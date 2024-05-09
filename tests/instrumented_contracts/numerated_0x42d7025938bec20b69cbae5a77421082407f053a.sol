1 # @version 0.2.8
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2021 - all rights reserved
6 @notice Metapool implementation
7 @dev Swaps between 3pool and USDP
8 """
9 
10 from vyper.interfaces import ERC20
11 
12 interface CurveToken:
13     def totalSupply() -> uint256: view
14     def mint(_to: address, _value: uint256) -> bool: nonpayable
15     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
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
103 RATES: constant(uint256[N_COINS]) = [1000000000000000000, 1000000000000000000]
104 BASE_N_COINS: constant(int128) = 3
105 
106 # An asset which may have a transfer fee (USDT)
107 FEE_ASSET: constant(address) = 0xdAC17F958D2ee523a2206206994597C13D831ec7
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
123 lp_token: public(address)
124 
125 # Token corresponding to the pool is always the last one
126 BASE_CACHE_EXPIRES: constant(int128) = 10 * 60  # 10 min
127 base_pool: public(address)
128 base_virtual_price: public(uint256)
129 base_cache_updated: public(uint256)
130 base_coins: public(address[BASE_N_COINS])
131 
132 A_PRECISION: constant(uint256) = 100
133 initial_A: public(uint256)
134 future_A: public(uint256)
135 initial_A_time: public(uint256)
136 future_A_time: public(uint256)
137 
138 admin_actions_deadline: public(uint256)
139 transfer_ownership_deadline: public(uint256)
140 future_fee: public(uint256)
141 future_admin_fee: public(uint256)
142 future_owner: public(address)
143 
144 is_killed: bool
145 kill_deadline: uint256
146 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
147 
148 
149 @external
150 def __init__(
151     _owner: address,
152     _coins: address[N_COINS],
153     _pool_token: address,
154     _base_pool: address,
155     _A: uint256,
156     _fee: uint256,
157     _admin_fee: uint256
158 ):
159     """
160     @notice Contract constructor
161     @param _owner Contract owner address
162     @param _coins Addresses of ERC20 conracts of coins
163     @param _pool_token Address of the token representing LP share
164     @param _base_pool Address of the base pool (which will have a virtual price)
165     @param _A Amplification coefficient multiplied by n * (n - 1)
166     @param _fee Fee to charge for exchanges
167     @param _admin_fee Admin fee
168     """
169     for i in range(N_COINS):
170         assert _coins[i] != ZERO_ADDRESS
171     self.coins = _coins
172     self.initial_A = _A * A_PRECISION
173     self.future_A = _A * A_PRECISION
174     self.fee = _fee
175     self.admin_fee = _admin_fee
176     self.owner = _owner
177     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
178     self.lp_token = _pool_token
179 
180     self.base_pool = _base_pool
181     self.base_virtual_price = Curve(_base_pool).get_virtual_price()
182     self.base_cache_updated = block.timestamp
183     for i in range(BASE_N_COINS):
184         base_coin: address = Curve(_base_pool).coins(convert(i, uint256))
185         self.base_coins[i] = base_coin
186 
187         # approve underlying coins for infinite transfers
188         response: Bytes[32] = raw_call(
189             base_coin,
190             concat(
191                 method_id("approve(address,uint256)"),
192                 convert(_base_pool, bytes32),
193                 convert(MAX_UINT256, bytes32),
194             ),
195             max_outsize=32,
196         )
197         if len(response) > 0:
198             assert convert(response, bool)
199 
200 
201 @view
202 @internal
203 def _A() -> uint256:
204     """
205     Handle ramping A up or down
206     """
207     t1: uint256 = self.future_A_time
208     A1: uint256 = self.future_A
209 
210     if block.timestamp < t1:
211         A0: uint256 = self.initial_A
212         t0: uint256 = self.initial_A_time
213         # Expressions in uint256 cannot have negative numbers, thus "if"
214         if A1 > A0:
215             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
216         else:
217             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
218 
219     else:  # when t1 == 0 or block.timestamp >= t1
220         return A1
221 
222 
223 @view
224 @external
225 def A() -> uint256:
226     return self._A() / A_PRECISION
227 
228 
229 @view
230 @external
231 def A_precise() -> uint256:
232     return self._A()
233 
234 
235 @view
236 @internal
237 def _xp(_vp_rate: uint256) -> uint256[N_COINS]:
238     result: uint256[N_COINS] = RATES
239     result[MAX_COIN] = _vp_rate  # virtual price for the metacurrency
240     for i in range(N_COINS):
241         result[i] = result[i] * self.balances[i] / PRECISION
242     return result
243 
244 
245 @pure
246 @internal
247 def _xp_mem(_vp_rate: uint256, _balances: uint256[N_COINS]) -> uint256[N_COINS]:
248     result: uint256[N_COINS] = RATES
249     result[MAX_COIN] = _vp_rate  # virtual price for the metacurrency
250     for i in range(N_COINS):
251         result[i] = result[i] * _balances[i] / PRECISION
252     return result
253 
254 
255 @internal
256 def _vp_rate() -> uint256:
257     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
258         vprice: uint256 = Curve(self.base_pool).get_virtual_price()
259         self.base_virtual_price = vprice
260         self.base_cache_updated = block.timestamp
261         return vprice
262     else:
263         return self.base_virtual_price
264 
265 
266 @internal
267 @view
268 def _vp_rate_ro() -> uint256:
269     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
270         return Curve(self.base_pool).get_virtual_price()
271     else:
272         return self.base_virtual_price
273 
274 
275 @pure
276 @internal
277 def _get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
278     S: uint256 = 0
279     Dprev: uint256 = 0
280 
281     for _x in _xp:
282         S += _x
283     if S == 0:
284         return 0
285 
286     D: uint256 = S
287     Ann: uint256 = _amp * N_COINS
288     for _i in range(255):
289         D_P: uint256 = D
290         for _x in _xp:
291             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
292         Dprev = D
293         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
294         # Equality with the precision of 1
295         if D > Dprev:
296             if D - Dprev <= 1:
297                 return D
298         else:
299             if Dprev - D <= 1:
300                 return D
301     # convergence typically occurs in 4 rounds or less, this should be unreachable!
302     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
303     raise
304 
305 
306 @view
307 @internal
308 def _get_D_mem(_vp_rate: uint256, _balances: uint256[N_COINS], _amp: uint256) -> uint256:
309     return self._get_D(self._xp_mem(_vp_rate, _balances), _amp)
310 
311 
312 @view
313 @external
314 def get_virtual_price() -> uint256:
315     """
316     @notice The current virtual price of the pool LP token
317     @dev Useful for calculating profits
318     @return LP token virtual price normalized to 1e18
319     """
320     amp: uint256 = self._A()
321     vp_rate: uint256 = self._vp_rate_ro()
322     xp: uint256[N_COINS] = self._xp(vp_rate)
323     D: uint256 = self._get_D(xp, amp)
324     # D is in the units similar to DAI (e.g. converted to precision 1e18)
325     # When balanced, D = n * x_u - total virtual value of the portfolio
326     token_supply: uint256 = CurveToken(self.lp_token).totalSupply()
327     return D * PRECISION / token_supply
328 
329 
330 @view
331 @external
332 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
333     """
334     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
335     @dev This calculation accounts for slippage, but not fees.
336          Needed to prevent front-running, not for precise calculations!
337     @param _amounts Amount of each coin being deposited
338     @param _is_deposit set True for deposits, False for withdrawals
339     @return Expected amount of LP tokens received
340     """
341     amp: uint256 = self._A()
342     vp_rate: uint256 = self._vp_rate_ro()
343     balances: uint256[N_COINS] = self.balances
344     D0: uint256 = self._get_D_mem(vp_rate, balances, amp)
345     for i in range(N_COINS):
346         if _is_deposit:
347             balances[i] += _amounts[i]
348         else:
349             balances[i] -= _amounts[i]
350     D1: uint256 = self._get_D_mem(vp_rate, balances, amp)
351     token_amount: uint256 = CurveToken(self.lp_token).totalSupply()
352     diff: uint256 = 0
353     if _is_deposit:
354         diff = D1 - D0
355     else:
356         diff = D0 - D1
357     return diff * token_amount / D0
358 
359 
360 @external
361 @nonreentrant('lock')
362 def add_liquidity(_amounts: uint256[N_COINS], _min_mint_amount: uint256) -> uint256:
363     """
364     @notice Deposit coins into the pool
365     @param _amounts List of amounts of coins to deposit
366     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
367     @return Amount of LP tokens received by depositing
368     """
369     assert not self.is_killed  # dev: is killed
370 
371     amp: uint256 = self._A()
372     vp_rate: uint256 = self._vp_rate()
373     old_balances: uint256[N_COINS] = self.balances
374 
375     # Initial invariant
376     D0: uint256 = self._get_D_mem(vp_rate, old_balances, amp)
377 
378     lp_token: address = self.lp_token
379     token_supply: uint256 = CurveToken(lp_token).totalSupply()
380     new_balances: uint256[N_COINS] = old_balances
381 
382     for i in range(N_COINS):
383         if token_supply == 0:
384             assert _amounts[i] > 0  # dev: initial deposit requires all coins
385         # balances store amounts of c-tokens
386         new_balances[i] = old_balances[i] + _amounts[i]
387 
388     # Invariant after change
389     D1: uint256 = self._get_D_mem(vp_rate, new_balances, amp)
390     assert D1 > D0
391 
392     # We need to recalculate the invariant accounting for fees
393     # to calculate fair user's share
394     fees: uint256[N_COINS] = empty(uint256[N_COINS])
395     D2: uint256 = D1
396     mint_amount: uint256 = 0
397     if token_supply > 0:
398         fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
399         admin_fee: uint256 = self.admin_fee
400         # Only account for fees if we are not the first to deposit
401         for i in range(N_COINS):
402             ideal_balance: uint256 = D1 * old_balances[i] / D0
403             difference: uint256 = 0
404             if ideal_balance > new_balances[i]:
405                 difference = ideal_balance - new_balances[i]
406             else:
407                 difference = new_balances[i] - ideal_balance
408             fees[i] = fee * difference / FEE_DENOMINATOR
409             self.balances[i] = new_balances[i] - (fees[i] * admin_fee / FEE_DENOMINATOR)
410             new_balances[i] -= fees[i]
411         D2 = self._get_D_mem(vp_rate, new_balances, amp)
412         mint_amount = token_supply * (D2 - D0) / D0
413     else:
414         self.balances = new_balances
415         mint_amount = D1  # Take the dust if there was any
416 
417     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
418 
419     # Take coins from the sender
420     for i in range(N_COINS):
421         if _amounts[i] > 0:
422             # "safeTransferFrom" which works for ERC20s which return bool or not
423             response: Bytes[32] = raw_call(
424                 self.coins[i],
425                 concat(
426                     method_id("transferFrom(address,address,uint256)"),
427                     convert(msg.sender, bytes32),
428                     convert(self, bytes32),
429                     convert(_amounts[i], bytes32),
430                 ),
431                 max_outsize=32,
432             )
433             if len(response) > 0:
434                 assert convert(response, bool)  # dev: failed transfer
435             # end "safeTransferFrom"
436 
437     # Mint pool tokens
438     CurveToken(lp_token).mint(msg.sender, mint_amount)
439 
440     log AddLiquidity(msg.sender, _amounts, fees, D1, token_supply + mint_amount)
441 
442     return mint_amount
443 
444 
445 @view
446 @internal
447 def _get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
448     """
449     Calculate x[j] if one makes x[i] = x
450 
451     Done by solving quadratic equation iteratively.
452     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
453     x_1**2 + b*x_1 = c
454 
455     x_1 = (x_1**2 + c) / (2*x_1 + b)
456     """
457     # x in the input is converted to the same price/precision
458 
459     assert i != j       # dev: same coin
460     assert j >= 0       # dev: j below zero
461     assert j < N_COINS  # dev: j above N_COINS
462 
463     # should be unreachable, but good for safety
464     assert i >= 0
465     assert i < N_COINS
466 
467     A: uint256 = self._A()
468     D: uint256 = self._get_D(_xp, A)
469     Ann: uint256 = A * N_COINS
470     c: uint256 = D
471     S: uint256 = 0
472     _x: uint256 = 0
473     y_prev: uint256 = 0
474 
475     for _i in range(N_COINS):
476         if _i == i:
477             _x = x
478         elif _i != j:
479             _x = _xp[_i]
480         else:
481             continue
482         S += _x
483         c = c * D / (_x * N_COINS)
484     c = c * D * A_PRECISION / (Ann * N_COINS)
485     b: uint256 = S + D * A_PRECISION / Ann  # - D
486     y: uint256 = D
487     for _i in range(255):
488         y_prev = y
489         y = (y*y + c) / (2 * y + b - D)
490         # Equality with the precision of 1
491         if y > y_prev:
492             if y - y_prev <= 1:
493                 return y
494         else:
495             if y_prev - y <= 1:
496                 return y
497     raise
498 
499 
500 @view
501 @external
502 def get_dy(i: int128, j: int128, _dx: uint256) -> uint256:
503     rates: uint256[N_COINS] = RATES
504     rates[MAX_COIN] = self._vp_rate_ro()
505     xp: uint256[N_COINS] = self._xp(rates[MAX_COIN])
506 
507     x: uint256 = xp[i] + (_dx * rates[i] / PRECISION)
508     y: uint256 = self._get_y(i, j, x, xp)
509     dy: uint256 = xp[j] - y - 1
510     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
511     return (dy - fee) * PRECISION / rates[j]
512 
513 
514 @view
515 @external
516 def get_dy_underlying(i: int128, j: int128, _dx: uint256) -> uint256:
517     # dx and dy in underlying units
518     vp_rate: uint256 = self._vp_rate_ro()
519     xp: uint256[N_COINS] = self._xp(vp_rate)
520     base_pool: address = self.base_pool
521 
522     # Use base_i or base_j if they are >= 0
523     base_i: int128 = i - MAX_COIN
524     base_j: int128 = j - MAX_COIN
525     meta_i: int128 = MAX_COIN
526     meta_j: int128 = MAX_COIN
527     if base_i < 0:
528         meta_i = i
529     if base_j < 0:
530         meta_j = j
531 
532     x: uint256 = 0
533     if base_i < 0:
534         x = xp[i] + _dx
535     else:
536         if base_j < 0:
537             # i is from BasePool
538             # At first, get the amount of pool tokens
539             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
540             base_inputs[base_i] = _dx
541             # Token amount transformed to underlying "dollars"
542             x = Curve(base_pool).calc_token_amount(base_inputs, True) * vp_rate / PRECISION
543             # Accounting for deposit/withdraw fees approximately
544             x -= x * Curve(base_pool).fee() / (2 * FEE_DENOMINATOR)
545             # Adding number of pool tokens
546             x += xp[MAX_COIN]
547         else:
548             # If both are from the base pool
549             return Curve(base_pool).get_dy(base_i, base_j, _dx)
550 
551     # This pool is involved only when in-pool assets are used
552     y: uint256 = self._get_y(meta_i, meta_j, x, xp)
553     dy: uint256 = xp[meta_j] - y - 1
554     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
555 
556     # If output is going via the metapool
557     if base_j >= 0:
558         # j is from BasePool
559         # The fee is already accounted for
560         dy = Curve(base_pool).calc_withdraw_one_coin(dy * PRECISION / vp_rate, base_j)
561 
562     return dy
563 
564 
565 @external
566 @nonreentrant('lock')
567 def exchange(i: int128, j: int128, _dx: uint256, _min_dy: uint256) -> uint256:
568     """
569     @notice Perform an exchange between two coins
570     @dev Index values can be found via the `coins` public getter method
571     @param i Index value for the coin to send
572     @param j Index valie of the coin to recieve
573     @param _dx Amount of `i` being exchanged
574     @param _min_dy Minimum amount of `j` to receive
575     @return Actual amount of `j` received
576     """
577     assert not self.is_killed  # dev: is killed
578     rates: uint256[N_COINS] = RATES
579     rates[MAX_COIN] = self._vp_rate()
580 
581     old_balances: uint256[N_COINS] = self.balances
582     xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
583 
584     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
585     y: uint256 = self._get_y(i, j, x, xp)
586 
587     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
588     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
589 
590     # Convert all to real units
591     dy = (dy - dy_fee) * PRECISION / rates[j]
592     assert dy >= _min_dy, "Too few coins in result"
593 
594     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
595     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
596 
597     # Change balances exactly in same way as we change actual ERC20 coin amounts
598     self.balances[i] = old_balances[i] + _dx
599     # When rounding errors happen, we undercharge admin fee in favor of LP
600     self.balances[j] = old_balances[j] - dy - dy_admin_fee
601 
602     response: Bytes[32] = raw_call(
603         self.coins[i],
604         concat(
605             method_id("transferFrom(address,address,uint256)"),
606             convert(msg.sender, bytes32),
607             convert(self, bytes32),
608             convert(_dx, bytes32),
609         ),
610         max_outsize=32,
611     )
612     if len(response) > 0:
613         assert convert(response, bool)
614 
615     response = raw_call(
616         self.coins[j],
617         concat(
618             method_id("transfer(address,uint256)"),
619             convert(msg.sender, bytes32),
620             convert(dy, bytes32),
621         ),
622         max_outsize=32,
623     )
624     if len(response) > 0:
625         assert convert(response, bool)
626 
627     log TokenExchange(msg.sender, i, _dx, j, dy)
628 
629     return dy
630 
631 
632 @external
633 @nonreentrant('lock')
634 def exchange_underlying(i: int128, j: int128, _dx: uint256, _min_dy: uint256) -> uint256:
635     """
636     @notice Perform an exchange between two underlying coins
637     @dev Index values can be found via the `underlying_coins` public getter method
638     @param i Index value for the underlying coin to send
639     @param j Index valie of the underlying coin to recieve
640     @param _dx Amount of `i` being exchanged
641     @param _min_dy Minimum amount of `j` to receive
642     @return Actual amount of `j` received
643     """
644     assert not self.is_killed  # dev: is killed
645     rates: uint256[N_COINS] = RATES
646     rates[MAX_COIN] = self._vp_rate()
647     base_pool: address = self.base_pool
648 
649     # Use base_i or base_j if they are >= 0
650     base_i: int128 = i - MAX_COIN
651     base_j: int128 = j - MAX_COIN
652     meta_i: int128 = MAX_COIN
653     meta_j: int128 = MAX_COIN
654     if base_i < 0:
655         meta_i = i
656     if base_j < 0:
657         meta_j = j
658     dy: uint256 = 0
659 
660     # Addresses for input and output coins
661     input_coin: address = ZERO_ADDRESS
662     output_coin: address = ZERO_ADDRESS
663     if base_i < 0:
664         input_coin = self.coins[i]
665     else:
666         input_coin = self.base_coins[base_i]
667     if base_j < 0:
668         output_coin = self.coins[j]
669     else:
670         output_coin = self.base_coins[base_j]
671 
672     # Handle potential Tether fees
673     dx_w_fee: uint256 = _dx
674     if input_coin == FEE_ASSET:
675         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self)
676 
677     response: Bytes[32] = raw_call(
678         input_coin,
679         concat(
680             method_id("transferFrom(address,address,uint256)"),
681             convert(msg.sender, bytes32),
682             convert(self, bytes32),
683             convert(_dx, bytes32),
684         ),
685         max_outsize=32,
686     )
687     if len(response) > 0:
688         assert convert(response, bool)
689 
690     # Handle potential Tether fees
691     if input_coin == FEE_ASSET:
692         dx_w_fee = ERC20(FEE_ASSET).balanceOf(self) - dx_w_fee
693 
694     if base_i < 0 or base_j < 0:
695         old_balances: uint256[N_COINS] = self.balances
696         xp: uint256[N_COINS] = self._xp_mem(rates[MAX_COIN], old_balances)
697 
698         x: uint256 = 0
699         if base_i < 0:
700             x = xp[i] + dx_w_fee * rates[i] / PRECISION
701         else:
702             # i is from BasePool
703             # At first, get the amount of pool tokens
704             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
705             base_inputs[base_i] = dx_w_fee
706             coin_i: address = self.coins[MAX_COIN]
707             # Deposit and measure delta
708             x = ERC20(coin_i).balanceOf(self)
709             Curve(base_pool).add_liquidity(base_inputs, 0)
710             # Need to convert pool token to "virtual" units using rates
711             # dx is also different now
712             dx_w_fee = ERC20(coin_i).balanceOf(self) - x
713             x = dx_w_fee * rates[MAX_COIN] / PRECISION
714             # Adding number of pool tokens
715             x += xp[MAX_COIN]
716 
717         y: uint256 = self._get_y(meta_i, meta_j, x, xp)
718 
719         # Either a real coin or token
720         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
721         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
722 
723         # Convert all to real units
724         # Works for both pool coins and real coins
725         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
726 
727         dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
728         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
729 
730         # Change balances exactly in same way as we change actual ERC20 coin amounts
731         self.balances[meta_i] = old_balances[meta_i] + dx_w_fee
732         # When rounding errors happen, we undercharge admin fee in favor of LP
733         self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee
734 
735         # Withdraw from the base pool if needed
736         if base_j >= 0:
737             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
738             Curve(base_pool).remove_liquidity_one_coin(dy, base_j, 0)
739             dy = ERC20(output_coin).balanceOf(self) - out_amount
740 
741         assert dy >= _min_dy, "Too few coins in result"
742 
743     else:
744         # If both are from the base pool
745         dy = ERC20(output_coin).balanceOf(self)
746         Curve(base_pool).exchange(base_i, base_j, dx_w_fee, _min_dy)
747         dy = ERC20(output_coin).balanceOf(self) - dy
748 
749     # "safeTransfer" which works for ERC20s which return bool or not
750     response = raw_call(
751         output_coin,
752         concat(
753             method_id("transfer(address,uint256)"),
754             convert(msg.sender, bytes32),
755             convert(dy, bytes32),
756         ),
757         max_outsize=32,
758     )  # dev: failed transfer
759     if len(response) > 0:
760         assert convert(response, bool)  # dev: failed transfer
761     # end "safeTransfer"
762 
763     log TokenExchangeUnderlying(msg.sender, i, _dx, j, dy)
764 
765     return dy
766 
767 
768 @external
769 @nonreentrant('lock')
770 def remove_liquidity(_amount: uint256, _min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
771     """
772     @notice Withdraw coins from the pool
773     @dev Withdrawal amounts are based on current deposit ratios
774     @param _amount Quantity of LP tokens to burn in the withdrawal
775     @param _min_amounts Minimum amounts of underlying coins to receive
776     @return List of amounts of coins that were withdrawn
777     """
778     lp_token: address = self.lp_token
779     total_supply: uint256 = CurveToken(lp_token).totalSupply()
780     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
781 
782     for i in range(N_COINS):
783         old_balance: uint256 = self.balances[i]
784         value: uint256 = old_balance * _amount / total_supply
785         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
786         self.balances[i] = old_balance - value
787         amounts[i] = value
788         ERC20(self.coins[i]).transfer(msg.sender, value)
789 
790     CurveToken(lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
791 
792     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply - _amount)
793 
794     return amounts
795 
796 
797 @external
798 @nonreentrant('lock')
799 def remove_liquidity_imbalance(_amounts: uint256[N_COINS], _max_burn_amount: uint256) -> uint256:
800     """
801     @notice Withdraw coins from the pool in an imbalanced amount
802     @param _amounts List of amounts of underlying coins to withdraw
803     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
804     @return Actual amount of the LP token burned in the withdrawal
805     """
806     assert not self.is_killed  # dev: is killed
807 
808     amp: uint256 = self._A()
809     vp_rate: uint256 = self._vp_rate()
810     old_balances: uint256[N_COINS] = self.balances
811     new_balances: uint256[N_COINS] = old_balances
812     D0: uint256 = self._get_D_mem(vp_rate, old_balances, amp)
813     for i in range(N_COINS):
814         new_balances[i] -= _amounts[i]
815     D1: uint256 = self._get_D_mem(vp_rate, new_balances, amp)
816 
817     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
818     admin_fee: uint256 = self.admin_fee
819     fees: uint256[N_COINS] = empty(uint256[N_COINS])
820     for i in range(N_COINS):
821         ideal_balance: uint256 = D1 * old_balances[i] / D0
822         difference: uint256 = 0
823         if ideal_balance > new_balances[i]:
824             difference = ideal_balance - new_balances[i]
825         else:
826             difference = new_balances[i] - ideal_balance
827         fees[i] = fee * difference / FEE_DENOMINATOR
828         self.balances[i] = new_balances[i] - (fees[i] * admin_fee / FEE_DENOMINATOR)
829         new_balances[i] -= fees[i]
830     D2: uint256 = self._get_D_mem(vp_rate, new_balances, amp)
831 
832     lp_token: address = self.lp_token
833     token_supply: uint256 = CurveToken(lp_token).totalSupply()
834     token_amount: uint256 = (D0 - D2) * token_supply / D0
835     assert token_amount != 0  # dev: zero tokens burned
836     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
837     assert token_amount <= _max_burn_amount, "Slippage screwed you"
838 
839     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
840     for i in range(N_COINS):
841         if _amounts[i] != 0:
842             ERC20(self.coins[i]).transfer(msg.sender, _amounts[i])
843 
844     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, token_supply - token_amount)
845 
846     return token_amount
847 
848 
849 @pure
850 @internal
851 def _get_y_D(A: uint256, i: int128, _xp: uint256[N_COINS], D: uint256) -> uint256:
852     """
853     Calculate x[i] if one reduces D from being calculated for xp to D
854 
855     Done by solving quadratic equation iteratively.
856     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
857     x_1**2 + b*x_1 = c
858 
859     x_1 = (x_1**2 + c) / (2*x_1 + b)
860     """
861     # x in the input is converted to the same price/precision
862 
863     assert i >= 0  # dev: i below zero
864     assert i < N_COINS  # dev: i above N_COINS
865 
866     Ann: uint256 = A * N_COINS
867     c: uint256 = D
868     S: uint256 = 0
869     _x: uint256 = 0
870     y_prev: uint256 = 0
871 
872     for _i in range(N_COINS):
873         if _i != i:
874             _x = _xp[_i]
875         else:
876             continue
877         S += _x
878         c = c * D / (_x * N_COINS)
879     c = c * D * A_PRECISION / (Ann * N_COINS)
880     b: uint256 = S + D * A_PRECISION / Ann
881     y: uint256 = D
882 
883     for _i in range(255):
884         y_prev = y
885         y = (y*y + c) / (2 * y + b - D)
886         # Equality with the precision of 1
887         if y > y_prev:
888             if y - y_prev <= 1:
889                 return y
890         else:
891             if y_prev - y <= 1:
892                 return y
893     raise
894 
895 
896 @view
897 @internal
898 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, _vp_rate: uint256) -> (uint256, uint256, uint256):
899     # First, need to calculate
900     # * Get current D
901     # * Solve Eqn against y_i for D - _token_amount
902     amp: uint256 = self._A()
903     xp: uint256[N_COINS] = self._xp(_vp_rate)
904     D0: uint256 = self._get_D(xp, amp)
905 
906     total_supply: uint256 = CurveToken(self.lp_token).totalSupply()
907     D1: uint256 = D0 - _token_amount * D0 / total_supply
908     new_y: uint256 = self._get_y_D(amp, i, xp, D1)
909 
910     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
911     rates: uint256[N_COINS] = RATES
912     rates[MAX_COIN] = _vp_rate
913 
914     xp_reduced: uint256[N_COINS] = xp
915     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
916 
917     for j in range(N_COINS):
918         dx_expected: uint256 = 0
919         if j == i:
920             dx_expected = xp[j] * D1 / D0 - new_y
921         else:
922             dx_expected = xp[j] - xp[j] * D1 / D0
923         xp_reduced[j] -= fee * dx_expected / FEE_DENOMINATOR
924 
925     dy: uint256 = xp_reduced[i] - self._get_y_D(amp, i, xp_reduced, D1)
926     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
927 
928     return dy, dy_0 - dy, total_supply
929 
930 
931 @view
932 @external
933 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
934     """
935     @notice Calculate the amount received when withdrawing a single coin
936     @param _token_amount Amount of LP tokens to burn in the withdrawal
937     @param i Index value of the coin to withdraw
938     @return Amount of coin received
939     """
940     vp_rate: uint256 = self._vp_rate_ro()
941     return self._calc_withdraw_one_coin(_token_amount, i, vp_rate)[0]
942 
943 
944 @external
945 @nonreentrant('lock')
946 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
947     """
948     @notice Withdraw a single coin from the pool
949     @param _token_amount Amount of LP tokens to burn in the withdrawal
950     @param i Index value of the coin to withdraw
951     @param _min_amount Minimum amount of coin to receive
952     @return Amount of coin received
953     """
954     assert not self.is_killed  # dev: is killed
955 
956     vp_rate: uint256 = self._vp_rate()
957     dy: uint256 = 0
958     dy_fee: uint256 = 0
959     total_supply: uint256 = 0
960     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_token_amount, i, vp_rate)
961     assert dy >= _min_amount, "Not enough coins removed"
962 
963     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
964     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
965 
966     ERC20(self.coins[i]).transfer(msg.sender, dy)
967 
968     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
969 
970     return dy
971 
972 
973 ### Admin functions ###
974 @external
975 def ramp_A(_future_A: uint256, _future_time: uint256):
976     assert msg.sender == self.owner  # dev: only owner
977     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
978     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
979 
980     initial_A: uint256 = self._A()
981     future_A_p: uint256 = _future_A * A_PRECISION
982 
983     assert _future_A > 0 and _future_A < MAX_A
984     if future_A_p < initial_A:
985         assert future_A_p * MAX_A_CHANGE >= initial_A
986     else:
987         assert future_A_p <= initial_A * MAX_A_CHANGE
988 
989     self.initial_A = initial_A
990     self.future_A = future_A_p
991     self.initial_A_time = block.timestamp
992     self.future_A_time = _future_time
993 
994     log RampA(initial_A, future_A_p, block.timestamp, _future_time)
995 
996 
997 @external
998 def stop_ramp_A():
999     assert msg.sender == self.owner  # dev: only owner
1000 
1001     current_A: uint256 = self._A()
1002     self.initial_A = current_A
1003     self.future_A = current_A
1004     self.initial_A_time = block.timestamp
1005     self.future_A_time = block.timestamp
1006     # now (block.timestamp < t1) is always False, so we return saved A
1007 
1008     log StopRampA(current_A, block.timestamp)
1009 
1010 
1011 @external
1012 def commit_new_fee(_new_fee: uint256, _new_admin_fee: uint256):
1013     assert msg.sender == self.owner  # dev: only owner
1014     assert self.admin_actions_deadline == 0  # dev: active action
1015     assert _new_fee <= MAX_FEE  # dev: fee exceeds maximum
1016     assert _new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
1017 
1018     deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1019     self.admin_actions_deadline = deadline
1020     self.future_fee = _new_fee
1021     self.future_admin_fee = _new_admin_fee
1022 
1023     log CommitNewFee(deadline, _new_fee, _new_admin_fee)
1024 
1025 
1026 @external
1027 def apply_new_fee():
1028     assert msg.sender == self.owner  # dev: only owner
1029     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
1030     assert self.admin_actions_deadline != 0  # dev: no active action
1031 
1032     self.admin_actions_deadline = 0
1033     fee: uint256 = self.future_fee
1034     admin_fee: uint256 = self.future_admin_fee
1035     self.fee = fee
1036     self.admin_fee = admin_fee
1037 
1038     log NewFee(fee, admin_fee)
1039 
1040 
1041 @external
1042 def revert_new_parameters():
1043     assert msg.sender == self.owner  # dev: only owner
1044 
1045     self.admin_actions_deadline = 0
1046 
1047 
1048 @external
1049 def commit_transfer_ownership(_owner: address):
1050     assert msg.sender == self.owner  # dev: only owner
1051     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1052 
1053     deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1054     self.transfer_ownership_deadline = deadline
1055     self.future_owner = _owner
1056 
1057     log CommitNewAdmin(deadline, _owner)
1058 
1059 
1060 @external
1061 def apply_transfer_ownership():
1062     assert msg.sender == self.owner  # dev: only owner
1063     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1064     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1065 
1066     self.transfer_ownership_deadline = 0
1067     owner: address = self.future_owner
1068     self.owner = owner
1069 
1070     log NewAdmin(owner)
1071 
1072 
1073 @external
1074 def revert_transfer_ownership():
1075     assert msg.sender == self.owner  # dev: only owner
1076 
1077     self.transfer_ownership_deadline = 0
1078 
1079 
1080 @view
1081 @external
1082 def admin_balances(i: uint256) -> uint256:
1083     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1084 
1085 
1086 @external
1087 def withdraw_admin_fees():
1088     assert msg.sender == self.owner  # dev: only owner
1089 
1090     for i in range(N_COINS):
1091         coin: address = self.coins[i]
1092         value: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
1093         if value > 0:
1094             ERC20(coin).transfer(msg.sender, value)
1095 
1096 @external
1097 def donate_admin_fees():
1098     assert msg.sender == self.owner  # dev: only owner
1099     for i in range(N_COINS):
1100         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
1101 
1102 
1103 @external
1104 def kill_me():
1105     assert msg.sender == self.owner  # dev: only owner
1106     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1107     self.is_killed = True
1108 
1109 
1110 @external
1111 def unkill_me():
1112     assert msg.sender == self.owner  # dev: only owner
1113     self.is_killed = False