defmodule VinmarWeb.CustomerSearchComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  alias Vinmar.Customers.CustomerManager

  @validation_true {true, ""}

  def render(assigns) do
    ~H"""
    <div class="w-full relative">
      <%= if is_nil(@customer) do %>
        <label class="block font-bold text-sm text-slate-700"><%= @name %></label>
        <input
          type="text"
          name="client"
          value={@form["customer_id"]}
          class={
            if @valid,
              do: "mt-1 rounded px-2 py-1 border border-slate-300 w-full bg-slate-50",
              else: "mt-1 rounded px-2 py-1 border-2 border-red-600 w-full bg-red-50"
          }
          required={@required}
          phx-change="input_changes"
          phx-target={@myself}
        />
        <%= if !Enum.empty?(@customers) do %>
          <div class="w-full bg-slate-100 rounded-b-lg">
            <%= for customer <- @customers do %>
              <button
                phx-click="select_customer"
                phx-value-id={customer.id}
                phx-target={@myself}
                type="button"
                class="w-full px-2 py-2 hover:bg-slate-300 hover:text-slate-800 hover:font-bold text-gray-700 rounded-lg"
              >
                <%= customer.sap_id %> - <%= customer.name %>
              </button>
            <% end %>
          </div>
        <% end %>
        <%= if !@valid do %>
          <label class="absolute bottom-0 left-0 text-red-700 text-xs font-semibold -mb-4">
            <%= @error_message %>
          </label>
        <% end %>
      <% else %>
        <div class="w-full inline-flex items-center rounded-lg border-2 border-slate-200 p-3 font-semibold bg-slate-100 text-slate-800 relative">
          <button
            type="button"
            phx-click="change_customer"
            phx-target={@myself}
            class="w-6 h-6 rounded-lg bg-slate-300 text-slate-700 inline-flex items-center absolute top-0 right-0 mt-2 mr-2"
          >
            <svg
              class="w-4 h-4 mx-auto"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 384 512"
              fill="currentColor"
            >
              <path d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z" />
            </svg>
          </button>
          <div>
            <div class="inline-flex items-center w-full">
              <div class="mx-auto w-12 h-12 rounded-full bg-slate-800 text-slate-50 inline-flex items-center">
                <span class="mx-auto text-2xl font-bold"><%= @customer.country.rating %></span>
              </div>
            </div>
            <div class="inline-flex items-center w-full mt-4">
              <label class={
                if @customer.country.insurance_coverage == "MARKEL",
                  do:
                    "mx-auto px-3 py-1 rounded-full text-xs font-bold text-green-800 bg-green-100 border border-green-300",
                  else:
                    "mx-auto px-3 py-1 rounded-full text-xs font-bold text-red-800 bg-red-100 border border-red-300"
              }>
                <%= @customer.country.insurance_coverage %>
              </label>
            </div>
          </div>
          <div>
            <label class="block "><%= @customer.name %></label>
            <label class="block font-bold text-sm">SAP: <%= @customer.sap_id %></label>
            <label class="block text-xs text-slate-600"><%= @customer.country.name %></label>
            <label class="block text-xs text-slate-600">
              Type: <%= @customer.customer_type.name %>
            </label>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(socket) do
    {:ok,
     assign(socket,
       validations: [],
       required: false,
       name: "",
       valid: true,
       error_message: "",
       customers: [],
       customer: nil,
       return: :updated_customer
     )}
  end

  def update(attrs, socket) do
    {:ok,
     assign(socket,
       id: attrs[:id],
       form: attrs[:form],
       name: attrs[:name],
       customer: attrs[:customer],
       validations: attrs[:validations],
       required: attrs[:required] || false
     )}
  end

  def handle_event("input_changes", %{"_target" => [target]} = params, socket) do
    value = Map.get(params, target)
    {valid, error_message} = validate_input(socket.assigns.validations, value)

    form = Map.put(socket.assigns.form, socket.assigns.id, value)

    send(self(), {:updated_form, %{form: form, valid: valid}})

    customers = if value == "", do: [], else: CustomerManager.search_customer(value)

    {:noreply,
     assign(socket, valid: valid, error_message: error_message, form: form, customers: customers)}
  end

  def handle_event("select_customer", %{"id" => id}, socket) do
    customer = Enum.find(socket.assigns.customers, &(&1.id == id))
    form = Map.put(socket.assigns.form, socket.assigns.id, id)
    send(self(), {:updated_form, %{form: form, valid: true}})
    send(self(), {:customer, %{form: form, customer: customer}})

    {:noreply,
     assign(socket, customer: customer, customers: [], valid: true, error_message: "", form: form)}
  end

  def handle_event("change_customer", _params, socket) do
    {valid, error_message} = validate_input(socket.assigns.validations, "")
    form = Map.put(socket.assigns.form, socket.assigns.id, "")
    send(self(), {:updated_form, %{form: form, valid: false}})
    send(self(), {:customer, %{form: form, customer: nil}})

    {:noreply,
     assign(socket, customer: nil, valid: valid, error_message: error_message, form: form)}
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
