defmodule Vinmar.Customers.CustomerManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Customers.Customer,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :preloads, :update]

  alias Vinmar.Customers.Customer

  alias Vinmar.Repo

  def search_customer(text) do
    text = "%#{text}%"

    Customer
    |> where([cus], ilike(cus.sap_id, ^text) or ilike(cus.name, ^text))
    |> order_by([cus], asc: cus.name)
    |> limit(10)
    |> preload([:customer_type, :country])
    |> Repo.all()
  end
end
