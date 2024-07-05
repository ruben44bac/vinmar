defmodule Vinmar.LocalCurrencies.CurrencyTypeManagment do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.LocalCurrencies.CurrencyType,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :delete, :update]
end
