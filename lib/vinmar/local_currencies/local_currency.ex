defmodule Vinmar.LocalCurrencies.LocalCurrency do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.Accounts.User
  alias Vinmar.Customers.Customer
  alias Vinmar.LocalCurrencies.CurrencyType
  alias Vinmar.Summaries.FinancialStatementSource

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [:user_id, :customer_id, :currency_type_id]
  @required_fields [:financial_statement_format_id]

  typed_schema "local_currencies" do
    belongs_to :financial_statement_format, FinancialStatementSource,
      foreign_key: :financial_statement_format_id,
      type: Ecto.UUID

    belongs_to :currency_type, CurrencyType,
      foreign_key: :currency_type_id,
      type: Ecto.UUID

    belongs_to :customer, Customer,
      foreign_key: :customer_id,
      type: Ecto.UUID

    belongs_to :user, User,
      foreign_key: :user_id,
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
