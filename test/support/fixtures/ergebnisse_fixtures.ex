defmodule Sportfest.ErgebnisseFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sportfest.Ergebnisse` context.
  """

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
end
