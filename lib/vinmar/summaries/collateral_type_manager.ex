defmodule Vinmar.Summaries.CollateralTypeManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Summaries.CollateralType,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :delete, :update]
end
