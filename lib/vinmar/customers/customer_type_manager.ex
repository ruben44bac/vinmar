defmodule Vinmar.Customers.CustomerTypeManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Customers.CustomerType,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :preloads, :update]
end
