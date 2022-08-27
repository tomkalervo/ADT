# Author Tom Karlsson
# Created 2022-08-26
defmodule Heap do
  @moduledoc """
  This module provides a heap data structure. Either min-heap or max-heap can be chosen.
  Heaps are usually of complexity Big O(log n) but that is not achiveable in functional programming languages.
  Lists are chosen because immutabillity makes tuples Big theta(n) for all operations.
  Lists are at least Big theta(1) for pop/1 and Big O(n) for insert/2 and delete/2.

  How to use: TBA
  """
  defstruct list: nil, length: nil, fun: nil

  def test() do
    h = new_min()
    |> Heap.Ops.insert(9, "nio")
    |> Heap.Ops.insert(1, "ett")
    |> Heap.Ops.insert(8, "atta")
    |> Heap.Ops.insert(2, "tva")
    |> Heap.Ops.insert(7, "sju")
    |> Heap.Ops.insert(3, "tre")

    IO.inspect(h)
    IO.inspect(Heap.Ops.extract(h))
  end

  @doc """
  Returns a new min-heap.
  {%Heap, comperator}
  """
  def new_min() do
    new(&(&1<&2))
  end

  @doc """
  Returns a new max-heap.
  {%Heap, comperator}
  """
  def new_max() do
    new(&(&1>&2))
  end

  defp new(fun) do
    %Heap{list: [], length: 0, fun: fun}
  end

  def is_heap?(heap) when is_map(heap) do
    heap.__struct__ == Heap
  end
  def is_heap?(_), do: false
end

defmodule Heap.Ops do
  import Heap

  def insert(heap, key, value) when is_integer(key) do
    if is_heap?(heap) do
      i = heap.length + 1
      list = heapify_up(heap.list, [{key, value}], i, heap.fun)
      %Heap{list: list, length: i, fun: heap.fun}
    else
      raise "Argument not a heap: #{IO.inspect(heap)}"
    end
  end

  def extract(heap) do
    if is_heap?(heap) do
      if heap.length > 0 do
        [first|list] = heap.list
        i = heap.length - 1
        {list,[w|last]} = get_i(list, i - 1)
        list = heapify_down([w|list ++ last],1,i,heap.fun)
        heap =
          %Heap{list: list, length: i, fun: heap.fun}
        {first, heap}
      else
        :error
      end

    else
      raise "Argument not a heap: #{IO.inspect(heap)}"
    end
  end

  defp heapify_down([],_,_,_), do: []
  defp heapify_down(heap, i, len, _) when i >= len, do: heap
  defp heapify_down(heap, i, len, comp) do
    {top, [{val,_} = w|bottom]} = get_i(heap, i)
    {top_left, [{left,_} = l|bottom]} = get_i(bottom, i)
    IO.inspect(left)
    IO.inspect(val)
    if comp.(left,val) do
      # TODO: switch
      IO.puts("left switch")
      heap = top ++ [l|top_left] ++ [w|bottom]
      heapify_down(heap, 2 * i, len, comp)
    else
      top_right = [l|top_left]
      [{right,_} = r | bottom] = bottom
      if comp.(right,val) do
        # TODO: switch
        IO.puts("right switch")
        heap = top ++ [r|top_right] ++ [w|bottom]
        heapify_down(heap, (2 * i) + 1, len, comp)
      else
        #all is well - no switch needed
        IO.puts("all well")
        IO.inspect(heap)
        heap
      end
    end
  end

  defp heapify_up(heap,new,1,_), do: heap ++ new
  defp heapify_up(heap,[{key2,_} = new|back],i,comp) do
    {top, [{key1,_} = prev|bottom]} = Enum.split(heap, div(i,2) - 1)
    if comp.(key1,key2) do
      heap ++ [new|back]
    else
      new = [new|bottom] ++ [prev|back]
      # IO.inspect(new)
      heapify_up(top, new, div(i,2), comp)
    end
  end

  defp get_i([h|list], i) do
    get_i(list, [h], i - 1)
  end
  defp get_i(list, acc, 0) do
    {Enum.reverse(acc), list}
  end
  defp get_i([h|t], acc, i) do
    get_i(t, [h|acc], i - 1)
  end

end
