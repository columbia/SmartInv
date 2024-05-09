1 # @version 0.2.12
2 """
3 @title Liquidity Gauge v3
4 @author Curve Finance
5 @license MIT
6 """
7 
8 from vyper.interfaces import ERC20
9 
10 implements: ERC20
11 
12 
13 interface BAO20:
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
35 interface ERC20Extended:
36     def symbol() -> String[26]: view
37 
38 
39 event Deposit:
40     provider: indexed(address)
41     value: uint256
42 
43 event Withdraw:
44     provider: indexed(address)
45     value: uint256
46 
47 event UpdateLiquidityLimit:
48     user: address
49     original_balance: uint256
50     original_supply: uint256
51     working_balance: uint256
52     working_supply: uint256
53 
54 event CommitOwnership:
55     admin: address
56 
57 event ApplyOwnership:
58     admin: address
59 
60 event Transfer:
61     _from: indexed(address)
62     _to: indexed(address)
63     _value: uint256
64 
65 event Approval:
66     _owner: indexed(address)
67     _spender: indexed(address)
68     _value: uint256
69 
70 
71 MAX_REWARDS: constant(uint256) = 8
72 TOKENLESS_PRODUCTION: constant(uint256) = 40
73 WEEK: constant(uint256) = 604800
74 CLAIM_FREQUENCY: constant(uint256) = 3600
75 
76 minter: public(address)
77 bao_token: public(address)
78 lp_token: public(address)
79 controller: public(address)
80 voting_escrow: public(address)
81 future_epoch_time: public(uint256)
82 
83 balanceOf: public(HashMap[address, uint256])
84 totalSupply: public(uint256)
85 allowance: public(HashMap[address, HashMap[address, uint256]])
86 
87 name: public(String[64])
88 symbol: public(String[32])
89 
90 working_balances: public(HashMap[address, uint256])
91 working_supply: public(uint256)
92 
93 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
94 # All values are kept in units of being multiplied by 1e18
95 period: public(int128)
96 period_timestamp: public(uint256[100000000000000000000000000000])
97 
98 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
99 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
100 
101 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
102 integrate_inv_supply_of: public(HashMap[address, uint256])
103 integrate_checkpoint_of: public(HashMap[address, uint256])
104 
105 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
106 # Units: rate * t = already number of coins per address to issue
107 integrate_fraction: public(HashMap[address, uint256])
108 
109 inflation_rate: public(uint256)
110 
111 # For tracking external rewards
112 reward_data: uint256
113 reward_tokens: public(address[MAX_REWARDS])
114 
115 # deposit / withdraw / claim
116 reward_sigs: bytes32
117 
118 # claimant -> default reward receiver
119 rewards_receiver: public(HashMap[address, address])
120 
121 # reward token -> integral
122 reward_integral: public(HashMap[address, uint256])
123 
124 # reward token -> claiming address -> integral
125 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
126 
127 # user -> [uint128 claimable amount][uint128 claimed amount]
128 claim_data: HashMap[address, HashMap[address, uint256]]
129 
130 admin: public(address)
131 future_admin: public(address)  # Can and will be a smart contract
132 is_killed: public(bool)
133 
134 
135 @external
136 def __init__(_lp_token: address, _minter: address, _admin: address):
137     """
138     @notice Contract constructor
139     @param _lp_token Liquidity Pool contract address
140     @param _minter Minter contract address
141     @param _admin Admin who can kill the gauge
142     """
143 
144     symbol: String[26] = ERC20Extended(_lp_token).symbol()
145     self.name = concat("Bao.finance ", symbol, " Gauge Deposit")
146     self.symbol = concat(symbol, "-gauge")
147 
148     bao_token: address = Minter(_minter).token()
149     controller: address = Minter(_minter).controller()
150 
151     self.lp_token = _lp_token
152     self.minter = _minter
153     self.admin = _admin
154     self.bao_token = bao_token
155     self.controller = controller
156     self.voting_escrow = Controller(controller).voting_escrow()
157 
158     self.period_timestamp[0] = block.timestamp
159     self.inflation_rate = BAO20(bao_token).rate()
160     self.future_epoch_time = BAO20(bao_token).future_epoch_time_write()
161 
162 
163 @view
164 @external
165 def decimals() -> uint256:
166     """
167     @notice Get the number of decimals for this token
168     @dev Implemented as a view method to reduce gas costs
169     @return uint256 decimal places
170     """
171     return 18
172 
173 
174 @view
175 @external
176 def integrate_checkpoint() -> uint256:
177     return self.period_timestamp[self.period]
178 
179 
180 @internal
181 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
182     """
183     @notice Calculate limits which depend on the amount of BAO token per-user.
184             Effectively it calculates working balances to apply amplification
185             of BAO production by BAO
186     @param addr User address
187     @param l User's amount of liquidity (LP tokens)
188     @param L Total amount of liquidity (LP tokens)
189     """
190     # To be called after totalSupply is updated
191     _voting_escrow: address = self.voting_escrow
192     voting_balance: uint256 = ERC20(_voting_escrow).balanceOf(addr)
193     voting_total: uint256 = ERC20(_voting_escrow).totalSupply()
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
209 def _checkpoint_rewards( _user: address, _total_supply: uint256, _claim: bool, _receiver: address):
210     """
211     @notice Claim pending rewards and checkpoint rewards for a user
212     """
213     # load reward tokens and integrals into memory
214     reward_tokens: address[MAX_REWARDS] = empty(address[MAX_REWARDS])
215     reward_integrals: uint256[MAX_REWARDS] = empty(uint256[MAX_REWARDS])
216     for i in range(MAX_REWARDS):
217         token: address = self.reward_tokens[i]
218         if token == ZERO_ADDRESS:
219             break
220         reward_tokens[i] = token
221         reward_integrals[i] = self.reward_integral[token]
222 
223     reward_data: uint256 = self.reward_data
224     if _total_supply != 0 and reward_data != 0 and block.timestamp > shift(reward_data, -160) + CLAIM_FREQUENCY:
225         # track balances prior to claiming
226         reward_balances: uint256[MAX_REWARDS] = empty(uint256[MAX_REWARDS])
227         for i in range(MAX_REWARDS):
228             token: address = self.reward_tokens[i]
229             if token == ZERO_ADDRESS:
230                 break
231             reward_balances[i] = ERC20(token).balanceOf(self)
232 
233         # claim from reward contract
234         reward_contract: address = convert(reward_data % 2**160, address)
235         raw_call(reward_contract, slice(self.reward_sigs, 8, 4))  # dev: bad claim sig
236         self.reward_data = convert(reward_contract, uint256) + shift(block.timestamp, 160)
237 
238         # get balances after claim and calculate new reward integrals
239         for i in range(MAX_REWARDS):
240             token: address = reward_tokens[i]
241             if token == ZERO_ADDRESS:
242                 break
243             dI: uint256 = 10**18 * (ERC20(token).balanceOf(self) - reward_balances[i]) / _total_supply
244             if dI > 0:
245                 reward_integrals[i] += dI
246                 self.reward_integral[token] = reward_integrals[i]
247 
248     if _user != ZERO_ADDRESS:
249 
250         receiver: address = _receiver
251         if _claim and receiver == ZERO_ADDRESS:
252             # if receiver is not explicitly declared, check for default receiver
253             receiver = self.rewards_receiver[_user]
254             if receiver == ZERO_ADDRESS:
255                 # direct claims to user if no default receiver is set
256                 receiver = _user
257 
258         # calculate new user reward integral and transfer any owed rewards
259         user_balance: uint256 = self.balanceOf[_user]
260         for i in range(MAX_REWARDS):
261             token: address = reward_tokens[i]
262             if token == ZERO_ADDRESS:
263                 break
264 
265             integral: uint256 = reward_integrals[i]
266             integral_for: uint256 = self.reward_integral_for[token][_user]
267             new_claimable: uint256 = 0
268             if integral_for < integral:
269                 self.reward_integral_for[token][_user] = integral
270                 new_claimable = user_balance * (integral - integral_for) / 10**18
271 
272             claim_data: uint256 = self.claim_data[_user][token]
273             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
274             if total_claimable > 0:
275                 total_claimed: uint256 = claim_data % 2 ** 128
276                 if _claim:
277                     response: Bytes[32] = raw_call(
278                         token,
279                         concat(
280                             method_id("transfer(address,uint256)"),
281                             convert(receiver, bytes32),
282                             convert(total_claimable, bytes32),
283                         ),
284                         max_outsize=32,
285                     )
286                     if len(response) != 0:
287                         assert convert(response, bool)
288                     # update amount claimed (lower order bytes)
289                     self.claim_data[_user][token] = total_claimed + total_claimable
290                 elif new_claimable > 0:
291                     # update total_claimable (higher order bytes)
292                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
293 
294 
295 @internal
296 def _checkpoint(addr: address):
297     """
298     @notice Checkpoint for a user
299     @param addr User address
300     """
301     _period: int128 = self.period
302     _period_time: uint256 = self.period_timestamp[_period]
303     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
304     rate: uint256 = self.inflation_rate
305     new_rate: uint256 = rate
306     prev_future_epoch: uint256 = self.future_epoch_time
307     if prev_future_epoch >= _period_time:
308         _token: address = self.bao_token
309         self.future_epoch_time = BAO20(_token).future_epoch_time_write()
310         new_rate = BAO20(_token).rate()
311         self.inflation_rate = new_rate
312 
313     if self.is_killed:
314         # Stop distributing inflation as soon as killed
315         rate = 0
316 
317     # Update integral of 1/supply
318     if block.timestamp > _period_time:
319         _working_supply: uint256 = self.working_supply
320         _controller: address = self.controller
321         Controller(_controller).checkpoint_gauge(self)
322         prev_week_time: uint256 = _period_time
323         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
324 
325         for i in range(500):
326             dt: uint256 = week_time - prev_week_time
327             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
328 
329             if _working_supply > 0:
330                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
331                     # If we went across one or multiple epochs, apply the rate
332                     # of the first epoch until it ends, and then the rate of
333                     # the last epoch.
334                     # If more than one epoch is crossed - the gauge gets less,
335                     # but that'd meen it wasn't called for more than 1 year
336                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
337                     rate = new_rate
338                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
339                 else:
340                     _integrate_inv_supply += rate * w * dt / _working_supply
341                 # On precisions of the calculation
342                 # rate ~= 10e18
343                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
344                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
345                 # The largest loss is at dt = 1
346                 # Loss is 1e-9 - acceptable
347 
348             if week_time == block.timestamp:
349                 break
350             prev_week_time = week_time
351             week_time = min(week_time + WEEK, block.timestamp)
352 
353     _period += 1
354     self.period = _period
355     self.period_timestamp[_period] = block.timestamp
356     self.integrate_inv_supply[_period] = _integrate_inv_supply
357 
358     # Update user-specific integrals
359     _working_balance: uint256 = self.working_balances[addr]
360     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
361     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
362     self.integrate_checkpoint_of[addr] = block.timestamp
363 
364 
365 @external
366 def user_checkpoint(addr: address) -> bool:
367     """
368     @notice Record a checkpoint for `addr`
369     @param addr User address
370     @return bool success
371     """
372     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
373     self._checkpoint(addr)
374     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
375     return True
376 
377 
378 @external
379 def claimable_tokens(addr: address) -> uint256:
380     """
381     @notice Get the number of claimable tokens per user
382     @dev This function should be manually changed to "view" in the ABI
383     @return uint256 number of claimable tokens per user
384     """
385     self._checkpoint(addr)
386     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
387 
388 
389 @view
390 @external
391 def reward_contract() -> address:
392     """
393     @notice Address of the reward contract providing non-BAO incentives for this gauge
394     @dev Returns `ZERO_ADDRESS` if there is no reward contract active
395     """
396     return convert(self.reward_data % 2**160, address)
397 
398 
399 @view
400 @external
401 def last_claim() -> uint256:
402     """
403     @notice Epoch timestamp of the last call to claim from `reward_contract`
404     @dev Rewards are claimed at most once per hour in order to reduce gas costs
405     """
406     return shift(self.reward_data, -160)
407 
408 
409 @view
410 @external
411 def claimed_reward(_addr: address, _token: address) -> uint256:
412     """
413     @notice Get the number of already-claimed reward tokens for a user
414     @param _addr Account to get reward amount for
415     @param _token Token to get reward amount for
416     @return uint256 Total amount of `_token` already claimed by `_addr`
417     """
418     return self.claim_data[_addr][_token] % 2**128
419 
420 
421 @view
422 @external
423 def claimable_reward(_addr: address, _token: address) -> uint256:
424     """
425     @notice Get the number of claimable reward tokens for a user
426     @dev This call does not consider pending claimable amount in `reward_contract`.
427          Off-chain callers should instead use `claimable_rewards_write` as a
428          view method.
429     @param _addr Account to get reward amount for
430     @param _token Token to get reward amount for
431     @return uint256 Claimable reward token amount
432     """
433     return shift(self.claim_data[_addr][_token], -128)
434 
435 
436 @external
437 @nonreentrant('lock')
438 def claimable_reward_write(_addr: address, _token: address) -> uint256:
439     """
440     @notice Get the number of claimable reward tokens for a user
441     @dev This function should be manually changed to "view" in the ABI
442          Calling it via a transaction will claim available reward tokens
443     @param _addr Account to get reward amount for
444     @param _token Token to get reward amount for
445     @return uint256 Claimable reward token amount
446     """
447     if self.reward_tokens[0] != ZERO_ADDRESS:
448         self._checkpoint_rewards(_addr, self.totalSupply, False, ZERO_ADDRESS)
449     return shift(self.claim_data[_addr][_token], -128)
450 
451 
452 @external
453 def set_rewards_receiver(_receiver: address):
454     """
455     @notice Set the default reward receiver for the caller.
456     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
457     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
458     """
459     self.rewards_receiver[msg.sender] = _receiver
460 
461 
462 @external
463 @nonreentrant('lock')
464 def claim_rewards(_addr: address = msg.sender, _receiver: address = ZERO_ADDRESS):
465     """
466     @notice Claim available reward tokens for `_addr`
467     @param _addr Address to claim for
468     @param _receiver Address to transfer rewards to - if set to
469                      ZERO_ADDRESS, uses the default reward receiver
470                      for the caller
471     """
472     if _receiver != ZERO_ADDRESS:
473         assert _addr == msg.sender  # dev: cannot redirect when claiming for another user
474     self._checkpoint_rewards(_addr, self.totalSupply, True, _receiver)
475 
476 
477 @external
478 def kick(addr: address):
479     """
480     @notice Kick `addr` for abusing their boost
481     @dev Only if either they had another voting event, or their voting escrow lock expired
482     @param addr Address to kick
483     """
484     _voting_escrow: address = self.voting_escrow
485     t_last: uint256 = self.integrate_checkpoint_of[addr]
486     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
487         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
488     )
489     _balance: uint256 = self.balanceOf[addr]
490 
491     assert ERC20(_voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
492     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
493 
494     self._checkpoint(addr)
495     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
496 
497 
498 @external
499 @nonreentrant('lock')
500 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
501     """
502     @notice Deposit `_value` LP tokens
503     @dev Depositting also claims pending reward tokens
504     @param _value Number of tokens to deposit
505     @param _addr Address to deposit for
506     """
507 
508     self._checkpoint(_addr)
509 
510     if _value != 0:
511         is_rewards: bool = self.reward_tokens[0] != ZERO_ADDRESS
512         total_supply: uint256 = self.totalSupply
513         if is_rewards:
514             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
515 
516         total_supply += _value
517         new_balance: uint256 = self.balanceOf[_addr] + _value
518         self.balanceOf[_addr] = new_balance
519         self.totalSupply = total_supply
520 
521         self._update_liquidity_limit(_addr, new_balance, total_supply)
522 
523         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
524         if is_rewards:
525             reward_data: uint256 = self.reward_data
526             if reward_data > 0:
527                 deposit_sig: Bytes[4] = slice(self.reward_sigs, 0, 4)
528                 if convert(deposit_sig, uint256) != 0:
529                     raw_call(
530                         convert(reward_data % 2**160, address),
531                         concat(deposit_sig, convert(_value, bytes32))
532                     )
533 
534     log Deposit(_addr, _value)
535     log Transfer(ZERO_ADDRESS, _addr, _value)
536 
537 
538 @external
539 @nonreentrant('lock')
540 def withdraw(_value: uint256, _claim_rewards: bool = False):
541     """
542     @notice Withdraw `_value` LP tokens
543     @dev Withdrawing also claims pending reward tokens
544     @param _value Number of tokens to withdraw
545     """
546     self._checkpoint(msg.sender)
547 
548     if _value != 0:
549         is_rewards: bool = self.reward_tokens[0] != ZERO_ADDRESS
550         total_supply: uint256 = self.totalSupply
551         if is_rewards:
552             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
553 
554         total_supply -= _value
555         new_balance: uint256 = self.balanceOf[msg.sender] - _value
556         self.balanceOf[msg.sender] = new_balance
557         self.totalSupply = total_supply
558 
559         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
560 
561         if is_rewards:
562             reward_data: uint256 = self.reward_data
563             if reward_data > 0:
564                 withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
565                 if convert(withdraw_sig, uint256) != 0:
566                     raw_call(
567                         convert(reward_data % 2**160, address),
568                         concat(withdraw_sig, convert(_value, bytes32))
569                     )
570         ERC20(self.lp_token).transfer(msg.sender, _value)
571 
572     log Withdraw(msg.sender, _value)
573     log Transfer(msg.sender, ZERO_ADDRESS, _value)
574 
575 
576 @internal
577 def _transfer(_from: address, _to: address, _value: uint256):
578     self._checkpoint(_from)
579     self._checkpoint(_to)
580 
581     if _value != 0:
582         total_supply: uint256 = self.totalSupply
583         is_rewards: bool = self.reward_tokens[0] != ZERO_ADDRESS
584         if is_rewards:
585             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
586         new_balance: uint256 = self.balanceOf[_from] - _value
587         self.balanceOf[_from] = new_balance
588         self._update_liquidity_limit(_from, new_balance, total_supply)
589 
590         if is_rewards:
591             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
592         new_balance = self.balanceOf[_to] + _value
593         self.balanceOf[_to] = new_balance
594         self._update_liquidity_limit(_to, new_balance, total_supply)
595 
596     log Transfer(_from, _to, _value)
597 
598 
599 @external
600 @nonreentrant('lock')
601 def transfer(_to : address, _value : uint256) -> bool:
602     """
603     @notice Transfer token for a specified address
604     @dev Transferring claims pending reward tokens for the sender and receiver
605     @param _to The address to transfer to.
606     @param _value The amount to be transferred.
607     """
608     self._transfer(msg.sender, _to, _value)
609 
610     return True
611 
612 
613 @external
614 @nonreentrant('lock')
615 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
616     """
617      @notice Transfer tokens from one address to another.
618      @dev Transferring claims pending reward tokens for the sender and receiver
619      @param _from address The address which you want to send tokens from
620      @param _to address The address which you want to transfer to
621      @param _value uint256 the amount of tokens to be transferred
622     """
623     _allowance: uint256 = self.allowance[_from][msg.sender]
624     if _allowance != MAX_UINT256:
625         self.allowance[_from][msg.sender] = _allowance - _value
626 
627     self._transfer(_from, _to, _value)
628 
629     return True
630 
631 
632 @external
633 def approve(_spender : address, _value : uint256) -> bool:
634     """
635     @notice Approve the passed address to transfer the specified amount of
636             tokens on behalf of msg.sender
637     @dev Beware that changing an allowance via this method brings the risk
638          that someone may use both the old and new allowance by unfortunate
639          transaction ordering. This may be mitigated with the use of
640          {incraseAllowance} and {decreaseAllowance}.
641          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
642     @param _spender The address which will transfer the funds
643     @param _value The amount of tokens that may be transferred
644     @return bool success
645     """
646     self.allowance[msg.sender][_spender] = _value
647     log Approval(msg.sender, _spender, _value)
648 
649     return True
650 
651 
652 @external
653 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
654     """
655     @notice Increase the allowance granted to `_spender` by the caller
656     @dev This is alternative to {approve} that can be used as a mitigation for
657          the potential race condition
658     @param _spender The address which will transfer the funds
659     @param _added_value The amount of to increase the allowance
660     @return bool success
661     """
662     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
663     self.allowance[msg.sender][_spender] = allowance
664 
665     log Approval(msg.sender, _spender, allowance)
666 
667     return True
668 
669 
670 @external
671 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
672     """
673     @notice Decrease the allowance granted to `_spender` by the caller
674     @dev This is alternative to {approve} that can be used as a mitigation for
675          the potential race condition
676     @param _spender The address which will transfer the funds
677     @param _subtracted_value The amount of to decrease the allowance
678     @return bool success
679     """
680     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
681     self.allowance[msg.sender][_spender] = allowance
682 
683     log Approval(msg.sender, _spender, allowance)
684 
685     return True
686 
687 
688 @external
689 @nonreentrant('lock')
690 def set_rewards(_reward_contract: address, _sigs: bytes32, _reward_tokens: address[MAX_REWARDS]):
691     """
692     @notice Set the active reward contract
693     @dev A reward contract cannot be set while this contract has no deposits
694     @param _reward_contract Reward contract address. Set to ZERO_ADDRESS to
695                             disable staking.
696     @param _sigs Four byte selectors for staking, withdrawing and claiming,
697                  right padded with zero bytes. If the reward contract can
698                  be claimed from but does not require staking, the staking
699                  and withdraw selectors should be set to 0x00
700     @param _reward_tokens List of claimable reward tokens. New reward tokens
701                           may be added but they cannot be removed. When calling
702                           this function to unset or modify a reward contract,
703                           this array must begin with the already-set reward
704                           token addresses.
705     """
706     assert msg.sender == self.admin
707 
708     lp_token: address = self.lp_token
709     current_reward_contract: address = convert(self.reward_data % 2**160, address)
710     total_supply: uint256 = self.totalSupply
711     if self.reward_tokens[0] != ZERO_ADDRESS:
712         self._checkpoint_rewards(ZERO_ADDRESS, total_supply, False, ZERO_ADDRESS)
713     if current_reward_contract != ZERO_ADDRESS:
714         withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
715         if convert(withdraw_sig, uint256) != 0:
716             if total_supply != 0:
717                 raw_call(
718                     current_reward_contract,
719                     concat(withdraw_sig, convert(total_supply, bytes32))
720                 )
721             ERC20(lp_token).approve(current_reward_contract, 0)
722 
723     if _reward_contract != ZERO_ADDRESS:
724         assert _reward_tokens[0] != ZERO_ADDRESS  # dev: no reward token
725         assert _reward_contract.is_contract  # dev: not a contract
726         deposit_sig: Bytes[4] = slice(_sigs, 0, 4)
727         withdraw_sig: Bytes[4] = slice(_sigs, 4, 4)
728 
729         if convert(deposit_sig, uint256) != 0:
730             # need a non-zero total supply to verify the sigs
731             assert total_supply != 0  # dev: zero total supply
732             ERC20(lp_token).approve(_reward_contract, MAX_UINT256)
733 
734             # it would be Very Bad if we get the signatures wrong here, so
735             # we do a test deposit and withdrawal prior to setting them
736             raw_call(
737                 _reward_contract,
738                 concat(deposit_sig, convert(total_supply, bytes32))
739             )  # dev: failed deposit
740             assert ERC20(lp_token).balanceOf(self) == 0
741             raw_call(
742                 _reward_contract,
743                 concat(withdraw_sig, convert(total_supply, bytes32))
744             )  # dev: failed withdraw
745             assert ERC20(lp_token).balanceOf(self) == total_supply
746 
747             # deposit and withdraw are good, time to make the actual deposit
748             raw_call(
749                 _reward_contract,
750                 concat(deposit_sig, convert(total_supply, bytes32))
751             )
752         else:
753             assert convert(withdraw_sig, uint256) == 0  # dev: withdraw without deposit
754 
755     self.reward_data = convert(_reward_contract, uint256)
756     self.reward_sigs = _sigs
757     for i in range(MAX_REWARDS):
758         current_token: address = self.reward_tokens[i]
759         new_token: address = _reward_tokens[i]
760         if current_token != ZERO_ADDRESS:
761             assert current_token == new_token  # dev: cannot modify existing reward token
762         elif new_token != ZERO_ADDRESS:
763             # store new reward token
764             self.reward_tokens[i] = new_token
765         else:
766             break
767 
768     if _reward_contract != ZERO_ADDRESS:
769         # do an initial checkpoint to verify that claims are working
770         self._checkpoint_rewards(ZERO_ADDRESS, total_supply, False, ZERO_ADDRESS)
771 
772 
773 @external
774 def set_killed(_is_killed: bool):
775     """
776     @notice Set the killed status for this contract
777     @dev When killed, the gauge always yields a rate of 0 and so cannot mint BAO
778     @param _is_killed Killed status to set
779     """
780     assert msg.sender == self.admin
781 
782     self.is_killed = _is_killed
783 
784 
785 @external
786 def commit_transfer_ownership(addr: address):
787     """
788     @notice Transfer ownership of GaugeController to `addr`
789     @param addr Address to have ownership transferred to
790     """
791     assert msg.sender == self.admin  # dev: admin only
792 
793     self.future_admin = addr
794     log CommitOwnership(addr)
795 
796 
797 @external
798 def accept_transfer_ownership():
799     """
800     @notice Accept a pending ownership transfer
801     """
802     _admin: address = self.future_admin
803     assert msg.sender == _admin  # dev: future admin only
804 
805     self.admin = _admin
806     log ApplyOwnership(_admin)