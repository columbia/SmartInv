1 # @version 0.2.12
2 # (c) Curve.Fi, 2021
3 # Pool for USDT/WBTC/WETH or similar
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
74     price_threshold: uint256
75     adjustment_step: uint256
76     ma_half_time: uint256
77 
78 event NewParameters:
79     admin_fee: uint256
80     mid_fee: uint256
81     out_fee: uint256
82     fee_gamma: uint256
83     price_threshold: uint256
84     adjustment_step: uint256
85     ma_half_time: uint256
86 
87 event RampAgamma:
88     initial_A: uint256
89     future_A: uint256
90     initial_time: uint256
91     future_time: uint256
92 
93 event StopRampA:
94     current_A: uint256
95     current_gamma: uint256
96     time: uint256
97 
98 event ClaimAdminFee:
99     admin: indexed(address)
100     tokens: uint256
101 
102 
103 N_COINS: constant(int128) = 3  # <- change
104 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
105 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
106 A_MULTIPLIER: constant(uint256) = 100
107 
108 # These addresses are replaced by the deployer
109 math: constant(address) = 0x656Dd75d33a6241A0C4C2368eb00441Ad3113ec0
110 token: constant(address) = 0xcA3d75aC011BF5aD07a98d02f18225F9bD9A6BDF
111 views: constant(address) = 0xCfB3CFEaE8c3F39aECDf7ec275a00d29ECA08535
112 coins: constant(address[N_COINS]) = [
113     0xdAC17F958D2ee523a2206206994597C13D831ec7,
114     0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,
115     0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
116 ]
117 
118 price_scale_packed: uint256   # Internal price scale
119 price_oracle_packed: uint256  # Price target given by MA
120 
121 last_prices_packed: uint256
122 last_prices_timestamp: public(uint256)
123 
124 initial_A_gamma: public(uint256)
125 future_A_gamma: public(uint256)
126 initial_A_gamma_time: public(uint256)
127 future_A_gamma_time: public(uint256)
128 
129 price_threshold: public(uint256)
130 future_price_threshoold: public(uint256)
131 
132 fee_gamma: public(uint256)
133 future_fee_gamma: public(uint256)
134 
135 adjustment_step: public(uint256)
136 future_adjustment_step: public(uint256)
137 
138 ma_half_time: public(uint256)
139 future_ma_half_time: public(uint256)
140 
141 mid_fee: public(uint256)
142 out_fee: public(uint256)
143 admin_fee: public(uint256)
144 future_mid_fee: public(uint256)
145 future_out_fee: public(uint256)
146 future_admin_fee: public(uint256)
147 
148 balances: public(uint256[N_COINS])
149 D: public(uint256)
150 
151 owner: public(address)
152 future_owner: public(address)
153 
154 xcp_profit: public(uint256)
155 xcp_profit_a: public(uint256)  # Full profit at last claim of admin fees
156 virtual_price: public(uint256)  # Cached (fast to read) virtual price also used internally
157 not_adjusted: bool
158 
159 is_killed: public(bool)
160 kill_deadline: public(uint256)
161 transfer_ownership_deadline: public(uint256)
162 admin_actions_deadline: public(uint256)
163 
164 admin_fee_receiver: public(address)
165 
166 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
167 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
168 MIN_RAMP_TIME: constant(uint256) = 86400
169 
170 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
171 MIN_FEE: constant(uint256) = 5 * 10 ** 5  # 0.5 bps
172 MAX_FEE: constant(uint256) = 5 * 10 ** 9
173 MAX_A: constant(uint256) = 10000 * A_MULTIPLIER
174 MAX_A_CHANGE: constant(uint256) = 10
175 MIN_GAMMA: constant(uint256) = 10**10
176 MAX_GAMMA: constant(uint256) = 10**16
177 NOISE_FEE: constant(uint256) = 10**5  # 0.1 bps
178 
179 PRICE_SIZE: constant(int128) = 256 / (N_COINS-1)
180 PRICE_MASK: constant(uint256) = 2**PRICE_SIZE - 1
181 
182 ALLOWED_EXTRA_PROFIT: constant(uint256) = 10**13  # 0.1 bps above the baseline
183 
184 # This must be changed for different N_COINS
185 # For example:
186 # N_COINS = 3 -> 1  (10**18 -> 10**18)
187 # N_COINS = 4 -> 10**8  (10**18 -> 10**10)
188 # PRICE_PRECISION_MUL: constant(uint256) = 1
189 PRECISIONS: constant(uint256[N_COINS]) = [
190     10**12, # USDT
191     10**10, # WBTC
192     1, # WETH
193 ]
194 
195 
196 @external
197 def __init__(
198     owner: address,
199     A: uint256,
200     gamma: uint256,
201     mid_fee: uint256,
202     out_fee: uint256,
203     price_threshold: uint256,
204     fee_gamma: uint256,
205     adjustment_step: uint256,
206     admin_fee: uint256,
207     ma_half_time: uint256,
208     initial_prices: uint256[N_COINS-1]
209 ):
210     self.owner = owner
211 
212     # Pack A and gamma:
213     # shifted A + gamma
214     A_gamma: uint256 = shift(A * A_MULTIPLIER, 128)
215     A_gamma = bitwise_or(A_gamma, gamma)
216     self.initial_A_gamma = A_gamma
217     self.future_A_gamma = A_gamma
218 
219     self.mid_fee = mid_fee
220     self.out_fee = out_fee
221     self.price_threshold = price_threshold
222     self.fee_gamma = fee_gamma
223     self.adjustment_step = adjustment_step
224     self.admin_fee = admin_fee
225 
226     # Packing prices
227     packed_prices: uint256 = 0
228     for k in range(N_COINS-1):
229         packed_prices = shift(packed_prices, PRICE_SIZE)
230         p: uint256 = initial_prices[N_COINS-2 - k]  # / PRICE_PRECISION_MUL
231         assert p < PRICE_MASK
232         packed_prices = bitwise_or(p, packed_prices)
233 
234     self.price_scale_packed = packed_prices
235     self.price_oracle_packed = packed_prices
236     self.last_prices_packed = packed_prices
237     self.last_prices_timestamp = block.timestamp
238     self.ma_half_time = ma_half_time
239 
240     self.xcp_profit_a = 10**18
241 
242     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
243 
244     self.admin_fee_receiver = owner
245 
246 
247 @payable
248 @external
249 def __default__():
250     pass
251 
252 
253 @internal
254 @view
255 def _packed_view(k: uint256, p: uint256) -> uint256:
256     assert k < N_COINS-1
257     return bitwise_and(
258         shift(p, -PRICE_SIZE * convert(k, int256)),
259         PRICE_MASK
260     )  # * PRICE_PRECISION_MUL
261 
262 
263 @external
264 @view
265 def price_oracle(k: uint256) -> uint256:
266     return self._packed_view(k, self.price_oracle_packed)
267 
268 
269 @external
270 @view
271 def price_scale(k: uint256) -> uint256:
272     return self._packed_view(k, self.price_scale_packed)
273 
274 
275 @external
276 @view
277 def last_prices(k: uint256) -> uint256:
278     return self._packed_view(k, self.last_prices_packed)
279 
280 
281 @external
282 @view
283 def token() -> address:
284     return token
285 
286 
287 @external
288 @view
289 def coins(i: uint256) -> address:
290     _coins: address[N_COINS] = coins
291     return _coins[i]
292 
293 
294 @internal
295 @view
296 def xp() -> uint256[N_COINS]:
297     result: uint256[N_COINS] = self.balances
298     packed_prices: uint256 = self.price_scale_packed
299 
300     precisions: uint256[N_COINS] = PRECISIONS
301 
302     result[0] *= PRECISIONS[0]
303     for i in range(1, N_COINS):
304         p: uint256 = bitwise_and(packed_prices, PRICE_MASK) * precisions[i]  # * PRICE_PRECISION_MUL
305         result[i] = result[i] * p / PRECISION
306         packed_prices = shift(packed_prices, -PRICE_SIZE)
307 
308     return result
309 
310 
311 @view
312 @internal
313 def _A_gamma() -> (uint256, uint256):
314     t1: uint256 = self.future_A_gamma_time
315 
316     A_gamma_1: uint256 = self.future_A_gamma
317     gamma1: uint256 = bitwise_and(A_gamma_1, 2**128-1)
318     A1: uint256 = shift(A_gamma_1, -128)
319 
320     if block.timestamp < t1:
321         # handle ramping up and down of A
322         A_gamma_0: uint256 = self.initial_A_gamma
323         t0: uint256 = self.initial_A_gamma_time
324 
325         # Less readable but more compact way of writing and converting to uint256
326         # gamma0: uint256 = bitwise_and(A_gamma_0, 2**128-1)
327         # A0: uint256 = shift(A_gamma_0, -128)
328         # A1 = A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
329         # gamma1 = gamma0 + (gamma1 - gamma0) * (block.timestamp - t0) / (t1 - t0)
330 
331         t1 -= t0
332         t0 = block.timestamp - t0
333 
334         A1 = (shift(A_gamma_0, -128) * (t1 - t0) + A1 * t0) / t1
335         gamma1 = (bitwise_and(A_gamma_0, 2**128-1) * (t1 - t0) + gamma1 * t0) / t1
336 
337     return A1, gamma1
338 
339 
340 @view
341 @external
342 def A() -> uint256:
343     return self._A_gamma()[0] / A_MULTIPLIER
344 
345 
346 @view
347 @external
348 def gamma() -> uint256:
349     return self._A_gamma()[1]
350 
351 
352 @view
353 @external
354 def A_precise() -> uint256:
355     return self._A_gamma()[0]
356 
357 
358 @internal
359 @view
360 def _fee(xp: uint256[N_COINS]) -> uint256:
361     f: uint256 = Math(math).reduction_coefficient(xp, self.fee_gamma)
362     return (self.mid_fee * f + self.out_fee * (10**18 - f)) / 10**18
363 
364 
365 @external
366 @view
367 def fee() -> uint256:
368     return self._fee(self.xp())
369 
370 
371 @external
372 @view
373 def fee_calc(xp: uint256[N_COINS]) -> uint256:
374     return self._fee(xp)
375 
376 
377 @internal
378 @view
379 def get_xcp(D: uint256) -> uint256:
380     x: uint256[N_COINS] = empty(uint256[N_COINS])
381     x[0] = D / N_COINS
382     packed_prices: uint256 = self.price_scale_packed
383     # No precisions here because we don't switch to "real" units
384 
385     for i in range(1, N_COINS):
386         x[i] = D * 10**18 / (N_COINS * bitwise_and(packed_prices, PRICE_MASK))  # ... * PRICE_PRECISION_MUL)
387         packed_prices = shift(packed_prices, -PRICE_SIZE)
388 
389     return Math(math).geometric_mean(x)
390 
391 
392 @external
393 @view
394 def get_virtual_price() -> uint256:
395     return 10**18 * self.get_xcp(self.D) / CurveToken(token).totalSupply()
396 
397 
398 @internal
399 def _claim_admin_fees():
400     receiver: address = self.admin_fee_receiver
401 
402     xcp_profit: uint256 = self.xcp_profit
403     vprice: uint256 = self.virtual_price
404     fees: uint256 = (xcp_profit - self.xcp_profit_a) * self.admin_fee / (2 * 10**10)
405 
406     if fees > 0:
407         # Would be nice to recalc D, but we have no bytespace left
408 
409         frac: uint256 = vprice * 10**18 / (vprice - fees) - 10**18
410         claimed: uint256 = CurveToken(token).mint_relative(receiver, frac)
411         total_supply: uint256 = CurveToken(token).totalSupply()
412 
413         # Gulp here
414         _coins: address[N_COINS] = coins
415         for i in range(N_COINS):
416             self.balances[i] = ERC20(_coins[i]).balanceOf(self)
417 
418         # Recalculate D b/c we gulped
419         A: uint256 = 0
420         gamma: uint256 = 0
421         A, gamma = self._A_gamma()
422         xp: uint256[N_COINS] = self.xp()
423         D: uint256 = Math(math).newton_D(A, gamma, xp)
424 
425         new_vprice: uint256 = 10**18 * self.get_xcp(D) / total_supply
426         self.virtual_price = new_vprice
427 
428         xcp_profit = new_vprice + xcp_profit - vprice
429         self.xcp_profit_a = xcp_profit
430         self.xcp_profit = xcp_profit
431 
432         log ClaimAdminFee(receiver, claimed)
433 
434 
435 @internal
436 def tweak_price(A: uint256, gamma: uint256,
437                 _xp: uint256[N_COINS], i: uint256, p_i: uint256,
438                 new_D: uint256 = 0):
439     price_oracle: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
440     last_prices: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
441     price_scale: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
442     xp: uint256[N_COINS] = empty(uint256[N_COINS])
443     p_new: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
444     norm: uint256 = 0
445 
446     # Update MA if needed
447     packed_prices: uint256 = self.price_oracle_packed
448     for k in range(N_COINS-1):
449         price_oracle[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
450         packed_prices = shift(packed_prices, -PRICE_SIZE)
451 
452     last_prices_timestamp: uint256 = self.last_prices_timestamp
453     packed_prices = self.last_prices_packed
454     for k in range(N_COINS-1):
455         last_prices[k] = bitwise_and(packed_prices, PRICE_MASK)   # * PRICE_PRECISION_MUL
456         packed_prices = shift(packed_prices, -PRICE_SIZE)
457 
458     if last_prices_timestamp < block.timestamp:
459         # MA update required
460         ma_half_time: uint256 = self.ma_half_time
461         alpha: uint256 = Math(math).halfpow((block.timestamp - last_prices_timestamp) * 10**18 / ma_half_time, 10**10)
462         packed_prices = 0
463         for k in range(N_COINS-1):
464             price_oracle[k] = (last_prices[k] * (10**18 - alpha) + price_oracle[k] * alpha) / 10**18
465         for k in range(N_COINS-1):
466             packed_prices = shift(packed_prices, PRICE_SIZE)
467             p: uint256 = price_oracle[N_COINS-2 - k]  # / PRICE_PRECISION_MUL
468             assert p < PRICE_MASK
469             packed_prices = bitwise_or(p, packed_prices)
470         self.price_oracle_packed = packed_prices
471         self.last_prices_timestamp = block.timestamp
472 
473     D_unadjusted: uint256 = new_D  # Withdrawal methods know new D already
474     if new_D == 0:
475         # We will need this a few times (35k gas)
476         D_unadjusted = Math(math).newton_D(A, gamma, _xp)
477     packed_prices = self.price_scale_packed
478     for k in range(N_COINS-1):
479         price_scale[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
480         packed_prices = shift(packed_prices, -PRICE_SIZE)
481 
482     if p_i > 0:
483         # Save the last price
484         if i > 0:
485             last_prices[i-1] = p_i
486         else:
487             # If 0th price changed - change all prices instead
488             for k in range(N_COINS-1):
489                 last_prices[k] = last_prices[k] * 10**18 / p_i
490     else:
491         # calculate real prices
492         # it would cost 70k gas for a 3-token pool. Sad. How do we do better?
493         __xp: uint256[N_COINS] = _xp
494         dx_price: uint256 = __xp[0] / 10**6
495         __xp[0] += dx_price
496         for k in range(N_COINS-1):
497             last_prices[k] = price_scale[k] * dx_price / (_xp[k+1] - Math(math).newton_y(A, gamma, __xp, D_unadjusted, k+1))
498 
499     packed_prices = 0
500     for k in range(N_COINS-1):
501         packed_prices = shift(packed_prices, PRICE_SIZE)
502         p: uint256 = last_prices[N_COINS-2 - k]  # / PRICE_PRECISION_MUL
503         assert p < PRICE_MASK
504         packed_prices = bitwise_or(p, packed_prices)
505     self.last_prices_packed = packed_prices
506 
507     total_supply: uint256 = CurveToken(token).totalSupply()
508     old_xcp_profit: uint256 = self.xcp_profit
509     old_virtual_price: uint256 = self.virtual_price
510     for k in range(N_COINS-1):
511         ratio: uint256 = price_oracle[k] * 10**18 / price_scale[k]
512         if ratio > 10**18:
513             ratio -= 10**18
514         else:
515             ratio = 10**18 - ratio
516         norm += ratio**2
517 
518     # Update profit numbers without price adjustment first
519     xp[0] = D_unadjusted / N_COINS
520     for k in range(N_COINS-1):
521         xp[k+1] = D_unadjusted * 10**18 / (N_COINS * price_scale[k])
522     xcp_profit: uint256 = 10**18
523     virtual_price: uint256 = 10**18
524 
525     if old_virtual_price > 0:
526         xcp: uint256 = Math(math).geometric_mean(xp)
527         virtual_price = 10**18 * xcp / total_supply
528         xcp_profit = old_xcp_profit * virtual_price / old_virtual_price
529 
530         if virtual_price < old_virtual_price:
531             raise "Loss"
532 
533     self.xcp_profit = xcp_profit
534 
535     needs_adjustment: bool = self.not_adjusted
536     if not needs_adjustment and (virtual_price-10**18 > (xcp_profit-10**18)/2 + ALLOWED_EXTRA_PROFIT):
537         needs_adjustment = True
538         self.not_adjusted = True
539 
540     # self.price_threshold must be > self.adjustment_step
541     if needs_adjustment and norm > self.price_threshold ** 2 and old_virtual_price > 0:
542         norm = Math(math).sqrt_int(norm / 10**18)  # Need to convert to 1e18 units!
543         adjustment_step: uint256 = self.adjustment_step
544 
545         for k in range(N_COINS-1):
546             p_new[k] = (price_scale[k] * (norm - adjustment_step) + adjustment_step * price_oracle[k]) / norm
547 
548         # Calculate balances*prices
549         xp = _xp
550         for k in range(N_COINS-1):
551             xp[k+1] = _xp[k+1] * p_new[k] / price_scale[k]
552 
553         # Calculate "extended constant product" invariant xCP and virtual price
554         D: uint256 = Math(math).newton_D(A, gamma, xp)
555         xp[0] = D / N_COINS
556         for k in range(N_COINS-1):
557             xp[k+1] = D * 10**18 / (N_COINS * p_new[k])
558         # We reuse old_virtual_price here but it's not old anymore
559         old_virtual_price = 10**18 * Math(math).geometric_mean(xp) / total_supply
560 
561         # Proceed if we've got enough profit
562         if (old_virtual_price > 10**18) and (2 * (old_virtual_price - 10**18) > xcp_profit - 10**18):
563             packed_prices = 0
564             for k in range(N_COINS-1):
565                 packed_prices = shift(packed_prices, PRICE_SIZE)
566                 p: uint256 = p_new[N_COINS-2 - k]  # / PRICE_PRECISION_MUL
567                 assert p < PRICE_MASK
568                 packed_prices = bitwise_or(p, packed_prices)
569             self.price_scale_packed = packed_prices
570             self.D = D
571             self.virtual_price = old_virtual_price
572 
573             return
574 
575         else:
576             self.not_adjusted = False
577 
578     # If we are here, the price_scale adjustment did not happen
579     # Still need to update the profit counter and D
580     self.D = D_unadjusted
581     self.virtual_price = virtual_price
582 
583 
584 
585 @payable
586 @external
587 @nonreentrant('lock')
588 def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool = False):
589     assert not self.is_killed  # dev: the pool is killed
590     assert i != j  # dev: coin index out of range
591     assert i < N_COINS  # dev: coin index out of range
592     assert j < N_COINS  # dev: coin index out of range
593     assert dx > 0  # dev: do not exchange 0 coins
594 
595     A: uint256 = 0
596     gamma: uint256 = 0
597     A, gamma = self._A_gamma()
598     xp: uint256[N_COINS] = self.balances
599     ix: uint256 = j
600     p: uint256 = 0
601     dy: uint256 = 0
602 
603     if True:  # scope to reduce size of memory when making internal calls later
604         _coins: address[N_COINS] = coins
605         if i == 2 and use_eth:
606             assert msg.value == dx  # dev: incorrect eth amount
607             WETH(coins[2]).deposit(value=msg.value)
608         else:
609             assert msg.value == 0  # dev: nonzero eth amount
610             # assert might be needed for some tokens - removed one to save bytespace
611             ERC20(_coins[i]).transferFrom(msg.sender, self, dx)
612 
613         y: uint256 = xp[j]
614         xp[i] += dx
615         self.balances[i] = xp[i]
616         prec_i: uint256 = 0
617         prec_j: uint256 = 0
618 
619         price_scale: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
620         packed_prices: uint256 = self.price_scale_packed
621         for k in range(N_COINS-1):
622             price_scale[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
623             packed_prices = shift(packed_prices, -PRICE_SIZE)
624 
625         precisions: uint256[N_COINS] = PRECISIONS
626         xp[0] *= PRECISIONS[0]
627         for k in range(1, N_COINS):
628             xp[k] = xp[k] * price_scale[k-1] * precisions[k] / PRECISION
629         prec_i = precisions[i]
630         prec_j = precisions[j]
631 
632         dy = xp[j] - Math(math).newton_y(A, gamma, xp, self.D, j)
633         # Not defining new "y" here to have less variables / make subsequent calls cheaper
634         xp[j] -= dy
635         dy -= 1
636 
637         if j > 0:
638             dy = dy * PRECISION / price_scale[j-1]
639         dy /= prec_j
640 
641         dy -= self._fee(xp) * dy / 10**10
642         assert dy >= min_dy, "Slippage"
643         y -= dy
644 
645         self.balances[j] = y
646         # assert might be needed for some tokens - removed one to save bytespace
647         if j == 2 and use_eth:
648             WETH(coins[2]).withdraw(dy)
649             raw_call(msg.sender, b"", value=dy)
650         else:
651             ERC20(_coins[j]).transfer(msg.sender, dy)
652 
653         xp[j] = y * prec_j
654         if j > 0:
655             xp[j] = xp[j] * price_scale[j-1] / PRECISION
656 
657         # Calculate price
658         if dx > 10**5 and dy > 10**5:
659             if i != 0 and j != 0:
660                 p = bitwise_and(
661                     shift(self.last_prices_packed, -PRICE_SIZE * convert(i-1, int256)),
662                     PRICE_MASK
663                 ) * (dx * prec_i) / (dy * prec_j)  # * PRICE_PRECISION_MUL
664             elif i == 0:
665                 p = (dx * prec_i) * 10**18 / (dy * prec_j)
666             else:  # j == 0
667                 p = (dy * prec_j) * 10**18 / (dx * prec_i)
668                 ix = i
669 
670     self.tweak_price(A, gamma, xp, ix, p)
671 
672     log TokenExchange(msg.sender, i, dx, j, dy)
673 
674 
675 @external
676 @view
677 def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256:
678     return Views(views).get_dy(i, j, dx)
679 
680 
681 @view
682 @internal
683 def _calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
684     # fee = sum(amounts_i - avg(amounts)) * fee' / sum(amounts)
685     fee: uint256 = self._fee(xp) * N_COINS / (4 * (N_COINS-1))
686     S: uint256 = 0
687     for _x in amounts:
688         S += _x
689     avg: uint256 = S / N_COINS
690     Sdiff: uint256 = 0
691     for _x in amounts:
692         if _x > avg:
693             Sdiff += _x - avg
694         else:
695             Sdiff += avg - _x
696     return fee * Sdiff / S + NOISE_FEE
697 
698 
699 @external
700 @view
701 def calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
702     return self._calc_token_fee(amounts, xp)
703 
704 
705 @external
706 @nonreentrant('lock')
707 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
708     assert not self.is_killed  # dev: the pool is killed
709 
710     A: uint256 = 0
711     gamma: uint256 = 0
712     A, gamma = self._A_gamma()
713 
714     _coins: address[N_COINS] = coins
715 
716     xp: uint256[N_COINS] = self.balances
717     amountsp: uint256[N_COINS] = amounts
718     xx: uint256[N_COINS] = empty(uint256[N_COINS])
719     d_token: uint256 = 0
720     d_token_fee: uint256 = 0
721 
722     if True:  # Scope to avoid having extra variables in memory later
723         n_coins_added: uint256 = 0
724         for i in range(N_COINS):
725             if amounts[i] > 0:
726                 # assert might be needed for some tokens - removed one to save bytespace
727                 ERC20(_coins[i]).transferFrom(msg.sender, self, amounts[i])
728                 n_coins_added += 1
729         assert n_coins_added > 0  # dev: no coins to add
730 
731         for i in range(N_COINS):
732             bal: uint256 = xp[i] + amounts[i]
733             xp[i] = bal
734             self.balances[i] = bal
735         xx = xp
736 
737         precisions: uint256[N_COINS] = PRECISIONS
738         packed_prices: uint256 = self.price_scale_packed
739         xp[0] *= PRECISIONS[0]
740         for i in range(1, N_COINS):
741             price_scale: uint256 = bitwise_and(packed_prices, PRICE_MASK) * precisions[i]  # * PRICE_PRECISION_MUL
742             xp[i] = xp[i] * price_scale / PRECISION
743             amountsp[i] = amountsp[i] * price_scale / PRECISION
744             packed_prices = shift(packed_prices, -PRICE_SIZE)
745 
746     D: uint256 = Math(math).newton_D(A, gamma, xp)
747 
748     token_supply: uint256 = CurveToken(token).totalSupply()
749     old_D: uint256 = self.D
750     if old_D > 0:
751         d_token = token_supply * D / old_D - token_supply
752     else:
753         d_token = self.get_xcp(D)  # making initial virtual price equal to 1
754     assert d_token > 0  # dev: nothing minted
755 
756     if old_D > 0:
757         d_token_fee = self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
758         d_token -= d_token_fee
759         token_supply += d_token
760         CurveToken(token).mint(msg.sender, d_token)
761 
762         # Calculate price
763         # p_i * (dx_i - dtoken / token_supply * xx_i) = sum{k!=i}(p_k * (dtoken / token_supply * xx_k - dx_k))
764         # Only ix is nonzero
765         p: uint256 = 0
766         ix: uint256 = 0
767         if d_token > 10**5:
768             n_zeros: uint256 = 0
769             for i in range(N_COINS):
770                 if amounts[i] == 0:
771                     n_zeros += 1
772                 else:
773                     ix = i
774             if n_zeros == N_COINS-1:
775                 S: uint256 = 0
776                 last_prices: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
777                 packed_prices: uint256 = self.last_prices_packed
778                 precisions: uint256[N_COINS] = PRECISIONS
779                 for k in range(N_COINS-1):
780                     last_prices[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
781                     packed_prices = shift(packed_prices, -PRICE_SIZE)
782                 for i in range(N_COINS):
783                     if i != ix:
784                         if i == 0:
785                             S += xx[0] * PRECISIONS[0]
786                         else:
787                             S += xx[i] * last_prices[i-1] * precisions[i] / PRECISION
788                 S = S * d_token / token_supply
789                 p = S * PRECISION / (amounts[ix] * precisions[ix] - d_token * xx[ix] * precisions[ix] / token_supply)
790 
791         self.tweak_price(A, gamma, xp, ix, p, D)
792 
793     else:
794         self.D = D
795         self.virtual_price = 10**18
796         self.xcp_profit = 10**18
797         assert CurveToken(token).mint(msg.sender, d_token)
798 
799     assert d_token >= min_mint_amount, "Slippage"
800 
801     log AddLiquidity(msg.sender, amounts, d_token_fee, token_supply)
802 
803 
804 @external
805 @nonreentrant('lock')
806 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
807     """
808     This withdrawal method is very safe, does no complex math
809     """
810     _coins: address[N_COINS] = coins
811     total_supply: uint256 = CurveToken(token).totalSupply()
812     assert CurveToken(token).burnFrom(msg.sender, _amount)
813     balances: uint256[N_COINS] = self.balances
814     amount: uint256 = _amount - 1  # Make rounding errors favoring other LPs a tiny bit
815 
816     for i in range(N_COINS):
817         d_balance: uint256 = balances[i] * amount / total_supply
818         assert d_balance >= min_amounts[i]
819         self.balances[i] = balances[i] - d_balance
820         balances[i] = d_balance  # now it's the amounts going out
821         # assert might be needed for some tokens - removed one to save bytespace
822         ERC20(_coins[i]).transfer(msg.sender, d_balance)
823 
824     D: uint256 = self.D
825     self.D = D - D * amount / total_supply
826 
827     log RemoveLiquidity(msg.sender, balances, total_supply - _amount)
828 
829 
830 @view
831 @external
832 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
833     return Views(views).calc_token_amount(amounts, deposit)
834 
835 
836 @internal
837 @view
838 def _calc_withdraw_one_coin(A: uint256, gamma: uint256, token_amount: uint256, i: uint256,
839                             calc_price: bool) -> (uint256, uint256, uint256, uint256[N_COINS]):
840     D: uint256 = self.D
841     D0: uint256 = D
842     token_supply: uint256 = CurveToken(token).totalSupply()
843     assert token_amount <= token_supply  # dev: token amount more than supply
844     assert i < N_COINS  # dev: coin out of range
845 
846     xx: uint256[N_COINS] = self.balances
847     xp: uint256[N_COINS] = PRECISIONS
848 
849     price_scale_i: uint256 = PRECISION * PRECISIONS[0]
850     if True:  # To remove packed_prices from memory
851         packed_prices: uint256 = self.price_scale_packed
852         xp[0] *= xx[0]
853         for k in range(1, N_COINS):
854             p: uint256 = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
855             if i == k:
856                 price_scale_i = p * xp[i]
857             xp[k] = xp[k] * xx[k] * p / PRECISION
858             packed_prices = shift(packed_prices, -PRICE_SIZE)
859 
860     # Charge the fee on D, not on y, e.g. reducing invariant LESS than charging the user
861     fee: uint256 = self._fee(xp)
862     dD: uint256 = token_amount * D / token_supply
863     D -= (dD - (fee * dD / (2 * 10**10) + 1))
864     y: uint256 = Math(math).newton_y(A, gamma, xp, D, i)
865     dy: uint256 = (xp[i] - y) * PRECISION / price_scale_i
866     xp[i] = y
867 
868     # Price calc
869     p: uint256 = 0
870     if calc_price and dy > 10**5 and token_amount > 10**5:
871         # p_i = dD / D0 * sum'(p_k * x_k) / (dy - dD / D0 * y0)
872         S: uint256 = 0
873         precisions: uint256[N_COINS] = PRECISIONS
874         last_prices: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
875         packed_prices: uint256 = self.last_prices_packed
876         for k in range(N_COINS-1):
877             last_prices[k] = bitwise_and(packed_prices, PRICE_MASK)  # * PRICE_PRECISION_MUL
878             packed_prices = shift(packed_prices, -PRICE_SIZE)
879         for k in range(N_COINS):
880             if k != i:
881                 if k == 0:
882                     S += xx[0] * PRECISIONS[0]
883                 else:
884                     S += xx[k] * last_prices[k-1] * precisions[k] / PRECISION
885         S = S * dD / D0
886         p = S * PRECISION / (dy * precisions[i] - dD * xx[i] * precisions[i] / D0)
887 
888     return dy, p, D, xp
889 
890 
891 @view
892 @external
893 def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256:
894     A: uint256 = 0
895     gamma: uint256 = 0
896     A, gamma = self._A_gamma()
897     return self._calc_withdraw_one_coin(A, gamma, token_amount, i, False)[0]
898 
899 
900 @external
901 @nonreentrant('lock')
902 def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256):
903     assert not self.is_killed  # dev: the pool is killed
904 
905     A: uint256 = 0
906     gamma: uint256 = 0
907     A, gamma = self._A_gamma()
908 
909     dy: uint256 = 0
910     D: uint256 = 0
911     p: uint256 = 0
912     xp: uint256[N_COINS] = empty(uint256[N_COINS])
913     dy, p, D, xp = self._calc_withdraw_one_coin(A, gamma, token_amount, i, True)
914     assert dy >= min_amount, "Slippage"
915 
916     self.balances[i] -= dy
917     assert CurveToken(token).burnFrom(msg.sender, token_amount)
918     self.tweak_price(A, gamma, xp, i, p, D)
919 
920     _coins: address[N_COINS] = coins
921     # assert might be needed for some tokens - removed one to save bytespace
922     ERC20(_coins[i]).transfer(msg.sender, dy)
923 
924     log RemoveLiquidityOne(msg.sender, token_amount, i, dy)
925 
926 
927 @external
928 @nonreentrant('lock')
929 def claim_admin_fees():
930     self._claim_admin_fees()
931 
932 
933 # Admin parameters
934 @external
935 def ramp_A_gamma(future_A: uint256, future_gamma: uint256, future_time: uint256):
936     assert msg.sender == self.owner  # dev: only owner
937     assert block.timestamp > self.initial_A_gamma_time + (MIN_RAMP_TIME-1)
938     assert future_time > block.timestamp + (MIN_RAMP_TIME-1)  # dev: insufficient time
939 
940     initial_A: uint256 = 0
941     initial_gamma: uint256 = 0
942     initial_A, initial_gamma = self._A_gamma()
943     initial_A_gamma: uint256 = shift(initial_A, 128)
944     initial_A_gamma = bitwise_or(initial_A_gamma, initial_gamma)
945 
946     future_A_p: uint256 = future_A * A_MULTIPLIER
947 
948     assert future_A > 0
949     assert future_A < MAX_A
950     assert future_gamma > MIN_GAMMA-1
951     assert future_gamma < MAX_GAMMA+1
952     if future_A_p < initial_A:
953         assert future_A_p * MAX_A_CHANGE >= initial_A
954     else:
955         assert future_A_p <= initial_A * MAX_A_CHANGE
956 
957     self.initial_A_gamma = initial_A_gamma
958     self.initial_A_gamma_time = block.timestamp
959 
960     future_A_gamma: uint256 = shift(future_A_p, 128)
961     future_A_gamma = bitwise_or(future_A_gamma, future_gamma)
962     self.future_A_gamma_time = future_time
963     self.future_A_gamma = future_A_gamma
964 
965     log RampAgamma(initial_A, future_A_p, block.timestamp, future_time)
966 
967 
968 @external
969 def stop_ramp_A_gamma():
970     assert msg.sender == self.owner  # dev: only owner
971 
972     current_A: uint256 = 0
973     current_gamma: uint256 = 0
974     current_A, current_gamma = self._A_gamma()
975     current_A_gamma: uint256 = shift(current_A, 128)
976     current_A_gamma = bitwise_or(current_A_gamma, current_gamma)
977     self.initial_A_gamma = current_A_gamma
978     self.future_A_gamma = current_A_gamma
979     self.initial_A_gamma_time = block.timestamp
980     self.future_A_gamma_time = block.timestamp
981     # now (block.timestamp < t1) is always False, so we return saved A
982 
983     log StopRampA(current_A, current_gamma, block.timestamp)
984 
985 
986 @external
987 def commit_new_parameters(
988     _new_mid_fee: uint256,
989     _new_out_fee: uint256,
990     _new_admin_fee: uint256,
991     _new_fee_gamma: uint256,
992     _new_price_threshold: uint256,
993     _new_adjustment_step: uint256,
994     _new_ma_half_time: uint256,
995     ):
996     assert msg.sender == self.owner  # dev: only owner
997     assert self.admin_actions_deadline == 0  # dev: active action
998 
999     new_mid_fee: uint256 = _new_mid_fee
1000     new_out_fee: uint256 = _new_out_fee
1001     new_admin_fee: uint256 = _new_admin_fee
1002     new_fee_gamma: uint256 = _new_fee_gamma
1003     new_price_threshold: uint256 = _new_price_threshold
1004     new_adjustment_step: uint256 = _new_adjustment_step
1005     new_ma_half_time: uint256 = _new_ma_half_time
1006 
1007     # Fees
1008     if new_out_fee != MAX_UINT256:
1009         assert new_out_fee < MAX_FEE+1  # dev: fee is out of range
1010         assert new_out_fee > MIN_FEE-1  # dev: fee is out of range
1011     else:
1012         new_out_fee = self.out_fee
1013     if new_mid_fee == MAX_UINT256:
1014         new_mid_fee = self.mid_fee
1015     assert new_mid_fee <= new_out_fee  # dev: mid-fee is too high
1016     if new_admin_fee != MAX_UINT256:
1017         assert new_admin_fee < MAX_ADMIN_FEE+1  # dev: admin fee exceeds maximum
1018     else:
1019         new_admin_fee = self.admin_fee
1020 
1021     # AMM parameters
1022     if new_fee_gamma != MAX_UINT256:
1023         assert new_fee_gamma > 0  # dev: fee_gamma out of range [1 .. 2**100]
1024         assert new_fee_gamma < 2**100  # dev: fee_gamma out of range [1 .. 2**100]
1025     else:
1026         new_fee_gamma = self.fee_gamma
1027     if new_price_threshold != MAX_UINT256:
1028         assert new_price_threshold > new_mid_fee  # dev: price threshold should be higher than the fee
1029     else:
1030         new_price_threshold = self.price_threshold
1031     if new_adjustment_step == MAX_UINT256:
1032         new_adjustment_step = self.adjustment_step
1033     assert new_adjustment_step <= new_price_threshold  # dev: adjustment step should be smaller than price threshold
1034 
1035     # MA
1036     if new_ma_half_time != MAX_UINT256:
1037         assert new_ma_half_time > 0  # dev: MA time should be shorter than 1 week
1038         assert new_ma_half_time < 7*86400  # dev: MA time should be shorter than 1 week
1039     else:
1040         new_ma_half_time = self.ma_half_time
1041 
1042     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1043     self.admin_actions_deadline = _deadline
1044 
1045     self.future_admin_fee = new_admin_fee
1046     self.future_mid_fee = new_mid_fee
1047     self.future_out_fee = new_out_fee
1048     self.future_fee_gamma = new_fee_gamma
1049     self.future_price_threshoold = new_price_threshold
1050     self.future_adjustment_step = new_adjustment_step
1051     self.future_ma_half_time = new_ma_half_time
1052 
1053     log CommitNewParameters(_deadline, new_admin_fee, new_mid_fee, new_out_fee,
1054                             new_fee_gamma,
1055                             new_price_threshold, new_adjustment_step,
1056                             new_ma_half_time)
1057 
1058 
1059 @external
1060 @nonreentrant('lock')
1061 def apply_new_parameters():
1062     assert msg.sender == self.owner  # dev: only owner
1063     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
1064     assert self.admin_actions_deadline != 0  # dev: no active action
1065 
1066     self.admin_actions_deadline = 0
1067 
1068     admin_fee: uint256 = self.future_admin_fee
1069     if self.admin_fee != admin_fee:
1070         self._claim_admin_fees()
1071         self.admin_fee = admin_fee
1072 
1073     mid_fee: uint256 = self.future_mid_fee
1074     self.mid_fee = mid_fee
1075     out_fee: uint256 = self.future_out_fee
1076     self.out_fee = out_fee
1077     fee_gamma: uint256 = self.future_fee_gamma
1078     self.fee_gamma = fee_gamma
1079     price_threshold: uint256 = self.future_price_threshoold
1080     self.price_threshold = price_threshold
1081     adjustment_step: uint256 = self.future_adjustment_step
1082     self.adjustment_step = adjustment_step
1083     ma_half_time: uint256 = self.future_ma_half_time
1084     self.ma_half_time = ma_half_time
1085 
1086     log NewParameters(admin_fee, mid_fee, out_fee,
1087                       fee_gamma,
1088                       price_threshold, adjustment_step,
1089                       ma_half_time)
1090 
1091 
1092 @external
1093 def revert_new_parameters():
1094     assert msg.sender == self.owner  # dev: only owner
1095 
1096     self.admin_actions_deadline = 0
1097 
1098 
1099 @external
1100 def commit_transfer_ownership(_owner: address):
1101     assert msg.sender == self.owner  # dev: only owner
1102     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1103 
1104     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1105     self.transfer_ownership_deadline = _deadline
1106     self.future_owner = _owner
1107 
1108     log CommitNewAdmin(_deadline, _owner)
1109 
1110 
1111 @external
1112 def apply_transfer_ownership():
1113     assert msg.sender == self.owner  # dev: only owner
1114     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1115     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1116 
1117     self.transfer_ownership_deadline = 0
1118     _owner: address = self.future_owner
1119     self.owner = _owner
1120 
1121     log NewAdmin(_owner)
1122 
1123 
1124 @external
1125 def revert_transfer_ownership():
1126     assert msg.sender == self.owner  # dev: only owner
1127 
1128     self.transfer_ownership_deadline = 0
1129 
1130 
1131 @external
1132 def kill_me():
1133     assert msg.sender == self.owner  # dev: only owner
1134     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1135     self.is_killed = True
1136 
1137 
1138 @external
1139 def unkill_me():
1140     assert msg.sender == self.owner  # dev: only owner
1141     self.is_killed = False
1142 
1143 
1144 @external
1145 def set_admin_fee_receiver(_admin_fee_receiver: address):
1146     assert msg.sender == self.owner  # dev: only owner
1147     self.admin_fee_receiver = _admin_fee_receiver