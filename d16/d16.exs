# Takes approx 6s to solve both parts

defmodule Grid do
  def filled() do
    Process.get(:memo)
    |> Enum.map(fn {square, _} -> square end)
    |> MapSet.new()
    |> MapSet.size()
  end

  def memo(square, direction, grid) do
    visited? = Process.get(:memo) |> MapSet.member?({square, direction})
    if visited? || is_nil(grid[square]) do
      true
    else
      Process.put(:memo, Process.get(:memo) |> MapSet.put({square, direction}))
      dfs(square, direction, grid)
    end
  end

  def dfs({y, x}, {dy, dx}, grid) do
    case grid[{y, x}] do
      ?. -> memo({y+dy, x+dx}, {dy, dx}, grid)
      ?| -> 
        case {dy, dx} do
          {0, _} ->
            memo({y+1, x}, {1, 0}, grid)
            memo({y-1, x}, {-1, 0}, grid)
          {dy, 0} ->
            memo({y+dy, x}, {dy, 0}, grid)
        end
      ?- -> 
        case {dy, dx} do
          {_, 0} ->
            memo({y, x+1}, {0, 1}, grid)
            memo({y, x-1}, {0, -1}, grid)
          {0, dx} ->
            memo({y, x+dx}, {0, dx}, grid)
        end
      ?\\ -> 
        {new_dy, new_dx} = {dx, dy}
        memo({y+new_dy, x+new_dx}, {new_dy, new_dx}, grid)
      ?/ -> 
        {new_dy, new_dx} = {-dx, -dy}
        memo({y+new_dy, x+new_dx}, {new_dy, new_dx}, grid)
    end
  end
end

input = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&to_charlist/1)

n = input |> length()
m = input |> List.first() |> length()

grid = for {row, y} <- Enum.with_index(input) do
  for {c, x} <- Enum.with_index(row) do
    {{y, x}, c}
  end
end
|> List.flatten()
|> Map.new()

Process.put(:memo, MapSet.new())
Grid.memo({0, 0}, {0, 1}, grid)
Grid.filled()
|> IO.inspect(label: "Star 1")

for {{y, x}, _} <- Enum.filter(grid, fn {{y, x}, _} -> (y in [0, n-1]) || (x in [0, m-1]) end) do
  for {dy, dx} <- [{0, 1}, {0, -1}, {-1, 0}, {1, 0}] do
    {{y, x}, {dy, dx}}
  end
end
|> List.flatten()
|> Task.async_stream(fn {{y, x}, {dy, dx}} ->
  Process.put(:memo, MapSet.new())
  Grid.memo({y, x}, {dy, dx}, grid)
  Grid.filled()
end)
|> Enum.map(fn {:ok, v} -> v end)
|> Enum.max()
|> IO.inspect(label: "Star 2")
