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
74 
75 minter: public(address)
76 crv_token: public(address)
77 lp_token: public(address)
78 controller: public(address)
79 voting_escrow: public(address)
80 future_epoch_time: public(uint256)
81 
82 balanceOf: public(HashMap[address, uint256])
83 totalSupply: public(uint256)
84 allowances: HashMap[address, HashMap[address, uint256]]
85 
86 name: public(String[64])
87 symbol: public(String[32])
88 
89 # caller -> recipient -> can deposit?
90 approved_to_deposit: public(HashMap[address, HashMap[address, bool]])
91 
92 working_balances: public(HashMap[address, uint256])
93 working_supply: public(uint256)
94 
95 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
96 # All values are kept in units of being multiplied by 1e18
97 period: public(int128)
98 period_timestamp: public(uint256[100000000000000000000000000000])
99 
100 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
101 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
102 
103 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
104 integrate_inv_supply_of: public(HashMap[address, uint256])
105 integrate_checkpoint_of: public(HashMap[address, uint256])
106 
107 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
108 # Units: rate * t = already number of coins per address to issue
109 integrate_fraction: public(HashMap[address, uint256])
110 
111 inflation_rate: public(uint256)
112 
113 # For tracking external rewards
114 reward_contract: public(address)
115 reward_tokens: public(address[MAX_REWARDS])
116 
117 # deposit / withdraw / claim
118 reward_sigs: bytes32
119 
120 # reward token -> integral
121 reward_integral: public(HashMap[address, uint256])
122 
123 # reward token -> claiming address -> integral
124 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
125 
126 admin: public(address)
127 future_admin: public(address)  # Can and will be a smart contract
128 is_killed: public(bool)
129 
130 
131 @external
132 def __init__(_lp_token: address, _minter: address, _admin: address):
133     """
134     @notice Contract constructor
135     @param _lp_token Liquidity Pool contract address
136     @param _minter Minter contract address
137     @param _admin Admin who can kill the gauge
138     """
139 
140     symbol: String[26] = ERC20Extended(_lp_token).symbol()
141     self.name = concat("Curve.fi ", symbol, " Gauge Deposit")
142     self.symbol = concat(symbol, "-gauge")
143 
144     crv_token: address = Minter(_minter).token()
145     controller: address = Minter(_minter).controller()
146 
147     self.lp_token = _lp_token
148     self.minter = _minter
149     self.admin = _admin
150     self.crv_token = crv_token
151     self.controller = controller
152     self.voting_escrow = Controller(controller).voting_escrow()
153 
154     self.period_timestamp[0] = block.timestamp
155     self.inflation_rate = CRV20(crv_token).rate()
156     self.future_epoch_time = CRV20(crv_token).future_epoch_time_write()
157 
158 
159 @view
160 @external
161 def decimals() -> uint256:
162     """
163     @notice Get the number of decimals for this token
164     @dev Implemented as a view method to reduce gas costs
165     @return uint256 decimal places
166     """
167     return 18
168 
169 
170 @view
171 @external
172 def integrate_checkpoint() -> uint256:
173     return self.period_timestamp[self.period]
174 
175 
176 @internal
177 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
178     """
179     @notice Calculate limits which depend on the amount of CRV token per-user.
180             Effectively it calculates working balances to apply amplification
181             of CRV production by CRV
182     @param addr User address
183     @param l User's amount of liquidity (LP tokens)
184     @param L Total amount of liquidity (LP tokens)
185     """
186     # To be called after totalSupply is updated
187     _voting_escrow: address = self.voting_escrow
188     voting_balance: uint256 = ERC20(_voting_escrow).balanceOf(addr)
189     voting_total: uint256 = ERC20(_voting_escrow).totalSupply()
190 
191     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
192     if voting_total > 0:
193         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
194 
195     lim = min(l, lim)
196     old_bal: uint256 = self.working_balances[addr]
197     self.working_balances[addr] = lim
198     _working_supply: uint256 = self.working_supply + lim - old_bal
199     self.working_supply = _working_supply
200 
201     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
202 
203 
204 @internal
205 def _checkpoint_rewards(_addr: address, _total_supply: uint256):
206     """
207     @notice Claim pending rewards and checkpoint rewards for a user
208     """
209     if _total_supply == 0:
210         return
211 
212     reward_balances: uint256[MAX_REWARDS] = empty(uint256[MAX_REWARDS])
213     reward_tokens: address[MAX_REWARDS] = empty(address[MAX_REWARDS])
214     for i in range(MAX_REWARDS):
215         token: address = self.reward_tokens[i]
216         if token == ZERO_ADDRESS:
217             break
218         reward_tokens[i] = token
219         reward_balances[i] = ERC20(token).balanceOf(self)
220 
221     # claim from reward contract
222     raw_call(self.reward_contract, slice(self.reward_sigs, 8, 4))  # dev: bad claim sig
223 
224     user_balance: uint256 = self.balanceOf[_addr]
225     for i in range(MAX_REWARDS):
226         token: address = reward_tokens[i]
227         if token == ZERO_ADDRESS:
228             break
229         dI: uint256 = 10**18 * (ERC20(token).balanceOf(self) - reward_balances[i]) / _total_supply
230         if _addr == ZERO_ADDRESS:
231             if dI != 0:
232                 self.reward_integral[token] += dI
233             continue
234 
235         integral: uint256 = self.reward_integral[token] + dI
236         if dI != 0:
237             self.reward_integral[token] = integral
238 
239         integral_for: uint256 = self.reward_integral_for[token][_addr]
240         if integral_for < integral:
241             claimable: uint256 = user_balance * (integral - integral_for) / 10**18
242             self.reward_integral_for[token][_addr] = integral
243             if claimable != 0:
244                 response: Bytes[32] = raw_call(
245                     token,
246                     concat(
247                         method_id("transfer(address,uint256)"),
248                         convert(_addr, bytes32),
249                         convert(claimable, bytes32),
250                     ),
251                     max_outsize=32,
252                 )
253                 if len(response) != 0:
254                     assert convert(response, bool)
255 
256 
257 @internal
258 def _checkpoint(addr: address):
259     """
260     @notice Checkpoint for a user
261     @param addr User address
262     """
263     _period: int128 = self.period
264     _period_time: uint256 = self.period_timestamp[_period]
265     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
266     rate: uint256 = self.inflation_rate
267     new_rate: uint256 = rate
268     prev_future_epoch: uint256 = self.future_epoch_time
269     if prev_future_epoch >= _period_time:
270         _token: address = self.crv_token
271         self.future_epoch_time = CRV20(_token).future_epoch_time_write()
272         new_rate = CRV20(_token).rate()
273         self.inflation_rate = new_rate
274 
275     if self.is_killed:
276         # Stop distributing inflation as soon as killed
277         rate = 0
278 
279     # Update integral of 1/supply
280     if block.timestamp > _period_time:
281         _working_supply: uint256 = self.working_supply
282         _controller: address = self.controller
283         Controller(_controller).checkpoint_gauge(self)
284         prev_week_time: uint256 = _period_time
285         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
286 
287         for i in range(500):
288             dt: uint256 = week_time - prev_week_time
289             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
290 
291             if _working_supply > 0:
292                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
293                     # If we went across one or multiple epochs, apply the rate
294                     # of the first epoch until it ends, and then the rate of
295                     # the last epoch.
296                     # If more than one epoch is crossed - the gauge gets less,
297                     # but that'd meen it wasn't called for more than 1 year
298                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
299                     rate = new_rate
300                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
301                 else:
302                     _integrate_inv_supply += rate * w * dt / _working_supply
303                 # On precisions of the calculation
304                 # rate ~= 10e18
305                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
306                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
307                 # The largest loss is at dt = 1
308                 # Loss is 1e-9 - acceptable
309 
310             if week_time == block.timestamp:
311                 break
312             prev_week_time = week_time
313             week_time = min(week_time + WEEK, block.timestamp)
314 
315     _period += 1
316     self.period = _period
317     self.period_timestamp[_period] = block.timestamp
318     self.integrate_inv_supply[_period] = _integrate_inv_supply
319 
320     # Update user-specific integrals
321     _working_balance: uint256 = self.working_balances[addr]
322     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
323     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
324     self.integrate_checkpoint_of[addr] = block.timestamp
325 
326 
327 @external
328 def user_checkpoint(addr: address) -> bool:
329     """
330     @notice Record a checkpoint for `addr`
331     @param addr User address
332     @return bool success
333     """
334     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
335     self._checkpoint(addr)
336     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
337     return True
338 
339 
340 @external
341 def claimable_tokens(addr: address) -> uint256:
342     """
343     @notice Get the number of claimable tokens per user
344     @dev This function should be manually changed to "view" in the ABI
345     @return uint256 number of claimable tokens per user
346     """
347     self._checkpoint(addr)
348     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
349 
350 
351 @external
352 @nonreentrant('lock')
353 def claimable_reward(_addr: address, _token: address) -> uint256:
354     """
355     @notice Get the number of claimable reward tokens for a user
356     @dev This function should be manually changed to "view" in the ABI
357          Calling it via a transaction will claim available reward tokens
358     @param _addr Account to get reward amount for
359     @param _token Token to get reward amount for
360     @return uint256 Claimable reward token amount
361     """
362     claimable: uint256 = ERC20(_token).balanceOf(_addr)
363     if self.reward_contract != ZERO_ADDRESS:
364         self._checkpoint_rewards(_addr, self.totalSupply)
365     claimable = ERC20(_token).balanceOf(_addr) - claimable
366 
367     integral: uint256 = self.reward_integral[_token]
368     integral_for: uint256 = self.reward_integral_for[_token][_addr]
369 
370     if integral_for < integral:
371         claimable += self.balanceOf[_addr] * (integral - integral_for) / 10**18
372 
373     return claimable
374 
375 
376 @external
377 @nonreentrant('lock')
378 def claim_rewards(_addr: address = msg.sender):
379     """
380     @notice Claim available reward tokens for `_addr`
381     @param _addr Address to claim for
382     """
383     self._checkpoint_rewards(_addr, self.totalSupply)
384 
385 
386 @external
387 @nonreentrant('lock')
388 def claim_historic_rewards(_reward_tokens: address[MAX_REWARDS], _addr: address = msg.sender):
389     """
390     @notice Claim reward tokens available from a previously-set staking contract
391     @param _reward_tokens Array of reward token addresses to claim
392     @param _addr Address to claim for
393     """
394     for token in _reward_tokens:
395         if token == ZERO_ADDRESS:
396             break
397         integral: uint256 = self.reward_integral[token]
398         integral_for: uint256 = self.reward_integral_for[token][_addr]
399 
400         if integral_for < integral:
401             claimable: uint256 = self.balanceOf[_addr] * (integral - integral_for) / 10**18
402             self.reward_integral_for[token][_addr] = integral
403             response: Bytes[32] = raw_call(
404                 token,
405                 concat(
406                     method_id("transfer(address,uint256)"),
407                     convert(_addr, bytes32),
408                     convert(claimable, bytes32),
409                 ),
410                 max_outsize=32,
411             )
412             if len(response) != 0:
413                 assert convert(response, bool)
414 
415 
416 @external
417 def kick(addr: address):
418     """
419     @notice Kick `addr` for abusing their boost
420     @dev Only if either they had another voting event, or their voting escrow lock expired
421     @param addr Address to kick
422     """
423     _voting_escrow: address = self.voting_escrow
424     t_last: uint256 = self.integrate_checkpoint_of[addr]
425     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
426         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
427     )
428     _balance: uint256 = self.balanceOf[addr]
429 
430     assert ERC20(self.voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
431     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
432 
433     self._checkpoint(addr)
434     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
435 
436 
437 @external
438 def set_approve_deposit(addr: address, can_deposit: bool):
439     """
440     @notice Set whether `addr` can deposit tokens for `msg.sender`
441     @param addr Address to set approval on
442     @param can_deposit bool - can this account deposit for `msg.sender`?
443     """
444     self.approved_to_deposit[addr][msg.sender] = can_deposit
445 
446 
447 @external
448 @nonreentrant('lock')
449 def deposit(_value: uint256, _addr: address = msg.sender):
450     """
451     @notice Deposit `_value` LP tokens
452     @dev Depositting also claims pending reward tokens
453     @param _value Number of tokens to deposit
454     @param _addr Address to deposit for
455     """
456     if _addr != msg.sender:
457         assert self.approved_to_deposit[msg.sender][_addr], "Not approved"
458 
459     self._checkpoint(_addr)
460 
461     if _value != 0:
462         reward_contract: address = self.reward_contract
463         total_supply: uint256 = self.totalSupply
464         if reward_contract != ZERO_ADDRESS:
465             self._checkpoint_rewards(_addr, total_supply)
466 
467         total_supply += _value
468         new_balance: uint256 = self.balanceOf[_addr] + _value
469         self.balanceOf[_addr] = new_balance
470         self.totalSupply = total_supply
471 
472         self._update_liquidity_limit(_addr, new_balance, total_supply)
473 
474         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
475         if reward_contract != ZERO_ADDRESS:
476             deposit_sig: Bytes[4] = slice(self.reward_sigs, 0, 4)
477             if convert(deposit_sig, uint256) != 0:
478                 raw_call(
479                     reward_contract,
480                     concat(deposit_sig, convert(_value, bytes32))
481                 )
482 
483     log Deposit(_addr, _value)
484     log Transfer(ZERO_ADDRESS, _addr, _value)
485 
486 
487 @external
488 @nonreentrant('lock')
489 def withdraw(_value: uint256):
490     """
491     @notice Withdraw `_value` LP tokens
492     @dev Withdrawing also claims pending reward tokens
493     @param _value Number of tokens to withdraw
494     """
495     self._checkpoint(msg.sender)
496 
497     if _value != 0:
498         reward_contract: address = self.reward_contract
499         total_supply: uint256 = self.totalSupply
500         if reward_contract != ZERO_ADDRESS:
501             self._checkpoint_rewards(msg.sender, total_supply)
502 
503         total_supply -= _value
504         new_balance: uint256 = self.balanceOf[msg.sender] - _value
505         self.balanceOf[msg.sender] = new_balance
506         self.totalSupply = total_supply
507 
508         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
509 
510         if reward_contract != ZERO_ADDRESS:
511             withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
512             if convert(withdraw_sig, uint256) != 0:
513                 raw_call(
514                     reward_contract,
515                     concat(withdraw_sig, convert(_value, bytes32))
516                 )
517         ERC20(self.lp_token).transfer(msg.sender, _value)
518 
519     log Withdraw(msg.sender, _value)
520     log Transfer(msg.sender, ZERO_ADDRESS, _value)
521 
522 
523 @view
524 @external
525 def allowance(_owner : address, _spender : address) -> uint256:
526     """
527     @notice Check the amount of tokens that an owner allowed to a spender
528     @param _owner The address which owns the funds
529     @param _spender The address which will spend the funds
530     @return uint256 Amount of tokens still available for the spender
531     """
532     return self.allowances[_owner][_spender]
533 
534 
535 @internal
536 def _transfer(_from: address, _to: address, _value: uint256):
537     self._checkpoint(_from)
538     self._checkpoint(_to)
539     reward_contract: address = self.reward_contract
540 
541     if _value != 0:
542         total_supply: uint256 = self.totalSupply
543         if reward_contract != ZERO_ADDRESS:
544             self._checkpoint_rewards(_from, total_supply)
545         new_balance: uint256 = self.balanceOf[_from] - _value
546         self.balanceOf[_from] = new_balance
547         self._update_liquidity_limit(_from, new_balance, total_supply)
548 
549         if reward_contract != ZERO_ADDRESS:
550             self._checkpoint_rewards(_to, total_supply)
551         new_balance = self.balanceOf[_to] + _value
552         self.balanceOf[_to] = new_balance
553         self._update_liquidity_limit(_to, new_balance, total_supply)
554 
555     log Transfer(_from, _to, _value)
556 
557 
558 @external
559 @nonreentrant('lock')
560 def transfer(_to : address, _value : uint256) -> bool:
561     """
562     @notice Transfer token for a specified address
563     @dev Transferring claims pending reward tokens for the sender and receiver
564     @param _to The address to transfer to.
565     @param _value The amount to be transferred.
566     """
567     self._transfer(msg.sender, _to, _value)
568 
569     return True
570 
571 
572 @external
573 @nonreentrant('lock')
574 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
575     """
576      @notice Transfer tokens from one address to another.
577      @dev Transferring claims pending reward tokens for the sender and receiver
578      @param _from address The address which you want to send tokens from
579      @param _to address The address which you want to transfer to
580      @param _value uint256 the amount of tokens to be transferred
581     """
582     _allowance: uint256 = self.allowances[_from][msg.sender]
583     if _allowance != MAX_UINT256:
584         self.allowances[_from][msg.sender] = _allowance - _value
585 
586     self._transfer(_from, _to, _value)
587 
588     return True
589 
590 
591 @external
592 def approve(_spender : address, _value : uint256) -> bool:
593     """
594     @notice Approve the passed address to transfer the specified amount of
595             tokens on behalf of msg.sender
596     @dev Beware that changing an allowance via this method brings the risk
597          that someone may use both the old and new allowance by unfortunate
598          transaction ordering. This may be mitigated with the use of
599          {incraseAllowance} and {decreaseAllowance}.
600          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
601     @param _spender The address which will transfer the funds
602     @param _value The amount of tokens that may be transferred
603     @return bool success
604     """
605     self.allowances[msg.sender][_spender] = _value
606     log Approval(msg.sender, _spender, _value)
607 
608     return True
609 
610 
611 @external
612 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
613     """
614     @notice Increase the allowance granted to `_spender` by the caller
615     @dev This is alternative to {approve} that can be used as a mitigation for
616          the potential race condition
617     @param _spender The address which will transfer the funds
618     @param _added_value The amount of to increase the allowance
619     @return bool success
620     """
621     allowance: uint256 = self.allowances[msg.sender][_spender] + _added_value
622     self.allowances[msg.sender][_spender] = allowance
623 
624     log Approval(msg.sender, _spender, allowance)
625 
626     return True
627 
628 
629 @external
630 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
631     """
632     @notice Decrease the allowance granted to `_spender` by the caller
633     @dev This is alternative to {approve} that can be used as a mitigation for
634          the potential race condition
635     @param _spender The address which will transfer the funds
636     @param _subtracted_value The amount of to decrease the allowance
637     @return bool success
638     """
639     allowance: uint256 = self.allowances[msg.sender][_spender] - _subtracted_value
640     self.allowances[msg.sender][_spender] = allowance
641 
642     log Approval(msg.sender, _spender, allowance)
643 
644     return True
645 
646 
647 @external
648 @nonreentrant('lock')
649 def set_rewards(_reward_contract: address, _sigs: bytes32, _reward_tokens: address[MAX_REWARDS]):
650     """
651     @notice Set the active reward contract
652     @dev A reward contract cannot be set while this contract has no deposits
653     @param _reward_contract Reward contract address. Set to ZERO_ADDRESS to
654                             disable staking.
655     @param _sigs Four byte selectors for staking, withdrawing and claiming,
656                  right padded with zero bytes. If the reward contract can
657                  be claimed from but does not require staking, the staking
658                  and withdraw selectors should be set to 0x00
659     @param _reward_tokens List of claimable tokens for this reward contract
660     """
661     assert msg.sender == self.admin
662 
663     lp_token: address = self.lp_token
664     current_reward_contract: address = self.reward_contract
665     total_supply: uint256 = self.totalSupply
666     if current_reward_contract != ZERO_ADDRESS:
667         self._checkpoint_rewards(ZERO_ADDRESS, total_supply)
668         withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
669         if convert(withdraw_sig, uint256) != 0:
670             if total_supply != 0:
671                 raw_call(
672                     current_reward_contract,
673                     concat(withdraw_sig, convert(total_supply, bytes32))
674                 )
675             ERC20(lp_token).approve(current_reward_contract, 0)
676 
677     if _reward_contract != ZERO_ADDRESS:
678         assert _reward_contract.is_contract  # dev: not a contract
679         sigs: bytes32 = _sigs
680         deposit_sig: Bytes[4] = slice(sigs, 0, 4)
681         withdraw_sig: Bytes[4] = slice(sigs, 4, 4)
682 
683         if convert(deposit_sig, uint256) != 0:
684             # need a non-zero total supply to verify the sigs
685             assert total_supply != 0  # dev: zero total supply
686             ERC20(lp_token).approve(_reward_contract, MAX_UINT256)
687 
688             # it would be Very Bad if we get the signatures wrong here, so
689             # we do a test deposit and withdrawal prior to setting them
690             raw_call(
691                 _reward_contract,
692                 concat(deposit_sig, convert(total_supply, bytes32))
693             )  # dev: failed deposit
694             assert ERC20(lp_token).balanceOf(self) == 0
695             raw_call(
696                 _reward_contract,
697                 concat(withdraw_sig, convert(total_supply, bytes32))
698             )  # dev: failed withdraw
699             assert ERC20(lp_token).balanceOf(self) == total_supply
700 
701             # deposit and withdraw are good, time to make the actual deposit
702             raw_call(
703                 _reward_contract,
704                 concat(deposit_sig, convert(total_supply, bytes32))
705             )
706         else:
707             assert convert(withdraw_sig, uint256) == 0  # dev: withdraw without deposit
708 
709     self.reward_contract = _reward_contract
710     self.reward_sigs = _sigs
711     for i in range(MAX_REWARDS):
712         if _reward_tokens[i] != ZERO_ADDRESS:
713             self.reward_tokens[i] = _reward_tokens[i]
714         elif self.reward_tokens[i] != ZERO_ADDRESS:
715             self.reward_tokens[i] = ZERO_ADDRESS
716         else:
717             assert i != 0  # dev: no reward token
718             break
719 
720     if _reward_contract != ZERO_ADDRESS:
721         # do an initial checkpoint to verify that claims are working
722         self._checkpoint_rewards(ZERO_ADDRESS, total_supply)
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