defmodule SportfestWeb.Router do
  use SportfestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SportfestWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SportfestWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/stationen", StationLive.Index, :index
    live "/stationen/new", StationLive.Index, :new
    live "/stationen/:id/edit", StationLive.Index, :edit

    live "/stationen/:id", StationLive.Show, :show
    live "/stationen/:id/show/edit", StationLive.Show, :edit

    live "/klassen", KlasseLive.Index, :index
    live "/klassen/new", KlasseLive.Index, :new
    live "/klassen/:id/edit", KlasseLive.Index, :edit

    live "/klassen/:id", KlasseLive.Show, :show
    live "/klassen/:id/show/edit", KlasseLive.Show, :edit

    live "/schueler", SchuelerLive.Index, :index
    live "/schueler/new", SchuelerLive.Index, :new
    live "/schueler/:id/edit", SchuelerLive.Index, :edit

    live "/schueler/:id", SchuelerLive.Show, :show
    live "/schueler/:id/show/edit", SchuelerLive.Show, :edit

    live "/schueler_scoreboards", SchuelerScoreboardLive.Index, :index
    live "/schueler_scoreboards/new", SchuelerScoreboardLive.Index, :new
    live "/schueler_scoreboards/:id/edit", SchuelerScoreboardLive.Index, :edit

    live "/schueler_scoreboards/:id", SchuelerScoreboardLive.Show, :show
    live "/schueler_scoreboards/:id/show/edit", SchuelerScoreboardLive.Show, :edit

    live "/klassen_scoreboards", KlassenScoreboardLive.Index, :index
    live "/klassen_scoreboards/new", KlassenScoreboardLive.Index, :new
    live "/klassen_scoreboards/:id/edit", KlassenScoreboardLive.Index, :edit

    live "/klassen_scoreboards/:id", KlassenScoreboardLive.Show, :show
    live "/klassen_scoreboards/:id/show/edit", KlassenScoreboardLive.Show, :edit

    live "/scores", ScoreLive.Index, :index
    live "/scores/new", ScoreLive.Index, :new
    live "/scores/:id/edit", ScoreLive.Index, :edit

    live "/scores/:id", ScoreLive.Show, :show
    live "/scores/:id/show/edit", ScoreLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", SportfestWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SportfestWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
