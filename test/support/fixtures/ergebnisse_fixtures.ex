defmodule Sportfest.ErgebnisseFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sportfest.Ergebnisse` context.
  """

  @doc """
  Generate a score.
  """
  def score_fixture(attrs) do
    {:ok, score} = Sportfest.Ergebnisse.create_score(attrs)

    score
  end
end
