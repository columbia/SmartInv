1 # @version 0.2.7
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
46 interface IIdle:
47     def delegate(delegatee: address): nonpayable
48 
49 # Interface for checking whether address belongs to a whitelisted
50 # type of a smart wallet.
51 # When new types are added - the whole contract is changed
52 # The check() method is modifying to be able to use caching
53 # for individual wallet addresses
54 interface SmartWalletChecker:
55     def check(addr: address) -> bool: nonpayable
56 
57 DEPOSIT_FOR_TYPE: constant(int128) = 0
58 CREATE_LOCK_TYPE: constant(int128) = 1
59 INCREASE_LOCK_AMOUNT: constant(int128) = 2
60 INCREASE_UNLOCK_TIME: constant(int128) = 3
61 
62 
63 event CommitOwnership:
64     admin: address
65 
66 event ApplyOwnership:
67     admin: address
68 
69 event Deposit:
70     provider: indexed(address)
71     value: uint256
72     locktime: indexed(uint256)
73     type: int128
74     ts: uint256
75 
76 event Withdraw:
77     provider: indexed(address)
78     value: uint256
79     ts: uint256
80 
81 event Supply:
82     prevSupply: uint256
83     supply: uint256
84 
85 
86 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
87 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
88 MULTIPLIER: constant(uint256) = 10 ** 18
89 
90 token: public(address)
91 supply: public(uint256)
92 
93 locked: public(HashMap[address, LockedBalance])
94 
95 epoch: public(uint256)
96 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
97 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
98 user_point_epoch: public(HashMap[address, uint256])
99 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
100 
101 # Aragon's view methods for compatibility
102 controller: public(address)
103 transfersEnabled: public(bool)
104 
105 name: public(String[64])
106 symbol: public(String[32])
107 version: public(String[32])
108 decimals: public(uint256)
109 
110 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
111 # The goal is to prevent tokenizing the escrow
112 future_smart_wallet_checker: public(address)
113 smart_wallet_checker: public(address)
114 
115 admin: public(address)  # Can and will be a smart contract
116 future_admin: public(address)
117 
118 vote_delegatee: public(address) # address of idle delegated votes
119 
120 @external
121 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32], _vote_delegate: address):
122     """
123     @notice Contract constructor
124     @param token_addr `ERC20CRV` token address
125     @param _name Token name
126     @param _symbol Token symbol
127     @param _version Contract version - required for Aragon compatibility
128     """
129     self.admin = msg.sender
130     self.token = token_addr
131     self.point_history[0].blk = block.number
132     self.point_history[0].ts = block.timestamp
133     self.controller = msg.sender
134     self.transfersEnabled = True
135 
136     _decimals: uint256 = ERC20(token_addr).decimals()
137     assert _decimals <= 255
138     self.decimals = _decimals
139 
140     self.name = _name
141     self.symbol = _symbol
142     self.version = _version
143 
144     # Delegate governance votes to address
145     self.vote_delegatee = _vote_delegate
146     IIdle(token_addr).delegate(_vote_delegate)
147 
148 @external
149 def update_delegate(_new_delegatee: address):
150     assert msg.sender == self.admin  # dev: admin only
151     self.vote_delegatee = _new_delegatee
152 
153     IIdle(self.token).delegate(_new_delegatee)
154 
155 @external
156 def commit_transfer_ownership(addr: address):
157     """
158     @notice Transfer ownership of VotingEscrow contract to `addr`
159     @param addr Address to have ownership transferred to
160     """
161     assert msg.sender == self.admin  # dev: admin only
162     self.future_admin = addr
163     log CommitOwnership(addr)
164 
165 
166 @external
167 def apply_transfer_ownership():
168     """
169     @notice Apply ownership transfer
170     """
171     assert msg.sender == self.admin  # dev: admin only
172     _admin: address = self.future_admin
173     assert _admin != ZERO_ADDRESS  # dev: admin not set
174     self.admin = _admin
175     log ApplyOwnership(_admin)
176 
177 
178 @external
179 def commit_smart_wallet_checker(addr: address):
180     """
181     @notice Set an external contract to check for approved smart contract wallets
182     @param addr Address of Smart contract checker
183     """
184     assert msg.sender == self.admin
185     self.future_smart_wallet_checker = addr
186 
187 
188 @external
189 def apply_smart_wallet_checker():
190     """
191     @notice Apply setting external contract to check approved smart contract wallets
192     """
193     assert msg.sender == self.admin
194     self.smart_wallet_checker = self.future_smart_wallet_checker
195 
196 
197 @internal
198 def assert_not_contract(addr: address):
199     """
200     @notice Check if the call is from a whitelisted smart contract, revert if not
201     @param addr Address to be checked
202     """
203     if addr != tx.origin:
204         checker: address = self.smart_wallet_checker
205         if checker != ZERO_ADDRESS:
206             if SmartWalletChecker(checker).check(addr):
207                 return
208         raise "Smart contract depositors not allowed"
209 
210 
211 @external
212 @view
213 def get_last_user_slope(addr: address) -> int128:
214     """
215     @notice Get the most recently recorded rate of voting power decrease for `addr`
216     @param addr Address of the user wallet
217     @return Value of the slope
218     """
219     uepoch: uint256 = self.user_point_epoch[addr]
220     return self.user_point_history[addr][uepoch].slope
221 
222 
223 @external
224 @view
225 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
226     """
227     @notice Get the timestamp for checkpoint `_idx` for `_addr`
228     @param _addr User wallet address
229     @param _idx User epoch number
230     @return Epoch time of the checkpoint
231     """
232     return self.user_point_history[_addr][_idx].ts
233 
234 
235 @external
236 @view
237 def locked__end(_addr: address) -> uint256:
238     """
239     @notice Get timestamp when `_addr`'s lock finishes
240     @param _addr User wallet
241     @return Epoch time of the lock end
242     """
243     return self.locked[_addr].end
244 
245 
246 @internal
247 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
248     """
249     @notice Record global and per-user data to checkpoint
250     @param addr User's wallet address. No user checkpoint if 0x0
251     @param old_locked Pevious locked amount / end lock time for the user
252     @param new_locked New locked amount / end lock time for the user
253     """
254     u_old: Point = empty(Point)
255     u_new: Point = empty(Point)
256     old_dslope: int128 = 0
257     new_dslope: int128 = 0
258     _epoch: uint256 = self.epoch
259 
260     if addr != ZERO_ADDRESS:
261         # Calculate slopes and biases
262         # Kept at zero when they have to
263         if old_locked.end > block.timestamp and old_locked.amount > 0:
264             u_old.slope = old_locked.amount / MAXTIME
265             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
266         if new_locked.end > block.timestamp and new_locked.amount > 0:
267             u_new.slope = new_locked.amount / MAXTIME
268             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
269 
270         # Read values of scheduled changes in the slope
271         # old_locked.end can be in the past and in the future
272         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
273         old_dslope = self.slope_changes[old_locked.end]
274         if new_locked.end != 0:
275             if new_locked.end == old_locked.end:
276                 new_dslope = old_dslope
277             else:
278                 new_dslope = self.slope_changes[new_locked.end]
279 
280     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
281     if _epoch > 0:
282         last_point = self.point_history[_epoch]
283     last_checkpoint: uint256 = last_point.ts
284     # initial_last_point is used for extrapolation to calculate block number
285     # (approximately, for *At methods) and save them
286     # as we cannot figure that out exactly from inside the contract
287     initial_last_point: Point = last_point
288     block_slope: uint256 = 0  # dblock/dt
289     if block.timestamp > last_point.ts:
290         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
291     # If last point is already recorded in this block, slope=0
292     # But that's ok b/c we know the block in such case
293 
294     # Go over weeks to fill history and calculate what the current point is
295     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
296     for i in range(255):
297         # Hopefully it won't happen that this won't get used in 5 years!
298         # If it does, users will be able to withdraw but vote weight will be broken
299         t_i += WEEK
300         d_slope: int128 = 0
301         if t_i > block.timestamp:
302             t_i = block.timestamp
303         else:
304             d_slope = self.slope_changes[t_i]
305         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
306         last_point.slope += d_slope
307         if last_point.bias < 0:  # This can happen
308             last_point.bias = 0
309         if last_point.slope < 0:  # This cannot happen - just in case
310             last_point.slope = 0
311         last_checkpoint = t_i
312         last_point.ts = t_i
313         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
314         _epoch += 1
315         if t_i == block.timestamp:
316             last_point.blk = block.number
317             break
318         else:
319             self.point_history[_epoch] = last_point
320 
321     self.epoch = _epoch
322     # Now point_history is filled until t=now
323 
324     if addr != ZERO_ADDRESS:
325         # If last point was in this block, the slope change has been applied already
326         # But in such case we have 0 slope(s)
327         last_point.slope += (u_new.slope - u_old.slope)
328         last_point.bias += (u_new.bias - u_old.bias)
329         if last_point.slope < 0:
330             last_point.slope = 0
331         if last_point.bias < 0:
332             last_point.bias = 0
333 
334     # Record the changed point into history
335     self.point_history[_epoch] = last_point
336 
337     if addr != ZERO_ADDRESS:
338         # Schedule the slope changes (slope is going down)
339         # We subtract new_user_slope from [new_locked.end]
340         # and add old_user_slope to [old_locked.end]
341         if old_locked.end > block.timestamp:
342             # old_dslope was <something> - u_old.slope, so we cancel that
343             old_dslope += u_old.slope
344             if new_locked.end == old_locked.end:
345                 old_dslope -= u_new.slope  # It was a new deposit, not extension
346             self.slope_changes[old_locked.end] = old_dslope
347 
348         if new_locked.end > block.timestamp:
349             if new_locked.end > old_locked.end:
350                 new_dslope -= u_new.slope  # old slope disappeared at this point
351                 self.slope_changes[new_locked.end] = new_dslope
352             # else: we recorded it already in old_dslope
353 
354         # Now handle user history
355         user_epoch: uint256 = self.user_point_epoch[addr] + 1
356 
357         self.user_point_epoch[addr] = user_epoch
358         u_new.ts = block.timestamp
359         u_new.blk = block.number
360         self.user_point_history[addr][user_epoch] = u_new
361 
362 
363 @internal
364 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
365     """
366     @notice Deposit and lock tokens for a user
367     @param _addr User's wallet address
368     @param _value Amount to deposit
369     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
370     @param locked_balance Previous locked amount / timestamp
371     """
372     _locked: LockedBalance = locked_balance
373     supply_before: uint256 = self.supply
374 
375     self.supply = supply_before + _value
376     old_locked: LockedBalance = _locked
377     # Adding to existing lock, or if a lock is expired - creating a new one
378     _locked.amount += convert(_value, int128)
379     if unlock_time != 0:
380         _locked.end = unlock_time
381     self.locked[_addr] = _locked
382 
383     # Possibilities:
384     # Both old_locked.end could be current or expired (>/< block.timestamp)
385     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
386     # _locked.end > block.timestamp (always)
387     self._checkpoint(_addr, old_locked, _locked)
388 
389     if _value != 0:
390         assert ERC20(self.token).transferFrom(_addr, self, _value)
391 
392     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
393     log Supply(supply_before, supply_before + _value)
394 
395 
396 @external
397 def checkpoint():
398     """
399     @notice Record global data to checkpoint
400     """
401     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
402 
403 
404 @external
405 @nonreentrant('lock')
406 def deposit_for(_addr: address, _value: uint256):
407     """
408     @notice Deposit `_value` tokens for `_addr` and add to the lock
409     @dev Anyone (even a smart contract) can deposit for someone else, but
410          cannot extend their locktime and deposit for a brand new user
411     @param _addr User's wallet address
412     @param _value Amount to add to user's lock
413     """
414     _locked: LockedBalance = self.locked[_addr]
415 
416     assert _value > 0  # dev: need non-zero value
417     assert _locked.amount > 0, "No existing lock found"
418     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
419 
420     self._deposit_for(_addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
421 
422 
423 @external
424 @nonreentrant('lock')
425 def create_lock(_value: uint256, _unlock_time: uint256):
426     """
427     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
428     @param _value Amount to deposit
429     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
430     """
431     self.assert_not_contract(msg.sender)
432     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
433     _locked: LockedBalance = self.locked[msg.sender]
434 
435     assert _value > 0  # dev: need non-zero value
436     assert _locked.amount == 0, "Withdraw old tokens first"
437     assert unlock_time > block.timestamp, "Can only lock until time in the future"
438     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
439 
440     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
441 
442 
443 @external
444 @nonreentrant('lock')
445 def increase_amount(_value: uint256):
446     """
447     @notice Deposit `_value` additional tokens for `msg.sender`
448             without modifying the unlock time
449     @param _value Amount of tokens to deposit and add to the lock
450     """
451     self.assert_not_contract(msg.sender)
452     _locked: LockedBalance = self.locked[msg.sender]
453 
454     assert _value > 0  # dev: need non-zero value
455     assert _locked.amount > 0, "No existing lock found"
456     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
457 
458     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
459 
460 
461 @external
462 @nonreentrant('lock')
463 def increase_unlock_time(_unlock_time: uint256):
464     """
465     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
466     @param _unlock_time New epoch time for unlocking
467     """
468     self.assert_not_contract(msg.sender)
469     _locked: LockedBalance = self.locked[msg.sender]
470     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
471 
472     assert _locked.end > block.timestamp, "Lock expired"
473     assert _locked.amount > 0, "Nothing is locked"
474     assert unlock_time > _locked.end, "Can only increase lock duration"
475     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
476 
477     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
478 
479 
480 @external
481 @nonreentrant('lock')
482 def withdraw():
483     """
484     @notice Withdraw all tokens for `msg.sender`
485     @dev Only possible if the lock has expired
486     """
487     _locked: LockedBalance = self.locked[msg.sender]
488     assert block.timestamp >= _locked.end, "The lock didn't expire"
489     value: uint256 = convert(_locked.amount, uint256)
490 
491     old_locked: LockedBalance = _locked
492     _locked.end = 0
493     _locked.amount = 0
494     self.locked[msg.sender] = _locked
495     supply_before: uint256 = self.supply
496     self.supply = supply_before - value
497 
498     # old_locked can have either expired <= timestamp or zero end
499     # _locked has only 0 end
500     # Both can have >= 0 amount
501     self._checkpoint(msg.sender, old_locked, _locked)
502 
503     assert ERC20(self.token).transfer(msg.sender, value)
504 
505     log Withdraw(msg.sender, value, block.timestamp)
506     log Supply(supply_before, supply_before - value)
507 
508 
509 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
510 # They measure the weights for the purpose of voting, so they don't represent
511 # real coins.
512 
513 @internal
514 @view
515 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
516     """
517     @notice Binary search to estimate timestamp for block number
518     @param _block Block to find
519     @param max_epoch Don't go beyond this epoch
520     @return Approximate timestamp for block
521     """
522     # Binary search
523     _min: uint256 = 0
524     _max: uint256 = max_epoch
525     for i in range(128):  # Will be always enough for 128-bit numbers
526         if _min >= _max:
527             break
528         _mid: uint256 = (_min + _max + 1) / 2
529         if self.point_history[_mid].blk <= _block:
530             _min = _mid
531         else:
532             _max = _mid - 1
533     return _min
534 
535 
536 @external
537 @view
538 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
539     """
540     @notice Get the current voting power for `msg.sender`
541     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
542     @param addr User wallet address
543     @param _t Epoch time to return voting power at
544     @return User voting power
545     """
546     _epoch: uint256 = self.user_point_epoch[addr]
547     if _epoch == 0:
548         return 0
549     else:
550         last_point: Point = self.user_point_history[addr][_epoch]
551         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
552         if last_point.bias < 0:
553             last_point.bias = 0
554         return convert(last_point.bias, uint256)
555 
556 
557 @external
558 @view
559 def balanceOfAt(addr: address, _block: uint256) -> uint256:
560     """
561     @notice Measure voting power of `addr` at block height `_block`
562     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
563     @param addr User's wallet address
564     @param _block Block to calculate the voting power at
565     @return Voting power
566     """
567     # Copying and pasting totalSupply code because Vyper cannot pass by
568     # reference yet
569     assert _block <= block.number
570 
571     # Binary search
572     _min: uint256 = 0
573     _max: uint256 = self.user_point_epoch[addr]
574     for i in range(128):  # Will be always enough for 128-bit numbers
575         if _min >= _max:
576             break
577         _mid: uint256 = (_min + _max + 1) / 2
578         if self.user_point_history[addr][_mid].blk <= _block:
579             _min = _mid
580         else:
581             _max = _mid - 1
582 
583     upoint: Point = self.user_point_history[addr][_min]
584 
585     max_epoch: uint256 = self.epoch
586     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
587     point_0: Point = self.point_history[_epoch]
588     d_block: uint256 = 0
589     d_t: uint256 = 0
590     if _epoch < max_epoch:
591         point_1: Point = self.point_history[_epoch + 1]
592         d_block = point_1.blk - point_0.blk
593         d_t = point_1.ts - point_0.ts
594     else:
595         d_block = block.number - point_0.blk
596         d_t = block.timestamp - point_0.ts
597     block_time: uint256 = point_0.ts
598     if d_block != 0:
599         block_time += d_t * (_block - point_0.blk) / d_block
600 
601     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
602     if upoint.bias >= 0:
603         return convert(upoint.bias, uint256)
604     else:
605         return 0
606 
607 
608 @internal
609 @view
610 def supply_at(point: Point, t: uint256) -> uint256:
611     """
612     @notice Calculate total voting power at some point in the past
613     @param point The point (bias/slope) to start search from
614     @param t Time to calculate the total voting power at
615     @return Total voting power at that time
616     """
617     last_point: Point = point
618     t_i: uint256 = (last_point.ts / WEEK) * WEEK
619     for i in range(255):
620         t_i += WEEK
621         d_slope: int128 = 0
622         if t_i > t:
623             t_i = t
624         else:
625             d_slope = self.slope_changes[t_i]
626         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
627         if t_i == t:
628             break
629         last_point.slope += d_slope
630         last_point.ts = t_i
631 
632     if last_point.bias < 0:
633         last_point.bias = 0
634     return convert(last_point.bias, uint256)
635 
636 
637 @external
638 @view
639 def totalSupply(t: uint256 = block.timestamp) -> uint256:
640     """
641     @notice Calculate total voting power
642     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
643     @return Total voting power
644     """
645     _epoch: uint256 = self.epoch
646     last_point: Point = self.point_history[_epoch]
647     return self.supply_at(last_point, t)
648 
649 
650 @external
651 @view
652 def totalSupplyAt(_block: uint256) -> uint256:
653     """
654     @notice Calculate total voting power at some point in the past
655     @param _block Block to calculate the total voting power at
656     @return Total voting power at `_block`
657     """
658     assert _block <= block.number
659     _epoch: uint256 = self.epoch
660     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
661 
662     point: Point = self.point_history[target_epoch]
663     dt: uint256 = 0
664     if target_epoch < _epoch:
665         point_next: Point = self.point_history[target_epoch + 1]
666         if point.blk != point_next.blk:
667             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
668     else:
669         if point.blk != block.number:
670             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
671     # Now dt contains info on how far are we beyond point
672 
673     return self.supply_at(point, point.ts + dt)
674 
675 
676 # Dummy methods for compatibility with Aragon
677 
678 @external
679 def changeController(_newController: address):
680     """
681     @dev Dummy method required for Aragon compatibility
682     """
683     assert msg.sender == self.controller
684     self.controller = _newController