defmodule SportfestWeb.KlasseLive.Show do
  use SportfestWeb, :live_view

  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Vorbereitung.subscribe()

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    klasse = Vorbereitung.get_klasse!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:klasse, klasse)
     |> assign(:schueler, Vorbereitung.list_schueler_by_klasse(klasse))
    }
  end

  @impl true
  # Ändert den "aktiv" Status eines/einer Schueler:in, wenn die Checkbox geändert wird.
  def handle_event("toggle_aktiv", %{"schueler_id" => schueler_id}, socket) do
    with schueler = Vorbereitung.get_schueler!(schueler_id) do
      case Vorbereitung.update_schueler(schueler, %{"aktiv" => not schueler.aktiv}) do
        {:ok, _schueler} ->
          {:noreply,
           socket
           |> put_flash(:info, "Status erfolgreich geändert")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    end
  end

  @impl true
  def handle_info({:schueler_created, schueler}, socket) do
    {:noreply,
           socket
           |> update(:schueler, fn schueler_list -> [schueler | schueler_list] end)}
  end

  @impl true
  def handle_info({:schueler_updated, schueler}, socket) do
    {:noreply,
           socket
           |> update(:schueler, fn schueler_list ->
                List.replace_at(schueler_list, # Manual replacement, since schueler_list is somehow not tracked by liveview
                  Enum.find_index(schueler_list, fn s -> s.id == schueler.id end),
                  schueler) end )}
  end

  @impl true
  def handle_info({:schueler_deleted, schueler}, socket) do
    {:noreply,
           socket
           |> update(:schueler, fn schueler_list ->
                List.delete(schueler_list, schueler) end)}
  end

  defp page_title(:show), do: "Klasse zeigen"
  defp page_title(:edit), do: "Klasse bearbeiten"
end
