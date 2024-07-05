defmodule Vinmar.Repo.Migrations.UpdateLocalCurrencyFinancialStatement do
  use Ecto.Migration

  def change do
    alter table(:currency_types) do
      remove :country, :string
      remove :country_key, :string
    end

    alter table(:local_currencies) do
      remove :financial_statement_format_id
    end

    alter table(:local_currency_periods) do
      add(
        :financial_statement_format_id,
        references(:financial_statement_formats, on_delete: :nothing, type: :uuid)
      )
    end
  end
end
