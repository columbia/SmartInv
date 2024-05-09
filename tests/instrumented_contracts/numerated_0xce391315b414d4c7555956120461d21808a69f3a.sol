1 # @version 0.3.3
2 
3 """
4 @title BAO Token
5 @author Curve Finance
6 @license MIT
7 @notice ERC20 with piecewise-linear mining supply.
8 @dev Based on the ERC-20 token standard as defined at
9      https://eips.ethereum.org/EIPS/eip-20
10 """
11 
12 from vyper.interfaces import ERC20
13 
14 implements: ERC20
15 
16 event Transfer:
17     _from: indexed(address)
18     _to: indexed(address)
19     _value: uint256
20 
21 event Approval:
22     _owner: indexed(address)
23     _spender: indexed(address)
24     _value: uint256
25 
26 event UpdateMiningParameters:
27     time: uint256
28     rate: uint256
29     supply: uint256
30 
31 event SetMinter:
32     minter: address
33 
34 event SetAdmin:
35     admin: address
36 
37 name: public(String[32])
38 symbol: public(String[32])
39 decimals: public(uint8)
40 
41 balanceOf: public(HashMap[address, uint256])
42 allowance: public(HashMap[address, HashMap[address, uint256]])
43 totalSupply: public(uint256)
44 
45 minter: public(address)
46 admin: public(address)
47 
48 # General constants
49 YEAR: constant(uint256) = 86400 * 365
50 
51 # Allocation:
52 # =========
53 # * BAO unlocking and migration (Main-net supply + xDAI supply after farms end)
54 # == X% ==
55 # supply left for inflation: Y% || **(X + Y = 100%)**
56 
57 # Supply parameters
58 INITIAL_SUPPLY_CAP: constant(uint256) = 1_091_753_221 # locked supply + circulating at farm ending 1,091,753,220.323429093032914451
59 INITIAL_RATE: constant(uint256) = 230_255_942 * 10 ** 18 / YEAR # ~42% premine
60 RATE_REDUCTION_TIME: constant(uint256) = YEAR
61 RATE_REDUCTION_COEFFICIENT: constant(uint256) = 1189207115002721024  #2 ** (1/4) * 1e18
62 RATE_DENOMINATOR: constant(uint256) = 10 ** 18
63 INFLATION_DELAY: constant(uint256) = 86400
64 
65 # Supply variables
66 mining_epoch: public(int128)
67 start_epoch_time: public(uint256)
68 rate: public(uint256)
69 
70 start_epoch_supply: uint256
71 
72 @external
73 def __init__(_name: String[32], _symbol: String[32], _decimals: uint8):
74     """
75     @notice Contract constructor
76     @param _name Token full name
77     @param _symbol Token symbol
78     @param _decimals Number of decimals for token
79     """
80     init_supply: uint256 = INITIAL_SUPPLY_CAP * 10 ** convert(_decimals, uint256)
81     self.name = _name
82     self.symbol = _symbol
83     self.decimals = _decimals
84     self.balanceOf[msg.sender] = init_supply
85     self.totalSupply = init_supply
86     self.admin = msg.sender
87     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
88 
89     self.start_epoch_time = block.timestamp + INFLATION_DELAY - RATE_REDUCTION_TIME
90     self.mining_epoch = -1
91     self.rate = 0
92     self.start_epoch_supply = init_supply
93 
94 
95 @internal
96 def _update_mining_parameters():
97     """
98     @dev Update mining rate and supply at the start of the epoch
99          Any modifying mining call must also call this
100     """
101     _rate: uint256 = self.rate
102     _start_epoch_supply: uint256 = self.start_epoch_supply
103 
104     self.start_epoch_time += RATE_REDUCTION_TIME
105     self.mining_epoch += 1
106 
107     if _rate == 0:
108         _rate = INITIAL_RATE
109     else:
110         _start_epoch_supply += _rate * RATE_REDUCTION_TIME
111         self.start_epoch_supply = _start_epoch_supply
112         _rate = _rate * RATE_DENOMINATOR / RATE_REDUCTION_COEFFICIENT
113 
114     self.rate = _rate
115 
116     log UpdateMiningParameters(block.timestamp, _rate, _start_epoch_supply)
117 
118 
119 @external
120 def update_mining_parameters():
121     """
122     @notice Update mining rate and supply at the start of the epoch
123     @dev Callable by any address, but only once per epoch
124          Total supply becomes slightly larger if this function is called late
125     """
126     assert block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME  # dev: too soon!
127     self._update_mining_parameters()
128 
129 
130 @external
131 def start_epoch_time_write() -> uint256:
132     """
133     @notice Get timestamp of the current mining epoch start
134             while simultaneously updating mining parameters
135     @return Timestamp of the epoch
136     """
137     _start_epoch_time: uint256 = self.start_epoch_time
138     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
139         self._update_mining_parameters()
140         return self.start_epoch_time
141     else:
142         return _start_epoch_time
143 
144 
145 @external
146 def future_epoch_time_write() -> uint256:
147     """
148     @notice Get timestamp of the next mining epoch start
149             while simultaneously updating mining parameters
150     @return Timestamp of the next epoch
151     """
152     _start_epoch_time: uint256 = self.start_epoch_time
153     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
154         self._update_mining_parameters()
155         return self.start_epoch_time + RATE_REDUCTION_TIME
156     else:
157         return _start_epoch_time + RATE_REDUCTION_TIME
158 
159 
160 @internal
161 @view
162 def _available_supply() -> uint256:
163     return self.start_epoch_supply + (block.timestamp - self.start_epoch_time) * self.rate
164 
165 
166 @external
167 @view
168 def available_supply() -> uint256:
169     """
170     @notice Current number of tokens in existence (claimed or unclaimed)
171     """
172     return self._available_supply()
173 
174 
175 @external
176 @view
177 def mintable_in_timeframe(start: uint256, end: uint256) -> uint256:
178     """
179     @notice How much supply is mintable from start timestamp till end timestamp
180     @param start Start of the time interval (timestamp)
181     @param end End of the time interval (timestamp)
182     @return Tokens mintable from `start` till `end`
183     """
184     assert start <= end  # dev: start > end
185     to_mint: uint256 = 0
186     current_epoch_time: uint256 = self.start_epoch_time
187     current_rate: uint256 = self.rate
188 
189     # Special case if end is in future (not yet minted) epoch
190     if end > current_epoch_time + RATE_REDUCTION_TIME:
191         current_epoch_time += RATE_REDUCTION_TIME
192         current_rate = current_rate * RATE_DENOMINATOR / RATE_REDUCTION_COEFFICIENT
193 
194     assert end <= current_epoch_time + RATE_REDUCTION_TIME  # dev: too far in future
195 
196     for i in range(999):  # will not work in 1000 years. Darn!
197         if end >= current_epoch_time:
198             current_end: uint256 = end
199             if current_end > current_epoch_time + RATE_REDUCTION_TIME:
200                 current_end = current_epoch_time + RATE_REDUCTION_TIME
201 
202             current_start: uint256 = start
203             if current_start >= current_epoch_time + RATE_REDUCTION_TIME:
204                 break  # We should never get here but what if...
205             elif current_start < current_epoch_time:
206                 current_start = current_epoch_time
207 
208             to_mint += current_rate * (current_end - current_start)
209 
210             if start >= current_epoch_time:
211                 break
212 
213         current_epoch_time -= RATE_REDUCTION_TIME
214         current_rate = current_rate * RATE_REDUCTION_COEFFICIENT / RATE_DENOMINATOR  # double-division with rounding made rate a bit less => good
215         assert current_rate <= INITIAL_RATE  # This should never happen
216 
217     return to_mint
218 
219 
220 @external
221 def set_minter(_minter: address):
222     """
223     @notice Set the minter address
224     @dev Only callable once, when the minter contract has not yet been set
225     @param _minter Address of the minter
226     """
227     assert msg.sender == self.admin  # dev: admin only
228     assert self.minter == ZERO_ADDRESS  # dev: can set the minter only once, at creation
229     self.minter = _minter
230     log SetMinter(_minter)
231 
232 
233 @external
234 def set_admin(_admin: address):
235     """
236     @notice Set the new admin.
237     @dev After all is set up, admin only can change the token name
238     @param _admin New admin address
239     """
240     assert msg.sender == self.admin  # dev: admin only
241     self.admin = _admin
242     log SetAdmin(_admin)
243 
244 
245 @external
246 def transfer(_to : address, _value : uint256) -> bool:
247     """
248     @notice Transfer `_value` tokens from `msg.sender` to `_to`
249     @dev Vyper does not allow underflows, so the subtraction in
250          this function will revert on an insufficient balance
251     @param _to The address to transfer to
252     @param _value The amount to be transferred
253     @return bool success
254     """
255     assert _to != ZERO_ADDRESS  # dev: transfers to 0x0 are not allowed
256     self.balanceOf[msg.sender] -= _value
257     self.balanceOf[_to] += _value
258     log Transfer(msg.sender, _to, _value)
259     return True
260 
261 
262 @external
263 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
264     """
265      @notice Transfer `_value` tokens from `_from` to `_to`
266      @param _from address The address which you want to send tokens from
267      @param _to address The address which you want to transfer to
268      @param _value uint256 the amount of tokens to be transferred
269      @return bool success
270     """
271     assert _to != ZERO_ADDRESS  # dev: transfers to 0x0 are not allowed
272     # NOTE: vyper does not allow underflows
273     #       so the following subtraction would revert on insufficient balance
274     self.balanceOf[_from] -= _value
275     self.balanceOf[_to] += _value
276     self.allowance[_from][msg.sender] -= _value
277     log Transfer(_from, _to, _value)
278     return True
279 
280 
281 @external
282 def approve(_spender : address, _value : uint256) -> bool:
283     """
284     @notice Approve `_spender` to transfer `_value` tokens on behalf of `msg.sender`
285     @dev Approval may only be from zero -> nonzero or from nonzero -> zero in order
286         to mitigate the potential race condition described here:
287         https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288     @param _spender The address which will spend the funds
289     @param _value The amount of tokens to be spent
290     @return bool success
291     """
292     assert _value == 0 or self.allowance[msg.sender][_spender] == 0
293     self.allowance[msg.sender][_spender] = _value
294     log Approval(msg.sender, _spender, _value)
295     return True
296 
297 
298 @external
299 def mint(_to: address, _value: uint256) -> bool:
300     """
301     @notice Mint `_value` tokens and assign them to `_to`
302     @dev Emits a Transfer event originating from 0x00
303     @param _to The account that will receive the created tokens
304     @param _value The amount that will be created
305     @return bool success
306     """
307     assert (msg.sender == self.minter)  # dev: minter only
308     assert _to != ZERO_ADDRESS  # dev: zero address
309 
310     if block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME:
311         self._update_mining_parameters()
312 
313     _total_supply: uint256 = self.totalSupply + _value
314     assert _total_supply <= self._available_supply()  # dev: exceeds allowable mint amount
315     self.totalSupply = _total_supply
316 
317     self.balanceOf[_to] += _value
318     log Transfer(ZERO_ADDRESS, _to, _value)
319 
320     return True
321 
322 
323 @external
324 def burn(_value: uint256) -> bool:
325     """
326     @notice Burn `_value` tokens belonging to `msg.sender`
327     @dev Emits a Transfer event with a destination of 0x00
328     @param _value The amount that will be burned
329     @return bool success
330     """
331     self.totalSupply -= _value
332     self.balanceOf[msg.sender] -= _value
333     log Transfer(msg.sender, ZERO_ADDRESS, _value)
334     return True