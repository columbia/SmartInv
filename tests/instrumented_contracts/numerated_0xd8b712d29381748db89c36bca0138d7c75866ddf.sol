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
36 interface ERC20Extended:
37     def symbol() -> String[26]: view
38 
39 interface Factory:
40     def admin() -> address: view
41 
42 
43 event Deposit:
44     provider: indexed(address)
45     value: uint256
46 
47 event Withdraw:
48     provider: indexed(address)
49     value: uint256
50 
51 event UpdateLiquidityLimit:
52     user: address
53     original_balance: uint256
54     original_supply: uint256
55     working_balance: uint256
56     working_supply: uint256
57 
58 event CommitOwnership:
59     admin: address
60 
61 event ApplyOwnership:
62     admin: address
63 
64 event Transfer:
65     _from: indexed(address)
66     _to: indexed(address)
67     _value: uint256
68 
69 event Approval:
70     _owner: indexed(address)
71     _spender: indexed(address)
72     _value: uint256
73 
74 
75 struct Reward:
76     token: address
77     distributor: address
78     period_finish: uint256
79     rate: uint256
80     last_update: uint256
81     integral: uint256
82 
83 
84 MAX_REWARDS: constant(uint256) = 8
85 TOKENLESS_PRODUCTION: constant(uint256) = 40
86 WEEK: constant(uint256) = 604800
87 
88 MINTER: constant(address) = 0xd061D61a4d941c39E5453435B6345Dc261C2fcE0
89 CRV: constant(address) = 0xD533a949740bb3306d119CC777fa900bA034cd52
90 VOTING_ESCROW: constant(address) = 0x5f3b5DfEb7B28CDbD7FAba78963EE202a494e2A2
91 GAUGE_CONTROLLER: constant(address) = 0x2F50D538606Fa9EDD2B11E2446BEb18C9D5846bB
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
140 is_killed: public(bool)
141 factory: public(address)
142 
143 
144 @external
145 def __init__(_lp_token: address, _factory: address):
146     """
147     @notice Contract constructor
148     @param _lp_token Liquidity Pool contract address
149     """
150 
151     assert self.lp_token == ZERO_ADDRESS
152     self.lp_token = _lp_token
153     self.factory = _factory
154 
155     symbol: String[26] = ERC20Extended(_lp_token).symbol()
156     self.name = concat("Curve.fi ", symbol, " Gauge Deposit")
157     self.symbol = concat(symbol, "-gauge")
158 
159     self.period_timestamp[0] = block.timestamp
160     self.inflation_rate = CRV20(CRV).rate()
161     self.future_epoch_time = CRV20(CRV).future_epoch_time_write()
162 
163 
164 @view
165 @external
166 def decimals() -> uint256:
167     """
168     @notice Get the number of decimals for this token
169     @dev Implemented as a view method to reduce gas costs
170     @return uint256 decimal places
171     """
172     return 18
173 
174 
175 @view
176 @external
177 def integrate_checkpoint() -> uint256:
178     return self.period_timestamp[self.period]
179 
180 
181 @internal
182 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
183     """
184     @notice Calculate limits which depend on the amount of CRV token per-user.
185             Effectively it calculates working balances to apply amplification
186             of CRV production by CRV
187     @param addr User address
188     @param l User's amount of liquidity (LP tokens)
189     @param L Total amount of liquidity (LP tokens)
190     """
191     # To be called after totalSupply is updated
192     voting_balance: uint256 = ERC20(VOTING_ESCROW).balanceOf(addr)
193     voting_total: uint256 = ERC20(VOTING_ESCROW).totalSupply()
194 
195     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
196     if voting_total > 0:
197         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
198 
199     lim = min(l, lim)
200     old_bal: uint256 = self.working_balances[addr]
201     self.working_balances[addr] = lim
202     _working_supply: uint256 = self.working_supply + lim - old_bal
203     self.working_supply = _working_supply
204 
205     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
206 
207 
208 @internal
209 def _checkpoint_rewards(_user: address, _total_supply: uint256, _claim: bool, _receiver: address):
210     """
211     @notice Claim pending rewards and checkpoint rewards for a user
212     """
213 
214     user_balance: uint256 = 0
215     receiver: address = _receiver
216     if _user != ZERO_ADDRESS:
217         user_balance = self.balanceOf[_user]
218         if _claim and _receiver == ZERO_ADDRESS:
219             # if receiver is not explicitly declared, check if a default receiver is set
220             receiver = self.rewards_receiver[_user]
221             if receiver == ZERO_ADDRESS:
222                 # if no default receiver is set, direct claims to the user
223                 receiver = _user
224 
225     reward_count: uint256 = self.reward_count
226     for i in range(MAX_REWARDS):
227         if i == reward_count:
228             break
229         token: address = self.reward_tokens[i]
230 
231         integral: uint256 = self.reward_data[token].integral
232         last_update: uint256 = min(block.timestamp, self.reward_data[token].period_finish)
233         duration: uint256 = last_update - self.reward_data[token].last_update
234         if duration != 0:
235             self.reward_data[token].last_update = last_update
236             if _total_supply != 0:
237                 integral += duration * self.reward_data[token].rate * 10**18 / _total_supply
238                 self.reward_data[token].integral = integral
239 
240         if _user != ZERO_ADDRESS:
241             integral_for: uint256 = self.reward_integral_for[token][_user]
242             new_claimable: uint256 = 0
243 
244             if integral_for < integral:
245                 self.reward_integral_for[token][_user] = integral
246                 new_claimable = user_balance * (integral - integral_for) / 10**18
247 
248             claim_data: uint256 = self.claim_data[_user][token]
249             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
250             if total_claimable > 0:
251                 total_claimed: uint256 = claim_data % 2**128
252                 if _claim:
253                     response: Bytes[32] = raw_call(
254                         token,
255                         concat(
256                             method_id("transfer(address,uint256)"),
257                             convert(receiver, bytes32),
258                             convert(total_claimable, bytes32),
259                         ),
260                         max_outsize=32,
261                     )
262                     if len(response) != 0:
263                         assert convert(response, bool)
264                     self.claim_data[_user][token] = total_claimed + total_claimable
265                 elif new_claimable > 0:
266                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
267 
268 
269 @internal
270 def _checkpoint(addr: address):
271     """
272     @notice Checkpoint for a user
273     @param addr User address
274     """
275     _period: int128 = self.period
276     _period_time: uint256 = self.period_timestamp[_period]
277     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
278     rate: uint256 = self.inflation_rate
279     new_rate: uint256 = rate
280     prev_future_epoch: uint256 = self.future_epoch_time
281     if prev_future_epoch >= _period_time:
282         self.future_epoch_time = CRV20(CRV).future_epoch_time_write()
283         new_rate = CRV20(CRV).rate()
284         self.inflation_rate = new_rate
285 
286     if self.is_killed:
287         # Stop distributing inflation as soon as killed
288         rate = 0
289 
290     # Update integral of 1/supply
291     if block.timestamp > _period_time:
292         _working_supply: uint256 = self.working_supply
293         Controller(GAUGE_CONTROLLER).checkpoint_gauge(self)
294         prev_week_time: uint256 = _period_time
295         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
296 
297         for i in range(500):
298             dt: uint256 = week_time - prev_week_time
299             w: uint256 = Controller(GAUGE_CONTROLLER).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
300 
301             if _working_supply > 0:
302                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
303                     # If we went across one or multiple epochs, apply the rate
304                     # of the first epoch until it ends, and then the rate of
305                     # the last epoch.
306                     # If more than one epoch is crossed - the gauge gets less,
307                     # but that'd meen it wasn't called for more than 1 year
308                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
309                     rate = new_rate
310                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
311                 else:
312                     _integrate_inv_supply += rate * w * dt / _working_supply
313                 # On precisions of the calculation
314                 # rate ~= 10e18
315                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
316                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
317                 # The largest loss is at dt = 1
318                 # Loss is 1e-9 - acceptable
319 
320             if week_time == block.timestamp:
321                 break
322             prev_week_time = week_time
323             week_time = min(week_time + WEEK, block.timestamp)
324 
325     _period += 1
326     self.period = _period
327     self.period_timestamp[_period] = block.timestamp
328     self.integrate_inv_supply[_period] = _integrate_inv_supply
329 
330     # Update user-specific integrals
331     _working_balance: uint256 = self.working_balances[addr]
332     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
333     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
334     self.integrate_checkpoint_of[addr] = block.timestamp
335 
336 
337 @external
338 def user_checkpoint(addr: address) -> bool:
339     """
340     @notice Record a checkpoint for `addr`
341     @param addr User address
342     @return bool success
343     """
344     assert msg.sender in [addr, MINTER]  # dev: unauthorized
345     self._checkpoint(addr)
346     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
347     return True
348 
349 
350 @external
351 def claimable_tokens(addr: address) -> uint256:
352     """
353     @notice Get the number of claimable tokens per user
354     @dev This function should be manually changed to "view" in the ABI
355     @return uint256 number of claimable tokens per user
356     """
357     self._checkpoint(addr)
358     return self.integrate_fraction[addr] - Minter(MINTER).minted(addr, self)
359 
360 
361 @view
362 @external
363 def claimed_reward(_addr: address, _token: address) -> uint256:
364     """
365     @notice Get the number of already-claimed reward tokens for a user
366     @param _addr Account to get reward amount for
367     @param _token Token to get reward amount for
368     @return uint256 Total amount of `_token` already claimed by `_addr`
369     """
370     return self.claim_data[_addr][_token] % 2**128
371 
372 
373 @view
374 @external
375 def claimable_reward(_user: address, _reward_token: address) -> uint256:
376     """
377     @notice Get the number of claimable reward tokens for a user
378     @param _user Account to get reward amount for
379     @param _reward_token Token to get reward amount for
380     @return uint256 Claimable reward token amount
381     """
382     integral: uint256 = self.reward_data[_reward_token].integral
383     total_supply: uint256 = self.totalSupply
384     if total_supply != 0:
385         last_update: uint256 = min(block.timestamp, self.reward_data[_reward_token].period_finish)
386         duration: uint256 = last_update - self.reward_data[_reward_token].last_update
387         integral += (duration * self.reward_data[_reward_token].rate * 10**18 / total_supply)
388 
389     integral_for: uint256 = self.reward_integral_for[_reward_token][_user]
390     new_claimable: uint256 = self.balanceOf[_user] * (integral - integral_for) / 10**18
391 
392     return shift(self.claim_data[_user][_reward_token], -128) + new_claimable
393 
394 
395 @external
396 def set_rewards_receiver(_receiver: address):
397     """
398     @notice Set the default reward receiver for the caller.
399     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
400     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
401     """
402     self.rewards_receiver[msg.sender] = _receiver
403 
404 
405 @external
406 @nonreentrant('lock')
407 def claim_rewards(_addr: address = msg.sender, _receiver: address = ZERO_ADDRESS):
408     """
409     @notice Claim available reward tokens for `_addr`
410     @param _addr Address to claim for
411     @param _receiver Address to transfer rewards to - if set to
412                      ZERO_ADDRESS, uses the default reward receiver
413                      for the caller
414     """
415     if _receiver != ZERO_ADDRESS:
416         assert _addr == msg.sender  # dev: cannot redirect when claiming for another user
417     self._checkpoint_rewards(_addr, self.totalSupply, True, _receiver)
418 
419 
420 @external
421 def kick(addr: address):
422     """
423     @notice Kick `addr` for abusing their boost
424     @dev Only if either they had another voting event, or their voting escrow lock expired
425     @param addr Address to kick
426     """
427     t_last: uint256 = self.integrate_checkpoint_of[addr]
428     t_ve: uint256 = VotingEscrow(VOTING_ESCROW).user_point_history__ts(
429         addr, VotingEscrow(VOTING_ESCROW).user_point_epoch(addr)
430     )
431     _balance: uint256 = self.balanceOf[addr]
432 
433     assert ERC20(VOTING_ESCROW).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
434     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
435 
436     self._checkpoint(addr)
437     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
438 
439 
440 @external
441 @nonreentrant('lock')
442 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
443     """
444     @notice Deposit `_value` LP tokens
445     @dev Depositting also claims pending reward tokens
446     @param _value Number of tokens to deposit
447     @param _addr Address to deposit for
448     """
449 
450     self._checkpoint(_addr)
451 
452     if _value != 0:
453         is_rewards: bool = self.reward_count != 0
454         total_supply: uint256 = self.totalSupply
455         if is_rewards:
456             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
457 
458         total_supply += _value
459         new_balance: uint256 = self.balanceOf[_addr] + _value
460         self.balanceOf[_addr] = new_balance
461         self.totalSupply = total_supply
462 
463         self._update_liquidity_limit(_addr, new_balance, total_supply)
464 
465         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
466 
467     log Deposit(_addr, _value)
468     log Transfer(ZERO_ADDRESS, _addr, _value)
469 
470 
471 @external
472 @nonreentrant('lock')
473 def withdraw(_value: uint256, _claim_rewards: bool = False):
474     """
475     @notice Withdraw `_value` LP tokens
476     @dev Withdrawing also claims pending reward tokens
477     @param _value Number of tokens to withdraw
478     """
479     self._checkpoint(msg.sender)
480 
481     if _value != 0:
482         is_rewards: bool = self.reward_count != 0
483         total_supply: uint256 = self.totalSupply
484         if is_rewards:
485             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
486 
487         total_supply -= _value
488         new_balance: uint256 = self.balanceOf[msg.sender] - _value
489         self.balanceOf[msg.sender] = new_balance
490         self.totalSupply = total_supply
491 
492         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
493 
494         ERC20(self.lp_token).transfer(msg.sender, _value)
495 
496     log Withdraw(msg.sender, _value)
497     log Transfer(msg.sender, ZERO_ADDRESS, _value)
498 
499 
500 @internal
501 def _transfer(_from: address, _to: address, _value: uint256):
502     self._checkpoint(_from)
503     self._checkpoint(_to)
504 
505     if _value != 0:
506         total_supply: uint256 = self.totalSupply
507         is_rewards: bool = self.reward_count != 0
508         if is_rewards:
509             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
510         new_balance: uint256 = self.balanceOf[_from] - _value
511         self.balanceOf[_from] = new_balance
512         self._update_liquidity_limit(_from, new_balance, total_supply)
513 
514         if is_rewards:
515             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
516         new_balance = self.balanceOf[_to] + _value
517         self.balanceOf[_to] = new_balance
518         self._update_liquidity_limit(_to, new_balance, total_supply)
519 
520     log Transfer(_from, _to, _value)
521 
522 
523 @external
524 @nonreentrant('lock')
525 def transfer(_to : address, _value : uint256) -> bool:
526     """
527     @notice Transfer token for a specified address
528     @dev Transferring claims pending reward tokens for the sender and receiver
529     @param _to The address to transfer to.
530     @param _value The amount to be transferred.
531     """
532     self._transfer(msg.sender, _to, _value)
533 
534     return True
535 
536 
537 @external
538 @nonreentrant('lock')
539 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
540     """
541      @notice Transfer tokens from one address to another.
542      @dev Transferring claims pending reward tokens for the sender and receiver
543      @param _from address The address which you want to send tokens from
544      @param _to address The address which you want to transfer to
545      @param _value uint256 the amount of tokens to be transferred
546     """
547     _allowance: uint256 = self.allowance[_from][msg.sender]
548     if _allowance != MAX_UINT256:
549         self.allowance[_from][msg.sender] = _allowance - _value
550 
551     self._transfer(_from, _to, _value)
552 
553     return True
554 
555 
556 @external
557 def approve(_spender : address, _value : uint256) -> bool:
558     """
559     @notice Approve the passed address to transfer the specified amount of
560             tokens on behalf of msg.sender
561     @dev Beware that changing an allowance via this method brings the risk
562          that someone may use both the old and new allowance by unfortunate
563          transaction ordering. This may be mitigated with the use of
564          {incraseAllowance} and {decreaseAllowance}.
565          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
566     @param _spender The address which will transfer the funds
567     @param _value The amount of tokens that may be transferred
568     @return bool success
569     """
570     self.allowance[msg.sender][_spender] = _value
571     log Approval(msg.sender, _spender, _value)
572 
573     return True
574 
575 
576 @external
577 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
578     """
579     @notice Increase the allowance granted to `_spender` by the caller
580     @dev This is alternative to {approve} that can be used as a mitigation for
581          the potential race condition
582     @param _spender The address which will transfer the funds
583     @param _added_value The amount of to increase the allowance
584     @return bool success
585     """
586     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
587     self.allowance[msg.sender][_spender] = allowance
588 
589     log Approval(msg.sender, _spender, allowance)
590 
591     return True
592 
593 
594 @external
595 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
596     """
597     @notice Decrease the allowance granted to `_spender` by the caller
598     @dev This is alternative to {approve} that can be used as a mitigation for
599          the potential race condition
600     @param _spender The address which will transfer the funds
601     @param _subtracted_value The amount of to decrease the allowance
602     @return bool success
603     """
604     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
605     self.allowance[msg.sender][_spender] = allowance
606 
607     log Approval(msg.sender, _spender, allowance)
608 
609     return True
610 
611 
612 @external
613 def add_reward(_reward_token: address, _distributor: address):
614     """
615     @notice Set the active reward contract
616     """
617     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
618 
619     reward_count: uint256 = self.reward_count
620     assert reward_count < MAX_REWARDS
621     assert self.reward_data[_reward_token].distributor == ZERO_ADDRESS
622 
623     self.reward_data[_reward_token].distributor = _distributor
624     self.reward_tokens[reward_count] = _reward_token
625     self.reward_count = reward_count + 1
626 
627 
628 @external
629 def set_reward_distributor(_reward_token: address, _distributor: address):
630     current_distributor: address = self.reward_data[_reward_token].distributor
631 
632     assert msg.sender == current_distributor or msg.sender == Factory(self.factory).admin()
633     assert current_distributor != ZERO_ADDRESS
634     assert _distributor != ZERO_ADDRESS
635 
636     self.reward_data[_reward_token].distributor = _distributor
637 
638 
639 @external
640 @nonreentrant("lock")
641 def deposit_reward_token(_reward_token: address, _amount: uint256):
642     assert msg.sender == self.reward_data[_reward_token].distributor
643 
644     self._checkpoint_rewards(ZERO_ADDRESS, self.totalSupply, False, ZERO_ADDRESS)
645 
646     response: Bytes[32] = raw_call(
647         _reward_token,
648         concat(
649             method_id("transferFrom(address,address,uint256)"),
650             convert(msg.sender, bytes32),
651             convert(self, bytes32),
652             convert(_amount, bytes32),
653         ),
654         max_outsize=32,
655     )
656     if len(response) != 0:
657         assert convert(response, bool)
658 
659     period_finish: uint256 = self.reward_data[_reward_token].period_finish
660     if block.timestamp >= period_finish:
661         self.reward_data[_reward_token].rate = _amount / WEEK
662     else:
663         remaining: uint256 = period_finish - block.timestamp
664         leftover: uint256 = remaining * self.reward_data[_reward_token].rate
665         self.reward_data[_reward_token].rate = (_amount + leftover) / WEEK
666 
667     self.reward_data[_reward_token].last_update = block.timestamp
668     self.reward_data[_reward_token].period_finish = block.timestamp + WEEK
669 
670 
671 @external
672 def set_killed(_is_killed: bool):
673     """
674     @notice Set the killed status for this contract
675     @dev When killed, the gauge always yields a rate of 0 and so cannot mint CRV
676     @param _is_killed Killed status to set
677     """
678     assert msg.sender == Factory(self.factory).admin()  # dev: only owner
679 
680     self.is_killed = _is_killed