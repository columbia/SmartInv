1 // SPDX-License-Identifier: GPL-3.0-only
2 
3 pragma solidity 0.7.4;
4 
5 library SafeMathLib {
6   function times(uint a, uint b) public pure returns (uint) {
7     uint c = a * b;
8     require(a == 0 || c / a == b, 'Overflow detected');
9     return c;
10   }
11 
12   function minus(uint a, uint b) public pure returns (uint) {
13     require(b <= a, 'Underflow detected');
14     return a - b;
15   }
16 
17   function plus(uint a, uint b) public pure returns (uint) {
18     uint c = a + b;
19     require(c>=a && c>=b, 'Overflow detected');
20     return c;
21   }
22 
23 }
24 
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface Token {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 // This contract is inspired by the harberger tax idea, it rewards people with FVT for burning their liquidity provider
101 // tokens.
102 contract LiquidityMining {
103     using SafeMathLib for uint;
104 
105     // this represents a single recipient of token rewards on a fixed schedule that does not depend on deposit or burn rate
106     // it specifies an id (key to a map below) an marker for the last time it was updated, a deposit (of LP tokens) and a
107     // burn rate of those LP tokens per block, and finally, the owner of the slot, who will receive the rewards
108     struct Slot {
109         uint id;
110         uint lastUpdatedBlock;
111         uint deposit;
112         uint burnRate;
113         address owner;
114     }
115 
116     // privileged key that can change key parameters, will change to dao later
117     address public management;
118 
119     // the token that the rewards are made in
120     Token public rewardToken;
121 
122     // the liquidity provider (LP) token
123     Token public liquidityToken;
124 
125     // address to which taxes are sent
126     address public taxAddress;
127 
128     // is the contract paused?
129     bool public paused = false;
130 
131     // when was the contract paused?
132     uint public pausedBlock = 0;
133 
134     // maximum number of slots, changeable by management key
135     uint public maxStakers = 0;
136 
137     // current number of stakers
138     uint public numStakers = 0;
139 
140     // minimum deposit allowable to claim a slot
141     uint public minimumDeposit = 0;
142 
143     // maximum deposit allowable (used to limit risk)
144     uint public maximumDeposit = 1000 ether;
145 
146     // minimum burn rate allowable to claim a slot
147     uint public minimumBurnRate = 0;
148 
149     // total liquidity tokens staked
150     uint public totalStaked = 0;
151 
152     // total rewards distributed
153     uint public totalRewards = 0;
154 
155     // total LP tokens burned
156     uint public totalBurned = 0;
157 
158     // start block used to compute rewards
159     uint public pulseStartBlock;
160 
161     // the length of a single pulse of rewards, in blocks
162     uint public pulseWavelengthBlocks = 0;
163 
164     // the amount of the highest per-block reward, in FVT
165     uint public pulseAmplitudeFVT = 0;
166 
167     // computed constants for deferred computation
168     uint public pulseIntegral = 0;
169     uint public pulseConstant = 0;
170 
171     // map of slot ids to slots
172     mapping (uint => Slot) public slots;
173 
174     // map of addresses to amount staked
175     mapping (address => uint) public totalStakedFor;
176 
177     // map of total rewards by address
178     mapping (address => uint) public totalRewardsFor;
179 
180     // map of rewards for session slotId -> rewardsForThisSession
181     mapping (uint => uint) public rewardsForSession;
182 
183     // map of total burned by address
184     mapping (address => uint) public totalBurnedFor;
185 
186     event ManagementUpdated(address oldMgmt, address newMgmt);
187     event ContractPaused();
188     event ContractUnpaused();
189     event WavelengthUpdated(uint oldWavelength, uint newWavelength);
190     event AmplitudeUpdated(uint oldAmplitude, uint newAmplitude);
191     event MaxStakersUpdated(uint oldMaxStakers, uint newMaxStakers);
192     event MinDepositUpdated(uint oldMinDeposit, uint newMinDeposit);
193     event MaxDepositUpdated(uint oldMaxDeposit, uint newMaxDeposit);
194     event MinBurnRateUpdated(uint oldMinBurnRate, uint newMinBurnRate);
195     event SlotChangedHands(uint slotId, uint deposit, uint burnRate, address owner);
196 
197     modifier managementOnly() {
198         require (msg.sender == management, 'Only management may call this');
199         _;
200     }
201 
202     constructor(
203         address rewardTokenAddr,
204         address liquidityTokenAddr,
205         address mgmt,
206         address taxAddr,
207         uint pulseLengthBlocks,
208         uint pulseAmplitude,
209         uint mxStkrs) {
210         rewardToken = Token(rewardTokenAddr);
211         liquidityToken = Token(liquidityTokenAddr);
212         management = mgmt;
213         pulseStartBlock = block.number;
214         pulseWavelengthBlocks = pulseLengthBlocks;
215         pulseAmplitudeFVT = pulseAmplitude;
216         pulseConstant = pulseAmplitudeFVT / pulseWavelengthBlocks.times(pulseWavelengthBlocks);
217         pulseIntegral = pulseSum(pulseWavelengthBlocks);
218         maxStakers = mxStkrs;
219         taxAddress = taxAddr;
220     }
221 
222     // only management can reset management key
223     function setManagement(address newMgmt) public managementOnly {
224         address oldMgmt = management;
225         management = newMgmt;
226         emit ManagementUpdated(oldMgmt, newMgmt);
227     }
228 
229     function pauseContract() public managementOnly {
230         require(paused == false, 'Already paused');
231         paused = true;
232         pausedBlock = block.number;
233         emit ContractPaused();
234     }
235 
236     function unpauseContract() public managementOnly {
237         require(paused == true, 'Already unpaused');
238         require(numStakers == 0, 'Must kick everyone out before unpausing');
239         paused = false;
240         pausedBlock = 0;
241         emit ContractUnpaused();
242     }
243 
244     // change the number of slots, should be done with care
245     function setMaxStakers(uint newMaxStakers) public managementOnly {
246         uint oldMaxStakers = maxStakers;
247         maxStakers = newMaxStakers;
248         emit MaxStakersUpdated(oldMaxStakers, maxStakers);
249     }
250 
251     // change the minimum deposit to acquire a slot
252     function setMinDeposit(uint newMinDeposit) public managementOnly {
253         uint oldMinDeposit = minimumDeposit;
254         minimumDeposit = newMinDeposit;
255         emit MinDepositUpdated(oldMinDeposit, newMinDeposit);
256     }
257 
258     // change the maximum deposit
259     function setMaxDeposit(uint newMaxDeposit) public managementOnly {
260         uint oldMaxDeposit = maximumDeposit;
261         maximumDeposit = newMaxDeposit;
262         emit MaxDepositUpdated(oldMaxDeposit, newMaxDeposit);
263     }
264 
265     // change the minimum burn rate to acquire a slot
266     function setMinBurnRate(uint newMinBurnRate) public managementOnly {
267         uint oldMinBurnRate = minimumBurnRate;
268         minimumBurnRate = newMinBurnRate;
269         emit MinBurnRateUpdated(oldMinBurnRate, newMinBurnRate);
270     }
271 
272     // change the length of a pulse, should be done with care, probably should update all slots simultaneously
273     function setPulseWavelength(uint newWavelength) public managementOnly {
274         uint oldWavelength = pulseWavelengthBlocks;
275         pulseWavelengthBlocks = newWavelength;
276         pulseConstant = pulseAmplitudeFVT / pulseWavelengthBlocks.times(pulseWavelengthBlocks);
277         pulseIntegral = pulseSum(newWavelength);
278         emit WavelengthUpdated(oldWavelength, newWavelength);
279     }
280 
281     // change the maximum height of the reward curve
282     function setPulseAmplitude(uint newAmplitude) public managementOnly {
283         uint oldAmplitude = pulseAmplitudeFVT;
284         pulseAmplitudeFVT = newAmplitude;
285         pulseConstant = pulseAmplitudeFVT / pulseWavelengthBlocks.times(pulseWavelengthBlocks);
286         pulseIntegral = pulseSum(pulseWavelengthBlocks);
287         emit AmplitudeUpdated(oldAmplitude, newAmplitude);
288     }
289 
290     // compute the sum of the rewards per pulse
291     function pulseSum(uint wavelength) public view returns (uint) {
292         // sum of squares formula
293         return pulseConstant.times(wavelength.times(wavelength.plus(1))).times(wavelength.times(2).plus(1)) / 6;
294     }
295 
296     // compute the undistributed rewards for a slot
297     function getRewards(uint slotId) public view returns (uint) {
298         Slot storage slot = slots[slotId];
299         if (slot.owner == address(0)) {
300             return 0;
301         }
302         uint referenceBlock = block.number;
303         if (paused) {
304             referenceBlock = pausedBlock;
305         }
306         // three parts, incomplete beginning, incomplete end and complete middle
307         uint rewards;
308 
309         // complete middle
310         // trim off overhang on both ends
311         uint startPhase = slot.lastUpdatedBlock.minus(pulseStartBlock) % pulseWavelengthBlocks;
312         uint startOverhang = pulseWavelengthBlocks.minus(startPhase);
313         uint startSum = pulseSum(startOverhang);
314 
315         uint blocksDiffTotal = referenceBlock.minus(slot.lastUpdatedBlock);
316 
317         uint endPhase = referenceBlock.minus(pulseStartBlock) % pulseWavelengthBlocks;
318         uint endingBlocks = pulseWavelengthBlocks.minus(endPhase);
319         uint leftoverSum = pulseSum(endingBlocks);
320 
321         // if we haven't made it to phase 0 yet
322         if (blocksDiffTotal < startOverhang) {
323             rewards = startSum.minus(leftoverSum);
324         } else {
325             uint blocksDiff = blocksDiffTotal.minus(endPhase).minus(startOverhang);
326             uint wavelengths = blocksDiff / pulseWavelengthBlocks;
327             rewards = wavelengths.times(pulseIntegral);
328 
329             // incomplete beginning of reward cycle, end of pulse
330             if (startPhase > 0) {
331                 rewards = rewards.plus(pulseSum(startOverhang));
332             }
333 
334             // incomplete ending of reward cycle, beginning of pulse
335             if (endPhase > 0) {
336                 rewards = rewards.plus(pulseIntegral.minus(leftoverSum));
337             }
338         }
339 
340         return rewards;
341     }
342 
343     // compute the unapplied burn to the deposit
344     function getBurn(uint slotId) public view returns (uint) {
345         Slot storage slot = slots[slotId];
346         uint referenceBlock = block.number;
347         if (paused) {
348             referenceBlock = pausedBlock;
349         }
350         uint burn = slot.burnRate * (referenceBlock - slot.lastUpdatedBlock);
351         if (burn > slot.deposit) {
352             burn = slot.deposit;
353         }
354         return burn;
355     }
356 
357     // this must be idempotent, it syncs both the rewards and the deposit burn atomically, and updates lastUpdatedBlock
358     function updateSlot(uint slotId) public {
359         Slot storage slot = slots[slotId];
360 
361         // burn and rewards always have to update together, since they both depend on lastUpdatedBlock
362         uint burn = getBurn(slotId);
363         uint rewards = getRewards(slotId);
364 
365         // update this first to make burn and reward zero in the case of re-entrance
366         slot.lastUpdatedBlock = block.number;
367 
368         if (burn > 0) {
369             // adjust deposit first
370             slot.deposit = slot.deposit.minus(burn);
371 
372             // bookkeeping
373             totalBurned = totalBurned.plus(burn);
374             totalBurnedFor[slot.owner] = totalBurnedFor[slot.owner].plus(burn);
375 
376             // burn them!
377             liquidityToken.transfer(taxAddress, burn);
378         }
379 
380         if (rewards > 0) {
381             // bookkeeping
382             totalRewards = totalRewards.plus(rewards);
383             totalRewardsFor[slot.owner] = totalStakedFor[slot.owner].plus(rewards);
384             rewardsForSession[slotId] = rewardsForSession[slotId].plus(rewards);
385 
386             rewardToken.transfer(slot.owner, rewards);
387         }
388     }
389 
390     // most important function for users, allows them to start receiving rewards
391     function claimSlot(uint slotId, uint newBurnRate, uint deposit) external {
392         require(slotId > 0, 'Slot id must be positive');
393         require(slotId <= maxStakers, 'Slot id out of range');
394         require(newBurnRate >= minimumBurnRate, 'Burn rate must meet or exceed minimum');
395         require(deposit >= minimumDeposit, 'Deposit must meet or exceed minimum');
396         require(deposit <= maximumDeposit, 'Deposit must not exceed maximum');
397         require(paused == false, 'Must be unpaused');
398 
399         Slot storage slot = slots[slotId];
400 
401         // count the stakers
402         if (slot.owner == address(0)) {
403             // assign id since this may be the first time
404             slot.id = slotId;
405             numStakers = numStakers.plus(1);
406             slot.lastUpdatedBlock = block.number;
407         } else {
408             updateSlot(slotId);
409 
410             bool betterDeal = newBurnRate > slot.burnRate && (deposit > slot.deposit || deposit == maximumDeposit);
411             require(betterDeal || slot.deposit == 0, 'You must outbid the current owner');
412 
413             // bookkeeping
414             totalStaked = totalStaked.minus(slot.deposit);
415             totalStakedFor[slot.owner] = totalStakedFor[slot.owner].minus(slot.deposit);
416 
417             // withdraw current owner
418             withdrawFromSlotInternal(slotId);
419         }
420 
421         // set new owner, burn rate
422         slot.owner = msg.sender;
423         slot.burnRate = newBurnRate;
424         slot.deposit = deposit;
425 
426         // bookkeeping
427         totalStaked = totalStaked.plus(deposit);
428         totalStakedFor[msg.sender] = totalStakedFor[msg.sender].plus(deposit);
429 
430         // transfer the tokens!
431         if (deposit > 0) {
432             liquidityToken.transferFrom(msg.sender, address(this), deposit);
433         }
434 
435         emit SlotChangedHands(slotId, deposit, newBurnRate, msg.sender);
436     }
437 
438     // separates user from slot, if either voluntary or delinquent
439     function withdrawFromSlot(uint slotId) external {
440         Slot storage slot = slots[slotId];
441         bool withdrawable = slot.owner == msg.sender || slot.deposit == 0;
442         require(withdrawable || paused, 'Only owner can call this unless user is delinquent or contract is paused');
443         updateSlot(slotId);
444         withdrawFromSlotInternal(slotId);
445 
446         // zero out owner and burn rate
447         slot.owner = address(0);
448         slot.burnRate = 0;
449         numStakers = numStakers.minus(1);
450         emit SlotChangedHands(slotId, 0, 0, address(0));
451     }
452 
453     // internal function for withdrawing from a slot
454     function withdrawFromSlotInternal(uint slotId) internal {
455         Slot storage slot = slots[slotId];
456 
457         rewardsForSession[slotId] = 0;
458 
459         // if there's any deposit left,
460         if (slot.deposit > 0) {
461             uint deposit = slot.deposit;
462             slot.deposit = 0;
463             liquidityToken.transfer(slot.owner, deposit);
464         }
465     }
466 
467 }