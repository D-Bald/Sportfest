defmodule Sportfest2Web.SchuelerScoreboardLive.Index do
  use Sportfest2Web, :live_view

  alias Sportfest2.Ergebnisse
  alias Sportfest2.Ergebnisse.SchuelerScoreboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :schueler_scoreboards, list_schueler_scoreboards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Schueler scoreboard")
    |> assign(:schueler_scoreboard, Ergebnisse.get_schueler_scoreboard!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Neues Schueler scoreboard")
    |> assign(:schueler_scoreboard, %SchuelerScoreboard{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Schüler Scoreboards")
    |> assign(:schueler_scoreboard, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    schueler_scoreboard = Ergebnisse.get_schueler_scoreboard!(id)
    {:ok, _} = Ergebnisse.delete_schueler_scoreboard(schueler_scoreboard)

    {:noreply, assign(socket, :schueler_scoreboards, list_schueler_scoreboards())}
  end

  defp list_schueler_scoreboards do
    Ergebnisse.list_schueler_scoreboards()
  end
end
