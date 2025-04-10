# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :vinmar,
  ecto_repos: [Vinmar.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :vinmar, VinmarWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: VinmarWeb.ErrorHTML, json: VinmarWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Vinmar.PubSub,
  live_view: [signing_salt: "Bqq6GFWT"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :vinmar, Vinmar.Mailer, adapter: Swoosh.Adapters.Local

config :vinmar, carbonite_mode: :capture

config :ex_cldr,
  default_locale: "en",
  json_library: Jason

config :ex_money,
  exchange_rates_retrieve_every: 300_000,
  api_module: Money.ExchangeRates.OpenExchangeRates,
  callback_module: Money.ExchangeRates.Callback,
  exchange_rates_cache_module: Money.ExchangeRates.Cache.Ets,
  preload_historic_rates: nil,
  retriever_options: nil,
  log_failure: :warning,
  log_info: :info,
  log_success: nil,
  json_library: Jason,
  default_cldr_backend: Vinmar.Cldr,
  exclude_protocol_implementations: []

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  vinmar: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  vinmar: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
