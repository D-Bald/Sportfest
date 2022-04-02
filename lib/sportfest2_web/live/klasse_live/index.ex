defmodule Sportfest2Web.KlasseLive.Index do
  use Sportfest2Web, :live_view

  alias Sportfest2.Vorbereitung
  alias Sportfest2.Vorbereitung.Klasse

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :klassen, list_klassen())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Klasse")
    |> assign(:klasse, Vorbereitung.get_klasse!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Klasse")
    |> assign(:klasse, %Klasse{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Klassen")
    |> assign(:klasse, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    klasse = Vorbereitung.get_klasse!(id)
    {:ok, _} = Vorbereitung.delete_klasse(klasse)

    {:noreply, assign(socket, :klassen, list_klassen())}
  end

  defp list_klassen do
    Vorbereitung.list_klassen()
  end
end
