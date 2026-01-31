defmodule TheOffersBrWeb do
  @moduledoc """
  The entrypoint for defining the web interface.
  """

  def static_paths do
    ~w(assets fonts images favicon.ico robots.txt)
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: TheOffersBrWeb.Layouts]

      import Plug.Conn
      import TheOffersBrWeb.Gettext
      alias TheOffersBrWeb.Router.Helpers, as: Routes
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.Component
      import Phoenix.LiveView.Helpers
      import TheOffersBrWeb.Icon
      import TheOffersBrWeb.BrandLogo
      import TheOffersBrWeb.Gettext
      alias TheOffersBrWeb.Router.Helpers, as: Routes
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {TheOffersBrWeb.Layouts, :app}

      unquote(html())
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import TheOffersBrWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
