1 # @version 0.2.15
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2021 - all rights reserved
6 @notice 2 coin pool implementation with no lending
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
72 N_COINS: constant(int128) = 2
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
279     for x in _xp:
280         S += x
281     if S == 0:
282         return 0
283 
284     D: uint256 = S
285     Ann: uint256 = _amp * N_COINS
286     for i in range(255):
287         D_P: uint256 = D * D / _xp[0] * D / _xp[1] / (N_COINS)**2
288         Dprev: uint256 = D
289         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
290         # Equality with the precision of 1
291         if D > Dprev:
292             if D - Dprev <= 1:
293                 return D
294         else:
295             if Dprev - D <= 1:
296                 return D
297     # convergence typically occurs in 4 rounds or less, this should be unreachable!
298     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
299     raise
300 
301 
302 @view
303 @external
304 def get_virtual_price() -> uint256:
305     """
306     @notice The current virtual price of the pool LP token
307     @dev Useful for calculating profits
308     @return LP token virtual price normalized to 1e18
309     """
310     amp: uint256 = self._A()
311     D: uint256 = self.get_D(self.balances, amp)
312     # D is in the units similar to DAI (e.g. converted to precision 1e18)
313     # When balanced, D = n * x_u - total virtual value of the portfolio
314     return D * PRECISION / self.totalSupply
315 
316 
317 @view
318 @external
319 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
320     """
321     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
322     @dev This calculation accounts for slippage, but not fees.
323          Needed to prevent front-running, not for precise calculations!
324     @param _amounts Amount of each coin being deposited
325     @param _is_deposit set True for deposits, False for withdrawals
326     @return Expected amount of LP tokens received
327     """
328     amp: uint256 = self._A()
329     balances: uint256[N_COINS] = self.balances
330 
331     D0: uint256 = self.get_D(balances, amp)
332     for i in range(N_COINS):
333         amount: uint256 = _amounts[i]
334         if _is_deposit:
335             balances[i] += amount
336         else:
337             balances[i] -= amount
338     D1: uint256 = self.get_D(balances, amp)
339     diff: uint256 = 0
340     if _is_deposit:
341         diff = D1 - D0
342     else:
343         diff = D0 - D1
344     return diff * self.totalSupply / D0
345 
346 
347 @external
348 @nonreentrant('lock')
349 def add_liquidity(
350     _amounts: uint256[N_COINS],
351     _min_mint_amount: uint256,
352     _receiver: address = msg.sender
353 ) -> uint256:
354     """
355     @notice Deposit coins into the pool
356     @param _amounts List of amounts of coins to deposit
357     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
358     @param _receiver Address that owns the minted LP tokens
359     @return Amount of LP tokens received by depositing
360     """
361     amp: uint256 = self._A()
362     old_balances: uint256[N_COINS] = self.balances
363 
364     # Initial invariant
365     D0: uint256 = self.get_D(old_balances, amp)
366 
367     total_supply: uint256 = self.totalSupply
368     new_balances: uint256[N_COINS] = old_balances
369     for i in range(N_COINS):
370         amount: uint256 = _amounts[i]
371         if total_supply == 0:
372             assert amount > 0  # dev: initial deposit requires all coins
373         new_balances[i] += amount
374 
375     # Invariant after change
376     D1: uint256 = self.get_D(new_balances, amp)
377     assert D1 > D0
378 
379     # We need to recalculate the invariant accounting for fees
380     # to calculate fair user's share
381     fees: uint256[N_COINS] = empty(uint256[N_COINS])
382     mint_amount: uint256 = 0
383     if total_supply > 0:
384         # Only account for fees if we are not the first to deposit
385         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
386         for i in range(N_COINS):
387             ideal_balance: uint256 = D1 * old_balances[i] / D0
388             difference: uint256 = 0
389             new_balance: uint256 = new_balances[i]
390             if ideal_balance > new_balance:
391                 difference = ideal_balance - new_balance
392             else:
393                 difference = new_balance - ideal_balance
394             fees[i] = base_fee * difference / FEE_DENOMINATOR
395             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
396             new_balances[i] -= fees[i]
397         D2: uint256 = self.get_D(new_balances, amp)
398         mint_amount = total_supply * (D2 - D0) / D0
399     else:
400         self.balances = new_balances
401         mint_amount = D1  # Take the dust if there was any
402 
403     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
404 
405     # Take coins from the sender
406     for i in range(N_COINS):
407         amount: uint256 = _amounts[i]
408         if amount > 0:
409             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amount)
410 
411     # Mint pool tokens
412     total_supply += mint_amount
413     self.balanceOf[_receiver] += mint_amount
414     self.totalSupply = total_supply
415     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
416 
417     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
418 
419     return mint_amount
420 
421 
422 @view
423 @internal
424 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
425     """
426     Calculate x[j] if one makes x[i] = x
427 
428     Done by solving quadratic equation iteratively.
429     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
430     x_1**2 + b*x_1 = c
431 
432     x_1 = (x_1**2 + c) / (2*x_1 + b)
433     """
434     # x in the input is converted to the same price/precision
435 
436     assert i != j       # dev: same coin
437     assert j >= 0       # dev: j below zero
438     assert j < N_COINS  # dev: j above N_COINS
439 
440     # should be unreachable, but good for safety
441     assert i >= 0
442     assert i < N_COINS
443 
444     amp: uint256 = self._A()
445     D: uint256 = self.get_D(xp, amp)
446     S_: uint256 = 0
447     _x: uint256 = 0
448     y_prev: uint256 = 0
449     c: uint256 = D
450     Ann: uint256 = amp * N_COINS
451 
452     for _i in range(N_COINS):
453         if _i == i:
454             _x = x
455         elif _i != j:
456             _x = xp[_i]
457         else:
458             continue
459         S_ += _x
460         c = c * D / (_x * N_COINS)
461 
462     c = c * D * A_PRECISION / (Ann * N_COINS)
463     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
464     y: uint256 = D
465 
466     for _i in range(255):
467         y_prev = y
468         y = (y*y + c) / (2 * y + b - D)
469         # Equality with the precision of 1
470         if y > y_prev:
471             if y - y_prev <= 1:
472                 return y
473         else:
474             if y_prev - y <= 1:
475                 return y
476     raise
477 
478 
479 @view
480 @external
481 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
482     """
483     @notice Calculate the current output dy given input dx
484     @dev Index values can be found via the `coins` public getter method
485     @param i Index value for the coin to send
486     @param j Index valie of the coin to recieve
487     @param dx Amount of `i` being exchanged
488     @return Amount of `j` predicted
489     """
490     xp: uint256[N_COINS] = self.balances
491 
492     x: uint256 = xp[i] + dx
493     y: uint256 = self.get_y(i, j, x, xp)
494     dy: uint256 = xp[j] - y - 1
495     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
496     return dy - fee
497 
498 
499 @external
500 @nonreentrant('lock')
501 def exchange(
502     i: int128,
503     j: int128,
504     _dx: uint256,
505     _min_dy: uint256,
506     _receiver: address = msg.sender,
507 ) -> uint256:
508     """
509     @notice Perform an exchange between two coins
510     @dev Index values can be found via the `coins` public getter method
511     @param i Index value for the coin to send
512     @param j Index valie of the coin to recieve
513     @param _dx Amount of `i` being exchanged
514     @param _min_dy Minimum amount of `j` to receive
515     @return Actual amount of `j` received
516     """
517     old_balances: uint256[N_COINS] = self.balances
518 
519     x: uint256 = old_balances[i] + _dx
520     y: uint256 = self.get_y(i, j, x, old_balances)
521 
522     dy: uint256 = old_balances[j] - y - 1  # -1 just in case there were some rounding errors
523     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
524 
525     # Convert all to real units
526     dy -= dy_fee
527     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
528 
529     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
530 
531     # Change balances exactly in same way as we change actual ERC20 coin amounts
532     self.balances[i] = old_balances[i] + _dx
533     # When rounding errors happen, we undercharge admin fee in favor of LP
534     self.balances[j] = old_balances[j] - dy - dy_admin_fee
535 
536     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, _dx)
537     assert ERC20(self.coins[j]).transfer(_receiver, dy)
538 
539     log TokenExchange(msg.sender, i, _dx, j, dy)
540 
541     return dy
542 
543 
544 @external
545 @nonreentrant('lock')
546 def remove_liquidity(
547     _burn_amount: uint256,
548     _min_amounts: uint256[N_COINS],
549     _receiver: address = msg.sender
550 ) -> uint256[N_COINS]:
551     """
552     @notice Withdraw coins from the pool
553     @dev Withdrawal amounts are based on current deposit ratios
554     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
555     @param _min_amounts Minimum amounts of underlying coins to receive
556     @param _receiver Address that receives the withdrawn coins
557     @return List of amounts of coins that were withdrawn
558     """
559     total_supply: uint256 = self.totalSupply
560     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
561 
562     for i in range(N_COINS):
563         old_balance: uint256 = self.balances[i]
564         value: uint256 = old_balance * _burn_amount / total_supply
565         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
566         self.balances[i] = old_balance - value
567         amounts[i] = value
568         assert ERC20(self.coins[i]).transfer(_receiver, value)
569 
570     total_supply -= _burn_amount
571     self.balanceOf[msg.sender] -= _burn_amount
572     self.totalSupply = total_supply
573     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
574 
575     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
576 
577     return amounts
578 
579 
580 @external
581 @nonreentrant('lock')
582 def remove_liquidity_imbalance(
583     _amounts: uint256[N_COINS],
584     _max_burn_amount: uint256,
585     _receiver: address = msg.sender
586 ) -> uint256:
587     """
588     @notice Withdraw coins from the pool in an imbalanced amount
589     @param _amounts List of amounts of underlying coins to withdraw
590     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
591     @param _receiver Address that receives the withdrawn coins
592     @return Actual amount of the LP token burned in the withdrawal
593     """
594     amp: uint256 = self._A()
595     old_balances: uint256[N_COINS] = self.balances
596     D0: uint256 = self.get_D(old_balances, amp)
597 
598     new_balances: uint256[N_COINS] = old_balances
599     for i in range(N_COINS):
600         new_balances[i] -= _amounts[i]
601     D1: uint256 = self.get_D(new_balances, amp)
602 
603     fees: uint256[N_COINS] = empty(uint256[N_COINS])
604     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
605     for i in range(N_COINS):
606         ideal_balance: uint256 = D1 * old_balances[i] / D0
607         difference: uint256 = 0
608         new_balance: uint256 = new_balances[i]
609         if ideal_balance > new_balance:
610             difference = ideal_balance - new_balance
611         else:
612             difference = new_balance - ideal_balance
613         fees[i] = base_fee * difference / FEE_DENOMINATOR
614         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
615         new_balances[i] -= fees[i]
616     D2: uint256 = self.get_D(new_balances, amp)
617 
618     total_supply: uint256 = self.totalSupply
619     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
620     assert burn_amount > 1  # dev: zero tokens burned
621     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
622 
623     total_supply -= burn_amount
624     self.totalSupply = total_supply
625     self.balanceOf[msg.sender] -= burn_amount
626     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
627 
628     for i in range(N_COINS):
629         if _amounts[i] != 0:
630             assert ERC20(self.coins[i]).transfer(_receiver, _amounts[i])
631 
632     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
633 
634     return burn_amount
635 
636 
637 @pure
638 @internal
639 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
640     """
641     Calculate x[i] if one reduces D from being calculated for xp to D
642 
643     Done by solving quadratic equation iteratively.
644     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
645     x_1**2 + b*x_1 = c
646 
647     x_1 = (x_1**2 + c) / (2*x_1 + b)
648     """
649     # x in the input is converted to the same price/precision
650 
651     assert i >= 0  # dev: i below zero
652     assert i < N_COINS  # dev: i above N_COINS
653 
654     S_: uint256 = 0
655     _x: uint256 = 0
656     y_prev: uint256 = 0
657     c: uint256 = D
658     Ann: uint256 = A * N_COINS
659 
660     for _i in range(N_COINS):
661         if _i != i:
662             _x = xp[_i]
663         else:
664             continue
665         S_ += _x
666         c = c * D / (_x * N_COINS)
667 
668     c = c * D * A_PRECISION / (Ann * N_COINS)
669     b: uint256 = S_ + D * A_PRECISION / Ann
670     y: uint256 = D
671 
672     for _i in range(255):
673         y_prev = y
674         y = (y*y + c) / (2 * y + b - D)
675         # Equality with the precision of 1
676         if y > y_prev:
677             if y - y_prev <= 1:
678                 return y
679         else:
680             if y_prev - y <= 1:
681                 return y
682     raise
683 
684 
685 @view
686 @internal
687 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
688     # First, need to calculate
689     # * Get current D
690     # * Solve Eqn against y_i for D - _token_amount
691     amp: uint256 = self._A()
692     balances: uint256[N_COINS] = self.balances
693     D0: uint256 = self.get_D(balances, amp)
694 
695     total_supply: uint256 = self.totalSupply
696     D1: uint256 = D0 - _burn_amount * D0 / total_supply
697     new_y: uint256 = self.get_y_D(amp, i, balances, D1)
698 
699     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
700     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
701 
702     for j in range(N_COINS):
703         dx_expected: uint256 = 0
704         xp_j: uint256 = balances[j]
705         if j == i:
706             dx_expected = xp_j * D1 / D0 - new_y
707         else:
708             dx_expected = xp_j - xp_j * D1 / D0
709         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
710 
711     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
712     dy_0: uint256 = (balances[i] - new_y)  # w/o fees
713     dy = (dy - 1)  # Withdraw less to account for rounding errors
714 
715     return [dy, dy_0 - dy]
716 
717 
718 @view
719 @external
720 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128, _previous: bool = False) -> uint256:
721     """
722     @notice Calculate the amount received when withdrawing a single coin
723     @param _burn_amount Amount of LP tokens to burn in the withdrawal
724     @param i Index value of the coin to withdraw
725     @return Amount of coin received
726     """
727     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
728 
729 
730 @external
731 @nonreentrant('lock')
732 def remove_liquidity_one_coin(
733     _burn_amount: uint256,
734     i: int128,
735     _min_received: uint256,
736     _receiver: address = msg.sender,
737 ) -> uint256:
738     """
739     @notice Withdraw a single coin from the pool
740     @param _burn_amount Amount of LP tokens to burn in the withdrawal
741     @param i Index value of the coin to withdraw
742     @param _min_received Minimum amount of coin to receive
743     @param _receiver Address that receives the withdrawn coins
744     @return Amount of coin received
745     """
746     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
747     assert dy[0] >= _min_received, "Not enough coins removed"
748 
749     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
750     total_supply: uint256 = self.totalSupply - _burn_amount
751     self.totalSupply = total_supply
752     self.balanceOf[msg.sender] -= _burn_amount
753     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
754 
755     assert ERC20(self.coins[i]).transfer(_receiver, dy[0])
756 
757     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
758 
759     return dy[0]
760 
761 
762 @external
763 def ramp_A(_future_A: uint256, _future_time: uint256):
764     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
765     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
766     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
767 
768     _initial_A: uint256 = self._A()
769     _future_A_p: uint256 = _future_A * A_PRECISION
770 
771     assert _future_A > 0 and _future_A < MAX_A
772     if _future_A_p < _initial_A:
773         assert _future_A_p * MAX_A_CHANGE >= _initial_A
774     else:
775         assert _future_A_p <= _initial_A * MAX_A_CHANGE
776 
777     self.initial_A = _initial_A
778     self.future_A = _future_A_p
779     self.initial_A_time = block.timestamp
780     self.future_A_time = _future_time
781 
782     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
783 
784 
785 @external
786 def stop_ramp_A():
787     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
788 
789     current_A: uint256 = self._A()
790     self.initial_A = current_A
791     self.future_A = current_A
792     self.initial_A_time = block.timestamp
793     self.future_A_time = block.timestamp
794     # now (block.timestamp < t1) is always False, so we return saved A
795 
796     log StopRampA(current_A, block.timestamp)
797 
798 
799 @view
800 @external
801 def admin_balances(i: uint256) -> uint256:
802     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
803 
804 
805 @external
806 def withdraw_admin_fees():
807     receiver: address = Factory(self.factory).get_fee_receiver(self)
808 
809     for i in range(N_COINS):
810         coin: address = self.coins[i]
811         fees: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
812         ERC20(coin).transfer(receiver, fees)