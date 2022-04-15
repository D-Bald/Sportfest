defmodule SportfestWeb.ScoreLive.FormComponent do
  use SportfestWeb, :live_component

  alias Sportfest.Ergebnisse

  @impl true
  def update(%{score: score} = assigns, socket) do
    changeset = Ergebnisse.change_score(score)
    socket =  cond do
                Map.has_key?(changeset.data, "station") ->
                                                          case changeset.data.station.team_challenge do
                                                            true ->
                                                              socket
                                                              |> assign(:team_challenge, true)
                                                              |> assign(:listofowners, Sportfest.Vorbereitung.list_klassen())
                                                            false ->
                                                              socket
                                                              |> assign(:team_challenge, false)
                                                              |> assign(:listofowners, Sportfest.Vorbereitung.list_schueler())
                                                          end
                true                                    ->
                                                          socket
                                                          |> assign(:team_challenge, false)
                                                          |> assign(:listofowners, Sportfest.Vorbereitung.list_schueler())
              end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:stationen, Sportfest.Vorbereitung.list_stationen_for_dropdown())
    }
  end

  @impl true
  def handle_event("validate", %{"score" => score_params}, socket) do
    changeset =
      socket.assigns.score
      |> Ergebnisse.change_score(score_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"score" => score_params}, socket) do
    save_score(socket, socket.assigns.action, score_params)
  end

  defp save_score(socket, :edit, score_params) do
    case Ergebnisse.update_score(socket.assigns.score, score_params) do
      {:ok, _score} ->
        {:noreply,
         socket
         |> put_flash(:info, "Score erfolreich aktualisiert")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_score(socket, :new, score_params) do
    case Ergebnisse.create_score(score_params) do
      {:ok, _score} ->
        {:noreply,
         socket
         |> put_flash(:info, "Score erfolgreich erstellt")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
