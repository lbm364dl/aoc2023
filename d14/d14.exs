# Takes 8s approx for both parts

rot_90 = fn grid ->
  grid
  |> Enum.zip()
  |> Enum.map(& Tuple.to_list(&1) |> Enum.reverse())
end

total_load = fn grid ->
  m = grid |> List.first() |> length()
  grid
  |> Enum.map(fn row ->
    row
    |> Enum.with_index()
    |> Enum.reduce(0, fn {c, j}, acc -> c == ?O && acc+m-j || acc end)
  end)
  |> Enum.sum()
end

slide = fn grid ->
  grid
  |> Enum.map(fn row ->
    row
    |> Enum.with_index()
    |> Enum.reduce({0, %{}}, fn {c, j}, {move_to, slided} ->
      case c do
        ?O -> {move_to+1, slided |> Map.put(j, ?.) |> Map.put(move_to, ?O)}
        ?# -> {j+1, slided |> Map.put(j, ?#)}
        ?. -> {move_to, slided |> Map.put(j, ?.)}
      end
    end)
    |> elem(1)
    |> Enum.sort()
    |> Enum.map(& elem(&1, 1))
  end)
end

cycle = fn grid ->
  Enum.reduce(1..4, grid, fn _, grid ->
    grid
    |> slide.()
    |> rot_90.()
  end)
end

input = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&to_charlist/1)

input
|> then(& Enum.reduce(1..3, &1, fn _, grid -> rot_90.(grid) end))
|> slide.()
|> total_load.()
|> IO.inspect(label: "Star 1")

input
|> then(& Enum.reduce(1..3, &1, fn _, grid -> rot_90.(grid) end))
|> then(fn grid -> 
  Stream.unfold({%{}, grid, 0}, fn {grids, cur_grid, i} ->
    new_grid = cycle.(cur_grid)
    grids = grids |> Map.put(cur_grid, i)
    case grids[new_grid] do
      nil -> {{grids, new_grid, i+1}, {grids, new_grid, i+1}}
      _ -> nil
    end
  end)
  |> Enum.to_list()
  |> List.last()
  |> then(fn {grids, last_grid, last_it} ->
    first_it = grids[cycle.(last_grid)]
    cycle_len = last_it - first_it + 1
    grids
    |> Map.new(fn {k, v} -> {v-first_it, k} end)
    |> Map.get(rem(10**9 - first_it, cycle_len))
  end)
  |> total_load.()
end)
|> IO.inspect(label: "Star 2")
