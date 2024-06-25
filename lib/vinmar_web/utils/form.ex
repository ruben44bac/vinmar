defmodule VinmarWeb.Utils.Form do
  @moduledoc false

  def convert_options(list, atom_name) do
    [%{id: 0, name: "Select option"}] ++
      Enum.map(list, &%{name: Map.get(&1, atom_name), id: &1.id})
  end
end
