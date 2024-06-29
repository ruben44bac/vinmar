defmodule Vinmar.Summaries.FinancialStatementSourceManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Summaries.FinancialStatementSource,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :delete, :update]
end
