defmodule SportfestWeb.ScoreLive.Show do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:score, Ergebnisse.get_score!(id))}
  end

  defp page_title(:show), do: "Show Score"
  defp page_title(:edit), do: "Edit Score"
end
