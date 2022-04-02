defmodule SportfestWeb.SchuelerLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Vorbereitung
  alias Sportfest.Vorbereitung.Schueler

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :schueler_collection, list_schueler())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Schueler")
    |> assign(:schueler, Vorbereitung.get_schueler!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Schueler")
    |> assign(:schueler, %Schueler{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Schueler")
    |> assign(:schueler, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    schueler = Vorbereitung.get_schueler!(id)
    {:ok, _} = Vorbereitung.delete_schueler(schueler)

    {:noreply, assign(socket, :schueler_collection, list_schueler())}
  end

  defp list_schueler do
    Vorbereitung.list_schueler()
  end
end
