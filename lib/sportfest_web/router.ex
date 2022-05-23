defmodule SportfestWeb.Router do
  use SportfestWeb, :router

  import SportfestWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SportfestWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :admin do
    plug :ensure_role, "admin"
  end

  pipeline :moderator do
    plug :ensure_role_or_admin, "moderator"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Scope offen für alle
  scope "/", SportfestWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Scope für eingeloggte User
  scope "/", SportfestWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/leaderboard", LeaderboardLive.Index, :index
    live "/leaderboard/station/:id", LeaderboardLive.Station, :index

    live "/stationen", StationLive.Index, :index
    live "/stationen/:id", StationLive.Show, :show
  end

  # Scopes mit Zugang für bestimmte Rollen
  scope "/", SportfestWeb do
    pipe_through [:browser, :require_authenticated_user, :moderator]

    live "/scores", ScoreLive.Index, :index

    live "/stationen/new", StationLive.Index, :new
    live "/stationen/:id/edit", StationLive.Index, :edit
    live "/stationen/:id/show/edit", StationLive.Show, :edit

    live "/klassen", KlasseLive.Index, :index
    live "/klassen/new", KlasseLive.Index, :new
    live "/klassen/:id/edit", KlasseLive.Index, :edit
    live "/klassen/:id", KlasseLive.Show, :show
    live "/klassen/:id/show/edit", KlasseLive.Show, :edit
  end

  scope "/", SportfestWeb do
    pipe_through [:browser, :require_authenticated_user, :admin]

    live "/schueler", SchuelerLive.Index, :index
    live "/schueler/new", SchuelerLive.Index, :new
    live "/schueler/:id/edit", SchuelerLive.Index, :edit
    live "/schueler/:id", SchuelerLive.Show, :show
    live "/schueler/:id/show/edit", SchuelerLive.Show, :edit
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

  ## Authentication routes
  scope "/", SportfestWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", SportfestWeb do
    pipe_through [:browser, :require_authenticated_user, :admin]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", SportfestWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
