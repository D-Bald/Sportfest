defmodule SportfestWeb.PageController do
  use SportfestWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
