defmodule Vinmar.LocalCurrencies.FinancialStatementFormatManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.LocalCurrencies.FinancialStatementFormat,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :delete, :update]
end
