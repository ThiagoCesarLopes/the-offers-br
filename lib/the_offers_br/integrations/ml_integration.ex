defmodule Theoffersbr.Integrations.MLIntegration do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime]

  schema "ml_integrations" do
    field :user_id, :binary_id
    field :app_id, :string
    field :client_secret, :string
    field :access_token, :string
    field :refresh_token, :string
    field :token_expires_at, :utc_datetime
    field :seller_id, :string
    field :nickname, :string
    field :is_active, :boolean, default: true

    timestamps()
  end

  def changeset(integration, attrs) do
    integration
    |> cast(attrs, [
      :user_id,
      :app_id,
      :client_secret,
      :access_token,
      :refresh_token,
      :token_expires_at,
      :seller_id,
      :nickname,
      :is_active
    ])
    |> validate_required([:user_id, :app_id, :client_secret])
    |> unique_constraint(:user_id)
  end
end
