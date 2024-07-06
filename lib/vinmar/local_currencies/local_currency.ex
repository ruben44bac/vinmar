defmodule Vinmar.LocalCurrencies.LocalCurrency do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.Accounts.User
  alias Vinmar.Customers.Customer

  alias Vinmar.LocalCurrencies.{
    CurrencyType,
    LocalCurrencyPeriod
  }

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [:user_id, :currency_type_id]
  @required_fields [:customer_id]

  typed_schema "local_currencies" do
    belongs_to :currency_type, CurrencyType,
      foreign_key: :currency_type_id,
      type: Ecto.UUID

    belongs_to :customer, Customer,
      foreign_key: :customer_id,
      type: Ecto.UUID

    belongs_to :user, User,
      foreign_key: :user_id,
      type: Ecto.UUID

    has_one :local_currency_period, LocalCurrencyPeriod

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
