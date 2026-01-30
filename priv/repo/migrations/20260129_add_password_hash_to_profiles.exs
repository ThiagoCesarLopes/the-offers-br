defmodule Theoffersbr.Repo.Migrations.AddPasswordHashToProfiles do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :password_hash, :string
    end
  end
end
