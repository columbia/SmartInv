1 # @version 0.2.8
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
16 # HIIQ is basically a fork, with the key difference that 1 IQ locked for 1 second would be ~ 1 HIIQ,
17 # As opposed to ~ 0 HIIQ (as it is with veCRV)
18 
19 # Voting escrow to have time-weighted votes
20 # Votes have a weight depending on time, so that users are committed
21 # to the future of (whatever they are voting for).
22 # The weight in this implementation is linear, and lock cannot be more than maxtime:
23 # w ^
24 # 1 +        /
25 #   |      /
26 #   |    /
27 #   |  /
28 #   |/
29 # 0 +--------+------> time
30 #       maxtime (4 years?)
31 
32 struct Point:
33     bias: int128
34     slope: int128  # - dweight / dt
35     ts: uint256
36     blk: uint256  # block
37     iq_amt: uint256
38 # We cannot really do block numbers per se b/c slope is per time, not per block
39 # and per block could be fairly bad b/c Ethereum changes blocktimes.
40 # What we can do is to extrapolate ***At functions
41 
42 struct LockedBalance:
43     amount: int128
44     end: uint256
45 
46 interface ERC20:
47     def decimals() -> uint256: view
48     def balanceOf(addr: address) -> uint256: view
49     def name() -> String[64]: view
50     def symbol() -> String[32]: view
51     def transfer(to: address, amount: uint256) -> bool: nonpayable
52     def transferFrom(spender: address, to: address, amount: uint256) -> bool: nonpayable
53 
54 
55 # Interface for checking whether address belongs to a whitelisted
56 # type of a smart wallet.
57 # When new types are added - the whole contract is changed
58 # The check() method is modifying to be able to use caching
59 # for individual wallet addresses
60 interface SmartWalletChecker:
61     def check(addr: address) -> bool: nonpayable
62 
63 DEPOSIT_FOR_TYPE: constant(int128) = 0
64 CREATE_LOCK_TYPE: constant(int128) = 1
65 INCREASE_LOCK_AMOUNT: constant(int128) = 2
66 INCREASE_UNLOCK_TIME: constant(int128) = 3
67 
68 event CommitOwnership:
69     admin: address
70 
71 event ApplyOwnership:
72     admin: address
73 
74 event Deposit:
75     provider: indexed(address)
76     value: uint256
77     locktime: indexed(uint256)
78     type: int128
79     ts: uint256
80 
81 event Withdraw:
82     provider: indexed(address)
83     value: uint256
84     ts: uint256
85 
86 event Supply:
87     prevSupply: uint256
88     supply: uint256
89 
90 
91 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
92 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
93 MULTIPLIER: constant(uint256) = 10 ** 18
94 
95 VOTE_WEIGHT_MULTIPLIER: constant(uint256) = 4 - 1 # 4x gives 300% boost at 4 years
96 
97 token: public(address)
98 supply: public(uint256)
99 
100 locked: public(HashMap[address, LockedBalance])
101 
102 epoch: public(uint256)
103 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
104 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
105 user_point_epoch: public(HashMap[address, uint256])
106 slope_changes: public(HashMap[uint256, int128])  # time -> signed slope change
107 
108 # Aragon's view methods for compatibility
109 controller: public(address)
110 transfersEnabled: public(bool)
111 
112 # Emergency Unlock
113 emergencyUnlockActive: public(bool)
114 
115 # ERC20 related
116 name: public(String[64])
117 symbol: public(String[32])
118 version: public(String[32])
119 decimals: public(uint256)
120 
121 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
122 # The goal is to prevent tokenizing the escrow
123 future_smart_wallet_checker: public(address)
124 smart_wallet_checker: public(address)
125 
126 admin: public(address)  # Can and will be a smart contract
127 future_admin: public(address)
128 
129 
130 @external
131 def __init__(token_addr: address, _name: String[64], _symbol: String[32], _version: String[32]):
132     """
133     @notice Contract constructor
134     @param token_addr `ERC20` token address
135     @param _name Token name
136     @param _symbol Token symbol
137     @param _version Contract version - required for Aragon compatibility
138     """
139     self.admin = msg.sender
140     self.token = token_addr
141     self.point_history[0].blk = block.number
142     self.point_history[0].ts = block.timestamp
143     self.point_history[0].iq_amt = 0
144     self.controller = msg.sender
145     self.transfersEnabled = True
146 
147     _decimals: uint256 = ERC20(token_addr).decimals()
148     assert _decimals <= 255
149     self.decimals = _decimals
150 
151     self.name = _name
152     self.symbol = _symbol
153     self.version = _version
154 
155 
156 @external
157 def commit_transfer_ownership(addr: address):
158     """
159     @notice Transfer ownership of VotingEscrow contract to `addr`
160     @param addr Address to have ownership transferred to
161     """
162     assert msg.sender == self.admin  # dev: admin only
163     self.future_admin = addr
164     log CommitOwnership(addr)
165 
166 
167 @external
168 def apply_transfer_ownership():
169     """
170     @notice Apply ownership transfer
171     """
172     assert msg.sender == self.admin  # dev: admin only
173     _admin: address = self.future_admin
174     assert _admin != ZERO_ADDRESS  # dev: admin not set
175     self.admin = _admin
176     log ApplyOwnership(_admin)
177 
178 
179 @external
180 def commit_smart_wallet_checker(addr: address):
181     """
182     @notice Set an external contract to check for approved smart contract wallets
183     @param addr Address of Smart contract checker
184     """
185     assert msg.sender == self.admin
186     self.future_smart_wallet_checker = addr
187 
188 
189 @external
190 def apply_smart_wallet_checker():
191     """
192     @notice Apply setting external contract to check approved smart contract wallets
193     """
194     assert msg.sender == self.admin
195     self.smart_wallet_checker = self.future_smart_wallet_checker
196 
197 @external
198 def toggleEmergencyUnlock():
199     """
200     @dev Used to allow early withdrawals of HIIQ back into IQ, in case of an emergency
201     """
202     assert msg.sender == self.admin  # dev: admin only
203     self.emergencyUnlockActive = not (self.emergencyUnlockActive)
204 
205 @external
206 def recoverERC20(token_addr: address, amount: uint256):
207     """
208     @dev Used to recover non-IQ ERC20 tokens
209     """
210     assert msg.sender == self.admin  # dev: admin only
211     assert token_addr != self.token  # Cannot recover IQ. Use toggleEmergencyUnlock instead and have users pull theirs out individually
212     ERC20(token_addr).transfer(self.admin, amount)
213 
214 @internal
215 def assert_not_contract(addr: address):
216     """
217     @notice Check if the call is from a whitelisted smart contract, revert if not
218     @param addr Address to be checked
219     """
220     if addr != tx.origin:
221         checker: address = self.smart_wallet_checker
222         if checker != ZERO_ADDRESS:
223             if SmartWalletChecker(checker).check(addr):
224                 return
225         raise "Smart contract depositors not allowed"
226 
227 @external
228 @view
229 def get_last_user_slope(addr: address) -> int128:
230     """
231     @notice Get the most recently recorded rate of voting power decrease for `addr`
232     @param addr Address of the user wallet
233     @return Value of the slope
234     """
235     uepoch: uint256 = self.user_point_epoch[addr]
236     return self.user_point_history[addr][uepoch].slope
237 
238 
239 @external
240 @view
241 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
242     """
243     @notice Get the timestamp for checkpoint `_idx` for `_addr`
244     @param _addr User wallet address
245     @param _idx User epoch number
246     @return Epoch time of the checkpoint
247     """
248     return self.user_point_history[_addr][_idx].ts
249 
250 
251 @external
252 @view
253 def locked__end(_addr: address) -> uint256:
254     """
255     @notice Get timestamp when `_addr`'s lock finishes
256     @param _addr User wallet
257     @return Epoch time of the lock end
258     """
259     return self.locked[_addr].end
260 
261 
262 @internal
263 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance):
264     """
265     @notice Record global and per-user data to checkpoint
266     @param addr User's wallet address. No user checkpoint if 0x0
267     @param old_locked Pevious locked amount / end lock time for the user
268     @param new_locked New locked amount / end lock time for the user
269     """
270     u_old: Point = empty(Point)
271     u_new: Point = empty(Point)
272     old_dslope: int128 = 0
273     new_dslope: int128 = 0
274     _epoch: uint256 = self.epoch
275 
276     if addr != ZERO_ADDRESS:
277         # Calculate slopes and biases
278         # Kept at zero when they have to
279         if old_locked.end > block.timestamp and old_locked.amount > 0:
280             u_old.slope = old_locked.amount / MAXTIME
281             u_old.bias = u_old.slope * convert(old_locked.end - block.timestamp, int128)
282         if new_locked.end > block.timestamp and new_locked.amount > 0:
283             u_new.slope = new_locked.amount / MAXTIME
284             u_new.bias = u_new.slope * convert(new_locked.end - block.timestamp, int128)
285 
286         # Read values of scheduled changes in the slope
287         # old_locked.end can be in the past and in the future
288         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
289         old_dslope = self.slope_changes[old_locked.end]
290         if new_locked.end != 0:
291             if new_locked.end == old_locked.end:
292                 new_dslope = old_dslope
293             else:
294                 new_dslope = self.slope_changes[new_locked.end]
295 
296     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number, iq_amt: 0})
297     if _epoch > 0:
298         last_point = self.point_history[_epoch]
299     else:
300         last_point.iq_amt = ERC20(self.token).balanceOf(self) # saves gas by only calling once
301     last_checkpoint: uint256 = last_point.ts
302     # initial_last_point is used for extrapolation to calculate block number
303     # (approximately, for *At methods) and save them
304     # as we cannot figure that out exactly from inside the contract
305     initial_last_point: Point = last_point
306     block_slope: uint256 = 0  # dblock/dt
307     if block.timestamp > last_point.ts:
308         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
309     # If last point is already recorded in this block, slope=0
310     # But that's ok b/c we know the block in such case
311 
312     # Go over weeks to fill history and calculate what the current point is
313     t_i: uint256 = (last_checkpoint / WEEK) * WEEK
314     for i in range(255):
315         # Hopefully it won't happen that this won't get used in 5 years!
316         # If it does, users will be able to withdraw but vote weight will be broken
317         t_i += WEEK
318         d_slope: int128 = 0
319         if t_i > block.timestamp:
320             t_i = block.timestamp
321         else:
322             d_slope = self.slope_changes[t_i]
323         last_point.bias -= last_point.slope * convert(t_i - last_checkpoint, int128)
324         last_point.slope += d_slope
325         if last_point.bias < 0:  # This can happen
326             last_point.bias = 0
327         if last_point.slope < 0:  # This cannot happen - just in case
328             last_point.slope = 0
329         last_checkpoint = t_i
330         last_point.ts = t_i
331         last_point.blk = initial_last_point.blk + block_slope * (t_i - initial_last_point.ts) / MULTIPLIER
332         _epoch += 1
333 
334         # Fill for the current block, if applicable
335         if t_i == block.timestamp:
336             last_point.blk = block.number
337             last_point.iq_amt = ERC20(self.token).balanceOf(self)
338             break
339         else:
340             self.point_history[_epoch] = last_point
341 
342     self.epoch = _epoch
343     # Now point_history is filled until t=now
344 
345     if addr != ZERO_ADDRESS:
346         # If last point was in this block, the slope change has been applied already
347         # But in such case we have 0 slope(s)
348         last_point.slope += (u_new.slope - u_old.slope)
349         last_point.bias += (u_new.bias - u_old.bias)
350         if last_point.slope < 0:
351             last_point.slope = 0
352         if last_point.bias < 0:
353             last_point.bias = 0
354 
355     # Record the changed point into history
356     self.point_history[_epoch] = last_point
357 
358     if addr != ZERO_ADDRESS:
359         # Schedule the slope changes (slope is going down)
360         # We subtract new_user_slope from [new_locked.end]
361         # and add old_user_slope to [old_locked.end]
362         if old_locked.end > block.timestamp:
363             # old_dslope was <something> - u_old.slope, so we cancel that
364             old_dslope += u_old.slope
365             if new_locked.end == old_locked.end:
366                 old_dslope -= u_new.slope  # It was a new deposit, not extension
367             self.slope_changes[old_locked.end] = old_dslope
368 
369         if new_locked.end > block.timestamp:
370             if new_locked.end > old_locked.end:
371                 new_dslope -= u_new.slope  # old slope disappeared at this point
372                 self.slope_changes[new_locked.end] = new_dslope
373             # else: we recorded it already in old_dslope
374 
375         # Now handle user history
376         user_epoch: uint256 = self.user_point_epoch[addr] + 1
377 
378         self.user_point_epoch[addr] = user_epoch
379         u_new.ts = block.timestamp
380         u_new.blk = block.number
381         u_new.iq_amt = convert(self.locked[addr].amount, uint256)
382         self.user_point_history[addr][user_epoch] = u_new
383 
384 
385 @internal
386 def _deposit_for(_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, type: int128):
387     """
388     @notice Deposit and lock tokens for a user
389     @param _addr User's wallet address
390     @param _value Amount to deposit
391     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
392     @param locked_balance Previous locked amount / timestamp
393     """
394     _locked: LockedBalance = locked_balance
395     supply_before: uint256 = self.supply
396 
397     self.supply = supply_before + _value
398     old_locked: LockedBalance = _locked
399     # Adding to existing lock, or if a lock is expired - creating a new one
400     _locked.amount += convert(_value, int128)
401     if unlock_time != 0:
402         _locked.end = unlock_time
403     self.locked[_addr] = _locked
404 
405     # Possibilities:
406     # Both old_locked.end could be current or expired (>/< block.timestamp)
407     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
408     # _locked.end > block.timestamp (always)
409     self._checkpoint(_addr, old_locked, _locked)
410 
411     if _value != 0:
412         assert ERC20(self.token).transferFrom(_addr, self, _value)
413 
414     log Deposit(_addr, _value, _locked.end, type, block.timestamp)
415     log Supply(supply_before, supply_before + _value)
416 
417 
418 @external
419 def checkpoint():
420     """
421     @notice Record global data to checkpoint
422     """
423     self._checkpoint(ZERO_ADDRESS, empty(LockedBalance), empty(LockedBalance))
424 
425 
426 @external
427 @nonreentrant('lock')
428 def deposit_for(_addr: address, _value: uint256):
429     """
430     @notice Deposit `_value` tokens for `_addr` and add to the lock
431     @dev Anyone (even a smart contract) can deposit for someone else, but
432          cannot extend their locktime and deposit for a brand new user
433     @param _addr User's wallet address
434     @param _value Amount to add to user's lock
435     """
436     _locked: LockedBalance = self.locked[_addr]
437 
438     assert _value > 0  # dev: need non-zero value
439     assert _locked.amount > 0, "No existing lock found"
440     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
441 
442     self._deposit_for(_addr, _value, 0, self.locked[_addr], DEPOSIT_FOR_TYPE)
443 
444 
445 @external
446 @nonreentrant('lock')
447 def create_lock(_value: uint256, _unlock_time: uint256):
448     """
449     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
450     @param _value Amount to deposit
451     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
452     """
453     self.assert_not_contract(msg.sender)
454     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
455     _locked: LockedBalance = self.locked[msg.sender]
456 
457     assert _value > 0  # dev: need non-zero value
458     assert _locked.amount == 0, "Withdraw old tokens first"
459     assert unlock_time > block.timestamp, "Can only lock until time in the future"
460     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
461 
462     self._deposit_for(msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
463 
464 
465 @external
466 @nonreentrant('lock')
467 def increase_amount(_value: uint256):
468     """
469     @notice Deposit `_value` additional tokens for `msg.sender`
470             without modifying the unlock time
471     @param _value Amount of tokens to deposit and add to the lock
472     """
473     self.assert_not_contract(msg.sender)
474     _locked: LockedBalance = self.locked[msg.sender]
475 
476     assert _value > 0  # dev: need non-zero value
477     assert _locked.amount > 0, "No existing lock found"
478     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
479 
480     self._deposit_for(msg.sender, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
481 
482 
483 @external
484 @nonreentrant('lock')
485 def increase_unlock_time(_unlock_time: uint256):
486     """
487     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
488     @param _unlock_time New epoch time for unlocking
489     """
490     self.assert_not_contract(msg.sender)
491     _locked: LockedBalance = self.locked[msg.sender]
492     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
493 
494     assert _locked.end > block.timestamp, "Lock expired"
495     assert _locked.amount > 0, "Nothing is locked"
496     assert unlock_time > _locked.end, "Can only increase lock duration"
497     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
498 
499     self._deposit_for(msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
500 
501 
502 @external
503 @nonreentrant('lock')
504 def withdraw():
505     """
506     @notice Withdraw all tokens for `msg.sender`
507     @dev Only possible if the lock has expired
508     """
509     _locked: LockedBalance = self.locked[msg.sender]
510     assert ((block.timestamp >= _locked.end) or (self.emergencyUnlockActive)), "The lock didn't expire"
511     value: uint256 = convert(_locked.amount, uint256)
512 
513     old_locked: LockedBalance = _locked
514     _locked.end = 0
515     _locked.amount = 0
516     self.locked[msg.sender] = _locked
517     supply_before: uint256 = self.supply
518     self.supply = supply_before - value
519 
520     # old_locked can have either expired <= timestamp or zero end
521     # _locked has only 0 end
522     # Both can have >= 0 amount
523     self._checkpoint(msg.sender, old_locked, _locked)
524 
525     assert ERC20(self.token).transfer(msg.sender, value)
526 
527     log Withdraw(msg.sender, value, block.timestamp)
528     log Supply(supply_before, supply_before - value)
529 
530 
531 # The following ERC20/minime-compatible methods are not real balanceOf and supply!
532 # They measure the weights for the purpose of voting, so they don't represent
533 # real coins.
534 # FRAX adds minimal 1-1 IQ/HIIQ, as well as a voting multiplier
535 
536 @internal
537 @view
538 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
539     """
540     @notice Binary search to estimate timestamp for block number
541     @param _block Block to find
542     @param max_epoch Don't go beyond this epoch
543     @return Approximate timestamp for block
544     """
545     # Binary search
546     _min: uint256 = 0
547     _max: uint256 = max_epoch
548     for i in range(128):  # Will be always enough for 128-bit numbers
549         if _min >= _max:
550             break
551         _mid: uint256 = (_min + _max + 1) / 2
552         if self.point_history[_mid].blk <= _block:
553             _min = _mid
554         else:
555             _max = _mid - 1
556     return _min
557 
558 
559 @external
560 @view
561 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
562     """
563     @notice Get the current voting power for `msg.sender`
564     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
565     @param addr User wallet address
566     @param _t Epoch time to return voting power at
567     @return User voting power
568     """
569     _epoch: uint256 = self.user_point_epoch[addr]
570     if _epoch == 0:
571         return 0
572     else:
573         last_point: Point = self.user_point_history[addr][_epoch]
574         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
575         if last_point.bias < 0:
576             last_point.bias = 0
577 
578         unweighted_supply: uint256 = convert(last_point.bias, uint256) # Original from veCRV
579         weighted_supply: uint256 = last_point.iq_amt + (VOTE_WEIGHT_MULTIPLIER * unweighted_supply)
580         return weighted_supply
581 
582 
583 @external
584 @view
585 def balanceOfAt(addr: address, _block: uint256) -> uint256:
586     """
587     @notice Measure voting power of `addr` at block height `_block`
588     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
589     @param addr User's wallet address
590     @param _block Block to calculate the voting power at
591     @return Voting power
592     """
593     # Copying and pasting totalSupply code because Vyper cannot pass by
594     # reference yet
595     assert _block <= block.number
596 
597     # Binary search
598     _min: uint256 = 0
599     _max: uint256 = self.user_point_epoch[addr]
600     for i in range(128):  # Will be always enough for 128-bit numbers
601         if _min >= _max:
602             break
603         _mid: uint256 = (_min + _max + 1) / 2
604         if self.user_point_history[addr][_mid].blk <= _block:
605             _min = _mid
606         else:
607             _max = _mid - 1
608 
609     upoint: Point = self.user_point_history[addr][_min]
610 
611     max_epoch: uint256 = self.epoch
612     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
613     point_0: Point = self.point_history[_epoch]
614     d_block: uint256 = 0
615     d_t: uint256 = 0
616     if _epoch < max_epoch:
617         point_1: Point = self.point_history[_epoch + 1]
618         d_block = point_1.blk - point_0.blk
619         d_t = point_1.ts - point_0.ts
620     else:
621         d_block = block.number - point_0.blk
622         d_t = block.timestamp - point_0.ts
623     block_time: uint256 = point_0.ts
624     if d_block != 0:
625         block_time += d_t * (_block - point_0.blk) / d_block
626 
627     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
628 
629     unweighted_supply: uint256 = convert(upoint.bias, uint256) # Original from veCRV
630     weighted_supply: uint256 = upoint.iq_amt + (VOTE_WEIGHT_MULTIPLIER * unweighted_supply)
631 
632     if ((upoint.bias >= 0) or (upoint.iq_amt >= 0)):
633         return weighted_supply
634     else:
635         return 0
636 
637 
638 @internal
639 @view
640 def supply_at(point: Point, t: uint256) -> uint256:
641     """
642     @notice Calculate total voting power at some point in the past
643     @param point The point (bias/slope) to start search from
644     @param t Time to calculate the total voting power at
645     @return Total voting power at that time
646     """
647     last_point: Point = point
648     t_i: uint256 = (last_point.ts / WEEK) * WEEK
649     for i in range(255):
650         t_i += WEEK
651         d_slope: int128 = 0
652         if t_i > t:
653             t_i = t
654         else:
655             d_slope = self.slope_changes[t_i]
656         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
657         if t_i == t:
658             break
659         last_point.slope += d_slope
660         last_point.ts = t_i
661 
662     if last_point.bias < 0:
663         last_point.bias = 0
664     unweighted_supply: uint256 = convert(last_point.bias, uint256) # Original from veCRV
665     weighted_supply: uint256 = last_point.iq_amt + (VOTE_WEIGHT_MULTIPLIER * unweighted_supply)
666     return weighted_supply
667 
668 
669 @external
670 @view
671 def totalSupply(t: uint256 = block.timestamp) -> uint256:
672     """
673     @notice Calculate total voting power
674     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
675     @return Total voting power
676     """
677     _epoch: uint256 = self.epoch
678     last_point: Point = self.point_history[_epoch]
679     return self.supply_at(last_point, t)
680 
681 
682 @external
683 @view
684 def totalSupplyAt(_block: uint256) -> uint256:
685     """
686     @notice Calculate total voting power at some point in the past
687     @param _block Block to calculate the total voting power at
688     @return Total voting power at `_block`
689     """
690     assert _block <= block.number
691     _epoch: uint256 = self.epoch
692     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
693 
694     point: Point = self.point_history[target_epoch]
695     dt: uint256 = 0
696     if target_epoch < _epoch:
697         point_next: Point = self.point_history[target_epoch + 1]
698         if point.blk != point_next.blk:
699             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
700     else:
701         if point.blk != block.number:
702             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
703     # Now dt contains info on how far are we beyond point
704 
705     return self.supply_at(point, point.ts + dt)
706 
707 # Dummy methods for compatibility with Aragon
708 
709 @external
710 @view
711 def totalIQSupply() -> uint256:
712     """
713     @notice Calculate IQ supply
714     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
715     @return Total IQ supply
716     """
717     return ERC20(self.token).balanceOf(self)
718 
719 @external
720 @view
721 def totalIQSupplyAt(_block: uint256) -> uint256:
722     """
723     @notice Calculate total IQ at some point in the past
724     @param _block Block to calculate the total voting power at
725     @return Total IQ supply at `_block`
726     """
727     assert _block <= block.number
728     _epoch: uint256 = self.epoch
729     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
730     point: Point = self.point_history[target_epoch]
731     return point.iq_amt
732 
733 @external
734 def changeController(_newController: address):
735     """
736     @dev Dummy method required for Aragon compatibility
737     """
738     assert msg.sender == self.controller
739     self.controller = _newController