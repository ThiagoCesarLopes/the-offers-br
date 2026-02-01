defmodule TheOffersBrWeb.IndexLive do
  use TheOffersBrWeb, :live_view

  alias Theoffersbr.Catalog

  @impl true
  def mount(_params, _session, socket) do
    categories = Catalog.list_active_categories()
    stores = Catalog.list_stores()
    offers = Catalog.list_offers(active: true)

    # Schedule carousel rotation
    Process.send_after(self(), :next_slide, 5000)

    {:ok,
     socket
     |> assign(:page_title, "The Offers Br - Compare e compre")
     |> assign(:categories, categories)
     |> assign(:stores, stores)
     |> assign(:offers, offers)
     |> assign(:selected_category, "all")
     |> assign(:selected_store, "all")
      |> assign(:current_slide, 0)
      |> assign(:compare_offer_ids, [])
      |> assign(:compare_open, false)
      |> assign(:share_offer, nil)
      |> assign(:selected_voltage, "bivolt")}
  end

  @impl true
  def handle_params(%{"category" => "all"}, _uri, socket) do
    offers = Catalog.list_offers(active: true)

    {:noreply,
     socket
     |> assign(:offers, offers)
     |> assign(:selected_category, "all")}
  end

  def handle_params(%{"category" => category_slug}, _uri, socket) do
    category =
      socket.assigns.categories
      |> Enum.find(fn category -> slugify(category.name) == category_slug end)

    if category do
      offers = Catalog.list_offers(active: true, category_id: category.id)

      {:noreply,
       socket
       |> assign(:offers, offers)
       |> assign(:selected_category, category.id)}
    else
      {:noreply, socket}
    end
  end

  def handle_params(_params, _uri, socket), do: {:noreply, socket}

  @impl true
  def handle_info(:next_slide, socket) do
    next_slide = rem(socket.assigns.current_slide + 1, 3)
    Process.send_after(self(), :next_slide, 5000)
    {:noreply, assign(socket, :current_slide, next_slide)}
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

  @impl true
  def handle_event("compare_add", %{"id" => offer_id}, socket) do
    # Find the clicked offer
    clicked_offer = Enum.find(socket.assigns.offers, &(&1.id == offer_id))

    if clicked_offer do
      # Find all offers with the same title (same product) but different stores
      same_product_offers =
        socket.assigns.offers
        |> Enum.filter(&(String.contains?(String.downcase(&1.title), String.downcase(clicked_offer.title)) or String.contains?(String.downcase(clicked_offer.title), String.downcase(&1.title))))
        |> Enum.take(4)

      compare_ids = Enum.map(same_product_offers, & &1.id)
      {:noreply, assign(socket, compare_offer_ids: compare_ids, compare_open: true)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("compare_remove", %{"id" => offer_id}, socket) do
    ids = List.delete(socket.assigns.compare_offer_ids, offer_id)
    {:noreply, assign(socket, compare_offer_ids: ids, compare_open: ids != [])}
  end

  @impl true
  def handle_event("compare_clear", _params, socket) do
    {:noreply, assign(socket, compare_offer_ids: [], compare_open: false)}
  end

  @impl true
  def handle_event("compare_toggle", _params, socket) do
    {:noreply, assign(socket, compare_open: !socket.assigns.compare_open)}
  end

  @impl true
  def handle_event("select_voltage", %{"voltage" => voltage}, socket) do
    {:noreply, assign(socket, :selected_voltage, String.downcase(voltage))}
  end

  @impl true
  def handle_event("share_open", %{"id" => offer_id}, socket) do
    offer = Enum.find(socket.assigns.offers, &(&1.id == offer_id))
    {:noreply, assign(socket, share_offer: offer)}
  end

  @impl true
  def handle_event("share_close", _params, socket) do
    {:noreply, assign(socket, share_offer: nil)}
  end

  defp build_filters("all", "all"), do: [active: true]
  defp build_filters(category_id, "all") when category_id != "all", do: [active: true, category_id: category_id]
  defp build_filters("all", store_type) when store_type != "all", do: [active: true, store_type: store_type]
  defp build_filters(category_id, store_type), do: [active: true, category_id: category_id, store_type: store_type]

  defp slugify(name) do
    name
    |> String.normalize(:nfd)
    |> String.replace(~r/[^a-zA-Z0-9\s-]/u, "")
    |> String.downcase()
    |> String.replace(~r/\s+/, "-")
  end

  defp store_label("amazon"), do: "Amazon"
  defp store_label("shopee"), do: "Shopee"
  defp store_label("mercadolivre"), do: "Mercado Livre"
  defp store_label("magalu"), do: "Magalu"
  defp store_label(_), do: "Loja"

  defp get_store_color("amazon"), do: "bg-[#FF9900]"
  defp get_store_color("shopee"), do: "bg-[#EE4D2D]"
  defp get_store_color("mercadolivre"), do: "bg-[#FFB100]"
  defp get_store_color("magalu"), do: "bg-[#0071E6]"
  defp get_store_color("casasbahia"), do: "bg-[#EC1C24]"
  defp get_store_color(_), do: "bg-base-content"

  defp get_store_button_color("amazon"), do: "bg-[#FF9900] hover:bg-[#E68A00]"
  defp get_store_button_color("shopee"), do: "bg-[#EE4D2D] hover:bg-[#D43F1B]"
  defp get_store_button_color("mercadolivre"), do: "bg-[#FFB100] hover:bg-[#E69900]"
  defp get_store_button_color("magalu"), do: "bg-[#0071E6] hover:bg-[#0059B8]"
  defp get_store_button_color("casasbahia"), do: "bg-[#EC1C24] hover:bg-[#C91318]"
  defp get_store_button_color(_), do: "bg-primary hover:bg-primary/80"

  defp share_url(nil), do: "#"
  defp share_url(offer), do: offer.affiliate_link || "#"

  defp share_text(nil), do: ""
  defp share_text(offer) do
    "🔥 #{offer.title} - Veja a oferta: #{share_url(offer)}"
  end

  @impl true
  def render(assigns) do
    ~H"""
    <TheOffersBrWeb.Layouts.app flash={%{}}>
      <div class="min-h-screen">
        <!-- White Divider Line -->
        <div class="h-px bg-base-300"></div>

      <!-- Hero Carousel -->
      <section class="relative h-[280px] md:h-[350px] overflow-hidden bg-black">
        <!-- Slide 1: OFERTAS EXPLOSIVAS -->
        <div class={["absolute inset-0 transition-opacity duration-1000", (if @current_slide == 0, do: "opacity-100", else: "opacity-0")]}>
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

        <!-- Slide 2: BLACK FRIDAY -->
        <div class={["absolute inset-0 transition-opacity duration-1000", (if @current_slide == 1, do: "opacity-100", else: "opacity-0")]}>
          <img
            src="https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=1920&q=80"
            alt="Black Friday Todo Dia"
            class="absolute inset-0 w-full h-full object-cover"
          />
          <div class="absolute inset-0 bg-gradient-to-r from-primary/80 via-primary/50 to-transparent" />

          <div class="absolute inset-0 flex items-center">
            <div class="container mx-auto px-4">
              <div class="max-w-2xl">
                <h1 class="text-4xl md:text-6xl lg:text-7xl font-display font-bold text-white mb-4"
                    style="text-shadow: 2px 4px 8px rgba(0,0,0,0.5)">
                  BLACK FRIDAY TODO DIA
                </h1>
                <p class="text-lg md:text-xl text-white/90 font-semibold mb-6"
                   style="text-shadow: 1px 2px 4px rgba(0,0,0,0.5)">
                  Descontos de até 90% nas melhores lojas
                </p>
                <button class="btn btn-primary btn-lg rounded-full shadow-button gap-2">
                  <.icon name="hero-rocket-launch" class="h-5 w-5" />
                  Ver Ofertas
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Slide 3: FRETE GRÁTIS -->
        <div class={["absolute inset-0 transition-opacity duration-1000", (if @current_slide == 2, do: "opacity-100", else: "opacity-0")]}>
          <img
            src="https://images.unsplash.com/photo-1472851294608-062f824d29cc?auto=format&fit=crop&w=1920&q=80"
            alt="Frete Grátis"
            class="absolute inset-0 w-full h-full object-cover"
          />
          <div class="absolute inset-0 bg-gradient-to-r from-secondary/80 via-secondary/50 to-transparent" />

          <div class="absolute inset-0 flex items-center">
            <div class="container mx-auto px-4">
              <div class="max-w-2xl">
                <h1 class="text-4xl md:text-6xl lg:text-7xl font-display font-bold text-white mb-4"
                    style="text-shadow: 2px 4px 8px rgba(0,0,0,0.5)">
                  FRETE GRÁTIS
                </h1>
                <p class="text-lg md:text-xl text-white/90 font-semibold mb-6"
                   style="text-shadow: 1px 2px 4px rgba(0,0,0,0.5)">
                  Milhares de produtos com entrega gratuita
                </p>
                <button class="btn btn-primary btn-lg rounded-full shadow-button gap-2">
                  <.icon name="hero-rocket-launch" class="h-5 w-5" />
                  Ver Ofertas
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Stats bar -->
        <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-base-100 via-base-100/80 to-transparent">
          <div class="container mx-auto px-4 py-6">
            <div class="flex justify-center gap-8 md:gap-16">
              <div class="text-center">
                <div class="text-2xl md:text-3xl font-display font-bold text-primary"><%= length(@offers) %>+</div>
                <div class="text-xs md:text-sm text-base-content/70">Ofertas Ativas</div>
              </div>
              <div class="text-center">
                <div class="text-2xl md:text-3xl font-display font-bold text-primary">Até 80%</div>
                <div class="text-xs md:text-sm text-base-content/70">de Desconto</div>
              </div>
              <div class="text-center">
                <div class="text-2xl md:text-3xl font-display font-bold text-primary">24/7</div>
                <div class="text-xs md:text-sm text-base-content/70">Atualizações</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Dots Navigation -->
        <div class="absolute bottom-20 left-1/2 -translate-x-1/2 flex gap-2">
          <button class={["transition-all duration-300 rounded-full h-3", (if @current_slide == 0, do: "w-8 bg-white", else: "w-3 bg-white/50 hover:bg-white/80")]} />
          <button class={["transition-all duration-300 rounded-full h-3", (if @current_slide == 1, do: "w-8 bg-white", else: "w-3 bg-white/50 hover:bg-white/80")]} />
          <button class={["transition-all duration-300 rounded-full h-3", (if @current_slide == 2, do: "w-8 bg-white", else: "w-3 bg-white/50 hover:bg-white/80")]} />
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
                    do: "btn-primary scale-105",
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
                <article class="group relative flex flex-col w-[320px] h-[480px] bg-[#2b201a] rounded-2xl border border-[#3a2a22] overflow-hidden transition-all hover:shadow-lg shadow-lg">
                  <!-- Image -->
                  <div class="relative w-full h-[200px] overflow-hidden bg-[#3a2a22]">
                    <%= if offer.image_url do %>
                      <img
                        src={offer.image_url}
                        alt={offer.title}
                        class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110 rounded-t-2xl"
                      />
                    <% else %>
                      <div class="w-full h-full flex items-center justify-center rounded-t-2xl">
                        <.brand_logo size="sm" />
                      </div>
                    <% end %>

                    <!-- Hot badge -->
                    <%= if offer.is_hot do %>
                      <div class="absolute top-2 left-2 z-10">
                        <div class="inline-flex items-center gap-1 rounded-full bg-[#ff3b30] text-white text-[11px] font-semibold px-2.5 py-0.5 shadow">
                          <.icon name="hero-fire" class="h-3 w-3" />
                          Quente!
                        </div>
                      </div>
                    <% end %>

                    <!-- Favorite icon -->
                    <button
                      type="button"
                      class="absolute top-2 right-2 z-10 w-8 h-8 rounded-full bg-[#3a2a22] border border-white/10 flex items-center justify-center text-white/80 hover:text-white shadow"
                    >
                      <.icon name="hero-heart" class="h-4 w-4" />
                    </button>

                    <!-- Discount badge -->
                    <%= if offer.discount do %>
                      <div class="absolute bottom-2 right-2 z-10">
                        <div class="rounded-full bg-[#ff8a00] text-white text-[11px] font-bold px-2.5 py-0.5 shadow">
                          -<%= offer.discount %>%
                        </div>
                      </div>
                    <% end %>
                  </div>

                  <!-- Content -->
                  <div class="flex flex-col flex-1 p-4 pt-3 text-[#f2e8dc]">
                    <div class="mb-2 flex items-center justify-between">
                      <span class={["inline-flex items-center rounded-full text-[11px] font-semibold px-2.5 py-0.5 text-white", get_store_color(offer.store_type)]}>
                        <%= store_label(offer.store_type) %>
                      </span>
                      <span class="inline-flex items-center gap-1 text-[11px] text-white/60">
                        <.icon name="hero-clock" class="h-3 w-3" />
                        há 1d
                      </span>
                    </div>
                    <h3 class="font-semibold text-[15px] leading-tight line-clamp-2 min-h-[2.3rem] mb-2">
                      <%= offer.title %>
                    </h3>

                    <!-- Price Section -->
                    <div class="mb-3 mt-auto pt-1 space-y-0.5">
                      <%= if offer.original_price do %>
                        <div class="text-xs text-white/40 line-through">
                          R$ <%= String.pad_leading(to_string(offer.original_price), 7) %>
                        </div>
                      <% end %>
                      <div class="text-[22px] font-display font-bold text-[#ff8a00] leading-none">
                        R$ <%= offer.current_price %>
                      </div>
                      <div class="text-xs text-white/60 mt-0.5">
                        à vista
                      </div>
                    </div>

                    <!-- CTA Buttons -->
                    <div class="flex flex-col gap-2 pt-1">
                      <button
                        type="button"
                        class="w-full rounded-lg border border-white/15 text-white text-[15px] font-semibold py-2 flex items-center justify-center gap-2 hover:border-white/30 hover:bg-white/5 transition"
                        phx-click="compare_add"
                        phx-value-id={offer.id}
                      >
                        <.icon name="hero-scale" class="h-4 w-4" />
                        Comparar Preços
                      </button>
                      <a
                        href={offer.affiliate_link}
                        target="_blank"
                        class={["w-full rounded-lg text-white text-[15px] font-semibold py-2 flex items-center justify-center gap-2 transition", get_store_button_color(offer.store_type)]}
                      >
                        <.icon name="hero-arrow-top-right-on-square" class="h-4 w-4" />
                        Ir para <%= store_label(offer.store_type) %>
                      </a>
                      <button
                        type="button"
                        class="w-full rounded-lg bg-[#2fbf63] text-white text-[15px] font-semibold py-2 flex items-center justify-center gap-2 hover:bg-[#27a654] transition"
                        phx-click="share_open"
                        phx-value-id={offer.id}
                      >
                        <.icon name="hero-share-2" class="h-4 w-4" />
                        Compartilhar
                      </button>
                    </div>
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
            <div class="aspect-video bg-base-200 rounded-2xl flex items-center justify-center">
              <div class="text-center">
                <.icon name="hero-play-circle" class="h-20 w-20 text-primary mx-auto mb-4" />
                <p class="text-base-content/60">Vídeo em breve</p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>

    <%= if @share_offer do %>
      <div class="fixed inset-0 z-50 flex items-center justify-center p-4">
        <div
          class="absolute inset-0 bg-base-300/60 backdrop-blur-sm"
          phx-click="share_close"
        />
        <div class="relative w-full max-w-sm bg-base-100 rounded-2xl shadow-lg border border-base-300">
          <div class="flex items-center justify-between p-4 border-b border-base-300">
            <h3 class="font-display font-bold text-lg">Compartilhar</h3>
            <button type="button" class="btn btn-ghost btn-circle btn-sm" phx-click="share_close">
              <.icon name="hero-x-mark" class="h-5 w-5" />
            </button>
          </div>
          <div class="p-4 space-y-3">
            <p class="text-sm text-base-content/70 line-clamp-2 font-medium"><%= @share_offer.title %></p>
            <div class="grid grid-cols-2 gap-2">
              <a
                class="btn btn-outline btn-sm rounded-full"
                href={"https://www.facebook.com/sharer/sharer.php?u=" <> URI.encode(share_url(@share_offer))}
                target="_blank"
              >
                Facebook
              </a>
              <a
                class="btn btn-outline btn-sm rounded-full"
                href={"https://twitter.com/intent/tweet?text=" <> URI.encode(share_text(@share_offer))}
                target="_blank"
              >
                Twitter
              </a>
              <a
                class="btn btn-outline btn-sm rounded-full"
                href="https://www.instagram.com/"
                target="_blank"
              >
                Instagram
              </a>
              <a
                class="btn btn-outline btn-sm rounded-full"
                href="https://www.youtube.com/"
                target="_blank"
              >
                YouTube
              </a>
            </div>
            <a
              class="btn btn-primary w-full rounded-full text-sm"
              href={"https://wa.me/?text=" <> URI.encode(share_text(@share_offer))}
              target="_blank"
            >
              WhatsApp
            </a>
          </div>
        </div>
      </div>
    <% end %>

    <%= if @compare_open do %>
      <% first_offer = Enum.at(@offers, 0) %>
      <% other_offers = @offers |> Enum.drop(1) |> Enum.take(3) %>
      <div class="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="max-w-4xl w-full">
          <div class="rounded-2xl bg-[#2b201a] text-[#f2e8dc] border border-white/10 shadow-2xl">
            <div class="flex items-center justify-between px-6 py-4 border-b border-white/10">
              <div class="flex items-center gap-2">
                <.icon name="hero-scale" class="h-5 w-5 text-primary" />
                <h3 class="font-display font-bold">Comparar Preços</h3>
              </div>
              <button type="button" class="btn btn-ghost btn-circle btn-sm text-[#f2e8dc]" phx-click="compare_toggle">
                <.icon name="hero-x-mark" class="h-4 w-4" />
              </button>
            </div>

            <div class="px-6 py-4 border-b border-white/10 text-sm text-[#e6d7c8]">
              <%= if first_offer do %>
                <%= first_offer.title %>
              <% else %>
                Nenhuma oferta selecionada
              <% end %>
            </div>

            <div class="px-6 py-4 border-b border-white/10">
              <div class="flex flex-wrap items-center gap-3 text-sm text-[#e6d7c8]">
                <.icon name="hero-plug" class="h-4 w-4" />
                <span>Voltagem:</span>
                <div class="flex gap-2">
                  <button type="button" phx-click="select_voltage" phx-value-voltage="110v" class={["btn btn-sm rounded-full", (if @selected_voltage == "110v", do: "bg-primary text-primary-content", else: "bg-[#1f1814] border border-white/10 text-[#e6d7c8]")]}>110V</button>
                  <button type="button" phx-click="select_voltage" phx-value-voltage="220v" class={["btn btn-sm rounded-full", (if @selected_voltage == "220v", do: "bg-primary text-primary-content", else: "bg-[#1f1814] border border-white/10 text-[#e6d7c8]")]}>220V</button>
                  <button type="button" phx-click="select_voltage" phx-value-voltage="bivolt" class={["btn btn-sm rounded-full", (if @selected_voltage == "bivolt", do: "bg-primary text-primary-content", else: "bg-[#1f1814] border border-white/10 text-[#e6d7c8]")]}>Bivolt</button>
                </div>
              </div>
            </div>

            <div class="px-6 py-8">
              <div class="grid grid-cols-4 gap-4">
                <!-- Main Offer Card -->
                <%= if first_offer do %>
                  <div class="rounded-lg bg-[#1f1814] border border-white/10 p-3 flex flex-col">
                    <div class="aspect-square rounded-md overflow-hidden bg-base-200 mb-2">
                      <%= if first_offer.image_url do %>
                        <img src={first_offer.image_url} alt={first_offer.title} class="w-full h-full object-cover" />
                      <% else %>
                        <div class="w-full h-full flex items-center justify-center">
                          <.brand_logo size="sm" />
                        </div>
                      <% end %>
                    </div>
                    <p class="text-xs text-[#e6d7c8] line-clamp-2 mb-2 flex-1"><%= first_offer.title %></p>
                    <div class="text-sm font-bold text-primary">R$ <%= first_offer.current_price %></div>
                  </div>
                <% else %>
                  <div class="rounded-lg bg-[#1f1814] border border-white/10 p-3 flex items-center justify-center h-48">
                    <p class="text-xs text-[#999]">Nenhuma oferta</p>
                  </div>
                <% end %>

                <!-- Comparison Options -->
                <%= for offer <- other_offers do %>
                  <div class="rounded-lg bg-[#1f1814] border border-white/10 p-3 flex flex-col hover:border-primary/50 transition-colors cursor-pointer">
                    <div class="aspect-square rounded-md overflow-hidden bg-base-200 mb-2">
                      <%= if offer.image_url do %>
                        <img src={offer.image_url} alt={offer.title} class="w-full h-full object-cover" />
                      <% else %>
                        <div class="w-full h-full flex items-center justify-center">
                          <.brand_logo size="sm" />
                        </div>
                      <% end %>
                    </div>
                    <p class="text-xs text-[#e6d7c8] line-clamp-2 mb-2 flex-1"><%= offer.title %></p>
                    <div class="text-sm font-bold text-primary">R$ <%= offer.current_price %></div>
                  </div>
                <% end %>
              </div>
            </div>

            <div class="px-6 py-4 border-t border-white/10 flex items-center justify-center gap-3">
              <%= if first_offer do %>
                <a class="btn btn-primary rounded-full" href={first_offer.affiliate_link} target="_blank">
                  <.icon name="hero-arrow-top-right-on-square" class="h-4 w-4" />
                  Ver Oferta
                </a>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    <% end %>
    </TheOffersBrWeb.Layouts.app>
    """
  end
end
