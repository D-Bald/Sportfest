defmodule SportfestWeb.KlassenScoreboardLiveTest do
  use SportfestWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sportfest.ErgebnisseFixtures

  @create_attrs %{klasse: "some klasse", scores: "some scores", summe: 42}
  @update_attrs %{klasse: "some updated klasse", scores: "some updated scores", summe: 43}
  @invalid_attrs %{klasse: nil, scores: nil, summe: nil}

  defp create_klassen_scoreboard(_) do
    klassen_scoreboard = klassen_scoreboard_fixture()
    %{klassen_scoreboard: klassen_scoreboard}
  end

  describe "Index" do
    setup [:create_klassen_scoreboard]

    test "lists all klassen_scoreboards", %{conn: conn, klassen_scoreboard: klassen_scoreboard} do
      {:ok, _index_live, html} = live(conn, Routes.klassen_scoreboard_index_path(conn, :index))

      assert html =~ "Listing Klassen scoreboards"
      assert html =~ klassen_scoreboard.klasse
    end

    test "saves new klassen_scoreboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.klassen_scoreboard_index_path(conn, :index))

      assert index_live |> element("a", "New Klassen scoreboard") |> render_click() =~
               "New Klassen scoreboard"

      assert_patch(index_live, Routes.klassen_scoreboard_index_path(conn, :new))

      assert index_live
             |> form("#klassen_scoreboard-form", klassen_scoreboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#klassen_scoreboard-form", klassen_scoreboard: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.klassen_scoreboard_index_path(conn, :index))

      assert html =~ "Klassen scoreboard created successfully"
      assert html =~ "some klasse"
    end

    test "updates klassen_scoreboard in listing", %{conn: conn, klassen_scoreboard: klassen_scoreboard} do
      {:ok, index_live, _html} = live(conn, Routes.klassen_scoreboard_index_path(conn, :index))

      assert index_live |> element("#klassen_scoreboard-#{klassen_scoreboard.id} a", "Edit") |> render_click() =~
               "Edit Klassen scoreboard"

      assert_patch(index_live, Routes.klassen_scoreboard_index_path(conn, :edit, klassen_scoreboard))

      assert index_live
             |> form("#klassen_scoreboard-form", klassen_scoreboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#klassen_scoreboard-form", klassen_scoreboard: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.klassen_scoreboard_index_path(conn, :index))

      assert html =~ "Klassen scoreboard updated successfully"
      assert html =~ "some updated klasse"
    end

    test "deletes klassen_scoreboard in listing", %{conn: conn, klassen_scoreboard: klassen_scoreboard} do
      {:ok, index_live, _html} = live(conn, Routes.klassen_scoreboard_index_path(conn, :index))

      assert index_live |> element("#klassen_scoreboard-#{klassen_scoreboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#klassen_scoreboard-#{klassen_scoreboard.id}")
    end
  end

  describe "Show" do
    setup [:create_klassen_scoreboard]

    test "displays klassen_scoreboard", %{conn: conn, klassen_scoreboard: klassen_scoreboard} do
      {:ok, _show_live, html} = live(conn, Routes.klassen_scoreboard_show_path(conn, :show, klassen_scoreboard))

      assert html =~ "Show Klassen scoreboard"
      assert html =~ klassen_scoreboard.klasse
    end

    test "updates klassen_scoreboard within modal", %{conn: conn, klassen_scoreboard: klassen_scoreboard} do
      {:ok, show_live, _html} = live(conn, Routes.klassen_scoreboard_show_path(conn, :show, klassen_scoreboard))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Klassen scoreboard"

      assert_patch(show_live, Routes.klassen_scoreboard_show_path(conn, :edit, klassen_scoreboard))

      assert show_live
             |> form("#klassen_scoreboard-form", klassen_scoreboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#klassen_scoreboard-form", klassen_scoreboard: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.klassen_scoreboard_show_path(conn, :show, klassen_scoreboard))

      assert html =~ "Klassen scoreboard updated successfully"
      assert html =~ "some updated klasse"
    end
  end
end
