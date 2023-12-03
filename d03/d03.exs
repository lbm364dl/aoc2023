deltas = Enum.zip([1, 0, -1, 0, 1, 1, -1, -1], [0, 1, 0, -1, 1, -1, 1, -1])

grid = File.stream!("input.txt")
|> Stream.with_index()
|> Stream.map(fn {line, y} ->
    line 
    |> to_charlist()
    |> Enum.with_index()
    |> Enum.map(fn {c, x} -> {{y, x}, c} end)
    |> Map.new()
end)
|> Enum.reduce(&Map.merge/2)

{marked?, get_id, get_val, _, _} = grid
|> Enum.sort()
|> Enum.reduce(
    {MapSet.new(), %{}, %{}, 0, 0}, 
    fn {{y, x}, c}, {marked?, get_id, get_val, cur_num, cur_id} ->
      cur_marked? = deltas
        |> Enum.map(fn {dy, dx} -> {y+dy, x+dx} end)
        |> Enum.any?(& Map.get(grid, &1, ?.) not in Enum.concat(?0..?9, [?., ?\n]))

      {cur_num, cur_id, sgn} = case c in ?0..?9 do
        true -> {10*cur_num + c-?0, cur_id, 1}
        false -> {0, cur_id + 1, -1}
      end

      {
        (if cur_marked?, do: MapSet.put(marked?, {y, x}), else: marked?),
        get_id |> Map.put({y, x}, sgn * cur_id),
        get_val |> Map.put(sgn * cur_id, cur_num),
        cur_num,
        cur_id
      }
    end
)

marked?
|> Enum.map(& Map.get(get_id, &1, -1))
|> Enum.filter(& &1 >= 0)
|> MapSet.new()
|> Enum.map(& Map.get(get_val, &1))
|> Enum.sum()
|> IO.inspect(label: "Star 1")

grid
|> Enum.filter(fn {_k, v} -> v == ?* end)
|> Enum.map(fn {{y, x}, _c} ->
    ids = deltas
    |> Enum.map(fn {dy, dx} -> Map.get(get_id, {y+dy, x+dx}) end)
    |> Enum.filter(& &1 >= 0)
    |> MapSet.new()

    case MapSet.size(ids) do
      2 -> ids |> Enum.map(& Map.get(get_val, &1)) |> Enum.product()
      _ -> 0
    end
end)
|> Enum.sum()
|> IO.inspect(label: "Star 2")
