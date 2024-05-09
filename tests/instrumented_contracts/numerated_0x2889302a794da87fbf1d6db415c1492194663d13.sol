1 # @version 0.3.9
2 
3 """
4 @title CurveTricryptoOptimizedWETH
5 @author Curve.Fi
6 @license Copyright (c) Curve.Fi, 2020-2023 - all rights reserved
7 @notice A Curve AMM pool for 3 unpegged assets (e.g. ETH, BTC, USD).
8 @dev All prices in the AMM are with respect to the first token in the pool.
9 """
10 
11 from vyper.interfaces import ERC20
12 implements: ERC20  # <--------------------- AMM contract is also the LP token.
13 
14 # --------------------------------- Interfaces -------------------------------
15 
16 interface Math:
17     def geometric_mean(_x: uint256[N_COINS]) -> uint256: view
18     def wad_exp(_power: int256) -> uint256: view
19     def cbrt(x: uint256) -> uint256: view
20     def reduction_coefficient(
21         x: uint256[N_COINS], fee_gamma: uint256
22     ) -> uint256: view
23     def newton_D(
24         ANN: uint256,
25         gamma: uint256,
26         x_unsorted: uint256[N_COINS],
27         K0_prev: uint256
28     ) -> uint256: view
29     def get_y(
30         ANN: uint256,
31         gamma: uint256,
32         x: uint256[N_COINS],
33         D: uint256,
34         i: uint256,
35     ) -> uint256[2]: view
36     def get_p(
37         _xp: uint256[N_COINS], _D: uint256, _A_gamma: uint256[2],
38     ) -> uint256[N_COINS-1]: view
39 
40 interface WETH:
41     def deposit(): payable
42     def withdraw(_amount: uint256): nonpayable
43 
44 interface Factory:
45     def admin() -> address: view
46     def fee_receiver() -> address: view
47     def views_implementation() -> address: view
48 
49 interface Views:
50     def calc_token_amount(
51         amounts: uint256[N_COINS], deposit: bool, swap: address
52     ) -> uint256: view
53     def get_dy(
54         i: uint256, j: uint256, dx: uint256, swap: address
55     ) -> uint256: view
56     def get_dx(
57         i: uint256, j: uint256, dy: uint256, swap: address
58     ) -> uint256: view
59 
60 
61 # ------------------------------- Events -------------------------------------
62 
63 event Transfer:
64     sender: indexed(address)
65     receiver: indexed(address)
66     value: uint256
67 
68 event Approval:
69     owner: indexed(address)
70     spender: indexed(address)
71     value: uint256
72 
73 event TokenExchange:
74     buyer: indexed(address)
75     sold_id: uint256
76     tokens_sold: uint256
77     bought_id: uint256
78     tokens_bought: uint256
79     fee: uint256
80     packed_price_scale: uint256
81 
82 event AddLiquidity:
83     provider: indexed(address)
84     token_amounts: uint256[N_COINS]
85     fee: uint256
86     token_supply: uint256
87     packed_price_scale: uint256
88 
89 event RemoveLiquidity:
90     provider: indexed(address)
91     token_amounts: uint256[N_COINS]
92     token_supply: uint256
93 
94 event RemoveLiquidityOne:
95     provider: indexed(address)
96     token_amount: uint256
97     coin_index: uint256
98     coin_amount: uint256
99     approx_fee: uint256
100     packed_price_scale: uint256
101 
102 event CommitNewParameters:
103     deadline: indexed(uint256)
104     mid_fee: uint256
105     out_fee: uint256
106     fee_gamma: uint256
107     allowed_extra_profit: uint256
108     adjustment_step: uint256
109     ma_time: uint256
110 
111 event NewParameters:
112     mid_fee: uint256
113     out_fee: uint256
114     fee_gamma: uint256
115     allowed_extra_profit: uint256
116     adjustment_step: uint256
117     ma_time: uint256
118 
119 event RampAgamma:
120     initial_A: uint256
121     future_A: uint256
122     initial_gamma: uint256
123     future_gamma: uint256
124     initial_time: uint256
125     future_time: uint256
126 
127 event StopRampA:
128     current_A: uint256
129     current_gamma: uint256
130     time: uint256
131 
132 event ClaimAdminFee:
133     admin: indexed(address)
134     tokens: uint256
135 
136 
137 # ----------------------- Storage/State Variables ----------------------------
138 
139 WETH20: public(immutable(address))
140 
141 N_COINS: constant(uint256) = 3
142 PRECISION: constant(uint256) = 10**18  # <------- The precision to convert to.
143 A_MULTIPLIER: constant(uint256) = 10000
144 packed_precisions: uint256
145 
146 MATH: public(immutable(Math))
147 coins: public(immutable(address[N_COINS]))
148 factory: public(address)
149 
150 price_scale_packed: uint256  # <------------------------ Internal price scale.
151 price_oracle_packed: uint256  # <------- Price target given by moving average.
152 
153 last_prices_packed: uint256
154 last_prices_timestamp: public(uint256)
155 
156 initial_A_gamma: public(uint256)
157 initial_A_gamma_time: public(uint256)
158 
159 future_A_gamma: public(uint256)
160 future_A_gamma_time: public(uint256)  # <------ Time when ramping is finished.
161 #         This value is 0 (default) when pool is first deployed, and only gets
162 #        populated by block.timestamp + future_time in `ramp_A_gamma` when the
163 #                      ramping process is initiated. After ramping is finished
164 #      (i.e. self.future_A_gamma_time < block.timestamp), the variable is left
165 #                                                            and not set to 0.
166 
167 balances: public(uint256[N_COINS])
168 D: public(uint256)
169 xcp_profit: public(uint256)
170 xcp_profit_a: public(uint256)  # <--- Full profit at last claim of admin fees.
171 
172 virtual_price: public(uint256)  # <------ Cached (fast to read) virtual price.
173 #                          The cached `virtual_price` is also used internally.
174 
175 # -------------- Params that affect how price_scale get adjusted -------------
176 
177 packed_rebalancing_params: public(uint256)  # <---------- Contains rebalancing
178 #               parameters allowed_extra_profit, adjustment_step, and ma_time.
179 
180 future_packed_rebalancing_params: uint256
181 
182 # ---------------- Fee params that determine dynamic fees --------------------
183 
184 packed_fee_params: public(uint256)  # <---- Packs mid_fee, out_fee, fee_gamma.
185 future_packed_fee_params: uint256
186 
187 ADMIN_FEE: public(constant(uint256)) = 5 * 10**9  # <----- 50% of earned fees.
188 MIN_FEE: constant(uint256) = 5 * 10**5  # <-------------------------- 0.5 BPS.
189 MAX_FEE: constant(uint256) = 10 * 10**9
190 NOISE_FEE: constant(uint256) = 10**5  # <---------------------------- 0.1 BPS.
191 
192 # ----------------------- Admin params ---------------------------------------
193 
194 admin_actions_deadline: public(uint256)
195 
196 ADMIN_ACTIONS_DELAY: constant(uint256) = 3 * 86400
197 MIN_RAMP_TIME: constant(uint256) = 86400
198 
199 MIN_A: constant(uint256) = N_COINS**N_COINS * A_MULTIPLIER / 100
200 MAX_A: constant(uint256) = 1000 * A_MULTIPLIER * N_COINS**N_COINS
201 MAX_A_CHANGE: constant(uint256) = 10
202 MIN_GAMMA: constant(uint256) = 10**10
203 MAX_GAMMA: constant(uint256) = 5 * 10**16
204 
205 PRICE_SIZE: constant(uint128) = 256 / (N_COINS - 1)
206 PRICE_MASK: constant(uint256) = 2**PRICE_SIZE - 1
207 
208 # ----------------------- ERC20 Specific vars --------------------------------
209 
210 name: public(immutable(String[64]))
211 symbol: public(immutable(String[32]))
212 decimals: public(constant(uint8)) = 18
213 version: public(constant(String[8])) = "v2.0.0"
214 
215 balanceOf: public(HashMap[address, uint256])
216 allowance: public(HashMap[address, HashMap[address, uint256]])
217 totalSupply: public(uint256)
218 nonces: public(HashMap[address, uint256])
219 
220 EIP712_TYPEHASH: constant(bytes32) = keccak256(
221     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)"
222 )
223 EIP2612_TYPEHASH: constant(bytes32) = keccak256(
224     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
225 )
226 VERSION_HASH: constant(bytes32) = keccak256(version)
227 NAME_HASH: immutable(bytes32)
228 CACHED_CHAIN_ID: immutable(uint256)
229 salt: public(immutable(bytes32))
230 CACHED_DOMAIN_SEPARATOR: immutable(bytes32)
231 
232 
233 # ----------------------- Contract -------------------------------------------
234 
235 @external
236 def __init__(
237     _name: String[64],
238     _symbol: String[32],
239     _coins: address[N_COINS],
240     _math: address,
241     _weth: address,
242     _salt: bytes32,
243     packed_precisions: uint256,
244     packed_A_gamma: uint256,
245     packed_fee_params: uint256,
246     packed_rebalancing_params: uint256,
247     packed_prices: uint256,
248 ):
249 
250     WETH20 = _weth
251     MATH = Math(_math)
252 
253     self.factory = msg.sender
254 
255     name = _name
256     symbol = _symbol
257     coins = _coins
258 
259     self.packed_precisions = packed_precisions  # <------- Precisions of coins
260     #                            are calculated as 10**(18 - coin.decimals()).
261 
262     self.initial_A_gamma = packed_A_gamma  # <------------------- A and gamma.
263     self.future_A_gamma = packed_A_gamma
264 
265     self.packed_rebalancing_params = packed_rebalancing_params  # <-- Contains
266     #               rebalancing params: allowed_extra_profit, adjustment_step,
267     #                                                         and ma_exp_time.
268 
269     self.packed_fee_params = packed_fee_params  # <-------------- Contains Fee
270     #                                  params: mid_fee, out_fee and fee_gamma.
271 
272     self.price_scale_packed = packed_prices
273     self.price_oracle_packed = packed_prices
274     self.last_prices_packed = packed_prices
275     self.last_prices_timestamp = block.timestamp
276     self.xcp_profit_a = 10**18
277 
278     #         Cache DOMAIN_SEPARATOR. If chain.id is not CACHED_CHAIN_ID, then
279     #     DOMAIN_SEPARATOR will be re-calculated each time `permit` is called.
280     #                   Otherwise, it will always use CACHED_DOMAIN_SEPARATOR.
281     #                       see: `_domain_separator()` for its implementation.
282     NAME_HASH = keccak256(name)
283     salt = _salt
284     CACHED_CHAIN_ID = chain.id
285     CACHED_DOMAIN_SEPARATOR = keccak256(
286         _abi_encode(
287             EIP712_TYPEHASH,
288             NAME_HASH,
289             VERSION_HASH,
290             chain.id,
291             self,
292             salt,
293         )
294     )
295 
296     log Transfer(empty(address), self, 0)  # <------- Fire empty transfer from
297     #                                       0x0 to self for indexers to catch.
298 
299 
300 # ------------------- Token transfers in and out of the AMM ------------------
301 
302 
303 @payable
304 @external
305 def __default__():
306     if msg.value > 0:
307         assert WETH20 in coins
308 
309 
310 @internal
311 def _transfer_in(
312     _coin: address,
313     dx: uint256,
314     dy: uint256,
315     mvalue: uint256,
316     callbacker: address,
317     callback_sig: bytes32,
318     sender: address,
319     receiver: address,
320     use_eth: bool
321 ):
322     """
323     @notice Transfers `_coin` from `sender` to `self` and calls `callback_sig`
324             if it is not empty.
325     @dev The callback sig must have the following args:
326          sender: address
327          receiver: address
328          coin: address
329          dx: uint256
330          dy: uint256
331     @params _coin address of the coin to transfer in.
332     @params dx amount of `_coin` to transfer into the pool.
333     @params dy amount of `_coin` to transfer out of the pool.
334     @params mvalue msg.value if the transfer is ETH, 0 otherwise.
335     @params callbacker address to call `callback_sig` on.
336     @params callback_sig signature of the callback function.
337     @params sender address to transfer `_coin` from.
338     @params receiver address to transfer `_coin` to.
339     @params use_eth True if the transfer is ETH, False otherwise.
340     """
341 
342     if use_eth and _coin == WETH20:
343         assert mvalue == dx  # dev: incorrect eth amount
344     else:
345         assert mvalue == 0  # dev: nonzero eth amount
346 
347         if callback_sig == empty(bytes32):
348 
349             assert ERC20(_coin).transferFrom(
350                 sender, self, dx, default_return_value=True
351             )
352 
353         else:
354 
355             # --------- This part of the _transfer_in logic is only accessible
356             #                                                    by _exchange.
357 
358             #                 First call callback logic and then check if pool
359             #                  gets dx amounts of _coins[i], revert otherwise.
360             b: uint256 = ERC20(_coin).balanceOf(self)
361             raw_call(
362                 callbacker,
363                 concat(
364                     slice(callback_sig, 0, 4),
365                     _abi_encode(sender, receiver, _coin, dx, dy)
366                 )
367             )
368             assert ERC20(_coin).balanceOf(self) - b == dx  # dev: callback didn't give us coins
369             #                                          ^------ note: dx cannot
370             #                   be 0, so the contract MUST receive some _coin.
371 
372         if _coin == WETH20:
373             WETH(WETH20).withdraw(dx)  # <--------- if WETH was transferred in
374             #           previous step and `not use_eth`, withdraw WETH to ETH.
375 
376 
377 @internal
378 def _transfer_out(
379     _coin: address, _amount: uint256, use_eth: bool, receiver: address
380 ):
381     """
382     @notice Transfer a single token from the pool to receiver.
383     @dev This function is called by `remove_liquidity` and
384          `remove_liquidity_one` and `_exchange` methods.
385     @params _coin Address of the token to transfer out
386     @params _amount Amount of token to transfer out
387     @params use_eth Whether to transfer ETH or not
388     @params receiver Address to send the tokens to
389     """
390 
391     if use_eth and _coin == WETH20:
392         raw_call(receiver, b"", value=_amount)
393     else:
394         if _coin == WETH20:
395             WETH(WETH20).deposit(value=_amount)
396 
397         assert ERC20(_coin).transfer(
398             receiver, _amount, default_return_value=True
399         )
400 
401 
402 # -------------------------- AMM Main Functions ------------------------------
403 
404 
405 @payable
406 @external
407 @nonreentrant("lock")
408 def exchange(
409     i: uint256,
410     j: uint256,
411     dx: uint256,
412     min_dy: uint256,
413     use_eth: bool = False,
414     receiver: address = msg.sender
415 ) -> uint256:
416     """
417     @notice Exchange using wrapped native token by default
418     @param i Index value for the input coin
419     @param j Index value for the output coin
420     @param dx Amount of input coin being swapped in
421     @param min_dy Minimum amount of output coin to receive
422     @param use_eth True if the input coin is native token, False otherwise
423     @param receiver Address to send the output coin to. Default is msg.sender
424     @return uint256 Amount of tokens at index j received by the `receiver
425     """
426     return self._exchange(
427         msg.sender,
428         msg.value,
429         i,
430         j,
431         dx,
432         min_dy,
433         use_eth,
434         receiver,
435         empty(address),
436         empty(bytes32)
437     )
438 
439 
440 @payable
441 @external
442 @nonreentrant('lock')
443 def exchange_underlying(
444     i: uint256,
445     j: uint256,
446     dx: uint256,
447     min_dy: uint256,
448     receiver: address = msg.sender
449 ) -> uint256:
450     """
451     @notice Exchange using native token transfers.
452     @param i Index value for the input coin
453     @param j Index value for the output coin
454     @param dx Amount of input coin being swapped in
455     @param min_dy Minimum amount of output coin to receive
456     @param receiver Address to send the output coin to. Default is msg.sender
457     @return uint256 Amount of tokens at index j received by the `receiver
458     """
459     return self._exchange(
460         msg.sender,
461         msg.value,
462         i,
463         j,
464         dx,
465         min_dy,
466         True,
467         receiver,
468         empty(address),
469         empty(bytes32)
470     )
471 
472 
473 @external
474 @nonreentrant('lock')
475 def exchange_extended(
476     i: uint256,
477     j: uint256,
478     dx: uint256,
479     min_dy: uint256,
480     use_eth: bool,
481     sender: address,
482     receiver: address,
483     cb: bytes32
484 ) -> uint256:
485     """
486     @notice Exchange with callback method.
487     @dev This method does not allow swapping in native token, but does allow
488          swaps that transfer out native token from the pool.
489     @dev Does not allow flashloans
490     @dev One use-case is to reduce the number of redundant ERC20 token
491          transfers in zaps.
492     @param i Index value for the input coin
493     @param j Index value for the output coin
494     @param dx Amount of input coin being swapped in
495     @param min_dy Minimum amount of output coin to receive
496     @param use_eth True if output is native token, False otherwise
497     @param sender Address to transfer input coin from
498     @param receiver Address to send the output coin to
499     @param cb Callback signature
500     @return uint256 Amount of tokens at index j received by the `receiver`
501     """
502 
503     assert cb != empty(bytes32)  # dev: No callback specified
504     return self._exchange(
505         sender, 0, i, j, dx, min_dy, use_eth, receiver, msg.sender, cb
506     )  # callbacker should never be self ------------------^
507 
508 
509 @payable
510 @external
511 @nonreentrant("lock")
512 def add_liquidity(
513     amounts: uint256[N_COINS],
514     min_mint_amount: uint256,
515     use_eth: bool = False,
516     receiver: address = msg.sender
517 ) -> uint256:
518     """
519     @notice Adds liquidity into the pool.
520     @param amounts Amounts of each coin to add.
521     @param min_mint_amount Minimum amount of LP to mint.
522     @param use_eth True if native token is being added to the pool.
523     @param receiver Address to send the LP tokens to. Default is msg.sender
524     @return uint256 Amount of LP tokens received by the `receiver
525     """
526 
527     A_gamma: uint256[2] = self._A_gamma()
528     xp: uint256[N_COINS] = self.balances
529     amountsp: uint256[N_COINS] = empty(uint256[N_COINS])
530     xx: uint256[N_COINS] = empty(uint256[N_COINS])
531     d_token: uint256 = 0
532     d_token_fee: uint256 = 0
533     old_D: uint256 = 0
534 
535     assert amounts[0] + amounts[1] + amounts[2] > 0  # dev: no coins to add
536 
537     # --------------------- Get prices, balances -----------------------------
538 
539     precisions: uint256[N_COINS] = self._unpack(self.packed_precisions)
540     packed_price_scale: uint256 = self.price_scale_packed
541     price_scale: uint256[N_COINS-1] = self._unpack_prices(packed_price_scale)
542 
543     # -------------------------------------- Update balances and calculate xp.
544     xp_old: uint256[N_COINS] = xp
545     for i in range(N_COINS):
546         bal: uint256 = xp[i] + amounts[i]
547         xp[i] = bal
548         self.balances[i] = bal
549     xx = xp
550 
551     xp[0] *= precisions[0]
552     xp_old[0] *= precisions[0]
553     for i in range(1, N_COINS):
554         xp[i] = unsafe_div(xp[i] * price_scale[i-1] * precisions[i], PRECISION)
555         xp_old[i] = unsafe_div(
556             xp_old[i] * unsafe_mul(price_scale[i-1], precisions[i]),
557             PRECISION
558         )
559 
560     # ---------------- transferFrom token into the pool ----------------------
561 
562     for i in range(N_COINS):
563 
564         if amounts[i] > 0:
565 
566             if coins[i] == WETH20:
567 
568                 self._transfer_in(
569                     coins[i],
570                     amounts[i],
571                     0,  # <-----------------------------------
572                     msg.value,  #                             | No callbacks
573                     empty(address),  # <----------------------| for
574                     empty(bytes32),  # <----------------------| add_liquidity.
575                     msg.sender,  #                            |
576                     empty(address),  # <-----------------------
577                     use_eth
578                 )
579 
580             else:
581 
582                 self._transfer_in(
583                     coins[i],
584                     amounts[i],
585                     0,
586                     0,  # <----------------- mvalue = 0 if coin is not WETH20.
587                     empty(address),
588                     empty(bytes32),
589                     msg.sender,
590                     empty(address),
591                     False  # <-------- use_eth is False if coin is not WETH20.
592                 )
593 
594             amountsp[i] = xp[i] - xp_old[i]
595 
596     # -------------------- Calculate LP tokens to mint -----------------------
597 
598     if self.future_A_gamma_time > block.timestamp:  # <--- A_gamma is ramping.
599 
600         # ----- Recalculate the invariant if A or gamma are undergoing a ramp.
601         old_D = MATH.newton_D(A_gamma[0], A_gamma[1], xp_old, 0)
602 
603     else:
604 
605         old_D = self.D
606 
607     D: uint256 = MATH.newton_D(A_gamma[0], A_gamma[1], xp, 0)
608 
609     token_supply: uint256 = self.totalSupply
610     if old_D > 0:
611         d_token = token_supply * D / old_D - token_supply
612     else:
613         d_token = self.get_xcp(D)  # <------------------------- Making initial
614         #                                            virtual price equal to 1.
615 
616     assert d_token > 0  # dev: nothing minted
617 
618     if old_D > 0:
619 
620         d_token_fee = (
621             self._calc_token_fee(amountsp, xp) * d_token / 10**10 + 1
622         )
623 
624         d_token -= d_token_fee
625         token_supply += d_token
626         self.mint(receiver, d_token)
627 
628         packed_price_scale = self.tweak_price(A_gamma, xp, D, 0)
629 
630     else:
631 
632         self.D = D
633         self.virtual_price = 10**18
634         self.xcp_profit = 10**18
635         self.xcp_profit_a = 10**18
636         self.mint(receiver, d_token)
637 
638     assert d_token >= min_mint_amount, "Slippage"
639 
640     log AddLiquidity(
641         receiver, amounts, d_token_fee, token_supply, packed_price_scale
642     )
643 
644     self._claim_admin_fees()  # <--------------------------- Claim admin fees.
645 
646     return d_token
647 
648 
649 @external
650 @nonreentrant("lock")
651 def remove_liquidity(
652     _amount: uint256,
653     min_amounts: uint256[N_COINS],
654     use_eth: bool = False,
655     receiver: address = msg.sender,
656     claim_admin_fees: bool = True,
657 ) -> uint256[N_COINS]:
658     """
659     @notice This withdrawal method is very safe, does no complex math since
660             tokens are withdrawn in balanced proportions. No fees are charged.
661     @param _amount Amount of LP tokens to burn
662     @param min_amounts Minimum amounts of tokens to withdraw
663     @param use_eth Whether to withdraw ETH or not
664     @param receiver Address to send the withdrawn tokens to
665     @param claim_admin_fees If True, call self._claim_admin_fees(). Default is True.
666     @return uint256[3] Amount of pool tokens received by the `receiver`
667     """
668     amount: uint256 = _amount
669     balances: uint256[N_COINS] = self.balances
670     d_balances: uint256[N_COINS] = empty(uint256[N_COINS])
671 
672     if claim_admin_fees:
673         self._claim_admin_fees()  # <------ We claim fees so that the DAO gets
674         #         paid before withdrawal. In emergency cases, set it to False.
675 
676     # -------------------------------------------------------- Burn LP tokens.
677 
678     total_supply: uint256 = self.totalSupply  # <------ Get totalSupply before
679     self.burnFrom(msg.sender, _amount)  # ---- reducing it with self.burnFrom.
680 
681     # There are two cases for withdrawing tokens from the pool.
682     #   Case 1. Withdrawal does not empty the pool.
683     #           In this situation, D is adjusted proportional to the amount of
684     #           LP tokens burnt. ERC20 tokens transferred is proportional
685     #           to : (AMM balance * LP tokens in) / LP token total supply
686     #   Case 2. Withdrawal empties the pool.
687     #           In this situation, all tokens are withdrawn and the invariant
688     #           is reset.
689 
690     if amount == total_supply:  # <----------------------------------- Case 2.
691 
692         for i in range(N_COINS):
693 
694             d_balances[i] = balances[i]
695             self.balances[i] = 0  # <------------------------- Empty the pool.
696 
697     else:  # <-------------------------------------------------------- Case 1.
698 
699         amount -= 1  # <---- To prevent rounding errors, favor LPs a tiny bit.
700 
701         for i in range(N_COINS):
702             d_balances[i] = balances[i] * amount / total_supply
703             assert d_balances[i] >= min_amounts[i]
704             self.balances[i] = balances[i] - d_balances[i]
705             balances[i] = d_balances[i]  # <-- Now it's the amounts going out.
706 
707     D: uint256 = self.D
708     self.D = D - unsafe_div(D * amount, total_supply)  # <----------- Reduce D
709     #      proportional to the amount of tokens leaving. Since withdrawals are
710     #       balanced, this is a simple subtraction. If amount == total_supply,
711     #                                                             D will be 0.
712 
713     # ---------------------------------- Transfers ---------------------------
714 
715     for i in range(N_COINS):
716         self._transfer_out(coins[i], d_balances[i], use_eth, receiver)
717 
718     log RemoveLiquidity(msg.sender, balances, total_supply - _amount)
719 
720     return d_balances
721 
722 
723 @external
724 @nonreentrant("lock")
725 def remove_liquidity_one_coin(
726     token_amount: uint256,
727     i: uint256,
728     min_amount: uint256,
729     use_eth: bool = False,
730     receiver: address = msg.sender
731 ) -> uint256:
732     """
733     @notice Withdraw liquidity in a single token.
734             Involves fees (lower than swap fees).
735     @dev This operation also involves an admin fee claim.
736     @param token_amount Amount of LP tokens to burn
737     @param i Index of the token to withdraw
738     @param min_amount Minimum amount of token to withdraw.
739     @param use_eth Whether to withdraw ETH or not
740     @param receiver Address to send the withdrawn tokens to
741     @return Amount of tokens at index i received by the `receiver`
742     """
743 
744     A_gamma: uint256[2] = self._A_gamma()
745 
746     dy: uint256 = 0
747     D: uint256 = 0
748     p: uint256 = 0
749     xp: uint256[N_COINS] = empty(uint256[N_COINS])
750     approx_fee: uint256 = 0
751 
752     # ---------------------------- Claim admin fees before removing liquidity.
753     self._claim_admin_fees()
754 
755     # ------------------------------------------------------------------------
756 
757     dy, D, xp, approx_fee = self._calc_withdraw_one_coin(
758         A_gamma,
759         token_amount,
760         i,
761         (self.future_A_gamma_time > block.timestamp),  # <------- During ramps
762     )  #                                                  we need to update D.
763 
764     assert dy >= min_amount, "Slippage"
765 
766     # ------------------------- Transfers ------------------------------------
767 
768     self.balances[i] -= dy
769     self.burnFrom(msg.sender, token_amount)
770     self._transfer_out(coins[i], dy, use_eth, receiver)
771 
772     packed_price_scale: uint256 = self.tweak_price(A_gamma, xp, D, 0)
773     #        Safe to use D from _calc_withdraw_one_coin here ---^
774 
775     log RemoveLiquidityOne(
776         msg.sender, token_amount, i, dy, approx_fee, packed_price_scale
777     )
778 
779     return dy
780 
781 
782 @external
783 @nonreentrant("lock")
784 def claim_admin_fees():
785     """
786     @notice Claim admin fees. Callable by anyone.
787     """
788     self._claim_admin_fees()
789 
790 
791 # -------------------------- Packing functions -------------------------------
792 
793 
794 @internal
795 @view
796 def _pack(x: uint256[3]) -> uint256:
797     """
798     @notice Packs 3 integers with values <= 10**18 into a uint256
799     @param x The uint256[3] to pack
800     @return uint256 Integer with packed values
801     """
802     return (x[0] << 128) | (x[1] << 64) | x[2]
803 
804 
805 @internal
806 @view
807 def _unpack(_packed: uint256) -> uint256[3]:
808     """
809     @notice Unpacks a uint256 into 3 integers (values must be <= 10**18)
810     @param val The uint256 to unpack
811     @return uint256[3] A list of length 3 with unpacked integers
812     """
813     return [
814         (_packed >> 128) & 18446744073709551615,
815         (_packed >> 64) & 18446744073709551615,
816         _packed & 18446744073709551615,
817     ]
818 
819 
820 @internal
821 @view
822 def _pack_prices(prices_to_pack: uint256[N_COINS-1]) -> uint256:
823     """
824     @notice Packs N_COINS-1 prices into a uint256.
825     @param prices_to_pack The prices to pack
826     @return uint256 An integer that packs prices
827     """
828     packed_prices: uint256 = 0
829     p: uint256 = 0
830     for k in range(N_COINS - 1):
831         packed_prices = packed_prices << PRICE_SIZE
832         p = prices_to_pack[N_COINS - 2 - k]
833         assert p < PRICE_MASK
834         packed_prices = p | packed_prices
835     return packed_prices
836 
837 
838 @internal
839 @view
840 def _unpack_prices(_packed_prices: uint256) -> uint256[2]:
841     """
842     @notice Unpacks N_COINS-1 prices from a uint256.
843     @param _packed_prices The packed prices
844     @return uint256[2] Unpacked prices
845     """
846     unpacked_prices: uint256[N_COINS-1] = empty(uint256[N_COINS-1])
847     packed_prices: uint256 = _packed_prices
848     for k in range(N_COINS - 1):
849         unpacked_prices[k] = packed_prices & PRICE_MASK
850         packed_prices = packed_prices >> PRICE_SIZE
851 
852     return unpacked_prices
853 
854 
855 # ---------------------- AMM Internal Functions -------------------------------
856 
857 
858 @internal
859 def _exchange(
860     sender: address,
861     mvalue: uint256,
862     i: uint256,
863     j: uint256,
864     dx: uint256,
865     min_dy: uint256,
866     use_eth: bool,
867     receiver: address,
868     callbacker: address,
869     callback_sig: bytes32
870 ) -> uint256:
871 
872     assert i != j  # dev: coin index out of range
873     assert dx > 0  # dev: do not exchange 0 coins
874 
875     A_gamma: uint256[2] = self._A_gamma()
876     xp: uint256[N_COINS] = self.balances
877     precisions: uint256[N_COINS] = self._unpack(self.packed_precisions)
878     dy: uint256 = 0
879 
880     y: uint256 = xp[j]  # <----------------- if j > N_COINS, this will revert.
881     x0: uint256 = xp[i]  # <--------------- if i > N_COINS, this will  revert.
882     xp[i] = x0 + dx
883     self.balances[i] = xp[i]
884 
885     packed_price_scale: uint256 = self.price_scale_packed
886     price_scale: uint256[N_COINS - 1] = self._unpack_prices(
887         packed_price_scale
888     )
889 
890     xp[0] *= precisions[0]
891     for k in range(1, N_COINS):
892         xp[k] = unsafe_div(
893             xp[k] * price_scale[k - 1] * precisions[k],
894             PRECISION
895         )  # <-------- Safu to do unsafe_div here since PRECISION is not zero.
896 
897     prec_i: uint256 = precisions[i]
898 
899     # ----------- Update invariant if A, gamma are undergoing ramps ---------
900 
901     t: uint256 = self.future_A_gamma_time
902     if t > block.timestamp:
903 
904         x0 *= prec_i
905 
906         if i > 0:
907             x0 = unsafe_div(x0 * price_scale[i - 1], PRECISION)
908 
909         x1: uint256 = xp[i]  # <------------------ Back up old value in xp ...
910         xp[i] = x0                                                         # |
911         self.D = MATH.newton_D(A_gamma[0], A_gamma[1], xp, 0)              # |
912         xp[i] = x1  # <-------------------------------------- ... and restore.
913 
914     # ----------------------- Calculate dy and fees --------------------------
915 
916     D: uint256 = self.D
917     prec_j: uint256 = precisions[j]
918     y_out: uint256[2] = MATH.get_y(A_gamma[0], A_gamma[1], xp, D, j)
919     dy = xp[j] - y_out[0]
920     xp[j] -= dy
921     dy -= 1
922 
923     if j > 0:
924         dy = dy * PRECISION / price_scale[j - 1]
925     dy /= prec_j
926 
927     fee: uint256 = unsafe_div(self._fee(xp) * dy, 10**10)
928 
929     dy -= fee  # <--------------------- Subtract fee from the outgoing amount.
930     assert dy >= min_dy, "Slippage"
931 
932     y -= dy
933     self.balances[j] = y  # <----------- Update pool balance of outgoing coin.
934 
935     y *= prec_j
936     if j > 0:
937         y = unsafe_div(y * price_scale[j - 1], PRECISION)
938     xp[j] = y  # <------------------------------------------------- Update xp.
939 
940     # ---------------------- Do Transfers in and out -------------------------
941 
942     ########################## TRANSFER IN <-------
943     self._transfer_in(
944         coins[i], dx, dy, mvalue,
945         callbacker, callback_sig,  # <-------- Callback method is called here.
946         sender, receiver, use_eth,
947     )
948 
949     ########################## -------> TRANSFER OUT
950     self._transfer_out(coins[j], dy, use_eth, receiver)
951 
952     # ------ Tweak price_scale with good initial guess for newton_D ----------
953 
954     packed_price_scale = self.tweak_price(A_gamma, xp, 0, y_out[1])
955 
956     log TokenExchange(sender, i, dx, j, dy, fee, packed_price_scale)
957 
958     return dy
959 
960 
961 @internal
962 def tweak_price(
963     A_gamma: uint256[2],
964     _xp: uint256[N_COINS],
965     new_D: uint256,
966     K0_prev: uint256 = 0,
967 ) -> uint256:
968     """
969     @notice Tweaks price_oracle, last_price and conditionally adjusts
970             price_scale. This is called whenever there is an unbalanced
971             liquidity operation: _exchange, add_liquidity, or
972             remove_liquidity_one_coin.
973     @dev Contains main liquidity rebalancing logic, by tweaking `price_scale`.
974     @param A_gamma Array of A and gamma parameters.
975     @param _xp Array of current balances.
976     @param new_D New D value.
977     @param K0_prev Initial guess for `newton_D`.
978     """
979 
980     # ---------------------------- Read storage ------------------------------
981 
982     rebalancing_params: uint256[3] = self._unpack(
983         self.packed_rebalancing_params
984     )  # <---------- Contains: allowed_extra_profit, adjustment_step, ma_time.
985     price_oracle: uint256[N_COINS - 1] = self._unpack_prices(
986         self.price_oracle_packed
987     )
988     last_prices: uint256[N_COINS - 1] = self._unpack_prices(
989         self.last_prices_packed
990     )
991     packed_price_scale: uint256 = self.price_scale_packed
992     price_scale: uint256[N_COINS - 1] = self._unpack_prices(
993         packed_price_scale
994     )
995 
996     total_supply: uint256 = self.totalSupply
997     old_xcp_profit: uint256 = self.xcp_profit
998     old_virtual_price: uint256 = self.virtual_price
999     last_prices_timestamp: uint256 = self.last_prices_timestamp
1000 
1001     # ----------------------- Update MA if needed ----------------------------
1002 
1003     if last_prices_timestamp < block.timestamp:
1004 
1005         #   The moving average price oracle is calculated using the last_price
1006         #      of the trade at the previous block, and the price oracle logged
1007         #              before that trade. This can happen only once per block.
1008 
1009         # ------------------ Calculate moving average params -----------------
1010 
1011         alpha: uint256 = MATH.wad_exp(
1012             -convert(
1013                 unsafe_div(
1014                     (block.timestamp - last_prices_timestamp) * 10**18,
1015                     rebalancing_params[2]  # <----------------------- ma_time.
1016                 ),
1017                 int256,
1018             )
1019         )
1020 
1021         for k in range(N_COINS - 1):
1022 
1023             # ----------------- We cap state price that goes into the EMA with
1024             #                                                 2 x price_scale.
1025             price_oracle[k] = unsafe_div(
1026                 min(last_prices[k], 2 * price_scale[k]) * (10**18 - alpha) +
1027                 price_oracle[k] * alpha,  # ^-------- Cap spot price into EMA.
1028                 10**18
1029             )
1030 
1031         self.price_oracle_packed = self._pack_prices(price_oracle)
1032         self.last_prices_timestamp = block.timestamp  # <---- Store timestamp.
1033 
1034     #                  price_oracle is used further on to calculate its vector
1035     #            distance from price_scale. This distance is used to calculate
1036     #                  the amount of adjustment to be done to the price_scale.
1037 
1038     # ------------------ If new_D is set to 0, calculate it ------------------
1039 
1040     D_unadjusted: uint256 = new_D
1041     if new_D == 0:  #  <--------------------------- _exchange sets new_D to 0.
1042         D_unadjusted = MATH.newton_D(A_gamma[0], A_gamma[1], _xp, K0_prev)
1043 
1044     # ----------------------- Calculate last_prices --------------------------
1045 
1046     last_prices = MATH.get_p(_xp, D_unadjusted, A_gamma)
1047     for k in range(N_COINS - 1):
1048         last_prices[k] = unsafe_div(last_prices[k] * price_scale[k], 10**18)
1049     self.last_prices_packed = self._pack_prices(last_prices)
1050 
1051     # ---------- Update profit numbers without price adjustment first --------
1052 
1053     xp: uint256[N_COINS] = empty(uint256[N_COINS])
1054     xp[0] = unsafe_div(D_unadjusted, N_COINS)
1055     for k in range(N_COINS - 1):
1056         xp[k + 1] = D_unadjusted * 10**18 / (N_COINS * price_scale[k])
1057 
1058     # ------------------------- Update xcp_profit ----------------------------
1059 
1060     xcp_profit: uint256 = 10**18
1061     virtual_price: uint256 = 10**18
1062 
1063     if old_virtual_price > 0:
1064 
1065         xcp: uint256 = MATH.geometric_mean(xp)
1066         virtual_price = 10**18 * xcp / total_supply
1067 
1068         xcp_profit = unsafe_div(
1069             old_xcp_profit * virtual_price,
1070             old_virtual_price
1071         )  # <---------------- Safu to do unsafe_div as old_virtual_price > 0.
1072 
1073         #       If A and gamma are not undergoing ramps (t < block.timestamp),
1074         #         ensure new virtual_price is not less than old virtual_price,
1075         #                                        else the pool suffers a loss.
1076         if self.future_A_gamma_time < block.timestamp:
1077             assert virtual_price > old_virtual_price, "Loss"
1078 
1079     self.xcp_profit = xcp_profit
1080 
1081     # ------------ Rebalance liquidity if there's enough profits to adjust it:
1082     if virtual_price * 2 - 10**18 > xcp_profit + 2 * rebalancing_params[0]:
1083         #                          allowed_extra_profit --------^
1084 
1085         # ------------------- Get adjustment step ----------------------------
1086 
1087         #                Calculate the vector distance between price_scale and
1088         #                                                        price_oracle.
1089         norm: uint256 = 0
1090         ratio: uint256 = 0
1091         for k in range(N_COINS - 1):
1092 
1093             ratio = unsafe_div(price_oracle[k] * 10**18, price_scale[k])
1094             # unsafe_div because we did safediv before ----^
1095 
1096             if ratio > 10**18:
1097                 ratio = unsafe_sub(ratio, 10**18)
1098             else:
1099                 ratio = unsafe_sub(10**18, ratio)
1100             norm = unsafe_add(norm, ratio**2)
1101 
1102         norm = isqrt(norm)  # <-------------------- isqrt is not in base 1e18.
1103         adjustment_step: uint256 = max(
1104             rebalancing_params[1], unsafe_div(norm, 5)
1105         )  #           ^------------------------------------- adjustment_step.
1106 
1107         if norm > adjustment_step:  # <---------- We only adjust prices if the
1108             #          vector distance between price_oracle and price_scale is
1109             #             large enough. This check ensures that no rebalancing
1110             #           occurs if the distance is low i.e. the pool prices are
1111             #                                     pegged to the oracle prices.
1112 
1113             # ------------------------------------- Calculate new price scale.
1114 
1115             p_new: uint256[N_COINS - 1] = empty(uint256[N_COINS - 1])
1116             for k in range(N_COINS - 1):
1117                 p_new[k] = unsafe_div(
1118                     price_scale[k] * unsafe_sub(norm, adjustment_step)
1119                     + adjustment_step * price_oracle[k],
1120                     norm
1121                 )  # <- norm is non-zero and gt adjustment_step; unsafe = safe
1122 
1123             # ---------------- Update stale xp (using price_scale) with p_new.
1124             xp = _xp
1125             for k in range(N_COINS - 1):
1126                 xp[k + 1] = unsafe_div(_xp[k + 1] * p_new[k], price_scale[k])
1127                 # unsafe_div because we did safediv before ----^
1128 
1129             # ------------------------------------------ Update D with new xp.
1130             D: uint256 = MATH.newton_D(A_gamma[0], A_gamma[1], xp, 0)
1131 
1132             for k in range(N_COINS):
1133                 frac: uint256 = xp[k] * 10**18 / D  # <----- Check validity of
1134                 assert (frac > 10**16 - 1) and (frac < 10**20 + 1)  #   p_new.
1135 
1136             xp[0] = D / N_COINS
1137             for k in range(N_COINS - 1):
1138                 xp[k + 1] = D * 10**18 / (N_COINS * p_new[k])  # <---- Convert
1139                 #                                           xp to real prices.
1140 
1141             # ---------- Calculate new virtual_price using new xp and D. Reuse
1142             #              `old_virtual_price` (but it has new virtual_price).
1143             old_virtual_price = unsafe_div(
1144                 10**18 * MATH.geometric_mean(xp), total_supply
1145             )  # <----- unsafe_div because we did safediv before (if vp>1e18)
1146 
1147             # ---------------------------- Proceed if we've got enough profit.
1148             if (
1149                 old_virtual_price > 10**18 and
1150                 2 * old_virtual_price - 10**18 > xcp_profit
1151             ):
1152 
1153                 packed_price_scale = self._pack_prices(p_new)
1154 
1155                 self.D = D
1156                 self.virtual_price = old_virtual_price
1157                 self.price_scale_packed = packed_price_scale
1158 
1159                 return packed_price_scale
1160 
1161     # --------- price_scale was not adjusted. Update the profit counter and D.
1162     self.D = D_unadjusted
1163     self.virtual_price = virtual_price
1164 
1165     return packed_price_scale
1166 
1167 
1168 @internal
1169 def _claim_admin_fees():
1170     """
1171     @notice Claims admin fees and sends it to fee_receiver set in the factory.
1172     """
1173     A_gamma: uint256[2] = self._A_gamma()
1174 
1175     xcp_profit: uint256 = self.xcp_profit  # <---------- Current pool profits.
1176     xcp_profit_a: uint256 = self.xcp_profit_a  # <- Profits at previous claim.
1177     total_supply: uint256 = self.totalSupply
1178 
1179     # Do not claim admin fees if:
1180     # 1. insufficient profits accrued since last claim, and
1181     # 2. there are less than 10**18 (or 1 unit of) lp tokens, else it can lead
1182     #    to manipulated virtual prices.
1183     if xcp_profit <= xcp_profit_a or total_supply < 10**18:
1184         return
1185 
1186     #      Claim tokens belonging to the admin here. This is done by 'gulping'
1187     #       pool tokens that have accrued as fees, but not accounted in pool's
1188     #         `self.balances` yet: pool balances only account for incoming and
1189     #                  outgoing tokens excluding fees. Following 'gulps' fees:
1190 
1191     for i in range(N_COINS):
1192         if coins[i] == WETH20:
1193             self.balances[i] = self.balance
1194         else:
1195             self.balances[i] = ERC20(coins[i]).balanceOf(self)
1196 
1197     #            If the pool has made no profits, `xcp_profit == xcp_profit_a`
1198     #                         and the pool gulps nothing in the previous step.
1199 
1200     vprice: uint256 = self.virtual_price
1201 
1202     #  Admin fees are calculated as follows.
1203     #      1. Calculate accrued profit since last claim. `xcp_profit`
1204     #         is the current profits. `xcp_profit_a` is the profits
1205     #         at the previous claim.
1206     #      2. Take out admin's share, which is hardcoded at 5 * 10**9.
1207     #         (50% => half of 100% => 10**10 / 2 => 5 * 10**9).
1208     #      3. Since half of the profits go to rebalancing the pool, we
1209     #         are left with half; so divide by 2.
1210 
1211     fees: uint256 = unsafe_div(
1212         unsafe_sub(xcp_profit, xcp_profit_a) * ADMIN_FEE, 2 * 10**10
1213     )
1214 
1215     # ------------------------------ Claim admin fees by minting admin's share
1216     #                                                of the pool in LP tokens.
1217     receiver: address = Factory(self.factory).fee_receiver()
1218     if receiver != empty(address) and fees > 0:
1219 
1220         frac: uint256 = vprice * 10**18 / (vprice - fees) - 10**18
1221         claimed: uint256 = self.mint_relative(receiver, frac)
1222 
1223         xcp_profit -= fees * 2
1224 
1225         self.xcp_profit = xcp_profit
1226 
1227         log ClaimAdminFee(receiver, claimed)
1228 
1229     # ------------------------------------------- Recalculate D b/c we gulped.
1230     D: uint256 = MATH.newton_D(A_gamma[0], A_gamma[1], self.xp(), 0)
1231     self.D = D
1232 
1233     # ------------------- Recalculate virtual_price following admin fee claim.
1234     #     In this instance we do not check if current virtual price is greater
1235     #               than old virtual price, since the claim process can result
1236     #                                     in a small decrease in pool's value.
1237 
1238     self.virtual_price = 10**18 * self.get_xcp(D) / self.totalSupply
1239     self.xcp_profit_a = xcp_profit  # <------------ Cache last claimed profit.
1240 
1241 
1242 @internal
1243 @view
1244 def xp() -> uint256[N_COINS]:
1245 
1246     result: uint256[N_COINS] = self.balances
1247     packed_prices: uint256 = self.price_scale_packed
1248     precisions: uint256[N_COINS] = self._unpack(self.packed_precisions)
1249 
1250     result[0] *= precisions[0]
1251     for i in range(1, N_COINS):
1252         p: uint256 = (packed_prices & PRICE_MASK) * precisions[i]
1253         result[i] = result[i] * p / PRECISION
1254         packed_prices = packed_prices >> PRICE_SIZE
1255 
1256     return result
1257 
1258 
1259 @view
1260 @internal
1261 def _A_gamma() -> uint256[2]:
1262     t1: uint256 = self.future_A_gamma_time
1263 
1264     A_gamma_1: uint256 = self.future_A_gamma
1265     gamma1: uint256 = A_gamma_1 & 2**128 - 1
1266     A1: uint256 = A_gamma_1 >> 128
1267 
1268     if block.timestamp < t1:
1269 
1270         # --------------- Handle ramping up and down of A --------------------
1271 
1272         A_gamma_0: uint256 = self.initial_A_gamma
1273         t0: uint256 = self.initial_A_gamma_time
1274 
1275         t1 -= t0
1276         t0 = block.timestamp - t0
1277         t2: uint256 = t1 - t0
1278 
1279         A1 = ((A_gamma_0 >> 128) * t2 + A1 * t0) / t1
1280         gamma1 = ((A_gamma_0 & 2**128 - 1) * t2 + gamma1 * t0) / t1
1281 
1282     return [A1, gamma1]
1283 
1284 
1285 @internal
1286 @view
1287 def _fee(xp: uint256[N_COINS]) -> uint256:
1288     fee_params: uint256[3] = self._unpack(self.packed_fee_params)
1289     f: uint256 = MATH.reduction_coefficient(xp, fee_params[2])
1290     return unsafe_div(
1291         fee_params[0] * f + fee_params[1] * (10**18 - f),
1292         10**18
1293     )
1294 
1295 
1296 @internal
1297 @view
1298 def get_xcp(D: uint256) -> uint256:
1299 
1300     x: uint256[N_COINS] = empty(uint256[N_COINS])
1301     x[0] = D / N_COINS
1302     packed_prices: uint256 = self.price_scale_packed  # <-- No precisions here
1303     #                                 because we don't switch to "real" units.
1304 
1305     for i in range(1, N_COINS):
1306         x[i] = D * 10**18 / (N_COINS * (packed_prices & PRICE_MASK))
1307         packed_prices = packed_prices >> PRICE_SIZE
1308 
1309     return MATH.geometric_mean(x)
1310 
1311 
1312 @view
1313 @internal
1314 def _calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256:
1315     # fee = sum(amounts_i - avg(amounts)) * fee' / sum(amounts)
1316     fee: uint256 = unsafe_div(
1317         unsafe_mul(self._fee(xp), N_COINS),
1318         unsafe_mul(4, unsafe_sub(N_COINS, 1))
1319     )
1320 
1321     S: uint256 = 0
1322     for _x in amounts:
1323         S += _x
1324 
1325     avg: uint256 = unsafe_div(S, N_COINS)
1326     Sdiff: uint256 = 0
1327 
1328     for _x in amounts:
1329         if _x > avg:
1330             Sdiff += unsafe_sub(_x, avg)
1331         else:
1332             Sdiff += unsafe_sub(avg, _x)
1333 
1334     return fee * Sdiff / S + NOISE_FEE
1335 
1336 
1337 @internal
1338 @view
1339 def _calc_withdraw_one_coin(
1340     A_gamma: uint256[2],
1341     token_amount: uint256,
1342     i: uint256,
1343     update_D: bool,
1344 ) -> (uint256, uint256, uint256[N_COINS], uint256):
1345 
1346     token_supply: uint256 = self.totalSupply
1347     assert token_amount <= token_supply  # dev: token amount more than supply
1348     assert i < N_COINS  # dev: coin out of range
1349 
1350     xx: uint256[N_COINS] = self.balances
1351     precisions: uint256[N_COINS] = self._unpack(self.packed_precisions)
1352     xp: uint256[N_COINS] = precisions
1353     D0: uint256 = 0
1354 
1355     # -------------------------- Calculate D0 and xp -------------------------
1356 
1357     price_scale_i: uint256 = PRECISION * precisions[0]
1358     packed_prices: uint256 = self.price_scale_packed
1359     xp[0] *= xx[0]
1360     for k in range(1, N_COINS):
1361         p: uint256 = (packed_prices & PRICE_MASK)
1362         if i == k:
1363             price_scale_i = p * xp[i]
1364         xp[k] = unsafe_div(xp[k] * xx[k] * p, PRECISION)
1365         packed_prices = packed_prices >> PRICE_SIZE
1366 
1367     if update_D:  # <-------------- D is updated if pool is undergoing a ramp.
1368         D0 = MATH.newton_D(A_gamma[0], A_gamma[1], xp, 0)
1369     else:
1370         D0 = self.D
1371 
1372     D: uint256 = D0
1373 
1374     # -------------------------------- Fee Calc ------------------------------
1375 
1376     # Charge fees on D. Roughly calculate xp[i] after withdrawal and use that
1377     # to calculate fee. Precision is not paramount here: we just want a
1378     # behavior where the higher the imbalance caused the more fee the AMM
1379     # charges.
1380 
1381     # xp is adjusted assuming xp[0] ~= xp[1] ~= x[2], which is usually not the
1382     #  case. We charge self._fee(xp), where xp is an imprecise adjustment post
1383     #  withdrawal in one coin. If the withdraw is too large: charge max fee by
1384     #   default. This is because the fee calculation will otherwise underflow.
1385 
1386     xp_imprecise: uint256[N_COINS] = xp
1387     xp_correction: uint256 = xp[i] * N_COINS * token_amount / token_supply
1388     fee: uint256 = self._unpack(self.packed_fee_params)[1]  # <- self.out_fee.
1389 
1390     if xp_correction < xp_imprecise[i]:
1391         xp_imprecise[i] -= xp_correction
1392         fee = self._fee(xp_imprecise)
1393 
1394     dD: uint256 = unsafe_div(token_amount * D, token_supply)
1395     D_fee: uint256 = fee * dD / (2 * 10**10) + 1  # <------- Actual fee on D.
1396 
1397     # --------- Calculate `approx_fee` (assuming balanced state) in ith token.
1398     # -------------------------------- We only need this for fee in the event.
1399     approx_fee: uint256 = N_COINS * D_fee * xx[i] / D
1400 
1401     # ------------------------------------------------------------------------
1402     D -= (dD - D_fee)  # <----------------------------------- Charge fee on D.
1403     # --------------------------------- Calculate `y_out`` with `(D - D_fee)`.
1404     y: uint256 = MATH.get_y(A_gamma[0], A_gamma[1], xp, D, i)[0]
1405     dy: uint256 = (xp[i] - y) * PRECISION / price_scale_i
1406     xp[i] = y
1407 
1408     return dy, D, xp, approx_fee
1409 
1410 
1411 # ------------------------ ERC20 functions -----------------------------------
1412 
1413 
1414 @internal
1415 def _approve(_owner: address, _spender: address, _value: uint256):
1416     self.allowance[_owner][_spender] = _value
1417 
1418     log Approval(_owner, _spender, _value)
1419 
1420 
1421 @internal
1422 def _transfer(_from: address, _to: address, _value: uint256):
1423     assert _to not in [self, empty(address)]
1424 
1425     self.balanceOf[_from] -= _value
1426     self.balanceOf[_to] += _value
1427 
1428     log Transfer(_from, _to, _value)
1429 
1430 
1431 @view
1432 @internal
1433 def _domain_separator() -> bytes32:
1434     if chain.id != CACHED_CHAIN_ID:
1435         return keccak256(
1436             _abi_encode(
1437                 EIP712_TYPEHASH,
1438                 NAME_HASH,
1439                 VERSION_HASH,
1440                 chain.id,
1441                 self,
1442                 salt,
1443             )
1444         )
1445     return CACHED_DOMAIN_SEPARATOR
1446 
1447 
1448 @external
1449 def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
1450     """
1451     @dev Transfer tokens from one address to another.
1452     @param _from address The address which you want to send tokens from
1453     @param _to address The address which you want to transfer to
1454     @param _value uint256 the amount of tokens to be transferred
1455     @return bool True on successul transfer. Reverts otherwise.
1456     """
1457     _allowance: uint256 = self.allowance[_from][msg.sender]
1458     if _allowance != max_value(uint256):
1459         self._approve(_from, msg.sender, _allowance - _value)
1460 
1461     self._transfer(_from, _to, _value)
1462     return True
1463 
1464 
1465 @external
1466 def transfer(_to: address, _value: uint256) -> bool:
1467     """
1468     @dev Transfer token for a specified address
1469     @param _to The address to transfer to.
1470     @param _value The amount to be transferred.
1471     @return bool True on successful transfer. Reverts otherwise.
1472     """
1473     self._transfer(msg.sender, _to, _value)
1474     return True
1475 
1476 
1477 @external
1478 def approve(_spender: address, _value: uint256) -> bool:
1479     """
1480     @notice Allow `_spender` to transfer up to `_value` amount
1481             of tokens from the caller's account.
1482     @dev Non-zero to non-zero approvals are allowed, but should
1483          be used cautiously. The methods increaseAllowance + decreaseAllowance
1484          are available to prevent any front-running that may occur.
1485     @param _spender The account permitted to spend up to `_value` amount of
1486                     caller's funds.
1487     @param _value The amount of tokens `_spender` is allowed to spend.
1488     @return bool Success
1489     """
1490     self._approve(msg.sender, _spender, _value)
1491     return True
1492 
1493 
1494 @external
1495 def increaseAllowance(_spender: address, _add_value: uint256) -> bool:
1496     """
1497     @notice Increase the allowance granted to `_spender`.
1498     @dev This function will never overflow, and instead will bound
1499          allowance to max_value(uint256). This has the potential to grant an
1500          infinite approval.
1501     @param _spender The account to increase the allowance of.
1502     @param _add_value The amount to increase the allowance by.
1503     @return bool Success
1504     """
1505     cached_allowance: uint256 = self.allowance[msg.sender][_spender]
1506     allowance: uint256 = unsafe_add(cached_allowance, _add_value)
1507 
1508     if allowance < cached_allowance:  # <-------------- Check for an overflow.
1509         allowance = max_value(uint256)
1510 
1511     if allowance != cached_allowance:
1512         self._approve(msg.sender, _spender, allowance)
1513 
1514     return True
1515 
1516 
1517 @external
1518 def decreaseAllowance(_spender: address, _sub_value: uint256) -> bool:
1519     """
1520     @notice Decrease the allowance granted to `_spender`.
1521     @dev This function will never underflow, and instead will bound
1522         allowance to 0.
1523     @param _spender The account to decrease the allowance of.
1524     @param _sub_value The amount to decrease the allowance by.
1525     @return bool Success.
1526     """
1527     cached_allowance: uint256 = self.allowance[msg.sender][_spender]
1528     allowance: uint256 = unsafe_sub(cached_allowance, _sub_value)
1529 
1530     if cached_allowance < allowance:  # <------------- Check for an underflow.
1531         allowance = 0
1532 
1533     if allowance != cached_allowance:
1534         self._approve(msg.sender, _spender, allowance)
1535 
1536     return True
1537 
1538 
1539 @external
1540 def permit(
1541     _owner: address,
1542     _spender: address,
1543     _value: uint256,
1544     _deadline: uint256,
1545     _v: uint8,
1546     _r: bytes32,
1547     _s: bytes32,
1548 ) -> bool:
1549     """
1550     @notice Permit `_spender` to spend up to `_value` amount of `_owner`'s
1551             tokens via a signature.
1552     @dev In the event of a chain fork, replay attacks are prevented as
1553          domain separator is recalculated. However, this is only if the
1554          resulting chains update their chainId.
1555     @param _owner The account which generated the signature and is granting an
1556                   allowance.
1557     @param _spender The account which will be granted an allowance.
1558     @param _value The approval amount.
1559     @param _deadline The deadline by which the signature must be submitted.
1560     @param _v The last byte of the ECDSA signature.
1561     @param _r The first 32 bytes of the ECDSA signature.
1562     @param _s The second 32 bytes of the ECDSA signature.
1563     @return bool Success.
1564     """
1565     assert _owner != empty(address)  # dev: invalid owner
1566     assert block.timestamp <= _deadline  # dev: permit expired
1567 
1568     nonce: uint256 = self.nonces[_owner]
1569     digest: bytes32 = keccak256(
1570         concat(
1571             b"\x19\x01",
1572             self._domain_separator(),
1573             keccak256(
1574                 _abi_encode(
1575                     EIP2612_TYPEHASH, _owner, _spender, _value, nonce, _deadline
1576                 )
1577             ),
1578         )
1579     )
1580     assert ecrecover(digest, _v, _r, _s) == _owner  # dev: invalid signature
1581 
1582     self.nonces[_owner] = unsafe_add(nonce, 1)  # <-- Unsafe add is safe here.
1583     self._approve(_owner, _spender, _value)
1584     return True
1585 
1586 
1587 @internal
1588 def mint(_to: address, _value: uint256) -> bool:
1589     """
1590     @dev Mint an amount of the token and assigns it to an account.
1591          This encapsulates the modification of balances such that the
1592          proper events are emitted.
1593     @param _to The account that will receive the created tokens.
1594     @param _value The amount that will be created.
1595     @return bool Success.
1596     """
1597     self.totalSupply += _value
1598     self.balanceOf[_to] += _value
1599 
1600     log Transfer(empty(address), _to, _value)
1601     return True
1602 
1603 
1604 @internal
1605 def mint_relative(_to: address, frac: uint256) -> uint256:
1606     """
1607     @dev Increases supply by factor of (1 + frac/1e18) and mints it for _to
1608     @param _to The account that will receive the created tokens.
1609     @param frac The fraction of the current supply to mint.
1610     @return uint256 Amount of tokens minted.
1611     """
1612     supply: uint256 = self.totalSupply
1613     d_supply: uint256 = supply * frac / 10**18
1614     if d_supply > 0:
1615         self.totalSupply = supply + d_supply
1616         self.balanceOf[_to] += d_supply
1617         log Transfer(empty(address), _to, d_supply)
1618 
1619     return d_supply
1620 
1621 
1622 @internal
1623 def burnFrom(_to: address, _value: uint256) -> bool:
1624     """
1625     @dev Burn an amount of the token from a given account.
1626     @param _to The account whose tokens will be burned.
1627     @param _value The amount that will be burned.
1628     @return bool Success.
1629     """
1630     self.totalSupply -= _value
1631     self.balanceOf[_to] -= _value
1632 
1633     log Transfer(_to, empty(address), _value)
1634     return True
1635 
1636 
1637 # ------------------------- AMM View Functions -------------------------------
1638 
1639 
1640 @external
1641 @view
1642 def fee_receiver() -> address:
1643     """
1644     @notice Returns the address of the admin fee receiver.
1645     @return address Fee receiver.
1646     """
1647     return Factory(self.factory).fee_receiver()
1648 
1649 
1650 @external
1651 @view
1652 def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:
1653     """
1654     @notice Calculate LP tokens minted or to be burned for depositing or
1655             removing `amounts` of coins
1656     @dev Includes fee.
1657     @param amounts Amounts of tokens being deposited or withdrawn
1658     @param deposit True if it is a deposit action, False if withdrawn.
1659     @return uint256 Amount of LP tokens deposited or withdrawn.
1660     """
1661     view_contract: address = Factory(self.factory).views_implementation()
1662     return Views(view_contract).calc_token_amount(amounts, deposit, self)
1663 
1664 
1665 @external
1666 @view
1667 def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256:
1668     """
1669     @notice Get amount of coin[j] tokens received for swapping in dx amount of coin[i]
1670     @dev Includes fee.
1671     @param i index of input token. Check pool.coins(i) to get coin address at ith index
1672     @param j index of output token
1673     @param dx amount of input coin[i] tokens
1674     @return uint256 Exact amount of output j tokens for dx amount of i input tokens.
1675     """
1676     view_contract: address = Factory(self.factory).views_implementation()
1677     return Views(view_contract).get_dy(i, j, dx, self)
1678 
1679 
1680 @external
1681 @view
1682 def get_dx(i: uint256, j: uint256, dy: uint256) -> uint256:
1683     """
1684     @notice Get amount of coin[i] tokens to input for swapping out dy amount
1685             of coin[j]
1686     @dev This is an approximate method, and returns estimates close to the input
1687          amount. Expensive to call on-chain.
1688     @param i index of input token. Check pool.coins(i) to get coin address at
1689            ith index
1690     @param j index of output token
1691     @param dy amount of input coin[j] tokens received
1692     @return uint256 Approximate amount of input i tokens to get dy amount of j tokens.
1693     """
1694     view_contract: address = Factory(self.factory).views_implementation()
1695     return Views(view_contract).get_dx(i, j, dy, self)
1696 
1697 
1698 @external
1699 @view
1700 @nonreentrant("lock")
1701 def lp_price() -> uint256:
1702     """
1703     @notice Calculates the current price of the LP token w.r.t coin at the
1704             0th index
1705     @return uint256 LP price.
1706     """
1707 
1708     price_oracle: uint256[N_COINS-1] = self._unpack_prices(
1709         self.price_oracle_packed
1710     )
1711     return (
1712         3 * self.virtual_price * MATH.cbrt(price_oracle[0] * price_oracle[1])
1713     ) / 10**24
1714 
1715 
1716 @external
1717 @view
1718 @nonreentrant("lock")
1719 def get_virtual_price() -> uint256:
1720     """
1721     @notice Calculates the current virtual price of the pool LP token.
1722     @dev Not to be confused with `self.virtual_price` which is a cached
1723          virtual price.
1724     @return uint256 Virtual Price.
1725     """
1726     return 10**18 * self.get_xcp(self.D) / self.totalSupply
1727 
1728 
1729 @external
1730 @view
1731 @nonreentrant("lock")
1732 def price_oracle(k: uint256) -> uint256:
1733     """
1734     @notice Returns the oracle price of the coin at index `k` w.r.t the coin
1735             at index 0.
1736     @dev The oracle is an exponential moving average, with a periodicity
1737          determined by `self.ma_time`. The aggregated prices are cached state
1738          prices (dy/dx) calculated AFTER the latest trade.
1739     @param k The index of the coin.
1740     @return uint256 Price oracle value of kth coin.
1741     """
1742     price_oracle: uint256 = self._unpack_prices(self.price_oracle_packed)[k]
1743     price_scale: uint256 = self._unpack_prices(self.price_scale_packed)[k]
1744     last_prices_timestamp: uint256 = self.last_prices_timestamp
1745 
1746     if last_prices_timestamp < block.timestamp:  # <------------ Update moving
1747         #                                                   average if needed.
1748 
1749         last_prices: uint256 = self._unpack_prices(self.last_prices_packed)[k]
1750         ma_time: uint256 = self._unpack(self.packed_rebalancing_params)[2]
1751         alpha: uint256 = MATH.wad_exp(
1752             -convert(
1753                 (block.timestamp - last_prices_timestamp) * 10**18 / ma_time,
1754                 int256,
1755             )
1756         )
1757 
1758         # ---- We cap state price that goes into the EMA with 2 x price_scale.
1759         return (
1760             min(last_prices, 2 * price_scale) * (10**18 - alpha) +
1761             price_oracle * alpha
1762         ) / 10**18
1763 
1764     return price_oracle
1765 
1766 
1767 @external
1768 @view
1769 def last_prices(k: uint256) -> uint256:
1770     """
1771     @notice Returns last price of the coin at index `k` w.r.t the coin
1772             at index 0.
1773     @dev last_prices returns the quote by the AMM for an infinitesimally small swap
1774          after the last trade. It is not equivalent to the last traded price, and
1775          is computed by taking the partial differential of `x` w.r.t `y`. The
1776          derivative is calculated in `get_p` and then multiplied with price_scale
1777          to give last_prices.
1778     @param k The index of the coin.
1779     @return uint256 Last logged price of coin.
1780     """
1781     return self._unpack_prices(self.last_prices_packed)[k]
1782 
1783 
1784 @external
1785 @view
1786 def price_scale(k: uint256) -> uint256:
1787     """
1788     @notice Returns the price scale of the coin at index `k` w.r.t the coin
1789             at index 0.
1790     @dev Price scale determines the price band around which liquidity is
1791          concentrated.
1792     @param k The index of the coin.
1793     @return uint256 Price scale of coin.
1794     """
1795     return self._unpack_prices(self.price_scale_packed)[k]
1796 
1797 
1798 @external
1799 @view
1800 def fee() -> uint256:
1801     """
1802     @notice Returns the fee charged by the pool at current state.
1803     @dev Not to be confused with the fee charged at liquidity action, since
1804          there the fee is calculated on `xp` AFTER liquidity is added or
1805          removed.
1806     @return uint256 fee bps.
1807     """
1808     return self._fee(self.xp())
1809 
1810 
1811 @view
1812 @external
1813 def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256:
1814     """
1815     @notice Calculates output tokens with fee
1816     @param token_amount LP Token amount to burn
1817     @param i token in which liquidity is withdrawn
1818     @return uint256 Amount of ith tokens received for burning token_amount LP tokens.
1819     """
1820 
1821     return self._calc_withdraw_one_coin(
1822         self._A_gamma(),
1823         token_amount,
1824         i,
1825         (self.future_A_gamma_time > block.timestamp)
1826     )[0]
1827 
1828 
1829 @external
1830 @view
1831 def calc_token_fee(
1832     amounts: uint256[N_COINS], xp: uint256[N_COINS]
1833 ) -> uint256:
1834     """
1835     @notice Returns the fee charged on the given amounts for add_liquidity.
1836     @param amounts The amounts of coins being added to the pool.
1837     @param xp The current balances of the pool multiplied by coin precisions.
1838     @return uint256 Fee charged.
1839     """
1840     return self._calc_token_fee(amounts, xp)
1841 
1842 
1843 @view
1844 @external
1845 def A() -> uint256:
1846     """
1847     @notice Returns the current pool amplification parameter.
1848     @return uint256 A param.
1849     """
1850     return self._A_gamma()[0]
1851 
1852 
1853 @view
1854 @external
1855 def gamma() -> uint256:
1856     """
1857     @notice Returns the current pool gamma parameter.
1858     @return uint256 gamma param.
1859     """
1860     return self._A_gamma()[1]
1861 
1862 
1863 @view
1864 @external
1865 def mid_fee() -> uint256:
1866     """
1867     @notice Returns the current mid fee
1868     @return uint256 mid_fee value.
1869     """
1870     return self._unpack(self.packed_fee_params)[0]
1871 
1872 
1873 @view
1874 @external
1875 def out_fee() -> uint256:
1876     """
1877     @notice Returns the current out fee
1878     @return uint256 out_fee value.
1879     """
1880     return self._unpack(self.packed_fee_params)[1]
1881 
1882 
1883 @view
1884 @external
1885 def fee_gamma() -> uint256:
1886     """
1887     @notice Returns the current fee gamma
1888     @return uint256 fee_gamma value.
1889     """
1890     return self._unpack(self.packed_fee_params)[2]
1891 
1892 
1893 @view
1894 @external
1895 def allowed_extra_profit() -> uint256:
1896     """
1897     @notice Returns the current allowed extra profit
1898     @return uint256 allowed_extra_profit value.
1899     """
1900     return self._unpack(self.packed_rebalancing_params)[0]
1901 
1902 
1903 @view
1904 @external
1905 def adjustment_step() -> uint256:
1906     """
1907     @notice Returns the current adjustment step
1908     @return uint256 adjustment_step value.
1909     """
1910     return self._unpack(self.packed_rebalancing_params)[1]
1911 
1912 
1913 @view
1914 @external
1915 def ma_time() -> uint256:
1916     """
1917     @notice Returns the current moving average time in seconds
1918     @dev To get time in seconds, the parameter is multipled by ln(2)
1919          One can expect off-by-one errors here.
1920     @return uint256 ma_time value.
1921     """
1922     return self._unpack(self.packed_rebalancing_params)[2] * 694 / 1000
1923 
1924 
1925 @view
1926 @external
1927 def precisions() -> uint256[N_COINS]:  # <-------------- For by view contract.
1928     """
1929     @notice Returns the precisions of each coin in the pool.
1930     @return uint256[3] precisions of coins.
1931     """
1932     return self._unpack(self.packed_precisions)
1933 
1934 
1935 @external
1936 @view
1937 def fee_calc(xp: uint256[N_COINS]) -> uint256:  # <----- For by view contract.
1938     """
1939     @notice Returns the fee charged by the pool at current state.
1940     @param xp The current balances of the pool multiplied by coin precisions.
1941     @return uint256 Fee value.
1942     """
1943     return self._fee(xp)
1944 
1945 
1946 @view
1947 @external
1948 def DOMAIN_SEPARATOR() -> bytes32:
1949     """
1950     @notice EIP712 domain separator.
1951     @return bytes32 Domain Separator set for the current chain.
1952     """
1953     return self._domain_separator()
1954 
1955 
1956 # ------------------------- AMM Admin Functions ------------------------------
1957 
1958 
1959 @external
1960 def ramp_A_gamma(
1961     future_A: uint256, future_gamma: uint256, future_time: uint256
1962 ):
1963     """
1964     @notice Initialise Ramping A and gamma parameter values linearly.
1965     @dev Only accessible by factory admin, and only
1966     @param future_A The future A value.
1967     @param future_gamma The future gamma value.
1968     @param future_time The timestamp at which the ramping will end.
1969     """
1970     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1971     assert block.timestamp > self.initial_A_gamma_time + (MIN_RAMP_TIME - 1)  # dev: ramp undergoing
1972     assert future_time > block.timestamp + MIN_RAMP_TIME - 1  # dev: insufficient time
1973 
1974     A_gamma: uint256[2] = self._A_gamma()
1975     initial_A_gamma: uint256 = A_gamma[0] << 128
1976     initial_A_gamma = initial_A_gamma | A_gamma[1]
1977 
1978     assert future_A > MIN_A - 1
1979     assert future_A < MAX_A + 1
1980     assert future_gamma > MIN_GAMMA - 1
1981     assert future_gamma < MAX_GAMMA + 1
1982 
1983     ratio: uint256 = 10**18 * future_A / A_gamma[0]
1984     assert ratio < 10**18 * MAX_A_CHANGE + 1
1985     assert ratio > 10**18 / MAX_A_CHANGE - 1
1986 
1987     ratio = 10**18 * future_gamma / A_gamma[1]
1988     assert ratio < 10**18 * MAX_A_CHANGE + 1
1989     assert ratio > 10**18 / MAX_A_CHANGE - 1
1990 
1991     self.initial_A_gamma = initial_A_gamma
1992     self.initial_A_gamma_time = block.timestamp
1993 
1994     future_A_gamma: uint256 = future_A << 128
1995     future_A_gamma = future_A_gamma | future_gamma
1996     self.future_A_gamma_time = future_time
1997     self.future_A_gamma = future_A_gamma
1998 
1999     log RampAgamma(
2000         A_gamma[0],
2001         future_A,
2002         A_gamma[1],
2003         future_gamma,
2004         block.timestamp,
2005         future_time,
2006     )
2007 
2008 
2009 @external
2010 def stop_ramp_A_gamma():
2011     """
2012     @notice Stop Ramping A and gamma parameters immediately.
2013     @dev Only accessible by factory admin.
2014     """
2015     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
2016 
2017     A_gamma: uint256[2] = self._A_gamma()
2018     current_A_gamma: uint256 = A_gamma[0] << 128
2019     current_A_gamma = current_A_gamma | A_gamma[1]
2020     self.initial_A_gamma = current_A_gamma
2021     self.future_A_gamma = current_A_gamma
2022     self.initial_A_gamma_time = block.timestamp
2023     self.future_A_gamma_time = block.timestamp
2024 
2025     # ------ Now (block.timestamp < t1) is always False, so we return saved A.
2026 
2027     log StopRampA(A_gamma[0], A_gamma[1], block.timestamp)
2028 
2029 
2030 @external
2031 def commit_new_parameters(
2032     _new_mid_fee: uint256,
2033     _new_out_fee: uint256,
2034     _new_fee_gamma: uint256,
2035     _new_allowed_extra_profit: uint256,
2036     _new_adjustment_step: uint256,
2037     _new_ma_time: uint256,
2038 ):
2039     """
2040     @notice Commit new parameters.
2041     @dev Only accessible by factory admin.
2042     @param _new_mid_fee The new mid fee.
2043     @param _new_out_fee The new out fee.
2044     @param _new_fee_gamma The new fee gamma.
2045     @param _new_allowed_extra_profit The new allowed extra profit.
2046     @param _new_adjustment_step The new adjustment step.
2047     @param _new_ma_time The new ma time. ma_time is time_in_seconds/ln(2).
2048     """
2049     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
2050     assert self.admin_actions_deadline == 0  # dev: active action
2051 
2052     _deadline: uint256 = block.timestamp + ADMIN_ACTIONS_DELAY
2053     self.admin_actions_deadline = _deadline
2054 
2055     # ----------------------------- Set fee params ---------------------------
2056 
2057     new_mid_fee: uint256 = _new_mid_fee
2058     new_out_fee: uint256 = _new_out_fee
2059     new_fee_gamma: uint256 = _new_fee_gamma
2060 
2061     current_fee_params: uint256[3] = self._unpack(self.packed_fee_params)
2062 
2063     if new_out_fee < MAX_FEE + 1:
2064         assert new_out_fee > MIN_FEE - 1  # dev: fee is out of range
2065     else:
2066         new_out_fee = current_fee_params[1]
2067 
2068     if new_mid_fee > MAX_FEE:
2069         new_mid_fee = current_fee_params[0]
2070     assert new_mid_fee <= new_out_fee  # dev: mid-fee is too high
2071 
2072     if new_fee_gamma < 10**18:
2073         assert new_fee_gamma > 0  # dev: fee_gamma out of range [1 .. 10**18]
2074     else:
2075         new_fee_gamma = current_fee_params[2]
2076 
2077     self.future_packed_fee_params = self._pack(
2078         [new_mid_fee, new_out_fee, new_fee_gamma]
2079     )
2080 
2081     # ----------------- Set liquidity rebalancing parameters -----------------
2082 
2083     new_allowed_extra_profit: uint256 = _new_allowed_extra_profit
2084     new_adjustment_step: uint256 = _new_adjustment_step
2085     new_ma_time: uint256 = _new_ma_time
2086 
2087     current_rebalancing_params: uint256[3] = self._unpack(self.packed_rebalancing_params)
2088 
2089     if new_allowed_extra_profit > 10**18:
2090         new_allowed_extra_profit = current_rebalancing_params[0]
2091 
2092     if new_adjustment_step > 10**18:
2093         new_adjustment_step = current_rebalancing_params[1]
2094 
2095     if new_ma_time < 872542:  # <----- Calculated as: 7 * 24 * 60 * 60 / ln(2)
2096         assert new_ma_time > 86  # dev: MA time should be longer than 60/ln(2)
2097     else:
2098         new_ma_time = current_rebalancing_params[2]
2099 
2100     self.future_packed_rebalancing_params = self._pack(
2101         [new_allowed_extra_profit, new_adjustment_step, new_ma_time]
2102     )
2103 
2104     # ---------------------------------- LOG ---------------------------------
2105 
2106     log CommitNewParameters(
2107         _deadline,
2108         new_mid_fee,
2109         new_out_fee,
2110         new_fee_gamma,
2111         new_allowed_extra_profit,
2112         new_adjustment_step,
2113         new_ma_time,
2114     )
2115 
2116 
2117 @external
2118 @nonreentrant("lock")
2119 def apply_new_parameters():
2120     """
2121     @notice Apply committed parameters.
2122     @dev Only callable after admin_actions_deadline.
2123     """
2124     assert block.timestamp >= self.admin_actions_deadline  # dev: insufficient time
2125     assert self.admin_actions_deadline != 0  # dev: no active action
2126 
2127     self.admin_actions_deadline = 0
2128 
2129     packed_fee_params: uint256 = self.future_packed_fee_params
2130     self.packed_fee_params = packed_fee_params
2131 
2132     packed_rebalancing_params: uint256 = self.future_packed_rebalancing_params
2133     self.packed_rebalancing_params = packed_rebalancing_params
2134 
2135     rebalancing_params: uint256[3] = self._unpack(packed_rebalancing_params)
2136     fee_params: uint256[3] = self._unpack(packed_fee_params)
2137 
2138     log NewParameters(
2139         fee_params[0],
2140         fee_params[1],
2141         fee_params[2],
2142         rebalancing_params[0],
2143         rebalancing_params[1],
2144         rebalancing_params[2],
2145     )
2146 
2147 
2148 @external
2149 def revert_new_parameters():
2150     """
2151     @notice Revert committed parameters
2152     @dev Only accessible by factory admin. Setting admin_actions_deadline to 0
2153          ensures a revert in apply_new_parameters.
2154     """
2155     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
2156     self.admin_actions_deadline = 0