1 # (c) Curve.Fi, 2020
2 # Pools for renBTC/wBTC. Ren can potentially change amount of underlying bitcoins
3 
4 
5 # External Contracts
6 contract ERC20m:
7     def totalSupply() -> uint256: constant
8     def allowance(_owner: address, _spender: address) -> uint256: constant
9     def transfer(_to: address, _value: uint256) -> bool: modifying
10     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
11     def approve(_spender: address, _value: uint256) -> bool: modifying
12     def mint(_to: address, _value: uint256): modifying
13     def burn(_value: uint256): modifying
14     def burnFrom(_to: address, _value: uint256): modifying
15     def name() -> string[64]: constant
16     def symbol() -> string[32]: constant
17     def decimals() -> uint256: constant
18     def balanceOf(arg0: address) -> uint256: constant
19     def set_minter(_minter: address): modifying
20 
21 
22 
23 # External Contracts
24 contract cERC20:
25     def totalSupply() -> uint256: constant
26     def allowance(_owner: address, _spender: address) -> uint256: constant
27     def transfer(_to: address, _value: uint256) -> bool: modifying
28     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
29     def approve(_spender: address, _value: uint256) -> bool: modifying
30     def burn(_value: uint256): modifying
31     def burnFrom(_to: address, _value: uint256): modifying
32     def name() -> string[64]: constant
33     def symbol() -> string[32]: constant
34     def decimals() -> uint256: constant
35     def balanceOf(arg0: address) -> uint256: constant
36     def mint(mintAmount: uint256) -> uint256: modifying
37     def redeem(redeemTokens: uint256) -> uint256: modifying
38     def redeemUnderlying(redeemAmount: uint256) -> uint256: modifying
39     def exchangeRateStored() -> uint256: constant
40     def exchangeRateCurrent() -> uint256: constant
41     def supplyRatePerBlock() -> uint256: constant
42     def accrualBlockNumber() -> uint256: constant
43 
44 
45 from vyper.interfaces import ERC20
46 
47 
48 # This can (and needs to) be changed at compile time
49 N_COINS: constant(int128) = 2  # <- change
50 
51 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
52 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256]  # <- change
53 
54 USE_LENDING: constant(bool[N_COINS]) = [True, False]
55 
56 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
57 LENDING_PRECISION: constant(uint256) = 10 ** 18
58 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
59 PRECISION_MUL: constant(uint256[N_COINS]) = [convert(10000000000, uint256), convert(10000000000, uint256)]
60 # PRECISION_MUL: constant(uint256[N_COINS]) = [
61 #     PRECISION / convert(PRECISION, uint256),  # DAI
62 #     PRECISION / convert(10 ** 6, uint256),   # USDC
63 #     PRECISION / convert(10 ** 6, uint256)]   # USDT
64 
65 
66 admin_actions_delay: constant(uint256) = 3 * 86400
67 min_ramp_time: constant(uint256) = 86400
68 
69 # Events
70 TokenExchange: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
71 AddLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
72 RemoveLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], token_supply: uint256})
73 RemoveLiquidityOne: event({provider: indexed(address), token_amount: uint256, coin_amount: uint256})
74 RemoveLiquidityImbalance: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
75 CommitNewAdmin: event({deadline: indexed(timestamp), admin: indexed(address)})
76 NewAdmin: event({admin: indexed(address)})
77 
78 CommitNewFee: event({deadline: indexed(timestamp), fee: uint256, admin_fee: uint256})
79 NewFee: event({fee: uint256, admin_fee: uint256})
80 RampA: event({old_A: uint256, new_A: uint256, initial_time: timestamp, future_time: timestamp})
81 StopRampA: event({A: uint256, t: timestamp})
82 
83 coins: public(address[N_COINS])
84 balances: public(uint256[N_COINS])
85 fee: public(uint256)  # fee * 1e10
86 admin_fee: public(uint256)  # admin_fee * 1e10
87 
88 max_admin_fee: constant(uint256) = 5 * 10 ** 9
89 max_fee: constant(uint256) = 5 * 10 ** 9
90 max_A: constant(uint256) = 10 ** 6
91 max_A_change: constant(uint256) = 10
92 
93 owner: public(address)
94 token: ERC20m
95 
96 initial_A: public(uint256)
97 future_A: public(uint256)
98 initial_A_time: public(timestamp)
99 future_A_time: public(timestamp)
100 
101 admin_actions_deadline: public(timestamp)
102 transfer_ownership_deadline: public(timestamp)
103 future_fee: public(uint256)
104 future_admin_fee: public(uint256)
105 future_owner: public(address)
106 
107 kill_deadline: timestamp
108 kill_deadline_dt: constant(uint256) = 2 * 30 * 86400
109 is_killed: bool
110 
111 
112 @public
113 def __init__(_coins: address[N_COINS],
114              _pool_token: address,
115              _A: uint256, _fee: uint256):
116     """
117     _coins: Addresses of ERC20 conracts of coins
118     _pool_token: Address of the token representing LP share
119     _A: Amplification coefficient multiplied by n * (n - 1)
120     _fee: Fee to charge for exchanges
121     """
122     for i in range(N_COINS):
123         assert _coins[i] != ZERO_ADDRESS
124         self.balances[i] = 0
125     self.coins = _coins
126     self.initial_A = _A
127     self.future_A = _A
128     self.fee = _fee
129     self.owner = msg.sender
130     self.kill_deadline = block.timestamp + kill_deadline_dt
131     self.is_killed = False
132     self.token = ERC20m(_pool_token)
133 
134 
135 @constant
136 @private
137 def _A() -> uint256:
138     """
139     Handle ramping A up or down
140     """
141     t1: timestamp = self.future_A_time
142     A1: uint256 = self.future_A
143 
144     if block.timestamp < t1:
145         A0: uint256 = self.initial_A
146         t0: timestamp = self.initial_A_time
147         # Expressions in uint256 cannot have negative numbers, thus "if"
148         if A1 > A0:
149             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
150         else:
151             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
152 
153     else:  # when t1 == 0 or block.timestamp >= t1
154         return A1
155 
156 
157 @constant
158 @public
159 def A() -> uint256:
160     return self._A()
161 
162 
163 @private
164 @constant
165 def _rates() -> uint256[N_COINS]:
166     result: uint256[N_COINS] = PRECISION_MUL
167     use_lending: bool[N_COINS] = USE_LENDING
168     for i in range(N_COINS):
169         rate: uint256 = LENDING_PRECISION  # Used with no lending
170         if use_lending[i]:
171             rate = cERC20(self.coins[i]).exchangeRateCurrent()
172         result[i] *= rate
173     return result
174 
175 
176 @private
177 @constant
178 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
179     result: uint256[N_COINS] = rates
180     for i in range(N_COINS):
181         result[i] = result[i] * self.balances[i] / LENDING_PRECISION
182     return result
183 
184 
185 @private
186 @constant
187 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
188     result: uint256[N_COINS] = rates
189     for i in range(N_COINS):
190         result[i] = result[i] * _balances[i] / PRECISION
191     return result
192 
193 
194 @private
195 @constant
196 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
197     S: uint256 = 0
198     for _x in xp:
199         S += _x
200     if S == 0:
201         return 0
202 
203     Dprev: uint256 = 0
204     D: uint256 = S
205     Ann: uint256 = amp * N_COINS
206     for _i in range(255):
207         D_P: uint256 = D
208         for _x in xp:
209             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
210         Dprev = D
211         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
212         # Equality with the precision of 1
213         if D > Dprev:
214             if D - Dprev <= 1:
215                 break
216         else:
217             if Dprev - D <= 1:
218                 break
219     return D
220 
221 
222 @private
223 @constant
224 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS], amp: uint256) -> uint256:
225     return self.get_D(self._xp_mem(rates, _balances), amp)
226 
227 
228 @public
229 @constant
230 def get_virtual_price() -> uint256:
231     """
232     Returns portfolio virtual price (for calculating profit)
233     scaled up by 1e18
234     """
235     D: uint256 = self.get_D(self._xp(self._rates()), self._A())
236     # D is in the units similar to DAI (e.g. converted to precision 1e18)
237     # When balanced, D = n * x_u - total virtual value of the portfolio
238     token_supply: uint256 = self.token.totalSupply()
239     return D * PRECISION / token_supply
240 
241 
242 @public
243 @constant
244 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
245     """
246     Simplified method to calculate addition or reduction in token supply at
247     deposit or withdrawal without taking fees into account (but looking at
248     slippage).
249     Needed to prevent front-running, not for precise calculations!
250     """
251     _balances: uint256[N_COINS] = self.balances
252     rates: uint256[N_COINS] = self._rates()
253     amp: uint256 = self._A()
254     D0: uint256 = self.get_D_mem(rates, _balances, amp)
255     for i in range(N_COINS):
256         if deposit:
257             _balances[i] += amounts[i]
258         else:
259             _balances[i] -= amounts[i]
260     D1: uint256 = self.get_D_mem(rates, _balances, amp)
261     token_amount: uint256 = self.token.totalSupply()
262     diff: uint256 = 0
263     if deposit:
264         diff = D1 - D0
265     else:
266         diff = D0 - D1
267     return diff * token_amount / D0
268 
269 
270 @public
271 @nonreentrant('lock')
272 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
273     # Amounts is amounts of c-tokens
274     assert not self.is_killed
275 
276     use_lending: bool[N_COINS] = USE_LENDING
277     fees: uint256[N_COINS] = ZEROS
278     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
279     _admin_fee: uint256 = self.admin_fee
280     amp: uint256 = self._A()
281 
282     token_supply: uint256 = self.token.totalSupply()
283     rates: uint256[N_COINS] = self._rates()
284     # Initial invariant
285     D0: uint256 = 0
286     old_balances: uint256[N_COINS] = self.balances
287     if token_supply > 0:
288         D0 = self.get_D_mem(rates, old_balances, amp)
289     new_balances: uint256[N_COINS] = old_balances
290 
291     for i in range(N_COINS):
292         if token_supply == 0:
293             assert amounts[i] > 0
294         # balances store amounts of c-tokens
295         new_balances[i] = old_balances[i] + amounts[i]
296 
297     # Invariant after change
298     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
299     assert D1 > D0
300 
301     # We need to recalculate the invariant accounting for fees
302     # to calculate fair user's share
303     D2: uint256 = D1
304     if token_supply > 0:
305         # Only account for fees if we are not the first to deposit
306         for i in range(N_COINS):
307             ideal_balance: uint256 = D1 * old_balances[i] / D0
308             difference: uint256 = 0
309             if ideal_balance > new_balances[i]:
310                 difference = ideal_balance - new_balances[i]
311             else:
312                 difference = new_balances[i] - ideal_balance
313             fees[i] = _fee * difference / FEE_DENOMINATOR
314             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
315             new_balances[i] -= fees[i]
316         D2 = self.get_D_mem(rates, new_balances, amp)
317     else:
318         self.balances = new_balances
319 
320     # Calculate, how much pool tokens to mint
321     mint_amount: uint256 = 0
322     if token_supply == 0:
323         mint_amount = D1  # Take the dust if there was any
324     else:
325         mint_amount = token_supply * (D2 - D0) / D0
326 
327     assert mint_amount >= min_mint_amount, "Slippage screwed you"
328 
329     # Take coins from the sender
330     for i in range(N_COINS):
331         if amounts[i] > 0:
332             assert_modifiable(
333                 cERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i]))
334 
335     # Mint pool tokens
336     self.token.mint(msg.sender, mint_amount)
337 
338     log.AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
339 
340 
341 @private
342 @constant
343 def get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
344     # x in the input is converted to the same price/precision
345 
346     assert (i != j) and (i >= 0) and (j >= 0) and (i < N_COINS) and (j < N_COINS)
347 
348     amp: uint256 = self._A()
349     D: uint256 = self.get_D(_xp, amp)
350     c: uint256 = D
351     S_: uint256 = 0
352     Ann: uint256 = amp * N_COINS
353 
354     _x: uint256 = 0
355     for _i in range(N_COINS):
356         if _i == i:
357             _x = x
358         elif _i != j:
359             _x = _xp[_i]
360         else:
361             continue
362         S_ += _x
363         c = c * D / (_x * N_COINS)
364     c = c * D / (Ann * N_COINS)
365     b: uint256 = S_ + D / Ann  # - D
366     y_prev: uint256 = 0
367     y: uint256 = D
368     for _i in range(255):
369         y_prev = y
370         y = (y*y + c) / (2 * y + b - D)
371         # Equality with the precision of 1
372         if y > y_prev:
373             if y - y_prev <= 1:
374                 break
375         else:
376             if y_prev - y <= 1:
377                 break
378     return y
379 
380 
381 @public
382 @constant
383 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
384     # dx and dy in c-units
385     rates: uint256[N_COINS] = self._rates()
386     xp: uint256[N_COINS] = self._xp(rates)
387 
388     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
389     y: uint256 = self.get_y(i, j, x, xp)
390     dy: uint256 = (xp[j] - y - 1) * PRECISION / rates[j]
391     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
392     return dy - _fee
393 
394 
395 @public
396 @constant
397 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
398     # dx and dy in underlying units
399     rates: uint256[N_COINS] = self._rates()
400     xp: uint256[N_COINS] = self._xp(rates)
401     precisions: uint256[N_COINS] = PRECISION_MUL
402 
403     x: uint256 = xp[i] + dx * precisions[i]
404     y: uint256 = self.get_y(i, j, x, xp)
405     dy: uint256 = (xp[j] - y - 1) / precisions[j]
406     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
407     return dy - _fee
408 
409 
410 @private
411 def _exchange(i: int128, j: int128, dx: uint256, rates: uint256[N_COINS]) -> uint256:
412     assert not self.is_killed
413     # dx and dy are in c-tokens
414 
415     old_balances: uint256[N_COINS] = self.balances
416     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
417 
418     x: uint256 = xp[i] + dx * rates[i] / PRECISION
419     y: uint256 = self.get_y(i, j, x, xp)
420 
421     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
422     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
423     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
424 
425     # Convert all to real units
426     dy = (dy - dy_fee) * PRECISION / rates[j]
427     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
428 
429     # Change balances exactly in same way as we change actual ERC20 coin amounts
430     self.balances[i] = old_balances[i] + dx
431     # When rounding errors happen, we undercharge admin fee in favor of LP
432     self.balances[j] = old_balances[j] - dy - dy_admin_fee
433 
434     return dy
435 
436 
437 @public
438 @nonreentrant('lock')
439 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256):
440     rates: uint256[N_COINS] = self._rates()
441     dy: uint256 = self._exchange(i, j, dx, rates)
442     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
443     use_lending: bool[N_COINS] = USE_LENDING
444 
445     assert_modifiable(cERC20(self.coins[i]).transferFrom(msg.sender, self, dx))
446     assert_modifiable(cERC20(self.coins[j]).transfer(msg.sender, dy))
447 
448     log.TokenExchange(msg.sender, i, dx, j, dy)
449 
450 
451 @public
452 @nonreentrant('lock')
453 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
454     total_supply: uint256 = self.token.totalSupply()
455     amounts: uint256[N_COINS] = ZEROS
456     fees: uint256[N_COINS] = ZEROS  # Fees are unused but we've got them historically in event
457     use_lending: bool[N_COINS] = USE_LENDING
458 
459     for i in range(N_COINS):
460         value: uint256 = self.balances[i] * _amount / total_supply
461         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
462         self.balances[i] -= value
463         amounts[i] = value
464         assert_modifiable(cERC20(self.coins[i]).transfer(msg.sender, value))
465 
466     self.token.burnFrom(msg.sender, _amount)  # Will raise if not enough
467 
468     log.RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
469 
470 
471 @public
472 @nonreentrant('lock')
473 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256):
474     assert not self.is_killed
475     use_lending: bool[N_COINS] = USE_LENDING
476 
477     token_supply: uint256 = self.token.totalSupply()
478     assert token_supply > 0
479     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
480     _admin_fee: uint256 = self.admin_fee
481     rates: uint256[N_COINS] = self._rates()
482     amp: uint256 = self._A()
483 
484     old_balances: uint256[N_COINS] = self.balances
485     new_balances: uint256[N_COINS] = old_balances
486     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
487     for i in range(N_COINS):
488         new_balances[i] -= amounts[i]
489     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
490     fees: uint256[N_COINS] = ZEROS
491     for i in range(N_COINS):
492         ideal_balance: uint256 = D1 * old_balances[i] / D0
493         difference: uint256 = 0
494         if ideal_balance > new_balances[i]:
495             difference = ideal_balance - new_balances[i]
496         else:
497             difference = new_balances[i] - ideal_balance
498         fees[i] = _fee * difference / FEE_DENOMINATOR
499         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
500         new_balances[i] -= fees[i]
501     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
502 
503     token_amount: uint256 = (D0 - D2) * token_supply / D0 + 1
504     assert token_amount <= max_burn_amount, "Slippage screwed you"
505 
506     for i in range(N_COINS):
507         if amounts[i] > 0:
508             assert_modifiable(cERC20(self.coins[i]).transfer(msg.sender, amounts[i]))
509     self.token.burnFrom(msg.sender, token_amount)  # Will raise if not enough
510 
511     log.RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
512 
513 
514 @private
515 @constant
516 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
517     """
518     Calculate x[i] if one reduces D from being calculated for xp to D
519 
520     Done by solving quadratic equation iteratively.
521     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
522     x_1**2 + b*x_1 = c
523 
524     x_1 = (x_1**2 + c) / (2*x_1 + b)
525     """
526     # x in the input is converted to the same price/precision
527 
528     assert (i >= 0) and (i < N_COINS)
529 
530     c: uint256 = D
531     S_: uint256 = 0
532     Ann: uint256 = A * N_COINS
533 
534     _x: uint256 = 0
535     for _i in range(N_COINS):
536         if _i != i:
537             _x = xp[_i]
538         else:
539             continue
540         S_ += _x
541         c = c * D / (_x * N_COINS)
542     c = c * D / (Ann * N_COINS)
543     b: uint256 = S_ + D / Ann
544     y_prev: uint256 = 0
545     y: uint256 = D
546     for _i in range(255):
547         y_prev = y
548         y = (y*y + c) / (2 * y + b - D)
549         # Equality with the precision of 1
550         if y > y_prev:
551             if y - y_prev <= 1:
552                 break
553         else:
554             if y_prev - y <= 1:
555                 break
556     return y
557 
558 
559 @private
560 @constant
561 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, rates: uint256[N_COINS]) -> (uint256, uint256):
562     # First, need to calculate
563     # * Get current D
564     # * Solve Eqn against y_i for D - _token_amount
565     amp: uint256 = self._A()
566     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
567     precisions: uint256[N_COINS] = PRECISION_MUL
568     total_supply: uint256 = self.token.totalSupply()
569 
570     xp: uint256[N_COINS] = self._xp(rates)
571 
572     D0: uint256 = self.get_D(xp, amp)
573     D1: uint256 = D0 - _token_amount * D0 / total_supply
574     xp_reduced: uint256[N_COINS] = xp
575 
576     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
577     dy_0: uint256 = (xp[i] - new_y) / precisions[i]  # w/o fees
578 
579     for j in range(N_COINS):
580         dx_expected: uint256 = 0
581         if j == i:
582             dx_expected = xp[j] * D1 / D0 - new_y
583         else:
584             dx_expected = xp[j] - xp[j] * D1 / D0
585         xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
586 
587     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
588     dy = (dy - 1) / precisions[i]  # Withdraw less to account for rounding errors
589 
590     return dy, dy_0 - dy
591 
592 
593 @public
594 @constant
595 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
596     rates: uint256[N_COINS] = self._rates()
597     return self._calc_withdraw_one_coin(_token_amount, i, rates)[0]
598 
599 
600 @public
601 @nonreentrant('lock')
602 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256):
603     """
604     Remove _amount of liquidity all in a form of coin i
605     """
606     dy: uint256 = 0
607     dy_fee: uint256 = 0
608     rates: uint256[N_COINS] = self._rates()
609     dy, dy_fee = self._calc_withdraw_one_coin(_token_amount, i, rates)
610     assert dy >= min_amount, "Not enough coins removed"
611 
612     self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
613     self.token.burnFrom(msg.sender, _token_amount)
614     assert_modifiable(ERC20(self.coins[i]).transfer(msg.sender, dy))
615 
616     log.RemoveLiquidityOne(msg.sender, _token_amount, dy)
617 
618 
619 ### Admin functions ###
620 @public
621 def ramp_A(_future_A: uint256, _future_time: timestamp):
622     assert msg.sender == self.owner
623     assert block.timestamp >= self.initial_A_time + min_ramp_time
624     assert _future_time >= block.timestamp + min_ramp_time
625 
626     _initial_A: uint256 = self._A()
627     assert (_future_A > 0) and (_future_A < max_A)
628     assert ((_future_A >= _initial_A) and (_future_A <= _initial_A * max_A_change)) or\
629            ((_future_A < _initial_A) and (_future_A * max_A_change >= _initial_A))
630     self.initial_A = _initial_A
631     self.future_A = _future_A
632     self.initial_A_time = block.timestamp
633     self.future_A_time = _future_time
634 
635     log.RampA(_initial_A, _future_A, block.timestamp, _future_time)
636 
637 
638 @public
639 def stop_ramp_A():
640     assert msg.sender == self.owner
641 
642     current_A: uint256 = self._A()
643     self.initial_A = current_A
644     self.future_A = current_A
645     self.initial_A_time = block.timestamp
646     self.future_A_time = block.timestamp
647     # now (block.timestamp < t1) is always False, so we return saved A
648 
649     log.StopRampA(current_A, block.timestamp)
650 
651 
652 @public
653 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
654     assert msg.sender == self.owner
655     assert self.admin_actions_deadline == 0
656     assert new_admin_fee <= max_admin_fee
657     assert new_fee <= max_fee
658 
659     _deadline: timestamp = block.timestamp + admin_actions_delay
660     self.admin_actions_deadline = _deadline
661     self.future_fee = new_fee
662     self.future_admin_fee = new_admin_fee
663 
664     log.CommitNewFee(_deadline, new_fee, new_admin_fee)
665 
666 
667 @public
668 def apply_new_fee():
669     assert msg.sender == self.owner
670     assert self.admin_actions_deadline <= block.timestamp\
671         and self.admin_actions_deadline > 0
672 
673     self.admin_actions_deadline = 0
674     _fee: uint256 = self.future_fee
675     _admin_fee: uint256 = self.future_admin_fee
676     self.fee = _fee
677     self.admin_fee = _admin_fee
678 
679     log.NewFee(_fee, _admin_fee)
680 
681 
682 @public
683 def revert_new_parameters():
684     assert msg.sender == self.owner
685 
686     self.admin_actions_deadline = 0
687 
688 
689 @public
690 def commit_transfer_ownership(_owner: address):
691     assert msg.sender == self.owner
692     assert self.transfer_ownership_deadline == 0
693 
694     _deadline: timestamp = block.timestamp + admin_actions_delay
695     self.transfer_ownership_deadline = _deadline
696     self.future_owner = _owner
697 
698     log.CommitNewAdmin(_deadline, _owner)
699 
700 
701 @public
702 def apply_transfer_ownership():
703     assert msg.sender == self.owner
704     assert block.timestamp >= self.transfer_ownership_deadline\
705         and self.transfer_ownership_deadline > 0
706 
707     self.transfer_ownership_deadline = 0
708     _owner: address = self.future_owner
709     self.owner = _owner
710 
711     log.NewAdmin(_owner)
712 
713 
714 @public
715 def revert_transfer_ownership():
716     assert msg.sender == self.owner
717 
718     self.transfer_ownership_deadline = 0
719 
720 
721 @public
722 def withdraw_admin_fees():
723     assert msg.sender == self.owner
724 
725     for i in range(N_COINS):
726         c: address = self.coins[i]
727         value: uint256 = cERC20(c).balanceOf(self) - self.balances[i]
728         if value > 0:
729             assert_modifiable(cERC20(c).transfer(msg.sender, value))
730 
731 
732 @public
733 def kill_me():
734     assert msg.sender == self.owner
735     assert self.kill_deadline > block.timestamp
736     self.is_killed = True
737 
738 
739 @public
740 def unkill_me():
741     assert msg.sender == self.owner
742     self.is_killed = False