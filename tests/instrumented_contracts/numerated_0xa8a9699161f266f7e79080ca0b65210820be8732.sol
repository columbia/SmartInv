1 # @version 0.3.1
2 """
3 @title Liquidity Gauge v5
4 @author Curve Finance
5 @license MIT
6 """
7 
8 from vyper.interfaces import ERC20
9 
10 implements: ERC20
11 
12 interface Controller:
13     def period() -> int128: view
14     def period_write() -> int128: nonpayable
15     def period_timestamp(p: int128) -> uint256: view
16     def gauge_relative_weight(addr: address, time: uint256) -> uint256: view
17     def voting_escrow() -> address: view
18     def veboost_proxy() -> address: view
19     def checkpoint(): nonpayable
20     def checkpoint_gauge(addr: address): nonpayable
21 
22 interface Minter:
23     def token() -> address: view
24     def controller() -> address: view
25     def minted(user: address, gauge: address) -> uint256: view
26     def future_epoch_time_write() -> uint256: nonpayable
27     def rate() -> uint256: view
28 
29 interface VotingEscrow:
30     def user_point_epoch(addr: address) -> uint256: view
31     def user_point_history__ts(addr: address, epoch: uint256) -> uint256: view
32 
33 interface VotingEscrowBoost:
34     def adjusted_balance_of(_account: address) -> uint256: view
35 
36 interface ERC20Extended:
37     def symbol() -> String[26]: view
38 
39 interface ERC1271:
40   def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view
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
51     user: address
52     original_balance: uint256
53     original_supply: uint256
54     working_balance: uint256
55     working_supply: uint256
56 
57 event CommitOwnership:
58     admin: address
59 
60 event ApplyOwnership:
61     admin: address
62 
63 event Transfer:
64     _from: indexed(address)
65     _to: indexed(address)
66     _value: uint256
67 
68 event Approval:
69     _owner: indexed(address)
70     _spender: indexed(address)
71     _value: uint256
72 
73 
74 struct Reward:
75     token: address
76     distributor: address
77     period_finish: uint256
78     rate: uint256
79     last_update: uint256
80     integral: uint256
81 
82   # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
83 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
84 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
85 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
86 VERSION: constant(String[8]) = "v5.0.0"
87 
88 MAX_REWARDS: constant(uint256) = 8
89 TOKENLESS_PRODUCTION: constant(uint256) = 40
90 WEEK: constant(uint256) = 604800
91 
92 MINTER: immutable(address)
93 RBN_TOKEN: immutable(address)
94 CONTROLLER: immutable(address)
95 VOTING_ESCROW: immutable(address)
96 VEBOOST_PROXY: immutable(address)
97 
98 NAME: immutable(String[64])
99 SYMBOL: immutable(String[32])
100 DOMAIN_SEPARATOR: immutable(bytes32)
101 LP_TOKEN: immutable(address)
102 nonces: public(HashMap[address, uint256])
103 
104 future_epoch_time: public(uint256)
105 
106 balanceOf: public(HashMap[address, uint256])
107 totalSupply: public(uint256)
108 allowance: public(HashMap[address, HashMap[address, uint256]])
109 
110 working_balances: public(HashMap[address, uint256])
111 working_supply: public(uint256)
112 
113 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
114 # All values are kept in units of being multiplied by 1e18
115 period: public(int128)
116 period_timestamp: public(uint256[100000000000000000000000000000])
117 
118 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
119 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
120 
121 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
122 integrate_inv_supply_of: public(HashMap[address, uint256])
123 integrate_checkpoint_of: public(HashMap[address, uint256])
124 
125 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
126 # Units: rate * t = already number of coins per address to issue
127 integrate_fraction: public(HashMap[address, uint256])
128 
129 inflation_rate: public(uint256)
130 
131 # For tracking external rewards
132 reward_count: public(uint256)
133 reward_tokens: public(address[MAX_REWARDS])
134 
135 reward_data: public(HashMap[address, Reward])
136 
137 # claimant -> default reward receiver
138 rewards_receiver: public(HashMap[address, address])
139 
140 # reward token -> claiming address -> integral
141 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
142 
143 # user -> [uint128 claimable amount][uint128 claimed amount]
144 claim_data: HashMap[address, HashMap[address, uint256]]
145 
146 admin: public(address)
147 future_admin: public(address)
148 is_killed: public(bool)
149 
150 
151 @external
152 def __init__(_lp_token: address, _minter: address, _admin: address):
153     """
154     @notice Contract constructor
155     @param _lp_token Liquidity Pool contract address
156     @param _minter Minter contract address
157     @param _admin Admin who can kill the gauge
158     """
159 
160     rbn_token: address = Minter(_minter).token()
161     controller: address = Minter(_minter).controller()
162 
163     MINTER = _minter
164     RBN_TOKEN = rbn_token
165     CONTROLLER = controller
166     VOTING_ESCROW = Controller(controller).voting_escrow()
167     VEBOOST_PROXY = Controller(controller).veboost_proxy()
168 
169     lp_symbol: String[26] = ERC20Extended(_lp_token).symbol()
170     name: String[64] = concat("Ribbon.fi ", lp_symbol, " Gauge Deposit")
171     NAME = name
172     SYMBOL = concat(lp_symbol, "-gauge")
173     DOMAIN_SEPARATOR = keccak256(
174         _abi_encode(EIP712_TYPEHASH, keccak256(name), keccak256(VERSION), chain.id, self)
175     )
176     LP_TOKEN = _lp_token
177 
178     self.admin = _admin
179     self.period_timestamp[0] = block.timestamp
180     self.inflation_rate = Minter(_minter).rate()
181     self.future_epoch_time = Minter(_minter).future_epoch_time_write()
182 
183 @view
184 @external
185 def integrate_checkpoint() -> uint256:
186     return self.period_timestamp[self.period]
187 
188 
189 @internal
190 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
191     """
192     @notice Calculate limits which depend on the amount of CRV token per-user.
193             Effectively it calculates working balances to apply amplification
194             of CRV production by CRV
195     @param addr User address
196     @param l User's amount of liquidity (LP tokens)
197     @param L Total amount of liquidity (LP tokens)
198     """
199     # To be called after totalSupply is updated
200     voting_balance: uint256 = VotingEscrowBoost(VEBOOST_PROXY).adjusted_balance_of(addr)
201     voting_total: uint256 = ERC20(VOTING_ESCROW).totalSupply()
202 
203     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
204     if voting_total > 0:
205         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
206 
207     lim = min(l, lim)
208     old_bal: uint256 = self.working_balances[addr]
209     self.working_balances[addr] = lim
210     _working_supply: uint256 = self.working_supply + lim - old_bal
211     self.working_supply = _working_supply
212 
213     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
214 
215 
216 @internal
217 def _checkpoint_rewards(_user: address, _total_supply: uint256, _claim: bool, _receiver: address):
218     """
219     @notice Claim pending rewards and checkpoint rewards for a user
220     """
221 
222     user_balance: uint256 = 0
223     receiver: address = _receiver
224     if _user != ZERO_ADDRESS:
225         user_balance = self.balanceOf[_user]
226         if _claim and _receiver == ZERO_ADDRESS:
227             # if receiver is not explicitly declared, check if a default receiver is set
228             receiver = self.rewards_receiver[_user]
229             if receiver == ZERO_ADDRESS:
230                 # if no default receiver is set, direct claims to the user
231                 receiver = _user
232 
233     reward_count: uint256 = self.reward_count
234     for i in range(MAX_REWARDS):
235         if i == reward_count:
236             break
237         token: address = self.reward_tokens[i]
238 
239         integral: uint256 = self.reward_data[token].integral
240         last_update: uint256 = min(block.timestamp, self.reward_data[token].period_finish)
241         duration: uint256 = last_update - self.reward_data[token].last_update
242         if duration != 0:
243             self.reward_data[token].last_update = last_update
244             if _total_supply != 0:
245                 integral += duration * self.reward_data[token].rate * 10**18 / _total_supply
246                 self.reward_data[token].integral = integral
247 
248         if _user != ZERO_ADDRESS:
249             integral_for: uint256 = self.reward_integral_for[token][_user]
250             new_claimable: uint256 = 0
251 
252             if integral_for < integral:
253                 self.reward_integral_for[token][_user] = integral
254                 new_claimable = user_balance * (integral - integral_for) / 10**18
255 
256             claim_data: uint256 = self.claim_data[_user][token]
257             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
258             if total_claimable > 0:
259                 total_claimed: uint256 = claim_data % 2**128
260                 if _claim:
261                     response: Bytes[32] = raw_call(
262                         token,
263                         concat(
264                             method_id("transfer(address,uint256)"),
265                             convert(receiver, bytes32),
266                             convert(total_claimable, bytes32),
267                         ),
268                         max_outsize=32,
269                     )
270                     if len(response) != 0:
271                         assert convert(response, bool)
272                     self.claim_data[_user][token] = total_claimed + total_claimable
273                 elif new_claimable > 0:
274                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
275 
276 
277 @internal
278 def _checkpoint(addr: address):
279     """
280     @notice Checkpoint for a user
281     @param addr User address
282     """
283     _period: int128 = self.period
284     _period_time: uint256 = self.period_timestamp[_period]
285     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
286     rate: uint256 = self.inflation_rate
287     new_rate: uint256 = rate
288     prev_future_epoch: uint256 = self.future_epoch_time
289 
290     if block.timestamp >= prev_future_epoch:
291       self.future_epoch_time = Minter(MINTER).future_epoch_time_write()
292       new_rate = Minter(MINTER).rate()
293       self.inflation_rate = new_rate
294 
295     if self.is_killed:
296         # Stop distributing inflation as soon as killed
297         rate = 0
298         new_rate = 0
299 
300     # Update integral of 1/supply
301     if block.timestamp > _period_time:
302         _working_supply: uint256 = self.working_supply
303         Controller(CONTROLLER).checkpoint_gauge(self)
304         prev_week_time: uint256 = _period_time
305         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
306 
307         for i in range(500):
308             dt: uint256 = week_time - prev_week_time
309             w: uint256 = Controller(CONTROLLER).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
310 
311             if _working_supply > 0:
312                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time and rate != new_rate:
313                     # If we went across one or multiple epochs, apply the rate
314                     # of the first epoch until it ends, and then the rate of
315                     # the last epoch.
316                     # If more than one epoch is crossed - the gauge gets less,
317                     # but that'd meen it wasn't called for more than 1 year
318                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
319                     rate = new_rate
320                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
321                 else:
322                     _integrate_inv_supply += new_rate * w * dt / _working_supply
323                 # On precisions of the calculation
324                 # rate ~= 10e18
325                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
326                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
327                 # The largest loss is at dt = 1
328                 # Loss is 1e-9 - acceptable
329 
330             if week_time == block.timestamp:
331                 break
332             prev_week_time = week_time
333             week_time = min(week_time + WEEK, block.timestamp)
334 
335     _period += 1
336     self.period = _period
337     self.period_timestamp[_period] = block.timestamp
338     self.integrate_inv_supply[_period] = _integrate_inv_supply
339 
340     # Update user-specific integrals
341     _working_balance: uint256 = self.working_balances[addr]
342     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
343     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
344     self.integrate_checkpoint_of[addr] = block.timestamp
345 
346 
347 @external
348 def user_checkpoint(addr: address) -> bool:
349     """
350     @notice Record a checkpoint for `addr`
351     @param addr User address
352     @return bool success
353     """
354     assert msg.sender in [addr, MINTER]  # dev: unauthorized
355     self._checkpoint(addr)
356     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
357     return True
358 
359 
360 @external
361 def claimable_tokens(addr: address) -> uint256:
362     """
363     @notice Get the number of claimable tokens per user
364     @dev This function should be manually changed to "view" in the ABI
365     @return uint256 number of claimable tokens per user
366     """
367     self._checkpoint(addr)
368     return self.integrate_fraction[addr] - Minter(MINTER).minted(addr, self)
369 
370 
371 @view
372 @external
373 def claimed_reward(_addr: address, _token: address) -> uint256:
374     """
375     @notice Get the number of already-claimed reward tokens for a user
376     @param _addr Account to get reward amount for
377     @param _token Token to get reward amount for
378     @return uint256 Total amount of `_token` already claimed by `_addr`
379     """
380     return self.claim_data[_addr][_token] % 2**128
381 
382 
383 @view
384 @external
385 def claimable_reward(_user: address, _reward_token: address) -> uint256:
386     """
387     @notice Get the number of claimable reward tokens for a user
388     @param _user Account to get reward amount for
389     @param _reward_token Token to get reward amount for
390     @return uint256 Claimable reward token amount
391     """
392     integral: uint256 = self.reward_data[_reward_token].integral
393     total_supply: uint256 = self.totalSupply
394     if total_supply != 0:
395         last_update: uint256 = min(block.timestamp, self.reward_data[_reward_token].period_finish)
396         duration: uint256 = last_update - self.reward_data[_reward_token].last_update
397         integral += (duration * self.reward_data[_reward_token].rate * 10**18 / total_supply)
398 
399     integral_for: uint256 = self.reward_integral_for[_reward_token][_user]
400     new_claimable: uint256 = self.balanceOf[_user] * (integral - integral_for) / 10**18
401 
402     return shift(self.claim_data[_user][_reward_token], -128) + new_claimable
403 
404 
405 @external
406 def set_rewards_receiver(_receiver: address):
407     """
408     @notice Set the default reward receiver for the caller.
409     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
410     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
411     """
412     self.rewards_receiver[msg.sender] = _receiver
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
431 def kick(addr: address):
432     """
433     @notice Kick `addr` for abusing their boost
434     @dev Only if either they had another voting event, or their voting escrow lock expired
435     @param addr Address to kick
436     """
437     t_last: uint256 = self.integrate_checkpoint_of[addr]
438     t_ve: uint256 = VotingEscrow(VOTING_ESCROW).user_point_history__ts(
439         addr, VotingEscrow(VOTING_ESCROW).user_point_epoch(addr)
440     )
441     _balance: uint256 = self.balanceOf[addr]
442 
443     assert ERC20(VOTING_ESCROW).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
444     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
445 
446     self._checkpoint(addr)
447     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
448 
449 
450 @external
451 @nonreentrant('lock')
452 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
453     """
454     @notice Deposit `_value` LP tokens
455     @dev Depositting also claims pending reward tokens
456     @param _value Number of tokens to deposit
457     @param _addr Address to deposit for
458     """
459 
460     self._checkpoint(_addr)
461 
462     if _value != 0:
463         is_rewards: bool = self.reward_count != 0
464         total_supply: uint256 = self.totalSupply
465         if is_rewards:
466             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
467 
468         total_supply += _value
469         new_balance: uint256 = self.balanceOf[_addr] + _value
470         self.balanceOf[_addr] = new_balance
471         self.totalSupply = total_supply
472 
473         self._update_liquidity_limit(_addr, new_balance, total_supply)
474 
475         ERC20(LP_TOKEN).transferFrom(msg.sender, self, _value)
476 
477     log Deposit(_addr, _value)
478     log Transfer(ZERO_ADDRESS, _addr, _value)
479 
480 
481 @external
482 @nonreentrant('lock')
483 def withdraw(_value: uint256, _claim_rewards: bool = False):
484     """
485     @notice Withdraw `_value` LP tokens
486     @dev Withdrawing also claims pending reward tokens
487     @param _value Number of tokens to withdraw
488     """
489     self._checkpoint(msg.sender)
490 
491     if _value != 0:
492         is_rewards: bool = self.reward_count != 0
493         total_supply: uint256 = self.totalSupply
494         if is_rewards:
495             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
496 
497         total_supply -= _value
498         new_balance: uint256 = self.balanceOf[msg.sender] - _value
499         self.balanceOf[msg.sender] = new_balance
500         self.totalSupply = total_supply
501 
502         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
503 
504         ERC20(LP_TOKEN).transfer(msg.sender, _value)
505 
506     log Withdraw(msg.sender, _value)
507     log Transfer(msg.sender, ZERO_ADDRESS, _value)
508 
509 
510 @internal
511 def _transfer(_from: address, _to: address, _value: uint256):
512     self._checkpoint(_from)
513     self._checkpoint(_to)
514 
515     if _value != 0:
516         total_supply: uint256 = self.totalSupply
517         is_rewards: bool = self.reward_count != 0
518         if is_rewards:
519             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
520         new_balance: uint256 = self.balanceOf[_from] - _value
521         self.balanceOf[_from] = new_balance
522         self._update_liquidity_limit(_from, new_balance, total_supply)
523 
524         if is_rewards:
525             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
526         new_balance = self.balanceOf[_to] + _value
527         self.balanceOf[_to] = new_balance
528         self._update_liquidity_limit(_to, new_balance, total_supply)
529 
530     log Transfer(_from, _to, _value)
531 
532 
533 @external
534 @nonreentrant('lock')
535 def transfer(_to : address, _value : uint256) -> bool:
536     """
537     @notice Transfer token for a specified address
538     @dev Transferring claims pending reward tokens for the sender and receiver
539     @param _to The address to transfer to.
540     @param _value The amount to be transferred.
541     """
542     self._transfer(msg.sender, _to, _value)
543 
544     return True
545 
546 
547 @external
548 @nonreentrant('lock')
549 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
550     """
551      @notice Transfer tokens from one address to another.
552      @dev Transferring claims pending reward tokens for the sender and receiver
553      @param _from address The address which you want to send tokens from
554      @param _to address The address which you want to transfer to
555      @param _value uint256 the amount of tokens to be transferred
556     """
557     _allowance: uint256 = self.allowance[_from][msg.sender]
558     if _allowance != MAX_UINT256:
559         self.allowance[_from][msg.sender] = _allowance - _value
560 
561     self._transfer(_from, _to, _value)
562 
563     return True
564 
565 
566 @external
567 def approve(_spender : address, _value : uint256) -> bool:
568     """
569     @notice Approve the passed address to transfer the specified amount of
570             tokens on behalf of msg.sender
571     @dev Beware that changing an allowance via this method brings the risk
572          that someone may use both the old and new allowance by unfortunate
573          transaction ordering. This may be mitigated with the use of
574          {incraseAllowance} and {decreaseAllowance}.
575          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
576     @param _spender The address which will transfer the funds
577     @param _value The amount of tokens that may be transferred
578     @return bool success
579     """
580     self.allowance[msg.sender][_spender] = _value
581     log Approval(msg.sender, _spender, _value)
582 
583     return True
584 
585 @external
586 def permit(
587   _owner: address,
588   _spender: address,
589   _value: uint256,
590   _deadline: uint256,
591   _v: uint8,
592   _r: bytes32,
593   _s: bytes32
594 ) -> bool:
595   """
596   @notice Approves spender by owner's signature to expend owner's tokens.
597       See https://eips.ethereum.org/EIPS/eip-2612.
598   @dev Inspired by https://github.com/yearn/yearn-vaults/blob/main/contracts/Vault.vy#L753-L793
599   @dev Supports smart contract wallets which implement ERC1271
600       https://eips.ethereum.org/EIPS/eip-1271
601   @param _owner The address which is a source of funds and has signed the Permit.
602   @param _spender The address which is allowed to spend the funds.
603   @param _value The amount of tokens to be spent.
604   @param _deadline The timestamp after which the Permit is no longer valid.
605   @param _v The bytes[64] of the valid secp256k1 signature of permit by owner
606   @param _r The bytes[0:32] of the valid secp256k1 signature of permit by owner
607   @param _s The bytes[32:64] of the valid secp256k1 signature of permit by owner
608   @return True, if transaction completes successfully
609   """
610   assert _owner != ZERO_ADDRESS
611   assert block.timestamp <= _deadline
612   nonce: uint256 = self.nonces[_owner]
613   digest: bytes32 = keccak256(
614       concat(
615           b"\x19\x01",
616           DOMAIN_SEPARATOR,
617           keccak256(_abi_encode(PERMIT_TYPEHASH, _owner, _spender, _value, nonce, _deadline))
618       )
619   )
620   if _owner.is_contract:
621       sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
622       assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
623   else:
624       assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
625   self.allowance[_owner][_spender] = _value
626   self.nonces[_owner] = nonce + 1
627   log Approval(_owner, _spender, _value)
628   return True
629 
630 @external
631 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
632     """
633     @notice Increase the allowance granted to `_spender` by the caller
634     @dev This is alternative to {approve} that can be used as a mitigation for
635          the potential race condition
636     @param _spender The address which will transfer the funds
637     @param _added_value The amount of to increase the allowance
638     @return bool success
639     """
640     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
641     self.allowance[msg.sender][_spender] = allowance
642 
643     log Approval(msg.sender, _spender, allowance)
644 
645     return True
646 
647 
648 @external
649 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
650     """
651     @notice Decrease the allowance granted to `_spender` by the caller
652     @dev This is alternative to {approve} that can be used as a mitigation for
653          the potential race condition
654     @param _spender The address which will transfer the funds
655     @param _subtracted_value The amount of to decrease the allowance
656     @return bool success
657     """
658     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
659     self.allowance[msg.sender][_spender] = allowance
660 
661     log Approval(msg.sender, _spender, allowance)
662 
663     return True
664 
665 
666 @external
667 def add_reward(_reward_token: address, _distributor: address):
668     """
669     @notice Set the active reward contract
670     """
671     assert msg.sender == self.admin  # dev: only owner
672 
673     reward_count: uint256 = self.reward_count
674     assert reward_count < MAX_REWARDS
675     assert self.reward_data[_reward_token].distributor == ZERO_ADDRESS
676 
677     self.reward_data[_reward_token].distributor = _distributor
678     self.reward_tokens[reward_count] = _reward_token
679     self.reward_count = reward_count + 1
680 
681 
682 @external
683 def set_reward_distributor(_reward_token: address, _distributor: address):
684     current_distributor: address = self.reward_data[_reward_token].distributor
685 
686     assert msg.sender == current_distributor or msg.sender == self.admin
687     assert current_distributor != ZERO_ADDRESS
688     assert _distributor != ZERO_ADDRESS
689 
690     self.reward_data[_reward_token].distributor = _distributor
691 
692 
693 @external
694 @nonreentrant("lock")
695 def deposit_reward_token(_reward_token: address, _amount: uint256):
696     assert msg.sender == self.reward_data[_reward_token].distributor
697 
698     self._checkpoint_rewards(ZERO_ADDRESS, self.totalSupply, False, ZERO_ADDRESS)
699 
700     response: Bytes[32] = raw_call(
701         _reward_token,
702         concat(
703             method_id("transferFrom(address,address,uint256)"),
704             convert(msg.sender, bytes32),
705             convert(self, bytes32),
706             convert(_amount, bytes32),
707         ),
708         max_outsize=32,
709     )
710     if len(response) != 0:
711         assert convert(response, bool)
712 
713     period_finish: uint256 = self.reward_data[_reward_token].period_finish
714     if block.timestamp >= period_finish:
715         self.reward_data[_reward_token].rate = _amount / WEEK
716     else:
717         remaining: uint256 = period_finish - block.timestamp
718         leftover: uint256 = remaining * self.reward_data[_reward_token].rate
719         self.reward_data[_reward_token].rate = (_amount + leftover) / WEEK
720 
721     self.reward_data[_reward_token].last_update = block.timestamp
722     self.reward_data[_reward_token].period_finish = block.timestamp + WEEK
723 
724 
725 @external
726 def set_killed(_is_killed: bool):
727     """
728     @notice Set the killed status for this contract
729     @dev When killed, the gauge always yields a rate of 0 and so cannot mint CRV
730     @param _is_killed Killed status to set
731     """
732     assert msg.sender == self.admin
733 
734     self.is_killed = _is_killed
735 
736 
737 @external
738 def commit_transfer_ownership(addr: address):
739     """
740     @notice Transfer ownership of GaugeController to `addr`
741     @param addr Address to have ownership transferred to
742     """
743     assert msg.sender == self.admin  # dev: admin only
744 
745     self.future_admin = addr
746     log CommitOwnership(addr)
747 
748 
749 @external
750 def accept_transfer_ownership():
751     """
752     @notice Accept a pending ownership transfer
753     """
754     _admin: address = self.future_admin
755     assert msg.sender == _admin  # dev: future admin only
756 
757     self.admin = _admin
758     log ApplyOwnership(_admin)
759 
760 @view
761 @external
762 def name() -> String[64]:
763   """
764   @notice Get the name for this gauge token
765   """
766   return NAME
767 
768 @view
769 @external
770 def symbol() -> String[32]:
771   """
772   @notice Get the symbol for this gauge token
773   """
774   return SYMBOL
775 
776 @view
777 @external
778 def decimals() -> uint256:
779   """
780   @notice Get the number of decimals for this token
781   @dev Implemented as a view method to reduce gas costs
782   @return uint256 decimal places
783   """
784   return 18
785 
786 @view
787 @external
788 def minter() -> address:
789   """
790   @notice Query the minter
791   """
792   return MINTER
793 
794 @view
795 @external
796 def rbn_token() -> address:
797   """
798   @notice Query the crv token
799   """
800   return RBN_TOKEN
801 
802 @view
803 @external
804 def controller() -> address:
805   """
806   @notice Query the controller
807   """
808   return CONTROLLER
809 
810 @view
811 @external
812 def voting_escrow() -> address:
813   """
814   @notice Query the voting escrow
815   """
816   return VOTING_ESCROW
817 
818 @view
819 @external
820 def veboost_proxy() -> address:
821   """
822   @notice Query the veboost proxy
823   """
824   return VEBOOST_PROXY
825 
826 @view
827 @external
828 def lp_token() -> address:
829   """
830   @notice Query the lp token used for this gauge
831   """
832   return LP_TOKEN
833 
834 @view
835 @external
836 def version() -> String[8]:
837   """
838   @notice Get the version of this gauge
839   """
840   return VERSION
841 
842 @view
843 @external
844 def DOMAIN_SEPARATOR() -> bytes32:
845   """
846   @notice Domain separator for this contract
847   """
848   return DOMAIN_SEPARATOR