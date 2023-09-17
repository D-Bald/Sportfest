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
              |> assign(klassen: Vorbereitung.list_klassen(%{preloads: false}), # TODO: Statt list_klassen mit preloads: false einfach eine neue Funktoni mit DTO mit nur benötigten Daten.
                        stationen: Vorbereitung.list_stationen(), # TODO: Hier reichen Stationsnamen. Alle anderen Infos müssen nicht in den Socket => abgespeckten API Call einrichten
                        ausgewählte_station: nil, # Assign aktuelle station, damit die Bedingungen für Medaillen gelesen werden können
                        filter: filter,
                        scores: [])
              |> assign(:reload_id, station_klasse_id_sum(filter)) # Id, um bei Änderung des Filters alle Scores neu zu holen.

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

    {_, ausgewaehlte_station} = get_selected_station(new_filter) # nil darf als ausgewählte station in die assigns

    filter_rows = cond do
      Enum.any?(Map.values(new_filter), &match?("None", &1)) -> []
      true -> get_filter_rows(new_filter)
    end

    {:noreply, assign(socket, scores: filter_rows, filter: new_filter,
                      ausgewählte_station: ausgewaehlte_station,
                      reload_id: station_klasse_id_sum(new_filter))}
  end

  # handles clicks on different medals
  def handle_event("toggle_medaille", %{"score_id" => score_id, "medaille" => target_medaille}, socket) do
    target_medaille_atom = String.to_existing_atom(target_medaille)
    with score = Ergebnisse.get_score!(score_id) do
      update_medaille = case score.medaille do
        ^target_medaille_atom -> :leer
        _ -> target_medaille_atom
      end
      case Ergebnisse.update_score(score, %{"medaille" => update_medaille}) do

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
    evaluate_if_affects_applied_filter(
      socket,
      score,
      {:noreply, socket |> update(:scores, fn scores -> [score | scores] end)},
      {:noreply, socket})
  end

  @impl true
  def handle_info({:score_updated, score}, socket) do
    evaluate_if_affects_applied_filter(
      socket,
      score,
      {:noreply, socket |> update(:scores, fn scores -> [score | scores] end)},
      {:noreply, socket})
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

  # Berechnet eine ID anhand der ausgewählten Station und Klasse im Filter.
  # Die ID verwendet live view, um bei Änderung das Element, das damit dekoriert wird, neu zu laden.
  # So kann bei einem Filter Event die ganze Score Liste neu geladen werden, obwohl der `phx-update` Wert `prepend` ist.
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
      iex> get_selected_station(%{"station_id" => "1"})
      %Station{}

      iex> get_selected_station(%{"station_id" => "None"})
      nil
  """
  def get_selected_station(filter) do
    case Map.has_key?(filter, "station_id") and filter["station_id"] != "None" do
      true -> {:ok, Vorbereitung.get_station!(filter["station_id"])}
      false -> {:error, nil}
    end
  end

  defp get_selected_station_id(filter) do
    case Map.has_key?(filter, "station_id") and filter["station_id"] != "None" do
      true -> {:ok, String.to_integer(filter["station_id"])}
      false -> {:error, nil}
    end
  end

  defp get_selected_klasse_id(filter) do
    case Map.has_key?(filter, "klasse_id") and filter["klasse_id"] != "None" do
      true -> {:ok, String.to_integer(filter["klasse_id"])}
      false -> {:error, nil}
    end
  end

  # Event soll auf der Scoreliste nur dann ausgelöst werden,
  # wenn der geupdatete/erstellte Score zur ausgewählten Klasse und Station gehört.
  defp evaluate_if_affects_applied_filter(socket, score, expr, else_expr) do
    with  {:ok, klasse_id} <- get_selected_klasse_id(socket.assigns.filter),
          {:ok, station_id} <- get_selected_station_id(socket.assigns.filter) do
          if score.klasse.id == klasse_id
            and score.station.id == station_id do
              expr
          else
              else_expr
          end
    else
      {:error, nil} -> else_expr
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
