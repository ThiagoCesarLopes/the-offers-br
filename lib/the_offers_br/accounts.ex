defmodule Theoffersbr.Accounts do
  import Ecto.Query, warn: false

  alias Theoffersbr.Repo
  alias Theoffersbr.Accounts.{Profile, ProfileType, UserRole, AssociateSocialAccount}

  def list_profiles do
    Repo.all(from p in Profile, order_by: p.display_name)
  end

  def get_profile!(id), do: Repo.get!(Profile, id)

  def list_profile_types do
    Repo.all(from pt in ProfileType, order_by: pt.name)
  end

  def list_user_roles do
    Repo.all(UserRole)
  end

  def list_associate_social_accounts do
    Repo.all(from a in AssociateSocialAccount, order_by: [desc: a.created_at])
  end

  def create_associate_social_account(attrs) do
    %AssociateSocialAccount{}
    |> AssociateSocialAccount.changeset(attrs)
    |> Repo.insert()
  end
end
