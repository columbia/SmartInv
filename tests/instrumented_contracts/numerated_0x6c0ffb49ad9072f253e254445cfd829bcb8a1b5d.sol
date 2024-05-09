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
26 
27 event Transfer:
28     sender: indexed(address)
29     receiver: indexed(address)
30     value: uint256
31 
32 event Approval:
33     owner: indexed(address)
34     spender: indexed(address)
35     value: uint256
36 
37 event TokenExchange:
38     buyer: indexed(address)
39     sold_id: int128
40     tokens_sold: uint256
41     bought_id: int128
42     tokens_bought: uint256
43 
44 event TokenExchangeUnderlying:
45     buyer: indexed(address)
46     sold_id: int128
47     tokens_sold: uint256
48     bought_id: int128
49     tokens_bought: uint256
50 
51 event AddLiquidity:
52     provider: indexed(address)
53     token_amounts: uint256[N_COINS]
54     fees: uint256[N_COINS]
55     invariant: uint256
56     token_supply: uint256
57 
58 event RemoveLiquidity:
59     provider: indexed(address)
60     token_amounts: uint256[N_COINS]
61     fees: uint256[N_COINS]
62     token_supply: uint256
63 
64 event RemoveLiquidityOne:
65     provider: indexed(address)
66     token_amount: uint256
67     coin_amount: uint256
68     token_supply: uint256
69 
70 event RemoveLiquidityImbalance:
71     provider: indexed(address)
72     token_amounts: uint256[N_COINS]
73     fees: uint256[N_COINS]
74     invariant: uint256
75     token_supply: uint256
76 
77 event CommitNewAdmin:
78     deadline: indexed(uint256)
79     admin: indexed(address)
80 
81 event NewAdmin:
82     admin: indexed(address)
83 
84 event CommitNewFee:
85     deadline: indexed(uint256)
86     fee: uint256
87     admin_fee: uint256
88 
89 event NewFee:
90     fee: uint256
91     admin_fee: uint256
92 
93 event RampA:
94     old_A: uint256
95     new_A: uint256
96     initial_time: uint256
97     future_time: uint256
98 
99 event StopRampA:
100     A: uint256
101     t: uint256
102 
103 
104 FEE_RECEIVER: constant(address) = 0xA464e6DCda8AC41e03616F95f4BC98a13b8922Dc
105 BASE_POOL: constant(address) = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7
106 BASE_COINS: constant(address[3]) = [
107     0x6B175474E89094C44Da98b954EedeAC495271d0F,  # DAI
108     0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,  # USDC
109     0xdAC17F958D2ee523a2206206994597C13D831ec7,  # USDT
110 ]
111 
112 N_COINS: constant(int128) = 2
113 MAX_COIN: constant(int128) = N_COINS - 1
114 BASE_N_COINS: constant(int128) = 3
115 PRECISION: constant(uint256) = 10 ** 18
116 
117 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
118 ADMIN_FEE: constant(uint256) = 5000000000
119 
120 A_PRECISION: constant(uint256) = 100
121 MAX_A: constant(uint256) = 10 ** 6
122 MAX_A_CHANGE: constant(uint256) = 10
123 MIN_RAMP_TIME: constant(uint256) = 86400
124 
125 
126 admin: public(address)
127 
128 coins: public(address[N_COINS])
129 balances: public(uint256[N_COINS])
130 fee: public(uint256)  # fee * 1e10
131 
132 BASE_CACHE_EXPIRES: constant(int128) = 10 * 60  # 10 min
133 base_virtual_price: public(uint256)
134 base_cache_updated: public(uint256)
135 
136 initial_A: public(uint256)
137 future_A: public(uint256)
138 initial_A_time: public(uint256)
139 future_A_time: public(uint256)
140 
141 rate_multiplier: uint256
142 
143 name: public(String[64])
144 symbol: public(String[32])
145 
146 balanceOf: public(HashMap[address, uint256])
147 allowance: public(HashMap[address, HashMap[address, uint256]])
148 totalSupply: public(uint256)
149 
150 
151 @external
152 def __init__():
153     # we do this to prevent the implementation contract from being used as a pool
154     self.fee = 31337
155 
156 
157 @external
158 def initialize(
159     _name: String[32],
160     _symbol: String[10],
161     _coin: address,
162     _decimals: uint256,
163     _A: uint256,
164     _fee: uint256,
165     _admin: address,
166 ):
167     """
168     @notice Contract initializer
169     @param _name Name of the new pool
170     @param _symbol Token symbol
171     @param _coin Addresses of ERC20 conracts of coins
172     @param _decimals Number of decimals in `_coin`
173     @param _A Amplification coefficient multiplied by n * (n - 1)
174     @param _fee Fee to charge for exchanges
175     @param _admin Admin address
176     """
177      # things break if a token has >18 decimals
178     assert _decimals < 19
179     # fee must be between 0.04% and 1%
180     assert _fee >= 4000000
181     assert _fee <= 100000000
182     # check if fee was already set to prevent initializing contract twice
183     assert self.fee == 0
184 
185     A: uint256 = _A * A_PRECISION
186     self.coins = [_coin, 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490]
187     self.rate_multiplier = 10 ** (36 - _decimals)
188     self.initial_A = A
189     self.future_A = A
190     self.fee = _fee
191     self.admin = _admin
192 
193     self.name = concat("Curve.fi Factory USD Metapool: ", _name)
194     self.symbol = concat(_symbol, "3CRV-f")
195 
196     for coin in BASE_COINS:
197         ERC20(coin).approve(BASE_POOL, MAX_UINT256)
198 
199     # fire a transfer event so block explorers identify the contract as an ERC20
200     log Transfer(ZERO_ADDRESS, self, 0)
201 
202 
203 ### ERC20 Functionality ###
204 
205 @view
206 @external
207 def decimals() -> uint256:
208     """
209     @notice Get the number of decimals for this token
210     @dev Implemented as a view method to reduce gas costs
211     @return uint256 decimal places
212     """
213     return 18
214 
215 
216 @external
217 def transfer(_to : address, _value : uint256) -> bool:
218     """
219     @dev Transfer token for a specified address
220     @param _to The address to transfer to.
221     @param _value The amount to be transferred.
222     """
223     # NOTE: vyper does not allow underflows
224     #       so the following subtraction would revert on insufficient balance
225     self.balanceOf[msg.sender] -= _value
226     self.balanceOf[_to] += _value
227 
228     log Transfer(msg.sender, _to, _value)
229     return True
230 
231 
232 @external
233 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
234     """
235      @dev Transfer tokens from one address to another.
236      @param _from address The address which you want to send tokens from
237      @param _to address The address which you want to transfer to
238      @param _value uint256 the amount of tokens to be transferred
239     """
240     self.balanceOf[_from] -= _value
241     self.balanceOf[_to] += _value
242 
243     _allowance: uint256 = self.allowance[_from][msg.sender]
244     if _allowance != MAX_UINT256:
245         self.allowance[_from][msg.sender] = _allowance - _value
246 
247     log Transfer(_from, _to, _value)
248     return True
249 
250 
251 @external
252 def approve(_spender : address, _value : uint256) -> bool:
253     """
254     @notice Approve the passed address to transfer the specified amount of
255             tokens on behalf of msg.sender
256     @dev Beware that changing an allowance via this method brings the risk that
257          someone may use both the old and new allowance by unfortunate transaction
258          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259     @param _spender The address which will transfer the funds
260     @param _value The amount of tokens that may be transferred
261     @return bool success
262     """
263     self.allowance[msg.sender][_spender] = _value
264 
265     log Approval(msg.sender, _spender, _value)
266     return True
267 
268 
269 ### StableSwap Functionality ###
270 
271 @view
272 @internal
273 def _A() -> uint256:
274     """
275     Handle ramping A up or down
276     """
277     t1: uint256 = self.future_A_time
278     A1: uint256 = self.future_A
279 
280     if block.timestamp < t1:
281         A0: uint256 = self.initial_A
282         t0: uint256 = self.initial_A_time
283         # Expressions in uint256 cannot have negative numbers, thus "if"
284         if A1 > A0:
285             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
286         else:
287             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
288 
289     else:  # when t1 == 0 or block.timestamp >= t1
290         return A1
291 
292 
293 @view
294 @external
295 def admin_fee() -> uint256:
296     return ADMIN_FEE
297 
298 
299 @view
300 @external
301 def A() -> uint256:
302     return self._A() / A_PRECISION
303 
304 
305 @view
306 @external
307 def A_precise() -> uint256:
308     return self._A()
309 
310 
311 @pure
312 @internal
313 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
314     result: uint256[N_COINS] = empty(uint256[N_COINS])
315     for i in range(N_COINS):
316         result[i] = _rates[i] * _balances[i] / PRECISION
317     return result
318 
319 
320 @view
321 @internal
322 def _xp(_rates: uint256[N_COINS]) -> uint256[N_COINS]:
323     return self._xp_mem(_rates, self.balances)
324 
325 
326 @internal
327 def _vp_rate() -> uint256:
328     vprice: uint256 = 0
329     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
330         vprice = Curve(BASE_POOL).get_virtual_price()
331         self.base_virtual_price = vprice
332         self.base_cache_updated = block.timestamp
333     else:
334         vprice = self.base_virtual_price
335     return vprice
336 
337 
338 @internal
339 @view
340 def _vp_rate_ro() -> uint256:
341     if block.timestamp > self.base_cache_updated + BASE_CACHE_EXPIRES:
342         return Curve(BASE_POOL).get_virtual_price()
343     else:
344         return self.base_virtual_price
345 
346 
347 @pure
348 @internal
349 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
350     S: uint256 = 0
351     Dprev: uint256 = 0
352     for x in _xp:
353         S += x
354     if S == 0:
355         return 0
356 
357     D: uint256 = S
358     Ann: uint256 = _amp * N_COINS
359     for i in range(255):
360         D_P: uint256 = D
361         for x in _xp:
362             D_P = D_P * D / (x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
363         Dprev = D
364         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
365         # Equality with the precision of 1
366         if D > Dprev:
367             if D - Dprev <= 1:
368                 return D
369         else:
370             if Dprev - D <= 1:
371                 return D
372     # convergence typically occurs in 4 rounds or less, this should be unreachable!
373     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
374     raise
375 
376 
377 @view
378 @internal
379 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
380     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
381     return self.get_D(xp, _amp)
382 
383 
384 @view
385 @external
386 def get_virtual_price() -> uint256:
387     """
388     @notice The current virtual price of the pool LP token
389     @dev Useful for calculating profits
390     @return LP token virtual price normalized to 1e18
391     """
392     amp: uint256 = self._A()
393     xp: uint256[N_COINS] = self._xp([self.rate_multiplier, self._vp_rate_ro()])
394     D: uint256 = self.get_D(xp, amp)
395     # D is in the units similar to DAI (e.g. converted to precision 1e18)
396     # When balanced, D = n * x_u - total virtual value of the portfolio
397     return D * PRECISION / self.totalSupply
398 
399 
400 @view
401 @external
402 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
403     """
404     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
405     @dev This calculation accounts for slippage, but not fees.
406          Needed to prevent front-running, not for precise calculations!
407     @param _amounts Amount of each coin being deposited
408     @param _is_deposit set True for deposits, False for withdrawals
409     @return Expected amount of LP tokens received
410     """
411     amp: uint256 = self._A()
412     rates: uint256[N_COINS] = [self.rate_multiplier, self._vp_rate_ro()]
413     balances: uint256[N_COINS] = self.balances
414     D0: uint256 = self.get_D_mem(rates, balances, amp)
415     for i in range(N_COINS):
416         amount: uint256 = _amounts[i]
417         if _is_deposit:
418             balances[i] += amount
419         else:
420             balances[i] -= amount
421     D1: uint256 = self.get_D_mem(rates, balances, amp)
422     diff: uint256 = 0
423     if _is_deposit:
424         diff = D1 - D0
425     else:
426         diff = D0 - D1
427     return diff * self.totalSupply / D0
428 
429 
430 @external
431 @nonreentrant('lock')
432 def add_liquidity(
433     _amounts: uint256[N_COINS],
434     _min_mint_amount: uint256,
435     _receiver: address = msg.sender
436 ) -> uint256:
437     """
438     @notice Deposit coins into the pool
439     @param _amounts List of amounts of coins to deposit
440     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
441     @param _receiver Address that owns the minted LP tokens
442     @return Amount of LP tokens received by depositing
443     """
444     amp: uint256 = self._A()
445     rates: uint256[N_COINS] = [self.rate_multiplier, self._vp_rate()]
446     total_supply: uint256 = self.totalSupply
447 
448     # Initial invariant
449     D0: uint256 = 0
450     old_balances: uint256[N_COINS] = self.balances
451     if total_supply > 0:
452         D0 = self.get_D_mem(rates, old_balances, amp)
453     new_balances: uint256[N_COINS] = old_balances
454 
455     for i in range(N_COINS):
456         amount: uint256 = _amounts[i]
457         if total_supply == 0:
458             assert amount > 0  # dev: initial deposit requires all coins
459         new_balances[i] += amount
460 
461     # Invariant after change
462     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
463     assert D1 > D0
464 
465     # We need to recalculate the invariant accounting for fees
466     # to calculate fair user's share
467     fees: uint256[N_COINS] = empty(uint256[N_COINS])
468     mint_amount: uint256 = 0
469     if total_supply > 0:
470         # Only account for fees if we are not the first to deposit
471         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
472         for i in range(N_COINS):
473             ideal_balance: uint256 = D1 * old_balances[i] / D0
474             difference: uint256 = 0
475             new_balance: uint256 = new_balances[i]
476             if ideal_balance > new_balance:
477                 difference = ideal_balance - new_balance
478             else:
479                 difference = new_balance - ideal_balance
480             fees[i] = base_fee * difference / FEE_DENOMINATOR
481             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
482             new_balances[i] -= fees[i]
483         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
484         mint_amount = total_supply * (D2 - D0) / D0
485     else:
486         self.balances = new_balances
487         mint_amount = D1  # Take the dust if there was any
488 
489     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
490 
491     # Take coins from the sender
492     for i in range(N_COINS):
493         amount: uint256 = _amounts[i]
494         if amount > 0:
495             ERC20(self.coins[i]).transferFrom(msg.sender, self, amount)  # dev: failed transfer
496 
497     # Mint pool tokens
498     total_supply += mint_amount
499     self.balanceOf[_receiver] += mint_amount
500     self.totalSupply = total_supply
501     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
502 
503     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
504 
505     return mint_amount
506 
507 
508 @view
509 @internal
510 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
511     # x in the input is converted to the same price/precision
512 
513     assert i != j       # dev: same coin
514     assert j >= 0       # dev: j below zero
515     assert j < N_COINS  # dev: j above N_COINS
516 
517     # should be unreachable, but good for safety
518     assert i >= 0
519     assert i < N_COINS
520 
521     amp: uint256 = self._A()
522     D: uint256 = self.get_D(xp, amp)
523     S_: uint256 = 0
524     _x: uint256 = 0
525     y_prev: uint256 = 0
526     c: uint256 = D
527     Ann: uint256 = amp * N_COINS
528 
529     for _i in range(N_COINS):
530         if _i == i:
531             _x = x
532         elif _i != j:
533             _x = xp[_i]
534         else:
535             continue
536         S_ += _x
537         c = c * D / (_x * N_COINS)
538 
539     c = c * D * A_PRECISION / (Ann * N_COINS)
540     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
541     y: uint256 = D
542 
543     for _i in range(255):
544         y_prev = y
545         y = (y*y + c) / (2 * y + b - D)
546         # Equality with the precision of 1
547         if y > y_prev:
548             if y - y_prev <= 1:
549                 return y
550         else:
551             if y_prev - y <= 1:
552                 return y
553     raise
554 
555 
556 @view
557 @external
558 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
559     rates: uint256[N_COINS] = [self.rate_multiplier, self._vp_rate_ro()]
560     xp: uint256[N_COINS] = self._xp(rates)
561 
562     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
563     y: uint256 = self.get_y(i, j, x, xp)
564     dy: uint256 = xp[j] - y - 1
565     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
566     return (dy - fee) * PRECISION / rates[j]
567 
568 
569 @view
570 @external
571 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
572     rates: uint256[N_COINS] = [self.rate_multiplier, self._vp_rate_ro()]
573     xp: uint256[N_COINS] = self._xp(rates)
574     base_pool: address = BASE_POOL
575 
576     x: uint256 = 0
577     base_i: int128 = 0
578     base_j: int128 = 0
579     meta_i: int128 = 0
580     meta_j: int128 = 0
581 
582     if i != 0:
583         base_i = i - MAX_COIN
584         meta_i = 1
585     if j != 0:
586         base_j = j - MAX_COIN
587         meta_j = 1
588 
589     if i == 0:
590         x = xp[i] + dx * (rates[0] / 10**18)
591     else:
592         if j == 0:
593             # i is from BasePool
594             # At first, get the amount of pool tokens
595             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
596             base_inputs[base_i] = dx
597             # Token amount transformed to underlying "dollars"
598             x = Curve(base_pool).calc_token_amount(base_inputs, True) * rates[1] / PRECISION
599             # Accounting for deposit/withdraw fees approximately
600             x -= x * Curve(base_pool).fee() / (2 * FEE_DENOMINATOR)
601             # Adding number of pool tokens
602             x += xp[MAX_COIN]
603         else:
604             # If both are from the base pool
605             return Curve(base_pool).get_dy(base_i, base_j, dx)
606 
607     # This pool is involved only when in-pool assets are used
608     y: uint256 = self.get_y(meta_i, meta_j, x, xp)
609     dy: uint256 = xp[meta_j] - y - 1
610     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
611 
612     # If output is going via the metapool
613     if j == 0:
614         dy /= (rates[0] / 10**18)
615     else:
616         # j is from BasePool
617         # The fee is already accounted for
618         dy = Curve(base_pool).calc_withdraw_one_coin(dy * PRECISION / rates[1], base_j)
619 
620     return dy
621 
622 
623 @external
624 @nonreentrant('lock')
625 def exchange(
626     i: int128,
627     j: int128,
628     dx: uint256,
629     min_dy: uint256,
630     _receiver: address = msg.sender,
631 ) -> uint256:
632     """
633     @notice Perform an exchange between two coins
634     @dev Index values can be found via the `coins` public getter method
635     @param i Index value for the coin to send
636     @param j Index valie of the coin to recieve
637     @param dx Amount of `i` being exchanged
638     @param min_dy Minimum amount of `j` to receive
639     @param _receiver Address that receives `j`
640     @return Actual amount of `j` received
641     """
642     rates: uint256[N_COINS] = [self.rate_multiplier, self._vp_rate()]
643 
644     old_balances: uint256[N_COINS] = self.balances
645     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
646 
647     x: uint256 = xp[i] + dx * rates[i] / PRECISION
648     y: uint256 = self.get_y(i, j, x, xp)
649 
650     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
651     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
652 
653     # Convert all to real units
654     dy = (dy - dy_fee) * PRECISION / rates[j]
655     assert dy >= min_dy, "Too few coins in result"
656 
657     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
658     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
659 
660     # Change balances exactly in same way as we change actual ERC20 coin amounts
661     self.balances[i] = old_balances[i] + dx
662     # When rounding errors happen, we undercharge admin fee in favor of LP
663     self.balances[j] = old_balances[j] - dy - dy_admin_fee
664 
665     ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)
666     ERC20(self.coins[j]).transfer(_receiver, dy)
667 
668     log TokenExchange(msg.sender, i, dx, j, dy)
669 
670     return dy
671 
672 
673 @external
674 @nonreentrant('lock')
675 def exchange_underlying(
676     i: int128,
677     j: int128,
678     dx: uint256,
679     min_dy: uint256,
680     _receiver: address = msg.sender,
681 ) -> uint256:
682     """
683     @notice Perform an exchange between two underlying coins
684     @dev Index values can be found via the `underlying_coins` public getter method
685     @param i Index value for the underlying coin to send
686     @param j Index valie of the underlying coin to recieve
687     @param dx Amount of `i` being exchanged
688     @param min_dy Minimum amount of `j` to receive
689     @param _receiver Address that receives `j`
690     @return Actual amount of `j` received
691     """
692     rates: uint256[N_COINS] = [self.rate_multiplier, self._vp_rate()]
693     old_balances: uint256[N_COINS] = self.balances
694     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
695 
696     base_pool: address = BASE_POOL
697     base_coins: address[3] = BASE_COINS
698 
699     dy: uint256 = 0
700     base_i: int128 = 0
701     base_j: int128 = 0
702     meta_i: int128 = 0
703     meta_j: int128 = 0
704     x: uint256 = 0
705     input_coin: address = ZERO_ADDRESS
706     output_coin: address = ZERO_ADDRESS
707 
708     if i == 0:
709         input_coin = self.coins[0]
710     else:
711         base_i = i - MAX_COIN
712         meta_i = 1
713         input_coin = base_coins[base_i]
714     if j == 0:
715         output_coin = self.coins[0]
716     else:
717         base_j = j - MAX_COIN
718         meta_j = 1
719         output_coin = base_coins[base_j]
720 
721     # Handle potential Tether fees
722     dx_w_fee: uint256 = dx
723     if j == 3:
724         dx_w_fee = ERC20(input_coin).balanceOf(self)
725 
726     ERC20(input_coin).transferFrom(msg.sender, self, dx)
727 
728     # Handle potential Tether fees
729     if j == 3:
730         dx_w_fee = ERC20(input_coin).balanceOf(self) - dx_w_fee
731 
732     if i == 0 or j == 0:
733         if i == 0:
734             x = xp[i] + dx_w_fee * rates[i] / PRECISION
735         else:
736             # i is from BasePool
737             # At first, get the amount of pool tokens
738             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
739             base_inputs[base_i] = dx_w_fee
740             coin_i: address = self.coins[MAX_COIN]
741             # Deposit and measure delta
742             x = ERC20(coin_i).balanceOf(self)
743             Curve(base_pool).add_liquidity(base_inputs, 0)
744             # Need to convert pool token to "virtual" units using rates
745             # dx is also different now
746             dx_w_fee = ERC20(coin_i).balanceOf(self) - x
747             x = dx_w_fee * rates[MAX_COIN] / PRECISION
748             # Adding number of pool tokens
749             x += xp[MAX_COIN]
750 
751         y: uint256 = self.get_y(meta_i, meta_j, x, xp)
752 
753         # Either a real coin or token
754         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
755         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
756 
757         # Convert all to real units
758         # Works for both pool coins and real coins
759         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
760 
761         dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
762         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
763 
764         # Change balances exactly in same way as we change actual ERC20 coin amounts
765         self.balances[meta_i] = old_balances[meta_i] + dx_w_fee
766         # When rounding errors happen, we undercharge admin fee in favor of LP
767         self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee
768 
769         # Withdraw from the base pool if needed
770         if j > 0:
771             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
772             Curve(base_pool).remove_liquidity_one_coin(dy, base_j, 0)
773             dy = ERC20(output_coin).balanceOf(self) - out_amount
774 
775         assert dy >= min_dy, "Too few coins in result"
776 
777     else:
778         # If both are from the base pool
779         dy = ERC20(output_coin).balanceOf(self)
780         Curve(base_pool).exchange(base_i, base_j, dx_w_fee, min_dy)
781         dy = ERC20(output_coin).balanceOf(self) - dy
782 
783     ERC20(output_coin).transfer(_receiver, dy)
784 
785     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
786 
787     return dy
788 
789 
790 @external
791 @nonreentrant('lock')
792 def remove_liquidity(
793     _burn_amount: uint256,
794     _min_amounts: uint256[N_COINS],
795     _receiver: address = msg.sender
796 ) -> uint256[N_COINS]:
797     """
798     @notice Withdraw coins from the pool
799     @dev Withdrawal amounts are based on current deposit ratios
800     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
801     @param _min_amounts Minimum amounts of underlying coins to receive
802     @param _receiver Address that receives the withdrawn coins
803     @return List of amounts of coins that were withdrawn
804     """
805     total_supply: uint256 = self.totalSupply
806     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
807 
808     for i in range(N_COINS):
809         old_balance: uint256 = self.balances[i]
810         value: uint256 = old_balance * _burn_amount / total_supply
811         assert value >= _min_amounts[i], "Too few coins in result"
812         self.balances[i] = old_balance - value
813         amounts[i] = value
814         ERC20(self.coins[i]).transfer(_receiver, value)
815 
816     total_supply -= _burn_amount
817     self.balanceOf[msg.sender] -= _burn_amount
818     self.totalSupply = total_supply
819     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
820 
821     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
822 
823     return amounts
824 
825 
826 @external
827 @nonreentrant('lock')
828 def remove_liquidity_imbalance(
829     _amounts: uint256[N_COINS],
830     _max_burn_amount: uint256,
831     _receiver: address = msg.sender
832 ) -> uint256:
833     """
834     @notice Withdraw coins from the pool in an imbalanced amount
835     @param _amounts List of amounts of underlying coins to withdraw
836     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
837     @param _receiver Address that receives the withdrawn coins
838     @return Actual amount of the LP token burned in the withdrawal
839     """
840 
841     amp: uint256 = self._A()
842     rates: uint256[N_COINS] = [self.rate_multiplier, self._vp_rate()]
843     old_balances: uint256[N_COINS] = self.balances
844     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
845 
846     new_balances: uint256[N_COINS] = old_balances
847     for i in range(N_COINS):
848         new_balances[i] -= _amounts[i]
849     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
850 
851     fees: uint256[N_COINS] = empty(uint256[N_COINS])
852     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
853     for i in range(N_COINS):
854         ideal_balance: uint256 = D1 * old_balances[i] / D0
855         difference: uint256 = 0
856         new_balance: uint256 = new_balances[i]
857         if ideal_balance > new_balance:
858             difference = ideal_balance - new_balance
859         else:
860             difference = new_balance - ideal_balance
861         fees[i] = base_fee * difference / FEE_DENOMINATOR
862         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
863         new_balances[i] -= fees[i]
864     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
865 
866     total_supply: uint256 = self.totalSupply
867     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
868     assert burn_amount > 1  # dev: zero tokens burned
869     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
870 
871     total_supply -= burn_amount
872     self.totalSupply = total_supply
873     self.balanceOf[msg.sender] -= burn_amount
874     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
875 
876     for i in range(N_COINS):
877         amount: uint256 = _amounts[i]
878         if amount != 0:
879             ERC20(self.coins[i]).transfer(_receiver, amount)
880 
881     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
882 
883     return burn_amount
884 
885 
886 @view
887 @internal
888 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
889     """
890     Calculate x[i] if one reduces D from being calculated for xp to D
891 
892     Done by solving quadratic equation iteratively.
893     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
894     x_1**2 + b*x_1 = c
895 
896     x_1 = (x_1**2 + c) / (2*x_1 + b)
897     """
898     # x in the input is converted to the same price/precision
899 
900     assert i >= 0  # dev: i below zero
901     assert i < N_COINS  # dev: i above N_COINS
902 
903     S_: uint256 = 0
904     _x: uint256 = 0
905     y_prev: uint256 = 0
906     c: uint256 = D
907     Ann: uint256 = A * N_COINS
908 
909     for _i in range(N_COINS):
910         if _i != i:
911             _x = xp[_i]
912         else:
913             continue
914         S_ += _x
915         c = c * D / (_x * N_COINS)
916 
917     c = c * D * A_PRECISION / (Ann * N_COINS)
918     b: uint256 = S_ + D * A_PRECISION / Ann
919     y: uint256 = D
920 
921     for _i in range(255):
922         y_prev = y
923         y = (y*y + c) / (2 * y + b - D)
924         # Equality with the precision of 1
925         if y > y_prev:
926             if y - y_prev <= 1:
927                 return y
928         else:
929             if y_prev - y <= 1:
930                 return y
931     raise
932 
933 
934 @view
935 @internal
936 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128, _rates: uint256[N_COINS]) -> (uint256, uint256, uint256):
937     # First, need to calculate
938     # * Get current D
939     # * Solve Eqn against y_i for D - _token_amount
940     amp: uint256 = self._A()
941     xp: uint256[N_COINS] = self._xp(_rates)
942     D0: uint256 = self.get_D(xp, amp)
943 
944     total_supply: uint256 = self.totalSupply
945     D1: uint256 = D0 - _burn_amount * D0 / total_supply
946     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
947 
948     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
949 
950     xp_reduced: uint256[N_COINS] = xp
951     dy_0: uint256 = (xp[i] - new_y) * PRECISION / _rates[i]  # w/o fees
952 
953     for j in range(N_COINS):
954         dx_expected: uint256 = 0
955         xp_j: uint256 = xp[j]
956         if j == i:
957             dx_expected = xp_j * D1 / D0 - new_y
958         else:
959             dx_expected = xp_j - xp_j * D1 / D0
960         xp_reduced[j] -= base_fee * dx_expected / FEE_DENOMINATOR
961 
962     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
963     dy = (dy - 1) * PRECISION / _rates[i]  # Withdraw less to account for rounding errors
964 
965     return dy, dy_0 - dy, total_supply
966 
967 
968 @view
969 @external
970 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
971     """
972     @notice Calculate the amount received when withdrawing a single coin
973     @param _burn_amount Amount of LP tokens to burn in the withdrawal
974     @param i Index value of the coin to withdraw
975     @return Amount of coin received
976     """
977     vp_rate: uint256 = self._vp_rate_ro()
978     return self._calc_withdraw_one_coin(_burn_amount, i, [self.rate_multiplier, vp_rate])[0]
979 
980 
981 @external
982 @nonreentrant('lock')
983 def remove_liquidity_one_coin(
984     _burn_amount: uint256,
985     i: int128,
986     _min_received: uint256,
987     _receiver: address = msg.sender,
988 ) -> uint256:
989     """
990     @notice Withdraw a single coin from the pool
991     @param _burn_amount Amount of LP tokens to burn in the withdrawal
992     @param i Index value of the coin to withdraw
993     @param _min_received Minimum amount of coin to receive
994     @param _receiver Address that receives the withdrawn coins
995     @return Amount of coin received
996     """
997 
998     dy: uint256 = 0
999     dy_fee: uint256 = 0
1000     total_supply: uint256 = 0
1001     dy, dy_fee, total_supply = self._calc_withdraw_one_coin(_burn_amount, i, [self.rate_multiplier, self._vp_rate()])
1002     assert dy >= _min_received, "Not enough coins removed"
1003 
1004     self.balances[i] -= (dy + dy_fee * ADMIN_FEE / FEE_DENOMINATOR)
1005 
1006     total_supply -= _burn_amount
1007     self.totalSupply = total_supply
1008     self.balanceOf[msg.sender] -= _burn_amount
1009     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
1010 
1011     ERC20(self.coins[i]).transfer(_receiver, dy)
1012 
1013     log RemoveLiquidityOne(msg.sender, _burn_amount, dy, total_supply)
1014 
1015     return dy
1016 
1017 
1018 @external
1019 def ramp_A(_future_A: uint256, _future_time: uint256):
1020     assert msg.sender == self.admin  # dev: only owner
1021     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
1022     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
1023 
1024     _initial_A: uint256 = self._A()
1025     _future_A_p: uint256 = _future_A * A_PRECISION
1026 
1027     assert _future_A > 0 and _future_A < MAX_A
1028     if _future_A_p < _initial_A:
1029         assert _future_A_p * MAX_A_CHANGE >= _initial_A
1030     else:
1031         assert _future_A_p <= _initial_A * MAX_A_CHANGE
1032 
1033     self.initial_A = _initial_A
1034     self.future_A = _future_A_p
1035     self.initial_A_time = block.timestamp
1036     self.future_A_time = _future_time
1037 
1038     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
1039 
1040 
1041 @external
1042 def stop_ramp_A():
1043     assert msg.sender == self.admin  # dev: only owner
1044 
1045     current_A: uint256 = self._A()
1046     self.initial_A = current_A
1047     self.future_A = current_A
1048     self.initial_A_time = block.timestamp
1049     self.future_A_time = block.timestamp
1050     # now (block.timestamp < t1) is always False, so we return saved A
1051 
1052     log StopRampA(current_A, block.timestamp)
1053 
1054 
1055 @view
1056 @external
1057 def admin_balances(i: uint256) -> uint256:
1058     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1059 
1060 
1061 @external
1062 def withdraw_admin_fees():
1063     """
1064     @notice Withdraw admin fees to the fee distributor
1065     @dev Non-3CRV admin fees are swapped prior to withdrawal
1066     """
1067     rates: uint256[N_COINS] = [self.rate_multiplier, self._vp_rate()]
1068 
1069     old_balances: uint256[N_COINS] = self.balances
1070     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
1071 
1072     new_balance: uint256 = old_balances[1]
1073     dx: uint256 = ERC20(self.coins[0]).balanceOf(self) - old_balances[0]
1074     if dx > 0:
1075         x: uint256 = xp[0] + dx * rates[0] / PRECISION
1076         y: uint256 = self.get_y(0, 1, x, xp)
1077 
1078         dy: uint256 = xp[1] - y - 1
1079         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
1080 
1081         # Convert all to real units
1082         dy = (dy - dy_fee) * PRECISION / rates[1]
1083         dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
1084         dy_admin_fee = dy_admin_fee * PRECISION / rates[1]
1085 
1086         new_balance -= dy + dy_admin_fee
1087         self.balances = [old_balances[0] + dx, new_balance]
1088 
1089     coin: address = self.coins[1]
1090     claimable_fee: uint256 = ERC20(coin).balanceOf(self) - new_balance
1091     ERC20(coin).transfer(FEE_RECEIVER, claimable_fee)