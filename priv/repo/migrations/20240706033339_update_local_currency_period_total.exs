defmodule Vinmar.Repo.Migrations.UpdateLocalCurrencyPeriodTotal do
  use Ecto.Migration

  def change do
    alter table(:local_currency_periods) do
      add :gross_profit_margin, :money_with_currency
      add :operating_profit_margin, :money_with_currency
      add :net_profit_margin, :money_with_currency
      add :return_assets, :money_with_currency
      add :roce, :money_with_currency
      add :leverage, :money_with_currency
      add :return_equity, :money_with_currency
      add :cash_flow_margin, :money_with_currency

      add :dso, :money_with_currency
      add :dio, :money_with_currency
      add :dpo, :money_with_currency
      add :dwo, :money_with_currency
      add :fixed_asset_turnover, :money_with_currency
      add :net_asset_to, :money_with_currency
      add :sales_total_assets, :money_with_currency

      add :current_ration, :money_with_currency
      add :quick_ratio, :money_with_currency
      add :cash_flow_from_operation, :money_with_currency
      add :cash_flow_liquidity_ratio, :money_with_currency
      add :working_capital, :money_with_currency

      add :debt_to_equity, :money_with_currency
      add :dect_ratio, :money_with_currency
      add :times_interest_earned, :money_with_currency
      add :lt_working_capital, :money_with_currency
      add :dscr, :money_with_currency

      add :current_assets_total, :money_with_currency
      add :fixed_assets_total, :money_with_currency
      add :other_assets_total, :money_with_currency
      add :current_liabilities_total, :money_with_currency
      add :long_term_debt_total, :money_with_currency
      add :stockholder_equity_total, :money_with_currency
      add :gross_margin_total, :money_with_currency
      add :operating_income_total, :money_with_currency
      add :net_income_total, :money_with_currency
    end
  end
end
