cols = fn grid, cnt ->
  n = grid |> length()
  m = grid |> List.first() |> length()

  grid = for {row, i} <- grid |> Enum.with_index() do
    for {col, j} <- row |> Enum.with_index() do
      {{i, j}, col}
    end
  end
  |> List.flatten()
  |> Map.new()

  for bar <- 0..m-1 do
    for y <- 0..n-1 do
      for x <- 0..m-1 do
        {grid[{y, x}], grid[{y, bar+1-(x-bar)}]}
        |> then(fn {x1, x2} -> if is_nil(x1) || is_nil(x2) || x1 == x2, do: 0, else: 1 end)
      end
      |> Enum.sum()
    end
    |> Enum.sum()
    |> div(2)
    |> then(& &1 == cnt)
  end
  |> Enum.find_index(& &1 == true)
  |> then(& &1 < m-1 && &1+1 || 0)
end

solve = fn cnt ->
  File.read!("input.txt")
  |> String.split("\n\n")
  |> Enum.map(fn grid_str ->
    grid = grid_str
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
  
    vertical = grid
    |> cols.(cnt)
  
    horizontal = grid
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> cols.(cnt)
  
    {vertical, horizontal}
  end)
  |> Enum.reduce({0, 0}, fn {v, h}, {v_acc, h_acc} -> {v+v_acc, h+h_acc} end)
  |> then(fn {v, h} -> v + 100*h end)
end

IO.inspect(solve.(0), label: "Star 1")
IO.inspect(solve.(1), label: "Star 2")
