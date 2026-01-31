defmodule TheOffersBrWeb.Admin.LojasLive do
  use TheOffersBrWeb, :live_view

  alias Theoffersbr.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, stores: Catalog.list_stores())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Lojas</h1>
      <ul class="mt-4 space-y-2">
        <li :for={store <- @stores} class="rounded border p-3">
          <div class="font-medium"><%= store.name %></div>
          <div class="text-xs text-gray-500"><%= store.store_type %></div>
        </li>
      </ul>
    </div>
    """
  end
end
