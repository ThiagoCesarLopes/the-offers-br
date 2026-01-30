defmodule Theoffersbr.Catalog.OfferClick do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theoffersbr.Catalog.Offer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :clicked_at, updated_at: false, type: :utc_datetime]

  schema "offer_clicks" do
    field :user_id, :binary_id
    field :associate_id, :string
    field :ip_address, :string
    field :user_agent, :string
    field :referrer, :string
    field :session_id, :string
    field :converted, :boolean, default: false
    field :conversion_value, :decimal
    field :conversion_at, :utc_datetime
    field :affiliate_order_id, :string

    belongs_to :offer, Offer

    timestamps()
  end

  def changeset(click, attrs) do
    click
    |> cast(attrs, [
      :offer_id,
      :user_id,
      :associate_id,
      :ip_address,
      :user_agent,
      :referrer,
      :session_id,
      :converted,
      :conversion_value,
      :conversion_at,
      :affiliate_order_id
    ])
    |> validate_required([:offer_id])
  end
end
