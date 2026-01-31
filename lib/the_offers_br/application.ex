defmodule TheOffersBr.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Repo (se existir)
      TheOffersBr.Repo,

      # Telemetry
      TheOffersBrWeb.Telemetry,

      # PubSub
      {Phoenix.PubSub, name: TheOffersBr.PubSub},

      # Endpoint
      TheOffersBrWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: TheOffersBr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    TheOffersBrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end