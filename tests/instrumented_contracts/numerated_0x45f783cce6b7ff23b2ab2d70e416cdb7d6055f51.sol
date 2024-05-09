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
81 max_admin_fee: constant(uint256) = 5 * 10 ** 9
82 
83 owner: public(address)
84 token: ERC20m
85 
86 admin_actions_deadline: public(timestamp)
87 transfer_ownership_deadline: public(timestamp)
88 future_A: public(uint256)
89 future_fee: public(uint256)
90 future_admin_fee: public(uint256)
91 future_owner: public(address)
92 
93 kill_deadline: timestamp
94 kill_deadline_dt: constant(uint256) = 2 * 30 * 86400
95 is_killed: bool
96 
97 
98 @public
99 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
100              _pool_token: address,
101              _A: uint256, _fee: uint256):
102     """
103     _coins: Addresses of ERC20 contracts of coins (y-tokens) involved
104     _underlying_coins: Addresses of plain coins (ERC20)
105     _pool_token: Address of the token representing LP share
106     _A: Amplification coefficient multiplied by n * (n - 1)
107     _fee: Fee to charge for exchanges
108     """
109     for i in range(N_COINS):
110         assert _coins[i] != ZERO_ADDRESS
111         assert _underlying_coins[i] != ZERO_ADDRESS
112         self.balances[i] = 0
113     self.coins = _coins
114     self.underlying_coins = _underlying_coins
115     self.A = _A
116     self.fee = _fee
117     self.admin_fee = 0
118     self.owner = msg.sender
119     self.kill_deadline = block.timestamp + kill_deadline_dt
120     self.is_killed = False
121     self.token = ERC20m(_pool_token)
122 
123 
124 @private
125 @constant
126 def _stored_rates() -> uint256[N_COINS]:
127     result: uint256[N_COINS] = PRECISION_MUL
128     for i in range(N_COINS):
129         result[i] *= yERC20(self.coins[i]).getPricePerFullShare()
130     return result
131 
132 
133 @private
134 @constant
135 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
136     result: uint256[N_COINS] = rates
137     for i in range(N_COINS):
138         result[i] = result[i] * self.balances[i] / PRECISION
139     return result
140 
141 
142 @private
143 @constant
144 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
145     result: uint256[N_COINS] = rates
146     for i in range(N_COINS):
147         result[i] = result[i] * _balances[i] / PRECISION
148     return result
149 
150 
151 @private
152 @constant
153 def get_D(xp: uint256[N_COINS]) -> uint256:
154     S: uint256 = 0
155     for _x in xp:
156         S += _x
157     if S == 0:
158         return 0
159 
160     Dprev: uint256 = 0
161     D: uint256 = S
162     Ann: uint256 = self.A * N_COINS
163     for _i in range(255):
164         D_P: uint256 = D
165         for _x in xp:
166             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
167         Dprev = D
168         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
169         # Equality with the precision of 1
170         if D > Dprev:
171             if D - Dprev <= 1:
172                 break
173         else:
174             if Dprev - D <= 1:
175                 break
176     return D
177 
178 
179 @private
180 @constant
181 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256:
182     return self.get_D(self._xp_mem(rates, _balances))
183 
184 
185 @public
186 @constant
187 def get_virtual_price() -> uint256:
188     """
189     Returns portfolio virtual price (for calculating profit)
190     scaled up by 1e18
191     """
192     D: uint256 = self.get_D(self._xp(self._stored_rates()))
193     # D is in the units similar to DAI (e.g. converted to precision 1e18)
194     # When balanced, D = n * x_u - total virtual value of the portfolio
195     token_supply: uint256 = self.token.totalSupply()
196     return D * PRECISION / token_supply
197 
198 
199 @public
200 @constant
201 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
202     """
203     Simplified method to calculate addition or reduction in token supply at
204     deposit or withdrawal without taking fees into account (but looking at
205     slippage).
206     Needed to prevent front-running, not for precise calculations!
207     """
208     _balances: uint256[N_COINS] = self.balances
209     rates: uint256[N_COINS] = self._stored_rates()
210     D0: uint256 = self.get_D_mem(rates, _balances)
211     for i in range(N_COINS):
212         if deposit:
213             _balances[i] += amounts[i]
214         else:
215             _balances[i] -= amounts[i]
216     D1: uint256 = self.get_D_mem(rates, _balances)
217     token_amount: uint256 = self.token.totalSupply()
218     diff: uint256 = 0
219     if deposit:
220         diff = D1 - D0
221     else:
222         diff = D0 - D1
223     return diff * token_amount / D0
224 
225 
226 @public
227 @nonreentrant('lock')
228 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
229     # Amounts is amounts of c-tokens
230     assert not self.is_killed
231 
232     fees: uint256[N_COINS] = ZEROS
233     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
234     _admin_fee: uint256 = self.admin_fee
235 
236     token_supply: uint256 = self.token.totalSupply()
237     rates: uint256[N_COINS] = self._stored_rates()
238     # Initial invariant
239     D0: uint256 = 0
240     old_balances: uint256[N_COINS] = self.balances
241     if token_supply > 0:
242         D0 = self.get_D_mem(rates, old_balances)
243     new_balances: uint256[N_COINS] = old_balances
244 
245     for i in range(N_COINS):
246         if token_supply == 0:
247             assert amounts[i] > 0
248         # balances store amounts of c-tokens
249         new_balances[i] = old_balances[i] + amounts[i]
250 
251     # Invariant after change
252     D1: uint256 = self.get_D_mem(rates, new_balances)
253     assert D1 > D0
254 
255     # We need to recalculate the invariant accounting for fees
256     # to calculate fair user's share
257     D2: uint256 = D1
258     if token_supply > 0:
259         # Only account for fees if we are not the first to deposit
260         for i in range(N_COINS):
261             ideal_balance: uint256 = D1 * old_balances[i] / D0
262             difference: uint256 = 0
263             if ideal_balance > new_balances[i]:
264                 difference = ideal_balance - new_balances[i]
265             else:
266                 difference = new_balances[i] - ideal_balance
267             fees[i] = _fee * difference / FEE_DENOMINATOR
268             self.balances[i] = new_balances[i] - fees[i] * _admin_fee / FEE_DENOMINATOR
269             new_balances[i] -= fees[i]
270         D2 = self.get_D_mem(rates, new_balances)
271     else:
272         self.balances = new_balances
273 
274     # Calculate, how much pool tokens to mint
275     mint_amount: uint256 = 0
276     if token_supply == 0:
277         mint_amount = D1  # Take the dust if there was any
278     else:
279         mint_amount = token_supply * (D2 - D0) / D0
280 
281     assert mint_amount >= min_mint_amount, "Slippage screwed you"
282 
283     # Take coins from the sender
284     for i in range(N_COINS):
285         assert_modifiable(
286             yERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i]))
287 
288 
289     # Mint pool tokens
290     self.token.mint(msg.sender, mint_amount)
291 
292     log.AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
293 
294 
295 @private
296 @constant
297 def get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
298     # x in the input is converted to the same price/precision
299 
300     assert (i != j) and (i >= 0) and (j >= 0) and (i < N_COINS) and (j < N_COINS)
301 
302     D: uint256 = self.get_D(_xp)
303     c: uint256 = D
304     S_: uint256 = 0
305     Ann: uint256 = self.A * N_COINS
306 
307     _x: uint256 = 0
308     for _i in range(N_COINS):
309         if _i == i:
310             _x = x
311         elif _i != j:
312             _x = _xp[_i]
313         else:
314             continue
315         S_ += _x
316         c = c * D / (_x * N_COINS)
317     c = c * D / (Ann * N_COINS)
318     b: uint256 = S_ + D / Ann  # - D
319     y_prev: uint256 = 0
320     y: uint256 = D
321     for _i in range(255):
322         y_prev = y
323         y = (y*y + c) / (2 * y + b - D)
324         # Equality with the precision of 1
325         if y > y_prev:
326             if y - y_prev <= 1:
327                 break
328         else:
329             if y_prev - y <= 1:
330                 break
331     return y
332 
333 
334 @public
335 @constant
336 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
337     # dx and dy in c-units
338     rates: uint256[N_COINS] = self._stored_rates()
339     xp: uint256[N_COINS] = self._xp(rates)
340 
341     x: uint256 = xp[i] + dx * rates[i] / PRECISION
342     y: uint256 = self.get_y(i, j, x, xp)
343     dy: uint256 = (xp[j] - y) * PRECISION / rates[j]
344     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
345     return dy - _fee
346 
347 
348 @public
349 @constant
350 def get_dx(i: int128, j: int128, dy: uint256) -> uint256:
351     # dx and dy in c-units
352     rates: uint256[N_COINS] = self._stored_rates()
353     xp: uint256[N_COINS] = self._xp(rates)
354 
355     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * rates[j] / PRECISION
356     x: uint256 = self.get_y(j, i, y, xp)
357     dx: uint256 = (x - xp[i]) * PRECISION / rates[i]
358     return dx
359 
360 
361 @public
362 @constant
363 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
364     # dx and dy in underlying units
365     rates: uint256[N_COINS] = self._stored_rates()
366     xp: uint256[N_COINS] = self._xp(rates)
367     precisions: uint256[N_COINS] = PRECISION_MUL
368 
369     x: uint256 = xp[i] + dx * precisions[i]
370     y: uint256 = self.get_y(i, j, x, xp)
371     dy: uint256 = (xp[j] - y) / precisions[j]
372     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
373     return dy - _fee
374 
375 
376 @public
377 @constant
378 def get_dx_underlying(i: int128, j: int128, dy: uint256) -> uint256:
379     # dx and dy in underlying units
380     rates: uint256[N_COINS] = self._stored_rates()
381     xp: uint256[N_COINS] = self._xp(rates)
382     precisions: uint256[N_COINS] = PRECISION_MUL
383 
384     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * precisions[j]
385     x: uint256 = self.get_y(j, i, y, xp)
386     dx: uint256 = (x - xp[i]) / precisions[i]
387     return dx
388 
389 
390 @private
391 def _exchange(i: int128, j: int128, dx: uint256, rates: uint256[N_COINS]) -> uint256:
392     assert not self.is_killed
393     # dx and dy are in c-tokens
394 
395     xp: uint256[N_COINS] = self._xp(rates)
396 
397     x: uint256 = xp[i] + dx * rates[i] / PRECISION
398     y: uint256 = self.get_y(i, j, x, xp)
399     dy: uint256 = xp[j] - y
400     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
401     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
402     self.balances[i] = x * PRECISION / rates[i]
403     self.balances[j] = (y + (dy_fee - dy_admin_fee)) * PRECISION / rates[j]
404 
405     _dy: uint256 = (dy - dy_fee) * PRECISION / rates[j]
406 
407     return _dy
408 
409 
410 @public
411 @nonreentrant('lock')
412 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256):
413     rates: uint256[N_COINS] = self._stored_rates()
414     dy: uint256 = self._exchange(i, j, dx, rates)
415     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
416 
417     assert_modifiable(yERC20(self.coins[i]).transferFrom(msg.sender, self, dx))
418 
419     assert_modifiable(yERC20(self.coins[j]).transfer(msg.sender, dy))
420 
421     log.TokenExchange(msg.sender, i, dx, j, dy)
422 
423 
424 @public
425 @nonreentrant('lock')
426 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256):
427     rates: uint256[N_COINS] = self._stored_rates()
428     precisions: uint256[N_COINS] = PRECISION_MUL
429     rate_i: uint256 = rates[i] / precisions[i]
430     rate_j: uint256 = rates[j] / precisions[j]
431     dx_: uint256 = dx * PRECISION / rate_i
432 
433     dy_: uint256 = self._exchange(i, j, dx_, rates)
434     dy: uint256 = dy_ * rate_j / PRECISION
435     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
436     tethered: bool[N_COINS] = TETHERED
437 
438     ok: uint256 = 0
439     if tethered[i]:
440         USDT(self.underlying_coins[i]).transferFrom(msg.sender, self, dx)
441     else:
442         assert_modifiable(ERC20(self.underlying_coins[i])\
443             .transferFrom(msg.sender, self, dx))
444     ERC20(self.underlying_coins[i]).approve(self.coins[i], dx)
445     yERC20(self.coins[i]).deposit(dx)
446     yERC20(self.coins[j]).withdraw(dy_)
447 
448     # y-tokens calculate imprecisely - use all available
449     dy = ERC20(self.underlying_coins[j]).balanceOf(self)
450     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
451 
452     if tethered[j]:
453         USDT(self.underlying_coins[j]).transfer(msg.sender, dy)
454     else:
455         assert_modifiable(ERC20(self.underlying_coins[j])\
456             .transfer(msg.sender, dy))
457 
458 
459     log.TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
460 
461 
462 @public
463 @nonreentrant('lock')
464 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
465     total_supply: uint256 = self.token.totalSupply()
466     amounts: uint256[N_COINS] = ZEROS
467     fees: uint256[N_COINS] = ZEROS
468 
469     for i in range(N_COINS):
470         value: uint256 = self.balances[i] * _amount / total_supply
471         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
472         self.balances[i] -= value
473         amounts[i] = value
474         assert_modifiable(yERC20(self.coins[i]).transfer(
475             msg.sender, value))
476 
477     self.token.burnFrom(msg.sender, _amount)  # Will raise if not enough
478 
479     log.RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
480 
481 
482 @public
483 @nonreentrant('lock')
484 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256):
485     assert not self.is_killed
486 
487     token_supply: uint256 = self.token.totalSupply()
488     assert token_supply > 0
489     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
490     _admin_fee: uint256 = self.admin_fee
491     rates: uint256[N_COINS] = self._stored_rates()
492 
493     old_balances: uint256[N_COINS] = self.balances
494     new_balances: uint256[N_COINS] = old_balances
495     D0: uint256 = self.get_D_mem(rates, old_balances)
496     for i in range(N_COINS):
497         new_balances[i] -= amounts[i]
498     D1: uint256 = self.get_D_mem(rates, new_balances)
499     fees: uint256[N_COINS] = ZEROS
500     for i in range(N_COINS):
501         ideal_balance: uint256 = D1 * old_balances[i] / D0
502         difference: uint256 = 0
503         if ideal_balance > new_balances[i]:
504             difference = ideal_balance - new_balances[i]
505         else:
506             difference = new_balances[i] - ideal_balance
507         fees[i] = _fee * difference / FEE_DENOMINATOR
508         self.balances[i] = new_balances[i] - fees[i] * _admin_fee / FEE_DENOMINATOR
509         new_balances[i] -= fees[i]
510     D2: uint256 = self.get_D_mem(rates, new_balances)
511 
512     token_amount: uint256 = (D0 - D2) * token_supply / D0
513     assert token_amount > 0
514     assert token_amount <= max_burn_amount, "Slippage screwed you"
515 
516     for i in range(N_COINS):
517         assert_modifiable(yERC20(self.coins[i]).transfer(msg.sender, amounts[i]))
518     self.token.burnFrom(msg.sender, token_amount)  # Will raise if not enough
519 
520     log.RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
521 
522 
523 ### Admin functions ###
524 @public
525 def commit_new_parameters(amplification: uint256,
526                           new_fee: uint256,
527                           new_admin_fee: uint256):
528     assert msg.sender == self.owner
529     assert self.admin_actions_deadline == 0
530     assert new_admin_fee <= max_admin_fee
531 
532     _deadline: timestamp = block.timestamp + admin_actions_delay
533     self.admin_actions_deadline = _deadline
534     self.future_A = amplification
535     self.future_fee = new_fee
536     self.future_admin_fee = new_admin_fee
537 
538     log.CommitNewParameters(_deadline, amplification, new_fee, new_admin_fee)
539 
540 
541 @public
542 def apply_new_parameters():
543     assert msg.sender == self.owner
544     assert self.admin_actions_deadline <= block.timestamp\
545         and self.admin_actions_deadline > 0
546 
547     self.admin_actions_deadline = 0
548     _A: uint256 = self.future_A
549     _fee: uint256 = self.future_fee
550     _admin_fee: uint256 = self.future_admin_fee
551     self.A = _A
552     self.fee = _fee
553     self.admin_fee = _admin_fee
554 
555     log.NewParameters(_A, _fee, _admin_fee)
556 
557 
558 @public
559 def revert_new_parameters():
560     assert msg.sender == self.owner
561 
562     self.admin_actions_deadline = 0
563 
564 
565 @public
566 def commit_transfer_ownership(_owner: address):
567     assert msg.sender == self.owner
568     assert self.transfer_ownership_deadline == 0
569 
570     _deadline: timestamp = block.timestamp + admin_actions_delay
571     self.transfer_ownership_deadline = _deadline
572     self.future_owner = _owner
573 
574     log.CommitNewAdmin(_deadline, _owner)
575 
576 
577 @public
578 def apply_transfer_ownership():
579     assert msg.sender == self.owner
580     assert block.timestamp >= self.transfer_ownership_deadline\
581         and self.transfer_ownership_deadline > 0
582 
583     self.transfer_ownership_deadline = 0
584     _owner: address = self.future_owner
585     self.owner = _owner
586 
587     log.NewAdmin(_owner)
588 
589 
590 @public
591 def revert_transfer_ownership():
592     assert msg.sender == self.owner
593 
594     self.transfer_ownership_deadline = 0
595 
596 
597 @public
598 def withdraw_admin_fees():
599     assert msg.sender == self.owner
600     _precisions: uint256[N_COINS] = PRECISION_MUL
601 
602     for i in range(N_COINS):
603         c: address = self.coins[i]
604         value: uint256 = yERC20(c).balanceOf(self) - self.balances[i]
605         if value > 0:
606             assert_modifiable(yERC20(c).transfer(msg.sender, value))
607 
608 
609 @public
610 def kill_me():
611     assert msg.sender == self.owner
612     assert self.kill_deadline > block.timestamp
613     self.is_killed = True
614 
615 
616 @public
617 def unkill_me():
618     assert msg.sender == self.owner
619     self.is_killed = False