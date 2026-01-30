defmodule Theoffersbr.Catalog do
  import Ecto.Query, warn: false

  alias Theoffersbr.Repo
  alias Theoffersbr.Catalog.{Category, Offer, Store, Favorite, OfferClick, SyncLog}

  def list_categories do
    Repo.all(from c in Category, order_by: c.name)
  end

  def list_active_categories do
    Repo.all(from c in Category, where: c.is_active == true, order_by: c.name)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def list_stores do
    Repo.all(from s in Store, order_by: s.name)
  end

  def list_active_stores do
    Repo.all(from s in Store, where: s.is_active == true, order_by: s.name)
  end

  def get_store!(id), do: Repo.get!(Store, id)

  def list_offers(opts \\ []) do
    query =
      Offer
      |> maybe_only_active(opts)
      |> maybe_only_hot(opts)
      |> maybe_filter_by_category(opts)
      |> maybe_filter_by_store_type(opts)
      |> preload([:category, :store])
      |> order_by([o], desc: o.created_at)

    Repo.all(query)
  end

  def get_offer!(id), do: Repo.get!(Offer, id)

  def create_offer(attrs) do
    %Offer{}
    |> Offer.changeset(attrs)
    |> Repo.insert()
  end

  def create_offer_click(attrs) do
    %OfferClick{}
    |> OfferClick.changeset(attrs)
    |> Repo.insert()
  end

  def list_offer_clicks do
    Repo.all(from c in OfferClick, order_by: [desc: c.clicked_at])
  end

  def list_sync_logs do
    Repo.all(from s in SyncLog, order_by: [desc: s.created_at])
  end

  def create_favorite(attrs) do
    %Favorite{}
    |> Favorite.changeset(attrs)
    |> Repo.insert()
  end

  def delete_favorite(%Favorite{} = favorite), do: Repo.delete(favorite)

  defp maybe_only_active(query, opts) do
    if Keyword.get(opts, :active, false) do
      from o in query, where: o.is_active == true
    else
      query
    end
  end

  defp maybe_only_hot(query, opts) do
    if Keyword.get(opts, :hot, false) do
      from o in query, where: o.is_hot == true
    else
      query
    end
  end

  defp maybe_filter_by_category(query, opts) do
    case Keyword.get(opts, :category_id) do
      nil -> query
      category_id -> from(o in query, where: o.category_id == ^category_id)
    end
  end

  defp maybe_filter_by_store_type(query, opts) do
    case Keyword.get(opts, :store_type) do
      nil -> query
      store_type -> from(o in query, where: o.store_type == ^store_type)
    end
  end
end
