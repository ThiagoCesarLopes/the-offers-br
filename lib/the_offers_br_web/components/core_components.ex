defmodule TheOffersBrWeb.CoreComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  ## FLASHES

  @doc """
  Renders a flash message.

  Supports:
  - info / error kinds
  - title
  - JS show/hide hooks
  - inner content
  """

  attr :id, :string, default: nil
  attr :flash, :map, default: %{}
  attr :kind, :atom, values: [:info, :error], required: true
  attr :title, :string, default: nil
  attr :phx_connected, :any, default: nil
  attr :phx_disconnected, :any, default: nil
  attr :hidden, :boolean, default: false

  slot :inner_block

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      class={[
        "rounded-lg p-4 mb-3 text-sm flex gap-2 items-start",
        @kind == :info && "bg-blue-50 text-blue-900",
        @kind == :error && "bg-red-50 text-red-900"
      ]}
      phx-connected={@phx_connected}
      phx-disconnected={@phx_disconnected}
      hidden={@hidden}
      role="alert"
    >
      <div class="flex-1">
        <p :if={@title} class="font-semibold mb-1">
          {@title}
        </p>

        <p>{msg}</p>

        <%= if @inner_block != [] do %>
          <div class="mt-1">
            <%= render_slot(@inner_block) %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  ## JS HELPERS

  def show(js \\ %JS{}, selector) do
    JS.show(js, to: selector)
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js, to: selector)
  end
end