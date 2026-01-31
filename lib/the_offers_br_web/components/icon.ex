defmodule TheOffersBrWeb.Icon do
  use Phoenix.Component

  attr :name, :string, required: true
  attr :class, :string, default: ""

  def icon(assigns) do
    ~H"""
    <span class={@class} aria-hidden="true">
      <%= @name %>
    </span>
    """
  end
end