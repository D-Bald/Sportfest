defmodule Sportfest2Web.KlassenScoreboardLive.FormComponent do
  use Sportfest2Web, :live_component

  alias Sportfest2.Ergebnisse

  @impl true
  def update(%{klassen_scoreboard: klassen_scoreboard} = assigns, socket) do
    changeset = Ergebnisse.change_klassen_scoreboard(klassen_scoreboard)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"klassen_scoreboard" => klassen_scoreboard_params}, socket) do
    changeset =
      socket.assigns.klassen_scoreboard
      |> Ergebnisse.change_klassen_scoreboard(klassen_scoreboard_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"klassen_scoreboard" => klassen_scoreboard_params}, socket) do
    save_klassen_scoreboard(socket, socket.assigns.action, klassen_scoreboard_params)
  end

  defp save_klassen_scoreboard(socket, :edit, klassen_scoreboard_params) do
    case Ergebnisse.update_klassen_scoreboard(socket.assigns.klassen_scoreboard, klassen_scoreboard_params) do
      {:ok, _klassen_scoreboard} ->
        {:noreply,
         socket
         |> put_flash(:info, "Klassen scoreboard updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_klassen_scoreboard(socket, :new, klassen_scoreboard_params) do
    case Ergebnisse.create_klassen_scoreboard(klassen_scoreboard_params) do
      {:ok, _klassen_scoreboard} ->
        {:noreply,
         socket
         |> put_flash(:info, "Klassen scoreboard created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
