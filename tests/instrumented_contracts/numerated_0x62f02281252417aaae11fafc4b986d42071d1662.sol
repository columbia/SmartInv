1 #
2 # Galore - A token made for traders.
3 #
4 # Galore has rules based on turns
5 # Galore burns, mints, aidrops and keeps a supply
6 # range between 100,000 GAL and 10,000 GAL
7 #
8 # Find out more about Galore @ https://galore.defilabs.eth.link
9 #
10 # A TOKEN TESTED BY DEFI LABS @ HTTPS://DEFILABS.ETH.LINK
11 # CREATOR: Dr. Mantis
12 #
13 # Telegram @ https://t.me/defilabs_community & @dr_mantis_defilabs
14 
15 from vyper.interfaces import ERC20
16 
17 implements: ERC20
18 
19 event Transfer:
20     sender: indexed(address)
21     receiver: indexed(address)
22     value: uint256
23 
24 event Approval:
25     owner: indexed(address)
26     spender: indexed(address)
27     value: uint256
28 
29 owner: public(address)
30 airdrop_address: public(address)
31 name: public(String[64])
32 symbol: public(String[32])
33 decimals: public(uint256)
34 max_supply: public(uint256)
35 min_supply: public(uint256)
36 balanceOf: public(HashMap[address, uint256])
37 isBurning: public(bool)
38 allowances: HashMap[address, HashMap[address, uint256]]
39 total_supply: public(uint256)
40 turn: public(uint256)
41 tx_n: public(uint256)
42 inc_z: public(uint256)
43 mint_pct: public(decimal)
44 burn_pct: public(decimal)
45 airdrop_pct: public(decimal)
46 treasury_pct: public(decimal)
47 airdropQualifiedAddresses: public(address[200])
48 airdropAddressCount: public(uint256)
49 
50 @external
51 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256, _min_supply: uint256, _max_supply: uint256):
52     init_supply: uint256 = _supply * 10 ** _decimals
53     self.owner = msg.sender
54     self.airdrop_address = msg.sender
55     self.name = _name
56     self.symbol = _symbol
57     self.decimals = _decimals
58     self.balanceOf[msg.sender] = init_supply
59     self.total_supply = init_supply
60     self.min_supply = _min_supply * 10 ** _decimals
61     self.max_supply = _max_supply * 10 ** _decimals
62     self.turn = 0
63     self.isBurning = True
64     self.tx_n = 0
65     self.inc_z = 10000
66     self.mint_pct = 0.0125
67     self.burn_pct = 0.0125
68     self.airdrop_pct = 0.0085
69     self.treasury_pct = 0.0050
70     self.airdropAddressCount = 0
71     self.airdropQualifiedAddresses[0] = self.airdrop_address
72     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
73 
74 @view
75 @external
76 def totalSupply() -> uint256:
77     return self.total_supply
78 
79 @view
80 @external
81 def allowance(_owner : address, _spender : address) -> uint256:
82     return self.allowances[_owner][_spender]
83 
84 @internal
85 def _rateadj():
86     if self.isBurning == True:
87         self.burn_pct += 0.00125
88         self.mint_pct += 0.00125
89         self.airdrop_pct += 0.00085
90         self.treasury_pct += 0.00050
91     else:
92         self.burn_pct -= 0.00100
93         self.mint_pct -= 0.00100
94         self.airdrop_pct -= 0.00068
95         self.treasury_pct -= 0.00040
96     if self.burn_pct > 0.2 or self.mint_pct > 0.2:
97         self.mint_pct -= 0.005
98         self.burn_pct -= 0.005
99         self.airdrop_pct -= 0.006
100         self.treasury_pct -= 0.0038
101     if self.burn_pct < 0.01 or self.mint_pct < 0.01 or self.airdrop_pct < 0.0017 or self.treasury_pct < 0.001:
102         self.mint_pct = 0.0125
103         self.burn_pct = 0.0125
104         self.airdrop_pct = 0.0085
105         self.treasury_pct = 0.0050
106     else:
107         pass
108 
109 @external
110 def setAirdropAddress(_airdropAddress: address):
111     assert msg.sender != ZERO_ADDRESS
112     assert _airdropAddress != ZERO_ADDRESS
113     assert msg.sender == self.owner
114     assert msg.sender == self.airdrop_address
115     self.airdrop_address = _airdropAddress
116 
117 @internal
118 def _minsupplyadj():
119     if self.turn == 3:
120         self.min_supply = 1000 * 10 ** self.decimals
121     elif self.turn == 5:
122         self.min_supply = 10000 * 10 ** self.decimals
123     elif self.turn == 7:
124         self.min_supply = 10 * 10 ** self.decimals
125     elif self.turn == 9:
126         self.min_supply = 10000 * 10 ** self.decimals
127 
128 @internal
129 def _airdrop():
130     split_calc: decimal = convert(self.balanceOf[self.airdrop_address] / 250, decimal)
131     split: uint256 = convert(split_calc, uint256)
132     self.airdropAddressCount = 0
133     for x in self.airdropQualifiedAddresses:
134         self.balanceOf[self.airdrop_address] -= split
135         self.balanceOf[x] += split
136         log Transfer(self.airdrop_address, x, split)
137 
138 @internal
139 def _mint(_to: address, _value: uint256):
140     assert _to != ZERO_ADDRESS, "Invalid Address."
141     self.total_supply += _value
142     self.balanceOf[_to] += _value
143     log Transfer(ZERO_ADDRESS, _to, _value)
144 
145 @internal
146 def _turn():
147     self.turn += 1
148     self._rateadj()
149     self._minsupplyadj()
150 
151 @internal
152 def _burn(_to: address, _value: uint256):
153     assert _to != ZERO_ADDRESS, "Invalid Address."
154     self.total_supply -= _value
155     self.balanceOf[_to] -= _value
156     log Transfer(_to, ZERO_ADDRESS, _value)
157 
158 @external
159 def transfer(_to : address, _value : uint256) -> bool:
160     assert _to != ZERO_ADDRESS, "Invalid Address"
161     if self.total_supply >= self.max_supply:
162         self._turn()
163         self.isBurning = True
164     elif self.total_supply <= self.min_supply:
165         self._turn()
166         self.isBurning = False
167     if self.airdropAddressCount == 0:
168         self._rateadj()
169     if self.isBurning == True and (self.turn % 2) != 0:
170         val: decimal = convert(_value, decimal)
171         burn_amt: uint256 = convert(val * self.burn_pct, uint256)
172         airdrop_amt: uint256 = convert(val * self.airdrop_pct, uint256)
173         treasury_amt: uint256 = convert(val * self.treasury_pct, uint256)
174         tx_amt: uint256 = _value - burn_amt - airdrop_amt - treasury_amt
175         self._burn(msg.sender, burn_amt)
176         self.balanceOf[msg.sender] -= tx_amt
177         self.balanceOf[_to] += tx_amt
178         log Transfer(msg.sender, _to, tx_amt)
179         self.balanceOf[msg.sender] -= treasury_amt
180         self.balanceOf[self.owner] += treasury_amt
181         log Transfer(msg.sender, self.owner, treasury_amt)
182         self.balanceOf[msg.sender] -= airdrop_amt
183         self.balanceOf[self.airdrop_address] += airdrop_amt
184         log Transfer(msg.sender, self.airdrop_address, airdrop_amt)
185         self.tx_n += 1
186         self.airdropAddressCount += 1
187         if self.airdropAddressCount < 199:
188             self.airdropQualifiedAddresses[self.airdropAddressCount] = msg.sender
189         elif self.airdropAddressCount == 199:
190             self.airdropQualifiedAddresses[self.airdropAddressCount] = msg.sender
191             self._airdrop()
192     
193     elif self.isBurning == False and (self.turn % 2) == 0:
194         val: decimal = convert(_value, decimal)
195         mint_amt: uint256 = convert(val * self.mint_pct, uint256)
196         airdrop_amt: uint256 = convert(val * self.airdrop_pct, uint256)
197         treasury_amt: uint256 = convert(val * self.treasury_pct, uint256)
198         tx_amt: uint256 = _value - airdrop_amt - treasury_amt
199         self._mint(msg.sender, mint_amt)
200         self.balanceOf[msg.sender] -= tx_amt
201         self.balanceOf[_to] += tx_amt
202         log Transfer(msg.sender, _to, tx_amt)
203         self.balanceOf[msg.sender] -= treasury_amt
204         self.balanceOf[self.owner] += treasury_amt
205         log Transfer(msg.sender, self.owner, treasury_amt)
206         self.balanceOf[msg.sender] -= airdrop_amt
207         self.balanceOf[self.airdrop_address] += airdrop_amt
208         log Transfer(msg.sender, self.airdrop_address, airdrop_amt)
209         self.tx_n += 1
210         self.airdropAddressCount += 1
211         if self.airdropAddressCount < 199:
212             self.airdropQualifiedAddresses[self.airdropAddressCount] = msg.sender
213         elif self.airdropAddressCount == 199:
214             self.airdropQualifiedAddresses[self.airdropAddressCount] = msg.sender
215             self._airdrop()
216     else:
217         raise "Error at TX Block"
218     return True
219 
220 @external
221 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
222     self.balanceOf[_from] -= _value
223     self.balanceOf[_to] += _value
224     self.allowances[_from][msg.sender] -= _value
225     log Transfer(_from, _to, _value)
226     return True
227 
228 @external
229 def approve(_spender : address, _value : uint256) -> bool:
230     self.allowances[msg.sender][_spender] = _value
231     log Approval(msg.sender, _spender, _value)
232     return True