defmodule DP do
  def memo(xs, ys, f) do
    cached = Process.get({xs, ys, f})
    if cached do
      cached
    else
      v = ways(xs, ys, f)
      Process.put({xs, ys, f}, v)
      v
    end
  end

  def ways([], [], _f), do: 1
  def ways([], [0], _f), do: 1
  def ways([], _ys, _f), do: 0
  def ways([?# | _xs], [], _f), do: 0
  def ways([?# | _xs], [0 | _ys], _f), do: 0
  def ways([?# | xs], [y | ys], f), do: memo(xs, [y-1 | ys], f)
  def ways([?. | xs], [], f), do: memo(xs, [], f)
  def ways([?. | xs], [0], f), do: memo(xs, [], f)
  def ways([?. | xs], [0 | ys], _f), do: memo(xs, ys, hd(ys))
  def ways([?. | _xs], [y | _ys], f) when y != f, do: 0
  def ways([?. | xs], [y | ys], f) when y == f, do: memo(xs, [y | ys], f)
  def ways([?? | xs], ys, f), do: memo([?# | xs], ys, f) + memo([?. | xs], ys, f)
end

solve = fn star ->
  File.stream!("input.txt")
  |> Task.async_stream(fn ln ->
    [l, counts] = ln |> String.trim() |> String.split(" ")
    counts = counts
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    {l, counts} = case star do
      1 ->
        {l, counts}
      2 ->
        l = Enum.map(0..4, fn _ -> [l] end)
        |> Enum.reduce([], &++/2)
        |> Enum.join("?")

        counts = Enum.map(0..4, fn _ -> [counts] end)
        |> Enum.reduce([], &++/2)
        |> List.flatten()

        {l, counts}
    end
    DP.memo(to_charlist(l), counts, hd(counts))
  end)
  |> Enum.map(fn {:ok, v} -> v end)
  |> Enum.sum()
end

IO.inspect(solve.(1), label: "Star 1")
IO.inspect(solve.(2), label: "Star 2")
