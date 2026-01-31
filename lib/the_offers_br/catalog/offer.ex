defmodule Theoffersbr.Catalog.Offer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theoffersbr.Catalog.{Category, Store}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime]

  @store_types [:amazon, :shopee, :mercadolivre, :magalu, :outros]

  schema "offers" do
    field :title, :string
    field :image_url, :string
    field :original_price, :decimal
    field :current_price, :decimal
    field :discount, :integer, read_after_writes: true
    field :store_type, Ecto.Enum, values: @store_types
    field :affiliate_link, :string
    field :is_hot, :boolean, default: false
    field :is_active, :boolean, default: true
    field :external_id, :string
    field :description, :string
    field :delivery_days, :integer
    field :store_rating, :decimal
    field :installments, :integer
    field :installment_value, :decimal, read_after_writes: true
    field :commission_percentage, :decimal

    belongs_to :store, Store
    belongs_to :category, Category

    timestamps()
  end

  def store_types, do: @store_types

  def changeset(offer, attrs) do
    offer
    |> cast(attrs, [
      :title,
      :image_url,
      :original_price,
      :current_price,
      :store_type,
      :affiliate_link,
      :is_hot,
      :is_active,
      :external_id,
      :description,
      :delivery_days,
      :store_rating,
      :installments,
      :commission_percentage,
      :store_id,
      :category_id
    ])
    |> validate_required([:title, :image_url, :original_price, :current_price, :store_type, :affiliate_link])
  end
end
