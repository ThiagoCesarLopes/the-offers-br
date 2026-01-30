defmodule TheoffersbrWeb.Admin.ProfileLive do
  use TheoffersbrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Perfil")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Perfil</h1>
      <p class="text-sm text-gray-500">Tela de perfil administrativo.</p>
    </div>
    """
  end
end
