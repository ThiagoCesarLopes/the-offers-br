defmodule TheoffersbrWeb.Admin.OfertasLive do
  use TheoffersbrWeb, :live_view

  alias Theoffersbr.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, offers: Catalog.list_offers())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Ofertas</h1>
      <ul class="mt-4 space-y-2">
        <li :for={offer <- @offers} class="rounded border p-3">
          <div class="font-medium"><%= offer.title %></div>
          <div class="text-sm text-gray-500">R$ <%= offer.current_price %></div>
        </li>
      </ul>
    </div>
    """
  end
end
