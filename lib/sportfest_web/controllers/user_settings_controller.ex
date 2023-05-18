defmodule SportfestWeb.UserSettingsController do
  use SportfestWeb, :controller

  alias Sportfest.Accounts
  alias SportfestWeb.UserAuth

  plug :assign_user_email_and_password_changesets_if_id_is_passed

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        {:ok, token} = Accounts.token_for_update_email_confirmation(
          applied_user,
          user.email
        )

        conn
        |> confirm_email(%{"token" => token})

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Passwort erfolgreich geändert.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit, user))
        |> log_in_if_updated_current_user

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email erfolgreich geändert.")
        |> redirect(to: Routes.user_settings_path(conn, :edit, conn.assigns.user))

      :error ->
        conn
        |> put_flash(:error, "Link zur Änderung der Email Adresse ist nicht gültig oder ausgelaufen.")
        |> redirect(to: Routes.user_settings_path(conn, :edit, conn.assigns.user))
    end
  end


  defp assign_user_email_and_password_changesets_if_id_is_passed(conn, _opts) do
    with %{"id" => id} <- conn.path_params do
      user = Accounts.get_user!(id)

      conn
      |> assign(:user, user)
      |> assign(:email_changeset, Accounts.change_user_email(user))
      |> assign(:password_changeset, Accounts.change_user_password(user))
    else
      _ -> conn
    end
  end

  defp log_in_if_updated_current_user(conn) do
    if conn.assigns.user == conn.assigns.current_user do
      UserAuth.log_in_user(conn, conn.assigns.user)
    else
      redirect(conn, to: Routes.user_settings_path(conn, :edit, conn.assigns.user))
    end
  end
end
