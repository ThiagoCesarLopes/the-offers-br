defmodule TheOffersBrWeb.PageLive do
  use TheOffersBrWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Home")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="flex flex-col items-center justify-center min-h-screen">
        <h1 class="text-4xl font-bold mb-4">Bem-vindo ao The Offers BR!</h1>
        <p class="text-lg text-gray-600">Sua aplicação Phoenix está rodando.</p>
      </div>
    </Layouts.app>
    """
  end
end
