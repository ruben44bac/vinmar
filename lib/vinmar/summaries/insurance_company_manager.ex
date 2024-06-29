defmodule Vinmar.Summaries.InsuranceCompanyManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.Summaries.InsuranceCompany,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :delete, :update]
end
