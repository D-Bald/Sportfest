defmodule Sportfest.VorbereitungFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sportfest.Vorbereitung` context.
  """

  @doc """
  Generate a unique station name.
  """
  def unique_station_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a station.
  """
  def station_fixture(attrs \\ %{}) do
    {:ok, station} =
      attrs
      |> Enum.into(%{
        bronze: 42,
        gold: 42,
        name: unique_station_name(),
        silber: 42
      })
      |> Sportfest.Vorbereitung.create_station()

    station
  end

  @doc """
  Generate a unique klasse name.
  """
  def unique_klasse_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a klasse.
  """
  def klasse_fixture(attrs \\ %{}) do
    {:ok, klasse} =
      attrs
      |> Enum.into(%{
        scores: "some scores",
        name: unique_klasse_name(),
        schueler: "some schueler",
        summe: 42
      })
      |> Sportfest.Vorbereitung.create_klasse()

    klasse
  end

  @doc """
  Generate a schueler.
  """
  def schueler_fixture(attrs \\ %{}) do
    {:ok, schueler} =
      attrs
      |> Enum.into(%{
        jahrgang: "some jahrgang",
        klasse: "some klasse",
        name: "some name",
        scores: "some scores"
      })
      |> Sportfest.Vorbereitung.create_schueler()

    schueler
  end
end
