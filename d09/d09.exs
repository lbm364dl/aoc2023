solve = fn first? ->
  File.stream!("input.txt")
  |> Stream.map(fn ln -> 
    ln
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Stream.unfold(fn l ->
      case Enum.all?(l, & &1 == 0) do
        true -> nil
        false -> {
          first? && List.first(l) || List.last(l), 
          Enum.zip_with(tl(l), l, & &1-&2)
        }
      end
    end)
    |> then(fn ends ->
      case first? do
        true ->
          ends
          |> Enum.reverse()
          |> Enum.reduce(& &1-&2)
        false ->
          ends
          |> Enum.sum()
      end
    end)
  end)
  |> Enum.sum()
end

IO.inspect(solve.(false), label: "Star 1")
IO.inspect(solve.(true), label: "Star 2")
