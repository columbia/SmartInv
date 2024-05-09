1 # @version 0.3.7
2 """
3 @title StableSwap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2023 - all rights reserved
6 @notice 2 coin pool implementation with no lending
7 @dev ERC20 support for return True/revert, return True/False, return None
8      Uses native Ether as coins[0] and can rebase ERC20
9 """
10 
11 from vyper.interfaces import ERC20
12 
13 interface Factory:
14     def convert_fees() -> bool: nonpayable
15     def get_fee_receiver(_pool: address) -> address: view
16     def admin() -> address: view
17 
18 interface ERC1271:
19     def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view
20 
21 
22 event Transfer:
23     sender: indexed(address)
24     receiver: indexed(address)
25     value: uint256
26 
27 event Approval:
28     owner: indexed(address)
29     spender: indexed(address)
30     value: uint256
31 
32 event TokenExchange:
33     buyer: indexed(address)
34     sold_id: int128
35     tokens_sold: uint256
36     bought_id: int128
37     tokens_bought: uint256
38 
39 event AddLiquidity:
40     provider: indexed(address)
41     token_amounts: uint256[N_COINS]
42     fees: uint256[N_COINS]
43     invariant: uint256
44     token_supply: uint256
45 
46 event RemoveLiquidity:
47     provider: indexed(address)
48     token_amounts: uint256[N_COINS]
49     fees: uint256[N_COINS]
50     token_supply: uint256
51 
52 event RemoveLiquidityOne:
53     provider: indexed(address)
54     token_amount: uint256
55     coin_amount: uint256
56     token_supply: uint256
57 
58 event RemoveLiquidityImbalance:
59     provider: indexed(address)
60     token_amounts: uint256[N_COINS]
61     fees: uint256[N_COINS]
62     invariant: uint256
63     token_supply: uint256
64 
65 event RampA:
66     old_A: uint256
67     new_A: uint256
68     initial_time: uint256
69     future_time: uint256
70 
71 event StopRampA:
72     A: uint256
73     t: uint256
74 
75 event CommitNewFee:
76     new_fee: uint256
77 
78 event ApplyNewFee:
79     fee: uint256
80 
81 
82 N_COINS_128: constant(int128) = 2
83 N_COINS: constant(uint256) = 2
84 PRECISION: constant(uint256) = 10 ** 18
85 ADMIN_ACTIONS_DEADLINE_DT: constant(uint256) = 86400 * 3
86 
87 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
88 ADMIN_FEE: constant(uint256) = 5000000000
89 
90 A_PRECISION: constant(uint256) = 100
91 MAX_FEE: constant(uint256) = 5 * 10 ** 9
92 MAX_A: constant(uint256) = 10 ** 6
93 MAX_A_CHANGE: constant(uint256) = 10
94 MIN_RAMP_TIME: constant(uint256) = 86400
95 
96 ETH_ADDR: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
97 
98 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
99 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
100 
101 # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
102 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
103 version: public(constant(String[8])) = "v6.0.1"
104 
105 factory: address
106 
107 coins: public(address[N_COINS])
108 admin_balances: public(uint256[N_COINS])
109 fee: public(uint256)  # fee * 1e10
110 future_fee: public(uint256)
111 admin_action_deadline: public(uint256)
112 
113 initial_A: public(uint256)
114 future_A: public(uint256)
115 initial_A_time: public(uint256)
116 future_A_time: public(uint256)
117 
118 # [bytes4 method_id][bytes8 <empty>][bytes20 oracle]
119 oracle_method: public(uint256)  # Only for one coin which is not ETH
120 originator: address  # Creator of the pool who can set the oracle method
121 
122 RATE_MULTIPLIERS: constant(uint256[2]) = [10**18, 10**18]
123 # shift(2**32 - 1, 224)
124 ORACLE_BIT_MASK: constant(uint256) = (2**32 - 1) * 256**28
125 
126 name: public(String[64])
127 symbol: public(String[32])
128 
129 balanceOf: public(HashMap[address, uint256])
130 allowance: public(HashMap[address, HashMap[address, uint256]])
131 totalSupply: public(uint256)
132 
133 decimals: public(constant(uint256)) = 18
134 
135 DOMAIN_SEPARATOR: public(bytes32)
136 nonces: public(HashMap[address, uint256])
137 
138 last_prices_packed: uint256  #  [last_price, ma_price]
139 ma_exp_time: public(uint256)
140 ma_last_time: public(uint256)
141 
142 
143 @external
144 def __init__():
145     # we do this to prevent the implementation contract from being used as a pool
146     self.factory = 0x0000000000000000000000000000000000000001
147     assert N_COINS == 2
148 
149 
150 @external
151 def initialize(
152     _name: String[32],
153     _symbol: String[10],
154     _coins: address[4],
155     _rate_multipliers: uint256[4],
156     _A: uint256,
157     _fee: uint256,
158 ):
159     """
160     @notice Contract constructor
161     @param _name Name of the new pool
162     @param _symbol Token symbol
163     @param _coins List of all ERC20 conract addresses of coins
164     @param _rate_multipliers List of number of decimals in coins
165     @param _A Amplification coefficient multiplied by n ** (n - 1)
166     @param _fee Fee to charge for exchanges
167     """
168     # check if factory was already set to prevent initializing contract twice
169     assert self.factory == empty(address)
170     # tx.origin will have the ability to set oracles for coins
171     self.originator = tx.origin
172 
173     # additional sanity checks for ETH configuration
174     assert _coins[0] == ETH_ADDR
175     for i in range(N_COINS):
176         assert _rate_multipliers[i] == 10**18
177         self.coins[i] = _coins[i]
178 
179     A: uint256 = _A * A_PRECISION
180     self.initial_A = A
181     self.future_A = A
182     self.fee = _fee
183     self.factory = msg.sender
184 
185     self.ma_exp_time = 866  # = 600 / ln(2)
186     self.last_prices_packed = self.pack_prices(10**18, 10**18)
187     self.ma_last_time = block.timestamp
188 
189     name: String[64] = concat("Curve.fi Factory Pool: ", _name)
190     self.name = name
191     self.symbol = concat(_symbol, "-f")
192 
193     self.DOMAIN_SEPARATOR = keccak256(
194         _abi_encode(EIP712_TYPEHASH, keccak256(name), keccak256(version), chain.id, self)
195     )
196 
197     # fire a transfer event so block explorers identify the contract as an ERC20
198     log Transfer(empty(address), self, 0)
199 
200 
201 ### ERC20 Functionality ###
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
333 @internal
334 def _stored_rates() -> uint256[N_COINS]:
335     assert self.originator == empty(address), "Set oracle"
336     rates: uint256[N_COINS] = RATE_MULTIPLIERS
337 
338     oracle: uint256 = self.oracle_method
339     if oracle != 0:
340         # NOTE: assumed that response is of precision 10**18
341         response: Bytes[32] = raw_call(
342             convert(oracle % 2**160, address),
343             _abi_encode(oracle & ORACLE_BIT_MASK),
344             max_outsize=32,
345             is_static_call=True,
346         )
347         assert len(response) != 0
348         rates[1] = rates[1] * convert(response, uint256) / PRECISION
349 
350     return rates
351 
352 
353 @view
354 @external
355 def stored_rates() -> uint256[N_COINS]:
356     return self._stored_rates()
357 
358 
359 @view
360 @internal
361 def _balances(_value: uint256 = 0) -> uint256[N_COINS]:
362     return [
363         self.balance - self.admin_balances[0] - _value,
364         ERC20(self.coins[1]).balanceOf(self) - self.admin_balances[1]
365     ]
366 
367 
368 @view
369 @external
370 def balances(i: uint256) -> uint256:
371     """
372     @notice Get the current balance of a coin within the
373             pool, less the accrued admin fees
374     @param i Index value for the coin to query balance of
375     @return Token balance
376     """
377     return self._balances()[i]
378 
379 
380 @view
381 @internal
382 def _A() -> uint256:
383     """
384     Handle ramping A up or down
385     """
386     t1: uint256 = self.future_A_time
387     A1: uint256 = self.future_A
388 
389     if block.timestamp < t1:
390         A0: uint256 = self.initial_A
391         t0: uint256 = self.initial_A_time
392         # Expressions in uint256 cannot have negative numbers, thus "if"
393         if A1 > A0:
394             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
395         else:
396             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
397 
398     else:  # when t1 == 0 or block.timestamp >= t1
399         return A1
400 
401 
402 @view
403 @external
404 def admin_fee() -> uint256:
405     return ADMIN_FEE
406 
407 
408 @view
409 @external
410 def A() -> uint256:
411     return self._A() / A_PRECISION
412 
413 
414 @view
415 @external
416 def A_precise() -> uint256:
417     return self._A()
418 
419 
420 @pure
421 @internal
422 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
423     result: uint256[N_COINS] = empty(uint256[N_COINS])
424     for i in range(N_COINS):
425         result[i] = _rates[i] * _balances[i] / PRECISION
426     return result
427 
428 
429 @pure
430 @internal
431 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
432     """
433     D invariant calculation in non-overflowing integer operations
434     iteratively
435 
436     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
437 
438     Converging solution:
439     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
440     """
441     S: uint256 = 0
442     for x in _xp:
443         S += x
444     if S == 0:
445         return 0
446 
447     D: uint256 = S
448     Ann: uint256 = _amp * N_COINS
449     for i in range(255):
450         D_P: uint256 = D * D / _xp[0] * D / _xp[1] / (N_COINS)**2
451         Dprev: uint256 = D
452         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
453         # Equality with the precision of 1
454         if D > Dprev:
455             if D - Dprev <= 1:
456                 return D
457         else:
458             if Dprev - D <= 1:
459                 return D
460     # convergence typically occurs in 4 rounds or less, this should be unreachable!
461     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
462     raise
463 
464 
465 @view
466 @internal
467 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
468     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
469     return self.get_D(xp, _amp)
470 
471 
472 @internal
473 @view
474 def _get_p(xp: uint256[N_COINS], amp: uint256, D: uint256) -> uint256:
475     # dx_0 / dx_1 only, however can have any number of coins in pool
476     ANN: uint256 = amp * N_COINS
477     Dr: uint256 = D / (N_COINS**N_COINS)
478     for i in range(N_COINS):
479         Dr = Dr * D / xp[i]
480     return 10**18 * (ANN * xp[0] / A_PRECISION + Dr * xp[0] / xp[1]) / (ANN * xp[0] / A_PRECISION + Dr)
481 
482 
483 @external
484 @view
485 def get_p() -> uint256:
486     amp: uint256 = self._A()
487     xp: uint256[N_COINS] = self._xp_mem(self._stored_rates(), self._balances())
488     D: uint256 = self.get_D(xp, amp)
489     return self._get_p(xp, amp, D)
490 
491 
492 @internal
493 @view
494 def exp(power: int256) -> uint256:
495     if power <= -42139678854452767551:
496         return 0
497 
498     if power >= 135305999368893231589:
499         raise "exp overflow"
500 
501     x: int256 = unsafe_div(unsafe_mul(power, 2**96), 10**18)
502 
503     k: int256 = unsafe_div(
504         unsafe_add(
505             unsafe_div(unsafe_mul(x, 2**96), 54916777467707473351141471128),
506             2**95),
507         2**96)
508     x = unsafe_sub(x, unsafe_mul(k, 54916777467707473351141471128))
509 
510     y: int256 = unsafe_add(x, 1346386616545796478920950773328)
511     y = unsafe_add(unsafe_div(unsafe_mul(y, x), 2**96), 57155421227552351082224309758442)
512     p: int256 = unsafe_sub(unsafe_add(y, x), 94201549194550492254356042504812)
513     p = unsafe_add(unsafe_div(unsafe_mul(p, y), 2**96), 28719021644029726153956944680412240)
514     p = unsafe_add(unsafe_mul(p, x), (4385272521454847904659076985693276 * 2**96))
515 
516     q: int256 = x - 2855989394907223263936484059900
517     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 50020603652535783019961831881945)
518     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 533845033583426703283633433725380)
519     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 3604857256930695427073651918091429)
520     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 14423608567350463180887372962807573)
521     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 26449188498355588339934803723976023)
522 
523     return shift(
524         unsafe_mul(convert(unsafe_div(p, q), uint256), 3822833074963236453042738258902158003155416615667),
525         unsafe_sub(k, 195))
526 
527 
528 @internal
529 @view
530 def _ma_price() -> uint256:
531     ma_last_time: uint256 = self.ma_last_time
532 
533     pp: uint256 = self.last_prices_packed
534     last_price: uint256 = min(pp & (2**128 - 1), 2 * 10**18)  # Limit the price going into EMA to not be more than 2.0
535     last_ema_price: uint256 = shift(pp, -128)
536 
537     if ma_last_time < block.timestamp:
538         alpha: uint256 = self.exp(- convert((block.timestamp - ma_last_time) * 10**18 / self.ma_exp_time, int256))
539         return (last_price * (10**18 - alpha) + last_ema_price * alpha) / 10**18
540 
541     else:
542         return last_ema_price
543 
544 
545 @external
546 @view
547 @nonreentrant('lock')
548 def price_oracle() -> uint256:
549     """
550     @notice EMA price oracle based on the last state prices
551             Prices are taken after rate multiplier is applied (if it is set)
552     """
553     return self._ma_price()
554 
555 
556 @internal
557 def save_p_from_price(last_price: uint256):
558     """
559     Saves current price and its EMA
560     """
561     if last_price != 0:
562         self.last_prices_packed = self.pack_prices(last_price, self._ma_price())
563         if self.ma_last_time < block.timestamp:
564             self.ma_last_time = block.timestamp
565 
566 
567 @internal
568 def save_p(xp: uint256[N_COINS], amp: uint256, D: uint256):
569     """
570     Saves current price and its EMA
571     """
572     self.save_p_from_price(self._get_p(xp, amp, D))
573 
574 
575 @view
576 @external
577 @nonreentrant('lock')
578 def get_virtual_price() -> uint256:
579     """
580     @notice The current virtual price of the pool LP token
581     @dev Useful for calculating profits
582     @return LP token virtual price normalized to 1e18
583     """
584     amp: uint256 = self._A()
585     xp: uint256[N_COINS] = self._xp_mem(self._stored_rates(), self._balances())
586     D: uint256 = self.get_D(xp, amp)
587     # D is in the units similar to DAI (e.g. converted to precision 1e18)
588     # When balanced, D = n * x_u - total virtual value of the portfolio
589     return D * PRECISION / self.totalSupply
590 
591 
592 @view
593 @external
594 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
595     """
596     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
597     @dev This calculation accounts for slippage, but not fees.
598          Needed to prevent front-running, not for precise calculations!
599     @param _amounts Amount of each coin being deposited
600     @param _is_deposit set True for deposits, False for withdrawals
601     @return Expected amount of LP tokens received
602     """
603     amp: uint256 = self._A()
604     balances: uint256[N_COINS] = self._balances()
605     rates: uint256[N_COINS] = self._stored_rates()
606 
607     D0: uint256 = self.get_D_mem(rates, balances, amp)
608     for i in range(N_COINS):
609         amount: uint256 = _amounts[i]
610         if _is_deposit:
611             balances[i] += amount
612         else:
613             balances[i] -= amount
614     D1: uint256 = self.get_D_mem(rates, balances, amp)
615     diff: uint256 = 0
616     if _is_deposit:
617         diff = D1 - D0
618     else:
619         diff = D0 - D1
620     return diff * self.totalSupply / D0
621 
622 
623 @payable
624 @external
625 @nonreentrant('lock')
626 def add_liquidity(
627     _amounts: uint256[N_COINS],
628     _min_mint_amount: uint256,
629     _receiver: address = msg.sender
630 ) -> uint256:
631     """
632     @notice Deposit coins into the pool
633     @param _amounts List of amounts of coins to deposit
634     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
635     @param _receiver Address that owns the minted LP tokens
636     @return Amount of LP tokens received by depositing
637     """
638     amp: uint256 = self._A()
639     old_balances: uint256[N_COINS] = self._balances(msg.value)
640     rates: uint256[N_COINS] = self._stored_rates()
641 
642     # Initial invariant
643     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
644 
645     total_supply: uint256 = self.totalSupply
646     new_balances: uint256[N_COINS] = old_balances
647     for i in range(N_COINS):
648         amount: uint256 = _amounts[i]
649         if total_supply == 0:
650             assert amount > 0  # dev: initial deposit requires all coins
651         new_balances[i] += amount
652 
653     # Invariant after change
654     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
655     assert D1 > D0
656 
657     # We need to recalculate the invariant accounting for fees
658     # to calculate fair user's share
659     fees: uint256[N_COINS] = empty(uint256[N_COINS])
660     mint_amount: uint256 = 0
661     if total_supply > 0:
662         # Only account for fees if we are not the first to deposit
663         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
664         for i in range(N_COINS):
665             ideal_balance: uint256 = D1 * old_balances[i] / D0
666             difference: uint256 = 0
667             new_balance: uint256 = new_balances[i]
668             if ideal_balance > new_balance:
669                 difference = ideal_balance - new_balance
670             else:
671                 difference = new_balance - ideal_balance
672             fees[i] = base_fee * difference / FEE_DENOMINATOR
673             self.admin_balances[i] += fees[i] * ADMIN_FEE / FEE_DENOMINATOR
674             new_balances[i] -= fees[i]
675         xp: uint256[N_COINS] = self._xp_mem(rates, new_balances)
676         D2: uint256 = self.get_D(xp, amp)
677         mint_amount = total_supply * (D2 - D0) / D0
678         self.save_p(xp, amp, D2)
679     else:
680         mint_amount = D1  # Take the dust if there was any
681 
682     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
683 
684     # Take coins from the sender
685     assert msg.value == _amounts[0]
686     if _amounts[1] > 0:
687         assert ERC20(self.coins[1]).transferFrom(msg.sender, self, _amounts[1], default_return_value=True)  # dev: failed transfer
688 
689     # Mint pool tokens
690     total_supply += mint_amount
691     self.balanceOf[_receiver] += mint_amount
692     self.totalSupply = total_supply
693     log Transfer(empty(address), _receiver, mint_amount)
694 
695     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
696 
697     return mint_amount
698 
699 
700 @view
701 @internal
702 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS], _amp: uint256, _D: uint256) -> uint256:
703     """
704     Calculate x[j] if one makes x[i] = x
705 
706     Done by solving quadratic equation iteratively.
707     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
708     x_1**2 + b*x_1 = c
709 
710     x_1 = (x_1**2 + c) / (2*x_1 + b)
711     """
712     # x in the input is converted to the same price/precision
713 
714     assert i != j       # dev: same coin
715     assert j >= 0       # dev: j below zero
716     assert j < N_COINS_128  # dev: j above N_COINS
717 
718     # should be unreachable, but good for safety
719     assert i >= 0
720     assert i < N_COINS_128
721 
722     amp: uint256 = _amp
723     D: uint256 = _D
724     if _D == 0:
725         amp = self._A()
726         D = self.get_D(xp, amp)
727     S_: uint256 = 0
728     _x: uint256 = 0
729     y_prev: uint256 = 0
730     c: uint256 = D
731     Ann: uint256 = amp * N_COINS
732 
733     for _i in range(N_COINS_128):
734         if _i == i:
735             _x = x
736         elif _i != j:
737             _x = xp[_i]
738         else:
739             continue
740         S_ += _x
741         c = c * D / (_x * N_COINS)
742 
743     c = c * D * A_PRECISION / (Ann * N_COINS)
744     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
745     y: uint256 = D
746 
747     for _i in range(255):
748         y_prev = y
749         y = (y*y + c) / (2 * y + b - D)
750         # Equality with the precision of 1
751         if y > y_prev:
752             if y - y_prev <= 1:
753                 return y
754         else:
755             if y_prev - y <= 1:
756                 return y
757     raise
758 
759 
760 @view
761 @external
762 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
763     """
764     @notice Calculate the current output dy given input dx
765     @dev Index values can be found via the `coins` public getter method
766     @param i Index value for the coin to send
767     @param j Index value of the coin to recieve
768     @param dx Amount of `i` being exchanged
769     @return Amount of `j` predicted
770     """
771     rates: uint256[N_COINS] = self._stored_rates()
772     xp: uint256[N_COINS] = self._xp_mem(rates, self._balances())
773 
774     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
775     y: uint256 = self.get_y(i, j, x, xp, 0, 0)
776     dy: uint256 = xp[j] - y - 1
777     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
778     return (dy - fee) * PRECISION / rates[j]
779 
780 
781 @payable
782 @external
783 @nonreentrant('lock')
784 def exchange(
785     i: int128,
786     j: int128,
787     _dx: uint256,
788     _min_dy: uint256,
789     _receiver: address = msg.sender,
790 ) -> uint256:
791     """
792     @notice Perform an exchange between two coins
793     @dev Index values can be found via the `coins` public getter method
794     @param i Index value for the coin to send
795     @param j Index valie of the coin to recieve
796     @param _dx Amount of `i` being exchanged
797     @param _min_dy Minimum amount of `j` to receive
798     @return Actual amount of `j` received
799     """
800     rates: uint256[N_COINS] = self._stored_rates()
801     old_balances: uint256[N_COINS] = self._balances(msg.value)
802     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
803 
804     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
805 
806     amp: uint256 = self._A()
807     D: uint256 = self.get_D(xp, amp)
808     y: uint256 = self.get_y(i, j, x, xp, amp, D)
809 
810     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
811     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
812 
813     # Convert all to real units
814     dy = (dy - dy_fee) * PRECISION / rates[j]
815     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
816 
817     # xp is not used anymore, so we reuse it for price calc
818     xp[i] = x
819     xp[j] = y
820     # D is not changed because we did not apply a fee
821     self.save_p(xp, amp, D)
822 
823     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR * PRECISION / rates[j]
824     if dy_admin_fee != 0:
825         self.admin_balances[j] += dy_admin_fee
826 
827     coin: address = self.coins[1]
828     if i == 0:
829         assert msg.value == _dx
830         assert ERC20(coin).transfer(_receiver, dy, default_return_value=True)
831     else:
832         assert msg.value == 0
833         assert ERC20(coin).transferFrom(msg.sender, self, _dx, default_return_value=True)
834         raw_call(_receiver, b"", value=dy)
835 
836     log TokenExchange(msg.sender, i, _dx, j, dy)
837 
838     return dy
839 
840 
841 @external
842 @nonreentrant('lock')
843 def remove_liquidity(
844     _burn_amount: uint256,
845     _min_amounts: uint256[N_COINS],
846     _receiver: address = msg.sender
847 ) -> uint256[N_COINS]:
848     """
849     @notice Withdraw coins from the pool
850     @dev Withdrawal amounts are based on current deposit ratios
851     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
852     @param _min_amounts Minimum amounts of underlying coins to receive
853     @param _receiver Address that receives the withdrawn coins
854     @return List of amounts of coins that were withdrawn
855     """
856     total_supply: uint256 = self.totalSupply
857     amounts: uint256[N_COINS] = self._balances()
858 
859     for i in range(N_COINS):
860         value: uint256 = amounts[i] * _burn_amount / total_supply
861         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
862         amounts[i] = value
863 
864         if i == 0:
865             raw_call(_receiver, b"", value=value)
866         else:
867             assert ERC20(self.coins[1]).transfer(_receiver, value, default_return_value=True)
868 
869     total_supply -= _burn_amount
870     self.balanceOf[msg.sender] -= _burn_amount
871     self.totalSupply = total_supply
872     log Transfer(msg.sender, empty(address), _burn_amount)
873 
874     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
875 
876     return amounts
877 
878 
879 @external
880 @nonreentrant('lock')
881 def remove_liquidity_imbalance(
882     _amounts: uint256[N_COINS],
883     _max_burn_amount: uint256,
884     _receiver: address = msg.sender
885 ) -> uint256:
886     """
887     @notice Withdraw coins from the pool in an imbalanced amount
888     @param _amounts List of amounts of underlying coins to withdraw
889     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
890     @param _receiver Address that receives the withdrawn coins
891     @return Actual amount of the LP token burned in the withdrawal
892     """
893     amp: uint256 = self._A()
894     rates: uint256[N_COINS] = self._stored_rates()
895     old_balances: uint256[N_COINS] = self._balances()
896     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
897 
898     new_balances: uint256[N_COINS] = old_balances
899     for i in range(N_COINS):
900         new_balances[i] -= _amounts[i]
901     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
902 
903     fees: uint256[N_COINS] = empty(uint256[N_COINS])
904     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
905     for i in range(N_COINS):
906         ideal_balance: uint256 = D1 * old_balances[i] / D0
907         difference: uint256 = 0
908         new_balance: uint256 = new_balances[i]
909         if ideal_balance > new_balance:
910             difference = ideal_balance - new_balance
911         else:
912             difference = new_balance - ideal_balance
913         fees[i] = base_fee * difference / FEE_DENOMINATOR
914         self.admin_balances[i] += fees[i] * ADMIN_FEE / FEE_DENOMINATOR
915         new_balances[i] -= fees[i]
916     new_balances = self._xp_mem(rates, new_balances)
917     D2: uint256 = self.get_D(new_balances, amp)
918 
919     self.save_p(new_balances, amp, D2)
920 
921     total_supply: uint256 = self.totalSupply
922     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
923     assert burn_amount > 1  # dev: zero tokens burned
924     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
925 
926     total_supply -= burn_amount
927     self.totalSupply = total_supply
928     self.balanceOf[msg.sender] -= burn_amount
929     log Transfer(msg.sender, empty(address), burn_amount)
930 
931     if _amounts[0] != 0:
932         raw_call(_receiver, b"", value=_amounts[0])
933     if _amounts[1] != 0:
934         assert ERC20(self.coins[1]).transfer(_receiver, _amounts[1], default_return_value=True)
935 
936     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
937 
938     return burn_amount
939 
940 
941 @pure
942 @internal
943 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
944     """
945     Calculate x[i] if one reduces D from being calculated for xp to D
946 
947     Done by solving quadratic equation iteratively.
948     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
949     x_1**2 + b*x_1 = c
950 
951     x_1 = (x_1**2 + c) / (2*x_1 + b)
952     """
953     # x in the input is converted to the same price/precision
954 
955     assert i >= 0  # dev: i below zero
956     assert i < N_COINS_128  # dev: i above N_COINS
957 
958     S_: uint256 = 0
959     _x: uint256 = 0
960     y_prev: uint256 = 0
961     c: uint256 = D
962     Ann: uint256 = A * N_COINS
963 
964     for _i in range(N_COINS_128):
965         if _i != i:
966             _x = xp[_i]
967         else:
968             continue
969         S_ += _x
970         c = c * D / (_x * N_COINS)
971 
972     c = c * D * A_PRECISION / (Ann * N_COINS)
973     b: uint256 = S_ + D * A_PRECISION / Ann
974     y: uint256 = D
975 
976     for _i in range(255):
977         y_prev = y
978         y = (y*y + c) / (2 * y + b - D)
979         # Equality with the precision of 1
980         if y > y_prev:
981             if y - y_prev <= 1:
982                 return y
983         else:
984             if y_prev - y <= 1:
985                 return y
986     raise
987 
988 
989 @view
990 @internal
991 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[3]:
992     # First, need to calculate
993     # * Get current D
994     # * Solve Eqn against y_i for D - _token_amount
995     amp: uint256 = self._A()
996     rates: uint256[N_COINS] = self._stored_rates()
997     xp: uint256[N_COINS] = self._xp_mem(rates, self._balances())
998     D0: uint256 = self.get_D(xp, amp)
999 
1000     total_supply: uint256 = self.totalSupply
1001     D1: uint256 = D0 - _burn_amount * D0 / total_supply
1002     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
1003 
1004     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
1005     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
1006 
1007     for j in range(N_COINS_128):
1008         dx_expected: uint256 = 0
1009         xp_j: uint256 = xp[j]
1010         if j == i:
1011             dx_expected = xp_j * D1 / D0 - new_y
1012         else:
1013             dx_expected = xp_j - xp_j * D1 / D0
1014         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
1015 
1016     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
1017     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
1018     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
1019 
1020     xp[i] = new_y
1021     last_p: uint256 = 0
1022     if new_y > 0:
1023         last_p = self._get_p(xp, amp, D1)
1024 
1025     return [dy, dy_0 - dy, last_p]
1026 
1027 
1028 @view
1029 @external
1030 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
1031     """
1032     @notice Calculate the amount received when withdrawing a single coin
1033     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1034     @param i Index value of the coin to withdraw
1035     @return Amount of coin received
1036     """
1037     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
1038 
1039 
1040 @external
1041 @nonreentrant('lock')
1042 def remove_liquidity_one_coin(
1043     _burn_amount: uint256,
1044     i: int128,
1045     _min_received: uint256,
1046     _receiver: address = msg.sender,
1047 ) -> uint256:
1048     """
1049     @notice Withdraw a single coin from the pool
1050     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1051     @param i Index value of the coin to withdraw
1052     @param _min_received Minimum amount of coin to receive
1053     @param _receiver Address that receives the withdrawn coins
1054     @return Amount of coin received
1055     """
1056     dy: uint256[3] = self._calc_withdraw_one_coin(_burn_amount, i)
1057     assert dy[0] >= _min_received, "Not enough coins removed"
1058 
1059     self.admin_balances[i] += dy[1] * ADMIN_FEE / FEE_DENOMINATOR
1060 
1061     total_supply: uint256 = self.totalSupply - _burn_amount
1062     self.totalSupply = total_supply
1063     self.balanceOf[msg.sender] -= _burn_amount
1064     log Transfer(msg.sender, empty(address), _burn_amount)
1065 
1066     if i == 0:
1067         raw_call(_receiver, b"", value=dy[0])
1068     else:
1069         assert ERC20(self.coins[1]).transfer(_receiver, dy[0], default_return_value=True)
1070 
1071     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
1072 
1073     self.save_p_from_price(dy[2])
1074 
1075     return dy[0]
1076 
1077 
1078 @external
1079 def ramp_A(_future_A: uint256, _future_time: uint256):
1080     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1081     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
1082     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
1083 
1084     _initial_A: uint256 = self._A()
1085     _future_A_p: uint256 = _future_A * A_PRECISION
1086 
1087     assert _future_A > 0 and _future_A < MAX_A
1088     if _future_A_p < _initial_A:
1089         assert _future_A_p * MAX_A_CHANGE >= _initial_A
1090     else:
1091         assert _future_A_p <= _initial_A * MAX_A_CHANGE
1092 
1093     self.initial_A = _initial_A
1094     self.future_A = _future_A_p
1095     self.initial_A_time = block.timestamp
1096     self.future_A_time = _future_time
1097 
1098     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
1099 
1100 
1101 @external
1102 def stop_ramp_A():
1103     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1104 
1105     current_A: uint256 = self._A()
1106     self.initial_A = current_A
1107     self.future_A = current_A
1108     self.initial_A_time = block.timestamp
1109     self.future_A_time = block.timestamp
1110     # now (block.timestamp < t1) is always False, so we return saved A
1111 
1112     log StopRampA(current_A, block.timestamp)
1113 
1114 
1115 @external
1116 def withdraw_admin_fees():
1117     receiver: address = Factory(self.factory).get_fee_receiver(self)
1118 
1119     amount: uint256 = self.admin_balances[0]
1120     if amount != 0:
1121         raw_call(receiver, b"", value=amount)
1122 
1123     amount = self.admin_balances[1]
1124     if amount != 0:
1125         assert ERC20(self.coins[1]).transfer(receiver, amount, default_return_value=True)
1126 
1127     self.admin_balances = empty(uint256[N_COINS])
1128 
1129 
1130 @external
1131 def commit_new_fee(_new_fee: uint256):
1132     assert msg.sender == Factory(self.factory).admin()
1133     assert _new_fee <= MAX_FEE
1134     assert self.admin_action_deadline == 0
1135 
1136     self.future_fee = _new_fee
1137     self.admin_action_deadline = block.timestamp + ADMIN_ACTIONS_DEADLINE_DT
1138     log CommitNewFee(_new_fee)
1139 
1140 
1141 @external
1142 def apply_new_fee():
1143     assert msg.sender == Factory(self.factory).admin()
1144     deadline: uint256 = self.admin_action_deadline
1145     assert deadline != 0 and block.timestamp >= deadline
1146 
1147     fee: uint256 = self.future_fee
1148     self.fee = fee
1149     self.admin_action_deadline = 0
1150     log ApplyNewFee(fee)
1151 
1152 
1153 @external
1154 def set_ma_exp_time(_ma_exp_time: uint256):
1155     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1156     assert _ma_exp_time != 0
1157 
1158     self.ma_exp_time = _ma_exp_time
1159 
1160 
1161 @external
1162 def set_oracle(_method_id: bytes4, _oracle: address):
1163     """
1164     @notice Set the oracles used for calculating rates
1165     @dev if any value is empty, rate will fallback to value provided on initialize, one time use.
1166         The precision of the rate returned by the oracle MUST be 18.
1167     @param _method_id method_id needed to call on `_oracle` to fetch rate
1168     @param _oracle oracle address
1169     """
1170     assert msg.sender == self.originator
1171 
1172     self.oracle_method = convert(_method_id, uint256) * 2**224 | convert(_oracle, uint256)
1173     self.originator = empty(address)