defmodule Sportfest.Repo do
  use Ecto.Repo,
    otp_app: :Sportfest,
    adapter: Ecto.Adapters.Postgres
end
