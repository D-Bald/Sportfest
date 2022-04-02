defmodule SportfestWeb.StationLive.FormComponent do
  use SportfestWeb, :live_component

  alias Sportfest.Vorbereitung

  @impl true
  def update(%{station: station} = assigns, socket) do
    changeset = Vorbereitung.change_station(station)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"station" => station_params}, socket) do
    changeset =
      socket.assigns.station
      |> Vorbereitung.change_station(station_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"station" => station_params}, socket) do
    save_station(socket, socket.assigns.action, station_params)
  end

  defp save_station(socket, :edit, station_params) do
    case Vorbereitung.update_station(socket.assigns.station, station_params) do
      {:ok, _station} ->
        {:noreply,
         socket
         |> put_flash(:info, "Station updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_station(socket, :new, station_params) do
    case Vorbereitung.create_station(station_params) do
      {:ok, _station} ->
        {:noreply,
         socket
         |> put_flash(:info, "Station created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
