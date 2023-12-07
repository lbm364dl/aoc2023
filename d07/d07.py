from collections import Counter

l = [(a, int(b)) for a, b in map(str.split, open(0).readlines())]
hand_pow = [[5], [4], [3, 2], [3], [2, 2], [2], [1], []]
card_pow = ['23456789TJQKA', 'J23456789TQKA']

def order(hand, use_js):
    *rest, = filter(lambda c: not use_js or c != 'J', hand)
    num_js = use_js and sum(c == 'J' for c in hand) or 0
    head, *tail = next(filter(lambda need: Counter(need) <= Counter(Counter(rest).values()), hand_pow)) or [0]
    return (-hand_pow.index([head+num_js, *tail]), tuple(map(card_pow[use_js].index, hand)))

print([sum(i*bid for i, (_, bid) in enumerate(sorted(l, key=lambda x: order(x[0], use_js)), 1)) for use_js in [0, 1]])
