defmodule TheOffersBrWeb.Layouts do
  use TheOffersBrWeb, :html

  import TheOffersBrWeb.CoreComponents
  use Gettext, backend: TheOffersBrWeb.Gettext

  @moduledoc """
  Application layouts.
  """

  embed_templates "layouts/*"

  attr :flash, :map, required: true
  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col bg-base-100">
      <main class="flex-1">
        {render_slot(@inner_block)}
      </main>

      <div class="fixed bottom-4 right-4 space-y-2">
        <.flash kind={:info} flash={@flash} />
        <.flash kind={:error} flash={@flash} />
      </div>
    </div>
    """
  end
end