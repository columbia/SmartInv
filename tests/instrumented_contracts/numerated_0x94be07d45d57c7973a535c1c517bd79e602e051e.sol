1 # @version 0.3.1
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
12 # Original idea and credit:
13 # Curve Finance's veCRV
14 # https://resources.curve.fi/faq/vote-locking-boost
15 # https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/VotingEscrow.vy
16 # This contract is an almost-identical fork of Curve's contract
17 
18 # Voting escrow to have time-weighted votes
19 # Votes have a weight depending on time, so that users are committed
20 # to the future of (whatever they are voting for).
21 # The weight in this implementation is linear, and lock cannot be more than maxtime:
22 # w ^
23 # 1 +        /
24 #   |      /
25 #   |    /
26 #   |  /
27 #   |/
28 # 0 +--------+------> time
29 #       maxtime (4 years?)
30 
31 struct Point:
32     bias: int128
33     slope: int128  # - dweight / dt
34     ts: uint256
35     blk: uint256  # block
36 # We cannot really do block numbers per se b/c slope is per time, not per block
37 # and per block could be fairly bad b/c Ethereum changes blocktimes.
38 # What we can do is to extrapolate ***At functions
39 
40 struct LockedBalance:
41     amount: int128
42     end: uint256
43 
44 
45 interface ERC20:
46     def decimals() -> uint256: view
47     def name() -> String[64]: view
48     def symbol() -> String[32]: view
49     def transfer(to: address, amount: uint256) -> bool: nonpayable
50     def transferFrom(spender: address, to: address, amount: uint256) -> bool: nonpayable
51 
52 
53 # Interface for checking whether address belongs to a whitelisted
54 # type of a smart wallet.
55 # When new types are added - the whole contract is changed
56 # The check() method is modifying to be able to use caching
57 # for individual wallet addresses
58 interface SmartWalletChecker:
59     def check(addr: address) -> bool: nonpayable
60 
61 DEPOSIT_FOR_TYPE: constant(int128) = 0
62 CREATE_LOCK_TYPE: constant(int128) = 1
63 INCREASE_LOCK_AMOUNT: constant(int128) = 2
64 INCREASE_UNLOCK_TIME: constant(int128) = 3
65 
66 
67 event CommitOwnership:
68     admin: address
69 
70 event ApplyOwnership:
71     admin: address
72 
73 event Deposit:
74     provider: indexed(address)
75     value: uint256
76     locktime: indexed(uint256)
77     type: int128
78     ts: uint256
79 
80 event Withdraw:
81     provider: indexed(address)
82     value: uint256
83     ts: uint256
84 
85 event Supply:
86     prevSupply: uint256
87     supply: uint256
88 
89 
90 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
91 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
92 MULTIPLIER: constant(uint256) = 10 ** 18
93 
94 token: public(address)
95 supply: public(uint256)
96 
97 locked: public(HashMap[address, LockedBalance])
98 
99 epoch: public(uint256)
100 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
101 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
102 user_point_epoch: public(HashMap[address, uint256])
103 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
104 
105 # Aragon's view methods for compatibility
106 controller: public(address)
107 transfersEnabled: public(bool)
108 
109 name: public(String[64])
110 symbol: public(String[32])
111 version: public(String[32])
112 decimals: public(uint256)
113 
114 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
115 # The goal is to prevent tokenizing the escrow
116 future_smart_wallet_checker: public(address)
117 smart_wallet_checker: public(address)
118 
119 admin: public(address)  # Can and will be a smart contract
120 future_admin: public(address)
121 
122 
123 @external
124 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
125     """
126     @notice Contract constructor
127     @param token_addr `ERC20 ACT` token address
128     @param _name Token name
129     @param _symbol Token symbol
130     @param _version Contract version - required for Aragon compatibility
131     """
132     self.admin = msg.sender
133     self.token = token_addr
134     self.point_history[0].blk = block.number
135     self.point_history[0].ts = block.timestamp
136     self.controller = msg.sender
137     self.transfersEnabled = True
138 
139     _decimals: uint256 = ERC20(token_addr).decimals()
140     assert _decimals <= 255
141     self.decimals = _decimals
142 
143     self.name = _name
144     self.symbol = _symbol
145     self.version = _version
146 
147 
148 @external
149 def commit_transfer_ownership(addr: address):
150     """
151     @notice Transfer ownership of VotingEscrow contract to `addr`
152     @param addr Address to have ownership transferred to
153     """
154     assert msg.sender == self.admin  # dev: admin only
155     self.future_admin = addr
156     log CommitOwnership(addr)
157 
158 
159 @external
160 def apply_transfer_ownership():
161     """
162     @notice Apply ownership transfer
163     """
164     assert msg.sender == self.admin  # dev: admin only
165     _admin: address = self.future_admin
166     assert _admin != ZERO_ADDRESS  # dev: admin not set
167     self.admin = _admin
168     log ApplyOwnership(_admin)
169 
170 
171 @external
172 def commit_smart_wallet_checker(addr: address):
173     """
174     @notice Set an external contract to check for approved smart contract wallets
175     @param addr Address of Smart contract checker
176     """
177     assert msg.sender == self.admin
178     self.future_smart_wallet_checker = addr
179 
180 
181 @external
182 def apply_smart_wallet_checker():
183     """
184     @notice Apply setting external contract to check approved smart contract wallets
185     """
186     assert msg.sender == self.admin
187     self.smart_wallet_checker = self.future_smart_wallet_checker
188 
189 
190 @internal
191 def assert_not_contract(addr: address):
192     """
193     @notice Check if the call is from a whitelisted smart contract, revert if not
194     @param addr Address to be checked
195     """
196     if addr != tx.origin:
197         checker: address = self.smart_wallet_checker
198         if checker != ZERO_ADDRESS:
199             if SmartWalletChecker(checker).check(addr):
200                 return
201         raise "Smart contract depositors not allowed"
202 
203 
204 @external
205 @view
206 def get_last_user_slope(addr: address) -> int128:
207     """
208     @notice Get the most recently recorded rate of voting power decrease for `addr`
209     @param addr Address of the user wallet
210     @return Value of the slope
211     """
212     uepoch: uint256 = self.user_point_epoch[addr]
213     return self.user_point_history[addr][uepoch].slope
214 
215 
216 @external
217 @view
218 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
219     """
220     @notice Get the timestamp for checkpoint `_idx` for `_addr`
221     @param _addr User wallet address
222     @param _idx User epoch number
223     @return Epoch time of the checkpoint
224     """
225     return self.user_point_history[_addr][_idx].ts
226 
227 
228 @external
229 @view
230 def locked__end(_addr: address) -> uint256:
231     """
232     @notice Get timestamp when `_addr`'s lock finishes
233     @param _addr User wallet
234     @return Epoch time of the lock end
235     """
236     return self.locked[_addr].end
237 
238 
239 @internal
240 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
241     """
242     @notice Record global and per-user data to checkpoint
243     @param addr User's wallet address. No user checkpoint if 0x0
244     @param old_locked Pevious locked amount / end lock time for the user
245     @param new_locked New locked amount / end lock time for the user
246     """
247     u_old: Point = empty(Point)
248     u_new: Point = empty(Point)
249     old_dslope: int128 = 0
250     new_dslope: int128 = 0
251     _epoch: uint256 = self.epoch
252 
253     if addr != ZERO_ADDRESS:
254         # Calculate slopes and biases
255         # Kept at zero when they have to
256         if old_locked.end > block.timestamp and old_locked.amount > 0:
257             u_old.slope = old_locked.amount / MAXTIME
258             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
259         if new_locked.end > block.timestamp and new_locked.amount > 0:
260             u_new.slope = new_locked.amount / MAXTIME
261             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
262 
263         # Read values of scheduled changes in the slope
264         # old_locked.end can be in the past and in the future
265         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
266         old_dslope = self.slope_changes[old_locked.end]
267         if new_locked.end != 0:
268             if new_locked.end == old_locked.end:
269                 new_dslope = old_dslope
270             else:
271                 new_dslope = self.slope_changes[new_locked.end]
272 
273     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
274     if _epoch > 0:
275         last_point = self.point_history[_epoch]
276     last_checkpoint: uint256 = last_point.ts
277     # initial_last_point is used for extrapolation to calculate block number
278     # (approximately, for *At methods) and save them
279     # as we cannot figure that out exactly from inside the contract
280     initial_last_point: Point = last_point
281     block_slope: uint256 = 0  # dblock/dt
282     if block.timestamp > last_point.ts:
283         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
284     # If last point is already recorded in this block, slope=0
285     # But that's ok b/c we know the block in such case
286 
287     # Go over weeks to fill history and calculate what the current point is
288     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
289     for i in range(255):
290         # Hopefully it won't happen that this won't get used in 5 years!
291         # If it does, users will be able to withdraw but vote weight will be broken
292         t_i += WEEK
293         d_slope: int128 = 0
294         if t_i > block.timestamp:
295             t_i = block.timestamp
296         else:
297             d_slope = self.slope_changes[t_i]
298         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
299         last_point.slope += d_slope
300         if last_point.bias < 0:  # This can happen
301             last_point.bias = 0
302         if last_point.slope < 0:  # This cannot happen - just in case
303             last_point.slope = 0
304         last_checkpoint = t_i
305         last_point.ts = t_i
306         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
307         _epoch += 1
308         if t_i == block.timestamp:
309             last_point.blk = block.number
310             break
311         else:
312             self.point_history[_epoch] = last_point
313 
314     self.epoch = _epoch
315     # Now point_history is filled until t=now
316 
317     if addr != ZERO_ADDRESS:
318         # If last point was in this block, the slope change has been applied already
319         # But in such case we have 0 slope(s)
320         last_point.slope += (u_new.slope - u_old.slope)
321         last_point.bias += (u_new.bias - u_old.bias)
322         if last_point.slope < 0:
323             last_point.slope = 0
324         if last_point.bias < 0:
325             last_point.bias = 0
326 
327     # Record the changed point into history
328     self.point_history[_epoch] = last_point
329 
330     if addr != ZERO_ADDRESS:
331         # Schedule the slope changes (slope is going down)
332         # We subtract new_user_slope from [new_locked.end]
333         # and add old_user_slope to [old_locked.end]
334         if old_locked.end > block.timestamp:
335             # old_dslope was <something> - u_old.slope, so we cancel that
336             old_dslope += u_old.slope
337             if new_locked.end == old_locked.end:
338                 old_dslope -= u_new.slope  # It was a new deposit, not extension
339             self.slope_changes[old_locked.end] = old_dslope
340 
341         if new_locked.end > block.timestamp:
342             if new_locked.end > old_locked.end:
343                 new_dslope -= u_new.slope  # old slope disappeared at this point
344                 self.slope_changes[new_locked.end] = new_dslope
345             # else: we recorded it already in old_dslope
346 
347         # Now handle user history
348         user_epoch: uint256 = self.user_point_epoch[addr] + 1
349 
350         self.user_point_epoch[addr] = user_epoch
351         u_new.ts = block.timestamp
352         u_new.blk = block.number
353         self.user_point_history[addr][user_epoch] = u_new
354 
355 
356 @internal
357 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
358     """
359     @notice Deposit and lock tokens for a user
360     @param _addr User's wallet address
361     @param _value Amount to deposit
362     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
363     @param locked_balance Previous locked amount / timestamp
364     """
365     _locked: LockedBalance = locked_balance
366     supply_before: uint256 = self.supply
367 
368     self.supply = supply_before + _value
369     old_locked: LockedBalance = _locked
370     # Adding to existing lock, or if a lock is expired - creating a new one
371     _locked.amount += convert(_value, int128)
372     if unlock_time != 0:
373         _locked.end = unlock_time
374     self.locked[_addr] = _locked
375 
376     # Possibilities:
377     # Both old_locked.end could be current or expired (>/< block.timestamp)
378     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
379     # _locked.end > block.timestamp (always)
380     self._checkpoint(_addr, old_locked, _locked)
381 
382     if _value != 0:
383         assert ERC20(self.token).transferFrom(_addr, self, _value)
384 
385     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
386     log Supply(supply_before, supply_before + _value)
387 
388 
389 @external
390 def checkpoint():
391     """
392     @notice Record global data to checkpoint
393     """
394     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
395 
396 
397 @external
398 @nonreentrant('lock')
399 def deposit_for(_addr: address, _value: uint256):
400     """
401     @notice Deposit `_value` tokens for `_addr` and add to the lock
402     @dev Anyone (even a smart contract) can deposit for someone else, but
403          cannot extend their locktime and deposit for a brand new user
404     @param _addr User's wallet address
405     @param _value Amount to add to user's lock
406     """
407     _locked: LockedBalance = self.locked[_addr]
408 
409     assert _value > 0  # dev: need non-zero value
410     assert _locked.amount > 0, "No existing lock found"
411     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
412 
413     self._deposit_for(_addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
414 
415 
416 @external
417 @nonreentrant('lock')
418 def create_lock(_value: uint256, _unlock_time: uint256):
419     """
420     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
421     @param _value Amount to deposit
422     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
423     """
424     self.assert_not_contract(msg.sender)
425     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
426     _locked: LockedBalance = self.locked[msg.sender]
427 
428     assert _value > 0  # dev: need non-zero value
429     assert _locked.amount == 0, "Withdraw old tokens first"
430     assert unlock_time > block.timestamp, "Can only lock until time in the future"
431     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
432 
433     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
434 
435 
436 @external
437 @nonreentrant('lock')
438 def increase_amount(_value: uint256):
439     """
440     @notice Deposit `_value` additional tokens for `msg.sender`
441             without modifying the unlock time
442     @param _value Amount of tokens to deposit and add to the lock
443     """
444     self.assert_not_contract(msg.sender)
445     _locked: LockedBalance = self.locked[msg.sender]
446 
447     assert _value > 0  # dev: need non-zero value
448     assert _locked.amount > 0, "No existing lock found"
449     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
450 
451     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
452 
453 
454 @external
455 @nonreentrant('lock')
456 def increase_unlock_time(_unlock_time: uint256):
457     """
458     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
459     @param _unlock_time New epoch time for unlocking
460     """
461     self.assert_not_contract(msg.sender)
462     _locked: LockedBalance = self.locked[msg.sender]
463     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
464 
465     assert _locked.end > block.timestamp, "Lock expired"
466     assert _locked.amount > 0, "Nothing is locked"
467     assert unlock_time > _locked.end, "Can only increase lock duration"
468     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
469 
470     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
471 
472 
473 @external
474 @nonreentrant('lock')
475 def withdraw():
476     """
477     @notice Withdraw all tokens for `msg.sender`
478     @dev Only possible if the lock has expired
479     """
480     _locked: LockedBalance = self.locked[msg.sender]
481     assert block.timestamp >= _locked.end, "The lock didn't expire"
482     value: uint256 = convert(_locked.amount, uint256)
483 
484     old_locked: LockedBalance = _locked
485     _locked.end = 0
486     _locked.amount = 0
487     self.locked[msg.sender] = _locked
488     supply_before: uint256 = self.supply
489     self.supply = supply_before - value
490 
491     # old_locked can have either expired <= timestamp or zero end
492     # _locked has only 0 end
493     # Both can have >= 0 amount
494     self._checkpoint(msg.sender, old_locked, _locked)
495 
496     assert ERC20(self.token).transfer(msg.sender, value)
497 
498     log Withdraw(msg.sender, value, block.timestamp)
499     log Supply(supply_before, supply_before - value)
500 
501 
502 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
503 # They measure the weights for the purpose of voting, so they don't represent
504 # real coins.
505 
506 @internal
507 @view
508 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
509     """
510     @notice Binary search to estimate timestamp for block number
511     @param _block Block to find
512     @param max_epoch Don't go beyond this epoch
513     @return Approximate timestamp for block
514     """
515     # Binary search
516     _min: uint256 = 0
517     _max: uint256 = max_epoch
518     for i in range(128):  # Will be always enough for 128-bit numbers
519         if _min >= _max:
520             break
521         _mid: uint256 = (_min + _max + 1) / 2
522         if self.point_history[_mid].blk <= _block:
523             _min = _mid
524         else:
525             _max = _mid - 1
526     return _min
527 
528 
529 @external
530 @view
531 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
532     """
533     @notice Get the current voting power for `msg.sender`
534     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
535     @param addr User wallet address
536     @param _t Epoch time to return voting power at
537     @return User voting power
538     """
539     _epoch: uint256 = self.user_point_epoch[addr]
540     if _epoch == 0:
541         return 0
542     else:
543         last_point: Point = self.user_point_history[addr][_epoch]
544         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
545         if last_point.bias < 0:
546             last_point.bias = 0
547         return convert(last_point.bias, uint256)
548 
549 
550 @external
551 @view
552 def balanceOfAt(addr: address, _block: uint256) -> uint256:
553     """
554     @notice Measure voting power of `addr` at block height `_block`
555     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
556     @param addr User's wallet address
557     @param _block Block to calculate the voting power at
558     @return Voting power
559     """
560     # Copying and pasting totalSupply code because Vyper cannot pass by
561     # reference yet
562     assert _block <= block.number
563 
564     # Binary search
565     _min: uint256 = 0
566     _max: uint256 = self.user_point_epoch[addr]
567     for i in range(128):  # Will be always enough for 128-bit numbers
568         if _min >= _max:
569             break
570         _mid: uint256 = (_min + _max + 1) / 2
571         if self.user_point_history[addr][_mid].blk <= _block:
572             _min = _mid
573         else:
574             _max = _mid - 1
575 
576     upoint: Point = self.user_point_history[addr][_min]
577 
578     max_epoch: uint256 = self.epoch
579     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
580     point_0: Point = self.point_history[_epoch]
581     d_block: uint256 = 0
582     d_t: uint256 = 0
583     if _epoch < max_epoch:
584         point_1: Point = self.point_history[_epoch + 1]
585         d_block = point_1.blk - point_0.blk
586         d_t = point_1.ts - point_0.ts
587     else:
588         d_block = block.number - point_0.blk
589         d_t = block.timestamp - point_0.ts
590     block_time: uint256 = point_0.ts
591     if d_block != 0:
592         block_time += d_t * (_block - point_0.blk) / d_block
593 
594     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
595     if upoint.bias >= 0:
596         return convert(upoint.bias, uint256)
597     else:
598         return 0
599 
600 
601 @internal
602 @view
603 def supply_at(point: Point, t: uint256) -> uint256:
604     """
605     @notice Calculate total voting power at some point in the past
606     @param point The point (bias/slope) to start search from
607     @param t Time to calculate the total voting power at
608     @return Total voting power at that time
609     """
610     last_point: Point = point
611     t_i: uint256 = (last_point.ts / WEEK) * WEEK
612     for i in range(255):
613         t_i += WEEK
614         d_slope: int128 = 0
615         if t_i > t:
616             t_i = t
617         else:
618             d_slope = self.slope_changes[t_i]
619         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
620         if t_i == t:
621             break
622         last_point.slope += d_slope
623         last_point.ts = t_i
624 
625     if last_point.bias < 0:
626         last_point.bias = 0
627     return convert(last_point.bias, uint256)
628 
629 
630 @external
631 @view
632 def totalSupply(t: uint256 = block.timestamp) -> uint256:
633     """
634     @notice Calculate total voting power
635     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
636     @return Total voting power
637     """
638     _epoch: uint256 = self.epoch
639     last_point: Point = self.point_history[_epoch]
640     return self.supply_at(last_point, t)
641 
642 
643 @external
644 @view
645 def totalSupplyAt(_block: uint256) -> uint256:
646     """
647     @notice Calculate total voting power at some point in the past
648     @param _block Block to calculate the total voting power at
649     @return Total voting power at `_block`
650     """
651     assert _block <= block.number
652     _epoch: uint256 = self.epoch
653     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
654 
655     point: Point = self.point_history[target_epoch]
656     dt: uint256 = 0
657     if target_epoch < _epoch:
658         point_next: Point = self.point_history[target_epoch + 1]
659         if point.blk != point_next.blk:
660             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
661     else:
662         if point.blk != block.number:
663             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
664     # Now dt contains info on how far are we beyond point
665 
666     return self.supply_at(point, point.ts + dt)
667 
668 
669 # Dummy methods for compatibility with Aragon
670 
671 @external
672 def changeController(_newController: address):
673     """
674     @dev Dummy method required for Aragon compatibility
675     """
676     assert msg.sender == self.controller
677     self.controller = _newController