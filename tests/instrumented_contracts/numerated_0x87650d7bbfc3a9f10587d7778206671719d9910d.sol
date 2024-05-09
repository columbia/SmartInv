1 # @version 0.2.8
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2021 - all rights reserved
6 @notice 3pool metapool implementation contract
7 """
8 
9 interface ERC20:
10     def transfer(_receiver: address, _amount: uint256): nonpayable
11     def transferFrom(_sender: address, _receiver: address, _amount: uint256): nonpayable
12     def approve(_spender: address, _amount: uint256): nonpayable
13     def balanceOf(_owner: address) -> uint256: view
14 
15 interface Curve:
16     def coins(i: uint256) -> address: view
17     def get_virtual_price() -> uint256: view
18     def calc_token_amount(amounts: uint256[BASE_N_COINS], deposit: bool) -> uint256: view
19     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
20     def fee() -> uint256: view
21     def get_dy(i: int128, j: int128, dx: uint256) -> uint256: view
22     def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
23     def add_liquidity(amounts: uint256[BASE_N_COINS], min_mint_amount: uint256): nonpayable
24     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256): nonpayable
25 
26 interface Factory:
27     def convert_fees() -> bool: nonpayable
28     def fee_receiver(_base_pool: address) -> address: view
29 
30 
31 event Transfer:
32     sender: indexed(address)
33     receiver: indexed(address)
34     value: uint256
35 
36 event Approval:
37     owner: indexed(address)
38     spender: indexed(address)
39     value: uint256
40 
41 event TokenExchange:
42     buyer: indexed(address)
43     sold_id: int128
44     tokens_sold: uint256
45     bought_id: int128
46     tokens_bought: uint256
47 
48 event TokenExchangeUnderlying:
49     buyer: indexed(address)
50     sold_id: int128
51     tokens_sold: uint256
52     bought_id: int128
53     tokens_bought: uint256
54 
55 event AddLiquidity:
56     provider: indexed(address)
57     token_amounts: uint256[N_COINS]
58     fees: uint256[N_COINS]
59     invariant: uint256
60     token_supply: uint256
61 
62 event RemoveLiquidity:
63     provider: indexed(address)
64     token_amounts: uint256[N_COINS]
65     fees: uint256[N_COINS]
66     token_supply: uint256
67 
68 event RemoveLiquidityOne:
69     provider: indexed(address)
70     token_amount: uint256
71     coin_amount: uint256
72     token_supply: uint256
73 
74 event RemoveLiquidityImbalance:
75     provider: indexed(address)
76     token_amounts: uint256[N_COINS]
77     fees: uint256[N_COINS]
78     invariant: uint256
79     token_supply: uint256
80 
81 event CommitNewAdmin:
82     deadline: indexed(uint256)
83     admin: indexed(address)
84 
85 event NewAdmin:
86     admin: indexed(address)
87 
88 event CommitNewFee:
89     deadline: indexed(uint256)
90     fee: uint256
91     admin_fee: uint256
92 
93 event NewFee:
94     fee: uint256
95     admin_fee: uint256
96 
97 event RampA:
98     old_A: uint256
99     new_A: uint256
100     initial_time: uint256
101     future_time: uint256
102 
103 event StopRampA:
104     A: uint256
105     t: uint256
106 
107 
108 BASE_POOL: constant(address) = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7
109 BASE_COINS: constant(address[3]) = [
110     0x6B175474E89094C44Da98b954EedeAC495271d0F,  # DAI
111     0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,  # USDC
112     0xdAC17F958D2ee523a2206206994597C13D831ec7,  # USDT
113 ]
114 
115 N_COINS: constant(int128) = 2
116 MAX_COIN: constant(int128) = N_COINS - 1
117 BASE_N_COINS: constant(int128) = 3
118 PRECISION: constant(uint256) = 10 ** 18
119 
120 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
121 ADMIN_FEE: constant(uint256) = 5000000000
122 
123 A_PRECISION: constant(uint256) = 100
124 MAX_A: constant(uint256) = 10 ** 6
125 MAX_A_CHANGE: constant(uint256) = 10
126 MIN_RAMP_TIME: constant(uint256) = 86400
127 
128 admin: public(address)
129 factory: address
130 
131 coins: public(address[N_COINS])
132 balances: public(uint256[N_COINS])
133 fee: public(uint256)  # fee * 1e10
134 
135 previous_balances: uint256[N_COINS]
136 price_cumulative_last: uint256[N_COINS]
137 block_timestamp_last: public(uint256)
138 
139 initial_A: public(uint256)
140 future_A: public(uint256)
141 initial_A_time: public(uint256)
142 future_A_time: public(uint256)
143 
144 rate_multiplier: uint256
145 
146 name: public(String[64])
147 symbol: public(String[32])
148 
149 balanceOf: public(HashMap[address, uint256])
150 allowance: public(HashMap[address, HashMap[address, uint256]])
151 totalSupply: public(uint256)
152 
153 
154 @external
155 def __init__():
156     # we do this to prevent the implementation contract from being used as a pool
157     self.fee = 31337
158 
159 
160 @external
161 def initialize(
162     _name: String[32],
163     _symbol: String[10],
164     _coin: address,
165     _decimals: uint256,
166     _A: uint256,
167     _fee: uint256,
168     _admin: address,
169 ):
170     """
171     @notice Contract initializer
172     @param _name Name of the new pool
173     @param _symbol Token symbol
174     @param _coin Addresses of ERC20 conracts of coins
175     @param _decimals Number of decimals in `_coin`
176     @param _A Amplification coefficient multiplied by n * (n - 1)
177     @param _fee Fee to charge for exchanges
178     @param _admin Admin address
179     """
180     #  # things break if a token has >18 decimals
181     assert _decimals < 19
182     # fee must be between 0.04% and 1%
183     assert _fee >= 4000000
184     assert _fee <= 100000000
185     # check if fee was already set to prevent initializing contract twice
186     assert self.fee == 0
187 
188     A: uint256 = _A * A_PRECISION
189     self.coins = [_coin, 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490]
190     self.rate_multiplier = 10 ** (36 - _decimals)
191     self.initial_A = A
192     self.future_A = A
193     self.fee = _fee
194     self.admin = _admin
195     self.factory = msg.sender
196 
197     self.name = concat("Curve.fi Factory USD Metapool: ", _name)
198     self.symbol = concat(_symbol, "3CRV-f")
199 
200     for coin in BASE_COINS:
201         ERC20(coin).approve(BASE_POOL, MAX_UINT256)
202 
203     # fire a transfer event so block explorers identify the contract as an ERC20
204     log Transfer(ZERO_ADDRESS, self, 0)
205 
206 
207 ### ERC20 Functionality ###
208 
209 @view
210 @external
211 def decimals() -> uint256:
212     """
213     @notice Get the number of decimals for this token
214     @dev Implemented as a view method to reduce gas costs
215     @return uint256 decimal places
216     """
217     return 18
218 
219 
220 @internal
221 def _transfer(_from: address, _to: address, _value: uint256):
222     # NOTE: vyper does not allow underflows
223     #       so the following subtraction would revert on insufficient balance
224     self.balanceOf[_from] -= _value
225     self.balanceOf[_to] += _value
226 
227     log Transfer(_from, _to, _value)
228 
229 
230 @external
231 def transfer(_to : address, _value : uint256) -> bool:
232     """
233     @dev Transfer token for a specified address
234     @param _to The address to transfer to.
235     @param _value The amount to be transferred.
236     """
237     self._transfer(msg.sender, _to, _value)
238     return True
239 
240 
241 @external
242 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
243     """
244      @dev Transfer tokens from one address to another.
245      @param _from address The address which you want to send tokens from
246      @param _to address The address which you want to transfer to
247      @param _value uint256 the amount of tokens to be transferred
248     """
249     self._transfer(_from, _to, _value)
250 
251     _allowance: uint256 = self.allowance[_from][msg.sender]
252     if _allowance != MAX_UINT256:
253         self.allowance[_from][msg.sender] = _allowance - _value
254 
255     return True
256 
257 
258 @external
259 def approve(_spender : address, _value : uint256) -> bool:
260     """
261     @notice Approve the passed address to transfer the specified amount of
262             tokens on behalf of msg.sender
263     @dev Beware that changing an allowance via this method brings the risk that
264          someone may use both the old and new allowance by unfortunate transaction
265          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266     @param _spender The address which will transfer the funds
267     @param _value The amount of tokens that may be transferred
268     @return bool success
269     """
270     self.allowance[msg.sender][_spender] = _value
271 
272     log Approval(msg.sender, _spender, _value)
273     return True
274 
275 
276 ### StableSwap Functionality ###
277 
278 @view
279 @external
280 def get_previous_balances() -> uint256[N_COINS]:
281     return self.previous_balances
282 
283 @view
284 @external
285 def get_balances() -> uint256[N_COINS]:
286     return self.balances
287 
288 @view
289 @external
290 def get_twap_balances(_first_balances: uint256[N_COINS], _last_balances: uint256[N_COINS], _time_elapsed: uint256) -> uint256[N_COINS]:
291     balances: uint256[N_COINS] = empty(uint256[N_COINS])
292     for x in range(N_COINS):
293         balances[x] = (_last_balances[x] - _first_balances[x]) / _time_elapsed
294     return balances
295 
296 
297 @view
298 @external
299 def get_price_cumulative_last() -> uint256[N_COINS]:
300     return self.price_cumulative_last
301 
302 
303 @view
304 @internal
305 def _A() -> uint256:
306     """
307     Handle ramping A up or down
308     """
309     t1: uint256 = self.future_A_time
310     A1: uint256 = self.future_A
311 
312     if block.timestamp < t1:
313         A0: uint256 = self.initial_A
314         t0: uint256 = self.initial_A_time
315         # Expressions in uint256 cannot have negative numbers, thus "if"
316         if A1 > A0:
317             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
318         else:
319             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
320 
321     else:  # when t1 == 0 or block.timestamp >= t1
322         return A1
323 
324 
325 @internal
326 def _update():
327     """
328     Commits pre-change balances for the previous block
329     Can be used to compare against current values for flash loan checks
330     """
331     elapsed_time: uint256 = block.timestamp - self.block_timestamp_last
332     if elapsed_time > 0:
333         for i in range(N_COINS):
334             _balance: uint256 = self.balances[i]
335             self.price_cumulative_last[i] += _balance * elapsed_time
336             self.previous_balances[i] = _balance
337         self.block_timestamp_last = block.timestamp
338 
339 
340 @view
341 @external
342 def admin_fee() -> uint256:
343     return ADMIN_FEE
344 
345 
346 @view
347 @external
348 def A() -> uint256:
349     return self._A() / A_PRECISION
350 
351 
352 @view
353 @external
354 def A_precise() -> uint256:
355     return self._A()
356 
357 
358 @pure
359 @internal
360 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
361     result: uint256[N_COINS] = empty(uint256[N_COINS])
362     for i in range(N_COINS):
363         result[i] = _rates[i] * _balances[i] / PRECISION
364     return result
365 
366 
367 @pure
368 @internal
369 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
370     S: uint256 = 0
371     Dprev: uint256 = 0
372     for x in _xp:
373         S += x
374     if S == 0:
375         return 0
376 
377     D: uint256 = S
378     Ann: uint256 = _amp * N_COINS
379     for i in range(255):
380         D_P: uint256 = D
381         for x in _xp:
382             D_P = D_P * D / (x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
383         Dprev = D
384         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
385         # Equality with the precision of 1
386         if D > Dprev:
387             if D - Dprev <= 1:
388                 return D
389         else:
390             if Dprev - D <= 1:
391                 return D
392     # convergence typically occurs in 4 rounds or less, this should be unreachable!
393     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
394     raise
395 
396 
397 @view
398 @internal
399 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
400     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
401     return self.get_D(xp, _amp)
402 
403 
404 @view
405 @external
406 def get_virtual_price() -> uint256:
407     """
408     @notice The current virtual price of the pool LP token
409     @dev Useful for calculating profits
410     @return LP token virtual price normalized to 1e18
411     """
412     amp: uint256 = self._A()
413     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
414     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
415     D: uint256 = self.get_D(xp, amp)
416     # D is in the units similar to DAI (e.g. converted to precision 1e18)
417     # When balanced, D = n * x_u - total virtual value of the portfolio
418     return D * PRECISION / self.totalSupply
419 
420 
421 @view
422 @external
423 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool, _previous: bool = False) -> uint256:
424     """
425     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
426     @dev This calculation accounts for slippage, but not fees.
427          Needed to prevent front-running, not for precise calculations!
428     @param _amounts Amount of each coin being deposited
429     @param _is_deposit set True for deposits, False for withdrawals
430     @param _previous use previous_balances or self.balances
431     @return Expected amount of LP tokens received
432     """
433     amp: uint256 = self._A()
434     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
435     balances: uint256[N_COINS] = self.balances
436     if _previous:
437         balances = self.previous_balances
438 
439     D0: uint256 = self.get_D_mem(rates, balances, amp)
440     for i in range(N_COINS):
441         amount: uint256 = _amounts[i]
442         if _is_deposit:
443             balances[i] += amount
444         else:
445             balances[i] -= amount
446     D1: uint256 = self.get_D_mem(rates, balances, amp)
447     diff: uint256 = 0
448     if _is_deposit:
449         diff = D1 - D0
450     else:
451         diff = D0 - D1
452     return diff * self.totalSupply / D0
453 
454 
455 @external
456 @nonreentrant('lock')
457 def add_liquidity(
458     _amounts: uint256[N_COINS],
459     _min_mint_amount: uint256,
460     _receiver: address = msg.sender
461 ) -> uint256:
462     """
463     @notice Deposit coins into the pool
464     @param _amounts List of amounts of coins to deposit
465     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
466     @param _receiver Address that owns the minted LP tokens
467     @return Amount of LP tokens received by depositing
468     """
469     self._update()
470     amp: uint256 = self._A()
471     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
472 
473     # Initial invariant
474     old_balances: uint256[N_COINS] = self.balances
475     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
476     new_balances: uint256[N_COINS] = old_balances
477 
478     total_supply: uint256 = self.totalSupply
479     for i in range(N_COINS):
480         amount: uint256 = _amounts[i]
481         if total_supply == 0:
482             assert amount > 0  # dev: initial deposit requires all coins
483         new_balances[i] += amount
484 
485     # Invariant after change
486     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
487     assert D1 > D0
488 
489     # We need to recalculate the invariant accounting for fees
490     # to calculate fair user's share
491     fees: uint256[N_COINS] = empty(uint256[N_COINS])
492     mint_amount: uint256 = 0
493     if total_supply > 0:
494         # Only account for fees if we are not the first to deposit
495         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
496         for i in range(N_COINS):
497             ideal_balance: uint256 = D1 * old_balances[i] / D0
498             difference: uint256 = 0
499             new_balance: uint256 = new_balances[i]
500             if ideal_balance > new_balance:
501                 difference = ideal_balance - new_balance
502             else:
503                 difference = new_balance - ideal_balance
504             fees[i] = base_fee * difference / FEE_DENOMINATOR
505             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
506             new_balances[i] -= fees[i]
507         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
508         mint_amount = total_supply * (D2 - D0) / D0
509     else:
510         self.balances = new_balances
511         mint_amount = D1  # Take the dust if there was any
512 
513     assert mint_amount >= _min_mint_amount
514 
515     # Take coins from the sender
516     for i in range(N_COINS):
517         amount: uint256 = _amounts[i]
518         if amount > 0:
519             ERC20(self.coins[i]).transferFrom(msg.sender, self, amount)  # dev: failed transfer
520 
521     # Mint pool tokens
522     total_supply += mint_amount
523     self.balanceOf[_receiver] += mint_amount
524     self.totalSupply = total_supply
525     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
526 
527     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
528 
529     return mint_amount
530 
531 
532 @view
533 @internal
534 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
535     # x in the input is converted to the same price/precision
536 
537     assert i != j       # dev: same coin
538     assert j >= 0       # dev: j below zero
539     assert j < N_COINS  # dev: j above N_COINS
540 
541     # should be unreachable, but good for safety
542     assert i >= 0
543     assert i < N_COINS
544 
545     amp: uint256 = self._A()
546     D: uint256 = self.get_D(xp, amp)
547     S_: uint256 = 0
548     _x: uint256 = 0
549     y_prev: uint256 = 0
550     c: uint256 = D
551     Ann: uint256 = amp * N_COINS
552 
553     for _i in range(N_COINS):
554         if _i == i:
555             _x = x
556         elif _i != j:
557             _x = xp[_i]
558         else:
559             continue
560         S_ += _x
561         c = c * D / (_x * N_COINS)
562 
563     c = c * D * A_PRECISION / (Ann * N_COINS)
564     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
565     y: uint256 = D
566 
567     for _i in range(255):
568         y_prev = y
569         y = (y*y + c) / (2 * y + b - D)
570         # Equality with the precision of 1
571         if y > y_prev:
572             if y - y_prev <= 1:
573                 return y
574         else:
575             if y_prev - y <= 1:
576                 return y
577     raise
578 
579 
580 @view
581 @external
582 def get_dy(i: int128, j: int128, dx: uint256, _balances: uint256[N_COINS] = [0,0]) -> uint256:
583     """
584     @notice Calculate the current output dy given input dx
585     @dev Index values can be found via the `coins` public getter method
586     @param i Index value for the coin to send
587     @param j Index valie of the coin to recieve
588     @param dx Amount of `i` being exchanged
589     @param _balances which balance to use, current, previous, or twap
590     @return Amount of `j` predicted
591     """
592     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
593     xp: uint256[N_COINS] = _balances
594     if _balances[0] == 0:
595         xp = self.balances
596     xp = self._xp_mem(rates, xp)
597 
598     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
599     y: uint256 = self.get_y(i, j, x, xp)
600     dy: uint256 = xp[j] - y - 1
601     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
602     return (dy - fee) * PRECISION / rates[j]
603 
604 
605 @view
606 @external
607 def get_dy_underlying(i: int128, j: int128, dx: uint256, _balances: uint256[N_COINS] = [0,0]) -> uint256:
608     """
609     @notice Calculate the current output dy given input dx on underlying
610     @dev Index values can be found via the `coins` public getter method
611     @param i Index value for the coin to send
612     @param j Index valie of the coin to recieve
613     @param dx Amount of `i` being exchanged
614     @param _balances which balance to use, current, previous, or twap
615     @return Amount of `j` predicted
616     """
617     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
618     xp: uint256[N_COINS] = _balances
619     if _balances[0] == 0:
620         xp = self.balances
621     xp = self._xp_mem(rates, xp)
622     base_pool: address = BASE_POOL
623 
624     x: uint256 = 0
625     base_i: int128 = 0
626     base_j: int128 = 0
627     meta_i: int128 = 0
628     meta_j: int128 = 0
629 
630     if i != 0:
631         base_i = i - MAX_COIN
632         meta_i = 1
633     if j != 0:
634         base_j = j - MAX_COIN
635         meta_j = 1
636 
637     if i == 0:
638         x = xp[i] + dx * (rates[0] / 10**18)
639     else:
640         if j == 0:
641             # i is from BasePool
642             # At first, get the amount of pool tokens
643             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
644             base_inputs[base_i] = dx
645             # Token amount transformed to underlying "dollars"
646             x = Curve(base_pool).calc_token_amount(base_inputs, True) * rates[1] / PRECISION
647             # Accounting for deposit/withdraw fees approximately
648             x -= x * Curve(base_pool).fee() / (2 * FEE_DENOMINATOR)
649             # Adding number of pool tokens
650             x += xp[MAX_COIN]
651         else:
652             # If both are from the base pool
653             return Curve(base_pool).get_dy(base_i, base_j, dx)
654 
655     # This pool is involved only when in-pool assets are used
656     y: uint256 = self.get_y(meta_i, meta_j, x, xp)
657     dy: uint256 = xp[meta_j] - y - 1
658     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
659 
660     # If output is going via the metapool
661     if j == 0:
662         dy /= (rates[0] / 10**18)
663     else:
664         # j is from BasePool
665         # The fee is already accounted for
666         dy = Curve(base_pool).calc_withdraw_one_coin(dy * PRECISION / rates[1], base_j)
667 
668     return dy
669 
670 
671 @external
672 @nonreentrant('lock')
673 def exchange(
674     i: int128,
675     j: int128,
676     dx: uint256,
677     min_dy: uint256,
678     _receiver: address = msg.sender,
679 ) -> uint256:
680     """
681     @notice Perform an exchange between two coins
682     @dev Index values can be found via the `coins` public getter method
683     @param i Index value for the coin to send
684     @param j Index valie of the coin to recieve
685     @param dx Amount of `i` being exchanged
686     @param min_dy Minimum amount of `j` to receive
687     @param _receiver Address that receives `j`
688     @return Actual amount of `j` received
689     """
690     self._update()
691     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
692 
693     old_balances: uint256[N_COINS] = self.balances
694     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
695 
696     x: uint256 = xp[i] + dx * rates[i] / PRECISION
697     y: uint256 = self.get_y(i, j, x, xp)
698 
699     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
700     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
701 
702     # Convert all to real units
703     dy = (dy - dy_fee) * PRECISION / rates[j]
704     assert dy >= min_dy
705 
706     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
707     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
708 
709     # Change balances exactly in same way as we change actual ERC20 coin amounts
710     self.balances[i] = old_balances[i] + dx
711     # When rounding errors happen, we undercharge admin fee in favor of LP
712     self.balances[j] = old_balances[j] - dy - dy_admin_fee
713 
714     ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)
715     ERC20(self.coins[j]).transfer(_receiver, dy)
716 
717     log TokenExchange(msg.sender, i, dx, j, dy)
718 
719     return dy
720 
721 
722 @external
723 @nonreentrant('lock')
724 def exchange_underlying(
725     i: int128,
726     j: int128,
727     dx: uint256,
728     min_dy: uint256,
729     _receiver: address = msg.sender,
730 ) -> uint256:
731     """
732     @notice Perform an exchange between two underlying coins
733     @dev Index values can be found via the `underlying_coins` public getter method
734     @param i Index value for the underlying coin to send
735     @param j Index valie of the underlying coin to recieve
736     @param dx Amount of `i` being exchanged
737     @param min_dy Minimum amount of `j` to receive
738     @param _receiver Address that receives `j`
739     @return Actual amount of `j` received
740     """
741     self._update()
742     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
743     old_balances: uint256[N_COINS] = self.balances
744     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
745 
746     base_pool: address = BASE_POOL
747     base_coins: address[3] = BASE_COINS
748 
749     dy: uint256 = 0
750     base_i: int128 = 0
751     base_j: int128 = 0
752     meta_i: int128 = 0
753     meta_j: int128 = 0
754     x: uint256 = 0
755     input_coin: address = ZERO_ADDRESS
756     output_coin: address = ZERO_ADDRESS
757 
758     if i == 0:
759         input_coin = self.coins[0]
760     else:
761         base_i = i - MAX_COIN
762         meta_i = 1
763         input_coin = base_coins[base_i]
764     if j == 0:
765         output_coin = self.coins[0]
766     else:
767         base_j = j - MAX_COIN
768         meta_j = 1
769         output_coin = base_coins[base_j]
770 
771     # Handle potential Tether fees
772     dx_w_fee: uint256 = dx
773     if j == 3:
774         dx_w_fee = ERC20(input_coin).balanceOf(self)
775 
776     ERC20(input_coin).transferFrom(msg.sender, self, dx)
777 
778     # Handle potential Tether fees
779     if j == 3:
780         dx_w_fee = ERC20(input_coin).balanceOf(self) - dx_w_fee
781 
782     if i == 0 or j == 0:
783         if i == 0:
784             x = xp[i] + dx_w_fee * rates[i] / PRECISION
785         else:
786             # i is from BasePool
787             # At first, get the amount of pool tokens
788             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
789             base_inputs[base_i] = dx_w_fee
790             coin_i: address = self.coins[MAX_COIN]
791             # Deposit and measure delta
792             x = ERC20(coin_i).balanceOf(self)
793             Curve(base_pool).add_liquidity(base_inputs, 0)
794             # Need to convert pool token to "virtual" units using rates
795             # dx is also different now
796             dx_w_fee = ERC20(coin_i).balanceOf(self) - x
797             x = dx_w_fee * rates[MAX_COIN] / PRECISION
798             # Adding number of pool tokens
799             x += xp[MAX_COIN]
800 
801         y: uint256 = self.get_y(meta_i, meta_j, x, xp)
802 
803         # Either a real coin or token
804         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
805         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
806 
807         # Convert all to real units
808         # Works for both pool coins and real coins
809         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
810 
811         dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
812         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
813 
814         # Change balances exactly in same way as we change actual ERC20 coin amounts
815         self.balances[meta_i] = old_balances[meta_i] + dx_w_fee
816         # When rounding errors happen, we undercharge admin fee in favor of LP
817         self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee
818 
819         # Withdraw from the base pool if needed
820         if j > 0:
821             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
822             Curve(base_pool).remove_liquidity_one_coin(dy, base_j, 0)
823             dy = ERC20(output_coin).balanceOf(self) - out_amount
824 
825         assert dy >= min_dy
826 
827     else:
828         # If both are from the base pool
829         dy = ERC20(output_coin).balanceOf(self)
830         Curve(base_pool).exchange(base_i, base_j, dx_w_fee, min_dy)
831         dy = ERC20(output_coin).balanceOf(self) - dy
832 
833     ERC20(output_coin).transfer(_receiver, dy)
834 
835     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
836 
837     return dy
838 
839 
840 @external
841 @nonreentrant('lock')
842 def remove_liquidity(
843     _burn_amount: uint256,
844     _min_amounts: uint256[N_COINS],
845     _receiver: address = msg.sender
846 ) -> uint256[N_COINS]:
847     """
848     @notice Withdraw coins from the pool
849     @dev Withdrawal amounts are based on current deposit ratios
850     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
851     @param _min_amounts Minimum amounts of underlying coins to receive
852     @param _receiver Address that receives the withdrawn coins
853     @return List of amounts of coins that were withdrawn
854     """
855     self._update()
856     total_supply: uint256 = self.totalSupply
857     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
858 
859     for i in range(N_COINS):
860         old_balance: uint256 = self.balances[i]
861         value: uint256 = old_balance * _burn_amount / total_supply
862         assert value >= _min_amounts[i]
863         self.balances[i] = old_balance - value
864         amounts[i] = value
865         ERC20(self.coins[i]).transfer(_receiver, value)
866 
867     total_supply -= _burn_amount
868     self.balanceOf[msg.sender] -= _burn_amount
869     self.totalSupply = total_supply
870     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
871 
872     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
873 
874     return amounts
875 
876 
877 @external
878 @nonreentrant('lock')
879 def remove_liquidity_imbalance(
880     _amounts: uint256[N_COINS],
881     _max_burn_amount: uint256,
882     _receiver: address = msg.sender
883 ) -> uint256:
884     """
885     @notice Withdraw coins from the pool in an imbalanced amount
886     @param _amounts List of amounts of underlying coins to withdraw
887     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
888     @param _receiver Address that receives the withdrawn coins
889     @return Actual amount of the LP token burned in the withdrawal
890     """
891     self._update()
892 
893     amp: uint256 = self._A()
894     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
895     old_balances: uint256[N_COINS] = self.balances
896     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
897 
898     new_balances: uint256[N_COINS] = old_balances
899     for i in range(N_COINS):
900         new_balances[i] -= _amounts[i]
901     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
902 
903     fees: uint256[N_COINS] = empty(uint256[N_COINS])
904     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
905     for i in range(N_COINS):
906         ideal_balance: uint256 = D1 * old_balances[i] / D0
907         difference: uint256 = 0
908         new_balance: uint256 = new_balances[i]
909         if ideal_balance > new_balance:
910             difference = ideal_balance - new_balance
911         else:
912             difference = new_balance - ideal_balance
913         fees[i] = base_fee * difference / FEE_DENOMINATOR
914         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
915         new_balances[i] -= fees[i]
916     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
917 
918     total_supply: uint256 = self.totalSupply
919     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
920     assert burn_amount > 1  # dev: zero tokens burned
921     assert burn_amount <= _max_burn_amount
922 
923     total_supply -= burn_amount
924     self.totalSupply = total_supply
925     self.balanceOf[msg.sender] -= burn_amount
926     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
927 
928     for i in range(N_COINS):
929         amount: uint256 = _amounts[i]
930         if amount != 0:
931             ERC20(self.coins[i]).transfer(_receiver, amount)
932 
933     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
934 
935     return burn_amount
936 
937 
938 @view
939 @internal
940 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
941     """
942     Calculate x[i] if one reduces D from being calculated for xp to D
943 
944     Done by solving quadratic equation iteratively.
945     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
946     x_1**2 + b*x_1 = c
947 
948     x_1 = (x_1**2 + c) / (2*x_1 + b)
949     """
950     # x in the input is converted to the same price/precision
951 
952     assert i >= 0  # dev: i below zero
953     assert i < N_COINS  # dev: i above N_COINS
954 
955     S_: uint256 = 0
956     _x: uint256 = 0
957     y_prev: uint256 = 0
958     c: uint256 = D
959     Ann: uint256 = A * N_COINS
960 
961     for _i in range(N_COINS):
962         if _i != i:
963             _x = xp[_i]
964         else:
965             continue
966         S_ += _x
967         c = c * D / (_x * N_COINS)
968 
969     c = c * D * A_PRECISION / (Ann * N_COINS)
970     b: uint256 = S_ + D * A_PRECISION / Ann
971     y: uint256 = D
972 
973     for _i in range(255):
974         y_prev = y
975         y = (y*y + c) / (2 * y + b - D)
976         # Equality with the precision of 1
977         if y > y_prev:
978             if y - y_prev <= 1:
979                 return y
980         else:
981             if y_prev - y <= 1:
982                 return y
983     raise
984 
985 
986 @view
987 @internal
988 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128, _balances: uint256[N_COINS]) -> (uint256, uint256):
989     # First, need to calculate
990     # * Get current D
991     # * Solve Eqn against y_i for D - _token_amount
992     amp: uint256 = self._A()
993     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
994     xp: uint256[N_COINS] = self._xp_mem(rates, _balances)
995     D0: uint256 = self.get_D(xp, amp)
996 
997     total_supply: uint256 = self.totalSupply
998     D1: uint256 = D0 - _burn_amount * D0 / total_supply
999     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
1000 
1001     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
1002     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
1003 
1004     for j in range(N_COINS):
1005         dx_expected: uint256 = 0
1006         xp_j: uint256 = xp[j]
1007         if j == i:
1008             dx_expected = xp_j * D1 / D0 - new_y
1009         else:
1010             dx_expected = xp_j - xp_j * D1 / D0
1011         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
1012 
1013     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
1014     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
1015     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
1016 
1017     return dy, dy_0 - dy
1018 
1019 
1020 @view
1021 @external
1022 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128, _previous: bool = False) -> uint256:
1023     """
1024     @notice Calculate the amount received when withdrawing a single coin
1025     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1026     @param i Index value of the coin to withdraw
1027     @param _previous indicate to use previous_balances or current balances
1028     @return Amount of coin received
1029     """
1030     balances: uint256[N_COINS] = self.balances
1031     if _previous:
1032         balances = self.previous_balances
1033     return self._calc_withdraw_one_coin(_burn_amount, i, balances)[0]
1034 
1035 
1036 @external
1037 @nonreentrant('lock')
1038 def remove_liquidity_one_coin(
1039     _burn_amount: uint256,
1040     i: int128,
1041     _min_received: uint256,
1042     _receiver: address = msg.sender,
1043 ) -> uint256:
1044     """
1045     @notice Withdraw a single coin from the pool
1046     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1047     @param i Index value of the coin to withdraw
1048     @param _min_received Minimum amount of coin to receive
1049     @param _receiver Address that receives the withdrawn coins
1050     @return Amount of coin received
1051     """
1052     self._update()
1053 
1054     dy: uint256 = 0
1055     dy_fee: uint256 = 0
1056     dy, dy_fee = self._calc_withdraw_one_coin(_burn_amount, i, self.balances)
1057     assert dy >= _min_received
1058 
1059     self.balances[i] -= (dy + dy_fee * ADMIN_FEE / FEE_DENOMINATOR)
1060     total_supply: uint256 = self.totalSupply - _burn_amount
1061     self.totalSupply = total_supply
1062     self.balanceOf[msg.sender] -= _burn_amount
1063     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
1064 
1065     ERC20(self.coins[i]).transfer(_receiver, dy)
1066 
1067     log RemoveLiquidityOne(msg.sender, _burn_amount, dy, total_supply)
1068 
1069     return dy
1070 
1071 
1072 @external
1073 def ramp_A(_future_A: uint256, _future_time: uint256):
1074     assert msg.sender == self.admin  # dev: only owner
1075     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
1076     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
1077 
1078     _initial_A: uint256 = self._A()
1079     _future_A_p: uint256 = _future_A * A_PRECISION
1080 
1081     assert _future_A > 0 and _future_A < MAX_A
1082     if _future_A_p < _initial_A:
1083         assert _future_A_p * MAX_A_CHANGE >= _initial_A
1084     else:
1085         assert _future_A_p <= _initial_A * MAX_A_CHANGE
1086 
1087     self.initial_A = _initial_A
1088     self.future_A = _future_A_p
1089     self.initial_A_time = block.timestamp
1090     self.future_A_time = _future_time
1091 
1092     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
1093 
1094 
1095 @external
1096 def stop_ramp_A():
1097     assert msg.sender == self.admin  # dev: only owner
1098 
1099     current_A: uint256 = self._A()
1100     self.initial_A = current_A
1101     self.future_A = current_A
1102     self.initial_A_time = block.timestamp
1103     self.future_A_time = block.timestamp
1104     # now (block.timestamp < t1) is always False, so we return saved A
1105 
1106     log StopRampA(current_A, block.timestamp)
1107 
1108 
1109 @view
1110 @external
1111 def admin_balances(i: uint256) -> uint256:
1112     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1113 
1114 
1115 @external
1116 def withdraw_admin_fees():
1117     factory: address = self.factory
1118 
1119     # transfer coin 0 to Factory and call `convert_fees` to swap it for coin 1
1120     coin: address = self.coins[0]
1121     amount: uint256 = ERC20(coin).balanceOf(self) - self.balances[0]
1122     if amount > 0:
1123         ERC20(coin).transfer(factory, amount)
1124         Factory(factory).convert_fees()
1125 
1126     # transfer coin 1 to the receiver
1127     coin = self.coins[1]
1128     amount = ERC20(coin).balanceOf(self) - self.balances[1]
1129     if amount > 0:
1130         receiver: address = Factory(factory).fee_receiver(BASE_POOL)
1131         ERC20(coin).transfer(receiver, amount)