defmodule Pairs do
  # TODO:
  # * Dializer
  # * Sanity check, only one per list

  @moduledoc false

  @doc ~S"""
  Creates a list of pairs from the `left` and `right` lists.

  Pairs will be matched on equality of the keys after the elements were passed
  through the `left_key_fun` and `right_key_fun` respecively.

  ## Examples

      iex> create(["Ant", "Buffalo"], &String.upcase/1, ["ant"], &String.upcase/1)
      [{"Buffalo", nil}, {"Ant", "ant"}]

      iex> create(["a", "b", "c", "d"], &String.to_atom/1, [:d, :e, :a], &(&1))
      [{"b", nil}, {"c", nil}, {"a", :a}, {"d", :d}, {nil, :e}]
  """
  def create(left, left_key_fun, right, right_key_fun)
      when is_list(left) and is_list(right)
      and is_function(left_key_fun) and is_function(right_key_fun) do
    left_grouped = Enum.group_by(left, left_key_fun)
    right_grouped = Enum.group_by(right, right_key_fun)
    divide(Map.keys(left_grouped), Map.keys(right_grouped))
    |> distribute(left_grouped, right_grouped)
  end

  @doc ~S"""
  Creates a list of pairs from the `left` and `right` lists.

  Two elements from the list end up in the same pair if they are equal.
  `Pairs.create/4` offers more flexibility by accepting functions to extract keys.

  ## Examples

      iex> create(["Ant", "Buffalo"], ["ant"])
      [{"Ant", nil}, {"Buffalo", nil}, {nil, "ant"}]

      iex> create(["Ant", "Buffalo"], ["Ant"])
      [{"Buffalo", nil}, {"Ant", "Ant"}]
  """
  def create(left, right) when is_list(left) and is_list(right) do
    create(left, &id/1, right, &id/1)
  end

  @doc false
  def divide(left, right) when is_list(left) and is_list(right) do
    left = MapSet.new(left)
    right = MapSet.new(right)

    in_both    = MapSet.intersection(left, right)
    left_only  = MapSet.difference(left, right)
    right_only = MapSet.difference(right, left)

    [left_only, in_both, right_only]
    |> Enum.map(&MapSet.to_list/1)
    |> List.to_tuple
  end

  defp distribute({left_only, in_both, right_only}, left_grouped, right_grouped) do
    make_pairs(left_only, left_grouped, %{}) ++
      make_pairs(in_both, left_grouped, right_grouped) ++
      make_pairs(right_only, %{}, right_grouped)
  end

  defp make_pairs(keys, left, right) do
    Enum.map(keys, fn(key) -> {get_one(left, key), get_one(right, key)} end)
  end

  defp get_one(map, key) do
    Map.get(map, key, []) |> List.first
  end

  defp id(a), do: a
end
