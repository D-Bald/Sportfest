defmodule Sportfest.ErgebnisseTest do
  use Sportfest.DataCase

  alias Sportfest.Ergebnisse
  alias Sportfest.Ergebnisse.Score
  import Sportfest.ErgebnisseFixtures
  import Sportfest.VorbereitungFixtures

  describe "scores" do
    @invalid_attrs %{medaille: :some_atom}

    setup [:create_valid_required_assoc_attrs]

    test "list_scores/0 returns all scores", %{valid_attrs: valid_attrs} do
      score = score_fixture(valid_attrs)

      # Compares list of score ids, because `list_scores` does preload the associations in contrast to the freshly built score
      assert Ergebnisse.list_scores() |> Enum.map(fn score -> score.id end)
          == [score]                  |> Enum.map(fn score -> score.id end)
    end

    test "get_score!/1 returns the score with given id", %{valid_attrs: valid_attrs} do

      score = score_fixture(valid_attrs)
      # Compares score ids, because `get_score!` does preload the associations in contrast to the freshly built score
      assert Ergebnisse.get_score!(score.id).id == score.id
    end

    test "create_score/1 with valid data creates a score", %{valid_attrs: valid_attrs} do

      assert {:ok, %Score{} = score} = Ergebnisse.create_score(valid_attrs)
      assert score.medaille == :keine # Default value

      # Get score from db, so that associations to klasse and station have been established
      score = Ergebnisse.get_score!(score.id)
      assert score.klasse.id == valid_attrs[:klasse_id]
      assert score.station.id == valid_attrs[:station_id]
    end

    test "create_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ergebnisse.create_score(@invalid_attrs)
    end

    test "update_score/2 with valid `medaille` value updates the score", %{valid_attrs: valid_attrs} do

      score = score_fixture(valid_attrs)
      update_attrs = %{medaille: :bronze}

      assert {:ok, %Score{} = score} = Ergebnisse.update_score(score, update_attrs)
      assert score.medaille == :bronze
    end

    test "update_score/2 with invalid data returns error changeset", %{valid_attrs: valid_attrs} do
      score = score_fixture(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Ergebnisse.update_score(score, @invalid_attrs)
      assert Ergebnisse.get_score!(score.id).medaille == score.medaille
    end

    test "delete_score/1 deletes the score", %{valid_attrs: valid_attrs} do
      score = score_fixture(valid_attrs)
      assert {:ok, %Score{}} = Ergebnisse.delete_score(score)
      assert_raise Ecto.NoResultsError, fn -> Ergebnisse.get_score!(score.id) end
    end

    test "change_score/1 returns a score changeset", %{valid_attrs: valid_attrs} do
      score = score_fixture(valid_attrs)
      assert %Ecto.Changeset{} = Ergebnisse.change_score(score)
    end
  end

  defp create_valid_required_assoc_attrs(_) do
    %{valid_attrs: %{klasse_id: klasse_fixture().id, station_id: station_fixture().id}}
  end

end
