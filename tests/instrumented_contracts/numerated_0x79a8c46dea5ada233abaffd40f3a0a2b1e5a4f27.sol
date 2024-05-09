1 # (c) Curve.Fi, 2020
2 
3 
4 # External Contracts
5 contract ERC20m:
6     def totalSupply() -> uint256: constant
7     def allowance(_owner: address, _spender: address) -> uint256: constant
8     def transfer(_to: address, _value: uint256) -> bool: modifying
9     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
10     def approve(_spender: address, _value: uint256) -> bool: modifying
11     def mint(_to: address, _value: uint256): modifying
12     def burn(_value: uint256): modifying
13     def burnFrom(_to: address, _value: uint256): modifying
14     def name() -> string[64]: constant
15     def symbol() -> string[32]: constant
16     def decimals() -> uint256: constant
17     def balanceOf(arg0: address) -> uint256: constant
18     def set_minter(_minter: address): modifying
19 
20 
21 
22 # External Contracts
23 contract yERC20:
24     def totalSupply() -> uint256: constant
25     def allowance(_owner: address, _spender: address) -> uint256: constant
26     def transfer(_to: address, _value: uint256) -> bool: modifying
27     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
28     def approve(_spender: address, _value: uint256) -> bool: modifying
29     def name() -> string[64]: constant
30     def symbol() -> string[32]: constant
31     def decimals() -> uint256: constant
32     def balanceOf(arg0: address) -> uint256: constant
33     def deposit(depositAmount: uint256): modifying
34     def withdraw(withdrawTokens: uint256): modifying
35     def getPricePerFullShare() -> uint256: constant
36 
37 
38 from vyper.interfaces import ERC20
39 
40 # Tether transfer-only ABI
41 contract USDT:
42     def transfer(_to: address, _value: uint256): modifying
43     def transferFrom(_from: address, _to: address, _value: uint256): modifying
44 
45 # This can (and needs to) be changed at compile time
46 N_COINS: constant(int128) = 4  # <- change
47 
48 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
49 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256, ZERO256, ZERO256]  # <- change
50 
51 TETHERED: constant(bool[N_COINS]) = [False, False, True, False]
52 
53 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
54 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
55 PRECISION_MUL: constant(uint256[N_COINS]) = [convert(1, uint256), convert(1000000000000, uint256), convert(1000000000000, uint256), convert(1, uint256)]
56 # PRECISION_MUL: constant(uint256[N_COINS]) = [
57 #     PRECISION / convert(10 ** 18, uint256),  # DAI
58 #     PRECISION / convert(10 ** 6, uint256),   # USDC
59 #     PRECISION / convert(10 ** 6, uint256),   # USDT
60 #     PRECISION / convert(10 ** 18, uint256)]  # TUSD
61 
62 admin_actions_delay: constant(uint256) = 3 * 86400
63 
64 # Events
65 TokenExchange: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
66 TokenExchangeUnderlying: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
67 AddLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
68 RemoveLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], token_supply: uint256})
69 RemoveLiquidityImbalance: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
70 CommitNewAdmin: event({deadline: indexed(timestamp), admin: indexed(address)})
71 NewAdmin: event({admin: indexed(address)})
72 CommitNewParameters: event({deadline: indexed(timestamp), A: uint256, fee: uint256, admin_fee: uint256})
73 NewParameters: event({A: uint256, fee: uint256, admin_fee: uint256})
74 
75 coins: public(address[N_COINS])
76 underlying_coins: public(address[N_COINS])
77 balances: public(uint256[N_COINS])
78 A: public(uint256)  # 2 x amplification coefficient
79 fee: public(uint256)  # fee * 1e10
80 admin_fee: public(uint256)  # admin_fee * 1e10
81 
82 max_admin_fee: constant(uint256) = 5 * 10 ** 9
83 max_fee: constant(uint256) = 5 * 10 ** 9
84 max_A: constant(uint256) = 10 ** 6
85 
86 owner: public(address)
87 token: ERC20m
88 
89 admin_actions_deadline: public(timestamp)
90 transfer_ownership_deadline: public(timestamp)
91 future_A: public(uint256)
92 future_fee: public(uint256)
93 future_admin_fee: public(uint256)
94 future_owner: public(address)
95 
96 kill_deadline: timestamp
97 kill_deadline_dt: constant(uint256) = 2 * 30 * 86400
98 is_killed: bool
99 
100 
101 @public
102 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
103              _pool_token: address,
104              _A: uint256, _fee: uint256):
105     """
106     _coins: Addresses of ERC20 contracts of coins (y-tokens) involved
107     _underlying_coins: Addresses of plain coins (ERC20)
108     _pool_token: Address of the token representing LP share
109     _A: Amplification coefficient multiplied by n * (n - 1)
110     _fee: Fee to charge for exchanges
111     """
112     for i in range(N_COINS):
113         assert _coins[i] != ZERO_ADDRESS
114         assert _underlying_coins[i] != ZERO_ADDRESS
115         self.balances[i] = 0
116     self.coins = _coins
117     self.underlying_coins = _underlying_coins
118     self.A = _A
119     self.fee = _fee
120     self.admin_fee = 0
121     self.owner = msg.sender
122     self.kill_deadline = block.timestamp + kill_deadline_dt
123     self.is_killed = False
124     self.token = ERC20m(_pool_token)
125 
126 
127 @private
128 @constant
129 def _stored_rates() -> uint256[N_COINS]:
130     result: uint256[N_COINS] = PRECISION_MUL
131     for i in range(N_COINS):
132         result[i] *= yERC20(self.coins[i]).getPricePerFullShare()
133     return result
134 
135 
136 @private
137 @constant
138 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
139     result: uint256[N_COINS] = rates
140     for i in range(N_COINS):
141         result[i] = result[i] * self.balances[i] / PRECISION
142     return result
143 
144 
145 @private
146 @constant
147 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
148     result: uint256[N_COINS] = rates
149     for i in range(N_COINS):
150         result[i] = result[i] * _balances[i] / PRECISION
151     return result
152 
153 
154 @private
155 @constant
156 def get_D(xp: uint256[N_COINS]) -> uint256:
157     S: uint256 = 0
158     for _x in xp:
159         S += _x
160     if S == 0:
161         return 0
162 
163     Dprev: uint256 = 0
164     D: uint256 = S
165     Ann: uint256 = self.A * N_COINS
166     for _i in range(255):
167         D_P: uint256 = D
168         for _x in xp:
169             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
170         Dprev = D
171         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
172         # Equality with the precision of 1
173         if D > Dprev:
174             if D - Dprev <= 1:
175                 break
176         else:
177             if Dprev - D <= 1:
178                 break
179     return D
180 
181 
182 @private
183 @constant
184 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256:
185     return self.get_D(self._xp_mem(rates, _balances))
186 
187 
188 @public
189 @constant
190 def get_virtual_price() -> uint256:
191     """
192     Returns portfolio virtual price (for calculating profit)
193     scaled up by 1e18
194     """
195     D: uint256 = self.get_D(self._xp(self._stored_rates()))
196     # D is in the units similar to DAI (e.g. converted to precision 1e18)
197     # When balanced, D = n * x_u - total virtual value of the portfolio
198     token_supply: uint256 = self.token.totalSupply()
199     return D * PRECISION / token_supply
200 
201 
202 @public
203 @constant
204 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
205     """
206     Simplified method to calculate addition or reduction in token supply at
207     deposit or withdrawal without taking fees into account (but looking at
208     slippage).
209     Needed to prevent front-running, not for precise calculations!
210     """
211     _balances: uint256[N_COINS] = self.balances
212     rates: uint256[N_COINS] = self._stored_rates()
213     D0: uint256 = self.get_D_mem(rates, _balances)
214     for i in range(N_COINS):
215         if deposit:
216             _balances[i] += amounts[i]
217         else:
218             _balances[i] -= amounts[i]
219     D1: uint256 = self.get_D_mem(rates, _balances)
220     token_amount: uint256 = self.token.totalSupply()
221     diff: uint256 = 0
222     if deposit:
223         diff = D1 - D0
224     else:
225         diff = D0 - D1
226     return diff * token_amount / D0
227 
228 
229 @public
230 @nonreentrant('lock')
231 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
232     # Amounts is amounts of c-tokens
233     assert not self.is_killed
234 
235     fees: uint256[N_COINS] = ZEROS
236     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
237     _admin_fee: uint256 = self.admin_fee
238 
239     token_supply: uint256 = self.token.totalSupply()
240     rates: uint256[N_COINS] = self._stored_rates()
241     # Initial invariant
242     D0: uint256 = 0
243     old_balances: uint256[N_COINS] = self.balances
244     if token_supply > 0:
245         D0 = self.get_D_mem(rates, old_balances)
246     new_balances: uint256[N_COINS] = old_balances
247 
248     for i in range(N_COINS):
249         if token_supply == 0:
250             assert amounts[i] > 0
251         # balances store amounts of c-tokens
252         new_balances[i] = old_balances[i] + amounts[i]
253 
254     # Invariant after change
255     D1: uint256 = self.get_D_mem(rates, new_balances)
256     assert D1 > D0
257 
258     # We need to recalculate the invariant accounting for fees
259     # to calculate fair user's share
260     D2: uint256 = D1
261     if token_supply > 0:
262         # Only account for fees if we are not the first to deposit
263         for i in range(N_COINS):
264             ideal_balance: uint256 = D1 * old_balances[i] / D0
265             difference: uint256 = 0
266             if ideal_balance > new_balances[i]:
267                 difference = ideal_balance - new_balances[i]
268             else:
269                 difference = new_balances[i] - ideal_balance
270             fees[i] = _fee * difference / FEE_DENOMINATOR
271             self.balances[i] = new_balances[i] - fees[i] * _admin_fee / FEE_DENOMINATOR
272             new_balances[i] -= fees[i]
273         D2 = self.get_D_mem(rates, new_balances)
274     else:
275         self.balances = new_balances
276 
277     # Calculate, how much pool tokens to mint
278     mint_amount: uint256 = 0
279     if token_supply == 0:
280         mint_amount = D1  # Take the dust if there was any
281     else:
282         mint_amount = token_supply * (D2 - D0) / D0
283 
284     assert mint_amount >= min_mint_amount, "Slippage screwed you"
285 
286     # Take coins from the sender
287     for i in range(N_COINS):
288         assert_modifiable(
289             yERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i]))
290 
291 
292     # Mint pool tokens
293     self.token.mint(msg.sender, mint_amount)
294 
295     log.AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
296 
297 
298 @private
299 @constant
300 def get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
301     # x in the input is converted to the same price/precision
302 
303     assert (i != j) and (i >= 0) and (j >= 0) and (i < N_COINS) and (j < N_COINS)
304 
305     D: uint256 = self.get_D(_xp)
306     c: uint256 = D
307     S_: uint256 = 0
308     Ann: uint256 = self.A * N_COINS
309 
310     _x: uint256 = 0
311     for _i in range(N_COINS):
312         if _i == i:
313             _x = x
314         elif _i != j:
315             _x = _xp[_i]
316         else:
317             continue
318         S_ += _x
319         c = c * D / (_x * N_COINS)
320     c = c * D / (Ann * N_COINS)
321     b: uint256 = S_ + D / Ann  # - D
322     y_prev: uint256 = 0
323     y: uint256 = D
324     for _i in range(255):
325         y_prev = y
326         y = (y*y + c) / (2 * y + b - D)
327         # Equality with the precision of 1
328         if y > y_prev:
329             if y - y_prev <= 1:
330                 break
331         else:
332             if y_prev - y <= 1:
333                 break
334     return y
335 
336 
337 @public
338 @constant
339 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
340     # dx and dy in c-units
341     rates: uint256[N_COINS] = self._stored_rates()
342     xp: uint256[N_COINS] = self._xp(rates)
343 
344     x: uint256 = xp[i] + dx * rates[i] / PRECISION
345     y: uint256 = self.get_y(i, j, x, xp)
346     dy: uint256 = (xp[j] - y) * PRECISION / rates[j]
347     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
348     return dy - _fee
349 
350 
351 @public
352 @constant
353 def get_dx(i: int128, j: int128, dy: uint256) -> uint256:
354     # dx and dy in c-units
355     rates: uint256[N_COINS] = self._stored_rates()
356     xp: uint256[N_COINS] = self._xp(rates)
357 
358     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * rates[j] / PRECISION
359     x: uint256 = self.get_y(j, i, y, xp)
360     dx: uint256 = (x - xp[i]) * PRECISION / rates[i]
361     return dx
362 
363 
364 @public
365 @constant
366 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
367     # dx and dy in underlying units
368     rates: uint256[N_COINS] = self._stored_rates()
369     xp: uint256[N_COINS] = self._xp(rates)
370     precisions: uint256[N_COINS] = PRECISION_MUL
371 
372     x: uint256 = xp[i] + dx * precisions[i]
373     y: uint256 = self.get_y(i, j, x, xp)
374     dy: uint256 = (xp[j] - y) / precisions[j]
375     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
376     return dy - _fee
377 
378 
379 @public
380 @constant
381 def get_dx_underlying(i: int128, j: int128, dy: uint256) -> uint256:
382     # dx and dy in underlying units
383     rates: uint256[N_COINS] = self._stored_rates()
384     xp: uint256[N_COINS] = self._xp(rates)
385     precisions: uint256[N_COINS] = PRECISION_MUL
386 
387     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * precisions[j]
388     x: uint256 = self.get_y(j, i, y, xp)
389     dx: uint256 = (x - xp[i]) / precisions[i]
390     return dx
391 
392 
393 @private
394 def _exchange(i: int128, j: int128, dx: uint256, rates: uint256[N_COINS]) -> uint256:
395     assert not self.is_killed
396     # dx and dy are in c-tokens
397 
398     xp: uint256[N_COINS] = self._xp(rates)
399 
400     x: uint256 = xp[i] + dx * rates[i] / PRECISION
401     y: uint256 = self.get_y(i, j, x, xp)
402     dy: uint256 = xp[j] - y
403     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
404     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
405     self.balances[i] = x * PRECISION / rates[i]
406     self.balances[j] = (y + (dy_fee - dy_admin_fee)) * PRECISION / rates[j]
407 
408     _dy: uint256 = (dy - dy_fee) * PRECISION / rates[j]
409 
410     return _dy
411 
412 
413 @public
414 @nonreentrant('lock')
415 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256):
416     rates: uint256[N_COINS] = self._stored_rates()
417     dy: uint256 = self._exchange(i, j, dx, rates)
418     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
419 
420     assert_modifiable(yERC20(self.coins[i]).transferFrom(msg.sender, self, dx))
421 
422     assert_modifiable(yERC20(self.coins[j]).transfer(msg.sender, dy))
423 
424     log.TokenExchange(msg.sender, i, dx, j, dy)
425 
426 
427 @public
428 @nonreentrant('lock')
429 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256):
430     rates: uint256[N_COINS] = self._stored_rates()
431     precisions: uint256[N_COINS] = PRECISION_MUL
432     rate_i: uint256 = rates[i] / precisions[i]
433     rate_j: uint256 = rates[j] / precisions[j]
434     dx_: uint256 = dx * PRECISION / rate_i
435 
436     dy_: uint256 = self._exchange(i, j, dx_, rates)
437     dy: uint256 = dy_ * rate_j / PRECISION
438     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
439     tethered: bool[N_COINS] = TETHERED
440 
441     if tethered[i]:
442         USDT(self.underlying_coins[i]).transferFrom(msg.sender, self, dx)
443     else:
444         assert_modifiable(ERC20(self.underlying_coins[i])\
445             .transferFrom(msg.sender, self, dx))
446     ERC20(self.underlying_coins[i]).approve(self.coins[i], dx)
447     yERC20(self.coins[i]).deposit(dx)
448     yERC20(self.coins[j]).withdraw(dy_)
449 
450     # y-tokens calculate imprecisely - use all available
451     dy = ERC20(self.underlying_coins[j]).balanceOf(self)
452     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
453 
454     if tethered[j]:
455         USDT(self.underlying_coins[j]).transfer(msg.sender, dy)
456     else:
457         assert_modifiable(ERC20(self.underlying_coins[j])\
458             .transfer(msg.sender, dy))
459 
460 
461     log.TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
462 
463 
464 @public
465 @nonreentrant('lock')
466 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
467     total_supply: uint256 = self.token.totalSupply()
468     amounts: uint256[N_COINS] = ZEROS
469     fees: uint256[N_COINS] = ZEROS
470 
471     for i in range(N_COINS):
472         value: uint256 = self.balances[i] * _amount / total_supply
473         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
474         self.balances[i] -= value
475         amounts[i] = value
476         assert_modifiable(yERC20(self.coins[i]).transfer(
477             msg.sender, value))
478 
479     self.token.burnFrom(msg.sender, _amount)  # Will raise if not enough
480 
481     log.RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
482 
483 
484 @public
485 @nonreentrant('lock')
486 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256):
487     assert not self.is_killed
488 
489     token_supply: uint256 = self.token.totalSupply()
490     assert token_supply > 0
491     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
492     _admin_fee: uint256 = self.admin_fee
493     rates: uint256[N_COINS] = self._stored_rates()
494 
495     old_balances: uint256[N_COINS] = self.balances
496     new_balances: uint256[N_COINS] = old_balances
497     D0: uint256 = self.get_D_mem(rates, old_balances)
498     for i in range(N_COINS):
499         new_balances[i] -= amounts[i]
500     D1: uint256 = self.get_D_mem(rates, new_balances)
501     fees: uint256[N_COINS] = ZEROS
502     for i in range(N_COINS):
503         ideal_balance: uint256 = D1 * old_balances[i] / D0
504         difference: uint256 = 0
505         if ideal_balance > new_balances[i]:
506             difference = ideal_balance - new_balances[i]
507         else:
508             difference = new_balances[i] - ideal_balance
509         fees[i] = _fee * difference / FEE_DENOMINATOR
510         self.balances[i] = new_balances[i] - fees[i] * _admin_fee / FEE_DENOMINATOR
511         new_balances[i] -= fees[i]
512     D2: uint256 = self.get_D_mem(rates, new_balances)
513 
514     token_amount: uint256 = (D0 - D2) * token_supply / D0
515     assert token_amount > 0
516     assert token_amount <= max_burn_amount, "Slippage screwed you"
517 
518     for i in range(N_COINS):
519         assert_modifiable(yERC20(self.coins[i]).transfer(msg.sender, amounts[i]))
520     self.token.burnFrom(msg.sender, token_amount)  # Will raise if not enough
521 
522     log.RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
523 
524 
525 ### Admin functions ###
526 @public
527 def commit_new_parameters(amplification: uint256,
528                           new_fee: uint256,
529                           new_admin_fee: uint256):
530     assert msg.sender == self.owner
531     assert self.admin_actions_deadline == 0
532     assert new_admin_fee <= max_admin_fee
533     assert new_fee <= max_fee
534     assert amplification <= max_A
535 
536     _deadline: timestamp = block.timestamp + admin_actions_delay
537     self.admin_actions_deadline = _deadline
538     self.future_A = amplification
539     self.future_fee = new_fee
540     self.future_admin_fee = new_admin_fee
541 
542     log.CommitNewParameters(_deadline, amplification, new_fee, new_admin_fee)
543 
544 
545 @public
546 def apply_new_parameters():
547     assert msg.sender == self.owner
548     assert self.admin_actions_deadline <= block.timestamp\
549         and self.admin_actions_deadline > 0
550 
551     self.admin_actions_deadline = 0
552     _A: uint256 = self.future_A
553     _fee: uint256 = self.future_fee
554     _admin_fee: uint256 = self.future_admin_fee
555     self.A = _A
556     self.fee = _fee
557     self.admin_fee = _admin_fee
558 
559     log.NewParameters(_A, _fee, _admin_fee)
560 
561 
562 @public
563 def revert_new_parameters():
564     assert msg.sender == self.owner
565 
566     self.admin_actions_deadline = 0
567 
568 
569 @public
570 def commit_transfer_ownership(_owner: address):
571     assert msg.sender == self.owner
572     assert self.transfer_ownership_deadline == 0
573 
574     _deadline: timestamp = block.timestamp + admin_actions_delay
575     self.transfer_ownership_deadline = _deadline
576     self.future_owner = _owner
577 
578     log.CommitNewAdmin(_deadline, _owner)
579 
580 
581 @public
582 def apply_transfer_ownership():
583     assert msg.sender == self.owner
584     assert block.timestamp >= self.transfer_ownership_deadline\
585         and self.transfer_ownership_deadline > 0
586 
587     self.transfer_ownership_deadline = 0
588     _owner: address = self.future_owner
589     self.owner = _owner
590 
591     log.NewAdmin(_owner)
592 
593 
594 @public
595 def revert_transfer_ownership():
596     assert msg.sender == self.owner
597 
598     self.transfer_ownership_deadline = 0
599 
600 
601 @public
602 def withdraw_admin_fees():
603     assert msg.sender == self.owner
604     _precisions: uint256[N_COINS] = PRECISION_MUL
605 
606     for i in range(N_COINS):
607         c: address = self.coins[i]
608         value: uint256 = yERC20(c).balanceOf(self) - self.balances[i]
609         if value > 0:
610             assert_modifiable(yERC20(c).transfer(msg.sender, value))
611 
612 
613 @public
614 def kill_me():
615     assert msg.sender == self.owner
616     assert self.kill_deadline > block.timestamp
617     self.is_killed = True
618 
619 
620 @public
621 def unkill_me():
622     assert msg.sender == self.owner
623     self.is_killed = False