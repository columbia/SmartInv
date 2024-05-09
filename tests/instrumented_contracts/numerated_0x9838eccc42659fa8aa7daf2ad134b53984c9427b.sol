1 # @version 0.3.0
2 # (c) Curve.Fi, 2021
3 # Pool for two crypto assets
4 
5 from vyper.interfaces import ERC20
6 # Expected coins:
7 # eur*/3crv
8 # crypto/tricrypto
9 # All are proper ERC20s, so let's use a standard interface and save bytespace
10 
11 interface CurveToken:
12     def totalSupply() -> uint256: view
13     def mint(_to: address, _value: uint256) -> bool: nonpayable
14     def mint_relative(_to: address, frac: uint256) -> uint256: nonpayable
15     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
16 
17 
18 # Events
19 event TokenExchange:
20     buyer: indexed(address)
21     sold_id: uint256
22     tokens_sold: uint256
23     bought_id: uint256
24     tokens_bought: uint256
25 
26 event AddLiquidity:
27     provider: indexed(address)
28     token_amounts: uint256[N_COINS]
29     fee: uint256
30     token_supply: uint256
31 
32 event RemoveLiquidity:
33     provider: indexed(address)
34     token_amounts: uint256[N_COINS]
35     token_supply: uint256
36 
37 event RemoveLiquidityOne:
38     provider: indexed(address)
39     token_amount: uint256
40     coin_index: uint256
41     coin_amount: uint256
42 
43 event CommitNewAdmin:
44     deadline: indexed(uint256)
45     admin: indexed(address)
46 
47 event NewAdmin:
48     admin: indexed(address)
49 
50 event CommitNewParameters:
51     deadline: indexed(uint256)
52     admin_fee: uint256
53     mid_fee: uint256
54     out_fee: uint256
55     fee_gamma: uint256
56     allowed_extra_profit: uint256
57     adjustment_step: uint256
58     ma_half_time: uint256
59 
60 event NewParameters:
61     admin_fee: uint256
62     mid_fee: uint256
63     out_fee: uint256
64     fee_gamma: uint256
65     allowed_extra_profit: uint256
66     adjustment_step: uint256
67     ma_half_time: uint256
68 
69 event RampAgamma:
70     initial_A: uint256
71     future_A: uint256
72     initial_gamma: uint256
73     future_gamma: uint256
74     initial_time: uint256
75     future_time: uint256
76 
77 event StopRampA:
78     current_A: uint256
79     current_gamma: uint256
80     time: uint256
81 
82 event ClaimAdminFee:
83     admin: indexed(address)
84     tokens: uint256
85 
86 
87 N_COINS: constant(int128) = 2
88 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
89 A_MULTIPLIER: constant(uint256) = 10000
90 
91 # These addresses are replaced by the deployer
92 token: constant(address) = 0x3b6831c0077a1e44ED0a21841C3bC4dC11bCE833
93 coins: constant(address[N_COINS]) = [
94     0xC581b735A1688071A1746c968e0798D642EDE491,
95     0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490]
96 
97 price_scale: public(uint256)   # Internal price scale
98 price_oracle: public(uint256)  # Price target given by MA
99 
100 last_prices: public(uint256)
101 last_prices_timestamp: public(uint256)
102 
103 initial_A_gamma: public(uint256)
104 future_A_gamma: public(uint256)
105 initial_A_gamma_time: public(uint256)
106 future_A_gamma_time: public(uint256)
107 
108 allowed_extra_profit: public(uint256)  # 2 * 10**12 - recommended value
109 future_allowed_extra_profit: public(uint256)
110 
111 fee_gamma: public(uint256)
112 future_fee_gamma: public(uint256)
113 
114 adjustment_step: public(uint256)
115 future_adjustment_step: public(uint256)
116 
117 ma_half_time: public(uint256)
118 future_ma_half_time: public(uint256)
119 
120 mid_fee: public(uint256)
121 out_fee: public(uint256)
122 admin_fee: public(uint256)
123 future_mid_fee: public(uint256)
124 future_out_fee: public(uint256)
125 future_admin_fee: public(uint256)
126 
127 balances: public(uint256[N_COINS])
128 D: public(uint256)
129 
130 owner: public(address)
131 future_owner: public(address)
132 
133 xcp_profit: public(uint256)
134 xcp_profit_a: public(uint256)  # Full profit at last claim of admin fees
135 virtual_price: public(uint256)  # Cached (fast to read) virtual price also used internally
136 not_adjusted: bool
137 
138 is_killed: public(bool)
139 kill_deadline: public(uint256)
140 transfer_ownership_deadline: public(uint256)
141 admin_actions_deadline: public(uint256)
142 
143 admin_fee_receiver: public(address)
144 
145 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
146 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
147 MIN_RAMP_TIME: constant(uint256) = 86400
148 
149 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
150 MIN_FEE: constant(uint256) = 5 * 10 ** 5  # 0.5 bps
151 MAX_FEE: constant(uint256) = 10 * 10 ** 9
152 MAX_A_CHANGE: constant(uint256) = 10
153 NOISE_FEE: constant(uint256) = 10**5  # 0.1 bps
154 
155 MIN_GAMMA: constant(uint256) = 10**10
156 MAX_GAMMA: constant(uint256) = 2 * 10**16
157 
158 MIN_A: constant(uint256) = N_COINS**N_COINS * A_MULTIPLIER / 10
159 MAX_A: constant(uint256) = N_COINS**N_COINS * A_MULTIPLIER * 100000
160 
161 # This must be changed for different N_COINS
162 # For example:
163 # N_COINS = 3 -> 1  (10**18 -> 10**18)
164 # N_COINS = 4 -> 10**8  (10**18 -> 10**10)
165 # PRICE_PRECISION_MUL: constant(uint256) = 1
166 PRECISIONS: constant(uint256[N_COINS]) = [
167     1000000000000,
168     1,
169 ]
170 
171 EXP_PRECISION: constant(uint256) = 10**10
172 
173 
174 @external
175 def __init__(
176     owner: address,
177     admin_fee_receiver: address,
178     A: uint256,
179     gamma: uint256,
180     mid_fee: uint256,
181     out_fee: uint256,
182     allowed_extra_profit: uint256,
183     fee_gamma: uint256,
184     adjustment_step: uint256,
185     admin_fee: uint256,
186     ma_half_time: uint256,
187     initial_price: uint256
188 ):
189     self.owner = owner
190 
191     # Pack A and gamma:
192     # shifted A + gamma
193     A_gamma: uint256 = shift(A, 128)
194     A_gamma = bitwise_or(A_gamma, gamma)
195     self.initial_A_gamma = A_gamma
196     self.future_A_gamma = A_gamma
197 
198     self.mid_fee = mid_fee
199     self.out_fee = out_fee
200     self.allowed_extra_profit = allowed_extra_profit
201     self.fee_gamma = fee_gamma
202     self.adjustment_step = adjustment_step
203     self.admin_fee = admin_fee
204 
205     self.price_scale = initial_price
206     self.price_oracle = initial_price
207     self.last_prices = initial_price
208     self.last_prices_timestamp = block.timestamp
209     self.ma_half_time = ma_half_time
210 
211     self.xcp_profit_a = 10**18
212 
213     self.kill_deadline = block.timestamp + KILL_DEADLINE_DT
214 
215     self.admin_fee_receiver = admin_fee_receiver
216 
217 
218 ### Math functions
219 @internal
220 @pure
221 def geometric_mean(unsorted_x: uint256[N_COINS], sort: bool) -> uint256:
222     """
223     (x[0] * x[1] * ...) ** (1/N)
224     """
225     x: uint256[N_COINS] = unsorted_x
226     if sort and x[0] < x[1]:
227         x = [unsorted_x[1], unsorted_x[0]]
228     D: uint256 = x[0]
229     diff: uint256 = 0
230     for i in range(255):
231         D_prev: uint256 = D
232         # tmp: uint256 = 10**18
233         # for _x in x:
234         #     tmp = tmp * _x / D
235         # D = D * ((N_COINS - 1) * 10**18 + tmp) / (N_COINS * 10**18)
236         # line below makes it for 2 coins
237         D = (D + x[0] * x[1] / D) / N_COINS
238         if D > D_prev:
239             diff = D - D_prev
240         else:
241             diff = D_prev - D
242         if diff <= 1 or diff * 10**18 < D:
243             return D
244     raise "Did not converge"
245 
246 
247 @internal
248 @view
249 def newton_D(ANN: uint256, gamma: uint256, x_unsorted: uint256[N_COINS]) -> uint256:
250     """
251     Finding the invariant using Newton method.
252     ANN is higher by the factor A_MULTIPLIER
253     ANN is already A * N**N
254 
255     Currently uses 60k gas
256     """
257     # Safety checks
258     assert ANN > MIN_A - 1 and ANN < MAX_A + 1  # dev: unsafe values A
259     assert gamma > MIN_GAMMA - 1 and gamma < MAX_GAMMA + 1  # dev: unsafe values gamma
260 
261     # Initial value of invariant D is that for constant-product invariant
262     x: uint256[N_COINS] = x_unsorted
263     if x[0] < x[1]:
264         x = [x_unsorted[1], x_unsorted[0]]
265 
266     assert x[0] > 10**9 - 1 and x[0] < 10**15 * 10**18 + 1  # dev: unsafe values x[0]
267     assert x[1] * 10**18 / x[0] > 10**14-1  # dev: unsafe values x[i] (input)
268 
269     D: uint256 = N_COINS * self.geometric_mean(x, False)
270     S: uint256 = x[0] + x[1]
271 
272     for i in range(255):
273         D_prev: uint256 = D
274 
275         # K0: uint256 = 10**18
276         # for _x in x:
277         #     K0 = K0 * _x * N_COINS / D
278         # collapsed for 2 coins
279         K0: uint256 = (10**18 * N_COINS**2) * x[0] / D * x[1] / D
280 
281         _g1k0: uint256 = gamma + 10**18
282         if _g1k0 > K0:
283             _g1k0 = _g1k0 - K0 + 1
284         else:
285             _g1k0 = K0 - _g1k0 + 1
286 
287         # D / (A * N**N) * _g1k0**2 / gamma**2
288         mul1: uint256 = 10**18 * D / gamma * _g1k0 / gamma * _g1k0 * A_MULTIPLIER / ANN
289 
290         # 2*N*K0 / _g1k0
291         mul2: uint256 = (2 * 10**18) * N_COINS * K0 / _g1k0
292 
293         neg_fprime: uint256 = (S + S * mul2 / 10**18) + mul1 * N_COINS / K0 - mul2 * D / 10**18
294 
295         # D -= f / fprime
296         D_plus: uint256 = D * (neg_fprime + S) / neg_fprime
297         D_minus: uint256 = D*D / neg_fprime
298         if 10**18 > K0:
299             D_minus += D * (mul1 / neg_fprime) / 10**18 * (10**18 - K0) / K0
300         else:
301             D_minus -= D * (mul1 / neg_fprime) / 10**18 * (K0 - 10**18) / K0
302 
303         if D_plus > D_minus:
304             D = D_plus - D_minus
305         else:
306             D = (D_minus - D_plus) / 2
307 
308         diff: uint256 = 0
309         if D > D_prev:
310             diff = D - D_prev
311         else:
312             diff = D_prev - D
313         if diff * 10**14 < max(10**16, D):  # Could reduce precision for gas efficiency here
314             # Test that we are safe with the next newton_y
315             for _x in x:
316                 frac: uint256 = _x * 10**18 / D
317                 assert (frac > 10**16 - 1) and (frac < 10**20 + 1)  # dev: unsafe values x[i]
318             return D
319 
320     raise "Did not converge"
321 
322 
323 @internal
324 @pure
325 def newton_y(ANN: uint256, gamma: uint256, x: uint256[N_COINS], D: uint256, i: uint256) -> uint256:
326     """
327     Calculating x[i] given other balances x[0..N_COINS-1] and invariant D
328     ANN = A * N**N
329     """
330     # Safety checks
331     assert ANN > MIN_A - 1 and ANN < MAX_A + 1  # dev: unsafe values A
332     assert gamma > MIN_GAMMA - 1 and gamma < MAX_GAMMA + 1  # dev: unsafe values gamma
333     assert D > 10**17 - 1 and D < 10**15 * 10**18 + 1 # dev: unsafe values D
334 
335     x_j: uint256 = x[1 - i]
336     y: uint256 = D**2 / (x_j * N_COINS**2)
337     K0_i: uint256 = (10**18 * N_COINS) * x_j / D
338     # S_i = x_j
339 
340     # frac = x_j * 1e18 / D => frac = K0_i / N_COINS
341     assert (K0_i > 10**16*N_COINS - 1) and (K0_i < 10**20*N_COINS + 1)  # dev: unsafe values x[i]
342 
343     # x_sorted: uint256[N_COINS] = x
344     # x_sorted[i] = 0
345     # x_sorted = self.sort(x_sorted)  # From high to low
346     # x[not i] instead of x_sorted since x_soted has only 1 element
347 
348     convergence_limit: uint256 = max(max(x_j / 10**14, D / 10**14), 100)
349 
350     for j in range(255):
351         y_prev: uint256 = y
352 
353         K0: uint256 = K0_i * y * N_COINS / D
354         S: uint256 = x_j + y
355 
356         _g1k0: uint256 = gamma + 10**18
357         if _g1k0 > K0:
358             _g1k0 = _g1k0 - K0 + 1
359         else:
360             _g1k0 = K0 - _g1k0 + 1
361 
362         # D / (A * N**N) * _g1k0**2 / gamma**2
363         mul1: uint256 = 10**18 * D / gamma * _g1k0 / gamma * _g1k0 * A_MULTIPLIER / ANN
364 
365         # 2*K0 / _g1k0
366         mul2: uint256 = 10**18 + (2 * 10**18) * K0 / _g1k0
367 
368         yfprime: uint256 = 10**18 * y + S * mul2 + mul1
369         _dyfprime: uint256 = D * mul2
370         if yfprime < _dyfprime:
371             y = y_prev / 2
372             continue
373         else:
374             yfprime -= _dyfprime
375         fprime: uint256 = yfprime / y
376 
377         # y -= f / f_prime;  y = (y * fprime - f) / fprime
378         # y = (yfprime + 10**18 * D - 10**18 * S) // fprime + mul1 // fprime * (10**18 - K0) // K0
379         y_minus: uint256 = mul1 / fprime
380         y_plus: uint256 = (yfprime + 10**18 * D) / fprime + y_minus * 10**18 / K0
381         y_minus += 10**18 * S / fprime
382 
383         if y_plus < y_minus:
384             y = y_prev / 2
385         else:
386             y = y_plus - y_minus
387 
388         diff: uint256 = 0
389         if y > y_prev:
390             diff = y - y_prev
391         else:
392             diff = y_prev - y
393         if diff < max(convergence_limit, y / 10**14):
394             frac: uint256 = y * 10**18 / D
395             assert (frac > 10**16 - 1) and (frac < 10**20 + 1)  # dev: unsafe value for y
396             return y
397 
398     raise "Did not converge"
399 
400 
401 @internal
402 @pure
403 def halfpow(power: uint256) -> uint256:
404     """
405     1e18 * 0.5 ** (power/1e18)
406 
407     Inspired by: https://github.com/balancer-labs/balancer-core/blob/master/contracts/BNum.sol#L128
408     """
409     intpow: uint256 = power / 10**18
410     otherpow: uint256 = power - intpow * 10**18
411     if intpow > 59:
412         return 0
413     result: uint256 = 10**18 / (2**intpow)
414     if otherpow == 0:
415         return result
416 
417     term: uint256 = 10**18
418     x: uint256 = 5 * 10**17
419     S: uint256 = 10**18
420     neg: bool = False
421 
422     for i in range(1, 256):
423         K: uint256 = i * 10**18
424         c: uint256 = K - 10**18
425         if otherpow > c:
426             c = otherpow - c
427             neg = not neg
428         else:
429             c -= otherpow
430         term = term * (c * x / 10**18) / K
431         if neg:
432             S -= term
433         else:
434             S += term
435         if term < EXP_PRECISION:
436             return result * S / 10**18
437 
438     raise "Did not converge"
439 ### end of Math functions
440 
441 
442 @external
443 @view
444 def token() -> address:
445     return token
446 
447 
448 @external
449 @view
450 def coins(i: uint256) -> address:
451     _coins: address[N_COINS] = coins
452     return _coins[i]
453 
454 
455 @internal
456 @view
457 def xp() -> uint256[N_COINS]:
458     return [self.balances[0] * PRECISIONS[0],
459             self.balances[1] * PRECISIONS[1] * self.price_scale / PRECISION]
460 
461 
462 @view
463 @internal
464 def _A_gamma() -> uint256[2]:
465     t1: uint256 = self.future_A_gamma_time
466 
467     A_gamma_1: uint256 = self.future_A_gamma
468     gamma1: uint256 = bitwise_and(A_gamma_1, 2**128-1)
469     A1: uint256 = shift(A_gamma_1, -128)
470 
471     if block.timestamp < t1:
472         # handle ramping up and down of A
473         A_gamma_0: uint256 = self.initial_A_gamma
474         t0: uint256 = self.initial_A_gamma_time
475 
476         # Less readable but more compact way of writing and converting to uint256
477         # gamma0: uint256 = bitwise_and(A_gamma_0, 2**128-1)
478         # A0: uint256 = shift(A_gamma_0, -128)
479         # A1 = A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
480         # gamma1 = gamma0 + (gamma1 - gamma0) * (block.timestamp - t0) / (t1 - t0)
481 
482         t1 -= t0
483         t0 = block.timestamp - t0
484         t2: uint256 = t1 - t0
485 
486         A1 = (shift(A_gamma_0, -128) * t2 + A1 * t0) / t1
487         gamma1 = (bitwise_and(A_gamma_0, 2**128-1) * t2 + gamma1 * t0) / t1
488 
489     return [A1, gamma1]
490 
491 
492 @view
493 @external
494 def A() -> uint256:
495     return self._A_gamma()[0]
496 
497 
498 @view
499 @external
500 def gamma() -> uint256:
501     return self._A_gamma()[1]
502 
503 
504 @internal
505 @view
506 def _fee(xp: uint256[N_COINS]) -> uint256:
507     """
508     f = fee_gamma / (fee_gamma + (1 - K))
509     where
510     K = prod(x) / (sum(x) / N)**N
511     (all normalized to 1e18)
512     """
513     fee_gamma: uint256 = self.fee_gamma
514     f: uint256 = xp[0] + xp[1]  # sum
515     f = fee_gamma * 10**18 / (
516         fee_gamma + 10**18 - (10**18 * N_COINS**N_COINS) * xp[0] / f * xp[1] / f
517     )
518     return (self.mid_fee * f + self.out_fee * (10**18 - f)) / 10**18
519 
520 
521 @external
522 @view
523 def fee() -> uint256:
524     return self._fee(self.xp())
525 
526 
527 @internal
528 @view
529 def get_xcp(D: uint256) -> uint256:
530     x: uint256[N_COINS] = [D / N_COINS, D * PRECISION / (self.price_scale * N_COINS)]
531     return self.geometric_mean(x, True)
532 
533 
534 @external
535 @view
536 def get_virtual_price() -> uint256:
537     return 10**18 * self.get_xcp(self.D) / CurveToken(token).totalSupply()
538 
539 
540 @internal
541 def _claim_admin_fees():
542     A_gamma: uint256[2] = self._A_gamma()
543 
544     xcp_profit: uint256 = self.xcp_profit
545     xcp_profit_a: uint256 = self.xcp_profit_a
546 
547     # Gulp here
548     _coins: address[N_COINS] = coins
549     for i in range(N_COINS):
550         self.balances[i] = ERC20(_coins[i]).balanceOf(self)
551 
552     vprice: uint256 = self.virtual_price
553 
554     if xcp_profit > xcp_profit_a:
555         fees: uint256 = (xcp_profit - xcp_profit_a) * self.admin_fee / (2 * 10**10)
556         if fees > 0:
557             receiver: address = self.admin_fee_receiver
558             if receiver != ZERO_ADDRESS:
559                 frac: uint256 = vprice * 10**18 / (vprice - fees) - 10**18
560                 claimed: uint256 = CurveToken(token).mint_relative(receiver, frac)
561                 xcp_profit -= fees*2
562                 self.xcp_profit = xcp_profit
563                 log ClaimAdminFee(receiver, claimed)
564 
565     total_supply: uint256 = CurveToken(token).totalSupply()
566 
567     # Recalculate D b/c we gulped
568     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], self.xp())
569     self.D = D
570 
571     self.virtual_price = 10**18 * self.get_xcp(D) / total_supply
572 
573     if xcp_profit > xcp_profit_a:
574         self.xcp_profit_a = xcp_profit
575 
576 
577 @internal
578 def tweak_price(A_gamma: uint256[2],_xp: uint256[N_COINS], p_i: uint256, new_D: uint256):
579     price_oracle: uint256 = self.price_oracle
580     last_prices: uint256 = self.last_prices
581     price_scale: uint256 = self.price_scale
582     last_prices_timestamp: uint256 = self.last_prices_timestamp
583     p_new: uint256 = 0
584 
585     if last_prices_timestamp < block.timestamp:
586         # MA update required
587         ma_half_time: uint256 = self.ma_half_time
588         alpha: uint256 = self.halfpow((block.timestamp - last_prices_timestamp) * 10**18 / ma_half_time)
589         price_oracle = (last_prices * (10**18 - alpha) + price_oracle * alpha) / 10**18
590         self.price_oracle = price_oracle
591         self.last_prices_timestamp = block.timestamp
592 
593     D_unadjusted: uint256 = new_D  # Withdrawal methods know new D already
594     if new_D == 0:
595         # We will need this a few times (35k gas)
596         D_unadjusted = self.newton_D(A_gamma[0], A_gamma[1], _xp)
597 
598     if p_i > 0:
599         last_prices = p_i
600 
601     else:
602         # calculate real prices
603         __xp: uint256[N_COINS] = _xp
604         dx_price: uint256 = __xp[0] / 10**6
605         __xp[0] += dx_price
606         last_prices = price_scale * dx_price / (_xp[1] - self.newton_y(A_gamma[0], A_gamma[1], __xp, D_unadjusted, 1))
607 
608     self.last_prices = last_prices
609 
610     total_supply: uint256 = CurveToken(token).totalSupply()
611     old_xcp_profit: uint256 = self.xcp_profit
612     old_virtual_price: uint256 = self.virtual_price
613 
614     # Update profit numbers without price adjustment first
615     xp: uint256[N_COINS] = [D_unadjusted / N_COINS, D_unadjusted * PRECISION / (N_COINS * price_scale)]
616     xcp_profit: uint256 = 10**18
617     virtual_price: uint256 = 10**18
618 
619     if old_virtual_price > 0:
620         xcp: uint256 = self.geometric_mean(xp, True)
621         virtual_price = 10**18 * xcp / total_supply
622         xcp_profit = old_xcp_profit * virtual_price / old_virtual_price
623 
624         t: uint256 = self.future_A_gamma_time
625         if virtual_price < old_virtual_price and t == 0:
626             raise "Loss"
627         if t == 1:
628             self.future_A_gamma_time = 0
629 
630     self.xcp_profit = xcp_profit
631 
632     needs_adjustment: bool = self.not_adjusted
633     # if not needs_adjustment and (virtual_price-10**18 > (xcp_profit-10**18)/2 + self.allowed_extra_profit):
634     # (re-arrange for gas efficiency)
635     if not needs_adjustment and (virtual_price * 2 - 10**18 > xcp_profit + 2*self.allowed_extra_profit):
636         needs_adjustment = True
637         self.not_adjusted = True
638 
639     if needs_adjustment:
640         adjustment_step: uint256 = self.adjustment_step
641         norm: uint256 = price_oracle * 10**18 / price_scale
642         if norm > 10**18:
643             norm -= 10**18
644         else:
645             norm = 10**18 - norm
646 
647         if norm > adjustment_step and old_virtual_price > 0:
648             p_new = (price_scale * (norm - adjustment_step) + adjustment_step * price_oracle) / norm
649 
650             # Calculate balances*prices
651             xp = [_xp[0], _xp[1] * p_new / price_scale]
652 
653             # Calculate "extended constant product" invariant xCP and virtual price
654             D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
655             xp = [D / N_COINS, D * PRECISION / (N_COINS * p_new)]
656             # We reuse old_virtual_price here but it's not old anymore
657             old_virtual_price = 10**18 * self.geometric_mean(xp, True) / total_supply
658 
659             # Proceed if we've got enough profit
660             # if (old_virtual_price > 10**18) and (2 * (old_virtual_price - 10**18) > xcp_profit - 10**18):
661             if (old_virtual_price > 10**18) and (2 * old_virtual_price - 10**18 > xcp_profit):
662                 self.price_scale = p_new
663                 self.D = D
664                 self.virtual_price = old_virtual_price
665 
666                 return
667 
668             else:
669                 self.not_adjusted = False
670 
671                 # Can instead do another flag variable if we want to save bytespace
672                 self.D = D_unadjusted
673                 self.virtual_price = virtual_price
674                 self._claim_admin_fees()
675 
676                 return
677 
678     # If we are here, the price_scale adjustment did not happen
679     # Still need to update the profit counter and D
680     self.D = D_unadjusted
681     self.virtual_price = virtual_price
682 
683 
684 
685 @external
686 @nonreentrant('lock')
687 def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256) -> uint256:
688     assert not self.is_killed  # dev: the pool is killed
689     assert i != j  # dev: coin index out of range
690     assert i < N_COINS  # dev: coin index out of range
691     assert j < N_COINS  # dev: coin index out of range
692     assert dx > 0  # dev: do not exchange 0 coins
693 
694     A_gamma: uint256[2] = self._A_gamma()
695     xp: uint256[N_COINS] = self.balances
696     p: uint256 = 0
697     dy: uint256 = 0
698 
699     _coins: address[N_COINS] = coins
700     assert ERC20(_coins[i]).transferFrom(msg.sender, self, dx)
701 
702     y: uint256 = xp[j]
703     x0: uint256 = xp[i]
704     xp[i] = x0 + dx
705     self.balances[i] = xp[i]
706 
707     price_scale: uint256 = self.price_scale
708 
709     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale * PRECISIONS[1] / PRECISION]
710 
711     prec_i: uint256 = PRECISIONS[0]
712     prec_j: uint256 = PRECISIONS[1]
713     if i == 1:
714         prec_i = PRECISIONS[1]
715         prec_j = PRECISIONS[0]
716 
717     # In case ramp is happening
718     t: uint256 = self.future_A_gamma_time
719     if t > 0:
720         x0 *= prec_i
721         if i > 0:
722             x0 = x0 * price_scale / PRECISION
723         x1: uint256 = xp[i]  # Back up old value in xp
724         xp[i] = x0
725         self.D = self.newton_D(A_gamma[0], A_gamma[1], xp)
726         xp[i] = x1  # And restore
727         if block.timestamp >= t:
728             self.future_A_gamma_time = 1
729 
730     dy = xp[j] - self.newton_y(A_gamma[0], A_gamma[1], xp, self.D, j)
731     # Not defining new "y" here to have less variables / make subsequent calls cheaper
732     xp[j] -= dy
733     dy -= 1
734 
735     if j > 0:
736         dy = dy * PRECISION / price_scale
737     dy /= prec_j
738 
739     dy -= self._fee(xp) * dy / 10**10
740     assert dy >= min_dy, "Slippage"
741     y -= dy
742 
743     self.balances[j] = y
744     assert ERC20(_coins[j]).transfer(msg.sender, dy)
745 
746     y *= prec_j
747     if j > 0:
748         y = y * price_scale / PRECISION
749     xp[j] = y
750 
751     # Calculate price
752     if dx > 10**5 and dy > 10**5:
753         _dx: uint256 = dx * prec_i
754         _dy: uint256 = dy * prec_j
755         if i == 0:
756             p = _dx * 10**18 / _dy
757         else:  # j == 0
758             p = _dy * 10**18 / _dx
759 
760     self.tweak_price(A_gamma, xp, p, 0)
761 
762     log TokenExchange(msg.sender, i, dx, j, dy)
763 
764     return dy
765 
766 
767 @external
768 @view
769 def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256:
770     assert i != j  # dev: same input and output coin
771     assert i < N_COINS  # dev: coin index out of range
772     assert j < N_COINS  # dev: coin index out of range
773 
774     price_scale: uint256 = self.price_scale * PRECISIONS[1]
775     xp: uint256[N_COINS] = self.balances
776 
777     A_gamma: uint256[2] = self._A_gamma()
778     D: uint256 = self.D
779     if self.future_A_gamma_time > 0:
780         D = self.newton_D(A_gamma[0], A_gamma[1], self.xp())
781 
782     xp[i] += dx
783     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale / PRECISION]
784 
785     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, j)
786     dy: uint256 = xp[j] - y - 1
787     xp[j] = y
788     if j > 0:
789         dy = dy * PRECISION / price_scale
790     else:
791         dy /= PRECISIONS[0]
792     dy -= self._fee(xp) * dy / 10**10
793 
794     return dy
795 
796 
797 @view
798 @internal
799 def _calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
800     # fee = sum(amounts_i - avg(amounts)) * fee' / sum(amounts)
801     fee: uint256 = self._fee(xp) * N_COINS / (4 * (N_COINS-1))
802     S: uint256 = 0
803     for _x in amounts:
804         S += _x
805     avg: uint256 = S / N_COINS
806     Sdiff: uint256 = 0
807     for _x in amounts:
808         if _x > avg:
809             Sdiff += _x - avg
810         else:
811             Sdiff += avg - _x
812     return fee * Sdiff / S + NOISE_FEE
813 
814 
815 @external
816 @nonreentrant('lock')
817 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256:
818     assert not self.is_killed  # dev: the pool is killed
819 
820     A_gamma: uint256[2] = self._A_gamma()
821 
822     _coins: address[N_COINS] = coins
823 
824     xp: uint256[N_COINS] = self.balances
825     amountsp: uint256[N_COINS] = empty(uint256[N_COINS])
826     xx: uint256[N_COINS] = empty(uint256[N_COINS])
827     d_token: uint256 = 0
828     d_token_fee: uint256 = 0
829     old_D: uint256 = 0
830 
831     xp_old: uint256[N_COINS] = xp
832 
833     for i in range(N_COINS):
834         bal: uint256 = xp[i] + amounts[i]
835         xp[i] = bal
836         self.balances[i] = bal
837     xx = xp
838 
839     price_scale: uint256 = self.price_scale * PRECISIONS[1]
840     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale / PRECISION]
841     xp_old = [xp_old[0] * PRECISIONS[0], xp_old[1] * price_scale / PRECISION]
842 
843     for i in range(N_COINS):
844         if amounts[i] > 0:
845             assert ERC20(_coins[i]).transferFrom(msg.sender, self, amounts[i])
846             amountsp[i] = xp[i] - xp_old[i]
847     assert amounts[0] > 0 or amounts[1] > 0  # dev: no coins to add
848 
849     t: uint256 = self.future_A_gamma_time
850     if t > 0:
851         old_D = self.newton_D(A_gamma[0], A_gamma[1], xp_old)
852         if block.timestamp >= t:
853             self.future_A_gamma_time = 1
854     else:
855         old_D = self.D
856 
857     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
858 
859     token_supply: uint256 = CurveToken(token).totalSupply()
860     if old_D > 0:
861         d_token = token_supply * D / old_D - token_supply
862     else:
863         d_token = self.get_xcp(D)  # making initial virtual price equal to 1
864     assert d_token > 0  # dev: nothing minted
865 
866     if old_D > 0:
867         d_token_fee = self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
868         d_token -= d_token_fee
869         token_supply += d_token
870         CurveToken(token).mint(msg.sender, d_token)
871 
872         # Calculate price
873         # p_i * (dx_i - dtoken / token_supply * xx_i) = sum{k!=i}(p_k * (dtoken / token_supply * xx_k - dx_k))
874         # Simplified for 2 coins
875         p: uint256 = 0
876         if d_token > 10**5:
877             if amounts[0] == 0 or amounts[1] == 0:
878                 S: uint256 = 0
879                 precision: uint256 = 0
880                 ix: uint256 = 0
881                 if amounts[0] == 0:
882                     S = xx[0] * PRECISIONS[0]
883                     precision = PRECISIONS[1]
884                     ix = 1
885                 else:
886                     S = xx[1] * PRECISIONS[1]
887                     precision = PRECISIONS[0]
888                 S = S * d_token / token_supply
889                 p = S * PRECISION / (amounts[ix] * precision - d_token * xx[ix] * precision / token_supply)
890                 if ix == 0:
891                     p = (10**18)**2 / p
892 
893         self.tweak_price(A_gamma, xp, p, D)
894 
895     else:
896         self.D = D
897         self.virtual_price = 10**18
898         self.xcp_profit = 10**18
899         CurveToken(token).mint(msg.sender, d_token)
900 
901     assert d_token >= min_mint_amount, "Slippage"
902 
903     log AddLiquidity(msg.sender, amounts, d_token_fee, token_supply)
904 
905     return d_token
906 
907 
908 @external
909 @nonreentrant('lock')
910 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]):
911     """
912     This withdrawal method is very safe, does no complex math
913     """
914     _coins: address[N_COINS] = coins
915     total_supply: uint256 = CurveToken(token).totalSupply()
916     CurveToken(token).burnFrom(msg.sender, _amount)
917     balances: uint256[N_COINS] = self.balances
918     amount: uint256 = _amount - 1  # Make rounding errors favoring other LPs a tiny bit
919 
920     for i in range(N_COINS):
921         d_balance: uint256 = balances[i] * amount / total_supply
922         assert d_balance >= min_amounts[i]
923         self.balances[i] = balances[i] - d_balance
924         balances[i] = d_balance  # now it's the amounts going out
925         assert ERC20(_coins[i]).transfer(msg.sender, d_balance)
926 
927     D: uint256 = self.D
928     self.D = D - D * amount / total_supply
929 
930     log RemoveLiquidity(msg.sender, balances, total_supply - _amount)
931 
932 
933 @view
934 @external
935 def calc_token_amount(amounts: uint256[N_COINS]) -> uint256:
936     token_supply: uint256 = CurveToken(token).totalSupply()
937     price_scale: uint256 = self.price_scale * PRECISIONS[1]
938     A_gamma: uint256[2] = self._A_gamma()
939     xp: uint256[N_COINS] = self.xp()
940     amountsp: uint256[N_COINS] = [
941         amounts[0] * PRECISIONS[0],
942         amounts[1] * price_scale / PRECISION]
943     D0: uint256 = self.D
944     if self.future_A_gamma_time > 0:
945         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
946     xp[0] += amountsp[0]
947     xp[1] += amountsp[1]
948     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
949     d_token: uint256 = token_supply * D / D0 - token_supply
950     d_token -= self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
951     return d_token
952 
953 
954 @internal
955 @view
956 def _calc_withdraw_one_coin(A_gamma: uint256[2], token_amount: uint256, i: uint256, update_D: bool,
957                             calc_price: bool) -> (uint256, uint256, uint256, uint256[N_COINS]):
958     token_supply: uint256 = CurveToken(token).totalSupply()
959     assert token_amount <= token_supply  # dev: token amount more than supply
960     assert i < N_COINS  # dev: coin out of range
961 
962     xx: uint256[N_COINS] = self.balances
963     D0: uint256 = 0
964 
965     price_scale_i: uint256 = self.price_scale * PRECISIONS[1]
966     xp: uint256[N_COINS] = [xx[0] * PRECISIONS[0], xx[1] * price_scale_i / PRECISION]
967     if i == 0:
968         price_scale_i = PRECISION * PRECISIONS[0]
969 
970     if update_D:
971         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
972     else:
973         D0 = self.D
974 
975     D: uint256 = D0
976 
977     # Charge the fee on D, not on y, e.g. reducing invariant LESS than charging the user
978     fee: uint256 = self._fee(xp)
979     dD: uint256 = token_amount * D / token_supply
980     D -= (dD - (fee * dD / (2 * 10**10) + 1))
981     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, i)
982     dy: uint256 = (xp[i] - y) * PRECISION / price_scale_i
983     xp[i] = y
984 
985     # Price calc
986     p: uint256 = 0
987     if calc_price and dy > 10**5 and token_amount > 10**5:
988         # p_i = dD / D0 * sum'(p_k * x_k) / (dy - dD / D0 * y0)
989         S: uint256 = 0
990         precision: uint256 = PRECISIONS[0]
991         if i == 1:
992             S = xx[0] * PRECISIONS[0]
993             precision = PRECISIONS[1]
994         else:
995             S = xx[1] * PRECISIONS[1]
996         S = S * dD / D0
997         p = S * PRECISION / (dy * precision - dD * xx[i] * precision / D0)
998         if i == 0:
999             p = (10**18)**2 / p
1000 
1001     return dy, p, D, xp
1002 
1003 
1004 @view
1005 @external
1006 def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256:
1007     return self._calc_withdraw_one_coin(self._A_gamma(), token_amount, i, True, False)[0]
1008 
1009 
1010 @external
1011 @nonreentrant('lock')
1012 def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256) -> uint256:
1013     assert not self.is_killed  # dev: the pool is killed
1014 
1015     A_gamma: uint256[2] = self._A_gamma()
1016 
1017     dy: uint256 = 0
1018     D: uint256 = 0
1019     p: uint256 = 0
1020     xp: uint256[N_COINS] = empty(uint256[N_COINS])
1021     future_A_gamma_time: uint256 = self.future_A_gamma_time
1022     dy, p, D, xp = self._calc_withdraw_one_coin(A_gamma, token_amount, i, (future_A_gamma_time > 0), True)
1023     assert dy >= min_amount, "Slippage"
1024 
1025     if block.timestamp >= future_A_gamma_time:
1026         self.future_A_gamma_time = 1
1027 
1028     self.balances[i] -= dy
1029     CurveToken(token).burnFrom(msg.sender, token_amount)
1030 
1031     _coins: address[N_COINS] = coins
1032     assert ERC20(_coins[i]).transfer(msg.sender, dy)
1033 
1034     self.tweak_price(A_gamma, xp, p, D)
1035 
1036     log RemoveLiquidityOne(msg.sender, token_amount, i, dy)
1037 
1038     return dy
1039 
1040 
1041 @external
1042 @nonreentrant('lock')
1043 def claim_admin_fees():
1044     self._claim_admin_fees()
1045 
1046 
1047 # Admin parameters
1048 @external
1049 def ramp_A_gamma(future_A: uint256, future_gamma: uint256, future_time: uint256):
1050     assert msg.sender == self.owner  # dev: only owner
1051     assert block.timestamp > self.initial_A_gamma_time + (MIN_RAMP_TIME-1)
1052     assert future_time > block.timestamp + (MIN_RAMP_TIME-1)  # dev: insufficient time
1053 
1054     A_gamma: uint256[2] = self._A_gamma()
1055     initial_A_gamma: uint256 = shift(A_gamma[0], 128)
1056     initial_A_gamma = bitwise_or(initial_A_gamma, A_gamma[1])
1057 
1058     assert future_A > MIN_A-1
1059     assert future_A < MAX_A+1
1060     assert future_gamma > MIN_GAMMA-1
1061     assert future_gamma < MAX_GAMMA+1
1062 
1063     ratio: uint256 = 10**18 * future_A / A_gamma[0]
1064     assert ratio < 10**18 * MAX_A_CHANGE + 1
1065     assert ratio > 10**18 / MAX_A_CHANGE - 1
1066 
1067     ratio = 10**18 * future_gamma / A_gamma[1]
1068     assert ratio < 10**18 * MAX_A_CHANGE + 1
1069     assert ratio > 10**18 / MAX_A_CHANGE - 1
1070 
1071     self.initial_A_gamma = initial_A_gamma
1072     self.initial_A_gamma_time = block.timestamp
1073 
1074     future_A_gamma: uint256 = shift(future_A, 128)
1075     future_A_gamma = bitwise_or(future_A_gamma, future_gamma)
1076     self.future_A_gamma_time = future_time
1077     self.future_A_gamma = future_A_gamma
1078 
1079     log RampAgamma(A_gamma[0], future_A, A_gamma[1], future_gamma, block.timestamp, future_time)
1080 
1081 
1082 @external
1083 def stop_ramp_A_gamma():
1084     assert msg.sender == self.owner  # dev: only owner
1085 
1086     A_gamma: uint256[2] = self._A_gamma()
1087     current_A_gamma: uint256 = shift(A_gamma[0], 128)
1088     current_A_gamma = bitwise_or(current_A_gamma, A_gamma[1])
1089     self.initial_A_gamma = current_A_gamma
1090     self.future_A_gamma = current_A_gamma
1091     self.initial_A_gamma_time = block.timestamp
1092     self.future_A_gamma_time = block.timestamp
1093     # now (block.timestamp < t1) is always False, so we return saved A
1094 
1095     log StopRampA(A_gamma[0], A_gamma[1], block.timestamp)
1096 
1097 
1098 @external
1099 def commit_new_parameters(
1100     _new_mid_fee: uint256,
1101     _new_out_fee: uint256,
1102     _new_admin_fee: uint256,
1103     _new_fee_gamma: uint256,
1104     _new_allowed_extra_profit: uint256,
1105     _new_adjustment_step: uint256,
1106     _new_ma_half_time: uint256,
1107     ):
1108     assert msg.sender == self.owner  # dev: only owner
1109     assert self.admin_actions_deadline == 0  # dev: active action
1110 
1111     new_mid_fee: uint256 = _new_mid_fee
1112     new_out_fee: uint256 = _new_out_fee
1113     new_admin_fee: uint256 = _new_admin_fee
1114     new_fee_gamma: uint256 = _new_fee_gamma
1115     new_allowed_extra_profit: uint256 = _new_allowed_extra_profit
1116     new_adjustment_step: uint256 = _new_adjustment_step
1117     new_ma_half_time: uint256 = _new_ma_half_time
1118 
1119     # Fees
1120     if new_out_fee < MAX_FEE+1:
1121         assert new_out_fee > MIN_FEE-1  # dev: fee is out of range
1122     else:
1123         new_out_fee = self.out_fee
1124     if new_mid_fee > MAX_FEE:
1125         new_mid_fee = self.mid_fee
1126     assert new_mid_fee <= new_out_fee  # dev: mid-fee is too high
1127     if new_admin_fee > MAX_ADMIN_FEE:
1128         new_admin_fee = self.admin_fee
1129 
1130     # AMM parameters
1131     if new_fee_gamma < 10**18:
1132         assert new_fee_gamma > 0  # dev: fee_gamma out of range [1 .. 10**18]
1133     else:
1134         new_fee_gamma = self.fee_gamma
1135     if new_allowed_extra_profit > 10**18:
1136         new_allowed_extra_profit = self.allowed_extra_profit
1137     if new_adjustment_step > 10**18:
1138         new_adjustment_step = self.adjustment_step
1139 
1140     # MA
1141     if new_ma_half_time < 7*86400:
1142         assert new_ma_half_time > 0  # dev: MA time should be longer than 1 second
1143     else:
1144         new_ma_half_time = self.ma_half_time
1145 
1146     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1147     self.admin_actions_deadline = _deadline
1148 
1149     self.future_admin_fee = new_admin_fee
1150     self.future_mid_fee = new_mid_fee
1151     self.future_out_fee = new_out_fee
1152     self.future_fee_gamma = new_fee_gamma
1153     self.future_allowed_extra_profit = new_allowed_extra_profit
1154     self.future_adjustment_step = new_adjustment_step
1155     self.future_ma_half_time = new_ma_half_time
1156 
1157     log CommitNewParameters(_deadline, new_admin_fee, new_mid_fee, new_out_fee,
1158                             new_fee_gamma,
1159                             new_allowed_extra_profit, new_adjustment_step,
1160                             new_ma_half_time)
1161 
1162 
1163 @external
1164 @nonreentrant('lock')
1165 def apply_new_parameters():
1166     assert msg.sender == self.owner  # dev: only owner
1167     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
1168     assert self.admin_actions_deadline != 0  # dev: no active action
1169 
1170     self.admin_actions_deadline = 0
1171 
1172     admin_fee: uint256 = self.future_admin_fee
1173     if self.admin_fee != admin_fee:
1174         self._claim_admin_fees()
1175         self.admin_fee = admin_fee
1176 
1177     mid_fee: uint256 = self.future_mid_fee
1178     self.mid_fee = mid_fee
1179     out_fee: uint256 = self.future_out_fee
1180     self.out_fee = out_fee
1181     fee_gamma: uint256 = self.future_fee_gamma
1182     self.fee_gamma = fee_gamma
1183     allowed_extra_profit: uint256 = self.future_allowed_extra_profit
1184     self.allowed_extra_profit = allowed_extra_profit
1185     adjustment_step: uint256 = self.future_adjustment_step
1186     self.adjustment_step = adjustment_step
1187     ma_half_time: uint256 = self.future_ma_half_time
1188     self.ma_half_time = ma_half_time
1189 
1190     log NewParameters(admin_fee, mid_fee, out_fee,
1191                       fee_gamma,
1192                       allowed_extra_profit, adjustment_step,
1193                       ma_half_time)
1194 
1195 
1196 @external
1197 def revert_new_parameters():
1198     assert msg.sender == self.owner  # dev: only owner
1199 
1200     self.admin_actions_deadline = 0
1201 
1202 
1203 @external
1204 def commit_transfer_ownership(_owner: address):
1205     assert msg.sender == self.owner  # dev: only owner
1206     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1207 
1208     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1209     self.transfer_ownership_deadline = _deadline
1210     self.future_owner = _owner
1211 
1212     log CommitNewAdmin(_deadline, _owner)
1213 
1214 
1215 @external
1216 def apply_transfer_ownership():
1217     assert msg.sender == self.owner  # dev: only owner
1218     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1219     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1220 
1221     self.transfer_ownership_deadline = 0
1222     _owner: address = self.future_owner
1223     self.owner = _owner
1224 
1225     log NewAdmin(_owner)
1226 
1227 
1228 @external
1229 def revert_transfer_ownership():
1230     assert msg.sender == self.owner  # dev: only owner
1231 
1232     self.transfer_ownership_deadline = 0
1233 
1234 
1235 @external
1236 def kill_me():
1237     assert msg.sender == self.owner  # dev: only owner
1238     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1239     self.is_killed = True
1240 
1241 
1242 @external
1243 def unkill_me():
1244     assert msg.sender == self.owner  # dev: only owner
1245     self.is_killed = False
1246 
1247 
1248 @external
1249 def set_admin_fee_receiver(_admin_fee_receiver: address):
1250     assert msg.sender == self.owner  # dev: only owner
1251     self.admin_fee_receiver = _admin_fee_receiver