# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config


# General application configuration
config :the_offers_br,
  ecto_repos: [TheOffersBr.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configure the endpoint
config :the_offers_br, TheOffersBrWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: TheOffersBrWeb.ErrorHTML, json: TheOffersBrWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Theoffersbr.PubSub,
  live_view: [signing_salt: "DY4JiT2N"]

# Configure the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :the_offers_br, TheOffersBr.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  the_offers_br: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.12",
  the_offers_br: [
    args: ~w(
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

import_config "#{config_env()}.exs"
config :phoenix_live_view, :colocated_js,
  disable_symlink_warning: true

  config :the_offers_br, TheOffersBrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CHANGE_ME",
  render_errors: [
    formats: [html: TheOffersBrWeb.ErrorHTML, json: TheOffersBrWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TheOffersBr.PubSub,
  live_view: [signing_salt: "CHANGE_ME"]

