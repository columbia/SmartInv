1 # @version 0.3.1
2 """
3 @title Voting Escrow
4 @author Versailles heroes
5 @license MIT
6 @notice Votes have a weight depending on time.
7 @dev Vote weight decays linearly over time. Lock time cannot be
8      more than `MAXTIME` (4 years).
9 """
10 
11 struct Point:
12     bias: int128
13     slope: int128  # - dweight / dt
14     ts: uint256
15     blk: uint256  # block
16 # We cannot really do block numbers per se b/c slope is per time, not per block
17 # and per block could be fairly bad b/c Ethereum changes blocktimes.
18 # What we can do is to extrapolate ***At functions
19 
20 struct LockedBalance:
21     amount: int128
22     end: uint256
23 
24 
25 interface ERC20:
26     def decimals() -> uint256: view
27     def name() -> String[64]: view
28     def symbol() -> String[32]: view
29     def transfer(to: address, amount: uint256) -> bool: nonpayable
30     def transferFrom(spender: address, to: address, amount: uint256) -> bool: nonpayable
31 
32 
33 # Interface for checking whether address belongs to a whitelisted
34 # type of a smart wallet.
35 # When new types are added - the whole contract is changed
36 # The check() method is modifying to be able to use caching
37 # for individual wallet addresses
38 interface SmartWalletChecker:
39     def check(addr: address) -> bool: nonpayable
40 
41 DEPOSIT_FOR_TYPE: constant(int128) = 0
42 CREATE_LOCK_TYPE: constant(int128) = 1
43 INCREASE_LOCK_AMOUNT: constant(int128) = 2
44 INCREASE_UNLOCK_TIME: constant(int128) = 3
45 CREATE_LOCK_FOR_TYPE: constant(int128) = 4
46 
47 
48 event CommitOwnership:
49     admin: address
50 
51 event ApplyOwnership:
52     admin: address
53 
54 event Deposit:
55     from_addr: indexed(address)
56     provider: indexed(address)
57     value: uint256
58     locktime: indexed(uint256)
59     type: int128
60     ts: uint256
61 
62 event Withdraw:
63     provider: indexed(address)
64     value: uint256
65     ts: uint256
66 
67 event Supply:
68     prevSupply: uint256
69     supply: uint256
70 
71 
72 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
73 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
74 MINTIME: constant(uint256) = 365 * 86400  # 1 year
75 MULTIPLIER: constant(uint256) = 10 ** 18
76 
77 token: public(address)
78 supply: public(uint256)
79 
80 locked: public(HashMap[address, LockedBalance])
81 
82 epoch: public(uint256)
83 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
84 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
85 user_point_epoch: public(HashMap[address, uint256])
86 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
87 
88 # Aragon's view methods for compatibility
89 controller: public(address)
90 transfersEnabled: public(bool)
91 
92 name: public(String[64])
93 symbol: public(String[32])
94 version: public(String[32])
95 decimals: public(uint256)
96 
97 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
98 # The goal is to prevent tokenizing the escrow
99 future_smart_wallet_checker: public(address)
100 smart_wallet_checker: public(address)
101 
102 admin: public(address)  # Can and will be a smart contract
103 future_admin: public(address)
104 
105 
106 @external
107 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
108     """
109     @notice Contract constructor
110     @param token_addr `ERC20CRV` token address
111     @param _name Token name
112     @param _symbol Token symbol
113     @param _version Contract version - required for Aragon compatibility
114     """
115     self.admin = msg.sender
116     self.token = token_addr
117     self.point_history[0].blk = block.number
118     self.point_history[0].ts = block.timestamp
119     self.controller = msg.sender
120     self.transfersEnabled = True
121 
122     _decimals: uint256 = ERC20(token_addr).decimals()
123     assert _decimals <= 255
124     self.decimals = _decimals
125 
126     self.name = _name
127     self.symbol = _symbol
128     self.version = _version
129 
130 
131 @external
132 def commit_transfer_ownership(addr: address):
133     """
134     @notice Transfer ownership of VotingEscrow contract to `addr`
135     @param addr Address to have ownership transferred to
136     """
137     assert msg.sender == self.admin  # dev: admin only
138     self.future_admin = addr
139     log CommitOwnership(addr)
140 
141 
142 @external
143 def apply_transfer_ownership():
144     """
145     @notice Apply ownership transfer
146     """
147     assert msg.sender == self.admin  # dev: admin only
148     _admin: address = self.future_admin
149     assert _admin != ZERO_ADDRESS  # dev: admin not set
150     self.admin = _admin
151     log ApplyOwnership(_admin)
152 
153 
154 @external
155 def commit_smart_wallet_checker(addr: address):
156     """
157     @notice Set an external contract to check for approved smart contract wallets
158     @param addr Address of Smart contract checker
159     """
160     assert msg.sender == self.admin
161     self.future_smart_wallet_checker = addr
162 
163 
164 @external
165 def apply_smart_wallet_checker():
166     """
167     @notice Apply setting external contract to check approved smart contract wallets
168     """
169     assert msg.sender == self.admin
170     self.smart_wallet_checker = self.future_smart_wallet_checker
171 
172 
173 @internal
174 def assert_not_contract(addr: address):
175     """
176     @notice Check if the call is from a whitelisted smart contract, revert if not
177     @param addr Address to be checked
178     """
179     if addr != tx.origin:
180         checker: address = self.smart_wallet_checker
181         if checker != ZERO_ADDRESS:
182             if SmartWalletChecker(checker).check(addr):
183                 return
184         raise "Smart contract depositors not allowed"
185 
186 
187 @external
188 @view
189 def get_last_user_slope(addr: address) -> int128:
190     """
191     @notice Get the most recently recorded rate of voting power decrease for `addr`
192     @param addr Address of the user wallet
193     @return Value of the slope
194     """
195     uepoch: uint256 = self.user_point_epoch[addr]
196     return self.user_point_history[addr][uepoch].slope
197 
198 
199 @external
200 @view
201 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
202     """
203     @notice Get the timestamp for checkpoint `_idx` for `_addr`
204     @param _addr User wallet address
205     @param _idx User epoch number
206     @return Epoch time of the checkpoint
207     """
208     return self.user_point_history[_addr][_idx].ts
209 
210 
211 @external
212 @view
213 def locked__end(_addr: address) -> uint256:
214     """
215     @notice Get timestamp when `_addr`'s lock finishes
216     @param _addr User wallet
217     @return Epoch time of the lock end
218     """
219     return self.locked[_addr].end
220 
221 
222 @internal
223 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
224     """
225     @notice Record global and per-user data to checkpoint
226     @param addr User's wallet address. No user checkpoint if 0x0
227     @param old_locked Pevious locked amount / end lock time for the user
228     @param new_locked New locked amount / end lock time for the user
229     """
230     u_old: Point = empty(Point)
231     u_new: Point = empty(Point)
232     old_dslope: int128 = 0
233     new_dslope: int128 = 0
234     _epoch: uint256 = self.epoch
235 
236     if addr != ZERO_ADDRESS:
237         # Calculate slopes and biases
238         # Kept at zero when they have to
239         if old_locked.end > block.timestamp and old_locked.amount > 0:
240             u_old.slope = old_locked.amount / MAXTIME
241             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
242         if new_locked.end > block.timestamp and new_locked.amount > 0:
243             u_new.slope = new_locked.amount / MAXTIME
244             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
245 
246         # Read values of scheduled changes in the slope
247         # old_locked.end can be in the past and in the future
248         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
249         old_dslope = self.slope_changes[old_locked.end]
250         if new_locked.end != 0:
251             if new_locked.end == old_locked.end:
252                 new_dslope = old_dslope
253             else:
254                 new_dslope = self.slope_changes[new_locked.end]
255 
256     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
257     if _epoch > 0:
258         last_point = self.point_history[_epoch]
259     last_checkpoint: uint256 = last_point.ts
260     # initial_last_point is used for extrapolation to calculate block number
261     # (approximately, for *At methods) and save them
262     # as we cannot figure that out exactly from inside the contract
263     initial_last_point: Point = last_point
264     block_slope: uint256 = 0  # dblock/dt
265     if block.timestamp > last_point.ts:
266         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
267     # If last point is already recorded in this block, slope=0
268     # But that's ok b/c we know the block in such case
269 
270     # Go over weeks to fill history and calculate what the current point is
271     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
272     for i in range(255):
273         # Hopefully it won't happen that this won't get used in 5 years!
274         # If it does, users will be able to withdraw but vote weight will be broken
275         t_i += WEEK
276         d_slope: int128 = 0
277         if t_i > block.timestamp:
278             t_i = block.timestamp
279         else:
280             d_slope = self.slope_changes[t_i]
281         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
282         last_point.slope += d_slope
283         if last_point.bias < 0:  # This can happen
284             last_point.bias = 0
285         if last_point.slope < 0:  # This cannot happen - just in case
286             last_point.slope = 0
287         last_checkpoint = t_i
288         last_point.ts = t_i
289         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
290         _epoch += 1
291         if t_i == block.timestamp:
292             last_point.blk = block.number
293             break
294         else:
295             self.point_history[_epoch] = last_point
296 
297     self.epoch = _epoch
298     # Now point_history is filled until t=now
299 
300     if addr != ZERO_ADDRESS:
301         # If last point was in this block, the slope change has been applied already
302         # But in such case we have 0 slope(s)
303         last_point.slope += (u_new.slope - u_old.slope)
304         last_point.bias += (u_new.bias - u_old.bias)
305         if last_point.slope < 0:
306             last_point.slope = 0
307         if last_point.bias < 0:
308             last_point.bias = 0
309 
310     # Record the changed point into history
311     self.point_history[_epoch] = last_point
312 
313     if addr != ZERO_ADDRESS:
314         # Schedule the slope changes (slope is going down)
315         # We subtract new_user_slope from [new_locked.end]
316         # and add old_user_slope to [old_locked.end]
317         if old_locked.end > block.timestamp:
318             # old_dslope was <something> - u_old.slope, so we cancel that
319             old_dslope += u_old.slope
320             if new_locked.end == old_locked.end:
321                 old_dslope -= u_new.slope  # It was a new deposit, not extension
322             self.slope_changes[old_locked.end] = old_dslope
323 
324         if new_locked.end > block.timestamp:
325             if new_locked.end > old_locked.end:
326                 new_dslope -= u_new.slope  # old slope disappeared at this point
327                 self.slope_changes[new_locked.end] = new_dslope
328             # else: we recorded it already in old_dslope
329 
330         # Now handle user history
331         user_epoch: uint256 = self.user_point_epoch[addr] + 1
332 
333         self.user_point_epoch[addr] = user_epoch
334         u_new.ts = block.timestamp
335         u_new.blk = block.number
336         self.user_point_history[addr][user_epoch] = u_new
337 
338 
339 @internal
340 def _deposit_for(_addr: address, _from: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
341     """
342     @notice Deposit and lock tokens for a user
343     @param _addr User's wallet address
344     @param _value Amount to deposit
345     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
346     @param locked_balance Previous locked amount / timestamp
347     """
348     _locked: LockedBalance = locked_balance
349     supply_before: uint256 = self.supply
350 
351     self.supply = supply_before + _value
352     old_locked: LockedBalance = _locked
353     # Adding to existing lock, or if a lock is expired - creating a new one
354     _locked.amount += convert(_value, int128)
355     if unlock_time != 0:
356         _locked.end = unlock_time
357     self.locked[_addr] = _locked
358 
359     # Possibilities:
360     # Both old_locked.end could be current or expired (>/< block.timestamp)
361     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
362     # _locked.end > block.timestamp (always)
363     self._checkpoint(_addr, old_locked, _locked)
364 
365     if _value != 0:
366         assert ERC20(self.token).transferFrom(_from, self, _value)
367 
368     log Deposit(_from, _addr, _value, _locked.end, type, block.timestamp)
369     log Supply(supply_before, supply_before + _value)
370 
371 
372 @external
373 def checkpoint():
374     """
375     @notice Record global data to checkpoint
376     """
377     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
378 
379 
380 @external
381 @nonreentrant('lock')
382 def deposit_for(_addr: address, _value: uint256):
383     """
384     @notice Deposit `_value` tokens for `_addr` and add to the lock
385     @dev Anyone (even a smart contract) can deposit for someone else, but
386          cannot extend their locktime and deposit for a brand new user
387     @param _addr User's wallet address
388     @param _value Amount to add to user's lock
389     """
390     _locked: LockedBalance = self.locked[_addr]
391 
392     assert _value > 0  # dev: need non-zero value
393     assert _locked.amount > 0, "No existing lock found"
394     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
395 
396     self._deposit_for(_addr, msg.sender, _value, 0, _locked, DEPOSIT_FOR_TYPE)
397 
398 
399 @external
400 @nonreentrant('lock')
401 def create_lock(_value: uint256, _unlock_time: uint256):
402     """
403     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
404     @param _value Amount to deposit
405     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
406     """
407     self.assert_not_contract(msg.sender)
408     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
409     _locked: LockedBalance = self.locked[msg.sender]
410 
411     assert _value > 0  # dev: need non-zero value
412     assert _locked.amount == 0, "Withdraw old tokens first"
413     assert unlock_time > block.timestamp, "Can only lock until time in the future"
414     assert unlock_time + WEEK >= block.timestamp + MINTIME, "Voting lock must be 1 year min"
415     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
416 
417     self._deposit_for(msg.sender, msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
418 
419 
420 @external
421 @nonreentrant('lock')
422 def create_lock_for(_for: address, _value: uint256, _unlock_time: uint256):
423     """
424     @notice Deposit `_value` tokens for `_for` and lock until `_unlock_time`
425     @param _value Amount to deposit
426     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
427     """
428     self.assert_not_contract(msg.sender)
429     assert _for.is_contract == False, "Can not create lock for contract"
430     assert _for != msg.sender # dev: use create lock
431     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
432     _locked: LockedBalance = self.locked[_for]
433 
434     assert _value > 0  # dev: need non-zero value
435     assert _locked.amount == 0, "Withdraw old tokens first"
436     assert unlock_time > block.timestamp, "Can only lock until time in the future"
437     assert unlock_time + WEEK >= block.timestamp + MINTIME, "Voting lock must be 1 year min"
438     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
439 
440     self._deposit_for(_for, msg.sender, _value, unlock_time, _locked, CREATE_LOCK_FOR_TYPE)
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
458     self._deposit_for(msg.sender, msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
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
477     self._deposit_for(msg.sender, msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
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