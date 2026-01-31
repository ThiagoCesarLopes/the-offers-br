defmodule TheOffersBrWeb.Admin.MercadoLivreLive do
  use TheOffersBrWeb, :live_view

  alias Theoffersbr.Integrations

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:integrations, Integrations.list_ml_integrations())
     |> assign(:mappings, Integrations.list_ml_offer_mappings())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Mercado Livre</h1>

      <section class="mt-6">
        <h2 class="text-lg font-medium">Integrações</h2>
        <ul class="mt-2 space-y-2">
          <li :for={integration <- @integrations} class="rounded border p-3">
            <div class="font-medium"><%= integration.app_id %></div>
            <div class="text-xs text-gray-500">Ativa: <%= integration.is_active %></div>
          </li>
        </ul>
      </section>

      <section class="mt-8">
        <h2 class="text-lg font-medium">Mapeamentos</h2>
        <ul class="mt-2 space-y-2">
          <li :for={mapping <- @mappings} class="rounded border p-3">
            <div class="font-medium"><%= mapping.ml_item_id %></div>
            <div class="text-xs text-gray-500">Status: <%= mapping.sync_status || "-" %></div>
          </li>
        </ul>
      </section>
    </div>
    """
  end
end
