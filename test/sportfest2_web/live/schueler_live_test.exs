defmodule Sportfest2Web.SchuelerLiveTest do
  use Sportfest2Web.ConnCase

  import Phoenix.LiveViewTest
  import Sportfest2.VorbereitungFixtures

  @create_attrs %{jahrgang: "some jahrgang", klasse: "some klasse", name: "some name", schueler_scoreboard: "some schueler_scoreboard"}
  @update_attrs %{jahrgang: "some updated jahrgang", klasse: "some updated klasse", name: "some updated name", schueler_scoreboard: "some updated schueler_scoreboard"}
  @invalid_attrs %{jahrgang: nil, klasse: nil, name: nil, schueler_scoreboard: nil}

  defp create_schueler(_) do
    schueler = schueler_fixture()
    %{schueler: schueler}
  end

  describe "Index" do
    setup [:create_schueler]

    test "lists all schueler", %{conn: conn, schueler: schueler} do
      {:ok, _index_live, html} = live(conn, Routes.schueler_index_path(conn, :index))

      assert html =~ "Listing Schueler"
      assert html =~ schueler.jahrgang
    end

    test "saves new schueler", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.schueler_index_path(conn, :index))

      assert index_live |> element("a", "New Schueler") |> render_click() =~
               "New Schueler"

      assert_patch(index_live, Routes.schueler_index_path(conn, :new))

      assert index_live
             |> form("#schueler-form", schueler: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#schueler-form", schueler: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.schueler_index_path(conn, :index))

      assert html =~ "Schueler created successfully"
      assert html =~ "some jahrgang"
    end

    test "updates schueler in listing", %{conn: conn, schueler: schueler} do
      {:ok, index_live, _html} = live(conn, Routes.schueler_index_path(conn, :index))

      assert index_live |> element("#schueler-#{schueler.id} a", "Edit") |> render_click() =~
               "Edit Schueler"

      assert_patch(index_live, Routes.schueler_index_path(conn, :edit, schueler))

      assert index_live
             |> form("#schueler-form", schueler: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#schueler-form", schueler: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.schueler_index_path(conn, :index))

      assert html =~ "Schueler updated successfully"
      assert html =~ "some updated jahrgang"
    end

    test "deletes schueler in listing", %{conn: conn, schueler: schueler} do
      {:ok, index_live, _html} = live(conn, Routes.schueler_index_path(conn, :index))

      assert index_live |> element("#schueler-#{schueler.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#schueler-#{schueler.id}")
    end
  end

  describe "Show" do
    setup [:create_schueler]

    test "displays schueler", %{conn: conn, schueler: schueler} do
      {:ok, _show_live, html} = live(conn, Routes.schueler_show_path(conn, :show, schueler))

      assert html =~ "Show Schueler"
      assert html =~ schueler.jahrgang
    end

    test "updates schueler within modal", %{conn: conn, schueler: schueler} do
      {:ok, show_live, _html} = live(conn, Routes.schueler_show_path(conn, :show, schueler))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Schueler"

      assert_patch(show_live, Routes.schueler_show_path(conn, :edit, schueler))

      assert show_live
             |> form("#schueler-form", schueler: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#schueler-form", schueler: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.schueler_show_path(conn, :show, schueler))

      assert html =~ "Schueler updated successfully"
      assert html =~ "some updated jahrgang"
    end
  end
end
