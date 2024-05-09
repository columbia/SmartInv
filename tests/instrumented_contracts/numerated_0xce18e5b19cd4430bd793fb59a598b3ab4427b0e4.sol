1 # @dev Implementation of ERC-20 token standard.
2 # @author Takayuki Jimba (@yudetamago)
3 # @autho VROOM.bet (@vroom_bet)
4 # https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
5 
6 from vyper.interfaces import ERC20
7 from vyper.interfaces import ERC20Detailed
8 
9 implements: ERC20
10 implements: ERC20Detailed
11 
12 event Transfer:
13   sender: indexed(address)
14   receiver: indexed(address)
15   value: uint256
16 
17 event Approval:
18   owner: indexed(address)
19   spender: indexed(address)
20   value: uint256
21 
22 MAX_RECIPIENTS: constant(uint256) = 100
23 BURN_ADDRESS: constant(address) = 0x000000000000000000000000000000000000dEaD
24 
25 name: public(String[32])
26 symbol: public(String[32])
27 decimals: public(uint8)
28 balanceOf: public(HashMap[address, uint256])
29 allowance: public(HashMap[address, HashMap[address, uint256]])
30 totalSupply: public(uint256)
31 owner: public(address)
32 
33 tradingEnabled: public(bool)
34 ammPairs: public(HashMap[address, bool])
35 
36 buyFees: public(uint256)
37 sellFees: public(uint256)
38 excludedFromFees: public(HashMap[address, bool])
39 
40 maxTxAmount: public(uint256)
41 excludedFromMaxTxAmount: public(HashMap[address, bool])
42 
43 @external
44 def __init__():
45   # token params
46   self.name = "VROOM"
47   self.symbol = "VROOM"
48   self.decimals = 18
49   self.totalSupply = 3_000_000_000 * 10 ** 18
50   self.owner = msg.sender
51 
52   # anti-bots params for launch
53   self.tradingEnabled = False
54   self.buyFees = 30
55   self.sellFees = 30
56   self.maxTxAmount = self.totalSupply / 100
57 
58   # mint all tokens to owner
59   self.balanceOf[msg.sender] = self.totalSupply
60   log Transfer(empty(address), msg.sender, self.totalSupply)
61 
62   # exlude owner from fees and transfer ban
63   self.excludedFromFees[msg.sender] = True
64   self.excludedFromMaxTxAmount[msg.sender] = True
65 
66   # exclude team tokens wallet from bans
67   self.excludedFromFees[0x2e38856eB6F2a0aAF13cE7ce98e34901884c517C] = True
68   self.excludedFromMaxTxAmount[0x2e38856eB6F2a0aAF13cE7ce98e34901884c517C] = True
69 
70 @external
71 def transfer(_to: address, _value: uint256) -> bool:
72   return self._transfer(msg.sender, _to, _value, msg.sender)
73 
74 @external
75 def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
76   assert _value <= self.allowance[_from][msg.sender], "Insufficient allowance"
77   self.allowance[_from][msg.sender] -= _value
78   return self._transfer(_from, _to, _value, msg.sender)
79 
80 @internal
81 def _transfer(_from: address, _to: address, _value: uint256, _sender: address) -> bool:
82   assert _to != empty(address), "Can't transfer to zero address"
83   assert self.balanceOf[_from] >= _value, "Insufficient balance"
84   assert self.tradingEnabled or self.excludedFromMaxTxAmount[_sender] == True, "Trading not enabled"
85 
86   if (self.ammPairs[_from] == True and self.excludedFromMaxTxAmount[_to] == False) or (self.ammPairs[_to] == True and self.excludedFromMaxTxAmount[_from] == False):
87     assert _value <= self.maxTxAmount, "Transfer amount exceeds the maxTxAmount."
88 
89   # first decrease the balance of the sender
90   self.balanceOf[_from] -= _value
91 
92   # calculate if fees applies
93   feesAmount: uint256 = 0
94   if self.ammPairs[_from] == True and self.excludedFromFees[_to] == False:
95     feesAmount = _value * self.buyFees / 100
96   elif self.ammPairs[_to] == True and self.excludedFromFees[_from] == False:
97       feesAmount = _value * self.sellFees / 100
98 
99   # increase the balance of the receiver
100   self.balanceOf[_to] += _value - feesAmount
101   self.balanceOf[BURN_ADDRESS] += feesAmount
102 
103   log Transfer(_from, _to, _value - feesAmount)
104 
105   return True
106 
107 @external
108 def approve(_spender: address, _value: uint256) -> bool:
109   self.allowance[msg.sender][_spender] = _value
110   log Approval(msg.sender, _spender, _value)
111   return True
112 
113 @external
114 def renounceOwnership() -> bool:
115   assert msg.sender == self.owner, "Only owner can renounce ownership"
116   self.owner = empty(address)
117   return True
118 
119 @external
120 def enableTrading() -> bool:
121   assert msg.sender == self.owner, "Only owner can enable trading"
122   self.tradingEnabled = True
123   return True
124 
125 @external
126 def addAMMPair(_pair: address) -> bool:
127   assert msg.sender == self.owner, "Only owner can add AMM pair"
128   assert self.ammPairs[_pair] == False, "AMM pair already added"
129   self.ammPairs[_pair] = True
130   return True
131 
132 @external
133 def updateFees(_buyFees: uint256, _sellFees: uint256) -> bool:
134   assert msg.sender == self.owner, "Only owner can update fees"
135   assert _buyFees <= 100 and _sellFees <= 100, "Fees can't be more than 100%"
136   self.buyFees = _buyFees
137   self.sellFees = _sellFees
138   return True
139 
140 @external
141 def addExcludedFromMaxTxAmount(_address: address) -> bool:
142   assert msg.sender == self.owner, "Only owner can add excluded from fees"
143   assert self.excludedFromMaxTxAmount[_address] == False, "Address already excluded from fees"
144   self.excludedFromMaxTxAmount[_address] = True
145   return True
146 
147 @external
148 def multiTransfer(_recipients: address[MAX_RECIPIENTS], _amounts: uint256[MAX_RECIPIENTS]) -> bool:
149   assert msg.sender == self.owner, "Only owner can multi transfer"
150 
151   totalAmount: uint256 = 0
152   for i in range(MAX_RECIPIENTS):
153     if _recipients[i] == empty(address):
154       break
155     totalAmount += _amounts[i]
156 
157   assert self.balanceOf[msg.sender] >= totalAmount, "Insufficient balance"
158 
159   for i in range(MAX_RECIPIENTS):
160     if _recipients[i] == empty(address):
161       break
162     self._transfer(msg.sender, _recipients[i], _amounts[i], msg.sender)
163 
164   return True