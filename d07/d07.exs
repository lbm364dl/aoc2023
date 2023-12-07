hands = File.stream!("input.txt")
|> Stream.map(fn line -> 
  [hand, bid] = line |> String.trim() |> String.split(" ")
  {to_charlist(hand), String.to_integer(bid)}
end)

hand_strength = [[5], [4], [3, 2], [3], [2, 2], [2], [1], []]
card_strength = %{false: '23456789TJQKA', true: 'J23456789TQKA'}

order = fn hand, use_jokers? ->
  {rest, jokers} = use_jokers? && Enum.split_with(hand, & &1 != ?J) || {hand, []}
  cnts = rest |> Enum.frequencies() |> Map.values() |> Enum.frequencies()

  hand_indices = hand
  |> Enum.map(fn card -> 
    Enum.find_index(card_strength[use_jokers?], & &1 == card) 
  end)

  idx = hand_strength
  |> Enum.find_index(fn need -> 
    need
    |> Enum.frequencies()
    |> Enum.all?(fn {k, v} -> v <= (cnts[k] || 0) end) 
  end)

  [head | rest] = hand_strength
  |> Enum.at(idx)
  |> then(& length(&1)>0 && &1 || [0])
  
  extra = use_jokers? && length(jokers) || 0
  strength = hand_strength
  |> Enum.find_index(& &1 == [head+extra | rest])

  {strength * -1, hand_indices}
end

solve = fn use_jokers? ->
  hands
  |> Enum.sort_by(fn {hand, _bid} -> order.(hand, use_jokers?) end)
  |> Enum.with_index(1)
  |> Enum.map(fn {{_hand, bid}, i} -> bid * i end)
  |> Enum.sum()
end

IO.inspect(solve.(false), label: "Star 1")
IO.inspect(solve.(true), label: "Star 2")
