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
102 _price_oracle: uint256  # Price target given by MA
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
211     self._price_oracle = initial_price
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
597 @view
598 def internal_price_oracle() -> uint256:
599     price_oracle: uint256 = self._price_oracle
600     last_prices_timestamp: uint256 = self.last_prices_timestamp
601 
602     if last_prices_timestamp < block.timestamp:
603         ma_half_time: uint256 = self.ma_half_time
604         last_prices: uint256 = self.last_prices
605         alpha: uint256 = self.halfpow((block.timestamp - last_prices_timestamp) * 10**18 / ma_half_time)
606         return (last_prices * (10**18 - alpha) + price_oracle * alpha) / 10**18
607 
608     else:
609         return price_oracle
610 
611 
612 @external
613 @view
614 def price_oracle() -> uint256:
615     return self.internal_price_oracle()
616 
617 
618 @internal
619 def tweak_price(A_gamma: uint256[2],_xp: uint256[N_COINS], p_i: uint256, new_D: uint256):
620     price_oracle: uint256 = self._price_oracle
621     last_prices: uint256 = self.last_prices
622     price_scale: uint256 = self.price_scale
623     last_prices_timestamp: uint256 = self.last_prices_timestamp
624     p_new: uint256 = 0
625 
626     if last_prices_timestamp < block.timestamp:
627         # MA update required
628         ma_half_time: uint256 = self.ma_half_time
629         alpha: uint256 = self.halfpow((block.timestamp - last_prices_timestamp) * 10**18 / ma_half_time)
630         price_oracle = (last_prices * (10**18 - alpha) + price_oracle * alpha) / 10**18
631         self._price_oracle = price_oracle
632         self.last_prices_timestamp = block.timestamp
633 
634     D_unadjusted: uint256 = new_D  # Withdrawal methods know new D already
635     if new_D == 0:
636         # We will need this a few times (35k gas)
637         D_unadjusted = self.newton_D(A_gamma[0], A_gamma[1], _xp)
638 
639     if p_i > 0:
640         last_prices = p_i
641 
642     else:
643         # calculate real prices
644         __xp: uint256[N_COINS] = _xp
645         dx_price: uint256 = __xp[0] / 10**6
646         __xp[0] += dx_price
647         last_prices = price_scale * dx_price / (_xp[1] - self.newton_y(A_gamma[0], A_gamma[1], __xp, D_unadjusted, 1))
648 
649     self.last_prices = last_prices
650 
651     total_supply: uint256 = CurveToken(token).totalSupply()
652     old_xcp_profit: uint256 = self.xcp_profit
653     old_virtual_price: uint256 = self.virtual_price
654 
655     # Update profit numbers without price adjustment first
656     xp: uint256[N_COINS] = [D_unadjusted / N_COINS, D_unadjusted * PRECISION / (N_COINS * price_scale)]
657     xcp_profit: uint256 = 10**18
658     virtual_price: uint256 = 10**18
659 
660     if old_virtual_price > 0:
661         xcp: uint256 = self.geometric_mean(xp, True)
662         virtual_price = 10**18 * xcp / total_supply
663         xcp_profit = old_xcp_profit * virtual_price / old_virtual_price
664 
665         t: uint256 = self.future_A_gamma_time
666         if virtual_price < old_virtual_price and t == 0:
667             raise "Loss"
668         if t == 1:
669             self.future_A_gamma_time = 0
670 
671     self.xcp_profit = xcp_profit
672 
673     norm: uint256 = price_oracle * 10**18 / price_scale
674     if norm > 10**18:
675         norm -= 10**18
676     else:
677         norm = 10**18 - norm
678     adjustment_step: uint256 = max(self.adjustment_step, norm / 10)
679 
680     needs_adjustment: bool = self.not_adjusted
681     # if not needs_adjustment and (virtual_price-10**18 > (xcp_profit-10**18)/2 + self.allowed_extra_profit):
682     # (re-arrange for gas efficiency)
683     if not needs_adjustment and (virtual_price * 2 - 10**18 > xcp_profit + 2*self.allowed_extra_profit) and (norm > adjustment_step) and (old_virtual_price > 0):
684         needs_adjustment = True
685         self.not_adjusted = True
686 
687     if needs_adjustment:
688         if norm > adjustment_step and old_virtual_price > 0:
689             p_new = (price_scale * (norm - adjustment_step) + adjustment_step * price_oracle) / norm
690 
691             # Calculate balances*prices
692             xp = [_xp[0], _xp[1] * p_new / price_scale]
693 
694             # Calculate "extended constant product" invariant xCP and virtual price
695             D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
696             xp = [D / N_COINS, D * PRECISION / (N_COINS * p_new)]
697             # We reuse old_virtual_price here but it's not old anymore
698             old_virtual_price = 10**18 * self.geometric_mean(xp, True) / total_supply
699 
700             # Proceed if we've got enough profit
701             # if (old_virtual_price > 10**18) and (2 * (old_virtual_price - 10**18) > xcp_profit - 10**18):
702             if (old_virtual_price > 10**18) and (2 * old_virtual_price - 10**18 > xcp_profit):
703                 self.price_scale = p_new
704                 self.D = D
705                 self.virtual_price = old_virtual_price
706 
707                 return
708 
709             else:
710                 self.not_adjusted = False
711 
712                 # Can instead do another flag variable if we want to save bytespace
713                 self.D = D_unadjusted
714                 self.virtual_price = virtual_price
715                 self._claim_admin_fees()
716 
717                 return
718 
719     # If we are here, the price_scale adjustment did not happen
720     # Still need to update the profit counter and D
721     self.D = D_unadjusted
722     self.virtual_price = virtual_price
723 
724     # norm appeared < adjustment_step after
725     if needs_adjustment:
726         self.not_adjusted = False
727         self._claim_admin_fees()
728 
729 
730 @internal
731 def _exchange(sender: address, mvalue: uint256, i: uint256, j: uint256, dx: uint256, min_dy: uint256,
732               use_eth: bool, receiver: address, callbacker: address, callback_sig: Bytes[4]) -> uint256:
733     assert not self.is_killed  # dev: the pool is killed
734     assert i != j  # dev: coin index out of range
735     assert i < N_COINS  # dev: coin index out of range
736     assert j < N_COINS  # dev: coin index out of range
737     assert dx > 0  # dev: do not exchange 0 coins
738 
739     A_gamma: uint256[2] = self._A_gamma()
740     xp: uint256[N_COINS] = self.balances
741     p: uint256 = 0
742     dy: uint256 = 0
743 
744     _coins: address[N_COINS] = coins
745 
746     y: uint256 = xp[j]
747     x0: uint256 = xp[i]
748     xp[i] = x0 + dx
749     self.balances[i] = xp[i]
750 
751     price_scale: uint256 = self.price_scale
752 
753     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale * PRECISIONS[1] / PRECISION]
754 
755     prec_i: uint256 = PRECISIONS[0]
756     prec_j: uint256 = PRECISIONS[1]
757     if i == 1:
758         prec_i = PRECISIONS[1]
759         prec_j = PRECISIONS[0]
760 
761     # In case ramp is happening
762     t: uint256 = self.future_A_gamma_time
763     if t > 0:
764         x0 *= prec_i
765         if i > 0:
766             x0 = x0 * price_scale / PRECISION
767         x1: uint256 = xp[i]  # Back up old value in xp
768         xp[i] = x0
769         self.D = self.newton_D(A_gamma[0], A_gamma[1], xp)
770         xp[i] = x1  # And restore
771         if block.timestamp >= t:
772             self.future_A_gamma_time = 1
773 
774     dy = xp[j] - self.newton_y(A_gamma[0], A_gamma[1], xp, self.D, j)
775     # Not defining new "y" here to have less variables / make subsequent calls cheaper
776     xp[j] -= dy
777     dy -= 1
778 
779     if j > 0:
780         dy = dy * PRECISION / price_scale
781     dy /= prec_j
782 
783     dy -= self._fee(xp) * dy / 10**10
784     assert dy >= min_dy, "Slippage"
785     y -= dy
786 
787     self.balances[j] = y
788 
789     # Do transfers in and out together
790     if use_eth and i == ETH_INDEX:
791         assert mvalue == dx  # dev: incorrect eth amount
792     else:
793         assert mvalue == 0  # dev: nonzero eth amount
794         if callback_sig == b"\x00\x00\x00\x00":
795             assert ERC20(_coins[i]).transferFrom(sender, self, dx)
796         else:
797             c: address = _coins[i]
798             b: uint256 = ERC20(c).balanceOf(self)
799             raw_call(callbacker,
800                      concat(
801                         callback_sig,
802                         convert(sender, bytes32),
803                         convert(receiver, bytes32),
804                         convert(c, bytes32),
805                         convert(dx, bytes32),
806                         convert(dy, bytes32)
807                      )
808             )
809             assert ERC20(c).balanceOf(self) - b == dx  # dev: callback didn't give us coins
810         if i == ETH_INDEX:
811             WETH(_coins[i]).withdraw(dx)
812 
813     if use_eth and j == ETH_INDEX:
814         raw_call(receiver, b"", value=dy)
815     else:
816         if j == ETH_INDEX:
817             WETH(_coins[j]).deposit(value=dy)
818         assert ERC20(_coins[j]).transfer(receiver, dy)
819 
820     y *= prec_j
821     if j > 0:
822         y = y * price_scale / PRECISION
823     xp[j] = y
824 
825     # Calculate price
826     if dx > 10**5 and dy > 10**5:
827         _dx: uint256 = dx * prec_i
828         _dy: uint256 = dy * prec_j
829         if i == 0:
830             p = _dx * 10**18 / _dy
831         else:  # j == 0
832             p = _dy * 10**18 / _dx
833 
834     self.tweak_price(A_gamma, xp, p, 0)
835 
836     log TokenExchange(sender, i, dx, j, dy)
837 
838     return dy
839 
840 
841 @payable
842 @external
843 @nonreentrant('lock')
844 def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256,
845              use_eth: bool = False, receiver: address = msg.sender) -> uint256:
846     """
847     Exchange using WETH by default
848     """
849     return self._exchange(msg.sender, msg.value, i, j, dx, min_dy, use_eth, receiver, ZERO_ADDRESS, b'\x00\x00\x00\x00')
850 
851 
852 @payable
853 @external
854 @nonreentrant('lock')
855 def exchange_underlying(i: uint256, j: uint256, dx: uint256, min_dy: uint256,
856                         receiver: address = msg.sender) -> uint256:
857     """
858     Exchange using ETH
859     """
860     return self._exchange(msg.sender, msg.value, i, j, dx, min_dy, True, receiver, ZERO_ADDRESS, b'\x00\x00\x00\x00')
861 
862 
863 @payable
864 @external
865 @nonreentrant('lock')
866 def exchange_extended(i: uint256, j: uint256, dx: uint256, min_dy: uint256,
867                       use_eth: bool, sender: address, receiver: address, cb: Bytes[4]) -> uint256:
868     assert cb != b'\x00\x00\x00\x00'  # dev: No callback specified
869     return self._exchange(sender, msg.value, i, j, dx, min_dy, use_eth, receiver, msg.sender, cb)
870 
871 
872 @external
873 @view
874 def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256:
875     assert i != j  # dev: same input and output coin
876     assert i < N_COINS  # dev: coin index out of range
877     assert j < N_COINS  # dev: coin index out of range
878 
879     price_scale: uint256 = self.price_scale * PRECISIONS[1]
880     xp: uint256[N_COINS] = self.balances
881 
882     A_gamma: uint256[2] = self._A_gamma()
883     D: uint256 = self.D
884     if self.future_A_gamma_time > 0:
885         D = self.newton_D(A_gamma[0], A_gamma[1], self.xp())
886 
887     xp[i] += dx
888     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale / PRECISION]
889 
890     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, j)
891     dy: uint256 = xp[j] - y - 1
892     xp[j] = y
893     if j > 0:
894         dy = dy * PRECISION / price_scale
895     else:
896         dy /= PRECISIONS[0]
897     dy -= self._fee(xp) * dy / 10**10
898 
899     return dy
900 
901 
902 @view
903 @internal
904 def _calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
905     # fee = sum(amounts_i - avg(amounts)) * fee' / sum(amounts)
906     fee: uint256 = self._fee(xp) * N_COINS / (4 * (N_COINS-1))
907     S: uint256 = 0
908     for _x in amounts:
909         S += _x
910     avg: uint256 = S / N_COINS
911     Sdiff: uint256 = 0
912     for _x in amounts:
913         if _x > avg:
914             Sdiff += _x - avg
915         else:
916             Sdiff += avg - _x
917     return fee * Sdiff / S + NOISE_FEE
918 
919 
920 @payable
921 @external
922 @nonreentrant('lock')
923 def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256,
924                   use_eth: bool = False, receiver: address = msg.sender) -> uint256:
925     assert not self.is_killed  # dev: the pool is killed
926     assert amounts[0] > 0 or amounts[1] > 0  # dev: no coins to add
927 
928     A_gamma: uint256[2] = self._A_gamma()
929 
930     _coins: address[N_COINS] = coins
931 
932     xp: uint256[N_COINS] = self.balances
933     amountsp: uint256[N_COINS] = empty(uint256[N_COINS])
934     xx: uint256[N_COINS] = empty(uint256[N_COINS])
935     d_token: uint256 = 0
936     d_token_fee: uint256 = 0
937     old_D: uint256 = 0
938 
939     xp_old: uint256[N_COINS] = xp
940 
941     for i in range(N_COINS):
942         bal: uint256 = xp[i] + amounts[i]
943         xp[i] = bal
944         self.balances[i] = bal
945     xx = xp
946 
947     price_scale: uint256 = self.price_scale * PRECISIONS[1]
948     xp = [xp[0] * PRECISIONS[0], xp[1] * price_scale / PRECISION]
949     xp_old = [xp_old[0] * PRECISIONS[0], xp_old[1] * price_scale / PRECISION]
950 
951     if not use_eth:
952         assert msg.value == 0  # dev: nonzero eth amount
953 
954     for i in range(N_COINS):
955         if use_eth and i == ETH_INDEX:
956             assert msg.value == amounts[i]  # dev: incorrect eth amount
957         if amounts[i] > 0:
958             coin: address = _coins[i]
959             if (not use_eth) or (i != ETH_INDEX):
960                 assert ERC20(coin).transferFrom(msg.sender, self, amounts[i])
961                 if i == ETH_INDEX:
962                     WETH(coin).withdraw(amounts[i])
963             amountsp[i] = xp[i] - xp_old[i]
964 
965     t: uint256 = self.future_A_gamma_time
966     if t > 0:
967         old_D = self.newton_D(A_gamma[0], A_gamma[1], xp_old)
968         if block.timestamp >= t:
969             self.future_A_gamma_time = 1
970     else:
971         old_D = self.D
972 
973     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
974 
975     token_supply: uint256 = CurveToken(token).totalSupply()
976     if old_D > 0:
977         d_token = token_supply * D / old_D - token_supply
978     else:
979         d_token = self.get_xcp(D)  # making initial virtual price equal to 1
980     assert d_token > 0  # dev: nothing minted
981 
982     if old_D > 0:
983         d_token_fee = self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
984         d_token -= d_token_fee
985         token_supply += d_token
986         CurveToken(token).mint(receiver, d_token)
987 
988         # Calculate price
989         # p_i * (dx_i - dtoken / token_supply * xx_i) = sum{k!=i}(p_k * (dtoken / token_supply * xx_k - dx_k))
990         # Simplified for 2 coins
991         p: uint256 = 0
992         if d_token > 10**5:
993             if amounts[0] == 0 or amounts[1] == 0:
994                 S: uint256 = 0
995                 precision: uint256 = 0
996                 ix: uint256 = 0
997                 if amounts[0] == 0:
998                     S = xx[0] * PRECISIONS[0]
999                     precision = PRECISIONS[1]
1000                     ix = 1
1001                 else:
1002                     S = xx[1] * PRECISIONS[1]
1003                     precision = PRECISIONS[0]
1004                 S = S * d_token / token_supply
1005                 p = S * PRECISION / (amounts[ix] * precision - d_token * xx[ix] * precision / token_supply)
1006                 if ix == 0:
1007                     p = (10**18)**2 / p
1008 
1009         self.tweak_price(A_gamma, xp, p, D)
1010 
1011     else:
1012         self.D = D
1013         self.virtual_price = 10**18
1014         self.xcp_profit = 10**18
1015         CurveToken(token).mint(receiver, d_token)
1016 
1017     assert d_token >= min_mint_amount, "Slippage"
1018 
1019     log AddLiquidity(receiver, amounts, d_token_fee, token_supply)
1020 
1021     return d_token
1022 
1023 
1024 @external
1025 @nonreentrant('lock')
1026 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS],
1027                      use_eth: bool = False, receiver: address = msg.sender):
1028     """
1029     This withdrawal method is very safe, does no complex math
1030     """
1031     _coins: address[N_COINS] = coins
1032     total_supply: uint256 = CurveToken(token).totalSupply()
1033     CurveToken(token).burnFrom(msg.sender, _amount)
1034     balances: uint256[N_COINS] = self.balances
1035     amount: uint256 = _amount - 1  # Make rounding errors favoring other LPs a tiny bit
1036 
1037     for i in range(N_COINS):
1038         d_balance: uint256 = balances[i] * amount / total_supply
1039         assert d_balance >= min_amounts[i]
1040         self.balances[i] = balances[i] - d_balance
1041         balances[i] = d_balance  # now it's the amounts going out
1042         if use_eth and i == ETH_INDEX:
1043             raw_call(receiver, b"", value=d_balance)
1044         else:
1045             coin: address = _coins[i]
1046             if i == ETH_INDEX:
1047                 WETH(_coins[i]).deposit(value=d_balance)
1048             assert ERC20(_coins[i]).transfer(receiver, d_balance)
1049 
1050     D: uint256 = self.D
1051     self.D = D - D * amount / total_supply
1052 
1053     log RemoveLiquidity(msg.sender, balances, total_supply - _amount)
1054 
1055 
1056 @view
1057 @external
1058 def calc_token_amount(amounts: uint256[N_COINS]) -> uint256:
1059     token_supply: uint256 = CurveToken(token).totalSupply()
1060     price_scale: uint256 = self.price_scale * PRECISIONS[1]
1061     A_gamma: uint256[2] = self._A_gamma()
1062     xp: uint256[N_COINS] = self.xp()
1063     amountsp: uint256[N_COINS] = [
1064         amounts[0] * PRECISIONS[0],
1065         amounts[1] * price_scale / PRECISION]
1066     D0: uint256 = self.D
1067     if self.future_A_gamma_time > 0:
1068         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1069     xp[0] += amountsp[0]
1070     xp[1] += amountsp[1]
1071     D: uint256 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1072     d_token: uint256 = token_supply * D / D0 - token_supply
1073     d_token -= self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
1074     return d_token
1075 
1076 
1077 @internal
1078 @view
1079 def _calc_withdraw_one_coin(A_gamma: uint256[2], token_amount: uint256, i: uint256, update_D: bool,
1080                             calc_price: bool) -> (uint256, uint256, uint256, uint256[N_COINS]):
1081     token_supply: uint256 = CurveToken(token).totalSupply()
1082     assert token_amount <= token_supply  # dev: token amount more than supply
1083     assert i < N_COINS  # dev: coin out of range
1084 
1085     xx: uint256[N_COINS] = self.balances
1086     D0: uint256 = 0
1087 
1088     price_scale_i: uint256 = self.price_scale * PRECISIONS[1]
1089     xp: uint256[N_COINS] = [xx[0] * PRECISIONS[0], xx[1] * price_scale_i / PRECISION]
1090     if i == 0:
1091         price_scale_i = PRECISION * PRECISIONS[0]
1092 
1093     if update_D:
1094         D0 = self.newton_D(A_gamma[0], A_gamma[1], xp)
1095     else:
1096         D0 = self.D
1097 
1098     D: uint256 = D0
1099 
1100     # Charge the fee on D, not on y, e.g. reducing invariant LESS than charging the user
1101     fee: uint256 = self._fee(xp)
1102     dD: uint256 = token_amount * D / token_supply
1103     D -= (dD - (fee * dD / (2 * 10**10) + 1))
1104     y: uint256 = self.newton_y(A_gamma[0], A_gamma[1], xp, D, i)
1105     dy: uint256 = (xp[i] - y) * PRECISION / price_scale_i
1106     xp[i] = y
1107 
1108     # Price calc
1109     p: uint256 = 0
1110     if calc_price and dy > 10**5 and token_amount > 10**5:
1111         # p_i = dD / D0 * sum'(p_k * x_k) / (dy - dD / D0 * y0)
1112         S: uint256 = 0
1113         precision: uint256 = PRECISIONS[0]
1114         if i == 1:
1115             S = xx[0] * PRECISIONS[0]
1116             precision = PRECISIONS[1]
1117         else:
1118             S = xx[1] * PRECISIONS[1]
1119         S = S * dD / D0
1120         p = S * PRECISION / (dy * precision - dD * xx[i] * precision / D0)
1121         if i == 0:
1122             p = (10**18)**2 / p
1123 
1124     return dy, p, D, xp
1125 
1126 
1127 @view
1128 @external
1129 def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256:
1130     return self._calc_withdraw_one_coin(self._A_gamma(), token_amount, i, True, False)[0]
1131 
1132 
1133 @external
1134 @nonreentrant('lock')
1135 def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256,
1136                               use_eth: bool = False, receiver: address = msg.sender) -> uint256:
1137     assert not self.is_killed  # dev: the pool is killed
1138 
1139     A_gamma: uint256[2] = self._A_gamma()
1140 
1141     dy: uint256 = 0
1142     D: uint256 = 0
1143     p: uint256 = 0
1144     xp: uint256[N_COINS] = empty(uint256[N_COINS])
1145     future_A_gamma_time: uint256 = self.future_A_gamma_time
1146     dy, p, D, xp = self._calc_withdraw_one_coin(A_gamma, token_amount, i, (future_A_gamma_time > 0), True)
1147     assert dy >= min_amount, "Slippage"
1148 
1149     if block.timestamp >= future_A_gamma_time:
1150         self.future_A_gamma_time = 1
1151 
1152     self.balances[i] -= dy
1153     CurveToken(token).burnFrom(msg.sender, token_amount)
1154 
1155     _coins: address[N_COINS] = coins
1156     if use_eth and i == ETH_INDEX:
1157         raw_call(receiver, b"", value=dy)
1158     else:
1159         coin: address = _coins[i]
1160         if i == ETH_INDEX:
1161             WETH(coin).deposit(value=dy)
1162         assert ERC20(coin).transfer(receiver, dy)
1163 
1164     self.tweak_price(A_gamma, xp, p, D)
1165 
1166     log RemoveLiquidityOne(msg.sender, token_amount, i, dy)
1167 
1168     return dy
1169 
1170 
1171 @external
1172 @nonreentrant('lock')
1173 def claim_admin_fees():
1174     self._claim_admin_fees()
1175 
1176 
1177 # Admin parameters
1178 @external
1179 def ramp_A_gamma(future_A: uint256, future_gamma: uint256, future_time: uint256):
1180     assert msg.sender == self.owner  # dev: only owner
1181     assert block.timestamp > self.initial_A_gamma_time + (MIN_RAMP_TIME-1)
1182     assert future_time > block.timestamp + (MIN_RAMP_TIME-1)  # dev: insufficient time
1183 
1184     A_gamma: uint256[2] = self._A_gamma()
1185     initial_A_gamma: uint256 = shift(A_gamma[0], 128)
1186     initial_A_gamma = bitwise_or(initial_A_gamma, A_gamma[1])
1187 
1188     assert future_A > MIN_A-1
1189     assert future_A < MAX_A+1
1190     assert future_gamma > MIN_GAMMA-1
1191     assert future_gamma < MAX_GAMMA+1
1192 
1193     ratio: uint256 = 10**18 * future_A / A_gamma[0]
1194     assert ratio < 10**18 * MAX_A_CHANGE + 1
1195     assert ratio > 10**18 / MAX_A_CHANGE - 1
1196 
1197     ratio = 10**18 * future_gamma / A_gamma[1]
1198     assert ratio < 10**18 * MAX_A_CHANGE + 1
1199     assert ratio > 10**18 / MAX_A_CHANGE - 1
1200 
1201     self.initial_A_gamma = initial_A_gamma
1202     self.initial_A_gamma_time = block.timestamp
1203 
1204     future_A_gamma: uint256 = shift(future_A, 128)
1205     future_A_gamma = bitwise_or(future_A_gamma, future_gamma)
1206     self.future_A_gamma_time = future_time
1207     self.future_A_gamma = future_A_gamma
1208 
1209     log RampAgamma(A_gamma[0], future_A, A_gamma[1], future_gamma, block.timestamp, future_time)
1210 
1211 
1212 @external
1213 def stop_ramp_A_gamma():
1214     assert msg.sender == self.owner  # dev: only owner
1215 
1216     A_gamma: uint256[2] = self._A_gamma()
1217     current_A_gamma: uint256 = shift(A_gamma[0], 128)
1218     current_A_gamma = bitwise_or(current_A_gamma, A_gamma[1])
1219     self.initial_A_gamma = current_A_gamma
1220     self.future_A_gamma = current_A_gamma
1221     self.initial_A_gamma_time = block.timestamp
1222     self.future_A_gamma_time = block.timestamp
1223     # now (block.timestamp < t1) is always False, so we return saved A
1224 
1225     log StopRampA(A_gamma[0], A_gamma[1], block.timestamp)
1226 
1227 
1228 @external
1229 def commit_new_parameters(
1230     _new_mid_fee: uint256,
1231     _new_out_fee: uint256,
1232     _new_admin_fee: uint256,
1233     _new_fee_gamma: uint256,
1234     _new_allowed_extra_profit: uint256,
1235     _new_adjustment_step: uint256,
1236     _new_ma_half_time: uint256,
1237     ):
1238     assert msg.sender == self.owner  # dev: only owner
1239     assert self.admin_actions_deadline == 0  # dev: active action
1240 
1241     new_mid_fee: uint256 = _new_mid_fee
1242     new_out_fee: uint256 = _new_out_fee
1243     new_admin_fee: uint256 = _new_admin_fee
1244     new_fee_gamma: uint256 = _new_fee_gamma
1245     new_allowed_extra_profit: uint256 = _new_allowed_extra_profit
1246     new_adjustment_step: uint256 = _new_adjustment_step
1247     new_ma_half_time: uint256 = _new_ma_half_time
1248 
1249     # Fees
1250     if new_out_fee < MAX_FEE+1:
1251         assert new_out_fee > MIN_FEE-1  # dev: fee is out of range
1252     else:
1253         new_out_fee = self.out_fee
1254     if new_mid_fee > MAX_FEE:
1255         new_mid_fee = self.mid_fee
1256     assert new_mid_fee <= new_out_fee  # dev: mid-fee is too high
1257     if new_admin_fee > MAX_ADMIN_FEE:
1258         new_admin_fee = self.admin_fee
1259 
1260     # AMM parameters
1261     if new_fee_gamma < 10**18:
1262         assert new_fee_gamma > 0  # dev: fee_gamma out of range [1 .. 10**18]
1263     else:
1264         new_fee_gamma = self.fee_gamma
1265     if new_allowed_extra_profit > 10**18:
1266         new_allowed_extra_profit = self.allowed_extra_profit
1267     if new_adjustment_step > 10**18:
1268         new_adjustment_step = self.adjustment_step
1269 
1270     # MA
1271     if new_ma_half_time < 7*86400:
1272         assert new_ma_half_time > 0  # dev: MA time should be longer than 1 second
1273     else:
1274         new_ma_half_time = self.ma_half_time
1275 
1276     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1277     self.admin_actions_deadline = _deadline
1278 
1279     self.future_admin_fee = new_admin_fee
1280     self.future_mid_fee = new_mid_fee
1281     self.future_out_fee = new_out_fee
1282     self.future_fee_gamma = new_fee_gamma
1283     self.future_allowed_extra_profit = new_allowed_extra_profit
1284     self.future_adjustment_step = new_adjustment_step
1285     self.future_ma_half_time = new_ma_half_time
1286 
1287     log CommitNewParameters(_deadline, new_admin_fee, new_mid_fee, new_out_fee,
1288                             new_fee_gamma,
1289                             new_allowed_extra_profit, new_adjustment_step,
1290                             new_ma_half_time)
1291 
1292 
1293 @external
1294 @nonreentrant('lock')
1295 def apply_new_parameters():
1296     assert msg.sender == self.owner  # dev: only owner
1297     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
1298     assert self.admin_actions_deadline != 0  # dev: no active action
1299 
1300     self.admin_actions_deadline = 0
1301 
1302     admin_fee: uint256 = self.future_admin_fee
1303     if self.admin_fee != admin_fee:
1304         self._claim_admin_fees()
1305         self.admin_fee = admin_fee
1306 
1307     mid_fee: uint256 = self.future_mid_fee
1308     self.mid_fee = mid_fee
1309     out_fee: uint256 = self.future_out_fee
1310     self.out_fee = out_fee
1311     fee_gamma: uint256 = self.future_fee_gamma
1312     self.fee_gamma = fee_gamma
1313     allowed_extra_profit: uint256 = self.future_allowed_extra_profit
1314     self.allowed_extra_profit = allowed_extra_profit
1315     adjustment_step: uint256 = self.future_adjustment_step
1316     self.adjustment_step = adjustment_step
1317     ma_half_time: uint256 = self.future_ma_half_time
1318     self.ma_half_time = ma_half_time
1319 
1320     log NewParameters(admin_fee, mid_fee, out_fee,
1321                       fee_gamma,
1322                       allowed_extra_profit, adjustment_step,
1323                       ma_half_time)
1324 
1325 
1326 @external
1327 def revert_new_parameters():
1328     assert msg.sender == self.owner  # dev: only owner
1329 
1330     self.admin_actions_deadline = 0
1331 
1332 
1333 @external
1334 def commit_transfer_ownership(_owner: address):
1335     assert msg.sender == self.owner  # dev: only owner
1336     assert self.transfer_ownership_deadline == 0  # dev: active transfer
1337 
1338     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
1339     self.transfer_ownership_deadline = _deadline
1340     self.future_owner = _owner
1341 
1342     log CommitNewAdmin(_deadline, _owner)
1343 
1344 
1345 @external
1346 def apply_transfer_ownership():
1347     assert msg.sender == self.owner  # dev: only owner
1348     assert block.timestamp >= self.transfer_ownership_deadline  # dev: insufficient time
1349     assert self.transfer_ownership_deadline != 0  # dev: no active transfer
1350 
1351     self.transfer_ownership_deadline = 0
1352     _owner: address = self.future_owner
1353     self.owner = _owner
1354 
1355     log NewAdmin(_owner)
1356 
1357 
1358 @external
1359 def revert_transfer_ownership():
1360     assert msg.sender == self.owner  # dev: only owner
1361 
1362     self.transfer_ownership_deadline = 0
1363 
1364 
1365 @external
1366 def kill_me():
1367     assert msg.sender == self.owner  # dev: only owner
1368     assert self.kill_deadline > block.timestamp  # dev: deadline has passed
1369     self.is_killed = True
1370 
1371 
1372 @external
1373 def unkill_me():
1374     assert msg.sender == self.owner  # dev: only owner
1375     self.is_killed = False
1376 
1377 
1378 @external
1379 def set_admin_fee_receiver(_admin_fee_receiver: address):
1380     assert msg.sender == self.owner  # dev: only owner
1381     self.admin_fee_receiver = _admin_fee_receiver
1382 
1383 
1384 @internal
1385 @pure
1386 def sqrt_int(x: uint256) -> uint256:
1387     """
1388     Originating from: https://github.com/vyperlang/vyper/issues/1266
1389     """
1390 
1391     if x == 0:
1392         return 0
1393 
1394     z: uint256 = (x + 10**18) / 2
1395     y: uint256 = x
1396 
1397     for i in range(256):
1398         if z == y:
1399             return y
1400         y = z
1401         z = (x * 10**18 / z + z) / 2
1402 
1403     raise "Did not converge"
1404 
1405 
1406 @external
1407 @view
1408 def lp_price() -> uint256:
1409     """
1410     Approximate LP token price
1411     """
1412     return 2 * self.virtual_price * self.sqrt_int(self.internal_price_oracle()) / 10**18
