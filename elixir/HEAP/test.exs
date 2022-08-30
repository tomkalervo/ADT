defmodule Test do

  def start(arg) do
    IO.inspect(arg)
    [i,n] = Enum.take(arg, 2) |> Enum.map(&(String.to_integer(&1)))
    l = Enum.map(1..i, fn(x) -> {:rand.uniform(n), Integer.to_string(x)} end)
    #Enum.each(l, &(IO.inspect(&1)))
    fun1 = fn(list,len) -> heap_start(list,len) end
    fun2 = fn(list,len) -> llist_start(list,len) end

    {time1, {:ok, acc1}} = :timer.tc(fun1, [l,i])
    {time2, {:ok, acc2}} = :timer.tc(fun2, [l,i])
    IO.puts("heap time : #{time1}")
    IO.puts("linked list time : #{time2}")
    print_res(acc1,acc2)
  end

  def print_res([],[]),do: IO.puts("done")
  def print_res([{k1,v1}|acc1],[{k2,v2}|acc2]) do
      #IO.puts("heap #{k1}:#{v1} \t\t linked #{k2}:#{v2}")
      print_res(acc1,acc2)
  end

  def llist_start(list, len) do
    h = Enum.sort(list, fn({k1,_},{k2,_}) -> k1 < k2 end)
    llist_extract(h, len)
  end
  def llist_extract([h|t], len) do
    #{_, val} = h
    llist_extract(t, len-1, [h])
  end
  def llist_extract(_,0,acc), do: {:ok, acc}
  def llist_extract([h|t], len, acc) do
        #{_, val} = h
        llist_extract(t, len-1, [h|acc])
  end

  def heap_start(list, len) do
    h = List.foldl(list, Heap.start_min(), fn({key, value}, h) ->
      Heap.insert(h, key, value)
    end)
    #IO.inspect(h)
    heap_extract(h, len)
  end
  def heap_extract(h,len) do
    {res,h} = Heap.extract(h)
    #{_, val} = res
    heap_extract(h, len - 1, [res])
  end
  def heap_extract(_,0,acc), do: {:ok, acc}
  def heap_extract(h,len,acc) do
    {res,h} = Heap.extract(h)
    #IO.inspect(res)
    #{_, val} = res
    heap_extract(h, len - 1, [res|acc])
  end

end

Test.start(System.argv)
