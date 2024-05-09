1 # @version 0.3.7
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2023 - all rights reserved
6 @notice 2 coin pool implementation with no lending
7 @dev ERC20 support for return True/revert, return True/False, return None
8 """
9 
10 from vyper.interfaces import ERC20
11 
12 interface Factory:
13     def get_fee_receiver(_pool: address) -> address: view
14     def admin() -> address: view
15 
16 interface ERC1271:
17     def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view
18 
19 
20 event Transfer:
21     sender: indexed(address)
22     receiver: indexed(address)
23     value: uint256
24 
25 event Approval:
26     owner: indexed(address)
27     spender: indexed(address)
28     value: uint256
29 
30 event TokenExchange:
31     buyer: indexed(address)
32     sold_id: int128
33     tokens_sold: uint256
34     bought_id: int128
35     tokens_bought: uint256
36 
37 event AddLiquidity:
38     provider: indexed(address)
39     token_amounts: uint256[N_COINS]
40     fees: uint256[N_COINS]
41     invariant: uint256
42     token_supply: uint256
43 
44 event RemoveLiquidity:
45     provider: indexed(address)
46     token_amounts: uint256[N_COINS]
47     fees: uint256[N_COINS]
48     token_supply: uint256
49 
50 event RemoveLiquidityOne:
51     provider: indexed(address)
52     token_amount: uint256
53     coin_amount: uint256
54     token_supply: uint256
55 
56 event RemoveLiquidityImbalance:
57     provider: indexed(address)
58     token_amounts: uint256[N_COINS]
59     fees: uint256[N_COINS]
60     invariant: uint256
61     token_supply: uint256
62 
63 event RampA:
64     old_A: uint256
65     new_A: uint256
66     initial_time: uint256
67     future_time: uint256
68 
69 event StopRampA:
70     A: uint256
71     t: uint256
72 
73 event CommitNewFee:
74     new_fee: uint256
75 
76 event ApplyNewFee:
77     fee: uint256
78 
79 
80 N_COINS: constant(uint256) = 2
81 N_COINS_128: constant(int128) = 2
82 PRECISION: constant(uint256) = 10 ** 18
83 ADMIN_ACTIONS_DEADLINE_DT: constant(uint256) = 86400 * 3
84 
85 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
86 ADMIN_FEE: constant(uint256) = 5000000000
87 
88 A_PRECISION: constant(uint256) = 100
89 MAX_FEE: constant(uint256) = 5 * 10 ** 9
90 MAX_A: constant(uint256) = 10 ** 6
91 MAX_A_CHANGE: constant(uint256) = 10
92 MIN_RAMP_TIME: constant(uint256) = 86400
93 
94 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
95 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
96 
97 # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
98 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
99 VERSION: constant(String[8]) = "v6.0.1"
100 
101 
102 factory: public(address)
103 
104 coins: public(address[N_COINS])
105 balances: public(uint256[N_COINS])
106 fee: public(uint256)  # fee * 1e10
107 future_fee: public(uint256)
108 admin_action_deadline: public(uint256)
109 
110 initial_A: public(uint256)
111 future_A: public(uint256)
112 initial_A_time: public(uint256)
113 future_A_time: public(uint256)
114 
115 rate_multipliers: uint256[N_COINS]
116 
117 name: public(String[64])
118 symbol: public(String[32])
119 
120 balanceOf: public(HashMap[address, uint256])
121 allowance: public(HashMap[address, HashMap[address, uint256]])
122 totalSupply: public(uint256)
123 
124 DOMAIN_SEPARATOR: public(bytes32)
125 nonces: public(HashMap[address, uint256])
126 
127 last_prices_packed: uint256  #  [last_price, ma_price]
128 ma_exp_time: public(uint256)
129 ma_last_time: public(uint256)
130 
131 
132 @external
133 def __init__():
134     # we do this to prevent the implementation contract from being used as a pool
135     self.factory = 0x0000000000000000000000000000000000000001
136     assert N_COINS == 2
137 
138 
139 @external
140 def initialize(
141     _name: String[32],
142     _symbol: String[10],
143     _coins: address[4],
144     _rate_multipliers: uint256[4],
145     _A: uint256,
146     _fee: uint256,
147 ):
148     """
149     @notice Contract constructor
150     @param _name Name of the new pool
151     @param _symbol Token symbol
152     @param _coins List of all ERC20 conract addresses of coins
153     @param _rate_multipliers List of number of decimals in coins
154     @param _A Amplification coefficient multiplied by n ** (n - 1)
155     @param _fee Fee to charge for exchanges
156     """
157     # check if factory was already set to prevent initializing contract twice
158     assert self.factory == empty(address)
159 
160     for i in range(N_COINS):
161         coin: address = _coins[i]
162         if coin == empty(address):
163             break
164         self.coins[i] = coin
165         self.rate_multipliers[i] = _rate_multipliers[i]
166 
167     A: uint256 = _A * A_PRECISION
168     self.initial_A = A
169     self.future_A = A
170     self.fee = _fee
171     self.factory = msg.sender
172     self.ma_exp_time = 866  # = 600 / ln(2)
173     self.last_prices_packed = self.pack_prices(10**18, 10**18)
174     self.ma_last_time = block.timestamp
175 
176     name: String[64] = concat("Curve.fi Factory Plain Pool: ", _name)
177     self.name = name
178     self.symbol = concat(_symbol, "-f")
179 
180     self.DOMAIN_SEPARATOR = keccak256(
181         _abi_encode(EIP712_TYPEHASH, keccak256(name), keccak256(VERSION), chain.id, self)
182     )
183 
184     # fire a transfer event so block explorers identify the contract as an ERC20
185     log Transfer(empty(address), self, 0)
186 
187 
188 ### ERC20 Functionality ###
189 
190 @view
191 @external
192 def decimals() -> uint8:
193     """
194     @notice Get the number of decimals for this token
195     @dev Implemented as a view method to reduce gas costs
196     @return uint8 decimal places
197     """
198     return 18
199 
200 
201 @internal
202 def _transfer(_from: address, _to: address, _value: uint256):
203     # # NOTE: vyper does not allow underflows
204     # #       so the following subtraction would revert on insufficient balance
205     self.balanceOf[_from] -= _value
206     self.balanceOf[_to] += _value
207 
208     log Transfer(_from, _to, _value)
209 
210 
211 @external
212 def transfer(_to : address, _value : uint256) -> bool:
213     """
214     @dev Transfer token for a specified address
215     @param _to The address to transfer to.
216     @param _value The amount to be transferred.
217     """
218     self._transfer(msg.sender, _to, _value)
219     return True
220 
221 
222 @external
223 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
224     """
225      @dev Transfer tokens from one address to another.
226      @param _from address The address which you want to send tokens from
227      @param _to address The address which you want to transfer to
228      @param _value uint256 the amount of tokens to be transferred
229     """
230     self._transfer(_from, _to, _value)
231 
232     _allowance: uint256 = self.allowance[_from][msg.sender]
233     if _allowance != max_value(uint256):
234         self.allowance[_from][msg.sender] = _allowance - _value
235 
236     return True
237 
238 
239 @external
240 def approve(_spender : address, _value : uint256) -> bool:
241     """
242     @notice Approve the passed address to transfer the specified amount of
243             tokens on behalf of msg.sender
244     @dev Beware that changing an allowance via this method brings the risk that
245          someone may use both the old and new allowance by unfortunate transaction
246          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247     @param _spender The address which will transfer the funds
248     @param _value The amount of tokens that may be transferred
249     @return bool success
250     """
251     self.allowance[msg.sender][_spender] = _value
252 
253     log Approval(msg.sender, _spender, _value)
254     return True
255 
256 
257 @external
258 def permit(
259     _owner: address,
260     _spender: address,
261     _value: uint256,
262     _deadline: uint256,
263     _v: uint8,
264     _r: bytes32,
265     _s: bytes32
266 ) -> bool:
267     """
268     @notice Approves spender by owner's signature to expend owner's tokens.
269         See https://eips.ethereum.org/EIPS/eip-2612.
270     @dev Inspired by https://github.com/yearn/yearn-vaults/blob/main/contracts/Vault.vy#L753-L793
271     @dev Supports smart contract wallets which implement ERC1271
272         https://eips.ethereum.org/EIPS/eip-1271
273     @param _owner The address which is a source of funds and has signed the Permit.
274     @param _spender The address which is allowed to spend the funds.
275     @param _value The amount of tokens to be spent.
276     @param _deadline The timestamp after which the Permit is no longer valid.
277     @param _v The bytes[64] of the valid secp256k1 signature of permit by owner
278     @param _r The bytes[0:32] of the valid secp256k1 signature of permit by owner
279     @param _s The bytes[32:64] of the valid secp256k1 signature of permit by owner
280     @return True, if transaction completes successfully
281     """
282     assert _owner != empty(address)
283     assert block.timestamp <= _deadline
284 
285     nonce: uint256 = self.nonces[_owner]
286     digest: bytes32 = keccak256(
287         concat(
288             b"\x19\x01",
289             self.DOMAIN_SEPARATOR,
290             keccak256(_abi_encode(PERMIT_TYPEHASH, _owner, _spender, _value, nonce, _deadline))
291         )
292     )
293 
294     if _owner.is_contract:
295         sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
296         # reentrancy not a concern since this is a staticcall
297         assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
298     else:
299         assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
300 
301     self.allowance[_owner][_spender] = _value
302     self.nonces[_owner] = nonce + 1
303 
304     log Approval(_owner, _spender, _value)
305     return True
306 
307 
308 ### StableSwap Functionality ###
309 
310 @pure
311 @internal
312 def pack_prices(p1: uint256, p2: uint256) -> uint256:
313     assert p1 < 2**128
314     assert p2 < 2**128
315     return p1 | shift(p2, 128)
316 
317 
318 @view
319 @external
320 def last_price() -> uint256:
321     return self.last_prices_packed & (2**128 - 1)
322 
323 
324 @view
325 @external
326 def ema_price() -> uint256:
327     return shift(self.last_prices_packed, -128)
328 
329 
330 @view
331 @external
332 def get_balances() -> uint256[N_COINS]:
333     return self.balances
334 
335 
336 @view
337 @internal
338 def _A() -> uint256:
339     """
340     Handle ramping A up or down
341     """
342     t1: uint256 = self.future_A_time
343     A1: uint256 = self.future_A
344 
345     if block.timestamp < t1:
346         A0: uint256 = self.initial_A
347         t0: uint256 = self.initial_A_time
348         # Expressions in uint256 cannot have negative numbers, thus "if"
349         if A1 > A0:
350             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
351         else:
352             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
353 
354     else:  # when t1 == 0 or block.timestamp >= t1
355         return A1
356 
357 
358 @view
359 @external
360 def admin_fee() -> uint256:
361     return ADMIN_FEE
362 
363 
364 @view
365 @external
366 def A() -> uint256:
367     return self._A() / A_PRECISION
368 
369 
370 @view
371 @external
372 def A_precise() -> uint256:
373     return self._A()
374 
375 
376 @pure
377 @internal
378 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
379     result: uint256[N_COINS] = empty(uint256[N_COINS])
380     for i in range(N_COINS):
381         result[i] = _rates[i] * _balances[i] / PRECISION
382     return result
383 
384 
385 @pure
386 @internal
387 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
388     """
389     D invariant calculation in non-overflowing integer operations
390     iteratively
391 
392     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
393 
394     Converging solution:
395     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
396     """
397     S: uint256 = 0
398     for x in _xp:
399         S += x
400     if S == 0:
401         return 0
402 
403     D: uint256 = S
404     Ann: uint256 = _amp * N_COINS
405     for i in range(255):
406         D_P: uint256 = D * D / _xp[0] * D / _xp[1] / N_COINS**N_COINS
407         Dprev: uint256 = D
408         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
409         # Equality with the precision of 1
410         if D > Dprev:
411             if D - Dprev <= 1:
412                 return D
413         else:
414             if Dprev - D <= 1:
415                 return D
416     # convergence typically occurs in 4 rounds or less, this should be unreachable!
417     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
418     raise
419 
420 
421 @view
422 @internal
423 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
424     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
425     return self.get_D(xp, _amp)
426 
427 
428 @internal
429 @view
430 def _get_p(xp: uint256[N_COINS], amp: uint256, D: uint256) -> uint256:
431     # dx_0 / dx_1 only, however can have any number of coins in pool
432     ANN: uint256 = amp * N_COINS
433     Dr: uint256 = D / (N_COINS**N_COINS)
434     for i in range(N_COINS):
435         Dr = Dr * D / xp[i]
436     return 10**18 * (ANN * xp[0] / A_PRECISION + Dr * xp[0] / xp[1]) / (ANN * xp[0] / A_PRECISION + Dr)
437 
438 
439 @external
440 @view
441 def get_p() -> uint256:
442     amp: uint256 = self._A()
443     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, self.balances)
444     D: uint256 = self.get_D(xp, amp)
445     return self._get_p(xp, amp, D)
446 
447 
448 @internal
449 @view
450 def exp(power: int256) -> uint256:
451     if power <= -42139678854452767551:
452         return 0
453 
454     if power >= 135305999368893231589:
455         raise "exp overflow"
456 
457     x: int256 = unsafe_div(unsafe_mul(power, 2**96), 10**18)
458 
459     k: int256 = unsafe_div(
460         unsafe_add(
461             unsafe_div(unsafe_mul(x, 2**96), 54916777467707473351141471128),
462             2**95),
463         2**96)
464     x = unsafe_sub(x, unsafe_mul(k, 54916777467707473351141471128))
465 
466     y: int256 = unsafe_add(x, 1346386616545796478920950773328)
467     y = unsafe_add(unsafe_div(unsafe_mul(y, x), 2**96), 57155421227552351082224309758442)
468     p: int256 = unsafe_sub(unsafe_add(y, x), 94201549194550492254356042504812)
469     p = unsafe_add(unsafe_div(unsafe_mul(p, y), 2**96), 28719021644029726153956944680412240)
470     p = unsafe_add(unsafe_mul(p, x), (4385272521454847904659076985693276 * 2**96))
471 
472     q: int256 = x - 2855989394907223263936484059900
473     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 50020603652535783019961831881945)
474     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 533845033583426703283633433725380)
475     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 3604857256930695427073651918091429)
476     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 14423608567350463180887372962807573)
477     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 26449188498355588339934803723976023)
478 
479     return shift(
480         unsafe_mul(convert(unsafe_div(p, q), uint256), 3822833074963236453042738258902158003155416615667),
481         unsafe_sub(k, 195))
482 
483 
484 @internal
485 @view
486 def _ma_price() -> uint256:
487     ma_last_time: uint256 = self.ma_last_time
488 
489     pp: uint256 = self.last_prices_packed
490     last_price: uint256 = min(pp & (2**128 - 1), 2 * 10**18)
491     last_ema_price: uint256 = shift(pp, -128)
492 
493     if ma_last_time < block.timestamp:
494         alpha: uint256 = self.exp(- convert((block.timestamp - ma_last_time) * 10**18 / self.ma_exp_time, int256))
495         return (last_price * (10**18 - alpha) + last_ema_price * alpha) / 10**18
496 
497     else:
498         return last_ema_price
499 
500 
501 @external
502 @view
503 def price_oracle() -> uint256:
504     return self._ma_price()
505 
506 
507 @internal
508 def save_p_from_price(last_price: uint256):
509     """
510     Saves current price and its EMA
511     """
512     if last_price != 0:
513         self.last_prices_packed = self.pack_prices(last_price, self._ma_price())
514         if self.ma_last_time < block.timestamp:
515             self.ma_last_time = block.timestamp
516 
517 
518 @internal
519 def save_p(xp: uint256[N_COINS], amp: uint256, D: uint256):
520     """
521     Saves current price and its EMA
522     """
523     self.save_p_from_price(self._get_p(xp, amp, D))
524 
525 
526 @view
527 @external
528 def get_virtual_price() -> uint256:
529     """
530     @notice The current virtual price of the pool LP token
531     @dev Useful for calculating profits
532     @return LP token virtual price normalized to 1e18
533     """
534     amp: uint256 = self._A()
535     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, self.balances)
536     D: uint256 = self.get_D(xp, amp)
537     # D is in the units similar to DAI (e.g. converted to precision 1e18)
538     # When balanced, D = n * x_u - total virtual value of the portfolio
539     return D * PRECISION / self.totalSupply
540 
541 
542 @view
543 @external
544 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
545     """
546     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
547     @param _amounts Amount of each coin being deposited
548     @param _is_deposit set True for deposits, False for withdrawals
549     @return Expected amount of LP tokens received
550     """
551     amp: uint256 = self._A()
552     old_balances: uint256[N_COINS] = self.balances
553     rates: uint256[N_COINS] = self.rate_multipliers
554 
555     # Initial invariant
556     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
557 
558     total_supply: uint256 = self.totalSupply
559     new_balances: uint256[N_COINS] = old_balances
560     for i in range(N_COINS):
561         amount: uint256 = _amounts[i]
562         if _is_deposit:
563             new_balances[i] += amount
564         else:
565             new_balances[i] -= amount
566 
567     # Invariant after change
568     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
569 
570     # We need to recalculate the invariant accounting for fees
571     # to calculate fair user's share
572     D2: uint256 = D1
573     if total_supply > 0:
574         # Only account for fees if we are not the first to deposit
575         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
576         for i in range(N_COINS):
577             ideal_balance: uint256 = D1 * old_balances[i] / D0
578             difference: uint256 = 0
579             new_balance: uint256 = new_balances[i]
580             if ideal_balance > new_balance:
581                 difference = ideal_balance - new_balance
582             else:
583                 difference = new_balance - ideal_balance
584             new_balances[i] -= base_fee * difference / FEE_DENOMINATOR
585         xp: uint256[N_COINS] = self._xp_mem(rates, new_balances)
586         D2 = self.get_D(xp, amp)
587     else:
588         return D1  # Take the dust if there was any
589 
590 
591     diff: uint256 = 0
592     if _is_deposit:
593         diff = D2 - D0
594     else:
595         diff = D0 - D2
596     return diff * total_supply / D0
597 
598 
599 @external
600 @nonreentrant('lock')
601 def add_liquidity(
602     _amounts: uint256[N_COINS],
603     _min_mint_amount: uint256,
604     _receiver: address = msg.sender
605 ) -> uint256:
606     """
607     @notice Deposit coins into the pool
608     @param _amounts List of amounts of coins to deposit
609     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
610     @param _receiver Address that owns the minted LP tokens
611     @return Amount of LP tokens received by depositing
612     """
613     amp: uint256 = self._A()
614     old_balances: uint256[N_COINS] = self.balances
615     rates: uint256[N_COINS] = self.rate_multipliers
616 
617     # Initial invariant
618     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
619 
620     total_supply: uint256 = self.totalSupply
621     new_balances: uint256[N_COINS] = old_balances
622     for i in range(N_COINS):
623         amount: uint256 = _amounts[i]
624         if amount > 0:
625             assert ERC20(self.coins[i]).transferFrom(msg.sender, self, amount, default_return_value=True)  # dev: failed transfer
626             new_balances[i] += amount
627         else:
628             assert total_supply != 0  # dev: initial deposit requires all coins
629 
630     # Invariant after change
631     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
632     assert D1 > D0
633 
634     # We need to recalculate the invariant accounting for fees
635     # to calculate fair user's share
636     fees: uint256[N_COINS] = empty(uint256[N_COINS])
637     mint_amount: uint256 = 0
638 
639     if total_supply > 0:
640         # Only account for fees if we are not the first to deposit
641         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
642         for i in range(N_COINS):
643             ideal_balance: uint256 = D1 * old_balances[i] / D0
644             difference: uint256 = 0
645             new_balance: uint256 = new_balances[i]
646             if ideal_balance > new_balance:
647                 difference = ideal_balance - new_balance
648             else:
649                 difference = new_balance - ideal_balance
650             fees[i] = base_fee * difference / FEE_DENOMINATOR
651             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
652             new_balances[i] -= fees[i]
653         xp: uint256[N_COINS] = self._xp_mem(rates, new_balances)
654         D2: uint256 = self.get_D(xp, amp)
655         mint_amount = total_supply * (D2 - D0) / D0
656         self.save_p(xp, amp, D2)
657 
658     else:
659         self.balances = new_balances
660         mint_amount = D1  # Take the dust if there was any
661 
662     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
663 
664     # Mint pool tokens
665     total_supply += mint_amount
666     self.balanceOf[_receiver] += mint_amount
667     self.totalSupply = total_supply
668     log Transfer(empty(address), _receiver, mint_amount)
669 
670     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
671 
672     return mint_amount
673 
674 
675 @view
676 @internal
677 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS], _amp: uint256, _D: uint256) -> uint256:
678     """
679     Calculate x[j] if one makes x[i] = x
680 
681     Done by solving quadratic equation iteratively.
682     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
683     x_1**2 + b*x_1 = c
684 
685     x_1 = (x_1**2 + c) / (2*x_1 + b)
686     """
687     # x in the input is converted to the same price/precision
688 
689     assert i != j       # dev: same coin
690     assert j >= 0       # dev: j below zero
691     assert j < N_COINS_128  # dev: j above N_COINS
692 
693     # should be unreachable, but good for safety
694     assert i >= 0
695     assert i < N_COINS_128
696 
697     amp: uint256 = _amp
698     D: uint256 = _D
699     if _D == 0:
700         amp = self._A()
701         D = self.get_D(xp, amp)
702     S_: uint256 = 0
703     _x: uint256 = 0
704     y_prev: uint256 = 0
705     c: uint256 = D
706     Ann: uint256 = amp * N_COINS
707 
708     for _i in range(N_COINS_128):
709         if _i == i:
710             _x = x
711         elif _i != j:
712             _x = xp[_i]
713         else:
714             continue
715         S_ += _x
716         c = c * D / (_x * N_COINS)
717 
718     c = c * D * A_PRECISION / (Ann * N_COINS)
719     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
720     y: uint256 = D
721 
722     for _i in range(255):
723         y_prev = y
724         y = (y*y + c) / (2 * y + b - D)
725         # Equality with the precision of 1
726         if y > y_prev:
727             if y - y_prev <= 1:
728                 return y
729         else:
730             if y_prev - y <= 1:
731                 return y
732     raise
733 
734 
735 @view
736 @external
737 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
738     """
739     @notice Calculate the current output dy given input dx
740     @dev Index values can be found via the `coins` public getter method
741     @param i Index value for the coin to send
742     @param j Index valie of the coin to recieve
743     @param dx Amount of `i` being exchanged
744     @return Amount of `j` predicted
745     """
746     rates: uint256[N_COINS] = self.rate_multipliers
747     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
748 
749     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
750     y: uint256 = self.get_y(i, j, x, xp, 0, 0)
751     dy: uint256 = xp[j] - y - 1
752     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
753     return (dy - fee) * PRECISION / rates[j]
754 
755 
756 @view
757 @external
758 def get_dx(i: int128, j: int128, dy: uint256) -> uint256:
759     """
760     @notice Calculate the current input dx given output dy
761     @dev Index values can be found via the `coins` public getter method
762     @param i Index value for the coin to send
763     @param j Index valie of the coin to recieve
764     @param dy Amount of `j` being received after exchange
765     @return Amount of `i` predicted
766     """
767     rates: uint256[N_COINS] = self.rate_multipliers
768     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
769 
770     y: uint256 = xp[j] - (dy * rates[j] / PRECISION + 1) * FEE_DENOMINATOR / (FEE_DENOMINATOR - self.fee)
771     x: uint256 = self.get_y(j, i, y, xp, 0, 0)
772     return (x - xp[i]) * PRECISION / rates[i]
773 
774 
775 @external
776 @nonreentrant('lock')
777 def exchange(
778     i: int128,
779     j: int128,
780     _dx: uint256,
781     _min_dy: uint256,
782     _receiver: address = msg.sender,
783 ) -> uint256:
784     """
785     @notice Perform an exchange between two coins
786     @dev Index values can be found via the `coins` public getter method
787     @param i Index value for the coin to send
788     @param j Index valie of the coin to recieve
789     @param _dx Amount of `i` being exchanged
790     @param _min_dy Minimum amount of `j` to receive
791     @return Actual amount of `j` received
792     """
793     rates: uint256[N_COINS] = self.rate_multipliers
794     old_balances: uint256[N_COINS] = self.balances
795     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
796 
797     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
798 
799     amp: uint256 = self._A()
800     D: uint256 = self.get_D(xp, amp)
801     y: uint256 = self.get_y(i, j, x, xp, amp, D)
802 
803     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
804     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
805 
806     # Convert all to real units
807     dy = (dy - dy_fee) * PRECISION / rates[j]
808     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
809 
810     # xp is not used anymore, so we reuse it for price calc
811     xp[i] = x
812     xp[j] = y
813     # D is not changed because we did not apply a fee
814     self.save_p(xp, amp, D)
815 
816     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
817     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
818 
819     # Change balances exactly in same way as we change actual ERC20 coin amounts
820     self.balances[i] = old_balances[i] + _dx
821     # When rounding errors happen, we undercharge admin fee in favor of LP
822     self.balances[j] = old_balances[j] - dy - dy_admin_fee
823 
824     assert ERC20(self.coins[i]).transferFrom(msg.sender, self, _dx, default_return_value=True)  # dev: failed transfer
825     assert ERC20(self.coins[j]).transfer(_receiver, dy, default_return_value=True)  # dev: failed transfer
826 
827     log TokenExchange(msg.sender, i, _dx, j, dy)
828 
829     return dy
830 
831 
832 @external
833 @nonreentrant('lock')
834 def remove_liquidity(
835     _burn_amount: uint256,
836     _min_amounts: uint256[N_COINS],
837     _receiver: address = msg.sender
838 ) -> uint256[N_COINS]:
839     """
840     @notice Withdraw coins from the pool
841     @dev Withdrawal amounts are based on current deposit ratios
842     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
843     @param _min_amounts Minimum amounts of underlying coins to receive
844     @param _receiver Address that receives the withdrawn coins
845     @return List of amounts of coins that were withdrawn
846     """
847     total_supply: uint256 = self.totalSupply
848     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
849 
850     for i in range(N_COINS):
851         old_balance: uint256 = self.balances[i]
852         value: uint256 = old_balance * _burn_amount / total_supply
853         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
854         self.balances[i] = old_balance - value
855         amounts[i] = value
856         assert ERC20(self.coins[i]).transfer(_receiver, value, default_return_value=True)  # dev: failed transfer
857 
858     total_supply -= _burn_amount
859     self.balanceOf[msg.sender] -= _burn_amount
860     self.totalSupply = total_supply
861     log Transfer(msg.sender, empty(address), _burn_amount)
862 
863     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
864 
865     return amounts
866 
867 
868 @external
869 @nonreentrant('lock')
870 def remove_liquidity_imbalance(
871     _amounts: uint256[N_COINS],
872     _max_burn_amount: uint256,
873     _receiver: address = msg.sender
874 ) -> uint256:
875     """
876     @notice Withdraw coins from the pool in an imbalanced amount
877     @param _amounts List of amounts of underlying coins to withdraw
878     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
879     @param _receiver Address that receives the withdrawn coins
880     @return Actual amount of the LP token burned in the withdrawal
881     """
882     amp: uint256 = self._A()
883     rates: uint256[N_COINS] = self.rate_multipliers
884     old_balances: uint256[N_COINS] = self.balances
885     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
886 
887     new_balances: uint256[N_COINS] = old_balances
888     for i in range(N_COINS):
889         amount: uint256 = _amounts[i]
890         if amount != 0:
891             new_balances[i] -= amount
892             assert ERC20(self.coins[i]).transfer(_receiver, amount, default_return_value=True)  # dev: failed transfer
893 
894     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
895 
896     fees: uint256[N_COINS] = empty(uint256[N_COINS])
897     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
898     for i in range(N_COINS):
899         ideal_balance: uint256 = D1 * old_balances[i] / D0
900         difference: uint256 = 0
901         new_balance: uint256 = new_balances[i]
902         if ideal_balance > new_balance:
903             difference = ideal_balance - new_balance
904         else:
905             difference = new_balance - ideal_balance
906         fees[i] = base_fee * difference / FEE_DENOMINATOR
907         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
908         new_balances[i] -= fees[i]
909     new_balances = self._xp_mem(rates, new_balances)
910     D2: uint256 = self.get_D(new_balances, amp)
911 
912     self.save_p(new_balances, amp, D2)
913 
914     total_supply: uint256 = self.totalSupply
915     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
916     assert burn_amount > 1  # dev: zero tokens burned
917     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
918 
919     total_supply -= burn_amount
920     self.totalSupply = total_supply
921     self.balanceOf[msg.sender] -= burn_amount
922     log Transfer(msg.sender, empty(address), burn_amount)
923     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
924 
925     return burn_amount
926 
927 
928 @pure
929 @internal
930 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
931     """
932     Calculate x[i] if one reduces D from being calculated for xp to D
933 
934     Done by solving quadratic equation iteratively.
935     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
936     x_1**2 + b*x_1 = c
937 
938     x_1 = (x_1**2 + c) / (2*x_1 + b)
939     """
940     # x in the input is converted to the same price/precision
941 
942     assert i >= 0  # dev: i below zero
943     assert i < N_COINS_128  # dev: i above N_COINS
944 
945     S_: uint256 = 0
946     _x: uint256 = 0
947     y_prev: uint256 = 0
948     c: uint256 = D
949     Ann: uint256 = A * N_COINS
950 
951     for _i in range(N_COINS_128):
952         if _i != i:
953             _x = xp[_i]
954         else:
955             continue
956         S_ += _x
957         c = c * D / (_x * N_COINS)
958 
959     c = c * D * A_PRECISION / (Ann * N_COINS)
960     b: uint256 = S_ + D * A_PRECISION / Ann
961     y: uint256 = D
962 
963     for _i in range(255):
964         y_prev = y
965         y = (y*y + c) / (2 * y + b - D)
966         # Equality with the precision of 1
967         if y > y_prev:
968             if y - y_prev <= 1:
969                 return y
970         else:
971             if y_prev - y <= 1:
972                 return y
973     raise
974 
975 
976 @view
977 @internal
978 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[3]:
979     # First, need to calculate
980     # * Get current D
981     # * Solve Eqn against y_i for D - _token_amount
982     amp: uint256 = self._A()
983     rates: uint256[N_COINS] = self.rate_multipliers
984     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
985     D0: uint256 = self.get_D(xp, amp)
986 
987     total_supply: uint256 = self.totalSupply
988     D1: uint256 = D0 - _burn_amount * D0 / total_supply
989     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
990 
991     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
992     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
993 
994     for j in range(N_COINS_128):
995         dx_expected: uint256 = 0
996         xp_j: uint256 = xp[j]
997         if j == i:
998             dx_expected = xp_j * D1 / D0 - new_y
999         else:
1000             dx_expected = xp_j - xp_j * D1 / D0
1001         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
1002 
1003     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
1004     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
1005     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
1006 
1007     xp[i] = new_y
1008     last_p: uint256 = 0
1009     if new_y > 0:
1010         last_p = self._get_p(xp, amp, D1)
1011 
1012     return [dy, dy_0 - dy, last_p]
1013 
1014 
1015 @view
1016 @external
1017 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
1018     """
1019     @notice Calculate the amount received when withdrawing a single coin
1020     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1021     @param i Index value of the coin to withdraw
1022     @return Amount of coin received
1023     """
1024     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
1025 
1026 
1027 @external
1028 @nonreentrant('lock')
1029 def remove_liquidity_one_coin(
1030     _burn_amount: uint256,
1031     i: int128,
1032     _min_received: uint256,
1033     _receiver: address = msg.sender,
1034 ) -> uint256:
1035     """
1036     @notice Withdraw a single coin from the pool
1037     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1038     @param i Index value of the coin to withdraw
1039     @param _min_received Minimum amount of coin to receive
1040     @param _receiver Address that receives the withdrawn coins
1041     @return Amount of coin received
1042     """
1043     dy: uint256[3] = self._calc_withdraw_one_coin(_burn_amount, i)
1044     assert dy[0] >= _min_received, "Not enough coins removed"
1045 
1046     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
1047     total_supply: uint256 = self.totalSupply - _burn_amount
1048     self.totalSupply = total_supply
1049     self.balanceOf[msg.sender] -= _burn_amount
1050     log Transfer(msg.sender, empty(address), _burn_amount)
1051 
1052     assert ERC20(self.coins[i]).transfer(_receiver, dy[0], default_return_value=True)  # dev: failed transfer
1053     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
1054 
1055     self.save_p_from_price(dy[2])
1056 
1057     return dy[0]
1058 
1059 
1060 @external
1061 def ramp_A(_future_A: uint256, _future_time: uint256):
1062     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1063     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
1064     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
1065 
1066     _initial_A: uint256 = self._A()
1067     _future_A_p: uint256 = _future_A * A_PRECISION
1068 
1069     assert _future_A > 0 and _future_A < MAX_A
1070     if _future_A_p < _initial_A:
1071         assert _future_A_p * MAX_A_CHANGE >= _initial_A
1072     else:
1073         assert _future_A_p <= _initial_A * MAX_A_CHANGE
1074 
1075     self.initial_A = _initial_A
1076     self.future_A = _future_A_p
1077     self.initial_A_time = block.timestamp
1078     self.future_A_time = _future_time
1079 
1080     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
1081 
1082 
1083 @external
1084 def stop_ramp_A():
1085     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1086 
1087     current_A: uint256 = self._A()
1088     self.initial_A = current_A
1089     self.future_A = current_A
1090     self.initial_A_time = block.timestamp
1091     self.future_A_time = block.timestamp
1092     # now (block.timestamp < t1) is always False, so we return saved A
1093 
1094     log StopRampA(current_A, block.timestamp)
1095 
1096 
1097 @external
1098 def set_ma_exp_time(_ma_exp_time: uint256):
1099     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1100     assert _ma_exp_time != 0
1101 
1102     self.ma_exp_time = _ma_exp_time
1103 
1104 
1105 @view
1106 @external
1107 def admin_balances(i: uint256) -> uint256:
1108     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1109 
1110 
1111 @external
1112 def commit_new_fee(_new_fee: uint256):
1113     assert msg.sender == Factory(self.factory).admin()
1114     assert _new_fee <= MAX_FEE
1115     assert self.admin_action_deadline == 0
1116 
1117     self.future_fee = _new_fee
1118     self.admin_action_deadline = block.timestamp + ADMIN_ACTIONS_DEADLINE_DT
1119     log CommitNewFee(_new_fee)
1120 
1121 
1122 @external
1123 def apply_new_fee():
1124     assert msg.sender == Factory(self.factory).admin()
1125     deadline: uint256 = self.admin_action_deadline
1126     assert deadline != 0 and block.timestamp >= deadline
1127 
1128     fee: uint256 = self.future_fee
1129     self.fee = fee
1130     self.admin_action_deadline = 0
1131     log ApplyNewFee(fee)
1132 
1133 
1134 @external
1135 def withdraw_admin_fees():
1136     receiver: address = Factory(self.factory).get_fee_receiver(self)
1137 
1138     for i in range(N_COINS):
1139         coin: address = self.coins[i]
1140         fees: uint256 = ERC20(coin).balanceOf(self) - self.balances[i]
1141         assert ERC20(coin).transfer(receiver, fees, default_return_value=True)
1142 
1143 
1144 @pure
1145 @external
1146 def version() -> String[8]:
1147     """
1148     @notice Get the version of this token contract
1149     """
1150     return VERSION