defmodule VinmarWeb.InputComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  @validation_true {true, ""}

  def render(assigns) do
    ~H"""
    <div class="w-full relative mt-4">
      <label class="block font-bold text-sm text-slate-700"><%= @name %></label>
      <input
        type={@type}
        name={@id}
        value={Map.get(@form, @id)}
        class={
          if @valid,
            do: "mt-1 rounded px-2 py-1 border border-slate-300 w-full bg-slate-50",
            else: "mt-1 rounded px-2 py-1 border-2 border-red-600 w-full bg-red-50"
        }
        required={@required}
        phx-change="input_changes"
        phx-target={@myself}
      />
      <%= if !@valid do %>
        <label class="absolute bottom-0 left-0 text-red-700 text-xs font-semibold -mb-4">
          <%= @error_message %>
        </label>
      <% end %>
    </div>
    """
  end

  def mount(socket) do
    {:ok,
     assign(socket,
       form: %{},
       type: "text",
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
       type: attrs[:type],
       name: attrs[:name],
       validations: attrs[:validations],
       required: attrs[:required] || false,
       return: attrs[:return] || :updated_form
     )}
  end

  def handle_event("input_changes", %{"_target" => [target]} = params, socket) do
    value = Map.get(params, target)
    {valid, error_message} = validate_input(socket.assigns.validations, value)

    form = Map.put(socket.assigns.form, socket.assigns.id, value)

    send(self(), {socket.assigns.return, %{form: form, valid: valid}})

    {:noreply, assign(socket, valid: valid, error_message: error_message, form: form)}
  end

  defp validate_input([], _value), do: @validation_true

  defp validate_input([:required | _tail], value) do
    if is_nil(value) || value == "" do
      {false, "Required value"}
    else
      @validation_true
    end
  end
end
