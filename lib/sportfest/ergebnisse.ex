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
  Returns score with given station and owner (klasse if station is a team challenge, schueler else).
  Creates a score if no score with the given station and owner exists.
  Raises `Ecto.MultipleResultsError` if more than one score with the same station and owner already exists.

  ## Examples

      iex> create_or_skip_score(station, besitzer)
      {:ok, %Score{}}

      iex> create_or_skip_score(bad_station, bad_besitzer)
      {:error, %Ecto.Changeset{}}

      iex> create_or_skip_score(station_mehrfach, besitzer_mehrfach)
      ** (Ecto.MultipleResultsError)
  """
  def create_or_skip_score(%Station{team_challenge: false} = station, %Schueler{} = schueler) do
    case  Score |> where(station_id: ^station.id)
                |> where(schueler_id: ^schueler.id)
                |> Ecto.Query.preload([klasse: [scores: [:station]], schueler: [scores: [:station]], station: []])
                |> Repo.one() do
                  nil   ->  create_score( %{station_id: station.id, klasse_id: schueler.klasse_id, schueler_id: schueler.id, medaille: :keine})
                  score ->  {:ok, score}
                end
  end

  def create_or_skip_score(%Station{team_challenge: true} = station, %Klasse{} = klasse) do
    case  Score |> where(station_id: ^station.id)
                |> where(klasse_id: ^klasse.id)
                |> Ecto.Query.preload([klasse: [scores: [:station]], schueler: [scores: [:station]], station: []])
                |> Repo.one() do
                  nil   ->  create_score(%{station_id: station.id, klasse_id: klasse.id, medaille: :keine})
                  score ->  {:ok, score}
                end
  end

  @doc """
  Creates a score.

  ## Examples

      iex> create_score(%{klasse_id: 1, station_id: 1})
      {:ok, %Score{}}

      iex> create_score(%{medaille: bad_value})
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

  @doc """
  Subscribe, um events zum Thema "scores" aus dem PubSub zu erhalten.any()

  ## Examples
      iex> Sportfest.Ergebnisse.subscribe
      :ok

      iex> Sportfest.Ergebnisse.subscribe
      {:error, term}
  """
  def subscribe do
    Phoenix.PubSub.subscribe(Sportfest.PubSub, "scores")
  end

  @doc """
  Broadcasting Events zu Scores im Phoenix PubSub, falls im ersten Parameter kein Error übergeben wird.

  ## Examples
      iex> broadcast({:ok, score}, event)
      {:ok, score}

      iex> broadcast({:error, error}, event)
      {:error, error}
  """
  def broadcast({:error, _error} = error, _event), do: error
  def broadcast({:ok, score}, event) do
    Phoenix.PubSub.broadcast!(Sportfest.PubSub, "scores", {event, score})
    {:ok, score}
  end

  @doc """
  Gibt die Punkte zurück, die für die assoziierte Station für die gegebene medaille vergeben werden.

  ## Examples

      iex> get_medal_points(score)
      3

  """
  def get_medal_points(score) do
    case score.medaille do
      :bronze -> score.station.bronze
      :silber -> score.station.silber
      :gold -> score.station.gold
      :keine -> 0
    end
  end

  @doc """
  Returns the sum of all scores associated to a given owner (schueler or klasse).

  ## Examples

      iex> get_score_sum(owner)
      50

  """
  def get_score_sum(owner) do
    Enum.map(owner.scores,
              fn score -> get_medal_points(score) end)
    |> Enum.sum()
  end

  @doc """
  Gibt die Summe der Scores an, die mit einer Klasse assoziiert sind.
  Skaliert dabei den Anteil der nicht Team Challenges am Klassenscore auf die Anzahl der Schueler in einer Klasse.

  ## Examples

      iex> scaled_class_score(klasse)
      50

      iex> scaled_class_score(klasse, station)
      20

  """
  def scaled_class_score(klasse) do
    team_points = klasse.scores
      |> Enum.filter(fn score -> score.station.team_challenge end)
      |> Enum.map(fn score -> get_medal_points(score) end)
      |> Enum.sum()

    aggregated_schueler_points =
      klasse.scores
      |> Enum.filter(fn score -> not score.station.team_challenge end)
      |> Enum.filter(fn score -> score.schueler.aktiv end)
      |> Enum.map(fn score ->
                    get_medal_points(score) / (klasse.schueler
                                              |> Enum.filter(fn s -> s.aktiv end)
                                              |> Enum.count())
          end)
    |> Enum.sum()

  team_points + aggregated_schueler_points
  |> Float.round(2)
  end

  def scaled_class_score(klasse, station) do
    scores =  klasse.scores
              |> Enum.filter(fn score -> score.station_id == station.id end)

    case station.team_challenge do
      false -> scores
              |> Enum.filter(fn score -> score.schueler.aktiv end)
              |> Enum.map(fn score ->
                            get_medal_points(score) / (klasse.schueler
                                                      |> Enum.filter(fn s -> s.aktiv end)
                                                      |> Enum.count())
                  end)
              |> Enum.sum()
              |> Float.round(2)
      _ -> scores
          |> Enum.map(fn score -> get_medal_points(score) end)
          |> Enum.sum()
    end
  end

  @doc """
  Gibt die Anzahl der Bronze Medaillen eines Besitzers zurück.

  ## Examples

      iex> count_bronze_medaillen(owner)
      3

      iex> count_bronze_medaillen(owner, station)
      1

  """
  def count_bronze_medaillen(owner) do
    count_medaillen(owner, :bronze)
  end
  def count_bronze_medaillen(owner, station) do
    count_medaillen(owner, station, :bronze)
  end

  @doc """
  Gibt die Anzahl der Silber Medaillen eines Besitzers zurück.

  ## Examples

      iex> count_silber_medaillen(owner)
      5

      iex> count_silber_medaillen(owner, station)
      2

  """
  def count_silber_medaillen(owner) do
    count_medaillen(owner, :silber)
  end
  def count_silber_medaillen(owner, station) do
    count_medaillen(owner, station, :silber)
  end

  @doc """
  Gibt die Anzahl der Gold Medaillen eines Besitzers zurück.

  ## Examples

      iex> count_gold_medaillen(owner)
      2

      iex> count_gold_medaillen(owner, station)
      1

  """
  def count_gold_medaillen(owner) do
    count_medaillen(owner, :gold)
  end
  def count_gold_medaillen(owner, station) do
    count_medaillen(owner, station, :gold)
  end


  # Zählt Medaillen gegeben durch ein Atom aus [:bronze, :silber, :gold]
  # von einem gegebenen Owner (%Klasse{} oder %Schueler{}) und optional gefiltert auf eine Station.
  defp count_medaillen(owner, medaille) do
    Enum.filter(owner.scores, fn score -> medaille == score.medaille end)
    |> Enum.count()
  end
  defp count_medaillen(owner, station, medaille) do
    Enum.filter(owner.scores, fn score -> score.station_id == station.id end)
    |> Enum.filter(fn score -> medaille == score.medaille end)
    |> Enum.count()
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
