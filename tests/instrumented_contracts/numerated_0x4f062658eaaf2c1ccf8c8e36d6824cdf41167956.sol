1 # @version 0.2.5
2 """
3 @title Curve GUSD Metapool
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 @dev Utilizes 3Pool to allow swaps between GUSD / DAI / USDC / USDT
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
17     def coins(i: uint256) -> address: view
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
102 PRECISION_MUL: constant(uint256[N_COINS]) = [10000000000000000, 1]
103 RATES: constant(uint256[N_COINS]) = [10000000000000000000000000000000000, 1000000000000000000]
104 
105 BASE_N_COINS: constant(int128) = 3
106 N_ALL_COINS: constant(int128) = N_COINS + BASE_N_COINS - 1
107 BASE_PRECISION_MUL: constant(uint256[BASE_N_COINS]) = [1, 1000000000000, 1000000000000]
108 BASE_RATES: constant(uint256[BASE_N_COINS]) = [1000000000000000000, 1000000000000000000000000000000, 1000000000000000000000000000000]
109 
110 # An asset which may have a transfer fee (USDT)
111 FEE_ASSET: constant(address) = 0xdAC17F958D2ee523a2206206994597C13D831ec7
112 
113 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
114 MAX_FEE: constant(uint256) = 5 * 10 ** 9
115 MAX_A: constant(uint256) = 10 ** 6
116 MAX_A_CHANGE: constant(uint256) = 10
117 
118 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
119 MIN_RAMP_TIME: constant(uint256) = 86400
120 
121 coins: public(address[N_COINS])
122 balances: public(uint256[N_COINS])
123 fee: public(uint256)  # fee * 1e10
124 admin_fee: public(uint256)  # admin_fee * 1e10
125 
126 owner: public(address)
127 token: CurveToken
128 
129 # Token corresponding to the pool is always the last one
130 BASE_POOL_COINS: constant(int128) = 3
131 BASE_CACHE_EXPIRES: constant(int128) = 10 * 60  # 10 min
132 base_pool: public(address)
133 base_virtual_price: public(uint256)
134 base_cache_updated: public(uint256)
135 base_coins: public(address[BASE_POOL_COINS])
136 
137 A_PRECISION: constant(uint256) = 100
138 initial_A: public(uint256)
139 future_A: public(uint256)
140 initial_A_time: public(uint256)
141 future_A_time: public(uint256)
142 
143 admin_actions_deadline: public(uint256)
144 transfer_ownership_deadline: public(uint256)
145 future_fee: public(uint256)
146 future_admin_fee: public(uint256)
147 future_owner: public(address)
148 
149 is_killed: bool
150 kill_deadline: uint256
151 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
152 
153 
154 @external
155 def __init__(
156     _owner: address,
157     _coins: address[N_COINS],
158     _pool_token: address,
159     _base_pool: address,
160     _A: uint256,
161     _fee: uint256,
162     _admin_fee: uint256
163 ):
164     """
165     @notice Contract constructor
166     @param _owner Contract owner address
167     @param _coins Addresses of ERC20 conracts of coins
168     @param _pool_token Address of the token representing LP share
169     @param _base_pool Address of the base pool (which will have a virtual price)
170     @param _A Amplification coefficient multiplied by n * (n - 1)
171     @param _fee Fee to charge for exchanges
172     @param _admin_fee Admin fee
173     """
174     for i in range(N_COINS):
175         assert _coins[i] != ZERO_ADDRESS
176     self.coins = _coins
177     self.initial_A = _A * A_PRECISION
178     self.future_A = _A * A_PRECISION
179     self.fee = _fee
180     self.admin_fee = _admin_fee
181     self.owner = _owner
182     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
183     self.token = CurveToken(_pool_token)
184 
185     self.base_pool = _base_pool
186     self.base_virtual_price = Curve(_base_pool).get_virtual_price()
187     self.base_cache_updated = block.timestamp
188     for i in range(BASE_POOL_COINS):
189         _base_coin: address = Curve(_base_pool).coins(convert(i, uint256))
190         self.base_coins[i] = _base_coin
191 
192         # approve underlying coins for infinite transfers
193         _response: Bytes[32] = raw_call(
194             _base_coin,
195             concat(
196                 method_id("approve(address,uint256)"),
197                 convert(_base_pool, bytes32),
198                 convert(MAX_UINT256, bytes32),
199             ),
200             max_outsize=32,
201         )
202         if len(_response) > 0:
203             assert convert(_response, bool)
204 
205 
206 @view
207 @internal
208 def _A() -> uint256:
209     """
210     Handle ramping A up or down
211     """
212     t1: uint256 = self.future_A_time
213     A1: uint256 = self.future_A
214 
215     if block.timestamp < t1:
216         A0: uint256 = self.initial_A
217         t0: uint256 = self.initial_A_time
218         # Expressions in uint256 cannot have negative numbers, thus "if"
219         if A1 > A0:
220             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
221         else:
222             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
223 
224     else:  # when t1 == 0 or block.timestamp >= t1
225         return A1
226 
227 
228 @view
229 @external
230 def A() -> uint256:
231     return self._A() / A_PRECISION
232 
233 
234 @view
235 @external
236 def A_precise() -> uint256:
237     return self._A()
238 
239 
240 @view
241 @internal
242 def _xp(vp_rate: uint256) -> uint256[N_COINS]:
243     result: uint256[N_COINS] = RATES
244     result[MAX_COIN] = vp_rate  # virtual price for the metacurrency
245     for i in range(N_COINS):
246         result[i] = result[i] * self.balances[i] / PRECISION
247     return result
248 
249 
250 @pure
251 @internal
252 def _xp_mem(vp_rate: uint256, _balances: uint256[N_COINS]) -> uint256[N_COINS]:
253     result: uint256[N_COINS] = RATES
254     result[MAX_COIN] = vp_rate  # virtual price for the metacurrency
255     for i in range(N_COINS):
256         result[i] = result[i] * _balances[i] / PRECISION
257     return result
258 
259 
260 @internal
261 def _vp_rate() -> uint256:
262     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
263         vprice: uint256 = Curve(self.base_pool).get_virtual_price()
264         self.base_virtual_price = vprice
265         self.base_cache_updated = block.timestamp
266         return vprice
267     else:
268         return self.base_virtual_price
269 
270 
271 @internal
272 @view
273 def _vp_rate_ro() -> uint256:
274     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
275         return Curve(self.base_pool).get_virtual_price()
276     else:
277         return self.base_virtual_price
278 
279 
280 @pure
281 @internal
282 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
283     S: uint256 = 0
284     Dprev: uint256 = 0
285     for _x in xp:
286         S += _x
287     if S == 0:
288         return 0
289 
290     D: uint256 = S
291     Ann: uint256 = amp * N_COINS
292     for _i in range(255):
293         D_P: uint256 = D
294         for _x in xp:
295             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
296         Dprev = D
297         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
298         # Equality with the precision of 1
299         if D > Dprev:
300             if D - Dprev <= 1:
301                 break
302         else:
303             if Dprev - D <= 1:
304                 break
305     return D
306 
307 
308 @view
309 @internal
310 def get_D_mem(vp_rate: uint256, _balances: uint256[N_COINS], amp: uint256) -> uint256:
311     xp: uint256[N_COINS] = self._xp_mem(vp_rate, _balances)
312     return self.get_D(xp, amp)
313 
314 
315 @view
316 @external
317 def get_virtual_price() -> uint256:
318     """
319     @notice The current virtual price of the pool LP token
320     @dev Useful for calculating profits
321     @return LP token virtual price normalized to 1e18
322     """
323     amp: uint256 = self._A()
324     vp_rate: uint256 = self._vp_rate_ro()
325     xp: uint256[N_COINS] = self._xp(vp_rate)
326     D: uint256 = self.get_D(xp, amp)
327     # D is in the units similar to DAI (e.g. converted to precision 1e18)
328     # When balanced, D = n * x_u - total virtual value of the portfolio
329     token_supply: uint256 = self.token.totalSupply()
330     return D * PRECISION / token_supply
331 
332 
333 @view
334 @external
335 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
336     """
337     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
338     @dev This calculation accounts for slippage, but not fees.
339          Needed to prevent front-running, not for precise calculations!
340     @param amounts Amount of each coin being deposited
341     @param is_deposit set True for deposits, False for withdrawals
342     @return Expected amount of LP tokens received
343     """
344     amp: uint256 = self._A()
345     vp_rate: uint256 = self._vp_rate_ro()
346     _balances: uint256[N_COINS] = self.balances
347     D0: uint256 = self.get_D_mem(vp_rate, _balances, amp)
348     for i in range(N_COINS):
349         if is_deposit:
350             _balances[i] += amounts[i]
351         else:
352             _balances[i] -= amounts[i]
353     D1: uint256 = self.get_D_mem(vp_rate, _balances, amp)
354     token_amount: uint256 = self.token.totalSupply()
355     diff: uint256 = 0
356     if is_deposit:
357         diff = D1 - D0
358     else:
359         diff = D0 - D1
360     return diff * token_amount / D0
361 
362 
363 @external
364 @nonreentrant('lock')
365 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
366     """
367     @notice Deposit coins into the pool
368     @param amounts List of amounts of coins to deposit
369     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
370     @return Amount of LP tokens received by depositing
371     """
372     assert not self.is_killed  # dev: is killed
373 
374     amp: uint256 = self._A()
375     vp_rate: uint256 = self._vp_rate()
376     token_supply: uint256 = self.token.totalSupply()
377     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
378     _admin_fee: uint256 = self.admin_fee
379 
380     # Initial invariant
381     D0: uint256 = 0
382     old_balances: uint256[N_COINS] = self.balances
383     if token_supply > 0:
384         D0 = self.get_D_mem(vp_rate, old_balances, amp)
385     new_balances: uint256[N_COINS] = old_balances
386 
387     for i in range(N_COINS):
388         if token_supply == 0:
389             assert amounts[i] > 0  # dev: initial deposit requires all coins
390         # balances store amounts of c-tokens
391         new_balances[i] = old_balances[i] + amounts[i]
392 
393     # Invariant after change
394     D1: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
395     assert D1 > D0
396 
397     # We need to recalculate the invariant accounting for fees
398     # to calculate fair user's share
399     fees: uint256[N_COINS] = empty(uint256[N_COINS])
400     D2: uint256 = D1
401     if token_supply > 0:
402         # Only account for fees if we are not the first to deposit
403         for i in range(N_COINS):
404             ideal_balance: uint256 = D1 * old_balances[i] / D0
405             difference: uint256 = 0
406             if ideal_balance > new_balances[i]:
407                 difference = ideal_balance - new_balances[i]
408             else:
409                 difference = new_balances[i] - ideal_balance
410             fees[i] = _fee * difference / FEE_DENOMINATOR
411             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
412             new_balances[i] -= fees[i]
413         D2 = self.get_D_mem(vp_rate, new_balances, amp)
414     else:
415         self.balances = new_balances
416 
417     # Calculate, how much pool tokens to mint
418     mint_amount: uint256 = 0
419     if token_supply == 0:
420         mint_amount = D1  # Take the dust if there was any
421     else:
422         mint_amount = token_supply * (D2 - D0) / D0
423 
424     assert mint_amount >= min_mint_amount, "Slippage screwed you"
425 
426     # Take coins from the sender
427     for i in range(N_COINS):
428         if amounts[i] > 0:
429             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i])  # dev: failed transfer
430 
431     # Mint pool tokens
432     self.token.mint(msg.sender, mint_amount)
433 
434     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
435 
436     return mint_amount
437 
438 
439 @view
440 @internal
441 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
442     # x in the input is converted to the same price/precision
443 
444     assert i != j       # dev: same coin
445     assert j >= 0       # dev: j below zero
446     assert j < N_COINS  # dev: j above N_COINS
447 
448     # should be unreachable, but good for safety
449     assert i >= 0
450     assert i < N_COINS
451 
452     amp: uint256 = self._A()
453     D: uint256 = self.get_D(xp_, amp)
454 
455     S_: uint256 = 0
456     _x: uint256 = 0
457     y_prev: uint256 = 0
458     c: uint256 = D
459     Ann: uint256 = amp * N_COINS
460 
461     for _i in range(N_COINS):
462         if _i == i:
463             _x = x
464         elif _i != j:
465             _x = xp_[_i]
466         else:
467             continue
468         S_ += _x
469         c = c * D / (_x * N_COINS)
470     c = c * D * A_PRECISION / (Ann * N_COINS)
471     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
472     y: uint256 = D
473     for _i in range(255):
474         y_prev = y
475         y = (y*y + c) / (2 * y + b - D)
476         # Equality with the precision of 1
477         if y > y_prev:
478             if y - y_prev <= 1:
479                 break
480         else:
481             if y_prev - y <= 1:
482                 break
483     return y
484 
485 
486 @view
487 @external
488 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
489     # dx and dy in c-units
490     rates: uint256[N_COINS] = RATES
491     rates[MAX_COIN] = self._vp_rate_ro()
492     xp: uint256[N_COINS] = self._xp(rates[MAX_COIN])
493 
494     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
495     y: uint256 = self.get_y(i, j, x, xp)
496     dy: uint256 = xp[j] - y - 1
497     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
498     return (dy - _fee) * PRECISION / rates[j]
499 
500 
501 @view
502 @external
503 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
504     # dx and dy in underlying units
505     vp_rate: uint256 = self._vp_rate_ro()
506     xp: uint256[N_COINS] = self._xp(vp_rate)
507     precisions: uint256[N_COINS] = PRECISION_MUL
508     _base_pool: address = self.base_pool
509 
510     # Use base_i or base_j if they are >= 0
511     base_i: int128 = i - MAX_COIN
512     base_j: int128 = j - MAX_COIN
513     meta_i: int128 = MAX_COIN
514     meta_j: int128 = MAX_COIN
515     if base_i < 0:
516         meta_i = i
517     if base_j < 0:
518         meta_j = j
519 
520     x: uint256 = 0
521     if base_i < 0:
522         x = xp[i] + dx * precisions[i]
523     else:
524         if base_j < 0:
525             # i is from BasePool
526             # At first, get the amount of pool tokens
527             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
528             base_inputs[base_i] = dx
529             # Token amount transformed to underlying "dollars"
530             x = Curve(_base_pool).calc_token_amount(base_inputs, True) * vp_rate / PRECISION
531             # Accounting for deposit/withdraw fees approximately
532             x -= x * Curve(_base_pool).fee() / (2 * FEE_DENOMINATOR)
533             # Adding number of pool tokens
534             x += xp[MAX_COIN]
535         else:
536             # If both are from the base pool
537             return Curve(_base_pool).get_dy(base_i, base_j, dx)
538 
539     # This pool is involved only when in-pool assets are used
540     y: uint256 = self.get_y(meta_i, meta_j, x, xp)
541     dy: uint256 = xp[meta_j] - y - 1
542     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
543 
544     # If output is going via the metapool
545     if base_j < 0:
546         dy /= precisions[meta_j]
547     else:
548         # j is from BasePool
549         # The fee is already accounted for
550         dy = Curve(_base_pool).calc_withdraw_one_coin(dy * PRECISION / vp_rate, base_j)
551 
552     return dy
553 
554 
555 @external
556 @nonreentrant('lock')
557 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
558     """
559     @notice Perform an exchange between two coins
560     @dev Index values can be found via the `coins` public getter method
561     @param i Index value for the coin to send
562     @param j Index valie of the coin to recieve
563     @param dx Amount of `i` being exchanged
564     @param min_dy Minimum amount of `j` to receive
565     @return Actual amount of `j` received
566     """
567     assert not self.is_killed  # dev: is killed
568     rates: uint256[N_COINS] = RATES
569     rates[MAX_COIN] = self._vp_rate()
570 
571     old_balances: uint256[N_COINS] = self.balances
572     xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
573 
574     x: uint256 = xp[i] + dx * rates[i] / PRECISION
575     y: uint256 = self.get_y(i, j, x, xp)
576 
577     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
578     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
579 
580     # Convert all to real units
581     dy = (dy - dy_fee) * PRECISION / rates[j]
582     assert dy >= min_dy, "Too few coins in result"
583 
584     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
585     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
586 
587     # Change balances exactly in same way as we change actual ERC20 coin amounts
588     self.balances[i] = old_balances[i] + dx
589     # When rounding errors happen, we undercharge admin fee in favor of LP
590     self.balances[j] = old_balances[j] - dy - dy_admin_fee
591 
592     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)
593     assert ERC20(self.coins[j]).transfer(msg.sender, dy)
594 
595     log TokenExchange(msg.sender, i, dx, j, dy)
596 
597     return dy
598 
599 
600 @external
601 @nonreentrant('lock')
602 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
603     """
604     @notice Perform an exchange between two underlying coins
605     @dev Index values can be found via the `underlying_coins` public getter method
606     @param i Index value for the underlying coin to send
607     @param j Index valie of the underlying coin to recieve
608     @param dx Amount of `i` being exchanged
609     @param min_dy Minimum amount of `j` to receive
610     @return Actual amount of `j` received
611     """
612     assert not self.is_killed  # dev: is killed
613     rates: uint256[N_COINS] = RATES
614     rates[MAX_COIN] = self._vp_rate()
615     _base_pool: address = self.base_pool
616 
617     # Use base_i or base_j if they are >= 0
618     base_i: int128 = i - MAX_COIN
619     base_j: int128 = j - MAX_COIN
620     meta_i: int128 = MAX_COIN
621     meta_j: int128 = MAX_COIN
622     if base_i < 0:
623         meta_i = i
624     if base_j < 0:
625         meta_j = j
626     dy: uint256 = 0
627 
628     # Addresses for input and output coins
629     input_coin: address = ZERO_ADDRESS
630     if base_i < 0:
631         input_coin = self.coins[i]
632     else:
633         input_coin = self.base_coins[base_i]
634     output_coin: address = ZERO_ADDRESS
635     if base_j < 0:
636         output_coin = self.coins[j]
637     else:
638         output_coin = self.base_coins[base_j]
639 
640     # Handle potential Tether fees
641     dx_w_fee: uint256 = dx
642     if input_coin == FEE_ASSET:
643         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self)
644     # "safeTransferFrom" which works for ERC20s which return bool or not
645     _response: Bytes[32] = raw_call(
646         input_coin,
647         concat(
648             method_id("transferFrom(address,address,uint256)"),
649             convert(msg.sender, bytes32),
650             convert(self, bytes32),
651             convert(dx, bytes32),
652         ),
653         max_outsize=32,
654     )  # dev: failed transfer
655     if len(_response) > 0:
656         assert convert(_response, bool)  # dev: failed transfer
657     # end "safeTransferFrom"
658     # Handle potential Tether fees
659     if input_coin == FEE_ASSET:
660         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self) - dx_w_fee
661 
662     if base_i < 0 or base_j < 0:
663         old_balances: uint256[N_COINS] = self.balances
664         xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
665 
666         x: uint256 = 0
667         if base_i < 0:
668             x = xp[i] + dx_w_fee * rates[i] / PRECISION
669         else:
670             # i is from BasePool
671             # At first, get the amount of pool tokens
672             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
673             base_inputs[base_i] = dx_w_fee
674             coin_i: address = self.coins[MAX_COIN]
675             # Deposit and measure delta
676             x = ERC20(coin_i).balanceOf(self)
677             Curve(_base_pool).add_liquidity(base_inputs, 0)
678             # Need to convert pool token to "virtual" units using rates
679             # dx is also different now
680             dx_w_fee = ERC20(coin_i).balanceOf(self) - x
681             x = dx_w_fee * rates[MAX_COIN] / PRECISION
682             # Adding number of pool tokens
683             x += xp[MAX_COIN]
684 
685         y: uint256 = self.get_y(meta_i, meta_j, x, xp)
686 
687         # Either a real coin or token
688         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
689         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
690 
691         # Convert all to real units
692         # Works for both pool coins and real coins
693         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
694 
695         dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
696         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
697 
698         # Change balances exactly in same way as we change actual ERC20 coin amounts
699         self.balances[meta_i] = old_balances[meta_i] + dx_w_fee
700         # When rounding errors happen, we undercharge admin fee in favor of LP
701         self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee
702 
703         # Withdraw from the base pool if needed
704         if base_j >= 0:
705             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
706             Curve(_base_pool).remove_liquidity_one_coin(dy, base_j, 0)
707             dy = ERC20(output_coin).balanceOf(self) - out_amount
708 
709         assert dy >= min_dy, "Too few coins in result"
710 
711     else:
712         # If both are from the base pool
713         dy = ERC20(output_coin).balanceOf(self)
714         Curve(_base_pool).exchange(base_i, base_j, dx_w_fee, min_dy)
715         dy = ERC20(output_coin).balanceOf(self) - dy
716 
717     # "safeTransfer" which works for ERC20s which return bool or not
718     _response = raw_call(
719         output_coin,
720         concat(
721             method_id("transfer(address,uint256)"),
722             convert(msg.sender, bytes32),
723             convert(dy, bytes32),
724         ),
725         max_outsize=32,
726     )  # dev: failed transfer
727     if len(_response) > 0:
728         assert convert(_response, bool)  # dev: failed transfer
729     # end "safeTransfer"
730 
731     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
732 
733     return dy
734 
735 
736 @external
737 @nonreentrant('lock')
738 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
739     """
740     @notice Withdraw coins from the pool
741     @dev Withdrawal amounts are based on current deposit ratios
742     @param _amount Quantity of LP tokens to burn in the withdrawal
743     @param min_amounts Minimum amounts of underlying coins to receive
744     @return List of amounts of coins that were withdrawn
745     """
746     total_supply: uint256 = self.token.totalSupply()
747     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
748     fees: uint256[N_COINS] = empty(uint256[N_COINS])  # Fees are unused but we've got them historically in event
749 
750     for i in range(N_COINS):
751         value: uint256 = self.balances[i] * _amount / total_supply
752         assert value >= min_amounts[i], "Too few coins in result"
753         self.balances[i] -= value
754         amounts[i] = value
755         assert ERC20(self.coins[i]).transfer(msg.sender, value)
756 
757     self.token.burnFrom(msg.sender, _amount)  # dev: insufficient funds
758 
759     log RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
760 
761     return amounts
762 
763 
764 @external
765 @nonreentrant('lock')
766 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256:
767     """
768     @notice Withdraw coins from the pool in an imbalanced amount
769     @param amounts List of amounts of underlying coins to withdraw
770     @param max_burn_amount Maximum amount of LP token to burn in the withdrawal
771     @return Actual amount of the LP token burned in the withdrawal
772     """
773     assert not self.is_killed  # dev: is killed
774 
775     amp: uint256 = self._A()
776     vp_rate: uint256 = self._vp_rate()
777 
778     token_supply: uint256 = self.token.totalSupply()
779     assert token_supply != 0  # dev: zero total supply
780     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
781     _admin_fee: uint256 = self.admin_fee
782 
783     old_balances: uint256[N_COINS] = self.balances
784     new_balances: uint256[N_COINS] = old_balances
785     D0: uint256 = self.get_D_mem(vp_rate, old_balances, amp)
786     for i in range(N_COINS):
787         new_balances[i] -= amounts[i]
788     D1: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
789 
790     fees: uint256[N_COINS] = empty(uint256[N_COINS])
791     for i in range(N_COINS):
792         ideal_balance: uint256 = D1 * old_balances[i] / D0
793         difference: uint256 = 0
794         if ideal_balance > new_balances[i]:
795             difference = ideal_balance - new_balances[i]
796         else:
797             difference = new_balances[i] - ideal_balance
798         fees[i] = _fee * difference / FEE_DENOMINATOR
799         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
800         new_balances[i] -= fees[i]
801     D2: uint256 = self.get_D_mem(vp_rate, new_balances, amp)
802 
803     token_amount: uint256 = (D0 - D2) * token_supply / D0
804     assert token_amount != 0  # dev: zero tokens burned
805     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
806     assert token_amount <= max_burn_amount, "Slippage screwed you"
807 
808     self.token.burnFrom(msg.sender, token_amount)  # dev: insufficient funds
809     for i in range(N_COINS):
810         if amounts[i] != 0:
811             assert ERC20(self.coins[i]).transfer(msg.sender, amounts[i])
812 
813     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
814 
815     return token_amount
816 
817 
818 @view
819 @internal
820 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
821     """
822     Calculate x[i] if one reduces D from being calculated for xp to D
823 
824     Done by solving quadratic equation iteratively.
825     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
826     x_1**2 + b*x_1 = c
827 
828     x_1 = (x_1**2 + c) / (2*x_1 + b)
829     """
830     # x in the input is converted to the same price/precision
831 
832     assert i >= 0  # dev: i below zero
833     assert i < N_COINS  # dev: i above N_COINS
834 
835     S_: uint256 = 0
836     _x: uint256 = 0
837     y_prev: uint256 = 0
838 
839     c: uint256 = D
840     Ann: uint256 = A_ * N_COINS
841 
842     for _i in range(N_COINS):
843         if _i != i:
844             _x = xp[_i]
845         else:
846             continue
847         S_ += _x
848         c = c * D / (_x * N_COINS)
849     c = c * D * A_PRECISION / (Ann * N_COINS)
850     b: uint256 = S_ + D * A_PRECISION / Ann
851     y: uint256 = D
852     for _i in range(255):
853         y_prev = y
854         y = (y*y + c) / (2 * y + b - D)
855         # Equality with the precision of 1
856         if y > y_prev:
857             if y - y_prev <= 1:
858                 break
859         else:
860             if y_prev - y <= 1:
861                 break
862     return y
863 
864 
865 @view
866 @internal
867 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, vp_rate: uint256) -> (uint256, uint256, uint256):
868     # First, need to calculate
869     # * Get current D
870     # * Solve Eqn against y_i for D - _token_amount
871     amp: uint256 = self._A()
872     xp: uint256[N_COINS] = self._xp(vp_rate)
873     D0: uint256 = self.get_D(xp, amp)
874 
875     total_supply: uint256 = self.token.totalSupply()
876     D1: uint256 = D0 - _token_amount * D0 / total_supply
877     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
878 
879     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
880     rates: uint256[N_COINS] = RATES
881     rates[MAX_COIN] = vp_rate
882 
883     xp_reduced: uint256[N_COINS] = xp
884     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
885 
886     for j in range(N_COINS):
887         dx_expected: uint256 = 0
888         if j == i:
889             dx_expected = xp[j] * D1 / D0 - new_y
890         else:
891             dx_expected = xp[j] - xp[j] * D1 / D0
892         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
893 
894     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
895     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
896 
897     return dy, dy_0 - dy, total_supply
898 
899 
900 @view
901 @external
902 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
903     """
904     @notice Calculate the amount received when withdrawing a single coin
905     @param _token_amount Amount of LP tokens to burn in the withdrawal
906     @param i Index value of the coin to withdraw
907     @return Amount of coin received
908     """
909     vp_rate: uint256 = self._vp_rate_ro()
910     return self._calc_withdraw_one_coin(_token_amount, i, vp_rate)[0]
911 
912 
913 @external
914 @nonreentrant('lock')
915 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
916     """
917     @notice Withdraw a single coin from the pool
918     @param _token_amount Amount of LP tokens to burn in the withdrawal
919     @param i Index value of the coin to withdraw
920     @param _min_amount Minimum amount of coin to receive
921     @return Amount of coin received
922     """
923     assert not self.is_killed  # dev: is killed
924 
925     vp_rate: uint256 = self._vp_rate()
926     dy: uint256 = 0
927     dy_fee: uint256 = 0
928     total_supply: uint256 = 0
929     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_token_amount, i, vp_rate)
930     assert dy >= _min_amount, "Not enough coins removed"
931 
932     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
933     self.token.burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
934     assert ERC20(self.coins[i]).transfer(msg.sender, dy)
935 
936     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
937 
938     return dy
939 
940 
941 ### Admin functions ###
942 @external
943 def ramp_A(_future_A: uint256, _future_time: uint256):
944     assert msg.sender == self.owner  # dev: only owner
945     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
946     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
947 
948     _initial_A: uint256 = self._A()
949     _future_A_p: uint256 = _future_A * A_PRECISION
950 
951     assert _future_A > 0 and _future_A < MAX_A
952     if _future_A_p < _initial_A:
953         assert _future_A_p * MAX_A_CHANGE >= _initial_A
954     else:
955         assert _future_A_p <= _initial_A * MAX_A_CHANGE
956 
957     self.initial_A = _initial_A
958     self.future_A = _future_A_p
959     self.initial_A_time = block.timestamp
960     self.future_A_time = _future_time
961 
962     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
963 
964 
965 @external
966 def stop_ramp_A():
967     assert msg.sender == self.owner  # dev: only owner
968 
969     current_A: uint256 = self._A()
970     self.initial_A = current_A
971     self.future_A = current_A
972     self.initial_A_time = block.timestamp
973     self.future_A_time = block.timestamp
974     # now (block.timestamp < t1) is always False, so we return saved A
975 
976     log StopRampA(current_A, block.timestamp)
977 
978 
979 @external
980 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
981     assert msg.sender == self.owner  # dev: only owner
982     assert self.admin_actions_deadline == 0  # dev: active action
983     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
984     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
985 
986     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
987     self.admin_actions_deadline = _deadline
988     self.future_fee = new_fee
989     self.future_admin_fee = new_admin_fee
990 
991     log CommitNewFee(_deadline, new_fee, new_admin_fee)
992 
993 
994 @external
995 def apply_new_fee():
996     assert msg.sender == self.owner  # dev: only owner
997     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
998     assert self.admin_actions_deadline != 0  # dev: no active action
999 
1000     self.admin_actions_deadline = 0
1001     _fee: uint256 = self.future_fee
1002     _admin_fee: uint256 = self.future_admin_fee
1003     self.fee = _fee
1004     self.admin_fee = _admin_fee
1005 
1006     log NewFee(_fee, _admin_fee)
1007 
1008 
1009 @external
1010 def revert_new_parameters():
1011     assert msg.sender == self.owner  # dev: only owner
1012 
1013     self.admin_actions_deadline = 0
1014 
1015 
1016 @external
1017 def commit_transfer_ownership(_owner: address):
1018     assert msg.sender == self.owner  # dev: only owner
1019     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1020 
1021     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1022     self.transfer_ownership_deadline = _deadline
1023     self.future_owner = _owner
1024 
1025     log CommitNewAdmin(_deadline, _owner)
1026 
1027 
1028 @external
1029 def apply_transfer_ownership():
1030     assert msg.sender == self.owner  # dev: only owner
1031     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1032     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1033 
1034     self.transfer_ownership_deadline = 0
1035     _owner: address = self.future_owner
1036     self.owner = _owner
1037 
1038     log NewAdmin(_owner)
1039 
1040 
1041 @external
1042 def revert_transfer_ownership():
1043     assert msg.sender == self.owner  # dev: only owner
1044 
1045     self.transfer_ownership_deadline = 0
1046 
1047 
1048 @view
1049 @external
1050 def admin_balances(i: uint256) -> uint256:
1051     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1052 
1053 
1054 @external
1055 def withdraw_admin_fees():
1056     assert msg.sender == self.owner  # dev: only owner
1057 
1058     for i in range(N_COINS):
1059         c: address = self.coins[i]
1060         value: uint256 = ERC20(c).balanceOf(self) - self.balances[i]
1061         if value > 0:
1062             assert ERC20(c).transfer(msg.sender, value)
1063 
1064 
1065 @external
1066 def donate_admin_fees():
1067     assert msg.sender == self.owner  # dev: only owner
1068     for i in range(N_COINS):
1069         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
1070 
1071 
1072 @external
1073 def kill_me():
1074     assert msg.sender == self.owner  # dev: only owner
1075     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1076     self.is_killed = True
1077 
1078 
1079 @external
1080 def unkill_me():
1081     assert msg.sender == self.owner  # dev: only owner
1082     self.is_killed = False