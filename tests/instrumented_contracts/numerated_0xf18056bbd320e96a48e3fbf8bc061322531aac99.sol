1 # @version 0.3.1
2 """
3 @title Curve Factory
4 @license MIT
5 @author Curve.Fi
6 @notice Permissionless pool deployer and registry
7 """
8 
9 
10 interface CryptoPool:
11     def balances(i: uint256) -> uint256: view
12     def initialize(
13         A: uint256,
14         gamma: uint256,
15         mid_fee: uint256,
16         out_fee: uint256,
17         allowed_extra_profit: uint256,
18         fee_gamma: uint256,
19         adjustment_step: uint256,
20         admin_fee: uint256,
21         ma_half_time: uint256,
22         initial_price: uint256,
23         _token: address,
24         _coins: address[2],
25         _precisions: uint256
26     ): nonpayable
27 
28 interface ERC20:
29     def decimals() -> uint256: view
30 
31 interface LiquidityGauge:
32     def initialize(_lp_token: address): nonpayable
33 
34 interface Token:
35     def initialize(_name: String[64], _symbol: String[32], _pool: address): nonpayable
36 
37 
38 event CryptoPoolDeployed:
39     token: address
40     coins: address[2]
41     A: uint256
42     gamma: uint256
43     mid_fee: uint256
44     out_fee: uint256
45     allowed_extra_profit: uint256
46     fee_gamma: uint256
47     adjustment_step: uint256
48     admin_fee: uint256
49     ma_half_time: uint256
50     initial_price: uint256
51     deployer: address
52 
53 event LiquidityGaugeDeployed:
54     pool: address
55     token: address
56     gauge: address
57 
58 event UpdateFeeReceiver:
59     _old_fee_receiver: address
60     _new_fee_receiver: address
61 
62 event UpdatePoolImplementation:
63     _old_pool_implementation: address
64     _new_pool_implementation: address
65 
66 event UpdateTokenImplementation:
67     _old_token_implementation: address
68     _new_token_implementation: address
69 
70 event UpdateGaugeImplementation:
71     _old_gauge_implementation: address
72     _new_gauge_implementation: address
73 
74 event TransferOwnership:
75     _old_owner: address
76     _new_owner: address
77 
78 
79 struct PoolArray:
80     token: address
81     liquidity_gauge: address
82     coins: address[2]
83     decimals: uint256
84 
85 
86 N_COINS: constant(int128) = 2
87 A_MULTIPLIER: constant(uint256) = 10000
88 
89 # Limits
90 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
91 MIN_FEE: constant(uint256) = 5 * 10 ** 5  # 0.5 bps
92 MAX_FEE: constant(uint256) = 10 * 10 ** 9
93 
94 MIN_GAMMA: constant(uint256) = 10 ** 10
95 MAX_GAMMA: constant(uint256) = 2 * 10 ** 16
96 
97 MIN_A: constant(uint256) = N_COINS ** N_COINS * A_MULTIPLIER / 10
98 MAX_A: constant(uint256) = N_COINS ** N_COINS * A_MULTIPLIER * 100000
99 
100 
101 WETH: immutable(address)
102 
103 
104 admin: public(address)
105 future_admin: public(address)
106 
107 # fee receiver for plain pools
108 fee_receiver: public(address)
109 
110 pool_implementation: public(address)
111 token_implementation: public(address)
112 gauge_implementation: public(address)
113 
114 # mapping of coins -> pools for trading
115 # a mapping key is generated for each pair of addresses via
116 # `bitwise_xor(convert(a, uint256), convert(b, uint256))`
117 markets: HashMap[uint256, address[4294967296]]
118 market_counts: HashMap[uint256, uint256]
119 
120 pool_count: public(uint256)              # actual length of pool_list
121 pool_data: HashMap[address, PoolArray]
122 pool_list: public(address[4294967296])   # master list of pools
123 
124 
125 @external
126 def __init__(
127     _fee_receiver: address,
128     _pool_implementation: address,
129     _token_implementation: address,
130     _gauge_implementation: address,
131     _weth: address
132 ):
133     self.fee_receiver = _fee_receiver
134     self.pool_implementation = _pool_implementation
135     self.token_implementation = _token_implementation
136     self.gauge_implementation = _gauge_implementation
137 
138     self.admin = msg.sender
139     WETH = _weth
140 
141     log UpdateFeeReceiver(ZERO_ADDRESS, _fee_receiver)
142     log UpdatePoolImplementation(ZERO_ADDRESS, _pool_implementation)
143     log UpdateTokenImplementation(ZERO_ADDRESS, _token_implementation)
144     log UpdateGaugeImplementation(ZERO_ADDRESS, _gauge_implementation)
145     log TransferOwnership(ZERO_ADDRESS, msg.sender)
146 
147 
148 # <--- Pool Deployers --->
149 
150 @external
151 def deploy_pool(
152     _name: String[32],
153     _symbol: String[10],
154     _coins: address[2],
155     A: uint256,
156     gamma: uint256,
157     mid_fee: uint256,
158     out_fee: uint256,
159     allowed_extra_profit: uint256,
160     fee_gamma: uint256,
161     adjustment_step: uint256,
162     admin_fee: uint256,
163     ma_half_time: uint256,
164     initial_price: uint256
165 ) -> address:
166     """
167     @notice Deploy a new pool
168     @param _name Name of the new plain pool
169     @param _symbol Symbol for the new plain pool - will be concatenated with factory symbol
170     Other parameters need some description
171     @return Address of the deployed pool
172     """
173     # Validate parameters
174     assert A > MIN_A-1
175     assert A < MAX_A+1
176     assert gamma > MIN_GAMMA-1
177     assert gamma < MAX_GAMMA+1
178     assert mid_fee > MIN_FEE-1
179     assert mid_fee < MAX_FEE-1
180     assert out_fee >= mid_fee
181     assert out_fee < MAX_FEE-1
182     assert admin_fee < 10**18+1
183     assert allowed_extra_profit < 10**16+1
184     assert fee_gamma < 10**18+1
185     assert fee_gamma > 0
186     assert adjustment_step < 10**18+1
187     assert adjustment_step > 0
188     assert ma_half_time < 7 * 86400
189     assert ma_half_time > 0
190     assert initial_price > 10**6
191     assert initial_price < 10**30
192     assert _coins[0] != _coins[1], "Duplicate coins"
193 
194     decimals: uint256[2] = empty(uint256[2])
195     for i in range(2):
196         d: uint256 = ERC20(_coins[i]).decimals()
197         assert d < 19, "Max 18 decimals for coins"
198         decimals[i] = d
199     precisions: uint256 = (18 - decimals[0]) + shift(18 - decimals[1], 8)
200 
201 
202     name: String[64] = concat("Curve.fi Factory Crypto Pool: ", _name)
203     symbol: String[32] = concat(_symbol, "-f")
204 
205     token: address = create_forwarder_to(self.token_implementation)
206     pool: address = create_forwarder_to(self.pool_implementation)
207 
208     Token(token).initialize(name, symbol, pool)
209     CryptoPool(pool).initialize(
210         A, gamma, mid_fee, out_fee, allowed_extra_profit, fee_gamma,
211         adjustment_step, admin_fee, ma_half_time, initial_price,
212         token, _coins, precisions)
213 
214     length: uint256 = self.pool_count
215     self.pool_list[length] = pool
216     self.pool_count = length + 1
217     self.pool_data[pool].token = token
218     self.pool_data[pool].decimals = shift(decimals[0], 8) + decimals[1]
219     self.pool_data[pool].coins = _coins
220 
221     key: uint256 = bitwise_xor(convert(_coins[0], uint256), convert(_coins[1], uint256))
222     length = self.market_counts[key]
223     self.markets[key][length] = pool
224     self.market_counts[key] = length + 1
225 
226     log CryptoPoolDeployed(
227         token, _coins,
228         A, gamma, mid_fee, out_fee, allowed_extra_profit, fee_gamma,
229         adjustment_step, admin_fee, ma_half_time, initial_price,
230         msg.sender)
231     return pool
232 
233 
234 @external
235 def deploy_gauge(_pool: address) -> address:
236     """
237     @notice Deploy a liquidity gauge for a factory pool
238     @param _pool Factory pool address to deploy a gauge for
239     @return Address of the deployed gauge
240     """
241     assert self.pool_data[_pool].coins[0] != ZERO_ADDRESS, "Unknown pool"
242     assert self.pool_data[_pool].liquidity_gauge == ZERO_ADDRESS, "Gauge already deployed"
243 
244     gauge: address = create_forwarder_to(self.gauge_implementation)
245     token: address = self.pool_data[_pool].token
246     LiquidityGauge(gauge).initialize(token)
247     self.pool_data[_pool].liquidity_gauge = gauge
248 
249     log LiquidityGaugeDeployed(_pool, token, gauge)
250     return gauge
251 
252 
253 # <--- Admin / Guarded Functionality --->
254 
255 
256 @external
257 def set_fee_receiver(_fee_receiver: address):
258     """
259     @notice Set fee receiver
260     @param _fee_receiver Address that fees are sent to
261     """
262     assert msg.sender == self.admin  # dev: admin only
263 
264     log UpdateFeeReceiver(self.fee_receiver, _fee_receiver)
265     self.fee_receiver = _fee_receiver
266 
267 
268 @external
269 def set_pool_implementation(_pool_implementation: address):
270     """
271     @notice Set pool implementation
272     @dev Set to ZERO_ADDRESS to prevent deployment of new pools
273     @param _pool_implementation Address of the new pool implementation
274     """
275     assert msg.sender == self.admin  # dev: admin only
276 
277     log UpdatePoolImplementation(self.pool_implementation, _pool_implementation)
278     self.pool_implementation = _pool_implementation
279 
280 
281 @external
282 def set_token_implementation(_token_implementation: address):
283     """
284     @notice Set token implementation
285     @dev Set to ZERO_ADDRESS to prevent deployment of new pools
286     @param _token_implementation Address of the new token implementation
287     """
288     assert msg.sender == self.admin  # dev: admin only
289 
290     log UpdateTokenImplementation(self.token_implementation, _token_implementation)
291     self.token_implementation = _token_implementation
292 
293 
294 @external
295 def set_gauge_implementation(_gauge_implementation: address):
296     """
297     @notice Set gauge implementation
298     @dev Set to ZERO_ADDRESS to prevent deployment of new gauges
299     @param _gauge_implementation Address of the new token implementation
300     """
301     assert msg.sender == self.admin  # dev: admin-only function
302 
303     log UpdateGaugeImplementation(self.gauge_implementation, _gauge_implementation)
304     self.gauge_implementation = _gauge_implementation
305 
306 
307 @external
308 def commit_transfer_ownership(_addr: address):
309     """
310     @notice Transfer ownership of this contract to `addr`
311     @param _addr Address of the new owner
312     """
313     assert msg.sender == self.admin  # dev: admin only
314 
315     self.future_admin = _addr
316 
317 
318 @external
319 def accept_transfer_ownership():
320     """
321     @notice Accept a pending ownership transfer
322     @dev Only callable by the new owner
323     """
324     assert msg.sender == self.future_admin  # dev: future admin only
325 
326     log TransferOwnership(self.admin, msg.sender)
327     self.admin = msg.sender
328 
329 
330 # <--- Factory Getters --->
331 
332 
333 @view
334 @external
335 def find_pool_for_coins(_from: address, _to: address, i: uint256 = 0) -> address:
336     """
337     @notice Find an available pool for exchanging two coins
338     @param _from Address of coin to be sent
339     @param _to Address of coin to be received
340     @param i Index value. When multiple pools are available
341             this value is used to return the n'th address.
342     @return Pool address
343     """
344     key: uint256 = bitwise_xor(convert(_from, uint256), convert(_to, uint256))
345     return self.markets[key][i]
346 
347 
348 # <--- Pool Getters --->
349 
350 
351 @view
352 @external
353 def get_coins(_pool: address) -> address[2]:
354     """
355     @notice Get the coins within a pool
356     @param _pool Pool address
357     @return List of coin addresses
358     """
359     return self.pool_data[_pool].coins
360 
361 
362 @view
363 @external
364 def get_decimals(_pool: address) -> uint256[2]:
365     """
366     @notice Get decimal places for each coin within a pool
367     @param _pool Pool address
368     @return uint256 list of decimals
369     """
370     decimals: uint256 = self.pool_data[_pool].decimals
371     return [shift(decimals, -8), decimals % 256]
372 
373 
374 @view
375 @external
376 def get_balances(_pool: address) -> uint256[2]:
377     """
378     @notice Get balances for each coin within a pool
379     @dev For pools using lending, these are the wrapped coin balances
380     @param _pool Pool address
381     @return uint256 list of balances
382     """
383     return [CryptoPool(_pool).balances(0), CryptoPool(_pool).balances(1)]
384 
385 
386 @view
387 @external
388 def get_coin_indices(
389     _pool: address,
390     _from: address,
391     _to: address
392 ) -> (uint256, uint256):
393     """
394     @notice Convert coin addresses to indices for use with pool methods
395     @param _pool Pool address
396     @param _from Coin address to be used as `i` within a pool
397     @param _to Coin address to be used as `j` within a pool
398     @return uint256 `i`, uint256 `j`
399     """
400     coins: address[2] = self.pool_data[_pool].coins
401 
402     if _from == coins[0] and _to == coins[1]:
403         return 0, 1
404     elif _from == coins[1] and _to == coins[0]:
405         return 1, 0
406     else:
407         raise "Coins not found"
408 
409 
410 @view
411 @external
412 def get_gauge(_pool: address) -> address:
413     """
414     @notice Get the address of the liquidity gauge contract for a factory pool
415     @dev Returns `ZERO_ADDRESS` if a gauge has not been deployed
416     @param _pool Pool address
417     @return Implementation contract address
418     """
419     return self.pool_data[_pool].liquidity_gauge
420 
421 
422 @view
423 @external
424 def get_eth_index(_pool: address) -> uint256:
425     """
426     @notice Get the index of WETH for a pool
427     @dev Returns MAX_UINT256 if WETH is not a coin in the pool
428     """
429     for i in range(2):
430         if self.pool_data[_pool].coins[i] == WETH:
431             return i
432     return MAX_UINT256
433 
434 
435 @view
436 @external
437 def get_token(_pool: address) -> address:
438     """
439     @notice Get the address of the LP token of a pool
440     """
441     return self.pool_data[_pool].token