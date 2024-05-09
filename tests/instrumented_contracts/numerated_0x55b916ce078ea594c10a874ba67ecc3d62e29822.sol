1 # @version 0.3.1
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
62     def calc_withdraw_one_coin(token_amount: uint256, i: int128,) -> uint256: view
63 
64 interface BasePool3Coins:
65     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256): nonpayable
66     def calc_token_amount(amounts: uint256[3], is_deposit: bool) -> uint256: view
67     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
68     def calc_withdraw_one_coin(token_amount: uint256, i: int128,) -> uint256: view
69 
70 interface LendingBasePool3Coins:
71     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256, use_underlying: bool): nonpayable
72     def calc_token_amount(amounts: uint256[3], is_deposit: bool) -> uint256: view
73     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256, use_underlying: bool) -> uint256: nonpayable
74     def calc_withdraw_one_coin(token_amount: uint256, i: int128,) -> uint256: view
75 
76 interface Calculator:
77     def get_dx(n_coins: uint256, balances: uint256[MAX_COINS], amp: uint256, fee: uint256,
78                rates: uint256[MAX_COINS], precisions: uint256[MAX_COINS],
79                i: int128, j: int128, dx: uint256) -> uint256: view
80     def get_dy(n_coins: uint256, balances: uint256[MAX_COINS], amp: uint256, fee: uint256,
81                rates: uint256[MAX_COINS], precisions: uint256[MAX_COINS],
82                i: int128, j: int128, dx: uint256[CALC_INPUT_SIZE]) -> uint256[CALC_INPUT_SIZE]: view
83 
84 
85 event TokenExchange:
86     buyer: indexed(address)
87     receiver: indexed(address)
88     pool: indexed(address)
89     token_sold: address
90     token_bought: address
91     amount_sold: uint256
92     amount_bought: uint256
93 
94 
95 ETH_ADDRESS: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
96 WETH_ADDRESS: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
97 MAX_COINS: constant(int128) = 8
98 CALC_INPUT_SIZE: constant(uint256) = 100
99 EMPTY_POOL_LIST: constant(address[8]) = [
100     ZERO_ADDRESS,
101     ZERO_ADDRESS,
102     ZERO_ADDRESS,
103     ZERO_ADDRESS,
104     ZERO_ADDRESS,
105     ZERO_ADDRESS,
106     ZERO_ADDRESS,
107     ZERO_ADDRESS,
108 ]
109 
110 
111 address_provider: AddressProvider
112 registry: public(address)
113 factory_registry: public(address)
114 crypto_registry: public(address)
115 
116 default_calculator: public(address)
117 is_killed: public(bool)
118 pool_calculator: HashMap[address, address]
119 
120 is_approved: HashMap[address, HashMap[address, bool]]
121 base_coins: HashMap[address, address[2]]
122 
123 
124 @external
125 def __init__(_address_provider: address, _calculator: address):
126     """
127     @notice Constructor function
128     """
129     self.address_provider = AddressProvider(_address_provider)
130     self.registry = AddressProvider(_address_provider).get_registry()
131     self.factory_registry = AddressProvider(_address_provider).get_address(3)
132     self.crypto_registry = AddressProvider(_address_provider).get_address(5)
133     self.default_calculator = _calculator
134 
135 
136 @external
137 @payable
138 def __default__():
139     pass
140 
141 
142 @view
143 @internal
144 def _get_exchange_amount(
145     _registry: address,
146     _pool: address,
147     _from: address,
148     _to: address,
149     _amount: uint256
150 ) -> uint256:
151     """
152     @notice Get the current number of coins received in an exchange
153     @param _registry Registry address
154     @param _pool Pool address
155     @param _from Address of coin to be sent
156     @param _to Address of coin to be received
157     @param _amount Quantity of `_from` to be sent
158     @return Quantity of `_to` to be received
159     """
160     i: int128 = 0
161     j: int128 = 0
162     is_underlying: bool = False
163     i, j, is_underlying = Registry(_registry).get_coin_indices(_pool, _from, _to) # dev: no market
164 
165     if is_underlying and (_registry == self.registry or Registry(_registry).is_meta(_pool)):
166         return CurvePool(_pool).get_dy_underlying(i, j, _amount)
167 
168     return CurvePool(_pool).get_dy(i, j, _amount)
169 
170 
171 @view
172 @internal
173 def _get_crypto_exchange_amount(
174     _registry: address,
175     _pool: address,
176     _from: address,
177     _to: address,
178     _amount: uint256
179 ) -> uint256:
180     """
181     @notice Get the current number of coins received in an exchange
182     @param _registry Registry address
183     @param _pool Pool address
184     @param _from Address of coin to be sent
185     @param _to Address of coin to be received
186     @param _amount Quantity of `_from` to be sent
187     @return Quantity of `_to` to be received
188     """
189     i: uint256 = 0
190     j: uint256 = 0
191     i, j = CryptoRegistry(_registry).get_coin_indices(_pool, _from, _to) # dev: no market
192 
193     return CryptoPool(_pool).get_dy(i, j, _amount)
194 
195 
196 @internal
197 def _exchange(
198     _registry: address,
199     _pool: address,
200     _from: address,
201     _to: address,
202     _amount: uint256,
203     _expected: uint256,
204     _sender: address,
205     _receiver: address,
206 ) -> uint256:
207 
208     assert not self.is_killed
209 
210     eth_amount: uint256 = 0
211     received_amount: uint256 = 0
212 
213     i: int128 = 0
214     j: int128 = 0
215     is_underlying: bool = False
216     i, j, is_underlying = Registry(_registry).get_coin_indices(_pool, _from, _to)  # dev: no market
217     if is_underlying and _registry == self.factory_registry:
218         if Registry(_registry).is_meta(_pool):
219             base_coins: address[2] = self.base_coins[_pool]
220             if base_coins == empty(address[2]):
221                 base_coins = [CurvePool(_pool).coins(0), CurvePool(_pool).coins(1)]
222                 self.base_coins[_pool] = base_coins
223 
224             # we only need to use exchange underlying if the input or output is not in the base coins
225             is_underlying = _from not in base_coins or _to not in base_coins
226         else:
227             # not a metapool so no underlying exchange method
228             is_underlying = False
229 
230     # perform / verify input transfer
231     if _from == ETH_ADDRESS:
232         eth_amount = _amount
233     else:
234         response: Bytes[32] = raw_call(
235             _from,
236             _abi_encode(
237                 _sender,
238                 self,
239                 _amount,
240                 method_id=method_id("transferFrom(address,address,uint256)"),
241             ),
242             max_outsize=32,
243         )
244         if len(response) != 0:
245             assert convert(response, bool)
246 
247     # approve input token
248     if _from != ETH_ADDRESS and not self.is_approved[_from][_pool]:
249         response: Bytes[32] = raw_call(
250             _from,
251             _abi_encode(
252                 _pool,
253                 MAX_UINT256,
254                 method_id=method_id("approve(address,uint256)"),
255             ),
256             max_outsize=32,
257         )
258         if len(response) != 0:
259             assert convert(response, bool)
260         self.is_approved[_from][_pool] = True
261 
262     # perform coin exchange
263     if is_underlying:
264         CurvePool(_pool).exchange_underlying(i, j, _amount, _expected, value=eth_amount)
265     else:
266         CurvePool(_pool).exchange(i, j, _amount, _expected, value=eth_amount)
267 
268     # perform output transfer
269     if _to == ETH_ADDRESS:
270         received_amount = self.balance
271         raw_call(_receiver, b"", value=self.balance)
272     else:
273         received_amount = ERC20(_to).balanceOf(self)
274         response: Bytes[32] = raw_call(
275             _to,
276             _abi_encode(
277                 _receiver,
278                 received_amount,
279                 method_id=method_id("transfer(address,uint256)"),
280             ),
281             max_outsize=32,
282         )
283         if len(response) != 0:
284             assert convert(response, bool)
285 
286     log TokenExchange(_sender, _receiver, _pool, _from, _to, _amount, received_amount)
287 
288     return received_amount
289 
290 
291 @internal
292 def _crypto_exchange(
293     _pool: address,
294     _from: address,
295     _to: address,
296     _amount: uint256,
297     _expected: uint256,
298     _sender: address,
299     _receiver: address,
300 ) -> uint256:
301 
302     assert not self.is_killed
303 
304     initial: address = _from
305     target: address = _to
306 
307     if _from == ETH_ADDRESS:
308         initial = WETH_ADDRESS
309     if _to == ETH_ADDRESS:
310         target = WETH_ADDRESS
311 
312     eth_amount: uint256 = 0
313     received_amount: uint256 = 0
314 
315     i: uint256 = 0
316     j: uint256 = 0
317     i, j = CryptoRegistry(self.crypto_registry).get_coin_indices(_pool, initial, target)  # dev: no market
318 
319     # perform / verify input transfer
320     if _from == ETH_ADDRESS:
321         eth_amount = _amount
322     else:
323         response: Bytes[32] = raw_call(
324             _from,
325             _abi_encode(
326                 _sender,
327                 self,
328                 _amount,
329                 method_id=method_id("transferFrom(address,address,uint256)"),
330             ),
331             max_outsize=32,
332         )
333         if len(response) != 0:
334             assert convert(response, bool)
335 
336     # approve input token
337     if not self.is_approved[_from][_pool]:
338         response: Bytes[32] = raw_call(
339             _from,
340             _abi_encode(
341                 _pool,
342                 MAX_UINT256,
343                 method_id=method_id("approve(address,uint256)"),
344             ),
345             max_outsize=32,
346         )
347         if len(response) != 0:
348             assert convert(response, bool)
349         self.is_approved[_from][_pool] = True
350 
351     # perform coin exchange
352     if ETH_ADDRESS in [_from, _to]:
353         CryptoPoolETH(_pool).exchange(i, j, _amount, _expected, True, value=eth_amount)
354     else:
355         CryptoPool(_pool).exchange(i, j, _amount, _expected)
356 
357     # perform output transfer
358     if _to == ETH_ADDRESS:
359         received_amount = self.balance
360         raw_call(_receiver, b"", value=self.balance)
361     else:
362         received_amount = ERC20(_to).balanceOf(self)
363         response: Bytes[32] = raw_call(
364             _to,
365             _abi_encode(
366                 _receiver,
367                 received_amount,
368                 method_id=method_id("transfer(address,uint256)"),
369             ),
370             max_outsize=32,
371         )
372         if len(response) != 0:
373             assert convert(response, bool)
374 
375     log TokenExchange(_sender, _receiver, _pool, _from, _to, _amount, received_amount)
376 
377     return received_amount
378 
379 
380 
381 @payable
382 @external
383 @nonreentrant("lock")
384 def exchange_with_best_rate(
385     _from: address,
386     _to: address,
387     _amount: uint256,
388     _expected: uint256,
389     _receiver: address = msg.sender,
390 ) -> uint256:
391     """
392     @notice Perform an exchange using the pool that offers the best rate
393     @dev Prior to calling this function, the caller must approve
394          this contract to transfer `_amount` coins from `_from`
395          Does NOT check rates in factory-deployed pools
396     @param _from Address of coin being sent
397     @param _to Address of coin being received
398     @param _amount Quantity of `_from` being sent
399     @param _expected Minimum quantity of `_from` received
400            in order for the transaction to succeed
401     @param _receiver Address to transfer the received tokens to
402     @return uint256 Amount received
403     """
404     if _from == ETH_ADDRESS:
405         assert _amount == msg.value, "Incorrect ETH amount"
406     else:
407         assert msg.value == 0, "Incorrect ETH amount"
408 
409     registry: address = self.registry
410     best_pool: address = ZERO_ADDRESS
411     max_dy: uint256 = 0
412     for i in range(65536):
413         pool: address = Registry(registry).find_pool_for_coins(_from, _to, i)
414         if pool == ZERO_ADDRESS:
415             break
416         dy: uint256 = self._get_exchange_amount(registry, pool, _from, _to, _amount)
417         if dy > max_dy:
418             best_pool = pool
419             max_dy = dy
420 
421     return self._exchange(registry, best_pool, _from, _to, _amount, _expected, msg.sender, _receiver)
422 
423 
424 @payable
425 @external
426 @nonreentrant("lock")
427 def exchange(
428     _pool: address,
429     _from: address,
430     _to: address,
431     _amount: uint256,
432     _expected: uint256,
433     _receiver: address = msg.sender,
434 ) -> uint256:
435     """
436     @notice Perform an exchange using a specific pool
437     @dev Prior to calling this function, the caller must approve
438          this contract to transfer `_amount` coins from `_from`
439          Works for both regular and factory-deployed pools
440     @param _pool Address of the pool to use for the swap
441     @param _from Address of coin being sent
442     @param _to Address of coin being received
443     @param _amount Quantity of `_from` being sent
444     @param _expected Minimum quantity of `_from` received
445            in order for the transaction to succeed
446     @param _receiver Address to transfer the received tokens to
447     @return uint256 Amount received
448     """
449     if _from == ETH_ADDRESS:
450         assert _amount == msg.value, "Incorrect ETH amount"
451     else:
452         assert msg.value == 0, "Incorrect ETH amount"
453 
454     if Registry(self.crypto_registry).get_lp_token(_pool) != ZERO_ADDRESS:
455         return self._crypto_exchange(_pool, _from, _to, _amount, _expected, msg.sender, _receiver)
456 
457     registry: address = self.registry
458     if Registry(registry).get_lp_token(_pool) == ZERO_ADDRESS:
459         registry = self.factory_registry
460     return self._exchange(registry, _pool, _from, _to, _amount, _expected, msg.sender, _receiver)
461 
462 
463 @external
464 @payable
465 def exchange_multiple(
466     _route: address[9],
467     _swap_params: uint256[3][4],
468     _amount: uint256,
469     _expected: uint256,
470     _pools: address[4]=[ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS],
471     _receiver: address=msg.sender
472 ) -> uint256:
473     """
474     @notice Perform up to four swaps in a single transaction
475     @dev Routing and swap params must be determined off-chain. This
476          functionality is designed for gas efficiency over ease-of-use.
477     @param _route Array of [initial token, pool, token, pool, token, ...]
478                   The array is iterated until a pool address of 0x00, then the last
479                   given token is transferred to `_receiver`
480     @param _swap_params Multidimensional array of [i, j, swap type] where i and j are the correct
481                         values for the n'th pool in `_route`. The swap type should be
482                         1 for a stableswap `exchange`,
483                         2 for stableswap `exchange_underlying`,
484                         3 for a cryptoswap `exchange`,
485                         4 for a cryptoswap `exchange_underlying`,
486                         5 for factory metapools with lending base pool `exchange_underlying`,
487                         6 for factory crypto-meta pools underlying exchange (`exchange` method in zap),
488                         7-9 for underlying coin -> LP token "exchange" (actually `add_liquidity`),
489                         10-11 for LP token -> underlying coin "exchange" (actually `remove_liquidity_one_coin`)
490     @param _amount The amount of `_route[0]` token being sent.
491     @param _expected The minimum amount received after the final swap.
492     @param _pools Array of pools for swaps via zap contracts. This parameter is only needed for
493                   Polygon meta-factories underlying swaps.
494     @param _receiver Address to transfer the final output token to.
495     @return Received amount of the final output token
496     """
497     input_token: address = _route[0]
498     amount: uint256 = _amount
499     output_token: address = ZERO_ADDRESS
500 
501     # validate / transfer initial token
502     if input_token == ETH_ADDRESS:
503         assert msg.value == amount
504     else:
505         assert msg.value == 0
506         response: Bytes[32] = raw_call(
507             input_token,
508             _abi_encode(
509                 msg.sender,
510                 self,
511                 amount,
512                 method_id=method_id("transferFrom(address,address,uint256)"),
513             ),
514             max_outsize=32,
515         )
516         if len(response) != 0:
517             assert convert(response, bool)
518 
519     for i in range(1,5):
520         # 4 rounds of iteration to perform up to 4 swaps
521         swap: address = _route[i*2-1]
522         pool: address = _pools[i-1] # Only for Polygon meta-factories underlying swap (swap_type == 4)
523         output_token = _route[i*2]
524         params: uint256[3] = _swap_params[i-1]  # i, j, swap type
525 
526         if not self.is_approved[input_token][swap]:
527             # approve the pool to transfer the input token
528             response: Bytes[32] = raw_call(
529                 input_token,
530                 _abi_encode(
531                     swap,
532                     MAX_UINT256,
533                     method_id=method_id("approve(address,uint256)"),
534                 ),
535                 max_outsize=32,
536             )
537             if len(response) != 0:
538                 assert convert(response, bool)
539             self.is_approved[input_token][swap] = True
540 
541         eth_amount: uint256 = 0
542         if input_token == ETH_ADDRESS:
543             eth_amount = amount
544         # perform the swap according to the swap type
545         if params[2] == 1:
546             CurvePool(swap).exchange(convert(params[0], int128), convert(params[1], int128), amount, 0, value=eth_amount)
547         elif params[2] == 2:
548             CurvePool(swap).exchange_underlying(convert(params[0], int128), convert(params[1], int128), amount, 0, value=eth_amount)
549         elif params[2] == 3:
550             if input_token == ETH_ADDRESS or output_token == ETH_ADDRESS:
551                 CryptoPoolETH(swap).exchange(params[0], params[1], amount, 0, True, value=eth_amount)
552             else:
553                 CryptoPool(swap).exchange(params[0], params[1], amount, 0)
554         elif params[2] == 4:
555             CryptoPool(swap).exchange_underlying(params[0], params[1], amount, 0, value=eth_amount)
556         elif params[2] == 5:
557             LendingBasePoolMetaZap(swap).exchange_underlying(pool, convert(params[0], int128), convert(params[1], int128), amount, 0)
558         elif params[2] == 6:
559             use_eth: bool = input_token == ETH_ADDRESS or output_token == ETH_ADDRESS
560             CryptoMetaZap(swap).exchange(pool, params[0], params[1], amount, 0, use_eth)
561         elif params[2] == 7:
562             _amounts: uint256[2] = [0, 0]
563             _amounts[params[0]] = amount
564             BasePool2Coins(swap).add_liquidity(_amounts, 0)
565         elif params[2] == 8:
566             _amounts: uint256[3] = [0, 0, 0]
567             _amounts[params[0]] = amount
568             BasePool3Coins(swap).add_liquidity(_amounts, 0)
569         elif params[2] == 9:
570             _amounts: uint256[3] = [0, 0, 0]
571             _amounts[params[0]] = amount
572             LendingBasePool3Coins(swap).add_liquidity(_amounts, 0, True) # example: aave on Polygon
573         elif params[2] == 10:
574             # The number of coins doesn't matter here
575             BasePool3Coins(swap).remove_liquidity_one_coin(amount, convert(params[1], int128), 0)
576         elif params[2] == 11:
577             # The number of coins doesn't matter here
578             LendingBasePool3Coins(swap).remove_liquidity_one_coin(amount, convert(params[1], int128), 0, True) # example: aave on Polygon
579         else:
580             raise "Bad swap type"
581 
582         # update the amount received
583         if output_token == ETH_ADDRESS:
584             amount = self.balance
585         else:
586             amount = ERC20(output_token).balanceOf(self)
587 
588         # sanity check, if the routing data is incorrect we will have a 0 balance and that is bad
589         assert amount != 0, "Received nothing"
590 
591         # check if this was the last swap
592         if i == 4 or _route[i*2+1] == ZERO_ADDRESS:
593             break
594         # if there is another swap, the output token becomes the input for the next round
595         input_token = output_token
596 
597     # validate the final amount received
598     assert amount >= _expected
599 
600     # transfer the final token to the receiver
601     if output_token == ETH_ADDRESS:
602         raw_call(_receiver, b"", value=amount)
603     else:
604         response: Bytes[32] = raw_call(
605             output_token,
606             _abi_encode(
607                 _receiver,
608                 amount,
609                 method_id=method_id("transfer(address,uint256)"),
610             ),
611             max_outsize=32,
612         )
613         if len(response) != 0:
614             assert convert(response, bool)
615 
616     return amount
617 
618 
619 @view
620 @external
621 def get_best_rate(
622     _from: address, _to: address, _amount: uint256, _exclude_pools: address[8] = EMPTY_POOL_LIST
623 ) -> (address, uint256):
624     """
625     @notice Find the pool offering the best rate for a given swap.
626     @dev Checks rates for regular and factory pools
627     @param _from Address of coin being sent
628     @param _to Address of coin being received
629     @param _amount Quantity of `_from` being sent
630     @param _exclude_pools A list of up to 8 addresses which shouldn't be returned
631     @return Pool address, amount received
632     """
633     best_pool: address = ZERO_ADDRESS
634     max_dy: uint256 = 0
635 
636     initial: address = _from
637     target: address = _to
638     if _from == ETH_ADDRESS:
639         initial = WETH_ADDRESS
640     if _to == ETH_ADDRESS:
641         target = WETH_ADDRESS
642 
643     registry: address = self.crypto_registry
644     for i in range(65536):
645         pool: address = Registry(registry).find_pool_for_coins(initial, target, i)
646         if pool == ZERO_ADDRESS:
647             if i == 0:
648                 # we only check for stableswap pools if we did not find any crypto pools
649                 break
650             return best_pool, max_dy
651         elif pool in _exclude_pools:
652             continue
653         dy: uint256 = self._get_crypto_exchange_amount(registry, pool, initial, target, _amount)
654         if dy > max_dy:
655             best_pool = pool
656             max_dy = dy
657 
658     registry = self.registry
659     for i in range(65536):
660         pool: address = Registry(registry).find_pool_for_coins(_from, _to, i)
661         if pool == ZERO_ADDRESS:
662             break
663         elif pool in _exclude_pools:
664             continue
665         dy: uint256 = self._get_exchange_amount(registry, pool, _from, _to, _amount)
666         if dy > max_dy:
667             best_pool = pool
668             max_dy = dy
669 
670     registry = self.factory_registry
671     for i in range(65536):
672         pool: address = Registry(registry).find_pool_for_coins(_from, _to, i)
673         if pool == ZERO_ADDRESS:
674             break
675         elif pool in _exclude_pools:
676             continue
677         if ERC20(pool).totalSupply() == 0:
678             # ignore pools without TVL as the call to `get_dy` will revert
679             continue
680         dy: uint256 = self._get_exchange_amount(registry, pool, _from, _to, _amount)
681         if dy > max_dy:
682             best_pool = pool
683             max_dy = dy
684 
685     return best_pool, max_dy
686 
687 
688 @view
689 @external
690 def get_exchange_amount(_pool: address, _from: address, _to: address, _amount: uint256) -> uint256:
691     """
692     @notice Get the current number of coins received in an exchange
693     @dev Works for both regular and factory-deployed pools
694     @param _pool Pool address
695     @param _from Address of coin to be sent
696     @param _to Address of coin to be received
697     @param _amount Quantity of `_from` to be sent
698     @return Quantity of `_to` to be received
699     """
700 
701     registry: address = self.crypto_registry
702     if Registry(registry).get_lp_token(_pool) != ZERO_ADDRESS:
703         initial: address = _from
704         target: address = _to
705         if _from == ETH_ADDRESS:
706             initial = WETH_ADDRESS
707         if _to == ETH_ADDRESS:
708             target = WETH_ADDRESS
709         return self._get_crypto_exchange_amount(registry, _pool, initial, target, _amount)
710 
711     registry = self.registry
712     if Registry(registry).get_lp_token(_pool) == ZERO_ADDRESS:
713         registry = self.factory_registry
714     return self._get_exchange_amount(registry, _pool, _from, _to, _amount)
715 
716 
717 @view
718 @external
719 def get_input_amount(_pool: address, _from: address, _to: address, _amount: uint256) -> uint256:
720     """
721     @notice Get the current number of coins required to receive the given amount in an exchange
722     @param _pool Pool address
723     @param _from Address of coin to be sent
724     @param _to Address of coin to be received
725     @param _amount Quantity of `_to` to be received
726     @return Quantity of `_from` to be sent
727     """
728     registry: address = self.registry
729 
730     i: int128 = 0
731     j: int128 = 0
732     is_underlying: bool = False
733     i, j, is_underlying = Registry(registry).get_coin_indices(_pool, _from, _to)
734     amp: uint256 = Registry(registry).get_A(_pool)
735     fee: uint256 = Registry(registry).get_fees(_pool)[0]
736 
737     balances: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
738     rates: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
739     decimals: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
740     n_coins: uint256 = Registry(registry).get_n_coins(_pool)[convert(is_underlying, uint256)]
741     if is_underlying:
742         balances = Registry(registry).get_underlying_balances(_pool)
743         decimals = Registry(registry).get_underlying_decimals(_pool)
744         for x in range(MAX_COINS):
745             if x == n_coins:
746                 break
747             rates[x] = 10**18
748     else:
749         balances = Registry(registry).get_balances(_pool)
750         decimals = Registry(registry).get_decimals(_pool)
751         rates = Registry(registry).get_rates(_pool)
752 
753     for x in range(MAX_COINS):
754         if x == n_coins:
755             break
756         decimals[x] = 10 ** (18 - decimals[x])
757 
758     calculator: address = self.pool_calculator[_pool]
759     if calculator == ZERO_ADDRESS:
760         calculator = self.default_calculator
761     return Calculator(calculator).get_dx(n_coins, balances, amp, fee, rates, decimals, i, j, _amount)
762 
763 
764 @view
765 @external
766 def get_exchange_amounts(
767     _pool: address,
768     _from: address,
769     _to: address,
770     _amounts: uint256[CALC_INPUT_SIZE]
771 ) -> uint256[CALC_INPUT_SIZE]:
772     """
773     @notice Get the current number of coins required to receive the given amount in an exchange
774     @param _pool Pool address
775     @param _from Address of coin to be sent
776     @param _to Address of coin to be received
777     @param _amounts Quantity of `_to` to be received
778     @return Quantity of `_from` to be sent
779     """
780     registry: address = self.registry
781 
782     i: int128 = 0
783     j: int128 = 0
784     is_underlying: bool = False
785     balances: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
786     rates: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
787     decimals: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
788 
789     amp: uint256 = Registry(registry).get_A(_pool)
790     fee: uint256 = Registry(registry).get_fees(_pool)[0]
791     i, j, is_underlying = Registry(registry).get_coin_indices(_pool, _from, _to)
792     n_coins: uint256 = Registry(registry).get_n_coins(_pool)[convert(is_underlying, uint256)]
793 
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
814     return Calculator(calculator).get_dy(n_coins, balances, amp, fee, rates, decimals, i, j, _amounts)
815 
816 
817 @view
818 @external
819 def get_exchange_multiple_amount(
820     _route: address[9],
821     _swap_params: uint256[3][4],
822     _amount: uint256,
823     _pools: address[4]=[ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS]
824 ) -> uint256:
825     """
826     @notice Get the current number the final output tokens received in an exchange
827     @dev Routing and swap params must be determined off-chain. This
828          functionality is designed for gas efficiency over ease-of-use.
829     @param _route Array of [initial token, pool, token, pool, token, ...]
830                   The array is iterated until a pool address of 0x00, then the last
831                   given token is transferred to `_receiver`
832     @param _swap_params Multidimensional array of [i, j, swap type] where i and j are the correct
833                         values for the n'th pool in `_route`. The swap type should be
834                         1 for a stableswap `exchange`,
835                         2 for stableswap `exchange_underlying`,
836                         3 for a cryptoswap `exchange`,
837                         4 for a cryptoswap `exchange_underlying`,
838                         5 for factory metapools with lending base pool `exchange_underlying`,
839                         6 for factory crypto-meta pools underlying exchange (`exchange` method in zap),
840                         7-9 for underlying coin -> LP token "exchange" (actually `add_liquidity`),
841                         10-11 for LP token -> underlying coin "exchange" (actually `remove_liquidity_one_coin`)
842     @param _amount The amount of `_route[0]` token to be sent.
843     @param _pools Array of pools for swaps via zap contracts. This parameter is only needed for
844                   Polygon meta-factories underlying swaps.
845     @return Expected amount of the final output token
846     """
847     amount: uint256 = _amount
848 
849     for i in range(1,5):
850         # 4 rounds of iteration to perform up to 4 swaps
851         swap: address = _route[i*2-1]
852         pool: address = _pools[i-1] # Only for Polygon meta-factories underlying swap (swap_type == 4)
853         params: uint256[3] = _swap_params[i-1]  # i, j, swap type
854 
855         # Calc output amount according to the swap type
856         if params[2] == 1:
857             amount = CurvePool(swap).get_dy(convert(params[0], int128), convert(params[1], int128), amount)
858         elif params[2] == 2:
859             amount = CurvePool(swap).get_dy_underlying(convert(params[0], int128), convert(params[1], int128), amount)
860         elif params[2] == 3:
861             amount = CryptoPool(swap).get_dy(params[0], params[1], amount)
862         elif params[2] == 4:
863             amount = CryptoPool(swap).get_dy_underlying(params[0], params[1], amount)
864         elif params[2] == 5:
865             amount = CurvePool(pool).get_dy_underlying(convert(params[0], int128), convert(params[1], int128), amount)
866         elif params[2] == 6:
867             amount = CryptoMetaZap(swap).get_dy(pool, params[0], params[1], amount)
868         elif params[2] == 7:
869             _amounts: uint256[2] = [0, 0]
870             _amounts[params[0]] = amount
871             amount = BasePool2Coins(swap).calc_token_amount(_amounts, True)
872         elif params[2] in [8, 9]:
873             _amounts: uint256[3] = [0, 0, 0]
874             _amounts[params[0]] = amount
875             amount = BasePool3Coins(swap).calc_token_amount(_amounts, True)
876         elif params[2] in [10, 11]:
877             # The number of coins doesn't matter here
878             amount = BasePool3Coins(swap).calc_withdraw_one_coin(amount, convert(params[1], int128))
879         else:
880             raise "Bad swap type"
881 
882         # check if this was the last swap
883         if i == 4 or _route[i*2+1] == ZERO_ADDRESS:
884             break
885 
886     return amount
887 
888 
889 @view
890 @external
891 def get_calculator(_pool: address) -> address:
892     """
893     @notice Set calculator contract
894     @dev Used to calculate `get_dy` for a pool
895     @param _pool Pool address
896     @return `CurveCalc` address
897     """
898     calculator: address = self.pool_calculator[_pool]
899     if calculator == ZERO_ADDRESS:
900         return self.default_calculator
901     else:
902         return calculator
903 
904 
905 @external
906 def update_registry_address() -> bool:
907     """
908     @notice Update registry address
909     @dev The registry address is kept in storage to reduce gas costs.
910          If a new registry is deployed this function should be called
911          to update the local address from the address provider.
912     @return bool success
913     """
914     address_provider: address = self.address_provider.address
915     self.registry = AddressProvider(address_provider).get_registry()
916     self.factory_registry = AddressProvider(address_provider).get_address(3)
917     self.crypto_registry = AddressProvider(address_provider).get_address(5)
918 
919     return True
920 
921 
922 @external
923 def set_calculator(_pool: address, _calculator: address) -> bool:
924     """
925     @notice Set calculator contract
926     @dev Used to calculate `get_dy` for a pool
927     @param _pool Pool address
928     @param _calculator `CurveCalc` address
929     @return bool success
930     """
931     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
932 
933     self.pool_calculator[_pool] = _calculator
934 
935     return True
936 
937 
938 @external
939 def set_default_calculator(_calculator: address) -> bool:
940     """
941     @notice Set default calculator contract
942     @dev Used to calculate `get_dy` for a pool
943     @param _calculator `CurveCalc` address
944     @return bool success
945     """
946     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
947 
948     self.default_calculator = _calculator
949 
950     return True
951 
952 
953 @external
954 def claim_balance(_token: address) -> bool:
955     """
956     @notice Transfer an ERC20 or ETH balance held by this contract
957     @dev The entire balance is transferred to the owner
958     @param _token Token address
959     @return bool success
960     """
961     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
962 
963     if _token == ETH_ADDRESS:
964         raw_call(msg.sender, b"", value=self.balance)
965     else:
966         amount: uint256 = ERC20(_token).balanceOf(self)
967         response: Bytes[32] = raw_call(
968             _token,
969             concat(
970                 method_id("transfer(address,uint256)"),
971                 convert(msg.sender, bytes32),
972                 convert(amount, bytes32),
973             ),
974             max_outsize=32,
975         )
976         if len(response) != 0:
977             assert convert(response, bool)
978 
979     return True
980 
981 
982 @external
983 def set_killed(_is_killed: bool) -> bool:
984     """
985     @notice Kill or unkill the contract
986     @param _is_killed Killed status of the contract
987     @return bool success
988     """
989     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
990     self.is_killed = _is_killed
991 
992     return True