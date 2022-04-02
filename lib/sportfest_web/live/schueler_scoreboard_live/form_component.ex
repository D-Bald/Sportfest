defmodule SportfestWeb.SchuelerScoreboardLive.FormComponent do
  use SportfestWeb, :live_component

  alias Sportfest.Ergebnisse

  @impl true
  def update(%{schueler_scoreboard: schueler_scoreboard} = assigns, socket) do
    changeset = Ergebnisse.change_schueler_scoreboard(schueler_scoreboard)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"schueler_scoreboard" => schueler_scoreboard_params}, socket) do
    changeset =
      socket.assigns.schueler_scoreboard
      |> Ergebnisse.change_schueler_scoreboard(schueler_scoreboard_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"schueler_scoreboard" => schueler_scoreboard_params}, socket) do
    save_schueler_scoreboard(socket, socket.assigns.action, schueler_scoreboard_params)
  end

  defp save_schueler_scoreboard(socket, :edit, schueler_scoreboard_params) do
    case Ergebnisse.update_schueler_scoreboard(socket.assigns.schueler_scoreboard, schueler_scoreboard_params) do
      {:ok, _schueler_scoreboard} ->
        {:noreply,
         socket
         |> put_flash(:info, "Schueler scoreboard updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_schueler_scoreboard(socket, :new, schueler_scoreboard_params) do
    case Ergebnisse.create_schueler_scoreboard(schueler_scoreboard_params) do
      {:ok, _schueler_scoreboard} ->
        {:noreply,
         socket
         |> put_flash(:info, "Schueler scoreboard created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
