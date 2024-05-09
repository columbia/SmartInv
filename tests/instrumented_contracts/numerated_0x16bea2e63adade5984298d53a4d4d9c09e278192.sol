1 # @version 0.2.8
2 
3 """
4 @title ETH2SNOW
5 @author SnowSwap/Curve
6  _____ _   _      _____  _____ _   _ _____  _    _ 
7 |  ___| | | |    / __  \/  ___| \ | |  _  || |  | |
8 | |__ | |_| |__  `' / /'\ `--.|  \| | | | || |  | |
9 |  __|| __| '_ \   / /   `--. \ . ` | | | || |/\| |
10 | |___| |_| | | |./ /___/\__/ / |\  \ \_/ /\  /\  /
11 \____/ \__|_| |_|\_____/\____/\_| \_/\___/  \/  \/ 
12                                                    
13                                                    
14 SnowSwap.org ETH2Snow Pool (Snowswap.org WETH/crETH/vETH2/aETH)
15 """
16 
17 from vyper.interfaces import ERC20
18 
19 interface CurveToken:
20     def mint(_to: address, _value: uint256) -> bool: nonpayable
21     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
22 
23 
24 # Events
25 event TokenExchange:
26     buyer: indexed(address)
27     sold_id: int128
28     tokens_sold: uint256
29     bought_id: int128
30     tokens_bought: uint256
31 
32 event AddLiquidity:
33     provider: indexed(address)
34     token_amounts: uint256[N_COINS]
35     fees: uint256[N_COINS]
36     invariant: uint256
37     token_supply: uint256
38 
39 event RemoveLiquidity:
40     provider: indexed(address)
41     token_amounts: uint256[N_COINS]
42     fees: uint256[N_COINS]
43     token_supply: uint256
44 
45 event RemoveLiquidityOne:
46     provider: indexed(address)
47     token_amount: uint256
48     coin_amount: uint256
49     token_supply: uint256
50 
51 event RemoveLiquidityImbalance:
52     provider: indexed(address)
53     token_amounts: uint256[N_COINS]
54     fees: uint256[N_COINS]
55     invariant: uint256
56     token_supply: uint256
57 
58 event CommitNewAdmin:
59     deadline: indexed(uint256)
60     admin: indexed(address)
61 
62 event NewAdmin:
63     admin: indexed(address)
64 
65 event CommitNewFee:
66     deadline: indexed(uint256)
67     fee: uint256
68     admin_fee: uint256
69 
70 event NewFee:
71     fee: uint256
72     admin_fee: uint256
73 
74 event RampA:
75     old_A: uint256
76     new_A: uint256
77     initial_time: uint256
78     future_time: uint256
79 
80 event StopRampA:
81     A: uint256
82     t: uint256
83 
84 
85 # These constants must be set prior to compiling
86 N_COINS: constant(int128) = 4
87 # PRECISION_MUL: constant(uint256[N_COINS]) = []
88 RATES: constant(uint256[N_COINS]) = [1000000000000000000, 1000000000000000000, 1000000000000000000, 1000000000000000000]
89 
90 # fixed constants
91 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
92 LENDING_PRECISION: constant(uint256) = 10 ** 18
93 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
94 
95 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
96 MAX_FEE: constant(uint256) = 5 * 10 ** 9
97 MAX_A: constant(uint256) = 10 ** 6
98 MAX_A_CHANGE: constant(uint256) = 10
99 
100 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
101 MIN_RAMP_TIME: constant(uint256) = 86400
102 
103 coins: public(address[N_COINS])
104 balances: public(uint256[N_COINS])
105 fee: public(uint256)  # fee * 1e10
106 admin_fee: public(uint256)  # admin_fee * 1e10
107 
108 owner: public(address)
109 lp_token: public(address)
110 
111 A_PRECISION: constant(uint256) = 100
112 initial_A: public(uint256)
113 future_A: public(uint256)
114 initial_A_time: public(uint256)
115 future_A_time: public(uint256)
116 
117 admin_actions_deadline: public(uint256)
118 transfer_ownership_deadline: public(uint256)
119 future_fee: public(uint256)
120 future_admin_fee: public(uint256)
121 future_owner: public(address)
122 
123 is_killed: bool
124 kill_deadline: uint256
125 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
126 
127 
128 @external
129 def __init__(
130     _owner: address,
131     _coins: address[N_COINS],
132     _pool_token: address,
133     _A: uint256,
134     _fee: uint256,
135     _admin_fee: uint256
136 ):
137     """
138     @notice Contract constructor
139     @param _owner Contract owner address
140     @param _coins Addresses of ERC20 conracts of coins
141     @param _pool_token Address of the token representing LP share
142     @param _A Amplification coefficient multiplied by n * (n - 1)
143     @param _fee Fee to charge for exchanges
144     @param _admin_fee Admin fee
145     """
146     for i in range(N_COINS):
147         assert _coins[i] != ZERO_ADDRESS
148     self.coins = _coins
149     self.initial_A = _A * A_PRECISION
150     self.future_A = _A * A_PRECISION
151     self.fee = _fee
152     self.admin_fee = _admin_fee
153     self.owner = _owner
154     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
155     self.lp_token = _pool_token
156 
157 
158 @view
159 @internal
160 def _A() -> uint256:
161     """
162     Handle ramping A up or down
163     """
164     t1: uint256 = self.future_A_time
165     A1: uint256 = self.future_A
166 
167     if block.timestamp < t1:
168         A0: uint256 = self.initial_A
169         t0: uint256 = self.initial_A_time
170         # Expressions in uint256 cannot have negative numbers, thus "if"
171         if A1 > A0:
172             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
173         else:
174             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
175 
176     else:  # when t1 == 0 or block.timestamp >= t1
177         return A1
178 
179 
180 @view
181 @external
182 def A() -> uint256:
183     return self._A() / A_PRECISION
184 
185 
186 @view
187 @external
188 def A_precise() -> uint256:
189     return self._A()
190 
191 
192 @view
193 @internal
194 def _xp() -> uint256[N_COINS]:
195     result: uint256[N_COINS] = RATES
196     for i in range(N_COINS):
197         result[i] = result[i] * self.balances[i] / LENDING_PRECISION
198     return result
199 
200 
201 @pure
202 @internal
203 def _xp_mem(_balances: uint256[N_COINS]) -> uint256[N_COINS]:
204     result: uint256[N_COINS] = RATES
205     for i in range(N_COINS):
206         result[i] = result[i] * _balances[i] / PRECISION
207     return result
208 
209 
210 @pure
211 @internal
212 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
213     S: uint256 = 0
214     Dprev: uint256 = 0
215 
216     for _x in xp:
217         S += _x
218     if S == 0:
219         return 0
220 
221     D: uint256 = S
222     Ann: uint256 = amp * N_COINS
223     for _i in range(255):
224         D_P: uint256 = D
225         for _x in xp:
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
236 
237     # convergence typically occurs in 4 rounds or less, this should be unreachable!
238     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
239     raise
240 
241 
242 @view
243 @internal
244 def get_D_mem(_balances: uint256[N_COINS], amp: uint256) -> uint256:
245     return self.get_D(self._xp_mem(_balances), amp)
246 
247 
248 @view
249 @external
250 def get_virtual_price() -> uint256:
251     """
252     @notice The current virtual price of the pool LP token
253     @dev Useful for calculating profits
254     @return LP token virtual price normalized to 1e18
255     """
256     D: uint256 = self.get_D(self._xp(), self._A())
257     # D is in the units similar to DAI (e.g. converted to precision 1e18)
258     # When balanced, D = n * x_u - total virtual value of the portfolio
259     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
260     return D * PRECISION / token_supply
261 
262 
263 @view
264 @external
265 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
266     """
267     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
268     @dev This calculation accounts for slippage, but not fees.
269          Needed to prevent front-running, not for precise calculations!
270     @param amounts Amount of each coin being deposited
271     @param is_deposit set True for deposits, False for withdrawals
272     @return Expected amount of LP tokens received
273     """
274     amp: uint256 = self._A()
275     _balances: uint256[N_COINS] = self.balances
276     D0: uint256 = self.get_D_mem(_balances, amp)
277     for i in range(N_COINS):
278         if is_deposit:
279             _balances[i] += amounts[i]
280         else:
281             _balances[i] -= amounts[i]
282     D1: uint256 = self.get_D_mem(_balances, amp)
283     token_amount: uint256 = ERC20(self.lp_token).totalSupply()
284     diff: uint256 = 0
285     if is_deposit:
286         diff = D1 - D0
287     else:
288         diff = D0 - D1
289     return diff * token_amount / D0
290 
291 
292 @external
293 @nonreentrant('lock')
294 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
295     """
296     @notice Deposit coins into the pool
297     @param amounts List of amounts of coins to deposit
298     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
299     @return Amount of LP tokens received by depositing
300     """
301     assert not self.is_killed  # dev: is killed
302 
303     amp: uint256 = self._A()
304 
305     _lp_token: address = self.lp_token
306     token_supply: uint256 = ERC20(_lp_token).totalSupply()
307     # Initial invariant
308     D0: uint256 = 0
309     old_balances: uint256[N_COINS] = self.balances
310     if token_supply > 0:
311         D0 = self.get_D_mem(old_balances, amp)
312     new_balances: uint256[N_COINS] = old_balances
313 
314     for i in range(N_COINS):
315         if token_supply == 0:
316             assert amounts[i] > 0  # dev: initial deposit requires all coins
317         # balances store amounts of c-tokens
318         new_balances[i] = old_balances[i] + amounts[i]
319 
320     # Invariant after change
321     D1: uint256 = self.get_D_mem(new_balances, amp)
322     assert D1 > D0
323 
324     # We need to recalculate the invariant accounting for fees
325     # to calculate fair user's share
326     D2: uint256 = D1
327     fees: uint256[N_COINS] = empty(uint256[N_COINS])
328 
329     if token_supply > 0:
330         # Only account for fees if we are not the first to deposit
331         _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
332         _admin_fee: uint256 = self.admin_fee
333         for i in range(N_COINS):
334             ideal_balance: uint256 = D1 * old_balances[i] / D0
335             difference: uint256 = 0
336             if ideal_balance > new_balances[i]:
337                 difference = ideal_balance - new_balances[i]
338             else:
339                 difference = new_balances[i] - ideal_balance
340             fees[i] = _fee * difference / FEE_DENOMINATOR
341             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
342             new_balances[i] -= fees[i]
343         D2 = self.get_D_mem(new_balances, amp)
344     else:
345         self.balances = new_balances
346 
347     # Calculate, how much pool tokens to mint
348     mint_amount: uint256 = 0
349     if token_supply == 0:
350         mint_amount = D1  # Take the dust if there was any
351     else:
352         mint_amount = token_supply * (D2 - D0) / D0
353 
354     assert mint_amount >= min_mint_amount, "Slippage screwed you"
355 
356     # Take coins from the sender
357     for i in range(N_COINS):
358         if amounts[i] > 0:
359             # "safeTransferFrom" which works for ERC20s which return bool or not
360             _response: Bytes[32] = raw_call(
361                 self.coins[i],
362                 concat(
363                     method_id("transferFrom(address,address,uint256)"),
364                     convert(msg.sender, bytes32),
365                     convert(self, bytes32),
366                     convert(amounts[i], bytes32),
367                 ),
368                 max_outsize=32,
369             )  # dev: failed transfer
370             if len(_response) > 0:
371                 assert convert(_response, bool)
372 
373     # Mint pool tokens
374     CurveToken(_lp_token).mint(msg.sender, mint_amount)
375 
376     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
377 
378     return mint_amount
379 
380 
381 @view
382 @internal
383 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
384     # x in the input is converted to the same price/precision
385 
386     assert i != j       # dev: same coin
387     assert j >= 0       # dev: j below zero
388     assert j < N_COINS  # dev: j above N_COINS
389 
390     # should be unreachable, but good for safety
391     assert i >= 0
392     assert i < N_COINS
393 
394     amp: uint256 = self._A()
395     D: uint256 = self.get_D(xp_, amp)
396     Ann: uint256 = amp * N_COINS
397     c: uint256 = D
398     S_: uint256 = 0
399     _x: uint256 = 0
400     y_prev: uint256 = 0
401 
402     for _i in range(N_COINS):
403         if _i == i:
404             _x = x
405         elif _i != j:
406             _x = xp_[_i]
407         else:
408             continue
409         S_ += _x
410         c = c * D / (_x * N_COINS)
411     c = c * D * A_PRECISION / (Ann * N_COINS)
412     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
413     y: uint256 = D
414     for _i in range(255):
415         y_prev = y
416         y = (y*y + c) / (2 * y + b - D)
417         # Equality with the precision of 1
418         if y > y_prev:
419             if y - y_prev <= 1:
420                 return y
421         else:
422             if y_prev - y <= 1:
423                 return y
424     raise
425 
426 
427 @view
428 @external
429 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
430     xp: uint256[N_COINS] = self._xp()
431     rates: uint256[N_COINS] = RATES
432 
433     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
434     y: uint256 = self.get_y(i, j, x, xp)
435     dy: uint256 = (xp[j] - y - 1)
436     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
437     return (dy - _fee) * PRECISION / rates[j]
438 
439 
440 @external
441 @nonreentrant('lock')
442 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
443     """
444     @notice Perform an exchange between two coins
445     @dev Index values can be found via the `coins` public getter method
446     @param i Index value for the coin to send
447     @param j Index valie of the coin to recieve
448     @param dx Amount of `i` being exchanged
449     @param min_dy Minimum amount of `j` to receive
450     @return Actual amount of `j` received
451     """
452     assert not self.is_killed  # dev: is killed
453 
454     old_balances: uint256[N_COINS] = self.balances
455     xp: uint256[N_COINS] = self._xp_mem(old_balances)
456 
457     rates: uint256[N_COINS] = RATES
458     x: uint256 = xp[i] + dx * rates[i] / PRECISION
459     y: uint256 = self.get_y(i, j, x, xp)
460 
461     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
462     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
463 
464     # Convert all to real units
465     dy = (dy - dy_fee) * PRECISION / rates[j]
466     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
467 
468     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
469     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
470 
471     # Change balances exactly in same way as we change actual ERC20 coin amounts
472     self.balances[i] = old_balances[i] + dx
473     # When rounding errors happen, we undercharge admin fee in favor of LP
474     self.balances[j] = old_balances[j] - dy - dy_admin_fee
475 
476     # "safeTransferFrom" which works for ERC20s which return bool or not
477     _response: Bytes[32] = raw_call(
478         self.coins[i],
479         concat(
480             method_id("transferFrom(address,address,uint256)"),
481             convert(msg.sender, bytes32),
482             convert(self, bytes32),
483             convert(dx, bytes32),
484         ),
485         max_outsize=32,
486     )  # dev: failed transfer
487     if len(_response) > 0:
488         assert convert(_response, bool)
489 
490     _response = raw_call(
491         self.coins[j],
492         concat(
493             method_id("transfer(address,uint256)"),
494             convert(msg.sender, bytes32),
495             convert(dy, bytes32),
496         ),
497         max_outsize=32,
498     )  # dev: failed transfer
499     if len(_response) > 0:
500         assert convert(_response, bool)
501 
502     log TokenExchange(msg.sender, i, dx, j, dy)
503 
504     return dy
505 
506 
507 @external
508 @nonreentrant('lock')
509 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
510     """
511     @notice Withdraw coins from the pool
512     @dev Withdrawal amounts are based on current deposit ratios
513     @param _amount Quantity of LP tokens to burn in the withdrawal
514     @param min_amounts Minimum amounts of underlying coins to receive
515     @return List of amounts of coins that were withdrawn
516     """
517     _lp_token: address = self.lp_token
518     total_supply: uint256 = ERC20(_lp_token).totalSupply()
519     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
520     fees: uint256[N_COINS] = empty(uint256[N_COINS])  # Fees are unused but we've got them historically in event
521 
522     for i in range(N_COINS):
523         value: uint256 = self.balances[i] * _amount / total_supply
524         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
525         self.balances[i] -= value
526         amounts[i] = value
527         _response: Bytes[32] = raw_call(
528             self.coins[i],
529             concat(
530                 method_id("transfer(address,uint256)"),
531                 convert(msg.sender, bytes32),
532                 convert(value, bytes32),
533             ),
534             max_outsize=32,
535         )  # dev: failed transfer
536         if len(_response) > 0:
537             assert convert(_response, bool)
538 
539     CurveToken(_lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
540 
541     log RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
542 
543     return amounts
544 
545 
546 @external
547 @nonreentrant('lock')
548 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256:
549     """
550     @notice Withdraw coins from the pool in an imbalanced amount
551     @param amounts List of amounts of underlying coins to withdraw
552     @param max_burn_amount Maximum amount of LP token to burn in the withdrawal
553     @return Actual amount of the LP token burned in the withdrawal
554     """
555     assert not self.is_killed  # dev: is killed
556 
557     amp: uint256 = self._A()
558 
559     old_balances: uint256[N_COINS] = self.balances
560     new_balances: uint256[N_COINS] = old_balances
561     D0: uint256 = self.get_D_mem(old_balances, amp)
562     for i in range(N_COINS):
563         new_balances[i] -= amounts[i]
564     D1: uint256 = self.get_D_mem(new_balances, amp)
565 
566     _lp_token: address = self.lp_token
567     token_supply: uint256 = ERC20(_lp_token).totalSupply()
568     assert token_supply != 0  # dev: zero total supply
569 
570     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
571     _admin_fee: uint256 = self.admin_fee
572     fees: uint256[N_COINS] = empty(uint256[N_COINS])
573     for i in range(N_COINS):
574         ideal_balance: uint256 = D1 * old_balances[i] / D0
575         difference: uint256 = 0
576         if ideal_balance > new_balances[i]:
577             difference = ideal_balance - new_balances[i]
578         else:
579             difference = new_balances[i] - ideal_balance
580         fees[i] = _fee * difference / FEE_DENOMINATOR
581         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
582         new_balances[i] -= fees[i]
583     D2: uint256 = self.get_D_mem(new_balances, amp)
584 
585     token_amount: uint256 = (D0 - D2) * token_supply / D0
586     assert token_amount != 0  # dev: zero tokens burned
587     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
588     assert token_amount <= max_burn_amount, "Slippage screwed you"
589 
590     CurveToken(_lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
591     for i in range(N_COINS):
592         if amounts[i] != 0:
593             _response: Bytes[32] = raw_call(
594                 self.coins[i],
595                 concat(
596                     method_id("transfer(address,uint256)"),
597                     convert(msg.sender, bytes32),
598                     convert(amounts[i], bytes32),
599                 ),
600                 max_outsize=32,
601             )  # dev: failed transfer
602             if len(_response) > 0:
603                 assert convert(_response, bool)
604 
605 
606     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
607 
608     return token_amount
609 
610 
611 @view
612 @internal
613 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
614     """
615     Calculate x[i] if one reduces D from being calculated for xp to D
616 
617     Done by solving quadratic equation iteratively.
618     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
619     x_1**2 + b*x_1 = c
620 
621     x_1 = (x_1**2 + c) / (2*x_1 + b)
622     """
623     # x in the input is converted to the same price/precision
624 
625     assert i >= 0  # dev: i below zero
626     assert i < N_COINS  # dev: i above N_COINS
627 
628     Ann: uint256 = A_ * N_COINS
629     c: uint256 = D
630     S_: uint256 = 0
631     _x: uint256 = 0
632     y_prev: uint256 = 0
633 
634     for _i in range(N_COINS):
635         if _i != i:
636             _x = xp[_i]
637         else:
638             continue
639         S_ += _x
640         c = c * D / (_x * N_COINS)
641     c = c * D * A_PRECISION / (Ann * N_COINS)
642     b: uint256 = S_ + D * A_PRECISION / Ann
643 
644     y: uint256 = D
645     for _i in range(255):
646         y_prev = y
647         y = (y*y + c) / (2 * y + b - D)
648         # Equality with the precision of 1
649         if y > y_prev:
650             if y - y_prev <= 1:
651                 return y
652         else:
653             if y_prev - y <= 1:
654                 return y
655     raise
656 
657 
658 @view
659 @internal
660 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256, uint256):
661     # First, need to calculate
662     # * Get current D
663     # * Solve Eqn against y_i for D - _token_amount
664     amp: uint256 = self._A()
665     xp: uint256[N_COINS] = self._xp()
666     D0: uint256 = self.get_D(xp, amp)
667 
668     total_supply: uint256 = ERC20(self.lp_token).totalSupply()
669     D1: uint256 = D0 - _token_amount * D0 / total_supply
670     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
671     xp_reduced: uint256[N_COINS] = xp
672 
673     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
674     for j in range(N_COINS):
675         dx_expected: uint256 = 0
676         if j == i:
677             dx_expected = xp[j] * D1 / D0 - new_y
678         else:
679             dx_expected = xp[j] - xp[j] * D1 / D0
680         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
681 
682 
683     # copied from stableswap steth.vy
684     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
685 
686     dy -= 1  # Withdraw less to account for rounding errors
687     dy_0: uint256 = xp[i] - new_y  # w/o fees
688 
689     # dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
690     # precisions: uint256[N_COINS] = PRECISION_MUL
691     # dy = (dy - 1) / precisions[i]  # Withdraw less to account for rounding errors
692     # dy_0: uint256 = (xp[i] - new_y) / precisions[i]  # w/o fees
693 
694     return dy, dy_0 - dy, total_supply
695 
696 
697 @view
698 @external
699 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
700     """
701     @notice Calculate the amount received when withdrawing a single coin
702     @param _token_amount Amount of LP tokens to burn in the withdrawal
703     @param i Index value of the coin to withdraw
704     @return Amount of coin received
705     """
706     return self._calc_withdraw_one_coin(_token_amount, i)[0]
707 
708 
709 @external
710 @nonreentrant('lock')
711 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
712     """
713     @notice Withdraw a single coin from the pool
714     @param _token_amount Amount of LP tokens to burn in the withdrawal
715     @param i Index value of the coin to withdraw
716     @param _min_amount Minimum amount of coin to receive
717     @return Amount of coin received
718     """
719     assert not self.is_killed  # dev: is killed
720 
721     dy: uint256 = 0
722     dy_fee: uint256 = 0
723     total_supply: uint256 = 0
724     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_token_amount, i)
725     assert dy >= _min_amount, "Not enough coins removed"
726 
727     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
728     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
729 
730 
731     _response: Bytes[32] = raw_call(
732         self.coins[i],
733         concat(
734             method_id("transfer(address,uint256)"),
735             convert(msg.sender, bytes32),
736             convert(dy, bytes32),
737         ),
738         max_outsize=32,
739     )  # dev: failed transfer
740     if len(_response) > 0:
741         assert convert(_response, bool)
742 
743     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
744 
745     return dy
746 
747 
748 ### Admin functions ###
749 @external
750 def ramp_A(_future_A: uint256, _future_time: uint256):
751     assert msg.sender == self.owner  # dev: only owner
752     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
753     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
754 
755     _initial_A: uint256 = self._A()
756     _future_A_p: uint256 = _future_A * A_PRECISION
757 
758     assert _future_A > 0 and _future_A < MAX_A
759     if _future_A_p < _initial_A:
760         assert _future_A_p * MAX_A_CHANGE >= _initial_A
761     else:
762         assert _future_A_p <= _initial_A * MAX_A_CHANGE
763 
764     self.initial_A = _initial_A
765     self.future_A = _future_A_p
766     self.initial_A_time = block.timestamp
767     self.future_A_time = _future_time
768 
769     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
770 
771 
772 @external
773 def stop_ramp_A():
774     assert msg.sender == self.owner  # dev: only owner
775 
776     current_A: uint256 = self._A()
777     self.initial_A = current_A
778     self.future_A = current_A
779     self.initial_A_time = block.timestamp
780     self.future_A_time = block.timestamp
781     # now (block.timestamp < t1) is always False, so we return saved A
782 
783     log StopRampA(current_A, block.timestamp)
784 
785 
786 @external
787 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
788     assert msg.sender == self.owner  # dev: only owner
789     assert self.admin_actions_deadline == 0  # dev: active action
790     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
791     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
792 
793     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
794     self.admin_actions_deadline = _deadline
795     self.future_fee = new_fee
796     self.future_admin_fee = new_admin_fee
797 
798     log CommitNewFee(_deadline, new_fee, new_admin_fee)
799 
800 
801 @external
802 def apply_new_fee():
803     assert msg.sender == self.owner  # dev: only owner
804     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
805     assert self.admin_actions_deadline != 0  # dev: no active action
806 
807     self.admin_actions_deadline = 0
808     _fee: uint256 = self.future_fee
809     _admin_fee: uint256 = self.future_admin_fee
810     self.fee = _fee
811     self.admin_fee = _admin_fee
812 
813     log NewFee(_fee, _admin_fee)
814 
815 
816 @external
817 def revert_new_parameters():
818     assert msg.sender == self.owner  # dev: only owner
819 
820     self.admin_actions_deadline = 0
821 
822 
823 @external
824 def commit_transfer_ownership(_owner: address):
825     assert msg.sender == self.owner  # dev: only owner
826     assert self.transfer_ownership_deadline == 0  # dev: active transfer
827 
828     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
829     self.transfer_ownership_deadline = _deadline
830     self.future_owner = _owner
831 
832     log CommitNewAdmin(_deadline, _owner)
833 
834 
835 @external
836 def apply_transfer_ownership():
837     assert msg.sender == self.owner  # dev: only owner
838     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
839     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
840 
841     self.transfer_ownership_deadline = 0
842     _owner: address = self.future_owner
843     self.owner = _owner
844 
845     log NewAdmin(_owner)
846 
847 
848 @external
849 def revert_transfer_ownership():
850     assert msg.sender == self.owner  # dev: only owner
851 
852     self.transfer_ownership_deadline = 0
853 
854 
855 @view
856 @external
857 def admin_balances(i: uint256) -> uint256:
858     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
859 
860 
861 @external
862 def withdraw_admin_fees():
863     assert msg.sender == self.owner  # dev: only owner
864 
865     for i in range(N_COINS):
866         coin: address = self.coins[i]
867         value: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
868         if value > 0:
869             _response: Bytes[32] = raw_call(
870                 coin,
871                 concat(
872                     method_id("transfer(address,uint256)"),
873                     convert(msg.sender, bytes32),
874                     convert(value, bytes32),
875                 ),
876                 max_outsize=32,
877             )  # dev: failed transfer
878             if len(_response) > 0:
879                 assert convert(_response, bool)
880 
881 
882 
883 @external
884 def donate_admin_fees():
885     assert msg.sender == self.owner  # dev: only owner
886     for i in range(N_COINS):
887         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
888 
889 
890 @external
891 def kill_me():
892     assert msg.sender == self.owner  # dev: only owner
893     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
894     self.is_killed = True
895 
896 
897 @external
898 def unkill_me():
899     assert msg.sender == self.owner  # dev: only owner
900     self.is_killed = False