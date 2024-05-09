1 # @version 0.2.15
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2021 - all rights reserved
6 @notice 3pool metapool implementation contract
7 @dev ERC20 support for return True/revert, return True/False, return None
8 """
9 
10 interface ERC20:
11     def approve(_spender: address, _amount: uint256): nonpayable
12     def balanceOf(_owner: address) -> uint256: view
13 
14 interface Curve:
15     def coins(i: uint256) -> address: view
16     def get_virtual_price() -> uint256: view
17     def calc_token_amount(amounts: uint256[BASE_N_COINS], deposit: bool) -> uint256: view
18     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
19     def fee() -> uint256: view
20     def get_dy(i: int128, j: int128, dx: uint256) -> uint256: view
21     def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
22     def add_liquidity(amounts: uint256[BASE_N_COINS], min_mint_amount: uint256): nonpayable
23     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256): nonpayable
24 
25 interface Factory:
26     def convert_metapool_fees() -> bool: nonpayable
27     def get_fee_receiver(_pool: address) -> address: view
28     def admin() -> address: view
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
81 event RampA:
82     old_A: uint256
83     new_A: uint256
84     initial_time: uint256
85     future_time: uint256
86 
87 event StopRampA:
88     A: uint256
89     t: uint256
90 
91 
92 BASE_POOL: constant(address) = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7
93 BASE_COINS: constant(address[3]) = [
94     0x6B175474E89094C44Da98b954EedeAC495271d0F,  # DAI
95     0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,  # USDC
96     0xdAC17F958D2ee523a2206206994597C13D831ec7,  # USDT
97 ]
98 
99 N_COINS: constant(int128) = 2
100 MAX_COIN: constant(int128) = N_COINS - 1
101 BASE_N_COINS: constant(int128) = 3
102 PRECISION: constant(uint256) = 10 ** 18
103 
104 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
105 ADMIN_FEE: constant(uint256) = 5000000000
106 
107 A_PRECISION: constant(uint256) = 100
108 MAX_A: constant(uint256) = 10 ** 6
109 MAX_A_CHANGE: constant(uint256) = 10
110 MIN_RAMP_TIME: constant(uint256) = 86400
111 
112 factory: address
113 
114 coins: public(address[N_COINS])
115 balances: public(uint256[N_COINS])
116 fee: public(uint256)  # fee * 1e10
117 
118 initial_A: public(uint256)
119 future_A: public(uint256)
120 initial_A_time: public(uint256)
121 future_A_time: public(uint256)
122 
123 rate_multiplier: uint256
124 
125 name: public(String[64])
126 symbol: public(String[32])
127 
128 balanceOf: public(HashMap[address, uint256])
129 allowance: public(HashMap[address, HashMap[address, uint256]])
130 totalSupply: public(uint256)
131 
132 
133 @external
134 def __init__():
135     # we do this to prevent the implementation contract from being used as a pool
136     self.fee = 31337
137 
138 
139 @external
140 def initialize(
141     _name: String[32],
142     _symbol: String[10],
143     _coin: address,
144     _rate_multiplier: uint256,
145     _A: uint256,
146     _fee: uint256
147 ):
148     """
149     @notice Contract initializer
150     @param _name Name of the new pool
151     @param _symbol Token symbol
152     @param _coin Addresses of ERC20 conracts of coins
153     @param _rate_multiplier Rate multiplier for `_coin` (10 ** (36 - decimals))
154     @param _A Amplification coefficient multiplied by n ** (n - 1)
155     @param _fee Fee to charge for exchanges
156     """
157     # check if fee was already set to prevent initializing contract twice
158     assert self.fee == 0
159 
160     A: uint256 = _A * A_PRECISION
161     self.coins = [_coin, 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490]
162     self.rate_multiplier = _rate_multiplier
163     self.initial_A = A
164     self.future_A = A
165     self.fee = _fee
166     self.factory = msg.sender
167 
168     self.name = concat("Curve.fi Factory USD Metapool: ", _name)
169     self.symbol = concat(_symbol, "3CRV-f")
170 
171     for coin in BASE_COINS:
172         ERC20(coin).approve(BASE_POOL, MAX_UINT256)
173 
174     # fire a transfer event so block explorers identify the contract as an ERC20
175     log Transfer(ZERO_ADDRESS, self, 0)
176 
177 
178 ### ERC20 Functionality ###
179 
180 @view
181 @external
182 def decimals() -> uint256:
183     """
184     @notice Get the number of decimals for this token
185     @dev Implemented as a view method to reduce gas costs
186     @return uint256 decimal places
187     """
188     return 18
189 
190 
191 @internal
192 def _transfer(_from: address, _to: address, _value: uint256):
193     # # NOTE: vyper does not allow underflows
194     # #       so the following subtraction would revert on insufficient balance
195     self.balanceOf[_from] -= _value
196     self.balanceOf[_to] += _value
197 
198     log Transfer(_from, _to, _value)
199 
200 
201 @external
202 def transfer(_to : address, _value : uint256) -> bool:
203     """
204     @dev Transfer token for a specified address
205     @param _to The address to transfer to.
206     @param _value The amount to be transferred.
207     """
208     self._transfer(msg.sender, _to, _value)
209     return True
210 
211 
212 @external
213 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
214     """
215      @dev Transfer tokens from one address to another.
216      @param _from address The address which you want to send tokens from
217      @param _to address The address which you want to transfer to
218      @param _value uint256 the amount of tokens to be transferred
219     """
220     self._transfer(_from, _to, _value)
221 
222     _allowance: uint256 = self.allowance[_from][msg.sender]
223     if _allowance != MAX_UINT256:
224         self.allowance[_from][msg.sender] = _allowance - _value
225 
226     return True
227 
228 
229 @external
230 def approve(_spender : address, _value : uint256) -> bool:
231     """
232     @notice Approve the passed address to transfer the specified amount of
233             tokens on behalf of msg.sender
234     @dev Beware that changing an allowance via this method brings the risk that
235          someone may use both the old and new allowance by unfortunate transaction
236          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237     @param _spender The address which will transfer the funds
238     @param _value The amount of tokens that may be transferred
239     @return bool success
240     """
241     self.allowance[msg.sender][_spender] = _value
242 
243     log Approval(msg.sender, _spender, _value)
244     return True
245 
246 
247 ### StableSwap Functionality ###
248 
249 @view
250 @internal
251 def _A() -> uint256:
252     """
253     Handle ramping A up or down
254     """
255     t1: uint256 = self.future_A_time
256     A1: uint256 = self.future_A
257 
258     if block.timestamp < t1:
259         A0: uint256 = self.initial_A
260         t0: uint256 = self.initial_A_time
261         # Expressions in uint256 cannot have negative numbers, thus "if"
262         if A1 > A0:
263             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
264         else:
265             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
266 
267     else:  # when t1 == 0 or block.timestamp >= t1
268         return A1
269 
270 
271 @view
272 @external
273 def admin_fee() -> uint256:
274     return ADMIN_FEE
275 
276 
277 @view
278 @external
279 def A() -> uint256:
280     return self._A() / A_PRECISION
281 
282 
283 @view
284 @external
285 def A_precise() -> uint256:
286     return self._A()
287 
288 
289 @pure
290 @internal
291 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
292     result: uint256[N_COINS] = empty(uint256[N_COINS])
293     for i in range(N_COINS):
294         result[i] = _rates[i] * _balances[i] / PRECISION
295     return result
296 
297 
298 @pure
299 @internal
300 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
301     """
302     D invariant calculation in non-overflowing integer operations
303     iteratively
304 
305     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
306 
307     Converging solution:
308     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
309     """
310     S: uint256 = 0
311     Dprev: uint256 = 0
312     for x in _xp:
313         S += x
314     if S == 0:
315         return 0
316 
317     D: uint256 = S
318     Ann: uint256 = _amp * N_COINS
319     for i in range(255):
320         D_P: uint256 = D
321         for x in _xp:
322             D_P = D_P * D / (x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
323         Dprev = D
324         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
325         # Equality with the precision of 1
326         if D > Dprev:
327             if D - Dprev <= 1:
328                 return D
329         else:
330             if Dprev - D <= 1:
331                 return D
332     # convergence typically occurs in 4 rounds or less, this should be unreachable!
333     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
334     raise
335 
336 
337 @view
338 @internal
339 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
340     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
341     return self.get_D(xp, _amp)
342 
343 
344 @view
345 @external
346 def get_virtual_price() -> uint256:
347     """
348     @notice The current virtual price of the pool LP token
349     @dev Useful for calculating profits
350     @return LP token virtual price normalized to 1e18
351     """
352     amp: uint256 = self._A()
353     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
354     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
355     D: uint256 = self.get_D(xp, amp)
356     # D is in the units similar to DAI (e.g. converted to precision 1e18)
357     # When balanced, D = n * x_u - total virtual value of the portfolio
358     return D * PRECISION / self.totalSupply
359 
360 
361 @view
362 @external
363 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
364     """
365     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
366     @dev This calculation accounts for slippage, but not fees.
367          Needed to prevent front-running, not for precise calculations!
368     @param _amounts Amount of each coin being deposited
369     @param _is_deposit set True for deposits, False for withdrawals
370     @return Expected amount of LP tokens received
371     """
372     amp: uint256 = self._A()
373     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
374     balances: uint256[N_COINS] = self.balances
375 
376     D0: uint256 = self.get_D_mem(rates, balances, amp)
377     for i in range(N_COINS):
378         amount: uint256 = _amounts[i]
379         if _is_deposit:
380             balances[i] += amount
381         else:
382             balances[i] -= amount
383     D1: uint256 = self.get_D_mem(rates, balances, amp)
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
407     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
408 
409     # Initial invariant
410     old_balances: uint256[N_COINS] = self.balances
411     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
412     new_balances: uint256[N_COINS] = old_balances
413 
414     total_supply: uint256 = self.totalSupply
415     for i in range(N_COINS):
416         amount: uint256 = _amounts[i]
417         if amount == 0:
418             assert total_supply > 0
419         else:
420             response: Bytes[32] = raw_call(
421                 self.coins[i],
422                 concat(
423                     method_id("transferFrom(address,address,uint256)"),
424                     convert(msg.sender, bytes32),
425                     convert(self, bytes32),
426                     convert(amount, bytes32),
427                 ),
428                 max_outsize=32,
429             )
430             if len(response) > 0:
431                 assert convert(response, bool)
432             new_balances[i] += amount
433 
434     # Invariant after change
435     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
436     assert D1 > D0
437 
438     # We need to recalculate the invariant accounting for fees
439     # to calculate fair user's share
440     fees: uint256[N_COINS] = empty(uint256[N_COINS])
441     mint_amount: uint256 = 0
442     if total_supply > 0:
443         # Only account for fees if we are not the first to deposit
444         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
445         for i in range(N_COINS):
446             ideal_balance: uint256 = D1 * old_balances[i] / D0
447             difference: uint256 = 0
448             new_balance: uint256 = new_balances[i]
449             if ideal_balance > new_balance:
450                 difference = ideal_balance - new_balance
451             else:
452                 difference = new_balance - ideal_balance
453             fees[i] = base_fee * difference / FEE_DENOMINATOR
454             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
455             new_balances[i] -= fees[i]
456         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
457         mint_amount = total_supply * (D2 - D0) / D0
458     else:
459         self.balances = new_balances
460         mint_amount = D1  # Take the dust if there was any
461 
462     assert mint_amount >= _min_mint_amount
463 
464     # Mint pool tokens
465     total_supply += mint_amount
466     self.balanceOf[_receiver] += mint_amount
467     self.totalSupply = total_supply
468     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
469     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
470 
471     return mint_amount
472 
473 
474 @view
475 @internal
476 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
477     # x in the input is converted to the same price/precision
478 
479     assert i != j       # dev: same coin
480     assert j >= 0       # dev: j below zero
481     assert j < N_COINS  # dev: j above N_COINS
482 
483     # should be unreachable, but good for safety
484     assert i >= 0
485     assert i < N_COINS
486 
487     amp: uint256 = self._A()
488     D: uint256 = self.get_D(xp, amp)
489     S_: uint256 = 0
490     _x: uint256 = 0
491     y_prev: uint256 = 0
492     c: uint256 = D
493     Ann: uint256 = amp * N_COINS
494 
495     for _i in range(N_COINS):
496         if _i == i:
497             _x = x
498         elif _i != j:
499             _x = xp[_i]
500         else:
501             continue
502         S_ += _x
503         c = c * D / (_x * N_COINS)
504 
505     c = c * D * A_PRECISION / (Ann * N_COINS)
506     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
507     y: uint256 = D
508 
509     for _i in range(255):
510         y_prev = y
511         y = (y*y + c) / (2 * y + b - D)
512         # Equality with the precision of 1
513         if y > y_prev:
514             if y - y_prev <= 1:
515                 return y
516         else:
517             if y_prev - y <= 1:
518                 return y
519     raise
520 
521 
522 @view
523 @external
524 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
525     """
526     @notice Calculate the current output dy given input dx
527     @dev Index values can be found via the `coins` public getter method
528     @param i Index value for the coin to send
529     @param j Index valie of the coin to recieve
530     @param dx Amount of `i` being exchanged
531     @return Amount of `j` predicted
532     """
533     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
534     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
535 
536     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
537     y: uint256 = self.get_y(i, j, x, xp)
538     dy: uint256 = xp[j] - y - 1
539     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
540     return (dy - fee) * PRECISION / rates[j]
541 
542 
543 @view
544 @external
545 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
546     """
547     @notice Calculate the current output dy given input dx on underlying
548     @dev Index values can be found via the `coins` public getter method
549     @param i Index value for the coin to send
550     @param j Index valie of the coin to recieve
551     @param dx Amount of `i` being exchanged
552     @return Amount of `j` predicted
553     """
554     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
555     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
556 
557     x: uint256 = 0
558     base_i: int128 = 0
559     base_j: int128 = 0
560     meta_i: int128 = 0
561     meta_j: int128 = 0
562 
563     if i != 0:
564         base_i = i - MAX_COIN
565         meta_i = 1
566     if j != 0:
567         base_j = j - MAX_COIN
568         meta_j = 1
569 
570     if i == 0:
571         x = xp[i] + dx * (rates[0] / 10**18)
572     else:
573         if j == 0:
574             # i is from BasePool
575             # At first, get the amount of pool tokens
576             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
577             base_inputs[base_i] = dx
578             # Token amount transformed to underlying "dollars"
579             x = Curve(BASE_POOL).calc_token_amount(base_inputs, True) * rates[1] / PRECISION
580             # Accounting for deposit/withdraw fees approximately
581             x -= x * Curve(BASE_POOL).fee() / (2 * FEE_DENOMINATOR)
582             # Adding number of pool tokens
583             x += xp[MAX_COIN]
584         else:
585             # If both are from the base pool
586             return Curve(BASE_POOL).get_dy(base_i, base_j, dx)
587 
588     # This pool is involved only when in-pool assets are used
589     y: uint256 = self.get_y(meta_i, meta_j, x, xp)
590     dy: uint256 = xp[meta_j] - y - 1
591     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
592 
593     # If output is going via the metapool
594     if j == 0:
595         dy /= (rates[0] / 10**18)
596     else:
597         # j is from BasePool
598         # The fee is already accounted for
599         dy = Curve(BASE_POOL).calc_withdraw_one_coin(dy * PRECISION / rates[1], base_j)
600 
601     return dy
602 
603 
604 @external
605 @nonreentrant('lock')
606 def exchange(
607     i: int128,
608     j: int128,
609     _dx: uint256,
610     _min_dy: uint256,
611     _receiver: address = msg.sender,
612 ) -> uint256:
613     """
614     @notice Perform an exchange between two coins
615     @dev Index values can be found via the `coins` public getter method
616     @param i Index value for the coin to send
617     @param j Index valie of the coin to recieve
618     @param _dx Amount of `i` being exchanged
619     @param _min_dy Minimum amount of `j` to receive
620     @param _receiver Address that receives `j`
621     @return Actual amount of `j` received
622     """
623     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
624 
625     old_balances: uint256[N_COINS] = self.balances
626     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
627 
628     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
629     y: uint256 = self.get_y(i, j, x, xp)
630 
631     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
632     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
633 
634     # Convert all to real units
635     dy = (dy - dy_fee) * PRECISION / rates[j]
636     assert dy >= _min_dy
637 
638     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
639     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
640 
641     # Change balances exactly in same way as we change actual ERC20 coin amounts
642     self.balances[i] = old_balances[i] + _dx
643     # When rounding errors happen, we undercharge admin fee in favor of LP
644     self.balances[j] = old_balances[j] - dy - dy_admin_fee
645 
646     response: Bytes[32] = raw_call(
647         self.coins[i],
648         concat(
649             method_id("transferFrom(address,address,uint256)"),
650             convert(msg.sender, bytes32),
651             convert(self, bytes32),
652             convert(_dx, bytes32),
653         ),
654         max_outsize=32,
655     )
656     if len(response) > 0:
657         assert convert(response, bool)
658 
659     response = raw_call(
660         self.coins[j],
661         concat(
662             method_id("transfer(address,uint256)"),
663             convert(_receiver, bytes32),
664             convert(dy, bytes32),
665         ),
666         max_outsize=32,
667     )
668     if len(response) > 0:
669         assert convert(response, bool)
670 
671     log TokenExchange(msg.sender, i, _dx, j, dy)
672 
673     return dy
674 
675 
676 @external
677 @nonreentrant('lock')
678 def exchange_underlying(
679     i: int128,
680     j: int128,
681     _dx: uint256,
682     _min_dy: uint256,
683     _receiver: address = msg.sender,
684 ) -> uint256:
685     """
686     @notice Perform an exchange between two underlying coins
687     @param i Index value for the underlying coin to send
688     @param j Index valie of the underlying coin to receive
689     @param _dx Amount of `i` being exchanged
690     @param _min_dy Minimum amount of `j` to receive
691     @param _receiver Address that receives `j`
692     @return Actual amount of `j` received
693     """
694     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
695     old_balances: uint256[N_COINS] = self.balances
696     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
697 
698     base_coins: address[3] = BASE_COINS
699 
700     dy: uint256 = 0
701     base_i: int128 = 0
702     base_j: int128 = 0
703     meta_i: int128 = 0
704     meta_j: int128 = 0
705     x: uint256 = 0
706     input_coin: address = ZERO_ADDRESS
707     output_coin: address = ZERO_ADDRESS
708 
709     if i == 0:
710         input_coin = self.coins[0]
711     else:
712         base_i = i - MAX_COIN
713         meta_i = 1
714         input_coin = base_coins[base_i]
715     if j == 0:
716         output_coin = self.coins[0]
717     else:
718         base_j = j - MAX_COIN
719         meta_j = 1
720         output_coin = base_coins[base_j]
721 
722     response: Bytes[32] = raw_call(
723         input_coin,
724         concat(
725             method_id("transferFrom(address,address,uint256)"),
726             convert(msg.sender, bytes32),
727             convert(self, bytes32),
728             convert(_dx, bytes32),
729         ),
730         max_outsize=32,
731     )
732     if len(response) > 0:
733         assert convert(response, bool)
734 
735     dx: uint256 = _dx
736     if i == 0 or j == 0:
737         if i == 0:
738             x = xp[i] + dx * rates[i] / PRECISION
739         else:
740             # i is from BasePool
741             # At first, get the amount of pool tokens
742             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
743             base_inputs[base_i] = dx
744             coin_i: address = self.coins[MAX_COIN]
745             # Deposit and measure delta
746             x = ERC20(coin_i).balanceOf(self)
747             Curve(BASE_POOL).add_liquidity(base_inputs, 0)
748             # Need to convert pool token to "virtual" units using rates
749             # dx is also different now
750             dx = ERC20(coin_i).balanceOf(self) - x
751             x = dx * rates[MAX_COIN] / PRECISION
752             # Adding number of pool tokens
753             x += xp[MAX_COIN]
754 
755         y: uint256 = self.get_y(meta_i, meta_j, x, xp)
756 
757         # Either a real coin or token
758         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
759         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
760 
761         # Convert all to real units
762         # Works for both pool coins and real coins
763         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
764 
765         dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
766         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
767 
768         # Change balances exactly in same way as we change actual ERC20 coin amounts
769         self.balances[meta_i] = old_balances[meta_i] + dx
770         # When rounding errors happen, we undercharge admin fee in favor of LP
771         self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee
772 
773         # Withdraw from the base pool if needed
774         if j > 0:
775             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
776             Curve(BASE_POOL).remove_liquidity_one_coin(dy, base_j, 0)
777             dy = ERC20(output_coin).balanceOf(self) - out_amount
778 
779         assert dy >= _min_dy
780 
781     else:
782         # If both are from the base pool
783         dy = ERC20(output_coin).balanceOf(self)
784         Curve(BASE_POOL).exchange(base_i, base_j, dx, _min_dy)
785         dy = ERC20(output_coin).balanceOf(self) - dy
786 
787     response = raw_call(
788         output_coin,
789         concat(
790             method_id("transfer(address,uint256)"),
791             convert(_receiver, bytes32),
792             convert(dy, bytes32),
793         ),
794         max_outsize=32,
795     )
796     if len(response) > 0:
797         assert convert(response, bool)
798 
799     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
800 
801     return dy
802 
803 
804 @external
805 @nonreentrant('lock')
806 def remove_liquidity(
807     _burn_amount: uint256,
808     _min_amounts: uint256[N_COINS],
809     _receiver: address = msg.sender
810 ) -> uint256[N_COINS]:
811     """
812     @notice Withdraw coins from the pool
813     @dev Withdrawal amounts are based on current deposit ratios
814     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
815     @param _min_amounts Minimum amounts of underlying coins to receive
816     @param _receiver Address that receives the withdrawn coins
817     @return List of amounts of coins that were withdrawn
818     """
819     total_supply: uint256 = self.totalSupply
820     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
821 
822     for i in range(N_COINS):
823         old_balance: uint256 = self.balances[i]
824         value: uint256 = old_balance * _burn_amount / total_supply
825         assert value >= _min_amounts[i]
826         self.balances[i] = old_balance - value
827         amounts[i] = value
828         response: Bytes[32] = raw_call(
829             self.coins[i],
830             concat(
831                 method_id("transfer(address,uint256)"),
832                 convert(_receiver, bytes32),
833                 convert(value, bytes32),
834             ),
835             max_outsize=32,
836         )
837         if len(response) > 0:
838             assert convert(response, bool)
839 
840 
841     total_supply -= _burn_amount
842     self.balanceOf[msg.sender] -= _burn_amount
843     self.totalSupply = total_supply
844     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
845 
846     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
847 
848     return amounts
849 
850 
851 @external
852 @nonreentrant('lock')
853 def remove_liquidity_imbalance(
854     _amounts: uint256[N_COINS],
855     _max_burn_amount: uint256,
856     _receiver: address = msg.sender
857 ) -> uint256:
858     """
859     @notice Withdraw coins from the pool in an imbalanced amount
860     @param _amounts List of amounts of underlying coins to withdraw
861     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
862     @param _receiver Address that receives the withdrawn coins
863     @return Actual amount of the LP token burned in the withdrawal
864     """
865     amp: uint256 = self._A()
866     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
867     old_balances: uint256[N_COINS] = self.balances
868     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
869 
870     new_balances: uint256[N_COINS] = old_balances
871     for i in range(N_COINS):
872         amount: uint256 = _amounts[i]
873         if amount != 0:
874             new_balances[i] -= amount
875             response: Bytes[32] = raw_call(
876                 self.coins[i],
877                 concat(
878                     method_id("transfer(address,uint256)"),
879                     convert(_receiver, bytes32),
880                     convert(amount, bytes32),
881                 ),
882                 max_outsize=32,
883             )
884             if len(response) > 0:
885                 assert convert(response, bool)
886     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
887 
888     fees: uint256[N_COINS] = empty(uint256[N_COINS])
889     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
890     for i in range(N_COINS):
891         ideal_balance: uint256 = D1 * old_balances[i] / D0
892         difference: uint256 = 0
893         new_balance: uint256 = new_balances[i]
894         if ideal_balance > new_balance:
895             difference = ideal_balance - new_balance
896         else:
897             difference = new_balance - ideal_balance
898         fees[i] = base_fee * difference / FEE_DENOMINATOR
899         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
900         new_balances[i] -= fees[i]
901     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
902 
903     total_supply: uint256 = self.totalSupply
904     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
905     assert burn_amount > 1  # dev: zero tokens burned
906     assert burn_amount <= _max_burn_amount
907 
908     total_supply -= burn_amount
909     self.totalSupply = total_supply
910     self.balanceOf[msg.sender] -= burn_amount
911     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
912     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
913 
914     return burn_amount
915 
916 
917 @view
918 @internal
919 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
920     """
921     Calculate x[i] if one reduces D from being calculated for xp to D
922 
923     Done by solving quadratic equation iteratively.
924     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
925     x_1**2 + b*x_1 = c
926 
927     x_1 = (x_1**2 + c) / (2*x_1 + b)
928     """
929     # x in the input is converted to the same price/precision
930 
931     assert i >= 0  # dev: i below zero
932     assert i < N_COINS  # dev: i above N_COINS
933 
934     S_: uint256 = 0
935     _x: uint256 = 0
936     y_prev: uint256 = 0
937     c: uint256 = D
938     Ann: uint256 = A * N_COINS
939 
940     for _i in range(N_COINS):
941         if _i != i:
942             _x = xp[_i]
943         else:
944             continue
945         S_ += _x
946         c = c * D / (_x * N_COINS)
947 
948     c = c * D * A_PRECISION / (Ann * N_COINS)
949     b: uint256 = S_ + D * A_PRECISION / Ann
950     y: uint256 = D
951 
952     for _i in range(255):
953         y_prev = y
954         y = (y*y + c) / (2 * y + b - D)
955         # Equality with the precision of 1
956         if y > y_prev:
957             if y - y_prev <= 1:
958                 return y
959         else:
960             if y_prev - y <= 1:
961                 return y
962     raise
963 
964 
965 @view
966 @internal
967 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
968     # First, need to calculate
969     # * Get current D
970     # * Solve Eqn against y_i for D - _token_amount
971     amp: uint256 = self._A()
972     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
973     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
974     D0: uint256 = self.get_D(xp, amp)
975 
976     total_supply: uint256 = self.totalSupply
977     D1: uint256 = D0 - _burn_amount * D0 / total_supply
978     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
979 
980     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
981     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
982 
983     for j in range(N_COINS):
984         dx_expected: uint256 = 0
985         xp_j: uint256 = xp[j]
986         if j == i:
987             dx_expected = xp_j * D1 / D0 - new_y
988         else:
989             dx_expected = xp_j - xp_j * D1 / D0
990         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
991 
992     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
993     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
994     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
995 
996     return [dy, dy_0 - dy]
997 
998 
999 @view
1000 @external
1001 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
1002     """
1003     @notice Calculate the amount received when withdrawing a single coin
1004     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1005     @param i Index value of the coin to withdraw
1006     @return Amount of coin received
1007     """
1008     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
1009 
1010 
1011 @external
1012 @nonreentrant('lock')
1013 def remove_liquidity_one_coin(
1014     _burn_amount: uint256,
1015     i: int128,
1016     _min_received: uint256,
1017     _receiver: address = msg.sender,
1018 ) -> uint256:
1019     """
1020     @notice Withdraw a single coin from the pool
1021     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1022     @param i Index value of the coin to withdraw
1023     @param _min_received Minimum amount of coin to receive
1024     @param _receiver Address that receives the withdrawn coins
1025     @return Amount of coin received
1026     """
1027     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
1028     assert dy[0] >= _min_received
1029 
1030     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
1031     total_supply: uint256 = self.totalSupply - _burn_amount
1032     self.totalSupply = total_supply
1033     self.balanceOf[msg.sender] -= _burn_amount
1034     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
1035 
1036     response: Bytes[32] = raw_call(
1037         self.coins[i],
1038         concat(
1039             method_id("transfer(address,uint256)"),
1040             convert(_receiver, bytes32),
1041             convert(dy[0], bytes32),
1042         ),
1043         max_outsize=32,
1044     )
1045     if len(response) > 0:
1046         assert convert(response, bool)
1047 
1048     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
1049 
1050     return dy[0]
1051 
1052 
1053 @external
1054 def ramp_A(_future_A: uint256, _future_time: uint256):
1055     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1056     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
1057     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
1058 
1059     _initial_A: uint256 = self._A()
1060     _future_A_p: uint256 = _future_A * A_PRECISION
1061 
1062     assert _future_A > 0 and _future_A < MAX_A
1063     if _future_A_p < _initial_A:
1064         assert _future_A_p * MAX_A_CHANGE >= _initial_A
1065     else:
1066         assert _future_A_p <= _initial_A * MAX_A_CHANGE
1067 
1068     self.initial_A = _initial_A
1069     self.future_A = _future_A_p
1070     self.initial_A_time = block.timestamp
1071     self.future_A_time = _future_time
1072 
1073     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
1074 
1075 
1076 @external
1077 def stop_ramp_A():
1078     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1079 
1080     current_A: uint256 = self._A()
1081     self.initial_A = current_A
1082     self.future_A = current_A
1083     self.initial_A_time = block.timestamp
1084     self.future_A_time = block.timestamp
1085     # now (block.timestamp < t1) is always False, so we return saved A
1086 
1087     log StopRampA(current_A, block.timestamp)
1088 
1089 
1090 @view
1091 @external
1092 def admin_balances(i: uint256) -> uint256:
1093     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1094 
1095 
1096 @external
1097 def withdraw_admin_fees():
1098     # transfer coin 0 to Factory and call `convert_fees` to swap it for coin 1
1099     factory: address = self.factory
1100     coin: address = self.coins[0]
1101     amount: uint256 = ERC20(coin).balanceOf(self) - self.balances[0]
1102     if amount > 0:
1103         response: Bytes[32] = raw_call(
1104             coin,
1105             concat(
1106                 method_id("transfer(address,uint256)"),
1107                 convert(factory, bytes32),
1108                 convert(amount, bytes32),
1109             ),
1110             max_outsize=32,
1111         )
1112         if len(response) > 0:
1113             assert convert(response, bool)
1114         Factory(factory).convert_metapool_fees()
1115 
1116     # transfer coin 1 to the receiver
1117     coin = self.coins[1]
1118     amount = ERC20(coin).balanceOf(self) - self.balances[1]
1119     if amount > 0:
1120         receiver: address = Factory(factory).get_fee_receiver(self)
1121         response: Bytes[32] = raw_call(
1122             coin,
1123             concat(
1124                 method_id("transfer(address,uint256)"),
1125                 convert(receiver, bytes32),
1126                 convert(amount, bytes32),
1127             ),
1128             max_outsize=32,
1129         )
1130         if len(response) > 0:
1131             assert convert(response, bool)