defmodule SportfestWeb.LeaderboardLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()
    jhg_klassen_map = Vorbereitung.list_klassen()
                      |> Enum.group_by(fn klasse -> String.first(klasse.name) end) # Workaround, da Jahrgang aus Versehen in schueler schema statt in klasse
                      |> Enum.map(fn {jahrgang, klassen_liste} ->
                          {jahrgang, Enum.sort_by(klassen_liste,  fn klasse -> Ergebnisse.scaled_class_score(klasse) end, :desc)}
                        end)
                      |> Enum.into(%{})

    jhg_schueler_map = Vorbereitung.list_schueler()
                        |> Enum.group_by(fn schueler -> schueler.jahrgang end)
                        |> Enum.map(fn {jahrgang, schueler_liste} ->
                            {jahrgang,
                              Enum.filter(schueler_liste, fn s -> s.aktiv end)
                              |> Enum.sort_by(fn s -> Ergebnisse.get_score_sum(s) end, :desc)}
                          end)
                        |> Enum.into(%{})

    stationen = Vorbereitung.list_stationen() |> Enum.sort_by(fn s -> s.name end, :asc)
    socket = assign(socket, jhg_schueler_map: jhg_schueler_map, jhg_klassen_map: jhg_klassen_map, stationen: stationen)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Leaderboard")
  end

  defp klassen_liste_aktualisieren(klasse, socket) do
    jahrgang = String.first(klasse.name)
    update(socket, :jhg_klassen_map,
      fn jhg_klassen_map ->
        %{jhg_klassen_map | jahrgang =>
          jhg_klassen_map[jahrgang]
          |> List.replace_at(# Manual replacement because klassen is not tracked
                      Enum.find_index(jhg_klassen_map[jahrgang], fn k -> k.id == klasse.id end),
                      klasse)
          |> Enum.sort_by(fn klasse -> Ergebnisse.scaled_class_score(klasse) end, :desc)
          }
      end)
  end

  defp schueler_liste_aktualisieren(schueler, socket) do
    jahrgang = schueler.jahrgang
    update(socket, :jhg_schueler_map,
      fn jhg_schueler_map ->
        %{jhg_schueler_map | jahrgang =>
        jhg_schueler_map[jahrgang]
          |> List.replace_at(# Manual replacement because klassen is not tracked
                      Enum.find_index(jhg_schueler_map[jahrgang], fn s -> s.id == schueler.id end),
                      schueler)
          |> Enum.sort_by(fn schueler -> Ergebnisse.get_score_sum(schueler) end, :desc)
          }
      end)
  end
end
