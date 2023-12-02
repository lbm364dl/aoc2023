spelled_nums = ~w(zero one two three four five six seven eight nine)

to_num = fn match ->
  case Enum.find_index(spelled_nums, & &1 == match) do
    nil -> match
    index -> to_string(index)
  end
end

solve = fn include_spelled? ->
  {pattern, pattern_rev} = case include_spelled? do
    true -> 
      {
        ~r{#{Enum.join(spelled_nums, "|")}|[0-9]}, 
        ~r{#{Enum.join(spelled_nums |> Enum.map(& String.reverse/1), "|")}|[0-9]}
      }
    false -> 
      {
        ~r{[0-9]}, 
        ~r{[0-9]}, 
      }
  end

  File.stream!("input.txt")
  |> Stream.map(fn line -> 
    [first] = Regex.run(pattern, line)
    [last] = Regex.run(pattern_rev, String.reverse(line))
  
    "#{to_num.(first)}#{to_num.(last |> String.reverse())}"
    |> String.to_integer()
  end)
  |> Enum.sum()
end

IO.inspect(solve.(false), label: "Star 1")
IO.inspect(solve.(true), label: "Star 2")
