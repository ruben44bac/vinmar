defmodule(Vinmar.Repo.Migrations.InstallCarbonite) do
  use Ecto.Migration

  @mode Application.compile_env!(:vinmar, :carbonite_mode)

  def up do
    # If you like to install Carbonite's tables into a different schema, add the
    # carbonite_prefix option.
    #
    #    Carbonite.Migrations.up(1, carbonite_prefix: "carbonite_other")

    Carbonite.Migrations.up(1..7)

    # Install a trigger for a table:
    #
    #    Carbonite.Migrations.create_trigger("rabbits")
    #    Carbonite.Migrations.create_trigger("rabbits", table_prefix: "animals")
    #    Carbonite.Migrations.create_trigger("rabbits", carbonite_prefix: "carbonite_other")

    # Configure trigger options:
    #
    #    Carbonite.Migrations.put_trigger_option("rabbits", :primary_key_columns, ["compound", "key"])
    #    Carbonite.Migrations.put_trigger_option("rabbits", :excluded_columns, ["private"])
    #    Carbonite.Migrations.put_trigger_option("rabbits", :filtered_columns, ["private"])
    #    Carbonite.Migrations.put_trigger_option("rabbits", :mode, :ignore)

    # If you wish to insert an initial outbox:
    #
    #    Carbonite.Migrations.create_outbox("rabbits")
    #    Carbonite.Migrations.create_outbox("rabbits", carbonite_prefix: "carbonite_other")
  end

  def down do
    # Remove trigger from a table:
    #
    #    Carbonite.Migrations.drop_trigger("rabbits")
    #    Carbonite.Migrations.drop_trigger("rabbits", table_prefix: "animals")
    #    Carbonite.Migrations.drop_trigger("rabbits", carbonite_prefix: "carbonite_other")

    Carbonite.Migrations.down(7..1)
  end
end
