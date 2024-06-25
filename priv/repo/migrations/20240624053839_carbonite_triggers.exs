defmodule Vinmar.Repo.Migrations.CarboniteTriggers do
  use Ecto.Migration

  @mode Application.compile_env!(:vinmar, :carbonite_mode)

  def up do
    Carbonite.Migrations.create_trigger(:customers)
    Carbonite.Migrations.put_trigger_config(:customers, :mode, @mode)
    Carbonite.Migrations.put_trigger_config(:customers, :store_changed_from, true)

    Carbonite.Migrations.create_trigger(:local_currencies)
    Carbonite.Migrations.put_trigger_config(:local_currencies, :mode, @mode)
    Carbonite.Migrations.put_trigger_config(:local_currencies, :store_changed_from, true)

    Carbonite.Migrations.create_trigger(:executive_summaries)
    Carbonite.Migrations.put_trigger_config(:executive_summaries, :mode, @mode)
    Carbonite.Migrations.put_trigger_config(:executive_summaries, :store_changed_from, true)
  end

  def down do
    Carbonite.Migrations.drop_trigger(:customers)
    Carbonite.Migrations.drop_trigger(:local_currencies)
    Carbonite.Migrations.drop_trigger(:executive_summaries)
  end
end
