defmodule SportfestWeb.SchuelerLive.Show do
  use SportfestWeb, :live_view

  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @spec handle_params(map, any, %{
          :assigns => atom | %{:live_action => :edit | :show, optional(any) => any},
          optional(any) => any
        }) :: {:noreply, map}
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:schueler, Vorbereitung.get_schueler!(id))}
  end

  defp page_title(:show), do: "Schüler:in zeigen"
  defp page_title(:edit), do: "Schüler:in bearbeiten"
end
