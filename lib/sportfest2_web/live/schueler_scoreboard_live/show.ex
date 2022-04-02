defmodule Sportfest2Web.SchuelerScoreboardLive.Show do
  use Sportfest2Web, :live_view

  alias Sportfest2.Ergebnisse

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:schueler_scoreboard, Ergebnisse.get_schueler_scoreboard!(id))}
  end

  defp page_title(:show), do: "Show Schueler scoreboard"
  defp page_title(:edit), do: "Edit Schueler scoreboard"
end
