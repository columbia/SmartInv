1 # @version 0.2.8
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 @notice Pool for swapping between Euro-denominated stablecoins
7 @dev Swaps between EURS and sEUR
8 """
9 
10 from vyper.interfaces import ERC20
11 
12 interface CurveToken:
13     def mint(_to: address, _value: uint256) -> bool: nonpayable
14     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
15 
16 
17 # Events
18 event TokenExchange:
19     buyer: indexed(address)
20     sold_id: int128
21     tokens_sold: uint256
22     bought_id: int128
23     tokens_bought: uint256
24 
25 event AddLiquidity:
26     provider: indexed(address)
27     token_amounts: uint256[N_COINS]
28     fees: uint256[N_COINS]
29     invariant: uint256
30     token_supply: uint256
31 
32 event RemoveLiquidity:
33     provider: indexed(address)
34     token_amounts: uint256[N_COINS]
35     fees: uint256[N_COINS]
36     token_supply: uint256
37 
38 event RemoveLiquidityOne:
39     provider: indexed(address)
40     token_amount: uint256
41     coin_amount: uint256
42     token_supply: uint256
43 
44 event RemoveLiquidityImbalance:
45     provider: indexed(address)
46     token_amounts: uint256[N_COINS]
47     fees: uint256[N_COINS]
48     invariant: uint256
49     token_supply: uint256
50 
51 event CommitNewAdmin:
52     deadline: indexed(uint256)
53     admin: indexed(address)
54 
55 event NewAdmin:
56     admin: indexed(address)
57 
58 event CommitNewFee:
59     deadline: indexed(uint256)
60     fee: uint256
61     admin_fee: uint256
62 
63 event NewFee:
64     fee: uint256
65     admin_fee: uint256
66 
67 event RampA:
68     old_A: uint256
69     new_A: uint256
70     initial_time: uint256
71     future_time: uint256
72 
73 event StopRampA:
74     A: uint256
75     t: uint256
76 
77 
78 # These constants must be set prior to compiling
79 N_COINS: constant(int128) = 2
80 PRECISION_MUL: constant(uint256[N_COINS]) = [10000000000000000, 1]
81 RATES: constant(uint256[N_COINS]) = [10000000000000000000000000000000000, 1000000000000000000]
82 
83 # fixed constants
84 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
85 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
86 
87 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
88 MAX_FEE: constant(uint256) = 5 * 10 ** 9
89 MAX_A: constant(uint256) = 10 ** 6
90 MAX_A_CHANGE: constant(uint256) = 10
91 
92 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
93 MIN_RAMP_TIME: constant(uint256) = 86400
94 
95 coins: public(address[N_COINS])
96 balances: public(uint256[N_COINS])
97 fee: public(uint256)  # fee * 1e10
98 admin_fee: public(uint256)  # admin_fee * 1e10
99 
100 owner: public(address)
101 lp_token: public(address)
102 
103 A_PRECISION: constant(uint256) = 100
104 initial_A: public(uint256)
105 future_A: public(uint256)
106 initial_A_time: public(uint256)
107 future_A_time: public(uint256)
108 
109 admin_actions_deadline: public(uint256)
110 transfer_ownership_deadline: public(uint256)
111 future_fee: public(uint256)
112 future_admin_fee: public(uint256)
113 future_owner: public(address)
114 
115 is_killed: bool
116 kill_deadline: uint256
117 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
118 
119 
120 @external
121 def __init__(
122     _owner: address,
123     _coins: address[N_COINS],
124     _pool_token: address,
125     _A: uint256,
126     _fee: uint256,
127     _admin_fee: uint256
128 ):
129     """
130     @notice Contract constructor
131     @param _owner Contract owner address
132     @param _coins Addresses of ERC20 conracts of coins
133     @param _pool_token Address of the token representing LP share
134     @param _A Amplification coefficient multiplied by n * (n - 1)
135     @param _fee Fee to charge for exchanges
136     @param _admin_fee Admin fee
137     """
138     for i in range(N_COINS):
139         assert _coins[i] != ZERO_ADDRESS
140     self.coins = _coins
141     self.initial_A = _A * A_PRECISION
142     self.future_A = _A * A_PRECISION
143     self.fee = _fee
144     self.admin_fee = _admin_fee
145     self.owner = _owner
146     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
147     self.lp_token = _pool_token
148 
149 
150 @view
151 @internal
152 def _A() -> uint256:
153     """
154     Handle ramping A up or down
155     """
156     t1: uint256 = self.future_A_time
157     A1: uint256 = self.future_A
158 
159     if block.timestamp < t1:
160         A0: uint256 = self.initial_A
161         t0: uint256 = self.initial_A_time
162         # Expressions in uint256 cannot have negative numbers, thus "if"
163         if A1 > A0:
164             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
165         else:
166             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
167 
168     else:  # when t1 == 0 or block.timestamp >= t1
169         return A1
170 
171 
172 @view
173 @external
174 def A() -> uint256:
175     return self._A() / A_PRECISION
176 
177 
178 @view
179 @external
180 def A_precise() -> uint256:
181     return self._A()
182 
183 
184 @view
185 @internal
186 def _xp() -> uint256[N_COINS]:
187     result: uint256[N_COINS] = RATES
188     for i in range(N_COINS):
189         result[i] = result[i] * self.balances[i] / PRECISION
190     return result
191 
192 
193 @pure
194 @internal
195 def _xp_mem(_balances: uint256[N_COINS]) -> uint256[N_COINS]:
196     result: uint256[N_COINS] = RATES
197     for i in range(N_COINS):
198         result[i] = result[i] * _balances[i] / PRECISION
199     return result
200 
201 
202 @pure
203 @internal
204 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
205     S: uint256 = 0
206     Dprev: uint256 = 0
207 
208     for _x in xp:
209         S += _x
210     if S == 0:
211         return 0
212 
213     D: uint256 = S
214     Ann: uint256 = amp * N_COINS
215     for _i in range(255):
216         D_P: uint256 = D
217         for _x in xp:
218             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
219         Dprev = D
220         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
221         # Equality with the precision of 1
222         if D > Dprev:
223             if D - Dprev <= 1:
224                 return D
225         else:
226             if Dprev - D <= 1:
227                 return D
228 
229     # convergence typically occurs in 4 rounds or less, this should be unreachable!
230     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
231     raise
232 
233 
234 @view
235 @internal
236 def get_D_mem(_balances: uint256[N_COINS], amp: uint256) -> uint256:
237     return self.get_D(self._xp_mem(_balances), amp)
238 
239 
240 @view
241 @external
242 def get_virtual_price() -> uint256:
243     """
244     @notice The current virtual price of the pool LP token
245     @dev Useful for calculating profits
246     @return LP token virtual price normalized to 1e18
247     """
248     D: uint256 = self.get_D(self._xp(), self._A())
249     # D is in the units similar to DAI (e.g. converted to precision 1e18)
250     # When balanced, D = n * x_u - total virtual value of the portfolio
251     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
252     return D * PRECISION / token_supply
253 
254 
255 @view
256 @external
257 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
258     """
259     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
260     @dev This calculation accounts for slippage, but not fees.
261          Needed to prevent front-running, not for precise calculations!
262     @param amounts Amount of each coin being deposited
263     @param is_deposit set True for deposits, False for withdrawals
264     @return Expected amount of LP tokens received
265     """
266     amp: uint256 = self._A()
267     _balances: uint256[N_COINS] = self.balances
268     D0: uint256 = self.get_D_mem(_balances, amp)
269     for i in range(N_COINS):
270         if is_deposit:
271             _balances[i] += amounts[i]
272         else:
273             _balances[i] -= amounts[i]
274     D1: uint256 = self.get_D_mem(_balances, amp)
275     token_amount: uint256 = ERC20(self.lp_token).totalSupply()
276     diff: uint256 = 0
277     if is_deposit:
278         diff = D1 - D0
279     else:
280         diff = D0 - D1
281     return diff * token_amount / D0
282 
283 
284 @external
285 @nonreentrant('lock')
286 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
287     """
288     @notice Deposit coins into the pool
289     @param amounts List of amounts of coins to deposit
290     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
291     @return Amount of LP tokens received by depositing
292     """
293     assert not self.is_killed  # dev: is killed
294 
295     amp: uint256 = self._A()
296 
297     _lp_token: address = self.lp_token
298     token_supply: uint256 = ERC20(_lp_token).totalSupply()
299     # Initial invariant
300     D0: uint256 = 0
301     old_balances: uint256[N_COINS] = self.balances
302     if token_supply > 0:
303         D0 = self.get_D_mem(old_balances, amp)
304     new_balances: uint256[N_COINS] = old_balances
305 
306     for i in range(N_COINS):
307         if token_supply == 0:
308             assert amounts[i] > 0  # dev: initial deposit requires all coins
309         # balances store amounts of c-tokens
310         new_balances[i] = old_balances[i] + amounts[i]
311 
312     # Invariant after change
313     D1: uint256 = self.get_D_mem(new_balances, amp)
314     assert D1 > D0
315 
316     # We need to recalculate the invariant accounting for fees
317     # to calculate fair user's share
318     D2: uint256 = D1
319     fees: uint256[N_COINS] = empty(uint256[N_COINS])
320 
321     if token_supply > 0:
322         # Only account for fees if we are not the first to deposit
323         _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
324         _admin_fee: uint256 = self.admin_fee
325         for i in range(N_COINS):
326             ideal_balance: uint256 = D1 * old_balances[i] / D0
327             difference: uint256 = 0
328             if ideal_balance > new_balances[i]:
329                 difference = ideal_balance - new_balances[i]
330             else:
331                 difference = new_balances[i] - ideal_balance
332             fees[i] = _fee * difference / FEE_DENOMINATOR
333             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
334             new_balances[i] -= fees[i]
335         D2 = self.get_D_mem(new_balances, amp)
336     else:
337         self.balances = new_balances
338 
339     # Calculate, how much pool tokens to mint
340     mint_amount: uint256 = 0
341     if token_supply == 0:
342         mint_amount = D1  # Take the dust if there was any
343     else:
344         mint_amount = token_supply * (D2 - D0) / D0
345 
346     assert mint_amount >= min_mint_amount, "Slippage screwed you"
347 
348     # Take coins from the sender
349     for i in range(N_COINS):
350         if amounts[i] > 0:
351             # "safeTransferFrom" which works for ERC20s which return bool or not
352             _response: Bytes[32] = raw_call(
353                 self.coins[i],
354                 concat(
355                     method_id("transferFrom(address,address,uint256)"),
356                     convert(msg.sender, bytes32),
357                     convert(self, bytes32),
358                     convert(amounts[i], bytes32),
359                 ),
360                 max_outsize=32,
361             )  # dev: failed transfer
362             if len(_response) > 0:
363                 assert convert(_response, bool)
364 
365     # Mint pool tokens
366     CurveToken(_lp_token).mint(msg.sender, mint_amount)
367 
368     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
369 
370     return mint_amount
371 
372 
373 @view
374 @internal
375 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
376     # x in the input is converted to the same price/precision
377 
378     assert i != j       # dev: same coin
379     assert j >= 0       # dev: j below zero
380     assert j < N_COINS  # dev: j above N_COINS
381 
382     # should be unreachable, but good for safety
383     assert i >= 0
384     assert i < N_COINS
385 
386     amp: uint256 = self._A()
387     D: uint256 = self.get_D(xp_, amp)
388     Ann: uint256 = amp * N_COINS
389     c: uint256 = D
390     S_: uint256 = 0
391     _x: uint256 = 0
392     y_prev: uint256 = 0
393 
394     for _i in range(N_COINS):
395         if _i == i:
396             _x = x
397         elif _i != j:
398             _x = xp_[_i]
399         else:
400             continue
401         S_ += _x
402         c = c * D / (_x * N_COINS)
403     c = c * D * A_PRECISION / (Ann * N_COINS)
404     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
405     y: uint256 = D
406     for _i in range(255):
407         y_prev = y
408         y = (y*y + c) / (2 * y + b - D)
409         # Equality with the precision of 1
410         if y > y_prev:
411             if y - y_prev <= 1:
412                 return y
413         else:
414             if y_prev - y <= 1:
415                 return y
416     raise
417 
418 
419 @view
420 @external
421 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
422     xp: uint256[N_COINS] = self._xp()
423     rates: uint256[N_COINS] = RATES
424 
425     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
426     y: uint256 = self.get_y(i, j, x, xp)
427     dy: uint256 = (xp[j] - y - 1)
428     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
429     return (dy - _fee) * PRECISION / rates[j]
430 
431 
432 @external
433 @nonreentrant('lock')
434 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
435     """
436     @notice Perform an exchange between two coins
437     @dev Index values can be found via the `coins` public getter method
438     @param i Index value for the coin to send
439     @param j Index valie of the coin to recieve
440     @param dx Amount of `i` being exchanged
441     @param min_dy Minimum amount of `j` to receive
442     @return Actual amount of `j` received
443     """
444     assert not self.is_killed  # dev: is killed
445 
446     old_balances: uint256[N_COINS] = self.balances
447     xp: uint256[N_COINS] = self._xp_mem(old_balances)
448 
449     rates: uint256[N_COINS] = RATES
450     x: uint256 = xp[i] + dx * rates[i] / PRECISION
451     y: uint256 = self.get_y(i, j, x, xp)
452 
453     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
454     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
455 
456     # Convert all to real units
457     dy = (dy - dy_fee) * PRECISION / rates[j]
458     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
459 
460     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
461     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
462 
463     # Change balances exactly in same way as we change actual ERC20 coin amounts
464     self.balances[i] = old_balances[i] + dx
465     # When rounding errors happen, we undercharge admin fee in favor of LP
466     self.balances[j] = old_balances[j] - dy - dy_admin_fee
467 
468     # "safeTransferFrom" which works for ERC20s which return bool or not
469     _response: Bytes[32] = raw_call(
470         self.coins[i],
471         concat(
472             method_id("transferFrom(address,address,uint256)"),
473             convert(msg.sender, bytes32),
474             convert(self, bytes32),
475             convert(dx, bytes32),
476         ),
477         max_outsize=32,
478     )  # dev: failed transfer
479     if len(_response) > 0:
480         assert convert(_response, bool)
481 
482     _response = raw_call(
483         self.coins[j],
484         concat(
485             method_id("transfer(address,uint256)"),
486             convert(msg.sender, bytes32),
487             convert(dy, bytes32),
488         ),
489         max_outsize=32,
490     )  # dev: failed transfer
491     if len(_response) > 0:
492         assert convert(_response, bool)
493 
494     log TokenExchange(msg.sender, i, dx, j, dy)
495 
496     return dy
497 
498 
499 @external
500 @nonreentrant('lock')
501 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
502     """
503     @notice Withdraw coins from the pool
504     @dev Withdrawal amounts are based on current deposit ratios
505     @param _amount Quantity of LP tokens to burn in the withdrawal
506     @param min_amounts Minimum amounts of underlying coins to receive
507     @return List of amounts of coins that were withdrawn
508     """
509     _lp_token: address = self.lp_token
510     total_supply: uint256 = ERC20(_lp_token).totalSupply()
511     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
512     fees: uint256[N_COINS] = empty(uint256[N_COINS])  # Fees are unused but we've got them historically in event
513 
514     for i in range(N_COINS):
515         value: uint256 = self.balances[i] * _amount / total_supply
516         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
517         self.balances[i] -= value
518         amounts[i] = value
519         _response: Bytes[32] = raw_call(
520             self.coins[i],
521             concat(
522                 method_id("transfer(address,uint256)"),
523                 convert(msg.sender, bytes32),
524                 convert(value, bytes32),
525             ),
526             max_outsize=32,
527         )  # dev: failed transfer
528         if len(_response) > 0:
529             assert convert(_response, bool)
530 
531     CurveToken(_lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
532 
533     log RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
534 
535     return amounts
536 
537 
538 @external
539 @nonreentrant('lock')
540 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256:
541     """
542     @notice Withdraw coins from the pool in an imbalanced amount
543     @param amounts List of amounts of underlying coins to withdraw
544     @param max_burn_amount Maximum amount of LP token to burn in the withdrawal
545     @return Actual amount of the LP token burned in the withdrawal
546     """
547     assert not self.is_killed  # dev: is killed
548 
549     amp: uint256 = self._A()
550 
551     old_balances: uint256[N_COINS] = self.balances
552     new_balances: uint256[N_COINS] = old_balances
553     D0: uint256 = self.get_D_mem(old_balances, amp)
554     for i in range(N_COINS):
555         new_balances[i] -= amounts[i]
556     D1: uint256 = self.get_D_mem(new_balances, amp)
557 
558     _lp_token: address = self.lp_token
559     token_supply: uint256 = ERC20(_lp_token).totalSupply()
560     assert token_supply != 0  # dev: zero total supply
561 
562     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
563     _admin_fee: uint256 = self.admin_fee
564     fees: uint256[N_COINS] = empty(uint256[N_COINS])
565     for i in range(N_COINS):
566         ideal_balance: uint256 = D1 * old_balances[i] / D0
567         difference: uint256 = 0
568         if ideal_balance > new_balances[i]:
569             difference = ideal_balance - new_balances[i]
570         else:
571             difference = new_balances[i] - ideal_balance
572         fees[i] = _fee * difference / FEE_DENOMINATOR
573         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
574         new_balances[i] -= fees[i]
575     D2: uint256 = self.get_D_mem(new_balances, amp)
576 
577     token_amount: uint256 = (D0 - D2) * token_supply / D0
578     assert token_amount != 0  # dev: zero tokens burned
579     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
580     assert token_amount <= max_burn_amount, "Slippage screwed you"
581 
582     CurveToken(_lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
583     for i in range(N_COINS):
584         if amounts[i] != 0:
585             _response: Bytes[32] = raw_call(
586                 self.coins[i],
587                 concat(
588                     method_id("transfer(address,uint256)"),
589                     convert(msg.sender, bytes32),
590                     convert(amounts[i], bytes32),
591                 ),
592                 max_outsize=32,
593             )  # dev: failed transfer
594             if len(_response) > 0:
595                 assert convert(_response, bool)
596 
597 
598     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
599 
600     return token_amount
601 
602 
603 @view
604 @internal
605 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
606     """
607     Calculate x[i] if one reduces D from being calculated for xp to D
608 
609     Done by solving quadratic equation iteratively.
610     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
611     x_1**2 + b*x_1 = c
612 
613     x_1 = (x_1**2 + c) / (2*x_1 + b)
614     """
615     # x in the input is converted to the same price/precision
616 
617     assert i >= 0  # dev: i below zero
618     assert i < N_COINS  # dev: i above N_COINS
619 
620     Ann: uint256 = A_ * N_COINS
621     c: uint256 = D
622     S_: uint256 = 0
623     _x: uint256 = 0
624     y_prev: uint256 = 0
625 
626     for _i in range(N_COINS):
627         if _i != i:
628             _x = xp[_i]
629         else:
630             continue
631         S_ += _x
632         c = c * D / (_x * N_COINS)
633     c = c * D * A_PRECISION / (Ann * N_COINS)
634     b: uint256 = S_ + D * A_PRECISION / Ann
635 
636     y: uint256 = D
637     for _i in range(255):
638         y_prev = y
639         y = (y*y + c) / (2 * y + b - D)
640         # Equality with the precision of 1
641         if y > y_prev:
642             if y - y_prev <= 1:
643                 return y
644         else:
645             if y_prev - y <= 1:
646                 return y
647     raise
648 
649 
650 @view
651 @internal
652 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256, uint256):
653     # First, need to calculate
654     # * Get current D
655     # * Solve Eqn against y_i for D - _token_amount
656     amp: uint256 = self._A()
657     xp: uint256[N_COINS] = self._xp()
658     D0: uint256 = self.get_D(xp, amp)
659 
660     total_supply: uint256 = ERC20(self.lp_token).totalSupply()
661     D1: uint256 = D0 - _token_amount * D0 / total_supply
662     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
663     xp_reduced: uint256[N_COINS] = xp
664 
665     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
666     for j in range(N_COINS):
667         dx_expected: uint256 = 0
668         if j == i:
669             dx_expected = xp[j] * D1 / D0 - new_y
670         else:
671             dx_expected = xp[j] - xp[j] * D1 / D0
672         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
673 
674     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
675     precisions: uint256[N_COINS] = PRECISION_MUL
676     dy = (dy - 1) / precisions[i]  # Withdraw less to account for rounding errors
677     dy_0: uint256 = (xp[i] - new_y) / precisions[i]  # w/o fees
678 
679     return dy, dy_0 - dy, total_supply
680 
681 
682 @view
683 @external
684 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
685     """
686     @notice Calculate the amount received when withdrawing a single coin
687     @param _token_amount Amount of LP tokens to burn in the withdrawal
688     @param i Index value of the coin to withdraw
689     @return Amount of coin received
690     """
691     return self._calc_withdraw_one_coin(_token_amount, i)[0]
692 
693 
694 @external
695 @nonreentrant('lock')
696 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
697     """
698     @notice Withdraw a single coin from the pool
699     @param _token_amount Amount of LP tokens to burn in the withdrawal
700     @param i Index value of the coin to withdraw
701     @param _min_amount Minimum amount of coin to receive
702     @return Amount of coin received
703     """
704     assert not self.is_killed  # dev: is killed
705 
706     dy: uint256 = 0
707     dy_fee: uint256 = 0
708     total_supply: uint256 = 0
709     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_token_amount, i)
710     assert dy >= _min_amount, "Not enough coins removed"
711 
712     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
713     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
714 
715 
716     _response: Bytes[32] = raw_call(
717         self.coins[i],
718         concat(
719             method_id("transfer(address,uint256)"),
720             convert(msg.sender, bytes32),
721             convert(dy, bytes32),
722         ),
723         max_outsize=32,
724     )  # dev: failed transfer
725     if len(_response) > 0:
726         assert convert(_response, bool)
727 
728     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
729 
730     return dy
731 
732 
733 ### Admin functions ###
734 @external
735 def ramp_A(_future_A: uint256, _future_time: uint256):
736     assert msg.sender == self.owner  # dev: only owner
737     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
738     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
739 
740     _initial_A: uint256 = self._A()
741     _future_A_p: uint256 = _future_A * A_PRECISION
742 
743     assert _future_A > 0 and _future_A < MAX_A
744     if _future_A_p < _initial_A:
745         assert _future_A_p * MAX_A_CHANGE >= _initial_A
746     else:
747         assert _future_A_p <= _initial_A * MAX_A_CHANGE
748 
749     self.initial_A = _initial_A
750     self.future_A = _future_A_p
751     self.initial_A_time = block.timestamp
752     self.future_A_time = _future_time
753 
754     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
755 
756 
757 @external
758 def stop_ramp_A():
759     assert msg.sender == self.owner  # dev: only owner
760 
761     current_A: uint256 = self._A()
762     self.initial_A = current_A
763     self.future_A = current_A
764     self.initial_A_time = block.timestamp
765     self.future_A_time = block.timestamp
766     # now (block.timestamp < t1) is always False, so we return saved A
767 
768     log StopRampA(current_A, block.timestamp)
769 
770 
771 @external
772 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
773     assert msg.sender == self.owner  # dev: only owner
774     assert self.admin_actions_deadline == 0  # dev: active action
775     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
776     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
777 
778     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
779     self.admin_actions_deadline = _deadline
780     self.future_fee = new_fee
781     self.future_admin_fee = new_admin_fee
782 
783     log CommitNewFee(_deadline, new_fee, new_admin_fee)
784 
785 
786 @external
787 def apply_new_fee():
788     assert msg.sender == self.owner  # dev: only owner
789     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
790     assert self.admin_actions_deadline != 0  # dev: no active action
791 
792     self.admin_actions_deadline = 0
793     _fee: uint256 = self.future_fee
794     _admin_fee: uint256 = self.future_admin_fee
795     self.fee = _fee
796     self.admin_fee = _admin_fee
797 
798     log NewFee(_fee, _admin_fee)
799 
800 
801 @external
802 def revert_new_parameters():
803     assert msg.sender == self.owner  # dev: only owner
804 
805     self.admin_actions_deadline = 0
806 
807 
808 @external
809 def commit_transfer_ownership(_owner: address):
810     assert msg.sender == self.owner  # dev: only owner
811     assert self.transfer_ownership_deadline == 0  # dev: active transfer
812 
813     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
814     self.transfer_ownership_deadline = _deadline
815     self.future_owner = _owner
816 
817     log CommitNewAdmin(_deadline, _owner)
818 
819 
820 @external
821 def apply_transfer_ownership():
822     assert msg.sender == self.owner  # dev: only owner
823     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
824     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
825 
826     self.transfer_ownership_deadline = 0
827     _owner: address = self.future_owner
828     self.owner = _owner
829 
830     log NewAdmin(_owner)
831 
832 
833 @external
834 def revert_transfer_ownership():
835     assert msg.sender == self.owner  # dev: only owner
836 
837     self.transfer_ownership_deadline = 0
838 
839 
840 @view
841 @external
842 def admin_balances(i: uint256) -> uint256:
843     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
844 
845 
846 @external
847 def withdraw_admin_fees():
848     assert msg.sender == self.owner  # dev: only owner
849 
850     for i in range(N_COINS):
851         coin: address = self.coins[i]
852         value: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
853         if value > 0:
854             _response: Bytes[32] = raw_call(
855                 coin,
856                 concat(
857                     method_id("transfer(address,uint256)"),
858                     convert(msg.sender, bytes32),
859                     convert(value, bytes32),
860                 ),
861                 max_outsize=32,
862             )  # dev: failed transfer
863             if len(_response) > 0:
864                 assert convert(_response, bool)
865 
866 
867 @external
868 def donate_admin_fees():
869     assert msg.sender == self.owner  # dev: only owner
870     for i in range(N_COINS):
871         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
872 
873 
874 @external
875 def kill_me():
876     assert msg.sender == self.owner  # dev: only owner
877     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
878     self.is_killed = True
879 
880 
881 @external
882 def unkill_me():
883     assert msg.sender == self.owner  # dev: only owner
884     self.is_killed = False