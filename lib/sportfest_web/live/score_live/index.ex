defmodule SportfestWeb.ScoreLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Ergebnisse.Score

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()
    socket = assign(socket, :scores, list_scores())
    {:ok, socket, temporary_assigns: [scores: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Score")
    |> assign(:score, Ergebnisse.get_score!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Score")
    |> assign(:score, %Score{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scores")
    |> assign(:score, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    score = Ergebnisse.get_score!(id)
    {:ok, _} = Ergebnisse.delete_score(score)

    {:noreply, assign(socket, :scores, list_scores())}
  end

  @impl true
  def handle_info({:score_created, score}, socket) do
    {:noreply, update(socket, :scores, fn scores -> [score | scores] end)}
  end

  @impl true
  def handle_info({:score_updated, score}, socket) do
    {:noreply, update(socket, :scores, fn scores -> [score | scores] end)}
  end

  defp list_scores do
    Ergebnisse.list_scores()
  end
end
