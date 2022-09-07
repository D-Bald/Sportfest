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
        name: unique_station_name(),
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
  def klasse_fixture(name \\ unique_klasse_name(), jahrgang \\ 5) do
    {:ok, klasse} = Sportfest.Vorbereitung.create_klasse(%{name: name, jahrgang: jahrgang})
    klasse
  end

  @doc """
  Generate a schueler.

  ## Example

      iex> schueler_fixture(%(klasse: klasse_fixture()))
  """
  def schueler_fixture(klasse, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        name: "some name",
      })

      {:ok, schueler} = Sportfest.Vorbereitung.create_schueler(klasse, attrs)

    schueler
  end
end
