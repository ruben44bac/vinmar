defmodule Vinmar.Repo do
  use Ecto.Repo,
    otp_app: :vinmar,
    adapter: Ecto.Adapters.Postgres
end
