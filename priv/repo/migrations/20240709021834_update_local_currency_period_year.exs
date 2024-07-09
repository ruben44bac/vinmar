defmodule Vinmar.Repo.Migrations.UpdateLocalCurrencyPeriodYear do
  use Ecto.Migration

  def change do
    alter table(:local_currency_periods) do
      add :year, :string
    end
  end
end
