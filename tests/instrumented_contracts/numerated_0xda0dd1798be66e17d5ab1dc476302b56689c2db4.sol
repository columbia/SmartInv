1 # @version 0.3.1
2 """
3 @title Liquidity Gauge
4 @author Curve Finance
5 @license MIT
6 @notice Implementation contract for use with Curve Factory
7 """
8 from vyper.interfaces import ERC20
9 
10 implements: ERC20
11 
12 
13 interface CRV20:
14     def future_epoch_time_write() -> uint256: nonpayable
15     def rate() -> uint256: view
16 
17 interface Controller:
18     def checkpoint_gauge(addr: address): nonpayable
19     def gauge_relative_weight(addr: address, time: uint256) -> uint256: view
20 
21 interface ERC20Extended:
22     def symbol() -> String[32]: view
23 
24 interface ERC1271:
25     def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view
26 
27 interface Factory:
28     def admin() -> address: view
29 
30 interface Minter:
31     def minted(user: address, gauge: address) -> uint256: view
32 
33 interface VotingEscrow:
34     def user_point_epoch(addr: address) -> uint256: view
35     def user_point_history__ts(addr: address, epoch: uint256) -> uint256: view
36 
37 interface VotingEscrowBoost:
38     def adjusted_balance_of(_account: address) -> uint256: view
39 
40 
41 event Deposit:
42     provider: indexed(address)
43     value: uint256
44 
45 event Withdraw:
46     provider: indexed(address)
47     value: uint256
48 
49 event UpdateLiquidityLimit:
50     user: indexed(address)
51     original_balance: uint256
52     original_supply: uint256
53     working_balance: uint256
54     working_supply: uint256
55 
56 event CommitOwnership:
57     admin: address
58 
59 event ApplyOwnership:
60     admin: address
61 
62 event Transfer:
63     _from: indexed(address)
64     _to: indexed(address)
65     _value: uint256
66 
67 event Approval:
68     _owner: indexed(address)
69     _spender: indexed(address)
70     _value: uint256
71 
72 
73 struct Reward:
74     token: address
75     distributor: address
76     period_finish: uint256
77     rate: uint256
78     last_update: uint256
79     integral: uint256
80 
81 
82 CLAIM_FREQUENCY: constant(uint256) = 3600
83 MAX_REWARDS: constant(uint256) = 8
84 TOKENLESS_PRODUCTION: constant(uint256) = 40
85 WEEK: constant(uint256) = 604800
86 
87 # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
88 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
89 VERSION: constant(String[8]) = "v5.0.0"
90 
91 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
92 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
93 
94 CRV: constant(address) = 0xD533a949740bb3306d119CC777fa900bA034cd52
95 GAUGE_CONTROLLER: constant(address) = 0x2F50D538606Fa9EDD2B11E2446BEb18C9D5846bB
96 MINTER: constant(address) = 0xd061D61a4d941c39E5453435B6345Dc261C2fcE0
97 VEBOOST_PROXY: constant(address) = 0x8E0c00ed546602fD9927DF742bbAbF726D5B0d16
98 VOTING_ESCROW: constant(address) = 0x5f3b5DfEb7B28CDbD7FAba78963EE202a494e2A2
99 
100 
101 # ERC20
102 balanceOf: public(HashMap[address, uint256])
103 totalSupply: public(uint256)
104 allowance: public(HashMap[address, HashMap[address, uint256]])
105 
106 name: public(String[64])
107 symbol: public(String[40])
108 
109 # ERC2612
110 DOMAIN_SEPARATOR: public(bytes32)
111 nonces: public(HashMap[address, uint256])
112 
113 # Gauge
114 factory: public(address)
115 lp_token: public(address)
116 
117 is_killed: public(bool)
118 
119 # [future_epoch_time uint40][inflation_rate uint216]
120 inflation_params: uint256
121 
122 # For tracking external rewards
123 reward_count: public(uint256)
124 reward_data: public(HashMap[address, Reward])
125 
126 # claimant -> default reward receiver
127 rewards_receiver: public(HashMap[address, address])
128 
129 # reward token -> claiming address -> integral
130 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
131 
132 # user -> [uint128 claimable amount][uint128 claimed amount]
133 claim_data: HashMap[address, HashMap[address, uint256]]
134 
135 working_balances: public(HashMap[address, uint256])
136 working_supply: public(uint256)
137 
138 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
139 integrate_inv_supply_of: public(HashMap[address, uint256])
140 integrate_checkpoint_of: public(HashMap[address, uint256])
141 
142 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
143 # Units: rate * t = already number of coins per address to issue
144 integrate_fraction: public(HashMap[address, uint256])
145 
146 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
147 # All values are kept in units of being multiplied by 1e18
148 period: public(int128)
149 
150 # array of reward tokens
151 reward_tokens: public(address[MAX_REWARDS])
152 
153 period_timestamp: public(uint256[100000000000000000000000000000])
154 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
155 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
156 
157 
158 @external
159 def __init__():
160     # prevent initialization of implementation
161     self.lp_token = 0x000000000000000000000000000000000000dEaD
162 
163 
164 # Internal Functions
165 
166 
167 @internal
168 def _checkpoint(addr: address):
169     """
170     @notice Checkpoint for a user
171     @dev Updates the CRV emissions a user is entitled to receive
172     @param addr User address
173     """
174     _period: int128 = self.period
175     _period_time: uint256 = self.period_timestamp[_period]
176     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
177 
178     inflation_params: uint256 = self.inflation_params
179     rate: uint256 = inflation_params % 2 ** 216
180     prev_future_epoch: uint256 = shift(inflation_params, -216)
181     new_rate: uint256 = rate
182 
183     if prev_future_epoch >= _period_time:
184         new_rate = CRV20(CRV).rate()
185         self.inflation_params = shift(CRV20(CRV).future_epoch_time_write(), 216) + new_rate
186 
187     if self.is_killed:
188         # Stop distributing inflation as soon as killed
189         rate = 0
190         new_rate = 0  # prevent distribution when crossing epochs
191 
192     # Update integral of 1/supply
193     if block.timestamp > _period_time:
194         _working_supply: uint256 = self.working_supply
195         Controller(GAUGE_CONTROLLER).checkpoint_gauge(self)
196         prev_week_time: uint256 = _period_time
197         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
198 
199         for i in range(500):
200             dt: uint256 = week_time - prev_week_time
201             w: uint256 = Controller(GAUGE_CONTROLLER).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
202 
203             if _working_supply > 0:
204                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
205                     # If we went across one or multiple epochs, apply the rate
206                     # of the first epoch until it ends, and then the rate of
207                     # the last epoch.
208                     # If more than one epoch is crossed - the gauge gets less,
209                     # but that'd meen it wasn't called for more than 1 year
210                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
211                     rate = new_rate
212                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
213                 else:
214                     _integrate_inv_supply += rate * w * dt / _working_supply
215                 # On precisions of the calculation
216                 # rate ~= 10e18
217                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
218                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
219                 # The largest loss is at dt = 1
220                 # Loss is 1e-9 - acceptable
221 
222             if week_time == block.timestamp:
223                 break
224             prev_week_time = week_time
225             week_time = min(week_time + WEEK, block.timestamp)
226 
227     _period += 1
228     self.period = _period
229     self.period_timestamp[_period] = block.timestamp
230     self.integrate_inv_supply[_period] = _integrate_inv_supply
231 
232     # Update user-specific integrals
233     _working_balance: uint256 = self.working_balances[addr]
234     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
235     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
236     self.integrate_checkpoint_of[addr] = block.timestamp
237 
238 
239 @internal
240 def _checkpoint_rewards(_user: address, _total_supply: uint256, _claim: bool, _receiver: address):
241     """
242     @notice Claim pending rewards and checkpoint rewards for a user
243     """
244     user_balance: uint256 = 0
245     receiver: address = _receiver
246     if _user != ZERO_ADDRESS:
247         user_balance = self.balanceOf[_user]
248         if _claim and _receiver == ZERO_ADDRESS:
249             # if receiver is not explicitly declared, check if a default receiver is set
250             receiver = self.rewards_receiver[_user]
251             if receiver == ZERO_ADDRESS:
252                 # if no default receiver is set, direct claims to the user
253                 receiver = _user
254 
255     reward_count: uint256 = self.reward_count
256     for i in range(MAX_REWARDS):
257         if i == reward_count:
258             break
259         token: address = self.reward_tokens[i]
260 
261         integral: uint256 = self.reward_data[token].integral
262         last_update: uint256 = min(block.timestamp, self.reward_data[token].period_finish)
263         duration: uint256 = last_update - self.reward_data[token].last_update
264         if duration != 0:
265             self.reward_data[token].last_update = last_update
266             if _total_supply != 0:
267                 integral += duration * self.reward_data[token].rate * 10**18 / _total_supply
268                 self.reward_data[token].integral = integral
269 
270         if _user != ZERO_ADDRESS:
271             integral_for: uint256 = self.reward_integral_for[token][_user]
272             new_claimable: uint256 = 0
273 
274             if integral_for < integral:
275                 self.reward_integral_for[token][_user] = integral
276                 new_claimable = user_balance * (integral - integral_for) / 10**18
277 
278             claim_data: uint256 = self.claim_data[_user][token]
279             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
280             if total_claimable > 0:
281                 total_claimed: uint256 = claim_data % 2**128
282                 if _claim:
283                     response: Bytes[32] = raw_call(
284                         token,
285                         _abi_encode(
286                             receiver,
287                             total_claimable,
288                             method_id=method_id("transfer(address,uint256)")
289                         ),
290                         max_outsize=32,
291                     )
292                     if len(response) != 0:
293                         assert convert(response, bool)
294                     self.claim_data[_user][token] = total_claimed + total_claimable
295                 elif new_claimable > 0:
296                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
297 
298 
299 @internal
300 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
301     """
302     @notice Calculate limits which depend on the amount of CRV token per-user.
303             Effectively it calculates working balances to apply amplification
304             of CRV production by CRV
305     @param addr User address
306     @param l User's amount of liquidity (LP tokens)
307     @param L Total amount of liquidity (LP tokens)
308     """
309     # To be called after totalSupply is updated
310     voting_balance: uint256 = VotingEscrowBoost(VEBOOST_PROXY).adjusted_balance_of(addr)
311     voting_total: uint256 = ERC20(VOTING_ESCROW).totalSupply()
312 
313     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
314     if voting_total > 0:
315         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
316 
317     lim = min(l, lim)
318     old_bal: uint256 = self.working_balances[addr]
319     self.working_balances[addr] = lim
320     _working_supply: uint256 = self.working_supply + lim - old_bal
321     self.working_supply = _working_supply
322 
323     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
324 
325 
326 @internal
327 def _transfer(_from: address, _to: address, _value: uint256):
328     """
329     @notice Transfer tokens as well as checkpoint users
330     """
331     self._checkpoint(_from)
332     self._checkpoint(_to)
333 
334     if _value != 0:
335         total_supply: uint256 = self.totalSupply
336         is_rewards: bool = self.reward_count != 0
337         if is_rewards:
338             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
339         new_balance: uint256 = self.balanceOf[_from] - _value
340         self.balanceOf[_from] = new_balance
341         self._update_liquidity_limit(_from, new_balance, total_supply)
342 
343         if is_rewards:
344             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
345         new_balance = self.balanceOf[_to] + _value
346         self.balanceOf[_to] = new_balance
347         self._update_liquidity_limit(_to, new_balance, total_supply)
348 
349     log Transfer(_from, _to, _value)
350 
351 
352 # External User Facing Functions
353 
354 
355 @external
356 @nonreentrant('lock')
357 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
358     """
359     @notice Deposit `_value` LP tokens
360     @dev Depositting also claims pending reward tokens
361     @param _value Number of tokens to deposit
362     @param _addr Address to deposit for
363     """
364 
365     self._checkpoint(_addr)
366 
367     if _value != 0:
368         is_rewards: bool = self.reward_count != 0
369         total_supply: uint256 = self.totalSupply
370         if is_rewards:
371             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
372 
373         total_supply += _value
374         new_balance: uint256 = self.balanceOf[_addr] + _value
375         self.balanceOf[_addr] = new_balance
376         self.totalSupply = total_supply
377 
378         self._update_liquidity_limit(_addr, new_balance, total_supply)
379 
380         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
381 
382     log Deposit(_addr, _value)
383     log Transfer(ZERO_ADDRESS, _addr, _value)
384 
385 
386 @external
387 @nonreentrant('lock')
388 def withdraw(_value: uint256, _claim_rewards: bool = False):
389     """
390     @notice Withdraw `_value` LP tokens
391     @dev Withdrawing also claims pending reward tokens
392     @param _value Number of tokens to withdraw
393     """
394     self._checkpoint(msg.sender)
395 
396     if _value != 0:
397         is_rewards: bool = self.reward_count != 0
398         total_supply: uint256 = self.totalSupply
399         if is_rewards:
400             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
401 
402         total_supply -= _value
403         new_balance: uint256 = self.balanceOf[msg.sender] - _value
404         self.balanceOf[msg.sender] = new_balance
405         self.totalSupply = total_supply
406 
407         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
408 
409         ERC20(self.lp_token).transfer(msg.sender, _value)
410 
411     log Withdraw(msg.sender, _value)
412     log Transfer(msg.sender, ZERO_ADDRESS, _value)
413 
414 
415 @external
416 @nonreentrant('lock')
417 def claim_rewards(_addr: address = msg.sender, _receiver: address = ZERO_ADDRESS):
418     """
419     @notice Claim available reward tokens for `_addr`
420     @param _addr Address to claim for
421     @param _receiver Address to transfer rewards to - if set to
422                      ZERO_ADDRESS, uses the default reward receiver
423                      for the caller
424     """
425     if _receiver != ZERO_ADDRESS:
426         assert _addr == msg.sender  # dev: cannot redirect when claiming for another user
427     self._checkpoint_rewards(_addr, self.totalSupply, True, _receiver)
428 
429 
430 @external
431 @nonreentrant('lock')
432 def transferFrom(_from: address, _to :address, _value: uint256) -> bool:
433     """
434      @notice Transfer tokens from one address to another.
435      @dev Transferring claims pending reward tokens for the sender and receiver
436      @param _from address The address which you want to send tokens from
437      @param _to address The address which you want to transfer to
438      @param _value uint256 the amount of tokens to be transferred
439     """
440     _allowance: uint256 = self.allowance[_from][msg.sender]
441     if _allowance != MAX_UINT256:
442         self.allowance[_from][msg.sender] = _allowance - _value
443 
444     self._transfer(_from, _to, _value)
445 
446     return True
447 
448 
449 @external
450 @nonreentrant('lock')
451 def transfer(_to: address, _value: uint256) -> bool:
452     """
453     @notice Transfer token for a specified address
454     @dev Transferring claims pending reward tokens for the sender and receiver
455     @param _to The address to transfer to.
456     @param _value The amount to be transferred.
457     """
458     self._transfer(msg.sender, _to, _value)
459 
460     return True
461 
462 
463 @external
464 def approve(_spender : address, _value : uint256) -> bool:
465     """
466     @notice Approve the passed address to transfer the specified amount of
467             tokens on behalf of msg.sender
468     @dev Beware that changing an allowance via this method brings the risk
469          that someone may use both the old and new allowance by unfortunate
470          transaction ordering. This may be mitigated with the use of
471          {incraseAllowance} and {decreaseAllowance}.
472          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
473     @param _spender The address which will transfer the funds
474     @param _value The amount of tokens that may be transferred
475     @return bool success
476     """
477     self.allowance[msg.sender][_spender] = _value
478     log Approval(msg.sender, _spender, _value)
479 
480     return True
481 
482 
483 @external
484 def permit(
485     _owner: address,
486     _spender: address,
487     _value: uint256,
488     _deadline: uint256,
489     _v: uint8,
490     _r: bytes32,
491     _s: bytes32
492 ) -> bool:
493     """
494     @notice Approves spender by owner's signature to expend owner's tokens.
495         See https://eips.ethereum.org/EIPS/eip-2612.
496     @dev Inspired by https://github.com/yearn/yearn-vaults/blob/main/contracts/Vault.vy#L753-L793
497     @dev Supports smart contract wallets which implement ERC1271
498         https://eips.ethereum.org/EIPS/eip-1271
499     @param _owner The address which is a source of funds and has signed the Permit.
500     @param _spender The address which is allowed to spend the funds.
501     @param _value The amount of tokens to be spent.
502     @param _deadline The timestamp after which the Permit is no longer valid.
503     @param _v The bytes[64] of the valid secp256k1 signature of permit by owner
504     @param _r The bytes[0:32] of the valid secp256k1 signature of permit by owner
505     @param _s The bytes[32:64] of the valid secp256k1 signature of permit by owner
506     @return True, if transaction completes successfully
507     """
508     assert _owner != ZERO_ADDRESS
509     assert block.timestamp <= _deadline
510 
511     nonce: uint256 = self.nonces[_owner]
512     digest: bytes32 = keccak256(
513         concat(
514             b"\x19\x01",
515             self.DOMAIN_SEPARATOR,
516             keccak256(_abi_encode(PERMIT_TYPEHASH, _owner, _spender, _value, nonce, _deadline))
517         )
518     )
519 
520     if _owner.is_contract:
521         sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
522         # reentrancy not a concern since this is a staticcall
523         assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
524     else:
525         assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
526 
527     self.allowance[_owner][_spender] = _value
528     self.nonces[_owner] = nonce + 1
529 
530     log Approval(_owner, _spender, _value)
531     return True
532 
533 
534 @external
535 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
536     """
537     @notice Increase the allowance granted to `_spender` by the caller
538     @dev This is alternative to {approve} that can be used as a mitigation for
539          the potential race condition
540     @param _spender The address which will transfer the funds
541     @param _added_value The amount of to increase the allowance
542     @return bool success
543     """
544     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
545     self.allowance[msg.sender][_spender] = allowance
546 
547     log Approval(msg.sender, _spender, allowance)
548 
549     return True
550 
551 
552 @external
553 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
554     """
555     @notice Decrease the allowance granted to `_spender` by the caller
556     @dev This is alternative to {approve} that can be used as a mitigation for
557          the potential race condition
558     @param _spender The address which will transfer the funds
559     @param _subtracted_value The amount of to decrease the allowance
560     @return bool success
561     """
562     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
563     self.allowance[msg.sender][_spender] = allowance
564 
565     log Approval(msg.sender, _spender, allowance)
566 
567     return True
568 
569 
570 @external
571 def user_checkpoint(addr: address) -> bool:
572     """
573     @notice Record a checkpoint for `addr`
574     @param addr User address
575     @return bool success
576     """
577     assert msg.sender in [addr, MINTER]  # dev: unauthorized
578     self._checkpoint(addr)
579     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
580     return True
581 
582 
583 @external
584 def set_rewards_receiver(_receiver: address):
585     """
586     @notice Set the default reward receiver for the caller.
587     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
588     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
589     """
590     self.rewards_receiver[msg.sender] = _receiver
591 
592 
593 @external
594 def kick(addr: address):
595     """
596     @notice Kick `addr` for abusing their boost
597     @dev Only if either they had another voting event, or their voting escrow lock expired
598     @param addr Address to kick
599     """
600     t_last: uint256 = self.integrate_checkpoint_of[addr]
601     t_ve: uint256 = VotingEscrow(VOTING_ESCROW).user_point_history__ts(
602         addr, VotingEscrow(VOTING_ESCROW).user_point_epoch(addr)
603     )
604     _balance: uint256 = self.balanceOf[addr]
605 
606     assert ERC20(VOTING_ESCROW).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
607     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
608 
609     self._checkpoint(addr)
610     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
611 
612 
613 # Administrative Functions
614 
615 
616 @external
617 @nonreentrant("lock")
618 def deposit_reward_token(_reward_token: address, _amount: uint256):
619     """
620     @notice Deposit a reward token for distribution
621     @param _reward_token The reward token being deposited
622     @param _amount The amount of `_reward_token` being deposited
623     """
624     assert msg.sender == self.reward_data[_reward_token].distributor
625 
626     self._checkpoint_rewards(ZERO_ADDRESS, self.totalSupply, False, ZERO_ADDRESS)
627 
628     response: Bytes[32] = raw_call(
629         _reward_token,
630         _abi_encode(
631             msg.sender, self, _amount, method_id=method_id("transferFrom(address,address,uint256)")
632         ),
633         max_outsize=32,
634     )
635     if len(response) != 0:
636         assert convert(response, bool)
637 
638     period_finish: uint256 = self.reward_data[_reward_token].period_finish
639     if block.timestamp >= period_finish:
640         self.reward_data[_reward_token].rate = _amount / WEEK
641     else:
642         remaining: uint256 = period_finish - block.timestamp
643         leftover: uint256 = remaining * self.reward_data[_reward_token].rate
644         self.reward_data[_reward_token].rate = (_amount + leftover) / WEEK
645 
646     self.reward_data[_reward_token].last_update = block.timestamp
647     self.reward_data[_reward_token].period_finish = block.timestamp + WEEK
648 
649 
650 @external
651 def add_reward(_reward_token: address, _distributor: address):
652     """
653     @notice Add additional rewards to be distributed to stakers
654     @param _reward_token The token to add as an additional reward
655     @param _distributor Address permitted to fund this contract with the reward token
656     """
657     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
658 
659     reward_count: uint256 = self.reward_count
660     assert reward_count < MAX_REWARDS
661     assert self.reward_data[_reward_token].distributor == ZERO_ADDRESS
662 
663     self.reward_data[_reward_token].distributor = _distributor
664     self.reward_tokens[reward_count] = _reward_token
665     self.reward_count = reward_count + 1
666 
667 
668 @external
669 def set_reward_distributor(_reward_token: address, _distributor: address):
670     """
671     @notice Reassign the reward distributor for a reward token
672     @param _reward_token The reward token to reassign distribution rights to
673     @param _distributor The address of the new distributor
674     """
675     current_distributor: address = self.reward_data[_reward_token].distributor
676 
677     assert msg.sender == current_distributor or msg.sender == Factory(self.factory).admin()
678     assert current_distributor != ZERO_ADDRESS
679     assert _distributor != ZERO_ADDRESS
680 
681     self.reward_data[_reward_token].distributor = _distributor
682 
683 
684 @external
685 def set_killed(_is_killed: bool):
686     """
687     @notice Set the killed status for this contract
688     @dev When killed, the gauge always yields a rate of 0 and so cannot mint CRV
689     @param _is_killed Killed status to set
690     """
691     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
692 
693     self.is_killed = _is_killed
694 
695 
696 # View Methods
697 
698 
699 @view
700 @external
701 def claimed_reward(_addr: address, _token: address) -> uint256:
702     """
703     @notice Get the number of already-claimed reward tokens for a user
704     @param _addr Account to get reward amount for
705     @param _token Token to get reward amount for
706     @return uint256 Total amount of `_token` already claimed by `_addr`
707     """
708     return self.claim_data[_addr][_token] % 2**128
709 
710 
711 @view
712 @external
713 def claimable_reward(_user: address, _reward_token: address) -> uint256:
714     """
715     @notice Get the number of claimable reward tokens for a user
716     @param _user Account to get reward amount for
717     @param _reward_token Token to get reward amount for
718     @return uint256 Claimable reward token amount
719     """
720     integral: uint256 = self.reward_data[_reward_token].integral
721     total_supply: uint256 = self.totalSupply
722     if total_supply != 0:
723         last_update: uint256 = min(block.timestamp, self.reward_data[_reward_token].period_finish)
724         duration: uint256 = last_update - self.reward_data[_reward_token].last_update
725         integral += (duration * self.reward_data[_reward_token].rate * 10**18 / total_supply)
726 
727     integral_for: uint256 = self.reward_integral_for[_reward_token][_user]
728     new_claimable: uint256 = self.balanceOf[_user] * (integral - integral_for) / 10**18
729 
730     return shift(self.claim_data[_user][_reward_token], -128) + new_claimable
731 
732 
733 @external
734 def claimable_tokens(addr: address) -> uint256:
735     """
736     @notice Get the number of claimable tokens per user
737     @dev This function should be manually changed to "view" in the ABI
738     @return uint256 number of claimable tokens per user
739     """
740     self._checkpoint(addr)
741     return self.integrate_fraction[addr] - Minter(MINTER).minted(addr, self)
742 
743 
744 @view
745 @external
746 def integrate_checkpoint() -> uint256:
747     """
748     @notice Get the timestamp of the last checkpoint
749     """
750     return self.period_timestamp[self.period]
751 
752 
753 @view
754 @external
755 def future_epoch_time() -> uint256:
756     """
757     @notice Get the locally stored CRV future epoch start time
758     """
759     return shift(self.inflation_params, -216)
760 
761 
762 @view
763 @external
764 def inflation_rate() -> uint256:
765     """
766     @notice Get the locally stored CRV inflation rate
767     """
768     return self.inflation_params % 2 ** 216
769 
770 
771 @view
772 @external
773 def decimals() -> uint256:
774     """
775     @notice Get the number of decimals for this token
776     @dev Implemented as a view method to reduce gas costs
777     @return uint256 decimal places
778     """
779     return 18
780 
781 
782 @view
783 @external
784 def version() -> String[8]:
785     """
786     @notice Get the version of this gauge contract
787     """
788     return VERSION
789 
790 
791 # Initializer
792 
793 
794 @external
795 def initialize(_lp_token: address):
796     """
797     @notice Contract constructor
798     @param _lp_token Liquidity Pool contract address
799     """
800     assert self.lp_token == ZERO_ADDRESS
801 
802     self.lp_token = _lp_token
803     self.factory = msg.sender
804 
805     symbol: String[32] = ERC20Extended(_lp_token).symbol()
806     name: String[64] = concat("Curve.fi ", symbol, " Gauge Deposit")
807 
808     self.name = name
809     self.symbol = concat(symbol, "-gauge")
810 
811     self.DOMAIN_SEPARATOR = keccak256(
812         _abi_encode(EIP712_TYPEHASH, keccak256(name), keccak256(VERSION), chain.id, self)
813     )
814 
815     self.period_timestamp[0] = block.timestamp
816     self.inflation_params = shift(CRV20(CRV).future_epoch_time_write(), 216) + CRV20(CRV).rate()