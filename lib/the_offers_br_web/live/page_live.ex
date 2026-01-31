defmodule TheOffersBrWeb.PageLive do
  use TheOffersBrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Home")
     |> assign(:offers, [])}
  end
end
