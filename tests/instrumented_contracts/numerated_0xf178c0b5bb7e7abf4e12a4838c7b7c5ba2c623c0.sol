1 # @version 0.2.8
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 @notice Minimal pool implementation with no lending
7 @dev Swaps between LINK and sLINK
8 """
9 
10 from vyper.interfaces import ERC20
11 
12 interface CurveToken:
13     def totalSupply() -> uint256: view
14     def mint(_to: address, _value: uint256) -> bool: nonpayable
15     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
16 
17 
18 # Events
19 event TokenExchange:
20     buyer: indexed(address)
21     sold_id: int128
22     tokens_sold: uint256
23     bought_id: int128
24     tokens_bought: uint256
25 
26 event AddLiquidity:
27     provider: indexed(address)
28     token_amounts: uint256[N_COINS]
29     fees: uint256[N_COINS]
30     invariant: uint256
31     token_supply: uint256
32 
33 event RemoveLiquidity:
34     provider: indexed(address)
35     token_amounts: uint256[N_COINS]
36     fees: uint256[N_COINS]
37     token_supply: uint256
38 
39 event RemoveLiquidityOne:
40     provider: indexed(address)
41     token_amount: uint256
42     coin_amount: uint256
43     token_supply: uint256
44 
45 event RemoveLiquidityImbalance:
46     provider: indexed(address)
47     token_amounts: uint256[N_COINS]
48     fees: uint256[N_COINS]
49     invariant: uint256
50     token_supply: uint256
51 
52 event CommitNewAdmin:
53     deadline: indexed(uint256)
54     admin: indexed(address)
55 
56 event NewAdmin:
57     admin: indexed(address)
58 
59 event CommitNewFee:
60     deadline: indexed(uint256)
61     fee: uint256
62     admin_fee: uint256
63 
64 event NewFee:
65     fee: uint256
66     admin_fee: uint256
67 
68 event RampA:
69     old_A: uint256
70     new_A: uint256
71     initial_time: uint256
72     future_time: uint256
73 
74 event StopRampA:
75     A: uint256
76     t: uint256
77 
78 
79 # These constants must be set prior to compiling
80 N_COINS: constant(int128) = 2
81 
82 # fixed constants
83 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
84 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
85 
86 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
87 MAX_FEE: constant(uint256) = 5 * 10 ** 9
88 MAX_A: constant(uint256) = 10 ** 6
89 MAX_A_CHANGE: constant(uint256) = 10
90 
91 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
92 MIN_RAMP_TIME: constant(uint256) = 86400
93 
94 coins: public(address[N_COINS])
95 balances: public(uint256[N_COINS])
96 fee: public(uint256)  # fee * 1e10
97 admin_fee: public(uint256)  # admin_fee * 1e10
98 
99 previous_balances: public(uint256[N_COINS])
100 block_timestamp_last: public(uint256)
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
129     _admin_fee: uint256
130 ):
131     """
132     @notice Contract constructor
133     @param _owner Contract owner address
134     @param _coins Addresses of ERC20 conracts of coins
135     @param _pool_token Address of the token representing LP share
136     @param _A Amplification coefficient multiplied by n * (n - 1)
137     @param _fee Fee to charge for exchanges
138     @param _admin_fee Admin fee
139     """
140     for i in range(N_COINS):
141         assert _coins[i] != ZERO_ADDRESS
142     self.coins = _coins
143     self.initial_A = _A * A_PRECISION
144     self.future_A = _A * A_PRECISION
145     self.fee = _fee
146     self.admin_fee = _admin_fee
147     self.owner = _owner
148     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
149     self.lp_token = _pool_token
150 
151 
152 @view
153 @internal
154 def _A() -> uint256:
155     """
156     Handle ramping A up or down
157     """
158     t1: uint256 = self.future_A_time
159     A1: uint256 = self.future_A
160 
161     if block.timestamp < t1:
162         A0: uint256 = self.initial_A
163         t0: uint256 = self.initial_A_time
164         # Expressions in uint256 cannot have negative numbers, thus "if"
165         if A1 > A0:
166             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
167         else:
168             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
169 
170     else:  # when t1 == 0 or block.timestamp >= t1
171         return A1
172 
173 
174 @view
175 @external
176 def A() -> uint256:
177     return self._A() / A_PRECISION
178 
179 
180 @view
181 @external
182 def A_precise() -> uint256:
183     return self._A()
184 
185 
186 @internal
187 def _update():
188     """
189     Commits pre-change balances for the previous block
190     Can be used to compare against current values for flash loan checks
191     """
192     if block.timestamp > self.block_timestamp_last:
193         self.previous_balances = self.balances
194         self.block_timestamp_last = block.timestamp
195 
196 
197 @pure
198 @internal
199 def _get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
200     """
201     D invariant calculation in non-overflowing integer operations
202     iteratively
203 
204     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
205 
206     Converging solution:
207     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
208     """
209     S: uint256 = 0
210     Dprev: uint256 = 0
211 
212     for _x in _xp:
213         S += _x
214     if S == 0:
215         return 0
216 
217     D: uint256 = S
218     Ann: uint256 = _amp * N_COINS
219     for _i in range(255):
220         D_P: uint256 = D
221         for _x in _xp:
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
239 def _get_D_mem(_balances: uint256[N_COINS], _amp: uint256) -> uint256:
240     return self._get_D(_balances, _amp)
241 
242 
243 @view
244 @external
245 def get_virtual_price() -> uint256:
246     """
247     @notice The current virtual price of the pool LP token
248     @dev Useful for calculating profits
249     @return LP token virtual price normalized to 1e18
250     """
251     D: uint256 = self._get_D(self.balances, self._A())
252     # D is in the units similar to DAI (e.g. converted to precision 1e18)
253     # When balanced, D = n * x_u - total virtual value of the portfolio
254     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
255     return D * PRECISION / token_supply
256 
257 
258 @view
259 @external
260 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
261     """
262     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
263     @dev This calculation accounts for slippage, but not fees.
264          Needed to prevent front-running, not for precise calculations!
265     @param _amounts Amount of each coin being deposited
266     @param _is_deposit set True for deposits, False for withdrawals
267     @return Expected amount of LP tokens received
268     """
269     amp: uint256 = self._A()
270     balances: uint256[N_COINS] = self.balances
271     D0: uint256 = self._get_D_mem(balances, amp)
272     for i in range(N_COINS):
273         if _is_deposit:
274             balances[i] += _amounts[i]
275         else:
276             balances[i] -= _amounts[i]
277     D1: uint256 = self._get_D_mem(balances, amp)
278     token_amount: uint256 = CurveToken(self.lp_token).totalSupply()
279     diff: uint256 = 0
280     if _is_deposit:
281         diff = D1 - D0
282     else:
283         diff = D0 - D1
284     return diff * token_amount / D0
285 
286 
287 @external
288 @nonreentrant('lock')
289 def add_liquidity(_amounts: uint256[N_COINS], _min_mint_amount: uint256) -> uint256:
290     """
291     @notice Deposit coins into the pool
292     @param _amounts List of amounts of coins to deposit
293     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
294     @return Amount of LP tokens received by depositing
295     """
296     self._update()
297     assert not self.is_killed  # dev: is killed
298 
299     amp: uint256 = self._A()
300     old_balances: uint256[N_COINS] = self.balances
301 
302     # Initial invariant
303     D0: uint256 = self._get_D_mem(old_balances, amp)
304 
305     lp_token: address = self.lp_token
306     token_supply: uint256 = CurveToken(lp_token).totalSupply()
307     new_balances: uint256[N_COINS] = old_balances
308     for i in range(N_COINS):
309         if token_supply == 0:
310             assert _amounts[i] > 0  # dev: initial deposit requires all coins
311         # balances store amounts of c-tokens
312         new_balances[i] += _amounts[i]
313 
314     # Invariant after change
315     D1: uint256 = self._get_D_mem(new_balances, amp)
316     assert D1 > D0
317 
318     # We need to recalculate the invariant accounting for fees
319     # to calculate fair user's share
320     D2: uint256 = D1
321     fees: uint256[N_COINS] = empty(uint256[N_COINS])
322     mint_amount: uint256 = 0
323     if token_supply > 0:
324         # Only account for fees if we are not the first to deposit
325         fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
326         admin_fee: uint256 = self.admin_fee
327         for i in range(N_COINS):
328             ideal_balance: uint256 = D1 * old_balances[i] / D0
329             difference: uint256 = 0
330             new_balance: uint256 = new_balances[i]
331             if ideal_balance > new_balance:
332                 difference = ideal_balance - new_balance
333             else:
334                 difference = new_balance - ideal_balance
335             fees[i] = fee * difference / FEE_DENOMINATOR
336             self.balances[i] = new_balance - (fees[i] * admin_fee / FEE_DENOMINATOR)
337             new_balances[i] -= fees[i]
338         D2 = self._get_D_mem(new_balances, amp)
339         mint_amount = token_supply * (D2 - D0) / D0
340     else:
341         self.balances = new_balances
342         mint_amount = D1  # Take the dust if there was any
343     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
344 
345     # Take coins from the sender
346     for i in range(N_COINS):
347         if _amounts[i] > 0:
348             # "safeTransferFrom" which works for ERC20s which return bool or not
349             _response: Bytes[32] = raw_call(
350                 self.coins[i],
351                 concat(
352                     method_id("transferFrom(address,address,uint256)"),
353                     convert(msg.sender, bytes32),
354                     convert(self, bytes32),
355                     convert(_amounts[i], bytes32),
356                 ),
357                 max_outsize=32,
358             )
359             if len(_response) > 0:
360                 assert convert(_response, bool)  # dev: failed transfer
361             # end "safeTransferFrom"
362 
363     # Mint pool tokens
364     CurveToken(lp_token).mint(msg.sender, mint_amount)
365 
366     log AddLiquidity(msg.sender, _amounts, fees, D1, token_supply + mint_amount)
367 
368     return mint_amount
369 
370 
371 @view
372 @internal
373 def _get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
374     """
375     Calculate x[j] if one makes x[i] = x
376 
377     Done by solving quadratic equation iteratively.
378     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
379     x_1**2 + b*x_1 = c
380 
381     x_1 = (x_1**2 + c) / (2*x_1 + b)
382     """
383     # x in the input is converted to the same price/precision
384 
385     assert i != j       # dev: same coin
386     assert j >= 0       # dev: j below zero
387     assert j < N_COINS  # dev: j above N_COINS
388 
389     # should be unreachable, but good for safety
390     assert i >= 0
391     assert i < N_COINS
392 
393     A: uint256 = self._A()
394     D: uint256 = self._get_D(_xp, A)
395     Ann: uint256 = A * N_COINS
396     c: uint256 = D
397     S: uint256 = 0
398     _x: uint256 = 0
399     y_prev: uint256 = 0
400 
401     for _i in range(N_COINS):
402         if _i == i:
403             _x = x
404         elif _i != j:
405             _x = _xp[_i]
406         else:
407             continue
408         S += _x
409         c = c * D / (_x * N_COINS)
410     c = c * D * A_PRECISION / (Ann * N_COINS)
411     b: uint256 = S + D * A_PRECISION / Ann  # - D
412     y: uint256 = D
413     for _i in range(255):
414         y_prev = y
415         y = (y*y + c) / (2 * y + b - D)
416         # Equality with the precision of 1
417         if y > y_prev:
418             if y - y_prev <= 1:
419                 return y
420         else:
421             if y_prev - y <= 1:
422                 return y
423     raise
424 
425 
426 @view
427 @external
428 def get_dy(i: int128, j: int128, _dx: uint256) -> uint256:
429     xp: uint256[N_COINS] = self.balances
430 
431     x: uint256 = xp[i] + _dx
432     y: uint256 = self._get_y(i, j, x, xp)
433     dy: uint256 = xp[j] - y - 1
434     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
435     return dy - fee
436 
437 
438 @external
439 @nonreentrant('lock')
440 def exchange(i: int128, j: int128, _dx: uint256, _min_dy: uint256) -> uint256:
441     """
442     @notice Perform an exchange between two coins
443     @dev Index values can be found via the `coins` public getter method
444     @param i Index value for the coin to send
445     @param j Index valie of the coin to recieve
446     @param _dx Amount of `i` being exchanged
447     @param _min_dy Minimum amount of `j` to receive
448     @return Actual amount of `j` received
449     """
450     assert not self.is_killed  # dev: is killed
451     self._update()
452 
453     old_balances: uint256[N_COINS] = self.balances
454     xp: uint256[N_COINS] = old_balances
455 
456     x: uint256 = xp[i] + _dx
457     y: uint256 = self._get_y(i, j, x, xp)
458 
459     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
460     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
461 
462     # Convert all to real units
463     dy -= dy_fee
464     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
465 
466     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
467 
468     # Change balances exactly in same way as we change actual ERC20 coin amounts
469     self.balances[i] = old_balances[i] + _dx
470     # When rounding errors happen, we undercharge admin fee in favor of LP
471     self.balances[j] = old_balances[j] - dy - dy_admin_fee
472 
473     _response: Bytes[32] = raw_call(
474         self.coins[i],
475         concat(
476             method_id("transferFrom(address,address,uint256)"),
477             convert(msg.sender, bytes32),
478             convert(self, bytes32),
479             convert(_dx, bytes32),
480         ),
481         max_outsize=32,
482     )
483     if len(_response) > 0:
484         assert convert(_response, bool)
485 
486     _response = raw_call(
487         self.coins[j],
488         concat(
489             method_id("transfer(address,uint256)"),
490             convert(msg.sender, bytes32),
491             convert(dy, bytes32),
492         ),
493         max_outsize=32,
494     )
495     if len(_response) > 0:
496         assert convert(_response, bool)
497 
498     log TokenExchange(msg.sender, i, _dx, j, dy)
499 
500     return dy
501 
502 
503 @external
504 @nonreentrant('lock')
505 def remove_liquidity(_amount: uint256, _min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
506     """
507     @notice Withdraw coins from the pool
508     @dev Withdrawal amounts are based on current deposit ratios
509     @param _amount Quantity of LP tokens to burn in the withdrawal
510     @param _min_amounts Minimum amounts of underlying coins to receive
511     @return List of amounts of coins that were withdrawn
512     """
513     self._update()
514     lp_token: address = self.lp_token
515     total_supply: uint256 = CurveToken(lp_token).totalSupply()
516     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
517     fees: uint256[N_COINS] = empty(uint256[N_COINS])  # Fees are unused but we've got them historically in event
518 
519     for i in range(N_COINS):
520         old_balance: uint256 = self.balances[i]
521         value: uint256 = old_balance * _amount / total_supply
522         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
523         self.balances[i] = old_balance - value
524         amounts[i] = value
525         _response: Bytes[32] = raw_call(
526             self.coins[i],
527             concat(
528                 method_id("transfer(address,uint256)"),
529                 convert(msg.sender, bytes32),
530                 convert(value, bytes32),
531             ),
532             max_outsize=32,
533         )
534         if len(_response) > 0:
535             assert convert(_response, bool)
536 
537     CurveToken(lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
538 
539     log RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
540 
541     return amounts
542 
543 
544 @external
545 @nonreentrant('lock')
546 def remove_liquidity_imbalance(_amounts: uint256[N_COINS], _max_burn_amount: uint256) -> uint256:
547     """
548     @notice Withdraw coins from the pool in an imbalanced amount
549     @param _amounts List of amounts of underlying coins to withdraw
550     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
551     @return Actual amount of the LP token burned in the withdrawal
552     """
553     assert not self.is_killed  # dev: is killed
554     self._update()
555 
556     amp: uint256 = self._A()
557     old_balances: uint256[N_COINS] = self.balances
558     D0: uint256 = self._get_D_mem(old_balances, amp)
559     new_balances: uint256[N_COINS] = old_balances
560     for i in range(N_COINS):
561         new_balances[i] -= _amounts[i]
562     D1: uint256 = self._get_D_mem(new_balances, amp)
563 
564     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
565     admin_fee: uint256 = self.admin_fee
566     fees: uint256[N_COINS] = empty(uint256[N_COINS])
567     for i in range(N_COINS):
568         new_balance: uint256 = new_balances[i]
569         ideal_balance: uint256 = D1 * old_balances[i] / D0
570         difference: uint256 = 0
571         if ideal_balance > new_balance:
572             difference = ideal_balance - new_balance
573         else:
574             difference = new_balance - ideal_balance
575         fees[i] = fee * difference / FEE_DENOMINATOR
576         self.balances[i] = new_balance - (fees[i] * admin_fee / FEE_DENOMINATOR)
577         new_balances[i] = new_balance - fees[i]
578     D2: uint256 = self._get_D_mem(new_balances, amp)
579 
580     lp_token: address = self.lp_token
581     token_supply: uint256 = CurveToken(lp_token).totalSupply()
582     token_amount: uint256 = (D0 - D2) * token_supply / D0
583     assert token_amount != 0  # dev: zero tokens burned
584     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
585     assert token_amount <= _max_burn_amount, "Slippage screwed you"
586 
587     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
588     for i in range(N_COINS):
589         if _amounts[i] != 0:
590             _response: Bytes[32] = raw_call(
591                 self.coins[i],
592                 concat(
593                     method_id("transfer(address,uint256)"),
594                     convert(msg.sender, bytes32),
595                     convert(_amounts[i], bytes32),
596                 ),
597                 max_outsize=32,
598             )
599             if len(_response) > 0:
600                 assert convert(_response, bool)
601 
602     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, token_supply - token_amount)
603 
604     return token_amount
605 
606 
607 @pure
608 @internal
609 def _get_y_D(A: uint256, i: int128, _xp: uint256[N_COINS], D: uint256) -> uint256:
610     """
611     Calculate x[i] if one reduces D from being calculated for xp to D
612 
613     Done by solving quadratic equation iteratively.
614     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
615     x_1**2 + b*x_1 = c
616 
617     x_1 = (x_1**2 + c) / (2*x_1 + b)
618     """
619     # x in the input is converted to the same price/precision
620 
621     assert i >= 0  # dev: i below zero
622     assert i < N_COINS  # dev: i above N_COINS
623 
624     Ann: uint256 = A * N_COINS
625     c: uint256 = D
626     S: uint256 = 0
627     _x: uint256 = 0
628     y_prev: uint256 = 0
629 
630     for _i in range(N_COINS):
631         if _i != i:
632             _x = _xp[_i]
633         else:
634             continue
635         S += _x
636         c = c * D / (_x * N_COINS)
637     c = c * D * A_PRECISION / (Ann * N_COINS)
638     b: uint256 = S + D * A_PRECISION / Ann
639     y: uint256 = D
640 
641     for _i in range(255):
642         y_prev = y
643         y = (y*y + c) / (2 * y + b - D)
644         # Equality with the precision of 1
645         if y > y_prev:
646             if y - y_prev <= 1:
647                 return y
648         else:
649             if y_prev - y <= 1:
650                 return y
651     raise
652 
653 
654 @view
655 @internal
656 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256, uint256):
657     # First, need to calculate
658     # * Get current D
659     # * Solve Eqn against y_i for D - _token_amount
660     amp: uint256 = self._A()
661     xp: uint256[N_COINS] = self.balances
662     D0: uint256 = self._get_D(xp, amp)
663 
664     total_supply: uint256 = CurveToken(self.lp_token).totalSupply()
665     D1: uint256 = D0 - _token_amount * D0 / total_supply
666     new_y: uint256 = self._get_y_D(amp, i, xp, D1)
667     xp_reduced: uint256[N_COINS] = xp
668     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
669     for j in range(N_COINS):
670         dx_expected: uint256 = 0
671         if j == i:
672             dx_expected = xp[j] * D1 / D0 - new_y
673         else:
674             dx_expected = xp[j] - xp[j] * D1 / D0
675         xp_reduced[j] -= fee * dx_expected / FEE_DENOMINATOR
676 
677     dy: uint256 = xp_reduced[i] - self._get_y_D(amp, i, xp_reduced, D1)
678     dy -= 1  # Withdraw less to account for rounding errors
679     dy_0: uint256 = xp[i] - new_y  # w/o fees
680 
681     return dy, dy_0 - dy, total_supply
682 
683 
684 @view
685 @external
686 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
687     """
688     @notice Calculate the amount received when withdrawing a single coin
689     @param _token_amount Amount of LP tokens to burn in the withdrawal
690     @param i Index value of the coin to withdraw
691     @return Amount of coin received
692     """
693     return self._calc_withdraw_one_coin(_token_amount, i)[0]
694 
695 
696 @external
697 @nonreentrant('lock')
698 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
699     """
700     @notice Withdraw a single coin from the pool
701     @param _token_amount Amount of LP tokens to burn in the withdrawal
702     @param i Index value of the coin to withdraw
703     @param _min_amount Minimum amount of coin to receive
704     @return Amount of coin received
705     """
706     assert not self.is_killed  # dev: is killed
707     self._update()
708 
709     dy: uint256 = 0
710     dy_fee: uint256 = 0
711     total_supply: uint256 = 0
712     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_token_amount, i)
713     assert dy >= _min_amount, "Not enough coins removed"
714 
715     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
716     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
717 
718     _response: Bytes[32] = raw_call(
719         self.coins[i],
720         concat(
721             method_id("transfer(address,uint256)"),
722             convert(msg.sender, bytes32),
723             convert(dy, bytes32),
724         ),
725         max_outsize=32,
726     )
727     if len(_response) > 0:
728         assert convert(_response, bool)
729 
730     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
731 
732     return dy
733 
734 
735 ### Admin functions ###
736 @external
737 def ramp_A(_future_A: uint256, _future_time: uint256):
738     assert msg.sender == self.owner  # dev: only owner
739     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
740     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
741 
742     initial_A: uint256 = self._A()
743     future_A_p: uint256 = _future_A * A_PRECISION
744 
745     assert _future_A > 0 and _future_A < MAX_A
746     if future_A_p < initial_A:
747         assert future_A_p * MAX_A_CHANGE >= initial_A
748     else:
749         assert future_A_p <= initial_A * MAX_A_CHANGE
750 
751     self.initial_A = initial_A
752     self.future_A = future_A_p
753     self.initial_A_time = block.timestamp
754     self.future_A_time = _future_time
755 
756     log RampA(initial_A, future_A_p, block.timestamp, _future_time)
757 
758 
759 @external
760 def stop_ramp_A():
761     assert msg.sender == self.owner  # dev: only owner
762 
763     current_A: uint256 = self._A()
764     self.initial_A = current_A
765     self.future_A = current_A
766     self.initial_A_time = block.timestamp
767     self.future_A_time = block.timestamp
768     # now (block.timestamp < t1) is always False, so we return saved A
769 
770     log StopRampA(current_A, block.timestamp)
771 
772 
773 @external
774 def commit_new_fee(_new_fee: uint256, _new_admin_fee: uint256):
775     assert msg.sender == self.owner  # dev: only owner
776     assert self.admin_actions_deadline == 0  # dev: active action
777     assert _new_fee <= MAX_FEE  # dev: fee exceeds maximum
778     assert _new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
779 
780     deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
781     self.admin_actions_deadline = deadline
782     self.future_fee = _new_fee
783     self.future_admin_fee = _new_admin_fee
784 
785     log CommitNewFee(deadline, _new_fee, _new_admin_fee)
786 
787 
788 @external
789 def apply_new_fee():
790     assert msg.sender == self.owner  # dev: only owner
791     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
792     assert self.admin_actions_deadline != 0  # dev: no active action
793 
794     self.admin_actions_deadline = 0
795     fee: uint256 = self.future_fee
796     admin_fee: uint256 = self.future_admin_fee
797     self.fee = fee
798     self.admin_fee = admin_fee
799 
800     log NewFee(fee, admin_fee)
801 
802 
803 @external
804 def revert_new_parameters():
805     assert msg.sender == self.owner  # dev: only owner
806 
807     self.admin_actions_deadline = 0
808 
809 
810 @external
811 def commit_transfer_ownership(_owner: address):
812     assert msg.sender == self.owner  # dev: only owner
813     assert self.transfer_ownership_deadline == 0  # dev: active transfer
814 
815     deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
816     self.transfer_ownership_deadline = deadline
817     self.future_owner = _owner
818 
819     log CommitNewAdmin(deadline, _owner)
820 
821 
822 @external
823 def apply_transfer_ownership():
824     assert msg.sender == self.owner  # dev: only owner
825     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
826     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
827 
828     self.transfer_ownership_deadline = 0
829     owner: address = self.future_owner
830     self.owner = owner
831 
832     log NewAdmin(owner)
833 
834 
835 @external
836 def revert_transfer_ownership():
837     assert msg.sender == self.owner  # dev: only owner
838 
839     self.transfer_ownership_deadline = 0
840 
841 
842 @view
843 @external
844 def admin_balances(i: uint256) -> uint256:
845     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
846 
847 
848 @external
849 def withdraw_admin_fees():
850     assert msg.sender == self.owner  # dev: only owner
851 
852     for i in range(N_COINS):
853         coin: address = self.coins[i]
854         value: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
855         if value > 0:
856             _response: Bytes[32] = raw_call(
857                 coin,
858                 concat(
859                     method_id("transfer(address,uint256)"),
860                     convert(msg.sender, bytes32),
861                     convert(value, bytes32),
862                 ),
863                 max_outsize=32,
864             )  # dev: failed transfer
865             if len(_response) > 0:
866                 assert convert(_response, bool)
867 
868 
869 @external
870 def donate_admin_fees():
871     assert msg.sender == self.owner  # dev: only owner
872     for i in range(N_COINS):
873         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
874 
875 
876 @external
877 def kill_me():
878     assert msg.sender == self.owner  # dev: only owner
879     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
880     self.is_killed = True
881 
882 
883 @external
884 def unkill_me():
885     assert msg.sender == self.owner  # dev: only owner
886     self.is_killed = False