defmodule Vinmar.Repo.Migrations.AddRatioAnalysis do
  use Ecto.Migration

  def change do
    create table(:ratio_analysis, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")

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
      add :current_ratio, :money_with_currency
      add :quick_ratio, :money_with_currency
      add :cash_flow_operation, :money_with_currency
      add :cash_flow_liquidity, :money_with_currency
      add :working_capital, :money_with_currency
      add :debt_equity, :money_with_currency
      add :debt_ratio, :money_with_currency
      add :times_interest_earned, :money_with_currency
      add :lt_working_capital, :money_with_currency
      add :dscr, :money_with_currency

      add(
        :local_currency_period_id,
        references(:local_currency_periods, on_delete: :nothing, type: :uuid)
      )

      timestamps(type: :utc_datetime)
    end
  end
end
