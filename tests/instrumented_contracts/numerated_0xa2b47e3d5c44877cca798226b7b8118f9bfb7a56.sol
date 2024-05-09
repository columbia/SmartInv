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
54 N_COINS: constant(int128) = 2  # <- change
55 
56 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
57 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256]  # <- change
58 
59 USE_LENDING: constant(bool[N_COINS]) = [True, True]
60 
61 # Flag "ERC20s" which don't return from transfer() and transferFrom()
62 TETHERED: constant(bool[N_COINS]) = [False, False]
63 
64 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
65 LENDING_PRECISION: constant(uint256) = 10 ** 18
66 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
67 PRECISION_MUL: constant(uint256[N_COINS]) = [convert(1, uint256), convert(1000000000000, uint256)]
68 # PRECISION_MUL: constant(uint256[N_COINS]) = [
69 #     PRECISION / convert(PRECISION, uint256),  # DAI
70 #     PRECISION / convert(10 ** 6, uint256),   # USDC
71 #     PRECISION / convert(10 ** 6, uint256)]   # USDT
72 
73 
74 admin_actions_delay: constant(uint256) = 3 * 86400
75 
76 # Events
77 TokenExchange: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
78 TokenExchangeUnderlying: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
79 AddLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
80 RemoveLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], token_supply: uint256})
81 RemoveLiquidityImbalance: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
82 CommitNewAdmin: event({deadline: indexed(timestamp), admin: indexed(address)})
83 NewAdmin: event({admin: indexed(address)})
84 CommitNewParameters: event({deadline: indexed(timestamp), A: uint256, fee: uint256, admin_fee: uint256})
85 NewParameters: event({A: uint256, fee: uint256, admin_fee: uint256})
86 
87 coins: public(address[N_COINS])
88 underlying_coins: public(address[N_COINS])
89 balances: public(uint256[N_COINS])
90 A: public(uint256)  # 2 x amplification coefficient
91 fee: public(uint256)  # fee * 1e10
92 admin_fee: public(uint256)  # admin_fee * 1e10
93 
94 max_admin_fee: constant(uint256) = 5 * 10 ** 9
95 max_fee: constant(uint256) = 5 * 10 ** 9
96 max_A: constant(uint256) = 10 ** 6
97 
98 owner: public(address)
99 token: ERC20m
100 
101 admin_actions_deadline: public(timestamp)
102 transfer_ownership_deadline: public(timestamp)
103 future_A: public(uint256)
104 future_fee: public(uint256)
105 future_admin_fee: public(uint256)
106 future_owner: public(address)
107 
108 kill_deadline: timestamp
109 kill_deadline_dt: constant(uint256) = 2 * 30 * 86400
110 is_killed: bool
111 
112 
113 @public
114 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
115              _pool_token: address,
116              _A: uint256, _fee: uint256):
117     """
118     _coins: Addresses of ERC20 conracts of coins (c-tokens) involved
119     _underlying_coins: Addresses of plain coins (ERC20)
120     _pool_token: Address of the token representing LP share
121     _A: Amplification coefficient multiplied by n * (n - 1)
122     _fee: Fee to charge for exchanges
123     """
124     for i in range(N_COINS):
125         assert _coins[i] != ZERO_ADDRESS
126         assert _underlying_coins[i] != ZERO_ADDRESS
127         self.balances[i] = 0
128     self.coins = _coins
129     self.underlying_coins = _underlying_coins
130     self.A = _A
131     self.fee = _fee
132     self.admin_fee = 0
133     self.owner = msg.sender
134     self.kill_deadline = block.timestamp + kill_deadline_dt
135     self.is_killed = False
136     self.token = ERC20m(_pool_token)
137 
138 
139 @private
140 @constant
141 def _stored_rates() -> uint256[N_COINS]:
142     # exchangeRateStored * (1 + supplyRatePerBlock * (getBlockNumber - accrualBlockNumber) / 1e18)
143     result: uint256[N_COINS] = PRECISION_MUL
144     use_lending: bool[N_COINS] = USE_LENDING
145     for i in range(N_COINS):
146         rate: uint256 = LENDING_PRECISION  # Used with no lending
147         if use_lending[i]:
148             rate = cERC20(self.coins[i]).exchangeRateStored()
149             supply_rate: uint256 = cERC20(self.coins[i]).supplyRatePerBlock()
150             old_block: uint256 = cERC20(self.coins[i]).accrualBlockNumber()
151             rate += rate * supply_rate * (block.number - old_block) / LENDING_PRECISION
152         result[i] *= rate
153     return result
154 
155 
156 @private
157 def _current_rates() -> uint256[N_COINS]:
158     result: uint256[N_COINS] = PRECISION_MUL
159     use_lending: bool[N_COINS] = USE_LENDING
160     for i in range(N_COINS):
161         rate: uint256 = LENDING_PRECISION  # Used with no lending
162         if use_lending[i]:
163             rate = cERC20(self.coins[i]).exchangeRateCurrent()
164         result[i] *= rate
165     return result
166 
167 
168 @private
169 @constant
170 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
171     result: uint256[N_COINS] = rates
172     for i in range(N_COINS):
173         result[i] = result[i] * self.balances[i] / PRECISION
174     return result
175 
176 
177 @private
178 @constant
179 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
180     result: uint256[N_COINS] = rates
181     for i in range(N_COINS):
182         result[i] = result[i] * _balances[i] / PRECISION
183     return result
184 
185 
186 @private
187 @constant
188 def get_D(xp: uint256[N_COINS]) -> uint256:
189     S: uint256 = 0
190     for _x in xp:
191         S += _x
192     if S == 0:
193         return 0
194 
195     Dprev: uint256 = 0
196     D: uint256 = S
197     Ann: uint256 = self.A * N_COINS
198     for _i in range(255):
199         D_P: uint256 = D
200         for _x in xp:
201             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
202         Dprev = D
203         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
204         # Equality with the precision of 1
205         if D > Dprev:
206             if D - Dprev <= 1:
207                 break
208         else:
209             if Dprev - D <= 1:
210                 break
211     return D
212 
213 
214 @private
215 @constant
216 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256:
217     return self.get_D(self._xp_mem(rates, _balances))
218 
219 
220 @public
221 @constant
222 def get_virtual_price() -> uint256:
223     """
224     Returns portfolio virtual price (for calculating profit)
225     scaled up by 1e18
226     """
227     D: uint256 = self.get_D(self._xp(self._stored_rates()))
228     # D is in the units similar to DAI (e.g. converted to precision 1e18)
229     # When balanced, D = n * x_u - total virtual value of the portfolio
230     token_supply: uint256 = self.token.totalSupply()
231     return D * PRECISION / token_supply
232 
233 
234 @public
235 @constant
236 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
237     """
238     Simplified method to calculate addition or reduction in token supply at
239     deposit or withdrawal without taking fees into account (but looking at
240     slippage).
241     Needed to prevent front-running, not for precise calculations!
242     """
243     _balances: uint256[N_COINS] = self.balances
244     rates: uint256[N_COINS] = self._stored_rates()
245     D0: uint256 = self.get_D_mem(rates, _balances)
246     for i in range(N_COINS):
247         if deposit:
248             _balances[i] += amounts[i]
249         else:
250             _balances[i] -= amounts[i]
251     D1: uint256 = self.get_D_mem(rates, _balances)
252     token_amount: uint256 = self.token.totalSupply()
253     diff: uint256 = 0
254     if deposit:
255         diff = D1 - D0
256     else:
257         diff = D0 - D1
258     return diff * token_amount / D0
259 
260 
261 @public
262 @nonreentrant('lock')
263 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
264     # Amounts is amounts of c-tokens
265     assert not self.is_killed
266 
267     tethered: bool[N_COINS] = TETHERED
268     use_lending: bool[N_COINS] = USE_LENDING
269     fees: uint256[N_COINS] = ZEROS
270     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
271     _admin_fee: uint256 = self.admin_fee
272 
273     token_supply: uint256 = self.token.totalSupply()
274     rates: uint256[N_COINS] = self._current_rates()
275     # Initial invariant
276     D0: uint256 = 0
277     old_balances: uint256[N_COINS] = self.balances
278     if token_supply > 0:
279         D0 = self.get_D_mem(rates, old_balances)
280     new_balances: uint256[N_COINS] = old_balances
281 
282     for i in range(N_COINS):
283         if token_supply == 0:
284             assert amounts[i] > 0
285         # balances store amounts of c-tokens
286         new_balances[i] = old_balances[i] + amounts[i]
287 
288     # Invariant after change
289     D1: uint256 = self.get_D_mem(rates, new_balances)
290     assert D1 > D0
291 
292     # We need to recalculate the invariant accounting for fees
293     # to calculate fair user's share
294     D2: uint256 = D1
295     if token_supply > 0:
296         # Only account for fees if we are not the first to deposit
297         for i in range(N_COINS):
298             ideal_balance: uint256 = D1 * old_balances[i] / D0
299             difference: uint256 = 0
300             if ideal_balance > new_balances[i]:
301                 difference = ideal_balance - new_balances[i]
302             else:
303                 difference = new_balances[i] - ideal_balance
304             fees[i] = _fee * difference / FEE_DENOMINATOR
305             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
306             new_balances[i] -= fees[i]
307         D2 = self.get_D_mem(rates, new_balances)
308     else:
309         self.balances = new_balances
310 
311     # Calculate, how much pool tokens to mint
312     mint_amount: uint256 = 0
313     if token_supply == 0:
314         mint_amount = D1  # Take the dust if there was any
315     else:
316         mint_amount = token_supply * (D2 - D0) / D0
317 
318     assert mint_amount >= min_mint_amount, "Slippage screwed you"
319 
320     # Take coins from the sender
321     for i in range(N_COINS):
322         if tethered[i] and not use_lending[i]:
323             USDT(self.coins[i]).transferFrom(msg.sender, self, amounts[i])
324         else:
325             assert_modifiable(
326                 cERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i]))
327 
328     # Mint pool tokens
329     self.token.mint(msg.sender, mint_amount)
330 
331     log.AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
332 
333 
334 @private
335 @constant
336 def get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
337     # x in the input is converted to the same price/precision
338 
339     assert (i != j) and (i >= 0) and (j >= 0) and (i < N_COINS) and (j < N_COINS)
340 
341     D: uint256 = self.get_D(_xp)
342     c: uint256 = D
343     S_: uint256 = 0
344     Ann: uint256 = self.A * N_COINS
345 
346     _x: uint256 = 0
347     for _i in range(N_COINS):
348         if _i == i:
349             _x = x
350         elif _i != j:
351             _x = _xp[_i]
352         else:
353             continue
354         S_ += _x
355         c = c * D / (_x * N_COINS)
356     c = c * D / (Ann * N_COINS)
357     b: uint256 = S_ + D / Ann  # - D
358     y_prev: uint256 = 0
359     y: uint256 = D
360     for _i in range(255):
361         y_prev = y
362         y = (y*y + c) / (2 * y + b - D)
363         # Equality with the precision of 1
364         if y > y_prev:
365             if y - y_prev <= 1:
366                 break
367         else:
368             if y_prev - y <= 1:
369                 break
370     return y
371 
372 
373 @public
374 @constant
375 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
376     # dx and dy in c-units
377     rates: uint256[N_COINS] = self._stored_rates()
378     xp: uint256[N_COINS] = self._xp(rates)
379 
380     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
381     y: uint256 = self.get_y(i, j, x, xp)
382     dy: uint256 = (xp[j] - y) * PRECISION / rates[j]
383     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
384     return dy - _fee
385 
386 
387 @public
388 @constant
389 def get_dx(i: int128, j: int128, dy: uint256) -> uint256:
390     # dx and dy in c-units
391     rates: uint256[N_COINS] = self._stored_rates()
392     xp: uint256[N_COINS] = self._xp(rates)
393 
394     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * rates[j] / PRECISION
395     x: uint256 = self.get_y(j, i, y, xp)
396     dx: uint256 = (x - xp[i]) * PRECISION / rates[i]
397     return dx
398 
399 
400 @public
401 @constant
402 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
403     # dx and dy in underlying units
404     rates: uint256[N_COINS] = self._stored_rates()
405     xp: uint256[N_COINS] = self._xp(rates)
406     precisions: uint256[N_COINS] = PRECISION_MUL
407 
408     x: uint256 = xp[i] + dx * precisions[i]
409     y: uint256 = self.get_y(i, j, x, xp)
410     dy: uint256 = (xp[j] - y) / precisions[j]
411     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
412     return dy - _fee
413 
414 
415 @public
416 @constant
417 def get_dx_underlying(i: int128, j: int128, dy: uint256) -> uint256:
418     # dx and dy in underlying units
419     rates: uint256[N_COINS] = self._stored_rates()
420     xp: uint256[N_COINS] = self._xp(rates)
421     precisions: uint256[N_COINS] = PRECISION_MUL
422 
423     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * precisions[j]
424     x: uint256 = self.get_y(j, i, y, xp)
425     dx: uint256 = (x - xp[i]) / precisions[i]
426     return dx
427 
428 
429 @private
430 def _exchange(i: int128, j: int128, dx: uint256, rates: uint256[N_COINS]) -> uint256:
431     assert not self.is_killed
432     # dx and dy are in c-tokens
433 
434     xp: uint256[N_COINS] = self._xp(rates)
435 
436     x: uint256 = xp[i] + dx * rates[i] / PRECISION
437     y: uint256 = self.get_y(i, j, x, xp)
438     dy: uint256 = xp[j] - y
439     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
440     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
441     self.balances[i] = x * PRECISION / rates[i]
442     self.balances[j] = (y + (dy_fee - dy_admin_fee)) * PRECISION / rates[j]
443 
444     _dy: uint256 = (dy - dy_fee) * PRECISION / rates[j]
445 
446     return _dy
447 
448 
449 @public
450 @nonreentrant('lock')
451 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256):
452     rates: uint256[N_COINS] = self._current_rates()
453     dy: uint256 = self._exchange(i, j, dx, rates)
454     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
455     tethered: bool[N_COINS] = TETHERED
456     use_lending: bool[N_COINS] = USE_LENDING
457 
458     if tethered[i] and not use_lending[i]:
459         USDT(self.coins[i]).transferFrom(msg.sender, self, dx)
460     else:
461         assert_modifiable(cERC20(self.coins[i]).transferFrom(msg.sender, self, dx))
462 
463     if tethered[j] and not use_lending[j]:
464         USDT(self.coins[j]).transfer(msg.sender, dy)
465     else:
466         assert_modifiable(cERC20(self.coins[j]).transfer(msg.sender, dy))
467 
468     log.TokenExchange(msg.sender, i, dx, j, dy)
469 
470 
471 @public
472 @nonreentrant('lock')
473 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256):
474     rates: uint256[N_COINS] = self._current_rates()
475     precisions: uint256[N_COINS] = PRECISION_MUL
476     rate_i: uint256 = rates[i] / precisions[i]
477     rate_j: uint256 = rates[j] / precisions[j]
478     dx_: uint256 = dx * PRECISION / rate_i
479 
480     dy_: uint256 = self._exchange(i, j, dx_, rates)
481     dy: uint256 = dy_ * rate_j / PRECISION
482     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
483     use_lending: bool[N_COINS] = USE_LENDING
484     tethered: bool[N_COINS] = TETHERED
485 
486     ok: uint256 = 0
487     if tethered[i]:
488         USDT(self.underlying_coins[i]).transferFrom(msg.sender, self, dx)
489     else:
490         assert_modifiable(ERC20(self.underlying_coins[i])\
491             .transferFrom(msg.sender, self, dx))
492     if use_lending[i]:
493         ERC20(self.underlying_coins[i]).approve(self.coins[i], dx)
494         ok = cERC20(self.coins[i]).mint(dx)
495         if ok > 0:
496             raise "Could not mint coin"
497     if use_lending[j]:
498         ok = cERC20(self.coins[j]).redeem(dy_)
499         if ok > 0:
500             raise "Could not redeem coin"
501     if tethered[j]:
502         USDT(self.underlying_coins[j]).transfer(msg.sender, dy)
503     else:
504         assert_modifiable(ERC20(self.underlying_coins[j])\
505             .transfer(msg.sender, dy))
506 
507     log.TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
508 
509 
510 @public
511 @nonreentrant('lock')
512 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
513     total_supply: uint256 = self.token.totalSupply()
514     amounts: uint256[N_COINS] = ZEROS
515     fees: uint256[N_COINS] = ZEROS
516     tethered: bool[N_COINS] = TETHERED
517     use_lending: bool[N_COINS] = USE_LENDING
518 
519     for i in range(N_COINS):
520         value: uint256 = self.balances[i] * _amount / total_supply
521         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
522         self.balances[i] -= value
523         amounts[i] = value
524         if tethered[i] and not use_lending[i]:
525             USDT(self.coins[i]).transfer(msg.sender, value)
526         else:
527             assert_modifiable(cERC20(self.coins[i]).transfer(
528                 msg.sender, value))
529 
530     self.token.burnFrom(msg.sender, _amount)  # Will raise if not enough
531 
532     log.RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
533 
534 
535 @public
536 @nonreentrant('lock')
537 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256):
538     assert not self.is_killed
539     tethered: bool[N_COINS] = TETHERED
540     use_lending: bool[N_COINS] = USE_LENDING
541 
542     token_supply: uint256 = self.token.totalSupply()
543     assert token_supply > 0
544     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
545     _admin_fee: uint256 = self.admin_fee
546     rates: uint256[N_COINS] = self._current_rates()
547 
548     old_balances: uint256[N_COINS] = self.balances
549     new_balances: uint256[N_COINS] = old_balances
550     D0: uint256 = self.get_D_mem(rates, old_balances)
551     for i in range(N_COINS):
552         new_balances[i] -= amounts[i]
553     D1: uint256 = self.get_D_mem(rates, new_balances)
554     fees: uint256[N_COINS] = ZEROS
555     for i in range(N_COINS):
556         ideal_balance: uint256 = D1 * old_balances[i] / D0
557         difference: uint256 = 0
558         if ideal_balance > new_balances[i]:
559             difference = ideal_balance - new_balances[i]
560         else:
561             difference = new_balances[i] - ideal_balance
562         fees[i] = _fee * difference / FEE_DENOMINATOR
563         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
564         new_balances[i] -= fees[i]
565     D2: uint256 = self.get_D_mem(rates, new_balances)
566 
567     token_amount: uint256 = (D0 - D2) * token_supply / D0
568     assert token_amount > 0
569     assert token_amount <= max_burn_amount, "Slippage screwed you"
570 
571     for i in range(N_COINS):
572         if tethered[i] and not use_lending[i]:
573             USDT(self.coins[i]).transfer(msg.sender, amounts[i])
574         else:
575             assert_modifiable(cERC20(self.coins[i]).transfer(msg.sender, amounts[i]))
576     self.token.burnFrom(msg.sender, token_amount)  # Will raise if not enough
577 
578     log.RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
579 
580 
581 ### Admin functions ###
582 @public
583 def commit_new_parameters(amplification: uint256,
584                           new_fee: uint256,
585                           new_admin_fee: uint256):
586     assert msg.sender == self.owner
587     assert self.admin_actions_deadline == 0
588     assert new_admin_fee <= max_admin_fee
589     assert new_fee <= max_fee
590     assert amplification <= max_A
591 
592     _deadline: timestamp = block.timestamp + admin_actions_delay
593     self.admin_actions_deadline = _deadline
594     self.future_A = amplification
595     self.future_fee = new_fee
596     self.future_admin_fee = new_admin_fee
597 
598     log.CommitNewParameters(_deadline, amplification, new_fee, new_admin_fee)
599 
600 
601 @public
602 def apply_new_parameters():
603     assert msg.sender == self.owner
604     assert self.admin_actions_deadline <= block.timestamp\
605         and self.admin_actions_deadline > 0
606 
607     self.admin_actions_deadline = 0
608     _A: uint256 = self.future_A
609     _fee: uint256 = self.future_fee
610     _admin_fee: uint256 = self.future_admin_fee
611     self.A = _A
612     self.fee = _fee
613     self.admin_fee = _admin_fee
614 
615     log.NewParameters(_A, _fee, _admin_fee)
616 
617 
618 @public
619 def revert_new_parameters():
620     assert msg.sender == self.owner
621 
622     self.admin_actions_deadline = 0
623 
624 
625 @public
626 def commit_transfer_ownership(_owner: address):
627     assert msg.sender == self.owner
628     assert self.transfer_ownership_deadline == 0
629 
630     _deadline: timestamp = block.timestamp + admin_actions_delay
631     self.transfer_ownership_deadline = _deadline
632     self.future_owner = _owner
633 
634     log.CommitNewAdmin(_deadline, _owner)
635 
636 
637 @public
638 def apply_transfer_ownership():
639     assert msg.sender == self.owner
640     assert block.timestamp >= self.transfer_ownership_deadline\
641         and self.transfer_ownership_deadline > 0
642 
643     self.transfer_ownership_deadline = 0
644     _owner: address = self.future_owner
645     self.owner = _owner
646 
647     log.NewAdmin(_owner)
648 
649 
650 @public
651 def revert_transfer_ownership():
652     assert msg.sender == self.owner
653 
654     self.transfer_ownership_deadline = 0
655 
656 
657 @public
658 def withdraw_admin_fees():
659     assert msg.sender == self.owner
660     _precisions: uint256[N_COINS] = PRECISION_MUL
661     tethered: bool[N_COINS] = TETHERED
662     use_lending: bool[N_COINS] = USE_LENDING
663 
664     for i in range(N_COINS):
665         c: address = self.coins[i]
666         value: uint256 = cERC20(c).balanceOf(self) - self.balances[i]
667         if value > 0:
668             if tethered[i] and not use_lending[i]:
669                 USDT(c).transfer(msg.sender, value)
670             else:
671                 assert_modifiable(cERC20(c).transfer(msg.sender, value))
672 
673 
674 @public
675 def kill_me():
676     assert msg.sender == self.owner
677     assert self.kill_deadline > block.timestamp
678     self.is_killed = True
679 
680 
681 @public
682 def unkill_me():
683     assert msg.sender == self.owner
684     self.is_killed = False