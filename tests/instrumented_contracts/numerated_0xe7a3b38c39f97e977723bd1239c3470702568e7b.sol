1 # @version 0.2.15
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2021 - all rights reserved
6 @notice 3 coin pool implementation with no lending
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
72 N_COINS: constant(int128) = 3
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
290     Dprev: uint256 = 0
291     for x in _xp:
292         S += x
293     if S == 0:
294         return 0
295 
296     D: uint256 = S
297     Ann: uint256 = _amp * N_COINS
298     for i in range(255):
299         D_P: uint256 = D
300         for x in _xp:
301             D_P = D_P * D / (x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
302         Dprev = D
303         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
304         # Equality with the precision of 1
305         if D > Dprev:
306             if D - Dprev <= 1:
307                 return D
308         else:
309             if Dprev - D <= 1:
310                 return D
311     # convergence typically occurs in 4 rounds or less, this should be unreachable!
312     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
313     raise
314 
315 
316 @view
317 @internal
318 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
319     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
320     return self.get_D(xp, _amp)
321 
322 
323 @view
324 @external
325 def get_virtual_price() -> uint256:
326     """
327     @notice The current virtual price of the pool LP token
328     @dev Useful for calculating profits
329     @return LP token virtual price normalized to 1e18
330     """
331     amp: uint256 = self._A()
332     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, self.balances)
333     D: uint256 = self.get_D(xp, amp)
334     # D is in the units similar to DAI (e.g. converted to precision 1e18)
335     # When balanced, D = n * x_u - total virtual value of the portfolio
336     return D * PRECISION / self.totalSupply
337 
338 
339 @view
340 @external
341 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
342     """
343     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
344     @dev This calculation accounts for slippage, but not fees.
345          Needed to prevent front-running, not for precise calculations!
346     @param _amounts Amount of each coin being deposited
347     @param _is_deposit set True for deposits, False for withdrawals
348     @return Expected amount of LP tokens received
349     """
350     amp: uint256 = self._A()
351     balances: uint256[N_COINS] = self.balances
352 
353     D0: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
354     for i in range(N_COINS):
355         amount: uint256 = _amounts[i]
356         if _is_deposit:
357             balances[i] += amount
358         else:
359             balances[i] -= amount
360     D1: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
361     diff: uint256 = 0
362     if _is_deposit:
363         diff = D1 - D0
364     else:
365         diff = D0 - D1
366     return diff * self.totalSupply / D0
367 
368 
369 @external
370 @nonreentrant('lock')
371 def add_liquidity(
372     _amounts: uint256[N_COINS],
373     _min_mint_amount: uint256,
374     _receiver: address = msg.sender
375 ) -> uint256:
376     """
377     @notice Deposit coins into the pool
378     @param _amounts List of amounts of coins to deposit
379     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
380     @param _receiver Address that owns the minted LP tokens
381     @return Amount of LP tokens received by depositing
382     """
383     amp: uint256 = self._A()
384     old_balances: uint256[N_COINS] = self.balances
385     rates: uint256[N_COINS] = self.rate_multipliers
386 
387     # Initial invariant
388     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
389 
390     total_supply: uint256 = self.totalSupply
391     new_balances: uint256[N_COINS] = old_balances
392     for i in range(N_COINS):
393         amount: uint256 = _amounts[i]
394         if amount > 0:
395             response: Bytes[32] = raw_call(
396                 self.coins[i],
397                 concat(
398                     method_id("transferFrom(address,address,uint256)"),
399                     convert(msg.sender, bytes32),
400                     convert(self, bytes32),
401                     convert(amount, bytes32),
402                 ),
403                 max_outsize=32,
404             )
405             if len(response) > 0:
406                 assert convert(response, bool)  # dev: failed transfer
407             new_balances[i] += amount
408             # end "safeTransferFrom"
409         else:
410             assert total_supply != 0  # dev: initial deposit requires all coins
411 
412     # Invariant after change
413     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
414     assert D1 > D0
415 
416     # We need to recalculate the invariant accounting for fees
417     # to calculate fair user's share
418     fees: uint256[N_COINS] = empty(uint256[N_COINS])
419     mint_amount: uint256 = 0
420     if total_supply > 0:
421         # Only account for fees if we are not the first to deposit
422         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
423         for i in range(N_COINS):
424             ideal_balance: uint256 = D1 * old_balances[i] / D0
425             difference: uint256 = 0
426             new_balance: uint256 = new_balances[i]
427             if ideal_balance > new_balance:
428                 difference = ideal_balance - new_balance
429             else:
430                 difference = new_balance - ideal_balance
431             fees[i] = base_fee * difference / FEE_DENOMINATOR
432             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
433             new_balances[i] -= fees[i]
434         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
435         mint_amount = total_supply * (D2 - D0) / D0
436     else:
437         self.balances = new_balances
438         mint_amount = D1  # Take the dust if there was any
439 
440     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
441 
442     # Mint pool tokens
443     total_supply += mint_amount
444     self.balanceOf[_receiver] += mint_amount
445     self.totalSupply = total_supply
446     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
447 
448     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
449 
450     return mint_amount
451 
452 
453 @view
454 @internal
455 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
456     """
457     Calculate x[j] if one makes x[i] = x
458 
459     Done by solving quadratic equation iteratively.
460     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
461     x_1**2 + b*x_1 = c
462 
463     x_1 = (x_1**2 + c) / (2*x_1 + b)
464     """
465     # x in the input is converted to the same price/precision
466 
467     assert i != j       # dev: same coin
468     assert j >= 0       # dev: j below zero
469     assert j < N_COINS  # dev: j above N_COINS
470 
471     # should be unreachable, but good for safety
472     assert i >= 0
473     assert i < N_COINS
474 
475     amp: uint256 = self._A()
476     D: uint256 = self.get_D(xp, amp)
477     S_: uint256 = 0
478     _x: uint256 = 0
479     y_prev: uint256 = 0
480     c: uint256 = D
481     Ann: uint256 = amp * N_COINS
482 
483     for _i in range(N_COINS):
484         if _i == i:
485             _x = x
486         elif _i != j:
487             _x = xp[_i]
488         else:
489             continue
490         S_ += _x
491         c = c * D / (_x * N_COINS)
492 
493     c = c * D * A_PRECISION / (Ann * N_COINS)
494     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
495     y: uint256 = D
496 
497     for _i in range(255):
498         y_prev = y
499         y = (y*y + c) / (2 * y + b - D)
500         # Equality with the precision of 1
501         if y > y_prev:
502             if y - y_prev <= 1:
503                 return y
504         else:
505             if y_prev - y <= 1:
506                 return y
507     raise
508 
509 
510 @view
511 @external
512 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
513     """
514     @notice Calculate the current output dy given input dx
515     @dev Index values can be found via the `coins` public getter method
516     @param i Index value for the coin to send
517     @param j Index valie of the coin to recieve
518     @param dx Amount of `i` being exchanged
519     @return Amount of `j` predicted
520     """
521     rates: uint256[N_COINS] = self.rate_multipliers
522     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
523 
524     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
525     y: uint256 = self.get_y(i, j, x, xp)
526     dy: uint256 = xp[j] - y - 1
527     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
528     return (dy - fee) * PRECISION / rates[j]
529 
530 
531 @external
532 @nonreentrant('lock')
533 def exchange(
534     i: int128,
535     j: int128,
536     _dx: uint256,
537     _min_dy: uint256,
538     _receiver: address = msg.sender,
539 ) -> uint256:
540     """
541     @notice Perform an exchange between two coins
542     @dev Index values can be found via the `coins` public getter method
543     @param i Index value for the coin to send
544     @param j Index valie of the coin to recieve
545     @param _dx Amount of `i` being exchanged
546     @param _min_dy Minimum amount of `j` to receive
547     @return Actual amount of `j` received
548     """
549     rates: uint256[N_COINS] = self.rate_multipliers
550     old_balances: uint256[N_COINS] = self.balances
551     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
552 
553     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
554     y: uint256 = self.get_y(i, j, x, xp)
555 
556     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
557     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
558 
559     # Convert all to real units
560     dy = (dy - dy_fee) * PRECISION / rates[j]
561     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
562 
563     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
564     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
565 
566     # Change balances exactly in same way as we change actual ERC20 coin amounts
567     self.balances[i] = old_balances[i] + _dx
568     # When rounding errors happen, we undercharge admin fee in favor of LP
569     self.balances[j] = old_balances[j] - dy - dy_admin_fee
570 
571     response: Bytes[32] = raw_call(
572         self.coins[i],
573         concat(
574             method_id("transferFrom(address,address,uint256)"),
575             convert(msg.sender, bytes32),
576             convert(self, bytes32),
577             convert(_dx, bytes32),
578         ),
579         max_outsize=32,
580     )
581     if len(response) > 0:
582         assert convert(response, bool)
583 
584     response = raw_call(
585         self.coins[j],
586         concat(
587             method_id("transfer(address,uint256)"),
588             convert(_receiver, bytes32),
589             convert(dy, bytes32),
590         ),
591         max_outsize=32,
592     )
593     if len(response) > 0:
594         assert convert(response, bool)
595 
596     log TokenExchange(msg.sender, i, _dx, j, dy)
597 
598     return dy
599 
600 
601 @external
602 @nonreentrant('lock')
603 def remove_liquidity(
604     _burn_amount: uint256,
605     _min_amounts: uint256[N_COINS],
606     _receiver: address = msg.sender
607 ) -> uint256[N_COINS]:
608     """
609     @notice Withdraw coins from the pool
610     @dev Withdrawal amounts are based on current deposit ratios
611     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
612     @param _min_amounts Minimum amounts of underlying coins to receive
613     @param _receiver Address that receives the withdrawn coins
614     @return List of amounts of coins that were withdrawn
615     """
616     total_supply: uint256 = self.totalSupply
617     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
618 
619     for i in range(N_COINS):
620         old_balance: uint256 = self.balances[i]
621         value: uint256 = old_balance * _burn_amount / total_supply
622         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
623         self.balances[i] = old_balance - value
624         amounts[i] = value
625 
626         response: Bytes[32] = raw_call(
627             self.coins[i],
628             concat(
629                 method_id("transfer(address,uint256)"),
630                 convert(_receiver, bytes32),
631                 convert(value, bytes32),
632             ),
633             max_outsize=32,
634         )
635         if len(response) > 0:
636             assert convert(response, bool)
637 
638     total_supply -= _burn_amount
639     self.balanceOf[msg.sender] -= _burn_amount
640     self.totalSupply = total_supply
641     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
642 
643     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
644 
645     return amounts
646 
647 
648 @external
649 @nonreentrant('lock')
650 def remove_liquidity_imbalance(
651     _amounts: uint256[N_COINS],
652     _max_burn_amount: uint256,
653     _receiver: address = msg.sender
654 ) -> uint256:
655     """
656     @notice Withdraw coins from the pool in an imbalanced amount
657     @param _amounts List of amounts of underlying coins to withdraw
658     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
659     @param _receiver Address that receives the withdrawn coins
660     @return Actual amount of the LP token burned in the withdrawal
661     """
662     amp: uint256 = self._A()
663     rates: uint256[N_COINS] = self.rate_multipliers
664     old_balances: uint256[N_COINS] = self.balances
665     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
666 
667     new_balances: uint256[N_COINS] = old_balances
668     for i in range(N_COINS):
669         amount: uint256 = _amounts[i]
670         if amount != 0:
671             new_balances[i] -= amount
672             response: Bytes[32] = raw_call(
673                 self.coins[i],
674                 concat(
675                     method_id("transfer(address,uint256)"),
676                     convert(_receiver, bytes32),
677                     convert(amount, bytes32),
678                 ),
679                 max_outsize=32,
680             )
681             if len(response) > 0:
682                 assert convert(response, bool)
683     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
684 
685     fees: uint256[N_COINS] = empty(uint256[N_COINS])
686     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
687     for i in range(N_COINS):
688         ideal_balance: uint256 = D1 * old_balances[i] / D0
689         difference: uint256 = 0
690         new_balance: uint256 = new_balances[i]
691         if ideal_balance > new_balance:
692             difference = ideal_balance - new_balance
693         else:
694             difference = new_balance - ideal_balance
695         fees[i] = base_fee * difference / FEE_DENOMINATOR
696         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
697         new_balances[i] -= fees[i]
698     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
699 
700     total_supply: uint256 = self.totalSupply
701     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
702     assert burn_amount > 1  # dev: zero tokens burned
703     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
704 
705     total_supply -= burn_amount
706     self.totalSupply = total_supply
707     self.balanceOf[msg.sender] -= burn_amount
708     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
709     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
710 
711     return burn_amount
712 
713 
714 @pure
715 @internal
716 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
717     """
718     Calculate x[i] if one reduces D from being calculated for xp to D
719 
720     Done by solving quadratic equation iteratively.
721     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
722     x_1**2 + b*x_1 = c
723 
724     x_1 = (x_1**2 + c) / (2*x_1 + b)
725     """
726     # x in the input is converted to the same price/precision
727 
728     assert i >= 0  # dev: i below zero
729     assert i < N_COINS  # dev: i above N_COINS
730 
731     S_: uint256 = 0
732     _x: uint256 = 0
733     y_prev: uint256 = 0
734     c: uint256 = D
735     Ann: uint256 = A * N_COINS
736 
737     for _i in range(N_COINS):
738         if _i != i:
739             _x = xp[_i]
740         else:
741             continue
742         S_ += _x
743         c = c * D / (_x * N_COINS)
744 
745     c = c * D * A_PRECISION / (Ann * N_COINS)
746     b: uint256 = S_ + D * A_PRECISION / Ann
747     y: uint256 = D
748 
749     for _i in range(255):
750         y_prev = y
751         y = (y*y + c) / (2 * y + b - D)
752         # Equality with the precision of 1
753         if y > y_prev:
754             if y - y_prev <= 1:
755                 return y
756         else:
757             if y_prev - y <= 1:
758                 return y
759     raise
760 
761 
762 @view
763 @internal
764 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
765     # First, need to calculate
766     # * Get current D
767     # * Solve Eqn against y_i for D - _token_amount
768     amp: uint256 = self._A()
769     rates: uint256[N_COINS] = self.rate_multipliers
770     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
771     D0: uint256 = self.get_D(xp, amp)
772 
773     total_supply: uint256 = self.totalSupply
774     D1: uint256 = D0 - _burn_amount * D0 / total_supply
775     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
776 
777     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
778     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
779 
780     for j in range(N_COINS):
781         dx_expected: uint256 = 0
782         xp_j: uint256 = xp[j]
783         if j == i:
784             dx_expected = xp_j * D1 / D0 - new_y
785         else:
786             dx_expected = xp_j - xp_j * D1 / D0
787         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
788 
789     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
790     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
791     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
792 
793     return [dy, dy_0 - dy]
794 
795 
796 @view
797 @external
798 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
799     """
800     @notice Calculate the amount received when withdrawing a single coin
801     @param _burn_amount Amount of LP tokens to burn in the withdrawal
802     @param i Index value of the coin to withdraw
803     @return Amount of coin received
804     """
805     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
806 
807 
808 @external
809 @nonreentrant('lock')
810 def remove_liquidity_one_coin(
811     _burn_amount: uint256,
812     i: int128,
813     _min_received: uint256,
814     _receiver: address = msg.sender,
815 ) -> uint256:
816     """
817     @notice Withdraw a single coin from the pool
818     @param _burn_amount Amount of LP tokens to burn in the withdrawal
819     @param i Index value of the coin to withdraw
820     @param _min_received Minimum amount of coin to receive
821     @param _receiver Address that receives the withdrawn coins
822     @return Amount of coin received
823     """
824     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
825     assert dy[0] >= _min_received, "Not enough coins removed"
826 
827     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
828     total_supply: uint256 = self.totalSupply - _burn_amount
829     self.totalSupply = total_supply
830     self.balanceOf[msg.sender] -= _burn_amount
831     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
832 
833     response: Bytes[32] = raw_call(
834         self.coins[i],
835         concat(
836             method_id("transfer(address,uint256)"),
837             convert(_receiver, bytes32),
838             convert(dy[0], bytes32),
839         ),
840         max_outsize=32,
841     )
842     if len(response) > 0:
843         assert convert(response, bool)
844 
845     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
846 
847     return dy[0]
848 
849 
850 @external
851 def ramp_A(_future_A: uint256, _future_time: uint256):
852     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
853     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
854     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
855 
856     _initial_A: uint256 = self._A()
857     _future_A_p: uint256 = _future_A * A_PRECISION
858 
859     assert _future_A > 0 and _future_A < MAX_A
860     if _future_A_p < _initial_A:
861         assert _future_A_p * MAX_A_CHANGE >= _initial_A
862     else:
863         assert _future_A_p <= _initial_A * MAX_A_CHANGE
864 
865     self.initial_A = _initial_A
866     self.future_A = _future_A_p
867     self.initial_A_time = block.timestamp
868     self.future_A_time = _future_time
869 
870     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
871 
872 
873 @external
874 def stop_ramp_A():
875     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
876 
877     current_A: uint256 = self._A()
878     self.initial_A = current_A
879     self.future_A = current_A
880     self.initial_A_time = block.timestamp
881     self.future_A_time = block.timestamp
882     # now (block.timestamp < t1) is always False, so we return saved A
883 
884     log StopRampA(current_A, block.timestamp)
885 
886 
887 @view
888 @external
889 def admin_balances(i: uint256) -> uint256:
890     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
891 
892 
893 @external
894 def withdraw_admin_fees():
895     receiver: address = Factory(self.factory).get_fee_receiver(self)
896 
897     for i in range(N_COINS):
898         coin: address = self.coins[i]
899         fees: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
900         raw_call(
901             coin,
902             concat(
903                 method_id("transfer(address,uint256)"),
904                 convert(receiver, bytes32),
905                 convert(fees, bytes32)
906             )
907         )