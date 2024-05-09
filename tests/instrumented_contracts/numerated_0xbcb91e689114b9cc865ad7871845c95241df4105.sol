1 # @version 0.2.15
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2021 - all rights reserved
6 @notice 3pool metapool implementation contract
7 @dev ERC20 support for return True/revert, return True/False, return None
8      Support for positive-rebasing and fee-on-transfer tokens
9 """
10 
11 interface ERC20:
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
27     def convert_metapool_fees() -> bool: nonpayable
28     def get_fee_receiver(_pool: address) -> address: view
29     def admin() -> address: view
30 
31 
32 event Transfer:
33     sender: indexed(address)
34     receiver: indexed(address)
35     value: uint256
36 
37 event Approval:
38     owner: indexed(address)
39     spender: indexed(address)
40     value: uint256
41 
42 event TokenExchange:
43     buyer: indexed(address)
44     sold_id: int128
45     tokens_sold: uint256
46     bought_id: int128
47     tokens_bought: uint256
48 
49 event TokenExchangeUnderlying:
50     buyer: indexed(address)
51     sold_id: int128
52     tokens_sold: uint256
53     bought_id: int128
54     tokens_bought: uint256
55 
56 event AddLiquidity:
57     provider: indexed(address)
58     token_amounts: uint256[N_COINS]
59     fees: uint256[N_COINS]
60     invariant: uint256
61     token_supply: uint256
62 
63 event RemoveLiquidity:
64     provider: indexed(address)
65     token_amounts: uint256[N_COINS]
66     fees: uint256[N_COINS]
67     token_supply: uint256
68 
69 event RemoveLiquidityOne:
70     provider: indexed(address)
71     token_amount: uint256
72     coin_amount: uint256
73     token_supply: uint256
74 
75 event RemoveLiquidityImbalance:
76     provider: indexed(address)
77     token_amounts: uint256[N_COINS]
78     fees: uint256[N_COINS]
79     invariant: uint256
80     token_supply: uint256
81 
82 event RampA:
83     old_A: uint256
84     new_A: uint256
85     initial_time: uint256
86     future_time: uint256
87 
88 event StopRampA:
89     A: uint256
90     t: uint256
91 
92 
93 BASE_POOL: constant(address) = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7
94 BASE_COINS: constant(address[3]) = [
95     0x6B175474E89094C44Da98b954EedeAC495271d0F,  # DAI
96     0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,  # USDC
97     0xdAC17F958D2ee523a2206206994597C13D831ec7,  # USDT
98 ]
99 
100 N_COINS: constant(int128) = 2
101 MAX_COIN: constant(int128) = N_COINS - 1
102 BASE_N_COINS: constant(int128) = 3
103 PRECISION: constant(uint256) = 10 ** 18
104 
105 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
106 ADMIN_FEE: constant(uint256) = 5000000000
107 
108 A_PRECISION: constant(uint256) = 100
109 MAX_A: constant(uint256) = 10 ** 6
110 MAX_A_CHANGE: constant(uint256) = 10
111 MIN_RAMP_TIME: constant(uint256) = 86400
112 
113 factory: address
114 
115 coins: public(address[N_COINS])
116 admin_balances: public(uint256[N_COINS])
117 fee: public(uint256)  # fee * 1e10
118 
119 initial_A: public(uint256)
120 future_A: public(uint256)
121 initial_A_time: public(uint256)
122 future_A_time: public(uint256)
123 
124 rate_multiplier: uint256
125 
126 name: public(String[64])
127 symbol: public(String[32])
128 
129 balanceOf: public(HashMap[address, uint256])
130 allowance: public(HashMap[address, HashMap[address, uint256]])
131 totalSupply: public(uint256)
132 
133 
134 @external
135 def __init__():
136     # we do this to prevent the implementation contract from being used as a pool
137     self.fee = 31337
138 
139 
140 @external
141 def initialize(
142     _name: String[32],
143     _symbol: String[10],
144     _coin: address,
145     _rate_multiplier: uint256,
146     _A: uint256,
147     _fee: uint256
148 ):
149     """
150     @notice Contract initializer
151     @param _name Name of the new pool
152     @param _symbol Token symbol
153     @param _coin Addresses of ERC20 conracts of coins
154     @param _rate_multiplier Rate multiplier for `_coin` (10 ** (36 - decimals))
155     @param _A Amplification coefficient multiplied by n ** (n - 1)
156     @param _fee Fee to charge for exchanges
157     """
158     # check if fee was already set to prevent initializing contract twice
159     assert self.fee == 0
160 
161     A: uint256 = _A * A_PRECISION
162     self.coins = [_coin, 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490]
163     self.rate_multiplier = _rate_multiplier
164     self.initial_A = A
165     self.future_A = A
166     self.fee = _fee
167     self.factory = msg.sender
168 
169     self.name = concat("Curve.fi Factory USD Metapool: ", _name)
170     self.symbol = concat(_symbol, "3CRV-f")
171 
172     for coin in BASE_COINS:
173         ERC20(coin).approve(BASE_POOL, MAX_UINT256)
174 
175     # fire a transfer event so block explorers identify the contract as an ERC20
176     log Transfer(ZERO_ADDRESS, self, 0)
177 
178 
179 ### ERC20 Functionality ###
180 
181 @view
182 @external
183 def decimals() -> uint256:
184     """
185     @notice Get the number of decimals for this token
186     @dev Implemented as a view method to reduce gas costs
187     @return uint256 decimal places
188     """
189     return 18
190 
191 
192 @internal
193 def _transfer(_from: address, _to: address, _value: uint256):
194     # # NOTE: vyper does not allow underflows
195     # #       so the following subtraction would revert on insufficient balance
196     self.balanceOf[_from] -= _value
197     self.balanceOf[_to] += _value
198 
199     log Transfer(_from, _to, _value)
200 
201 
202 @external
203 def transfer(_to : address, _value : uint256) -> bool:
204     """
205     @dev Transfer token for a specified address
206     @param _to The address to transfer to.
207     @param _value The amount to be transferred.
208     """
209     self._transfer(msg.sender, _to, _value)
210     return True
211 
212 
213 @external
214 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
215     """
216      @dev Transfer tokens from one address to another.
217      @param _from address The address which you want to send tokens from
218      @param _to address The address which you want to transfer to
219      @param _value uint256 the amount of tokens to be transferred
220     """
221     self._transfer(_from, _to, _value)
222 
223     _allowance: uint256 = self.allowance[_from][msg.sender]
224     if _allowance != MAX_UINT256:
225         self.allowance[_from][msg.sender] = _allowance - _value
226 
227     return True
228 
229 
230 @external
231 def approve(_spender : address, _value : uint256) -> bool:
232     """
233     @notice Approve the passed address to transfer the specified amount of
234             tokens on behalf of msg.sender
235     @dev Beware that changing an allowance via this method brings the risk that
236          someone may use both the old and new allowance by unfortunate transaction
237          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238     @param _spender The address which will transfer the funds
239     @param _value The amount of tokens that may be transferred
240     @return bool success
241     """
242     self.allowance[msg.sender][_spender] = _value
243 
244     log Approval(msg.sender, _spender, _value)
245     return True
246 
247 
248 ### StableSwap Functionality ###
249 
250 @view
251 @internal
252 def _balances() -> uint256[N_COINS]:
253     result: uint256[N_COINS] = empty(uint256[N_COINS])
254     for i in range(N_COINS):
255         result[i] = ERC20(self.coins[i]).balanceOf(self) - self.admin_balances[i]
256     return result
257 
258 
259 @view
260 @external
261 def balances(i: uint256) -> uint256:
262     """
263     @notice Get the current balance of a coin within the
264             pool, less the accrued admin fees
265     @param i Index value for the coin to query balance of
266     @return Token balance
267     """
268     return self._balances()[i]
269 
270 
271 @view
272 @external
273 def get_balances() -> uint256[N_COINS]:
274     return self._balances()
275 
276 
277 @view
278 @internal
279 def _A() -> uint256:
280     """
281     Handle ramping A up or down
282     """
283     t1: uint256 = self.future_A_time
284     A1: uint256 = self.future_A
285 
286     if block.timestamp < t1:
287         A0: uint256 = self.initial_A
288         t0: uint256 = self.initial_A_time
289         # Expressions in uint256 cannot have negative numbers, thus "if"
290         if A1 > A0:
291             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
292         else:
293             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
294 
295     else:  # when t1 == 0 or block.timestamp >= t1
296         return A1
297 
298 
299 @view
300 @external
301 def admin_fee() -> uint256:
302     return ADMIN_FEE
303 
304 
305 @view
306 @external
307 def A() -> uint256:
308     return self._A() / A_PRECISION
309 
310 
311 @view
312 @external
313 def A_precise() -> uint256:
314     return self._A()
315 
316 
317 @pure
318 @internal
319 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
320     result: uint256[N_COINS] = empty(uint256[N_COINS])
321     for i in range(N_COINS):
322         result[i] = _rates[i] * _balances[i] / PRECISION
323     return result
324 
325 
326 @pure
327 @internal
328 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
329     """
330     D invariant calculation in non-overflowing integer operations
331     iteratively
332 
333     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
334 
335     Converging solution:
336     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
337     """
338     S: uint256 = 0
339     Dprev: uint256 = 0
340     for x in _xp:
341         S += x
342     if S == 0:
343         return 0
344 
345     D: uint256 = S
346     Ann: uint256 = _amp * N_COINS
347     for i in range(255):
348         D_P: uint256 = D
349         for x in _xp:
350             D_P = D_P * D / (x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
351         Dprev = D
352         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
353         # Equality with the precision of 1
354         if D > Dprev:
355             if D - Dprev <= 1:
356                 return D
357         else:
358             if Dprev - D <= 1:
359                 return D
360     # convergence typically occurs in 4 rounds or less, this should be unreachable!
361     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
362     raise
363 
364 
365 @view
366 @internal
367 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
368     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
369     return self.get_D(xp, _amp)
370 
371 
372 @view
373 @external
374 def get_virtual_price() -> uint256:
375     """
376     @notice The current virtual price of the pool LP token
377     @dev Useful for calculating profits
378     @return LP token virtual price normalized to 1e18
379     """
380     amp: uint256 = self._A()
381     balances: uint256[N_COINS] = self._balances()
382     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
383     xp: uint256[N_COINS] = self._xp_mem(rates, balances)
384     D: uint256 = self.get_D(xp, amp)
385     # D is in the units similar to DAI (e.g. converted to precision 1e18)
386     # When balanced, D = n * x_u - total virtual value of the portfolio
387     return D * PRECISION / self.totalSupply
388 
389 
390 @view
391 @external
392 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
393     """
394     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
395     @dev This calculation accounts for slippage, but not fees.
396          Needed to prevent front-running, not for precise calculations!
397     @param _amounts Amount of each coin being deposited
398     @param _is_deposit set True for deposits, False for withdrawals
399     @return Expected amount of LP tokens received
400     """
401     amp: uint256 = self._A()
402     balances: uint256[N_COINS] = self._balances()
403     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
404 
405     D0: uint256 = self.get_D_mem(rates, balances, amp)
406     for i in range(N_COINS):
407         amount: uint256 = _amounts[i]
408         if _is_deposit:
409             balances[i] += amount
410         else:
411             balances[i] -= amount
412     D1: uint256 = self.get_D_mem(rates, balances, amp)
413     diff: uint256 = 0
414     if _is_deposit:
415         diff = D1 - D0
416     else:
417         diff = D0 - D1
418     return diff * self.totalSupply / D0
419 
420 
421 @external
422 @nonreentrant('lock')
423 def add_liquidity(
424     _amounts: uint256[N_COINS],
425     _min_mint_amount: uint256,
426     _receiver: address = msg.sender
427 ) -> uint256:
428     """
429     @notice Deposit coins into the pool
430     @param _amounts List of amounts of coins to deposit
431     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
432     @param _receiver Address that owns the minted LP tokens
433     @return Amount of LP tokens received by depositing
434     """
435     amp: uint256 = self._A()
436     old_balances: uint256[N_COINS] = self._balances()
437     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
438 
439     # Initial invariant
440     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
441     new_balances: uint256[N_COINS] = old_balances
442 
443     total_supply: uint256 = self.totalSupply
444     for i in range(N_COINS):
445         amount: uint256 = _amounts[i]
446         if amount == 0:
447             assert total_supply > 0
448         else:
449             coin: address = self.coins[i]
450             initial: uint256 = ERC20(coin).balanceOf(self)
451             response: Bytes[32] = raw_call(
452                 coin,
453                 concat(
454                     method_id("transferFrom(address,address,uint256)"),
455                     convert(msg.sender, bytes32),
456                     convert(self, bytes32),
457                     convert(amount, bytes32),
458                 ),
459                 max_outsize=32,
460             )
461             if len(response) > 0:
462                 assert convert(response, bool)
463             new_balances[i] += ERC20(coin).balanceOf(self) - initial
464 
465     # Invariant after change
466     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
467     assert D1 > D0
468 
469     # We need to recalculate the invariant accounting for fees
470     # to calculate fair user's share
471     fees: uint256[N_COINS] = empty(uint256[N_COINS])
472     mint_amount: uint256 = 0
473     if total_supply > 0:
474         # Only account for fees if we are not the first to deposit
475         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
476         for i in range(N_COINS):
477             ideal_balance: uint256 = D1 * old_balances[i] / D0
478             difference: uint256 = 0
479             new_balance: uint256 = new_balances[i]
480             if ideal_balance > new_balance:
481                 difference = ideal_balance - new_balance
482             else:
483                 difference = new_balance - ideal_balance
484             fees[i] = base_fee * difference / FEE_DENOMINATOR
485             self.admin_balances[i] += fees[i] * ADMIN_FEE / FEE_DENOMINATOR
486             new_balances[i] -= fees[i]
487         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
488         mint_amount = total_supply * (D2 - D0) / D0
489     else:
490         mint_amount = D1  # Take the dust if there was any
491 
492     assert mint_amount >= _min_mint_amount
493 
494     # Mint pool tokens
495     total_supply += mint_amount
496     self.balanceOf[_receiver] += mint_amount
497     self.totalSupply = total_supply
498     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
499     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
500 
501     return mint_amount
502 
503 
504 @view
505 @internal
506 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
507     # x in the input is converted to the same price/precision
508 
509     assert i != j       # dev: same coin
510     assert j >= 0       # dev: j below zero
511     assert j < N_COINS  # dev: j above N_COINS
512 
513     # should be unreachable, but good for safety
514     assert i >= 0
515     assert i < N_COINS
516 
517     amp: uint256 = self._A()
518     D: uint256 = self.get_D(xp, amp)
519     S_: uint256 = 0
520     _x: uint256 = 0
521     y_prev: uint256 = 0
522     c: uint256 = D
523     Ann: uint256 = amp * N_COINS
524 
525     for _i in range(N_COINS):
526         if _i == i:
527             _x = x
528         elif _i != j:
529             _x = xp[_i]
530         else:
531             continue
532         S_ += _x
533         c = c * D / (_x * N_COINS)
534 
535     c = c * D * A_PRECISION / (Ann * N_COINS)
536     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
537     y: uint256 = D
538 
539     for _i in range(255):
540         y_prev = y
541         y = (y*y + c) / (2 * y + b - D)
542         # Equality with the precision of 1
543         if y > y_prev:
544             if y - y_prev <= 1:
545                 return y
546         else:
547             if y_prev - y <= 1:
548                 return y
549     raise
550 
551 
552 @view
553 @external
554 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
555     """
556     @notice Calculate the current output dy given input dx
557     @dev Index values can be found via the `coins` public getter method
558     @param i Index value for the coin to send
559     @param j Index valie of the coin to recieve
560     @param dx Amount of `i` being exchanged
561     @return Amount of `j` predicted
562     """
563     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
564     xp: uint256[N_COINS] = self._xp_mem(rates, self._balances())
565 
566     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
567     y: uint256 = self.get_y(i, j, x, xp)
568     dy: uint256 = xp[j] - y - 1
569     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
570     return (dy - fee) * PRECISION / rates[j]
571 
572 
573 @view
574 @external
575 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
576     """
577     @notice Calculate the current output dy given input dx on underlying
578     @dev Index values can be found via the `coins` public getter method
579     @param i Index value for the coin to send
580     @param j Index valie of the coin to recieve
581     @param dx Amount of `i` being exchanged
582     @return Amount of `j` predicted
583     """
584     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
585     xp: uint256[N_COINS] = self._xp_mem(rates, self._balances())
586 
587     x: uint256 = 0
588     base_i: int128 = 0
589     base_j: int128 = 0
590     meta_i: int128 = 0
591     meta_j: int128 = 0
592 
593     if i != 0:
594         base_i = i - MAX_COIN
595         meta_i = 1
596     if j != 0:
597         base_j = j - MAX_COIN
598         meta_j = 1
599 
600     if i == 0:
601         x = xp[i] + dx * (rates[0] / 10**18)
602     else:
603         if j == 0:
604             # i is from BasePool
605             # At first, get the amount of pool tokens
606             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
607             base_inputs[base_i] = dx
608             # Token amount transformed to underlying "dollars"
609             x = Curve(BASE_POOL).calc_token_amount(base_inputs, True) * rates[1] / PRECISION
610             # Accounting for deposit/withdraw fees approximately
611             x -= x * Curve(BASE_POOL).fee() / (2 * FEE_DENOMINATOR)
612             # Adding number of pool tokens
613             x += xp[MAX_COIN]
614         else:
615             # If both are from the base pool
616             return Curve(BASE_POOL).get_dy(base_i, base_j, dx)
617 
618     # This pool is involved only when in-pool assets are used
619     y: uint256 = self.get_y(meta_i, meta_j, x, xp)
620     dy: uint256 = xp[meta_j] - y - 1
621     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
622 
623     # If output is going via the metapool
624     if j == 0:
625         dy /= (rates[0] / 10**18)
626     else:
627         # j is from BasePool
628         # The fee is already accounted for
629         dy = Curve(BASE_POOL).calc_withdraw_one_coin(dy * PRECISION / rates[1], base_j)
630 
631     return dy
632 
633 
634 @external
635 @nonreentrant('lock')
636 def exchange(
637     i: int128,
638     j: int128,
639     _dx: uint256,
640     _min_dy: uint256,
641     _receiver: address = msg.sender,
642 ) -> uint256:
643     """
644     @notice Perform an exchange between two coins
645     @dev Index values can be found via the `coins` public getter method
646     @param i Index value for the coin to send
647     @param j Index valie of the coin to recieve
648     @param _dx Amount of `i` being exchanged
649     @param _min_dy Minimum amount of `j` to receive
650     @param _receiver Address that receives `j`
651     @return Actual amount of `j` received
652     """
653     old_balances: uint256[N_COINS] = self._balances()
654     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
655 
656     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
657 
658     coin: address = self.coins[i]
659     dx_w_fee: uint256 = ERC20(coin).balanceOf(self)
660     response: Bytes[32] = raw_call(
661         coin,
662         concat(
663             method_id("transferFrom(address,address,uint256)"),
664             convert(msg.sender, bytes32),
665             convert(self, bytes32),
666             convert(_dx, bytes32),
667         ),
668         max_outsize=32,
669     )
670     if len(response) > 0:
671         assert convert(response, bool)
672     dx_w_fee = ERC20(coin).balanceOf(self) - dx_w_fee
673 
674     x: uint256 = xp[i] + dx_w_fee * rates[i] / PRECISION
675     dy: uint256 = xp[j] - self.get_y(i, j, x, xp) - 1  # -1 just in case there were some rounding errors
676     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
677 
678     # Convert all to real units
679     dy = (dy - dy_fee) * PRECISION / rates[j]
680     assert dy >= _min_dy
681 
682     self.admin_balances[j] += (dy_fee * ADMIN_FEE / FEE_DENOMINATOR) * PRECISION / rates[j]
683 
684     response = raw_call(
685         self.coins[j],
686         concat(
687             method_id("transfer(address,uint256)"),
688             convert(_receiver, bytes32),
689             convert(dy, bytes32),
690         ),
691         max_outsize=32,
692     )
693     if len(response) > 0:
694         assert convert(response, bool)
695 
696     log TokenExchange(msg.sender, i, dx_w_fee, j, dy)
697 
698     return dy
699 
700 
701 @external
702 @nonreentrant('lock')
703 def exchange_underlying(
704     i: int128,
705     j: int128,
706     _dx: uint256,
707     _min_dy: uint256,
708     _receiver: address = msg.sender,
709 ) -> uint256:
710     """
711     @notice Perform an exchange between two underlying coins
712     @param i Index value for the underlying coin to send
713     @param j Index valie of the underlying coin to receive
714     @param _dx Amount of `i` being exchanged
715     @param _min_dy Minimum amount of `j` to receive
716     @param _receiver Address that receives `j`
717     @return Actual amount of `j` received
718     """
719     old_balances: uint256[N_COINS] = self._balances()
720     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
721     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
722 
723     base_coins: address[3] = BASE_COINS
724 
725     dy: uint256 = 0
726     base_i: int128 = 0
727     base_j: int128 = 0
728     meta_i: int128 = 0
729     meta_j: int128 = 0
730     x: uint256 = 0
731     input_coin: address = ZERO_ADDRESS
732     output_coin: address = ZERO_ADDRESS
733 
734     if i == 0:
735         input_coin = self.coins[0]
736     else:
737         base_i = i - MAX_COIN
738         meta_i = 1
739         input_coin = base_coins[base_i]
740     if j == 0:
741         output_coin = self.coins[0]
742     else:
743         base_j = j - MAX_COIN
744         meta_j = 1
745         output_coin = base_coins[base_j]
746 
747     dx_w_fee: uint256 = ERC20(input_coin).balanceOf(self)
748     response: Bytes[32] = raw_call(
749         input_coin,
750         concat(
751             method_id("transferFrom(address,address,uint256)"),
752             convert(msg.sender, bytes32),
753             convert(self, bytes32),
754             convert(_dx, bytes32),
755         ),
756         max_outsize=32,
757     )
758     if len(response) > 0:
759         assert convert(response, bool)
760     dx_w_fee = ERC20(input_coin).balanceOf(self) - dx_w_fee
761 
762     if i == 0 or j == 0:
763         if i == 0:
764             x = xp[i] + dx_w_fee * rates[i] / PRECISION
765         else:
766             # i is from BasePool
767             # At first, get the amount of pool tokens
768             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
769             base_inputs[base_i] = dx_w_fee
770             coin_i: address = self.coins[MAX_COIN]
771             # Deposit and measure delta
772             x = ERC20(coin_i).balanceOf(self)
773             Curve(BASE_POOL).add_liquidity(base_inputs, 0)
774             # Need to convert pool token to "virtual" units using rates
775             # dx is also different now
776             dx_w_fee = ERC20(coin_i).balanceOf(self) - x
777             x = dx_w_fee * rates[MAX_COIN] / PRECISION
778             # Adding number of pool tokens
779             x += xp[MAX_COIN]
780 
781         y: uint256 = self.get_y(meta_i, meta_j, x, xp)
782 
783         # Either a real coin or token
784         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
785         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
786 
787         # Convert all to real units
788         # Works for both pool coins and real coins
789         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
790 
791         dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
792         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
793 
794         self.admin_balances[meta_j] += dy_admin_fee
795 
796         # Withdraw from the base pool if needed
797         if j > 0:
798             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
799             Curve(BASE_POOL).remove_liquidity_one_coin(dy, base_j, 0)
800             dy = ERC20(output_coin).balanceOf(self) - out_amount
801 
802         assert dy >= _min_dy
803 
804     else:
805         # If both are from the base pool
806         dy = ERC20(output_coin).balanceOf(self)
807         Curve(BASE_POOL).exchange(base_i, base_j, dx_w_fee, _min_dy)
808         dy = ERC20(output_coin).balanceOf(self) - dy
809 
810     response = raw_call(
811         output_coin,
812         concat(
813             method_id("transfer(address,uint256)"),
814             convert(_receiver, bytes32),
815             convert(dy, bytes32),
816         ),
817         max_outsize=32,
818     )
819     if len(response) > 0:
820         assert convert(response, bool)
821 
822     log TokenExchangeUnderlying(msg.sender, i, _dx, j, dy)
823 
824     return dy
825 
826 
827 @external
828 @nonreentrant('lock')
829 def remove_liquidity(
830     _burn_amount: uint256,
831     _min_amounts: uint256[N_COINS],
832     _receiver: address = msg.sender
833 ) -> uint256[N_COINS]:
834     """
835     @notice Withdraw coins from the pool
836     @dev Withdrawal amounts are based on current deposit ratios
837     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
838     @param _min_amounts Minimum amounts of underlying coins to receive
839     @param _receiver Address that receives the withdrawn coins
840     @return List of amounts of coins that were withdrawn
841     """
842     total_supply: uint256 = self.totalSupply
843     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
844     balances: uint256[N_COINS] = self._balances()
845 
846     for i in range(N_COINS):
847         value: uint256 = balances[i] * _burn_amount / total_supply
848         assert value >= _min_amounts[i]
849         amounts[i] = value
850         response: Bytes[32] = raw_call(
851             self.coins[i],
852             concat(
853                 method_id("transfer(address,uint256)"),
854                 convert(_receiver, bytes32),
855                 convert(value, bytes32),
856             ),
857             max_outsize=32,
858         )
859         if len(response) > 0:
860             assert convert(response, bool)
861     total_supply -= _burn_amount
862     self.balanceOf[msg.sender] -= _burn_amount
863     self.totalSupply = total_supply
864     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
865 
866     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
867 
868     return amounts
869 
870 
871 @external
872 @nonreentrant('lock')
873 def remove_liquidity_imbalance(
874     _amounts: uint256[N_COINS],
875     _max_burn_amount: uint256,
876     _receiver: address = msg.sender
877 ) -> uint256:
878     """
879     @notice Withdraw coins from the pool in an imbalanced amount
880     @param _amounts List of amounts of underlying coins to withdraw
881     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
882     @param _receiver Address that receives the withdrawn coins
883     @return Actual amount of the LP token burned in the withdrawal
884     """
885     amp: uint256 = self._A()
886     old_balances: uint256[N_COINS] = self._balances()
887     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
888     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
889 
890     new_balances: uint256[N_COINS] = old_balances
891     for i in range(N_COINS):
892         amount: uint256 = _amounts[i]
893         if amount != 0:
894             new_balances[i] -= amount
895             response: Bytes[32] = raw_call(
896                 self.coins[i],
897                 concat(
898                     method_id("transfer(address,uint256)"),
899                     convert(_receiver, bytes32),
900                     convert(amount, bytes32),
901                 ),
902                 max_outsize=32,
903             )
904             if len(response) > 0:
905                 assert convert(response, bool)
906     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
907 
908     fees: uint256[N_COINS] = empty(uint256[N_COINS])
909     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
910     for i in range(N_COINS):
911         ideal_balance: uint256 = D1 * old_balances[i] / D0
912         difference: uint256 = 0
913         new_balance: uint256 = new_balances[i]
914         if ideal_balance > new_balance:
915             difference = ideal_balance - new_balance
916         else:
917             difference = new_balance - ideal_balance
918         fees[i] = base_fee * difference / FEE_DENOMINATOR
919         self.admin_balances[i] += fees[i] * ADMIN_FEE / FEE_DENOMINATOR
920         new_balances[i] -= fees[i]
921     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
922 
923     total_supply: uint256 = self.totalSupply
924     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
925     assert burn_amount > 1  # dev: zero tokens burned
926     assert burn_amount <= _max_burn_amount
927 
928     total_supply -= burn_amount
929     self.totalSupply = total_supply
930     self.balanceOf[msg.sender] -= burn_amount
931     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
932     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
933 
934     return burn_amount
935 
936 
937 @view
938 @internal
939 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
940     """
941     Calculate x[i] if one reduces D from being calculated for xp to D
942 
943     Done by solving quadratic equation iteratively.
944     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
945     x_1**2 + b*x_1 = c
946 
947     x_1 = (x_1**2 + c) / (2*x_1 + b)
948     """
949     # x in the input is converted to the same price/precision
950 
951     assert i >= 0  # dev: i below zero
952     assert i < N_COINS  # dev: i above N_COINS
953 
954     S_: uint256 = 0
955     _x: uint256 = 0
956     y_prev: uint256 = 0
957     c: uint256 = D
958     Ann: uint256 = A * N_COINS
959 
960     for _i in range(N_COINS):
961         if _i != i:
962             _x = xp[_i]
963         else:
964             continue
965         S_ += _x
966         c = c * D / (_x * N_COINS)
967 
968     c = c * D * A_PRECISION / (Ann * N_COINS)
969     b: uint256 = S_ + D * A_PRECISION / Ann
970     y: uint256 = D
971 
972     for _i in range(255):
973         y_prev = y
974         y = (y*y + c) / (2 * y + b - D)
975         # Equality with the precision of 1
976         if y > y_prev:
977             if y - y_prev <= 1:
978                 return y
979         else:
980             if y_prev - y <= 1:
981                 return y
982     raise
983 
984 
985 @view
986 @internal
987 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
988     # First, need to calculate
989     # * Get current D
990     # * Solve Eqn against y_i for D - _token_amount
991     amp: uint256 = self._A()
992     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
993     xp: uint256[N_COINS] = self._xp_mem(rates, self._balances())
994     D0: uint256 = self.get_D(xp, amp)
995 
996     total_supply: uint256 = self.totalSupply
997     D1: uint256 = D0 - _burn_amount * D0 / total_supply
998     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
999 
1000     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
1001     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
1002 
1003     for j in range(N_COINS):
1004         dx_expected: uint256 = 0
1005         xp_j: uint256 = xp[j]
1006         if j == i:
1007             dx_expected = xp_j * D1 / D0 - new_y
1008         else:
1009             dx_expected = xp_j - xp_j * D1 / D0
1010         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
1011 
1012     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
1013     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
1014     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
1015 
1016     return [dy, dy_0 - dy]
1017 
1018 
1019 @view
1020 @external
1021 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
1022     """
1023     @notice Calculate the amount received when withdrawing a single coin
1024     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1025     @param i Index value of the coin to withdraw
1026     @return Amount of coin received
1027     """
1028     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
1029 
1030 
1031 @external
1032 @nonreentrant('lock')
1033 def remove_liquidity_one_coin(
1034     _burn_amount: uint256,
1035     i: int128,
1036     _min_received: uint256,
1037     _receiver: address = msg.sender,
1038 ) -> uint256:
1039     """
1040     @notice Withdraw a single coin from the pool
1041     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1042     @param i Index value of the coin to withdraw
1043     @param _min_received Minimum amount of coin to receive
1044     @param _receiver Address that receives the withdrawn coins
1045     @return Amount of coin received
1046     """
1047     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
1048     assert dy[0] >= _min_received
1049 
1050     self.admin_balances[i] += dy[1] * ADMIN_FEE / FEE_DENOMINATOR
1051     total_supply: uint256 = self.totalSupply - _burn_amount
1052     self.totalSupply = total_supply
1053     self.balanceOf[msg.sender] -= _burn_amount
1054     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
1055 
1056     response: Bytes[32] = raw_call(
1057         self.coins[i],
1058         concat(
1059             method_id("transfer(address,uint256)"),
1060             convert(_receiver, bytes32),
1061             convert(dy[0], bytes32),
1062         ),
1063         max_outsize=32,
1064     )
1065     if len(response) > 0:
1066         assert convert(response, bool)
1067 
1068     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
1069 
1070     return dy[0]
1071 
1072 
1073 @external
1074 def ramp_A(_future_A: uint256, _future_time: uint256):
1075     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1076     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
1077     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
1078 
1079     _initial_A: uint256 = self._A()
1080     _future_A_p: uint256 = _future_A * A_PRECISION
1081 
1082     assert _future_A > 0 and _future_A < MAX_A
1083     if _future_A_p < _initial_A:
1084         assert _future_A_p * MAX_A_CHANGE >= _initial_A
1085     else:
1086         assert _future_A_p <= _initial_A * MAX_A_CHANGE
1087 
1088     self.initial_A = _initial_A
1089     self.future_A = _future_A_p
1090     self.initial_A_time = block.timestamp
1091     self.future_A_time = _future_time
1092 
1093     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
1094 
1095 
1096 @external
1097 def stop_ramp_A():
1098     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1099 
1100     current_A: uint256 = self._A()
1101     self.initial_A = current_A
1102     self.future_A = current_A
1103     self.initial_A_time = block.timestamp
1104     self.future_A_time = block.timestamp
1105     # now (block.timestamp < t1) is always False, so we return saved A
1106 
1107     log StopRampA(current_A, block.timestamp)
1108 
1109 
1110 @external
1111 @nonreentrant('lock')
1112 def withdraw_admin_fees():
1113     # transfer coin 0 to Factory and call `convert_fees` to swap it for coin 1
1114     balances: uint256[N_COINS] = self._balances()
1115     factory: address = self.factory
1116     amount: uint256 = self.admin_balances[0]
1117     if amount > 0:
1118         self.admin_balances[0] = 0
1119         coin: address = self.coins[0]
1120         response: Bytes[32] = raw_call(
1121             coin,
1122             concat(
1123                 method_id("transfer(address,uint256)"),
1124                 convert(factory, bytes32),
1125                 convert(amount, bytes32),
1126             ),
1127             max_outsize=32,
1128         )
1129         if len(response) > 0:
1130             assert convert(response, bool)
1131         Factory(factory).convert_metapool_fees()
1132 
1133     # transfer coin 1 to the receiver
1134     amount = self.admin_balances[1]
1135 
1136     if amount > 0:
1137         self.admin_balances[1] = 0
1138         coin: address = self.coins[1]
1139         receiver: address = Factory(factory).get_fee_receiver(self)
1140         response: Bytes[32] = raw_call(
1141             coin,
1142             concat(
1143                 method_id("transfer(address,uint256)"),
1144                 convert(receiver, bytes32),
1145                 convert(amount, bytes32),
1146             ),
1147             max_outsize=32,
1148         )
1149         if len(response) > 0:
1150             assert convert(response, bool)