defmodule Theoffersbr.Accounts.AssociateSocialAccount do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime]

  @platforms [:twitter, :instagram, :tiktok, :youtube, :facebook, :linkedin, :threads]

  schema "associate_social_accounts" do
    field :associate_id, :string
    field :user_id, :binary_id
    field :platform, :string
    field :username, :string
    field :profile_url, :string
    field :social_url, :string
    field :follower_count, :integer
    field :is_verified, :boolean, default: false
    field :is_active, :boolean, default: true

    timestamps()
  end

  def platforms, do: @platforms

  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      :associate_id,
      :user_id,
      :platform,
      :username,
      :profile_url,
      :social_url,
      :follower_count,
      :is_verified,
      :is_active
    ])
    |> validate_required([:user_id, :platform])
  end
end
