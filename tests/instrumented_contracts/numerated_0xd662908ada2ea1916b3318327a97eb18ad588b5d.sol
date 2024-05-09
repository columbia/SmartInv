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
247             response: Bytes[32] = raw_call(
248                 token,
249                 concat(
250                     method_id("transfer(address,uint256)"),
251                     convert(_addr, bytes32),
252                     convert(claimable, bytes32),
253                 ),
254                 max_outsize=32,
255             )
256             if len(response) != 0:
257                 assert convert(response, bool)
258 
259 
260 @internal
261 def _checkpoint(addr: address):
262     """
263     @notice Checkpoint for a user
264     @param addr User address
265     """
266     _period: int128 = self.period
267     _period_time: uint256 = self.period_timestamp[_period]
268     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
269     rate: uint256 = self.inflation_rate
270     new_rate: uint256 = rate
271     prev_future_epoch: uint256 = self.future_epoch_time
272     if prev_future_epoch >= _period_time:
273         _token: address = self.crv_token
274         self.future_epoch_time = CRV20(_token).future_epoch_time_write()
275         new_rate = CRV20(_token).rate()
276         self.inflation_rate = new_rate
277 
278     if self.is_killed:
279         # Stop distributing inflation as soon as killed
280         rate = 0
281 
282     # Update integral of 1/supply
283     if block.timestamp > _period_time:
284         _working_supply: uint256 = self.working_supply
285         _controller: address = self.controller
286         Controller(_controller).checkpoint_gauge(self)
287         prev_week_time: uint256 = _period_time
288         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
289 
290         for i in range(500):
291             dt: uint256 = week_time - prev_week_time
292             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
293 
294             if _working_supply > 0:
295                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
296                     # If we went across one or multiple epochs, apply the rate
297                     # of the first epoch until it ends, and then the rate of
298                     # the last epoch.
299                     # If more than one epoch is crossed - the gauge gets less,
300                     # but that'd meen it wasn't called for more than 1 year
301                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
302                     rate = new_rate
303                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
304                 else:
305                     _integrate_inv_supply += rate * w * dt / _working_supply
306                 # On precisions of the calculation
307                 # rate ~= 10e18
308                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
309                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
310                 # The largest loss is at dt = 1
311                 # Loss is 1e-9 - acceptable
312 
313             if week_time == block.timestamp:
314                 break
315             prev_week_time = week_time
316             week_time = min(week_time + WEEK, block.timestamp)
317 
318     _period += 1
319     self.period = _period
320     self.period_timestamp[_period] = block.timestamp
321     self.integrate_inv_supply[_period] = _integrate_inv_supply
322 
323     # Update user-specific integrals
324     _working_balance: uint256 = self.working_balances[addr]
325     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
326     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
327     self.integrate_checkpoint_of[addr] = block.timestamp
328 
329 
330 @external
331 def user_checkpoint(addr: address) -> bool:
332     """
333     @notice Record a checkpoint for `addr`
334     @param addr User address
335     @return bool success
336     """
337     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
338     self._checkpoint(addr)
339     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
340     return True
341 
342 
343 @external
344 def claimable_tokens(addr: address) -> uint256:
345     """
346     @notice Get the number of claimable tokens per user
347     @dev This function should be manually changed to "view" in the ABI
348     @return uint256 number of claimable tokens per user
349     """
350     self._checkpoint(addr)
351     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
352 
353 
354 @external
355 @nonreentrant('lock')
356 def claimable_reward(_addr: address, _token: address) -> uint256:
357     """
358     @notice Get the number of claimable reward tokens for a user
359     @dev This function should be manually changed to "view" in the ABI
360          Calling it via a transaction will claim available reward tokens
361     @param _addr Account to get reward amount for
362     @param _token Token to get reward amount for
363     @return uint256 Claimable reward token amount
364     """
365     claimable: uint256 = ERC20(_token).balanceOf(_addr)
366     if self.reward_contract != ZERO_ADDRESS:
367         self._checkpoint_rewards(_addr, self.totalSupply)
368     claimable = ERC20(_token).balanceOf(_addr) - claimable
369 
370     integral: uint256 = self.reward_integral[_token]
371     integral_for: uint256 = self.reward_integral_for[_token][_addr]
372 
373     if integral_for < integral:
374         claimable += self.balanceOf[_addr] * (integral - integral_for) / 10**18
375 
376     return claimable
377 
378 
379 @external
380 @nonreentrant('lock')
381 def claim_rewards(_addr: address = msg.sender):
382     """
383     @notice Claim available reward tokens for `_addr`
384     @param _addr Address to claim for
385     """
386     self._checkpoint_rewards(_addr, self.totalSupply)
387 
388 
389 @external
390 @nonreentrant('lock')
391 def claim_historic_rewards(_reward_tokens: address[MAX_REWARDS], _addr: address = msg.sender):
392     """
393     @notice Claim reward tokens available from a previously-set staking contract
394     @param _reward_tokens Array of reward token addresses to claim
395     @param _addr Address to claim for
396     """
397     for token in _reward_tokens:
398         if token == ZERO_ADDRESS:
399             break
400         integral: uint256 = self.reward_integral[token]
401         integral_for: uint256 = self.reward_integral_for[token][_addr]
402 
403         if integral_for < integral:
404             claimable: uint256 = self.balanceOf[_addr] * (integral - integral_for) / 10**18
405             self.reward_integral_for[token][_addr] = integral
406             response: Bytes[32] = raw_call(
407                 token,
408                 concat(
409                     method_id("transfer(address,uint256)"),
410                     convert(_addr, bytes32),
411                     convert(claimable, bytes32),
412                 ),
413                 max_outsize=32,
414             )
415             if len(response) != 0:
416                 assert convert(response, bool)
417 
418 
419 @external
420 def kick(addr: address):
421     """
422     @notice Kick `addr` for abusing their boost
423     @dev Only if either they had another voting event, or their voting escrow lock expired
424     @param addr Address to kick
425     """
426     _voting_escrow: address = self.voting_escrow
427     t_last: uint256 = self.integrate_checkpoint_of[addr]
428     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
429         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
430     )
431     _balance: uint256 = self.balanceOf[addr]
432 
433     assert ERC20(self.voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
434     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
435 
436     self._checkpoint(addr)
437     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
438 
439 
440 @external
441 def set_approve_deposit(addr: address, can_deposit: bool):
442     """
443     @notice Set whether `addr` can deposit tokens for `msg.sender`
444     @param addr Address to set approval on
445     @param can_deposit bool - can this account deposit for `msg.sender`?
446     """
447     self.approved_to_deposit[addr][msg.sender] = can_deposit
448 
449 
450 @external
451 @nonreentrant('lock')
452 def deposit(_value: uint256, _addr: address = msg.sender):
453     """
454     @notice Deposit `_value` LP tokens
455     @dev Depositting also claims pending reward tokens
456     @param _value Number of tokens to deposit
457     @param _addr Address to deposit for
458     """
459     if _addr != msg.sender:
460         assert self.approved_to_deposit[msg.sender][_addr], "Not approved"
461 
462     self._checkpoint(_addr)
463 
464     if _value != 0:
465         reward_contract: address = self.reward_contract
466         total_supply: uint256 = self.totalSupply
467         if reward_contract != ZERO_ADDRESS:
468             self._checkpoint_rewards(_addr, total_supply)
469 
470         total_supply += _value
471         new_balance: uint256 = self.balanceOf[_addr] + _value
472         self.balanceOf[_addr] = new_balance
473         self.totalSupply = total_supply
474 
475         self._update_liquidity_limit(_addr, new_balance, total_supply)
476 
477         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
478         if reward_contract != ZERO_ADDRESS:
479             deposit_sig: Bytes[4] = slice(self.reward_sigs, 0, 4)
480             if convert(deposit_sig, uint256) != 0:
481                 raw_call(
482                     reward_contract,
483                     concat(deposit_sig, convert(_value, bytes32))
484                 )
485 
486     log Deposit(_addr, _value)
487     log Transfer(ZERO_ADDRESS, _addr, _value)
488 
489 
490 @external
491 @nonreentrant('lock')
492 def withdraw(_value: uint256):
493     """
494     @notice Withdraw `_value` LP tokens
495     @dev Withdrawing also claims pending reward tokens
496     @param _value Number of tokens to withdraw
497     """
498     self._checkpoint(msg.sender)
499 
500     if _value != 0:
501         reward_contract: address = self.reward_contract
502         total_supply: uint256 = self.totalSupply
503         if reward_contract != ZERO_ADDRESS:
504             self._checkpoint_rewards(msg.sender, total_supply)
505 
506         total_supply -= _value
507         new_balance: uint256 = self.balanceOf[msg.sender] - _value
508         self.balanceOf[msg.sender] = new_balance
509         self.totalSupply = total_supply
510 
511         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
512 
513         if reward_contract != ZERO_ADDRESS:
514             withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
515             if convert(withdraw_sig, uint256) != 0:
516                 raw_call(
517                     reward_contract,
518                     concat(withdraw_sig, convert(_value, bytes32))
519                 )
520         ERC20(self.lp_token).transfer(msg.sender, _value)
521 
522     log Withdraw(msg.sender, _value)
523     log Transfer(msg.sender, ZERO_ADDRESS, _value)
524 
525 
526 @view
527 @external
528 def allowance(_owner : address, _spender : address) -> uint256:
529     """
530     @notice Check the amount of tokens that an owner allowed to a spender
531     @param _owner The address which owns the funds
532     @param _spender The address which will spend the funds
533     @return uint256 Amount of tokens still available for the spender
534     """
535     return self.allowances[_owner][_spender]
536 
537 
538 @internal
539 def _transfer(_from: address, _to: address, _value: uint256):
540     self._checkpoint(_from)
541     self._checkpoint(_to)
542     reward_contract: address = self.reward_contract
543 
544     if _value != 0:
545         total_supply: uint256 = self.totalSupply
546         if reward_contract != ZERO_ADDRESS:
547             self._checkpoint_rewards(_from, total_supply)
548         new_balance: uint256 = self.balanceOf[_from] - _value
549         self.balanceOf[_from] = new_balance
550         self._update_liquidity_limit(_from, new_balance, total_supply)
551 
552         if reward_contract != ZERO_ADDRESS:
553             self._checkpoint_rewards(_to, total_supply)
554         new_balance = self.balanceOf[_to] + _value
555         self.balanceOf[_to] = new_balance
556         self._update_liquidity_limit(_to, new_balance, total_supply)
557 
558     log Transfer(_from, _to, _value)
559 
560 
561 @external
562 @nonreentrant('lock')
563 def transfer(_to : address, _value : uint256) -> bool:
564     """
565     @notice Transfer token for a specified address
566     @dev Transferring claims pending reward tokens for the sender and receiver
567     @param _to The address to transfer to.
568     @param _value The amount to be transferred.
569     """
570     self._transfer(msg.sender, _to, _value)
571 
572     return True
573 
574 
575 @external
576 @nonreentrant('lock')
577 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
578     """
579      @notice Transfer tokens from one address to another.
580      @dev Transferring claims pending reward tokens for the sender and receiver
581      @param _from address The address which you want to send tokens from
582      @param _to address The address which you want to transfer to
583      @param _value uint256 the amount of tokens to be transferred
584     """
585     _allowance: uint256 = self.allowances[_from][msg.sender]
586     if _allowance != MAX_UINT256:
587         self.allowances[_from][msg.sender] = _allowance - _value
588 
589     self._transfer(_from, _to, _value)
590 
591     return True
592 
593 
594 @external
595 def approve(_spender : address, _value : uint256) -> bool:
596     """
597     @notice Approve the passed address to transfer the specified amount of
598             tokens on behalf of msg.sender
599     @dev Beware that changing an allowance via this method brings the risk
600          that someone may use both the old and new allowance by unfortunate
601          transaction ordering. This may be mitigated with the use of
602          {incraseAllowance} and {decreaseAllowance}.
603          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
604     @param _spender The address which will transfer the funds
605     @param _value The amount of tokens that may be transferred
606     @return bool success
607     """
608     self.allowances[msg.sender][_spender] = _value
609     log Approval(msg.sender, _spender, _value)
610 
611     return True
612 
613 
614 @external
615 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
616     """
617     @notice Increase the allowance granted to `_spender` by the caller
618     @dev This is alternative to {approve} that can be used as a mitigation for
619          the potential race condition
620     @param _spender The address which will transfer the funds
621     @param _added_value The amount of to increase the allowance
622     @return bool success
623     """
624     allowance: uint256 = self.allowances[msg.sender][_spender] + _added_value
625     self.allowances[msg.sender][_spender] = allowance
626 
627     log Approval(msg.sender, _spender, allowance)
628 
629     return True
630 
631 
632 @external
633 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
634     """
635     @notice Decrease the allowance granted to `_spender` by the caller
636     @dev This is alternative to {approve} that can be used as a mitigation for
637          the potential race condition
638     @param _spender The address which will transfer the funds
639     @param _subtracted_value The amount of to decrease the allowance
640     @return bool success
641     """
642     allowance: uint256 = self.allowances[msg.sender][_spender] - _subtracted_value
643     self.allowances[msg.sender][_spender] = allowance
644 
645     log Approval(msg.sender, _spender, allowance)
646 
647     return True
648 
649 
650 @external
651 @nonreentrant('lock')
652 def set_rewards(_reward_contract: address, _sigs: bytes32, _reward_tokens: address[MAX_REWARDS]):
653     """
654     @notice Set the active reward contract
655     @dev A reward contract cannot be set while this contract has no deposits
656     @param _reward_contract Reward contract address. Set to ZERO_ADDRESS to
657                             disable staking.
658     @param _sigs Four byte selectors for staking, withdrawing and claiming,
659                  right padded with zero bytes. If the reward contract can
660                  be claimed from but does not require staking, the staking
661                  and withdraw selectors should be set to 0x00
662     @param _reward_tokens List of claimable tokens for this reward contract
663     """
664     assert msg.sender == self.admin
665 
666     lp_token: address = self.lp_token
667     current_reward_contract: address = self.reward_contract
668     total_supply: uint256 = self.totalSupply
669     if current_reward_contract != ZERO_ADDRESS:
670         self._checkpoint_rewards(ZERO_ADDRESS, total_supply)
671         withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
672         if convert(withdraw_sig, uint256) != 0:
673             if total_supply != 0:
674                 raw_call(
675                     current_reward_contract,
676                     concat(withdraw_sig, convert(total_supply, bytes32))
677                 )
678             ERC20(lp_token).approve(current_reward_contract, 0)
679 
680     if _reward_contract != ZERO_ADDRESS:
681         assert _reward_contract.is_contract  # dev: not a contract
682         sigs: bytes32 = _sigs
683         deposit_sig: Bytes[4] = slice(sigs, 0, 4)
684         withdraw_sig: Bytes[4] = slice(sigs, 4, 4)
685 
686         if convert(deposit_sig, uint256) != 0:
687             # need a non-zero total supply to verify the sigs
688             assert total_supply != 0  # dev: zero total supply
689             ERC20(lp_token).approve(_reward_contract, MAX_UINT256)
690 
691             # it would be Very Bad if we get the signatures wrong here, so
692             # we do a test deposit and withdrawal prior to setting them
693             raw_call(
694                 _reward_contract,
695                 concat(deposit_sig, convert(total_supply, bytes32))
696             )  # dev: failed deposit
697             assert ERC20(lp_token).balanceOf(self) == 0
698             raw_call(
699                 _reward_contract,
700                 concat(withdraw_sig, convert(total_supply, bytes32))
701             )  # dev: failed withdraw
702             assert ERC20(lp_token).balanceOf(self) == total_supply
703 
704             # deposit and withdraw are good, time to make the actual deposit
705             raw_call(
706                 _reward_contract,
707                 concat(deposit_sig, convert(total_supply, bytes32))
708             )
709         else:
710             assert convert(withdraw_sig, uint256) == 0  # dev: withdraw without deposit
711 
712     self.reward_contract = _reward_contract
713     self.reward_sigs = _sigs
714     for i in range(MAX_REWARDS):
715         if _reward_tokens[i] != ZERO_ADDRESS:
716             self.reward_tokens[i] = _reward_tokens[i]
717         elif self.reward_tokens[i] != ZERO_ADDRESS:
718             self.reward_tokens[i] = ZERO_ADDRESS
719         else:
720             assert i != 0  # dev: no reward token
721             break
722 
723     if _reward_contract != ZERO_ADDRESS:
724         # do an initial checkpoint to verify that claims are working
725         self._checkpoint_rewards(ZERO_ADDRESS, total_supply)
726 
727 
728 @external
729 def set_killed(_is_killed: bool):
730     """
731     @notice Set the killed status for this contract
732     @dev When killed, the gauge always yields a rate of 0 and so cannot mint CRV
733     @param _is_killed Killed status to set
734     """
735     assert msg.sender == self.admin
736 
737     self.is_killed = _is_killed
738 
739 
740 @external
741 def commit_transfer_ownership(addr: address):
742     """
743     @notice Transfer ownership of GaugeController to `addr`
744     @param addr Address to have ownership transferred to
745     """
746     assert msg.sender == self.admin  # dev: admin only
747 
748     self.future_admin = addr
749     log CommitOwnership(addr)
750 
751 
752 @external
753 def accept_transfer_ownership():
754     """
755     @notice Accept a pending ownership transfer
756     """
757     _admin: address = self.future_admin
758     assert msg.sender == _admin  # dev: future admin only
759 
760     self.admin = _admin
761     log ApplyOwnership(_admin)