defmodule TheOffersBrWeb.Admin.CategoriasLive do
  use TheOffersBrWeb, :live_view

  alias Theoffersbr.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, categories: Catalog.list_categories())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Categorias</h1>
      <ul class="mt-4 space-y-2">
        <li :for={category <- @categories} class="rounded border p-3">
          <div class="font-medium"><%= category.name %></div>
          <div class="text-xs text-gray-500"><%= category.icon || "" %></div>
        </li>
      </ul>
    </div>
    """
  end
end
