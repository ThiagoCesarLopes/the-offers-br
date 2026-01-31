defmodule TheOffersBrWeb.LogoPreviewLive do
  use TheOffersBrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Logo Preview")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Logo Preview</h1>
      <p class="text-sm text-gray-500">Página de pré-visualização de logo.</p>
    </div>
    """
  end
end
