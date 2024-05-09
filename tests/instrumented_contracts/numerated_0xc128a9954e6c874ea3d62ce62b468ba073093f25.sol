1 # @version 0.3.1
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
76 
77 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
78 MAXTIME: constant(uint256) = 365 * 86400  # 1 year
79 MULTIPLIER: constant(uint256) = 10 ** 18
80 
81 TOKEN: immutable(address)
82 AUTHORIZER_ADAPTOR: immutable(address) # Authorizer Adaptor
83 
84 NAME: immutable(String[64])
85 SYMBOL: immutable(String[32])
86 DECIMALS: immutable(uint256)
87 
88 supply: public(uint256)
89 locked: public(HashMap[address, LockedBalance])
90 
91 epoch: public(uint256)
92 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
93 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
94 user_point_epoch: public(HashMap[address, uint256])
95 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
96 
97 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
98 # The goal is to prevent tokenizing the escrow
99 future_smart_wallet_checker: public(address)
100 smart_wallet_checker: public(address)
101 
102 
103 @external
104 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _authorizer_adaptor: address):
105     """
106     @notice Contract constructor
107     @param token_addr 80/20 BAL-WETH BPT token address
108     @param _name Token name
109     @param _symbol Token symbol
110     @param _authorizer_adaptor `AuthorizerAdaptor` contract address
111     """
112     assert _authorizer_adaptor != ZERO_ADDRESS
113 
114     TOKEN = token_addr
115     AUTHORIZER_ADAPTOR = _authorizer_adaptor
116     self.point_history[0].blk = block.number
117     self.point_history[0].ts = block.timestamp
118 
119     _decimals: uint256 = ERC20(token_addr).decimals()
120     assert _decimals <= 255
121 
122     NAME = _name
123     SYMBOL = _symbol
124     DECIMALS = _decimals
125 
126 @external
127 @view
128 def token() -> address:
129     return TOKEN
130 
131 @external
132 @view
133 def name() -> String[64]:
134     return NAME
135 
136 @external
137 @view
138 def symbol() -> String[32]:
139     return SYMBOL
140 
141 @external
142 @view
143 def decimals() -> uint256:
144     return DECIMALS
145 
146 @external
147 @view
148 def admin() -> address:
149     return AUTHORIZER_ADAPTOR
150 
151 @external
152 def commit_smart_wallet_checker(addr: address):
153     """
154     @notice Set an external contract to check for approved smart contract wallets
155     @param addr Address of Smart contract checker
156     """
157     assert msg.sender == AUTHORIZER_ADAPTOR
158     self.future_smart_wallet_checker = addr
159 
160 
161 @external
162 def apply_smart_wallet_checker():
163     """
164     @notice Apply setting external contract to check approved smart contract wallets
165     """
166     assert msg.sender == AUTHORIZER_ADAPTOR
167     self.smart_wallet_checker = self.future_smart_wallet_checker
168 
169 
170 @internal
171 def assert_not_contract(addr: address):
172     """
173     @notice Check if the call is from a whitelisted smart contract, revert if not
174     @param addr Address to be checked
175     """
176     if addr != tx.origin:
177         checker: address = self.smart_wallet_checker
178         if checker != ZERO_ADDRESS:
179             if SmartWalletChecker(checker).check(addr):
180                 return
181         raise "Smart contract depositors not allowed"
182 
183 
184 @external
185 @view
186 def get_last_user_slope(addr: address) -> int128:
187     """
188     @notice Get the most recently recorded rate of voting power decrease for `addr`
189     @param addr Address of the user wallet
190     @return Value of the slope
191     """
192     uepoch: uint256 = self.user_point_epoch[addr]
193     return self.user_point_history[addr][uepoch].slope
194 
195 
196 @external
197 @view
198 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
199     """
200     @notice Get the timestamp for checkpoint `_idx` for `_addr`
201     @param _addr User wallet address
202     @param _idx User epoch number
203     @return Epoch time of the checkpoint
204     """
205     return self.user_point_history[_addr][_idx].ts
206 
207 
208 @external
209 @view
210 def locked__end(_addr: address) -> uint256:
211     """
212     @notice Get timestamp when `_addr`'s lock finishes
213     @param _addr User wallet
214     @return Epoch time of the lock end
215     """
216     return self.locked[_addr].end
217 
218 
219 @internal
220 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
221     """
222     @notice Record global and per-user data to checkpoint
223     @param addr User's wallet address. No user checkpoint if 0x0
224     @param old_locked Pevious locked amount / end lock time for the user
225     @param new_locked New locked amount / end lock time for the user
226     """
227     u_old: Point = empty(Point)
228     u_new: Point = empty(Point)
229     old_dslope: int128 = 0
230     new_dslope: int128 = 0
231     _epoch: uint256 = self.epoch
232 
233     if addr != ZERO_ADDRESS:
234         # Calculate slopes and biases
235         # Kept at zero when they have to
236         if old_locked.end > block.timestamp and old_locked.amount > 0:
237             u_old.slope = old_locked.amount / MAXTIME
238             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
239         if new_locked.end > block.timestamp and new_locked.amount > 0:
240             u_new.slope = new_locked.amount / MAXTIME
241             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
242 
243         # Read values of scheduled changes in the slope
244         # old_locked.end can be in the past and in the future
245         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
246         old_dslope = self.slope_changes[old_locked.end]
247         if new_locked.end != 0:
248             if new_locked.end == old_locked.end:
249                 new_dslope = old_dslope
250             else:
251                 new_dslope = self.slope_changes[new_locked.end]
252 
253     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
254     if _epoch > 0:
255         last_point = self.point_history[_epoch]
256     last_checkpoint: uint256 = last_point.ts
257     # initial_last_point is used for extrapolation to calculate block number
258     # (approximately, for *At methods) and save them
259     # as we cannot figure that out exactly from inside the contract
260     initial_last_point: Point = last_point
261     block_slope: uint256 = 0  # dblock/dt
262     if block.timestamp > last_point.ts:
263         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
264     # If last point is already recorded in this block, slope=0
265     # But that's ok b/c we know the block in such case
266 
267     # Go over weeks to fill history and calculate what the current point is
268     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
269     for i in range(255):
270         # Hopefully it won't happen that this won't get used in 5 years!
271         # If it does, users will be able to withdraw but vote weight will be broken
272         t_i += WEEK
273         d_slope: int128 = 0
274         if t_i > block.timestamp:
275             t_i = block.timestamp
276         else:
277             d_slope = self.slope_changes[t_i]
278         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
279         last_point.slope += d_slope
280         if last_point.bias < 0:  # This can happen
281             last_point.bias = 0
282         if last_point.slope < 0:  # This cannot happen - just in case
283             last_point.slope = 0
284         last_checkpoint = t_i
285         last_point.ts = t_i
286         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
287         _epoch += 1
288         if t_i == block.timestamp:
289             last_point.blk = block.number
290             break
291         else:
292             self.point_history[_epoch] = last_point
293 
294     self.epoch = _epoch
295     # Now point_history is filled until t=now
296 
297     if addr != ZERO_ADDRESS:
298         # If last point was in this block, the slope change has been applied already
299         # But in such case we have 0 slope(s)
300         last_point.slope += (u_new.slope - u_old.slope)
301         last_point.bias += (u_new.bias - u_old.bias)
302         if last_point.slope < 0:
303             last_point.slope = 0
304         if last_point.bias < 0:
305             last_point.bias = 0
306 
307     # Record the changed point into history
308     self.point_history[_epoch] = last_point
309 
310     if addr != ZERO_ADDRESS:
311         # Schedule the slope changes (slope is going down)
312         # We subtract new_user_slope from [new_locked.end]
313         # and add old_user_slope to [old_locked.end]
314         if old_locked.end > block.timestamp:
315             # old_dslope was <something> - u_old.slope, so we cancel that
316             old_dslope += u_old.slope
317             if new_locked.end == old_locked.end:
318                 old_dslope -= u_new.slope  # It was a new deposit, not extension
319             self.slope_changes[old_locked.end] = old_dslope
320 
321         if new_locked.end > block.timestamp:
322             if new_locked.end > old_locked.end:
323                 new_dslope -= u_new.slope  # old slope disappeared at this point
324                 self.slope_changes[new_locked.end] = new_dslope
325             # else: we recorded it already in old_dslope
326 
327         # Now handle user history
328         user_epoch: uint256 = self.user_point_epoch[addr] + 1
329 
330         self.user_point_epoch[addr] = user_epoch
331         u_new.ts = block.timestamp
332         u_new.blk = block.number
333         self.user_point_history[addr][user_epoch] = u_new
334 
335 
336 @internal
337 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
338     """
339     @notice Deposit and lock tokens for a user
340     @param _addr User's wallet address
341     @param _value Amount to deposit
342     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
343     @param locked_balance Previous locked amount / timestamp
344     """
345     _locked: LockedBalance = locked_balance
346     supply_before: uint256 = self.supply
347 
348     self.supply = supply_before + _value
349     old_locked: LockedBalance = _locked
350     # Adding to existing lock, or if a lock is expired - creating a new one
351     _locked.amount += convert(_value, int128)
352     if unlock_time != 0:
353         _locked.end = unlock_time
354     self.locked[_addr] = _locked
355 
356     # Possibilities:
357     # Both old_locked.end could be current or expired (>/< block.timestamp)
358     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
359     # _locked.end > block.timestamp (always)
360     self._checkpoint(_addr, old_locked, _locked)
361 
362     if _value != 0:
363         assert ERC20(TOKEN).transferFrom(_addr, self, _value)
364 
365     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
366     log Supply(supply_before, supply_before + _value)
367 
368 
369 @external
370 def checkpoint():
371     """
372     @notice Record global data to checkpoint
373     """
374     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
375 
376 
377 @external
378 @nonreentrant('lock')
379 def deposit_for(_addr: address, _value: uint256):
380     """
381     @notice Deposit `_value` tokens for `_addr` and add to the lock
382     @dev Anyone (even a smart contract) can deposit for someone else, but
383          cannot extend their locktime and deposit for a brand new user
384     @param _addr User's wallet address
385     @param _value Amount to add to user's lock
386     """
387     _locked: LockedBalance = self.locked[_addr]
388 
389     assert _value > 0  # dev: need non-zero value
390     assert _locked.amount > 0, "No existing lock found"
391     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
392 
393     self._deposit_for(_addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
394 
395 
396 @external
397 @nonreentrant('lock')
398 def create_lock(_value: uint256, _unlock_time: uint256):
399     """
400     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
401     @param _value Amount to deposit
402     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
403     """
404     self.assert_not_contract(msg.sender)
405     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
406     _locked: LockedBalance = self.locked[msg.sender]
407 
408     assert _value > 0  # dev: need non-zero value
409     assert _locked.amount == 0, "Withdraw old tokens first"
410     assert unlock_time > block.timestamp, "Can only lock until time in the future"
411     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 1 year max"
412 
413     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
414 
415 
416 @external
417 @nonreentrant('lock')
418 def increase_amount(_value: uint256):
419     """
420     @notice Deposit `_value` additional tokens for `msg.sender`
421             without modifying the unlock time
422     @param _value Amount of tokens to deposit and add to the lock
423     """
424     self.assert_not_contract(msg.sender)
425     _locked: LockedBalance = self.locked[msg.sender]
426 
427     assert _value > 0  # dev: need non-zero value
428     assert _locked.amount > 0, "No existing lock found"
429     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
430 
431     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
432 
433 
434 @external
435 @nonreentrant('lock')
436 def increase_unlock_time(_unlock_time: uint256):
437     """
438     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
439     @param _unlock_time New epoch time for unlocking
440     """
441     self.assert_not_contract(msg.sender)
442     _locked: LockedBalance = self.locked[msg.sender]
443     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
444 
445     assert _locked.end > block.timestamp, "Lock expired"
446     assert _locked.amount > 0, "Nothing is locked"
447     assert unlock_time > _locked.end, "Can only increase lock duration"
448     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 1 year max"
449 
450     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
451 
452 
453 @external
454 @nonreentrant('lock')
455 def withdraw():
456     """
457     @notice Withdraw all tokens for `msg.sender`
458     @dev Only possible if the lock has expired
459     """
460     _locked: LockedBalance = self.locked[msg.sender]
461     assert block.timestamp >= _locked.end, "The lock didn't expire"
462     value: uint256 = convert(_locked.amount, uint256)
463 
464     old_locked: LockedBalance = _locked
465     _locked.end = 0
466     _locked.amount = 0
467     self.locked[msg.sender] = _locked
468     supply_before: uint256 = self.supply
469     self.supply = supply_before - value
470 
471     # old_locked can have either expired <= timestamp or zero end
472     # _locked has only 0 end
473     # Both can have >= 0 amount
474     self._checkpoint(msg.sender, old_locked, _locked)
475 
476     assert ERC20(TOKEN).transfer(msg.sender, value)
477 
478     log Withdraw(msg.sender, value, block.timestamp)
479     log Supply(supply_before, supply_before - value)
480 
481 
482 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
483 # They measure the weights for the purpose of voting, so they don't represent
484 # real coins.
485 
486 @internal
487 @view
488 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
489     """
490     @notice Binary search to find epoch containing block number
491     @param _block Block to find
492     @param max_epoch Don't go beyond this epoch
493     @return Epoch which contains _block
494     """
495     # Binary search
496     _min: uint256 = 0
497     _max: uint256 = max_epoch
498     for i in range(128):  # Will be always enough for 128-bit numbers
499         if _min >= _max:
500             break
501         _mid: uint256 = (_min + _max + 1) / 2
502         if self.point_history[_mid].blk <= _block:
503             _min = _mid
504         else:
505             _max = _mid - 1
506     return _min
507 
508 @internal
509 @view
510 def find_timestamp_epoch(_timestamp: uint256, max_epoch: uint256) -> uint256:
511     """
512     @notice Binary search to find epoch for timestamp
513     @param _timestamp timestamp to find
514     @param max_epoch Don't go beyond this epoch
515     @return Epoch which contains _timestamp
516     """
517     # Binary search
518     _min: uint256 = 0
519     _max: uint256 = max_epoch
520     for i in range(128):  # Will be always enough for 128-bit numbers
521         if _min >= _max:
522             break
523         _mid: uint256 = (_min + _max + 1) / 2
524         if self.point_history[_mid].ts <= _timestamp:
525             _min = _mid
526         else:
527             _max = _mid - 1
528     return _min
529 
530 @internal
531 @view
532 def find_block_user_epoch(_addr: address, _block: uint256, max_epoch: uint256) -> uint256:
533     """
534     @notice Binary search to find epoch for block number
535     @param _addr User for which to find user epoch for
536     @param _block Block to find
537     @param max_epoch Don't go beyond this epoch
538     @return Epoch which contains _block
539     """
540     # Binary search
541     _min: uint256 = 0
542     _max: uint256 = max_epoch
543     for i in range(128):  # Will be always enough for 128-bit numbers
544         if _min >= _max:
545             break
546         _mid: uint256 = (_min + _max + 1) / 2
547         if self.user_point_history[_addr][_mid].blk <= _block:
548             _min = _mid
549         else:
550             _max = _mid - 1
551     return _min
552 
553 @internal
554 @view
555 def find_timestamp_user_epoch(_addr: address, _timestamp: uint256, max_epoch: uint256) -> uint256:
556     """
557     @notice Binary search to find user epoch for timestamp
558     @param _addr User for which to find user epoch for
559     @param _timestamp timestamp to find
560     @param max_epoch Don't go beyond this epoch
561     @return Epoch which contains _timestamp
562     """
563     # Binary search
564     _min: uint256 = 0
565     _max: uint256 = max_epoch
566     for i in range(128):  # Will be always enough for 128-bit numbers
567         if _min >= _max:
568             break
569         _mid: uint256 = (_min + _max + 1) / 2
570         if self.user_point_history[_addr][_mid].ts <= _timestamp:
571             _min = _mid
572         else:
573             _max = _mid - 1
574     return _min
575 
576 @external
577 @view
578 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
579     """
580     @notice Get the current voting power for `msg.sender`
581     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
582     @param addr User wallet address
583     @param _t Epoch time to return voting power at
584     @return User voting power
585     """
586     _epoch: uint256 = 0
587     if _t == block.timestamp:
588         # No need to do binary search, will always live in current epoch
589         _epoch = self.user_point_epoch[addr]
590     else:
591         _epoch = self.find_timestamp_user_epoch(addr, _t, self.user_point_epoch[addr])
592 
593     if _epoch == 0:
594         return 0
595     else:
596         last_point: Point = self.user_point_history[addr][_epoch]
597         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
598         if last_point.bias < 0:
599             last_point.bias = 0
600         return convert(last_point.bias, uint256)
601 
602 
603 @external
604 @view
605 def balanceOfAt(addr: address, _block: uint256) -> uint256:
606     """
607     @notice Measure voting power of `addr` at block height `_block`
608     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
609     @param addr User's wallet address
610     @param _block Block to calculate the voting power at
611     @return Voting power
612     """
613     # Copying and pasting totalSupply code because Vyper cannot pass by
614     # reference yet
615     assert _block <= block.number
616 
617     _user_epoch: uint256 = self.find_block_user_epoch(addr, _block, self.user_point_epoch[addr])
618     upoint: Point = self.user_point_history[addr][_user_epoch]
619 
620     max_epoch: uint256 = self.epoch
621     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
622     point_0: Point = self.point_history[_epoch]
623     d_block: uint256 = 0
624     d_t: uint256 = 0
625     if _epoch < max_epoch:
626         point_1: Point = self.point_history[_epoch + 1]
627         d_block = point_1.blk - point_0.blk
628         d_t = point_1.ts - point_0.ts
629     else:
630         d_block = block.number - point_0.blk
631         d_t = block.timestamp - point_0.ts
632     block_time: uint256 = point_0.ts
633     if d_block != 0:
634         block_time += d_t * (_block - point_0.blk) / d_block
635 
636     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
637     if upoint.bias >= 0:
638         return convert(upoint.bias, uint256)
639     else:
640         return 0
641 
642 
643 @internal
644 @view
645 def supply_at(point: Point, t: uint256) -> uint256:
646     """
647     @notice Calculate total voting power at some point in the past
648     @param point The point (bias/slope) to start search from
649     @param t Time to calculate the total voting power at
650     @return Total voting power at that time
651     """
652     last_point: Point = point
653     t_i: uint256 = (last_point.ts / WEEK) * WEEK
654     for i in range(255):
655         t_i += WEEK
656         d_slope: int128 = 0
657         if t_i > t:
658             t_i = t
659         else:
660             d_slope = self.slope_changes[t_i]
661         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
662         if t_i == t:
663             break
664         last_point.slope += d_slope
665         last_point.ts = t_i
666 
667     if last_point.bias < 0:
668         last_point.bias = 0
669     return convert(last_point.bias, uint256)
670 
671 
672 @external
673 @view
674 def totalSupply(t: uint256 = block.timestamp) -> uint256:
675     """
676     @notice Calculate total voting power
677     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
678     @return Total voting power
679     """
680     _epoch: uint256 = 0
681     if t == block.timestamp:
682         # No need to do binary search, will always live in current epoch
683         _epoch = self.epoch
684     else:
685         _epoch = self.find_timestamp_epoch(t, self.epoch)
686 
687     if _epoch == 0:
688         return 0
689     else:
690         last_point: Point = self.point_history[_epoch]
691         return self.supply_at(last_point, t)
692 
693 
694 @external
695 @view
696 def totalSupplyAt(_block: uint256) -> uint256:
697     """
698     @notice Calculate total voting power at some point in the past
699     @param _block Block to calculate the total voting power at
700     @return Total voting power at `_block`
701     """
702     assert _block <= block.number
703     _epoch: uint256 = self.epoch
704     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
705 
706     point: Point = self.point_history[target_epoch]
707     dt: uint256 = 0
708     if target_epoch < _epoch:
709         point_next: Point = self.point_history[target_epoch + 1]
710         if point.blk != point_next.blk:
711             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
712     else:
713         if point.blk != block.number:
714             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
715     # Now dt contains info on how far are we beyond point
716 
717     return self.supply_at(point, point.ts + dt)