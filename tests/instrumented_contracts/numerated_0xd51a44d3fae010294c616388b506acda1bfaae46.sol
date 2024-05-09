1 # @version 0.2.12
2 # (c) Curve.Fi, 2021
3 # Pool for USDT/BTC/ETH or similar
4 
5 interface ERC20:  # Custom ERC20 which works for USDT, WETH and WBTC
6     def transfer(_to: address, _amount: uint256): nonpayable
7     def transferFrom(_from: address, _to: address, _amount: uint256): nonpayable
8     def balanceOf(_user: address) -> uint256: view
9 
10 interface CurveToken:
11     def totalSupply() -> uint256: view
12     def mint(_to: address, _value: uint256) -> bool: nonpayable
13     def mint_relative(_to: address, frac: uint256) -> uint256: nonpayable
14     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
15 
16 
17 interface Math:
18     def geometric_mean(unsorted_x: uint256[N_COINS]) -> uint256: view
19     def reduction_coefficient(x: uint256[N_COINS], fee_gamma: uint256) -> uint256: view
20     def newton_D(ANN: uint256, gamma: uint256, x_unsorted: uint256[N_COINS]) -> uint256: view
21     def newton_y(ANN: uint256, gamma: uint256, x: uint256[N_COINS], D: uint256, i: uint256) -> uint256: view
22     def halfpow(power: uint256, precision: uint256) -> uint256: view
23     def sqrt_int(x: uint256) -> uint256: view
24 
25 
26 interface Views:
27     def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256: view
28     def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256: view
29 
30 
31 interface WETH:
32     def deposit(): payable
33     def withdraw(_amount: uint256): nonpayable
34 
35 
36 # Events
37 event TokenExchange:
38     buyer: indexed(address)
39     sold_id: uint256
40     tokens_sold: uint256
41     bought_id: uint256
42     tokens_bought: uint256
43 
44 event AddLiquidity:
45     provider: indexed(address)
46     token_amounts: uint256[N_COINS]
47     fee: uint256
48     token_supply: uint256
49 
50 event RemoveLiquidity:
51     provider: indexed(address)
52     token_amounts: uint256[N_COINS]
53     token_supply: uint256
54 
55 event RemoveLiquidityOne:
56     provider: indexed(address)
57     token_amount: uint256
58     coin_index: uint256
59     coin_amount: uint256
60 
61 event CommitNewAdmin:
62     deadline: indexed(uint256)
63     admin: indexed(address)
64 
65 event NewAdmin:
66     admin: indexed(address)
67 
68 event CommitNewParameters:
69     deadline: indexed(uint256)
70     admin_fee: uint256
71     mid_fee: uint256
72     out_fee: uint256
73     fee_gamma: uint256
74     allowed_extra_profit: uint256
75     adjustment_step: uint256
76     ma_half_time: uint256
77 
78 event NewParameters:
79     admin_fee: uint256
80     mid_fee: uint256
81     out_fee: uint256
82     fee_gamma: uint256
83     allowed_extra_profit: uint256
84     adjustment_step: uint256
85     ma_half_time: uint256
86 
87 event RampAgamma:
88     initial_A: uint256
89     future_A: uint256
90     initial_gamma: uint256
91     future_gamma: uint256
92     initial_time: uint256
93     future_time: uint256
94 
95 event StopRampA:
96     current_A: uint256
97     current_gamma: uint256
98     time: uint256
99 
100 event ClaimAdminFee:
101     admin: indexed(address)
102     tokens: uint256
103 
104 
105 N_COINS: constant(int128) = 3  # <- change
106 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
107 A_MULTIPLIER: constant(uint256) = 10000
108 
109 # These addresses are replaced by the deployer
110 math: constant(address) = 0x8F68f4810CcE3194B6cB6F3d50fa58c2c9bDD1d5
111 token: constant(address) = 0xc4AD29ba4B3c580e6D59105FFf484999997675Ff
112 views: constant(address) = 0x40745803C2faA8E8402E2Ae935933D07cA8f355c
113 coins: constant(address[N_COINS]) = [
114     0xdAC17F958D2ee523a2206206994597C13D831ec7,
115     0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,
116     0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
117 ]
118 
119 price_scale_packed: uint256   # Internal price scale
120 price_oracle_packed: uint256  # Price target given by MA
121 
122 last_prices_packed: uint256
123 last_prices_timestamp: public(uint256)
124 
125 initial_A_gamma: public(uint256)
126 future_A_gamma: public(uint256)
127 initial_A_gamma_time: public(uint256)
128 future_A_gamma_time: public(uint256)
129 
130 allowed_extra_profit: public(uint256)  # 2 * 10**12 - recommended value
131 future_allowed_extra_profit: public(uint256)
132 
133 fee_gamma: public(uint256)
134 future_fee_gamma: public(uint256)
135 
136 adjustment_step: public(uint256)
137 future_adjustment_step: public(uint256)
138 
139 ma_half_time: public(uint256)
140 future_ma_half_time: public(uint256)
141 
142 mid_fee: public(uint256)
143 out_fee: public(uint256)
144 admin_fee: public(uint256)
145 future_mid_fee: public(uint256)
146 future_out_fee: public(uint256)
147 future_admin_fee: public(uint256)
148 
149 balances: public(uint256[N_COINS])
150 D: public(uint256)
151 
152 owner: public(address)
153 future_owner: public(address)
154 
155 xcp_profit: public(uint256)
156 xcp_profit_a: public(uint256)  # Full profit at last claim of admin fees
157 virtual_price: public(uint256)  # Cached (fast to read) virtual price also used internally
158 not_adjusted: bool
159 
160 is_killed: public(bool)
161 kill_deadline: public(uint256)
162 transfer_ownership_deadline: public(uint256)
163 admin_actions_deadline: public(uint256)
164 
165 admin_fee_receiver: public(address)
166 
167 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
168 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
169 MIN_RAMP_TIME: constant(uint256) = 86400
170 
171 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
172 MIN_FEE: constant(uint256) = 5 * 10 ** 5  # 0.5 bps
173 MAX_FEE: constant(uint256) = 10 * 10 ** 9
174 MAX_A: constant(uint256) = 10000 * A_MULTIPLIER * N_COINS**N_COINS
175 MAX_A_CHANGE: constant(uint256) = 10
176 MIN_GAMMA: constant(uint256) = 10**10
177 MAX_GAMMA: constant(uint256) = 10**16
178 NOISE_FEE: constant(uint256) = 10**5  # 0.1 bps
179 
180 PRICE_SIZE: constant(int128) = 256 / (N_COINS-1)
181 PRICE_MASK: constant(uint256) = 2**PRICE_SIZE - 1
182 
183 # This must be changed for different N_COINS
184 # For example:
185 # N_COINS = 3 -> 1  (10**18 -> 10**18)
186 # N_COINS = 4 -> 10**8  (10**18 -> 10**10)
187 # PRICE_PRECISION_MUL: constant(uint256) = 1
188 PRECISIONS: constant(uint256[N_COINS]) = [
189     1000000000000,
190     10000000000,
191     1,
192 ]
193 
194 INF_COINS: constant(uint256) = 15
195 
196 
197 @external
198 def __init__(
199     owner: address,
200     admin_fee_receiver: address,
201     A: uint256,
202     gamma: uint256,
203     mid_fee: uint256,
204     out_fee: uint256,
205     allowed_extra_profit: uint256,
206     fee_gamma: uint256,
207     adjustment_step: uint256,
208     admin_fee: uint256,
209     ma_half_time: uint256,
210     initial_prices: uint256[N_COINS-1]
211 ):
212     self.owner = owner
213 
214     # Pack A and gamma:
215     # shifted A + gamma
216     A_gamma: uint256 = shift(A, 128)
217     A_gamma = bitwise_or(A_gamma, gamma)
218     self.initial_A_gamma = A_gamma
219     self.future_A_gamma = A_gamma
220 
221     self.mid_fee = mid_fee
222     self.out_fee = out_fee
223     self.allowed_extra_profit = allowed_extra_profit
224     self.fee_gamma = fee_gamma
225     self.adjustment_step = adjustment_step
226     self.admin_fee = admin_fee
227 
228     # Packing prices
229     packed_prices: uint256 = 0
230     for k in range(N_COINS-1):
231         packed_prices = shift(packed_prices, PRICE_SIZE)
232         p: uint256 = initial_prices[N_COINS-2 - k]  # / PRICE_PRECISION_MUL
233         assert p < PRICE_MASK
234         packed_prices = bitwise_or(p, packed_prices)
235 
236     self.price_scale_packed = packed_prices
237     self.price_oracle_packed = packed_prices
238     self.last_prices_packed = packed_prices
239     self.last_prices_timestamp = block.timestamp
240     self.ma_half_time = ma_half_time
241 
242     self.xcp_profit_a = 10**18
243 
244     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
245 
246     self.admin_fee_receiver = admin_fee_receiver
247 
248 
249 @payable
250 @external
251 def __default__():
252     pass
253 
254 
255 @internal
256 @view
257 def _packed_view(k: uint256, p: uint256) -> uint256:
258     assert k < N_COINS-1
259     return bitwise_and(
260         shift(p, -PRICE_SIZE * convert(k, int256)),
261         PRICE_MASK
262     )  # * PRICE_PRECISION_MUL
263 
264 
265 @external
266 @view
267 def price_oracle(k: uint256) -> uint256:
268     return self._packed_view(k, self.price_oracle_packed)
269 
270 
271 @external
272 @view
273 def price_scale(k: uint256) -> uint256:
274     return self._packed_view(k, self.price_scale_packed)
275 
276 
277 @external
278 @view
279 def last_prices(k: uint256) -> uint256:
280     return self._packed_view(k, self.last_prices_packed)
281 
282 
283 @external
284 @view
285 def token() -> address:
286     return token
287 
288 
289 @external
290 @view
291 def coins(i: uint256) -> address:
292     _coins: address[N_COINS] = coins
293     return _coins[i]
294 
295 
296 @internal
297 @view
298 def xp() -> uint256[N_COINS]:
299     result: uint256[N_COINS] = self.balances
300     packed_prices: uint256 = self.price_scale_packed
301 
302     precisions: uint256[N_COINS] = PRECISIONS
303 
304     result[0] *= PRECISIONS[0]
305     for i in range(1, N_COINS):
306         p: uint256 = bitwise_and(packed_prices, PRICE_MASK) * precisions[i]  # * PRICE_PRECISION_MUL
307         result[i] = result[i] * p / PRECISION
308         packed_prices = shift(packed_prices, -PRICE_SIZE)
309 
310     return result
311 
312 
313 @view
314 @internal
315 def _A_gamma() -> uint256[2]:
316     t1: uint256 = self.future_A_gamma_time
317 
318     A_gamma_1: uint256 = self.future_A_gamma
319     gamma1: uint256 = bitwise_and(A_gamma_1, 2**128-1)
320     A1: uint256 = shift(A_gamma_1, -128)
321 
322     if block.timestamp < t1:
323         # handle ramping up and down of A
324         A_gamma_0: uint256 = self.initial_A_gamma
325         t0: uint256 = self.initial_A_gamma_time
326 
327         # Less readable but more compact way of writing and converting to uint256
328         # gamma0: uint256 = bitwise_and(A_gamma_0, 2**128-1)
329         # A0: uint256 = shift(A_gamma_0, -128)
330         # A1 = A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
331         # gamma1 = gamma0 + (gamma1 - gamma0) * (block.timestamp - t0) / (t1 - t0)
332 
333         t1 -= t0
334         t0 = block.timestamp - t0
335         t2: uint256 = t1 - t0
336 
337         A1 = (shift(A_gamma_0, -128) * t2 + A1 * t0) / t1
338         gamma1 = (bitwise_and(A_gamma_0, 2**128-1) * t2 + gamma1 * t0) / t1
339 
340     return [A1, gamma1]
341 
342 
343 @view
344 @external
345 def A() -> uint256:
346     return self._A_gamma()[0]
347 
348 
349 @view
350 @external
351 def gamma() -> uint256:
352     return self._A_gamma()[1]
353 
354 
355 @internal
356 @view
357 def _fee(xp: uint256[N_COINS]) -> uint256:
358     f: uint256 = Math(math).reduction_coefficient(xp, self.fee_gamma)
359     return (self.mid_fee * f + self.out_fee * (10**18 - f)) / 10**18
360 
361 
362 @external
363 @view
364 def fee() -> uint256:
365     return self._fee(self.xp())
366 
367 
368 @external
369 @view
370 def fee_calc(xp: uint256[N_COINS]) -> uint256:
371     return self._fee(xp)
372 
373 
374 @internal
375 @view
376 def get_xcp(D: uint256) -> uint256:
377     x: uint256[N_COINS] = empty(uint256[N_COINS])
378     x[0] = D / N_COINS
379     packed_prices: uint256 = self.price_scale_packed
380     # No precisions here because we don't switch to "real" units
381 
382     for i in range(1, N_COINS):
383         x[i] = D * 10**18 / (N_COINS * bitwise_and(packed_prices, PRICE_MASK))  # ... * PRICE_PRECISION_MUL)
384         packed_prices = shift(packed_prices, -PRICE_SIZE)
385 
386     return Math(math).geometric_mean(x)
387 
388 
389 @external
390 @view
391 def get_virtual_price() -> uint256:
392     return 10**18 * self.get_xcp(self.D) / CurveToken(token).totalSupply()
393 
394 
395 @internal
396 def _claim_admin_fees():
397     A_gamma: uint256[2] = self._A_gamma()
398 
399     xcp_profit: uint256 = self.xcp_profit
400     xcp_profit_a: uint256 = self.xcp_profit_a
401 
402     # Gulp here
403     _coins: address[N_COINS] = coins
404     for i in range(N_COINS):
405         self.balances[i] = ERC20(_coins[i]).balanceOf(self)
406 
407     vprice: uint256 = self.virtual_price
408 
409     if xcp_profit > xcp_profit_a:
410         fees: uint256 = (xcp_profit - xcp_profit_a) * self.admin_fee / (2 * 10**10)
411         if fees > 0:
412             receiver: address = self.admin_fee_receiver
413             frac: uint256 = vprice * 10**18 / (vprice - fees) - 10**18
414             claimed: uint256 = CurveToken(token).mint_relative(receiver, frac)
415             xcp_profit -= fees*2
416             self.xcp_profit = xcp_profit
417             log ClaimAdminFee(receiver, claimed)
418 
419     total_supply: uint256 = CurveToken(token).totalSupply()
420 
421     # Recalculate D b/c we gulped
422     D: uint256 = Math(math).newton_D(A_gamma[0], A_gamma[1], self.xp())
423     self.D = D
424 
425     self.virtual_price = 10**18 * self.get_xcp(D) / total_supply
426 
427     if xcp_profit > xcp_profit_a:
428         self.xcp_profit_a = xcp_profit
429 
430 
431 @internal
432 def tweak_price(A_gamma: uint256[2],
433                 _xp: uint256[N_COINS], i: uint256, p_i: uint256,
434                 new_D: uint256):
435     price_oracle: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
436     last_prices: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
437     price_scale: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
438     xp: uint256[N_COINS] = empty(uint256[N_COINS])
439     p_new: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
440 
441     # Update MA if needed
442     packed_prices: uint256 = self.price_oracle_packed
443     for k in range(N_COINS-1):
444         price_oracle[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
445         packed_prices = shift(packed_prices, -PRICE_SIZE)
446 
447     last_prices_timestamp: uint256 = self.last_prices_timestamp
448     packed_prices = self.last_prices_packed
449     for k in range(N_COINS-1):
450         last_prices[k] = bitwise_and(packed_prices, PRICE_MASK)   # * PRICE_PRECISION_MUL
451         packed_prices = shift(packed_prices, -PRICE_SIZE)
452 
453     if last_prices_timestamp < block.timestamp:
454         # MA update required
455         ma_half_time: uint256 = self.ma_half_time
456         alpha: uint256 = Math(math).halfpow((block.timestamp - last_prices_timestamp) * 10**18 / ma_half_time, 10**10)
457         packed_prices = 0
458         for k in range(N_COINS-1):
459             price_oracle[k] = (last_prices[k] * (10**18 - alpha) + price_oracle[k] * alpha) / 10**18
460         for k in range(N_COINS-1):
461             packed_prices = shift(packed_prices, PRICE_SIZE)
462             p: uint256 = price_oracle[N_COINS-2 - k]  # / PRICE_PRECISION_MUL
463             assert p < PRICE_MASK
464             packed_prices = bitwise_or(p, packed_prices)
465         self.price_oracle_packed = packed_prices
466         self.last_prices_timestamp = block.timestamp
467 
468     D_unadjusted: uint256 = new_D  # Withdrawal methods know new D already
469     if new_D == 0:
470         # We will need this a few times (35k gas)
471         D_unadjusted = Math(math).newton_D(A_gamma[0], A_gamma[1], _xp)
472     packed_prices = self.price_scale_packed
473     for k in range(N_COINS-1):
474         price_scale[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
475         packed_prices = shift(packed_prices, -PRICE_SIZE)
476 
477     if p_i > 0:
478         # Save the last price
479         if i > 0:
480             last_prices[i-1] = p_i
481         else:
482             # If 0th price changed - change all prices instead
483             for k in range(N_COINS-1):
484                 last_prices[k] = last_prices[k] * 10**18 / p_i
485     else:
486         # calculate real prices
487         # it would cost 70k gas for a 3-token pool. Sad. How do we do better?
488         __xp: uint256[N_COINS] = _xp
489         dx_price: uint256 = __xp[0] / 10**6
490         __xp[0] += dx_price
491         for k in range(N_COINS-1):
492             last_prices[k] = price_scale[k] * dx_price / (_xp[k+1] - Math(math).newton_y(A_gamma[0], A_gamma[1], __xp, D_unadjusted, k+1))
493 
494     packed_prices = 0
495     for k in range(N_COINS-1):
496         packed_prices = shift(packed_prices, PRICE_SIZE)
497         p: uint256 = last_prices[N_COINS-2 - k]  # / PRICE_PRECISION_MUL
498         assert p < PRICE_MASK
499         packed_prices = bitwise_or(p, packed_prices)
500     self.last_prices_packed = packed_prices
501 
502     total_supply: uint256 = CurveToken(token).totalSupply()
503     old_xcp_profit: uint256 = self.xcp_profit
504     old_virtual_price: uint256 = self.virtual_price
505 
506     # Update profit numbers without price adjustment first
507     xp[0] = D_unadjusted / N_COINS
508     for k in range(N_COINS-1):
509         xp[k+1] = D_unadjusted * 10**18 / (N_COINS * price_scale[k])
510     xcp_profit: uint256 = 10**18
511     virtual_price: uint256 = 10**18
512 
513     if old_virtual_price > 0:
514         xcp: uint256 = Math(math).geometric_mean(xp)
515         virtual_price = 10**18 * xcp / total_supply
516         xcp_profit = old_xcp_profit * virtual_price / old_virtual_price
517 
518         t: uint256 = self.future_A_gamma_time
519         if virtual_price < old_virtual_price and t == 0:
520             raise "Loss"
521         if t == 1:
522             self.future_A_gamma_time = 0
523 
524     self.xcp_profit = xcp_profit
525 
526     needs_adjustment: bool = self.not_adjusted
527     # if not needs_adjustment and (virtual_price-10**18 > (xcp_profit-10**18)/2 + self.allowed_extra_profit):
528     # (re-arrange for gas efficiency)
529     if not needs_adjustment and (virtual_price * 2 - 10**18 > xcp_profit + 2*self.allowed_extra_profit):
530         needs_adjustment = True
531         self.not_adjusted = True
532 
533     if needs_adjustment:
534         adjustment_step: uint256 = self.adjustment_step
535         norm: uint256 = 0
536 
537         for k in range(N_COINS-1):
538             ratio: uint256 = price_oracle[k] * 10**18 / price_scale[k]
539             if ratio > 10**18:
540                 ratio -= 10**18
541             else:
542                 ratio = 10**18 - ratio
543             norm += ratio**2
544 
545         if norm > adjustment_step ** 2 and old_virtual_price > 0:
546             norm = Math(math).sqrt_int(norm / 10**18)  # Need to convert to 1e18 units!
547 
548             for k in range(N_COINS-1):
549                 p_new[k] = (price_scale[k] * (norm - adjustment_step) + adjustment_step * price_oracle[k]) / norm
550 
551             # Calculate balances*prices
552             xp = _xp
553             for k in range(N_COINS-1):
554                 xp[k+1] = _xp[k+1] * p_new[k] / price_scale[k]
555 
556             # Calculate "extended constant product" invariant xCP and virtual price
557             D: uint256 = Math(math).newton_D(A_gamma[0], A_gamma[1], xp)
558             xp[0] = D / N_COINS
559             for k in range(N_COINS-1):
560                 xp[k+1] = D * 10**18 / (N_COINS * p_new[k])
561             # We reuse old_virtual_price here but it's not old anymore
562             old_virtual_price = 10**18 * Math(math).geometric_mean(xp) / total_supply
563 
564             # Proceed if we've got enough profit
565             # if (old_virtual_price > 10**18) and (2 * (old_virtual_price - 10**18) > xcp_profit - 10**18):
566             if (old_virtual_price > 10**18) and (2 * old_virtual_price - 10**18 > xcp_profit):
567                 packed_prices = 0
568                 for k in range(N_COINS-1):
569                     packed_prices = shift(packed_prices, PRICE_SIZE)
570                     p: uint256 = p_new[N_COINS-2 - k]  # / PRICE_PRECISION_MUL
571                     assert p < PRICE_MASK
572                     packed_prices = bitwise_or(p, packed_prices)
573                 self.price_scale_packed = packed_prices
574                 self.D = D
575                 self.virtual_price = old_virtual_price
576 
577                 return
578 
579             else:
580                 self.not_adjusted = False
581 
582     # If we are here, the price_scale adjustment did not happen
583     # Still need to update the profit counter and D
584     self.D = D_unadjusted
585     self.virtual_price = virtual_price
586 
587 
588 
589 @payable
590 @external
591 @nonreentrant('lock')
592 def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool = False):
593     assert not self.is_killed  # dev: the pool is killed
594     assert i != j  # dev: coin index out of range
595     assert i < N_COINS  # dev: coin index out of range
596     assert j < N_COINS  # dev: coin index out of range
597     assert dx > 0  # dev: do not exchange 0 coins
598 
599     A_gamma: uint256[2] = self._A_gamma()
600     xp: uint256[N_COINS] = self.balances
601     ix: uint256 = j
602     p: uint256 = 0
603     dy: uint256 = 0
604 
605     if True:  # scope to reduce size of memory when making internal calls later
606         _coins: address[N_COINS] = coins
607         if i == 2 and use_eth:
608             assert msg.value == dx  # dev: incorrect eth amount
609             WETH(coins[2]).deposit(value=msg.value)
610         else:
611             assert msg.value == 0  # dev: nonzero eth amount
612             # assert might be needed for some tokens - removed one to save bytespace
613             ERC20(_coins[i]).transferFrom(msg.sender, self, dx)
614 
615         y: uint256 = xp[j]
616         x0: uint256 = xp[i]
617         xp[i] = x0 + dx
618         self.balances[i] = xp[i]
619 
620         price_scale: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
621         packed_prices: uint256 = self.price_scale_packed
622         for k in range(N_COINS-1):
623             price_scale[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
624             packed_prices = shift(packed_prices, -PRICE_SIZE)
625 
626         precisions: uint256[N_COINS] = PRECISIONS
627         xp[0] *= PRECISIONS[0]
628         for k in range(1, N_COINS):
629             xp[k] = xp[k] * price_scale[k-1] * precisions[k] / PRECISION
630 
631         prec_i: uint256 = precisions[i]
632 
633         # In case ramp is happening
634         if True:
635             t: uint256 = self.future_A_gamma_time
636             if t > 0:
637                 x0 *= prec_i
638                 if i > 0:
639                     x0 = x0 * price_scale[i-1] / PRECISION
640                 x1: uint256 = xp[i]  # Back up old value in xp
641                 xp[i] = x0
642                 self.D = Math(math).newton_D(A_gamma[0], A_gamma[1], xp)
643                 xp[i] = x1  # And restore
644                 if block.timestamp >= t:
645                     self.future_A_gamma_time = 1
646 
647         prec_j: uint256 = precisions[j]
648 
649         dy = xp[j] - Math(math).newton_y(A_gamma[0], A_gamma[1], xp, self.D, j)
650         # Not defining new "y" here to have less variables / make subsequent calls cheaper
651         xp[j] -= dy
652         dy -= 1
653 
654         if j > 0:
655             dy = dy * PRECISION / price_scale[j-1]
656         dy /= prec_j
657 
658         dy -= self._fee(xp) * dy / 10**10
659         assert dy >= min_dy, "Slippage"
660         y -= dy
661 
662         self.balances[j] = y
663         # assert might be needed for some tokens - removed one to save bytespace
664         if j == 2 and use_eth:
665             WETH(coins[2]).withdraw(dy)
666             raw_call(msg.sender, b"", value=dy)
667         else:
668             ERC20(_coins[j]).transfer(msg.sender, dy)
669 
670         y *= prec_j
671         if j > 0:
672             y = y * price_scale[j-1] / PRECISION
673         xp[j] = y
674 
675         # Calculate price
676         if dx > 10**5 and dy > 10**5:
677             _dx: uint256 = dx * prec_i
678             _dy: uint256 = dy * prec_j
679             if i != 0 and j != 0:
680                 p = bitwise_and(
681                     shift(self.last_prices_packed, -PRICE_SIZE * convert(i-1, int256)),
682                     PRICE_MASK
683                 ) * _dx / _dy  # * PRICE_PRECISION_MUL
684             elif i == 0:
685                 p = _dx * 10**18 / _dy
686             else:  # j == 0
687                 p = _dy * 10**18 / _dx
688                 ix = i
689 
690     self.tweak_price(A_gamma, xp, ix, p, 0)
691 
692     log TokenExchange(msg.sender, i, dx, j, dy)
693 
694 
695 @external
696 @view
697 def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256:
698     return Views(views).get_dy(i, j, dx)
699 
700 
701 @view
702 @internal
703 def _calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
704     # fee = sum(amounts_i - avg(amounts)) * fee' / sum(amounts)
705     fee: uint256 = self._fee(xp) * N_COINS / (4 * (N_COINS-1))
706     S: uint256 = 0
707     for _x in amounts:
708         S += _x
709     avg: uint256 = S / N_COINS
710     Sdiff: uint256 = 0
711     for _x in amounts:
712         if _x > avg:
713             Sdiff += _x - avg
714         else:
715             Sdiff += avg - _x
716     return fee * Sdiff / S + NOISE_FEE
717 
718 
719 @external
720 @view
721 def calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
722     return self._calc_token_fee(amounts, xp)
723 
724 
725 @external
726 @nonreentrant('lock')
727 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
728     assert not self.is_killed  # dev: the pool is killed
729 
730     A_gamma: uint256[2] = self._A_gamma()
731 
732     _coins: address[N_COINS] = coins
733 
734     xp: uint256[N_COINS] = self.balances
735     amountsp: uint256[N_COINS] = empty(uint256[N_COINS])
736     xx: uint256[N_COINS] = empty(uint256[N_COINS])
737     d_token: uint256 = 0
738     d_token_fee: uint256 = 0
739     old_D: uint256 = 0
740     ix: uint256 = INF_COINS
741 
742     if True:  # Scope to avoid having extra variables in memory later
743         xp_old: uint256[N_COINS] = xp
744 
745         for i in range(N_COINS):
746             bal: uint256 = xp[i] + amounts[i]
747             xp[i] = bal
748             self.balances[i] = bal
749         xx = xp
750 
751         precisions: uint256[N_COINS] = PRECISIONS
752         packed_prices: uint256 = self.price_scale_packed
753         xp[0] *= PRECISIONS[0]
754         xp_old[0] *= PRECISIONS[0]
755         for i in range(1, N_COINS):
756             price_scale: uint256 = bitwise_and(packed_prices, PRICE_MASK) * precisions[i]  # * PRICE_PRECISION_MUL
757             xp[i] = xp[i] * price_scale / PRECISION
758             xp_old[i] = xp_old[i] * price_scale / PRECISION
759             packed_prices = shift(packed_prices, -PRICE_SIZE)
760 
761         for i in range(N_COINS):
762             if amounts[i] > 0:
763                 # assert might be needed for some tokens - removed one to save bytespace
764                 ERC20(_coins[i]).transferFrom(msg.sender, self, amounts[i])
765                 amountsp[i] = xp[i] - xp_old[i]
766                 if ix == INF_COINS:
767                     ix = i
768                 else:
769                     ix = INF_COINS-1
770         assert ix != INF_COINS  # dev: no coins to add
771 
772         t: uint256 = self.future_A_gamma_time
773         if t > 0:
774             old_D = Math(math).newton_D(A_gamma[0], A_gamma[1], xp_old)
775             if block.timestamp >= t:
776                 self.future_A_gamma_time = 1
777         else:
778             old_D = self.D
779 
780     D: uint256 = Math(math).newton_D(A_gamma[0], A_gamma[1], xp)
781 
782     token_supply: uint256 = CurveToken(token).totalSupply()
783     if old_D > 0:
784         d_token = token_supply * D / old_D - token_supply
785     else:
786         d_token = self.get_xcp(D)  # making initial virtual price equal to 1
787     assert d_token > 0  # dev: nothing minted
788 
789     if old_D > 0:
790         d_token_fee = self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
791         d_token -= d_token_fee
792         token_supply += d_token
793         CurveToken(token).mint(msg.sender, d_token)
794 
795         # Calculate price
796         # p_i * (dx_i - dtoken / token_supply * xx_i) = sum{k!=i}(p_k * (dtoken / token_supply * xx_k - dx_k))
797         # Only ix is nonzero
798         p: uint256 = 0
799         if d_token > 10**5:
800             if ix < N_COINS:
801                 S: uint256 = 0
802                 last_prices: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
803                 packed_prices: uint256 = self.last_prices_packed
804                 precisions: uint256[N_COINS] = PRECISIONS
805                 for k in range(N_COINS-1):
806                     last_prices[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
807                     packed_prices = shift(packed_prices, -PRICE_SIZE)
808                 for i in range(N_COINS):
809                     if i != ix:
810                         if i == 0:
811                             S += xx[0] * PRECISIONS[0]
812                         else:
813                             S += xx[i] * last_prices[i-1] * precisions[i] / PRECISION
814                 S = S * d_token / token_supply
815                 p = S * PRECISION / (amounts[ix] * precisions[ix] - d_token * xx[ix] * precisions[ix] / token_supply)
816 
817         self.tweak_price(A_gamma, xp, ix, p, D)
818 
819     else:
820         self.D = D
821         self.virtual_price = 10**18
822         self.xcp_profit = 10**18
823         CurveToken(token).mint(msg.sender, d_token)
824 
825     assert d_token >= min_mint_amount, "Slippage"
826 
827     log AddLiquidity(msg.sender, amounts, d_token_fee, token_supply)
828 
829 
830 @external
831 @nonreentrant('lock')
832 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
833     """
834     This withdrawal method is very safe, does no complex math
835     """
836     _coins: address[N_COINS] = coins
837     total_supply: uint256 = CurveToken(token).totalSupply()
838     CurveToken(token).burnFrom(msg.sender, _amount)
839     balances: uint256[N_COINS] = self.balances
840     amount: uint256 = _amount - 1  # Make rounding errors favoring other LPs a tiny bit
841 
842     for i in range(N_COINS):
843         d_balance: uint256 = balances[i] * amount / total_supply
844         assert d_balance >= min_amounts[i]
845         self.balances[i] = balances[i] - d_balance
846         balances[i] = d_balance  # now it's the amounts going out
847         # assert might be needed for some tokens - removed one to save bytespace
848         ERC20(_coins[i]).transfer(msg.sender, d_balance)
849 
850     D: uint256 = self.D
851     self.D = D - D * amount / total_supply
852 
853     log RemoveLiquidity(msg.sender, balances, total_supply - _amount)
854 
855 
856 @view
857 @external
858 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
859     return Views(views).calc_token_amount(amounts, deposit)
860 
861 
862 @internal
863 @view
864 def _calc_withdraw_one_coin(A_gamma: uint256[2], token_amount: uint256, i: uint256, update_D: bool,
865                             calc_price: bool) -> (uint256, uint256, uint256, uint256[N_COINS]):
866     token_supply: uint256 = CurveToken(token).totalSupply()
867     assert token_amount <= token_supply  # dev: token amount more than supply
868     assert i < N_COINS  # dev: coin out of range
869 
870     xx: uint256[N_COINS] = self.balances
871     xp: uint256[N_COINS] = PRECISIONS
872     D0: uint256 = 0
873 
874     price_scale_i: uint256 = PRECISION * PRECISIONS[0]
875     if True:  # To remove packed_prices from memory
876         packed_prices: uint256 = self.price_scale_packed
877         xp[0] *= xx[0]
878         for k in range(1, N_COINS):
879             p: uint256 = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
880             if i == k:
881                 price_scale_i = p * xp[i]
882             xp[k] = xp[k] * xx[k] * p / PRECISION
883             packed_prices = shift(packed_prices, -PRICE_SIZE)
884 
885     if update_D:
886         D0 = Math(math).newton_D(A_gamma[0], A_gamma[1], xp)
887     else:
888         D0 = self.D
889 
890     D: uint256 = D0
891 
892     # Charge the fee on D, not on y, e.g. reducing invariant LESS than charging the user
893     fee: uint256 = self._fee(xp)
894     dD: uint256 = token_amount * D / token_supply
895     D -= (dD - (fee * dD / (2 * 10**10) + 1))
896     y: uint256 = Math(math).newton_y(A_gamma[0], A_gamma[1], xp, D, i)
897     dy: uint256 = (xp[i] - y) * PRECISION / price_scale_i
898     xp[i] = y
899 
900     # Price calc
901     p: uint256 = 0
902     if calc_price and dy > 10**5 and token_amount > 10**5:
903         # p_i = dD / D0 * sum'(p_k * x_k) / (dy - dD / D0 * y0)
904         S: uint256 = 0
905         precisions: uint256[N_COINS] = PRECISIONS
906         last_prices: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
907         packed_prices: uint256 = self.last_prices_packed
908         for k in range(N_COINS-1):
909             last_prices[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
910             packed_prices = shift(packed_prices, -PRICE_SIZE)
911         for k in range(N_COINS):
912             if k != i:
913                 if k == 0:
914                     S += xx[0] * PRECISIONS[0]
915                 else:
916                     S += xx[k] * last_prices[k-1] * precisions[k] / PRECISION
917         S = S * dD / D0
918         p = S * PRECISION / (dy * precisions[i] - dD * xx[i] * precisions[i] / D0)
919 
920     return dy, p, D, xp
921 
922 
923 @view
924 @external
925 def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256:
926     return self._calc_withdraw_one_coin(self._A_gamma(), token_amount, i, True, False)[0]
927 
928 
929 @external
930 @nonreentrant('lock')
931 def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256):
932     assert not self.is_killed  # dev: the pool is killed
933 
934     A_gamma: uint256[2] = self._A_gamma()
935 
936     dy: uint256 = 0
937     D: uint256 = 0
938     p: uint256 = 0
939     xp: uint256[N_COINS] = empty(uint256[N_COINS])
940     future_A_gamma_time: uint256 = self.future_A_gamma_time
941     dy, p, D, xp = self._calc_withdraw_one_coin(A_gamma, token_amount, i, (future_A_gamma_time > 0), True)
942     assert dy >= min_amount, "Slippage"
943 
944     if block.timestamp >= future_A_gamma_time:
945         self.future_A_gamma_time = 1
946 
947     self.balances[i] -= dy
948     CurveToken(token).burnFrom(msg.sender, token_amount)
949     self.tweak_price(A_gamma, xp, i, p, D)
950 
951     _coins: address[N_COINS] = coins
952     # assert might be needed for some tokens - removed one to save bytespace
953     ERC20(_coins[i]).transfer(msg.sender, dy)
954 
955     log RemoveLiquidityOne(msg.sender, token_amount, i, dy)
956 
957 
958 @external
959 @nonreentrant('lock')
960 def claim_admin_fees():
961     self._claim_admin_fees()
962 
963 
964 # Admin parameters
965 @external
966 def ramp_A_gamma(future_A: uint256, future_gamma: uint256, future_time: uint256):
967     assert msg.sender == self.owner  # dev: only owner
968     assert block.timestamp > self.initial_A_gamma_time + (MIN_RAMP_TIME-1)
969     assert future_time > block.timestamp + (MIN_RAMP_TIME-1)  # dev: insufficient time
970 
971     A_gamma: uint256[2] = self._A_gamma()
972     initial_A_gamma: uint256 = shift(A_gamma[0], 128)
973     initial_A_gamma = bitwise_or(initial_A_gamma, A_gamma[1])
974 
975     assert future_A > 0
976     assert future_A < MAX_A+1
977     assert future_gamma > MIN_GAMMA-1
978     assert future_gamma < MAX_GAMMA+1
979 
980     ratio: uint256 = 10**18 * future_A / A_gamma[0]
981     assert ratio < 10**18 * MAX_A_CHANGE + 1
982     assert ratio > 10**18 / MAX_A_CHANGE - 1
983 
984     ratio = 10**18 * future_gamma / A_gamma[1]
985     assert ratio < 10**18 * MAX_A_CHANGE + 1
986     assert ratio > 10**18 / MAX_A_CHANGE - 1
987 
988     self.initial_A_gamma = initial_A_gamma
989     self.initial_A_gamma_time = block.timestamp
990 
991     future_A_gamma: uint256 = shift(future_A, 128)
992     future_A_gamma = bitwise_or(future_A_gamma, future_gamma)
993     self.future_A_gamma_time = future_time
994     self.future_A_gamma = future_A_gamma
995 
996     log RampAgamma(A_gamma[0], future_A, A_gamma[1], future_gamma, block.timestamp, future_time)
997 
998 
999 @external
1000 def stop_ramp_A_gamma():
1001     assert msg.sender == self.owner  # dev: only owner
1002 
1003     A_gamma: uint256[2] = self._A_gamma()
1004     current_A_gamma: uint256 = shift(A_gamma[0], 128)
1005     current_A_gamma = bitwise_or(current_A_gamma, A_gamma[1])
1006     self.initial_A_gamma = current_A_gamma
1007     self.future_A_gamma = current_A_gamma
1008     self.initial_A_gamma_time = block.timestamp
1009     self.future_A_gamma_time = block.timestamp
1010     # now (block.timestamp < t1) is always False, so we return saved A
1011 
1012     log StopRampA(A_gamma[0], A_gamma[1], block.timestamp)
1013 
1014 
1015 @external
1016 def commit_new_parameters(
1017     _new_mid_fee: uint256,
1018     _new_out_fee: uint256,
1019     _new_admin_fee: uint256,
1020     _new_fee_gamma: uint256,
1021     _new_allowed_extra_profit: uint256,
1022     _new_adjustment_step: uint256,
1023     _new_ma_half_time: uint256,
1024     ):
1025     assert msg.sender == self.owner  # dev: only owner
1026     assert self.admin_actions_deadline == 0  # dev: active action
1027 
1028     new_mid_fee: uint256 = _new_mid_fee
1029     new_out_fee: uint256 = _new_out_fee
1030     new_admin_fee: uint256 = _new_admin_fee
1031     new_fee_gamma: uint256 = _new_fee_gamma
1032     new_allowed_extra_profit: uint256 = _new_allowed_extra_profit
1033     new_adjustment_step: uint256 = _new_adjustment_step
1034     new_ma_half_time: uint256 = _new_ma_half_time
1035 
1036     # Fees
1037     if new_out_fee < MAX_FEE+1:
1038         assert new_out_fee > MIN_FEE-1  # dev: fee is out of range
1039     else:
1040         new_out_fee = self.out_fee
1041     if new_mid_fee > MAX_FEE:
1042         new_mid_fee = self.mid_fee
1043     assert new_mid_fee <= new_out_fee  # dev: mid-fee is too high
1044     if new_admin_fee > MAX_ADMIN_FEE:
1045         new_admin_fee = self.admin_fee
1046 
1047     # AMM parameters
1048     if new_fee_gamma < 10**18:
1049         assert new_fee_gamma > 0  # dev: fee_gamma out of range [1 .. 10**18]
1050     else:
1051         new_fee_gamma = self.fee_gamma
1052     if new_allowed_extra_profit > 10**18:
1053         new_allowed_extra_profit = self.allowed_extra_profit
1054     if new_adjustment_step > 10**18:
1055         new_adjustment_step = self.adjustment_step
1056 
1057     # MA
1058     if new_ma_half_time < 7*86400:
1059         assert new_ma_half_time > 0  # dev: MA time should be longer than 1 second
1060     else:
1061         new_ma_half_time = self.ma_half_time
1062 
1063     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1064     self.admin_actions_deadline = _deadline
1065 
1066     self.future_admin_fee = new_admin_fee
1067     self.future_mid_fee = new_mid_fee
1068     self.future_out_fee = new_out_fee
1069     self.future_fee_gamma = new_fee_gamma
1070     self.future_allowed_extra_profit = new_allowed_extra_profit
1071     self.future_adjustment_step = new_adjustment_step
1072     self.future_ma_half_time = new_ma_half_time
1073 
1074     log CommitNewParameters(_deadline, new_admin_fee, new_mid_fee, new_out_fee,
1075                             new_fee_gamma,
1076                             new_allowed_extra_profit, new_adjustment_step,
1077                             new_ma_half_time)
1078 
1079 
1080 @external
1081 @nonreentrant('lock')
1082 def apply_new_parameters():
1083     assert msg.sender == self.owner  # dev: only owner
1084     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
1085     assert self.admin_actions_deadline != 0  # dev: no active action
1086 
1087     self.admin_actions_deadline = 0
1088 
1089     admin_fee: uint256 = self.future_admin_fee
1090     if self.admin_fee != admin_fee:
1091         self._claim_admin_fees()
1092         self.admin_fee = admin_fee
1093 
1094     mid_fee: uint256 = self.future_mid_fee
1095     self.mid_fee = mid_fee
1096     out_fee: uint256 = self.future_out_fee
1097     self.out_fee = out_fee
1098     fee_gamma: uint256 = self.future_fee_gamma
1099     self.fee_gamma = fee_gamma
1100     allowed_extra_profit: uint256 = self.future_allowed_extra_profit
1101     self.allowed_extra_profit = allowed_extra_profit
1102     adjustment_step: uint256 = self.future_adjustment_step
1103     self.adjustment_step = adjustment_step
1104     ma_half_time: uint256 = self.future_ma_half_time
1105     self.ma_half_time = ma_half_time
1106 
1107     log NewParameters(admin_fee, mid_fee, out_fee,
1108                       fee_gamma,
1109                       allowed_extra_profit, adjustment_step,
1110                       ma_half_time)
1111 
1112 
1113 @external
1114 def revert_new_parameters():
1115     assert msg.sender == self.owner  # dev: only owner
1116 
1117     self.admin_actions_deadline = 0
1118 
1119 
1120 @external
1121 def commit_transfer_ownership(_owner: address):
1122     assert msg.sender == self.owner  # dev: only owner
1123     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1124 
1125     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1126     self.transfer_ownership_deadline = _deadline
1127     self.future_owner = _owner
1128 
1129     log CommitNewAdmin(_deadline, _owner)
1130 
1131 
1132 @external
1133 def apply_transfer_ownership():
1134     assert msg.sender == self.owner  # dev: only owner
1135     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1136     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1137 
1138     self.transfer_ownership_deadline = 0
1139     _owner: address = self.future_owner
1140     self.owner = _owner
1141 
1142     log NewAdmin(_owner)
1143 
1144 
1145 @external
1146 def revert_transfer_ownership():
1147     assert msg.sender == self.owner  # dev: only owner
1148 
1149     self.transfer_ownership_deadline = 0
1150 
1151 
1152 @external
1153 def kill_me():
1154     assert msg.sender == self.owner  # dev: only owner
1155     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1156     self.is_killed = True
1157 
1158 
1159 @external
1160 def unkill_me():
1161     assert msg.sender == self.owner  # dev: only owner
1162     self.is_killed = False
1163 
1164 
1165 @external
1166 def set_admin_fee_receiver(_admin_fee_receiver: address):
1167     assert msg.sender == self.owner  # dev: only owner
1168     self.admin_fee_receiver = _admin_fee_receiver