defmodule Theoffersbr.Catalog.Store do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime]

  @store_types [:amazon, :shopee, :mercadolivre, :magalu, :outros]

  schema "stores" do
    field :name, :string
    field :store_type, Ecto.Enum, values: @store_types
    field :affiliate_tag, :string
    field :is_active, :boolean, default: true

    timestamps()
  end

  def store_types, do: @store_types

  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :store_type, :affiliate_tag, :is_active])
    |> validate_required([:name, :store_type])
  end
end
