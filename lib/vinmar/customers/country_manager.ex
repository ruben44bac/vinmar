defmodule Vinmar.Customers.CountryManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Customers.Country,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :preloads, :update]
end
