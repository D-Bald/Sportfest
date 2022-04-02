defmodule Sportfest.ErgebnisseTest do
  use Sportfest.DataCase

  alias Sportfest.Ergebnisse

  describe "scores" do
    alias Sportfest.Ergebnisse.Score

    import Sportfest.ErgebnisseFixtures

    @invalid_attrs %{medaille: nil, scoreboard: nil, station: nil}

    test "list_scores/0 returns all scores" do
      score = score_fixture()
      assert Ergebnisse.list_scores() == [score]
    end

    test "get_score!/1 returns the score with given id" do
      score = score_fixture()
      assert Ergebnisse.get_score!(score.id) == score
    end

    test "create_score/1 with valid data creates a score" do
      valid_attrs = %{medaille: "some medaille", scoreboard: "some scoreboard", station: "some station"}

      assert {:ok, %Score{} = score} = Ergebnisse.create_score(valid_attrs)
      assert score.medaille == "some medaille"
      assert score.scoreboard == "some scoreboard"
      assert score.station == "some station"
    end

    test "create_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ergebnisse.create_score(@invalid_attrs)
    end

    test "update_score/2 with valid data updates the score" do
      score = score_fixture()
      update_attrs = %{medaille: "some updated medaille", scoreboard: "some updated scoreboard", station: "some updated station"}

      assert {:ok, %Score{} = score} = Ergebnisse.update_score(score, update_attrs)
      assert score.medaille == "some updated medaille"
      assert score.scoreboard == "some updated scoreboard"
      assert score.station == "some updated station"
    end

    test "update_score/2 with invalid data returns error changeset" do
      score = score_fixture()
      assert {:error, %Ecto.Changeset{}} = Ergebnisse.update_score(score, @invalid_attrs)
      assert score == Ergebnisse.get_score!(score.id)
    end

    test "delete_score/1 deletes the score" do
      score = score_fixture()
      assert {:ok, %Score{}} = Ergebnisse.delete_score(score)
      assert_raise Ecto.NoResultsError, fn -> Ergebnisse.get_score!(score.id) end
    end

    test "change_score/1 returns a score changeset" do
      score = score_fixture()
      assert %Ecto.Changeset{} = Ergebnisse.change_score(score)
    end
  end
end
