[seeds | maps] = File.read!("input.txt") |> String.split("\n\n")

seeds = seeds |> String.split(" ") |> tl() |> Enum.map(&String.to_integer/1)

maps = maps
|> Enum.map(fn map -> 
  [mapping_names | mapping_ranges] = String.split(map, "\n", trim: true)
  [_, from, to] = Regex.run(~r{^(.+)-to-(.+) map:$}, mapping_names)

  mapping_ranges = mapping_ranges
  |> Enum.map(fn ranges -> 
    [v_to, v_from, len] = String.split(ranges, " ") |> Enum.map(&String.to_integer/1)
    {v_from, v_to, len}
  end)
  |> Enum.sort(:desc)

  {from, {to, mapping_ranges}}
end)
|> Map.new()
|> Map.put("location", {"end", []})

min_location = fn seeds ->
  seeds
  |> Enum.map(fn [from, len] -> {from, from+len} end)
  |> then(fn seeds -> 
    Stream.unfold({seeds, maps["seed"]}, fn 
      {_, {"end", _}} -> 
        nil
      {seeds, {next_map, mapping_ranges}} ->
        seeds
        |> Enum.flat_map(fn {a, b} ->
          mapping_ranges
          |> Enum.reduce(%{}, fn {v_from, v_to, len}, acc ->
            acc
            |> Map.put(v_from, v_to)
            |> Map.put_new(v_from+len, v_from+len)
          end)
          |> Map.put_new(0, 0)
          |> Map.put_new(10**18, 10**18)
          |> Enum.sort()
          |> then(& Enum.zip_with(&1, tl(&1), fn {v_from_1, v_to_1}, {v_from_2, _} ->
            {v_from_1, v_from_2, v_to_1}
          end))
          |> Enum.map(fn {c, d, to} -> 
            {new_c, new_d} = {max(a, c), min(b, d)} 
            {new_c, new_d, to+new_c-c}
          end)
          |> Enum.filter(fn {c, d, _} -> c <= d end)
        end)
        |> Enum.map(fn {c, d, to} -> {to, to+d-c} end)
        |> then(& {&1, {&1, maps[next_map]}})
    end)
    |> Enum.to_list()
    |> List.last()
    |> Enum.min()
    |> elem(0)
  end)
end

seeds
|> Enum.map(& [&1, 1])
|> min_location.()
|> IO.inspect(label: "Star 1")

seeds
|> Enum.chunk_every(2)
|> min_location.()
|> IO.inspect(label: "Star 2")
