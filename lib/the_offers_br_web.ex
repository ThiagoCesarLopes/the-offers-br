defmodule TheOffersBrWeb do
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

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {TheOffersBrWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import TheOffersBrWeb.Gettext
    end
  end

  defp html_helpers do
    quote do
      use Phoenix.HTML
      import Phoenix.LiveView.Helpers
      import Phoenix.Component

      import TheOffersBrWeb.Gettext
      alias TheOffersBrWeb.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
