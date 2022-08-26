defmodule List2 do

  def test(n) do
    {t1,t2} = loop(n,0,0)
    IO.puts(Float.round((t1/10_000)/n, 3))
    IO.puts(Float.round((t2/10_000)/n, 3))
  end

  defp loop(0, t1, t2) do
    {t1,t2}
  end
  defp loop(n, t1, t2) do
    list1 = Enum.to_list(1..10000000) |> Enum.reverse()
    list2 = Enum.to_list(100..20000)
    fun = &rev_append1(&1,&2)
    {time, _} = :timer.tc(fun,[list1,list2])
    t1 = t1 + time
    fun = &rev_append2(&1,&2)
    {time, _} = :timer.tc(fun,[list1,list2])
    t2 = t2 + time
    loop(n-1, t1, t2)
  end

  def rev_append1([],x), do: x
  def rev_append1([h|t],x), do: rev_append1(t, [h|x])

  def rev_append2(l1,l2), do: List.foldl(l1,l2,&([&1|&2]))
end
