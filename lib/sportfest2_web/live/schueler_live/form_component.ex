defmodule Sportfest2Web.SchuelerLive.FormComponent do
  use Sportfest2Web, :live_component

  alias Sportfest2.Vorbereitung

  @impl true
  def update(%{schueler: schueler} = assigns, socket) do
    changeset = Vorbereitung.change_schueler(schueler)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:klassen, Sportfest2.Vorbereitung.list_klassen_for_dropdown())
    }
  end

  @impl true
  def handle_event("validate", %{"schueler" => schueler_params}, socket) do
    changeset =
      socket.assigns.schueler
      |> Vorbereitung.change_schueler(schueler_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"schueler" => schueler_params}, socket) do
    save_schueler(socket, socket.assigns.action, schueler_params)
  end

  defp save_schueler(socket, :edit, schueler_params) do
    case Vorbereitung.update_schueler(socket.assigns.schueler, schueler_params) do
      {:ok, _schueler} ->
        {:noreply,
         socket
         |> put_flash(:info, "Schueler updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_schueler(socket, :new, %{"klasse_id" => klasse_id} = schueler_params) do
    klasse = Sportfest2.Vorbereitung.get_klasse!(klasse_id)

    case Vorbereitung.create_schueler(klasse, schueler_params) do
      {:ok, _schueler} ->
        {:noreply,
         socket
         |> put_flash(:info, "Schueler created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
