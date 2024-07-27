defmodule VinmarWeb.HomeLive.Index do
  use VinmarWeb, :live_view

  def mount(_params, _session, socket) do
    send(self(), :after_join)

    chart_data = %{
      labels: ["January", "February", "March", "April", "May", "June", "July"],
      datasets: [
        %{
          label: "My First dataset",
          backgroundColor: "rgba(75, 192, 192, 0.2)",
          borderColor: "rgba(75, 192, 192, 1)",
          data: [65, 59, 80, 81, 56, 55, 40]
        }
      ]
    }


    {:ok, assign(socket, show_table: false, chart_data: chart_data)}
  end

  def handle_info(:after_join, socket) do
    Task.async(fn -> :show_table end)
    {:noreply, socket}
  end

  def handle_info({_ref, :show_table}, socket) do
    {:noreply, assign(socket, show_table: true)}
  end

  def handle_info({:DOWN, _, :process, _, :normal}, socket), do: {:noreply, socket}
end
