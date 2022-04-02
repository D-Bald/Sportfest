defmodule Sportfest.ErgebnisseFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sportfest.Ergebnisse` context.
  """

  @doc """
  Generate a schueler_scoreboard.
  """
  def schueler_scoreboard_fixture(attrs \\ %{}) do
    {:ok, schueler_scoreboard} =
      attrs
      |> Enum.into(%{
        schueler: "some schueler",
        scores: "some scores",
        summe: 42
      })
      |> Sportfest.Ergebnisse.create_schueler_scoreboard()

    schueler_scoreboard
  end

  @doc """
  Generate a score.
  """
  def score_fixture(attrs \\ %{}) do
    {:ok, score} =
      attrs
      |> Enum.into(%{
        medaille: "some medaille",
        scoreboard: "some scoreboard",
        station: "some station"
      })
      |> Sportfest.Ergebnisse.create_score()

    score
  end

  @doc """
  Generate a klassen_scoreboard.
  """
  def klassen_scoreboard_fixture(attrs \\ %{}) do
    {:ok, klassen_scoreboard} =
      attrs
      |> Enum.into(%{
        klasse: "some klasse",
        scores: "some scores",
        summe: 42
      })
      |> Sportfest.Ergebnisse.create_klassen_scoreboard()

    klassen_scoreboard
  end
end
