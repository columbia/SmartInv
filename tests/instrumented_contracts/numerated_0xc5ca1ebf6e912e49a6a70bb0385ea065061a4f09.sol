1 # @version 0.2.4
2 """
3 @title Voting Escrow
4 @author APWine, Curve Finance
5 @license MIT
6 @notice Votes have a weight depending on time, so that users are
7         committed to the future of (whatever they are voting for)
8 @dev Vote weight decays linearly over time. Lock time cannot be
9      more than `MAXTIME` (2 years). (modified for veAPW)
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
83 
84 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
85 MAXTIME: constant(uint256) = 2 * 365 * 86400  # 2 years
86 MULTIPLIER: constant(uint256) = 10 ** 18
87 
88 token: public(address)
89 supply: public(uint256)
90 
91 locked: public(HashMap[address, LockedBalance])
92 
93 epoch: public(uint256)
94 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
95 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
96 user_point_epoch: public(HashMap[address, uint256])
97 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
98 
99 # Aragon's view methods for compatibility
100 controller: public(address)
101 transfersEnabled: public(bool)
102 
103 name: public(String[64])
104 symbol: public(String[32])
105 version: public(String[32])
106 decimals: public(uint256)
107 
108 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
109 # The goal is to prevent tokenizing the escrow
110 future_smart_wallet_checker: public(address)
111 smart_wallet_checker: public(address)
112 
113 admin: public(address)  # Can and will be a smart contract
114 future_admin: public(address)
115 
116 
117 @external
118 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
119     """
120     @notice Contract constructor
121     @param token_addr `ERC20APW` token address
122     @param _name Token name
123     @param _symbol Token symbol
124     @param _version Contract version - required for Aragon compatibility
125     """
126     self.admin = msg.sender
127     self.token = token_addr
128     self.point_history[0].blk = block.number
129     self.point_history[0].ts = block.timestamp
130     self.controller = msg.sender
131     self.transfersEnabled = True
132 
133     _decimals: uint256 = ERC20(token_addr).decimals()
134     assert _decimals <= 255
135     self.decimals = _decimals
136 
137     self.name = _name
138     self.symbol = _symbol
139     self.version = _version
140 
141 
142 @external
143 def commit_transfer_ownership(addr: address):
144     """
145     @notice Transfer ownership of VotingEscrow contract to `addr`
146     @param addr Address to have ownership transferred to
147     """
148     assert msg.sender == self.admin  # dev: admin only
149     self.future_admin = addr
150     log CommitOwnership(addr)
151 
152 
153 @external
154 def apply_transfer_ownership():
155     """
156     @notice Apply ownership transfer
157     """
158     assert msg.sender == self.admin  # dev: admin only
159     _admin: address = self.future_admin
160     assert _admin != ZERO_ADDRESS  # dev: admin not set
161     self.admin = _admin
162     log ApplyOwnership(_admin)
163 
164 
165 @external
166 def commit_smart_wallet_checker(addr: address):
167     """
168     @notice Set an external contract to check for approved smart contract wallets
169     @param addr Address of Smart contract checker
170     """
171     assert msg.sender == self.admin
172     self.future_smart_wallet_checker = addr
173 
174 
175 @external
176 def apply_smart_wallet_checker():
177     """
178     @notice Apply setting external contract to check approved smart contract wallets
179     """
180     assert msg.sender == self.admin
181     self.smart_wallet_checker = self.future_smart_wallet_checker
182 
183 
184 @internal
185 def assert_not_contract(addr: address):
186     """
187     @notice Check if the call is from a whitelisted smart contract, revert if not
188     @param addr Address to be checked
189     """
190     if addr != tx.origin:
191         checker: address = self.smart_wallet_checker
192         if checker != ZERO_ADDRESS:
193             if SmartWalletChecker(checker).check(addr):
194                 return
195         raise "Smart contract depositors not allowed"
196 
197 
198 @external
199 @view
200 def get_last_user_slope(addr: address) -> int128:
201     """
202     @notice Get the most recently recorded rate of voting power decrease for `addr`
203     @param addr Address of the user wallet
204     @return Value of the slope
205     """
206     uepoch: uint256 = self.user_point_epoch[addr]
207     return self.user_point_history[addr][uepoch].slope
208 
209 
210 @external
211 @view
212 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
213     """
214     @notice Get the timestamp for checkpoint `_idx` for `_addr`
215     @param _addr User wallet address
216     @param _idx User epoch number
217     @return Epoch time of the checkpoint
218     """
219     return self.user_point_history[_addr][_idx].ts
220 
221 
222 @external
223 @view
224 def locked__end(_addr: address) -> uint256:
225     """
226     @notice Get timestamp when `_addr`'s lock finishes
227     @param _addr User wallet
228     @return Epoch time of the lock end
229     """
230     return self.locked[_addr].end
231 
232 @external
233 @view
234 def locked__amount(_addr: address) -> uint256:
235     """
236     @notice Get amount locked in `_addr`'s lock
237     @param _addr User wallet
238     @return Amount locked
239     """
240     return convert(self.locked[_addr].amount, uint256)
241 
242 
243 @internal
244 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
245     """
246     @notice Record global and per-user data to checkpoint
247     @param addr User's wallet address. No user checkpoint if 0x0
248     @param old_locked Pevious locked amount / end lock time for the user
249     @param new_locked New locked amount / end lock time for the user
250     """
251     u_old: Point = empty(Point)
252     u_new: Point = empty(Point)
253     old_dslope: int128 = 0
254     new_dslope: int128 = 0
255     _epoch: uint256 = self.epoch
256 
257     if addr != ZERO_ADDRESS:
258         # Calculate slopes and biases
259         # Kept at zero when they have to
260         if old_locked.end > block.timestamp and old_locked.amount > 0:
261             u_old.slope = old_locked.amount / MAXTIME
262             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
263         if new_locked.end > block.timestamp and new_locked.amount > 0:
264             u_new.slope = new_locked.amount / MAXTIME
265             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
266 
267         # Read values of scheduled changes in the slope
268         # old_locked.end can be in the past and in the future
269         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
270         old_dslope = self.slope_changes[old_locked.end]
271         if new_locked.end != 0:
272             if new_locked.end == old_locked.end:
273                 new_dslope = old_dslope
274             else:
275                 new_dslope = self.slope_changes[new_locked.end]
276 
277     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
278     if _epoch > 0:
279         last_point = self.point_history[_epoch]
280     last_checkpoint: uint256 = last_point.ts
281     # initial_last_point is used for extrapolation to calculate block number
282     # (approximately, for *At methods) and save them
283     # as we cannot figure that out exactly from inside the contract
284     initial_last_point: Point = last_point
285     block_slope: uint256 = 0  # dblock/dt
286     if block.timestamp > last_point.ts:
287         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
288     # If last point is already recorded in this block, slope=0
289     # But that's ok b/c we know the block in such case
290 
291     # Go over weeks to fill history and calculate what the current point is
292     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
293     for i in range(255):
294         # Hopefully it won't happen that this won't get used in 5 years!
295         # If it does, users will be able to withdraw but vote weight will be broken
296         t_i += WEEK
297         d_slope: int128 = 0
298         if t_i > block.timestamp:
299             t_i = block.timestamp
300         else:
301             d_slope = self.slope_changes[t_i]
302         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
303         last_point.slope += d_slope
304         if last_point.bias < 0:  # This can happen
305             last_point.bias = 0
306         if last_point.slope < 0:  # This cannot happen - just in case
307             last_point.slope = 0
308         last_checkpoint = t_i
309         last_point.ts = t_i
310         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
311         _epoch += 1
312         if t_i == block.timestamp:
313             last_point.blk = block.number
314             break
315         else:
316             self.point_history[_epoch] = last_point
317 
318     self.epoch = _epoch
319     # Now point_history is filled until t=now
320 
321     if addr != ZERO_ADDRESS:
322         # If last point was in this block, the slope change has been applied already
323         # But in such case we have 0 slope(s)
324         last_point.slope += (u_new.slope - u_old.slope)
325         last_point.bias += (u_new.bias - u_old.bias)
326         if last_point.slope < 0:
327             last_point.slope = 0
328         if last_point.bias < 0:
329             last_point.bias = 0
330 
331     # Record the changed point into history
332     self.point_history[_epoch] = last_point
333 
334     if addr != ZERO_ADDRESS:
335         # Schedule the slope changes (slope is going down)
336         # We subtract new_user_slope from [new_locked.end]
337         # and add old_user_slope to [old_locked.end]
338         if old_locked.end > block.timestamp:
339             # old_dslope was <something> - u_old.slope, so we cancel that
340             old_dslope += u_old.slope
341             if new_locked.end == old_locked.end:
342                 old_dslope -= u_new.slope  # It was a new deposit, not extension
343             self.slope_changes[old_locked.end] = old_dslope
344 
345         if new_locked.end > block.timestamp:
346             if new_locked.end > old_locked.end:
347                 new_dslope -= u_new.slope  # old slope disappeared at this point
348                 self.slope_changes[new_locked.end] = new_dslope
349             # else: we recorded it already in old_dslope
350 
351         # Now handle user history
352         user_epoch: uint256 = self.user_point_epoch[addr] + 1
353 
354         self.user_point_epoch[addr] = user_epoch
355         u_new.ts = block.timestamp
356         u_new.blk = block.number
357         self.user_point_history[addr][user_epoch] = u_new
358 
359 
360 # TODO: add _sender parameter to prevent anyone from being able to deposit_for in case allowance has been given & forgotten
361 @internal
362 def _deposit_for(_addr: address, _spender:address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
363     """
364     @notice Deposit and lock tokens for a user
365     @param _addr User's wallet address
366     @param _value Amount to deposit
367     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
368     @param locked_balance Previous locked amount / timestamp
369     """
370     _locked: LockedBalance = locked_balance
371     supply_before: uint256 = self.supply
372 
373     self.supply = supply_before + _value
374     old_locked: LockedBalance = _locked
375     # Adding to existing lock, or if a lock is expired - creating a new one
376     _locked.amount += convert(_value, int128)
377     if unlock_time != 0:
378         _locked.end = unlock_time
379     self.locked[_addr] = _locked
380 
381     # Possibilities:
382     # Both old_locked.end could be current or expired (>/< block.timestamp)
383     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
384     # _locked.end > block.timestamp (always)
385     self._checkpoint(_addr, old_locked, _locked)
386 
387     if _value != 0:
388         assert ERC20(self.token).transferFrom(_spender, self, _value)
389 
390     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
391     log Supply(supply_before, supply_before + _value)
392 
393 
394 @external
395 def checkpoint():
396     """
397     @notice Record global data to checkpoint
398     """
399     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
400 
401 
402 @external
403 @nonreentrant('lock')
404 def deposit_for(_addr: address, _value: uint256):
405     """
406     @notice Deposit `_value` tokens for `_addr` and add to the lock
407     @dev Anyone (even a smart contract) can deposit for someone else, but
408          cannot extend their locktime and deposit for a brand new user
409     @param _addr User's wallet address
410     @param _value Amount to add to user's lock
411     """
412     _locked: LockedBalance = self.locked[_addr]
413 
414     assert _value > 0  # dev: need non-zero value
415 
416     # allow adding amount to an "empty" lock (_locked.amount == 0)
417     #assert _locked.amount > 0, "No existing lock found"
418 
419     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
420 
421     self._deposit_for(_addr, msg.sender, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
422 
423 
424 @external
425 @nonreentrant('lock')
426 def create_lock(_value: uint256, _unlock_time: uint256):
427     """
428     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
429     @param _value Amount to deposit
430     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
431     """
432     self.assert_not_contract(msg.sender)
433     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
434     _locked: LockedBalance = self.locked[msg.sender]
435 
436     # allow creating lock with no tokens. can later add amount
437     #assert _value > 0  # dev: need non-zero value
438     assert _locked.amount == 0, "Withdraw old tokens first"
439     assert unlock_time > block.timestamp, "Can only lock until time in the future"
440     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 2 years max"
441 
442     self._deposit_for(msg.sender, msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
443 
444 
445 @external
446 @nonreentrant('lock')
447 def increase_amount(_value: uint256):
448     """
449     @notice Deposit `_value` additional tokens for `msg.sender`
450             without modifying the unlock time
451     @param _value Amount of tokens to deposit and add to the lock
452     """
453     self.assert_not_contract(msg.sender)
454     _locked: LockedBalance = self.locked[msg.sender]
455 
456     assert _value > 0  # dev: need non-zero value
457     assert _locked.amount > 0, "No existing lock found"
458     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
459 
460     self._deposit_for(msg.sender, msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
461 
462 
463 @external
464 @nonreentrant('lock')
465 def increase_unlock_time(_unlock_time: uint256):
466     """
467     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
468     @param _unlock_time New epoch time for unlocking
469     """
470     self.assert_not_contract(msg.sender)
471     _locked: LockedBalance = self.locked[msg.sender]
472     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
473 
474     assert _locked.end > block.timestamp, "Lock expired"
475     #assert _locked.amount > 0, "Nothing is locked"
476     assert unlock_time > _locked.end, "Can only increase lock duration"
477     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 2 years max"
478 
479     self._deposit_for(msg.sender, msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
480 
481 
482 @external
483 @nonreentrant('lock')
484 def withdraw():
485     """
486     @notice Withdraw all tokens for `msg.sender`
487     @dev Only possible if the lock has expired
488     """
489     _locked: LockedBalance = self.locked[msg.sender]
490     assert block.timestamp >= _locked.end, "The lock didn't expire"
491     value: uint256 = convert(_locked.amount, uint256)
492 
493     old_locked: LockedBalance = _locked
494     _locked.end = 0
495     _locked.amount = 0
496     self.locked[msg.sender] = _locked
497     supply_before: uint256 = self.supply
498     self.supply = supply_before - value
499 
500     # old_locked can have either expired <= timestamp or zero end
501     # _locked has only 0 end
502     # Both can have >= 0 amount
503     self._checkpoint(msg.sender, old_locked, _locked)
504 
505     assert ERC20(self.token).transfer(msg.sender, value)
506 
507     log Withdraw(msg.sender, value, block.timestamp)
508     log Supply(supply_before, supply_before - value)
509 
510 
511 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
512 # They measure the weights for the purpose of voting, so they don't represent
513 # real coins.
514 
515 @internal
516 @view
517 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
518     """
519     @notice Binary search to estimate timestamp for block number
520     @param _block Block to find
521     @param max_epoch Don't go beyond this epoch
522     @return Approximate timestamp for block
523     """
524     # Binary search
525     _min: uint256 = 0
526     _max: uint256 = max_epoch
527     for i in range(128):  # Will be always enough for 128-bit numbers
528         if _min >= _max:
529             break
530         _mid: uint256 = (_min + _max + 1) / 2
531         if self.point_history[_mid].blk <= _block:
532             _min = _mid
533         else:
534             _max = _mid - 1
535     return _min
536 
537 
538 @external
539 @view
540 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
541     """
542     @notice Get the current voting power for `msg.sender`
543     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
544     @param addr User wallet address
545     @param _t Epoch time to return voting power at
546     @return User voting power
547     """
548     _epoch: uint256 = self.user_point_epoch[addr]
549     if _epoch == 0:
550         return 0
551     else:
552         last_point: Point = self.user_point_history[addr][_epoch]
553         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
554         if last_point.bias < 0:
555             last_point.bias = 0
556         return convert(last_point.bias, uint256)
557 
558 
559 @external
560 @view
561 def balanceOfAt(addr: address, _block: uint256) -> uint256:
562     """
563     @notice Measure voting power of `addr` at block height `_block`
564     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
565     @param addr User's wallet address
566     @param _block Block to calculate the voting power at
567     @return Voting power
568     """
569     # Copying and pasting totalSupply code because Vyper cannot pass by
570     # reference yet
571     assert _block <= block.number
572 
573     # Binary search
574     _min: uint256 = 0
575     _max: uint256 = self.user_point_epoch[addr]
576     for i in range(128):  # Will be always enough for 128-bit numbers
577         if _min >= _max:
578             break
579         _mid: uint256 = (_min + _max + 1) / 2
580         if self.user_point_history[addr][_mid].blk <= _block:
581             _min = _mid
582         else:
583             _max = _mid - 1
584 
585     upoint: Point = self.user_point_history[addr][_min]
586 
587     max_epoch: uint256 = self.epoch
588     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
589     point_0: Point = self.point_history[_epoch]
590     d_block: uint256 = 0
591     d_t: uint256 = 0
592     if _epoch < max_epoch:
593         point_1: Point = self.point_history[_epoch + 1]
594         d_block = point_1.blk - point_0.blk
595         d_t = point_1.ts - point_0.ts
596     else:
597         d_block = block.number - point_0.blk
598         d_t = block.timestamp - point_0.ts
599     block_time: uint256 = point_0.ts
600     if d_block != 0:
601         block_time += d_t * (_block - point_0.blk) / d_block
602 
603     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
604     if upoint.bias >= 0:
605         return convert(upoint.bias, uint256)
606     else:
607         return 0
608 
609 
610 @internal
611 @view
612 def supply_at(point: Point, t: uint256) -> uint256:
613     """
614     @notice Calculate total voting power at some point in the past
615     @param point The point (bias/slope) to start search from
616     @param t Time to calculate the total voting power at
617     @return Total voting power at that time
618     """
619     last_point: Point = point
620     t_i: uint256 = (last_point.ts / WEEK) * WEEK
621     for i in range(255):
622         t_i += WEEK
623         d_slope: int128 = 0
624         if t_i > t:
625             t_i = t
626         else:
627             d_slope = self.slope_changes[t_i]
628         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
629         if t_i == t:
630             break
631         last_point.slope += d_slope
632         last_point.ts = t_i
633 
634     if last_point.bias < 0:
635         last_point.bias = 0
636     return convert(last_point.bias, uint256)
637 
638 
639 @external
640 @view
641 def totalSupply(t: uint256 = block.timestamp) -> uint256:
642     """
643     @notice Calculate total voting power
644     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
645     @return Total voting power
646     """
647     _epoch: uint256 = self.epoch
648     last_point: Point = self.point_history[_epoch]
649     return self.supply_at(last_point, t)
650 
651 
652 @external
653 @view
654 def totalSupplyAt(_block: uint256) -> uint256:
655     """
656     @notice Calculate total voting power at some point in the past
657     @param _block Block to calculate the total voting power at
658     @return Total voting power at `_block`
659     """
660     assert _block <= block.number
661     _epoch: uint256 = self.epoch
662     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
663 
664     point: Point = self.point_history[target_epoch]
665     dt: uint256 = 0
666     if target_epoch < _epoch:
667         point_next: Point = self.point_history[target_epoch + 1]
668         if point.blk != point_next.blk:
669             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
670     else:
671         if point.blk != block.number:
672             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
673     # Now dt contains info on how far are we beyond point
674 
675     return self.supply_at(point, point.ts + dt)
676 
677 
678 # Dummy methods for compatibility with Aragon
679 
680 @external
681 def changeController(_newController: address):
682     """
683     @dev Dummy method required for Aragon compatibility
684     """
685     assert msg.sender == self.controller
686     self.controller = _newController