1 # @version 0.3.7
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
17 interface ERC1271:
18     def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view
19 
20 
21 event Transfer:
22     sender: indexed(address)
23     receiver: indexed(address)
24     value: uint256
25 
26 event Approval:
27     owner: indexed(address)
28     spender: indexed(address)
29     value: uint256
30 
31 event TokenExchange:
32     buyer: indexed(address)
33     sold_id: int128
34     tokens_sold: uint256
35     bought_id: int128
36     tokens_bought: uint256
37 
38 event AddLiquidity:
39     provider: indexed(address)
40     token_amounts: uint256[N_COINS]
41     fees: uint256[N_COINS]
42     invariant: uint256
43     token_supply: uint256
44 
45 event RemoveLiquidity:
46     provider: indexed(address)
47     token_amounts: uint256[N_COINS]
48     fees: uint256[N_COINS]
49     token_supply: uint256
50 
51 event RemoveLiquidityOne:
52     provider: indexed(address)
53     token_amount: uint256
54     coin_amount: uint256
55     token_supply: uint256
56 
57 event RemoveLiquidityImbalance:
58     provider: indexed(address)
59     token_amounts: uint256[N_COINS]
60     fees: uint256[N_COINS]
61     invariant: uint256
62     token_supply: uint256
63 
64 event RampA:
65     old_A: uint256
66     new_A: uint256
67     initial_time: uint256
68     future_time: uint256
69 
70 event StopRampA:
71     A: uint256
72     t: uint256
73 
74 event CommitNewFee:
75     new_fee: uint256
76 
77 event ApplyNewFee:
78     fee: uint256
79 
80 
81 N_COINS: constant(uint256) = 2
82 N_COINS_128: constant(int128) = 2
83 PRECISION: constant(uint256) = 10 ** 18
84 ADMIN_ACTIONS_DEADLINE_DT: constant(uint256) = 86400 * 3
85 
86 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
87 ADMIN_FEE: constant(uint256) = 5000000000
88 
89 A_PRECISION: constant(uint256) = 100
90 MAX_FEE: constant(uint256) = 5 * 10 ** 9
91 MAX_A: constant(uint256) = 10 ** 6
92 MAX_A_CHANGE: constant(uint256) = 10
93 MIN_RAMP_TIME: constant(uint256) = 86400
94 
95 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
96 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
97 
98 # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
99 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
100 VERSION: constant(String[8]) = "v6.0.0"
101 
102 
103 factory: address
104 
105 coins: public(address[N_COINS])
106 balances: public(uint256[N_COINS])
107 fee: public(uint256)  # fee * 1e10
108 future_fee: public(uint256)
109 admin_action_deadline: public(uint256)
110 
111 initial_A: public(uint256)
112 future_A: public(uint256)
113 initial_A_time: public(uint256)
114 future_A_time: public(uint256)
115 
116 rate_multipliers: uint256[N_COINS]
117 
118 name: public(String[64])
119 symbol: public(String[32])
120 
121 balanceOf: public(HashMap[address, uint256])
122 allowance: public(HashMap[address, HashMap[address, uint256]])
123 totalSupply: public(uint256)
124 
125 DOMAIN_SEPARATOR: public(bytes32)
126 nonces: public(HashMap[address, uint256])
127 
128 last_prices_packed: uint256  #  [last_price, ma_price]
129 ma_exp_time: public(uint256)
130 ma_last_time: public(uint256)
131 
132 
133 @external
134 def __init__():
135     # we do this to prevent the implementation contract from being used as a pool
136     self.factory = 0x0000000000000000000000000000000000000001
137     assert N_COINS == 2
138 
139 
140 @external
141 def initialize(
142     _name: String[32],
143     _symbol: String[10],
144     _coins: address[4],
145     _rate_multipliers: uint256[4],
146     _A: uint256,
147     _fee: uint256,
148 ):
149     """
150     @notice Contract constructor
151     @param _name Name of the new pool
152     @param _symbol Token symbol
153     @param _coins List of all ERC20 conract addresses of coins
154     @param _rate_multipliers List of number of decimals in coins
155     @param _A Amplification coefficient multiplied by n ** (n - 1)
156     @param _fee Fee to charge for exchanges
157     """
158     # check if factory was already set to prevent initializing contract twice
159     assert self.factory == empty(address)
160 
161     for i in range(N_COINS):
162         coin: address = _coins[i]
163         if coin == empty(address):
164             break
165         self.coins[i] = coin
166         self.rate_multipliers[i] = _rate_multipliers[i]
167 
168     A: uint256 = _A * A_PRECISION
169     self.initial_A = A
170     self.future_A = A
171     self.fee = _fee
172     self.factory = msg.sender
173 
174     self.ma_exp_time = 866  # = 600 / ln(2)
175     self.last_prices_packed = self.pack_prices(10**18, 10**18)
176     self.ma_last_time = block.timestamp
177 
178     name: String[64] = concat("Curve.fi Factory Plain Pool: ", _name)
179     self.name = name
180     self.symbol = concat(_symbol, "-f")
181 
182     self.DOMAIN_SEPARATOR = keccak256(
183         _abi_encode(EIP712_TYPEHASH, keccak256(name), keccak256(VERSION), chain.id, self)
184     )
185 
186     # fire a transfer event so block explorers identify the contract as an ERC20
187     log Transfer(empty(address), self, 0)
188 
189 
190 ### ERC20 Functionality ###
191 
192 @view
193 @external
194 def decimals() -> uint8:
195     """
196     @notice Get the number of decimals for this token
197     @dev Implemented as a view method to reduce gas costs
198     @return uint8 decimal places
199     """
200     return 18
201 
202 
203 @internal
204 def _transfer(_from: address, _to: address, _value: uint256):
205     # # NOTE: vyper does not allow underflows
206     # #       so the following subtraction would revert on insufficient balance
207     self.balanceOf[_from] -= _value
208     self.balanceOf[_to] += _value
209 
210     log Transfer(_from, _to, _value)
211 
212 
213 @external
214 def transfer(_to : address, _value : uint256) -> bool:
215     """
216     @dev Transfer token for a specified address
217     @param _to The address to transfer to.
218     @param _value The amount to be transferred.
219     """
220     self._transfer(msg.sender, _to, _value)
221     return True
222 
223 
224 @external
225 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
226     """
227      @dev Transfer tokens from one address to another.
228      @param _from address The address which you want to send tokens from
229      @param _to address The address which you want to transfer to
230      @param _value uint256 the amount of tokens to be transferred
231     """
232     self._transfer(_from, _to, _value)
233 
234     _allowance: uint256 = self.allowance[_from][msg.sender]
235     if _allowance != max_value(uint256):
236         self.allowance[_from][msg.sender] = _allowance - _value
237 
238     return True
239 
240 
241 @external
242 def approve(_spender : address, _value : uint256) -> bool:
243     """
244     @notice Approve the passed address to transfer the specified amount of
245             tokens on behalf of msg.sender
246     @dev Beware that changing an allowance via this method brings the risk that
247          someone may use both the old and new allowance by unfortunate transaction
248          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249     @param _spender The address which will transfer the funds
250     @param _value The amount of tokens that may be transferred
251     @return bool success
252     """
253     self.allowance[msg.sender][_spender] = _value
254 
255     log Approval(msg.sender, _spender, _value)
256     return True
257 
258 
259 @external
260 def permit(
261     _owner: address,
262     _spender: address,
263     _value: uint256,
264     _deadline: uint256,
265     _v: uint8,
266     _r: bytes32,
267     _s: bytes32
268 ) -> bool:
269     """
270     @notice Approves spender by owner's signature to expend owner's tokens.
271         See https://eips.ethereum.org/EIPS/eip-2612.
272     @dev Inspired by https://github.com/yearn/yearn-vaults/blob/main/contracts/Vault.vy#L753-L793
273     @dev Supports smart contract wallets which implement ERC1271
274         https://eips.ethereum.org/EIPS/eip-1271
275     @param _owner The address which is a source of funds and has signed the Permit.
276     @param _spender The address which is allowed to spend the funds.
277     @param _value The amount of tokens to be spent.
278     @param _deadline The timestamp after which the Permit is no longer valid.
279     @param _v The bytes[64] of the valid secp256k1 signature of permit by owner
280     @param _r The bytes[0:32] of the valid secp256k1 signature of permit by owner
281     @param _s The bytes[32:64] of the valid secp256k1 signature of permit by owner
282     @return True, if transaction completes successfully
283     """
284     assert _owner != empty(address)
285     assert block.timestamp <= _deadline
286 
287     nonce: uint256 = self.nonces[_owner]
288     digest: bytes32 = keccak256(
289         concat(
290             b"\x19\x01",
291             self.DOMAIN_SEPARATOR,
292             keccak256(_abi_encode(PERMIT_TYPEHASH, _owner, _spender, _value, nonce, _deadline))
293         )
294     )
295 
296     if _owner.is_contract:
297         sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
298         # reentrancy not a concern since this is a staticcall
299         assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
300     else:
301         assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
302 
303     self.allowance[_owner][_spender] = _value
304     self.nonces[_owner] = nonce + 1
305 
306     log Approval(_owner, _spender, _value)
307     return True
308 
309 
310 ### StableSwap Functionality ###
311 
312 @pure
313 @internal
314 def pack_prices(p1: uint256, p2: uint256) -> uint256:
315     assert p1 < 2**128
316     assert p2 < 2**128
317     return p1 | shift(p2, 128)
318 
319 
320 @view
321 @external
322 def last_price() -> uint256:
323     return self.last_prices_packed & (2**128 - 1)
324 
325 
326 @view
327 @external
328 def ema_price() -> uint256:
329     return shift(self.last_prices_packed, -128)
330 
331 
332 @view
333 @external
334 def get_balances() -> uint256[N_COINS]:
335     return self.balances
336 
337 
338 @view
339 @internal
340 def _A() -> uint256:
341     """
342     Handle ramping A up or down
343     """
344     t1: uint256 = self.future_A_time
345     A1: uint256 = self.future_A
346 
347     if block.timestamp < t1:
348         A0: uint256 = self.initial_A
349         t0: uint256 = self.initial_A_time
350         # Expressions in uint256 cannot have negative numbers, thus "if"
351         if A1 > A0:
352             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
353         else:
354             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
355 
356     else:  # when t1 == 0 or block.timestamp >= t1
357         return A1
358 
359 
360 @view
361 @external
362 def admin_fee() -> uint256:
363     return ADMIN_FEE
364 
365 
366 @view
367 @external
368 def A() -> uint256:
369     return self._A() / A_PRECISION
370 
371 
372 @view
373 @external
374 def A_precise() -> uint256:
375     return self._A()
376 
377 
378 @pure
379 @internal
380 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
381     result: uint256[N_COINS] = empty(uint256[N_COINS])
382     for i in range(N_COINS):
383         result[i] = _rates[i] * _balances[i] / PRECISION
384     return result
385 
386 
387 @pure
388 @internal
389 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
390     """
391     D invariant calculation in non-overflowing integer operations
392     iteratively
393 
394     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
395 
396     Converging solution:
397     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
398     """
399     S: uint256 = 0
400     for x in _xp:
401         S += x
402     if S == 0:
403         return 0
404 
405     D: uint256 = S
406     Ann: uint256 = _amp * N_COINS
407     for i in range(255):
408         D_P: uint256 = D * D / _xp[0] * D / _xp[1] / N_COINS**N_COINS
409         Dprev: uint256 = D
410         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
411         # Equality with the precision of 1
412         if D > Dprev:
413             if D - Dprev <= 1:
414                 return D
415         else:
416             if Dprev - D <= 1:
417                 return D
418     # convergence typically occurs in 4 rounds or less, this should be unreachable!
419     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
420     raise
421 
422 
423 @view
424 @internal
425 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
426     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
427     return self.get_D(xp, _amp)
428 
429 
430 @internal
431 @view
432 def _get_p(xp: uint256[N_COINS], amp: uint256, D: uint256) -> uint256:
433     # dx_0 / dx_1 only, however can have any number of coins in pool
434     ANN: uint256 = amp * N_COINS
435     Dr: uint256 = D / (N_COINS**N_COINS)
436     for i in range(N_COINS):
437         Dr = Dr * D / xp[i]
438     return 10**18 * (ANN * xp[0] / A_PRECISION + Dr * xp[0] / xp[1]) / (ANN * xp[0] / A_PRECISION + Dr)
439 
440 
441 @external
442 @view
443 def get_p() -> uint256:
444     amp: uint256 = self._A()
445     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, self.balances)
446     D: uint256 = self.get_D(xp, amp)
447     return self._get_p(xp, amp, D)
448 
449 
450 @internal
451 @view
452 def exp(power: int256) -> uint256:
453     if power <= -42139678854452767551:
454         return 0
455 
456     if power >= 135305999368893231589:
457         raise "exp overflow"
458 
459     x: int256 = unsafe_div(unsafe_mul(power, 2**96), 10**18)
460 
461     k: int256 = unsafe_div(
462         unsafe_add(
463             unsafe_div(unsafe_mul(x, 2**96), 54916777467707473351141471128),
464             2**95),
465         2**96)
466     x = unsafe_sub(x, unsafe_mul(k, 54916777467707473351141471128))
467 
468     y: int256 = unsafe_add(x, 1346386616545796478920950773328)
469     y = unsafe_add(unsafe_div(unsafe_mul(y, x), 2**96), 57155421227552351082224309758442)
470     p: int256 = unsafe_sub(unsafe_add(y, x), 94201549194550492254356042504812)
471     p = unsafe_add(unsafe_div(unsafe_mul(p, y), 2**96), 28719021644029726153956944680412240)
472     p = unsafe_add(unsafe_mul(p, x), (4385272521454847904659076985693276 * 2**96))
473 
474     q: int256 = x - 2855989394907223263936484059900
475     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 50020603652535783019961831881945)
476     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 533845033583426703283633433725380)
477     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 3604857256930695427073651918091429)
478     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 14423608567350463180887372962807573)
479     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 26449188498355588339934803723976023)
480 
481     return shift(
482         unsafe_mul(convert(unsafe_div(p, q), uint256), 3822833074963236453042738258902158003155416615667),
483         unsafe_sub(k, 195))
484 
485 
486 @internal
487 @view
488 def _ma_price() -> uint256:
489     ma_last_time: uint256 = self.ma_last_time
490 
491     pp: uint256 = self.last_prices_packed
492     last_price: uint256 = pp & (2**128 - 1)
493     last_ema_price: uint256 = shift(pp, -128)
494 
495     if ma_last_time < block.timestamp:
496         alpha: uint256 = self.exp(- convert((block.timestamp - ma_last_time) * 10**18 / self.ma_exp_time, int256))
497         return (last_price * (10**18 - alpha) + last_ema_price * alpha) / 10**18
498 
499     else:
500         return last_ema_price
501 
502 
503 @external
504 @view
505 @nonreentrant('lock')
506 def price_oracle() -> uint256:
507     return self._ma_price()
508 
509 
510 @internal
511 def save_p_from_price(last_price: uint256):
512     """
513     Saves current price and its EMA
514     """
515     if last_price != 0:
516         self.last_prices_packed = self.pack_prices(last_price, self._ma_price())
517         if self.ma_last_time < block.timestamp:
518             self.ma_last_time = block.timestamp
519 
520 
521 @internal
522 def save_p(xp: uint256[N_COINS], amp: uint256, D: uint256):
523     """
524     Saves current price and its EMA
525     """
526     self.save_p_from_price(self._get_p(xp, amp, D))
527 
528 
529 @view
530 @external
531 @nonreentrant('lock')
532 def get_virtual_price() -> uint256:
533     """
534     @notice The current virtual price of the pool LP token
535     @dev Useful for calculating profits
536     @return LP token virtual price normalized to 1e18
537     """
538     amp: uint256 = self._A()
539     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, self.balances)
540     D: uint256 = self.get_D(xp, amp)
541     # D is in the units similar to DAI (e.g. converted to precision 1e18)
542     # When balanced, D = n * x_u - total virtual value of the portfolio
543     return D * PRECISION / self.totalSupply
544 
545 
546 @view
547 @external
548 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
549     """
550     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
551     @dev This calculation accounts for slippage, but not fees.
552          Needed to prevent front-running, not for precise calculations!
553     @param _amounts Amount of each coin being deposited
554     @param _is_deposit set True for deposits, False for withdrawals
555     @return Expected amount of LP tokens received
556     """
557     amp: uint256 = self._A()
558     balances: uint256[N_COINS] = self.balances
559 
560     D0: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
561     for i in range(N_COINS):
562         amount: uint256 = _amounts[i]
563         if _is_deposit:
564             balances[i] += amount
565         else:
566             balances[i] -= amount
567     D1: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
568     diff: uint256 = 0
569     if _is_deposit:
570         diff = D1 - D0
571     else:
572         diff = D0 - D1
573     return diff * self.totalSupply / D0
574 
575 
576 @external
577 @nonreentrant('lock')
578 def add_liquidity(
579     _amounts: uint256[N_COINS],
580     _min_mint_amount: uint256,
581     _receiver: address = msg.sender
582 ) -> uint256:
583     """
584     @notice Deposit coins into the pool
585     @param _amounts List of amounts of coins to deposit
586     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
587     @param _receiver Address that owns the minted LP tokens
588     @return Amount of LP tokens received by depositing
589     """
590     amp: uint256 = self._A()
591     old_balances: uint256[N_COINS] = self.balances
592     rates: uint256[N_COINS] = self.rate_multipliers
593 
594     # Initial invariant
595     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
596 
597     total_supply: uint256 = self.totalSupply
598     new_balances: uint256[N_COINS] = old_balances
599     for i in range(N_COINS):
600         amount: uint256 = _amounts[i]
601         if amount > 0:
602             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amount, default_return_value=True)  # dev: failed transfer
603             new_balances[i] += amount
604         else:
605             assert total_supply != 0  # dev: initial deposit requires all coins
606 
607     # Invariant after change
608     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
609     assert D1 > D0
610 
611     # We need to recalculate the invariant accounting for fees
612     # to calculate fair user's share
613     fees: uint256[N_COINS] = empty(uint256[N_COINS])
614     mint_amount: uint256 = 0
615 
616     if total_supply > 0:
617         # Only account for fees if we are not the first to deposit
618         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
619         for i in range(N_COINS):
620             ideal_balance: uint256 = D1 * old_balances[i] / D0
621             difference: uint256 = 0
622             new_balance: uint256 = new_balances[i]
623             if ideal_balance > new_balance:
624                 difference = ideal_balance - new_balance
625             else:
626                 difference = new_balance - ideal_balance
627             fees[i] = base_fee * difference / FEE_DENOMINATOR
628             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
629             new_balances[i] -= fees[i]
630         xp: uint256[N_COINS] = self._xp_mem(rates, new_balances)
631         D2: uint256 = self.get_D(xp, amp)
632         mint_amount = total_supply * (D2 - D0) / D0
633         self.save_p(xp, amp, D2)
634 
635     else:
636         self.balances = new_balances
637         mint_amount = D1  # Take the dust if there was any
638 
639     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
640 
641     # Mint pool tokens
642     total_supply += mint_amount
643     self.balanceOf[_receiver] += mint_amount
644     self.totalSupply = total_supply
645     log Transfer(empty(address), _receiver, mint_amount)
646 
647     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
648 
649     return mint_amount
650 
651 
652 @view
653 @internal
654 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS], _amp: uint256, _D: uint256) -> uint256:
655     """
656     Calculate x[j] if one makes x[i] = x
657 
658     Done by solving quadratic equation iteratively.
659     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
660     x_1**2 + b*x_1 = c
661 
662     x_1 = (x_1**2 + c) / (2*x_1 + b)
663     """
664     # x in the input is converted to the same price/precision
665 
666     assert i != j       # dev: same coin
667     assert j >= 0       # dev: j below zero
668     assert j < N_COINS_128  # dev: j above N_COINS
669 
670     # should be unreachable, but good for safety
671     assert i >= 0
672     assert i < N_COINS_128
673 
674     amp: uint256 = _amp
675     D: uint256 = _D
676     if _D == 0:
677         amp = self._A()
678         D = self.get_D(xp, amp)
679     S_: uint256 = 0
680     _x: uint256 = 0
681     y_prev: uint256 = 0
682     c: uint256 = D
683     Ann: uint256 = amp * N_COINS
684 
685     for _i in range(N_COINS_128):
686         if _i == i:
687             _x = x
688         elif _i != j:
689             _x = xp[_i]
690         else:
691             continue
692         S_ += _x
693         c = c * D / (_x * N_COINS)
694 
695     c = c * D * A_PRECISION / (Ann * N_COINS)
696     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
697     y: uint256 = D
698 
699     for _i in range(255):
700         y_prev = y
701         y = (y*y + c) / (2 * y + b - D)
702         # Equality with the precision of 1
703         if y > y_prev:
704             if y - y_prev <= 1:
705                 return y
706         else:
707             if y_prev - y <= 1:
708                 return y
709     raise
710 
711 
712 @view
713 @external
714 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
715     """
716     @notice Calculate the current output dy given input dx
717     @dev Index values can be found via the `coins` public getter method
718     @param i Index value for the coin to send
719     @param j Index valie of the coin to recieve
720     @param dx Amount of `i` being exchanged
721     @return Amount of `j` predicted
722     """
723     rates: uint256[N_COINS] = self.rate_multipliers
724     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
725 
726     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
727     y: uint256 = self.get_y(i, j, x, xp, 0, 0)
728     dy: uint256 = xp[j] - y - 1
729     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
730     return (dy - fee) * PRECISION / rates[j]
731 
732 
733 # get_dx XXX
734 
735 
736 @external
737 @nonreentrant('lock')
738 def exchange(
739     i: int128,
740     j: int128,
741     _dx: uint256,
742     _min_dy: uint256,
743     _receiver: address = msg.sender,
744 ) -> uint256:
745     """
746     @notice Perform an exchange between two coins
747     @dev Index values can be found via the `coins` public getter method
748     @param i Index value for the coin to send
749     @param j Index valie of the coin to recieve
750     @param _dx Amount of `i` being exchanged
751     @param _min_dy Minimum amount of `j` to receive
752     @return Actual amount of `j` received
753     """
754     rates: uint256[N_COINS] = self.rate_multipliers
755     old_balances: uint256[N_COINS] = self.balances
756     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
757 
758     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
759 
760     amp: uint256 = self._A()
761     D: uint256 = self.get_D(xp, amp)
762     y: uint256 = self.get_y(i, j, x, xp, amp, D)
763 
764     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
765     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
766 
767     # Convert all to real units
768     dy = (dy - dy_fee) * PRECISION / rates[j]
769     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
770 
771     # xp is not used anymore, so we reuse it for price calc
772     xp[i] = x
773     xp[j] = y
774     # D is not changed because we did not apply a fee
775     self.save_p(xp, amp, D)
776 
777     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
778     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
779 
780     # Change balances exactly in same way as we change actual ERC20 coin amounts
781     self.balances[i] = old_balances[i] + _dx
782     # When rounding errors happen, we undercharge admin fee in favor of LP
783     self.balances[j] = old_balances[j] - dy - dy_admin_fee
784 
785     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, _dx, default_return_value=True)  # dev: failed transfer
786     assert ERC20(self.coins[j]).transfer(_receiver, dy, default_return_value=True)  # dev: failed transfer
787 
788     log TokenExchange(msg.sender, i, _dx, j, dy)
789 
790     return dy
791 
792 
793 @external
794 @nonreentrant('lock')
795 def remove_liquidity(
796     _burn_amount: uint256,
797     _min_amounts: uint256[N_COINS],
798     _receiver: address = msg.sender
799 ) -> uint256[N_COINS]:
800     """
801     @notice Withdraw coins from the pool
802     @dev Withdrawal amounts are based on current deposit ratios
803     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
804     @param _min_amounts Minimum amounts of underlying coins to receive
805     @param _receiver Address that receives the withdrawn coins
806     @return List of amounts of coins that were withdrawn
807     """
808     total_supply: uint256 = self.totalSupply
809     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
810 
811     for i in range(N_COINS):
812         old_balance: uint256 = self.balances[i]
813         value: uint256 = old_balance * _burn_amount / total_supply
814         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
815         self.balances[i] = old_balance - value
816         amounts[i] = value
817         assert ERC20(self.coins[i]).transfer(_receiver, value, default_return_value=True)  # dev: failed transfer
818 
819     total_supply -= _burn_amount
820     self.balanceOf[msg.sender] -= _burn_amount
821     self.totalSupply = total_supply
822     log Transfer(msg.sender, empty(address), _burn_amount)
823 
824     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
825 
826     return amounts
827 
828 
829 @external
830 @nonreentrant('lock')
831 def remove_liquidity_imbalance(
832     _amounts: uint256[N_COINS],
833     _max_burn_amount: uint256,
834     _receiver: address = msg.sender
835 ) -> uint256:
836     """
837     @notice Withdraw coins from the pool in an imbalanced amount
838     @param _amounts List of amounts of underlying coins to withdraw
839     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
840     @param _receiver Address that receives the withdrawn coins
841     @return Actual amount of the LP token burned in the withdrawal
842     """
843     amp: uint256 = self._A()
844     rates: uint256[N_COINS] = self.rate_multipliers
845     old_balances: uint256[N_COINS] = self.balances
846     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
847 
848     new_balances: uint256[N_COINS] = old_balances
849     for i in range(N_COINS):
850         amount: uint256 = _amounts[i]
851         if amount != 0:
852             new_balances[i] -= amount
853             assert ERC20(self.coins[i]).transfer(_receiver, amount, default_return_value=True)  # dev: failed transfer
854 
855     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
856 
857     fees: uint256[N_COINS] = empty(uint256[N_COINS])
858     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
859     for i in range(N_COINS):
860         ideal_balance: uint256 = D1 * old_balances[i] / D0
861         difference: uint256 = 0
862         new_balance: uint256 = new_balances[i]
863         if ideal_balance > new_balance:
864             difference = ideal_balance - new_balance
865         else:
866             difference = new_balance - ideal_balance
867         fees[i] = base_fee * difference / FEE_DENOMINATOR
868         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
869         new_balances[i] -= fees[i]
870     new_balances = self._xp_mem(rates, new_balances)
871     D2: uint256 = self.get_D(new_balances, amp)
872 
873     self.save_p(new_balances, amp, D2)
874 
875     total_supply: uint256 = self.totalSupply
876     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
877     assert burn_amount > 1  # dev: zero tokens burned
878     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
879 
880     total_supply -= burn_amount
881     self.totalSupply = total_supply
882     self.balanceOf[msg.sender] -= burn_amount
883     log Transfer(msg.sender, empty(address), burn_amount)
884     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
885 
886     return burn_amount
887 
888 
889 @pure
890 @internal
891 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
892     """
893     Calculate x[i] if one reduces D from being calculated for xp to D
894 
895     Done by solving quadratic equation iteratively.
896     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
897     x_1**2 + b*x_1 = c
898 
899     x_1 = (x_1**2 + c) / (2*x_1 + b)
900     """
901     # x in the input is converted to the same price/precision
902 
903     assert i >= 0  # dev: i below zero
904     assert i < N_COINS_128  # dev: i above N_COINS
905 
906     S_: uint256 = 0
907     _x: uint256 = 0
908     y_prev: uint256 = 0
909     c: uint256 = D
910     Ann: uint256 = A * N_COINS
911 
912     for _i in range(N_COINS_128):
913         if _i != i:
914             _x = xp[_i]
915         else:
916             continue
917         S_ += _x
918         c = c * D / (_x * N_COINS)
919 
920     c = c * D * A_PRECISION / (Ann * N_COINS)
921     b: uint256 = S_ + D * A_PRECISION / Ann
922     y: uint256 = D
923 
924     for _i in range(255):
925         y_prev = y
926         y = (y*y + c) / (2 * y + b - D)
927         # Equality with the precision of 1
928         if y > y_prev:
929             if y - y_prev <= 1:
930                 return y
931         else:
932             if y_prev - y <= 1:
933                 return y
934     raise
935 
936 
937 @view
938 @internal
939 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[3]:
940     # First, need to calculate
941     # * Get current D
942     # * Solve Eqn against y_i for D - _token_amount
943     amp: uint256 = self._A()
944     rates: uint256[N_COINS] = self.rate_multipliers
945     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
946     D0: uint256 = self.get_D(xp, amp)
947 
948     total_supply: uint256 = self.totalSupply
949     D1: uint256 = D0 - _burn_amount * D0 / total_supply
950     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
951 
952     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
953     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
954 
955     for j in range(N_COINS_128):
956         dx_expected: uint256 = 0
957         xp_j: uint256 = xp[j]
958         if j == i:
959             dx_expected = xp_j * D1 / D0 - new_y
960         else:
961             dx_expected = xp_j - xp_j * D1 / D0
962         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
963 
964     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
965     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
966     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
967 
968     xp[i] = new_y
969     last_p: uint256 = 0
970     if new_y > 0:
971         last_p = self._get_p(xp, amp, D1)
972 
973     return [dy, dy_0 - dy, last_p]
974 
975 
976 @view
977 @external
978 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
979     """
980     @notice Calculate the amount received when withdrawing a single coin
981     @param _burn_amount Amount of LP tokens to burn in the withdrawal
982     @param i Index value of the coin to withdraw
983     @return Amount of coin received
984     """
985     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
986 
987 
988 @external
989 @nonreentrant('lock')
990 def remove_liquidity_one_coin(
991     _burn_amount: uint256,
992     i: int128,
993     _min_received: uint256,
994     _receiver: address = msg.sender,
995 ) -> uint256:
996     """
997     @notice Withdraw a single coin from the pool
998     @param _burn_amount Amount of LP tokens to burn in the withdrawal
999     @param i Index value of the coin to withdraw
1000     @param _min_received Minimum amount of coin to receive
1001     @param _receiver Address that receives the withdrawn coins
1002     @return Amount of coin received
1003     """
1004     dy: uint256[3] = self._calc_withdraw_one_coin(_burn_amount, i)
1005     assert dy[0] >= _min_received, "Not enough coins removed"
1006 
1007     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
1008     total_supply: uint256 = self.totalSupply - _burn_amount
1009     self.totalSupply = total_supply
1010     self.balanceOf[msg.sender] -= _burn_amount
1011     log Transfer(msg.sender, empty(address), _burn_amount)
1012 
1013     assert ERC20(self.coins[i]).transfer(_receiver, dy[0], default_return_value=True)  # dev: failed transfer
1014     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
1015 
1016     self.save_p_from_price(dy[2])
1017 
1018     return dy[0]
1019 
1020 
1021 @external
1022 def ramp_A(_future_A: uint256, _future_time: uint256):
1023     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1024     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
1025     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
1026 
1027     _initial_A: uint256 = self._A()
1028     _future_A_p: uint256 = _future_A * A_PRECISION
1029 
1030     assert _future_A > 0 and _future_A < MAX_A
1031     if _future_A_p < _initial_A:
1032         assert _future_A_p * MAX_A_CHANGE >= _initial_A
1033     else:
1034         assert _future_A_p <= _initial_A * MAX_A_CHANGE
1035 
1036     self.initial_A = _initial_A
1037     self.future_A = _future_A_p
1038     self.initial_A_time = block.timestamp
1039     self.future_A_time = _future_time
1040 
1041     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
1042 
1043 
1044 @external
1045 def stop_ramp_A():
1046     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1047 
1048     current_A: uint256 = self._A()
1049     self.initial_A = current_A
1050     self.future_A = current_A
1051     self.initial_A_time = block.timestamp
1052     self.future_A_time = block.timestamp
1053     # now (block.timestamp < t1) is always False, so we return saved A
1054 
1055     log StopRampA(current_A, block.timestamp)
1056 
1057 
1058 @external
1059 def set_ma_exp_time(_ma_exp_time: uint256):
1060     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1061     assert _ma_exp_time != 0
1062 
1063     self.ma_exp_time = _ma_exp_time
1064 
1065 
1066 @view
1067 @external
1068 def admin_balances(i: uint256) -> uint256:
1069     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1070 
1071 
1072 @external
1073 def commit_new_fee(_new_fee: uint256):
1074     assert msg.sender == Factory(self.factory).admin()
1075     assert _new_fee <= MAX_FEE
1076     assert self.admin_action_deadline == 0
1077 
1078     self.future_fee = _new_fee
1079     self.admin_action_deadline = block.timestamp + ADMIN_ACTIONS_DEADLINE_DT
1080     log CommitNewFee(_new_fee)
1081 
1082 
1083 @external
1084 def apply_new_fee():
1085     assert msg.sender == Factory(self.factory).admin()
1086     deadline: uint256 = self.admin_action_deadline
1087     assert deadline != 0 and block.timestamp >= deadline
1088     
1089     fee: uint256 = self.future_fee
1090     self.fee = fee
1091     self.admin_action_deadline = 0
1092     log ApplyNewFee(fee)
1093 
1094 
1095 @external
1096 def withdraw_admin_fees():
1097     receiver: address = Factory(self.factory).get_fee_receiver(self)
1098 
1099     for i in range(N_COINS):
1100         coin: address = self.coins[i]
1101         fees: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
1102         assert ERC20(coin).transfer(receiver, fees, default_return_value=True)
1103 
1104 
1105 @pure
1106 @external
1107 def version() -> String[8]:
1108     """
1109     @notice Get the version of this token contract
1110     """
1111     return VERSION