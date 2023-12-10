defmodule Search do
  def dfs(x, p, g, vis, path) do
    case MapSet.member?(vis, x) do
      true -> {vis, path}
      false ->
        for {_, to} <- g[x] || [], to != p do
          to
        end
        |> Enum.reduce({MapSet.new(), -1}, fn to, {vis_acc, path_acc} ->
          {vis, path} = dfs(to, x, g, MapSet.put(vis, x), [to | path])
          {vis |> MapSet.union(vis_acc), path != -1 && path || path_acc}
        end)
    end
  end
end

input = File.read!("input.txt") |> String.split()
n = input |> length()
m = input |> List.first() |> String.length()

to_pipe_type = %{
  [1, 1] => ?-,
  [1, m] => ?L,
  [-m, -1] => ?F,
  [-1, -1] => ?-,
  [-1, m] => ?J,
  [-m, -1] => ?7,
  [m, m] => ?|,
  [m, 1] => ?7,
  [-1, m] => ?F,
  [-m, -m] => ?|,
  [-m, 1] => ?F,
  [-m, -1] => ?J,
}

delta = %{
  ?| => [{0, 1}, {0, -1}],
  ?- => [{1, 0}, {-1, 0}],
  ?L => [{0, -1}, {1, 0}],
  ?J => [{0, -1}, {-1, 0}],
  ?F => [{0, 1}, {1, 0}],
  ?7 => [{0, 1}, {-1, 0}],
}

id = fn {y, x} -> y*m + x end

grid = for {ln, y} <- Enum.with_index(input) do
  for {c, x} <- to_charlist(ln) |> Enum.with_index() do
    {id.({y, x}), c}
  end
end
|> List.flatten()
|> Map.new()

start = input
|> Enum.with_index()
|> Enum.map(fn {ln, y} ->
  to_charlist(ln)
  |> Enum.find_index(& &1 == ?S)
  |> then(& {y, &1})
end)
|> Enum.find(fn {_y, x} -> not is_nil(x) end)
|> then(& id.(&1))

ok_neighs_S = [{{0, 1}, '|JL'}, {{0, -1}, '|7F'}, {{1, 0}, '-7J'}, {{-1, 0}, '-LF'}]

g = for {ln, y} <- Enum.with_index(input) do
  for {c, x} <- to_charlist(ln) |> Enum.with_index(), c in '|-LJF7S' do
    case c do
      ?S ->
        for {{dx, dy}, ok_neighs} <- ok_neighs_S, (grid[id.({y+dy,x+dx})] || 0) in ok_neighs do
          {id.({y, x}), id.({y+dy, x+dx})}
        end
      c ->
        for {dx, dy} <- delta[c] do
          {id.({y, x}), id.({y+dy, x+dx})}
        end
    end
  end
end
|> List.flatten()
|> Enum.group_by(fn {from, _to} -> from end)

{_, path} = Search.dfs(start, -1, g, MapSet.new(), [start])

path
|> length()
|> div(2)
|> IO.inspect(label: "Star 1")

grid = grid
|> then(fn grid -> 
    start_pipe_type = Enum.zip_with(path, tl(path), &-/2)
    |> then(& [List.last(&1), List.first(&1)] |> Enum.sort())
    |> then(& to_pipe_type[&1])

    Map.put(grid, start, start_pipe_type)
end)

path = MapSet.new(path)

Enum.map(0..n-1, fn y ->
  Enum.reduce(0..m-1, {false, 0}, fn x, {inside?, area} ->
    id = id.({y, x})
    case id in path do
      true -> 
        {(if grid[id] in '|LJ', do: not inside?, else: inside?), area}
      false ->
        {inside?, area + (inside? && 1 || 0)}
    end
  end)
  |> then(fn {_, area} -> area end)
end)
|> Enum.sum()
|> IO.inspect(label: "Star 2")
