defmodule SportfestWeb.KlassenScoreboardLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Ergebnisse.KlassenScoreboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :klassen_scoreboards, list_klassen_scoreboards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Klassen scoreboard")
    |> assign(:klassen_scoreboard, Ergebnisse.get_klassen_scoreboard!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Klassen scoreboard")
    |> assign(:klassen_scoreboard, %KlassenScoreboard{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Klassen scoreboards")
    |> assign(:klassen_scoreboard, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    klassen_scoreboard = Ergebnisse.get_klassen_scoreboard!(id)
    {:ok, _} = Ergebnisse.delete_klassen_scoreboard(klassen_scoreboard)

    {:noreply, assign(socket, :klassen_scoreboards, list_klassen_scoreboards())}
  end

  defp list_klassen_scoreboards do
    Ergebnisse.list_klassen_scoreboards()
  end
end
