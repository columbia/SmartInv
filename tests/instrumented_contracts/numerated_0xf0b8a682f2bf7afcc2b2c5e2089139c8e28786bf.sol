1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address _who) public view returns (uint256);
6   function transfer(address _to, uint256 _value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address _owner, address _spender)
12     public view returns (uint256);
13 
14   function transferFrom(address _from, address _to, uint256 _value)
15     public returns (bool);
16 
17   function approve(address _spender, uint256 _value) public returns (bool);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 contract IDealsSupport {
26 
27 // Any user
28 
29   /**
30    * @dev Checks whether a deal can be cancelled by merchant
31    * @param _dealIndex deal index
32    * @return whether a deal can be cancelled by merchant
33    */
34   function canBeCancelledByMerchant(uint _dealIndex) public view returns(bool);
35 
36   /**
37    * @dev Returns affiliate reward info
38    * @param _referenceHash affiliate's reference hash(index)
39    * @param _affiliateRewardIndex affiliate reward index
40    * @return affiliate reward info
41    */
42   function getAffiliateRewardInfo(uint _referenceHash, uint _affiliateRewardIndex) public view returns(uint, uint);
43 
44   /**
45    * @dev Returns deal index by reference hash
46    * @param _referenceHash affiliate's reference hash(index)
47    * @return deal index
48    */
49   function getDealIndex(uint _referenceHash) public view returns(uint);
50 
51   /**
52    * @dev Returns dynamic deal info: reference hashes.
53    * @param _dealIndex deal index
54    * @return array of reference hashes in deal
55    */
56   function getDynamicDealInfo(uint _dealIndex) public view returns(uint[]);
57 
58   /**
59    * @dev Returns reference hash that should be passed in reference links
60    * @param _dealIndex deal index
61    * @param _affiliateAddress affiliate address
62    * @return reference hash
63    */
64   function getReferenceHash(uint _dealIndex, address _affiliateAddress) public view returns(uint);
65 
66   /**
67    * @dev Checks whether deal is cancelled
68    * @param _dealIndex deal index
69    * @return bool whether deal is cancelled
70    */
71   function isDealCancelled(uint _dealIndex) public view returns(bool);
72 
73   /**
74    * @dev Checks whether deal is closed
75    * @param _dealIndex deal index
76    * @return bool whether deal is closed
77    */
78   function isDealClosed(uint _dealIndex) public view returns(bool);
79 
80 // Admin
81 
82   /**
83    * @dev Blocks/unblocks affiliate. As an admin i would like to block the selected affiliate.
84    * @param _referenceHash affiliate's reference hash(index)
85    */
86   function toggleBlockAffiliate(uint _referenceHash) public;
87 
88   /**
89    * @dev Cancells deal immediately. As an admin I would like to immediately cancel the selected deal in order to prevent fraudulent behaviour.
90    * @notice Will immediately move the selected deal into 'cancelled' state
91    * @param _dealIndex deal index
92    */
93   function cancelDealByAdmin(uint _dealIndex) public;
94 
95   /**
96    * @dev Changes admin address(transfer ownership)
97    * @param _newAdminAddress new admin address
98    */
99   function changeAdmin(address _newAdminAddress) public;
100 
101 // Affiliate
102 
103   /**
104    * @dev Withdraws a reward by affiliate. As an affiliate i would like to get my reward for the selected deal in order to get money.
105    * Preconditions:
106    *  1. The Deal index is valid.
107    *  2. Affiliate is not blocked.
108    *  3. The reward amount is non zero for the selected affiliate.
109    *  4. The reward amount is non zero for the selected deal.
110    * @param _dealIndex deal index
111    * Result:
112    *   All reward tokens are transferred from the current MultistageCrowdsale contract to the affiliate.
113    *   The reward amount for the selected affiliate is set to zero.
114    *   The reward amount for the selected deal is decreased.
115    */
116   function getMyReward(uint _dealIndex) public;
117 
118 // Merchant
119 
120   /**
121    * @dev Approves affiliate address for deal. As a merchant i would like to manually approve selected affiliate in order to provide incentives.
122    * @notice The same affiliate address can have different reference hashes because the same affiliate address can participate in multiple deals.
123    * @param _dealIndex deal index
124    * @param _affiliateAddress affiliate address
125    */
126   function approveAffiliate(uint _dealIndex, address _affiliateAddress) public;
127 
128   /**
129    * @dev Cancels all deals by merchant
130    */
131   function cancelAllDealsByMerchant() public;
132 
133   /**
134    * @dev Marks deal to be cancelled by merchant. As a merchant I would like to request a deal cancelation in order to cancel it after “Cancelation period” is elapsed.
135    * @param _dealIndex deal index
136    */
137   function cancelDealByMerchant(uint _dealIndex) public;
138 
139   /**
140    * @dev Creates a new deal by merchant. As a merchant i would like to create new deal in order to add incentives for affiliates.
141    * @param _rewardTokenAddress ERC20 token address used for affiliates' rewards
142    * @param _rewardRatePpm reward rate ppm, 100% == 1000000
143    * @param _daysOfCancellation when deal is marked as cancelled it is still live for _daysOfCancellation number of days
144    * @param _daysBeforeClose number of days since deal creation when deal is still live, the deal is over and any left over staked tokens can be withdrawn by merchant
145    */
146   function createDeal(bytes4 _dealID, address _rewardTokenAddress, uint _rewardRatePpm, uint _daysOfCancellation, uint _daysBeforeClose, bool _isAcceptAnyAffiliate) public;
147 
148   /**
149    * @dev Stakes ERC20 tokens as reward for affiliates by merchant. As a merchant i would like to transfer ERC20 tokens to the selected deal in order to stake them.
150    * @notice Merchant should allow _amount of tokens to be withdrawn (use ERC20.approve() method) BEFORE calling this method.
151    * Preconditions:
152    *  1. The Deal was created by Merchant before
153    *  2. isCancelled == false
154    *  3. isClosed == false
155    *  4. Merchant allowed current MultistageCrowdsale to withdraw correct amount of tokens
156    * @param _dealIndex deal index
157    * @param _amount amount in wei
158    */
159   function fillStake(uint _dealIndex, uint _amount) public;
160 
161   /**
162    * @dev Returns tokens at stake back to merchant if deal is cancelled. As a merchant i would like to get my stake back in order to get my tokens back (if deal is cancelled).
163    * Preconditions:
164      *  1. The Deal was created by Merchant before.
165      *  2. The Deal isCancelled==true.
166      *  3. The Deal still has some stake left.
167    *  4. The Deal has enough tokens to pay to all affiliates.
168    * @param _dealIndex deal index
169    * Result:
170      *    All staked reward tokens are transferred from the current MultistageCrowdsale contract back to merchant.
171      *    The “Current reward stake amount” of the selected Deal is decreased.
172    */
173   function getMyStakeBack(uint _dealIndex) public;
174 
175   /**
176    * @dev Updates a deal by merchant
177    * @param _dealIndex deal index
178    * @param _newRewardRatePpm new reward rate ppm, 100% == 1000000
179    */
180   function updateDeal(uint _dealIndex, uint _newRewardRatePpm) public;
181 
182 }
183 
184 contract DealsSupport is IDealsSupport {
185   using SafeMath for uint;
186 
187   address public adminAddress;
188   address public merchantAddress;
189 
190   mapping(uint => Affiliate) public affiliates;
191   uint public affiliatesCount;
192 
193   mapping(uint => Deal) public deals;
194   uint public dealsCount;
195 
196   mapping(address => uint[]) public affiliateDealIndexes;
197   mapping(address => uint) public affiliateDealIndexesCount;
198 
199   mapping(uint => mapping(address => uint)) public dealAffiliateReferenceHash;
200   mapping(uint => mapping(address => uint)) public dealAffiliateReferenceHashCount;
201   mapping(uint => uint) public referenceHashDealIndex;
202 
203   event ApproveAffiliate(bytes4 _dealId, address indexed _merchantAddress, uint indexed _dealIndex, address indexed _affiliateAddress, uint _referenceHash);
204   event CreateDeal(bytes4 _dealId, uint _dealIndex, address indexed _merchantAddress, address indexed _rewardTokenAddress, uint _rewardRatePpm, uint _daysOfCancellation, uint _daysBeforeClose, uint _dealsCount);
205   event ToggleBlockAffiliate(bytes4 _dealId, uint _referenceHash, bool _isBlocked);
206   event DealCancelled(bytes4 _dealId, uint _days, address _who);
207   event StakeFilled(bytes4 _dealId, uint _fill, uint _left);
208   event RewardClaimed(bytes4 _dealId, uint _referenceHash, uint _rewardAmount);
209   event DealUpdated(bytes4 _dealId, uint _newRewardRatePpm);
210   event RewardCreated(bytes4 _dealId, uint _referenceHash, uint _purchasedTokenAmount, uint _rewardAmount);
211 
212   struct Affiliate {
213     address affiliateAddress;
214     bool isBlocked;
215     uint rewardAmount;
216     uint affiliateRewardsCount;
217     mapping(uint => AffiliateReward) affiliateRewards;
218   }
219 
220   struct AffiliateReward {
221     uint amount;
222     uint createdAt;
223   }
224 
225   struct Deal {
226     address rewardTokenAddress;
227     bool isCancelled;
228     bool isCancelRequestedByMerchant;
229     uint rewardRatePpm;
230     uint daysOfCancellation;
231     uint daysBeforeClose;
232     uint createdAt;
233     uint cancelRequestedAt;
234     uint leftStakeAmount;
235     uint affiliatesCount;
236     uint lockedTokensAmount;
237     uint[] referenceHashes;
238 
239     bytes4 dealId;
240     bool allowAdminToAddAffiliate;
241   }
242 
243   /**
244   * Modifiers
245   */
246 
247   /**
248   * Checks that deal is still active, not cancelled or closed
249   */
250   modifier activeDeal(uint _dealIndex) {
251     require(!isDealCancelled(_dealIndex),"Deal is cancelled.");
252     require(!isDealClosed(_dealIndex),"Deal is closed.");
253     _;
254   }
255 
256   /**
257   * Checks that method is called by admin
258   */
259   modifier onlyAdmin() {
260     require(msg.sender == adminAddress, "Admin rights required.");
261     _;
262   }
263 
264   /**
265   * Checks that method is called by merchant
266   */
267   modifier onlyMerchant() {
268     require(msg.sender == merchantAddress, "Merchant rights required.");
269     _;
270   }
271 
272   /**
273   * Modifier checks that deal exists
274   */
275   modifier validDealIndex(uint _dealIndex) {
276     require(_dealIndex < dealsCount, "That deal index does not exist.");
277     _;
278   }
279 
280   /**
281   * Modifier checks that affiliate exists
282   */
283   modifier validReferenceHash(uint _referenceHash) {
284     // _referenceHash == 0 is reserved for usage in invest() method to distinguish whether user came from affiliate, so _referenceHash == 0 means that user didn't come from any affiliate
285     require(_referenceHash != 0, "referenceHash can not be 0");
286     require(_referenceHash <= affiliatesCount, "That referenceHash does not exist");
287     _;
288   }
289 
290   /**
291   * @dev Contract constructor
292   * @param _adminAddress admin address
293   * @param _merchantAddress merchant address
294   */
295   constructor(address _adminAddress, address _merchantAddress) public {
296     // validation
297     require(_adminAddress != address(0), "Admin address can not be 0.");
298     require(_merchantAddress != address(0), "Merchant address can not be 0.");
299     // set contract properties
300     adminAddress = _adminAddress;
301     merchantAddress = _merchantAddress;
302     // start affiliate reference hashes from 1 because 0 reference hash is used in invest() to detect whether user has come from affiliate or not
303     affiliatesCount = 0;
304   }
305 
306   /**
307   * Public methods
308   */
309 
310   /**
311   * @dev Checks whether a deal can be cancelled by merchant
312   * @param _dealIndex deal index
313   * @return whether a deal can be cancelled by merchant
314   */
315   function canBeCancelledByMerchant(uint _dealIndex) public view validDealIndex(_dealIndex) returns(bool) {
316     bool canBeCancelled = true;
317     if (deals[_dealIndex].isCancelled || deals[_dealIndex].isCancelRequestedByMerchant) {
318       canBeCancelled = false;
319     }
320     return canBeCancelled;
321   }
322 
323   /**
324   * @dev convert Deal ID -> Deal index.
325   * @param _dealId deal ID
326   * @return dealIndex
327   */
328   function dealIdToIndex(bytes4 _dealId) public view returns(uint) {
329     for (uint i = 0; i<dealsCount; i++) {
330       if (deals[i].dealId == _dealId) {
331         return i;
332       }
333     }
334     revert("dealID not found");
335   }
336 
337   /**
338   * @dev convert Deal index -> Deal ID
339   * @param _dealIndex deal index
340   * @return dealId
341   */
342   //Should
343   function dealIndexToId(uint _dealIndex) public view returns(bytes4) {
344     return deals[_dealIndex].dealId;
345   }
346 
347   /**
348   * @dev Returns affiliate reward info
349   * @param _referenceHash affiliate's reference hash(index)
350   * @param _affiliateRewardIndex affiliate reward index
351   * @return affiliate reward info
352   */
353   function getAffiliateRewardInfo(uint _referenceHash, uint _affiliateRewardIndex) public view validReferenceHash(_referenceHash) returns(uint, uint) {
354     require(_affiliateRewardIndex < affiliates[_referenceHash].affiliateRewardsCount, "affiliateRewardIndex does not exist.");
355     AffiliateReward memory affiliateReward = affiliates[_referenceHash].affiliateRewards[_affiliateRewardIndex];
356     return (
357       affiliateReward.amount,
358       affiliateReward.createdAt
359     );
360   }
361 
362   /**
363   * @dev Returns deal index by reference hash
364   * @param _referenceHash affiliate's reference hash(index)
365   * @return deal index
366   */
367   function getDealIndex(uint _referenceHash) public view validReferenceHash(_referenceHash) returns(uint) {
368     return referenceHashDealIndex[_referenceHash];
369   }
370 
371   /**
372   * @dev Returns array of deal indexes where provided affiliate takes part
373   * @param _affiliateAddress affiliate address
374   * @return array of deal indexes
375   */
376   function getDealIndexesByAffiliate(address _affiliateAddress) public view returns(uint[]) {
377     require(_affiliateAddress != address(0), "affiliateAddress can not be 0.");
378     return affiliateDealIndexes[_affiliateAddress];
379   }
380 
381   /**
382   * @dev Returns dynamic deal info: reference hashes.
383   * @param _dealIndex deal index
384   * @return array of reference hashes in deal
385   */
386   function getDynamicDealInfo(uint _dealIndex) public view validDealIndex(_dealIndex) returns(uint[]) {
387     return deals[_dealIndex].referenceHashes;
388   }
389 
390   /**
391   * @dev Returns reference hash that should be passed in reference links
392   * @param _dealIndex deal index
393   * @param _affiliateAddress affiliate address
394   * @return reference hash
395   */
396   function getReferenceHash(uint _dealIndex, address _affiliateAddress) public view validDealIndex(_dealIndex) returns(uint) {
397     // validation
398     require(_affiliateAddress != address(0), "affiliateAddress can not be 0.");
399     require(dealAffiliateReferenceHashCount[_dealIndex][_affiliateAddress] == 1, "dealAffiliateReferenceHash does not exist.");
400     // return reference hash
401     return dealAffiliateReferenceHash[_dealIndex][_affiliateAddress];
402   }
403 
404   /**
405   * @dev Returns reference hash info: affiliate address and deal index
406   * @param _referenceHash affiliate's reference hash(index)
407   * @return affiliate address and deal index
408   */
409   function getReferenceHashInfo(uint _referenceHash) public view validReferenceHash(_referenceHash) returns (address, uint) {
410     return (
411       affiliates[_referenceHash].affiliateAddress,
412       referenceHashDealIndex[_referenceHash]
413     );
414   }
415 
416   /**
417   * @dev Checks whether deal is cancelled
418   * @param _dealIndex deal index
419   * @return bool whether deal is cancelled
420   */
421   function isDealCancelled(uint _dealIndex) public view validDealIndex(_dealIndex) returns(bool) {
422     bool isCancelled = false;
423     Deal memory deal = deals[_dealIndex];
424     if (deal.isCancelled) {
425       isCancelled = true;
426     }
427     if (deal.isCancelRequestedByMerchant && ((now - deal.cancelRequestedAt) >= (deal.daysOfCancellation * 24 * 60 * 60))) {
428       isCancelled = true;
429     }
430     return isCancelled;
431   }
432 
433   /**
434   * @dev Checks whether deal is closed
435   * @param _dealIndex deal index
436   * @return bool whether deal is closed
437   */
438   function isDealClosed(uint _dealIndex) public view validDealIndex(_dealIndex) returns(bool) {
439     bool isClosed = false;
440     Deal memory deal = deals[_dealIndex];
441     if ((now - deal.createdAt) >= (deal.daysBeforeClose * 24 * 60 * 60)) {
442       isClosed = true;
443     }
444     return isClosed;
445   }
446 
447   /**
448   * Admin methods
449   */
450 
451   /**
452   * @dev Blocks/unblocks affiliate. As an admin i would like to block the selected affiliate.
453   * @param _referenceHash affiliate's reference hash(index)
454   */
455   function toggleBlockAffiliate(uint _referenceHash) public onlyAdmin validReferenceHash(_referenceHash) {
456     affiliates[_referenceHash].isBlocked = !affiliates[_referenceHash].isBlocked;
457     bytes4 dealId = deals[referenceHashDealIndex[_referenceHash]].dealId;
458     emit ToggleBlockAffiliate(dealId, _referenceHash, affiliates[_referenceHash].isBlocked);
459   }
460 
461   /**
462   * @dev Cancells deal immediately. As an admin I would like to immediately cancel the selected deal in order to prevent fraudulent behaviour.
463   * @notice Will immediately move the selected deal into 'cancelled' state
464   * @param _dealIndex deal index
465   */
466   function cancelDealByAdmin(uint _dealIndex) public onlyAdmin validDealIndex(_dealIndex) {
467     deals[_dealIndex].isCancelled = true;
468     emit DealCancelled(deals[_dealIndex].dealId, deals[_dealIndex].daysOfCancellation, msg.sender);
469   }
470 
471   /**
472   * @dev Changes admin address(transfer ownership)
473   * @param _newAdminAddress new admin address
474   */
475   function changeAdmin(address _newAdminAddress) public onlyAdmin {
476     require(_newAdminAddress != address(0), "newAdmin can not be 0.");
477     adminAddress = _newAdminAddress;
478   }
479 
480   /**
481   * Affiliate methods
482   */
483 
484   /**
485   * @dev Withdraws a reward by affiliate. As an affiliate i would like to get my reward for the selected deal in order to get money.
486   * Preconditions:
487   *  1. The Deal index is valid.
488   *  2. Affiliate is not blocked.
489   *  3. The reward amount is non zero for the selected affiliate.
490   *  4. The reward amount is non zero for the selected deal.
491   * @param _dealIndex deal index
492   * Result:
493   *   All reward tokens are transferred from the current MultistageCrowdsale contract to the affiliate.
494   *   The reward amount for the selected affiliate is set to zero.
495   *   The reward amount for the selected deal is decreased.
496   */
497   function getMyReward(uint _dealIndex) public validDealIndex(_dealIndex) {
498     // validation
499     uint referenceHash = getReferenceHash(_dealIndex, msg.sender);
500     require(!affiliates[referenceHash].isBlocked, "Affiliate is blocked.");
501     require(affiliates[referenceHash].rewardAmount > 0, "rewardAmount for the affiliate is 0.");
502     require(deals[_dealIndex].leftStakeAmount >= affiliates[referenceHash].rewardAmount, "There is not enough stake to pay the reward.");
503     // update deal properties
504     deals[_dealIndex].leftStakeAmount = deals[_dealIndex].leftStakeAmount.sub(affiliates[referenceHash].rewardAmount);
505     // transfer reward tokens to affiliate
506     uint tokenAmountToTransfer = affiliates[referenceHash].rewardAmount;
507     affiliates[referenceHash].rewardAmount = 0;
508     deals[_dealIndex].lockedTokensAmount = deals[_dealIndex].lockedTokensAmount.sub(tokenAmountToTransfer);
509     ERC20(deals[_dealIndex].rewardTokenAddress).transfer(affiliates[referenceHash].affiliateAddress, tokenAmountToTransfer);
510     emit RewardClaimed(deals[_dealIndex].dealId, referenceHash, tokenAmountToTransfer);
511   }
512 
513   /**
514   * Merchant methods
515   */
516 
517   /**
518   * @dev Approves affiliate address for deal. As a merchant i would like to manually approve selected affiliate in order to provide incentives.
519   * @notice The same affiliate address can have different reference hashes because the same affiliate address can participate in multiple deals.
520   * @param _dealIndex deal index
521   * @param _affiliateAddress affiliate address
522   */
523   function approveAffiliate(uint _dealIndex, address _affiliateAddress) public validDealIndex(_dealIndex) activeDeal(_dealIndex) {
524     if (!deals[_dealIndex].allowAdminToAddAffiliate) {
525       require(msg.sender == merchantAddress, "Merchant permission required.");
526     } else {
527       require((msg.sender == adminAddress) || (msg.sender == merchantAddress), "Admin or merchant permission required.");
528     }
529     // validation
530     require(_affiliateAddress != address(0), "affiliateAddress can not be 0.");
531     // check that affiliate is not yet approved for this deal
532     require(dealAffiliateReferenceHashCount[_dealIndex][_affiliateAddress] == 0, "Affiliate is already approved for this deal.");
533     // create affiliate
534     Affiliate memory affiliate;
535     affiliate.affiliateAddress = _affiliateAddress;
536     // add affiliate to global affiliates property
537     affiliatesCount = affiliatesCount.add(1);
538     affiliates[affiliatesCount] = affiliate;
539     // add affliate to deal
540     uint _referenceHash = affiliatesCount;
541     deals[_dealIndex].referenceHashes.push(_referenceHash);
542     deals[_dealIndex].affiliatesCount = deals[_dealIndex].affiliatesCount.add(1);
543     // add deal to affiliate
544     affiliateDealIndexes[_affiliateAddress].push(_dealIndex);
545     affiliateDealIndexesCount[_affiliateAddress] = affiliateDealIndexesCount[_affiliateAddress].add(1);
546     // update globals affiliates count
547     dealAffiliateReferenceHash[_dealIndex][_affiliateAddress] = affiliatesCount;
548     dealAffiliateReferenceHashCount[_dealIndex][_affiliateAddress] = 1;
549     referenceHashDealIndex[affiliatesCount] = _dealIndex;
550     // emitting event
551     emit ApproveAffiliate(deals[_dealIndex].dealId, msg.sender, _dealIndex, _affiliateAddress, _referenceHash);
552   }
553 
554   /**
555   * @dev Cancels all deals by merchant
556   */
557   function cancelAllDealsByMerchant() public onlyMerchant {
558     for (uint i = 0; i < dealsCount; i++) {
559       if (canBeCancelledByMerchant(i)) {
560         cancelDealByMerchant(i);
561         emit DealCancelled(deals[i].dealId, deals[i].daysOfCancellation, msg.sender);
562       }
563     }
564   }
565 
566   /**
567   * @dev Marks deal to be cancelled by merchant. As a merchant I would like to request a deal cancelation in order to cancel it after “Cancelation period” is elapsed.
568   * @param _dealIndex deal index
569   */
570   function cancelDealByMerchant(uint _dealIndex) public onlyMerchant validDealIndex(_dealIndex) {
571     // validation
572     require(canBeCancelledByMerchant(_dealIndex),"Deal can not be cancelled by merchant.");
573     // mark deal to be cancelled
574     deals[_dealIndex].isCancelRequestedByMerchant = true;
575     deals[_dealIndex].cancelRequestedAt = now;
576     if (deals[_dealIndex].daysOfCancellation == 0) {
577       deals[_dealIndex].isCancelled = true;
578     }
579     emit DealCancelled(deals[_dealIndex].dealId, deals[_dealIndex].daysOfCancellation, msg.sender);
580   }
581 
582   /**
583   * @dev Creates a new deal by merchant. As a merchant i would like to create new deal in order to add incentives for affiliates.
584   * @param _dealId deal dealId
585   * @param _rewardTokenAddress ERC20 token address used for affiliates' rewards
586   * @param _rewardRatePpm reward rate ppm, 100% == 1000000
587   * @param _daysOfCancellation when deal is marked as cancelled it is still live for _daysOfCancellation number of days
588   * @param _daysBeforeClose number of days since deal creation when deal is still live, the deal is over and any left over staked tokens can be withdrawn by merchant
589   */
590 
591   function createDeal(bytes4 _dealId, address _rewardTokenAddress, uint _rewardRatePpm, uint _daysOfCancellation, uint _daysBeforeClose, bool _allowAdminToAddAffiliate) public onlyMerchant {
592     // validation
593     require(_rewardTokenAddress != address(0), "rewardTokenAddress can not be 0.");
594     require(_rewardRatePpm > 0, "rewardRatePpm can not be 0.");
595     require(_daysOfCancellation <= 90,"daysOfCancellation can not be >90.");
596     require(_daysBeforeClose > 0, "daysBeforeClose should be >0.");
597     require(_daysBeforeClose <= 365, "daysBeforeClose can not be >365.");
598     // create a new deal
599     Deal memory deal;
600     deal.dealId = _dealId;
601     deal.rewardTokenAddress = _rewardTokenAddress;
602     deal.rewardRatePpm = _rewardRatePpm;
603     deal.daysOfCancellation = _daysOfCancellation;
604     deal.daysBeforeClose = _daysBeforeClose;
605     deal.createdAt = now;
606     deal.allowAdminToAddAffiliate = _allowAdminToAddAffiliate;
607     deals[dealsCount] = deal;
608 
609     // update contract properties
610     dealsCount = dealsCount.add(1);
611     // emitting event
612 
613     emit CreateDeal(_dealId, dealsCount - 1, msg.sender, _rewardTokenAddress, _rewardRatePpm, _daysOfCancellation, _daysBeforeClose, dealsCount);
614   }
615 
616   /**
617   * @dev Stakes ERC20 tokens as reward for affiliates by merchant. As a merchant i would like to transfer ERC20 tokens to the selected deal in order to stake them.
618   * @notice Merchant should allow _amount of tokens to be withdrawn (use ERC20.approve() method) BEFORE calling this method.
619   * Preconditions:
620   *  1. The Deal was created by Merchant before
621   *  2. isCancelled == false
622   *  3. isClosed == false
623   *  4. Merchant allowed current MultistageCrowdsale to withdraw correct amount of tokens
624   * @param _dealIndex deal index
625   * @param _amount amount in wei
626   */
627   function fillStake(uint _dealIndex, uint _amount) public onlyMerchant validDealIndex(_dealIndex) activeDeal(_dealIndex) {
628     // validation
629     require(_amount > 0, "amount should be >0.");
630     ERC20 rewardToken = ERC20(deals[_dealIndex].rewardTokenAddress);
631     require(rewardToken.allowance(msg.sender, address(this)) >= _amount, "Allowance is not enough to send the required amount.");
632     // stake tokens for affiliates' rewards
633     deals[_dealIndex].leftStakeAmount = deals[_dealIndex].leftStakeAmount.add(_amount);
634     rewardToken.transferFrom(msg.sender, address(this), _amount);
635     emit StakeFilled(deals[_dealIndex].dealId, _amount, deals[_dealIndex].leftStakeAmount);
636   }
637 
638   /**
639   * @dev Returns tokens at stake back to merchant if deal is cancelled. As a merchant i would like to get my stake back in order to get my tokens back (if deal is cancelled).
640   * Preconditions:
641   *  1. The Deal was created by Merchant before.
642   *  2. The Deal isCancelled==true.
643   *  3. The Deal still has some stake left.
644   *  4. The Deal has enough tokens to pay to all affiliates.
645   * @param _dealIndex deal index
646   * Result:
647   *    All staked reward tokens are transferred from the current MultistageCrowdsale contract back to merchant.
648   *    The “Current reward stake amount” of the selected Deal is decreased.
649   */
650   function getMyStakeBack(uint _dealIndex) public onlyMerchant validDealIndex(_dealIndex) {
651     // validation
652     require(isDealCancelled(_dealIndex), "Deal is not cancelled.");
653     require(deals[_dealIndex].leftStakeAmount > 0, "There is no stake left.");
654     require(deals[_dealIndex].leftStakeAmount >= deals[_dealIndex].lockedTokensAmount, "Stake is lower than lockedTokensAmount.");
655     // transfer ERC20 tokens back to merchant
656     uint tokenAmountToWithdraw = deals[_dealIndex].leftStakeAmount - deals[_dealIndex].lockedTokensAmount;
657     deals[_dealIndex].leftStakeAmount = deals[_dealIndex].lockedTokensAmount;
658     ERC20(deals[_dealIndex].rewardTokenAddress).transfer(msg.sender, tokenAmountToWithdraw);
659   }
660 
661   /**
662   * @dev Updates a deal by merchant
663   * @param _dealIndex deal index
664   * @param _newRewardRatePpm new reward rate ppm, 100% == 1000000
665   */
666   function updateDeal(uint _dealIndex, uint _newRewardRatePpm) public onlyMerchant validDealIndex(_dealIndex) activeDeal(_dealIndex) {
667     require(_newRewardRatePpm > 0, "_newRewardRatePpm should be >0.");
668     deals[_dealIndex].rewardRatePpm = _newRewardRatePpm;
669     emit DealUpdated(deals[_dealIndex].dealId, _newRewardRatePpm);
670   }
671 
672   /**
673   * Internal methods
674   */
675 
676   /**
677   * @dev Increases affiliate's reward amount
678   * @param _referenceHash affiliate's reference hash(index/referenceHash that is passed to invest() function)
679   */
680   function _rewardAffiliate(uint _referenceHash, uint _purchasedTokenAmount) internal validReferenceHash(_referenceHash) {
681     // get deal index by reference hash
682     uint dealIndex = getDealIndex(_referenceHash);
683     // calculate reward amount for affiliate
684     uint rewardAmount = _purchasedTokenAmount.div(1000000).mul(deals[dealIndex].rewardRatePpm);
685     // add affiliate reward to affiliate
686     AffiliateReward memory affiliateReward;
687     affiliateReward.amount = rewardAmount;
688     affiliateReward.createdAt = now;
689     affiliates[_referenceHash].affiliateRewards[affiliates[_referenceHash].affiliateRewardsCount] = affiliateReward;
690     affiliates[_referenceHash].affiliateRewardsCount = affiliates[_referenceHash].affiliateRewardsCount.add(1);
691     // update affiliate reward amount
692     affiliates[_referenceHash].rewardAmount = affiliates[_referenceHash].rewardAmount.add(rewardAmount);
693     // update deal's locked token balance
694     deals[dealIndex].lockedTokensAmount = deals[dealIndex].lockedTokensAmount.add(rewardAmount);
695     emit RewardCreated(dealIndexToId(dealIndex), _referenceHash, _purchasedTokenAmount, rewardAmount);
696   }
697 
698 }
699 
700 
701 
702 /**
703  * @title Ownable
704  * @dev The Ownable contract has an owner address, and provides basic authorization control
705  * functions, this simplifies the implementation of "user permissions".
706  */
707 contract Ownable {
708   address public owner;
709 
710 
711   event OwnershipRenounced(address indexed previousOwner);
712   event OwnershipTransferred(
713     address indexed previousOwner,
714     address indexed newOwner
715   );
716 
717 
718   /**
719    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
720    * account.
721    */
722   constructor() public {
723     owner = msg.sender;
724   }
725 
726   /**
727    * @dev Throws if called by any account other than the owner.
728    */
729   modifier onlyOwner() {
730     require(msg.sender == owner);
731     _;
732   }
733 
734   /**
735    * @dev Allows the current owner to relinquish control of the contract.
736    * @notice Renouncing to ownership will leave the contract without an owner.
737    * It will not be possible to call the functions with the `onlyOwner`
738    * modifier anymore.
739    */
740   function renounceOwnership() public onlyOwner {
741     emit OwnershipRenounced(owner);
742     owner = address(0);
743   }
744 
745   /**
746    * @dev Allows the current owner to transfer control of the contract to a newOwner.
747    * @param _newOwner The address to transfer ownership to.
748    */
749   function transferOwnership(address _newOwner) public onlyOwner {
750     _transferOwnership(_newOwner);
751   }
752 
753   /**
754    * @dev Transfers control of the contract to a newOwner.
755    * @param _newOwner The address to transfer ownership to.
756    */
757   function _transferOwnership(address _newOwner) internal {
758     require(_newOwner != address(0));
759     emit OwnershipTransferred(owner, _newOwner);
760     owner = _newOwner;
761   }
762 }
763 
764 contract MultistageCrowdsale is DealsSupport, Ownable {
765   using SafeMath for uint256;
766 
767   /**
768    * Event for token purchase logging
769    * @param purchaser who paid for the tokens
770    * @param affiliate address, if any
771    * @param value weis paid for purchase
772    * @param amount amount of tokens purchased
773    * @param orderID to be used with fiat payments
774    */
775   event TokenPurchase(address indexed purchaser, address indexed affiliate, uint256 value, uint256 amount, bytes4 indexed orderID);
776 
777   struct Stage {
778     uint32 time;
779     uint64 rate;
780     uint256 minInv;
781     uint256 maxInv;
782 
783   }
784 
785   Stage[] stages;
786 
787   mapping(address => uint256) invested;
788 
789   address wallet;
790   address token;
791   address signer;
792   uint32 saleEndTime;
793 
794   /**
795    * @dev The constructor that takes all parameters
796    * @param _timesAndRates An array that defines the stages of the contract. the first entry being the start time of the sale, followed by pairs of rates ond close times of consequitive stages.
797    *       Example 1: [10000, 99, 12000]
798    *         A single stage sale that starts at unix time 10000 and ends 2000 seconds later.
799    *         This sale gives 99 tokens for each Gwei invested.
800    *       Example 2: [10000, 99, 12000, 88, 14000]
801    *         A 2 stage sale that starts at unix time 10000 and ends 4000 seconds later.
802    *         The sale reduces the rate at mid time
803    *         This sale gives 99 tokens for each Gwei invested in first stage.
804    *         The sale gives 88 tokens for each Gwei invested in second stage.
805    * @param _wallet The address of the wallet where invested Ether will be send to
806    * @param _token The tokens that the investor will receive
807    * @param _signer The address of the key that whitelists investor (operator key)
808    */
809   constructor(
810     uint256[] _timesAndRates,
811     address _wallet,
812     address _token,
813     address _signer,
814     address _admin,
815     address _merchant
816   )
817     public
818     DealsSupport(_admin, _merchant)
819   {
820     require(_wallet != address(0), "Wallet address can not be 0.");
821     require(_token != address(0), "Token address can not be 0.");
822 
823     storeStages(_timesAndRates);
824 
825     saleEndTime = uint32(_timesAndRates[_timesAndRates.length - 1]);
826     // check sale ends after last stage opening time
827     require(saleEndTime > stages[stages.length - 1].time, "Sale end time should be after last stage opening time.");
828 
829     wallet = _wallet;
830     token = _token;
831     signer = _signer;
832   }
833 
834   function setMinInvestmentAtStage(uint32 _stage, uint256 _value) onlyOwner public {
835     require(_stage < stages.length, "Stage does not exist");
836     require(_value != getMinInvAtStage(_stage),"That is the current minimum investment");
837     require(getMaxInvAtStage(_stage) == 0 || _value <= getMaxInvAtStage(_stage),"Minimum should be lower than the maximum investment when it is not 0");
838     stages[_stage].minInv = _value;
839   }
840 
841   function setMaxInvestmentAtStage(uint32 _stage, uint256 _value) onlyOwner public {
842     require(_stage < stages.length, "Stage does not exist");
843     require(_value != getMaxInvAtStage(_stage),"That is the current minimum investment");
844     require(_value == 0 || _value >= getMinInvAtStage(_stage),"Maximum should be either 0, or higher than the minimum investment");
845     stages[_stage].maxInv = _value;
846   }
847 
848   /**
849    * @dev called by investors to purchase tokens
850    * @param _r part of receipt signature
851    * @param _s part of receipt signature
852    * @param _a first payload of signed receipt.
853    * @param _b second payload of signed receipt.
854    *   The receipt commits to the follwing inputs:
855    *     56 bits - sale contract address, to prevent replay of receipt
856    *     32 bits - orderID for fiat payments
857    *     160 bits - beneficiary address - address whitelisted to receive tokens
858    *     32 bits - time - when receipt was signed
859    *     64 bits - outOfBandPaymentAmount - out of band payment amount, for fiat investments
860    *     32 bits - reference hash
861    */
862 
863   function invest(bytes32 _r, bytes32 _s, bytes32 _a, bytes32 _b) public payable {
864     // parse inputs
865     uint32 time = uint32(_b >> 224);
866     address beneficiary = address(_a);
867     uint256 outOfBandPaymentAmount = uint64(_b >> 160);
868     uint256 referenceHash = uint256(_b << 96 >> 224);
869 
870     // verify inputs
871     require(uint56(_a >> 192) == uint56(this), "Destination contract address does not match this contract address.");
872     if (outOfBandPaymentAmount == 0) {
873       outOfBandPaymentAmount = msg.value;
874     } else {
875       outOfBandPaymentAmount = outOfBandPaymentAmount.mul(1000000000);  // convert outOfBandPaymentAmount to wei
876     }
877     bytes4 orderID = bytes4(uint32(_a >> 160));
878     /* solium-disable-next-line arg-overflow */
879     require(ecrecover(keccak256(abi.encodePacked(uint8(0), uint248(_a), _b)), uint8(_a >> 248), _r, _s) == signer, "Signer address not matching.");
880     require(beneficiary != address(0), "Beneficiary can not be 0.");
881 
882     // check investment is above current minimum investment
883     require(outOfBandPaymentAmount>=getMinInvAt(now),"Investment below minimum required");
884     // check investment is under above current maximum investment
885     require(outOfBandPaymentAmount+invested[beneficiary]<=getMaxInvAt(now) || getMaxInvAt(now)==0,"Investment over maximum allowed in current stage");
886     // calculate token amount to be created
887     uint256 rate = getRateAt(now); // solium-disable-line security/no-block-members
888     // at the time of signing the receipt the rate should have been the same as now
889     require(rate == getRateAt(time), "rate not matching current stage rate.");
890     // multiply rate with Gwei of investment
891     // uint256 purchasedTokenAmount = rate.mul(outOfBandPaymentAmount).div(1000000000);
892     // multiply rate with Gwei of investment and ceil to avoid weird amounts
893     uint256 purchasedTokenAmount = ceil(rate.mul(outOfBandPaymentAmount).div(1000000000), 10**3);
894     // check that msg.value > 0
895     require(purchasedTokenAmount > 0, "purchasedTokenAmount can not be 0.");
896 
897     // pocket Ether
898     if (msg.value > 0) {
899       wallet.transfer(outOfBandPaymentAmount);
900     }
901 
902     // if user came from affiliate then reward affiliate
903     address affiliate = address(0);
904     if (referenceHash != 0) {
905       affiliate = affiliates[referenceHash].affiliateAddress;
906       _rewardAffiliate(referenceHash, purchasedTokenAmount);
907     }
908 
909     // do token transfer
910     invested[beneficiary] += outOfBandPaymentAmount;
911     ERC20(token).transferFrom(wallet, beneficiary, purchasedTokenAmount);
912     emit TokenPurchase(beneficiary, affiliate, outOfBandPaymentAmount, purchasedTokenAmount, orderID);
913   }
914 
915   function getParams() view public returns (uint256[] _times, uint256[] _rates, uint256[] _minInvs, uint256[] _maxInvs, address _wallet, address _token, address _signer) {
916     _times = new uint256[](stages.length + 1);
917     _rates = new uint256[](stages.length);
918     _minInvs = new uint256[](stages.length);
919     _maxInvs = new uint256[](stages.length);
920     for (uint256 i = 0; i < stages.length; i++) {
921       _times[i] = stages[i].time;
922       _rates[i] = stages[i].rate;
923       _minInvs[i] = stages[i].rate;
924       _maxInvs[i] = stages[i].rate;
925     }
926     _times[stages.length] = saleEndTime;
927     _wallet = wallet;
928     _token = token;
929     _signer = signer;
930   }
931 
932   function storeStages(uint256[] _timesAndRates) internal {
933     // check odd amount of array elements, groups of time, rate, minInv and maxInv + saleEndTime
934     require(_timesAndRates.length % 4 == 1, "Wrong number of parameters in times and rates.");
935     // check that at least 1 stage provided
936     require(_timesAndRates.length >= 5, "There should be at least 1 complete stage, check number of parameters.");
937 
938     for (uint256 i = 0; i < _timesAndRates.length / 4; i++) {
939       require(uint64(_timesAndRates[(i * 4) + 3]) == 0 || uint64(_timesAndRates[(i * 4) + 2]) <= uint64(_timesAndRates[(i * 4) + 3]), "Maximum should be higher than minimum, or 0");
940       stages.push(Stage(uint32(_timesAndRates[i * 4]), uint64(_timesAndRates[(i * 4) + 1]), uint64(_timesAndRates[(i * 4) + 2]), uint64(_timesAndRates[(i * 4) + 3])));
941       if (i > 0) {
942         // check that each time higher than previous time
943         require(stages[i-1].time < stages[i].time, "Starting time should be higher than previous stage starting time.");
944         // check that each rate is lower than previous rate
945         require(stages[i-1].rate > stages[i].rate, "rate can not be higher than previous stage rate.");
946       }
947     }
948 
949     // check that opening time in the future
950     require(stages[0].time > now, "Sale start time should be in the future."); // solium-disable-line security/no-block-members
951 
952     // check final rate > 0
953     require(stages[stages.length - 1].rate > 0, "Final rate can not be 0.");
954   }
955 
956   function updateRateAtStage (uint256 _stage, uint256 _newRate) public onlyOwner {
957     // if before first stage, return 0
958     require(_stage < stages.length, "Stage does not exist");
959     require(_newRate != getRateAtStage(_stage),"That is the current rate");
960     // check that each rate is lower than previous rate
961     if (_stage > 0) {
962       require(stages[_stage-1].rate > _newRate, "New rate can not be higher than previous stage rate.");
963     }
964     stages[_stage].rate = uint64(_newRate);
965   }
966 
967   function getRateAt(uint256 _now) view internal returns (uint256 rate) {
968     // if before first stage, return 0
969     if (_now < stages[0].time) {
970       return 0;
971     }
972     for (uint i = 1; i < stages.length; i++) {
973       if (_now < stages[i].time)
974         return stages[i - 1].rate;
975     }
976     // handle last stage
977     if (_now < saleEndTime)
978       return stages[stages.length - 1].rate;
979     // sale already closed
980     return 0;
981   }
982 
983   function getRateAtStage (uint256 _stage) view public returns (uint256 rate) {
984     // if before first stage, return 0
985     require(_stage < stages.length, "Stage does not exist");
986     return stages[_stage].rate;
987   }
988 
989   function getMinInvAt(uint256 _now) view public returns (uint256 inv) {
990     // if before first stage, return 0
991     require(_now >= stages[0].time, "Sale not started");
992     require(_now < saleEndTime, "Sale finished");
993 
994     for (uint i = 1; i < stages.length; i++) {
995       if (_now < stages[i].time)
996         return stages[i - 1].minInv;
997     }
998 
999     // handle last stage
1000     if (_now < saleEndTime)
1001       return stages[stages.length - 1].minInv;
1002   }
1003 
1004   function getMinInvAtStage(uint32 _stage) view public returns (uint256 inv) {
1005     require(_stage < stages.length, "Stage does not exist");
1006     return stages[_stage].minInv;
1007   }
1008 
1009   function getMaxInvAt(uint256 _now) view public returns (uint256 inv) {
1010     // if before first stage, return 0
1011     require(_now >= stages[0].time, "Sale not started");
1012     require(_now < saleEndTime, "Sale finished");
1013 
1014     for (uint i = 1; i < stages.length; i++) {
1015       if (_now < stages[i].time)
1016         return stages[i - 1].maxInv;
1017     }
1018 
1019     // handle last stage
1020     if (_now < saleEndTime)
1021       return stages[stages.length - 1].maxInv;
1022   }
1023 
1024   function getMaxInvAtStage(uint32 _stage) view public returns (uint256 inv) {
1025     require(_stage < stages.length, "Stage does not exist");
1026     return stages[_stage].maxInv;
1027   }
1028 
1029   function ceil(uint _value, uint _dec) pure private returns (uint) {
1030     return((_value + _dec - 1) / _dec) * _dec;
1031   }
1032 // Deals overrides:
1033   /*
1034   function isMerchant(address _a) public view returns(bool){
1035     // TODO: implement
1036     // Who is Merchnat in this case? Who deployed current contract or who owns current contract?
1037     return false;
1038   }
1039   */
1040 }
1041 
1042 library SafeMath {
1043 
1044   /**
1045   * @dev Multiplies two numbers, throws on overflow.
1046   */
1047   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1048     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1049     // benefit is lost if 'b' is also tested.
1050     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1051     if (_a == 0) {
1052       return 0;
1053     }
1054 
1055     c = _a * _b;
1056     assert(c / _a == _b);
1057     return c;
1058   }
1059 
1060   /**
1061   * @dev Integer division of two numbers, truncating the quotient.
1062   */
1063   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1064     // assert(_b > 0); // Solidity automatically throws when dividing by 0
1065     // uint256 c = _a / _b;
1066     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1067     return _a / _b;
1068   }
1069 
1070   /**
1071   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1072   */
1073   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1074     assert(_b <= _a);
1075     return _a - _b;
1076   }
1077 
1078   /**
1079   * @dev Adds two numbers, throws on overflow.
1080   */
1081   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1082     c = _a + _b;
1083     assert(c >= _a);
1084     return c;
1085   }
1086 }