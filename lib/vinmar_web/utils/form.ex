defmodule VinmarWeb.Utils.Form do
  @moduledoc false

  use Timex

  @form_format "%Y-%m-%d"

  def convert_options(list, atom_name) do
    [%{id: 0, name: "Select option"}] ++
      Enum.map(list, &%{name: Map.get(&1, atom_name), id: &1.id})
  end

  def format_dates_to_datetime(form, keys) do
    form
    |> Map.take(keys)
    |> Enum.map(&convert_date_to_datetime/1)
    |> Map.new()
    |> then(&Map.merge(form, &1))
  end

  def format_money(form, keys, type) do
    form
    |> Map.take(keys)
    |> Enum.map(&new_money(&1, type))
    |> Map.new()
    |> then(&Map.merge(form, &1))
  end

  def convert_struct_form(struct) do
    struct
    |> Map.drop([:__meta__, :__struct__])
    |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
    |> Map.new()
  end

  def convert_struct_form(struct, instructions) do
    struct
    |> Map.drop([:__meta__, :__struct__])
    |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
    |> convert_instructions(instructions)
    |> Map.new()
  end

  def format_date_form(datetime) when datetime in [nil, ""], do: ""

  def format_date_form(datetime) do
    datetime
    |> Timex.Format.DateTime.Formatter.format("%Y-%m-%d", :strftime)
    |> case do
      {:ok, date} -> date
      _ -> ""
    end
  end

  def format_money_form(value) when value in [nil, ""], do: ""

  def format_money_form(value) do
    value
    |> Money.to_decimal()
    |> Decimal.to_string()
  end

  defp convert_instructions(data_list, %{date: options} = instructions) do
    data_filter =
      data_list
      |> Enum.filter(fn {k, v} -> k in options end)
      |> Enum.map(fn {k, v} -> {k, format_date_form(v)} end)

    data_list
    |> Enum.reject(fn {k, v} -> k in options end)
    |> Kernel.++(data_filter)
    |> convert_instructions(Map.delete(instructions, :date))
  end

  defp convert_instructions(data_list, %{money: options} = instructions) do
    data_filter =
      data_list
      |> Enum.filter(fn {k, v} -> k in options end)
      |> Enum.map(fn {k, v} -> {k, format_money_form(v)} end)

    data_list
    |> Enum.reject(fn {k, v} -> k in options end)
    |> Kernel.++(data_filter)
    |> convert_instructions(Map.delete(instructions, :money))
  end

  defp convert_instructions(data_list, _instructuons), do: data_list

  defp new_money({k, v}, _type) when v in [nil, ""], do: {k, nil}

  defp new_money({k, v}, type) do
    type
    |> Money.new(v)
    |> case do
      %Money{} = value -> {k, value}
      _ -> {k, v}
    end
  end

  defp convert_date_to_datetime({k, v}) when v in [nil, ""], do: {k, nil}

  defp convert_date_to_datetime({k, v}) do
    [year, month, day] =
      String.split(v, "-")

    datetime =
      Timex.to_datetime(
        {{String.to_integer(year), String.to_integer(month), String.to_integer(day)}, {0, 0, 0}},
        "Etc/UTC"
      )

    {k, datetime}
  end
end
