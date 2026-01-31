defmodule TheOffersBrWeb.BrandLogo do
  use Phoenix.Component

  attr :size, :string, default: "md"
  attr :show_tagline, :boolean, default: false

  def brand_logo(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <span class="font-bold text-xl">The Offers BR</span>

      <%= if @show_tagline do %>
        <span class="text-sm opacity-70">
          As melhores ofertas
        </span>
      <% end %>
    </div>
    """
  end
end
