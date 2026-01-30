defmodule Theoffersbr.Accounts.ProfileType do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [inserted_at: false, updated_at: false]

  schema "profile_types" do
    field :name, :string
    field :description, :string
  end

  def changeset(profile_type, attrs) do
    profile_type
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
