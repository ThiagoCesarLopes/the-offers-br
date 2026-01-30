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

              <!-- User Menu (placeholder) -->
              <button class="btn btn-ghost btn-circle">
                <.icon name="hero-user" class="h-5 w-5" />
              </button>

              <!-- CTA Button -->
              <button class="hidden lg:flex btn btn-primary rounded-full gap-2 shadow-button">
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
      <footer class="bg-base-content text-base-100">
        <!-- Newsletter section -->
        <div class="bg-primary py-8">
          <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row items-center justify-between gap-6">
              <div class="text-center md:text-left">
                <h3 class="text-xl font-display font-bold text-primary-content mb-1">
                  📧 Receba as melhores ofertas!
                </h3>
                <p class="text-primary-content/80 text-sm">
                  Cadastre-se e seja o primeiro a saber das promoções
                </p>
              </div>
              <div class="flex gap-2 w-full md:w-auto max-w-md">
                <input
                  type="email"
                  placeholder="Seu melhor e-mail"
                  class="input w-full rounded-full border-0 text-base-content"
                />
                <button class="btn btn-secondary rounded-full">
                  <.icon name="hero-paper-airplane" class="h-4 w-4" />
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Main footer -->
        <div class="py-12">
          <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
              <!-- Brand -->
              <div class="md:col-span-1">
                <div class="flex items-center gap-2 mb-4">
                  <.icon name="hero-tag" class="h-7 w-7 text-primary" />
                  <span class="font-display font-bold text-xl">
                    The Offers<sup class="text-xs font-semibold text-primary ml-0.5">Br</sup>
                  </span>
                </div>
                <p class="text-sm text-base-100/70 mb-4">
                  🏷️ Compare e compre! Encontre as melhores ofertas com descontos de até 90% nas melhores lojas.
                </p>
                <!-- Social links -->
                <div class="flex gap-3">
                  <%= for social <- [{"hero-globe-alt", "#"}, {"hero-heart", "#"}, {"hero-share", "#"}] do %>
                    <a
                      href={elem(social, 1)}
                      class="w-10 h-10 rounded-full bg-base-100/10 flex items-center justify-center hover:bg-primary transition-colors"
                    >
                      <.icon name={elem(social, 0)} class="h-4 w-4" />
                    </a>
                  <% end %>
                </div>
              </div>

              <!-- Links -->
              <div>
                <h4 class="font-display font-bold mb-4">Categorias</h4>
                <ul class="space-y-2 text-sm text-base-100/70">
                  <li><a href="#" class="hover:text-primary transition-colors">Eletrônicos</a></li>
                  <li><a href="#" class="hover:text-primary transition-colors">Moda</a></li>
                  <li><a href="#" class="hover:text-primary transition-colors">Casa</a></li>
                  <li><a href="#" class="hover:text-primary transition-colors">Beleza</a></li>
                  <li><a href="#" class="hover:text-primary transition-colors">Esportes</a></li>
                </ul>
              </div>

              <div>
                <h4 class="font-display font-bold mb-4">Institucional</h4>
                <ul class="space-y-2 text-sm text-base-100/70">
                  <li><a href="#" class="hover:text-primary transition-colors">Sobre Nós</a></li>
                  <li><a href="#" class="hover:text-primary transition-colors">Como Funciona</a></li>
                  <li><a href="#" class="hover:text-primary transition-colors">Política de Privacidade</a></li>
                  <li><a href="#" class="hover:text-primary transition-colors">Termos de Uso</a></li>
                  <li><a href="#" class="hover:text-primary transition-colors">Contato</a></li>
                </ul>
              </div>

              <div>
                <h4 class="font-display font-bold mb-4">Lojas Parceiras</h4>
                <ul class="space-y-2 text-sm text-base-100/70">
                  <li class="flex items-center gap-2">
                    <span class="text-lg">🛒</span>
                    <span>Amazon</span>
                  </li>
                  <li class="flex items-center gap-2">
                    <span class="text-lg">🧡</span>
                    <span>Shopee</span>
                  </li>
                  <li class="flex items-center gap-2">
                    <span class="text-lg">🤝</span>
                    <span>Mercado Livre</span>
                  </li>
                  <li class="flex items-center gap-2">
                    <span class="text-lg">💙</span>
                    <span>Magazine Luiza</span>
                  </li>
                </ul>
              </div>
            </div>

            <!-- Copyright -->
            <div class="border-t border-base-100/10 mt-8 pt-6 text-center">
              <p class="text-base-100/60 text-sm mb-2">
                © 2026 The Offers Br. Todos os direitos reservados.
              </p>
              <p class="text-base-100/40 text-xs">
                The Offers Br participa de programas de afiliados. Ao comprar através dos nossos links, podemos receber uma comissão sem custo adicional para você.
              </p>
            </div>
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
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
