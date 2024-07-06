defmodule VinmarWeb.LocalCurrencyLive.Form do
  use VinmarWeb, :live_view

  import VinmarWeb.Utils.Form,
    only: [
      format_money: 3,
      convert_options: 2,
      format_dates_to_datetime: 2,
      convert_struct_form: 1,
      convert_struct_form: 2
    ]

  alias Vinmar.LocalCurrencies.{
    CurrencyTypeManagment,
    LocalCurrencyManager,
    LocalCurrencyPeriodManager,
    FinancialStatementFormatManager,
    LocalCurrencyPeriod
  }

  import VinmarWeb.ModalComponent, only: [modal_right: 1]

  @money_fields [
    "balance_f_x",
    "cash",
    "accounts_receivable_net",
    "inventory",
    "affiliates_advances",
    "def_refundable_inc_tax",
    "other_current_assets",
    "prepaid",
    "machinery_equipment",
    "office_equipment",
    "other_fixed_assets",
    "transportation_equipment",
    "real_state_buildings",
    "less_accumulated_depr",
    "due_from_affiliates",
    "deferred_charges",
    "intangible_goodwill",
    "investment_others",
    "other_assets_1",
    "other_assets_2",
    "bank_overdraft",
    "accounts_payable",
    "bank_payable",
    "other_current_liab",
    "current_portion_ltd",
    "bank_long_term_debt",
    "other_lt_liabilities",
    "subordinated_debt",
    "common_stock",
    "other",
    "treasury_stock",
    "retained_earnings",
    "other_2",
    "dividens_other",
    "cash_flow_operation",
    "revenue",
    "less_return_allow",
    "cost_goods_sold",
    "cost_goods_other",
    "salaries_wages",
    "operating_experenses",
    "selling_expense",
    "other_selling_expense",
    "bad_debt_expense",
    "general_admin_exp",
    "depreciation_expense",
    "amortization_expense",
    "interest_expense",
    "non_recurring_expense",
    "interest_income",
    "other_income_expense",
    "taxes",
    "gross_profit_margin",
    "operating_profit_margin",
    "net_profit_margin",
    "return_assets",
    "roce",
    "leverage",
    "return_equity",
    "cash_flow_margin",
    "dso",
    "dio",
    "dpo",
    "dwo",
    "fixed_asset_turnover",
    "net_asset_to",
    "sales_total_assets",
    "current_ration",
    "quick_ratio",
    "cash_flow_from_operation",
    "cash_flow_liquidity_ratio",
    "working_capital",
    "current_assets_total",
    "fixed_assets_total",
    "other_assets_total",
    "current_liabilities_total",
    "long_term_debt_total",
    "stockholder_equity_total",
    "gross_margin_total",
    "operating_income_total",
    "net_income_total"
  ]

  @date_fields [
    "statetment_a",
    "statetment_as_to"
  ]

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: send(self(), :after_join)

    {:ok,
     assign(socket,
       tree: [:home, :local_currency_list],
       form: %{},
       form_step: %{},
       page_title: "",
       type_step: "",
       loading: true,
       error_message: nil,
       error_message_step: nil,
       customer: nil,
       local_currency: nil,
       currency_type: nil,
       valid_form: true,
       valid_form_step: true,
       option_years: get_option_years(),
       currency_types: [],
       option_currency_types: [],
       financial_statement_formats: [],
       option_financial_statement_formats: [],
       option_no_months: get_no_months(),
       option_periods: get_option_periods(),
       modal_form_open: false,
       modal_form_type: :current_assets
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    socket =
      if Enum.empty?(socket.assigns.currency_types) do
        Task.async(fn -> :get_lists end)
        socket
      else
        assign(socket, loading: false)
      end

    {:noreply, socket}
  end

  def handle_info({:updated_form, %{form: form, valid: _valid}}, socket) do
    IO.inspect(form, label: "form ---> ")
    {:noreply, assign(socket, form: form, valid_form: true, error_message: "")}
  end

  def handle_info({:updated_form_step, %{form: form_step, valid: _valid}}, socket) do
    IO.inspect(form_step, label: "form_step ---> ")
    {:noreply, assign(socket, form_step: form_step, valid_form: true, error_message: "")}
  end

  def handle_info({:update_currency_type, %{form: form, valid: _valid}}, socket) do
    currency_type = Enum.find(socket.assigns.currency_types, &(&1.id == form["currency_type_id"]))

    {:noreply,
     assign(socket, form: form, valid_form: true, error_message: "", currency_type: currency_type)}
  end

  def handle_info({:customer, %{form: form, customer: customer}}, socket) do
    form = Map.put(form, "customer_id", if(is_nil(customer), do: nil, else: customer.id))

    {:noreply,
     assign(socket, form: form, valid_form: true, error_message: "", customer: customer)}
  end

  def handle_info({:change_step, %{step: step}}, socket) do
    {:noreply, assign(socket, current_step: step)}
  end

  def handle_info({:DOWN, _, :process, _, :normal}, socket), do: {:noreply, socket}

  def handle_info({_ref, :get_lists}, socket) do
    currency_types = CurrencyTypeManagment.get_all([], [], [], [])

    financial_statement_formats = FinancialStatementFormatManager.get_all()

    option_currency_types =
      [%{id: 0, name: "Select option"}] ++
        Enum.map(
          currency_types,
          &%{id: &1.id, name: "#{&1.money_key}-#{String.replace(&1.money_name, "_", " ")}"}
        )

    option_financial_statement_formats = convert_options(financial_statement_formats, :name)

    {:noreply,
     assign(socket,
       loading: false,
       currency_types: currency_types,
       option_currency_types: option_currency_types,
       financial_statement_formats: financial_statement_formats,
       option_financial_statement_formats: option_financial_statement_formats
     )}
  end

  def handle_event("submit_form", params, socket) do
    params = Map.merge(params, socket.assigns.form)

    with :ok <- validate_form(params) do
      money_key = String.to_atom(socket.assigns.currency_type.money_key)

      params
      |> format_dates_to_datetime(@date_fields)
      |> format_money(@money_fields, money_key)
      |> update_create(socket, socket.assigns.local_currency)
    else
      {:error, message} ->
        {:noreply,
         socket
         |> assign(form: params, valid_form: false, error_message: message)
         |> put_flash(:error, inspect(message))}
    end
  end

  def handle_event("submit_form_step", params, socket) do
    money_key = String.to_atom(socket.assigns.currency_type.money_key)

    params =
      params
      |> Map.merge(socket.assigns.form_step)
      |> LocalCurrencyPeriodManager.calculate_total(money_key, socket.assigns.type_step)
      |> IO.inspect(label: "Whats ---_> ")

    local_currency = socket.assigns.local_currency

    local_currency.local_currency_period
    |> LocalCurrencyPeriodManager.update(params)
    |> case do
      {:ok, local_currency_period} ->
        {:noreply,
         socket
         |> assign(:modal_form_open, false)
         |> assign(
           :local_currency,
           Map.put(local_currency, :local_currency_period, local_currency_period)
         )
         |> put_flash(:info, "Analysis was updated.")}

      {:erorr, data} ->
        {:noreply,
         socket
         |> put_flash(:error, inspect(data))}
    end
  end

  def handle_event("modal_form_close", _params, socket) do
    {:noreply, assign(socket, modal_form_open: false)}
  end

  def handle_event("modal_form_open", %{"type" => type}, socket) do
    form_step =
      prepare_period_data(
        socket.assigns.local_currency.local_currency_period,
        LocalCurrencyPeriodManager.get_topic_keys(type)
      )
      |> IO.inspect(label: "form --->>>>>> ")

    {:noreply,
     assign(socket,
       form_step: form_step,
       type_step: type,
       modal_form_open: true,
       modal_form_type: type,
       valid_form_step: true,
       error_message_step: nil
     )}
  end

  def sum_totals(nil, nil, _list), do: "0"

  def sum_totals(_, nil, _list), do: "0"

  def sum_totals(nil, _, _list), do: "0"

  def sum_totals(local_currency, currency_type, list) do
    money_key = String.to_atom(currency_type.money_key)

    local_currency.local_currency_period
    |> Map.take(list)
    |> Enum.reduce(Money.new(money_key, "0"), fn {k, val}, acc ->
      if is_nil(val) do
        acc
      else
        Money.add(val, acc)
        |> case do
          {:ok, mon} -> mon
          _error -> acc
        end
      end
    end)
  end

  def get_currency(currency_id, currency_types) do
    currency_types
    |> Enum.find(&(&1.id == currency_id))
    |> case do
      nil -> "Currency"
      currency -> String.replace(currency.money_name, "_", " ")
    end
  end

  def calculate_exchange(form, currency_types) do
    balance_f_x = Decimal.new(form["balance_f_x"])

    if Decimal.gt?(balance_f_x, "0") do
      currency_id = form["currency_type_id"]

      currency_types
      |> Enum.find(&(&1.id == currency_id))
      |> case do
        nil ->
          Money.new(:USD, "0")

        currency ->
          key = String.to_atom(currency.money_key)

          1
          |> Decimal.div(balance_f_x)
          |> IO.inspect(label: "div ---> ")
          |> then(&Money.new(key, &1))
      end
    else
      Money.new(:USD, "0")
    end
  end

  defp prepare_period_data(period, keys) do
    period
    |> Map.take(keys)
    |> convert_struct_form(%{
      date: @date_fields,
      money: @money_fields
    })
  end

  defp update_create(params, socket, nil) do
    params
    |> LocalCurrencyManager.create([], %{
      type: "Create local_currency",
      transaction_responsible: socket.assigns.current_user.id
    })
    |> case do
      {:ok, %{create_entity: local_currency}} ->
        update_create_period(local_currency.id, params)

        {:noreply,
         socket
         |> assign(form: params, local_currency: local_currency)
         |> put_flash(:info, "Credit Analysis was started.")
         |> push_patch(to: ~p"/local_currency/form/#{local_currency.id}")}

      {:error, _atom, error, _data} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}

      {:error, error} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}
    end
  end

  defp update_create(params, socket, local_currency) do
    step = socket.assigns.current_step

    local_currency
    |> LocalCurrencyManager.update(params, %{
      type: "Update local_currency",
      transaction_responsible: socket.assigns.current_user.id
    })
    |> case do
      {:ok, %{update_entity: local_currency}} ->
        local_currency = get_entity(local_currency.id)

        update_create_period(local_currency.id, params)

        {:noreply,
         socket
         |> put_flash(:info, "Analysis was updated.")
         |> redirect(to: "/local_currency")}

      {:error, _atom, error, _data} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}

      {:error, error} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}
    end
  end

  defp update_create_period(local_currency_id, params) do
    period =
      LocalCurrencyPeriodManager.get(local_currency_id: local_currency_id)

    if is_nil(period) do
      params
      |> Map.put("local_currency_id", local_currency_id)
      |> LocalCurrencyPeriodManager.create()
    else
      LocalCurrencyPeriodManager.update(period, params)
    end
  end

  defp apply_action(socket, :new, _params) do
    assign(socket,
      page_title: "New Credit Analysis",
      tree: socket.assigns.tree ++ [:new_local_currency]
    )
  end

  defp apply_action(socket, :edit, %{"id" => id} = params) do
    local_currency = get_entity(id)

    period_form =
      if is_nil(local_currency.local_currency_period),
        do: %{},
        else:
          convert_struct_form(local_currency.local_currency_period, %{
            date: @date_fields,
            money: @money_fields
          })

    form =
      local_currency
      |> convert_struct_form(%{date: @date_fields, money: @money_fields})
      |> Map.merge(period_form)

    assign(socket,
      page_title: "Edit Credit Analysis",
      tree: socket.assigns.tree ++ [:edit_local_currency],
      customer: local_currency.customer,
      currency_type: local_currency.currency_type,
      local_currency: local_currency,
      form: form
    )
  end

  defp validate_form(params) do
    params
    |> IO.inspect(label: "data ---> ")
    |> Enum.reduce([], fn
      {"customer_id", "0"}, acc -> acc ++ ["Customer"]
      {"currency_type_id", "0"}, acc -> acc ++ ["Currency"]
      {"financial_statement_format_id", "0"}, acc -> acc ++ ["Financial Statement Format"]
      {"year", "0"}, acc -> acc ++ ["Year"]
      {"balance_f_x", "0"}, acc -> acc ++ ["Exchange Rate to USD can't be 0"]
      {"balance_f_x", ""}, acc -> acc ++ ["Exchange Rate to USD"]
      {"statetment_as_to", "0"}, acc -> acc ++ ["Statetment as of"]
      {"no_months", "0"}, acc -> acc ++ ["Number of months"]
      _param, acc -> acc
    end)
    |> case do
      [] -> :ok
      list -> {:error, "Please, complete this fields: " <> Enum.join(list, ", ")}
    end
  end

  defp get_entity(id) do
    LocalCurrencyManager.get!(id, [
      :currency_type,
      :local_currency_period,
      customer: [:customer_type, :country]
    ])
  end

  defp get_option_years do
    year = Map.get(Timex.now(), :year)

    Enum.reduce(0..10, [%{id: 0, name: "Select option"}], fn number, acc ->
      new_year = year - number
      acc ++ [%{id: year - number, name: "#{new_year}"}]
    end)
  end

  defp get_option_periods() do
    [
      %{id: 0, name: "Select option"},
      %{id: "Annual", name: "Annual"},
      %{id: "Semi-Annual", name: "Semi-Annual"},
      %{id: "Quarterly", name: "Quarterly"},
      %{id: "Interim", name: "Interim"}
    ]
  end

  defp get_no_months() do
    [
      %{id: 0, name: "Select option"}
    ] ++ Enum.map(1..12, &%{id: "#{&1}", name: "#{&1}"})
  end
end
