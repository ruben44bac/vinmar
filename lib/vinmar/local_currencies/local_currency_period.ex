defmodule Vinmar.LocalCurrencies.LocalCurrencyPeriod do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.LocalCurrencies.{ExchangeRate, LocalCurrency, FinancialStatementFormat}
  alias Vinmar.Accounts.User

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [
    :local_currency_id,
    :user_id,
    :balance_f_x,
    :pl_f_x,
    :period,
    :statetment_a,
    :statetment_as_to,
    :no_months,
    :units,
    :cash,
    :accounts_receivable_net,
    :inventory,
    :affiliates_advances,
    :def_refundable_inc_tax,
    :other_current_assets,
    :prepaid,
    :machinery_equipment,
    :office_equipment,
    :other_fixed_assets,
    :transportation_equipment,
    :real_state_buildings,
    :less_accumulated_depr,
    :due_from_affiliates,
    :deferred_charges,
    :intangible_goodwill,
    :investment_others,
    :other_assets_1,
    :other_assets_2,
    :bank_overdraft,
    :accounts_payable,
    :bank_payable,
    :other_current_liab,
    :current_portion_ltd,
    :bank_long_term_debt,
    :other_lt_liabilities,
    :subordinated_debt,
    :common_stock,
    :other,
    :treasury_stock,
    :retained_earnings,
    :other_2,
    :dividens_other,
    :cash_flow_operation,
    :revenue,
    :less_return_allow,
    :cost_goods_sold,
    :cost_goods_other,
    :salaries_wages,
    :operating_experenses,
    :selling_expense,
    :other_selling_expense,
    :bad_debt_expense,
    :general_admin_exp,
    :depreciation_expense,
    :amortization_expense,
    :interest_expense,
    :non_recurring_expense,
    :interest_income,
    :other_income_expense,
    :taxes,
    :other_current_assets_description,
    :other_fixed_assets_description,
    :other_assets_description,
    :other_current_liabilities_description,
    :other_lt_liabilities_description,
    :other_description,
    :other_cost_goods_description,
    :other_income_description,
    :other_before_taxes_description
  ]
  @required_fields [
    :financial_statement_format_id,
    :exchange_rate_id
  ]

  typed_schema "local_currency_periods" do
    field :balance_f_x, Money.Ecto.Composite.Type
    field :pl_f_x, :decimal
    field :period, :string
    field :statetment_a, :utc_datetime
    field :statetment_as_to, :utc_datetime
    field :no_months, :integer
    field :units, :decimal
    field :cash, Money.Ecto.Composite.Type
    field :accounts_receivable_net, Money.Ecto.Composite.Type
    field :inventory, Money.Ecto.Composite.Type
    field :affiliates_advances, Money.Ecto.Composite.Type
    field :def_refundable_inc_tax, Money.Ecto.Composite.Type
    field :other_current_assets, Money.Ecto.Composite.Type
    field :prepaid, Money.Ecto.Composite.Type
    field :other_current_assets_description, :string
    field :other_fixed_assets_description, :string
    field :other_assets_description, :string
    field :other_current_liabilities_description, :string
    field :other_lt_liabilities_description, :string
    field :other_description, :string
    field :other_cost_goods_description, :string
    field :other_income_description, :string
    field :other_before_taxes_description, :string

    field :machinery_equipment, Money.Ecto.Composite.Type
    field :office_equipment, Money.Ecto.Composite.Type
    field :other_fixed_assets, Money.Ecto.Composite.Type
    field :transportation_equipment, Money.Ecto.Composite.Type
    field :real_state_buildings, Money.Ecto.Composite.Type
    field :less_accumulated_depr, Money.Ecto.Composite.Type
    field :due_from_affiliates, Money.Ecto.Composite.Type
    field :deferred_charges, Money.Ecto.Composite.Type
    field :intangible_goodwill, Money.Ecto.Composite.Type
    field :investment_others, Money.Ecto.Composite.Type
    field :other_assets_1, Money.Ecto.Composite.Type
    field :other_assets_2, Money.Ecto.Composite.Type
    field :bank_overdraft, Money.Ecto.Composite.Type
    field :accounts_payable, Money.Ecto.Composite.Type
    field :bank_payable, Money.Ecto.Composite.Type
    field :other_current_liab, Money.Ecto.Composite.Type
    field :current_portion_ltd, Money.Ecto.Composite.Type
    field :bank_long_term_debt, Money.Ecto.Composite.Type
    field :other_lt_liabilities, Money.Ecto.Composite.Type
    field :subordinated_debt, Money.Ecto.Composite.Type
    field :common_stock, Money.Ecto.Composite.Type
    field :other, Money.Ecto.Composite.Type
    field :treasury_stock, Money.Ecto.Composite.Type
    field :retained_earnings, Money.Ecto.Composite.Type
    field :other_2, Money.Ecto.Composite.Type
    field :dividens_other, Money.Ecto.Composite.Type
    field :cash_flow_operation, Money.Ecto.Composite.Type
    field :revenue, Money.Ecto.Composite.Type
    field :less_return_allow, Money.Ecto.Composite.Type
    field :cost_goods_sold, Money.Ecto.Composite.Type
    field :cost_goods_other, Money.Ecto.Composite.Type
    field :salaries_wages, Money.Ecto.Composite.Type
    field :operating_experenses, Money.Ecto.Composite.Type
    field :selling_expense, Money.Ecto.Composite.Type
    field :other_selling_expense, Money.Ecto.Composite.Type
    field :bad_debt_expense, Money.Ecto.Composite.Type
    field :general_admin_exp, Money.Ecto.Composite.Type
    field :depreciation_expense, Money.Ecto.Composite.Type
    field :amortization_expense, Money.Ecto.Composite.Type
    field :interest_expense, Money.Ecto.Composite.Type
    field :non_recurring_expense, Money.Ecto.Composite.Type
    field :interest_income, Money.Ecto.Composite.Type
    field :other_income_expense, Money.Ecto.Composite.Type
    field :taxes, Money.Ecto.Composite.Type

    belongs_to :financial_statement_format, FinancialStatementFormat,
      foreign_key: :financial_statement_format_id,
      type: Ecto.UUID

    belongs_to :local_currency, LocalCurrency,
      foreign_key: :local_currency_id,
      type: Ecto.UUID

    belongs_to :exchange_rate, ExchangeRate,
      foreign_key: :exchange_rate_id,
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
