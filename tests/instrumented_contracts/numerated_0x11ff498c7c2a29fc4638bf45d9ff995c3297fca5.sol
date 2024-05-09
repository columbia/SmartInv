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
71 event RelativeWeightCapChanged:
72     new_relative_weight_cap: uint256
73 
74 struct Reward:
75     token: address
76     distributor: address
77     period_finish: uint256
78     rate: uint256
79     last_update: uint256
80     integral: uint256
81 
82 
83 CLAIM_FREQUENCY: constant(uint256) = 3600
84 MAX_REWARDS: constant(uint256) = 8
85 TOKENLESS_PRODUCTION: constant(uint256) = 40
86 WEEK: constant(uint256) = 604800
87 
88 # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
89 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
90 VERSION: constant(String[8]) = "v5.0.0"
91 
92 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
93 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
94 
95 BAL_TOKEN_ADMIN: immutable(address)
96 BAL_VAULT: immutable(address)
97 AUTHORIZER_ADAPTOR: immutable(address)
98 GAUGE_CONTROLLER: immutable(address)
99 MINTER: immutable(address)
100 VOTING_ESCROW: immutable(address)
101 VEBOOST_PROXY: immutable(address)
102 
103 MAX_RELATIVE_WEIGHT_CAP: constant(uint256) = 10 ** 18
104 
105 # ERC20
106 balanceOf: public(HashMap[address, uint256])
107 totalSupply: public(uint256)
108 _allowance: HashMap[address, HashMap[address, uint256]]
109 
110 name: public(String[64])
111 symbol: public(String[40])
112 
113 # ERC2612
114 DOMAIN_SEPARATOR: public(bytes32)
115 nonces: public(HashMap[address, uint256])
116 
117 # Gauge
118 lp_token: public(address)
119 
120 is_killed: public(bool)
121 
122 # [future_epoch_time uint40][inflation_rate uint216]
123 inflation_params: uint256
124 
125 # For tracking external rewards
126 reward_count: public(uint256)
127 reward_data: public(HashMap[address, Reward])
128 
129 # claimant -> default reward receiver
130 rewards_receiver: public(HashMap[address, address])
131 
132 # reward token -> claiming address -> integral
133 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
134 
135 # user -> [uint128 claimable amount][uint128 claimed amount]
136 claim_data: HashMap[address, HashMap[address, uint256]]
137 
138 working_balances: public(HashMap[address, uint256])
139 working_supply: public(uint256)
140 
141 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
142 integrate_inv_supply_of: public(HashMap[address, uint256])
143 integrate_checkpoint_of: public(HashMap[address, uint256])
144 
145 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
146 # Units: rate * t = already number of coins per address to issue
147 integrate_fraction: public(HashMap[address, uint256])
148 
149 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
150 # All values are kept in units of being multiplied by 1e18
151 period: public(int128)
152 
153 # array of reward tokens
154 reward_tokens: public(address[MAX_REWARDS])
155 
156 period_timestamp: public(uint256[100000000000000000000000000000])
157 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
158 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
159 
160 _relative_weight_cap: uint256
161 
162 @external
163 def __init__(minter: address, veBoostProxy: address, authorizerAdaptor: address):
164     """
165     @param minter Address of minter contract
166     @param veBoostProxy Address of boost delegation contract
167     """
168     gaugeController: address = Minter(minter).getGaugeController()
169     balTokenAdmin: address = Minter(minter).getBalancerTokenAdmin()
170     BAL_TOKEN_ADMIN = balTokenAdmin
171     BAL_VAULT = TokenAdmin(balTokenAdmin).getVault()
172     AUTHORIZER_ADAPTOR = authorizerAdaptor
173     GAUGE_CONTROLLER = gaugeController
174     MINTER = minter
175     VOTING_ESCROW = Controller(gaugeController).voting_escrow()
176     VEBOOST_PROXY = veBoostProxy
177     # prevent initialization of implementation
178     self.lp_token = 0x000000000000000000000000000000000000dEaD
179 
180 
181 # Internal Functions
182 
183 @view
184 @internal
185 def _get_allowance(owner: address, spender: address) -> uint256:
186     """
187      @dev Override to grant the Vault infinite allowance, causing for Gauge Tokens to not require approval.
188      This is sound as the Vault already provides authorization mechanisms when initiating token transfers, which this
189      contract inherits.
190     """
191     if (spender == BAL_VAULT):
192         return MAX_UINT256
193     return self._allowance[owner][spender]
194 
195 @internal
196 @view
197 def _getCappedRelativeWeight(period: uint256) -> uint256:
198     """
199     @dev Returns the gauge's relative weight, capped to its _relative_weight_cap attribute.
200     """
201     return min(Controller(GAUGE_CONTROLLER).gauge_relative_weight(self, period), self._relative_weight_cap)
202 
203 @internal
204 def _checkpoint(addr: address):
205     """
206     @notice Checkpoint for a user
207     @dev Updates the BAL emissions a user is entitled to receive
208     @param addr User address
209     """
210     _period: int128 = self.period
211     _period_time: uint256 = self.period_timestamp[_period]
212     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
213 
214     inflation_params: uint256 = self.inflation_params
215     rate: uint256 = inflation_params % 2 ** 216
216     prev_future_epoch: uint256 = shift(inflation_params, -216)
217     new_rate: uint256 = rate
218 
219     if prev_future_epoch >= _period_time:
220         new_rate = TokenAdmin(BAL_TOKEN_ADMIN).rate()
221         self.inflation_params = shift(TokenAdmin(BAL_TOKEN_ADMIN).future_epoch_time_write(), 216) + new_rate
222 
223     if self.is_killed:
224         # Stop distributing inflation as soon as killed
225         rate = 0
226         new_rate = 0  # prevent distribution when crossing epochs
227 
228     # Update integral of 1/supply
229     if block.timestamp > _period_time:
230         _working_supply: uint256 = self.working_supply
231         Controller(GAUGE_CONTROLLER).checkpoint_gauge(self)
232         prev_week_time: uint256 = _period_time
233         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
234 
235         for i in range(500):
236             dt: uint256 = week_time - prev_week_time
237             w: uint256 = self._getCappedRelativeWeight(prev_week_time / WEEK * WEEK)
238 
239             if _working_supply > 0:
240                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
241                     # If we went across one or multiple epochs, apply the rate
242                     # of the first epoch until it ends, and then the rate of
243                     # the last epoch.
244                     # If more than one epoch is crossed - the gauge gets less,
245                     # but that'd meen it wasn't called for more than 1 year
246                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
247                     rate = new_rate
248                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
249                 else:
250                     _integrate_inv_supply += rate * w * dt / _working_supply
251                 # On precisions of the calculation
252                 # rate ~= 10e18
253                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
254                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
255                 # The largest loss is at dt = 1
256                 # Loss is 1e-9 - acceptable
257 
258             if week_time == block.timestamp:
259                 break
260             prev_week_time = week_time
261             week_time = min(week_time + WEEK, block.timestamp)
262 
263     _period += 1
264     self.period = _period
265     self.period_timestamp[_period] = block.timestamp
266     self.integrate_inv_supply[_period] = _integrate_inv_supply
267 
268     # Update user-specific integrals
269     _working_balance: uint256 = self.working_balances[addr]
270     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
271     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
272     self.integrate_checkpoint_of[addr] = block.timestamp
273 
274 
275 @internal
276 def _checkpoint_rewards(_user: address, _total_supply: uint256, _claim: bool, _receiver: address):
277     """
278     @notice Claim pending rewards and checkpoint rewards for a user
279     """
280     user_balance: uint256 = 0
281     receiver: address = _receiver
282     if _user != ZERO_ADDRESS:
283         user_balance = self.balanceOf[_user]
284         if _claim and _receiver == ZERO_ADDRESS:
285             # if receiver is not explicitly declared, check if a default receiver is set
286             receiver = self.rewards_receiver[_user]
287             if receiver == ZERO_ADDRESS:
288                 # if no default receiver is set, direct claims to the user
289                 receiver = _user
290 
291     reward_count: uint256 = self.reward_count
292     for i in range(MAX_REWARDS):
293         if i == reward_count:
294             break
295         token: address = self.reward_tokens[i]
296 
297         integral: uint256 = self.reward_data[token].integral
298         last_update: uint256 = min(block.timestamp, self.reward_data[token].period_finish)
299         duration: uint256 = last_update - self.reward_data[token].last_update
300         if duration != 0:
301             self.reward_data[token].last_update = last_update
302             if _total_supply != 0:
303                 integral += duration * self.reward_data[token].rate * 10**18 / _total_supply
304                 self.reward_data[token].integral = integral
305 
306         if _user != ZERO_ADDRESS:
307             integral_for: uint256 = self.reward_integral_for[token][_user]
308             new_claimable: uint256 = 0
309 
310             if integral_for < integral:
311                 self.reward_integral_for[token][_user] = integral
312                 new_claimable = user_balance * (integral - integral_for) / 10**18
313 
314             claim_data: uint256 = self.claim_data[_user][token]
315             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
316             if total_claimable > 0:
317                 total_claimed: uint256 = claim_data % 2**128
318                 if _claim:
319                     response: Bytes[32] = raw_call(
320                         token,
321                         _abi_encode(
322                             receiver,
323                             total_claimable,
324                             method_id=method_id("transfer(address,uint256)")
325                         ),
326                         max_outsize=32,
327                     )
328                     if len(response) != 0:
329                         assert convert(response, bool)
330                     self.claim_data[_user][token] = total_claimed + total_claimable
331                 elif new_claimable > 0:
332                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
333 
334 
335 @internal
336 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
337     """
338     @notice Calculate limits which depend on the amount of BPT token per-user.
339             Effectively it calculates working balances to apply amplification
340             of BAL production by BPT
341     @param addr User address
342     @param l User's amount of liquidity (LP tokens)
343     @param L Total amount of liquidity (LP tokens)
344     """
345     # To be called after totalSupply is updated
346     voting_balance: uint256 = VotingEscrowBoost(VEBOOST_PROXY).adjusted_balance_of(addr)
347     voting_total: uint256 = ERC20(VOTING_ESCROW).totalSupply()
348 
349     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
350     if voting_total > 0:
351         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
352 
353     lim = min(l, lim)
354     old_bal: uint256 = self.working_balances[addr]
355     self.working_balances[addr] = lim
356     _working_supply: uint256 = self.working_supply + lim - old_bal
357     self.working_supply = _working_supply
358 
359     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
360 
361 
362 @internal
363 def _transfer(_from: address, _to: address, _value: uint256):
364     """
365     @notice Transfer tokens as well as checkpoint users
366     """
367     self._checkpoint(_from)
368     self._checkpoint(_to)
369 
370     if _value != 0:
371         total_supply: uint256 = self.totalSupply
372         is_rewards: bool = self.reward_count != 0
373         if is_rewards:
374             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
375         new_balance: uint256 = self.balanceOf[_from] - _value
376         self.balanceOf[_from] = new_balance
377         self._update_liquidity_limit(_from, new_balance, total_supply)
378 
379         if is_rewards:
380             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
381         new_balance = self.balanceOf[_to] + _value
382         self.balanceOf[_to] = new_balance
383         self._update_liquidity_limit(_to, new_balance, total_supply)
384 
385     log Transfer(_from, _to, _value)
386 
387 
388 # External User Facing Functions
389 
390 
391 @external
392 @nonreentrant('lock')
393 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
394     """
395     @notice Deposit `_value` LP tokens
396     @dev Depositting also claims pending reward tokens
397     @param _value Number of tokens to deposit
398     @param _addr Address to deposit for
399     """
400 
401     self._checkpoint(_addr)
402 
403     if _value != 0:
404         is_rewards: bool = self.reward_count != 0
405         total_supply: uint256 = self.totalSupply
406         if is_rewards:
407             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
408 
409         total_supply += _value
410         new_balance: uint256 = self.balanceOf[_addr] + _value
411         self.balanceOf[_addr] = new_balance
412         self.totalSupply = total_supply
413 
414         self._update_liquidity_limit(_addr, new_balance, total_supply)
415 
416         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
417 
418     log Deposit(_addr, _value)
419     log Transfer(ZERO_ADDRESS, _addr, _value)
420 
421 
422 @external
423 @nonreentrant('lock')
424 def withdraw(_value: uint256, _claim_rewards: bool = False):
425     """
426     @notice Withdraw `_value` LP tokens
427     @dev Withdrawing also claims pending reward tokens
428     @param _value Number of tokens to withdraw
429     """
430     self._checkpoint(msg.sender)
431 
432     if _value != 0:
433         is_rewards: bool = self.reward_count != 0
434         total_supply: uint256 = self.totalSupply
435         if is_rewards:
436             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
437 
438         total_supply -= _value
439         new_balance: uint256 = self.balanceOf[msg.sender] - _value
440         self.balanceOf[msg.sender] = new_balance
441         self.totalSupply = total_supply
442 
443         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
444 
445         ERC20(self.lp_token).transfer(msg.sender, _value)
446 
447     log Withdraw(msg.sender, _value)
448     log Transfer(msg.sender, ZERO_ADDRESS, _value)
449 
450 
451 @external
452 @nonreentrant('lock')
453 def claim_rewards(_addr: address = msg.sender, _receiver: address = ZERO_ADDRESS):
454     """
455     @notice Claim available reward tokens for `_addr`
456     @param _addr Address to claim for
457     @param _receiver Address to transfer rewards to - if set to
458                      ZERO_ADDRESS, uses the default reward receiver
459                      for the caller
460     """
461     if _receiver != ZERO_ADDRESS:
462         assert _addr == msg.sender  # dev: cannot redirect when claiming for another user
463     self._checkpoint_rewards(_addr, self.totalSupply, True, _receiver)
464 
465 
466 @external
467 @nonreentrant('lock')
468 def transferFrom(_from: address, _to :address, _value: uint256) -> bool:
469     """
470      @notice Transfer tokens from one address to another.
471      @dev Transferring claims pending reward tokens for the sender and receiver
472      @param _from address The address which you want to send tokens from
473      @param _to address The address which you want to transfer to
474      @param _value uint256 the amount of tokens to be transferred
475     """
476     _allowance: uint256 = self._get_allowance(_from, msg.sender)
477     if _allowance != MAX_UINT256:
478         self._allowance[_from][msg.sender] = _allowance - _value
479 
480     self._transfer(_from, _to, _value)
481 
482     return True
483 
484 
485 @external
486 @nonreentrant('lock')
487 def transfer(_to: address, _value: uint256) -> bool:
488     """
489     @notice Transfer token for a specified address
490     @dev Transferring claims pending reward tokens for the sender and receiver
491     @param _to The address to transfer to.
492     @param _value The amount to be transferred.
493     """
494     self._transfer(msg.sender, _to, _value)
495 
496     return True
497 
498 
499 @external
500 def approve(_spender : address, _value : uint256) -> bool:
501     """
502     @notice Approve the passed address to transfer the specified amount of
503             tokens on behalf of msg.sender
504     @dev Beware that changing an allowance via this method brings the risk
505          that someone may use both the old and new allowance by unfortunate
506          transaction ordering. This may be mitigated with the use of
507          {incraseAllowance} and {decreaseAllowance}.
508          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
509     @param _spender The address which will transfer the funds
510     @param _value The amount of tokens that may be transferred
511     @return bool success
512     """
513     self._allowance[msg.sender][_spender] = _value
514     log Approval(msg.sender, _spender, _value)
515 
516     return True
517 
518 
519 @external
520 def permit(
521     _owner: address,
522     _spender: address,
523     _value: uint256,
524     _deadline: uint256,
525     _v: uint8,
526     _r: bytes32,
527     _s: bytes32
528 ) -> bool:
529     """
530     @notice Approves spender by owner's signature to expend owner's tokens.
531         See https://eips.ethereum.org/EIPS/eip-2612.
532     @dev Inspired by https://github.com/yearn/yearn-vaults/blob/main/contracts/Vault.vy#L753-L793
533     @dev Supports smart contract wallets which implement ERC1271
534         https://eips.ethereum.org/EIPS/eip-1271
535     @param _owner The address which is a source of funds and has signed the Permit.
536     @param _spender The address which is allowed to spend the funds.
537     @param _value The amount of tokens to be spent.
538     @param _deadline The timestamp after which the Permit is no longer valid.
539     @param _v The bytes[64] of the valid secp256k1 signature of permit by owner
540     @param _r The bytes[0:32] of the valid secp256k1 signature of permit by owner
541     @param _s The bytes[32:64] of the valid secp256k1 signature of permit by owner
542     @return True, if transaction completes successfully
543     """
544     assert _owner != ZERO_ADDRESS
545     assert block.timestamp <= _deadline
546 
547     nonce: uint256 = self.nonces[_owner]
548     digest: bytes32 = keccak256(
549         concat(
550             b"\x19\x01",
551             self.DOMAIN_SEPARATOR,
552             keccak256(_abi_encode(PERMIT_TYPEHASH, _owner, _spender, _value, nonce, _deadline))
553         )
554     )
555 
556     if _owner.is_contract:
557         sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
558         # reentrancy not a concern since this is a staticcall
559         assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
560     else:
561         assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
562 
563     self._allowance[_owner][_spender] = _value
564     self.nonces[_owner] = nonce + 1
565 
566     log Approval(_owner, _spender, _value)
567     return True
568 
569 
570 @external
571 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
572     """
573     @notice Increase the allowance granted to `_spender` by the caller
574     @dev This is alternative to {approve} that can be used as a mitigation for
575          the potential race condition
576     @param _spender The address which will transfer the funds
577     @param _added_value The amount of to increase the allowance
578     @return bool success
579     """
580     allowance: uint256 = self._get_allowance(msg.sender,_spender) + _added_value
581     self._allowance[msg.sender][_spender] = allowance
582 
583     log Approval(msg.sender, _spender, allowance)
584 
585     return True
586 
587 
588 @external
589 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
590     """
591     @notice Decrease the allowance granted to `_spender` by the caller
592     @dev This is alternative to {approve} that can be used as a mitigation for
593          the potential race condition
594     @param _spender The address which will transfer the funds
595     @param _subtracted_value The amount of to decrease the allowance
596     @return bool success
597     """
598     allowance: uint256 = self._get_allowance(msg.sender, _spender) - _subtracted_value
599     self._allowance[msg.sender][_spender] = allowance
600 
601     log Approval(msg.sender, _spender, allowance)
602 
603     return True
604 
605 
606 @external
607 def user_checkpoint(addr: address) -> bool:
608     """
609     @notice Record a checkpoint for `addr`
610     @param addr User address
611     @return bool success
612     """
613     assert msg.sender in [addr, MINTER]  # dev: unauthorized
614     self._checkpoint(addr)
615     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
616     return True
617 
618 
619 @external
620 def set_rewards_receiver(_receiver: address):
621     """
622     @notice Set the default reward receiver for the caller.
623     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
624     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
625     """
626     self.rewards_receiver[msg.sender] = _receiver
627 
628 
629 @external
630 def kick(addr: address):
631     """
632     @notice Kick `addr` for abusing their boost
633     @dev Only if either they had another voting event, or their voting escrow lock expired
634     @param addr Address to kick
635     """
636     t_last: uint256 = self.integrate_checkpoint_of[addr]
637     t_ve: uint256 = VotingEscrow(VOTING_ESCROW).user_point_history__ts(
638         addr, VotingEscrow(VOTING_ESCROW).user_point_epoch(addr)
639     )
640     _balance: uint256 = self.balanceOf[addr]
641 
642     assert ERC20(VOTING_ESCROW).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
643     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
644 
645     self._checkpoint(addr)
646     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
647 
648 
649 # Administrative Functions
650 
651 
652 @external
653 @nonreentrant("lock")
654 def deposit_reward_token(_reward_token: address, _amount: uint256):
655     """
656     @notice Deposit a reward token for distribution
657     @param _reward_token The reward token being deposited
658     @param _amount The amount of `_reward_token` being deposited
659     """
660     assert msg.sender == self.reward_data[_reward_token].distributor
661 
662     self._checkpoint_rewards(ZERO_ADDRESS, self.totalSupply, False, ZERO_ADDRESS)
663 
664     response: Bytes[32] = raw_call(
665         _reward_token,
666         _abi_encode(
667             msg.sender, self, _amount, method_id=method_id("transferFrom(address,address,uint256)")
668         ),
669         max_outsize=32,
670     )
671     if len(response) != 0:
672         assert convert(response, bool)
673 
674     period_finish: uint256 = self.reward_data[_reward_token].period_finish
675     if block.timestamp >= period_finish:
676         self.reward_data[_reward_token].rate = _amount / WEEK
677     else:
678         remaining: uint256 = period_finish - block.timestamp
679         leftover: uint256 = remaining * self.reward_data[_reward_token].rate
680         self.reward_data[_reward_token].rate = (_amount + leftover) / WEEK
681 
682     self.reward_data[_reward_token].last_update = block.timestamp
683     self.reward_data[_reward_token].period_finish = block.timestamp + WEEK
684 
685 
686 @external
687 def add_reward(_reward_token: address, _distributor: address):
688     """
689     @notice Add additional rewards to be distributed to stakers
690     @param _reward_token The token to add as an additional reward
691     @param _distributor Address permitted to fund this contract with the reward token
692     """
693     assert _distributor != ZERO_ADDRESS
694     assert msg.sender == AUTHORIZER_ADAPTOR  # dev: only owner
695 
696     reward_count: uint256 = self.reward_count
697     assert reward_count < MAX_REWARDS
698     assert self.reward_data[_reward_token].distributor == ZERO_ADDRESS
699 
700     self.reward_data[_reward_token].distributor = _distributor
701     self.reward_tokens[reward_count] = _reward_token
702     self.reward_count = reward_count + 1
703     log RewardDistributorUpdated(_reward_token, _distributor)
704 
705 
706 @external
707 def set_reward_distributor(_reward_token: address, _distributor: address):
708     """
709     @notice Reassign the reward distributor for a reward token
710     @param _reward_token The reward token to reassign distribution rights to
711     @param _distributor The address of the new distributor
712     """
713     current_distributor: address = self.reward_data[_reward_token].distributor
714 
715     assert msg.sender == current_distributor or msg.sender == AUTHORIZER_ADAPTOR
716     assert current_distributor != ZERO_ADDRESS
717     assert _distributor != ZERO_ADDRESS
718 
719     self.reward_data[_reward_token].distributor = _distributor
720     log RewardDistributorUpdated(_reward_token, _distributor)
721 
722 @external
723 def killGauge():
724     """
725     @notice Kills the gauge so it always yields a rate of 0 and so cannot mint BAL
726     """
727     assert msg.sender == AUTHORIZER_ADAPTOR  # dev: only owner
728 
729     self.is_killed = True
730 
731 @external
732 def unkillGauge():
733     """
734     @notice Unkills the gauge so it can mint BAL again
735     """
736     assert msg.sender == AUTHORIZER_ADAPTOR  # dev: only owner
737 
738     self.is_killed = False
739 
740 
741 # View Methods
742 
743 
744 @view
745 @external
746 def claimed_reward(_addr: address, _token: address) -> uint256:
747     """
748     @notice Get the number of already-claimed reward tokens for a user
749     @param _addr Account to get reward amount for
750     @param _token Token to get reward amount for
751     @return uint256 Total amount of `_token` already claimed by `_addr`
752     """
753     return self.claim_data[_addr][_token] % 2**128
754 
755 
756 @view
757 @external
758 def claimable_reward(_user: address, _reward_token: address) -> uint256:
759     """
760     @notice Get the number of claimable reward tokens for a user
761     @param _user Account to get reward amount for
762     @param _reward_token Token to get reward amount for
763     @return uint256 Claimable reward token amount
764     """
765     integral: uint256 = self.reward_data[_reward_token].integral
766     total_supply: uint256 = self.totalSupply
767     if total_supply != 0:
768         last_update: uint256 = min(block.timestamp, self.reward_data[_reward_token].period_finish)
769         duration: uint256 = last_update - self.reward_data[_reward_token].last_update
770         integral += (duration * self.reward_data[_reward_token].rate * 10**18 / total_supply)
771 
772     integral_for: uint256 = self.reward_integral_for[_reward_token][_user]
773     new_claimable: uint256 = self.balanceOf[_user] * (integral - integral_for) / 10**18
774 
775     return shift(self.claim_data[_user][_reward_token], -128) + new_claimable
776 
777 
778 @external
779 def claimable_tokens(addr: address) -> uint256:
780     """
781     @notice Get the number of claimable tokens per user
782     @dev This function should be manually changed to "view" in the ABI
783     @return uint256 number of claimable tokens per user
784     """
785     self._checkpoint(addr)
786     return self.integrate_fraction[addr] - Minter(MINTER).minted(addr, self)
787 
788 
789 @view
790 @external
791 def integrate_checkpoint() -> uint256:
792     """
793     @notice Get the timestamp of the last checkpoint
794     """
795     return self.period_timestamp[self.period]
796 
797 
798 @view
799 @external
800 def future_epoch_time() -> uint256:
801     """
802     @notice Get the locally stored BAL future epoch start time
803     """
804     return shift(self.inflation_params, -216)
805 
806 
807 @view
808 @external
809 def inflation_rate() -> uint256:
810     """
811     @notice Get the locally stored BAL inflation rate
812     """
813     return self.inflation_params % 2 ** 216
814 
815 
816 @view
817 @external
818 def decimals() -> uint256:
819     """
820     @notice Get the number of decimals for this token
821     @dev Implemented as a view method to reduce gas costs
822     @return uint256 decimal places
823     """
824     return 18
825 
826 
827 @view
828 @external
829 def version() -> String[8]:
830     """
831     @notice Get the version of this gauge contract
832     """
833     return VERSION
834 
835 @view
836 @external
837 def allowance(owner: address, spender: address) -> uint256:
838     """
839      @notice Get `spender`'s current allowance from `owner` 
840     """
841     return self._get_allowance(owner, spender)
842 
843 
844 # Initializer
845 
846 @internal
847 def _setRelativeWeightCap(relative_weight_cap: uint256):
848     assert relative_weight_cap <= MAX_RELATIVE_WEIGHT_CAP, "Relative weight cap exceeds allowed absolute maximum"
849     self._relative_weight_cap = relative_weight_cap
850     log RelativeWeightCapChanged(relative_weight_cap)
851 
852 @external
853 def initialize(_lp_token: address, relative_weight_cap: uint256):
854     """
855     @notice Contract constructor
856     @param _lp_token Liquidity Pool contract address
857     """
858     assert self.lp_token == ZERO_ADDRESS
859 
860     self.lp_token = _lp_token
861 
862     symbol: String[32] = ERC20Extended(_lp_token).symbol()
863     name: String[64] = concat("Balancer ", symbol, " Gauge Deposit")
864 
865     self.name = name
866     self.symbol = concat(symbol, "-gauge")
867 
868     self.DOMAIN_SEPARATOR = keccak256(
869         _abi_encode(EIP712_TYPEHASH, keccak256(name), keccak256(VERSION), chain.id, self)
870     )
871 
872     self.period_timestamp[0] = block.timestamp
873     self.inflation_params = shift(TokenAdmin(BAL_TOKEN_ADMIN).future_epoch_time_write(), 216) + TokenAdmin(BAL_TOKEN_ADMIN).rate()
874     self._setRelativeWeightCap(relative_weight_cap)
875 
876 @external
877 def setRelativeWeightCap(relative_weight_cap: uint256):
878     """
879     @notice Sets a new relative weight cap for the gauge.
880             The value shall be normalized to 1e18, and not greater than MAX_RELATIVE_WEIGHT_CAP.
881     @param relative_weight_cap New relative weight cap.
882     """
883     assert msg.sender == AUTHORIZER_ADAPTOR  # dev: only owner
884     self._setRelativeWeightCap(relative_weight_cap)
885 
886 @external
887 @view
888 def getRelativeWeightCap() -> uint256:
889     """
890     @notice Returns relative weight cap for the gauge.
891     """
892     return self._relative_weight_cap
893 
894 @external
895 @view
896 def getCappedRelativeWeight(time: uint256) -> uint256:
897     """
898     @notice Returns the gauge's relative weight for a given time, capped to its _relative_weight_cap attribute.
899     @param time Timestamp in the past or present.
900     """
901     return self._getCappedRelativeWeight(time)
902 
903 @external
904 @pure
905 def getMaxRelativeWeightCap() -> uint256:
906     """
907     @notice Returns the maximum value that can be set to _relative_weight_cap attribute.
908     """
909     return MAX_RELATIVE_WEIGHT_CAP