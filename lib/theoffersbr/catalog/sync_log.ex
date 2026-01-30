defmodule Theoffersbr.Catalog.SyncLog do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theoffersbr.Catalog.Store

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at, updated_at: false, type: :utc_datetime]

  schema "sync_logs" do
    field :status, :string
    field :message, :string
    field :offers_created, :integer
    field :offers_updated, :integer

    belongs_to :store, Store

    timestamps()
  end

  def changeset(sync_log, attrs) do
    sync_log
    |> cast(attrs, [:status, :message, :offers_created, :offers_updated, :store_id])
    |> validate_required([:status])
  end
end
