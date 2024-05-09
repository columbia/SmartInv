1 # @version 0.2.8
2 """
3 @title Curve IronBank Pool
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2021 - all rights reserved
6 @notice Pool for swapping between cyTokens (cyDAI, cyUSDC, cyUSDT)
7 """
8 
9 # External Contracts
10 interface cyToken:
11     def transfer(_to: address, _value: uint256) -> bool: nonpayable
12     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: nonpayable
13     def mint(mintAmount: uint256) -> uint256: nonpayable
14     def redeem(redeemTokens: uint256) -> uint256: nonpayable
15     def exchangeRateStored() -> uint256: view
16     def exchangeRateCurrent() -> uint256: nonpayable
17     def supplyRatePerBlock() -> uint256: view
18     def accrualBlockNumber() -> uint256: view
19 
20 interface CurveToken:
21     def mint(_to: address, _value: uint256) -> bool: nonpayable
22     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
23 
24 interface ERC20:
25     def transfer(_to: address, _value: uint256): nonpayable
26     def transferFrom(_from: address, _to: address, _value: uint256): nonpayable
27     def totalSupply() -> uint256: view
28     def balanceOf(_addr: address) -> uint256: view
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
62 
63 event RemoveLiquidityImbalance:
64     provider: indexed(address)
65     token_amounts: uint256[N_COINS]
66     fees: uint256[N_COINS]
67     invariant: uint256
68     token_supply: uint256
69 
70 event CommitNewAdmin:
71     deadline: indexed(uint256)
72     admin: indexed(address)
73 
74 event NewAdmin:
75     admin: indexed(address)
76 
77 event CommitNewFee:
78     deadline: indexed(uint256)
79     fee: uint256
80     admin_fee: uint256
81 
82 event NewFee:
83     fee: uint256
84     admin_fee: uint256
85 
86 event RampA:
87     old_A: uint256
88     new_A: uint256
89     initial_time: uint256
90     future_time: uint256
91 
92 event StopRampA:
93     A: uint256
94     t: uint256
95 
96 
97 # These constants must be set prior to compiling
98 N_COINS: constant(int128) = 3
99 PRECISION_MUL: constant(uint256[N_COINS]) = [1, 1000000000000, 1000000000000]
100 
101 # fixed constants
102 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
103 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
104 
105 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
106 MAX_FEE: constant(uint256) = 5 * 10 ** 9
107 MAX_A: constant(uint256) = 10 ** 6
108 MAX_A_CHANGE: constant(uint256) = 10
109 
110 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
111 MIN_RAMP_TIME: constant(uint256) = 86400
112 
113 coins: public(address[N_COINS])
114 underlying_coins: public(address[N_COINS])
115 balances: public(uint256[N_COINS])
116 
117 previous_balances: public(uint256[N_COINS])
118 block_timestamp_last: public(uint256)
119 
120 fee: public(uint256)  # fee * 1e10
121 admin_fee: public(uint256)  # admin_fee * 1e10
122 
123 owner: public(address)
124 lp_token: public(address)
125 
126 A_PRECISION: constant(uint256) = 100
127 initial_A: public(uint256)
128 future_A: public(uint256)
129 initial_A_time: public(uint256)
130 future_A_time: public(uint256)
131 
132 admin_actions_deadline: public(uint256)
133 transfer_ownership_deadline: public(uint256)
134 future_fee: public(uint256)
135 future_admin_fee: public(uint256)
136 future_owner: public(address)
137 
138 is_killed: bool
139 kill_deadline: uint256
140 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
141 
142 @external
143 def __init__(
144     _owner: address,
145     _coins: address[N_COINS],
146     _underlying_coins: address[N_COINS],
147     _pool_token: address,
148     _A: uint256,
149     _fee: uint256,
150     _admin_fee: uint256,
151 ):
152     """
153     @notice Contract constructor
154     @param _owner Contract owner address
155     @param _coins Addresses of ERC20 contracts of wrapped coins
156     @param _underlying_coins Addresses of ERC20 contracts of underlying coins
157     @param _pool_token Address of the token representing LP share
158     @param _A Amplification coefficient multiplied by n * (n - 1)
159     @param _fee Fee to charge for exchanges
160     @param _admin_fee Admin fee
161     """
162     for i in range(N_COINS):
163         assert _coins[i] != ZERO_ADDRESS
164         assert _underlying_coins[i] != ZERO_ADDRESS
165 
166         # approve underlying coins for infinite transfers
167         _response: Bytes[32] = raw_call(
168             _underlying_coins[i],
169             concat(
170                 method_id("approve(address,uint256)"),
171                 convert(_coins[i], bytes32),
172                 convert(MAX_UINT256, bytes32),
173             ),
174             max_outsize=32,
175         )
176         if len(_response) > 0:
177             assert convert(_response, bool)
178 
179     self.coins = _coins
180     self.underlying_coins = _underlying_coins
181     self.initial_A = _A * A_PRECISION
182     self.future_A = _A * A_PRECISION
183     self.fee = _fee
184     self.admin_fee = _admin_fee
185     self.owner = _owner
186     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
187     self.lp_token = _pool_token
188 
189 
190 @view
191 @internal
192 def _A() -> uint256:
193     """
194     Handle ramping A up or down
195     """
196     t1: uint256 = self.future_A_time
197     A1: uint256 = self.future_A
198 
199     if block.timestamp < t1:
200         A0: uint256 = self.initial_A
201         t0: uint256 = self.initial_A_time
202         # Expressions in uint256 cannot have negative numbers, thus "if"
203         if A1 > A0:
204             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
205         else:
206             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
207 
208     else:  # when t1 == 0 or block.timestamp >= t1
209         return A1
210 
211 
212 @view
213 @external
214 def A() -> uint256:
215     return self._A() / A_PRECISION
216 
217 
218 @view
219 @external
220 def A_precise() -> uint256:
221     return self._A()
222 
223 
224 @view
225 @internal
226 def _stored_rates() -> uint256[N_COINS]:
227     # exchangeRateStored * (1 + supplyRatePerBlock * (getBlockNumber - accrualBlockNumber) / 1e18)
228     result: uint256[N_COINS] = PRECISION_MUL
229     for i in range(N_COINS):
230         coin: address = self.coins[i]
231         rate: uint256 = cyToken(coin).exchangeRateStored()
232         rate += rate * cyToken(coin).supplyRatePerBlock() * (block.number - cyToken(coin).accrualBlockNumber()) / PRECISION
233         result[i] *= rate
234     return result
235 
236 
237 @internal
238 def _update():
239     """
240     Commits pre-change balances for the previous block
241     Can be used to compare against current values for flash loan checks
242     """
243     if block.timestamp > self.block_timestamp_last:
244         self.previous_balances = self.balances
245         self.block_timestamp_last = block.timestamp
246 
247 
248 @internal
249 def _current_rates() -> uint256[N_COINS]:
250     self._update()
251     result: uint256[N_COINS] = PRECISION_MUL
252     for i in range(N_COINS):
253         result[i] *= cyToken(self.coins[i]).exchangeRateCurrent()
254     return result
255 
256 
257 @view
258 @internal
259 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
260     result: uint256[N_COINS] = empty(uint256[N_COINS])
261     for i in range(N_COINS):
262         result[i] = rates[i] * self.balances[i] / PRECISION
263     return result
264 
265 @pure
266 @internal
267 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
268     S: uint256 = 0
269     Dprev: uint256 = 0
270 
271     for _x in xp:
272         S += _x
273     if S == 0:
274         return 0
275 
276     D: uint256 = S
277     Ann: uint256 = amp * N_COINS
278     for _i in range(255):
279         D_P: uint256 = D
280         for _x in xp:
281             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
282         Dprev = D
283         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
284         # Equality with the precision of 1
285         if D > Dprev:
286             if D - Dprev <= 1:
287                 return D
288         else:
289             if Dprev - D <= 1:
290                 return D
291     # convergence typically occurs in 4 rounds or less, this should be unreachable!
292     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
293     raise
294 
295 
296 @view
297 @internal
298 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
299     xp: uint256[N_COINS] = empty(uint256[N_COINS])
300     for i in range(N_COINS):
301         xp[i] = rates[i] * _balances[i] / PRECISION
302 
303     return self.get_D(xp, _amp)
304 
305 
306 @view
307 @external
308 def get_virtual_price() -> uint256:
309     """
310     @notice The current virtual price of the pool LP token
311     @dev Useful for calculating profits
312     @return LP token virtual price normalized to 1e18
313     """
314     D: uint256 = self.get_D(self._xp(self._stored_rates()), self._A())
315     # D is in the units similar to DAI (e.g. converted to precision 1e18)
316     # When balanced, D = n * x_u - total virtual value of the portfolio
317     return D * PRECISION / ERC20(self.lp_token).totalSupply()
318 
319 
320 @view
321 @external
322 def calc_token_amount(amounts: uint256[N_COINS], is_deposit: bool) -> uint256:
323     """
324     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
325     @dev This calculation accounts for slippage, but not fees.
326          Needed to prevent front-running, not for precise calculations!
327     @param amounts Amount of each coin being deposited
328     @param is_deposit set True for deposits, False for withdrawals
329     @return Expected amount of LP tokens received
330     """
331     amp: uint256 = self._A()
332     rates: uint256[N_COINS] = self._stored_rates()
333     _balances: uint256[N_COINS] = self.balances
334     D0: uint256 = self.get_D_mem(rates, _balances, amp)
335     for i in range(N_COINS):
336         _amount: uint256 = amounts[i]
337         if is_deposit:
338             _balances[i] += _amount
339         else:
340             _balances[i] -= _amount
341     D1: uint256 = self.get_D_mem(rates, _balances, amp)
342     token_amount: uint256 = ERC20(self.lp_token).totalSupply()
343     diff: uint256 = 0
344     if is_deposit:
345         diff = D1 - D0
346     else:
347         diff = D0 - D1
348     return diff * token_amount / D0
349 
350 
351 @external
352 @nonreentrant('lock')
353 def add_liquidity(
354     _amounts: uint256[N_COINS],
355     _min_mint_amount: uint256,
356     _use_underlying: bool = False
357 ) -> uint256:
358     """
359     @notice Deposit coins into the pool
360     @param _amounts List of amounts of coins to deposit
361     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
362     @param _use_underlying If True, deposit underlying assets instead of cyTokens
363     @return Amount of LP tokens received by depositing
364     """
365     assert not self.is_killed
366 
367     amp: uint256 = self._A()
368     rates: uint256[N_COINS] = self._current_rates()
369     _lp_token: address = self.lp_token
370     token_supply: uint256 = ERC20(_lp_token).totalSupply()
371 
372     # Initial invariant
373     old_balances: uint256[N_COINS] = self.balances
374     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
375 
376     # Take coins from the sender
377     new_balances: uint256[N_COINS] = old_balances
378     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
379     for i in range(N_COINS):
380         amount: uint256 = _amounts[i]
381 
382         if amount == 0:
383             assert token_supply > 0
384         else:
385             coin: address = self.coins[i]
386             if _use_underlying:
387                 ERC20(self.underlying_coins[i]).transferFrom(msg.sender, self, amount)
388                 before: uint256 = ERC20(coin).balanceOf(self)
389                 assert cyToken(coin).mint(amount) == 0
390                 amount = ERC20(coin).balanceOf(self) - before
391             else:
392                 assert cyToken(coin).transferFrom(msg.sender, self, amount)
393             amounts[i] = amount
394             new_balances[i] += amount
395 
396     # Invariant after change
397     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
398     assert D1 > D0
399 
400     # We need to recalculate the invariant accounting for fees
401     # to calculate fair user's share
402     fees: uint256[N_COINS] = empty(uint256[N_COINS])
403     mint_amount: uint256 = 0
404     if token_supply != 0:
405         # Only account for fees if we are not the first to deposit
406         _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
407         _admin_fee: uint256 = self.admin_fee
408         difference: uint256 = 0
409         for i in range(N_COINS):
410             new_balance: uint256 = new_balances[i]
411             ideal_balance: uint256 = D1 * old_balances[i] / D0
412             if ideal_balance > new_balance:
413                 difference = ideal_balance - new_balance
414             else:
415                 difference = new_balance - ideal_balance
416             fees[i] = _fee * difference / FEE_DENOMINATOR
417             self.balances[i] = new_balance - (fees[i] * _admin_fee / FEE_DENOMINATOR)
418             new_balances[i] -= fees[i]
419         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
420         mint_amount = token_supply * (D2 - D0) / D0
421     else:
422         self.balances = new_balances
423         mint_amount = D1  # Take the dust if there was any
424 
425     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
426 
427     # Mint pool tokens
428     CurveToken(_lp_token).mint(msg.sender, mint_amount)
429 
430     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
431 
432     return mint_amount
433 
434 
435 @view
436 @internal
437 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
438     # x in the input is converted to the same price/precision
439 
440     assert i != j       # dev: same coin
441     assert j >= 0       # dev: j below zero
442     assert j < N_COINS  # dev: j above N_COINS
443 
444     # should be unreachable, but good for safety
445     assert i >= 0
446     assert i < N_COINS
447 
448     A_: uint256 = self._A()
449     D: uint256 = self.get_D(xp_, A_)
450     Ann: uint256 = A_ * N_COINS
451     c: uint256 = D
452     S_: uint256 = 0
453     _x: uint256 = 0
454     y_prev: uint256 = 0
455 
456     for _i in range(N_COINS):
457         if _i == i:
458             _x = x
459         elif _i != j:
460             _x = xp_[_i]
461         else:
462             continue
463         S_ += _x
464         c = c * D / (_x * N_COINS)
465     c = c * D * A_PRECISION / (Ann * N_COINS)
466     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
467     y: uint256 = D
468     for _i in range(255):
469         y_prev = y
470         y = (y*y + c) / (2 * y + b - D)
471         # Equality with the precision of 1
472         if y > y_prev:
473             if y - y_prev <= 1:
474                 return y
475         else:
476             if y_prev - y <= 1:
477                 return y
478     raise
479 
480 
481 @view
482 @external
483 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
484     # dx and dy in c-units
485     rates: uint256[N_COINS] = self._stored_rates()
486     xp: uint256[N_COINS] = self._xp(rates)
487 
488     x: uint256 = xp[i] + dx * rates[i] / PRECISION
489     y: uint256 = self.get_y(i, j, x, xp)
490     dy: uint256 = xp[j] - y - 1
491     return (dy - (self.fee * dy / FEE_DENOMINATOR)) * PRECISION / rates[j]
492 
493 
494 @view
495 @external
496 def get_dx(i: int128, j: int128, dy: uint256) -> uint256:
497     # dx and dy in c-units
498     rates: uint256[N_COINS] = self._stored_rates()
499     xp: uint256[N_COINS] = self._xp(rates)
500 
501     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * rates[j] / PRECISION
502     x: uint256 = self.get_y(j, i, y, xp)
503     return (x - xp[i]) * PRECISION / rates[i]
504 
505 
506 @view
507 @external
508 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
509     # dx and dy in underlying units
510     rates: uint256[N_COINS] = self._stored_rates()
511     xp: uint256[N_COINS] = self._xp(rates)
512     precisions: uint256[N_COINS] = PRECISION_MUL
513 
514     x: uint256 = xp[i] + dx * precisions[i]
515     dy: uint256 = xp[j] - self.get_y(i, j, x, xp) - 1
516     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
517     return (dy - _fee) / precisions[j]
518 
519 
520 @external
521 @view
522 def get_dx_underlying(i: int128, j: int128, dy: uint256) -> uint256:
523     # dx and dy in underlying units
524     rates: uint256[N_COINS] = self._stored_rates()
525     xp: uint256[N_COINS] = self._xp(rates)
526     precisions: uint256[N_COINS] = PRECISION_MUL
527 
528     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * precisions[j]
529     return (self.get_y(j, i, y, xp) - xp[i]) / precisions[i]
530 
531 @internal
532 def _exchange(i: int128, j: int128, dx: uint256) -> uint256:
533     assert not self.is_killed
534     # dx and dy are in cy tokens
535 
536     rates: uint256[N_COINS] = self._current_rates()
537     old_balances: uint256[N_COINS] = self.balances
538 
539     xp: uint256[N_COINS] = empty(uint256[N_COINS])
540     for k in range(N_COINS):
541         xp[k] = rates[k] * old_balances[k] / PRECISION
542 
543     x: uint256 = xp[i] + dx * rates[i] / PRECISION
544     dy: uint256 = xp[j] - self.get_y(i, j, x, xp) - 1  # -1 just in case there were some rounding errors
545     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
546 
547     dy = (dy - dy_fee) * PRECISION / rates[j]
548     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
549     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
550 
551     self.balances[i] = old_balances[i] + dx
552     self.balances[j] = old_balances[j] - dy - dy_admin_fee
553 
554     return dy
555 
556 
557 @external
558 @nonreentrant('lock')
559 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
560     """
561     @notice Perform an exchange between two coins
562     @dev Index values can be found via the `coins` public getter method
563     @param i Index value for the coin to send
564     @param j Index valie of the coin to recieve
565     @param dx Amount of `i` being exchanged
566     @param min_dy Minimum amount of `j` to receive
567     @return Actual amount of `j` received
568     """
569     dy: uint256 = self._exchange(i, j, dx)
570     assert dy >= min_dy, "Too few coins in result"
571 
572     assert cyToken(self.coins[i]).transferFrom(msg.sender, self, dx)
573     assert cyToken(self.coins[j]).transfer(msg.sender, dy)
574 
575     log TokenExchange(msg.sender, i, dx, j, dy)
576 
577     return dy
578 
579 
580 @external
581 @nonreentrant('lock')
582 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256) -> uint256:
583     """
584     @notice Perform an exchange between two underlying coins
585     @dev Index values can be found via the `underlying_coins` public getter method
586     @param i Index value for the underlying coin to send
587     @param j Index valie of the underlying coin to recieve
588     @param dx Amount of `i` being exchanged
589     @param min_dy Minimum amount of `j` to receive
590     @return Actual amount of `j` received
591     """
592 
593     ERC20(self.underlying_coins[i]).transferFrom(msg.sender, self, dx)
594 
595     coin: address = self.coins[i]
596 
597     dx_: uint256 = ERC20(coin).balanceOf(self)
598     assert cyToken(coin).mint(dx) == 0
599     dx_ = ERC20(coin).balanceOf(self) - dx_
600     dy_: uint256 = self._exchange(i, j, dx_)
601 
602     assert cyToken(self.coins[j]).redeem(dy_) == 0
603 
604     underlying: address = self.underlying_coins[j]
605 
606     dy: uint256 = ERC20(underlying).balanceOf(self)
607     assert dy >= min_dy, "Too few coins in result"
608 
609     ERC20(underlying).transfer(msg.sender, dy)
610 
611     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
612 
613     return dy
614 
615 
616 @external
617 @nonreentrant('lock')
618 def remove_liquidity(
619     _amount: uint256,
620     _min_amounts: uint256[N_COINS],
621     _use_underlying: bool = False
622 ) -> uint256[N_COINS]:
623     """
624     @notice Withdraw coins from the pool
625     @dev Withdrawal amounts are based on current deposit ratios
626     @param _amount Quantity of LP tokens to burn in the withdrawal
627     @param _min_amounts Minimum amounts of underlying coins to receive
628     @param _use_underlying If True, withdraw underlying assets instead of cyTokens
629     @return List of amounts of coins that were withdrawn
630     """
631     self._update()
632     _lp_token: address = self.lp_token
633     total_supply: uint256 = ERC20(_lp_token).totalSupply()
634     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
635 
636     for i in range(N_COINS):
637         _balance: uint256 = self.balances[i]
638         value: uint256 = _balance * _amount / total_supply
639         self.balances[i] = _balance - value
640         amounts[i] = value
641 
642         coin: address = self.coins[i]
643         if _use_underlying:
644             assert cyToken(coin).redeem(value) == 0
645             underlying: address = self.underlying_coins[i]
646             value = ERC20(underlying).balanceOf(self)
647             ERC20(underlying).transfer(msg.sender, value)
648         else:
649             assert cyToken(coin).transfer(msg.sender, value)
650 
651         assert value >= _min_amounts[i]
652 
653     CurveToken(_lp_token).burnFrom(msg.sender, _amount)  # Will raise if not enough
654 
655     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply - _amount)
656 
657     return amounts
658 
659 
660 @external
661 @nonreentrant('lock')
662 def remove_liquidity_imbalance(
663     _amounts: uint256[N_COINS],
664     _max_burn_amount: uint256,
665     _use_underlying: bool = False
666 ) -> uint256:
667     """
668     @notice Withdraw coins from the pool in an imbalanced amount
669     @param _amounts List of amounts of underlying coins to withdraw
670     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
671     @param _use_underlying If True, withdraw underlying assets instead of cyTokens
672     @return Actual amount of the LP token burned in the withdrawal
673     """
674     assert not self.is_killed
675 
676     amp: uint256 = self._A()
677     rates: uint256[N_COINS] = self._current_rates()
678     old_balances: uint256[N_COINS] = self.balances
679     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
680 
681     new_balances: uint256[N_COINS] = old_balances
682     amounts: uint256[N_COINS] = _amounts
683 
684     precisions: uint256[N_COINS] = PRECISION_MUL
685     for i in range(N_COINS):
686         amount: uint256 = amounts[i]
687         if amount > 0:
688             if _use_underlying:
689                 amount = amount * precisions[i] * PRECISION / rates[i]
690                 amounts[i] = amount
691             new_balances[i] -= amount
692 
693     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
694 
695     fees: uint256[N_COINS] = empty(uint256[N_COINS])
696     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
697     _admin_fee: uint256 = self.admin_fee
698     for i in range(N_COINS):
699         ideal_balance: uint256 = D1 * old_balances[i] / D0
700         new_balance: uint256 = new_balances[i]
701         difference: uint256 = 0
702         if ideal_balance > new_balance:
703             difference = ideal_balance - new_balance
704         else:
705             difference = new_balance - ideal_balance
706         coin_fee: uint256 = _fee * difference / FEE_DENOMINATOR
707         self.balances[i] = new_balance - (coin_fee * _admin_fee / FEE_DENOMINATOR)
708         new_balances[i] -= coin_fee
709         fees[i] = coin_fee
710     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
711 
712     lp_token: address = self.lp_token
713     token_supply: uint256 = ERC20(lp_token).totalSupply()
714     token_amount: uint256 = (D0 - D2) * token_supply / D0
715     assert token_amount != 0
716     assert token_amount <= _max_burn_amount, "Slippage screwed you"
717 
718     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
719     for i in range(N_COINS):
720         amount: uint256 = amounts[i]
721         if amount != 0:
722             coin: address = self.coins[i]
723             if _use_underlying:
724                 assert cyToken(coin).redeem(amount) == 0
725                 underlying: address = self.underlying_coins[i]
726                 ERC20(underlying).transfer(msg.sender, ERC20(underlying).balanceOf(self))
727             else:
728                 assert cyToken(coin).transfer(msg.sender, amount)
729 
730     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
731 
732     return token_amount
733 
734 
735 @pure
736 @internal
737 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
738     """
739     Calculate x[i] if one reduces D from being calculated for xp to D
740 
741     Done by solving quadratic equation iteratively.
742     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
743     x_1**2 + b*x_1 = c
744 
745     x_1 = (x_1**2 + c) / (2*x_1 + b)
746     """
747     # x in the input is converted to the same price/precision
748 
749     assert i >= 0  # dev: i below zero
750     assert i < N_COINS  # dev: i above N_COINS
751 
752     Ann: uint256 = A_ * N_COINS
753     c: uint256 = D
754     S_: uint256 = 0
755     _x: uint256 = 0
756     y_prev: uint256 = 0
757 
758     for _i in range(N_COINS):
759         if _i != i:
760             _x = xp[_i]
761         else:
762             continue
763         S_ += _x
764         c = c * D / (_x * N_COINS)
765     c = c * D * A_PRECISION / (Ann * N_COINS)
766     b: uint256 = S_ + D * A_PRECISION / Ann
767     y: uint256 = D
768 
769     for _i in range(255):
770         y_prev = y
771         y = (y*y + c) / (2 * y + b - D)
772         # Equality with the precision of 1
773         if y > y_prev:
774             if y - y_prev <= 1:
775                 return y
776         else:
777             if y_prev - y <= 1:
778                 return y
779     raise
780 
781 
782 @view
783 @internal
784 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, _use_underlying: bool, _rates: uint256[N_COINS]) -> uint256[2]:
785     # First, need to calculate
786     # * Get current D
787     # * Solve Eqn against y_i for D - _token_amount
788     amp: uint256 = self._A()
789     xp: uint256[N_COINS] = self._xp(_rates)
790     D0: uint256 = self.get_D(xp, amp)
791 
792     total_supply: uint256 = ERC20(self.lp_token).totalSupply()
793 
794     D1: uint256 = D0 - _token_amount * D0 / total_supply
795     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
796 
797     xp_reduced: uint256[N_COINS] = xp
798     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
799     rate: uint256 = _rates[i]
800 
801     for j in range(N_COINS):
802         dx_expected: uint256 = 0
803         xp_j: uint256 = xp[j]
804         if j == i:
805             dx_expected = xp_j * D1 / D0 - new_y
806         else:
807             dx_expected = xp_j - xp_j * D1 / D0
808         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
809 
810     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
811     dy = (dy - 1) * PRECISION / rate  # Withdraw less to account for rounding errors
812     dy_fee: uint256 = ((xp[i] - new_y) * PRECISION / rate) - dy
813     if _use_underlying:
814         # this branch is only reachable when called via `calc_withdraw_one_coin`, which
815         # only needs `dy` - so we don't bother converting `dy_fee` to the underlying
816         precisions: uint256[N_COINS] = PRECISION_MUL
817         dy = dy * rate / precisions[i] / PRECISION
818 
819     return [dy, dy_fee]
820 
821 
822 @view
823 @external
824 def calc_withdraw_one_coin(_token_amount: uint256, i: int128, _use_underlying: bool = False) -> uint256:
825     """
826     @notice Calculate the amount received when withdrawing a single coin
827     @param _token_amount Amount of LP tokens to burn in the withdrawal
828     @param i Index value of the coin to withdraw
829     @return Amount of coin received
830     """
831     return self._calc_withdraw_one_coin(_token_amount, i, _use_underlying, self._stored_rates())[0]
832 
833 
834 @external
835 @nonreentrant('lock')
836 def remove_liquidity_one_coin(
837     _token_amount: uint256,
838     i: int128,
839     _min_amount: uint256,
840     _use_underlying: bool = False
841 ) -> uint256:
842     """
843     @notice Withdraw a single coin from the pool
844     @param _token_amount Amount of LP tokens to burn in the withdrawal
845     @param i Index value of the coin to withdraw
846     @param _min_amount Minimum amount of coin to receive
847     @param _use_underlying If True, withdraw underlying assets instead of cyTokens
848     @return Amount of coin received
849     """
850     assert not self.is_killed  # dev: is killed
851 
852     dy: uint256[2] = self._calc_withdraw_one_coin(_token_amount, i, False, self._current_rates())
853     amount: uint256 = dy[0]
854 
855     self.balances[i] -= (dy[0] + dy[1] * self.admin_fee / FEE_DENOMINATOR)
856     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
857     coin: address = self.coins[i]
858     if _use_underlying:
859         assert cyToken(coin).redeem(dy[0]) == 0
860         underlying: address = self.underlying_coins[i]
861         amount = ERC20(underlying).balanceOf(self)
862         ERC20(underlying).transfer(msg.sender, amount)
863     else:
864         assert cyToken(coin).transfer(msg.sender, amount)
865 
866     assert amount >= _min_amount, "Not enough coins removed"
867     log RemoveLiquidityOne(msg.sender, _token_amount, dy[0])
868 
869     return dy[0]
870 
871 
872 ### Admin functions ###
873 @external
874 def ramp_A(_future_A: uint256, _future_time: uint256):
875     assert msg.sender == self.owner  # dev: only owner
876     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
877     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
878 
879     _initial_A: uint256 = self._A()
880     _future_A_p: uint256 = _future_A * A_PRECISION
881 
882     assert _future_A > 0 and _future_A < MAX_A
883     if _future_A_p < _initial_A:
884         assert _future_A_p * MAX_A_CHANGE >= _initial_A
885     else:
886         assert _future_A_p <= _initial_A * MAX_A_CHANGE
887 
888     self.initial_A = _initial_A
889     self.future_A = _future_A_p
890     self.initial_A_time = block.timestamp
891     self.future_A_time = _future_time
892 
893     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
894 
895 
896 @external
897 def stop_ramp_A():
898     assert msg.sender == self.owner  # dev: only owner
899 
900     current_A: uint256 = self._A()
901     self.initial_A = current_A
902     self.future_A = current_A
903     self.initial_A_time = block.timestamp
904     self.future_A_time = block.timestamp
905     # now (block.timestamp < t1) is always False, so we return saved A
906 
907     log StopRampA(current_A, block.timestamp)
908 
909 
910 @external
911 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
912     assert msg.sender == self.owner  # dev: only owner
913     assert self.admin_actions_deadline == 0  # dev: active action
914     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
915     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
916 
917     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
918     self.admin_actions_deadline = _deadline
919     self.future_fee = new_fee
920     self.future_admin_fee = new_admin_fee
921 
922     log CommitNewFee(_deadline, new_fee, new_admin_fee)
923 
924 
925 @external
926 def apply_new_fee():
927     assert msg.sender == self.owner  # dev: only owner
928     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
929     assert self.admin_actions_deadline != 0  # dev: no active action
930 
931     self.admin_actions_deadline = 0
932     _fee: uint256 = self.future_fee
933     _admin_fee: uint256 = self.future_admin_fee
934     self.fee = _fee
935     self.admin_fee = _admin_fee
936 
937     log NewFee(_fee, _admin_fee)
938 
939 
940 @external
941 def revert_new_parameters():
942     assert msg.sender == self.owner  # dev: only owner
943 
944     self.admin_actions_deadline = 0
945 
946 
947 @external
948 def commit_transfer_ownership(_owner: address):
949     assert msg.sender == self.owner  # dev: only owner
950     assert self.transfer_ownership_deadline == 0  # dev: active transfer
951 
952     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
953     self.transfer_ownership_deadline = _deadline
954     self.future_owner = _owner
955 
956     log CommitNewAdmin(_deadline, _owner)
957 
958 
959 @external
960 def apply_transfer_ownership():
961     assert msg.sender == self.owner  # dev: only owner
962     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
963     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
964 
965     self.transfer_ownership_deadline = 0
966     _owner: address = self.future_owner
967     self.owner = _owner
968 
969     log NewAdmin(_owner)
970 
971 
972 @external
973 def revert_transfer_ownership():
974     assert msg.sender == self.owner  # dev: only owner
975 
976     self.transfer_ownership_deadline = 0
977 
978 
979 @view
980 @external
981 def admin_balances(i: uint256) -> uint256:
982     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
983 
984 
985 @external
986 def withdraw_admin_fees():
987     assert msg.sender == self.owner  # dev: only owner
988 
989     for i in range(N_COINS):
990         coin: address = self.coins[i]
991         value: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
992         if value > 0:
993             assert cyToken(coin).transfer(msg.sender, value)
994 
995 
996 @external
997 def kill_me():
998     assert msg.sender == self.owner  # dev: only owner
999     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1000     self.is_killed = True
1001 
1002 
1003 @external
1004 def unkill_me():
1005     assert msg.sender == self.owner  # dev: only owner
1006     self.is_killed = False