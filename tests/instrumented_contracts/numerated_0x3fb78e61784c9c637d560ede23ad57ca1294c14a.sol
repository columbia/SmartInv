1 # @version 0.2.15
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2021 - all rights reserved
6 @notice 2 coin pool implementation with no lending
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
312     for x in _xp:
313         S += x
314     if S == 0:
315         return 0
316 
317     D: uint256 = S
318     Ann: uint256 = _amp * N_COINS
319     for i in range(255):
320         D_P: uint256 = D * D / _xp[0] * D / _xp[1] / (N_COINS)**2
321         Dprev: uint256 = D
322         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
323         # Equality with the precision of 1
324         if D > Dprev:
325             if D - Dprev <= 1:
326                 return D
327         else:
328             if Dprev - D <= 1:
329                 return D
330     # convergence typically occurs in 4 rounds or less, this should be unreachable!
331     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
332     raise
333 
334 
335 @view
336 @internal
337 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
338     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
339     return self.get_D(xp, _amp)
340 
341 
342 @view
343 @external
344 def get_virtual_price() -> uint256:
345     """
346     @notice The current virtual price of the pool LP token
347     @dev Useful for calculating profits
348     @return LP token virtual price normalized to 1e18
349     """
350     amp: uint256 = self._A()
351     balances: uint256[N_COINS] = self._balances()
352     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, balances)
353     D: uint256 = self.get_D(xp, amp)
354     # D is in the units similar to DAI (e.g. converted to precision 1e18)
355     # When balanced, D = n * x_u - total virtual value of the portfolio
356     return D * PRECISION / self.totalSupply
357 
358 
359 @view
360 @external
361 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
362     """
363     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
364     @dev This calculation accounts for slippage, but not fees.
365          Needed to prevent front-running, not for precise calculations!
366     @param _amounts Amount of each coin being deposited
367     @param _is_deposit set True for deposits, False for withdrawals
368     @return Expected amount of LP tokens received
369     """
370     amp: uint256 = self._A()
371     balances: uint256[N_COINS] = self._balances()
372 
373     D0: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
374     for i in range(N_COINS):
375         amount: uint256 = _amounts[i]
376         if _is_deposit:
377             balances[i] += amount
378         else:
379             balances[i] -= amount
380     D1: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
381     diff: uint256 = 0
382     if _is_deposit:
383         diff = D1 - D0
384     else:
385         diff = D0 - D1
386     return diff * self.totalSupply / D0
387 
388 
389 @external
390 @nonreentrant('lock')
391 def add_liquidity(
392     _amounts: uint256[N_COINS],
393     _min_mint_amount: uint256,
394     _receiver: address = msg.sender
395 ) -> uint256:
396     """
397     @notice Deposit coins into the pool
398     @param _amounts List of amounts of coins to deposit
399     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
400     @param _receiver Address that owns the minted LP tokens
401     @return Amount of LP tokens received by depositing
402     """
403     amp: uint256 = self._A()
404     old_balances: uint256[N_COINS] = self._balances()
405     rates: uint256[N_COINS] = self.rate_multipliers
406 
407     # Initial invariant
408     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
409 
410     total_supply: uint256 = self.totalSupply
411     new_balances: uint256[N_COINS] = old_balances
412     for i in range(N_COINS):
413         amount: uint256 = _amounts[i]
414         if amount > 0:
415             coin: address = self.coins[i]
416             initial: uint256 = ERC20(coin).balanceOf(self)
417             response: Bytes[32] = raw_call(
418                 coin,
419                 concat(
420                     method_id("transferFrom(address,address,uint256)"),
421                     convert(msg.sender, bytes32),
422                     convert(self, bytes32),
423                     convert(amount, bytes32),
424                 ),
425                 max_outsize=32,
426             )
427             if len(response) > 0:
428                 assert convert(response, bool)  # dev: failed transfer
429             new_balances[i] += ERC20(coin).balanceOf(self) - initial
430         else:
431             assert total_supply != 0  # dev: initial deposit requires all coins
432 
433     # Invariant after change
434     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
435     assert D1 > D0
436 
437     # We need to recalculate the invariant accounting for fees
438     # to calculate fair user's share
439     fees: uint256[N_COINS] = empty(uint256[N_COINS])
440     mint_amount: uint256 = 0
441     if total_supply > 0:
442         # Only account for fees if we are not the first to deposit
443         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
444         for i in range(N_COINS):
445             ideal_balance: uint256 = D1 * old_balances[i] / D0
446             difference: uint256 = 0
447             new_balance: uint256 = new_balances[i]
448             if ideal_balance > new_balance:
449                 difference = ideal_balance - new_balance
450             else:
451                 difference = new_balance - ideal_balance
452             fees[i] = base_fee * difference / FEE_DENOMINATOR
453             self.admin_balances[i] += fees[i] * ADMIN_FEE / FEE_DENOMINATOR
454             new_balances[i] -= fees[i]
455         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
456         mint_amount = total_supply * (D2 - D0) / D0
457     else:
458         mint_amount = D1  # Take the dust if there was any
459 
460     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
461 
462     # Mint pool tokens
463     total_supply += mint_amount
464     self.balanceOf[_receiver] += mint_amount
465     self.totalSupply = total_supply
466     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
467 
468     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
469 
470     return mint_amount
471 
472 
473 @view
474 @internal
475 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
476     """
477     Calculate x[j] if one makes x[i] = x
478 
479     Done by solving quadratic equation iteratively.
480     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
481     x_1**2 + b*x_1 = c
482 
483     x_1 = (x_1**2 + c) / (2*x_1 + b)
484     """
485     # x in the input is converted to the same price/precision
486 
487     assert i != j       # dev: same coin
488     assert j >= 0       # dev: j below zero
489     assert j < N_COINS  # dev: j above N_COINS
490 
491     # should be unreachable, but good for safety
492     assert i >= 0
493     assert i < N_COINS
494 
495     amp: uint256 = self._A()
496     D: uint256 = self.get_D(xp, amp)
497     S_: uint256 = 0
498     _x: uint256 = 0
499     y_prev: uint256 = 0
500     c: uint256 = D
501     Ann: uint256 = amp * N_COINS
502 
503     for _i in range(N_COINS):
504         if _i == i:
505             _x = x
506         elif _i != j:
507             _x = xp[_i]
508         else:
509             continue
510         S_ += _x
511         c = c * D / (_x * N_COINS)
512 
513     c = c * D * A_PRECISION / (Ann * N_COINS)
514     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
515     y: uint256 = D
516 
517     for _i in range(255):
518         y_prev = y
519         y = (y*y + c) / (2 * y + b - D)
520         # Equality with the precision of 1
521         if y > y_prev:
522             if y - y_prev <= 1:
523                 return y
524         else:
525             if y_prev - y <= 1:
526                 return y
527     raise
528 
529 
530 @view
531 @external
532 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
533     """
534     @notice Calculate the current output dy given input dx
535     @dev Index values can be found via the `coins` public getter method
536     @param i Index value for the coin to send
537     @param j Index valie of the coin to recieve
538     @param dx Amount of `i` being exchanged
539     @return Amount of `j` predicted
540     """
541     rates: uint256[N_COINS] = self.rate_multipliers
542     xp: uint256[N_COINS] = self._xp_mem(rates, self._balances())
543 
544     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
545     y: uint256 = self.get_y(i, j, x, xp)
546     dy: uint256 = xp[j] - y - 1
547     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
548     return (dy - fee) * PRECISION / rates[j]
549 
550 
551 @external
552 @nonreentrant('lock')
553 def exchange(
554     i: int128,
555     j: int128,
556     _dx: uint256,
557     _min_dy: uint256,
558     _receiver: address = msg.sender,
559 ) -> uint256:
560     """
561     @notice Perform an exchange between two coins
562     @dev Index values can be found via the `coins` public getter method
563     @param i Index value for the coin to send
564     @param j Index valie of the coin to recieve
565     @param _dx Amount of `i` being exchanged
566     @param _min_dy Minimum amount of `j` to receive
567     @return Actual amount of `j` received
568     """
569     rates: uint256[N_COINS] = self.rate_multipliers
570     old_balances: uint256[N_COINS] = self._balances()
571     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
572 
573     coin: address = self.coins[i]
574     dx: uint256 = ERC20(coin).balanceOf(self)
575     response: Bytes[32] = raw_call(
576         coin,
577         concat(
578             method_id("transferFrom(address,address,uint256)"),
579             convert(msg.sender, bytes32),
580             convert(self, bytes32),
581             convert(_dx, bytes32),
582         ),
583         max_outsize=32,
584     )
585     if len(response) > 0:
586         assert convert(response, bool)
587     dx = ERC20(coin).balanceOf(self) - dx
588 
589     x: uint256 = xp[i] + dx * rates[i] / PRECISION
590     y: uint256 = self.get_y(i, j, x, xp)
591 
592     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
593     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
594 
595     # Convert all to real units
596     dy = (dy - dy_fee) * PRECISION / rates[j]
597     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
598 
599     self.admin_balances[j] += (dy_fee * ADMIN_FEE / FEE_DENOMINATOR) * PRECISION / rates[j]
600 
601     response = raw_call(
602         self.coins[j],
603         concat(
604             method_id("transfer(address,uint256)"),
605             convert(_receiver, bytes32),
606             convert(dy, bytes32),
607         ),
608         max_outsize=32,
609     )
610     if len(response) > 0:
611         assert convert(response, bool)
612 
613     log TokenExchange(msg.sender, i, _dx, j, dy)
614 
615     return dy
616 
617 
618 @external
619 @nonreentrant('lock')
620 def remove_liquidity(
621     _burn_amount: uint256,
622     _min_amounts: uint256[N_COINS],
623     _receiver: address = msg.sender
624 ) -> uint256[N_COINS]:
625     """
626     @notice Withdraw coins from the pool
627     @dev Withdrawal amounts are based on current deposit ratios
628     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
629     @param _min_amounts Minimum amounts of underlying coins to receive
630     @param _receiver Address that receives the withdrawn coins
631     @return List of amounts of coins that were withdrawn
632     """
633     total_supply: uint256 = self.totalSupply
634     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
635     balances: uint256[N_COINS] = self._balances()
636 
637     for i in range(N_COINS):
638         value: uint256 = balances[i] * _burn_amount / total_supply
639         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
640         amounts[i] = value
641 
642         response: Bytes[32] = raw_call(
643             self.coins[i],
644             concat(
645                 method_id("transfer(address,uint256)"),
646                 convert(_receiver, bytes32),
647                 convert(value, bytes32),
648             ),
649             max_outsize=32,
650         )
651         if len(response) > 0:
652             assert convert(response, bool)
653 
654     total_supply -= _burn_amount
655     self.balanceOf[msg.sender] -= _burn_amount
656     self.totalSupply = total_supply
657     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
658 
659     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
660 
661     return amounts
662 
663 
664 @external
665 @nonreentrant('lock')
666 def remove_liquidity_imbalance(
667     _amounts: uint256[N_COINS],
668     _max_burn_amount: uint256,
669     _receiver: address = msg.sender
670 ) -> uint256:
671     """
672     @notice Withdraw coins from the pool in an imbalanced amount
673     @param _amounts List of amounts of underlying coins to withdraw
674     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
675     @param _receiver Address that receives the withdrawn coins
676     @return Actual amount of the LP token burned in the withdrawal
677     """
678     amp: uint256 = self._A()
679     old_balances: uint256[N_COINS] = self._balances()
680     rates: uint256[N_COINS] = self.rate_multipliers
681     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
682 
683     new_balances: uint256[N_COINS] = old_balances
684     for i in range(N_COINS):
685         amount: uint256 = _amounts[i]
686         if amount != 0:
687             new_balances[i] -= amount
688             response: Bytes[32] = raw_call(
689                 self.coins[i],
690                 concat(
691                     method_id("transfer(address,uint256)"),
692                     convert(_receiver, bytes32),
693                     convert(amount, bytes32),
694                 ),
695                 max_outsize=32,
696             )
697             if len(response) > 0:
698                 assert convert(response, bool)
699     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
700 
701     fees: uint256[N_COINS] = empty(uint256[N_COINS])
702     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
703     for i in range(N_COINS):
704         ideal_balance: uint256 = D1 * old_balances[i] / D0
705         difference: uint256 = 0
706         new_balance: uint256 = new_balances[i]
707         if ideal_balance > new_balance:
708             difference = ideal_balance - new_balance
709         else:
710             difference = new_balance - ideal_balance
711         fees[i] = base_fee * difference / FEE_DENOMINATOR
712         self.admin_balances[i] += fees[i] * ADMIN_FEE / FEE_DENOMINATOR
713         new_balances[i] -= fees[i]
714     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
715 
716     total_supply: uint256 = self.totalSupply
717     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
718     assert burn_amount > 1  # dev: zero tokens burned
719     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
720 
721     total_supply -= burn_amount
722     self.totalSupply = total_supply
723     self.balanceOf[msg.sender] -= burn_amount
724     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
725     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
726 
727     return burn_amount
728 
729 
730 @pure
731 @internal
732 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
733     """
734     Calculate x[i] if one reduces D from being calculated for xp to D
735 
736     Done by solving quadratic equation iteratively.
737     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
738     x_1**2 + b*x_1 = c
739 
740     x_1 = (x_1**2 + c) / (2*x_1 + b)
741     """
742     # x in the input is converted to the same price/precision
743 
744     assert i >= 0  # dev: i below zero
745     assert i < N_COINS  # dev: i above N_COINS
746 
747     S_: uint256 = 0
748     _x: uint256 = 0
749     y_prev: uint256 = 0
750     c: uint256 = D
751     Ann: uint256 = A * N_COINS
752 
753     for _i in range(N_COINS):
754         if _i != i:
755             _x = xp[_i]
756         else:
757             continue
758         S_ += _x
759         c = c * D / (_x * N_COINS)
760 
761     c = c * D * A_PRECISION / (Ann * N_COINS)
762     b: uint256 = S_ + D * A_PRECISION / Ann
763     y: uint256 = D
764 
765     for _i in range(255):
766         y_prev = y
767         y = (y*y + c) / (2 * y + b - D)
768         # Equality with the precision of 1
769         if y > y_prev:
770             if y - y_prev <= 1:
771                 return y
772         else:
773             if y_prev - y <= 1:
774                 return y
775     raise
776 
777 
778 @view
779 @internal
780 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
781     # First, need to calculate
782     # * Get current D
783     # * Solve Eqn against y_i for D - _token_amount
784     amp: uint256 = self._A()
785     rates: uint256[N_COINS] = self.rate_multipliers
786     xp: uint256[N_COINS] = self._xp_mem(rates, self._balances())
787     D0: uint256 = self.get_D(xp, amp)
788 
789     total_supply: uint256 = self.totalSupply
790     D1: uint256 = D0 - _burn_amount * D0 / total_supply
791     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
792 
793     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
794     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
795 
796     for j in range(N_COINS):
797         dx_expected: uint256 = 0
798         xp_j: uint256 = xp[j]
799         if j == i:
800             dx_expected = xp_j * D1 / D0 - new_y
801         else:
802             dx_expected = xp_j - xp_j * D1 / D0
803         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
804 
805     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
806     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
807     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
808 
809     return [dy, dy_0 - dy]
810 
811 
812 @view
813 @external
814 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
815     """
816     @notice Calculate the amount received when withdrawing a single coin
817     @param _burn_amount Amount of LP tokens to burn in the withdrawal
818     @param i Index value of the coin to withdraw
819     @return Amount of coin received
820     """
821     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
822 
823 
824 @external
825 @nonreentrant('lock')
826 def remove_liquidity_one_coin(
827     _burn_amount: uint256,
828     i: int128,
829     _min_received: uint256,
830     _receiver: address = msg.sender,
831 ) -> uint256:
832     """
833     @notice Withdraw a single coin from the pool
834     @param _burn_amount Amount of LP tokens to burn in the withdrawal
835     @param i Index value of the coin to withdraw
836     @param _min_received Minimum amount of coin to receive
837     @param _receiver Address that receives the withdrawn coins
838     @return Amount of coin received
839     """
840     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
841     assert dy[0] >= _min_received, "Not enough coins removed"
842 
843     self.admin_balances[i] += dy[1] * ADMIN_FEE / FEE_DENOMINATOR
844     total_supply: uint256 = self.totalSupply - _burn_amount
845     self.totalSupply = total_supply
846     self.balanceOf[msg.sender] -= _burn_amount
847     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
848 
849     response: Bytes[32] = raw_call(
850         self.coins[i],
851         concat(
852             method_id("transfer(address,uint256)"),
853             convert(_receiver, bytes32),
854             convert(dy[0], bytes32),
855         ),
856         max_outsize=32,
857     )
858     if len(response) > 0:
859         assert convert(response, bool)
860 
861     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
862 
863     return dy[0]
864 
865 
866 @external
867 def ramp_A(_future_A: uint256, _future_time: uint256):
868     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
869     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
870     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
871 
872     _initial_A: uint256 = self._A()
873     _future_A_p: uint256 = _future_A * A_PRECISION
874 
875     assert _future_A > 0 and _future_A < MAX_A
876     if _future_A_p < _initial_A:
877         assert _future_A_p * MAX_A_CHANGE >= _initial_A
878     else:
879         assert _future_A_p <= _initial_A * MAX_A_CHANGE
880 
881     self.initial_A = _initial_A
882     self.future_A = _future_A_p
883     self.initial_A_time = block.timestamp
884     self.future_A_time = _future_time
885 
886     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
887 
888 
889 @external
890 def stop_ramp_A():
891     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
892 
893     current_A: uint256 = self._A()
894     self.initial_A = current_A
895     self.future_A = current_A
896     self.initial_A_time = block.timestamp
897     self.future_A_time = block.timestamp
898     # now (block.timestamp < t1) is always False, so we return saved A
899 
900     log StopRampA(current_A, block.timestamp)
901 
902 
903 @external
904 def withdraw_admin_fees():
905     receiver: address = Factory(self.factory).get_fee_receiver(self)
906 
907     for i in range(N_COINS):
908         amount: uint256 = self.admin_balances[i]
909         if amount != 0:
910             coin: address = self.coins[i]
911             raw_call(
912                 coin,
913                 concat(
914                     method_id("transfer(address,uint256)"),
915                     convert(receiver, bytes32),
916                     convert(amount, bytes32)
917                 )
918             )
919             self.admin_balances[i] = 0