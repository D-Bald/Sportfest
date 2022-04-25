defmodule SportfestWeb.StationLive.FormComponent do
  use SportfestWeb, :live_component

  alias Sportfest.Vorbereitung

  @impl true
  def update(%{station: station} = assigns, socket) do
    changeset = Vorbereitung.change_station(station)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:images, accept: ~w(.jpg .jpeg .png), max_entries: 5)} # NOCH FESTLEGEN WIE VIELE MAX
  end

  @impl true
  def handle_event("validate", %{"station" => station_params}, socket) do
    changeset =
      socket.assigns.station
      |> Vorbereitung.change_station(station_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :images, ref)}
  end

  def handle_event("save", %{"station" => station_params}, socket) do
    case uploaded_entries(socket, :images) do
      {[_|_] = entries, []} ->
        uploaded_files = for entry <- entries do
          file_ext = Path.extname(entry.client_name)
          consume_uploaded_entry(socket, entry, fn %{path: path} ->
            dest = Path.join(["priv/static/uploads", Path.basename(path <> file_ext)])
            File.cp!(path, dest)
            {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}
          end)
        end
        save_station(socket, socket.assigns.action, Map.put(station_params, "image_uploads", uploaded_files))

      _ ->
        save_station(socket, socket.assigns.action, station_params)
    end
  end

  defp save_station(socket, :edit, station_params) do
    # Lösche mögicherweise vorher hinzugefügte Fotos, damit diese nicht ungenutzt im uploads Ordner bleiben.
    if Map.has_key?(station_params, "image_uploads") do
      for img <- socket.assigns.station.image_uploads do
        File.rm!(Path.join("priv/static/", img))
      end
    end

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

  def error_to_string(:too_large), do: "Zu große Datei"
  def error_to_string(:too_many_files), do: "Zu viele Dateien"
  def error_to_string(:not_accepted), do: "Dieser Datei Typ wird nicht unterstützt"
end
