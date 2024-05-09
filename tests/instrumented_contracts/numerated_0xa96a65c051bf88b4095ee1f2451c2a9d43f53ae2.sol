1 # @version 0.2.8
2 """
3 @title ETH/ankrETH StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 """
7 
8 from vyper.interfaces import ERC20
9 
10 # External Contracts
11 interface aETH:
12     def ratio() -> uint256: view
13 
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
28 event AddLiquidity:
29     provider: indexed(address)
30     token_amounts: uint256[N_COINS]
31     fees: uint256[N_COINS]
32     invariant: uint256
33     token_supply: uint256
34 
35 event RemoveLiquidity:
36     provider: indexed(address)
37     token_amounts: uint256[N_COINS]
38     fees: uint256[N_COINS]
39     token_supply: uint256
40 
41 event RemoveLiquidityOne:
42     provider: indexed(address)
43     token_amount: uint256
44     coin_amount: uint256
45 
46 event RemoveLiquidityImbalance:
47     provider: indexed(address)
48     token_amounts: uint256[N_COINS]
49     fees: uint256[N_COINS]
50     invariant: uint256
51     token_supply: uint256
52 
53 event CommitNewAdmin:
54     deadline: indexed(uint256)
55     admin: indexed(address)
56 
57 event NewAdmin:
58     admin: indexed(address)
59 
60 event CommitNewFee:
61     deadline: indexed(uint256)
62     fee: uint256
63     admin_fee: uint256
64 
65 event NewFee:
66     fee: uint256
67     admin_fee: uint256
68 
69 event RampA:
70     old_A: uint256
71     new_A: uint256
72     initial_time: uint256
73     future_time: uint256
74 
75 event StopRampA:
76     A: uint256
77     t: uint256
78 
79 
80 # These constants must be set prior to compiling
81 N_COINS: constant(int128) = 2
82 
83 # fixed constants
84 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
85 LENDING_PRECISION: constant(uint256) = 10 ** 18
86 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
87 
88 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
89 MAX_FEE: constant(uint256) = 5 * 10 ** 9
90 MAX_A: constant(uint256) = 10 ** 6
91 MAX_A_CHANGE: constant(uint256) = 10
92 
93 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
94 MIN_RAMP_TIME: constant(uint256) = 86400
95 
96 coins: public(address[N_COINS])
97 balances: public(uint256[N_COINS])
98 
99 fee: public(uint256)  # fee * 1e10
100 admin_fee: public(uint256)  # admin_fee * 1e10
101 
102 owner: public(address)
103 lp_token: public(address)
104 
105 A_PRECISION: constant(uint256) = 100
106 initial_A: public(uint256)
107 future_A: public(uint256)
108 initial_A_time: public(uint256)
109 future_A_time: public(uint256)
110 
111 admin_actions_deadline: public(uint256)
112 transfer_ownership_deadline: public(uint256)
113 future_fee: public(uint256)
114 future_admin_fee: public(uint256)
115 future_owner: public(address)
116 
117 is_killed: bool
118 kill_deadline: uint256
119 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
120 
121 
122 @external
123 def __init__(
124     _owner: address,
125     _coins: address[N_COINS],
126     _pool_token: address,
127     _A: uint256,
128     _fee: uint256,
129     _admin_fee: uint256,
130 ):
131     """
132     @notice Contract constructor
133     @param _owner Contract owner address
134     @param _coins Addresses of ERC20 contracts of wrapped coins
135     @param _pool_token Address of the token representing LP share
136     @param _A Amplification coefficient multiplied by n * (n - 1)
137     @param _fee Fee to charge for exchanges
138     @param _admin_fee Admin fee
139     """
140 
141     assert _coins[0] == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
142     assert _coins[1] != ZERO_ADDRESS
143 
144     self.coins = _coins
145     self.initial_A = _A * A_PRECISION
146     self.future_A = _A * A_PRECISION
147     self.fee = _fee
148     self.admin_fee = _admin_fee
149     self.owner = _owner
150     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
151     self.lp_token = _pool_token
152 
153 
154 @view
155 @internal
156 def _A() -> uint256:
157     """
158     Handle ramping A up or down
159     """
160     t1: uint256 = self.future_A_time
161     A1: uint256 = self.future_A
162 
163     if block.timestamp < t1:
164         A0: uint256 = self.initial_A
165         t0: uint256 = self.initial_A_time
166         # Expressions in uint256 cannot have negative numbers, thus "if"
167         if A1 > A0:
168             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
169         else:
170             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
171 
172     else:  # when t1 == 0 or block.timestamp >= t1
173         return A1
174 
175 
176 @view
177 @external
178 def A() -> uint256:
179     return self._A() / A_PRECISION
180 
181 
182 @view
183 @external
184 def A_precise() -> uint256:
185     return self._A()
186 
187 
188 @view
189 @internal
190 def _stored_rates() -> uint256[N_COINS]:
191     return [
192         convert(PRECISION, uint256),
193         PRECISION * LENDING_PRECISION / aETH(self.coins[1]).ratio()
194     ]
195 
196 
197 @view
198 @internal
199 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
200     result: uint256[N_COINS] = rates
201     for i in range(N_COINS):
202         result[i] = result[i] * self.balances[i] / PRECISION
203     return result
204 
205 
206 @internal
207 @view
208 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
209     S: uint256 = 0
210     Dprev: uint256 = 0
211 
212     for _x in xp:
213         S += _x
214     if S == 0:
215         return 0
216 
217     D: uint256 = S
218     Ann: uint256 = amp * N_COINS
219     for _i in range(255):
220         D_P: uint256 = D
221         for _x in xp:
222             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
223         Dprev = D
224         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
225         # Equality with the precision of 1
226         if D > Dprev:
227             if D - Dprev <= 1:
228                 return D
229         else:
230             if Dprev - D <= 1:
231                 return D
232     # convergence typically occurs in 4 rounds or less, this should be unreachable!
233     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
234     raise
235 
236 
237 @view
238 @internal
239 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS], amp: uint256) -> uint256:
240     result: uint256[N_COINS] = rates
241     for i in range(N_COINS):
242         result[i] = result[i] * _balances[i] / PRECISION
243     return self.get_D(result, amp)
244 
245 
246 @view
247 @external
248 def get_virtual_price() -> uint256:
249     """
250     @notice The current virtual price of the pool LP token
251     @dev Useful for calculating profits
252     @return LP token virtual price normalized to 1e18
253     """
254     D: uint256 = self.get_D(self._xp(self._stored_rates()), self._A())
255     # D is in the units similar to DAI (e.g. converted to precision 1e18)
256     # When balanced, D = n * x_u - total virtual value of the portfolio
257     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
258     return D * PRECISION / token_supply
259 
260 
261 @view
262 @external
263 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
264     """
265     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
266     @dev This calculation accounts for slippage, but not fees.
267          Needed to prevent front-running, not for precise calculations!
268     @param amounts Amount of each coin being deposited
269     @param is_deposit set True for deposits, False for withdrawals
270     @return Expected amount of LP tokens received
271     """
272     amp: uint256 = self._A()
273     rates: uint256[N_COINS] = self._stored_rates()
274     _balances: uint256[N_COINS] = self.balances
275     D0: uint256 = self.get_D_mem(rates, _balances, amp)
276     for i in range(N_COINS):
277         _amount: uint256 = amounts[i]
278         if is_deposit:
279             _balances[i] += _amount
280         else:
281             _balances[i] -= _amount
282     D1: uint256 = self.get_D_mem(rates, _balances, amp)
283     token_amount: uint256 = ERC20(self.lp_token).totalSupply()
284     diff: uint256 = 0
285     if is_deposit:
286         diff = D1 - D0
287     else:
288         diff = D0 - D1
289     return diff * token_amount / D0
290 
291 @payable
292 @external
293 @nonreentrant('lock')
294 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
295     """
296     @notice Deposit coins into the pool
297     @param amounts List of amounts of coins to deposit
298     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
299     @return Amount of LP tokens received by depositing
300     """
301     assert not self.is_killed
302     amp: uint256 = self._A()
303     rates: uint256[N_COINS] = self._stored_rates()
304     _lp_token: address = self.lp_token
305     token_supply: uint256 = ERC20(_lp_token).totalSupply()
306 
307     # Initial invariant
308     D0: uint256 = 0
309     old_balances: uint256[N_COINS] = self.balances
310     if token_supply != 0:
311         D0 = self.get_D_mem(rates, old_balances, amp)
312 
313     new_balances: uint256[N_COINS] = old_balances
314     for i in range(N_COINS):
315         if token_supply == 0:
316             assert amounts[i] > 0
317         new_balances[i] += amounts[i]
318 
319     # Invariant after change
320     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
321     assert D1 > D0
322 
323     # We need to recalculate the invariant accounting for fees
324     # to calculate fair user's share
325     D2: uint256 = D1
326     fees: uint256[N_COINS] = empty(uint256[N_COINS])
327     mint_amount: uint256 = 0
328     if token_supply != 0:
329         # Only account for fees if we are not the first to deposit
330         _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
331         _admin_fee: uint256 = self.admin_fee
332         for i in range(N_COINS):
333             ideal_balance: uint256 = D1 * old_balances[i] / D0
334             difference: uint256 = 0
335             if ideal_balance > new_balances[i]:
336                 difference = ideal_balance - new_balances[i]
337             else:
338                 difference = new_balances[i] - ideal_balance
339             fees[i] = _fee * difference / FEE_DENOMINATOR
340             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
341             new_balances[i] -= fees[i]
342         D2 = self.get_D_mem(rates, new_balances, amp)
343         mint_amount = token_supply * (D2 - D0) / D0
344     else:
345         self.balances = new_balances
346         mint_amount = D1  # Take the dust if there was any
347 
348     assert mint_amount >= min_mint_amount, "Slippage screwed you"
349 
350     # Take coins from the sender
351     assert msg.value == amounts[0]
352     if amounts[1] > 0:
353         assert ERC20(self.coins[1]).transferFrom(msg.sender, self, amounts[1])
354 
355     # Mint pool tokens
356     CurveToken(_lp_token).mint(msg.sender, mint_amount)
357 
358     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
359 
360     return mint_amount
361 
362 
363 @view
364 @internal
365 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
366     # x in the input is converted to the same price/precision
367 
368     assert i != j       # dev: same coin
369     assert j >= 0       # dev: j below zero
370     assert j < N_COINS  # dev: j above N_COINS
371 
372     # should be unreachable, but good for safety
373     assert i >= 0
374     assert i < N_COINS
375 
376     A_: uint256 = self._A()
377     D: uint256 = self.get_D(xp_, A_)
378     Ann: uint256 = A_ * N_COINS
379     c: uint256 = D
380     S_: uint256 = 0
381     _x: uint256 = 0
382     y_prev: uint256 = 0
383 
384     for _i in range(N_COINS):
385         if _i == i:
386             _x = x
387         elif _i != j:
388             _x = xp_[_i]
389         else:
390             continue
391         S_ += _x
392         c = c * D / (_x * N_COINS)
393     c = c * D * A_PRECISION / (Ann * N_COINS)
394     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
395     y: uint256 = D
396     for _i in range(255):
397         y_prev = y
398         y = (y*y + c) / (2 * y + b - D)
399         # Equality with the precision of 1
400         if y > y_prev:
401             if y - y_prev <= 1:
402                 return y
403         else:
404             if y_prev - y <= 1:
405                 return y
406     raise
407 
408 
409 @view
410 @external
411 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
412     # dx and dy in c-units
413     rates: uint256[N_COINS] = self._stored_rates()
414     xp: uint256[N_COINS] = self._xp(rates)
415 
416     x: uint256 = xp[i] + dx * rates[i] / PRECISION
417     y: uint256 = self.get_y(i, j, x, xp)
418     dy: uint256 = xp[j] - y
419     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
420     return (dy - _fee) * PRECISION / rates[j]
421 
422 
423 @view
424 @external
425 def get_dx(i: int128, j: int128, dy: uint256) -> uint256:
426     # dx and dy in c-units
427     rates: uint256[N_COINS] = self._stored_rates()
428     xp: uint256[N_COINS] = self._xp(rates)
429 
430     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * rates[j] / PRECISION
431     x: uint256 = self.get_y(j, i, y, xp)
432     dx: uint256 = (x - xp[i]) * PRECISION / rates[i]
433     return dx
434 
435 
436 @payable
437 @external
438 @nonreentrant('lock')
439 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
440     """
441     @notice Perform an exchange between two coins
442     @dev Index values can be found via the `coins` public getter method
443     @param i Index value for the coin to send
444     @param j Index valie of the coin to recieve
445     @param dx Amount of `i` being exchanged
446     @param min_dy Minimum amount of `j` to receive
447     @return Actual amount of `j` received
448     """
449     assert not self.is_killed # dev: is killed
450 
451     rates: uint256[N_COINS] = self._stored_rates()
452 
453     xp: uint256[N_COINS] = self._xp(rates)
454     x: uint256 = xp[i] + dx * rates[i] / PRECISION
455     y: uint256 = self.get_y(i, j, x, xp)
456     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
457     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
458     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
459 
460     self.balances[i] = x * PRECISION / rates[i]
461     self.balances[j] = (y + (dy_fee - dy_admin_fee)) * PRECISION / rates[j]
462 
463     dy = (dy - dy_fee) * PRECISION / rates[j]
464     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
465 
466     coin: address = self.coins[1]
467     if i == 0:
468         assert msg.value == dx
469         assert ERC20(coin).transfer(msg.sender, dy)
470     else:
471         assert msg.value == 0
472         assert ERC20(coin).transferFrom(msg.sender, self, dx)
473         raw_call(msg.sender, b"", value=dy)
474 
475     log TokenExchange(msg.sender, i, dx, j, dy)
476 
477     return dy
478 
479 
480 @external
481 @nonreentrant('lock')
482 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
483     """
484     @notice Withdraw coins from the pool
485     @dev Withdrawal amounts are based on current deposit ratios
486     @param _amount Quantity of LP tokens to burn in the withdrawal
487     @param min_amounts Minimum amounts of underlying coins to receive
488     @return List of amounts of coins that were withdrawn
489     """
490     _lp_token: address = self.lp_token
491     total_supply: uint256 = ERC20(_lp_token).totalSupply()
492     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
493 
494     for i in range(N_COINS):
495         _balance: uint256 = self.balances[i]
496         value: uint256 = _balance * _amount / total_supply
497         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
498         self.balances[i] = _balance - value
499         amounts[i] = value
500         if i == 0:
501             raw_call(msg.sender, b"", value=value)
502         else:
503             assert ERC20(self.coins[1]).transfer(msg.sender, value)
504 
505     CurveToken(_lp_token).burnFrom(msg.sender, _amount)  # Will raise if not enough
506 
507     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply - _amount)
508 
509     return amounts
510 
511 
512 @external
513 @nonreentrant('lock')
514 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256:
515     """
516     @notice Withdraw coins from the pool in an imbalanced amount
517     @param amounts List of amounts of underlying coins to withdraw
518     @param max_burn_amount Maximum amount of LP token to burn in the withdrawal
519     @return Actual amount of the LP token burned in the withdrawal
520     """
521     assert not self.is_killed
522     amp: uint256 = self._A()
523     rates: uint256[N_COINS] = self._stored_rates()
524     old_balances: uint256[N_COINS] = self.balances
525     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
526 
527     new_balances: uint256[N_COINS] = old_balances
528     for i in range(N_COINS):
529         new_balances[i] -= amounts[i]
530     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
531 
532     fees: uint256[N_COINS] = empty(uint256[N_COINS])
533     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
534     _admin_fee: uint256 = self.admin_fee
535     for i in range(N_COINS):
536         ideal_balance: uint256 = D1 * old_balances[i] / D0
537         new_balance: uint256 = new_balances[i]
538         difference: uint256 = 0
539         if ideal_balance > new_balance:
540             difference = ideal_balance - new_balance
541         else:
542             difference = new_balance - ideal_balance
543         fees[i] = _fee * difference / FEE_DENOMINATOR
544         self.balances[i] = new_balance - (fees[i] * _admin_fee / FEE_DENOMINATOR)
545         new_balances[i] = new_balance - fees[i]
546     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
547 
548     lp_token: address = self.lp_token
549     token_supply: uint256 = ERC20(lp_token).totalSupply()
550     token_amount: uint256 = (D0 - D2) * token_supply / D0
551     assert token_amount != 0
552     assert token_amount <= max_burn_amount, "Slippage screwed you"
553 
554     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
555 
556     if amounts[0] != 0:
557         raw_call(msg.sender, b"", value=amounts[0])
558     if amounts[1] != 0:
559         assert ERC20(self.coins[1]).transfer(msg.sender, amounts[1])
560 
561     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
562 
563     return token_amount
564 
565 
566 @pure
567 @internal
568 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
569     """
570     Calculate x[i] if one reduces D from being calculated for xp to D
571 
572     Done by solving quadratic equation iteratively.
573     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
574     x_1**2 + b*x_1 = c
575 
576     x_1 = (x_1**2 + c) / (2*x_1 + b)
577     """
578     # x in the input is converted to the same price/precision
579 
580     assert i >= 0  # dev: i below zero
581     assert i < N_COINS  # dev: i above N_COINS
582 
583     Ann: uint256 = A_ * N_COINS
584     c: uint256 = D
585     S_: uint256 = 0
586     _x: uint256 = 0
587     y_prev: uint256 = 0
588 
589     for _i in range(N_COINS):
590         if _i != i:
591             _x = xp[_i]
592         else:
593             continue
594         S_ += _x
595         c = c * D / (_x * N_COINS)
596     c = c * D * A_PRECISION / (Ann * N_COINS)
597     b: uint256 = S_ + D * A_PRECISION / Ann
598     y: uint256 = D
599 
600     for _i in range(255):
601         y_prev = y
602         y = (y*y + c) / (2 * y + b - D)
603         # Equality with the precision of 1
604         if y > y_prev:
605             if y - y_prev <= 1:
606                 return y
607         else:
608             if y_prev - y <= 1:
609                 return y
610     raise
611 
612 
613 @view
614 @internal
615 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256):
616     # First, need to calculate
617     # * Get current D
618     # * Solve Eqn against y_i for D - _token_amount
619     amp: uint256 = self._A()
620     rates: uint256[N_COINS] = self._stored_rates()
621     xp: uint256[N_COINS] = self._xp(rates)
622     D0: uint256 = self.get_D(xp, amp)
623 
624     total_supply: uint256 = ERC20(self.lp_token).totalSupply()
625 
626     D1: uint256 = D0 - _token_amount * D0 / total_supply
627     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
628 
629     xp_reduced: uint256[N_COINS] = xp
630     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
631 
632     for j in range(N_COINS):
633         dx_expected: uint256 = 0
634         xp_j: uint256 = xp[j]
635         if j == i:
636             dx_expected = xp_j * D1 / D0 - new_y
637         else:
638             dx_expected = xp_j - xp_j * D1 / D0
639         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
640 
641     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
642     rate: uint256 = rates[i]
643     dy = (dy - 1) * PRECISION / rate  # Withdraw less to account for rounding errors
644     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rate   # w/o fees
645 
646     return dy, dy_0 - dy
647 
648 
649 @view
650 @external
651 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
652     """
653     @notice Calculate the amount received when withdrawing a single coin
654     @param _token_amount Amount of LP tokens to burn in the withdrawal
655     @param i Index value of the coin to withdraw
656     @return Amount of coin received
657     """
658     return self._calc_withdraw_one_coin(_token_amount, i)[0]
659 
660 
661 @external
662 @nonreentrant('lock')
663 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
664     """
665     @notice Withdraw a single coin from the pool
666     @param _token_amount Amount of LP tokens to burn in the withdrawal
667     @param i Index value of the coin to withdraw
668     @param _min_amount Minimum amount of coin to receive
669     @return Amount of coin received
670     """
671     assert not self.is_killed  # dev: is killed
672 
673     dy: uint256 = 0
674     dy_fee: uint256 = 0
675     dy, dy_fee = self._calc_withdraw_one_coin(_token_amount, i)
676     assert dy >= _min_amount, "Not enough coins removed"
677 
678     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
679     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
680 
681     if i == 0:
682         raw_call(msg.sender, b"", value=dy)
683     else:
684         assert ERC20(self.coins[1]).transfer(msg.sender, dy)
685 
686     log RemoveLiquidityOne(msg.sender, _token_amount, dy)
687 
688     return dy
689 
690 
691 ### Admin functions ###
692 @external
693 def ramp_A(_future_A: uint256, _future_time: uint256):
694     assert msg.sender == self.owner  # dev: only owner
695     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
696     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
697 
698     _initial_A: uint256 = self._A()
699     _future_A_p: uint256 = _future_A * A_PRECISION
700 
701     assert _future_A > 0 and _future_A < MAX_A
702     if _future_A_p < _initial_A:
703         assert _future_A_p * MAX_A_CHANGE >= _initial_A
704     else:
705         assert _future_A_p <= _initial_A * MAX_A_CHANGE
706 
707     self.initial_A = _initial_A
708     self.future_A = _future_A_p
709     self.initial_A_time = block.timestamp
710     self.future_A_time = _future_time
711 
712     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
713 
714 
715 @external
716 def stop_ramp_A():
717     assert msg.sender == self.owner  # dev: only owner
718 
719     current_A: uint256 = self._A()
720     self.initial_A = current_A
721     self.future_A = current_A
722     self.initial_A_time = block.timestamp
723     self.future_A_time = block.timestamp
724     # now (block.timestamp < t1) is always False, so we return saved A
725 
726     log StopRampA(current_A, block.timestamp)
727 
728 
729 @external
730 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
731     assert msg.sender == self.owner  # dev: only owner
732     assert self.admin_actions_deadline == 0  # dev: active action
733     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
734     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
735 
736     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
737     self.admin_actions_deadline = _deadline
738     self.future_fee = new_fee
739     self.future_admin_fee = new_admin_fee
740 
741     log CommitNewFee(_deadline, new_fee, new_admin_fee)
742 
743 
744 @external
745 @nonreentrant('lock')
746 def apply_new_fee():
747     assert msg.sender == self.owner  # dev: only owner
748     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
749     assert self.admin_actions_deadline != 0  # dev: no active action
750 
751     self.admin_actions_deadline = 0
752     _fee: uint256 = self.future_fee
753     _admin_fee: uint256 = self.future_admin_fee
754     self.fee = _fee
755     self.admin_fee = _admin_fee
756 
757     log NewFee(_fee, _admin_fee)
758 
759 
760 @external
761 def revert_new_parameters():
762     assert msg.sender == self.owner  # dev: only owner
763 
764     self.admin_actions_deadline = 0
765 
766 
767 @external
768 def commit_transfer_ownership(_owner: address):
769     assert msg.sender == self.owner  # dev: only owner
770     assert self.transfer_ownership_deadline == 0  # dev: active transfer
771 
772     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
773     self.transfer_ownership_deadline = _deadline
774     self.future_owner = _owner
775 
776     log CommitNewAdmin(_deadline, _owner)
777 
778 
779 @external
780 @nonreentrant('lock')
781 def apply_transfer_ownership():
782     assert msg.sender == self.owner  # dev: only owner
783     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
784     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
785 
786     self.transfer_ownership_deadline = 0
787     _owner: address = self.future_owner
788     self.owner = _owner
789 
790     log NewAdmin(_owner)
791 
792 
793 @external
794 def revert_transfer_ownership():
795     assert msg.sender == self.owner  # dev: only owner
796     self.transfer_ownership_deadline = 0
797 
798 
799 @view
800 @external
801 def admin_balances(i: uint256) -> uint256:
802     if i == 0:
803         return self.balance - self.balances[0]
804     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
805 
806 
807 @external
808 @nonreentrant('lock')
809 def withdraw_admin_fees():
810     assert msg.sender == self.owner  # dev: only owner
811 
812     amount: uint256 = self.balance - self.balances[0]
813     if amount != 0:
814         raw_call(msg.sender, b"", value=amount)
815 
816     amount = ERC20(self.coins[1]).balanceOf(self) - self.balances[1]
817     if amount != 0:
818         assert ERC20(self.coins[1]).transfer(msg.sender, amount)
819 
820 
821 @external
822 @nonreentrant('lock')
823 def donate_admin_fees():
824     assert msg.sender == self.owner  # dev: only owner
825     for i in range(N_COINS):
826         if i == 0:
827             self.balances[0] = self.balance
828         else:
829             self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
830 
831 
832 @external
833 def kill_me():
834     assert msg.sender == self.owner  # dev: only owner
835     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
836     self.is_killed = True
837 
838 
839 @external
840 def unkill_me():
841     assert msg.sender == self.owner  # dev: only owner
842     self.is_killed = False