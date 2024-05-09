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
40 
41 # Tether transfer-only ABI
42 contract USDT:
43     def transfer(_to: address, _value: uint256): modifying
44     def transferFrom(_from: address, _to: address, _value: uint256): modifying
45 
46 
47 # This can (and needs to) be changed at compile time
48 N_COINS: constant(int128) = 4  # <- change
49 
50 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
51 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256, ZERO256, ZERO256]  # <- change
52 
53 USE_LENDING: constant(bool[N_COINS]) = [True, True, True, False]
54 
55 # Flag "ERC20s" which don't return from transfer() and transferFrom()
56 TETHERED: constant(bool[N_COINS]) = [False, False, True, False]
57 
58 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
59 LENDING_PRECISION: constant(uint256) = 10 ** 18
60 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
61 PRECISION_MUL: constant(uint256[N_COINS]) = [convert(1, uint256), convert(1000000000000, uint256), convert(1000000000000, uint256), convert(1, uint256)]
62 # PRECISION_MUL: constant(uint256[N_COINS]) = [
63 #     PRECISION / convert(PRECISION, uint256),  # DAI
64 #     PRECISION / convert(10 ** 6, uint256),   # USDC
65 #     PRECISION / convert(10 ** 6, uint256)]   # USDT
66 
67 
68 admin_actions_delay: constant(uint256) = 3 * 86400
69 min_ramp_time: constant(uint256) = 86400
70 
71 # Events
72 TokenExchange: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
73 TokenExchangeUnderlying: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
74 AddLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
75 RemoveLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], token_supply: uint256})
76 RemoveLiquidityImbalance: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
77 CommitNewAdmin: event({deadline: indexed(timestamp), admin: indexed(address)})
78 NewAdmin: event({admin: indexed(address)})
79 
80 CommitNewFee: event({deadline: indexed(timestamp), fee: uint256, admin_fee: uint256})
81 NewFee: event({fee: uint256, admin_fee: uint256})
82 RampA: event({old_A: uint256, new_A: uint256, initial_time: timestamp, future_time: timestamp})
83 StopRampA: event({A: uint256, t: timestamp})
84 
85 coins: public(address[N_COINS])
86 underlying_coins: public(address[N_COINS])
87 balances: public(uint256[N_COINS])
88 fee: public(uint256)  # fee * 1e10
89 admin_fee: public(uint256)  # admin_fee * 1e10
90 
91 max_admin_fee: constant(uint256) = 5 * 10 ** 9
92 max_fee: constant(uint256) = 5 * 10 ** 9
93 max_A: constant(uint256) = 10 ** 6
94 max_A_change: constant(uint256) = 10
95 
96 owner: public(address)
97 token: ERC20m
98 
99 initial_A: public(uint256)
100 future_A: public(uint256)
101 initial_A_time: public(timestamp)
102 future_A_time: public(timestamp)
103 
104 admin_actions_deadline: public(timestamp)
105 transfer_ownership_deadline: public(timestamp)
106 future_fee: public(uint256)
107 future_admin_fee: public(uint256)
108 future_owner: public(address)
109 
110 kill_deadline: timestamp
111 kill_deadline_dt: constant(uint256) = 2 * 30 * 86400
112 is_killed: bool
113 
114 
115 @public
116 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
117              _pool_token: address,
118              _A: uint256, _fee: uint256):
119     """
120     _coins: Addresses of ERC20 conracts of coins (y-tokens) involved
121     _underlying_coins: Addresses of plain coins (ERC20)
122     _pool_token: Address of the token representing LP share
123     _A: Amplification coefficient multiplied by n * (n - 1)
124     _fee: Fee to charge for exchanges
125     """
126     for i in range(N_COINS):
127         assert _coins[i] != ZERO_ADDRESS
128         assert _underlying_coins[i] != ZERO_ADDRESS
129         self.balances[i] = 0
130     self.coins = _coins
131     self.underlying_coins = _underlying_coins
132     self.initial_A = _A
133     self.future_A = _A
134     self.initial_A_time = 0
135     self.future_A_time = 0
136     self.fee = _fee
137     self.admin_fee = 0
138     self.owner = msg.sender
139     self.kill_deadline = block.timestamp + kill_deadline_dt
140     self.is_killed = False
141     self.token = ERC20m(_pool_token)
142 
143 
144 @constant
145 @private
146 def _A() -> uint256:
147     """
148     Handle ramping A up or down
149     """
150     t1: timestamp = self.future_A_time
151     A1: uint256 = self.future_A
152 
153     if block.timestamp < t1:
154         A0: uint256 = self.initial_A
155         t0: timestamp = self.initial_A_time
156         # Expressions in uint256 cannot have negative numbers, thus "if"
157         if A1 > A0:
158             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
159         else:
160             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
161 
162     else:  # when t1 == 0 or block.timestamp >= t1
163         return A1
164 
165 
166 @constant
167 @public
168 def A() -> uint256:
169     return self._A()
170 
171 
172 @private
173 @constant
174 def _rates() -> uint256[N_COINS]:
175     # exchangeRateStored * (1 + supplyRatePerBlock * (getBlockNumber - accrualBlockNumber) / 1e18)
176     result: uint256[N_COINS] = PRECISION_MUL
177     use_lending: bool[N_COINS] = USE_LENDING
178     for i in range(N_COINS):
179         rate: uint256 = LENDING_PRECISION  # Used with no lending
180         if use_lending[i]:
181             rate = yERC20(self.coins[i]).getPricePerFullShare()
182         result[i] *= rate
183     return result
184 
185 
186 @private
187 @constant
188 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
189     result: uint256[N_COINS] = rates
190     for i in range(N_COINS):
191         result[i] = result[i] * self.balances[i] / PRECISION
192     return result
193 
194 
195 @private
196 @constant
197 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
198     result: uint256[N_COINS] = rates
199     for i in range(N_COINS):
200         result[i] = result[i] * _balances[i] / PRECISION
201     return result
202 
203 
204 @private
205 @constant
206 def get_D(xp: uint256[N_COINS], amp: uint256) -> uint256:
207     S: uint256 = 0
208     for _x in xp:
209         S += _x
210     if S == 0:
211         return 0
212 
213     Dprev: uint256 = 0
214     D: uint256 = S
215     Ann: uint256 = amp * N_COINS
216     for _i in range(255):
217         D_P: uint256 = D
218         for _x in xp:
219             D_P = D_P * D / (_x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
220         Dprev = D
221         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
222         # Equality with the precision of 1
223         if D > Dprev:
224             if D - Dprev <= 1:
225                 break
226         else:
227             if Dprev - D <= 1:
228                 break
229     return D
230 
231 
232 @private
233 @constant
234 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS], amp: uint256) -> uint256:
235     return self.get_D(self._xp_mem(rates, _balances), amp)
236 
237 
238 @public
239 @constant
240 def get_virtual_price() -> uint256:
241     """
242     Returns portfolio virtual price (for calculating profit)
243     scaled up by 1e18
244     """
245     D: uint256 = self.get_D(self._xp(self._rates()), self._A())
246     # D is in the units similar to DAI (e.g. converted to precision 1e18)
247     # When balanced, D = n * x_u - total virtual value of the portfolio
248     token_supply: uint256 = self.token.totalSupply()
249     return D * PRECISION / token_supply
250 
251 
252 @public
253 @constant
254 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
255     """
256     Simplified method to calculate addition or reduction in token supply at
257     deposit or withdrawal without taking fees into account (but looking at
258     slippage).
259     Needed to prevent front-running, not for precise calculations!
260     """
261     _balances: uint256[N_COINS] = self.balances
262     rates: uint256[N_COINS] = self._rates()
263     amp: uint256 = self._A()
264     D0: uint256 = self.get_D_mem(rates, _balances, amp)
265     for i in range(N_COINS):
266         if deposit:
267             _balances[i] += amounts[i]
268         else:
269             _balances[i] -= amounts[i]
270     D1: uint256 = self.get_D_mem(rates, _balances, amp)
271     token_amount: uint256 = self.token.totalSupply()
272     diff: uint256 = 0
273     if deposit:
274         diff = D1 - D0
275     else:
276         diff = D0 - D1
277     return diff * token_amount / D0
278 
279 
280 @public
281 @nonreentrant('lock')
282 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
283     # Amounts is amounts of c-tokens
284     assert not self.is_killed
285 
286     tethered: bool[N_COINS] = TETHERED
287     use_lending: bool[N_COINS] = USE_LENDING
288     fees: uint256[N_COINS] = ZEROS
289     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
290     _admin_fee: uint256 = self.admin_fee
291     amp: uint256 = self._A()
292 
293     token_supply: uint256 = self.token.totalSupply()
294     rates: uint256[N_COINS] = self._rates()
295     # Initial invariant
296     D0: uint256 = 0
297     old_balances: uint256[N_COINS] = self.balances
298     if token_supply > 0:
299         D0 = self.get_D_mem(rates, old_balances, amp)
300     new_balances: uint256[N_COINS] = old_balances
301 
302     for i in range(N_COINS):
303         if token_supply == 0:
304             assert amounts[i] > 0
305         # balances store amounts of c-tokens
306         new_balances[i] = old_balances[i] + amounts[i]
307 
308     # Invariant after change
309     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
310     assert D1 > D0
311 
312     # We need to recalculate the invariant accounting for fees
313     # to calculate fair user's share
314     D2: uint256 = D1
315     if token_supply > 0:
316         # Only account for fees if we are not the first to deposit
317         for i in range(N_COINS):
318             ideal_balance: uint256 = D1 * old_balances[i] / D0
319             difference: uint256 = 0
320             if ideal_balance > new_balances[i]:
321                 difference = ideal_balance - new_balances[i]
322             else:
323                 difference = new_balances[i] - ideal_balance
324             fees[i] = _fee * difference / FEE_DENOMINATOR
325             self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
326             new_balances[i] -= fees[i]
327         D2 = self.get_D_mem(rates, new_balances, amp)
328     else:
329         self.balances = new_balances
330 
331     # Calculate, how much pool tokens to mint
332     mint_amount: uint256 = 0
333     if token_supply == 0:
334         mint_amount = D1  # Take the dust if there was any
335     else:
336         mint_amount = token_supply * (D2 - D0) / D0
337 
338     assert mint_amount >= min_mint_amount, "Slippage screwed you"
339 
340     # Take coins from the sender
341     for i in range(N_COINS):
342         if amounts[i] > 0:
343             if tethered[i] and not use_lending[i]:
344                 USDT(self.coins[i]).transferFrom(msg.sender, self, amounts[i])
345             else:
346                 assert_modifiable(
347                     yERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i]))
348 
349     # Mint pool tokens
350     self.token.mint(msg.sender, mint_amount)
351 
352     log.AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
353 
354 
355 @private
356 @constant
357 def get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
358     # x in the input is converted to the same price/precision
359 
360     assert (i != j) and (i >= 0) and (j >= 0) and (i < N_COINS) and (j < N_COINS)
361 
362     amp: uint256 = self._A()
363     D: uint256 = self.get_D(_xp, amp)
364     c: uint256 = D
365     S_: uint256 = 0
366     Ann: uint256 = amp * N_COINS
367 
368     _x: uint256 = 0
369     for _i in range(N_COINS):
370         if _i == i:
371             _x = x
372         elif _i != j:
373             _x = _xp[_i]
374         else:
375             continue
376         S_ += _x
377         c = c * D / (_x * N_COINS)
378     c = c * D / (Ann * N_COINS)
379     b: uint256 = S_ + D / Ann  # - D
380     y_prev: uint256 = 0
381     y: uint256 = D
382     for _i in range(255):
383         y_prev = y
384         y = (y*y + c) / (2 * y + b - D)
385         # Equality with the precision of 1
386         if y > y_prev:
387             if y - y_prev <= 1:
388                 break
389         else:
390             if y_prev - y <= 1:
391                 break
392     return y
393 
394 
395 @public
396 @constant
397 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
398     # dx and dy in c-units
399     rates: uint256[N_COINS] = self._rates()
400     xp: uint256[N_COINS] = self._xp(rates)
401 
402     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
403     y: uint256 = self.get_y(i, j, x, xp)
404     dy: uint256 = (xp[j] - y - 1) * PRECISION / rates[j]
405     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
406     return dy - _fee
407 
408 
409 @public
410 @constant
411 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
412     # dx and dy in underlying units
413     rates: uint256[N_COINS] = self._rates()
414     xp: uint256[N_COINS] = self._xp(rates)
415     precisions: uint256[N_COINS] = PRECISION_MUL
416 
417     x: uint256 = xp[i] + dx * precisions[i]
418     y: uint256 = self.get_y(i, j, x, xp)
419     dy: uint256 = (xp[j] - y - 1) / precisions[j]
420     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
421     return dy - _fee
422 
423 
424 @private
425 def _exchange(i: int128, j: int128, dx: uint256, rates: uint256[N_COINS]) -> uint256:
426     assert not self.is_killed
427     # dx and dy are in c-tokens
428 
429     xp: uint256[N_COINS] = self._xp(rates)
430 
431     x: uint256 = xp[i] + dx * rates[i] / PRECISION
432     y: uint256 = self.get_y(i, j, x, xp)
433     dy: uint256 = xp[j] - y
434     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
435     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
436     self.balances[i] = x * PRECISION / rates[i]
437     self.balances[j] = (y + (dy_fee - dy_admin_fee)) * PRECISION / rates[j]
438 
439     _dy: uint256 = (dy - dy_fee) * PRECISION / rates[j]
440 
441     return _dy
442 
443 
444 @public
445 @nonreentrant('lock')
446 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256):
447     rates: uint256[N_COINS] = self._rates()
448     dy: uint256 = self._exchange(i, j, dx, rates)
449     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
450     tethered: bool[N_COINS] = TETHERED
451     use_lending: bool[N_COINS] = USE_LENDING
452 
453     if tethered[i] and not use_lending[i]:
454         USDT(self.coins[i]).transferFrom(msg.sender, self, dx)
455     else:
456         assert_modifiable(yERC20(self.coins[i]).transferFrom(msg.sender, self, dx))
457 
458     if tethered[j] and not use_lending[j]:
459         USDT(self.coins[j]).transfer(msg.sender, dy)
460     else:
461         assert_modifiable(yERC20(self.coins[j]).transfer(msg.sender, dy))
462 
463     log.TokenExchange(msg.sender, i, dx, j, dy)
464 
465 
466 @public
467 @nonreentrant('lock')
468 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256):
469     rates: uint256[N_COINS] = self._rates()
470     precisions: uint256[N_COINS] = PRECISION_MUL
471     rate_i: uint256 = rates[i] / precisions[i]
472     rate_j: uint256 = rates[j] / precisions[j]
473     dx_: uint256 = dx * PRECISION / rate_i
474 
475     dy_: uint256 = self._exchange(i, j, dx_, rates)
476     dy: uint256 = dy_ * rate_j / PRECISION
477     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
478     use_lending: bool[N_COINS] = USE_LENDING
479     tethered: bool[N_COINS] = TETHERED
480 
481     if tethered[i]:
482         USDT(self.underlying_coins[i]).transferFrom(msg.sender, self, dx)
483     else:
484         assert_modifiable(ERC20(self.underlying_coins[i])\
485             .transferFrom(msg.sender, self, dx))
486 
487     if use_lending[i]:
488         ERC20(self.underlying_coins[i]).approve(self.coins[i], dx)
489         yERC20(self.coins[i]).deposit(dx)
490     if use_lending[j]:
491         yERC20(self.coins[j]).withdraw(dy_)
492         # y-tokens calculate imprecisely - use all available
493         dy = ERC20(self.underlying_coins[j]).balanceOf(self)
494         assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
495 
496     if tethered[j]:
497         USDT(self.underlying_coins[j]).transfer(msg.sender, dy)
498     else:
499         assert_modifiable(ERC20(self.underlying_coins[j])\
500             .transfer(msg.sender, dy))
501 
502     log.TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
503 
504 
505 @public
506 @nonreentrant('lock')
507 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
508     total_supply: uint256 = self.token.totalSupply()
509     amounts: uint256[N_COINS] = ZEROS
510     fees: uint256[N_COINS] = ZEROS
511     tethered: bool[N_COINS] = TETHERED
512     use_lending: bool[N_COINS] = USE_LENDING
513 
514     for i in range(N_COINS):
515         value: uint256 = self.balances[i] * _amount / total_supply
516         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
517         self.balances[i] -= value
518         amounts[i] = value
519         if tethered[i] and not use_lending[i]:
520             USDT(self.coins[i]).transfer(msg.sender, value)
521         else:
522             assert_modifiable(yERC20(self.coins[i]).transfer(
523                 msg.sender, value))
524 
525     self.token.burnFrom(msg.sender, _amount)  # Will raise if not enough
526 
527     log.RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
528 
529 
530 @public
531 @nonreentrant('lock')
532 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256):
533     assert not self.is_killed
534     tethered: bool[N_COINS] = TETHERED
535     use_lending: bool[N_COINS] = USE_LENDING
536 
537     token_supply: uint256 = self.token.totalSupply()
538     assert token_supply > 0
539     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
540     _admin_fee: uint256 = self.admin_fee
541     rates: uint256[N_COINS] = self._rates()
542     amp: uint256 = self._A()
543 
544     old_balances: uint256[N_COINS] = self.balances
545     new_balances: uint256[N_COINS] = old_balances
546     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
547     for i in range(N_COINS):
548         new_balances[i] -= amounts[i]
549     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
550     fees: uint256[N_COINS] = ZEROS
551     for i in range(N_COINS):
552         ideal_balance: uint256 = D1 * old_balances[i] / D0
553         difference: uint256 = 0
554         if ideal_balance > new_balances[i]:
555             difference = ideal_balance - new_balances[i]
556         else:
557             difference = new_balances[i] - ideal_balance
558         fees[i] = _fee * difference / FEE_DENOMINATOR
559         self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
560         new_balances[i] -= fees[i]
561     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
562 
563     token_amount: uint256 = (D0 - D2) * token_supply / D0 + 1
564     assert token_amount <= max_burn_amount, "Slippage screwed you"
565 
566     for i in range(N_COINS):
567         if amounts[i] > 0:
568             if tethered[i] and not use_lending[i]:
569                 USDT(self.coins[i]).transfer(msg.sender, amounts[i])
570             else:
571                 assert_modifiable(yERC20(self.coins[i]).transfer(msg.sender, amounts[i]))
572     self.token.burnFrom(msg.sender, token_amount)  # Will raise if not enough
573 
574     log.RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
575 
576 
577 ### Admin functions ###
578 @public
579 def ramp_A(_future_A: uint256, _future_time: timestamp):
580     assert msg.sender == self.owner
581     assert block.timestamp >= self.initial_A_time + min_ramp_time
582     assert _future_time >= block.timestamp + min_ramp_time
583 
584     _initial_A: uint256 = self._A()
585     assert (_future_A > 0) and (_future_A < max_A)
586     assert ((_future_A >= _initial_A) and (_future_A <= _initial_A * max_A_change)) or\
587            ((_future_A < _initial_A) and (_future_A * max_A_change >= _initial_A))
588     self.initial_A = _initial_A
589     self.future_A = _future_A
590     self.initial_A_time = block.timestamp
591     self.future_A_time = _future_time
592 
593     log.RampA(_initial_A, _future_A, block.timestamp, _future_time)
594 
595 
596 @public
597 def stop_ramp_A():
598     assert msg.sender == self.owner
599 
600     current_A: uint256 = self._A()
601     self.initial_A = current_A
602     self.future_A = current_A
603     self.initial_A_time = block.timestamp
604     self.future_A_time = block.timestamp
605     # now (block.timestamp < t1) is always False, so we return saved A
606 
607     log.StopRampA(current_A, block.timestamp)
608 
609 
610 @public
611 def commit_new_fee(new_fee: uint256, new_admin_fee: uint256):
612     assert msg.sender == self.owner
613     assert self.admin_actions_deadline == 0
614     assert new_admin_fee <= max_admin_fee
615     assert new_fee <= max_fee
616 
617     _deadline: timestamp = block.timestamp + admin_actions_delay
618     self.admin_actions_deadline = _deadline
619     self.future_fee = new_fee
620     self.future_admin_fee = new_admin_fee
621 
622     log.CommitNewFee(_deadline, new_fee, new_admin_fee)
623 
624 
625 @public
626 def apply_new_fee():
627     assert msg.sender == self.owner
628     assert self.admin_actions_deadline <= block.timestamp\
629         and self.admin_actions_deadline > 0
630 
631     self.admin_actions_deadline = 0
632     _fee: uint256 = self.future_fee
633     _admin_fee: uint256 = self.future_admin_fee
634     self.fee = _fee
635     self.admin_fee = _admin_fee
636 
637     log.NewFee(_fee, _admin_fee)
638 
639 
640 @public
641 def revert_new_parameters():
642     assert msg.sender == self.owner
643 
644     self.admin_actions_deadline = 0
645 
646 
647 @public
648 def commit_transfer_ownership(_owner: address):
649     assert msg.sender == self.owner
650     assert self.transfer_ownership_deadline == 0
651 
652     _deadline: timestamp = block.timestamp + admin_actions_delay
653     self.transfer_ownership_deadline = _deadline
654     self.future_owner = _owner
655 
656     log.CommitNewAdmin(_deadline, _owner)
657 
658 
659 @public
660 def apply_transfer_ownership():
661     assert msg.sender == self.owner
662     assert block.timestamp >= self.transfer_ownership_deadline\
663         and self.transfer_ownership_deadline > 0
664 
665     self.transfer_ownership_deadline = 0
666     _owner: address = self.future_owner
667     self.owner = _owner
668 
669     log.NewAdmin(_owner)
670 
671 
672 @public
673 def revert_transfer_ownership():
674     assert msg.sender == self.owner
675 
676     self.transfer_ownership_deadline = 0
677 
678 
679 @public
680 def withdraw_admin_fees():
681     assert msg.sender == self.owner
682     _precisions: uint256[N_COINS] = PRECISION_MUL
683     tethered: bool[N_COINS] = TETHERED
684     use_lending: bool[N_COINS] = USE_LENDING
685 
686     for i in range(N_COINS):
687         c: address = self.coins[i]
688         value: uint256 = yERC20(c).balanceOf(self) - self.balances[i]
689         if value > 0:
690             if tethered[i] and not use_lending[i]:
691                 USDT(c).transfer(msg.sender, value)
692             else:
693                 assert_modifiable(yERC20(c).transfer(msg.sender, value))
694 
695 
696 @public
697 def kill_me():
698     assert msg.sender == self.owner
699     assert self.kill_deadline > block.timestamp
700     self.is_killed = True
701 
702 
703 @public
704 def unkill_me():
705     assert msg.sender == self.owner
706     self.is_killed = False