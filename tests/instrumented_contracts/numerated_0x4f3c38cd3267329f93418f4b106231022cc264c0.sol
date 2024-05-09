1 #------------------------------------------------------------------------------
2 #
3 #   Copyright 2019 Fetch.AI Limited
4 #
5 #   Licensed under the Apache License, Version 2.0 (the "License");
6 #   you may not use this file except in compliance with the License.
7 #   You may obtain a copy of the License at
8 #
9 #       http://www.apache.org/licenses/LICENSE-2.0
10 #
11 #   Unless required by applicable law or agreed to in writing, software
12 #   distributed under the License is distributed on an "AS IS" BASIS,
13 #   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14 #   See the License for the specific language governing permissions and
15 #   limitations under the License.
16 #
17 #------------------------------------------------------------------------------
18 from vyper.interfaces import ERC20
19 
20 units: {
21     tok: "smallest ERC20 token unit",
22 }
23 
24 # maximum possible number of stakers a new auction can specify
25 MAX_SLOTS: constant(uint256) = 200
26 # number of blocks during which the auction remains open at reserve price
27 RESERVE_PRICE_DURATION: constant(uint256) = 25  # number of blocks
28 # number of seconds before deletion of the contract becomes possible after last lockupEnd() call
29 DELETE_PERIOD: constant(timedelta) = 60 * (3600 * 24)
30 # defining the decimals supported in pool rewards per token
31 REWARD_PER_TOK_DENOMINATOR: constant(uint256(tok)) = 100000
32 
33 # Structs
34 struct Auction:
35     finalPrice: uint256(tok)
36     lockupEnd: uint256
37     slotsSold: uint256
38     start: uint256
39     end: uint256
40     startStake: uint256(tok)
41     reserveStake: uint256(tok)
42     declinePerBlock: uint256(tok)
43     slotsOnSale: uint256
44     rewardPerSlot: uint256(tok)
45     uniqueStakers: uint256
46 
47 struct Pledge:
48     amount: uint256(tok)
49     AID: uint256
50     pool: address
51 
52 struct Pool:
53     remainingReward: uint256(tok)
54     rewardPerTok: uint256(tok)
55     AID: uint256
56 
57 struct VirtTokenHolder:
58     isHolder: bool
59     limit: uint256(tok)
60     rewards: uint256(tok)
61 
62 # Events
63 Bid: event({AID: uint256, _from: indexed(address), currentPrice: uint256(tok), amount: uint256(tok)})
64 NewAuction: event({AID: uint256, start: uint256, end: uint256,
65     lockupEnd: uint256, startStake: uint256(tok), reserveStake: uint256(tok),
66     declinePerBlock: uint256(tok), slotsOnSale: uint256,
67     rewardPerSlot: uint256(tok)})
68 PoolRegistration: event({AID: uint256, _address: address,
69     maxStake: uint256(tok), rewardPerTok: uint256(tok)})
70 NewPledge: event({AID: uint256, _from: indexed(address), operator: address, amount: uint256(tok)})
71 IncreasedPledge: event({AID: uint256, _from: indexed(address), operator: address, topup: uint256(tok)})
72 AuctionFinalised: event({AID: uint256, finalPrice: uint256(tok), slotsSold: uint256(tok)})
73 LockupEnded: event({AID: uint256})
74 AuctionAborted: event({AID: uint256, rewardsPaid: bool})
75 SelfStakeWithdrawal: event({_from: indexed(address), amount: uint256(tok)})
76 PledgeWithdrawal: event({_from: indexed(address), amount: uint256(tok)})
77 
78 # Contract state
79 token: ERC20
80 owner: public(address)
81 earliestDelete: public(timestamp)
82 # address -> uint256 Slots a staker has won in the current auction (cleared at endLockup())
83 stakerSlots: map(address, uint256)
84 # auction winners
85 stakers: address[MAX_SLOTS]
86 
87 # pledged stake + committed pool reward, excl. selfStakerDeposit; pool -> deposits
88 poolDeposits: public(map(address, uint256(tok)))
89 # staker (through pool) -> Pledge{pool, amount}
90 pledges: public(map(address, Pledge))
91 # staker (directly) -> amount
92 selfStakerDeposits: public(map(address, uint256(tok)))
93 # staker (directly) -> price at which the bid was made
94 priceAtBid: public(map(address, uint256(tok)))
95 # pool address -> Pool
96 registeredPools: public(map(address, Pool))
97 
98 # Auction details
99 currentAID: public(uint256)
100 auction: public(Auction)
101 totalAuctionRewards: public(uint256(tok))
102 
103 # Virtual token management
104 virtTokenHolders: public(map(address, VirtTokenHolder))
105 
106 ################################################################################
107 # Constant functions
108 ################################################################################
109 # @notice True from auction initialisation until either we hit the lower bound on being clear or
110 #   the auction finalised through finaliseAuction()
111 @private
112 @constant
113 def _isBiddingPhase() -> bool:
114     return ((self.auction.lockupEnd > 0)
115             and (block.number < self.auction.end)
116             and (self.auction.slotsSold < self.auction.slotsOnSale)
117             and (self.auction.finalPrice == 0))
118 
119 # @notice Returns true if either the auction has been finalised or the lockup has ended
120 # @dev self.auction will be cleared in endLockup() call
121 # @dev reserveStake > 0 condition in initialiseAuction() guarantees that finalPrice = 0 can never be
122 #   a valid final price
123 @private
124 @constant
125 def _isFinalised() -> bool:
126     return (self.auction.finalPrice > 0) or (self.auction.lockupEnd == 0)
127 
128 # @notice Calculate the scheduled, linearly declining price of the dutch auction
129 @private
130 @constant
131 def _getScheduledPrice() -> uint256(tok):
132     startStake_: uint256(tok) = self.auction.startStake
133     start: uint256 = self.auction.start
134     if (block.number <= start):
135         return startStake_
136     else:
137         # do not calculate max(startStake - decline, reserveStake) as that could throw on negative startStake - decline
138         decline: uint256(tok) = min(self.auction.declinePerBlock * (block.number - start),
139                                     startStake_ - self.auction.reserveStake)
140         return startStake_ - decline
141 
142 # @notice Returns the scheduled price of the auction until the auction is finalised. Then returns
143 #   the final price.
144 # @dev Auction price declines linearly from auction.start over _duration, then
145 # stays at _reserveStake for RESERVE_PRICE_DURATION
146 # @dev Returns zero If no auction is in bidding or lock-up phase
147 @private
148 @constant
149 def _getCurrentPrice() -> (uint256(tok)):
150     if self._isFinalised():
151         return self.auction.finalPrice
152     else:
153         scheduledPrice: uint256(tok) = self._getScheduledPrice()
154         return scheduledPrice
155 
156 # @notice Returns the lockup needed by an address that stakes directly
157 # @dev Will throw if _address is a bidder in current auction & auciton not yet finalised, as the
158 #   slot number & price are not final yet
159 # @dev Calling endLockup() will clear all stakerSlots flags and thereby set the required
160 #   lockups to 0 for all participants
161 @private
162 @constant
163 def _calculateSelfStakeNeeded(_address: address) -> uint256(tok):
164     selfStakeNeeded: uint256(tok) = 0
165     # these slots can be outdated if auction is not yet finalised / lockup hasn't ended yet
166     slotsWon: uint256 = self.stakerSlots[_address]
167 
168     if slotsWon > 0:
169         assert self._isFinalised(), "Is bidder and auction not finalised yet"
170         poolDeposit: uint256(tok) = self.poolDeposits[_address]
171         currentPrice: uint256(tok) = self._getCurrentPrice()
172 
173         if (slotsWon * currentPrice) > poolDeposit:
174             selfStakeNeeded += (slotsWon * currentPrice) - poolDeposit
175     return selfStakeNeeded
176 
177 ################################################################################
178 # Main functions
179 ################################################################################
180 @public
181 def __init__(_ERC20Address: address):
182     self.owner = msg.sender
183     self.token = ERC20(_ERC20Address)
184 
185 # @notice Owner can initialise new auctions
186 # @dev First auction starts with AID 1
187 # @dev Requires the transfer of _reward to the contract to be approved with the
188 #   underlying ERC20 token
189 # @param _start: start of the price decay
190 # @param _startStake: initial auction price
191 # @param _reserveStake: lowest possible auction price >= 1
192 # @param _duration: duration over which the auction price declines. Total bidding
193 #   duration is _duration + RESERVE_PRICE_DURATION
194 # @param _lockup_duration: number of blocks the lockup phase will last
195 # @param _slotsOnSale: size of the assembly in this cycle
196 # @param _reward: added to any remaining reward of past auctions
197 @public
198 def initialiseAuction(_start: uint256,
199                       _startStake: uint256(tok),
200                       _reserveStake: uint256(tok),
201                       _duration: uint256,
202                       _lockup_duration: uint256,
203                       _slotsOnSale: uint256,
204                       _reward: uint256(tok)):
205     assert msg.sender == self.owner, "Owner only"
206     assert _startStake > _reserveStake, "Invalid startStake"
207     assert (_slotsOnSale > 0) and (_slotsOnSale <= MAX_SLOTS), "Invald slot number"
208     assert _start >= block.number, "Start before current block"
209     # NOTE: _isFinalised() relies on this requirement
210     assert _reserveStake > 0, "Reserve stake has to be at least 1"
211     assert self.auction.lockupEnd == 0, "End current auction"
212 
213     self.currentAID += 1
214 
215     # Use integer-ceil() of the fraction with (+ _duration - 1)
216     declinePerBlock: uint256(tok) = (_startStake - _reserveStake + _duration - 1) / _duration
217     end: uint256 = _start + _duration + RESERVE_PRICE_DURATION
218     self.auction.start = _start
219     self.auction.end = end
220     self.auction.lockupEnd = end + _lockup_duration
221     self.auction.startStake = _startStake
222     self.auction.reserveStake = _reserveStake
223     self.auction.declinePerBlock = declinePerBlock
224     self.auction.slotsOnSale = _slotsOnSale
225     # Also acts as the last checked price in _updatePrice()
226     self.auction.finalPrice = 0
227 
228     # add auction rewards
229     self.totalAuctionRewards += _reward
230     self.auction.rewardPerSlot = self.totalAuctionRewards / self.auction.slotsOnSale
231     success: bool = self.token.transferFrom(msg.sender, self, as_unitless_number(_reward))
232     assert success, "Transfer failed"
233 
234     log.NewAuction(self.currentAID, _start, end, end + _lockup_duration, _startStake,
235                    _reserveStake, declinePerBlock, _slotsOnSale, self.auction.rewardPerSlot)
236 
237 # @notice Move unclaimed auction rewards back to the contract owner
238 # @dev Requires that no auction is in bidding or lockup phase
239 @public
240 def retrieveUndistributedAuctionRewards():
241     assert msg.sender == self.owner, "Owner only"
242     assert self.auction.lockupEnd == 0, "Auction ongoing"
243     undistributed: uint256(tok) = self.totalAuctionRewards
244     clear(self.totalAuctionRewards)
245 
246     success: bool = self.token.transfer(self.owner, as_unitless_number(undistributed))
247     assert success, "Transfer failed"
248 
249 # @notice Enter a bid into the auction. Requires the sender's deposits + _topup >= currentPrice or
250 #   specify _topup = 0 to automatically calculate and transfer the topup needed to make a bid at the
251 #   current price. Beforehand the sender must have approved the ERC20 contract to allow the transfer
252 #   of at least the topup to the auction contract via ERC20.approve(auctionContract.address, amount)
253 # @param _topup: Set to 0 to bid current price (automatically calculating and transfering required topup),
254 #   o/w it will be interpreted as a topup to the existing deposits
255 # @dev Only one bid per address and auction allowed, as time of bidding also specifies the priority
256 #   in slot allocation
257 # @dev No bids below current auction price allowed
258 @public
259 def bid(_topup: uint256(tok)):
260     assert self._isBiddingPhase(), "Not in bidding phase"
261     assert self.stakerSlots[msg.sender] == 0, "Sender already bid"
262 
263     _currentAID: uint256 = self.currentAID
264     currentPrice: uint256(tok) = self._getCurrentPrice()
265     _isVirtTokenHolder: bool = self.virtTokenHolders[msg.sender].isHolder
266 
267     assert (_isVirtTokenHolder == False) or (_topup <= self.virtTokenHolders[msg.sender].limit), "Virtual tokens above limit"
268 
269     # If pool: move unclaimed rewards and clear
270     if self.registeredPools[msg.sender].AID == _currentAID:
271         unclaimed: uint256(tok) = self.registeredPools[msg.sender].remainingReward
272         clear(self.registeredPools[msg.sender])
273         self.poolDeposits[msg.sender] -= unclaimed
274         self.selfStakerDeposits[msg.sender] += unclaimed
275     # if address was a pool in a previous auction and not the current one: reset poolDeposits
276     # do not rely on self.registeredPools[msg.sender].AID as this gets cleared at certain points
277     elif self.poolDeposits[msg.sender] > 0:
278         clear(self.poolDeposits[msg.sender])
279 
280     totDeposit: uint256(tok) = self.poolDeposits[msg.sender] + self.selfStakerDeposits[msg.sender]
281 
282     # cannot modify input argument
283     topup: uint256(tok) = _topup
284     if (currentPrice > totDeposit) and(_topup == 0):
285         topup = currentPrice - totDeposit
286     else:
287         assert totDeposit + topup >= currentPrice, "Bid below current price"
288 
289     # Update deposits & stakers
290     self.priceAtBid[msg.sender] = currentPrice
291     self.selfStakerDeposits[msg.sender] += topup
292     slots: uint256 = min((totDeposit + topup) / currentPrice, self.auction.slotsOnSale - self.auction.slotsSold)
293     self.stakerSlots[msg.sender] = slots
294     self.auction.slotsSold += slots
295     self.stakers[self.auction.uniqueStakers] = msg.sender
296     self.auction.uniqueStakers += 1
297 
298     # Transfer topup if necessary
299     if (topup > 0) and (_isVirtTokenHolder == False):
300         success: bool = self.token.transferFrom(msg.sender, self, as_unitless_number(topup))
301         assert success, "Transfer failed"
302     log.Bid(_currentAID, msg.sender, currentPrice, totDeposit + topup)
303 
304 # @Notice Anyone can supply the correct final price to finalise the auction and calculate the number of slots each
305 #   staker has won. Required before lock-up can be ended or withdrawals can be made
306 # @param finalPrice: proposed solution for the final price. Throws if not the correct solution
307 # @dev Allows to move the calculation of the price that clear the auction off-chain
308 @public
309 def finaliseAuction(finalPrice: uint256(tok)):
310     currentPrice: uint256(tok) = self._getCurrentPrice()
311     assert finalPrice >= currentPrice, "Suggested solution below current price"
312     assert self.auction.finalPrice == 0, "Auction already finalised"
313     assert self.auction.lockupEnd >= 0, "Lockup has already ended"
314 
315     slotsOnSale: uint256 = self.auction.slotsOnSale
316     slotsRemaining: uint256 = slotsOnSale
317     slotsRemainingP1: uint256 = slotsOnSale
318     finalPriceP1: uint256(tok) = finalPrice + 1
319 
320     uniqueStakers_int128: int128 = convert(self.auction.uniqueStakers, int128)
321     staker: address = ZERO_ADDRESS
322     totDeposit: uint256(tok) = 0
323     slots: uint256 = 0
324     currentSlots: uint256 = 0
325     _priceAtBid: uint256(tok)= 0
326 
327     for i in range(MAX_SLOTS):
328         if i >= uniqueStakers_int128:
329             break
330 
331         staker = self.stakers[i]
332         _priceAtBid = self.priceAtBid[staker]
333         slots = 0
334 
335         if finalPrice <= _priceAtBid:
336             totDeposit = self.selfStakerDeposits[staker] + self.poolDeposits[staker]
337 
338             if slotsRemaining > 0:
339                 # finalPrice will always be > 0 as reserveStake required to be > 0
340                 slots = min(totDeposit / finalPrice, slotsRemaining)
341                 currentSlots = self.stakerSlots[staker]
342                 if slots != currentSlots:
343                     self.stakerSlots[staker] = slots
344                 slotsRemaining -= slots
345 
346             if finalPriceP1 <= _priceAtBid:
347                 slotsRemainingP1 -= min(totDeposit / finalPriceP1, slotsRemainingP1)
348 
349         # later bidders dropping out of slot-allocation as earlier bidders already claim all slots at the final price
350         if slots == 0:
351             clear(self.stakerSlots[staker])
352             clear(self.stakers[i])
353 
354     if (finalPrice == self.auction.reserveStake) and (self._isBiddingPhase() == False):
355         # a) reserveStake clears the auction and reserveStake + 1 does not
356         doesClear: bool = (slotsRemaining == 0) and (slotsRemainingP1 > 0)
357         # b) reserveStake does not clear the auction, accordingly neither will any other higher price
358         assert (doesClear or (slotsRemaining > 0)), "reserveStake is not the best solution"
359     else:
360         assert slotsRemaining == 0, "finalPrice does not clear auction"
361         assert slotsRemainingP1 > 0, "Not largest price clearing the auction"
362 
363     self.auction.finalPrice = finalPrice
364     self.auction.slotsSold = slotsOnSale - slotsRemaining
365     log.AuctionFinalised(self.currentAID, finalPrice, slotsOnSale - slotsRemaining)
366 
367 # @notice Anyone can end the lock-up of an auction, thereby allowing everyone to
368 #   withdraw their stakes and rewards. Auction must first be finalised through finaliseAuction().
369 @private
370 def _endLockup(payoutRewards: bool):
371     assert self.auction.lockupEnd > 0, "No lockup to end"
372 
373     slotsSold: uint256 = self.auction.slotsSold
374     rewardPerSlot_: uint256(tok) = 0
375     self.earliestDelete = block.timestamp + DELETE_PERIOD
376 
377     if payoutRewards:
378         assert self._isFinalised(), "Not finalised"
379         rewardPerSlot_ = self.auction.rewardPerSlot
380         self.totalAuctionRewards -= slotsSold * rewardPerSlot_
381 
382     # distribute rewards & cleanup
383     staker: address = ZERO_ADDRESS
384 
385     for i in range(MAX_SLOTS):
386         staker = self.stakers[i]
387         if staker == ZERO_ADDRESS:
388             break
389 
390         if payoutRewards:
391             if self.virtTokenHolders[staker].isHolder:
392                 self.virtTokenHolders[staker].rewards += self.stakerSlots[staker] * rewardPerSlot_
393             else:
394                 self.selfStakerDeposits[staker] += self.stakerSlots[staker] * rewardPerSlot_
395 
396         clear(self.stakerSlots[staker])
397         if self.virtTokenHolders[staker].isHolder:
398             clear(self.selfStakerDeposits[staker])
399 
400     clear(self.stakers)
401     clear(self.auction)
402 
403 @public
404 def endLockup():
405     # Prevents repeated calls of this function as self.auction will get reset here
406     assert self.auction.finalPrice > 0, "Auction not finalised yet or no auction to end"
407     assert block.number >= self.auction.lockupEnd, "Lockup not over"
408     self._endLockup(True)
409     log.LockupEnded(self.currentAID)
410 
411 # @notice The owner can clear the auction and all recorded slots in the case of an emergency and
412 # thereby immediately lift any lockups and allow the immediate withdrawal of any made deposits.
413 # @param payoutRewards: whether rewards get distributed to bidders
414 @public
415 def abortAuction(payoutRewards: bool):
416     assert msg.sender == self.owner, "Owner only"
417 
418     self._endLockup(payoutRewards)
419     log.AuctionAborted(self.currentAID, payoutRewards)
420 
421 # @param AID: auction ID, has to match self.currentAID
422 # @param _totalReward: total reward committed to stakers, has to be paid upon
423 #   calling this and be approved with the ERC20 token
424 # @param _rewardPerTok: _rewardPerTok / REWARD_PER_TOK_DENOMINATOR will be paid
425 #   for each stake pledged to the pool. Meaning _rewardPerTok should equal
426 #   reward per token * REWARD_PER_TOK_DENOMINATOR (see getDenominator())
427 @public
428 def registerPool(AID: uint256,
429                  _totalReward: uint256(tok),
430                  _rewardPerTok: uint256(tok)):
431     assert AID == self.currentAID, "Not current auction"
432     assert self._isBiddingPhase(), "Not in bidding phase"
433     assert self.registeredPools[msg.sender].AID < AID, "Pool already exists"
434     assert self.registeredPools[msg.sender].remainingReward == 0, "Unclaimed rewards"
435     assert self.virtTokenHolders[msg.sender].isHolder == False, "Not allowed for virtTokenHolders"
436 
437     self.registeredPools[msg.sender] = Pool({remainingReward: _totalReward,
438                                              rewardPerTok: _rewardPerTok,
439                                              AID: AID})
440     # overwrite any poolDeposits that existed for the last auction
441     self.poolDeposits[msg.sender] = _totalReward
442 
443     success: bool = self.token.transferFrom(msg.sender, self, as_unitless_number(_totalReward))
444     assert success, "Transfer failed"
445 
446     maxStake: uint256(tok) = (_totalReward * REWARD_PER_TOK_DENOMINATOR) / _rewardPerTok
447     log.PoolRegistration(AID, msg.sender, maxStake, _rewardPerTok)
448 
449 # @notice Move pool rewards that were not claimed by anyone into
450 #   selfStakerDeposits. Automatically done if pool enters a bid.
451 # @dev Requires that the auction has passed the bidding phase
452 @public
453 def retrieveUnclaimedPoolRewards():
454     assert ((self._isBiddingPhase() == False)
455              or (self.registeredPools[msg.sender].AID < self.currentAID)), "Bidding phase of AID not over"
456 
457     unclaimed: uint256(tok) = self.registeredPools[msg.sender].remainingReward
458     clear(self.registeredPools[msg.sender])
459 
460     self.poolDeposits[msg.sender] -= unclaimed
461     self.selfStakerDeposits[msg.sender] += unclaimed
462 
463 @private
464 def _updatePoolRewards(pool: address, newAmount: uint256(tok)) -> uint256(tok):
465     newReward: uint256(tok) = ((self.registeredPools[pool].rewardPerTok * newAmount)
466                                 / REWARD_PER_TOK_DENOMINATOR)
467     assert self.registeredPools[pool].remainingReward >= newReward, "Rewards depleted"
468     self.registeredPools[pool].remainingReward -= newReward
469     return newReward
470 
471 # @notice Pledge stake to a staking pool. Possible from auction intialisation
472 #   until the end of the bidding phase or until the pool has made a bid.
473 #   Stake from the last auction can be taken over to the next auction. If amount
474 #   exceeds the previous stake, this contract must be approved with the ERC20 token
475 #   to transfer the difference to this contract.
476 # @dev Only one pledge per address and auction allowed
477 # @dev If decreasing the pledge, the difference is immediately paid out
478 # @dev If the pool operator has already bid, this will throw with "Rewards depleted"
479 # @param AID: The auction ID
480 # @param pool: The address of the pool
481 # @param amount: The new total amount, not the difference to existing pledges. If increasing the
482 #   pledge, this has to include the pool rewards of the initial pledge
483 @public
484 def pledgeStake(AID: uint256, pool: address, amount: uint256(tok)):
485     assert AID == self.currentAID, "Not current AID"
486     assert self._isBiddingPhase(), "Not in bidding phase"
487     assert self.registeredPools[pool].AID == AID, "Not a registered pool"
488     assert self.virtTokenHolders[msg.sender].isHolder == False, "Not allowed for virtTokenHolders"
489 
490     existingPledgeAmount: uint256(tok) = self.pledges[msg.sender].amount
491     assert self.pledges[msg.sender].AID < AID, "Already pledged"
492 
493     newReward: uint256(tok) = self._updatePoolRewards(pool, amount)
494 
495     # overwriting any existing amount
496     self.pledges[msg.sender] = Pledge({amount: amount + newReward,
497                                                   AID: AID,
498                                                   pool: pool})
499     # pool reward is already added to poolDeposits during registerPool() call
500     self.poolDeposits[pool] += amount
501 
502     if amount > existingPledgeAmount:
503         success: bool = self.token.transferFrom(msg.sender, self, as_unitless_number(amount - existingPledgeAmount))
504         assert success, "Transfer failed"
505     elif amount < existingPledgeAmount:
506         success: bool = self.token.transfer(msg.sender, as_unitless_number(existingPledgeAmount - amount))
507         assert success, "Transfer failed"
508 
509     log.NewPledge(AID, msg.sender, pool, amount)
510 
511 # @notice Increase an existing pledge in the current auction
512 # @dev Requires the auction to be in bidding phase and the pool to have enough rewards remaining
513 # @param pool: The address of the pool. Has to match the pool of the initial pledge
514 # @param topup: Value by which to increase the pledge
515 @public
516 def increasePledge(pool: address, topup: uint256(tok)):
517     AID: uint256 = self.currentAID
518     assert self._isBiddingPhase(), "Not in bidding phase"
519     assert self.pledges[msg.sender].AID == AID, "No pledge made in this auction yet"
520     assert self.pledges[msg.sender].pool == pool, "Cannot change pool"
521 
522     newReward: uint256(tok) = self._updatePoolRewards(pool, topup)
523     self.pledges[msg.sender].amount += topup + newReward
524     self.poolDeposits[pool] += topup
525 
526     success: bool = self.token.transferFrom(msg.sender, self, as_unitless_number(topup))
527     assert success, "Transfer failed"
528 
529     log.IncreasedPledge(AID, msg.sender, pool, topup)
530 
531 # @notice Withdraw any self-stake exceeding the required lockup. In case sender is a bidder in the
532 #   current auction, this requires the auction to be finalised through finaliseAuction(),
533 #   o/w _calculateSelfStakeNeeded() will throw
534 @public
535 def withdrawSelfStake() -> uint256(tok):
536     # not guaranteed to be initialised to 0 without setting it explicitly
537     withdrawal: uint256(tok) = 0
538 
539     if self.virtTokenHolders[msg.sender].isHolder:
540         withdrawal = self.virtTokenHolders[msg.sender].rewards
541         clear(self.virtTokenHolders[msg.sender].rewards)
542     else:
543         selfStake: uint256(tok) = self.selfStakerDeposits[msg.sender]
544         selfStakeNeeded: uint256(tok) = self._calculateSelfStakeNeeded(msg.sender)
545 
546         if selfStake > selfStakeNeeded:
547             withdrawal = selfStake - selfStakeNeeded
548             self.selfStakerDeposits[msg.sender] -= withdrawal
549         elif selfStake < selfStakeNeeded:
550             assert False, "Critical failure"
551 
552     success: bool = self.token.transfer(msg.sender, as_unitless_number(withdrawal))
553     assert success, "Transfer failed"
554 
555     log.SelfStakeWithdrawal(msg.sender, withdrawal)
556 
557     return withdrawal
558 
559 # @notice Withdraw pledged stake after the lock-up has ended
560 @public
561 def withdrawPledgedStake() -> uint256(tok):
562     withdrawal: uint256(tok) = 0
563     if ((self.pledges[msg.sender].AID < self.currentAID)
564         or (self.auction.lockupEnd == 0)):
565         withdrawal += self.pledges[msg.sender].amount
566         clear(self.pledges[msg.sender])
567 
568     success: bool = self.token.transfer(msg.sender, as_unitless_number(withdrawal))
569     assert success, "Transfer failed"
570 
571     log.PledgeWithdrawal(msg.sender, withdrawal)
572 
573     return withdrawal
574 
575 # @notice Allow the owner to remove the contract, given that no auction is
576 #   active and at least DELETE_PERIOD blocks have past since the last lock-up end.
577 @public
578 def deleteContract():
579     assert msg.sender == self.owner, "Owner only"
580     assert self.auction.lockupEnd == 0, "In lockup phase"
581     assert block.timestamp >= self.earliestDelete, "earliestDelete not reached"
582 
583     contractBalance: uint256 = self.token.balanceOf(self)
584     success: bool = self.token.transfer(self.owner, contractBalance)
585     assert success, "Transfer failed"
586 
587     selfdestruct(self.owner)
588 
589 # @notice Allow the owner to set virtTokenHolder status for addresses, allowing them to participate
590 #   with virtual tokens
591 # @dev Throws if the address has existing selfStakerDeposits, active slots, a registered pool for
592 #   this auction, unretrieved pool rewards or existing pledges
593 # @param _address: address for which to set the value
594 # @param _isVirtTokenHolder: new value indicating whether isVirtTokenHolder or not
595 # @param preserveRewards: if setting isVirtTokenHolder to false and that address still has remaining rewards:
596 #   whether to move those rewards into selfStakerDeposits or to add them back to the control of the owner
597 #   by adding them to totalAuctionRewards
598 @public
599 def setVirtTokenHolder(_address: address, _isVirtTokenHolder: bool, limit: uint256(tok), preserveRewards: bool):
600     assert msg.sender == self.owner, "Owner only"
601     assert self.stakerSlots[_address] == 0, "Address has active slots"
602     assert self.selfStakerDeposits[_address] == 0, "Address has positive selfStakerDeposits"
603     assert self.registeredPools[_address].remainingReward == 0, "Address has remainingReward"
604     assert self.pledges[_address].amount == 0, "Address has positive pledges"
605     assert (self.registeredPools[_address].AID < self.currentAID) or (self.auction.finalPrice == 0), "Address has a pool in ongoing auction"
606 
607     existingRewards: uint256(tok) = self.virtTokenHolders[_address].rewards
608 
609     if (_isVirtTokenHolder == False) and (existingRewards > 0):
610         if preserveRewards:
611             self.selfStakerDeposits[_address] += existingRewards
612         else:
613             self.totalAuctionRewards += existingRewards
614         clear(self.virtTokenHolders[_address].rewards)
615 
616     self.virtTokenHolders[_address].isHolder = _isVirtTokenHolder
617     self.virtTokenHolders[_address].limit = limit
618 
619 @public
620 def setVirtTokenLimit(_address: address, _virtTokenLimit: uint256(tok)):
621     assert msg.sender == self.owner, "Owner only"
622     assert self.virtTokenHolders[_address].isHolder, "Not a virtTokenHolder"
623     self.virtTokenHolders[_address].limit = _virtTokenLimit
624 
625 ################################################################################
626 # Getters
627 ################################################################################
628 @public
629 @constant
630 def getERC20Address() -> address:
631     return self.token
632 
633 @public
634 @constant
635 def getDenominator() -> uint256(tok):
636     return REWARD_PER_TOK_DENOMINATOR
637 
638 @public
639 @constant
640 def getFinalStakerSlots(staker: address) -> uint256:
641     assert self._isFinalised(), "Slots not yet final"
642     return self.stakerSlots[staker]
643 
644 # @dev Always returns an array of MAX_SLOTS with elements > unique bidders = zero
645 @public
646 @constant
647 def getFinalStakers() -> address[MAX_SLOTS]:
648     assert self._isFinalised(), "Stakers not yet final"
649     return self.stakers
650 
651 @public
652 @constant
653 def getFinalSlotsSold() -> uint256:
654     assert self._isFinalised(), "Slots not yet final"
655     return self.auction.slotsSold
656 
657 @public
658 @constant
659 def isBiddingPhase() -> bool:
660     return self._isBiddingPhase()
661 
662 @public
663 @constant
664 def isFinalised() -> bool:
665     return self._isFinalised()
666 
667 @public
668 @constant
669 def getCurrentPrice() -> uint256(tok):
670     return self._getCurrentPrice()
671 
672 @public
673 @constant
674 def calculateSelfStakeNeeded(_address: address) -> uint256(tok):
675     return self._calculateSelfStakeNeeded(_address)