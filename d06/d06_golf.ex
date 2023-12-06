import Enum
i=&String.to_integer/1
l=map (Regex.scan~r{\d+},File.read!"i"),&i.(hd &1)
l=chunk_every l,div(length(l),2)
f=fn[t,d]->s=(t*t-4*d)**0.5;floor((t+s)/2)-ceil((t-s)/2)+1 end
IO.puts product zip_with l,f
IO.puts f.(map l,&i.(join&1))
