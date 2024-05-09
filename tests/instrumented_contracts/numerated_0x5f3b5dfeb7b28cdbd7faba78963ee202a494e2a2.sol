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
85 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
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
121     @param token_addr `ERC20CRV` token address
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
232 
233 @internal
234 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
235     """
236     @notice Record global and per-user data to checkpoint
237     @param addr User's wallet address. No user checkpoint if 0x0
238     @param old_locked Pevious locked amount / end lock time for the user
239     @param new_locked New locked amount / end lock time for the user
240     """
241     u_old: Point = empty(Point)
242     u_new: Point = empty(Point)
243     old_dslope: int128 = 0
244     new_dslope: int128 = 0
245     _epoch: uint256 = self.epoch
246 
247     if addr != ZERO_ADDRESS:
248         # Calculate slopes and biases
249         # Kept at zero when they have to
250         if old_locked.end > block.timestamp and old_locked.amount > 0:
251             u_old.slope = old_locked.amount / MAXTIME
252             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
253         if new_locked.end > block.timestamp and new_locked.amount > 0:
254             u_new.slope = new_locked.amount / MAXTIME
255             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
256 
257         # Read values of scheduled changes in the slope
258         # old_locked.end can be in the past and in the future
259         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
260         old_dslope = self.slope_changes[old_locked.end]
261         if new_locked.end != 0:
262             if new_locked.end == old_locked.end:
263                 new_dslope = old_dslope
264             else:
265                 new_dslope = self.slope_changes[new_locked.end]
266 
267     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
268     if _epoch > 0:
269         last_point = self.point_history[_epoch]
270     last_checkpoint: uint256 = last_point.ts
271     # initial_last_point is used for extrapolation to calculate block number
272     # (approximately, for *At methods) and save them
273     # as we cannot figure that out exactly from inside the contract
274     initial_last_point: Point = last_point
275     block_slope: uint256 = 0  # dblock/dt
276     if block.timestamp > last_point.ts:
277         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
278     # If last point is already recorded in this block, slope=0
279     # But that's ok b/c we know the block in such case
280 
281     # Go over weeks to fill history and calculate what the current point is
282     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
283     for i in range(255):
284         # Hopefully it won't happen that this won't get used in 5 years!
285         # If it does, users will be able to withdraw but vote weight will be broken
286         t_i += WEEK
287         d_slope: int128 = 0
288         if t_i > block.timestamp:
289             t_i = block.timestamp
290         else:
291             d_slope = self.slope_changes[t_i]
292         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
293         last_point.slope += d_slope
294         if last_point.bias < 0:  # This can happen
295             last_point.bias = 0
296         if last_point.slope < 0:  # This cannot happen - just in case
297             last_point.slope = 0
298         last_checkpoint = t_i
299         last_point.ts = t_i
300         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
301         _epoch += 1
302         if t_i == block.timestamp:
303             last_point.blk = block.number
304             break
305         else:
306             self.point_history[_epoch] = last_point
307 
308     self.epoch = _epoch
309     # Now point_history is filled until t=now
310 
311     if addr != ZERO_ADDRESS:
312         # If last point was in this block, the slope change has been applied already
313         # But in such case we have 0 slope(s)
314         last_point.slope += (u_new.slope - u_old.slope)
315         last_point.bias += (u_new.bias - u_old.bias)
316         if last_point.slope < 0:
317             last_point.slope = 0
318         if last_point.bias < 0:
319             last_point.bias = 0
320 
321     # Record the changed point into history
322     self.point_history[_epoch] = last_point
323 
324     if addr != ZERO_ADDRESS:
325         # Schedule the slope changes (slope is going down)
326         # We subtract new_user_slope from [new_locked.end]
327         # and add old_user_slope to [old_locked.end]
328         if old_locked.end > block.timestamp:
329             # old_dslope was <something> - u_old.slope, so we cancel that
330             old_dslope += u_old.slope
331             if new_locked.end == old_locked.end:
332                 old_dslope -= u_new.slope  # It was a new deposit, not extension
333             self.slope_changes[old_locked.end] = old_dslope
334 
335         if new_locked.end > block.timestamp:
336             if new_locked.end > old_locked.end:
337                 new_dslope -= u_new.slope  # old slope disappeared at this point
338                 self.slope_changes[new_locked.end] = new_dslope
339             # else: we recorded it already in old_dslope
340 
341         # Now handle user history
342         user_epoch: uint256 = self.user_point_epoch[addr] + 1
343 
344         self.user_point_epoch[addr] = user_epoch
345         u_new.ts = block.timestamp
346         u_new.blk = block.number
347         self.user_point_history[addr][user_epoch] = u_new
348 
349 
350 @internal
351 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
352     """
353     @notice Deposit and lock tokens for a user
354     @param _addr User's wallet address
355     @param _value Amount to deposit
356     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
357     @param locked_balance Previous locked amount / timestamp
358     """
359     _locked: LockedBalance = locked_balance
360     supply_before: uint256 = self.supply
361 
362     self.supply = supply_before + _value
363     old_locked: LockedBalance = _locked
364     # Adding to existing lock, or if a lock is expired - creating a new one
365     _locked.amount += convert(_value, int128)
366     if unlock_time != 0:
367         _locked.end = unlock_time
368     self.locked[_addr] = _locked
369 
370     # Possibilities:
371     # Both old_locked.end could be current or expired (>/< block.timestamp)
372     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
373     # _locked.end > block.timestamp (always)
374     self._checkpoint(_addr, old_locked, _locked)
375 
376     if _value != 0:
377         assert ERC20(self.token).transferFrom(_addr, self, _value)
378 
379     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
380     log Supply(supply_before, supply_before + _value)
381 
382 
383 @external
384 def checkpoint():
385     """
386     @notice Record global data to checkpoint
387     """
388     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
389 
390 
391 @external
392 @nonreentrant('lock')
393 def deposit_for(_addr: address, _value: uint256):
394     """
395     @notice Deposit `_value` tokens for `_addr` and add to the lock
396     @dev Anyone (even a smart contract) can deposit for someone else, but
397          cannot extend their locktime and deposit for a brand new user
398     @param _addr User's wallet address
399     @param _value Amount to add to user's lock
400     """
401     _locked: LockedBalance = self.locked[_addr]
402 
403     assert _value > 0  # dev: need non-zero value
404     assert _locked.amount > 0, "No existing lock found"
405     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
406 
407     self._deposit_for(_addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
408 
409 
410 @external
411 @nonreentrant('lock')
412 def create_lock(_value: uint256, _unlock_time: uint256):
413     """
414     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
415     @param _value Amount to deposit
416     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
417     """
418     self.assert_not_contract(msg.sender)
419     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
420     _locked: LockedBalance = self.locked[msg.sender]
421 
422     assert _value > 0  # dev: need non-zero value
423     assert _locked.amount == 0, "Withdraw old tokens first"
424     assert unlock_time > block.timestamp, "Can only lock until time in the future"
425     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
426 
427     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
428 
429 
430 @external
431 @nonreentrant('lock')
432 def increase_amount(_value: uint256):
433     """
434     @notice Deposit `_value` additional tokens for `msg.sender`
435             without modifying the unlock time
436     @param _value Amount of tokens to deposit and add to the lock
437     """
438     self.assert_not_contract(msg.sender)
439     _locked: LockedBalance = self.locked[msg.sender]
440 
441     assert _value > 0  # dev: need non-zero value
442     assert _locked.amount > 0, "No existing lock found"
443     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
444 
445     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
446 
447 
448 @external
449 @nonreentrant('lock')
450 def increase_unlock_time(_unlock_time: uint256):
451     """
452     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
453     @param _unlock_time New epoch time for unlocking
454     """
455     self.assert_not_contract(msg.sender)
456     _locked: LockedBalance = self.locked[msg.sender]
457     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
458 
459     assert _locked.end > block.timestamp, "Lock expired"
460     assert _locked.amount > 0, "Nothing is locked"
461     assert unlock_time > _locked.end, "Can only increase lock duration"
462     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
463 
464     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
465 
466 
467 @external
468 @nonreentrant('lock')
469 def withdraw():
470     """
471     @notice Withdraw all tokens for `msg.sender`
472     @dev Only possible if the lock has expired
473     """
474     _locked: LockedBalance = self.locked[msg.sender]
475     assert block.timestamp >= _locked.end, "The lock didn't expire"
476     value: uint256 = convert(_locked.amount, uint256)
477 
478     old_locked: LockedBalance = _locked
479     _locked.end = 0
480     _locked.amount = 0
481     self.locked[msg.sender] = _locked
482     supply_before: uint256 = self.supply
483     self.supply = supply_before - value
484 
485     # old_locked can have either expired <= timestamp or zero end
486     # _locked has only 0 end
487     # Both can have >= 0 amount
488     self._checkpoint(msg.sender, old_locked, _locked)
489 
490     assert ERC20(self.token).transfer(msg.sender, value)
491 
492     log Withdraw(msg.sender, value, block.timestamp)
493     log Supply(supply_before, supply_before - value)
494 
495 
496 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
497 # They measure the weights for the purpose of voting, so they don't represent
498 # real coins.
499 
500 @internal
501 @view
502 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
503     """
504     @notice Binary search to estimate timestamp for block number
505     @param _block Block to find
506     @param max_epoch Don't go beyond this epoch
507     @return Approximate timestamp for block
508     """
509     # Binary search
510     _min: uint256 = 0
511     _max: uint256 = max_epoch
512     for i in range(128):  # Will be always enough for 128-bit numbers
513         if _min >= _max:
514             break
515         _mid: uint256 = (_min + _max + 1) / 2
516         if self.point_history[_mid].blk <= _block:
517             _min = _mid
518         else:
519             _max = _mid - 1
520     return _min
521 
522 
523 @external
524 @view
525 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
526     """
527     @notice Get the current voting power for `msg.sender`
528     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
529     @param addr User wallet address
530     @param _t Epoch time to return voting power at
531     @return User voting power
532     """
533     _epoch: uint256 = self.user_point_epoch[addr]
534     if _epoch == 0:
535         return 0
536     else:
537         last_point: Point = self.user_point_history[addr][_epoch]
538         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
539         if last_point.bias < 0:
540             last_point.bias = 0
541         return convert(last_point.bias, uint256)
542 
543 
544 @external
545 @view
546 def balanceOfAt(addr: address, _block: uint256) -> uint256:
547     """
548     @notice Measure voting power of `addr` at block height `_block`
549     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
550     @param addr User's wallet address
551     @param _block Block to calculate the voting power at
552     @return Voting power
553     """
554     # Copying and pasting totalSupply code because Vyper cannot pass by
555     # reference yet
556     assert _block <= block.number
557 
558     # Binary search
559     _min: uint256 = 0
560     _max: uint256 = self.user_point_epoch[addr]
561     for i in range(128):  # Will be always enough for 128-bit numbers
562         if _min >= _max:
563             break
564         _mid: uint256 = (_min + _max + 1) / 2
565         if self.user_point_history[addr][_mid].blk <= _block:
566             _min = _mid
567         else:
568             _max = _mid - 1
569 
570     upoint: Point = self.user_point_history[addr][_min]
571 
572     max_epoch: uint256 = self.epoch
573     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
574     point_0: Point = self.point_history[_epoch]
575     d_block: uint256 = 0
576     d_t: uint256 = 0
577     if _epoch < max_epoch:
578         point_1: Point = self.point_history[_epoch + 1]
579         d_block = point_1.blk - point_0.blk
580         d_t = point_1.ts - point_0.ts
581     else:
582         d_block = block.number - point_0.blk
583         d_t = block.timestamp - point_0.ts
584     block_time: uint256 = point_0.ts
585     if d_block != 0:
586         block_time += d_t * (_block - point_0.blk) / d_block
587 
588     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
589     if upoint.bias >= 0:
590         return convert(upoint.bias, uint256)
591     else:
592         return 0
593 
594 
595 @internal
596 @view
597 def supply_at(point: Point, t: uint256) -> uint256:
598     """
599     @notice Calculate total voting power at some point in the past
600     @param point The point (bias/slope) to start search from
601     @param t Time to calculate the total voting power at
602     @return Total voting power at that time
603     """
604     last_point: Point = point
605     t_i: uint256 = (last_point.ts / WEEK) * WEEK
606     for i in range(255):
607         t_i += WEEK
608         d_slope: int128 = 0
609         if t_i > t:
610             t_i = t
611         else:
612             d_slope = self.slope_changes[t_i]
613         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
614         if t_i == t:
615             break
616         last_point.slope += d_slope
617         last_point.ts = t_i
618 
619     if last_point.bias < 0:
620         last_point.bias = 0
621     return convert(last_point.bias, uint256)
622 
623 
624 @external
625 @view
626 def totalSupply(t: uint256 = block.timestamp) -> uint256:
627     """
628     @notice Calculate total voting power
629     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
630     @return Total voting power
631     """
632     _epoch: uint256 = self.epoch
633     last_point: Point = self.point_history[_epoch]
634     return self.supply_at(last_point, t)
635 
636 
637 @external
638 @view
639 def totalSupplyAt(_block: uint256) -> uint256:
640     """
641     @notice Calculate total voting power at some point in the past
642     @param _block Block to calculate the total voting power at
643     @return Total voting power at `_block`
644     """
645     assert _block <= block.number
646     _epoch: uint256 = self.epoch
647     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
648 
649     point: Point = self.point_history[target_epoch]
650     dt: uint256 = 0
651     if target_epoch < _epoch:
652         point_next: Point = self.point_history[target_epoch + 1]
653         if point.blk != point_next.blk:
654             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
655     else:
656         if point.blk != block.number:
657             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
658     # Now dt contains info on how far are we beyond point
659 
660     return self.supply_at(point, point.ts + dt)
661 
662 
663 # Dummy methods for compatibility with Aragon
664 
665 @external
666 def changeController(_newController: address):
667     """
668     @dev Dummy method required for Aragon compatibility
669     """
670     assert msg.sender == self.controller
671     self.controller = _newController