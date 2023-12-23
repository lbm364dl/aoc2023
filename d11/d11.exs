input = File.read!("input.txt") |> String.split("\n", trim: true)
n = input |> length()
m = input |> List.first() |> String.length()

grid = for {row, y} <- input |> Enum.with_index() do
  for {c, x} <- row |> to_charlist() |> Enum.with_index() do
    {{y, x}, c}
  end
end
|> List.flatten()
|> Map.new()

empty_rows = Enum.filter(0..n-1, fn y -> Enum.all?(0..m-1, fn x -> grid[{y, x}] == ?. end) end)
empty_cols = Enum.filter(0..m-1, fn x -> Enum.all?(0..n-1, fn y -> grid[{y, x}] == ?. end) end)

galaxies = for y <- 0..n-1 do
  for x <- 0..m-1, grid[{y, x}] == ?# do
    {y, x}
  end
end
|> List.flatten()

total = fn mult ->
  for {y1, x1} <- galaxies do
    for {y2, x2} <- galaxies do
      {x1, x2} = Enum.min_max([x1, x2])
      {y1, y2} = Enum.min_max([y1, y2])
      (
        y2-y1 
        + x2-x1 
        + mult*Enum.count(empty_cols, & x1 < &1 && &1 < x2) 
        + mult*Enum.count(empty_rows, & y1 < &1 && &1 < y2)
      )
    end
    |> Enum.sum()
  end
  |> Enum.sum()
  |> div(2)
end

IO.inspect(total.(1), label: "Star 1")
IO.inspect(total.(999999), label: "Star 2")
