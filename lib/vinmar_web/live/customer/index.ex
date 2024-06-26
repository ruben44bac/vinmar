defmodule VinmarWeb.CustomerLive.Index do
  use VinmarWeb, :live_view

  alias Vinmar.Customers.CustomerManager

  def mount(_params, _session, socket) do
    send(self(), :after_join)

    {:ok,
     assign(socket,
       tree: [:home, :customer_list],
       list: [],
       page_title: "Customers"
     )}
  end

  def handle_info(:after_join, socket) do
    list = CustomerManager.get_all([], [], [], [:customer_type, :country])

    {:noreply,
     assign(socket,
       list: list
     )}
  end
end
