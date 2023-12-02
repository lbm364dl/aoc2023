spelled_nums = ~w(zero one two three four five six seven eight nine)

to_num = fn match ->
  case Enum.find_index(spelled_nums, & &1 == match) do
    nil -> match
    index -> to_string(index)
  end
end

solve = fn include_spelled? ->
  File.stream!("input.txt")
  |> Stream.map(fn line -> 
    case include_spelled? do
      true -> spelled_nums
      false -> []
    end
    |> Enum.concat(1..9)
    |> Enum.map(& Regex.scan(~r/#{&1}/, line, return: :index))
    |> List.flatten()
    |> Enum.min_max()
    |> Tuple.to_list()
    |> Enum.map(fn {start, length} ->
      line
      |> String.slice(start, length)
      |> to_num.()
    end)
    |> Enum.join("")
    |> String.to_integer()
  end)
  |> Enum.sum()
end

IO.inspect(solve.(false), label: "Star 1")
IO.inspect(solve.(true), label: "Star 2")
