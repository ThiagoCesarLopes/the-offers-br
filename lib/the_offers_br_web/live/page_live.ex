defmodule TheOffersBrWeb.PageLive do
  use TheOffersBrWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Home")}
  end
end
