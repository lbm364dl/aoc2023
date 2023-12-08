import Enum
[i,n]=String.split (File.read!"i"),"\n\n"
m=Map.new (Regex.scan~r{(.+) = \((.+), (...)},n),fn[_,n,l,r]->{n,%{?L=>l,?R=>r}}end
l=&sum Stream.transform((Stream.cycle to_charlist i),&1,fn _,<<_,_,?Z>>->{:halt,0};d,c->{[1],m[c][d]}end)
IO.puts l.("AAA")
IO.puts reduce map(filter((Map.keys m),&String.last(&1)=="A"),l),&div(&1*&2,Integer.gcd(&1,&2))
