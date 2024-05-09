1 # Created by interfinex.io
2 # - The Greeks
3 
4 from vyper.interfaces import ERC20
5 
6 event Transfer:
7     sender: indexed(address)
8     receiver: indexed(address)
9     value: uint256
10 
11 event Approval:
12     owner: indexed(address)
13     spender: indexed(address)
14     value: uint256
15 
16 event ClaimDividends:
17     to: indexed(address)
18     value: uint256
19     totalDividends: uint256
20 
21 event DistributeDividends:
22     sender: indexed(address)
23     value: uint256
24     totalDividends: uint256
25 
26 name: public(String[64])
27 symbol: public(String[32])
28 decimals: public(uint256)
29 totalDividends: public(uint256)
30 totalClaimedTokenDividends: public(uint256)
31 totalTokenDividends: public(uint256)
32 dividend_token: public(address)
33 withdraw_address: public(address)
34 
35 balanceOf: public(HashMap[address, uint256])
36 allowances: HashMap[address, HashMap[address, uint256]]
37 total_supply: public(uint256)
38 minter: public(address)
39 mintable: public(bool)
40 
41 POINT_MULTIPLIER: constant(uint256) = 10 ** 24
42 
43 lastDividends: public(HashMap[address, uint256])
44 
45 @external
46 def initializeERC20(
47     _name: String[64], 
48     _symbol: String[32], 
49     _decimals: uint256, 
50     _supply: uint256, 
51     _dividend_token: address,
52     _mintable: bool
53 ):
54     assert self.minter == ZERO_ADDRESS, "Cannot initialize contract more than once"
55     init_supply: uint256 = _supply * 10 ** _decimals
56     self.name = _name
57     self.symbol = _symbol
58     self.decimals = _decimals
59     self.balanceOf[msg.sender] = init_supply
60     self.total_supply = init_supply
61     self.minter = msg.sender
62     self.mintable = _mintable
63     self.dividend_token = _dividend_token
64     ERC20(self.dividend_token).approve(self, MAX_UINT256)
65     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
66 
67 @view
68 @external
69 def totalSupply() -> uint256:
70     """
71     @dev Total number of tokens in existence.
72     """
73     return self.total_supply
74 
75 @view
76 @external
77 def allowance(_owner : address, _spender : address) -> uint256:
78     """
79     @dev Function to check the amount of tokens that an owner allowed to a spender.
80     @param _owner The address which owns the funds.
81     @param _spender The address which will spend the funds.
82     @return An uint256 specifying the amount of tokens still available for the spender.
83     """
84     return self.allowances[_owner][_spender]
85 
86 @view
87 @internal
88 def _dividendsOf(_owner: address) -> uint256:
89     return (self.totalDividends - self.lastDividends[_owner]) * self.balanceOf[_owner] / POINT_MULTIPLIER
90 
91 @internal
92 def _distributeDividends(_from: address, _value: uint256):
93     if _value == 0:
94         return
95     ERC20(self.dividend_token).transferFrom(_from, self, _value)
96     # Ignore whatever the contract balance is because the contract can't claim dividends
97     self.totalDividends += _value * POINT_MULTIPLIER / (self.total_supply - self.balanceOf[self])
98     self.totalTokenDividends += _value
99     log DistributeDividends(_from, _value, self.totalDividends)
100 
101 @external
102 def distributeDividends(_value: uint256):
103     self._distributeDividends(msg.sender, _value)
104 
105 @internal
106 def _distributeExcessBalance():
107     """
108     @dev    Withdraw excess tokens in the contract. It's possible that excess tokens, 
109             via dividends or some other means, will accrue in the contract. This provides
110             an escape hatch for those funds.
111     """
112     excess_balance: uint256 = ERC20(self.dividend_token).balanceOf(self) - (self.totalTokenDividends - self.totalClaimedTokenDividends)
113     self._distributeDividends(self, excess_balance)
114 
115 @external
116 def distributeExcessBalance():
117     self._distributeExcessBalance()
118 
119 @view
120 @external
121 def getExcessBalance() -> uint256:
122     return ERC20(self.dividend_token).balanceOf(self) - (self.totalTokenDividends - self.totalClaimedTokenDividends)
123     
124 @view
125 @external
126 def dividendsOf(_owner: address) -> uint256:
127     return self._dividendsOf(_owner)
128 
129 @internal
130 def _claimDividends(_to: address):
131     if _to == self:
132         return
133     dividends: uint256 = self._dividendsOf(_to)
134     self.lastDividends[_to] = self.totalDividends   
135     if dividends != 0:
136         ERC20(self.dividend_token).transfer(_to, dividends)
137         self.totalClaimedTokenDividends += dividends
138         log ClaimDividends(_to, dividends, self.totalDividends)
139 
140 @external
141 def claimDividends():
142     self._claimDividends(msg.sender)
143 
144 @external
145 def transfer(_to : address, _value : uint256) -> bool:
146     """
147     @dev Transfer token for a specified address
148     @param _to The address to transfer to.
149     @param _value The amount to be transferred.
150     """
151     self._claimDividends(msg.sender)
152     self._claimDividends(_to)
153     self.balanceOf[msg.sender] -= _value
154     self.balanceOf[_to] += _value
155     log Transfer(msg.sender, _to, _value)
156     return True
157 
158 @external
159 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
160     """
161      @dev Transfer tokens from one address to another.
162      @param _from address The address which you want to send tokens from
163      @param _to address The address which you want to transfer to
164      @param _value uint256 the amount of tokens to be transferred
165     """
166     self._claimDividends(_from)
167     self._claimDividends(_to)
168     self.balanceOf[_from] -= _value
169     self.balanceOf[_to] += _value
170     self.allowances[_from][msg.sender] -= _value
171     log Transfer(_from, _to, _value)
172     return True
173 
174 @external
175 def approve(_spender : address, _value : uint256) -> bool:
176     """
177     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178          Beware that changing an allowance with this method brings the risk that someone may use both the old
179          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     @param _spender The address which will spend the funds.
183     @param _value The amount of tokens to be spent.
184     """
185     self.allowances[msg.sender][_spender] = _value
186     log Approval(msg.sender, _spender, _value)
187     return True
188 
189 @external
190 def mint(_to: address, _value: uint256):
191     """
192     @dev Mint an amount of the token and assigns it to an account.
193          This encapsulates the modification of balances such that the
194          proper events are emitted.
195     @param _to The account that will receive the created tokens.
196     @param _value The amount that will be created.
197     """
198     assert self.mintable == True
199     assert msg.sender == self.minter
200     assert _to != ZERO_ADDRESS
201     self._claimDividends(_to)
202     self.total_supply += _value
203     self.balanceOf[_to] += _value
204     log Transfer(ZERO_ADDRESS, _to, _value)
205 
206 
207 @internal
208 def _burn(_to: address, _value: uint256):
209     """
210     @dev Internal function that burns an amount of the token of a given
211          account.
212     @param _to The account whose tokens will be burned.
213     @param _value The amount that will be burned.
214     """
215     assert _to != ZERO_ADDRESS
216     self._claimDividends(_to)
217     self.total_supply -= _value
218     self.balanceOf[_to] -= _value
219     log Transfer(_to, ZERO_ADDRESS, _value)
220 
221 
222 @external
223 def burn(_value: uint256):
224     """
225     @dev Burn an amount of the token of msg.sender.
226     @param _value The amount that will be burned.
227     """
228     self._claimDividends(msg.sender)
229     self._burn(msg.sender, _value)
230 
231 
232 @external
233 def burnFrom(_to: address, _value: uint256):
234     """
235     @dev Burn an amount of the token from a given account.
236     @param _to The account whose tokens will be burned.
237     @param _value The amount that will be burned.
238     """
239     self._claimDividends(msg.sender)
240     self.allowances[_to][msg.sender] -= _value
241     self._burn(_to, _value)