1 # @version 0.3.3
2 """
3 @title Curve Registry Exchange Contract
4 @license MIT
5 @author Curve.Fi
6 @notice Find pools, query exchange rates and perform swaps
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 
12 interface AddressProvider:
13     def admin() -> address: view
14     def get_registry() -> address: view
15     def get_address(idx: uint256) -> address: view
16 
17 interface Registry:
18     def address_provider() -> address: view
19     def get_A(_pool: address) -> uint256: view
20     def get_fees(_pool: address) -> uint256[2]: view
21     def get_coin_indices(_pool: address, _from: address, _to: address) -> (int128, int128, bool): view
22     def get_n_coins(_pool: address) -> uint256[2]: view
23     def get_balances(_pool: address) -> uint256[MAX_COINS]: view
24     def get_underlying_balances(_pool: address) -> uint256[MAX_COINS]: view
25     def get_rates(_pool: address) -> uint256[MAX_COINS]: view
26     def get_decimals(_pool: address) -> uint256[MAX_COINS]: view
27     def get_underlying_decimals(_pool: address) -> uint256[MAX_COINS]: view
28     def find_pool_for_coins(_from: address, _to: address, i: uint256) -> address: view
29     def get_lp_token(_pool: address) -> address: view
30     def is_meta(_pool: address) -> bool: view
31 
32 interface CryptoRegistry:
33     def get_coin_indices(_pool: address, _from: address, _to: address) -> (uint256, uint256): view
34 
35 interface CurvePool:
36     def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): payable
37     def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256): payable
38     def get_dy(i: int128, j: int128, amount: uint256) -> uint256: view
39     def get_dy_underlying(i: int128, j: int128, amount: uint256) -> uint256: view
40     def coins(i: uint256) -> address: view
41 
42 interface CryptoPool:
43     def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256): payable
44     def exchange_underlying(i: uint256, j: uint256, dx: uint256, min_dy: uint256): payable
45     def get_dy(i: uint256, j: uint256, amount: uint256) -> uint256: view
46     def get_dy_underlying(i: uint256, j: uint256, amount: uint256) -> uint256: view
47 
48 interface CryptoPoolETH:
49     def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool): payable
50 
51 interface LendingBasePoolMetaZap:
52     def exchange_underlying(pool: address, i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
53 
54 interface CryptoMetaZap:
55     def get_dy(pool: address, i: uint256, j: uint256, dx: uint256) -> uint256: view
56     def exchange(pool: address, i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool): payable
57 
58 interface BasePool2Coins:
59     def add_liquidity(amounts: uint256[2], min_mint_amount: uint256): nonpayable
60     def calc_token_amount(amounts: uint256[2], is_deposit: bool) -> uint256: view
61     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
62     def calc_withdraw_one_coin(token_amount: uint256, i: int128) -> uint256: view
63 
64 interface BasePool3Coins:
65     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256): nonpayable
66     def calc_token_amount(amounts: uint256[3], is_deposit: bool) -> uint256: view
67     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
68     def calc_withdraw_one_coin(token_amount: uint256, i: int128) -> uint256: view
69 
70 interface LendingBasePool3Coins:
71     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256, use_underlying: bool): nonpayable
72     def calc_token_amount(amounts: uint256[3], is_deposit: bool) -> uint256: view
73     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256, use_underlying: bool) -> uint256: nonpayable
74     def calc_withdraw_one_coin(token_amount: uint256, i: int128) -> uint256: view
75 
76 interface CryptoBasePool3Coins:
77     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256, use_underlying: bool): nonpayable
78     def calc_token_amount(amounts: uint256[3], is_deposit: bool) -> uint256: view
79     def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256): nonpayable
80     def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256: view
81 
82 interface BasePool4Coins:
83     def add_liquidity(amounts: uint256[4], min_mint_amount: uint256): nonpayable
84     def calc_token_amount(amounts: uint256[4], is_deposit: bool) -> uint256: view
85     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
86     def calc_withdraw_one_coin(token_amount: uint256, i: int128) -> uint256: view
87 
88 interface BasePool5Coins:
89     def add_liquidity(amounts: uint256[5], min_mint_amount: uint256): nonpayable
90     def calc_token_amount(amounts: uint256[5], is_deposit: bool) -> uint256: view
91     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
92     def calc_withdraw_one_coin(token_amount: uint256, i: int128) -> uint256: view
93 
94 interface wETH:
95     def deposit(): payable
96     def withdraw(_amount: uint256): nonpayable
97 
98 interface Calculator:
99     def get_dx(n_coins: uint256, balances: uint256[MAX_COINS], amp: uint256, fee: uint256,
100                rates: uint256[MAX_COINS], precisions: uint256[MAX_COINS],
101                i: int128, j: int128, dx: uint256) -> uint256: view
102     def get_dy(n_coins: uint256, balances: uint256[MAX_COINS], amp: uint256, fee: uint256,
103                rates: uint256[MAX_COINS], precisions: uint256[MAX_COINS],
104                i: int128, j: int128, dx: uint256[CALC_INPUT_SIZE]) -> uint256[CALC_INPUT_SIZE]: view
105 
106 
107 event TokenExchange:
108     buyer: indexed(address)
109     receiver: indexed(address)
110     pool: indexed(address)
111     token_sold: address
112     token_bought: address
113     amount_sold: uint256
114     amount_bought: uint256
115 
116 event ExchangeMultiple:
117     buyer: indexed(address)
118     receiver: indexed(address)
119     route: address[9]
120     swap_params: uint256[3][4]
121     pools: address[4]
122     amount_sold: uint256
123     amount_bought: uint256
124 
125 ETH_ADDRESS: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
126 WETH_ADDRESS: immutable(address)
127 MAX_COINS: constant(uint256) = 8
128 CALC_INPUT_SIZE: constant(uint256) = 100
129 EMPTY_POOL_LIST: constant(address[8]) = [
130     ZERO_ADDRESS,
131     ZERO_ADDRESS,
132     ZERO_ADDRESS,
133     ZERO_ADDRESS,
134     ZERO_ADDRESS,
135     ZERO_ADDRESS,
136     ZERO_ADDRESS,
137     ZERO_ADDRESS,
138 ]
139 
140 
141 address_provider: AddressProvider
142 registry: public(address)
143 factory_registry: public(address)
144 crypto_registry: public(address)
145 
146 default_calculator: public(address)
147 is_killed: public(bool)
148 pool_calculator: HashMap[address, address]
149 
150 is_approved: HashMap[address, HashMap[address, bool]]
151 base_coins: HashMap[address, address[2]]
152 
153 
154 @external
155 def __init__(_address_provider: address, _calculator: address, _weth: address):
156     """
157     @notice Constructor function
158     """
159     self.address_provider = AddressProvider(_address_provider)
160     self.registry = AddressProvider(_address_provider).get_registry()
161     self.factory_registry = AddressProvider(_address_provider).get_address(3)
162     self.crypto_registry = AddressProvider(_address_provider).get_address(5)
163     self.default_calculator = _calculator
164 
165     WETH_ADDRESS = _weth
166 
167 
168 @external
169 @payable
170 def __default__():
171     pass
172 
173 
174 @view
175 @internal
176 def _get_exchange_amount(
177     _registry: address,
178     _pool: address,
179     _from: address,
180     _to: address,
181     _amount: uint256
182 ) -> uint256:
183     """
184     @notice Get the current number of coins received in an exchange
185     @param _registry Registry address
186     @param _pool Pool address
187     @param _from Address of coin to be sent
188     @param _to Address of coin to be received
189     @param _amount Quantity of `_from` to be sent
190     @return Quantity of `_to` to be received
191     """
192     i: int128 = 0
193     j: int128 = 0
194     is_underlying: bool = False
195     i, j, is_underlying = Registry(_registry).get_coin_indices(_pool, _from, _to) # dev: no market
196 
197     if is_underlying and (_registry == self.registry or Registry(_registry).is_meta(_pool)):
198         return CurvePool(_pool).get_dy_underlying(i, j, _amount)
199 
200     return CurvePool(_pool).get_dy(i, j, _amount)
201 
202 
203 @view
204 @internal
205 def _get_crypto_exchange_amount(
206     _registry: address,
207     _pool: address,
208     _from: address,
209     _to: address,
210     _amount: uint256
211 ) -> uint256:
212     """
213     @notice Get the current number of coins received in an exchange
214     @param _registry Registry address
215     @param _pool Pool address
216     @param _from Address of coin to be sent
217     @param _to Address of coin to be received
218     @param _amount Quantity of `_from` to be sent
219     @return Quantity of `_to` to be received
220     """
221     i: uint256 = 0
222     j: uint256 = 0
223     i, j = CryptoRegistry(_registry).get_coin_indices(_pool, _from, _to) # dev: no market
224 
225     return CryptoPool(_pool).get_dy(i, j, _amount)
226 
227 
228 @internal
229 def _exchange(
230     _registry: address,
231     _pool: address,
232     _from: address,
233     _to: address,
234     _amount: uint256,
235     _expected: uint256,
236     _sender: address,
237     _receiver: address,
238 ) -> uint256:
239 
240     assert not self.is_killed
241 
242     eth_amount: uint256 = 0
243     received_amount: uint256 = 0
244 
245     i: int128 = 0
246     j: int128 = 0
247     is_underlying: bool = False
248     i, j, is_underlying = Registry(_registry).get_coin_indices(_pool, _from, _to)  # dev: no market
249     if is_underlying and _registry == self.factory_registry:
250         if Registry(_registry).is_meta(_pool):
251             base_coins: address[2] = self.base_coins[_pool]
252             if base_coins[0] == empty(address) and base_coins[1] == empty(address):
253                 base_coins = [CurvePool(_pool).coins(0), CurvePool(_pool).coins(1)]
254                 self.base_coins[_pool] = base_coins
255 
256             # we only need to use exchange underlying if the input or output is not in the base coins
257             is_underlying = _from not in base_coins or _to not in base_coins
258         else:
259             # not a metapool so no underlying exchange method
260             is_underlying = False
261 
262     # perform / verify input transfer
263     if _from == ETH_ADDRESS:
264         eth_amount = _amount
265     else:
266         response: Bytes[32] = raw_call(
267             _from,
268             _abi_encode(
269                 _sender,
270                 self,
271                 _amount,
272                 method_id=method_id("transferFrom(address,address,uint256)"),
273             ),
274             max_outsize=32,
275         )
276         if len(response) != 0:
277             assert convert(response, bool)
278 
279     # approve input token
280     if _from != ETH_ADDRESS and not self.is_approved[_from][_pool]:
281         response: Bytes[32] = raw_call(
282             _from,
283             _abi_encode(
284                 _pool,
285                 MAX_UINT256,
286                 method_id=method_id("approve(address,uint256)"),
287             ),
288             max_outsize=32,
289         )
290         if len(response) != 0:
291             assert convert(response, bool)
292         self.is_approved[_from][_pool] = True
293 
294     # perform coin exchange
295     if is_underlying:
296         CurvePool(_pool).exchange_underlying(i, j, _amount, _expected, value=eth_amount)
297     else:
298         CurvePool(_pool).exchange(i, j, _amount, _expected, value=eth_amount)
299 
300     # perform output transfer
301     if _to == ETH_ADDRESS:
302         received_amount = self.balance
303         raw_call(_receiver, b"", value=self.balance)
304     else:
305         received_amount = ERC20(_to).balanceOf(self)
306         response: Bytes[32] = raw_call(
307             _to,
308             _abi_encode(
309                 _receiver,
310                 received_amount,
311                 method_id=method_id("transfer(address,uint256)"),
312             ),
313             max_outsize=32,
314         )
315         if len(response) != 0:
316             assert convert(response, bool)
317 
318     log TokenExchange(_sender, _receiver, _pool, _from, _to, _amount, received_amount)
319 
320     return received_amount
321 
322 
323 @internal
324 def _crypto_exchange(
325     _pool: address,
326     _from: address,
327     _to: address,
328     _amount: uint256,
329     _expected: uint256,
330     _sender: address,
331     _receiver: address,
332 ) -> uint256:
333 
334     assert not self.is_killed
335 
336     initial: address = _from
337     target: address = _to
338 
339     if _from == ETH_ADDRESS:
340         initial = WETH_ADDRESS
341     if _to == ETH_ADDRESS:
342         target = WETH_ADDRESS
343 
344     eth_amount: uint256 = 0
345     received_amount: uint256 = 0
346 
347     i: uint256 = 0
348     j: uint256 = 0
349     i, j = CryptoRegistry(self.crypto_registry).get_coin_indices(_pool, initial, target)  # dev: no market
350 
351     # perform / verify input transfer
352     if _from == ETH_ADDRESS:
353         eth_amount = _amount
354     else:
355         response: Bytes[32] = raw_call(
356             _from,
357             _abi_encode(
358                 _sender,
359                 self,
360                 _amount,
361                 method_id=method_id("transferFrom(address,address,uint256)"),
362             ),
363             max_outsize=32,
364         )
365         if len(response) != 0:
366             assert convert(response, bool)
367 
368     # approve input token
369     if not self.is_approved[_from][_pool]:
370         response: Bytes[32] = raw_call(
371             _from,
372             _abi_encode(
373                 _pool,
374                 MAX_UINT256,
375                 method_id=method_id("approve(address,uint256)"),
376             ),
377             max_outsize=32,
378         )
379         if len(response) != 0:
380             assert convert(response, bool)
381         self.is_approved[_from][_pool] = True
382 
383     # perform coin exchange
384     if ETH_ADDRESS in [_from, _to]:
385         CryptoPoolETH(_pool).exchange(i, j, _amount, _expected, True, value=eth_amount)
386     else:
387         CryptoPool(_pool).exchange(i, j, _amount, _expected)
388 
389     # perform output transfer
390     if _to == ETH_ADDRESS:
391         received_amount = self.balance
392         raw_call(_receiver, b"", value=self.balance)
393     else:
394         received_amount = ERC20(_to).balanceOf(self)
395         response: Bytes[32] = raw_call(
396             _to,
397             _abi_encode(
398                 _receiver,
399                 received_amount,
400                 method_id=method_id("transfer(address,uint256)"),
401             ),
402             max_outsize=32,
403         )
404         if len(response) != 0:
405             assert convert(response, bool)
406 
407     log TokenExchange(_sender, _receiver, _pool, _from, _to, _amount, received_amount)
408 
409     return received_amount
410 
411 
412 
413 @payable
414 @external
415 @nonreentrant("lock")
416 def exchange_with_best_rate(
417     _from: address,
418     _to: address,
419     _amount: uint256,
420     _expected: uint256,
421     _receiver: address = msg.sender,
422 ) -> uint256:
423     """
424     @notice Perform an exchange using the pool that offers the best rate
425     @dev Prior to calling this function, the caller must approve
426          this contract to transfer `_amount` coins from `_from`
427          Does NOT check rates in factory-deployed pools
428     @param _from Address of coin being sent
429     @param _to Address of coin being received
430     @param _amount Quantity of `_from` being sent
431     @param _expected Minimum quantity of `_from` received
432            in order for the transaction to succeed
433     @param _receiver Address to transfer the received tokens to
434     @return uint256 Amount received
435     """
436     if _from == ETH_ADDRESS:
437         assert _amount == msg.value, "Incorrect ETH amount"
438     else:
439         assert msg.value == 0, "Incorrect ETH amount"
440 
441     registry: address = self.registry
442     best_pool: address = ZERO_ADDRESS
443     max_dy: uint256 = 0
444     for i in range(65536):
445         pool: address = Registry(registry).find_pool_for_coins(_from, _to, i)
446         if pool == ZERO_ADDRESS:
447             break
448         dy: uint256 = self._get_exchange_amount(registry, pool, _from, _to, _amount)
449         if dy > max_dy:
450             best_pool = pool
451             max_dy = dy
452 
453     return self._exchange(registry, best_pool, _from, _to, _amount, _expected, msg.sender, _receiver)
454 
455 
456 @payable
457 @external
458 @nonreentrant("lock")
459 def exchange(
460     _pool: address,
461     _from: address,
462     _to: address,
463     _amount: uint256,
464     _expected: uint256,
465     _receiver: address = msg.sender,
466 ) -> uint256:
467     """
468     @notice Perform an exchange using a specific pool
469     @dev Prior to calling this function, the caller must approve
470          this contract to transfer `_amount` coins from `_from`
471          Works for both regular and factory-deployed pools
472     @param _pool Address of the pool to use for the swap
473     @param _from Address of coin being sent
474     @param _to Address of coin being received
475     @param _amount Quantity of `_from` being sent
476     @param _expected Minimum quantity of `_from` received
477            in order for the transaction to succeed
478     @param _receiver Address to transfer the received tokens to
479     @return uint256 Amount received
480     """
481     if _from == ETH_ADDRESS:
482         assert _amount == msg.value, "Incorrect ETH amount"
483     else:
484         assert msg.value == 0, "Incorrect ETH amount"
485 
486     if Registry(self.crypto_registry).get_lp_token(_pool) != ZERO_ADDRESS:
487         return self._crypto_exchange(_pool, _from, _to, _amount, _expected, msg.sender, _receiver)
488 
489     registry: address = self.registry
490     if Registry(registry).get_lp_token(_pool) == ZERO_ADDRESS:
491         registry = self.factory_registry
492     return self._exchange(registry, _pool, _from, _to, _amount, _expected, msg.sender, _receiver)
493 
494 
495 @external
496 @payable
497 def exchange_multiple(
498     _route: address[9],
499     _swap_params: uint256[3][4],
500     _amount: uint256,
501     _expected: uint256,
502     _pools: address[4]=[ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS],
503     _receiver: address=msg.sender
504 ) -> uint256:
505     """
506     @notice Perform up to four swaps in a single transaction
507     @dev Routing and swap params must be determined off-chain. This
508          functionality is designed for gas efficiency over ease-of-use.
509     @param _route Array of [initial token, pool, token, pool, token, ...]
510                   The array is iterated until a pool address of 0x00, then the last
511                   given token is transferred to `_receiver`
512     @param _swap_params Multidimensional array of [i, j, swap type] where i and j are the correct
513                         values for the n'th pool in `_route`. The swap type should be
514                         1 for a stableswap `exchange`,
515                         2 for stableswap `exchange_underlying`,
516                         3 for a cryptoswap `exchange`,
517                         4 for a cryptoswap `exchange_underlying`,
518                         5 for factory metapools with lending base pool `exchange_underlying`,
519                         6 for factory crypto-meta pools underlying exchange (`exchange` method in zap),
520                         7-11 for wrapped coin (underlying for lending or fake pool) -> LP token "exchange" (actually `add_liquidity`),
521                         12-14 for LP token -> wrapped coin (underlying for lending pool) "exchange" (actually `remove_liquidity_one_coin`)
522                         15 for WETH -> ETH "exchange" (actually deposit/withdraw)
523     @param _amount The amount of `_route[0]` token being sent.
524     @param _expected The minimum amount received after the final swap.
525     @param _pools Array of pools for swaps via zap contracts. This parameter is only needed for
526                   Polygon meta-factories underlying swaps.
527     @param _receiver Address to transfer the final output token to.
528     @return Received amount of the final output token
529     """
530     input_token: address = _route[0]
531     amount: uint256 = _amount
532     output_token: address = ZERO_ADDRESS
533 
534     # validate / transfer initial token
535     if input_token == ETH_ADDRESS:
536         assert msg.value == amount
537     else:
538         assert msg.value == 0
539         response: Bytes[32] = raw_call(
540             input_token,
541             _abi_encode(
542                 msg.sender,
543                 self,
544                 amount,
545                 method_id=method_id("transferFrom(address,address,uint256)"),
546             ),
547             max_outsize=32,
548         )
549         if len(response) != 0:
550             assert convert(response, bool)
551 
552     for i in range(1,5):
553         # 4 rounds of iteration to perform up to 4 swaps
554         swap: address = _route[i*2-1]
555         pool: address = _pools[i-1] # Only for Polygon meta-factories underlying swap (swap_type == 4)
556         output_token = _route[i*2]
557         params: uint256[3] = _swap_params[i-1]  # i, j, swap type
558 
559         if not self.is_approved[input_token][swap]:
560             # approve the pool to transfer the input token
561             response: Bytes[32] = raw_call(
562                 input_token,
563                 _abi_encode(
564                     swap,
565                     MAX_UINT256,
566                     method_id=method_id("approve(address,uint256)"),
567                 ),
568                 max_outsize=32,
569             )
570             if len(response) != 0:
571                 assert convert(response, bool)
572             self.is_approved[input_token][swap] = True
573 
574         eth_amount: uint256 = 0
575         if input_token == ETH_ADDRESS:
576             eth_amount = amount
577         # perform the swap according to the swap type
578         if params[2] == 1:
579             CurvePool(swap).exchange(convert(params[0], int128), convert(params[1], int128), amount, 0, value=eth_amount)
580         elif params[2] == 2:
581             CurvePool(swap).exchange_underlying(convert(params[0], int128), convert(params[1], int128), amount, 0, value=eth_amount)
582         elif params[2] == 3:
583             if input_token == ETH_ADDRESS or output_token == ETH_ADDRESS:
584                 CryptoPoolETH(swap).exchange(params[0], params[1], amount, 0, True, value=eth_amount)
585             else:
586                 CryptoPool(swap).exchange(params[0], params[1], amount, 0)
587         elif params[2] == 4:
588             CryptoPool(swap).exchange_underlying(params[0], params[1], amount, 0, value=eth_amount)
589         elif params[2] == 5:
590             LendingBasePoolMetaZap(swap).exchange_underlying(pool, convert(params[0], int128), convert(params[1], int128), amount, 0)
591         elif params[2] == 6:
592             use_eth: bool = input_token == ETH_ADDRESS or output_token == ETH_ADDRESS
593             CryptoMetaZap(swap).exchange(pool, params[0], params[1], amount, 0, use_eth)
594         elif params[2] == 7:
595             _amounts: uint256[2] = [0, 0]
596             _amounts[params[0]] = amount
597             BasePool2Coins(swap).add_liquidity(_amounts, 0)
598         elif params[2] == 8:
599             _amounts: uint256[3] = [0, 0, 0]
600             _amounts[params[0]] = amount
601             BasePool3Coins(swap).add_liquidity(_amounts, 0)
602         elif params[2] == 9:
603             _amounts: uint256[3] = [0, 0, 0]
604             _amounts[params[0]] = amount
605             LendingBasePool3Coins(swap).add_liquidity(_amounts, 0, True) # example: aave on Polygon
606         elif params[2] == 10:
607             _amounts: uint256[4] = [0, 0, 0, 0]
608             _amounts[params[0]] = amount
609             BasePool4Coins(swap).add_liquidity(_amounts, 0)
610         elif params[2] == 11:
611             _amounts: uint256[5] = [0, 0, 0, 0, 0]
612             _amounts[params[0]] = amount
613             BasePool5Coins(swap).add_liquidity(_amounts, 0)
614         elif params[2] == 12:
615             # The number of coins doesn't matter here
616             BasePool3Coins(swap).remove_liquidity_one_coin(amount, convert(params[1], int128), 0)
617         elif params[2] == 13:
618             # The number of coins doesn't matter here
619             LendingBasePool3Coins(swap).remove_liquidity_one_coin(amount, convert(params[1], int128), 0, True) # example: aave on Polygon
620         elif params[2] == 14:
621             # The number of coins doesn't matter here
622             CryptoBasePool3Coins(swap).remove_liquidity_one_coin(amount, params[1], 0) # example: atricrypto3 on Polygon
623         elif params[2] == 15:
624             if input_token == ETH_ADDRESS:
625                 wETH(swap).deposit(value=amount)
626             elif output_token == ETH_ADDRESS:
627                 wETH(swap).withdraw(amount)
628             else:
629                 raise "One of the coins must be ETH for swap type 15"
630         else:
631             raise "Bad swap type"
632 
633         # update the amount received
634         if output_token == ETH_ADDRESS:
635             amount = self.balance
636         else:
637             amount = ERC20(output_token).balanceOf(self)
638 
639         # sanity check, if the routing data is incorrect we will have a 0 balance and that is bad
640         assert amount != 0, "Received nothing"
641 
642         # check if this was the last swap
643         if i == 4 or _route[i*2+1] == ZERO_ADDRESS:
644             break
645         # if there is another swap, the output token becomes the input for the next round
646         input_token = output_token
647 
648     # validate the final amount received
649     assert amount >= _expected
650 
651     # transfer the final token to the receiver
652     if output_token == ETH_ADDRESS:
653         raw_call(_receiver, b"", value=amount)
654     else:
655         response: Bytes[32] = raw_call(
656             output_token,
657             _abi_encode(
658                 _receiver,
659                 amount,
660                 method_id=method_id("transfer(address,uint256)"),
661             ),
662             max_outsize=32,
663         )
664         if len(response) != 0:
665             assert convert(response, bool)
666 
667     log ExchangeMultiple(msg.sender, _receiver, _route, _swap_params, _pools, _amount, amount)
668 
669     return amount
670 
671 
672 @view
673 @external
674 def get_best_rate(
675     _from: address, _to: address, _amount: uint256, _exclude_pools: address[8] = EMPTY_POOL_LIST
676 ) -> (address, uint256):
677     """
678     @notice Find the pool offering the best rate for a given swap.
679     @dev Checks rates for regular and factory pools
680     @param _from Address of coin being sent
681     @param _to Address of coin being received
682     @param _amount Quantity of `_from` being sent
683     @param _exclude_pools A list of up to 8 addresses which shouldn't be returned
684     @return Pool address, amount received
685     """
686     best_pool: address = ZERO_ADDRESS
687     max_dy: uint256 = 0
688 
689     initial: address = _from
690     target: address = _to
691     if _from == ETH_ADDRESS:
692         initial = WETH_ADDRESS
693     if _to == ETH_ADDRESS:
694         target = WETH_ADDRESS
695 
696     registry: address = self.crypto_registry
697     for i in range(65536):
698         pool: address = Registry(registry).find_pool_for_coins(initial, target, i)
699         if pool == ZERO_ADDRESS:
700             if i == 0:
701                 # we only check for stableswap pools if we did not find any crypto pools
702                 break
703             return best_pool, max_dy
704         elif pool in _exclude_pools:
705             continue
706         dy: uint256 = self._get_crypto_exchange_amount(registry, pool, initial, target, _amount)
707         if dy > max_dy:
708             best_pool = pool
709             max_dy = dy
710 
711     registry = self.registry
712     for i in range(65536):
713         pool: address = Registry(registry).find_pool_for_coins(_from, _to, i)
714         if pool == ZERO_ADDRESS:
715             break
716         elif pool in _exclude_pools:
717             continue
718         dy: uint256 = self._get_exchange_amount(registry, pool, _from, _to, _amount)
719         if dy > max_dy:
720             best_pool = pool
721             max_dy = dy
722 
723     registry = self.factory_registry
724     for i in range(65536):
725         pool: address = Registry(registry).find_pool_for_coins(_from, _to, i)
726         if pool == ZERO_ADDRESS:
727             break
728         elif pool in _exclude_pools:
729             continue
730         if ERC20(pool).totalSupply() == 0:
731             # ignore pools without TVL as the call to `get_dy` will revert
732             continue
733         dy: uint256 = self._get_exchange_amount(registry, pool, _from, _to, _amount)
734         if dy > max_dy:
735             best_pool = pool
736             max_dy = dy
737 
738     return best_pool, max_dy
739 
740 
741 @view
742 @external
743 def get_exchange_amount(_pool: address, _from: address, _to: address, _amount: uint256) -> uint256:
744     """
745     @notice Get the current number of coins received in an exchange
746     @dev Works for both regular and factory-deployed pools
747     @param _pool Pool address
748     @param _from Address of coin to be sent
749     @param _to Address of coin to be received
750     @param _amount Quantity of `_from` to be sent
751     @return Quantity of `_to` to be received
752     """
753 
754     registry: address = self.crypto_registry
755     if Registry(registry).get_lp_token(_pool) != ZERO_ADDRESS:
756         initial: address = _from
757         target: address = _to
758         if _from == ETH_ADDRESS:
759             initial = WETH_ADDRESS
760         if _to == ETH_ADDRESS:
761             target = WETH_ADDRESS
762         return self._get_crypto_exchange_amount(registry, _pool, initial, target, _amount)
763 
764     registry = self.registry
765     if Registry(registry).get_lp_token(_pool) == ZERO_ADDRESS:
766         registry = self.factory_registry
767     return self._get_exchange_amount(registry, _pool, _from, _to, _amount)
768 
769 
770 @view
771 @external
772 def get_input_amount(_pool: address, _from: address, _to: address, _amount: uint256) -> uint256:
773     """
774     @notice Get the current number of coins required to receive the given amount in an exchange
775     @param _pool Pool address
776     @param _from Address of coin to be sent
777     @param _to Address of coin to be received
778     @param _amount Quantity of `_to` to be received
779     @return Quantity of `_from` to be sent
780     """
781     registry: address = self.registry
782 
783     i: int128 = 0
784     j: int128 = 0
785     is_underlying: bool = False
786     i, j, is_underlying = Registry(registry).get_coin_indices(_pool, _from, _to)
787     amp: uint256 = Registry(registry).get_A(_pool)
788     fee: uint256 = Registry(registry).get_fees(_pool)[0]
789 
790     balances: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
791     rates: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
792     decimals: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
793     n_coins: uint256 = Registry(registry).get_n_coins(_pool)[convert(is_underlying, uint256)]
794     if is_underlying:
795         balances = Registry(registry).get_underlying_balances(_pool)
796         decimals = Registry(registry).get_underlying_decimals(_pool)
797         for x in range(MAX_COINS):
798             if x == n_coins:
799                 break
800             rates[x] = 10**18
801     else:
802         balances = Registry(registry).get_balances(_pool)
803         decimals = Registry(registry).get_decimals(_pool)
804         rates = Registry(registry).get_rates(_pool)
805 
806     for x in range(MAX_COINS):
807         if x == n_coins:
808             break
809         decimals[x] = 10 ** (18 - decimals[x])
810 
811     calculator: address = self.pool_calculator[_pool]
812     if calculator == ZERO_ADDRESS:
813         calculator = self.default_calculator
814     return Calculator(calculator).get_dx(n_coins, balances, amp, fee, rates, decimals, i, j, _amount)
815 
816 
817 @view
818 @external
819 def get_exchange_amounts(
820     _pool: address,
821     _from: address,
822     _to: address,
823     _amounts: uint256[CALC_INPUT_SIZE]
824 ) -> uint256[CALC_INPUT_SIZE]:
825     """
826     @notice Get the current number of coins required to receive the given amount in an exchange
827     @param _pool Pool address
828     @param _from Address of coin to be sent
829     @param _to Address of coin to be received
830     @param _amounts Quantity of `_to` to be received
831     @return Quantity of `_from` to be sent
832     """
833     registry: address = self.registry
834 
835     i: int128 = 0
836     j: int128 = 0
837     is_underlying: bool = False
838     balances: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
839     rates: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
840     decimals: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
841 
842     amp: uint256 = Registry(registry).get_A(_pool)
843     fee: uint256 = Registry(registry).get_fees(_pool)[0]
844     i, j, is_underlying = Registry(registry).get_coin_indices(_pool, _from, _to)
845     n_coins: uint256 = Registry(registry).get_n_coins(_pool)[convert(is_underlying, uint256)]
846 
847     if is_underlying:
848         balances = Registry(registry).get_underlying_balances(_pool)
849         decimals = Registry(registry).get_underlying_decimals(_pool)
850         for x in range(MAX_COINS):
851             if x == n_coins:
852                 break
853             rates[x] = 10**18
854     else:
855         balances = Registry(registry).get_balances(_pool)
856         decimals = Registry(registry).get_decimals(_pool)
857         rates = Registry(registry).get_rates(_pool)
858 
859     for x in range(MAX_COINS):
860         if x == n_coins:
861             break
862         decimals[x] = 10 ** (18 - decimals[x])
863 
864     calculator: address = self.pool_calculator[_pool]
865     if calculator == ZERO_ADDRESS:
866         calculator = self.default_calculator
867     return Calculator(calculator).get_dy(n_coins, balances, amp, fee, rates, decimals, i, j, _amounts)
868 
869 
870 @view
871 @external
872 def get_exchange_multiple_amount(
873     _route: address[9],
874     _swap_params: uint256[3][4],
875     _amount: uint256,
876     _pools: address[4]=[ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS]
877 ) -> uint256:
878     """
879     @notice Get the current number the final output tokens received in an exchange
880     @dev Routing and swap params must be determined off-chain. This
881          functionality is designed for gas efficiency over ease-of-use.
882     @param _route Array of [initial token, pool, token, pool, token, ...]
883                   The array is iterated until a pool address of 0x00, then the last
884                   given token is transferred to `_receiver`
885     @param _swap_params Multidimensional array of [i, j, swap type] where i and j are the correct
886                         values for the n'th pool in `_route`. The swap type should be
887                         1 for a stableswap `exchange`,
888                         2 for stableswap `exchange_underlying`,
889                         3 for a cryptoswap `exchange`,
890                         4 for a cryptoswap `exchange_underlying`,
891                         5 for factory metapools with lending base pool `exchange_underlying`,
892                         6 for factory crypto-meta pools underlying exchange (`exchange` method in zap),
893                         7-11 for wrapped coin (underlying for lending pool) -> LP token "exchange" (actually `add_liquidity`),
894                         12-14 for LP token -> wrapped coin (underlying for lending or fake pool) "exchange" (actually `remove_liquidity_one_coin`)
895                         15 for WETH -> ETH "exchange" (actually deposit/withdraw)
896     @param _amount The amount of `_route[0]` token to be sent.
897     @param _pools Array of pools for swaps via zap contracts. This parameter is only needed for
898                   Polygon meta-factories underlying swaps.
899     @return Expected amount of the final output token
900     """
901     amount: uint256 = _amount
902 
903     for i in range(1,5):
904         # 4 rounds of iteration to perform up to 4 swaps
905         swap: address = _route[i*2-1]
906         pool: address = _pools[i-1] # Only for Polygon meta-factories underlying swap (swap_type == 4)
907         params: uint256[3] = _swap_params[i-1]  # i, j, swap type
908 
909         # Calc output amount according to the swap type
910         if params[2] == 1:
911             amount = CurvePool(swap).get_dy(convert(params[0], int128), convert(params[1], int128), amount)
912         elif params[2] == 2:
913             amount = CurvePool(swap).get_dy_underlying(convert(params[0], int128), convert(params[1], int128), amount)
914         elif params[2] == 3:
915             amount = CryptoPool(swap).get_dy(params[0], params[1], amount)
916         elif params[2] == 4:
917             amount = CryptoPool(swap).get_dy_underlying(params[0], params[1], amount)
918         elif params[2] == 5:
919             amount = CurvePool(pool).get_dy_underlying(convert(params[0], int128), convert(params[1], int128), amount)
920         elif params[2] == 6:
921             amount = CryptoMetaZap(swap).get_dy(pool, params[0], params[1], amount)
922         elif params[2] == 7:
923             _amounts: uint256[2] = [0, 0]
924             _amounts[params[0]] = amount
925             amount = BasePool2Coins(swap).calc_token_amount(_amounts, True)
926         elif params[2] in [8, 9]:
927             _amounts: uint256[3] = [0, 0, 0]
928             _amounts[params[0]] = amount
929             amount = BasePool3Coins(swap).calc_token_amount(_amounts, True)
930         elif params[2] == 10:
931             _amounts: uint256[4] = [0, 0, 0, 0]
932             _amounts[params[0]] = amount
933             amount = BasePool4Coins(swap).calc_token_amount(_amounts, True)
934         elif params[2] == 11:
935             _amounts: uint256[5] = [0, 0, 0, 0, 0]
936             _amounts[params[0]] = amount
937             amount = BasePool5Coins(swap).calc_token_amount(_amounts, True)
938         elif params[2] in [12, 13]:
939             # The number of coins doesn't matter here
940             amount = BasePool3Coins(swap).calc_withdraw_one_coin(amount, convert(params[1], int128))
941         elif params[2] == 14:
942             # The number of coins doesn't matter here
943             amount = CryptoBasePool3Coins(swap).calc_withdraw_one_coin(amount, params[1])
944         elif params[2] == 15:
945             # ETH <--> WETH rate is 1:1
946             pass
947         else:
948             raise "Bad swap type"
949 
950         # check if this was the last swap
951         if i == 4 or _route[i*2+1] == ZERO_ADDRESS:
952             break
953 
954     return amount
955 
956 
957 @view
958 @external
959 def get_calculator(_pool: address) -> address:
960     """
961     @notice Set calculator contract
962     @dev Used to calculate `get_dy` for a pool
963     @param _pool Pool address
964     @return `CurveCalc` address
965     """
966     calculator: address = self.pool_calculator[_pool]
967     if calculator == ZERO_ADDRESS:
968         return self.default_calculator
969     else:
970         return calculator
971 
972 
973 @external
974 def update_registry_address() -> bool:
975     """
976     @notice Update registry address
977     @dev The registry address is kept in storage to reduce gas costs.
978          If a new registry is deployed this function should be called
979          to update the local address from the address provider.
980     @return bool success
981     """
982     address_provider: address = self.address_provider.address
983     self.registry = AddressProvider(address_provider).get_registry()
984     self.factory_registry = AddressProvider(address_provider).get_address(3)
985     self.crypto_registry = AddressProvider(address_provider).get_address(5)
986 
987     return True
988 
989 
990 @external
991 def set_calculator(_pool: address, _calculator: address) -> bool:
992     """
993     @notice Set calculator contract
994     @dev Used to calculate `get_dy` for a pool
995     @param _pool Pool address
996     @param _calculator `CurveCalc` address
997     @return bool success
998     """
999     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
1000 
1001     self.pool_calculator[_pool] = _calculator
1002 
1003     return True
1004 
1005 
1006 @external
1007 def set_default_calculator(_calculator: address) -> bool:
1008     """
1009     @notice Set default calculator contract
1010     @dev Used to calculate `get_dy` for a pool
1011     @param _calculator `CurveCalc` address
1012     @return bool success
1013     """
1014     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
1015 
1016     self.default_calculator = _calculator
1017 
1018     return True
1019 
1020 
1021 @external
1022 def claim_balance(_token: address) -> bool:
1023     """
1024     @notice Transfer an ERC20 or ETH balance held by this contract
1025     @dev The entire balance is transferred to the owner
1026     @param _token Token address
1027     @return bool success
1028     """
1029     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
1030 
1031     if _token == ETH_ADDRESS:
1032         raw_call(msg.sender, b"", value=self.balance)
1033     else:
1034         amount: uint256 = ERC20(_token).balanceOf(self)
1035         response: Bytes[32] = raw_call(
1036             _token,
1037             concat(
1038                 method_id("transfer(address,uint256)"),
1039                 convert(msg.sender, bytes32),
1040                 convert(amount, bytes32),
1041             ),
1042             max_outsize=32,
1043         )
1044         if len(response) != 0:
1045             assert convert(response, bool)
1046 
1047     return True
1048 
1049 
1050 @external
1051 def set_killed(_is_killed: bool) -> bool:
1052     """
1053     @notice Kill or unkill the contract
1054     @param _is_killed Killed status of the contract
1055     @return bool success
1056     """
1057     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
1058     self.is_killed = _is_killed
1059 
1060     return True