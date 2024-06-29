defmodule Vinmar.Summaries.ExecutiveSummaryManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Summaries.ExecutiveSummary,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :preloads, :update]
end
