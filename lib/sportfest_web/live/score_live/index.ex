defmodule SportfestWeb.ScoreLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()

    # Filter für Stationen und Klassen wird auf None gesetzt
    filter = %{"station_id" => "None", "klasse_id" => "None"}

    socket = assign_defaults(session, socket)
              |> assign(:page_title, "Scores")
              |> assign(klassen: Vorbereitung.list_klassen(),
                        stationen: Vorbereitung.list_stationen(),
                        ausgewählte_station: nil, # Assign aktuelle station, damit die Bedingungen für Medaillen gelesen werden können
                        filter: filter,
                        scores: [])
              |> assign(:reload_id, station_klasse_id_sum(filter))

    {:ok, socket, temporary_assigns: [scores: []]}
  end

  @impl true
  # reset filters : each col filter is set to "All"
  def handle_event("reset", _, socket) do
    filter =  %{"station_id" => "None", "klasse_id" => "None"}
    {:noreply, assign(socket, scores: [], filter: filter, ausgewählte_station: nil, reload_id: 0)}
  end

  # filter : add new filter to the socket
  # unless the filter is All, in this case previous filter for this column is deleted
  def handle_event("filter", filter, socket) do
    filter = Map.delete(filter, "_target") # Keine Ahnung, wo das her kommt, stört aber

    new_filter = socket.assigns.filter |> Map.merge(filter)
    {filter_rows, ausgewaehlte_station} = cond do
      Enum.any?(Map.values(new_filter), &match?("None", &1)) -> {[], nil}
      true -> {get_filter_rows(new_filter), get_selected_station_from_filter(new_filter)}
    end

    {:noreply, assign(socket, scores: filter_rows, filter: new_filter,
                      ausgewählte_station: ausgewaehlte_station,
                      reload_id: station_klasse_id_sum(new_filter))}
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
           |> update(:scores, fn scores -> [score | scores] end)}
  end

  @impl true
  def handle_info({:score_deleted, score}, socket) do
    {:noreply,
            socket
            |> update(:scores, fn scores ->
                List.delete(scores, score) end)}
  end

  # Gibt zurück, ob im gegebenen `filter` der gegebene `key` mit dem erwarteten `value` verknüpft ist.
  def selected?(filter,key,value) do
    case Map.has_key?(filter, key) do
      true  -> filter[key]==value
      false -> false
      end
    end

  # Gibt zurück, ob im gegebenen `filter` der gegebene `key` mit dem erwarteten `value` verknüpft ist oder leer ist.
  def selected_or_empty?(filter, key, value) do
    case Map.has_key?(filter, key) do
      true  -> filter[key]==value
      false -> true
      end
  end

  def station_klasse_id_sum(%{"station_id" => "None", "klasse_id" => "None"}) do
    0
  end
  def station_klasse_id_sum(%{"station_id" => station_id, "klasse_id" => "None"}) do
    String.to_integer(station_id)
  end
  def station_klasse_id_sum(%{"station_id" => "None", "klasse_id" => klasse_id}) do
    String.to_integer(klasse_id)
  end
  def station_klasse_id_sum(%{"station_id" => station_id, "klasse_id" => klasse_id}) do
    String.to_integer(station_id) + String.to_integer(klasse_id)
  end


  @doc """
  Holt die im gegebenen `filter` unter `station_id` angegebene Station aus der Datenbank.
  Gibt `nil` zurück, falls `station_id` nicht im Filter enthalten oder `"None"`

  ## Examples
      iex> get_selected_station_from_filter(%{"station_id" => "1"})
      %Station{}

      iex> get_selected_station_from_filter(%{"station_id" => "None"})
      nil
  """
  def get_selected_station_from_filter(filter) do
    case Map.has_key?(filter, "station_id") and filter["station_id"] != "None" do
      true -> Vorbereitung.get_station!(filter["station_id"])
      false -> nil
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
end
