defmodule Vinmar.Summaries.ReviewManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Summaries.Review,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :get, :delete, :update]
end
