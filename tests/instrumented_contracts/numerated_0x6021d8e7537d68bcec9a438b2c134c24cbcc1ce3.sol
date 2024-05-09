1 # @version 0.2.4
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
61 event Shutdown:
62     pass
63 
64 event CommitOwnership:
65     admin: address
66 
67 event ApplyOwnership:
68     admin: address
69 
70 event Deposit:
71     provider: indexed(address)
72     value: uint256
73     locktime: indexed(uint256)
74     type: int128
75     ts: uint256
76 
77 event Withdraw:
78     provider: indexed(address)
79     value: uint256
80     ts: uint256
81 
82 event Supply:
83     prevSupply: uint256
84     supply: uint256
85 
86 event Delegate:
87     user: address
88     delegate: address 
89 
90 
91 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
92 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
93 MULTIPLIER: constant(uint256) = 10 ** 18
94 
95 token: public(address)
96 supply: public(uint256)
97 
98 locked: public(HashMap[address, LockedBalance])
99 
100 epoch: public(uint256)
101 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
102 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
103 user_point_epoch: public(HashMap[address, uint256])
104 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
105 
106 # Aragon's view methods for compatibility
107 controller: public(address)
108 transfersEnabled: public(bool)
109 
110 name: public(String[64])
111 symbol: public(String[32])
112 version: public(String[32])
113 decimals: public(uint256)
114 
115 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
116 # The goal is to prevent tokenizing the escrow
117 future_smart_wallet_checker: public(address)
118 smart_wallet_checker: public(address)
119 
120 admin: public(address)  # Can and will be a smart contract
121 future_admin: public(address)
122 
123 # Functionality added to original Curve contract:
124 
125 # 1) allow complete shutdown of this contract while
126 # allowing users to withdraw their locked deposits
127 is_shutdown: public(bool)
128 
129 # 2) allow delegation for the `create_lock` functionality
130 # via a slightly modified `create_lock_for` function.
131 delegate_for: public(HashMap[address, address])
132 
133 
134 @external
135 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
136     """
137     @notice Contract constructor
138     @param token_addr `ERC20CRV` token address
139     @param _name Token name
140     @param _symbol Token symbol
141     @param _version Contract version - required for Aragon compatibility
142     """
143     self.admin = msg.sender
144     self.token = token_addr
145     self.point_history[0].blk = block.number
146     self.point_history[0].ts = block.timestamp
147     self.controller = msg.sender
148     self.transfersEnabled = True
149 
150     _decimals: uint256 = ERC20(token_addr).decimals()
151     assert _decimals <= 255
152     self.decimals = _decimals
153 
154     self.name = _name
155     self.symbol = _symbol
156     self.version = _version
157 
158     self.is_shutdown = False
159 
160 
161 @external
162 def shutdown():
163     """
164     @notice Disable deposits but allow withdrawals regardless of lock
165 
166     Extension to original VotingEscrow
167     """
168     assert msg.sender == self.admin, "Admin only"  # dev: admin only
169     self.is_shutdown = True
170     log Shutdown()
171 
172 
173 @external
174 def commit_transfer_ownership(addr: address):
175     """
176     @notice Transfer ownership of VotingEscrow contract to `addr`
177     @param addr Address to have ownership transferred to
178     """
179     assert msg.sender == self.admin  # dev: admin only
180     self.future_admin = addr
181     log CommitOwnership(addr)
182 
183 
184 @external
185 def apply_transfer_ownership():
186     """
187     @notice Apply ownership transfer
188     """
189     assert msg.sender == self.admin  # dev: admin only
190     _admin: address = self.future_admin
191     assert _admin != ZERO_ADDRESS  # dev: admin not set
192     self.admin = _admin
193     log ApplyOwnership(_admin)
194 
195 
196 @external
197 def commit_smart_wallet_checker(addr: address):
198     """
199     @notice Set an external contract to check for approved smart contract wallets
200     @param addr Address of Smart contract checker
201     """
202     assert msg.sender == self.admin
203     self.future_smart_wallet_checker = addr
204 
205 
206 @external
207 def apply_smart_wallet_checker():
208     """
209     @notice Apply setting external contract to check approved smart contract wallets
210     """
211     assert msg.sender == self.admin
212     self.smart_wallet_checker = self.future_smart_wallet_checker
213 
214 
215 @internal
216 def assert_not_contract(addr: address):
217     """
218     @notice Check if the call is from a whitelisted smart contract, revert if not
219     @param addr Address to be checked
220     """
221     if addr != tx.origin:
222         checker: address = self.smart_wallet_checker
223         if checker != ZERO_ADDRESS:
224             if SmartWalletChecker(checker).check(addr):
225                 return
226         raise "Smart contract depositors not allowed"
227 
228 
229 @external
230 def assign_delegate(addr: address):
231     """
232     @notice Assign `addr` the power to create locks for `msg.sender`
233     @param addr Address of lock delegate
234 
235     Extension to original VotingEscrow
236     """
237     self.delegate_for[msg.sender] = addr
238     log Delegate(msg.sender, addr)
239 
240 
241 @external
242 @view
243 def get_last_user_slope(addr: address) -> int128:
244     """
245     @notice Get the most recently recorded rate of voting power decrease for `addr`
246     @param addr Address of the user wallet
247     @return Value of the slope
248     """
249     uepoch: uint256 = self.user_point_epoch[addr]
250     return self.user_point_history[addr][uepoch].slope
251 
252 
253 @external
254 @view
255 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
256     """
257     @notice Get the timestamp for checkpoint `_idx` for `_addr`
258     @param _addr User wallet address
259     @param _idx User epoch number
260     @return Epoch time of the checkpoint
261     """
262     return self.user_point_history[_addr][_idx].ts
263 
264 
265 @external
266 @view
267 def locked__end(_addr: address) -> uint256:
268     """
269     @notice Get timestamp when `_addr`'s lock finishes
270     @param _addr User wallet
271     @return Epoch time of the lock end
272     """
273     return self.locked[_addr].end
274 
275 
276 @internal
277 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
278     """
279     @notice Record global and per-user data to checkpoint
280     @param addr User's wallet address. No user checkpoint if 0x0
281     @param old_locked Pevious locked amount / end lock time for the user
282     @param new_locked New locked amount / end lock time for the user
283     """
284     u_old: Point = empty(Point)
285     u_new: Point = empty(Point)
286     old_dslope: int128 = 0
287     new_dslope: int128 = 0
288     _epoch: uint256 = self.epoch
289 
290     if addr != ZERO_ADDRESS:
291         # Calculate slopes and biases
292         # Kept at zero when they have to
293         if old_locked.end > block.timestamp and old_locked.amount > 0:
294             u_old.slope = old_locked.amount / MAXTIME
295             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
296         if new_locked.end > block.timestamp and new_locked.amount > 0:
297             u_new.slope = new_locked.amount / MAXTIME
298             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
299 
300         # Read values of scheduled changes in the slope
301         # old_locked.end can be in the past and in the future
302         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
303         old_dslope = self.slope_changes[old_locked.end]
304         if new_locked.end != 0:
305             if new_locked.end == old_locked.end:
306                 new_dslope = old_dslope
307             else:
308                 new_dslope = self.slope_changes[new_locked.end]
309 
310     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
311     if _epoch > 0:
312         last_point = self.point_history[_epoch]
313     last_checkpoint: uint256 = last_point.ts
314     # initial_last_point is used for extrapolation to calculate block number
315     # (approximately, for *At methods) and save them
316     # as we cannot figure that out exactly from inside the contract
317     initial_last_point: Point = last_point
318     block_slope: uint256 = 0  # dblock/dt
319     if block.timestamp > last_point.ts:
320         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
321     # If last point is already recorded in this block, slope=0
322     # But that's ok b/c we know the block in such case
323 
324     # Go over weeks to fill history and calculate what the current point is
325     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
326     for i in range(255):
327         # Hopefully it won't happen that this won't get used in 5 years!
328         # If it does, users will be able to withdraw but vote weight will be broken
329         t_i += WEEK
330         d_slope: int128 = 0
331         if t_i > block.timestamp:
332             t_i = block.timestamp
333         else:
334             d_slope = self.slope_changes[t_i]
335         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
336         last_point.slope += d_slope
337         if last_point.bias < 0:  # This can happen
338             last_point.bias = 0
339         if last_point.slope < 0:  # This cannot happen - just in case
340             last_point.slope = 0
341         last_checkpoint = t_i
342         last_point.ts = t_i
343         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
344         _epoch += 1
345         if t_i == block.timestamp:
346             last_point.blk = block.number
347             break
348         else:
349             self.point_history[_epoch] = last_point
350 
351     self.epoch = _epoch
352     # Now point_history is filled until t=now
353 
354     if addr != ZERO_ADDRESS:
355         # If last point was in this block, the slope change has been applied already
356         # But in such case we have 0 slope(s)
357         last_point.slope += (u_new.slope - u_old.slope)
358         last_point.bias += (u_new.bias - u_old.bias)
359         if last_point.slope < 0:
360             last_point.slope = 0
361         if last_point.bias < 0:
362             last_point.bias = 0
363 
364     # Record the changed point into history
365     self.point_history[_epoch] = last_point
366 
367     if addr != ZERO_ADDRESS:
368         # Schedule the slope changes (slope is going down)
369         # We subtract new_user_slope from [new_locked.end]
370         # and add old_user_slope to [old_locked.end]
371         if old_locked.end > block.timestamp:
372             # old_dslope was <something> - u_old.slope, so we cancel that
373             old_dslope += u_old.slope
374             if new_locked.end == old_locked.end:
375                 old_dslope -= u_new.slope  # It was a new deposit, not extension
376             self.slope_changes[old_locked.end] = old_dslope
377 
378         if new_locked.end > block.timestamp:
379             if new_locked.end > old_locked.end:
380                 new_dslope -= u_new.slope  # old slope disappeared at this point
381                 self.slope_changes[new_locked.end] = new_dslope
382             # else: we recorded it already in old_dslope
383 
384         # Now handle user history
385         user_epoch: uint256 = self.user_point_epoch[addr] + 1
386 
387         self.user_point_epoch[addr] = user_epoch
388         u_new.ts = block.timestamp
389         u_new.blk = block.number
390         self.user_point_history[addr][user_epoch] = u_new
391 
392 
393 @internal
394 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
395     """
396     @notice Deposit and lock tokens for a user
397     @param _addr User's wallet address
398     @param _value Amount to deposit
399     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
400     @param locked_balance Previous locked amount / timestamp
401     """
402     _locked: LockedBalance = locked_balance
403     supply_before: uint256 = self.supply
404 
405     self.supply = supply_before + _value
406     old_locked: LockedBalance = _locked
407     # Adding to existing lock, or if a lock is expired - creating a new one
408     _locked.amount += convert(_value, int128)
409     if unlock_time != 0:
410         _locked.end = unlock_time
411     self.locked[_addr] = _locked
412 
413     # Possibilities:
414     # Both old_locked.end could be current or expired (>/< block.timestamp)
415     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
416     # _locked.end > block.timestamp (always)
417     self._checkpoint(_addr, old_locked, _locked)
418 
419 
420     if _value != 0:
421         assert ERC20(self.token).transferFrom(_addr, self, _value)
422 
423     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
424     log Supply(supply_before, supply_before + _value)
425 
426 
427 @external
428 def checkpoint():
429     """
430     @notice Record global data to checkpoint
431     """
432     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
433 
434 
435 @external
436 @nonreentrant('lock')
437 def deposit_for(_addr: address, _value: uint256):
438     """
439     @notice Deposit `_value` tokens for `_addr` and add to the lock
440     @dev Anyone (even a smart contract) can deposit for someone else, but
441          cannot extend their locktime and deposit for a brand new user
442     @param _addr User's wallet address
443     @param _value Amount to add to user's lock
444     """
445     _locked: LockedBalance = self.locked[_addr]
446 
447     assert not self.is_shutdown, "Contract is shutdown"
448     assert _value > 0  # dev: need non-zero value
449     assert _locked.amount > 0, "No existing lock found"
450     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
451 
452     self._deposit_for(_addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
453 
454 
455 @external
456 @nonreentrant('lock')
457 def create_lock(_value: uint256, _unlock_time: uint256):
458     """
459     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
460     @param _value Amount to deposit
461     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
462     """
463     self.assert_not_contract(msg.sender)
464     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
465     _locked: LockedBalance = self.locked[msg.sender]
466 
467     assert not self.is_shutdown, "Contract is shutdown"
468     assert _value > 0  # dev: need non-zero value
469     assert _locked.amount == 0, "Withdraw old tokens first"
470     assert unlock_time > block.timestamp, "Can only lock until time in the future"
471     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
472 
473     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
474 
475 
476 @external
477 @nonreentrant('lock')
478 def create_lock_for(_addr: address, _value: uint256, _unlock_time: uint256):
479     """
480     @notice Deposit `_value` tokens for `_addr` and lock until `_unlock_time`
481     @param _addr Address lock is for
482     @param _value Amount to deposit
483     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
484 
485     Extension to original VotingEscrow
486     """
487     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
488     _locked: LockedBalance = self.locked[_addr]
489 
490     assert not self.is_shutdown, "Contract is shutdown"
491     assert msg.sender == self.delegate_for[_addr], "Delegate only"
492     assert _value > 0  # dev: need non-zero value
493     assert _locked.amount == 0, "Withdraw old tokens first"
494     assert unlock_time > block.timestamp, "Can only lock until time in the future"
495     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
496 
497     self._deposit_for(_addr, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
498 
499 
500 @external
501 @nonreentrant('lock')
502 def increase_amount(_value: uint256):
503     """
504     @notice Deposit `_value` additional tokens for `msg.sender`
505             without modifying the unlock time
506     @param _value Amount of tokens to deposit and add to the lock
507     """
508     self.assert_not_contract(msg.sender)
509     _locked: LockedBalance = self.locked[msg.sender]
510 
511     assert not self.is_shutdown, "Contract is shutdown"
512     assert _value > 0  # dev: need non-zero value
513     assert _locked.amount > 0, "No existing lock found"
514     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
515 
516     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
517 
518 
519 @external
520 @nonreentrant('lock')
521 def increase_unlock_time(_unlock_time: uint256):
522     """
523     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
524     @param _unlock_time New epoch time for unlocking
525     """
526     self.assert_not_contract(msg.sender)
527     _locked: LockedBalance = self.locked[msg.sender]
528     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
529 
530     assert not self.is_shutdown, "Contract is shutdown"
531     assert _locked.end > block.timestamp, "Lock expired"
532     assert _locked.amount > 0, "Nothing is locked"
533     assert unlock_time > _locked.end, "Can only increase lock duration"
534     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
535 
536     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
537 
538 
539 @external
540 @nonreentrant('lock')
541 def withdraw():
542     """
543     @notice Withdraw all tokens for `msg.sender`
544     @dev Only possible if the lock has expired
545     """
546     _locked: LockedBalance = self.locked[msg.sender]
547     assert block.timestamp >= _locked.end or self.is_shutdown, "The lock didn't expire"
548     value: uint256 = convert(_locked.amount, uint256)
549 
550     old_locked: LockedBalance = _locked
551     _locked.end = 0
552     _locked.amount = 0
553     self.locked[msg.sender] = _locked
554     supply_before: uint256 = self.supply
555     self.supply = supply_before - value
556 
557     # old_locked can have either expired <= timestamp or zero end
558     # _locked has only 0 end
559     # Both can have >= 0 amount
560     if not self.is_shutdown:
561         self._checkpoint(msg.sender, old_locked, _locked)
562 
563     assert ERC20(self.token).transfer(msg.sender, value)
564 
565     log Withdraw(msg.sender, value, block.timestamp)
566     log Supply(supply_before, supply_before - value)
567 
568 
569 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
570 # They measure the weights for the purpose of voting, so they don't represent
571 # real coins.
572 
573 @internal
574 @view
575 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
576     """
577     @notice Binary search to estimate timestamp for block number
578     @param _block Block to find
579     @param max_epoch Don't go beyond this epoch
580     @return Approximate timestamp for block
581     """
582     # Binary search
583     _min: uint256 = 0
584     _max: uint256 = max_epoch
585     for i in range(128):  # Will be always enough for 128-bit numbers
586         if _min >= _max:
587             break
588         _mid: uint256 = (_min + _max + 1) / 2
589         if self.point_history[_mid].blk <= _block:
590             _min = _mid
591         else:
592             _max = _mid - 1
593     return _min
594 
595 
596 @external
597 @view
598 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
599     """
600     @notice Get the current voting power for `msg.sender`
601     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
602     @param addr User wallet address
603     @param _t Epoch time to return voting power at
604     @return User voting power
605     """
606     _epoch: uint256 = self.user_point_epoch[addr]
607     if _epoch == 0:
608         return 0
609     else:
610         last_point: Point = self.user_point_history[addr][_epoch]
611         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
612         if last_point.bias < 0:
613             last_point.bias = 0
614         return convert(last_point.bias, uint256)
615 
616 
617 @external
618 @view
619 def balanceOfAt(addr: address, _block: uint256) -> uint256:
620     """
621     @notice Measure voting power of `addr` at block height `_block`
622     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
623     @param addr User's wallet address
624     @param _block Block to calculate the voting power at
625     @return Voting power
626     """
627     # Copying and pasting totalSupply code because Vyper cannot pass by
628     # reference yet
629     assert _block <= block.number
630 
631     # Binary search
632     _min: uint256 = 0
633     _max: uint256 = self.user_point_epoch[addr]
634     for i in range(128):  # Will be always enough for 128-bit numbers
635         if _min >= _max:
636             break
637         _mid: uint256 = (_min + _max + 1) / 2
638         if self.user_point_history[addr][_mid].blk <= _block:
639             _min = _mid
640         else:
641             _max = _mid - 1
642 
643     upoint: Point = self.user_point_history[addr][_min]
644 
645     max_epoch: uint256 = self.epoch
646     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
647     point_0: Point = self.point_history[_epoch]
648     d_block: uint256 = 0
649     d_t: uint256 = 0
650     if _epoch < max_epoch:
651         point_1: Point = self.point_history[_epoch + 1]
652         d_block = point_1.blk - point_0.blk
653         d_t = point_1.ts - point_0.ts
654     else:
655         d_block = block.number - point_0.blk
656         d_t = block.timestamp - point_0.ts
657     block_time: uint256 = point_0.ts
658     if d_block != 0:
659         block_time += d_t * (_block - point_0.blk) / d_block
660 
661     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
662     if upoint.bias >= 0:
663         return convert(upoint.bias, uint256)
664     else:
665         return 0
666 
667 
668 @internal
669 @view
670 def supply_at(point: Point, t: uint256) -> uint256:
671     """
672     @notice Calculate total voting power at some point in the past
673     @param point The point (bias/slope) to start search from
674     @param t Time to calculate the total voting power at
675     @return Total voting power at that time
676     """
677     last_point: Point = point
678     t_i: uint256 = (last_point.ts / WEEK) * WEEK
679     for i in range(255):
680         t_i += WEEK
681         d_slope: int128 = 0
682         if t_i > t:
683             t_i = t
684         else:
685             d_slope = self.slope_changes[t_i]
686         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
687         if t_i == t:
688             break
689         last_point.slope += d_slope
690         last_point.ts = t_i
691 
692     if last_point.bias < 0:
693         last_point.bias = 0
694     return convert(last_point.bias, uint256)
695 
696 
697 @external
698 @view
699 def totalSupply(t: uint256 = block.timestamp) -> uint256:
700     """
701     @notice Calculate total voting power
702     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
703     @return Total voting power
704     """
705     _epoch: uint256 = self.epoch
706     last_point: Point = self.point_history[_epoch]
707     return self.supply_at(last_point, t)
708 
709 
710 @external
711 @view
712 def totalSupplyAt(_block: uint256) -> uint256:
713     """
714     @notice Calculate total voting power at some point in the past
715     @param _block Block to calculate the total voting power at
716     @return Total voting power at `_block`
717     """
718     assert _block <= block.number
719     _epoch: uint256 = self.epoch
720     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
721 
722     point: Point = self.point_history[target_epoch]
723     dt: uint256 = 0
724     if target_epoch < _epoch:
725         point_next: Point = self.point_history[target_epoch + 1]
726         if point.blk != point_next.blk:
727             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
728     else:
729         if point.blk != block.number:
730             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
731     # Now dt contains info on how far are we beyond point
732 
733     return self.supply_at(point, point.ts + dt)
734 
735 
736 # Dummy methods for compatibility with Aragon
737 
738 @external
739 def changeController(_newController: address):
740     """
741     @dev Dummy method required for Aragon compatibility
742     """
743     assert msg.sender == self.controller
744     self.controller = _newController