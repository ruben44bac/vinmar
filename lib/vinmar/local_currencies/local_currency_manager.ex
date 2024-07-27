defmodule Vinmar.LocalCurrencies.LocalCurrencyManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.LocalCurrencies.LocalCurrency,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get!, :delete, :update]

  alias Vinmar.LocalCurrencies.LocalCurrency

  alias Vinmar.Repo

  def get_available_periods(nil), do: []

  def get_available_periods(%{id: id, customer_id: customer_id}) do
    LocalCurrency
    |> join(:inner, [lc], lcp in assoc(lc, :local_currency_period))
    |> where([lc, lcp], lc.id != ^id and lc.customer_id == ^customer_id and not is_nil(lcp.year))
    |> select([lc, lcp], %{
      id: lcp.id,
      year: lcp.year,
      period: lcp.period,
      no_months: lcp.no_months,
      statetment_as_to: lcp.statetment_as_to
    })
    |> Repo.all()
  end
end
