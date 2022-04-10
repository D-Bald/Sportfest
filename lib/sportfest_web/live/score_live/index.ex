defmodule SportfestWeb.ScoreLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Ergebnisse.Score
  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()

    #filter is set to All for each column
    filter = %{"station_id" => "All", "klasse_id" => "All"}

    socket = assign(socket, scores: list_scores(), rows: get_rows(), stationen: list_stationen(), klassen: list_klassen(), schueler: list_schueler(), filter: filter)
    {:ok, socket, temporary_assigns: [scores: [], rows: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Bearbeite Score")
    |> assign(:score, Ergebnisse.get_score!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Neuer Score")
    |> assign(:score, %Score{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Scores")
    |> assign(:score, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    score = Ergebnisse.get_score!(id)
    {:ok, _} = Ergebnisse.delete_score(score)

    {:noreply, assign(socket, :scores, list_scores())}
  end

  # reset filters : each col filter is set to "All"
  def handle_event("reset", _, socket) do
    rows = get_rows()
    filter =  %{station_id: "All", klasse_id: "All"}
    {:noreply, assign(socket, rows: rows, filter: filter)}
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
    {:noreply, assign(socket, rows: filter_rows, filter: new_filter)}
  end

  # handles clicks on different medals
  def handle_event("set_medaille", %{"score_id" => score_id, "medaille" => medaille}, socket) do
    with %Ergebnisse.Score{} = score <- Ergebnisse.get_score!(score_id) do
      case Ergebnisse.update_score(score, %{"medaille" => medaille}) do
        {:ok, _score} ->
          {:noreply,
           socket
           |> put_flash(:info, "Score updated successfully")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    end
  end

  @impl true
  def handle_info({:score_created, score}, socket) do
    {:noreply,
           socket
           |> update(:scores, fn scores -> [score | scores] end)
           |> update(:rows, fn scores -> [score | scores] end)}
  end

  @impl true
  def handle_info({:score_updated, score}, socket) do
    {:noreply,
           socket
           |> update(:scores, fn scores -> [score | scores] end)
           |> update(:rows, fn scores -> [score | scores] end)}
  end

  defp list_scores do
    Ergebnisse.list_scores()
  end

  defp list_stationen do
    Vorbereitung.list_stationen()
  end

  defp list_klassen do
    Vorbereitung.list_klassen()
  end

  defp list_schueler do
    Vorbereitung.list_schueler()
  end

  ###################################
  ### COPY PASTE FROM https://github.com/imartinat/phoenix_live_view_tablefilter/blob/master/lib/demo_web/live/table_filter/search_filter.ex
  ###################################

  def selected?(filter,key,value) do
    case Map.has_key?(filter, key) do
      true -> filter[key]==value
      false -> false
      end
    end

  # get the list of values from rows for the column filter
  def get_list(rows, filter) do
    list =
      Enum.map(rows, fn r -> Map.get(r,String.to_atom(filter)) end)
      |> Enum.uniq()
      |> Enum.sort()
    ["All" | list]
  end

  # get the list of values from rows for each column of col_list
  def select_list(col_list,rows) do
    Enum.map(col_list, fn c ->
      { c, get_list(rows,c) }
      end)
    |> Enum.into(%{})
  end

  def get_filter_list do
    ["station","klasse"]
  end

  def get_cols do
    #should get the cols from a database or a json config file
    [ {"station", "Station"}, {"klasse", "Klasse"}, {"schueler", "Schüler:in"}, {"medaille", "Medaille"} ]
  end

  def get_rows do
    Ergebnisse.list_scores()
  end

  def get_filter_rows(filter) do
    Ergebnisse.query_table(filter)
  end
end
