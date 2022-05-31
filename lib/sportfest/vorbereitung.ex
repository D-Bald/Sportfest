defmodule Sportfest.Vorbereitung do
  @moduledoc """
  The Vorbereitung context.
  """

  import Ecto.Query, warn: false
  alias Sportfest.Repo

  alias Sportfest.Vorbereitung.Station
  alias Sportfest.Vorbereitung.Klasse
  alias Sportfest.Vorbereitung.Schueler

  @doc """
  Returns the list of stationen.

  ## Examples

      iex> list_stationen()
      [%Station{}, ...]

  """
  def list_stationen do
    Station
    |> order_by(asc: :name)
    |> Repo.all()
  end

  @doc """
  Gibt Stationen zurück, die KEINE Team-Challenge sind

  ## Examples

      iex> list_singe_challenge_stationen()
      [%Station{}, ...]

  """
  def list_singe_challenge_stationen do
    Station
    |> where(team_challenge: false)
    |> order_by(asc: :name)
    |> Repo.all()
  end

  @doc """
  Gibt Stationen zurück, die ein Team-Challenge sind

  ## Examples

      iex> list_team_challenge_stationen
      [%Station{}, ...]

  """
  def list_team_challenge_stationen do
    Station
    |> where(team_challenge: true)
    |> order_by(asc: :name)
    |> Repo.all()
  end

  @doc """
  Gibt Name und ID für alle Stationen zurück.
  """
  def list_stationen_for_dropdown do
    Repo.all(from s in Station, order_by: s.name, select: {s.name, s.id})
  end

  @doc """
  Gets a single station.

  Raises `Ecto.NoResultsError` if the Station does not exist.

  ## Examples

      iex> get_station!(123)
      %Station{}

      iex> get_station!(456)
      ** (Ecto.NoResultsError)

  """
  def get_station!(id), do: Repo.get!(Station, id)

  @doc """
  Creates a station.

  ## Examples

      iex> create_station(%{field: value})
      {:ok, %Station{}}

      iex> create_station(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_station(attrs \\ %{}) do
    with {:ok, station} <-
      %Station{}
      |> Station.changeset(attrs)
      |> Repo.insert() do
        case station.team_challenge do
          false ->
            for schueler <- list_schueler() do
              Sportfest.Ergebnisse.create_score(%{station_id: station.id, klasse_id: schueler.klasse.id,
                                              schueler_id: schueler.id, medaille: :keine})
            end
          true ->
            for klasse <- list_klassen() do
              Sportfest.Ergebnisse.create_score(%{station_id: station.id, klasse_id: klasse.id, medaille: :keine})
            end
        end
        {:ok, station}
      end
  end

  @doc """
  Updates a station.

  ## Examples

      iex> update_station(station, %{field: new_value})
      {:ok, %Station{}}

      iex> update_station(station, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_station(%Station{} = station, attrs) do
    station
    |> Station.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a station.

  ## Examples

      iex> delete_station(station)
      {:ok, %Station{}}

      iex> delete_station(station)
      {:error, %Ecto.Changeset{}}

  """
  def delete_station(%Station{} = station) do
    Repo.delete(station)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking station changes.

  ## Examples

      iex> change_station(station)
      %Ecto.Changeset{data: %Station{}}

  """
  def change_station(%Station{} = station, attrs \\ %{}) do
    Station.changeset(station, attrs)
  end

  @doc """
  Returns the list of klassen.

  ## Examples

      iex> list_klassen()
      [%Klasse{}, ...]

  """
  def list_klassen do
    Klasse
    |> preload([scores: [:station, :schueler], schueler: []])
    |> order_by(asc: :name)
    |> Repo.all()
  end

  @doc """
  Gibt Klassen mit gegebenen IDs und Namen zurück.
  """
  def list_klassen_for_dropdown do
    Repo.all(from k in Klasse, order_by: k.name, select: {k.name, k.id})
  end

  @doc """
  Gets a single klasse.

  Raises `Ecto.NoResultsError` if the Klasse does not exist.

  ## Examples

      iex> get_klasse!(123)
      %Klasse{}

      iex> get_klasse!(456)
      ** (Ecto.NoResultsError)

  """
  def get_klasse!(id) do
    Klasse
    |> Ecto.Query.preload([scores: [:station, :schueler], schueler: []])
    |> Repo.get!(id)
  end

  @doc """
  Gets a single klasse by given name.

  Raise Error if more than one Klasse with given name exist.
  Since on creation a unique constraint for name is applied, this should not occure.

  ## Examples

      iex> get_klasse_by_name("5b)")
      %Klasse{}

      iex> get_klasse_by_name("14f)")
      ** nil

  """
  def get_klasse_by_name(name) do
    Klasse
    |> Ecto.Query.preload([scores: [:station, :schueler], schueler: []])
    |> Repo.get_by(name: name)
  end

  @doc """
  Creates a klasse.

  ## Examples

      iex> create_klasse(%{name: "5b", jahrgang: 5)
      {:ok, %Klasse{}}

      iex> create_klasse(%{name: bad_name, , jahrgang: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_klasse(name, jahrgang) do
    with {:ok, klasse} <-
      %Klasse{}
      |> Klasse.changeset(%{name: name, jahrgang: jahrgang})
      |> Repo.insert() do
        for station <- list_team_challenge_stationen() do
          Sportfest.Ergebnisse.create_score(%{station_id: station.id, klasse_id: klasse.id, medaille: :keine})
        end
        {:ok, klasse}
      end
  end

  @doc """
  Updates a klasse.

  ## Examples

      iex> update_klasse(klasse, %{name: "6b"})
      {:ok, %Klasse{}}

      iex> update_klasse(klasse, %{name: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_klasse(%Klasse{} = klasse, attrs) do
    klasse
    |> change_klasse(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a klasse.

  ## Examples

      iex> delete_klasse(klasse)
      {:ok, %Klasse{}}

      iex> delete_klasse(klasse)
      {:error, %Ecto.Changeset{}}

  """
  def delete_klasse(%Klasse{} = klasse) do
    Repo.delete(klasse)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking klasse changes.

  ## Examples

      iex> change_klasse(klasse)
      %Ecto.Changeset{data: %Klasse{}}

  """
  def change_klasse(%Klasse{} = klasse, attrs \\ %{}) do
    klasse
    |> Repo.preload([scores: [:station, :schueler], schueler: []])
    |> Klasse.changeset(attrs)
  end

  @doc """
  Checks if any klasse exists.

  ## Examples

      iex> exists_klasse?()
      true

  """
  def exists_klasse? do
    Repo.exists?(Klasse)
  end

  @doc """
  Gibt die Anzahl als aktiv markierter Schüler:innen der gegebenen Klasse zurück

  ## Examples

      iex> get_aktive_schueler(klasse)
      25

  """
  def count_aktive_schueler(%Klasse{} = klasse) do
    klasse.schueler
    |> Enum.filter(fn s -> s.aktiv end)
    |> Enum.count()
  end

  @doc """
  Returns the list of schueler.

  ## Examples

      iex> list_schueler()
      [%Schueler{}, ...]

  """
  def list_schueler do
    Schueler
    |> Ecto.Query.preload([scores: [:station], klasse: []])
    |> order_by(asc: :name)
    |> Repo.all()
  end

    @doc """
  Gets a single klasse by given name.

  Raise Error if more than one Klasse with given name exist.
  Since on creation a unique constraint for name is applied, this should not occure.

  ## Examples

      iex> list_schueler_by_klasse("5b)")
      %Klasse{}

      iex> list_schueler_by_klasse("14f)")
      ** nil

  """
  def list_schueler_by_klasse(%Klasse{} = klasse) do
    Schueler
    |> Ecto.Query.preload([scores: [:station], klasse: []])
    |> where(klasse_id: ^klasse.id)
    |> order_by(asc: :name)
    |> Repo.all()
  end

  @doc """
  Gibt Name und ID für alle Schüler:innen zurück.
  """
  def list_schueler_for_dropdown do
    Repo.all(from s in Schueler, order_by: s.name, select: {s.name, s.id})
  end

  @doc """
  Gets a single schueler.

  Raises `Ecto.NoResultsError` if the Schueler does not exist.

  ## Examples

      iex> get_schueler!(123)
      %Schueler{}

      iex> get_schueler!(456)
      ** (Ecto.NoResultsError)

  """
  def get_schueler!(id) do
    Schueler
    |> Ecto.Query.preload([scores: [:station], klasse: []])
    |> Repo.get!(id)
  end

  @doc """
  Erstellt eine:n Schueler:in in gegebener Klasse und einen assoziierten Score.

  ## Examples

      iex> create_schueler(klasse, %{field: value})
      {:ok, %Schueler{}}

      iex> create_schueler(klasse, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_schueler(%Klasse{} = klasse, attrs \\ %{}) do
    with {:ok, schueler} <-
      Ecto.build_assoc(klasse, :schueler)
      |> change_schueler(attrs)
      |> Repo.insert()
      |> broadcast(:schueler_created) do
        for station <- list_singe_challenge_stationen() do
          Sportfest.Ergebnisse.create_score(%{station_id: station.id, klasse_id: klasse.id,
                                              schueler_id: schueler.id, medaille: :keine})
        end
        {:ok, schueler}
    end
  end


  @doc """
  Returns schueler with given name and klasse.
  Creates a schueler if no schueler with the given name and klasse exists.
  Raises `Ecto.MultipleResultsError` if more than one schueler with the same name and klasse already exists.

  ## Examples

      iex> create_or_skip_schueler(%{name: name, klasse: klasse})
      {:ok, %Schueler{}}

      iex> create_or_skip_schueler(%{name: vergebener_name, klasse: klasse})
      {:ok, %Schueler{}}

      iex> create_or_skip_schueler(%{name: bad_value, klasse: bad_value})
      {:error, %Ecto.Changeset{}}

      iex> create_or_skip_schueler(%{name: name_mehrfach, klasse: klasse_mehrfach})
      ** (Ecto.MultipleResultsError)
  """
  def create_or_skip_schueler(%{name: name, klasse: klasse} = attrs) do
    case Schueler |> where(name: ^name)
                  |> where(klasse_id: ^klasse.id)
                  |> Ecto.Query.preload([scores: [:station], klasse: []])
                  |> Repo.one()
                  do
      nil -> create_schueler(klasse, attrs)
      schueler -> {:ok, schueler}
    end
  end

  @doc """
  Updates a schueler.

  ## Examples

      iex> update_schueler(schueler, %{field: new_value})
      {:ok, %Schueler{}}

      iex> update_schueler(schueler, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_schueler(%Schueler{} = schueler, attrs) do
    schueler
    |> change_schueler(attrs)
    |> Repo.update()
    |> broadcast(:schueler_updated)
  end

  @doc """
  Deletes a schueler.

  ## Examples

      iex> delete_schueler(schueler)
      {:ok, %Schueler{}}

      iex> delete_schueler(schueler)
      {:error, %Ecto.Changeset{}}

  """
  def delete_schueler(%Schueler{} = schueler) do
    with {:ok, schueler} <-
      Repo.delete(schueler)
      |> broadcast(:schueler_deleted) do
          for score <- schueler.scores do
            Sportfest.Ergebnisse.broadcast({:ok, score}, :score_deleted)
          end
          {:ok, schueler}
      end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking schueler changes.

  ## Examples

      iex> change_schueler(schueler)
      %Ecto.Changeset{data: %Schueler{}}

  """
  def change_schueler(%Schueler{} = schueler, attrs \\ %{}) do
    changeset =
      schueler
      |> Repo.preload([scores: [:station], klasse: []])
      |> Schueler.changeset(attrs)

    changeset
  end

  @doc """
  Checks if any schueler exists.

  ## Examples

      iex> exists_schueler?()
      true

  """
  def exists_schueler? do
    Repo.exists?(Schueler)
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
    Phoenix.PubSub.subscribe(Sportfest.PubSub, "schueler")
  end

  @doc """
  Broadcasting Events zu Schüler:innen im Phoenix PubSub, falls im ersten Parameter kein Error übergeben wird.

  ## Examples
      iex> broadcast({:ok, schueler}, event)
      {:ok, schueler}

      iex> broadcast({:error, error}, event)
      {:error, error}
  """
  def broadcast({:error, _error} = error, _event), do: error
  def broadcast({:ok, schueler}, event) do
    Phoenix.PubSub.broadcast!(Sportfest.PubSub, "schueler", {event, schueler})
    {:ok, schueler}
  end
end
