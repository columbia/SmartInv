1 # @version 0.3.0
2 """
3 @title Instrumental Finance Voting Escrow
4 @author Instrumental Finance
5 @license MIT 
6 @notice Votes (voting power) are time weighted to support 
7         commitment to the future of what the users are voting for
8 @dev Voting power decays linearly over time. Lock time cannot be
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
28     ts: uint256    # timestamp
29     blk: uint256   # block
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
71     locked_amount: int128
72     old_locktime: uint256
73     deposit_type: int128
74     ts: uint256
75 
76 event DepositFor:
77     provider: indexed(address)
78     receiver: indexed(address)
79     value: uint256
80     locktime: indexed(uint256)
81     locked_amount: int128
82     old_locktime: uint256
83     deposit_type: int128
84     ts: uint256
85 
86 event DepositDays:
87     user: indexed(address)
88     value: uint256
89     unlock_days: uint256
90 
91 event Withdraw:
92     provider: indexed(address)
93     value: uint256
94     ts: uint256
95 
96 event Supply:
97     prevSupply: uint256
98     supply: uint256
99 
100 
101 DAY: constant(uint256) = 86400 
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
134 
135 @external
136 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
137     """
138     @notice Contract constructor
139     @param token_addr `ERC20STRM` token address
140     @param _name Token name
141     @param _symbol Token symbol
142     @param _version Contract version - required for Aragon compatibility
143     """
144     self.admin = msg.sender
145     self.token = token_addr
146     self.point_history[0].blk = block.number
147     self.point_history[0].ts = block.timestamp
148     self.controller = msg.sender
149     self.transfersEnabled = True
150 
151     _decimals: uint256 = ERC20(token_addr).decimals()
152     assert _decimals <= 255
153     self.decimals = _decimals
154 
155     self.name = _name
156     self.symbol = _symbol
157     self.version = _version
158 
159 
160 @external
161 def commit_transfer_ownership(addr: address):
162     """
163     @notice Transfer ownership of VotingEscrow contract to `addr`
164     @param addr Address to have ownership transferred to
165     """
166     assert msg.sender == self.admin  # dev: admin only
167     self.future_admin = addr
168     log CommitOwnership(addr)
169 
170 
171 @external
172 def apply_transfer_ownership():
173     """
174     @notice Apply ownership transfer
175     """
176     assert msg.sender == self.admin  # dev: admin only
177     _admin: address = self.future_admin
178     assert _admin != ZERO_ADDRESS  # dev: admin not set
179     self.admin = _admin
180     log ApplyOwnership(_admin)
181 
182 
183 @external
184 def commit_smart_wallet_checker(addr: address):
185     """
186     @notice Set an external contract to check for approved smart contract wallets
187     @param addr Address of Smart contract checker
188     """
189     assert msg.sender == self.admin
190     self.future_smart_wallet_checker = addr
191 
192 
193 @external
194 def apply_smart_wallet_checker():
195     """
196     @notice Apply setting external contract to check approved smart contract wallets
197     """
198     assert msg.sender == self.admin
199     self.smart_wallet_checker = self.future_smart_wallet_checker
200 
201 
202 @internal
203 def assert_not_contract(addr: address):
204     """
205     @notice Check if the call is from a whitelisted smart contract, revert if not
206     @param addr Address to be checked
207     """
208     if addr != tx.origin:
209         checker: address = self.smart_wallet_checker
210         if checker != ZERO_ADDRESS:
211             if SmartWalletChecker(checker).check(addr):
212                 return
213         raise "Smart contract depositors not allowed"
214 
215 
216 @external
217 @view
218 def get_last_user_slope(addr: address) -> int128:
219     """
220     @notice Get the most recently recorded rate of voting power decrease for `addr`
221     @param addr Address of the user wallet
222     @return Value of the slope
223     """
224     uepoch: uint256 = self.user_point_epoch[addr]
225     return self.user_point_history[addr][uepoch].slope
226 
227 
228 @external
229 @view
230 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
231     """
232     @notice Get the timestamp for checkpoint `_idx` for `_addr`
233     @param _addr User wallet address
234     @param _idx User epoch number
235     @return Epoch time of the checkpoint
236     """
237     return self.user_point_history[_addr][_idx].ts
238 
239 
240 @external
241 @view
242 def locked__end(_addr: address) -> uint256:
243     """
244     @notice Get timestamp when `_addr`'s lock finishes
245     @param _addr User wallet
246     @return Epoch time of the lock end
247     """
248     return self.locked[_addr].end
249 
250 
251 @internal
252 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
253     """
254     @notice Record global and per-user data to checkpoint
255     @param addr User's wallet address. No user checkpoint if 0x0
256     @param old_locked Pevious locked amount / end lock time for the user
257     @param new_locked New locked amount / end lock time for the user
258     """
259     u_old: Point = empty(Point)
260     u_new: Point = empty(Point)
261     old_dslope: int128 = 0
262     new_dslope: int128 = 0
263     _epoch: uint256 = self.epoch
264 
265     if addr != ZERO_ADDRESS:
266         # Calculate slopes and biases
267         # Kept at zero when they have to
268         if old_locked.end > block.timestamp and old_locked.amount > 0:
269             u_old.slope = old_locked.amount / MAXTIME
270             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
271         if new_locked.end > block.timestamp and new_locked.amount > 0:
272             u_new.slope = new_locked.amount / MAXTIME
273             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
274 
275         # Read values of scheduled changes in the slope
276         # old_locked.end can be in the past and in the future
277         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
278         old_dslope = self.slope_changes[old_locked.end]
279         if new_locked.end != 0:
280             if new_locked.end == old_locked.end:
281                 new_dslope = old_dslope
282             else:
283                 new_dslope = self.slope_changes[new_locked.end]
284 
285     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
286     if _epoch > 0:
287         last_point = self.point_history[_epoch]
288     last_checkpoint: uint256 = last_point.ts
289     # initial_last_point is used for extrapolation to calculate block number
290     # (approximately, for *At methods) and save them
291     # as we cannot figure that out exactly from inside the contract
292     initial_last_point: Point = last_point
293     block_slope: uint256 = 0  # dblock/dt
294     if block.timestamp > last_point.ts:
295         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
296     # If last point is already recorded in this block, slope=0
297     # But that's ok b/c we know the block in such case
298 
299     # Go over weeks to fill history and calculate what the current point is
300     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
301     for i in range(255):
302         # Hopefully it won't happen that this won't get used in 5 years!
303         # If it does, users will be able to withdraw but vote weight will be broken
304         t_i += WEEK
305         d_slope: int128 = 0
306         if t_i > block.timestamp:
307             t_i = block.timestamp
308         else:
309             d_slope = self.slope_changes[t_i]
310         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
311         last_point.slope += d_slope
312         if last_point.bias < 0:  # This can happen
313             last_point.bias = 0
314         if last_point.slope < 0:  # This cannot happen - just in case
315             last_point.slope = 0
316         last_checkpoint = t_i
317         last_point.ts = t_i
318         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
319         _epoch += 1
320         if t_i == block.timestamp:
321             last_point.blk = block.number
322             break
323         else:
324             self.point_history[_epoch] = last_point
325 
326     self.epoch = _epoch
327     # Now point_history is filled until t=now
328 
329     if addr != ZERO_ADDRESS:
330         # If last point was in this block, the slope change has been applied already
331         # But in such case we have 0 slope(s)
332         last_point.slope += (u_new.slope - u_old.slope)
333         last_point.bias += (u_new.bias - u_old.bias)
334         if last_point.slope < 0:
335             last_point.slope = 0
336         if last_point.bias < 0:
337             last_point.bias = 0
338 
339     # Record the changed point into history
340     self.point_history[_epoch] = last_point
341 
342     if addr != ZERO_ADDRESS:
343         # Schedule the slope changes (slope is going down)
344         # We subtract new_user_slope from [new_locked.end]
345         # and add old_user_slope to [old_locked.end]
346         if old_locked.end > block.timestamp:
347             # old_dslope was <something> - u_old.slope, so we cancel that
348             old_dslope += u_old.slope
349             if new_locked.end == old_locked.end:
350                 old_dslope -= u_new.slope  # It was a new deposit, not extension
351             self.slope_changes[old_locked.end] = old_dslope
352 
353         if new_locked.end > block.timestamp:
354             if new_locked.end > old_locked.end:
355                 new_dslope -= u_new.slope  # old slope disappeared at this point
356                 self.slope_changes[new_locked.end] = new_dslope
357             # else: we recorded it already in old_dslope
358 
359         # Now handle user history
360         user_epoch: uint256 = self.user_point_epoch[addr] + 1
361 
362         self.user_point_epoch[addr] = user_epoch
363         u_new.ts = block.timestamp
364         u_new.blk = block.number
365         self.user_point_history[addr][user_epoch] = u_new
366 
367 
368 @internal
369 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, depositType: int128):
370     """
371     @notice Deposit and lock tokens for a user
372     @param _addr User's wallet address
373     @param _value Amount to deposit
374     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
375     @param locked_balance Previous locked amount / timestamp
376     """
377     _locked: LockedBalance = locked_balance
378     supply_before: uint256 = self.supply
379 
380     self.supply = supply_before + _value
381     old_locked: LockedBalance = _locked
382     # Adding to existing lock, or if a lock is expired - creating a new one
383     _locked.amount += convert(_value, int128)
384     if unlock_time != 0:
385         _locked.end = unlock_time
386     self.locked[_addr] = _locked
387 
388     # Possibilities:
389     # Both old_locked.end could be current or expired (>/< block.timestamp)
390     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
391     # _locked.end > block.timestamp (always)
392     self._checkpoint(_addr, old_locked, _locked)
393 
394     if _value != 0:
395         assert ERC20(self.token).transferFrom(_addr, self, _value)
396 
397     log Deposit(_addr, _value, _locked.end, _locked.amount, old_locked.end, depositType, block.timestamp)
398     log Supply(supply_before, supply_before + _value)
399 
400 
401 @internal
402 def _deposit_from_for(_addr_from: address, _addr_for: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, depositType: int128):
403     """
404     @notice Deposit and lock tokens for a user
405     @param _addr_from Depositor's wallet address
406     @param _addr_for User's wallet address
407     @param _value Amount to deposit
408     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
409     @param locked_balance Previous locked amount / timestamp
410     """
411     _locked: LockedBalance = locked_balance
412     supply_before: uint256 = self.supply
413 
414     self.supply = supply_before + _value
415     old_locked: LockedBalance = _locked
416     # Adding to existing lock, or if a lock is expired - creating a new one
417     _locked.amount += convert(_value, int128)
418     if unlock_time != 0:
419         _locked.end = unlock_time
420     self.locked[_addr_for] = _locked
421 
422     # Possibilities:
423     # Both old_locked.end could be current or expired (>/< block.timestamp)
424     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
425     # _locked.end > block.timestamp (always)
426     self._checkpoint(_addr_for, old_locked, _locked)
427 
428     if _value != 0:
429         assert ERC20(self.token).transferFrom(_addr_from, self, _value)
430 
431     log Deposit(_addr_for, _value, _locked.end, _locked.amount, old_locked.end, depositType, block.timestamp)
432     log DepositFor(_addr_from, _addr_for, _value, _locked.end, _locked.amount, old_locked.end, depositType, block.timestamp)
433     log Supply(supply_before, supply_before + _value)
434 
435 
436 @external
437 def checkpoint():
438     """
439     @notice Record global data to checkpoint
440     """
441     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
442 
443 
444 @external
445 @nonreentrant('lock')
446 def deposit_for(_addr: address, _value: uint256):
447     """
448     @notice Deposit `_value` tokens for `_addr` and add to the lock
449     @dev Anyone (even a smart contract) can deposit for someone else, but
450          cannot extend their locktime and deposit for a brand new user
451     @param _addr User's wallet address
452     @param _value Amount to add to user's lock
453     """
454     _locked: LockedBalance = self.locked[_addr]
455 
456     assert _value > 0  # dev: need non-zero value
457     assert _locked.amount > 0, "No existing lock found"
458     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
459 
460     self._deposit_from_for(msg.sender, _addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
461 
462 
463 @external
464 @nonreentrant('lock')
465 def create_lock(_value: uint256, _unlock_time: uint256):
466     """
467     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
468     @param _value Amount to deposit
469     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
470     """
471     self.assert_not_contract(msg.sender)
472     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
473     _locked: LockedBalance = self.locked[msg.sender]
474 
475     assert _value > 0  # dev: need non-zero value
476     assert _locked.amount == 0, "Withdraw old tokens first"
477     assert unlock_time > block.timestamp, "Can only lock until time in the future"
478     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
479 
480     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
481 
482 
483 @external
484 @nonreentrant('lock')
485 def create_lock_days(_value: uint256, _unlock_days: uint256):
486     """
487     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_days` * DAY
488     @param _value Amount to deposit
489     @param _unlock_days Days qty when tokens unlock, starting from this tx block timestamp
490     """
491     self.assert_not_contract(msg.sender)
492     unlock_time: uint256 = ((block.timestamp + _unlock_days * DAY) / WEEK) * WEEK
493     _locked: LockedBalance = self.locked[msg.sender]
494 
495     assert _value > 0  # dev: need non-zero value
496     assert _locked.amount == 0, "Withdraw old tokens first"
497     assert unlock_time > block.timestamp, "Can only lock until time in the future"
498     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
499 
500     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
501     log DepositDays(msg.sender, _value, _unlock_days)
502 
503 
504 @external
505 @nonreentrant('lock')
506 def increase_amount(_value: uint256):
507     """
508     @notice Deposit `_value` additional tokens for `msg.sender`
509             without modifying the unlock time
510     @param _value Amount of tokens to deposit and add to the lock
511     """
512     self.assert_not_contract(msg.sender)
513     _locked: LockedBalance = self.locked[msg.sender]
514 
515     assert _value > 0  # dev: need non-zero value
516     assert _locked.amount > 0, "No existing lock found"
517     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
518 
519     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
520 
521     log DepositDays(msg.sender, _value, 0)
522 
523 
524 @external
525 @nonreentrant('lock')
526 def increase_unlock_time(_unlock_time: uint256):
527     """
528     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
529     @param _unlock_time New epoch time for unlocking
530     """
531     self.assert_not_contract(msg.sender)
532     _locked: LockedBalance = self.locked[msg.sender]
533     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
534 
535     assert _locked.end > block.timestamp, "Lock expired"
536     assert _locked.amount > 0, "Nothing is locked"
537     assert unlock_time > _locked.end, "Can only increase lock duration"
538     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
539 
540     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
541 
542 
543 @external
544 @nonreentrant('lock')
545 def increase_unlock_time_days(_unlock_days: uint256):
546     """
547     @notice Extend the unlock time for `msg.sender` to `_unlock_days` * DAY
548     @param _unlock_days Difference in days from the previous locktime
549     """
550     self.assert_not_contract(msg.sender)
551     _locked: LockedBalance = self.locked[msg.sender]
552     unlock_time: uint256 = ((_locked.end + _unlock_days * DAY) / WEEK) * WEEK
553 
554     assert _locked.end > block.timestamp, "Lock expired"
555     assert _locked.amount > 0, "Nothing is locked"
556     assert unlock_time > _locked.end, "Can only increase lock duration"
557     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
558 
559     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
560     
561     log DepositDays(msg.sender, 0, _unlock_days)
562 
563 
564 @external
565 @nonreentrant('lock')
566 def withdraw():
567     """
568     @notice Withdraw all tokens for `msg.sender`
569     @dev Only possible if the lock has expired
570     """
571     _locked: LockedBalance = self.locked[msg.sender]
572     assert block.timestamp >= _locked.end, "The lock didn't expire"
573     value: uint256 = convert(_locked.amount, uint256)
574 
575     old_locked: LockedBalance = _locked
576     _locked.end = 0
577     _locked.amount = 0
578     self.locked[msg.sender] = _locked
579     supply_before: uint256 = self.supply
580     self.supply = supply_before - value
581 
582     # old_locked can have either expired <= timestamp or zero end
583     # _locked has only 0 end
584     # Both can have >= 0 amount
585     self._checkpoint(msg.sender, old_locked, _locked)
586 
587     assert ERC20(self.token).transfer(msg.sender, value)
588 
589     log Withdraw(msg.sender, value, block.timestamp)
590     log Supply(supply_before, supply_before - value)
591 
592 
593 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
594 # They measure the weights for the purpose of voting, so they don't represent
595 # real coins.
596 
597 @internal
598 @view
599 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
600     """
601     @notice Binary search to estimate timestamp for block number
602     @param _block Block to find
603     @param max_epoch Don't go beyond this epoch
604     @return Approximate timestamp for block
605     """
606     # Binary search
607     _min: uint256 = 0
608     _max: uint256 = max_epoch
609     for i in range(128):  # Will be always enough for 128-bit numbers
610         if _min >= _max:
611             break
612         _mid: uint256 = (_min + _max + 1) / 2
613         if self.point_history[_mid].blk <= _block:
614             _min = _mid
615         else:
616             _max = _mid - 1
617     return _min
618 
619 @internal
620 @view
621 def _find_user_block_epoch(_user: address, _block: uint256, _max_epoch: uint256) -> uint256:
622     """
623     @notice Binary search to estimate timestamp for block number
624     @param _block Block to find
625     @param max_epoch Don't go beyond this epoch
626     @return Approximate timestamp for block
627     """
628     # Binary search
629     _min: uint256 = 0
630     _max: uint256 = _max_epoch
631     if _max == 0:
632         _max = self.user_point_epoch[_user]
633     
634     for i in range(128):  # Will be always enough for 128-bit numbers
635         if _min >= _max:
636             break
637         _mid: uint256 = (_min + _max + 1) / 2
638         if self.user_point_history[_user][_mid].blk <= _block:
639             _min = _mid
640         else:
641             _max = _mid - 1
642     return _min
643 
644 @external
645 @view
646 def get_user_block_point(_addr: address, _block: uint256) -> Point:
647     """
648     @notice Get user Point at a given block number
649     @param _block Block to find the block at
650     @return Approximate timestamp for block
651     """
652     # Binary search
653     _user_block_epoch: uint256 = self._find_user_block_epoch(_addr, _block, 0)
654     return self.user_point_history[_addr][_user_block_epoch]
655 
656 @external
657 @view
658 def balanceOf(addr: address) -> uint256:
659     """
660     @notice Get the current voting power for `addr`
661     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
662     @param addr User wallet address
663     @return User voting power
664     """
665     _t: uint256 = block.timestamp # epoch time to return voting power at
666     _epoch: uint256 = self.user_point_epoch[addr]
667     if _epoch == 0:
668         return 0
669     else:
670         last_point: Point = self.user_point_history[addr][_epoch]
671         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
672         if last_point.bias < 0:
673             last_point.bias = 0
674         return convert(last_point.bias, uint256)
675 
676 @external
677 @view
678 def balanceOfAt(addr: address, _t: uint256) -> uint256:
679     """
680     @notice Get voting power for addr at `_t` time current or in the future
681     @dev Throws when trying to pass time `_t` in the past
682     @param addr User wallet address
683     @param _t Epoch time to return voting power at
684     @return User voting power
685     """
686     _epoch: uint256 = self.user_point_epoch[addr]
687     if _epoch == 0:
688         return 0
689     else:
690         last_point: Point = self.user_point_history[addr][_epoch]
691         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
692         if last_point.bias < 0:
693             last_point.bias = 0
694         return convert(last_point.bias, uint256)
695 
696 
697 @external
698 @view
699 def balanceOfAtBlock(addr: address, _block: uint256) -> uint256:
700     """
701     @notice Measure voting power of `addr` at block height `_block`
702     @dev Adheres to MiniMe `balanceOfAtBlock` interface: https://github.com/Giveth/minime
703     @param addr User's wallet address
704     @param _block Block to calculate the voting power at
705     @return Voting power
706     """
707     # Copying and pasting totalSupply code because Vyper cannot pass by
708     # reference yet
709     assert _block <= block.number
710 
711     # Binary search
712     _min: uint256 = 0
713     _max: uint256 = self.user_point_epoch[addr]
714     for i in range(128):  # Will be always enough for 128-bit numbers
715         if _min >= _max:
716             break
717         _mid: uint256 = (_min + _max + 1) / 2
718         if self.user_point_history[addr][_mid].blk <= _block:
719             _min = _mid
720         else:
721             _max = _mid - 1
722 
723     upoint: Point = self.user_point_history[addr][_min]
724 
725     max_epoch: uint256 = self.epoch
726     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
727     point_0: Point = self.point_history[_epoch]
728     d_block: uint256 = 0
729     d_t: uint256 = 0
730     if _epoch < max_epoch:
731         point_1: Point = self.point_history[_epoch + 1]
732         d_block = point_1.blk - point_0.blk
733         d_t = point_1.ts - point_0.ts
734     else:
735         d_block = block.number - point_0.blk
736         d_t = block.timestamp - point_0.ts
737     block_time: uint256 = point_0.ts
738     if d_block != 0:
739         block_time += d_t * (_block - point_0.blk) / d_block
740 
741     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
742     if upoint.bias >= 0:
743         return convert(upoint.bias, uint256)
744     else:
745         return 0
746 
747 
748 @internal
749 @view
750 def supply_at(point: Point, t: uint256) -> uint256:
751     """
752     @notice Calculate total voting power at some point in the past
753     @param point The point (bias/slope) to start search from
754     @param t Time to calculate the total voting power at
755     @return Total voting power at that time
756     """
757     last_point: Point = point
758     t_i: uint256 = (last_point.ts / WEEK) * WEEK
759     for i in range(255):
760         t_i += WEEK
761         d_slope: int128 = 0
762         if t_i > t:
763             t_i = t
764         else:
765             d_slope = self.slope_changes[t_i]
766         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
767         if t_i == t:
768             break
769         last_point.slope += d_slope
770         last_point.ts = t_i
771 
772     if last_point.bias < 0:
773         last_point.bias = 0
774     return convert(last_point.bias, uint256)
775 
776 
777 @external
778 @view
779 def totalSupply() -> uint256:
780     """
781     @notice Calculate total voting power
782     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
783     @return Total voting power
784     """
785     t: uint256 = block.timestamp
786     _epoch: uint256 = self.epoch
787     last_point: Point = self.point_history[_epoch]
788     return self.supply_at(last_point, t)
789 
790 @external
791 @view
792 def totalSupplyAt(t: uint256) -> uint256:
793     """
794     @notice Calculate total voting power
795     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
796     @param t Time to calculate the total voting power at
797     @return Total voting power
798     """
799     _epoch: uint256 = self.epoch
800     last_point: Point = self.point_history[_epoch]
801     return self.supply_at(last_point, t)
802 
803 
804 @external
805 @view
806 def totalSupplyAtBlock(_block: uint256) -> uint256:
807     """
808     @notice Calculate total voting power at some point in the past
809     @param _block Block to calculate the total voting power at
810     @return Total voting power at `_block`
811     """
812     assert _block <= block.number
813     _epoch: uint256 = self.epoch
814     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
815 
816     point: Point = self.point_history[target_epoch]
817     dt: uint256 = 0
818     if target_epoch < _epoch:
819         point_next: Point = self.point_history[target_epoch + 1]
820         if point.blk != point_next.blk:
821             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
822     else:
823         if point.blk != block.number:
824             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
825     # Now dt contains info on how far are we beyond point
826 
827     return self.supply_at(point, point.ts + dt)
828 
829 
830 # Dummy methods for compatibility with Aragon
831 
832 @external
833 def changeController(_newController: address):
834     """
835     @dev Dummy method required for Aragon compatibility
836     """
837     assert msg.sender == self.controller
838     self.controller = _newController