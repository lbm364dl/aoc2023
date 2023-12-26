solve = fn first? ->
  File.stream!("input.txt")
  |> Stream.map(fn ln -> 
    String.split(ln)
    |> Enum.map(&String.to_integer/1)
    |> Stream.unfold(fn l ->
      case Enum.all?(l, & &1 == 0) do
        true -> nil
        false -> {Enum.at(l, first? && 0 || -1), Enum.zip_with(tl(l), l, &-/2)}
      end
    end)
    |> then(fn ends ->
      case first? do
        true -> ends |> Enum.reverse() |> Enum.reduce(&-/2)
        false -> ends |> Enum.sum()
      end
    end)
  end)
  |> Enum.sum()
end

IO.inspect(solve.(false), label: "Star 1")
IO.inspect(solve.(true), label: "Star 2")
