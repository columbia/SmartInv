1 # @version 0.3.7
2 """
3 @title crvUSD Controller
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2023 - all rights reserved
6 """
7 
8 interface LLAMMA:
9     def A() -> uint256: view
10     def get_p() -> uint256: view
11     def get_base_price() -> uint256: view
12     def active_band() -> int256: view
13     def active_band_with_skip() -> int256: view
14     def p_oracle_up(n: int256) -> uint256: view
15     def p_oracle_down(n: int256) -> uint256: view
16     def deposit_range(user: address, amount: uint256, n1: int256, n2: int256): nonpayable
17     def read_user_tick_numbers(_for: address) -> int256[2]: view
18     def get_sum_xy(user: address) -> uint256[2]: view
19     def withdraw(user: address, frac: uint256) -> uint256[2]: nonpayable
20     def get_x_down(user: address) -> uint256: view
21     def get_rate_mul() -> uint256: view
22     def set_rate(rate: uint256) -> uint256: nonpayable
23     def set_fee(fee: uint256): nonpayable
24     def set_admin_fee(fee: uint256): nonpayable
25     def price_oracle() -> uint256: view
26     def can_skip_bands(n_end: int256) -> bool: view
27     def set_price_oracle(price_oracle: PriceOracle): nonpayable
28     def admin_fees_x() -> uint256: view
29     def admin_fees_y() -> uint256: view
30     def reset_admin_fees(): nonpayable
31     def has_liquidity(user: address) -> bool: view
32     def bands_x(n: int256) -> uint256: view
33     def bands_y(n: int256) -> uint256: view
34     def set_callback(user: address): nonpayable
35 
36 interface ERC20:
37     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: nonpayable
38     def transfer(_to: address, _value: uint256) -> bool: nonpayable
39     def decimals() -> uint256: view
40     def approve(_spender: address, _value: uint256) -> bool: nonpayable
41     def balanceOf(_from: address) -> uint256: view
42 
43 interface WETH:
44     def deposit(): payable
45     def withdraw(_amount: uint256): nonpayable
46 
47 interface MonetaryPolicy:
48     def rate_write() -> uint256: nonpayable
49 
50 interface Factory:
51     def stablecoin() -> address: view
52     def admin() -> address: view
53     def fee_receiver() -> address: view
54     def WETH() -> address: view
55 
56 interface PriceOracle:
57     def price() -> uint256: view
58     def price_w() -> uint256: nonpayable
59 
60 
61 event UserState:
62     user: indexed(address)
63     collateral: uint256
64     debt: uint256
65     n1: int256
66     n2: int256
67     liquidation_discount: uint256
68 
69 event Borrow:
70     user: indexed(address)
71     collateral_increase: uint256
72     loan_increase: uint256
73 
74 event Repay:
75     user: indexed(address)
76     collateral_decrease: uint256
77     loan_decrease: uint256
78 
79 event RemoveCollateral:
80     user: indexed(address)
81     collateral_decrease: uint256
82 
83 event Liquidate:
84     liquidator: indexed(address)
85     user: indexed(address)
86     collateral_received: uint256
87     stablecoin_received: uint256
88     debt: uint256
89 
90 event SetMonetaryPolicy:
91     monetary_policy: address
92 
93 event SetBorrowingDiscounts:
94     loan_discount: uint256
95     liquidation_discount: uint256
96 
97 event CollectFees:
98     amount: uint256
99     new_supply: uint256
100 
101 
102 struct Loan:
103     initial_debt: uint256
104     rate_mul: uint256
105 
106 struct Position:
107     user: address
108     x: uint256
109     y: uint256
110     debt: uint256
111     health: int256
112 
113 struct CallbackData:
114     active_band: int256
115     stablecoins: uint256
116     collateral: uint256
117 
118 
119 FACTORY: immutable(Factory)
120 STABLECOIN: immutable(ERC20)
121 MAX_LOAN_DISCOUNT: constant(uint256) = 5 * 10**17
122 MIN_LIQUIDATION_DISCOUNT: constant(uint256) = 10**16 # Start liquidating when threshold reached
123 MAX_TICKS: constant(int256) = 50
124 MAX_TICKS_UINT: constant(uint256) = 50
125 MIN_TICKS: constant(int256) = 4
126 MAX_SKIP_TICKS: constant(uint256) = 1024
127 MAX_P_BASE_BANDS: constant(int256) = 5
128 
129 MAX_RATE: constant(uint256) = 43959106799  # 400% APY
130 
131 loan: HashMap[address, Loan]
132 liquidation_discounts: public(HashMap[address, uint256])
133 _total_debt: Loan
134 
135 loans: public(address[2**64 - 1])  # Enumerate existing loans
136 loan_ix: public(HashMap[address, uint256])  # Position of the loan in the list
137 n_loans: public(uint256)  # Number of nonzero loans
138 
139 minted: public(uint256)
140 redeemed: public(uint256)
141 
142 monetary_policy: public(MonetaryPolicy)
143 liquidation_discount: public(uint256)
144 loan_discount: public(uint256)
145 
146 COLLATERAL_TOKEN: immutable(ERC20)
147 COLLATERAL_PRECISION: immutable(uint256)
148 
149 AMM: immutable(LLAMMA)
150 A: immutable(uint256)
151 Aminus1: immutable(uint256)
152 LOG2_A_RATIO: immutable(int256)  # log(A / (A - 1))
153 SQRT_BAND_RATIO: immutable(uint256)
154 
155 MAX_ADMIN_FEE: constant(uint256) = 10**18  # 100%
156 MIN_FEE: constant(uint256) = 10**6  # 1e-12, still needs to be above 0
157 MAX_FEE: constant(uint256) = 10**17  # 10%
158 
159 USE_ETH: immutable(bool)
160 
161 CALLBACK_DEPOSIT: constant(bytes4) = method_id("callback_deposit(address,uint256,uint256,uint256,uint256[])", output_type=bytes4)
162 CALLBACK_REPAY: constant(bytes4) = method_id("callback_repay(address,uint256,uint256,uint256,uint256[])", output_type=bytes4)
163 CALLBACK_LIQUIDATE: constant(bytes4) = method_id("callback_liquidate(address,uint256,uint256,uint256,uint256[])", output_type=bytes4)
164 
165 DEAD_SHARES: constant(uint256) = 1000
166 
167 MAX_ETH_GAS: constant(uint256) = 10000  # Forward this much gas to ETH transfers (2300 is what send() does)
168 
169 
170 @external
171 def __init__(
172         collateral_token: address,
173         monetary_policy: address,
174         loan_discount: uint256,
175         liquidation_discount: uint256,
176         amm: address):
177     """
178     @notice Controller constructor deployed by the factory from blueprint
179     @param collateral_token Token to use for collateral
180     @param monetary_policy Address of monetary policy
181     @param loan_discount Discount of the maximum loan size compare to get_x_down() value
182     @param liquidation_discount Discount of the maximum loan size compare to
183            get_x_down() for "bad liquidation" purposes
184     @param amm AMM address (Already deployed from blueprint)
185     """
186     FACTORY = Factory(msg.sender)
187     stablecoin: ERC20 = ERC20(Factory(msg.sender).stablecoin())
188     STABLECOIN = stablecoin
189     assert stablecoin.decimals() == 18
190 
191     self.monetary_policy = MonetaryPolicy(monetary_policy)
192 
193     self.liquidation_discount = liquidation_discount
194     self.loan_discount = loan_discount
195     self._total_debt.rate_mul = 10**18
196 
197     AMM = LLAMMA(amm)
198     _A: uint256 = LLAMMA(amm).A()
199     A = _A
200     Aminus1 = _A - 1
201     LOG2_A_RATIO = self.log2(_A * 10**18 / unsafe_sub(_A, 1))
202 
203     COLLATERAL_TOKEN = ERC20(collateral_token)
204     COLLATERAL_PRECISION = pow_mod256(10, 18 - ERC20(collateral_token).decimals())
205 
206     SQRT_BAND_RATIO = isqrt(unsafe_div(10**36 * _A, unsafe_sub(_A, 1)))
207 
208     stablecoin.approve(msg.sender, max_value(uint256))
209 
210     if Factory(msg.sender).WETH() == collateral_token:
211         USE_ETH = True
212 
213 
214 @payable
215 @external
216 def __default__():
217     if msg.value > 0:
218         assert USE_ETH
219     assert len(msg.data) == 0
220 
221 
222 @internal
223 @pure
224 def log2(_x: uint256) -> int256:
225     """
226     @notice int(1e18 * log2(_x / 1e18))
227     """
228     # adapted from: https://medium.com/coinmonks/9aef8515136e
229     # and vyper log implementation
230     # Might use more optimal solmate's log
231     inverse: bool = _x < 10**18
232     res: uint256 = 0
233     x: uint256 = _x
234     if inverse:
235         x = 10**36 / x
236     t: uint256 = 2**7
237     for i in range(8):
238         p: uint256 = pow_mod256(2, t)
239         if x >= unsafe_mul(p, 10**18):
240             x = unsafe_div(x, p)
241             res = unsafe_add(unsafe_mul(t, 10**18), res)
242         t = unsafe_div(t, 2)
243     d: uint256 = 10**18
244     for i in range(34):  # 10 decimals: math.log(10**10, 2) == 33.2. Need more?
245         if (x >= 2 * 10**18):
246             res = unsafe_add(res, d)
247             x = unsafe_div(x, 2)
248         x = unsafe_div(unsafe_mul(x, x), 10**18)
249         d = unsafe_div(d, 2)
250     if inverse:
251         return -convert(res, int256)
252     else:
253         return convert(res, int256)
254 
255 
256 @external
257 @view
258 def factory() -> Factory:
259     """
260     @notice Address of the factory
261     """
262     return FACTORY
263 
264 
265 @external
266 @view
267 def amm() -> LLAMMA:
268     """
269     @notice Address of the AMM
270     """
271     return AMM
272 
273 
274 @external
275 @view
276 def collateral_token() -> ERC20:
277     """
278     @notice Address of the collateral token
279     """
280     return COLLATERAL_TOKEN
281 
282 
283 @internal
284 def _rate_mul_w() -> uint256:
285     """
286     @notice Getter for rate_mul (the one which is 1.0+) from the AMM
287     """
288     rate: uint256 = min(self.monetary_policy.rate_write(), MAX_RATE)
289     return AMM.set_rate(rate)
290 
291 
292 @internal
293 def _debt(user: address) -> (uint256, uint256):
294     """
295     @notice Get the value of debt and rate_mul and update the rate_mul counter
296     @param user User address
297     @return (debt, rate_mul)
298     """
299     rate_mul: uint256 = self._rate_mul_w()
300     loan: Loan = self.loan[user]
301     if loan.initial_debt == 0:
302         return (0, rate_mul)
303     else:
304         return (loan.initial_debt * rate_mul / loan.rate_mul, rate_mul)
305 
306 
307 @internal
308 @view
309 def _debt_ro(user: address) -> uint256:
310     """
311     @notice Get the value of debt without changing the state
312     @param user User address
313     @return Value of debt
314     """
315     rate_mul: uint256 = AMM.get_rate_mul()
316     loan: Loan = self.loan[user]
317     if loan.initial_debt == 0:
318         return 0
319     else:
320         return loan.initial_debt * rate_mul / loan.rate_mul
321 
322 
323 @external
324 @view
325 @nonreentrant('lock')
326 def debt(user: address) -> uint256:
327     """
328     @notice Get the value of debt without changing the state
329     @param user User address
330     @return Value of debt
331     """
332     return self._debt_ro(user)
333 
334 
335 @external
336 @view
337 @nonreentrant('lock')
338 def loan_exists(user: address) -> bool:
339     """
340     @notice Check whether there is a loan of `user` in existence
341     """
342     return self.loan[user].initial_debt > 0
343 
344 
345 # No decorator because used in monetary policy
346 @external
347 @view
348 def total_debt() -> uint256:
349     """
350     @notice Total debt of this controller
351     """
352     rate_mul: uint256 = AMM.get_rate_mul()
353     loan: Loan = self._total_debt
354     return loan.initial_debt * rate_mul / loan.rate_mul
355 
356 
357 @internal
358 @view
359 def get_y_effective(collateral: uint256, N: uint256, discount: uint256) -> uint256:
360     """
361     @notice Intermediary method which calculates y_effective defined as x_effective / p_base,
362             however discounted by loan_discount.
363             x_effective is an amount which can be obtained from collateral when liquidating
364     @param collateral Amount of collateral to get the value for
365     @param N Number of bands the deposit is made into
366     @param discount Loan discount at 1e18 base (e.g. 1e18 == 100%)
367     @return y_effective
368     """
369     # x_effective = sum_{i=0..N-1}(y / N * p(n_{n1+i})) =
370     # = y / N * p_oracle_up(n1) * sqrt((A - 1) / A) * sum_{0..N-1}(((A-1) / A)**k)
371     # === d_y_effective * p_oracle_up(n1) * sum(...) === y_effective * p_oracle_up(n1)
372     # d_y_effective = y / N / sqrt(A / (A - 1))
373     # d_y_effective: uint256 = collateral * unsafe_sub(10**18, discount) / (SQRT_BAND_RATIO * N)
374     # Make some extra discount to always deposit lower when we have DEAD_SHARES rounding
375     d_y_effective: uint256 = collateral * unsafe_sub(
376         10**18, min(discount + (DEAD_SHARES * 10**18) / max(collateral / N, DEAD_SHARES), 10**18)
377     ) / (SQRT_BAND_RATIO * N)
378     y_effective: uint256 = d_y_effective
379     for i in range(1, MAX_TICKS_UINT):
380         if i == N:
381             break
382         d_y_effective = unsafe_div(d_y_effective * Aminus1, A)
383         y_effective = unsafe_add(y_effective, d_y_effective)
384     return y_effective
385 
386 
387 @internal
388 @view
389 def _calculate_debt_n1(collateral: uint256, debt: uint256, N: uint256) -> int256:
390     """
391     @notice Calculate the upper band number for the deposit to sit in to support
392             the given debt. Reverts if requested debt is too high.
393     @param collateral Amount of collateral (at its native precision)
394     @param debt Amount of requested debt
395     @param N Number of bands to deposit into
396     @return Upper band n1 (n1 <= n2) to deposit into. Signed integer
397     """
398     assert debt > 0, "No loan"
399     n0: int256 = AMM.active_band()
400     p_base: uint256 = AMM.p_oracle_up(n0)
401 
402     # x_effective = y / N * p_oracle_up(n1) * sqrt((A - 1) / A) * sum_{0..N-1}(((A-1) / A)**k)
403     # === d_y_effective * p_oracle_up(n1) * sum(...) === y_effective * p_oracle_up(n1)
404     # d_y_effective = y / N / sqrt(A / (A - 1))
405     y_effective: uint256 = self.get_y_effective(collateral * COLLATERAL_PRECISION, N, self.loan_discount)
406     # p_oracle_up(n1) = base_price * ((A - 1) / A)**n1
407 
408     # We borrow up until min band touches p_oracle,
409     # or it touches non-empty bands which cannot be skipped.
410     # We calculate required n1 for given (collateral, debt),
411     # and if n1 corresponds to price_oracle being too high, or unreachable band
412     # - we revert.
413 
414     # n1 is band number based on adiabatic trading, e.g. when p_oracle ~ p
415     y_effective = y_effective * p_base / (debt + 1)  # Now it's a ratio
416 
417     # n1 = floor(log2(y_effective) / self.logAratio)
418     # EVM semantics is not doing floor unlike Python, so we do this
419     assert y_effective > 0, "Amount too low"
420     n1: int256 = self.log2(y_effective)  # <- switch to faster ln() XXX?
421     if n1 < 0:
422         n1 -= LOG2_A_RATIO - 1  # This is to deal with vyper's rounding of negative numbers
423     n1 /= LOG2_A_RATIO
424 
425     n1 = min(n1, 1024 - convert(N, int256)) + n0
426     if n1 <= n0:
427         assert AMM.can_skip_bands(n1 - 1), "Debt too high"
428 
429     # Let's not rely on active_band corresponding to price_oracle:
430     # this will be not correct if we are in the area of empty bands
431     assert AMM.p_oracle_up(n1) < AMM.price_oracle(), "Debt too high"
432 
433     return n1
434 
435 
436 @internal
437 @view
438 def max_p_base() -> uint256:
439     """
440     @notice Calculate max base price including skipping bands
441     """
442     p_oracle: uint256 = AMM.price_oracle()
443     # Should be correct unless price changes suddenly by MAX_P_BASE_BANDS+ bands
444     n1: int256 = unsafe_div(self.log2(AMM.get_base_price() * 10**18 / p_oracle), LOG2_A_RATIO) + MAX_P_BASE_BANDS
445     p_base: uint256 = AMM.p_oracle_up(n1)
446     n_min: int256 = AMM.active_band_with_skip()
447 
448     for i in range(MAX_SKIP_TICKS + 1):
449         n1 -= 1
450         if n1 <= n_min:
451             break
452         p_base_prev: uint256 = p_base
453         p_base = unsafe_div(p_base * A, Aminus1)
454         if p_base > p_oracle:
455             return p_base_prev
456 
457     return p_base
458 
459 
460 @external
461 @view
462 @nonreentrant('lock')
463 def max_borrowable(collateral: uint256, N: uint256) -> uint256:
464     """
465     @notice Calculation of maximum which can be borrowed (details in comments)
466     @param collateral Collateral amount against which to borrow
467     @param N number of bands to have the deposit into
468     @return Maximum amount of stablecoin to borrow
469     """
470     # Calculation of maximum which can be borrowed.
471     # It corresponds to a minimum between the amount corresponding to price_oracle
472     # and the one given by the min reachable band.
473     #
474     # Given by p_oracle (perhaps needs to be multiplied by (A - 1) / A to account for mid-band effects)
475     # x_max ~= y_effective * p_oracle
476     #
477     # Given by band number:
478     # if n1 is the lowest empty band in the AMM
479     # xmax ~= y_effective * amm.p_oracle_up(n1)
480     #
481     # When n1 -= 1:
482     # p_oracle_up *= A / (A - 1)
483 
484     y_effective: uint256 = self.get_y_effective(collateral * COLLATERAL_PRECISION, N, self.loan_discount)
485 
486     x: uint256 = unsafe_sub(max(unsafe_div(y_effective * self.max_p_base(), 10**18), 1), 1)
487     x = unsafe_div(x * (10**18 - 10**14), 10**18)  # Make it a bit smaller
488     return min(x, STABLECOIN.balanceOf(self))  # Cannot borrow beyond the amount of coins Controller has
489 
490 
491 @external
492 @view
493 @nonreentrant('lock')
494 def min_collateral(debt: uint256, N: uint256) -> uint256:
495     """
496     @notice Minimal amount of collateral required to support debt
497     @param debt The debt to support
498     @param N Number of bands to deposit into
499     @return Minimal collateral required
500     """
501     # Add N**2 to account for precision loss in multiple bands, e.g. N * 1 / (y/N) = N**2 / y
502     return unsafe_div(unsafe_div(debt * 10**18 / self.max_p_base() * 10**18 / self.get_y_effective(10**18, N, self.loan_discount) + N * (N + 2 * DEAD_SHARES), COLLATERAL_PRECISION) * 10**18, 10**18 - 10**14)
503 
504 
505 @external
506 @view
507 @nonreentrant('lock')
508 def calculate_debt_n1(collateral: uint256, debt: uint256, N: uint256) -> int256:
509     """
510     @notice Calculate the upper band number for the deposit to sit in to support
511             the given debt. Reverts if requested debt is too high.
512     @param collateral Amount of collateral (at its native precision)
513     @param debt Amount of requested debt
514     @param N Number of bands to deposit into
515     @return Upper band n1 (n1 <= n2) to deposit into. Signed integer
516     """
517     return self._calculate_debt_n1(collateral, debt, N)
518 
519 
520 @internal
521 def _deposit_collateral(amount: uint256, mvalue: uint256):
522     """
523     Deposits raw ETH, WETH or both at the same time
524     """
525     if not USE_ETH:
526         assert mvalue == 0  # dev: Not accepting ETH
527     diff: uint256 = amount - mvalue  # dev: Incorrect ETH amount
528     if mvalue > 0:
529         WETH(COLLATERAL_TOKEN.address).deposit(value=mvalue)
530         assert COLLATERAL_TOKEN.transfer(AMM.address, mvalue)
531     if diff > 0:
532         assert COLLATERAL_TOKEN.transferFrom(msg.sender, AMM.address, diff, default_return_value=True)
533 
534 
535 @internal
536 def _withdraw_collateral(_for: address, amount: uint256, use_eth: bool):
537     if use_eth and USE_ETH:
538         assert COLLATERAL_TOKEN.transferFrom(AMM.address, self, amount)
539         WETH(COLLATERAL_TOKEN.address).withdraw(amount)
540         raw_call(_for, b"", value=amount, gas=MAX_ETH_GAS)
541     else:
542         assert COLLATERAL_TOKEN.transferFrom(AMM.address, _for, amount, default_return_value=True)
543 
544 
545 @internal
546 def execute_callback(callbacker: address, callback_sig: bytes4,
547                      user: address, stablecoins: uint256, collateral: uint256, debt: uint256,
548                      callback_args: DynArray[uint256, 5]) -> CallbackData:
549     assert callbacker != COLLATERAL_TOKEN.address
550 
551     data: CallbackData = empty(CallbackData)
552     data.active_band = AMM.active_band()
553     band_x: uint256 = AMM.bands_x(data.active_band)
554     band_y: uint256 = AMM.bands_y(data.active_band)
555 
556     # Callback
557     response: Bytes[64] = raw_call(
558         callbacker,
559         concat(callback_sig, _abi_encode(user, stablecoins, collateral, debt, callback_args)),
560         max_outsize=64
561     )
562     data.stablecoins = convert(slice(response, 0, 32), uint256)
563     data.collateral = convert(slice(response, 32, 32), uint256)
564 
565     # Checks after callback
566     assert data.active_band == AMM.active_band()
567     assert band_x == AMM.bands_x(data.active_band)
568     assert band_y == AMM.bands_y(data.active_band)
569 
570     return data
571 
572 @internal
573 def _create_loan(mvalue: uint256, collateral: uint256, debt: uint256, N: uint256, transfer_coins: bool):
574     assert self.loan[msg.sender].initial_debt == 0, "Loan already created"
575     assert N > MIN_TICKS-1, "Need more ticks"
576     assert N < MAX_TICKS+1, "Need less ticks"
577 
578     n1: int256 = self._calculate_debt_n1(collateral, debt, N)
579     n2: int256 = n1 + convert(N - 1, int256)
580 
581     rate_mul: uint256 = self._rate_mul_w()
582     self.loan[msg.sender] = Loan({initial_debt: debt, rate_mul: rate_mul})
583     liquidation_discount: uint256 = self.liquidation_discount
584     self.liquidation_discounts[msg.sender] = liquidation_discount
585 
586     n_loans: uint256 = self.n_loans
587     self.loans[n_loans] = msg.sender
588     self.loan_ix[msg.sender] = n_loans
589     self.n_loans = unsafe_add(n_loans, 1)
590 
591     total_debt: uint256 = self._total_debt.initial_debt * rate_mul / self._total_debt.rate_mul + debt
592     self._total_debt.initial_debt = total_debt
593     self._total_debt.rate_mul = rate_mul
594 
595     AMM.deposit_range(msg.sender, collateral, n1, n2)
596     self.minted += debt
597 
598     if transfer_coins:
599         self._deposit_collateral(collateral, mvalue)
600         STABLECOIN.transfer(msg.sender, debt)
601 
602     log UserState(msg.sender, collateral, debt, n1, n2, liquidation_discount)
603     log Borrow(msg.sender, collateral, debt)
604 
605 
606 @payable
607 @external
608 @nonreentrant('lock')
609 def create_loan(collateral: uint256, debt: uint256, N: uint256):
610     """
611     @notice Create loan
612     @param collateral Amount of collateral to use
613     @param debt Stablecoin debt to take
614     @param N Number of bands to deposit into (to do autoliquidation-deliquidation),
615            can be from MIN_TICKS to MAX_TICKS
616     """
617     self._create_loan(msg.value, collateral, debt, N, True)
618 
619 
620 @payable
621 @external
622 @nonreentrant('lock')
623 def create_loan_extended(collateral: uint256, debt: uint256, N: uint256, callbacker: address, callback_args: DynArray[uint256,5]):
624     """
625     @notice Create loan but pass stablecoin to a callback first so that it can build leverage
626     @param collateral Amount of collateral to use
627     @param debt Stablecoin debt to take
628     @param N Number of bands to deposit into (to do autoliquidation-deliquidation),
629            can be from MIN_TICKS to MAX_TICKS
630     @param callbacker Address of the callback contract
631     @param callback_args Extra arguments for the callback (up to 5) such as min_amount etc
632     """
633     # Before callback
634     STABLECOIN.transfer(callbacker, debt)
635 
636     # Callback
637     # If there is any unused debt, callbacker can send it to the user
638     more_collateral: uint256 = self.execute_callback(
639         callbacker, CALLBACK_DEPOSIT, msg.sender, 0, collateral, debt, callback_args).collateral
640 
641     # After callback
642     self._deposit_collateral(collateral, msg.value)
643     assert COLLATERAL_TOKEN.transferFrom(callbacker, AMM.address, more_collateral, default_return_value=True)
644     self._create_loan(0, collateral + more_collateral, debt, N, False)
645 
646 
647 @internal
648 def _add_collateral_borrow(d_collateral: uint256, d_debt: uint256, _for: address, remove_collateral: bool):
649     """
650     @notice Internal method to borrow and add or remove collateral
651     @param d_collateral Amount of collateral to add
652     @param d_debt Amount of debt increase
653     @param _for Address to transfer tokens to
654     @param remove_collateral Remove collateral instead of adding
655     """
656     debt: uint256 = 0
657     rate_mul: uint256 = 0
658     debt, rate_mul = self._debt(_for)
659     assert debt > 0, "Loan doesn't exist"
660     debt += d_debt
661     ns: int256[2] = AMM.read_user_tick_numbers(_for)
662     size: uint256 = convert(unsafe_add(unsafe_sub(ns[1], ns[0]), 1), uint256)
663 
664     xy: uint256[2] = AMM.withdraw(_for, 10**18)
665     assert xy[0] == 0, "Already in underwater mode"
666     if remove_collateral:
667         xy[1] -= d_collateral
668     else:
669         xy[1] += d_collateral
670     n1: int256 = self._calculate_debt_n1(xy[1], debt, size)
671     n2: int256 = n1 + unsafe_sub(ns[1], ns[0])
672 
673     AMM.deposit_range(_for, xy[1], n1, n2)
674     self.loan[_for] = Loan({initial_debt: debt, rate_mul: rate_mul})
675     liquidation_discount: uint256 = self.liquidation_discount
676     self.liquidation_discounts[_for] = liquidation_discount
677 
678     if d_debt != 0:
679         total_debt: uint256 = self._total_debt.initial_debt * rate_mul / self._total_debt.rate_mul + d_debt
680         self._total_debt.initial_debt = total_debt
681         self._total_debt.rate_mul = rate_mul
682 
683     if remove_collateral:
684         log RemoveCollateral(_for, d_collateral)
685     else:
686         log Borrow(_for, d_collateral, d_debt)
687     log UserState(_for, xy[1], debt, n1, n2, liquidation_discount)
688 
689 
690 @payable
691 @external
692 @nonreentrant('lock')
693 def add_collateral(collateral: uint256, _for: address = msg.sender):
694     """
695     @notice Add extra collateral to avoid bad liqidations
696     @param collateral Amount of collateral to add
697     @param _for Address to add collateral for
698     """
699     if collateral == 0:
700         return
701     self._add_collateral_borrow(collateral, 0, _for, False)
702     self._deposit_collateral(collateral, msg.value)
703 
704 
705 @external
706 @nonreentrant('lock')
707 def remove_collateral(collateral: uint256, use_eth: bool = True):
708     """
709     @notice Remove some collateral without repaying the debt
710     @param collateral Amount of collateral to remove
711     @param use_eth Use wrapping/unwrapping if collateral is ETH
712     """
713     if collateral == 0:
714         return
715     self._add_collateral_borrow(collateral, 0, msg.sender, True)
716     self._withdraw_collateral(msg.sender, collateral, use_eth)
717 
718 
719 @payable
720 @external
721 @nonreentrant('lock')
722 def borrow_more(collateral: uint256, debt: uint256):
723     """
724     @notice Borrow more stablecoins while adding more collateral (not necessary)
725     @param collateral Amount of collateral to add
726     @param debt Amount of stablecoin debt to take
727     """
728     if debt == 0:
729         return
730     self._add_collateral_borrow(collateral, debt, msg.sender, False)
731     if collateral != 0:
732         self._deposit_collateral(collateral, msg.value)
733     STABLECOIN.transfer(msg.sender, debt)
734     self.minted += debt
735 
736 
737 @internal
738 def _remove_from_list(_for: address):
739     last_loan_ix: uint256 = self.n_loans - 1
740     loan_ix: uint256 = self.loan_ix[_for]
741     assert self.loans[loan_ix] == _for  # dev: should never fail but safety first
742     self.loan_ix[_for] = 0
743     if loan_ix < last_loan_ix:  # Need to replace
744         last_loan: address = self.loans[last_loan_ix]
745         self.loans[loan_ix] = last_loan
746         self.loan_ix[last_loan] = loan_ix
747     self.n_loans = last_loan_ix
748 
749 
750 @payable
751 @external
752 @nonreentrant('lock')
753 def repay(_d_debt: uint256, _for: address = msg.sender, max_active_band: int256 = 2**255-1, use_eth: bool = True):
754     """
755     @notice Repay debt (partially or fully)
756     @param _d_debt The amount of debt to repay. If higher than the current debt - will do full repayment
757     @param _for The user to repay the debt for
758     @param max_active_band Don't allow active band to be higher than this (to prevent front-running the repay)
759     @param use_eth Use wrapping/unwrapping if collateral is ETH
760     """
761     if _d_debt == 0:
762         return
763     # Or repay all for MAX_UINT256
764     # Withdraw if debt become 0
765     debt: uint256 = 0
766     rate_mul: uint256 = 0
767     debt, rate_mul = self._debt(_for)
768     assert debt > 0, "Loan doesn't exist"
769     d_debt: uint256 = min(debt, _d_debt)
770     debt = unsafe_sub(debt, d_debt)
771 
772     if debt == 0:
773         # Allow to withdraw all assets even when underwater
774         xy: uint256[2] = AMM.withdraw(_for, 10**18)
775         if xy[0] > 0:
776             # Only allow full repayment when underwater for the sender to do
777             assert _for == msg.sender
778             STABLECOIN.transferFrom(AMM.address, _for, xy[0])
779         if xy[1] > 0:
780             self._withdraw_collateral(_for, xy[1], use_eth)
781         log UserState(_for, 0, 0, 0, 0, 0)
782         log Repay(_for, xy[1], d_debt)
783         self._remove_from_list(_for)
784 
785     else:
786         active_band: int256 = AMM.active_band_with_skip()
787         assert active_band <= max_active_band
788 
789         ns: int256[2] = AMM.read_user_tick_numbers(_for)
790         size: uint256 = convert(unsafe_add(unsafe_sub(ns[1], ns[0]), 1), uint256)
791         liquidation_discount: uint256 = 0
792 
793         if ns[0] > active_band:
794             # Not in liquidation - can move bands
795             xy: uint256[2] = AMM.withdraw(_for, 10**18)
796             n1: int256 = self._calculate_debt_n1(xy[1], debt, size)
797             n2: int256 = n1 + unsafe_sub(ns[1], ns[0])
798             AMM.deposit_range(_for, xy[1], n1, n2)
799             liquidation_discount = self.liquidation_discount
800             self.liquidation_discounts[_for] = liquidation_discount
801             log UserState(_for, xy[1], debt, n1, n2, liquidation_discount)
802             log Repay(_for, 0, d_debt)
803         else:
804             # Underwater - cannot move band but can avoid a bad liquidation
805             liquidation_discount = self.liquidation_discounts[_for]
806             log UserState(_for, max_value(uint256), debt, ns[0], ns[1], liquidation_discount)
807             log Repay(_for, 0, d_debt)
808 
809         if _for != msg.sender:
810             # Doesn't allow non-sender to repay in a way which ends with unhealthy state
811             # full = False to make this condition non-manipulatable (and also cheaper on gas)
812             assert self._health(_for, debt, False, liquidation_discount) > 0
813 
814     # If we withdrew already - will burn less!
815     STABLECOIN.transferFrom(msg.sender, self, d_debt)  # fail: insufficient funds
816     self.redeemed += d_debt
817 
818     self.loan[_for] = Loan({initial_debt: debt, rate_mul: rate_mul})
819     total_debt: uint256 = self._total_debt.initial_debt * rate_mul / self._total_debt.rate_mul
820     self._total_debt.initial_debt = unsafe_sub(max(total_debt, d_debt), d_debt)
821     self._total_debt.rate_mul = rate_mul
822 
823 
824 @external
825 @nonreentrant('lock')
826 def repay_extended(callbacker: address, callback_args: DynArray[uint256,5]):
827     """
828     @notice Repay loan but get a stablecoin for that from callback (to deleverage)
829     @param callbacker Address of the callback contract
830     @param callback_args Extra arguments for the callback (up to 5) such as min_amount etc
831     """
832     # Before callback
833     ns: int256[2] = AMM.read_user_tick_numbers(msg.sender)
834     xy: uint256[2] = AMM.withdraw(msg.sender, 10**18)
835     debt: uint256 = 0
836     rate_mul: uint256 = 0
837     debt, rate_mul = self._debt(msg.sender)
838     COLLATERAL_TOKEN.transferFrom(AMM.address, callbacker, xy[1], default_return_value=True)
839 
840     cb: CallbackData = self.execute_callback(
841         callbacker, CALLBACK_REPAY, msg.sender, xy[0], xy[1], debt, callback_args)
842 
843     # After callback
844     total_stablecoins: uint256 = cb.stablecoins + xy[0]
845     assert total_stablecoins > 0  # dev: no coins to repay
846 
847     # d_debt: uint256 = min(debt, total_stablecoins)
848 
849     d_debt: uint256 = 0
850 
851     # If we have more stablecoins than the debt - full repayment and closing the position
852     if total_stablecoins >= debt:
853         d_debt = debt
854         debt = 0
855         self._remove_from_list(msg.sender)
856 
857         # Transfer debt to self, everything else to sender
858         if cb.stablecoins > 0:
859             STABLECOIN.transferFrom(callbacker, self, cb.stablecoins)
860         if xy[0] > 0:
861             STABLECOIN.transferFrom(AMM.address, self, xy[0])
862         if total_stablecoins > d_debt:
863             STABLECOIN.transfer(msg.sender, unsafe_sub(total_stablecoins, d_debt))
864         if cb.collateral > 0:
865             assert COLLATERAL_TOKEN.transferFrom(callbacker, msg.sender, cb.collateral, default_return_value=True)
866 
867         log UserState(msg.sender, 0, 0, 0, 0, 0)
868 
869     # Else - partial repayment -> deleverage, but only if we are not underwater
870     else:
871         size: uint256 = convert(unsafe_add(unsafe_sub(ns[1], ns[0]), 1), uint256)
872         assert ns[0] > cb.active_band
873         d_debt = cb.stablecoins  # cb.stablecoins <= total_stablecoins < debt
874         debt = unsafe_sub(debt, cb.stablecoins)
875 
876         # Not in liquidation - can move bands
877         n1: int256 = self._calculate_debt_n1(cb.collateral, debt, size)
878         n2: int256 = n1 + unsafe_sub(ns[1], ns[0])
879         AMM.deposit_range(msg.sender, cb.collateral, n1, n2)
880         liquidation_discount: uint256 = self.liquidation_discount
881         self.liquidation_discounts[msg.sender] = liquidation_discount
882 
883         assert COLLATERAL_TOKEN.transferFrom(callbacker, AMM.address, cb.collateral, default_return_value=True)
884         # Stablecoin is all spent to repay debt -> all goes to self
885         STABLECOIN.transferFrom(callbacker, self, cb.stablecoins)
886         # We are above active band, so xy[0] is 0 anyway
887 
888         log UserState(msg.sender, cb.collateral, debt, n1, n2, liquidation_discount)
889         xy[1] = 0
890 
891         # No need to check _health() because it's the sender
892 
893     # Common calls which we will do regardless of whether it's a full repay or not
894     log Repay(msg.sender, xy[1], d_debt)
895     self.redeemed += d_debt
896     self.loan[msg.sender] = Loan({initial_debt: debt, rate_mul: rate_mul})
897     total_debt: uint256 = self._total_debt.initial_debt * rate_mul / self._total_debt.rate_mul
898     self._total_debt.initial_debt = unsafe_sub(max(total_debt, d_debt), d_debt)
899     self._total_debt.rate_mul = rate_mul
900 
901 
902 @internal
903 @view
904 def _health(user: address, debt: uint256, full: bool, liquidation_discount: uint256) -> int256:
905     """
906     @notice Returns position health normalized to 1e18 for the user.
907             Liquidation starts when < 0, however devaluation of collateral doesn't cause liquidation
908     @param user User address to calculate health for
909     @param debt The amount of debt to calculate health for
910     @param full Whether to take into account the price difference above the highest user's band
911     @param liquidation_discount Liquidation discount to use (can be 0)
912     @return Health: > 0 = good.
913     """
914     assert debt > 0, "Loan doesn't exist"
915     health: int256 = 10**18
916     if liquidation_discount > 0:
917         health -= convert(liquidation_discount, int256)
918     health = unsafe_div(convert(AMM.get_x_down(user), int256) * health, convert(debt, int256)) - 10**18
919 
920     if full:
921         ns: int256[2] = AMM.read_user_tick_numbers(user) # ns[1] > ns[0]
922         if ns[0] > AMM.active_band():  # We are not in liquidation mode
923             p: uint256 = AMM.price_oracle()
924             p_up: uint256 = AMM.p_oracle_up(ns[0])
925             if p > p_up:
926                 health += convert(unsafe_div((p - p_up) * AMM.get_sum_xy(user)[1] * COLLATERAL_PRECISION, debt), int256)
927 
928     return health
929 
930 
931 @external
932 @view
933 @nonreentrant('lock')
934 def health_calculator(user: address, d_collateral: int256, d_debt: int256, full: bool, N: uint256 = 0) -> int256:
935     """
936     @notice Health predictor in case user changes the debt or collateral
937     @param user Address of the user
938     @param d_collateral Change in collateral amount (signed)
939     @param d_debt Change in debt amount (signed)
940     @param full Whether it's a 'full' health or not
941     @param N Number of bands in case loan doesn't yet exist
942     @return Signed health value
943     """
944     xy: uint256[2] = AMM.get_sum_xy(user)
945     xy[1] *= COLLATERAL_PRECISION
946     ns: int256[2] = AMM.read_user_tick_numbers(user)
947     debt: int256 = convert(self._debt_ro(user), int256)
948     n: uint256 = N
949     ld: int256 = 0
950     if debt != 0:
951         ld = convert(self.liquidation_discounts[user], int256)
952         n = convert(unsafe_add(unsafe_sub(ns[1], ns[0]), 1), uint256)
953     else:
954         ld = convert(self.liquidation_discount, int256)
955         ns[0] = max_value(int256)  # This will trigger a "re-deposit"
956 
957     n1: int256 = 0
958     collateral: int256 = 0
959     x_eff: int256 = 0
960     debt += d_debt
961     assert debt > 0, "Non-positive debt"
962 
963     active_band: int256 = AMM.active_band_with_skip()
964 
965     if ns[0] > active_band and (d_collateral != 0 or d_debt != 0):  # re-deposit
966         collateral = convert(xy[1], int256) + d_collateral
967         n1 = self._calculate_debt_n1(convert(collateral, uint256), convert(debt, uint256), n)
968 
969     else:
970         n1 = ns[0]
971         x_eff = convert(AMM.get_x_down(user) * 10**18, int256)
972 
973     p0: int256 = convert(AMM.p_oracle_up(n1), int256)
974     if ns[0] > active_band:
975         x_eff = convert(self.get_y_effective(convert(collateral, uint256), n, 0), int256) * p0
976 
977     health: int256 = unsafe_div(x_eff, debt)
978     health = health - unsafe_div(health * ld, 10**18) - 10**18
979 
980     if full:
981         if n1 > active_band:  # We are not in liquidation mode
982             p_diff: int256 = max(p0, convert(AMM.price_oracle(), int256)) - p0
983             if p_diff > 0:
984                 health += unsafe_div(p_diff * collateral, debt)
985 
986     return health
987 
988 
989 @internal
990 @view
991 def _get_f_remove(frac: uint256, health_limit: uint256) -> uint256:
992     # f_remove = ((1 + h / 2) / (1 + h) * (1 - frac) + frac) * frac
993     f_remove: uint256 = 10 ** 18
994     if frac < 10 ** 18:
995         f_remove = unsafe_div(unsafe_mul(unsafe_add(10 ** 18, unsafe_div(health_limit, 2)), unsafe_sub(10 ** 18, frac)), unsafe_add(10 ** 18, health_limit))
996         f_remove = unsafe_div(unsafe_mul(unsafe_add(f_remove, frac), frac), 10 ** 18)
997 
998     return f_remove
999 
1000 @internal
1001 def _liquidate(user: address, min_x: uint256, health_limit: uint256, frac: uint256, use_eth: bool,
1002                callbacker: address, callback_args: DynArray[uint256,5]):
1003     """
1004     @notice Perform a bad liquidation of user if the health is too bad
1005     @param user Address of the user
1006     @param min_x Minimal amount of stablecoin withdrawn (to avoid liquidators being sandwiched)
1007     @param health_limit Minimal health to liquidate at
1008     @param frac Fraction to liquidate; 100% = 10**18
1009     @param use_eth Use wrapping/unwrapping if collateral is ETH
1010     @param callbacker Address of the callback contract
1011     @param callback_args Extra arguments for the callback (up to 5) such as min_amount etc
1012     """
1013     debt: uint256 = 0
1014     rate_mul: uint256 = 0
1015     debt, rate_mul = self._debt(user)
1016 
1017     if health_limit != 0:
1018         assert self._health(user, debt, True, health_limit) < 0, "Not enough rekt"
1019 
1020     final_debt: uint256 = debt
1021     debt = unsafe_div(debt * frac, 10**18)
1022     assert debt > 0
1023     final_debt = unsafe_sub(final_debt, debt)
1024 
1025     # Withdraw sender's stablecoin and collateral to our contract
1026     # When frac is set - we withdraw a bit less for the same debt fraction
1027     # f_remove = ((1 + h/2) / (1 + h) * (1 - frac) + frac) * frac
1028     # where h is health limit.
1029     # This is less than full h discount but more than no discount
1030     f_remove: uint256 = self._get_f_remove(frac, health_limit)
1031     xy: uint256[2] = AMM.withdraw(user, f_remove)  # [stable, collateral]
1032 
1033     # x increase in same block -> price up -> good
1034     # x decrease in same block -> price down -> bad
1035     assert xy[0] >= min_x, "Slippage"
1036 
1037     min_amm_burn: uint256 = min(xy[0], debt)
1038     if min_amm_burn != 0:
1039         STABLECOIN.transferFrom(AMM.address, self, min_amm_burn)
1040 
1041     if debt > xy[0]:
1042         to_repay: uint256 = unsafe_sub(debt, xy[0])
1043 
1044         if callbacker == empty(address):
1045             # Withdraw collateral if no callback is present
1046             self._withdraw_collateral(msg.sender, xy[1], use_eth)
1047             # Request what's left from user
1048             STABLECOIN.transferFrom(msg.sender, self, to_repay)
1049 
1050         else:
1051             # Move collateral to callbacker, call it and remove everything from it back in
1052             if xy[1] > 0:
1053                 assert COLLATERAL_TOKEN.transferFrom(AMM.address, callbacker, xy[1], default_return_value=True)
1054             # Callback
1055             cb: CallbackData = self.execute_callback(
1056                 callbacker, CALLBACK_LIQUIDATE, user, xy[0], xy[1], debt, callback_args)
1057             assert cb.stablecoins >= to_repay, "not enough proceeds"
1058             if cb.stablecoins > to_repay:
1059                 STABLECOIN.transferFrom(callbacker, msg.sender, unsafe_sub(cb.stablecoins, to_repay))
1060             STABLECOIN.transferFrom(callbacker, self, to_repay)
1061             if cb.collateral > 0:
1062                 assert COLLATERAL_TOKEN.transferFrom(callbacker, msg.sender, cb.collateral)
1063 
1064     else:
1065         # Withdraw collateral
1066         self._withdraw_collateral(msg.sender, xy[1], use_eth)
1067         # Return what's left to user
1068         if xy[0] > debt:
1069             STABLECOIN.transferFrom(AMM.address, msg.sender, unsafe_sub(xy[0], debt))
1070 
1071     self.redeemed += debt
1072     self.loan[user] = Loan({initial_debt: final_debt, rate_mul: rate_mul})
1073     log Repay(user, xy[1], debt)
1074     log Liquidate(msg.sender, user, xy[1], xy[0], debt)
1075     if final_debt == 0:
1076         log UserState(user, 0, 0, 0, 0, 0)  # Not logging partial removeal b/c we have not enough info
1077         self._remove_from_list(user)
1078 
1079     d: uint256 = self._total_debt.initial_debt * rate_mul / self._total_debt.rate_mul
1080     self._total_debt.initial_debt = unsafe_sub(max(d, debt), debt)
1081     self._total_debt.rate_mul = rate_mul
1082 
1083 
1084 @external
1085 @nonreentrant('lock')
1086 def liquidate(user: address, min_x: uint256, use_eth: bool = True):
1087     """
1088     @notice Peform a bad liquidation (or self-liquidation) of user if health is not good
1089     @param min_x Minimal amount of stablecoin to receive (to avoid liquidators being sandwiched)
1090     @param use_eth Use wrapping/unwrapping if collateral is ETH
1091     """
1092     discount: uint256 = 0
1093     if user != msg.sender:
1094         discount = self.liquidation_discounts[user]
1095     self._liquidate(user, min_x, discount, 10**18, use_eth, empty(address), [])
1096 
1097 
1098 @external
1099 @nonreentrant('lock')
1100 def liquidate_extended(user: address, min_x: uint256, frac: uint256, use_eth: bool,
1101                        callbacker: address, callback_args: DynArray[uint256,5]):
1102     """
1103     @notice Peform a bad liquidation (or self-liquidation) of user if health is not good
1104     @param min_x Minimal amount of stablecoin to receive (to avoid liquidators being sandwiched)
1105     @param frac Fraction to liquidate; 100% = 10**18
1106     @param use_eth Use wrapping/unwrapping if collateral is ETH
1107     @param callbacker Address of the callback contract
1108     @param callback_args Extra arguments for the callback (up to 5) such as min_amount etc
1109     """
1110     discount: uint256 = 0
1111     if user != msg.sender:
1112         discount = self.liquidation_discounts[user]
1113     self._liquidate(user, min_x, discount, min(frac, 10**18), use_eth, callbacker, callback_args)
1114 
1115 
1116 @view
1117 @external
1118 @nonreentrant('lock')
1119 def tokens_to_liquidate(user: address, frac: uint256 = 10 ** 18) -> uint256:
1120     """
1121     @notice Calculate the amount of stablecoins to have in liquidator's wallet to liquidate a user
1122     @param user Address of the user to liquidate
1123     @param frac Fraction to liquidate; 100% = 10**18
1124     @return The amount of stablecoins needed
1125     """
1126     health_limit: uint256 = 0
1127     if user != msg.sender:
1128         health_limit = self.liquidation_discounts[user]
1129     f_remove: uint256 = self._get_f_remove(frac, health_limit)
1130     stablecoins: uint256 = unsafe_div(AMM.get_sum_xy(user)[0] * f_remove, 10 ** 18)
1131     debt: uint256 = unsafe_div(self._debt_ro(user) * frac, 10 ** 18)
1132 
1133     return unsafe_sub(max(debt, stablecoins), stablecoins)
1134 
1135 
1136 @view
1137 @external
1138 @nonreentrant('lock')
1139 def health(user: address, full: bool = False) -> int256:
1140     """
1141     @notice Returns position health normalized to 1e18 for the user.
1142             Liquidation starts when < 0, however devaluation of collateral doesn't cause liquidation
1143     """
1144     return self._health(user, self._debt_ro(user), full, self.liquidation_discounts[user])
1145 
1146 
1147 @view
1148 @external
1149 @nonreentrant('lock')
1150 def users_to_liquidate(_from: uint256=0, _limit: uint256=0) -> DynArray[Position, 1000]:
1151     """
1152     @notice Returns a dynamic array of users who can be "hard-liquidated".
1153             This method is designed for convenience of liquidation bots.
1154     @param _from Loan index to start iteration from
1155     @param _limit Number of loans to look over
1156     @return Dynamic array with detailed info about positions of users
1157     """
1158     n_loans: uint256 = self.n_loans
1159     limit: uint256 = _limit
1160     if _limit == 0:
1161         limit = n_loans
1162     ix: uint256 = _from
1163     out: DynArray[Position, 1000] = []
1164     for i in range(10**6):
1165         if ix >= n_loans or i == limit:
1166             break
1167         user: address = self.loans[ix]
1168         debt: uint256 = self._debt_ro(user)
1169         health: int256 = self._health(user, debt, True, self.liquidation_discounts[user])
1170         if health < 0:
1171             xy: uint256[2] = AMM.get_sum_xy(user)
1172             out.append(Position({
1173                 user: user,
1174                 x: xy[0],
1175                 y: xy[1],
1176                 debt: debt,
1177                 health: health
1178             }))
1179         ix += 1
1180     return out
1181 
1182 
1183 # AMM has a nonreentrant decorator
1184 @view
1185 @external
1186 def amm_price() -> uint256:
1187     """
1188     @notice Current price from the AMM
1189     """
1190     return AMM.get_p()
1191 
1192 
1193 @view
1194 @external
1195 @nonreentrant('lock')
1196 def user_prices(user: address) -> uint256[2]:  # Upper, lower
1197     """
1198     @notice Lowest price of the lower band and highest price of the upper band the user has deposit in the AMM
1199     @param user User address
1200     @return (upper_price, lower_price)
1201     """
1202     assert AMM.has_liquidity(user)
1203     ns: int256[2] = AMM.read_user_tick_numbers(user) # ns[1] > ns[0]
1204     return [AMM.p_oracle_up(ns[0]), AMM.p_oracle_down(ns[1])]
1205 
1206 
1207 @view
1208 @external
1209 @nonreentrant('lock')
1210 def user_state(user: address) -> uint256[4]:
1211     """
1212     @notice Return the user state in one call
1213     @param user User to return the state for
1214     @return (collateral, stablecoin, debt, N)
1215     """
1216     xy: uint256[2] = AMM.get_sum_xy(user)
1217     ns: int256[2] = AMM.read_user_tick_numbers(user) # ns[1] > ns[0]
1218     return [xy[1], xy[0], self._debt_ro(user), convert(unsafe_add(unsafe_sub(ns[1], ns[0]), 1), uint256)]
1219 
1220 
1221 # AMM has nonreentrant decorator
1222 @external
1223 def set_amm_fee(fee: uint256):
1224     """
1225     @notice Set the AMM fee (factory admin only)
1226     @param fee The fee which should be no higher than MAX_FEE
1227     """
1228     assert msg.sender == FACTORY.admin()
1229     assert fee <= MAX_FEE and fee >= MIN_FEE, "Fee"
1230     AMM.set_fee(fee)
1231 
1232 
1233 # AMM has nonreentrant decorator
1234 @external
1235 def set_amm_admin_fee(fee: uint256):
1236     """
1237     @notice Set AMM's admin fee
1238     @param fee New admin fee (not higher than MAX_ADMIN_FEE)
1239     """
1240     assert msg.sender == FACTORY.admin()
1241     assert fee <= MAX_ADMIN_FEE, "High fee"
1242     AMM.set_admin_fee(fee)
1243 
1244 
1245 @nonreentrant('lock')
1246 @external
1247 def set_monetary_policy(monetary_policy: address):
1248     """
1249     @notice Set monetary policy contract
1250     @param monetary_policy Address of the monetary policy contract
1251     """
1252     assert msg.sender == FACTORY.admin()
1253     self.monetary_policy = MonetaryPolicy(monetary_policy)
1254     MonetaryPolicy(monetary_policy).rate_write()
1255     log SetMonetaryPolicy(monetary_policy)
1256 
1257 
1258 @nonreentrant('lock')
1259 @external
1260 def set_borrowing_discounts(loan_discount: uint256, liquidation_discount: uint256):
1261     """
1262     @notice Set discounts at which we can borrow (defines max LTV) and where bad liquidation starts
1263     @param loan_discount Discount which defines LTV
1264     @param liquidation_discount Discount where bad liquidation starts
1265     """
1266     assert msg.sender == FACTORY.admin()
1267     assert loan_discount > liquidation_discount
1268     assert liquidation_discount >= MIN_LIQUIDATION_DISCOUNT
1269     assert loan_discount <= MAX_LOAN_DISCOUNT
1270     self.liquidation_discount = liquidation_discount
1271     self.loan_discount = loan_discount
1272     log SetBorrowingDiscounts(loan_discount, liquidation_discount)
1273 
1274 
1275 @external
1276 @nonreentrant('lock')
1277 def set_callback(cb: address):
1278     """
1279     @notice Set liquidity mining callback
1280     """
1281     assert msg.sender == FACTORY.admin()
1282     AMM.set_callback(cb)
1283 
1284 
1285 @external
1286 @view
1287 def admin_fees() -> uint256:
1288     """
1289     @notice Calculate the amount of fees obtained from the interest
1290     """
1291     rate_mul: uint256 = AMM.get_rate_mul()
1292     loan: Loan = self._total_debt
1293     loan.initial_debt = loan.initial_debt * rate_mul / loan.rate_mul
1294     loan.initial_debt += self.redeemed
1295     minted: uint256 = self.minted
1296     return unsafe_sub(max(loan.initial_debt, minted), minted)
1297 
1298 
1299 @external
1300 @nonreentrant('lock')
1301 def collect_fees() -> uint256:
1302     """
1303     @notice Collect the fees charged as interest
1304     """
1305     _to: address = FACTORY.fee_receiver()
1306     # AMM-based fees
1307     borrowed_fees: uint256 = AMM.admin_fees_x()
1308     collateral_fees: uint256 = AMM.admin_fees_y()
1309     if borrowed_fees > 0:
1310         STABLECOIN.transferFrom(AMM.address, _to, borrowed_fees)
1311     if collateral_fees > 0:
1312         assert COLLATERAL_TOKEN.transferFrom(AMM.address, _to, collateral_fees, default_return_value=True)
1313     AMM.reset_admin_fees()
1314 
1315     # Borrowing-based fees
1316     rate_mul: uint256 = self._rate_mul_w()
1317     loan: Loan = self._total_debt
1318     loan.initial_debt = loan.initial_debt * rate_mul / loan.rate_mul
1319     loan.rate_mul = rate_mul
1320     self._total_debt = loan
1321 
1322     # Amount which would have been redeemed if all the debt was repaid now
1323     to_be_redeemed: uint256 = loan.initial_debt + self.redeemed
1324     # Amount which was minted when borrowing + all previously claimed admin fees
1325     minted: uint256 = self.minted
1326     # Difference between to_be_redeemed and minted amount is exactly due to interest charged
1327     if to_be_redeemed > minted:
1328         self.minted = to_be_redeemed
1329         to_be_redeemed = unsafe_sub(to_be_redeemed, minted)  # Now this is the fees to charge
1330         STABLECOIN.transfer(_to, to_be_redeemed)
1331         log CollectFees(to_be_redeemed, loan.initial_debt)
1332         return to_be_redeemed
1333     else:
1334         log CollectFees(0, loan.initial_debt)
1335         return 0