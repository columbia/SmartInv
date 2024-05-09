1 # @version 0.3.1
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
30 interface ERC1271:
31     def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view
32 
33 
34 event Transfer:
35     sender: indexed(address)
36     receiver: indexed(address)
37     value: uint256
38 
39 event Approval:
40     owner: indexed(address)
41     spender: indexed(address)
42     value: uint256
43 
44 event TokenExchange:
45     buyer: indexed(address)
46     sold_id: int128
47     tokens_sold: uint256
48     bought_id: int128
49     tokens_bought: uint256
50 
51 event TokenExchangeUnderlying:
52     buyer: indexed(address)
53     sold_id: int128
54     tokens_sold: uint256
55     bought_id: int128
56     tokens_bought: uint256
57 
58 event AddLiquidity:
59     provider: indexed(address)
60     token_amounts: uint256[N_COINS]
61     fees: uint256[N_COINS]
62     invariant: uint256
63     token_supply: uint256
64 
65 event RemoveLiquidity:
66     provider: indexed(address)
67     token_amounts: uint256[N_COINS]
68     fees: uint256[N_COINS]
69     token_supply: uint256
70 
71 event RemoveLiquidityOne:
72     provider: indexed(address)
73     token_amount: uint256
74     coin_amount: uint256
75     token_supply: uint256
76 
77 event RemoveLiquidityImbalance:
78     provider: indexed(address)
79     token_amounts: uint256[N_COINS]
80     fees: uint256[N_COINS]
81     invariant: uint256
82     token_supply: uint256
83 
84 event RampA:
85     old_A: uint256
86     new_A: uint256
87     initial_time: uint256
88     future_time: uint256
89 
90 event StopRampA:
91     A: uint256
92     t: uint256
93 
94 
95 BASE_POOL: constant(address) = 0xDcEF968d416a41Cdac0ED8702fAC8128A64241A2
96 BASE_N_COINS: constant(int128) = 2
97 BASE_COINS: constant(address[BASE_N_COINS]) = [0x853d955aCEf822Db058eb8505911ED77F175b99e, 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48]
98 
99 BASE_LP_TOKEN: constant(address) = 0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC
100 
101 N_COINS: constant(int128) = 2
102 MAX_COIN: constant(int128) = N_COINS - 1
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
113 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
114 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
115 
116 # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
117 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
118 VERSION: constant(String[8]) = "v5.0.0"
119 
120 
121 factory: address
122 
123 coins: public(address[N_COINS])
124 balances: public(uint256[N_COINS])
125 fee: public(uint256)  # fee * 1e10
126 
127 initial_A: public(uint256)
128 future_A: public(uint256)
129 initial_A_time: public(uint256)
130 future_A_time: public(uint256)
131 
132 rate_multiplier: uint256
133 
134 name: public(String[64])
135 symbol: public(String[32])
136 
137 balanceOf: public(HashMap[address, uint256])
138 allowance: public(HashMap[address, HashMap[address, uint256]])
139 totalSupply: public(uint256)
140 
141 DOMAIN_SEPARATOR: public(bytes32)
142 nonces: public(HashMap[address, uint256])
143 
144 
145 @external
146 def __init__():
147     # we do this to prevent the implementation contract from being used as a pool
148     self.fee = 31337
149 
150 
151 @external
152 def initialize(
153     _name: String[32],
154     _symbol: String[10],
155     _coin: address,
156     _rate_multiplier: uint256,
157     _A: uint256,
158     _fee: uint256
159 ):
160     """
161     @notice Contract initializer
162     @param _name Name of the new pool
163     @param _symbol Token symbol
164     @param _coin Addresses of ERC20 conracts of coins
165     @param _rate_multiplier Rate multiplier for `_coin` (10 ** (36 - decimals))
166     @param _A Amplification coefficient multiplied by n ** (n - 1)
167     @param _fee Fee to charge for exchanges
168     """
169     # check if fee was already set to prevent initializing contract twice
170     assert self.fee == 0
171 
172     A: uint256 = _A * A_PRECISION
173     self.coins = [_coin, BASE_LP_TOKEN]
174     self.rate_multiplier = _rate_multiplier
175     self.initial_A = A
176     self.future_A = A
177     self.fee = _fee
178     self.factory = msg.sender
179 
180     name: String[64] = concat("Curve.fi Factory USD Metapool: ", _name)
181     self.name = name
182     self.symbol = concat(_symbol, "3CRV-f")
183 
184     for coin in BASE_COINS:
185         ERC20(coin).approve(BASE_POOL, MAX_UINT256)
186 
187     self.DOMAIN_SEPARATOR = keccak256(
188         _abi_encode(EIP712_TYPEHASH, keccak256(name), keccak256(VERSION), chain.id, self)
189     )
190 
191     # fire a transfer event so block explorers identify the contract as an ERC20
192     log Transfer(ZERO_ADDRESS, self, 0)
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
240     if _allowance != MAX_UINT256:
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
289     assert _owner != ZERO_ADDRESS
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
317 @view
318 @internal
319 def _A() -> uint256:
320     """
321     Handle ramping A up or down
322     """
323     t1: uint256 = self.future_A_time
324     A1: uint256 = self.future_A
325 
326     if block.timestamp < t1:
327         A0: uint256 = self.initial_A
328         t0: uint256 = self.initial_A_time
329         # Expressions in uint256 cannot have negative numbers, thus "if"
330         if A1 > A0:
331             return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
332         else:
333             return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
334 
335     else:  # when t1 == 0 or block.timestamp >= t1
336         return A1
337 
338 
339 @view
340 @external
341 def admin_fee() -> uint256:
342     return ADMIN_FEE
343 
344 
345 @view
346 @external
347 def A() -> uint256:
348     return self._A() / A_PRECISION
349 
350 
351 @view
352 @external
353 def A_precise() -> uint256:
354     return self._A()
355 
356 
357 @pure
358 @internal
359 def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
360     result: uint256[N_COINS] = empty(uint256[N_COINS])
361     for i in range(N_COINS):
362         result[i] = _rates[i] * _balances[i] / PRECISION
363     return result
364 
365 
366 @pure
367 @internal
368 def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:
369     """
370     D invariant calculation in non-overflowing integer operations
371     iteratively
372 
373     A * sum(x_i) * n**n + D = A * D * n**n + D**(n+1) / (n**n * prod(x_i))
374 
375     Converging solution:
376     D[j+1] = (A * n**n * sum(x_i) - D[j]**(n+1) / (n**n prod(x_i))) / (A * n**n - 1)
377     """
378     S: uint256 = 0
379     Dprev: uint256 = 0
380     for x in _xp:
381         S += x
382     if S == 0:
383         return 0
384 
385     D: uint256 = S
386     Ann: uint256 = _amp * N_COINS
387     for i in range(255):
388         D_P: uint256 = D
389         for x in _xp:
390             D_P = D_P * D / (x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good
391         Dprev = D
392         D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)
393         # Equality with the precision of 1
394         if D > Dprev:
395             if D - Dprev <= 1:
396                 return D
397         else:
398             if Dprev - D <= 1:
399                 return D
400     # convergence typically occurs in 4 rounds or less, this should be unreachable!
401     # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`
402     raise
403 
404 
405 @view
406 @internal
407 def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:
408     xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)
409     return self.get_D(xp, _amp)
410 
411 
412 @view
413 @external
414 def get_virtual_price() -> uint256:
415     """
416     @notice The current virtual price of the pool LP token
417     @dev Useful for calculating profits
418     @return LP token virtual price normalized to 1e18
419     """
420     amp: uint256 = self._A()
421     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
422     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
423     D: uint256 = self.get_D(xp, amp)
424     # D is in the units similar to DAI (e.g. converted to precision 1e18)
425     # When balanced, D = n * x_u - total virtual value of the portfolio
426     return D * PRECISION / self.totalSupply
427 
428 
429 @view
430 @external
431 def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:
432     """
433     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
434     @dev This calculation accounts for slippage, but not fees.
435          Needed to prevent front-running, not for precise calculations!
436     @param _amounts Amount of each coin being deposited
437     @param _is_deposit set True for deposits, False for withdrawals
438     @return Expected amount of LP tokens received
439     """
440     amp: uint256 = self._A()
441     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
442     balances: uint256[N_COINS] = self.balances
443 
444     D0: uint256 = self.get_D_mem(rates, balances, amp)
445     for i in range(N_COINS):
446         amount: uint256 = _amounts[i]
447         if _is_deposit:
448             balances[i] += amount
449         else:
450             balances[i] -= amount
451     D1: uint256 = self.get_D_mem(rates, balances, amp)
452     diff: uint256 = 0
453     if _is_deposit:
454         diff = D1 - D0
455     else:
456         diff = D0 - D1
457     return diff * self.totalSupply / D0
458 
459 
460 @external
461 @nonreentrant('lock')
462 def add_liquidity(
463     _amounts: uint256[N_COINS],
464     _min_mint_amount: uint256,
465     _receiver: address = msg.sender
466 ) -> uint256:
467     """
468     @notice Deposit coins into the pool
469     @param _amounts List of amounts of coins to deposit
470     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
471     @param _receiver Address that owns the minted LP tokens
472     @return Amount of LP tokens received by depositing
473     """
474     amp: uint256 = self._A()
475     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
476 
477     # Initial invariant
478     old_balances: uint256[N_COINS] = self.balances
479     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
480     new_balances: uint256[N_COINS] = old_balances
481 
482     total_supply: uint256 = self.totalSupply
483     for i in range(N_COINS):
484         amount: uint256 = _amounts[i]
485         if amount == 0:
486             assert total_supply > 0
487         else:
488             response: Bytes[32] = raw_call(
489                 self.coins[i],
490                 _abi_encode(
491                     msg.sender,
492                     self,
493                     amount,
494                     method_id=method_id("transferFrom(address,address,uint256)")
495                 ),
496                 max_outsize=32,
497             )
498             if len(response) > 0:
499                 assert convert(response, bool)
500             new_balances[i] += amount
501 
502     # Invariant after change
503     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
504     assert D1 > D0
505 
506     # We need to recalculate the invariant accounting for fees
507     # to calculate fair user's share
508     fees: uint256[N_COINS] = empty(uint256[N_COINS])
509     mint_amount: uint256 = 0
510     if total_supply > 0:
511         # Only account for fees if we are not the first to deposit
512         base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
513         for i in range(N_COINS):
514             ideal_balance: uint256 = D1 * old_balances[i] / D0
515             difference: uint256 = 0
516             new_balance: uint256 = new_balances[i]
517             if ideal_balance > new_balance:
518                 difference = ideal_balance - new_balance
519             else:
520                 difference = new_balance - ideal_balance
521             fees[i] = base_fee * difference / FEE_DENOMINATOR
522             self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
523             new_balances[i] -= fees[i]
524         D2: uint256 = self.get_D_mem(rates, new_balances, amp)
525         mint_amount = total_supply * (D2 - D0) / D0
526     else:
527         self.balances = new_balances
528         mint_amount = D1  # Take the dust if there was any
529 
530     assert mint_amount >= _min_mint_amount
531 
532     # Mint pool tokens
533     total_supply += mint_amount
534     self.balanceOf[_receiver] += mint_amount
535     self.totalSupply = total_supply
536     log Transfer(ZERO_ADDRESS, _receiver, mint_amount)
537     log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)
538 
539     return mint_amount
540 
541 
542 @view
543 @internal
544 def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:
545     # x in the input is converted to the same price/precision
546 
547     assert i != j       # dev: same coin
548     assert j >= 0       # dev: j below zero
549     assert j < N_COINS  # dev: j above N_COINS
550 
551     # should be unreachable, but good for safety
552     assert i >= 0
553     assert i < N_COINS
554 
555     amp: uint256 = self._A()
556     D: uint256 = self.get_D(xp, amp)
557     S_: uint256 = 0
558     _x: uint256 = 0
559     y_prev: uint256 = 0
560     c: uint256 = D
561     Ann: uint256 = amp * N_COINS
562 
563     for _i in range(N_COINS):
564         if _i == i:
565             _x = x
566         elif _i != j:
567             _x = xp[_i]
568         else:
569             continue
570         S_ += _x
571         c = c * D / (_x * N_COINS)
572 
573     c = c * D * A_PRECISION / (Ann * N_COINS)
574     b: uint256 = S_ + D * A_PRECISION / Ann  # - D
575     y: uint256 = D
576 
577     for _i in range(255):
578         y_prev = y
579         y = (y*y + c) / (2 * y + b - D)
580         # Equality with the precision of 1
581         if y > y_prev:
582             if y - y_prev <= 1:
583                 return y
584         else:
585             if y_prev - y <= 1:
586                 return y
587     raise
588 
589 
590 @view
591 @external
592 def get_dy(i: int128, j: int128, dx: uint256) -> uint256:
593     """
594     @notice Calculate the current output dy given input dx
595     @dev Index values can be found via the `coins` public getter method
596     @param i Index value for the coin to send
597     @param j Index valie of the coin to recieve
598     @param dx Amount of `i` being exchanged
599     @return Amount of `j` predicted
600     """
601     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
602     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
603 
604     x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
605     y: uint256 = self.get_y(i, j, x, xp)
606     dy: uint256 = xp[j] - y - 1
607     fee: uint256 = self.fee * dy / FEE_DENOMINATOR
608     return (dy - fee) * PRECISION / rates[j]
609 
610 
611 @view
612 @external
613 def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:
614     """
615     @notice Calculate the current output dy given input dx on underlying
616     @dev Index values can be found via the `coins` public getter method
617     @param i Index value for the coin to send
618     @param j Index valie of the coin to recieve
619     @param dx Amount of `i` being exchanged
620     @return Amount of `j` predicted
621     """
622     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
623     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
624 
625     x: uint256 = 0
626     base_i: int128 = 0
627     base_j: int128 = 0
628     meta_i: int128 = 0
629     meta_j: int128 = 0
630 
631     if i != 0:
632         base_i = i - MAX_COIN
633         meta_i = 1
634     if j != 0:
635         base_j = j - MAX_COIN
636         meta_j = 1
637 
638     if i == 0:
639         x = xp[i] + dx * (rates[0] / 10**18)
640     else:
641         if j == 0:
642             # i is from BasePool
643             # At first, get the amount of pool tokens
644             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
645             base_inputs[base_i] = dx
646             # Token amount transformed to underlying "dollars"
647             x = Curve(BASE_POOL).calc_token_amount(base_inputs, True) * rates[1] / PRECISION
648             # Accounting for deposit/withdraw fees approximately
649             x -= x * Curve(BASE_POOL).fee() / (2 * FEE_DENOMINATOR)
650             # Adding number of pool tokens
651             x += xp[MAX_COIN]
652         else:
653             # If both are from the base pool
654             return Curve(BASE_POOL).get_dy(base_i, base_j, dx)
655 
656     # This pool is involved only when in-pool assets are used
657     y: uint256 = self.get_y(meta_i, meta_j, x, xp)
658     dy: uint256 = xp[meta_j] - y - 1
659     dy = (dy - self.fee * dy / FEE_DENOMINATOR)
660 
661     # If output is going via the metapool
662     if j == 0:
663         dy /= (rates[0] / 10**18)
664     else:
665         # j is from BasePool
666         # The fee is already accounted for
667         dy = Curve(BASE_POOL).calc_withdraw_one_coin(dy * PRECISION / rates[1], base_j)
668 
669     return dy
670 
671 
672 @external
673 @nonreentrant('lock')
674 def exchange(
675     i: int128,
676     j: int128,
677     _dx: uint256,
678     _min_dy: uint256,
679     _receiver: address = msg.sender,
680 ) -> uint256:
681     """
682     @notice Perform an exchange between two coins
683     @dev Index values can be found via the `coins` public getter method
684     @param i Index value for the coin to send
685     @param j Index valie of the coin to recieve
686     @param _dx Amount of `i` being exchanged
687     @param _min_dy Minimum amount of `j` to receive
688     @param _receiver Address that receives `j`
689     @return Actual amount of `j` received
690     """
691     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
692 
693     old_balances: uint256[N_COINS] = self.balances
694     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
695 
696     x: uint256 = xp[i] + _dx * rates[i] / PRECISION
697     y: uint256 = self.get_y(i, j, x, xp)
698 
699     dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
700     dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
701 
702     # Convert all to real units
703     dy = (dy - dy_fee) * PRECISION / rates[j]
704     assert dy >= _min_dy
705 
706     dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
707     dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
708 
709     # Change balances exactly in same way as we change actual ERC20 coin amounts
710     self.balances[i] = old_balances[i] + _dx
711     # When rounding errors happen, we undercharge admin fee in favor of LP
712     self.balances[j] = old_balances[j] - dy - dy_admin_fee
713 
714     response: Bytes[32] = raw_call(
715         self.coins[i],
716         _abi_encode(
717             msg.sender, self, _dx, method_id=method_id("transferFrom(address,address,uint256)")
718         ),
719         max_outsize=32,
720     )
721     if len(response) > 0:
722         assert convert(response, bool)
723 
724     response = raw_call(
725         self.coins[j],
726         _abi_encode(_receiver, dy, method_id=method_id("transfer(address,uint256)")),
727         max_outsize=32,
728     )
729     if len(response) > 0:
730         assert convert(response, bool)
731 
732     log TokenExchange(msg.sender, i, _dx, j, dy)
733 
734     return dy
735 
736 
737 @external
738 @nonreentrant('lock')
739 def exchange_underlying(
740     i: int128,
741     j: int128,
742     _dx: uint256,
743     _min_dy: uint256,
744     _receiver: address = msg.sender,
745 ) -> uint256:
746     """
747     @notice Perform an exchange between two underlying coins
748     @param i Index value for the underlying coin to send
749     @param j Index valie of the underlying coin to receive
750     @param _dx Amount of `i` being exchanged
751     @param _min_dy Minimum amount of `j` to receive
752     @param _receiver Address that receives `j`
753     @return Actual amount of `j` received
754     """
755     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
756     old_balances: uint256[N_COINS] = self.balances
757     xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)
758 
759     base_coins: address[BASE_N_COINS] = BASE_COINS
760 
761     dy: uint256 = 0
762     base_i: int128 = 0
763     base_j: int128 = 0
764     meta_i: int128 = 0
765     meta_j: int128 = 0
766     x: uint256 = 0
767     input_coin: address = ZERO_ADDRESS
768     output_coin: address = ZERO_ADDRESS
769 
770     if i == 0:
771         input_coin = self.coins[0]
772     else:
773         base_i = i - MAX_COIN
774         meta_i = 1
775         input_coin = base_coins[base_i]
776     if j == 0:
777         output_coin = self.coins[0]
778     else:
779         base_j = j - MAX_COIN
780         meta_j = 1
781         output_coin = base_coins[base_j]
782 
783     response: Bytes[32] = raw_call(
784         input_coin,
785         _abi_encode(
786             msg.sender, self, _dx, method_id=method_id("transferFrom(address,address,uint256)")
787         ),
788         max_outsize=32,
789     )
790     if len(response) > 0:
791         assert convert(response, bool)
792 
793     dx: uint256 = _dx
794     if i == 0 or j == 0:
795         if i == 0:
796             x = xp[i] + dx * rates[i] / PRECISION
797         else:
798             # i is from BasePool
799             # At first, get the amount of pool tokens
800             base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
801             base_inputs[base_i] = dx
802             coin_i: address = self.coins[MAX_COIN]
803             # Deposit and measure delta
804             x = ERC20(coin_i).balanceOf(self)
805             Curve(BASE_POOL).add_liquidity(base_inputs, 0)
806             # Need to convert pool token to "virtual" units using rates
807             # dx is also different now
808             dx = ERC20(coin_i).balanceOf(self) - x
809             x = dx * rates[MAX_COIN] / PRECISION
810             # Adding number of pool tokens
811             x += xp[MAX_COIN]
812 
813         y: uint256 = self.get_y(meta_i, meta_j, x, xp)
814 
815         # Either a real coin or token
816         dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors
817         dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
818 
819         # Convert all to real units
820         # Works for both pool coins and real coins
821         dy = (dy - dy_fee) * PRECISION / rates[meta_j]
822 
823         dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR
824         dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]
825 
826         # Change balances exactly in same way as we change actual ERC20 coin amounts
827         self.balances[meta_i] = old_balances[meta_i] + dx
828         # When rounding errors happen, we undercharge admin fee in favor of LP
829         self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee
830 
831         # Withdraw from the base pool if needed
832         if j > 0:
833             out_amount: uint256 = ERC20(output_coin).balanceOf(self)
834             Curve(BASE_POOL).remove_liquidity_one_coin(dy, base_j, 0)
835             dy = ERC20(output_coin).balanceOf(self) - out_amount
836 
837         assert dy >= _min_dy
838 
839     else:
840         # If both are from the base pool
841         dy = ERC20(output_coin).balanceOf(self)
842         Curve(BASE_POOL).exchange(base_i, base_j, dx, _min_dy)
843         dy = ERC20(output_coin).balanceOf(self) - dy
844 
845     response = raw_call(
846         output_coin,
847         _abi_encode(_receiver, dy, method_id=method_id("transfer(address,uint256)")),
848         max_outsize=32,
849     )
850     if len(response) > 0:
851         assert convert(response, bool)
852 
853     log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)
854 
855     return dy
856 
857 
858 @external
859 @nonreentrant('lock')
860 def remove_liquidity(
861     _burn_amount: uint256,
862     _min_amounts: uint256[N_COINS],
863     _receiver: address = msg.sender
864 ) -> uint256[N_COINS]:
865     """
866     @notice Withdraw coins from the pool
867     @dev Withdrawal amounts are based on current deposit ratios
868     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
869     @param _min_amounts Minimum amounts of underlying coins to receive
870     @param _receiver Address that receives the withdrawn coins
871     @return List of amounts of coins that were withdrawn
872     """
873     total_supply: uint256 = self.totalSupply
874     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
875 
876     for i in range(N_COINS):
877         old_balance: uint256 = self.balances[i]
878         value: uint256 = old_balance * _burn_amount / total_supply
879         assert value >= _min_amounts[i]
880         self.balances[i] = old_balance - value
881         amounts[i] = value
882         response: Bytes[32] = raw_call(
883             self.coins[i],
884             _abi_encode(_receiver, value, method_id=method_id("transfer(address,uint256)")),
885             max_outsize=32,
886         )
887         if len(response) > 0:
888             assert convert(response, bool)
889 
890     total_supply -= _burn_amount
891     self.balanceOf[msg.sender] -= _burn_amount
892     self.totalSupply = total_supply
893     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
894 
895     log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)
896 
897     return amounts
898 
899 
900 @external
901 @nonreentrant('lock')
902 def remove_liquidity_imbalance(
903     _amounts: uint256[N_COINS],
904     _max_burn_amount: uint256,
905     _receiver: address = msg.sender
906 ) -> uint256:
907     """
908     @notice Withdraw coins from the pool in an imbalanced amount
909     @param _amounts List of amounts of underlying coins to withdraw
910     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
911     @param _receiver Address that receives the withdrawn coins
912     @return Actual amount of the LP token burned in the withdrawal
913     """
914     amp: uint256 = self._A()
915     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
916     old_balances: uint256[N_COINS] = self.balances
917     D0: uint256 = self.get_D_mem(rates, old_balances, amp)
918 
919     new_balances: uint256[N_COINS] = old_balances
920     for i in range(N_COINS):
921         amount: uint256 = _amounts[i]
922         if amount != 0:
923             new_balances[i] -= amount
924             response: Bytes[32] = raw_call(
925                 self.coins[i],
926                 _abi_encode(_receiver, amount, method_id=method_id("transfer(address,uint256)")),
927                 max_outsize=32,
928             )
929             if len(response) > 0:
930                 assert convert(response, bool)
931     D1: uint256 = self.get_D_mem(rates, new_balances, amp)
932 
933     fees: uint256[N_COINS] = empty(uint256[N_COINS])
934     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
935     for i in range(N_COINS):
936         ideal_balance: uint256 = D1 * old_balances[i] / D0
937         difference: uint256 = 0
938         new_balance: uint256 = new_balances[i]
939         if ideal_balance > new_balance:
940             difference = ideal_balance - new_balance
941         else:
942             difference = new_balance - ideal_balance
943         fees[i] = base_fee * difference / FEE_DENOMINATOR
944         self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)
945         new_balances[i] -= fees[i]
946     D2: uint256 = self.get_D_mem(rates, new_balances, amp)
947 
948     total_supply: uint256 = self.totalSupply
949     burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1
950     assert burn_amount > 1  # dev: zero tokens burned
951     assert burn_amount <= _max_burn_amount
952 
953     total_supply -= burn_amount
954     self.totalSupply = total_supply
955     self.balanceOf[msg.sender] -= burn_amount
956     log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)
957     log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)
958 
959     return burn_amount
960 
961 
962 @view
963 @internal
964 def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:
965     """
966     Calculate x[i] if one reduces D from being calculated for xp to D
967 
968     Done by solving quadratic equation iteratively.
969     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
970     x_1**2 + b*x_1 = c
971 
972     x_1 = (x_1**2 + c) / (2*x_1 + b)
973     """
974     # x in the input is converted to the same price/precision
975 
976     assert i >= 0  # dev: i below zero
977     assert i < N_COINS  # dev: i above N_COINS
978 
979     S_: uint256 = 0
980     _x: uint256 = 0
981     y_prev: uint256 = 0
982     c: uint256 = D
983     Ann: uint256 = A * N_COINS
984 
985     for _i in range(N_COINS):
986         if _i != i:
987             _x = xp[_i]
988         else:
989             continue
990         S_ += _x
991         c = c * D / (_x * N_COINS)
992 
993     c = c * D * A_PRECISION / (Ann * N_COINS)
994     b: uint256 = S_ + D * A_PRECISION / Ann
995     y: uint256 = D
996 
997     for _i in range(255):
998         y_prev = y
999         y = (y*y + c) / (2 * y + b - D)
1000         # Equality with the precision of 1
1001         if y > y_prev:
1002             if y - y_prev <= 1:
1003                 return y
1004         else:
1005             if y_prev - y <= 1:
1006                 return y
1007     raise
1008 
1009 
1010 @view
1011 @internal
1012 def _calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256[2]:
1013     # First, need to calculate
1014     # * Get current D
1015     # * Solve Eqn against y_i for D - _token_amount
1016     amp: uint256 = self._A()
1017     rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
1018     xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
1019     D0: uint256 = self.get_D(xp, amp)
1020 
1021     total_supply: uint256 = self.totalSupply
1022     D1: uint256 = D0 - _burn_amount * D0 / total_supply
1023     new_y: uint256 = self.get_y_D(amp, i, xp, D1)
1024 
1025     base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))
1026     xp_reduced: uint256[N_COINS] = empty(uint256[N_COINS])
1027 
1028     for j in range(N_COINS):
1029         dx_expected: uint256 = 0
1030         xp_j: uint256 = xp[j]
1031         if j == i:
1032             dx_expected = xp_j * D1 / D0 - new_y
1033         else:
1034             dx_expected = xp_j - xp_j * D1 / D0
1035         xp_reduced[j] = xp_j - base_fee * dx_expected / FEE_DENOMINATOR
1036 
1037     dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
1038     dy_0: uint256 = (xp[i] - new_y) * PRECISION / rates[i]  # w/o fees
1039     dy = (dy - 1) * PRECISION / rates[i]  # Withdraw less to account for rounding errors
1040 
1041     return [dy, dy_0 - dy]
1042 
1043 
1044 @view
1045 @external
1046 def calc_withdraw_one_coin(_burn_amount: uint256, i: int128) -> uint256:
1047     """
1048     @notice Calculate the amount received when withdrawing a single coin
1049     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1050     @param i Index value of the coin to withdraw
1051     @return Amount of coin received
1052     """
1053     return self._calc_withdraw_one_coin(_burn_amount, i)[0]
1054 
1055 
1056 @external
1057 @nonreentrant('lock')
1058 def remove_liquidity_one_coin(
1059     _burn_amount: uint256,
1060     i: int128,
1061     _min_received: uint256,
1062     _receiver: address = msg.sender,
1063 ) -> uint256:
1064     """
1065     @notice Withdraw a single coin from the pool
1066     @param _burn_amount Amount of LP tokens to burn in the withdrawal
1067     @param i Index value of the coin to withdraw
1068     @param _min_received Minimum amount of coin to receive
1069     @param _receiver Address that receives the withdrawn coins
1070     @return Amount of coin received
1071     """
1072     dy: uint256[2] = self._calc_withdraw_one_coin(_burn_amount, i)
1073     assert dy[0] >= _min_received
1074 
1075     self.balances[i] -= (dy[0] + dy[1] * ADMIN_FEE / FEE_DENOMINATOR)
1076     total_supply: uint256 = self.totalSupply - _burn_amount
1077     self.totalSupply = total_supply
1078     self.balanceOf[msg.sender] -= _burn_amount
1079     log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)
1080 
1081     response: Bytes[32] = raw_call(
1082         self.coins[i],
1083         _abi_encode(_receiver, dy[0], method_id=method_id("transfer(address,uint256)")),
1084         max_outsize=32,
1085     )
1086     if len(response) > 0:
1087         assert convert(response, bool)
1088 
1089     log RemoveLiquidityOne(msg.sender, _burn_amount, dy[0], total_supply)
1090 
1091     return dy[0]
1092 
1093 
1094 @external
1095 def ramp_A(_future_A: uint256, _future_time: uint256):
1096     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1097     assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME
1098     assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time
1099 
1100     _initial_A: uint256 = self._A()
1101     _future_A_p: uint256 = _future_A * A_PRECISION
1102 
1103     assert _future_A > 0 and _future_A < MAX_A
1104     if _future_A_p < _initial_A:
1105         assert _future_A_p * MAX_A_CHANGE >= _initial_A
1106     else:
1107         assert _future_A_p <= _initial_A * MAX_A_CHANGE
1108 
1109     self.initial_A = _initial_A
1110     self.future_A = _future_A_p
1111     self.initial_A_time = block.timestamp
1112     self.future_A_time = _future_time
1113 
1114     log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)
1115 
1116 
1117 @external
1118 def stop_ramp_A():
1119     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
1120 
1121     current_A: uint256 = self._A()
1122     self.initial_A = current_A
1123     self.future_A = current_A
1124     self.initial_A_time = block.timestamp
1125     self.future_A_time = block.timestamp
1126     # now (block.timestamp < t1) is always False, so we return saved A
1127 
1128     log StopRampA(current_A, block.timestamp)
1129 
1130 
1131 @view
1132 @external
1133 def admin_balances(i: uint256) -> uint256:
1134     return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]
1135 
1136 
1137 @external
1138 def withdraw_admin_fees():
1139     # transfer coin 0 to Factory and call `convert_fees` to swap it for coin 1
1140     factory: address = self.factory
1141     coin: address = self.coins[0]
1142     amount: uint256 = ERC20(coin).balanceOf(self) - self.balances[0]
1143     if amount > 0:
1144         response: Bytes[32] = raw_call(
1145             coin,
1146             _abi_encode(factory, amount, method_id=method_id("transfer(address,uint256)")),
1147             max_outsize=32,
1148         )
1149         if len(response) > 0:
1150             assert convert(response, bool)
1151         Factory(factory).convert_metapool_fees()
1152 
1153     # transfer coin 1 to the receiver
1154     coin = self.coins[1]
1155     amount = ERC20(coin).balanceOf(self) - self.balances[1]
1156     if amount > 0:
1157         receiver: address = Factory(factory).get_fee_receiver(self)
1158         response: Bytes[32] = raw_call(
1159             coin,
1160             _abi_encode(receiver, amount, method_id=method_id("transfer(address,uint256)")),
1161             max_outsize=32,
1162         )
1163         if len(response) > 0:
1164             assert convert(response, bool)
1165 
1166 
1167 @view
1168 @external
1169 def version() -> String[8]:
1170     """
1171     @notice Get the version of this token contract
1172     """
1173     return VERSION