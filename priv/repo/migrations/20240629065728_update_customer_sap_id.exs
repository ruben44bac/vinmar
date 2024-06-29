defmodule Vinmar.Repo.Migrations.UpdateCustomerSapId do
  use Ecto.Migration

  def change do
    alter table(:customers) do
      modify :sap_id, :string
    end
  end
end
