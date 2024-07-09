defmodule Vinmar.LocalCurrencies.RatioAnalysisManager do
  @moduledoc """

  """
  use Vinmar.BaseManager,
    schema: Vinmar.LocalCurrencies.RatioAnalysis,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get, :delete, :update]

  @fields [
    :gross_profit_margin,
    :operating_profit_margin,
    :net_profit_margin,
    :leverage,
    :dso,
    :dio,
    :dpo,
    :dwo,
    :fixed_asset_turnover,
    :net_asset_to,
    :sales_total_assets,
    :return_assets,
    :roce,
    :return_equity,
    :cash_flow_margin,
    :current_ratio,
    :quick_ratio,
    :cash_flow_operation,
    :cash_flow_liquidity,
    :working_capital,
    :debt_equity,
    :debt_ratio,
    :times_interest_earned,
    :lt_working_capital,
    :dscr
  ]

  def calculate_ratio(period) do
    Enum.reduce(@fields, %{}, fn atom, acc ->
      Map.put(acc, atom, calculate_ratio(period, atom))
    end)
  end

  defp calculate_ratio(period, :gross_profit_margin) do
    period.gross_margin_total
    |> Money.div(period.revenue)
    |> case do
      {:ok, value} -> value
      _error -> nil
    end
  end

  defp calculate_ratio(period, :operating_profit_margin) do
    period.operating_income_total
    |> Money.div(period.revenue)
    |> case do
      {:ok, value} -> value
      _error -> nil
    end
  end

  defp calculate_ratio(period, :net_profit_margin) do
    period.net_income_total
    |> Money.add(period.taxes)
    |> case do
      {:ok, value} ->
        value
        |> Money.div(period.revenue)
        |> case do
          {:ok, value} -> value
          _error -> nil
        end

      _error ->
        nil
    end
  end

  defp calculate_ratio(period, :leverage) do
    period.other_assets_total
    |> Money.div(period.stockholder_equity_total)
    |> case do
      {:ok, value} -> value
      _error -> nil
    end
  end
end
