1 # @version 0.3.0
2 # (c) Curve.Fi, 2021
3 # Pool for two crypto assets
4 
5 from vyper.interfaces import ERC20
6 # Expected coins:
7 # eth/whatever
8 
9 interface CurveToken:
10     def totalSupply() -> uint256: view
11     def mint(_to: address, _value: uint256) -> bool: nonpayable
12     def mint_relative(_to: address, frac: uint256) -> uint256: nonpayable
13     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
14 
15 
16 interface WETH:
17     def deposit(): payable
18     def withdraw(_amount: uint256): nonpayable
19 
20 
21 # Events
22 event TokenExchange:
23     buyer: indexed(address)
24     sold_id: uint256
25     tokens_sold: uint256
26     bought_id: uint256
27     tokens_bought: uint256
28 
29 event AddLiquidity:
30     provider: indexed(address)
31     token_amounts: uint256[N_COINS]
32     fee: uint256
33     token_supply: uint256
34 
35 event RemoveLiquidity:
36     provider: indexed(address)
37     token_amounts: uint256[N_COINS]
38     token_supply: uint256
39 
40 event RemoveLiquidityOne:
41     provider: indexed(address)
42     token_amount: uint256
43     coin_index: uint256
44     coin_amount: uint256
45 
46 event CommitNewAdmin:
47     deadline: indexed(uint256)
48     admin: indexed(address)
49 
50 event NewAdmin:
51     admin: indexed(address)
52 
53 event CommitNewParameters:
54     deadline: indexed(uint256)
55     admin_fee: uint256
56     mid_fee: uint256
57     out_fee: uint256
58     fee_gamma: uint256
59     allowed_extra_profit: uint256
60     adjustment_step: uint256
61     ma_half_time: uint256
62 
63 event NewParameters:
64     admin_fee: uint256
65     mid_fee: uint256
66     out_fee: uint256
67     fee_gamma: uint256
68     allowed_extra_profit: uint256
69     adjustment_step: uint256
70     ma_half_time: uint256
71 
72 event RampAgamma:
73     initial_A: uint256
74     future_A: uint256
75     initial_gamma: uint256
76     future_gamma: uint256
77     initial_time: uint256
78     future_time: uint256
79 
80 event StopRampA:
81     current_A: uint256
82     current_gamma: uint256
83     time: uint256
84 
85 event ClaimAdminFee:
86     admin: indexed(address)
87     tokens: uint256
88 
89 
90 N_COINS: constant(int128) = 2
91 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
92 A_MULTIPLIER: constant(uint256) = 10000
93 
94 # These addresses are replaced by the deployer
95 token: constant(address) = 0xEd4064f376cB8d68F770FB1Ff088a3d0F3FF5c4d
96 coins: constant(address[N_COINS]) = [
97     0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
98     0xD533a949740bb3306d119CC777fa900bA034cd52]
99 
100 price_scale: public(uint256)   # Internal price scale
101 price_oracle: public(uint256)  # Price target given by MA
102 
103 last_prices: public(uint256)
104 last_prices_timestamp: public(uint256)
105 
106 initial_A_gamma: public(uint256)
107 future_A_gamma: public(uint256)
108 initial_A_gamma_time: public(uint256)
109 future_A_gamma_time: public(uint256)
110 
111 allowed_extra_profit: public(uint256)  # 2 * 10**12 - recommended value
112 future_allowed_extra_profit: public(uint256)
113 
114 fee_gamma: public(uint256)
115 future_fee_gamma: public(uint256)
116 
117 adjustment_step: public(uint256)
118 future_adjustment_step: public(uint256)
119 
120 ma_half_time: public(uint256)
121 future_ma_half_time: public(uint256)
122 
123 mid_fee: public(uint256)
124 out_fee: public(uint256)
125 admin_fee: public(uint256)
126 future_mid_fee: public(uint256)
127 future_out_fee: public(uint256)
128 future_admin_fee: public(uint256)
129 
130 balances: public(uint256[N_COINS])
131 D: public(uint256)
132 
133 owner: public(address)
134 future_owner: public(address)
135 
136 xcp_profit: public(uint256)
137 xcp_profit_a: public(uint256)  # Full profit at last claim of admin fees
138 virtual_price: public(uint256)  # Cached (fast to read) virtual price also used internally
139 not_adjusted: bool
140 
141 is_killed: public(bool)
142 kill_deadline: public(uint256)
143 transfer_ownership_deadline: public(uint256)
144 admin_actions_deadline: public(uint256)
145 
146 admin_fee_receiver: public(address)
147 
148 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
149 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
150 MIN_RAMP_TIME: constant(uint256) = 86400
151 
152 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
153 MIN_FEE: constant(uint256) = 5 * 10 ** 5  # 0.5 bps
154 MAX_FEE: constant(uint256) = 10 * 10 ** 9
155 MAX_A_CHANGE: constant(uint256) = 10
156 NOISE_FEE: constant(uint256) = 10**5  # 0.1 bps
157 
158 MIN_GAMMA: constant(uint256) = 10**10
159 MAX_GAMMA: constant(uint256) = 2 * 10**16
160 
161 MIN_A: constant(uint256) = N_COINS**N_COINS * A_MULTIPLIER / 10
162 MAX_A: constant(uint256) = N_COINS**N_COINS * A_MULTIPLIER * 100000
163 
164 # This must be changed for different N_COINS
165 # For example:
166 # N_COINS = 3 -> 1  (10**18 -> 10**18)
167 # N_COINS = 4 -> 10**8  (10**18 -> 10**10)
168 # PRICE_PRECISION_MUL: constant(uint256) = 1
169 PRECISIONS: constant(uint256[N_COINS]) = [
170     1,
171     1,
172 ]
173 
174 EXP_PRECISION: constant(uint256) = 10**10
175 
176 ETH_INDEX: constant(uint256) = 0  # Can put it to something big to turn the logic off
177 
178 
179 @external
180 def __init__(
181     owner: address,
182     admin_fee_receiver: address,
183     A: uint256,
184     gamma: uint256,
185     mid_fee: uint256,
186     out_fee: uint256,
187     allowed_extra_profit: uint256,
188     fee_gamma: uint256,
189     adjustment_step: uint256,
190     admin_fee: uint256,
191     ma_half_time: uint256,
192     initial_price: uint256
193 ):
194     self.owner = owner
195 
196     # Pack A and gamma:
197     # shifted A + gamma
198     A_gamma: uint256 = shift(A, 128)
199     A_gamma = bitwise_or(A_gamma, gamma)
200     self.initial_A_gamma = A_gamma
201     self.future_A_gamma = A_gamma
202 
203     self.mid_fee = mid_fee
204     self.out_fee = out_fee
205     self.allowed_extra_profit = allowed_extra_profit
206     self.fee_gamma = fee_gamma
207     self.adjustment_step = adjustment_step
208     self.admin_fee = admin_fee
209 
210     self.price_scale = initial_price
211     self.price_oracle = initial_price
212     self.last_prices = initial_price
213     self.last_prices_timestamp = block.timestamp
214     self.ma_half_time = ma_half_time
215 
216     self.xcp_profit_a = 10**18
217 
218     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
219 
220     self.admin_fee_receiver = admin_fee_receiver
221 
222 
223 @payable
224 @external
225 def __default__():
226     pass
227 
228 
229 ### Math functions
230 @internal
231 @pure
232 def geometric_mean(unsorted_x: uint256[N_COINS], sort: bool) -> uint256:
233     """
234     (x[0] * x[1] * ...) ** (1/N)
235     """
236     x: uint256[N_COINS] = unsorted_x
237     if sort and x[0] < x[1]:
238         x = [unsorted_x[1], unsorted_x[0]]
239     D: uint256 = x[0]
240     diff: uint256 = 0
241     for i in range(255):
242         D_prev: uint256 = D
243         # tmp: uint256 = 10**18
244         # for _x in x:
245         #     tmp = tmp * _x / D
246         # D = D * ((N_COINS - 1) * 10**18 + tmp) / (N_COINS * 10**18)
247         # line below makes it for 2 coins
248         D = (D + x[0] * x[1] / D) / N_COINS
249         if D > D_prev:
250             diff = D - D_prev
251         else:
252             diff = D_prev - D
253         if diff <= 1 or diff * 10**18 < D:
254             return D
255     raise "Did not converge"
256 
257 
258 @internal
259 @view
260 def newton_D(ANN: uint256, gamma: uint256, x_unsorted: uint256[N_COINS]) -> uint256:
261     """
262     Finding the invariant using Newton method.
263     ANN is higher by the factor A_MULTIPLIER
264     ANN is already A * N**N
265 
266     Currently uses 60k gas
267     """
268     # Safety checks
269     assert ANN > MIN_A - 1 and ANN < MAX_A + 1  # dev: unsafe values A
270     assert gamma > MIN_GAMMA - 1 and gamma < MAX_GAMMA + 1  # dev: unsafe values gamma
271 
272     # Initial value of invariant D is that for constant-product invariant
273     x: uint256[N_COINS] = x_unsorted
274     if x[0] < x[1]:
275         x = [x_unsorted[1], x_unsorted[0]]
276 
277     assert x[0] > 10**9 - 1 and x[0] < 10**15 * 10**18 + 1  # dev: unsafe values x[0]
278     assert x[1] * 10**18 / x[0] > 10**14-1  # dev: unsafe values x[i] (input)
279 
280     D: uint256 = N_COINS * self.geometric_mean(x, False)
281     S: uint256 = x[0] + x[1]
282 
283     for i in range(255):
284         D_prev: uint256 = D
285 
286         # K0: uint256 = 10**18
287         # for _x in x:
288         #     K0 = K0 * _x * N_COINS / D
289         # collapsed for 2 coins
290         K0: uint256 = (10**18 * N_COINS**2) * x[0] / D * x[1] / D
291 
292         _g1k0: uint256 = gamma + 10**18
293         if _g1k0 > K0:
294             _g1k0 = _g1k0 - K0 + 1
295         else:
296             _g1k0 = K0 - _g1k0 + 1
297 
298         # D / (A * N**N) * _g1k0**2 / gamma**2
299         mul1: uint256 = 10**18 * D / gamma * _g1k0 / gamma * _g1k0 * A_MULTIPLIER / ANN
300 
301         # 2*N*K0 / _g1k0
302         mul2: uint256 = (2 * 10**18) * N_COINS * K0 / _g1k0
303 
304         neg_fprime: uint256 = (S + S * mul2 / 10**18) + mul1 * N_COINS / K0 - mul2 * D / 10**18
305 
306         # D -= f / fprime
307         D_plus: uint256 = D * (neg_fprime + S) / neg_fprime
308         D_minus: uint256 = D*D / neg_fprime
309         if 10**18 > K0:
310             D_minus += D * (mul1 / neg_fprime) / 10**18 * (10**18 - K0) / K0
311         else:
312             D_minus -= D * (mul1 / neg_fprime) / 10**18 * (K0 - 10**18) / K0
313 
314         if D_plus > D_minus:
315             D = D_plus - D_minus
316         else:
317             D = (D_minus - D_plus) / 2
318 
319         diff: uint256 = 0
320         if D > D_prev:
321             diff = D - D_prev
322         else:
323             diff = D_prev - D
324         if diff * 10**14 < max(10**16, D):  # Could reduce precision for gas efficiency here
325             # Test that we are safe with the next newton_y
326             for _x in x:
327                 frac: uint256 = _x * 10**18 / D
328                 assert (frac > 10**16 - 1) and (frac < 10**20 + 1)  # dev: unsafe values x[i]
329             return D
330 
331     raise "Did not converge"
332 
333 
334 @internal
335 @pure
336 def newton_y(ANN: uint256, gamma: uint256, x: uint256[N_COINS], D: uint256, i: uint256) -> uint256:
337     """
338     Calculating x[i] given other balances x[0..N_COINS-1] and invariant D
339     ANN = A * N**N
340     """
341     # Safety checks
342     assert ANN > MIN_A - 1 and ANN < MAX_A + 1  # dev: unsafe values A
343     assert gamma > MIN_GAMMA - 1 and gamma < MAX_GAMMA + 1  # dev: unsafe values gamma
344     assert D > 10**17 - 1 and D < 10**15 * 10**18 + 1 # dev: unsafe values D
345 
346     x_j: uint256 = x[1 - i]
347     y: uint256 = D**2 / (x_j * N_COINS**2)
348     K0_i: uint256 = (10**18 * N_COINS) * x_j / D
349     # S_i = x_j
350 
351     # frac = x_j * 1e18 / D => frac = K0_i / N_COINS
352     assert (K0_i > 10**16*N_COINS - 1) and (K0_i < 10**20*N_COINS + 1)  # dev: unsafe values x[i]
353 
354     # x_sorted: uint256[N_COINS] = x
355     # x_sorted[i] = 0
356     # x_sorted = self.sort(x_sorted)  # From high to low
357     # x[not i] instead of x_sorted since x_soted has only 1 element
358 
359     convergence_limit: uint256 = max(max(x_j / 10**14, D / 10**14), 100)
360 
361     for j in range(255):
362         y_prev: uint256 = y
363 
364         K0: uint256 = K0_i * y * N_COINS / D
365         S: uint256 = x_j + y
366 
367         _g1k0: uint256 = gamma + 10**18
368         if _g1k0 > K0:
369             _g1k0 = _g1k0 - K0 + 1
370         else:
371             _g1k0 = K0 - _g1k0 + 1
372 
373         # D / (A * N**N) * _g1k0**2 / gamma**2
374         mul1: uint256 = 10**18 * D / gamma * _g1k0 / gamma * _g1k0 * A_MULTIPLIER / ANN
375 
376         # 2*K0 / _g1k0
377         mul2: uint256 = 10**18 + (2 * 10**18) * K0 / _g1k0
378 
379         yfprime: uint256 = 10**18 * y + S * mul2 + mul1
380         _dyfprime: uint256 = D * mul2
381         if yfprime < _dyfprime:
382             y = y_prev / 2
383             continue
384         else:
385             yfprime -= _dyfprime
386         fprime: uint256 = yfprime / y
387 
388         # y -= f / f_prime;  y = (y * fprime - f) / fprime
389         # y = (yfprime + 10**18 * D - 10**18 * S) // fprime + mul1 // fprime * (10**18 - K0) // K0
390         y_minus: uint256 = mul1 / fprime
391         y_plus: uint256 = (yfprime + 10**18 * D) / fprime + y_minus * 10**18 / K0
392         y_minus += 10**18 * S / fprime
393 
394         if y_plus < y_minus:
395             y = y_prev / 2
396         else:
397             y = y_plus - y_minus
398 
399         diff: uint256 = 0
400         if y > y_prev:
401             diff = y - y_prev
402         else:
403             diff = y_prev - y
404         if diff < max(convergence_limit, y / 10**14):
405             frac: uint256 = y * 10**18 / D
406             assert (frac > 10**16 - 1) and (frac < 10**20 + 1)  # dev: unsafe value for y
407             return y
408 
409     raise "Did not converge"
410 
411 
412 @internal
413 @pure
414 def halfpow(power: uint256) -> uint256:
415     """
416     1e18 * 0.5 ** (power/1e18)
417 
418     Inspired by: https://github.com/balancer-labs/balancer-core/blob/master/contracts/BNum.sol#L128
419     """
420     intpow: uint256 = power / 10**18
421     otherpow: uint256 = power - intpow * 10**18
422     if intpow > 59:
423         return 0
424     result: uint256 = 10**18 / (2**intpow)
425     if otherpow == 0:
426         return result
427 
428     term: uint256 = 10**18
429     x: uint256 = 5 * 10**17
430     S: uint256 = 10**18
431     neg: bool = False
432 
433     for i in range(1, 256):
434         K: uint256 = i * 10**18
435         c: uint256 = K - 10**18
436         if otherpow > c:
437             c = otherpow - c
438             neg = not neg
439         else:
440             c -= otherpow
441         term = term * (c * x / 10**18) / K
442         if neg:
443             S -= term
444         else:
445             S += term
446         if term < EXP_PRECISION:
447             return result * S / 10**18
448 
449     raise "Did not converge"
450 ### end of Math functions
451 
452 
453 @external
454 @view
455 def token() -> address:
456     return token
457 
458 
459 @external
460 @view
461 def coins(i: uint256) -> address:
462     _coins: address[N_COINS] = coins
463     return _coins[i]
464 
465 
466 @internal
467 @view
468 def xp() -> uint256[N_COINS]:
469     return [self.balances[0] * PRECISIONS[0],
470             self.balances[1] * PRECISIONS[1] * self.price_scale / PRECISION]
471 
472 
473 @view
474 @internal
475 def _A_gamma() -> uint256[2]:
476     t1: uint256 = self.future_A_gamma_time
477 
478     A_gamma_1: uint256 = self.future_A_gamma
479     gamma1: uint256 = bitwise_and(A_gamma_1, 2**128-1)
480     A1: uint256 = shift(A_gamma_1, -128)
481 
482     if block.timestamp < t1:
483         # handle ramping up and down of A
484         A_gamma_0: uint256 = self.initial_A_gamma
485         t0: uint256 = self.initial_A_gamma_time
486 
487         # Less readable but more compact way of writing and converting to uint256
488         # gamma0: uint256 = bitwise_and(A_gamma_0, 2**128-1)
489         # A0: uint256 = shift(A_gamma_0, -128)
490         # A1 = A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
491         # gamma1 = gamma0 + (gamma1 - gamma0) * (block.timestamp - t0) / (t1 - t0)
492 
493         t1 -= t0
494         t0 = block.timestamp - t0
495         t2: uint256 = t1 - t0
496 
497         A1 = (shift(A_gamma_0, -128) * t2 + A1 * t0) / t1
498         gamma1 = (bitwise_and(A_gamma_0, 2**128-1) * t2 + gamma1 * t0) / t1
499 
500     return [A1, gamma1]
501 
502 
503 @view
504 @external
505 def A() -> uint256:
506     return self._A_gamma()[0]
507 
508 
509 @view
510 @external
511 def gamma() -> uint256:
512     return self._A_gamma()[1]
513 
514 
515 @internal
516 @view
517 def _fee(xp: uint256[N_COINS]) -> uint256:
518     """
519     f = fee_gamma / (fee_gamma + (1 - K))
520     where
521     K = prod(x) / (sum(x) / N)**N
522     (all normalized to 1e18)
523     """
524     fee_gamma: uint256 = self.fee_gamma
525     f: uint256 = xp[0] + xp[1]  # sum
526     f = fee_gamma * 10**18 / (
527         fee_gamma + 10**18 - (10**18 * N_COINS**N_COINS) * xp[0] / f * xp[1] / f
528     )
529     return (self.mid_fee * f + self.out_fee * (10**18 - f)) / 10**18
530 
531 
532 @external
533 @view
534 def fee() -> uint256:
535     return self._fee(self.xp())
536 
537 
538 @internal
539 @view
540 def get_xcp(D: uint256) -> uint256:
541     x: uint256[N_COINS] = [D / N_COINS, D * PRECISION / (self.price_scale * N_COINS)]
542     return self.geometric_mean(x, True)
543 
544 
545 @external
546 @view
547 def get_virtual_price() -> uint256:
548     return 10**18 * self.get_xcp(self.D) / CurveToken(token).totalSupply()
549 
550 
551 @internal
552 def _claim_admin_fees():
553     A_gamma: uint256[2] = self._A_gamma()
554 
555     xcp_profit: uint256 = self.xcp_profit
556     xcp_profit_a: uint256 = self.xcp_profit_a
557 
558     # Gulp here
559     _coins: address[N_COINS] = coins
560     for i in range(N_COINS):
561         if i == ETH_INDEX:
562             self.balances[i] = self.balance
563         else:
564             self.balances[i] = ERC20(_coins[i]).balanceOf(self)
565 
566     vprice: uint256 = self.virtual_price
567 
568     if xcp_profit > xcp_profit_a:
569         fees: uint256 = (xcp_profit - xcp_profit_a) * self.admin_fee / (2 * 10**10)
570         if fees > 0:
571             receiver: address = self.admin_fee_receiver
572             if receiver != ZERO_ADDRESS:
573                 frac: uint256 = vprice * 10**18 / (vprice - fees) - 10**18
574                 claimed: uint256 = CurveToken(token).mint_relative(receiver, frac)
575                 xcp_profit -= fees*2
576                 self.xcp_profit = xcp_profit
577                 log ClaimAdminFee(receiver, claimed)
578 
579     total_supply: uint256 = CurveToken(token).totalSupply()
580 
581     # Recalculate D b/c we gulped
582     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], self.xp())
583     self.D = D
584 
585     self.virtual_price = 10**18 * self.get_xcp(D) / total_supply
586 
587     if xcp_profit > xcp_profit_a:
588         self.xcp_profit_a = xcp_profit
589 
590 
591 @internal
592 def tweak_price(A_gamma: uint256[2],_xp: uint256[N_COINS], p_i: uint256, new_D: uint256):
593     price_oracle: uint256 = self.price_oracle
594     last_prices: uint256 = self.last_prices
595     price_scale: uint256 = self.price_scale
596     last_prices_timestamp: uint256 = self.last_prices_timestamp
597     p_new: uint256 = 0
598 
599     if last_prices_timestamp < block.timestamp:
600         # MA update required
601         ma_half_time: uint256 = self.ma_half_time
602         alpha: uint256 = self.halfpow((block.timestamp - last_prices_timestamp) * 10**18 / ma_half_time)
603         price_oracle = (last_prices * (10**18 - alpha) + price_oracle * alpha) / 10**18
604         self.price_oracle = price_oracle
605         self.last_prices_timestamp = block.timestamp
606 
607     D_unadjusted: uint256 = new_D  # Withdrawal methods know new D already
608     if new_D == 0:
609         # We will need this a few times (35k gas)
610         D_unadjusted = self.newton_D(A_gamma[0], A_gamma[1], _xp)
611 
612     if p_i > 0:
613         last_prices = p_i
614 
615     else:
616         # calculate real prices
617         __xp: uint256[N_COINS] = _xp
618         dx_price: uint256 = __xp[0] / 10**6
619         __xp[0] += dx_price
620         last_prices = price_scale * dx_price / (_xp[1] - self.newton_y(A_gamma[0], A_gamma[1], __xp, D_unadjusted, 1))
621 
622     self.last_prices = last_prices
623 
624     total_supply: uint256 = CurveToken(token).totalSupply()
625     old_xcp_profit: uint256 = self.xcp_profit
626     old_virtual_price: uint256 = self.virtual_price
627 
628     # Update profit numbers without price adjustment first
629     xp: uint256[N_COINS] = [D_unadjusted / N_COINS, D_unadjusted * PRECISION / (N_COINS * price_scale)]
630     xcp_profit: uint256 = 10**18
631     virtual_price: uint256 = 10**18
632 
633     if old_virtual_price > 0:
634         xcp: uint256 = self.geometric_mean(xp, True)
635         virtual_price = 10**18 * xcp / total_supply
636         xcp_profit = old_xcp_profit * virtual_price / old_virtual_price
637 
638         t: uint256 = self.future_A_gamma_time
639         if virtual_price < old_virtual_price and t == 0:
640             raise "Loss"
641         if t == 1:
642             self.future_A_gamma_time = 0
643 
644     self.xcp_profit = xcp_profit
645 
646     needs_adjustment: bool = self.not_adjusted
647     # if not needs_adjustment and (virtual_price-10**18 > (xcp_profit-10**18)/2 + self.allowed_extra_profit):
648     # (re-arrange for gas efficiency)
649     if not needs_adjustment and (virtual_price * 2 - 10**18 > xcp_profit + 2*self.allowed_extra_profit):
650         needs_adjustment = True
651         self.not_adjusted = True
652 
653     if needs_adjustment:
654         norm: uint256 = price_oracle * 10**18 / price_scale
655         if norm > 10**18:
656             norm -= 10**18
657         else:
658             norm = 10**18 - norm
659         adjustment_step: uint256 = max(self.adjustment_step, norm / 10)
660 
661         if norm > adjustment_step and old_virtual_price > 0:
662             p_new = (price_scale * (norm - adjustment_step) + adjustment_step * price_oracle) / norm
663 
664             # Calculate balances*prices
665             xp = [_xp[0], _xp[1] * p_new / price_scale]
666 
667             # Calculate "extended constant product" invariant xCP and virtual price
668             D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
669             xp = [D / N_COINS, D * PRECISION / (N_COINS * p_new)]
670             # We reuse old_virtual_price here but it's not old anymore
671             old_virtual_price = 10**18 * self.geometric_mean(xp, True) / total_supply
672 
673             # Proceed if we've got enough profit
674             # if (old_virtual_price > 10**18) and (2 * (old_virtual_price - 10**18) > xcp_profit - 10**18):
675             if (old_virtual_price > 10**18) and (2 * old_virtual_price - 10**18 > xcp_profit):
676                 self.price_scale = p_new
677                 self.D = D
678                 self.virtual_price = old_virtual_price
679 
680                 return
681 
682             else:
683                 self.not_adjusted = False
684 
685                 # Can instead do another flag variable if we want to save bytespace
686                 self.D = D_unadjusted
687                 self.virtual_price = virtual_price
688                 self._claim_admin_fees()
689 
690                 return
691 
692     # If we are here, the price_scale adjustment did not happen
693     # Still need to update the profit counter and D
694     self.D = D_unadjusted
695     self.virtual_price = virtual_price
696 
697 
698 @internal
699 def _exchange(sender: address, mvalue: uint256, i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool) -> uint256:
700     assert not self.is_killed  # dev: the pool is killed
701     assert i != j  # dev: coin index out of range
702     assert i < N_COINS  # dev: coin index out of range
703     assert j < N_COINS  # dev: coin index out of range
704     assert dx > 0  # dev: do not exchange 0 coins
705 
706     A_gamma: uint256[2] = self._A_gamma()
707     xp: uint256[N_COINS] = self.balances
708     p: uint256 = 0
709     dy: uint256 = 0
710 
711     _coins: address[N_COINS] = coins
712     if use_eth and i == ETH_INDEX:
713         assert mvalue == dx  # dev: incorrect eth amount
714     else:
715         assert mvalue == 0  # dev: nonzero eth amount
716         assert ERC20(_coins[i]).transferFrom(sender, self, dx)
717         if i == ETH_INDEX:
718             WETH(_coins[i]).withdraw(dx)
719 
720     y: uint256 = xp[j]
721     x0: uint256 = xp[i]
722     xp[i] = x0 + dx
723     self.balances[i] = xp[i]
724 
725     price_scale: uint256 = self.price_scale
726 
727     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale * PRECISIONS[1] / PRECISION]
728 
729     prec_i: uint256 = PRECISIONS[0]
730     prec_j: uint256 = PRECISIONS[1]
731     if i == 1:
732         prec_i = PRECISIONS[1]
733         prec_j = PRECISIONS[0]
734 
735     # In case ramp is happening
736     t: uint256 = self.future_A_gamma_time
737     if t > 0:
738         x0 *= prec_i
739         if i > 0:
740             x0 = x0 * price_scale / PRECISION
741         x1: uint256 = xp[i]  # Back up old value in xp
742         xp[i] = x0
743         self.D = self.newton_D(A_gamma[0], A_gamma[1], xp)
744         xp[i] = x1  # And restore
745         if block.timestamp >= t:
746             self.future_A_gamma_time = 1
747 
748     dy = xp[j] - self.newton_y(A_gamma[0], A_gamma[1], xp, self.D, j)
749     # Not defining new "y" here to have less variables / make subsequent calls cheaper
750     xp[j] -= dy
751     dy -= 1
752 
753     if j > 0:
754         dy = dy * PRECISION / price_scale
755     dy /= prec_j
756 
757     dy -= self._fee(xp) * dy / 10**10
758     assert dy >= min_dy, "Slippage"
759     y -= dy
760 
761     self.balances[j] = y
762     if use_eth and j == ETH_INDEX:
763         raw_call(sender, b"", value=dy)
764     else:
765         if j == ETH_INDEX:
766             WETH(_coins[j]).deposit(value=dy)
767         assert ERC20(_coins[j]).transfer(sender, dy)
768 
769     y *= prec_j
770     if j > 0:
771         y = y * price_scale / PRECISION
772     xp[j] = y
773 
774     # Calculate price
775     if dx > 10**5 and dy > 10**5:
776         _dx: uint256 = dx * prec_i
777         _dy: uint256 = dy * prec_j
778         if i == 0:
779             p = _dx * 10**18 / _dy
780         else:  # j == 0
781             p = _dy * 10**18 / _dx
782 
783     self.tweak_price(A_gamma, xp, p, 0)
784 
785     log TokenExchange(sender, i, dx, j, dy)
786 
787     return dy
788 
789 
790 @payable
791 @external
792 @nonreentrant('lock')
793 def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool = False) -> uint256:
794     """
795     Exchange using WETH by default
796     """
797     return self._exchange(msg.sender, msg.value, i, j, dx, min_dy, use_eth)
798 
799 
800 @payable
801 @external
802 @nonreentrant('lock')
803 def exchange_underlying(i: uint256, j: uint256, dx: uint256, min_dy: uint256) -> uint256:
804     """
805     Exchange using ETH
806     """
807     return self._exchange(msg.sender, msg.value, i, j, dx, min_dy, True)
808 
809 
810 @external
811 @view
812 def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256:
813     assert i != j  # dev: same input and output coin
814     assert i < N_COINS  # dev: coin index out of range
815     assert j < N_COINS  # dev: coin index out of range
816 
817     price_scale: uint256 = self.price_scale * PRECISIONS[1]
818     xp: uint256[N_COINS] = self.balances
819 
820     A_gamma: uint256[2] = self._A_gamma()
821     D: uint256 = self.D
822     if self.future_A_gamma_time > 0:
823         D = self.newton_D(A_gamma[0], A_gamma[1], self.xp())
824 
825     xp[i] += dx
826     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale / PRECISION]
827 
828     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, j)
829     dy: uint256 = xp[j] - y - 1
830     xp[j] = y
831     if j > 0:
832         dy = dy * PRECISION / price_scale
833     else:
834         dy /= PRECISIONS[0]
835     dy -= self._fee(xp) * dy / 10**10
836 
837     return dy
838 
839 
840 @view
841 @internal
842 def _calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
843     # fee = sum(amounts_i - avg(amounts)) * fee' / sum(amounts)
844     fee: uint256 = self._fee(xp) * N_COINS / (4 * (N_COINS-1))
845     S: uint256 = 0
846     for _x in amounts:
847         S += _x
848     avg: uint256 = S / N_COINS
849     Sdiff: uint256 = 0
850     for _x in amounts:
851         if _x > avg:
852             Sdiff += _x - avg
853         else:
854             Sdiff += avg - _x
855     return fee * Sdiff / S + NOISE_FEE
856 
857 
858 @payable
859 @external
860 @nonreentrant('lock')
861 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256, use_eth: bool = False) -> uint256:
862     assert not self.is_killed  # dev: the pool is killed
863     assert amounts[0] > 0 or amounts[1] > 0  # dev: no coins to add
864 
865     A_gamma: uint256[2] = self._A_gamma()
866 
867     _coins: address[N_COINS] = coins
868 
869     xp: uint256[N_COINS] = self.balances
870     amountsp: uint256[N_COINS] = empty(uint256[N_COINS])
871     xx: uint256[N_COINS] = empty(uint256[N_COINS])
872     d_token: uint256 = 0
873     d_token_fee: uint256 = 0
874     old_D: uint256 = 0
875 
876     xp_old: uint256[N_COINS] = xp
877 
878     for i in range(N_COINS):
879         bal: uint256 = xp[i] + amounts[i]
880         xp[i] = bal
881         self.balances[i] = bal
882     xx = xp
883 
884     price_scale: uint256 = self.price_scale * PRECISIONS[1]
885     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale / PRECISION]
886     xp_old = [xp_old[0] * PRECISIONS[0], xp_old[1] * price_scale / PRECISION]
887 
888     if not use_eth:
889         assert msg.value == 0  # dev: nonzero eth amount
890 
891     for i in range(N_COINS):
892         if use_eth and i == ETH_INDEX:
893             assert msg.value == amounts[i]  # dev: incorrect eth amount
894         if amounts[i] > 0:
895             if (not use_eth) or (i != ETH_INDEX):
896                 assert ERC20(_coins[i]).transferFrom(msg.sender, self, amounts[i])
897                 if i == ETH_INDEX:
898                     WETH(_coins[i]).withdraw(amounts[i])
899             amountsp[i] = xp[i] - xp_old[i]
900 
901     t: uint256 = self.future_A_gamma_time
902     if t > 0:
903         old_D = self.newton_D(A_gamma[0], A_gamma[1], xp_old)
904         if block.timestamp >= t:
905             self.future_A_gamma_time = 1
906     else:
907         old_D = self.D
908 
909     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
910 
911     token_supply: uint256 = CurveToken(token).totalSupply()
912     if old_D > 0:
913         d_token = token_supply * D / old_D - token_supply
914     else:
915         d_token = self.get_xcp(D)  # making initial virtual price equal to 1
916     assert d_token > 0  # dev: nothing minted
917 
918     if old_D > 0:
919         d_token_fee = self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
920         d_token -= d_token_fee
921         token_supply += d_token
922         CurveToken(token).mint(msg.sender, d_token)
923 
924         # Calculate price
925         # p_i * (dx_i - dtoken / token_supply * xx_i) = sum{k!=i}(p_k * (dtoken / token_supply * xx_k - dx_k))
926         # Simplified for 2 coins
927         p: uint256 = 0
928         if d_token > 10**5:
929             if amounts[0] == 0 or amounts[1] == 0:
930                 S: uint256 = 0
931                 precision: uint256 = 0
932                 ix: uint256 = 0
933                 if amounts[0] == 0:
934                     S = xx[0] * PRECISIONS[0]
935                     precision = PRECISIONS[1]
936                     ix = 1
937                 else:
938                     S = xx[1] * PRECISIONS[1]
939                     precision = PRECISIONS[0]
940                 S = S * d_token / token_supply
941                 p = S * PRECISION / (amounts[ix] * precision - d_token * xx[ix] * precision / token_supply)
942                 if ix == 0:
943                     p = (10**18)**2 / p
944 
945         self.tweak_price(A_gamma, xp, p, D)
946 
947     else:
948         self.D = D
949         self.virtual_price = 10**18
950         self.xcp_profit = 10**18
951         CurveToken(token).mint(msg.sender, d_token)
952 
953     assert d_token >= min_mint_amount, "Slippage"
954 
955     log AddLiquidity(msg.sender, amounts, d_token_fee, token_supply)
956 
957     return d_token
958 
959 
960 @external
961 @nonreentrant('lock')
962 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS], use_eth: bool = False):
963     """
964     This withdrawal method is very safe, does no complex math
965     """
966     _coins: address[N_COINS] = coins
967     total_supply: uint256 = CurveToken(token).totalSupply()
968     CurveToken(token).burnFrom(msg.sender, _amount)
969     balances: uint256[N_COINS] = self.balances
970     amount: uint256 = _amount - 1  # Make rounding errors favoring other LPs a tiny bit
971 
972     for i in range(N_COINS):
973         d_balance: uint256 = balances[i] * amount / total_supply
974         assert d_balance >= min_amounts[i]
975         self.balances[i] = balances[i] - d_balance
976         balances[i] = d_balance  # now it's the amounts going out
977         if use_eth and i == ETH_INDEX:
978             raw_call(msg.sender, b"", value=d_balance)
979         else:
980             if i == ETH_INDEX:
981                 WETH(_coins[i]).deposit(value=d_balance)
982             assert ERC20(_coins[i]).transfer(msg.sender, d_balance)
983 
984     D: uint256 = self.D
985     self.D = D - D * amount / total_supply
986 
987     log RemoveLiquidity(msg.sender, balances, total_supply - _amount)
988 
989 
990 @view
991 @external
992 def calc_token_amount(amounts: uint256[N_COINS]) -> uint256:
993     token_supply: uint256 = CurveToken(token).totalSupply()
994     price_scale: uint256 = self.price_scale * PRECISIONS[1]
995     A_gamma: uint256[2] = self._A_gamma()
996     xp: uint256[N_COINS] = self.xp()
997     amountsp: uint256[N_COINS] = [
998         amounts[0] * PRECISIONS[0],
999         amounts[1] * price_scale / PRECISION]
1000     D0: uint256 = self.D
1001     if self.future_A_gamma_time > 0:
1002         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1003     xp[0] += amountsp[0]
1004     xp[1] += amountsp[1]
1005     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1006     d_token: uint256 = token_supply * D / D0 - token_supply
1007     d_token -= self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
1008     return d_token
1009 
1010 
1011 @internal
1012 @view
1013 def _calc_withdraw_one_coin(A_gamma: uint256[2], token_amount: uint256, i: uint256, update_D: bool,
1014                             calc_price: bool) -> (uint256, uint256, uint256, uint256[N_COINS]):
1015     token_supply: uint256 = CurveToken(token).totalSupply()
1016     assert token_amount <= token_supply  # dev: token amount more than supply
1017     assert i < N_COINS  # dev: coin out of range
1018 
1019     xx: uint256[N_COINS] = self.balances
1020     D0: uint256 = 0
1021 
1022     price_scale_i: uint256 = self.price_scale * PRECISIONS[1]
1023     xp: uint256[N_COINS] = [xx[0] * PRECISIONS[0], xx[1] * price_scale_i / PRECISION]
1024     if i == 0:
1025         price_scale_i = PRECISION * PRECISIONS[0]
1026 
1027     if update_D:
1028         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1029     else:
1030         D0 = self.D
1031 
1032     D: uint256 = D0
1033 
1034     # Charge the fee on D, not on y, e.g. reducing invariant LESS than charging the user
1035     fee: uint256 = self._fee(xp)
1036     dD: uint256 = token_amount * D / token_supply
1037     D -= (dD - (fee * dD / (2 * 10**10) + 1))
1038     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, i)
1039     dy: uint256 = (xp[i] - y) * PRECISION / price_scale_i
1040     xp[i] = y
1041 
1042     # Price calc
1043     p: uint256 = 0
1044     if calc_price and dy > 10**5 and token_amount > 10**5:
1045         # p_i = dD / D0 * sum'(p_k * x_k) / (dy - dD / D0 * y0)
1046         S: uint256 = 0
1047         precision: uint256 = PRECISIONS[0]
1048         if i == 1:
1049             S = xx[0] * PRECISIONS[0]
1050             precision = PRECISIONS[1]
1051         else:
1052             S = xx[1] * PRECISIONS[1]
1053         S = S * dD / D0
1054         p = S * PRECISION / (dy * precision - dD * xx[i] * precision / D0)
1055         if i == 0:
1056             p = (10**18)**2 / p
1057 
1058     return dy, p, D, xp
1059 
1060 
1061 @view
1062 @external
1063 def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256:
1064     return self._calc_withdraw_one_coin(self._A_gamma(), token_amount, i, True, False)[0]
1065 
1066 
1067 @external
1068 @nonreentrant('lock')
1069 def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256, use_eth: bool = False) -> uint256:
1070     assert not self.is_killed  # dev: the pool is killed
1071 
1072     A_gamma: uint256[2] = self._A_gamma()
1073 
1074     dy: uint256 = 0
1075     D: uint256 = 0
1076     p: uint256 = 0
1077     xp: uint256[N_COINS] = empty(uint256[N_COINS])
1078     future_A_gamma_time: uint256 = self.future_A_gamma_time
1079     dy, p, D, xp = self._calc_withdraw_one_coin(A_gamma, token_amount, i, (future_A_gamma_time > 0), True)
1080     assert dy >= min_amount, "Slippage"
1081 
1082     if block.timestamp >= future_A_gamma_time:
1083         self.future_A_gamma_time = 1
1084 
1085     self.balances[i] -= dy
1086     CurveToken(token).burnFrom(msg.sender, token_amount)
1087 
1088     _coins: address[N_COINS] = coins
1089     if use_eth and i == ETH_INDEX:
1090         raw_call(msg.sender, b"", value=dy)
1091     else:
1092         if i == ETH_INDEX:
1093             WETH(_coins[i]).deposit(value=dy)
1094         assert ERC20(_coins[i]).transfer(msg.sender, dy)
1095 
1096     self.tweak_price(A_gamma, xp, p, D)
1097 
1098     log RemoveLiquidityOne(msg.sender, token_amount, i, dy)
1099 
1100     return dy
1101 
1102 
1103 @external
1104 @nonreentrant('lock')
1105 def claim_admin_fees():
1106     self._claim_admin_fees()
1107 
1108 
1109 # Admin parameters
1110 @external
1111 def ramp_A_gamma(future_A: uint256, future_gamma: uint256, future_time: uint256):
1112     assert msg.sender == self.owner  # dev: only owner
1113     assert block.timestamp > self.initial_A_gamma_time + (MIN_RAMP_TIME-1)
1114     assert future_time > block.timestamp + (MIN_RAMP_TIME-1)  # dev: insufficient time
1115 
1116     A_gamma: uint256[2] = self._A_gamma()
1117     initial_A_gamma: uint256 = shift(A_gamma[0], 128)
1118     initial_A_gamma = bitwise_or(initial_A_gamma, A_gamma[1])
1119 
1120     assert future_A > MIN_A-1
1121     assert future_A < MAX_A+1
1122     assert future_gamma > MIN_GAMMA-1
1123     assert future_gamma < MAX_GAMMA+1
1124 
1125     ratio: uint256 = 10**18 * future_A / A_gamma[0]
1126     assert ratio < 10**18 * MAX_A_CHANGE + 1
1127     assert ratio > 10**18 / MAX_A_CHANGE - 1
1128 
1129     ratio = 10**18 * future_gamma / A_gamma[1]
1130     assert ratio < 10**18 * MAX_A_CHANGE + 1
1131     assert ratio > 10**18 / MAX_A_CHANGE - 1
1132 
1133     self.initial_A_gamma = initial_A_gamma
1134     self.initial_A_gamma_time = block.timestamp
1135 
1136     future_A_gamma: uint256 = shift(future_A, 128)
1137     future_A_gamma = bitwise_or(future_A_gamma, future_gamma)
1138     self.future_A_gamma_time = future_time
1139     self.future_A_gamma = future_A_gamma
1140 
1141     log RampAgamma(A_gamma[0], future_A, A_gamma[1], future_gamma, block.timestamp, future_time)
1142 
1143 
1144 @external
1145 def stop_ramp_A_gamma():
1146     assert msg.sender == self.owner  # dev: only owner
1147 
1148     A_gamma: uint256[2] = self._A_gamma()
1149     current_A_gamma: uint256 = shift(A_gamma[0], 128)
1150     current_A_gamma = bitwise_or(current_A_gamma, A_gamma[1])
1151     self.initial_A_gamma = current_A_gamma
1152     self.future_A_gamma = current_A_gamma
1153     self.initial_A_gamma_time = block.timestamp
1154     self.future_A_gamma_time = block.timestamp
1155     # now (block.timestamp < t1) is always False, so we return saved A
1156 
1157     log StopRampA(A_gamma[0], A_gamma[1], block.timestamp)
1158 
1159 
1160 @external
1161 def commit_new_parameters(
1162     _new_mid_fee: uint256,
1163     _new_out_fee: uint256,
1164     _new_admin_fee: uint256,
1165     _new_fee_gamma: uint256,
1166     _new_allowed_extra_profit: uint256,
1167     _new_adjustment_step: uint256,
1168     _new_ma_half_time: uint256,
1169     ):
1170     assert msg.sender == self.owner  # dev: only owner
1171     assert self.admin_actions_deadline == 0  # dev: active action
1172 
1173     new_mid_fee: uint256 = _new_mid_fee
1174     new_out_fee: uint256 = _new_out_fee
1175     new_admin_fee: uint256 = _new_admin_fee
1176     new_fee_gamma: uint256 = _new_fee_gamma
1177     new_allowed_extra_profit: uint256 = _new_allowed_extra_profit
1178     new_adjustment_step: uint256 = _new_adjustment_step
1179     new_ma_half_time: uint256 = _new_ma_half_time
1180 
1181     # Fees
1182     if new_out_fee < MAX_FEE+1:
1183         assert new_out_fee > MIN_FEE-1  # dev: fee is out of range
1184     else:
1185         new_out_fee = self.out_fee
1186     if new_mid_fee > MAX_FEE:
1187         new_mid_fee = self.mid_fee
1188     assert new_mid_fee <= new_out_fee  # dev: mid-fee is too high
1189     if new_admin_fee > MAX_ADMIN_FEE:
1190         new_admin_fee = self.admin_fee
1191 
1192     # AMM parameters
1193     if new_fee_gamma < 10**18:
1194         assert new_fee_gamma > 0  # dev: fee_gamma out of range [1 .. 10**18]
1195     else:
1196         new_fee_gamma = self.fee_gamma
1197     if new_allowed_extra_profit > 10**18:
1198         new_allowed_extra_profit = self.allowed_extra_profit
1199     if new_adjustment_step > 10**18:
1200         new_adjustment_step = self.adjustment_step
1201 
1202     # MA
1203     if new_ma_half_time < 7*86400:
1204         assert new_ma_half_time > 0  # dev: MA time should be longer than 1 second
1205     else:
1206         new_ma_half_time = self.ma_half_time
1207 
1208     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1209     self.admin_actions_deadline = _deadline
1210 
1211     self.future_admin_fee = new_admin_fee
1212     self.future_mid_fee = new_mid_fee
1213     self.future_out_fee = new_out_fee
1214     self.future_fee_gamma = new_fee_gamma
1215     self.future_allowed_extra_profit = new_allowed_extra_profit
1216     self.future_adjustment_step = new_adjustment_step
1217     self.future_ma_half_time = new_ma_half_time
1218 
1219     log CommitNewParameters(_deadline, new_admin_fee, new_mid_fee, new_out_fee,
1220                             new_fee_gamma,
1221                             new_allowed_extra_profit, new_adjustment_step,
1222                             new_ma_half_time)
1223 
1224 
1225 @external
1226 @nonreentrant('lock')
1227 def apply_new_parameters():
1228     assert msg.sender == self.owner  # dev: only owner
1229     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
1230     assert self.admin_actions_deadline != 0  # dev: no active action
1231 
1232     self.admin_actions_deadline = 0
1233 
1234     admin_fee: uint256 = self.future_admin_fee
1235     if self.admin_fee != admin_fee:
1236         self._claim_admin_fees()
1237         self.admin_fee = admin_fee
1238 
1239     mid_fee: uint256 = self.future_mid_fee
1240     self.mid_fee = mid_fee
1241     out_fee: uint256 = self.future_out_fee
1242     self.out_fee = out_fee
1243     fee_gamma: uint256 = self.future_fee_gamma
1244     self.fee_gamma = fee_gamma
1245     allowed_extra_profit: uint256 = self.future_allowed_extra_profit
1246     self.allowed_extra_profit = allowed_extra_profit
1247     adjustment_step: uint256 = self.future_adjustment_step
1248     self.adjustment_step = adjustment_step
1249     ma_half_time: uint256 = self.future_ma_half_time
1250     self.ma_half_time = ma_half_time
1251 
1252     log NewParameters(admin_fee, mid_fee, out_fee,
1253                       fee_gamma,
1254                       allowed_extra_profit, adjustment_step,
1255                       ma_half_time)
1256 
1257 
1258 @external
1259 def revert_new_parameters():
1260     assert msg.sender == self.owner  # dev: only owner
1261 
1262     self.admin_actions_deadline = 0
1263 
1264 
1265 @external
1266 def commit_transfer_ownership(_owner: address):
1267     assert msg.sender == self.owner  # dev: only owner
1268     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1269 
1270     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1271     self.transfer_ownership_deadline = _deadline
1272     self.future_owner = _owner
1273 
1274     log CommitNewAdmin(_deadline, _owner)
1275 
1276 
1277 @external
1278 def apply_transfer_ownership():
1279     assert msg.sender == self.owner  # dev: only owner
1280     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1281     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1282 
1283     self.transfer_ownership_deadline = 0
1284     _owner: address = self.future_owner
1285     self.owner = _owner
1286 
1287     log NewAdmin(_owner)
1288 
1289 
1290 @external
1291 def revert_transfer_ownership():
1292     assert msg.sender == self.owner  # dev: only owner
1293 
1294     self.transfer_ownership_deadline = 0
1295 
1296 
1297 @external
1298 def kill_me():
1299     assert msg.sender == self.owner  # dev: only owner
1300     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1301     self.is_killed = True
1302 
1303 
1304 @external
1305 def unkill_me():
1306     assert msg.sender == self.owner  # dev: only owner
1307     self.is_killed = False
1308 
1309 
1310 @external
1311 def set_admin_fee_receiver(_admin_fee_receiver: address):
1312     assert msg.sender == self.owner  # dev: only owner
1313     self.admin_fee_receiver = _admin_fee_receiver
1314 
1315 
1316 @internal
1317 @pure
1318 def sqrt_int(x: uint256) -> uint256:
1319     """
1320     Originating from: https://github.com/vyperlang/vyper/issues/1266
1321     """
1322 
1323     if x == 0:
1324         return 0
1325 
1326     z: uint256 = (x + 10**18) / 2
1327     y: uint256 = x
1328 
1329     for i in range(256):
1330         if z == y:
1331             return y
1332         y = z
1333         z = (x * 10**18 / z + z) / 2
1334 
1335     raise "Did not converge"
1336 
1337 
1338 @external
1339 @view
1340 def lp_price() -> uint256:
1341     """
1342     Approximate LP token price
1343     """
1344     max_price: uint256 = 2 * self.virtual_price * self.sqrt_int(self.price_oracle) / 10**18
1345 
1346     return max_price