defmodule VinmarWeb.ProgressBarComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <nav aria-label="Progress">
      <ol
        role="list"
        class="divide-y divide-gray-300 rounded-md border border-gray-300 md:flex md:divide-y-0"
      >
        <%= for {step, index} <- Enum.with_index(@steps) do %>
          <li class="relative md:flex md:flex-1">
            <!-- Completed Step -->
            <%= if step.id < @current_step do %>
              <button
                phx-click="select_step"
                phx-value-step={step.id}
                phx-target={@myself}
                class="group flex w-full items-center"
              >
                <span class="flex items-center px-6 py-4 text-sm font-medium">
                  <span class="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full bg-green-600 group-hover:bg-green-800">
                    <svg
                      class="h-6 w-6 text-white"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      aria-hidden="true"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M19.916 4.626a.75.75 0 01.208 1.04l-9 13.5a.75.75 0 01-1.154.114l-6-6a.75.75 0 011.06-1.06l5.353 5.353 8.493-12.739a.75.75 0 011.04-.208z"
                        clip-rule="evenodd"
                      />
                    </svg>
                  </span>
                  <span class="ml-4 text-sm font-medium text-gray-900"><%= step.name %></span>
                </span>
              </button>
            <% end %>
            <%= if step.id == @current_step do %>
              <button
                phx-click="select_step"
                phx-value-step={step.id}
                phx-target={@myself}
                class="flex items-center px-6 py-4 text-sm font-medium"
                aria-current="step"
              >
                <span class="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full border-2 border-green-600">
                  <span class="text-green-600"><%= step.id %></span>
                </span>
                <span class="ml-4 text-sm font-medium text-green-600"><%= step.name %></span>
              </button>
            <% end %>

            <%= if step.id > @current_step do %>
              <button
                phx-click="select_step"
                phx-value-step={step.id}
                phx-target={@myself}
                class="group flex items-center"
              >
                <span class="flex items-center px-6 py-4 text-sm font-medium">
                  <span class="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full border-2 border-gray-300 group-hover:border-gray-400">
                    <span class="text-gray-500 group-hover:text-gray-900"><%= step.id %></span>
                  </span>
                  <span class="ml-4 text-sm font-medium text-gray-500 group-hover:text-gray-900">
                    <%= step.name %>
                  </span>
                </span>
              </button>
            <% end %>
            <%= if (index + 1) < length(@steps) do %>
              <div class="absolute right-0 top-0 hidden h-full w-5 md:block" aria-hidden="true">
                <svg
                  class="h-full w-full text-gray-300"
                  viewBox="0 0 22 80"
                  fill="none"
                  preserveAspectRatio="none"
                >
                  <path
                    d="M0 -2L20 40L0 82"
                    vector-effect="non-scaling-stroke"
                    stroke="currentcolor"
                    stroke-linejoin="round"
                  />
                </svg>
              </div>
            <% end %>
          </li>
        <% end %>
      </ol>
    </nav>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, steps: [], current_step: 0)}
  end

  def update(attrs, socket) do
    {:ok, assign(socket, steps: attrs.steps, current_step: attrs.current_step)}
  end

  def handle_event("select_step", %{"step" => step}, socket) do
    step = String.to_integer(step)
    full_current_step = Enum.find(socket.assigns.steps, &(&1.id == step))

    if full_current_step.enable || socket.assigns.current_step > step do
      send(self(), {:change_step, %{step: step}})

      {:noreply, assign(socket, current_step: step)}
    else
      {:noreply, socket}
    end
  end
end
