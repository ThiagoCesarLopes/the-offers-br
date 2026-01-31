defmodule Theoffersbr.Integrations.MLOfferMapping do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theoffersbr.Catalog.Offer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime]

  schema "ml_offer_mappings" do
    field :ml_item_id, :string
    field :last_synced_at, :utc_datetime
    field :sync_status, :string
    field :sync_error, :string

    belongs_to :offer, Offer

    timestamps()
  end

  def changeset(mapping, attrs) do
    mapping
    |> cast(attrs, [:offer_id, :ml_item_id, :last_synced_at, :sync_status, :sync_error])
    |> validate_required([:offer_id, :ml_item_id])
    |> unique_constraint(:offer_id)
    |> unique_constraint(:ml_item_id)
  end
end
