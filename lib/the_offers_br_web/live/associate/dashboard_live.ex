defmodule TheOffersBrWeb.Associate.DashboardLive do
  use TheOffersBrWeb, :live_view

  alias Theoffersbr.Catalog

  @impl true
  def mount(_params, _session, socket) do
    offers = Catalog.list_offers(active: true)
    {:ok, assign(socket, offers: offers)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Dashboard do Associado</h1>
      <p class="text-sm text-gray-500">Resumo das ofertas disponíveis.</p>

      <ul class="mt-4 space-y-2">
        <li :for={offer <- @offers} class="rounded border p-3">
          <div class="font-medium"><%= offer.title %></div>
          <div class="text-xs text-gray-500">R$ <%= offer.current_price %></div>
        </li>
      </ul>
    </div>
    """
  end
end
