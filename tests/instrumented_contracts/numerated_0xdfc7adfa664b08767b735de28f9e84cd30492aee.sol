1 # @version 0.2.8
2 """
3 @title Liquidity Gauge v2
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
35 
36 event Deposit:
37     provider: indexed(address)
38     value: uint256
39 
40 event Withdraw:
41     provider: indexed(address)
42     value: uint256
43 
44 event UpdateLiquidityLimit:
45     user: address
46     original_balance: uint256
47     original_supply: uint256
48     working_balance: uint256
49     working_supply: uint256
50 
51 event CommitOwnership:
52     admin: address
53 
54 event ApplyOwnership:
55     admin: address
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
67 
68 
69 MAX_REWARDS: constant(uint256) = 8
70 TOKENLESS_PRODUCTION: constant(uint256) = 40
71 BOOST_WARMUP: constant(uint256) = 2 * 7 * 86400
72 WEEK: constant(uint256) = 604800
73 
74 minter: public(address)
75 crv_token: public(address)
76 lp_token: public(address)
77 controller: public(address)
78 voting_escrow: public(address)
79 future_epoch_time: public(uint256)
80 
81 balanceOf: public(HashMap[address, uint256])
82 totalSupply: public(uint256)
83 allowances: HashMap[address, HashMap[address, uint256]]
84 
85 name: public(String[64])
86 symbol: public(String[32])
87 
88 # caller -> recipient -> can deposit?
89 approved_to_deposit: public(HashMap[address, HashMap[address, bool]])
90 
91 working_balances: public(HashMap[address, uint256])
92 working_supply: public(uint256)
93 
94 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
95 # All values are kept in units of being multiplied by 1e18
96 period: public(int128)
97 period_timestamp: public(uint256[100000000000000000000000000000])
98 
99 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
100 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
101 
102 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
103 integrate_inv_supply_of: public(HashMap[address, uint256])
104 integrate_checkpoint_of: public(HashMap[address, uint256])
105 
106 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
107 # Units: rate * t = already number of coins per address to issue
108 integrate_fraction: public(HashMap[address, uint256])
109 
110 inflation_rate: public(uint256)
111 
112 # For tracking external rewards
113 reward_contract: public(address)
114 reward_tokens: public(address[MAX_REWARDS])
115 
116 # deposit / withdraw / claim
117 reward_sigs: bytes32
118 
119 # reward token -> integral
120 reward_integral: public(HashMap[address, uint256])
121 
122 # reward token -> claiming address -> integral
123 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
124 
125 admin: public(address)
126 future_admin: public(address)  # Can and will be a smart contract
127 is_killed: public(bool)
128 
129 
130 @external
131 def __init__(
132     _name: String[64],
133     _symbol: String[32],
134     _lp_token: address,
135     _minter: address,
136     _admin: address,
137 ):
138     """
139     @notice Contract constructor
140     @param _name Token full name
141     @param _symbol Token symbol
142     @param _lp_token Liquidity Pool contract address
143     @param _minter Minter contract address
144     @param _admin Admin who can kill the gauge
145     """
146     self.name = _name
147     self.symbol = _symbol
148 
149     crv_token: address = Minter(_minter).token()
150     controller: address = Minter(_minter).controller()
151 
152     self.lp_token = _lp_token
153     self.minter = _minter
154     self.admin = _admin
155     self.crv_token = crv_token
156     self.controller = controller
157     self.voting_escrow = Controller(controller).voting_escrow()
158 
159     self.period_timestamp[0] = block.timestamp
160     self.inflation_rate = CRV20(crv_token).rate()
161     self.future_epoch_time = CRV20(crv_token).future_epoch_time_write()
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
192     _voting_escrow: address = self.voting_escrow
193     voting_balance: uint256 = ERC20(_voting_escrow).balanceOf(addr)
194     voting_total: uint256 = ERC20(_voting_escrow).totalSupply()
195 
196     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
197     if (voting_total > 0) and (block.timestamp > self.period_timestamp[0] + BOOST_WARMUP):
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
210 def _checkpoint_rewards(_addr: address, _total_supply: uint256):
211     """
212     @notice Claim pending rewards and checkpoint rewards for a user
213     """
214     if _total_supply == 0:
215         return
216 
217     balances: uint256[MAX_REWARDS] = empty(uint256[MAX_REWARDS])
218     reward_tokens: address[MAX_REWARDS] = empty(address[MAX_REWARDS])
219     for i in range(MAX_REWARDS):
220         token: address = self.reward_tokens[i]
221         if token == ZERO_ADDRESS:
222             break
223         reward_tokens[i] = token
224         balances[i] = ERC20(token).balanceOf(self)
225 
226     # claim from reward contract
227     raw_call(self.reward_contract, slice(self.reward_sigs, 8, 4))  # dev: bad claim sig
228 
229     for i in range(MAX_REWARDS):
230         token: address = reward_tokens[i]
231         if token == ZERO_ADDRESS:
232             break
233         dI: uint256 = 10**18 * (ERC20(token).balanceOf(self) - balances[i]) / _total_supply
234         if _addr == ZERO_ADDRESS:
235             if dI != 0:
236                 self.reward_integral[token] += dI
237             continue
238 
239         integral: uint256 = self.reward_integral[token] + dI
240         if dI != 0:
241             self.reward_integral[token] = integral
242 
243         integral_for: uint256 = self.reward_integral_for[token][_addr]
244         if integral_for < integral:
245             claimable: uint256 = self.balanceOf[_addr] * (integral - integral_for) / 10**18
246             self.reward_integral_for[token][_addr] = integral
247             assert ERC20(token).transfer(_addr, claimable)
248 
249 
250 @internal
251 def _checkpoint(addr: address):
252     """
253     @notice Checkpoint for a user
254     @param addr User address
255     """
256     _period: int128 = self.period
257     _period_time: uint256 = self.period_timestamp[_period]
258     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
259     rate: uint256 = self.inflation_rate
260     new_rate: uint256 = rate
261     prev_future_epoch: uint256 = self.future_epoch_time
262     if prev_future_epoch >= _period_time:
263         _token: address = self.crv_token
264         self.future_epoch_time = CRV20(_token).future_epoch_time_write()
265         new_rate = CRV20(_token).rate()
266         self.inflation_rate = new_rate
267 
268     if self.is_killed:
269         # Stop distributing inflation as soon as killed
270         rate = 0
271 
272     # Update integral of 1/supply
273     if block.timestamp > _period_time:
274         _working_supply: uint256 = self.working_supply
275         _controller: address = self.controller
276         Controller(_controller).checkpoint_gauge(self)
277         prev_week_time: uint256 = _period_time
278         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
279 
280         for i in range(500):
281             dt: uint256 = week_time - prev_week_time
282             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
283 
284             if _working_supply > 0:
285                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
286                     # If we went across one or multiple epochs, apply the rate
287                     # of the first epoch until it ends, and then the rate of
288                     # the last epoch.
289                     # If more than one epoch is crossed - the gauge gets less,
290                     # but that'd meen it wasn't called for more than 1 year
291                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
292                     rate = new_rate
293                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
294                 else:
295                     _integrate_inv_supply += rate * w * dt / _working_supply
296                 # On precisions of the calculation
297                 # rate ~= 10e18
298                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
299                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
300                 # The largest loss is at dt = 1
301                 # Loss is 1e-9 - acceptable
302 
303             if week_time == block.timestamp:
304                 break
305             prev_week_time = week_time
306             week_time = min(week_time + WEEK, block.timestamp)
307 
308     _period += 1
309     self.period = _period
310     self.period_timestamp[_period] = block.timestamp
311     self.integrate_inv_supply[_period] = _integrate_inv_supply
312 
313     # Update user-specific integrals
314     _working_balance: uint256 = self.working_balances[addr]
315     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
316     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
317     self.integrate_checkpoint_of[addr] = block.timestamp
318 
319 
320 @external
321 def user_checkpoint(addr: address) -> bool:
322     """
323     @notice Record a checkpoint for `addr`
324     @param addr User address
325     @return bool success
326     """
327     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
328     self._checkpoint(addr)
329     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
330     return True
331 
332 
333 @external
334 def claimable_tokens(addr: address) -> uint256:
335     """
336     @notice Get the number of claimable tokens per user
337     @dev This function should be manually changed to "view" in the ABI
338     @return uint256 number of claimable tokens per user
339     """
340     self._checkpoint(addr)
341     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
342 
343 
344 @external
345 @nonreentrant('lock')
346 def claimable_reward(_addr: address, _token: address) -> uint256:
347     """
348     @notice Get the number of claimable reward tokens for a user
349     @dev This function should be manually changed to "view" in the ABI
350          Calling it via a transaction will claim available reward tokens
351     @param _addr Account to get reward amount for
352     @param _token Token to get reward amount for
353     @return uint256 Claimable reward token amount
354     """
355     claimable: uint256 = ERC20(_token).balanceOf(_addr)
356     if self.reward_contract != ZERO_ADDRESS:
357         self._checkpoint_rewards(_addr, self.totalSupply)
358     claimable = ERC20(_token).balanceOf(_addr) - claimable
359 
360     integral: uint256 = self.reward_integral[_token]
361     integral_for: uint256 = self.reward_integral_for[_token][_addr]
362 
363     if integral_for < integral:
364         claimable += self.balanceOf[_addr] * (integral - integral_for) / 10**18
365 
366     return claimable
367 
368 
369 @external
370 @nonreentrant('lock')
371 def claim_rewards(_addr: address = msg.sender):
372     """
373     @notice Claim available reward tokens for `_addr`
374     @param _addr Address to claim for
375     """
376     self._checkpoint_rewards(_addr, self.totalSupply)
377 
378 
379 @external
380 @nonreentrant('lock')
381 def claim_historic_rewards(_reward_tokens: address[MAX_REWARDS], _addr: address = msg.sender):
382     """
383     @notice Claim reward tokens available from a previously-set staking contract
384     @param _reward_tokens Array of reward token addresses to claim
385     @param _addr Address to claim for
386     """
387     for token in _reward_tokens:
388         if token == ZERO_ADDRESS:
389             break
390         integral: uint256 = self.reward_integral[token]
391         integral_for: uint256 = self.reward_integral_for[token][_addr]
392 
393         if integral_for < integral:
394             claimable: uint256 = self.balanceOf[_addr] * (integral - integral_for) / 10**18
395             self.reward_integral_for[token][_addr] = integral
396             assert ERC20(token).transfer(_addr, claimable)
397 
398 
399 @external
400 def kick(addr: address):
401     """
402     @notice Kick `addr` for abusing their boost
403     @dev Only if either they had another voting event, or their voting escrow lock expired
404     @param addr Address to kick
405     """
406     _voting_escrow: address = self.voting_escrow
407     t_last: uint256 = self.integrate_checkpoint_of[addr]
408     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
409         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
410     )
411     _balance: uint256 = self.balanceOf[addr]
412 
413     assert ERC20(self.voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
414     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
415 
416     self._checkpoint(addr)
417     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
418 
419 
420 @external
421 def set_approve_deposit(addr: address, can_deposit: bool):
422     """
423     @notice Set whether `addr` can deposit tokens for `msg.sender`
424     @param addr Address to set approval on
425     @param can_deposit bool - can this account deposit for `msg.sender`?
426     """
427     self.approved_to_deposit[addr][msg.sender] = can_deposit
428 
429 
430 @external
431 @nonreentrant('lock')
432 def deposit(_value: uint256, _addr: address = msg.sender):
433     """
434     @notice Deposit `_value` LP tokens
435     @dev Depositting also claims pending reward tokens
436     @param _value Number of tokens to deposit
437     @param _addr Address to deposit for
438     """
439     if _addr != msg.sender:
440         assert self.approved_to_deposit[msg.sender][_addr], "Not approved"
441 
442     self._checkpoint(_addr)
443 
444     if _value != 0:
445         reward_contract: address = self.reward_contract
446         total_supply: uint256 = self.totalSupply
447         if reward_contract != ZERO_ADDRESS:
448             self._checkpoint_rewards(_addr, total_supply)
449 
450         total_supply += _value
451         new_balance: uint256 = self.balanceOf[_addr] + _value
452         self.balanceOf[_addr] = new_balance
453         self.totalSupply = total_supply
454 
455         self._update_liquidity_limit(_addr, new_balance, total_supply)
456 
457         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
458         if reward_contract != ZERO_ADDRESS:
459             deposit_sig: Bytes[4] = slice(self.reward_sigs, 0, 4)
460             if convert(deposit_sig, uint256) != 0:
461                 raw_call(
462                     reward_contract,
463                     concat(deposit_sig, convert(_value, bytes32))
464                 )
465 
466     log Deposit(_addr, _value)
467     log Transfer(ZERO_ADDRESS, _addr, _value)
468 
469 
470 @external
471 @nonreentrant('lock')
472 def withdraw(_value: uint256):
473     """
474     @notice Withdraw `_value` LP tokens
475     @dev Withdrawing also claims pending reward tokens
476     @param _value Number of tokens to withdraw
477     """
478     self._checkpoint(msg.sender)
479 
480     if _value != 0:
481         reward_contract: address = self.reward_contract
482         total_supply: uint256 = self.totalSupply
483         if reward_contract != ZERO_ADDRESS:
484             self._checkpoint_rewards(msg.sender, total_supply)
485 
486         total_supply -= _value
487         new_balance: uint256 = self.balanceOf[msg.sender] - _value
488         self.balanceOf[msg.sender] = new_balance
489         self.totalSupply = total_supply
490 
491         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
492 
493         if reward_contract != ZERO_ADDRESS:
494             withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
495             if convert(withdraw_sig, uint256) != 0:
496                 raw_call(
497                     reward_contract,
498                     concat(withdraw_sig, convert(_value, bytes32))
499                 )
500         ERC20(self.lp_token).transfer(msg.sender, _value)
501 
502     log Withdraw(msg.sender, _value)
503     log Transfer(msg.sender, ZERO_ADDRESS, _value)
504 
505 
506 @view
507 @external
508 def allowance(_owner : address, _spender : address) -> uint256:
509     """
510     @notice Check the amount of tokens that an owner allowed to a spender
511     @param _owner The address which owns the funds
512     @param _spender The address which will spend the funds
513     @return uint256 Amount of tokens still available for the spender
514     """
515     return self.allowances[_owner][_spender]
516 
517 
518 @internal
519 def _transfer(_from: address, _to: address, _value: uint256):
520     self._checkpoint(_from)
521     self._checkpoint(_to)
522     reward_contract: address = self.reward_contract
523 
524     if _value != 0:
525         total_supply: uint256 = self.totalSupply
526         if reward_contract != ZERO_ADDRESS:
527             self._checkpoint_rewards(_from, total_supply)
528         new_balance: uint256 = self.balanceOf[_from] - _value
529         self.balanceOf[_from] = new_balance
530         self._update_liquidity_limit(_from, new_balance, total_supply)
531 
532         if reward_contract != ZERO_ADDRESS:
533             self._checkpoint_rewards(_to, total_supply)
534         new_balance = self.balanceOf[_to] + _value
535         self.balanceOf[_to] = new_balance
536         self._update_liquidity_limit(_to, new_balance, total_supply)
537 
538     log Transfer(_from, _to, _value)
539 
540 
541 @external
542 @nonreentrant('lock')
543 def transfer(_to : address, _value : uint256) -> bool:
544     """
545     @notice Transfer token for a specified address
546     @dev Transferring claims pending reward tokens for the sender and receiver
547     @param _to The address to transfer to.
548     @param _value The amount to be transferred.
549     """
550     self._transfer(msg.sender, _to, _value)
551 
552     return True
553 
554 
555 @external
556 @nonreentrant('lock')
557 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
558     """
559      @notice Transfer tokens from one address to another.
560      @dev Transferring claims pending reward tokens for the sender and receiver
561      @param _from address The address which you want to send tokens from
562      @param _to address The address which you want to transfer to
563      @param _value uint256 the amount of tokens to be transferred
564     """
565     _allowance: uint256 = self.allowances[_from][msg.sender]
566     if _allowance != MAX_UINT256:
567         self.allowances[_from][msg.sender] = _allowance - _value
568 
569     self._transfer(_from, _to, _value)
570 
571     return True
572 
573 
574 @external
575 def approve(_spender : address, _value : uint256) -> bool:
576     """
577     @notice Approve the passed address to transfer the specified amount of
578             tokens on behalf of msg.sender
579     @dev Beware that changing an allowance via this method brings the risk
580          that someone may use both the old and new allowance by unfortunate
581          transaction ordering. This may be mitigated with the use of
582          {incraseAllowance} and {decreaseAllowance}.
583          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
584     @param _spender The address which will transfer the funds
585     @param _value The amount of tokens that may be transferred
586     @return bool success
587     """
588     self.allowances[msg.sender][_spender] = _value
589     log Approval(msg.sender, _spender, _value)
590 
591     return True
592 
593 
594 @external
595 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
596     """
597     @notice Increase the allowance granted to `_spender` by the caller
598     @dev This is alternative to {approve} that can be used as a mitigation for
599          the potential race condition
600     @param _spender The address which will transfer the funds
601     @param _added_value The amount of to increase the allowance
602     @return bool success
603     """
604     allowance: uint256 = self.allowances[msg.sender][_spender] + _added_value
605     self.allowances[msg.sender][_spender] = allowance
606 
607     log Approval(msg.sender, _spender, allowance)
608 
609     return True
610 
611 
612 @external
613 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
614     """
615     @notice Decrease the allowance granted to `_spender` by the caller
616     @dev This is alternative to {approve} that can be used as a mitigation for
617          the potential race condition
618     @param _spender The address which will transfer the funds
619     @param _subtracted_value The amount of to decrease the allowance
620     @return bool success
621     """
622     allowance: uint256 = self.allowances[msg.sender][_spender] - _subtracted_value
623     self.allowances[msg.sender][_spender] = allowance
624 
625     log Approval(msg.sender, _spender, allowance)
626 
627     return True
628 
629 
630 @external
631 @nonreentrant('lock')
632 def set_rewards(_reward_contract: address, _sigs: bytes32, _reward_tokens: address[MAX_REWARDS]):
633     """
634     @notice Set the active reward contract
635     @dev A reward contract cannot be set while this contract has no deposits
636     @param _reward_contract Reward contract address. Set to ZERO_ADDRESS to
637                             disable staking.
638     @param _sigs Four byte selectors for staking, withdrawing and claiming,
639                  right padded with zero bytes. If the reward contract can
640                  be claimed from but does not require staking, the staking
641                  and withdraw selectors should be set to 0x00
642     @param _reward_tokens List of claimable tokens for this reward contract
643     """
644     assert msg.sender == self.admin
645 
646     lp_token: address = self.lp_token
647     current_reward_contract: address = self.reward_contract
648     total_supply: uint256 = self.totalSupply
649     if current_reward_contract != ZERO_ADDRESS:
650         self._checkpoint_rewards(ZERO_ADDRESS, total_supply)
651         withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
652         if convert(withdraw_sig, uint256) != 0:
653             if total_supply != 0:
654                 raw_call(
655                     current_reward_contract,
656                     concat(withdraw_sig, convert(total_supply, bytes32))
657                 )
658             ERC20(lp_token).approve(current_reward_contract, 0)
659 
660     if _reward_contract != ZERO_ADDRESS:
661         assert _reward_contract.is_contract  # dev: not a contract
662         sigs: bytes32 = _sigs
663         deposit_sig: Bytes[4] = slice(sigs, 0, 4)
664         withdraw_sig: Bytes[4] = slice(sigs, 4, 4)
665 
666         if convert(deposit_sig, uint256) != 0:
667             # need a non-zero total supply to verify the sigs
668             assert total_supply != 0  # dev: zero total supply
669             ERC20(lp_token).approve(_reward_contract, MAX_UINT256)
670 
671             # it would be Very Bad if we get the signatures wrong here, so
672             # we do a test deposit and withdrawal prior to setting them
673             raw_call(
674                 _reward_contract,
675                 concat(deposit_sig, convert(total_supply, bytes32))
676             )  # dev: failed deposit
677             assert ERC20(lp_token).balanceOf(self) == 0
678             raw_call(
679                 _reward_contract,
680                 concat(withdraw_sig, convert(total_supply, bytes32))
681             )  # dev: failed withdraw
682             assert ERC20(lp_token).balanceOf(self) == total_supply
683 
684             # deposit and withdraw are good, time to make the actual deposit
685             raw_call(
686                 _reward_contract,
687                 concat(deposit_sig, convert(total_supply, bytes32))
688             )
689         else:
690             assert convert(withdraw_sig, uint256) == 0  # dev: withdraw without deposit
691 
692     self.reward_contract = _reward_contract
693     self.reward_sigs = _sigs
694     for i in range(MAX_REWARDS):
695         if _reward_tokens[i] != ZERO_ADDRESS:
696             self.reward_tokens[i] = _reward_tokens[i]
697         elif self.reward_tokens[i] != ZERO_ADDRESS:
698             self.reward_tokens[i] = ZERO_ADDRESS
699         else:
700             assert i != 0  # dev: no reward token
701             break
702 
703     if _reward_contract != ZERO_ADDRESS:
704         # do an initial checkpoint to verify that claims are working
705         self._checkpoint_rewards(ZERO_ADDRESS, total_supply)
706 
707 
708 @external
709 def set_killed(_is_killed: bool):
710     """
711     @notice Set the killed status for this contract
712     @dev When killed, the gauge always yields a rate of 0 and so cannot mint CRV
713     @param _is_killed Killed status to set
714     """
715     assert msg.sender == self.admin
716 
717     self.is_killed = _is_killed
718 
719 
720 @external
721 def commit_transfer_ownership(addr: address):
722     """
723     @notice Transfer ownership of GaugeController to `addr`
724     @param addr Address to have ownership transferred to
725     """
726     assert msg.sender == self.admin  # dev: admin only
727 
728     self.future_admin = addr
729     log CommitOwnership(addr)
730 
731 
732 @external
733 def accept_transfer_ownership():
734     """
735     @notice Accept a pending ownership transfer
736     """
737     _admin: address = self.future_admin
738     assert msg.sender == _admin  # dev: future admin only
739 
740     self.admin = _admin
741     log ApplyOwnership(_admin)