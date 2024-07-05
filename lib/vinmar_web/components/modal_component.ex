defmodule VinmarWeb.ModalComponent do
  @moduledoc false

  use Phoenix.Component

  slot :inner_block, required: true

  def modal_right(assigns) do
    ~H"""
    <div class="">
      <%= if @modal_form_open do %>
        <div class="w-full h-screen fixed top-0 left-0 backdrop-blur-sm bg-black/20 inline-flex p-2 lg:p-4">
          <div class="h-full ml-auto w-full lg:w-1/2 bg-white rounded lg:rounded-3xl shadow-lg p-4 lg:p-8 animate-moveRight">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
