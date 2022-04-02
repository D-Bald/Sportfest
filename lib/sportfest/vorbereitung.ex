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
    Repo.all(Station)
  end

  @doc """
  Gibt Name und ID für alle Stationen zurück.
  """
  def list_stationen_for_dropdown do
    Repo.all(from s in Station, select: {s.name, s.id})
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
    %Station{}
    |> Station.changeset(attrs)
    |> Repo.insert()
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
    |> Ecto.Query.preload([scores: [:station], schueler: []])
    |> Repo.all()
  end

  @doc """
  Gibt Name und ID für alle Klassen zurück.
  """
  def list_klassen_for_dropdown do
    Repo.all(from k in Klasse, select: {k.name, k.id})
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
    |> Ecto.Query.preload([scores: [:station], schueler: []])
    |> Repo.get!(id)
  end

  @doc """
  Creates a klasse.

  ## Examples

      iex> create_klasse(name)
      {:ok, %Klasse{}}

      iex> create_klasse(bad_input)
      {:error, %Ecto.Changeset{}}

  """
  def create_klasse(name) do
    %Klasse{}
    |> Klasse.changeset(%{name: name})
    |> Repo.insert()
  end

  @doc """
  Updates a klasse.

  ## Examples

      iex> update_klasse(klasse, %{field: new_value})
      {:ok, %Klasse{}}

      iex> update_klasse(klasse, %{field: bad_value})
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
    |> Repo.preload([scores: [:station], schueler: []])
    |> Klasse.changeset(attrs)
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
    |> Repo.all()
  end

  @doc """
  Gibt Name und ID für alle Schüler:innen zurück.
  """
  def list_schueler_for_dropdown do
    Repo.all(from s in Schueler, select: {s.name, s.id})
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
  Creates a schueler.

  ## Examples

      iex> create_schueler(klasse, %{field: value})
      {:ok, %Schueler{}}

      iex> create_schueler(klasse, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_schueler(%Klasse{} = klasse, attrs \\ %{}) do
    Ecto.build_assoc(klasse, :schueler)
    |> change_schueler(attrs)
    |> Repo.insert()
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
    Repo.delete(schueler)
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

    # if Map.has_key?(attrs, "klasse_id") do
    #   klasse = get_klasse!(attrs["klasse_id"])
    #   ^changeset = Ecto.Changeset.put_assoc(changeset, :klasse, klasse)
    # end

    changeset
  end
end
