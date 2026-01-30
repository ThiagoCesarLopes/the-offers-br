defmodule Theoffersbr.Repo.Migrations.CreateInitialTables do
  use Ecto.Migration

  def change do
    create table(:profile_types, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :name, :string, null: false
      add :description, :string
    end

    create unique_index(:profile_types, [:name])

    create table(:profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: false
      add :display_name, :string
      add :avatar_url, :string
      add :associate_id, :string
      add :pix_key, :string
      add :pix_type, :string
      add :notification_email, :string
      add :notification_whatsapp, :string
      add :email, :string
      add :first_login, :boolean
      add :password_hash, :string
      add :profile_type_id, references(:profile_types, type: :binary_id)

      timestamps(inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime)
    end

    create unique_index(:profiles, [:associate_id])

    create table(:user_roles, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :user_id, references(:profiles, type: :binary_id, on_delete: :delete_all)
      add :role, :string, null: false
      add :created_at, :utc_datetime, default: fragment("NOW()"), null: false
    end

    create unique_index(:user_roles, [:user_id, :role])

    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :name, :string, null: false
      add :icon, :string
      add :is_active, :boolean, default: true

      timestamps(inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime)
    end

    create unique_index(:categories, [:name])

    create table(:stores, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :name, :string, null: false
      add :store_type, :string, null: false
      add :affiliate_tag, :string
      add :is_active, :boolean, default: true

      timestamps(inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime)
    end

    create table(:offers, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :title, :string, null: false
      add :image_url, :string, null: false
      add :original_price, :decimal, null: false
      add :current_price, :decimal, null: false
      add :discount, :integer
      add :store_type, :string, null: false
      add :affiliate_link, :string, null: false
      add :is_hot, :boolean, default: false
      add :is_active, :boolean, default: true
      add :external_id, :string
      add :description, :text
      add :delivery_days, :integer
      add :store_rating, :decimal
      add :installments, :integer
      add :installment_value, :decimal
      add :commission_percentage, :decimal
      add :store_id, references(:stores, type: :binary_id, on_delete: :delete_all)
      add :category_id, references(:categories, type: :binary_id, on_delete: :delete_all)

      timestamps(inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime)
    end

    create index(:offers, [:store_id])
    create index(:offers, [:category_id])

    create table(:offer_clicks, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :user_id, :binary_id
      add :associate_id, :string
      add :ip_address, :string
      add :user_agent, :string
      add :referrer, :string
      add :session_id, :string
      add :converted, :boolean, default: false
      add :conversion_value, :decimal
      add :conversion_at, :utc_datetime
      add :affiliate_order_id, :string
      add :offer_id, references(:offers, type: :binary_id, on_delete: :delete_all)
      add :clicked_at, :utc_datetime, default: fragment("NOW()"), null: false
    end

    create index(:offer_clicks, [:offer_id])

    create table(:favorites, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :user_id, :binary_id
      add :offer_id, references(:offers, type: :binary_id, on_delete: :delete_all)

      timestamps(inserted_at: :created_at, updated_at: :updated_at, type: :utc_datetime)
    end

    create unique_index(:favorites, [:user_id, :offer_id])

    create table(:sync_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :status, :string
      add :message, :string
      add :offers_created, :integer
      add :offers_updated, :integer
      add :store_id, references(:stores, type: :binary_id, on_delete: :delete_all)
      add :created_at, :utc_datetime, default: fragment("NOW()"), null: false
    end

    create index(:sync_logs, [:store_id])
  end
end
