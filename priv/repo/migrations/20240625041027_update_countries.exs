defmodule Vinmar.Repo.Migrations.UpdateCountries do
  use Ecto.Migration

  def change do
    alter table(:countries) do
      add :mr_2015, :string, size: 10
      add :sp_rating, :string, size: 10
      add :sp_score, :decimal
      add :db_rating, :string, size: 10
      add :db_score, :decimal
      add :coface_rating, :string, size: 10
      add :coface_score, :decimal
      add :eiu_rating, :string, size: 10
      add :eiu_score, :decimal
      add :ihs_rating, :decimal
      add :score, :decimal
      add :total, :decimal
      add :mean_score, :decimal
      add :comments, :string
      add :insurance_coverage, :string
    end
  end
end
