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
46 # This can (and needs to) be changed at compile time
47 N_COINS: constant(int128) = 2  # <- change
48 
49 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
50 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256]  # <- change
51 
52 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
53 PRECISION_MUL: constant(uint256[N_COINS]) = [PRECISION / convert(1000000000000000000, uint256), PRECISION / convert(1000000, uint256)]
54 # PRECISION_MUL: constant(uint256[N_COINS]) = [
55 #     PRECISION / convert(10 ** 18, uint256),  # DAI
56 #     PRECISION / convert(10 ** 6, uint256),   # USDC
57 #     PRECISION / convert(10 ** 6, uint256)]   # USDT
58 
59 
60 admin_actions_delay: constant(uint256) = 3 * 86400
61 
62 # Events
63 TokenExchange: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
64 TokenExchangeUnderlying: event({buyer: indexed(address), sold_id: int128, tokens_sold: uint256, bought_id: int128, tokens_bought: uint256})
65 AddLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], invariant: uint256, token_supply: uint256})
66 RemoveLiquidity: event({provider: indexed(address), token_amounts: uint256[N_COINS], fees: uint256[N_COINS], invariant: uint256, token_supply: uint256})
67 CommitNewAdmin: event({deadline: indexed(timestamp), admin: indexed(address)})
68 NewAdmin: event({admin: indexed(address)})
69 CommitNewParameters: event({deadline: indexed(timestamp), A: int128, fee: int128, admin_fee: int128})
70 NewParameters: event({A: int128, fee: int128, admin_fee: int128})
71 
72 coins: public(address[N_COINS])
73 underlying_coins: public(address[N_COINS])
74 balances: public(uint256[N_COINS])
75 A: public(int128)  # 2 x amplification coefficient
76 fee: public(int128)  # fee * 1e10
77 admin_fee: public(int128)  # admin_fee * 1e10
78 max_admin_fee: constant(int128) = 5 * 10 ** 9
79 
80 owner: public(address)
81 token: ERC20m
82 
83 admin_actions_deadline: public(timestamp)
84 transfer_ownership_deadline: public(timestamp)
85 future_A: public(int128)
86 future_fee: public(int128)
87 future_admin_fee: public(int128)
88 future_owner: public(address)
89 
90 kill_deadline: timestamp
91 kill_deadline_dt: constant(uint256) = 2 * 30 * 86400
92 is_killed: bool
93 
94 
95 @public
96 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
97              _pool_token: address,
98              _A: int128, _fee: int128):
99     for i in range(N_COINS):
100         assert _coins[i] != ZERO_ADDRESS
101         assert _underlying_coins[i] != ZERO_ADDRESS
102         self.balances[i] = 0
103     self.coins = _coins
104     self.underlying_coins = _underlying_coins
105     self.A = _A
106     self.fee = _fee
107     self.admin_fee = 0
108     self.owner = msg.sender
109     self.kill_deadline = block.timestamp + kill_deadline_dt
110     self.is_killed = False
111     self.token = ERC20m(_pool_token)
112 
113 
114 @private
115 @constant
116 def _stored_rates() -> uint256[N_COINS]:
117     # exchangeRateStored * (1 + supplyRatePerBlock * (getBlockNumber - accrualBlockNumber) / 1e18)
118     result: uint256[N_COINS] = PRECISION_MUL
119     for i in range(N_COINS):
120         rate: uint256 = cERC20(self.coins[i]).exchangeRateStored()
121         supply_rate: uint256 = cERC20(self.coins[i]).supplyRatePerBlock()
122         old_block: uint256 = cERC20(self.coins[i]).accrualBlockNumber()
123         rate += rate * supply_rate * (block.number - old_block) / 10 ** 18
124         result[i] = rate * result[i]
125     return result
126 
127 
128 @private
129 def _current_rates() -> uint256[N_COINS]:
130     result: uint256[N_COINS] = PRECISION_MUL
131     for i in range(N_COINS):
132         rate: uint256 = cERC20(self.coins[i]).exchangeRateCurrent()
133         result[i] = rate * result[i]
134     return result
135 
136 
137 @private
138 @constant
139 def _xp(rates: uint256[N_COINS]) -> uint256[N_COINS]:
140     result: uint256[N_COINS] = rates
141     for i in range(N_COINS):
142         result[i] = result[i] * self.balances[i] / 10 ** 18
143     return result
144 
145 
146 @private
147 @constant
148 def get_D(xp: uint256[N_COINS]) -> uint256:
149     S: uint256 = 0
150     for _x in xp:
151         S += _x
152     if S == 0:
153         return 0
154 
155     Dprev: uint256 = 0
156     D: uint256 = S
157     Ann: uint256 = convert(self.A, uint256) * N_COINS
158     for _i in range(255):
159         D_P: uint256 = D
160         for _x in xp:
161             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
162         Dprev = D
163         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
164         # Equality with the precision of 1
165         if D > Dprev:
166             if D - Dprev <= 1:
167                 break
168         else:
169             if Dprev - D <= 1:
170                 break
171     return D
172 
173 
174 @public
175 @constant
176 def get_virtual_price() -> uint256:
177     """
178     Returns portfolio virtual price (for calculating profit)
179     scaled up by 1e18
180     """
181     D: uint256 = self.get_D(self._xp(self._stored_rates()))
182     # D is in the units similar to DAI (e.g. converted to precision 1e18)
183     # When balanced, D = n * x_u - total virtual value of the portfolio
184     token_supply: uint256 = self.token.totalSupply()
185     return D * 10 ** 18 / token_supply
186 
187 
188 @public
189 @nonreentrant('lock')
190 def add_liquidity(amounts: uint256[N_COINS], deadline: timestamp):
191     # Amounts is amounts of c-tokens
192     assert block.timestamp <= deadline, "Transaction expired"
193     assert not self.is_killed
194 
195     token_supply: uint256 = self.token.totalSupply()
196     rates: uint256[N_COINS] = self._current_rates()
197     # Initial invariant
198     D0: uint256 = 0
199     if token_supply > 0:
200         D0 = self.get_D(self._xp(rates))
201 
202     for i in range(N_COINS):
203         if token_supply == 0:
204             assert amounts[i] > 0
205         # balances store amounts of c-tokens
206         self.balances[i] += amounts[i]
207 
208     # Invariant after change
209     D1: uint256 = self.get_D(self._xp(rates))
210     assert D1 > D0
211 
212     # Calculate, how much pool tokens to mint
213     mint_amount: uint256 = 0
214     if token_supply == 0:
215         mint_amount = D1  # Take the dust if there was any
216     else:
217         mint_amount = token_supply * (D1 - D0) / D0
218 
219     # Take coins from the sender
220     for i in range(N_COINS):
221         assert_modifiable(
222             cERC20(self.coins[i]).transferFrom(msg.sender, self, amounts[i]))
223 
224     # Mint pool tokens
225     self.token.mint(msg.sender, mint_amount)
226 
227     log.AddLiquidity(msg.sender, amounts, D1, token_supply + mint_amount)
228 
229 
230 @private
231 @constant
232 def get_y(i: int128, j: int128, x: uint256, _xp: uint256[N_COINS]) -> uint256:
233     # x in the input is converted to the same price/precision
234 
235     assert i != j
236 
237     D: uint256 = self.get_D(_xp)
238     c: uint256 = D
239     S_: uint256 = 0
240     Ann: uint256 = convert(self.A, uint256) * N_COINS
241 
242     _x: uint256 = 0
243     for _i in range(N_COINS):
244         if _i == i:
245             _x = x
246         elif _i != j:
247             _x = _xp[_i]
248         else:
249             continue
250         S_ += _x
251         c = c * D / (_x * N_COINS)
252     c = c * D / (Ann * N_COINS)
253     b: uint256 = S_ + D / Ann  # - D
254     y_prev: uint256 = 0
255     y: uint256 = D
256     for _i in range(255):
257         y_prev = y
258         y = (y*y + c) / (2 * y + b - D)
259         # Equality with the precision of 1
260         if y > y_prev:
261             if y - y_prev <= 1:
262                 break
263         else:
264             if y_prev - y <= 1:
265                 break
266     return y
267 
268 
269 @public
270 @constant
271 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
272     # dx and dy in c-units
273     rates: uint256[N_COINS] = self._stored_rates()
274     xp: uint256[N_COINS] = self._xp(rates)
275 
276     x: uint256 = xp[i] + dx * rates[i] / 10 ** 18
277     y: uint256 = self.get_y(i, j, x, xp)
278     dy: uint256 = (xp[j] - y) * 10 ** 18 / rates[j]
279     _fee: uint256 = convert(self.fee, uint256) * dy / 10 ** 10
280     return dy - _fee
281 
282 
283 @public
284 @constant
285 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
286     # dx and dy in underlying units
287     rates: uint256[N_COINS] = self._stored_rates()
288     xp: uint256[N_COINS] = self._xp(rates)
289     precisions: uint256[N_COINS] = PRECISION_MUL
290 
291     x: uint256 = xp[i] + dx * precisions[i]
292     y: uint256 = self.get_y(i, j, x, xp)
293     dy: uint256 = (xp[j] - y) / precisions[j]
294     _fee: uint256 = convert(self.fee, uint256) * dy / 10 ** 10
295     return dy - _fee
296 
297 
298 @private
299 def _exchange(i: int128, j: int128, dx: uint256,
300              min_dy: uint256, deadline: timestamp,
301              rates: uint256[N_COINS]) -> uint256:
302     assert block.timestamp <= deadline, "Transaction expired"
303     assert i < N_COINS and j < N_COINS, "Coin number out of range"
304     assert not self.is_killed
305     # dx and dy are in c-tokens
306 
307     xp: uint256[N_COINS] = self._xp(rates)
308 
309     x: uint256 = xp[i] + dx * rates[i] / 10 ** 18
310     y: uint256 = self.get_y(i, j, x, xp)
311     dy: uint256 = xp[j] - y
312     dy_fee: uint256 = dy * convert(self.fee, uint256) / 10 ** 10
313     dy_admin_fee: uint256 = dy_fee * convert(self.admin_fee, uint256) / 10 ** 10
314     self.balances[i] = x * 10 ** 18 / rates[i]
315     self.balances[j] = (y + (dy_fee - dy_admin_fee)) * 10 ** 18 / rates[j]
316 
317     _dy: uint256 = (dy - dy_fee) * 10 ** 18 / rates[j]
318     assert _dy >= min_dy
319 
320     return _dy
321 
322 
323 @public
324 @nonreentrant('lock')
325 def exchange(i: int128, j: int128, dx: uint256,
326              min_dy: uint256, deadline: timestamp):
327     rates: uint256[N_COINS] = self._current_rates()
328     dy: uint256 = self._exchange(i, j, dx, min_dy, deadline, rates)
329     assert_modifiable(cERC20(self.coins[i]).transferFrom(msg.sender, self, dx))
330     assert_modifiable(cERC20(self.coins[j]).transfer(msg.sender, dy))
331     log.TokenExchange(msg.sender, i, dx, j, dy)
332 
333 
334 @public
335 @nonreentrant('lock')
336 def exchange_underlying(i: int128, j: int128, dx: uint256,
337                         min_dy: uint256, deadline: timestamp):
338     rates: uint256[N_COINS] = self._current_rates()
339     precisions: uint256[N_COINS] = PRECISION_MUL
340     rate_i: uint256 = rates[i] / precisions[i]
341     rate_j: uint256 = rates[j] / precisions[j]
342     dx_: uint256 = dx * 10 ** 18 / rate_i
343     min_dy_: uint256 = min_dy * 10 ** 18 / rate_j
344 
345     dy_: uint256 = self._exchange(i, j, dx_, min_dy_, deadline, rates)
346     dy: uint256 = dy_ * rate_j / 10 ** 18
347 
348     ok: uint256 = 0
349     assert_modifiable(ERC20(self.underlying_coins[i])\
350         .transferFrom(msg.sender, self, dx))
351     ERC20(self.underlying_coins[i]).approve(self.coins[i], dx)
352     ok = cERC20(self.coins[i]).mint(dx)
353     if ok > 0:
354         raise "Could not mint coin"
355     ok = cERC20(self.coins[j]).redeem(dy_)
356     if ok > 0:
357         raise "Could not redeem coin"
358     assert_modifiable(ERC20(self.underlying_coins[j])\
359         .transfer(msg.sender, dy))
360 
361     log.TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
362 
363 
364 @public
365 @nonreentrant('lock')
366 def remove_liquidity(_amount: uint256, deadline: timestamp,
367                      min_amounts: uint256[N_COINS]):
368     assert block.timestamp <= deadline, "Transaction expired"
369     assert self.token.balanceOf(msg.sender) >= _amount
370     total_supply: uint256 = self.token.totalSupply()
371     amounts: uint256[N_COINS] = ZEROS
372     fees: uint256[N_COINS] = ZEROS
373 
374     for i in range(N_COINS):
375         value: uint256 = self.balances[i] * _amount / total_supply
376         assert value >= min_amounts[i]
377         self.balances[i] -= value
378         amounts[i] = value
379         assert_modifiable(cERC20(self.coins[i]).transfer(
380             msg.sender, value))
381 
382     self.token.burnFrom(msg.sender, _amount)
383 
384     D: uint256 = self.get_D(self._xp(self._current_rates()))
385     log.RemoveLiquidity(msg.sender, amounts, fees, D, total_supply - _amount)
386 
387 
388 @public
389 @nonreentrant('lock')
390 def remove_liquidity_imbalance(amounts: uint256[N_COINS], deadline: timestamp):
391     assert block.timestamp <= deadline, "Transaction expired"
392     assert not self.is_killed
393 
394     token_supply: uint256 = self.token.totalSupply()
395     assert token_supply > 0
396     fees: uint256[N_COINS] = ZEROS
397     _fee: uint256 = convert(self.fee, uint256)
398     _admin_fee: uint256 = convert(self.admin_fee, uint256)
399     rates: uint256[N_COINS] = self._current_rates()
400 
401     D0: uint256 = self.get_D(self._xp(rates))
402     for i in range(N_COINS):
403         fees[i] = amounts[i] * _fee / 10 ** 10
404         self.balances[i] -= amounts[i] + fees[i]  # Charge all fees
405     D1: uint256 = self.get_D(self._xp(rates))
406 
407     token_amount: uint256 = (D0 - D1) * token_supply / D0
408     assert self.token.balanceOf(msg.sender) >= token_amount
409     for i in range(N_COINS):
410         assert_modifiable(cERC20(self.coins[i]).transfer(msg.sender, amounts[i]))
411     self.token.burnFrom(msg.sender, token_amount)
412 
413     # Now "charge" fees
414     # In fact, we "refund" fees to the liquidity providers but w/o admin fees
415     # They got paid by burning a higher amount of liquidity token from sender
416     for i in range(N_COINS):
417         self.balances[i] += fees[i] - _admin_fee * fees[i] / 10 ** 10
418 
419     # D1 doesn't include the fee we've charged here, so not super precise
420     log.RemoveLiquidity(msg.sender, amounts, fees, D1, token_supply - token_amount)
421 
422 
423 ### Admin functions ###
424 @public
425 def commit_new_parameters(amplification: int128,
426                           new_fee: int128,
427                           new_admin_fee: int128):
428     assert msg.sender == self.owner
429     assert self.admin_actions_deadline == 0
430     assert new_admin_fee <= max_admin_fee
431 
432     _deadline: timestamp = block.timestamp + admin_actions_delay
433     self.admin_actions_deadline = _deadline
434     self.future_A = amplification
435     self.future_fee = new_fee
436     self.future_admin_fee = new_admin_fee
437 
438     log.CommitNewParameters(_deadline, amplification, new_fee, new_admin_fee)
439 
440 
441 @public
442 def apply_new_parameters():
443     assert msg.sender == self.owner
444     assert self.admin_actions_deadline <= block.timestamp\
445         and self.admin_actions_deadline > 0
446 
447     self.admin_actions_deadline = 0
448     _A: int128 = self.future_A
449     _fee: int128 = self.future_fee
450     _admin_fee: int128 = self.future_admin_fee
451     self.A = _A
452     self.fee = _fee
453     self.admin_fee = _admin_fee
454 
455     log.NewParameters(_A, _fee, _admin_fee)
456 
457 
458 @public
459 def revert_new_parameters():
460     assert msg.sender == self.owner
461 
462     self.admin_actions_deadline = 0
463 
464 
465 @public
466 def commit_transfer_ownership(_owner: address):
467     assert msg.sender == self.owner
468     assert self.transfer_ownership_deadline == 0
469 
470     _deadline: timestamp = block.timestamp + admin_actions_delay
471     self.transfer_ownership_deadline = _deadline
472     self.future_owner = _owner
473 
474     log.CommitNewAdmin(_deadline, _owner)
475 
476 
477 @public
478 def apply_transfer_ownership():
479     assert msg.sender == self.owner
480     assert block.timestamp >= self.transfer_ownership_deadline\
481         and self.transfer_ownership_deadline > 0
482 
483     self.transfer_ownership_deadline = 0
484     _owner: address = self.future_owner
485     self.owner = _owner
486 
487     log.NewAdmin(_owner)
488 
489 
490 @public
491 def revert_transfer_ownership():
492     assert msg.sender == self.owner
493 
494     self.transfer_ownership_deadline = 0
495 
496 
497 @public
498 def withdraw_admin_fees():
499     assert msg.sender == self.owner
500     _precisions: uint256[N_COINS] = PRECISION_MUL
501 
502     for i in range(N_COINS):
503         c: address = self.coins[i]
504         value: uint256 = cERC20(c).balanceOf(self) - self.balances[i]
505         if value > 0:
506             assert_modifiable(cERC20(c).transfer(msg.sender, value))
507 
508 
509 @public
510 def kill_me():
511     assert msg.sender == self.owner
512     assert self.kill_deadline > block.timestamp
513     self.is_killed = True
514 
515 
516 @public
517 def unkill_me():
518     assert msg.sender == self.owner
519     self.is_killed = False