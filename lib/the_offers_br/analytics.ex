defmodule Theoffersbr.Analytics do
  import Ecto.Query, warn: false

  alias Theoffersbr.Repo
  alias Theoffersbr.Catalog.OfferClick

  def list_offer_clicks do
    Repo.all(from c in OfferClick, order_by: [desc: c.clicked_at])
  end
end
