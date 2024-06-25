defmodule Vinmar.Customers.CustomerManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Customers.Customer,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :preloads, :update]
end
