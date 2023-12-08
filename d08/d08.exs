# I don't like crafted inputs with hidden restrictions
# but for part 2 this code (as probably everyone else's)
# assumes the cycle lengths are always equal and always go
# through the same ending node and only that one

[instructions, nodes] = File.read!("input.txt") |> String.split("\n\n")

map = Regex.scan(~r{([A-Z]+) = \(([A-Z]+), ([A-Z]+)}, nodes)
|> Map.new(fn [_, node, l, r] -> {node, %{?L => l, ?R => r}} end)

path_length = fn start_node ->
  instructions
  |> to_charlist()
  |> Stream.cycle()
  |> Enum.reduce_while({start_node, 0}, fn
      _, {<<_, _, ?Z>>, i} -> {:halt, i}
      dir, {cur_node, i} -> {:cont, {map[cur_node][dir], i+1}}
    end
  )
end

path_length.("AAA")
|> IO.inspect(label: "Star 1")

map
|> Map.keys()
|> Enum.filter(& String.ends_with?(&1, "A"))
|> Enum.map(path_length)
|> Enum.reduce(& div(&1*&2, Integer.gcd(&1, &2)))
|> IO.inspect(label: "Star 2")
