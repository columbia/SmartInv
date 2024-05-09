1 # @version 0.2.12
2 """
3 @title LSDx ETH/stETH/frxETH/rETH StableSwap
4 """
5 
6 from vyper.interfaces import ERC20
7 
8 interface rETH:
9     def getExchangeRate() -> uint256: view
10 
11 interface CurveToken:
12     def mint(_to: address, _value: uint256) -> bool: nonpayable
13     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
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
76 N_COINS: constant(int128) = 4
77 
78 # fixed constants
79 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
80 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
81 
82 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
83 MAX_FEE: constant(uint256) = 5 * 10 ** 9
84 
85 MAX_A: constant(uint256) = 10 ** 6
86 MAX_A_CHANGE: constant(uint256) = 10
87 A_PRECISION: constant(uint256) = 100
88 
89 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
90 MIN_RAMP_TIME: constant(uint256) = 86400
91 
92 coins: public(address[N_COINS])
93 admin_balances: public(uint256[N_COINS])
94 
95 fee: public(uint256)  # fee * 1e10
96 admin_fee: public(uint256)  # admin_fee * 1e10
97 
98 owner: public(address)
99 lp_token: public(address)
100 
101 initial_A: public(uint256)
102 future_A: public(uint256)
103 initial_A_time: public(uint256)
104 future_A_time: public(uint256)
105 
106 admin_actions_deadline: public(uint256)
107 transfer_ownership_deadline: public(uint256)
108 future_fee: public(uint256)
109 future_admin_fee: public(uint256)
110 future_owner: public(address)
111 
112 is_killed: bool
113 kill_deadline: uint256
114 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
115 
116 
117 @external
118 def __init__(
119     _owner: address,
120     _coins: address[N_COINS],
121     _pool_token: address,
122     _A: uint256,
123     _fee: uint256,
124     _admin_fee: uint256
125 ):
126     """
127     @notice Contract constructor
128     @param _owner Contract owner address
129     @param _coins Addresses of ERC20 contracts of coins. Should be in exact order: ETH/stETH/frxETH/rETH
130     @param _pool_token Address of the token representing LP share
131     @param _A Amplification coefficient multiplied by n * (n - 1)
132     @param _fee Fee to charge for exchanges
133     @param _admin_fee Admin fee
134     """
135     for i in range(N_COINS):
136         if i == 0:
137             assert _coins[i] == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
138         else:
139             assert _coins[i] != ZERO_ADDRESS
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
153     t1: uint256 = self.future_A_time
154     A1: uint256 = self.future_A
155 
156     if block.timestamp < t1:
157         # handle ramping up and down of A
158         A0: uint256 = self.initial_A
159         t0: uint256 = self.initial_A_time
160         # Expressions in uint256 cannot have negative numbers, thus "if"
161         if A1 > A0:
162             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
163         else:
164             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
165 
166     else:  # when t1 == 0 or block.timestamp >= t1
167         return A1
168 
169 
170 @view
171 @external
172 def A() -> uint256:
173     return self._A() / A_PRECISION
174 
175 
176 @view
177 @external
178 def A_precise() -> uint256:
179     return self._A()
180 
181 
182 @view
183 @internal
184 def _stored_rates() -> uint256[N_COINS]:
185     return [
186         convert(PRECISION, uint256),
187         convert(PRECISION, uint256),
188         convert(PRECISION, uint256),
189         rETH(self.coins[3]).getExchangeRate()
190     ]
191 
192 
193 @view
194 @internal
195 def _balances(_value: uint256 = 0) -> uint256[N_COINS]:
196     result: uint256[N_COINS] = empty(uint256[N_COINS])
197     for i in range(N_COINS):
198         if i == 0:
199             result[i] = self.balance - self.admin_balances[i] - _value
200         else:
201             result[i] = ERC20(self.coins[i]).balanceOf(self) - self.admin_balances[i]
202     return result
203 
204 
205 @view
206 @external
207 def balances(i: uint256) -> uint256:
208     """
209     @notice Get the current balance of a coin within the
210             pool, less the accrued admin fees
211     @param i Index value for the coin to query balance of
212     @return Token balance
213     """
214     return self._balances()[i]
215 
216 @view
217 @internal
218 def _xp(rates: uint256[N_COINS], _value: uint256 = 0) -> uint256[N_COINS]:
219     result: uint256[N_COINS] = rates
220     balances: uint256[N_COINS] = self._balances(_value)
221     for i in range(N_COINS):
222         result[i] = result[i] * balances[i] / PRECISION
223     return result
224 
225 
226 @pure
227 @internal
228 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
229     """
230     D invariant calculation in non-overflowing integer operations
231     iteratively
232 
233     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
234 
235     Converging solution:
236     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
237     """
238     S: uint256 = 0
239     Dprev: uint256 = 0
240 
241     for _x in xp:
242         S += _x
243     if S == 0:
244         return 0
245 
246     D: uint256 = S
247     Ann: uint256 = amp * N_COINS
248     for _i in range(255):
249         D_P: uint256 = D
250         for _x in xp:
251             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
252         Dprev = D
253         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
254         # Equality with the precision of 1
255         if D > Dprev:
256             if D - Dprev <= 1:
257                 return D
258         else:
259             if Dprev - D <= 1:
260                 return D
261     # convergence typically occurs in 4 rounds or less, this should be unreachable!
262     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
263     raise
264 
265 
266 @view
267 @internal
268 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS], amp: uint256) -> uint256:
269     result: uint256[N_COINS] = rates
270     for i in range(N_COINS):
271         result[i] = result[i] * _balances[i] / PRECISION
272     return self.get_D(result, amp)
273 
274 
275 @view
276 @external
277 def get_virtual_price() -> uint256:
278     """
279     @notice The current virtual price of the pool LP token
280     @dev Useful for calculating profits
281     @return LP token virtual price normalized to 1e18
282     """
283     D: uint256 = self.get_D(self._xp(self._stored_rates()), self._A())
284     # D is in the units similar to DAI (e.g. converted to precision 1e18)
285     # When balanced, D = n * x_u - total virtual value of the portfolio
286     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
287     return D * PRECISION / token_supply
288 
289 
290 @view
291 @external
292 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
293     """
294     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
295     @dev This calculation accounts for slippage, but not fees.
296          Needed to prevent front-running, not for precise calculations!
297     @param amounts Amount of each coin being deposited
298     @param is_deposit set True for deposits, False for withdrawals
299     @return Expected amount of LP tokens received
300     """
301     amp: uint256 = self._A()
302     balances: uint256[N_COINS] = self._balances()
303     rates: uint256[N_COINS] = self._stored_rates()
304     D0: uint256 = self.get_D_mem(rates, balances, amp)
305     for i in range(N_COINS):
306         if is_deposit:
307             balances[i] += amounts[i]
308         else:
309             balances[i] -= amounts[i]
310     D1: uint256 = self.get_D_mem(rates, balances, amp)
311     token_amount: uint256 = ERC20(self.lp_token).totalSupply()
312     diff: uint256 = 0
313     if is_deposit:
314         diff = D1 - D0
315     else:
316         diff = D0 - D1
317     return diff * token_amount / D0
318 
319 
320 @payable
321 @external
322 @nonreentrant('lock')
323 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
324     """
325     @notice Deposit coins into the pool
326     @param amounts List of amounts of coins to deposit
327     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
328     @return Amount of LP tokens received by depositing
329     """
330     assert not self.is_killed  # dev: is killed
331 
332     # Initial invariant
333     amp: uint256 = self._A()
334     rates: uint256[N_COINS] = self._stored_rates()
335     lp_token: address = self.lp_token
336     token_supply: uint256 = ERC20(lp_token).totalSupply()
337     D0: uint256 = 0
338     old_balances: uint256[N_COINS] = self._balances(msg.value)
339     if token_supply != 0:
340         D0 = self.get_D_mem(rates, old_balances, amp)
341 
342     new_balances: uint256[N_COINS] = old_balances
343     for i in range(N_COINS):
344         if token_supply == 0:
345             assert amounts[i] > 0  # dev: initial deposit requires all coins
346         new_balances[i] += amounts[i]
347 
348     # Invariant after change
349     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
350     assert D1 > D0
351 
352     # We need to recalculate the invariant accounting for fees
353     # to calculate fair user's share
354     fees: uint256[N_COINS] = empty(uint256[N_COINS])
355     mint_amount: uint256 = 0
356     D2: uint256 = 0
357     if token_supply > 0:
358         # Only account for fees if we are not the first to deposit
359         fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
360         admin_fee: uint256 = self.admin_fee
361         for i in range(N_COINS):
362             ideal_balance: uint256 = D1 * old_balances[i] / D0
363             difference: uint256 = 0
364             if ideal_balance > new_balances[i]:
365                 difference = ideal_balance - new_balances[i]
366             else:
367                 difference = new_balances[i] - ideal_balance
368             fees[i] = fee * difference / FEE_DENOMINATOR
369             if admin_fee != 0:
370                 self.admin_balances[i] += fees[i] * admin_fee / FEE_DENOMINATOR
371             new_balances[i] -= fees[i]
372         D2 = self.get_D_mem(rates, new_balances, amp)
373         mint_amount = token_supply * (D2 - D0) / D0
374     else:
375         mint_amount = D1  # Take the dust if there was any
376 
377     assert mint_amount >= min_mint_amount, "Slippage screwed you"
378 
379     # Take coins from the sender
380     for i in range(N_COINS):
381         if self.coins[i] == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
382             assert msg.value == amounts[i]
383         elif amounts[i] > 0:
384             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i])
385 
386     # Mint pool tokens
387     CurveToken(lp_token).mint(msg.sender, mint_amount)
388 
389     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
390 
391     return mint_amount
392 
393 
394 @view
395 @internal
396 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
397     """
398     Calculate x[j] if one makes x[i] = x
399 
400     Done by solving quadratic equation iteratively.
401     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
402     x_1**2 + b*x_1 = c
403 
404     x_1 = (x_1**2 + c) / (2*x_1 + b)
405     """
406     # x in the input is converted to the same price/precision
407 
408     assert i != j       # dev: same coin
409     assert j >= 0       # dev: j below zero
410     assert j < N_COINS  # dev: j above N_COINS
411 
412     # should be unreachable, but good for safety
413     assert i >= 0
414     assert i < N_COINS
415 
416     amp: uint256 = self._A()
417     D: uint256 = self.get_D(xp, amp)
418     Ann: uint256 = amp * N_COINS
419     c: uint256 = D
420     S_: uint256 = 0
421     _x: uint256 = 0
422     y_prev: uint256 = 0
423 
424     for _i in range(N_COINS):
425         if _i == i:
426             _x = x
427         elif _i != j:
428             _x = xp[_i]
429         else:
430             continue
431         S_ += _x
432         c = c * D / (_x * N_COINS)
433     c = c * D * A_PRECISION / (Ann * N_COINS)
434     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
435     y: uint256 = D
436     for _i in range(255):
437         y_prev = y
438         y = (y*y + c) / (2 * y + b - D)
439         # Equality with the precision of 1
440         if y > y_prev:
441             if y - y_prev <= 1:
442                 return y
443         else:
444             if y_prev - y <= 1:
445                 return y
446     raise
447 
448 
449 @view
450 @external
451 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
452     # dx and dy in c-units
453     rates: uint256[N_COINS] = self._stored_rates()
454     xp: uint256[N_COINS] = self._xp(rates)
455 
456     x: uint256 = xp[i] + dx * rates[i] / PRECISION
457     y: uint256 = self.get_y(i, j, x, xp)
458     dy: uint256 = xp[j] - y
459     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
460     return (dy - fee) * PRECISION / rates[j]
461 
462 
463 @view
464 @external
465 def get_dx(i: int128, j: int128, dy: uint256) -> uint256:
466     # dx and dy in c-units
467     rates: uint256[N_COINS] = self._stored_rates()
468     xp: uint256[N_COINS] = self._xp(rates)
469 
470     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * rates[j] / PRECISION
471     x: uint256 = self.get_y(j, i, y, xp)
472     dx: uint256 = (x - xp[i]) * PRECISION / rates[i]
473     return dx
474 
475 
476 @payable
477 @external
478 @nonreentrant('lock')
479 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
480     """
481     @notice Perform an exchange between two coins
482     @dev Index values can be found via the `coins` public getter method
483     @param i Index value for the coin to send
484     @param j Index valie of the coin to recieve
485     @param dx Amount of `i` being exchanged
486     @param min_dy Minimum amount of `j` to receive
487     @return Actual amount of `j` received
488     """
489     assert not self.is_killed  # dev: is killed
490 
491     rates: uint256[N_COINS] = self._stored_rates()
492 
493     xp: uint256[N_COINS] = self._xp(rates, msg.value)
494     x: uint256 = xp[i] + dx * rates[i] / PRECISION
495     y: uint256 = self.get_y(i, j, x, xp)
496     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
497     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
498     dy = (dy - dy_fee) * PRECISION / rates[j]
499     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
500 
501     admin_fee: uint256 = self.admin_fee
502     if admin_fee != 0:
503         dy_admin_fee: uint256 = dy_fee * admin_fee / FEE_DENOMINATOR
504         if dy_admin_fee != 0:
505             self.admin_balances[j] += dy_admin_fee
506 
507     in_coin: address = self.coins[i]
508     if in_coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
509         assert msg.value == dx
510     else:
511         assert msg.value == 0
512         assert ERC20(in_coin).transferFrom(msg.sender, self, dx)
513 
514     out_coin: address = self.coins[j] 
515     if out_coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
516         raw_call(msg.sender, b"", value=dy)
517     else:
518         assert ERC20(out_coin).transfer(msg.sender, dy)
519 
520     log TokenExchange(msg.sender, i, dx, j, dy)
521 
522     return dy
523 
524 
525 @external
526 @nonreentrant('lock')
527 def remove_liquidity(
528     _amount: uint256,
529     _min_amounts: uint256[N_COINS],
530 ) -> uint256[N_COINS]:
531     """
532     @notice Withdraw coins from the pool
533     @dev Withdrawal amounts are based on current deposit ratios
534     @param _amount Quantity of LP tokens to burn in the withdrawal
535     @param _min_amounts Minimum amounts of underlying coins to receive
536     @return List of amounts of coins that were withdrawn
537     """
538     amounts: uint256[N_COINS] = self._balances()
539     lp_token: address = self.lp_token
540     total_supply: uint256 = ERC20(lp_token).totalSupply()
541     CurveToken(lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
542 
543     for i in range(N_COINS):
544         value: uint256 = amounts[i] * _amount / total_supply
545         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
546 
547         amounts[i] = value
548         if i == 0:
549             raw_call(msg.sender, b"", value=value)
550         else:
551             assert ERC20(self.coins[i]).transfer(msg.sender, value)
552 
553     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply - _amount)
554 
555     return amounts
556 
557 
558 @external
559 @nonreentrant('lock')
560 def remove_liquidity_imbalance(
561     _amounts: uint256[N_COINS],
562     _max_burn_amount: uint256
563 ) -> uint256:
564     """
565     @notice Withdraw coins from the pool in an imbalanced amount
566     @param _amounts List of amounts of underlying coins to withdraw
567     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
568     @return Actual amount of the LP token burned in the withdrawal
569     """
570     assert not self.is_killed  # dev: is killed
571 
572     amp: uint256 = self._A()
573     rates: uint256[N_COINS] = self._stored_rates()
574     old_balances: uint256[N_COINS] = self._balances()
575     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
576 
577     new_balances: uint256[N_COINS] = old_balances
578     for i in range(N_COINS):
579         new_balances[i] -= _amounts[i]
580     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
581 
582     fees: uint256[N_COINS] = empty(uint256[N_COINS])
583     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
584     admin_fee: uint256 = self.admin_fee
585     for i in range(N_COINS):
586         ideal_balance: uint256 = D1 * old_balances[i] / D0
587         new_balance: uint256 = new_balances[i]
588         difference: uint256 = 0
589         if ideal_balance > new_balance:
590             difference = ideal_balance - new_balance
591         else:
592             difference = new_balance - ideal_balance
593         fees[i] = fee * difference / FEE_DENOMINATOR
594         if admin_fee != 0:
595             self.admin_balances[i] += fees[i] * admin_fee / FEE_DENOMINATOR
596         new_balances[i] -= fees[i]
597     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
598 
599     lp_token: address = self.lp_token
600     token_supply: uint256 = ERC20(lp_token).totalSupply()
601     token_amount: uint256 = (D0 - D2) * token_supply / D0
602 
603     assert token_amount != 0  # dev: zero tokens burned
604     assert token_amount <= _max_burn_amount, "Slippage screwed you"
605 
606     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
607 
608     for i in range(N_COINS):
609         amount: uint256 = _amounts[i]
610         if amount != 0:
611             coin: address = self.coins[i]
612             if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
613                 raw_call(msg.sender, b"", value=amount)
614             else:
615                 assert ERC20(self.coins[i]).transfer(msg.sender, _amounts[i])
616 
617     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, token_supply - token_amount)
618 
619     return token_amount
620 
621 
622 @pure
623 @internal
624 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
625     """
626     Calculate x[i] if one reduces D from being calculated for xp to D
627 
628     Done by solving quadratic equation iteratively.
629     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
630     x_1**2 + b*x_1 = c
631 
632     x_1 = (x_1**2 + c) / (2*x_1 + b)
633     """
634     # x in the input is converted to the same price/precision
635 
636     assert i >= 0       # dev: i below zero
637     assert i < N_COINS  # dev: i above N_COINS
638 
639     Ann: uint256 = A_ * N_COINS
640     c: uint256 = D
641     S_: uint256 = 0
642     _x: uint256 = 0
643     y_prev: uint256 = 0
644 
645     for _i in range(N_COINS):
646         if _i != i:
647             _x = xp[_i]
648         else:
649             continue
650         S_ += _x
651         c = c * D / (_x * N_COINS)
652     c = c * D * A_PRECISION / (Ann * N_COINS)
653     b: uint256 = S_ + D * A_PRECISION / Ann
654     y: uint256 = D
655 
656     for _i in range(255):
657         y_prev = y
658         y = (y*y + c) / (2 * y + b - D)
659         # Equality with the precision of 1
660         if y > y_prev:
661             if y - y_prev <= 1:
662                 return y
663         else:
664             if y_prev - y <= 1:
665                 return y
666     raise
667 
668 
669 @view
670 @internal
671 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256):
672     # First, need to calculate
673     # * Get current D
674     # * Solve Eqn against y_i for D - _token_amount
675     amp: uint256 = self._A()
676     rates: uint256[N_COINS] = self._stored_rates()
677     xp: uint256[N_COINS] = self._xp(rates)
678     D0: uint256 = self.get_D(xp, amp)
679     total_supply: uint256 = ERC20(self.lp_token).totalSupply()
680     D1: uint256 = D0 - _token_amount * D0 / total_supply
681     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
682 
683     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
684     xp_reduced: uint256[N_COINS] = xp
685     for j in range(N_COINS):
686         dx_expected: uint256 = 0
687         if j == i:
688             dx_expected = xp[j] * D1 / D0 - new_y
689         else:
690             dx_expected = xp[j] - xp[j] * D1 / D0
691         xp_reduced[j] -= fee * dx_expected / FEE_DENOMINATOR
692 
693     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
694     rate: uint256 = rates[i]
695     dy = (dy - 1) * PRECISION / rate  # Withdraw less to account for rounding errors
696     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rate   # w/o fees
697 
698     return dy, dy_0 - dy
699 
700 
701 @view
702 @external
703 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
704     """
705     @notice Calculate the amount received when withdrawing a single coin
706     @dev Result is the same for underlying or wrapped asset withdrawals
707     @param _token_amount Amount of LP tokens to burn in the withdrawal
708     @param i Index value of the coin to withdraw
709     @return Amount of coin received
710     """
711     return self._calc_withdraw_one_coin(_token_amount, i)[0]
712 
713 
714 @external
715 @nonreentrant('lock')
716 def remove_liquidity_one_coin(
717     _token_amount: uint256,
718     i: int128,
719     _min_amount: uint256
720 ) -> uint256:
721     """
722     @notice Withdraw a single coin from the pool
723     @param _token_amount Amount of LP tokens to burn in the withdrawal
724     @param i Index value of the coin to withdraw
725     @param _min_amount Minimum amount of coin to receive
726     @return Amount of coin received
727     """
728     assert not self.is_killed  # dev: is killed
729 
730     dy: uint256 = 0
731     dy_fee: uint256 = 0
732     dy, dy_fee = self._calc_withdraw_one_coin(_token_amount, i)
733 
734     assert dy >= _min_amount, "Not enough coins removed"
735 
736     self.admin_balances[i] += dy_fee * self.admin_fee / FEE_DENOMINATOR
737 
738     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
739 
740     coin: address = self.coins[i]
741     if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
742         raw_call(msg.sender, b"", value=dy)
743     else:
744         assert ERC20(self.coins[i]).transfer(msg.sender, dy)
745 
746     log RemoveLiquidityOne(msg.sender, _token_amount, dy)
747 
748     return dy
749 
750 
751 ### Admin functions ###
752 
753 @external
754 def ramp_A(_future_A: uint256, _future_time: uint256):
755     assert msg.sender == self.owner  # dev: only owner
756     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
757     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
758 
759     _initial_A: uint256 = self._A()
760     _future_A_p: uint256 = _future_A * A_PRECISION
761 
762     assert _future_A > 0 and _future_A < MAX_A
763     if _future_A_p < _initial_A:
764         assert _future_A_p * MAX_A_CHANGE >= _initial_A
765     else:
766         assert _future_A_p <= _initial_A * MAX_A_CHANGE
767 
768     self.initial_A = _initial_A
769     self.future_A = _future_A_p
770     self.initial_A_time = block.timestamp
771     self.future_A_time = _future_time
772 
773     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
774 
775 
776 @external
777 def stop_ramp_A():
778     assert msg.sender == self.owner  # dev: only owner
779 
780     current_A: uint256 = self._A()
781     self.initial_A = current_A
782     self.future_A = current_A
783     self.initial_A_time = block.timestamp
784     self.future_A_time = block.timestamp
785     # now (block.timestamp < t1) is always False, so we return saved A
786 
787     log StopRampA(current_A, block.timestamp)
788 
789 
790 @external
791 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
792     assert msg.sender == self.owner  # dev: only owner
793     assert self.admin_actions_deadline == 0  # dev: active action
794     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
795     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
796 
797     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
798     self.admin_actions_deadline = _deadline
799     self.future_fee = new_fee
800     self.future_admin_fee = new_admin_fee
801 
802     log CommitNewFee(_deadline, new_fee, new_admin_fee)
803 
804 
805 @external
806 @nonreentrant('lock')
807 def apply_new_fee():
808     assert msg.sender == self.owner  # dev: only owner
809     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
810     assert self.admin_actions_deadline != 0  # dev: no active action
811 
812     self.admin_actions_deadline = 0
813     _fee: uint256 = self.future_fee
814     _admin_fee: uint256 = self.future_admin_fee
815     self.fee = _fee
816     self.admin_fee = _admin_fee
817 
818     log NewFee(_fee, _admin_fee)
819 
820 
821 @external
822 def revert_new_parameters():
823     assert msg.sender == self.owner  # dev: only owner
824 
825     self.admin_actions_deadline = 0
826 
827 
828 @external
829 def commit_transfer_ownership(_owner: address):
830     assert msg.sender == self.owner  # dev: only owner
831     assert self.transfer_ownership_deadline == 0  # dev: active transfer
832 
833     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
834     self.transfer_ownership_deadline = _deadline
835     self.future_owner = _owner
836 
837     log CommitNewAdmin(_deadline, _owner)
838 
839 
840 @external
841 @nonreentrant('lock')
842 def apply_transfer_ownership():
843     assert msg.sender == self.owner  # dev: only owner
844     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
845     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
846 
847     self.transfer_ownership_deadline = 0
848     _owner: address = self.future_owner
849     self.owner = _owner
850 
851     log NewAdmin(_owner)
852 
853 
854 @external
855 def revert_transfer_ownership():
856     assert msg.sender == self.owner  # dev: only owner
857 
858     self.transfer_ownership_deadline = 0
859 
860 
861 @external
862 @nonreentrant('lock')
863 def withdraw_admin_fees():
864     assert msg.sender == self.owner  # dev: only owner
865 
866     for i in range(N_COINS):
867         amount: uint256 = self.admin_balances[i]
868         if amount != 0:
869             if self.coins[i] == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
870                 raw_call(msg.sender, b"", value=amount)
871             else:
872                 assert ERC20(self.coins[i]).transfer(msg.sender, amount)
873 
874     self.admin_balances = empty(uint256[N_COINS])
875 
876 
877 @external
878 @nonreentrant('lock')
879 def donate_admin_fees():
880     """
881     Just in case admin balances somehow become higher than total (rounding error?)
882     this can be used to fix the state, too
883     """
884     assert msg.sender == self.owner  # dev: only owner
885     self.admin_balances = empty(uint256[N_COINS])
886 
887 
888 @external
889 def kill_me():
890     assert msg.sender == self.owner  # dev: only owner
891     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
892     self.is_killed = True
893 
894 
895 @external
896 def unkill_me():
897     assert msg.sender == self.owner  # dev: only owner
898     self.is_killed = False