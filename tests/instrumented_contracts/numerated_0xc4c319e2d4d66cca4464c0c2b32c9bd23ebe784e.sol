1 # @version 0.2.15
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2021 - all rights reserved
6 @notice 2 coin pool implementation with no lending
7 @dev ERC20 support for return True/revert, return True/False, return None
8      Uses native Ether as coins[0]
9 """
10 
11 from vyper.interfaces import ERC20
12 
13 interface Factory:
14     def convert_fees() -> bool: nonpayable
15     def get_fee_receiver(_pool: address) -> address: view
16     def admin() -> address: view
17 
18 
19 event Transfer:
20     sender: indexed(address)
21     receiver: indexed(address)
22     value: uint256
23 
24 event Approval:
25     owner: indexed(address)
26     spender: indexed(address)
27     value: uint256
28 
29 event TokenExchange:
30     buyer: indexed(address)
31     sold_id: int128
32     tokens_sold: uint256
33     bought_id: int128
34     tokens_bought: uint256
35 
36 event AddLiquidity:
37     provider: indexed(address)
38     token_amounts: uint256[N_COINS]
39     fees: uint256[N_COINS]
40     invariant: uint256
41     token_supply: uint256
42 
43 event RemoveLiquidity:
44     provider: indexed(address)
45     token_amounts: uint256[N_COINS]
46     fees: uint256[N_COINS]
47     token_supply: uint256
48 
49 event RemoveLiquidityOne:
50     provider: indexed(address)
51     token_amount: uint256
52     coin_amount: uint256
53     token_supply: uint256
54 
55 event RemoveLiquidityImbalance:
56     provider: indexed(address)
57     token_amounts: uint256[N_COINS]
58     fees: uint256[N_COINS]
59     invariant: uint256
60     token_supply: uint256
61 
62 event RampA:
63     old_A: uint256
64     new_A: uint256
65     initial_time: uint256
66     future_time: uint256
67 
68 event StopRampA:
69     A: uint256
70     t: uint256
71 
72 
73 N_COINS: constant(int128) = 2
74 PRECISION: constant(uint256) = 10 ** 18
75 
76 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
77 ADMIN_FEE: constant(uint256) = 5000000000
78 
79 A_PRECISION: constant(uint256) = 100
80 MAX_A: constant(uint256) = 10 ** 6
81 MAX_A_CHANGE: constant(uint256) = 10
82 MIN_RAMP_TIME: constant(uint256) = 86400
83 
84 factory: address
85 
86 coins: public(address[N_COINS])
87 balances: public(uint256[N_COINS])
88 fee: public(uint256)  # fee * 1e10
89 
90 initial_A: public(uint256)
91 future_A: public(uint256)
92 initial_A_time: public(uint256)
93 future_A_time: public(uint256)
94 
95 rate_multipliers: uint256[N_COINS]
96 
97 name: public(String[64])
98 symbol: public(String[32])
99 
100 balanceOf: public(HashMap[address, uint256])
101 allowance: public(HashMap[address, HashMap[address, uint256]])
102 totalSupply: public(uint256)
103 
104 
105 @external
106 def __init__():
107     # we do this to prevent the implementation contract from being used as a pool
108     self.fee = 31337
109 
110 
111 @external
112 def initialize(
113     _name: String[32],
114     _symbol: String[10],
115     _coins: address[4],
116     _rate_multipliers: uint256[4],
117     _A: uint256,
118     _fee: uint256,
119 ):
120     """
121     @notice Contract constructor
122     @param _name Name of the new pool
123     @param _symbol Token symbol
124     @param _coins List of all ERC20 conract addresses of coins
125     @param _rate_multipliers List of number of decimals in coins
126     @param _A Amplification coefficient multiplied by n ** (n - 1)
127     @param _fee Fee to charge for exchanges
128     """
129     # check if fee was already set to prevent initializing contract twice
130     assert self.fee == 0
131 
132     # additional sanity checks for ETH configuration
133     assert _coins[0] == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
134     assert _rate_multipliers[0] == 10**18
135 
136     for i in range(N_COINS):
137         coin: address = _coins[i]
138         if coin == ZERO_ADDRESS:
139             break
140         self.coins[i] = coin
141         self.rate_multipliers[i] = _rate_multipliers[i]
142 
143     A: uint256 = _A * A_PRECISION
144     self.initial_A = A
145     self.future_A = A
146     self.fee = _fee
147     self.factory = msg.sender
148 
149     self.name = concat("Curve.fi Factory Pool: ", _name)
150     self.symbol = concat(_symbol, "-f")
151 
152     # fire a transfer event so block explorers identify the contract as an ERC20
153     log Transfer(ZERO_ADDRESS, self, 0)
154 
155 
156 ### ERC20 Functionality ###
157 
158 @view
159 @external
160 def decimals() -> uint256:
161     """
162     @notice Get the number of decimals for this token
163     @dev Implemented as a view method to reduce gas costs
164     @return uint256 decimal places
165     """
166     return 18
167 
168 
169 @internal
170 def _transfer(_from: address, _to: address, _value: uint256):
171     # # NOTE: vyper does not allow underflows
172     # #       so the following subtraction would revert on insufficient balance
173     self.balanceOf[_from] -= _value
174     self.balanceOf[_to] += _value
175 
176     log Transfer(_from, _to, _value)
177 
178 
179 @external
180 def transfer(_to : address, _value : uint256) -> bool:
181     """
182     @dev Transfer token for a specified address
183     @param _to The address to transfer to.
184     @param _value The amount to be transferred.
185     """
186     self._transfer(msg.sender, _to, _value)
187     return True
188 
189 
190 @external
191 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
192     """
193      @dev Transfer tokens from one address to another.
194      @param _from address The address which you want to send tokens from
195      @param _to address The address which you want to transfer to
196      @param _value uint256 the amount of tokens to be transferred
197     """
198     self._transfer(_from, _to, _value)
199 
200     _allowance: uint256 = self.allowance[_from][msg.sender]
201     if _allowance != MAX_UINT256:
202         self.allowance[_from][msg.sender] = _allowance - _value
203 
204     return True
205 
206 
207 @external
208 def approve(_spender : address, _value : uint256) -> bool:
209     """
210     @notice Approve the passed address to transfer the specified amount of
211             tokens on behalf of msg.sender
212     @dev Beware that changing an allowance via this method brings the risk that
213          someone may use both the old and new allowance by unfortunate transaction
214          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215     @param _spender The address which will transfer the funds
216     @param _value The amount of tokens that may be transferred
217     @return bool success
218     """
219     self.allowance[msg.sender][_spender] = _value
220 
221     log Approval(msg.sender, _spender, _value)
222     return True
223 
224 
225 ### StableSwap Functionality ###
226 
227 @view
228 @external
229 def get_balances() -> uint256[N_COINS]:
230     return self.balances
231 
232 
233 @view
234 @internal
235 def _A() -> uint256:
236     """
237     Handle ramping A up or down
238     """
239     t1: uint256 = self.future_A_time
240     A1: uint256 = self.future_A
241 
242     if block.timestamp < t1:
243         A0: uint256 = self.initial_A
244         t0: uint256 = self.initial_A_time
245         # Expressions in uint256 cannot have negative numbers, thus "if"
246         if A1 > A0:
247             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
248         else:
249             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
250 
251     else:  # when t1 == 0 or block.timestamp >= t1
252         return A1
253 
254 
255 @view
256 @external
257 def admin_fee() -> uint256:
258     return ADMIN_FEE
259 
260 
261 @view
262 @external
263 def A() -> uint256:
264     return self._A() / A_PRECISION
265 
266 
267 @view
268 @external
269 def A_precise() -> uint256:
270     return self._A()
271 
272 
273 @pure
274 @internal
275 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
276     result: uint256[N_COINS] = empty(uint256[N_COINS])
277     for i in range(N_COINS):
278         result[i] = _rates[i] * _balances[i] / PRECISION
279     return result
280 
281 
282 @pure
283 @internal
284 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
285     """
286     D invariant calculation in non-overflowing integer operations
287     iteratively
288 
289     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
290 
291     Converging solution:
292     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
293     """
294     S: uint256 = 0
295     for x in _xp:
296         S += x
297     if S == 0:
298         return 0
299 
300     D: uint256 = S
301     Ann: uint256 = _amp * N_COINS
302     for i in range(255):
303         D_P: uint256 = D * D / _xp[0] * D / _xp[1] / (N_COINS)**2
304         Dprev: uint256 = D
305         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
306         # Equality with the precision of 1
307         if D > Dprev:
308             if D - Dprev <= 1:
309                 return D
310         else:
311             if Dprev - D <= 1:
312                 return D
313     # convergence typically occurs in 4 rounds or less, this should be unreachable!
314     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
315     raise
316 
317 
318 @view
319 @internal
320 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
321     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
322     return self.get_D(xp, _amp)
323 
324 
325 @view
326 @external
327 def get_virtual_price() -> uint256:
328     """
329     @notice The current virtual price of the pool LP token
330     @dev Useful for calculating profits
331     @return LP token virtual price normalized to 1e18
332     """
333     amp: uint256 = self._A()
334     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, self.balances)
335     D: uint256 = self.get_D(xp, amp)
336     # D is in the units similar to DAI (e.g. converted to precision 1e18)
337     # When balanced, D = n * x_u - total virtual value of the portfolio
338     return D * PRECISION / self.totalSupply
339 
340 
341 @view
342 @external
343 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
344     """
345     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
346     @dev This calculation accounts for slippage, but not fees.
347          Needed to prevent front-running, not for precise calculations!
348     @param _amounts Amount of each coin being deposited
349     @param _is_deposit set True for deposits, False for withdrawals
350     @return Expected amount of LP tokens received
351     """
352     amp: uint256 = self._A()
353     balances: uint256[N_COINS] = self.balances
354 
355     D0: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
356     for i in range(N_COINS):
357         amount: uint256 = _amounts[i]
358         if _is_deposit:
359             balances[i] += amount
360         else:
361             balances[i] -= amount
362     D1: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
363     diff: uint256 = 0
364     if _is_deposit:
365         diff = D1 - D0
366     else:
367         diff = D0 - D1
368     return diff * self.totalSupply / D0
369 
370 
371 @payable
372 @external
373 @nonreentrant('lock')
374 def add_liquidity(
375     _amounts: uint256[N_COINS],
376     _min_mint_amount: uint256,
377     _receiver: address = msg.sender
378 ) -> uint256:
379     """
380     @notice Deposit coins into the pool
381     @param _amounts List of amounts of coins to deposit
382     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
383     @param _receiver Address that owns the minted LP tokens
384     @return Amount of LP tokens received by depositing
385     """
386     amp: uint256 = self._A()
387     old_balances: uint256[N_COINS] = self.balances
388     rates: uint256[N_COINS] = self.rate_multipliers
389 
390     # Initial invariant
391     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
392 
393     total_supply: uint256 = self.totalSupply
394     new_balances: uint256[N_COINS] = old_balances
395     for i in range(N_COINS):
396         amount: uint256 = _amounts[i]
397         if total_supply == 0:
398             assert amount > 0  # dev: initial deposit requires all coins
399         new_balances[i] += amount
400 
401     # Invariant after change
402     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
403     assert D1 > D0
404 
405     # We need to recalculate the invariant accounting for fees
406     # to calculate fair user's share
407     fees: uint256[N_COINS] = empty(uint256[N_COINS])
408     mint_amount: uint256 = 0
409     if total_supply > 0:
410         # Only account for fees if we are not the first to deposit
411         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
412         for i in range(N_COINS):
413             ideal_balance: uint256 = D1 * old_balances[i] / D0
414             difference: uint256 = 0
415             new_balance: uint256 = new_balances[i]
416             if ideal_balance > new_balance:
417                 difference = ideal_balance - new_balance
418             else:
419                 difference = new_balance - ideal_balance
420             fees[i] = base_fee * difference / FEE_DENOMINATOR
421             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
422             new_balances[i] -= fees[i]
423         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
424         mint_amount = total_supply * (D2 - D0) / D0
425     else:
426         self.balances = new_balances
427         mint_amount = D1  # Take the dust if there was any
428 
429     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
430 
431     # Take coins from the sender
432     assert msg.value == _amounts[0]
433     if _amounts[1] > 0:
434         response: Bytes[32] = raw_call(
435             self.coins[1],
436             concat(
437                 method_id("transferFrom(address,address,uint256)"),
438                 convert(msg.sender, bytes32),
439                 convert(self, bytes32),
440                 convert(_amounts[1], bytes32),
441             ),
442             max_outsize=32,
443         )
444         if len(response) > 0:
445             assert convert(response, bool)  # dev: failed transfer
446         # end "safeTransferFrom"
447 
448     # Mint pool tokens
449     total_supply += mint_amount
450     self.balanceOf[_receiver] += mint_amount
451     self.totalSupply = total_supply
452     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
453 
454     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
455 
456     return mint_amount
457 
458 
459 @view
460 @internal
461 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
462     """
463     Calculate x[j] if one makes x[i] = x
464 
465     Done by solving quadratic equation iteratively.
466     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
467     x_1**2 + b*x_1 = c
468 
469     x_1 = (x_1**2 + c) / (2*x_1 + b)
470     """
471     # x in the input is converted to the same price/precision
472 
473     assert i != j       # dev: same coin
474     assert j >= 0       # dev: j below zero
475     assert j < N_COINS  # dev: j above N_COINS
476 
477     # should be unreachable, but good for safety
478     assert i >= 0
479     assert i < N_COINS
480 
481     amp: uint256 = self._A()
482     D: uint256 = self.get_D(xp, amp)
483     S_: uint256 = 0
484     _x: uint256 = 0
485     y_prev: uint256 = 0
486     c: uint256 = D
487     Ann: uint256 = amp * N_COINS
488 
489     for _i in range(N_COINS):
490         if _i == i:
491             _x = x
492         elif _i != j:
493             _x = xp[_i]
494         else:
495             continue
496         S_ += _x
497         c = c * D / (_x * N_COINS)
498 
499     c = c * D * A_PRECISION / (Ann * N_COINS)
500     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
501     y: uint256 = D
502 
503     for _i in range(255):
504         y_prev = y
505         y = (y*y + c) / (2 * y + b - D)
506         # Equality with the precision of 1
507         if y > y_prev:
508             if y - y_prev <= 1:
509                 return y
510         else:
511             if y_prev - y <= 1:
512                 return y
513     raise
514 
515 
516 @view
517 @external
518 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
519     """
520     @notice Calculate the current output dy given input dx
521     @dev Index values can be found via the `coins` public getter method
522     @param i Index value for the coin to send
523     @param j Index valie of the coin to recieve
524     @param dx Amount of `i` being exchanged
525     @return Amount of `j` predicted
526     """
527     rates: uint256[N_COINS] = self.rate_multipliers
528     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
529 
530     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
531     y: uint256 = self.get_y(i, j, x, xp)
532     dy: uint256 = xp[j] - y - 1
533     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
534     return (dy - fee) * PRECISION / rates[j]
535 
536 
537 @payable
538 @external
539 @nonreentrant('lock')
540 def exchange(
541     i: int128,
542     j: int128,
543     _dx: uint256,
544     _min_dy: uint256,
545     _receiver: address = msg.sender,
546 ) -> uint256:
547     """
548     @notice Perform an exchange between two coins
549     @dev Index values can be found via the `coins` public getter method
550     @param i Index value for the coin to send
551     @param j Index valie of the coin to recieve
552     @param _dx Amount of `i` being exchanged
553     @param _min_dy Minimum amount of `j` to receive
554     @return Actual amount of `j` received
555     """
556     rates: uint256[N_COINS] = self.rate_multipliers
557     old_balances: uint256[N_COINS] = self.balances
558     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
559 
560     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
561     y: uint256 = self.get_y(i, j, x, xp)
562 
563     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
564     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
565 
566     # Convert all to real units
567     dy = (dy - dy_fee) * PRECISION / rates[j]
568     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
569 
570     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
571     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
572 
573     # Change balances exactly in same way as we change actual ERC20 coin amounts
574     self.balances[i] = old_balances[i] + _dx
575     # When rounding errors happen, we undercharge admin fee in favor of LP
576     self.balances[j] = old_balances[j] - dy - dy_admin_fee
577 
578     coin: address = self.coins[1]
579     if i == 0:
580         assert msg.value == _dx
581         response: Bytes[32] = raw_call(
582             coin,
583             concat(
584                 method_id("transfer(address,uint256)"),
585                 convert(_receiver, bytes32),
586                 convert(dy, bytes32),
587             ),
588             max_outsize=32,
589         )
590         if len(response) > 0:
591             assert convert(response, bool)
592     else:
593         assert msg.value == 0
594         response: Bytes[32] = raw_call(
595             coin,
596             concat(
597                 method_id("transferFrom(address,address,uint256)"),
598                 convert(msg.sender, bytes32),
599                 convert(self, bytes32),
600                 convert(_dx, bytes32),
601             ),
602             max_outsize=32,
603         )
604         if len(response) > 0:
605             assert convert(response, bool)
606         raw_call(_receiver, b"", value=dy)
607 
608     log TokenExchange(msg.sender, i, _dx, j, dy)
609 
610     return dy
611 
612 
613 @external
614 @nonreentrant('lock')
615 def remove_liquidity(
616     _burn_amount: uint256,
617     _min_amounts: uint256[N_COINS],
618     _receiver: address = msg.sender
619 ) -> uint256[N_COINS]:
620     """
621     @notice Withdraw coins from the pool
622     @dev Withdrawal amounts are based on current deposit ratios
623     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
624     @param _min_amounts Minimum amounts of underlying coins to receive
625     @param _receiver Address that receives the withdrawn coins
626     @return List of amounts of coins that were withdrawn
627     """
628     total_supply: uint256 = self.totalSupply
629     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
630 
631     for i in range(N_COINS):
632         old_balance: uint256 = self.balances[i]
633         value: uint256 = old_balance * _burn_amount / total_supply
634         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
635         self.balances[i] = old_balance - value
636         amounts[i] = value
637 
638         if i == 0:
639             raw_call(_receiver, b"", value=value)
640         else:
641             response: Bytes[32] = raw_call(
642                 self.coins[1],
643                 concat(
644                     method_id("transfer(address,uint256)"),
645                     convert(_receiver, bytes32),
646                     convert(value, bytes32),
647                 ),
648                 max_outsize=32,
649             )
650             if len(response) > 0:
651                 assert convert(response, bool)
652 
653     total_supply -= _burn_amount
654     self.balanceOf[msg.sender] -= _burn_amount
655     self.totalSupply = total_supply
656     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
657 
658     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
659 
660     return amounts
661 
662 
663 @external
664 @nonreentrant('lock')
665 def remove_liquidity_imbalance(
666     _amounts: uint256[N_COINS],
667     _max_burn_amount: uint256,
668     _receiver: address = msg.sender
669 ) -> uint256:
670     """
671     @notice Withdraw coins from the pool in an imbalanced amount
672     @param _amounts List of amounts of underlying coins to withdraw
673     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
674     @param _receiver Address that receives the withdrawn coins
675     @return Actual amount of the LP token burned in the withdrawal
676     """
677     amp: uint256 = self._A()
678     rates: uint256[N_COINS] = self.rate_multipliers
679     old_balances: uint256[N_COINS] = self.balances
680     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
681 
682     new_balances: uint256[N_COINS] = old_balances
683     for i in range(N_COINS):
684         new_balances[i] -= _amounts[i]
685     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
686 
687     fees: uint256[N_COINS] = empty(uint256[N_COINS])
688     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
689     for i in range(N_COINS):
690         ideal_balance: uint256 = D1 * old_balances[i] / D0
691         difference: uint256 = 0
692         new_balance: uint256 = new_balances[i]
693         if ideal_balance > new_balance:
694             difference = ideal_balance - new_balance
695         else:
696             difference = new_balance - ideal_balance
697         fees[i] = base_fee * difference / FEE_DENOMINATOR
698         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
699         new_balances[i] -= fees[i]
700     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
701 
702     total_supply: uint256 = self.totalSupply
703     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
704     assert burn_amount > 1  # dev: zero tokens burned
705     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
706 
707     total_supply -= burn_amount
708     self.totalSupply = total_supply
709     self.balanceOf[msg.sender] -= burn_amount
710     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
711 
712     if _amounts[0] != 0:
713         raw_call(_receiver, b"", value=_amounts[0])
714     if _amounts[1] != 0:
715         response: Bytes[32] = raw_call(
716             self.coins[1],
717             concat(
718                 method_id("transfer(address,uint256)"),
719                 convert(_receiver, bytes32),
720                 convert(_amounts[1], bytes32),
721             ),
722             max_outsize=32,
723         )
724         if len(response) > 0:
725             assert convert(response, bool)
726 
727     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
728 
729     return burn_amount
730 
731 
732 @pure
733 @internal
734 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
735     """
736     Calculate x[i] if one reduces D from being calculated for xp to D
737 
738     Done by solving quadratic equation iteratively.
739     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
740     x_1**2 + b*x_1 = c
741 
742     x_1 = (x_1**2 + c) / (2*x_1 + b)
743     """
744     # x in the input is converted to the same price/precision
745 
746     assert i >= 0  # dev: i below zero
747     assert i < N_COINS  # dev: i above N_COINS
748 
749     S_: uint256 = 0
750     _x: uint256 = 0
751     y_prev: uint256 = 0
752     c: uint256 = D
753     Ann: uint256 = A * N_COINS
754 
755     for _i in range(N_COINS):
756         if _i != i:
757             _x = xp[_i]
758         else:
759             continue
760         S_ += _x
761         c = c * D / (_x * N_COINS)
762 
763     c = c * D * A_PRECISION / (Ann * N_COINS)
764     b: uint256 = S_ + D * A_PRECISION / Ann
765     y: uint256 = D
766 
767     for _i in range(255):
768         y_prev = y
769         y = (y*y + c) / (2 * y + b - D)
770         # Equality with the precision of 1
771         if y > y_prev:
772             if y - y_prev <= 1:
773                 return y
774         else:
775             if y_prev - y <= 1:
776                 return y
777     raise
778 
779 
780 @view
781 @internal
782 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
783     # First, need to calculate
784     # * Get current D
785     # * Solve Eqn against y_i for D - _token_amount
786     amp: uint256 = self._A()
787     rates: uint256[N_COINS] = self.rate_multipliers
788     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
789     D0: uint256 = self.get_D(xp, amp)
790 
791     total_supply: uint256 = self.totalSupply
792     D1: uint256 = D0 - _burn_amount * D0 / total_supply
793     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
794 
795     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
796     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
797 
798     for j in range(N_COINS):
799         dx_expected: uint256 = 0
800         xp_j: uint256 = xp[j]
801         if j == i:
802             dx_expected = xp_j * D1 / D0 - new_y
803         else:
804             dx_expected = xp_j - xp_j * D1 / D0
805         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
806 
807     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
808     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
809     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
810 
811     return [dy, dy_0 - dy]
812 
813 
814 @view
815 @external
816 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
817     """
818     @notice Calculate the amount received when withdrawing a single coin
819     @param _burn_amount Amount of LP tokens to burn in the withdrawal
820     @param i Index value of the coin to withdraw
821     @return Amount of coin received
822     """
823     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
824 
825 
826 @external
827 @nonreentrant('lock')
828 def remove_liquidity_one_coin(
829     _burn_amount: uint256,
830     i: int128,
831     _min_received: uint256,
832     _receiver: address = msg.sender,
833 ) -> uint256:
834     """
835     @notice Withdraw a single coin from the pool
836     @param _burn_amount Amount of LP tokens to burn in the withdrawal
837     @param i Index value of the coin to withdraw
838     @param _min_received Minimum amount of coin to receive
839     @param _receiver Address that receives the withdrawn coins
840     @return Amount of coin received
841     """
842     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
843     assert dy[0] >= _min_received, "Not enough coins removed"
844 
845     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
846     total_supply: uint256 = self.totalSupply - _burn_amount
847     self.totalSupply = total_supply
848     self.balanceOf[msg.sender] -= _burn_amount
849     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
850 
851     if i == 0:
852         raw_call(_receiver, b"", value=dy[0])
853     else:
854         response: Bytes[32] = raw_call(
855             self.coins[1],
856             concat(
857                 method_id("transfer(address,uint256)"),
858                 convert(_receiver, bytes32),
859                 convert(dy[0], bytes32),
860             ),
861             max_outsize=32,
862         )
863         if len(response) > 0:
864             assert convert(response, bool)
865 
866     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
867 
868     return dy[0]
869 
870 
871 @external
872 def ramp_A(_future_A: uint256, _future_time: uint256):
873     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
874     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
875     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
876 
877     _initial_A: uint256 = self._A()
878     _future_A_p: uint256 = _future_A * A_PRECISION
879 
880     assert _future_A > 0 and _future_A < MAX_A
881     if _future_A_p < _initial_A:
882         assert _future_A_p * MAX_A_CHANGE >= _initial_A
883     else:
884         assert _future_A_p <= _initial_A * MAX_A_CHANGE
885 
886     self.initial_A = _initial_A
887     self.future_A = _future_A_p
888     self.initial_A_time = block.timestamp
889     self.future_A_time = _future_time
890 
891     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
892 
893 
894 @external
895 def stop_ramp_A():
896     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
897 
898     current_A: uint256 = self._A()
899     self.initial_A = current_A
900     self.future_A = current_A
901     self.initial_A_time = block.timestamp
902     self.future_A_time = block.timestamp
903     # now (block.timestamp < t1) is always False, so we return saved A
904 
905     log StopRampA(current_A, block.timestamp)
906 
907 
908 @view
909 @external
910 def admin_balances(i: uint256) -> uint256:
911     if i == 0:
912         return self.balance - self.balances[0]
913     else:
914         return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
915 
916 
917 @external
918 def withdraw_admin_fees():
919     receiver: address = Factory(self.factory).get_fee_receiver(self)
920 
921     fees: uint256 = self.balance - self.balances[0]
922     raw_call(receiver, b"", value=fees)
923 
924     coin: address = self.coins[1]
925     fees = ERC20(coin).balanceOf(self) - self.balances[1]
926     raw_call(
927     coin,
928     concat(
929         method_id("transfer(address,uint256)"),
930         convert(receiver, bytes32),
931         convert(fees, bytes32)
932     )
933 )