defmodule TheoffersbrWeb.Admin.ConfigLive do
  use TheoffersbrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Configurações")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Configurações</h1>
      <p class="text-sm text-gray-500">Configurações administrativas serão migradas.</p>
    </div>
    """
  end
end
