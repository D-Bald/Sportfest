defmodule SportfestWeb.StationLive.Show do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()

    socket = assign(socket, klassen: Vorbereitung.list_klassen(), schueler: Vorbereitung.list_schueler())

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    station = Vorbereitung.get_station!(id)
    #filter is set to All for each column
    filter = %{"station_id" => station.id}

    socket =  socket
              |> assign(:page_title, page_title(socket.assigns.live_action))
              |> assign(:station, station)
              |> assign(:filter, filter)

    socket = assign(socket, :scores, [])#get_scores(socket))

    {:noreply,  socket}
  end

  @impl true
  # reset filters : each col filter is set to "All"
  def handle_event("reset", _, socket) do
    # scores = get_scores(socket)
    filter =  %{"station_id" => socket.assigns.station.id, "klasse_id" => "None"}
    {:noreply, assign(socket, scores: [], filter: filter)}
  end

  # filter : add new filter to the socket
  # unless the filter is All, in this case previous filter for this column is deleted
  def handle_event("filter", filter, socket) do
    filter = Map.delete(filter, "_target") # Keine Ahnung, wo das her kommt, stört aber
    IO.inspect(filter)
    key = hd(Map.keys(filter))

    new_filter = socket.assigns.filter |> Map.merge(filter)
    filter_rows = case filter[key] do
      "None" -> []
      _ -> get_filter_rows(new_filter)
    end

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
  # Ändert den "aktiv" Status eines/einer Schueler:in, wenn die Checkbox geändert wird.
  def handle_event("delete_img", %{"img_path" => img_path}, socket) do
    station = socket.assigns.station
    case Vorbereitung.update_station(station, %{"image_uploads" =>
      case List.delete(station.image_uploads, img_path) do
        [] -> nil
        list -> list
      end}) do
      {:ok, _station} ->
        {:noreply,
          socket
          |> put_flash(:info, "Bild erfolgreich gelöscht")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
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
