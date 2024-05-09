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
74 CLAIM_FREQUENCY: constant(uint256) = 3600
75 
76 minter: public(address)
77 crv_token: public(address)
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
145     self.name = concat("Curve.fi ", symbol, " Gauge Deposit")
146     self.symbol = concat(symbol, "-gauge")
147 
148     crv_token: address = Minter(_minter).token()
149     controller: address = Minter(_minter).controller()
150 
151     self.lp_token = _lp_token
152     self.minter = _minter
153     self.admin = _admin
154     self.crv_token = crv_token
155     self.controller = controller
156     self.voting_escrow = Controller(controller).voting_escrow()
157 
158     self.period_timestamp[0] = block.timestamp
159     self.inflation_rate = CRV20(crv_token).rate()
160     self.future_epoch_time = CRV20(crv_token).future_epoch_time_write()
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
183     @notice Calculate limits which depend on the amount of CRV token per-user.
184             Effectively it calculates working balances to apply amplification
185             of CRV production by CRV
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
249         user_balance: uint256 = self.balanceOf[_user]
250         receiver: address = _receiver
251         if _claim and _receiver == ZERO_ADDRESS:
252             # if receiver is not explicitly declared, check if a default receiver is set
253             receiver = self.rewards_receiver[_user]
254             if receiver == ZERO_ADDRESS:
255                 # if no default receiver is set, direct claims to the user
256                 receiver = _user
257 
258         # calculate new user reward integral and transfer any owed rewards
259         for i in range(MAX_REWARDS):
260             token: address = reward_tokens[i]
261             if token == ZERO_ADDRESS:
262                 break
263 
264             integral: uint256 = reward_integrals[i]
265             integral_for: uint256 = self.reward_integral_for[token][_user]
266             new_claimable: uint256 = 0
267             if integral_for < integral:
268                 self.reward_integral_for[token][_user] = integral
269                 new_claimable = user_balance * (integral - integral_for) / 10**18
270 
271             claim_data: uint256 = self.claim_data[_user][token]
272             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
273             if total_claimable > 0:
274                 total_claimed: uint256 = claim_data % 2**128
275                 if _claim:
276                     response: Bytes[32] = raw_call(
277                         token,
278                         concat(
279                             method_id("transfer(address,uint256)"),
280                             convert(receiver, bytes32),
281                             convert(total_claimable, bytes32),
282                         ),
283                         max_outsize=32,
284                     )
285                     if len(response) != 0:
286                         assert convert(response, bool)
287                     self.claim_data[_user][token] = total_claimed + total_claimable
288                 elif new_claimable > 0:
289                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
290 
291 
292 @internal
293 def _checkpoint(addr: address):
294     """
295     @notice Checkpoint for a user
296     @param addr User address
297     """
298     _period: int128 = self.period
299     _period_time: uint256 = self.period_timestamp[_period]
300     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
301     rate: uint256 = self.inflation_rate
302     new_rate: uint256 = rate
303     prev_future_epoch: uint256 = self.future_epoch_time
304     if prev_future_epoch >= _period_time:
305         _token: address = self.crv_token
306         self.future_epoch_time = CRV20(_token).future_epoch_time_write()
307         new_rate = CRV20(_token).rate()
308         self.inflation_rate = new_rate
309 
310     if self.is_killed:
311         # Stop distributing inflation as soon as killed
312         rate = 0
313 
314     # Update integral of 1/supply
315     if block.timestamp > _period_time:
316         _working_supply: uint256 = self.working_supply
317         _controller: address = self.controller
318         Controller(_controller).checkpoint_gauge(self)
319         prev_week_time: uint256 = _period_time
320         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
321 
322         for i in range(500):
323             dt: uint256 = week_time - prev_week_time
324             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
325 
326             if _working_supply > 0:
327                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
328                     # If we went across one or multiple epochs, apply the rate
329                     # of the first epoch until it ends, and then the rate of
330                     # the last epoch.
331                     # If more than one epoch is crossed - the gauge gets less,
332                     # but that'd meen it wasn't called for more than 1 year
333                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
334                     rate = new_rate
335                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
336                 else:
337                     _integrate_inv_supply += rate * w * dt / _working_supply
338                 # On precisions of the calculation
339                 # rate ~= 10e18
340                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
341                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
342                 # The largest loss is at dt = 1
343                 # Loss is 1e-9 - acceptable
344 
345             if week_time == block.timestamp:
346                 break
347             prev_week_time = week_time
348             week_time = min(week_time + WEEK, block.timestamp)
349 
350     _period += 1
351     self.period = _period
352     self.period_timestamp[_period] = block.timestamp
353     self.integrate_inv_supply[_period] = _integrate_inv_supply
354 
355     # Update user-specific integrals
356     _working_balance: uint256 = self.working_balances[addr]
357     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
358     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
359     self.integrate_checkpoint_of[addr] = block.timestamp
360 
361 
362 @external
363 def user_checkpoint(addr: address) -> bool:
364     """
365     @notice Record a checkpoint for `addr`
366     @param addr User address
367     @return bool success
368     """
369     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
370     self._checkpoint(addr)
371     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
372     return True
373 
374 
375 @external
376 def claimable_tokens(addr: address) -> uint256:
377     """
378     @notice Get the number of claimable tokens per user
379     @dev This function should be manually changed to "view" in the ABI
380     @return uint256 number of claimable tokens per user
381     """
382     self._checkpoint(addr)
383     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
384 
385 
386 @view
387 @external
388 def reward_contract() -> address:
389     """
390     @notice Address of the reward contract providing non-CRV incentives for this gauge
391     @dev Returns `ZERO_ADDRESS` if there is no reward contract active
392     """
393     return convert(self.reward_data % 2**160, address)
394 
395 
396 @view
397 @external
398 def last_claim() -> uint256:
399     """
400     @notice Epoch timestamp of the last call to claim from `reward_contract`
401     @dev Rewards are claimed at most once per hour in order to reduce gas costs
402     """
403     return shift(self.reward_data, -160)
404 
405 
406 @view
407 @external
408 def claimed_reward(_addr: address, _token: address) -> uint256:
409     """
410     @notice Get the number of already-claimed reward tokens for a user
411     @param _addr Account to get reward amount for
412     @param _token Token to get reward amount for
413     @return uint256 Total amount of `_token` already claimed by `_addr`
414     """
415     return self.claim_data[_addr][_token] % 2**128
416 
417 
418 @view
419 @external
420 def claimable_reward(_addr: address, _token: address) -> uint256:
421     """
422     @notice Get the number of claimable reward tokens for a user
423     @dev This call does not consider pending claimable amount in `reward_contract`.
424          Off-chain callers should instead use `claimable_rewards_write` as a
425          view method.
426     @param _addr Account to get reward amount for
427     @param _token Token to get reward amount for
428     @return uint256 Claimable reward token amount
429     """
430     return shift(self.claim_data[_addr][_token], -128)
431 
432 
433 @external
434 @nonreentrant('lock')
435 def claimable_reward_write(_addr: address, _token: address) -> uint256:
436     """
437     @notice Get the number of claimable reward tokens for a user
438     @dev This function should be manually changed to "view" in the ABI
439          Calling it via a transaction will claim available reward tokens
440     @param _addr Account to get reward amount for
441     @param _token Token to get reward amount for
442     @return uint256 Claimable reward token amount
443     """
444     if self.reward_tokens[0] != ZERO_ADDRESS:
445         self._checkpoint_rewards(_addr, self.totalSupply, False, ZERO_ADDRESS)
446     return shift(self.claim_data[_addr][_token], -128)
447 
448 
449 @external
450 def set_rewards_receiver(_receiver: address):
451     """
452     @notice Set the default reward receiver for the caller.
453     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
454     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
455     """
456     self.rewards_receiver[msg.sender] = _receiver
457 
458 
459 @external
460 @nonreentrant('lock')
461 def claim_rewards(_addr: address = msg.sender, _receiver: address = ZERO_ADDRESS):
462     """
463     @notice Claim available reward tokens for `_addr`
464     @param _addr Address to claim for
465     @param _receiver Address to transfer rewards to - if set to
466                      ZERO_ADDRESS, uses the default reward receiver
467                      for the caller
468     """
469     if _receiver != ZERO_ADDRESS:
470         assert _addr == msg.sender  # dev: cannot redirect when claiming for another user
471     self._checkpoint_rewards(_addr, self.totalSupply, True, _receiver)
472 
473 
474 @external
475 def kick(addr: address):
476     """
477     @notice Kick `addr` for abusing their boost
478     @dev Only if either they had another voting event, or their voting escrow lock expired
479     @param addr Address to kick
480     """
481     _voting_escrow: address = self.voting_escrow
482     t_last: uint256 = self.integrate_checkpoint_of[addr]
483     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
484         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
485     )
486     _balance: uint256 = self.balanceOf[addr]
487 
488     assert ERC20(self.voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
489     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
490 
491     self._checkpoint(addr)
492     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
493 
494 
495 @external
496 @nonreentrant('lock')
497 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
498     """
499     @notice Deposit `_value` LP tokens
500     @dev Depositting also claims pending reward tokens
501     @param _value Number of tokens to deposit
502     @param _addr Address to deposit for
503     """
504 
505     self._checkpoint(_addr)
506 
507     if _value != 0:
508         is_rewards: bool = self.reward_tokens[0] != ZERO_ADDRESS
509         total_supply: uint256 = self.totalSupply
510         if is_rewards:
511             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
512 
513         total_supply += _value
514         new_balance: uint256 = self.balanceOf[_addr] + _value
515         self.balanceOf[_addr] = new_balance
516         self.totalSupply = total_supply
517 
518         self._update_liquidity_limit(_addr, new_balance, total_supply)
519 
520         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
521         if is_rewards:
522             reward_data: uint256 = self.reward_data
523             if reward_data > 0:
524                 deposit_sig: Bytes[4] = slice(self.reward_sigs, 0, 4)
525                 if convert(deposit_sig, uint256) != 0:
526                     raw_call(
527                         convert(reward_data % 2**160, address),
528                         concat(deposit_sig, convert(_value, bytes32))
529                     )
530 
531     log Deposit(_addr, _value)
532     log Transfer(ZERO_ADDRESS, _addr, _value)
533 
534 
535 @external
536 @nonreentrant('lock')
537 def withdraw(_value: uint256, _claim_rewards: bool = False):
538     """
539     @notice Withdraw `_value` LP tokens
540     @dev Withdrawing also claims pending reward tokens
541     @param _value Number of tokens to withdraw
542     """
543     self._checkpoint(msg.sender)
544 
545     if _value != 0:
546         is_rewards: bool = self.reward_tokens[0] != ZERO_ADDRESS
547         total_supply: uint256 = self.totalSupply
548         if is_rewards:
549             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
550 
551         total_supply -= _value
552         new_balance: uint256 = self.balanceOf[msg.sender] - _value
553         self.balanceOf[msg.sender] = new_balance
554         self.totalSupply = total_supply
555 
556         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
557 
558         if is_rewards:
559             reward_data: uint256 = self.reward_data
560             if reward_data > 0:
561                 withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
562                 if convert(withdraw_sig, uint256) != 0:
563                     raw_call(
564                         convert(reward_data % 2**160, address),
565                         concat(withdraw_sig, convert(_value, bytes32))
566                     )
567         ERC20(self.lp_token).transfer(msg.sender, _value)
568 
569     log Withdraw(msg.sender, _value)
570     log Transfer(msg.sender, ZERO_ADDRESS, _value)
571 
572 
573 @internal
574 def _transfer(_from: address, _to: address, _value: uint256):
575     self._checkpoint(_from)
576     self._checkpoint(_to)
577 
578     if _value != 0:
579         total_supply: uint256 = self.totalSupply
580         is_rewards: bool = self.reward_tokens[0] != ZERO_ADDRESS
581         if is_rewards:
582             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
583         new_balance: uint256 = self.balanceOf[_from] - _value
584         self.balanceOf[_from] = new_balance
585         self._update_liquidity_limit(_from, new_balance, total_supply)
586 
587         if is_rewards:
588             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
589         new_balance = self.balanceOf[_to] + _value
590         self.balanceOf[_to] = new_balance
591         self._update_liquidity_limit(_to, new_balance, total_supply)
592 
593     log Transfer(_from, _to, _value)
594 
595 
596 @external
597 @nonreentrant('lock')
598 def transfer(_to : address, _value : uint256) -> bool:
599     """
600     @notice Transfer token for a specified address
601     @dev Transferring claims pending reward tokens for the sender and receiver
602     @param _to The address to transfer to.
603     @param _value The amount to be transferred.
604     """
605     self._transfer(msg.sender, _to, _value)
606 
607     return True
608 
609 
610 @external
611 @nonreentrant('lock')
612 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
613     """
614      @notice Transfer tokens from one address to another.
615      @dev Transferring claims pending reward tokens for the sender and receiver
616      @param _from address The address which you want to send tokens from
617      @param _to address The address which you want to transfer to
618      @param _value uint256 the amount of tokens to be transferred
619     """
620     _allowance: uint256 = self.allowance[_from][msg.sender]
621     if _allowance != MAX_UINT256:
622         self.allowance[_from][msg.sender] = _allowance - _value
623 
624     self._transfer(_from, _to, _value)
625 
626     return True
627 
628 
629 @external
630 def approve(_spender : address, _value : uint256) -> bool:
631     """
632     @notice Approve the passed address to transfer the specified amount of
633             tokens on behalf of msg.sender
634     @dev Beware that changing an allowance via this method brings the risk
635          that someone may use both the old and new allowance by unfortunate
636          transaction ordering. This may be mitigated with the use of
637          {incraseAllowance} and {decreaseAllowance}.
638          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
639     @param _spender The address which will transfer the funds
640     @param _value The amount of tokens that may be transferred
641     @return bool success
642     """
643     self.allowance[msg.sender][_spender] = _value
644     log Approval(msg.sender, _spender, _value)
645 
646     return True
647 
648 
649 @external
650 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
651     """
652     @notice Increase the allowance granted to `_spender` by the caller
653     @dev This is alternative to {approve} that can be used as a mitigation for
654          the potential race condition
655     @param _spender The address which will transfer the funds
656     @param _added_value The amount of to increase the allowance
657     @return bool success
658     """
659     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
660     self.allowance[msg.sender][_spender] = allowance
661 
662     log Approval(msg.sender, _spender, allowance)
663 
664     return True
665 
666 
667 @external
668 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
669     """
670     @notice Decrease the allowance granted to `_spender` by the caller
671     @dev This is alternative to {approve} that can be used as a mitigation for
672          the potential race condition
673     @param _spender The address which will transfer the funds
674     @param _subtracted_value The amount of to decrease the allowance
675     @return bool success
676     """
677     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
678     self.allowance[msg.sender][_spender] = allowance
679 
680     log Approval(msg.sender, _spender, allowance)
681 
682     return True
683 
684 
685 @external
686 @nonreentrant('lock')
687 def set_rewards(_reward_contract: address, _sigs: bytes32, _reward_tokens: address[MAX_REWARDS]):
688     """
689     @notice Set the active reward contract
690     @dev A reward contract cannot be set while this contract has no deposits
691     @param _reward_contract Reward contract address. Set to ZERO_ADDRESS to
692                             disable staking.
693     @param _sigs Four byte selectors for staking, withdrawing and claiming,
694                  right padded with zero bytes. If the reward contract can
695                  be claimed from but does not require staking, the staking
696                  and withdraw selectors should be set to 0x00
697     @param _reward_tokens List of claimable reward tokens. New reward tokens
698                           may be added but they cannot be removed. When calling
699                           this function to unset or modify a reward contract,
700                           this array must begin with the already-set reward
701                           token addresses.
702     """
703     assert msg.sender == self.admin
704 
705     lp_token: address = self.lp_token
706     current_reward_contract: address = convert(self.reward_data % 2**160, address)
707     total_supply: uint256 = self.totalSupply
708     if self.reward_tokens[0] != ZERO_ADDRESS:
709         self._checkpoint_rewards(ZERO_ADDRESS, total_supply, False, ZERO_ADDRESS)
710     if current_reward_contract != ZERO_ADDRESS:
711         withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
712         if convert(withdraw_sig, uint256) != 0:
713             if total_supply != 0:
714                 raw_call(
715                     current_reward_contract,
716                     concat(withdraw_sig, convert(total_supply, bytes32))
717                 )
718             ERC20(lp_token).approve(current_reward_contract, 0)
719 
720     if _reward_contract != ZERO_ADDRESS:
721         assert _reward_tokens[0] != ZERO_ADDRESS  # dev: no reward token
722         assert _reward_contract.is_contract  # dev: not a contract
723         deposit_sig: Bytes[4] = slice(_sigs, 0, 4)
724         withdraw_sig: Bytes[4] = slice(_sigs, 4, 4)
725 
726         if convert(deposit_sig, uint256) != 0:
727             # need a non-zero total supply to verify the sigs
728             assert total_supply != 0  # dev: zero total supply
729             ERC20(lp_token).approve(_reward_contract, MAX_UINT256)
730 
731             # it would be Very Bad if we get the signatures wrong here, so
732             # we do a test deposit and withdrawal prior to setting them
733             raw_call(
734                 _reward_contract,
735                 concat(deposit_sig, convert(total_supply, bytes32))
736             )  # dev: failed deposit
737             assert ERC20(lp_token).balanceOf(self) == 0
738             raw_call(
739                 _reward_contract,
740                 concat(withdraw_sig, convert(total_supply, bytes32))
741             )  # dev: failed withdraw
742             assert ERC20(lp_token).balanceOf(self) == total_supply
743 
744             # deposit and withdraw are good, time to make the actual deposit
745             raw_call(
746                 _reward_contract,
747                 concat(deposit_sig, convert(total_supply, bytes32))
748             )
749         else:
750             assert convert(withdraw_sig, uint256) == 0  # dev: withdraw without deposit
751 
752     self.reward_data = convert(_reward_contract, uint256)
753     self.reward_sigs = _sigs
754     for i in range(MAX_REWARDS):
755         current_token: address = self.reward_tokens[i]
756         new_token: address = _reward_tokens[i]
757         if current_token != ZERO_ADDRESS:
758             assert current_token == new_token  # dev: cannot modify existing reward token
759         elif new_token != ZERO_ADDRESS:
760             # store new reward token
761             self.reward_tokens[i] = new_token
762         else:
763             break
764 
765     if _reward_contract != ZERO_ADDRESS:
766         # do an initial checkpoint to verify that claims are working
767         self._checkpoint_rewards(ZERO_ADDRESS, total_supply, False, ZERO_ADDRESS)
768 
769 
770 @external
771 def set_killed(_is_killed: bool):
772     """
773     @notice Set the killed status for this contract
774     @dev When killed, the gauge always yields a rate of 0 and so cannot mint CRV
775     @param _is_killed Killed status to set
776     """
777     assert msg.sender == self.admin
778 
779     self.is_killed = _is_killed
780 
781 
782 @external
783 def commit_transfer_ownership(addr: address):
784     """
785     @notice Transfer ownership of GaugeController to `addr`
786     @param addr Address to have ownership transferred to
787     """
788     assert msg.sender == self.admin  # dev: admin only
789 
790     self.future_admin = addr
791     log CommitOwnership(addr)
792 
793 
794 @external
795 def accept_transfer_ownership():
796     """
797     @notice Accept a pending ownership transfer
798     """
799     _admin: address = self.future_admin
800     assert msg.sender == _admin  # dev: future admin only
801 
802     self.admin = _admin
803     log ApplyOwnership(_admin)