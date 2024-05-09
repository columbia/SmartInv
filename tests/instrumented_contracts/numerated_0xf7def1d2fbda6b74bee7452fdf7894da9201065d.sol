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
67 event DepositsLockedChange:
68     status: bool
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
86 
87 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
88 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
89 MULTIPLIER: constant(uint256) = 10 ** 18
90 
91 token: public(address)
92 supply: public(uint256)
93 
94 locked: public(HashMap[address, LockedBalance])
95 
96 epoch: public(uint256)
97 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
98 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
99 user_point_epoch: public(HashMap[address, uint256])
100 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
101 
102 # Aragon's view methods for compatibility
103 controller: public(address)
104 transfersEnabled: public(bool)
105 
106 
107 # Allows to unlock all deposits at once in exceptional scenarios
108 depositsLocked: public(bool)
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
123 
124 @external
125 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
126     """
127     @notice Contract constructor
128     @param token_addr `ERC20CRV` token address
129     @param _name Token name
130     @param _symbol Token symbol
131     @param _version Contract version - required for Aragon compatibility
132     """
133     self.admin = msg.sender
134     self.token = token_addr
135     self.point_history[0].blk = block.number
136     self.point_history[0].ts = block.timestamp
137     self.controller = msg.sender
138     self.transfersEnabled = True
139     self.depositsLocked = True
140 
141     _decimals: uint256 = ERC20(token_addr).decimals()
142     assert _decimals <= 255
143     self.decimals = _decimals
144 
145     self.name = _name
146     self.symbol = _symbol
147     self.version = _version
148 
149 
150 @external
151 def commit_transfer_ownership(addr: address):
152     """
153     @notice Transfer ownership of VotingEscrow contract to `addr`
154     @param addr Address to have ownership transferred to
155     """
156     assert msg.sender == self.admin  # dev: admin only
157     self.future_admin = addr
158     log CommitOwnership(addr)
159 
160 
161 @external
162 def set_depositsLocked(new_status: bool):
163     """
164     @notice Able / disable locks end restriction on withdraws
165     @param new_status Boolean to set as status of the variable
166     """
167     assert msg.sender == self.admin # dev: admin only
168     self.depositsLocked = new_status
169     log DepositsLockedChange(new_status)
170 
171 
172 @external
173 def apply_transfer_ownership():
174     """
175     @notice Apply ownership transfer
176     """
177     assert msg.sender == self.admin  # dev: admin only
178     _admin: address = self.future_admin
179     assert _admin != ZERO_ADDRESS  # dev: admin not set
180     self.admin = _admin
181     log ApplyOwnership(_admin)
182 
183 
184 @external
185 def commit_smart_wallet_checker(addr: address):
186     """
187     @notice Set an external contract to check for approved smart contract wallets
188     @param addr Address of Smart contract checker
189     """
190     assert msg.sender == self.admin
191     self.future_smart_wallet_checker = addr
192 
193 
194 @external
195 def apply_smart_wallet_checker():
196     """
197     @notice Apply setting external contract to check approved smart contract wallets
198     """
199     assert msg.sender == self.admin
200     self.smart_wallet_checker = self.future_smart_wallet_checker
201 
202 
203 @internal
204 def assert_not_contract(addr: address):
205     """
206     @notice Check if the call is from a whitelisted smart contract, revert if not
207     @param addr Address to be checked
208     """
209     if addr != tx.origin:
210         checker: address = self.smart_wallet_checker
211         if checker != ZERO_ADDRESS:
212             if SmartWalletChecker(checker).check(addr):
213                 return
214         raise "Smart contract depositors not allowed"
215 
216 
217 @external
218 @view
219 def get_last_user_slope(addr: address) -> int128:
220     """
221     @notice Get the most recently recorded rate of voting power decrease for `addr`
222     @param addr Address of the user wallet
223     @return Value of the slope
224     """
225     uepoch: uint256 = self.user_point_epoch[addr]
226     return self.user_point_history[addr][uepoch].slope
227 
228 
229 @external
230 @view
231 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
232     """
233     @notice Get the timestamp for checkpoint `_idx` for `_addr`
234     @param _addr User wallet address
235     @param _idx User epoch number
236     @return Epoch time of the checkpoint
237     """
238     return self.user_point_history[_addr][_idx].ts
239 
240 
241 @external
242 @view
243 def locked__end(_addr: address) -> uint256:
244     """
245     @notice Get timestamp when `_addr`'s lock finishes
246     @param _addr User wallet
247     @return Epoch time of the lock end
248     """
249     return self.locked[_addr].end
250 
251 
252 @internal
253 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
254     """
255     @notice Record global and per-user data to checkpoint
256     @param addr User's wallet address. No user checkpoint if 0x0
257     @param old_locked Pevious locked amount / end lock time for the user
258     @param new_locked New locked amount / end lock time for the user
259     """
260     u_old: Point = empty(Point)
261     u_new: Point = empty(Point)
262     old_dslope: int128 = 0
263     new_dslope: int128 = 0
264     _epoch: uint256 = self.epoch
265 
266     if addr != ZERO_ADDRESS:
267         # Calculate slopes and biases
268         # Kept at zero when they have to
269         if old_locked.end > block.timestamp and old_locked.amount > 0:
270             u_old.slope = old_locked.amount / MAXTIME
271             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
272         if new_locked.end > block.timestamp and new_locked.amount > 0:
273             u_new.slope = new_locked.amount / MAXTIME
274             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
275 
276         # Read values of scheduled changes in the slope
277         # old_locked.end can be in the past and in the future
278         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
279         old_dslope = self.slope_changes[old_locked.end]
280         if new_locked.end != 0:
281             if new_locked.end == old_locked.end:
282                 new_dslope = old_dslope
283             else:
284                 new_dslope = self.slope_changes[new_locked.end]
285 
286     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
287     if _epoch > 0:
288         last_point = self.point_history[_epoch]
289     last_checkpoint: uint256 = last_point.ts
290     # initial_last_point is used for extrapolation to calculate block number
291     # (approximately, for *At methods) and save them
292     # as we cannot figure that out exactly from inside the contract
293     initial_last_point: Point = last_point
294     block_slope: uint256 = 0  # dblock/dt
295     if block.timestamp > last_point.ts:
296         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
297     # If last point is already recorded in this block, slope=0
298     # But that's ok b/c we know the block in such case
299 
300     # Go over weeks to fill history and calculate what the current point is
301     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
302     for i in range(255):
303         # Hopefully it won't happen that this won't get used in 5 years!
304         # If it does, users will be able to withdraw but vote weight will be broken
305         t_i += WEEK
306         d_slope: int128 = 0
307         if t_i > block.timestamp:
308             t_i = block.timestamp
309         else:
310             d_slope = self.slope_changes[t_i]
311         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
312         last_point.slope += d_slope
313         if last_point.bias < 0:  # This can happen
314             last_point.bias = 0
315         if last_point.slope < 0:  # This cannot happen - just in case
316             last_point.slope = 0
317         last_checkpoint = t_i
318         last_point.ts = t_i
319         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
320         _epoch += 1
321         if t_i == block.timestamp:
322             last_point.blk = block.number
323             break
324         else:
325             self.point_history[_epoch] = last_point
326 
327     self.epoch = _epoch
328     # Now point_history is filled until t=now
329 
330     if addr != ZERO_ADDRESS:
331         # If last point was in this block, the slope change has been applied already
332         # But in such case we have 0 slope(s)
333         last_point.slope += (u_new.slope - u_old.slope)
334         last_point.bias += (u_new.bias - u_old.bias)
335         if last_point.slope < 0:
336             last_point.slope = 0
337         if last_point.bias < 0:
338             last_point.bias = 0
339 
340     # Record the changed point into history
341     self.point_history[_epoch] = last_point
342 
343     if addr != ZERO_ADDRESS:
344         # Schedule the slope changes (slope is going down)
345         # We subtract new_user_slope from [new_locked.end]
346         # and add old_user_slope to [old_locked.end]
347         if old_locked.end > block.timestamp:
348             # old_dslope was <something> - u_old.slope, so we cancel that
349             old_dslope += u_old.slope
350             if new_locked.end == old_locked.end:
351                 old_dslope -= u_new.slope  # It was a new deposit, not extension
352             self.slope_changes[old_locked.end] = old_dslope
353 
354         if new_locked.end > block.timestamp:
355             if new_locked.end > old_locked.end:
356                 new_dslope -= u_new.slope  # old slope disappeared at this point
357                 self.slope_changes[new_locked.end] = new_dslope
358             # else: we recorded it already in old_dslope
359 
360         # Now handle user history
361         user_epoch: uint256 = self.user_point_epoch[addr] + 1
362 
363         self.user_point_epoch[addr] = user_epoch
364         u_new.ts = block.timestamp
365         u_new.blk = block.number
366         self.user_point_history[addr][user_epoch] = u_new
367 
368 
369 @internal
370 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
371     """
372     @notice Deposit and lock tokens for a user
373     @param _addr User's wallet address
374     @param _value Amount to deposit
375     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
376     @param locked_balance Previous locked amount / timestamp
377     """
378     _locked: LockedBalance = locked_balance
379     supply_before: uint256 = self.supply
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
396         assert ERC20(self.token).transferFrom(_addr, self, _value)
397 
398     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
399     log Supply(supply_before, supply_before + _value)
400 
401 
402 @external
403 def checkpoint():
404     """
405     @notice Record global data to checkpoint
406     """
407     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
408 
409 
410 @external
411 @nonreentrant('lock')
412 def deposit_for(_addr: address, _value: uint256):
413     """
414     @notice Deposit `_value` tokens for `_addr` and add to the lock
415     @dev Anyone (even a smart contract) can deposit for someone else, but
416          cannot extend their locktime and deposit for a brand new user
417     @param _addr User's wallet address
418     @param _value Amount to add to user's lock
419     """
420     _locked: LockedBalance = self.locked[_addr]
421 
422     assert _value > 0  # dev: need non-zero value
423     assert _locked.amount > 0, "No existing lock found"
424     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
425 
426     self._deposit_for(_addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
427 
428 
429 @external
430 @nonreentrant('lock')
431 def create_lock(_value: uint256, _unlock_time: uint256):
432     """
433     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
434     @param _value Amount to deposit
435     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
436     """
437     self.assert_not_contract(msg.sender)
438     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
439     _locked: LockedBalance = self.locked[msg.sender]
440 
441     assert _value > 0  # dev: need non-zero value
442     assert _locked.amount == 0, "Withdraw old tokens first"
443     assert unlock_time > block.timestamp, "Can only lock until time in the future"
444     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
445 
446     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
447 
448 
449 @external
450 @nonreentrant('lock')
451 def increase_amount(_value: uint256):
452     """
453     @notice Deposit `_value` additional tokens for `msg.sender`
454             without modifying the unlock time
455     @param _value Amount of tokens to deposit and add to the lock
456     """
457     self.assert_not_contract(msg.sender)
458     _locked: LockedBalance = self.locked[msg.sender]
459 
460     assert _value > 0  # dev: need non-zero value
461     assert _locked.amount > 0, "No existing lock found"
462     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
463 
464     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
465 
466 
467 @external
468 @nonreentrant('lock')
469 def increase_unlock_time(_unlock_time: uint256):
470     """
471     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
472     @param _unlock_time New epoch time for unlocking
473     """
474     self.assert_not_contract(msg.sender)
475     _locked: LockedBalance = self.locked[msg.sender]
476     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
477 
478     assert _locked.end > block.timestamp, "Lock expired"
479     assert _locked.amount > 0, "Nothing is locked"
480     assert unlock_time > _locked.end, "Can only increase lock duration"
481     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
482 
483     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
484 
485 
486 @external
487 @nonreentrant('lock')
488 def withdraw():
489     """
490     @notice Withdraw all tokens for `msg.sender`
491     @dev Only possible if the lock has expired
492     """
493     _locked: LockedBalance = self.locked[msg.sender]
494     if self.depositsLocked:
495         assert block.timestamp >= _locked.end, "The lock didn't expire"
496     value: uint256 = convert(_locked.amount, uint256)
497 
498     old_locked: LockedBalance = _locked
499     _locked.end = 0
500     _locked.amount = 0
501     self.locked[msg.sender] = _locked
502     supply_before: uint256 = self.supply
503     self.supply = supply_before - value
504 
505     # old_locked can have either expired <= timestamp or zero end
506     # _locked has only 0 end
507     # Both can have >= 0 amount
508     self._checkpoint(msg.sender, old_locked, _locked)
509 
510     assert ERC20(self.token).transfer(msg.sender, value)
511 
512     log Withdraw(msg.sender, value, block.timestamp)
513     log Supply(supply_before, supply_before - value)
514 
515 
516 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
517 # They measure the weights for the purpose of voting, so they don't represent
518 # real coins.
519 
520 @internal
521 @view
522 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
523     """
524     @notice Binary search to estimate timestamp for block number
525     @param _block Block to find
526     @param max_epoch Don't go beyond this epoch
527     @return Approximate timestamp for block
528     """
529     # Binary search
530     _min: uint256 = 0
531     _max: uint256 = max_epoch
532     for i in range(128):  # Will be always enough for 128-bit numbers
533         if _min >= _max:
534             break
535         _mid: uint256 = (_min + _max + 1) / 2
536         if self.point_history[_mid].blk <= _block:
537             _min = _mid
538         else:
539             _max = _mid - 1
540     return _min
541 
542 
543 @external
544 @view
545 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
546     """
547     @notice Get the current voting power for `msg.sender`
548     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
549     @param addr User wallet address
550     @param _t Epoch time to return voting power at
551     @return User voting power
552     """
553     _epoch: uint256 = self.user_point_epoch[addr]
554     if _epoch == 0:
555         return 0
556     else:
557         last_point: Point = self.user_point_history[addr][_epoch]
558         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
559         if last_point.bias < 0:
560             last_point.bias = 0
561         return convert(last_point.bias, uint256)
562 
563 
564 @external
565 @view
566 def balanceOfAt(addr: address, _block: uint256) -> uint256:
567     """
568     @notice Measure voting power of `addr` at block height `_block`
569     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
570     @param addr User's wallet address
571     @param _block Block to calculate the voting power at
572     @return Voting power
573     """
574     # Copying and pasting totalSupply code because Vyper cannot pass by
575     # reference yet
576     assert _block <= block.number
577 
578     # Binary search
579     _min: uint256 = 0
580     _max: uint256 = self.user_point_epoch[addr]
581     for i in range(128):  # Will be always enough for 128-bit numbers
582         if _min >= _max:
583             break
584         _mid: uint256 = (_min + _max + 1) / 2
585         if self.user_point_history[addr][_mid].blk <= _block:
586             _min = _mid
587         else:
588             _max = _mid - 1
589 
590     upoint: Point = self.user_point_history[addr][_min]
591 
592     max_epoch: uint256 = self.epoch
593     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
594     point_0: Point = self.point_history[_epoch]
595     d_block: uint256 = 0
596     d_t: uint256 = 0
597     if _epoch < max_epoch:
598         point_1: Point = self.point_history[_epoch + 1]
599         d_block = point_1.blk - point_0.blk
600         d_t = point_1.ts - point_0.ts
601     else:
602         d_block = block.number - point_0.blk
603         d_t = block.timestamp - point_0.ts
604     block_time: uint256 = point_0.ts
605     if d_block != 0:
606         block_time += d_t * (_block - point_0.blk) / d_block
607 
608     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
609     if upoint.bias >= 0:
610         return convert(upoint.bias, uint256)
611     else:
612         return 0
613 
614 
615 @internal
616 @view
617 def supply_at(point: Point, t: uint256) -> uint256:
618     """
619     @notice Calculate total voting power at some point in the past
620     @param point The point (bias/slope) to start search from
621     @param t Time to calculate the total voting power at
622     @return Total voting power at that time
623     """
624     last_point: Point = point
625     t_i: uint256 = (last_point.ts / WEEK) * WEEK
626     for i in range(255):
627         t_i += WEEK
628         d_slope: int128 = 0
629         if t_i > t:
630             t_i = t
631         else:
632             d_slope = self.slope_changes[t_i]
633         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
634         if t_i == t:
635             break
636         last_point.slope += d_slope
637         last_point.ts = t_i
638 
639     if last_point.bias < 0:
640         last_point.bias = 0
641     return convert(last_point.bias, uint256)
642 
643 
644 @external
645 @view
646 def totalSupply(t: uint256 = block.timestamp) -> uint256:
647     """
648     @notice Calculate total voting power
649     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
650     @return Total voting power
651     """
652     _epoch: uint256 = self.epoch
653     last_point: Point = self.point_history[_epoch]
654     return self.supply_at(last_point, t)
655 
656 
657 @external
658 @view
659 def totalSupplyAt(_block: uint256) -> uint256:
660     """
661     @notice Calculate total voting power at some point in the past
662     @param _block Block to calculate the total voting power at
663     @return Total voting power at `_block`
664     """
665     assert _block <= block.number
666     _epoch: uint256 = self.epoch
667     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
668 
669     point: Point = self.point_history[target_epoch]
670     dt: uint256 = 0
671     if target_epoch < _epoch:
672         point_next: Point = self.point_history[target_epoch + 1]
673         if point.blk != point_next.blk:
674             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
675     else:
676         if point.blk != block.number:
677             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
678     # Now dt contains info on how far are we beyond point
679 
680     return self.supply_at(point, point.ts + dt)
681 
682 
683 # Dummy methods for compatibility with Aragon
684 
685 @external
686 def changeController(_newController: address):
687     """
688     @dev Dummy method required for Aragon compatibility
689     """
690     assert msg.sender == self.controller
691     self.controller = _newController