defmodule SportfestWeb.StationLive.Show do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()

    socket = assign(socket, klassen: list_klassen(), schueler: list_schueler())

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    station = Vorbereitung.get_station!(id)
    #filter is set to All for each column
    filter = %{"station_id" => station.id, "klasse_id" => "All"}

    socket =  socket
              |> assign(:page_title, page_title(socket.assigns.live_action))
              |> assign(:station, station)
              |> assign(:filter, filter)

    socket = assign(socket, :scores, get_scores(socket))

    {:noreply,  socket}
  end

  @impl true
  # reset filters : each col filter is set to "All"
  def handle_event("reset", _, socket) do
    scores = get_scores(socket)
    filter =  %{"station_id" => socket.assigns.station.id, "klasse_id" => "All"}
    {:noreply, assign(socket, scores: scores, filter: filter)}
  end

  # filter : add new filter to the socket
  # unless the filter is All, in this case previous filter for this column is deleted
  def handle_event("filter", filter, socket) do
    filter = Map.delete(filter, "_target") # Keine Ahnung, wo das her kommt, stört aber
    IO.inspect(filter)
    key = hd(Map.keys(filter))
    val = filter[key]
    new_filter = case val do
      "All"     -> socket.assigns.filter |> Map.delete(key)
        _       -> socket.assigns.filter |> Map.merge(filter)
    end

    filter_rows = get_filter_rows(new_filter)
    {:noreply, assign(socket, scores: filter_rows, filter: new_filter)}
  end

  # handles clicks on different medals
  def handle_event("set_medaille", %{"score_id" => score_id, "medaille" => medaille}, socket) do
    with score = Ergebnisse.get_score!(score_id) do
      case Ergebnisse.update_score(score, %{"medaille" => medaille}) do
        {:ok, _score} ->
          {:noreply,
            socket
            |> put_flash(:info, "Medaille erfolgreich hinzugefügt")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    end
  end

  @impl true
  def handle_info({:score_created, score}, socket) do
    {:noreply,
            socket
            |> update(:scores, fn scores -> [score | scores] end)}
  end

  @impl true
  def handle_info({:score_updated, score}, socket) do
    {:noreply,
            socket
            |> update(:scores, fn scores ->
                List.replace_at(scores, # Manual replacement, since the scores cannot be tracked by liveview due to filters
                  Enum.find_index(scores, fn s -> s.id == score.id end),
                  score) end )}
  end

  @impl true
  def handle_info({:score_deleted, score}, socket) do
    {:noreply,
            socket
            |> update(:scores, fn scores ->
                List.delete(scores, score) end)}
  end

  def selected?(filter,key,value) do
    case Map.has_key?(filter, key) do
      true -> filter[key]==value
      false -> false
      end
    end

  def selected_or_empty?(filter, key, value) do
    case Map.has_key?(filter, key) do
      true -> filter[key]==value
      false -> true
      end
  end

  def img_size(score, medaille) do
    case score.medaille == medaille do
      true  -> 70
      false -> 40
    end
  end

  defp list_klassen do
    Vorbereitung.list_klassen()
  end

  defp list_schueler do
    Vorbereitung.list_schueler()
  end

  # Wrapper für create_or_skip_score/2
  defp get_scores(socket) do
    station = socket.assigns.station
    cond do
      station.team_challenge ->
        for klasse <- socket.assigns.klassen do
          Ergebnisse.create_or_skip_score(station, klasse)
        end
      true ->
        for schueler <- socket.assigns.schueler do
          Ergebnisse.create_or_skip_score(station, schueler)
        end
    end

    get_filter_rows(%{"station_id" => station.id, "klasse_id" => "All"})
  end

  # Datenbankergebnisse mit gegebenem Filter sortiert nach Schüler-Name, Klasse und Station
  defp get_filter_rows(filter) do
    ergebnisse = Ergebnisse.query_table(filter)
    ergebnisse_single_sorted =
      ergebnisse
      |> Enum.filter(fn score -> not score.station.team_challenge end)
      |> Enum.filter(fn score -> score.schueler.aktiv end)
      |> Enum.sort_by(fn score -> score.schueler.name end, :asc)
    ergebnisse_team = Enum.filter(ergebnisse, fn score -> score.station.team_challenge end)

    ergebnisse_single_sorted ++ ergebnisse_team
    |> Enum.sort_by(fn score -> score.klasse.name end, :asc)
    |> Enum.sort_by(fn score -> score.station.name end, :asc)
  end

  defp page_title(:show), do: "Station zeigen"
  defp page_title(:edit), do: "Station bearbeiten"
end
