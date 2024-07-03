defmodule Vinmar.LocalCurrencies.ExchangeRate do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.LocalCurrencies.CurrencyType

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [:dollar_amount, :day, :currency_type_id]
  @required_fields []

  typed_schema "exchange_rates" do
    field :dollar_amount, Money.Ecto.Composite.Type
    field :day, :date

    belongs_to :currency_types, CurrencyType,
      foreign_key: :currency_type_id,
      type: Ecto.UUID

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
