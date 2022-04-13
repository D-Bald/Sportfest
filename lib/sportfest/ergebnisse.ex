defmodule Sportfest.Ergebnisse do
  @moduledoc """
  The Ergebnisse context.
  """

  import Ecto.Query, warn: false
  alias Sportfest.Repo

  alias Sportfest.Ergebnisse.Score
  alias Sportfest.Vorbereitung.{Station, Klasse, Schueler}

  @doc """
  Returns the list of scores.

  ## Examples

      iex> list_scores()
      [%Score{}, ...]

  """
  def list_scores do
    Score
    |> Ecto.Query.preload([klasse: [scores: [:station]], schueler: [scores: [:station]], station: []])
    |> Ecto.Query.order_by([s], desc: s.id)
    |> Repo.all()
  end

  @doc """
  Gets a single score.

  Raises `Ecto.NoResultsError` if the Score does not exist.

  ## Examples

      iex> get_score!(123)
      %Score{}

      iex> get_score!(456)
      ** (Ecto.NoResultsError)

  """
  def get_score!(id) do
    Score
    |> Ecto.Query.preload([klasse: [scores: [:station]], schueler: [scores: [:station]], station: []])
    |> Repo.get!(id)
  end

   @doc """
  Returns the list of scores with given station and klasse (if station is a team challenge) or schueler

  ## Examples

      iex> get_score(station, besitzer)
      %Score{}

      iex> get_score!(bad_station, bad_besitzer)
      ** (Ecto.NoResultsError)
  """
  def get_or_create_score!(%Station{team_challenge: true} = station, %Klasse{} = klasse) do
    case  Score |> where(station_id: ^station.id)
                |> where(klasse_id: ^klasse.id)
                |> Ecto.Query.preload([klasse: [scores: [:station]], schueler: [scores: [:station]], station: []])
                |> Repo.one() do
                  nil   ->  {:ok, score} = create_score(%{station_id: station.id, klasse_id: klasse.id, medaille: :keine})
                            score
                  score ->  score
                end
  end

  def get_or_create_score!(%Station{team_challenge: false} = station, %Schueler{} = schueler) do
    case  Score |> where(station_id: ^station.id)
                |> where(schueler_id: ^schueler.id)
                |> Ecto.Query.preload([klasse: [scores: [:station]], schueler: [scores: [:station]], station: []])
                |> Repo.one() do
                  nil   ->  {:ok, score} = create_score( %{station_id: station.id, klasse_id: schueler.klasse_id, schueler_id: schueler.id, medaille: :keine})
                            score
                  score ->  score
                end
  end

  @doc """
  Creates a score.

  ## Examples

      iex> create_score(%{field: value})
      {:ok, %Score{}}

      iex> create_score(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_score(attrs) do
    %Score{}
    |> change_score(attrs)
    |> Repo.insert()
    |> broadcast(:score_created)
  end

  @doc """
  Updates a score.

  ## Examples

      iex> update_score(score, %{field: new_value})
      {:ok, %Score{}}

      iex> update_score(score, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_score(%Score{} = score, attrs) do
    score
    |> change_score(attrs)
    |> Repo.update()
    |> broadcast(:score_updated)
  end

  @doc """
  Deletes a score.

  ## Examples

      iex> delete_score(score)
      {:ok, %Score{}}

      iex> delete_score(score)
      {:error, %Ecto.Changeset{}}

  """
  def delete_score(%Score{} = score) do
    Repo.delete(score)
    |> broadcast(:score_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking score changes.

  ## Examples

      iex> change_score(score)
      %Ecto.Changeset{data: %Score{}}

  """
  def change_score(%Score{} = score, attrs \\ %{}) do
    score
    |> Repo.preload([klasse: [scores: [:station]], schueler: [scores: [:station]], station: []])
    |> Score.changeset(attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Sportfest.PubSub, "scores")
  end

  defp broadcast({:error, _error} = error, _event), do: error
  defp broadcast({:ok, score}, event) do
    Phoenix.PubSub.broadcast!(Sportfest.PubSub, "scores", {event, score})
    {:ok, score}
  end

  @doc """
  Returns the sum of all scores associated to a given owner (schueler or klasse).

  ## Examples

      iex> get_score_sum(owner)
      50

  """
  def get_score_sum(owner) do
    Enum.map(owner.scores,
              fn score ->
                case score.medaille do
                  :bronze -> score.station.bronze
                  :silber -> score.station.silber
                  :gold -> score.station.gold
                  :keine -> 0
                end
              end)
    |> Enum.sum()
  end

  # Functions to filter the output for the score list
  defp base_query do
    from s in Score
  end

  def query_table(criteria) do
    base_query()
    |> build_query(criteria)
    |> Ecto.Query.preload([klasse: [scores: [:station]], schueler: [scores: [:station]], station: []])
    |> Repo.all()
  end

  defp build_query(query, criteria) do
    Enum.reduce(criteria, query, &compose_query/2)
  end

  defp compose_query({_, "All"}, query) do
    query
  end

  defp compose_query({k,val},query) do
    query
    |> where([s], field(s,^String.to_atom(k)) == ^val)
  end
end
