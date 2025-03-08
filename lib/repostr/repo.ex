defmodule Repostr.Repo do
  use Ecto.Repo,
    otp_app: :repostr,
    adapter: Ecto.Adapters.Postgres
end
