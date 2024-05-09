1 # @version 0.2.15
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2021 - all rights reserved
6 @notice 3 coin pool implementation with no lending
7 @dev Optimized to only support ERC20's with 18 decimals that return True/revert
8 """
9 
10 from vyper.interfaces import ERC20
11 
12 interface Factory:
13     def convert_fees() -> bool: nonpayable
14     def get_fee_receiver(_pool: address) -> address: view
15     def admin() -> address: view
16 
17 
18 event Transfer:
19     sender: indexed(address)
20     receiver: indexed(address)
21     value: uint256
22 
23 event Approval:
24     owner: indexed(address)
25     spender: indexed(address)
26     value: uint256
27 
28 event TokenExchange:
29     buyer: indexed(address)
30     sold_id: int128
31     tokens_sold: uint256
32     bought_id: int128
33     tokens_bought: uint256
34 
35 event AddLiquidity:
36     provider: indexed(address)
37     token_amounts: uint256[N_COINS]
38     fees: uint256[N_COINS]
39     invariant: uint256
40     token_supply: uint256
41 
42 event RemoveLiquidity:
43     provider: indexed(address)
44     token_amounts: uint256[N_COINS]
45     fees: uint256[N_COINS]
46     token_supply: uint256
47 
48 event RemoveLiquidityOne:
49     provider: indexed(address)
50     token_amount: uint256
51     coin_amount: uint256
52     token_supply: uint256
53 
54 event RemoveLiquidityImbalance:
55     provider: indexed(address)
56     token_amounts: uint256[N_COINS]
57     fees: uint256[N_COINS]
58     invariant: uint256
59     token_supply: uint256
60 
61 event RampA:
62     old_A: uint256
63     new_A: uint256
64     initial_time: uint256
65     future_time: uint256
66 
67 event StopRampA:
68     A: uint256
69     t: uint256
70 
71 
72 N_COINS: constant(int128) = 3
73 PRECISION: constant(int128) = 10 ** 18
74 
75 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
76 ADMIN_FEE: constant(uint256) = 5000000000
77 
78 A_PRECISION: constant(uint256) = 100
79 MAX_A: constant(uint256) = 10 ** 6
80 MAX_A_CHANGE: constant(uint256) = 10
81 MIN_RAMP_TIME: constant(uint256) = 86400
82 
83 factory: address
84 
85 coins: public(address[N_COINS])
86 balances: public(uint256[N_COINS])
87 fee: public(uint256)  # fee * 1e10
88 
89 initial_A: public(uint256)
90 future_A: public(uint256)
91 initial_A_time: public(uint256)
92 future_A_time: public(uint256)
93 
94 name: public(String[64])
95 symbol: public(String[32])
96 
97 balanceOf: public(HashMap[address, uint256])
98 allowance: public(HashMap[address, HashMap[address, uint256]])
99 totalSupply: public(uint256)
100 
101 
102 @external
103 def __init__():
104     # we do this to prevent the implementation contract from being used as a pool
105     self.fee = 31337
106 
107 
108 @external
109 def initialize(
110     _name: String[32],
111     _symbol: String[10],
112     _coins: address[4],
113     _rate_multipliers: uint256[4],
114     _A: uint256,
115     _fee: uint256,
116 ):
117     """
118     @notice Contract constructor
119     @param _name Name of the new pool
120     @param _symbol Token symbol
121     @param _coins List of all ERC20 conract addresses of coins
122     @param _rate_multipliers List of number of decimals in coins
123     @param _A Amplification coefficient multiplied by n ** (n - 1)
124     @param _fee Fee to charge for exchanges
125     """
126     # check if fee was already set to prevent initializing contract twice
127     assert self.fee == 0
128 
129     for i in range(N_COINS):
130         coin: address = _coins[i]
131         if coin == ZERO_ADDRESS:
132             break
133         self.coins[i] = coin
134         assert _rate_multipliers[i] == PRECISION
135 
136     A: uint256 = _A * A_PRECISION
137     self.initial_A = A
138     self.future_A = A
139     self.fee = _fee
140     self.factory = msg.sender
141 
142     self.name = concat("Curve.fi Factory Plain Pool: ", _name)
143     self.symbol = concat(_symbol, "-f")
144 
145     # fire a transfer event so block explorers identify the contract as an ERC20
146     log Transfer(ZERO_ADDRESS, self, 0)
147 
148 
149 ### ERC20 Functionality ###
150 
151 @view
152 @external
153 def decimals() -> uint256:
154     """
155     @notice Get the number of decimals for this token
156     @dev Implemented as a view method to reduce gas costs
157     @return uint256 decimal places
158     """
159     return 18
160 
161 
162 @internal
163 def _transfer(_from: address, _to: address, _value: uint256):
164     # # NOTE: vyper does not allow underflows
165     # #       so the following subtraction would revert on insufficient balance
166     self.balanceOf[_from] -= _value
167     self.balanceOf[_to] += _value
168 
169     log Transfer(_from, _to, _value)
170 
171 
172 @external
173 def transfer(_to : address, _value : uint256) -> bool:
174     """
175     @dev Transfer token for a specified address
176     @param _to The address to transfer to.
177     @param _value The amount to be transferred.
178     """
179     self._transfer(msg.sender, _to, _value)
180     return True
181 
182 
183 @external
184 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
185     """
186      @dev Transfer tokens from one address to another.
187      @param _from address The address which you want to send tokens from
188      @param _to address The address which you want to transfer to
189      @param _value uint256 the amount of tokens to be transferred
190     """
191     self._transfer(_from, _to, _value)
192 
193     _allowance: uint256 = self.allowance[_from][msg.sender]
194     if _allowance != MAX_UINT256:
195         self.allowance[_from][msg.sender] = _allowance - _value
196 
197     return True
198 
199 
200 @external
201 def approve(_spender : address, _value : uint256) -> bool:
202     """
203     @notice Approve the passed address to transfer the specified amount of
204             tokens on behalf of msg.sender
205     @dev Beware that changing an allowance via this method brings the risk that
206          someone may use both the old and new allowance by unfortunate transaction
207          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208     @param _spender The address which will transfer the funds
209     @param _value The amount of tokens that may be transferred
210     @return bool success
211     """
212     self.allowance[msg.sender][_spender] = _value
213 
214     log Approval(msg.sender, _spender, _value)
215     return True
216 
217 
218 ### StableSwap Functionality ###
219 
220 @view
221 @external
222 def get_balances() -> uint256[N_COINS]:
223     return self.balances
224 
225 
226 @view
227 @internal
228 def _A() -> uint256:
229     """
230     Handle ramping A up or down
231     """
232     t1: uint256 = self.future_A_time
233     A1: uint256 = self.future_A
234 
235     if block.timestamp < t1:
236         A0: uint256 = self.initial_A
237         t0: uint256 = self.initial_A_time
238         # Expressions in uint256 cannot have negative numbers, thus "if"
239         if A1 > A0:
240             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
241         else:
242             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
243 
244     else:  # when t1 == 0 or block.timestamp >= t1
245         return A1
246 
247 
248 @view
249 @external
250 def admin_fee() -> uint256:
251     return ADMIN_FEE
252 
253 
254 @view
255 @external
256 def A() -> uint256:
257     return self._A() / A_PRECISION
258 
259 
260 @view
261 @external
262 def A_precise() -> uint256:
263     return self._A()
264 
265 
266 @pure
267 @internal
268 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
269     """
270     D invariant calculation in non-overflowing integer operations
271     iteratively
272 
273     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
274 
275     Converging solution:
276     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
277     """
278     S: uint256 = 0
279     Dprev: uint256 = 0
280     for x in _xp:
281         S += x
282     if S == 0:
283         return 0
284 
285     D: uint256 = S
286     Ann: uint256 = _amp * N_COINS
287     for i in range(255):
288         D_P: uint256 = D
289         for x in _xp:
290             D_P = D_P * D / (x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
291         Dprev = D
292         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
293         # Equality with the precision of 1
294         if D > Dprev:
295             if D - Dprev <= 1:
296                 return D
297         else:
298             if Dprev - D <= 1:
299                 return D
300     # convergence typically occurs in 4 rounds or less, this should be unreachable!
301     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
302     raise
303 
304 
305 @view
306 @external
307 def get_virtual_price() -> uint256:
308     """
309     @notice The current virtual price of the pool LP token
310     @dev Useful for calculating profits
311     @return LP token virtual price normalized to 1e18
312     """
313     amp: uint256 = self._A()
314     D: uint256 = self.get_D(self.balances, amp)
315     # D is in the units similar to DAI (e.g. converted to precision 1e18)
316     # When balanced, D = n * x_u - total virtual value of the portfolio
317     return D * PRECISION / self.totalSupply
318 
319 
320 @view
321 @external
322 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
323     """
324     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
325     @dev This calculation accounts for slippage, but not fees.
326          Needed to prevent front-running, not for precise calculations!
327     @param _amounts Amount of each coin being deposited
328     @param _is_deposit set True for deposits, False for withdrawals
329     @return Expected amount of LP tokens received
330     """
331     amp: uint256 = self._A()
332     balances: uint256[N_COINS] = self.balances
333 
334     D0: uint256 = self.get_D(balances, amp)
335     for i in range(N_COINS):
336         amount: uint256 = _amounts[i]
337         if _is_deposit:
338             balances[i] += amount
339         else:
340             balances[i] -= amount
341     D1: uint256 = self.get_D(balances, amp)
342     diff: uint256 = 0
343     if _is_deposit:
344         diff = D1 - D0
345     else:
346         diff = D0 - D1
347     return diff * self.totalSupply / D0
348 
349 
350 @external
351 @nonreentrant('lock')
352 def add_liquidity(
353     _amounts: uint256[N_COINS],
354     _min_mint_amount: uint256,
355     _receiver: address = msg.sender
356 ) -> uint256:
357     """
358     @notice Deposit coins into the pool
359     @param _amounts List of amounts of coins to deposit
360     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
361     @param _receiver Address that owns the minted LP tokens
362     @return Amount of LP tokens received by depositing
363     """
364     amp: uint256 = self._A()
365     old_balances: uint256[N_COINS] = self.balances
366 
367     # Initial invariant
368     D0: uint256 = self.get_D(old_balances, amp)
369 
370     total_supply: uint256 = self.totalSupply
371     new_balances: uint256[N_COINS] = old_balances
372     for i in range(N_COINS):
373         amount: uint256 = _amounts[i]
374         if total_supply == 0:
375             assert amount > 0  # dev: initial deposit requires all coins
376         new_balances[i] += amount
377 
378     # Invariant after change
379     D1: uint256 = self.get_D(new_balances, amp)
380     assert D1 > D0
381 
382     # We need to recalculate the invariant accounting for fees
383     # to calculate fair user's share
384     fees: uint256[N_COINS] = empty(uint256[N_COINS])
385     mint_amount: uint256 = 0
386     if total_supply > 0:
387         # Only account for fees if we are not the first to deposit
388         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
389         for i in range(N_COINS):
390             ideal_balance: uint256 = D1 * old_balances[i] / D0
391             difference: uint256 = 0
392             new_balance: uint256 = new_balances[i]
393             if ideal_balance > new_balance:
394                 difference = ideal_balance - new_balance
395             else:
396                 difference = new_balance - ideal_balance
397             fees[i] = base_fee * difference / FEE_DENOMINATOR
398             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
399             new_balances[i] -= fees[i]
400         D2: uint256 = self.get_D(new_balances, amp)
401         mint_amount = total_supply * (D2 - D0) / D0
402     else:
403         self.balances = new_balances
404         mint_amount = D1  # Take the dust if there was any
405 
406     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
407 
408     # Take coins from the sender
409     for i in range(N_COINS):
410         amount: uint256 = _amounts[i]
411         if amount > 0:
412             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amount)
413 
414     # Mint pool tokens
415     total_supply += mint_amount
416     self.balanceOf[_receiver] += mint_amount
417     self.totalSupply = total_supply
418     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
419 
420     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
421 
422     return mint_amount
423 
424 
425 @view
426 @internal
427 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
428     """
429     Calculate x[j] if one makes x[i] = x
430 
431     Done by solving quadratic equation iteratively.
432     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
433     x_1**2 + b*x_1 = c
434 
435     x_1 = (x_1**2 + c) / (2*x_1 + b)
436     """
437     # x in the input is converted to the same price/precision
438 
439     assert i != j       # dev: same coin
440     assert j >= 0       # dev: j below zero
441     assert j < N_COINS  # dev: j above N_COINS
442 
443     # should be unreachable, but good for safety
444     assert i >= 0
445     assert i < N_COINS
446 
447     amp: uint256 = self._A()
448     D: uint256 = self.get_D(xp, amp)
449     S_: uint256 = 0
450     _x: uint256 = 0
451     y_prev: uint256 = 0
452     c: uint256 = D
453     Ann: uint256 = amp * N_COINS
454 
455     for _i in range(N_COINS):
456         if _i == i:
457             _x = x
458         elif _i != j:
459             _x = xp[_i]
460         else:
461             continue
462         S_ += _x
463         c = c * D / (_x * N_COINS)
464 
465     c = c * D * A_PRECISION / (Ann * N_COINS)
466     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
467     y: uint256 = D
468 
469     for _i in range(255):
470         y_prev = y
471         y = (y*y + c) / (2 * y + b - D)
472         # Equality with the precision of 1
473         if y > y_prev:
474             if y - y_prev <= 1:
475                 return y
476         else:
477             if y_prev - y <= 1:
478                 return y
479     raise
480 
481 
482 @view
483 @external
484 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
485     """
486     @notice Calculate the current output dy given input dx
487     @dev Index values can be found via the `coins` public getter method
488     @param i Index value for the coin to send
489     @param j Index valie of the coin to recieve
490     @param dx Amount of `i` being exchanged
491     @return Amount of `j` predicted
492     """
493     xp: uint256[N_COINS] = self.balances
494 
495     x: uint256 = xp[i] + dx
496     y: uint256 = self.get_y(i, j, x, xp)
497     dy: uint256 = xp[j] - y - 1
498     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
499     return dy - fee
500 
501 
502 @external
503 @nonreentrant('lock')
504 def exchange(
505     i: int128,
506     j: int128,
507     _dx: uint256,
508     _min_dy: uint256,
509     _receiver: address = msg.sender,
510 ) -> uint256:
511     """
512     @notice Perform an exchange between two coins
513     @dev Index values can be found via the `coins` public getter method
514     @param i Index value for the coin to send
515     @param j Index valie of the coin to recieve
516     @param _dx Amount of `i` being exchanged
517     @param _min_dy Minimum amount of `j` to receive
518     @return Actual amount of `j` received
519     """
520     old_balances: uint256[N_COINS] = self.balances
521 
522     x: uint256 = old_balances[i] + _dx
523     y: uint256 = self.get_y(i, j, x, old_balances)
524 
525     dy: uint256 = old_balances[j] - y - 1  # -1 just in case there were some rounding errors
526     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
527 
528     # Convert all to real units
529     dy -= dy_fee
530     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
531 
532     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
533 
534     # Change balances exactly in same way as we change actual ERC20 coin amounts
535     self.balances[i] = old_balances[i] + _dx
536     # When rounding errors happen, we undercharge admin fee in favor of LP
537     self.balances[j] = old_balances[j] - dy - dy_admin_fee
538 
539     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, _dx)
540     assert ERC20(self.coins[j]).transfer(_receiver, dy)
541 
542     log TokenExchange(msg.sender, i, _dx, j, dy)
543 
544     return dy
545 
546 
547 @external
548 @nonreentrant('lock')
549 def remove_liquidity(
550     _burn_amount: uint256,
551     _min_amounts: uint256[N_COINS],
552     _receiver: address = msg.sender
553 ) -> uint256[N_COINS]:
554     """
555     @notice Withdraw coins from the pool
556     @dev Withdrawal amounts are based on current deposit ratios
557     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
558     @param _min_amounts Minimum amounts of underlying coins to receive
559     @param _receiver Address that receives the withdrawn coins
560     @return List of amounts of coins that were withdrawn
561     """
562     total_supply: uint256 = self.totalSupply
563     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
564 
565     for i in range(N_COINS):
566         old_balance: uint256 = self.balances[i]
567         value: uint256 = old_balance * _burn_amount / total_supply
568         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
569         self.balances[i] = old_balance - value
570         amounts[i] = value
571         assert ERC20(self.coins[i]).transfer(_receiver, value)
572 
573     total_supply -= _burn_amount
574     self.balanceOf[msg.sender] -= _burn_amount
575     self.totalSupply = total_supply
576     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
577 
578     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
579 
580     return amounts
581 
582 
583 @external
584 @nonreentrant('lock')
585 def remove_liquidity_imbalance(
586     _amounts: uint256[N_COINS],
587     _max_burn_amount: uint256,
588     _receiver: address = msg.sender
589 ) -> uint256:
590     """
591     @notice Withdraw coins from the pool in an imbalanced amount
592     @param _amounts List of amounts of underlying coins to withdraw
593     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
594     @param _receiver Address that receives the withdrawn coins
595     @return Actual amount of the LP token burned in the withdrawal
596     """
597     amp: uint256 = self._A()
598     old_balances: uint256[N_COINS] = self.balances
599     D0: uint256 = self.get_D(old_balances, amp)
600 
601     new_balances: uint256[N_COINS] = old_balances
602     for i in range(N_COINS):
603         new_balances[i] -= _amounts[i]
604     D1: uint256 = self.get_D(new_balances, amp)
605 
606     fees: uint256[N_COINS] = empty(uint256[N_COINS])
607     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
608     for i in range(N_COINS):
609         ideal_balance: uint256 = D1 * old_balances[i] / D0
610         difference: uint256 = 0
611         new_balance: uint256 = new_balances[i]
612         if ideal_balance > new_balance:
613             difference = ideal_balance - new_balance
614         else:
615             difference = new_balance - ideal_balance
616         fees[i] = base_fee * difference / FEE_DENOMINATOR
617         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
618         new_balances[i] -= fees[i]
619     D2: uint256 = self.get_D(new_balances, amp)
620 
621     total_supply: uint256 = self.totalSupply
622     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
623     assert burn_amount > 1  # dev: zero tokens burned
624     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
625 
626     total_supply -= burn_amount
627     self.totalSupply = total_supply
628     self.balanceOf[msg.sender] -= burn_amount
629     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
630 
631     for i in range(N_COINS):
632         if _amounts[i] != 0:
633             assert ERC20(self.coins[i]).transfer(_receiver, _amounts[i])
634 
635     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
636 
637     return burn_amount
638 
639 
640 @pure
641 @internal
642 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
643     """
644     Calculate x[i] if one reduces D from being calculated for xp to D
645 
646     Done by solving quadratic equation iteratively.
647     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
648     x_1**2 + b*x_1 = c
649 
650     x_1 = (x_1**2 + c) / (2*x_1 + b)
651     """
652     # x in the input is converted to the same price/precision
653 
654     assert i >= 0  # dev: i below zero
655     assert i < N_COINS  # dev: i above N_COINS
656 
657     S_: uint256 = 0
658     _x: uint256 = 0
659     y_prev: uint256 = 0
660     c: uint256 = D
661     Ann: uint256 = A * N_COINS
662 
663     for _i in range(N_COINS):
664         if _i != i:
665             _x = xp[_i]
666         else:
667             continue
668         S_ += _x
669         c = c * D / (_x * N_COINS)
670 
671     c = c * D * A_PRECISION / (Ann * N_COINS)
672     b: uint256 = S_ + D * A_PRECISION / Ann
673     y: uint256 = D
674 
675     for _i in range(255):
676         y_prev = y
677         y = (y*y + c) / (2 * y + b - D)
678         # Equality with the precision of 1
679         if y > y_prev:
680             if y - y_prev <= 1:
681                 return y
682         else:
683             if y_prev - y <= 1:
684                 return y
685     raise
686 
687 
688 @view
689 @internal
690 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
691     # First, need to calculate
692     # * Get current D
693     # * Solve Eqn against y_i for D - _token_amount
694     amp: uint256 = self._A()
695     balances: uint256[N_COINS] = self.balances
696     D0: uint256 = self.get_D(balances, amp)
697 
698     total_supply: uint256 = self.totalSupply
699     D1: uint256 = D0 - _burn_amount * D0 / total_supply
700     new_y: uint256 = self.get_y_D(amp, i, balances, D1)
701 
702     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
703     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
704 
705     for j in range(N_COINS):
706         dx_expected: uint256 = 0
707         xp_j: uint256 = balances[j]
708         if j == i:
709             dx_expected = xp_j * D1 / D0 - new_y
710         else:
711             dx_expected = xp_j - xp_j * D1 / D0
712         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
713 
714     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
715     dy_0: uint256 = (balances[i] - new_y)  # w/o fees
716     dy = (dy - 1)  # Withdraw less to account for rounding errors
717 
718     return [dy, dy_0 - dy]
719 
720 
721 @view
722 @external
723 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
724     """
725     @notice Calculate the amount received when withdrawing a single coin
726     @param _burn_amount Amount of LP tokens to burn in the withdrawal
727     @param i Index value of the coin to withdraw
728     @return Amount of coin received
729     """
730     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
731 
732 
733 @external
734 @nonreentrant('lock')
735 def remove_liquidity_one_coin(
736     _burn_amount: uint256,
737     i: int128,
738     _min_received: uint256,
739     _receiver: address = msg.sender,
740 ) -> uint256:
741     """
742     @notice Withdraw a single coin from the pool
743     @param _burn_amount Amount of LP tokens to burn in the withdrawal
744     @param i Index value of the coin to withdraw
745     @param _min_received Minimum amount of coin to receive
746     @param _receiver Address that receives the withdrawn coins
747     @return Amount of coin received
748     """
749     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
750     assert dy[0] >= _min_received, "Not enough coins removed"
751 
752     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
753     total_supply: uint256 = self.totalSupply - _burn_amount
754     self.totalSupply = total_supply
755     self.balanceOf[msg.sender] -= _burn_amount
756     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
757 
758     assert ERC20(self.coins[i]).transfer(_receiver, dy[0])
759 
760     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
761 
762     return dy[0]
763 
764 
765 @external
766 def ramp_A(_future_A: uint256, _future_time: uint256):
767     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
768     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
769     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
770 
771     _initial_A: uint256 = self._A()
772     _future_A_p: uint256 = _future_A * A_PRECISION
773 
774     assert _future_A > 0 and _future_A < MAX_A
775     if _future_A_p < _initial_A:
776         assert _future_A_p * MAX_A_CHANGE >= _initial_A
777     else:
778         assert _future_A_p <= _initial_A * MAX_A_CHANGE
779 
780     self.initial_A = _initial_A
781     self.future_A = _future_A_p
782     self.initial_A_time = block.timestamp
783     self.future_A_time = _future_time
784 
785     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
786 
787 
788 @external
789 def stop_ramp_A():
790     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
791 
792     current_A: uint256 = self._A()
793     self.initial_A = current_A
794     self.future_A = current_A
795     self.initial_A_time = block.timestamp
796     self.future_A_time = block.timestamp
797     # now (block.timestamp < t1) is always False, so we return saved A
798 
799     log StopRampA(current_A, block.timestamp)
800 
801 
802 @view
803 @external
804 def admin_balances(i: uint256) -> uint256:
805     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
806 
807 
808 @external
809 def withdraw_admin_fees():
810     receiver: address = Factory(self.factory).get_fee_receiver(self)
811 
812     for i in range(N_COINS):
813         coin: address = self.coins[i]
814         fees: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
815         ERC20(coin).transfer(receiver, fees)