defmodule SportfestWeb.LeaderboardLive.Index do
  use SportfestWeb, :live_view

  alias Sportfest.Ergebnisse
  alias Sportfest.Vorbereitung

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Ergebnisse.subscribe()
    klassen = Vorbereitung.list_klassen() |> Enum.sort_by(fn klasse -> Ergebnisse.scaled_class_score(klasse) end, :desc)
    socket = assign(socket, page_title: "Leaderboard", schueler: Vorbereitung.list_schueler(), klassen: klassen)

    {:ok, socket}
  end

  @impl true
  def handle_info({:score_created, score}, socket) do
    klassen_liste_aktualisieren(Vorbereitung.get_klasse!(score.klasse_id), socket)
  end

  def handle_info({:score_updated, score}, socket) do
    klassen_liste_aktualisieren(Vorbereitung.get_klasse!(score.klasse_id), socket)
  end

  def handle_info({:score_deleted, score}, socket) do
    klassen_liste_aktualisieren(Vorbereitung.get_klasse!(score.klasse_id), socket)
  end

  defp klassen_liste_aktualisieren(klasse, socket) do
    {:noreply,
           socket
           |> update(:klassen, fn klassen ->  List.replace_at(klassen, # Manual replacement because klassen is not tracked
                                                  Enum.find_index(klassen, fn s -> s.id == klasse.id end),
                                                  klasse)
                                              |> Enum.sort_by(fn klasse -> Ergebnisse.scaled_class_score(klasse) end, :desc) end)}
  end
end
