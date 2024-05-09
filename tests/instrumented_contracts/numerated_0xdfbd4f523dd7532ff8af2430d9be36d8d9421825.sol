1 # @version ^0.2.0
2 
3 interface UniswapV2Pair:
4     def sync(): nonpayable
5 
6 interface Stakable:
7     def deposit(_account: address, _amount: uint256) -> bool: nonpayable
8     def stake(_reward: uint256) -> bool: nonpayable
9     def withdraw(_account: address) -> bool: nonpayable
10 
11 event CommitOwnership:
12     owner: address
13 
14 event ApplyOwnership:
15     owner: address
16 
17 
18 TOKEN: constant(address) = 0x674C6Ad92Fd080e4004b2312b45f796a192D27a0
19 MAX_PAIRS_LENGTH: constant(uint256) = 10 ** 3
20 
21 
22 uniswapPairs: public(address[MAX_PAIRS_LENGTH])
23 indexByPair: public(HashMap[address, uint256])
24 lastPairIndex: public(uint256)
25 
26 author: public(address)
27 owner: public(address)
28 futureOwner: public(address)
29 
30 
31 @external
32 def __init__():
33     self.author = msg.sender
34     self.owner = msg.sender
35 
36 
37 @external
38 def deposit(_account: address, _amount: uint256) -> bool:
39     assert msg.sender == self.owner or msg.sender == self.author, "owner only"
40     return Stakable(TOKEN).deposit(_account, _amount)
41 
42 
43 @external
44 def stake(_reward: uint256) -> bool:
45     assert msg.sender == self.owner or msg.sender == self.author, "owner only"
46     assert Stakable(TOKEN).stake(_reward)
47 
48     _lastPairIndex: uint256 = self.lastPairIndex
49     for i in range(1, MAX_PAIRS_LENGTH):
50         if i > _lastPairIndex:
51             break
52 
53         UniswapV2Pair(self.uniswapPairs[i]).sync()
54 
55     return True
56 
57 
58 @external
59 def withdraw(_account: address) -> bool:
60     assert msg.sender == self.owner or msg.sender == self.author, "owner only"
61     return Stakable(TOKEN).withdraw(_account)
62 
63 
64 @external
65 def addUniswapPair(_pair: address):
66     assert msg.sender == self.owner or msg.sender == self.author, "owner only"
67     assert _pair != ZERO_ADDRESS
68     pairIndex: uint256 = self.indexByPair[_pair]
69     assert pairIndex == 0, "pair is exist"
70 
71     pairIndex = self.lastPairIndex + 1
72     self.uniswapPairs[pairIndex] = _pair
73     self.indexByPair[_pair] = pairIndex
74     self.lastPairIndex = pairIndex
75 
76 
77 @external
78 def removeUniswapPair(_pair: address):
79     assert msg.sender == self.owner or msg.sender == self.author, "owner only"
80     pairIndex: uint256 = self.indexByPair[_pair]
81     assert pairIndex > 0, "pair is not exist"
82 
83     recentPairIndex: uint256 = self.lastPairIndex
84     lastPair: address = self.uniswapPairs[recentPairIndex]
85 
86     self.uniswapPairs[pairIndex] = lastPair
87     self.indexByPair[lastPair] = pairIndex
88     self.indexByPair[_pair] = 0
89     self.lastPairIndex = recentPairIndex - 1
90 
91 
92 @external
93 def transferOwnership(_futureOwner: address):
94     assert msg.sender == self.owner or msg.sender == self.author, "owner only"
95     self.futureOwner = _futureOwner
96     log CommitOwnership(_futureOwner)
97 
98 
99 @external
100 def applyOwnership():
101     assert msg.sender == self.owner or msg.sender == self.author, "owner only"
102     _owner: address = self.futureOwner
103     assert _owner != ZERO_ADDRESS, "owner not set"
104     self.owner = _owner
105     log ApplyOwnership(_owner)