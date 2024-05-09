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
13 interface TokenAdmin:
14     def getVault() -> address: view
15     def future_epoch_time_write() -> uint256: nonpayable
16     def rate() -> uint256: view
17 
18 interface Controller:
19     def voting_escrow() -> address: view
20     def checkpoint_gauge(addr: address): nonpayable
21     def gauge_relative_weight(addr: address, time: uint256) -> uint256: view
22 
23 interface ERC20Extended:
24     def symbol() -> String[32]: view
25 
26 interface ERC1271:
27     def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view
28 
29 interface Minter:
30     def getBalancerTokenAdmin() -> address: view
31     def getGaugeController() -> address: view
32     def minted(user: address, gauge: address) -> uint256: view
33 
34 interface VotingEscrow:
35     def user_point_epoch(addr: address) -> uint256: view
36     def user_point_history__ts(addr: address, epoch: uint256) -> uint256: view
37 
38 interface VotingEscrowBoost:
39     def adjusted_balance_of(_account: address) -> uint256: view
40 
41 
42 event Deposit:
43     provider: indexed(address)
44     value: uint256
45 
46 event Withdraw:
47     provider: indexed(address)
48     value: uint256
49 
50 event UpdateLiquidityLimit:
51     user: indexed(address)
52     original_balance: uint256
53     original_supply: uint256
54     working_balance: uint256
55     working_supply: uint256
56 
57 event Transfer:
58     _from: indexed(address)
59     _to: indexed(address)
60     _value: uint256
61 
62 event Approval:
63     _owner: indexed(address)
64     _spender: indexed(address)
65     _value: uint256
66 
67 event RewardDistributorUpdated:
68     reward_token: indexed(address)
69     distributor: address
70 
71 struct Reward:
72     token: address
73     distributor: address
74     period_finish: uint256
75     rate: uint256
76     last_update: uint256
77     integral: uint256
78 
79 
80 CLAIM_FREQUENCY: constant(uint256) = 3600
81 MAX_REWARDS: constant(uint256) = 8
82 TOKENLESS_PRODUCTION: constant(uint256) = 40
83 WEEK: constant(uint256) = 604800
84 
85 # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
86 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
87 VERSION: constant(String[8]) = "v5.0.0"
88 
89 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
90 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
91 
92 BAL_TOKEN_ADMIN: immutable(address)
93 BAL_VAULT: immutable(address)
94 AUTHORIZER_ADAPTOR: immutable(address)
95 GAUGE_CONTROLLER: immutable(address)
96 MINTER: immutable(address)
97 VOTING_ESCROW: immutable(address)
98 VEBOOST_PROXY: immutable(address)
99 
100 
101 # ERC20
102 balanceOf: public(HashMap[address, uint256])
103 totalSupply: public(uint256)
104 _allowance: HashMap[address, HashMap[address, uint256]]
105 
106 name: public(String[64])
107 symbol: public(String[40])
108 
109 # ERC2612
110 DOMAIN_SEPARATOR: public(bytes32)
111 nonces: public(HashMap[address, uint256])
112 
113 # Gauge
114 lp_token: public(address)
115 
116 is_killed: public(bool)
117 
118 # [future_epoch_time uint40][inflation_rate uint216]
119 inflation_params: uint256
120 
121 # For tracking external rewards
122 reward_count: public(uint256)
123 reward_data: public(HashMap[address, Reward])
124 
125 # claimant -> default reward receiver
126 rewards_receiver: public(HashMap[address, address])
127 
128 # reward token -> claiming address -> integral
129 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
130 
131 # user -> [uint128 claimable amount][uint128 claimed amount]
132 claim_data: HashMap[address, HashMap[address, uint256]]
133 
134 working_balances: public(HashMap[address, uint256])
135 working_supply: public(uint256)
136 
137 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
138 integrate_inv_supply_of: public(HashMap[address, uint256])
139 integrate_checkpoint_of: public(HashMap[address, uint256])
140 
141 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
142 # Units: rate * t = already number of coins per address to issue
143 integrate_fraction: public(HashMap[address, uint256])
144 
145 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
146 # All values are kept in units of being multiplied by 1e18
147 period: public(int128)
148 
149 # array of reward tokens
150 reward_tokens: public(address[MAX_REWARDS])
151 
152 period_timestamp: public(uint256[100000000000000000000000000000])
153 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
154 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
155 
156 
157 @external
158 def __init__(minter: address, veBoostProxy: address, authorizerAdaptor: address):
159     """
160     @param minter Address of minter contract
161     @param veBoostProxy Address of boost delegation contract
162     """
163     gaugeController: address = Minter(minter).getGaugeController()
164     balTokenAdmin: address = Minter(minter).getBalancerTokenAdmin()
165     BAL_TOKEN_ADMIN = balTokenAdmin
166     BAL_VAULT = TokenAdmin(balTokenAdmin).getVault()
167     AUTHORIZER_ADAPTOR = authorizerAdaptor
168     GAUGE_CONTROLLER = gaugeController
169     MINTER = minter
170     VOTING_ESCROW = Controller(gaugeController).voting_escrow()
171     VEBOOST_PROXY = veBoostProxy
172     # prevent initialization of implementation
173     self.lp_token = 0x000000000000000000000000000000000000dEaD
174 
175 
176 # Internal Functions
177 
178 @view
179 @internal
180 def _get_allowance(owner: address, spender: address) -> uint256:
181     """
182      @dev Override to grant the Vault infinite allowance, causing for Gauge Tokens to not require approval.
183      This is sound as the Vault already provides authorization mechanisms when initiating token transfers, which this
184      contract inherits.
185     """
186     if (spender == BAL_VAULT):
187         return MAX_UINT256
188     return self._allowance[owner][spender]
189 
190 @internal
191 def _checkpoint(addr: address):
192     """
193     @notice Checkpoint for a user
194     @dev Updates the BAL emissions a user is entitled to receive
195     @param addr User address
196     """
197     _period: int128 = self.period
198     _period_time: uint256 = self.period_timestamp[_period]
199     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
200 
201     inflation_params: uint256 = self.inflation_params
202     rate: uint256 = inflation_params % 2 ** 216
203     prev_future_epoch: uint256 = shift(inflation_params, -216)
204     new_rate: uint256 = rate
205 
206     if prev_future_epoch >= _period_time:
207         new_rate = TokenAdmin(BAL_TOKEN_ADMIN).rate()
208         self.inflation_params = shift(TokenAdmin(BAL_TOKEN_ADMIN).future_epoch_time_write(), 216) + new_rate
209 
210     if self.is_killed:
211         # Stop distributing inflation as soon as killed
212         rate = 0
213         new_rate = 0  # prevent distribution when crossing epochs
214 
215     # Update integral of 1/supply
216     if block.timestamp > _period_time:
217         _working_supply: uint256 = self.working_supply
218         Controller(GAUGE_CONTROLLER).checkpoint_gauge(self)
219         prev_week_time: uint256 = _period_time
220         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
221 
222         for i in range(500):
223             dt: uint256 = week_time - prev_week_time
224             w: uint256 = Controller(GAUGE_CONTROLLER).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
225 
226             if _working_supply > 0:
227                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
228                     # If we went across one or multiple epochs, apply the rate
229                     # of the first epoch until it ends, and then the rate of
230                     # the last epoch.
231                     # If more than one epoch is crossed - the gauge gets less,
232                     # but that'd meen it wasn't called for more than 1 year
233                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
234                     rate = new_rate
235                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
236                 else:
237                     _integrate_inv_supply += rate * w * dt / _working_supply
238                 # On precisions of the calculation
239                 # rate ~= 10e18
240                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
241                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
242                 # The largest loss is at dt = 1
243                 # Loss is 1e-9 - acceptable
244 
245             if week_time == block.timestamp:
246                 break
247             prev_week_time = week_time
248             week_time = min(week_time + WEEK, block.timestamp)
249 
250     _period += 1
251     self.period = _period
252     self.period_timestamp[_period] = block.timestamp
253     self.integrate_inv_supply[_period] = _integrate_inv_supply
254 
255     # Update user-specific integrals
256     _working_balance: uint256 = self.working_balances[addr]
257     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
258     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
259     self.integrate_checkpoint_of[addr] = block.timestamp
260 
261 
262 @internal
263 def _checkpoint_rewards(_user: address, _total_supply: uint256, _claim: bool, _receiver: address):
264     """
265     @notice Claim pending rewards and checkpoint rewards for a user
266     """
267     user_balance: uint256 = 0
268     receiver: address = _receiver
269     if _user != ZERO_ADDRESS:
270         user_balance = self.balanceOf[_user]
271         if _claim and _receiver == ZERO_ADDRESS:
272             # if receiver is not explicitly declared, check if a default receiver is set
273             receiver = self.rewards_receiver[_user]
274             if receiver == ZERO_ADDRESS:
275                 # if no default receiver is set, direct claims to the user
276                 receiver = _user
277 
278     reward_count: uint256 = self.reward_count
279     for i in range(MAX_REWARDS):
280         if i == reward_count:
281             break
282         token: address = self.reward_tokens[i]
283 
284         integral: uint256 = self.reward_data[token].integral
285         last_update: uint256 = min(block.timestamp, self.reward_data[token].period_finish)
286         duration: uint256 = last_update - self.reward_data[token].last_update
287         if duration != 0:
288             self.reward_data[token].last_update = last_update
289             if _total_supply != 0:
290                 integral += duration * self.reward_data[token].rate * 10**18 / _total_supply
291                 self.reward_data[token].integral = integral
292 
293         if _user != ZERO_ADDRESS:
294             integral_for: uint256 = self.reward_integral_for[token][_user]
295             new_claimable: uint256 = 0
296 
297             if integral_for < integral:
298                 self.reward_integral_for[token][_user] = integral
299                 new_claimable = user_balance * (integral - integral_for) / 10**18
300 
301             claim_data: uint256 = self.claim_data[_user][token]
302             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
303             if total_claimable > 0:
304                 total_claimed: uint256 = claim_data % 2**128
305                 if _claim:
306                     response: Bytes[32] = raw_call(
307                         token,
308                         _abi_encode(
309                             receiver,
310                             total_claimable,
311                             method_id=method_id("transfer(address,uint256)")
312                         ),
313                         max_outsize=32,
314                     )
315                     if len(response) != 0:
316                         assert convert(response, bool)
317                     self.claim_data[_user][token] = total_claimed + total_claimable
318                 elif new_claimable > 0:
319                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
320 
321 
322 @internal
323 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
324     """
325     @notice Calculate limits which depend on the amount of BPT token per-user.
326             Effectively it calculates working balances to apply amplification
327             of BAL production by BPT
328     @param addr User address
329     @param l User's amount of liquidity (LP tokens)
330     @param L Total amount of liquidity (LP tokens)
331     """
332     # To be called after totalSupply is updated
333     voting_balance: uint256 = VotingEscrowBoost(VEBOOST_PROXY).adjusted_balance_of(addr)
334     voting_total: uint256 = ERC20(VOTING_ESCROW).totalSupply()
335 
336     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
337     if voting_total > 0:
338         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
339 
340     lim = min(l, lim)
341     old_bal: uint256 = self.working_balances[addr]
342     self.working_balances[addr] = lim
343     _working_supply: uint256 = self.working_supply + lim - old_bal
344     self.working_supply = _working_supply
345 
346     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
347 
348 
349 @internal
350 def _transfer(_from: address, _to: address, _value: uint256):
351     """
352     @notice Transfer tokens as well as checkpoint users
353     """
354     self._checkpoint(_from)
355     self._checkpoint(_to)
356 
357     if _value != 0:
358         total_supply: uint256 = self.totalSupply
359         is_rewards: bool = self.reward_count != 0
360         if is_rewards:
361             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
362         new_balance: uint256 = self.balanceOf[_from] - _value
363         self.balanceOf[_from] = new_balance
364         self._update_liquidity_limit(_from, new_balance, total_supply)
365 
366         if is_rewards:
367             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
368         new_balance = self.balanceOf[_to] + _value
369         self.balanceOf[_to] = new_balance
370         self._update_liquidity_limit(_to, new_balance, total_supply)
371 
372     log Transfer(_from, _to, _value)
373 
374 
375 # External User Facing Functions
376 
377 
378 @external
379 @nonreentrant('lock')
380 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
381     """
382     @notice Deposit `_value` LP tokens
383     @dev Depositting also claims pending reward tokens
384     @param _value Number of tokens to deposit
385     @param _addr Address to deposit for
386     """
387 
388     self._checkpoint(_addr)
389 
390     if _value != 0:
391         is_rewards: bool = self.reward_count != 0
392         total_supply: uint256 = self.totalSupply
393         if is_rewards:
394             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
395 
396         total_supply += _value
397         new_balance: uint256 = self.balanceOf[_addr] + _value
398         self.balanceOf[_addr] = new_balance
399         self.totalSupply = total_supply
400 
401         self._update_liquidity_limit(_addr, new_balance, total_supply)
402 
403         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
404 
405     log Deposit(_addr, _value)
406     log Transfer(ZERO_ADDRESS, _addr, _value)
407 
408 
409 @external
410 @nonreentrant('lock')
411 def withdraw(_value: uint256, _claim_rewards: bool = False):
412     """
413     @notice Withdraw `_value` LP tokens
414     @dev Withdrawing also claims pending reward tokens
415     @param _value Number of tokens to withdraw
416     """
417     self._checkpoint(msg.sender)
418 
419     if _value != 0:
420         is_rewards: bool = self.reward_count != 0
421         total_supply: uint256 = self.totalSupply
422         if is_rewards:
423             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
424 
425         total_supply -= _value
426         new_balance: uint256 = self.balanceOf[msg.sender] - _value
427         self.balanceOf[msg.sender] = new_balance
428         self.totalSupply = total_supply
429 
430         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
431 
432         ERC20(self.lp_token).transfer(msg.sender, _value)
433 
434     log Withdraw(msg.sender, _value)
435     log Transfer(msg.sender, ZERO_ADDRESS, _value)
436 
437 
438 @external
439 @nonreentrant('lock')
440 def claim_rewards(_addr: address = msg.sender, _receiver: address = ZERO_ADDRESS):
441     """
442     @notice Claim available reward tokens for `_addr`
443     @param _addr Address to claim for
444     @param _receiver Address to transfer rewards to - if set to
445                      ZERO_ADDRESS, uses the default reward receiver
446                      for the caller
447     """
448     if _receiver != ZERO_ADDRESS:
449         assert _addr == msg.sender  # dev: cannot redirect when claiming for another user
450     self._checkpoint_rewards(_addr, self.totalSupply, True, _receiver)
451 
452 
453 @external
454 @nonreentrant('lock')
455 def transferFrom(_from: address, _to :address, _value: uint256) -> bool:
456     """
457      @notice Transfer tokens from one address to another.
458      @dev Transferring claims pending reward tokens for the sender and receiver
459      @param _from address The address which you want to send tokens from
460      @param _to address The address which you want to transfer to
461      @param _value uint256 the amount of tokens to be transferred
462     """
463     _allowance: uint256 = self._get_allowance(_from, msg.sender)
464     if _allowance != MAX_UINT256:
465         self._allowance[_from][msg.sender] = _allowance - _value
466 
467     self._transfer(_from, _to, _value)
468 
469     return True
470 
471 
472 @external
473 @nonreentrant('lock')
474 def transfer(_to: address, _value: uint256) -> bool:
475     """
476     @notice Transfer token for a specified address
477     @dev Transferring claims pending reward tokens for the sender and receiver
478     @param _to The address to transfer to.
479     @param _value The amount to be transferred.
480     """
481     self._transfer(msg.sender, _to, _value)
482 
483     return True
484 
485 
486 @external
487 def approve(_spender : address, _value : uint256) -> bool:
488     """
489     @notice Approve the passed address to transfer the specified amount of
490             tokens on behalf of msg.sender
491     @dev Beware that changing an allowance via this method brings the risk
492          that someone may use both the old and new allowance by unfortunate
493          transaction ordering. This may be mitigated with the use of
494          {incraseAllowance} and {decreaseAllowance}.
495          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
496     @param _spender The address which will transfer the funds
497     @param _value The amount of tokens that may be transferred
498     @return bool success
499     """
500     self._allowance[msg.sender][_spender] = _value
501     log Approval(msg.sender, _spender, _value)
502 
503     return True
504 
505 
506 @external
507 def permit(
508     _owner: address,
509     _spender: address,
510     _value: uint256,
511     _deadline: uint256,
512     _v: uint8,
513     _r: bytes32,
514     _s: bytes32
515 ) -> bool:
516     """
517     @notice Approves spender by owner's signature to expend owner's tokens.
518         See https://eips.ethereum.org/EIPS/eip-2612.
519     @dev Inspired by https://github.com/yearn/yearn-vaults/blob/main/contracts/Vault.vy#L753-L793
520     @dev Supports smart contract wallets which implement ERC1271
521         https://eips.ethereum.org/EIPS/eip-1271
522     @param _owner The address which is a source of funds and has signed the Permit.
523     @param _spender The address which is allowed to spend the funds.
524     @param _value The amount of tokens to be spent.
525     @param _deadline The timestamp after which the Permit is no longer valid.
526     @param _v The bytes[64] of the valid secp256k1 signature of permit by owner
527     @param _r The bytes[0:32] of the valid secp256k1 signature of permit by owner
528     @param _s The bytes[32:64] of the valid secp256k1 signature of permit by owner
529     @return True, if transaction completes successfully
530     """
531     assert _owner != ZERO_ADDRESS
532     assert block.timestamp <= _deadline
533 
534     nonce: uint256 = self.nonces[_owner]
535     digest: bytes32 = keccak256(
536         concat(
537             b"\x19\x01",
538             self.DOMAIN_SEPARATOR,
539             keccak256(_abi_encode(PERMIT_TYPEHASH, _owner, _spender, _value, nonce, _deadline))
540         )
541     )
542 
543     if _owner.is_contract:
544         sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
545         # reentrancy not a concern since this is a staticcall
546         assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
547     else:
548         assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
549 
550     self._allowance[_owner][_spender] = _value
551     self.nonces[_owner] = nonce + 1
552 
553     log Approval(_owner, _spender, _value)
554     return True
555 
556 
557 @external
558 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
559     """
560     @notice Increase the allowance granted to `_spender` by the caller
561     @dev This is alternative to {approve} that can be used as a mitigation for
562          the potential race condition
563     @param _spender The address which will transfer the funds
564     @param _added_value The amount of to increase the allowance
565     @return bool success
566     """
567     allowance: uint256 = self._get_allowance(msg.sender,_spender) + _added_value
568     self._allowance[msg.sender][_spender] = allowance
569 
570     log Approval(msg.sender, _spender, allowance)
571 
572     return True
573 
574 
575 @external
576 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
577     """
578     @notice Decrease the allowance granted to `_spender` by the caller
579     @dev This is alternative to {approve} that can be used as a mitigation for
580          the potential race condition
581     @param _spender The address which will transfer the funds
582     @param _subtracted_value The amount of to decrease the allowance
583     @return bool success
584     """
585     allowance: uint256 = self._get_allowance(msg.sender, _spender) - _subtracted_value
586     self._allowance[msg.sender][_spender] = allowance
587 
588     log Approval(msg.sender, _spender, allowance)
589 
590     return True
591 
592 
593 @external
594 def user_checkpoint(addr: address) -> bool:
595     """
596     @notice Record a checkpoint for `addr`
597     @param addr User address
598     @return bool success
599     """
600     assert msg.sender in [addr, MINTER]  # dev: unauthorized
601     self._checkpoint(addr)
602     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
603     return True
604 
605 
606 @external
607 def set_rewards_receiver(_receiver: address):
608     """
609     @notice Set the default reward receiver for the caller.
610     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
611     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
612     """
613     self.rewards_receiver[msg.sender] = _receiver
614 
615 
616 @external
617 def kick(addr: address):
618     """
619     @notice Kick `addr` for abusing their boost
620     @dev Only if either they had another voting event, or their voting escrow lock expired
621     @param addr Address to kick
622     """
623     t_last: uint256 = self.integrate_checkpoint_of[addr]
624     t_ve: uint256 = VotingEscrow(VOTING_ESCROW).user_point_history__ts(
625         addr, VotingEscrow(VOTING_ESCROW).user_point_epoch(addr)
626     )
627     _balance: uint256 = self.balanceOf[addr]
628 
629     assert ERC20(VOTING_ESCROW).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
630     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
631 
632     self._checkpoint(addr)
633     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
634 
635 
636 # Administrative Functions
637 
638 
639 @external
640 @nonreentrant("lock")
641 def deposit_reward_token(_reward_token: address, _amount: uint256):
642     """
643     @notice Deposit a reward token for distribution
644     @param _reward_token The reward token being deposited
645     @param _amount The amount of `_reward_token` being deposited
646     """
647     assert msg.sender == self.reward_data[_reward_token].distributor
648 
649     self._checkpoint_rewards(ZERO_ADDRESS, self.totalSupply, False, ZERO_ADDRESS)
650 
651     response: Bytes[32] = raw_call(
652         _reward_token,
653         _abi_encode(
654             msg.sender, self, _amount, method_id=method_id("transferFrom(address,address,uint256)")
655         ),
656         max_outsize=32,
657     )
658     if len(response) != 0:
659         assert convert(response, bool)
660 
661     period_finish: uint256 = self.reward_data[_reward_token].period_finish
662     if block.timestamp >= period_finish:
663         self.reward_data[_reward_token].rate = _amount / WEEK
664     else:
665         remaining: uint256 = period_finish - block.timestamp
666         leftover: uint256 = remaining * self.reward_data[_reward_token].rate
667         self.reward_data[_reward_token].rate = (_amount + leftover) / WEEK
668 
669     self.reward_data[_reward_token].last_update = block.timestamp
670     self.reward_data[_reward_token].period_finish = block.timestamp + WEEK
671 
672 
673 @external
674 def add_reward(_reward_token: address, _distributor: address):
675     """
676     @notice Add additional rewards to be distributed to stakers
677     @param _reward_token The token to add as an additional reward
678     @param _distributor Address permitted to fund this contract with the reward token
679     """
680     assert _distributor != ZERO_ADDRESS
681     assert msg.sender == AUTHORIZER_ADAPTOR  # dev: only owner
682 
683     reward_count: uint256 = self.reward_count
684     assert reward_count < MAX_REWARDS
685     assert self.reward_data[_reward_token].distributor == ZERO_ADDRESS
686 
687     self.reward_data[_reward_token].distributor = _distributor
688     self.reward_tokens[reward_count] = _reward_token
689     self.reward_count = reward_count + 1
690     log RewardDistributorUpdated(_reward_token, _distributor)
691 
692 
693 @external
694 def set_reward_distributor(_reward_token: address, _distributor: address):
695     """
696     @notice Reassign the reward distributor for a reward token
697     @param _reward_token The reward token to reassign distribution rights to
698     @param _distributor The address of the new distributor
699     """
700     current_distributor: address = self.reward_data[_reward_token].distributor
701 
702     assert msg.sender == current_distributor or msg.sender == AUTHORIZER_ADAPTOR
703     assert current_distributor != ZERO_ADDRESS
704     assert _distributor != ZERO_ADDRESS
705 
706     self.reward_data[_reward_token].distributor = _distributor
707     log RewardDistributorUpdated(_reward_token, _distributor)
708 
709 @external
710 def killGauge():
711     """
712     @notice Kills the gauge so it always yields a rate of 0 and so cannot mint BAL
713     """
714     assert msg.sender == AUTHORIZER_ADAPTOR  # dev: only owner
715 
716     self.is_killed = True
717 
718 @external
719 def unkillGauge():
720     """
721     @notice Unkills the gauge so it can mint BAL again
722     """
723     assert msg.sender == AUTHORIZER_ADAPTOR  # dev: only owner
724 
725     self.is_killed = False
726 
727 
728 # View Methods
729 
730 
731 @view
732 @external
733 def claimed_reward(_addr: address, _token: address) -> uint256:
734     """
735     @notice Get the number of already-claimed reward tokens for a user
736     @param _addr Account to get reward amount for
737     @param _token Token to get reward amount for
738     @return uint256 Total amount of `_token` already claimed by `_addr`
739     """
740     return self.claim_data[_addr][_token] % 2**128
741 
742 
743 @view
744 @external
745 def claimable_reward(_user: address, _reward_token: address) -> uint256:
746     """
747     @notice Get the number of claimable reward tokens for a user
748     @param _user Account to get reward amount for
749     @param _reward_token Token to get reward amount for
750     @return uint256 Claimable reward token amount
751     """
752     integral: uint256 = self.reward_data[_reward_token].integral
753     total_supply: uint256 = self.totalSupply
754     if total_supply != 0:
755         last_update: uint256 = min(block.timestamp, self.reward_data[_reward_token].period_finish)
756         duration: uint256 = last_update - self.reward_data[_reward_token].last_update
757         integral += (duration * self.reward_data[_reward_token].rate * 10**18 / total_supply)
758 
759     integral_for: uint256 = self.reward_integral_for[_reward_token][_user]
760     new_claimable: uint256 = self.balanceOf[_user] * (integral - integral_for) / 10**18
761 
762     return shift(self.claim_data[_user][_reward_token], -128) + new_claimable
763 
764 
765 @external
766 def claimable_tokens(addr: address) -> uint256:
767     """
768     @notice Get the number of claimable tokens per user
769     @dev This function should be manually changed to "view" in the ABI
770     @return uint256 number of claimable tokens per user
771     """
772     self._checkpoint(addr)
773     return self.integrate_fraction[addr] - Minter(MINTER).minted(addr, self)
774 
775 
776 @view
777 @external
778 def integrate_checkpoint() -> uint256:
779     """
780     @notice Get the timestamp of the last checkpoint
781     """
782     return self.period_timestamp[self.period]
783 
784 
785 @view
786 @external
787 def future_epoch_time() -> uint256:
788     """
789     @notice Get the locally stored BAL future epoch start time
790     """
791     return shift(self.inflation_params, -216)
792 
793 
794 @view
795 @external
796 def inflation_rate() -> uint256:
797     """
798     @notice Get the locally stored BAL inflation rate
799     """
800     return self.inflation_params % 2 ** 216
801 
802 
803 @view
804 @external
805 def decimals() -> uint256:
806     """
807     @notice Get the number of decimals for this token
808     @dev Implemented as a view method to reduce gas costs
809     @return uint256 decimal places
810     """
811     return 18
812 
813 
814 @view
815 @external
816 def version() -> String[8]:
817     """
818     @notice Get the version of this gauge contract
819     """
820     return VERSION
821 
822 @view
823 @external
824 def allowance(owner: address, spender: address) -> uint256:
825     """
826      @notice Get `spender`'s current allowance from `owner` 
827     """
828     return self._get_allowance(owner, spender)
829 
830 
831 # Initializer
832 
833 
834 @external
835 def initialize(_lp_token: address):
836     """
837     @notice Contract constructor
838     @param _lp_token Liquidity Pool contract address
839     """
840     assert self.lp_token == ZERO_ADDRESS
841 
842     self.lp_token = _lp_token
843 
844     symbol: String[32] = ERC20Extended(_lp_token).symbol()
845     name: String[64] = concat("Balancer ", symbol, " Gauge Deposit")
846 
847     self.name = name
848     self.symbol = concat(symbol, "-gauge")
849 
850     self.DOMAIN_SEPARATOR = keccak256(
851         _abi_encode(EIP712_TYPEHASH, keccak256(name), keccak256(VERSION), chain.id, self)
852     )
853 
854     self.period_timestamp[0] = block.timestamp
855     self.inflation_params = shift(TokenAdmin(BAL_TOKEN_ADMIN).future_epoch_time_write(), 216) + TokenAdmin(BAL_TOKEN_ADMIN).rate()