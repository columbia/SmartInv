1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: contracts/SafeMath96.sol
164 
165 pragma solidity 0.6.12;
166 
167 /**
168  * @dev Wrappers over Solidity's arithmetic operations with added overflow
169  * checks.
170  *
171  * Arithmetic operations in Solidity wrap on overflow. This can easily result
172  * in bugs, because programmers usually assume that an overflow raises an
173  * error, which is the standard behavior in high level programming languages.
174  * `SafeMath` restores this intuition by reverting the transaction when an
175  * operation overflows.
176  *
177  * Using this library instead of the unchecked operations eliminates an entire
178  * class of bugs, so it's recommended to use it always.
179  */
180 library SafeMath96 {
181     /**
182      * @dev Returns the addition of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `+` operator.
186      *
187      * Requirements:
188      * - Addition cannot overflow.
189      */
190     function add(uint96 a, uint256 b) internal pure returns (uint96) {
191         require(uint256(uint96(b)) == b, "SafeMath: addition overflow");
192         uint96 c = a + uint96(b);
193         require(c >= a, "SafeMath: addition overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting on
200      * overflow (when the result is negative).
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      * - Subtraction cannot overflow.
206      */
207     function sub(uint96 a, uint256 b) internal pure returns (uint96) {
208         require(uint256(uint96(b)) == b, "SafeMath: subtraction overflow");
209         return sub(a, uint96(b), "SafeMath: subtraction overflow");
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      * - Subtraction cannot overflow.
220      *
221      * _Available since v2.4.0._
222      */
223     function sub(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
224         require(b <= a, errorMessage);
225         uint96 c = a - b;
226 
227         return c;
228     }
229 
230 }
231 
232 // File: @openzeppelin/contracts/math/Math.sol
233 
234 pragma solidity ^0.6.0;
235 
236 /**
237  * @dev Standard math utilities missing in the Solidity language.
238  */
239 library Math {
240     /**
241      * @dev Returns the largest of two numbers.
242      */
243     function max(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a >= b ? a : b;
245     }
246 
247     /**
248      * @dev Returns the smallest of two numbers.
249      */
250     function min(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a < b ? a : b;
252     }
253 
254     /**
255      * @dev Returns the average of two numbers. The result is rounded towards
256      * zero.
257      */
258     function average(uint256 a, uint256 b) internal pure returns (uint256) {
259         // (a + b) / 2 can overflow, so we distribute
260         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
261     }
262 }
263 
264 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
265 
266 pragma solidity ^0.6.0;
267 
268 /**
269  * @dev Interface of the ERC20 standard as defined in the EIP.
270  */
271 interface IERC20 {
272     /**
273      * @dev Returns the amount of tokens in existence.
274      */
275     function totalSupply() external view returns (uint256);
276 
277     /**
278      * @dev Returns the amount of tokens owned by `account`.
279      */
280     function balanceOf(address account) external view returns (uint256);
281 
282     /**
283      * @dev Moves `amount` tokens from the caller's account to `recipient`.
284      *
285      * Returns a boolean value indicating whether the operation succeeded.
286      *
287      * Emits a {Transfer} event.
288      */
289     function transfer(address recipient, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Returns the remaining number of tokens that `spender` will be
293      * allowed to spend on behalf of `owner` through {transferFrom}. This is
294      * zero by default.
295      *
296      * This value changes when {approve} or {transferFrom} are called.
297      */
298     function allowance(address owner, address spender) external view returns (uint256);
299 
300     /**
301      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * IMPORTANT: Beware that changing an allowance with this method brings the risk
306      * that someone may use both the old and the new allowance by unfortunate
307      * transaction ordering. One possible solution to mitigate this race
308      * condition is to first reduce the spender's allowance to 0 and set the
309      * desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      *
312      * Emits an {Approval} event.
313      */
314     function approve(address spender, uint256 amount) external returns (bool);
315 
316     /**
317      * @dev Moves `amount` tokens from `sender` to `recipient` using the
318      * allowance mechanism. `amount` is then deducted from the caller's
319      * allowance.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Emitted when `value` tokens are moved from one account (`from`) to
329      * another (`to`).
330      *
331      * Note that `value` may be zero.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 value);
334 
335     /**
336      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
337      * a call to {approve}. `value` is the new allowance.
338      */
339     event Approval(address indexed owner, address indexed spender, uint256 value);
340 }
341 
342 // File: contracts/spec_interfaces/ICommittee.sol
343 
344 pragma solidity 0.6.12;
345 
346 /// @title Committee contract interface
347 interface ICommittee {
348 	event CommitteeChange(address indexed addr, uint256 weight, bool certification, bool inCommittee);
349 	event CommitteeSnapshot(address[] addrs, uint256[] weights, bool[] certification);
350 
351 	// No external functions
352 
353 	/*
354      * External functions
355      */
356 
357     /// Notifies a weight change of a member
358     /// @dev Called only by: Elections contract
359     /// @param addr is the committee member address
360     /// @param weight is the updated weight of the committee member
361 	function memberWeightChange(address addr, uint256 weight) external /* onlyElectionsContract onlyWhenActive */;
362 
363     /// Notifies a change in the certification of a member
364     /// @dev Called only by: Elections contract
365     /// @param addr is the committee member address
366     /// @param isCertified is the updated certification state of the member
367 	function memberCertificationChange(address addr, bool isCertified) external /* onlyElectionsContract onlyWhenActive */;
368 
369     /// Notifies a member removal for example due to voteOut or voteUnready
370     /// @dev Called only by: Elections contract
371     /// @param memberRemoved is the removed committee member address
372     /// @return memberRemoved indicates whether the member was removed from the committee
373     /// @return removedMemberWeight indicates the removed member weight
374     /// @return removedMemberCertified indicates whether the member was in the certified committee
375 	function removeMember(address addr) external returns (bool memberRemoved, uint removedMemberWeight, bool removedMemberCertified)/* onlyElectionContract */;
376 
377     /// Notifies a new member applicable for committee (due to registration, unbanning, certification change)
378     /// The new member will be added only if it is qualified to join the committee 
379     /// @dev Called only by: Elections contract
380     /// @param addr is the added committee member address
381     /// @param weight is the added member weight
382     /// @param isCertified is the added member certification state
383     /// @return memberAdded bool indicates whether the member was added
384 	function addMember(address addr, uint256 weight, bool isCertified) external returns (bool memberAdded)  /* onlyElectionsContract */;
385 
386     /// Checks if addMember() would add a the member to the committee (qualified to join)
387     /// @param addr is the candidate committee member address
388     /// @param weight is the candidate committee member weight
389     /// @return wouldAddMember bool indicates whether the member will be added
390 	function checkAddMember(address addr, uint256 weight) external view returns (bool wouldAddMember);
391 
392     /// Returns the committee members and their weights
393     /// @return addrs is the committee members list
394     /// @return weights is an array of uint, indicating committee members list weight
395     /// @return certification is an array of bool, indicating the committee members certification status
396 	function getCommittee() external view returns (address[] memory addrs, uint256[] memory weights, bool[] memory certification);
397 
398     /// Returns the currently appointed committee data
399     /// @return generalCommitteeSize is the number of members in the committee
400     /// @return certifiedCommitteeSize is the number of certified members in the committee
401     /// @return totalWeight is the total effective stake (weight) of the committee
402 	function getCommitteeStats() external view returns (uint generalCommitteeSize, uint certifiedCommitteeSize, uint totalWeight);
403 
404     /// Returns a committee member data
405     /// @param addr is the committee member address
406     /// @return inCommittee indicates whether the queried address is a member in the committee
407     /// @return weight is the committee member weight
408     /// @return isCertified indicates whether the committee member is certified
409     /// @return totalCommitteeWeight is the total weight of the committee.
410 	function getMemberInfo(address addr) external view returns (bool inCommittee, uint weight, bool isCertified, uint totalCommitteeWeight);
411 
412     /// Emits a CommitteeSnapshot events with current committee info
413     /// @dev a CommitteeSnapshot is useful on contract migration or to remove the need to track past events.
414 	function emitCommitteeSnapshot() external;
415 
416 	/*
417 	 * Governance functions
418 	 */
419 
420 	event MaxCommitteeSizeChanged(uint8 newValue, uint8 oldValue);
421 
422     /// Sets the maximum number of committee members
423     /// @dev governance function called only by the functional manager
424     /// @dev when reducing the number of members, the bottom ones are removed from the committee
425     /// @param _maxCommitteeSize is the maximum number of committee members 
426 	function setMaxCommitteeSize(uint8 _maxCommitteeSize) external /* onlyFunctionalManager */;
427 
428     /// Returns the maximum number of committee members
429     /// @return maxCommitteeSize is the maximum number of committee members 
430 	function getMaxCommitteeSize() external view returns (uint8);
431 	
432     /// Imports the committee members from a previous committee contract during migration
433     /// @dev initialization function called only by the initializationManager
434     /// @dev does not update the reward contract to avoid incorrect notifications 
435     /// @param previousCommitteeContract is the address of the previous committee contract
436 	function importMembers(ICommittee previousCommitteeContract) external /* onlyInitializationAdmin */;
437 }
438 
439 // File: contracts/spec_interfaces/IProtocolWallet.sol
440 
441 pragma solidity 0.6.12;
442 
443 
444 /// @title Protocol Wallet interface
445 interface IProtocolWallet {
446     event FundsAddedToPool(uint256 added, uint256 total);
447 
448     /*
449     * External functions
450     */
451 
452     /// Returns the address of the underlying staked token
453     /// @return balance is the wallet balance
454     function getBalance() external view returns (uint256 balance);
455 
456     /// Transfers the given amount of orbs tokens form the sender to this contract and updates the pool
457     /// @dev assumes the caller approved the amount prior to calling
458     /// @param amount is the amount to add to the wallet
459     function topUp(uint256 amount) external;
460 
461     /// Withdraws from pool to the client address, limited by the pool's MaxRate.
462     /// @dev may only be called by the wallet client
463     /// @dev no more than MaxRate x time period since the last withdraw may be withdrawn
464     /// @dev allocation that wasn't withdrawn can not be withdrawn in the next call
465     /// @param amount is the amount to withdraw
466     function withdraw(uint256 amount) external; /* onlyClient */
467 
468 
469     /*
470     * Governance functions
471     */
472 
473     event ClientSet(address client);
474     event MaxAnnualRateSet(uint256 maxAnnualRate);
475     event EmergencyWithdrawal(address addr, address token);
476     event OutstandingTokensReset(uint256 startTime);
477 
478     /// Sets a new annual withdraw rate for the pool
479     /// @dev governance function called only by the migration owner
480     /// @dev the rate for a duration is duration x annualRate / 1 year 
481     /// @param _annualRate is the maximum annual rate that can be withdrawn
482     function setMaxAnnualRate(uint256 _annualRate) external; /* onlyMigrationOwner */
483 
484     /// Returns the annual withdraw rate of the pool
485     /// @return annualRate is the maximum annual rate that can be withdrawn
486     function getMaxAnnualRate() external view returns (uint256);
487 
488     /// Resets the outstanding tokens to new start time
489     /// @dev governance function called only by the migration owner
490     /// @dev the next duration will be calculated starting from the given time
491     /// @param startTime is the time to set as the last withdrawal time
492     function resetOutstandingTokens(uint256 startTime) external; /* onlyMigrationOwner */
493 
494     /// Emergency withdraw the wallet funds
495     /// @dev governance function called only by the migration owner
496     /// @dev used in emergencies, when a migration to a new wallet is needed
497     /// @param erc20 is the erc20 address of the token to withdraw
498     function emergencyWithdraw(address erc20) external; /* onlyMigrationOwner */
499 
500     /// Sets the address of the client that can withdraw funds
501     /// @dev governance function called only by the functional owner
502     /// @param _client is the address of the new client
503     function setClient(address _client) external; /* onlyFunctionalOwner */
504 
505 }
506 
507 // File: contracts/spec_interfaces/IMigratableFeesWallet.sol
508 
509 pragma solidity 0.6.12;
510 
511 /// @title An interface for Fee wallets that support bucket migration.
512 interface IMigratableFeesWallet {
513 
514     /// Accepts a bucket fees from a old fees wallet as part of a migration
515     /// @dev Called by the old FeesWallet contract.
516     /// @dev Part of the IMigratableFeesWallet interface.
517     /// @dev assumes the caller approved the transfer of the amount prior to calling
518     /// @param bucketStartTime is the start time of the bucket to migration, must be a bucket's valid start time
519     /// @param amount is the amount to migrate (transfer) to the bucket
520     function acceptBucketMigration(uint256 bucketStartTime, uint256 amount) external;
521 }
522 
523 // File: contracts/spec_interfaces/IFeesWallet.sol
524 
525 pragma solidity 0.6.12;
526 
527 
528 /// @title Fees Wallet contract interface, manages the fee buckets
529 interface IFeesWallet {
530 
531     event FeesWithdrawnFromBucket(uint256 bucketId, uint256 withdrawn, uint256 total);
532     event FeesAddedToBucket(uint256 bucketId, uint256 added, uint256 total);
533 
534     /*
535      *   External methods
536      */
537 
538     /// Top-ups the fee pool with the given amount at the given rate
539     /// @dev Called by: subscriptions contract. (not enforced)
540     /// @dev fills the rewards in 30 days buckets based on the monthlyRate
541     /// @param amount is the amount to fill
542     /// @param monthlyRate is the monthly rate
543     /// @param fromTimestamp is the to start fill the buckets, determines the first bucket to fill and the amount filled in the first bucket.
544     function fillFeeBuckets(uint256 amount, uint256 monthlyRate, uint256 fromTimestamp) external;
545 
546     /// Collect fees from the buckets since the last call and transfers the amount back.
547     /// @dev Called by: only FeesAndBootstrapRewards contract
548     /// @dev The amount to collect may be queried before collect by calling getOutstandingFees
549     /// @return collectedFees the amount of fees collected and transferred
550     function collectFees() external returns (uint256 collectedFees) /* onlyRewardsContract */;
551 
552     /// Returns the amount of fees that are currently available for withdrawal
553     /// @param currentTime is the time to check the pending fees for
554     /// @return outstandingFees is the amount of pending fees to collect at time currentTime
555     function getOutstandingFees(uint256 currentTime) external view returns (uint256 outstandingFees);
556 
557     /*
558      * General governance
559      */
560 
561     event EmergencyWithdrawal(address addr, address token);
562 
563     /// Migrates the fees of a bucket starting at startTimestamp.
564     /// @dev governance function called only by the migration manager
565     /// @dev Calls acceptBucketMigration in the destination contract.
566     /// @param destination is the address of the new FeesWallet contract
567     /// @param bucketStartTime is the start time of the bucket to migration, must be a bucket's valid start time
568     function migrateBucket(IMigratableFeesWallet destination, uint256 bucketStartTime) external /* onlyMigrationManager */;
569 
570     /// Accepts a fees bucket balance from a old fees wallet as part of the fees wallet migration
571     /// @dev Called by the old FeesWallet contract.
572     /// @dev Part of the IMigratableFeesWallet interface.
573     /// @dev assumes the caller approved the amount prior to calling
574     /// @param bucketStartTime is the start time of the bucket to migration, must be a bucket's valid start time
575     /// @param amount is the amount to migrate (transfer) to the bucket
576     function acceptBucketMigration(uint256 bucketStartTime, uint256 amount) external;
577 
578     /// Emergency withdraw the contract funds
579     /// @dev governance function called only by the migration manager
580     /// @dev used in emergencies only, where migrateBucket is not a suitable solution
581     /// @param erc20 is the erc20 address of the token to withdraw
582     function emergencyWithdraw(address erc20) external /* onlyMigrationManager */;
583 
584 }
585 
586 // File: contracts/spec_interfaces/IFeesAndBootstrapRewards.sol
587 
588 pragma solidity 0.6.12;
589 
590 /// @title Rewards contract interface
591 interface IFeesAndBootstrapRewards {
592     event FeesAllocated(uint256 allocatedGeneralFees, uint256 generalFeesPerMember, uint256 allocatedCertifiedFees, uint256 certifiedFeesPerMember);
593     event FeesAssigned(address indexed guardian, uint256 amount, uint256 totalAwarded, bool certification, uint256 feesPerMember);
594     event FeesWithdrawn(address indexed guardian, uint256 amount, uint256 totalWithdrawn);
595     event BootstrapRewardsAllocated(uint256 allocatedGeneralBootstrapRewards, uint256 generalBootstrapRewardsPerMember, uint256 allocatedCertifiedBootstrapRewards, uint256 certifiedBootstrapRewardsPerMember);
596     event BootstrapRewardsAssigned(address indexed guardian, uint256 amount, uint256 totalAwarded, bool certification, uint256 bootstrapPerMember);
597     event BootstrapRewardsWithdrawn(address indexed guardian, uint256 amount, uint256 totalWithdrawn);
598 
599     /*
600     * External functions
601     */
602 
603     /// Triggers update of the guardian rewards
604     /// @dev Called by: the Committee contract
605     /// @dev called upon expected change in the committee membership of the guardian
606     /// @param guardian is the guardian who's committee membership is updated
607     /// @param inCommittee indicates whether the guardian is in the committee prior to the change
608     /// @param isCertified indicates whether the guardian is certified prior to the change
609     /// @param nextCertification indicates whether after the change, the guardian is certified
610     /// @param generalCommitteeSize indicates the general committee size prior to the change
611     /// @param certifiedCommitteeSize indicates the certified committee size prior to the change
612     function committeeMembershipWillChange(address guardian, bool inCommittee, bool isCertified, bool nextCertification, uint generalCommitteeSize, uint certifiedCommitteeSize) external /* onlyCommitteeContract */;
613 
614     /// Returns the fees and bootstrap balances of a guardian
615     /// @dev calculates the up to date balances (differ from the state)
616     /// @param guardian is the guardian address
617     /// @return feeBalance the guardian's fees balance
618     /// @return bootstrapBalance the guardian's bootstrap balance
619     function getFeesAndBootstrapBalance(address guardian) external view returns (
620         uint256 feeBalance,
621         uint256 bootstrapBalance
622     );
623 
624     /// Returns an estimation of the fees and bootstrap a guardian will be entitled to for a duration of time
625     /// The estimation is based on the current system state and there for only provides an estimation
626     /// @param guardian is the guardian address
627     /// @param duration is the amount of time in seconds for which the estimation is calculated
628     /// @return estimatedFees is the estimated received fees for the duration
629     /// @return estimatedBootstrapRewards is the estimated received bootstrap for the duration
630     function estimateFutureFeesAndBootstrapRewards(address guardian, uint256 duration) external view returns (
631         uint256 estimatedFees,
632         uint256 estimatedBootstrapRewards
633     );
634 
635     /// Transfers the guardian Fees balance to their account
636     /// @dev One may withdraw for another guardian
637     /// @param guardian is the guardian address
638     function withdrawFees(address guardian) external;
639 
640     /// Transfers the guardian bootstrap balance to their account
641     /// @dev One may withdraw for another guardian
642     /// @param guardian is the guardian address
643     function withdrawBootstrapFunds(address guardian) external;
644 
645     /// Returns the current global Fees and Bootstrap rewards state 
646     /// @dev calculated to the latest block, may differ from the state read
647     /// @return certifiedFeesPerMember represents the fees a certified committee member from day 0 would have receive
648     /// @return generalFeesPerMember represents the fees a non-certified committee member from day 0 would have receive
649     /// @return certifiedBootstrapPerMember represents the bootstrap fund a certified committee member from day 0 would have receive
650     /// @return generalBootstrapPerMember represents the bootstrap fund a non-certified committee member from day 0 would have receive
651     /// @return lastAssigned is the time the calculation was done to (typically the latest block time)
652     function getFeesAndBootstrapState() external view returns (
653         uint256 certifiedFeesPerMember,
654         uint256 generalFeesPerMember,
655         uint256 certifiedBootstrapPerMember,
656         uint256 generalBootstrapPerMember,
657         uint256 lastAssigned
658     );
659 
660     /// Returns the current guardian Fees and Bootstrap rewards state 
661     /// @dev calculated to the latest block, may differ from the state read
662     /// @param guardian is the guardian to query
663     /// @return feeBalance is the guardian fees balance 
664     /// @return lastFeesPerMember is the FeesPerMember on the last update based on the guardian certification state
665     /// @return bootstrapBalance is the guardian bootstrap balance 
666     /// @return lastBootstrapPerMember is the FeesPerMember on the last BootstrapPerMember based on the guardian certification state
667     /// @return withdrawnFees is the amount of fees withdrawn by the guardian
668     /// @return withdrawnBootstrap is the amount of bootstrap reward withdrawn by the guardian
669     /// @return certified is the current guardian certification state 
670     function getFeesAndBootstrapData(address guardian) external view returns (
671         uint256 feeBalance,
672         uint256 lastFeesPerMember,
673         uint256 bootstrapBalance,
674         uint256 lastBootstrapPerMember,
675         uint256 withdrawnFees,
676         uint256 withdrawnBootstrap,
677         bool certified
678     );
679 
680     /*
681      * Governance
682      */
683 
684     event GeneralCommitteeAnnualBootstrapChanged(uint256 generalCommitteeAnnualBootstrap);
685     event CertifiedCommitteeAnnualBootstrapChanged(uint256 certifiedCommitteeAnnualBootstrap);
686     event RewardDistributionActivated(uint256 startTime);
687     event RewardDistributionDeactivated();
688     event FeesAndBootstrapRewardsBalanceMigrated(address indexed guardian, uint256 fees, uint256 bootstrapRewards, address toRewardsContract);
689     event FeesAndBootstrapRewardsBalanceMigrationAccepted(address from, address indexed guardian, uint256 fees, uint256 bootstrapRewards);
690     event EmergencyWithdrawal(address addr, address token);
691 
692     /// Activates fees and bootstrap allocation
693     /// @dev governance function called only by the initialization admin
694     /// @dev On migrations, startTime should be set as the previous contract deactivation time.
695     /// @param startTime sets the last assignment time
696     function activateRewardDistribution(uint startTime) external /* onlyInitializationAdmin */;
697     
698     /// Deactivates fees and bootstrap allocation
699     /// @dev governance function called only by the migration manager
700     /// @dev guardians updates remain active based on the current perMember value
701     function deactivateRewardDistribution() external /* onlyMigrationManager */;
702 
703     /// Returns the rewards allocation activation status
704     /// @return rewardAllocationActive is the activation status
705     function isRewardAllocationActive() external view returns (bool);
706 
707     /// Sets the annual rate for the general committee bootstrap
708     /// @dev governance function called only by the functional manager
709     /// @dev updates the global bootstrap and fees state before updating  
710     /// @param annualAmount is the annual general committee bootstrap award
711     function setGeneralCommitteeAnnualBootstrap(uint256 annualAmount) external /* onlyFunctionalManager */;
712 
713     /// Returns the general committee annual bootstrap award
714     /// @return generalCommitteeAnnualBootstrap is the general committee annual bootstrap
715     function getGeneralCommitteeAnnualBootstrap() external view returns (uint256);
716 
717     /// Sets the annual rate for the certified committee bootstrap
718     /// @dev governance function called only by the functional manager
719     /// @dev updates the global bootstrap and fees state before updating  
720     /// @param annualAmount is the annual certified committee bootstrap award
721     function setCertifiedCommitteeAnnualBootstrap(uint256 annualAmount) external /* onlyFunctionalManager */;
722 
723     /// Returns the certified committee annual bootstrap reward
724     /// @return certifiedCommitteeAnnualBootstrap is the certified committee additional annual bootstrap
725     function getCertifiedCommitteeAnnualBootstrap() external view returns (uint256);
726 
727     /// Migrates the rewards balance to a new FeesAndBootstrap contract
728     /// @dev The new rewards contract is determined according to the contracts registry
729     /// @dev No impact of the calling contract if the currently configured contract in the registry
730     /// @dev may be called also while the contract is locked
731     /// @param guardians is the list of guardians to migrate
732     function migrateRewardsBalance(address[] calldata guardians) external;
733 
734     /// Accepts guardian's balance migration from a previous rewards contract
735     /// @dev the function may be called by any caller that approves the amounts provided for transfer
736     /// @param guardians is the list of migrated guardians
737     /// @param fees is the list of received guardian fees balance
738     /// @param totalFees is the total amount of fees migrated for all guardians in the list. Must match the sum of the fees list.
739     /// @param bootstrap is the list of received guardian bootstrap balance.
740     /// @param totalBootstrap is the total amount of bootstrap rewards migrated for all guardians in the list. Must match the sum of the bootstrap list.
741     function acceptRewardsBalanceMigration(address[] memory guardians, uint256[] memory fees, uint256 totalFees, uint256[] memory bootstrap, uint256 totalBootstrap) external;
742 
743     /// Performs emergency withdrawal of the contract balance
744     /// @dev called with a token to withdraw, should be called twice with the fees and bootstrap tokens
745     /// @dev governance function called only by the migration manager
746     /// @param erc20 is the ERC20 token to withdraw
747     function emergencyWithdraw(address erc20) external; /* onlyMigrationManager */
748 
749     /// Returns the contract's settings
750     /// @return generalCommitteeAnnualBootstrap is the general committee annual bootstrap
751     /// @return certifiedCommitteeAnnualBootstrap is the certified committee additional annual bootstrap
752     /// @return rewardAllocationActive indicates the rewards allocation activation state 
753     function getSettings() external view returns (
754         uint generalCommitteeAnnualBootstrap,
755         uint certifiedCommitteeAnnualBootstrap,
756         bool rewardAllocationActive
757     );
758 }
759 
760 // File: contracts/spec_interfaces/IManagedContract.sol
761 
762 pragma solidity 0.6.12;
763 
764 /// @title managed contract interface, used by the contracts registry to notify the contract on updates
765 interface IManagedContract /* is ILockable, IContractRegistryAccessor, Initializable */ {
766 
767     /// Refreshes the address of the other contracts the contract interacts with
768     /// @dev called by the registry contract upon an update of a contract in the registry
769     function refreshContracts() external;
770 
771 }
772 
773 // File: contracts/spec_interfaces/IContractRegistry.sol
774 
775 pragma solidity 0.6.12;
776 
777 /// @title Contract registry contract interface
778 /// @dev The contract registry holds Orbs PoS contracts and managers lists
779 /// @dev The contract registry updates the managed contracts on changes in the contract list
780 /// @dev Governance functions restricted to managers access the registry to retrieve the manager address 
781 /// @dev The contract registry represents the source of truth for Orbs Ethereum contracts 
782 /// @dev By tracking the registry events or query before interaction, one can access the up to date contracts 
783 interface IContractRegistry {
784 
785 	event ContractAddressUpdated(string contractName, address addr, bool managedContract);
786 	event ManagerChanged(string role, address newManager);
787 	event ContractRegistryUpdated(address newContractRegistry);
788 
789 	/*
790 	* External functions
791 	*/
792 
793     /// Updates the contracts address and emits a corresponding event
794     /// @dev governance function called only by the migrationManager or registryAdmin
795     /// @param contractName is the contract name, used to identify it
796     /// @param addr is the contract updated address
797     /// @param managedContract indicates whether the contract is managed by the registry and notified on changes
798 	function setContract(string calldata contractName, address addr, bool managedContract) external /* onlyAdminOrMigrationManager */;
799 
800     /// Returns the current address of the given contracts
801     /// @param contractName is the contract name, used to identify it
802     /// @return addr is the contract updated address
803 	function getContract(string calldata contractName) external view returns (address);
804 
805     /// Returns the list of contract addresses managed by the registry
806     /// @dev Managed contracts are updated on changes in the registry contracts addresses 
807     /// @return addrs is the list of managed contracts
808 	function getManagedContracts() external view returns (address[] memory);
809 
810     /// Locks all the managed contracts 
811     /// @dev governance function called only by the migrationManager or registryAdmin
812     /// @dev When set all onlyWhenActive functions will revert
813 	function lockContracts() external /* onlyAdminOrMigrationManager */;
814 
815     /// Unlocks all the managed contracts 
816     /// @dev governance function called only by the migrationManager or registryAdmin
817 	function unlockContracts() external /* onlyAdminOrMigrationManager */;
818 	
819     /// Updates a manager address and emits a corresponding event
820     /// @dev governance function called only by the registryAdmin
821     /// @dev the managers list is a flexible list of role to the manager's address
822     /// @param role is the managers' role name, for example "functionalManager"
823     /// @param manager is the manager updated address
824 	function setManager(string calldata role, address manager) external /* onlyAdmin */;
825 
826     /// Returns the current address of the given manager
827     /// @param role is the manager name, used to identify it
828     /// @return addr is the manager updated address
829 	function getManager(string calldata role) external view returns (address);
830 
831     /// Sets a new contract registry to migrate to
832     /// @dev governance function called only by the registryAdmin
833     /// @dev updates the registry address record in all the managed contracts
834     /// @dev by tracking the emitted ContractRegistryUpdated, tools can track the up to date contracts
835     /// @param newRegistry is the new registry contract 
836 	function setNewContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;
837 
838     /// Returns the previous contract registry address 
839     /// @dev used when the setting the contract as a new registry to assure a valid registry
840     /// @return previousContractRegistry is the previous contract registry
841 	function getPreviousContractRegistry() external view returns (address);
842 }
843 
844 // File: contracts/spec_interfaces/IContractRegistryAccessor.sol
845 
846 pragma solidity 0.6.12;
847 
848 
849 interface IContractRegistryAccessor {
850 
851     /// Sets the contract registry address
852     /// @dev governance function called only by an admin
853     /// @param newRegistry is the new registry contract 
854     function setContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;
855 
856     /// Returns the contract registry address
857     /// @return contractRegistry is the contract registry address
858     function getContractRegistry() external view returns (IContractRegistry contractRegistry);
859 
860     function setRegistryAdmin(address _registryAdmin) external /* onlyInitializationAdmin */;
861 
862 }
863 
864 // File: @openzeppelin/contracts/GSN/Context.sol
865 
866 pragma solidity ^0.6.0;
867 
868 /*
869  * @dev Provides information about the current execution context, including the
870  * sender of the transaction and its data. While these are generally available
871  * via msg.sender and msg.data, they should not be accessed in such a direct
872  * manner, since when dealing with GSN meta-transactions the account sending and
873  * paying for execution may not be the actual sender (as far as an application
874  * is concerned).
875  *
876  * This contract is only required for intermediate, library-like contracts.
877  */
878 abstract contract Context {
879     function _msgSender() internal view virtual returns (address payable) {
880         return msg.sender;
881     }
882 
883     function _msgData() internal view virtual returns (bytes memory) {
884         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
885         return msg.data;
886     }
887 }
888 
889 // File: contracts/WithClaimableRegistryManagement.sol
890 
891 pragma solidity 0.6.12;
892 
893 
894 /**
895  * @title Claimable
896  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
897  * This allows the new owner to accept the transfer.
898  */
899 contract WithClaimableRegistryManagement is Context {
900     address private _registryAdmin;
901     address private _pendingRegistryAdmin;
902 
903     event RegistryManagementTransferred(address indexed previousRegistryAdmin, address indexed newRegistryAdmin);
904 
905     /**
906      * @dev Initializes the contract setting the deployer as the initial registryRegistryAdmin.
907      */
908     constructor () internal {
909         address msgSender = _msgSender();
910         _registryAdmin = msgSender;
911         emit RegistryManagementTransferred(address(0), msgSender);
912     }
913 
914     /**
915      * @dev Returns the address of the current registryAdmin.
916      */
917     function registryAdmin() public view returns (address) {
918         return _registryAdmin;
919     }
920 
921     /**
922      * @dev Throws if called by any account other than the registryAdmin.
923      */
924     modifier onlyRegistryAdmin() {
925         require(isRegistryAdmin(), "WithClaimableRegistryManagement: caller is not the registryAdmin");
926         _;
927     }
928 
929     /**
930      * @dev Returns true if the caller is the current registryAdmin.
931      */
932     function isRegistryAdmin() public view returns (bool) {
933         return _msgSender() == _registryAdmin;
934     }
935 
936     /**
937      * @dev Leaves the contract without registryAdmin. It will not be possible to call
938      * `onlyManager` functions anymore. Can only be called by the current registryAdmin.
939      *
940      * NOTE: Renouncing registryManagement will leave the contract without an registryAdmin,
941      * thereby removing any functionality that is only available to the registryAdmin.
942      */
943     function renounceRegistryManagement() public onlyRegistryAdmin {
944         emit RegistryManagementTransferred(_registryAdmin, address(0));
945         _registryAdmin = address(0);
946     }
947 
948     /**
949      * @dev Transfers registryManagement of the contract to a new account (`newManager`).
950      */
951     function _transferRegistryManagement(address newRegistryAdmin) internal {
952         require(newRegistryAdmin != address(0), "RegistryAdmin: new registryAdmin is the zero address");
953         emit RegistryManagementTransferred(_registryAdmin, newRegistryAdmin);
954         _registryAdmin = newRegistryAdmin;
955     }
956 
957     /**
958      * @dev Modifier throws if called by any account other than the pendingManager.
959      */
960     modifier onlyPendingRegistryAdmin() {
961         require(msg.sender == _pendingRegistryAdmin, "Caller is not the pending registryAdmin");
962         _;
963     }
964     /**
965      * @dev Allows the current registryAdmin to set the pendingManager address.
966      * @param newRegistryAdmin The address to transfer registryManagement to.
967      */
968     function transferRegistryManagement(address newRegistryAdmin) public onlyRegistryAdmin {
969         _pendingRegistryAdmin = newRegistryAdmin;
970     }
971 
972     /**
973      * @dev Allows the _pendingRegistryAdmin address to finalize the transfer.
974      */
975     function claimRegistryManagement() external onlyPendingRegistryAdmin {
976         _transferRegistryManagement(_pendingRegistryAdmin);
977         _pendingRegistryAdmin = address(0);
978     }
979 
980     /**
981      * @dev Returns the current pendingRegistryAdmin
982     */
983     function pendingRegistryAdmin() public view returns (address) {
984        return _pendingRegistryAdmin;  
985     }
986 }
987 
988 // File: contracts/Initializable.sol
989 
990 pragma solidity 0.6.12;
991 
992 contract Initializable {
993 
994     address private _initializationAdmin;
995 
996     event InitializationComplete();
997 
998     /// Constructor
999     /// Sets the initializationAdmin to the contract deployer
1000     /// The initialization admin may call any manager only function until initializationComplete
1001     constructor() public{
1002         _initializationAdmin = msg.sender;
1003     }
1004 
1005     modifier onlyInitializationAdmin() {
1006         require(msg.sender == initializationAdmin(), "sender is not the initialization admin");
1007 
1008         _;
1009     }
1010 
1011     /*
1012     * External functions
1013     */
1014 
1015     /// Returns the initializationAdmin address
1016     function initializationAdmin() public view returns (address) {
1017         return _initializationAdmin;
1018     }
1019 
1020     /// Finalizes the initialization and revokes the initializationAdmin role 
1021     function initializationComplete() external onlyInitializationAdmin {
1022         _initializationAdmin = address(0);
1023         emit InitializationComplete();
1024     }
1025 
1026     /// Checks if the initialization was completed
1027     function isInitializationComplete() public view returns (bool) {
1028         return _initializationAdmin == address(0);
1029     }
1030 
1031 }
1032 
1033 // File: contracts/ContractRegistryAccessor.sol
1034 
1035 pragma solidity 0.6.12;
1036 
1037 
1038 
1039 
1040 
1041 contract ContractRegistryAccessor is IContractRegistryAccessor, WithClaimableRegistryManagement, Initializable {
1042 
1043     IContractRegistry private contractRegistry;
1044 
1045     /// Constructor
1046     /// @param _contractRegistry is the contract registry address
1047     /// @param _registryAdmin is the registry admin address
1048     constructor(IContractRegistry _contractRegistry, address _registryAdmin) public {
1049         require(address(_contractRegistry) != address(0), "_contractRegistry cannot be 0");
1050         setContractRegistry(_contractRegistry);
1051         _transferRegistryManagement(_registryAdmin);
1052     }
1053 
1054     modifier onlyAdmin {
1055         require(isAdmin(), "sender is not an admin (registryManger or initializationAdmin)");
1056 
1057         _;
1058     }
1059 
1060     modifier onlyMigrationManager {
1061         require(isMigrationManager(), "sender is not the migration manager");
1062 
1063         _;
1064     }
1065 
1066     modifier onlyFunctionalManager {
1067         require(isFunctionalManager(), "sender is not the functional manager");
1068 
1069         _;
1070     }
1071 
1072     /// Checks whether the caller is Admin: either the contract registry, the registry admin, or the initialization admin
1073     function isAdmin() internal view returns (bool) {
1074         return msg.sender == address(contractRegistry) || msg.sender == registryAdmin() || msg.sender == initializationAdmin();
1075     }
1076 
1077     /// Checks whether the caller is a specific manager role or and Admin
1078     /// @dev queries the registry contract for the up to date manager assignment
1079     function isManager(string memory role) internal view returns (bool) {
1080         IContractRegistry _contractRegistry = contractRegistry;
1081         return isAdmin() || _contractRegistry != IContractRegistry(0) && contractRegistry.getManager(role) == msg.sender;
1082     }
1083 
1084     /// Checks whether the caller is the migration manager
1085     function isMigrationManager() internal view returns (bool) {
1086         return isManager('migrationManager');
1087     }
1088 
1089     /// Checks whether the caller is the functional manager
1090     function isFunctionalManager() internal view returns (bool) {
1091         return isManager('functionalManager');
1092     }
1093 
1094     /* 
1095      * Contract getters, return the address of a contract by calling the contract registry 
1096      */ 
1097 
1098     function getProtocolContract() internal view returns (address) {
1099         return contractRegistry.getContract("protocol");
1100     }
1101 
1102     function getStakingRewardsContract() internal view returns (address) {
1103         return contractRegistry.getContract("stakingRewards");
1104     }
1105 
1106     function getFeesAndBootstrapRewardsContract() internal view returns (address) {
1107         return contractRegistry.getContract("feesAndBootstrapRewards");
1108     }
1109 
1110     function getCommitteeContract() internal view returns (address) {
1111         return contractRegistry.getContract("committee");
1112     }
1113 
1114     function getElectionsContract() internal view returns (address) {
1115         return contractRegistry.getContract("elections");
1116     }
1117 
1118     function getDelegationsContract() internal view returns (address) {
1119         return contractRegistry.getContract("delegations");
1120     }
1121 
1122     function getGuardiansRegistrationContract() internal view returns (address) {
1123         return contractRegistry.getContract("guardiansRegistration");
1124     }
1125 
1126     function getCertificationContract() internal view returns (address) {
1127         return contractRegistry.getContract("certification");
1128     }
1129 
1130     function getStakingContract() internal view returns (address) {
1131         return contractRegistry.getContract("staking");
1132     }
1133 
1134     function getSubscriptionsContract() internal view returns (address) {
1135         return contractRegistry.getContract("subscriptions");
1136     }
1137 
1138     function getStakingRewardsWallet() internal view returns (address) {
1139         return contractRegistry.getContract("stakingRewardsWallet");
1140     }
1141 
1142     function getBootstrapRewardsWallet() internal view returns (address) {
1143         return contractRegistry.getContract("bootstrapRewardsWallet");
1144     }
1145 
1146     function getGeneralFeesWallet() internal view returns (address) {
1147         return contractRegistry.getContract("generalFeesWallet");
1148     }
1149 
1150     function getCertifiedFeesWallet() internal view returns (address) {
1151         return contractRegistry.getContract("certifiedFeesWallet");
1152     }
1153 
1154     function getStakingContractHandler() internal view returns (address) {
1155         return contractRegistry.getContract("stakingContractHandler");
1156     }
1157 
1158     /*
1159     * Governance functions
1160     */
1161 
1162     event ContractRegistryAddressUpdated(address addr);
1163 
1164     /// Sets the contract registry address
1165     /// @dev governance function called only by an admin
1166     /// @param newContractRegistry is the new registry contract 
1167     function setContractRegistry(IContractRegistry newContractRegistry) public override onlyAdmin {
1168         require(newContractRegistry.getPreviousContractRegistry() == address(contractRegistry), "new contract registry must provide the previous contract registry");
1169         contractRegistry = newContractRegistry;
1170         emit ContractRegistryAddressUpdated(address(newContractRegistry));
1171     }
1172 
1173     /// Returns the contract registry that the contract is set to use
1174     /// @return contractRegistry is the registry contract address
1175     function getContractRegistry() public override view returns (IContractRegistry) {
1176         return contractRegistry;
1177     }
1178 
1179     function setRegistryAdmin(address _registryAdmin) external override onlyInitializationAdmin {
1180         _transferRegistryManagement(_registryAdmin);
1181     }
1182 
1183 }
1184 
1185 // File: contracts/spec_interfaces/ILockable.sol
1186 
1187 pragma solidity 0.6.12;
1188 
1189 /// @title lockable contract interface, allows to lock a contract
1190 interface ILockable {
1191 
1192     event Locked();
1193     event Unlocked();
1194 
1195     /// Locks the contract to external non-governance function calls
1196     /// @dev governance function called only by the migration manager or an admin
1197     /// @dev typically called by the registry contract upon locking all managed contracts
1198     /// @dev getters and migration functions remain active also for locked contracts
1199     /// @dev checked by the onlyWhenActive modifier
1200     function lock() external /* onlyMigrationManager */;
1201 
1202     /// Unlocks the contract 
1203     /// @dev governance function called only by the migration manager or an admin
1204     /// @dev typically called by the registry contract upon unlocking all managed contracts
1205     function unlock() external /* onlyMigrationManager */;
1206 
1207     /// Returns the contract locking status
1208     /// @return isLocked is a bool indicating the contract is locked 
1209     function isLocked() view external returns (bool);
1210 
1211 }
1212 
1213 // File: contracts/Lockable.sol
1214 
1215 pragma solidity 0.6.12;
1216 
1217 
1218 
1219 /// @title lockable contract
1220 contract Lockable is ILockable, ContractRegistryAccessor {
1221 
1222     bool public locked;
1223 
1224     /// Constructor
1225     /// @param _contractRegistry is the contract registry address
1226     /// @param _registryAdmin is the registry admin address
1227     constructor(IContractRegistry _contractRegistry, address _registryAdmin) ContractRegistryAccessor(_contractRegistry, _registryAdmin) public {}
1228 
1229     /// Locks the contract to external non-governance function calls
1230     /// @dev governance function called only by the migration manager or an admin
1231     /// @dev typically called by the registry contract upon locking all managed contracts
1232     /// @dev getters and migration functions remain active also for locked contracts
1233     /// @dev checked by the onlyWhenActive modifier
1234     function lock() external override onlyMigrationManager {
1235         locked = true;
1236         emit Locked();
1237     }
1238 
1239     /// Unlocks the contract 
1240     /// @dev governance function called only by the migration manager or an admin
1241     /// @dev typically called by the registry contract upon unlocking all managed contracts
1242     function unlock() external override onlyMigrationManager {
1243         locked = false;
1244         emit Unlocked();
1245     }
1246 
1247     /// Returns the contract locking status
1248     /// @return isLocked is a bool indicating the contract is locked 
1249     function isLocked() external override view returns (bool) {
1250         return locked;
1251     }
1252 
1253     modifier onlyWhenActive() {
1254         require(!locked, "contract is locked for this operation");
1255 
1256         _;
1257     }
1258 }
1259 
1260 // File: contracts/ManagedContract.sol
1261 
1262 pragma solidity 0.6.12;
1263 
1264 
1265 
1266 /// @title managed contract
1267 contract ManagedContract is IManagedContract, Lockable {
1268 
1269     /// @param _contractRegistry is the contract registry address
1270     /// @param _registryAdmin is the registry admin address
1271     constructor(IContractRegistry _contractRegistry, address _registryAdmin) Lockable(_contractRegistry, _registryAdmin) public {}
1272 
1273     /// Refreshes the address of the other contracts the contract interacts with
1274     /// @dev called by the registry contract upon an update of a contract in the registry
1275     function refreshContracts() virtual override external {}
1276 
1277 }
1278 
1279 // File: contracts/FeesAndBootstrapRewards.sol
1280 
1281 pragma solidity 0.6.12;
1282 
1283 
1284 
1285 
1286 
1287 
1288 
1289 
1290 
1291 
1292 contract FeesAndBootstrapRewards is IFeesAndBootstrapRewards, ManagedContract {
1293     using SafeMath for uint256;
1294     using SafeMath96 for uint96;
1295 
1296     uint256 constant PERCENT_MILLIE_BASE = 100000;
1297     uint256 constant TOKEN_BASE = 1e18;
1298 
1299     struct Settings {
1300         uint96 generalCommitteeAnnualBootstrap;
1301         uint96 certifiedCommitteeAnnualBootstrap;
1302         bool rewardAllocationActive;
1303     }
1304     Settings settings;
1305 
1306     IERC20 public bootstrapToken;
1307     IERC20 public feesToken;
1308 
1309     struct FeesAndBootstrapState {
1310         uint96 certifiedFeesPerMember;
1311         uint96 generalFeesPerMember;
1312         uint96 certifiedBootstrapPerMember;
1313         uint96 generalBootstrapPerMember;
1314         uint32 lastAssigned;
1315     }
1316     FeesAndBootstrapState public feesAndBootstrapState;
1317 
1318     struct FeesAndBootstrap {
1319         uint96 feeBalance;
1320         uint96 bootstrapBalance;
1321         uint96 lastFeesPerMember;
1322         uint96 lastBootstrapPerMember;
1323         uint96 withdrawnFees;
1324         uint96 withdrawnBootstrap;
1325     }
1326     mapping(address => FeesAndBootstrap) public feesAndBootstrap;
1327 
1328     /// Constructor
1329     /// @param _contractRegistry is the contract registry address
1330     /// @param _registryAdmin is the registry admin address
1331     /// @param _feesToken is the token used for virtual chains fees 
1332     /// @param _bootstrapToken is the token used for the bootstrap reward
1333     /// @param generalCommitteeAnnualBootstrap is the general committee annual bootstrap reward
1334     /// @param certifiedCommitteeAnnualBootstrap is the certified committee additional annual bootstrap reward
1335     constructor(
1336         IContractRegistry _contractRegistry,
1337         address _registryAdmin,
1338         IERC20 _feesToken,
1339         IERC20 _bootstrapToken,
1340         uint generalCommitteeAnnualBootstrap,
1341         uint certifiedCommitteeAnnualBootstrap
1342     ) ManagedContract(_contractRegistry, _registryAdmin) public {
1343         require(address(_bootstrapToken) != address(0), "bootstrapToken must not be 0");
1344         require(address(_feesToken) != address(0), "feeToken must not be 0");
1345 
1346         _setGeneralCommitteeAnnualBootstrap(generalCommitteeAnnualBootstrap);
1347         _setCertifiedCommitteeAnnualBootstrap(certifiedCommitteeAnnualBootstrap);
1348 
1349         feesToken = _feesToken;
1350         bootstrapToken = _bootstrapToken;
1351     }
1352 
1353     modifier onlyCommitteeContract() {
1354         require(msg.sender == address(committeeContract), "caller is not the elections contract");
1355 
1356         _;
1357     }
1358 
1359     /*
1360     * External functions
1361     */
1362 
1363     /// Triggers update of the guardian rewards
1364     /// @dev Called by: the Committee contract
1365     /// @dev called upon expected change in the committee membership of the guardian
1366     /// @param guardian is the guardian who's committee membership is updated
1367     /// @param inCommittee indicates whether the guardian is in the committee prior to the change
1368     /// @param isCertified indicates whether the guardian is certified prior to the change
1369     /// @param nextCertification indicates whether after the change, the guardian is certified
1370     /// @param generalCommitteeSize indicates the general committee size prior to the change
1371     /// @param certifiedCommitteeSize indicates the certified committee size prior to the change
1372     function committeeMembershipWillChange(address guardian, bool inCommittee, bool isCertified, bool nextCertification, uint generalCommitteeSize, uint certifiedCommitteeSize) external override onlyWhenActive onlyCommitteeContract {
1373         _updateGuardianFeesAndBootstrap(guardian, inCommittee, isCertified, nextCertification, generalCommitteeSize, certifiedCommitteeSize);
1374     }
1375 
1376     /// Returns the fees and bootstrap balances of a guardian
1377     /// @dev calculates the up to date balances (differ from the state)
1378     /// @return feeBalance the guardian's fees balance
1379     /// @return bootstrapBalance the guardian's bootstrap balance
1380     function getFeesAndBootstrapBalance(address guardian) external override view returns (uint256 feeBalance, uint256 bootstrapBalance) {
1381         (FeesAndBootstrap memory guardianFeesAndBootstrap,) = getGuardianFeesAndBootstrap(guardian, block.timestamp);
1382         return (guardianFeesAndBootstrap.feeBalance, guardianFeesAndBootstrap.bootstrapBalance);
1383     }
1384 
1385     /// Returns an estimation of the fees and bootstrap a guardian will be entitled to for a duration of time
1386     /// The estimation is based on the current system state and there for only provides an estimation
1387     /// @param guardian is the guardian address
1388     /// @param duration is the amount of time in seconds for which the estimation is calculated
1389     /// @return estimatedFees is the estimated received fees for the duration
1390     /// @return estimatedBootstrapRewards is the estimated received bootstrap for the duration
1391     function estimateFutureFeesAndBootstrapRewards(address guardian, uint256 duration) external override view returns (uint256 estimatedFees, uint256 estimatedBootstrapRewards) {
1392         (FeesAndBootstrap memory guardianFeesAndBootstrapNow,) = getGuardianFeesAndBootstrap(guardian, block.timestamp);
1393         (FeesAndBootstrap memory guardianFeesAndBootstrapFuture,) = getGuardianFeesAndBootstrap(guardian, block.timestamp.add(duration));
1394         estimatedFees = guardianFeesAndBootstrapFuture.feeBalance.sub(guardianFeesAndBootstrapNow.feeBalance);
1395         estimatedBootstrapRewards = guardianFeesAndBootstrapFuture.bootstrapBalance.sub(guardianFeesAndBootstrapNow.bootstrapBalance);
1396     }
1397 
1398     /// Transfers the guardian Fees balance to their account
1399     /// @dev One may withdraw for another guardian
1400     /// @param guardian is the guardian address
1401     function withdrawFees(address guardian) external override onlyWhenActive {
1402         updateGuardianFeesAndBootstrap(guardian);
1403 
1404         uint256 amount = feesAndBootstrap[guardian].feeBalance;
1405         feesAndBootstrap[guardian].feeBalance = 0;
1406         uint96 withdrawnFees = feesAndBootstrap[guardian].withdrawnFees.add(amount);
1407         feesAndBootstrap[guardian].withdrawnFees = withdrawnFees;
1408 
1409         emit FeesWithdrawn(guardian, amount, withdrawnFees);
1410         require(feesToken.transfer(guardian, amount), "Rewards::withdrawFees - insufficient funds");
1411     }
1412 
1413     /// Transfers the guardian bootstrap balance to their account
1414     /// @dev One may withdraw for another guardian
1415     /// @param guardian is the guardian address
1416     function withdrawBootstrapFunds(address guardian) external override onlyWhenActive {
1417         updateGuardianFeesAndBootstrap(guardian);
1418         uint256 amount = feesAndBootstrap[guardian].bootstrapBalance;
1419         feesAndBootstrap[guardian].bootstrapBalance = 0;
1420         uint96 withdrawnBootstrap = feesAndBootstrap[guardian].withdrawnBootstrap.add(amount);
1421         feesAndBootstrap[guardian].withdrawnBootstrap = withdrawnBootstrap;
1422         emit BootstrapRewardsWithdrawn(guardian, amount, withdrawnBootstrap);
1423 
1424         require(bootstrapToken.transfer(guardian, amount), "Rewards::withdrawBootstrapFunds - insufficient funds");
1425     }
1426 
1427     /// Returns the current global Fees and Bootstrap rewards state 
1428     /// @dev calculated to the latest block, may differ from the state read
1429     /// @return certifiedFeesPerMember represents the fees a certified committee member from day 0 would have receive
1430     /// @return generalFeesPerMember represents the fees a non-certified committee member from day 0 would have receive
1431     /// @return certifiedBootstrapPerMember represents the bootstrap fund a certified committee member from day 0 would have receive
1432     /// @return generalBootstrapPerMember represents the bootstrap fund a non-certified committee member from day 0 would have receive
1433     /// @return lastAssigned is the time the calculation was done to (typically the latest block time)
1434     function getFeesAndBootstrapState() external override view returns (
1435         uint256 certifiedFeesPerMember,
1436         uint256 generalFeesPerMember,
1437         uint256 certifiedBootstrapPerMember,
1438         uint256 generalBootstrapPerMember,
1439         uint256 lastAssigned
1440     ) {
1441         (uint generalCommitteeSize, uint certifiedCommitteeSize, ) = committeeContract.getCommitteeStats();
1442         (FeesAndBootstrapState memory _feesAndBootstrapState,,) = _getFeesAndBootstrapState(generalCommitteeSize, certifiedCommitteeSize, generalFeesWallet.getOutstandingFees(block.timestamp), certifiedFeesWallet.getOutstandingFees(block.timestamp), block.timestamp, settings);
1443         certifiedFeesPerMember = _feesAndBootstrapState.certifiedFeesPerMember;
1444         generalFeesPerMember = _feesAndBootstrapState.generalFeesPerMember;
1445         certifiedBootstrapPerMember = _feesAndBootstrapState.certifiedBootstrapPerMember;
1446         generalBootstrapPerMember = _feesAndBootstrapState.generalBootstrapPerMember;
1447         lastAssigned = _feesAndBootstrapState.lastAssigned;
1448     }
1449 
1450     /// Returns the current guardian Fees and Bootstrap rewards state 
1451     /// @dev calculated to the latest block, may differ from the state read
1452     /// @return feeBalance is the guardian fees balance 
1453     /// @return lastFeesPerMember is the FeesPerMember on the last update based on the guardian certification state
1454     /// @return bootstrapBalance is the guardian bootstrap balance 
1455     /// @return lastBootstrapPerMember is the FeesPerMember on the last BootstrapPerMember based on the guardian certification state
1456     function getFeesAndBootstrapData(address guardian) external override view returns (
1457         uint256 feeBalance,
1458         uint256 lastFeesPerMember,
1459         uint256 bootstrapBalance,
1460         uint256 lastBootstrapPerMember,
1461         uint256 withdrawnFees,
1462         uint256 withdrawnBootstrap,
1463         bool certified
1464     ) {
1465         FeesAndBootstrap memory guardianFeesAndBootstrap;
1466         (guardianFeesAndBootstrap, certified) = getGuardianFeesAndBootstrap(guardian, block.timestamp);
1467         return (
1468             guardianFeesAndBootstrap.feeBalance,
1469             guardianFeesAndBootstrap.lastFeesPerMember,
1470             guardianFeesAndBootstrap.bootstrapBalance,
1471             guardianFeesAndBootstrap.lastBootstrapPerMember,
1472             guardianFeesAndBootstrap.withdrawnFees,
1473             guardianFeesAndBootstrap.withdrawnBootstrap,
1474             certified
1475         );
1476     }
1477 
1478     /*
1479      * Governance functions
1480      */
1481 
1482     /// Activates fees and bootstrap allocation
1483     /// @dev governance function called only by the initialization admin
1484     /// @dev On migrations, startTime should be set as the previous contract deactivation time.
1485     /// @param startTime sets the last assignment time
1486     function activateRewardDistribution(uint startTime) external override onlyMigrationManager {
1487         require(!settings.rewardAllocationActive, "reward distribution is already activated");
1488 
1489         feesAndBootstrapState.lastAssigned = uint32(startTime);
1490         settings.rewardAllocationActive = true;
1491 
1492         emit RewardDistributionActivated(startTime);
1493     }
1494 
1495     /// Deactivates fees and bootstrap allocation
1496     /// @dev governance function called only by the migration manager
1497     /// @dev guardians updates remain active based on the current perMember value
1498     function deactivateRewardDistribution() external override onlyMigrationManager {
1499         require(settings.rewardAllocationActive, "reward distribution is already deactivated");
1500 
1501         updateFeesAndBootstrapState();
1502 
1503         settings.rewardAllocationActive = false;
1504 
1505         emit RewardDistributionDeactivated();
1506     }
1507 
1508     /// Returns the rewards allocation activation status
1509     /// @return rewardAllocationActive is the activation status
1510     function isRewardAllocationActive() external override view returns (bool) {
1511         return settings.rewardAllocationActive;
1512     }
1513 
1514     /// Sets the annual rate for the general committee bootstrap
1515     /// @dev governance function called only by the functional manager
1516     /// @dev updates the global bootstrap and fees state before updating  
1517     /// @param annualAmount is the annual general committee bootstrap award
1518     function setGeneralCommitteeAnnualBootstrap(uint256 annualAmount) external override onlyFunctionalManager {
1519         updateFeesAndBootstrapState();
1520         _setGeneralCommitteeAnnualBootstrap(annualAmount);
1521     }
1522 
1523     /// Returns the general committee annual bootstrap award
1524     /// @return generalCommitteeAnnualBootstrap is the general committee annual bootstrap
1525     function getGeneralCommitteeAnnualBootstrap() external override view returns (uint256) {
1526         return settings.generalCommitteeAnnualBootstrap;
1527     }
1528 
1529     /// Sets the annual rate for the certified committee bootstrap
1530     /// @dev governance function called only by the functional manager
1531     /// @dev updates the global bootstrap and fees state before updating  
1532     /// @param annualAmount is the annual certified committee bootstrap award
1533     function setCertifiedCommitteeAnnualBootstrap(uint256 annualAmount) external override onlyFunctionalManager {
1534         updateFeesAndBootstrapState();
1535         _setCertifiedCommitteeAnnualBootstrap(annualAmount);
1536     }
1537 
1538     /// Returns the certified committee annual bootstrap reward
1539     /// @return certifiedCommitteeAnnualBootstrap is the certified committee additional annual bootstrap
1540     function getCertifiedCommitteeAnnualBootstrap() external override view returns (uint256) {
1541         return settings.certifiedCommitteeAnnualBootstrap;
1542     }
1543 
1544     /// Migrates the rewards balance to a new FeesAndBootstrap contract
1545     /// @dev The new rewards contract is determined according to the contracts registry
1546     /// @dev No impact of the calling contract if the currently configured contract in the registry
1547     /// @dev may be called also while the contract is locked
1548     /// @param guardians is the list of guardians to migrate
1549     function migrateRewardsBalance(address[] calldata guardians) external override {
1550         require(!settings.rewardAllocationActive, "Reward distribution must be deactivated for migration");
1551 
1552         IFeesAndBootstrapRewards currentRewardsContract = IFeesAndBootstrapRewards(getFeesAndBootstrapRewardsContract());
1553         require(address(currentRewardsContract) != address(this), "New rewards contract is not set");
1554 
1555         uint256 totalFees = 0;
1556         uint256 totalBootstrap = 0;
1557         uint256[] memory fees = new uint256[](guardians.length);
1558         uint256[] memory bootstrap = new uint256[](guardians.length);
1559 
1560         for (uint i = 0; i < guardians.length; i++) {
1561             updateGuardianFeesAndBootstrap(guardians[i]);
1562 
1563             FeesAndBootstrap memory guardianFeesAndBootstrap = feesAndBootstrap[guardians[i]];
1564             fees[i] = guardianFeesAndBootstrap.feeBalance;
1565             totalFees = totalFees.add(fees[i]);
1566             bootstrap[i] = guardianFeesAndBootstrap.bootstrapBalance;
1567             totalBootstrap = totalBootstrap.add(bootstrap[i]);
1568 
1569             guardianFeesAndBootstrap.feeBalance = 0;
1570             guardianFeesAndBootstrap.bootstrapBalance = 0;
1571             feesAndBootstrap[guardians[i]] = guardianFeesAndBootstrap;
1572         }
1573 
1574         require(feesToken.approve(address(currentRewardsContract), totalFees), "migrateRewardsBalance: approve failed");
1575         require(bootstrapToken.approve(address(currentRewardsContract), totalBootstrap), "migrateRewardsBalance: approve failed");
1576         currentRewardsContract.acceptRewardsBalanceMigration(guardians, fees, totalFees, bootstrap, totalBootstrap);
1577 
1578         for (uint i = 0; i < guardians.length; i++) {
1579             emit FeesAndBootstrapRewardsBalanceMigrated(guardians[i], fees[i], bootstrap[i], address(currentRewardsContract));
1580         }
1581     }
1582 
1583     /// Accepts guardian's balance migration from a previous rewards contract
1584     /// @dev the function may be called by any caller that approves the amounts provided for transfer
1585     /// @param guardians is the list of migrated guardians
1586     /// @param fees is the list of received guardian fees balance
1587     /// @param totalFees is the total amount of fees migrated for all guardians in the list. Must match the sum of the fees list.
1588     /// @param bootstrap is the list of received guardian bootstrap balance.
1589     /// @param totalBootstrap is the total amount of bootstrap rewards migrated for all guardians in the list. Must match the sum of the bootstrap list.
1590     function acceptRewardsBalanceMigration(address[] memory guardians, uint256[] memory fees, uint256 totalFees, uint256[] memory bootstrap, uint256 totalBootstrap) external override {
1591         uint256 _totalFees = 0;
1592         uint256 _totalBootstrap = 0;
1593 
1594         for (uint i = 0; i < guardians.length; i++) {
1595             _totalFees = _totalFees.add(fees[i]);
1596             _totalBootstrap = _totalBootstrap.add(bootstrap[i]);
1597         }
1598 
1599         require(totalFees == _totalFees, "totalFees does not match fees sum");
1600         require(totalBootstrap == _totalBootstrap, "totalBootstrap does not match bootstrap sum");
1601 
1602         if (totalFees > 0) {
1603             require(feesToken.transferFrom(msg.sender, address(this), totalFees), "acceptRewardBalanceMigration: transfer failed");
1604         }
1605         if (totalBootstrap > 0) {
1606             require(bootstrapToken.transferFrom(msg.sender, address(this), totalBootstrap), "acceptRewardBalanceMigration: transfer failed");
1607         }
1608 
1609         FeesAndBootstrap memory guardianFeesAndBootstrap;
1610         for (uint i = 0; i < guardians.length; i++) {
1611             guardianFeesAndBootstrap = feesAndBootstrap[guardians[i]];
1612             guardianFeesAndBootstrap.feeBalance = guardianFeesAndBootstrap.feeBalance.add(fees[i]);
1613             guardianFeesAndBootstrap.bootstrapBalance = guardianFeesAndBootstrap.bootstrapBalance.add(bootstrap[i]);
1614             feesAndBootstrap[guardians[i]] = guardianFeesAndBootstrap;
1615 
1616             emit FeesAndBootstrapRewardsBalanceMigrationAccepted(msg.sender, guardians[i], fees[i], bootstrap[i]);
1617         }
1618     }
1619 
1620     /// Performs emergency withdrawal of the contract balance
1621     /// @dev called with a token to withdraw, should be called twice with the fees and bootstrap tokens
1622     /// @dev governance function called only by the migration manager
1623     /// @param erc20 is the ERC20 token to withdraw
1624     function emergencyWithdraw(address erc20) external override onlyMigrationManager {
1625         IERC20 _token = IERC20(erc20);
1626         emit EmergencyWithdrawal(msg.sender, address(_token));
1627         require(_token.transfer(msg.sender, _token.balanceOf(address(this))), "Rewards::emergencyWithdraw - transfer failed");
1628     }
1629 
1630     /// Returns the contract's settings
1631     /// @return generalCommitteeAnnualBootstrap is the general committee annual bootstrap
1632     /// @return certifiedCommitteeAnnualBootstrap is the certified committee additional annual bootstrap
1633     /// @return rewardAllocationActive indicates the rewards allocation activation state 
1634     function getSettings() external override view returns (
1635         uint generalCommitteeAnnualBootstrap,
1636         uint certifiedCommitteeAnnualBootstrap,
1637         bool rewardAllocationActive
1638     ) {
1639         Settings memory _settings = settings;
1640         generalCommitteeAnnualBootstrap = _settings.generalCommitteeAnnualBootstrap;
1641         certifiedCommitteeAnnualBootstrap = _settings.certifiedCommitteeAnnualBootstrap;
1642         rewardAllocationActive = _settings.rewardAllocationActive;
1643     }
1644 
1645     /*
1646     * Private functions
1647     */
1648 
1649     // Global state
1650 
1651     /// Returns the current global Fees and Bootstrap rewards state 
1652     /// @dev receives the relevant committee and general state data
1653     /// @param generalCommitteeSize is the current number of members in the certified committee
1654     /// @param certifiedCommitteeSize is the current number of members in the general committee
1655     /// @param collectedGeneralFees is the amount of fees collected from general virtual chains for the calculated period
1656     /// @param collectedCertifiedFees is the amount of fees collected from general virtual chains for the calculated period
1657     /// @param currentTime is the time to calculate the fees and bootstrap for
1658     /// @param _settings is the contract settings
1659     function _getFeesAndBootstrapState(uint generalCommitteeSize, uint certifiedCommitteeSize, uint256 collectedGeneralFees, uint256 collectedCertifiedFees, uint256 currentTime, Settings memory _settings) private view returns (FeesAndBootstrapState memory _feesAndBootstrapState, uint256 allocatedGeneralBootstrap, uint256 allocatedCertifiedBootstrap) {
1660         _feesAndBootstrapState = feesAndBootstrapState;
1661 
1662         if (_settings.rewardAllocationActive) {
1663             uint256 generalFeesDelta = generalCommitteeSize == 0 ? 0 : collectedGeneralFees.div(generalCommitteeSize);
1664             uint256 certifiedFeesDelta = certifiedCommitteeSize == 0 ? 0 : generalFeesDelta.add(collectedCertifiedFees.div(certifiedCommitteeSize));
1665 
1666             _feesAndBootstrapState.generalFeesPerMember = _feesAndBootstrapState.generalFeesPerMember.add(generalFeesDelta);
1667             _feesAndBootstrapState.certifiedFeesPerMember = _feesAndBootstrapState.certifiedFeesPerMember.add(certifiedFeesDelta);
1668 
1669             uint duration = currentTime.sub(_feesAndBootstrapState.lastAssigned);
1670             uint256 generalBootstrapDelta = uint256(_settings.generalCommitteeAnnualBootstrap).mul(duration).div(365 days);
1671             uint256 certifiedBootstrapDelta = generalBootstrapDelta.add(uint256(_settings.certifiedCommitteeAnnualBootstrap).mul(duration).div(365 days));
1672 
1673             _feesAndBootstrapState.generalBootstrapPerMember = _feesAndBootstrapState.generalBootstrapPerMember.add(generalBootstrapDelta);
1674             _feesAndBootstrapState.certifiedBootstrapPerMember = _feesAndBootstrapState.certifiedBootstrapPerMember.add(certifiedBootstrapDelta);
1675             _feesAndBootstrapState.lastAssigned = uint32(currentTime);
1676 
1677             allocatedGeneralBootstrap = generalBootstrapDelta.mul(generalCommitteeSize);
1678             allocatedCertifiedBootstrap = certifiedBootstrapDelta.mul(certifiedCommitteeSize);
1679         }
1680     }
1681 
1682     /// Updates the global Fees and Bootstrap rewards state
1683     /// @dev utilizes _getFeesAndBootstrapState to calculate the global state 
1684     /// @param generalCommitteeSize is the current number of members in the certified committee
1685     /// @param certifiedCommitteeSize is the current number of members in the general committee
1686     /// @return _feesAndBootstrapState is a FeesAndBootstrapState struct with the updated state
1687     function _updateFeesAndBootstrapState(uint generalCommitteeSize, uint certifiedCommitteeSize) private returns (FeesAndBootstrapState memory _feesAndBootstrapState) {
1688         Settings memory _settings = settings;
1689         if (!_settings.rewardAllocationActive) {
1690             return feesAndBootstrapState;
1691         }
1692 
1693         uint256 collectedGeneralFees = generalFeesWallet.collectFees();
1694         uint256 collectedCertifiedFees = certifiedFeesWallet.collectFees();
1695         uint256 allocatedGeneralBootstrap;
1696         uint256 allocatedCertifiedBootstrap;
1697 
1698         (_feesAndBootstrapState, allocatedGeneralBootstrap, allocatedCertifiedBootstrap) = _getFeesAndBootstrapState(generalCommitteeSize, certifiedCommitteeSize, collectedGeneralFees, collectedCertifiedFees, block.timestamp, _settings);
1699         bootstrapRewardsWallet.withdraw(allocatedGeneralBootstrap.add(allocatedCertifiedBootstrap));
1700 
1701         feesAndBootstrapState = _feesAndBootstrapState;
1702 
1703         emit FeesAllocated(collectedGeneralFees, _feesAndBootstrapState.generalFeesPerMember, collectedCertifiedFees, _feesAndBootstrapState.certifiedFeesPerMember);
1704         emit BootstrapRewardsAllocated(allocatedGeneralBootstrap, _feesAndBootstrapState.generalBootstrapPerMember, allocatedCertifiedBootstrap, _feesAndBootstrapState.certifiedBootstrapPerMember);
1705     }
1706 
1707     /// Updates the global Fees and Bootstrap rewards state
1708     /// @dev utilizes _updateFeesAndBootstrapState
1709     /// @return _feesAndBootstrapState is a FeesAndBootstrapState struct with the updated state
1710     function updateFeesAndBootstrapState() private returns (FeesAndBootstrapState memory _feesAndBootstrapState) {
1711         (uint generalCommitteeSize, uint certifiedCommitteeSize, ) = committeeContract.getCommitteeStats();
1712         return _updateFeesAndBootstrapState(generalCommitteeSize, certifiedCommitteeSize);
1713     }
1714 
1715     // Guardian state
1716 
1717     /// Returns the current guardian Fees and Bootstrap rewards state 
1718     /// @dev receives the relevant guardian committee membership data and the global state
1719     /// @param guardian is the guardian to query
1720     /// @param inCommittee indicates whether the guardian is currently in the committee
1721     /// @param isCertified indicates whether the guardian is currently certified
1722     /// @param nextCertification indicates whether after the change, the guardian is certified
1723     /// @param _feesAndBootstrapState is the current updated global fees and bootstrap state
1724     /// @return guardianFeesAndBootstrap is a struct with the guardian updated fees and bootstrap state
1725     /// @return addedBootstrapAmount is the amount added to the guardian bootstrap balance
1726     /// @return addedFeesAmount is the amount added to the guardian fees balance
1727     function _getGuardianFeesAndBootstrap(address guardian, bool inCommittee, bool isCertified, bool nextCertification, FeesAndBootstrapState memory _feesAndBootstrapState) private view returns (FeesAndBootstrap memory guardianFeesAndBootstrap, uint256 addedBootstrapAmount, uint256 addedFeesAmount) {
1728         guardianFeesAndBootstrap = feesAndBootstrap[guardian];
1729 
1730         if (inCommittee) {
1731             addedBootstrapAmount = (isCertified ? _feesAndBootstrapState.certifiedBootstrapPerMember : _feesAndBootstrapState.generalBootstrapPerMember).sub(guardianFeesAndBootstrap.lastBootstrapPerMember);
1732             guardianFeesAndBootstrap.bootstrapBalance = guardianFeesAndBootstrap.bootstrapBalance.add(addedBootstrapAmount);
1733 
1734             addedFeesAmount = (isCertified ? _feesAndBootstrapState.certifiedFeesPerMember : _feesAndBootstrapState.generalFeesPerMember).sub(guardianFeesAndBootstrap.lastFeesPerMember);
1735             guardianFeesAndBootstrap.feeBalance = guardianFeesAndBootstrap.feeBalance.add(addedFeesAmount);
1736         }
1737 
1738         guardianFeesAndBootstrap.lastBootstrapPerMember = nextCertification ?  _feesAndBootstrapState.certifiedBootstrapPerMember : _feesAndBootstrapState.generalBootstrapPerMember;
1739         guardianFeesAndBootstrap.lastFeesPerMember = nextCertification ?  _feesAndBootstrapState.certifiedFeesPerMember : _feesAndBootstrapState.generalFeesPerMember;
1740     }
1741 
1742     /// Updates a guardian Fees and Bootstrap rewards state
1743     /// @dev receives the relevant guardian committee membership data
1744     /// @dev updates the global Fees and Bootstrap state prior to calculating the guardian's
1745     /// @dev utilizes _getGuardianFeesAndBootstrap
1746     /// @param guardian is the guardian to update
1747     /// @param inCommittee indicates whether the guardian is currently in the committee
1748     /// @param isCertified indicates whether the guardian is currently certified
1749     /// @param nextCertification indicates whether after the change, the guardian is certified
1750     /// @param generalCommitteeSize indicates the general committee size prior to the change
1751     /// @param certifiedCommitteeSize indicates the certified committee size prior to the change
1752     function _updateGuardianFeesAndBootstrap(address guardian, bool inCommittee, bool isCertified, bool nextCertification, uint generalCommitteeSize, uint certifiedCommitteeSize) private {
1753         uint256 addedBootstrapAmount;
1754         uint256 addedFeesAmount;
1755 
1756         FeesAndBootstrapState memory _feesAndBootstrapState = _updateFeesAndBootstrapState(generalCommitteeSize, certifiedCommitteeSize);
1757         FeesAndBootstrap memory guardianFeesAndBootstrap;
1758         (guardianFeesAndBootstrap, addedBootstrapAmount, addedFeesAmount) = _getGuardianFeesAndBootstrap(guardian, inCommittee, isCertified, nextCertification, _feesAndBootstrapState);
1759         feesAndBootstrap[guardian] = guardianFeesAndBootstrap;
1760 
1761         emit BootstrapRewardsAssigned(guardian, addedBootstrapAmount, guardianFeesAndBootstrap.withdrawnBootstrap.add(guardianFeesAndBootstrap.bootstrapBalance), isCertified, guardianFeesAndBootstrap.lastBootstrapPerMember);
1762         emit FeesAssigned(guardian, addedFeesAmount, guardianFeesAndBootstrap.withdrawnFees.add(guardianFeesAndBootstrap.feeBalance), isCertified, guardianFeesAndBootstrap.lastFeesPerMember);
1763     }
1764 
1765     /// Returns the guardian Fees and Bootstrap rewards state for a given time
1766     /// @dev if the time to estimate is in the future, estimates the fees and rewards for the given time
1767     /// @dev for future time estimation assumes no change in the guardian committee membership and certification
1768     /// @param guardian is the guardian to query
1769     /// @param currentTime is the time to calculate the fees and bootstrap for
1770     /// @return guardianFeesAndBootstrap is a struct with the guardian updated fees and bootstrap state
1771     /// @return certified is the guardian certification status
1772     function getGuardianFeesAndBootstrap(address guardian, uint256 currentTime) private view returns (FeesAndBootstrap memory guardianFeesAndBootstrap, bool certified) {
1773         ICommittee _committeeContract = committeeContract;
1774         (uint generalCommitteeSize, uint certifiedCommitteeSize, ) = _committeeContract.getCommitteeStats();
1775         (FeesAndBootstrapState memory _feesAndBootstrapState,,) = _getFeesAndBootstrapState(generalCommitteeSize, certifiedCommitteeSize, generalFeesWallet.getOutstandingFees(currentTime), certifiedFeesWallet.getOutstandingFees(currentTime), currentTime, settings);
1776         bool inCommittee;
1777         (inCommittee, , certified,) = _committeeContract.getMemberInfo(guardian);
1778         (guardianFeesAndBootstrap, ,) = _getGuardianFeesAndBootstrap(guardian, inCommittee, certified, certified, _feesAndBootstrapState);
1779     }
1780 
1781     /// Updates a guardian Fees and Bootstrap rewards state
1782     /// @dev query the relevant guardian and committee data from the committee contract
1783     /// @dev utilizes _updateGuardianFeesAndBootstrap
1784     /// @param guardian is the guardian to update
1785     function updateGuardianFeesAndBootstrap(address guardian) private {
1786         ICommittee _committeeContract = committeeContract;
1787         (uint generalCommitteeSize, uint certifiedCommitteeSize, ) = _committeeContract.getCommitteeStats();
1788         (bool inCommittee, , bool isCertified,) = _committeeContract.getMemberInfo(guardian);
1789         _updateGuardianFeesAndBootstrap(guardian, inCommittee, isCertified, isCertified, generalCommitteeSize, certifiedCommitteeSize);
1790     }
1791 
1792     // Governance and misc.
1793 
1794     /// Sets the annual rate for the general committee bootstrap
1795     /// @param annualAmount is the annual general committee bootstrap award
1796     function _setGeneralCommitteeAnnualBootstrap(uint256 annualAmount) private {
1797         require(uint256(uint96(annualAmount)) == annualAmount, "annualAmount must fit in uint96");
1798 
1799         settings.generalCommitteeAnnualBootstrap = uint96(annualAmount);
1800         emit GeneralCommitteeAnnualBootstrapChanged(annualAmount);
1801     }
1802 
1803     /// Sets the annual rate for the certified committee bootstrap
1804     /// @param annualAmount is the annual certified committee bootstrap award
1805     function _setCertifiedCommitteeAnnualBootstrap(uint256 annualAmount) private {
1806         require(uint256(uint96(annualAmount)) == annualAmount, "annualAmount must fit in uint96");
1807 
1808         settings.certifiedCommitteeAnnualBootstrap = uint96(annualAmount);
1809         emit CertifiedCommitteeAnnualBootstrapChanged(annualAmount);
1810     }
1811 
1812     /*
1813      * Contracts topology / registry interface
1814      */
1815 
1816     ICommittee committeeContract;
1817     IFeesWallet generalFeesWallet;
1818     IFeesWallet certifiedFeesWallet;
1819     IProtocolWallet bootstrapRewardsWallet;
1820 
1821     /// Refreshes the address of the other contracts the contract interacts with
1822     /// @dev called by the registry contract upon an update of a contract in the registry
1823     function refreshContracts() external override {
1824         committeeContract = ICommittee(getCommitteeContract());
1825         generalFeesWallet = IFeesWallet(getGeneralFeesWallet());
1826         certifiedFeesWallet = IFeesWallet(getCertifiedFeesWallet());
1827         bootstrapRewardsWallet = IProtocolWallet(getBootstrapRewardsWallet());
1828     }
1829 }