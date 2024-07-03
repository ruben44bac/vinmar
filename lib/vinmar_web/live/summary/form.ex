defmodule VinmarWeb.SummaryLive.Form do
  use VinmarWeb, :live_view

  import VinmarWeb.Utils.Form,
    only: [
      format_money: 3,
      convert_options: 2,
      format_dates_to_datetime: 2,
      convert_struct_form: 1,
      convert_struct_form: 2
    ]

  alias Vinmar.Summaries.{
    CollateralTypeManager,
    ExecutiveSummaryManager,
    FinancialStatementSourceManager,
    InsuranceCompanyManager,
    ReviewedPeriodManager,
    ReviewManager
  }

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
       tree: [:home, :summary_list],
       form: %{},
       page_title: "",
       loading: true,
       error_message: nil,
       customer: nil,
       summary: nil,
       valid_form: true,
       current_step: 1,
       steps: [
         %{id: 1, name: "Limits", enable: false},
         %{id: 2, name: "Liquidity Profile", enable: false}
       ],
       option_customer: [],
       financial_statement_source: [],
       option_financial_statement_source: [],
       insurance_company: [],
       option_insurance_company: [],
       collateral_type: [],
       option_collateral_type: [],
       reviewed_period: [],
       option_reviewed_period: [],
       option_credit_agency_rating: get_option_credit_agency_rating(),
       option_outlook: get_option_outlook(),
       option_coverage_type: [
         %{id: 0, name: "Select option"},
         %{id: "named", name: "Named"},
         %{id: "dcl", name: "DCL"},
         %{id: "uninsured", name: "Uninsured"}
       ]
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    socket =
      if Enum.empty?(socket.assigns.financial_statement_source) do
        Task.async(fn -> :get_lists end)
        socket
      else
        assign(socket, loading: false)
      end

    {:noreply, socket}
  end

  def handle_info({:updated_form, %{form: form, valid: _valid}}, socket) do
    {:noreply, assign(socket, form: form, valid_form: true, error_message: "")}
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
    financial_statement_source = FinancialStatementSourceManager.get_all()
    insurance_company = InsuranceCompanyManager.get_all()
    collateral_type = CollateralTypeManager.get_all()
    reviewed_period = ReviewedPeriodManager.get_all()

    option_financial_statement_source = convert_options(financial_statement_source, :name)
    option_insurance_company = convert_options(insurance_company, :name)
    option_collateral_type = convert_options(collateral_type, :name)
    option_reviewed_period = convert_options(reviewed_period, :name)

    {:noreply,
     assign(socket,
       financial_statement_source: financial_statement_source,
       option_financial_statement_source: option_financial_statement_source,
       insurance_company: insurance_company,
       option_insurance_company: option_insurance_company,
       collateral_type: collateral_type,
       option_collateral_type: option_collateral_type,
       reviewed_period: reviewed_period,
       option_reviewed_period: option_reviewed_period,
       loading: false
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
    assign(socket, page_title: "New summary", tree: socket.assigns.tree ++ [:new_summary])
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
      page_title: "Edit summary",
      current_step: params |> Map.get("step", "1") |> String.to_integer(),
      tree: socket.assigns.tree ++ [:edit_summary],
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
    ExecutiveSummaryManager.get!(id, customer: [:customer_type, :country])
  end

  defp get_option_credit_agency_rating do
    [
      %{id: 0, name: "Select option"},
      %{id: "AAA", name: "AAA"},
      %{id: "AA+", name: "AA+"},
      %{id: "AA", name: "AA"},
      %{id: "AA-", name: "AA-"},
      %{id: "A+", name: "A+"},
      %{id: "A", name: "A"},
      %{id: "A-", name: "A-"},
      %{id: "BBB", name: "BBB"},
      %{id: "BB+", name: "BB+"},
      %{id: "BB", name: "BB"},
      %{id: "BB-", name: "BB-"},
      %{id: "B+", name: "B+"},
      %{id: "B", name: "B"},
      %{id: "B-", name: "B-"},
      %{id: "CCC+", name: "CCC+"},
      %{id: "CCC", name: "CCC"},
      %{id: "CCC-", name: "CCC-"},
      %{id: "CC", name: "CC"},
      %{id: "C", name: "C"},
      %{id: "D", name: "D"}
    ]
  end

  defp get_option_outlook do
    [
      %{id: 0, name: "Select option"},
      %{id: "positive", name: "Positive"},
      %{id: "stable", name: "Stable"},
      %{id: "negative", name: "Negative"}
    ]
  end
end
