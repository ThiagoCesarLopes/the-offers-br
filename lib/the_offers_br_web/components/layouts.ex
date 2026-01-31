defmodule TheOffersBrWeb.Layouts do
  use TheOffersBrWeb, :html

  import TheOffersBrWeb.CoreComponents
  use Gettext, backend: TheOffersBrWeb.Gettext

  @moduledoc """
  Application layouts.
  """

  embed_templates "layouts/*"

  attr :flash, :map, required: true

  # Aceita tanto inner_block (componente) quanto inner_content (LiveView)
  slot :inner_block

  def app(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col bg-base-100">
      <main class="flex-1">
        <%= if assigns[:inner_block] do %>
          <%= render_slot(@inner_block) %>
        <% else %>
          <%= @inner_content %>
        <% end %>
      </main>

      <div class="fixed bottom-4 right-4 space-y-2">
        <.flash kind={:info} flash={@flash} />
        <.flash kind={:error} flash={@flash} />
      </div>
    </div>
    """
  end
end