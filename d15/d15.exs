hash = fn s ->
  s
  |> to_charlist()
  |> Enum.reduce(0, fn c, acc -> rem((acc+c)*17, 256) end)
end

input = File.read!("input.txt")
|> String.trim()
|> String.split(",")

input
|> Enum.map(& hash.(&1))
|> Enum.sum()
|> IO.inspect(label: "Star 1")

input
|> Enum.with_index()
|> Enum.reduce(%{}, fn {s, i}, boxes ->
  case s =~ "=" do
    true -> 
      [label, val] = String.split(s, "=")
      val = String.to_integer(val)
      Map.update(boxes, hash.(label), %{label => {val, i}}, fn box ->
        Map.update(box, label, {val, i}, fn {_, i} -> {val, i} end)
      end)
    false ->
      [label] = String.split(s, "-", trim: true)
      Map.update(boxes, hash.(label), %{}, & Map.delete(&1, label))
  end
end)
|> Enum.map(fn {box_pos, lens} ->
  lens
  |> Enum.sort_by(fn {_k, {_val, i}} -> i end)
  |> Enum.with_index()
  |> Enum.map(fn {{_, {val, _}}, lens_pos} -> (box_pos+1) * (lens_pos+1) * val end)
  |> Enum.sum()
end)
|> Enum.sum()
|> IO.inspect(label: "Star 2")
