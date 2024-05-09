1 # @version 0.3.7
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
96 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
97 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
98 
99 # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
100 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
101 VERSION: constant(String[8]) = "v6.0.0"
102 
103 
104 factory: address
105 
106 coins: public(address[N_COINS])
107 balances: public(uint256[N_COINS])
108 fee: public(uint256)  # fee * 1e10
109 future_fee: public(uint256)
110 admin_action_deadline: public(uint256)
111 
112 initial_A: public(uint256)
113 future_A: public(uint256)
114 initial_A_time: public(uint256)
115 future_A_time: public(uint256)
116 
117 rate_multipliers: uint256[N_COINS]
118 
119 name: public(String[64])
120 symbol: public(String[32])
121 
122 balanceOf: public(HashMap[address, uint256])
123 allowance: public(HashMap[address, HashMap[address, uint256]])
124 totalSupply: public(uint256)
125 
126 DOMAIN_SEPARATOR: public(bytes32)
127 nonces: public(HashMap[address, uint256])
128 
129 last_prices_packed: uint256  #  [last_price, ma_price]
130 ma_exp_time: public(uint256)
131 ma_last_time: public(uint256)
132 
133 
134 @external
135 def __init__():
136     # we do this to prevent the implementation contract from being used as a pool
137     self.factory = 0x0000000000000000000000000000000000000001
138     assert N_COINS == 2
139 
140 
141 @external
142 def initialize(
143     _name: String[32],
144     _symbol: String[10],
145     _coins: address[4],
146     _rate_multipliers: uint256[4],
147     _A: uint256,
148     _fee: uint256,
149 ):
150     """
151     @notice Contract constructor
152     @param _name Name of the new pool
153     @param _symbol Token symbol
154     @param _coins List of all ERC20 conract addresses of coins
155     @param _rate_multipliers List of number of decimals in coins
156     @param _A Amplification coefficient multiplied by n ** (n - 1)
157     @param _fee Fee to charge for exchanges
158     """
159     # check if factory was already set to prevent initializing contract twice
160     assert self.factory == empty(address)
161 
162     # additional sanity checks for ETH configuration
163     assert _coins[0] == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
164     assert _rate_multipliers[0] == 10**18
165 
166     for i in range(N_COINS):
167         coin: address = _coins[i]
168         if coin == empty(address):
169             break
170         self.coins[i] = coin
171         self.rate_multipliers[i] = _rate_multipliers[i]
172 
173     A: uint256 = _A * A_PRECISION
174     self.initial_A = A
175     self.future_A = A
176     self.fee = _fee
177     self.factory = msg.sender
178 
179     self.ma_exp_time = 866  # = 600 / ln(2)
180     self.last_prices_packed = self.pack_prices(10**18, 10**18)
181     self.ma_last_time = block.timestamp
182 
183     name: String[64] = concat("Curve.fi Factory Pool: ", _name)
184     self.name = name
185     self.symbol = concat(_symbol, "-f")
186 
187     self.DOMAIN_SEPARATOR = keccak256(
188         _abi_encode(EIP712_TYPEHASH, keccak256(name), keccak256(VERSION), chain.id, self)
189     )
190 
191     # fire a transfer event so block explorers identify the contract as an ERC20
192     log Transfer(empty(address), self, 0)
193 
194 
195 ### ERC20 Functionality ###
196 
197 @view
198 @external
199 def decimals() -> uint256:
200     """
201     @notice Get the number of decimals for this token
202     @dev Implemented as a view method to reduce gas costs
203     @return uint256 decimal places
204     """
205     return 18
206 
207 
208 @internal
209 def _transfer(_from: address, _to: address, _value: uint256):
210     # # NOTE: vyper does not allow underflows
211     # #       so the following subtraction would revert on insufficient balance
212     self.balanceOf[_from] -= _value
213     self.balanceOf[_to] += _value
214 
215     log Transfer(_from, _to, _value)
216 
217 
218 @external
219 def transfer(_to : address, _value : uint256) -> bool:
220     """
221     @dev Transfer token for a specified address
222     @param _to The address to transfer to.
223     @param _value The amount to be transferred.
224     """
225     self._transfer(msg.sender, _to, _value)
226     return True
227 
228 
229 @external
230 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
231     """
232      @dev Transfer tokens from one address to another.
233      @param _from address The address which you want to send tokens from
234      @param _to address The address which you want to transfer to
235      @param _value uint256 the amount of tokens to be transferred
236     """
237     self._transfer(_from, _to, _value)
238 
239     _allowance: uint256 = self.allowance[_from][msg.sender]
240     if _allowance != max_value(uint256):
241         self.allowance[_from][msg.sender] = _allowance - _value
242 
243     return True
244 
245 
246 @external
247 def approve(_spender : address, _value : uint256) -> bool:
248     """
249     @notice Approve the passed address to transfer the specified amount of
250             tokens on behalf of msg.sender
251     @dev Beware that changing an allowance via this method brings the risk that
252          someone may use both the old and new allowance by unfortunate transaction
253          ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254     @param _spender The address which will transfer the funds
255     @param _value The amount of tokens that may be transferred
256     @return bool success
257     """
258     self.allowance[msg.sender][_spender] = _value
259 
260     log Approval(msg.sender, _spender, _value)
261     return True
262 
263 
264 @external
265 def permit(
266     _owner: address,
267     _spender: address,
268     _value: uint256,
269     _deadline: uint256,
270     _v: uint8,
271     _r: bytes32,
272     _s: bytes32
273 ) -> bool:
274     """
275     @notice Approves spender by owner's signature to expend owner's tokens.
276         See https://eips.ethereum.org/EIPS/eip-2612.
277     @dev Inspired by https://github.com/yearn/yearn-vaults/blob/main/contracts/Vault.vy#L753-L793
278     @dev Supports smart contract wallets which implement ERC1271
279         https://eips.ethereum.org/EIPS/eip-1271
280     @param _owner The address which is a source of funds and has signed the Permit.
281     @param _spender The address which is allowed to spend the funds.
282     @param _value The amount of tokens to be spent.
283     @param _deadline The timestamp after which the Permit is no longer valid.
284     @param _v The bytes[64] of the valid secp256k1 signature of permit by owner
285     @param _r The bytes[0:32] of the valid secp256k1 signature of permit by owner
286     @param _s The bytes[32:64] of the valid secp256k1 signature of permit by owner
287     @return True, if transaction completes successfully
288     """
289     assert _owner != empty(address)
290     assert block.timestamp <= _deadline
291 
292     nonce: uint256 = self.nonces[_owner]
293     digest: bytes32 = keccak256(
294         concat(
295             b"\x19\x01",
296             self.DOMAIN_SEPARATOR,
297             keccak256(_abi_encode(PERMIT_TYPEHASH, _owner, _spender, _value, nonce, _deadline))
298         )
299     )
300 
301     if _owner.is_contract:
302         sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
303         # reentrancy not a concern since this is a staticcall
304         assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
305     else:
306         assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
307 
308     self.allowance[_owner][_spender] = _value
309     self.nonces[_owner] = nonce + 1
310 
311     log Approval(_owner, _spender, _value)
312     return True
313 
314 
315 ### StableSwap Functionality ###
316 
317 
318 @pure
319 @internal
320 def pack_prices(p1: uint256, p2: uint256) -> uint256:
321     assert p1 < 2**128
322     assert p2 < 2**128
323     return p1 | shift(p2, 128)
324 
325 
326 @view
327 @external
328 def last_price() -> uint256:
329     return self.last_prices_packed & (2**128 - 1)
330 
331 
332 @view
333 @external
334 def ema_price() -> uint256:
335     return shift(self.last_prices_packed, -128)
336 
337 
338 @view
339 @external
340 def get_balances() -> uint256[N_COINS]:
341     return self.balances
342 
343 
344 @view
345 @internal
346 def _A() -> uint256:
347     """
348     Handle ramping A up or down
349     """
350     t1: uint256 = self.future_A_time
351     A1: uint256 = self.future_A
352 
353     if block.timestamp < t1:
354         A0: uint256 = self.initial_A
355         t0: uint256 = self.initial_A_time
356         # Expressions in uint256 cannot have negative numbers, thus "if"
357         if A1 > A0:
358             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
359         else:
360             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
361 
362     else:  # when t1 == 0 or block.timestamp >= t1
363         return A1
364 
365 
366 @view
367 @external
368 def admin_fee() -> uint256:
369     return ADMIN_FEE
370 
371 
372 @view
373 @external
374 def A() -> uint256:
375     return self._A() / A_PRECISION
376 
377 
378 @view
379 @external
380 def A_precise() -> uint256:
381     return self._A()
382 
383 
384 @pure
385 @internal
386 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
387     result: uint256[N_COINS] = empty(uint256[N_COINS])
388     for i in range(N_COINS):
389         result[i] = _rates[i] * _balances[i] / PRECISION
390     return result
391 
392 
393 @pure
394 @internal
395 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
396     """
397     D invariant calculation in non-overflowing integer operations
398     iteratively
399 
400     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
401 
402     Converging solution:
403     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
404     """
405     S: uint256 = 0
406     for x in _xp:
407         S += x
408     if S == 0:
409         return 0
410 
411     D: uint256 = S
412     Ann: uint256 = _amp * N_COINS
413     for i in range(255):
414         D_P: uint256 = D * D / _xp[0] * D / _xp[1] / (N_COINS)**2
415         Dprev: uint256 = D
416         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
417         # Equality with the precision of 1
418         if D > Dprev:
419             if D - Dprev <= 1:
420                 return D
421         else:
422             if Dprev - D <= 1:
423                 return D
424     # convergence typically occurs in 4 rounds or less, this should be unreachable!
425     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
426     raise
427 
428 
429 @view
430 @internal
431 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
432     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
433     return self.get_D(xp, _amp)
434 
435 
436 @internal
437 @view
438 def _get_p(xp: uint256[N_COINS], amp: uint256, D: uint256) -> uint256:
439     # dx_0 / dx_1 only, however can have any number of coins in pool
440     ANN: uint256 = amp * N_COINS
441     Dr: uint256 = D / (N_COINS**N_COINS)
442     for i in range(N_COINS):
443         Dr = Dr * D / xp[i]
444     return 10**18 * (ANN * xp[0] / A_PRECISION + Dr * xp[0] / xp[1]) / (ANN * xp[0] / A_PRECISION + Dr)
445 
446 
447 @external
448 @view
449 def get_p() -> uint256:
450     amp: uint256 = self._A()
451     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, self.balances)
452     D: uint256 = self.get_D(xp, amp)
453     return self._get_p(xp, amp, D)
454 
455 
456 @internal
457 @view
458 def exp(power: int256) -> uint256:
459     if power <= -42139678854452767551:
460         return 0
461 
462     if power >= 135305999368893231589:
463         raise "exp overflow"
464 
465     x: int256 = unsafe_div(unsafe_mul(power, 2**96), 10**18)
466 
467     k: int256 = unsafe_div(
468         unsafe_add(
469             unsafe_div(unsafe_mul(x, 2**96), 54916777467707473351141471128),
470             2**95),
471         2**96)
472     x = unsafe_sub(x, unsafe_mul(k, 54916777467707473351141471128))
473 
474     y: int256 = unsafe_add(x, 1346386616545796478920950773328)
475     y = unsafe_add(unsafe_div(unsafe_mul(y, x), 2**96), 57155421227552351082224309758442)
476     p: int256 = unsafe_sub(unsafe_add(y, x), 94201549194550492254356042504812)
477     p = unsafe_add(unsafe_div(unsafe_mul(p, y), 2**96), 28719021644029726153956944680412240)
478     p = unsafe_add(unsafe_mul(p, x), (4385272521454847904659076985693276 * 2**96))
479 
480     q: int256 = x - 2855989394907223263936484059900
481     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 50020603652535783019961831881945)
482     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 533845033583426703283633433725380)
483     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 3604857256930695427073651918091429)
484     q = unsafe_sub(unsafe_div(unsafe_mul(q, x), 2**96), 14423608567350463180887372962807573)
485     q = unsafe_add(unsafe_div(unsafe_mul(q, x), 2**96), 26449188498355588339934803723976023)
486 
487     return shift(
488         unsafe_mul(convert(unsafe_div(p, q), uint256), 3822833074963236453042738258902158003155416615667),
489         unsafe_sub(k, 195))
490 
491 
492 @internal
493 @view
494 def _ma_price() -> uint256:
495     ma_last_time: uint256 = self.ma_last_time
496 
497     pp: uint256 = self.last_prices_packed
498     last_price: uint256 = pp & (2**128 - 1)
499     last_ema_price: uint256 = shift(pp, -128)
500 
501     if ma_last_time < block.timestamp:
502         alpha: uint256 = self.exp(- convert((block.timestamp - ma_last_time) * 10**18 / self.ma_exp_time, int256))
503         return (last_price * (10**18 - alpha) + last_ema_price * alpha) / 10**18
504 
505     else:
506         return last_ema_price
507 
508 
509 @external
510 @view
511 @nonreentrant('lock')
512 def price_oracle() -> uint256:
513     return self._ma_price()
514 
515 
516 @internal
517 def save_p_from_price(last_price: uint256):
518     """
519     Saves current price and its EMA
520     """
521     if last_price != 0:
522         self.last_prices_packed = self.pack_prices(last_price, self._ma_price())
523         if self.ma_last_time < block.timestamp:
524             self.ma_last_time = block.timestamp
525 
526 
527 @internal
528 def save_p(xp: uint256[N_COINS], amp: uint256, D: uint256):
529     """
530     Saves current price and its EMA
531     """
532     self.save_p_from_price(self._get_p(xp, amp, D))
533 
534 
535 @view
536 @external
537 @nonreentrant('lock')
538 def get_virtual_price() -> uint256:
539     """
540     @notice The current virtual price of the pool LP token
541     @dev Useful for calculating profits
542     @return LP token virtual price normalized to 1e18
543     """
544     amp: uint256 = self._A()
545     xp: uint256[N_COINS] = self._xp_mem(self.rate_multipliers, self.balances)
546     D: uint256 = self.get_D(xp, amp)
547     # D is in the units similar to DAI (e.g. converted to precision 1e18)
548     # When balanced, D = n * x_u - total virtual value of the portfolio
549     return D * PRECISION / self.totalSupply
550 
551 
552 @view
553 @external
554 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
555     """
556     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
557     @dev This calculation accounts for slippage, but not fees.
558          Needed to prevent front-running, not for precise calculations!
559     @param _amounts Amount of each coin being deposited
560     @param _is_deposit set True for deposits, False for withdrawals
561     @return Expected amount of LP tokens received
562     """
563     amp: uint256 = self._A()
564     balances: uint256[N_COINS] = self.balances
565 
566     D0: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
567     for i in range(N_COINS):
568         amount: uint256 = _amounts[i]
569         if _is_deposit:
570             balances[i] += amount
571         else:
572             balances[i] -= amount
573     D1: uint256 = self.get_D_mem(self.rate_multipliers, balances, amp)
574     diff: uint256 = 0
575     if _is_deposit:
576         diff = D1 - D0
577     else:
578         diff = D0 - D1
579     return diff * self.totalSupply / D0
580 
581 
582 @payable
583 @external
584 @nonreentrant('lock')
585 def add_liquidity(
586     _amounts: uint256[N_COINS],
587     _min_mint_amount: uint256,
588     _receiver: address = msg.sender
589 ) -> uint256:
590     """
591     @notice Deposit coins into the pool
592     @param _amounts List of amounts of coins to deposit
593     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
594     @param _receiver Address that owns the minted LP tokens
595     @return Amount of LP tokens received by depositing
596     """
597     amp: uint256 = self._A()
598     old_balances: uint256[N_COINS] = self.balances
599     rates: uint256[N_COINS] = self.rate_multipliers
600 
601     # Initial invariant
602     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
603 
604     total_supply: uint256 = self.totalSupply
605     new_balances: uint256[N_COINS] = old_balances
606     for i in range(N_COINS):
607         amount: uint256 = _amounts[i]
608         if total_supply == 0:
609             assert amount > 0  # dev: initial deposit requires all coins
610         new_balances[i] += amount
611 
612     # Invariant after change
613     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
614     assert D1 > D0
615 
616     # We need to recalculate the invariant accounting for fees
617     # to calculate fair user's share
618     fees: uint256[N_COINS] = empty(uint256[N_COINS])
619     mint_amount: uint256 = 0
620     if total_supply > 0:
621         # Only account for fees if we are not the first to deposit
622         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
623         for i in range(N_COINS):
624             ideal_balance: uint256 = D1 * old_balances[i] / D0
625             difference: uint256 = 0
626             new_balance: uint256 = new_balances[i]
627             if ideal_balance > new_balance:
628                 difference = ideal_balance - new_balance
629             else:
630                 difference = new_balance - ideal_balance
631             fees[i] = base_fee * difference / FEE_DENOMINATOR
632             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
633             new_balances[i] -= fees[i]
634         xp: uint256[N_COINS] = self._xp_mem(rates, new_balances)
635         D2: uint256 = self.get_D(xp, amp)
636         mint_amount = total_supply * (D2 - D0) / D0
637         self.save_p(xp, amp, D2)
638     else:
639         self.balances = new_balances
640         mint_amount = D1  # Take the dust if there was any
641 
642     assert mint_amount >= _min_mint_amount, "Slippage screwed you"
643 
644     # Take coins from the sender
645     assert msg.value == _amounts[0]
646     if _amounts[1] > 0:
647         assert ERC20(self.coins[1]).transferFrom(msg.sender, self, _amounts[1], default_return_value=True)  # dev: failed transfer
648 
649     # Mint pool tokens
650     total_supply += mint_amount
651     self.balanceOf[_receiver] += mint_amount
652     self.totalSupply = total_supply
653     log Transfer(empty(address), _receiver, mint_amount)
654 
655     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
656 
657     return mint_amount
658 
659 
660 @view
661 @internal
662 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS], _amp: uint256, _D: uint256) -> uint256:
663     """
664     Calculate x[j] if one makes x[i] = x
665 
666     Done by solving quadratic equation iteratively.
667     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
668     x_1**2 + b*x_1 = c
669 
670     x_1 = (x_1**2 + c) / (2*x_1 + b)
671     """
672     # x in the input is converted to the same price/precision
673 
674     assert i != j       # dev: same coin
675     assert j >= 0       # dev: j below zero
676     assert j < N_COINS_128  # dev: j above N_COINS
677 
678     # should be unreachable, but good for safety
679     assert i >= 0
680     assert i < N_COINS_128
681 
682     amp: uint256 = _amp
683     D: uint256 = _D
684     if _D == 0:
685         amp = self._A()
686         D = self.get_D(xp, amp)
687     S_: uint256 = 0
688     _x: uint256 = 0
689     y_prev: uint256 = 0
690     c: uint256 = D
691     Ann: uint256 = amp * N_COINS
692 
693     for _i in range(N_COINS_128):
694         if _i == i:
695             _x = x
696         elif _i != j:
697             _x = xp[_i]
698         else:
699             continue
700         S_ += _x
701         c = c * D / (_x * N_COINS)
702 
703     c = c * D * A_PRECISION / (Ann * N_COINS)
704     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
705     y: uint256 = D
706 
707     for _i in range(255):
708         y_prev = y
709         y = (y*y + c) / (2 * y + b - D)
710         # Equality with the precision of 1
711         if y > y_prev:
712             if y - y_prev <= 1:
713                 return y
714         else:
715             if y_prev - y <= 1:
716                 return y
717     raise
718 
719 
720 @view
721 @external
722 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
723     """
724     @notice Calculate the current output dy given input dx
725     @dev Index values can be found via the `coins` public getter method
726     @param i Index value for the coin to send
727     @param j Index valie of the coin to recieve
728     @param dx Amount of `i` being exchanged
729     @return Amount of `j` predicted
730     """
731     rates: uint256[N_COINS] = self.rate_multipliers
732     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
733 
734     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
735     y: uint256 = self.get_y(i, j, x, xp, 0, 0)
736     dy: uint256 = xp[j] - y - 1
737     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
738     return (dy - fee) * PRECISION / rates[j]
739 
740 
741 @payable
742 @external
743 @nonreentrant('lock')
744 def exchange(
745     i: int128,
746     j: int128,
747     _dx: uint256,
748     _min_dy: uint256,
749     _receiver: address = msg.sender,
750 ) -> uint256:
751     """
752     @notice Perform an exchange between two coins
753     @dev Index values can be found via the `coins` public getter method
754     @param i Index value for the coin to send
755     @param j Index valie of the coin to recieve
756     @param _dx Amount of `i` being exchanged
757     @param _min_dy Minimum amount of `j` to receive
758     @return Actual amount of `j` received
759     """
760     rates: uint256[N_COINS] = self.rate_multipliers
761     old_balances: uint256[N_COINS] = self.balances
762     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
763 
764     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
765 
766     amp: uint256 = self._A()
767     D: uint256 = self.get_D(xp, amp)
768     y: uint256 = self.get_y(i, j, x, xp, amp, D)
769 
770     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
771     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
772 
773     # Convert all to real units
774     dy = (dy - dy_fee) * PRECISION / rates[j]
775     assert dy >= _min_dy, "Exchange resulted in fewer coins than expected"
776 
777     # xp is not used anymore, so we reuse it for price calc
778     xp[i] = x
779     xp[j] = y
780     # D is not changed because we did not apply a fee
781     self.save_p(xp, amp, D)
782 
783     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
784     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
785 
786     # Change balances exactly in same way as we change actual ERC20 coin amounts
787     self.balances[i] = old_balances[i] + _dx
788     # When rounding errors happen, we undercharge admin fee in favor of LP
789     self.balances[j] = old_balances[j] - dy - dy_admin_fee
790 
791     coin: address = self.coins[1]
792     if i == 0:
793         assert msg.value == _dx
794         assert ERC20(coin).transfer(_receiver, dy, default_return_value=True)
795     else:
796         assert msg.value == 0
797         assert ERC20(coin).transferFrom(msg.sender, self, _dx, default_return_value=True)
798         raw_call(_receiver, b"", value=dy)
799 
800     log TokenExchange(msg.sender, i, _dx, j, dy)
801 
802     return dy
803 
804 
805 @external
806 @nonreentrant('lock')
807 def remove_liquidity(
808     _burn_amount: uint256,
809     _min_amounts: uint256[N_COINS],
810     _receiver: address = msg.sender
811 ) -> uint256[N_COINS]:
812     """
813     @notice Withdraw coins from the pool
814     @dev Withdrawal amounts are based on current deposit ratios
815     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
816     @param _min_amounts Minimum amounts of underlying coins to receive
817     @param _receiver Address that receives the withdrawn coins
818     @return List of amounts of coins that were withdrawn
819     """
820     total_supply: uint256 = self.totalSupply
821     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
822 
823     for i in range(N_COINS):
824         old_balance: uint256 = self.balances[i]
825         value: uint256 = old_balance * _burn_amount / total_supply
826         assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"
827         self.balances[i] = old_balance - value
828         amounts[i] = value
829 
830         if i == 0:
831             raw_call(_receiver, b"", value=value)
832         else:
833             assert ERC20(self.coins[1]).transfer(_receiver, value, default_return_value=True)
834 
835     total_supply -= _burn_amount
836     self.balanceOf[msg.sender] -= _burn_amount
837     self.totalSupply = total_supply
838     log Transfer(msg.sender, empty(address), _burn_amount)
839 
840     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
841 
842     return amounts
843 
844 
845 @external
846 @nonreentrant('lock')
847 def remove_liquidity_imbalance(
848     _amounts: uint256[N_COINS],
849     _max_burn_amount: uint256,
850     _receiver: address = msg.sender
851 ) -> uint256:
852     """
853     @notice Withdraw coins from the pool in an imbalanced amount
854     @param _amounts List of amounts of underlying coins to withdraw
855     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
856     @param _receiver Address that receives the withdrawn coins
857     @return Actual amount of the LP token burned in the withdrawal
858     """
859     amp: uint256 = self._A()
860     rates: uint256[N_COINS] = self.rate_multipliers
861     old_balances: uint256[N_COINS] = self.balances
862     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
863 
864     new_balances: uint256[N_COINS] = old_balances
865     for i in range(N_COINS):
866         new_balances[i] -= _amounts[i]
867     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
868 
869     fees: uint256[N_COINS] = empty(uint256[N_COINS])
870     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
871     for i in range(N_COINS):
872         ideal_balance: uint256 = D1 * old_balances[i] / D0
873         difference: uint256 = 0
874         new_balance: uint256 = new_balances[i]
875         if ideal_balance > new_balance:
876             difference = ideal_balance - new_balance
877         else:
878             difference = new_balance - ideal_balance
879         fees[i] = base_fee * difference / FEE_DENOMINATOR
880         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
881         new_balances[i] -= fees[i]
882     new_balances = self._xp_mem(rates, new_balances)
883     D2: uint256 = self.get_D(new_balances, amp)
884 
885     self.save_p(new_balances, amp, D2)
886 
887     total_supply: uint256 = self.totalSupply
888     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
889     assert burn_amount > 1  # dev: zero tokens burned
890     assert burn_amount <= _max_burn_amount, "Slippage screwed you"
891 
892     total_supply -= burn_amount
893     self.totalSupply = total_supply
894     self.balanceOf[msg.sender] -= burn_amount
895     log Transfer(msg.sender, empty(address), burn_amount)
896 
897     if _amounts[0] != 0:
898         raw_call(_receiver, b"", value=_amounts[0])
899     if _amounts[1] != 0:
900         assert ERC20(self.coins[1]).transfer(_receiver, _amounts[1], default_return_value=True)
901 
902     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
903 
904     return burn_amount
905 
906 
907 @pure
908 @internal
909 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
910     """
911     Calculate x[i] if one reduces D from being calculated for xp to D
912 
913     Done by solving quadratic equation iteratively.
914     x_1**2 + x_1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
915     x_1**2 + b*x_1 = c
916 
917     x_1 = (x_1**2 + c) / (2*x_1 + b)
918     """
919     # x in the input is converted to the same price/precision
920 
921     assert i >= 0  # dev: i below zero
922     assert i < N_COINS_128  # dev: i above N_COINS
923 
924     S_: uint256 = 0
925     _x: uint256 = 0
926     y_prev: uint256 = 0
927     c: uint256 = D
928     Ann: uint256 = A * N_COINS
929 
930     for _i in range(N_COINS_128):
931         if _i != i:
932             _x = xp[_i]
933         else:
934             continue
935         S_ += _x
936         c = c * D / (_x * N_COINS)
937 
938     c = c * D * A_PRECISION / (Ann * N_COINS)
939     b: uint256 = S_ + D * A_PRECISION / Ann
940     y: uint256 = D
941 
942     for _i in range(255):
943         y_prev = y
944         y = (y*y + c) / (2 * y + b - D)
945         # Equality with the precision of 1
946         if y > y_prev:
947             if y - y_prev <= 1:
948                 return y
949         else:
950             if y_prev - y <= 1:
951                 return y
952     raise
953 
954 
955 @view
956 @internal
957 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[3]:
958     # First, need to calculate
959     # * Get current D
960     # * Solve Eqn against y_i for D - _token_amount
961     amp: uint256 = self._A()
962     rates: uint256[N_COINS] = self.rate_multipliers
963     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
964     D0: uint256 = self.get_D(xp, amp)
965 
966     total_supply: uint256 = self.totalSupply
967     D1: uint256 = D0 - _burn_amount * D0 / total_supply
968     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
969 
970     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
971     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
972 
973     for j in range(N_COINS_128):
974         dx_expected: uint256 = 0
975         xp_j: uint256 = xp[j]
976         if j == i:
977             dx_expected = xp_j * D1 / D0 - new_y
978         else:
979             dx_expected = xp_j - xp_j * D1 / D0
980         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
981 
982     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
983     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
984     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
985 
986     xp[i] = new_y
987     last_p: uint256 = 0
988     if new_y > 0:
989         last_p = self._get_p(xp, amp, D1)
990 
991     return [dy, dy_0 - dy, last_p]
992 
993 
994 @view
995 @external
996 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
997     """
998     @notice Calculate the amount received when withdrawing a single coin
999     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1000     @param i Index value of the coin to withdraw
1001     @return Amount of coin received
1002     """
1003     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
1004 
1005 
1006 @external
1007 @nonreentrant('lock')
1008 def remove_liquidity_one_coin(
1009     _burn_amount: uint256,
1010     i: int128,
1011     _min_received: uint256,
1012     _receiver: address = msg.sender,
1013 ) -> uint256:
1014     """
1015     @notice Withdraw a single coin from the pool
1016     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1017     @param i Index value of the coin to withdraw
1018     @param _min_received Minimum amount of coin to receive
1019     @param _receiver Address that receives the withdrawn coins
1020     @return Amount of coin received
1021     """
1022     dy: uint256[3] = self._calc_withdraw_one_coin(_burn_amount, i)
1023     assert dy[0] >= _min_received, "Not enough coins removed"
1024 
1025     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
1026     total_supply: uint256 = self.totalSupply - _burn_amount
1027     self.totalSupply = total_supply
1028     self.balanceOf[msg.sender] -= _burn_amount
1029     log Transfer(msg.sender, empty(address), _burn_amount)
1030 
1031     if i == 0:
1032         raw_call(_receiver, b"", value=dy[0])
1033     else:
1034         assert ERC20(self.coins[1]).transfer(_receiver, dy[0], default_return_value=True)
1035 
1036     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
1037 
1038     self.save_p_from_price(dy[2])
1039 
1040     return dy[0]
1041 
1042 
1043 @external
1044 def ramp_A(_future_A: uint256, _future_time: uint256):
1045     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1046     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
1047     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
1048 
1049     _initial_A: uint256 = self._A()
1050     _future_A_p: uint256 = _future_A * A_PRECISION
1051 
1052     assert _future_A > 0 and _future_A < MAX_A
1053     if _future_A_p < _initial_A:
1054         assert _future_A_p * MAX_A_CHANGE >= _initial_A
1055     else:
1056         assert _future_A_p <= _initial_A * MAX_A_CHANGE
1057 
1058     self.initial_A = _initial_A
1059     self.future_A = _future_A_p
1060     self.initial_A_time = block.timestamp
1061     self.future_A_time = _future_time
1062 
1063     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
1064 
1065 
1066 @external
1067 def stop_ramp_A():
1068     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1069 
1070     current_A: uint256 = self._A()
1071     self.initial_A = current_A
1072     self.future_A = current_A
1073     self.initial_A_time = block.timestamp
1074     self.future_A_time = block.timestamp
1075     # now (block.timestamp < t1) is always False, so we return saved A
1076 
1077     log StopRampA(current_A, block.timestamp)
1078 
1079 
1080 @view
1081 @external
1082 def admin_balances(i: uint256) -> uint256:
1083     if i == 0:
1084         return self.balance - self.balances[0]
1085     else:
1086         return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1087 
1088 
1089 @external
1090 def withdraw_admin_fees():
1091     receiver: address = Factory(self.factory).get_fee_receiver(self)
1092 
1093     fees: uint256 = self.balance - self.balances[0]
1094     raw_call(receiver, b"", value=fees)
1095 
1096     coin: address = self.coins[1]
1097     fees = ERC20(coin).balanceOf(self) - self.balances[1]
1098     assert ERC20(coin).transfer(receiver, fees, default_return_value=True)
1099 
1100 
1101 @external
1102 def commit_new_fee(_new_fee: uint256):
1103     assert msg.sender == Factory(self.factory).admin()
1104     assert _new_fee <= MAX_FEE
1105     assert self.admin_action_deadline == 0
1106 
1107     self.future_fee = _new_fee
1108     self.admin_action_deadline = block.timestamp + ADMIN_ACTIONS_DEADLINE_DT
1109     log CommitNewFee(_new_fee)
1110 
1111 
1112 @external
1113 def apply_new_fee():
1114     assert msg.sender == Factory(self.factory).admin()
1115     deadline: uint256 = self.admin_action_deadline
1116     assert deadline != 0 and block.timestamp >= deadline
1117     
1118     fee: uint256 = self.future_fee
1119     self.fee = fee
1120     self.admin_action_deadline = 0
1121     log ApplyNewFee(fee)
1122 
1123 
1124 @external
1125 def set_ma_exp_time(_ma_exp_time: uint256):
1126     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1127     assert _ma_exp_time != 0
1128 
1129     self.ma_exp_time = _ma_exp_time
1130 
1131 
1132 @view
1133 @external
1134 def version() -> String[8]:
1135     """
1136     @notice Get the version of this token contract
1137     """
1138     return VERSION