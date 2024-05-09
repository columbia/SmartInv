1 # @version 0.2.8
2 """
3 @title Curve aPool
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
89 # These constants must be set prior to compiling
90 N_COINS: constant(int128) = 3
91 PRECISION_MUL: constant(uint256[N_COINS]) = [1, 1000000000000, 1000000000000]
92 
93 # fixed constants
94 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
95 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
96 
97 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
98 MAX_FEE: constant(uint256) = 5 * 10 ** 9
99 
100 MAX_A: constant(uint256) = 10 ** 6
101 MAX_A_CHANGE: constant(uint256) = 10
102 A_PRECISION: constant(uint256) = 100
103 
104 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
105 MIN_RAMP_TIME: constant(uint256) = 86400
106 
107 coins: public(address[N_COINS])
108 underlying_coins: public(address[N_COINS])
109 admin_balances: public(uint256[N_COINS])
110 
111 fee: public(uint256)  # fee * 1e10
112 offpeg_fee_multiplier: public(uint256)  # * 1e10
113 admin_fee: public(uint256)  # admin_fee * 1e10
114 
115 owner: public(address)
116 lp_token: public(address)
117 
118 aave_lending_pool: address
119 aave_referral: uint256
120 
121 initial_A: public(uint256)
122 future_A: public(uint256)
123 initial_A_time: public(uint256)
124 future_A_time: public(uint256)
125 
126 admin_actions_deadline: public(uint256)
127 transfer_ownership_deadline: public(uint256)
128 future_fee: public(uint256)
129 future_admin_fee: public(uint256)
130 future_offpeg_fee_multiplier: public(uint256)  # * 1e10
131 future_owner: public(address)
132 
133 is_killed: bool
134 kill_deadline: uint256
135 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
136 
137 
138 @external
139 def __init__(
140     _coins: address[N_COINS],
141     _underlying_coins: address[N_COINS],
142     _pool_token: address,
143     _aave_lending_pool: address,
144     _A: uint256,
145     _fee: uint256,
146     _admin_fee: uint256,
147     _offpeg_fee_multiplier: uint256,
148 ):
149     """
150     @notice Contract constructor
151     @param _coins List of wrapped coin addresses
152     @param _underlying_coins List of underlying coin addresses
153     @param _pool_token Pool LP token address
154     @param _aave_lending_pool Aave lending pool address
155     @param _A Amplification coefficient multiplied by n * (n - 1)
156     @param _fee Swap fee expressed as an integer with 1e10 precision
157     @param _admin_fee Percentage of fee taken as an admin fee,
158                       expressed as an integer with 1e10 precision
159     @param _offpeg_fee_multiplier Offpeg fee multiplier
160     """
161     for i in range(N_COINS):
162         assert _coins[i] != ZERO_ADDRESS
163         assert _underlying_coins[i] != ZERO_ADDRESS
164 
165     self.coins = _coins
166     self.underlying_coins = _underlying_coins
167     self.initial_A = _A * A_PRECISION
168     self.future_A = _A * A_PRECISION
169     self.fee = _fee
170     self.admin_fee = _admin_fee
171     self.offpeg_fee_multiplier = _offpeg_fee_multiplier
172     self.owner = msg.sender
173     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
174     self.lp_token = _pool_token
175     self.aave_lending_pool = _aave_lending_pool
176 
177     # approve transfer of underlying coin to aave lending pool
178     for coin in _underlying_coins:
179         _response: Bytes[32] = raw_call(
180             coin,
181             concat(
182                 method_id("approve(address,uint256)"),
183                 convert(_aave_lending_pool, bytes32),
184                 convert(MAX_UINT256, bytes32)
185             ),
186             max_outsize=32
187         )
188         if len(_response) != 0:
189             assert convert(_response, bool)
190 
191 
192 
193 @view
194 @internal
195 def _A() -> uint256:
196     t1: uint256 = self.future_A_time
197     A1: uint256 = self.future_A
198 
199     if block.timestamp < t1:
200         # handle ramping up and down of A
201         A0: uint256 = self.initial_A
202         t0: uint256 = self.initial_A_time
203         # Expressions in uint256 cannot have negative numbers, thus "if"
204         if A1 > A0:
205             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
206         else:
207             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
208 
209     else:  # when t1 == 0 or block.timestamp >= t1
210         return A1
211 
212 
213 @view
214 @external
215 def A() -> uint256:
216     return self._A() / A_PRECISION
217 
218 
219 @view
220 @external
221 def A_precise() -> uint256:
222     return self._A()
223 
224 
225 @pure
226 @internal
227 def _dynamic_fee(xpi: uint256, xpj: uint256, _fee: uint256, _feemul: uint256) -> uint256:
228     if _feemul <= FEE_DENOMINATOR:
229         return _fee
230     else:
231         xps2: uint256 = (xpi + xpj)
232         xps2 *= xps2  # Doing just ** 2 can overflow apparently
233         return (_feemul * _fee) / (
234             (_feemul - FEE_DENOMINATOR) * 4 * xpi * xpj / xps2 + \
235             FEE_DENOMINATOR)
236 
237 
238 @view
239 @external
240 def dynamic_fee(i: int128, j: int128) -> uint256:
241     """
242     @notice Return the fee for swapping between `i` and `j`
243     @param i Index value for the coin to send
244     @param j Index value of the coin to recieve
245     @return Swap fee expressed as an integer with 1e10 precision
246     """
247     precisions: uint256[N_COINS] = PRECISION_MUL
248     xpi: uint256 = (ERC20(self.coins[i]).balanceOf(self) - self.admin_balances[i]) * precisions[i]
249     xpj: uint256 = (ERC20(self.coins[j]).balanceOf(self) - self.admin_balances[j]) * precisions[j]
250     return self._dynamic_fee(xpi, xpj, self.fee, self.offpeg_fee_multiplier)
251 
252 
253 @view
254 @external
255 def balances(i: uint256) -> uint256:
256     """
257     @notice Get the current balance of a coin within the
258             pool, less the accrued admin fees
259     @param i Index value for the coin to query balance of
260     @return Token balance
261     """
262     return ERC20(self.coins[i]).balanceOf(self) - self.admin_balances[i]
263 
264 
265 @view
266 @internal
267 def _balances() -> uint256[N_COINS]:
268     result: uint256[N_COINS] = empty(uint256[N_COINS])
269     for i in range(N_COINS):
270         result[i] = ERC20(self.coins[i]).balanceOf(self) - self.admin_balances[i]
271     return result
272 
273 
274 @pure
275 @internal
276 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
277     """
278     D invariant calculation in non-overflowing integer operations
279     iteratively
280 
281     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
282 
283     Converging solution:
284     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
285     """
286     S: uint256 = 0
287 
288     for _x in xp:
289         S += _x
290     if S == 0:
291         return 0
292 
293     Dprev: uint256 = 0
294     D: uint256 = S
295     Ann: uint256 = amp * N_COINS
296     for _i in range(255):
297         D_P: uint256 = D
298         for _x in xp:
299             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
300         Dprev = D
301         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
302         # Equality with the precision of 1
303         if D > Dprev:
304             if D - Dprev <= 1:
305                 return D
306         else:
307             if Dprev - D <= 1:
308                 return D
309     # convergence typically occurs in 4 rounds or less, this should be unreachable!
310     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
311     raise
312 
313 
314 
315 @view
316 @internal
317 def get_D_precisions(coin_balances: uint256[N_COINS], amp: uint256) -> uint256:
318     xp: uint256[N_COINS] = PRECISION_MUL
319     for i in range(N_COINS):
320         xp[i] *= coin_balances[i]
321     return self.get_D(xp, amp)
322 
323 
324 @view
325 @external
326 def get_virtual_price() -> uint256:
327     """
328     @notice The current virtual price of the pool LP token
329     @dev Useful for calculating profits
330     @return LP token virtual price normalized to 1e18
331     """
332     D: uint256 = self.get_D_precisions(self._balances(), self._A())
333     # D is in the units similar to DAI (e.g. converted to precision 1e18)
334     # When balanced, D = n * x_u - total virtual value of the portfolio
335     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
336     return D * PRECISION / token_supply
337 
338 
339 @view
340 @external
341 def calc_token_amount(_amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
342     """
343     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
344     @dev This calculation accounts for slippage, but not fees.
345          Needed to prevent front-running, not for precise calculations!
346     @param _amounts Amount of each coin being deposited
347     @param is_deposit set True for deposits, False for withdrawals
348     @return Expected amount of LP tokens received
349     """
350     coin_balances: uint256[N_COINS] = self._balances()
351     amp: uint256 = self._A()
352     D0: uint256 = self.get_D_precisions(coin_balances, amp)
353     for i in range(N_COINS):
354         if is_deposit:
355             coin_balances[i] += _amounts[i]
356         else:
357             coin_balances[i] -= _amounts[i]
358     D1: uint256 = self.get_D_precisions(coin_balances, amp)
359     token_amount: uint256 = ERC20(self.lp_token).totalSupply()
360     diff: uint256 = 0
361     if is_deposit:
362         diff = D1 - D0
363     else:
364         diff = D0 - D1
365     return diff * token_amount / D0
366 
367 
368 @external
369 @nonreentrant('lock')
370 def add_liquidity(_amounts: uint256[N_COINS], _min_mint_amount: uint256, _use_underlying: bool = False) -> uint256:
371     """
372     @notice Deposit coins into the pool
373     @param _amounts List of amounts of coins to deposit
374     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
375     @param _use_underlying If True, deposit underlying assets instead of aTokens
376     @return Amount of LP tokens received by depositing
377     """
378 
379     assert not self.is_killed  # dev: is killed
380 
381     # Initial invariant
382     amp: uint256 = self._A()
383     old_balances: uint256[N_COINS] = self._balances()
384     lp_token: address = self.lp_token
385     token_supply: uint256 = ERC20(lp_token).totalSupply()
386     D0: uint256 = 0
387     if token_supply != 0:
388         D0 = self.get_D_precisions(old_balances, amp)
389 
390     new_balances: uint256[N_COINS] = old_balances
391     for i in range(N_COINS):
392         if token_supply == 0:
393             assert _amounts[i] != 0  # dev: initial deposit requires all coins
394         new_balances[i] += _amounts[i]
395 
396     # Invariant after change
397     D1: uint256 = self.get_D_precisions(new_balances, amp)
398     assert D1 > D0
399 
400     # We need to recalculate the invariant accounting for fees
401     # to calculate fair user's share
402     fees: uint256[N_COINS] = empty(uint256[N_COINS])
403     mint_amount: uint256 = 0
404     if token_supply != 0:
405         # Only account for fees if we are not the first to deposit
406         ys: uint256 = (D0 + D1) / N_COINS
407         _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
408         _feemul: uint256 = self.offpeg_fee_multiplier
409         _admin_fee: uint256 = self.admin_fee
410         difference: uint256 = 0
411         for i in range(N_COINS):
412             ideal_balance: uint256 = D1 * old_balances[i] / D0
413             new_balance: uint256 = new_balances[i]
414             if ideal_balance > new_balance:
415                 difference = ideal_balance - new_balance
416             else:
417                 difference = new_balance - ideal_balance
418             xs: uint256 = old_balances[i] + new_balance
419             fees[i] = self._dynamic_fee(xs, ys, _fee, _feemul) * difference / FEE_DENOMINATOR
420             if _admin_fee != 0:
421                 self.admin_balances[i] += fees[i] * _admin_fee / FEE_DENOMINATOR
422             new_balances[i] = new_balance - fees[i]
423         D2: uint256 = self.get_D_precisions(new_balances, amp)
424         mint_amount = token_supply * (D2 - D0) / D0
425     else:
426         mint_amount = D1  # Take the dust if there was any
427 
428     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
429 
430     # Take coins from the sender
431     if _use_underlying:
432         lending_pool: address = self.aave_lending_pool
433         aave_referral: bytes32 = convert(self.aave_referral, bytes32)
434 
435         # Take coins from the sender
436         for i in range(N_COINS):
437             amount: uint256 = _amounts[i]
438             if amount != 0:
439                 coin: address = self.underlying_coins[i]
440                 # transfer underlying coin from msg.sender to self
441                 _response: Bytes[32] = raw_call(
442                     coin,
443                     concat(
444                         method_id("transferFrom(address,address,uint256)"),
445                         convert(msg.sender, bytes32),
446                         convert(self, bytes32),
447                         convert(amount, bytes32)
448                     ),
449                     max_outsize=32
450                 )
451                 if len(_response) != 0:
452                     assert convert(_response, bool)
453 
454                 # deposit to aave lending pool
455                 raw_call(
456                     lending_pool,
457                     concat(
458                         method_id("deposit(address,uint256,address,uint16)"),
459                         convert(coin, bytes32),
460                         convert(amount, bytes32),
461                         convert(self, bytes32),
462                         aave_referral,
463                     )
464                 )
465     else:
466         for i in range(N_COINS):
467             amount: uint256 = _amounts[i]
468             if amount != 0:
469                 assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amount) # dev: failed transfer
470 
471     # Mint pool tokens
472     CurveToken(lp_token).mint(msg.sender, mint_amount)
473 
474     log AddLiquidity(msg.sender, _amounts, fees, D1, token_supply + mint_amount)
475 
476     return mint_amount
477 
478 
479 @view
480 @internal
481 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
482     """
483     Calculate x[j] if one makes x[i] = x
484 
485     Done by solving quadratic equation iteratively.
486     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
487     x_1**2 + b*x_1 = c
488 
489     x_1 = (x_1**2 + c) / (2*x_1 + b)
490     """
491     # x in the input is converted to the same price/precision
492 
493     assert i != j       # dev: same coin
494     assert j >= 0       # dev: j below zero
495     assert j < N_COINS  # dev: j above N_COINS
496 
497     # should be unreachable, but good for safety
498     assert i >= 0
499     assert i < N_COINS
500 
501     amp: uint256 = self._A()
502     D: uint256 = self.get_D(xp, amp)
503     Ann: uint256 = amp * N_COINS
504     c: uint256 = D
505     S_: uint256 = 0
506     _x: uint256 = 0
507     y_prev: uint256 = 0
508 
509     for _i in range(N_COINS):
510         if _i == i:
511             _x = x
512         elif _i != j:
513             _x = xp[_i]
514         else:
515             continue
516         S_ += _x
517         c = c * D / (_x * N_COINS)
518     c = c * D * A_PRECISION / (Ann * N_COINS)
519     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
520     y: uint256 = D
521     for _i in range(255):
522         y_prev = y
523         y = (y*y + c) / (2 * y + b - D)
524         # Equality with the precision of 1
525         if y > y_prev:
526             if y - y_prev <= 1:
527                 return y
528         else:
529             if y_prev - y <= 1:
530                 return y
531     raise
532 
533 
534 @view
535 @internal
536 def _get_dy(i: int128, j: int128, dx: uint256) -> uint256:
537     xp: uint256[N_COINS] = self._balances()
538     precisions: uint256[N_COINS] = PRECISION_MUL
539     for k in range(N_COINS):
540         xp[k] *= precisions[k]
541 
542     x: uint256 = xp[i] + dx * precisions[i]
543     y: uint256 = self.get_y(i, j, x, xp)
544     dy: uint256 = (xp[j] - y) / precisions[j]
545     _fee: uint256 = self._dynamic_fee(
546             (xp[i] + x) / 2, (xp[j] + y) / 2, self.fee, self.offpeg_fee_multiplier
547         ) * dy / FEE_DENOMINATOR
548     return dy - _fee
549 
550 
551 @view
552 @external
553 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
554     return self._get_dy(i, j, dx)
555 
556 
557 @view
558 @external
559 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
560     return self._get_dy(i, j, dx)
561 
562 
563 @internal
564 def _exchange(i: int128, j: int128, dx: uint256) -> uint256:
565     assert not self.is_killed  # dev: is killed
566     # dx and dy are in aTokens
567 
568     xp: uint256[N_COINS] = self._balances()
569     precisions: uint256[N_COINS] = PRECISION_MUL
570     for k in range(N_COINS):
571         xp[k] *= precisions[k]
572 
573     x: uint256 = xp[i] + dx * precisions[i]
574     y: uint256 = self.get_y(i, j, x, xp)
575     dy: uint256 = xp[j] - y
576     dy_fee: uint256 = dy * self._dynamic_fee(
577             (xp[i] + x) / 2, (xp[j] + y) / 2, self.fee, self.offpeg_fee_multiplier
578         ) / FEE_DENOMINATOR
579 
580     admin_fee: uint256 = self.admin_fee
581     if admin_fee != 0:
582         dy_admin_fee: uint256 = dy_fee * admin_fee / FEE_DENOMINATOR
583         if dy_admin_fee != 0:
584             self.admin_balances[j] += dy_admin_fee / precisions[j]
585 
586     return (dy - dy_fee) / precisions[j]
587 
588 
589 @external
590 @nonreentrant('lock')
591 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
592     """
593     @notice Perform an exchange between two coins
594     @dev Index values can be found via the `coins` public getter method
595     @param i Index value for the coin to send
596     @param j Index valie of the coin to recieve
597     @param dx Amount of `i` being exchanged
598     @param min_dy Minimum amount of `j` to receive
599     @return Actual amount of `j` received
600     """
601     dy: uint256 = self._exchange(i, j, dx)
602     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
603 
604     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)
605     assert ERC20(self.coins[j]).transfer(msg.sender, dy)
606 
607     log TokenExchange(msg.sender, i, dx, j, dy)
608 
609     return dy
610 
611 
612 @external
613 @nonreentrant('lock')
614 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
615     """
616     @notice Perform an exchange between two underlying coins
617     @dev Index values can be found via the `underlying_coins` public getter method
618     @param i Index value for the underlying coin to send
619     @param j Index valie of the underlying coin to recieve
620     @param dx Amount of `i` being exchanged
621     @param min_dy Minimum amount of `j` to receive
622     @return Actual amount of `j` received
623     """
624     dy: uint256 = self._exchange(i, j, dx)
625     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
626 
627     u_coin_i: address = self.underlying_coins[i]
628     lending_pool: address = self.aave_lending_pool
629 
630     # transfer underlying coin from msg.sender to self
631     _response: Bytes[32] = raw_call(
632         u_coin_i,
633         concat(
634             method_id("transferFrom(address,address,uint256)"),
635             convert(msg.sender, bytes32),
636             convert(self, bytes32),
637             convert(dx, bytes32)
638         ),
639         max_outsize=32
640     )
641     if len(_response) != 0:
642         assert convert(_response, bool)
643 
644     # deposit to aave lending pool
645     raw_call(
646         lending_pool,
647         concat(
648             method_id("deposit(address,uint256,address,uint16)"),
649             convert(u_coin_i, bytes32),
650             convert(dx, bytes32),
651             convert(self, bytes32),
652             convert(self.aave_referral, bytes32),
653         )
654     )
655     # withdraw `j` underlying from lending pool and transfer to caller
656     LendingPool(lending_pool).withdraw(self.underlying_coins[j], dy, msg.sender)
657 
658     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
659 
660     return dy
661 
662 
663 @external
664 @nonreentrant('lock')
665 def remove_liquidity(
666     _amount: uint256,
667     _min_amounts: uint256[N_COINS],
668     _use_underlying: bool = False,
669 ) -> uint256[N_COINS]:
670     """
671     @notice Withdraw coins from the pool
672     @dev Withdrawal amounts are based on current deposit ratios
673     @param _amount Quantity of LP tokens to burn in the withdrawal
674     @param _min_amounts Minimum amounts of underlying coins to receive
675     @param _use_underlying If True, withdraw underlying assets instead of aTokens
676     @return List of amounts of coins that were withdrawn
677     """
678     amounts: uint256[N_COINS] = self._balances()
679     lp_token: address = self.lp_token
680     total_supply: uint256 = ERC20(lp_token).totalSupply()
681     CurveToken(lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
682 
683     lending_pool: address = ZERO_ADDRESS
684     if _use_underlying:
685         lending_pool = self.aave_lending_pool
686 
687     for i in range(N_COINS):
688         value: uint256 = amounts[i] * _amount / total_supply
689         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
690         amounts[i] = value
691         if _use_underlying:
692             LendingPool(lending_pool).withdraw(self.underlying_coins[i], value, msg.sender)
693         else:
694             assert ERC20(self.coins[i]).transfer(msg.sender, value)
695 
696     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply - _amount)
697 
698     return amounts
699 
700 
701 @external
702 @nonreentrant('lock')
703 def remove_liquidity_imbalance(
704     _amounts: uint256[N_COINS],
705     _max_burn_amount: uint256,
706     _use_underlying: bool = False
707 ) -> uint256:
708     """
709     @notice Withdraw coins from the pool in an imbalanced amount
710     @param _amounts List of amounts of underlying coins to withdraw
711     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
712     @param _use_underlying If True, withdraw underlying assets instead of aTokens
713     @return Actual amount of the LP token burned in the withdrawal
714     """
715     assert not self.is_killed  # dev: is killed
716 
717     amp: uint256 = self._A()
718     old_balances: uint256[N_COINS] = self._balances()
719     D0: uint256 = self.get_D_precisions(old_balances, amp)
720     new_balances: uint256[N_COINS] = old_balances
721     for i in range(N_COINS):
722         new_balances[i] -= _amounts[i]
723     D1: uint256 = self.get_D_precisions(new_balances, amp)
724     ys: uint256 = (D0 + D1) / N_COINS
725 
726     lp_token: address = self.lp_token
727     token_supply: uint256 = ERC20(lp_token).totalSupply()
728     assert token_supply != 0  # dev: zero total supply
729 
730     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
731     _feemul: uint256 = self.offpeg_fee_multiplier
732     _admin_fee: uint256 = self.admin_fee
733     fees: uint256[N_COINS] = empty(uint256[N_COINS])
734     for i in range(N_COINS):
735         ideal_balance: uint256 = D1 * old_balances[i] / D0
736         new_balance: uint256 = new_balances[i]
737         difference: uint256 = 0
738         if ideal_balance > new_balance:
739             difference = ideal_balance - new_balance
740         else:
741             difference = new_balance - ideal_balance
742         xs: uint256 = new_balance + old_balances[i]
743         fees[i] = self._dynamic_fee(xs, ys, _fee, _feemul) * difference / FEE_DENOMINATOR
744         if _admin_fee != 0:
745             self.admin_balances[i] += fees[i] * _admin_fee / FEE_DENOMINATOR
746         new_balances[i] -= fees[i]
747     D2: uint256 = self.get_D_precisions(new_balances, amp)
748 
749     token_amount: uint256 = (D0 - D2) * token_supply / D0
750     assert token_amount != 0  # dev: zero tokens burned
751     assert token_amount <= _max_burn_amount, "Slippage screwed you"
752 
753     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
754 
755     lending_pool: address = ZERO_ADDRESS
756     if _use_underlying:
757         lending_pool = self.aave_lending_pool
758 
759     for i in range(N_COINS):
760         amount: uint256 = _amounts[i]
761         if amount != 0:
762             if _use_underlying:
763                 LendingPool(lending_pool).withdraw(self.underlying_coins[i], amount, msg.sender)
764             else:
765                 assert ERC20(self.coins[i]).transfer(msg.sender, amount)
766 
767     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, token_supply - token_amount)
768 
769     return token_amount
770 
771 
772 @pure
773 @internal
774 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
775     """
776     Calculate x[i] if one reduces D from being calculated for xp to D
777 
778     Done by solving quadratic equation iteratively.
779     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
780     x_1**2 + b*x_1 = c
781 
782     x_1 = (x_1**2 + c) / (2*x_1 + b)
783     """
784     # x in the input is converted to the same price/precision
785 
786     assert i >= 0       # dev: i below zero
787     assert i < N_COINS  # dev: i above N_COINS
788 
789     Ann: uint256 = A_ * N_COINS
790     c: uint256 = D
791     S_: uint256 = 0
792     _x: uint256 = 0
793     y_prev: uint256 = 0
794 
795     for _i in range(N_COINS):
796         if _i != i:
797             _x = xp[_i]
798         else:
799             continue
800         S_ += _x
801         c = c * D / (_x * N_COINS)
802     c = c * D * A_PRECISION / (Ann * N_COINS)
803     b: uint256 = S_ + D * A_PRECISION / Ann
804     y: uint256 = D
805 
806     for _i in range(255):
807         y_prev = y
808         y = (y*y + c) / (2 * y + b - D)
809         # Equality with the precision of 1
810         if y > y_prev:
811             if y - y_prev <= 1:
812                 return y
813         else:
814             if y_prev - y <= 1:
815                 return y
816     raise
817 
818 
819 @view
820 @internal
821 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
822     # First, need to calculate
823     # * Get current D
824     # * Solve Eqn against y_i for D - _token_amount
825     amp: uint256 = self._A()
826     xp: uint256[N_COINS] = self._balances()
827     precisions: uint256[N_COINS] = PRECISION_MUL
828 
829     for j in range(N_COINS):
830         xp[j] *= precisions[j]
831 
832     D0: uint256 = self.get_D(xp, amp)
833     D1: uint256 = D0 - _token_amount * D0 / ERC20(self.lp_token).totalSupply()
834     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
835 
836     xp_reduced: uint256[N_COINS] = xp
837     ys: uint256 = (D0 + D1) / (2 * N_COINS)
838 
839     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
840     feemul: uint256 = self.offpeg_fee_multiplier
841     for j in range(N_COINS):
842         dx_expected: uint256 = 0
843         xavg: uint256 = 0
844         if j == i:
845             dx_expected = xp[j] * D1 / D0 - new_y
846             xavg = (xp[j] + new_y) / 2
847         else:
848             dx_expected = xp[j] - xp[j] * D1 / D0
849             xavg = xp[j]
850         xp_reduced[j] -= self._dynamic_fee(xavg, ys, _fee, feemul) * dx_expected / FEE_DENOMINATOR
851 
852     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
853 
854     return (dy - 1) / precisions[i]
855 
856 
857 @view
858 @external
859 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
860     """
861     @notice Calculate the amount received when withdrawing a single coin
862     @dev Result is the same for underlying or wrapped asset withdrawals
863     @param _token_amount Amount of LP tokens to burn in the withdrawal
864     @param i Index value of the coin to withdraw
865     @return Amount of coin received
866     """
867     return self._calc_withdraw_one_coin(_token_amount, i)
868 
869 
870 @external
871 @nonreentrant('lock')
872 def remove_liquidity_one_coin(
873     _token_amount: uint256,
874     i: int128,
875     _min_amount: uint256,
876     _use_underlying: bool = False
877 ) -> uint256:
878     """
879     @notice Withdraw a single coin from the pool
880     @param _token_amount Amount of LP tokens to burn in the withdrawal
881     @param i Index value of the coin to withdraw
882     @param _min_amount Minimum amount of coin to receive
883     @param _use_underlying If True, withdraw underlying assets instead of aTokens
884     @return Amount of coin received
885     """
886     assert not self.is_killed  # dev: is killed
887 
888     dy: uint256 = self._calc_withdraw_one_coin(_token_amount, i)
889     assert dy >= _min_amount, "Not enough coins removed"
890 
891     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
892 
893     if _use_underlying:
894         LendingPool(self.aave_lending_pool).withdraw(self.underlying_coins[i], dy, msg.sender)
895     else:
896         assert ERC20(self.coins[i]).transfer(msg.sender, dy)
897 
898     log RemoveLiquidityOne(msg.sender, _token_amount, dy)
899 
900     return dy
901 
902 
903 ### Admin functions ###
904 
905 @external
906 def ramp_A(_future_A: uint256, _future_time: uint256):
907     assert msg.sender == self.owner  # dev: only owner
908     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
909     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
910 
911     _initial_A: uint256 = self._A()
912     _future_A_p: uint256 = _future_A * A_PRECISION
913 
914     assert _future_A > 0 and _future_A < MAX_A
915     if _future_A_p < _initial_A:
916         assert _future_A_p * MAX_A_CHANGE >= _initial_A
917     else:
918         assert _future_A_p <= _initial_A * MAX_A_CHANGE
919 
920     self.initial_A = _initial_A
921     self.future_A = _future_A_p
922     self.initial_A_time = block.timestamp
923     self.future_A_time = _future_time
924 
925     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
926 
927 
928 @external
929 def stop_ramp_A():
930     assert msg.sender == self.owner  # dev: only owner
931 
932     current_A: uint256 = self._A()
933     self.initial_A = current_A
934     self.future_A = current_A
935     self.initial_A_time = block.timestamp
936     self.future_A_time = block.timestamp
937     # now (block.timestamp < t1) is always False, so we return saved A
938 
939     log StopRampA(current_A, block.timestamp)
940 
941 
942 @external
943 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256, new_offpeg_fee_multiplier: uint256):
944     assert msg.sender == self.owner  # dev: only owner
945     assert self.admin_actions_deadline == 0  # dev: active action
946     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
947     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
948     assert new_offpeg_fee_multiplier * new_fee <= MAX_FEE * FEE_DENOMINATOR  # dev: offpeg multiplier exceeds maximum
949 
950     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
951     self.admin_actions_deadline = _deadline
952     self.future_fee = new_fee
953     self.future_admin_fee = new_admin_fee
954     self.future_offpeg_fee_multiplier = new_offpeg_fee_multiplier
955 
956     log CommitNewFee(_deadline, new_fee, new_admin_fee, new_offpeg_fee_multiplier)
957 
958 
959 @external
960 def apply_new_fee():
961     assert msg.sender == self.owner  # dev: only owner
962     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
963     assert self.admin_actions_deadline != 0  # dev: no active action
964 
965     self.admin_actions_deadline = 0
966     _fee: uint256 = self.future_fee
967     _admin_fee: uint256 = self.future_admin_fee
968     _fml: uint256 = self.future_offpeg_fee_multiplier
969     self.fee = _fee
970     self.admin_fee = _admin_fee
971     self.offpeg_fee_multiplier = _fml
972 
973     log NewFee(_fee, _admin_fee, _fml)
974 
975 
976 @external
977 def revert_new_parameters():
978     assert msg.sender == self.owner  # dev: only owner
979 
980     self.admin_actions_deadline = 0
981 
982 
983 @external
984 def commit_transfer_ownership(_owner: address):
985     assert msg.sender == self.owner  # dev: only owner
986     assert self.transfer_ownership_deadline == 0  # dev: active transfer
987 
988     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
989     self.transfer_ownership_deadline = _deadline
990     self.future_owner = _owner
991 
992     log CommitNewAdmin(_deadline, _owner)
993 
994 
995 @external
996 def apply_transfer_ownership():
997     assert msg.sender == self.owner  # dev: only owner
998     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
999     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1000 
1001     self.transfer_ownership_deadline = 0
1002     _owner: address = self.future_owner
1003     self.owner = _owner
1004 
1005     log NewAdmin(_owner)
1006 
1007 
1008 @external
1009 def revert_transfer_ownership():
1010     assert msg.sender == self.owner  # dev: only owner
1011 
1012     self.transfer_ownership_deadline = 0
1013 
1014 
1015 @external
1016 def withdraw_admin_fees():
1017     assert msg.sender == self.owner  # dev: only owner
1018 
1019     for i in range(N_COINS):
1020         value: uint256 = self.admin_balances[i]
1021         if value != 0:
1022             assert ERC20(self.coins[i]).transfer(msg.sender, value)
1023             self.admin_balances[i] = 0
1024 
1025 
1026 @external
1027 def donate_admin_fees():
1028     """
1029     Just in case admin balances somehow become higher than total (rounding error?)
1030     this can be used to fix the state, too
1031     """
1032     assert msg.sender == self.owner  # dev: only owner
1033     self.admin_balances = empty(uint256[N_COINS])
1034 
1035 
1036 @external
1037 def kill_me():
1038     assert msg.sender == self.owner  # dev: only owner
1039     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1040     self.is_killed = True
1041 
1042 
1043 @external
1044 def unkill_me():
1045     assert msg.sender == self.owner  # dev: only owner
1046     self.is_killed = False
1047 
1048 
1049 @external
1050 def set_aave_referral(referral_code: uint256):
1051     assert msg.sender == self.owner  # dev: only owner
1052     assert referral_code < 2 ** 16  # dev: uint16 overflow
1053     self.aave_referral = referral_code