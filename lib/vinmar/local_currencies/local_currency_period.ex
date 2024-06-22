defmodule Vinmar.LocalCurrencies.LocalCurrencyPeriod do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.LocalCurrencies.{ExchangeRate, LocalCurrency}
  alias Vinmar.Accounts.User

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [:local_currency_id, :exchange_rate_id, :user_id]
  @required_fields [
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
    :taxes
  ]

  typed_schema "local_currency_periods" do
    field :balance_f_x, Money.Ecto.Amount.Type
    field :pl_f_x, :decimal
    field :period, :string
    field :statetment_a, :utc_datetime
    field :statetment_as_to, :utc_datetime
    field :no_months, :integer
    field :units, :decimal
    field :cash, Money.Ecto.Amount.Type
    field :accounts_receivable_net, Money.Ecto.Amount.Type
    field :inventory, Money.Ecto.Amount.Type
    field :affiliates_advances, Money.Ecto.Amount.Type
    field :def_refundable_inc_tax, Money.Ecto.Amount.Type
    field :other_current_assets, Money.Ecto.Amount.Type
    field :prepaid, Money.Ecto.Amount.Type
    field :machinery_equipment, Money.Ecto.Amount.Type
    field :office_equipment, Money.Ecto.Amount.Type
    field :other_fixed_assets, Money.Ecto.Amount.Type
    field :transportation_equipment, Money.Ecto.Amount.Type
    field :real_state_buildings, Money.Ecto.Amount.Type
    field :less_accumulated_depr, Money.Ecto.Amount.Type
    field :due_from_affiliates, Money.Ecto.Amount.Type
    field :deferred_charges, Money.Ecto.Amount.Type
    field :intangible_goodwill, Money.Ecto.Amount.Type
    field :investment_others, Money.Ecto.Amount.Type
    field :other_assets_1, Money.Ecto.Amount.Type
    field :other_assets_2, Money.Ecto.Amount.Type
    field :bank_overdraft, Money.Ecto.Amount.Type
    field :accounts_payable, Money.Ecto.Amount.Type
    field :bank_payable, Money.Ecto.Amount.Type
    field :other_current_liab, Money.Ecto.Amount.Type
    field :current_portion_ltd, Money.Ecto.Amount.Type
    field :bank_long_term_debt, Money.Ecto.Amount.Type
    field :other_lt_liabilities, Money.Ecto.Amount.Type
    field :subordinated_debt, Money.Ecto.Amount.Type
    field :common_stock, Money.Ecto.Amount.Type
    field :other, Money.Ecto.Amount.Type
    field :treasury_stock, Money.Ecto.Amount.Type
    field :retained_earnings, Money.Ecto.Amount.Type
    field :other_2, Money.Ecto.Amount.Type
    field :dividens_other, Money.Ecto.Amount.Type
    field :cash_flow_operation, Money.Ecto.Amount.Type
    field :revenue, Money.Ecto.Amount.Type
    field :less_return_allow, Money.Ecto.Amount.Type
    field :cost_goods_sold, Money.Ecto.Amount.Type
    field :cost_goods_other, Money.Ecto.Amount.Type
    field :salaries_wages, Money.Ecto.Amount.Type
    field :operating_experenses, Money.Ecto.Amount.Type
    field :selling_expense, Money.Ecto.Amount.Type
    field :other_selling_expense, Money.Ecto.Amount.Type
    field :bad_debt_expense, Money.Ecto.Amount.Type
    field :general_admin_exp, Money.Ecto.Amount.Type
    field :depreciation_expense, Money.Ecto.Amount.Type
    field :amortization_expense, Money.Ecto.Amount.Type
    field :interest_expense, Money.Ecto.Amount.Type
    field :non_recurring_expense, Money.Ecto.Amount.Type
    field :interest_income, Money.Ecto.Amount.Type
    field :other_income_expense, Money.Ecto.Amount.Type
    field :taxes, Money.Ecto.Amount.Type

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
