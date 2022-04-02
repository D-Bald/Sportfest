defmodule Sportfest2Web.KlasseLive.FormComponent do
  use Sportfest2Web, :live_component

  alias Sportfest2.Vorbereitung

  @impl true
  def update(%{klasse: klasse} = assigns, socket) do
    changeset = Vorbereitung.change_klasse(klasse)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"klasse" => klasse_params}, socket) do
    changeset =
      socket.assigns.klasse
      |> Vorbereitung.change_klasse(klasse_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"klasse" => klasse_params}, socket) do
    save_klasse(socket, socket.assigns.action, klasse_params)
  end

  defp save_klasse(socket, :edit, klasse_params) do
    case Vorbereitung.update_klasse(socket.assigns.klasse, klasse_params) do
      {:ok, _klasse} ->
        {:noreply,
         socket
         |> put_flash(:info, "Klasse updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_klasse(socket, :new, klasse_params) do
    case Vorbereitung.create_klasse(klasse_params) do
      {:ok, _klasse} ->
        {:noreply,
         socket
         |> put_flash(:info, "Klasse created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
