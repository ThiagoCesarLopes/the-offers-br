defmodule TheoffersbrWeb.IndexLive do
  use TheoffersbrWeb, :live_view

  alias Theoffersbr.Catalog

  @impl true
  def mount(_params, _session, socket) do
    categories = Catalog.list_active_categories()
    stores = Catalog.list_stores()
    offers = Catalog.list_offers(active: true)

    {:ok,
     socket
     |> assign(:page_title, "The Offers Br - Compare e compre")
     |> assign(:categories, categories)
     |> assign(:stores, stores)
     |> assign(:offers, offers)
     |> assign(:selected_category, "all")
     |> assign(:selected_store, "all")
     |> assign(:current_slide, 0)}
  end

  @impl true
  def handle_event("filter_category", %{"category" => category_id}, socket) do
    filters = build_filters(category_id, socket.assigns.selected_store)
    offers = Catalog.list_offers(filters)

    {:noreply,
     socket
     |> assign(:offers, offers)
     |> assign(:selected_category, category_id)}
  end

  @impl true
  def handle_event("filter_store", %{"store" => store_type}, socket) do
    filters = build_filters(socket.assigns.selected_category, store_type)
    offers = Catalog.list_offers(filters)

    {:noreply,
     socket
     |> assign(:offers, offers)
     |> assign(:selected_store, store_type)}
  end

  defp build_filters("all", "all"), do: [active: true]
  defp build_filters(category_id, "all") when category_id != "all", do: [active: true, category_id: category_id]
  defp build_filters("all", store_type) when store_type != "all", do: [active: true, store_type: store_type]
  defp build_filters(category_id, store_type), do: [active: true, category_id: category_id, store_type: store_type]

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen">
      <!-- Hero Carousel -->
      <section class="relative h-[280px] md:h-[350px] overflow-hidden">
        <!-- Slide 1: OFERTAS EXPLOSIVAS -->
        <div class="absolute inset-0">
          <img
            src="https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=1920&q=80"
            alt="Ofertas Explosivas"
            class="absolute inset-0 w-full h-full object-cover"
          />
          <div class="absolute inset-0 bg-gradient-to-r from-black/70 via-black/50 to-transparent" />

          <div class="absolute inset-0 flex items-center">
            <div class="container mx-auto px-4">
              <div class="max-w-2xl">
                <h1 class="text-4xl md:text-6xl lg:text-7xl font-display font-bold text-white mb-4"
                    style="text-shadow: 2px 4px 8px rgba(0,0,0,0.5)">
                  OFERTAS EXPLOSIVAS
                </h1>
                <p class="text-lg md:text-xl text-white/90 font-semibold mb-6"
                   style="text-shadow: 1px 2px 4px rgba(0,0,0,0.5)">
                  As melhores promoções do Brasil em um só lugar!
                </p>
                <button class="btn btn-primary btn-lg rounded-full shadow-button gap-2">
                  <.icon name="hero-rocket-launch" class="h-5 w-5" />
                  Ver Ofertas
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Stats bar -->
      <section class="bg-gradient-to-r from-primary to-accent py-6">
        <div class="container mx-auto px-4">
          <div class="flex flex-wrap justify-center md:justify-around gap-8 text-center text-primary-content">
            <div class="flex flex-col items-center">
              <div class="text-3xl md:text-4xl font-display font-bold mb-1"><%= length(@offers) %>+</div>
              <div class="text-sm md:text-base opacity-90">Ofertas Ativas</div>
            </div>
            <div class="flex flex-col items-center">
              <div class="text-3xl md:text-4xl font-display font-bold mb-1">Até 80%</div>
              <div class="text-sm md:text-base opacity-90">de Desconto</div>
            </div>
            <div class="flex flex-col items-center">
              <div class="text-3xl md:text-4xl font-display font-bold mb-1">24/7</div>
              <div class="text-sm md:text-base opacity-90">Atualizações</div>
            </div>
          </div>
        </div>
      </section>

      <!-- Store Filter -->
      <section class="py-4">
        <div class="container mx-auto px-4">
          <h2 class="text-lg md:text-xl font-display font-bold text-center mb-3">
            Buscar por <span class="text-primary">Parceiro</span>
          </h2>

          <div class="flex gap-2 pb-4 justify-center flex-wrap">
            <%= for {key, name, icon} <- [{"all", "Todas", "hero-shopping-bag"}, {"amazon", "Amazon", "hero-shopping-bag"}, {"shopee", "Shopee", "hero-building-storefront"}, {"mercadolivre", "Mercado Livre", "hero-truck"}, {"magalu", "Magalu", "hero-building-office-2"}] do %>
              <button
                phx-click="filter_store"
                phx-value-store={key}
                class={[
                  "btn rounded-full transition-all duration-300 gap-2",
                  if(@selected_store == key,
                    do: "btn-primary shadow-button scale-105",
                    else: "btn-outline hover:btn-primary")
                ]}
              >
                <.icon name={icon} class="h-4 w-4" />
                <%= name %>
              </button>
            <% end %>
          </div>
        </div>
      </section>

      <!-- Category Filter -->
      <section class="py-2 border-t border-base-300/50">
        <div class="container mx-auto px-4">
          <div class="flex gap-1.5 pb-2 justify-center flex-wrap">
            <button
              phx-click="filter_category"
              phx-value-category="all"
              class={[
                "btn btn-sm rounded-full",
                if(@selected_category == "all",
                  do: "btn-primary",
                  else: "btn-ghost hover:btn-primary/10")
              ]}
            >
              Todas
            </button>
            <%= for category <- @categories do %>
              <button
                phx-click="filter_category"
                phx-value-category={category.id}
                class={[
                  "btn btn-sm rounded-full gap-1.5",
                  if(@selected_category == category.id,
                    do: "btn-primary",
                    else: "btn-ghost hover:btn-primary/10")
                ]}
              >
                <%= category.icon %>
                <%= category.name %>
              </button>
            <% end %>
          </div>
        </div>
      </section>

      <!-- Offer Grid -->
      <section class="py-8">
        <div class="container mx-auto px-4">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl md:text-3xl font-display font-bold">
              Ofertas <span class="text-primary">Recentes</span> 🍈
            </h2>
            <span class="text-sm text-base-content/60">
              <%= length(@offers) %> ofertas encontradas
            </span>
          </div>

          <%= if length(@offers) == 0 do %>
            <div class="text-center py-16">
              <div class="text-6xl mb-4">🍈</div>
              <h3 class="text-xl font-semibold mb-2">Nenhuma oferta encontrada</h3>
              <p class="text-base-content/60">
                Tente outra categoria ou volte mais tarde para novas ofertas!
              </p>
            </div>
          <% else %>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6">
              <%= for offer <- @offers do %>
                <article class="card-offer group bg-base-100 border border-base-300 flex flex-col h-full">
                  <!-- Image -->
                  <figure class="relative aspect-square overflow-hidden bg-base-200">
                    <%= if offer.image_url do %>
                      <img
                        src={offer.image_url}
                        alt={offer.title}
                        class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                      />
                    <% else %>
                      <div class="w-full h-full flex items-center justify-center text-6xl">
                        📦
                      </div>
                    <% end %>

                    <!-- Hot badge -->
                    <%= if offer.is_hot do %>
                      <div class="absolute top-3 left-3 z-10">
                        <div class="badge badge-error gap-1 animate-pulse-glow">
                          <.icon name="hero-fire" class="h-3 w-3" />
                          Quente!
                        </div>
                      </div>
                    <% end %>

                    <!-- Discount badge -->
                    <%= if offer.discount do %>
                      <div class="absolute top-3 right-3 z-10">
                        <div class="badge badge-success text-lg font-bold px-3 py-3">
                          -<%= offer.discount %>%
                        </div>
                      </div>
                    <% end %>
                  </figure>

                  <!-- Content -->
                  <div class="card-body p-4 flex-1 flex flex-col">
                    <h3 class="card-title text-sm md:text-base line-clamp-2 min-h-[2.5rem]">
                      <%= offer.title %>
                    </h3>

                    <!-- Price -->
                    <div class="mt-auto pt-2">
                      <%= if offer.original_price do %>
                        <div class="text-xs text-base-content/50 line-through">
                          R$ <%= offer.original_price %>
                        </div>
                      <% end %>
                      <div class="text-2xl font-bold text-primary">
                        R$ <%= offer.current_price %>
                      </div>
                      <%= if offer.installments do %>
                        <div class="text-xs text-base-content/70">
                          ou <%= offer.installments %>x de R$ <%= offer.installment_value || Decimal.div(offer.current_price, offer.installments) %>
                        </div>
                      <% end %>
                    </div>

                    <!-- CTA Button -->
                    <a
                      href={offer.affiliate_link}
                      target="_blank"
                      class="btn btn-primary w-full rounded-full mt-4 gap-2"
                    >
                      Ver Oferta
                      <.icon name="hero-arrow-top-right-on-square" class="h-4 w-4" />
                    </a>
                  </div>
                </article>
              <% end %>
            </div>
          <% end %>
        </div>
      </section>

      <!-- Video Promo Section -->
      <section class="py-12 bg-gradient-to-br from-primary/5 to-accent/5">
        <div class="container mx-auto px-4">
          <h2 class="text-3xl md:text-4xl font-display font-bold text-center mb-8">
            Como Funciona o <span class="text-gradient">The Offers Br</span>
          </h2>
          <div class="max-w-4xl mx-auto">
            <div class="aspect-video bg-base-200 rounded-2xl shadow-card flex items-center justify-center">
              <div class="text-center">
                <.icon name="hero-play-circle" class="h-20 w-20 text-primary mx-auto mb-4" />
                <p class="text-base-content/60">Vídeo em breve</p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    """
  end
end
