games = File.stream!("input.txt")
|> Stream.map(fn line ->
  [_, options] = line |> String.trim() |> String.split(":")

  for option <- options |> String.split(";") do
    for bag <- option |> String.split(",") do
      [cnt, color] = bag |> String.split(" ", trim: true)
      {color, String.to_integer(cnt)}
    end
    |> Map.new()
  end
end)

mx = %{"red" => 12, "green" => 13, "blue" => 14}
for {game, i} <- games |> Enum.with_index() do
  game
  |> Enum.all?(& &1 |> Enum.all?(fn {color, cnt} -> mx[color] >= cnt end))
  |> then(& &1 && i+1 || 0)
end
|> Enum.sum()
|> IO.inspect(label: "Star 1")

for game <- games do
  game
  |> Enum.reduce(& Map.merge(&1, &2, fn _k, v1, v2 -> max(v1, v2) end))
  |> Map.values()
  |> Enum.product()
end
|> Enum.sum()
|> IO.inspect(label: "Star 2")
