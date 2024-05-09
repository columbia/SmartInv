1 # @version 0.3.1
2 """
3 @title Curve DAO Token
4 @author Curve Finance
5 @license MIT
6 @notice ERC20 with piecewise-linear mining supply.
7 @dev Based on the ERC-20 token standard as defined at
8      https://eips.ethereum.org/EIPS/eip-20
9 """
10 
11 # Original idea and credit:
12 # Curve Finance's ERC20CRV
13 # https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/ERC20CRV.vy
14 # This contract is an almost-identical fork of Curve's contract
15 # The initial supply change to 2_350_000
16 # The initial rate change to 0 per second
17 # The rate reduction coefficient change to 1, lead to 0% decay per year
18 
19 from vyper.interfaces import ERC20
20 
21 implements: ERC20
22 
23 
24 event Transfer:
25     _from: indexed(address)
26     _to: indexed(address)
27     _value: uint256
28 
29 event Approval:
30     _owner: indexed(address)
31     _spender: indexed(address)
32     _value: uint256
33 
34 event UpdateMiningParameters:
35     time: uint256
36     rate: uint256
37     supply: uint256
38 
39 event SetMinter:
40     minter: address
41 
42 event SetAdmin:
43     admin: address
44 
45 
46 name: public(String[64])
47 symbol: public(String[32])
48 decimals: public(uint256)
49 
50 balanceOf: public(HashMap[address, uint256])
51 allowances: HashMap[address, HashMap[address, uint256]]
52 total_supply: uint256
53 
54 minter: public(address)
55 admin: public(address)
56 
57 # General constants
58 YEAR: constant(uint256) = 86400 * 365
59 
60 # Allocation:
61 # =========
62 # * Aladdin DAO - 30%
63 # * Treasury - 10%
64 # * CTRributor - 5%
65 # * Airdrop - 1%
66 # * Initial Liquidity - 1%
67 # == 47% ==
68 # left for Liquidity Mining and Vault Mining: 53%
69 # all left token will be minted during IFO
70 
71 # Supply parameters
72 INITIAL_SUPPLY: constant(uint256) = 2_350_000
73 INITIAL_RATE: constant(uint256) = 0
74 RATE_REDUCTION_TIME: constant(uint256) = YEAR
75 RATE_REDUCTION_COEFFICIENT: constant(uint256) = 10 ** 18
76 RATE_DENOMINATOR: constant(uint256) = 10 ** 18
77 INFLATION_DELAY: constant(uint256) = 86400
78 
79 # Supply variables
80 mining_epoch: public(int128)
81 start_epoch_time: public(uint256)
82 rate: public(uint256)
83 
84 start_epoch_supply: uint256
85 
86 
87 @external
88 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256):
89     """
90     @notice Contract constructor
91     @param _name Token full name
92     @param _symbol Token symbol
93     @param _decimals Number of decimals for token
94     """
95     init_supply: uint256 = INITIAL_SUPPLY * 10 ** _decimals
96     self.name = _name
97     self.symbol = _symbol
98     self.decimals = _decimals
99     self.balanceOf[msg.sender] = init_supply
100     self.total_supply = init_supply
101     self.admin = msg.sender
102     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
103 
104     self.start_epoch_time = block.timestamp + INFLATION_DELAY - RATE_REDUCTION_TIME
105     self.mining_epoch = -1
106     self.rate = 0
107     self.start_epoch_supply = init_supply
108 
109 
110 @internal
111 def _update_mining_parameters():
112     """
113     @dev Update mining rate and supply at the start of the epoch
114          Any modifying mining call must also call this
115     """
116     _rate: uint256 = self.rate
117     _start_epoch_supply: uint256 = self.start_epoch_supply
118 
119     self.start_epoch_time += RATE_REDUCTION_TIME
120     self.mining_epoch += 1
121 
122     if _rate == 0:
123         _rate = INITIAL_RATE
124     else:
125         _start_epoch_supply += _rate * RATE_REDUCTION_TIME
126         self.start_epoch_supply = _start_epoch_supply
127         _rate = _rate * RATE_DENOMINATOR / RATE_REDUCTION_COEFFICIENT
128 
129     self.rate = _rate
130 
131     log UpdateMiningParameters(block.timestamp, _rate, _start_epoch_supply)
132 
133 
134 @external
135 def update_mining_parameters():
136     """
137     @notice Update mining rate and supply at the start of the epoch
138     @dev Callable by any address, but only once per epoch
139          Total supply becomes slightly larger if this function is called late
140     """
141     assert block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME  # dev: too soon!
142     self._update_mining_parameters()
143 
144 
145 @external
146 def start_epoch_time_write() -> uint256:
147     """
148     @notice Get timestamp of the current mining epoch start
149             while simultaneously updating mining parameters
150     @return Timestamp of the epoch
151     """
152     _start_epoch_time: uint256 = self.start_epoch_time
153     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
154         self._update_mining_parameters()
155         return self.start_epoch_time
156     else:
157         return _start_epoch_time
158 
159 
160 @external
161 def future_epoch_time_write() -> uint256:
162     """
163     @notice Get timestamp of the next mining epoch start
164             while simultaneously updating mining parameters
165     @return Timestamp of the next epoch
166     """
167     _start_epoch_time: uint256 = self.start_epoch_time
168     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
169         self._update_mining_parameters()
170         return self.start_epoch_time + RATE_REDUCTION_TIME
171     else:
172         return _start_epoch_time + RATE_REDUCTION_TIME
173 
174 
175 @internal
176 @view
177 def _available_supply() -> uint256:
178     # @note changed to make sure we always have 5000000 max supply
179     return 5_000_000 * 10 ** self.decimals
180 
181 
182 @external
183 @view
184 def available_supply() -> uint256:
185     """
186     @notice Current number of tokens in existence (claimed or unclaimed)
187     """
188     return self._available_supply()
189 
190 
191 @external
192 @view
193 def mintable_in_timeframe(start: uint256, end: uint256) -> uint256:
194     """
195     @notice How much supply is mintable from start timestamp till end timestamp
196     @param start Start of the time interval (timestamp)
197     @param end End of the time interval (timestamp)
198     @return Tokens mintable from `start` till `end`
199     """
200     assert start <= end  # dev: start > end
201     to_mint: uint256 = 0
202     current_epoch_time: uint256 = self.start_epoch_time
203     current_rate: uint256 = self.rate
204 
205     # Special case if end is in future (not yet minted) epoch
206     if end > current_epoch_time + RATE_REDUCTION_TIME:
207         current_epoch_time += RATE_REDUCTION_TIME
208         current_rate = current_rate * RATE_DENOMINATOR / RATE_REDUCTION_COEFFICIENT
209 
210     assert end <= current_epoch_time + RATE_REDUCTION_TIME  # dev: too far in future
211 
212     for i in range(999):  # Curve will not work in 1000 years. Darn!
213         if end >= current_epoch_time:
214             current_end: uint256 = end
215             if current_end > current_epoch_time + RATE_REDUCTION_TIME:
216                 current_end = current_epoch_time + RATE_REDUCTION_TIME
217 
218             current_start: uint256 = start
219             if current_start >= current_epoch_time + RATE_REDUCTION_TIME:
220                 break  # We should never get here but what if...
221             elif current_start < current_epoch_time:
222                 current_start = current_epoch_time
223 
224             to_mint += current_rate * (current_end - current_start)
225 
226             if start >= current_epoch_time:
227                 break
228 
229         current_epoch_time -= RATE_REDUCTION_TIME
230         current_rate = current_rate * RATE_REDUCTION_COEFFICIENT / RATE_DENOMINATOR  # double-division with rounding made rate a bit less => good
231         assert current_rate <= INITIAL_RATE  # This should never happen
232 
233     return to_mint
234 
235 
236 @external
237 def set_minter(_minter: address):
238     """
239     @notice Set the minter address
240     @dev Only callable once, when minter has not yet been set
241     @param _minter Address of the minter
242     """
243     assert msg.sender == self.admin  # dev: admin only
244     assert self.minter == ZERO_ADDRESS  # dev: can set the minter only once, at creation
245     self.minter = _minter
246     log SetMinter(_minter)
247 
248 
249 @external
250 def set_admin(_admin: address):
251     """
252     @notice Set the new admin.
253     @dev After all is set up, admin only can change the token name
254     @param _admin New admin address
255     """
256     assert msg.sender == self.admin  # dev: admin only
257     self.admin = _admin
258     log SetAdmin(_admin)
259 
260 
261 @external
262 @view
263 def totalSupply() -> uint256:
264     """
265     @notice Total number of tokens in existence.
266     """
267     return self.total_supply
268 
269 
270 @external
271 @view
272 def allowance(_owner : address, _spender : address) -> uint256:
273     """
274     @notice Check the amount of tokens that an owner allowed to a spender
275     @param _owner The address which owns the funds
276     @param _spender The address which will spend the funds
277     @return uint256 specifying the amount of tokens still available for the spender
278     """
279     return self.allowances[_owner][_spender]
280 
281 
282 @external
283 def transfer(_to : address, _value : uint256) -> bool:
284     """
285     @notice Transfer `_value` tokens from `msg.sender` to `_to`
286     @dev Vyper does not allow underflows, so the subtraction in
287          this function will revert on an insufficient balance
288     @param _to The address to transfer to
289     @param _value The amount to be transferred
290     @return bool success
291     """
292     assert _to != ZERO_ADDRESS  # dev: transfers to 0x0 are not allowed
293     self.balanceOf[msg.sender] -= _value
294     self.balanceOf[_to] += _value
295     log Transfer(msg.sender, _to, _value)
296     return True
297 
298 
299 @external
300 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
301     """
302      @notice Transfer `_value` tokens from `_from` to `_to`
303      @param _from address The address which you want to send tokens from
304      @param _to address The address which you want to transfer to
305      @param _value uint256 the amount of tokens to be transferred
306      @return bool success
307     """
308     assert _to != ZERO_ADDRESS  # dev: transfers to 0x0 are not allowed
309     # NOTE: vyper does not allow underflows
310     #       so the following subtraction would revert on insufficient balance
311     self.balanceOf[_from] -= _value
312     self.balanceOf[_to] += _value
313     self.allowances[_from][msg.sender] -= _value
314     log Transfer(_from, _to, _value)
315     return True
316 
317 
318 @external
319 def approve(_spender : address, _value : uint256) -> bool:
320     """
321     @notice Approve `_spender` to transfer `_value` tokens on behalf of `msg.sender`
322     @dev Approval may only be from zero -> nonzero or from nonzero -> zero in order
323         to mitigate the potential race condition described here:
324         https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
325     @param _spender The address which will spend the funds
326     @param _value The amount of tokens to be spent
327     @return bool success
328     """
329     assert _value == 0 or self.allowances[msg.sender][_spender] == 0
330     self.allowances[msg.sender][_spender] = _value
331     log Approval(msg.sender, _spender, _value)
332     return True
333 
334 
335 @external
336 def mint(_to: address, _value: uint256) -> bool:
337     """
338     @notice Mint `_value` tokens and assign them to `_to`
339     @dev Emits a Transfer event originating from 0x00
340     @param _to The account that will receive the created tokens
341     @param _value The amount that will be created
342     @return bool success
343     """
344     assert msg.sender == self.minter  # dev: minter only
345     assert _to != ZERO_ADDRESS  # dev: zero address
346 
347     if block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME:
348        self._update_mining_parameters()
349 
350     _total_supply: uint256 = self.total_supply + _value
351     assert _total_supply <= self._available_supply()  # dev: exceeds allowable mint amount
352     self.total_supply = _total_supply
353 
354     self.balanceOf[_to] += _value
355     log Transfer(ZERO_ADDRESS, _to, _value)
356 
357     return True
358 
359 
360 @external
361 def burn(_value: uint256) -> bool:
362     """
363     @notice Burn `_value` tokens belonging to `msg.sender`
364     @dev Emits a Transfer event with a destination of 0x00
365     @param _value The amount that will be burned
366     @return bool success
367     """
368     self.balanceOf[msg.sender] -= _value
369     self.total_supply -= _value
370 
371     log Transfer(msg.sender, ZERO_ADDRESS, _value)
372     return True
373 
374 
375 @external
376 def set_name(_name: String[64], _symbol: String[32]):
377     """
378     @notice Change the token name and symbol to `_name` and `_symbol`
379     @dev Only callable by the admin account
380     @param _name New token name
381     @param _symbol New token symbol
382     """
383     assert msg.sender == self.admin, "Only admin is allowed to change name"
384     self.name = _name
385     self.symbol = _symbol