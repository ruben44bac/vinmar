defmodule VinmarWeb.LocalCurrencyLive.Index do
  @moduledoc false

  use VinmarWeb, :live_view

  alias Vinmar.LocalCurrencies.LocalCurrencyManager

  def mount(_params, _session, socket) do
    send(self(), :after_join)

    {:ok,
     assign(socket,
       tree: [:home, :local_currency_list],
       list: [],
       page_title: "Credit Analysis"
     )}
  end

  def handle_info(:after_join, socket) do
    list =
      LocalCurrencyManager.get_all([], [], [], [
        :currency_type,
        :local_currency_period,
        customer: [:customer_type, :country]
      ])

    {:noreply,
     assign(socket,
       list: list
     )}
  end
end
