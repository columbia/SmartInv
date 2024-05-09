1 # @version 0.3.1
2 """
3 @title Voting Escrow
4 @author Curve Finance
5 @license MIT
6 @notice Votes have a weight depending on time, so that users are
7         committed to the future of (whatever they are voting for)
8 @dev Vote weight decays linearly over time. Lock time cannot be
9      more than `MAXTIME` (4 years).
10 """
11 
12 # Voting escrow to have time-weighted votes
13 # Votes have a weight depending on time, so that users are committed
14 # to the future of (whatever they are voting for).
15 # The weight in this implementation is linear, and lock cannot be more than maxtime:
16 # w ^
17 # 1 +        /
18 #   |      /
19 #   |    /
20 #   |  /
21 #   |/
22 # 0 +--------+------> time
23 #       maxtime (2 years?)
24 
25 struct Point:
26     bias: int128
27     slope: int128  # - dweight / dt
28     ts: uint256
29     blk: uint256  # block
30 # We cannot really do block numbers per se b/c slope is per time, not per block
31 # and per block could be fairly bad b/c Ethereum changes blocktimes.
32 # What we can do is to extrapolate ***At functions
33 
34 struct LockedBalance:
35     amount: int128
36     end: uint256
37 
38 
39 interface ERC20:
40     def decimals() -> uint256: view
41     def name() -> String[64]: view
42     def symbol() -> String[32]: view
43     def transfer(to: address, amount: uint256) -> bool: nonpayable
44     def transferFrom(spender: address, to: address, amount: uint256) -> bool: nonpayable
45     def approve(spender: address, amount: uint256) -> bool: nonpayable
46 
47 
48 interface IVeSDLRewards:
49     def updateReward(_account: address) -> bool: nonpayable
50     def donate(_amount: uint256) -> bool: nonpayable
51 
52 # Interface for checking whether address belongs to a whitelisted
53 # type of a smart wallet.
54 # When new types are added - the whole contract is changed
55 # The check() method is modifying to be able to use caching
56 # for individual wallet addresses
57 interface SmartWalletChecker:
58     def check(addr: address) -> bool: nonpayable
59 
60 DEPOSIT_FOR_TYPE: constant(int128) = 0
61 CREATE_LOCK_TYPE: constant(int128) = 1
62 INCREASE_LOCK_AMOUNT: constant(int128) = 2
63 INCREASE_UNLOCK_TIME: constant(int128) = 3
64 
65 
66 event CommitOwnership:
67     admin: address
68 
69 event ApplyOwnership:
70     admin: address
71 
72 event FundsUnlocked:
73     funds_unlocked: bool
74 
75 event Deposit:
76     deposit_from: indexed(address)
77     provider: indexed(address)
78     value: uint256
79     locktime: indexed(uint256)
80     type: int128
81     ts: uint256
82 
83 event Withdraw:
84     provider: indexed(address)
85     value: uint256
86     ts: uint256
87 
88 event Supply:
89     prevSupply: uint256
90     supply: uint256
91 
92 
93 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
94 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
95 MULTIPLIER: constant(uint256) = 10 ** 18
96 
97 token: public(address)
98 supply: public(uint256)
99 
100 locked: public(HashMap[address, LockedBalance])
101 
102 epoch: public(uint256)
103 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
104 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
105 user_point_epoch: public(HashMap[address, uint256])
106 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
107 
108 name: public(String[64])
109 symbol: public(String[32])
110 decimals: public(uint256)
111 
112 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
113 # The goal is to prevent tokenizing the escrow
114 future_smart_wallet_checker: public(address)
115 smart_wallet_checker: public(address)
116 
117 admin: public(address)  # Can and will be a smart contract
118 future_admin: public(address)
119 
120 is_unlocked: public(bool)
121 
122 reward_pool: public(address)
123 
124 @external
125 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _admin: address):
126     """
127     @notice Contract constructor
128     @param token_addr `ERC20CRV` token address
129     @param _name Token name
130     @param _symbol Token symbol
131     @param _admin Admin for contract
132     """
133     self.admin = _admin
134     self.token = token_addr
135     self.point_history[0].blk = block.number
136     self.point_history[0].ts = block.timestamp
137 
138     _decimals: uint256 = ERC20(token_addr).decimals()
139     assert _decimals <= 255
140     self.decimals = _decimals
141 
142     self.name = _name
143     self.symbol = _symbol
144 
145 @external
146 def set_reward_pool(addr: address):
147   assert msg.sender == self.admin or self.reward_pool == ZERO_ADDRESS # dev: admin only
148   assert addr != ZERO_ADDRESS
149   self.reward_pool = addr
150 
151 @external
152 def commit_transfer_ownership(addr: address):
153     """
154     @notice Transfer ownership of VotingEscrow contract to `addr`
155     @param addr Address to have ownership transferred to
156     """
157     assert msg.sender == self.admin  # dev: admin only
158     self.future_admin = addr
159     log CommitOwnership(addr)
160 
161 
162 @external
163 def apply_transfer_ownership():
164     """
165     @notice Apply ownership transfer
166     """
167     assert msg.sender == self.admin  # dev: admin only
168     _admin: address = self.future_admin
169     assert _admin != ZERO_ADDRESS  # dev: admin not set
170     self.admin = _admin
171     log ApplyOwnership(_admin)
172 
173 
174 @external
175 def commit_smart_wallet_checker(addr: address):
176     """
177     @notice Set an external contract to check for approved smart contract wallets
178     @param addr Address of Smart contract checker
179     """
180     assert msg.sender == self.admin
181     self.future_smart_wallet_checker = addr
182 
183 
184 @external
185 def apply_smart_wallet_checker():
186     """
187     @notice Apply setting external contract to check approved smart contract wallets
188     """
189     assert msg.sender == self.admin
190     self.smart_wallet_checker = self.future_smart_wallet_checker
191 
192 @external
193 def set_funds_unlocked(_funds_unlocked: bool):
194   """
195   @notice Toggle fund lock
196   """
197   assert msg.sender == self.admin  # dev: admin only
198   self.is_unlocked = _funds_unlocked
199   log FundsUnlocked(_funds_unlocked)
200 
201 @internal
202 def assert_not_contract(addr: address):
203     """
204     @notice Check if the call is from a whitelisted smart contract, revert if not
205     @param addr Address to be checked
206     """
207     if addr != tx.origin:
208         checker: address = self.smart_wallet_checker
209         if checker != ZERO_ADDRESS:
210             if SmartWalletChecker(checker).check(addr):
211                 return
212         raise "Smart contract depositors not allowed"
213 
214 
215 @external
216 @view
217 def get_last_user_slope(addr: address) -> int128:
218     """
219     @notice Get the most recently recorded rate of voting power decrease for `addr`
220     @param addr Address of the user wallet
221     @return Value of the slope
222     """
223     uepoch: uint256 = self.user_point_epoch[addr]
224     return self.user_point_history[addr][uepoch].slope
225 
226 
227 @external
228 @view
229 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
230     """
231     @notice Get the timestamp for checkpoint `_idx` for `_addr`
232     @param _addr User wallet address
233     @param _idx User epoch number
234     @return Epoch time of the checkpoint
235     """
236     return self.user_point_history[_addr][_idx].ts
237 
238 
239 @external
240 @view
241 def locked__end(_addr: address) -> uint256:
242     """
243     @notice Get timestamp when `_addr`'s lock finishes
244     @param _addr User wallet
245     @return Epoch time of the lock end
246     """
247     return self.locked[_addr].end
248 
249 
250 @internal
251 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
252     """
253     @notice Record global and per-user data to checkpoint
254     @param addr User's wallet address. No user checkpoint if 0x0
255     @param old_locked Pevious locked amount / end lock time for the user
256     @param new_locked New locked amount / end lock time for the user
257     """
258     u_old: Point = empty(Point)
259     u_new: Point = empty(Point)
260     old_dslope: int128 = 0
261     new_dslope: int128 = 0
262     _epoch: uint256 = self.epoch
263 
264     if addr != ZERO_ADDRESS:
265         # Calculate slopes and biases
266         # Kept at zero when they have to
267         if old_locked.end > block.timestamp and old_locked.amount > 0:
268             u_old.slope = old_locked.amount / MAXTIME
269             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
270         if new_locked.end > block.timestamp and new_locked.amount > 0:
271             u_new.slope = new_locked.amount / MAXTIME
272             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
273 
274         # Read values of scheduled changes in the slope
275         # old_locked.end can be in the past and in the future
276         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
277         old_dslope = self.slope_changes[old_locked.end]
278         if new_locked.end != 0:
279             if new_locked.end == old_locked.end:
280                 new_dslope = old_dslope
281             else:
282                 new_dslope = self.slope_changes[new_locked.end]
283 
284     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
285     if _epoch > 0:
286         last_point = self.point_history[_epoch]
287     last_checkpoint: uint256 = last_point.ts
288     # initial_last_point is used for extrapolation to calculate block number
289     # (approximately, for *At methods) and save them
290     # as we cannot figure that out exactly from inside the contract
291     initial_last_point: Point = last_point
292     block_slope: uint256 = 0  # dblock/dt
293     if block.timestamp > last_point.ts:
294         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
295     # If last point is already recorded in this block, slope=0
296     # But that's ok b/c we know the block in such case
297 
298     # Go over weeks to fill history and calculate what the current point is
299     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
300     for i in range(255):
301         # Hopefully it won't happen that this won't get used in 3 years!
302         # If it does, users will be able to withdraw but vote weight will be broken
303         t_i += WEEK
304         d_slope: int128 = 0
305         if t_i > block.timestamp:
306             t_i = block.timestamp
307         else:
308             d_slope = self.slope_changes[t_i]
309         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
310         last_point.slope += d_slope
311         if last_point.bias < 0:  # This can happen
312             last_point.bias = 0
313         if last_point.slope < 0:  # This cannot happen - just in case
314             last_point.slope = 0
315         last_checkpoint = t_i
316         last_point.ts = t_i
317         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
318         _epoch += 1
319         if t_i == block.timestamp:
320             last_point.blk = block.number
321             break
322         else:
323             self.point_history[_epoch] = last_point
324 
325     self.epoch = _epoch
326     # Now point_history is filled until t=now
327 
328     if addr != ZERO_ADDRESS:
329         # If last point was in this block, the slope change has been applied already
330         # But in such case we have 0 slope(s)
331         last_point.slope += (u_new.slope - u_old.slope)
332         last_point.bias += (u_new.bias - u_old.bias)
333         if last_point.slope < 0:
334             last_point.slope = 0
335         if last_point.bias < 0:
336             last_point.bias = 0
337 
338     # Record the changed point into history
339     self.point_history[_epoch] = last_point
340 
341     if addr != ZERO_ADDRESS:
342         # Schedule the slope changes (slope is going down)
343         # We subtract new_user_slope from [new_locked.end]
344         # and add old_user_slope to [old_locked.end]
345         if old_locked.end > block.timestamp:
346             # old_dslope was <something> - u_old.slope, so we cancel that
347             old_dslope += u_old.slope
348             if new_locked.end == old_locked.end:
349                 old_dslope -= u_new.slope  # It was a new deposit, not extension
350             self.slope_changes[old_locked.end] = old_dslope
351 
352         if new_locked.end > block.timestamp:
353             if new_locked.end > old_locked.end:
354                 new_dslope -= u_new.slope  # old slope disappeared at this point
355                 self.slope_changes[new_locked.end] = new_dslope
356             # else: we recorded it already in old_dslope
357 
358         # Now handle user history
359         user_epoch: uint256 = self.user_point_epoch[addr] + 1
360 
361         self.user_point_epoch[addr] = user_epoch
362         u_new.ts = block.timestamp
363         u_new.blk = block.number
364         self.user_point_history[addr][user_epoch] = u_new
365 
366 
367 @internal
368 def _deposit_for(_from: address, _addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
369     """
370     @notice Deposit and lock tokens for a user
371     @param _from Address to take funds from
372     @param _addr User's wallet address
373     @param _value Amount to deposit
374     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
375     @param locked_balance Previous locked amount / timestamp
376     """
377     _locked: LockedBalance = locked_balance
378     supply_before: uint256 = self.supply
379     IVeSDLRewards(self.reward_pool).updateReward(_addr) # Reward pool snapshot
380 
381     self.supply = supply_before + _value
382     old_locked: LockedBalance = _locked
383     # Adding to existing lock, or if a lock is expired - creating a new one
384     _locked.amount += convert(_value, int128)
385     if unlock_time != 0:
386         _locked.end = unlock_time
387     self.locked[_addr] = _locked
388 
389     # Possibilities:
390     # Both old_locked.end could be current or expired (>/< block.timestamp)
391     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
392     # _locked.end > block.timestamp (always)
393     self._checkpoint(_addr, old_locked, _locked)
394 
395     if _value != 0:
396         assert ERC20(self.token).transferFrom(_from, self, _value)
397 
398     log Deposit(_from, _addr, _value, _locked.end, type, block.timestamp)
399     log Supply(supply_before, supply_before + _value)
400 
401 @external
402 def checkpoint():
403     """
404     @notice Record global data to checkpoint
405     """
406     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
407 
408 @external
409 @nonreentrant('lock')
410 def deposit_for(_addr: address, _value: uint256):
411     """
412     @notice Deposit `_value` tokens for `_addr` and add to the lock
413     @dev Anyone (even a smart contract) can deposit for someone else, but
414          cannot extend their locktime and deposit for a brand new user
415     @param _addr User's wallet address
416     @param _value Amount to add to user's lock
417     """
418     _locked: LockedBalance = self.locked[_addr]
419 
420     assert _value > 0  # dev: need non-zero value
421     assert _locked.amount > 0, "No existing lock found"
422     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
423 
424     self._deposit_for(msg.sender, _addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
425 
426 @external
427 @nonreentrant('lock')
428 def create_lock(_value: uint256, _unlock_time: uint256):
429     """
430     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
431     @param _value Amount to deposit
432     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
433     """
434     self.assert_not_contract(msg.sender)
435     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
436     _locked: LockedBalance = self.locked[msg.sender]
437 
438     assert _value > 0  # dev: need non-zero value
439     assert _locked.amount == 0, "Withdraw old tokens first"
440     assert unlock_time > block.timestamp, "Can only lock until time in the future"
441     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
442 
443     self._deposit_for(msg.sender, msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
444 
445 
446 @external
447 @nonreentrant('lock')
448 def increase_amount(_value: uint256):
449     """
450     @notice Deposit `_value` additional tokens for `msg.sender`
451             without modifying the unlock time
452     @param _value Amount of tokens to deposit and add to the lock
453     """
454     self.assert_not_contract(msg.sender)
455     _locked: LockedBalance = self.locked[msg.sender]
456 
457     assert _value > 0  # dev: need non-zero value
458     assert _locked.amount > 0, "No existing lock found"
459     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
460 
461     self._deposit_for(msg.sender, msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
462 
463 
464 @external
465 @nonreentrant('lock')
466 def increase_unlock_time(_unlock_time: uint256):
467     """
468     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
469     @param _unlock_time New epoch time for unlocking
470     """
471     self.assert_not_contract(msg.sender)
472     _locked: LockedBalance = self.locked[msg.sender]
473     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
474 
475     assert _locked.end > block.timestamp, "Lock expired"
476     assert _locked.amount > 0, "Nothing is locked"
477     assert unlock_time > _locked.end, "Can only increase lock duration"
478     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
479 
480     self._deposit_for(msg.sender, msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
481 
482 
483 @external
484 @nonreentrant('lock')
485 def withdraw():
486     """
487     @notice Withdraw all tokens for `msg.sender`
488     @dev Only possible if the lock has expired
489     """
490     _locked: LockedBalance = self.locked[msg.sender]
491     _unlocked: bool = self.is_unlocked
492     assert block.timestamp >= _locked.end or _unlocked, "The lock didn't expire and funds are not unlocked"
493     value: uint256 = convert(_locked.amount, uint256)
494 
495     old_locked: LockedBalance = _locked
496     _locked.end = 0
497     _locked.amount = 0
498     self.locked[msg.sender] = _locked
499     supply_before: uint256 = self.supply
500     self.supply = supply_before - value
501 
502     # old_locked can have either expired <= timestamp or zero end
503     # _locked has only 0 end
504     # Both can have >= 0 amount
505     self._checkpoint(msg.sender, old_locked, _locked)
506 
507     assert ERC20(self.token).transfer(msg.sender, value)
508 
509     if not _unlocked:
510       IVeSDLRewards(self.reward_pool).updateReward(msg.sender) # Reward pool snapshot
511 
512     log Withdraw(msg.sender, value, block.timestamp)
513     log Supply(supply_before, supply_before - value)
514 
515 @external
516 @nonreentrant('lock')
517 def force_withdraw():
518   """
519   @notice Withdraw all tokens for `msg.sender`
520   @dev Will pay a penalty based on time.
521   With a 4 years lock on withdraw, you pay 75% penalty during the first year.
522   penalty decrease linearly to zero starting when time left is under 3 years.
523   """
524   assert(self.is_unlocked == False)
525   _locked: LockedBalance = self.locked[msg.sender]
526   assert block.timestamp < _locked.end, "lock expired"
527 
528   time_left: uint256 = _locked.end - block.timestamp
529   penalty_ratio: uint256 = min(MULTIPLIER * 3 / 4,  MULTIPLIER * time_left / MAXTIME)
530   value: uint256 = convert(_locked.amount, uint256)
531   IVeSDLRewards(self.reward_pool).updateReward(msg.sender) # Reward pool snapshot
532   old_locked: LockedBalance = _locked
533   _locked.end = 0
534   _locked.amount = 0
535   self.locked[msg.sender] = _locked
536   supply_before: uint256 = self.supply
537   self.supply = supply_before - value
538   # old_locked can have either expired <= timestamp or zero end
539   # _locked has only 0 end
540   # Both can have >= 0 amount
541   self._checkpoint(msg.sender, old_locked, _locked)
542 
543   penalty: uint256 = value * penalty_ratio / MULTIPLIER
544   assert ERC20(self.token).transfer(msg.sender, value - penalty)
545   if penalty != 0:
546       assert ERC20(self.token).approve(self.reward_pool, penalty)
547       IVeSDLRewards(self.reward_pool).donate(penalty)
548   log Withdraw(msg.sender, value, block.timestamp)
549   log Supply(supply_before, supply_before - value)
550 
551 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
552 # They measure the weights for the purpose of voting, so they don't represent
553 # real coins.
554 
555 @internal
556 @view
557 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
558     """
559     @notice Binary search to estimate timestamp for block number
560     @param _block Block to find
561     @param max_epoch Don't go beyond this epoch
562     @return Approximate timestamp for block
563     """
564     # Binary search
565     _min: uint256 = 0
566     _max: uint256 = max_epoch
567     for i in range(128):  # Will be always enough for 128-bit numbers
568         if _min >= _max:
569             break
570         _mid: uint256 = (_min + _max + 1) / 2
571         if self.point_history[_mid].blk <= _block:
572             _min = _mid
573         else:
574             _max = _mid - 1
575     return _min
576 
577 
578 @external
579 @view
580 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
581     """
582     @notice Get the current voting power for `msg.sender`
583     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
584     @param addr User wallet address
585     @param _t Epoch time to return voting power at
586     @return User voting power
587     """
588     _epoch: uint256 = self.user_point_epoch[addr]
589     if _epoch == 0:
590         return 0
591     else:
592         last_point: Point = self.user_point_history[addr][_epoch]
593         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
594         if last_point.bias < 0:
595             last_point.bias = 0
596         return convert(last_point.bias, uint256)
597 
598 
599 @external
600 @view
601 def getPriorVotes(addr: address, _block: uint256) -> uint256:
602     """
603     @notice Measure voting power of `addr` at block height `_block`
604     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
605     @param addr User's wallet address
606     @param _block Block to calculate the voting power at
607     @return Voting power
608     """
609     # Copying and pasting totalSupply code because Vyper cannot pass by
610     # reference yet
611     assert _block <= block.number
612 
613     # Binary search
614     _min: uint256 = 0
615     _max: uint256 = self.user_point_epoch[addr]
616     for i in range(128):  # Will be always enough for 128-bit numbers
617         if _min >= _max:
618             break
619         _mid: uint256 = (_min + _max + 1) / 2
620         if self.user_point_history[addr][_mid].blk <= _block:
621             _min = _mid
622         else:
623             _max = _mid - 1
624 
625     upoint: Point = self.user_point_history[addr][_min]
626 
627     max_epoch: uint256 = self.epoch
628     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
629     point_0: Point = self.point_history[_epoch]
630     d_block: uint256 = 0
631     d_t: uint256 = 0
632     if _epoch < max_epoch:
633         point_1: Point = self.point_history[_epoch + 1]
634         d_block = point_1.blk - point_0.blk
635         d_t = point_1.ts - point_0.ts
636     else:
637         d_block = block.number - point_0.blk
638         d_t = block.timestamp - point_0.ts
639     block_time: uint256 = point_0.ts
640     if d_block != 0:
641         block_time += d_t * (_block - point_0.blk) / d_block
642 
643     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
644     if upoint.bias >= 0:
645         return convert(upoint.bias, uint256)
646     else:
647         return 0
648 
649 
650 @internal
651 @view
652 def supply_at(point: Point, t: uint256) -> uint256:
653     """
654     @notice Calculate total voting power at some point in the past
655     @param point The point (bias/slope) to start search from
656     @param t Time to calculate the total voting power at
657     @return Total voting power at that time
658     """
659     last_point: Point = point
660     t_i: uint256 = (last_point.ts / WEEK) * WEEK
661     for i in range(255):
662         t_i += WEEK
663         d_slope: int128 = 0
664         if t_i > t:
665             t_i = t
666         else:
667             d_slope = self.slope_changes[t_i]
668         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
669         if t_i == t:
670             break
671         last_point.slope += d_slope
672         last_point.ts = t_i
673 
674     if last_point.bias < 0:
675         last_point.bias = 0
676     return convert(last_point.bias, uint256)
677 
678 
679 @external
680 @view
681 def totalSupply(t: uint256 = block.timestamp) -> uint256:
682     """
683     @notice Calculate total voting power
684     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
685     @return Total voting power
686     """
687     _epoch: uint256 = self.epoch
688     last_point: Point = self.point_history[_epoch]
689     return self.supply_at(last_point, t)
690 
691 
692 @external
693 @view
694 def totalSupplyAt(_block: uint256) -> uint256:
695     """
696     @notice Calculate total voting power at some point in the past
697     @param _block Block to calculate the total voting power at
698     @return Total voting power at `_block`
699     """
700     assert _block <= block.number
701     _epoch: uint256 = self.epoch
702     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
703 
704     point: Point = self.point_history[target_epoch]
705     dt: uint256 = 0
706     if target_epoch < _epoch:
707         point_next: Point = self.point_history[target_epoch + 1]
708         if point.blk != point_next.blk:
709             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
710     else:
711         if point.blk != block.number:
712             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
713     # Now dt contains info on how far are we beyond point
714 
715     return self.supply_at(point, point.ts + dt)