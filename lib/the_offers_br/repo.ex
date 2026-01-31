defmodule TheOffersBr.Repo do
  use Ecto.Repo,
    otp_app: :the_offers_br,
    adapter: Ecto.Adapters.Postgres
end
