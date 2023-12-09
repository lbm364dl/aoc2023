from operator import sub, add
l = [[*map(int,l.split())] for l in open(0)]

def f(l, pos, op):
    return op(l[pos], f([*map(sub, l[1:], l)], pos, op)) if l else 0

for pos, op in (-1, add), (0, sub): 
    print(sum(map(lambda l: f(l, pos, op), l)))
