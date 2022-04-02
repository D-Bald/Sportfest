defmodule Sportfest.VorbereitungTest do
  use Sportfest.DataCase

  alias Sportfest.Vorbereitung

  describe "stationen" do
    alias Sportfest.Vorbereitung.Station

    import Sportfest.VorbereitungFixtures

    @invalid_attrs %{bronze: nil, gold: nil, name: nil, silber: nil}

    test "list_stationen/0 returns all stationen" do
      station = station_fixture()
      assert Vorbereitung.list_stationen() == [station]
    end

    test "get_station!/1 returns the station with given id" do
      station = station_fixture()
      assert Vorbereitung.get_station!(station.id) == station
    end

    test "create_station/1 with valid data creates a station" do
      valid_attrs = %{bronze: 42, gold: 42, name: "some name", silber: 42}

      assert {:ok, %Station{} = station} = Vorbereitung.create_station(valid_attrs)
      assert station.bronze == 42
      assert station.gold == 42
      assert station.name == "some name"
      assert station.silber == 42
    end

    test "create_station/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vorbereitung.create_station(@invalid_attrs)
    end

    test "update_station/2 with valid data updates the station" do
      station = station_fixture()
      update_attrs = %{bronze: 43, gold: 43, name: "some updated name", silber: 43}

      assert {:ok, %Station{} = station} = Vorbereitung.update_station(station, update_attrs)
      assert station.bronze == 43
      assert station.gold == 43
      assert station.name == "some updated name"
      assert station.silber == 43
    end

    test "update_station/2 with invalid data returns error changeset" do
      station = station_fixture()
      assert {:error, %Ecto.Changeset{}} = Vorbereitung.update_station(station, @invalid_attrs)
      assert station == Vorbereitung.get_station!(station.id)
    end

    test "delete_station/1 deletes the station" do
      station = station_fixture()
      assert {:ok, %Station{}} = Vorbereitung.delete_station(station)
      assert_raise Ecto.NoResultsError, fn -> Vorbereitung.get_station!(station.id) end
    end

    test "change_station/1 returns a station changeset" do
      station = station_fixture()
      assert %Ecto.Changeset{} = Vorbereitung.change_station(station)
    end
  end

  describe "klassen" do
    alias Sportfest.Vorbereitung.Klasse

    import Sportfest.VorbereitungFixtures

    @invalid_attrs %{scores: nil, name: nil, schueler: nil, summe: nil}

    test "list_klassen/0 returns all klassen" do
      klasse = klasse_fixture()
      assert Vorbereitung.list_klassen() == [klasse]
    end

    test "get_klasse!/1 returns the klasse with given id" do
      klasse = klasse_fixture()
      assert Vorbereitung.get_klasse!(klasse.id) == klasse
    end

    test "create_klasse/1 with valid data creates a klasse" do
      valid_attrs = %{scores: "some scores", name: "some name", schueler: "some schueler", summe: 42}

      assert {:ok, %Klasse{} = klasse} = Vorbereitung.create_klasse(valid_attrs)
      assert klasse.scores == "some scores"
      assert klasse.name == "some name"
      assert klasse.schueler == "some schueler"
      assert klasse.summe == 42
    end

    test "create_klasse/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vorbereitung.create_klasse(@invalid_attrs)
    end

    test "update_klasse/2 with valid data updates the klasse" do
      klasse = klasse_fixture()
      update_attrs = %{scores: "some updated scores", name: "some updated name", schueler: "some updated schueler", summe: 43}

      assert {:ok, %Klasse{} = klasse} = Vorbereitung.update_klasse(klasse, update_attrs)
      assert klasse.scores == "some updated scores"
      assert klasse.name == "some updated name"
      assert klasse.schueler == "some updated schueler"
      assert klasse.summe == 43
    end

    test "update_klasse/2 with invalid data returns error changeset" do
      klasse = klasse_fixture()
      assert {:error, %Ecto.Changeset{}} = Vorbereitung.update_klasse(klasse, @invalid_attrs)
      assert klasse == Vorbereitung.get_klasse!(klasse.id)
    end

    test "delete_klasse/1 deletes the klasse" do
      klasse = klasse_fixture()
      assert {:ok, %Klasse{}} = Vorbereitung.delete_klasse(klasse)
      assert_raise Ecto.NoResultsError, fn -> Vorbereitung.get_klasse!(klasse.id) end
    end

    test "change_klasse/1 returns a klasse changeset" do
      klasse = klasse_fixture()
      assert %Ecto.Changeset{} = Vorbereitung.change_klasse(klasse)
    end
  end

  describe "schueler" do
    alias Sportfest.Vorbereitung.Schueler

    import Sportfest.VorbereitungFixtures

    @invalid_attrs %{jahrgang: nil, klasse: nil, name: nil, scores: nil}

    test "list_schueler/0 returns all schueler" do
      schueler = schueler_fixture()
      assert Vorbereitung.list_schueler() == [schueler]
    end

    test "get_schueler!/1 returns the schueler with given id" do
      schueler = schueler_fixture()
      assert Vorbereitung.get_schueler!(schueler.id) == schueler
    end

    test "create_schueler/1 with valid data creates a schueler" do
      valid_attrs = %{jahrgang: "some jahrgang", klasse: "some klasse", name: "some name", scores: "some scores"}

      assert {:ok, %Schueler{} = schueler} = Vorbereitung.create_schueler(valid_attrs)
      assert schueler.jahrgang == "some jahrgang"
      assert schueler.klasse == "some klasse"
      assert schueler.name == "some name"
      assert schueler.scores == "some scores"
    end

    test "create_schueler/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vorbereitung.create_schueler(@invalid_attrs)
    end

    test "update_schueler/2 with valid data updates the schueler" do
      schueler = schueler_fixture()
      update_attrs = %{jahrgang: "some updated jahrgang", klasse: "some updated klasse", name: "some updated name", scores: "some updated scores"}

      assert {:ok, %Schueler{} = schueler} = Vorbereitung.update_schueler(schueler, update_attrs)
      assert schueler.jahrgang == "some updated jahrgang"
      assert schueler.klasse == "some updated klasse"
      assert schueler.name == "some updated name"
      assert schueler.scores == "some updated scores"
    end

    test "update_schueler/2 with invalid data returns error changeset" do
      schueler = schueler_fixture()
      assert {:error, %Ecto.Changeset{}} = Vorbereitung.update_schueler(schueler, @invalid_attrs)
      assert schueler == Vorbereitung.get_schueler!(schueler.id)
    end

    test "delete_schueler/1 deletes the schueler" do
      schueler = schueler_fixture()
      assert {:ok, %Schueler{}} = Vorbereitung.delete_schueler(schueler)
      assert_raise Ecto.NoResultsError, fn -> Vorbereitung.get_schueler!(schueler.id) end
    end

    test "change_schueler/1 returns a schueler changeset" do
      schueler = schueler_fixture()
      assert %Ecto.Changeset{} = Vorbereitung.change_schueler(schueler)
    end
  end
end
