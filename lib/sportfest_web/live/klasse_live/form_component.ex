defmodule SportfestWeb.KlasseLive.FormComponent do
  use SportfestWeb, :live_component

  alias Sportfest.Vorbereitung

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
         |> put_flash(:info, "Klasse erfolgreich aktualisiert")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_klasse(socket, :new, jahrgang_params) do
    case Vorbereitung.create_klasse(jahrgang_params) do
      {:ok, _klasse} ->
        {:noreply,
         socket
         |> put_flash(:info, "Klasse erfolgreich erstellt")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
