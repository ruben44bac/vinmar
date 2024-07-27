defmodule VinmarWeb.MultiSelectComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  @validation_true {true, ""}

  def render(assigns) do
    ~H"""
    <div class="w-full relative">
      <label class="block font-bold text-sm text-slate-700"><%= @name %></label>

      <div class="w-full">
        <div class="flex flex-col items-center relative">
          <div class="w-full ">
            <div class="mt-1 p-1 flex border border-slate-300 w-full bg-slate-50 rounded">
              <div class="flex flex-auto flex-wrap">
                <%= for item <- @selects do %>
                  <div class="flex justify-center items-center m-1 font-semibold py-1 px-2 bg-white rounded-full text-teal-700 bg-teal-100 border border-teal-300 ">
                    <div class="text-xs leading-none max-w-full flex-initial">
                      <%= item.title %>
                    </div>
                    <button
                      type="button"
                      phx-click="select_item"
                      phx-value-id={item.id}
                      phx-target={@myself}
                      class="w-5 h-5 rounded-full bg-teal-200 hover:bg-teal-400 inline-flex items-center ml-2"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill="currentColor"
                        class="h-4 w-4 mx-auto"
                        viewBox="0 0 384 512"
                      >
                        <path d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z" />
                      </svg>
                    </button>
                  </div>
                <% end %>

                <div class="flex-1">
                  <input
                    name={@id}
                    value={Map.get(@form, @id)}
                    phx-change="input_changes"
                    phx-target={@myself}
                    placeholder=""
                    class="bg-transparent p-1 px-2 appearance-none outline-none h-full w-full text-gray-800"
                  />
                </div>
              </div>
              <button
                type="button"
                phx-click="open_options"
                phx-target={@myself}
                class="hover:bg-slate-200 text-gray-300 rounded w-8 h-8 text-gray-600 border-l inline-flex items-center border-gray-200"
              >
                <%= if @open_options do %>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="currentColor"
                    class="w-4 h-4 mx-auto"
                    viewBox="0 0 512 512"
                  >
                    <path d="M233.4 105.4c12.5-12.5 32.8-12.5 45.3 0l192 192c12.5 12.5 12.5 32.8 0 45.3s-32.8 12.5-45.3 0L256 173.3 86.6 342.6c-12.5 12.5-32.8 12.5-45.3 0s-12.5-32.8 0-45.3l192-192z" />
                  </svg>
                <% else %>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="currentColor"
                    class="w-4 h-4 mx-auto"
                    viewBox="0 0 512 512"
                  >
                    <path d="M233.4 406.6c12.5 12.5 32.8 12.5 45.3 0l192-192c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L256 338.7 86.6 169.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3l192 192z" />
                  </svg>
                <% end %>
              </button>
            </div>
          </div>
          <%= if @open_options do %>
            <div class="absolute mt-12 shadow top-100 bg-white z-10 w-full lef-0 rounded max-h-select overflow-y-auto">
              <div class="flex flex-col w-full">
                <%= for item <- @options do %>
                  <button
                    type="button"
                    phx-click="select_item"
                    phx-value-id={item.id}
                    phx-target={@myself}
                    class="cursor-pointer w-full border-gray-100 rounded-t border-b hover:bg-teal-100 text-left"
                  >
                    <div class="flex w-full items-center p-2 pl-2 border-transparent border-l-2 relative hover:border-teal-100">
                      <div class="w-full block px-2">
                        <label class="text-slate-700 block pointer-events-none">
                          <%= item.title %>
                        </label>
                        <label class="block text-sm text-slate-600 block pointer-events-none">
                          <%= item.subtitle %>
                        </label>
                      </div>
                    </div>
                  </button>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok,
     assign(socket,
       form: %{"search" => ""},
       name: "",
       options: [],
       selects: [],
       open_options: false,
       return: :updated_form
     )}
  end

  def update(attrs, socket) do
    {:ok,
     assign(socket,
       id: attrs[:id],
       options: attrs[:options],
       selects: attrs[:selects] || [],
       name: attrs[:name],
       return: attrs[:return] || :updated_form
     )}
  end

  def handle_event("input_changes", %{"_target" => [target]} = params, socket) do
    value = Map.get(params, target)

    form = Map.put(socket.assigns.form, target, value)

    # send(self(), {socket.assigns.return, %{form: form, valid: true}})

    {:noreply, assign(socket, form: form, open_options: true)}
  end

  def handle_event("select_item", %{"id" => id}, socket) do
    select =
      socket.assigns.options
      |> Enum.find(&(&1.id == id))

    selects =
      if select in socket.assigns.selects,
        do: Enum.reject(socket.assigns.selects, &(&1 == select)),
        else: Kernel.++(socket.assigns.selects, [select])

    send(self(), {socket.assigns.return, %{selects: selects}})

    {:noreply, assign(socket, selects: selects)}
  end

  def handle_event("open_options", _params, socket) do
    {:noreply, assign(socket, open_options: !socket.assigns.open_options)}
  end

  defp compare_selected(id, form, key) do
    value = Map.get(form, key)
    Kernel.==("#{id}", "#{value}")
  end
end
