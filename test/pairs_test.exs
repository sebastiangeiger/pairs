defmodule PairsTest do
  use ExUnit.Case, async: true
  import Pairs, only: [create: 2, create: 4, divide: 2]
  doctest Pairs

  describe "#create/2" do
    test "with no lists" do
      assert create([],[]) == []
    end

    test "with a single element in the first list" do
      assert create([:a],[]) == [{:a, nil}]
    end

    test "with a single element in the second list" do
      assert create([],[:a]) == [{nil, :a}]
    end

    test "with two non-matching elements in both lists" do
      assert create([:a],[:b]) == [{:a, nil}, {nil, :b}]
    end

    test "with two matching elements in both lists" do
      assert create([:a],[:a]) == [{:a, :a}]
    end

    test "with a lot of elements" do
      assert create([:a, :b, :c, :d],[:d, :e, :a]) ==
        [{:b, nil}, {:c, nil}, {:a, :a}, {:d, :d}, {nil, :e}]
    end
  end

  defp id(a), do: a

  describe "#create/4" do
    test "with a lot of elements" do
      assert create(["a", "b", "c", "d"], &String.to_atom/1, [:d, :e, :a], &id/1) ==
        [{"b", nil}, {"c", nil}, {"a", :a}, {"d", :d}, {nil, :e}]
    end
  end

  describe "#divide" do
    test "with no lists" do
      assert divide([],[]) == {[], [], []}
    end

    test "with a single element in the first list" do
      assert divide([:a],[]) == {[:a], [], []}
    end

    test "with a single element in the second list" do
      assert divide([],[:a]) == {[], [], [:a]}
    end

    test "with two non-matching elements in both lists" do
      assert divide([:a],[:b]) == {[:a],[],[:b]}
    end

    test "with two matching elements in both lists" do
      assert divide([:a],[:a]) == {[],[:a],[]}
    end
  end
end
