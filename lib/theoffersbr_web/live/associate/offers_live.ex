defmodule TheoffersbrWeb.Associate.OffersLive do
  use TheoffersbrWeb, :live_view

  alias Theoffersbr.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, offers: Catalog.list_offers(active: true))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Ofertas do Associado</h1>
      <ul class="mt-4 space-y-2">
        <li :for={offer <- @offers} class="rounded border p-3">
          <div class="font-medium"><%= offer.title %></div>
          <div class="text-xs text-gray-500">Desconto: <%= offer.discount || 0 %>%</div>
        </li>
      </ul>
    </div>
    """
  end
end
