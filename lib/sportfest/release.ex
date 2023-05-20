defmodule Sportfest.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :sportfest

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def reset_accounts do
    load_app()
    Application.ensure_all_started(@app)

    Sportfest.Repo.delete_all(Sportfest.Accounts.User)

    create_accounts_by_role()
  end

  def maybe_create_accounts do
    load_app()
    Application.ensure_all_started(@app)

    if Sportfest.Accounts.list_users() == [] do
      create_accounts_by_role()
    end
  end

  defp create_accounts_by_role do
    for role <- ["admin", "moderator", "user"] do
      if not Sportfest.Accounts.exists_user_with_role?(role) do
        email = IO.gets("Gib eine Email-Adresse für den Benutzer mit der Rolle \"#{role}\" ein:\n") |> String.trim()
        password = IO.gets("Setze ein Password für diesen Benutzer (mindestens 12 Zeichen):\n") |> String.trim()

        {:ok, user} = Sportfest.Accounts.register_user(%{email: email, password: password})
        case role do
          "admin" ->
            Sportfest.Accounts.set_admin_role(user)
          "moderator" ->
            Sportfest.Accounts.set_moderator_role(user)
          _ -> {:ok, user}
        end
      end
    end
  end

  def station_backup do
    load_app()
    Application.ensure_all_started(@app)

    Sportfest.Utils.CSVData.export_stationen_to_csv()
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
