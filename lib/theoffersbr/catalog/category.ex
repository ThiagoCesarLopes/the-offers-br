defmodule Theoffersbr.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime]

  schema "categories" do
    field :name, :string
    field :icon, :string
    field :is_active, :boolean, default: true

    timestamps()
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :icon, :is_active])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
