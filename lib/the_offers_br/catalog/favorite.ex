defmodule Theoffersbr.Catalog.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theoffersbr.Catalog.Offer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime]

  schema "favorites" do
    field :user_id, :binary_id

    belongs_to :offer, Offer

    timestamps()
  end

  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:user_id, :offer_id])
    |> validate_required([:user_id, :offer_id])
    |> unique_constraint([:user_id, :offer_id])
  end
end
