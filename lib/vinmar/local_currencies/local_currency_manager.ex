defmodule Vinmar.LocalCurrencies.LocalCurrencyManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.LocalCurrencies.LocalCurrency,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :delete, :update]
end
