defmodule VinmarWeb.LoadingComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div>
      <%= if @loading do %>
        <div class="w-full fixed h-screen top-0 left-0 backdrop-blur-sm bg-white/30 inline-flex items-center">
          <div class="mx-auto">
            <div class="flex">
              <lottie-player
                class="w-48 h-auto mx-auto"
                src="/images/loading.json"
                background="transparent"
                speed="1"
                loop
                autoplay
              >
              </lottie-player>
            </div>
            <div class="block text-center font-bold text-cyan-950 text-xl -mt-10">Loading...</div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, loading: false)}
  end

  def update(attrs, socket) do
    {:ok, assign(socket, loading: Map.get(attrs, :loading, false))}
  end
end
