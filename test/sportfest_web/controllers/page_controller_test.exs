defmodule SportfestWeb.PageControllerTest do
  use SportfestWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Amselympia"
  end
end
