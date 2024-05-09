1 # @version 0.3.1
2 # (c) Curve.Fi, 2021
3 # Pool for two crypto assets
4 
5 # Universal implementation which can use both ETH and ERC20s
6 from vyper.interfaces import ERC20
7 
8 
9 interface Factory:
10     def admin() -> address: view
11     def fee_receiver() -> address: view
12 
13 interface CurveToken:
14     def totalSupply() -> uint256: view
15     def mint(_to: address, _value: uint256) -> bool: nonpayable
16     def mint_relative(_to: address, frac: uint256) -> uint256: nonpayable
17     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
18 
19 interface WETH:
20     def deposit(): payable
21     def withdraw(_amount: uint256): nonpayable
22 
23 
24 # Events
25 event TokenExchange:
26     buyer: indexed(address)
27     sold_id: uint256
28     tokens_sold: uint256
29     bought_id: uint256
30     tokens_bought: uint256
31 
32 event AddLiquidity:
33     provider: indexed(address)
34     token_amounts: uint256[N_COINS]
35     fee: uint256
36     token_supply: uint256
37 
38 event RemoveLiquidity:
39     provider: indexed(address)
40     token_amounts: uint256[N_COINS]
41     token_supply: uint256
42 
43 event RemoveLiquidityOne:
44     provider: indexed(address)
45     token_amount: uint256
46     coin_index: uint256
47     coin_amount: uint256
48 
49 event CommitNewParameters:
50     deadline: indexed(uint256)
51     admin_fee: uint256
52     mid_fee: uint256
53     out_fee: uint256
54     fee_gamma: uint256
55     allowed_extra_profit: uint256
56     adjustment_step: uint256
57     ma_half_time: uint256
58 
59 event NewParameters:
60     admin_fee: uint256
61     mid_fee: uint256
62     out_fee: uint256
63     fee_gamma: uint256
64     allowed_extra_profit: uint256
65     adjustment_step: uint256
66     ma_half_time: uint256
67 
68 event RampAgamma:
69     initial_A: uint256
70     future_A: uint256
71     initial_gamma: uint256
72     future_gamma: uint256
73     initial_time: uint256
74     future_time: uint256
75 
76 event StopRampA:
77     current_A: uint256
78     current_gamma: uint256
79     time: uint256
80 
81 event ClaimAdminFee:
82     admin: indexed(address)
83     tokens: uint256
84 
85 
86 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
87 MIN_RAMP_TIME: constant(uint256) = 86400
88 
89 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
90 MIN_FEE: constant(uint256) = 5 * 10 ** 5  # 0.5 bps
91 MAX_FEE: constant(uint256) = 10 * 10 ** 9
92 MAX_A_CHANGE: constant(uint256) = 10
93 NOISE_FEE: constant(uint256) = 10**5  # 0.1 bps
94 
95 MIN_GAMMA: constant(uint256) = 10**10
96 MAX_GAMMA: constant(uint256) = 2 * 10**16
97 
98 MIN_A: constant(uint256) = N_COINS**N_COINS * A_MULTIPLIER / 10
99 MAX_A: constant(uint256) = N_COINS**N_COINS * A_MULTIPLIER * 100000
100 
101 EXP_PRECISION: constant(uint256) = 10**10
102 
103 N_COINS: constant(int128) = 2
104 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
105 A_MULTIPLIER: constant(uint256) = 10000
106 
107 
108 # Implementation can be changed by changing this constant
109 WETH20: immutable(address)
110 
111 
112 token: public(address)
113 coins: public(address[N_COINS])
114 
115 price_scale: public(uint256)   # Internal price scale
116 _price_oracle: uint256  # Price target given by MA
117 
118 last_prices: public(uint256)
119 last_prices_timestamp: public(uint256)
120 
121 initial_A_gamma: public(uint256)
122 future_A_gamma: public(uint256)
123 initial_A_gamma_time: public(uint256)
124 future_A_gamma_time: public(uint256)
125 
126 allowed_extra_profit: public(uint256)  # 2 * 10**12 - recommended value
127 future_allowed_extra_profit: public(uint256)
128 
129 fee_gamma: public(uint256)
130 future_fee_gamma: public(uint256)
131 
132 adjustment_step: public(uint256)
133 future_adjustment_step: public(uint256)
134 
135 ma_half_time: public(uint256)
136 future_ma_half_time: public(uint256)
137 
138 mid_fee: public(uint256)
139 out_fee: public(uint256)
140 admin_fee: public(uint256)
141 future_mid_fee: public(uint256)
142 future_out_fee: public(uint256)
143 future_admin_fee: public(uint256)
144 
145 balances: public(uint256[N_COINS])
146 D: public(uint256)
147 
148 factory: public(address)
149 
150 xcp_profit: public(uint256)
151 xcp_profit_a: public(uint256)  # Full profit at last claim of admin fees
152 virtual_price: public(uint256)  # Cached (fast to read) virtual price also used internally
153 not_adjusted: bool
154 
155 admin_actions_deadline: public(uint256)
156 
157 # This must be changed for different N_COINS
158 # For example:
159 # N_COINS = 3 -> 1  (10**18 -> 10**18)
160 # N_COINS = 4 -> 10**8  (10**18 -> 10**10)
161 # PRICE_PRECISION_MUL: constant(uint256) = 1
162 PRECISIONS: uint256  # packed
163 
164 
165 @external
166 def __init__(_weth: address):
167     WETH20 = _weth
168     self.mid_fee = 22022022
169 
170 
171 @payable
172 @external
173 def __default__():
174     pass
175 
176 
177 # Internal Functions
178 
179 @internal
180 @view
181 def _get_precisions() -> uint256[2]:
182     p0: uint256 = self.PRECISIONS
183     p1: uint256 = 10 ** shift(p0, -8)
184     p0 = 10 ** bitwise_and(p0, 255)
185     return [p0, p1]
186 
187 
188 @internal
189 @view
190 def xp() -> uint256[N_COINS]:
191     precisions: uint256[2] = self._get_precisions()
192     return [self.balances[0] * precisions[0],
193             self.balances[1] * precisions[1] * self.price_scale / PRECISION]
194 
195 
196 @view
197 @internal
198 def _A_gamma() -> uint256[2]:
199     t1: uint256 = self.future_A_gamma_time
200 
201     A_gamma_1: uint256 = self.future_A_gamma
202     gamma1: uint256 = bitwise_and(A_gamma_1, 2**128-1)
203     A1: uint256 = shift(A_gamma_1, -128)
204 
205     if block.timestamp < t1:
206         # handle ramping up and down of A
207         A_gamma_0: uint256 = self.initial_A_gamma
208         t0: uint256 = self.initial_A_gamma_time
209 
210         # Less readable but more compact way of writing and converting to uint256
211         # gamma0: uint256 = bitwise_and(A_gamma_0, 2**128-1)
212         # A0: uint256 = shift(A_gamma_0, -128)
213         # A1 = A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
214         # gamma1 = gamma0 + (gamma1 - gamma0) * (block.timestamp - t0) / (t1 - t0)
215 
216         t1 -= t0
217         t0 = block.timestamp - t0
218         t2: uint256 = t1 - t0
219 
220         A1 = (shift(A_gamma_0, -128) * t2 + A1 * t0) / t1
221         gamma1 = (bitwise_and(A_gamma_0, 2**128-1) * t2 + gamma1 * t0) / t1
222 
223     return [A1, gamma1]
224 
225 
226 @internal
227 @view
228 def _fee(xp: uint256[N_COINS]) -> uint256:
229     """
230     f = fee_gamma / (fee_gamma + (1 - K))
231     where
232     K = prod(x) / (sum(x) / N)**N
233     (all normalized to 1e18)
234     """
235     fee_gamma: uint256 = self.fee_gamma
236     f: uint256 = xp[0] + xp[1]  # sum
237     f = fee_gamma * 10**18 / (
238         fee_gamma + 10**18 - (10**18 * N_COINS**N_COINS) * xp[0] / f * xp[1] / f
239     )
240     return (self.mid_fee * f + self.out_fee * (10**18 - f)) / 10**18
241 
242 
243 ### Math functions
244 @internal
245 @pure
246 def geometric_mean(unsorted_x: uint256[N_COINS], sort: bool) -> uint256:
247     """
248     (x[0] * x[1] * ...) ** (1/N)
249     """
250     x: uint256[N_COINS] = unsorted_x
251     if sort and x[0] < x[1]:
252         x = [unsorted_x[1], unsorted_x[0]]
253     D: uint256 = x[0]
254     diff: uint256 = 0
255     for i in range(255):
256         D_prev: uint256 = D
257         # tmp: uint256 = 10**18
258         # for _x in x:
259         #     tmp = tmp * _x / D
260         # D = D * ((N_COINS - 1) * 10**18 + tmp) / (N_COINS * 10**18)
261         # line below makes it for 2 coins
262         D = (D + x[0] * x[1] / D) / N_COINS
263         if D > D_prev:
264             diff = D - D_prev
265         else:
266             diff = D_prev - D
267         if diff <= 1 or diff * 10**18 < D:
268             return D
269     raise "Did not converge"
270 
271 
272 @internal
273 @view
274 def newton_D(ANN: uint256, gamma: uint256, x_unsorted: uint256[N_COINS]) -> uint256:
275     """
276     Finding the invariant using Newton method.
277     ANN is higher by the factor A_MULTIPLIER
278     ANN is already A * N**N
279 
280     Currently uses 60k gas
281     """
282     # Safety checks
283     assert ANN > MIN_A - 1 and ANN < MAX_A + 1  # dev: unsafe values A
284     assert gamma > MIN_GAMMA - 1 and gamma < MAX_GAMMA + 1  # dev: unsafe values gamma
285 
286     # Initial value of invariant D is that for constant-product invariant
287     x: uint256[N_COINS] = x_unsorted
288     if x[0] < x[1]:
289         x = [x_unsorted[1], x_unsorted[0]]
290 
291     assert x[0] > 10**9 - 1 and x[0] < 10**15 * 10**18 + 1  # dev: unsafe values x[0]
292     assert x[1] * 10**18 / x[0] > 10**14-1  # dev: unsafe values x[i] (input)
293 
294     D: uint256 = N_COINS * self.geometric_mean(x, False)
295     S: uint256 = x[0] + x[1]
296 
297     for i in range(255):
298         D_prev: uint256 = D
299 
300         # K0: uint256 = 10**18
301         # for _x in x:
302         #     K0 = K0 * _x * N_COINS / D
303         # collapsed for 2 coins
304         K0: uint256 = (10**18 * N_COINS**2) * x[0] / D * x[1] / D
305 
306         _g1k0: uint256 = gamma + 10**18
307         if _g1k0 > K0:
308             _g1k0 = _g1k0 - K0 + 1
309         else:
310             _g1k0 = K0 - _g1k0 + 1
311 
312         # D / (A * N**N) * _g1k0**2 / gamma**2
313         mul1: uint256 = 10**18 * D / gamma * _g1k0 / gamma * _g1k0 * A_MULTIPLIER / ANN
314 
315         # 2*N*K0 / _g1k0
316         mul2: uint256 = (2 * 10**18) * N_COINS * K0 / _g1k0
317 
318         neg_fprime: uint256 = (S + S * mul2 / 10**18) + mul1 * N_COINS / K0 - mul2 * D / 10**18
319 
320         # D -= f / fprime
321         D_plus: uint256 = D * (neg_fprime + S) / neg_fprime
322         D_minus: uint256 = D*D / neg_fprime
323         if 10**18 > K0:
324             D_minus += D * (mul1 / neg_fprime) / 10**18 * (10**18 - K0) / K0
325         else:
326             D_minus -= D * (mul1 / neg_fprime) / 10**18 * (K0 - 10**18) / K0
327 
328         if D_plus > D_minus:
329             D = D_plus - D_minus
330         else:
331             D = (D_minus - D_plus) / 2
332 
333         diff: uint256 = 0
334         if D > D_prev:
335             diff = D - D_prev
336         else:
337             diff = D_prev - D
338         if diff * 10**14 < max(10**16, D):  # Could reduce precision for gas efficiency here
339             # Test that we are safe with the next newton_y
340             for _x in x:
341                 frac: uint256 = _x * 10**18 / D
342                 assert (frac > 10**16 - 1) and (frac < 10**20 + 1)  # dev: unsafe values x[i]
343             return D
344 
345     raise "Did not converge"
346 
347 
348 @internal
349 @pure
350 def newton_y(ANN: uint256, gamma: uint256, x: uint256[N_COINS], D: uint256, i: uint256) -> uint256:
351     """
352     Calculating x[i] given other balances x[0..N_COINS-1] and invariant D
353     ANN = A * N**N
354     """
355     # Safety checks
356     assert ANN > MIN_A - 1 and ANN < MAX_A + 1  # dev: unsafe values A
357     assert gamma > MIN_GAMMA - 1 and gamma < MAX_GAMMA + 1  # dev: unsafe values gamma
358     assert D > 10**17 - 1 and D < 10**15 * 10**18 + 1 # dev: unsafe values D
359 
360     x_j: uint256 = x[1 - i]
361     y: uint256 = D**2 / (x_j * N_COINS**2)
362     K0_i: uint256 = (10**18 * N_COINS) * x_j / D
363     # S_i = x_j
364 
365     # frac = x_j * 1e18 / D => frac = K0_i / N_COINS
366     assert (K0_i > 10**16*N_COINS - 1) and (K0_i < 10**20*N_COINS + 1)  # dev: unsafe values x[i]
367 
368     # x_sorted: uint256[N_COINS] = x
369     # x_sorted[i] = 0
370     # x_sorted = self.sort(x_sorted)  # From high to low
371     # x[not i] instead of x_sorted since x_soted has only 1 element
372 
373     convergence_limit: uint256 = max(max(x_j / 10**14, D / 10**14), 100)
374 
375     for j in range(255):
376         y_prev: uint256 = y
377 
378         K0: uint256 = K0_i * y * N_COINS / D
379         S: uint256 = x_j + y
380 
381         _g1k0: uint256 = gamma + 10**18
382         if _g1k0 > K0:
383             _g1k0 = _g1k0 - K0 + 1
384         else:
385             _g1k0 = K0 - _g1k0 + 1
386 
387         # D / (A * N**N) * _g1k0**2 / gamma**2
388         mul1: uint256 = 10**18 * D / gamma * _g1k0 / gamma * _g1k0 * A_MULTIPLIER / ANN
389 
390         # 2*K0 / _g1k0
391         mul2: uint256 = 10**18 + (2 * 10**18) * K0 / _g1k0
392 
393         yfprime: uint256 = 10**18 * y + S * mul2 + mul1
394         _dyfprime: uint256 = D * mul2
395         if yfprime < _dyfprime:
396             y = y_prev / 2
397             continue
398         else:
399             yfprime -= _dyfprime
400         fprime: uint256 = yfprime / y
401 
402         # y -= f / f_prime;  y = (y * fprime - f) / fprime
403         # y = (yfprime + 10**18 * D - 10**18 * S) // fprime + mul1 // fprime * (10**18 - K0) // K0
404         y_minus: uint256 = mul1 / fprime
405         y_plus: uint256 = (yfprime + 10**18 * D) / fprime + y_minus * 10**18 / K0
406         y_minus += 10**18 * S / fprime
407 
408         if y_plus < y_minus:
409             y = y_prev / 2
410         else:
411             y = y_plus - y_minus
412 
413         diff: uint256 = 0
414         if y > y_prev:
415             diff = y - y_prev
416         else:
417             diff = y_prev - y
418         if diff < max(convergence_limit, y / 10**14):
419             frac: uint256 = y * 10**18 / D
420             assert (frac > 10**16 - 1) and (frac < 10**20 + 1)  # dev: unsafe value for y
421             return y
422 
423     raise "Did not converge"
424 
425 
426 @internal
427 @pure
428 def halfpow(power: uint256) -> uint256:
429     """
430     1e18 * 0.5 ** (power/1e18)
431 
432     Inspired by: https://github.com/balancer-labs/balancer-core/blob/master/contracts/BNum.sol#L128
433     """
434     intpow: uint256 = power / 10**18
435     otherpow: uint256 = power - intpow * 10**18
436     if intpow > 59:
437         return 0
438     result: uint256 = 10**18 / (2**intpow)
439     if otherpow == 0:
440         return result
441 
442     term: uint256 = 10**18
443     x: uint256 = 5 * 10**17
444     S: uint256 = 10**18
445     neg: bool = False
446 
447     for i in range(1, 256):
448         K: uint256 = i * 10**18
449         c: uint256 = K - 10**18
450         if otherpow > c:
451             c = otherpow - c
452             neg = not neg
453         else:
454             c -= otherpow
455         term = term * (c * x / 10**18) / K
456         if neg:
457             S -= term
458         else:
459             S += term
460         if term < EXP_PRECISION:
461             return result * S / 10**18
462 
463     raise "Did not converge"
464 ### end of Math functions
465 
466 
467 @internal
468 @view
469 def get_xcp(D: uint256) -> uint256:
470     x: uint256[N_COINS] = [D / N_COINS, D * PRECISION / (self.price_scale * N_COINS)]
471     return self.geometric_mean(x, True)
472 
473 
474 @internal
475 def _claim_admin_fees():
476     A_gamma: uint256[2] = self._A_gamma()
477 
478     xcp_profit: uint256 = self.xcp_profit
479     xcp_profit_a: uint256 = self.xcp_profit_a
480 
481     # Gulp here
482     for i in range(N_COINS):
483         coin: address = self.coins[i]
484         if coin == WETH20:
485             self.balances[i] = self.balance
486         else:
487             self.balances[i] = ERC20(coin).balanceOf(self)
488 
489     vprice: uint256 = self.virtual_price
490 
491     if xcp_profit > xcp_profit_a:
492         fees: uint256 = (xcp_profit - xcp_profit_a) * self.admin_fee / (2 * 10**10)
493         if fees > 0:
494             receiver: address = Factory(self.factory).fee_receiver()
495             if receiver != ZERO_ADDRESS:
496                 frac: uint256 = vprice * 10**18 / (vprice - fees) - 10**18
497                 claimed: uint256 = CurveToken(self.token).mint_relative(receiver, frac)
498                 xcp_profit -= fees*2
499                 self.xcp_profit = xcp_profit
500                 log ClaimAdminFee(receiver, claimed)
501 
502     total_supply: uint256 = CurveToken(self.token).totalSupply()
503 
504     # Recalculate D b/c we gulped
505     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], self.xp())
506     self.D = D
507 
508     self.virtual_price = 10**18 * self.get_xcp(D) / total_supply
509 
510     if xcp_profit > xcp_profit_a:
511         self.xcp_profit_a = xcp_profit
512 
513 
514 @internal
515 @view
516 def internal_price_oracle() -> uint256:
517     price_oracle: uint256 = self._price_oracle
518     last_prices_timestamp: uint256 = self.last_prices_timestamp
519 
520     if last_prices_timestamp < block.timestamp:
521         ma_half_time: uint256 = self.ma_half_time
522         last_prices: uint256 = self.last_prices
523         alpha: uint256 = self.halfpow((block.timestamp - last_prices_timestamp) * 10**18 / ma_half_time)
524         return (last_prices * (10**18 - alpha) + price_oracle * alpha) / 10**18
525 
526     else:
527         return price_oracle
528 
529 
530 @internal
531 def tweak_price(A_gamma: uint256[2],_xp: uint256[N_COINS], p_i: uint256, new_D: uint256):
532     price_oracle: uint256 = self._price_oracle
533     last_prices: uint256 = self.last_prices
534     price_scale: uint256 = self.price_scale
535     last_prices_timestamp: uint256 = self.last_prices_timestamp
536     p_new: uint256 = 0
537 
538     if last_prices_timestamp < block.timestamp:
539         # MA update required
540         ma_half_time: uint256 = self.ma_half_time
541         alpha: uint256 = self.halfpow((block.timestamp - last_prices_timestamp) * 10**18 / ma_half_time)
542         price_oracle = (last_prices * (10**18 - alpha) + price_oracle * alpha) / 10**18
543         self._price_oracle = price_oracle
544         self.last_prices_timestamp = block.timestamp
545 
546     D_unadjusted: uint256 = new_D  # Withdrawal methods know new D already
547     if new_D == 0:
548         # We will need this a few times (35k gas)
549         D_unadjusted = self.newton_D(A_gamma[0], A_gamma[1], _xp)
550 
551     if p_i > 0:
552         last_prices = p_i
553 
554     else:
555         # calculate real prices
556         __xp: uint256[N_COINS] = _xp
557         dx_price: uint256 = __xp[0] / 10**6
558         __xp[0] += dx_price
559         last_prices = price_scale * dx_price / (_xp[1] - self.newton_y(A_gamma[0], A_gamma[1], __xp, D_unadjusted, 1))
560 
561     self.last_prices = last_prices
562 
563     total_supply: uint256 = CurveToken(self.token).totalSupply()
564     old_xcp_profit: uint256 = self.xcp_profit
565     old_virtual_price: uint256 = self.virtual_price
566 
567     # Update profit numbers without price adjustment first
568     xp: uint256[N_COINS] = [D_unadjusted / N_COINS, D_unadjusted * PRECISION / (N_COINS * price_scale)]
569     xcp_profit: uint256 = 10**18
570     virtual_price: uint256 = 10**18
571 
572     if old_virtual_price > 0:
573         xcp: uint256 = self.geometric_mean(xp, True)
574         virtual_price = 10**18 * xcp / total_supply
575         xcp_profit = old_xcp_profit * virtual_price / old_virtual_price
576 
577         t: uint256 = self.future_A_gamma_time
578         if virtual_price < old_virtual_price and t == 0:
579             raise "Loss"
580         if t == 1:
581             self.future_A_gamma_time = 0
582 
583     self.xcp_profit = xcp_profit
584 
585     norm: uint256 = price_oracle * 10**18 / price_scale
586     if norm > 10**18:
587         norm -= 10**18
588     else:
589         norm = 10**18 - norm
590     adjustment_step: uint256 = max(self.adjustment_step, norm / 5)
591 
592     needs_adjustment: bool = self.not_adjusted
593     # if not needs_adjustment and (virtual_price-10**18 > (xcp_profit-10**18)/2 + self.allowed_extra_profit):
594     # (re-arrange for gas efficiency)
595     if not needs_adjustment and (virtual_price * 2 - 10**18 > xcp_profit + 2*self.allowed_extra_profit) and (norm > adjustment_step) and (old_virtual_price > 0):
596         needs_adjustment = True
597         self.not_adjusted = True
598 
599     if needs_adjustment:
600         if norm > adjustment_step and old_virtual_price > 0:
601             p_new = (price_scale * (norm - adjustment_step) + adjustment_step * price_oracle) / norm
602 
603             # Calculate balances*prices
604             xp = [_xp[0], _xp[1] * p_new / price_scale]
605 
606             # Calculate "extended constant product" invariant xCP and virtual price
607             D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
608             xp = [D / N_COINS, D * PRECISION / (N_COINS * p_new)]
609             # We reuse old_virtual_price here but it's not old anymore
610             old_virtual_price = 10**18 * self.geometric_mean(xp, True) / total_supply
611 
612             # Proceed if we've got enough profit
613             # if (old_virtual_price > 10**18) and (2 * (old_virtual_price - 10**18) > xcp_profit - 10**18):
614             if (old_virtual_price > 10**18) and (2 * old_virtual_price - 10**18 > xcp_profit):
615                 self.price_scale = p_new
616                 self.D = D
617                 self.virtual_price = old_virtual_price
618 
619                 return
620 
621             else:
622                 self.not_adjusted = False
623 
624                 # Can instead do another flag variable if we want to save bytespace
625                 self.D = D_unadjusted
626                 self.virtual_price = virtual_price
627                 self._claim_admin_fees()
628 
629                 return
630 
631     # If we are here, the price_scale adjustment did not happen
632     # Still need to update the profit counter and D
633     self.D = D_unadjusted
634     self.virtual_price = virtual_price
635 
636     # norm appeared < adjustment_step after
637     if needs_adjustment:
638         self.not_adjusted = False
639         self._claim_admin_fees()
640 
641 
642 @internal
643 def _exchange(sender: address, mvalue: uint256, i: uint256, j: uint256, dx: uint256, min_dy: uint256,
644               use_eth: bool, receiver: address, callbacker: address, callback_sig: bytes32) -> uint256:
645     assert i != j  # dev: coin index out of range
646     assert i < N_COINS  # dev: coin index out of range
647     assert j < N_COINS  # dev: coin index out of range
648     assert dx > 0  # dev: do not exchange 0 coins
649 
650     A_gamma: uint256[2] = self._A_gamma()
651     xp: uint256[N_COINS] = self.balances
652     p: uint256 = 0
653     dy: uint256 = 0
654 
655     in_coin: address = self.coins[i]
656     out_coin: address = self.coins[j]
657 
658     y: uint256 = xp[j]
659     x0: uint256 = xp[i]
660     xp[i] = x0 + dx
661     self.balances[i] = xp[i]
662 
663     price_scale: uint256 = self.price_scale
664     precisions: uint256[2] = self._get_precisions()
665 
666     xp = [xp[0] * precisions[0], xp[1] * price_scale * precisions[1] / PRECISION]
667 
668     prec_i: uint256 = precisions[0]
669     prec_j: uint256 = precisions[1]
670     if i == 1:
671         prec_i = precisions[1]
672         prec_j = precisions[0]
673 
674     # In case ramp is happening
675     t: uint256 = self.future_A_gamma_time
676     if t > 0:
677         x0 *= prec_i
678         if i > 0:
679             x0 = x0 * price_scale / PRECISION
680         x1: uint256 = xp[i]  # Back up old value in xp
681         xp[i] = x0
682         self.D = self.newton_D(A_gamma[0], A_gamma[1], xp)
683         xp[i] = x1  # And restore
684         if block.timestamp >= t:
685             self.future_A_gamma_time = 1
686 
687     dy = xp[j] - self.newton_y(A_gamma[0], A_gamma[1], xp, self.D, j)
688     # Not defining new "y" here to have less variables / make subsequent calls cheaper
689     xp[j] -= dy
690     dy -= 1
691 
692     if j > 0:
693         dy = dy * PRECISION / price_scale
694     dy /= prec_j
695 
696     dy -= self._fee(xp) * dy / 10**10
697     assert dy >= min_dy, "Slippage"
698     y -= dy
699 
700     self.balances[j] = y
701 
702     # Do transfers in and out together
703     # XXX coin vs ETH
704     if use_eth and in_coin == WETH20:
705         assert mvalue == dx  # dev: incorrect eth amount
706     else:
707         assert mvalue == 0  # dev: nonzero eth amount
708         if callback_sig == EMPTY_BYTES32:
709             response: Bytes[32] = raw_call(
710                 in_coin,
711                 _abi_encode(
712                     sender, self, dx, method_id=method_id("transferFrom(address,address,uint256)")
713                 ),
714                 max_outsize=32,
715             )
716             if len(response) != 0:
717                 assert convert(response, bool)  # dev: failed transfer
718         else:
719             b: uint256 = ERC20(in_coin).balanceOf(self)
720             raw_call(
721                 callbacker,
722                 concat(slice(callback_sig, 0, 4), _abi_encode(sender, receiver, in_coin, dx, dy))
723             )
724             assert ERC20(in_coin).balanceOf(self) - b == dx  # dev: callback didn't give us coins
725         if in_coin == WETH20:
726             WETH(WETH20).withdraw(dx)
727 
728     if use_eth and out_coin == WETH20:
729         raw_call(receiver, b"", value=dy)
730     else:
731         if out_coin == WETH20:
732             WETH(WETH20).deposit(value=dy)
733         response: Bytes[32] = raw_call(
734             out_coin,
735             _abi_encode(receiver, dy, method_id=method_id("transfer(address,uint256)")),
736             max_outsize=32,
737         )
738         if len(response) != 0:
739             assert convert(response, bool)
740 
741     y *= prec_j
742     if j > 0:
743         y = y * price_scale / PRECISION
744     xp[j] = y
745 
746     # Calculate price
747     if dx > 10**5 and dy > 10**5:
748         _dx: uint256 = dx * prec_i
749         _dy: uint256 = dy * prec_j
750         if i == 0:
751             p = _dx * 10**18 / _dy
752         else:  # j == 0
753             p = _dy * 10**18 / _dx
754 
755     self.tweak_price(A_gamma, xp, p, 0)
756 
757     log TokenExchange(sender, i, dx, j, dy)
758 
759     return dy
760 
761 
762 @view
763 @internal
764 def _calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
765     # fee = sum(amounts_i - avg(amounts)) * fee' / sum(amounts)
766     fee: uint256 = self._fee(xp) * N_COINS / (4 * (N_COINS-1))
767     S: uint256 = 0
768     for _x in amounts:
769         S += _x
770     avg: uint256 = S / N_COINS
771     Sdiff: uint256 = 0
772     for _x in amounts:
773         if _x > avg:
774             Sdiff += _x - avg
775         else:
776             Sdiff += avg - _x
777     return fee * Sdiff / S + NOISE_FEE
778 
779 
780 @internal
781 @view
782 def _calc_withdraw_one_coin(A_gamma: uint256[2], token_amount: uint256, i: uint256, update_D: bool,
783                             calc_price: bool) -> (uint256, uint256, uint256, uint256[N_COINS]):
784     token_supply: uint256 = CurveToken(self.token).totalSupply()
785     assert token_amount <= token_supply  # dev: token amount more than supply
786     assert i < N_COINS  # dev: coin out of range
787 
788     xx: uint256[N_COINS] = self.balances
789     D0: uint256 = 0
790     precisions: uint256[2] = self._get_precisions()
791 
792     price_scale_i: uint256 = self.price_scale * precisions[1]
793     xp: uint256[N_COINS] = [xx[0] * precisions[0], xx[1] * price_scale_i / PRECISION]
794     if i == 0:
795         price_scale_i = PRECISION * precisions[0]
796 
797     if update_D:
798         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
799     else:
800         D0 = self.D
801 
802     D: uint256 = D0
803 
804     # Charge the fee on D, not on y, e.g. reducing invariant LESS than charging the user
805     fee: uint256 = self._fee(xp)
806     dD: uint256 = token_amount * D / token_supply
807     D -= (dD - (fee * dD / (2 * 10**10) + 1))
808     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, i)
809     dy: uint256 = (xp[i] - y) * PRECISION / price_scale_i
810     xp[i] = y
811 
812     # Price calc
813     p: uint256 = 0
814     if calc_price and dy > 10**5 and token_amount > 10**5:
815         # p_i = dD / D0 * sum'(p_k * x_k) / (dy - dD / D0 * y0)
816         S: uint256 = 0
817         precision: uint256 = precisions[0]
818         if i == 1:
819             S = xx[0] * precisions[0]
820             precision = precisions[1]
821         else:
822             S = xx[1] * precisions[1]
823         S = S * dD / D0
824         p = S * PRECISION / (dy * precision - dD * xx[i] * precision / D0)
825         if i == 0:
826             p = (10**18)**2 / p
827 
828     return dy, p, D, xp
829 
830 
831 @internal
832 @pure
833 def sqrt_int(x: uint256) -> uint256:
834     """
835     Originating from: https://github.com/vyperlang/vyper/issues/1266
836     """
837 
838     if x == 0:
839         return 0
840 
841     z: uint256 = (x + 10**18) / 2
842     y: uint256 = x
843 
844     for i in range(256):
845         if z == y:
846             return y
847         y = z
848         z = (x * 10**18 / z + z) / 2
849 
850     raise "Did not converge"
851 
852 
853 # External Functions
854 
855 
856 @payable
857 @external
858 @nonreentrant('lock')
859 def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256,
860              use_eth: bool = False, receiver: address = msg.sender) -> uint256:
861     """
862     Exchange using WETH by default
863     """
864     return self._exchange(msg.sender, msg.value, i, j, dx, min_dy, use_eth, receiver, ZERO_ADDRESS, EMPTY_BYTES32)
865 
866 
867 @payable
868 @external
869 @nonreentrant('lock')
870 def exchange_underlying(i: uint256, j: uint256, dx: uint256, min_dy: uint256,
871                         receiver: address = msg.sender) -> uint256:
872     """
873     Exchange using ETH
874     """
875     return self._exchange(msg.sender, msg.value, i, j, dx, min_dy, True, receiver, ZERO_ADDRESS, EMPTY_BYTES32)
876 
877 
878 @payable
879 @external
880 @nonreentrant('lock')
881 def exchange_extended(i: uint256, j: uint256, dx: uint256, min_dy: uint256,
882                       use_eth: bool, sender: address, receiver: address, cb: bytes32) -> uint256:
883     assert cb != EMPTY_BYTES32  # dev: No callback specified
884     return self._exchange(sender, msg.value, i, j, dx, min_dy, use_eth, receiver, msg.sender, cb)
885 
886 
887 @payable
888 @external
889 @nonreentrant('lock')
890 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256,
891                   use_eth: bool = False, receiver: address = msg.sender) -> uint256:
892     assert amounts[0] > 0 or amounts[1] > 0  # dev: no coins to add
893 
894     A_gamma: uint256[2] = self._A_gamma()
895 
896     xp: uint256[N_COINS] = self.balances
897     amountsp: uint256[N_COINS] = empty(uint256[N_COINS])
898     xx: uint256[N_COINS] = empty(uint256[N_COINS])
899     d_token: uint256 = 0
900     d_token_fee: uint256 = 0
901     old_D: uint256 = 0
902 
903     xp_old: uint256[N_COINS] = xp
904 
905     for i in range(N_COINS):
906         bal: uint256 = xp[i] + amounts[i]
907         xp[i] = bal
908         self.balances[i] = bal
909     xx = xp
910 
911     precisions: uint256[2] = self._get_precisions()
912 
913     price_scale: uint256 = self.price_scale * precisions[1]
914     xp = [xp[0] * precisions[0], xp[1] * price_scale / PRECISION]
915     xp_old = [xp_old[0] * precisions[0], xp_old[1] * price_scale / PRECISION]
916 
917     if not use_eth:
918         assert msg.value == 0  # dev: nonzero eth amount
919 
920     for i in range(N_COINS):
921         coin: address = self.coins[i]
922         if use_eth and coin == WETH20:
923             assert msg.value == amounts[i]  # dev: incorrect eth amount
924         if amounts[i] > 0:
925             if (not use_eth) or (coin != WETH20):
926                 response: Bytes[32] = raw_call(
927                     coin,
928                     _abi_encode(
929                         msg.sender,
930                         self,
931                         amounts[i],
932                         method_id=method_id("transferFrom(address,address,uint256)"),
933                     ),
934                     max_outsize=32,
935                 )
936                 if len(response) != 0:
937                     assert convert(response, bool)  # dev: failed transfer
938                 if coin == WETH20:
939                     WETH(WETH20).withdraw(amounts[i])
940             amountsp[i] = xp[i] - xp_old[i]
941 
942     t: uint256 = self.future_A_gamma_time
943     if t > 0:
944         old_D = self.newton_D(A_gamma[0], A_gamma[1], xp_old)
945         if block.timestamp >= t:
946             self.future_A_gamma_time = 1
947     else:
948         old_D = self.D
949 
950     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
951 
952     lp_token: address = self.token
953     token_supply: uint256 = CurveToken(lp_token).totalSupply()
954     if old_D > 0:
955         d_token = token_supply * D / old_D - token_supply
956     else:
957         d_token = self.get_xcp(D)  # making initial virtual price equal to 1
958     assert d_token > 0  # dev: nothing minted
959 
960     if old_D > 0:
961         d_token_fee = self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
962         d_token -= d_token_fee
963         token_supply += d_token
964         CurveToken(lp_token).mint(receiver, d_token)
965 
966         # Calculate price
967         # p_i * (dx_i - dtoken / token_supply * xx_i) = sum{k!=i}(p_k * (dtoken / token_supply * xx_k - dx_k))
968         # Simplified for 2 coins
969         p: uint256 = 0
970         if d_token > 10**5:
971             if amounts[0] == 0 or amounts[1] == 0:
972                 S: uint256 = 0
973                 precision: uint256 = 0
974                 ix: uint256 = 0
975                 if amounts[0] == 0:
976                     S = xx[0] * precisions[0]
977                     precision = precisions[1]
978                     ix = 1
979                 else:
980                     S = xx[1] * precisions[1]
981                     precision = precisions[0]
982                 S = S * d_token / token_supply
983                 p = S * PRECISION / (amounts[ix] * precision - d_token * xx[ix] * precision / token_supply)
984                 if ix == 0:
985                     p = (10**18)**2 / p
986 
987         self.tweak_price(A_gamma, xp, p, D)
988 
989     else:
990         self.D = D
991         self.virtual_price = 10**18
992         self.xcp_profit = 10**18
993         CurveToken(lp_token).mint(receiver, d_token)
994 
995     assert d_token >= min_mint_amount, "Slippage"
996 
997     log AddLiquidity(receiver, amounts, d_token_fee, token_supply)
998 
999     return d_token
1000 
1001 
1002 @external
1003 @nonreentrant('lock')
1004 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS],
1005                      use_eth: bool = False, receiver: address = msg.sender):
1006     """
1007     This withdrawal method is very safe, does no complex math
1008     """
1009     lp_token: address = self.token
1010     total_supply: uint256 = CurveToken(lp_token).totalSupply()
1011     CurveToken(lp_token).burnFrom(msg.sender, _amount)
1012     balances: uint256[N_COINS] = self.balances
1013     amount: uint256 = _amount - 1  # Make rounding errors favoring other LPs a tiny bit
1014 
1015     for i in range(N_COINS):
1016         d_balance: uint256 = balances[i] * amount / total_supply
1017         assert d_balance >= min_amounts[i]
1018         self.balances[i] = balances[i] - d_balance
1019         balances[i] = d_balance  # now it's the amounts going out
1020         coin: address = self.coins[i]
1021         if use_eth and coin == WETH20:
1022             raw_call(receiver, b"", value=d_balance)
1023         else:
1024             if coin == WETH20:
1025                 WETH(WETH20).deposit(value=d_balance)
1026             response: Bytes[32] = raw_call(
1027                 coin,
1028                 _abi_encode(receiver, d_balance, method_id=method_id("transfer(address,uint256)")),
1029                 max_outsize=32,
1030             )
1031             if len(response) != 0:
1032                 assert convert(response, bool)
1033 
1034     D: uint256 = self.D
1035     self.D = D - D * amount / total_supply
1036 
1037     log RemoveLiquidity(msg.sender, balances, total_supply - _amount)
1038 
1039 
1040 @external
1041 @nonreentrant('lock')
1042 def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256,
1043                               use_eth: bool = False, receiver: address = msg.sender) -> uint256:
1044     A_gamma: uint256[2] = self._A_gamma()
1045 
1046     dy: uint256 = 0
1047     D: uint256 = 0
1048     p: uint256 = 0
1049     xp: uint256[N_COINS] = empty(uint256[N_COINS])
1050     future_A_gamma_time: uint256 = self.future_A_gamma_time
1051     dy, p, D, xp = self._calc_withdraw_one_coin(A_gamma, token_amount, i, (future_A_gamma_time > 0), True)
1052     assert dy >= min_amount, "Slippage"
1053 
1054     if block.timestamp >= future_A_gamma_time:
1055         self.future_A_gamma_time = 1
1056 
1057     self.balances[i] -= dy
1058     CurveToken(self.token).burnFrom(msg.sender, token_amount)
1059 
1060     coin: address = self.coins[i]
1061     if use_eth and coin == WETH20:
1062         raw_call(receiver, b"", value=dy)
1063     else:
1064         if coin == WETH20:
1065             WETH(WETH20).deposit(value=dy)
1066         response: Bytes[32] = raw_call(
1067             coin,
1068             _abi_encode(receiver, dy, method_id=method_id("transfer(address,uint256)")),
1069             max_outsize=32,
1070         )
1071         if len(response) != 0:
1072             assert convert(response, bool)
1073 
1074     self.tweak_price(A_gamma, xp, p, D)
1075 
1076     log RemoveLiquidityOne(msg.sender, token_amount, i, dy)
1077 
1078     return dy
1079 
1080 
1081 @external
1082 @nonreentrant('lock')
1083 def claim_admin_fees():
1084     self._claim_admin_fees()
1085 
1086 
1087 # Admin parameters
1088 @external
1089 def ramp_A_gamma(future_A: uint256, future_gamma: uint256, future_time: uint256):
1090     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1091     assert block.timestamp > self.initial_A_gamma_time + (MIN_RAMP_TIME-1)
1092     assert future_time > block.timestamp + (MIN_RAMP_TIME-1)  # dev: insufficient time
1093 
1094     A_gamma: uint256[2] = self._A_gamma()
1095     initial_A_gamma: uint256 = shift(A_gamma[0], 128)
1096     initial_A_gamma = bitwise_or(initial_A_gamma, A_gamma[1])
1097 
1098     assert future_A > MIN_A-1
1099     assert future_A < MAX_A+1
1100     assert future_gamma > MIN_GAMMA-1
1101     assert future_gamma < MAX_GAMMA+1
1102 
1103     ratio: uint256 = 10**18 * future_A / A_gamma[0]
1104     assert ratio < 10**18 * MAX_A_CHANGE + 1
1105     assert ratio > 10**18 / MAX_A_CHANGE - 1
1106 
1107     ratio = 10**18 * future_gamma / A_gamma[1]
1108     assert ratio < 10**18 * MAX_A_CHANGE + 1
1109     assert ratio > 10**18 / MAX_A_CHANGE - 1
1110 
1111     self.initial_A_gamma = initial_A_gamma
1112     self.initial_A_gamma_time = block.timestamp
1113 
1114     future_A_gamma: uint256 = shift(future_A, 128)
1115     future_A_gamma = bitwise_or(future_A_gamma, future_gamma)
1116     self.future_A_gamma_time = future_time
1117     self.future_A_gamma = future_A_gamma
1118 
1119     log RampAgamma(A_gamma[0], future_A, A_gamma[1], future_gamma, block.timestamp, future_time)
1120 
1121 
1122 @external
1123 def stop_ramp_A_gamma():
1124     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1125 
1126     A_gamma: uint256[2] = self._A_gamma()
1127     current_A_gamma: uint256 = shift(A_gamma[0], 128)
1128     current_A_gamma = bitwise_or(current_A_gamma, A_gamma[1])
1129     self.initial_A_gamma = current_A_gamma
1130     self.future_A_gamma = current_A_gamma
1131     self.initial_A_gamma_time = block.timestamp
1132     self.future_A_gamma_time = block.timestamp
1133     # now (block.timestamp < t1) is always False, so we return saved A
1134 
1135     log StopRampA(A_gamma[0], A_gamma[1], block.timestamp)
1136 
1137 
1138 @external
1139 def commit_new_parameters(
1140     _new_mid_fee: uint256,
1141     _new_out_fee: uint256,
1142     _new_admin_fee: uint256,
1143     _new_fee_gamma: uint256,
1144     _new_allowed_extra_profit: uint256,
1145     _new_adjustment_step: uint256,
1146     _new_ma_half_time: uint256,
1147     ):
1148     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1149     assert self.admin_actions_deadline == 0  # dev: active action
1150 
1151     new_mid_fee: uint256 = _new_mid_fee
1152     new_out_fee: uint256 = _new_out_fee
1153     new_admin_fee: uint256 = _new_admin_fee
1154     new_fee_gamma: uint256 = _new_fee_gamma
1155     new_allowed_extra_profit: uint256 = _new_allowed_extra_profit
1156     new_adjustment_step: uint256 = _new_adjustment_step
1157     new_ma_half_time: uint256 = _new_ma_half_time
1158 
1159     # Fees
1160     if new_out_fee < MAX_FEE+1:
1161         assert new_out_fee > MIN_FEE-1  # dev: fee is out of range
1162     else:
1163         new_out_fee = self.out_fee
1164     if new_mid_fee > MAX_FEE:
1165         new_mid_fee = self.mid_fee
1166     assert new_mid_fee <= new_out_fee  # dev: mid-fee is too high
1167     if new_admin_fee > MAX_ADMIN_FEE:
1168         new_admin_fee = self.admin_fee
1169 
1170     # AMM parameters
1171     if new_fee_gamma < 10**18:
1172         assert new_fee_gamma > 0  # dev: fee_gamma out of range [1 .. 10**18]
1173     else:
1174         new_fee_gamma = self.fee_gamma
1175     if new_allowed_extra_profit > 10**18:
1176         new_allowed_extra_profit = self.allowed_extra_profit
1177     if new_adjustment_step > 10**18:
1178         new_adjustment_step = self.adjustment_step
1179 
1180     # MA
1181     if new_ma_half_time < 7*86400:
1182         assert new_ma_half_time > 0  # dev: MA time should be longer than 1 second
1183     else:
1184         new_ma_half_time = self.ma_half_time
1185 
1186     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1187     self.admin_actions_deadline = _deadline
1188 
1189     self.future_admin_fee = new_admin_fee
1190     self.future_mid_fee = new_mid_fee
1191     self.future_out_fee = new_out_fee
1192     self.future_fee_gamma = new_fee_gamma
1193     self.future_allowed_extra_profit = new_allowed_extra_profit
1194     self.future_adjustment_step = new_adjustment_step
1195     self.future_ma_half_time = new_ma_half_time
1196 
1197     log CommitNewParameters(_deadline, new_admin_fee, new_mid_fee, new_out_fee,
1198                             new_fee_gamma,
1199                             new_allowed_extra_profit, new_adjustment_step,
1200                             new_ma_half_time)
1201 
1202 
1203 @external
1204 @nonreentrant('lock')
1205 def apply_new_parameters():
1206     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1207     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
1208     assert self.admin_actions_deadline != 0  # dev: no active action
1209 
1210     self.admin_actions_deadline = 0
1211 
1212     admin_fee: uint256 = self.future_admin_fee
1213     if self.admin_fee != admin_fee:
1214         self._claim_admin_fees()
1215         self.admin_fee = admin_fee
1216 
1217     mid_fee: uint256 = self.future_mid_fee
1218     self.mid_fee = mid_fee
1219     out_fee: uint256 = self.future_out_fee
1220     self.out_fee = out_fee
1221     fee_gamma: uint256 = self.future_fee_gamma
1222     self.fee_gamma = fee_gamma
1223     allowed_extra_profit: uint256 = self.future_allowed_extra_profit
1224     self.allowed_extra_profit = allowed_extra_profit
1225     adjustment_step: uint256 = self.future_adjustment_step
1226     self.adjustment_step = adjustment_step
1227     ma_half_time: uint256 = self.future_ma_half_time
1228     self.ma_half_time = ma_half_time
1229 
1230     log NewParameters(admin_fee, mid_fee, out_fee,
1231                       fee_gamma,
1232                       allowed_extra_profit, adjustment_step,
1233                       ma_half_time)
1234 
1235 
1236 @external
1237 def revert_new_parameters():
1238     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1239 
1240     self.admin_actions_deadline = 0
1241 
1242 
1243 # View Methods
1244 
1245 
1246 @external
1247 @view
1248 def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256:
1249     assert i != j  # dev: same input and output coin
1250     assert i < N_COINS  # dev: coin index out of range
1251     assert j < N_COINS  # dev: coin index out of range
1252 
1253     precisions: uint256[2] = self._get_precisions()
1254 
1255     price_scale: uint256 = self.price_scale * precisions[1]
1256     xp: uint256[N_COINS] = self.balances
1257 
1258     A_gamma: uint256[2] = self._A_gamma()
1259     D: uint256 = self.D
1260     if self.future_A_gamma_time > 0:
1261         D = self.newton_D(A_gamma[0], A_gamma[1], self.xp())
1262 
1263     xp[i] += dx
1264     xp = [xp[0] * precisions[0], xp[1] * price_scale / PRECISION]
1265 
1266     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, j)
1267     dy: uint256 = xp[j] - y - 1
1268     xp[j] = y
1269     if j > 0:
1270         dy = dy * PRECISION / price_scale
1271     else:
1272         dy /= precisions[0]
1273     dy -= self._fee(xp) * dy / 10**10
1274 
1275     return dy
1276 
1277 
1278 @view
1279 @external
1280 def calc_token_amount(amounts: uint256[N_COINS]) -> uint256:
1281     token_supply: uint256 = CurveToken(self.token).totalSupply()
1282     precisions: uint256[2] = self._get_precisions()
1283     price_scale: uint256 = self.price_scale * precisions[1]
1284     A_gamma: uint256[2] = self._A_gamma()
1285     xp: uint256[N_COINS] = self.xp()
1286     amountsp: uint256[N_COINS] = [
1287         amounts[0] * precisions[0],
1288         amounts[1] * price_scale / PRECISION]
1289     D0: uint256 = self.D
1290     if self.future_A_gamma_time > 0:
1291         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1292     xp[0] += amountsp[0]
1293     xp[1] += amountsp[1]
1294     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1295     d_token: uint256 = token_supply * D / D0 - token_supply
1296     d_token -= self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
1297     return d_token
1298 
1299 
1300 @view
1301 @external
1302 def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256:
1303     return self._calc_withdraw_one_coin(self._A_gamma(), token_amount, i, True, False)[0]
1304 
1305 
1306 @external
1307 @view
1308 def lp_price() -> uint256:
1309     """
1310     Approximate LP token price
1311     """
1312     return 2 * self.virtual_price * self.sqrt_int(self.internal_price_oracle()) / 10**18
1313 
1314 
1315 @view
1316 @external
1317 def A() -> uint256:
1318     return self._A_gamma()[0]
1319 
1320 
1321 @view
1322 @external
1323 def gamma() -> uint256:
1324     return self._A_gamma()[1]
1325 
1326 
1327 @external
1328 @view
1329 def fee() -> uint256:
1330     return self._fee(self.xp())
1331 
1332 
1333 @external
1334 @view
1335 def get_virtual_price() -> uint256:
1336     return 10**18 * self.get_xcp(self.D) / CurveToken(self.token).totalSupply()
1337 
1338 
1339 @external
1340 @view
1341 def price_oracle() -> uint256:
1342     return self.internal_price_oracle()
1343 
1344 
1345 # Initializer
1346 
1347 
1348 @external
1349 def initialize(
1350     A: uint256,
1351     gamma: uint256,
1352     mid_fee: uint256,
1353     out_fee: uint256,
1354     allowed_extra_profit: uint256,
1355     fee_gamma: uint256,
1356     adjustment_step: uint256,
1357     admin_fee: uint256,
1358     ma_half_time: uint256,
1359     initial_price: uint256,
1360     _token: address,
1361     _coins: address[N_COINS],
1362     _precisions: uint256,
1363 ):
1364     assert self.mid_fee == 0  # dev: check that we call it from factory
1365 
1366     self.factory = msg.sender
1367 
1368     # Pack A and gamma:
1369     # shifted A + gamma
1370     A_gamma: uint256 = shift(A, 128)
1371     A_gamma = bitwise_or(A_gamma, gamma)
1372     self.initial_A_gamma = A_gamma
1373     self.future_A_gamma = A_gamma
1374 
1375     self.mid_fee = mid_fee
1376     self.out_fee = out_fee
1377     self.allowed_extra_profit = allowed_extra_profit
1378     self.fee_gamma = fee_gamma
1379     self.adjustment_step = adjustment_step
1380     self.admin_fee = admin_fee
1381 
1382     self.price_scale = initial_price
1383     self._price_oracle = initial_price
1384     self.last_prices = initial_price
1385     self.last_prices_timestamp = block.timestamp
1386     self.ma_half_time = ma_half_time
1387 
1388     self.xcp_profit_a = 10**18
1389 
1390     self.token = _token
1391     self.coins = _coins
1392     self.PRECISIONS = _precisions