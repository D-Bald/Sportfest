defmodule Sportfest2Web.StationLive.Index do
  use Sportfest2Web, :live_view

  alias Sportfest2.Vorbereitung
  alias Sportfest2.Vorbereitung.Station

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :stationen, list_stationen())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Station")
    |> assign(:station, Vorbereitung.get_station!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Station")
    |> assign(:station, %Station{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stationen")
    |> assign(:station, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    station = Vorbereitung.get_station!(id)
    {:ok, _} = Vorbereitung.delete_station(station)

    {:noreply, assign(socket, :stationen, list_stationen())}
  end

  defp list_stationen do
    Vorbereitung.list_stationen()
  end
end
