defmodule SportfestWeb.LeaderboardLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Vorbereitung
  alias Sportfest.Utils.ListItems

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()
    klassen_liste = Vorbereitung.list_klassen() |> Enum.sort_by(fn klasse -> Ergebnisse.scaled_class_score(klasse) end, :desc)
    schueler_liste = Vorbereitung.list_schueler() |> Enum.sort_by(fn s -> Ergebnisse.get_score_sum(s) end, :desc)

    jhg_klassen_map = klassen_liste
                      |> Enum.group_by(fn klasse -> klasse.jahrgang end)
                      |> Enum.into(%{})

    jhg_schueler_map = schueler_liste
                        |> Enum.group_by(fn schueler -> schueler.klasse.jahrgang end)
                        |> Enum.into(%{})

    stationen = Vorbereitung.list_stationen() |> Enum.sort_by(fn s -> s.name end, :asc)
    socket = assign(socket, klassen_liste: klassen_liste, schueler_liste: schueler_liste,
                      jhg_schueler_map: jhg_schueler_map, jhg_klassen_map: jhg_klassen_map, stationen: stationen)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({:score_created, score}, socket) do
    {:noreply, refresh_scores(socket, score)}
  end

  def handle_info({:score_updated, score}, socket) do
    {:noreply, refresh_scores(socket, score)}
  end

  def handle_info({:score_deleted, score}, socket) do
    {:noreply, refresh_scores(socket, score)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Leaderboard")
  end

  # Liste für alle Jahrgänge
  defp klassen_liste_aktualisieren(socket, klasse) do
    update(socket, :klassen_liste, fn klassen ->
      ListItems.replace_item_by_id_or_add(klassen, klasse)
      |> Enum.sort_by(fn k -> Ergebnisse.scaled_class_score(k) end, :desc)
    end)
  end

  # Für jahrgangsweise Filter
  defp jhg_klassen_map_aktualisieren(socket, klasse) do
    update(socket, :jhg_klassen_map,
      fn jhg_klassen_map ->
        %{jhg_klassen_map | klasse.jahrgang =>
          jhg_klassen_map[klasse.jahrgang]
          |> ListItems.replace_item_by_id_or_add(klasse)
          |> Enum.sort_by(fn k -> Ergebnisse.scaled_class_score(k) end, :desc)
          }
      end)
  end

  # Liste für alle Jahrgänge
  defp schueler_liste_aktualisieren(socket, schueler) do
    update(socket, :schueler_liste, fn schueler_list ->
      ListItems.replace_item_by_id_or_add(schueler_list, schueler)
      |> Enum.sort_by(fn s -> Ergebnisse.get_score_sum(s) end, :desc)
    end)
  end

  # Für jahrgangsweise Filter
  defp jhg_schueler_map_aktualisieren(socket, schueler) do
    jahrgang = schueler.klasse.jahrgang
    update(socket, :jhg_schueler_map,
      fn jhg_schueler_map ->
        %{jhg_schueler_map | jahrgang =>
        jhg_schueler_map[jahrgang]
          |> ListItems.replace_item_by_id_or_add(schueler)
          |> Enum.sort_by(fn s -> Ergebnisse.get_score_sum(s) end, :desc)
          }
      end)
  end

  defp refresh_scores(socket, score) do
    klasse = Vorbereitung.get_klasse!(score.klasse_id)
    socket = klassen_liste_aktualisieren(socket, klasse)
              |> jhg_klassen_map_aktualisieren(klasse)
    if not score.station.team_challenge do
      schueler = Vorbereitung.get_schueler!(score.schueler_id)
        schueler_liste_aktualisieren(socket, schueler)
        |> jhg_schueler_map_aktualisieren(schueler)
    else
      socket
    end
  end
end
