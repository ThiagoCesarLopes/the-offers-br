defmodule TheOffersBrWeb.Router do
  use TheOffersBrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", TheOffersBrWeb do
    pipe_through :browser

    live_session :default do
      live "/", PageLive, :home
    end
  end
end
