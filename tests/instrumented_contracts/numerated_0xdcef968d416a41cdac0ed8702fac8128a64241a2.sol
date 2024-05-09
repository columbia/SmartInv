1 # @version 0.3.1
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 """
7 from vyper.interfaces import ERC20
8 
9 
10 interface CurveToken:
11     def totalSupply() -> uint256: view
12     def mint(_to: address, _value: uint256) -> bool: nonpayable
13     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
14 
15 
16 # Events
17 event TokenExchange:
18     buyer: indexed(address)
19     sold_id: int128
20     tokens_sold: uint256
21     bought_id: int128
22     tokens_bought: uint256
23 
24 event AddLiquidity:
25     provider: indexed(address)
26     token_amounts: uint256[N_COINS]
27     fees: uint256[N_COINS]
28     invariant: uint256
29     token_supply: uint256
30 
31 event RemoveLiquidity:
32     provider: indexed(address)
33     token_amounts: uint256[N_COINS]
34     fees: uint256[N_COINS]
35     token_supply: uint256
36 
37 event RemoveLiquidityOne:
38     provider: indexed(address)
39     token_amount: uint256
40     coin_amount: uint256
41     token_supply: uint256
42 
43 event RemoveLiquidityImbalance:
44     provider: indexed(address)
45     token_amounts: uint256[N_COINS]
46     fees: uint256[N_COINS]
47     invariant: uint256
48     token_supply: uint256
49 
50 event CommitNewAdmin:
51     deadline: indexed(uint256)
52     admin: indexed(address)
53 
54 event NewAdmin:
55     admin: indexed(address)
56 
57 event CommitNewFee:
58     deadline: indexed(uint256)
59     fee: uint256
60     admin_fee: uint256
61 
62 event NewFee:
63     fee: uint256
64     admin_fee: uint256
65 
66 event RampA:
67     old_A: uint256
68     new_A: uint256
69     initial_time: uint256
70     future_time: uint256
71 
72 event StopRampA:
73     A: uint256
74     t: uint256
75 
76 
77 # These constants must be set prior to compiling
78 N_COINS: constant(int128) = 2
79 PRECISION_MUL: constant(uint256[N_COINS]) = [1, 1000000000000]
80 RATES: constant(uint256[N_COINS]) = [1000000000000000000, 1000000000000000000000000000000]
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
99 owner: public(address)
100 lp_token: public(address)
101 
102 A_PRECISION: constant(uint256) = 100
103 initial_A: public(uint256)
104 future_A: public(uint256)
105 initial_A_time: public(uint256)
106 future_A_time: public(uint256)
107 
108 admin_actions_deadline: public(uint256)
109 transfer_ownership_deadline: public(uint256)
110 future_fee: public(uint256)
111 future_admin_fee: public(uint256)
112 future_owner: public(address)
113 
114 is_killed: bool
115 kill_deadline: uint256
116 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
117 
118 
119 @external
120 def __init__(
121     _owner: address,
122     _coins: address[N_COINS],
123     _pool_token: address,
124     _A: uint256,
125     _fee: uint256,
126     _admin_fee: uint256
127 ):
128     """
129     @notice Contract constructor
130     @param _owner Contract owner address
131     @param _coins Addresses of ERC20 conracts of coins
132     @param _pool_token Address of the token representing LP share
133     @param _A Amplification coefficient multiplied by n * (n - 1)
134     @param _fee Fee to charge for exchanges
135     @param _admin_fee Admin fee
136     """
137     for i in range(N_COINS):
138         assert _coins[i] != ZERO_ADDRESS
139     self.coins = _coins
140     self.initial_A = _A * A_PRECISION
141     self.future_A = _A * A_PRECISION
142     self.fee = _fee
143     self.admin_fee = _admin_fee
144     self.owner = _owner
145     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
146     self.lp_token = _pool_token
147 
148 
149 @view
150 @internal
151 def _A() -> uint256:
152     """
153     Handle ramping A up or down
154     """
155     t1: uint256 = self.future_A_time
156     A1: uint256 = self.future_A
157 
158     if block.timestamp < t1:
159         A0: uint256 = self.initial_A
160         t0: uint256 = self.initial_A_time
161         # Expressions in uint256 cannot have negative numbers, thus "if"
162         if A1 > A0:
163             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
164         else:
165             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
166 
167     else:  # when t1 == 0 or block.timestamp >= t1
168         return A1
169 
170 
171 @view
172 @external
173 def A() -> uint256:
174     return self._A() / A_PRECISION
175 
176 
177 @view
178 @external
179 def A_precise() -> uint256:
180     return self._A()
181 
182 
183 @view
184 @internal
185 def _xp() -> uint256[N_COINS]:
186     result: uint256[N_COINS] = RATES
187     for i in range(N_COINS):
188         result[i] = result[i] * self.balances[i] / PRECISION
189     return result
190 
191 
192 @pure
193 @internal
194 def _xp_mem(_balances: uint256[N_COINS]) -> uint256[N_COINS]:
195     result: uint256[N_COINS] = RATES
196     for i in range(N_COINS):
197         result[i] = result[i] * _balances[i] / PRECISION
198     return result
199 
200 
201 @pure
202 @internal
203 def _get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
204     """
205     D invariant calculation in non-overflowing integer operations
206     iteratively
207 
208     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
209 
210     Converging solution:
211     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
212     """
213     S: uint256 = 0
214     Dprev: uint256 = 0
215 
216     for _x in _xp:
217         S += _x
218     if S == 0:
219         return 0
220 
221     D: uint256 = S
222     Ann: uint256 = _amp * N_COINS
223     for _i in range(255):
224         D_P: uint256 = D
225         for _x in _xp:
226             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
227         Dprev = D
228         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
229         # Equality with the precision of 1
230         if D > Dprev:
231             if D - Dprev <= 1:
232                 return D
233         else:
234             if Dprev - D <= 1:
235                 return D
236     # convergence typically occurs in 4 rounds or less, this should be unreachable!
237     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
238     raise
239 
240 
241 @view
242 @internal
243 def _get_D_mem(_balances: uint256[N_COINS], _amp: uint256) -> uint256:
244     return self._get_D(self._xp_mem(_balances), _amp)
245 
246 
247 @view
248 @external
249 def get_virtual_price() -> uint256:
250     """
251     @notice The current virtual price of the pool LP token
252     @dev Useful for calculating profits
253     @return LP token virtual price normalized to 1e18
254     """
255     D: uint256 = self._get_D(self._xp(), self._A())
256     # D is in the units similar to DAI (e.g. converted to precision 1e18)
257     # When balanced, D = n * x_u - total virtual value of the portfolio
258     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
259     return D * PRECISION / token_supply
260 
261 
262 @view
263 @external
264 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
265     """
266     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
267     @dev This calculation accounts for slippage, but not fees.
268          Needed to prevent front-running, not for precise calculations!
269     @param _amounts Amount of each coin being deposited
270     @param _is_deposit set True for deposits, False for withdrawals
271     @return Expected amount of LP tokens received
272     """
273     amp: uint256 = self._A()
274     balances: uint256[N_COINS] = self.balances
275     D0: uint256 = self._get_D_mem(balances, amp)
276     for i in range(N_COINS):
277         if _is_deposit:
278             balances[i] += _amounts[i]
279         else:
280             balances[i] -= _amounts[i]
281     D1: uint256 = self._get_D_mem(balances, amp)
282     token_amount: uint256 = CurveToken(self.lp_token).totalSupply()
283     diff: uint256 = 0
284     if _is_deposit:
285         diff = D1 - D0
286     else:
287         diff = D0 - D1
288     return diff * token_amount / D0
289 
290 
291 @external
292 @nonreentrant('lock')
293 def add_liquidity(_amounts: uint256[N_COINS], _min_mint_amount: uint256) -> uint256:
294     """
295     @notice Deposit coins into the pool
296     @param _amounts List of amounts of coins to deposit
297     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
298     @return Amount of LP tokens received by depositing
299     """
300     assert not self.is_killed  # dev: is killed
301 
302     amp: uint256 = self._A()
303     old_balances: uint256[N_COINS] = self.balances
304 
305     # Initial invariant
306     D0: uint256 = self._get_D_mem(old_balances, amp)
307 
308     lp_token: address = self.lp_token
309     token_supply: uint256 = CurveToken(lp_token).totalSupply()
310     new_balances: uint256[N_COINS] = old_balances
311     for i in range(N_COINS):
312         if token_supply == 0:
313             assert _amounts[i] > 0  # dev: initial deposit requires all coins
314         # balances store amounts of c-tokens
315         new_balances[i] += _amounts[i]
316 
317     # Invariant after change
318     D1: uint256 = self._get_D_mem(new_balances, amp)
319     assert D1 > D0
320 
321     # We need to recalculate the invariant accounting for fees
322     # to calculate fair user's share
323     D2: uint256 = D1
324     fees: uint256[N_COINS] = empty(uint256[N_COINS])
325     mint_amount: uint256 = 0
326     if token_supply > 0:
327         # Only account for fees if we are not the first to deposit
328         fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
329         admin_fee: uint256 = self.admin_fee
330         for i in range(N_COINS):
331             ideal_balance: uint256 = D1 * old_balances[i] / D0
332             difference: uint256 = 0
333             new_balance: uint256 = new_balances[i]
334             if ideal_balance > new_balance:
335                 difference = ideal_balance - new_balance
336             else:
337                 difference = new_balance - ideal_balance
338             fees[i] = fee * difference / FEE_DENOMINATOR
339             self.balances[i] = new_balance - (fees[i] * admin_fee / FEE_DENOMINATOR)
340             new_balances[i] -= fees[i]
341         D2 = self._get_D_mem(new_balances, amp)
342         mint_amount = token_supply * (D2 - D0) / D0
343     else:
344         self.balances = new_balances
345         mint_amount = D1  # Take the dust if there was any
346     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
347 
348     # Take coins from the sender
349     for i in range(N_COINS):
350         if _amounts[i] > 0:
351             # "safeTransferFrom" which works for ERC20s which return bool or not
352             _response: Bytes[32] = raw_call(
353                 self.coins[i],
354                 concat(
355                     method_id("transferFrom(address,address,uint256)"),
356                     convert(msg.sender, bytes32),
357                     convert(self, bytes32),
358                     convert(_amounts[i], bytes32),
359                 ),
360                 max_outsize=32,
361             )
362             if len(_response) > 0:
363                 assert convert(_response, bool)  # dev: failed transfer
364             # end "safeTransferFrom"
365 
366     # Mint pool tokens
367     CurveToken(lp_token).mint(msg.sender, mint_amount)
368 
369     log AddLiquidity(msg.sender, _amounts, fees, D1, token_supply + mint_amount)
370 
371     return mint_amount
372 
373 
374 @view
375 @internal
376 def _get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
377     """
378     Calculate x[j] if one makes x[i] = x
379 
380     Done by solving quadratic equation iteratively.
381     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
382     x_1**2 + b*x_1 = c
383 
384     x_1 = (x_1**2 + c) / (2*x_1 + b)
385     """
386     # x in the input is converted to the same price/precision
387 
388     assert i != j       # dev: same coin
389     assert j >= 0       # dev: j below zero
390     assert j < N_COINS  # dev: j above N_COINS
391 
392     # should be unreachable, but good for safety
393     assert i >= 0
394     assert i < N_COINS
395 
396     A: uint256 = self._A()
397     D: uint256 = self._get_D(_xp, A)
398     Ann: uint256 = A * N_COINS
399     c: uint256 = D
400     S: uint256 = 0
401     _x: uint256 = 0
402     y_prev: uint256 = 0
403 
404     for _i in range(N_COINS):
405         if _i == i:
406             _x = x
407         elif _i != j:
408             _x = _xp[_i]
409         else:
410             continue
411         S += _x
412         c = c * D / (_x * N_COINS)
413     c = c * D * A_PRECISION / (Ann * N_COINS)
414     b: uint256 = S + D * A_PRECISION / Ann  # - D
415     y: uint256 = D
416     for _i in range(255):
417         y_prev = y
418         y = (y*y + c) / (2 * y + b - D)
419         # Equality with the precision of 1
420         if y > y_prev:
421             if y - y_prev <= 1:
422                 return y
423         else:
424             if y_prev - y <= 1:
425                 return y
426     raise
427 
428 
429 @view
430 @external
431 def get_dy(i: int128, j: int128, _dx: uint256) -> uint256:
432     xp: uint256[N_COINS] = self._xp()
433     rates: uint256[N_COINS] = RATES
434 
435     x: uint256 = xp[i] + (_dx * rates[i] / PRECISION)
436     y: uint256 = self._get_y(i, j, x, xp)
437     dy: uint256 = xp[j] - y - 1
438     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
439     return (dy - fee) * PRECISION / rates[j]
440 
441 
442 @external
443 @nonreentrant('lock')
444 def exchange(i: int128, j: int128, _dx: uint256, _min_dy: uint256) -> uint256:
445     """
446     @notice Perform an exchange between two coins
447     @dev Index values can be found via the `coins` public getter method
448     @param i Index value for the coin to send
449     @param j Index valie of the coin to recieve
450     @param _dx Amount of `i` being exchanged
451     @param _min_dy Minimum amount of `j` to receive
452     @return Actual amount of `j` received
453     """
454     assert not self.is_killed  # dev: is killed
455 
456     old_balances: uint256[N_COINS] = self.balances
457     xp: uint256[N_COINS] = self._xp_mem(old_balances)
458 
459     rates: uint256[N_COINS] = RATES
460     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
461     y: uint256 = self._get_y(i, j, x, xp)
462 
463     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
464     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
465 
466     # Convert all to real units
467     dy = (dy - dy_fee) * PRECISION / rates[j]
468     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
469 
470     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
471     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
472 
473     # Change balances exactly in same way as we change actual ERC20 coin amounts
474     self.balances[i] = old_balances[i] + _dx
475     # When rounding errors happen, we undercharge admin fee in favor of LP
476     self.balances[j] = old_balances[j] - dy - dy_admin_fee
477 
478     _response: Bytes[32] = raw_call(
479         self.coins[i],
480         concat(
481             method_id("transferFrom(address,address,uint256)"),
482             convert(msg.sender, bytes32),
483             convert(self, bytes32),
484             convert(_dx, bytes32),
485         ),
486         max_outsize=32,
487     )
488     if len(_response) > 0:
489         assert convert(_response, bool)
490 
491     _response = raw_call(
492         self.coins[j],
493         concat(
494             method_id("transfer(address,uint256)"),
495             convert(msg.sender, bytes32),
496             convert(dy, bytes32),
497         ),
498         max_outsize=32,
499     )
500     if len(_response) > 0:
501         assert convert(_response, bool)
502 
503     log TokenExchange(msg.sender, i, _dx, j, dy)
504 
505     return dy
506 
507 
508 @external
509 @nonreentrant('lock')
510 def remove_liquidity(_amount: uint256, _min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
511     """
512     @notice Withdraw coins from the pool
513     @dev Withdrawal amounts are based on current deposit ratios
514     @param _amount Quantity of LP tokens to burn in the withdrawal
515     @param _min_amounts Minimum amounts of underlying coins to receive
516     @return List of amounts of coins that were withdrawn
517     """
518     lp_token: address = self.lp_token
519     total_supply: uint256 = CurveToken(lp_token).totalSupply()
520     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
521 
522     for i in range(N_COINS):
523         old_balance: uint256 = self.balances[i]
524         value: uint256 = old_balance * _amount / total_supply
525         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
526         self.balances[i] = old_balance - value
527         amounts[i] = value
528         _response: Bytes[32] = raw_call(
529             self.coins[i],
530             concat(
531                 method_id("transfer(address,uint256)"),
532                 convert(msg.sender, bytes32),
533                 convert(value, bytes32),
534             ),
535             max_outsize=32,
536         )
537         if len(_response) > 0:
538             assert convert(_response, bool)
539 
540     CurveToken(lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
541 
542     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply - _amount)
543 
544     return amounts
545 
546 
547 @external
548 @nonreentrant('lock')
549 def remove_liquidity_imbalance(_amounts: uint256[N_COINS], _max_burn_amount: uint256) -> uint256:
550     """
551     @notice Withdraw coins from the pool in an imbalanced amount
552     @param _amounts List of amounts of underlying coins to withdraw
553     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
554     @return Actual amount of the LP token burned in the withdrawal
555     """
556     assert not self.is_killed  # dev: is killed
557 
558     amp: uint256 = self._A()
559     old_balances: uint256[N_COINS] = self.balances
560     D0: uint256 = self._get_D_mem(old_balances, amp)
561     new_balances: uint256[N_COINS] = old_balances
562     for i in range(N_COINS):
563         new_balances[i] -= _amounts[i]
564     D1: uint256 = self._get_D_mem(new_balances, amp)
565 
566     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
567     admin_fee: uint256 = self.admin_fee
568     fees: uint256[N_COINS] = empty(uint256[N_COINS])
569     for i in range(N_COINS):
570         new_balance: uint256 = new_balances[i]
571         ideal_balance: uint256 = D1 * old_balances[i] / D0
572         difference: uint256 = 0
573         if ideal_balance > new_balance:
574             difference = ideal_balance - new_balance
575         else:
576             difference = new_balance - ideal_balance
577         fees[i] = fee * difference / FEE_DENOMINATOR
578         self.balances[i] = new_balance - (fees[i] * admin_fee / FEE_DENOMINATOR)
579         new_balances[i] = new_balance - fees[i]
580     D2: uint256 = self._get_D_mem(new_balances, amp)
581 
582     lp_token: address = self.lp_token
583     token_supply: uint256 = CurveToken(lp_token).totalSupply()
584     token_amount: uint256 = (D0 - D2) * token_supply / D0
585     assert token_amount != 0  # dev: zero tokens burned
586     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
587     assert token_amount <= _max_burn_amount, "Slippage screwed you"
588 
589     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
590     for i in range(N_COINS):
591         if _amounts[i] != 0:
592             _response: Bytes[32] = raw_call(
593                 self.coins[i],
594                 concat(
595                     method_id("transfer(address,uint256)"),
596                     convert(msg.sender, bytes32),
597                     convert(_amounts[i], bytes32),
598                 ),
599                 max_outsize=32,
600             )
601             if len(_response) > 0:
602                 assert convert(_response, bool)
603 
604     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, token_supply - token_amount)
605 
606     return token_amount
607 
608 
609 @pure
610 @internal
611 def _get_y_D(A: uint256, i: int128, _xp: uint256[N_COINS], D: uint256) -> uint256:
612     """
613     Calculate x[i] if one reduces D from being calculated for xp to D
614 
615     Done by solving quadratic equation iteratively.
616     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
617     x_1**2 + b*x_1 = c
618 
619     x_1 = (x_1**2 + c) / (2*x_1 + b)
620     """
621     # x in the input is converted to the same price/precision
622 
623     assert i >= 0  # dev: i below zero
624     assert i < N_COINS  # dev: i above N_COINS
625 
626     Ann: uint256 = A * N_COINS
627     c: uint256 = D
628     S: uint256 = 0
629     _x: uint256 = 0
630     y_prev: uint256 = 0
631 
632     for _i in range(N_COINS):
633         if _i != i:
634             _x = _xp[_i]
635         else:
636             continue
637         S += _x
638         c = c * D / (_x * N_COINS)
639     c = c * D * A_PRECISION / (Ann * N_COINS)
640     b: uint256 = S + D * A_PRECISION / Ann
641     y: uint256 = D
642 
643     for _i in range(255):
644         y_prev = y
645         y = (y*y + c) / (2 * y + b - D)
646         # Equality with the precision of 1
647         if y > y_prev:
648             if y - y_prev <= 1:
649                 return y
650         else:
651             if y_prev - y <= 1:
652                 return y
653     raise
654 
655 
656 @view
657 @internal
658 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256, uint256):
659     # First, need to calculate
660     # * Get current D
661     # * Solve Eqn against y_i for D - _token_amount
662     amp: uint256 = self._A()
663     xp: uint256[N_COINS] = self._xp()
664     D0: uint256 = self._get_D(xp, amp)
665 
666     total_supply: uint256 = CurveToken(self.lp_token).totalSupply()
667     D1: uint256 = D0 - _token_amount * D0 / total_supply
668     new_y: uint256 = self._get_y_D(amp, i, xp, D1)
669     xp_reduced: uint256[N_COINS] = xp
670     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
671     for j in range(N_COINS):
672         dx_expected: uint256 = 0
673         if j == i:
674             dx_expected = xp[j] * D1 / D0 - new_y
675         else:
676             dx_expected = xp[j] - xp[j] * D1 / D0
677         xp_reduced[j] -= fee * dx_expected / FEE_DENOMINATOR
678 
679     dy: uint256 = xp_reduced[i] - self._get_y_D(amp, i, xp_reduced, D1)
680     precisions: uint256[N_COINS] = PRECISION_MUL
681     dy = (dy - 1) / precisions[i]  # Withdraw less to account for rounding errors
682     dy_0: uint256 = (xp[i] - new_y) / precisions[i]  # w/o fees
683 
684     return dy, dy_0 - dy, total_supply
685 
686 
687 @view
688 @external
689 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
690     """
691     @notice Calculate the amount received when withdrawing a single coin
692     @param _token_amount Amount of LP tokens to burn in the withdrawal
693     @param i Index value of the coin to withdraw
694     @return Amount of coin received
695     """
696     return self._calc_withdraw_one_coin(_token_amount, i)[0]
697 
698 
699 @external
700 @nonreentrant('lock')
701 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
702     """
703     @notice Withdraw a single coin from the pool
704     @param _token_amount Amount of LP tokens to burn in the withdrawal
705     @param i Index value of the coin to withdraw
706     @param _min_amount Minimum amount of coin to receive
707     @return Amount of coin received
708     """
709     assert not self.is_killed  # dev: is killed
710 
711     dy: uint256 = 0
712     dy_fee: uint256 = 0
713     total_supply: uint256 = 0
714     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_token_amount, i)
715     assert dy >= _min_amount, "Not enough coins removed"
716 
717     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
718     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
719 
720     _response: Bytes[32] = raw_call(
721         self.coins[i],
722         concat(
723             method_id("transfer(address,uint256)"),
724             convert(msg.sender, bytes32),
725             convert(dy, bytes32),
726         ),
727         max_outsize=32,
728     )
729     if len(_response) > 0:
730         assert convert(_response, bool)
731 
732     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
733 
734     return dy
735 
736 
737 ### Admin functions ###
738 @external
739 def ramp_A(_future_A: uint256, _future_time: uint256):
740     assert msg.sender == self.owner  # dev: only owner
741     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
742     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
743 
744     initial_A: uint256 = self._A()
745     future_A_p: uint256 = _future_A * A_PRECISION
746 
747     assert _future_A > 0 and _future_A < MAX_A
748     if future_A_p < initial_A:
749         assert future_A_p * MAX_A_CHANGE >= initial_A
750     else:
751         assert future_A_p <= initial_A * MAX_A_CHANGE
752 
753     self.initial_A = initial_A
754     self.future_A = future_A_p
755     self.initial_A_time = block.timestamp
756     self.future_A_time = _future_time
757 
758     log RampA(initial_A, future_A_p, block.timestamp, _future_time)
759 
760 
761 @external
762 def stop_ramp_A():
763     assert msg.sender == self.owner  # dev: only owner
764 
765     current_A: uint256 = self._A()
766     self.initial_A = current_A
767     self.future_A = current_A
768     self.initial_A_time = block.timestamp
769     self.future_A_time = block.timestamp
770     # now (block.timestamp < t1) is always False, so we return saved A
771 
772     log StopRampA(current_A, block.timestamp)
773 
774 
775 @external
776 def commit_new_fee(_new_fee: uint256, _new_admin_fee: uint256):
777     assert msg.sender == self.owner  # dev: only owner
778     assert self.admin_actions_deadline == 0  # dev: active action
779     assert _new_fee <= MAX_FEE  # dev: fee exceeds maximum
780     assert _new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
781 
782     deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
783     self.admin_actions_deadline = deadline
784     self.future_fee = _new_fee
785     self.future_admin_fee = _new_admin_fee
786 
787     log CommitNewFee(deadline, _new_fee, _new_admin_fee)
788 
789 
790 @external
791 def apply_new_fee():
792     assert msg.sender == self.owner  # dev: only owner
793     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
794     assert self.admin_actions_deadline != 0  # dev: no active action
795 
796     self.admin_actions_deadline = 0
797     fee: uint256 = self.future_fee
798     admin_fee: uint256 = self.future_admin_fee
799     self.fee = fee
800     self.admin_fee = admin_fee
801 
802     log NewFee(fee, admin_fee)
803 
804 
805 @external
806 def revert_new_parameters():
807     assert msg.sender == self.owner  # dev: only owner
808 
809     self.admin_actions_deadline = 0
810 
811 
812 @external
813 def commit_transfer_ownership(_owner: address):
814     assert msg.sender == self.owner  # dev: only owner
815     assert self.transfer_ownership_deadline == 0  # dev: active transfer
816 
817     deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
818     self.transfer_ownership_deadline = deadline
819     self.future_owner = _owner
820 
821     log CommitNewAdmin(deadline, _owner)
822 
823 
824 @external
825 def apply_transfer_ownership():
826     assert msg.sender == self.owner  # dev: only owner
827     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
828     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
829 
830     self.transfer_ownership_deadline = 0
831     owner: address = self.future_owner
832     self.owner = owner
833 
834     log NewAdmin(owner)
835 
836 
837 @external
838 def revert_transfer_ownership():
839     assert msg.sender == self.owner  # dev: only owner
840 
841     self.transfer_ownership_deadline = 0
842 
843 
844 @view
845 @external
846 def admin_balances(i: uint256) -> uint256:
847     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
848 
849 
850 @external
851 def withdraw_admin_fees():
852     assert msg.sender == self.owner  # dev: only owner
853 
854     for i in range(N_COINS):
855         coin: address = self.coins[i]
856         value: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
857         if value > 0:
858             _response: Bytes[32] = raw_call(
859                 coin,
860                 concat(
861                     method_id("transfer(address,uint256)"),
862                     convert(msg.sender, bytes32),
863                     convert(value, bytes32),
864                 ),
865                 max_outsize=32,
866             )  # dev: failed transfer
867             if len(_response) > 0:
868                 assert convert(_response, bool)
869 
870 
871 @external
872 def donate_admin_fees():
873     assert msg.sender == self.owner  # dev: only owner
874     for i in range(N_COINS):
875         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
876 
877 
878 @external
879 def kill_me():
880     assert msg.sender == self.owner  # dev: only owner
881     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
882     self.is_killed = True
883 
884 
885 @external
886 def unkill_me():
887     assert msg.sender == self.owner  # dev: only owner
888     self.is_killed = False