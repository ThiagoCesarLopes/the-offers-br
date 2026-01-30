defmodule Theoffersbr.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: false, type: :utc_datetime]

  @roles [:admin, :user]

  schema "user_roles" do
    field :user_id, :binary_id
    field :role, Ecto.Enum, values: @roles, default: :user

    timestamps()
  end

  def roles, do: @roles

  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role])
    |> validate_required([:user_id, :role])
    |> unique_constraint([:user_id, :role])
  end
end
