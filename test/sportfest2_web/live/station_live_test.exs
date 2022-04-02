defmodule Sportfest2Web.StationLiveTest do
  use Sportfest2Web.ConnCase

  import Phoenix.LiveViewTest
  import Sportfest2.VorbereitungFixtures

  @create_attrs %{bronze: 42, gold: 42, name: "some name", silber: 42}
  @update_attrs %{bronze: 43, gold: 43, name: "some updated name", silber: 43}
  @invalid_attrs %{bronze: nil, gold: nil, name: nil, silber: nil}

  defp create_station(_) do
    station = station_fixture()
    %{station: station}
  end

  describe "Index" do
    setup [:create_station]

    test "lists all stationen", %{conn: conn, station: station} do
      {:ok, _index_live, html} = live(conn, Routes.station_index_path(conn, :index))

      assert html =~ "Listing Stationen"
      assert html =~ station.name
    end

    test "saves new station", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.station_index_path(conn, :index))

      assert index_live |> element("a", "New Station") |> render_click() =~
               "New Station"

      assert_patch(index_live, Routes.station_index_path(conn, :new))

      assert index_live
             |> form("#station-form", station: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#station-form", station: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.station_index_path(conn, :index))

      assert html =~ "Station created successfully"
      assert html =~ "some name"
    end

    test "updates station in listing", %{conn: conn, station: station} do
      {:ok, index_live, _html} = live(conn, Routes.station_index_path(conn, :index))

      assert index_live |> element("#station-#{station.id} a", "Edit") |> render_click() =~
               "Edit Station"

      assert_patch(index_live, Routes.station_index_path(conn, :edit, station))

      assert index_live
             |> form("#station-form", station: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#station-form", station: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.station_index_path(conn, :index))

      assert html =~ "Station updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes station in listing", %{conn: conn, station: station} do
      {:ok, index_live, _html} = live(conn, Routes.station_index_path(conn, :index))

      assert index_live |> element("#station-#{station.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#station-#{station.id}")
    end
  end

  describe "Show" do
    setup [:create_station]

    test "displays station", %{conn: conn, station: station} do
      {:ok, _show_live, html} = live(conn, Routes.station_show_path(conn, :show, station))

      assert html =~ "Show Station"
      assert html =~ station.name
    end

    test "updates station within modal", %{conn: conn, station: station} do
      {:ok, show_live, _html} = live(conn, Routes.station_show_path(conn, :show, station))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Station"

      assert_patch(show_live, Routes.station_show_path(conn, :edit, station))

      assert show_live
             |> form("#station-form", station: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#station-form", station: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.station_show_path(conn, :show, station))

      assert html =~ "Station updated successfully"
      assert html =~ "some updated name"
    end
  end
end
