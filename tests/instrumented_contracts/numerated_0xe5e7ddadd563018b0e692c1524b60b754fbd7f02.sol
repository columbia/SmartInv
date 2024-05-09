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
108 admin: public(address)  # Can and will be a smart contract
109 future_admin: public(address)
110 
111 
112 @external
113 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
114     """
115     @notice Contract constructor
116     @param token_addr `ERC20CRV` token address
117     @param _name Token name
118     @param _symbol Token symbol
119     @param _version Contract version - required for Aragon compatibility
120     """
121     self.admin = msg.sender
122     self.token = token_addr
123     self.point_history[0].blk = block.number
124     self.point_history[0].ts = block.timestamp
125     self.controller = msg.sender
126     self.transfersEnabled = True
127 
128     _decimals: uint256 = ERC20(token_addr).decimals()
129     assert _decimals <= 255
130     self.decimals = _decimals
131 
132     self.name = _name
133     self.symbol = _symbol
134     self.version = _version
135 
136 
137 @external
138 def commit_transfer_ownership(addr: address):
139     """
140     @notice Transfer ownership of VotingEscrow contract to `addr`
141     @param addr Address to have ownership transferred to
142     """
143     assert msg.sender == self.admin  # dev: admin only
144     self.future_admin = addr
145     log CommitOwnership(addr)
146 
147 
148 @external
149 def apply_transfer_ownership():
150     """
151     @notice Apply ownership transfer
152     """
153     assert msg.sender == self.admin  # dev: admin only
154     _admin: address = self.future_admin
155     assert _admin != ZERO_ADDRESS  # dev: admin not set
156     self.admin = _admin
157     log ApplyOwnership(_admin)
158 
159 
160 @external
161 @view
162 def get_last_user_slope(addr: address) -> int128:
163     """
164     @notice Get the most recently recorded rate of voting power decrease for `addr`
165     @param addr Address of the user wallet
166     @return Value of the slope
167     """
168     uepoch: uint256 = self.user_point_epoch[addr]
169     return self.user_point_history[addr][uepoch].slope
170 
171 
172 @external
173 @view
174 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
175     """
176     @notice Get the timestamp for checkpoint `_idx` for `_addr`
177     @param _addr User wallet address
178     @param _idx User epoch number
179     @return Epoch time of the checkpoint
180     """
181     return self.user_point_history[_addr][_idx].ts
182 
183 
184 @external
185 @view
186 def locked__end(_addr: address) -> uint256:
187     """
188     @notice Get timestamp when `_addr`'s lock finishes
189     @param _addr User wallet
190     @return Epoch time of the lock end
191     """
192     return self.locked[_addr].end
193 
194 
195 @internal
196 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
197     """
198     @notice Record global and per-user data to checkpoint
199     @param addr User's wallet address. No user checkpoint if 0x0
200     @param old_locked Pevious locked amount / end lock time for the user
201     @param new_locked New locked amount / end lock time for the user
202     """
203     u_old: Point = empty(Point)
204     u_new: Point = empty(Point)
205     old_dslope: int128 = 0
206     new_dslope: int128 = 0
207     _epoch: uint256 = self.epoch
208 
209     if addr != ZERO_ADDRESS:
210         # Calculate slopes and biases
211         # Kept at zero when they have to
212         if old_locked.end > block.timestamp and old_locked.amount > 0:
213             u_old.slope = old_locked.amount / MAXTIME
214             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
215         if new_locked.end > block.timestamp and new_locked.amount > 0:
216             u_new.slope = new_locked.amount / MAXTIME
217             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
218 
219         # Read values of scheduled changes in the slope
220         # old_locked.end can be in the past and in the future
221         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
222         old_dslope = self.slope_changes[old_locked.end]
223         if new_locked.end != 0:
224             if new_locked.end == old_locked.end:
225                 new_dslope = old_dslope
226             else:
227                 new_dslope = self.slope_changes[new_locked.end]
228 
229     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number})
230     if _epoch > 0:
231         last_point = self.point_history[_epoch]
232     last_checkpoint: uint256 = last_point.ts
233     # initial_last_point is used for extrapolation to calculate block number
234     # (approximately, for *At methods) and save them
235     # as we cannot figure that out exactly from inside the contract
236     initial_last_point: Point = last_point
237     block_slope: uint256 = 0  # dblock/dt
238     if block.timestamp > last_point.ts:
239         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
240     # If last point is already recorded in this block, slope=0
241     # But that's ok b/c we know the block in such case
242 
243     # Go over weeks to fill history and calculate what the current point is
244     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
245     for i in range(255):
246         # Hopefully it won't happen that this won't get used in 5 years!
247         # If it does, users will be able to withdraw but vote weight will be broken
248         t_i += WEEK
249         d_slope: int128 = 0
250         if t_i > block.timestamp:
251             t_i = block.timestamp
252         else:
253             d_slope = self.slope_changes[t_i]
254         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
255         last_point.slope += d_slope
256         if last_point.bias < 0:  # This can happen
257             last_point.bias = 0
258         if last_point.slope < 0:  # This cannot happen - just in case
259             last_point.slope = 0
260         last_checkpoint = t_i
261         last_point.ts = t_i
262         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
263         _epoch += 1
264         if t_i == block.timestamp:
265             last_point.blk = block.number
266             break
267         else:
268             self.point_history[_epoch] = last_point
269 
270     self.epoch = _epoch
271     # Now point_history is filled until t=now
272 
273     if addr != ZERO_ADDRESS:
274         # If last point was in this block, the slope change has been applied already
275         # But in such case we have 0 slope(s)
276         last_point.slope += (u_new.slope - u_old.slope)
277         last_point.bias += (u_new.bias - u_old.bias)
278         if last_point.slope < 0:
279             last_point.slope = 0
280         if last_point.bias < 0:
281             last_point.bias = 0
282 
283     # Record the changed point into history
284     self.point_history[_epoch] = last_point
285 
286     if addr != ZERO_ADDRESS:
287         # Schedule the slope changes (slope is going down)
288         # We subtract new_user_slope from [new_locked.end]
289         # and add old_user_slope to [old_locked.end]
290         if old_locked.end > block.timestamp:
291             # old_dslope was <something> - u_old.slope, so we cancel that
292             old_dslope += u_old.slope
293             if new_locked.end == old_locked.end:
294                 old_dslope -= u_new.slope  # It was a new deposit, not extension
295             self.slope_changes[old_locked.end] = old_dslope
296 
297         if new_locked.end > block.timestamp:
298             if new_locked.end > old_locked.end:
299                 new_dslope -= u_new.slope  # old slope disappeared at this point
300                 self.slope_changes[new_locked.end] = new_dslope
301             # else: we recorded it already in old_dslope
302 
303         # Now handle user history
304         user_epoch: uint256 = self.user_point_epoch[addr] + 1
305 
306         self.user_point_epoch[addr] = user_epoch
307         u_new.ts = block.timestamp
308         u_new.blk = block.number
309         self.user_point_history[addr][user_epoch] = u_new
310 
311 
312 @internal
313 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
314     """
315     @notice Deposit and lock tokens for a user
316     @param _addr User's wallet address
317     @param _value Amount to deposit
318     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
319     @param locked_balance Previous locked amount / timestamp
320     """
321     _locked: LockedBalance = locked_balance
322     supply_before: uint256 = self.supply
323 
324     self.supply = supply_before + _value
325     old_locked: LockedBalance = _locked
326     # Adding to existing lock, or if a lock is expired - creating a new one
327     _locked.amount += convert(_value, int128)
328     if unlock_time != 0:
329         _locked.end = unlock_time
330     self.locked[_addr] = _locked
331 
332     # Possibilities:
333     # Both old_locked.end could be current or expired (>/< block.timestamp)
334     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
335     # _locked.end > block.timestamp (always)
336     self._checkpoint(_addr, old_locked, _locked)
337 
338     if _value != 0:
339         assert ERC20(self.token).transferFrom(_addr, self, _value)
340 
341     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
342     log Supply(supply_before, supply_before + _value)
343 
344 
345 @external
346 def checkpoint():
347     """
348     @notice Record global data to checkpoint
349     """
350     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
351 
352 
353 @external
354 @nonreentrant('lock')
355 def deposit_for(_addr: address, _value: uint256):
356     """
357     @notice Deposit `_value` tokens for `_addr` and add to the lock
358     @dev Anyone (even a smart contract) can deposit for someone else, but
359          cannot extend their locktime and deposit for a brand new user
360     @param _addr User's wallet address
361     @param _value Amount to add to user's lock
362     """
363     _locked: LockedBalance = self.locked[_addr]
364 
365     assert _value > 0  # dev: need non-zero value
366     assert _locked.amount > 0, "No existing lock found"
367     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
368 
369     self._deposit_for(_addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
370 
371 
372 @external
373 @nonreentrant('lock')
374 def create_lock(_value: uint256, _unlock_time: uint256):
375     """
376     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
377     @param _value Amount to deposit
378     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
379     """
380     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
381     _locked: LockedBalance = self.locked[msg.sender]
382 
383     assert _value > 0  # dev: need non-zero value
384     assert _locked.amount == 0, "Withdraw old tokens first"
385     assert unlock_time > block.timestamp, "Can only lock until time in the future"
386     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
387 
388     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
389 
390 
391 @external
392 @nonreentrant('lock')
393 def increase_amount(_value: uint256):
394     """
395     @notice Deposit `_value` additional tokens for `msg.sender`
396             without modifying the unlock time
397     @param _value Amount of tokens to deposit and add to the lock
398     """
399     _locked: LockedBalance = self.locked[msg.sender]
400 
401     assert _value > 0  # dev: need non-zero value
402     assert _locked.amount > 0, "No existing lock found"
403     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
404 
405     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
406 
407 
408 @external
409 @nonreentrant('lock')
410 def increase_unlock_time(_unlock_time: uint256):
411     """
412     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
413     @param _unlock_time New epoch time for unlocking
414     """
415     _locked: LockedBalance = self.locked[msg.sender]
416     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
417 
418     assert _locked.end > block.timestamp, "Lock expired"
419     assert _locked.amount > 0, "Nothing is locked"
420     assert unlock_time > _locked.end, "Can only increase lock duration"
421     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
422 
423     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
424 
425 
426 @external
427 @nonreentrant('lock')
428 def withdraw():
429     """
430     @notice Withdraw all tokens for `msg.sender`
431     @dev Only possible if the lock has expired
432     """
433     _locked: LockedBalance = self.locked[msg.sender]
434     assert block.timestamp >= _locked.end, "The lock didn't expire"
435     value: uint256 = convert(_locked.amount, uint256)
436 
437     old_locked: LockedBalance = _locked
438     _locked.end = 0
439     _locked.amount = 0
440     self.locked[msg.sender] = _locked
441     supply_before: uint256 = self.supply
442     self.supply = supply_before - value
443 
444     # old_locked can have either expired <= timestamp or zero end
445     # _locked has only 0 end
446     # Both can have >= 0 amount
447     self._checkpoint(msg.sender, old_locked, _locked)
448 
449     assert ERC20(self.token).transfer(msg.sender, value)
450 
451     log Withdraw(msg.sender, value, block.timestamp)
452     log Supply(supply_before, supply_before - value)
453 
454 
455 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
456 # They measure the weights for the purpose of voting, so they don't represent
457 # real coins.
458 
459 @internal
460 @view
461 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
462     """
463     @notice Binary search to estimate timestamp for block number
464     @param _block Block to find
465     @param max_epoch Don't go beyond this epoch
466     @return Approximate timestamp for block
467     """
468     # Binary search
469     _min: uint256 = 0
470     _max: uint256 = max_epoch
471     for i in range(128):  # Will be always enough for 128-bit numbers
472         if _min >= _max:
473             break
474         _mid: uint256 = (_min + _max + 1) / 2
475         if self.point_history[_mid].blk <= _block:
476             _min = _mid
477         else:
478             _max = _mid - 1
479     return _min
480 
481 
482 @external
483 @view
484 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
485     """
486     @notice Get the current voting power for `msg.sender`
487     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
488     @param addr User wallet address
489     @param _t Epoch time to return voting power at
490     @return User voting power
491     """
492     _epoch: uint256 = self.user_point_epoch[addr]
493     if _epoch == 0:
494         return 0
495     else:
496         last_point: Point = self.user_point_history[addr][_epoch]
497         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
498         if last_point.bias < 0:
499             last_point.bias = 0
500         return convert(last_point.bias, uint256)
501 
502 
503 @external
504 @view
505 def balanceOfAt(addr: address, _block: uint256) -> uint256:
506     """
507     @notice Measure voting power of `addr` at block height `_block`
508     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
509     @param addr User's wallet address
510     @param _block Block to calculate the voting power at
511     @return Voting power
512     """
513     # Copying and pasting totalSupply code because Vyper cannot pass by
514     # reference yet
515     assert _block <= block.number
516 
517     # Binary search
518     _min: uint256 = 0
519     _max: uint256 = self.user_point_epoch[addr]
520     for i in range(128):  # Will be always enough for 128-bit numbers
521         if _min >= _max:
522             break
523         _mid: uint256 = (_min + _max + 1) / 2
524         if self.user_point_history[addr][_mid].blk <= _block:
525             _min = _mid
526         else:
527             _max = _mid - 1
528 
529     upoint: Point = self.user_point_history[addr][_min]
530 
531     max_epoch: uint256 = self.epoch
532     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
533     point_0: Point = self.point_history[_epoch]
534     d_block: uint256 = 0
535     d_t: uint256 = 0
536     if _epoch < max_epoch:
537         point_1: Point = self.point_history[_epoch + 1]
538         d_block = point_1.blk - point_0.blk
539         d_t = point_1.ts - point_0.ts
540     else:
541         d_block = block.number - point_0.blk
542         d_t = block.timestamp - point_0.ts
543     block_time: uint256 = point_0.ts
544     if d_block != 0:
545         block_time += d_t * (_block - point_0.blk) / d_block
546 
547     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
548     if upoint.bias >= 0:
549         return convert(upoint.bias, uint256)
550     else:
551         return 0
552 
553 
554 @internal
555 @view
556 def supply_at(point: Point, t: uint256) -> uint256:
557     """
558     @notice Calculate total voting power at some point in the past
559     @param point The point (bias/slope) to start search from
560     @param t Time to calculate the total voting power at
561     @return Total voting power at that time
562     """
563     last_point: Point = point
564     t_i: uint256 = (last_point.ts / WEEK) * WEEK
565     for i in range(255):
566         t_i += WEEK
567         d_slope: int128 = 0
568         if t_i > t:
569             t_i = t
570         else:
571             d_slope = self.slope_changes[t_i]
572         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
573         if t_i == t:
574             break
575         last_point.slope += d_slope
576         last_point.ts = t_i
577 
578     if last_point.bias < 0:
579         last_point.bias = 0
580     return convert(last_point.bias, uint256)
581 
582 
583 @external
584 @view
585 def totalSupply(t: uint256 = block.timestamp) -> uint256:
586     """
587     @notice Calculate total voting power
588     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
589     @return Total voting power
590     """
591     _epoch: uint256 = self.epoch
592     last_point: Point = self.point_history[_epoch]
593     return self.supply_at(last_point, t)
594 
595 
596 @external
597 @view
598 def totalSupplyAt(_block: uint256) -> uint256:
599     """
600     @notice Calculate total voting power at some point in the past
601     @param _block Block to calculate the total voting power at
602     @return Total voting power at `_block`
603     """
604     assert _block <= block.number
605     _epoch: uint256 = self.epoch
606     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
607 
608     point: Point = self.point_history[target_epoch]
609     dt: uint256 = 0
610     if target_epoch < _epoch:
611         point_next: Point = self.point_history[target_epoch + 1]
612         if point.blk != point_next.blk:
613             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
614     else:
615         if point.blk != block.number:
616             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
617     # Now dt contains info on how far are we beyond point
618 
619     return self.supply_at(point, point.ts + dt)
620 
621 
622 # Dummy methods for compatibility with Aragon
623 
624 @external
625 def changeController(_newController: address):
626     """
627     @dev Dummy method required for Aragon compatibility
628     """
629     assert msg.sender == self.controller
630     self.controller = _newController