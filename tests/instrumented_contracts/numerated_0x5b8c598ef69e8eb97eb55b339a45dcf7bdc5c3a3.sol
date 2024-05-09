1 # @version 0.2.16
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
59 CREATE_LOCK_FOR_TYPE: constant(int128) = 4
60 
61 
62 event CommitOwnership:
63     admin: address
64 
65 event ApplyOwnership:
66     admin: address
67 
68 event Deposit:
69     provider: indexed(address)
70     value: uint256
71     locktime: indexed(uint256)
72     type: int128
73     ts: uint256
74 
75 event Withdraw:
76     provider: indexed(address)
77     value: uint256
78     ts: uint256
79 
80 event Supply:
81     prevSupply: uint256
82     supply: uint256
83 
84 
85 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
86 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
87 MULTIPLIER: constant(uint256) = 10 ** 18
88 
89 token: public(address)
90 supply: public(uint256)
91 
92 locked: public(HashMap[address, LockedBalance])
93 
94 epoch: public(uint256)
95 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
96 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
97 user_point_epoch: public(HashMap[address, uint256])
98 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
99 
100 # Aragon's view methods for compatibility
101 controller: public(address)
102 transfersEnabled: public(bool)
103 
104 name: public(String[64])
105 symbol: public(String[32])
106 version: public(String[32])
107 decimals: public(uint256)
108 
109 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
110 # The goal is to prevent tokenizing the escrow
111 future_smart_wallet_checker: public(address)
112 smart_wallet_checker: public(address)
113 
114 admin: public(address)  # Can and will be a smart contract
115 future_admin: public(address)
116 
117 MIN_VE: constant(uint256) = 2500 * 10**18
118 
119 
120 @external
121 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
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
144 
145 @external
146 def commit_transfer_ownership(addr: address):
147     """
148     @notice Transfer ownership of VotingEscrow contract to `addr`
149     @param addr Address to have ownership transferred to
150     """
151     assert msg.sender == self.admin  # dev: admin only
152     self.future_admin = addr
153     log CommitOwnership(addr)
154 
155 
156 @external
157 def apply_transfer_ownership():
158     """
159     @notice Apply ownership transfer
160     """
161     assert msg.sender == self.admin  # dev: admin only
162     _admin: address = self.future_admin
163     assert _admin != ZERO_ADDRESS  # dev: admin not set
164     self.admin = _admin
165     log ApplyOwnership(_admin)
166 
167 
168 @external
169 def commit_smart_wallet_checker(addr: address):
170     """
171     @notice Set an external contract to check for approved smart contract wallets
172     @param addr Address of Smart contract checker
173     """
174     assert msg.sender == self.admin
175     self.future_smart_wallet_checker = addr
176 
177 
178 @external
179 def apply_smart_wallet_checker():
180     """
181     @notice Apply setting external contract to check approved smart contract wallets
182     """
183     assert msg.sender == self.admin
184     self.smart_wallet_checker = self.future_smart_wallet_checker
185 
186 
187 @internal
188 def assert_not_contract(addr: address):
189     """
190     @notice Check if the call is from a whitelisted smart contract, revert if not
191     @param addr Address to be checked
192     """
193     if addr != tx.origin:
194         checker: address = self.smart_wallet_checker
195         if checker != ZERO_ADDRESS:
196             if SmartWalletChecker(checker).check(addr):
197                 return
198         raise "Smart contract depositors not allowed"
199 
200 
201 @external
202 @view
203 def get_last_user_slope(addr: address) -> int128:
204     """
205     @notice Get the most recently recorded rate of voting power decrease for `addr`
206     @param addr Address of the user wallet
207     @return Value of the slope
208     """
209     uepoch: uint256 = self.user_point_epoch[addr]
210     return self.user_point_history[addr][uepoch].slope
211 
212 
213 @external
214 @view
215 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
216     """
217     @notice Get the timestamp for checkpoint `_idx` for `_addr`
218     @param _addr User wallet address
219     @param _idx User epoch number
220     @return Epoch time of the checkpoint
221     """
222     return self.user_point_history[_addr][_idx].ts
223 
224 
225 @external
226 @view
227 def locked__end(_addr: address) -> uint256:
228     """
229     @notice Get timestamp when `_addr`'s lock finishes
230     @param _addr User wallet
231     @return Epoch time of the lock end
232     """
233     return self.locked[_addr].end
234 
235 
236 @internal
237 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
238     """
239     @notice Record global and per-user data to checkpoint
240     @param addr User's wallet address. No user checkpoint if 0x0
241     @param old_locked Pevious locked amount / end lock time for the user
242     @param new_locked New locked amount / end lock time for the user
243     """
244     u_old: Point = empty(Point)
245     u_new: Point = empty(Point)
246     old_dslope: int128 = 0
247     new_dslope: int128 = 0
248     _epoch: uint256 = self.epoch
249 
250     if addr != ZERO_ADDRESS:
251         # Calculate slopes and biases
252         # Kept at zero when they have to
253         if old_locked.end > block.timestamp and old_locked.amount > 0:
254             u_old.slope = old_locked.amount / MAXTIME
255             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
256         if new_locked.end > block.timestamp and new_locked.amount > 0:
257             u_new.slope = new_locked.amount / MAXTIME
258             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
259 
260         # Read values of scheduled changes in the slope
261         # old_locked.end can be in the past and in the future
262         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
263         old_dslope = self.slope_changes[old_locked.end]
264         if new_locked.end != 0:
265             if new_locked.end == old_locked.end:
266                 new_dslope = old_dslope
267             else:
268                 new_dslope = self.slope_changes[new_locked.end]
269 
270     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
271     if _epoch > 0:
272         last_point = self.point_history[_epoch]
273     last_checkpoint: uint256 = last_point.ts
274     # initial_last_point is used for extrapolation to calculate block number
275     # (approximately, for *At methods) and save them
276     # as we cannot figure that out exactly from inside the contract
277     initial_last_point: Point = last_point
278     block_slope: uint256 = 0  # dblock/dt
279     if block.timestamp > last_point.ts:
280         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
281     # If last point is already recorded in this block, slope=0
282     # But that's ok b/c we know the block in such case
283 
284     # Go over weeks to fill history and calculate what the current point is
285     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
286     for i in range(255):
287         # Hopefully it won't happen that this won't get used in 5 years!
288         # If it does, users will be able to withdraw but vote weight will be broken
289         t_i += WEEK
290         d_slope: int128 = 0
291         if t_i > block.timestamp:
292             t_i = block.timestamp
293         else:
294             d_slope = self.slope_changes[t_i]
295         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
296         last_point.slope += d_slope
297         if last_point.bias < 0:  # This can happen
298             last_point.bias = 0
299         if last_point.slope < 0:  # This cannot happen - just in case
300             last_point.slope = 0
301         last_checkpoint = t_i
302         last_point.ts = t_i
303         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
304         _epoch += 1
305         if t_i == block.timestamp:
306             last_point.blk = block.number
307             break
308         else:
309             self.point_history[_epoch] = last_point
310 
311     self.epoch = _epoch
312     # Now point_history is filled until t=now
313 
314     if addr != ZERO_ADDRESS:
315         # If last point was in this block, the slope change has been applied already
316         # But in such case we have 0 slope(s)
317         last_point.slope += (u_new.slope - u_old.slope)
318         last_point.bias += (u_new.bias - u_old.bias)
319         if last_point.slope < 0:
320             last_point.slope = 0
321         if last_point.bias < 0:
322             last_point.bias = 0
323 
324     # Record the changed point into history
325     self.point_history[_epoch] = last_point
326 
327     if addr != ZERO_ADDRESS:
328         # Schedule the slope changes (slope is going down)
329         # We subtract new_user_slope from [new_locked.end]
330         # and add old_user_slope to [old_locked.end]
331         if old_locked.end > block.timestamp:
332             # old_dslope was <something> - u_old.slope, so we cancel that
333             old_dslope += u_old.slope
334             if new_locked.end == old_locked.end:
335                 old_dslope -= u_new.slope  # It was a new deposit, not extension
336             self.slope_changes[old_locked.end] = old_dslope
337 
338         if new_locked.end > block.timestamp:
339             if new_locked.end > old_locked.end:
340                 new_dslope -= u_new.slope  # old slope disappeared at this point
341                 self.slope_changes[new_locked.end] = new_dslope
342             # else: we recorded it already in old_dslope
343 
344         # Now handle user history
345         user_epoch: uint256 = self.user_point_epoch[addr] + 1
346 
347         self.user_point_epoch[addr] = user_epoch
348         u_new.ts = block.timestamp
349         u_new.blk = block.number
350         self.user_point_history[addr][user_epoch] = u_new
351 
352 
353 @internal
354 def _deposit_for(_from: address, _addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
355     """
356     @notice Deposit and lock tokens for a user
357     @param _addr User's wallet address
358     @param _value Amount to deposit
359     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
360     @param locked_balance Previous locked amount / timestamp
361     """
362     _locked: LockedBalance = locked_balance
363     supply_before: uint256 = self.supply
364 
365     self.supply = supply_before + _value
366     old_locked: LockedBalance = _locked
367     # Adding to existing lock, or if a lock is expired - creating a new one
368     _locked.amount += convert(_value, int128)
369     if unlock_time != 0:
370         _locked.end = unlock_time
371     self.locked[_addr] = _locked
372 
373     # Possibilities:
374     # Both old_locked.end could be current or expired (>/< block.timestamp)
375     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
376     # _locked.end > block.timestamp (always)
377     self._checkpoint(_addr, old_locked, _locked)
378 
379     if _value != 0:
380         assert ERC20(self.token).transferFrom(_from, self, _value)
381 
382     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
383     log Supply(supply_before, supply_before + _value)
384 
385 
386 @external
387 def checkpoint():
388     """
389     @notice Record global data to checkpoint
390     """
391     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
392 
393 
394 @external
395 @nonreentrant('lock')
396 def deposit_for(_addr: address, _value: uint256):
397     """
398     @notice Deposit `_value` tokens for `_addr` and add to the lock
399     @dev Anyone (even a smart contract) can deposit for someone else, but
400          cannot extend their locktime and deposit for a brand new user
401     @param _addr User's wallet address
402     @param _value Amount to add to user's lock
403     """
404     _locked: LockedBalance = self.locked[_addr]
405 
406     assert _value > 0  # dev: need non-zero value
407     assert _locked.amount > 0, "No existing lock found"
408     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
409 
410     self._deposit_for(msg.sender, _addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
411 
412 
413 @external
414 @nonreentrant('lock')
415 def create_lock(_value: uint256, _unlock_time: uint256):
416     """
417     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
418     @param _value Amount to deposit
419     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
420     """
421     self.assert_not_contract(msg.sender)
422     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
423     _locked: LockedBalance = self.locked[msg.sender]
424 
425     assert _value > 0  # dev: need non-zero value
426     assert _locked.amount == 0, "Withdraw old tokens first"
427     assert unlock_time > block.timestamp, "Can only lock until time in the future"
428     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
429 
430     self._deposit_for(msg.sender, msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
431 
432 
433 @external
434 @nonreentrant('lock')
435 def create_lock_for(_addr: address, _value: uint256, _unlock_time: uint256):
436     """
437     @notice Deposit `_value` tokens for `addr` and lock until `_unlock_time`
438     @param _value Amount to deposit
439     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
440     """
441     self.assert_not_contract(msg.sender)
442     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
443     _locked: LockedBalance = self.locked[_addr]
444 
445     assert _value > 0  # dev: need non-zero value
446     assert _locked.amount == 0, "Withdraw old tokens first"
447     assert unlock_time > block.timestamp, "Can only lock until time in the future"
448     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
449 
450     self._deposit_for(msg.sender, _addr, _value, unlock_time, _locked, CREATE_LOCK_FOR_TYPE)
451 
452 
453 @external
454 @nonreentrant('lock')
455 def increase_amount(_value: uint256):
456     """
457     @notice Deposit `_value` additional tokens for `msg.sender`
458             without modifying the unlock time
459     @param _value Amount of tokens to deposit and add to the lock
460     """
461     self.assert_not_contract(msg.sender)
462     _locked: LockedBalance = self.locked[msg.sender]
463 
464     assert _value > 0  # dev: need non-zero value
465     assert _locked.amount > 0, "No existing lock found"
466     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
467 
468     self._deposit_for(msg.sender, msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
469 
470 
471 @external
472 @nonreentrant('lock')
473 def increase_unlock_time(_unlock_time: uint256):
474     """
475     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
476     @param _unlock_time New epoch time for unlocking
477     """
478     self.assert_not_contract(msg.sender)
479     _locked: LockedBalance = self.locked[msg.sender]
480     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
481 
482     assert _locked.end > block.timestamp, "Lock expired"
483     assert _locked.amount > 0, "Nothing is locked"
484     assert unlock_time > _locked.end, "Can only increase lock duration"
485     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
486 
487     self._deposit_for(msg.sender, msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
488 
489 
490 @external
491 @nonreentrant('lock')
492 def withdraw():
493     """
494     @notice Withdraw all tokens for `msg.sender`
495     @dev Only possible if the lock has expired
496     """
497     _locked: LockedBalance = self.locked[msg.sender]
498     assert block.timestamp >= _locked.end, "The lock didn't expire"
499     value: uint256 = convert(_locked.amount, uint256)
500 
501     old_locked: LockedBalance = _locked
502     _locked.end = 0
503     _locked.amount = 0
504     self.locked[msg.sender] = _locked
505     supply_before: uint256 = self.supply
506     self.supply = supply_before - value
507 
508     # old_locked can have either expired <= timestamp or zero end
509     # _locked has only 0 end
510     # Both can have >= 0 amount
511     self._checkpoint(msg.sender, old_locked, _locked)
512 
513     assert ERC20(self.token).transfer(msg.sender, value)
514 
515     log Withdraw(msg.sender, value, block.timestamp)
516     log Supply(supply_before, supply_before - value)
517 
518 
519 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
520 # They measure the weights for the purpose of voting, so they don't represent
521 # real coins.
522 
523 @internal
524 @view
525 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
526     """
527     @notice Binary search to estimate timestamp for block number
528     @param _block Block to find
529     @param max_epoch Don't go beyond this epoch
530     @return Approximate timestamp for block
531     """
532     # Binary search
533     _min: uint256 = 0
534     _max: uint256 = max_epoch
535     for i in range(128):  # Will be always enough for 128-bit numbers
536         if _min >= _max:
537             break
538         _mid: uint256 = (_min + _max + 1) / 2
539         if self.point_history[_mid].blk <= _block:
540             _min = _mid
541         else:
542             _max = _mid - 1
543     return _min
544 
545 @external
546 @view
547 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
548     """
549     @notice Get the current voting power for `msg.sender`
550     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
551     @param addr User wallet address
552     @param _t Epoch time to return voting power at
553     @return User voting power
554     """
555     _epoch: uint256 = self.user_point_epoch[addr]
556     if _epoch == 0:
557         return 0
558     else:
559         last_point: Point = self.user_point_history[addr][_epoch]
560         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
561         if last_point.bias < 0:
562             last_point.bias = 0
563         return convert(last_point.bias, uint256)
564 
565 @external
566 @view
567 def balanceOfAt(addr: address, _block: uint256) -> uint256:
568     """
569     @notice Measure voting power of `addr` at block height `_block`
570     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
571     @param addr User's wallet address
572     @param _block Block to calculate the voting power at
573     @return Voting power
574     """
575     # Copying and pasting totalSupply code because Vyper cannot pass by
576     # reference yet
577     assert _block <= block.number
578 
579     # Binary search
580     _min: uint256 = 0
581     _max: uint256 = self.user_point_epoch[addr]
582     for i in range(128):  # Will be always enough for 128-bit numbers
583         if _min >= _max:
584             break
585         _mid: uint256 = (_min + _max + 1) / 2
586         if self.user_point_history[addr][_mid].blk <= _block:
587             _min = _mid
588         else:
589             _max = _mid - 1
590 
591     upoint: Point = self.user_point_history[addr][_min]
592 
593     max_epoch: uint256 = self.epoch
594     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
595     point_0: Point = self.point_history[_epoch]
596     d_block: uint256 = 0
597     d_t: uint256 = 0
598     if _epoch < max_epoch:
599         point_1: Point = self.point_history[_epoch + 1]
600         d_block = point_1.blk - point_0.blk
601         d_t = point_1.ts - point_0.ts
602     else:
603         d_block = block.number - point_0.blk
604         d_t = block.timestamp - point_0.ts
605     block_time: uint256 = point_0.ts
606     if d_block != 0:
607         block_time += d_t * (_block - point_0.blk) / d_block
608 
609     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
610     if upoint.bias >= 0:
611         return convert(upoint.bias, uint256)
612     else:
613         return 0
614 
615 
616 @internal
617 @view
618 def supply_at(point: Point, t: uint256) -> uint256:
619     """
620     @notice Calculate total voting power at some point in the past
621     @param point The point (bias/slope) to start search from
622     @param t Time to calculate the total voting power at
623     @return Total voting power at that time
624     """
625     last_point: Point = point
626     t_i: uint256 = (last_point.ts / WEEK) * WEEK
627     for i in range(255):
628         t_i += WEEK
629         d_slope: int128 = 0
630         if t_i > t:
631             t_i = t
632         else:
633             d_slope = self.slope_changes[t_i]
634         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
635         if t_i == t:
636             break
637         last_point.slope += d_slope
638         last_point.ts = t_i
639 
640     if last_point.bias < 0:
641         last_point.bias = 0
642     return convert(last_point.bias, uint256)
643 
644 
645 @external
646 @view
647 def totalSupply(t: uint256 = block.timestamp) -> uint256:
648     """
649     @notice Calculate total voting power
650     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
651     @return Total voting power
652     """
653     _epoch: uint256 = self.epoch
654     last_point: Point = self.point_history[_epoch]
655     return self.supply_at(last_point, t)
656 
657 
658 @external
659 @view
660 def totalSupplyAt(_block: uint256) -> uint256:
661     """
662     @notice Calculate total voting power at some point in the past
663     @param _block Block to calculate the total voting power at
664     @return Total voting power at `_block`
665     """
666     assert _block <= block.number
667     _epoch: uint256 = self.epoch
668     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
669 
670     point: Point = self.point_history[target_epoch]
671     dt: uint256 = 0
672     if target_epoch < _epoch:
673         point_next: Point = self.point_history[target_epoch + 1]
674         if point.blk != point_next.blk:
675             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
676     else:
677         if point.blk != block.number:
678             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
679     # Now dt contains info on how far are we beyond point
680 
681     return self.supply_at(point, point.ts + dt)
682 
683 
684 # Dummy methods for compatibility with Aragon
685 
686 @external
687 def changeController(_newController: address):
688     """
689     @dev Dummy method required for Aragon compatibility
690     """
691     assert msg.sender == self.controller
692     self.controller = _newController