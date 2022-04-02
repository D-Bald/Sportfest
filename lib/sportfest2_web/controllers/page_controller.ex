defmodule Sportfest2Web.PageController do
  use Sportfest2Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
