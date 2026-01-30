defmodule TheoffersbrWeb.AuthLive do
  use TheoffersbrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Autenticação")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-2xl font-semibold">Autenticação</h1>
      <p class="text-sm text-gray-500">
        Fluxo de autenticação será migrado do Supabase para Phoenix.
      </p>
    </div>
    """
  end
end
