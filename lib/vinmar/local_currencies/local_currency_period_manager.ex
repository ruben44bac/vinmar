defmodule Vinmar.LocalCurrencies.LocalCurrencyPeriodManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.LocalCurrencies.LocalCurrencyPeriod,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :delete, :update]
end
