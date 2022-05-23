defmodule SportfestWeb.StationLive.Show do
  use SportfestWeb, :live_view

  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, session, socket) do

    socket = assign_defaults(session, socket)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    station = Vorbereitung.get_station!(id)

    socket =  socket
              |> assign(:page_title, page_title(socket.assigns.live_action, station))
              |> assign(:station, station)

    {:noreply,  socket}
  end

  @impl true
  # reset filters : each col filter is set to "All"
  def handle_event("reset", _, socket) do
    filter =  %{"station_id" => socket.assigns.station.id, "klasse_id" => "None"}
    {:noreply, assign(socket, scores: [], filter: filter)}
  end

  @impl true
  # Ändert den "aktiv" Status eines/einer Schueler:in, wenn die Checkbox geändert wird.
  def handle_event("delete_img", %{"img_path" => img_path}, socket) do
    station = socket.assigns.station
    case Vorbereitung.update_station(station, %{"image_uploads" =>
      case List.delete(station.image_uploads, img_path) do
        [] -> nil
        list -> list
      end}) do
      {:ok, _station} ->
        {:noreply,
          socket
          |> put_flash(:info, "Bild erfolgreich gelöscht")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp page_title(:show, station), do: "#{station.name}"
  defp page_title(:edit, station), do: "Bearbeite #{station.name}"
end
