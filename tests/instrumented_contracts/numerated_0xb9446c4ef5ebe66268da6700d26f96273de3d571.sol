1 # @version 0.2.15
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2021 - all rights reserved
6 @notice 3 coin pool implementation with no lending
7 @dev ERC20 support for return True/revert, return True/False, return None
8      Support for positive-rebasing and fee-on-transfer tokens
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
73 N_COINS: constant(int128) = 3
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
87 admin_balances: public(uint256[N_COINS])
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
132     for i in range(N_COINS):
133         coin: address = _coins[i]
134         if coin == ZERO_ADDRESS:
135             break
136         self.coins[i] = coin
137         self.rate_multipliers[i] = _rate_multipliers[i]
138 
139     A: uint256 = _A * A_PRECISION
140     self.initial_A = A
141     self.future_A = A
142     self.fee = _fee
143     self.factory = msg.sender
144 
145     self.name = concat("Curve.fi Factory Plain Pool: ", _name)
146     self.symbol = concat(_symbol, "-f")
147 
148     # fire a transfer event so block explorers identify the contract as an ERC20
149     log Transfer(ZERO_ADDRESS, self, 0)
150 
151 
152 ### ERC20 Functionality ###
153 
154 @view
155 @external
156 def decimals() -> uint256:
157     """
158     @notice Get the number of decimals for this token
159     @dev Implemented as a view method to reduce gas costs
160     @return uint256 decimal places
161     """
162     return 18
163 
164 
165 @internal
166 def _transfer(_from: address, _to: address, _value: uint256):
167     # # NOTE: vyper does not allow underflows
168     # #       so the following subtraction would revert on insufficient balance
169     self.balanceOf[_from] -= _value
170     self.balanceOf[_to] += _value
171 
172     log Transfer(_from, _to, _value)
173 
174 
175 @external
176 def transfer(_to : address, _value : uint256) -> bool:
177     """
178     @dev Transfer token for a specified address
179     @param _to The address to transfer to.
180     @param _value The amount to be transferred.
181     """
182     self._transfer(msg.sender, _to, _value)
183     return True
184 
185 
186 @external
187 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
188     """
189      @dev Transfer tokens from one address to another.
190      @param _from address The address which you want to send tokens from
191      @param _to address The address which you want to transfer to
192      @param _value uint256 the amount of tokens to be transferred
193     """
194     self._transfer(_from, _to, _value)
195 
196     _allowance: uint256 = self.allowance[_from][msg.sender]
197     if _allowance != MAX_UINT256:
198         self.allowance[_from][msg.sender] = _allowance - _value
199 
200     return True
201 
202 
203 @external
204 def approve(_spender : address, _value : uint256) -> bool:
205     """
206     @notice Approve the passed address to transfer the specified amount of
207             tokens on behalf of msg.sender
208     @dev Beware that changing an allowance via this method brings the risk that
209          someone may use both the old and new allowance by unfortunate transaction
210          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211     @param _spender The address which will transfer the funds
212     @param _value The amount of tokens that may be transferred
213     @return bool success
214     """
215     self.allowance[msg.sender][_spender] = _value
216 
217     log Approval(msg.sender, _spender, _value)
218     return True
219 
220 
221 ### StableSwap Functionality ###
222 
223 @view
224 @internal
225 def _balances() -> uint256[N_COINS]:
226     result: uint256[N_COINS] = empty(uint256[N_COINS])
227     for i in range(N_COINS):
228         result[i] = ERC20(self.coins[i]).balanceOf(self) - self.admin_balances[i]
229     return result
230 
231 
232 @view
233 @external
234 def balances(i: uint256) -> uint256:
235     """
236     @notice Get the current balance of a coin within the
237             pool, less the accrued admin fees
238     @param i Index value for the coin to query balance of
239     @return Token balance
240     """
241     return self._balances()[i]
242 
243 
244 @view
245 @external
246 def get_balances() -> uint256[N_COINS]:
247     return self._balances()
248 
249 
250 @view
251 @internal
252 def _A() -> uint256:
253     """
254     Handle ramping A up or down
255     """
256     t1: uint256 = self.future_A_time
257     A1: uint256 = self.future_A
258 
259     if block.timestamp < t1:
260         A0: uint256 = self.initial_A
261         t0: uint256 = self.initial_A_time
262         # Expressions in uint256 cannot have negative numbers, thus "if"
263         if A1 > A0:
264             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
265         else:
266             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
267 
268     else:  # when t1 == 0 or block.timestamp >= t1
269         return A1
270 
271 
272 @view
273 @external
274 def admin_fee() -> uint256:
275     return ADMIN_FEE
276 
277 
278 @view
279 @external
280 def A() -> uint256:
281     return self._A() / A_PRECISION
282 
283 
284 @view
285 @external
286 def A_precise() -> uint256:
287     return self._A()
288 
289 
290 @pure
291 @internal
292 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
293     result: uint256[N_COINS] = empty(uint256[N_COINS])
294     for i in range(N_COINS):
295         result[i] = _rates[i] * _balances[i] / PRECISION
296     return result
297 
298 
299 @pure
300 @internal
301 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
302     """
303     D invariant calculation in non-overflowing integer operations
304     iteratively
305 
306     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
307 
308     Converging solution:
309     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
310     """
311     S: uint256 = 0
312     Dprev: uint256 = 0
313     for x in _xp:
314         S += x
315     if S == 0:
316         return 0
317 
318     D: uint256 = S
319     Ann: uint256 = _amp * N_COINS
320     for i in range(255):
321         D_P: uint256 = D
322         for x in _xp:
323             D_P = D_P * D / (x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
324         Dprev = D
325         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
326         # Equality with the precision of 1
327         if D > Dprev:
328             if D - Dprev <= 1:
329                 return D
330         else:
331             if Dprev - D <= 1:
332                 return D
333     # convergence typically occurs in 4 rounds or less, this should be unreachable!
334     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
335     raise
336 
337 
338 @view
339 @internal
340 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
341     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
342     return self.get_D(xp, _amp)
343 
344 
345 @view
346 @external
347 def get_virtual_price() -> uint256:
348     """
349     @notice The current virtual price of the pool LP token
350     @dev Useful for calculating profits
351     @return LP token virtual price normalized to 1e18
352     """
353     amp: uint256 = self._A()
354     balances: uint256[N_COINS] = self._balances()
355     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, balances)
356     D: uint256 = self.get_D(xp, amp)
357     # D is in the units similar to DAI (e.g. converted to precision 1e18)
358     # When balanced, D = n * x_u - total virtual value of the portfolio
359     return D * PRECISION / self.totalSupply
360 
361 
362 @view
363 @external
364 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
365     """
366     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
367     @dev This calculation accounts for slippage, but not fees.
368          Needed to prevent front-running, not for precise calculations!
369     @param _amounts Amount of each coin being deposited
370     @param _is_deposit set True for deposits, False for withdrawals
371     @return Expected amount of LP tokens received
372     """
373     amp: uint256 = self._A()
374     balances: uint256[N_COINS] = self._balances()
375 
376     D0: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
377     for i in range(N_COINS):
378         amount: uint256 = _amounts[i]
379         if _is_deposit:
380             balances[i] += amount
381         else:
382             balances[i] -= amount
383     D1: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
384     diff: uint256 = 0
385     if _is_deposit:
386         diff = D1 - D0
387     else:
388         diff = D0 - D1
389     return diff * self.totalSupply / D0
390 
391 
392 @external
393 @nonreentrant('lock')
394 def add_liquidity(
395     _amounts: uint256[N_COINS],
396     _min_mint_amount: uint256,
397     _receiver: address = msg.sender
398 ) -> uint256:
399     """
400     @notice Deposit coins into the pool
401     @param _amounts List of amounts of coins to deposit
402     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
403     @param _receiver Address that owns the minted LP tokens
404     @return Amount of LP tokens received by depositing
405     """
406     amp: uint256 = self._A()
407     old_balances: uint256[N_COINS] = self._balances()
408     rates: uint256[N_COINS] = self.rate_multipliers
409 
410     # Initial invariant
411     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
412 
413     total_supply: uint256 = self.totalSupply
414     new_balances: uint256[N_COINS] = old_balances
415     for i in range(N_COINS):
416         amount: uint256 = _amounts[i]
417         if amount > 0:
418             coin: address = self.coins[i]
419             initial: uint256 = ERC20(coin).balanceOf(self)
420             response: Bytes[32] = raw_call(
421                 coin,
422                 concat(
423                     method_id("transferFrom(address,address,uint256)"),
424                     convert(msg.sender, bytes32),
425                     convert(self, bytes32),
426                     convert(amount, bytes32),
427                 ),
428                 max_outsize=32,
429             )
430             if len(response) > 0:
431                 assert convert(response, bool)  # dev: failed transfer
432             new_balances[i] += ERC20(coin).balanceOf(self) - initial
433         else:
434             assert total_supply != 0  # dev: initial deposit requires all coins
435 
436     # Invariant after change
437     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
438     assert D1 > D0
439 
440     # We need to recalculate the invariant accounting for fees
441     # to calculate fair user's share
442     fees: uint256[N_COINS] = empty(uint256[N_COINS])
443     mint_amount: uint256 = 0
444     if total_supply > 0:
445         # Only account for fees if we are not the first to deposit
446         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
447         for i in range(N_COINS):
448             ideal_balance: uint256 = D1 * old_balances[i] / D0
449             difference: uint256 = 0
450             new_balance: uint256 = new_balances[i]
451             if ideal_balance > new_balance:
452                 difference = ideal_balance - new_balance
453             else:
454                 difference = new_balance - ideal_balance
455             fees[i] = base_fee * difference / FEE_DENOMINATOR
456             self.admin_balances[i] += fees[i] * ADMIN_FEE / FEE_DENOMINATOR
457             new_balances[i] -= fees[i]
458         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
459         mint_amount = total_supply * (D2 - D0) / D0
460     else:
461         mint_amount = D1  # Take the dust if there was any
462 
463     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
464 
465     # Mint pool tokens
466     total_supply += mint_amount
467     self.balanceOf[_receiver] += mint_amount
468     self.totalSupply = total_supply
469     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
470 
471     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
472 
473     return mint_amount
474 
475 
476 @view
477 @internal
478 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
479     """
480     Calculate x[j] if one makes x[i] = x
481 
482     Done by solving quadratic equation iteratively.
483     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
484     x_1**2 + b*x_1 = c
485 
486     x_1 = (x_1**2 + c) / (2*x_1 + b)
487     """
488     # x in the input is converted to the same price/precision
489 
490     assert i != j       # dev: same coin
491     assert j >= 0       # dev: j below zero
492     assert j < N_COINS  # dev: j above N_COINS
493 
494     # should be unreachable, but good for safety
495     assert i >= 0
496     assert i < N_COINS
497 
498     amp: uint256 = self._A()
499     D: uint256 = self.get_D(xp, amp)
500     S_: uint256 = 0
501     _x: uint256 = 0
502     y_prev: uint256 = 0
503     c: uint256 = D
504     Ann: uint256 = amp * N_COINS
505 
506     for _i in range(N_COINS):
507         if _i == i:
508             _x = x
509         elif _i != j:
510             _x = xp[_i]
511         else:
512             continue
513         S_ += _x
514         c = c * D / (_x * N_COINS)
515 
516     c = c * D * A_PRECISION / (Ann * N_COINS)
517     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
518     y: uint256 = D
519 
520     for _i in range(255):
521         y_prev = y
522         y = (y*y + c) / (2 * y + b - D)
523         # Equality with the precision of 1
524         if y > y_prev:
525             if y - y_prev <= 1:
526                 return y
527         else:
528             if y_prev - y <= 1:
529                 return y
530     raise
531 
532 
533 @view
534 @external
535 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
536     """
537     @notice Calculate the current output dy given input dx
538     @dev Index values can be found via the `coins` public getter method
539     @param i Index value for the coin to send
540     @param j Index valie of the coin to recieve
541     @param dx Amount of `i` being exchanged
542     @return Amount of `j` predicted
543     """
544     rates: uint256[N_COINS] = self.rate_multipliers
545     xp: uint256[N_COINS] = self._xp_mem(rates, self._balances())
546 
547     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
548     y: uint256 = self.get_y(i, j, x, xp)
549     dy: uint256 = xp[j] - y - 1
550     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
551     return (dy - fee) * PRECISION / rates[j]
552 
553 
554 @external
555 @nonreentrant('lock')
556 def exchange(
557     i: int128,
558     j: int128,
559     _dx: uint256,
560     _min_dy: uint256,
561     _receiver: address = msg.sender,
562 ) -> uint256:
563     """
564     @notice Perform an exchange between two coins
565     @dev Index values can be found via the `coins` public getter method
566     @param i Index value for the coin to send
567     @param j Index valie of the coin to recieve
568     @param _dx Amount of `i` being exchanged
569     @param _min_dy Minimum amount of `j` to receive
570     @return Actual amount of `j` received
571     """
572     rates: uint256[N_COINS] = self.rate_multipliers
573     old_balances: uint256[N_COINS] = self._balances()
574     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
575 
576     coin: address = self.coins[i]
577     dx: uint256 = ERC20(coin).balanceOf(self)
578     response: Bytes[32] = raw_call(
579         coin,
580         concat(
581             method_id("transferFrom(address,address,uint256)"),
582             convert(msg.sender, bytes32),
583             convert(self, bytes32),
584             convert(_dx, bytes32),
585         ),
586         max_outsize=32,
587     )
588     if len(response) > 0:
589         assert convert(response, bool)
590     dx = ERC20(coin).balanceOf(self) - dx
591 
592     x: uint256 = xp[i] + dx * rates[i] / PRECISION
593     y: uint256 = self.get_y(i, j, x, xp)
594 
595     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
596     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
597 
598     # Convert all to real units
599     dy = (dy - dy_fee) * PRECISION / rates[j]
600     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
601 
602     self.admin_balances[j] += (dy_fee * ADMIN_FEE / FEE_DENOMINATOR) * PRECISION / rates[j]
603 
604     response = raw_call(
605         self.coins[j],
606         concat(
607             method_id("transfer(address,uint256)"),
608             convert(_receiver, bytes32),
609             convert(dy, bytes32),
610         ),
611         max_outsize=32,
612     )
613     if len(response) > 0:
614         assert convert(response, bool)
615 
616     log TokenExchange(msg.sender, i, _dx, j, dy)
617 
618     return dy
619 
620 
621 @external
622 @nonreentrant('lock')
623 def remove_liquidity(
624     _burn_amount: uint256,
625     _min_amounts: uint256[N_COINS],
626     _receiver: address = msg.sender
627 ) -> uint256[N_COINS]:
628     """
629     @notice Withdraw coins from the pool
630     @dev Withdrawal amounts are based on current deposit ratios
631     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
632     @param _min_amounts Minimum amounts of underlying coins to receive
633     @param _receiver Address that receives the withdrawn coins
634     @return List of amounts of coins that were withdrawn
635     """
636     total_supply: uint256 = self.totalSupply
637     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
638     balances: uint256[N_COINS] = self._balances()
639 
640     for i in range(N_COINS):
641         value: uint256 = balances[i] * _burn_amount / total_supply
642         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
643         amounts[i] = value
644 
645         response: Bytes[32] = raw_call(
646             self.coins[i],
647             concat(
648                 method_id("transfer(address,uint256)"),
649                 convert(_receiver, bytes32),
650                 convert(value, bytes32),
651             ),
652             max_outsize=32,
653         )
654         if len(response) > 0:
655             assert convert(response, bool)
656 
657     total_supply -= _burn_amount
658     self.balanceOf[msg.sender] -= _burn_amount
659     self.totalSupply = total_supply
660     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
661 
662     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
663 
664     return amounts
665 
666 
667 @external
668 @nonreentrant('lock')
669 def remove_liquidity_imbalance(
670     _amounts: uint256[N_COINS],
671     _max_burn_amount: uint256,
672     _receiver: address = msg.sender
673 ) -> uint256:
674     """
675     @notice Withdraw coins from the pool in an imbalanced amount
676     @param _amounts List of amounts of underlying coins to withdraw
677     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
678     @param _receiver Address that receives the withdrawn coins
679     @return Actual amount of the LP token burned in the withdrawal
680     """
681     amp: uint256 = self._A()
682     old_balances: uint256[N_COINS] = self._balances()
683     rates: uint256[N_COINS] = self.rate_multipliers
684     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
685 
686     new_balances: uint256[N_COINS] = old_balances
687     for i in range(N_COINS):
688         amount: uint256 = _amounts[i]
689         if amount != 0:
690             new_balances[i] -= amount
691             response: Bytes[32] = raw_call(
692                 self.coins[i],
693                 concat(
694                     method_id("transfer(address,uint256)"),
695                     convert(_receiver, bytes32),
696                     convert(amount, bytes32),
697                 ),
698                 max_outsize=32,
699             )
700             if len(response) > 0:
701                 assert convert(response, bool)
702     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
703 
704     fees: uint256[N_COINS] = empty(uint256[N_COINS])
705     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
706     for i in range(N_COINS):
707         ideal_balance: uint256 = D1 * old_balances[i] / D0
708         difference: uint256 = 0
709         new_balance: uint256 = new_balances[i]
710         if ideal_balance > new_balance:
711             difference = ideal_balance - new_balance
712         else:
713             difference = new_balance - ideal_balance
714         fees[i] = base_fee * difference / FEE_DENOMINATOR
715         self.admin_balances[i] += fees[i] * ADMIN_FEE / FEE_DENOMINATOR
716         new_balances[i] -= fees[i]
717     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
718 
719     total_supply: uint256 = self.totalSupply
720     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
721     assert burn_amount > 1  # dev: zero tokens burned
722     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
723 
724     total_supply -= burn_amount
725     self.totalSupply = total_supply
726     self.balanceOf[msg.sender] -= burn_amount
727     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
728     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
729 
730     return burn_amount
731 
732 
733 @pure
734 @internal
735 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
736     """
737     Calculate x[i] if one reduces D from being calculated for xp to D
738 
739     Done by solving quadratic equation iteratively.
740     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
741     x_1**2 + b*x_1 = c
742 
743     x_1 = (x_1**2 + c) / (2*x_1 + b)
744     """
745     # x in the input is converted to the same price/precision
746 
747     assert i >= 0  # dev: i below zero
748     assert i < N_COINS  # dev: i above N_COINS
749 
750     S_: uint256 = 0
751     _x: uint256 = 0
752     y_prev: uint256 = 0
753     c: uint256 = D
754     Ann: uint256 = A * N_COINS
755 
756     for _i in range(N_COINS):
757         if _i != i:
758             _x = xp[_i]
759         else:
760             continue
761         S_ += _x
762         c = c * D / (_x * N_COINS)
763 
764     c = c * D * A_PRECISION / (Ann * N_COINS)
765     b: uint256 = S_ + D * A_PRECISION / Ann
766     y: uint256 = D
767 
768     for _i in range(255):
769         y_prev = y
770         y = (y*y + c) / (2 * y + b - D)
771         # Equality with the precision of 1
772         if y > y_prev:
773             if y - y_prev <= 1:
774                 return y
775         else:
776             if y_prev - y <= 1:
777                 return y
778     raise
779 
780 
781 @view
782 @internal
783 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
784     # First, need to calculate
785     # * Get current D
786     # * Solve Eqn against y_i for D - _token_amount
787     amp: uint256 = self._A()
788     rates: uint256[N_COINS] = self.rate_multipliers
789     xp: uint256[N_COINS] = self._xp_mem(rates, self._balances())
790     D0: uint256 = self.get_D(xp, amp)
791 
792     total_supply: uint256 = self.totalSupply
793     D1: uint256 = D0 - _burn_amount * D0 / total_supply
794     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
795 
796     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
797     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
798 
799     for j in range(N_COINS):
800         dx_expected: uint256 = 0
801         xp_j: uint256 = xp[j]
802         if j == i:
803             dx_expected = xp_j * D1 / D0 - new_y
804         else:
805             dx_expected = xp_j - xp_j * D1 / D0
806         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
807 
808     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
809     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
810     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
811 
812     return [dy, dy_0 - dy]
813 
814 
815 @view
816 @external
817 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
818     """
819     @notice Calculate the amount received when withdrawing a single coin
820     @param _burn_amount Amount of LP tokens to burn in the withdrawal
821     @param i Index value of the coin to withdraw
822     @return Amount of coin received
823     """
824     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
825 
826 
827 @external
828 @nonreentrant('lock')
829 def remove_liquidity_one_coin(
830     _burn_amount: uint256,
831     i: int128,
832     _min_received: uint256,
833     _receiver: address = msg.sender,
834 ) -> uint256:
835     """
836     @notice Withdraw a single coin from the pool
837     @param _burn_amount Amount of LP tokens to burn in the withdrawal
838     @param i Index value of the coin to withdraw
839     @param _min_received Minimum amount of coin to receive
840     @param _receiver Address that receives the withdrawn coins
841     @return Amount of coin received
842     """
843     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
844     assert dy[0] >= _min_received, "Not enough coins removed"
845 
846     self.admin_balances[i] += dy[1] * ADMIN_FEE / FEE_DENOMINATOR
847     total_supply: uint256 = self.totalSupply - _burn_amount
848     self.totalSupply = total_supply
849     self.balanceOf[msg.sender] -= _burn_amount
850     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
851 
852     response: Bytes[32] = raw_call(
853         self.coins[i],
854         concat(
855             method_id("transfer(address,uint256)"),
856             convert(_receiver, bytes32),
857             convert(dy[0], bytes32),
858         ),
859         max_outsize=32,
860     )
861     if len(response) > 0:
862         assert convert(response, bool)
863 
864     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
865 
866     return dy[0]
867 
868 
869 @external
870 def ramp_A(_future_A: uint256, _future_time: uint256):
871     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
872     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
873     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
874 
875     _initial_A: uint256 = self._A()
876     _future_A_p: uint256 = _future_A * A_PRECISION
877 
878     assert _future_A > 0 and _future_A < MAX_A
879     if _future_A_p < _initial_A:
880         assert _future_A_p * MAX_A_CHANGE >= _initial_A
881     else:
882         assert _future_A_p <= _initial_A * MAX_A_CHANGE
883 
884     self.initial_A = _initial_A
885     self.future_A = _future_A_p
886     self.initial_A_time = block.timestamp
887     self.future_A_time = _future_time
888 
889     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
890 
891 
892 @external
893 def stop_ramp_A():
894     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
895 
896     current_A: uint256 = self._A()
897     self.initial_A = current_A
898     self.future_A = current_A
899     self.initial_A_time = block.timestamp
900     self.future_A_time = block.timestamp
901     # now (block.timestamp < t1) is always False, so we return saved A
902 
903     log StopRampA(current_A, block.timestamp)
904 
905 
906 @external
907 def withdraw_admin_fees():
908     receiver: address = Factory(self.factory).get_fee_receiver(self)
909 
910     for i in range(N_COINS):
911         amount: uint256 = self.admin_balances[i]
912         if amount != 0:
913             coin: address = self.coins[i]
914             raw_call(
915                 coin,
916                 concat(
917                     method_id("transfer(address,uint256)"),
918                     convert(receiver, bytes32),
919                     convert(amount, bytes32)
920                 )
921             )
922             self.admin_balances[i] = 0