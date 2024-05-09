1 # @version 0.2.4
2 # (c) Curve.Fi, 2020
3 # Pool for hBTC/wBTC
4 
5 from vyper.interfaces import ERC20
6 
7 interface CurveToken:
8     def set_minter(_minter: address): nonpayable
9     def set_name(_name: String[64], _symbol: String[32]): nonpayable
10     def totalSupply() -> uint256: view
11     def allowance(_owner: address, _spender: address) -> uint256: view
12     def transfer(_to: address, _value: uint256) -> bool: nonpayable
13     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: nonpayable
14     def approve(_spender: address, _value: uint256) -> bool: nonpayable
15     def mint(_to: address, _value: uint256) -> bool: nonpayable
16     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
17     def name() -> String[64]: view
18     def symbol() -> String[32]: view
19     def decimals() -> uint256: view
20     def balanceOf(arg0: address) -> uint256: view
21 
22 
23 # Events
24 event TokenExchange:
25     buyer: indexed(address)
26     sold_id: int128
27     tokens_sold: uint256
28     bought_id: int128
29     tokens_bought: uint256
30 
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
49 
50 event RemoveLiquidityImbalance:
51     provider: indexed(address)
52     token_amounts: uint256[N_COINS]
53     fees: uint256[N_COINS]
54     invariant: uint256
55     token_supply: uint256
56 
57 event CommitNewAdmin:
58     deadline: indexed(uint256)
59     admin: indexed(address)
60 
61 event NewAdmin:
62     admin: indexed(address)
63 
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
85 # This can (and needs to) be changed at compile time
86 N_COINS: constant(int128) = 2  # <- change
87 
88 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
89 LENDING_PRECISION: constant(uint256) = 10 ** 18
90 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
91 PRECISION_MUL: constant(uint256[N_COINS]) = [1, 10000000000]
92 RATES: constant(uint256[N_COINS]) = [1000000000000000000, 10000000000000000000000000000]
93 # PRECISION_MUL: constant(uint256[N_COINS]) = [
94 #     PRECISION / convert(PRECISION, uint256),  # DAI
95 #     PRECISION / convert(10 ** 6, uint256),   # USDC
96 #     PRECISION / convert(10 ** 6, uint256)]   # USDT
97 
98 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
99 MAX_FEE: constant(uint256) = 5 * 10 ** 9
100 MAX_A: constant(uint256) = 10 ** 6
101 MAX_A_CHANGE: constant(uint256) = 10
102 
103 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
104 MIN_RAMP_TIME: constant(uint256) = 86400
105 
106 coins: public(address[N_COINS])
107 balances: public(uint256[N_COINS])
108 fee: public(uint256)  # fee * 1e10
109 admin_fee: public(uint256)  # admin_fee * 1e10
110 
111 owner: public(address)
112 token: CurveToken
113 
114 initial_A: public(uint256)
115 future_A: public(uint256)
116 initial_A_time: public(uint256)
117 future_A_time: public(uint256)
118 
119 admin_actions_deadline: public(uint256)
120 transfer_ownership_deadline: public(uint256)
121 future_fee: public(uint256)
122 future_admin_fee: public(uint256)
123 future_owner: public(address)
124 
125 is_killed: bool
126 kill_deadline: uint256
127 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
128 
129 
130 @external
131 def __init__(
132     _owner: address,
133     _coins: address[N_COINS],
134     _pool_token: address,
135     _A: uint256,
136     _fee: uint256,
137     _admin_fee: uint256
138 ):
139     """
140     @notice Contract constructor
141     @param _owner Contract owner address
142     @param _coins Addresses of ERC20 conracts of coins
143     @param _pool_token Address of the token representing LP share
144     @param _A Amplification coefficient multiplied by n * (n - 1)
145     @param _fee Fee to charge for exchanges
146     @param _admin_fee Admin fee
147     """
148     for i in range(N_COINS):
149         assert _coins[i] != ZERO_ADDRESS
150     self.coins = _coins
151     self.initial_A = _A
152     self.future_A = _A
153     self.fee = _fee
154     self.admin_fee = _admin_fee
155     self.owner = _owner
156     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
157     self.token = CurveToken(_pool_token)
158 
159 
160 @view
161 @internal
162 def _A() -> uint256:
163     """
164     Handle ramping A up or down
165     """
166     t1: uint256 = self.future_A_time
167     A1: uint256 = self.future_A
168 
169     if block.timestamp < t1:
170         A0: uint256 = self.initial_A
171         t0: uint256 = self.initial_A_time
172         # Expressions in uint256 cannot have negative numbers, thus "if"
173         if A1 > A0:
174             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
175         else:
176             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
177 
178     else:  # when t1 == 0 or block.timestamp >= t1
179         return A1
180 
181 
182 @view
183 @external
184 def A() -> uint256:
185     return self._A()
186 
187 
188 @view
189 @internal
190 def _xp() -> uint256[N_COINS]:
191     result: uint256[N_COINS] = RATES
192     for i in range(N_COINS):
193         result[i] = result[i] * self.balances[i] / LENDING_PRECISION
194     return result
195 
196 
197 @pure
198 @internal
199 def _xp_mem(_balances: uint256[N_COINS]) -> uint256[N_COINS]:
200     result: uint256[N_COINS] = RATES
201     for i in range(N_COINS):
202         result[i] = result[i] * _balances[i] / PRECISION
203     return result
204 
205 
206 @pure
207 @internal
208 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
209     S: uint256 = 0
210     for _x in xp:
211         S += _x
212     if S == 0:
213         return 0
214 
215     Dprev: uint256 = 0
216     D: uint256 = S
217     Ann: uint256 = amp * N_COINS
218     for _i in range(255):
219         D_P: uint256 = D
220         for _x in xp:
221             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
222         Dprev = D
223         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
224         # Equality with the precision of 1
225         if D > Dprev:
226             if D - Dprev <= 1:
227                 break
228         else:
229             if Dprev - D <= 1:
230                 break
231     return D
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
244     Returns portfolio virtual price (for calculating profit)
245     scaled up by 1e18
246     """
247     D: uint256 = self.get_D(self._xp(), self._A())
248     # D is in the units similar to DAI (e.g. converted to precision 1e18)
249     # When balanced, D = n * x_u - total virtual value of the portfolio
250     token_supply: uint256 = self.token.totalSupply()
251     return D * PRECISION / token_supply
252 
253 
254 @view
255 @external
256 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
257     """
258     Simplified method to calculate addition or reduction in token supply at
259     deposit or withdrawal without taking fees into account (but looking at
260     slippage).
261     Needed to prevent front-running, not for precise calculations!
262     """
263     _balances: uint256[N_COINS] = self.balances
264     amp: uint256 = self._A()
265     D0: uint256 = self.get_D_mem(_balances, amp)
266     for i in range(N_COINS):
267         if deposit:
268             _balances[i] += amounts[i]
269         else:
270             _balances[i] -= amounts[i]
271     D1: uint256 = self.get_D_mem(_balances, amp)
272     token_amount: uint256 = self.token.totalSupply()
273     diff: uint256 = 0
274     if deposit:
275         diff = D1 - D0
276     else:
277         diff = D0 - D1
278     return diff * token_amount / D0
279 
280 
281 @external
282 @nonreentrant('lock')
283 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
284     assert not self.is_killed  # dev: is killed
285 
286     fees: uint256[N_COINS] = empty(uint256[N_COINS])
287     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
288     _admin_fee: uint256 = self.admin_fee
289     amp: uint256 = self._A()
290 
291     token_supply: uint256 = self.token.totalSupply()
292     # Initial invariant
293     D0: uint256 = 0
294     old_balances: uint256[N_COINS] = self.balances
295     if token_supply > 0:
296         D0 = self.get_D_mem(old_balances, amp)
297     new_balances: uint256[N_COINS] = old_balances
298 
299     for i in range(N_COINS):
300         if token_supply == 0:
301             assert amounts[i] > 0  # dev: initial deposit requires all coins
302         # balances store amounts of c-tokens
303         new_balances[i] = old_balances[i] + amounts[i]
304 
305     # Invariant after change
306     D1: uint256 = self.get_D_mem(new_balances, amp)
307     assert D1 > D0
308 
309     # We need to recalculate the invariant accounting for fees
310     # to calculate fair user's share
311     D2: uint256 = D1
312     if token_supply > 0:
313         # Only account for fees if we are not the first to deposit
314         for i in range(N_COINS):
315             ideal_balance: uint256 = D1 * old_balances[i] / D0
316             difference: uint256 = 0
317             if ideal_balance > new_balances[i]:
318                 difference = ideal_balance - new_balances[i]
319             else:
320                 difference = new_balances[i] - ideal_balance
321             fees[i] = _fee * difference / FEE_DENOMINATOR
322             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
323             new_balances[i] -= fees[i]
324         D2 = self.get_D_mem(new_balances, amp)
325     else:
326         self.balances = new_balances
327 
328     # Calculate, how much pool tokens to mint
329     mint_amount: uint256 = 0
330     if token_supply == 0:
331         mint_amount = D1  # Take the dust if there was any
332     else:
333         mint_amount = token_supply * (D2 - D0) / D0
334 
335     assert mint_amount >= min_mint_amount, "Slippage screwed you"
336 
337     # Take coins from the sender
338     for i in range(N_COINS):
339         if amounts[i] > 0:
340             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i])  # dev: failed transfer
341 
342     # Mint pool tokens
343     self.token.mint(msg.sender, mint_amount)
344 
345     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
346 
347 
348 @view
349 @internal
350 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
351     # x in the input is converted to the same price/precision
352 
353     assert i != j       # dev: same coin
354     assert j >= 0       # dev: j below zero
355     assert j < N_COINS  # dev: j above N_COINS
356 
357     # should be unreachable, but good for safety
358     assert i >= 0
359     assert i < N_COINS
360 
361     amp: uint256 = self._A()
362     D: uint256 = self.get_D(xp_, amp)
363     c: uint256 = D
364     S_: uint256 = 0
365     Ann: uint256 = amp * N_COINS
366 
367     _x: uint256 = 0
368     for _i in range(N_COINS):
369         if _i == i:
370             _x = x
371         elif _i != j:
372             _x = xp_[_i]
373         else:
374             continue
375         S_ += _x
376         c = c * D / (_x * N_COINS)
377     c = c * D / (Ann * N_COINS)
378     b: uint256 = S_ + D / Ann  # - D
379     y_prev: uint256 = 0
380     y: uint256 = D
381     for _i in range(255):
382         y_prev = y
383         y = (y*y + c) / (2 * y + b - D)
384         # Equality with the precision of 1
385         if y > y_prev:
386             if y - y_prev <= 1:
387                 break
388         else:
389             if y_prev - y <= 1:
390                 break
391     return y
392 
393 
394 @view
395 @external
396 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
397     # dx and dy in c-units
398     rates: uint256[N_COINS] = RATES
399     xp: uint256[N_COINS] = self._xp()
400 
401     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
402     y: uint256 = self.get_y(i, j, x, xp)
403     dy: uint256 = (xp[j] - y - 1) * PRECISION / rates[j]
404     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
405     return dy - _fee
406 
407 
408 @view
409 @external
410 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
411     # dx and dy in underlying units
412     xp: uint256[N_COINS] = self._xp()
413     precisions: uint256[N_COINS] = PRECISION_MUL
414 
415     x: uint256 = xp[i] + dx * precisions[i]
416     y: uint256 = self.get_y(i, j, x, xp)
417     dy: uint256 = (xp[j] - y - 1) / precisions[j]
418     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
419     return dy - _fee
420 
421 
422 
423 @external
424 @nonreentrant('lock')
425 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256):
426     assert not self.is_killed  # dev: is killed
427     rates: uint256[N_COINS] = RATES
428 
429     old_balances: uint256[N_COINS] = self.balances
430     xp: uint256[N_COINS] = self._xp_mem(old_balances)
431 
432     x: uint256 = xp[i] + dx * rates[i] / PRECISION
433     y: uint256 = self.get_y(i, j, x, xp)
434 
435     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
436     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
437 
438     # Convert all to real units
439     dy = (dy - dy_fee) * PRECISION / rates[j]
440     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
441 
442     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
443     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
444 
445     # Change balances exactly in same way as we change actual ERC20 coin amounts
446     self.balances[i] = old_balances[i] + dx
447     # When rounding errors happen, we undercharge admin fee in favor of LP
448     self.balances[j] = old_balances[j] - dy - dy_admin_fee
449 
450     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)
451     assert ERC20(self.coins[j]).transfer(msg.sender, dy)
452 
453     log TokenExchange(msg.sender, i, dx, j, dy)
454 
455 
456 @external
457 @nonreentrant('lock')
458 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
459     total_supply: uint256 = self.token.totalSupply()
460     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
461     fees: uint256[N_COINS] = empty(uint256[N_COINS])  # Fees are unused but we've got them historically in event
462 
463     for i in range(N_COINS):
464         value: uint256 = self.balances[i] * _amount / total_supply
465         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
466         self.balances[i] -= value
467         amounts[i] = value
468         assert ERC20(self.coins[i]).transfer(msg.sender, value)
469 
470     self.token.burnFrom(msg.sender, _amount)  # dev: insufficient funds
471 
472     log RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
473 
474 
475 @external
476 @nonreentrant('lock')
477 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256):
478     assert not self.is_killed  # dev: is killed
479 
480     token_supply: uint256 = self.token.totalSupply()
481     assert token_supply != 0  # dev: zero total supply
482     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
483     _admin_fee: uint256 = self.admin_fee
484     amp: uint256 = self._A()
485 
486     old_balances: uint256[N_COINS] = self.balances
487     new_balances: uint256[N_COINS] = old_balances
488     D0: uint256 = self.get_D_mem(old_balances, amp)
489     for i in range(N_COINS):
490         new_balances[i] -= amounts[i]
491     D1: uint256 = self.get_D_mem(new_balances, amp)
492     fees: uint256[N_COINS] = empty(uint256[N_COINS])
493     for i in range(N_COINS):
494         ideal_balance: uint256 = D1 * old_balances[i] / D0
495         difference: uint256 = 0
496         if ideal_balance > new_balances[i]:
497             difference = ideal_balance - new_balances[i]
498         else:
499             difference = new_balances[i] - ideal_balance
500         fees[i] = _fee * difference / FEE_DENOMINATOR
501         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
502         new_balances[i] -= fees[i]
503     D2: uint256 = self.get_D_mem(new_balances, amp)
504 
505     token_amount: uint256 = (D0 - D2) * token_supply / D0
506     assert token_amount != 0  # dev: zero tokens burned
507     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
508     assert token_amount <= max_burn_amount, "Slippage screwed you"
509 
510     self.token.burnFrom(msg.sender, token_amount)  # dev: insufficient funds
511     for i in range(N_COINS):
512         if amounts[i] != 0:
513             assert ERC20(self.coins[i]).transfer(msg.sender, amounts[i])
514 
515     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
516 
517 
518 @view
519 @internal
520 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
521     """
522     Calculate x[i] if one reduces D from being calculated for xp to D
523 
524     Done by solving quadratic equation iteratively.
525     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
526     x_1**2 + b*x_1 = c
527 
528     x_1 = (x_1**2 + c) / (2*x_1 + b)
529     """
530     # x in the input is converted to the same price/precision
531 
532     assert i >= 0  # dev: i below zero
533     assert i < N_COINS  # dev: i above N_COINS
534 
535     c: uint256 = D
536     S_: uint256 = 0
537     Ann: uint256 = A_ * N_COINS
538 
539     _x: uint256 = 0
540     for _i in range(N_COINS):
541         if _i != i:
542             _x = xp[_i]
543         else:
544             continue
545         S_ += _x
546         c = c * D / (_x * N_COINS)
547     c = c * D / (Ann * N_COINS)
548     b: uint256 = S_ + D / Ann
549     y_prev: uint256 = 0
550     y: uint256 = D
551     for _i in range(255):
552         y_prev = y
553         y = (y*y + c) / (2 * y + b - D)
554         # Equality with the precision of 1
555         if y > y_prev:
556             if y - y_prev <= 1:
557                 break
558         else:
559             if y_prev - y <= 1:
560                 break
561     return y
562 
563 
564 @view
565 @internal
566 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256):
567     # First, need to calculate
568     # * Get current D
569     # * Solve Eqn against y_i for D - _token_amount
570     amp: uint256 = self._A()
571     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
572     precisions: uint256[N_COINS] = PRECISION_MUL
573     total_supply: uint256 = self.token.totalSupply()
574 
575     xp: uint256[N_COINS] = self._xp()
576 
577     D0: uint256 = self.get_D(xp, amp)
578     D1: uint256 = D0 - _token_amount * D0 / total_supply
579     xp_reduced: uint256[N_COINS] = xp
580 
581     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
582     dy_0: uint256 = (xp[i] - new_y) / precisions[i]  # w/o fees
583 
584     for j in range(N_COINS):
585         dx_expected: uint256 = 0
586         if j == i:
587             dx_expected = xp[j] * D1 / D0 - new_y
588         else:
589             dx_expected = xp[j] - xp[j] * D1 / D0
590         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
591 
592     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
593     dy = (dy - 1) / precisions[i]  # Withdraw less to account for rounding errors
594 
595     return dy, dy_0 - dy
596 
597 
598 @view
599 @external
600 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
601     return self._calc_withdraw_one_coin(_token_amount, i)[0]
602 
603 
604 @external
605 @nonreentrant('lock')
606 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256):
607     """
608     Remove _amount of liquidity all in a form of coin i
609     """
610     assert not self.is_killed  # dev: is killed
611 
612     dy: uint256 = 0
613     dy_fee: uint256 = 0
614     dy, dy_fee = self._calc_withdraw_one_coin(_token_amount, i)
615     assert dy >= min_amount, "Not enough coins removed"
616 
617     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
618     self.token.burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
619     assert ERC20(self.coins[i]).transfer(msg.sender, dy)
620 
621     log RemoveLiquidityOne(msg.sender, _token_amount, dy)
622 
623 
624 ### Admin functions ###
625 @external
626 def ramp_A(_future_A: uint256, _future_time: uint256):
627     assert msg.sender == self.owner  # dev: only owner
628     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
629     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
630 
631     _initial_A: uint256 = self._A()
632     assert (_future_A > 0) and (_future_A < MAX_A)
633     assert ((_future_A >= _initial_A) and (_future_A <= _initial_A * MAX_A_CHANGE)) or\
634            ((_future_A < _initial_A) and (_future_A * MAX_A_CHANGE >= _initial_A))
635     self.initial_A = _initial_A
636     self.future_A = _future_A
637     self.initial_A_time = block.timestamp
638     self.future_A_time = _future_time
639 
640     log RampA(_initial_A, _future_A, block.timestamp, _future_time)
641 
642 
643 @external
644 def stop_ramp_A():
645     assert msg.sender == self.owner  # dev: only owner
646 
647     current_A: uint256 = self._A()
648     self.initial_A = current_A
649     self.future_A = current_A
650     self.initial_A_time = block.timestamp
651     self.future_A_time = block.timestamp
652     # now (block.timestamp < t1) is always False, so we return saved A
653 
654     log StopRampA(current_A, block.timestamp)
655 
656 
657 @external
658 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
659     assert msg.sender == self.owner  # dev: only owner
660     assert self.admin_actions_deadline == 0  # dev: active action
661     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
662     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
663 
664     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
665     self.admin_actions_deadline = _deadline
666     self.future_fee = new_fee
667     self.future_admin_fee = new_admin_fee
668 
669     log CommitNewFee(_deadline, new_fee, new_admin_fee)
670 
671 
672 @external
673 def apply_new_fee():
674     assert msg.sender == self.owner  # dev: only owner
675     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
676     assert self.admin_actions_deadline != 0  # dev: no active action
677 
678     self.admin_actions_deadline = 0
679     _fee: uint256 = self.future_fee
680     _admin_fee: uint256 = self.future_admin_fee
681     self.fee = _fee
682     self.admin_fee = _admin_fee
683 
684     log NewFee(_fee, _admin_fee)
685 
686 
687 @external
688 def revert_new_parameters():
689     assert msg.sender == self.owner  # dev: only owner
690 
691     self.admin_actions_deadline = 0
692 
693 
694 @external
695 def commit_transfer_ownership(_owner: address):
696     assert msg.sender == self.owner  # dev: only owner
697     assert self.transfer_ownership_deadline == 0  # dev: active transfer
698 
699     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
700     self.transfer_ownership_deadline = _deadline
701     self.future_owner = _owner
702 
703     log CommitNewAdmin(_deadline, _owner)
704 
705 
706 @external
707 def apply_transfer_ownership():
708     assert msg.sender == self.owner  # dev: only owner
709     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
710     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
711 
712     self.transfer_ownership_deadline = 0
713     _owner: address = self.future_owner
714     self.owner = _owner
715 
716     log NewAdmin(_owner)
717 
718 
719 @external
720 def revert_transfer_ownership():
721     assert msg.sender == self.owner  # dev: only owner
722 
723     self.transfer_ownership_deadline = 0
724 
725 
726 @view
727 @external
728 def admin_balances(i: uint256) -> uint256:
729     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
730 
731 
732 @external
733 def withdraw_admin_fees():
734     assert msg.sender == self.owner  # dev: only owner
735 
736     for i in range(N_COINS):
737         c: address = self.coins[i]
738         value: uint256 = ERC20(c).balanceOf(self) - self.balances[i]
739         if value > 0:
740             assert ERC20(c).transfer(msg.sender, value)
741 
742 
743 @external
744 def donate_admin_fees():
745     assert msg.sender == self.owner  # dev: only owner
746     for i in range(N_COINS):
747         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
748 
749 
750 @external
751 def kill_me():
752     assert msg.sender == self.owner  # dev: only owner
753     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
754     self.is_killed = True
755 
756 
757 @external
758 def unkill_me():
759     assert msg.sender == self.owner  # dev: only owner
760     self.is_killed = False