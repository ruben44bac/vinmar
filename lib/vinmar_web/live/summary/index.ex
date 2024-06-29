defmodule VinmarWeb.SummaryLive.Index do
  @moduledoc false

  use VinmarWeb, :live_view

  alias Vinmar.Summaries.ExecutiveSummaryManager

  def mount(_params, _session, socket) do
    send(self(), :after_join)

    {:ok,
     assign(socket,
       tree: [:home, :summary_list],
       list: [],
       page_title: "Summary"
     )}
  end

  def handle_info(:after_join, socket) do
    list =
      ExecutiveSummaryManager.get_all([], [], [], [
        :customer,
        :financial_statement_source,
        :current_insurance_company,
        :insurance_company
      ])

    {:noreply,
     assign(socket,
       list: list
     )}
  end
end
