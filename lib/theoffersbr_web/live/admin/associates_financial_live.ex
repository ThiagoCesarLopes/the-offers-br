defmodule TheoffersbrWeb.Admin.AssociatesFinancialLive do
  use TheoffersbrWeb, :live_view

  alias Theoffersbr.Analytics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, clicks: Analytics.list_offer_clicks())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Financeiro dos Associados</h1>
      <ul class="mt-4 space-y-2">
        <li :for={click <- @clicks} class="rounded border p-3">
          <div class="text-sm">Associate: <%= click.associate_id || "-" %></div>
          <div class="text-xs text-gray-500">Conversão: <%= click.converted %></div>
        </li>
      </ul>
    </div>
    """
  end
end
