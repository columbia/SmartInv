1 # @version 0.3.1
2 # (c) Curve.Fi, 2021
3 # Pool for two crypto assets
4 
5 # Expected coins:
6 # eth/whatever
7 
8 interface CurveToken:
9     def totalSupply() -> uint256: view
10     def mint(_to: address, _value: uint256) -> bool: nonpayable
11     def mint_relative(_to: address, frac: uint256) -> uint256: nonpayable
12     def burnFrom(_to: address, _value: uint256) -> bool: nonpayable
13 
14 interface ERC20:
15     def transfer(_to: address, _value: uint256) -> bool: nonpayable
16     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: nonpayable
17     def decimals() -> uint256: view
18     def balanceOf(_user: address) -> uint256: view
19 
20 interface WETH:
21     def deposit(): payable
22     def withdraw(_amount: uint256): nonpayable
23 
24 
25 # Events
26 event TokenExchange:
27     buyer: indexed(address)
28     sold_id: uint256
29     tokens_sold: uint256
30     bought_id: uint256
31     tokens_bought: uint256
32 
33 event AddLiquidity:
34     provider: indexed(address)
35     token_amounts: uint256[N_COINS]
36     fee: uint256
37     token_supply: uint256
38 
39 event RemoveLiquidity:
40     provider: indexed(address)
41     token_amounts: uint256[N_COINS]
42     token_supply: uint256
43 
44 event RemoveLiquidityOne:
45     provider: indexed(address)
46     token_amount: uint256
47     coin_index: uint256
48     coin_amount: uint256
49 
50 event CommitNewAdmin:
51     deadline: indexed(uint256)
52     admin: indexed(address)
53 
54 event NewAdmin:
55     admin: indexed(address)
56 
57 event CommitNewParameters:
58     deadline: indexed(uint256)
59     admin_fee: uint256
60     mid_fee: uint256
61     out_fee: uint256
62     fee_gamma: uint256
63     allowed_extra_profit: uint256
64     adjustment_step: uint256
65     ma_half_time: uint256
66 
67 event NewParameters:
68     admin_fee: uint256
69     mid_fee: uint256
70     out_fee: uint256
71     fee_gamma: uint256
72     allowed_extra_profit: uint256
73     adjustment_step: uint256
74     ma_half_time: uint256
75 
76 event RampAgamma:
77     initial_A: uint256
78     future_A: uint256
79     initial_gamma: uint256
80     future_gamma: uint256
81     initial_time: uint256
82     future_time: uint256
83 
84 event StopRampA:
85     current_A: uint256
86     current_gamma: uint256
87     time: uint256
88 
89 event ClaimAdminFee:
90     admin: indexed(address)
91     tokens: uint256
92 
93 
94 N_COINS: constant(int128) = 2
95 PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to
96 A_MULTIPLIER: constant(uint256) = 10000
97 
98 token: immutable(address)
99 coins: immutable(address[N_COINS])
100 
101 price_scale: public(uint256)   # Internal price scale
102 price_oracle: public(uint256)  # Price target given by MA
103 
104 last_prices: public(uint256)
105 last_prices_timestamp: public(uint256)
106 
107 initial_A_gamma: public(uint256)
108 future_A_gamma: public(uint256)
109 initial_A_gamma_time: public(uint256)
110 future_A_gamma_time: public(uint256)
111 
112 allowed_extra_profit: public(uint256)  # 2 * 10**12 - recommended value
113 future_allowed_extra_profit: public(uint256)
114 
115 fee_gamma: public(uint256)
116 future_fee_gamma: public(uint256)
117 
118 adjustment_step: public(uint256)
119 future_adjustment_step: public(uint256)
120 
121 ma_half_time: public(uint256)
122 future_ma_half_time: public(uint256)
123 
124 mid_fee: public(uint256)
125 out_fee: public(uint256)
126 admin_fee: public(uint256)
127 future_mid_fee: public(uint256)
128 future_out_fee: public(uint256)
129 future_admin_fee: public(uint256)
130 
131 balances: public(uint256[N_COINS])
132 D: public(uint256)
133 
134 owner: public(address)
135 future_owner: public(address)
136 
137 xcp_profit: public(uint256)
138 xcp_profit_a: public(uint256)  # Full profit at last claim of admin fees
139 virtual_price: public(uint256)  # Cached (fast to read) virtual price also used internally
140 not_adjusted: bool
141 
142 is_killed: public(bool)
143 kill_deadline: public(uint256)
144 transfer_ownership_deadline: public(uint256)
145 admin_actions_deadline: public(uint256)
146 
147 admin_fee_receiver: public(address)
148 
149 KILL_DEADLINE_DT: constant(uint256) = 2 * 30 * 86400
150 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
151 MIN_RAMP_TIME: constant(uint256) = 86400
152 
153 MAX_ADMIN_FEE: constant(uint256) = 10 * 10 ** 9
154 MIN_FEE: constant(uint256) = 5 * 10 ** 5  # 0.5 bps
155 MAX_FEE: constant(uint256) = 10 * 10 ** 9
156 MAX_A_CHANGE: constant(uint256) = 10
157 NOISE_FEE: constant(uint256) = 10**5  # 0.1 bps
158 
159 MIN_GAMMA: constant(uint256) = 10**10
160 MAX_GAMMA: constant(uint256) = 2 * 10**16
161 
162 MIN_A: constant(uint256) = N_COINS**N_COINS * A_MULTIPLIER / 10
163 MAX_A: constant(uint256) = N_COINS**N_COINS * A_MULTIPLIER * 100000
164 
165 # This must be changed for different N_COINS
166 # For example:
167 # N_COINS = 3 -> 1  (10**18 -> 10**18)
168 # N_COINS = 4 -> 10**8  (10**18 -> 10**10)
169 # PRICE_PRECISION_MUL: constant(uint256) = 1
170 PRECISIONS: immutable(uint256[N_COINS])
171 
172 EXP_PRECISION: constant(uint256) = 10**10
173 
174 ETH_INDEX: constant(uint256) = 0  # Can put it to something big to turn the logic off
175 
176 
177 @external
178 def __init__(
179     owner: address,
180     admin_fee_receiver: address,
181     A: uint256,
182     gamma: uint256,
183     mid_fee: uint256,
184     out_fee: uint256,
185     allowed_extra_profit: uint256,
186     fee_gamma: uint256,
187     adjustment_step: uint256,
188     admin_fee: uint256,
189     ma_half_time: uint256,
190     initial_price: uint256,
191     _token: address,
192     _coins: address[N_COINS]
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
222     token = _token
223     coins = _coins
224     PRECISIONS = [10 ** (18 - ERC20(_coins[0]).decimals()),
225                   10 ** (18 - ERC20(_coins[1]).decimals())]
226 
227 
228 @payable
229 @external
230 def __default__():
231     pass
232 
233 
234 ### Math functions
235 @internal
236 @pure
237 def geometric_mean(unsorted_x: uint256[N_COINS], sort: bool) -> uint256:
238     """
239     (x[0] * x[1] * ...) ** (1/N)
240     """
241     x: uint256[N_COINS] = unsorted_x
242     if sort and x[0] < x[1]:
243         x = [unsorted_x[1], unsorted_x[0]]
244     D: uint256 = x[0]
245     diff: uint256 = 0
246     for i in range(255):
247         D_prev: uint256 = D
248         # tmp: uint256 = 10**18
249         # for _x in x:
250         #     tmp = tmp * _x / D
251         # D = D * ((N_COINS - 1) * 10**18 + tmp) / (N_COINS * 10**18)
252         # line below makes it for 2 coins
253         D = (D + x[0] * x[1] / D) / N_COINS
254         if D > D_prev:
255             diff = D - D_prev
256         else:
257             diff = D_prev - D
258         if diff <= 1 or diff * 10**18 < D:
259             return D
260     raise "Did not converge"
261 
262 
263 @internal
264 @view
265 def newton_D(ANN: uint256, gamma: uint256, x_unsorted: uint256[N_COINS]) -> uint256:
266     """
267     Finding the invariant using Newton method.
268     ANN is higher by the factor A_MULTIPLIER
269     ANN is already A * N**N
270 
271     Currently uses 60k gas
272     """
273     # Safety checks
274     assert ANN > MIN_A - 1 and ANN < MAX_A + 1  # dev: unsafe values A
275     assert gamma > MIN_GAMMA - 1 and gamma < MAX_GAMMA + 1  # dev: unsafe values gamma
276 
277     # Initial value of invariant D is that for constant-product invariant
278     x: uint256[N_COINS] = x_unsorted
279     if x[0] < x[1]:
280         x = [x_unsorted[1], x_unsorted[0]]
281 
282     assert x[0] > 10**9 - 1 and x[0] < 10**15 * 10**18 + 1  # dev: unsafe values x[0]
283     assert x[1] * 10**18 / x[0] > 10**14-1  # dev: unsafe values x[i] (input)
284 
285     D: uint256 = N_COINS * self.geometric_mean(x, False)
286     S: uint256 = x[0] + x[1]
287 
288     for i in range(255):
289         D_prev: uint256 = D
290 
291         # K0: uint256 = 10**18
292         # for _x in x:
293         #     K0 = K0 * _x * N_COINS / D
294         # collapsed for 2 coins
295         K0: uint256 = (10**18 * N_COINS**2) * x[0] / D * x[1] / D
296 
297         _g1k0: uint256 = gamma + 10**18
298         if _g1k0 > K0:
299             _g1k0 = _g1k0 - K0 + 1
300         else:
301             _g1k0 = K0 - _g1k0 + 1
302 
303         # D / (A * N**N) * _g1k0**2 / gamma**2
304         mul1: uint256 = 10**18 * D / gamma * _g1k0 / gamma * _g1k0 * A_MULTIPLIER / ANN
305 
306         # 2*N*K0 / _g1k0
307         mul2: uint256 = (2 * 10**18) * N_COINS * K0 / _g1k0
308 
309         neg_fprime: uint256 = (S + S * mul2 / 10**18) + mul1 * N_COINS / K0 - mul2 * D / 10**18
310 
311         # D -= f / fprime
312         D_plus: uint256 = D * (neg_fprime + S) / neg_fprime
313         D_minus: uint256 = D*D / neg_fprime
314         if 10**18 > K0:
315             D_minus += D * (mul1 / neg_fprime) / 10**18 * (10**18 - K0) / K0
316         else:
317             D_minus -= D * (mul1 / neg_fprime) / 10**18 * (K0 - 10**18) / K0
318 
319         if D_plus > D_minus:
320             D = D_plus - D_minus
321         else:
322             D = (D_minus - D_plus) / 2
323 
324         diff: uint256 = 0
325         if D > D_prev:
326             diff = D - D_prev
327         else:
328             diff = D_prev - D
329         if diff * 10**14 < max(10**16, D):  # Could reduce precision for gas efficiency here
330             # Test that we are safe with the next newton_y
331             for _x in x:
332                 frac: uint256 = _x * 10**18 / D
333                 assert (frac > 10**16 - 1) and (frac < 10**20 + 1)  # dev: unsafe values x[i]
334             return D
335 
336     raise "Did not converge"
337 
338 
339 @internal
340 @pure
341 def newton_y(ANN: uint256, gamma: uint256, x: uint256[N_COINS], D: uint256, i: uint256) -> uint256:
342     """
343     Calculating x[i] given other balances x[0..N_COINS-1] and invariant D
344     ANN = A * N**N
345     """
346     # Safety checks
347     assert ANN > MIN_A - 1 and ANN < MAX_A + 1  # dev: unsafe values A
348     assert gamma > MIN_GAMMA - 1 and gamma < MAX_GAMMA + 1  # dev: unsafe values gamma
349     assert D > 10**17 - 1 and D < 10**15 * 10**18 + 1 # dev: unsafe values D
350 
351     x_j: uint256 = x[1 - i]
352     y: uint256 = D**2 / (x_j * N_COINS**2)
353     K0_i: uint256 = (10**18 * N_COINS) * x_j / D
354     # S_i = x_j
355 
356     # frac = x_j * 1e18 / D => frac = K0_i / N_COINS
357     assert (K0_i > 10**16*N_COINS - 1) and (K0_i < 10**20*N_COINS + 1)  # dev: unsafe values x[i]
358 
359     # x_sorted: uint256[N_COINS] = x
360     # x_sorted[i] = 0
361     # x_sorted = self.sort(x_sorted)  # From high to low
362     # x[not i] instead of x_sorted since x_soted has only 1 element
363 
364     convergence_limit: uint256 = max(max(x_j / 10**14, D / 10**14), 100)
365 
366     for j in range(255):
367         y_prev: uint256 = y
368 
369         K0: uint256 = K0_i * y * N_COINS / D
370         S: uint256 = x_j + y
371 
372         _g1k0: uint256 = gamma + 10**18
373         if _g1k0 > K0:
374             _g1k0 = _g1k0 - K0 + 1
375         else:
376             _g1k0 = K0 - _g1k0 + 1
377 
378         # D / (A * N**N) * _g1k0**2 / gamma**2
379         mul1: uint256 = 10**18 * D / gamma * _g1k0 / gamma * _g1k0 * A_MULTIPLIER / ANN
380 
381         # 2*K0 / _g1k0
382         mul2: uint256 = 10**18 + (2 * 10**18) * K0 / _g1k0
383 
384         yfprime: uint256 = 10**18 * y + S * mul2 + mul1
385         _dyfprime: uint256 = D * mul2
386         if yfprime < _dyfprime:
387             y = y_prev / 2
388             continue
389         else:
390             yfprime -= _dyfprime
391         fprime: uint256 = yfprime / y
392 
393         # y -= f / f_prime;  y = (y * fprime - f) / fprime
394         # y = (yfprime + 10**18 * D - 10**18 * S) // fprime + mul1 // fprime * (10**18 - K0) // K0
395         y_minus: uint256 = mul1 / fprime
396         y_plus: uint256 = (yfprime + 10**18 * D) / fprime + y_minus * 10**18 / K0
397         y_minus += 10**18 * S / fprime
398 
399         if y_plus < y_minus:
400             y = y_prev / 2
401         else:
402             y = y_plus - y_minus
403 
404         diff: uint256 = 0
405         if y > y_prev:
406             diff = y - y_prev
407         else:
408             diff = y_prev - y
409         if diff < max(convergence_limit, y / 10**14):
410             frac: uint256 = y * 10**18 / D
411             assert (frac > 10**16 - 1) and (frac < 10**20 + 1)  # dev: unsafe value for y
412             return y
413 
414     raise "Did not converge"
415 
416 
417 @internal
418 @pure
419 def halfpow(power: uint256) -> uint256:
420     """
421     1e18 * 0.5 ** (power/1e18)
422 
423     Inspired by: https://github.com/balancer-labs/balancer-core/blob/master/contracts/BNum.sol#L128
424     """
425     intpow: uint256 = power / 10**18
426     otherpow: uint256 = power - intpow * 10**18
427     if intpow > 59:
428         return 0
429     result: uint256 = 10**18 / (2**intpow)
430     if otherpow == 0:
431         return result
432 
433     term: uint256 = 10**18
434     x: uint256 = 5 * 10**17
435     S: uint256 = 10**18
436     neg: bool = False
437 
438     for i in range(1, 256):
439         K: uint256 = i * 10**18
440         c: uint256 = K - 10**18
441         if otherpow > c:
442             c = otherpow - c
443             neg = not neg
444         else:
445             c -= otherpow
446         term = term * (c * x / 10**18) / K
447         if neg:
448             S -= term
449         else:
450             S += term
451         if term < EXP_PRECISION:
452             return result * S / 10**18
453 
454     raise "Did not converge"
455 ### end of Math functions
456 
457 
458 @external
459 @view
460 def token() -> address:
461     return token
462 
463 
464 @external
465 @view
466 def coins(i: uint256) -> address:
467     _coins: address[N_COINS] = coins
468     return _coins[i]
469 
470 
471 @internal
472 @view
473 def xp() -> uint256[N_COINS]:
474     return [self.balances[0] * PRECISIONS[0],
475             self.balances[1] * PRECISIONS[1] * self.price_scale / PRECISION]
476 
477 
478 @view
479 @internal
480 def _A_gamma() -> uint256[2]:
481     t1: uint256 = self.future_A_gamma_time
482 
483     A_gamma_1: uint256 = self.future_A_gamma
484     gamma1: uint256 = bitwise_and(A_gamma_1, 2**128-1)
485     A1: uint256 = shift(A_gamma_1, -128)
486 
487     if block.timestamp < t1:
488         # handle ramping up and down of A
489         A_gamma_0: uint256 = self.initial_A_gamma
490         t0: uint256 = self.initial_A_gamma_time
491 
492         # Less readable but more compact way of writing and converting to uint256
493         # gamma0: uint256 = bitwise_and(A_gamma_0, 2**128-1)
494         # A0: uint256 = shift(A_gamma_0, -128)
495         # A1 = A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
496         # gamma1 = gamma0 + (gamma1 - gamma0) * (block.timestamp - t0) / (t1 - t0)
497 
498         t1 -= t0
499         t0 = block.timestamp - t0
500         t2: uint256 = t1 - t0
501 
502         A1 = (shift(A_gamma_0, -128) * t2 + A1 * t0) / t1
503         gamma1 = (bitwise_and(A_gamma_0, 2**128-1) * t2 + gamma1 * t0) / t1
504 
505     return [A1, gamma1]
506 
507 
508 @view
509 @external
510 def A() -> uint256:
511     return self._A_gamma()[0]
512 
513 
514 @view
515 @external
516 def gamma() -> uint256:
517     return self._A_gamma()[1]
518 
519 
520 @internal
521 @view
522 def _fee(xp: uint256[N_COINS]) -> uint256:
523     """
524     f = fee_gamma / (fee_gamma + (1 - K))
525     where
526     K = prod(x) / (sum(x) / N)**N
527     (all normalized to 1e18)
528     """
529     fee_gamma: uint256 = self.fee_gamma
530     f: uint256 = xp[0] + xp[1]  # sum
531     f = fee_gamma * 10**18 / (
532         fee_gamma + 10**18 - (10**18 * N_COINS**N_COINS) * xp[0] / f * xp[1] / f
533     )
534     return (self.mid_fee * f + self.out_fee * (10**18 - f)) / 10**18
535 
536 
537 @external
538 @view
539 def fee() -> uint256:
540     return self._fee(self.xp())
541 
542 
543 @internal
544 @view
545 def get_xcp(D: uint256) -> uint256:
546     x: uint256[N_COINS] = [D / N_COINS, D * PRECISION / (self.price_scale * N_COINS)]
547     return self.geometric_mean(x, True)
548 
549 
550 @external
551 @view
552 def get_virtual_price() -> uint256:
553     return 10**18 * self.get_xcp(self.D) / CurveToken(token).totalSupply()
554 
555 
556 @internal
557 def _claim_admin_fees():
558     A_gamma: uint256[2] = self._A_gamma()
559 
560     xcp_profit: uint256 = self.xcp_profit
561     xcp_profit_a: uint256 = self.xcp_profit_a
562 
563     # Gulp here
564     _coins: address[N_COINS] = coins
565     for i in range(N_COINS):
566         if i == ETH_INDEX:
567             self.balances[i] = self.balance
568         else:
569             self.balances[i] = ERC20(_coins[i]).balanceOf(self)
570 
571     vprice: uint256 = self.virtual_price
572 
573     if xcp_profit > xcp_profit_a:
574         fees: uint256 = (xcp_profit - xcp_profit_a) * self.admin_fee / (2 * 10**10)
575         if fees > 0:
576             receiver: address = self.admin_fee_receiver
577             if receiver != ZERO_ADDRESS:
578                 frac: uint256 = vprice * 10**18 / (vprice - fees) - 10**18
579                 claimed: uint256 = CurveToken(token).mint_relative(receiver, frac)
580                 xcp_profit -= fees*2
581                 self.xcp_profit = xcp_profit
582                 log ClaimAdminFee(receiver, claimed)
583 
584     total_supply: uint256 = CurveToken(token).totalSupply()
585 
586     # Recalculate D b/c we gulped
587     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], self.xp())
588     self.D = D
589 
590     self.virtual_price = 10**18 * self.get_xcp(D) / total_supply
591 
592     if xcp_profit > xcp_profit_a:
593         self.xcp_profit_a = xcp_profit
594 
595 
596 @internal
597 def tweak_price(A_gamma: uint256[2],_xp: uint256[N_COINS], p_i: uint256, new_D: uint256):
598     price_oracle: uint256 = self.price_oracle
599     last_prices: uint256 = self.last_prices
600     price_scale: uint256 = self.price_scale
601     last_prices_timestamp: uint256 = self.last_prices_timestamp
602     p_new: uint256 = 0
603 
604     if last_prices_timestamp < block.timestamp:
605         # MA update required
606         ma_half_time: uint256 = self.ma_half_time
607         alpha: uint256 = self.halfpow((block.timestamp - last_prices_timestamp) * 10**18 / ma_half_time)
608         price_oracle = (last_prices * (10**18 - alpha) + price_oracle * alpha) / 10**18
609         self.price_oracle = price_oracle
610         self.last_prices_timestamp = block.timestamp
611 
612     D_unadjusted: uint256 = new_D  # Withdrawal methods know new D already
613     if new_D == 0:
614         # We will need this a few times (35k gas)
615         D_unadjusted = self.newton_D(A_gamma[0], A_gamma[1], _xp)
616 
617     if p_i > 0:
618         last_prices = p_i
619 
620     else:
621         # calculate real prices
622         __xp: uint256[N_COINS] = _xp
623         dx_price: uint256 = __xp[0] / 10**6
624         __xp[0] += dx_price
625         last_prices = price_scale * dx_price / (_xp[1] - self.newton_y(A_gamma[0], A_gamma[1], __xp, D_unadjusted, 1))
626 
627     self.last_prices = last_prices
628 
629     total_supply: uint256 = CurveToken(token).totalSupply()
630     old_xcp_profit: uint256 = self.xcp_profit
631     old_virtual_price: uint256 = self.virtual_price
632 
633     # Update profit numbers without price adjustment first
634     xp: uint256[N_COINS] = [D_unadjusted / N_COINS, D_unadjusted * PRECISION / (N_COINS * price_scale)]
635     xcp_profit: uint256 = 10**18
636     virtual_price: uint256 = 10**18
637 
638     if old_virtual_price > 0:
639         xcp: uint256 = self.geometric_mean(xp, True)
640         virtual_price = 10**18 * xcp / total_supply
641         xcp_profit = old_xcp_profit * virtual_price / old_virtual_price
642 
643         t: uint256 = self.future_A_gamma_time
644         if virtual_price < old_virtual_price and t == 0:
645             raise "Loss"
646         if t == 1:
647             self.future_A_gamma_time = 0
648 
649     self.xcp_profit = xcp_profit
650 
651     norm: uint256 = price_oracle * 10**18 / price_scale
652     if norm > 10**18:
653         norm -= 10**18
654     else:
655         norm = 10**18 - norm
656     adjustment_step: uint256 = max(self.adjustment_step, norm / 10)
657 
658     needs_adjustment: bool = self.not_adjusted
659     # if not needs_adjustment and (virtual_price-10**18 > (xcp_profit-10**18)/2 + self.allowed_extra_profit):
660     # (re-arrange for gas efficiency)
661     if not needs_adjustment and (virtual_price * 2 - 10**18 > xcp_profit + 2*self.allowed_extra_profit) and (norm > adjustment_step) and (old_virtual_price > 0):
662         needs_adjustment = True
663         self.not_adjusted = True
664 
665     if needs_adjustment:
666         if norm > adjustment_step and old_virtual_price > 0:
667             p_new = (price_scale * (norm - adjustment_step) + adjustment_step * price_oracle) / norm
668 
669             # Calculate balances*prices
670             xp = [_xp[0], _xp[1] * p_new / price_scale]
671 
672             # Calculate "extended constant product" invariant xCP and virtual price
673             D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
674             xp = [D / N_COINS, D * PRECISION / (N_COINS * p_new)]
675             # We reuse old_virtual_price here but it's not old anymore
676             old_virtual_price = 10**18 * self.geometric_mean(xp, True) / total_supply
677 
678             # Proceed if we've got enough profit
679             # if (old_virtual_price > 10**18) and (2 * (old_virtual_price - 10**18) > xcp_profit - 10**18):
680             if (old_virtual_price > 10**18) and (2 * old_virtual_price - 10**18 > xcp_profit):
681                 self.price_scale = p_new
682                 self.D = D
683                 self.virtual_price = old_virtual_price
684 
685                 return
686 
687             else:
688                 self.not_adjusted = False
689 
690                 # Can instead do another flag variable if we want to save bytespace
691                 self.D = D_unadjusted
692                 self.virtual_price = virtual_price
693                 self._claim_admin_fees()
694 
695                 return
696 
697     # If we are here, the price_scale adjustment did not happen
698     # Still need to update the profit counter and D
699     self.D = D_unadjusted
700     self.virtual_price = virtual_price
701 
702     # norm appeared < adjustment_step after
703     if needs_adjustment:
704         self.not_adjusted = False
705         self._claim_admin_fees()
706 
707 
708 @internal
709 def _exchange(sender: address, mvalue: uint256, i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool) -> uint256:
710     assert not self.is_killed  # dev: the pool is killed
711     assert i != j  # dev: coin index out of range
712     assert i < N_COINS  # dev: coin index out of range
713     assert j < N_COINS  # dev: coin index out of range
714     assert dx > 0  # dev: do not exchange 0 coins
715 
716     A_gamma: uint256[2] = self._A_gamma()
717     xp: uint256[N_COINS] = self.balances
718     p: uint256 = 0
719     dy: uint256 = 0
720 
721     _coins: address[N_COINS] = coins
722     if use_eth and i == ETH_INDEX:
723         assert mvalue == dx  # dev: incorrect eth amount
724     else:
725         assert mvalue == 0  # dev: nonzero eth amount
726         assert ERC20(_coins[i]).transferFrom(sender, self, dx)
727         if i == ETH_INDEX:
728             WETH(_coins[i]).withdraw(dx)
729 
730     y: uint256 = xp[j]
731     x0: uint256 = xp[i]
732     xp[i] = x0 + dx
733     self.balances[i] = xp[i]
734 
735     price_scale: uint256 = self.price_scale
736 
737     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale * PRECISIONS[1] / PRECISION]
738 
739     prec_i: uint256 = PRECISIONS[0]
740     prec_j: uint256 = PRECISIONS[1]
741     if i == 1:
742         prec_i = PRECISIONS[1]
743         prec_j = PRECISIONS[0]
744 
745     # In case ramp is happening
746     t: uint256 = self.future_A_gamma_time
747     if t > 0:
748         x0 *= prec_i
749         if i > 0:
750             x0 = x0 * price_scale / PRECISION
751         x1: uint256 = xp[i]  # Back up old value in xp
752         xp[i] = x0
753         self.D = self.newton_D(A_gamma[0], A_gamma[1], xp)
754         xp[i] = x1  # And restore
755         if block.timestamp >= t:
756             self.future_A_gamma_time = 1
757 
758     dy = xp[j] - self.newton_y(A_gamma[0], A_gamma[1], xp, self.D, j)
759     # Not defining new "y" here to have less variables / make subsequent calls cheaper
760     xp[j] -= dy
761     dy -= 1
762 
763     if j > 0:
764         dy = dy * PRECISION / price_scale
765     dy /= prec_j
766 
767     dy -= self._fee(xp) * dy / 10**10
768     assert dy >= min_dy, "Slippage"
769     y -= dy
770 
771     self.balances[j] = y
772     if use_eth and j == ETH_INDEX:
773         raw_call(sender, b"", value=dy)
774     else:
775         if j == ETH_INDEX:
776             WETH(_coins[j]).deposit(value=dy)
777         assert ERC20(_coins[j]).transfer(sender, dy)
778 
779     y *= prec_j
780     if j > 0:
781         y = y * price_scale / PRECISION
782     xp[j] = y
783 
784     # Calculate price
785     if dx > 10**5 and dy > 10**5:
786         _dx: uint256 = dx * prec_i
787         _dy: uint256 = dy * prec_j
788         if i == 0:
789             p = _dx * 10**18 / _dy
790         else:  # j == 0
791             p = _dy * 10**18 / _dx
792 
793     self.tweak_price(A_gamma, xp, p, 0)
794 
795     log TokenExchange(sender, i, dx, j, dy)
796 
797     return dy
798 
799 
800 @payable
801 @external
802 @nonreentrant('lock')
803 def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool = False) -> uint256:
804     """
805     Exchange using WETH by default
806     """
807     return self._exchange(msg.sender, msg.value, i, j, dx, min_dy, use_eth)
808 
809 
810 @payable
811 @external
812 @nonreentrant('lock')
813 def exchange_underlying(i: uint256, j: uint256, dx: uint256, min_dy: uint256) -> uint256:
814     """
815     Exchange using ETH
816     """
817     return self._exchange(msg.sender, msg.value, i, j, dx, min_dy, True)
818 
819 
820 @external
821 @view
822 def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256:
823     assert i != j  # dev: same input and output coin
824     assert i < N_COINS  # dev: coin index out of range
825     assert j < N_COINS  # dev: coin index out of range
826 
827     price_scale: uint256 = self.price_scale * PRECISIONS[1]
828     xp: uint256[N_COINS] = self.balances
829 
830     A_gamma: uint256[2] = self._A_gamma()
831     D: uint256 = self.D
832     if self.future_A_gamma_time > 0:
833         D = self.newton_D(A_gamma[0], A_gamma[1], self.xp())
834 
835     xp[i] += dx
836     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale / PRECISION]
837 
838     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, j)
839     dy: uint256 = xp[j] - y - 1
840     xp[j] = y
841     if j > 0:
842         dy = dy * PRECISION / price_scale
843     else:
844         dy /= PRECISIONS[0]
845     dy -= self._fee(xp) * dy / 10**10
846 
847     return dy
848 
849 
850 @view
851 @internal
852 def _calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
853     # fee = sum(amounts_i - avg(amounts)) * fee' / sum(amounts)
854     fee: uint256 = self._fee(xp) * N_COINS / (4 * (N_COINS-1))
855     S: uint256 = 0
856     for _x in amounts:
857         S += _x
858     avg: uint256 = S / N_COINS
859     Sdiff: uint256 = 0
860     for _x in amounts:
861         if _x > avg:
862             Sdiff += _x - avg
863         else:
864             Sdiff += avg - _x
865     return fee * Sdiff / S + NOISE_FEE
866 
867 
868 @payable
869 @external
870 @nonreentrant('lock')
871 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256, use_eth: bool = False) -> uint256:
872     assert not self.is_killed  # dev: the pool is killed
873     assert amounts[0] > 0 or amounts[1] > 0  # dev: no coins to add
874 
875     A_gamma: uint256[2] = self._A_gamma()
876 
877     _coins: address[N_COINS] = coins
878 
879     xp: uint256[N_COINS] = self.balances
880     amountsp: uint256[N_COINS] = empty(uint256[N_COINS])
881     xx: uint256[N_COINS] = empty(uint256[N_COINS])
882     d_token: uint256 = 0
883     d_token_fee: uint256 = 0
884     old_D: uint256 = 0
885 
886     xp_old: uint256[N_COINS] = xp
887 
888     for i in range(N_COINS):
889         bal: uint256 = xp[i] + amounts[i]
890         xp[i] = bal
891         self.balances[i] = bal
892     xx = xp
893 
894     price_scale: uint256 = self.price_scale * PRECISIONS[1]
895     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale / PRECISION]
896     xp_old = [xp_old[0] * PRECISIONS[0], xp_old[1] * price_scale / PRECISION]
897 
898     if not use_eth:
899         assert msg.value == 0  # dev: nonzero eth amount
900 
901     for i in range(N_COINS):
902         if use_eth and i == ETH_INDEX:
903             assert msg.value == amounts[i]  # dev: incorrect eth amount
904         if amounts[i] > 0:
905             if (not use_eth) or (i != ETH_INDEX):
906                 assert ERC20(_coins[i]).transferFrom(msg.sender, self, amounts[i])
907                 if i == ETH_INDEX:
908                     WETH(_coins[i]).withdraw(amounts[i])
909             amountsp[i] = xp[i] - xp_old[i]
910 
911     t: uint256 = self.future_A_gamma_time
912     if t > 0:
913         old_D = self.newton_D(A_gamma[0], A_gamma[1], xp_old)
914         if block.timestamp >= t:
915             self.future_A_gamma_time = 1
916     else:
917         old_D = self.D
918 
919     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
920 
921     token_supply: uint256 = CurveToken(token).totalSupply()
922     if old_D > 0:
923         d_token = token_supply * D / old_D - token_supply
924     else:
925         d_token = self.get_xcp(D)  # making initial virtual price equal to 1
926     assert d_token > 0  # dev: nothing minted
927 
928     if old_D > 0:
929         d_token_fee = self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
930         d_token -= d_token_fee
931         token_supply += d_token
932         CurveToken(token).mint(msg.sender, d_token)
933 
934         # Calculate price
935         # p_i * (dx_i - dtoken / token_supply * xx_i) = sum{k!=i}(p_k * (dtoken / token_supply * xx_k - dx_k))
936         # Simplified for 2 coins
937         p: uint256 = 0
938         if d_token > 10**5:
939             if amounts[0] == 0 or amounts[1] == 0:
940                 S: uint256 = 0
941                 precision: uint256 = 0
942                 ix: uint256 = 0
943                 if amounts[0] == 0:
944                     S = xx[0] * PRECISIONS[0]
945                     precision = PRECISIONS[1]
946                     ix = 1
947                 else:
948                     S = xx[1] * PRECISIONS[1]
949                     precision = PRECISIONS[0]
950                 S = S * d_token / token_supply
951                 p = S * PRECISION / (amounts[ix] * precision - d_token * xx[ix] * precision / token_supply)
952                 if ix == 0:
953                     p = (10**18)**2 / p
954 
955         self.tweak_price(A_gamma, xp, p, D)
956 
957     else:
958         self.D = D
959         self.virtual_price = 10**18
960         self.xcp_profit = 10**18
961         CurveToken(token).mint(msg.sender, d_token)
962 
963     assert d_token >= min_mint_amount, "Slippage"
964 
965     log AddLiquidity(msg.sender, amounts, d_token_fee, token_supply)
966 
967     return d_token
968 
969 
970 @external
971 @nonreentrant('lock')
972 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS], use_eth: bool = False):
973     """
974     This withdrawal method is very safe, does no complex math
975     """
976     _coins: address[N_COINS] = coins
977     total_supply: uint256 = CurveToken(token).totalSupply()
978     CurveToken(token).burnFrom(msg.sender, _amount)
979     balances: uint256[N_COINS] = self.balances
980     amount: uint256 = _amount - 1  # Make rounding errors favoring other LPs a tiny bit
981 
982     for i in range(N_COINS):
983         d_balance: uint256 = balances[i] * amount / total_supply
984         assert d_balance >= min_amounts[i]
985         self.balances[i] = balances[i] - d_balance
986         balances[i] = d_balance  # now it's the amounts going out
987         if use_eth and i == ETH_INDEX:
988             raw_call(msg.sender, b"", value=d_balance)
989         else:
990             if i == ETH_INDEX:
991                 WETH(_coins[i]).deposit(value=d_balance)
992             assert ERC20(_coins[i]).transfer(msg.sender, d_balance)
993 
994     D: uint256 = self.D
995     self.D = D - D * amount / total_supply
996 
997     log RemoveLiquidity(msg.sender, balances, total_supply - _amount)
998 
999 
1000 @view
1001 @external
1002 def calc_token_amount(amounts: uint256[N_COINS]) -> uint256:
1003     token_supply: uint256 = CurveToken(token).totalSupply()
1004     price_scale: uint256 = self.price_scale * PRECISIONS[1]
1005     A_gamma: uint256[2] = self._A_gamma()
1006     xp: uint256[N_COINS] = self.xp()
1007     amountsp: uint256[N_COINS] = [
1008         amounts[0] * PRECISIONS[0],
1009         amounts[1] * price_scale / PRECISION]
1010     D0: uint256 = self.D
1011     if self.future_A_gamma_time > 0:
1012         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1013     xp[0] += amountsp[0]
1014     xp[1] += amountsp[1]
1015     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1016     d_token: uint256 = token_supply * D / D0 - token_supply
1017     d_token -= self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
1018     return d_token
1019 
1020 
1021 @internal
1022 @view
1023 def _calc_withdraw_one_coin(A_gamma: uint256[2], token_amount: uint256, i: uint256, update_D: bool,
1024                             calc_price: bool) -> (uint256, uint256, uint256, uint256[N_COINS]):
1025     token_supply: uint256 = CurveToken(token).totalSupply()
1026     assert token_amount <= token_supply  # dev: token amount more than supply
1027     assert i < N_COINS  # dev: coin out of range
1028 
1029     xx: uint256[N_COINS] = self.balances
1030     D0: uint256 = 0
1031 
1032     price_scale_i: uint256 = self.price_scale * PRECISIONS[1]
1033     xp: uint256[N_COINS] = [xx[0] * PRECISIONS[0], xx[1] * price_scale_i / PRECISION]
1034     if i == 0:
1035         price_scale_i = PRECISION * PRECISIONS[0]
1036 
1037     if update_D:
1038         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1039     else:
1040         D0 = self.D
1041 
1042     D: uint256 = D0
1043 
1044     # Charge the fee on D, not on y, e.g. reducing invariant LESS than charging the user
1045     fee: uint256 = self._fee(xp)
1046     dD: uint256 = token_amount * D / token_supply
1047     D -= (dD - (fee * dD / (2 * 10**10) + 1))
1048     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, i)
1049     dy: uint256 = (xp[i] - y) * PRECISION / price_scale_i
1050     xp[i] = y
1051 
1052     # Price calc
1053     p: uint256 = 0
1054     if calc_price and dy > 10**5 and token_amount > 10**5:
1055         # p_i = dD / D0 * sum'(p_k * x_k) / (dy - dD / D0 * y0)
1056         S: uint256 = 0
1057         precision: uint256 = PRECISIONS[0]
1058         if i == 1:
1059             S = xx[0] * PRECISIONS[0]
1060             precision = PRECISIONS[1]
1061         else:
1062             S = xx[1] * PRECISIONS[1]
1063         S = S * dD / D0
1064         p = S * PRECISION / (dy * precision - dD * xx[i] * precision / D0)
1065         if i == 0:
1066             p = (10**18)**2 / p
1067 
1068     return dy, p, D, xp
1069 
1070 
1071 @view
1072 @external
1073 def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256:
1074     return self._calc_withdraw_one_coin(self._A_gamma(), token_amount, i, True, False)[0]
1075 
1076 
1077 @external
1078 @nonreentrant('lock')
1079 def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256, use_eth: bool = False) -> uint256:
1080     assert not self.is_killed  # dev: the pool is killed
1081 
1082     A_gamma: uint256[2] = self._A_gamma()
1083 
1084     dy: uint256 = 0
1085     D: uint256 = 0
1086     p: uint256 = 0
1087     xp: uint256[N_COINS] = empty(uint256[N_COINS])
1088     future_A_gamma_time: uint256 = self.future_A_gamma_time
1089     dy, p, D, xp = self._calc_withdraw_one_coin(A_gamma, token_amount, i, (future_A_gamma_time > 0), True)
1090     assert dy >= min_amount, "Slippage"
1091 
1092     if block.timestamp >= future_A_gamma_time:
1093         self.future_A_gamma_time = 1
1094 
1095     self.balances[i] -= dy
1096     CurveToken(token).burnFrom(msg.sender, token_amount)
1097 
1098     _coins: address[N_COINS] = coins
1099     if use_eth and i == ETH_INDEX:
1100         raw_call(msg.sender, b"", value=dy)
1101     else:
1102         if i == ETH_INDEX:
1103             WETH(_coins[i]).deposit(value=dy)
1104         assert ERC20(_coins[i]).transfer(msg.sender, dy)
1105 
1106     self.tweak_price(A_gamma, xp, p, D)
1107 
1108     log RemoveLiquidityOne(msg.sender, token_amount, i, dy)
1109 
1110     return dy
1111 
1112 
1113 @external
1114 @nonreentrant('lock')
1115 def claim_admin_fees():
1116     self._claim_admin_fees()
1117 
1118 
1119 # Admin parameters
1120 @external
1121 def ramp_A_gamma(future_A: uint256, future_gamma: uint256, future_time: uint256):
1122     assert msg.sender == self.owner  # dev: only owner
1123     assert block.timestamp > self.initial_A_gamma_time + (MIN_RAMP_TIME-1)
1124     assert future_time > block.timestamp + (MIN_RAMP_TIME-1)  # dev: insufficient time
1125 
1126     A_gamma: uint256[2] = self._A_gamma()
1127     initial_A_gamma: uint256 = shift(A_gamma[0], 128)
1128     initial_A_gamma = bitwise_or(initial_A_gamma, A_gamma[1])
1129 
1130     assert future_A > MIN_A-1
1131     assert future_A < MAX_A+1
1132     assert future_gamma > MIN_GAMMA-1
1133     assert future_gamma < MAX_GAMMA+1
1134 
1135     ratio: uint256 = 10**18 * future_A / A_gamma[0]
1136     assert ratio < 10**18 * MAX_A_CHANGE + 1
1137     assert ratio > 10**18 / MAX_A_CHANGE - 1
1138 
1139     ratio = 10**18 * future_gamma / A_gamma[1]
1140     assert ratio < 10**18 * MAX_A_CHANGE + 1
1141     assert ratio > 10**18 / MAX_A_CHANGE - 1
1142 
1143     self.initial_A_gamma = initial_A_gamma
1144     self.initial_A_gamma_time = block.timestamp
1145 
1146     future_A_gamma: uint256 = shift(future_A, 128)
1147     future_A_gamma = bitwise_or(future_A_gamma, future_gamma)
1148     self.future_A_gamma_time = future_time
1149     self.future_A_gamma = future_A_gamma
1150 
1151     log RampAgamma(A_gamma[0], future_A, A_gamma[1], future_gamma, block.timestamp, future_time)
1152 
1153 
1154 @external
1155 def stop_ramp_A_gamma():
1156     assert msg.sender == self.owner  # dev: only owner
1157 
1158     A_gamma: uint256[2] = self._A_gamma()
1159     current_A_gamma: uint256 = shift(A_gamma[0], 128)
1160     current_A_gamma = bitwise_or(current_A_gamma, A_gamma[1])
1161     self.initial_A_gamma = current_A_gamma
1162     self.future_A_gamma = current_A_gamma
1163     self.initial_A_gamma_time = block.timestamp
1164     self.future_A_gamma_time = block.timestamp
1165     # now (block.timestamp < t1) is always False, so we return saved A
1166 
1167     log StopRampA(A_gamma[0], A_gamma[1], block.timestamp)
1168 
1169 
1170 @external
1171 def commit_new_parameters(
1172     _new_mid_fee: uint256,
1173     _new_out_fee: uint256,
1174     _new_admin_fee: uint256,
1175     _new_fee_gamma: uint256,
1176     _new_allowed_extra_profit: uint256,
1177     _new_adjustment_step: uint256,
1178     _new_ma_half_time: uint256,
1179     ):
1180     assert msg.sender == self.owner  # dev: only owner
1181     assert self.admin_actions_deadline == 0  # dev: active action
1182 
1183     new_mid_fee: uint256 = _new_mid_fee
1184     new_out_fee: uint256 = _new_out_fee
1185     new_admin_fee: uint256 = _new_admin_fee
1186     new_fee_gamma: uint256 = _new_fee_gamma
1187     new_allowed_extra_profit: uint256 = _new_allowed_extra_profit
1188     new_adjustment_step: uint256 = _new_adjustment_step
1189     new_ma_half_time: uint256 = _new_ma_half_time
1190 
1191     # Fees
1192     if new_out_fee < MAX_FEE+1:
1193         assert new_out_fee > MIN_FEE-1  # dev: fee is out of range
1194     else:
1195         new_out_fee = self.out_fee
1196     if new_mid_fee > MAX_FEE:
1197         new_mid_fee = self.mid_fee
1198     assert new_mid_fee <= new_out_fee  # dev: mid-fee is too high
1199     if new_admin_fee > MAX_ADMIN_FEE:
1200         new_admin_fee = self.admin_fee
1201 
1202     # AMM parameters
1203     if new_fee_gamma < 10**18:
1204         assert new_fee_gamma > 0  # dev: fee_gamma out of range [1 .. 10**18]
1205     else:
1206         new_fee_gamma = self.fee_gamma
1207     if new_allowed_extra_profit > 10**18:
1208         new_allowed_extra_profit = self.allowed_extra_profit
1209     if new_adjustment_step > 10**18:
1210         new_adjustment_step = self.adjustment_step
1211 
1212     # MA
1213     if new_ma_half_time < 7*86400:
1214         assert new_ma_half_time > 0  # dev: MA time should be longer than 1 second
1215     else:
1216         new_ma_half_time = self.ma_half_time
1217 
1218     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1219     self.admin_actions_deadline = _deadline
1220 
1221     self.future_admin_fee = new_admin_fee
1222     self.future_mid_fee = new_mid_fee
1223     self.future_out_fee = new_out_fee
1224     self.future_fee_gamma = new_fee_gamma
1225     self.future_allowed_extra_profit = new_allowed_extra_profit
1226     self.future_adjustment_step = new_adjustment_step
1227     self.future_ma_half_time = new_ma_half_time
1228 
1229     log CommitNewParameters(_deadline, new_admin_fee, new_mid_fee, new_out_fee,
1230                             new_fee_gamma,
1231                             new_allowed_extra_profit, new_adjustment_step,
1232                             new_ma_half_time)
1233 
1234 
1235 @external
1236 @nonreentrant('lock')
1237 def apply_new_parameters():
1238     assert msg.sender == self.owner  # dev: only owner
1239     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
1240     assert self.admin_actions_deadline != 0  # dev: no active action
1241 
1242     self.admin_actions_deadline = 0
1243 
1244     admin_fee: uint256 = self.future_admin_fee
1245     if self.admin_fee != admin_fee:
1246         self._claim_admin_fees()
1247         self.admin_fee = admin_fee
1248 
1249     mid_fee: uint256 = self.future_mid_fee
1250     self.mid_fee = mid_fee
1251     out_fee: uint256 = self.future_out_fee
1252     self.out_fee = out_fee
1253     fee_gamma: uint256 = self.future_fee_gamma
1254     self.fee_gamma = fee_gamma
1255     allowed_extra_profit: uint256 = self.future_allowed_extra_profit
1256     self.allowed_extra_profit = allowed_extra_profit
1257     adjustment_step: uint256 = self.future_adjustment_step
1258     self.adjustment_step = adjustment_step
1259     ma_half_time: uint256 = self.future_ma_half_time
1260     self.ma_half_time = ma_half_time
1261 
1262     log NewParameters(admin_fee, mid_fee, out_fee,
1263                       fee_gamma,
1264                       allowed_extra_profit, adjustment_step,
1265                       ma_half_time)
1266 
1267 
1268 @external
1269 def revert_new_parameters():
1270     assert msg.sender == self.owner  # dev: only owner
1271 
1272     self.admin_actions_deadline = 0
1273 
1274 
1275 @external
1276 def commit_transfer_ownership(_owner: address):
1277     assert msg.sender == self.owner  # dev: only owner
1278     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1279 
1280     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1281     self.transfer_ownership_deadline = _deadline
1282     self.future_owner = _owner
1283 
1284     log CommitNewAdmin(_deadline, _owner)
1285 
1286 
1287 @external
1288 def apply_transfer_ownership():
1289     assert msg.sender == self.owner  # dev: only owner
1290     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1291     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1292 
1293     self.transfer_ownership_deadline = 0
1294     _owner: address = self.future_owner
1295     self.owner = _owner
1296 
1297     log NewAdmin(_owner)
1298 
1299 
1300 @external
1301 def revert_transfer_ownership():
1302     assert msg.sender == self.owner  # dev: only owner
1303 
1304     self.transfer_ownership_deadline = 0
1305 
1306 
1307 @external
1308 def kill_me():
1309     assert msg.sender == self.owner  # dev: only owner
1310     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1311     self.is_killed = True
1312 
1313 
1314 @external
1315 def unkill_me():
1316     assert msg.sender == self.owner  # dev: only owner
1317     self.is_killed = False
1318 
1319 
1320 @external
1321 def set_admin_fee_receiver(_admin_fee_receiver: address):
1322     assert msg.sender == self.owner  # dev: only owner
1323     self.admin_fee_receiver = _admin_fee_receiver
1324 
1325 
1326 @internal
1327 @pure
1328 def sqrt_int(x: uint256) -> uint256:
1329     """
1330     Originating from: https://github.com/vyperlang/vyper/issues/1266
1331     """
1332 
1333     if x == 0:
1334         return 0
1335 
1336     z: uint256 = (x + 10**18) / 2
1337     y: uint256 = x
1338 
1339     for i in range(256):
1340         if z == y:
1341             return y
1342         y = z
1343         z = (x * 10**18 / z + z) / 2
1344 
1345     raise "Did not converge"
1346 
1347 
1348 @external
1349 @view
1350 def lp_price() -> uint256:
1351     """
1352     Approximate LP token price
1353     """
1354     max_price: uint256 = 2 * self.virtual_price * self.sqrt_int(self.price_oracle) / 10**18
1355 
1356     return max_price