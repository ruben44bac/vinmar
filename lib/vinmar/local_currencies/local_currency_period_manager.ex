defmodule Vinmar.LocalCurrencies.LocalCurrencyPeriodManager do
  @moduledoc false

  use Vinmar.BaseManager,
    schema: Vinmar.LocalCurrencies.LocalCurrencyPeriod,
    repo: Vinmar.Repo,
    only: [:get_all, :create, :get, :delete, :update]

  alias Vinmar.LocalCurrencies.LocalCurrencyPeriod

  alias Vinmar.Repo

  def get_periods(ids) do
    LocalCurrencyPeriod
    |> where([w], w.id in ^ids)
    |> Repo.all()
  end

  def calculate_total(form, money_key, local_currency_period, type) do
    total = sum_amounts(form, :decimal)

    form
    |> Map.put("#{type}_total", Money.new!(money_key, total))
    |> calculate_extra_total(money_key, local_currency_period, type)
  end

  defp calculate_extra_total(
         %{"gross_margin_total" => other_total} = form,
         money_key,
         local_currency_period,
         "gross_margin"
       ) do
    total =
      local_currency_period
      |> Map.take(operating_income())
      |> sum_amounts(money_key)
      |> Money.add!(other_total)

    form
    |> Map.put("operating_income_total", total)
    |> calculate_extra_total(money_key, local_currency_period, "operating_income")
  end

  defp calculate_extra_total(
         %{"operating_income_total" => other_total} = form,
         money_key,
         local_currency_period,
         "operating_income"
       ) do
    total =
      local_currency_period
      |> Map.take(net_income())
      |> sum_amounts(money_key)
      |> Money.add!(other_total)

    form
    |> Map.put("net_income_total", total)
  end

  defp calculate_extra_total(form, _money_key, _local_currency_period, _type), do: form

  defp sum_amounts(form_map, :decimal) do
    Enum.reduce(form_map, Decimal.new("0"), fn {k, v}, acc ->
      case Decimal.cast(v) do
        {:ok, decimal} -> Decimal.add(acc, decimal)
        _error -> acc
      end
    end)
  end

  defp sum_amounts(form_map, money_key) do
    Enum.reduce(form_map, Money.new!(money_key, "0"), fn {k, v}, acc ->
      case v do
        nil -> acc
        money -> Money.add!(acc, money)
      end
    end)
  end

  def get_topic_keys(topic) do
    case topic do
      "current_assets" -> current_assets()
      "fixed_assets" -> fixed_assets()
      "other_assets" -> other_assets()
      "current_liabilities" -> current_liabilities()
      "long_term_debt" -> long_term_debt()
      "stockholder_equity" -> stockholder_equity()
      "gross_margin" -> gross_margin()
      "operating_income" -> operating_income()
      "net_income" -> net_income()
    end
  end

  defp current_assets do
    [
      :cash,
      :accounts_receivable_net,
      :inventory,
      :affiliates_advances,
      :def_refundable_inc_tax,
      :prepaid,
      :other_current_assets,
      :other_current_assets_description
    ]
  end

  defp fixed_assets do
    [
      :machinery_equipment,
      :office_equipment,
      :real_state_buildings,
      :transportation_equipment,
      :other_fixed_assets,
      :other_fixed_assets_description,
      :less_accumulated_depr
    ]
  end

  defp other_assets do
    [
      :due_from_affiliates,
      :deferred_charges,
      :intangible_goodwill,
      :investment_others,
      :other_assets_1,
      :other_assets_description
    ]
  end

  defp current_liabilities do
    [
      :bank_overdraft,
      :accounts_payable,
      :bank_payable,
      :current_portion_ltd,
      :other_current_liab,
      :other_current_liabilities_description
    ]
  end

  defp long_term_debt do
    [
      :bank_long_term_debt,
      :subordinated_debt,
      :other_lt_liabilities,
      :other_lt_liabilities_description
    ]
  end

  defp stockholder_equity do
    [
      :common_stock,
      :treasury_stock,
      :retained_earnings,
      :dividens_other,
      :cash_flow_operation,
      :other,
      :other_2,
      :other_description
    ]
  end

  defp gross_margin do
    [
      :revenue,
      :less_return_allow,
      :cost_goods_sold,
      :cost_goods_other,
      :other_cost_goods_description
    ]
  end

  defp operating_income do
    [
      :salaries_wages,
      :operating_experenses,
      :selling_expense,
      :bad_debt_expense,
      :general_admin_exp,
      :depreciation_expense,
      :amortization_expense,
      :other_selling_expense,
      :other_income_description
    ]
  end

  defp net_income do
    [
      :interest_expense,
      :non_recurring_expense,
      :interest_income,
      :other_income_expense,
      :other_before_taxes_description
    ]
  end
end
