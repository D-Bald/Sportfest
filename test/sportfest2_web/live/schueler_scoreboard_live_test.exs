defmodule Sportfest2Web.SchuelerScoreboardLiveTest do
  use Sportfest2Web.ConnCase

  import Phoenix.LiveViewTest
  import Sportfest2.ErgebnisseFixtures

  @create_attrs %{schueler: "some schueler", scores: "some scores", summe: 42}
  @update_attrs %{schueler: "some updated schueler", scores: "some updated scores", summe: 43}
  @invalid_attrs %{schueler: nil, scores: nil, summe: nil}

  defp create_schueler_scoreboard(_) do
    schueler_scoreboard = schueler_scoreboard_fixture()
    %{schueler_scoreboard: schueler_scoreboard}
  end

  describe "Index" do
    setup [:create_schueler_scoreboard]

    test "lists all schueler_scoreboards", %{conn: conn, schueler_scoreboard: schueler_scoreboard} do
      {:ok, _index_live, html} = live(conn, Routes.schueler_scoreboard_index_path(conn, :index))

      assert html =~ "Listing Schueler scoreboards"
      assert html =~ schueler_scoreboard.schueler
    end

    test "saves new schueler_scoreboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.schueler_scoreboard_index_path(conn, :index))

      assert index_live |> element("a", "New Schueler scoreboard") |> render_click() =~
               "New Schueler scoreboard"

      assert_patch(index_live, Routes.schueler_scoreboard_index_path(conn, :new))

      assert index_live
             |> form("#schueler_scoreboard-form", schueler_scoreboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#schueler_scoreboard-form", schueler_scoreboard: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.schueler_scoreboard_index_path(conn, :index))

      assert html =~ "Schueler scoreboard created successfully"
      assert html =~ "some schueler"
    end

    test "updates schueler_scoreboard in listing", %{conn: conn, schueler_scoreboard: schueler_scoreboard} do
      {:ok, index_live, _html} = live(conn, Routes.schueler_scoreboard_index_path(conn, :index))

      assert index_live |> element("#schueler_scoreboard-#{schueler_scoreboard.id} a", "Edit") |> render_click() =~
               "Edit Schueler scoreboard"

      assert_patch(index_live, Routes.schueler_scoreboard_index_path(conn, :edit, schueler_scoreboard))

      assert index_live
             |> form("#schueler_scoreboard-form", schueler_scoreboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#schueler_scoreboard-form", schueler_scoreboard: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.schueler_scoreboard_index_path(conn, :index))

      assert html =~ "Schueler scoreboard updated successfully"
      assert html =~ "some updated schueler"
    end

    test "deletes schueler_scoreboard in listing", %{conn: conn, schueler_scoreboard: schueler_scoreboard} do
      {:ok, index_live, _html} = live(conn, Routes.schueler_scoreboard_index_path(conn, :index))

      assert index_live |> element("#schueler_scoreboard-#{schueler_scoreboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#schueler_scoreboard-#{schueler_scoreboard.id}")
    end
  end

  describe "Show" do
    setup [:create_schueler_scoreboard]

    test "displays schueler_scoreboard", %{conn: conn, schueler_scoreboard: schueler_scoreboard} do
      {:ok, _show_live, html} = live(conn, Routes.schueler_scoreboard_show_path(conn, :show, schueler_scoreboard))

      assert html =~ "Show Schueler scoreboard"
      assert html =~ schueler_scoreboard.schueler
    end

    test "updates schueler_scoreboard within modal", %{conn: conn, schueler_scoreboard: schueler_scoreboard} do
      {:ok, show_live, _html} = live(conn, Routes.schueler_scoreboard_show_path(conn, :show, schueler_scoreboard))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Schueler scoreboard"

      assert_patch(show_live, Routes.schueler_scoreboard_show_path(conn, :edit, schueler_scoreboard))

      assert show_live
             |> form("#schueler_scoreboard-form", schueler_scoreboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#schueler_scoreboard-form", schueler_scoreboard: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.schueler_scoreboard_show_path(conn, :show, schueler_scoreboard))

      assert html =~ "Schueler scoreboard updated successfully"
      assert html =~ "some updated schueler"
    end
  end
end
