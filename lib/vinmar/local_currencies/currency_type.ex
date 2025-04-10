defmodule Vinmar.LocalCurrencies.CurrencyType do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields []
  @required_fields [:money_name, :money_key]

  typed_schema "currency_types" do
    field :money_name, :string
    field :money_key, :string

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @required_fields)
    |> cast(attrs, @optional_fields)
    |> validate_required(@required_fields)
  end
end
