defmodule TheoffersbrWeb.IndexLive do
  use TheoffersbrWeb, :live_view

  alias Theoffersbr.Catalog

  @impl true
  def mount(_params, _session, socket) do
    categories = Catalog.list_active_categories()
    offers = Catalog.list_offers(active: true)

    {:ok,
     socket
     |> assign(:page_title, "TheOffersBR")
     |> assign(:categories, categories)
     |> assign(:offers, offers)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-3xl font-bold">TheOffersBR</h1>
      <p class="text-sm text-gray-500">Migrado para Phoenix LiveView</p>

      <section class="mt-8">
        <h2 class="text-xl font-semibold">Categorias</h2>
        <ul class="mt-4 grid grid-cols-1 gap-2 md:grid-cols-3">
          <li :for={category <- @categories} class="rounded border p-3">
            <div class="font-medium"><%= category.name %></div>
            <div class="text-xs text-gray-500"><%= category.icon || "" %></div>
          </li>
        </ul>
      </section>

      <section class="mt-10">
        <h2 class="text-xl font-semibold">Ofertas</h2>
        <ul class="mt-4 grid grid-cols-1 gap-4 md:grid-cols-3">
          <li :for={offer <- @offers} class="rounded border p-3">
            <div class="font-medium"><%= offer.title %></div>
            <div class="text-sm text-gray-600">R$ <%= offer.current_price %></div>
            <div class="text-xs text-gray-500">Desconto: <%= offer.discount || 0 %>%</div>
          </li>
        </ul>
      </section>
    </div>
    """
  end
end
