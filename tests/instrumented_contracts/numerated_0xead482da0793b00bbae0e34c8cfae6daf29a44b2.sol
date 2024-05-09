1 # @version 0.3.1
2 """
3 @title Versailles heroes DAO token
4 @author Versailles heroes
5 @license MIT
6 @notice ERC20 with piecewise-linear mining supply.
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 implements: ERC20
12 
13 event Transfer:
14     sender: indexed(address)
15     receiver: indexed(address)
16     value: uint256
17 
18 event Approval:
19     owner: indexed(address)
20     spender: indexed(address)
21     value: uint256
22 
23 event UpdateMiningParameters:
24     time: uint256
25     rate: uint256
26     supply: uint256
27 
28 event SetMinter:
29     minter: address
30 
31 event SetAdmin:
32     admin: address
33 
34 name: public(String[64])
35 symbol: public(String[32])
36 decimals: public(uint256)
37 
38 balanceOf: public(HashMap[address, uint256])
39 allowance: public(HashMap[address, HashMap[address, uint256]])
40 totalSupply: public(uint256)
41 minter: public(address)
42 admin: public(address)
43 
44 YEAR: constant(uint256) = 86400 * 365
45 INITIAL_SUPPLY: constant(uint256) = 727_200_000
46 INITIAL_RATE: constant(uint256) = 121_587_840 * 10 ** 18 / YEAR
47 RATE_REDUCTION_TIME: constant(uint256) = YEAR
48 RATE_REDUCTION_COEFFICIENT: constant(uint256) = 1189207115002721024  # 2 ** (1/4) * 1e18
49 RATE_DENOMINATOR: constant(uint256) = 10 ** 18
50 INFLATION_DELAY: constant(uint256) = 86400
51 
52 rate: public(uint256)
53 mining_epoch: public(int128)
54 start_epoch_time: public(uint256)
55 start_epoch_supply: uint256
56 
57 @external
58 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256):
59     init_supply: uint256 = INITIAL_SUPPLY * 10 ** _decimals
60     self.name = _name
61     self.symbol = _symbol
62     self.decimals = _decimals
63     self.balanceOf[msg.sender] = init_supply
64     self.totalSupply = init_supply
65     self.admin = msg.sender
66     self.rate = 0
67     self.mining_epoch = -1
68     self.start_epoch_time = block.timestamp + INFLATION_DELAY - RATE_REDUCTION_TIME
69     self.start_epoch_supply = init_supply
70     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
71 
72 
73 @internal
74 def _update_mining_parameters():
75     _rate: uint256 = self.rate
76     _start_epoch_supply: uint256 = self.start_epoch_supply
77 
78     self.start_epoch_time += RATE_REDUCTION_TIME
79     self.mining_epoch += 1
80 
81     if _rate == 0:
82         _rate = INITIAL_RATE
83     else:
84         _start_epoch_supply += _rate * RATE_REDUCTION_TIME
85         self.start_epoch_supply = _start_epoch_supply
86         _rate = _rate * RATE_DENOMINATOR / RATE_REDUCTION_COEFFICIENT
87 
88     self.rate = _rate
89 
90     log UpdateMiningParameters(block.timestamp, _rate, _start_epoch_supply)
91 
92 
93 @external
94 def update_mining_parameters():
95     assert block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME
96     self._update_mining_parameters()
97 
98 
99 @external
100 def start_epoch_time_write() -> uint256:
101     '''
102     @notice Get timestamp of the current mining epoch start while simultaneously updating mining parameters
103     @return Timestamp of the epoch
104     '''
105     _start_epoch_time: uint256 = self.start_epoch_time
106     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
107         self._update_mining_parameters()
108         return self.start_epoch_time
109     else:
110         return _start_epoch_time
111 
112 
113 @external
114 def future_epoch_time_write() -> uint256:
115     '''
116     @notice Get timestamp of the next mining epoch start while simultaneously updating mining parameters
117     @return Timestamp of the next epoch
118     '''
119     _start_epoch_time: uint256 = self.start_epoch_time
120     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
121         self._update_mining_parameters()
122         return self.start_epoch_time + RATE_REDUCTION_TIME
123     else:
124         return _start_epoch_time + RATE_REDUCTION_TIME
125 
126 
127 @internal
128 @view
129 def _available_supply() -> uint256:
130     return self.start_epoch_supply + (block.timestamp - self.start_epoch_time) * self.rate
131 
132 
133 @external
134 @view
135 def available_supply() -> uint256:
136     return self._available_supply()
137 
138 
139 @external
140 def transfer(_to : address, _value : uint256) -> bool:
141     '''
142     @dev Transfer token for a specified address
143     @param _to The address to transfer to.
144     @param _value The amount to be transferred.
145     '''
146     # NOTE: vyper does not allow underflows
147     #       so the following subtraction would revert on insufficient balance
148     self.balanceOf[msg.sender] -= _value
149     self.balanceOf[_to] += _value
150     log Transfer(msg.sender, _to, _value)
151     return True
152 
153 
154 @external
155 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
156     '''
157     @dev Transfer tokens from one address to another.
158     @param _from address The address which you want to send tokens from
159     @param _to address The address which you want to transfer to
160     @param _value uint256 the amount of tokens to be transferred
161     '''
162     # NOTE: vyper does not allow underflows
163     #       so the following subtraction would revert on insufficient balance
164 
165     self.balanceOf[_from] -= _value
166     self.balanceOf[_to] += _value
167     # NOTE: vyper does not allow underflows
168     #      so the following subtraction would revert on insufficient allowance
169     self.allowance[_from][msg.sender] -= _value
170     log Transfer(_from, _to, _value)
171     return True
172 
173 
174 @external
175 def approve(_spender : address, _value : uint256) -> bool:
176     '''
177     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178         #Beware that changing an allowance with this method brings the risk that someone may use both the old
179         #and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180         #race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181         #https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     @param _spender The address which will spend the funds.
183     @param _value The amount of tokens to be spent.
184     '''
185     self.allowance[msg.sender][_spender] = _value
186     log Approval(msg.sender, _spender, _value)
187     return True
188 
189 
190 @external
191 @view
192 def mintable_in_timeframe(start: uint256, end: uint256) -> uint256:
193     """
194     @notice How much supply is mintable from start timestamp till end timestamp
195     @param start Start of the time interval (timestamp)
196     @param end End of the time interval (timestamp)
197     @return Tokens mintable from `start` till `end`
198     """
199     assert start <= end  # dev: start > end
200     to_mint: uint256 = 0
201     current_epoch_time: uint256 = self.start_epoch_time
202     current_rate: uint256 = self.rate
203 
204     # Special case if end is in future (not yet minted) epoch
205     if end > current_epoch_time + RATE_REDUCTION_TIME:
206         current_epoch_time += RATE_REDUCTION_TIME
207         current_rate = current_rate * RATE_DENOMINATOR / RATE_REDUCTION_COEFFICIENT
208 
209     assert end <= current_epoch_time + RATE_REDUCTION_TIME  # dev: too far in future
210 
211     for i in range(999):  # Curve will not work in 1000 years. Darn!
212         if end >= current_epoch_time:
213             current_end: uint256 = end
214             if current_end > current_epoch_time + RATE_REDUCTION_TIME:
215                 current_end = current_epoch_time + RATE_REDUCTION_TIME
216 
217             current_start: uint256 = start
218             if current_start >= current_epoch_time + RATE_REDUCTION_TIME:
219                 break  # We should never get here but what if...
220             elif current_start < current_epoch_time:
221                 current_start = current_epoch_time
222 
223             to_mint += current_rate * (current_end - current_start)
224 
225             if start >= current_epoch_time:
226                 break
227 
228         current_epoch_time -= RATE_REDUCTION_TIME
229         current_rate = current_rate * RATE_REDUCTION_COEFFICIENT / RATE_DENOMINATOR  # double-division with rounding made rate a bit less => good
230         assert current_rate <= INITIAL_RATE  # This should never happen
231 
232     return to_mint
233 
234 
235 @external
236 def set_minter(_minter: address):
237     assert msg.sender == self.admin
238     assert self.minter == ZERO_ADDRESS
239     self.minter = _minter
240     log SetMinter(_minter)
241 
242 
243 @external
244 def set_admin(_admin: address):
245     assert msg.sender == self.admin
246     self.admin = _admin
247     log SetAdmin(_admin)
248 
249 
250 @external
251 def mint(_to: address, _value: uint256) -> bool:
252     '''
253     @dev Mint an amount of the token and assigns it to an account.
254         #This encapsulates the modification of balances such that the
255         #proper events are emitted.
256     @param _to The account that will receive the created tokens.
257     @param _value The amount that will be created.
258     '''
259     assert msg.sender == self.minter
260     assert _to != ZERO_ADDRESS
261 
262     if block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME:
263         self._update_mining_parameters()
264     
265     _total_supply: uint256 = self.totalSupply + _value
266     assert _total_supply <= self._available_supply() # dev: exceeds allowable mint amount
267     self.totalSupply = _total_supply
268 
269     self.balanceOf[_to] += _value
270     log Transfer(ZERO_ADDRESS, _to, _value)
271 
272     return True
273 
274 
275 @internal
276 def _burn(_to: address, _value: uint256):
277     '''
278     @dev Internal function that burns an amount of the token of a given
279         #account.
280     @param _to The account whose tokens will be burned.
281     @param _value The amount that will be burned.
282     '''
283     assert _to != ZERO_ADDRESS
284     self.totalSupply -= _value
285     self.balanceOf[_to] -= _value
286     log Transfer(_to, ZERO_ADDRESS, _value)
287 
288 
289 @external
290 def burn(_value: uint256):
291     '''
292     @dev Burn an amount of the token of msg.sender.
293     @param _value The amount that will be burned.
294     '''
295     self._burn(msg.sender, _value)