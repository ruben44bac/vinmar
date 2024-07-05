defmodule Vinmar.Repo.Migrations.UpdateLocalCurrencyDescriptions do
  use Ecto.Migration

  def change do
    alter table(:local_currency_periods) do
      add :other_current_assets_description, :string
      add :other_fixed_assets_description, :string
      add :other_assets_description, :string
      add :other_current_liabilities_description, :string
      add :other_lt_liabilities_description, :string
      add :other_description, :string
      add :other_cost_goods_description, :string
      add :other_income_description, :string
      add :other_before_taxes_description, :string
    end
  end
end
