1 # @version 0.2.15
2 """
3 @title Liquidity Gauge
4 @author Curve Finance
5 @license MIT
6 @notice Implementation contract for use with Curve Factory
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 implements: ERC20
12 
13 
14 interface CRV20:
15     def future_epoch_time_write() -> uint256: nonpayable
16     def rate() -> uint256: view
17 
18 interface Controller:
19     def period() -> int128: view
20     def period_write() -> int128: nonpayable
21     def period_timestamp(p: int128) -> uint256: view
22     def gauge_relative_weight(addr: address, time: uint256) -> uint256: view
23     def voting_escrow() -> address: view
24     def checkpoint(): nonpayable
25     def checkpoint_gauge(addr: address): nonpayable
26 
27 interface Minter:
28     def token() -> address: view
29     def controller() -> address: view
30     def minted(user: address, gauge: address) -> uint256: view
31 
32 interface VotingEscrow:
33     def user_point_epoch(addr: address) -> uint256: view
34     def user_point_history__ts(addr: address, epoch: uint256) -> uint256: view
35 
36 interface VotingEscrowBoost:
37     def adjusted_balance_of(_account: address) -> uint256: view
38 
39 interface ERC20Extended:
40     def symbol() -> String[26]: view
41 
42 interface Factory:
43     def admin() -> address: view
44 
45 
46 event Deposit:
47     provider: indexed(address)
48     value: uint256
49 
50 event Withdraw:
51     provider: indexed(address)
52     value: uint256
53 
54 event UpdateLiquidityLimit:
55     user: address
56     original_balance: uint256
57     original_supply: uint256
58     working_balance: uint256
59     working_supply: uint256
60 
61 event CommitOwnership:
62     admin: address
63 
64 event ApplyOwnership:
65     admin: address
66 
67 event Transfer:
68     _from: indexed(address)
69     _to: indexed(address)
70     _value: uint256
71 
72 event Approval:
73     _owner: indexed(address)
74     _spender: indexed(address)
75     _value: uint256
76 
77 
78 struct Reward:
79     token: address
80     distributor: address
81     period_finish: uint256
82     rate: uint256
83     last_update: uint256
84     integral: uint256
85 
86 
87 MAX_REWARDS: constant(uint256) = 8
88 TOKENLESS_PRODUCTION: constant(uint256) = 40
89 WEEK: constant(uint256) = 604800
90 CLAIM_FREQUENCY: constant(uint256) = 3600
91 
92 MINTER: constant(address) = 0xd061D61a4d941c39E5453435B6345Dc261C2fcE0
93 CRV: constant(address) = 0xD533a949740bb3306d119CC777fa900bA034cd52
94 VOTING_ESCROW: constant(address) = 0x5f3b5DfEb7B28CDbD7FAba78963EE202a494e2A2
95 GAUGE_CONTROLLER: constant(address) = 0x2F50D538606Fa9EDD2B11E2446BEb18C9D5846bB
96 VEBOOST_PROXY: constant(address) = 0x8E0c00ed546602fD9927DF742bbAbF726D5B0d16
97 
98 
99 lp_token: public(address)
100 future_epoch_time: public(uint256)
101 
102 balanceOf: public(HashMap[address, uint256])
103 totalSupply: public(uint256)
104 allowance: public(HashMap[address, HashMap[address, uint256]])
105 
106 name: public(String[64])
107 symbol: public(String[32])
108 
109 working_balances: public(HashMap[address, uint256])
110 working_supply: public(uint256)
111 
112 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
113 # All values are kept in units of being multiplied by 1e18
114 period: public(int128)
115 period_timestamp: public(uint256[100000000000000000000000000000])
116 
117 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
118 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
119 
120 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
121 integrate_inv_supply_of: public(HashMap[address, uint256])
122 integrate_checkpoint_of: public(HashMap[address, uint256])
123 
124 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
125 # Units: rate * t = already number of coins per address to issue
126 integrate_fraction: public(HashMap[address, uint256])
127 
128 inflation_rate: public(uint256)
129 
130 # For tracking external rewards
131 reward_count: public(uint256)
132 reward_tokens: public(address[MAX_REWARDS])
133 
134 reward_data: public(HashMap[address, Reward])
135 
136 # claimant -> default reward receiver
137 rewards_receiver: public(HashMap[address, address])
138 
139 # reward token -> claiming address -> integral
140 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
141 
142 # user -> [uint128 claimable amount][uint128 claimed amount]
143 claim_data: HashMap[address, HashMap[address, uint256]]
144 
145 is_killed: public(bool)
146 factory: public(address)
147 
148 @external
149 def __init__():
150     self.lp_token = 0x000000000000000000000000000000000000dEaD
151 
152 
153 @external
154 def initialize(_lp_token: address):
155     """
156     @notice Contract constructor
157     @param _lp_token Liquidity Pool contract address
158     """
159 
160     assert self.lp_token == ZERO_ADDRESS
161     self.lp_token = _lp_token
162     self.factory = msg.sender
163 
164     symbol: String[26] = ERC20Extended(_lp_token).symbol()
165     self.name = concat("Curve.fi ", symbol, " Gauge Deposit")
166     self.symbol = concat(symbol, "-gauge")
167 
168     self.period_timestamp[0] = block.timestamp
169     self.inflation_rate = CRV20(CRV).rate()
170     self.future_epoch_time = CRV20(CRV).future_epoch_time_write()
171 
172 
173 @view
174 @external
175 def decimals() -> uint256:
176     """
177     @notice Get the number of decimals for this token
178     @dev Implemented as a view method to reduce gas costs
179     @return uint256 decimal places
180     """
181     return 18
182 
183 
184 @view
185 @external
186 def integrate_checkpoint() -> uint256:
187     return self.period_timestamp[self.period]
188 
189 
190 @internal
191 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
192     """
193     @notice Calculate limits which depend on the amount of CRV token per-user.
194             Effectively it calculates working balances to apply amplification
195             of CRV production by CRV
196     @param addr User address
197     @param l User's amount of liquidity (LP tokens)
198     @param L Total amount of liquidity (LP tokens)
199     """
200     # To be called after totalSupply is updated
201     voting_balance: uint256 = VotingEscrowBoost(VEBOOST_PROXY).adjusted_balance_of(addr)
202     voting_total: uint256 = ERC20(VOTING_ESCROW).totalSupply()
203 
204     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
205     if voting_total > 0:
206         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
207 
208     lim = min(l, lim)
209     old_bal: uint256 = self.working_balances[addr]
210     self.working_balances[addr] = lim
211     _working_supply: uint256 = self.working_supply + lim - old_bal
212     self.working_supply = _working_supply
213 
214     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
215 
216 
217 @internal
218 def _checkpoint_rewards(_user: address, _total_supply: uint256, _claim: bool, _receiver: address):
219     """
220     @notice Claim pending rewards and checkpoint rewards for a user
221     """
222 
223     user_balance: uint256 = 0
224     receiver: address = _receiver
225     if _user != ZERO_ADDRESS:
226         user_balance = self.balanceOf[_user]
227         if _claim and _receiver == ZERO_ADDRESS:
228             # if receiver is not explicitly declared, check if a default receiver is set
229             receiver = self.rewards_receiver[_user]
230             if receiver == ZERO_ADDRESS:
231                 # if no default receiver is set, direct claims to the user
232                 receiver = _user
233 
234     reward_count: uint256 = self.reward_count
235     for i in range(MAX_REWARDS):
236         if i == reward_count:
237             break
238         token: address = self.reward_tokens[i]
239 
240         integral: uint256 = self.reward_data[token].integral
241         last_update: uint256 = min(block.timestamp, self.reward_data[token].period_finish)
242         duration: uint256 = last_update - self.reward_data[token].last_update
243         if duration != 0:
244             self.reward_data[token].last_update = last_update
245             if _total_supply != 0:
246                 integral += duration * self.reward_data[token].rate * 10**18 / _total_supply
247                 self.reward_data[token].integral = integral
248 
249         if _user != ZERO_ADDRESS:
250             integral_for: uint256 = self.reward_integral_for[token][_user]
251             new_claimable: uint256 = 0
252 
253             if integral_for < integral:
254                 self.reward_integral_for[token][_user] = integral
255                 new_claimable = user_balance * (integral - integral_for) / 10**18
256 
257             claim_data: uint256 = self.claim_data[_user][token]
258             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
259             if total_claimable > 0:
260                 total_claimed: uint256 = claim_data % 2**128
261                 if _claim:
262                     response: Bytes[32] = raw_call(
263                         token,
264                         concat(
265                             method_id("transfer(address,uint256)"),
266                             convert(receiver, bytes32),
267                             convert(total_claimable, bytes32),
268                         ),
269                         max_outsize=32,
270                     )
271                     if len(response) != 0:
272                         assert convert(response, bool)
273                     self.claim_data[_user][token] = total_claimed + total_claimable
274                 elif new_claimable > 0:
275                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
276 
277 
278 @internal
279 def _checkpoint(addr: address):
280     """
281     @notice Checkpoint for a user
282     @param addr User address
283     """
284     _period: int128 = self.period
285     _period_time: uint256 = self.period_timestamp[_period]
286     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
287     rate: uint256 = self.inflation_rate
288     new_rate: uint256 = rate
289     prev_future_epoch: uint256 = self.future_epoch_time
290     if prev_future_epoch >= _period_time:
291         self.future_epoch_time = CRV20(CRV).future_epoch_time_write()
292         new_rate = CRV20(CRV).rate()
293         self.inflation_rate = new_rate
294 
295     if self.is_killed:
296         # Stop distributing inflation as soon as killed
297         rate = 0
298 
299     # Update integral of 1/supply
300     if block.timestamp > _period_time:
301         _working_supply: uint256 = self.working_supply
302         Controller(GAUGE_CONTROLLER).checkpoint_gauge(self)
303         prev_week_time: uint256 = _period_time
304         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
305 
306         for i in range(500):
307             dt: uint256 = week_time - prev_week_time
308             w: uint256 = Controller(GAUGE_CONTROLLER).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
309 
310             if _working_supply > 0:
311                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
312                     # If we went across one or multiple epochs, apply the rate
313                     # of the first epoch until it ends, and then the rate of
314                     # the last epoch.
315                     # If more than one epoch is crossed - the gauge gets less,
316                     # but that'd meen it wasn't called for more than 1 year
317                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
318                     rate = new_rate
319                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
320                 else:
321                     _integrate_inv_supply += rate * w * dt / _working_supply
322                 # On precisions of the calculation
323                 # rate ~= 10e18
324                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
325                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
326                 # The largest loss is at dt = 1
327                 # Loss is 1e-9 - acceptable
328 
329             if week_time == block.timestamp:
330                 break
331             prev_week_time = week_time
332             week_time = min(week_time + WEEK, block.timestamp)
333 
334     _period += 1
335     self.period = _period
336     self.period_timestamp[_period] = block.timestamp
337     self.integrate_inv_supply[_period] = _integrate_inv_supply
338 
339     # Update user-specific integrals
340     _working_balance: uint256 = self.working_balances[addr]
341     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
342     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
343     self.integrate_checkpoint_of[addr] = block.timestamp
344 
345 
346 @external
347 def user_checkpoint(addr: address) -> bool:
348     """
349     @notice Record a checkpoint for `addr`
350     @param addr User address
351     @return bool success
352     """
353     assert msg.sender in [addr, MINTER]  # dev: unauthorized
354     self._checkpoint(addr)
355     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
356     return True
357 
358 
359 @external
360 def claimable_tokens(addr: address) -> uint256:
361     """
362     @notice Get the number of claimable tokens per user
363     @dev This function should be manually changed to "view" in the ABI
364     @return uint256 number of claimable tokens per user
365     """
366     self._checkpoint(addr)
367     return self.integrate_fraction[addr] - Minter(MINTER).minted(addr, self)
368 
369 
370 @view
371 @external
372 def claimed_reward(_addr: address, _token: address) -> uint256:
373     """
374     @notice Get the number of already-claimed reward tokens for a user
375     @param _addr Account to get reward amount for
376     @param _token Token to get reward amount for
377     @return uint256 Total amount of `_token` already claimed by `_addr`
378     """
379     return self.claim_data[_addr][_token] % 2**128
380 
381 
382 @view
383 @external
384 def claimable_reward(_user: address, _reward_token: address) -> uint256:
385     """
386     @notice Get the number of claimable reward tokens for a user
387     @param _user Account to get reward amount for
388     @param _reward_token Token to get reward amount for
389     @return uint256 Claimable reward token amount
390     """
391     integral: uint256 = self.reward_data[_reward_token].integral
392     total_supply: uint256 = self.totalSupply
393     if total_supply != 0:
394         last_update: uint256 = min(block.timestamp, self.reward_data[_reward_token].period_finish)
395         duration: uint256 = last_update - self.reward_data[_reward_token].last_update
396         integral += (duration * self.reward_data[_reward_token].rate * 10**18 / total_supply)
397 
398     integral_for: uint256 = self.reward_integral_for[_reward_token][_user]
399     new_claimable: uint256 = self.balanceOf[_user] * (integral - integral_for) / 10**18
400 
401     return shift(self.claim_data[_user][_reward_token], -128) + new_claimable
402 
403 
404 @external
405 def set_rewards_receiver(_receiver: address):
406     """
407     @notice Set the default reward receiver for the caller.
408     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
409     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
410     """
411     self.rewards_receiver[msg.sender] = _receiver
412 
413 
414 @external
415 @nonreentrant('lock')
416 def claim_rewards(_addr: address = msg.sender, _receiver: address = ZERO_ADDRESS):
417     """
418     @notice Claim available reward tokens for `_addr`
419     @param _addr Address to claim for
420     @param _receiver Address to transfer rewards to - if set to
421                      ZERO_ADDRESS, uses the default reward receiver
422                      for the caller
423     """
424     if _receiver != ZERO_ADDRESS:
425         assert _addr == msg.sender  # dev: cannot redirect when claiming for another user
426     self._checkpoint_rewards(_addr, self.totalSupply, True, _receiver)
427 
428 
429 @external
430 def kick(addr: address):
431     """
432     @notice Kick `addr` for abusing their boost
433     @dev Only if either they had another voting event, or their voting escrow lock expired
434     @param addr Address to kick
435     """
436     t_last: uint256 = self.integrate_checkpoint_of[addr]
437     t_ve: uint256 = VotingEscrow(VOTING_ESCROW).user_point_history__ts(
438         addr, VotingEscrow(VOTING_ESCROW).user_point_epoch(addr)
439     )
440     _balance: uint256 = self.balanceOf[addr]
441 
442     assert ERC20(VOTING_ESCROW).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
443     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
444 
445     self._checkpoint(addr)
446     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
447 
448 
449 @external
450 @nonreentrant('lock')
451 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
452     """
453     @notice Deposit `_value` LP tokens
454     @dev Depositting also claims pending reward tokens
455     @param _value Number of tokens to deposit
456     @param _addr Address to deposit for
457     """
458 
459     self._checkpoint(_addr)
460 
461     if _value != 0:
462         is_rewards: bool = self.reward_count != 0
463         total_supply: uint256 = self.totalSupply
464         if is_rewards:
465             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
466 
467         total_supply += _value
468         new_balance: uint256 = self.balanceOf[_addr] + _value
469         self.balanceOf[_addr] = new_balance
470         self.totalSupply = total_supply
471 
472         self._update_liquidity_limit(_addr, new_balance, total_supply)
473 
474         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
475 
476     log Deposit(_addr, _value)
477     log Transfer(ZERO_ADDRESS, _addr, _value)
478 
479 
480 @external
481 @nonreentrant('lock')
482 def withdraw(_value: uint256, _claim_rewards: bool = False):
483     """
484     @notice Withdraw `_value` LP tokens
485     @dev Withdrawing also claims pending reward tokens
486     @param _value Number of tokens to withdraw
487     """
488     self._checkpoint(msg.sender)
489 
490     if _value != 0:
491         is_rewards: bool = self.reward_count != 0
492         total_supply: uint256 = self.totalSupply
493         if is_rewards:
494             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
495 
496         total_supply -= _value
497         new_balance: uint256 = self.balanceOf[msg.sender] - _value
498         self.balanceOf[msg.sender] = new_balance
499         self.totalSupply = total_supply
500 
501         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
502 
503         ERC20(self.lp_token).transfer(msg.sender, _value)
504 
505     log Withdraw(msg.sender, _value)
506     log Transfer(msg.sender, ZERO_ADDRESS, _value)
507 
508 
509 @internal
510 def _transfer(_from: address, _to: address, _value: uint256):
511     self._checkpoint(_from)
512     self._checkpoint(_to)
513 
514     if _value != 0:
515         total_supply: uint256 = self.totalSupply
516         is_rewards: bool = self.reward_count != 0
517         if is_rewards:
518             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
519         new_balance: uint256 = self.balanceOf[_from] - _value
520         self.balanceOf[_from] = new_balance
521         self._update_liquidity_limit(_from, new_balance, total_supply)
522 
523         if is_rewards:
524             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
525         new_balance = self.balanceOf[_to] + _value
526         self.balanceOf[_to] = new_balance
527         self._update_liquidity_limit(_to, new_balance, total_supply)
528 
529     log Transfer(_from, _to, _value)
530 
531 
532 @external
533 @nonreentrant('lock')
534 def transfer(_to : address, _value : uint256) -> bool:
535     """
536     @notice Transfer token for a specified address
537     @dev Transferring claims pending reward tokens for the sender and receiver
538     @param _to The address to transfer to.
539     @param _value The amount to be transferred.
540     """
541     self._transfer(msg.sender, _to, _value)
542 
543     return True
544 
545 
546 @external
547 @nonreentrant('lock')
548 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
549     """
550      @notice Transfer tokens from one address to another.
551      @dev Transferring claims pending reward tokens for the sender and receiver
552      @param _from address The address which you want to send tokens from
553      @param _to address The address which you want to transfer to
554      @param _value uint256 the amount of tokens to be transferred
555     """
556     _allowance: uint256 = self.allowance[_from][msg.sender]
557     if _allowance != MAX_UINT256:
558         self.allowance[_from][msg.sender] = _allowance - _value
559 
560     self._transfer(_from, _to, _value)
561 
562     return True
563 
564 
565 @external
566 def approve(_spender : address, _value : uint256) -> bool:
567     """
568     @notice Approve the passed address to transfer the specified amount of
569             tokens on behalf of msg.sender
570     @dev Beware that changing an allowance via this method brings the risk
571          that someone may use both the old and new allowance by unfortunate
572          transaction ordering. This may be mitigated with the use of
573          {incraseAllowance} and {decreaseAllowance}.
574          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
575     @param _spender The address which will transfer the funds
576     @param _value The amount of tokens that may be transferred
577     @return bool success
578     """
579     self.allowance[msg.sender][_spender] = _value
580     log Approval(msg.sender, _spender, _value)
581 
582     return True
583 
584 
585 @external
586 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
587     """
588     @notice Increase the allowance granted to `_spender` by the caller
589     @dev This is alternative to {approve} that can be used as a mitigation for
590          the potential race condition
591     @param _spender The address which will transfer the funds
592     @param _added_value The amount of to increase the allowance
593     @return bool success
594     """
595     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
596     self.allowance[msg.sender][_spender] = allowance
597 
598     log Approval(msg.sender, _spender, allowance)
599 
600     return True
601 
602 
603 @external
604 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
605     """
606     @notice Decrease the allowance granted to `_spender` by the caller
607     @dev This is alternative to {approve} that can be used as a mitigation for
608          the potential race condition
609     @param _spender The address which will transfer the funds
610     @param _subtracted_value The amount of to decrease the allowance
611     @return bool success
612     """
613     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
614     self.allowance[msg.sender][_spender] = allowance
615 
616     log Approval(msg.sender, _spender, allowance)
617 
618     return True
619 
620 
621 @external
622 def add_reward(_reward_token: address, _distributor: address):
623     """
624     @notice Set the active reward contract
625     """
626     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
627 
628     reward_count: uint256 = self.reward_count
629     assert reward_count < MAX_REWARDS
630     assert self.reward_data[_reward_token].distributor == ZERO_ADDRESS
631 
632     self.reward_data[_reward_token].distributor = _distributor
633     self.reward_tokens[reward_count] = _reward_token
634     self.reward_count = reward_count + 1
635 
636 
637 @external
638 def set_reward_distributor(_reward_token: address, _distributor: address):
639     current_distributor: address = self.reward_data[_reward_token].distributor
640 
641     assert msg.sender == current_distributor or msg.sender == Factory(self.factory).admin()
642     assert current_distributor != ZERO_ADDRESS
643     assert _distributor != ZERO_ADDRESS
644 
645     self.reward_data[_reward_token].distributor = _distributor
646 
647 
648 @external
649 @nonreentrant("lock")
650 def deposit_reward_token(_reward_token: address, _amount: uint256):
651     assert msg.sender == self.reward_data[_reward_token].distributor
652 
653     self._checkpoint_rewards(ZERO_ADDRESS, self.totalSupply, False, ZERO_ADDRESS)
654 
655     response: Bytes[32] = raw_call(
656         _reward_token,
657         concat(
658             method_id("transferFrom(address,address,uint256)"),
659             convert(msg.sender, bytes32),
660             convert(self, bytes32),
661             convert(_amount, bytes32),
662         ),
663         max_outsize=32,
664     )
665     if len(response) != 0:
666         assert convert(response, bool)
667 
668     period_finish: uint256 = self.reward_data[_reward_token].period_finish
669     if block.timestamp >= period_finish:
670         self.reward_data[_reward_token].rate = _amount / WEEK
671     else:
672         remaining: uint256 = period_finish - block.timestamp
673         leftover: uint256 = remaining * self.reward_data[_reward_token].rate
674         self.reward_data[_reward_token].rate = (_amount + leftover) / WEEK
675 
676     self.reward_data[_reward_token].last_update = block.timestamp
677     self.reward_data[_reward_token].period_finish = block.timestamp + WEEK
678 
679 
680 @external
681 def set_killed(_is_killed: bool):
682     """
683     @notice Set the killed status for this contract
684     @dev When killed, the gauge always yields a rate of 0 and so cannot mint CRV
685     @param _is_killed Killed status to set
686     """
687     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
688 
689     self.is_killed = _is_killed