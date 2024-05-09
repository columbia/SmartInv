1 # @version 0.3.1
2 """
3 @title Liquidity Gauge v3
4 @author Curve Finance
5 @license MIT
6 """
7 
8 # Original idea and credit:
9 # Curve Finance's Liquidity Gauge V3
10 # https://resources.curve.fi/base-features/understanding-gauges
11 # https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/gauges/LiquidityGaugeV3.vy
12 # This contract is an almost-identical fork of Curve's contract
13 # veCLEV is used instead of veCRV.
14 
15 from vyper.interfaces import ERC20
16 
17 implements: ERC20
18 
19 
20 interface CLEV20:
21     def future_epoch_time_write() -> uint256: nonpayable
22     def rate() -> uint256: view
23 
24 interface Controller:
25     def period() -> int128: view
26     def period_write() -> int128: nonpayable
27     def period_timestamp(p: int128) -> uint256: view
28     def gauge_relative_weight(addr: address, time: uint256) -> uint256: view
29     def voting_escrow() -> address: view
30     def checkpoint(): nonpayable
31     def checkpoint_gauge(addr: address): nonpayable
32 
33 interface Minter:
34     def token() -> address: view
35     def controller() -> address: view
36     def minted(user: address, gauge: address) -> uint256: view
37 
38 interface VotingEscrow:
39     def user_point_epoch(addr: address) -> uint256: view
40     def user_point_history__ts(addr: address, epoch: uint256) -> uint256: view
41 
42 interface ERC20Extended:
43     def symbol() -> String[26]: view
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
78 MAX_REWARDS: constant(uint256) = 8
79 TOKENLESS_PRODUCTION: constant(uint256) = 40
80 WEEK: constant(uint256) = 604800
81 CLAIM_FREQUENCY: constant(uint256) = 3600
82 
83 minter: public(address)
84 crv_token: public(address)
85 lp_token: public(address)
86 controller: public(address)
87 voting_escrow: public(address)
88 future_epoch_time: public(uint256)
89 
90 balanceOf: public(HashMap[address, uint256])
91 totalSupply: public(uint256)
92 allowance: public(HashMap[address, HashMap[address, uint256]])
93 
94 name: public(String[64])
95 symbol: public(String[32])
96 
97 working_balances: public(HashMap[address, uint256])
98 working_supply: public(uint256)
99 
100 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
101 # All values are kept in units of being multiplied by 1e18
102 period: public(int128)
103 period_timestamp: public(uint256[100000000000000000000000000000])
104 
105 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
106 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
107 
108 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
109 integrate_inv_supply_of: public(HashMap[address, uint256])
110 integrate_checkpoint_of: public(HashMap[address, uint256])
111 
112 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
113 # Units: rate * t = already number of coins per address to issue
114 integrate_fraction: public(HashMap[address, uint256])
115 
116 inflation_rate: public(uint256)
117 
118 # For tracking external rewards
119 reward_data: uint256
120 reward_tokens: public(address[MAX_REWARDS])
121 
122 # deposit / withdraw / claim
123 reward_sigs: bytes32
124 
125 # claimant -> default reward receiver
126 rewards_receiver: public(HashMap[address, address])
127 
128 # reward token -> integral
129 reward_integral: public(HashMap[address, uint256])
130 
131 # reward token -> claiming address -> integral
132 reward_integral_for: public(HashMap[address, HashMap[address, uint256]])
133 
134 # user -> [uint128 claimable amount][uint128 claimed amount]
135 claim_data: HashMap[address, HashMap[address, uint256]]
136 
137 admin: public(address)
138 future_admin: public(address)  # Can and will be a smart contract
139 is_killed: public(bool)
140 
141 
142 @external
143 def __init__(_lp_token: address, _minter: address, _admin: address):
144     """
145     @notice Contract constructor
146     @param _lp_token Liquidity Pool contract address
147     @param _minter Minter contract address
148     @param _admin Admin who can kill the gauge
149     """
150 
151     symbol: String[26] = ERC20Extended(_lp_token).symbol()
152     self.name = concat("Curve.fi ", symbol, " Gauge Deposit")
153     self.symbol = concat(symbol, "-gauge")
154 
155     crv_token: address = Minter(_minter).token()
156     controller: address = Minter(_minter).controller()
157 
158     self.lp_token = _lp_token
159     self.minter = _minter
160     self.admin = _admin
161     self.crv_token = crv_token
162     self.controller = controller
163     self.voting_escrow = Controller(controller).voting_escrow()
164 
165     self.period_timestamp[0] = block.timestamp
166     self.inflation_rate = CLEV20(crv_token).rate()
167     self.future_epoch_time = CLEV20(crv_token).future_epoch_time_write()
168 
169 
170 @view
171 @external
172 def decimals() -> uint256:
173     """
174     @notice Get the number of decimals for this token
175     @dev Implemented as a view method to reduce gas costs
176     @return uint256 decimal places
177     """
178     return 18
179 
180 
181 @view
182 @external
183 def integrate_checkpoint() -> uint256:
184     return self.period_timestamp[self.period]
185 
186 
187 @internal
188 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
189     """
190     @notice Calculate limits which depend on the amount of CLEV token per-user.
191             Effectively it calculates working balances to apply amplification
192             of CLEV production by CLEV
193     @param addr User address
194     @param l User's amount of liquidity (LP tokens)
195     @param L Total amount of liquidity (LP tokens)
196     """
197     # To be called after totalSupply is updated
198     _voting_escrow: address = self.voting_escrow
199     voting_balance: uint256 = ERC20(_voting_escrow).balanceOf(addr)
200     voting_total: uint256 = ERC20(_voting_escrow).totalSupply()
201 
202     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
203     if voting_total > 0:
204         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
205 
206     lim = min(l, lim)
207     old_bal: uint256 = self.working_balances[addr]
208     self.working_balances[addr] = lim
209     _working_supply: uint256 = self.working_supply + lim - old_bal
210     self.working_supply = _working_supply
211 
212     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
213 
214 
215 @internal
216 def _checkpoint_rewards( _user: address, _total_supply: uint256, _claim: bool, _receiver: address):
217     """
218     @notice Claim pending rewards and checkpoint rewards for a user
219     """
220     # load reward tokens and integrals into memory
221     reward_tokens: address[MAX_REWARDS] = empty(address[MAX_REWARDS])
222     reward_integrals: uint256[MAX_REWARDS] = empty(uint256[MAX_REWARDS])
223     for i in range(MAX_REWARDS):
224         token: address = self.reward_tokens[i]
225         if token == ZERO_ADDRESS:
226             break
227         reward_tokens[i] = token
228         reward_integrals[i] = self.reward_integral[token]
229 
230     reward_data: uint256 = self.reward_data
231     if _total_supply != 0 and reward_data != 0 and block.timestamp > shift(reward_data, -160) + CLAIM_FREQUENCY:
232         # track balances prior to claiming
233         reward_balances: uint256[MAX_REWARDS] = empty(uint256[MAX_REWARDS])
234         for i in range(MAX_REWARDS):
235             token: address = self.reward_tokens[i]
236             if token == ZERO_ADDRESS:
237                 break
238             reward_balances[i] = ERC20(token).balanceOf(self)
239 
240         # claim from reward contract
241         reward_contract: address = convert(reward_data % 2**160, address)
242         raw_call(reward_contract, slice(self.reward_sigs, 8, 4))  # dev: bad claim sig
243         self.reward_data = convert(reward_contract, uint256) + shift(block.timestamp, 160)
244 
245         # get balances after claim and calculate new reward integrals
246         for i in range(MAX_REWARDS):
247             token: address = reward_tokens[i]
248             if token == ZERO_ADDRESS:
249                 break
250             dI: uint256 = 10**18 * (ERC20(token).balanceOf(self) - reward_balances[i]) / _total_supply
251             if dI > 0:
252                 reward_integrals[i] += dI
253                 self.reward_integral[token] = reward_integrals[i]
254 
255     if _user != ZERO_ADDRESS:
256 
257         receiver: address = _receiver
258         if _claim and receiver == ZERO_ADDRESS:
259             # if receiver is not explicitly declared, check for default receiver
260             receiver = self.rewards_receiver[_user]
261             if receiver == ZERO_ADDRESS:
262                 # direct claims to user if no default receiver is set
263                 receiver = _user
264 
265         # calculate new user reward integral and transfer any owed rewards
266         user_balance: uint256 = self.balanceOf[_user]
267         for i in range(MAX_REWARDS):
268             token: address = reward_tokens[i]
269             if token == ZERO_ADDRESS:
270                 break
271 
272             integral: uint256 = reward_integrals[i]
273             integral_for: uint256 = self.reward_integral_for[token][_user]
274             new_claimable: uint256 = 0
275             if integral_for < integral:
276                 self.reward_integral_for[token][_user] = integral
277                 new_claimable = user_balance * (integral - integral_for) / 10**18
278 
279             claim_data: uint256 = self.claim_data[_user][token]
280             total_claimable: uint256 = shift(claim_data, -128) + new_claimable
281             if total_claimable > 0:
282                 total_claimed: uint256 = claim_data % 2 ** 128
283                 if _claim:
284                     response: Bytes[32] = raw_call(
285                         token,
286                         concat(
287                             method_id("transfer(address,uint256)"),
288                             convert(receiver, bytes32),
289                             convert(total_claimable, bytes32),
290                         ),
291                         max_outsize=32,
292                     )
293                     if len(response) != 0:
294                         assert convert(response, bool)
295                     # update amount claimed (lower order bytes)
296                     self.claim_data[_user][token] = total_claimed + total_claimable
297                 elif new_claimable > 0:
298                     # update total_claimable (higher order bytes)
299                     self.claim_data[_user][token] = total_claimed + shift(total_claimable, 128)
300 
301 
302 @internal
303 def _checkpoint(addr: address):
304     """
305     @notice Checkpoint for a user
306     @param addr User address
307     """
308     _period: int128 = self.period
309     _period_time: uint256 = self.period_timestamp[_period]
310     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
311     rate: uint256 = self.inflation_rate
312     new_rate: uint256 = rate
313     prev_future_epoch: uint256 = self.future_epoch_time
314     if prev_future_epoch >= _period_time:
315         _token: address = self.crv_token
316         self.future_epoch_time = CLEV20(_token).future_epoch_time_write()
317         new_rate = CLEV20(_token).rate()
318         self.inflation_rate = new_rate
319 
320     if self.is_killed:
321         # Stop distributing inflation as soon as killed
322         rate = 0
323 
324     # Update integral of 1/supply
325     if block.timestamp > _period_time:
326         _working_supply: uint256 = self.working_supply
327         _controller: address = self.controller
328         Controller(_controller).checkpoint_gauge(self)
329         prev_week_time: uint256 = _period_time
330         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
331 
332         for i in range(500):
333             dt: uint256 = week_time - prev_week_time
334             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
335 
336             if _working_supply > 0:
337                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
338                     # If we went across one or multiple epochs, apply the rate
339                     # of the first epoch until it ends, and then the rate of
340                     # the last epoch.
341                     # If more than one epoch is crossed - the gauge gets less,
342                     # but that'd meen it wasn't called for more than 1 year
343                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
344                     rate = new_rate
345                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
346                 else:
347                     _integrate_inv_supply += rate * w * dt / _working_supply
348                 # On precisions of the calculation
349                 # rate ~= 10e18
350                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
351                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
352                 # The largest loss is at dt = 1
353                 # Loss is 1e-9 - acceptable
354 
355             if week_time == block.timestamp:
356                 break
357             prev_week_time = week_time
358             week_time = min(week_time + WEEK, block.timestamp)
359 
360     _period += 1
361     self.period = _period
362     self.period_timestamp[_period] = block.timestamp
363     self.integrate_inv_supply[_period] = _integrate_inv_supply
364 
365     # Update user-specific integrals
366     _working_balance: uint256 = self.working_balances[addr]
367     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
368     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
369     self.integrate_checkpoint_of[addr] = block.timestamp
370 
371 
372 @external
373 def user_checkpoint(addr: address) -> bool:
374     """
375     @notice Record a checkpoint for `addr`
376     @param addr User address
377     @return bool success
378     """
379     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
380     self._checkpoint(addr)
381     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
382     return True
383 
384 
385 @external
386 def claimable_tokens(addr: address) -> uint256:
387     """
388     @notice Get the number of claimable tokens per user
389     @dev This function should be manually changed to "view" in the ABI
390     @return uint256 number of claimable tokens per user
391     """
392     self._checkpoint(addr)
393     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
394 
395 
396 @view
397 @external
398 def reward_contract() -> address:
399     """
400     @notice Address of the reward contract providing non-CLEV incentives for this gauge
401     @dev Returns `ZERO_ADDRESS` if there is no reward contract active
402     """
403     return convert(self.reward_data % 2**160, address)
404 
405 
406 @view
407 @external
408 def last_claim() -> uint256:
409     """
410     @notice Epoch timestamp of the last call to claim from `reward_contract`
411     @dev Rewards are claimed at most once per hour in order to reduce gas costs
412     """
413     return shift(self.reward_data, -160)
414 
415 
416 @view
417 @external
418 def claimed_reward(_addr: address, _token: address) -> uint256:
419     """
420     @notice Get the number of already-claimed reward tokens for a user
421     @param _addr Account to get reward amount for
422     @param _token Token to get reward amount for
423     @return uint256 Total amount of `_token` already claimed by `_addr`
424     """
425     return self.claim_data[_addr][_token] % 2**128
426 
427 
428 @view
429 @external
430 def claimable_reward(_addr: address, _token: address) -> uint256:
431     """
432     @notice Get the number of claimable reward tokens for a user
433     @dev This call does not consider pending claimable amount in `reward_contract`.
434          Off-chain callers should instead use `claimable_rewards_write` as a
435          view method.
436     @param _addr Account to get reward amount for
437     @param _token Token to get reward amount for
438     @return uint256 Claimable reward token amount
439     """
440     return shift(self.claim_data[_addr][_token], -128)
441 
442 
443 @external
444 @nonreentrant('lock')
445 def claimable_reward_write(_addr: address, _token: address) -> uint256:
446     """
447     @notice Get the number of claimable reward tokens for a user
448     @dev This function should be manually changed to "view" in the ABI
449          Calling it via a transaction will claim available reward tokens
450     @param _addr Account to get reward amount for
451     @param _token Token to get reward amount for
452     @return uint256 Claimable reward token amount
453     """
454     if self.reward_tokens[0] != ZERO_ADDRESS:
455         self._checkpoint_rewards(_addr, self.totalSupply, False, ZERO_ADDRESS)
456     return shift(self.claim_data[_addr][_token], -128)
457 
458 
459 @external
460 def set_rewards_receiver(_receiver: address):
461     """
462     @notice Set the default reward receiver for the caller.
463     @dev When set to ZERO_ADDRESS, rewards are sent to the caller
464     @param _receiver Receiver address for any rewards claimed via `claim_rewards`
465     """
466     self.rewards_receiver[msg.sender] = _receiver
467 
468 
469 @external
470 @nonreentrant('lock')
471 def claim_rewards(_addr: address = msg.sender, _receiver: address = ZERO_ADDRESS):
472     """
473     @notice Claim available reward tokens for `_addr`
474     @param _addr Address to claim for
475     @param _receiver Address to transfer rewards to - if set to
476                      ZERO_ADDRESS, uses the default reward receiver
477                      for the caller
478     """
479     if _receiver != ZERO_ADDRESS:
480         assert _addr == msg.sender  # dev: cannot redirect when claiming for another user
481     self._checkpoint_rewards(_addr, self.totalSupply, True, _receiver)
482 
483 
484 @external
485 def kick(addr: address):
486     """
487     @notice Kick `addr` for abusing their boost
488     @dev Only if either they had another voting event, or their voting escrow lock expired
489     @param addr Address to kick
490     """
491     _voting_escrow: address = self.voting_escrow
492     t_last: uint256 = self.integrate_checkpoint_of[addr]
493     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
494         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
495     )
496     _balance: uint256 = self.balanceOf[addr]
497 
498     assert ERC20(_voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
499     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
500 
501     self._checkpoint(addr)
502     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
503 
504 
505 @external
506 @nonreentrant('lock')
507 def deposit(_value: uint256, _addr: address = msg.sender, _claim_rewards: bool = False):
508     """
509     @notice Deposit `_value` LP tokens
510     @dev Depositting also claims pending reward tokens
511     @param _value Number of tokens to deposit
512     @param _addr Address to deposit for
513     """
514 
515     self._checkpoint(_addr)
516 
517     if _value != 0:
518         is_rewards: bool = self.reward_tokens[0] != ZERO_ADDRESS
519         total_supply: uint256 = self.totalSupply
520         if is_rewards:
521             self._checkpoint_rewards(_addr, total_supply, _claim_rewards, ZERO_ADDRESS)
522 
523         total_supply += _value
524         new_balance: uint256 = self.balanceOf[_addr] + _value
525         self.balanceOf[_addr] = new_balance
526         self.totalSupply = total_supply
527 
528         self._update_liquidity_limit(_addr, new_balance, total_supply)
529 
530         ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
531         if is_rewards:
532             reward_data: uint256 = self.reward_data
533             if reward_data > 0:
534                 deposit_sig: Bytes[4] = slice(self.reward_sigs, 0, 4)
535                 if convert(deposit_sig, uint256) != 0:
536                     raw_call(
537                         convert(reward_data % 2**160, address),
538                         concat(deposit_sig, convert(_value, bytes32))
539                     )
540 
541     log Deposit(_addr, _value)
542     log Transfer(ZERO_ADDRESS, _addr, _value)
543 
544 
545 @external
546 @nonreentrant('lock')
547 def withdraw(_value: uint256, _claim_rewards: bool = False):
548     """
549     @notice Withdraw `_value` LP tokens
550     @dev Withdrawing also claims pending reward tokens
551     @param _value Number of tokens to withdraw
552     """
553     self._checkpoint(msg.sender)
554 
555     if _value != 0:
556         is_rewards: bool = self.reward_tokens[0] != ZERO_ADDRESS
557         total_supply: uint256 = self.totalSupply
558         if is_rewards:
559             self._checkpoint_rewards(msg.sender, total_supply, _claim_rewards, ZERO_ADDRESS)
560 
561         total_supply -= _value
562         new_balance: uint256 = self.balanceOf[msg.sender] - _value
563         self.balanceOf[msg.sender] = new_balance
564         self.totalSupply = total_supply
565 
566         self._update_liquidity_limit(msg.sender, new_balance, total_supply)
567 
568         if is_rewards:
569             reward_data: uint256 = self.reward_data
570             if reward_data > 0:
571                 withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
572                 if convert(withdraw_sig, uint256) != 0:
573                     raw_call(
574                         convert(reward_data % 2**160, address),
575                         concat(withdraw_sig, convert(_value, bytes32))
576                     )
577         ERC20(self.lp_token).transfer(msg.sender, _value)
578 
579     log Withdraw(msg.sender, _value)
580     log Transfer(msg.sender, ZERO_ADDRESS, _value)
581 
582 
583 @internal
584 def _transfer(_from: address, _to: address, _value: uint256):
585     self._checkpoint(_from)
586     self._checkpoint(_to)
587 
588     if _value != 0:
589         total_supply: uint256 = self.totalSupply
590         is_rewards: bool = self.reward_tokens[0] != ZERO_ADDRESS
591         if is_rewards:
592             self._checkpoint_rewards(_from, total_supply, False, ZERO_ADDRESS)
593         new_balance: uint256 = self.balanceOf[_from] - _value
594         self.balanceOf[_from] = new_balance
595         self._update_liquidity_limit(_from, new_balance, total_supply)
596 
597         if is_rewards:
598             self._checkpoint_rewards(_to, total_supply, False, ZERO_ADDRESS)
599         new_balance = self.balanceOf[_to] + _value
600         self.balanceOf[_to] = new_balance
601         self._update_liquidity_limit(_to, new_balance, total_supply)
602 
603     log Transfer(_from, _to, _value)
604 
605 
606 @external
607 @nonreentrant('lock')
608 def transfer(_to : address, _value : uint256) -> bool:
609     """
610     @notice Transfer token for a specified address
611     @dev Transferring claims pending reward tokens for the sender and receiver
612     @param _to The address to transfer to.
613     @param _value The amount to be transferred.
614     """
615     self._transfer(msg.sender, _to, _value)
616 
617     return True
618 
619 
620 @external
621 @nonreentrant('lock')
622 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
623     """
624      @notice Transfer tokens from one address to another.
625      @dev Transferring claims pending reward tokens for the sender and receiver
626      @param _from address The address which you want to send tokens from
627      @param _to address The address which you want to transfer to
628      @param _value uint256 the amount of tokens to be transferred
629     """
630     _allowance: uint256 = self.allowance[_from][msg.sender]
631     if _allowance != MAX_UINT256:
632         self.allowance[_from][msg.sender] = _allowance - _value
633 
634     self._transfer(_from, _to, _value)
635 
636     return True
637 
638 
639 @external
640 def approve(_spender : address, _value : uint256) -> bool:
641     """
642     @notice Approve the passed address to transfer the specified amount of
643             tokens on behalf of msg.sender
644     @dev Beware that changing an allowance via this method brings the risk
645          that someone may use both the old and new allowance by unfortunate
646          transaction ordering. This may be mitigated with the use of
647          {incraseAllowance} and {decreaseAllowance}.
648          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
649     @param _spender The address which will transfer the funds
650     @param _value The amount of tokens that may be transferred
651     @return bool success
652     """
653     self.allowance[msg.sender][_spender] = _value
654     log Approval(msg.sender, _spender, _value)
655 
656     return True
657 
658 
659 @external
660 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
661     """
662     @notice Increase the allowance granted to `_spender` by the caller
663     @dev This is alternative to {approve} that can be used as a mitigation for
664          the potential race condition
665     @param _spender The address which will transfer the funds
666     @param _added_value The amount of to increase the allowance
667     @return bool success
668     """
669     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
670     self.allowance[msg.sender][_spender] = allowance
671 
672     log Approval(msg.sender, _spender, allowance)
673 
674     return True
675 
676 
677 @external
678 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
679     """
680     @notice Decrease the allowance granted to `_spender` by the caller
681     @dev This is alternative to {approve} that can be used as a mitigation for
682          the potential race condition
683     @param _spender The address which will transfer the funds
684     @param _subtracted_value The amount of to decrease the allowance
685     @return bool success
686     """
687     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
688     self.allowance[msg.sender][_spender] = allowance
689 
690     log Approval(msg.sender, _spender, allowance)
691 
692     return True
693 
694 
695 @external
696 @nonreentrant('lock')
697 def set_rewards(_reward_contract: address, _sigs: bytes32, _reward_tokens: address[MAX_REWARDS]):
698     """
699     @notice Set the active reward contract
700     @dev A reward contract cannot be set while this contract has no deposits
701     @param _reward_contract Reward contract address. Set to ZERO_ADDRESS to
702                             disable staking.
703     @param _sigs Four byte selectors for staking, withdrawing and claiming,
704                  right padded with zero bytes. If the reward contract can
705                  be claimed from but does not require staking, the staking
706                  and withdraw selectors should be set to 0x00
707     @param _reward_tokens List of claimable reward tokens. New reward tokens
708                           may be added but they cannot be removed. When calling
709                           this function to unset or modify a reward contract,
710                           this array must begin with the already-set reward
711                           token addresses.
712     """
713     assert msg.sender == self.admin
714 
715     lp_token: address = self.lp_token
716     current_reward_contract: address = convert(self.reward_data % 2**160, address)
717     total_supply: uint256 = self.totalSupply
718     if self.reward_tokens[0] != ZERO_ADDRESS:
719         self._checkpoint_rewards(ZERO_ADDRESS, total_supply, False, ZERO_ADDRESS)
720     if current_reward_contract != ZERO_ADDRESS:
721         withdraw_sig: Bytes[4] = slice(self.reward_sigs, 4, 4)
722         if convert(withdraw_sig, uint256) != 0:
723             if total_supply != 0:
724                 raw_call(
725                     current_reward_contract,
726                     concat(withdraw_sig, convert(total_supply, bytes32))
727                 )
728             ERC20(lp_token).approve(current_reward_contract, 0)
729 
730     if _reward_contract != ZERO_ADDRESS:
731         assert _reward_tokens[0] != ZERO_ADDRESS  # dev: no reward token
732         assert _reward_contract.is_contract  # dev: not a contract
733         deposit_sig: Bytes[4] = slice(_sigs, 0, 4)
734         withdraw_sig: Bytes[4] = slice(_sigs, 4, 4)
735 
736         if convert(deposit_sig, uint256) != 0:
737             # need a non-zero total supply to verify the sigs
738             assert total_supply != 0  # dev: zero total supply
739             ERC20(lp_token).approve(_reward_contract, MAX_UINT256)
740 
741             # it would be Very Bad if we get the signatures wrong here, so
742             # we do a test deposit and withdrawal prior to setting them
743             raw_call(
744                 _reward_contract,
745                 concat(deposit_sig, convert(total_supply, bytes32))
746             )  # dev: failed deposit
747             assert ERC20(lp_token).balanceOf(self) == 0
748             raw_call(
749                 _reward_contract,
750                 concat(withdraw_sig, convert(total_supply, bytes32))
751             )  # dev: failed withdraw
752             assert ERC20(lp_token).balanceOf(self) == total_supply
753 
754             # deposit and withdraw are good, time to make the actual deposit
755             raw_call(
756                 _reward_contract,
757                 concat(deposit_sig, convert(total_supply, bytes32))
758             )
759         else:
760             assert convert(withdraw_sig, uint256) == 0  # dev: withdraw without deposit
761 
762     self.reward_data = convert(_reward_contract, uint256)
763     self.reward_sigs = _sigs
764     for i in range(MAX_REWARDS):
765         current_token: address = self.reward_tokens[i]
766         new_token: address = _reward_tokens[i]
767         if current_token != ZERO_ADDRESS:
768             assert current_token == new_token  # dev: cannot modify existing reward token
769         elif new_token != ZERO_ADDRESS:
770             # store new reward token
771             self.reward_tokens[i] = new_token
772         else:
773             break
774 
775     if _reward_contract != ZERO_ADDRESS:
776         # do an initial checkpoint to verify that claims are working
777         self._checkpoint_rewards(ZERO_ADDRESS, total_supply, False, ZERO_ADDRESS)
778 
779 
780 @external
781 def set_killed(_is_killed: bool):
782     """
783     @notice Set the killed status for this contract
784     @dev When killed, the gauge always yields a rate of 0 and so cannot mint CLEV
785     @param _is_killed Killed status to set
786     """
787     assert msg.sender == self.admin
788 
789     self.is_killed = _is_killed
790 
791 
792 @external
793 def commit_transfer_ownership(addr: address):
794     """
795     @notice Transfer ownership of GaugeController to `addr`
796     @param addr Address to have ownership transferred to
797     """
798     assert msg.sender == self.admin  # dev: admin only
799 
800     self.future_admin = addr
801     log CommitOwnership(addr)
802 
803 
804 @external
805 def accept_transfer_ownership():
806     """
807     @notice Accept a pending ownership transfer
808     """
809     _admin: address = self.future_admin
810     assert msg.sender == _admin  # dev: future admin only
811 
812     self.admin = _admin
813     log ApplyOwnership(_admin)