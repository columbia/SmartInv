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
507 // File: contracts/spec_interfaces/IStakingRewards.sol
508 
509 pragma solidity 0.6.12;
510 
511 /// @title Staking rewards contract interface
512 interface IStakingRewards {
513 
514     event DelegatorStakingRewardsAssigned(address indexed delegator, uint256 amount, uint256 totalAwarded, address guardian, uint256 delegatorRewardsPerToken, uint256 delegatorRewardsPerTokenDelta);
515     event GuardianStakingRewardsAssigned(address indexed guardian, uint256 amount, uint256 totalAwarded, uint256 delegatorRewardsPerToken, uint256 delegatorRewardsPerTokenDelta, uint256 stakingRewardsPerWeight, uint256 stakingRewardsPerWeightDelta);
516     event StakingRewardsClaimed(address indexed addr, uint256 claimedDelegatorRewards, uint256 claimedGuardianRewards, uint256 totalClaimedDelegatorRewards, uint256 totalClaimedGuardianRewards);
517     event StakingRewardsAllocated(uint256 allocatedRewards, uint256 stakingRewardsPerWeight);
518     event GuardianDelegatorsStakingRewardsPercentMilleUpdated(address indexed guardian, uint256 delegatorsStakingRewardsPercentMille);
519 
520     /*
521      * External functions
522      */
523 
524     /// Returns the current reward balance of the given address.
525     /// @dev calculates the up to date balances (differ from the state)
526     /// @param addr is the address to query
527     /// @return delegatorStakingRewardsBalance the rewards awarded to the guardian role
528     /// @return guardianStakingRewardsBalance the rewards awarded to the guardian role
529     function getStakingRewardsBalance(address addr) external view returns (uint256 delegatorStakingRewardsBalance, uint256 guardianStakingRewardsBalance);
530 
531     /// Claims the staking rewards balance of an addr, staking the rewards
532     /// @dev Claimed rewards are staked in the staking contract using the distributeRewards interface
533     /// @dev includes the rewards for both the delegator and guardian roles
534     /// @dev calculates the up to date rewards prior to distribute them to the staking contract
535     /// @param addr is the address to claim rewards for
536     function claimStakingRewards(address addr) external;
537 
538     /// Returns the current global staking rewards state
539     /// @dev calculated to the latest block, may differ from the state read
540     /// @return stakingRewardsPerWeight is the potential reward per 1E18 (TOKEN_BASE) committee weight assigned to a guardian was in the committee from day zero
541     /// @return unclaimedStakingRewards is the of tokens that were assigned to participants and not claimed yet
542     function getStakingRewardsState() external view returns (
543         uint96 stakingRewardsPerWeight,
544         uint96 unclaimedStakingRewards
545     );
546 
547     /// Returns the current guardian staking rewards state
548     /// @dev calculated to the latest block, may differ from the state read
549     /// @dev notice that the guardian rewards are the rewards for the guardian role as guardian and do not include delegation rewards
550     /// @dev use getDelegatorStakingRewardsData to get the guardian's rewards as delegator
551     /// @param guardian is the guardian to query
552     /// @return balance is the staking rewards balance for the guardian role
553     /// @return claimed is the staking rewards for the guardian role that were claimed
554     /// @return delegatorRewardsPerToken is the potential reward per token (1E18 units) assigned to a guardian's delegator that delegated from day zero
555     /// @return delegatorRewardsPerTokenDelta is the increment in delegatorRewardsPerToken since the last guardian update
556     /// @return lastStakingRewardsPerWeight is the up to date stakingRewardsPerWeight used for the guardian state calculation
557     /// @return stakingRewardsPerWeightDelta is the increment in stakingRewardsPerWeight since the last guardian update
558     function getGuardianStakingRewardsData(address guardian) external view returns (
559         uint256 balance,
560         uint256 claimed,
561         uint256 delegatorRewardsPerToken,
562         uint256 delegatorRewardsPerTokenDelta,
563         uint256 lastStakingRewardsPerWeight,
564         uint256 stakingRewardsPerWeightDelta
565     );
566 
567     /// Returns the current delegator staking rewards state
568     /// @dev calculated to the latest block, may differ from the state read
569     /// @param delegator is the delegator to query
570     /// @return balance is the staking rewards balance for the delegator role
571     /// @return claimed is the staking rewards for the delegator role that were claimed
572     /// @return guardian is the guardian the delegator delegated to receiving a portion of the guardian staking rewards
573     /// @return lastDelegatorRewardsPerToken is the up to date delegatorRewardsPerToken used for the delegator state calculation
574     /// @return delegatorRewardsPerTokenDelta is the increment in delegatorRewardsPerToken since the last delegator update
575     function getDelegatorStakingRewardsData(address delegator) external view returns (
576         uint256 balance,
577         uint256 claimed,
578         address guardian,
579         uint256 lastDelegatorRewardsPerToken,
580         uint256 delegatorRewardsPerTokenDelta
581     );
582 
583     /// Returns an estimation for the delegator and guardian staking rewards for a given duration
584     /// @dev the returned value is an estimation, assuming no change in the PoS state
585     /// @dev the period calculated for start from the current block time until the current time + duration.
586     /// @param addr is the address to estimate rewards for
587     /// @param duration is the duration to calculate for in seconds
588     /// @return estimatedDelegatorStakingRewards is the estimated reward for the delegator role
589     /// @return estimatedGuardianStakingRewards is the estimated reward for the guardian role
590     function estimateFutureRewards(address addr, uint256 duration) external view returns (
591         uint256 estimatedDelegatorStakingRewards,
592         uint256 estimatedGuardianStakingRewards
593     );
594 
595     /// Sets the guardian's delegators staking reward portion
596     /// @dev by default uses the defaultDelegatorsStakingRewardsPercentMille
597     /// @param delegatorRewardsPercentMille is the delegators portion in percent-mille (0 - maxDelegatorsStakingRewardsPercentMille)
598     function setGuardianDelegatorsStakingRewardsPercentMille(uint32 delegatorRewardsPercentMille) external;
599 
600     /// Returns a guardian's delegators staking reward portion
601     /// @dev If not explicitly set, returns the defaultDelegatorsStakingRewardsPercentMille
602     /// @return delegatorRewardsRatioPercentMille is the delegators portion in percent-mille
603     function getGuardianDelegatorsStakingRewardsPercentMille(address guardian) external view returns (uint256 delegatorRewardsRatioPercentMille);
604 
605     /// Returns the amount of ORBS tokens in the staking rewards wallet allocated to staking rewards
606     /// @dev The staking wallet balance must always larger than the allocated value
607     /// @return allocated is the amount of tokens allocated in the staking rewards wallet
608     function getStakingRewardsWalletAllocatedTokens() external view returns (uint256 allocated);
609 
610     /// Returns the current annual staking reward rate
611     /// @dev calculated based on the current total committee weight
612     /// @return annualRate is the current staking reward rate in percent-mille
613     function getCurrentStakingRewardsRatePercentMille() external view returns (uint256 annualRate);
614 
615     /// Notifies an expected change in the committee membership of the guardian
616     /// @dev Called only by: the Committee contract
617     /// @dev called upon expected change in the committee membership of the guardian
618     /// @dev triggers update of the global rewards state and the guardian rewards state
619     /// @dev updates the rewards state based on the committee state prior to the change
620     /// @param guardian is the guardian who's committee membership is updated
621     /// @param weight is the weight of the guardian prior to the change
622     /// @param totalCommitteeWeight is the total committee weight prior to the change
623     /// @param inCommittee indicates whether the guardian was in the committee prior to the change
624     /// @param inCommitteeAfter indicates whether the guardian is in the committee after the change
625     function committeeMembershipWillChange(address guardian, uint256 weight, uint256 totalCommitteeWeight, bool inCommittee, bool inCommitteeAfter) external /* onlyCommitteeContract */;
626 
627     /// Notifies an expected change in a delegator and his guardian delegation state
628     /// @dev Called only by: the Delegation contract
629     /// @dev called upon expected change in a delegator's delegation state
630     /// @dev triggers update of the global rewards state, the guardian rewards state and the delegator rewards state
631     /// @dev on delegation change, updates also the new guardian and the delegator's lastDelegatorRewardsPerToken accordingly
632     /// @param guardian is the delegator's guardian prior to the change
633     /// @param guardianDelegatedStake is the delegated stake of the delegator's guardian prior to the change
634     /// @param delegator is the delegator about to change delegation state
635     /// @param delegatorStake is the stake of the delegator
636     /// @param nextGuardian is the delegator's guardian after to the change
637     /// @param nextGuardianDelegatedStake is the delegated stake of the delegator's guardian after to the change
638     function delegationWillChange(address guardian, uint256 guardianDelegatedStake, address delegator, uint256 delegatorStake, address nextGuardian, uint256 nextGuardianDelegatedStake) external /* onlyDelegationsContract */;
639 
640     /*
641      * Governance functions
642      */
643 
644     event AnnualStakingRewardsRateChanged(uint256 annualRateInPercentMille, uint256 annualCap);
645     event DefaultDelegatorsStakingRewardsChanged(uint32 defaultDelegatorsStakingRewardsPercentMille);
646     event MaxDelegatorsStakingRewardsChanged(uint32 maxDelegatorsStakingRewardsPercentMille);
647     event RewardDistributionActivated(uint256 startTime);
648     event RewardDistributionDeactivated();
649     event StakingRewardsBalanceMigrated(address indexed addr, uint256 guardianStakingRewards, uint256 delegatorStakingRewards, address toRewardsContract);
650     event StakingRewardsBalanceMigrationAccepted(address from, address indexed addr, uint256 guardianStakingRewards, uint256 delegatorStakingRewards);
651     event EmergencyWithdrawal(address addr, address token);
652 
653     /// Activates staking rewards allocation
654     /// @dev governance function called only by the initialization admin
655     /// @dev On migrations, startTime should be set to the previous contract deactivation time
656     /// @param startTime sets the last assignment time
657     function activateRewardDistribution(uint startTime) external /* onlyInitializationAdmin */;
658 
659     /// Deactivates fees and bootstrap allocation
660     /// @dev governance function called only by the migration manager
661     /// @dev guardians updates remain active based on the current perMember value
662     function deactivateRewardDistribution() external /* onlyMigrationManager */;
663     
664     /// Sets the default delegators staking reward portion
665     /// @dev governance function called only by the functional manager
666     /// @param defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille(0 - maxDelegatorsStakingRewardsPercentMille)
667     function setDefaultDelegatorsStakingRewardsPercentMille(uint32 defaultDelegatorsStakingRewardsPercentMille) external /* onlyFunctionalManager */;
668 
669     /// Returns the default delegators staking reward portion
670     /// @return defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille
671     function getDefaultDelegatorsStakingRewardsPercentMille() external view returns (uint32);
672 
673     /// Sets the maximum delegators staking reward portion
674     /// @dev governance function called only by the functional manager
675     /// @param maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille(0 - 100,000)
676     function setMaxDelegatorsStakingRewardsPercentMille(uint32 maxDelegatorsStakingRewardsPercentMille) external /* onlyFunctionalManager */;
677 
678     /// Returns the default delegators staking reward portion
679     /// @return maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille
680     function getMaxDelegatorsStakingRewardsPercentMille() external view returns (uint32);
681 
682     /// Sets the annual rate and cap for the staking reward
683     /// @dev governance function called only by the functional manager
684     /// @param annualRateInPercentMille is the annual rate in percent-mille
685     /// @param annualCap is the annual staking rewards cap
686     function setAnnualStakingRewardsRate(uint32 annualRateInPercentMille, uint96 annualCap) external /* onlyFunctionalManager */;
687 
688     /// Returns the annual staking reward rate
689     /// @return annualStakingRewardsRatePercentMille is the annual rate in percent-mille
690     function getAnnualStakingRewardsRatePercentMille() external view returns (uint32);
691 
692     /// Returns the annual staking rewards cap
693     /// @return annualStakingRewardsCap is the annual rate in percent-mille
694     function getAnnualStakingRewardsCap() external view returns (uint256);
695 
696     /// Checks if rewards allocation is active
697     /// @return rewardAllocationActive is a bool that indicates that rewards allocation is active
698     function isRewardAllocationActive() external view returns (bool);
699 
700     /// Returns the contract's settings
701     /// @return annualStakingRewardsCap is the annual rate in percent-mille
702     /// @return annualStakingRewardsRatePercentMille is the annual rate in percent-mille
703     /// @return defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille
704     /// @return maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille
705     /// @return rewardAllocationActive is a bool that indicates that rewards allocation is active
706     function getSettings() external view returns (
707         uint annualStakingRewardsCap,
708         uint32 annualStakingRewardsRatePercentMille,
709         uint32 defaultDelegatorsStakingRewardsPercentMille,
710         uint32 maxDelegatorsStakingRewardsPercentMille,
711         bool rewardAllocationActive
712     );
713 
714     /// Migrates the staking rewards balance of the given addresses to a new staking rewards contract
715     /// @dev The new rewards contract is determined according to the contracts registry
716     /// @dev No impact of the calling contract if the currently configured contract in the registry
717     /// @dev may be called also while the contract is locked
718     /// @param addrs is the list of addresses to migrate
719     function migrateRewardsBalance(address[] calldata addrs) external;
720 
721     /// Accepts addresses balance migration from a previous rewards contract
722     /// @dev the function may be called by any caller that approves the amounts provided for transfer
723     /// @param addrs is the list migrated addresses
724     /// @param migratedGuardianStakingRewards is the list of received guardian rewards balance for each address
725     /// @param migratedDelegatorStakingRewards is the list of received delegator rewards balance for each address
726     /// @param totalAmount is the total amount of staking rewards migrated for all addresses in the list. Must match the sum of migratedGuardianStakingRewards and migratedDelegatorStakingRewards lists.
727     function acceptRewardsBalanceMigration(address[] calldata addrs, uint256[] calldata migratedGuardianStakingRewards, uint256[] calldata migratedDelegatorStakingRewards, uint256 totalAmount) external;
728 
729     /// Performs emergency withdrawal of the contract balance
730     /// @dev called with a token to withdraw, should be called twice with the fees and bootstrap tokens
731     /// @dev governance function called only by the migration manager
732     /// @param erc20 is the ERC20 token to withdraw
733     function emergencyWithdraw(address erc20) external /* onlyMigrationManager */;
734 }
735 
736 // File: contracts/spec_interfaces/IDelegations.sol
737 
738 pragma solidity 0.6.12;
739 
740 /// @title Delegations contract interface
741 interface IDelegations /* is IStakeChangeNotifier */ {
742 
743     // Delegation state change events
744 	event DelegatedStakeChanged(address indexed addr, uint256 selfDelegatedStake, uint256 delegatedStake, address indexed delegator, uint256 delegatorContributedStake);
745 
746     // Function calls
747 	event Delegated(address indexed from, address indexed to);
748 
749 	/*
750      * External functions
751      */
752 
753     /// Delegate your stake
754     /// @dev updates the election contract on the changes in the delegated stake
755     /// @dev updates the rewards contract on the upcoming change in the delegator's delegation state
756     /// @param to is the address to delegate to
757 	function delegate(address to) external /* onlyWhenActive */;
758 
759     /// Refresh the address stake for delegation power based on the staking contract
760     /// @dev Disabled stake change update notifications from the staking contract may create mismatches
761     /// @dev refreshStake re-syncs the stake data with the staking contract
762     /// @param addr is the address to refresh its stake
763 	function refreshStake(address addr) external /* onlyWhenActive */;
764 
765     /// Refresh the addresses stake for delegation power based on the staking contract
766     /// @dev Batched version of refreshStake
767     /// @dev Disabled stake change update notifications from the staking contract may create mismatches
768     /// @dev refreshStakeBatch re-syncs the stake data with the staking contract
769     /// @param addrs is the list of addresses to refresh their stake
770 	function refreshStakeBatch(address[] calldata addrs) external /* onlyWhenActive */;
771 
772     /// Returns the delegate address of the given address
773     /// @param addr is the address to query
774     /// @return delegation is the address the addr delegated to
775 	function getDelegation(address addr) external view returns (address);
776 
777     /// Returns a delegator info
778     /// @param addr is the address to query
779     /// @return delegation is the address the addr delegated to
780     /// @return delegatorStake is the stake of the delegator as reflected in the delegation contract
781 	function getDelegationInfo(address addr) external view returns (address delegation, uint256 delegatorStake);
782 	
783     /// Returns the delegated stake of an addr 
784     /// @dev an address that is not self delegating has a 0 delegated stake
785     /// @param addr is the address to query
786     /// @return delegatedStake is the address delegated stake
787 	function getDelegatedStake(address addr) external view returns (uint256);
788 
789     /// Returns the total delegated stake
790     /// @dev delegatedStake - the total stake delegated to an address that is self delegating
791     /// @dev the delegated stake of a non self-delegated address is 0
792     /// @return totalDelegatedStake is the total delegatedStake of all the addresses
793 	function getTotalDelegatedStake() external view returns (uint256) ;
794 
795 	/*
796 	 * Governance functions
797 	 */
798 
799 	event DelegationsImported(address[] from, address indexed to);
800 
801 	event DelegationInitialized(address indexed from, address indexed to);
802 
803     /// Imports delegations during initial migration
804     /// @dev initialization function called only by the initializationManager
805     /// @dev Does not update the Rewards or Election contracts
806     /// @dev assumes deactivated Rewards
807     /// @param from is a list of delegator addresses
808     /// @param to is the address the delegators delegate to
809 	function importDelegations(address[] calldata from, address to) external /* onlyMigrationManager onlyDuringDelegationImport */;
810 
811     /// Initializes the delegation of an address during initial migration 
812     /// @dev initialization function called only by the initializationManager
813     /// @dev behaves identically to a delegate transaction sent by the delegator
814     /// @param from is the delegator addresses
815     /// @param to is the delegator delegates to
816 	function initDelegation(address from, address to) external /* onlyInitializationAdmin */;
817 }
818 
819 // File: contracts/IMigratableStakingContract.sol
820 
821 pragma solidity 0.6.12;
822 
823 
824 /// @title An interface for staking contracts which support stake migration.
825 interface IMigratableStakingContract {
826     /// @dev Returns the address of the underlying staked token.
827     /// @return IERC20 The address of the token.
828     function getToken() external view returns (IERC20);
829 
830     /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
831     /// the required amount using ERC20 approve.
832     /// @param _stakeOwner address The specified stake owner.
833     /// @param _amount uint256 The number of tokens to stake.
834     function acceptMigration(address _stakeOwner, uint256 _amount) external;
835 
836     event AcceptedMigration(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
837 }
838 
839 // File: contracts/IStakingContract.sol
840 
841 pragma solidity 0.6.12;
842 
843 
844 /// @title An interface for staking contracts.
845 interface IStakingContract {
846     /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
847     /// the required amount using ERC20 approve.
848     /// @param _amount uint256 The amount of tokens to stake.
849     function stake(uint256 _amount) external;
850 
851     /// @dev Unstakes ORBS tokens from msg.sender. If successful, this will start the cooldown period, after which
852     /// msg.sender would be able to withdraw all of his tokens.
853     /// @param _amount uint256 The amount of tokens to unstake.
854     function unstake(uint256 _amount) external;
855 
856     /// @dev Requests to withdraw all of staked ORBS tokens back to msg.sender. Stake owners can withdraw their ORBS
857     /// tokens only after previously unstaking them and after the cooldown period has passed (unless the contract was
858     /// requested to release all stakes).
859     function withdraw() external;
860 
861     /// @dev Restakes unstaked ORBS tokens (in or after cooldown) for msg.sender.
862     function restake() external;
863 
864     /// @dev Distributes staking rewards to a list of addresses by directly adding rewards to their stakes. This method
865     /// assumes that the user has already approved at least the required amount using ERC20 approve. Since this is a
866     /// convenience method, we aren't concerned about reaching block gas limit by using large lists. We assume that
867     /// callers will be able to properly batch/paginate their requests.
868     /// @param _totalAmount uint256 The total amount of rewards to distribute.
869     /// @param _stakeOwners address[] The addresses of the stake owners.
870     /// @param _amounts uint256[] The amounts of the rewards.
871     function distributeRewards(uint256 _totalAmount, address[] calldata _stakeOwners, uint256[] calldata _amounts) external;
872 
873     /// @dev Returns the stake of the specified stake owner (excluding unstaked tokens).
874     /// @param _stakeOwner address The address to check.
875     /// @return uint256 The total stake.
876     function getStakeBalanceOf(address _stakeOwner) external view returns (uint256);
877 
878     /// @dev Returns the total amount staked tokens (excluding unstaked tokens).
879     /// @return uint256 The total staked tokens of all stake owners.
880     function getTotalStakedTokens() external view returns (uint256);
881 
882     /// @dev Returns the time that the cooldown period ends (or ended) and the amount of tokens to be released.
883     /// @param _stakeOwner address The address to check.
884     /// @return cooldownAmount uint256 The total tokens in cooldown.
885     /// @return cooldownEndTime uint256 The time when the cooldown period ends (in seconds).
886     function getUnstakeStatus(address _stakeOwner) external view returns (uint256 cooldownAmount,
887         uint256 cooldownEndTime);
888 
889     /// @dev Migrates the stake of msg.sender from this staking contract to a new approved staking contract.
890     /// @param _newStakingContract IMigratableStakingContract The new staking contract which supports stake migration.
891     /// @param _amount uint256 The amount of tokens to migrate.
892     function migrateStakedTokens(IMigratableStakingContract _newStakingContract, uint256 _amount) external;
893 
894     event Staked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
895     event Unstaked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
896     event Withdrew(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
897     event Restaked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
898     event MigratedStake(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
899 }
900 
901 // File: contracts/spec_interfaces/IManagedContract.sol
902 
903 pragma solidity 0.6.12;
904 
905 /// @title managed contract interface, used by the contracts registry to notify the contract on updates
906 interface IManagedContract /* is ILockable, IContractRegistryAccessor, Initializable */ {
907 
908     /// Refreshes the address of the other contracts the contract interacts with
909     /// @dev called by the registry contract upon an update of a contract in the registry
910     function refreshContracts() external;
911 
912 }
913 
914 // File: contracts/spec_interfaces/IContractRegistry.sol
915 
916 pragma solidity 0.6.12;
917 
918 /// @title Contract registry contract interface
919 /// @dev The contract registry holds Orbs PoS contracts and managers lists
920 /// @dev The contract registry updates the managed contracts on changes in the contract list
921 /// @dev Governance functions restricted to managers access the registry to retrieve the manager address 
922 /// @dev The contract registry represents the source of truth for Orbs Ethereum contracts 
923 /// @dev By tracking the registry events or query before interaction, one can access the up to date contracts 
924 interface IContractRegistry {
925 
926 	event ContractAddressUpdated(string contractName, address addr, bool managedContract);
927 	event ManagerChanged(string role, address newManager);
928 	event ContractRegistryUpdated(address newContractRegistry);
929 
930 	/*
931 	* External functions
932 	*/
933 
934     /// Updates the contracts address and emits a corresponding event
935     /// @dev governance function called only by the migrationManager or registryAdmin
936     /// @param contractName is the contract name, used to identify it
937     /// @param addr is the contract updated address
938     /// @param managedContract indicates whether the contract is managed by the registry and notified on changes
939 	function setContract(string calldata contractName, address addr, bool managedContract) external /* onlyAdminOrMigrationManager */;
940 
941     /// Returns the current address of the given contracts
942     /// @param contractName is the contract name, used to identify it
943     /// @return addr is the contract updated address
944 	function getContract(string calldata contractName) external view returns (address);
945 
946     /// Returns the list of contract addresses managed by the registry
947     /// @dev Managed contracts are updated on changes in the registry contracts addresses 
948     /// @return addrs is the list of managed contracts
949 	function getManagedContracts() external view returns (address[] memory);
950 
951     /// Locks all the managed contracts 
952     /// @dev governance function called only by the migrationManager or registryAdmin
953     /// @dev When set all onlyWhenActive functions will revert
954 	function lockContracts() external /* onlyAdminOrMigrationManager */;
955 
956     /// Unlocks all the managed contracts 
957     /// @dev governance function called only by the migrationManager or registryAdmin
958 	function unlockContracts() external /* onlyAdminOrMigrationManager */;
959 	
960     /// Updates a manager address and emits a corresponding event
961     /// @dev governance function called only by the registryAdmin
962     /// @dev the managers list is a flexible list of role to the manager's address
963     /// @param role is the managers' role name, for example "functionalManager"
964     /// @param manager is the manager updated address
965 	function setManager(string calldata role, address manager) external /* onlyAdmin */;
966 
967     /// Returns the current address of the given manager
968     /// @param role is the manager name, used to identify it
969     /// @return addr is the manager updated address
970 	function getManager(string calldata role) external view returns (address);
971 
972     /// Sets a new contract registry to migrate to
973     /// @dev governance function called only by the registryAdmin
974     /// @dev updates the registry address record in all the managed contracts
975     /// @dev by tracking the emitted ContractRegistryUpdated, tools can track the up to date contracts
976     /// @param newRegistry is the new registry contract 
977 	function setNewContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;
978 
979     /// Returns the previous contract registry address 
980     /// @dev used when the setting the contract as a new registry to assure a valid registry
981     /// @return previousContractRegistry is the previous contract registry
982 	function getPreviousContractRegistry() external view returns (address);
983 }
984 
985 // File: contracts/spec_interfaces/IContractRegistryAccessor.sol
986 
987 pragma solidity 0.6.12;
988 
989 
990 interface IContractRegistryAccessor {
991 
992     /// Sets the contract registry address
993     /// @dev governance function called only by an admin
994     /// @param newRegistry is the new registry contract 
995     function setContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;
996 
997     /// Returns the contract registry address
998     /// @return contractRegistry is the contract registry address
999     function getContractRegistry() external view returns (IContractRegistry contractRegistry);
1000 
1001     function setRegistryAdmin(address _registryAdmin) external /* onlyInitializationAdmin */;
1002 
1003 }
1004 
1005 // File: @openzeppelin/contracts/GSN/Context.sol
1006 
1007 pragma solidity ^0.6.0;
1008 
1009 /*
1010  * @dev Provides information about the current execution context, including the
1011  * sender of the transaction and its data. While these are generally available
1012  * via msg.sender and msg.data, they should not be accessed in such a direct
1013  * manner, since when dealing with GSN meta-transactions the account sending and
1014  * paying for execution may not be the actual sender (as far as an application
1015  * is concerned).
1016  *
1017  * This contract is only required for intermediate, library-like contracts.
1018  */
1019 abstract contract Context {
1020     function _msgSender() internal view virtual returns (address payable) {
1021         return msg.sender;
1022     }
1023 
1024     function _msgData() internal view virtual returns (bytes memory) {
1025         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1026         return msg.data;
1027     }
1028 }
1029 
1030 // File: contracts/WithClaimableRegistryManagement.sol
1031 
1032 pragma solidity 0.6.12;
1033 
1034 
1035 /**
1036  * @title Claimable
1037  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
1038  * This allows the new owner to accept the transfer.
1039  */
1040 contract WithClaimableRegistryManagement is Context {
1041     address private _registryAdmin;
1042     address private _pendingRegistryAdmin;
1043 
1044     event RegistryManagementTransferred(address indexed previousRegistryAdmin, address indexed newRegistryAdmin);
1045 
1046     /**
1047      * @dev Initializes the contract setting the deployer as the initial registryRegistryAdmin.
1048      */
1049     constructor () internal {
1050         address msgSender = _msgSender();
1051         _registryAdmin = msgSender;
1052         emit RegistryManagementTransferred(address(0), msgSender);
1053     }
1054 
1055     /**
1056      * @dev Returns the address of the current registryAdmin.
1057      */
1058     function registryAdmin() public view returns (address) {
1059         return _registryAdmin;
1060     }
1061 
1062     /**
1063      * @dev Throws if called by any account other than the registryAdmin.
1064      */
1065     modifier onlyRegistryAdmin() {
1066         require(isRegistryAdmin(), "WithClaimableRegistryManagement: caller is not the registryAdmin");
1067         _;
1068     }
1069 
1070     /**
1071      * @dev Returns true if the caller is the current registryAdmin.
1072      */
1073     function isRegistryAdmin() public view returns (bool) {
1074         return _msgSender() == _registryAdmin;
1075     }
1076 
1077     /**
1078      * @dev Leaves the contract without registryAdmin. It will not be possible to call
1079      * `onlyManager` functions anymore. Can only be called by the current registryAdmin.
1080      *
1081      * NOTE: Renouncing registryManagement will leave the contract without an registryAdmin,
1082      * thereby removing any functionality that is only available to the registryAdmin.
1083      */
1084     function renounceRegistryManagement() public onlyRegistryAdmin {
1085         emit RegistryManagementTransferred(_registryAdmin, address(0));
1086         _registryAdmin = address(0);
1087     }
1088 
1089     /**
1090      * @dev Transfers registryManagement of the contract to a new account (`newManager`).
1091      */
1092     function _transferRegistryManagement(address newRegistryAdmin) internal {
1093         require(newRegistryAdmin != address(0), "RegistryAdmin: new registryAdmin is the zero address");
1094         emit RegistryManagementTransferred(_registryAdmin, newRegistryAdmin);
1095         _registryAdmin = newRegistryAdmin;
1096     }
1097 
1098     /**
1099      * @dev Modifier throws if called by any account other than the pendingManager.
1100      */
1101     modifier onlyPendingRegistryAdmin() {
1102         require(msg.sender == _pendingRegistryAdmin, "Caller is not the pending registryAdmin");
1103         _;
1104     }
1105     /**
1106      * @dev Allows the current registryAdmin to set the pendingManager address.
1107      * @param newRegistryAdmin The address to transfer registryManagement to.
1108      */
1109     function transferRegistryManagement(address newRegistryAdmin) public onlyRegistryAdmin {
1110         _pendingRegistryAdmin = newRegistryAdmin;
1111     }
1112 
1113     /**
1114      * @dev Allows the _pendingRegistryAdmin address to finalize the transfer.
1115      */
1116     function claimRegistryManagement() external onlyPendingRegistryAdmin {
1117         _transferRegistryManagement(_pendingRegistryAdmin);
1118         _pendingRegistryAdmin = address(0);
1119     }
1120 
1121     /**
1122      * @dev Returns the current pendingRegistryAdmin
1123     */
1124     function pendingRegistryAdmin() public view returns (address) {
1125        return _pendingRegistryAdmin;  
1126     }
1127 }
1128 
1129 // File: contracts/Initializable.sol
1130 
1131 pragma solidity 0.6.12;
1132 
1133 contract Initializable {
1134 
1135     address private _initializationAdmin;
1136 
1137     event InitializationComplete();
1138 
1139     /// Constructor
1140     /// Sets the initializationAdmin to the contract deployer
1141     /// The initialization admin may call any manager only function until initializationComplete
1142     constructor() public{
1143         _initializationAdmin = msg.sender;
1144     }
1145 
1146     modifier onlyInitializationAdmin() {
1147         require(msg.sender == initializationAdmin(), "sender is not the initialization admin");
1148 
1149         _;
1150     }
1151 
1152     /*
1153     * External functions
1154     */
1155 
1156     /// Returns the initializationAdmin address
1157     function initializationAdmin() public view returns (address) {
1158         return _initializationAdmin;
1159     }
1160 
1161     /// Finalizes the initialization and revokes the initializationAdmin role 
1162     function initializationComplete() external onlyInitializationAdmin {
1163         _initializationAdmin = address(0);
1164         emit InitializationComplete();
1165     }
1166 
1167     /// Checks if the initialization was completed
1168     function isInitializationComplete() public view returns (bool) {
1169         return _initializationAdmin == address(0);
1170     }
1171 
1172 }
1173 
1174 // File: contracts/ContractRegistryAccessor.sol
1175 
1176 pragma solidity 0.6.12;
1177 
1178 
1179 
1180 
1181 
1182 contract ContractRegistryAccessor is IContractRegistryAccessor, WithClaimableRegistryManagement, Initializable {
1183 
1184     IContractRegistry private contractRegistry;
1185 
1186     /// Constructor
1187     /// @param _contractRegistry is the contract registry address
1188     /// @param _registryAdmin is the registry admin address
1189     constructor(IContractRegistry _contractRegistry, address _registryAdmin) public {
1190         require(address(_contractRegistry) != address(0), "_contractRegistry cannot be 0");
1191         setContractRegistry(_contractRegistry);
1192         _transferRegistryManagement(_registryAdmin);
1193     }
1194 
1195     modifier onlyAdmin {
1196         require(isAdmin(), "sender is not an admin (registryManger or initializationAdmin)");
1197 
1198         _;
1199     }
1200 
1201     modifier onlyMigrationManager {
1202         require(isMigrationManager(), "sender is not the migration manager");
1203 
1204         _;
1205     }
1206 
1207     modifier onlyFunctionalManager {
1208         require(isFunctionalManager(), "sender is not the functional manager");
1209 
1210         _;
1211     }
1212 
1213     /// Checks whether the caller is Admin: either the contract registry, the registry admin, or the initialization admin
1214     function isAdmin() internal view returns (bool) {
1215         return msg.sender == address(contractRegistry) || msg.sender == registryAdmin() || msg.sender == initializationAdmin();
1216     }
1217 
1218     /// Checks whether the caller is a specific manager role or and Admin
1219     /// @dev queries the registry contract for the up to date manager assignment
1220     function isManager(string memory role) internal view returns (bool) {
1221         IContractRegistry _contractRegistry = contractRegistry;
1222         return isAdmin() || _contractRegistry != IContractRegistry(0) && contractRegistry.getManager(role) == msg.sender;
1223     }
1224 
1225     /// Checks whether the caller is the migration manager
1226     function isMigrationManager() internal view returns (bool) {
1227         return isManager('migrationManager');
1228     }
1229 
1230     /// Checks whether the caller is the functional manager
1231     function isFunctionalManager() internal view returns (bool) {
1232         return isManager('functionalManager');
1233     }
1234 
1235     /* 
1236      * Contract getters, return the address of a contract by calling the contract registry 
1237      */ 
1238 
1239     function getProtocolContract() internal view returns (address) {
1240         return contractRegistry.getContract("protocol");
1241     }
1242 
1243     function getStakingRewardsContract() internal view returns (address) {
1244         return contractRegistry.getContract("stakingRewards");
1245     }
1246 
1247     function getFeesAndBootstrapRewardsContract() internal view returns (address) {
1248         return contractRegistry.getContract("feesAndBootstrapRewards");
1249     }
1250 
1251     function getCommitteeContract() internal view returns (address) {
1252         return contractRegistry.getContract("committee");
1253     }
1254 
1255     function getElectionsContract() internal view returns (address) {
1256         return contractRegistry.getContract("elections");
1257     }
1258 
1259     function getDelegationsContract() internal view returns (address) {
1260         return contractRegistry.getContract("delegations");
1261     }
1262 
1263     function getGuardiansRegistrationContract() internal view returns (address) {
1264         return contractRegistry.getContract("guardiansRegistration");
1265     }
1266 
1267     function getCertificationContract() internal view returns (address) {
1268         return contractRegistry.getContract("certification");
1269     }
1270 
1271     function getStakingContract() internal view returns (address) {
1272         return contractRegistry.getContract("staking");
1273     }
1274 
1275     function getSubscriptionsContract() internal view returns (address) {
1276         return contractRegistry.getContract("subscriptions");
1277     }
1278 
1279     function getStakingRewardsWallet() internal view returns (address) {
1280         return contractRegistry.getContract("stakingRewardsWallet");
1281     }
1282 
1283     function getBootstrapRewardsWallet() internal view returns (address) {
1284         return contractRegistry.getContract("bootstrapRewardsWallet");
1285     }
1286 
1287     function getGeneralFeesWallet() internal view returns (address) {
1288         return contractRegistry.getContract("generalFeesWallet");
1289     }
1290 
1291     function getCertifiedFeesWallet() internal view returns (address) {
1292         return contractRegistry.getContract("certifiedFeesWallet");
1293     }
1294 
1295     function getStakingContractHandler() internal view returns (address) {
1296         return contractRegistry.getContract("stakingContractHandler");
1297     }
1298 
1299     /*
1300     * Governance functions
1301     */
1302 
1303     event ContractRegistryAddressUpdated(address addr);
1304 
1305     /// Sets the contract registry address
1306     /// @dev governance function called only by an admin
1307     /// @param newContractRegistry is the new registry contract 
1308     function setContractRegistry(IContractRegistry newContractRegistry) public override onlyAdmin {
1309         require(newContractRegistry.getPreviousContractRegistry() == address(contractRegistry), "new contract registry must provide the previous contract registry");
1310         contractRegistry = newContractRegistry;
1311         emit ContractRegistryAddressUpdated(address(newContractRegistry));
1312     }
1313 
1314     /// Returns the contract registry that the contract is set to use
1315     /// @return contractRegistry is the registry contract address
1316     function getContractRegistry() public override view returns (IContractRegistry) {
1317         return contractRegistry;
1318     }
1319 
1320     function setRegistryAdmin(address _registryAdmin) external override onlyInitializationAdmin {
1321         _transferRegistryManagement(_registryAdmin);
1322     }
1323 
1324 }
1325 
1326 // File: contracts/spec_interfaces/ILockable.sol
1327 
1328 pragma solidity 0.6.12;
1329 
1330 /// @title lockable contract interface, allows to lock a contract
1331 interface ILockable {
1332 
1333     event Locked();
1334     event Unlocked();
1335 
1336     /// Locks the contract to external non-governance function calls
1337     /// @dev governance function called only by the migration manager or an admin
1338     /// @dev typically called by the registry contract upon locking all managed contracts
1339     /// @dev getters and migration functions remain active also for locked contracts
1340     /// @dev checked by the onlyWhenActive modifier
1341     function lock() external /* onlyMigrationManager */;
1342 
1343     /// Unlocks the contract 
1344     /// @dev governance function called only by the migration manager or an admin
1345     /// @dev typically called by the registry contract upon unlocking all managed contracts
1346     function unlock() external /* onlyMigrationManager */;
1347 
1348     /// Returns the contract locking status
1349     /// @return isLocked is a bool indicating the contract is locked 
1350     function isLocked() view external returns (bool);
1351 
1352 }
1353 
1354 // File: contracts/Lockable.sol
1355 
1356 pragma solidity 0.6.12;
1357 
1358 
1359 
1360 /// @title lockable contract
1361 contract Lockable is ILockable, ContractRegistryAccessor {
1362 
1363     bool public locked;
1364 
1365     /// Constructor
1366     /// @param _contractRegistry is the contract registry address
1367     /// @param _registryAdmin is the registry admin address
1368     constructor(IContractRegistry _contractRegistry, address _registryAdmin) ContractRegistryAccessor(_contractRegistry, _registryAdmin) public {}
1369 
1370     /// Locks the contract to external non-governance function calls
1371     /// @dev governance function called only by the migration manager or an admin
1372     /// @dev typically called by the registry contract upon locking all managed contracts
1373     /// @dev getters and migration functions remain active also for locked contracts
1374     /// @dev checked by the onlyWhenActive modifier
1375     function lock() external override onlyMigrationManager {
1376         locked = true;
1377         emit Locked();
1378     }
1379 
1380     /// Unlocks the contract 
1381     /// @dev governance function called only by the migration manager or an admin
1382     /// @dev typically called by the registry contract upon unlocking all managed contracts
1383     function unlock() external override onlyMigrationManager {
1384         locked = false;
1385         emit Unlocked();
1386     }
1387 
1388     /// Returns the contract locking status
1389     /// @return isLocked is a bool indicating the contract is locked 
1390     function isLocked() external override view returns (bool) {
1391         return locked;
1392     }
1393 
1394     modifier onlyWhenActive() {
1395         require(!locked, "contract is locked for this operation");
1396 
1397         _;
1398     }
1399 }
1400 
1401 // File: contracts/ManagedContract.sol
1402 
1403 pragma solidity 0.6.12;
1404 
1405 
1406 
1407 /// @title managed contract
1408 contract ManagedContract is IManagedContract, Lockable {
1409 
1410     /// @param _contractRegistry is the contract registry address
1411     /// @param _registryAdmin is the registry admin address
1412     constructor(IContractRegistry _contractRegistry, address _registryAdmin) Lockable(_contractRegistry, _registryAdmin) public {}
1413 
1414     /// Refreshes the address of the other contracts the contract interacts with
1415     /// @dev called by the registry contract upon an update of a contract in the registry
1416     function refreshContracts() virtual override external {}
1417 
1418 }
1419 
1420 // File: contracts/StakingRewards.sol
1421 
1422 pragma solidity 0.6.12;
1423 
1424 
1425 
1426 
1427 
1428 
1429 
1430 
1431 
1432 
1433 
1434 contract StakingRewards is IStakingRewards, ManagedContract {
1435     using SafeMath for uint256;
1436     using SafeMath96 for uint96;
1437 
1438     uint256 constant PERCENT_MILLIE_BASE = 100000;
1439     uint256 constant TOKEN_BASE = 1e18;
1440 
1441     struct Settings {
1442         uint96 annualCap;
1443         uint32 annualRateInPercentMille;
1444         uint32 defaultDelegatorsStakingRewardsPercentMille;
1445         uint32 maxDelegatorsStakingRewardsPercentMille;
1446         bool rewardAllocationActive;
1447     }
1448     Settings settings;
1449 
1450     IERC20 public token;
1451 
1452     struct StakingRewardsState {
1453         uint96 stakingRewardsPerWeight;
1454         uint96 unclaimedStakingRewards;
1455         uint32 lastAssigned;
1456     }
1457     StakingRewardsState public stakingRewardsState;
1458 
1459     uint256 public stakingRewardsContractBalance;
1460 
1461     struct GuardianStakingRewards {
1462         uint96 delegatorRewardsPerToken;
1463         uint96 lastStakingRewardsPerWeight;
1464         uint96 balance;
1465         uint96 claimed;
1466     }
1467     mapping(address => GuardianStakingRewards) public guardiansStakingRewards;
1468 
1469     struct GuardianRewardSettings {
1470         uint32 delegatorsStakingRewardsPercentMille;
1471         bool overrideDefault;
1472     }
1473     mapping(address => GuardianRewardSettings) public guardiansRewardSettings;
1474 
1475     struct DelegatorStakingRewards {
1476         uint96 balance;
1477         uint96 lastDelegatorRewardsPerToken;
1478         uint96 claimed;
1479     }
1480     mapping(address => DelegatorStakingRewards) public delegatorsStakingRewards;
1481 
1482     /// Constructor
1483     /// @dev the constructor does not migrate reward balances from the previous rewards contract
1484     /// @param _contractRegistry is the contract registry address
1485     /// @param _registryAdmin is the registry admin address
1486     /// @param _token is the token used for staking rewards
1487     /// @param annualRateInPercentMille is the annual rate in percent-mille
1488     /// @param annualCap is the annual staking rewards cap
1489     /// @param defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille(0 - maxDelegatorsStakingRewardsPercentMille)
1490     /// @param maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille(0 - 100,000)
1491     /// @param previousRewardsContract is the previous rewards contract address used for migration of guardians settings. address(0) indicates no guardian settings to migrate
1492     /// @param guardiansToMigrate is a list of guardian addresses to migrate their rewards settings
1493     constructor(
1494         IContractRegistry _contractRegistry,
1495         address _registryAdmin,
1496         IERC20 _token,
1497         uint32 annualRateInPercentMille,
1498         uint96 annualCap,
1499         uint32 defaultDelegatorsStakingRewardsPercentMille,
1500         uint32 maxDelegatorsStakingRewardsPercentMille,
1501         IStakingRewards previousRewardsContract,
1502         address[] memory guardiansToMigrate
1503     ) ManagedContract(_contractRegistry, _registryAdmin) public {
1504         require(address(_token) != address(0), "token must not be 0");
1505 
1506         _setAnnualStakingRewardsRate(annualRateInPercentMille, annualCap);
1507         setMaxDelegatorsStakingRewardsPercentMille(maxDelegatorsStakingRewardsPercentMille);
1508         setDefaultDelegatorsStakingRewardsPercentMille(defaultDelegatorsStakingRewardsPercentMille);
1509 
1510         token = _token;
1511 
1512         if (address(previousRewardsContract) != address(0)) {
1513             migrateGuardiansSettings(previousRewardsContract, guardiansToMigrate);
1514         }
1515     }
1516 
1517     modifier onlyCommitteeContract() {
1518         require(msg.sender == address(committeeContract), "caller is not the elections contract");
1519 
1520         _;
1521     }
1522 
1523     modifier onlyDelegationsContract() {
1524         require(msg.sender == address(delegationsContract), "caller is not the delegations contract");
1525 
1526         _;
1527     }
1528 
1529     /*
1530     * External functions
1531     */
1532 
1533     /// Returns the current reward balance of the given address.
1534     /// @dev calculates the up to date balances (differ from the state)
1535     /// @param addr is the address to query
1536     /// @return delegatorStakingRewardsBalance the rewards awarded to the guardian role
1537     /// @return guardianStakingRewardsBalance the rewards awarded to the guardian role
1538     function getStakingRewardsBalance(address addr) external override view returns (uint256 delegatorStakingRewardsBalance, uint256 guardianStakingRewardsBalance) {
1539         (DelegatorStakingRewards memory delegatorStakingRewards,,) = getDelegatorStakingRewards(addr, block.timestamp);
1540         (GuardianStakingRewards memory guardianStakingRewards,,) = getGuardianStakingRewards(addr, block.timestamp);
1541         return (delegatorStakingRewards.balance, guardianStakingRewards.balance);
1542     }
1543 
1544     /// Claims the staking rewards balance of an addr, staking the rewards
1545     /// @dev Claimed rewards are staked in the staking contract using the distributeRewards interface
1546     /// @dev includes the rewards for both the delegator and guardian roles
1547     /// @dev calculates the up to date rewards prior to distribute them to the staking contract
1548     /// @param addr is the address to claim rewards for
1549     function claimStakingRewards(address addr) external override onlyWhenActive {
1550         (uint256 guardianRewards, uint256 delegatorRewards) = claimStakingRewardsLocally(addr);
1551         uint256 total = delegatorRewards.add(guardianRewards);
1552         if (total == 0) {
1553             return;
1554         }
1555 
1556         uint96 claimedGuardianRewards = guardiansStakingRewards[addr].claimed.add(guardianRewards);
1557         guardiansStakingRewards[addr].claimed = claimedGuardianRewards;
1558         uint96 claimedDelegatorRewards = delegatorsStakingRewards[addr].claimed.add(delegatorRewards);
1559         delegatorsStakingRewards[addr].claimed = claimedDelegatorRewards;
1560 
1561         require(token.approve(address(stakingContract), total), "claimStakingRewards: approve failed");
1562 
1563         address[] memory addrs = new address[](1);
1564         addrs[0] = addr;
1565         uint256[] memory amounts = new uint256[](1);
1566         amounts[0] = total;
1567         stakingContract.distributeRewards(total, addrs, amounts);
1568 
1569         emit StakingRewardsClaimed(addr, delegatorRewards, guardianRewards, claimedDelegatorRewards, claimedGuardianRewards);
1570     }
1571 
1572     /// Returns the current global staking rewards state
1573     /// @dev calculated to the latest block, may differ from the state read
1574     /// @return stakingRewardsPerWeight is the potential reward per 1E18 (TOKEN_BASE) committee weight assigned to a guardian was in the committee from day zero
1575     /// @return unclaimedStakingRewards is the of tokens that were assigned to participants and not claimed yet
1576     function getStakingRewardsState() public override view returns (
1577         uint96 stakingRewardsPerWeight,
1578         uint96 unclaimedStakingRewards
1579     ) {
1580         (, , uint totalCommitteeWeight) = committeeContract.getCommitteeStats();
1581         (StakingRewardsState memory _stakingRewardsState,) = _getStakingRewardsState(totalCommitteeWeight, block.timestamp, settings);
1582         stakingRewardsPerWeight = _stakingRewardsState.stakingRewardsPerWeight;
1583         unclaimedStakingRewards = _stakingRewardsState.unclaimedStakingRewards;
1584     }
1585 
1586     /// Returns the current guardian staking rewards state
1587     /// @dev calculated to the latest block, may differ from the state read
1588     /// @dev notice that the guardian rewards are the rewards for the guardian role as guardian and do not include delegation rewards
1589     /// @dev use getDelegatorStakingRewardsData to get the guardian's rewards as delegator
1590     /// @param guardian is the guardian to query
1591     /// @return balance is the staking rewards balance for the guardian role
1592     /// @return claimed is the staking rewards for the guardian role that were claimed
1593     /// @return delegatorRewardsPerToken is the potential reward per token (1E18 units) assigned to a guardian's delegator that delegated from day zero
1594     /// @return delegatorRewardsPerTokenDelta is the increment in delegatorRewardsPerToken since the last guardian update
1595     /// @return lastStakingRewardsPerWeight is the up to date stakingRewardsPerWeight used for the guardian state calculation
1596     /// @return stakingRewardsPerWeightDelta is the increment in stakingRewardsPerWeight since the last guardian update
1597     function getGuardianStakingRewardsData(address guardian) external override view returns (
1598         uint256 balance,
1599         uint256 claimed,
1600         uint256 delegatorRewardsPerToken,
1601         uint256 delegatorRewardsPerTokenDelta,
1602         uint256 lastStakingRewardsPerWeight,
1603         uint256 stakingRewardsPerWeightDelta
1604     ) {
1605         (GuardianStakingRewards memory rewards, uint256 _stakingRewardsPerWeightDelta, uint256 _delegatorRewardsPerTokenDelta) = getGuardianStakingRewards(guardian, block.timestamp);
1606         return (rewards.balance, rewards.claimed, rewards.delegatorRewardsPerToken, _delegatorRewardsPerTokenDelta, rewards.lastStakingRewardsPerWeight, _stakingRewardsPerWeightDelta);
1607     }
1608 
1609     /// Returns the current delegator staking rewards state
1610     /// @dev calculated to the latest block, may differ from the state read
1611     /// @param delegator is the delegator to query
1612     /// @return balance is the staking rewards balance for the delegator role
1613     /// @return claimed is the staking rewards for the delegator role that were claimed
1614     /// @return guardian is the guardian the delegator delegated to receiving a portion of the guardian staking rewards
1615     /// @return lastDelegatorRewardsPerToken is the up to date delegatorRewardsPerToken used for the delegator state calculation
1616     /// @return delegatorRewardsPerTokenDelta is the increment in delegatorRewardsPerToken since the last delegator update
1617     function getDelegatorStakingRewardsData(address delegator) external override view returns (
1618         uint256 balance,
1619         uint256 claimed,
1620         address guardian,
1621         uint256 lastDelegatorRewardsPerToken,
1622         uint256 delegatorRewardsPerTokenDelta
1623     ) {
1624         (DelegatorStakingRewards memory rewards, address _guardian, uint256 _delegatorRewardsPerTokenDelta) = getDelegatorStakingRewards(delegator, block.timestamp);
1625         return (rewards.balance, rewards.claimed, _guardian, rewards.lastDelegatorRewardsPerToken, _delegatorRewardsPerTokenDelta);
1626     }
1627 
1628     /// Returns an estimation for the delegator and guardian staking rewards for a given duration
1629     /// @dev the returned value is an estimation, assuming no change in the PoS state
1630     /// @dev the period calculated for start from the current block time until the current time + duration.
1631     /// @param addr is the address to estimate rewards for
1632     /// @param duration is the duration to calculate for in seconds
1633     /// @return estimatedDelegatorStakingRewards is the estimated reward for the delegator role
1634     /// @return estimatedGuardianStakingRewards is the estimated reward for the guardian role
1635     function estimateFutureRewards(address addr, uint256 duration) external override view returns (uint256 estimatedDelegatorStakingRewards, uint256 estimatedGuardianStakingRewards) {
1636         (GuardianStakingRewards memory guardianRewardsNow,,) = getGuardianStakingRewards(addr, block.timestamp);
1637         (DelegatorStakingRewards memory delegatorRewardsNow,,) = getDelegatorStakingRewards(addr, block.timestamp);
1638         (GuardianStakingRewards memory guardianRewardsFuture,,) = getGuardianStakingRewards(addr, block.timestamp.add(duration));
1639         (DelegatorStakingRewards memory delegatorRewardsFuture,,) = getDelegatorStakingRewards(addr, block.timestamp.add(duration));
1640 
1641         estimatedDelegatorStakingRewards = delegatorRewardsFuture.balance.sub(delegatorRewardsNow.balance);
1642         estimatedGuardianStakingRewards = guardianRewardsFuture.balance.sub(guardianRewardsNow.balance);
1643     }
1644 
1645     /// Sets the guardian's delegators staking reward portion
1646     /// @dev by default uses the defaultDelegatorsStakingRewardsPercentMille
1647     /// @param delegatorRewardsPercentMille is the delegators portion in percent-mille (0 - maxDelegatorsStakingRewardsPercentMille)
1648     function setGuardianDelegatorsStakingRewardsPercentMille(uint32 delegatorRewardsPercentMille) external override onlyWhenActive {
1649         require(delegatorRewardsPercentMille <= PERCENT_MILLIE_BASE, "delegatorRewardsPercentMille must be 100000 at most");
1650         require(delegatorRewardsPercentMille <= settings.maxDelegatorsStakingRewardsPercentMille, "delegatorRewardsPercentMille must not be larger than maxDelegatorsStakingRewardsPercentMille");
1651         updateDelegatorStakingRewards(msg.sender);
1652         _setGuardianDelegatorsStakingRewardsPercentMille(msg.sender, delegatorRewardsPercentMille);
1653     }
1654 
1655     /// Returns a guardian's delegators staking reward portion
1656     /// @dev If not explicitly set, returns the defaultDelegatorsStakingRewardsPercentMille
1657     /// @return delegatorRewardsRatioPercentMille is the delegators portion in percent-mille
1658     function getGuardianDelegatorsStakingRewardsPercentMille(address guardian) external override view returns (uint256 delegatorRewardsRatioPercentMille) {
1659         return _getGuardianDelegatorsStakingRewardsPercentMille(guardian, settings);
1660     }
1661 
1662     /// Returns the amount of ORBS tokens in the staking rewards wallet allocated to staking rewards
1663     /// @dev The staking wallet balance must always larger than the allocated value
1664     /// @return allocated is the amount of tokens allocated in the staking rewards wallet
1665     function getStakingRewardsWalletAllocatedTokens() external override view returns (uint256 allocated) {
1666         (, uint96 unclaimedStakingRewards) = getStakingRewardsState();
1667         return uint256(unclaimedStakingRewards).sub(stakingRewardsContractBalance);
1668     }
1669 
1670     /// Returns the current annual staking reward rate
1671     /// @dev calculated based on the current total committee weight
1672     /// @return annualRate is the current staking reward rate in percent-mille
1673     function getCurrentStakingRewardsRatePercentMille() external override view returns (uint256 annualRate) {
1674         (, , uint totalCommitteeWeight) = committeeContract.getCommitteeStats();
1675         annualRate = _getAnnualRewardPerWeight(totalCommitteeWeight, settings).mul(PERCENT_MILLIE_BASE).div(TOKEN_BASE);
1676     }
1677 
1678     /// Notifies an expected change in the committee membership of the guardian
1679     /// @dev Called only by: the Committee contract
1680     /// @dev called upon expected change in the committee membership of the guardian
1681     /// @dev triggers update of the global rewards state and the guardian rewards state
1682     /// @dev updates the rewards state based on the committee state prior to the change
1683     /// @param guardian is the guardian who's committee membership is updated
1684     /// @param weight is the weight of the guardian prior to the change
1685     /// @param totalCommitteeWeight is the total committee weight prior to the change
1686     /// @param inCommittee indicates whether the guardian was in the committee prior to the change
1687     /// @param inCommitteeAfter indicates whether the guardian is in the committee after the change
1688     function committeeMembershipWillChange(address guardian, uint256 weight, uint256 totalCommitteeWeight, bool inCommittee, bool inCommitteeAfter) external override onlyWhenActive onlyCommitteeContract {
1689         uint256 delegatedStake = delegationsContract.getDelegatedStake(guardian);
1690 
1691         Settings memory _settings = settings;
1692         StakingRewardsState memory _stakingRewardsState = _updateStakingRewardsState(totalCommitteeWeight, _settings);
1693         _updateGuardianStakingRewards(guardian, inCommittee, inCommitteeAfter, weight, delegatedStake, _stakingRewardsState, _settings);
1694     }
1695 
1696     /// Notifies an expected change in a delegator and his guardian delegation state
1697     /// @dev Called only by: the Delegation contract
1698     /// @dev called upon expected change in a delegator's delegation state
1699     /// @dev triggers update of the global rewards state, the guardian rewards state and the delegator rewards state
1700     /// @dev on delegation change, updates also the new guardian and the delegator's lastDelegatorRewardsPerToken accordingly
1701     /// @param guardian is the delegator's guardian prior to the change
1702     /// @param guardianDelegatedStake is the delegated stake of the delegator's guardian prior to the change
1703     /// @param delegator is the delegator about to change delegation state
1704     /// @param delegatorStake is the stake of the delegator
1705     /// @param nextGuardian is the delegator's guardian after to the change
1706     /// @param nextGuardianDelegatedStake is the delegated stake of the delegator's guardian after to the change
1707     function delegationWillChange(address guardian, uint256 guardianDelegatedStake, address delegator, uint256 delegatorStake, address nextGuardian, uint256 nextGuardianDelegatedStake) external override onlyWhenActive onlyDelegationsContract {
1708         Settings memory _settings = settings;
1709         (bool inCommittee, uint256 weight, , uint256 totalCommitteeWeight) = committeeContract.getMemberInfo(guardian);
1710 
1711         StakingRewardsState memory _stakingRewardsState = _updateStakingRewardsState(totalCommitteeWeight, _settings);
1712         GuardianStakingRewards memory guardianStakingRewards = _updateGuardianStakingRewards(guardian, inCommittee, inCommittee, weight, guardianDelegatedStake, _stakingRewardsState, _settings);
1713         _updateDelegatorStakingRewards(delegator, delegatorStake, guardian, guardianStakingRewards);
1714 
1715         if (nextGuardian != guardian) {
1716             (inCommittee, weight, , totalCommitteeWeight) = committeeContract.getMemberInfo(nextGuardian);
1717             GuardianStakingRewards memory nextGuardianStakingRewards = _updateGuardianStakingRewards(nextGuardian, inCommittee, inCommittee, weight, nextGuardianDelegatedStake, _stakingRewardsState, _settings);
1718             delegatorsStakingRewards[delegator].lastDelegatorRewardsPerToken = nextGuardianStakingRewards.delegatorRewardsPerToken;
1719         }
1720     }
1721 
1722     /*
1723     * Governance functions
1724     */
1725 
1726     /// Activates staking rewards allocation
1727     /// @dev governance function called only by the initialization admin
1728     /// @dev On migrations, startTime should be set to the previous contract deactivation time
1729     /// @param startTime sets the last assignment time
1730     function activateRewardDistribution(uint startTime) external override onlyMigrationManager {
1731         require(!settings.rewardAllocationActive, "reward distribution is already activated");
1732 
1733         stakingRewardsState.lastAssigned = uint32(startTime);
1734         settings.rewardAllocationActive = true;
1735 
1736         emit RewardDistributionActivated(startTime);
1737     }
1738 
1739     /// Deactivates fees and bootstrap allocation
1740     /// @dev governance function called only by the migration manager
1741     /// @dev guardians updates remain active based on the current perMember value
1742     function deactivateRewardDistribution() external override onlyMigrationManager {
1743         require(settings.rewardAllocationActive, "reward distribution is already deactivated");
1744 
1745         StakingRewardsState memory _stakingRewardsState = updateStakingRewardsState();
1746 
1747         settings.rewardAllocationActive = false;
1748 
1749         withdrawRewardsWalletAllocatedTokens(_stakingRewardsState);
1750 
1751         emit RewardDistributionDeactivated();
1752     }
1753 
1754     /// Sets the default delegators staking reward portion
1755     /// @dev governance function called only by the functional manager
1756     /// @param defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille(0 - maxDelegatorsStakingRewardsPercentMille)
1757     function setDefaultDelegatorsStakingRewardsPercentMille(uint32 defaultDelegatorsStakingRewardsPercentMille) public override onlyFunctionalManager {
1758         require(defaultDelegatorsStakingRewardsPercentMille <= PERCENT_MILLIE_BASE, "defaultDelegatorsStakingRewardsPercentMille must not be larger than 100000");
1759         require(defaultDelegatorsStakingRewardsPercentMille <= settings.maxDelegatorsStakingRewardsPercentMille, "defaultDelegatorsStakingRewardsPercentMille must not be larger than maxDelegatorsStakingRewardsPercentMille");
1760         settings.defaultDelegatorsStakingRewardsPercentMille = defaultDelegatorsStakingRewardsPercentMille;
1761         emit DefaultDelegatorsStakingRewardsChanged(defaultDelegatorsStakingRewardsPercentMille);
1762     }
1763 
1764     /// Returns the default delegators staking reward portion
1765     /// @return defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille
1766     function getDefaultDelegatorsStakingRewardsPercentMille() public override view returns (uint32) {
1767         return settings.defaultDelegatorsStakingRewardsPercentMille;
1768     }
1769 
1770     /// Sets the maximum delegators staking reward portion
1771     /// @dev governance function called only by the functional manager
1772     /// @param maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille(0 - 100,000)
1773     function setMaxDelegatorsStakingRewardsPercentMille(uint32 maxDelegatorsStakingRewardsPercentMille) public override onlyFunctionalManager {
1774         require(maxDelegatorsStakingRewardsPercentMille <= PERCENT_MILLIE_BASE, "maxDelegatorsStakingRewardsPercentMille must not be larger than 100000");
1775         settings.maxDelegatorsStakingRewardsPercentMille = maxDelegatorsStakingRewardsPercentMille;
1776         emit MaxDelegatorsStakingRewardsChanged(maxDelegatorsStakingRewardsPercentMille);
1777     }
1778 
1779     /// Returns the default delegators staking reward portion
1780     /// @return maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille
1781     function getMaxDelegatorsStakingRewardsPercentMille() public override view returns (uint32) {
1782         return settings.maxDelegatorsStakingRewardsPercentMille;
1783     }
1784 
1785     /// Sets the annual rate and cap for the staking reward
1786     /// @dev governance function called only by the functional manager
1787     /// @param annualRateInPercentMille is the annual rate in percent-mille
1788     /// @param annualCap is the annual staking rewards cap
1789     function setAnnualStakingRewardsRate(uint32 annualRateInPercentMille, uint96 annualCap) external override onlyFunctionalManager {
1790         updateStakingRewardsState();
1791         return _setAnnualStakingRewardsRate(annualRateInPercentMille, annualCap);
1792     }
1793 
1794     /// Returns the annual staking reward rate
1795     /// @return annualStakingRewardsRatePercentMille is the annual rate in percent-mille
1796     function getAnnualStakingRewardsRatePercentMille() external override view returns (uint32) {
1797         return settings.annualRateInPercentMille;
1798     }
1799 
1800     /// Returns the annual staking rewards cap
1801     /// @return annualStakingRewardsCap is the annual rate in percent-mille
1802     function getAnnualStakingRewardsCap() external override view returns (uint256) {
1803         return settings.annualCap;
1804     }
1805 
1806     /// Checks if rewards allocation is active
1807     /// @return rewardAllocationActive is a bool that indicates that rewards allocation is active
1808     function isRewardAllocationActive() external override view returns (bool) {
1809         return settings.rewardAllocationActive;
1810     }
1811 
1812     /// Returns the contract's settings
1813     /// @return annualStakingRewardsCap is the annual rate in percent-mille
1814     /// @return annualStakingRewardsRatePercentMille is the annual rate in percent-mille
1815     /// @return defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille
1816     /// @return maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille
1817     /// @return rewardAllocationActive is a bool that indicates that rewards allocation is active
1818     function getSettings() external override view returns (
1819         uint annualStakingRewardsCap,
1820         uint32 annualStakingRewardsRatePercentMille,
1821         uint32 defaultDelegatorsStakingRewardsPercentMille,
1822         uint32 maxDelegatorsStakingRewardsPercentMille,
1823         bool rewardAllocationActive
1824     ) {
1825         Settings memory _settings = settings;
1826         annualStakingRewardsCap = _settings.annualCap;
1827         annualStakingRewardsRatePercentMille = _settings.annualRateInPercentMille;
1828         defaultDelegatorsStakingRewardsPercentMille = _settings.defaultDelegatorsStakingRewardsPercentMille;
1829         maxDelegatorsStakingRewardsPercentMille = _settings.maxDelegatorsStakingRewardsPercentMille;
1830         rewardAllocationActive = _settings.rewardAllocationActive;
1831     }
1832 
1833     /// Migrates the staking rewards balance of the given addresses to a new staking rewards contract
1834     /// @dev The new rewards contract is determined according to the contracts registry
1835     /// @dev No impact of the calling contract if the currently configured contract in the registry
1836     /// @dev may be called also while the contract is locked
1837     /// @param addrs is the list of addresses to migrate
1838     function migrateRewardsBalance(address[] calldata addrs) external override {
1839         require(!settings.rewardAllocationActive, "Reward distribution must be deactivated for migration");
1840 
1841         IStakingRewards currentRewardsContract = IStakingRewards(getStakingRewardsContract());
1842         require(address(currentRewardsContract) != address(this), "New rewards contract is not set");
1843 
1844         uint256 totalAmount = 0;
1845         uint256[] memory guardianRewards = new uint256[](addrs.length);
1846         uint256[] memory delegatorRewards = new uint256[](addrs.length);
1847         for (uint i = 0; i < addrs.length; i++) {
1848             (guardianRewards[i], delegatorRewards[i]) = claimStakingRewardsLocally(addrs[i]);
1849             totalAmount = totalAmount.add(guardianRewards[i]).add(delegatorRewards[i]);
1850         }
1851 
1852         require(token.approve(address(currentRewardsContract), totalAmount), "migrateRewardsBalance: approve failed");
1853         currentRewardsContract.acceptRewardsBalanceMigration(addrs, guardianRewards, delegatorRewards, totalAmount);
1854 
1855         for (uint i = 0; i < addrs.length; i++) {
1856             emit StakingRewardsBalanceMigrated(addrs[i], guardianRewards[i], delegatorRewards[i], address(currentRewardsContract));
1857         }
1858     }
1859 
1860     /// Accepts addresses balance migration from a previous rewards contract
1861     /// @dev the function may be called by any caller that approves the amounts provided for transfer
1862     /// @param addrs is the list migrated addresses
1863     /// @param migratedGuardianStakingRewards is the list of received guardian rewards balance for each address
1864     /// @param migratedDelegatorStakingRewards is the list of received delegator rewards balance for each address
1865     /// @param totalAmount is the total amount of staking rewards migrated for all addresses in the list. Must match the sum of migratedGuardianStakingRewards and migratedDelegatorStakingRewards lists.
1866     function acceptRewardsBalanceMigration(address[] calldata addrs, uint256[] calldata migratedGuardianStakingRewards, uint256[] calldata migratedDelegatorStakingRewards, uint256 totalAmount) external override {
1867         uint256 _totalAmount = 0;
1868 
1869         for (uint i = 0; i < addrs.length; i++) {
1870             _totalAmount = _totalAmount.add(migratedGuardianStakingRewards[i]).add(migratedDelegatorStakingRewards[i]);
1871         }
1872 
1873         require(totalAmount == _totalAmount, "totalAmount does not match sum of rewards");
1874 
1875         if (totalAmount > 0) {
1876             require(token.transferFrom(msg.sender, address(this), totalAmount), "acceptRewardBalanceMigration: transfer failed");
1877         }
1878 
1879         for (uint i = 0; i < addrs.length; i++) {
1880             guardiansStakingRewards[addrs[i]].balance = guardiansStakingRewards[addrs[i]].balance.add(migratedGuardianStakingRewards[i]);
1881             delegatorsStakingRewards[addrs[i]].balance = delegatorsStakingRewards[addrs[i]].balance.add(migratedDelegatorStakingRewards[i]);
1882             emit StakingRewardsBalanceMigrationAccepted(msg.sender, addrs[i], migratedGuardianStakingRewards[i], migratedDelegatorStakingRewards[i]);
1883         }
1884 
1885         stakingRewardsContractBalance = stakingRewardsContractBalance.add(totalAmount);
1886         stakingRewardsState.unclaimedStakingRewards = stakingRewardsState.unclaimedStakingRewards.add(totalAmount);
1887     }
1888 
1889     /// Performs emergency withdrawal of the contract balance
1890     /// @dev called with a token to withdraw, should be called twice with the fees and bootstrap tokens
1891     /// @dev governance function called only by the migration manager
1892     /// @param erc20 is the ERC20 token to withdraw
1893     function emergencyWithdraw(address erc20) external override onlyMigrationManager {
1894         IERC20 _token = IERC20(erc20);
1895         emit EmergencyWithdrawal(msg.sender, address(_token));
1896         require(_token.transfer(msg.sender, _token.balanceOf(address(this))), "StakingRewards::emergencyWithdraw - transfer failed");
1897     }
1898 
1899     /*
1900     * Private functions
1901     */
1902 
1903     // Global state
1904 
1905     /// Returns the annual reward per weight
1906     /// @dev calculates the current annual rewards per weight based on the annual rate and annual cap
1907     function _getAnnualRewardPerWeight(uint256 totalCommitteeWeight, Settings memory _settings) private pure returns (uint256) {
1908         return totalCommitteeWeight == 0 ? 0 : Math.min(uint256(_settings.annualRateInPercentMille).mul(TOKEN_BASE).div(PERCENT_MILLIE_BASE), uint256(_settings.annualCap).mul(TOKEN_BASE).div(totalCommitteeWeight));
1909     }
1910 
1911     /// Calculates the added rewards per weight for the given duration based on the committee data
1912     /// @param totalCommitteeWeight is the current committee total weight
1913     /// @param duration is the duration to calculate for in seconds
1914     /// @param _settings is the contract settings
1915     function calcStakingRewardPerWeightDelta(uint256 totalCommitteeWeight, uint duration, Settings memory _settings) private pure returns (uint256 stakingRewardsPerWeightDelta) {
1916         stakingRewardsPerWeightDelta = 0;
1917 
1918         if (totalCommitteeWeight > 0) {
1919             uint annualRewardPerWeight = _getAnnualRewardPerWeight(totalCommitteeWeight, _settings);
1920             stakingRewardsPerWeightDelta = annualRewardPerWeight.mul(duration).div(365 days);
1921         }
1922     }
1923 
1924     /// Returns the up global staking rewards state for a specific time
1925     /// @dev receives the relevant committee data
1926     /// @dev for future time calculations assumes no change in the committee data
1927     /// @param totalCommitteeWeight is the current committee total weight
1928     /// @param currentTime is the time to calculate the rewards for
1929     /// @param _settings is the contract settings
1930     function _getStakingRewardsState(uint256 totalCommitteeWeight, uint256 currentTime, Settings memory _settings) private view returns (StakingRewardsState memory _stakingRewardsState, uint256 allocatedRewards) {
1931         _stakingRewardsState = stakingRewardsState;
1932         if (_settings.rewardAllocationActive) {
1933             uint delta = calcStakingRewardPerWeightDelta(totalCommitteeWeight, currentTime.sub(stakingRewardsState.lastAssigned), _settings);
1934             _stakingRewardsState.stakingRewardsPerWeight = stakingRewardsState.stakingRewardsPerWeight.add(delta);
1935             _stakingRewardsState.lastAssigned = uint32(currentTime);
1936             allocatedRewards = delta.mul(totalCommitteeWeight).div(TOKEN_BASE);
1937             _stakingRewardsState.unclaimedStakingRewards = _stakingRewardsState.unclaimedStakingRewards.add(allocatedRewards);
1938         }
1939     }
1940 
1941     /// Updates the global staking rewards
1942     /// @dev calculated to the latest block, may differ from the state read
1943     /// @dev uses the _getStakingRewardsState function
1944     /// @param totalCommitteeWeight is the current committee total weight
1945     /// @param _settings is the contract settings
1946     /// @return _stakingRewardsState is the updated global staking rewards struct
1947     function _updateStakingRewardsState(uint256 totalCommitteeWeight, Settings memory _settings) private returns (StakingRewardsState memory _stakingRewardsState) {
1948         if (!_settings.rewardAllocationActive) {
1949             return stakingRewardsState;
1950         }
1951 
1952         uint allocatedRewards;
1953         (_stakingRewardsState, allocatedRewards) = _getStakingRewardsState(totalCommitteeWeight, block.timestamp, _settings);
1954         stakingRewardsState = _stakingRewardsState;
1955         emit StakingRewardsAllocated(allocatedRewards, _stakingRewardsState.stakingRewardsPerWeight);
1956     }
1957 
1958     /// Updates the global staking rewards
1959     /// @dev calculated to the latest block, may differ from the state read
1960     /// @dev queries the committee state from the committee contract
1961     /// @dev uses the _updateStakingRewardsState function
1962     /// @return _stakingRewardsState is the updated global staking rewards struct
1963     function updateStakingRewardsState() private returns (StakingRewardsState memory _stakingRewardsState) {
1964         (, , uint totalCommitteeWeight) = committeeContract.getCommitteeStats();
1965         return _updateStakingRewardsState(totalCommitteeWeight, settings);
1966     }
1967 
1968     // Guardian state
1969 
1970     /// Returns the current guardian staking rewards state
1971     /// @dev receives the relevant committee and guardian data along with the global updated global state
1972     /// @dev calculated to the latest block, may differ from the state read
1973     /// @param guardian is the guardian to query
1974     /// @param inCommittee indicates whether the guardian is currently in the committee
1975     /// @param inCommitteeAfter indicates whether after a potential change the guardian is in the committee
1976     /// @param guardianWeight is the guardian committee weight
1977     /// @param guardianDelegatedStake is the guardian delegated stake
1978     /// @param _stakingRewardsState is the updated global staking rewards state
1979     /// @param _settings is the contract settings
1980     /// @return guardianStakingRewards is the updated guardian staking rewards state
1981     /// @return rewardsAdded is the amount awarded to the guardian since the last update
1982     /// @return stakingRewardsPerWeightDelta is the delta added to the stakingRewardsPerWeight since the last update
1983     /// @return delegatorRewardsPerTokenDelta is the delta added to the guardian's delegatorRewardsPerToken since the last update
1984     function _getGuardianStakingRewards(address guardian, bool inCommittee, bool inCommitteeAfter, uint256 guardianWeight, uint256 guardianDelegatedStake, StakingRewardsState memory _stakingRewardsState, Settings memory _settings) private view returns (GuardianStakingRewards memory guardianStakingRewards, uint256 rewardsAdded, uint256 stakingRewardsPerWeightDelta, uint256 delegatorRewardsPerTokenDelta) {
1985         guardianStakingRewards = guardiansStakingRewards[guardian];
1986 
1987         if (inCommittee) {
1988             stakingRewardsPerWeightDelta = uint256(_stakingRewardsState.stakingRewardsPerWeight).sub(guardianStakingRewards.lastStakingRewardsPerWeight);
1989             uint256 totalRewards = stakingRewardsPerWeightDelta.mul(guardianWeight);
1990 
1991             uint256 delegatorRewardsRatioPercentMille = _getGuardianDelegatorsStakingRewardsPercentMille(guardian, _settings);
1992 
1993             delegatorRewardsPerTokenDelta = guardianDelegatedStake == 0 ? 0 : totalRewards
1994             .div(guardianDelegatedStake)
1995             .mul(delegatorRewardsRatioPercentMille)
1996             .div(PERCENT_MILLIE_BASE);
1997 
1998             uint256 guardianCutPercentMille = PERCENT_MILLIE_BASE.sub(delegatorRewardsRatioPercentMille);
1999 
2000             rewardsAdded = totalRewards
2001             .mul(guardianCutPercentMille)
2002             .div(PERCENT_MILLIE_BASE)
2003             .div(TOKEN_BASE);
2004 
2005             guardianStakingRewards.delegatorRewardsPerToken = guardianStakingRewards.delegatorRewardsPerToken.add(delegatorRewardsPerTokenDelta);
2006             guardianStakingRewards.balance = guardianStakingRewards.balance.add(rewardsAdded);
2007         }
2008 
2009         guardianStakingRewards.lastStakingRewardsPerWeight = inCommitteeAfter ? _stakingRewardsState.stakingRewardsPerWeight : 0;
2010     }
2011 
2012     /// Returns the guardian staking rewards state for a given time
2013     /// @dev if the time to estimate is in the future, estimates the rewards for the given time
2014     /// @dev for future time estimation assumes no change in the committee and the guardian state
2015     /// @param guardian is the guardian to query
2016     /// @param currentTime is the time to calculate the rewards for
2017     /// @return guardianStakingRewards is the guardian staking rewards state updated to the give time
2018     /// @return stakingRewardsPerWeightDelta is the delta added to the stakingRewardsPerWeight since the last update
2019     /// @return delegatorRewardsPerTokenDelta is the delta added to the guardian's delegatorRewardsPerToken since the last update
2020     function getGuardianStakingRewards(address guardian, uint256 currentTime) private view returns (GuardianStakingRewards memory guardianStakingRewards, uint256 stakingRewardsPerWeightDelta, uint256 delegatorRewardsPerTokenDelta) {
2021         Settings memory _settings = settings;
2022 
2023         (bool inCommittee, uint256 guardianWeight, ,uint256 totalCommitteeWeight) = committeeContract.getMemberInfo(guardian);
2024         uint256 guardianDelegatedStake = delegationsContract.getDelegatedStake(guardian);
2025 
2026         (StakingRewardsState memory _stakingRewardsState,) = _getStakingRewardsState(totalCommitteeWeight, currentTime, _settings);
2027         (guardianStakingRewards,,stakingRewardsPerWeightDelta,delegatorRewardsPerTokenDelta) = _getGuardianStakingRewards(guardian, inCommittee, inCommittee, guardianWeight, guardianDelegatedStake, _stakingRewardsState, _settings);
2028     }
2029 
2030     /// Updates a guardian staking rewards state
2031     /// @dev receives the relevant committee and guardian data along with the global updated global state
2032     /// @dev updates the global staking rewards state prior to calculating the guardian's
2033     /// @dev uses _getGuardianStakingRewards
2034     /// @param guardian is the guardian to update
2035     /// @param inCommittee indicates whether the guardian was in the committee prior to the change
2036     /// @param inCommitteeAfter indicates whether the guardian is in the committee after the change
2037     /// @param guardianWeight is the committee weight of the guardian prior to the change
2038     /// @param guardianDelegatedStake is the delegated stake of the guardian prior to the change
2039     /// @param _stakingRewardsState is the updated global staking rewards state
2040     /// @param _settings is the contract settings
2041     /// @return guardianStakingRewards is the updated guardian staking rewards state
2042     function _updateGuardianStakingRewards(address guardian, bool inCommittee, bool inCommitteeAfter, uint256 guardianWeight, uint256 guardianDelegatedStake, StakingRewardsState memory _stakingRewardsState, Settings memory _settings) private returns (GuardianStakingRewards memory guardianStakingRewards) {
2043         uint256 guardianStakingRewardsAdded;
2044         uint256 stakingRewardsPerWeightDelta;
2045         uint256 delegatorRewardsPerTokenDelta;
2046         (guardianStakingRewards, guardianStakingRewardsAdded, stakingRewardsPerWeightDelta, delegatorRewardsPerTokenDelta) = _getGuardianStakingRewards(guardian, inCommittee, inCommitteeAfter, guardianWeight, guardianDelegatedStake, _stakingRewardsState, _settings);
2047         guardiansStakingRewards[guardian] = guardianStakingRewards;
2048         emit GuardianStakingRewardsAssigned(guardian, guardianStakingRewardsAdded, guardianStakingRewards.claimed.add(guardianStakingRewards.balance), guardianStakingRewards.delegatorRewardsPerToken, delegatorRewardsPerTokenDelta, _stakingRewardsState.stakingRewardsPerWeight, stakingRewardsPerWeightDelta);
2049     }
2050 
2051     /// Updates a guardian staking rewards state
2052     /// @dev queries the relevant guardian and committee data from the committee contract
2053     /// @dev uses _updateGuardianStakingRewards
2054     /// @param guardian is the guardian to update
2055     /// @param _stakingRewardsState is the updated global staking rewards state
2056     /// @param _settings is the contract settings
2057     /// @return guardianStakingRewards is the updated guardian staking rewards state
2058     function updateGuardianStakingRewards(address guardian, StakingRewardsState memory _stakingRewardsState, Settings memory _settings) private returns (GuardianStakingRewards memory guardianStakingRewards) {
2059         (bool inCommittee, uint256 guardianWeight,,) = committeeContract.getMemberInfo(guardian);
2060         return _updateGuardianStakingRewards(guardian, inCommittee, inCommittee, guardianWeight, delegationsContract.getDelegatedStake(guardian), _stakingRewardsState, _settings);
2061     }
2062 
2063     // Delegator state
2064 
2065     /// Returns the current delegator staking rewards state
2066     /// @dev receives the relevant delegator data along with the delegator's current guardian updated global state
2067     /// @dev calculated to the latest block, may differ from the state read
2068     /// @param delegator is the delegator to query
2069     /// @param delegatorStake is the stake of the delegator
2070     /// @param guardianStakingRewards is the updated guardian staking rewards state
2071     /// @return delegatorStakingRewards is the updated delegator staking rewards state
2072     /// @return delegatorRewardsAdded is the amount awarded to the delegator since the last update
2073     /// @return delegatorRewardsPerTokenDelta is the delta added to the delegator's delegatorRewardsPerToken since the last update
2074     function _getDelegatorStakingRewards(address delegator, uint256 delegatorStake, GuardianStakingRewards memory guardianStakingRewards) private view returns (DelegatorStakingRewards memory delegatorStakingRewards, uint256 delegatorRewardsAdded, uint256 delegatorRewardsPerTokenDelta) {
2075         delegatorStakingRewards = delegatorsStakingRewards[delegator];
2076 
2077         delegatorRewardsPerTokenDelta = uint256(guardianStakingRewards.delegatorRewardsPerToken)
2078         .sub(delegatorStakingRewards.lastDelegatorRewardsPerToken);
2079         delegatorRewardsAdded = delegatorRewardsPerTokenDelta
2080         .mul(delegatorStake)
2081         .div(TOKEN_BASE);
2082 
2083         delegatorStakingRewards.balance = delegatorStakingRewards.balance.add(delegatorRewardsAdded);
2084         delegatorStakingRewards.lastDelegatorRewardsPerToken = guardianStakingRewards.delegatorRewardsPerToken;
2085     }
2086 
2087     /// Returns the delegator staking rewards state for a given time
2088     /// @dev if the time to estimate is in the future, estimates the rewards for the given time
2089     /// @dev for future time estimation assumes no change in the committee, delegation and the delegator state
2090     /// @param delegator is the delegator to query
2091     /// @param currentTime is the time to calculate the rewards for
2092     /// @return delegatorStakingRewards is the updated delegator staking rewards state
2093     /// @return guardian is the guardian the delegator delegated to
2094     /// @return delegatorStakingRewardsPerTokenDelta is the delta added to the delegator's delegatorRewardsPerToken since the last update
2095     function getDelegatorStakingRewards(address delegator, uint256 currentTime) private view returns (DelegatorStakingRewards memory delegatorStakingRewards, address guardian, uint256 delegatorStakingRewardsPerTokenDelta) {
2096         uint256 delegatorStake;
2097         (guardian, delegatorStake) = delegationsContract.getDelegationInfo(delegator);
2098         (GuardianStakingRewards memory guardianStakingRewards,,) = getGuardianStakingRewards(guardian, currentTime);
2099 
2100         (delegatorStakingRewards,,delegatorStakingRewardsPerTokenDelta) = _getDelegatorStakingRewards(delegator, delegatorStake, guardianStakingRewards);
2101     }
2102 
2103     /// Updates a delegator staking rewards state
2104     /// @dev receives the relevant delegator data along with the delegator's current guardian updated global state
2105     /// @dev updates the guardian staking rewards state prior to calculating the delegator's
2106     /// @dev uses _getDelegatorStakingRewards
2107     /// @param delegator is the delegator to update
2108     /// @param delegatorStake is the stake of the delegator
2109     /// @param guardianStakingRewards is the updated guardian staking rewards state
2110     function _updateDelegatorStakingRewards(address delegator, uint256 delegatorStake, address guardian, GuardianStakingRewards memory guardianStakingRewards) private {
2111         uint256 delegatorStakingRewardsAdded;
2112         uint256 delegatorRewardsPerTokenDelta;
2113         DelegatorStakingRewards memory delegatorStakingRewards;
2114         (delegatorStakingRewards, delegatorStakingRewardsAdded, delegatorRewardsPerTokenDelta) = _getDelegatorStakingRewards(delegator, delegatorStake, guardianStakingRewards);
2115         delegatorsStakingRewards[delegator] = delegatorStakingRewards;
2116 
2117         emit DelegatorStakingRewardsAssigned(delegator, delegatorStakingRewardsAdded, delegatorStakingRewards.claimed.add(delegatorStakingRewards.balance), guardian, guardianStakingRewards.delegatorRewardsPerToken, delegatorRewardsPerTokenDelta);
2118     }
2119 
2120     /// Updates a delegator staking rewards state
2121     /// @dev queries the relevant delegator and committee data from the committee contract and delegation contract
2122     /// @dev uses _updateDelegatorStakingRewards
2123     /// @param delegator is the delegator to update
2124     function updateDelegatorStakingRewards(address delegator) private {
2125         Settings memory _settings = settings;
2126 
2127         (, , uint totalCommitteeWeight) = committeeContract.getCommitteeStats();
2128         StakingRewardsState memory _stakingRewardsState = _updateStakingRewardsState(totalCommitteeWeight, _settings);
2129 
2130         (address guardian, uint delegatorStake) = delegationsContract.getDelegationInfo(delegator);
2131         GuardianStakingRewards memory guardianRewards = updateGuardianStakingRewards(guardian, _stakingRewardsState, _settings);
2132 
2133         _updateDelegatorStakingRewards(delegator, delegatorStake, guardian, guardianRewards);
2134     }
2135 
2136     // Guardian settings
2137 
2138     /// Returns the guardian's delegator portion in percent-mille
2139     /// @dev if no explicit value was set by the guardian returns the default value
2140     /// @dev enforces the maximum delegators staking rewards cut
2141     function _getGuardianDelegatorsStakingRewardsPercentMille(address guardian, Settings memory _settings) private view returns (uint256 delegatorRewardsRatioPercentMille) {
2142         GuardianRewardSettings memory guardianSettings = guardiansRewardSettings[guardian];
2143         delegatorRewardsRatioPercentMille =  guardianSettings.overrideDefault ? guardianSettings.delegatorsStakingRewardsPercentMille : _settings.defaultDelegatorsStakingRewardsPercentMille;
2144         return Math.min(delegatorRewardsRatioPercentMille, _settings.maxDelegatorsStakingRewardsPercentMille);
2145     }
2146 
2147     /// Migrates a list of guardians' delegators portion setting from a previous staking rewards contract
2148     /// @dev called by the constructor
2149     function migrateGuardiansSettings(IStakingRewards previousRewardsContract, address[] memory guardiansToMigrate) private {
2150         for (uint i = 0; i < guardiansToMigrate.length; i++) {
2151             _setGuardianDelegatorsStakingRewardsPercentMille(guardiansToMigrate[i], uint32(previousRewardsContract.getGuardianDelegatorsStakingRewardsPercentMille(guardiansToMigrate[i])));
2152         }
2153     }
2154 
2155     // Governance and misc.
2156 
2157     /// Sets the annual rate and cap for the staking reward
2158     /// @param annualRateInPercentMille is the annual rate in percent-mille
2159     /// @param annualCap is the annual staking rewards cap
2160     function _setAnnualStakingRewardsRate(uint32 annualRateInPercentMille, uint96 annualCap) private {
2161         Settings memory _settings = settings;
2162         _settings.annualRateInPercentMille = annualRateInPercentMille;
2163         _settings.annualCap = annualCap;
2164         settings = _settings;
2165 
2166         emit AnnualStakingRewardsRateChanged(annualRateInPercentMille, annualCap);
2167     }
2168 
2169     /// Sets the guardian's delegators staking reward portion
2170     /// @param guardian is the guardian to set
2171     /// @param delegatorRewardsPercentMille is the delegators portion in percent-mille (0 - maxDelegatorsStakingRewardsPercentMille)
2172     function _setGuardianDelegatorsStakingRewardsPercentMille(address guardian, uint32 delegatorRewardsPercentMille) private {
2173         guardiansRewardSettings[guardian] = GuardianRewardSettings({
2174             overrideDefault: true,
2175             delegatorsStakingRewardsPercentMille: delegatorRewardsPercentMille
2176             });
2177 
2178         emit GuardianDelegatorsStakingRewardsPercentMilleUpdated(guardian, delegatorRewardsPercentMille);
2179     }
2180 
2181     /// Claims an addr staking rewards and update its rewards state without transferring the rewards
2182     /// @dev used by claimStakingRewards and migrateRewardsBalance
2183     /// @param addr is the address to claim rewards for
2184     /// @return guardianRewards is the claimed guardian rewards balance
2185     /// @return delegatorRewards is the claimed delegator rewards balance
2186     function claimStakingRewardsLocally(address addr) private returns (uint256 guardianRewards, uint256 delegatorRewards) {
2187         updateDelegatorStakingRewards(addr);
2188 
2189         guardianRewards = guardiansStakingRewards[addr].balance;
2190         guardiansStakingRewards[addr].balance = 0;
2191 
2192         delegatorRewards = delegatorsStakingRewards[addr].balance;
2193         delegatorsStakingRewards[addr].balance = 0;
2194 
2195         uint256 total = delegatorRewards.add(guardianRewards);
2196 
2197         StakingRewardsState memory _stakingRewardsState = stakingRewardsState;
2198 
2199         uint256 _stakingRewardsContractBalance = stakingRewardsContractBalance;
2200         if (total > _stakingRewardsContractBalance) {
2201             _stakingRewardsContractBalance = withdrawRewardsWalletAllocatedTokens(_stakingRewardsState);
2202         }
2203 
2204         stakingRewardsContractBalance = _stakingRewardsContractBalance.sub(total);
2205         stakingRewardsState.unclaimedStakingRewards = _stakingRewardsState.unclaimedStakingRewards.sub(total);
2206     }
2207 
2208     /// Withdraws the tokens that were allocated to the contract from the staking rewards wallet
2209     /// @dev used as part of the migration flow to withdraw all the funds allocated for participants before updating the wallet client to a new contract
2210     /// @param _stakingRewardsState is the updated global staking rewards state
2211     function withdrawRewardsWalletAllocatedTokens(StakingRewardsState memory _stakingRewardsState) private returns (uint256 _stakingRewardsContractBalance){
2212         _stakingRewardsContractBalance = stakingRewardsContractBalance;
2213         uint256 allocated = _stakingRewardsState.unclaimedStakingRewards.sub(_stakingRewardsContractBalance);
2214         stakingRewardsWallet.withdraw(allocated);
2215         _stakingRewardsContractBalance = _stakingRewardsContractBalance.add(allocated);
2216         stakingRewardsContractBalance = _stakingRewardsContractBalance;
2217     }
2218 
2219     /*
2220      * Contracts topology / registry interface
2221      */
2222 
2223     ICommittee committeeContract;
2224     IDelegations delegationsContract;
2225     IProtocolWallet stakingRewardsWallet;
2226     IStakingContract stakingContract;
2227 
2228     /// Refreshes the address of the other contracts the contract interacts with
2229     /// @dev called by the registry contract upon an update of a contract in the registry
2230     function refreshContracts() external override {
2231         committeeContract = ICommittee(getCommitteeContract());
2232         delegationsContract = IDelegations(getDelegationsContract());
2233         stakingRewardsWallet = IProtocolWallet(getStakingRewardsWallet());
2234         stakingContract = IStakingContract(getStakingContract());
2235     }
2236 }