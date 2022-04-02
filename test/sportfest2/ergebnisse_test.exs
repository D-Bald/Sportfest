defmodule Sportfest.ErgebnisseTest do
  use Sportfest.DataCase

  alias Sportfest.Ergebnisse

  describe "schueler_scoreboards" do
    alias Sportfest.Ergebnisse.SchuelerScoreboard

    import Sportfest.ErgebnisseFixtures

    @invalid_attrs %{schueler: nil, scores: nil, summe: nil}

    test "list_schueler_scoreboards/0 returns all schueler_scoreboards" do
      schueler_scoreboard = schueler_scoreboard_fixture()
      assert Ergebnisse.list_schueler_scoreboards() == [schueler_scoreboard]
    end

    test "get_schueler_scoreboard!/1 returns the schueler_scoreboard with given id" do
      schueler_scoreboard = schueler_scoreboard_fixture()
      assert Ergebnisse.get_schueler_scoreboard!(schueler_scoreboard.id) == schueler_scoreboard
    end

    test "create_schueler_scoreboard/1 with valid data creates a schueler_scoreboard" do
      valid_attrs = %{schueler: "some schueler", scores: "some scores", summe: 42}

      assert {:ok, %SchuelerScoreboard{} = schueler_scoreboard} = Ergebnisse.create_schueler_scoreboard(valid_attrs)
      assert schueler_scoreboard.schueler == "some schueler"
      assert schueler_scoreboard.scores == "some scores"
      assert schueler_scoreboard.summe == 42
    end

    test "create_schueler_scoreboard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ergebnisse.create_schueler_scoreboard(@invalid_attrs)
    end

    test "update_schueler_scoreboard/2 with valid data updates the schueler_scoreboard" do
      schueler_scoreboard = schueler_scoreboard_fixture()
      update_attrs = %{schueler: "some updated schueler", scores: "some updated scores", summe: 43}

      assert {:ok, %SchuelerScoreboard{} = schueler_scoreboard} = Ergebnisse.update_schueler_scoreboard(schueler_scoreboard, update_attrs)
      assert schueler_scoreboard.schueler == "some updated schueler"
      assert schueler_scoreboard.scores == "some updated scores"
      assert schueler_scoreboard.summe == 43
    end

    test "update_schueler_scoreboard/2 with invalid data returns error changeset" do
      schueler_scoreboard = schueler_scoreboard_fixture()
      assert {:error, %Ecto.Changeset{}} = Ergebnisse.update_schueler_scoreboard(schueler_scoreboard, @invalid_attrs)
      assert schueler_scoreboard == Ergebnisse.get_schueler_scoreboard!(schueler_scoreboard.id)
    end

    test "delete_schueler_scoreboard/1 deletes the schueler_scoreboard" do
      schueler_scoreboard = schueler_scoreboard_fixture()
      assert {:ok, %SchuelerScoreboard{}} = Ergebnisse.delete_schueler_scoreboard(schueler_scoreboard)
      assert_raise Ecto.NoResultsError, fn -> Ergebnisse.get_schueler_scoreboard!(schueler_scoreboard.id) end
    end

    test "change_schueler_scoreboard/1 returns a schueler_scoreboard changeset" do
      schueler_scoreboard = schueler_scoreboard_fixture()
      assert %Ecto.Changeset{} = Ergebnisse.change_schueler_scoreboard(schueler_scoreboard)
    end
  end

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

  describe "klassen_scoreboards" do
    alias Sportfest.Ergebnisse.KlassenScoreboard

    import Sportfest.ErgebnisseFixtures

    @invalid_attrs %{klasse: nil, scores: nil, summe: nil}

    test "list_klassen_scoreboards/0 returns all klassen_scoreboards" do
      klassen_scoreboard = klassen_scoreboard_fixture()
      assert Ergebnisse.list_klassen_scoreboards() == [klassen_scoreboard]
    end

    test "get_klassen_scoreboard!/1 returns the klassen_scoreboard with given id" do
      klassen_scoreboard = klassen_scoreboard_fixture()
      assert Ergebnisse.get_klassen_scoreboard!(klassen_scoreboard.id) == klassen_scoreboard
    end

    test "create_klassen_scoreboard/1 with valid data creates a klassen_scoreboard" do
      valid_attrs = %{klasse: "some klasse", scores: "some scores", summe: 42}

      assert {:ok, %KlassenScoreboard{} = klassen_scoreboard} = Ergebnisse.create_klassen_scoreboard(valid_attrs)
      assert klassen_scoreboard.klasse == "some klasse"
      assert klassen_scoreboard.scores == "some scores"
      assert klassen_scoreboard.summe == 42
    end

    test "create_klassen_scoreboard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ergebnisse.create_klassen_scoreboard(@invalid_attrs)
    end

    test "update_klassen_scoreboard/2 with valid data updates the klassen_scoreboard" do
      klassen_scoreboard = klassen_scoreboard_fixture()
      update_attrs = %{klasse: "some updated klasse", scores: "some updated scores", summe: 43}

      assert {:ok, %KlassenScoreboard{} = klassen_scoreboard} = Ergebnisse.update_klassen_scoreboard(klassen_scoreboard, update_attrs)
      assert klassen_scoreboard.klasse == "some updated klasse"
      assert klassen_scoreboard.scores == "some updated scores"
      assert klassen_scoreboard.summe == 43
    end

    test "update_klassen_scoreboard/2 with invalid data returns error changeset" do
      klassen_scoreboard = klassen_scoreboard_fixture()
      assert {:error, %Ecto.Changeset{}} = Ergebnisse.update_klassen_scoreboard(klassen_scoreboard, @invalid_attrs)
      assert klassen_scoreboard == Ergebnisse.get_klassen_scoreboard!(klassen_scoreboard.id)
    end

    test "delete_klassen_scoreboard/1 deletes the klassen_scoreboard" do
      klassen_scoreboard = klassen_scoreboard_fixture()
      assert {:ok, %KlassenScoreboard{}} = Ergebnisse.delete_klassen_scoreboard(klassen_scoreboard)
      assert_raise Ecto.NoResultsError, fn -> Ergebnisse.get_klassen_scoreboard!(klassen_scoreboard.id) end
    end

    test "change_klassen_scoreboard/1 returns a klassen_scoreboard changeset" do
      klassen_scoreboard = klassen_scoreboard_fixture()
      assert %Ecto.Changeset{} = Ergebnisse.change_klassen_scoreboard(klassen_scoreboard)
    end
  end
end
