defmodule Vinmar.LocalCurrencies.RatioAnalysis do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.LocalCurrencies.LocalCurrencyPeriod

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [
    :gross_profit_margin,
    :operating_profit_margin,
    :net_profit_margin,
    :return_assets,
    :roce,
    :leverage,
    :return_equity,
    :cash_flow_margin,
    :dso,
    :dio,
    :dpo,
    :dwo,
    :fixed_asset_turnover,
    :net_asset_to,
    :sales_total_assets,
    :current_ratio,
    :quick_ratio,
    :cash_flow_operation,
    :cash_flow_liquidity,
    :working_capital,
    :debt_equity,
    :debt_ratio,
    :times_interest_earned,
    :lt_working_capital,
    :dscr
  ]
  @required_fields [:local_currency_period_id]

  typed_schema "ratio_analysis" do
    field :gross_profit_margin, Money.Ecto.Composite.Type
    field :operating_profit_margin, Money.Ecto.Composite.Type
    field :net_profit_margin, Money.Ecto.Composite.Type
    field :return_assets, Money.Ecto.Composite.Type
    field :roce, Money.Ecto.Composite.Type
    field :leverage, Money.Ecto.Composite.Type
    field :return_equity, Money.Ecto.Composite.Type
    field :cash_flow_margin, Money.Ecto.Composite.Type
    field :dso, Money.Ecto.Composite.Type
    field :dio, Money.Ecto.Composite.Type
    field :dpo, Money.Ecto.Composite.Type
    field :dwo, Money.Ecto.Composite.Type
    field :fixed_asset_turnover, Money.Ecto.Composite.Type
    field :net_asset_to, Money.Ecto.Composite.Type
    field :sales_total_assets, Money.Ecto.Composite.Type
    field :current_ratio, Money.Ecto.Composite.Type
    field :quick_ratio, Money.Ecto.Composite.Type
    field :cash_flow_operation, Money.Ecto.Composite.Type
    field :cash_flow_liquidity, Money.Ecto.Composite.Type
    field :working_capital, Money.Ecto.Composite.Type
    field :debt_equity, Money.Ecto.Composite.Type
    field :debt_ratio, Money.Ecto.Composite.Type
    field :times_interest_earned, Money.Ecto.Composite.Type
    field :lt_working_capital, Money.Ecto.Composite.Type
    field :dscr, Money.Ecto.Composite.Type

    belongs_to :local_currency_period, LocalCurrencyPeriod,
      foreign_key: :local_currency_period_id,
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
