1 # @version 0.3.7
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
12 # ====================================================================
13 # |     ______                   _______                             |
14 # |    / _____________ __  __   / ____(_____  ____ _____  ________   |
15 # |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
16 # |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
17 # | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
18 # |                                                                  |
19 # ====================================================================
20 # ============================== veFPIS ==============================
21 # ====================================================================
22 # Frax Finance: https://github.com/FraxFinance
23 
24 # Original idea and credit:
25 # Curve Finance's veCRV
26 # https://curve.readthedocs.io/dao-vecrv.html
27 # https://resources.curve.fi/faq/vote-locking-boost
28 # https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/VotingEscrow.vy
29 # veFPIS is basically a fork, with the key difference that 1 FPIS locked for 1 second would be ~ 1 veFPIS,
30 # As opposed to ~ 0 veFPIS (as it is with veCRV)
31 
32 # Frax Primary Forker(s) / Modifier(s) 
33 # Travis Moore: https://github.com/FortisFortuna
34 
35 # Frax Reviewer(s) / Contributor(s)
36 # Dennis: https://github.com/denett
37 # Jamie Turley: https://github.com/jyturley
38 # Drake Evans: https://github.com/DrakeEvans
39 # Rich Gee: https://github.com/zer0blockchain
40 # Sam Kazemian: https://github.com/samkazemian
41 
42 # Voting escrow to have time-weighted votes
43 # Votes have a weight depending on time, so that users are committed
44 # to the future of (whatever they are voting for).
45 # The weight in this implementation is linear, and lock cannot be more than maxtime:
46 # w ^
47 # 4 +        /
48 #   |      /
49 #   |    /
50 #   |  /
51 #   |/
52 # 1 +--------+------> time
53 #       maxtime (4 years)
54 
55 struct Point:
56     bias: int128 # principal FPIS amount locked
57     slope: int128  # - dweight / dt
58     ts: uint256
59     blk: uint256  # block
60     fpis_amt: uint256
61 # We cannot really do block numbers per se b/c slope is per time, not per block
62 # and per block could be fairly bad b/c Ethereum changes blocktimes.
63 # What we can do is to extrapolate ***At functions
64 
65 struct LockedBalance:
66     amount: int128
67     end: uint256
68 
69 interface ERC20:
70     def decimals() -> uint256: view
71     def balanceOf(addr: address) -> uint256: view
72     def name() -> String[64]: view
73     def symbol() -> String[32]: view
74     def transfer(to: address, amount: uint256) -> bool: nonpayable
75     def transferFrom(spender: address, to: address, amount: uint256) -> bool: nonpayable
76 
77 
78 # Interface for checking whether address belongs to a whitelisted
79 # type of a smart wallet.
80 # When new types are added - the whole contract is changed
81 # The check() method is modifying to be able to use caching
82 # for individual wallet addresses
83 interface SmartWalletChecker:
84     def check(addr: address) -> bool: nonpayable
85 
86 # Flags
87 CREATE_LOCK_TYPE: constant(int128) = 0
88 INCREASE_LOCK_AMOUNT: constant(int128) = 1
89 INCREASE_UNLOCK_TIME: constant(int128) = 2
90 USER_WITHDRAW: constant(int128) = 3
91 TRANSFER_FROM_APP: constant(int128) = 4
92 TRANSFER_TO_APP: constant(int128) = 5
93 PROXY_ADD: constant(int128) = 6
94 PROXY_SLASH: constant(int128) = 7
95 CHECKPOINT_ONLY: constant(int128) = 8
96 
97 event NominateOwnership:
98     admin: address
99 
100 event AcceptOwnership:
101     admin: address
102 
103 event Deposit:
104     provider: indexed(address)
105     payer_addr: indexed(address)
106     value: uint256
107     locktime: indexed(uint256)
108     type: int128
109     ts: uint256
110 
111 event Withdraw:
112     provider: indexed(address)
113     to_addr: indexed(address)
114     value: uint256
115     ts: uint256
116 
117 event Supply:
118     prevSupply: uint256
119     supply: uint256
120 
121 event TransferToApp:
122     staker_addr: indexed(address)
123     app_addr: indexed(address)
124     transfer_amt: uint256
125 
126 event TransferFromApp:
127     app_addr: indexed(address)
128     staker_addr: indexed(address)
129     transfer_amt: uint256
130 
131 event ProxyAdd:
132     staker_addr: indexed(address)
133     proxy_addr: indexed(address)
134     add_amt: uint256
135 
136 event ProxySlash:
137     staker_addr: indexed(address)
138     proxy_addr: indexed(address)
139     slash_amt: uint256
140 
141 event SmartWalletCheckerComitted:
142     future_smart_wallet_checker: address
143 
144 event SmartWalletCheckerApplied:
145     smart_wallet_checker: address
146 
147 event EmergencyUnlockToggled:
148     emergencyUnlockActive: bool
149 
150 event AppIncreaseAmountForsToggled:
151     appIncreaseAmountForsEnabled: bool
152 
153 event ProxyTransferFromsToggled:
154     appTransferFromsEnabled: bool
155 
156 event ProxyTransferTosToggled:
157     appTransferTosEnabled: bool
158 
159 event ProxyAddsToggled:
160     proxyAddsEnabled: bool
161 
162 event ProxySlashesToggled:
163     proxySlashesEnabled: bool
164 
165 event LendingProxySet:
166     proxy_address: address
167 
168 event HistoricalProxyToggled:
169     proxy_address: address
170     enabled: bool
171 
172 event StakerProxySet:
173     proxy_address: address
174 
175 
176 WEEK: constant(uint256) = 7 * 86400  # all future times are rounded by week
177 MAXTIME: constant(uint256) = 4 * 365 * 86400  # 4 years
178 MAXTIME_I128: constant(int128) = 4 * 365 * 86400  # 4 years
179 MULTIPLIER: constant(uint256) = 10 ** 18
180 
181 VOTE_WEIGHT_MULTIPLIER: constant(uint256) = 4 - 1 # 4x gives 300% boost at 4 years
182 VOTE_WEIGHT_MULTIPLIER_I128: constant(int128) = 4 - 1 # 4x gives 300% boost at 4 years
183 
184 token: public(address)
185 supply: public(uint256) # Tracked FPIS in the contract
186 
187 locked: public(HashMap[address, LockedBalance]) # user -> locked balance position info
188 
189 epoch: public(uint256)
190 point_history: public(Point[100000000000000000000000000000])  # epoch -> unsigned point
191 user_point_history: public(HashMap[address, Point[1000000000]])  # user -> Point[user_epoch]
192 user_point_epoch: public(HashMap[address, uint256]) # user -> last week epoch their slope and bias were checkpointed
193 
194 # time -> signed slope change. Stored ahead of time so we can keep track of expiring users.
195 # Time will always be a multiple of 1 week
196 slope_changes: public(HashMap[uint256, int128])  
197                                                  
198 # Misc
199 appIncreaseAmountForsEnabled: public(bool) # Whether the proxy can directly deposit FPIS and increase a particular user's stake 
200 appTransferFromsEnabled: public(bool) # Whether FPIS can be received from apps or not
201 appTransferTosEnabled: public(bool) # Whether FPIS can be sent to apps or not
202 proxyAddsEnabled: public(bool) # Whether the proxy can add to the user's position
203 proxySlashesEnabled: public(bool) # Whether the proxy can slash the user's position
204 
205 # Emergency Unlock
206 emergencyUnlockActive: public(bool)
207 
208 # Proxies (allow withdrawal / deposits for lending protocols, etc.)
209 current_proxy: public(address) # Set by admin. Can only be one at any given time
210 historical_proxies: public(HashMap[address, bool]) # Set by admin. Used for paying back / liquidating after the main current_proxy changes
211 staker_whitelisted_proxy: public(HashMap[address, address])  # user -> proxy. Set by user
212 user_proxy_balance: public(HashMap[address, uint256]) # user -> amount held in proxy
213 
214 # ERC20 related
215 name: public(String[64])
216 symbol: public(String[32])
217 version: public(String[32])
218 decimals: public(uint256)
219 
220 # Checker for whitelisted (smart contract) wallets which are allowed to deposit
221 # The goal is to prevent tokenizing the escrow
222 future_smart_wallet_checker: public(address)
223 smart_wallet_checker: public(address)
224 
225 admin: public(address)  # Can and will be a smart contract
226 future_admin: public(address)
227 
228 
229 @external
230 def __init__():
231     """
232     @notice Contract constructor. No constructor args due to Etherscan verification issues
233     """
234     token_addr: address = 0xc2544A32872A91F4A553b404C6950e89De901fdb
235     self.admin = msg.sender
236     self.token = token_addr
237     self.point_history[0].blk = block.number
238     self.point_history[0].ts = block.timestamp
239     self.point_history[0].fpis_amt = 0
240     self.appTransferFromsEnabled = False
241     self.appTransferTosEnabled = False
242     self.proxyAddsEnabled = False
243     self.proxySlashesEnabled = False
244 
245     _decimals: uint256 = ERC20(token_addr).decimals()
246     assert _decimals <= 255
247     self.decimals = _decimals
248 
249     self.name = "veFPIS"
250     self.symbol = "veFPIS"
251     self.version = "veFPIS_1.0.0"
252 
253 @external
254 def nominate_ownership(addr: address):
255     """
256     @notice Transfer ownership of this contract to `addr`
257     @param addr Address of the new owner
258     """
259     assert msg.sender == self.admin  # dev: admin only
260 
261     self.future_admin = addr
262     log NominateOwnership(addr)
263 
264 
265 @external
266 def accept_transfer_ownership():
267     """
268     @notice Accept a pending ownership transfer
269     @dev Only callable by the new owner
270     """
271     _admin: address = self.future_admin
272     assert msg.sender == _admin  # dev: future admin only
273 
274     self.admin = _admin
275     self.future_admin = empty(address)
276     log AcceptOwnership(_admin)
277 
278 @external
279 def commit_smart_wallet_checker(addr: address):
280     """
281     @notice Set an external contract to check for approved smart contract wallets
282     @param addr Address of Smart contract checker
283     """
284     assert msg.sender == self.admin
285     self.future_smart_wallet_checker = addr
286 
287     log SmartWalletCheckerComitted(self.future_smart_wallet_checker)
288 
289 
290 @external
291 def apply_smart_wallet_checker():
292     """
293     @notice Apply setting external contract to check approved smart contract wallets
294     """
295     assert msg.sender == self.admin
296     self.smart_wallet_checker = self.future_smart_wallet_checker
297 
298     log SmartWalletCheckerApplied(self.smart_wallet_checker)
299 
300 @external
301 def recoverERC20(token_addr: address, amount: uint256):
302     """
303     @dev Used to recover non-FPIS ERC20 tokens
304     """
305     assert msg.sender == self.admin  # dev: admin only
306     assert token_addr != self.token  # Cannot recover FPIS. Use toggleEmergencyUnlock instead and have users pull theirs out individually
307     ERC20(token_addr).transfer(self.admin, amount)
308 
309 @internal
310 def assert_not_contract(addr: address):
311     """
312     @notice Check if the call is from a whitelisted smart contract, revert if not
313     @param addr Address to be checked
314     """
315     if addr != tx.origin:
316         checker: address = self.smart_wallet_checker
317         if checker != empty(address):
318             if SmartWalletChecker(checker).check(addr):
319                 return
320         raise "Smart contract depositors not allowed"
321 
322 @external
323 @view
324 def get_last_user_slope(addr: address) -> int128:
325     """
326     @notice Get the most recently recorded rate of voting power decrease for `addr`
327     @param addr Address of the user wallet
328     @return Value of the slope
329     """
330     uepoch: uint256 = self.user_point_epoch[addr]
331     return self.user_point_history[addr][uepoch].slope
332 
333 @external
334 @view
335 def get_last_user_bias(addr: address) -> int128:
336     """
337     @notice Get the most recently recorded bias (principal)
338     @param addr Address of the user wallet
339     @return Value of the bias
340     """
341     uepoch: uint256 = self.user_point_epoch[addr]
342     return self.user_point_history[addr][uepoch].bias
343 
344 @external
345 @view
346 def get_last_user_point(addr: address) -> Point:
347     """
348     @notice Get the most recently recorded Point for `addr`
349     @param addr Address of the user wallet
350     @return Latest Point for the user
351     """
352     uepoch: uint256 = self.user_point_epoch[addr]
353     return self.user_point_history[addr][uepoch]
354 
355 @external
356 @view
357 def user_point_history__ts(_addr: address, _idx: uint256) -> uint256:
358     """
359     @notice Get the timestamp for checkpoint `_idx` for `_addr`
360     @param _addr User wallet address
361     @param _idx User epoch number
362     @return Epoch time of the checkpoint
363     """
364     return self.user_point_history[_addr][_idx].ts
365 
366 @external
367 @view
368 def get_last_point() -> Point:
369     """
370     @notice Get the most recently recorded Point for the contract
371     @return Latest Point for the contract
372     """
373     return self.point_history[self.epoch]
374 
375 @external
376 @view
377 def locked__end(_addr: address) -> uint256:
378     """
379     @notice Get timestamp when `_addr`'s lock finishes
380     @param _addr User wallet
381     @return Epoch time of the lock end
382     """
383     return self.locked[_addr].end
384 
385 @external
386 @view
387 def locked__amount(_addr: address) -> int128:
388     """
389     @notice Get amount of `_addr`'s locked FPIS
390     @param _addr User wallet
391     @return FPIS amount locked by `_addr`
392     """
393     return self.locked[_addr].amount
394 
395 @external
396 @view
397 def curr_period_start() -> uint256:
398     """
399     @notice Get the start timestamp of this week's period
400     @return Epoch time of the period start
401     """
402     return (block.timestamp / WEEK * WEEK)
403 
404 @external
405 @view
406 def next_period_start() -> uint256:
407     """
408     @notice Get the start timestamp of next week's period
409     @return Epoch time of next week's period start
410     """
411     return (WEEK + (block.timestamp / WEEK * WEEK))
412 
413 @internal
414 def _checkpoint(addr: address, old_locked: LockedBalance, new_locked: LockedBalance, flag: int128):
415     """
416     @notice Record global and per-user data to checkpoint
417     @param addr User's wallet address. No user checkpoint if 0x0
418     @param old_locked Previous locked amount / end lock time for the user
419     @param new_locked New locked amount / end lock time for the user
420     @param flag Used for downstream logic
421     """
422     usr_old_pt: Point = empty(Point)
423     usr_new_pt: Point = empty(Point)
424     old_gbl_dslope: int128 = 0 # Old global slope change
425     new_gbl_dslope: int128 = 0 # New global slope change
426     _epoch: uint256 = self.epoch
427 
428     # ////////////////////////////////// STEP 1 //////////////////////////////////
429     # Take note of any user bias and slope changes
430     # Also note previous global slope and point
431     # ////////////////////////////////////////////////////////////////////////////
432     # Skip if a user isn't being checkpointed
433     if addr != empty(address):
434         # Calculate slopes and biases
435         # Kept at zero when they have to
436 
437         # ==============================================================================
438         # -------------------------------- Old veCRV method --------------------------------
439         # if old_locked.end > block.timestamp and old_locked.amount > 0:
440         #     usr_old_pt.slope = old_locked.amount / MAXTIME_I128
441         #     usr_old_pt.bias = usr_old_pt.slope * convert(old_locked.end - block.timestamp, int128)
442         # if new_locked.end > block.timestamp and new_locked.amount > 0:
443         #     usr_new_pt.slope = new_locked.amount / MAXTIME_I128
444         #     usr_new_pt.bias = usr_new_pt.slope * convert(new_locked.end - block.timestamp, int128)
445 
446         # -------------------------------- New method for veFPIS --------------------------------
447         if old_locked.end > block.timestamp and old_locked.amount > 0:
448             usr_old_pt.slope = (old_locked.amount * VOTE_WEIGHT_MULTIPLIER_I128) / MAXTIME_I128 
449             usr_old_pt.bias = old_locked.amount + (usr_old_pt.slope * convert(old_locked.end - block.timestamp, int128))
450         if new_locked.end > block.timestamp and new_locked.amount > 0:
451             usr_new_pt.slope = (new_locked.amount * VOTE_WEIGHT_MULTIPLIER_I128) / MAXTIME_I128
452             usr_new_pt.bias = new_locked.amount + (usr_new_pt.slope * convert(new_locked.end - block.timestamp, int128))
453         # ==============================================================================
454 
455         # Read values of scheduled changes in the slope
456         # old_locked.end can be in the past and in the future
457         # new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
458         old_gbl_dslope = self.slope_changes[old_locked.end]
459         if new_locked.end != 0:
460             if new_locked.end == old_locked.end:
461                 new_gbl_dslope = old_gbl_dslope
462             else:
463                 new_gbl_dslope = self.slope_changes[new_locked.end]
464 
465     # Get last global point and checkpoint time
466     last_point: Point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number, fpis_amt: 0})
467     if _epoch > 0:
468         last_point = self.point_history[_epoch]
469     last_checkpoint: uint256 = last_point.ts
470 
471     # initial_last_point is used for extrapolation to calculate block number
472     # (approximately, for *At methods) and save them
473     # as we cannot figure that out exactly from inside the contract
474     initial_last_point: Point = last_point
475 
476     # Calculate the average blocks per second since the last checkpoint
477     # Will use this to estimate block numbers at intermediate points in Step 2
478     block_slope: uint256 = 0  # dblock/dt
479     if block.timestamp > last_point.ts:
480         block_slope = MULTIPLIER * (block.number - last_point.blk) / (block.timestamp - last_point.ts)
481     # If last point is already recorded in this block, slope=0
482     # But that's ok b/c we know the block in such case
483 
484 
485     # ////////////////////////////////// STEP 2 //////////////////////////////////
486     # Go over past weeks to fill history and calculate what the current point is
487     # Basically "catches up" the global state
488     # Ignore user-specific deltas right now, they will be handled later
489     # ////////////////////////////////////////////////////////////////////////////
490     latest_checkpoint_ts: uint256 = (last_checkpoint / WEEK) * WEEK
491     for i in range(255):
492         # Hopefully it won't happen that this won't get used in 5 years!
493         # If it does, users will be able to withdraw but vote weight will be broken
494         latest_checkpoint_ts += WEEK
495         d_slope: int128 = 0
496         if latest_checkpoint_ts > block.timestamp:
497             latest_checkpoint_ts = block.timestamp
498         else:
499             d_slope = self.slope_changes[latest_checkpoint_ts]
500 
501         # Subtract the elapsed bias (slope * elapsed time) from the bias total
502         last_point.bias -= last_point.slope * convert(latest_checkpoint_ts - last_checkpoint, int128)
503 
504         # Add / Subtract the pre-recorded change in slope (d_slope) for this epoch to the total slope
505         # d_slope can be either positive or negative
506         last_point.slope += d_slope
507 
508         # Safety checks
509         if last_point.bias < 0:  # This can happen
510             last_point.bias = 0
511         if last_point.slope < 0:  # This cannot happen - just in case
512             last_point.slope = 0
513 
514         # Update the latest checkpoint, last_point info, and epoch
515         last_checkpoint = latest_checkpoint_ts
516         last_point.ts = latest_checkpoint_ts
517 
518         # This block number is an estimate
519         last_point.blk = initial_last_point.blk + block_slope * (latest_checkpoint_ts - initial_last_point.ts) / MULTIPLIER
520         _epoch += 1
521 
522         # Fill for the current block, if applicable
523         if latest_checkpoint_ts == block.timestamp:
524             last_point.blk = block.number
525             break
526         else:
527             self.point_history[_epoch] = last_point
528 
529     self.epoch = _epoch
530     # Now point_history is filled until t=now
531 
532 
533     # ////////////////////////////////// STEP 3 //////////////////////////////////
534     # Handle some special cases
535     # ////////////////////////////////////////////////////////////////////////////
536     # Skip if a user isn't being checkpointed
537     if addr != empty(address):
538         # If last point was in this block, the slope change has been applied already
539         # But in such case we have 0 slope(s)
540         last_point.slope += (usr_new_pt.slope - usr_old_pt.slope)
541         last_point.bias += (usr_new_pt.bias - usr_old_pt.bias)
542         
543 
544         # ==============================================================================
545         # Handle FPIS balance change (withdrawals and deposits)
546         if (new_locked.amount > old_locked.amount):
547             last_point.fpis_amt += convert(new_locked.amount - old_locked.amount, uint256)
548 
549         if (new_locked.amount < old_locked.amount):
550             last_point.fpis_amt -= convert(old_locked.amount - new_locked.amount, uint256)
551 
552             # Subtract the bias if you are slashing after expiry
553             if ((flag == PROXY_SLASH) and (new_locked.end < block.timestamp)):
554                 # Net change is the delta
555                 last_point.bias += new_locked.amount
556                 last_point.bias -= old_locked.amount
557 
558             # Remove the offset
559             # Corner case to fix issue because emergency unlock allows withdrawal before expiry and disrupts the math
560             if (new_locked.amount == 0):
561                 if (not (self.emergencyUnlockActive)):
562                     # Net change is the delta
563                     # last_point.bias += new_locked.amount WILL BE ZERO
564                     last_point.bias -= old_locked.amount
565 
566         # ==============================================================================
567 
568         # Check for zeroes
569         if last_point.slope < 0:
570             last_point.slope = 0
571         if last_point.bias < 0:
572             last_point.bias = 0
573 
574 
575     # Record the changed point into history
576     self.point_history[_epoch] = last_point
577 
578 
579     # ////////////////////////////////// STEP 4 //////////////////////////////////
580     # Handle global slope changes and user point historical info
581     # ////////////////////////////////////////////////////////////////////////////
582     # Skip if a user isn't being checkpointed
583     if addr != empty(address):
584         # Schedule the slope changes (slope is going down)
585         # We subtract new_user_slope from [new_locked.end]
586         # and add old_user_slope to [old_locked.end]
587         if old_locked.end > block.timestamp:
588             # old_gbl_dslope was <something> - usr_old_pt.slope, so we cancel that
589             old_gbl_dslope += usr_old_pt.slope
590             if new_locked.end == old_locked.end:
591                 old_gbl_dslope -= usr_new_pt.slope  # It was a new deposit, not extension
592             self.slope_changes[old_locked.end] = old_gbl_dslope
593 
594         if new_locked.end > block.timestamp:
595             if new_locked.end > old_locked.end:
596                 new_gbl_dslope -= usr_new_pt.slope  # old slope disappeared at this point
597                 self.slope_changes[new_locked.end] = new_gbl_dslope
598             # else: we recorded it already in old_gbl_dslope
599 
600         # Now handle user history
601         user_epoch: uint256 = self.user_point_epoch[addr] + 1
602 
603         # Update tracked info for user
604         self.user_point_epoch[addr] = user_epoch
605         usr_new_pt.ts = block.timestamp
606         usr_new_pt.blk = block.number
607         usr_new_pt.fpis_amt = convert(self.locked[addr].amount, uint256)
608 
609         # Final check
610         # At the end of the day, if the user is expired, their bias should be self.locked[addr].amount (fpis_amt)
611         # And their slope, 0
612         if new_locked.end < block.timestamp:
613             usr_new_pt.bias = self.locked[addr].amount
614             usr_new_pt.slope = 0
615 
616         self.user_point_history[addr][user_epoch] = usr_new_pt
617 
618 
619 @internal
620 def _deposit_for(_staker_addr: address, _payer_addr: address, _value: uint256, unlock_time: uint256, locked_balance: LockedBalance, flag: int128):
621     """
622     @notice Deposit and lock tokens for a user
623     @param _staker_addr User's wallet address
624     @param _payer_addr Payer address for the deposit
625     @param _value Amount to deposit
626     @param unlock_time New time when to unlock the tokens, or 0 if unchanged
627     @param locked_balance Previous locked amount / timestamp
628     """
629 
630     # Pull in the tokens first before modifying state
631     assert ERC20(self.token).transferFrom(_payer_addr, self, _value)
632 
633     # Note original data
634     old_locked: LockedBalance = locked_balance
635     supply_before: uint256 = self.supply
636 
637     # Get the staker's balance and the total supply
638     new_locked: LockedBalance = old_locked # Will be incremented soon
639     
640     # Increase the supply
641     self.supply = supply_before + _value
642 
643     # Add to an existing lock, or if the lock is expired - create a new one
644     new_locked.amount += convert(_value, int128)
645     if unlock_time != 0:
646         new_locked.end = unlock_time
647     self.locked[_staker_addr] = new_locked
648 
649     # Possibilities:
650     # Both old_locked.end could be current or expired (>/< block.timestamp)
651     # value == 0 (extend lock) or value > 0 (add to lock or extend lock)
652     # new_locked.end > block.timestamp (always)
653     self._checkpoint(_staker_addr, old_locked, new_locked, flag)
654 
655     log Deposit(_staker_addr, _payer_addr, _value, new_locked.end, flag, block.timestamp)
656     log Supply(supply_before, supply_before + _value)
657 
658 
659 @external
660 def checkpoint():
661     """
662     @notice Record global data to checkpoint
663     """
664     self._checkpoint(empty(address), empty(LockedBalance), empty(LockedBalance), 0)
665 
666 
667 @external
668 @nonreentrant('lock')
669 def create_lock(_value: uint256, _unlock_time: uint256):
670     """
671     @notice Deposit `_value` tokens for `msg.sender` and lock until `_unlock_time`
672     @param _value Amount to deposit
673     @param _unlock_time Epoch time when tokens unlock, rounded down to whole weeks
674     """
675     self.assert_not_contract(msg.sender)
676     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
677     _locked: LockedBalance = self.locked[msg.sender]
678 
679     assert _value > 0, "Value must be > 0"  # dev: need non-zero value
680     assert _locked.amount == 0, "Withdraw old tokens first"
681     assert unlock_time > block.timestamp, "Can only lock until time in the future"
682     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
683 
684     self._deposit_for(msg.sender, msg.sender, _value, unlock_time, _locked, CREATE_LOCK_TYPE)
685 
686 @internal
687 def _increase_amount(_staker_addr: address, _payer_addr: address, _value: uint256):
688     """
689     @notice Deposit `_value` additional tokens for `_staker_addr`
690             without modifying the unlock time or creating a new stake
691     @param _staker_addr The user that the tokens should be credited to
692     @param _staker_addr Payer of the FPIS
693     @param _value Amount of tokens to deposit and add to the lock
694     """
695     if ((_payer_addr != self.current_proxy) and (not self.historical_proxies[_payer_addr])):
696         self.assert_not_contract(_payer_addr) # Payer should either be a proxy, EOA, or authorized contract
697 
698     self.assert_not_contract(_staker_addr) # The staker should not be unauthorized
699     
700     _locked: LockedBalance = self.locked[_staker_addr]
701     
702     assert _value > 0, "Value must be > 0"  # dev: need non-zero value
703     assert _locked.amount > 0, "No existing lock found"
704     assert _locked.end > block.timestamp, "Cannot add to expired lock. Withdraw"
705 
706     self._deposit_for(_staker_addr, _payer_addr, _value, 0, _locked, INCREASE_LOCK_AMOUNT)
707 
708 @external
709 @nonreentrant('lock')
710 def increase_amount(_value: uint256):
711     """
712     @notice Deposit `_value` additional tokens for `msg.sender`
713             without modifying the unlock time
714     @param _value Amount of tokens to deposit and add to the lock
715     """
716     self._increase_amount(msg.sender, msg.sender, _value)
717 
718 @external
719 @nonreentrant('lock')
720 def increase_amount_for(_staker_addr: address, _value: uint256):
721     """
722     @notice Deposit `_value` additional tokens for `_staker_addr`
723             without modifying the unlock time or creating a new stake.
724             msg.sender is payer.
725     @param _staker_addr The user that the tokens should be credited to
726     @param _value Amount of tokens to deposit and add to the lock
727     """
728     assert (self.appIncreaseAmountForsEnabled), "Currently disabled"
729 
730     # Sender is payer. Make sure to have it approve to veFPIS first
731     self._increase_amount(_staker_addr, msg.sender, _value)
732 
733 @external
734 @nonreentrant('lock')
735 def checkpoint_user(_staker_addr: address):
736     """
737     @notice Simply updates the slope, bias, etc for a user.
738     @param _staker_addr The user to update
739     """
740     _locked: LockedBalance = self.locked[_staker_addr]
741     
742     assert _locked.amount > 0, "No existing lock found"
743     # assert _locked.end > block.timestamp, "Expired lock"
744 
745     self._deposit_for(_staker_addr, _staker_addr, 0, 0, _locked, CHECKPOINT_ONLY)
746 
747 
748 @external
749 @nonreentrant('lock')
750 def increase_unlock_time(_unlock_time: uint256):
751     """
752     @notice Extend the unlock time for `msg.sender` to `_unlock_time`
753     @param _unlock_time New epoch time for unlocking
754     """
755     self.assert_not_contract(msg.sender)
756     _locked: LockedBalance = self.locked[msg.sender]
757     unlock_time: uint256 = (_unlock_time / WEEK) * WEEK  # Locktime is rounded down to weeks
758 
759     assert _locked.end > block.timestamp, "Lock expired"
760     assert _locked.amount > 0, "Nothing is locked"
761     assert unlock_time > _locked.end, "Can only increase lock duration"
762     assert unlock_time <= block.timestamp + MAXTIME, "Voting lock can be 4 years max"
763 
764     self._deposit_for(msg.sender, msg.sender, 0, unlock_time, _locked, INCREASE_UNLOCK_TIME)
765 
766 
767 @internal
768 def _withdraw(staker_addr: address, addr_out: address, locked_in: LockedBalance, amount_in: int128, flag: int128):
769     """
770     @notice Withdraw tokens for `staker_addr`
771     @dev Must be greater than 0 and less than the user's locked amount
772     @dev Only special users can withdraw less than the full locked amount (namely lending platforms, etc)
773     """
774     assert ((amount_in >= 0) and (amount_in <= locked_in.amount)), "Cannot withdraw more than the user has"
775     _locked: LockedBalance = locked_in
776     value: uint256 = convert(amount_in, uint256)
777 
778     old_locked: LockedBalance = _locked
779     if (amount_in == _locked.amount):
780         _locked.end = 0 # End the position if doing a full withdrawal
781     _locked.amount -= amount_in
782 
783     self.locked[staker_addr] = _locked
784     supply_before: uint256 = self.supply
785     self.supply = supply_before - value
786 
787     # old_locked can have either expired <= timestamp or zero end
788     # _locked has only 0 end
789     # Both can have >= 0 amount
790     # addr: address, old_locked: LockedBalance, new_locked: LockedBalance
791     self._checkpoint(staker_addr, old_locked, _locked, flag)
792 
793     # Transfer out the tokens at the very end
794     assert ERC20(self.token).transfer(addr_out, value), "ERC20 transfer out failed"
795 
796     log Withdraw(staker_addr, addr_out, value, block.timestamp)
797     log Supply(supply_before, supply_before - value)
798 
799 @external
800 @nonreentrant('proxy')
801 def proxy_add(
802     _staker_addr: address, 
803     _add_amt: uint256, 
804 ):
805     """
806     @notice Proxy increaes `_staker_addr`'s veFPIS base / bias. Usually due to rewards on an app
807     @param _staker_addr The target veFPIS staker address to act on
808     """
809     # Make sure that the function isn't disabled, and also that the proxy is valid
810     assert (self.proxyAddsEnabled), "Currently disabled"
811     assert (msg.sender == self.current_proxy or self.historical_proxies[msg.sender]), "Proxy not whitelisted [admin level]"
812     assert (msg.sender == self.staker_whitelisted_proxy[_staker_addr]), "Proxy not whitelisted [staker level]"
813 
814     # NOTE: IF YOU ACTUALLY WANT TO TRANSFER TOKENS, YOU CAN USE
815     # _deposit_for() instead of below
816 
817     # Get the staker's locked position and proxy balance
818     old_locked: LockedBalance = self.locked[_staker_addr]
819     _proxy_balance: uint256 = self.user_proxy_balance[_staker_addr]
820 
821     # Validate some things
822     assert old_locked.amount > 0, "No existing lock found"
823     assert (_add_amt) > 0, "Amount must be non-zero"
824 
825     # Increase the proxy balance 
826     self.user_proxy_balance[_staker_addr] += _add_amt
827 
828     # Note original data
829     supply_before: uint256 = self.supply
830 
831     # Get the staker's balance and the total supply
832     new_locked: LockedBalance = old_locked # Will be incremented soon
833     
834     # Increase the supply
835     self.supply += _add_amt
836 
837     # Add to an existing lock
838     new_locked.amount += convert(_add_amt, int128)
839     self.locked[_staker_addr] = new_locked
840 
841     # Checkpoint:
842     self._checkpoint(_staker_addr, old_locked, new_locked, PROXY_ADD)
843 
844     # Events
845     log ProxyAdd(_staker_addr, msg.sender, _add_amt)
846     log Supply(supply_before, supply_before + _add_amt)
847 
848 
849 @external
850 @nonreentrant('proxy')
851 def proxy_slash(
852     _staker_addr: address, 
853     _slash_amt: uint256, 
854 ):
855     """
856     @notice Proxy increaes `_staker_addr`'s veFPIS base / bias. Usually due to rewards on an app
857     @param _staker_addr The target veFPIS staker address to act on
858     """
859     # Make sure that the function isn't disabled, and also that the proxy is valid
860     assert (self.proxyAddsEnabled), "Currently disabled"
861     assert (msg.sender == self.current_proxy or self.historical_proxies[msg.sender]), "Proxy not whitelisted [admin level]"
862     assert (msg.sender == self.staker_whitelisted_proxy[_staker_addr]), "Proxy not whitelisted [staker level]"
863 
864     # NOTE: IF YOU ACTUALLY WANT TO TRANSFER TOKENS, YOU CAN USE
865     # _deposit_for() instead of below
866 
867     # Get the staker's locked position and proxy balance
868     old_locked: LockedBalance = self.locked[_staker_addr]
869     _proxy_balance: uint256 = self.user_proxy_balance[_staker_addr]
870 
871     # Validate some things
872     assert old_locked.amount > 0, "No existing lock found"
873     assert (_slash_amt) > 0, "Amount must be non-zero"
874 
875     # Decrease the proxy balance 
876     assert (self.user_proxy_balance[_staker_addr] >= _slash_amt), "Trying to slash too much"
877     self.user_proxy_balance[_staker_addr] -= _slash_amt
878 
879     # Note original data
880     supply_before: uint256 = self.supply
881 
882     # Get the staker's balance and the total supply
883     new_locked: LockedBalance = old_locked # Will be decremented soon
884     
885     # Decrease the supply
886     self.supply -= _slash_amt
887 
888     # Remove from an existing lock
889     new_locked.amount -= convert(_slash_amt, int128)
890     self.locked[_staker_addr] = new_locked
891 
892     # Checkpoint:
893     self._checkpoint(_staker_addr, old_locked, new_locked, PROXY_SLASH)
894 
895     # Events
896     log ProxyAdd(_staker_addr, msg.sender, _slash_amt)
897     log Supply(supply_before, supply_before - _slash_amt)
898 
899 @external
900 @nonreentrant('lock')
901 def withdraw():
902     """
903     @notice Withdraw all tokens for `msg.sender`
904     @dev Only possible if the lock has expired or the emergency unlock is active
905     @dev Also need to make sure all debts to the proxy, if any, are paid off first
906     """
907     # Get the staker's locked position
908     _locked: LockedBalance = self.locked[msg.sender]
909 
910     # Validate some things
911     assert ((block.timestamp >= _locked.end) or (self.emergencyUnlockActive)), "The lock didn't expire"
912     assert (self.user_proxy_balance[msg.sender] == 0), "Outstanding FPIS in proxy"
913     
914     # Allow the withdrawal
915     self._withdraw(msg.sender, msg.sender, _locked, _locked.amount, USER_WITHDRAW)
916 
917 @external
918 @nonreentrant('proxy')
919 def transfer_from_app(_staker_addr: address, _app_addr: address, _transfer_amt: int128):
920     """
921     @notice Transfer tokens from a proxy-connected app to the veFPIS contract
922     @dev Only possible for whitelisted proxies, both by the admin and by the staker
923     @dev Only proxy and staker are checked, not the app, so make sure to do that at the proxy level
924     @dev Make sure app does the approval to veFPIS first
925     """
926     # Make sure that the function isn't disabled, and also that the proxy is valid
927     assert (self.appTransferFromsEnabled), "Currently disabled"
928     assert (msg.sender == self.current_proxy or self.historical_proxies[msg.sender]), "Proxy not whitelisted [admin level]"
929     assert (msg.sender == self.staker_whitelisted_proxy[_staker_addr]), "Proxy not whitelisted [staker level]"
930     
931     # Get the staker's locked position
932     _locked: LockedBalance = self.locked[_staker_addr]
933     assert _locked.amount > 0, "No existing lock found"
934 
935     # Note the amount to be moved to the veFPIS contract 
936     _value: uint256 = convert(_transfer_amt, uint256)
937     assert (self.user_proxy_balance[_staker_addr] >= _value), "Trying to transfer back too much"
938     self.user_proxy_balance[_staker_addr] -= _value
939 
940     # Allow the transfer to the app.
941     # This will not reduce the user's veFPIS balance
942     assert ERC20(self.token).transferFrom(_app_addr, self, _value)
943 
944     # Checkpoint
945     self._checkpoint(_staker_addr, _locked, _locked, TRANSFER_FROM_APP)
946 
947     log TransferFromApp(_app_addr, _staker_addr, _value)
948 
949 @external
950 @nonreentrant('proxy')
951 def transfer_to_app(_staker_addr: address, _app_addr: address, _transfer_amt: int128):
952     """
953     @notice Transfer tokens for `_staker_addr` to a proxy-connected app directly, to be loaned or otherwise used
954     @dev Only possible for whitelisted proxies, both by the admin and by the staker
955     @dev Only proxy and staker are checked, not the app, so make sure to do that at the proxy level
956     """
957     # Make sure that the function isn't disabled, and also that the proxy is valid
958     assert (self.appTransferTosEnabled), "Currently disabled"
959     assert (msg.sender == self.current_proxy or self.historical_proxies[msg.sender]), "Proxy not whitelisted [admin level]"
960     assert (msg.sender == self.staker_whitelisted_proxy[_staker_addr]), "Proxy not whitelisted [staker level]"
961     
962     # Get the staker's locked position
963     _locked: LockedBalance = self.locked[_staker_addr]
964     _locked_amt: uint256 = convert(_locked.amount, uint256)
965 
966     # Make sure the position isn't expired (no outbound transfers after expiry)
967     assert (block.timestamp < _locked.end), "No transfers after expiration"
968 
969     # Note the amount to be moved to the app 
970     _value: uint256 = convert(_transfer_amt, uint256)
971     self.user_proxy_balance[_staker_addr] += _value
972 
973     # Make sure total user transfers do not surpass user locked balance
974     assert (self.user_proxy_balance[_staker_addr] <= _locked_amt), "Amount exceeds locked balance"
975 
976     # Allow the transfer to the app.
977     # This will not reduce the user's veFPIS balance
978     assert ERC20(self.token).transfer(_app_addr, _value)
979 
980     # Checkpoint
981     self._checkpoint(_staker_addr, _locked, _locked, TRANSFER_TO_APP)
982 
983     log TransferToApp(_staker_addr, _app_addr, _value)
984 
985 
986 
987 @internal
988 @view
989 def find_block_epoch(_block: uint256, max_epoch: uint256) -> uint256:
990     """
991     @notice Binary search to estimate timestamp for block number
992     @param _block Block to find
993     @param max_epoch Don't go beyond this epoch
994     @return Approximate timestamp for block
995     """
996     # Binary search
997     _min: uint256 = 0
998     _max: uint256 = max_epoch
999     for i in range(128):  # Will be always enough for 128-bit numbers
1000         if _min >= _max:
1001             break
1002         _mid: uint256 = (_min + _max + 1) / 2
1003         if self.point_history[_mid].blk <= _block:
1004             _min = _mid
1005         else:
1006             _max = _mid - 1
1007     return _min
1008 
1009 
1010 @external
1011 @view
1012 def balanceOf(addr: address, _t: uint256 = block.timestamp) -> uint256:
1013     """
1014     @notice Get the current voting power for `msg.sender`
1015     @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
1016     @param addr User wallet address
1017     @param _t Epoch time to return voting power at
1018     @return User voting power
1019     """
1020     _epoch: uint256 = self.user_point_epoch[addr]
1021     if _epoch == 0:
1022         return 0
1023     else:
1024         # Just leave this alone. It is fine if it decays to 1 veFPIS = 1 bias
1025         # Otherwise it would be inconsistent with totalSupply and totalSupplyAt
1026         # _locked: LockedBalance = self.locked[addr]
1027         # if (block.timestamp >= _locked.end): return 0
1028 
1029         last_point: Point = self.user_point_history[addr][_epoch]
1030         last_point.bias -= last_point.slope * convert(_t - last_point.ts, int128)
1031         if last_point.bias < 0:
1032             last_point.bias = 0
1033 
1034         # ==============================================================================
1035         # -------------------------------- veCRV method --------------------------------
1036         # weighted_supply: uint256 = convert(last_point.bias, uint256)
1037 
1038         # -------------------------------- veFPIS --------------------------------
1039         # Mainly used to counter negative biases
1040         weighted_supply: uint256 = convert(last_point.bias, uint256)
1041         if weighted_supply < last_point.fpis_amt:
1042             weighted_supply = last_point.fpis_amt
1043         
1044 
1045         # ==============================================================================
1046 
1047         return weighted_supply
1048 
1049 
1050 @external
1051 @view
1052 def balanceOfAt(addr: address, _block: uint256) -> uint256:
1053     """
1054     @notice Measure voting power of `addr` at block height `_block`
1055     @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
1056     @param addr User's wallet address
1057     @param _block Block to calculate the voting power at
1058     @return Voting power
1059     """
1060     # Copying and pasting totalSupply code because Vyper cannot pass by
1061     # reference yet
1062     assert _block <= block.number
1063 
1064     # Binary search
1065     _min: uint256 = 0
1066     _max: uint256 = self.user_point_epoch[addr]
1067     for i in range(128):  # Will be always enough for 128-bit numbers
1068         if _min >= _max:
1069             break
1070         _mid: uint256 = (_min + _max + 1) / 2
1071         if self.user_point_history[addr][_mid].blk <= _block:
1072             _min = _mid
1073         else:
1074             _max = _mid - 1
1075 
1076     upoint: Point = self.user_point_history[addr][_min]
1077 
1078     max_epoch: uint256 = self.epoch
1079     _epoch: uint256 = self.find_block_epoch(_block, max_epoch)
1080     point_0: Point = self.point_history[_epoch]
1081     d_block: uint256 = 0
1082     d_t: uint256 = 0
1083     if _epoch < max_epoch:
1084         point_1: Point = self.point_history[_epoch + 1]
1085         d_block = point_1.blk - point_0.blk
1086         d_t = point_1.ts - point_0.ts
1087     else:
1088         d_block = block.number - point_0.blk
1089         d_t = block.timestamp - point_0.ts
1090     block_time: uint256 = point_0.ts
1091     if d_block != 0:
1092         block_time += d_t * (_block - point_0.blk) / d_block
1093 
1094     upoint.bias -= upoint.slope * convert(block_time - upoint.ts, int128)
1095 
1096     # ==============================================================================
1097     # -------------------------------- veCRV method --------------------------------
1098     # if upoint.bias >= 0:
1099     #     return convert(upoint.bias, uint256)
1100     # else:
1101     #     return 0
1102 
1103     # ----------------------------------- veFPIS -----------------------------------
1104     if ((upoint.bias >= 0) or (upoint.fpis_amt >= 0)):
1105         return convert(upoint.bias, uint256)
1106     else:
1107         return 0
1108     # ==============================================================================
1109 
1110         
1111 @internal
1112 @view
1113 def supply_at(point: Point, t: uint256) -> uint256:
1114     """
1115     @notice Calculate total voting power at some point in the past
1116     @param point The point (bias/slope) to start search from
1117     @param t Time to calculate the total voting power at
1118     @return Total voting power at that time
1119     """
1120     last_point: Point = point
1121     t_i: uint256 = (last_point.ts / WEEK) * WEEK
1122     for i in range(255):
1123         t_i += WEEK
1124         d_slope: int128 = 0
1125         if t_i > t:
1126             t_i = t
1127         else:
1128             d_slope = self.slope_changes[t_i]
1129         last_point.bias -= last_point.slope * convert(t_i - last_point.ts, int128)
1130         if t_i == t:
1131             break
1132         last_point.slope += d_slope
1133         last_point.ts = t_i
1134 
1135     if last_point.bias < 0:
1136         last_point.bias = 0
1137 
1138     # ==============================================================================
1139     # ----------------------------------- veCRV ------------------------------------
1140     # weighted_supply: uint256 = convert(last_point.bias, uint256)
1141 
1142     # ----------------------------------- veFPIS -----------------------------------
1143     weighted_supply: uint256 = convert(last_point.bias, uint256)
1144     if weighted_supply < last_point.fpis_amt:
1145         weighted_supply = last_point.fpis_amt
1146 
1147     # ==============================================================================
1148 
1149     return weighted_supply
1150 
1151 
1152 @external
1153 @view
1154 def totalSupply(t: uint256 = block.timestamp) -> uint256:
1155     """
1156     @notice Calculate total voting power
1157     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
1158     @return Total voting power
1159     """
1160     _epoch: uint256 = self.epoch
1161     last_point: Point = self.point_history[_epoch]
1162     return self.supply_at(last_point, t)
1163 
1164 
1165 @external
1166 @view
1167 def totalSupplyAt(_block: uint256) -> uint256:
1168     """
1169     @notice Calculate total voting power at some point in the past
1170     @param _block Block to calculate the total voting power at
1171     @return Total voting power at `_block`
1172     """
1173     assert _block <= block.number
1174     _epoch: uint256 = self.epoch
1175     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
1176 
1177     point: Point = self.point_history[target_epoch]
1178     dt: uint256 = 0
1179     if target_epoch < _epoch:
1180         point_next: Point = self.point_history[target_epoch + 1]
1181         if point.blk != point_next.blk:
1182             dt = (_block - point.blk) * (point_next.ts - point.ts) / (point_next.blk - point.blk)
1183     else:
1184         if point.blk != block.number:
1185             dt = (_block - point.blk) * (block.timestamp - point.ts) / (block.number - point.blk)
1186     # Now dt contains info on how far are we beyond point
1187 
1188     return self.supply_at(point, point.ts + dt)
1189 
1190 @external
1191 @view
1192 def totalFPISSupply() -> uint256:
1193     """
1194     @notice Calculate FPIS supply
1195     @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
1196     @return Total FPIS supply
1197     """
1198     return self.supply # Don't use ERC20(self.token).balanceOf(self)
1199 
1200 @external
1201 @view
1202 def totalFPISSupplyAt(_block: uint256) -> uint256:
1203     """
1204     @notice Calculate total FPIS at some point in the past
1205     @param _block Block to calculate the total voting power at
1206     @return Total FPIS supply at `_block`
1207     """
1208     assert _block <= block.number
1209     _epoch: uint256 = self.epoch
1210     target_epoch: uint256 = self.find_block_epoch(_block, _epoch)
1211     point: Point = self.point_history[target_epoch]
1212     return point.fpis_amt
1213 
1214 @external
1215 def toggleEmergencyUnlock():
1216     """
1217     @dev Used to allow early withdrawals of veFPIS back into FPIS, in case of an emergency
1218     """
1219     assert msg.sender == self.admin  # dev: admin only
1220     self.emergencyUnlockActive = not (self.emergencyUnlockActive)
1221     self._checkpoint(empty(address), empty(LockedBalance), empty(LockedBalance), 0)
1222 
1223     log EmergencyUnlockToggled(self.emergencyUnlockActive)
1224 
1225 @external
1226 def toggleAppIncreaseAmountFors():
1227     """
1228     @dev Toggles the ability for the proxy to directly deposit FPIS for a user, increasing their existing stake only
1229     """
1230     assert msg.sender == self.admin  # dev: admin only
1231     self.appIncreaseAmountForsEnabled = not (self.appIncreaseAmountForsEnabled)
1232     self._checkpoint(empty(address), empty(LockedBalance), empty(LockedBalance), 0)
1233 
1234     log AppIncreaseAmountForsToggled(self.appIncreaseAmountForsEnabled)
1235 
1236 @external
1237 def toggleTransferFromApp():
1238     """
1239     @dev Toggles the ability to receive FPIS from apps
1240     """
1241     assert msg.sender == self.admin  # dev: admin only
1242     self.appTransferFromsEnabled = not (self.appTransferFromsEnabled)
1243     self._checkpoint(empty(address), empty(LockedBalance), empty(LockedBalance), 0)
1244 
1245     log ProxyTransferFromsToggled(self.appTransferFromsEnabled)
1246 
1247 @external
1248 def toggleTransferToApp():
1249     """
1250     @dev Toggles the ability to send FPIS to apps
1251     """
1252     assert msg.sender == self.admin  # dev: admin only
1253     self.appTransferTosEnabled = not (self.appTransferTosEnabled)
1254     self._checkpoint(empty(address), empty(LockedBalance), empty(LockedBalance), 0)
1255 
1256     log ProxyTransferTosToggled(self.appTransferTosEnabled)
1257 
1258 @external
1259 def toggleProxyAdds():
1260     """
1261     @dev Toggles the ability for the proxy to add FPIS credit to user 
1262     """
1263     assert msg.sender == self.admin  # dev: admin only
1264     self.proxyAddsEnabled = not (self.proxyAddsEnabled)
1265     self._checkpoint(empty(address), empty(LockedBalance), empty(LockedBalance), 0)
1266 
1267     log ProxyAddsToggled(self.proxyAddsEnabled)
1268 
1269 
1270 @external
1271 def toggleProxySlashes():
1272     """
1273     @dev Toggles the ability for the proxy to subtract FPIS from a user 
1274     """
1275     assert msg.sender == self.admin  # dev: admin only
1276     self.proxySlashesEnabled = not (self.proxySlashesEnabled)
1277     self._checkpoint(empty(address), empty(LockedBalance), empty(LockedBalance), 0)
1278 
1279     log ProxySlashesToggled(self.proxySlashesEnabled)
1280 
1281 @external
1282 def adminSetProxy(_proxy: address):
1283     """
1284     @dev Admin sets the lending proxy
1285     @param _proxy The lending proxy address 
1286     """
1287     assert msg.sender == self.admin, "Admin only"  # dev: admin only
1288     self.current_proxy = _proxy
1289     self.historical_proxies[_proxy] = True
1290 
1291     log LendingProxySet(_proxy)
1292 
1293 @external
1294 def adminToggleHistoricalProxy(_proxy: address):
1295     """
1296     @dev Admin can manipulate a historical proxy if needed (normally done automatically in adminSetProxy)
1297     @dev This is needed if the main current_proxy changes and and old proxy needs to pay back or liquidate a user
1298     @dev Or if there is something wrong with an older proxy
1299     @param _proxy The lending proxy address 
1300     """
1301     assert msg.sender == self.admin, "Admin only"  # dev: admin only
1302     self.historical_proxies[_proxy] = not self.historical_proxies[_proxy]
1303 
1304     log HistoricalProxyToggled(_proxy, self.historical_proxies[_proxy])
1305 
1306 
1307 @external
1308 def stakerSetProxy(_proxy: address):
1309     """
1310     @dev Staker lets a particular address do activities on their behalf
1311     @dev Each staker can only have one proxy, to keep things / collateral / LTC calculations simple
1312     @param _proxy The address the staker will let withdraw/deposit for them 
1313     """
1314     # Do some checks
1315     assert (_proxy == empty(address) or self.current_proxy == _proxy), "Proxy not whitelisted [admin level]"
1316     assert (self.user_proxy_balance[msg.sender] == 0), "Outstanding FPIS in proxy"
1317 
1318     # Set the proxy
1319     self.staker_whitelisted_proxy[msg.sender] = _proxy
1320 
1321     log StakerProxySet(_proxy)