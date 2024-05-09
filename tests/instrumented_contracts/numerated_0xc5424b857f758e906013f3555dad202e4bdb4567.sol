1 # @version 0.2.8
2 """
3 @title Curve ETH/sETH StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 """
7 
8 from vyper.interfaces import ERC20
9 
10 interface CurveToken:
11     def mint(_to: address, _value: uint256) -> bool: nonpayable
12     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
13 
14 
15 # Events
16 event TokenExchange:
17     buyer: indexed(address)
18     sold_id: int128
19     tokens_sold: uint256
20     bought_id: int128
21     tokens_bought: uint256
22 
23 event AddLiquidity:
24     provider: indexed(address)
25     token_amounts: uint256[N_COINS]
26     fees: uint256[N_COINS]
27     invariant: uint256
28     token_supply: uint256
29 
30 event RemoveLiquidity:
31     provider: indexed(address)
32     token_amounts: uint256[N_COINS]
33     fees: uint256[N_COINS]
34     token_supply: uint256
35 
36 event RemoveLiquidityOne:
37     provider: indexed(address)
38     token_amount: uint256
39     coin_amount: uint256
40 
41 event RemoveLiquidityImbalance:
42     provider: indexed(address)
43     token_amounts: uint256[N_COINS]
44     fees: uint256[N_COINS]
45     invariant: uint256
46     token_supply: uint256
47 
48 event CommitNewAdmin:
49     deadline: indexed(uint256)
50     admin: indexed(address)
51 
52 event NewAdmin:
53     admin: indexed(address)
54 
55 event CommitNewFee:
56     deadline: indexed(uint256)
57     fee: uint256
58     admin_fee: uint256
59 
60 event NewFee:
61     fee: uint256
62     admin_fee: uint256
63 
64 event RampA:
65     old_A: uint256
66     new_A: uint256
67     initial_time: uint256
68     future_time: uint256
69 
70 event StopRampA:
71     A: uint256
72     t: uint256
73 
74 
75 # These constants must be set prior to compiling
76 N_COINS: constant(int128) = 2
77 
78 # fixed constants
79 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
80 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
81 
82 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
83 MAX_FEE: constant(uint256) = 5 * 10 ** 9
84 MAX_A: constant(uint256) = 10 ** 6
85 MAX_A_CHANGE: constant(uint256) = 10
86 
87 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
88 MIN_RAMP_TIME: constant(uint256) = 86400
89 
90 coins: public(address[N_COINS])
91 balances: public(uint256[N_COINS])
92 fee: public(uint256)  # fee * 1e10
93 admin_fee: public(uint256)  # admin_fee * 1e10
94 
95 owner: public(address)
96 lp_token: address
97 
98 A_PRECISION: constant(uint256) = 100
99 initial_A: public(uint256)
100 future_A: public(uint256)
101 initial_A_time: public(uint256)
102 future_A_time: public(uint256)
103 
104 admin_actions_deadline: public(uint256)
105 transfer_ownership_deadline: public(uint256)
106 future_fee: public(uint256)
107 future_admin_fee: public(uint256)
108 future_owner: public(address)
109 
110 is_killed: bool
111 kill_deadline: uint256
112 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
113 
114 
115 @external
116 def __init__(
117     _owner: address,
118     _coins: address[N_COINS],
119     _pool_token: address,
120     _A: uint256,
121     _fee: uint256,
122     _admin_fee: uint256
123 ):
124     """
125     @notice Contract constructor
126     @param _owner Contract owner address
127     @param _coins Addresses of ERC20 conracts of coins
128     @param _pool_token Address of the token representing LP share
129     @param _A Amplification coefficient multiplied by n * (n - 1)
130     @param _fee Fee to charge for exchanges
131     @param _admin_fee Admin fee
132     """
133     for i in range(N_COINS):
134         assert _coins[i] != ZERO_ADDRESS
135     self.coins = _coins
136     self.initial_A = _A * A_PRECISION
137     self.future_A = _A * A_PRECISION
138     self.fee = _fee
139     self.admin_fee = _admin_fee
140     self.owner = _owner
141     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
142     self.lp_token = _pool_token
143 
144 
145 @view
146 @internal
147 def _A() -> uint256:
148     """
149     Handle ramping A up or down
150     """
151     t1: uint256 = self.future_A_time
152     A1: uint256 = self.future_A
153 
154     if block.timestamp < t1:
155         A0: uint256 = self.initial_A
156         t0: uint256 = self.initial_A_time
157         # Expressions in uint256 cannot have negative numbers, thus "if"
158         if A1 > A0:
159             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
160         else:
161             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
162 
163     else:  # when t1 == 0 or block.timestamp >= t1
164         return A1
165 
166 
167 @view
168 @external
169 def A() -> uint256:
170     return self._A() / A_PRECISION
171 
172 
173 @view
174 @external
175 def A_precise() -> uint256:
176     return self._A()
177 
178 
179 @pure
180 @internal
181 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
182     S: uint256 = 0
183     Dprev: uint256 = 0
184     for _x in xp:
185         S += _x
186     if S == 0:
187         return 0
188 
189     D: uint256 = S
190     Ann: uint256 = amp * N_COINS
191     for _i in range(255):
192         D_P: uint256 = D
193         for _x in xp:
194             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
195         Dprev = D
196         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
197         # Equality with the precision of 1
198         if D > Dprev:
199             if D - Dprev <= 1:
200                 return D
201         else:
202             if Dprev - D <= 1:
203                 return D
204     raise
205 
206 
207 @view
208 @external
209 def get_virtual_price() -> uint256:
210     """
211     @notice The current virtual price of the pool LP token
212     @dev Useful for calculating profits
213     @return LP token virtual price normalized to 1e18
214     """
215     D: uint256 = self.get_D(self.balances, self._A())
216     # D is in the units similar to DAI (e.g. converted to precision 1e18)
217     # When balanced, D = n * x_u - total virtual value of the portfolio
218     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
219     return D * PRECISION / token_supply
220 
221 
222 @view
223 @external
224 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
225     """
226     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
227     @dev This calculation accounts for slippage, but not fees.
228          Needed to prevent front-running, not for precise calculations!
229     @param amounts Amount of each coin being deposited
230     @param is_deposit set True for deposits, False for withdrawals
231     @return Expected amount of LP tokens received
232     """
233     amp: uint256 = self._A()
234     _balances: uint256[N_COINS] = self.balances
235     D0: uint256 = self.get_D(_balances, amp)
236     for i in range(N_COINS):
237         if is_deposit:
238             _balances[i] += amounts[i]
239         else:
240             _balances[i] -= amounts[i]
241     D1: uint256 = self.get_D(_balances, amp)
242     token_amount: uint256 = ERC20(self.lp_token).totalSupply()
243     diff: uint256 = 0
244     if is_deposit:
245         diff = D1 - D0
246     else:
247         diff = D0 - D1
248     return diff * token_amount / D0
249 
250 
251 @payable
252 @external
253 @nonreentrant('lock')
254 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
255     """
256     @notice Deposit coins into the pool
257     @param amounts List of amounts of coins to deposit
258     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
259     @return Amount of LP tokens received by depositing
260     """
261     assert not self.is_killed  # dev: is killed
262 
263     # Initial invariant
264     amp: uint256 = self._A()
265     old_balances: uint256[N_COINS] = self.balances
266     D0: uint256 = self.get_D(old_balances, amp)
267 
268     lp_token: address = self.lp_token
269     token_supply: uint256 = ERC20(lp_token).totalSupply()
270     new_balances: uint256[N_COINS] = empty(uint256[N_COINS])
271     for i in range(N_COINS):
272         if token_supply == 0:
273             assert amounts[i] > 0  # dev: initial deposit requires all coins
274         new_balances[i] = old_balances[i] + amounts[i]
275 
276     # Invariant after change
277     D1: uint256 = self.get_D(new_balances, amp)
278     assert D1 > D0
279 
280     # We need to recalculate the invariant accounting for fees
281     # to calculate fair user's share
282     fees: uint256[N_COINS] = empty(uint256[N_COINS])
283     mint_amount: uint256 = 0
284     D2: uint256 = D1
285     if token_supply > 0:
286         # Only account for fees if we are not the first to deposit
287         fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
288         admin_fee: uint256 = self.admin_fee
289         for i in range(N_COINS):
290             ideal_balance: uint256 = D1 * old_balances[i] / D0
291             difference: uint256 = 0
292             if ideal_balance > new_balances[i]:
293                 difference = ideal_balance - new_balances[i]
294             else:
295                 difference = new_balances[i] - ideal_balance
296             fees[i] = fee * difference / FEE_DENOMINATOR
297             self.balances[i] = new_balances[i] - (fees[i] * admin_fee / FEE_DENOMINATOR)
298             new_balances[i] -= fees[i]
299         D2 = self.get_D(new_balances, amp)
300         mint_amount = token_supply * (D2 - D0) / D0
301     else:
302         self.balances = new_balances
303         mint_amount = D1  # Take the dust if there was any
304 
305     assert mint_amount >= min_mint_amount, "Slippage screwed you"
306 
307     # Take coins from the sender
308     for i in range(N_COINS):
309         _coin: address = self.coins[i]
310         _amount: uint256 = amounts[i]
311         if _coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
312             assert msg.value == _amount
313         elif _amount > 0:
314             # "safeTransferFrom" which works for ERC20s which return bool or not
315             _response: Bytes[32] = raw_call(
316                 _coin,
317                 concat(
318                     method_id("transferFrom(address,address,uint256)"),
319                     convert(msg.sender, bytes32),
320                     convert(self, bytes32),
321                     convert(_amount, bytes32),
322                 ),
323                 max_outsize=32,
324             )  # dev: failed transfer
325             if len(_response) > 0:
326                 assert convert(_response, bool)
327 
328     # Mint pool tokens
329     CurveToken(lp_token).mint(msg.sender, mint_amount)
330 
331     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
332 
333     return mint_amount
334 
335 
336 @view
337 @internal
338 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
339     # x in the input is converted to the same price/precision
340 
341     assert i != j       # dev: same coin
342     assert j >= 0       # dev: j below zero
343     assert j < N_COINS  # dev: j above N_COINS
344 
345     # should be unreachable, but good for safety
346     assert i >= 0
347     assert i < N_COINS
348 
349     amp: uint256 = self._A()
350     D: uint256 = self.get_D(xp_, amp)
351     c: uint256 = D
352     S_: uint256 = 0
353     _x: uint256 = 0
354     y_prev: uint256 = 0
355     Ann: uint256 = amp * N_COINS
356 
357     for _i in range(N_COINS):
358         if _i == i:
359             _x = x
360         elif _i != j:
361             _x = xp_[_i]
362         else:
363             continue
364         S_ += _x
365         c = c * D / (_x * N_COINS)
366 
367     c = c * D * A_PRECISION / (Ann * N_COINS)
368     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
369     y: uint256 = D
370     for _i in range(255):
371         y_prev = y
372         y = (y*y + c) / (2 * y + b - D)
373         # Equality with the precision of 1
374         if y > y_prev:
375             if y - y_prev <= 1:
376                 return y
377         else:
378             if y_prev - y <= 1:
379                 return y
380     raise
381 
382 
383 @view
384 @external
385 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
386     xp: uint256[N_COINS] = self.balances
387     x: uint256 = xp[i] + dx
388     y: uint256 = self.get_y(i, j, x, xp)
389     dy: uint256 = xp[j] - y - 1
390     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
391     return dy - _fee
392 
393 
394 @payable
395 @external
396 @nonreentrant('lock')
397 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
398     """
399     @notice Perform an exchange between two coins
400     @dev Index values can be found via the `coins` public getter method
401     @param i Index value for the coin to send
402     @param j Index valie of the coin to recieve
403     @param dx Amount of `i` being exchanged
404     @param min_dy Minimum amount of `j` to receive
405     @return Actual amount of `j` received
406     """
407     assert not self.is_killed  # dev: is killed
408 
409     old_balances: uint256[N_COINS] = self.balances
410 
411     x: uint256 = old_balances[i] + dx
412     y: uint256 = self.get_y(i, j, x, old_balances)
413 
414     dy: uint256 = old_balances[j] - y - 1  # -1 just in case there were some rounding errors
415     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
416 
417     # Convert all to real units
418     dy = dy - dy_fee
419     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
420 
421     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
422 
423     # Change balances exactly in same way as we change actual ERC20 coin amounts
424     self.balances[i] = old_balances[i] + dx
425     # When rounding errors happen, we undercharge admin fee in favor of LP
426     self.balances[j] = old_balances[j] - dy - dy_admin_fee
427 
428     # "safeTransferFrom" which works for ERC20s which return bool or not
429     _coin: address = self.coins[i]
430     if _coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
431         assert msg.value == dx
432     else:
433         assert msg.value == 0
434         _response: Bytes[32] = raw_call(
435             _coin,
436             concat(
437                 method_id("transferFrom(address,address,uint256)"),
438                 convert(msg.sender, bytes32),
439                 convert(self, bytes32),
440                 convert(dx, bytes32),
441             ),
442             max_outsize=32,
443         )  # dev: failed transfer
444         if len(_response) > 0:
445             assert convert(_response, bool)
446 
447     _coin = self.coins[j]
448     if _coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
449         raw_call(msg.sender, b"", value=dy)
450     else:
451         _response: Bytes[32] = raw_call(
452             _coin,
453             concat(
454                 method_id("transfer(address,uint256)"),
455                 convert(msg.sender, bytes32),
456                 convert(dy, bytes32),
457             ),
458             max_outsize=32,
459         )  # dev: failed transfer
460         if len(_response) > 0:
461             assert convert(_response, bool)
462 
463     log TokenExchange(msg.sender, i, dx, j, dy)
464 
465     return dy
466 
467 
468 @external
469 @nonreentrant('lock')
470 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
471     """
472     @notice Withdraw coins from the pool
473     @dev Withdrawal amounts are based on current deposit ratios
474     @param _amount Quantity of LP tokens to burn in the withdrawal
475     @param min_amounts Minimum amounts of underlying coins to receive
476     @return List of amounts of coins that were withdrawn
477     """
478     lp_token: address = self.lp_token
479     total_supply: uint256 = ERC20(lp_token).totalSupply()
480     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
481 
482     CurveToken(lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
483 
484     for i in range(N_COINS):
485         old_balance: uint256 = self.balances[i]
486         value: uint256 = old_balance * _amount / total_supply
487         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
488 
489         self.balances[i] = old_balance - value
490         amounts[i] = value
491         _coin: address = self.coins[i]
492         if _coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
493             raw_call(msg.sender, b"", value=value)
494         else:
495             _response: Bytes[32] = raw_call(
496                 _coin,
497                 concat(
498                     method_id("transfer(address,uint256)"),
499                     convert(msg.sender, bytes32),
500                     convert(value, bytes32),
501                 ),
502                 max_outsize=32,
503             )  # dev: failed transfer
504             if len(_response) > 0:
505                 assert convert(_response, bool)
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
521     assert not self.is_killed  # dev: is killed
522 
523     amp: uint256 = self._A()
524     lp_token: address = self.lp_token
525     token_supply: uint256 = ERC20(lp_token).totalSupply()
526     assert token_supply != 0  # dev: zero total supply
527 
528     old_balances: uint256[N_COINS] = self.balances
529     D0: uint256 = self.get_D(old_balances, amp)
530 
531     new_balances: uint256[N_COINS] = empty(uint256[N_COINS])
532     for i in range(N_COINS):
533         new_balances[i] = old_balances[i] - amounts[i]
534     D1: uint256 = self.get_D(new_balances, amp)
535 
536     fees: uint256[N_COINS] = empty(uint256[N_COINS])
537     difference: uint256 = 0
538     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
539     admin_fee: uint256 = self.admin_fee
540     for i in range(N_COINS):
541         new_balance: uint256 = new_balances[i]
542         ideal_balance: uint256 = D1 * old_balances[i] / D0
543         if ideal_balance > new_balance:
544             difference = ideal_balance - new_balance
545         else:
546             difference = new_balance - ideal_balance
547         fees[i] = fee * difference / FEE_DENOMINATOR
548         self.balances[i] = new_balance - (fees[i] * admin_fee / FEE_DENOMINATOR)
549         new_balances[i] = new_balance - fees[i]
550     D2: uint256 = self.get_D(new_balances, amp)
551 
552     token_amount: uint256 = (D0 - D2) * token_supply / D0
553     assert token_amount != 0  # dev: zero tokens burned
554     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
555     assert token_amount <= max_burn_amount, "Slippage screwed you"
556 
557     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
558 
559     for i in range(N_COINS):
560         amount: uint256 = amounts[i]
561         if amount != 0:
562             coin: address = self.coins[i]
563             if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
564                 raw_call(msg.sender, b"", value=amount)
565             else:
566                 _response: Bytes[32] = raw_call(
567                     coin,
568                     concat(
569                         method_id("transfer(address,uint256)"),
570                         convert(msg.sender, bytes32),
571                         convert(amount, bytes32),
572                     ),
573                     max_outsize=32,
574                 )  # dev: failed transfer
575                 if len(_response) > 0:
576                     assert convert(_response, bool)
577 
578     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
579 
580     return token_amount
581 
582 
583 @view
584 @internal
585 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
586     """
587     Calculate x[i] if one reduces D from being calculated for xp to D
588 
589     Done by solving quadratic equation iteratively.
590     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
591     x_1**2 + b*x_1 = c
592 
593     x_1 = (x_1**2 + c) / (2*x_1 + b)
594     """
595     # x in the input is converted to the same price/precision
596 
597     assert i >= 0  # dev: i below zero
598     assert i < N_COINS  # dev: i above N_COINS
599 
600     S_: uint256 = 0
601     _x: uint256 = 0
602     y_prev: uint256 = 0
603     c: uint256 = D
604     Ann: uint256 = A_ * N_COINS
605 
606     for _i in range(N_COINS):
607         if _i != i:
608             _x = xp[_i]
609         else:
610             continue
611         S_ += _x
612         c = c * D / (_x * N_COINS)
613     c = c * D * A_PRECISION / (Ann * N_COINS)
614     b: uint256 = S_ + D * A_PRECISION / Ann
615 
616     y: uint256 = D
617     for _i in range(255):
618         y_prev = y
619         y = (y*y + c) / (2 * y + b - D)
620         # Equality with the precision of 1
621         if y > y_prev:
622             if y - y_prev <= 1:
623                 return y
624         else:
625             if y_prev - y <= 1:
626                 return y
627     raise
628 
629 
630 @view
631 @internal
632 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256):
633     # First, need to calculate
634     # * Get current D
635     # * Solve Eqn against y_i for D - _token_amount
636     amp: uint256 = self._A()
637     xp: uint256[N_COINS] = self.balances
638     D0: uint256 = self.get_D(xp, amp)
639     total_supply: uint256 = ERC20(self.lp_token).totalSupply()
640     D1: uint256 = D0 - _token_amount * D0 / total_supply
641     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
642 
643     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
644     xp_reduced: uint256[N_COINS] = xp
645     for j in range(N_COINS):
646         dx_expected: uint256 = 0
647         if j == i:
648             dx_expected = xp[j] * D1 / D0 - new_y
649         else:
650             dx_expected = xp[j] - xp[j] * D1 / D0
651         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
652 
653     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
654 
655     dy -= 1  # Withdraw less to account for rounding errors
656     dy_0: uint256 = xp[i] - new_y  # w/o fees
657 
658     return dy, dy_0 - dy
659 
660 
661 @view
662 @external
663 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
664     """
665     @notice Calculate the amount received when withdrawing a single coin
666     @param _token_amount Amount of LP tokens to burn in the withdrawal
667     @param i Index value of the coin to withdraw
668     @return Amount of coin received
669     """
670     return self._calc_withdraw_one_coin(_token_amount, i)[0]
671 
672 
673 @external
674 @nonreentrant('lock')
675 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
676     """
677     @notice Withdraw a single coin from the pool
678     @param _token_amount Amount of LP tokens to burn in the withdrawal
679     @param i Index value of the coin to withdraw
680     @param _min_amount Minimum amount of coin to receive
681     @return Amount of coin received
682     """
683     assert not self.is_killed  # dev: is killed
684 
685     dy: uint256 = 0
686     dy_fee: uint256 = 0
687     dy, dy_fee = self._calc_withdraw_one_coin(_token_amount, i)
688     assert dy >= _min_amount, "Not enough coins removed"
689 
690     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
691     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
692 
693     _coin: address = self.coins[i]
694     if _coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
695         raw_call(msg.sender, b"", value=dy)
696     else:
697         _response: Bytes[32] = raw_call(
698             _coin,
699             concat(
700                 method_id("transfer(address,uint256)"),
701                 convert(msg.sender, bytes32),
702                 convert(dy, bytes32),
703             ),
704             max_outsize=32,
705         )  # dev: failed transfer
706         if len(_response) > 0:
707             assert convert(_response, bool)
708 
709     log RemoveLiquidityOne(msg.sender, _token_amount, dy)
710 
711     return dy
712 
713 
714 ### Admin functions ###
715 @external
716 def ramp_A(_future_A: uint256, _future_time: uint256):
717     assert msg.sender == self.owner  # dev: only owner
718     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
719     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
720 
721     _initial_A: uint256 = self._A()
722     _future_A_p: uint256 = _future_A * A_PRECISION
723 
724     assert _future_A > 0 and _future_A < MAX_A
725     if _future_A_p < _initial_A:
726         assert _future_A_p * MAX_A_CHANGE >= _initial_A
727     else:
728         assert _future_A_p <= _initial_A * MAX_A_CHANGE
729 
730     self.initial_A = _initial_A
731     self.future_A = _future_A_p
732     self.initial_A_time = block.timestamp
733     self.future_A_time = _future_time
734 
735     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
736 
737 
738 @external
739 def stop_ramp_A():
740     assert msg.sender == self.owner  # dev: only owner
741 
742     current_A: uint256 = self._A()
743     self.initial_A = current_A
744     self.future_A = current_A
745     self.initial_A_time = block.timestamp
746     self.future_A_time = block.timestamp
747     # now (block.timestamp < t1) is always False, so we return saved A
748 
749     log StopRampA(current_A, block.timestamp)
750 
751 
752 @external
753 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
754     assert msg.sender == self.owner  # dev: only owner
755     assert self.admin_actions_deadline == 0  # dev: active action
756     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
757     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
758 
759     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
760     self.admin_actions_deadline = _deadline
761     self.future_fee = new_fee
762     self.future_admin_fee = new_admin_fee
763 
764     log CommitNewFee(_deadline, new_fee, new_admin_fee)
765 
766 
767 @external
768 @nonreentrant('lock')
769 def apply_new_fee():
770     assert msg.sender == self.owner  # dev: only owner
771     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
772     assert self.admin_actions_deadline != 0  # dev: no active action
773 
774     self.admin_actions_deadline = 0
775     _fee: uint256 = self.future_fee
776     _admin_fee: uint256 = self.future_admin_fee
777     self.fee = _fee
778     self.admin_fee = _admin_fee
779 
780     log NewFee(_fee, _admin_fee)
781 
782 
783 @external
784 def revert_new_parameters():
785     assert msg.sender == self.owner  # dev: only owner
786 
787     self.admin_actions_deadline = 0
788 
789 
790 @external
791 def commit_transfer_ownership(_owner: address):
792     assert msg.sender == self.owner  # dev: only owner
793     assert self.transfer_ownership_deadline == 0  # dev: active transfer
794 
795     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
796     self.transfer_ownership_deadline = _deadline
797     self.future_owner = _owner
798 
799     log CommitNewAdmin(_deadline, _owner)
800 
801 
802 @external
803 @nonreentrant('lock')
804 def apply_transfer_ownership():
805     assert msg.sender == self.owner  # dev: only owner
806     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
807     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
808 
809     self.transfer_ownership_deadline = 0
810     _owner: address = self.future_owner
811     self.owner = _owner
812 
813     log NewAdmin(_owner)
814 
815 
816 @external
817 def revert_transfer_ownership():
818     assert msg.sender == self.owner  # dev: only owner
819 
820     self.transfer_ownership_deadline = 0
821 
822 
823 @view
824 @external
825 def admin_balances(i: uint256) -> uint256:
826     coin: address = self.coins[i]
827     if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
828         return self.balance - self.balances[i]
829     else:
830         return ERC20(coin).balanceOf(self) - self.balances[i]
831 
832 
833 @external
834 @nonreentrant('lock')
835 def withdraw_admin_fees():
836     assert msg.sender == self.owner  # dev: only owner
837 
838     for i in range(N_COINS):
839         coin: address = self.coins[i]
840         if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
841             value: uint256 = self.balance - self.balances[i]
842             if value > 0:
843                 raw_call(msg.sender, b"", value=value)
844         else:
845             value: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
846             if value > 0:
847                 _response: Bytes[32] = raw_call(
848                     coin,
849                     concat(
850                         method_id("transfer(address,uint256)"),
851                         convert(msg.sender, bytes32),
852                         convert(value, bytes32),
853                     ),
854                     max_outsize=32,
855                 )  # dev: failed transfer
856                 if len(_response) > 0:
857                     assert convert(_response, bool)
858 
859 
860 
861 @external
862 @nonreentrant('lock')
863 def donate_admin_fees():
864     assert msg.sender == self.owner  # dev: only owner
865     for i in range(N_COINS):
866         coin: address = self.coins[i]
867         if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
868             self.balances[i] = self.balance
869         else:
870             self.balances[i] = ERC20(coin).balanceOf(self)
871 
872 
873 @external
874 def kill_me():
875     assert msg.sender == self.owner  # dev: only owner
876     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
877     self.is_killed = True
878 
879 
880 @external
881 def unkill_me():
882     assert msg.sender == self.owner  # dev: only owner
883     self.is_killed = False