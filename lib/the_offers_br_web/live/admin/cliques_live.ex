defmodule TheOffersBrWeb.Admin.CliquesLive do
  use TheOffersBrWeb, :live_view

  alias Theoffersbr.Analytics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, clicks: Analytics.list_offer_clicks())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Cliques</h1>
      <ul class="mt-4 space-y-2">
        <li :for={click <- @clicks} class="rounded border p-3">
          <div class="text-sm text-gray-500">Offer: <%= click.offer_id %></div>
          <div class="text-xs">Sessão: <%= click.session_id || "-" %></div>
        </li>
      </ul>
    </div>
    """
  end
end
