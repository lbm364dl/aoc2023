# Takes 13s approx for both parts

defmodule Paths do
  @inf 10**12
  
  def shortest_path(pq, dist, grid, n, m, mn_consec, mx_consec) do
    {{cur_d, {{y, x}, {dy, dx}, cnt} = node}, new_pq} = :gb_sets.take_smallest(pq)

    cond do
      dist[node] != cur_d ->
        shortest_path(new_pq, dist, grid, n, m, mn_consec, mx_consec)
      {y, x} == {n-1, m-1} ->
        cur_d
      true ->
        [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
        |> Enum.map(fn {ndy, ndx} ->
          {ny, nx} = {y+ndy, x+ndx}
          new_cnt = {ndy, ndx} == {dy, dx} && cnt+1 || 1
          new_dist = cond do
            {dy, dx} == {-ndy, -ndx} -> @inf
            is_nil(grid[{ny, nx}]) -> @inf
            {ndy, ndx} != {dy, dx} && cnt < mn_consec -> @inf
            {ndy, ndx} == {dy, dx} && cnt+1 > mx_consec -> @inf
            true -> dist[node] + grid[{ny, nx}]
          end
          new_node = {{ny, nx}, {ndy, ndx}, new_cnt}
          {new_dist, new_node}
        end)
        |> Enum.reduce({new_pq, dist}, fn {new_dist, new_node}, {pq, dist} ->
          if new_dist < @inf && new_dist < dist[new_node] do
            {:gb_sets.insert({new_dist, new_node}, pq), Map.put(dist, new_node, new_dist)}
          else
            {pq, dist}
          end
        end)
        |> then(fn {new_pq, new_dist} ->
          shortest_path(new_pq, new_dist, grid, n, m, mn_consec, mx_consec)
        end)
    end
  end
end

input = File.read!("input.txt") |> String.split("\n", trim: true)
n = input |> length()
m = input |> List.first() |> String.length()

grid = for {row, y} <- Enum.with_index(input) do
  for {col, x} <- row |> to_charlist() |> Enum.with_index() do
    {{y, x}, col-?0}
  end
end
|> List.flatten()
|> Map.new()

node_1 = {{0, 0}, {1, 0}, 0}
node_2 = {{0, 0}, {0, 1}, 0}
pq = :gb_sets.from_list([{0, node_1}, {0, node_2}])
dist = %{node_1 => 0, node_2 => 0}

IO.inspect(Paths.shortest_path(pq, dist, grid, n, m, 0, 3), label: "Star 1")
IO.inspect(Paths.shortest_path(pq, dist, grid, n, m, 4, 10), label: "Star 2")
