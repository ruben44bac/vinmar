defmodule VinmarWeb.CustomerLive.Index do
  use VinmarWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, tree: [:home, :customer_list])}
  end
end
