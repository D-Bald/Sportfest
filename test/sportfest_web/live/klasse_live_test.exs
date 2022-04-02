defmodule SportfestWeb.KlasseLiveTest do
  use SportfestWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sportfest.VorbereitungFixtures

  @create_attrs %{scores: "some scores", name: "some name", schueler: "some schueler", summe: 42}
  @update_attrs %{scores: "some updated scores", name: "some updated name", schueler: "some updated schueler", summe: 43}
  @invalid_attrs %{scores: nil, name: nil, schueler: nil, summe: nil}

  defp create_klasse(_) do
    klasse = klasse_fixture()
    %{klasse: klasse}
  end

  describe "Index" do
    setup [:create_klasse]

    test "lists all klassen", %{conn: conn, klasse: klasse} do
      {:ok, _index_live, html} = live(conn, Routes.klasse_index_path(conn, :index))

      assert html =~ "Listing Klassen"
      assert html =~ klasse.scores
    end

    test "saves new klasse", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.klasse_index_path(conn, :index))

      assert index_live |> element("a", "New Klasse") |> render_click() =~
               "New Klasse"

      assert_patch(index_live, Routes.klasse_index_path(conn, :new))

      assert index_live
             |> form("#klasse-form", klasse: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#klasse-form", klasse: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.klasse_index_path(conn, :index))

      assert html =~ "Klasse created successfully"
      assert html =~ "some scores"
    end

    test "updates klasse in listing", %{conn: conn, klasse: klasse} do
      {:ok, index_live, _html} = live(conn, Routes.klasse_index_path(conn, :index))

      assert index_live |> element("#klasse-#{klasse.id} a", "Edit") |> render_click() =~
               "Edit Klasse"

      assert_patch(index_live, Routes.klasse_index_path(conn, :edit, klasse))

      assert index_live
             |> form("#klasse-form", klasse: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#klasse-form", klasse: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.klasse_index_path(conn, :index))

      assert html =~ "Klasse updated successfully"
      assert html =~ "some updated scores"
    end

    test "deletes klasse in listing", %{conn: conn, klasse: klasse} do
      {:ok, index_live, _html} = live(conn, Routes.klasse_index_path(conn, :index))

      assert index_live |> element("#klasse-#{klasse.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#klasse-#{klasse.id}")
    end
  end

  describe "Show" do
    setup [:create_klasse]

    test "displays klasse", %{conn: conn, klasse: klasse} do
      {:ok, _show_live, html} = live(conn, Routes.klasse_show_path(conn, :show, klasse))

      assert html =~ "Show Klasse"
      assert html =~ klasse.scores
    end

    test "updates klasse within modal", %{conn: conn, klasse: klasse} do
      {:ok, show_live, _html} = live(conn, Routes.klasse_show_path(conn, :show, klasse))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Klasse"

      assert_patch(show_live, Routes.klasse_show_path(conn, :edit, klasse))

      assert show_live
             |> form("#klasse-form", klasse: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#klasse-form", klasse: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.klasse_show_path(conn, :show, klasse))

      assert html =~ "Klasse updated successfully"
      assert html =~ "some updated scores"
    end
  end
end
