input = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(& Regex.scan(~r{\d+}, &1) |> Enum.map(fn [x] -> String.to_integer(x) end))

solve = fn times_and_distances ->
  times_and_distances
  |> Enum.map(fn {t, d} ->
    sqrt = :math.sqrt(t*t - 4*d)
    floor((t+sqrt)/2) - ceil((t-sqrt)/2) + 1
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
