1 # @version 0.2.4
2 # (c) Curve.Fi, 2020
3 # Pool for DAI/USDC/USDT
4 
5 from vyper.interfaces import ERC20
6 
7 interface CurveToken:
8     def totalSupply() -> uint256: view
9     def mint(_to: address, _value: uint256) -> bool: nonpayable
10     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
11 
12 
13 # Events
14 event TokenExchange:
15     buyer: indexed(address)
16     sold_id: int128
17     tokens_sold: uint256
18     bought_id: int128
19     tokens_bought: uint256
20 
21 
22 event AddLiquidity:
23     provider: indexed(address)
24     token_amounts: uint256[N_COINS]
25     fees: uint256[N_COINS]
26     invariant: uint256
27     token_supply: uint256
28 
29 event RemoveLiquidity:
30     provider: indexed(address)
31     token_amounts: uint256[N_COINS]
32     fees: uint256[N_COINS]
33     token_supply: uint256
34 
35 event RemoveLiquidityOne:
36     provider: indexed(address)
37     token_amount: uint256
38     coin_amount: uint256
39 
40 event RemoveLiquidityImbalance:
41     provider: indexed(address)
42     token_amounts: uint256[N_COINS]
43     fees: uint256[N_COINS]
44     invariant: uint256
45     token_supply: uint256
46 
47 event CommitNewAdmin:
48     deadline: indexed(uint256)
49     admin: indexed(address)
50 
51 event NewAdmin:
52     admin: indexed(address)
53 
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
75 # This can (and needs to) be changed at compile time
76 N_COINS: constant(int128) = 3  # <- change
77 
78 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
79 LENDING_PRECISION: constant(uint256) = 10 ** 18
80 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
81 PRECISION_MUL: constant(uint256[N_COINS]) = [1, 1000000000000, 1000000000000]
82 RATES: constant(uint256[N_COINS]) = [1000000000000000000, 1000000000000000000000000000000, 1000000000000000000000000000000]
83 FEE_INDEX: constant(int128) = 2  # Which coin may potentially have fees (USDT)
84 
85 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
86 MAX_FEE: constant(uint256) = 5 * 10 ** 9
87 MAX_A: constant(uint256) = 10 ** 6
88 MAX_A_CHANGE: constant(uint256) = 10
89 
90 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
91 MIN_RAMP_TIME: constant(uint256) = 86400
92 
93 coins: public(address[N_COINS])
94 balances: public(uint256[N_COINS])
95 fee: public(uint256)  # fee * 1e10
96 admin_fee: public(uint256)  # admin_fee * 1e10
97 
98 owner: public(address)
99 token: CurveToken
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
129     @param _coins Addresses of ERC20 conracts of coins
130     @param _pool_token Address of the token representing LP share
131     @param _A Amplification coefficient multiplied by n * (n - 1)
132     @param _fee Fee to charge for exchanges
133     @param _admin_fee Admin fee
134     """
135     for i in range(N_COINS):
136         assert _coins[i] != ZERO_ADDRESS
137     self.coins = _coins
138     self.initial_A = _A
139     self.future_A = _A
140     self.fee = _fee
141     self.admin_fee = _admin_fee
142     self.owner = _owner
143     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
144     self.token = CurveToken(_pool_token)
145 
146 
147 @view
148 @internal
149 def _A() -> uint256:
150     """
151     Handle ramping A up or down
152     """
153     t1: uint256 = self.future_A_time
154     A1: uint256 = self.future_A
155 
156     if block.timestamp < t1:
157         A0: uint256 = self.initial_A
158         t0: uint256 = self.initial_A_time
159         # Expressions in uint256 cannot have negative numbers, thus "if"
160         if A1 > A0:
161             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
162         else:
163             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
164 
165     else:  # when t1 == 0 or block.timestamp >= t1
166         return A1
167 
168 
169 @view
170 @external
171 def A() -> uint256:
172     return self._A()
173 
174 
175 @view
176 @internal
177 def _xp() -> uint256[N_COINS]:
178     result: uint256[N_COINS] = RATES
179     for i in range(N_COINS):
180         result[i] = result[i] * self.balances[i] / LENDING_PRECISION
181     return result
182 
183 
184 @pure
185 @internal
186 def _xp_mem(_balances: uint256[N_COINS]) -> uint256[N_COINS]:
187     result: uint256[N_COINS] = RATES
188     for i in range(N_COINS):
189         result[i] = result[i] * _balances[i] / PRECISION
190     return result
191 
192 
193 @pure
194 @internal
195 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
196     S: uint256 = 0
197     for _x in xp:
198         S += _x
199     if S == 0:
200         return 0
201 
202     Dprev: uint256 = 0
203     D: uint256 = S
204     Ann: uint256 = amp * N_COINS
205     for _i in range(255):
206         D_P: uint256 = D
207         for _x in xp:
208             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
209         Dprev = D
210         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
211         # Equality with the precision of 1
212         if D > Dprev:
213             if D - Dprev <= 1:
214                 break
215         else:
216             if Dprev - D <= 1:
217                 break
218     return D
219 
220 
221 @view
222 @internal
223 def get_D_mem(_balances: uint256[N_COINS], amp: uint256) -> uint256:
224     return self.get_D(self._xp_mem(_balances), amp)
225 
226 
227 @view
228 @external
229 def get_virtual_price() -> uint256:
230     """
231     Returns portfolio virtual price (for calculating profit)
232     scaled up by 1e18
233     """
234     D: uint256 = self.get_D(self._xp(), self._A())
235     # D is in the units similar to DAI (e.g. converted to precision 1e18)
236     # When balanced, D = n * x_u - total virtual value of the portfolio
237     token_supply: uint256 = self.token.totalSupply()
238     return D * PRECISION / token_supply
239 
240 
241 @view
242 @external
243 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
244     """
245     Simplified method to calculate addition or reduction in token supply at
246     deposit or withdrawal without taking fees into account (but looking at
247     slippage).
248     Needed to prevent front-running, not for precise calculations!
249     """
250     _balances: uint256[N_COINS] = self.balances
251     amp: uint256 = self._A()
252     D0: uint256 = self.get_D_mem(_balances, amp)
253     for i in range(N_COINS):
254         if deposit:
255             _balances[i] += amounts[i]
256         else:
257             _balances[i] -= amounts[i]
258     D1: uint256 = self.get_D_mem(_balances, amp)
259     token_amount: uint256 = self.token.totalSupply()
260     diff: uint256 = 0
261     if deposit:
262         diff = D1 - D0
263     else:
264         diff = D0 - D1
265     return diff * token_amount / D0
266 
267 
268 @external
269 @nonreentrant('lock')
270 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
271     assert not self.is_killed  # dev: is killed
272 
273     fees: uint256[N_COINS] = empty(uint256[N_COINS])
274     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
275     _admin_fee: uint256 = self.admin_fee
276     amp: uint256 = self._A()
277 
278     token_supply: uint256 = self.token.totalSupply()
279     # Initial invariant
280     D0: uint256 = 0
281     old_balances: uint256[N_COINS] = self.balances
282     if token_supply > 0:
283         D0 = self.get_D_mem(old_balances, amp)
284     new_balances: uint256[N_COINS] = old_balances
285 
286     for i in range(N_COINS):
287         in_amount: uint256 = amounts[i]
288         if token_supply == 0:
289             assert in_amount > 0  # dev: initial deposit requires all coins
290         in_coin: address = self.coins[i]
291 
292         # Take coins from the sender
293         if in_amount > 0:
294             if i == FEE_INDEX:
295                 in_amount = ERC20(in_coin).balanceOf(self)
296 
297             # "safeTransferFrom" which works for ERC20s which return bool or not
298             _response: Bytes[32] = raw_call(
299                 in_coin,
300                 concat(
301                     method_id("transferFrom(address,address,uint256)"),
302                     convert(msg.sender, bytes32),
303                     convert(self, bytes32),
304                     convert(amounts[i], bytes32),
305                 ),
306                 max_outsize=32,
307             )  # dev: failed transfer
308             if len(_response) > 0:
309                 assert convert(_response, bool)  # dev: failed transfer
310 
311             if i == FEE_INDEX:
312                 in_amount = ERC20(in_coin).balanceOf(self) - in_amount
313 
314         new_balances[i] = old_balances[i] + in_amount
315 
316     # Invariant after change
317     D1: uint256 = self.get_D_mem(new_balances, amp)
318     assert D1 > D0
319 
320     # We need to recalculate the invariant accounting for fees
321     # to calculate fair user's share
322     D2: uint256 = D1
323     if token_supply > 0:
324         # Only account for fees if we are not the first to deposit
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
348     # Mint pool tokens
349     self.token.mint(msg.sender, mint_amount)
350 
351     log AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
352 
353 
354 @view
355 @internal
356 def get_y(i: int128, j: int128, x: uint256, xp_: uint256[N_COINS]) -> uint256:
357     # x in the input is converted to the same price/precision
358 
359     assert i != j       # dev: same coin
360     assert j >= 0       # dev: j below zero
361     assert j < N_COINS  # dev: j above N_COINS
362 
363     # should be unreachable, but good for safety
364     assert i >= 0
365     assert i < N_COINS
366 
367     amp: uint256 = self._A()
368     D: uint256 = self.get_D(xp_, amp)
369     c: uint256 = D
370     S_: uint256 = 0
371     Ann: uint256 = amp * N_COINS
372 
373     _x: uint256 = 0
374     for _i in range(N_COINS):
375         if _i == i:
376             _x = x
377         elif _i != j:
378             _x = xp_[_i]
379         else:
380             continue
381         S_ += _x
382         c = c * D / (_x * N_COINS)
383     c = c * D / (Ann * N_COINS)
384     b: uint256 = S_ + D / Ann  # - D
385     y_prev: uint256 = 0
386     y: uint256 = D
387     for _i in range(255):
388         y_prev = y
389         y = (y*y + c) / (2 * y + b - D)
390         # Equality with the precision of 1
391         if y > y_prev:
392             if y - y_prev <= 1:
393                 break
394         else:
395             if y_prev - y <= 1:
396                 break
397     return y
398 
399 
400 @view
401 @external
402 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
403     # dx and dy in c-units
404     rates: uint256[N_COINS] = RATES
405     xp: uint256[N_COINS] = self._xp()
406 
407     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
408     y: uint256 = self.get_y(i, j, x, xp)
409     dy: uint256 = (xp[j] - y - 1) * PRECISION / rates[j]
410     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
411     return dy - _fee
412 
413 
414 @view
415 @external
416 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
417     # dx and dy in underlying units
418     xp: uint256[N_COINS] = self._xp()
419     precisions: uint256[N_COINS] = PRECISION_MUL
420 
421     x: uint256 = xp[i] + dx * precisions[i]
422     y: uint256 = self.get_y(i, j, x, xp)
423     dy: uint256 = (xp[j] - y - 1) / precisions[j]
424     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
425     return dy - _fee
426 
427 
428 
429 @external
430 @nonreentrant('lock')
431 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256):
432     assert not self.is_killed  # dev: is killed
433     rates: uint256[N_COINS] = RATES
434 
435     old_balances: uint256[N_COINS] = self.balances
436     xp: uint256[N_COINS] = self._xp_mem(old_balances)
437 
438     # Handling an unexpected charge of a fee on transfer (USDT, PAXG)
439     dx_w_fee: uint256 = dx
440     input_coin: address = self.coins[i]
441 
442     if i == FEE_INDEX:
443         dx_w_fee = ERC20(input_coin).balanceOf(self)
444 
445     # "safeTransferFrom" which works for ERC20s which return bool or not
446     _response: Bytes[32] = raw_call(
447         input_coin,
448         concat(
449             method_id("transferFrom(address,address,uint256)"),
450             convert(msg.sender, bytes32),
451             convert(self, bytes32),
452             convert(dx, bytes32),
453         ),
454         max_outsize=32,
455     )  # dev: failed transfer
456     if len(_response) > 0:
457         assert convert(_response, bool)  # dev: failed transfer
458 
459     if i == FEE_INDEX:
460         dx_w_fee = ERC20(input_coin).balanceOf(self) - dx_w_fee
461 
462     x: uint256 = xp[i] + dx_w_fee * rates[i] / PRECISION
463     y: uint256 = self.get_y(i, j, x, xp)
464 
465     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
466     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
467 
468     # Convert all to real units
469     dy = (dy - dy_fee) * PRECISION / rates[j]
470     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
471 
472     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
473     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
474 
475     # Change balances exactly in same way as we change actual ERC20 coin amounts
476     self.balances[i] = old_balances[i] + dx_w_fee
477     # When rounding errors happen, we undercharge admin fee in favor of LP
478     self.balances[j] = old_balances[j] - dy - dy_admin_fee
479 
480     # "safeTransfer" which works for ERC20s which return bool or not
481     _response = raw_call(
482         self.coins[j],
483         concat(
484             method_id("transfer(address,uint256)"),
485             convert(msg.sender, bytes32),
486             convert(dy, bytes32),
487         ),
488         max_outsize=32,
489     )  # dev: failed transfer
490     if len(_response) > 0:
491         assert convert(_response, bool)  # dev: failed transfer
492 
493     log TokenExchange(msg.sender, i, dx, j, dy)
494 
495 
496 @external
497 @nonreentrant('lock')
498 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
499     total_supply: uint256 = self.token.totalSupply()
500     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
501     fees: uint256[N_COINS] = empty(uint256[N_COINS])  # Fees are unused but we've got them historically in event
502 
503     for i in range(N_COINS):
504         value: uint256 = self.balances[i] * _amount / total_supply
505         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
506         self.balances[i] -= value
507         amounts[i] = value
508 
509         # "safeTransfer" which works for ERC20s which return bool or not
510         _response: Bytes[32] = raw_call(
511             self.coins[i],
512             concat(
513                 method_id("transfer(address,uint256)"),
514                 convert(msg.sender, bytes32),
515                 convert(value, bytes32),
516             ),
517             max_outsize=32,
518         )  # dev: failed transfer
519         if len(_response) > 0:
520             assert convert(_response, bool)  # dev: failed transfer
521 
522     self.token.burnFrom(msg.sender, _amount)  # dev: insufficient funds
523 
524     log RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
525 
526 
527 @external
528 @nonreentrant('lock')
529 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256):
530     assert not self.is_killed  # dev: is killed
531 
532     token_supply: uint256 = self.token.totalSupply()
533     assert token_supply != 0  # dev: zero total supply
534     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
535     _admin_fee: uint256 = self.admin_fee
536     amp: uint256 = self._A()
537 
538     old_balances: uint256[N_COINS] = self.balances
539     new_balances: uint256[N_COINS] = old_balances
540     D0: uint256 = self.get_D_mem(old_balances, amp)
541     for i in range(N_COINS):
542         new_balances[i] -= amounts[i]
543     D1: uint256 = self.get_D_mem(new_balances, amp)
544     fees: uint256[N_COINS] = empty(uint256[N_COINS])
545     for i in range(N_COINS):
546         ideal_balance: uint256 = D1 * old_balances[i] / D0
547         difference: uint256 = 0
548         if ideal_balance > new_balances[i]:
549             difference = ideal_balance - new_balances[i]
550         else:
551             difference = new_balances[i] - ideal_balance
552         fees[i] = _fee * difference / FEE_DENOMINATOR
553         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
554         new_balances[i] -= fees[i]
555     D2: uint256 = self.get_D_mem(new_balances, amp)
556 
557     token_amount: uint256 = (D0 - D2) * token_supply / D0
558     assert token_amount != 0  # dev: zero tokens burned
559     token_amount += 1  # In case of rounding errors - make it unfavorable for the "attacker"
560     assert token_amount <= max_burn_amount, "Slippage screwed you"
561 
562     self.token.burnFrom(msg.sender, token_amount)  # dev: insufficient funds
563     for i in range(N_COINS):
564         if amounts[i] != 0:
565 
566             # "safeTransfer" which works for ERC20s which return bool or not
567             _response: Bytes[32] = raw_call(
568                 self.coins[i],
569                 concat(
570                     method_id("transfer(address,uint256)"),
571                     convert(msg.sender, bytes32),
572                     convert(amounts[i], bytes32),
573                 ),
574                 max_outsize=32,
575             )  # dev: failed transfer
576             if len(_response) > 0:
577                 assert convert(_response, bool)  # dev: failed transfer
578 
579     log RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
580 
581 
582 @view
583 @internal
584 def get_y_D(A_: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
585     """
586     Calculate x[i] if one reduces D from being calculated for xp to D
587 
588     Done by solving quadratic equation iteratively.
589     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
590     x_1**2 + b*x_1 = c
591 
592     x_1 = (x_1**2 + c) / (2*x_1 + b)
593     """
594     # x in the input is converted to the same price/precision
595 
596     assert i >= 0  # dev: i below zero
597     assert i < N_COINS  # dev: i above N_COINS
598 
599     c: uint256 = D
600     S_: uint256 = 0
601     Ann: uint256 = A_ * N_COINS
602 
603     _x: uint256 = 0
604     for _i in range(N_COINS):
605         if _i != i:
606             _x = xp[_i]
607         else:
608             continue
609         S_ += _x
610         c = c * D / (_x * N_COINS)
611     c = c * D / (Ann * N_COINS)
612     b: uint256 = S_ + D / Ann
613     y_prev: uint256 = 0
614     y: uint256 = D
615     for _i in range(255):
616         y_prev = y
617         y = (y*y + c) / (2 * y + b - D)
618         # Equality with the precision of 1
619         if y > y_prev:
620             if y - y_prev <= 1:
621                 break
622         else:
623             if y_prev - y <= 1:
624                 break
625     return y
626 
627 
628 @view
629 @internal
630 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> (uint256, uint256):
631     # First, need to calculate
632     # * Get current D
633     # * Solve Eqn against y_i for D - _token_amount
634     amp: uint256 = self._A()
635     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
636     precisions: uint256[N_COINS] = PRECISION_MUL
637     total_supply: uint256 = self.token.totalSupply()
638 
639     xp: uint256[N_COINS] = self._xp()
640 
641     D0: uint256 = self.get_D(xp, amp)
642     D1: uint256 = D0 - _token_amount * D0 / total_supply
643     xp_reduced: uint256[N_COINS] = xp
644 
645     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
646     dy_0: uint256 = (xp[i] - new_y) / precisions[i]  # w/o fees
647 
648     for j in range(N_COINS):
649         dx_expected: uint256 = 0
650         if j == i:
651             dx_expected = xp[j] * D1 / D0 - new_y
652         else:
653             dx_expected = xp[j] - xp[j] * D1 / D0
654         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
655 
656     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
657     dy = (dy - 1) / precisions[i]  # Withdraw less to account for rounding errors
658 
659     return dy, dy_0 - dy
660 
661 
662 @view
663 @external
664 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
665     return self._calc_withdraw_one_coin(_token_amount, i)[0]
666 
667 
668 @external
669 @nonreentrant('lock')
670 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256):
671     """
672     Remove _amount of liquidity all in a form of coin i
673     """
674     assert not self.is_killed  # dev: is killed
675 
676     dy: uint256 = 0
677     dy_fee: uint256 = 0
678     dy, dy_fee = self._calc_withdraw_one_coin(_token_amount, i)
679     assert dy >= min_amount, "Not enough coins removed"
680 
681     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
682     self.token.burnFrom(msg.sender, _token_amount)  # dev: insufficient funds
683 
684     # "safeTransfer" which works for ERC20s which return bool or not
685     _response: Bytes[32] = raw_call(
686         self.coins[i],
687         concat(
688             method_id("transfer(address,uint256)"),
689             convert(msg.sender, bytes32),
690             convert(dy, bytes32),
691         ),
692         max_outsize=32,
693     )  # dev: failed transfer
694     if len(_response) > 0:
695         assert convert(_response, bool)  # dev: failed transfer
696 
697     log RemoveLiquidityOne(msg.sender, _token_amount, dy)
698 
699 
700 ### Admin functions ###
701 @external
702 def ramp_A(_future_A: uint256, _future_time: uint256):
703     assert msg.sender == self.owner  # dev: only owner
704     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
705     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
706 
707     _initial_A: uint256 = self._A()
708     assert (_future_A > 0) and (_future_A < MAX_A)
709     assert ((_future_A >= _initial_A) and (_future_A <= _initial_A * MAX_A_CHANGE)) or\
710            ((_future_A < _initial_A) and (_future_A * MAX_A_CHANGE >= _initial_A))
711     self.initial_A = _initial_A
712     self.future_A = _future_A
713     self.initial_A_time = block.timestamp
714     self.future_A_time = _future_time
715 
716     log RampA(_initial_A, _future_A, block.timestamp, _future_time)
717 
718 
719 @external
720 def stop_ramp_A():
721     assert msg.sender == self.owner  # dev: only owner
722 
723     current_A: uint256 = self._A()
724     self.initial_A = current_A
725     self.future_A = current_A
726     self.initial_A_time = block.timestamp
727     self.future_A_time = block.timestamp
728     # now (block.timestamp < t1) is always False, so we return saved A
729 
730     log StopRampA(current_A, block.timestamp)
731 
732 
733 @external
734 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
735     assert msg.sender == self.owner  # dev: only owner
736     assert self.admin_actions_deadline == 0  # dev: active action
737     assert new_fee <= MAX_FEE  # dev: fee exceeds maximum
738     assert new_admin_fee <= MAX_ADMIN_FEE  # dev: admin fee exceeds maximum
739 
740     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
741     self.admin_actions_deadline = _deadline
742     self.future_fee = new_fee
743     self.future_admin_fee = new_admin_fee
744 
745     log CommitNewFee(_deadline, new_fee, new_admin_fee)
746 
747 
748 @external
749 def apply_new_fee():
750     assert msg.sender == self.owner  # dev: only owner
751     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
752     assert self.admin_actions_deadline != 0  # dev: no active action
753 
754     self.admin_actions_deadline = 0
755     _fee: uint256 = self.future_fee
756     _admin_fee: uint256 = self.future_admin_fee
757     self.fee = _fee
758     self.admin_fee = _admin_fee
759 
760     log NewFee(_fee, _admin_fee)
761 
762 
763 @external
764 def revert_new_parameters():
765     assert msg.sender == self.owner  # dev: only owner
766 
767     self.admin_actions_deadline = 0
768 
769 
770 @external
771 def commit_transfer_ownership(_owner: address):
772     assert msg.sender == self.owner  # dev: only owner
773     assert self.transfer_ownership_deadline == 0  # dev: active transfer
774 
775     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
776     self.transfer_ownership_deadline = _deadline
777     self.future_owner = _owner
778 
779     log CommitNewAdmin(_deadline, _owner)
780 
781 
782 @external
783 def apply_transfer_ownership():
784     assert msg.sender == self.owner  # dev: only owner
785     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
786     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
787 
788     self.transfer_ownership_deadline = 0
789     _owner: address = self.future_owner
790     self.owner = _owner
791 
792     log NewAdmin(_owner)
793 
794 
795 @external
796 def revert_transfer_ownership():
797     assert msg.sender == self.owner  # dev: only owner
798 
799     self.transfer_ownership_deadline = 0
800 
801 
802 @view
803 @external
804 def admin_balances(i: uint256) -> uint256:
805     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
806 
807 
808 @external
809 def withdraw_admin_fees():
810     assert msg.sender == self.owner  # dev: only owner
811 
812     for i in range(N_COINS):
813         c: address = self.coins[i]
814         value: uint256 = ERC20(c).balanceOf(self) - self.balances[i]
815         if value > 0:
816             # "safeTransfer" which works for ERC20s which return bool or not
817             _response: Bytes[32] = raw_call(
818                 c,
819                 concat(
820                     method_id("transfer(address,uint256)"),
821                     convert(msg.sender, bytes32),
822                     convert(value, bytes32),
823                 ),
824                 max_outsize=32,
825             )  # dev: failed transfer
826             if len(_response) > 0:
827                 assert convert(_response, bool)  # dev: failed transfer
828 
829 
830 @external
831 def donate_admin_fees():
832     assert msg.sender == self.owner  # dev: only owner
833     for i in range(N_COINS):
834         self.balances[i] = ERC20(self.coins[i]).balanceOf(self)
835 
836 
837 @external
838 def kill_me():
839     assert msg.sender == self.owner  # dev: only owner
840     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
841     self.is_killed = True
842 
843 
844 @external
845 def unkill_me():
846     assert msg.sender == self.owner  # dev: only owner
847     self.is_killed = False