1 # @version 0.2.15
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2021 - all rights reserved
6 @notice 2 coin pool implementation with no lending
7 @dev ERC20 support for return True/revert, return True/False, return None
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
73 PRECISION: constant(uint256) = 10 ** 18
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
94 rate_multipliers: uint256[N_COINS]
95 
96 name: public(String[64])
97 symbol: public(String[32])
98 
99 balanceOf: public(HashMap[address, uint256])
100 allowance: public(HashMap[address, HashMap[address, uint256]])
101 totalSupply: public(uint256)
102 
103 
104 @external
105 def __init__():
106     # we do this to prevent the implementation contract from being used as a pool
107     self.fee = 31337
108 
109 
110 @external
111 def initialize(
112     _name: String[32],
113     _symbol: String[10],
114     _coins: address[4],
115     _rate_multipliers: uint256[4],
116     _A: uint256,
117     _fee: uint256,
118 ):
119     """
120     @notice Contract constructor
121     @param _name Name of the new pool
122     @param _symbol Token symbol
123     @param _coins List of all ERC20 conract addresses of coins
124     @param _rate_multipliers List of number of decimals in coins
125     @param _A Amplification coefficient multiplied by n ** (n - 1)
126     @param _fee Fee to charge for exchanges
127     """
128     # check if fee was already set to prevent initializing contract twice
129     assert self.fee == 0
130 
131     for i in range(N_COINS):
132         coin: address = _coins[i]
133         if coin == ZERO_ADDRESS:
134             break
135         self.coins[i] = coin
136         self.rate_multipliers[i] = _rate_multipliers[i]
137 
138     A: uint256 = _A * A_PRECISION
139     self.initial_A = A
140     self.future_A = A
141     self.fee = _fee
142     self.factory = msg.sender
143 
144     self.name = concat("Curve.fi Factory Plain Pool: ", _name)
145     self.symbol = concat(_symbol, "-f")
146 
147     # fire a transfer event so block explorers identify the contract as an ERC20
148     log Transfer(ZERO_ADDRESS, self, 0)
149 
150 
151 ### ERC20 Functionality ###
152 
153 @view
154 @external
155 def decimals() -> uint256:
156     """
157     @notice Get the number of decimals for this token
158     @dev Implemented as a view method to reduce gas costs
159     @return uint256 decimal places
160     """
161     return 18
162 
163 
164 @internal
165 def _transfer(_from: address, _to: address, _value: uint256):
166     # # NOTE: vyper does not allow underflows
167     # #       so the following subtraction would revert on insufficient balance
168     self.balanceOf[_from] -= _value
169     self.balanceOf[_to] += _value
170 
171     log Transfer(_from, _to, _value)
172 
173 
174 @external
175 def transfer(_to : address, _value : uint256) -> bool:
176     """
177     @dev Transfer token for a specified address
178     @param _to The address to transfer to.
179     @param _value The amount to be transferred.
180     """
181     self._transfer(msg.sender, _to, _value)
182     return True
183 
184 
185 @external
186 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
187     """
188      @dev Transfer tokens from one address to another.
189      @param _from address The address which you want to send tokens from
190      @param _to address The address which you want to transfer to
191      @param _value uint256 the amount of tokens to be transferred
192     """
193     self._transfer(_from, _to, _value)
194 
195     _allowance: uint256 = self.allowance[_from][msg.sender]
196     if _allowance != MAX_UINT256:
197         self.allowance[_from][msg.sender] = _allowance - _value
198 
199     return True
200 
201 
202 @external
203 def approve(_spender : address, _value : uint256) -> bool:
204     """
205     @notice Approve the passed address to transfer the specified amount of
206             tokens on behalf of msg.sender
207     @dev Beware that changing an allowance via this method brings the risk that
208          someone may use both the old and new allowance by unfortunate transaction
209          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210     @param _spender The address which will transfer the funds
211     @param _value The amount of tokens that may be transferred
212     @return bool success
213     """
214     self.allowance[msg.sender][_spender] = _value
215 
216     log Approval(msg.sender, _spender, _value)
217     return True
218 
219 
220 ### StableSwap Functionality ###
221 
222 @view
223 @external
224 def get_balances() -> uint256[N_COINS]:
225     return self.balances
226 
227 
228 @view
229 @internal
230 def _A() -> uint256:
231     """
232     Handle ramping A up or down
233     """
234     t1: uint256 = self.future_A_time
235     A1: uint256 = self.future_A
236 
237     if block.timestamp < t1:
238         A0: uint256 = self.initial_A
239         t0: uint256 = self.initial_A_time
240         # Expressions in uint256 cannot have negative numbers, thus "if"
241         if A1 > A0:
242             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
243         else:
244             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
245 
246     else:  # when t1 == 0 or block.timestamp >= t1
247         return A1
248 
249 
250 @view
251 @external
252 def admin_fee() -> uint256:
253     return ADMIN_FEE
254 
255 
256 @view
257 @external
258 def A() -> uint256:
259     return self._A() / A_PRECISION
260 
261 
262 @view
263 @external
264 def A_precise() -> uint256:
265     return self._A()
266 
267 
268 @pure
269 @internal
270 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
271     result: uint256[N_COINS] = empty(uint256[N_COINS])
272     for i in range(N_COINS):
273         result[i] = _rates[i] * _balances[i] / PRECISION
274     return result
275 
276 
277 @pure
278 @internal
279 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
280     """
281     D invariant calculation in non-overflowing integer operations
282     iteratively
283 
284     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
285 
286     Converging solution:
287     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
288     """
289     S: uint256 = 0
290     for x in _xp:
291         S += x
292     if S == 0:
293         return 0
294 
295     D: uint256 = S
296     Ann: uint256 = _amp * N_COINS
297     for i in range(255):
298         D_P: uint256 = D * D / _xp[0] * D / _xp[1] / (N_COINS)**2
299         Dprev: uint256 = D
300         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
301         # Equality with the precision of 1
302         if D > Dprev:
303             if D - Dprev <= 1:
304                 return D
305         else:
306             if Dprev - D <= 1:
307                 return D
308     # convergence typically occurs in 4 rounds or less, this should be unreachable!
309     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
310     raise
311 
312 
313 @view
314 @internal
315 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
316     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
317     return self.get_D(xp, _amp)
318 
319 
320 @view
321 @external
322 def get_virtual_price() -> uint256:
323     """
324     @notice The current virtual price of the pool LP token
325     @dev Useful for calculating profits
326     @return LP token virtual price normalized to 1e18
327     """
328     amp: uint256 = self._A()
329     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, self.balances)
330     D: uint256 = self.get_D(xp, amp)
331     # D is in the units similar to DAI (e.g. converted to precision 1e18)
332     # When balanced, D = n * x_u - total virtual value of the portfolio
333     return D * PRECISION / self.totalSupply
334 
335 
336 @view
337 @external
338 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
339     """
340     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
341     @dev This calculation accounts for slippage, but not fees.
342          Needed to prevent front-running, not for precise calculations!
343     @param _amounts Amount of each coin being deposited
344     @param _is_deposit set True for deposits, False for withdrawals
345     @return Expected amount of LP tokens received
346     """
347     amp: uint256 = self._A()
348     balances: uint256[N_COINS] = self.balances
349 
350     D0: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
351     for i in range(N_COINS):
352         amount: uint256 = _amounts[i]
353         if _is_deposit:
354             balances[i] += amount
355         else:
356             balances[i] -= amount
357     D1: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
358     diff: uint256 = 0
359     if _is_deposit:
360         diff = D1 - D0
361     else:
362         diff = D0 - D1
363     return diff * self.totalSupply / D0
364 
365 
366 @external
367 @nonreentrant('lock')
368 def add_liquidity(
369     _amounts: uint256[N_COINS],
370     _min_mint_amount: uint256,
371     _receiver: address = msg.sender
372 ) -> uint256:
373     """
374     @notice Deposit coins into the pool
375     @param _amounts List of amounts of coins to deposit
376     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
377     @param _receiver Address that owns the minted LP tokens
378     @return Amount of LP tokens received by depositing
379     """
380     amp: uint256 = self._A()
381     old_balances: uint256[N_COINS] = self.balances
382     rates: uint256[N_COINS] = self.rate_multipliers
383 
384     # Initial invariant
385     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
386 
387     total_supply: uint256 = self.totalSupply
388     new_balances: uint256[N_COINS] = old_balances
389     for i in range(N_COINS):
390         amount: uint256 = _amounts[i]
391         if amount > 0:
392             response: Bytes[32] = raw_call(
393                 self.coins[i],
394                 concat(
395                     method_id("transferFrom(address,address,uint256)"),
396                     convert(msg.sender, bytes32),
397                     convert(self, bytes32),
398                     convert(amount, bytes32),
399                 ),
400                 max_outsize=32,
401             )
402             if len(response) > 0:
403                 assert convert(response, bool)  # dev: failed transfer
404             new_balances[i] += amount
405             # end "safeTransferFrom"
406         else:
407             assert total_supply != 0  # dev: initial deposit requires all coins
408 
409     # Invariant after change
410     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
411     assert D1 > D0
412 
413     # We need to recalculate the invariant accounting for fees
414     # to calculate fair user's share
415     fees: uint256[N_COINS] = empty(uint256[N_COINS])
416     mint_amount: uint256 = 0
417     if total_supply > 0:
418         # Only account for fees if we are not the first to deposit
419         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
420         for i in range(N_COINS):
421             ideal_balance: uint256 = D1 * old_balances[i] / D0
422             difference: uint256 = 0
423             new_balance: uint256 = new_balances[i]
424             if ideal_balance > new_balance:
425                 difference = ideal_balance - new_balance
426             else:
427                 difference = new_balance - ideal_balance
428             fees[i] = base_fee * difference / FEE_DENOMINATOR
429             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
430             new_balances[i] -= fees[i]
431         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
432         mint_amount = total_supply * (D2 - D0) / D0
433     else:
434         self.balances = new_balances
435         mint_amount = D1  # Take the dust if there was any
436 
437     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
438 
439     # Mint pool tokens
440     total_supply += mint_amount
441     self.balanceOf[_receiver] += mint_amount
442     self.totalSupply = total_supply
443     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
444 
445     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
446 
447     return mint_amount
448 
449 
450 @view
451 @internal
452 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
453     """
454     Calculate x[j] if one makes x[i] = x
455 
456     Done by solving quadratic equation iteratively.
457     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
458     x_1**2 + b*x_1 = c
459 
460     x_1 = (x_1**2 + c) / (2*x_1 + b)
461     """
462     # x in the input is converted to the same price/precision
463 
464     assert i != j       # dev: same coin
465     assert j >= 0       # dev: j below zero
466     assert j < N_COINS  # dev: j above N_COINS
467 
468     # should be unreachable, but good for safety
469     assert i >= 0
470     assert i < N_COINS
471 
472     amp: uint256 = self._A()
473     D: uint256 = self.get_D(xp, amp)
474     S_: uint256 = 0
475     _x: uint256 = 0
476     y_prev: uint256 = 0
477     c: uint256 = D
478     Ann: uint256 = amp * N_COINS
479 
480     for _i in range(N_COINS):
481         if _i == i:
482             _x = x
483         elif _i != j:
484             _x = xp[_i]
485         else:
486             continue
487         S_ += _x
488         c = c * D / (_x * N_COINS)
489 
490     c = c * D * A_PRECISION / (Ann * N_COINS)
491     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
492     y: uint256 = D
493 
494     for _i in range(255):
495         y_prev = y
496         y = (y*y + c) / (2 * y + b - D)
497         # Equality with the precision of 1
498         if y > y_prev:
499             if y - y_prev <= 1:
500                 return y
501         else:
502             if y_prev - y <= 1:
503                 return y
504     raise
505 
506 
507 @view
508 @external
509 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
510     """
511     @notice Calculate the current output dy given input dx
512     @dev Index values can be found via the `coins` public getter method
513     @param i Index value for the coin to send
514     @param j Index valie of the coin to recieve
515     @param dx Amount of `i` being exchanged
516     @return Amount of `j` predicted
517     """
518     rates: uint256[N_COINS] = self.rate_multipliers
519     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
520 
521     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
522     y: uint256 = self.get_y(i, j, x, xp)
523     dy: uint256 = xp[j] - y - 1
524     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
525     return (dy - fee) * PRECISION / rates[j]
526 
527 
528 @external
529 @nonreentrant('lock')
530 def exchange(
531     i: int128,
532     j: int128,
533     _dx: uint256,
534     _min_dy: uint256,
535     _receiver: address = msg.sender,
536 ) -> uint256:
537     """
538     @notice Perform an exchange between two coins
539     @dev Index values can be found via the `coins` public getter method
540     @param i Index value for the coin to send
541     @param j Index valie of the coin to recieve
542     @param _dx Amount of `i` being exchanged
543     @param _min_dy Minimum amount of `j` to receive
544     @return Actual amount of `j` received
545     """
546     rates: uint256[N_COINS] = self.rate_multipliers
547     old_balances: uint256[N_COINS] = self.balances
548     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
549 
550     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
551     y: uint256 = self.get_y(i, j, x, xp)
552 
553     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
554     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
555 
556     # Convert all to real units
557     dy = (dy - dy_fee) * PRECISION / rates[j]
558     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
559 
560     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
561     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
562 
563     # Change balances exactly in same way as we change actual ERC20 coin amounts
564     self.balances[i] = old_balances[i] + _dx
565     # When rounding errors happen, we undercharge admin fee in favor of LP
566     self.balances[j] = old_balances[j] - dy - dy_admin_fee
567 
568     response: Bytes[32] = raw_call(
569         self.coins[i],
570         concat(
571             method_id("transferFrom(address,address,uint256)"),
572             convert(msg.sender, bytes32),
573             convert(self, bytes32),
574             convert(_dx, bytes32),
575         ),
576         max_outsize=32,
577     )
578     if len(response) > 0:
579         assert convert(response, bool)
580 
581     response = raw_call(
582         self.coins[j],
583         concat(
584             method_id("transfer(address,uint256)"),
585             convert(_receiver, bytes32),
586             convert(dy, bytes32),
587         ),
588         max_outsize=32,
589     )
590     if len(response) > 0:
591         assert convert(response, bool)
592 
593     log TokenExchange(msg.sender, i, _dx, j, dy)
594 
595     return dy
596 
597 
598 @external
599 @nonreentrant('lock')
600 def remove_liquidity(
601     _burn_amount: uint256,
602     _min_amounts: uint256[N_COINS],
603     _receiver: address = msg.sender
604 ) -> uint256[N_COINS]:
605     """
606     @notice Withdraw coins from the pool
607     @dev Withdrawal amounts are based on current deposit ratios
608     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
609     @param _min_amounts Minimum amounts of underlying coins to receive
610     @param _receiver Address that receives the withdrawn coins
611     @return List of amounts of coins that were withdrawn
612     """
613     total_supply: uint256 = self.totalSupply
614     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
615 
616     for i in range(N_COINS):
617         old_balance: uint256 = self.balances[i]
618         value: uint256 = old_balance * _burn_amount / total_supply
619         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
620         self.balances[i] = old_balance - value
621         amounts[i] = value
622 
623         response: Bytes[32] = raw_call(
624             self.coins[i],
625             concat(
626                 method_id("transfer(address,uint256)"),
627                 convert(_receiver, bytes32),
628                 convert(value, bytes32),
629             ),
630             max_outsize=32,
631         )
632         if len(response) > 0:
633             assert convert(response, bool)
634 
635     total_supply -= _burn_amount
636     self.balanceOf[msg.sender] -= _burn_amount
637     self.totalSupply = total_supply
638     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
639 
640     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
641 
642     return amounts
643 
644 
645 @external
646 @nonreentrant('lock')
647 def remove_liquidity_imbalance(
648     _amounts: uint256[N_COINS],
649     _max_burn_amount: uint256,
650     _receiver: address = msg.sender
651 ) -> uint256:
652     """
653     @notice Withdraw coins from the pool in an imbalanced amount
654     @param _amounts List of amounts of underlying coins to withdraw
655     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
656     @param _receiver Address that receives the withdrawn coins
657     @return Actual amount of the LP token burned in the withdrawal
658     """
659     amp: uint256 = self._A()
660     rates: uint256[N_COINS] = self.rate_multipliers
661     old_balances: uint256[N_COINS] = self.balances
662     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
663 
664     new_balances: uint256[N_COINS] = old_balances
665     for i in range(N_COINS):
666         amount: uint256 = _amounts[i]
667         if amount != 0:
668             new_balances[i] -= amount
669             response: Bytes[32] = raw_call(
670                 self.coins[i],
671                 concat(
672                     method_id("transfer(address,uint256)"),
673                     convert(_receiver, bytes32),
674                     convert(amount, bytes32),
675                 ),
676                 max_outsize=32,
677             )
678             if len(response) > 0:
679                 assert convert(response, bool)
680     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
681 
682     fees: uint256[N_COINS] = empty(uint256[N_COINS])
683     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
684     for i in range(N_COINS):
685         ideal_balance: uint256 = D1 * old_balances[i] / D0
686         difference: uint256 = 0
687         new_balance: uint256 = new_balances[i]
688         if ideal_balance > new_balance:
689             difference = ideal_balance - new_balance
690         else:
691             difference = new_balance - ideal_balance
692         fees[i] = base_fee * difference / FEE_DENOMINATOR
693         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
694         new_balances[i] -= fees[i]
695     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
696 
697     total_supply: uint256 = self.totalSupply
698     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
699     assert burn_amount > 1  # dev: zero tokens burned
700     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
701 
702     total_supply -= burn_amount
703     self.totalSupply = total_supply
704     self.balanceOf[msg.sender] -= burn_amount
705     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
706     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
707 
708     return burn_amount
709 
710 
711 @pure
712 @internal
713 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
714     """
715     Calculate x[i] if one reduces D from being calculated for xp to D
716 
717     Done by solving quadratic equation iteratively.
718     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
719     x_1**2 + b*x_1 = c
720 
721     x_1 = (x_1**2 + c) / (2*x_1 + b)
722     """
723     # x in the input is converted to the same price/precision
724 
725     assert i >= 0  # dev: i below zero
726     assert i < N_COINS  # dev: i above N_COINS
727 
728     S_: uint256 = 0
729     _x: uint256 = 0
730     y_prev: uint256 = 0
731     c: uint256 = D
732     Ann: uint256 = A * N_COINS
733 
734     for _i in range(N_COINS):
735         if _i != i:
736             _x = xp[_i]
737         else:
738             continue
739         S_ += _x
740         c = c * D / (_x * N_COINS)
741 
742     c = c * D * A_PRECISION / (Ann * N_COINS)
743     b: uint256 = S_ + D * A_PRECISION / Ann
744     y: uint256 = D
745 
746     for _i in range(255):
747         y_prev = y
748         y = (y*y + c) / (2 * y + b - D)
749         # Equality with the precision of 1
750         if y > y_prev:
751             if y - y_prev <= 1:
752                 return y
753         else:
754             if y_prev - y <= 1:
755                 return y
756     raise
757 
758 
759 @view
760 @internal
761 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
762     # First, need to calculate
763     # * Get current D
764     # * Solve Eqn against y_i for D - _token_amount
765     amp: uint256 = self._A()
766     rates: uint256[N_COINS] = self.rate_multipliers
767     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
768     D0: uint256 = self.get_D(xp, amp)
769 
770     total_supply: uint256 = self.totalSupply
771     D1: uint256 = D0 - _burn_amount * D0 / total_supply
772     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
773 
774     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
775     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
776 
777     for j in range(N_COINS):
778         dx_expected: uint256 = 0
779         xp_j: uint256 = xp[j]
780         if j == i:
781             dx_expected = xp_j * D1 / D0 - new_y
782         else:
783             dx_expected = xp_j - xp_j * D1 / D0
784         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
785 
786     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
787     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
788     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
789 
790     return [dy, dy_0 - dy]
791 
792 
793 @view
794 @external
795 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
796     """
797     @notice Calculate the amount received when withdrawing a single coin
798     @param _burn_amount Amount of LP tokens to burn in the withdrawal
799     @param i Index value of the coin to withdraw
800     @return Amount of coin received
801     """
802     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
803 
804 
805 @external
806 @nonreentrant('lock')
807 def remove_liquidity_one_coin(
808     _burn_amount: uint256,
809     i: int128,
810     _min_received: uint256,
811     _receiver: address = msg.sender,
812 ) -> uint256:
813     """
814     @notice Withdraw a single coin from the pool
815     @param _burn_amount Amount of LP tokens to burn in the withdrawal
816     @param i Index value of the coin to withdraw
817     @param _min_received Minimum amount of coin to receive
818     @param _receiver Address that receives the withdrawn coins
819     @return Amount of coin received
820     """
821     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
822     assert dy[0] >= _min_received, "Not enough coins removed"
823 
824     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
825     total_supply: uint256 = self.totalSupply - _burn_amount
826     self.totalSupply = total_supply
827     self.balanceOf[msg.sender] -= _burn_amount
828     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
829 
830     response: Bytes[32] = raw_call(
831         self.coins[i],
832         concat(
833             method_id("transfer(address,uint256)"),
834             convert(_receiver, bytes32),
835             convert(dy[0], bytes32),
836         ),
837         max_outsize=32,
838     )
839     if len(response) > 0:
840         assert convert(response, bool)
841 
842     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
843 
844     return dy[0]
845 
846 
847 @external
848 def ramp_A(_future_A: uint256, _future_time: uint256):
849     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
850     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
851     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
852 
853     _initial_A: uint256 = self._A()
854     _future_A_p: uint256 = _future_A * A_PRECISION
855 
856     assert _future_A > 0 and _future_A < MAX_A
857     if _future_A_p < _initial_A:
858         assert _future_A_p * MAX_A_CHANGE >= _initial_A
859     else:
860         assert _future_A_p <= _initial_A * MAX_A_CHANGE
861 
862     self.initial_A = _initial_A
863     self.future_A = _future_A_p
864     self.initial_A_time = block.timestamp
865     self.future_A_time = _future_time
866 
867     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
868 
869 
870 @external
871 def stop_ramp_A():
872     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
873 
874     current_A: uint256 = self._A()
875     self.initial_A = current_A
876     self.future_A = current_A
877     self.initial_A_time = block.timestamp
878     self.future_A_time = block.timestamp
879     # now (block.timestamp < t1) is always False, so we return saved A
880 
881     log StopRampA(current_A, block.timestamp)
882 
883 
884 @view
885 @external
886 def admin_balances(i: uint256) -> uint256:
887     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
888 
889 
890 @external
891 def withdraw_admin_fees():
892     receiver: address = Factory(self.factory).get_fee_receiver(self)
893 
894     for i in range(N_COINS):
895         coin: address = self.coins[i]
896         fees: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
897         raw_call(
898             coin,
899             concat(
900                 method_id("transfer(address,uint256)"),
901                 convert(receiver, bytes32),
902                 convert(fees, bytes32)
903             )
904         )