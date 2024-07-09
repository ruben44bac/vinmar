defmodule VinmarWeb.HomeLive.Index do
  use VinmarWeb, :live_view

  def mount(_params, _session, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, show_table: false)}
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
