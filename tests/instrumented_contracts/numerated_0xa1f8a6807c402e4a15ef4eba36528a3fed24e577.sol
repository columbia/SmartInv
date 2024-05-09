1 # @version 0.3.7
2 """
3 @title FRXETH StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2022 - all rights reserved
6 @notice Curve ETH pool implementation
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 interface CurveToken:
12     def totalSupply() -> uint256: view
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
79 N_COINS: constant(uint256) = 2
80 N_COINS_128: constant(int128) = 2
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
114 ma_price: uint256
115 ma_exp_time: public(uint256)
116 ma_last_time: public(uint256)
117 
118 is_killed: bool
119 kill_deadline: uint256
120 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
121 
122 
123 @external
124 def __init__(
125     _owner: address,
126     _coins: address[N_COINS],
127     _pool_token: address,
128     _A: uint256,
129     _fee: uint256,
130     _admin_fee: uint256
131 ):
132     """
133     @notice Contract constructor
134     @param _owner Contract owner address
135     @param _coins Addresses of ERC20 conracts of coins
136     @param _pool_token Address of the token representing LP share
137     @param _A Amplification coefficient multiplied by n * (n - 1)
138     @param _fee Fee to charge for exchanges
139     @param _admin_fee Admin fee
140     """
141     for i in range(N_COINS):
142         assert _coins[i] != empty(address)
143     self.coins = _coins
144     self.initial_A = _A * A_PRECISION
145     self.future_A = _A * A_PRECISION
146     self.fee = _fee
147     self.admin_fee = _admin_fee
148     self.owner = _owner
149     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
150     self.lp_token = _pool_token
151 
152     self.ma_exp_time = 2597  # = 1800 / ln(2)  # 30 mins
153     self.ma_price = 10**18
154     self.ma_last_time = block.timestamp
155 
156 
157 @view
158 @internal
159 def _A() -> uint256:
160     """
161     Handle ramping A up or down
162     """
163     t1: uint256 = self.future_A_time
164     A1: uint256 = self.future_A
165 
166     if block.timestamp < t1:
167         A0: uint256 = self.initial_A
168         t0: uint256 = self.initial_A_time
169         # Expressions in uint256 cannot have negative numbers, thus "if"
170         if A1 > A0:
171             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
172         else:
173             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
174 
175     else:  # when t1 == 0 or block.timestamp >= t1
176         return A1
177 
178 
179 @view
180 @external
181 def A() -> uint256:
182     return self._A() / A_PRECISION
183 
184 
185 @view
186 @external
187 def A_precise() -> uint256:
188     return self._A()
189 
190 
191 @pure
192 @internal
193 def _get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
194     """
195     D invariant calculation in non-overflowing integer operations
196     iteratively
197 
198     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
199 
200     Converging solution:
201     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
202     """
203     S: uint256 = 0
204     Dprev: uint256 = 0
205 
206     for _x in _xp:
207         S += _x
208     if S == 0:
209         return 0
210 
211     D: uint256 = S
212     Ann: uint256 = _amp * N_COINS
213     for _i in range(255):
214         D_P: uint256 = D
215         for _x in _xp:
216             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
217         Dprev = D
218         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
219         # Equality with the precision of 1
220         if D > Dprev:
221             if D - Dprev <= 1:
222                 return D
223         else:
224             if Dprev - D <= 1:
225                 return D
226     # convergence typically occurs in 4 rounds or less, this should be unreachable!
227     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
228     raise
229 
230 
231 @internal
232 @view
233 def _get_p(xp: uint256[N_COINS], amp: uint256, D: uint256) -> uint256:
234     # dx_0 / dx_1 only, however can have any number of coins in pool
235     ANN: uint256 = amp * N_COINS
236     Dr: uint256 = D / (N_COINS**N_COINS)
237     for i in range(N_COINS):
238         Dr = Dr * D / xp[i]
239     return 10**18 * (ANN * xp[0] / A_PRECISION + Dr * xp[0] / xp[1]) / (ANN * xp[0] / A_PRECISION + Dr)
240 
241 
242 @external
243 @view
244 @nonreentrant('lock')
245 def get_p() -> uint256:
246     amp: uint256 = self._A()
247     xp: uint256[N_COINS] = self.balances
248     D: uint256 = self._get_D(xp, amp)
249     return self._get_p(xp, amp, D)
250 
251 
252 @internal
253 @view
254 def exp(power: int256) -> uint256:
255     # courtesy of solmate
256     # https://github.com/transmissions11/solmate/blob/master/src/utils/SignedWadMath.sol#L83
257     if power <= -42139678854452767551:
258         return 0
259 
260     if power >= 135305999368893231589:
261         raise "exp overflow"
262 
263     x: int256 = unsafe_div(unsafe_mul(power, 2**96), 10**18)
264 
265     k: int256 = unsafe_div(
266         unsafe_add(
267             unsafe_div(unsafe_mul(x, 2**96), 54916777467707473351141471128),
268             2**95),
269         2**96)
270     x = unsafe_sub(x, unsafe_mul(k, 54916777467707473351141471128))
271 
272     y: int256 = unsafe_add(x, 1346386616545796478920950773328)
273     y = unsafe_add(unsafe_div(unsafe_mul(y, x), 2**96), 57155421227552351082224309758442)
274     p: int256 = unsafe_sub(unsafe_add(y, x), 94201549194550492254356042504812)
275     p = unsafe_add(unsafe_div(unsafe_mul(p, y), 2**96), 28719021644029726153956944680412240)
276     p = unsafe_add(unsafe_mul(p, x), (4385272521454847904659076985693276 * 2**96))
277 
278     q: int256 = unsafe_sub(x, 2855989394907223263936484059900)
279     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 50020603652535783019961831881945)
280     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 533845033583426703283633433725380)
281     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 3604857256930695427073651918091429)
282     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 14423608567350463180887372962807573)
283     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 26449188498355588339934803723976023)
284 
285     return unsafe_div(
286         unsafe_mul(convert(unsafe_div(p, q), uint256), 3822833074963236453042738258902158003155416615667),
287         pow_mod256(2, convert(unsafe_sub(195, k), uint256))
288     )
289 
290 
291 @internal
292 @view
293 def _ma_price(xp: uint256[N_COINS], amp: uint256, D: uint256) -> uint256:
294     p: uint256 = self._get_p(xp, amp, D)
295     ema_mul: uint256 = self.exp(-convert((block.timestamp - self.ma_last_time) * 10**18 / self.ma_exp_time, int256))
296     return (self.ma_price * ema_mul + p * (10**18 - ema_mul)) / 10**18
297 
298 
299 @external
300 @view
301 @nonreentrant('lock')
302 def price_oracle() -> uint256:
303     amp: uint256 = self._A()
304     xp: uint256[N_COINS] = self.balances
305     D: uint256 = self._get_D(xp, amp)
306     return self._ma_price(xp, amp, D)
307 
308 
309 @internal
310 def save_p(xp: uint256[N_COINS], amp: uint256, D: uint256):
311     """
312     Saves current price and its EMA
313     """
314     self.ma_price = self._ma_price(xp, amp, D)
315     self.ma_last_time = block.timestamp
316 
317 
318 @view
319 @external
320 @nonreentrant('lock')
321 def get_virtual_price() -> uint256:
322     """
323     @notice The current virtual price of the pool LP token
324     @dev Useful for calculating profits
325     @return LP token virtual price normalized to 1e18
326     """
327     D: uint256 = self._get_D(self.balances, self._A())
328     # D is in the units similar to DAI (e.g. converted to precision 1e18)
329     # When balanced, D = n * x_u - total virtual value of the portfolio
330     token_supply: uint256 = ERC20(self.lp_token).totalSupply()
331     return D * PRECISION / token_supply
332 
333 
334 @view
335 @external
336 @nonreentrant('lock')
337 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
338     """
339     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
340     @dev This calculation accounts for slippage, but not fees.
341          Needed to prevent front-running, not for precise calculations!
342     @param _amounts Amount of each coin being deposited
343     @param _is_deposit set True for deposits, False for withdrawals
344     @return Expected amount of LP tokens received
345     """
346     amp: uint256 = self._A()
347     balances: uint256[N_COINS] = self.balances
348     D0: uint256 = self._get_D(balances, amp)
349     for i in range(N_COINS):
350         if _is_deposit:
351             balances[i] += _amounts[i]
352         else:
353             balances[i] -= _amounts[i]
354     D1: uint256 = self._get_D(balances, amp)
355     token_amount: uint256 = CurveToken(self.lp_token).totalSupply()
356     diff: uint256 = 0
357     if _is_deposit:
358         diff = D1 - D0
359     else:
360         diff = D0 - D1
361     return diff * token_amount / D0
362 
363 
364 @payable
365 @external
366 @nonreentrant('lock')
367 def add_liquidity(_amounts: uint256[N_COINS], _min_mint_amount: uint256) -> uint256:
368     """
369     @notice Deposit coins into the pool
370     @param _amounts List of amounts of coins to deposit
371     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
372     @return Amount of LP tokens received by depositing
373     """
374     assert not self.is_killed  # dev: is killed
375 
376     amp: uint256 = self._A()
377     old_balances: uint256[N_COINS] = self.balances
378     
379     # Initial invariant
380     D0: uint256 = self._get_D(old_balances, amp)
381 
382     lp_token: address = self.lp_token
383     token_supply: uint256 = ERC20(lp_token).totalSupply()
384     new_balances: uint256[N_COINS] = empty(uint256[N_COINS])
385     for i in range(N_COINS):
386         if token_supply == 0:
387             assert _amounts[i] > 0  # dev: initial deposit requires all coins
388         new_balances[i] = old_balances[i] + _amounts[i]
389 
390     # Invariant after change
391     D1: uint256 = self._get_D(new_balances, amp)
392     assert D1 > D0
393 
394     # We need to recalculate the invariant accounting for fees
395     # to calculate fair user's share
396     fees: uint256[N_COINS] = empty(uint256[N_COINS])
397     mint_amount: uint256 = 0
398     D2: uint256 = D1
399     if token_supply > 0:
400         # Only account for fees if we are not the first to deposit
401         fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
402         admin_fee: uint256 = self.admin_fee
403         for i in range(N_COINS):
404             ideal_balance: uint256 = D1 * old_balances[i] / D0
405             difference: uint256 = 0
406             if ideal_balance > new_balances[i]:
407                 difference = ideal_balance - new_balances[i]
408             else:
409                 difference = new_balances[i] - ideal_balance
410             fees[i] = fee * difference / FEE_DENOMINATOR
411             self.balances[i] = new_balances[i] - (fees[i] * admin_fee / FEE_DENOMINATOR)
412             new_balances[i] -= fees[i]
413         D2 = self._get_D(new_balances, amp)
414         mint_amount = token_supply * (D2 - D0) / D0
415         self.save_p(new_balances, amp, D2)
416     else:
417         self.balances = new_balances
418         mint_amount = D1  # Take the dust if there was any
419 
420     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
421 
422     # Take coins from the sender
423     for i in range(N_COINS):
424         coin: address = self.coins[i]
425         amount: uint256 = _amounts[i]
426         if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
427             assert msg.value == amount
428         elif amount > 0:
429             assert ERC20(coin).transferFrom(msg.sender, self, amount, default_return_value=True)
430 
431     # Mint pool tokens
432     CurveToken(lp_token).mint(msg.sender, mint_amount)
433 
434     log AddLiquidity(msg.sender, _amounts, fees, D1, token_supply + mint_amount)
435 
436     return mint_amount
437 
438 
439 @view
440 @internal
441 def _get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
442     """
443     Calculate x[j] if one makes x[i] = x
444 
445     Done by solving quadratic equation iteratively.
446     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
447     x_1**2 + b*x_1 = c
448 
449     x_1 = (x_1**2 + c) / (2*x_1 + b)
450     """
451     # x in the input is converted to the same price/precision
452 
453     assert i != j       # dev: same coin
454     assert j >= 0       # dev: j below zero
455     assert j < N_COINS_128  # dev: j above N_COINS
456 
457     # should be unreachable, but good for safety
458     assert i >= 0
459     assert i < N_COINS_128
460 
461     A: uint256 = self._A()
462     D: uint256 = self._get_D(_xp, A)
463     Ann: uint256 = A * N_COINS
464     c: uint256 = D
465     S: uint256 = 0
466     _x: uint256 = 0
467     y_prev: uint256 = 0
468 
469     for _i in range(N_COINS_128):
470         if _i == i:
471             _x = x
472         elif _i != j:
473             _x = _xp[_i]
474         else:
475             continue
476         S += _x
477         c = c * D / (_x * N_COINS)
478     c = c * D * A_PRECISION / (Ann * N_COINS)
479     b: uint256 = S + D * A_PRECISION / Ann  # - D
480     y: uint256 = D
481     for _i in range(255):
482         y_prev = y
483         y = (y*y + c) / (2 * y + b - D)
484         # Equality with the precision of 1
485         if y > y_prev:
486             if y - y_prev <= 1:
487                 return y
488         else:
489             if y_prev - y <= 1:
490                 return y
491     raise
492 
493 
494 @view
495 @external
496 @nonreentrant('lock')
497 def get_dy(i: int128, j: int128, _dx: uint256) -> uint256:
498     xp: uint256[N_COINS] = self.balances
499     x: uint256 = xp[i] + _dx
500     y: uint256 = self._get_y(i, j, x, xp)
501     dy: uint256 = xp[j] - y - 1
502     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
503     return dy - fee
504 
505 
506 @payable
507 @external
508 @nonreentrant('lock')
509 def exchange(i: int128, j: int128, _dx: uint256, _min_dy: uint256) -> uint256:
510     """
511     @notice Perform an exchange between two coins
512     @dev Index values can be found via the `coins` public getter method
513     @param i Index value for the coin to send
514     @param j Index valie of the coin to recieve
515     @param _dx Amount of `i` being exchanged
516     @param _min_dy Minimum amount of `j` to receive
517     @return Actual amount of `j` received
518     """
519     assert not self.is_killed  # dev: is killed
520 
521     old_balances: uint256[N_COINS] = self.balances
522 
523     x: uint256 = old_balances[i] + _dx
524 
525     amp: uint256 = self._A()
526     D: uint256 = self._get_D(old_balances, amp)
527     y: uint256 = self._get_y(i, j, x, old_balances)
528 
529     dy: uint256 = old_balances[j] - y - 1  # -1 just in case there were some rounding errors
530     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
531 
532     # Convert all to real units
533     dy = dy - dy_fee
534     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
535 
536     xp: uint256[N_COINS] = old_balances
537     xp[i] = x
538     xp[j] = y
539 
540     self.save_p(xp, amp, D)
541 
542     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
543 
544     # Change balances exactly in same way as we change actual ERC20 coin amounts
545     self.balances[i] = old_balances[i] + _dx
546     # When rounding errors happen, we undercharge admin fee in favor of LP
547     self.balances[j] = old_balances[j] - dy - dy_admin_fee
548 
549     coin: address = self.coins[i]
550     if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
551         assert msg.value == _dx
552     else:
553         assert msg.value == 0
554         assert ERC20(coin).transferFrom(msg.sender, self, _dx, default_return_value=True)
555 
556     coin = self.coins[j]
557     if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
558         raw_call(msg.sender, b"", value=dy)
559     else:
560         assert ERC20(coin).transfer(msg.sender, dy, default_return_value=True)
561 
562     log TokenExchange(msg.sender, i, _dx, j, dy)
563 
564     return dy
565 
566 
567 @external
568 @nonreentrant('lock')
569 def remove_liquidity(_amount: uint256, _min_amounts: uint256[N_COINS]) -> uint256[N_COINS]:
570     """
571     @notice Withdraw coins from the pool
572     @dev Withdrawal amounts are based on current deposit ratios
573     @param _amount Quantity of LP tokens to burn in the withdrawal
574     @param _min_amounts Minimum amounts of underlying coins to receive
575     @return List of amounts of coins that were withdrawn
576     """
577     lp_token: address = self.lp_token
578     total_supply: uint256 = CurveToken(lp_token).totalSupply()
579     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
580 
581     for i in range(N_COINS):
582         old_balance: uint256 = self.balances[i]
583         value: uint256 = old_balance * _amount / total_supply
584         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
585         self.balances[i] = old_balance - value
586         amounts[i] = value
587         coin: address = self.coins[i]
588         if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
589             raw_call(msg.sender, b"", value=value)
590         else:
591             assert ERC20(coin).transfer(msg.sender, value, default_return_value=True)
592 
593     CurveToken(lp_token).burnFrom(msg.sender, _amount)  # dev: insufficient funds
594 
595     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply - _amount)
596 
597     return amounts
598 
599 
600 @external
601 @nonreentrant('lock')
602 def remove_liquidity_imbalance(_amounts: uint256[N_COINS], _max_burn_amount: uint256) -> uint256:
603     """
604     @notice Withdraw coins from the pool in an imbalanced amount
605     @param _amounts List of amounts of underlying coins to withdraw
606     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
607     @return Actual amount of the LP token burned in the withdrawal
608     """
609     assert not self.is_killed  # dev: is killed
610 
611     amp: uint256 = self._A()
612     old_balances: uint256[N_COINS] = self.balances
613     D0: uint256 = self._get_D(old_balances, amp)
614     new_balances: uint256[N_COINS] = empty(uint256[N_COINS])
615     for i in range(N_COINS):
616         new_balances[i] = old_balances[i] - _amounts[i]
617     D1: uint256 = self._get_D(new_balances, amp)
618 
619     fees: uint256[N_COINS] = empty(uint256[N_COINS])
620     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
621     admin_fee: uint256 = self.admin_fee
622     for i in range(N_COINS):
623         new_balance: uint256 = new_balances[i]
624         ideal_balance: uint256 = D1 * old_balances[i] / D0
625         difference: uint256 = 0
626         if ideal_balance > new_balance:
627             difference = ideal_balance - new_balance
628         else:
629             difference = new_balance - ideal_balance
630         fees[i] = fee * difference / FEE_DENOMINATOR
631         self.balances[i] = new_balance - (fees[i] * admin_fee / FEE_DENOMINATOR)
632         new_balances[i] = new_balance - fees[i]
633     D2: uint256 = self._get_D(new_balances, amp)
634 
635     self.save_p(new_balances, amp, D2)
636 
637     lp_token: address = self.lp_token
638     token_supply: uint256 = CurveToken(lp_token).totalSupply()
639     token_amount: uint256 = (D0 - D2) * token_supply / D0
640     assert token_amount != 0  # dev: zero tokens burned
641     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
642     assert token_amount <= _max_burn_amount, "Slippage screwed you"
643 
644     CurveToken(lp_token).burnFrom(msg.sender, token_amount)  # dev: insufficient funds
645     for i in range(N_COINS):
646         amount: uint256 = _amounts[i]
647         if amount != 0:
648             coin: address = self.coins[i]
649             if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
650                 raw_call(msg.sender, b"", value=amount)
651             else:
652                 assert ERC20(coin).transfer(msg.sender, amount, default_return_value=True)
653 
654     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, token_supply - token_amount)
655 
656     return token_amount
657 
658 
659 @pure
660 @internal
661 def _get_y_D(A: uint256, i: int128, _xp: uint256[N_COINS], D: uint256) -> uint256:
662     """
663     Calculate x[i] if one reduces D from being calculated for xp to D
664 
665     Done by solving quadratic equation iteratively.
666     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
667     x_1**2 + b*x_1 = c
668 
669     x_1 = (x_1**2 + c) / (2*x_1 + b)
670     """
671     # x in the input is converted to the same price/precision
672 
673     assert i >= 0  # dev: i below zero
674     assert i < N_COINS_128  # dev: i above N_COINS
675 
676     Ann: uint256 = A * N_COINS
677     c: uint256 = D
678     S: uint256 = 0
679     _x: uint256 = 0
680     y_prev: uint256 = 0
681     
682     for _i in range(N_COINS_128):
683         if _i != i:
684             _x = _xp[_i]
685         else:
686             continue
687         S += _x
688         c = c * D / (_x * N_COINS)
689     c = c * D * A_PRECISION / (Ann * N_COINS)
690     b: uint256 = S + D * A_PRECISION / Ann
691     y: uint256 = D
692 
693     for _i in range(255):
694         y_prev = y
695         y = (y*y + c) / (2 * y + b - D)
696         # Equality with the precision of 1
697         if y > y_prev:
698             if y - y_prev <= 1:
699                 return y
700         else:
701             if y_prev - y <= 1:
702                 return y
703     raise
704 
705 
706 @view
707 @internal
708 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256, uint256, uint256):
709     # First, need to calculate
710     # * Get current D
711     # * Solve Eqn against y_i for D - _token_amount
712     amp: uint256 = self._A()
713     xp: uint256[N_COINS] = self.balances
714     D0: uint256 = self._get_D(xp, amp)
715     total_supply: uint256 = CurveToken(self.lp_token).totalSupply()
716     D1: uint256 = D0 - _token_amount * D0 / total_supply
717     new_y: uint256 = self._get_y_D(amp, i, xp, D1)
718     fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
719     xp_reduced: uint256[N_COINS] = xp
720     for j in range(N_COINS_128):
721         dx_expected: uint256 = 0
722         if j == i:
723             dx_expected = xp[j] * D1 / D0 - new_y
724         else:
725             dx_expected = xp[j] - xp[j] * D1 / D0
726         xp_reduced[j] -= fee * dx_expected / FEE_DENOMINATOR
727 
728     dy: uint256 = xp_reduced[i] - self._get_y_D(amp, i, xp_reduced, D1)
729 
730     dy -= 1  # Withdraw less to account for rounding errors
731     dy_0: uint256 = xp[i] - new_y  # w/o fees
732 
733     xp[i] = new_y
734     ma_p: uint256 = 0
735     if new_y > 0:
736         ma_p = self._ma_price(xp, amp, D1)
737 
738     return dy, dy_0 - dy, total_supply, ma_p
739 
740 
741 @view
742 @external
743 @nonreentrant('lock')
744 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
745     """
746     @notice Calculate the amount received when withdrawing a single coin
747     @param _token_amount Amount of LP tokens to burn in the withdrawal
748     @param i Index value of the coin to withdraw
749     @return Amount of coin received
750     """
751     return self._calc_withdraw_one_coin(_token_amount, i)[0]
752 
753 
754 @external
755 @nonreentrant('lock')
756 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
757     """
758     @notice Withdraw a single coin from the pool
759     @param _token_amount Amount of LP tokens to burn in the withdrawal
760     @param i Index value of the coin to withdraw
761     @param _min_amount Minimum amount of coin to receive
762     @return Amount of coin received
763     """
764     assert not self.is_killed  # dev: is killed
765 
766     dy: uint256 = 0
767     dy_fee: uint256 = 0
768     total_supply: uint256 = 0
769     ma_p: uint256 = 0
770     dy, dy_fee, total_supply, ma_p = self._calc_withdraw_one_coin(_token_amount, i)
771     assert dy >= _min_amount, "Not enough coins removed"
772 
773     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
774     CurveToken(self.lp_token).burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
775 
776     coin: address = self.coins[i]
777     if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
778         raw_call(msg.sender, b"", value=dy)
779     else:
780         assert ERC20(coin).transfer(msg.sender, dy, default_return_value=True)
781 
782     log RemoveLiquidityOne(msg.sender, _token_amount, dy, total_supply - _token_amount)
783 
784     self.ma_price = ma_p
785     self.ma_last_time = block.timestamp
786 
787     return dy
788 
789 
790 ### Admin functions ###
791 @external
792 def ramp_A(_future_A: uint256, _future_time: uint256):
793     assert msg.sender == self.owner  # dev: only owner
794     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
795     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
796 
797     initial_A: uint256 = self._A()
798     future_A_p: uint256 = _future_A * A_PRECISION
799 
800     assert _future_A > 0 and _future_A < MAX_A
801     if future_A_p < initial_A:
802         assert future_A_p * MAX_A_CHANGE >= initial_A
803     else:
804         assert future_A_p <= initial_A * MAX_A_CHANGE
805 
806     self.initial_A = initial_A
807     self.future_A = future_A_p
808     self.initial_A_time = block.timestamp
809     self.future_A_time = _future_time
810 
811     log RampA(initial_A, future_A_p, block.timestamp, _future_time)
812 
813 
814 @external
815 def stop_ramp_A():
816     assert msg.sender == self.owner  # dev: only owner
817 
818     current_A: uint256 = self._A()
819     self.initial_A = current_A
820     self.future_A = current_A
821     self.initial_A_time = block.timestamp
822     self.future_A_time = block.timestamp
823     # now (block.timestamp < t1) is always False, so we return saved A
824 
825     log StopRampA(current_A, block.timestamp)
826 
827 
828 @external
829 def commit_new_fee(_new_fee: uint256, _new_admin_fee: uint256):
830     assert msg.sender == self.owner  # dev: only owner
831     assert self.admin_actions_deadline == 0  # dev: active action
832     assert _new_fee <= MAX_FEE  # dev: fee exceeds maximum
833     assert _new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
834 
835     deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
836     self.admin_actions_deadline = deadline
837     self.future_fee = _new_fee
838     self.future_admin_fee = _new_admin_fee
839 
840     log CommitNewFee(deadline, _new_fee, _new_admin_fee)
841 
842 
843 @external
844 def apply_new_fee():
845     assert msg.sender == self.owner  # dev: only owner
846     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
847     assert self.admin_actions_deadline != 0  # dev: no active action
848 
849     self.admin_actions_deadline = 0
850     fee: uint256 = self.future_fee
851     admin_fee: uint256 = self.future_admin_fee
852     self.fee = fee
853     self.admin_fee = admin_fee
854 
855     log NewFee(fee, admin_fee)
856 
857 
858 @external
859 def revert_new_parameters():
860     assert msg.sender == self.owner  # dev: only owner
861 
862     self.admin_actions_deadline = 0
863 
864 
865 @external
866 def set_ma_exp_time(_ma_exp_time: uint256):
867     assert msg.sender == self.owner
868     assert _ma_exp_time != 0
869 
870     self.ma_exp_time = _ma_exp_time
871 
872 
873 @external
874 def commit_transfer_ownership(_owner: address):
875     assert msg.sender == self.owner  # dev: only owner
876     assert self.transfer_ownership_deadline == 0  # dev: active transfer
877 
878     deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
879     self.transfer_ownership_deadline = deadline
880     self.future_owner = _owner
881 
882     log CommitNewAdmin(deadline, _owner)
883 
884 
885 @external
886 def apply_transfer_ownership():
887     assert msg.sender == self.owner  # dev: only owner
888     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
889     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
890 
891     self.transfer_ownership_deadline = 0
892     owner: address = self.future_owner
893     self.owner = owner
894 
895     log NewAdmin(owner)
896 
897 
898 @external
899 def revert_transfer_ownership():
900     assert msg.sender == self.owner  # dev: only owner
901 
902     self.transfer_ownership_deadline = 0
903 
904 
905 @view
906 @external
907 def admin_balances(i: uint256) -> uint256:
908     coin: address = self.coins[i]
909     if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
910         return self.balance - self.balances[i]
911     else:
912         return ERC20(coin).balanceOf(self) - self.balances[i]
913 
914 
915 @external
916 def withdraw_admin_fees():
917     assert msg.sender == self.owner  # dev: only owner
918 
919     for i in range(N_COINS):
920         coin: address = self.coins[i]
921         if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
922             value: uint256 = self.balance - self.balances[i]
923             if value > 0:
924                 raw_call(msg.sender, b"", value=value)
925         else:
926             value: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
927             if value > 0:
928                 assert ERC20(coin).transfer(msg.sender, value, default_return_value=True)
929 
930 
931 @external
932 def donate_admin_fees():
933     assert msg.sender == self.owner  # dev: only owner
934     for i in range(N_COINS):
935         coin: address = self.coins[i]
936         if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
937             self.balances[i] = self.balance
938         else:
939             self.balances[i] = ERC20(coin).balanceOf(self)
940 
941 
942 @external
943 def kill_me():
944     assert msg.sender == self.owner  # dev: only owner
945     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
946     self.is_killed = True
947 
948 
949 @external
950 def unkill_me():
951     assert msg.sender == self.owner  # dev: only owner
952     self.is_killed = False