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
    FinancialStatementFormatManager
  }

  import VinmarWeb.ModalComponent, only: [modal_right: 1]

  @money_fields [
    "current_credit_limit",
    "current_insurance_coverage",
    "request_credit_limit",
    "request_insurance_coverage",
    "amount",
    "recommended_limit",
    "recommended_credit_limit",
    "credit_facilities",
    "availability_headroom"
  ]

  @date_fields [
    "reviewed_at",
    "next_reviewed_at",
    "last_expirated_at",
    "expirated_at"
  ]

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: send(self(), :after_join)

    {:ok,
     assign(socket,
       tree: [:home, :local_currency_list],
       form: %{},
       page_title: "",
       loading: true,
       error_message: nil,
       customer: nil,
       local_currency: nil,
       currency_type: nil,
       valid_form: true,
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

  def handle_event("submit_form", _params, socket) do
    params = socket.assigns.form

    with :ok <- validate_form(params) do
      params
      |> format_dates_to_datetime(@date_fields)
      |> format_money(@money_fields, :USD)
      |> update_create(socket, socket.assigns.summary)
    else
      {:error, message} ->
        {:noreply,
         socket
         |> assign(form: params, valid_form: false, error_message: message)
         |> put_flash(:error, inspect(message))}
    end
  end

  def handle_event("modal_form_close", _params, socket) do
    {:noreply, assign(socket, modal_form_open: false)}
  end

  def handle_event("modal_form_open", %{"type" => type}, socket) do
    {:noreply, assign(socket, modal_form_open: true, modal_form_type: String.to_atom(type))}
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
    current_credit_limit = Decimal.new(form["current_credit_limit"])

    if Decimal.gt?(current_credit_limit, "0") do
      currency_id = form["currency_type_id"]

      currency_types
      |> Enum.find(&(&1.id == currency_id))
      |> case do
        nil ->
          Money.new(:USD, "0")

        currency ->
          key = String.to_atom(currency.money_key)

          1
          |> Decimal.div(current_credit_limit)
          |> IO.inspect(label: "div ---> ")
          |> then(&Money.new(key, &1))
      end
    else
      Money.new(:USD, "0")
    end
  end

  defp update_create(params, socket, nil) do
    params
    |> ExecutiveSummaryManager.create([], %{
      type: "Create summary",
      transaction_responsible: socket.assigns.current_user.id
    })
    |> case do
      {:ok, %{create_entity: summary}} ->
        {:noreply,
         socket
         |> assign(form: params)
         |> put_flash(:info, "Summary was created.")
         |> redirect(to: "/summary/form/#{summary.id}/2")}

      {:error, _atom, error, _data} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}

      {:error, error} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}
    end
  end

  defp update_create(params, socket, summary) do
    step = socket.assigns.current_step

    summary
    |> ExecutiveSummaryManager.update(params, %{
      type: "Update summary",
      transaction_responsible: socket.assigns.current_user.id
    })
    |> case do
      {:ok, %{update_entity: summary}} ->
        summary = get_entity(summary.id)

        update_create_review(summary.id, params, step)

        if step == 2 do
          {:noreply,
           socket
           |> put_flash(:info, "Summary was updated.")
           |> redirect(to: "/summary")}
        else
          {:noreply,
           socket
           |> assign(
             summary: summary,
             customer: summary.customer,
             current_step: step + 1
           )
           |> put_flash(:info, "Summary was updated.")}
        end

      {:error, _atom, error, _data} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}

      {:error, error} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}
    end
  end

  defp update_create_review(summary_id, params, 2) do
    review = ReviewManager.get(executive_summary_id: summary_id)

    if is_nil(review) do
      params
      |> Map.put("executive_summary_id", summary_id)
      |> ReviewManager.create()
    else
      ReviewManager.update(review, params)
    end
  end

  defp update_create_review(_summary_id, _params, _step), do: nil

  defp apply_action(socket, :new, _params) do
    assign(socket,
      page_title: "New Credit Analysis",
      tree: socket.assigns.tree ++ [:new_local_currency]
    )
  end

  defp apply_action(socket, :edit, %{"id" => id} = params) do
    summary =
      ExecutiveSummaryManager.get!(id, [:review, customer: [:customer_type, :country]])

    review_form = if is_nil(summary.review), do: %{}, else: convert_struct_form(summary.review)

    form =
      summary
      |> convert_struct_form(%{date: @date_fields, money: @money_fields})
      |> Map.merge(review_form)

    assign(socket,
      page_title: "Edit Credit Analysis",
      tree: socket.assigns.tree ++ [:edit_local_currency],
      customer: summary.customer,
      summary: summary,
      form: form
    )
  end

  defp validate_form(params) do
    params
    |> Enum.reduce([], fn
      {"customer_id", "0"}, acc -> acc ++ ["Customer"]
      _param, acc -> acc
    end)
    |> case do
      [] -> :ok
      list -> {:error, "Please, complete this fields: " <> Enum.join(list, ", ")}
    end
  end

  defp get_entity(id) do
    LocalCurrencyManager.get!(id, customer: [:customer_type, :country])
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
