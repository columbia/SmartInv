1 # @version 0.2.8
2 """
3 @title Curve bBTC Metapool
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 @dev Utilizes sBTC pool to allow swaps between bBTC / rebBTC / wBTC / sBTC
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 interface CurveToken:
12     def totalSupply() -> uint256: view
13     def mint(_to: address, _value: uint256) -> bool: nonpayable
14     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
15 
16 interface Curve:
17     def coins(i: int128) -> address: view
18     def get_virtual_price() -> uint256: view
19     def calc_token_amount(amounts: uint256[BASE_N_COINS], deposit: bool) -> uint256: view
20     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
21     def fee() -> uint256: view
22     def get_dy(i: int128, j: int128, dx: uint256) -> uint256: view
23     def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256: view
24     def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
25     def add_liquidity(amounts: uint256[BASE_N_COINS], min_mint_amount: uint256): nonpayable
26     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256): nonpayable
27 
28 
29 # Events
30 event TokenExchange:
31     buyer: indexed(address)
32     sold_id: int128
33     tokens_sold: uint256
34     bought_id: int128
35     tokens_bought: uint256
36 
37 event TokenExchangeUnderlying:
38     buyer: indexed(address)
39     sold_id: int128
40     tokens_sold: uint256
41     bought_id: int128
42     tokens_bought: uint256
43 
44 event AddLiquidity:
45     provider: indexed(address)
46     token_amounts: uint256[N_COINS]
47     fees: uint256[N_COINS]
48     invariant: uint256
49     token_supply: uint256
50 
51 event RemoveLiquidity:
52     provider: indexed(address)
53     token_amounts: uint256[N_COINS]
54     fees: uint256[N_COINS]
55     token_supply: uint256
56 
57 event RemoveLiquidityOne:
58     provider: indexed(address)
59     token_amount: uint256
60     coin_amount: uint256
61     token_supply: uint256
62 
63 event RemoveLiquidityImbalance:
64     provider: indexed(address)
65     token_amounts: uint256[N_COINS]
66     fees: uint256[N_COINS]
67     invariant: uint256
68     token_supply: uint256
69 
70 event CommitNewAdmin:
71     deadline: indexed(uint256)
72     admin: indexed(address)
73 
74 event NewAdmin:
75     admin: indexed(address)
76 
77 event CommitNewFee:
78     deadline: indexed(uint256)
79     fee: uint256
80     admin_fee: uint256
81 
82 event NewFee:
83     fee: uint256
84     admin_fee: uint256
85 
86 event RampA:
87     old_A: uint256
88     new_A: uint256
89     initial_time: uint256
90     future_time: uint256
91 
92 event StopRampA:
93     A: uint256
94     t: uint256
95 
96 
97 N_COINS: constant(int128) = 2
98 MAX_COIN: constant(int128) = N_COINS - 1
99 
100 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
101 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
102 PRECISION_MUL: constant(uint256[N_COINS]) = [10000000000, 1]
103 RATES: constant(uint256[N_COINS]) = [10000000000000000000000000000, 1000000000000000000]
104 BASE_N_COINS: constant(int128) = 3
105 
106 # An asset which may have a transfer fee (renBTC)
107 FEE_ASSET: constant(address) = 0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D
108 
109 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
110 MAX_FEE: constant(uint256) = 5 * 10 ** 9
111 MAX_A: constant(uint256) = 10 ** 6
112 MAX_A_CHANGE: constant(uint256) = 10
113 
114 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
115 MIN_RAMP_TIME: constant(uint256) = 86400
116 
117 coins: public(address[N_COINS])
118 balances: public(uint256[N_COINS])
119 fee: public(uint256)  # fee * 1e10
120 admin_fee: public(uint256)  # admin_fee * 1e10
121 
122 owner: public(address)
123 token: public(CurveToken)
124 
125 BASE_CACHE_EXPIRES: constant(int128) = 10 * 60  # 10 min
126 base_pool: public(address)
127 base_virtual_price: public(uint256)
128 base_cache_updated: public(uint256)
129 base_coins: public(address[BASE_N_COINS])
130 
131 A_PRECISION: constant(uint256) = 100
132 initial_A: public(uint256)
133 future_A: public(uint256)
134 initial_A_time: public(uint256)
135 future_A_time: public(uint256)
136 
137 admin_actions_deadline: public(uint256)
138 transfer_ownership_deadline: public(uint256)
139 future_fee: public(uint256)
140 future_admin_fee: public(uint256)
141 future_owner: public(address)
142 
143 is_killed: bool
144 kill_deadline: uint256
145 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
146 
147 
148 @external
149 def __init__(
150     _owner: address,
151     _coins: address[N_COINS],
152     _pool_token: address,
153     _base_pool: address,
154     _A: uint256,
155     _fee: uint256,
156     _admin_fee: uint256
157 ):
158     """
159     @notice Contract constructor
160     @param _owner Contract owner address
161     @param _coins Addresses of ERC20 conracts of coins
162     @param _pool_token Address of the token representing LP share
163     @param _base_pool Address of the base pool (which will have a virtual price)
164     @param _A Amplification coefficient multiplied by n * (n - 1)
165     @param _fee Fee to charge for exchanges
166     @param _admin_fee Admin fee
167     """
168     for i in range(N_COINS):
169         assert _coins[i] != ZERO_ADDRESS
170     self.coins = _coins
171     self.initial_A = _A * A_PRECISION
172     self.future_A = _A * A_PRECISION
173     self.fee = _fee
174     self.admin_fee = _admin_fee
175     self.owner = _owner
176     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
177     self.token = CurveToken(_pool_token)
178 
179     self.base_pool = _base_pool
180     self.base_virtual_price = Curve(_base_pool).get_virtual_price()
181     self.base_cache_updated = block.timestamp
182     for i in range(BASE_N_COINS):
183         _base_coin: address = Curve(_base_pool).coins(i)
184         self.base_coins[i] = _base_coin
185 
186         # approve underlying coins for infinite transfers
187         _response: Bytes[32] = raw_call(
188             _base_coin,
189             concat(
190                 method_id("approve(address,uint256)"),
191                 convert(_base_pool, bytes32),
192                 convert(MAX_UINT256, bytes32),
193             ),
194             max_outsize=32,
195         )
196         if len(_response) > 0:
197             assert convert(_response, bool)
198 
199 
200 @view
201 @internal
202 def _A() -> uint256:
203     """
204     Handle ramping A up or down
205     """
206     t1: uint256 = self.future_A_time
207     A1: uint256 = self.future_A
208 
209     if block.timestamp < t1:
210         A0: uint256 = self.initial_A
211         t0: uint256 = self.initial_A_time
212         # Expressions in uint256 cannot have negative numbers, thus "if"
213         if A1 > A0:
214             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
215         else:
216             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
217 
218     else:  # when t1 == 0 or block.timestamp >= t1
219         return A1
220 
221 
222 @view
223 @external
224 def A() -> uint256:
225     return self._A() / A_PRECISION
226 
227 
228 @view
229 @external
230 def A_precise() -> uint256:
231     return self._A()
232 
233 
234 @view
235 @internal
236 def _xp(vp_rate: uint256) -> uint256[N_COINS]:
237     result: uint256[N_COINS] = RATES
238     result[MAX_COIN] = vp_rate  # virtual price for the metacurrency
239     for i in range(N_COINS):
240         result[i] = result[i] * self.balances[i] / PRECISION
241     return result
242 
243 
244 @pure
245 @internal
246 def _xp_mem(vp_rate: uint256, _balances: uint256[N_COINS]) -> uint256[N_COINS]:
247     result: uint256[N_COINS] = RATES
248     result[MAX_COIN] = vp_rate  # virtual price for the metacurrency
249     for i in range(N_COINS):
250         result[i] = result[i] * _balances[i] / PRECISION
251     return result
252 
253 
254 @internal
255 def _vp_rate() -> uint256:
256     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
257         vprice: uint256 = Curve(self.base_pool).get_virtual_price()
258         self.base_virtual_price = vprice
259         self.base_cache_updated = block.timestamp
260         return vprice
261     else:
262         return self.base_virtual_price
263 
264 
265 @internal
266 @view
267 def _vp_rate_ro() -> uint256:
268     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
269         return Curve(self.base_pool).get_virtual_price()
270     else:
271         return self.base_virtual_price
272 
273 
274 @pure
275 @internal
276 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
277     S: uint256 = 0
278     Dprev: uint256 = 0
279     for _x in xp:
280         S += _x
281     if S == 0:
282         return 0
283 
284     D: uint256 = S
285     Ann: uint256 = amp * N_COINS
286     for _i in range(255):
287         D_P: uint256 = D
288         for _x in xp:
289             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
290         Dprev = D
291         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
292         # Equality with the precision of 1
293         if D > Dprev:
294             if D - Dprev <= 1:
295                 break
296         else:
297             if Dprev - D <= 1:
298                 break
299     return D
300 
301 
302 @view
303 @internal
304 def get_D_mem(vp_rate: uint256, _balances: uint256[N_COINS], amp: uint256) -> uint256:
305     xp: uint256[N_COINS] = self._xp_mem(vp_rate, _balances)
306     return self.get_D(xp, amp)
307 
308 
309 @view
310 @external
311 def get_virtual_price() -> uint256:
312     """
313     @notice The current virtual price of the pool LP token
314     @dev Useful for calculating profits
315     @return LP token virtual price normalized to 1e18
316     """
317     amp: uint256 = self._A()
318     vp_rate: uint256 = self._vp_rate_ro()
319     xp: uint256[N_COINS] = self._xp(vp_rate)
320     D: uint256 = self.get_D(xp, amp)
321     # D is in the units similar to DAI (e.g. converted to precision 1e18)
322     # When balanced, D = n * x_u - total virtual value of the portfolio
323     token_supply: uint256 = self.token.totalSupply()
324     return D * PRECISION / token_supply
325 
326 
327 @view
328 @external
329 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
330     """
331     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
332     @dev This calculation accounts for slippage, but not fees.
333          Needed to prevent front-running, not for precise calculations!
334     @param amounts Amount of each coin being deposited
335     @param is_deposit set True for deposits, False for withdrawals
336     @return Expected amount of LP tokens received
337     """
338     amp: uint256 = self._A()
339     vp_rate: uint256 = self._vp_rate_ro()
340     _balances: uint256[N_COINS] = self.balances
341     D0: uint256 = self.get_D_mem(vp_rate, _balances, amp)
342     for i in range(N_COINS):
343         if is_deposit:
344             _balances[i] += amounts[i]
345         else:
346             _balances[i] -= amounts[i]
347     D1: uint256 = self.get_D_mem(vp_rate, _balances, amp)
348     token_amount: uint256 = self.token.totalSupply()
349     diff: uint256 = 0
350     if is_deposit:
351         diff = D1 - D0
352     else:
353         diff = D0 - D1
354     return diff * token_amount / D0
355 
356 
357 @external
358 @nonreentrant('lock')
359 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
360     """
361     @notice Deposit coins into the pool
362     @param amounts List of amounts of coins to deposit
363     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
364     @return Amount of LP tokens received by depositing
365     """
366     assert not self.is_killed  # dev: is killed
367 
368     amp: uint256 = self._A()
369     vp_rate: uint256 = self._vp_rate()
370     token_supply: uint256 = self.token.totalSupply()
371     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
372     _admin_fee: uint256 = self.admin_fee
373 
374     # Initial invariant
375     D0: uint256 = 0
376     old_balances: uint256[N_COINS] = self.balances
377     if token_supply > 0:
378         D0 = self.get_D_mem(vp_rate, old_balances, amp)
379     new_balances: uint256[N_COINS] = old_balances
380 
381     for i in range(N_COINS):
382         if token_supply == 0:
383             assert amounts[i] > 0  # dev: initial deposit requires all coins
384         # balances store amounts of c-tokens
385         new_balances[i] = old_balances[i] + amounts[i]
386 
387     # Invariant after change
388     D1: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
389     assert D1 > D0
390 
391     # We need to recalculate the invariant accounting for fees
392     # to calculate fair user's share
393     fees: uint256[N_COINS] = empty(uint256[N_COINS])
394     D2: uint256 = D1
395     if token_supply > 0:
396         # Only account for fees if we are not the first to deposit
397         for i in range(N_COINS):
398             ideal_balance: uint256 = D1 * old_balances[i] / D0
399             difference: uint256 = 0
400             if ideal_balance > new_balances[i]:
401                 difference = ideal_balance - new_balances[i]
402             else:
403                 difference = new_balances[i] - ideal_balance
404             fees[i] = _fee * difference / FEE_DENOMINATOR
405             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
406             new_balances[i] -= fees[i]
407         D2 = self.get_D_mem(vp_rate, new_balances, amp)
408     else:
409         self.balances = new_balances
410 
411     # Calculate, how much pool tokens to mint
412     mint_amount: uint256 = 0
413     if token_supply == 0:
414         mint_amount = D1  # Take the dust if there was any
415     else:
416         mint_amount = token_supply * (D2 - D0) / D0
417 
418     assert mint_amount >= min_mint_amount, "Slippage screwed you"
419 
420     # Take coins from the sender
421     for i in range(N_COINS):
422         if amounts[i] > 0:
423             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i])  # dev: failed transfer
424 
425     # Mint pool tokens
426     self.token.mint(msg.sender, mint_amount)
427 
428     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
429 
430     return mint_amount
431 
432 
433 @view
434 @internal
435 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
436     # x in the input is converted to the same price/precision
437 
438     assert i != j       # dev: same coin
439     assert j >= 0       # dev: j below zero
440     assert j < N_COINS  # dev: j above N_COINS
441 
442     # should be unreachable, but good for safety
443     assert i >= 0
444     assert i < N_COINS
445 
446     amp: uint256 = self._A()
447     D: uint256 = self.get_D(xp_, amp)
448 
449     S_: uint256 = 0
450     _x: uint256 = 0
451     y_prev: uint256 = 0
452     c: uint256 = D
453     Ann: uint256 = amp * N_COINS
454 
455     for _i in range(N_COINS):
456         if _i == i:
457             _x = x
458         elif _i != j:
459             _x = xp_[_i]
460         else:
461             continue
462         S_ += _x
463         c = c * D / (_x * N_COINS)
464     c = c * D * A_PRECISION / (Ann * N_COINS)
465     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
466     y: uint256 = D
467     for _i in range(255):
468         y_prev = y
469         y = (y*y + c) / (2 * y + b - D)
470         # Equality with the precision of 1
471         if y > y_prev:
472             if y - y_prev <= 1:
473                 break
474         else:
475             if y_prev - y <= 1:
476                 break
477     return y
478 
479 
480 @view
481 @external
482 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
483     # dx and dy in c-units
484     rates: uint256[N_COINS] = RATES
485     rates[MAX_COIN] = self._vp_rate_ro()
486     xp: uint256[N_COINS] = self._xp(rates[MAX_COIN])
487 
488     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
489     y: uint256 = self.get_y(i, j, x, xp)
490     dy: uint256 = xp[j] - y - 1
491     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
492     return (dy - _fee) * PRECISION / rates[j]
493 
494 
495 @view
496 @external
497 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
498     # dx and dy in underlying units
499     vp_rate: uint256 = self._vp_rate_ro()
500     xp: uint256[N_COINS] = self._xp(vp_rate)
501     precisions: uint256[N_COINS] = PRECISION_MUL
502     _base_pool: address = self.base_pool
503 
504     # Use base_i or base_j if they are >= 0
505     base_i: int128 = i - MAX_COIN
506     base_j: int128 = j - MAX_COIN
507     meta_i: int128 = MAX_COIN
508     meta_j: int128 = MAX_COIN
509     if base_i < 0:
510         meta_i = i
511     if base_j < 0:
512         meta_j = j
513 
514     x: uint256 = 0
515     if base_i < 0:
516         x = xp[i] + dx * precisions[i]
517     else:
518         if base_j < 0:
519             # i is from BasePool
520             # At first, get the amount of pool tokens
521             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
522             base_inputs[base_i] = dx
523             # Token amount transformed to underlying "dollars"
524             x = Curve(_base_pool).calc_token_amount(base_inputs, True) * vp_rate / PRECISION
525             # Accounting for deposit/withdraw fees approximately
526             x -= x * Curve(_base_pool).fee() / (2 * FEE_DENOMINATOR)
527             # Adding number of pool tokens
528             x += xp[MAX_COIN]
529         else:
530             # If both are from the base pool
531             return Curve(_base_pool).get_dy(base_i, base_j, dx)
532 
533     # This pool is involved only when in-pool assets are used
534     y: uint256 = self.get_y(meta_i, meta_j, x, xp)
535     dy: uint256 = xp[meta_j] - y - 1
536     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
537 
538     # If output is going via the metapool
539     if base_j < 0:
540         dy /= precisions[meta_j]
541     else:
542         # j is from BasePool
543         # The fee is already accounted for
544         dy = Curve(_base_pool).calc_withdraw_one_coin(dy * PRECISION / vp_rate, base_j)
545 
546     return dy
547 
548 
549 @external
550 @nonreentrant('lock')
551 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
552     """
553     @notice Perform an exchange between two coins
554     @dev Index values can be found via the `coins` public getter method
555     @param i Index value for the coin to send
556     @param j Index valie of the coin to recieve
557     @param dx Amount of `i` being exchanged
558     @param min_dy Minimum amount of `j` to receive
559     @return Actual amount of `j` received
560     """
561     assert not self.is_killed  # dev: is killed
562     rates: uint256[N_COINS] = RATES
563     rates[MAX_COIN] = self._vp_rate()
564 
565     old_balances: uint256[N_COINS] = self.balances
566     xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
567 
568     x: uint256 = xp[i] + dx * rates[i] / PRECISION
569     y: uint256 = self.get_y(i, j, x, xp)
570 
571     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
572     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
573 
574     # Convert all to real units
575     dy = (dy - dy_fee) * PRECISION / rates[j]
576     assert dy >= min_dy, "Too few coins in result"
577 
578     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
579     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
580 
581     # Change balances exactly in same way as we change actual ERC20 coin amounts
582     self.balances[i] = old_balances[i] + dx
583     # When rounding errors happen, we undercharge admin fee in favor of LP
584     self.balances[j] = old_balances[j] - dy - dy_admin_fee
585 
586     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)
587     assert ERC20(self.coins[j]).transfer(msg.sender, dy)
588 
589     log TokenExchange(msg.sender, i, dx, j, dy)
590 
591     return dy
592 
593 
594 @external
595 @nonreentrant('lock')
596 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
597     """
598     @notice Perform an exchange between two underlying coins
599     @dev Index values can be found via the `underlying_coins` public getter method
600     @param i Index value for the underlying coin to send
601     @param j Index valie of the underlying coin to recieve
602     @param dx Amount of `i` being exchanged
603     @param min_dy Minimum amount of `j` to receive
604     @return Actual amount of `j` received
605     """
606     assert not self.is_killed  # dev: is killed
607     rates: uint256[N_COINS] = RATES
608     rates[MAX_COIN] = self._vp_rate()
609     _base_pool: address = self.base_pool
610 
611     # Use base_i or base_j if they are >= 0
612     base_i: int128 = i - MAX_COIN
613     base_j: int128 = j - MAX_COIN
614     meta_i: int128 = MAX_COIN
615     meta_j: int128 = MAX_COIN
616     if base_i < 0:
617         meta_i = i
618     if base_j < 0:
619         meta_j = j
620     dy: uint256 = 0
621 
622     # Addresses for input and output coins
623     input_coin: address = ZERO_ADDRESS
624     if base_i < 0:
625         input_coin = self.coins[i]
626     else:
627         input_coin = self.base_coins[base_i]
628     output_coin: address = ZERO_ADDRESS
629     if base_j < 0:
630         output_coin = self.coins[j]
631     else:
632         output_coin = self.base_coins[base_j]
633 
634     # Handle potential Tether fees
635     dx_w_fee: uint256 = dx
636     if input_coin == FEE_ASSET:
637         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self)
638     # "safeTransferFrom" which works for ERC20s which return bool or not
639     _response: Bytes[32] = raw_call(
640         input_coin,
641         concat(
642             method_id("transferFrom(address,address,uint256)"),
643             convert(msg.sender, bytes32),
644             convert(self, bytes32),
645             convert(dx, bytes32),
646         ),
647         max_outsize=32,
648     )  # dev: failed transfer
649     if len(_response) > 0:
650         assert convert(_response, bool)  # dev: failed transfer
651     # end "safeTransferFrom"
652     # Handle potential Tether fees
653     if input_coin == FEE_ASSET:
654         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self) - dx_w_fee
655 
656     if base_i < 0 or base_j < 0:
657         old_balances: uint256[N_COINS] = self.balances
658         xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
659 
660         x: uint256 = 0
661         if base_i < 0:
662             x = xp[i] + dx_w_fee * rates[i] / PRECISION
663         else:
664             # i is from BasePool
665             # At first, get the amount of pool tokens
666             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
667             base_inputs[base_i] = dx_w_fee
668             coin_i: address = self.coins[MAX_COIN]
669             # Deposit and measure delta
670             x = ERC20(coin_i).balanceOf(self)
671             Curve(_base_pool).add_liquidity(base_inputs, 0)
672             # Need to convert pool token to "virtual" units using rates
673             # dx is also different now
674             dx_w_fee = ERC20(coin_i).balanceOf(self) - x
675             x = dx_w_fee * rates[MAX_COIN] / PRECISION
676             # Adding number of pool tokens
677             x += xp[MAX_COIN]
678 
679         y: uint256 = self.get_y(meta_i, meta_j, x, xp)
680 
681         # Either a real coin or token
682         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
683         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
684 
685         # Convert all to real units
686         # Works for both pool coins and real coins
687         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
688 
689         dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
690         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
691 
692         # Change balances exactly in same way as we change actual ERC20 coin amounts
693         self.balances[meta_i] = old_balances[meta_i] + dx_w_fee
694         # When rounding errors happen, we undercharge admin fee in favor of LP
695         self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee
696 
697         # Withdraw from the base pool if needed
698         if base_j >= 0:
699             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
700             Curve(_base_pool).remove_liquidity_one_coin(dy, base_j, 0)
701             dy = ERC20(output_coin).balanceOf(self) - out_amount
702 
703         assert dy >= min_dy, "Too few coins in result"
704 
705     else:
706         # If both are from the base pool
707         dy = ERC20(output_coin).balanceOf(self)
708         Curve(_base_pool).exchange(base_i, base_j, dx_w_fee, min_dy)
709         dy = ERC20(output_coin).balanceOf(self) - dy
710 
711     # "safeTransfer" which works for ERC20s which return bool or not
712     _response = raw_call(
713         output_coin,
714         concat(
715             method_id("transfer(address,uint256)"),
716             convert(msg.sender, bytes32),
717             convert(dy, bytes32),
718         ),
719         max_outsize=32,
720     )  # dev: failed transfer
721     if len(_response) > 0:
722         assert convert(_response, bool)  # dev: failed transfer
723     # end "safeTransfer"
724 
725     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
726 
727     return dy
728 
729 
730 @external
731 @nonreentrant('lock')
732 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
733     """
734     @notice Withdraw coins from the pool
735     @dev Withdrawal amounts are based on current deposit ratios
736     @param _amount Quantity of LP tokens to burn in the withdrawal
737     @param min_amounts Minimum amounts of underlying coins to receive
738     @return List of amounts of coins that were withdrawn
739     """
740     total_supply: uint256 = self.token.totalSupply()
741     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
742     fees: uint256[N_COINS] = empty(uint256[N_COINS])  # Fees are unused but we've got them historically in event
743 
744     for i in range(N_COINS):
745         value: uint256 = self.balances[i] * _amount / total_supply
746         assert value >= min_amounts[i], "Too few coins in result"
747         self.balances[i] -= value
748         amounts[i] = value
749         assert ERC20(self.coins[i]).transfer(msg.sender, value)
750 
751     self.token.burnFrom(msg.sender, _amount)  # dev: insufficient funds
752 
753     log RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
754 
755     return amounts
756 
757 
758 @external
759 @nonreentrant('lock')
760 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256:
761     """
762     @notice Withdraw coins from the pool in an imbalanced amount
763     @param amounts List of amounts of underlying coins to withdraw
764     @param max_burn_amount Maximum amount of LP token to burn in the withdrawal
765     @return Actual amount of the LP token burned in the withdrawal
766     """
767     assert not self.is_killed  # dev: is killed
768 
769     amp: uint256 = self._A()
770     vp_rate: uint256 = self._vp_rate()
771 
772     token_supply: uint256 = self.token.totalSupply()
773     assert token_supply != 0  # dev: zero total supply
774     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
775     _admin_fee: uint256 = self.admin_fee
776 
777     old_balances: uint256[N_COINS] = self.balances
778     new_balances: uint256[N_COINS] = old_balances
779     D0: uint256 = self.get_D_mem(vp_rate, old_balances, amp)
780     for i in range(N_COINS):
781         new_balances[i] -= amounts[i]
782     D1: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
783 
784     fees: uint256[N_COINS] = empty(uint256[N_COINS])
785     for i in range(N_COINS):
786         ideal_balance: uint256 = D1 * old_balances[i] / D0
787         difference: uint256 = 0
788         if ideal_balance > new_balances[i]:
789             difference = ideal_balance - new_balances[i]
790         else:
791             difference = new_balances[i] - ideal_balance
792         fees[i] = _fee * difference / FEE_DENOMINATOR
793         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
794         new_balances[i] -= fees[i]
795     D2: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
796 
797     token_amount: uint256 = (D0 - D2) * token_supply / D0
798     assert token_amount != 0  # dev: zero tokens burned
799     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
800     assert token_amount <= max_burn_amount, "Slippage screwed you"
801 
802     self.token.burnFrom(msg.sender, token_amount)  # dev: insufficient funds
803     for i in range(N_COINS):
804         if amounts[i] != 0:
805             assert ERC20(self.coins[i]).transfer(msg.sender, amounts[i])
806 
807     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
808 
809     return token_amount
810 
811 
812 @view
813 @internal
814 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
815     """
816     Calculate x[i] if one reduces D from being calculated for xp to D
817 
818     Done by solving quadratic equation iteratively.
819     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
820     x_1**2 + b*x_1 = c
821 
822     x_1 = (x_1**2 + c) / (2*x_1 + b)
823     """
824     # x in the input is converted to the same price/precision
825 
826     assert i >= 0  # dev: i below zero
827     assert i < N_COINS  # dev: i above N_COINS
828 
829     S_: uint256 = 0
830     _x: uint256 = 0
831     y_prev: uint256 = 0
832 
833     c: uint256 = D
834     Ann: uint256 = A_ * N_COINS
835 
836     for _i in range(N_COINS):
837         if _i != i:
838             _x = xp[_i]
839         else:
840             continue
841         S_ += _x
842         c = c * D / (_x * N_COINS)
843     c = c * D * A_PRECISION / (Ann * N_COINS)
844     b: uint256 = S_ + D * A_PRECISION / Ann
845     y: uint256 = D
846     for _i in range(255):
847         y_prev = y
848         y = (y*y + c) / (2 * y + b - D)
849         # Equality with the precision of 1
850         if y > y_prev:
851             if y - y_prev <= 1:
852                 break
853         else:
854             if y_prev - y <= 1:
855                 break
856     return y
857 
858 
859 @view
860 @internal
861 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, vp_rate: uint256) -> (uint256, uint256, uint256):
862     # First, need to calculate
863     # * Get current D
864     # * Solve Eqn against y_i for D - _token_amount
865     amp: uint256 = self._A()
866     xp: uint256[N_COINS] = self._xp(vp_rate)
867     D0: uint256 = self.get_D(xp, amp)
868 
869     total_supply: uint256 = self.token.totalSupply()
870     D1: uint256 = D0 - _token_amount * D0 / total_supply
871     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
872 
873     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
874     rates: uint256[N_COINS] = RATES
875     rates[MAX_COIN] = vp_rate
876 
877     xp_reduced: uint256[N_COINS] = xp
878     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
879 
880     for j in range(N_COINS):
881         dx_expected: uint256 = 0
882         if j == i:
883             dx_expected = xp[j] * D1 / D0 - new_y
884         else:
885             dx_expected = xp[j] - xp[j] * D1 / D0
886         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
887 
888     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
889     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
890 
891     return dy, dy_0 - dy, total_supply
892 
893 
894 @view
895 @external
896 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
897     """
898     @notice Calculate the amount received when withdrawing a single coin
899     @param _token_amount Amount of LP tokens to burn in the withdrawal
900     @param i Index value of the coin to withdraw
901     @return Amount of coin received
902     """
903     vp_rate: uint256 = self._vp_rate_ro()
904     return self._calc_withdraw_one_coin(_token_amount, i, vp_rate)[0]
905 
906 
907 @external
908 @nonreentrant('lock')
909 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
910     """
911     @notice Withdraw a single coin from the pool
912     @param _token_amount Amount of LP tokens to burn in the withdrawal
913     @param i Index value of the coin to withdraw
914     @param _min_amount Minimum amount of coin to receive
915     @return Amount of coin received
916     """
917     assert not self.is_killed  # dev: is killed
918 
919     vp_rate: uint256 = self._vp_rate()
920     dy: uint256 = 0
921     dy_fee: uint256 = 0
922     total_supply: uint256 = 0
923     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_token_amount, i, vp_rate)
924     assert dy >= _min_amount, "Not enough coins removed"
925 
926     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
927     self.token.burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
928     assert ERC20(self.coins[i]).transfer(msg.sender, dy)
929 
930     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
931 
932     return dy
933 
934 
935 ### Admin functions ###
936 @external
937 def ramp_A(_future_A: uint256, _future_time: uint256):
938     assert msg.sender == self.owner  # dev: only owner
939     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
940     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
941 
942     _initial_A: uint256 = self._A()
943     _future_A_p: uint256 = _future_A * A_PRECISION
944 
945     assert _future_A > 0 and _future_A < MAX_A
946     if _future_A_p < _initial_A:
947         assert _future_A_p * MAX_A_CHANGE >= _initial_A
948     else:
949         assert _future_A_p <= _initial_A * MAX_A_CHANGE
950 
951     self.initial_A = _initial_A
952     self.future_A = _future_A_p
953     self.initial_A_time = block.timestamp
954     self.future_A_time = _future_time
955 
956     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
957 
958 
959 @external
960 def stop_ramp_A():
961     assert msg.sender == self.owner  # dev: only owner
962 
963     current_A: uint256 = self._A()
964     self.initial_A = current_A
965     self.future_A = current_A
966     self.initial_A_time = block.timestamp
967     self.future_A_time = block.timestamp
968     # now (block.timestamp < t1) is always False, so we return saved A
969 
970     log StopRampA(current_A, block.timestamp)
971 
972 
973 @external
974 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
975     assert msg.sender == self.owner  # dev: only owner
976     assert self.admin_actions_deadline == 0  # dev: active action
977     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
978     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
979 
980     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
981     self.admin_actions_deadline = _deadline
982     self.future_fee = new_fee
983     self.future_admin_fee = new_admin_fee
984 
985     log CommitNewFee(_deadline, new_fee, new_admin_fee)
986 
987 
988 @external
989 def apply_new_fee():
990     assert msg.sender == self.owner  # dev: only owner
991     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
992     assert self.admin_actions_deadline != 0  # dev: no active action
993 
994     self.admin_actions_deadline = 0
995     _fee: uint256 = self.future_fee
996     _admin_fee: uint256 = self.future_admin_fee
997     self.fee = _fee
998     self.admin_fee = _admin_fee
999 
1000     log NewFee(_fee, _admin_fee)
1001 
1002 
1003 @external
1004 def revert_new_parameters():
1005     assert msg.sender == self.owner  # dev: only owner
1006 
1007     self.admin_actions_deadline = 0
1008 
1009 
1010 @external
1011 def commit_transfer_ownership(_owner: address):
1012     assert msg.sender == self.owner  # dev: only owner
1013     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1014 
1015     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1016     self.transfer_ownership_deadline = _deadline
1017     self.future_owner = _owner
1018 
1019     log CommitNewAdmin(_deadline, _owner)
1020 
1021 
1022 @external
1023 def apply_transfer_ownership():
1024     assert msg.sender == self.owner  # dev: only owner
1025     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1026     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1027 
1028     self.transfer_ownership_deadline = 0
1029     _owner: address = self.future_owner
1030     self.owner = _owner
1031 
1032     log NewAdmin(_owner)
1033 
1034 
1035 @external
1036 def revert_transfer_ownership():
1037     assert msg.sender == self.owner  # dev: only owner
1038 
1039     self.transfer_ownership_deadline = 0
1040 
1041 
1042 @view
1043 @external
1044 def admin_balances(i: uint256) -> uint256:
1045     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1046 
1047 
1048 @external
1049 def withdraw_admin_fees():
1050     assert msg.sender == self.owner  # dev: only owner
1051 
1052     for i in range(N_COINS):
1053         c: address = self.coins[i]
1054         value: uint256 = ERC20(c).balanceOf(self) - self.balances[i]
1055         if value > 0:
1056             assert ERC20(c).transfer(msg.sender, value)
1057 
1058 
1059 @external
1060 def donate_admin_fees():
1061     assert msg.sender == self.owner  # dev: only owner
1062     for i in range(N_COINS):
1063         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
1064 
1065 
1066 @external
1067 def kill_me():
1068     assert msg.sender == self.owner  # dev: only owner
1069     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1070     self.is_killed = True
1071 
1072 
1073 @external
1074 def unkill_me():
1075     assert msg.sender == self.owner  # dev: only owner
1076     self.is_killed = False