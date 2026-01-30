defmodule Theoffersbr.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theoffersbr.Accounts.ProfileType

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime]

  @pix_types [:cpf, :cnpj, :email, :phone, :random]

  schema "profiles" do
    field :display_name, :string
    field :avatar_url, :string
    field :associate_id, :string
    field :pix_key, :string
    field :pix_type, Ecto.Enum, values: @pix_types
    field :notification_email, :string
    field :notification_whatsapp, :string
    field :email, :string
    field :first_login, :boolean
    field :password_hash, :string

    belongs_to :profile_type, ProfileType

    timestamps()
  end

  def pix_types, do: @pix_types

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [
      :id,
      :display_name,
      :avatar_url,
      :associate_id,
      :pix_key,
      :pix_type,
      :notification_email,
      :notification_whatsapp,
      :email,
      :first_login,
      :password_hash,
      :profile_type_id
    ])
    |> validate_required([:id])
    |> unique_constraint(:associate_id)
  end
end
