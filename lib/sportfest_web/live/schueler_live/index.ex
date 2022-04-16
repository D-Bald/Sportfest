defmodule SportfestWeb.SchuelerLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Vorbereitung
  alias Sportfest.Vorbereitung.Schueler

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:schueler_collection, list_schueler())
      |> allow_upload(:schueler_data, accept: ~w(.csv), max_entries: 10)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Schüler:in bearbeiten")
    |> assign(:schueler, Vorbereitung.get_schueler!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Schüler:in erstellen")
    |> assign(:schueler, %Schueler{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Schüler:innen")
    |> assign(:schueler, nil)
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :schueler_data, ref)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    schueler = Vorbereitung.get_schueler!(id)
    {:ok, _} = Vorbereitung.delete_schueler(schueler)

    {:noreply, assign(socket, :schueler_collection, list_schueler())}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    consume_uploaded_entries(socket, :schueler_data,
                              fn %{path: path}, _ ->
                                {:ok, Sportfest.Utils.CSVDataImports.add_schueler_from_csv(path)}
                              end)
    {:noreply, assign(socket, :schueler_collection, list_schueler())}
  end

  def error_to_string(:too_large), do: "Zu große Datei"
  def error_to_string(:not_accepted), do: "Dieser Datei Typ wird nicht unterstützt"

  defp list_schueler do
    Vorbereitung.list_schueler()
    |> Enum.sort_by(fn s -> s.name end, :asc)
    |> Enum.sort_by(fn s -> s.klasse end, :asc)
    |> Enum.sort_by(fn s -> s.jahrgang end, :asc)
  end
end
