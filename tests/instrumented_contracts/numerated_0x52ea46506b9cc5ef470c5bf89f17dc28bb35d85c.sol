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
23 contract cERC20:
24     def totalSupply() -> uint256: constant
25     def allowance(_owner: address, _spender: address) -> uint256: constant
26     def transfer(_to: address, _value: uint256) -> bool: modifying
27     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
28     def approve(_spender: address, _value: uint256) -> bool: modifying
29     def burn(_value: uint256): modifying
30     def burnFrom(_to: address, _value: uint256): modifying
31     def name() -> string[64]: constant
32     def symbol() -> string[32]: constant
33     def decimals() -> uint256: constant
34     def balanceOf(arg0: address) -> uint256: constant
35     def mint(mintAmount: uint256) -> uint256: modifying
36     def redeem(redeemTokens: uint256) -> uint256: modifying
37     def redeemUnderlying(redeemAmount: uint256) -> uint256: modifying
38     def exchangeRateStored() -> uint256: constant
39     def exchangeRateCurrent() -> uint256: modifying
40     def supplyRatePerBlock() -> uint256: constant
41     def accrualBlockNumber() -> uint256: constant
42 
43 
44 from vyper.interfaces import ERC20
45 
46 
47 # Tether transfer-only ABI
48 contract USDT:
49     def transfer(_to: address, _value: uint256): modifying
50     def transferFrom(_from: address, _to: address, _value: uint256): modifying
51 
52 
53 # This can (and needs to) be changed at compile time
54 N_COINS: constant(int128) = 3  # <- change
55 
56 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
57 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256, ZERO256]  # <- change
58 
59 USE_LENDING: constant(bool[N_COINS]) = [True, True, False]
60 TETHERED: constant(bool[N_COINS]) = [False, False, True]
61 
62 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
63 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
64 PRECISION_MUL: constant(uint256[N_COINS]) = [convert(1, uint256), convert(1000000000000, uint256), convert(1000000000000, uint256)]
65 # PRECISION_MUL: constant(uint256[N_COINS]) = [
66 #     PRECISION / convert(PRECISION, uint256),  # DAI
67 #     PRECISION / convert(10 ** 6, uint256),   # USDC
68 #     PRECISION / convert(10 ** 6, uint256)]   # USDT
69 
70 
71 admin_actions_delay: constant(uint256) = 3 * 86400
72 
73 # Events
74 TokenExchange: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
75 TokenExchangeUnderlying: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
76 AddLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
77 RemoveLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], token_supply: uint256})
78 RemoveLiquidityImbalance: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
79 CommitNewAdmin: event({deadline: indexed(timestamp), admin: indexed(address)})
80 NewAdmin: event({admin: indexed(address)})
81 CommitNewParameters: event({deadline: indexed(timestamp), A: uint256, fee: uint256, admin_fee: uint256})
82 NewParameters: event({A: uint256, fee: uint256, admin_fee: uint256})
83 
84 coins: public(address[N_COINS])
85 underlying_coins: public(address[N_COINS])
86 balances: public(uint256[N_COINS])
87 A: public(uint256)  # 2 x amplification coefficient
88 fee: public(uint256)  # fee * 1e10
89 admin_fee: public(uint256)  # admin_fee * 1e10
90 max_admin_fee: constant(uint256) = 5 * 10 ** 9
91 
92 owner: public(address)
93 token: ERC20m
94 
95 admin_actions_deadline: public(timestamp)
96 transfer_ownership_deadline: public(timestamp)
97 future_A: public(uint256)
98 future_fee: public(uint256)
99 future_admin_fee: public(uint256)
100 future_owner: public(address)
101 
102 kill_deadline: timestamp
103 kill_deadline_dt: constant(uint256) = 2 * 30 * 86400
104 is_killed: bool
105 
106 
107 @public
108 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
109              _pool_token: address,
110              _A: uint256, _fee: uint256):
111     """
112     _coins: Addresses of ERC20 conracts of coins (c-tokens) involved
113     _underlying_coins: Addresses of plain coins (ERC20)
114     _pool_token: Address of the token representing LP share
115     _A: Amplification coefficient multiplied by n * (n - 1)
116     _fee: Fee to charge for exchanges
117     """
118     for i in range(N_COINS):
119         assert _coins[i] != ZERO_ADDRESS
120         assert _underlying_coins[i] != ZERO_ADDRESS
121         self.balances[i] = 0
122     self.coins = _coins
123     self.underlying_coins = _underlying_coins
124     self.A = _A
125     self.fee = _fee
126     self.admin_fee = 0
127     self.owner = msg.sender
128     self.kill_deadline = block.timestamp + kill_deadline_dt
129     self.is_killed = False
130     self.token = ERC20m(_pool_token)
131 
132 
133 @private
134 @constant
135 def _stored_rates() -> uint256[N_COINS]:
136     # exchangeRateStored * (1 + supplyRatePerBlock * (getBlockNumber - accrualBlockNumber) / 1e18)
137     result: uint256[N_COINS] = PRECISION_MUL
138     use_lending: bool[N_COINS] = USE_LENDING
139     for i in range(N_COINS):
140         rate: uint256 = PRECISION  # Used with no lending
141         if use_lending[i]:
142             rate = cERC20(self.coins[i]).exchangeRateStored()
143             supply_rate: uint256 = cERC20(self.coins[i]).supplyRatePerBlock()
144             old_block: uint256 = cERC20(self.coins[i]).accrualBlockNumber()
145             rate += rate * supply_rate * (block.number - old_block) / PRECISION
146         result[i] *= rate
147     return result
148 
149 
150 @private
151 def _current_rates() -> uint256[N_COINS]:
152     result: uint256[N_COINS] = PRECISION_MUL
153     use_lending: bool[N_COINS] = USE_LENDING
154     for i in range(N_COINS):
155         rate: uint256 = PRECISION  # Used with no lending
156         if use_lending[i]:
157             rate = cERC20(self.coins[i]).exchangeRateCurrent()
158         result[i] *= rate
159     return result
160 
161 
162 @private
163 @constant
164 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
165     result: uint256[N_COINS] = rates
166     for i in range(N_COINS):
167         result[i] = result[i] * self.balances[i] / PRECISION
168     return result
169 
170 
171 @private
172 @constant
173 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
174     result: uint256[N_COINS] = rates
175     for i in range(N_COINS):
176         result[i] = result[i] * _balances[i] / PRECISION
177     return result
178 
179 
180 @private
181 @constant
182 def get_D(xp: uint256[N_COINS]) -> uint256:
183     S: uint256 = 0
184     for _x in xp:
185         S += _x
186     if S == 0:
187         return 0
188 
189     Dprev: uint256 = 0
190     D: uint256 = S
191     Ann: uint256 = self.A * N_COINS
192     for _i in range(255):
193         D_P: uint256 = D
194         for _x in xp:
195             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
196         Dprev = D
197         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
198         # Equality with the precision of 1
199         if D > Dprev:
200             if D - Dprev <= 1:
201                 break
202         else:
203             if Dprev - D <= 1:
204                 break
205     return D
206 
207 
208 @private
209 @constant
210 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256:
211     return self.get_D(self._xp_mem(rates, _balances))
212 
213 
214 @public
215 @constant
216 def get_virtual_price() -> uint256:
217     """
218     Returns portfolio virtual price (for calculating profit)
219     scaled up by 1e18
220     """
221     D: uint256 = self.get_D(self._xp(self._stored_rates()))
222     # D is in the units similar to DAI (e.g. converted to precision 1e18)
223     # When balanced, D = n * x_u - total virtual value of the portfolio
224     token_supply: uint256 = self.token.totalSupply()
225     return D * PRECISION / token_supply
226 
227 
228 @public
229 @constant
230 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
231     """
232     Simplified method to calculate addition or reduction in token supply at
233     deposit or withdrawal without taking fees into account (but looking at
234     slippage).
235     Needed to prevent front-running, not for precise calculations!
236     """
237     _balances: uint256[N_COINS] = self.balances
238     rates: uint256[N_COINS] = self._stored_rates()
239     D0: uint256 = self.get_D_mem(rates, _balances)
240     for i in range(N_COINS):
241         if deposit:
242             _balances[i] += amounts[i]
243         else:
244             _balances[i] -= amounts[i]
245     D1: uint256 = self.get_D_mem(rates, _balances)
246     token_amount: uint256 = self.token.totalSupply()
247     diff: uint256 = 0
248     if deposit:
249         diff = D1 - D0
250     else:
251         diff = D0 - D1
252     return diff * token_amount / D0
253 
254 
255 @public
256 @nonreentrant('lock')
257 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
258     # Amounts is amounts of c-tokens
259     assert not self.is_killed
260 
261     tethered: bool[N_COINS] = TETHERED
262     use_lending: bool[N_COINS] = USE_LENDING
263     fees: uint256[N_COINS] = ZEROS
264     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
265     _admin_fee: uint256 = self.admin_fee
266 
267     token_supply: uint256 = self.token.totalSupply()
268     rates: uint256[N_COINS] = self._current_rates()
269     # Initial invariant
270     D0: uint256 = 0
271     old_balances: uint256[N_COINS] = self.balances
272     if token_supply > 0:
273         D0 = self.get_D_mem(rates, old_balances)
274     new_balances: uint256[N_COINS] = old_balances
275 
276     for i in range(N_COINS):
277         if token_supply == 0:
278             assert amounts[i] > 0
279         # balances store amounts of c-tokens
280         new_balances[i] = old_balances[i] + amounts[i]
281 
282     # Invariant after change
283     D1: uint256 = self.get_D_mem(rates, new_balances)
284     assert D1 > D0
285 
286     # We need to recalculate the invariant accounting for fees
287     # to calculate fair user's share
288     D2: uint256 = D1
289     if token_supply > 0:
290         # Only account for fees if we are not the first to deposit
291         for i in range(N_COINS):
292             ideal_balance: uint256 = D1 * old_balances[i] / D0
293             difference: uint256 = 0
294             if ideal_balance > new_balances[i]:
295                 difference = ideal_balance - new_balances[i]
296             else:
297                 difference = new_balances[i] - ideal_balance
298             fees[i] = _fee * difference / FEE_DENOMINATOR
299             self.balances[i] = new_balances[i] - fees[i] * _admin_fee / FEE_DENOMINATOR
300             new_balances[i] -= fees[i]
301         D2 = self.get_D_mem(rates, new_balances)
302     else:
303         self.balances = new_balances
304 
305     # Calculate, how much pool tokens to mint
306     mint_amount: uint256 = 0
307     if token_supply == 0:
308         mint_amount = D1  # Take the dust if there was any
309     else:
310         mint_amount = token_supply * (D2 - D0) / D0
311 
312     assert mint_amount >= min_mint_amount, "Slippage screwed you"
313 
314     # Take coins from the sender
315     for i in range(N_COINS):
316         if tethered[i] and not use_lending[i]:
317             USDT(self.coins[i]).transferFrom(msg.sender, self, amounts[i])
318         else:
319             assert_modifiable(
320                 cERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i]))
321 
322     # Mint pool tokens
323     self.token.mint(msg.sender, mint_amount)
324 
325     log.AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
326 
327 
328 @private
329 @constant
330 def get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
331     # x in the input is converted to the same price/precision
332 
333     assert (i != j) and (i >= 0) and (j >= 0) and (i < N_COINS) and (j < N_COINS)
334 
335     D: uint256 = self.get_D(_xp)
336     c: uint256 = D
337     S_: uint256 = 0
338     Ann: uint256 = self.A * N_COINS
339 
340     _x: uint256 = 0
341     for _i in range(N_COINS):
342         if _i == i:
343             _x = x
344         elif _i != j:
345             _x = _xp[_i]
346         else:
347             continue
348         S_ += _x
349         c = c * D / (_x * N_COINS)
350     c = c * D / (Ann * N_COINS)
351     b: uint256 = S_ + D / Ann  # - D
352     y_prev: uint256 = 0
353     y: uint256 = D
354     for _i in range(255):
355         y_prev = y
356         y = (y*y + c) / (2 * y + b - D)
357         # Equality with the precision of 1
358         if y > y_prev:
359             if y - y_prev <= 1:
360                 break
361         else:
362             if y_prev - y <= 1:
363                 break
364     return y
365 
366 
367 @public
368 @constant
369 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
370     # dx and dy in c-units
371     rates: uint256[N_COINS] = self._stored_rates()
372     xp: uint256[N_COINS] = self._xp(rates)
373 
374     x: uint256 = xp[i] + dx * rates[i] / PRECISION
375     y: uint256 = self.get_y(i, j, x, xp)
376     dy: uint256 = (xp[j] - y) * PRECISION / rates[j]
377     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
378     return dy - _fee
379 
380 
381 @public
382 @constant
383 def get_dx(i: int128, j: int128, dy: uint256) -> uint256:
384     # dx and dy in c-units
385     rates: uint256[N_COINS] = self._stored_rates()
386     xp: uint256[N_COINS] = self._xp(rates)
387 
388     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * rates[j] / PRECISION
389     x: uint256 = self.get_y(j, i, y, xp)
390     dx: uint256 = (x - xp[i]) * PRECISION / rates[i]
391     return dx
392 
393 
394 @public
395 @constant
396 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
397     # dx and dy in underlying units
398     rates: uint256[N_COINS] = self._stored_rates()
399     xp: uint256[N_COINS] = self._xp(rates)
400     precisions: uint256[N_COINS] = PRECISION_MUL
401 
402     x: uint256 = xp[i] + dx * precisions[i]
403     y: uint256 = self.get_y(i, j, x, xp)
404     dy: uint256 = (xp[j] - y) / precisions[j]
405     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
406     return dy - _fee
407 
408 
409 @public
410 @constant
411 def get_dx_underlying(i: int128, j: int128, dy: uint256) -> uint256:
412     # dx and dy in underlying units
413     rates: uint256[N_COINS] = self._stored_rates()
414     xp: uint256[N_COINS] = self._xp(rates)
415     precisions: uint256[N_COINS] = PRECISION_MUL
416 
417     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * precisions[j]
418     x: uint256 = self.get_y(j, i, y, xp)
419     dx: uint256 = (x - xp[i]) / precisions[i]
420     return dx
421 
422 
423 @private
424 def _exchange(i: int128, j: int128, dx: uint256, rates: uint256[N_COINS]) -> uint256:
425     assert not self.is_killed
426     # dx and dy are in c-tokens
427 
428     xp: uint256[N_COINS] = self._xp(rates)
429 
430     x: uint256 = xp[i] + dx * rates[i] / PRECISION
431     y: uint256 = self.get_y(i, j, x, xp)
432     dy: uint256 = xp[j] - y
433     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
434     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
435     self.balances[i] = x * PRECISION / rates[i]
436     self.balances[j] = (y + (dy_fee - dy_admin_fee)) * PRECISION / rates[j]
437 
438     _dy: uint256 = (dy - dy_fee) * PRECISION / rates[j]
439 
440     return _dy
441 
442 
443 @public
444 @nonreentrant('lock')
445 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256):
446     rates: uint256[N_COINS] = self._current_rates()
447     dy: uint256 = self._exchange(i, j, dx, rates)
448     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
449     tethered: bool[N_COINS] = TETHERED
450     use_lending: bool[N_COINS] = USE_LENDING
451 
452     if tethered[i] and not use_lending[i]:
453         USDT(self.coins[i]).transferFrom(msg.sender, self, dx)
454     else:
455         assert_modifiable(cERC20(self.coins[i]).transferFrom(msg.sender, self, dx))
456 
457     if tethered[j] and not use_lending[j]:
458         USDT(self.coins[j]).transfer(msg.sender, dy)
459     else:
460         assert_modifiable(cERC20(self.coins[j]).transfer(msg.sender, dy))
461 
462     log.TokenExchange(msg.sender, i, dx, j, dy)
463 
464 
465 @public
466 @nonreentrant('lock')
467 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256):
468     rates: uint256[N_COINS] = self._current_rates()
469     precisions: uint256[N_COINS] = PRECISION_MUL
470     rate_i: uint256 = rates[i] / precisions[i]
471     rate_j: uint256 = rates[j] / precisions[j]
472     dx_: uint256 = dx * PRECISION / rate_i
473 
474     dy_: uint256 = self._exchange(i, j, dx_, rates)
475     dy: uint256 = dy_ * rate_j / PRECISION
476     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
477     use_lending: bool[N_COINS] = USE_LENDING
478     tethered: bool[N_COINS] = TETHERED
479 
480     ok: uint256 = 0
481     if tethered[i]:
482         USDT(self.underlying_coins[i]).transferFrom(msg.sender, self, dx)
483     else:
484         assert_modifiable(ERC20(self.underlying_coins[i])\
485             .transferFrom(msg.sender, self, dx))
486     if use_lending[i]:
487         ERC20(self.underlying_coins[i]).approve(self.coins[i], dx)
488         ok = cERC20(self.coins[i]).mint(dx)
489         if ok > 0:
490             raise "Could not mint coin"
491     if use_lending[j]:
492         ok = cERC20(self.coins[j]).redeem(dy_)
493         if ok > 0:
494             raise "Could not redeem coin"
495     if tethered[j]:
496         USDT(self.underlying_coins[j]).transfer(msg.sender, dy)
497     else:
498         assert_modifiable(ERC20(self.underlying_coins[j])\
499             .transfer(msg.sender, dy))
500 
501     log.TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
502 
503 
504 @public
505 @nonreentrant('lock')
506 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
507     total_supply: uint256 = self.token.totalSupply()
508     amounts: uint256[N_COINS] = ZEROS
509     fees: uint256[N_COINS] = ZEROS
510     tethered: bool[N_COINS] = TETHERED
511     use_lending: bool[N_COINS] = USE_LENDING
512 
513     for i in range(N_COINS):
514         value: uint256 = self.balances[i] * _amount / total_supply
515         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
516         self.balances[i] -= value
517         amounts[i] = value
518         if tethered[i] and not use_lending[i]:
519             USDT(self.coins[i]).transfer(msg.sender, value)
520         else:
521             assert_modifiable(cERC20(self.coins[i]).transfer(
522                 msg.sender, value))
523 
524     self.token.burnFrom(msg.sender, _amount)  # Will raise if not enough
525 
526     log.RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
527 
528 
529 @public
530 @nonreentrant('lock')
531 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256):
532     assert not self.is_killed
533     tethered: bool[N_COINS] = TETHERED
534     use_lending: bool[N_COINS] = USE_LENDING
535 
536     token_supply: uint256 = self.token.totalSupply()
537     assert token_supply > 0
538     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
539     _admin_fee: uint256 = self.admin_fee
540     rates: uint256[N_COINS] = self._current_rates()
541 
542     old_balances: uint256[N_COINS] = self.balances
543     new_balances: uint256[N_COINS] = old_balances
544     D0: uint256 = self.get_D_mem(rates, old_balances)
545     for i in range(N_COINS):
546         new_balances[i] -= amounts[i]
547     D1: uint256 = self.get_D_mem(rates, new_balances)
548     fees: uint256[N_COINS] = ZEROS
549     for i in range(N_COINS):
550         ideal_balance: uint256 = D1 * old_balances[i] / D0
551         difference: uint256 = 0
552         if ideal_balance > new_balances[i]:
553             difference = ideal_balance - new_balances[i]
554         else:
555             difference = new_balances[i] - ideal_balance
556         fees[i] = _fee * difference / FEE_DENOMINATOR
557         self.balances[i] = new_balances[i] - fees[i] * _admin_fee / FEE_DENOMINATOR
558         new_balances[i] -= fees[i]
559     D2: uint256 = self.get_D_mem(rates, new_balances)
560 
561     token_amount: uint256 = (D0 - D2) * token_supply / D0
562     assert token_amount > 0
563     assert token_amount <= max_burn_amount, "Slippage screwed you"
564 
565     for i in range(N_COINS):
566         if tethered[i] and not use_lending[i]:
567             USDT(self.coins[i]).transfer(msg.sender, amounts[i])
568         else:
569             assert_modifiable(cERC20(self.coins[i]).transfer(msg.sender, amounts[i]))
570     self.token.burnFrom(msg.sender, token_amount)  # Will raise if not enough
571 
572     log.RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
573 
574 
575 ### Admin functions ###
576 @public
577 def commit_new_parameters(amplification: uint256,
578                           new_fee: uint256,
579                           new_admin_fee: uint256):
580     assert msg.sender == self.owner
581     assert self.admin_actions_deadline == 0
582     assert new_admin_fee <= max_admin_fee
583 
584     _deadline: timestamp = block.timestamp + admin_actions_delay
585     self.admin_actions_deadline = _deadline
586     self.future_A = amplification
587     self.future_fee = new_fee
588     self.future_admin_fee = new_admin_fee
589 
590     log.CommitNewParameters(_deadline, amplification, new_fee, new_admin_fee)
591 
592 
593 @public
594 def apply_new_parameters():
595     assert msg.sender == self.owner
596     assert self.admin_actions_deadline <= block.timestamp\
597         and self.admin_actions_deadline > 0
598 
599     self.admin_actions_deadline = 0
600     _A: uint256 = self.future_A
601     _fee: uint256 = self.future_fee
602     _admin_fee: uint256 = self.future_admin_fee
603     self.A = _A
604     self.fee = _fee
605     self.admin_fee = _admin_fee
606 
607     log.NewParameters(_A, _fee, _admin_fee)
608 
609 
610 @public
611 def revert_new_parameters():
612     assert msg.sender == self.owner
613 
614     self.admin_actions_deadline = 0
615 
616 
617 @public
618 def commit_transfer_ownership(_owner: address):
619     assert msg.sender == self.owner
620     assert self.transfer_ownership_deadline == 0
621 
622     _deadline: timestamp = block.timestamp + admin_actions_delay
623     self.transfer_ownership_deadline = _deadline
624     self.future_owner = _owner
625 
626     log.CommitNewAdmin(_deadline, _owner)
627 
628 
629 @public
630 def apply_transfer_ownership():
631     assert msg.sender == self.owner
632     assert block.timestamp >= self.transfer_ownership_deadline\
633         and self.transfer_ownership_deadline > 0
634 
635     self.transfer_ownership_deadline = 0
636     _owner: address = self.future_owner
637     self.owner = _owner
638 
639     log.NewAdmin(_owner)
640 
641 
642 @public
643 def revert_transfer_ownership():
644     assert msg.sender == self.owner
645 
646     self.transfer_ownership_deadline = 0
647 
648 
649 @public
650 def withdraw_admin_fees():
651     assert msg.sender == self.owner
652     _precisions: uint256[N_COINS] = PRECISION_MUL
653     tethered: bool[N_COINS] = TETHERED
654     use_lending: bool[N_COINS] = USE_LENDING
655 
656     for i in range(N_COINS):
657         c: address = self.coins[i]
658         value: uint256 = cERC20(c).balanceOf(self) - self.balances[i]
659         if value > 0:
660             if tethered[i] and not use_lending[i]:
661                 USDT(c).transfer(msg.sender, value)
662             else:
663                 assert_modifiable(cERC20(c).transfer(msg.sender, value))
664 
665 
666 @public
667 def kill_me():
668     assert msg.sender == self.owner
669     assert self.kill_deadline > block.timestamp
670     self.is_killed = True
671 
672 
673 @public
674 def unkill_me():
675     assert msg.sender == self.owner
676     self.is_killed = False