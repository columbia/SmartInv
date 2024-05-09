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
15 # The initial supply change to 1_035_000
16 # The initial rate change to 0.003059994926433282 per second
17 # The rate reduction coefficient change to 1/0.9 * 1e18, lead to 10% decay per year
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
62 # * Community Contributors - 4%
63 # * Reserve - 5%
64 # * IDO - 5%
65 # * Airdrop - 5%
66 # * Aladdin DAO - 30%
67 # * Initial Liquidity - 1%
68 # * Beta Bonus - 0.25%
69 # * Stragetic Partnerships - 0.75%
70 # * StakeDAO Partnership - 0.75%
71 # == 51.75% ==
72 # left for inflation: 48.25%
73 
74 # Supply parameters
75 INITIAL_SUPPLY: constant(uint256) = 1_035_000
76 INITIAL_RATE: constant(uint256) = 96_500 * 10 ** 18 / YEAR
77 RATE_REDUCTION_TIME: constant(uint256) = YEAR
78 RATE_REDUCTION_COEFFICIENT: constant(uint256) = 1111111111111111111  # 1/0.9 * 1e18
79 RATE_DENOMINATOR: constant(uint256) = 10 ** 18
80 INFLATION_DELAY: constant(uint256) = 86400
81 
82 # Supply variables
83 mining_epoch: public(int128)
84 start_epoch_time: public(uint256)
85 rate: public(uint256)
86 
87 start_epoch_supply: uint256
88 
89 
90 @external
91 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256):
92     """
93     @notice Contract constructor
94     @param _name Token full name
95     @param _symbol Token symbol
96     @param _decimals Number of decimals for token
97     """
98     init_supply: uint256 = INITIAL_SUPPLY * 10 ** _decimals
99     self.name = _name
100     self.symbol = _symbol
101     self.decimals = _decimals
102     self.balanceOf[msg.sender] = init_supply
103     self.total_supply = init_supply
104     self.admin = msg.sender
105     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
106 
107     self.start_epoch_time = block.timestamp + INFLATION_DELAY - RATE_REDUCTION_TIME
108     self.mining_epoch = -1
109     self.rate = 0
110     self.start_epoch_supply = init_supply
111 
112 
113 @internal
114 def _update_mining_parameters():
115     """
116     @dev Update mining rate and supply at the start of the epoch
117          Any modifying mining call must also call this
118     """
119     _rate: uint256 = self.rate
120     _start_epoch_supply: uint256 = self.start_epoch_supply
121 
122     self.start_epoch_time += RATE_REDUCTION_TIME
123     self.mining_epoch += 1
124 
125     if _rate == 0:
126         _rate = INITIAL_RATE
127     else:
128         _start_epoch_supply += _rate * RATE_REDUCTION_TIME
129         self.start_epoch_supply = _start_epoch_supply
130         _rate = _rate * RATE_DENOMINATOR / RATE_REDUCTION_COEFFICIENT
131 
132     self.rate = _rate
133 
134     log UpdateMiningParameters(block.timestamp, _rate, _start_epoch_supply)
135 
136 
137 @external
138 def update_mining_parameters():
139     """
140     @notice Update mining rate and supply at the start of the epoch
141     @dev Callable by any address, but only once per epoch
142          Total supply becomes slightly larger if this function is called late
143     """
144     assert block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME  # dev: too soon!
145     self._update_mining_parameters()
146 
147 
148 @external
149 def start_epoch_time_write() -> uint256:
150     """
151     @notice Get timestamp of the current mining epoch start
152             while simultaneously updating mining parameters
153     @return Timestamp of the epoch
154     """
155     _start_epoch_time: uint256 = self.start_epoch_time
156     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
157         self._update_mining_parameters()
158         return self.start_epoch_time
159     else:
160         return _start_epoch_time
161 
162 
163 @external
164 def future_epoch_time_write() -> uint256:
165     """
166     @notice Get timestamp of the next mining epoch start
167             while simultaneously updating mining parameters
168     @return Timestamp of the next epoch
169     """
170     _start_epoch_time: uint256 = self.start_epoch_time
171     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
172         self._update_mining_parameters()
173         return self.start_epoch_time + RATE_REDUCTION_TIME
174     else:
175         return _start_epoch_time + RATE_REDUCTION_TIME
176 
177 
178 @internal
179 @view
180 def _available_supply() -> uint256:
181     return self.start_epoch_supply + (block.timestamp - self.start_epoch_time) * self.rate
182 
183 
184 @external
185 @view
186 def available_supply() -> uint256:
187     """
188     @notice Current number of tokens in existence (claimed or unclaimed)
189     """
190     return self._available_supply()
191 
192 
193 @external
194 @view
195 def mintable_in_timeframe(start: uint256, end: uint256) -> uint256:
196     """
197     @notice How much supply is mintable from start timestamp till end timestamp
198     @param start Start of the time interval (timestamp)
199     @param end End of the time interval (timestamp)
200     @return Tokens mintable from `start` till `end`
201     """
202     assert start <= end  # dev: start > end
203     to_mint: uint256 = 0
204     current_epoch_time: uint256 = self.start_epoch_time
205     current_rate: uint256 = self.rate
206 
207     # Special case if end is in future (not yet minted) epoch
208     if end > current_epoch_time + RATE_REDUCTION_TIME:
209         current_epoch_time += RATE_REDUCTION_TIME
210         current_rate = current_rate * RATE_DENOMINATOR / RATE_REDUCTION_COEFFICIENT
211 
212     assert end <= current_epoch_time + RATE_REDUCTION_TIME  # dev: too far in future
213 
214     for i in range(999):  # Curve will not work in 1000 years. Darn!
215         if end >= current_epoch_time:
216             current_end: uint256 = end
217             if current_end > current_epoch_time + RATE_REDUCTION_TIME:
218                 current_end = current_epoch_time + RATE_REDUCTION_TIME
219 
220             current_start: uint256 = start
221             if current_start >= current_epoch_time + RATE_REDUCTION_TIME:
222                 break  # We should never get here but what if...
223             elif current_start < current_epoch_time:
224                 current_start = current_epoch_time
225 
226             to_mint += current_rate * (current_end - current_start)
227 
228             if start >= current_epoch_time:
229                 break
230 
231         current_epoch_time -= RATE_REDUCTION_TIME
232         current_rate = current_rate * RATE_REDUCTION_COEFFICIENT / RATE_DENOMINATOR  # double-division with rounding made rate a bit less => good
233         assert current_rate <= INITIAL_RATE  # This should never happen
234 
235     return to_mint
236 
237 
238 @external
239 def set_minter(_minter: address):
240     """
241     @notice Set the minter address
242     @dev Only callable once, when minter has not yet been set
243     @param _minter Address of the minter
244     """
245     assert msg.sender == self.admin  # dev: admin only
246     assert self.minter == ZERO_ADDRESS  # dev: can set the minter only once, at creation
247     self.minter = _minter
248     log SetMinter(_minter)
249 
250 
251 @external
252 def set_admin(_admin: address):
253     """
254     @notice Set the new admin.
255     @dev After all is set up, admin only can change the token name
256     @param _admin New admin address
257     """
258     assert msg.sender == self.admin  # dev: admin only
259     self.admin = _admin
260     log SetAdmin(_admin)
261 
262 
263 @external
264 @view
265 def totalSupply() -> uint256:
266     """
267     @notice Total number of tokens in existence.
268     """
269     return self.total_supply
270 
271 
272 @external
273 @view
274 def allowance(_owner : address, _spender : address) -> uint256:
275     """
276     @notice Check the amount of tokens that an owner allowed to a spender
277     @param _owner The address which owns the funds
278     @param _spender The address which will spend the funds
279     @return uint256 specifying the amount of tokens still available for the spender
280     """
281     return self.allowances[_owner][_spender]
282 
283 
284 @external
285 def transfer(_to : address, _value : uint256) -> bool:
286     """
287     @notice Transfer `_value` tokens from `msg.sender` to `_to`
288     @dev Vyper does not allow underflows, so the subtraction in
289          this function will revert on an insufficient balance
290     @param _to The address to transfer to
291     @param _value The amount to be transferred
292     @return bool success
293     """
294     assert _to != ZERO_ADDRESS  # dev: transfers to 0x0 are not allowed
295     self.balanceOf[msg.sender] -= _value
296     self.balanceOf[_to] += _value
297     log Transfer(msg.sender, _to, _value)
298     return True
299 
300 
301 @external
302 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
303     """
304      @notice Transfer `_value` tokens from `_from` to `_to`
305      @param _from address The address which you want to send tokens from
306      @param _to address The address which you want to transfer to
307      @param _value uint256 the amount of tokens to be transferred
308      @return bool success
309     """
310     assert _to != ZERO_ADDRESS  # dev: transfers to 0x0 are not allowed
311     # NOTE: vyper does not allow underflows
312     #       so the following subtraction would revert on insufficient balance
313     self.balanceOf[_from] -= _value
314     self.balanceOf[_to] += _value
315     self.allowances[_from][msg.sender] -= _value
316     log Transfer(_from, _to, _value)
317     return True
318 
319 
320 @external
321 def approve(_spender : address, _value : uint256) -> bool:
322     """
323     @notice Approve `_spender` to transfer `_value` tokens on behalf of `msg.sender`
324     @dev Approval may only be from zero -> nonzero or from nonzero -> zero in order
325         to mitigate the potential race condition described here:
326         https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
327     @param _spender The address which will spend the funds
328     @param _value The amount of tokens to be spent
329     @return bool success
330     """
331     assert _value == 0 or self.allowances[msg.sender][_spender] == 0
332     self.allowances[msg.sender][_spender] = _value
333     log Approval(msg.sender, _spender, _value)
334     return True
335 
336 
337 @external
338 def mint(_to: address, _value: uint256) -> bool:
339     """
340     @notice Mint `_value` tokens and assign them to `_to`
341     @dev Emits a Transfer event originating from 0x00
342     @param _to The account that will receive the created tokens
343     @param _value The amount that will be created
344     @return bool success
345     """
346     assert msg.sender == self.minter  # dev: minter only
347     assert _to != ZERO_ADDRESS  # dev: zero address
348 
349     if block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME:
350         self._update_mining_parameters()
351 
352     _total_supply: uint256 = self.total_supply + _value
353     assert _total_supply <= self._available_supply()  # dev: exceeds allowable mint amount
354     self.total_supply = _total_supply
355 
356     self.balanceOf[_to] += _value
357     log Transfer(ZERO_ADDRESS, _to, _value)
358 
359     return True
360 
361 
362 @external
363 def burn(_value: uint256) -> bool:
364     """
365     @notice Burn `_value` tokens belonging to `msg.sender`
366     @dev Emits a Transfer event with a destination of 0x00
367     @param _value The amount that will be burned
368     @return bool success
369     """
370     self.balanceOf[msg.sender] -= _value
371     self.total_supply -= _value
372 
373     log Transfer(msg.sender, ZERO_ADDRESS, _value)
374     return True
375 
376 
377 @external
378 def set_name(_name: String[64], _symbol: String[32]):
379     """
380     @notice Change the token name and symbol to `_name` and `_symbol`
381     @dev Only callable by the admin account
382     @param _name New token name
383     @param _symbol New token symbol
384     """
385     assert msg.sender == self.admin, "Only admin is allowed to change name"
386     self.name = _name
387     self.symbol = _symbol