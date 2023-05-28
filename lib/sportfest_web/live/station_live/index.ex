defmodule SportfestWeb.StationLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Vorbereitung
  alias Sportfest.Vorbereitung.Station

  @impl true
  def mount(_params, session, socket) do
    {:ok,
      assign_defaults(session, socket)
      |> assign(:stationen, Vorbereitung.list_stationen())
      |> assign(:stationen, Vorbereitung.list_stationen())
      # Bei mehreren CSV kommt es vor, dass in der Datenbank zwei Schüler:innen mit der
      # gleichen ID erstellt werden => max_entries: 1
      |> allow_upload(:stationen_data, accept: ~w(.csv), max_entries: 1)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    station = Vorbereitung.get_station!(id)
    socket
    |> assign(:page_title, "Bearbeite #{station.name}")
    |> assign(:station, station)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Station erstellen")
    |> assign(:station, %Station{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Stationen")
    |> assign(:station, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    station = Vorbereitung.get_station!(id)
    {:ok, _} = Vorbereitung.delete_station(station)

    # Lösche mögicherweise vorher hinzugefügte Fotos, damit diese nicht ungenutzt im uploads Ordner bleiben.
    if station.image_uploads do
      for img <- station.image_uploads do
        File.rm!(Path.join("priv/static/", img))
      end
    end

    {:noreply, assign(socket, :stationen, Vorbereitung.list_stationen())}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :stationen_data, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    with {[_|_] = entries, []} <- uploaded_entries(socket, :stationen_data) do
      for entry <- entries do
        consume_uploaded_entry(socket, entry, fn %{path: path} ->
          {:ok, Sportfest.Utils.CSVData.import_stationen_from_csv(path)}
        end)
      end
    end

    {:noreply, assign(socket, :stationen, Vorbereitung.list_stationen())}
  end

  def error_to_string(:too_large), do: "Zu große Datei"
  def error_to_string(:too_many_files), do: "Zu viele Dateien"
  def error_to_string(:not_accepted), do: "Dieser Datei Typ wird nicht unterstützt"
end
