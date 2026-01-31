defmodule Theoffersbr.Integrations do
  import Ecto.Query, warn: false

  alias Theoffersbr.Repo
  alias Theoffersbr.Integrations.{MLIntegration, MLOfferMapping}

  def list_ml_integrations do
    Repo.all(from i in MLIntegration, order_by: [desc: i.created_at])
  end

  def list_ml_offer_mappings do
    Repo.all(from m in MLOfferMapping, order_by: [desc: m.created_at])
  end

  def create_ml_integration(attrs) do
    %MLIntegration{}
    |> MLIntegration.changeset(attrs)
    |> Repo.insert()
  end

  def create_ml_offer_mapping(attrs) do
    %MLOfferMapping{}
    |> MLOfferMapping.changeset(attrs)
    |> Repo.insert()
  end
end
