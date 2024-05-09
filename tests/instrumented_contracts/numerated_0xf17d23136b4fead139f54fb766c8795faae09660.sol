1 # @version 0.3.7
2 """
3 @title Voting Escrow
4 @author Curve Finance
5 @license MIT
6 @notice Votes have a weight depending on time, so that users are
7         committed to the future of (whatever they are voting for)
8 @dev Vote weight decays linearly over time. Lock time cannot be
9      more than `MAXTIME` (1 year).
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
23 #       maxtime (1 year?)
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
60 event Deposit:
61     provider: indexed(address)
62     value: uint256
63     locktime: indexed(uint256)
64     type: int128
65     ts: uint256
66 
67 event Withdraw:
68     provider: indexed(address)
69     value: uint256
70     ts: uint256
71 
72 event Supply:
73     prevSupply: uint256
74     supply: uint256
75 
76 event NewPendingAdmin:
77     new_pending_admin: address
78 
79 event NewAdmin:
80     new_admin: address
81 
82 
83 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
84 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
85 MULTIPLIER: constant(uint256) = 10 ** 18
86 
87 TOKEN: immutable(address)
88 NAME: immutable(String[64])
89 SYMBOL: immutable(String[32])
90 DECIMALS: immutable(uint256)
91 
92 pending_admin: public(address)
93 admin: public(address)
94 
95 supply: public(uint256)
96 locked: public(HashMap[address, LockedBalance])
97 
98 epoch: public(uint256)
99 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
100 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
101 user_point_epoch: public(HashMap[address, uint256])
102 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
103 
104 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
105 # The goal is to prevent tokenizing the escrow
106 future_smart_wallet_checker: public(address)
107 smart_wallet_checker: public(address)
108 
109 
110 @external
111 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _admin: address):
112     """
113     @notice Contract constructor
114     @param token_addr The token to escrow
115     @param _name Token name
116     @param _symbol Token symbol
117     @param _admin The admin address
118     """
119     assert _admin != empty(address)
120 
121     TOKEN = token_addr
122     self.admin = _admin
123     self.point_history[0].blk = block.number
124     self.point_history[0].ts = block.timestamp
125 
126     _decimals: uint256 = ERC20(token_addr).decimals()
127     assert _decimals <= 255
128 
129     NAME = _name
130     SYMBOL = _symbol
131     DECIMALS = _decimals
132 
133 
134 @external
135 @view
136 def token() -> address:
137     return TOKEN
138 
139 
140 @external
141 @view
142 def name() -> String[64]:
143     return NAME
144 
145 
146 @external
147 @view
148 def symbol() -> String[32]:
149     return SYMBOL
150 
151 
152 @external
153 @view
154 def decimals() -> uint256:
155     return DECIMALS
156 
157 
158 @external
159 def commit_smart_wallet_checker(addr: address):
160     """
161     @notice Set an external contract to check for approved smart contract wallets
162     @param addr Address of Smart contract checker
163     """
164     assert msg.sender == self.admin
165     self.future_smart_wallet_checker = addr
166 
167 
168 @external
169 def apply_smart_wallet_checker():
170     """
171     @notice Apply setting external contract to check approved smart contract wallets
172     """
173     assert msg.sender == self.admin
174     self.smart_wallet_checker = self.future_smart_wallet_checker
175 
176 
177 @internal
178 def assert_not_contract(addr: address):
179     """
180     @notice Check if the call is from a whitelisted smart contract, revert if not
181     @param addr Address to be checked
182     """
183     if addr != tx.origin:
184         checker: address = self.smart_wallet_checker
185         if checker != empty(address):
186             if SmartWalletChecker(checker).check(addr):
187                 return
188         raise "Smart contract depositors not allowed"
189 
190 
191 @external
192 @view
193 def get_last_user_slope(addr: address) -> int128:
194     """
195     @notice Get the most recently recorded rate of voting power decrease for `addr`
196     @param addr Address of the user wallet
197     @return Value of the slope
198     """
199     uepoch: uint256 = self.user_point_epoch[addr]
200     return self.user_point_history[addr][uepoch].slope
201 
202 
203 @external
204 @view
205 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
206     """
207     @notice Get the timestamp for checkpoint `_idx` for `_addr`
208     @param _addr User wallet address
209     @param _idx User epoch number
210     @return Epoch time of the checkpoint
211     """
212     return self.user_point_history[_addr][_idx].ts
213 
214 
215 @external
216 @view
217 def locked__end(_addr: address) -> uint256:
218     """
219     @notice Get timestamp when `_addr`'s lock finishes
220     @param _addr User wallet
221     @return Epoch time of the lock end
222     """
223     return self.locked[_addr].end
224 
225 
226 @internal
227 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
228     """
229     @notice Record global and per-user data to checkpoint
230     @param addr User's wallet address. No user checkpoint if 0x0
231     @param old_locked Pevious locked amount / end lock time for the user
232     @param new_locked New locked amount / end lock time for the user
233     """
234     u_old: Point = empty(Point)
235     u_new: Point = empty(Point)
236     old_dslope: int128 = 0
237     new_dslope: int128 = 0
238     _epoch: uint256 = self.epoch
239 
240     if addr != empty(address):
241         # Calculate slopes and biases
242         # Kept at zero when they have to
243         if old_locked.end > block.timestamp and old_locked.amount > 0:
244             u_old.slope = old_locked.amount / convert(MAXTIME, int128)
245             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
246         if new_locked.end > block.timestamp and new_locked.amount > 0:
247             u_new.slope = new_locked.amount / convert(MAXTIME, int128)
248             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
249 
250         # Read values of scheduled changes in the slope
251         # old_locked.end can be in the past and in the future
252         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
253         old_dslope = self.slope_changes[old_locked.end]
254         if new_locked.end != 0:
255             if new_locked.end == old_locked.end:
256                 new_dslope = old_dslope
257             else:
258                 new_dslope = self.slope_changes[new_locked.end]
259 
260     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
261     if _epoch > 0:
262         last_point = self.point_history[_epoch]
263     last_checkpoint: uint256 = last_point.ts
264     # initial_last_point is used for extrapolation to calculate block number
265     # (approximately, for *At methods) and save them
266     # as we cannot figure that out exactly from inside the contract
267     initial_last_point: Point = last_point
268     block_slope: uint256 = 0  # dblock/dt
269     if block.timestamp > last_point.ts:
270         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
271     # If last point is already recorded in this block, slope=0
272     # But that's ok b/c we know the block in such case
273 
274     # Go over weeks to fill history and calculate what the current point is
275     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
276     for i in range(255):
277         # Hopefully it won't happen that this won't get used in 5 years!
278         # If it does, users will be able to withdraw but vote weight will be broken
279         t_i += WEEK
280         d_slope: int128 = 0
281         if t_i > block.timestamp:
282             t_i = block.timestamp
283         else:
284             d_slope = self.slope_changes[t_i]
285         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
286         last_point.slope += d_slope
287         if last_point.bias < 0:  # This can happen
288             last_point.bias = 0
289         if last_point.slope < 0:  # This cannot happen - just in case
290             last_point.slope = 0
291         last_checkpoint = t_i
292         last_point.ts = t_i
293         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
294         _epoch += 1
295         if t_i == block.timestamp:
296             last_point.blk = block.number
297             break
298         else:
299             self.point_history[_epoch] = last_point
300 
301     self.epoch = _epoch
302     # Now point_history is filled until t=now
303 
304     if addr != empty(address):
305         # If last point was in this block, the slope change has been applied already
306         # But in such case we have 0 slope(s)
307         last_point.slope += (u_new.slope - u_old.slope)
308         last_point.bias += (u_new.bias - u_old.bias)
309         if last_point.slope < 0:
310             last_point.slope = 0
311         if last_point.bias < 0:
312             last_point.bias = 0
313 
314     # Record the changed point into history
315     self.point_history[_epoch] = last_point
316 
317     if addr != empty(address):
318         # Schedule the slope changes (slope is going down)
319         # We subtract new_user_slope from [new_locked.end]
320         # and add old_user_slope to [old_locked.end]
321         if old_locked.end > block.timestamp:
322             # old_dslope was <something> - u_old.slope, so we cancel that
323             old_dslope += u_old.slope
324             if new_locked.end == old_locked.end:
325                 old_dslope -= u_new.slope  # It was a new deposit, not extension
326             self.slope_changes[old_locked.end] = old_dslope
327 
328         if new_locked.end > block.timestamp:
329             if new_locked.end > old_locked.end:
330                 new_dslope -= u_new.slope  # old slope disappeared at this point
331                 self.slope_changes[new_locked.end] = new_dslope
332             # else: we recorded it already in old_dslope
333 
334         # Now handle user history
335         user_epoch: uint256 = self.user_point_epoch[addr] + 1
336 
337         self.user_point_epoch[addr] = user_epoch
338         u_new.ts = block.timestamp
339         u_new.blk = block.number
340         self.user_point_history[addr][user_epoch] = u_new
341 
342 
343 @internal
344 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
345     """
346     @notice Deposit and lock tokens for a user
347     @param _addr User's wallet address
348     @param _value Amount to deposit
349     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
350     @param locked_balance Previous locked amount / timestamp
351     """
352     _locked: LockedBalance = locked_balance
353     supply_before: uint256 = self.supply
354 
355     self.supply = supply_before + _value
356     old_locked: LockedBalance = _locked
357     # Adding to existing lock, or if a lock is expired - creating a new one
358     _locked.amount += convert(_value, int128)
359     if unlock_time != 0:
360         _locked.end = unlock_time
361     self.locked[_addr] = _locked
362 
363     # Possibilities:
364     # Both old_locked.end could be current or expired (>/< block.timestamp)
365     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
366     # _locked.end > block.timestamp (always)
367     self._checkpoint(_addr, old_locked, _locked)
368 
369     if _value != 0:
370         assert ERC20(TOKEN).transferFrom(_addr, self, _value)
371 
372     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
373     log Supply(supply_before, supply_before + _value)
374 
375 
376 @external
377 def checkpoint():
378     """
379     @notice Record global data to checkpoint
380     """
381     self._checkpoint(empty(address), empty(LockedBalance), empty(LockedBalance))
382 
383 
384 @external
385 @nonreentrant('lock')
386 def deposit_for(_addr: address, _value: uint256):
387     """
388     @notice Deposit `_value` tokens for `_addr` and add to the lock
389     @dev Anyone (even a smart contract) can deposit for someone else, but
390          cannot extend their locktime and deposit for a brand new user
391     @param _addr User's wallet address
392     @param _value Amount to add to user's lock
393     """
394     _locked: LockedBalance = self.locked[_addr]
395 
396     assert _value > 0  # dev: need non-zero value
397     assert _locked.amount > 0, "No existing lock found"
398     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
399 
400     self._deposit_for(_addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
401 
402 
403 @external
404 @nonreentrant('lock')
405 def create_lock(_value: uint256, _unlock_time: uint256):
406     """
407     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
408     @param _value Amount to deposit
409     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
410     """
411     self.assert_not_contract(msg.sender)
412     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
413     _locked: LockedBalance = self.locked[msg.sender]
414 
415     assert _value > 0  # dev: need non-zero value
416     assert _locked.amount == 0, "Withdraw old tokens first"
417     assert unlock_time > block.timestamp, "Can only lock until time in the future"
418     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 1 year max"
419 
420     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
421 
422 
423 @external
424 @nonreentrant('lock')
425 def increase_amount(_value: uint256):
426     """
427     @notice Deposit `_value` additional tokens for `msg.sender`
428             without modifying the unlock time
429     @param _value Amount of tokens to deposit and add to the lock
430     """
431     self.assert_not_contract(msg.sender)
432     _locked: LockedBalance = self.locked[msg.sender]
433 
434     assert _value > 0  # dev: need non-zero value
435     assert _locked.amount > 0, "No existing lock found"
436     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
437 
438     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
439 
440 
441 @external
442 @nonreentrant('lock')
443 def increase_unlock_time(_unlock_time: uint256):
444     """
445     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
446     @param _unlock_time New epoch time for unlocking
447     """
448     self.assert_not_contract(msg.sender)
449     _locked: LockedBalance = self.locked[msg.sender]
450     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
451 
452     assert _locked.end > block.timestamp, "Lock expired"
453     assert _locked.amount > 0, "Nothing is locked"
454     assert unlock_time > _locked.end, "Can only increase lock duration"
455     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 1 year max"
456 
457     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
458 
459 
460 @external
461 @nonreentrant('lock')
462 def withdraw():
463     """
464     @notice Withdraw all tokens for `msg.sender`
465     @dev Only possible if the lock has expired
466     """
467     _locked: LockedBalance = self.locked[msg.sender]
468     assert block.timestamp >= _locked.end, "The lock didn't expire"
469     value: uint256 = convert(_locked.amount, uint256)
470 
471     old_locked: LockedBalance = _locked
472     _locked.end = 0
473     _locked.amount = 0
474     self.locked[msg.sender] = _locked
475     supply_before: uint256 = self.supply
476     self.supply = supply_before - value
477 
478     # old_locked can have either expired <= timestamp or zero end
479     # _locked has only 0 end
480     # Both can have >= 0 amount
481     self._checkpoint(msg.sender, old_locked, _locked)
482 
483     assert ERC20(TOKEN).transfer(msg.sender, value)
484 
485     log Withdraw(msg.sender, value, block.timestamp)
486     log Supply(supply_before, supply_before - value)
487 
488 
489 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
490 # They measure the weights for the purpose of voting, so they don't represent
491 # real coins.
492 
493 @internal
494 @view
495 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
496     """
497     @notice Binary search to find epoch containing block number
498     @param _block Block to find
499     @param max_epoch Don't go beyond this epoch
500     @return Epoch which contains _block
501     """
502     # Binary search
503     _min: uint256 = 0
504     _max: uint256 = max_epoch
505     for i in range(128):  # Will be always enough for 128-bit numbers
506         if _min >= _max:
507             break
508         _mid: uint256 = (_min + _max + 1) / 2
509         if self.point_history[_mid].blk <= _block:
510             _min = _mid
511         else:
512             _max = _mid - 1
513     return _min
514 
515 
516 @internal
517 @view
518 def find_timestamp_epoch(_timestamp: uint256, max_epoch: uint256) -> uint256:
519     """
520     @notice Binary search to find epoch for timestamp
521     @param _timestamp timestamp to find
522     @param max_epoch Don't go beyond this epoch
523     @return Epoch which contains _timestamp
524     """
525     # Binary search
526     _min: uint256 = 0
527     _max: uint256 = max_epoch
528     for i in range(128):  # Will be always enough for 128-bit numbers
529         if _min >= _max:
530             break
531         _mid: uint256 = (_min + _max + 1) / 2
532         if self.point_history[_mid].ts <= _timestamp:
533             _min = _mid
534         else:
535             _max = _mid - 1
536     return _min
537 
538 
539 @internal
540 @view
541 def find_block_user_epoch(_addr: address, _block: uint256, max_epoch: uint256) -> uint256:
542     """
543     @notice Binary search to find epoch for block number
544     @param _addr User for which to find user epoch for
545     @param _block Block to find
546     @param max_epoch Don't go beyond this epoch
547     @return Epoch which contains _block
548     """
549     # Binary search
550     _min: uint256 = 0
551     _max: uint256 = max_epoch
552     for i in range(128):  # Will be always enough for 128-bit numbers
553         if _min >= _max:
554             break
555         _mid: uint256 = (_min + _max + 1) / 2
556         if self.user_point_history[_addr][_mid].blk <= _block:
557             _min = _mid
558         else:
559             _max = _mid - 1
560     return _min
561 
562 
563 @internal
564 @view
565 def find_timestamp_user_epoch(_addr: address, _timestamp: uint256, max_epoch: uint256) -> uint256:
566     """
567     @notice Binary search to find user epoch for timestamp
568     @param _addr User for which to find user epoch for
569     @param _timestamp timestamp to find
570     @param max_epoch Don't go beyond this epoch
571     @return Epoch which contains _timestamp
572     """
573     # Binary search
574     _min: uint256 = 0
575     _max: uint256 = max_epoch
576     for i in range(128):  # Will be always enough for 128-bit numbers
577         if _min >= _max:
578             break
579         _mid: uint256 = (_min + _max + 1) / 2
580         if self.user_point_history[_addr][_mid].ts <= _timestamp:
581             _min = _mid
582         else:
583             _max = _mid - 1
584     return _min
585 
586 
587 @external
588 @view
589 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
590     """
591     @notice Get the current voting power for `msg.sender`
592     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
593     @param addr User wallet address
594     @param _t Epoch time to return voting power at
595     @return User voting power
596     """
597     _epoch: uint256 = 0
598     if _t == block.timestamp:
599         # No need to do binary search, will always live in current epoch
600         _epoch = self.user_point_epoch[addr]
601     else:
602         _epoch = self.find_timestamp_user_epoch(addr, _t, self.user_point_epoch[addr])
603 
604     if _epoch == 0:
605         return 0
606     else:
607         last_point: Point = self.user_point_history[addr][_epoch]
608         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
609         if last_point.bias < 0:
610             last_point.bias = 0
611         return convert(last_point.bias, uint256)
612 
613 
614 @external
615 @view
616 def balanceOfAt(addr: address, _block: uint256) -> uint256:
617     """
618     @notice Measure voting power of `addr` at block height `_block`
619     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
620     @param addr User's wallet address
621     @param _block Block to calculate the voting power at
622     @return Voting power
623     """
624     # Copying and pasting totalSupply code because Vyper cannot pass by
625     # reference yet
626     assert _block <= block.number
627 
628     _user_epoch: uint256 = self.find_block_user_epoch(addr, _block, self.user_point_epoch[addr])
629     upoint: Point = self.user_point_history[addr][_user_epoch]
630 
631     max_epoch: uint256 = self.epoch
632     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
633     point_0: Point = self.point_history[_epoch]
634     d_block: uint256 = 0
635     d_t: uint256 = 0
636     if _epoch < max_epoch:
637         point_1: Point = self.point_history[_epoch + 1]
638         d_block = point_1.blk - point_0.blk
639         d_t = point_1.ts - point_0.ts
640     else:
641         d_block = block.number - point_0.blk
642         d_t = block.timestamp - point_0.ts
643     block_time: uint256 = point_0.ts
644     if d_block != 0:
645         block_time += d_t * (_block - point_0.blk) / d_block
646 
647     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
648     if upoint.bias >= 0:
649         return convert(upoint.bias, uint256)
650     else:
651         return 0
652 
653 
654 @internal
655 @view
656 def supply_at(point: Point, t: uint256) -> uint256:
657     """
658     @notice Calculate total voting power at some point in the past
659     @param point The point (bias/slope) to start search from
660     @param t Time to calculate the total voting power at
661     @return Total voting power at that time
662     """
663     last_point: Point = point
664     t_i: uint256 = (last_point.ts / WEEK) * WEEK
665     for i in range(255):
666         t_i += WEEK
667         d_slope: int128 = 0
668         if t_i > t:
669             t_i = t
670         else:
671             d_slope = self.slope_changes[t_i]
672         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
673         if t_i == t:
674             break
675         last_point.slope += d_slope
676         last_point.ts = t_i
677 
678     if last_point.bias < 0:
679         last_point.bias = 0
680     return convert(last_point.bias, uint256)
681 
682 
683 @external
684 @view
685 def totalSupply(t: uint256 = block.timestamp) -> uint256:
686     """
687     @notice Calculate total voting power
688     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
689     @return Total voting power
690     """
691     _epoch: uint256 = 0
692     if t == block.timestamp:
693         # No need to do binary search, will always live in current epoch
694         _epoch = self.epoch
695     else:
696         _epoch = self.find_timestamp_epoch(t, self.epoch)
697 
698     if _epoch == 0:
699         return 0
700     else:
701         last_point: Point = self.point_history[_epoch]
702         return self.supply_at(last_point, t)
703 
704 
705 @external
706 @view
707 def totalSupplyAt(_block: uint256) -> uint256:
708     """
709     @notice Calculate total voting power at some point in the past
710     @param _block Block to calculate the total voting power at
711     @return Total voting power at `_block`
712     """
713     assert _block <= block.number
714     _epoch: uint256 = self.epoch
715     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
716 
717     point: Point = self.point_history[target_epoch]
718     dt: uint256 = 0
719     if target_epoch < _epoch:
720         point_next: Point = self.point_history[target_epoch + 1]
721         if point.blk != point_next.blk:
722             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
723     else:
724         if point.blk != block.number:
725             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
726     # Now dt contains info on how far are we beyond point
727 
728     return self.supply_at(point, point.ts + dt)
729 
730 
731 @external
732 def change_pending_admin(new_pending_admin: address):
733     """
734     @notice Change pending_admin to `new_pending_admin`
735     @param new_pending_admin The new pending_admin address
736     """
737     assert msg.sender == self.admin
738 
739     self.pending_admin = new_pending_admin
740 
741     log NewPendingAdmin(new_pending_admin)
742 
743 
744 @external
745 def claim_admin():
746     """
747     @notice Called by pending_admin to set admin to pending_admin
748     """
749     assert msg.sender == self.pending_admin
750 
751     self.admin = msg.sender
752     self.pending_admin = empty(address)
753 
754     log NewAdmin(msg.sender)