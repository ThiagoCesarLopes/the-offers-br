defmodule TheoffersbrWeb.AuthLive do
  use TheoffersbrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Autenticação")}
  end

  @impl true
  def handle_event("login", _params, socket) do
    {:noreply, put_flash(socket, :info, "Login em breve. Estamos finalizando a autenticação.")}
  end

  @impl true
  def handle_event("register", _params, socket) do
    {:noreply, put_flash(socket, :info, "Cadastro em breve. Estamos finalizando a autenticação.")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-[calc(100vh-4rem)] flex items-center justify-center bg-gradient-to-br from-primary/10 via-accent/5 to-secondary/10 px-4 py-10">
      <div class="w-full max-w-md">
        <div class="card bg-base-100 border border-base-300 rounded-2xl">
          <div class="card-body p-8">
            <div class="flex flex-col items-center text-center gap-3 mb-6">
              <.brand_logo size="md" show_tagline />
              <p class="text-sm text-base-content/70">
                Entre para salvar favoritos e comparar ofertas.
              </p>
            </div>

            <.form for={%{}} phx-submit="login" class="space-y-4">
              <div>
                <label class="label" for="email">
                  <span class="label-text">E-mail</span>
                </label>
                <input
                  id="email"
                  type="email"
                  placeholder="voce@email.com"
                  class="input input-bordered w-full rounded-full"
                />
              </div>
              <div>
                <label class="label" for="password">
                  <span class="label-text">Senha</span>
                </label>
                <input
                  id="password"
                  type="password"
                  placeholder="Sua senha"
                  class="input input-bordered w-full rounded-full"
                />
              </div>

              <button type="button" class="btn btn-primary w-full rounded-full">
                Entrar
              </button>
            </.form>

            <div class="divider text-base-content/50">ou</div>

            <div class="space-y-2">
              <button type="button" class="btn btn-outline w-full rounded-full gap-2">
                <.icon name="hero-envelope" class="h-4 w-4" />
                Continuar com e-mail
              </button>
              <button type="button" class="btn btn-secondary w-full rounded-full gap-2" phx-click="register">
                <.icon name="hero-user-plus" class="h-4 w-4" />
                Criar conta
              </button>
            </div>

            <p class="text-xs text-center text-base-content/50 mt-6">
              Ao continuar, você concorda com nossos Termos e Política de Privacidade.
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
