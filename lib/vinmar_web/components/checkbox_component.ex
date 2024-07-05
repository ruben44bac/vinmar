defmodule VinmarWeb.CheckboxComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  @validation_true {true, ""}

  def render(assigns) do
    ~H"""
    <div class="w-full flex items-center">
      <button
        type="button"
        phx-click="input_changes"
        phx-value-id={@id}
        phx-target={@myself}
        class={
          if selected?(@form, @id),
            do: "w-6 h-6 bg-cyan-700 rounded-md border-2 border-cyan-950 inline-flex items-center",
            else: "w-6 h-6 bg-slate-200 rounded-md border-2 border-slate-300"
        }
      >
        <%= if selected?(@form, @id) do %>
          <svg class="w-4 h-4 mx-auto text-white" viewBox="0 0 448 512" fill="currentColor">
            <path d="M438.6 105.4c12.5 12.5 12.5 32.8 0 45.3l-256 256c-12.5 12.5-32.8 12.5-45.3 0l-128-128c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0L160 338.7 393.4 105.4c12.5-12.5 32.8-12.5 45.3 0z" />
          </svg>
        <% end %>
      </button>
      <label class="block font-bold text-sm text-slate-700 ml-2"><%= @name %></label>
    </div>
    """
  end

  def mount(socket) do
    {:ok,
     assign(socket,
       form: %{},
       validations: [],
       required: false,
       name: "",
       valid: true,
       error_message: "",
       return: :updated_form
     )}
  end

  def update(attrs, socket) do
    {:ok,
     assign(socket,
       id: attrs[:id],
       form: attrs[:form],
       name: attrs[:name],
       validations: attrs[:validations],
       required: attrs[:required] || false,
       return: attrs[:return] || :updated_form
     )}
  end

  def handle_event("input_changes", %{"id" => id}, socket) do
    value = Map.get(socket.assigns.form, id, false)

    form =
      Map.put(socket.assigns.form, id, !value)

    send(self(), {socket.assigns.return, %{form: form, valid: true}})

    {:noreply, assign(socket, valid: true, error_message: "", form: form)}
  end

  defp validate_input([], _value), do: @validation_true

  defp validate_input([:required | _tail], value) do
    if is_nil(value) || value == "" do
      {false, "Required value"}
    else
      @validation_true
    end
  end

  defp selected?(form, id) do
    value = Map.get(form, id, false)
    value == "true" || value == true
  end
end
