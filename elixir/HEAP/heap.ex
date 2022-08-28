# Author Tom Karlsson
# Created 2022-08-26
defmodule Heap do
  @moduledoc """
  This module provides a heap data structure. Either min-heap or max-heap can be chosen.

  functions:
  start_min/0
  start_max/0
  insert/3
  extract/1
  find/1 - TODO
  is_empty?/1
  """
  defstruct vector: nil, length: nil, fun: nil

  def test() do
    h = start_min()
    |> Heap.Ops.insert(9, "nio")
    |> Heap.Ops.insert(1, "ett")
    |> Heap.Ops.insert(8, "atta")
    |> Heap.Ops.insert(2, "tva")
    |> Heap.Ops.insert(7, "sju")
    |> Heap.Ops.insert(3, "tre")
    |> Heap.Ops.insert(6, "sex")
    |> Heap.Ops.insert(4, "fyra")
    |> Heap.Ops.insert(5, "fem")

    IO.inspect(h)

    {{_,res}, h} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")
    IO.inspect(h)

    {{_,res}, h} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")
    IO.inspect(h)

    {{_,res}, h} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")
    IO.inspect(h)

    {{_,res}, h} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")
    IO.inspect(h)


    {{_,res}, h} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")

    {{_,res}, h} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")

    {{_,res}, h} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")

    {{_,res}, h} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")

    {{_,res}, h} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")

    {{_,res}, _} = Heap.Ops.extract(h)
    IO.puts("extracted min and got value: #{res}")


  end

  @doc """
  Returns a new min-heap.
  {%Heap, comperator}
  """
  def start_min() do
    new(&(&1<&2))
  end

  @doc """
  Returns a new max-heap.
  {%Heap, comperator}
  """
  def start_max() do
    new(&(&1>&2))
  end

  defp new(fun) do
    %Heap{vector: {}, length: -1, fun: fun}
  end

  def is_heap?(heap) when is_map(heap) do
    heap.__struct__ == Heap
  end
  def is_heap?(_), do: false

  @doc """
  returns true if heap is empty
  """
  def is_empty?(heap) do
    heap.length < 0
  end

  @doc """
  insert/3 takes heap, key and value as arguments.
  insert/3 appends the key-value pair to the heap and returns this new heap.
  """
  def insert(h,k,v), do: Heap.Ops.insert(h,k,v)

  @doc """
  extract/1 removes and returnes the root element of the heap together with a new heap.
  If a min-heap the value with a minimum key is returned, if a max-heap the value with a maximum key is returned(there can be several keys with the same min/max).
  """
  def extract(h), do: Heap.Ops.extract(h)
end

defmodule Heap.Ops do
  import Heap

  @doc """
  insert/3 takes heap, key and value as arguments.
  insert/3 appends the key-value pair to the heap and returns this new heap.
  """
  def insert(heap, key, value) when is_integer(key) do
    if is_heap?(heap) do
      i = heap.length + 1
      v = Tuple.append(heap.vector, {key, value})
      |> heapify_up(i,heap.fun)
      %Heap{vector: v, length: i, fun: heap.fun}
    else
      raise "Argument not a heap: #{IO.inspect(heap)}"
    end
  end

  @doc """
  extract/1 removes and returnes the root element of the heap together with a new heap.
  If a min-heap the value with a minimum key is returned, if a max-heap the value with a maximum key is returned(there can be several keys with the same min/max).
  """
  def extract(heap) do
    if is_heap?(heap) do
      i = heap.length
      if i < 0 do
        raise "Trying to extract from empty heap"
      else
        res = elem(heap.vector, 0)
        tmp = elem(heap.vector, i)
        v =
          put_elem(heap.vector, 0, tmp)
          |> Tuple.delete_at(i)

        i = i - 1
        v = heapify_down(v,1,i,heap.fun)
        {res, %Heap{vector: v, length: i, fun: heap.fun}}
      end
    else
      raise "Argument not a heap: #{IO.inspect(heap)}"
    end
  end

  defp heapify_down({},_,_,_), do: {}
  defp heapify_down(v, i, len, _) when i >= len, do: v
  defp heapify_down(vector, i, len, comp) do
    #IO.puts("heapify down with i : #{i} and vector:")
    #IO.inspect(vector)
    {key, val} = elem(vector, i - 1)
    left_i = 2 * i
    right_i = left_i + 1
    #check if index is valid
    if (right_i <= len) do
      left_child = elem(vector, left_i - 1)
      {left, _} = left_child
      right_child = elem(vector, right_i - 1)
      {right, _} = right_child
      if (comp.(left,right)) do
        # check left
        if comp.(key,left) do
          # all correct
          vector
        else
          # swap
          put_elem(vector, i - 1, left_child)
          |> put_elem(left_i - 1, {key, val})
          |> heapify_down(left_i,len,comp)
        end
      else
        # check right
        if comp.(key,right) do
          # all correct
          vector
        else
          # swap
          put_elem(vector, i - 1, right_child)
          |> put_elem(right_i - 1, {key, val})
          |> heapify_down(right_i,len,comp)
        end
      end
    else
      if (left_i <= len) do
        left_child = elem(vector, left_i - 1)
        {left, _} = left_child
        # check left
        if comp.(key,left) do
          # all correct
          vector
        else
          # swap
          put_elem(vector, i - 1, left_child)
          |> put_elem(left_i - 1, {key, val})
          |> heapify_down(left_i,len,comp)
        end
      else
        vector
      end
    end
  end

  defp heapify_up(vector,0,_), do: vector
  defp heapify_up(vector,i,comp) do
    {key1,val1} = elem(vector, div(i,2))
    {key2,val2} = elem(vector, i)
    if comp.(key1,key2) do
      vector
    else
      put_elem(vector, div(i,2), {key2, val2})
      |> put_elem(i, {key1, val1})
      |> heapify_up(div(i,2), comp)
    end
  end

end
