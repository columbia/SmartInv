1 # ███████╗███╗   ██╗ ██████╗ ██╗    ██╗███████╗██╗    ██╗ █████╗ ██████╗ 
2 # ██╔════╝████╗  ██║██╔═══██╗██║    ██║██╔════╝██║    ██║██╔══██╗██╔══██╗
3 # ███████╗██╔██╗ ██║██║   ██║██║ █╗ ██║███████╗██║ █╗ ██║███████║██████╔╝
4 # ╚════██║██║╚██╗██║██║   ██║██║███╗██║╚════██║██║███╗██║██╔══██║██╔═══╝ 
5 # ███████║██║ ╚████║╚██████╔╝╚███╔███╔╝███████║╚███╔███╔╝██║  ██║██║     
6 # ╚══════╝╚═╝  ╚═══╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     
7 # 
8 # SnowSwap yVault DAI, USDC, USDT, TUSD Pool
9 # 
10 # Forked from Curve.fi       
11 # 
12 # WARNING: While Curve contracts are audited, SnowSwap is not. Use at your own risk!
13 # 
14 # Do not deposit funds you cannot afford to lose. 
15 
16 
17 
18 # External Contracts
19 contract ERC20m:
20     def totalSupply() -> uint256: constant
21     def allowance(_owner: address, _spender: address) -> uint256: constant
22     def transfer(_to: address, _value: uint256) -> bool: modifying
23     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
24     def approve(_spender: address, _value: uint256) -> bool: modifying
25     def mint(_to: address, _value: uint256): modifying
26     def burn(_value: uint256): modifying
27     def burnFrom(_to: address, _value: uint256): modifying
28     def name() -> string[64]: constant
29     def symbol() -> string[32]: constant
30     def decimals() -> uint256: constant
31     def balanceOf(arg0: address) -> uint256: constant
32     def set_minter(_minter: address): modifying
33 
34 
35 #
36 # External Contracts
37 contract yvERC20:
38     def totalSupply() -> uint256: constant
39     def allowance(_owner: address, _spender: address) -> uint256: constant
40     def transfer(_to: address, _value: uint256) -> bool: modifying
41     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
42     def approve(_spender: address, _value: uint256) -> bool: modifying
43     def name() -> string[64]: constant
44     def symbol() -> string[32]: constant
45     def decimals() -> uint256: constant
46     def balanceOf(arg0: address) -> uint256: constant
47     def deposit(depositAmount: uint256): modifying
48     def withdraw(withdrawTokens: uint256): modifying
49     def getPricePerFullShare() -> uint256: constant
50 
51 from vyper.interfaces import ERC20
52 
53 # Tether transfer-only ABI
54 contract USDT:
55     def transfer(_to: address, _value: uint256): modifying
56     def transferFrom(_from: address, _to: address, _value: uint256): modifying
57 
58 # This can (and needs to) be changed at compile time
59 N_COINS: constant(int128) = 2  # <- change
60 
61 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
62 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256]  # <- change
63 
64 TETHERED: constant(bool[N_COINS]) = [False, False]
65 
66 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
67 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
68 PRECISION_MUL: constant(uint256[N_COINS]) = [convert(1, uint256), convert(1, uint256)]
69 # PRECISION_MUL: constant(uint256[N_COINS]) = [
70 #     PRECISION / convert(10 ** 18, uint256),  # DAI
71 #     PRECISION / convert(10 ** 6, uint256),   # USDC
72 #     PRECISION / convert(10 ** 6, uint256),   # USDT
73 #     PRECISION / convert(10 ** 18, uint256)]  # TUSD
74 
75 admin_actions_delay: constant(uint256) = 3 * 86400
76 
77 # Events
78 TokenExchange: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
79 TokenExchangeUnderlying: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
80 AddLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
81 RemoveLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], token_supply: uint256})
82 RemoveLiquidityImbalance: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
83 CommitNewAdmin: event({deadline: indexed(timestamp), admin: indexed(address)})
84 NewAdmin: event({admin: indexed(address)})
85 CommitNewParameters: event({deadline: indexed(timestamp), A: uint256, fee: uint256, admin_fee: uint256})
86 NewParameters: event({A: uint256, fee: uint256, admin_fee: uint256})
87 
88 coins: public(address[N_COINS])
89 underlying_coins: public(address[N_COINS])
90 balances: public(uint256[N_COINS])
91 A: public(uint256)  # 2 x amplification coefficient
92 fee: public(uint256)  # fee * 1e10
93 admin_fee: public(uint256)  # admin_fee * 1e10
94 max_admin_fee: constant(uint256) = 5 * 10 ** 9
95 
96 owner: public(address)
97 token: ERC20m
98 
99 admin_actions_deadline: public(timestamp)
100 transfer_ownership_deadline: public(timestamp)
101 future_A: public(uint256)
102 future_fee: public(uint256)
103 future_admin_fee: public(uint256)
104 future_owner: public(address)
105 
106 kill_deadline: timestamp
107 kill_deadline_dt: constant(uint256) = 2 * 30 * 86400
108 is_killed: bool
109 
110 
111 @public
112 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
113              _pool_token: address,
114              _A: uint256, _fee: uint256):
115     """
116     _coins: Addresses of ERC20 contracts of coins (y-tokens) involved
117     _underlying_coins: Addresses of plain coins (ERC20)
118     _pool_token: Address of the token representing LP share
119     _A: Amplification coefficient multiplied by n * (n - 1)
120     _fee: Fee to charge for exchanges
121     """
122     for i in range(N_COINS):
123         assert _coins[i] != ZERO_ADDRESS
124         assert _underlying_coins[i] != ZERO_ADDRESS
125         self.balances[i] = 0
126     self.coins = _coins
127     self.underlying_coins = _underlying_coins
128     self.A = _A
129     self.fee = _fee
130     self.admin_fee = 0
131     self.owner = msg.sender
132     self.kill_deadline = block.timestamp + kill_deadline_dt
133     self.is_killed = False
134     self.token = ERC20m(_pool_token)
135 
136 
137 @private
138 @constant
139 def _stored_rates() -> uint256[N_COINS]:
140     result: uint256[N_COINS] = PRECISION_MUL
141     for i in range(N_COINS):
142         result[i] *= yvERC20(self.coins[i]).getPricePerFullShare()
143     return result
144 
145 
146 @private
147 @constant
148 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
149     result: uint256[N_COINS] = rates
150     for i in range(N_COINS):
151         result[i] = result[i] * self.balances[i] / PRECISION
152     return result
153 
154 
155 @private
156 @constant
157 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
158     result: uint256[N_COINS] = rates
159     for i in range(N_COINS):
160         result[i] = result[i] * _balances[i] / PRECISION
161     return result
162 
163 
164 @private
165 @constant
166 def get_D(xp: uint256[N_COINS]) -> uint256:
167     S: uint256 = 0
168     for _x in xp:
169         S += _x
170     if S == 0:
171         return 0
172 
173     Dprev: uint256 = 0
174     D: uint256 = S
175     Ann: uint256 = self.A * N_COINS
176     for _i in range(255):
177         D_P: uint256 = D
178         for _x in xp:
179             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
180         Dprev = D
181         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
182         # Equality with the precision of 1
183         if D > Dprev:
184             if D - Dprev <= 1:
185                 break
186         else:
187             if Dprev - D <= 1:
188                 break
189     return D
190 
191 
192 @private
193 @constant
194 def get_D_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256:
195     return self.get_D(self._xp_mem(rates, _balances))
196 
197 
198 @public
199 @constant
200 def get_virtual_price() -> uint256:
201     """
202     Returns portfolio virtual price (for calculating profit)
203     scaled up by 1e18
204     """
205     D: uint256 = self.get_D(self._xp(self._stored_rates()))
206     # D is in the units similar to DAI (e.g. converted to precision 1e18)
207     # When balanced, D = n * x_u - total virtual value of the portfolio
208     token_supply: uint256 = self.token.totalSupply()
209     return D * PRECISION / token_supply
210 
211 
212 @public
213 @constant
214 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
215     """
216     Simplified method to calculate addition or reduction in token supply at
217     deposit or withdrawal without taking fees into account (but looking at
218     slippage).
219     Needed to prevent front-running, not for precise calculations!
220     """
221     _balances: uint256[N_COINS] = self.balances
222     rates: uint256[N_COINS] = self._stored_rates()
223     D0: uint256 = self.get_D_mem(rates, _balances)
224     for i in range(N_COINS):
225         if deposit:
226             _balances[i] += amounts[i]
227         else:
228             _balances[i] -= amounts[i]
229     D1: uint256 = self.get_D_mem(rates, _balances)
230     token_amount: uint256 = self.token.totalSupply()
231     diff: uint256 = 0
232     if deposit:
233         diff = D1 - D0
234     else:
235         diff = D0 - D1
236     return diff * token_amount / D0
237 
238 
239 @public
240 @nonreentrant('lock')
241 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
242     # Amounts is amounts of c-tokens
243     assert not self.is_killed
244 
245     fees: uint256[N_COINS] = ZEROS
246     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
247     _admin_fee: uint256 = self.admin_fee
248 
249     token_supply: uint256 = self.token.totalSupply()
250     rates: uint256[N_COINS] = self._stored_rates()
251     # Initial invariant
252     D0: uint256 = 0
253     old_balances: uint256[N_COINS] = self.balances
254     if token_supply > 0:
255         D0 = self.get_D_mem(rates, old_balances)
256     new_balances: uint256[N_COINS] = old_balances
257 
258     for i in range(N_COINS):
259         if token_supply == 0:
260             assert amounts[i] > 0
261         # balances store amounts of c-tokens
262         new_balances[i] = old_balances[i] + amounts[i]
263 
264     # Invariant after change
265     D1: uint256 = self.get_D_mem(rates, new_balances)
266     assert D1 > D0
267 
268     # We need to recalculate the invariant accounting for fees
269     # to calculate fair user's share
270     D2: uint256 = D1
271     if token_supply > 0:
272         # Only account for fees if we are not the first to deposit
273         for i in range(N_COINS):
274             ideal_balance: uint256 = D1 * old_balances[i] / D0
275             difference: uint256 = 0
276             if ideal_balance > new_balances[i]:
277                 difference = ideal_balance - new_balances[i]
278             else:
279                 difference = new_balances[i] - ideal_balance
280             fees[i] = _fee * difference / FEE_DENOMINATOR
281             self.balances[i] = new_balances[i] - fees[i] * _admin_fee / FEE_DENOMINATOR
282             new_balances[i] -= fees[i]
283         D2 = self.get_D_mem(rates, new_balances)
284     else:
285         self.balances = new_balances
286 
287     # Calculate, how much pool tokens to mint
288     mint_amount: uint256 = 0
289     if token_supply == 0:
290         mint_amount = D1  # Take the dust if there was any
291     else:
292         mint_amount = token_supply * (D2 - D0) / D0
293 
294     assert mint_amount >= min_mint_amount, "Slippage screwed you"
295 
296     # Take coins from the sender
297     for i in range(N_COINS):
298         assert_modifiable(
299             yvERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i]))
300 
301 
302     # Mint pool tokens
303     self.token.mint(msg.sender, mint_amount)
304 
305     log.AddLiquidity(msg.sender, amounts, fees, D1, token_supply + mint_amount)
306 
307 
308 @private
309 @constant
310 def get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
311     # x in the input is converted to the same price/precision
312 
313     assert (i != j) and (i >= 0) and (j >= 0) and (i < N_COINS) and (j < N_COINS)
314 
315     D: uint256 = self.get_D(_xp)
316     c: uint256 = D
317     S_: uint256 = 0
318     Ann: uint256 = self.A * N_COINS
319 
320     _x: uint256 = 0
321     for _i in range(N_COINS):
322         if _i == i:
323             _x = x
324         elif _i != j:
325             _x = _xp[_i]
326         else:
327             continue
328         S_ += _x
329         c = c * D / (_x * N_COINS)
330     c = c * D / (Ann * N_COINS)
331     b: uint256 = S_ + D / Ann  # - D
332     y_prev: uint256 = 0
333     y: uint256 = D
334     for _i in range(255):
335         y_prev = y
336         y = (y*y + c) / (2 * y + b - D)
337         # Equality with the precision of 1
338         if y > y_prev:
339             if y - y_prev <= 1:
340                 break
341         else:
342             if y_prev - y <= 1:
343                 break
344     return y
345 
346 
347 @public
348 @constant
349 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
350     # dx and dy in c-units
351     rates: uint256[N_COINS] = self._stored_rates()
352     xp: uint256[N_COINS] = self._xp(rates)
353 
354     x: uint256 = xp[i] + dx * rates[i] / PRECISION
355     y: uint256 = self.get_y(i, j, x, xp)
356     dy: uint256 = (xp[j] - y) * PRECISION / rates[j]
357     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
358     return dy - _fee
359 
360 
361 @public
362 @constant
363 def get_dx(i: int128, j: int128, dy: uint256) -> uint256:
364     # dx and dy in c-units
365     rates: uint256[N_COINS] = self._stored_rates()
366     xp: uint256[N_COINS] = self._xp(rates)
367 
368     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * rates[j] / PRECISION
369     x: uint256 = self.get_y(j, i, y, xp)
370     dx: uint256 = (x - xp[i]) * PRECISION / rates[i]
371     return dx
372 
373 # TODO: update these to take into account withdrawal fees
374 @public
375 @constant
376 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
377     # dx and dy in underlying units
378     rates: uint256[N_COINS] = self._stored_rates()
379     xp: uint256[N_COINS] = self._xp(rates)
380     precisions: uint256[N_COINS] = PRECISION_MUL
381 
382     x: uint256 = xp[i] + dx * precisions[i]
383     y: uint256 = self.get_y(i, j, x, xp)
384     dy: uint256 = (xp[j] - y) / precisions[j]
385     _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
386     vault_fee: uint256 = 0
387 
388     balance_underlying: uint256 = ERC20(self.underlying_coins[j]).balanceOf(self.coins[j])
389     # if withdrawal fee will be incurred, pass fee onto user
390     # improved precision based on yVault contract logic
391     # r: uint256 = (yvERC20(self.coins[j]).balance * dy_) / yvERC20(self.coins[j]).totalSupply()
392     if balance_underlying < dy:
393         # integer maths
394         vault_fee = (5 * dy) / 1000
395 
396     return dy - _fee - vault_fee
397 
398 
399 @public
400 @constant
401 def get_dx_underlying(i: int128, j: int128, dy: uint256) -> uint256:
402     # dx and dy in underlying units
403     rates: uint256[N_COINS] = self._stored_rates()
404     xp: uint256[N_COINS] = self._xp(rates)
405     precisions: uint256[N_COINS] = PRECISION_MUL
406 
407     y: uint256 = xp[j] - (dy * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)) * precisions[j]
408     x: uint256 = self.get_y(j, i, y, xp)
409     dx: uint256 = (x - xp[i]) / precisions[i]
410     return dx
411 
412 
413 @private
414 def _exchange(i: int128, j: int128, dx: uint256, rates: uint256[N_COINS]) -> uint256:
415     assert not self.is_killed
416     # dx and dy are in c-tokens
417 
418     xp: uint256[N_COINS] = self._xp(rates)
419 
420     x: uint256 = xp[i] + dx * rates[i] / PRECISION
421     y: uint256 = self.get_y(i, j, x, xp)
422     dy: uint256 = xp[j] - y
423     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
424     dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
425     self.balances[i] = x * PRECISION / rates[i]
426     self.balances[j] = (y + (dy_fee - dy_admin_fee)) * PRECISION / rates[j]
427 
428     _dy: uint256 = (dy - dy_fee) * PRECISION / rates[j]
429 
430     return _dy
431 
432 
433 @public
434 @nonreentrant('lock')
435 def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256):
436     rates: uint256[N_COINS] = self._stored_rates()
437     dy: uint256 = self._exchange(i, j, dx, rates)
438     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
439 
440     assert_modifiable(yvERC20(self.coins[i]).transferFrom(msg.sender, self, dx))
441 
442     assert_modifiable(yvERC20(self.coins[j]).transfer(msg.sender, dy))
443 
444     log.TokenExchange(msg.sender, i, dx, j, dy)
445 
446 @public
447 @nonreentrant('lock')
448 def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256):
449     rates: uint256[N_COINS] = self._stored_rates()
450     precisions: uint256[N_COINS] = PRECISION_MUL
451     rate_i: uint256 = rates[i] / precisions[i]
452     rate_j: uint256 = rates[j] / precisions[j]
453     dx_: uint256 = dx * PRECISION / rate_i
454 
455     dy_: uint256 = self._exchange(i, j, dx_, rates)
456     dy: uint256 = dy_ * rate_j / PRECISION
457 
458     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
459     tethered: bool[N_COINS] = TETHERED
460 
461     if tethered[i]:
462         USDT(self.underlying_coins[i]).transferFrom(msg.sender, self, dx)
463     else:
464         assert_modifiable(ERC20(self.underlying_coins[i])\
465             .transferFrom(msg.sender, self, dx))
466     ERC20(self.underlying_coins[i]).approve(self.coins[i], dx)
467     yvERC20(self.coins[i]).deposit(dx)
468     yvERC20(self.coins[j]).withdraw(dy_)
469 
470     # y-tokens calculate imprecisely - use all available
471     dy = ERC20(self.underlying_coins[j]).balanceOf(self)
472     assert dy >= min_dy, "Exchange resulted in fewer coins than expected"
473 
474     if tethered[j]:
475         USDT(self.underlying_coins[j]).transfer(msg.sender, dy)
476     else:
477         assert_modifiable(ERC20(self.underlying_coins[j])\
478             .transfer(msg.sender, dy))
479 
480 
481     log.TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
482 
483 
484 @public
485 @nonreentrant('lock')
486 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
487     total_supply: uint256 = self.token.totalSupply()
488     amounts: uint256[N_COINS] = ZEROS
489     fees: uint256[N_COINS] = ZEROS
490 
491     for i in range(N_COINS):
492         value: uint256 = self.balances[i] * _amount / total_supply
493         assert value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected"
494         self.balances[i] -= value
495         amounts[i] = value
496         assert_modifiable(yvERC20(self.coins[i]).transfer(
497             msg.sender, value))
498 
499     self.token.burnFrom(msg.sender, _amount)  # Will raise if not enough
500 
501     log.RemoveLiquidity(msg.sender, amounts, fees, total_supply - _amount)
502 
503 
504 @public
505 @nonreentrant('lock')
506 def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256):
507     assert not self.is_killed
508 
509     token_supply: uint256 = self.token.totalSupply()
510     assert token_supply > 0
511     _fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
512     _admin_fee: uint256 = self.admin_fee
513     rates: uint256[N_COINS] = self._stored_rates()
514 
515     old_balances: uint256[N_COINS] = self.balances
516     new_balances: uint256[N_COINS] = old_balances
517     D0: uint256 = self.get_D_mem(rates, old_balances)
518     for i in range(N_COINS):
519         new_balances[i] -= amounts[i]
520     D1: uint256 = self.get_D_mem(rates, new_balances)
521     fees: uint256[N_COINS] = ZEROS
522     for i in range(N_COINS):
523         ideal_balance: uint256 = D1 * old_balances[i] / D0
524         difference: uint256 = 0
525         if ideal_balance > new_balances[i]:
526             difference = ideal_balance - new_balances[i]
527         else:
528             difference = new_balances[i] - ideal_balance
529         fees[i] = _fee * difference / FEE_DENOMINATOR
530         self.balances[i] = new_balances[i] - fees[i] * _admin_fee / FEE_DENOMINATOR
531         new_balances[i] -= fees[i]
532     D2: uint256 = self.get_D_mem(rates, new_balances)
533 
534     token_amount: uint256 = (D0 - D2) * token_supply / D0
535     assert token_amount > 0
536     assert token_amount <= max_burn_amount, "Slippage screwed you"
537 
538     for i in range(N_COINS):
539         assert_modifiable(yvERC20(self.coins[i]).transfer(msg.sender, amounts[i]))
540     self.token.burnFrom(msg.sender, token_amount)  # Will raise if not enough
541 
542     log.RemoveLiquidityImbalance(msg.sender, amounts, fees, D1, token_supply - token_amount)
543 
544 
545 ### Admin functions ###
546 @public
547 def commit_new_parameters(amplification: uint256,
548                           new_fee: uint256,
549                           new_admin_fee: uint256):
550     assert msg.sender == self.owner
551     assert self.admin_actions_deadline == 0
552     assert new_admin_fee <= max_admin_fee
553 
554     _deadline: timestamp = block.timestamp + admin_actions_delay
555     self.admin_actions_deadline = _deadline
556     self.future_A = amplification
557     self.future_fee = new_fee
558     self.future_admin_fee = new_admin_fee
559 
560     log.CommitNewParameters(_deadline, amplification, new_fee, new_admin_fee)
561 
562 
563 @public
564 def apply_new_parameters():
565     assert msg.sender == self.owner
566     assert self.admin_actions_deadline <= block.timestamp\
567         and self.admin_actions_deadline > 0
568 
569     self.admin_actions_deadline = 0
570     _A: uint256 = self.future_A
571     _fee: uint256 = self.future_fee
572     _admin_fee: uint256 = self.future_admin_fee
573     self.A = _A
574     self.fee = _fee
575     self.admin_fee = _admin_fee
576 
577     log.NewParameters(_A, _fee, _admin_fee)
578 
579 
580 @public
581 def revert_new_parameters():
582     assert msg.sender == self.owner
583 
584     self.admin_actions_deadline = 0
585 
586 
587 @public
588 def commit_transfer_ownership(_owner: address):
589     assert msg.sender == self.owner
590     assert self.transfer_ownership_deadline == 0
591 
592     _deadline: timestamp = block.timestamp + admin_actions_delay
593     self.transfer_ownership_deadline = _deadline
594     self.future_owner = _owner
595 
596     log.CommitNewAdmin(_deadline, _owner)
597 
598 
599 @public
600 def apply_transfer_ownership():
601     assert msg.sender == self.owner
602     assert block.timestamp >= self.transfer_ownership_deadline\
603         and self.transfer_ownership_deadline > 0
604 
605     self.transfer_ownership_deadline = 0
606     _owner: address = self.future_owner
607     self.owner = _owner
608 
609     log.NewAdmin(_owner)
610 
611 
612 @public
613 def revert_transfer_ownership():
614     assert msg.sender == self.owner
615 
616     self.transfer_ownership_deadline = 0
617 
618 
619 @public
620 def withdraw_admin_fees():
621     assert msg.sender == self.owner
622     _precisions: uint256[N_COINS] = PRECISION_MUL
623 
624     for i in range(N_COINS):
625         c: address = self.coins[i]
626         value: uint256 = yvERC20(c).balanceOf(self) - self.balances[i]
627         if value > 0:
628             assert_modifiable(yvERC20(c).transfer(msg.sender, value))
629 
630 
631 @public
632 def kill_me():
633     assert msg.sender == self.owner
634     assert self.kill_deadline > block.timestamp
635     self.is_killed = True
636 
637 
638 @public
639 def unkill_me():
640     assert msg.sender == self.owner
641     self.is_killed = False