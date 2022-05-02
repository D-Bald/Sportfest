defmodule SportfestWeb.LeaderboardLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()
    klassen = Vorbereitung.list_klassen() |> Enum.sort_by(fn klasse -> Ergebnisse.scaled_class_score(klasse) end, :desc)
    schueler = Vorbereitung.list_schueler() |> Enum.sort_by(fn s -> Ergebnisse.get_score_sum(s) end, :desc) |> Enum.take(20)
    stationen = Vorbereitung.list_stationen() |> Enum.sort_by(fn s -> s.name end, :asc)
    socket = assign(socket, schueler: schueler, klassen: klassen, stationen: stationen)

    {:ok, socket}
  end

  @impl true
  def handle_info({:score_created, score}, socket) do
    socket = klassen_liste_aktualisieren(Vorbereitung.get_klasse!(score.klasse_id), socket)
    socket = case score.station.team_challenge do
        false ->
          schueler_liste_aktualisieren(Vorbereitung.get_schueler!(score.schueler_id), socket)
        _ -> socket
      end

    {:noreply, socket}
  end

  def handle_info({:score_updated, score}, socket) do
    socket = klassen_liste_aktualisieren(Vorbereitung.get_klasse!(score.klasse_id), socket)
    socket = case score.station.team_challenge do
        false ->
          schueler_liste_aktualisieren(Vorbereitung.get_schueler!(score.schueler_id), socket)
        _ -> socket
      end

    {:noreply, socket}
  end

  def handle_info({:score_deleted, score}, socket) do
    socket = klassen_liste_aktualisieren(Vorbereitung.get_klasse!(score.klasse_id), socket)
    socket = case score.station.team_challenge do
        false ->
          schueler_liste_aktualisieren(Vorbereitung.get_schueler!(score.schueler_id), socket)
        _ -> socket
      end

    {:noreply, socket}
  end

  defp klassen_liste_aktualisieren(klasse, socket) do
    update(socket, :klassen, fn klassen ->
      List.replace_at(klassen, # Manual replacement because klassen is not tracked
                      Enum.find_index(klassen, fn k -> k.id == klasse.id end),
                      klasse)
      |> Enum.sort_by(fn klasse -> Ergebnisse.scaled_class_score(klasse) end, :desc)
    end)
  end

  defp schueler_liste_aktualisieren(schueler, socket) do
    update(socket, :schueler, fn schueler_list ->
      List.replace_at(schueler_list, # Manual replacement because klassen is not tracked
                      Enum.find_index(schueler_list, fn s -> s.id == schueler.id end),
                      schueler)
      |> Enum.sort_by(fn schueler -> Ergebnisse.get_score_sum(schueler) end, :desc)
      |> Enum.take(20)
    end)
  end
end
