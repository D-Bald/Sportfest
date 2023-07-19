defmodule SportfestWeb.LeaderboardLive.Station do
  use SportfestWeb, :live_view

  alias Sportfest.Vorbereitung
  alias Sportfest.Ergebnisse
  alias Sportfest.Utils.ListItems

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    station = Vorbereitung.get_station!(id)

    scores = Ergebnisse.query_table(%{"station_id" => station.id, "klasse_id" => "All"})

    klassen = Vorbereitung.list_klassen() |> Ergebnisse.sort(:klasse, station)
    socket =  socket
              |> assign(:station, station)

    socket = assign(socket, scores: scores, klassen: klassen)

    {:noreply,  socket}
  end

  @impl true
  def handle_info({:score_created, score}, socket) do
    socket = klassen_liste_aktualisieren(Vorbereitung.get_klasse!(score.klasse_id), socket)

    {:noreply, socket}
  end

  def handle_info({:score_updated, score}, socket) do
    socket = klassen_liste_aktualisieren(Vorbereitung.get_klasse!(score.klasse_id), socket)

    {:noreply, socket}
  end

  def handle_info({:score_deleted, score}, socket) do
    socket = klassen_liste_aktualisieren(Vorbereitung.get_klasse!(score.klasse_id), socket)

    {:noreply, socket}
  end

  defp klassen_liste_aktualisieren(klasse, socket) do
    update(socket, :klassen, fn klassen ->
      ListItems.replace_item_by_id_or_add(klassen, klasse)
      |> Ergebnisse.sort(:klasse, socket.assigns.station)
    end)
  end
end
