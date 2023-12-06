winning = File.stream!("input.txt")
|> Stream.map(fn line ->
  line = String.trim(line)
  [_card, parts] = String.split(line, ":")
  [winning, all_cards] = parts
    |> String.split("|")
    |> Enum.map(& String.split(&1, " ", trim: true))
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)

  winning = MapSet.new(winning)
  Enum.count(all_cards, & MapSet.member?(winning, &1))
end)

winning
|> Stream.map(& floor(2**(&1-1)))
|> Enum.sum()
|> IO.inspect(label: "Star 1")

winning
|> Stream.with_index(1)
|> Enum.reduce(%{}, fn {cnt, i}, acc ->
  acc = Map.update(acc, i, 1, & &1+1)

  (cnt>0 && (i+1..i+cnt) || [])
  |> Enum.reduce(acc, fn j, acc -> Map.update(acc, j, acc[i], & &1+acc[i]) end)
end)
|> Map.values()
|> Enum.sum()
|> IO.inspect(label: "Star 2")
