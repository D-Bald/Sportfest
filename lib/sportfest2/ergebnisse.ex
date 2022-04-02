defmodule Sportfest2.Ergebnisse do
  @moduledoc """
  The Ergebnisse context.
  """

  import Ecto.Query, warn: false
  alias Sportfest2.Repo

  alias Sportfest2.Ergebnisse.KlassenScoreboard
  alias Sportfest2.Ergebnisse.SchuelerScoreboard
  alias Sportfest2.Ergebnisse.Score

  alias Sportfest2.Vorbereitung.{Klasse, Schueler, Station}

  @doc """
  Returns the list of schueler_scoreboards.

  ## Examples

      iex> list_schueler_scoreboards()
      [%SchuelerScoreboard{}, ...]

  """
  def list_schueler_scoreboards do
    SchuelerScoreboard
    |> Ecto.Query.preload([scores: [:station], schueler: []])
    |> Repo.all()
  end

  @doc """
  Gets a single schueler_scoreboard.

  Raises `Ecto.NoResultsError` if the Schueler scoreboard does not exist.

  ## Examples

      iex> get_schueler_scoreboard!(123)
      %SchuelerScoreboard{}

      iex> get_schueler_scoreboard!(456)
      ** (Ecto.NoResultsError)

  """
  def get_schueler_scoreboard!(id) do
    SchuelerScoreboard
    |> Ecto.Query.preload([scores: [:station], schueler: []])
    |> Repo.get!(id)
  end

  @doc """
  Creates a schueler_scoreboard.

  ## Examples

      iex> create_schueler_scoreboard(schueler, %{field: value})
      {:ok, %SchuelerScoreboard{}}

      iex> create_schueler_scoreboard(schueler, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_schueler_scoreboard(%Schueler{} = schueler, attrs \\ %{}) do
    Ecto.build_assoc(schueler, :schueler_scoreboard)
    |> change_schueler_scoreboard(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a schueler_scoreboard.

  ## Examples

      iex> update_schueler_scoreboard(schueler_scoreboard, %{field: new_value})
      {:ok, %SchuelerScoreboard{}}

      iex> update_schueler_scoreboard(schueler_scoreboard, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_schueler_scoreboard(%SchuelerScoreboard{} = schueler_scoreboard, attrs) do
    schueler_scoreboard
    |> change_schueler_scoreboard(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a schueler_scoreboard.

  ## Examples

      iex> delete_schueler_scoreboard(schueler_scoreboard)
      {:ok, %SchuelerScoreboard{}}

      iex> delete_schueler_scoreboard(schueler_scoreboard)
      {:error, %Ecto.Changeset{}}

  """
  def delete_schueler_scoreboard(%SchuelerScoreboard{} = schueler_scoreboard) do
    Repo.delete(schueler_scoreboard)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking schueler_scoreboard changes.

  ## Examples

      iex> change_schueler_scoreboard(schueler_scoreboard)
      %Ecto.Changeset{data: %SchuelerScoreboard{}}

  """
  def change_schueler_scoreboard(%SchuelerScoreboard{} = schueler_scoreboard, attrs \\ %{}) do
    schueler_scoreboard
    |> Repo.preload([scores: [:station], schueler: []])
    |> SchuelerScoreboard.changeset(attrs)
  end

  @doc """
  Returns the list of scores.

  ## Examples

      iex> list_scores()
      [%Score{}, ...]

  """
  def list_scores do
    Score
    |> Ecto.Query.preload([klassen_scoreboard: [:klasse, :scores], schueler_scoreboard: [:schueler, :scores], station: []])
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
    |> Ecto.Query.preload([klassen_scoreboard: [:klasse, :scores], schueler_scoreboard: [:schueler, :scores], station: []])
    |> Repo.get!(id)
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
    |> Repo.preload([klassen_scoreboard: [:klasse, :scores], schueler_scoreboard: [:schueler, :scores], station: []])
    |> Score.changeset(attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Sportfest2.PubSub, "scores")
  end

  defp broadcast({:error, _error} = error, _event), do: error
  defp broadcast({:ok, score}, event) do
    Phoenix.PubSub.broadcast!(Sportfest2.PubSub, "scores", {event, score})
    {:ok, score}
  end

  @doc """
  Returns the list of klassen_scoreboards.

  ## Examples

      iex> list_klassen_scoreboards()
      [%KlassenScoreboard{}, ...]

  """
  def list_klassen_scoreboards do
    KlassenScoreboard
    |> Ecto.Query.preload([scores: [:station], klasse: []])
    |> Repo.all()
  end

  @doc """
  Gets a single klassen_scoreboard.

  Raises `Ecto.NoResultsError` if the Klassen scoreboard does not exist.

  ## Examples

      iex> get_klassen_scoreboard!(123)
      %KlassenScoreboard{}

      iex> get_klassen_scoreboard!(456)
      ** (Ecto.NoResultsError)

  """
  def get_klassen_scoreboard!(id) do
    KlassenScoreboard
    |> Ecto.Query.preload([scores: [:station], klasse: []])
    |> Repo.get!(id)
  end

  @doc """
  Creates a klassen_scoreboard.

  ## Examples

      iex> create_klassen_scoreboard(klasse, %{field: new_value})
      {:ok, %KlassenScoreboard{}}

      iex> create_klassen_scoreboard(klasse,%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_klassen_scoreboard(%Klasse{} = klasse, attrs \\ %{}) do
    Ecto.build_assoc(klasse, :klassen_scoreboard)
    |> change_klassen_scoreboard(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a klassen_scoreboard.

  ## Examples

      iex> update_klassen_scoreboard(klassen_scoreboard, %{field: new_value})
      {:ok, %KlassenScoreboard{}}

      iex> update_klassen_scoreboard(klassen_scoreboard, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_klassen_scoreboard(%KlassenScoreboard{} = klassen_scoreboard, attrs) do
    klassen_scoreboard
    |> change_klassen_scoreboard(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a klassen_scoreboard.

  ## Examples

      iex> delete_klassen_scoreboard(klassen_scoreboard)
      {:ok, %KlassenScoreboard{}}

      iex> delete_klassen_scoreboard(klassen_scoreboard)
      {:error, %Ecto.Changeset{}}

  """
  def delete_klassen_scoreboard(%KlassenScoreboard{} = klassen_scoreboard) do
    Repo.delete(klassen_scoreboard)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking klassen_scoreboard changes.

  ## Examples

      iex> change_klassen_scoreboard(klassen_scoreboard)
      %Ecto.Changeset{data: %KlassenScoreboard{}}

  """
  def change_klassen_scoreboard(%KlassenScoreboard{} = klassen_scoreboard, attrs \\ %{}) do
    klassen_scoreboard
    |> Repo.preload([scores: [:station], klasse: []])
    |> KlassenScoreboard.changeset(attrs)
  end

  @doc """
  Returns the sum of all scores in a given scoreboard.

  ## Examples

      iex> get_scoreboard_sum(scoreboard)
      50

  """
  def get_scoreboard_sum(scoreboard) do
    Enum.map(scoreboard.scores,
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
end
