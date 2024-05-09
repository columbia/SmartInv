1 # @version 0.2.16
2 """
3 @title Liquidity Gauge v4
4 @author Curve Finance
5 @license MIT
6 """
7 
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
18     def period() -> int128: view
19     def period_write() -> int128: nonpayable
20     def period_timestamp(p: int128) -> uint256: view
21     def gauge_relative_weight(addr: address, time: uint256) -> uint256: view
22     def voting_escrow() -> address: view
23     def checkpoint(): nonpayable
24     def checkpoint_gauge(addr: address): nonpayable
25 
26 interface Minter:
27     def token() -> address: view
28     def controller() -> address: view
29     def minted(user: address, gauge: address) -> uint256: view
30 
31 interface VotingEscrow:
32     def user_point_epoch(addr: address) -> uint256: view
33     def user_point_history__ts(addr: address, epoch: uint256) -> uint256: view
34 
35 interface VotingEscrowBoost:
36     def adjusted_balance_of(_account: address) -> uint256: view
37 
38 interface ERC20Extended:
39     def symbol() -> String[26]: view
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
82 
83 MAX_REWARDS: constant(uint256) = 8
84 TOKENLESS_PRODUCTION: constant(uint256) = 40
85 WEEK: constant(uint256) = 604800
86 
87 MINTER: constant(address) = 0xd061D61a4d941c39E5453435B6345Dc261C2fcE0
88 CRV: constant(address) = 0xD533a949740bb3306d119CC777fa900bA034cd52
89 VOTING_ESCROW: constant(address) = 0x5f3b5DfEb7B28CDbD7FAba78963EE202a494e2A2
90 GAUGE_CONTROLLER: constant(address) = 0x2F50D538606Fa9EDD2B11E2446BEb18C9D5846bB
91 VEBOOST_PROXY: constant(address) = 0x8E0c00ed546602fD9927DF742bbAbF726D5B0d16
92 
93 
94 lp_token: public(address)
95 future_epoch_time: public(uint256)
96 
97 balanceOf: public(HashMap[address, uint256])
98 totalSupply: public(uint256)
99 allowance: public(HashMap[address, HashMap[address, uint256]])
100 
101 name: public(String[64])
102 symbol: public(String[32])
103 
104 working_balances: public(HashMap[address, uint256])
105 working_supply: public(uint256)
106 
107 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
108 # All values are kept in units of being multiplied by 1e18
109 period: public(int128)
110 period_timestamp: public(uint256[100000000000000000000000000000])
111 
112 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
113 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
114 
115 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
116 integrate_inv_supply_of: public(HashMap[address, uint256])
117 integrate_checkpoint_of: public(HashMap[address, uint256])
118 
119 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
120 # Units: rate * t = already number of coins per address to issue
121 integrate_fraction: public(HashMap[address, uint256])
122 
123 inflation_rate: public(uint256)
124 
125 # For tracking external rewards
126 reward_count: public(uint256)
127 reward_tokens: public(address[MAX_REWARDS])
128 
129 reward_data: public(HashMap[address, Reward])
130 
131 # claimant -> default reward receiver
132 rewards_receiver: public(HashMap[address, address])
133 
134 # reward token -> claiming address -> integral
135 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
136 
137 # user -> [uint128 claimable amount][uint128 claimed amount]
138 claim_data: HashMap[address, HashMap[address, uint256]]
139 
140 admin: public(address)
141 future_admin: public(address)
142 is_killed: public(bool)
143 
144 
145 @external
146 def __init__(_lp_token: address, _admin: address):
147     """
148     @notice Contract constructor
149     @param _lp_token Liquidity Pool contract address
150     @param _admin Admin who can kill the gauge
151     """
152 
153     self.lp_token = _lp_token
154     self.admin = _admin
155 
156     symbol: String[26] = ERC20Extended(_lp_token).symbol()
157     self.name = concat("Curve.fi ", symbol, " Gauge Deposit")
158     self.symbol = concat(symbol, "-gauge")
159 
160     self.period_timestamp[0] = block.timestamp
161     self.inflation_rate = CRV20(CRV).rate()
162     self.future_epoch_time = CRV20(CRV).future_epoch_time_write()
163 
164 
165 @view
166 @external
167 def decimals() -> uint256:
168     """
169     @notice Get the number of decimals for this token
170     @dev Implemented as a view method to reduce gas costs
171     @return uint256 decimal places
172     """
173     return 18
174 
175 
176 @view
177 @external
178 def integrate_checkpoint() -> uint256:
179     return self.period_timestamp[self.period]
180 
181 
182 @internal
183 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
184     """
185     @notice Calculate limits which depend on the amount of CRV token per-user.
186             Effectively it calculates working balances to apply amplification
187             of CRV production by CRV
188     @param addr User address
189     @param l User's amount of liquidity (LP tokens)
190     @param L Total amount of liquidity (LP tokens)
191     """
192     # To be called after totalSupply is updated
193     voting_balance: uint256 = VotingEscrowBoost(VEBOOST_PROXY).adjusted_balance_of(addr)
194     voting_total: uint256 = ERC20(VOTING_ESCROW).totalSupply()
195 
196     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
197     if voting_total > 0:
198         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
199 
200     lim = min(l, lim)
201     old_bal: uint256 = self.working_balances[addr]
202     self.working_balances[addr] = lim
203     _working_supply: uint256 = self.working_supply + lim - old_bal
204     self.working_supply = _working_supply
205 
206     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
207 
208 
209 @internal
210 def _checkpoint_rewards(_user: address, _total_supply: uint256, _claim: bool, _receiver: address):
211     """
212     @notice Claim pending rewards and checkpoint rewards for a user
213     """
214 
215     user_balance: uint256 = 0
216     receiver: address = _receiver
217     if _user != ZERO_ADDRESS:
218         user_balance = self.balanceOf[_user]
219         if _claim and _receiver == ZERO_ADDRESS:
220             # if receiver is not explicitly declared, check if a default receiver is set
221             receiver = self.rewards_receiver[_user]
222             if receiver == ZERO_ADDRESS:
223                 # if no default receiver is set, direct claims to the user
224                 receiver = _user
225 
226     reward_count: uint256 = self.reward_count
227     for i in range(MAX_REWARDS):
228         if i == reward_count:
229             break
230         token: address = self.reward_tokens[i]
231 
232         integral: uint256 = self.reward_data[token].integral
233         last_update: uint256 = min(block.timestamp, self.reward_data[token].period_finish)
234         duration: uint256 = last_update - self.reward_data[token].last_update
235         if duration != 0:
236             self.reward_data[token].last_update = last_update
237             if _total_supply != 0:
238                 integral += duration * self.reward_data[token].rate * 10**18 / _total_supply
239                 self.reward_data[token].integral = integral
240 
241         if _user != ZERO_ADDRESS:
242             integral_for: uint256 = self.reward_integral_for[token][_user]
243             new_claimable: uint256 = 0
244 
245             if integral_for < integral:
246                 self.reward_integral_for[token][_user] = integral
247                 new_claimable = user_balance * (integral - integral_for) / 10**18
248 
249             claim_data: uint256 = self.claim_data[_user][token]
250             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
251             if total_claimable > 0:
252                 total_claimed: uint256 = claim_data % 2**128
253                 if _claim:
254                     response: Bytes[32] = raw_call(
255                         token,
256                         concat(
257                             method_id("transfer(address,uint256)"),
258                             convert(receiver, bytes32),
259                             convert(total_claimable, bytes32),
260                         ),
261                         max_outsize=32,
262                     )
263                     if len(response) != 0:
264                         assert convert(response, bool)
265                     self.claim_data[_user][token] = total_claimed + total_claimable
266                 elif new_claimable > 0:
267                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
268 
269 
270 @internal
271 def _checkpoint(addr: address):
272     """
273     @notice Checkpoint for a user
274     @param addr User address
275     """
276     _period: int128 = self.period
277     _period_time: uint256 = self.period_timestamp[_period]
278     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
279     rate: uint256 = self.inflation_rate
280     new_rate: uint256 = rate
281     prev_future_epoch: uint256 = self.future_epoch_time
282     if prev_future_epoch >= _period_time:
283         self.future_epoch_time = CRV20(CRV).future_epoch_time_write()
284         new_rate = CRV20(CRV).rate()
285         self.inflation_rate = new_rate
286 
287     if self.is_killed:
288         # Stop distributing inflation as soon as killed
289         rate = 0
290 
291     # Update integral of 1/supply
292     if block.timestamp > _period_time:
293         _working_supply: uint256 = self.working_supply
294         Controller(GAUGE_CONTROLLER).checkpoint_gauge(self)
295         prev_week_time: uint256 = _period_time
296         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
297 
298         for i in range(500):
299             dt: uint256 = week_time - prev_week_time
300             w: uint256 = Controller(GAUGE_CONTROLLER).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
301 
302             if _working_supply > 0:
303                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
304                     # If we went across one or multiple epochs, apply the rate
305                     # of the first epoch until it ends, and then the rate of
306                     # the last epoch.
307                     # If more than one epoch is crossed - the gauge gets less,
308                     # but that'd meen it wasn't called for more than 1 year
309                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
310                     rate = new_rate
311                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
312                 else:
313                     _integrate_inv_supply += rate * w * dt / _working_supply
314                 # On precisions of the calculation
315                 # rate ~= 10e18
316                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
317                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
318                 # The largest loss is at dt = 1
319                 # Loss is 1e-9 - acceptable
320 
321             if week_time == block.timestamp:
322                 break
323             prev_week_time = week_time
324             week_time = min(week_time + WEEK, block.timestamp)
325 
326     _period += 1
327     self.period = _period
328     self.period_timestamp[_period] = block.timestamp
329     self.integrate_inv_supply[_period] = _integrate_inv_supply
330 
331     # Update user-specific integrals
332     _working_balance: uint256 = self.working_balances[addr]
333     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
334     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
335     self.integrate_checkpoint_of[addr] = block.timestamp
336 
337 
338 @external
339 def user_checkpoint(addr: address) -> bool:
340     """
341     @notice Record a checkpoint for `addr`
342     @param addr User address
343     @return bool success
344     """
345     assert msg.sender in [addr, MINTER]  # dev: unauthorized
346     self._checkpoint(addr)
347     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
348     return True
349 
350 
351 @external
352 def claimable_tokens(addr: address) -> uint256:
353     """
354     @notice Get the number of claimable tokens per user
355     @dev This function should be manually changed to "view" in the ABI
356     @return uint256 number of claimable tokens per user
357     """
358     self._checkpoint(addr)
359     return self.integrate_fraction[addr] - Minter(MINTER).minted(addr, self)
360 
361 
362 @view
363 @external
364 def claimed_reward(_addr: address, _token: address) -> uint256:
365     """
366     @notice Get the number of already-claimed reward tokens for a user
367     @param _addr Account to get reward amount for
368     @param _token Token to get reward amount for
369     @return uint256 Total amount of `_token` already claimed by `_addr`
370     """
371     return self.claim_data[_addr][_token] % 2**128
372 
373 
374 @view
375 @external
376 def claimable_reward(_user: address, _reward_token: address) -> uint256:
377     """
378     @notice Get the number of claimable reward tokens for a user
379     @param _user Account to get reward amount for
380     @param _reward_token Token to get reward amount for
381     @return uint256 Claimable reward token amount
382     """
383     integral: uint256 = self.reward_data[_reward_token].integral
384     total_supply: uint256 = self.totalSupply
385     if total_supply != 0:
386         last_update: uint256 = min(block.timestamp, self.reward_data[_reward_token].period_finish)
387         duration: uint256 = last_update - self.reward_data[_reward_token].last_update
388         integral += (duration * self.reward_data[_reward_token].rate * 10**18 / total_supply)
389 
390     integral_for: uint256 = self.reward_integral_for[_reward_token][_user]
391     new_claimable: uint256 = self.balanceOf[_user] * (integral - integral_for) / 10**18
392 
393     return shift(self.claim_data[_user][_reward_token], -128) + new_claimable
394 
395 
396 @external
397 def set_rewards_receiver(_receiver: address):
398     """
399     @notice Set the default reward receiver for the caller.
400     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
401     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
402     """
403     self.rewards_receiver[msg.sender] = _receiver
404 
405 
406 @external
407 @nonreentrant('lock')
408 def claim_rewards(_addr: address = msg.sender, _receiver: address = ZERO_ADDRESS):
409     """
410     @notice Claim available reward tokens for `_addr`
411     @param _addr Address to claim for
412     @param _receiver Address to transfer rewards to - if set to
413                      ZERO_ADDRESS, uses the default reward receiver
414                      for the caller
415     """
416     if _receiver != ZERO_ADDRESS:
417         assert _addr == msg.sender  # dev: cannot redirect when claiming for another user
418     self._checkpoint_rewards(_addr, self.totalSupply, True, _receiver)
419 
420 
421 @external
422 def kick(addr: address):
423     """
424     @notice Kick `addr` for abusing their boost
425     @dev Only if either they had another voting event, or their voting escrow lock expired
426     @param addr Address to kick
427     """
428     t_last: uint256 = self.integrate_checkpoint_of[addr]
429     t_ve: uint256 = VotingEscrow(VOTING_ESCROW).user_point_history__ts(
430         addr, VotingEscrow(VOTING_ESCROW).user_point_epoch(addr)
431     )
432     _balance: uint256 = self.balanceOf[addr]
433 
434     assert ERC20(VOTING_ESCROW).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
435     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
436 
437     self._checkpoint(addr)
438     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
439 
440 
441 @external
442 @nonreentrant('lock')
443 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
444     """
445     @notice Deposit `_value` LP tokens
446     @dev Depositting also claims pending reward tokens
447     @param _value Number of tokens to deposit
448     @param _addr Address to deposit for
449     """
450 
451     self._checkpoint(_addr)
452 
453     if _value != 0:
454         is_rewards: bool = self.reward_count != 0
455         total_supply: uint256 = self.totalSupply
456         if is_rewards:
457             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
458 
459         total_supply += _value
460         new_balance: uint256 = self.balanceOf[_addr] + _value
461         self.balanceOf[_addr] = new_balance
462         self.totalSupply = total_supply
463 
464         self._update_liquidity_limit(_addr, new_balance, total_supply)
465 
466         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
467 
468     log Deposit(_addr, _value)
469     log Transfer(ZERO_ADDRESS, _addr, _value)
470 
471 
472 @external
473 @nonreentrant('lock')
474 def withdraw(_value: uint256, _claim_rewards: bool = False):
475     """
476     @notice Withdraw `_value` LP tokens
477     @dev Withdrawing also claims pending reward tokens
478     @param _value Number of tokens to withdraw
479     """
480     self._checkpoint(msg.sender)
481 
482     if _value != 0:
483         is_rewards: bool = self.reward_count != 0
484         total_supply: uint256 = self.totalSupply
485         if is_rewards:
486             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
487 
488         total_supply -= _value
489         new_balance: uint256 = self.balanceOf[msg.sender] - _value
490         self.balanceOf[msg.sender] = new_balance
491         self.totalSupply = total_supply
492 
493         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
494 
495         ERC20(self.lp_token).transfer(msg.sender, _value)
496 
497     log Withdraw(msg.sender, _value)
498     log Transfer(msg.sender, ZERO_ADDRESS, _value)
499 
500 
501 @internal
502 def _transfer(_from: address, _to: address, _value: uint256):
503     self._checkpoint(_from)
504     self._checkpoint(_to)
505 
506     if _value != 0:
507         total_supply: uint256 = self.totalSupply
508         is_rewards: bool = self.reward_count != 0
509         if is_rewards:
510             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
511         new_balance: uint256 = self.balanceOf[_from] - _value
512         self.balanceOf[_from] = new_balance
513         self._update_liquidity_limit(_from, new_balance, total_supply)
514 
515         if is_rewards:
516             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
517         new_balance = self.balanceOf[_to] + _value
518         self.balanceOf[_to] = new_balance
519         self._update_liquidity_limit(_to, new_balance, total_supply)
520 
521     log Transfer(_from, _to, _value)
522 
523 
524 @external
525 @nonreentrant('lock')
526 def transfer(_to : address, _value : uint256) -> bool:
527     """
528     @notice Transfer token for a specified address
529     @dev Transferring claims pending reward tokens for the sender and receiver
530     @param _to The address to transfer to.
531     @param _value The amount to be transferred.
532     """
533     self._transfer(msg.sender, _to, _value)
534 
535     return True
536 
537 
538 @external
539 @nonreentrant('lock')
540 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
541     """
542      @notice Transfer tokens from one address to another.
543      @dev Transferring claims pending reward tokens for the sender and receiver
544      @param _from address The address which you want to send tokens from
545      @param _to address The address which you want to transfer to
546      @param _value uint256 the amount of tokens to be transferred
547     """
548     _allowance: uint256 = self.allowance[_from][msg.sender]
549     if _allowance != MAX_UINT256:
550         self.allowance[_from][msg.sender] = _allowance - _value
551 
552     self._transfer(_from, _to, _value)
553 
554     return True
555 
556 
557 @external
558 def approve(_spender : address, _value : uint256) -> bool:
559     """
560     @notice Approve the passed address to transfer the specified amount of
561             tokens on behalf of msg.sender
562     @dev Beware that changing an allowance via this method brings the risk
563          that someone may use both the old and new allowance by unfortunate
564          transaction ordering. This may be mitigated with the use of
565          {incraseAllowance} and {decreaseAllowance}.
566          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
567     @param _spender The address which will transfer the funds
568     @param _value The amount of tokens that may be transferred
569     @return bool success
570     """
571     self.allowance[msg.sender][_spender] = _value
572     log Approval(msg.sender, _spender, _value)
573 
574     return True
575 
576 
577 @external
578 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
579     """
580     @notice Increase the allowance granted to `_spender` by the caller
581     @dev This is alternative to {approve} that can be used as a mitigation for
582          the potential race condition
583     @param _spender The address which will transfer the funds
584     @param _added_value The amount of to increase the allowance
585     @return bool success
586     """
587     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
588     self.allowance[msg.sender][_spender] = allowance
589 
590     log Approval(msg.sender, _spender, allowance)
591 
592     return True
593 
594 
595 @external
596 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
597     """
598     @notice Decrease the allowance granted to `_spender` by the caller
599     @dev This is alternative to {approve} that can be used as a mitigation for
600          the potential race condition
601     @param _spender The address which will transfer the funds
602     @param _subtracted_value The amount of to decrease the allowance
603     @return bool success
604     """
605     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
606     self.allowance[msg.sender][_spender] = allowance
607 
608     log Approval(msg.sender, _spender, allowance)
609 
610     return True
611 
612 
613 @external
614 def add_reward(_reward_token: address, _distributor: address):
615     """
616     @notice Set the active reward contract
617     """
618     assert msg.sender == self.admin  # dev: only owner
619 
620     reward_count: uint256 = self.reward_count
621     assert reward_count < MAX_REWARDS
622     assert self.reward_data[_reward_token].distributor == ZERO_ADDRESS
623 
624     self.reward_data[_reward_token].distributor = _distributor
625     self.reward_tokens[reward_count] = _reward_token
626     self.reward_count = reward_count + 1
627 
628 
629 @external
630 def set_reward_distributor(_reward_token: address, _distributor: address):
631     current_distributor: address = self.reward_data[_reward_token].distributor
632 
633     assert msg.sender == current_distributor or msg.sender == self.admin
634     assert current_distributor != ZERO_ADDRESS
635     assert _distributor != ZERO_ADDRESS
636 
637     self.reward_data[_reward_token].distributor = _distributor
638 
639 
640 @external
641 @nonreentrant("lock")
642 def deposit_reward_token(_reward_token: address, _amount: uint256):
643     assert msg.sender == self.reward_data[_reward_token].distributor
644 
645     self._checkpoint_rewards(ZERO_ADDRESS, self.totalSupply, False, ZERO_ADDRESS)
646 
647     response: Bytes[32] = raw_call(
648         _reward_token,
649         concat(
650             method_id("transferFrom(address,address,uint256)"),
651             convert(msg.sender, bytes32),
652             convert(self, bytes32),
653             convert(_amount, bytes32),
654         ),
655         max_outsize=32,
656     )
657     if len(response) != 0:
658         assert convert(response, bool)
659 
660     period_finish: uint256 = self.reward_data[_reward_token].period_finish
661     if block.timestamp >= period_finish:
662         self.reward_data[_reward_token].rate = _amount / WEEK
663     else:
664         remaining: uint256 = period_finish - block.timestamp
665         leftover: uint256 = remaining * self.reward_data[_reward_token].rate
666         self.reward_data[_reward_token].rate = (_amount + leftover) / WEEK
667 
668     self.reward_data[_reward_token].last_update = block.timestamp
669     self.reward_data[_reward_token].period_finish = block.timestamp + WEEK
670 
671 
672 @external
673 def set_killed(_is_killed: bool):
674     """
675     @notice Set the killed status for this contract
676     @dev When killed, the gauge always yields a rate of 0 and so cannot mint CRV
677     @param _is_killed Killed status to set
678     """
679     assert msg.sender == self.admin
680 
681     self.is_killed = _is_killed
682 
683 
684 @external
685 def commit_transfer_ownership(addr: address):
686     """
687     @notice Transfer ownership of GaugeController to `addr`
688     @param addr Address to have ownership transferred to
689     """
690     assert msg.sender == self.admin  # dev: admin only
691 
692     self.future_admin = addr
693     log CommitOwnership(addr)
694 
695 
696 @external
697 def accept_transfer_ownership():
698     """
699     @notice Accept a pending ownership transfer
700     """
701     _admin: address = self.future_admin
702     assert msg.sender == _admin  # dev: future admin only
703 
704     self.admin = _admin
705     log ApplyOwnership(_admin)