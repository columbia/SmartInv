1 # @version 0.2.5
2 """
3 @title Curve USDN Metapool
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 @dev Utilizes 3Pool to allow swaps between USDN / DAI / USDC / USDT
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 interface CurveToken:
12     def totalSupply() -> uint256: view
13     def mint(_to: address, _value: uint256) -> bool: nonpayable
14     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
15 
16 
17 interface Curve:
18     def coins(i: uint256) -> address: view
19     def get_virtual_price() -> uint256: view
20     def calc_token_amount(amounts: uint256[BASE_N_COINS], deposit: bool) -> uint256: view
21     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
22     def fee() -> uint256: view
23     def get_dy(i: int128, j: int128, dx: uint256) -> uint256: view
24     def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256: view
25     def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
26     def add_liquidity(amounts: uint256[BASE_N_COINS], min_mint_amount: uint256): nonpayable
27     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256): nonpayable
28 
29 
30 # Events
31 event TokenExchange:
32     buyer: indexed(address)
33     sold_id: int128
34     tokens_sold: uint256
35     bought_id: int128
36     tokens_bought: uint256
37 
38 event TokenExchangeUnderlying:
39     buyer: indexed(address)
40     sold_id: int128
41     tokens_sold: uint256
42     bought_id: int128
43     tokens_bought: uint256
44 
45 event AddLiquidity:
46     provider: indexed(address)
47     token_amounts: uint256[N_COINS]
48     fees: uint256[N_COINS]
49     invariant: uint256
50     token_supply: uint256
51 
52 event RemoveLiquidity:
53     provider: indexed(address)
54     token_amounts: uint256[N_COINS]
55     fees: uint256[N_COINS]
56     token_supply: uint256
57 
58 event RemoveLiquidityOne:
59     provider: indexed(address)
60     token_amount: uint256
61     coin_amount: uint256
62     token_supply: uint256
63 
64 event RemoveLiquidityImbalance:
65     provider: indexed(address)
66     token_amounts: uint256[N_COINS]
67     fees: uint256[N_COINS]
68     invariant: uint256
69     token_supply: uint256
70 
71 event CommitNewAdmin:
72     deadline: indexed(uint256)
73     admin: indexed(address)
74 
75 event NewAdmin:
76     admin: indexed(address)
77 
78 event CommitNewFee:
79     deadline: indexed(uint256)
80     fee: uint256
81     admin_fee: uint256
82 
83 event NewFee:
84     fee: uint256
85     admin_fee: uint256
86 
87 event RampA:
88     old_A: uint256
89     new_A: uint256
90     initial_time: uint256
91     future_time: uint256
92 
93 event StopRampA:
94     A: uint256
95     t: uint256
96 
97 
98 N_COINS: constant(int128) = 2
99 MAX_COIN: constant(int128) = N_COINS - 1
100 
101 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
102 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
103 PRECISION_MUL: constant(uint256[N_COINS]) = [1, 1]
104 RATES: constant(uint256[N_COINS]) = [1000000000000000000, 1000000000000000000]
105 
106 BASE_N_COINS: constant(int128) = 3
107 N_ALL_COINS: constant(int128) = N_COINS + BASE_N_COINS - 1
108 BASE_PRECISION_MUL: constant(uint256[BASE_N_COINS]) = [1, 1000000000000, 1000000000000]
109 BASE_RATES: constant(uint256[BASE_N_COINS]) = [1000000000000000000, 1000000000000000000000000000000, 1000000000000000000000000000000]
110 
111 # An asset which may have a transfer fee (USDT)
112 FEE_ASSET: constant(address) = 0xdAC17F958D2ee523a2206206994597C13D831ec7
113 
114 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
115 MAX_FEE: constant(uint256) = 5 * 10 ** 9
116 MAX_A: constant(uint256) = 10 ** 6
117 MAX_A_CHANGE: constant(uint256) = 10
118 
119 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
120 MIN_RAMP_TIME: constant(uint256) = 86400
121 
122 coins: public(address[N_COINS])
123 balances: public(uint256[N_COINS])
124 fee: public(uint256)  # fee * 1e10
125 admin_fee: public(uint256)  # admin_fee * 1e10
126 
127 owner: public(address)
128 token: CurveToken
129 
130 # Token corresponding to the pool is always the last one
131 BASE_POOL_COINS: constant(int128) = 3
132 BASE_CACHE_EXPIRES: constant(int128) = 10 * 60  # 10 min
133 base_pool: public(address)
134 base_virtual_price: public(uint256)
135 base_cache_updated: public(uint256)
136 base_coins: public(address[BASE_POOL_COINS])
137 
138 A_PRECISION: constant(uint256) = 100
139 initial_A: public(uint256)
140 future_A: public(uint256)
141 initial_A_time: public(uint256)
142 future_A_time: public(uint256)
143 
144 admin_actions_deadline: public(uint256)
145 transfer_ownership_deadline: public(uint256)
146 future_fee: public(uint256)
147 future_admin_fee: public(uint256)
148 future_owner: public(address)
149 
150 is_killed: bool
151 kill_deadline: uint256
152 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
153 
154 
155 @external
156 def __init__(
157     _owner: address,
158     _coins: address[N_COINS],
159     _pool_token: address,
160     _base_pool: address,
161     _A: uint256,
162     _fee: uint256,
163     _admin_fee: uint256
164 ):
165     """
166     @notice Contract constructor
167     @param _owner Contract owner address
168     @param _coins Addresses of ERC20 conracts of coins
169     @param _pool_token Address of the token representing LP share
170     @param _base_pool Address of the base pool (which will have a virtual price)
171     @param _A Amplification coefficient multiplied by n * (n - 1)
172     @param _fee Fee to charge for exchanges
173     @param _admin_fee Admin fee
174     """
175     for i in range(N_COINS):
176         assert _coins[i] != ZERO_ADDRESS
177     self.coins = _coins
178     self.initial_A = _A * A_PRECISION
179     self.future_A = _A * A_PRECISION
180     self.fee = _fee
181     self.admin_fee = _admin_fee
182     self.owner = _owner
183     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
184     self.token = CurveToken(_pool_token)
185 
186     self.base_pool = _base_pool
187     self.base_virtual_price = Curve(_base_pool).get_virtual_price()
188     self.base_cache_updated = block.timestamp
189     for i in range(BASE_POOL_COINS):
190         _base_coin: address = Curve(_base_pool).coins(convert(i, uint256))
191         self.base_coins[i] = _base_coin
192 
193         # approve underlying coins for infinite transfers
194         _response: Bytes[32] = raw_call(
195             _base_coin,
196             concat(
197                 method_id("approve(address,uint256)"),
198                 convert(_base_pool, bytes32),
199                 convert(MAX_UINT256, bytes32),
200             ),
201             max_outsize=32,
202         )
203         if len(_response) > 0:
204             assert convert(_response, bool)
205 
206 
207 @view
208 @internal
209 def _A() -> uint256:
210     """
211     Handle ramping A up or down
212     """
213     t1: uint256 = self.future_A_time
214     A1: uint256 = self.future_A
215 
216     if block.timestamp < t1:
217         A0: uint256 = self.initial_A
218         t0: uint256 = self.initial_A_time
219         # Expressions in uint256 cannot have negative numbers, thus "if"
220         if A1 > A0:
221             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
222         else:
223             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
224 
225     else:  # when t1 == 0 or block.timestamp >= t1
226         return A1
227 
228 
229 @view
230 @external
231 def A() -> uint256:
232     return self._A() / A_PRECISION
233 
234 
235 @view
236 @external
237 def A_precise() -> uint256:
238     return self._A()
239 
240 
241 @view
242 @internal
243 def _xp(vp_rate: uint256) -> uint256[N_COINS]:
244     result: uint256[N_COINS] = RATES
245     result[MAX_COIN] = vp_rate  # virtual price for the metacurrency
246     for i in range(N_COINS):
247         result[i] = result[i] * self.balances[i] / PRECISION
248     return result
249 
250 
251 @pure
252 @internal
253 def _xp_mem(vp_rate: uint256, _balances: uint256[N_COINS]) -> uint256[N_COINS]:
254     result: uint256[N_COINS] = RATES
255     result[MAX_COIN] = vp_rate  # virtual price for the metacurrency
256     for i in range(N_COINS):
257         result[i] = result[i] * _balances[i] / PRECISION
258     return result
259 
260 
261 @internal
262 def _vp_rate() -> uint256:
263     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
264         vprice: uint256 = Curve(self.base_pool).get_virtual_price()
265         self.base_virtual_price = vprice
266         self.base_cache_updated = block.timestamp
267         return vprice
268     else:
269         return self.base_virtual_price
270 
271 
272 @internal
273 @view
274 def _vp_rate_ro() -> uint256:
275     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
276         return Curve(self.base_pool).get_virtual_price()
277     else:
278         return self.base_virtual_price
279 
280 
281 @pure
282 @internal
283 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
284     S: uint256 = 0
285     Dprev: uint256 = 0
286     for _x in xp:
287         S += _x
288     if S == 0:
289         return 0
290 
291     D: uint256 = S
292     Ann: uint256 = amp * N_COINS
293     for _i in range(255):
294         D_P: uint256 = D
295         for _x in xp:
296             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
297         Dprev = D
298         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
299         # Equality with the precision of 1
300         if D > Dprev:
301             if D - Dprev <= 1:
302                 break
303         else:
304             if Dprev - D <= 1:
305                 break
306     return D
307 
308 
309 @view
310 @internal
311 def get_D_mem(vp_rate: uint256, _balances: uint256[N_COINS], amp: uint256) -> uint256:
312     xp: uint256[N_COINS] = self._xp_mem(vp_rate, _balances)
313     return self.get_D(xp, amp)
314 
315 
316 @view
317 @external
318 def get_virtual_price() -> uint256:
319     """
320     @notice The current virtual price of the pool LP token
321     @dev Useful for calculating profits
322     @return LP token virtual price normalized to 1e18
323     """
324     amp: uint256 = self._A()
325     vp_rate: uint256 = self._vp_rate_ro()
326     xp: uint256[N_COINS] = self._xp(vp_rate)
327     D: uint256 = self.get_D(xp, amp)
328     # D is in the units similar to DAI (e.g. converted to precision 1e18)
329     # When balanced, D = n * x_u - total virtual value of the portfolio
330     token_supply: uint256 = self.token.totalSupply()
331     return D * PRECISION / token_supply
332 
333 
334 @view
335 @external
336 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
337     """
338     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
339     @dev This calculation accounts for slippage, but not fees.
340          Needed to prevent front-running, not for precise calculations!
341     @param amounts Amount of each coin being deposited
342     @param is_deposit set True for deposits, False for withdrawals
343     @return Expected amount of LP tokens received
344     """
345     amp: uint256 = self._A()
346     vp_rate: uint256 = self._vp_rate_ro()
347     _balances: uint256[N_COINS] = self.balances
348     D0: uint256 = self.get_D_mem(vp_rate, _balances, amp)
349     for i in range(N_COINS):
350         if is_deposit:
351             _balances[i] += amounts[i]
352         else:
353             _balances[i] -= amounts[i]
354     D1: uint256 = self.get_D_mem(vp_rate, _balances, amp)
355     token_amount: uint256 = self.token.totalSupply()
356     diff: uint256 = 0
357     if is_deposit:
358         diff = D1 - D0
359     else:
360         diff = D0 - D1
361     return diff * token_amount / D0
362 
363 
364 @external
365 @nonreentrant('lock')
366 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
367     """
368     @notice Deposit coins into the pool
369     @param amounts List of amounts of coins to deposit
370     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
371     @return Amount of LP tokens received by depositing
372     """
373     assert not self.is_killed  # dev: is killed
374 
375     amp: uint256 = self._A()
376     vp_rate: uint256 = self._vp_rate()
377     token_supply: uint256 = self.token.totalSupply()
378     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
379     _admin_fee: uint256 = self.admin_fee
380 
381     # Initial invariant
382     D0: uint256 = 0
383     old_balances: uint256[N_COINS] = self.balances
384     if token_supply > 0:
385         D0 = self.get_D_mem(vp_rate, old_balances, amp)
386     new_balances: uint256[N_COINS] = old_balances
387 
388     for i in range(N_COINS):
389         if token_supply == 0:
390             assert amounts[i] > 0  # dev: initial deposit requires all coins
391         # balances store amounts of c-tokens
392         new_balances[i] = old_balances[i] + amounts[i]
393 
394     # Invariant after change
395     D1: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
396     assert D1 > D0
397 
398     # We need to recalculate the invariant accounting for fees
399     # to calculate fair user's share
400     fees: uint256[N_COINS] = empty(uint256[N_COINS])
401     D2: uint256 = D1
402     if token_supply > 0:
403         # Only account for fees if we are not the first to deposit
404         for i in range(N_COINS):
405             ideal_balance: uint256 = D1 * old_balances[i] / D0
406             difference: uint256 = 0
407             if ideal_balance > new_balances[i]:
408                 difference = ideal_balance - new_balances[i]
409             else:
410                 difference = new_balances[i] - ideal_balance
411             fees[i] = _fee * difference / FEE_DENOMINATOR
412             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
413             new_balances[i] -= fees[i]
414         D2 = self.get_D_mem(vp_rate, new_balances, amp)
415     else:
416         self.balances = new_balances
417 
418     # Calculate, how much pool tokens to mint
419     mint_amount: uint256 = 0
420     if token_supply == 0:
421         mint_amount = D1  # Take the dust if there was any
422     else:
423         mint_amount = token_supply * (D2 - D0) / D0
424 
425     assert mint_amount >= min_mint_amount, "Slippage screwed you"
426 
427     # Take coins from the sender
428     for i in range(N_COINS):
429         if amounts[i] > 0:
430             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i])  # dev: failed transfer
431 
432     # Mint pool tokens
433     self.token.mint(msg.sender, mint_amount)
434 
435     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
436 
437     return mint_amount
438 
439 
440 @view
441 @internal
442 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
443     # x in the input is converted to the same price/precision
444 
445     assert i != j       # dev: same coin
446     assert j >= 0       # dev: j below zero
447     assert j < N_COINS  # dev: j above N_COINS
448 
449     # should be unreachable, but good for safety
450     assert i >= 0
451     assert i < N_COINS
452 
453     amp: uint256 = self._A()
454     D: uint256 = self.get_D(xp_, amp)
455 
456     S_: uint256 = 0
457     _x: uint256 = 0
458     y_prev: uint256 = 0
459     c: uint256 = D
460     Ann: uint256 = amp * N_COINS
461 
462     for _i in range(N_COINS):
463         if _i == i:
464             _x = x
465         elif _i != j:
466             _x = xp_[_i]
467         else:
468             continue
469         S_ += _x
470         c = c * D / (_x * N_COINS)
471     c = c * D * A_PRECISION / (Ann * N_COINS)
472     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
473     y: uint256 = D
474     for _i in range(255):
475         y_prev = y
476         y = (y*y + c) / (2 * y + b - D)
477         # Equality with the precision of 1
478         if y > y_prev:
479             if y - y_prev <= 1:
480                 break
481         else:
482             if y_prev - y <= 1:
483                 break
484     return y
485 
486 
487 @view
488 @external
489 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
490     # dx and dy in c-units
491     rates: uint256[N_COINS] = RATES
492     rates[MAX_COIN] = self._vp_rate_ro()
493     xp: uint256[N_COINS] = self._xp(rates[MAX_COIN])
494 
495     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
496     y: uint256 = self.get_y(i, j, x, xp)
497     dy: uint256 = xp[j] - y - 1
498     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
499     return (dy - _fee) * PRECISION / rates[j]
500 
501 
502 @view
503 @external
504 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
505     # dx and dy in underlying units
506     vp_rate: uint256 = self._vp_rate_ro()
507     xp: uint256[N_COINS] = self._xp(vp_rate)
508     precisions: uint256[N_COINS] = PRECISION_MUL
509     _base_pool: address = self.base_pool
510 
511     # Use base_i or base_j if they are >= 0
512     base_i: int128 = i - MAX_COIN
513     base_j: int128 = j - MAX_COIN
514     meta_i: int128 = MAX_COIN
515     meta_j: int128 = MAX_COIN
516     if base_i < 0:
517         meta_i = i
518     if base_j < 0:
519         meta_j = j
520 
521     x: uint256 = 0
522     if base_i < 0:
523         x = xp[i] + dx * precisions[i]
524     else:
525         if base_j < 0:
526             # i is from BasePool
527             # At first, get the amount of pool tokens
528             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
529             base_inputs[base_i] = dx
530             # Token amount transformed to underlying "dollars"
531             x = Curve(_base_pool).calc_token_amount(base_inputs, True) * vp_rate / PRECISION
532             # Accounting for deposit/withdraw fees approximately
533             x -= x * Curve(_base_pool).fee() / (2 * FEE_DENOMINATOR)
534             # Adding number of pool tokens
535             x += xp[MAX_COIN]
536         else:
537             # If both are from the base pool
538             return Curve(_base_pool).get_dy(base_i, base_j, dx)
539 
540     # This pool is involved only when in-pool assets are used
541     y: uint256 = self.get_y(meta_i, meta_j, x, xp)
542     dy: uint256 = xp[meta_j] - y - 1
543     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
544 
545     # If output is going via the metapool
546     if base_j < 0:
547         dy /= precisions[meta_j]
548     else:
549         # j is from BasePool
550         # The fee is already accounted for
551         dy = Curve(_base_pool).calc_withdraw_one_coin(dy * PRECISION / vp_rate, base_j)
552 
553     return dy
554 
555 
556 @external
557 @nonreentrant('lock')
558 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
559     """
560     @notice Perform an exchange between two coins
561     @dev Index values can be found via the `coins` public getter method
562     @param i Index value for the coin to send
563     @param j Index valie of the coin to recieve
564     @param dx Amount of `i` being exchanged
565     @param min_dy Minimum amount of `j` to receive
566     @return Actual amount of `j` received
567     """
568     assert not self.is_killed  # dev: is killed
569     rates: uint256[N_COINS] = RATES
570     rates[MAX_COIN] = self._vp_rate()
571 
572     old_balances: uint256[N_COINS] = self.balances
573     xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
574 
575     x: uint256 = xp[i] + dx * rates[i] / PRECISION
576     y: uint256 = self.get_y(i, j, x, xp)
577 
578     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
579     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
580 
581     # Convert all to real units
582     dy = (dy - dy_fee) * PRECISION / rates[j]
583     assert dy >= min_dy, "Too few coins in result"
584 
585     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
586     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
587 
588     # Change balances exactly in same way as we change actual ERC20 coin amounts
589     self.balances[i] = old_balances[i] + dx
590     # When rounding errors happen, we undercharge admin fee in favor of LP
591     self.balances[j] = old_balances[j] - dy - dy_admin_fee
592 
593     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)
594     assert ERC20(self.coins[j]).transfer(msg.sender, dy)
595 
596     log TokenExchange(msg.sender, i, dx, j, dy)
597 
598     return dy
599 
600 
601 @external
602 @nonreentrant('lock')
603 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
604     """
605     @notice Perform an exchange between two underlying coins
606     @dev Index values can be found via the `underlying_coins` public getter method
607     @param i Index value for the underlying coin to send
608     @param j Index valie of the underlying coin to recieve
609     @param dx Amount of `i` being exchanged
610     @param min_dy Minimum amount of `j` to receive
611     @return Actual amount of `j` received
612     """
613     assert not self.is_killed  # dev: is killed
614     rates: uint256[N_COINS] = RATES
615     rates[MAX_COIN] = self._vp_rate()
616     _base_pool: address = self.base_pool
617 
618     # Use base_i or base_j if they are >= 0
619     base_i: int128 = i - MAX_COIN
620     base_j: int128 = j - MAX_COIN
621     meta_i: int128 = MAX_COIN
622     meta_j: int128 = MAX_COIN
623     if base_i < 0:
624         meta_i = i
625     if base_j < 0:
626         meta_j = j
627     dy: uint256 = 0
628 
629     # Addresses for input and output coins
630     input_coin: address = ZERO_ADDRESS
631     if base_i < 0:
632         input_coin = self.coins[i]
633     else:
634         input_coin = self.base_coins[base_i]
635     output_coin: address = ZERO_ADDRESS
636     if base_j < 0:
637         output_coin = self.coins[j]
638     else:
639         output_coin = self.base_coins[base_j]
640 
641     # Handle potential Tether fees
642     dx_w_fee: uint256 = dx
643     if input_coin == FEE_ASSET:
644         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self)
645     # "safeTransferFrom" which works for ERC20s which return bool or not
646     _response: Bytes[32] = raw_call(
647         input_coin,
648         concat(
649             method_id("transferFrom(address,address,uint256)"),
650             convert(msg.sender, bytes32),
651             convert(self, bytes32),
652             convert(dx, bytes32),
653         ),
654         max_outsize=32,
655     )  # dev: failed transfer
656     if len(_response) > 0:
657         assert convert(_response, bool)  # dev: failed transfer
658     # end "safeTransferFrom"
659     # Handle potential Tether fees
660     if input_coin == FEE_ASSET:
661         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self) - dx_w_fee
662 
663     if base_i < 0 or base_j < 0:
664         old_balances: uint256[N_COINS] = self.balances
665         xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
666 
667         x: uint256 = 0
668         if base_i < 0:
669             x = xp[i] + dx_w_fee * rates[i] / PRECISION
670         else:
671             # i is from BasePool
672             # At first, get the amount of pool tokens
673             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
674             base_inputs[base_i] = dx_w_fee
675             coin_i: address = self.coins[MAX_COIN]
676             # Deposit and measure delta
677             x = ERC20(coin_i).balanceOf(self)
678             Curve(_base_pool).add_liquidity(base_inputs, 0)
679             # Need to convert pool token to "virtual" units using rates
680             # dx is also different now
681             dx_w_fee = ERC20(coin_i).balanceOf(self) - x
682             x = dx_w_fee * rates[MAX_COIN] / PRECISION
683             # Adding number of pool tokens
684             x += xp[MAX_COIN]
685 
686         y: uint256 = self.get_y(meta_i, meta_j, x, xp)
687 
688         # Either a real coin or token
689         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
690         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
691 
692         # Convert all to real units
693         # Works for both pool coins and real coins
694         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
695 
696         dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
697         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
698 
699         # Change balances exactly in same way as we change actual ERC20 coin amounts
700         self.balances[meta_i] = old_balances[meta_i] + dx_w_fee
701         # When rounding errors happen, we undercharge admin fee in favor of LP
702         self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee
703 
704         # Withdraw from the base pool if needed
705         if base_j >= 0:
706             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
707             Curve(_base_pool).remove_liquidity_one_coin(dy, base_j, 0)
708             dy = ERC20(output_coin).balanceOf(self) - out_amount
709 
710         assert dy >= min_dy, "Too few coins in result"
711 
712     else:
713         # If both are from the base pool
714         dy = ERC20(output_coin).balanceOf(self)
715         Curve(_base_pool).exchange(base_i, base_j, dx_w_fee, min_dy)
716         dy = ERC20(output_coin).balanceOf(self) - dy
717 
718     # "safeTransfer" which works for ERC20s which return bool or not
719     _response = raw_call(
720         output_coin,
721         concat(
722             method_id("transfer(address,uint256)"),
723             convert(msg.sender, bytes32),
724             convert(dy, bytes32),
725         ),
726         max_outsize=32,
727     )  # dev: failed transfer
728     if len(_response) > 0:
729         assert convert(_response, bool)  # dev: failed transfer
730     # end "safeTransfer"
731 
732     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
733 
734     return dy
735 
736 
737 @external
738 @nonreentrant('lock')
739 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
740     """
741     @notice Withdraw coins from the pool
742     @dev Withdrawal amounts are based on current deposit ratios
743     @param _amount Quantity of LP tokens to burn in the withdrawal
744     @param min_amounts Minimum amounts of underlying coins to receive
745     @return List of amounts of coins that were withdrawn
746     """
747     total_supply: uint256 = self.token.totalSupply()
748     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
749     fees: uint256[N_COINS] = empty(uint256[N_COINS])  # Fees are unused but we've got them historically in event
750 
751     for i in range(N_COINS):
752         value: uint256 = self.balances[i] * _amount / total_supply
753         assert value >= min_amounts[i], "Too few coins in result"
754         self.balances[i] -= value
755         amounts[i] = value
756         assert ERC20(self.coins[i]).transfer(msg.sender, value)
757 
758     self.token.burnFrom(msg.sender, _amount)  # dev: insufficient funds
759 
760     log RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
761 
762     return amounts
763 
764 
765 @external
766 @nonreentrant('lock')
767 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256:
768     """
769     @notice Withdraw coins from the pool in an imbalanced amount
770     @param amounts List of amounts of underlying coins to withdraw
771     @param max_burn_amount Maximum amount of LP token to burn in the withdrawal
772     @return Actual amount of the LP token burned in the withdrawal
773     """
774     assert not self.is_killed  # dev: is killed
775 
776     amp: uint256 = self._A()
777     vp_rate: uint256 = self._vp_rate()
778 
779     token_supply: uint256 = self.token.totalSupply()
780     assert token_supply != 0  # dev: zero total supply
781     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
782     _admin_fee: uint256 = self.admin_fee
783 
784     old_balances: uint256[N_COINS] = self.balances
785     new_balances: uint256[N_COINS] = old_balances
786     D0: uint256 = self.get_D_mem(vp_rate, old_balances, amp)
787     for i in range(N_COINS):
788         new_balances[i] -= amounts[i]
789     D1: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
790 
791     fees: uint256[N_COINS] = empty(uint256[N_COINS])
792     for i in range(N_COINS):
793         ideal_balance: uint256 = D1 * old_balances[i] / D0
794         difference: uint256 = 0
795         if ideal_balance > new_balances[i]:
796             difference = ideal_balance - new_balances[i]
797         else:
798             difference = new_balances[i] - ideal_balance
799         fees[i] = _fee * difference / FEE_DENOMINATOR
800         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
801         new_balances[i] -= fees[i]
802     D2: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
803 
804     token_amount: uint256 = (D0 - D2) * token_supply / D0
805     assert token_amount != 0  # dev: zero tokens burned
806     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
807     assert token_amount <= max_burn_amount, "Slippage screwed you"
808 
809     self.token.burnFrom(msg.sender, token_amount)  # dev: insufficient funds
810     for i in range(N_COINS):
811         if amounts[i] != 0:
812             assert ERC20(self.coins[i]).transfer(msg.sender, amounts[i])
813 
814     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
815 
816     return token_amount
817 
818 
819 @view
820 @internal
821 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
822     """
823     Calculate x[i] if one reduces D from being calculated for xp to D
824 
825     Done by solving quadratic equation iteratively.
826     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
827     x_1**2 + b*x_1 = c
828 
829     x_1 = (x_1**2 + c) / (2*x_1 + b)
830     """
831     # x in the input is converted to the same price/precision
832 
833     assert i >= 0  # dev: i below zero
834     assert i < N_COINS  # dev: i above N_COINS
835 
836     S_: uint256 = 0
837     _x: uint256 = 0
838     y_prev: uint256 = 0
839 
840     c: uint256 = D
841     Ann: uint256 = A_ * N_COINS
842 
843     for _i in range(N_COINS):
844         if _i != i:
845             _x = xp[_i]
846         else:
847             continue
848         S_ += _x
849         c = c * D / (_x * N_COINS)
850     c = c * D * A_PRECISION / (Ann * N_COINS)
851     b: uint256 = S_ + D * A_PRECISION / Ann
852     y: uint256 = D
853     for _i in range(255):
854         y_prev = y
855         y = (y*y + c) / (2 * y + b - D)
856         # Equality with the precision of 1
857         if y > y_prev:
858             if y - y_prev <= 1:
859                 break
860         else:
861             if y_prev - y <= 1:
862                 break
863     return y
864 
865 
866 @view
867 @internal
868 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, vp_rate: uint256) -> (uint256, uint256, uint256):
869     # First, need to calculate
870     # * Get current D
871     # * Solve Eqn against y_i for D - _token_amount
872     amp: uint256 = self._A()
873     xp: uint256[N_COINS] = self._xp(vp_rate)
874     D0: uint256 = self.get_D(xp, amp)
875 
876     total_supply: uint256 = self.token.totalSupply()
877     D1: uint256 = D0 - _token_amount * D0 / total_supply
878     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
879 
880     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
881     rates: uint256[N_COINS] = RATES
882     rates[MAX_COIN] = vp_rate
883 
884     xp_reduced: uint256[N_COINS] = xp
885     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
886 
887     for j in range(N_COINS):
888         dx_expected: uint256 = 0
889         if j == i:
890             dx_expected = xp[j] * D1 / D0 - new_y
891         else:
892             dx_expected = xp[j] - xp[j] * D1 / D0
893         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
894 
895     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
896     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
897 
898     return dy, dy_0 - dy, total_supply
899 
900 
901 @view
902 @external
903 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
904     """
905     @notice Calculate the amount received when withdrawing a single coin
906     @param _token_amount Amount of LP tokens to burn in the withdrawal
907     @param i Index value of the coin to withdraw
908     @return Amount of coin received
909     """
910     vp_rate: uint256 = self._vp_rate_ro()
911     return self._calc_withdraw_one_coin(_token_amount, i, vp_rate)[0]
912 
913 
914 @external
915 @nonreentrant('lock')
916 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
917     """
918     @notice Withdraw a single coin from the pool
919     @param _token_amount Amount of LP tokens to burn in the withdrawal
920     @param i Index value of the coin to withdraw
921     @param _min_amount Minimum amount of coin to receive
922     @return Amount of coin received
923     """
924     assert not self.is_killed  # dev: is killed
925 
926     vp_rate: uint256 = self._vp_rate()
927     dy: uint256 = 0
928     dy_fee: uint256 = 0
929     total_supply: uint256 = 0
930     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_token_amount, i, vp_rate)
931     assert dy >= _min_amount, "Not enough coins removed"
932 
933     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
934     self.token.burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
935     assert ERC20(self.coins[i]).transfer(msg.sender, dy)
936 
937     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
938 
939     return dy
940 
941 
942 ### Admin functions ###
943 @external
944 def ramp_A(_future_A: uint256, _future_time: uint256):
945     assert msg.sender == self.owner  # dev: only owner
946     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
947     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
948 
949     _initial_A: uint256 = self._A()
950     _future_A_p: uint256 = _future_A * A_PRECISION
951 
952     assert _future_A > 0 and _future_A < MAX_A
953     if _future_A_p < _initial_A:
954         assert _future_A_p * MAX_A_CHANGE >= _initial_A
955     else:
956         assert _future_A_p <= _initial_A * MAX_A_CHANGE
957 
958     self.initial_A = _initial_A
959     self.future_A = _future_A_p
960     self.initial_A_time = block.timestamp
961     self.future_A_time = _future_time
962 
963     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
964 
965 
966 @external
967 def stop_ramp_A():
968     assert msg.sender == self.owner  # dev: only owner
969 
970     current_A: uint256 = self._A()
971     self.initial_A = current_A
972     self.future_A = current_A
973     self.initial_A_time = block.timestamp
974     self.future_A_time = block.timestamp
975     # now (block.timestamp < t1) is always False, so we return saved A
976 
977     log StopRampA(current_A, block.timestamp)
978 
979 
980 @external
981 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
982     assert msg.sender == self.owner  # dev: only owner
983     assert self.admin_actions_deadline == 0  # dev: active action
984     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
985     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
986 
987     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
988     self.admin_actions_deadline = _deadline
989     self.future_fee = new_fee
990     self.future_admin_fee = new_admin_fee
991 
992     log CommitNewFee(_deadline, new_fee, new_admin_fee)
993 
994 
995 @external
996 def apply_new_fee():
997     assert msg.sender == self.owner  # dev: only owner
998     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
999     assert self.admin_actions_deadline != 0  # dev: no active action
1000 
1001     self.admin_actions_deadline = 0
1002     _fee: uint256 = self.future_fee
1003     _admin_fee: uint256 = self.future_admin_fee
1004     self.fee = _fee
1005     self.admin_fee = _admin_fee
1006 
1007     log NewFee(_fee, _admin_fee)
1008 
1009 
1010 @external
1011 def revert_new_parameters():
1012     assert msg.sender == self.owner  # dev: only owner
1013 
1014     self.admin_actions_deadline = 0
1015 
1016 
1017 @external
1018 def commit_transfer_ownership(_owner: address):
1019     assert msg.sender == self.owner  # dev: only owner
1020     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1021 
1022     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1023     self.transfer_ownership_deadline = _deadline
1024     self.future_owner = _owner
1025 
1026     log CommitNewAdmin(_deadline, _owner)
1027 
1028 
1029 @external
1030 def apply_transfer_ownership():
1031     assert msg.sender == self.owner  # dev: only owner
1032     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1033     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1034 
1035     self.transfer_ownership_deadline = 0
1036     _owner: address = self.future_owner
1037     self.owner = _owner
1038 
1039     log NewAdmin(_owner)
1040 
1041 
1042 @external
1043 def revert_transfer_ownership():
1044     assert msg.sender == self.owner  # dev: only owner
1045 
1046     self.transfer_ownership_deadline = 0
1047 
1048 
1049 @view
1050 @external
1051 def admin_balances(i: uint256) -> uint256:
1052     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1053 
1054 
1055 @external
1056 def withdraw_admin_fees():
1057     assert msg.sender == self.owner  # dev: only owner
1058 
1059     for i in range(N_COINS):
1060         c: address = self.coins[i]
1061         value: uint256 = ERC20(c).balanceOf(self) - self.balances[i]
1062         if value > 0:
1063             assert ERC20(c).transfer(msg.sender, value)
1064 
1065 
1066 @external
1067 def donate_admin_fees():
1068     assert msg.sender == self.owner  # dev: only owner
1069     for i in range(N_COINS):
1070         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
1071 
1072 
1073 @external
1074 def kill_me():
1075     assert msg.sender == self.owner  # dev: only owner
1076     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1077     self.is_killed = True
1078 
1079 
1080 @external
1081 def unkill_me():
1082     assert msg.sender == self.owner  # dev: only owner
1083     self.is_killed = False