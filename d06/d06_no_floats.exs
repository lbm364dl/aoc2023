defmodule Search do
  def binary_search(l, r, _func) when r-l <= 1, do: r
  def binary_search(l, r, func) do
    m = Integer.floor_div(l+r, 2)
    case func.(m) do
      false -> binary_search(m, r, func)
      true -> binary_search(l, m, func)
    end
  end
end

input = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(& Regex.scan(~r{\d+}, &1) |> Enum.map(fn [x] -> String.to_integer(x) end))

solve = fn times_and_distances ->
  times_and_distances
  |> Enum.map(fn {t, d} ->
    mn = Search.binary_search(0, div(t, 2), & (t-&1)*&1 > d)
    mx = Search.binary_search(div(t+1, 2), 10**18, & (t-&1)*&1 < d)
    mx - mn
  end)
  |> Enum.product()
end

input
|> Enum.zip()
|> solve.()
|> IO.inspect(label: "Star 1")

input
|> Enum.map(& Enum.join(&1) |> String.to_integer())
|> then(fn [t, d] -> [{t, d}] end)
|> solve.()
|> IO.inspect(label: "Star 2")
