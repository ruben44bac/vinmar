defmodule VinmarWeb.CustomerLive.Form do
  use VinmarWeb, :live_view

  import VinmarWeb.Utils.Form,
    only: [convert_options: 2, format_dates_to_datetime: 2, convert_struct_form: 1]

  alias Vinmar.Customers.{
    CustomerManager,
    CountryManager,
    CustomerTypeManager
  }

  @impl true
  def mount(_params, _session, socket) do
    send(self(), :after_join)

    {:ok,
     assign(socket,
       tree: [:home, :customer_list],
       customer: nil,
       option_customer_types: [],
       option_countries: [],
       country_selected: nil,
       form: %{},
       page_title: "",
       country_detail: false,
       error_message: nil,
       valid_form: true
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("submit_form", params, socket) do
    with :ok <- validate_form(params) do
      params
      |> format_dates_to_datetime(["created_at", "inception_at"])
      |> CustomerManager.create([], %{
        type: "Create customer",
        transaction_responsible: socket.assigns.current_user.id
      })
      |> case do
        {:ok, %{create_entity: customer}} ->
          {:noreply,
           socket
           |> assign(form: params)
           |> put_flash(:info, "#{customer.name} was created.")
           |> redirect(to: "/customer")}

        {:error, _atom, error, _data} ->
          {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}

        {:error, error} ->
          {:noreply, socket |> assign(form: params) |> put_flash(:error, inspect(error))}
      end
    else
      {:error, message} ->
        {:noreply,
         socket
         |> assign(form: params, valid_form: false, error_message: message)
         |> put_flash(:error, inspect(message))}
    end
  end

  def handle_event("country_detail", _params, socket) do
    {:noreply, assign(socket, country_detail: !socket.assigns.country_detail)}
  end

  def handle_info(:after_join, socket) do
    customer_types = CustomerTypeManager.get_all()

    option_customer_types = convert_options(customer_types, :name)

    countries = CountryManager.get_all()

    option_countries = convert_options(countries, :name)

    {:noreply,
     assign(socket,
       countries: countries,
       option_countries: option_countries,
       customer_types: customer_types,
       option_customer_types: option_customer_types
     )}
  end

  def handle_info({:updated_form, %{form: form, valid: valid}}, socket) do
    {:noreply, assign(socket, form: form, valid_form: true, error_message: "")}
  end

  def handle_info({:country, %{form: form, valid: valid}}, socket) do
    country_id = form["country_id"]

    country_selected = Enum.find(socket.assigns.countries, &(&1.id == country_id))

    {:noreply,
     assign(socket,
       form: form,
       country_selected: country_selected,
       valid_form: true,
       error_message: ""
     )}
  end

  defp apply_action(socket, :new, _params) do
    assign(socket, page_title: "New customer", tree: socket.assigns.tree ++ [:new_customer])
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    customer =
      CustomerManager.get!(id)
      |> IO.inspect()

    assign(socket,
      page_title: "Edit customer",
      customer: customer,
      form: convert_struct_form(customer),
      tree: socket.assigns.tree ++ [:new_customer]
    )
  end

  defp validate_form(params) do
    params
    |> Enum.reduce([], fn
      {"customer_type_id", "0"}, acc -> acc ++ ["Type of Customer"]
      {"country_id", "0"}, acc -> acc ++ ["Country of Customer"]
      _param, acc -> acc
    end)
    |> case do
      [] -> :ok
      list -> {:error, "Please, complete this fields: " <> Enum.join(list, ", ")}
    end
  end
end
