1 # @version 0.2.7
2 """
3 @title Curve tBTC Metapool
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 @dev Utilizes 3Pool to allow swaps between tBTC / DAI / USDC / USDT
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
102 PRECISION_MUL: constant(uint256[N_COINS]) = [1, 1]
103 RATES: constant(uint256[N_COINS]) = [1000000000000000000, 1000000000000000000]
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
125 # Token corresponding to the pool is always the last one
126 BASE_POOL_COINS: constant(int128) = 3
127 BASE_CACHE_EXPIRES: constant(int128) = 10 * 60  # 10 min
128 base_pool: public(address)
129 base_virtual_price: public(uint256)
130 base_cache_updated: public(uint256)
131 base_coins: public(address[BASE_POOL_COINS])
132 
133 A_PRECISION: constant(uint256) = 100
134 initial_A: public(uint256)
135 future_A: public(uint256)
136 initial_A_time: public(uint256)
137 future_A_time: public(uint256)
138 
139 admin_actions_deadline: public(uint256)
140 transfer_ownership_deadline: public(uint256)
141 future_fee: public(uint256)
142 future_admin_fee: public(uint256)
143 future_owner: public(address)
144 
145 is_killed: bool
146 kill_deadline: uint256
147 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
148 
149 
150 @external
151 def __init__(
152     _owner: address,
153     _coins: address[N_COINS],
154     _pool_token: address,
155     _base_pool: address,
156     _A: uint256,
157     _fee: uint256,
158     _admin_fee: uint256
159 ):
160     """
161     @notice Contract constructor
162     @param _owner Contract owner address
163     @param _coins Addresses of ERC20 conracts of coins
164     @param _pool_token Address of the token representing LP share
165     @param _base_pool Address of the base pool (which will have a virtual price)
166     @param _A Amplification coefficient multiplied by n * (n - 1)
167     @param _fee Fee to charge for exchanges
168     @param _admin_fee Admin fee
169     """
170     for i in range(N_COINS):
171         assert _coins[i] != ZERO_ADDRESS
172     self.coins = _coins
173     self.initial_A = _A * A_PRECISION
174     self.future_A = _A * A_PRECISION
175     self.fee = _fee
176     self.admin_fee = _admin_fee
177     self.owner = _owner
178     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
179     self.token = CurveToken(_pool_token)
180 
181     self.base_pool = _base_pool
182     self.base_virtual_price = Curve(_base_pool).get_virtual_price()
183     self.base_cache_updated = block.timestamp
184     for i in range(BASE_POOL_COINS):
185         _base_coin: address = Curve(_base_pool).coins(i)
186         self.base_coins[i] = _base_coin
187 
188         # approve underlying coins for infinite transfers
189         _response: Bytes[32] = raw_call(
190             _base_coin,
191             concat(
192                 method_id("approve(address,uint256)"),
193                 convert(_base_pool, bytes32),
194                 convert(MAX_UINT256, bytes32),
195             ),
196             max_outsize=32,
197         )
198         if len(_response) > 0:
199             assert convert(_response, bool)
200 
201 
202 @view
203 @internal
204 def _A() -> uint256:
205     """
206     Handle ramping A up or down
207     """
208     t1: uint256 = self.future_A_time
209     A1: uint256 = self.future_A
210 
211     if block.timestamp < t1:
212         A0: uint256 = self.initial_A
213         t0: uint256 = self.initial_A_time
214         # Expressions in uint256 cannot have negative numbers, thus "if"
215         if A1 > A0:
216             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
217         else:
218             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
219 
220     else:  # when t1 == 0 or block.timestamp >= t1
221         return A1
222 
223 
224 @view
225 @external
226 def A() -> uint256:
227     return self._A() / A_PRECISION
228 
229 
230 @view
231 @external
232 def A_precise() -> uint256:
233     return self._A()
234 
235 
236 @view
237 @internal
238 def _xp(vp_rate: uint256) -> uint256[N_COINS]:
239     result: uint256[N_COINS] = RATES
240     result[MAX_COIN] = vp_rate  # virtual price for the metacurrency
241     for i in range(N_COINS):
242         result[i] = result[i] * self.balances[i] / PRECISION
243     return result
244 
245 
246 @pure
247 @internal
248 def _xp_mem(vp_rate: uint256, _balances: uint256[N_COINS]) -> uint256[N_COINS]:
249     result: uint256[N_COINS] = RATES
250     result[MAX_COIN] = vp_rate  # virtual price for the metacurrency
251     for i in range(N_COINS):
252         result[i] = result[i] * _balances[i] / PRECISION
253     return result
254 
255 
256 @internal
257 def _vp_rate() -> uint256:
258     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
259         vprice: uint256 = Curve(self.base_pool).get_virtual_price()
260         self.base_virtual_price = vprice
261         self.base_cache_updated = block.timestamp
262         return vprice
263     else:
264         return self.base_virtual_price
265 
266 
267 @internal
268 @view
269 def _vp_rate_ro() -> uint256:
270     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
271         return Curve(self.base_pool).get_virtual_price()
272     else:
273         return self.base_virtual_price
274 
275 
276 @pure
277 @internal
278 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
279     S: uint256 = 0
280     Dprev: uint256 = 0
281     for _x in xp:
282         S += _x
283     if S == 0:
284         return 0
285 
286     D: uint256 = S
287     Ann: uint256 = amp * N_COINS
288     for _i in range(255):
289         D_P: uint256 = D
290         for _x in xp:
291             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
292         Dprev = D
293         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
294         # Equality with the precision of 1
295         if D > Dprev:
296             if D - Dprev <= 1:
297                 break
298         else:
299             if Dprev - D <= 1:
300                 break
301     return D
302 
303 
304 @view
305 @internal
306 def get_D_mem(vp_rate: uint256, _balances: uint256[N_COINS], amp: uint256) -> uint256:
307     xp: uint256[N_COINS] = self._xp_mem(vp_rate, _balances)
308     return self.get_D(xp, amp)
309 
310 
311 @view
312 @external
313 def get_virtual_price() -> uint256:
314     """
315     @notice The current virtual price of the pool LP token
316     @dev Useful for calculating profits
317     @return LP token virtual price normalized to 1e18
318     """
319     amp: uint256 = self._A()
320     vp_rate: uint256 = self._vp_rate_ro()
321     xp: uint256[N_COINS] = self._xp(vp_rate)
322     D: uint256 = self.get_D(xp, amp)
323     # D is in the units similar to DAI (e.g. converted to precision 1e18)
324     # When balanced, D = n * x_u - total virtual value of the portfolio
325     token_supply: uint256 = self.token.totalSupply()
326     return D * PRECISION / token_supply
327 
328 
329 @view
330 @external
331 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
332     """
333     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
334     @dev This calculation accounts for slippage, but not fees.
335          Needed to prevent front-running, not for precise calculations!
336     @param amounts Amount of each coin being deposited
337     @param is_deposit set True for deposits, False for withdrawals
338     @return Expected amount of LP tokens received
339     """
340     amp: uint256 = self._A()
341     vp_rate: uint256 = self._vp_rate_ro()
342     _balances: uint256[N_COINS] = self.balances
343     D0: uint256 = self.get_D_mem(vp_rate, _balances, amp)
344     for i in range(N_COINS):
345         if is_deposit:
346             _balances[i] += amounts[i]
347         else:
348             _balances[i] -= amounts[i]
349     D1: uint256 = self.get_D_mem(vp_rate, _balances, amp)
350     token_amount: uint256 = self.token.totalSupply()
351     diff: uint256 = 0
352     if is_deposit:
353         diff = D1 - D0
354     else:
355         diff = D0 - D1
356     return diff * token_amount / D0
357 
358 
359 @external
360 @nonreentrant('lock')
361 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
362     """
363     @notice Deposit coins into the pool
364     @param amounts List of amounts of coins to deposit
365     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
366     @return Amount of LP tokens received by depositing
367     """
368     assert not self.is_killed  # dev: is killed
369 
370     amp: uint256 = self._A()
371     vp_rate: uint256 = self._vp_rate()
372     token_supply: uint256 = self.token.totalSupply()
373     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
374     _admin_fee: uint256 = self.admin_fee
375 
376     # Initial invariant
377     D0: uint256 = 0
378     old_balances: uint256[N_COINS] = self.balances
379     if token_supply > 0:
380         D0 = self.get_D_mem(vp_rate, old_balances, amp)
381     new_balances: uint256[N_COINS] = old_balances
382 
383     for i in range(N_COINS):
384         if token_supply == 0:
385             assert amounts[i] > 0  # dev: initial deposit requires all coins
386         # balances store amounts of c-tokens
387         new_balances[i] = old_balances[i] + amounts[i]
388 
389     # Invariant after change
390     D1: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
391     assert D1 > D0
392 
393     # We need to recalculate the invariant accounting for fees
394     # to calculate fair user's share
395     fees: uint256[N_COINS] = empty(uint256[N_COINS])
396     D2: uint256 = D1
397     if token_supply > 0:
398         # Only account for fees if we are not the first to deposit
399         for i in range(N_COINS):
400             ideal_balance: uint256 = D1 * old_balances[i] / D0
401             difference: uint256 = 0
402             if ideal_balance > new_balances[i]:
403                 difference = ideal_balance - new_balances[i]
404             else:
405                 difference = new_balances[i] - ideal_balance
406             fees[i] = _fee * difference / FEE_DENOMINATOR
407             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
408             new_balances[i] -= fees[i]
409         D2 = self.get_D_mem(vp_rate, new_balances, amp)
410     else:
411         self.balances = new_balances
412 
413     # Calculate, how much pool tokens to mint
414     mint_amount: uint256 = 0
415     if token_supply == 0:
416         mint_amount = D1  # Take the dust if there was any
417     else:
418         mint_amount = token_supply * (D2 - D0) / D0
419 
420     assert mint_amount >= min_mint_amount, "Slippage screwed you"
421 
422     # Take coins from the sender
423     for i in range(N_COINS):
424         if amounts[i] > 0:
425             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i])  # dev: failed transfer
426 
427     # Mint pool tokens
428     self.token.mint(msg.sender, mint_amount)
429 
430     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
431 
432     return mint_amount
433 
434 
435 @view
436 @internal
437 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
438     # x in the input is converted to the same price/precision
439 
440     assert i != j       # dev: same coin
441     assert j >= 0       # dev: j below zero
442     assert j < N_COINS  # dev: j above N_COINS
443 
444     # should be unreachable, but good for safety
445     assert i >= 0
446     assert i < N_COINS
447 
448     amp: uint256 = self._A()
449     D: uint256 = self.get_D(xp_, amp)
450 
451     S_: uint256 = 0
452     _x: uint256 = 0
453     y_prev: uint256 = 0
454     c: uint256 = D
455     Ann: uint256 = amp * N_COINS
456 
457     for _i in range(N_COINS):
458         if _i == i:
459             _x = x
460         elif _i != j:
461             _x = xp_[_i]
462         else:
463             continue
464         S_ += _x
465         c = c * D / (_x * N_COINS)
466     c = c * D * A_PRECISION / (Ann * N_COINS)
467     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
468     y: uint256 = D
469     for _i in range(255):
470         y_prev = y
471         y = (y*y + c) / (2 * y + b - D)
472         # Equality with the precision of 1
473         if y > y_prev:
474             if y - y_prev <= 1:
475                 break
476         else:
477             if y_prev - y <= 1:
478                 break
479     return y
480 
481 
482 @view
483 @external
484 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
485     # dx and dy in c-units
486     rates: uint256[N_COINS] = RATES
487     rates[MAX_COIN] = self._vp_rate_ro()
488     xp: uint256[N_COINS] = self._xp(rates[MAX_COIN])
489 
490     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
491     y: uint256 = self.get_y(i, j, x, xp)
492     dy: uint256 = xp[j] - y - 1
493     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
494     return (dy - _fee) * PRECISION / rates[j]
495 
496 
497 @view
498 @external
499 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
500     # dx and dy in underlying units
501     vp_rate: uint256 = self._vp_rate_ro()
502     xp: uint256[N_COINS] = self._xp(vp_rate)
503     precisions: uint256[N_COINS] = PRECISION_MUL
504     _base_pool: address = self.base_pool
505 
506     # Use base_i or base_j if they are >= 0
507     base_i: int128 = i - MAX_COIN
508     base_j: int128 = j - MAX_COIN
509     meta_i: int128 = MAX_COIN
510     meta_j: int128 = MAX_COIN
511     if base_i < 0:
512         meta_i = i
513     if base_j < 0:
514         meta_j = j
515 
516     x: uint256 = 0
517     if base_i < 0:
518         x = xp[i] + dx * precisions[i]
519     else:
520         if base_j < 0:
521             # i is from BasePool
522             # At first, get the amount of pool tokens
523             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
524             base_inputs[base_i] = dx
525             # Token amount transformed to underlying "dollars"
526             x = Curve(_base_pool).calc_token_amount(base_inputs, True) * vp_rate / PRECISION
527             # Accounting for deposit/withdraw fees approximately
528             x -= x * Curve(_base_pool).fee() / (2 * FEE_DENOMINATOR)
529             # Adding number of pool tokens
530             x += xp[MAX_COIN]
531         else:
532             # If both are from the base pool
533             return Curve(_base_pool).get_dy(base_i, base_j, dx)
534 
535     # This pool is involved only when in-pool assets are used
536     y: uint256 = self.get_y(meta_i, meta_j, x, xp)
537     dy: uint256 = xp[meta_j] - y - 1
538     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
539 
540     # If output is going via the metapool
541     if base_j < 0:
542         dy /= precisions[meta_j]
543     else:
544         # j is from BasePool
545         # The fee is already accounted for
546         dy = Curve(_base_pool).calc_withdraw_one_coin(dy * PRECISION / vp_rate, base_j)
547 
548     return dy
549 
550 
551 @external
552 @nonreentrant('lock')
553 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
554     """
555     @notice Perform an exchange between two coins
556     @dev Index values can be found via the `coins` public getter method
557     @param i Index value for the coin to send
558     @param j Index valie of the coin to recieve
559     @param dx Amount of `i` being exchanged
560     @param min_dy Minimum amount of `j` to receive
561     @return Actual amount of `j` received
562     """
563     assert not self.is_killed  # dev: is killed
564     rates: uint256[N_COINS] = RATES
565     rates[MAX_COIN] = self._vp_rate()
566 
567     old_balances: uint256[N_COINS] = self.balances
568     xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
569 
570     x: uint256 = xp[i] + dx * rates[i] / PRECISION
571     y: uint256 = self.get_y(i, j, x, xp)
572 
573     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
574     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
575 
576     # Convert all to real units
577     dy = (dy - dy_fee) * PRECISION / rates[j]
578     assert dy >= min_dy, "Too few coins in result"
579 
580     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
581     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
582 
583     # Change balances exactly in same way as we change actual ERC20 coin amounts
584     self.balances[i] = old_balances[i] + dx
585     # When rounding errors happen, we undercharge admin fee in favor of LP
586     self.balances[j] = old_balances[j] - dy - dy_admin_fee
587 
588     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)
589     assert ERC20(self.coins[j]).transfer(msg.sender, dy)
590 
591     log TokenExchange(msg.sender, i, dx, j, dy)
592 
593     return dy
594 
595 
596 @external
597 @nonreentrant('lock')
598 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
599     """
600     @notice Perform an exchange between two underlying coins
601     @dev Index values can be found via the `underlying_coins` public getter method
602     @param i Index value for the underlying coin to send
603     @param j Index valie of the underlying coin to recieve
604     @param dx Amount of `i` being exchanged
605     @param min_dy Minimum amount of `j` to receive
606     @return Actual amount of `j` received
607     """
608     assert not self.is_killed  # dev: is killed
609     rates: uint256[N_COINS] = RATES
610     rates[MAX_COIN] = self._vp_rate()
611     _base_pool: address = self.base_pool
612 
613     # Use base_i or base_j if they are >= 0
614     base_i: int128 = i - MAX_COIN
615     base_j: int128 = j - MAX_COIN
616     meta_i: int128 = MAX_COIN
617     meta_j: int128 = MAX_COIN
618     if base_i < 0:
619         meta_i = i
620     if base_j < 0:
621         meta_j = j
622     dy: uint256 = 0
623 
624     # Addresses for input and output coins
625     input_coin: address = ZERO_ADDRESS
626     if base_i < 0:
627         input_coin = self.coins[i]
628     else:
629         input_coin = self.base_coins[base_i]
630     output_coin: address = ZERO_ADDRESS
631     if base_j < 0:
632         output_coin = self.coins[j]
633     else:
634         output_coin = self.base_coins[base_j]
635 
636     # Handle potential Tether fees
637     dx_w_fee: uint256 = dx
638     if input_coin == FEE_ASSET:
639         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self)
640     # "safeTransferFrom" which works for ERC20s which return bool or not
641     _response: Bytes[32] = raw_call(
642         input_coin,
643         concat(
644             method_id("transferFrom(address,address,uint256)"),
645             convert(msg.sender, bytes32),
646             convert(self, bytes32),
647             convert(dx, bytes32),
648         ),
649         max_outsize=32,
650     )  # dev: failed transfer
651     if len(_response) > 0:
652         assert convert(_response, bool)  # dev: failed transfer
653     # end "safeTransferFrom"
654     # Handle potential Tether fees
655     if input_coin == FEE_ASSET:
656         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self) - dx_w_fee
657 
658     if base_i < 0 or base_j < 0:
659         old_balances: uint256[N_COINS] = self.balances
660         xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
661 
662         x: uint256 = 0
663         if base_i < 0:
664             x = xp[i] + dx_w_fee * rates[i] / PRECISION
665         else:
666             # i is from BasePool
667             # At first, get the amount of pool tokens
668             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
669             base_inputs[base_i] = dx_w_fee
670             coin_i: address = self.coins[MAX_COIN]
671             # Deposit and measure delta
672             x = ERC20(coin_i).balanceOf(self)
673             Curve(_base_pool).add_liquidity(base_inputs, 0)
674             # Need to convert pool token to "virtual" units using rates
675             # dx is also different now
676             dx_w_fee = ERC20(coin_i).balanceOf(self) - x
677             x = dx_w_fee * rates[MAX_COIN] / PRECISION
678             # Adding number of pool tokens
679             x += xp[MAX_COIN]
680 
681         y: uint256 = self.get_y(meta_i, meta_j, x, xp)
682 
683         # Either a real coin or token
684         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
685         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
686 
687         # Convert all to real units
688         # Works for both pool coins and real coins
689         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
690 
691         dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
692         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
693 
694         # Change balances exactly in same way as we change actual ERC20 coin amounts
695         self.balances[meta_i] = old_balances[meta_i] + dx_w_fee
696         # When rounding errors happen, we undercharge admin fee in favor of LP
697         self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee
698 
699         # Withdraw from the base pool if needed
700         if base_j >= 0:
701             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
702             Curve(_base_pool).remove_liquidity_one_coin(dy, base_j, 0)
703             dy = ERC20(output_coin).balanceOf(self) - out_amount
704 
705         assert dy >= min_dy, "Too few coins in result"
706 
707     else:
708         # If both are from the base pool
709         dy = ERC20(output_coin).balanceOf(self)
710         Curve(_base_pool).exchange(base_i, base_j, dx_w_fee, min_dy)
711         dy = ERC20(output_coin).balanceOf(self) - dy
712 
713     # "safeTransfer" which works for ERC20s which return bool or not
714     _response = raw_call(
715         output_coin,
716         concat(
717             method_id("transfer(address,uint256)"),
718             convert(msg.sender, bytes32),
719             convert(dy, bytes32),
720         ),
721         max_outsize=32,
722     )  # dev: failed transfer
723     if len(_response) > 0:
724         assert convert(_response, bool)  # dev: failed transfer
725     # end "safeTransfer"
726 
727     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
728 
729     return dy
730 
731 
732 @external
733 @nonreentrant('lock')
734 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
735     """
736     @notice Withdraw coins from the pool
737     @dev Withdrawal amounts are based on current deposit ratios
738     @param _amount Quantity of LP tokens to burn in the withdrawal
739     @param min_amounts Minimum amounts of underlying coins to receive
740     @return List of amounts of coins that were withdrawn
741     """
742     total_supply: uint256 = self.token.totalSupply()
743     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
744     fees: uint256[N_COINS] = empty(uint256[N_COINS])  # Fees are unused but we've got them historically in event
745 
746     for i in range(N_COINS):
747         value: uint256 = self.balances[i] * _amount / total_supply
748         assert value >= min_amounts[i], "Too few coins in result"
749         self.balances[i] -= value
750         amounts[i] = value
751         assert ERC20(self.coins[i]).transfer(msg.sender, value)
752 
753     self.token.burnFrom(msg.sender, _amount)  # dev: insufficient funds
754 
755     log RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
756 
757     return amounts
758 
759 
760 @external
761 @nonreentrant('lock')
762 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256:
763     """
764     @notice Withdraw coins from the pool in an imbalanced amount
765     @param amounts List of amounts of underlying coins to withdraw
766     @param max_burn_amount Maximum amount of LP token to burn in the withdrawal
767     @return Actual amount of the LP token burned in the withdrawal
768     """
769     assert not self.is_killed  # dev: is killed
770 
771     amp: uint256 = self._A()
772     vp_rate: uint256 = self._vp_rate()
773 
774     token_supply: uint256 = self.token.totalSupply()
775     assert token_supply != 0  # dev: zero total supply
776     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
777     _admin_fee: uint256 = self.admin_fee
778 
779     old_balances: uint256[N_COINS] = self.balances
780     new_balances: uint256[N_COINS] = old_balances
781     D0: uint256 = self.get_D_mem(vp_rate, old_balances, amp)
782     for i in range(N_COINS):
783         new_balances[i] -= amounts[i]
784     D1: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
785 
786     fees: uint256[N_COINS] = empty(uint256[N_COINS])
787     for i in range(N_COINS):
788         ideal_balance: uint256 = D1 * old_balances[i] / D0
789         difference: uint256 = 0
790         if ideal_balance > new_balances[i]:
791             difference = ideal_balance - new_balances[i]
792         else:
793             difference = new_balances[i] - ideal_balance
794         fees[i] = _fee * difference / FEE_DENOMINATOR
795         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
796         new_balances[i] -= fees[i]
797     D2: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
798 
799     token_amount: uint256 = (D0 - D2) * token_supply / D0
800     assert token_amount != 0  # dev: zero tokens burned
801     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
802     assert token_amount <= max_burn_amount, "Slippage screwed you"
803 
804     self.token.burnFrom(msg.sender, token_amount)  # dev: insufficient funds
805     for i in range(N_COINS):
806         if amounts[i] != 0:
807             assert ERC20(self.coins[i]).transfer(msg.sender, amounts[i])
808 
809     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
810 
811     return token_amount
812 
813 
814 @view
815 @internal
816 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
817     """
818     Calculate x[i] if one reduces D from being calculated for xp to D
819 
820     Done by solving quadratic equation iteratively.
821     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
822     x_1**2 + b*x_1 = c
823 
824     x_1 = (x_1**2 + c) / (2*x_1 + b)
825     """
826     # x in the input is converted to the same price/precision
827 
828     assert i >= 0  # dev: i below zero
829     assert i < N_COINS  # dev: i above N_COINS
830 
831     S_: uint256 = 0
832     _x: uint256 = 0
833     y_prev: uint256 = 0
834 
835     c: uint256 = D
836     Ann: uint256 = A_ * N_COINS
837 
838     for _i in range(N_COINS):
839         if _i != i:
840             _x = xp[_i]
841         else:
842             continue
843         S_ += _x
844         c = c * D / (_x * N_COINS)
845     c = c * D * A_PRECISION / (Ann * N_COINS)
846     b: uint256 = S_ + D * A_PRECISION / Ann
847     y: uint256 = D
848     for _i in range(255):
849         y_prev = y
850         y = (y*y + c) / (2 * y + b - D)
851         # Equality with the precision of 1
852         if y > y_prev:
853             if y - y_prev <= 1:
854                 break
855         else:
856             if y_prev - y <= 1:
857                 break
858     return y
859 
860 
861 @view
862 @internal
863 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, vp_rate: uint256) -> (uint256, uint256, uint256):
864     # First, need to calculate
865     # * Get current D
866     # * Solve Eqn against y_i for D - _token_amount
867     amp: uint256 = self._A()
868     xp: uint256[N_COINS] = self._xp(vp_rate)
869     D0: uint256 = self.get_D(xp, amp)
870 
871     total_supply: uint256 = self.token.totalSupply()
872     D1: uint256 = D0 - _token_amount * D0 / total_supply
873     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
874 
875     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
876     rates: uint256[N_COINS] = RATES
877     rates[MAX_COIN] = vp_rate
878 
879     xp_reduced: uint256[N_COINS] = xp
880     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
881 
882     for j in range(N_COINS):
883         dx_expected: uint256 = 0
884         if j == i:
885             dx_expected = xp[j] * D1 / D0 - new_y
886         else:
887             dx_expected = xp[j] - xp[j] * D1 / D0
888         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
889 
890     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
891     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
892 
893     return dy, dy_0 - dy, total_supply
894 
895 
896 @view
897 @external
898 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
899     """
900     @notice Calculate the amount received when withdrawing a single coin
901     @param _token_amount Amount of LP tokens to burn in the withdrawal
902     @param i Index value of the coin to withdraw
903     @return Amount of coin received
904     """
905     vp_rate: uint256 = self._vp_rate_ro()
906     return self._calc_withdraw_one_coin(_token_amount, i, vp_rate)[0]
907 
908 
909 @external
910 @nonreentrant('lock')
911 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
912     """
913     @notice Withdraw a single coin from the pool
914     @param _token_amount Amount of LP tokens to burn in the withdrawal
915     @param i Index value of the coin to withdraw
916     @param _min_amount Minimum amount of coin to receive
917     @return Amount of coin received
918     """
919     assert not self.is_killed  # dev: is killed
920 
921     vp_rate: uint256 = self._vp_rate()
922     dy: uint256 = 0
923     dy_fee: uint256 = 0
924     total_supply: uint256 = 0
925     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_token_amount, i, vp_rate)
926     assert dy >= _min_amount, "Not enough coins removed"
927 
928     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
929     self.token.burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
930     assert ERC20(self.coins[i]).transfer(msg.sender, dy)
931 
932     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
933 
934     return dy
935 
936 
937 ### Admin functions ###
938 @external
939 def ramp_A(_future_A: uint256, _future_time: uint256):
940     assert msg.sender == self.owner  # dev: only owner
941     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
942     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
943 
944     _initial_A: uint256 = self._A()
945     _future_A_p: uint256 = _future_A * A_PRECISION
946 
947     assert _future_A > 0 and _future_A < MAX_A
948     if _future_A_p < _initial_A:
949         assert _future_A_p * MAX_A_CHANGE >= _initial_A
950     else:
951         assert _future_A_p <= _initial_A * MAX_A_CHANGE
952 
953     self.initial_A = _initial_A
954     self.future_A = _future_A_p
955     self.initial_A_time = block.timestamp
956     self.future_A_time = _future_time
957 
958     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
959 
960 
961 @external
962 def stop_ramp_A():
963     assert msg.sender == self.owner  # dev: only owner
964 
965     current_A: uint256 = self._A()
966     self.initial_A = current_A
967     self.future_A = current_A
968     self.initial_A_time = block.timestamp
969     self.future_A_time = block.timestamp
970     # now (block.timestamp < t1) is always False, so we return saved A
971 
972     log StopRampA(current_A, block.timestamp)
973 
974 
975 @external
976 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
977     assert msg.sender == self.owner  # dev: only owner
978     assert self.admin_actions_deadline == 0  # dev: active action
979     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
980     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
981 
982     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
983     self.admin_actions_deadline = _deadline
984     self.future_fee = new_fee
985     self.future_admin_fee = new_admin_fee
986 
987     log CommitNewFee(_deadline, new_fee, new_admin_fee)
988 
989 
990 @external
991 def apply_new_fee():
992     assert msg.sender == self.owner  # dev: only owner
993     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
994     assert self.admin_actions_deadline != 0  # dev: no active action
995 
996     self.admin_actions_deadline = 0
997     _fee: uint256 = self.future_fee
998     _admin_fee: uint256 = self.future_admin_fee
999     self.fee = _fee
1000     self.admin_fee = _admin_fee
1001 
1002     log NewFee(_fee, _admin_fee)
1003 
1004 
1005 @external
1006 def revert_new_parameters():
1007     assert msg.sender == self.owner  # dev: only owner
1008 
1009     self.admin_actions_deadline = 0
1010 
1011 
1012 @external
1013 def commit_transfer_ownership(_owner: address):
1014     assert msg.sender == self.owner  # dev: only owner
1015     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1016 
1017     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1018     self.transfer_ownership_deadline = _deadline
1019     self.future_owner = _owner
1020 
1021     log CommitNewAdmin(_deadline, _owner)
1022 
1023 
1024 @external
1025 def apply_transfer_ownership():
1026     assert msg.sender == self.owner  # dev: only owner
1027     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1028     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1029 
1030     self.transfer_ownership_deadline = 0
1031     _owner: address = self.future_owner
1032     self.owner = _owner
1033 
1034     log NewAdmin(_owner)
1035 
1036 
1037 @external
1038 def revert_transfer_ownership():
1039     assert msg.sender == self.owner  # dev: only owner
1040 
1041     self.transfer_ownership_deadline = 0
1042 
1043 
1044 @view
1045 @external
1046 def admin_balances(i: uint256) -> uint256:
1047     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1048 
1049 
1050 @external
1051 def withdraw_admin_fees():
1052     assert msg.sender == self.owner  # dev: only owner
1053 
1054     for i in range(N_COINS):
1055         c: address = self.coins[i]
1056         value: uint256 = ERC20(c).balanceOf(self) - self.balances[i]
1057         if value > 0:
1058             assert ERC20(c).transfer(msg.sender, value)
1059 
1060 
1061 @external
1062 def donate_admin_fees():
1063     assert msg.sender == self.owner  # dev: only owner
1064     for i in range(N_COINS):
1065         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
1066 
1067 
1068 @external
1069 def kill_me():
1070     assert msg.sender == self.owner  # dev: only owner
1071     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1072     self.is_killed = True
1073 
1074 
1075 @external
1076 def unkill_me():
1077     assert msg.sender == self.owner  # dev: only owner
1078     self.is_killed = False