defmodule TheoffersbrWeb.Admin.DashboardLive do
  use TheoffersbrWeb, :live_view

  alias Theoffersbr.Catalog
  alias Theoffersbr.Analytics

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Admin - Dashboard")
     |> assign(:offers_count, length(Catalog.list_offers()))
     |> assign(:clicks_count, length(Analytics.list_offer_clicks()))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Dashboard</h1>
      <div class="mt-6 grid grid-cols-1 gap-4 md:grid-cols-2">
        <div class="rounded border p-4">
          <div class="text-sm text-gray-500">Ofertas</div>
          <div class="text-2xl font-semibold"><%= @offers_count %></div>
        </div>
        <div class="rounded border p-4">
          <div class="text-sm text-gray-500">Cliques</div>
          <div class="text-2xl font-semibold"><%= @clicks_count %></div>
        </div>
      </div>
    </div>
    """
  end
end
