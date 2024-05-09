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
51 interface PolygonMetaZap:
52     def exchange_underlying(pool: address, i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
53 
54 interface BasePool2Coins:
55     def add_liquidity(amounts: uint256[2], min_mint_amount: uint256): nonpayable
56     def calc_token_amount(amounts: uint256[2], is_deposit: bool) -> uint256: view
57     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
58     def calc_withdraw_one_coin(token_amount: uint256, i: int128,) -> uint256: view
59 
60 interface BasePool3Coins:
61     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256): nonpayable
62     def calc_token_amount(amounts: uint256[3], is_deposit: bool) -> uint256: view
63     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
64     def calc_withdraw_one_coin(token_amount: uint256, i: int128,) -> uint256: view
65 
66 interface BaseLendingPool3Coins:
67     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256, use_underlying: bool): nonpayable
68     def calc_token_amount(amounts: uint256[3], is_deposit: bool) -> uint256: view
69     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256, use_underlying: bool) -> uint256: nonpayable
70     def calc_withdraw_one_coin(token_amount: uint256, i: int128,) -> uint256: view
71 
72 interface Calculator:
73     def get_dx(n_coins: uint256, balances: uint256[MAX_COINS], amp: uint256, fee: uint256,
74                rates: uint256[MAX_COINS], precisions: uint256[MAX_COINS],
75                i: int128, j: int128, dx: uint256) -> uint256: view
76     def get_dy(n_coins: uint256, balances: uint256[MAX_COINS], amp: uint256, fee: uint256,
77                rates: uint256[MAX_COINS], precisions: uint256[MAX_COINS],
78                i: int128, j: int128, dx: uint256[CALC_INPUT_SIZE]) -> uint256[CALC_INPUT_SIZE]: view
79 
80 
81 event TokenExchange:
82     buyer: indexed(address)
83     receiver: indexed(address)
84     pool: indexed(address)
85     token_sold: address
86     token_bought: address
87     amount_sold: uint256
88     amount_bought: uint256
89 
90 
91 ETH_ADDRESS: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
92 WETH_ADDRESS: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
93 MAX_COINS: constant(int128) = 8
94 CALC_INPUT_SIZE: constant(uint256) = 100
95 EMPTY_POOL_LIST: constant(address[8]) = [
96     ZERO_ADDRESS,
97     ZERO_ADDRESS,
98     ZERO_ADDRESS,
99     ZERO_ADDRESS,
100     ZERO_ADDRESS,
101     ZERO_ADDRESS,
102     ZERO_ADDRESS,
103     ZERO_ADDRESS,
104 ]
105 
106 
107 address_provider: AddressProvider
108 registry: public(address)
109 factory_registry: public(address)
110 crypto_registry: public(address)
111 
112 default_calculator: public(address)
113 is_killed: public(bool)
114 pool_calculator: HashMap[address, address]
115 
116 is_approved: HashMap[address, HashMap[address, bool]]
117 base_coins: HashMap[address, address[2]]
118 
119 
120 @external
121 def __init__(_address_provider: address, _calculator: address):
122     """
123     @notice Constructor function
124     """
125     self.address_provider = AddressProvider(_address_provider)
126     self.registry = AddressProvider(_address_provider).get_registry()
127     self.factory_registry = AddressProvider(_address_provider).get_address(3)
128     self.crypto_registry = AddressProvider(_address_provider).get_address(5)
129     self.default_calculator = _calculator
130 
131 
132 @external
133 @payable
134 def __default__():
135     pass
136 
137 
138 @view
139 @internal
140 def _get_exchange_amount(
141     _registry: address,
142     _pool: address,
143     _from: address,
144     _to: address,
145     _amount: uint256
146 ) -> uint256:
147     """
148     @notice Get the current number of coins received in an exchange
149     @param _registry Registry address
150     @param _pool Pool address
151     @param _from Address of coin to be sent
152     @param _to Address of coin to be received
153     @param _amount Quantity of `_from` to be sent
154     @return Quantity of `_to` to be received
155     """
156     i: int128 = 0
157     j: int128 = 0
158     is_underlying: bool = False
159     i, j, is_underlying = Registry(_registry).get_coin_indices(_pool, _from, _to) # dev: no market
160 
161     if is_underlying and (_registry == self.registry or Registry(_registry).is_meta(_pool)):
162         return CurvePool(_pool).get_dy_underlying(i, j, _amount)
163 
164     return CurvePool(_pool).get_dy(i, j, _amount)
165 
166 
167 @view
168 @internal
169 def _get_crypto_exchange_amount(
170     _registry: address,
171     _pool: address,
172     _from: address,
173     _to: address,
174     _amount: uint256
175 ) -> uint256:
176     """
177     @notice Get the current number of coins received in an exchange
178     @param _registry Registry address
179     @param _pool Pool address
180     @param _from Address of coin to be sent
181     @param _to Address of coin to be received
182     @param _amount Quantity of `_from` to be sent
183     @return Quantity of `_to` to be received
184     """
185     i: uint256 = 0
186     j: uint256 = 0
187     i, j = CryptoRegistry(_registry).get_coin_indices(_pool, _from, _to) # dev: no market
188 
189     return CryptoPool(_pool).get_dy(i, j, _amount)
190 
191 
192 @internal
193 def _exchange(
194     _registry: address,
195     _pool: address,
196     _from: address,
197     _to: address,
198     _amount: uint256,
199     _expected: uint256,
200     _sender: address,
201     _receiver: address,
202 ) -> uint256:
203 
204     assert not self.is_killed
205 
206     eth_amount: uint256 = 0
207     received_amount: uint256 = 0
208 
209     i: int128 = 0
210     j: int128 = 0
211     is_underlying: bool = False
212     i, j, is_underlying = Registry(_registry).get_coin_indices(_pool, _from, _to)  # dev: no market
213     if is_underlying and _registry == self.factory_registry:
214         if Registry(_registry).is_meta(_pool):
215             base_coins: address[2] = self.base_coins[_pool]
216             if base_coins == empty(address[2]):
217                 base_coins = [CurvePool(_pool).coins(0), CurvePool(_pool).coins(1)]
218                 self.base_coins[_pool] = base_coins
219 
220             # we only need to use exchange underlying if the input or output is not in the base coins
221             is_underlying = _from not in base_coins or _to not in base_coins
222         else:
223             # not a metapool so no underlying exchange method
224             is_underlying = False
225 
226     # perform / verify input transfer
227     if _from == ETH_ADDRESS:
228         eth_amount = _amount
229     else:
230         response: Bytes[32] = raw_call(
231             _from,
232             _abi_encode(
233                 _sender,
234                 self,
235                 _amount,
236                 method_id=method_id("transferFrom(address,address,uint256)"),
237             ),
238             max_outsize=32,
239         )
240         if len(response) != 0:
241             assert convert(response, bool)
242 
243     # approve input token
244     if _from != ETH_ADDRESS and not self.is_approved[_from][_pool]:
245         response: Bytes[32] = raw_call(
246             _from,
247             _abi_encode(
248                 _pool,
249                 MAX_UINT256,
250                 method_id=method_id("approve(address,uint256)"),
251             ),
252             max_outsize=32,
253         )
254         if len(response) != 0:
255             assert convert(response, bool)
256         self.is_approved[_from][_pool] = True
257 
258     # perform coin exchange
259     if is_underlying:
260         CurvePool(_pool).exchange_underlying(i, j, _amount, _expected, value=eth_amount)
261     else:
262         CurvePool(_pool).exchange(i, j, _amount, _expected, value=eth_amount)
263 
264     # perform output transfer
265     if _to == ETH_ADDRESS:
266         received_amount = self.balance
267         raw_call(_receiver, b"", value=self.balance)
268     else:
269         received_amount = ERC20(_to).balanceOf(self)
270         response: Bytes[32] = raw_call(
271             _to,
272             _abi_encode(
273                 _receiver,
274                 received_amount,
275                 method_id=method_id("transfer(address,uint256)"),
276             ),
277             max_outsize=32,
278         )
279         if len(response) != 0:
280             assert convert(response, bool)
281 
282     log TokenExchange(_sender, _receiver, _pool, _from, _to, _amount, received_amount)
283 
284     return received_amount
285 
286 
287 @internal
288 def _crypto_exchange(
289     _pool: address,
290     _from: address,
291     _to: address,
292     _amount: uint256,
293     _expected: uint256,
294     _sender: address,
295     _receiver: address,
296 ) -> uint256:
297 
298     assert not self.is_killed
299 
300     initial: address = _from
301     target: address = _to
302 
303     if _from == ETH_ADDRESS:
304         initial = WETH_ADDRESS
305     if _to == ETH_ADDRESS:
306         target = WETH_ADDRESS
307 
308     eth_amount: uint256 = 0
309     received_amount: uint256 = 0
310 
311     i: uint256 = 0
312     j: uint256 = 0
313     i, j = CryptoRegistry(self.crypto_registry).get_coin_indices(_pool, initial, target)  # dev: no market
314 
315     # perform / verify input transfer
316     if _from == ETH_ADDRESS:
317         eth_amount = _amount
318     else:
319         response: Bytes[32] = raw_call(
320             _from,
321             _abi_encode(
322                 _sender,
323                 self,
324                 _amount,
325                 method_id=method_id("transferFrom(address,address,uint256)"),
326             ),
327             max_outsize=32,
328         )
329         if len(response) != 0:
330             assert convert(response, bool)
331 
332     # approve input token
333     if not self.is_approved[_from][_pool]:
334         response: Bytes[32] = raw_call(
335             _from,
336             _abi_encode(
337                 _pool,
338                 MAX_UINT256,
339                 method_id=method_id("approve(address,uint256)"),
340             ),
341             max_outsize=32,
342         )
343         if len(response) != 0:
344             assert convert(response, bool)
345         self.is_approved[_from][_pool] = True
346 
347     # perform coin exchange
348     if ETH_ADDRESS in [_from, _to]:
349         CryptoPoolETH(_pool).exchange(i, j, _amount, _expected, True, value=eth_amount)
350     else:
351         CryptoPool(_pool).exchange(i, j, _amount, _expected)
352 
353     # perform output transfer
354     if _to == ETH_ADDRESS:
355         received_amount = self.balance
356         raw_call(_receiver, b"", value=self.balance)
357     else:
358         received_amount = ERC20(_to).balanceOf(self)
359         response: Bytes[32] = raw_call(
360             _to,
361             _abi_encode(
362                 _receiver,
363                 received_amount,
364                 method_id=method_id("transfer(address,uint256)"),
365             ),
366             max_outsize=32,
367         )
368         if len(response) != 0:
369             assert convert(response, bool)
370 
371     log TokenExchange(_sender, _receiver, _pool, _from, _to, _amount, received_amount)
372 
373     return received_amount
374 
375 
376 
377 @payable
378 @external
379 @nonreentrant("lock")
380 def exchange_with_best_rate(
381     _from: address,
382     _to: address,
383     _amount: uint256,
384     _expected: uint256,
385     _receiver: address = msg.sender,
386 ) -> uint256:
387     """
388     @notice Perform an exchange using the pool that offers the best rate
389     @dev Prior to calling this function, the caller must approve
390          this contract to transfer `_amount` coins from `_from`
391          Does NOT check rates in factory-deployed pools
392     @param _from Address of coin being sent
393     @param _to Address of coin being received
394     @param _amount Quantity of `_from` being sent
395     @param _expected Minimum quantity of `_from` received
396            in order for the transaction to succeed
397     @param _receiver Address to transfer the received tokens to
398     @return uint256 Amount received
399     """
400     if _from == ETH_ADDRESS:
401         assert _amount == msg.value, "Incorrect ETH amount"
402     else:
403         assert msg.value == 0, "Incorrect ETH amount"
404 
405     registry: address = self.registry
406     best_pool: address = ZERO_ADDRESS
407     max_dy: uint256 = 0
408     for i in range(65536):
409         pool: address = Registry(registry).find_pool_for_coins(_from, _to, i)
410         if pool == ZERO_ADDRESS:
411             break
412         dy: uint256 = self._get_exchange_amount(registry, pool, _from, _to, _amount)
413         if dy > max_dy:
414             best_pool = pool
415             max_dy = dy
416 
417     return self._exchange(registry, best_pool, _from, _to, _amount, _expected, msg.sender, _receiver)
418 
419 
420 @payable
421 @external
422 @nonreentrant("lock")
423 def exchange(
424     _pool: address,
425     _from: address,
426     _to: address,
427     _amount: uint256,
428     _expected: uint256,
429     _receiver: address = msg.sender,
430 ) -> uint256:
431     """
432     @notice Perform an exchange using a specific pool
433     @dev Prior to calling this function, the caller must approve
434          this contract to transfer `_amount` coins from `_from`
435          Works for both regular and factory-deployed pools
436     @param _pool Address of the pool to use for the swap
437     @param _from Address of coin being sent
438     @param _to Address of coin being received
439     @param _amount Quantity of `_from` being sent
440     @param _expected Minimum quantity of `_from` received
441            in order for the transaction to succeed
442     @param _receiver Address to transfer the received tokens to
443     @return uint256 Amount received
444     """
445     if _from == ETH_ADDRESS:
446         assert _amount == msg.value, "Incorrect ETH amount"
447     else:
448         assert msg.value == 0, "Incorrect ETH amount"
449 
450     if Registry(self.crypto_registry).get_lp_token(_pool) != ZERO_ADDRESS:
451         return self._crypto_exchange(_pool, _from, _to, _amount, _expected, msg.sender, _receiver)
452 
453     registry: address = self.registry
454     if Registry(registry).get_lp_token(_pool) == ZERO_ADDRESS:
455         registry = self.factory_registry
456     return self._exchange(registry, _pool, _from, _to, _amount, _expected, msg.sender, _receiver)
457 
458 
459 @external
460 @payable
461 def exchange_multiple(
462     _route: address[9],
463     _swap_params: uint256[3][4],
464     _amount: uint256,
465     _expected: uint256,
466     _pools: address[4]=[ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS],
467     _receiver: address=msg.sender
468 ) -> uint256:
469     """
470     @notice Perform up to four swaps in a single transaction
471     @dev Routing and swap params must be determined off-chain. This
472          functionality is designed for gas efficiency over ease-of-use.
473     @param _route Array of [initial token, pool, token, pool, token, ...]
474                   The array is iterated until a pool address of 0x00, then the last
475                   given token is transferred to `_receiver`
476     @param _swap_params Multidimensional array of [i, j, swap type] where i and j are the correct
477                         values for the n'th pool in `_route`. The swap type should be 1 for
478                         a stableswap `exchange`, 2 for stableswap `exchange_underlying`, 3
479                         for a cryptoswap `exchange`, 4 for a cryptoswap `exchange_underlying`,
480                         5 for Polygon factory metapools `exchange_underlying`, 6-8 for
481                         underlying coin -> LP token "exchange" (actually `add_liquidity`), 9 and 10
482                         for LP token -> underlying coin "exchange" (actually `remove_liquidity_one_coin`)
483     @param _amount The amount of `_route[0]` token being sent.
484     @param _expected The minimum amount received after the final swap.
485     @param _pools Array of pools for swaps via zap contracts. This parameter is only needed for
486                   Polygon meta-factories underlying swaps.
487     @param _receiver Address to transfer the final output token to.
488     @return Received amount of the final output token
489     """
490     input_token: address = _route[0]
491     amount: uint256 = _amount
492     output_token: address = ZERO_ADDRESS
493 
494     # validate / transfer initial token
495     if input_token == ETH_ADDRESS:
496         assert msg.value == amount
497     else:
498         assert msg.value == 0
499         response: Bytes[32] = raw_call(
500             input_token,
501             _abi_encode(
502                 msg.sender,
503                 self,
504                 amount,
505                 method_id=method_id("transferFrom(address,address,uint256)"),
506             ),
507             max_outsize=32,
508         )
509         if len(response) != 0:
510             assert convert(response, bool)
511 
512     for i in range(1,5):
513         # 4 rounds of iteration to perform up to 4 swaps
514         swap: address = _route[i*2-1]
515         pool: address = _pools[i-1] # Only for Polygon meta-factories underlying swap (swap_type == 4)
516         output_token = _route[i*2]
517         params: uint256[3] = _swap_params[i-1]  # i, j, swap type
518 
519         if not self.is_approved[input_token][swap]:
520             # approve the pool to transfer the input token
521             response: Bytes[32] = raw_call(
522                 input_token,
523                 _abi_encode(
524                     swap,
525                     MAX_UINT256,
526                     method_id=method_id("approve(address,uint256)"),
527                 ),
528                 max_outsize=32,
529             )
530             if len(response) != 0:
531                 assert convert(response, bool)
532             self.is_approved[input_token][swap] = True
533 
534         eth_amount: uint256 = 0
535         if input_token == ETH_ADDRESS:
536             eth_amount = amount
537         # perform the swap according to the swap type
538         if params[2] == 1:
539             CurvePool(swap).exchange(convert(params[0], int128), convert(params[1], int128), amount, 0, value=eth_amount)
540         elif params[2] == 2:
541             CurvePool(swap).exchange_underlying(convert(params[0], int128), convert(params[1], int128), amount, 0, value=eth_amount)
542         elif params[2] == 3:
543             if input_token == ETH_ADDRESS or output_token == ETH_ADDRESS:
544                 CryptoPoolETH(swap).exchange(params[0], params[1], amount, 0, True, value=eth_amount)
545             else:
546                 CryptoPool(swap).exchange(params[0], params[1], amount, 0)
547         elif params[2] == 4:
548             CryptoPool(swap).exchange_underlying(params[0], params[1], amount, 0, value=eth_amount)
549         elif params[2] == 5:
550             PolygonMetaZap(swap).exchange_underlying(pool, convert(params[0], int128), convert(params[1], int128), amount, 0)
551         elif params[2] == 6:
552             _amounts: uint256[2] = [0, 0]
553             _amounts[params[0]] = amount
554             BasePool2Coins(swap).add_liquidity(_amounts, 0)
555         elif params[2] == 7:
556             _amounts: uint256[3] = [0, 0, 0]
557             _amounts[params[0]] = amount
558             BasePool3Coins(swap).add_liquidity(_amounts, 0)
559         elif params[2] == 8:
560             _amounts: uint256[3] = [0, 0, 0]
561             _amounts[params[0]] = amount
562             BaseLendingPool3Coins(swap).add_liquidity(_amounts, 0, True) # aave on Polygon
563         elif params[2] == 9:
564             # The number of coins doesn't matter here
565             BasePool3Coins(swap).remove_liquidity_one_coin(amount, convert(params[1], int128), 0)
566         elif params[2] == 10:
567             # The number of coins doesn't matter here
568             BaseLendingPool3Coins(swap).remove_liquidity_one_coin(amount, convert(params[1], int128), 0, True) # aave on Polygon
569         else:
570             raise "Bad swap type"
571 
572         # update the amount received
573         if output_token == ETH_ADDRESS:
574             amount = self.balance
575         else:
576             amount = ERC20(output_token).balanceOf(self)
577 
578         # sanity check, if the routing data is incorrect we will have a 0 balance and that is bad
579         assert amount != 0, "Received nothing"
580 
581         # check if this was the last swap
582         if i == 4 or _route[i*2+1] == ZERO_ADDRESS:
583             break
584         # if there is another swap, the output token becomes the input for the next round
585         input_token = output_token
586 
587     # validate the final amount received
588     assert amount >= _expected
589 
590     # transfer the final token to the receiver
591     if output_token == ETH_ADDRESS:
592         raw_call(_receiver, b"", value=amount)
593     else:
594         response: Bytes[32] = raw_call(
595             output_token,
596             _abi_encode(
597                 _receiver,
598                 amount,
599                 method_id=method_id("transfer(address,uint256)"),
600             ),
601             max_outsize=32,
602         )
603         if len(response) != 0:
604             assert convert(response, bool)
605 
606     return amount
607 
608 
609 @view
610 @external
611 def get_best_rate(
612     _from: address, _to: address, _amount: uint256, _exclude_pools: address[8] = EMPTY_POOL_LIST
613 ) -> (address, uint256):
614     """
615     @notice Find the pool offering the best rate for a given swap.
616     @dev Checks rates for regular and factory pools
617     @param _from Address of coin being sent
618     @param _to Address of coin being received
619     @param _amount Quantity of `_from` being sent
620     @param _exclude_pools A list of up to 8 addresses which shouldn't be returned
621     @return Pool address, amount received
622     """
623     best_pool: address = ZERO_ADDRESS
624     max_dy: uint256 = 0
625 
626     initial: address = _from
627     target: address = _to
628     if _from == ETH_ADDRESS:
629         initial = WETH_ADDRESS
630     if _to == ETH_ADDRESS:
631         target = WETH_ADDRESS
632 
633     registry: address = self.crypto_registry
634     for i in range(65536):
635         pool: address = Registry(registry).find_pool_for_coins(initial, target, i)
636         if pool == ZERO_ADDRESS:
637             if i == 0:
638                 # we only check for stableswap pools if we did not find any crypto pools
639                 break
640             return best_pool, max_dy
641         elif pool in _exclude_pools:
642             continue
643         dy: uint256 = self._get_crypto_exchange_amount(registry, pool, initial, target, _amount)
644         if dy > max_dy:
645             best_pool = pool
646             max_dy = dy
647 
648     registry = self.registry
649     for i in range(65536):
650         pool: address = Registry(registry).find_pool_for_coins(_from, _to, i)
651         if pool == ZERO_ADDRESS:
652             break
653         elif pool in _exclude_pools:
654             continue
655         dy: uint256 = self._get_exchange_amount(registry, pool, _from, _to, _amount)
656         if dy > max_dy:
657             best_pool = pool
658             max_dy = dy
659 
660     registry = self.factory_registry
661     for i in range(65536):
662         pool: address = Registry(registry).find_pool_for_coins(_from, _to, i)
663         if pool == ZERO_ADDRESS:
664             break
665         elif pool in _exclude_pools:
666             continue
667         if ERC20(pool).totalSupply() == 0:
668             # ignore pools without TVL as the call to `get_dy` will revert
669             continue
670         dy: uint256 = self._get_exchange_amount(registry, pool, _from, _to, _amount)
671         if dy > max_dy:
672             best_pool = pool
673             max_dy = dy
674 
675     return best_pool, max_dy
676 
677 
678 @view
679 @external
680 def get_exchange_amount(_pool: address, _from: address, _to: address, _amount: uint256) -> uint256:
681     """
682     @notice Get the current number of coins received in an exchange
683     @dev Works for both regular and factory-deployed pools
684     @param _pool Pool address
685     @param _from Address of coin to be sent
686     @param _to Address of coin to be received
687     @param _amount Quantity of `_from` to be sent
688     @return Quantity of `_to` to be received
689     """
690 
691     registry: address = self.crypto_registry
692     if Registry(registry).get_lp_token(_pool) != ZERO_ADDRESS:
693         initial: address = _from
694         target: address = _to
695         if _from == ETH_ADDRESS:
696             initial = WETH_ADDRESS
697         if _to == ETH_ADDRESS:
698             target = WETH_ADDRESS
699         return self._get_crypto_exchange_amount(registry, _pool, initial, target, _amount)
700 
701     registry = self.registry
702     if Registry(registry).get_lp_token(_pool) == ZERO_ADDRESS:
703         registry = self.factory_registry
704     return self._get_exchange_amount(registry, _pool, _from, _to, _amount)
705 
706 
707 @view
708 @external
709 def get_input_amount(_pool: address, _from: address, _to: address, _amount: uint256) -> uint256:
710     """
711     @notice Get the current number of coins required to receive the given amount in an exchange
712     @param _pool Pool address
713     @param _from Address of coin to be sent
714     @param _to Address of coin to be received
715     @param _amount Quantity of `_to` to be received
716     @return Quantity of `_from` to be sent
717     """
718     registry: address = self.registry
719 
720     i: int128 = 0
721     j: int128 = 0
722     is_underlying: bool = False
723     i, j, is_underlying = Registry(registry).get_coin_indices(_pool, _from, _to)
724     amp: uint256 = Registry(registry).get_A(_pool)
725     fee: uint256 = Registry(registry).get_fees(_pool)[0]
726 
727     balances: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
728     rates: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
729     decimals: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
730     n_coins: uint256 = Registry(registry).get_n_coins(_pool)[convert(is_underlying, uint256)]
731     if is_underlying:
732         balances = Registry(registry).get_underlying_balances(_pool)
733         decimals = Registry(registry).get_underlying_decimals(_pool)
734         for x in range(MAX_COINS):
735             if x == n_coins:
736                 break
737             rates[x] = 10**18
738     else:
739         balances = Registry(registry).get_balances(_pool)
740         decimals = Registry(registry).get_decimals(_pool)
741         rates = Registry(registry).get_rates(_pool)
742 
743     for x in range(MAX_COINS):
744         if x == n_coins:
745             break
746         decimals[x] = 10 ** (18 - decimals[x])
747 
748     calculator: address = self.pool_calculator[_pool]
749     if calculator == ZERO_ADDRESS:
750         calculator = self.default_calculator
751     return Calculator(calculator).get_dx(n_coins, balances, amp, fee, rates, decimals, i, j, _amount)
752 
753 
754 @view
755 @external
756 def get_exchange_amounts(
757     _pool: address,
758     _from: address,
759     _to: address,
760     _amounts: uint256[CALC_INPUT_SIZE]
761 ) -> uint256[CALC_INPUT_SIZE]:
762     """
763     @notice Get the current number of coins required to receive the given amount in an exchange
764     @param _pool Pool address
765     @param _from Address of coin to be sent
766     @param _to Address of coin to be received
767     @param _amounts Quantity of `_to` to be received
768     @return Quantity of `_from` to be sent
769     """
770     registry: address = self.registry
771 
772     i: int128 = 0
773     j: int128 = 0
774     is_underlying: bool = False
775     balances: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
776     rates: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
777     decimals: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
778 
779     amp: uint256 = Registry(registry).get_A(_pool)
780     fee: uint256 = Registry(registry).get_fees(_pool)[0]
781     i, j, is_underlying = Registry(registry).get_coin_indices(_pool, _from, _to)
782     n_coins: uint256 = Registry(registry).get_n_coins(_pool)[convert(is_underlying, uint256)]
783 
784     if is_underlying:
785         balances = Registry(registry).get_underlying_balances(_pool)
786         decimals = Registry(registry).get_underlying_decimals(_pool)
787         for x in range(MAX_COINS):
788             if x == n_coins:
789                 break
790             rates[x] = 10**18
791     else:
792         balances = Registry(registry).get_balances(_pool)
793         decimals = Registry(registry).get_decimals(_pool)
794         rates = Registry(registry).get_rates(_pool)
795 
796     for x in range(MAX_COINS):
797         if x == n_coins:
798             break
799         decimals[x] = 10 ** (18 - decimals[x])
800 
801     calculator: address = self.pool_calculator[_pool]
802     if calculator == ZERO_ADDRESS:
803         calculator = self.default_calculator
804     return Calculator(calculator).get_dy(n_coins, balances, amp, fee, rates, decimals, i, j, _amounts)
805 
806 
807 @view
808 @external
809 def get_exchange_multiple_amount(
810     _route: address[9],
811     _swap_params: uint256[3][4],
812     _amount: uint256,
813     _pools: address[4]=[ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS]
814 ) -> uint256:
815     """
816     @notice Get the current number the final output tokens received in an exchange
817     @dev Routing and swap params must be determined off-chain. This
818          functionality is designed for gas efficiency over ease-of-use.
819     @param _route Array of [initial token, pool, token, pool, token, ...]
820                   The array is iterated until a pool address of 0x00, then the last
821                   given token is transferred to `_receiver`
822     @param _swap_params Multidimensional array of [i, j, swap type] where i and j are the correct
823                         values for the n'th pool in `_route`. The swap type should be 1 for
824                         a stableswap `exchange`, 2 for stableswap `exchange_underlying`, 3
825                         for a cryptoswap `exchange`, 4 for a cryptoswap `exchange_underlying`,
826                         5 for Polygon factory metapools `exchange_underlying`, 6-8 for
827                         underlying coin -> LP token "exchange" (actually `add_liquidity`), 9 and 10
828                         for LP token -> underlying coin "exchange" (actually `remove_liquidity_one_coin`)
829     @param _amount The amount of `_route[0]` token to be sent.
830     @param _pools Array of pools for swaps via zap contracts. This parameter is only needed for
831                   Polygon meta-factories underlying swaps.
832     @return Expected amount of the final output token
833     """
834     amount: uint256 = _amount
835 
836     for i in range(1,5):
837         # 4 rounds of iteration to perform up to 4 swaps
838         swap: address = _route[i*2-1]
839         pool: address = _pools[i-1] # Only for Polygon meta-factories underlying swap (swap_type == 4)
840         params: uint256[3] = _swap_params[i-1]  # i, j, swap type
841 
842         # Calc output amount according to the swap type
843         if params[2] == 1:
844             amount = CurvePool(swap).get_dy(convert(params[0], int128), convert(params[1], int128), amount)
845         elif params[2] == 2:
846             amount = CurvePool(swap).get_dy_underlying(convert(params[0], int128), convert(params[1], int128), amount)
847         elif params[2] == 3:
848             amount = CryptoPool(swap).get_dy(params[0], params[1], amount)
849         elif params[2] == 4:
850             amount = CryptoPool(swap).get_dy_underlying(params[0], params[1], amount)
851         elif params[2] == 5:
852             amount = CurvePool(pool).get_dy_underlying(convert(params[0], int128), convert(params[1], int128), amount)
853         elif params[2] == 6:
854             _amounts: uint256[2] = [0, 0]
855             _amounts[params[0]] = amount
856             amount = BasePool2Coins(swap).calc_token_amount(_amounts, True)
857         elif params[2] in [7, 8]:
858             _amounts: uint256[3] = [0, 0, 0]
859             _amounts[params[0]] = amount
860             amount = BasePool3Coins(swap).calc_token_amount(_amounts, True)
861         elif params[2] in [9, 10]:
862             # The number of coins doesn't matter here
863             amount = BasePool3Coins(swap).calc_withdraw_one_coin(amount, convert(params[1], int128))
864         else:
865             raise "Bad swap type"
866 
867         # check if this was the last swap
868         if i == 4 or _route[i*2+1] == ZERO_ADDRESS:
869             break
870 
871     return amount
872 
873 
874 @view
875 @external
876 def get_calculator(_pool: address) -> address:
877     """
878     @notice Set calculator contract
879     @dev Used to calculate `get_dy` for a pool
880     @param _pool Pool address
881     @return `CurveCalc` address
882     """
883     calculator: address = self.pool_calculator[_pool]
884     if calculator == ZERO_ADDRESS:
885         return self.default_calculator
886     else:
887         return calculator
888 
889 
890 @external
891 def update_registry_address() -> bool:
892     """
893     @notice Update registry address
894     @dev The registry address is kept in storage to reduce gas costs.
895          If a new registry is deployed this function should be called
896          to update the local address from the address provider.
897     @return bool success
898     """
899     address_provider: address = self.address_provider.address
900     self.registry = AddressProvider(address_provider).get_registry()
901     self.factory_registry = AddressProvider(address_provider).get_address(3)
902     self.crypto_registry = AddressProvider(address_provider).get_address(5)
903 
904     return True
905 
906 
907 @external
908 def set_calculator(_pool: address, _calculator: address) -> bool:
909     """
910     @notice Set calculator contract
911     @dev Used to calculate `get_dy` for a pool
912     @param _pool Pool address
913     @param _calculator `CurveCalc` address
914     @return bool success
915     """
916     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
917 
918     self.pool_calculator[_pool] = _calculator
919 
920     return True
921 
922 
923 @external
924 def set_default_calculator(_calculator: address) -> bool:
925     """
926     @notice Set default calculator contract
927     @dev Used to calculate `get_dy` for a pool
928     @param _calculator `CurveCalc` address
929     @return bool success
930     """
931     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
932 
933     self.default_calculator = _calculator
934 
935     return True
936 
937 
938 @external
939 def claim_balance(_token: address) -> bool:
940     """
941     @notice Transfer an ERC20 or ETH balance held by this contract
942     @dev The entire balance is transferred to the owner
943     @param _token Token address
944     @return bool success
945     """
946     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
947 
948     if _token == ETH_ADDRESS:
949         raw_call(msg.sender, b"", value=self.balance)
950     else:
951         amount: uint256 = ERC20(_token).balanceOf(self)
952         response: Bytes[32] = raw_call(
953             _token,
954             concat(
955                 method_id("transfer(address,uint256)"),
956                 convert(msg.sender, bytes32),
957                 convert(amount, bytes32),
958             ),
959             max_outsize=32,
960         )
961         if len(response) != 0:
962             assert convert(response, bool)
963 
964     return True
965 
966 
967 @external
968 def set_killed(_is_killed: bool) -> bool:
969     """
970     @notice Kill or unkill the contract
971     @param _is_killed Killed status of the contract
972     @return bool success
973     """
974     assert msg.sender == self.address_provider.admin()  # dev: admin-only function
975     self.is_killed = _is_killed
976 
977     return True