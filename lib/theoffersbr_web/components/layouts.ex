defmodule TheoffersbrWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use TheoffersbrWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col bg-base-100">
      <!-- Header with BrandLogo -->
      <header class="sticky top-0 z-50 bg-base-100/95 backdrop-blur-md border-b border-base-300">
        <div class="container mx-auto px-4">
          <!-- Top bar -->
          <div class="flex items-center justify-between py-3 gap-4">
            <!-- Logo -->
            <a href="/" class="shrink-0">
              <.brand_logo show_tagline class="group" />
            </a>

            <!-- Search - Desktop -->
            <div class="hidden md:flex flex-1 max-w-xl mx-4">
              <div class="relative w-full">
                <.icon name="hero-magnifying-glass" class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-base-content/50" />
                <input
                  type="search"
                  placeholder="Buscar ofertas..."
                  class="input input-bordered w-full pl-10 pr-4 py-2 rounded-full border-2 border-base-300 focus:border-primary transition-colors bg-base-200/50"
                />
              </div>
            </div>

            <!-- Actions -->
            <div class="flex items-center gap-1">
              <!-- Search toggle - Mobile -->
              <button class="btn btn-ghost btn-circle md:hidden">
                <.icon name="hero-magnifying-glass" class="h-5 w-5" />
              </button>

              <!-- Theme Toggle -->
              <.theme_toggle />

              <!-- Favorites -->
              <button class="btn btn-ghost btn-circle">
                <.icon name="hero-heart" class="h-5 w-5" />
              </button>

              <!-- Login -->
              <a href="/auth" class="hidden sm:flex btn btn-ghost rounded-full gap-2">
                <.icon name="hero-user-circle" class="h-5 w-5" />
                Entrar
              </a>
              <a href="/auth" class="btn btn-ghost btn-circle sm:hidden">
                <.icon name="hero-user-circle" class="h-5 w-5" />
              </a>

              <!-- CTA Button -->
              <button class="hidden lg:flex btn btn-primary rounded-full gap-2">
                <.icon name="hero-bell" class="h-4 w-4" />
                Alertas de Ofertas
              </button>
            </div>
          </div>

          <!-- Mobile search -->
          <div class="md:hidden pb-3">
            <div class="relative w-full">
              <.icon name="hero-magnifying-glass" class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-base-content/50" />
              <input
                type="search"
                placeholder="Buscar ofertas..."
                class="input input-bordered w-full pl-10 pr-4 rounded-full border-2 border-base-300 focus:border-primary transition-colors bg-base-200/50"
              />
            </div>
          </div>
        </div>
      </header>

      <!-- Main content -->
      <main class="flex-1">
        {render_slot(@inner_block)}
      </main>

      <!-- Footer -->
      <footer class="bg-base-100 text-base-content">
        <!-- Newsletter section -->
        <div class="bg-primary py-8">
          <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row items-center justify-between gap-6">
              <div class="text-center md:text-left">
                <div class="flex items-center gap-2 mb-2 justify-center md:justify-start">
                  <.icon name="hero-envelope" class="h-6 w-6 text-base-content" />
                  <h3 class="text-xl font-display font-bold text-base-content">
                    Receba as melhores ofertas!
                  </h3>
                </div>
                <p class="text-base-content/80 text-sm">
                  Cadastre-se e seja o primeiro a saber das promoções
                </p>
              </div>
              <div class="flex gap-3 w-full md:w-auto max-w-sm">
                <input
                  type="email"
                  placeholder="Seu melhor e-mail"
                  class="input w-full rounded-full border-0 bg-white text-base-content placeholder:text-[#6b6b6b] h-10 px-4"
                />
                <button class="btn btn-success rounded-full w-10 h-10 min-h-0 p-0 text-white">
                  <.icon name="hero-paper-airplane" class="h-4 w-4" />
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Main footer -->
        <div class="py-12 border-t border-base-300">
          <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-10">
              <!-- Brand -->
              <div>
                <div class="inline-flex items-center gap-1 mb-5">
                  <span class="text-2xl">🏷️</span>
                  <span class="font-display font-bold text-lg">The Offers<span class="text-primary">br</span></span>
                </div>
                <p class="text-sm text-base-content/70 mb-5">
                  Compare e compre! Encontre as melhores ofertas com descontos de até 90% nas melhores lojas.
                </p>
                <!-- Social links -->
                <div class="flex gap-3">
                  <a href="https://www.facebook.com/" target="_blank" class="w-9 h-9 rounded-full bg-base-200 flex items-center justify-center hover:bg-primary hover:text-primary-content transition-colors font-bold text-base">
                    f
                  </a>
                  <a href="https://www.instagram.com/" target="_blank" class="w-9 h-9 rounded-full bg-base-200 flex items-center justify-center hover:bg-primary hover:text-primary-content transition-colors">
                    <.icon name="hero-camera" class="h-5 w-5" />
                  </a>
                  <a href="https://twitter.com/" target="_blank" class="w-9 h-9 rounded-full bg-base-200 flex items-center justify-center hover:bg-primary hover:text-primary-content transition-colors">
                    <.icon name="hero-arrow-top-right-on-square" class="h-5 w-5" />
                  </a>
                  <a href="https://www.youtube.com/" target="_blank" class="w-9 h-9 rounded-full bg-base-200 flex items-center justify-center hover:bg-primary hover:text-primary-content transition-colors">
                    <.icon name="hero-play" class="h-5 w-5" />
                  </a>
                </div>
              </div>

              <!-- Categorias -->
              <div>
                <h4 class="font-display font-bold mb-5 text-base-content">Categorias</h4>
                <ul class="space-y-3 text-sm text-base-content/70">
                  <li><a href="/?category=eletronicos" class="hover:text-primary transition-colors">Eletrônicos</a></li>
                  <li><a href="/?category=moda" class="hover:text-primary transition-colors">Moda</a></li>
                  <li><a href="/?category=casa" class="hover:text-primary transition-colors">Casa</a></li>
                  <li><a href="/?category=beleza" class="hover:text-primary transition-colors">Beleza</a></li>
                  <li><a href="/?category=esportes" class="hover:text-primary transition-colors">Esportes</a></li>
                </ul>
              </div>

              <!-- Institucional -->
              <div>
                <h4 class="font-display font-bold mb-5 text-base-content">Institucional</h4>
                <ul class="space-y-3 text-sm text-base-content/70">
                  <li><a href="/about" target="_blank" class="hover:text-primary transition-colors">Sobre Nós</a></li>
                  <li><a href="/how-it-works" target="_blank" class="hover:text-primary transition-colors">Como Funciona</a></li>
                  <li><a href="/privacy" target="_blank" class="hover:text-primary transition-colors">Política de Privacidade</a></li>
                  <li><a href="/terms" target="_blank" class="hover:text-primary transition-colors">Termos de Uso</a></li>
                  <li><a href="/contact" target="_blank" class="hover:text-primary transition-colors">Contato</a></li>
                </ul>
              </div>

              <!-- Lojas Parceiras -->
              <div>
                <h4 class="font-display font-bold mb-5 text-base-content">Lojas Parceiras</h4>
                <div class="flex flex-wrap gap-3 text-xs">
                  <span class="inline-flex items-center gap-1 px-3 py-1 bg-base-200 rounded-full hover:bg-primary hover:text-primary-content transition-colors">🛒 Amazon</span>
                  <span class="inline-flex items-center gap-1 px-3 py-1 bg-base-200 rounded-full hover:bg-primary hover:text-primary-content transition-colors">🧡 Shopee</span>
                  <span class="inline-flex items-center gap-1 px-3 py-1 bg-base-200 rounded-full hover:bg-primary hover:text-primary-content transition-colors">🤝 Mercado Livre</span>
                  <span class="inline-flex items-center gap-1 px-3 py-1 bg-base-200 rounded-full hover:bg-primary hover:text-primary-content transition-colors">💙 Magazine Luiza</span>
                  <span class="inline-flex items-center gap-1 px-3 py-1 bg-base-200 rounded-full hover:bg-primary hover:text-primary-content transition-colors">🏠 Casas Bahia</span>
                  <span class="inline-flex items-center gap-1 px-3 py-1 bg-base-200 rounded-full hover:bg-primary hover:text-primary-content transition-colors">📦 AliExpress</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Bottom bar -->
        <div class="border-t border-base-300 py-4">
          <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row items-center justify-between gap-2 text-sm text-base-content/60">
              <p>© <%= Date.utc_today().year %> The Offers Br. Todos os direitos reservados.</p>
              <p class="flex items-center gap-1">
                Feito com
                <.icon name="hero-heart" class="h-3 w-3 text-error" />
                para economizadores
              </p>
            </div>
          </div>
        </div>

        <!-- Disclaimer -->
        <div class="bg-base-200/30 py-3">
          <div class="container mx-auto px-4">
            <p class="text-xs text-center text-base-content/50">
              <.icon name="hero-shopping-bag" class="inline h-3 w-3 mr-1" />
              The Offers Br participa de programas de afiliados. Ao comprar através dos nossos links, podemos receber uma comissão sem custo adicional para você.
            </p>
          </div>
        </div>
      </footer>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left] pointer-events-none" />

      <button
        class="flex p-2 cursor-pointer w-1/3 relative z-10"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3 relative z-10"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3 relative z-10"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
