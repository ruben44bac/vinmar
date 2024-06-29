defmodule VinmarWeb.SummaryLive.Form do
  use VinmarWeb, :live_view

  alias Vinmar.Summaries.{
    CollateralTypeManager,
    ExecutiveSummaryManager,
    FinancialStatementSourceManager,
    InsuranceCompanyManager,
    ReviewedPeriodManager
  }

  import VinmarWeb.Utils.Form,
    only: [
      convert_options: 2,
      format_dates_to_datetime: 2,
      convert_struct_form: 1,
      format_date_form: 1
    ]

  @impl true
  def mount(_params, _session, socket) do
    send(self(), :after_join)

    {:ok,
     assign(socket,
       tree: [:home, :summary_list],
       form: %{},
       page_title: "",
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
    if Enum.empty?(socket.assigns.financial_statement_source) do
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
         option_reviewed_period: option_reviewed_period
       )}
    else
      {:noreply, socket}
    end
  end

  def handle_info({:updated_form, %{form: form, valid: _valid}}, socket) do
    {:noreply, assign(socket, form: form, valid_form: true, error_message: "")}
  end

  def handle_info({:customer, %{form: form, customer: customer}}, socket) do
    {:noreply,
     assign(socket, form: form, valid_form: true, error_message: "", customer: customer)}
  end

  def handle_event("submit_form", params, socket) do
    with :ok <- validate_form(params) do
      params
      |> format_dates_to_datetime(["reviewed_at", "next_reviewed_at"])
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
         |> put_flash(:info, "#{summary.name} was created.")
         |> redirect(to: "/summary")}

      {:error, _atom, error, _data} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}

      {:error, error} ->
        {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}
    end
  end

  defp apply_action(socket, :new, _params) do
    assign(socket, page_title: "New summary", tree: socket.assigns.tree ++ [:new_summary])
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    summary = ExecutiveSummaryManager.get!(id, customer: [:customer_type, :country])

    assign(socket,
      page_title: "Edit summary",
      tree: socket.assigns.tree ++ [:edit_summary],
      customer: summary.customer,
      summary: summary,
      form: summary |> convert_struct_form()
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
end
