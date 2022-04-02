defmodule Sportfest.Repo do
  use Ecto.Repo,
    otp_app: :sportfest,
    adapter: Ecto.Adapters.Postgres
end
