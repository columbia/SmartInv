1 # @version 0.2.8
2 """
3 @title Curve saPool
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 @notice Pool implementation with aToken-style lending
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 
12 interface LendingPool:
13     def withdraw(_underlying_asset: address, _amount: uint256, _receiver: address): nonpayable
14 
15 interface CurveToken:
16     def mint(_to: address, _value: uint256) -> bool: nonpayable
17     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
18 
19 
20 # Events
21 event TokenExchange:
22     buyer: indexed(address)
23     sold_id: int128
24     tokens_sold: uint256
25     bought_id: int128
26     tokens_bought: uint256
27 
28 event TokenExchangeUnderlying:
29     buyer: indexed(address)
30     sold_id: int128
31     tokens_sold: uint256
32     bought_id: int128
33     tokens_bought: uint256
34 
35 event AddLiquidity:
36     provider: indexed(address)
37     token_amounts: uint256[N_COINS]
38     fees: uint256[N_COINS]
39     invariant: uint256
40     token_supply: uint256
41 
42 event RemoveLiquidity:
43     provider: indexed(address)
44     token_amounts: uint256[N_COINS]
45     fees: uint256[N_COINS]
46     token_supply: uint256
47 
48 event RemoveLiquidityOne:
49     provider: indexed(address)
50     token_amount: uint256
51     coin_amount: uint256
52 
53 event RemoveLiquidityImbalance:
54     provider: indexed(address)
55     token_amounts: uint256[N_COINS]
56     fees: uint256[N_COINS]
57     invariant: uint256
58     token_supply: uint256
59 
60 event CommitNewAdmin:
61     deadline: indexed(uint256)
62     admin: indexed(address)
63 
64 event NewAdmin:
65     admin: indexed(address)
66 
67 event CommitNewFee:
68     deadline: indexed(uint256)
69     fee: uint256
70     admin_fee: uint256
71     offpeg_fee_multiplier: uint256
72 
73 event NewFee:
74     fee: uint256
75     admin_fee: uint256
76     offpeg_fee_multiplier: uint256
77 
78 event RampA:
79     old_A: uint256
80     new_A: uint256
81     initial_time: uint256
82     future_time: uint256
83 
84 event StopRampA:
85     A: uint256
86     t: uint256
87 
88 
89 N_COINS: constant(int128) = 2
90 
91 # fixed constants
92 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
93 PRECISION: constant(uint256) = 10 ** 18
94 
95 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
96 MAX_FEE: constant(uint256) = 5 * 10 ** 9
97 
98 MAX_A: constant(uint256) = 10 ** 6
99 MAX_A_CHANGE: constant(uint256) = 10
100 A_PRECISION: constant(uint256) = 100
101 
102 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
103 MIN_RAMP_TIME: constant(uint256) = 86400
104 
105 coins: public(address[N_COINS])
106 underlying_coins: public(address[N_COINS])
107 admin_balances: public(uint256[N_COINS])
108 
109 fee: public(uint256)  # fee * 1e10
110 offpeg_fee_multiplier: public(uint256)  # * 1e10
111 admin_fee: public(uint256)  # admin_fee * 1e10
112 
113 owner: public(address)
114 lp_token: public(address)
115 
116 aave_lending_pool: address
117 aave_referral: uint256
118 
119 initial_A: public(uint256)
120 future_A: public(uint256)
121 initial_A_time: public(uint256)
122 future_A_time: public(uint256)
123 
124 admin_actions_deadline: public(uint256)
125 transfer_ownership_deadline: public(uint256)
126 future_fee: public(uint256)
127 future_admin_fee: public(uint256)
128 future_offpeg_fee_multiplier: public(uint256)  # * 1e10
129 future_owner: public(address)
130 
131 is_killed: bool
132 kill_deadline: uint256
133 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
134 
135 
136 @external
137 def __init__(
138     _coins: address[N_COINS],
139     _underlying_coins: address[N_COINS],
140     _pool_token: address,
141     _aave_lending_pool: address,
142     _A: uint256,
143     _fee: uint256,
144     _admin_fee: uint256,
145     _offpeg_fee_multiplier: uint256,
146 ):
147     """
148     @notice Contract constructor
149     @param _coins List of wrapped coin addresses
150     @param _underlying_coins List of underlying coin addresses
151     @param _pool_token Pool LP token address
152     @param _aave_lending_pool Aave lending pool address
153     @param _A Amplification coefficient multiplied by n * (n - 1)
154     @param _fee Swap fee expressed as an integer with 1e10 precision
155     @param _admin_fee Percentage of fee taken as an admin fee,
156                       expressed as an integer with 1e10 precision
157     @param _offpeg_fee_multiplier Offpeg fee multiplier
158     """
159     for i in range(N_COINS):
160         assert _coins[i] != ZERO_ADDRESS
161         assert _underlying_coins[i] != ZERO_ADDRESS
162 
163     self.coins = _coins
164     self.underlying_coins = _underlying_coins
165     self.initial_A = _A * A_PRECISION
166     self.future_A = _A * A_PRECISION
167     self.fee = _fee
168     self.admin_fee = _admin_fee
169     self.offpeg_fee_multiplier = _offpeg_fee_multiplier
170     self.owner = msg.sender
171     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
172     self.lp_token = _pool_token
173     self.aave_lending_pool = _aave_lending_pool
174 
175     # approve transfer of underlying coin to aave lending pool
176     for coin in _underlying_coins:
177         assert ERC20(coin).approve(_aave_lending_pool, MAX_UINT256)
178 
179 
180 @view
181 @internal
182 def _A() -> uint256:
183     t1: uint256 = self.future_A_time
184     A1: uint256 = self.future_A
185 
186     if block.timestamp < t1:
187         # handle ramping up and down of A
188         A0: uint256 = self.initial_A
189         t0: uint256 = self.initial_A_time
190         # Expressions in uint256 cannot have negative numbers, thus "if"
191         if A1 > A0:
192             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
193         else:
194             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
195 
196     else:  # when t1 == 0 or block.timestamp >= t1
197         return A1
198 
199 
200 @view
201 @external
202 def A() -> uint256:
203     return self._A() / A_PRECISION
204 
205 
206 @view
207 @external
208 def A_precise() -> uint256:
209     return self._A()
210 
211 
212 @pure
213 @internal
214 def _dynamic_fee(xpi: uint256, xpj: uint256, _fee: uint256, _feemul: uint256) -> uint256:
215     if _feemul <= FEE_DENOMINATOR:
216         return _fee
217     else:
218         xps2: uint256 = (xpi + xpj)
219         xps2 *= xps2  # Doing just ** 2 can overflow apparently
220         return (_feemul * _fee) / (
221             (_feemul - FEE_DENOMINATOR) * 4 * xpi * xpj / xps2 + \
222             FEE_DENOMINATOR)
223 
224 
225 @view
226 @external
227 def dynamic_fee(i: int128, j: int128) -> uint256:
228     """
229     @notice Return the fee for swapping between `i` and `j`
230     @param i Index value for the coin to send
231     @param j Index value of the coin to recieve
232     @return Swap fee expressed as an integer with 1e10 precision
233     """
234     xpi: uint256 = (ERC20(self.coins[i]).balanceOf(self) - self.admin_balances[i])
235     xpj: uint256 = (ERC20(self.coins[j]).balanceOf(self) - self.admin_balances[j])
236     return self._dynamic_fee(xpi, xpj, self.fee, self.offpeg_fee_multiplier)
237 
238 
239 @view
240 @external
241 def balances(i: uint256) -> uint256:
242     """
243     @notice Get the current balance of a coin within the
244             pool, less the accrued admin fees
245     @param i Index value for the coin to query balance of
246     @return Token balance
247     """
248     return ERC20(self.coins[i]).balanceOf(self) - self.admin_balances[i]
249 
250 
251 @view
252 @internal
253 def _balances() -> uint256[N_COINS]:
254     result: uint256[N_COINS] = empty(uint256[N_COINS])
255     for i in range(N_COINS):
256         result[i] = ERC20(self.coins[i]).balanceOf(self) - self.admin_balances[i]
257     return result
258 
259 
260 @pure
261 @internal
262 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
263     """
264     D invariant calculation in non-overflowing integer operations
265     iteratively
266 
267     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
268 
269     Converging solution:
270     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
271     """
272     S: uint256 = 0
273 
274     for _x in xp:
275         S += _x
276     if S == 0:
277         return 0
278 
279     Dprev: uint256 = 0
280     D: uint256 = S
281     Ann: uint256 = amp * N_COINS
282     for _i in range(255):
283         D_P: uint256 = D
284         for _x in xp:
285             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
286         Dprev = D
287         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
288         # Equality with the precision of 1
289         if D > Dprev:
290             if D - Dprev <= 1:
291                 return D
292         else:
293             if Dprev - D <= 1:
294                 return D
295     # convergence typically occurs in 4 rounds or less, this should be unreachable!
296     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
297     raise
298 
299 
300 @view
301 @external
302 def get_virtual_price() -> uint256:
303     """
304     @notice The current virtual price of the pool LP token
305     @dev Useful for calculating profits
306     @return LP token virtual price normalized to 1e18
307     """
308     D: uint256 = self.get_D(self._balances(), self._A())
309     # D is in the units similar to DAI (e.g. converted to precision 1e18)
310     # When balanced, D = n * x_u - total virtual value of the portfolio
311     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
312     return D * PRECISION / token_supply
313 
314 
315 @view
316 @external
317 def calc_token_amount(_amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
318     """
319     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
320     @dev This calculation accounts for slippage, but not fees.
321          Needed to prevent front-running, not for precise calculations!
322     @param _amounts Amount of each coin being deposited
323     @param is_deposit set True for deposits, False for withdrawals
324     @return Expected amount of LP tokens received
325     """
326     coin_balances: uint256[N_COINS] = self._balances()
327     amp: uint256 = self._A()
328     D0: uint256 = self.get_D(coin_balances, amp)
329     for i in range(N_COINS):
330         if is_deposit:
331             coin_balances[i] += _amounts[i]
332         else:
333             coin_balances[i] -= _amounts[i]
334     D1: uint256 = self.get_D(coin_balances, amp)
335     token_amount: uint256 = ERC20(self.lp_token).totalSupply()
336     diff: uint256 = 0
337     if is_deposit:
338         diff = D1 - D0
339     else:
340         diff = D0 - D1
341     return diff * token_amount / D0
342 
343 
344 @external
345 @nonreentrant('lock')
346 def add_liquidity(_amounts: uint256[N_COINS], _min_mint_amount: uint256, _use_underlying: bool = False) -> uint256:
347     """
348     @notice Deposit coins into the pool
349     @param _amounts List of amounts of coins to deposit
350     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
351     @param _use_underlying If True, deposit underlying assets instead of aTokens
352     @return Amount of LP tokens received by depositing
353     """
354 
355     assert not self.is_killed  # dev: is killed
356 
357     # Initial invariant
358     amp: uint256 = self._A()
359     old_balances: uint256[N_COINS] = self._balances()
360     lp_token: address = self.lp_token
361     token_supply: uint256 = ERC20(lp_token).totalSupply()
362     D0: uint256 = 0
363     if token_supply != 0:
364         D0 = self.get_D(old_balances, amp)
365 
366     new_balances: uint256[N_COINS] = old_balances
367     for i in range(N_COINS):
368         if token_supply == 0:
369             assert _amounts[i] != 0  # dev: initial deposit requires all coins
370         new_balances[i] += _amounts[i]
371 
372     # Invariant after change
373     D1: uint256 = self.get_D(new_balances, amp)
374     assert D1 > D0
375 
376     # We need to recalculate the invariant accounting for fees
377     # to calculate fair user's share
378     fees: uint256[N_COINS] = empty(uint256[N_COINS])
379     mint_amount: uint256 = 0
380     if token_supply != 0:
381         # Only account for fees if we are not the first to deposit
382         ys: uint256 = (D0 + D1) / N_COINS
383         _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
384         _feemul: uint256 = self.offpeg_fee_multiplier
385         _admin_fee: uint256 = self.admin_fee
386         difference: uint256 = 0
387         for i in range(N_COINS):
388             ideal_balance: uint256 = D1 * old_balances[i] / D0
389             new_balance: uint256 = new_balances[i]
390             if ideal_balance > new_balance:
391                 difference = ideal_balance - new_balance
392             else:
393                 difference = new_balance - ideal_balance
394             xs: uint256 = old_balances[i] + new_balance
395             fees[i] = self._dynamic_fee(xs, ys, _fee, _feemul) * difference / FEE_DENOMINATOR
396             if _admin_fee != 0:
397                 self.admin_balances[i] += fees[i] * _admin_fee / FEE_DENOMINATOR
398             new_balances[i] = new_balance - fees[i]
399         D2: uint256 = self.get_D(new_balances, amp)
400         mint_amount = token_supply * (D2 - D0) / D0
401     else:
402         mint_amount = D1  # Take the dust if there was any
403 
404     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
405 
406     # Take coins from the sender
407     if _use_underlying:
408         lending_pool: address = self.aave_lending_pool
409         aave_referral: bytes32 = convert(self.aave_referral, bytes32)
410 
411         # Take coins from the sender
412         for i in range(N_COINS):
413             amount: uint256 = _amounts[i]
414             if amount != 0:
415                 coin: address = self.underlying_coins[i]
416                 # transfer underlying coin from msg.sender to self
417                 assert ERC20(coin).transferFrom(msg.sender, self, amount)
418 
419                 # deposit to aave lending pool
420                 raw_call(
421                     lending_pool,
422                     concat(
423                         method_id("deposit(address,uint256,address,uint16)"),
424                         convert(coin, bytes32),
425                         convert(amount, bytes32),
426                         convert(self, bytes32),
427                         aave_referral,
428                     )
429                 )
430     else:
431         for i in range(N_COINS):
432             amount: uint256 = _amounts[i]
433             if amount != 0:
434                 assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amount) # dev: failed transfer
435 
436     # Mint pool tokens
437     CurveToken(lp_token).mint(msg.sender, mint_amount)
438 
439     log AddLiquidity(msg.sender, _amounts, fees, D1, token_supply + mint_amount)
440 
441     return mint_amount
442 
443 
444 @view
445 @internal
446 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
447     """
448     Calculate x[j] if one makes x[i] = x
449 
450     Done by solving quadratic equation iteratively.
451     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
452     x_1**2 + b*x_1 = c
453 
454     x_1 = (x_1**2 + c) / (2*x_1 + b)
455     """
456     # x in the input is converted to the same price/precision
457 
458     assert i != j       # dev: same coin
459     assert j >= 0       # dev: j below zero
460     assert j < N_COINS  # dev: j above N_COINS
461 
462     # should be unreachable, but good for safety
463     assert i >= 0
464     assert i < N_COINS
465 
466     amp: uint256 = self._A()
467     D: uint256 = self.get_D(xp, amp)
468     Ann: uint256 = amp * N_COINS
469     c: uint256 = D
470     S_: uint256 = 0
471     _x: uint256 = 0
472     y_prev: uint256 = 0
473 
474     for _i in range(N_COINS):
475         if _i == i:
476             _x = x
477         elif _i != j:
478             _x = xp[_i]
479         else:
480             continue
481         S_ += _x
482         c = c * D / (_x * N_COINS)
483     c = c * D * A_PRECISION / (Ann * N_COINS)
484     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
485     y: uint256 = D
486     for _i in range(255):
487         y_prev = y
488         y = (y*y + c) / (2 * y + b - D)
489         # Equality with the precision of 1
490         if y > y_prev:
491             if y - y_prev <= 1:
492                 return y
493         else:
494             if y_prev - y <= 1:
495                 return y
496     raise
497 
498 
499 @view
500 @internal
501 def _get_dy(i: int128, j: int128, dx: uint256) -> uint256:
502     xp: uint256[N_COINS] = self._balances()
503 
504     x: uint256 = xp[i] + dx
505     y: uint256 = self.get_y(i, j, x, xp)
506     dy: uint256 = (xp[j] - y)
507     _fee: uint256 = self._dynamic_fee(
508             (xp[i] + x) / 2, (xp[j] + y) / 2, self.fee, self.offpeg_fee_multiplier
509         ) * dy / FEE_DENOMINATOR
510     return dy - _fee
511 
512 
513 @view
514 @external
515 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
516     return self._get_dy(i, j, dx)
517 
518 
519 @view
520 @external
521 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
522     return self._get_dy(i, j, dx)
523 
524 
525 @internal
526 def _exchange(i: int128, j: int128, dx: uint256) -> uint256:
527     assert not self.is_killed  # dev: is killed
528     # dx and dy are in aTokens
529 
530     xp: uint256[N_COINS] = self._balances()
531 
532     x: uint256 = xp[i] + dx
533     y: uint256 = self.get_y(i, j, x, xp)
534     dy: uint256 = xp[j] - y
535     dy_fee: uint256 = dy * self._dynamic_fee(
536             (xp[i] + x) / 2, (xp[j] + y) / 2, self.fee, self.offpeg_fee_multiplier
537         ) / FEE_DENOMINATOR
538 
539     admin_fee: uint256 = self.admin_fee
540     if admin_fee != 0:
541         dy_admin_fee: uint256 = dy_fee * admin_fee / FEE_DENOMINATOR
542         if dy_admin_fee != 0:
543             self.admin_balances[j] += dy_admin_fee
544 
545     return dy - dy_fee
546 
547 
548 @external
549 @nonreentrant('lock')
550 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
551     """
552     @notice Perform an exchange between two coins
553     @dev Index values can be found via the `coins` public getter method
554     @param i Index value for the coin to send
555     @param j Index valie of the coin to recieve
556     @param dx Amount of `i` being exchanged
557     @param min_dy Minimum amount of `j` to receive
558     @return Actual amount of `j` received
559     """
560     dy: uint256 = self._exchange(i, j, dx)
561     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
562 
563     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)
564     assert ERC20(self.coins[j]).transfer(msg.sender, dy)
565 
566     log TokenExchange(msg.sender, i, dx, j, dy)
567 
568     return dy
569 
570 
571 @external
572 @nonreentrant('lock')
573 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
574     """
575     @notice Perform an exchange between two underlying coins
576     @dev Index values can be found via the `underlying_coins` public getter method
577     @param i Index value for the underlying coin to send
578     @param j Index valie of the underlying coin to recieve
579     @param dx Amount of `i` being exchanged
580     @param min_dy Minimum amount of `j` to receive
581     @return Actual amount of `j` received
582     """
583     dy: uint256 = self._exchange(i, j, dx)
584     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
585 
586     u_coin_i: address = self.underlying_coins[i]
587     lending_pool: address = self.aave_lending_pool
588 
589     # transfer underlying coin from msg.sender to self
590     assert ERC20(u_coin_i).transferFrom(msg.sender, self, dx)
591 
592     # deposit to aave lending pool
593     raw_call(
594         lending_pool,
595         concat(
596             method_id("deposit(address,uint256,address,uint16)"),
597             convert(u_coin_i, bytes32),
598             convert(dx, bytes32),
599             convert(self, bytes32),
600             convert(self.aave_referral, bytes32),
601         )
602     )
603     # withdraw `j` underlying from lending pool and transfer to caller
604     LendingPool(lending_pool).withdraw(self.underlying_coins[j], dy, msg.sender)
605 
606     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
607 
608     return dy
609 
610 
611 @external
612 @nonreentrant('lock')
613 def remove_liquidity(
614     _amount: uint256,
615     _min_amounts: uint256[N_COINS],
616     _use_underlying: bool = False,
617 ) -> uint256[N_COINS]:
618     """
619     @notice Withdraw coins from the pool
620     @dev Withdrawal amounts are based on current deposit ratios
621     @param _amount Quantity of LP tokens to burn in the withdrawal
622     @param _min_amounts Minimum amounts of underlying coins to receive
623     @param _use_underlying If True, withdraw underlying assets instead of aTokens
624     @return List of amounts of coins that were withdrawn
625     """
626     amounts: uint256[N_COINS] = self._balances()
627     lp_token: address = self.lp_token
628     total_supply: uint256 = ERC20(lp_token).totalSupply()
629     CurveToken(lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
630 
631     lending_pool: address = ZERO_ADDRESS
632     if _use_underlying:
633         lending_pool = self.aave_lending_pool
634 
635     for i in range(N_COINS):
636         value: uint256 = amounts[i] * _amount / total_supply
637         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
638         amounts[i] = value
639         if _use_underlying:
640             LendingPool(lending_pool).withdraw(self.underlying_coins[i], value, msg.sender)
641         else:
642             assert ERC20(self.coins[i]).transfer(msg.sender, value)
643 
644     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply - _amount)
645 
646     return amounts
647 
648 
649 @external
650 @nonreentrant('lock')
651 def remove_liquidity_imbalance(
652     _amounts: uint256[N_COINS],
653     _max_burn_amount: uint256,
654     _use_underlying: bool = False
655 ) -> uint256:
656     """
657     @notice Withdraw coins from the pool in an imbalanced amount
658     @param _amounts List of amounts of underlying coins to withdraw
659     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
660     @param _use_underlying If True, withdraw underlying assets instead of aTokens
661     @return Actual amount of the LP token burned in the withdrawal
662     """
663     assert not self.is_killed  # dev: is killed
664 
665     amp: uint256 = self._A()
666     old_balances: uint256[N_COINS] = self._balances()
667     D0: uint256 = self.get_D(old_balances, amp)
668     new_balances: uint256[N_COINS] = old_balances
669     for i in range(N_COINS):
670         new_balances[i] -= _amounts[i]
671     D1: uint256 = self.get_D(new_balances, amp)
672     ys: uint256 = (D0 + D1) / N_COINS
673 
674     lp_token: address = self.lp_token
675     token_supply: uint256 = ERC20(lp_token).totalSupply()
676     assert token_supply != 0  # dev: zero total supply
677 
678     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
679     _feemul: uint256 = self.offpeg_fee_multiplier
680     _admin_fee: uint256 = self.admin_fee
681     fees: uint256[N_COINS] = empty(uint256[N_COINS])
682     for i in range(N_COINS):
683         ideal_balance: uint256 = D1 * old_balances[i] / D0
684         new_balance: uint256 = new_balances[i]
685         difference: uint256 = 0
686         if ideal_balance > new_balance:
687             difference = ideal_balance - new_balance
688         else:
689             difference = new_balance - ideal_balance
690         xs: uint256 = new_balance + old_balances[i]
691         fees[i] = self._dynamic_fee(xs, ys, _fee, _feemul) * difference / FEE_DENOMINATOR
692         if _admin_fee != 0:
693             self.admin_balances[i] += fees[i] * _admin_fee / FEE_DENOMINATOR
694         new_balances[i] -= fees[i]
695     D2: uint256 = self.get_D(new_balances, amp)
696 
697     token_amount: uint256 = (D0 - D2) * token_supply / D0
698     assert token_amount != 0  # dev: zero tokens burned
699     assert token_amount <= _max_burn_amount, "Slippage screwed you"
700 
701     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
702 
703     lending_pool: address = ZERO_ADDRESS
704     if _use_underlying:
705         lending_pool = self.aave_lending_pool
706 
707     for i in range(N_COINS):
708         amount: uint256 = _amounts[i]
709         if amount != 0:
710             if _use_underlying:
711                 LendingPool(lending_pool).withdraw(self.underlying_coins[i], amount, msg.sender)
712             else:
713                 assert ERC20(self.coins[i]).transfer(msg.sender, amount)
714 
715     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, token_supply - token_amount)
716 
717     return token_amount
718 
719 
720 @pure
721 @internal
722 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
723     """
724     Calculate x[i] if one reduces D from being calculated for xp to D
725 
726     Done by solving quadratic equation iteratively.
727     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
728     x_1**2 + b*x_1 = c
729 
730     x_1 = (x_1**2 + c) / (2*x_1 + b)
731     """
732     # x in the input is converted to the same price/precision
733 
734     assert i >= 0       # dev: i below zero
735     assert i < N_COINS  # dev: i above N_COINS
736 
737     Ann: uint256 = A_ * N_COINS
738     c: uint256 = D
739     S_: uint256 = 0
740     _x: uint256 = 0
741     y_prev: uint256 = 0
742 
743     for _i in range(N_COINS):
744         if _i != i:
745             _x = xp[_i]
746         else:
747             continue
748         S_ += _x
749         c = c * D / (_x * N_COINS)
750     c = c * D * A_PRECISION / (Ann * N_COINS)
751     b: uint256 = S_ + D * A_PRECISION / Ann
752     y: uint256 = D
753 
754     for _i in range(255):
755         y_prev = y
756         y = (y*y + c) / (2 * y + b - D)
757         # Equality with the precision of 1
758         if y > y_prev:
759             if y - y_prev <= 1:
760                 return y
761         else:
762             if y_prev - y <= 1:
763                 return y
764     raise
765 
766 
767 @view
768 @internal
769 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
770     # First, need to calculate
771     # * Get current D
772     # * Solve Eqn against y_i for D - _token_amount
773     amp: uint256 = self._A()
774     xp: uint256[N_COINS] = self._balances()
775 
776     D0: uint256 = self.get_D(xp, amp)
777     D1: uint256 = D0 - _token_amount * D0 / ERC20(self.lp_token).totalSupply()
778     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
779 
780     xp_reduced: uint256[N_COINS] = xp
781     ys: uint256 = (D0 + D1) / (2 * N_COINS)
782 
783     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
784     feemul: uint256 = self.offpeg_fee_multiplier
785     for j in range(N_COINS):
786         dx_expected: uint256 = 0
787         xavg: uint256 = 0
788         if j == i:
789             dx_expected = xp[j] * D1 / D0 - new_y
790             xavg = (xp[j] + new_y) / 2
791         else:
792             dx_expected = xp[j] - xp[j] * D1 / D0
793             xavg = xp[j]
794         xp_reduced[j] -= self._dynamic_fee(xavg, ys, _fee, feemul) * dx_expected / FEE_DENOMINATOR
795 
796     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
797 
798     return dy - 1
799 
800 
801 @view
802 @external
803 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
804     """
805     @notice Calculate the amount received when withdrawing a single coin
806     @dev Result is the same for underlying or wrapped asset withdrawals
807     @param _token_amount Amount of LP tokens to burn in the withdrawal
808     @param i Index value of the coin to withdraw
809     @return Amount of coin received
810     """
811     return self._calc_withdraw_one_coin(_token_amount, i)
812 
813 
814 @external
815 @nonreentrant('lock')
816 def remove_liquidity_one_coin(
817     _token_amount: uint256,
818     i: int128,
819     _min_amount: uint256,
820     _use_underlying: bool = False
821 ) -> uint256:
822     """
823     @notice Withdraw a single coin from the pool
824     @param _token_amount Amount of LP tokens to burn in the withdrawal
825     @param i Index value of the coin to withdraw
826     @param _min_amount Minimum amount of coin to receive
827     @param _use_underlying If True, withdraw underlying assets instead of aTokens
828     @return Amount of coin received
829     """
830     assert not self.is_killed  # dev: is killed
831 
832     dy: uint256 = self._calc_withdraw_one_coin(_token_amount, i)
833     assert dy >= _min_amount, "Not enough coins removed"
834 
835     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
836 
837     if _use_underlying:
838         LendingPool(self.aave_lending_pool).withdraw(self.underlying_coins[i], dy, msg.sender)
839     else:
840         assert ERC20(self.coins[i]).transfer(msg.sender, dy)
841 
842     log RemoveLiquidityOne(msg.sender, _token_amount, dy)
843 
844     return dy
845 
846 
847 ### Admin functions ###
848 
849 @external
850 def ramp_A(_future_A: uint256, _future_time: uint256):
851     assert msg.sender == self.owner  # dev: only owner
852     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
853     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
854 
855     _initial_A: uint256 = self._A()
856     _future_A_p: uint256 = _future_A * A_PRECISION
857 
858     assert _future_A > 0 and _future_A < MAX_A
859     if _future_A_p < _initial_A:
860         assert _future_A_p * MAX_A_CHANGE >= _initial_A
861     else:
862         assert _future_A_p <= _initial_A * MAX_A_CHANGE
863 
864     self.initial_A = _initial_A
865     self.future_A = _future_A_p
866     self.initial_A_time = block.timestamp
867     self.future_A_time = _future_time
868 
869     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
870 
871 
872 @external
873 def stop_ramp_A():
874     assert msg.sender == self.owner  # dev: only owner
875 
876     current_A: uint256 = self._A()
877     self.initial_A = current_A
878     self.future_A = current_A
879     self.initial_A_time = block.timestamp
880     self.future_A_time = block.timestamp
881     # now (block.timestamp < t1) is always False, so we return saved A
882 
883     log StopRampA(current_A, block.timestamp)
884 
885 
886 @external
887 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256, new_offpeg_fee_multiplier: uint256):
888     assert msg.sender == self.owner  # dev: only owner
889     assert self.admin_actions_deadline == 0  # dev: active action
890     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
891     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
892     assert new_offpeg_fee_multiplier * new_fee <= MAX_FEE * FEE_DENOMINATOR  # dev: offpeg multiplier exceeds maximum
893 
894     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
895     self.admin_actions_deadline = _deadline
896     self.future_fee = new_fee
897     self.future_admin_fee = new_admin_fee
898     self.future_offpeg_fee_multiplier = new_offpeg_fee_multiplier
899 
900     log CommitNewFee(_deadline, new_fee, new_admin_fee, new_offpeg_fee_multiplier)
901 
902 
903 @external
904 def apply_new_fee():
905     assert msg.sender == self.owner  # dev: only owner
906     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
907     assert self.admin_actions_deadline != 0  # dev: no active action
908 
909     self.admin_actions_deadline = 0
910     _fee: uint256 = self.future_fee
911     _admin_fee: uint256 = self.future_admin_fee
912     _fml: uint256 = self.future_offpeg_fee_multiplier
913     self.fee = _fee
914     self.admin_fee = _admin_fee
915     self.offpeg_fee_multiplier = _fml
916 
917     log NewFee(_fee, _admin_fee, _fml)
918 
919 
920 @external
921 def revert_new_parameters():
922     assert msg.sender == self.owner  # dev: only owner
923 
924     self.admin_actions_deadline = 0
925 
926 
927 @external
928 def commit_transfer_ownership(_owner: address):
929     assert msg.sender == self.owner  # dev: only owner
930     assert self.transfer_ownership_deadline == 0  # dev: active transfer
931 
932     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
933     self.transfer_ownership_deadline = _deadline
934     self.future_owner = _owner
935 
936     log CommitNewAdmin(_deadline, _owner)
937 
938 
939 @external
940 def apply_transfer_ownership():
941     assert msg.sender == self.owner  # dev: only owner
942     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
943     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
944 
945     self.transfer_ownership_deadline = 0
946     _owner: address = self.future_owner
947     self.owner = _owner
948 
949     log NewAdmin(_owner)
950 
951 
952 @external
953 def revert_transfer_ownership():
954     assert msg.sender == self.owner  # dev: only owner
955 
956     self.transfer_ownership_deadline = 0
957 
958 
959 @external
960 def withdraw_admin_fees():
961     assert msg.sender == self.owner  # dev: only owner
962 
963     for i in range(N_COINS):
964         value: uint256 = self.admin_balances[i]
965         if value != 0:
966             assert ERC20(self.coins[i]).transfer(msg.sender, value)
967             self.admin_balances[i] = 0
968 
969 
970 @external
971 def donate_admin_fees():
972     """
973     Just in case admin balances somehow become higher than total (rounding error?)
974     this can be used to fix the state, too
975     """
976     assert msg.sender == self.owner  # dev: only owner
977     self.admin_balances = empty(uint256[N_COINS])
978 
979 
980 @external
981 def kill_me():
982     assert msg.sender == self.owner  # dev: only owner
983     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
984     self.is_killed = True
985 
986 
987 @external
988 def unkill_me():
989     assert msg.sender == self.owner  # dev: only owner
990     self.is_killed = False
991 
992 
993 @external
994 def set_aave_referral(referral_code: uint256):
995     assert msg.sender == self.owner  # dev: only owner
996     assert referral_code < 2 ** 16  # dev: uint16 overflow
997     self.aave_referral = referral_code