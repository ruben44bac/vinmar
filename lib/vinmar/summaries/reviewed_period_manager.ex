defmodule Vinmar.Summaries.ReviewedPeriodManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Summaries.ReviewedPeriod,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :delete, :update]
end
