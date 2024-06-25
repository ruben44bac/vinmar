import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :vinmar, Vinmar.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "vinmar_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vinmar, VinmarWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "k3teMR2qDi5i7/v19xhY8U4OIfcKAASNz2Ot97OYVkb6ULM7XjuzKNBcEnfmDyaM",
  server: false

# In test we don't send emails.
config :vinmar, Vinmar.Mailer, adapter: Swoosh.Adapters.Test

config :vinmar, carbonite_mode: :ignore

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
