1 # @version 0.2.15
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
23 #       maxtime (4 years?)
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
45 
46 
47 # Interface for checking whether address belongs to a whitelisted
48 # type of a smart wallet.
49 # When new types are added - the whole contract is changed
50 # The check() method is modifying to be able to use caching
51 # for individual wallet addresses
52 interface SmartWalletChecker:
53     def check(addr: address) -> bool: nonpayable
54 
55 DEPOSIT_FOR_TYPE: constant(int128) = 0
56 CREATE_LOCK_TYPE: constant(int128) = 1
57 INCREASE_LOCK_AMOUNT: constant(int128) = 2
58 INCREASE_UNLOCK_TIME: constant(int128) = 3
59 
60 
61 event CommitOwnership:
62     admin: address
63 
64 event ApplyOwnership:
65     admin: address
66 
67 event Deposit:
68     provider: indexed(address)
69     value: uint256
70     locktime: indexed(uint256)
71     type: int128
72     ts: uint256
73 
74 event Withdraw:
75     provider: indexed(address)
76     value: uint256
77     ts: uint256
78 
79 event Supply:
80     prevSupply: uint256
81     supply: uint256
82 
83 event NewDelegation:
84     delegator: indexed(address)
85     gauge: indexed(address)
86     receiver: indexed(address)
87     pct: uint256
88     cancel_time: uint256
89     expire_time: uint256
90 
91 event CancelledDelegation:
92     delegator: indexed(address)
93     gauge: indexed(address)
94     receiver: indexed(address)
95     cancelled_by: address
96 
97 struct ReceivedBoost:
98     length: uint256
99     data: uint256[10]
100 
101 
102 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
103 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
104 MULTIPLIER: constant(uint256) = 10 ** 18
105 
106 token: public(address)
107 supply: public(uint256)
108 
109 locked: public(HashMap[address, LockedBalance])
110 
111 epoch: public(uint256)
112 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
113 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
114 user_point_epoch: public(HashMap[address, uint256])
115 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
116 
117 # Aragon's view methods for compatibility
118 controller: public(address)
119 transfersEnabled: public(bool)
120 
121 name: public(String[64])
122 symbol: public(String[32])
123 version: public(String[32])
124 decimals: public(uint256)
125 
126 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
127 # The goal is to prevent tokenizing the escrow
128 future_smart_wallet_checker: public(address)
129 smart_wallet_checker: public(address)
130 
131 admin: public(address)  # Can and will be a smart contract
132 future_admin: public(address)
133 
134 # user -> number of active boost delegations
135 delegation_count: public(HashMap[address, uint256])
136 
137 # user -> gauge -> data on boosts delegated to user
138 # tightly packed as [address][uint16 pct][uint40 cancel time][uint40 expire time]
139 delegation_data: HashMap[address, HashMap[address, ReceivedBoost]]
140 
141 # user -> gauge -> data about delegation user has made for this gauge
142 delegated_to: HashMap[address, HashMap[address, uint256]]
143 
144 operator_of: public(HashMap[address, address])
145 
146 MIN_VE: constant(uint256) = 2500 * 10**18
147 
148 
149 @external
150 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
151     """
152     @notice Contract constructor
153     @param token_addr `ERC20CRV` token address
154     @param _name Token name
155     @param _symbol Token symbol
156     @param _version Contract version - required for Aragon compatibility
157     """
158     self.admin = msg.sender
159     self.token = token_addr
160     self.point_history[0].blk = block.number
161     self.point_history[0].ts = block.timestamp
162     self.controller = msg.sender
163     self.transfersEnabled = True
164 
165     _decimals: uint256 = ERC20(token_addr).decimals()
166     assert _decimals <= 255
167     self.decimals = _decimals
168 
169     self.name = _name
170     self.symbol = _symbol
171     self.version = _version
172 
173 
174 @external
175 def commit_transfer_ownership(addr: address):
176     """
177     @notice Transfer ownership of VotingEscrow contract to `addr`
178     @param addr Address to have ownership transferred to
179     """
180     assert msg.sender == self.admin  # dev: admin only
181     self.future_admin = addr
182     log CommitOwnership(addr)
183 
184 
185 @external
186 def apply_transfer_ownership():
187     """
188     @notice Apply ownership transfer
189     """
190     assert msg.sender == self.admin  # dev: admin only
191     _admin: address = self.future_admin
192     assert _admin != ZERO_ADDRESS  # dev: admin not set
193     self.admin = _admin
194     log ApplyOwnership(_admin)
195 
196 
197 @external
198 def commit_smart_wallet_checker(addr: address):
199     """
200     @notice Set an external contract to check for approved smart contract wallets
201     @param addr Address of Smart contract checker
202     """
203     assert msg.sender == self.admin
204     self.future_smart_wallet_checker = addr
205 
206 
207 @external
208 def apply_smart_wallet_checker():
209     """
210     @notice Apply setting external contract to check approved smart contract wallets
211     """
212     assert msg.sender == self.admin
213     self.smart_wallet_checker = self.future_smart_wallet_checker
214 
215 
216 @internal
217 def assert_not_contract(addr: address):
218     """
219     @notice Check if the call is from a whitelisted smart contract, revert if not
220     @param addr Address to be checked
221     """
222     if addr != tx.origin:
223         checker: address = self.smart_wallet_checker
224         if checker != ZERO_ADDRESS:
225             if SmartWalletChecker(checker).check(addr):
226                 return
227         raise "Smart contract depositors not allowed"
228 
229 
230 @external
231 @view
232 def get_last_user_slope(addr: address) -> int128:
233     """
234     @notice Get the most recently recorded rate of voting power decrease for `addr`
235     @param addr Address of the user wallet
236     @return Value of the slope
237     """
238     uepoch: uint256 = self.user_point_epoch[addr]
239     return self.user_point_history[addr][uepoch].slope
240 
241 
242 @external
243 @view
244 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
245     """
246     @notice Get the timestamp for checkpoint `_idx` for `_addr`
247     @param _addr User wallet address
248     @param _idx User epoch number
249     @return Epoch time of the checkpoint
250     """
251     return self.user_point_history[_addr][_idx].ts
252 
253 
254 @external
255 @view
256 def locked__end(_addr: address) -> uint256:
257     """
258     @notice Get timestamp when `_addr`'s lock finishes
259     @param _addr User wallet
260     @return Epoch time of the lock end
261     """
262     return self.locked[_addr].end
263 
264 
265 @internal
266 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
267     """
268     @notice Record global and per-user data to checkpoint
269     @param addr User's wallet address. No user checkpoint if 0x0
270     @param old_locked Pevious locked amount / end lock time for the user
271     @param new_locked New locked amount / end lock time for the user
272     """
273     u_old: Point = empty(Point)
274     u_new: Point = empty(Point)
275     old_dslope: int128 = 0
276     new_dslope: int128 = 0
277     _epoch: uint256 = self.epoch
278 
279     if addr != ZERO_ADDRESS:
280         # Calculate slopes and biases
281         # Kept at zero when they have to
282         if old_locked.end > block.timestamp and old_locked.amount > 0:
283             u_old.slope = old_locked.amount / MAXTIME
284             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
285         if new_locked.end > block.timestamp and new_locked.amount > 0:
286             u_new.slope = new_locked.amount / MAXTIME
287             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
288 
289         # Read values of scheduled changes in the slope
290         # old_locked.end can be in the past and in the future
291         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
292         old_dslope = self.slope_changes[old_locked.end]
293         if new_locked.end != 0:
294             if new_locked.end == old_locked.end:
295                 new_dslope = old_dslope
296             else:
297                 new_dslope = self.slope_changes[new_locked.end]
298 
299     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
300     if _epoch > 0:
301         last_point = self.point_history[_epoch]
302     last_checkpoint: uint256 = last_point.ts
303     # initial_last_point is used for extrapolation to calculate block number
304     # (approximately, for *At methods) and save them
305     # as we cannot figure that out exactly from inside the contract
306     initial_last_point: Point = last_point
307     block_slope: uint256 = 0  # dblock/dt
308     if block.timestamp > last_point.ts:
309         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
310     # If last point is already recorded in this block, slope=0
311     # But that's ok b/c we know the block in such case
312 
313     # Go over weeks to fill history and calculate what the current point is
314     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
315     for i in range(255):
316         # Hopefully it won't happen that this won't get used in 5 years!
317         # If it does, users will be able to withdraw but vote weight will be broken
318         t_i += WEEK
319         d_slope: int128 = 0
320         if t_i > block.timestamp:
321             t_i = block.timestamp
322         else:
323             d_slope = self.slope_changes[t_i]
324         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
325         last_point.slope += d_slope
326         if last_point.bias < 0:  # This can happen
327             last_point.bias = 0
328         if last_point.slope < 0:  # This cannot happen - just in case
329             last_point.slope = 0
330         last_checkpoint = t_i
331         last_point.ts = t_i
332         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
333         _epoch += 1
334         if t_i == block.timestamp:
335             last_point.blk = block.number
336             break
337         else:
338             self.point_history[_epoch] = last_point
339 
340     self.epoch = _epoch
341     # Now point_history is filled until t=now
342 
343     if addr != ZERO_ADDRESS:
344         # If last point was in this block, the slope change has been applied already
345         # But in such case we have 0 slope(s)
346         last_point.slope += (u_new.slope - u_old.slope)
347         last_point.bias += (u_new.bias - u_old.bias)
348         if last_point.slope < 0:
349             last_point.slope = 0
350         if last_point.bias < 0:
351             last_point.bias = 0
352 
353     # Record the changed point into history
354     self.point_history[_epoch] = last_point
355 
356     if addr != ZERO_ADDRESS:
357         # Schedule the slope changes (slope is going down)
358         # We subtract new_user_slope from [new_locked.end]
359         # and add old_user_slope to [old_locked.end]
360         if old_locked.end > block.timestamp:
361             # old_dslope was <something> - u_old.slope, so we cancel that
362             old_dslope += u_old.slope
363             if new_locked.end == old_locked.end:
364                 old_dslope -= u_new.slope  # It was a new deposit, not extension
365             self.slope_changes[old_locked.end] = old_dslope
366 
367         if new_locked.end > block.timestamp:
368             if new_locked.end > old_locked.end:
369                 new_dslope -= u_new.slope  # old slope disappeared at this point
370                 self.slope_changes[new_locked.end] = new_dslope
371             # else: we recorded it already in old_dslope
372 
373         # Now handle user history
374         user_epoch: uint256 = self.user_point_epoch[addr] + 1
375 
376         self.user_point_epoch[addr] = user_epoch
377         u_new.ts = block.timestamp
378         u_new.blk = block.number
379         self.user_point_history[addr][user_epoch] = u_new
380 
381 
382 @internal
383 def _deposit_for(_from: address, _addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
384     """
385     @notice Deposit and lock tokens for a user
386     @param _addr User's wallet address
387     @param _value Amount to deposit
388     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
389     @param locked_balance Previous locked amount / timestamp
390     """
391     _locked: LockedBalance = locked_balance
392     supply_before: uint256 = self.supply
393 
394     self.supply = supply_before + _value
395     old_locked: LockedBalance = _locked
396     # Adding to existing lock, or if a lock is expired - creating a new one
397     _locked.amount += convert(_value, int128)
398     if unlock_time != 0:
399         _locked.end = unlock_time
400     self.locked[_addr] = _locked
401 
402     # Possibilities:
403     # Both old_locked.end could be current or expired (>/< block.timestamp)
404     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
405     # _locked.end > block.timestamp (always)
406     self._checkpoint(_addr, old_locked, _locked)
407 
408     if _value != 0:
409         assert ERC20(self.token).transferFrom(_from, self, _value)
410 
411     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
412     log Supply(supply_before, supply_before + _value)
413 
414 
415 @external
416 def checkpoint():
417     """
418     @notice Record global data to checkpoint
419     """
420     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
421 
422 
423 @external
424 @nonreentrant('lock')
425 def deposit_for(_addr: address, _value: uint256):
426     """
427     @notice Deposit `_value` tokens for `_addr` and add to the lock
428     @dev Anyone (even a smart contract) can deposit for someone else, but
429          cannot extend their locktime and deposit for a brand new user
430     @param _addr User's wallet address
431     @param _value Amount to add to user's lock
432     """
433     _locked: LockedBalance = self.locked[_addr]
434 
435     assert _value > 0  # dev: need non-zero value
436     assert _locked.amount > 0, "No existing lock found"
437     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
438 
439     self._deposit_for(msg.sender, _addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
440 
441 
442 @external
443 @nonreentrant('lock')
444 def create_lock(_value: uint256, _unlock_time: uint256):
445     """
446     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
447     @param _value Amount to deposit
448     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
449     """
450     self.assert_not_contract(msg.sender)
451     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
452     _locked: LockedBalance = self.locked[msg.sender]
453 
454     assert _value > 0  # dev: need non-zero value
455     assert _locked.amount == 0, "Withdraw old tokens first"
456     assert unlock_time > block.timestamp, "Can only lock until time in the future"
457     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
458 
459     self._deposit_for(msg.sender, msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
460 
461 
462 @external
463 @nonreentrant('lock')
464 def increase_amount(_value: uint256):
465     """
466     @notice Deposit `_value` additional tokens for `msg.sender`
467             without modifying the unlock time
468     @param _value Amount of tokens to deposit and add to the lock
469     """
470     self.assert_not_contract(msg.sender)
471     _locked: LockedBalance = self.locked[msg.sender]
472 
473     assert _value > 0  # dev: need non-zero value
474     assert _locked.amount > 0, "No existing lock found"
475     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
476 
477     self._deposit_for(msg.sender, msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
478 
479 
480 @external
481 @nonreentrant('lock')
482 def increase_unlock_time(_unlock_time: uint256):
483     """
484     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
485     @param _unlock_time New epoch time for unlocking
486     """
487     self.assert_not_contract(msg.sender)
488     _locked: LockedBalance = self.locked[msg.sender]
489     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
490 
491     assert _locked.end > block.timestamp, "Lock expired"
492     assert _locked.amount > 0, "Nothing is locked"
493     assert unlock_time > _locked.end, "Can only increase lock duration"
494     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
495 
496     self._deposit_for(msg.sender, msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
497 
498 
499 @external
500 @nonreentrant('lock')
501 def withdraw():
502     """
503     @notice Withdraw all tokens for `msg.sender`
504     @dev Only possible if the lock has expired
505     """
506     _locked: LockedBalance = self.locked[msg.sender]
507     assert block.timestamp >= _locked.end, "The lock didn't expire"
508     value: uint256 = convert(_locked.amount, uint256)
509 
510     old_locked: LockedBalance = _locked
511     _locked.end = 0
512     _locked.amount = 0
513     self.locked[msg.sender] = _locked
514     supply_before: uint256 = self.supply
515     self.supply = supply_before - value
516 
517     # old_locked can have either expired <= timestamp or zero end
518     # _locked has only 0 end
519     # Both can have >= 0 amount
520     self._checkpoint(msg.sender, old_locked, _locked)
521 
522     assert ERC20(self.token).transfer(msg.sender, value)
523 
524     log Withdraw(msg.sender, value, block.timestamp)
525     log Supply(supply_before, supply_before - value)
526 
527 
528 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
529 # They measure the weights for the purpose of voting, so they don't represent
530 # real coins.
531 
532 @internal
533 @view
534 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
535     """
536     @notice Binary search to estimate timestamp for block number
537     @param _block Block to find
538     @param max_epoch Don't go beyond this epoch
539     @return Approximate timestamp for block
540     """
541     # Binary search
542     _min: uint256 = 0
543     _max: uint256 = max_epoch
544     for i in range(128):  # Will be always enough for 128-bit numbers
545         if _min >= _max:
546             break
547         _mid: uint256 = (_min + _max + 1) / 2
548         if self.point_history[_mid].blk <= _block:
549             _min = _mid
550         else:
551             _max = _mid - 1
552     return _min
553 
554 @internal
555 @view
556 def _balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
557     """
558     @notice Get the current voting power for `msg.sender`
559     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
560     @param addr User wallet address
561     @param _t Epoch time to return voting power at
562     @return User voting power
563     """
564     _epoch: uint256 = self.user_point_epoch[addr]
565     if _epoch == 0:
566         return 0
567     else:
568         last_point: Point = self.user_point_history[addr][_epoch]
569         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
570         if last_point.bias < 0:
571             last_point.bias = 0
572         return convert(last_point.bias, uint256)
573 
574 @external
575 @view
576 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
577     """
578     @notice Get the current voting power for `msg.sender`
579     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
580     @param addr User wallet address
581     @param _t Epoch time to return voting power at
582     @return User voting power
583     """
584     return self._balanceOf(addr, _t)
585 
586 @external
587 @view
588 def balanceOfAt(addr: address, _block: uint256) -> uint256:
589     """
590     @notice Measure voting power of `addr` at block height `_block`
591     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
592     @param addr User's wallet address
593     @param _block Block to calculate the voting power at
594     @return Voting power
595     """
596     # Copying and pasting totalSupply code because Vyper cannot pass by
597     # reference yet
598     assert _block <= block.number
599 
600     # Binary search
601     _min: uint256 = 0
602     _max: uint256 = self.user_point_epoch[addr]
603     for i in range(128):  # Will be always enough for 128-bit numbers
604         if _min >= _max:
605             break
606         _mid: uint256 = (_min + _max + 1) / 2
607         if self.user_point_history[addr][_mid].blk <= _block:
608             _min = _mid
609         else:
610             _max = _mid - 1
611 
612     upoint: Point = self.user_point_history[addr][_min]
613 
614     max_epoch: uint256 = self.epoch
615     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
616     point_0: Point = self.point_history[_epoch]
617     d_block: uint256 = 0
618     d_t: uint256 = 0
619     if _epoch < max_epoch:
620         point_1: Point = self.point_history[_epoch + 1]
621         d_block = point_1.blk - point_0.blk
622         d_t = point_1.ts - point_0.ts
623     else:
624         d_block = block.number - point_0.blk
625         d_t = block.timestamp - point_0.ts
626     block_time: uint256 = point_0.ts
627     if d_block != 0:
628         block_time += d_t * (_block - point_0.blk) / d_block
629 
630     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
631     if upoint.bias >= 0:
632         return convert(upoint.bias, uint256)
633     else:
634         return 0
635 
636 
637 @internal
638 @view
639 def supply_at(point: Point, t: uint256) -> uint256:
640     """
641     @notice Calculate total voting power at some point in the past
642     @param point The point (bias/slope) to start search from
643     @param t Time to calculate the total voting power at
644     @return Total voting power at that time
645     """
646     last_point: Point = point
647     t_i: uint256 = (last_point.ts / WEEK) * WEEK
648     for i in range(255):
649         t_i += WEEK
650         d_slope: int128 = 0
651         if t_i > t:
652             t_i = t
653         else:
654             d_slope = self.slope_changes[t_i]
655         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
656         if t_i == t:
657             break
658         last_point.slope += d_slope
659         last_point.ts = t_i
660 
661     if last_point.bias < 0:
662         last_point.bias = 0
663     return convert(last_point.bias, uint256)
664 
665 
666 @external
667 @view
668 def totalSupply(t: uint256 = block.timestamp) -> uint256:
669     """
670     @notice Calculate total voting power
671     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
672     @return Total voting power
673     """
674     _epoch: uint256 = self.epoch
675     last_point: Point = self.point_history[_epoch]
676     return self.supply_at(last_point, t)
677 
678 
679 @external
680 @view
681 def totalSupplyAt(_block: uint256) -> uint256:
682     """
683     @notice Calculate total voting power at some point in the past
684     @param _block Block to calculate the total voting power at
685     @return Total voting power at `_block`
686     """
687     assert _block <= block.number
688     _epoch: uint256 = self.epoch
689     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
690 
691     point: Point = self.point_history[target_epoch]
692     dt: uint256 = 0
693     if target_epoch < _epoch:
694         point_next: Point = self.point_history[target_epoch + 1]
695         if point.blk != point_next.blk:
696             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
697     else:
698         if point.blk != block.number:
699             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
700     # Now dt contains info on how far are we beyond point
701 
702     return self.supply_at(point, point.ts + dt)
703 
704 
705 # Dummy methods for compatibility with Aragon
706 
707 @external
708 def changeController(_newController: address):
709     """
710     @dev Dummy method required for Aragon compatibility
711     """
712     assert msg.sender == self.controller
713     self.controller = _newController
714 
715 @view
716 @external
717 def get_delegated_to(_delegator: address, _gauge: address) -> (address, uint256, uint256, uint256):
718     """
719     @notice Get data about an accounts's boost delegation
720     @param _delegator Address to query delegation data for
721     @param _gauge Gauge address to query. Use ZERO_ADDRESS for global delegation.
722     @return address receiving the delegated boost
723             delegated boost pct (out of 10000)
724             cancellable timestamp
725             expiry timestamp
726     """
727     data: uint256 = self.delegated_to[_delegator][_gauge]
728     return (
729         convert(shift(data, 96), address),
730         shift(data, 80) % 2**16,
731         shift(data, 40) % 2**40,
732         data % 2**40
733     )
734 
735 
736 @view
737 @external
738 def get_delegation_data(
739     _receiver: address,
740     _gauge: address,
741     _idx: uint256
742 ) -> (address, uint256, uint256, uint256):
743     """
744     @notice Get data delegation toward an account
745     @param _receiver Address to query delegation data for
746     @param _gauge Gauge address to query. Use ZERO_ADDRESS for global delegation.
747     @param _idx Data index. Each account can receive a max of 10 delegations per pool.
748     @return address of the delegator
749             delegated boost pct (out of 10000)
750             cancellable timestamp
751             expiry timestamp
752     """
753     data: uint256 = self.delegation_data[_receiver][_gauge].data[_idx]
754     return (
755         convert(shift(data, 96), address),
756         shift(data, 80) % 2**16,
757         shift(data, 40) % 2**40,
758         data % 2**40
759     )
760 
761 
762 @external
763 def set_operator(_operator: address) -> bool:
764     """
765     @notice Set the authorized operator for an address
766     @dev An operator can delegate boost, including creating delegations that
767          cannot be cancelled. This permission should only be given to trusted
768          3rd parties and smart contracts where the contract behavior is known
769          to be not malicious.
770     @param _operator Approved operator address. Set to `ZERO_ADDRESS` to revoke
771                      the currently active approval.
772     @return bool success
773     """
774     self.operator_of[msg.sender] = _operator
775     return True
776 
777 
778 @internal
779 def _delete_delegation_data(_delegator: address, _gauge: address, _delegation_data: uint256):
780     # delete record for the delegator
781     self.delegated_to[_delegator][_gauge] = 0
782     self.delegation_count[_delegator] -= 1
783 
784     receiver: address = convert(shift(_delegation_data, 96), address)
785     length: uint256 = self.delegation_data[receiver][_gauge].length
786 
787     # delete record for the receiver
788     for i in range(10):
789         if i == length - 1:
790             self.delegation_data[receiver][_gauge].data[i] = 0
791             break
792         if self.delegation_data[receiver][_gauge].data[i] == _delegation_data:
793             self.delegation_data[receiver][_gauge].data[i] = self.delegation_data[receiver][_gauge].data[length-1]
794             self.delegation_data[receiver][_gauge].data[length-1] = 0
795 
796 
797 @external
798 def delegate_boost(
799     _delegator: address,
800     _gauge: address,
801     _receiver: address,
802     _pct: uint256,
803     _cancel_time: uint256,
804     _expire_time: uint256
805 ) -> bool:
806     """
807     @notice Delegate per-gauge or global boost to another account
808     @param _delegator Address of the user delegating boost. The caller must be the
809                       delegator or the approved operator of the delegator.
810     @param _gauge Address of the gauge to delegate for. Set as ZERO_ADDRESS for
811                   global delegation. Global delegation is not possible if there is
812                   also one or more active per-gauge delegations.
813     @param _receiver Address to delegate boost to.
814     @param _pct Percentage of boost to delegate. 100% is expressed as 10000.
815     @param _cancel_time Delegation cannot be cancelled before this time.
816     @param _expire_time Delegation automatically expires at this time.
817     @return bool success
818     """
819     assert msg.sender in [_delegator, self.operator_of[_delegator]], "Only owner or operator"
820 
821     assert _delegator != _receiver, "Cannot delegate to self"
822     assert _pct >= 100, "Percent too low"
823     assert _pct <= 10000, "Percent too high"
824     assert _expire_time < 2**40, "Expiry time too high"
825     assert _expire_time > block.timestamp, "Already expired"
826     assert _cancel_time <= _expire_time, "Cancel time after expiry time"
827 
828     # check for minimum ve- balance, used to prevent 0 ve- delegation spam
829     assert self._balanceOf(_delegator) >= MIN_VE, "Insufficient ve- to delegate"
830 
831     # check for an existing, expired delegation
832     data: uint256 = self.delegated_to[_delegator][_gauge]
833     if data != 0:
834         assert data % 2**40 <= block.timestamp, "Existing delegation has not expired"
835         self._delete_delegation_data(_delegator, _gauge, data)
836 
837     if _gauge == ZERO_ADDRESS:
838         assert self.delegation_count[_delegator] == 0, "Cannot delegate globally while per-gauge is active"
839     else:
840         assert self.delegated_to[_delegator][ZERO_ADDRESS] == 0, "Cannot delegate per-gauge while global is active"
841 
842     # tightly pack the delegation data
843     # [address][uint16 pct][uint40 cancel time][uint40 expire time]
844     data = shift(_pct, -80) + shift(_cancel_time, -40) + _expire_time
845     idx: uint256 = self.delegation_data[_receiver][_gauge].length
846 
847     self.delegation_data[_receiver][_gauge].data[idx] = data + shift(convert(_delegator, uint256), -96)
848     self.delegated_to[_delegator][_gauge] = data + shift(convert(_receiver, uint256), -96)
849     self.delegation_data[_receiver][_gauge].length = idx + 1
850 
851     log NewDelegation(_delegator, _gauge, _receiver, _pct, _cancel_time, _expire_time)
852     return True
853 
854 
855 @external
856 def cancel_delegation(_delegator: address, _gauge: address) -> bool:
857     """
858     @notice Cancel an existing boost delegation
859     @param _delegator Address of the user delegating boost. The caller can be the
860                       delegator, the receiver, the approved operator of the delegator
861                       or receiver. The delegator can cancel after the cancel time
862                       has passed, the receiver can cancel at any time.
863     @param _gauge Address of the gauge to cancel delegattion for. Set as ZERO_ADDRESS
864                   for global delegation.
865     @return bool success
866     """
867     data: uint256 = self.delegated_to[_delegator][_gauge]
868     assert data != 0, "No delegation for this pool"
869 
870     receiver: address = convert(shift(data, 96), address)
871     if msg.sender not in [receiver, self.operator_of[receiver]]:
872         assert msg.sender in [receiver, self.operator_of[receiver]], "Only owner or operator"
873         assert shift(data, 40) % 2**40 <= block.timestamp, "Not yet cancellable"
874 
875     self._delete_delegation_data(_delegator, _gauge, data)
876 
877     log CancelledDelegation(_delegator, _gauge, receiver, msg.sender)
878     return True
879 
880 
881 @view
882 @external
883 def get_adjusted_ve_balance(_user: address, _gauge: address) -> uint256:
884     """
885     @notice Get the adjusted ve- balance of an account after delegation
886     @param _user Address to query a ve- balance for
887     @param _gauge Gauge address
888     @return Adjusted ve- balance after delegation
889     """
890     # query the initial ve balance for `_user`
891     voting_balance: uint256 = self._balanceOf(_user)
892 
893     # check if the user has delegated any ve and reduce the voting balance
894     delegation_count: uint256 = self.delegation_count[_user]
895     if delegation_count != 0:
896         is_global: bool = False
897         # apply global delegation
898         if delegation_count == 1:
899             data: uint256 = self.delegated_to[_user][ZERO_ADDRESS]
900             if data % 2**40 > block.timestamp:
901                 voting_balance = voting_balance * (10000 - shift(data, 80) % 2**16) / 10000
902                 is_global = True
903         # apply pool-specific delegation
904         if not is_global:
905             data: uint256 = self.delegated_to[_user][_gauge]
906             if data % 2**40 > block.timestamp:
907                 voting_balance = voting_balance * (10000 - shift(data, 80) % 2**16) / 10000
908 
909     # check for other ve delegated to `_user` and increase the voting balance
910     for target in [_gauge, ZERO_ADDRESS]:
911         length: uint256 = self.delegation_data[_user][target].length
912         if length > 0:
913             for i in range(10):
914                 if i == length:
915                     break
916                 data: uint256 = self.delegation_data[_user][target].data[i]
917                 if data % 2**40 > block.timestamp:
918                     delegator: address = convert(shift(data, 96), address)
919                     delegator_balance: uint256 = self._balanceOf(delegator)
920                     voting_balance += delegator_balance * (shift(data, 80) % 2**16) / 10000
921 
922     return voting_balance
923 
924 
925 @external
926 def update_delegation_records(_user: address, _gauge: address) -> bool:
927     """
928     @notice Remove data about any expired delegations for a user.
929     @dev Reduces gas costs when calling `get_adjusted_ve_balance` on
930          an address with expired delegations.
931     @param _user Address to update records for.
932     @param _gauge Gauge address. Use `ZERO_ADDRESS` for global delegations.
933     """
934     length: uint256 = self.delegation_data[_user][_gauge].length - 1
935     adjusted_length: uint256 = length
936 
937     # iterate in reverse over `delegation_data` and remove expired records
938     for i in range(10):
939         if i > length:
940             break
941         idx: uint256 = length - i
942         data: uint256 = self.delegation_data[_user][_gauge].data[idx]
943         if data % 2**40 <= block.timestamp:
944             # delete record for the delegator
945             delegator: address = convert(shift(data, 96), address)
946             self.delegated_to[delegator][_gauge] = 0
947             self.delegation_count[delegator] -= 1
948 
949             # delete record for the receiver
950             if idx == adjusted_length:
951                 self.delegation_data[_user][_gauge].data[idx] = 0
952             else:
953                 self.delegation_data[_user][_gauge].data[idx] = self.delegation_data[_user][_gauge].data[adjusted_length]
954             adjusted_length -= 1
955 
956     return True