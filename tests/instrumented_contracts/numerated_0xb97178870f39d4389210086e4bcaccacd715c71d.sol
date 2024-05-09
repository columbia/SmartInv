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
232 // File: contracts/spec_interfaces/IElections.sol
233 
234 pragma solidity 0.6.12;
235 
236 /// @title Elections contract interface
237 interface IElections {
238 	
239 	// Election state change events
240 	event StakeChanged(address indexed addr, uint256 selfDelegatedStake, uint256 delegatedStake, uint256 effectiveStake);
241 	event GuardianStatusUpdated(address indexed guardian, bool readyToSync, bool readyForCommittee);
242 
243 	// Vote out / Vote unready
244 	event GuardianVotedUnready(address indexed guardian);
245 	event VoteUnreadyCasted(address indexed voter, address indexed subject, uint256 expiration);
246 	event GuardianVotedOut(address indexed guardian);
247 	event VoteOutCasted(address indexed voter, address indexed subject);
248 
249 	/*
250 	 * External functions
251 	 */
252 
253     /// Notifies that the guardian is ready to sync with other nodes
254     /// @dev may be called with either the guardian address or the guardian's orbs address
255     /// @dev ready to sync state is not managed in the contract that only emits an event
256     /// @dev readyToSync clears the readyForCommittee state
257 	function readyToSync() external;
258 
259     /// Notifies that the guardian is ready to join the committee
260     /// @dev may be called with either the guardian address or the guardian's orbs address
261     /// @dev a qualified guardian calling readyForCommittee is added to the committee
262 	function readyForCommittee() external;
263 
264     /// Checks if a guardian is qualified to join the committee
265     /// @dev when true, calling readyForCommittee() will result in adding the guardian to the committee
266     /// @dev called periodically by guardians to check if they are qualified to join the committee
267     /// @param guardian is the guardian to check
268     /// @return canJoin indicating that the guardian can join the current committee
269 	function canJoinCommittee(address guardian) external view returns (bool);
270 
271     /// Returns an address effective stake
272     /// The effective stake is derived from a guardian delegate stake and selfs stake  
273     /// @return effectiveStake is the guardian's effective stake
274 	function getEffectiveStake(address guardian) external view returns (uint effectiveStake);
275 
276     /// Returns the current committee along with the guardians' Orbs address and IP
277     /// @return committee is a list of the committee members' guardian addresses
278     /// @return weights is a list of the committee members' weight (effective stake)
279     /// @return orbsAddrs is a list of the committee members' orbs address
280     /// @return certification is a list of bool indicating the committee members certification
281     /// @return ips is a list of the committee members' ip
282 	function getCommittee() external view returns (address[] memory committee, uint256[] memory weights, address[] memory orbsAddrs, bool[] memory certification, bytes4[] memory ips);
283 
284 	// Vote-unready
285 
286     /// Casts an unready vote on a subject guardian
287     /// @dev Called by a guardian as part of the automatic vote-unready flow
288     /// @dev The transaction may be sent from the guardian or orbs address.
289     /// @param subject is the subject guardian to vote out
290     /// @param voteExpiration is the expiration time of the vote unready to prevent counting of a vote that is already irrelevant.
291 	function voteUnready(address subject, uint voteExpiration) external;
292 
293     /// Returns the current vote unready vote for a voter and a subject pair
294     /// @param voter is the voting guardian address
295     /// @param subject is the subject guardian address
296     /// @return valid indicates whether there is a valid vote
297     /// @return expiration returns the votes expiration time
298 	function getVoteUnreadyVote(address voter, address subject) external view returns (bool valid, uint256 expiration);
299 
300     /// Returns the current vote-unready status of a subject guardian.
301     /// @dev the committee and certification data is used to check the certified and committee threshold
302     /// @param subject is the subject guardian address
303     /// @return committee is a list of the current committee members
304     /// @return weights is a list of the current committee members weight
305     /// @return certification is a list of bool indicating the committee members certification
306     /// @return votes is a list of bool indicating the members that votes the subject unready
307     /// @return subjectInCommittee indicates that the subject is in the committee
308     /// @return subjectInCertifiedCommittee indicates that the subject is in the certified committee
309 	function getVoteUnreadyStatus(address subject) external view returns (
310 		address[] memory committee,
311 		uint256[] memory weights,
312 		bool[] memory certification,
313 		bool[] memory votes,
314 		bool subjectInCommittee,
315 		bool subjectInCertifiedCommittee
316 	);
317 
318 	// Vote-out
319 
320     /// Casts a voteOut vote by the sender to the given address
321     /// @dev the transaction is sent from the guardian address
322     /// @param subject is the subject guardian address
323 	function voteOut(address subject) external;
324 
325     /// Returns the subject address the addr has voted-out against
326     /// @param voter is the voting guardian address
327     /// @return subject is the subject the voter has voted out
328 	function getVoteOutVote(address voter) external view returns (address);
329 
330     /// Returns the governance voteOut status of a guardian.
331     /// @dev A guardian is voted out if votedStake / totalDelegatedStake (in percent mille) > threshold
332     /// @param subject is the subject guardian address
333     /// @return votedOut indicates whether the subject was voted out
334     /// @return votedStake is the total stake voting against the subject
335     /// @return totalDelegatedStake is the total delegated stake
336 	function getVoteOutStatus(address subject) external view returns (bool votedOut, uint votedStake, uint totalDelegatedStake);
337 
338 	/*
339 	 * Notification functions from other PoS contracts
340 	 */
341 
342     /// Notifies a delegated stake change event
343     /// @dev Called by: delegation contract
344     /// @param delegate is the delegate to update
345     /// @param selfDelegatedStake is the delegate self stake (0 if not self-delegating)
346     /// @param delegatedStake is the delegate delegated stake (0 if not self-delegating)
347     /// @param totalDelegatedStake is the total delegated stake
348 	function delegatedStakeChange(address delegate, uint256 selfDelegatedStake, uint256 delegatedStake, uint256 totalDelegatedStake) external /* onlyDelegationsContract onlyWhenActive */;
349 
350     /// Notifies a new guardian was unregistered
351     /// @dev Called by: guardian registration contract
352     /// @dev when a guardian unregisters its status is updated to not ready to sync and is removed from the committee
353     /// @param guardian is the address of the guardian that unregistered
354 	function guardianUnregistered(address guardian) external /* onlyGuardiansRegistrationContract */;
355 
356     /// Notifies on a guardian certification change
357     /// @dev Called by: guardian registration contract
358     /// @param guardian is the address of the guardian to update
359     /// @param isCertified indicates whether the guardian is certified
360 	function guardianCertificationChanged(address guardian, bool isCertified) external /* onlyCertificationContract */;
361 
362 
363 	/*
364      * Governance functions
365 	 */
366 
367 	event VoteUnreadyTimeoutSecondsChanged(uint32 newValue, uint32 oldValue);
368 	event VoteOutPercentMilleThresholdChanged(uint32 newValue, uint32 oldValue);
369 	event VoteUnreadyPercentMilleThresholdChanged(uint32 newValue, uint32 oldValue);
370 	event MinSelfStakePercentMilleChanged(uint32 newValue, uint32 oldValue);
371 
372     /// Sets the minimum self stake requirement for the effective stake
373     /// @dev governance function called only by the functional manager
374     /// @param minSelfStakePercentMille is the minimum self stake in percent-mille (0-100,000) 
375 	function setMinSelfStakePercentMille(uint32 minSelfStakePercentMille) external /* onlyFunctionalManager */;
376 
377     /// Returns the minimum self-stake required for the effective stake
378     /// @return minSelfStakePercentMille is the minimum self stake in percent-mille 
379 	function getMinSelfStakePercentMille() external view returns (uint32);
380 
381     /// Sets the vote-out threshold
382     /// @dev governance function called only by the functional manager
383     /// @param voteOutPercentMilleThreshold is the minimum threshold in percent-mille (0-100,000)
384 	function setVoteOutPercentMilleThreshold(uint32 voteOutPercentMilleThreshold) external /* onlyFunctionalManager */;
385 
386     /// Returns the vote-out threshold
387     /// @return voteOutPercentMilleThreshold is the minimum threshold in percent-mille
388 	function getVoteOutPercentMilleThreshold() external view returns (uint32);
389 
390     /// Sets the vote-unready threshold
391     /// @dev governance function called only by the functional manager
392     /// @param voteUnreadyPercentMilleThreshold is the minimum threshold in percent-mille (0-100,000)
393 	function setVoteUnreadyPercentMilleThreshold(uint32 voteUnreadyPercentMilleThreshold) external /* onlyFunctionalManager */;
394 
395     /// Returns the vote-unready threshold
396     /// @return voteUnreadyPercentMilleThreshold is the minimum threshold in percent-mille
397 	function getVoteUnreadyPercentMilleThreshold() external view returns (uint32);
398 
399     /// Returns the contract's settings 
400     /// @return minSelfStakePercentMille is the minimum self stake in percent-mille
401     /// @return voteUnreadyPercentMilleThreshold is the minimum threshold in percent-mille
402     /// @return voteOutPercentMilleThreshold is the minimum threshold in percent-mille
403 	function getSettings() external view returns (
404 		uint32 minSelfStakePercentMille,
405 		uint32 voteUnreadyPercentMilleThreshold,
406 		uint32 voteOutPercentMilleThreshold
407 	);
408 
409     /// Initializes the ready for committee notification for the committee guardians
410     /// @dev governance function called only by the initialization admin during migration 
411     /// @dev identical behaviour as if each guardian sent readyForCommittee() 
412     /// @param guardians a list of guardians addresses to update
413 	function initReadyForCommittee(address[] calldata guardians) external /* onlyInitializationAdmin */;
414 
415 }
416 
417 // File: contracts/spec_interfaces/IDelegations.sol
418 
419 pragma solidity 0.6.12;
420 
421 /// @title Delegations contract interface
422 interface IDelegations /* is IStakeChangeNotifier */ {
423 
424     // Delegation state change events
425 	event DelegatedStakeChanged(address indexed addr, uint256 selfDelegatedStake, uint256 delegatedStake, address indexed delegator, uint256 delegatorContributedStake);
426 
427     // Function calls
428 	event Delegated(address indexed from, address indexed to);
429 
430 	/*
431      * External functions
432      */
433 
434     /// Delegate your stake
435     /// @dev updates the election contract on the changes in the delegated stake
436     /// @dev updates the rewards contract on the upcoming change in the delegator's delegation state
437     /// @param to is the address to delegate to
438 	function delegate(address to) external /* onlyWhenActive */;
439 
440     /// Refresh the address stake for delegation power based on the staking contract
441     /// @dev Disabled stake change update notifications from the staking contract may create mismatches
442     /// @dev refreshStake re-syncs the stake data with the staking contract
443     /// @param addr is the address to refresh its stake
444 	function refreshStake(address addr) external /* onlyWhenActive */;
445 
446     /// Refresh the addresses stake for delegation power based on the staking contract
447     /// @dev Batched version of refreshStake
448     /// @dev Disabled stake change update notifications from the staking contract may create mismatches
449     /// @dev refreshStakeBatch re-syncs the stake data with the staking contract
450     /// @param addrs is the list of addresses to refresh their stake
451 	function refreshStakeBatch(address[] calldata addrs) external /* onlyWhenActive */;
452 
453     /// Returns the delegate address of the given address
454     /// @param addr is the address to query
455     /// @return delegation is the address the addr delegated to
456 	function getDelegation(address addr) external view returns (address);
457 
458     /// Returns a delegator info
459     /// @param addr is the address to query
460     /// @return delegation is the address the addr delegated to
461     /// @return delegatorStake is the stake of the delegator as reflected in the delegation contract
462 	function getDelegationInfo(address addr) external view returns (address delegation, uint256 delegatorStake);
463 	
464     /// Returns the delegated stake of an addr 
465     /// @dev an address that is not self delegating has a 0 delegated stake
466     /// @param addr is the address to query
467     /// @return delegatedStake is the address delegated stake
468 	function getDelegatedStake(address addr) external view returns (uint256);
469 
470     /// Returns the total delegated stake
471     /// @dev delegatedStake - the total stake delegated to an address that is self delegating
472     /// @dev the delegated stake of a non self-delegated address is 0
473     /// @return totalDelegatedStake is the total delegatedStake of all the addresses
474 	function getTotalDelegatedStake() external view returns (uint256) ;
475 
476 	/*
477 	 * Governance functions
478 	 */
479 
480 	event DelegationsImported(address[] from, address indexed to);
481 
482 	event DelegationInitialized(address indexed from, address indexed to);
483 
484     /// Imports delegations during initial migration
485     /// @dev initialization function called only by the initializationManager
486     /// @dev Does not update the Rewards or Election contracts
487     /// @dev assumes deactivated Rewards
488     /// @param from is a list of delegator addresses
489     /// @param to is the address the delegators delegate to
490 	function importDelegations(address[] calldata from, address to) external /* onlyMigrationManager onlyDuringDelegationImport */;
491 
492     /// Initializes the delegation of an address during initial migration 
493     /// @dev initialization function called only by the initializationManager
494     /// @dev behaves identically to a delegate transaction sent by the delegator
495     /// @param from is the delegator addresses
496     /// @param to is the delegator delegates to
497 	function initDelegation(address from, address to) external /* onlyInitializationAdmin */;
498 }
499 
500 // File: contracts/IStakeChangeNotifier.sol
501 
502 pragma solidity 0.6.12;
503 
504 /// @title An interface for notifying of stake change events (e.g., stake, unstake, partial unstake, restate, etc.).
505 interface IStakeChangeNotifier {
506     /// @dev Notifies of stake change event.
507     /// @param _stakeOwner address The address of the subject stake owner.
508     /// @param _amount uint256 The difference in the total staked amount.
509     /// @param _sign bool The sign of the added (true) or subtracted (false) amount.
510     /// @param _updatedStake uint256 The updated total staked amount.
511     function stakeChange(address _stakeOwner, uint256 _amount, bool _sign, uint256 _updatedStake) external;
512 
513     /// @dev Notifies of multiple stake change events.
514     /// @param _stakeOwners address[] The addresses of subject stake owners.
515     /// @param _amounts uint256[] The differences in total staked amounts.
516     /// @param _signs bool[] The signs of the added (true) or subtracted (false) amounts.
517     /// @param _updatedStakes uint256[] The updated total staked amounts.
518     function stakeChangeBatch(address[] calldata _stakeOwners, uint256[] calldata _amounts, bool[] calldata _signs,
519         uint256[] calldata _updatedStakes) external;
520 
521     /// @dev Notifies of stake migration event.
522     /// @param _stakeOwner address The address of the subject stake owner.
523     /// @param _amount uint256 The migrated amount.
524     function stakeMigration(address _stakeOwner, uint256 _amount) external;
525 }
526 
527 // File: contracts/spec_interfaces/IStakingContractHandler.sol
528 
529 pragma solidity 0.6.12;
530 
531 /// @title Staking contract handler contract interface in addition to IStakeChangeNotifier
532 interface IStakingContractHandler {
533     event StakeChangeNotificationSkipped(address indexed stakeOwner);
534     event StakeChangeBatchNotificationSkipped(address[] stakeOwners);
535     event StakeMigrationNotificationSkipped(address indexed stakeOwner);
536 
537     /*
538     * External functions
539     */
540 
541     /// Returns the stake of the specified stake owner (excluding unstaked tokens).
542     /// @param stakeOwner address The address to check.
543     /// @return uint256 The total stake.
544     function getStakeBalanceOf(address stakeOwner) external view returns (uint256);
545 
546     /// Returns the total amount staked tokens (excluding unstaked tokens).
547     /// @return uint256 is the total staked tokens of all stake owners.
548     function getTotalStakedTokens() external view returns (uint256);
549 
550     /*
551     * Governance functions
552     */
553 
554     event NotifyDelegationsChanged(bool notifyDelegations);
555 
556     /// Sets notifications to the delegation contract
557     /// @dev staking while notifications are disabled may lead to a discrepancy in the delegation data  
558     /// @dev governance function called only by the migration manager
559     /// @param notifyDelegations is a bool indicating whether to notify the delegation contract
560     function setNotifyDelegations(bool notifyDelegations) external; /* onlyMigrationManager */
561 
562     /// Returns the notifications to the delegation contract status
563     /// @return notifyDelegations is a bool indicating whether notifications are enabled
564     function getNotifyDelegations() external view returns (bool);
565 }
566 
567 // File: contracts/spec_interfaces/IStakingRewards.sol
568 
569 pragma solidity 0.6.12;
570 
571 /// @title Staking rewards contract interface
572 interface IStakingRewards {
573 
574     event DelegatorStakingRewardsAssigned(address indexed delegator, uint256 amount, uint256 totalAwarded, address guardian, uint256 delegatorRewardsPerToken, uint256 delegatorRewardsPerTokenDelta);
575     event GuardianStakingRewardsAssigned(address indexed guardian, uint256 amount, uint256 totalAwarded, uint256 delegatorRewardsPerToken, uint256 delegatorRewardsPerTokenDelta, uint256 stakingRewardsPerWeight, uint256 stakingRewardsPerWeightDelta);
576     event StakingRewardsClaimed(address indexed addr, uint256 claimedDelegatorRewards, uint256 claimedGuardianRewards, uint256 totalClaimedDelegatorRewards, uint256 totalClaimedGuardianRewards);
577     event StakingRewardsAllocated(uint256 allocatedRewards, uint256 stakingRewardsPerWeight);
578     event GuardianDelegatorsStakingRewardsPercentMilleUpdated(address indexed guardian, uint256 delegatorsStakingRewardsPercentMille);
579 
580     /*
581      * External functions
582      */
583 
584     /// Returns the current reward balance of the given address.
585     /// @dev calculates the up to date balances (differ from the state)
586     /// @param addr is the address to query
587     /// @return delegatorStakingRewardsBalance the rewards awarded to the guardian role
588     /// @return guardianStakingRewardsBalance the rewards awarded to the guardian role
589     function getStakingRewardsBalance(address addr) external view returns (uint256 delegatorStakingRewardsBalance, uint256 guardianStakingRewardsBalance);
590 
591     /// Claims the staking rewards balance of an addr, staking the rewards
592     /// @dev Claimed rewards are staked in the staking contract using the distributeRewards interface
593     /// @dev includes the rewards for both the delegator and guardian roles
594     /// @dev calculates the up to date rewards prior to distribute them to the staking contract
595     /// @param addr is the address to claim rewards for
596     function claimStakingRewards(address addr) external;
597 
598     /// Returns the current global staking rewards state
599     /// @dev calculated to the latest block, may differ from the state read
600     /// @return stakingRewardsPerWeight is the potential reward per 1E18 (TOKEN_BASE) committee weight assigned to a guardian was in the committee from day zero
601     /// @return unclaimedStakingRewards is the of tokens that were assigned to participants and not claimed yet
602     function getStakingRewardsState() external view returns (
603         uint96 stakingRewardsPerWeight,
604         uint96 unclaimedStakingRewards
605     );
606 
607     /// Returns the current guardian staking rewards state
608     /// @dev calculated to the latest block, may differ from the state read
609     /// @dev notice that the guardian rewards are the rewards for the guardian role as guardian and do not include delegation rewards
610     /// @dev use getDelegatorStakingRewardsData to get the guardian's rewards as delegator
611     /// @param guardian is the guardian to query
612     /// @return balance is the staking rewards balance for the guardian role
613     /// @return claimed is the staking rewards for the guardian role that were claimed
614     /// @return delegatorRewardsPerToken is the potential reward per token (1E18 units) assigned to a guardian's delegator that delegated from day zero
615     /// @return delegatorRewardsPerTokenDelta is the increment in delegatorRewardsPerToken since the last guardian update
616     /// @return lastStakingRewardsPerWeight is the up to date stakingRewardsPerWeight used for the guardian state calculation
617     /// @return stakingRewardsPerWeightDelta is the increment in stakingRewardsPerWeight since the last guardian update
618     function getGuardianStakingRewardsData(address guardian) external view returns (
619         uint256 balance,
620         uint256 claimed,
621         uint256 delegatorRewardsPerToken,
622         uint256 delegatorRewardsPerTokenDelta,
623         uint256 lastStakingRewardsPerWeight,
624         uint256 stakingRewardsPerWeightDelta
625     );
626 
627     /// Returns the current delegator staking rewards state
628     /// @dev calculated to the latest block, may differ from the state read
629     /// @param delegator is the delegator to query
630     /// @return balance is the staking rewards balance for the delegator role
631     /// @return claimed is the staking rewards for the delegator role that were claimed
632     /// @return guardian is the guardian the delegator delegated to receiving a portion of the guardian staking rewards
633     /// @return lastDelegatorRewardsPerToken is the up to date delegatorRewardsPerToken used for the delegator state calculation
634     /// @return delegatorRewardsPerTokenDelta is the increment in delegatorRewardsPerToken since the last delegator update
635     function getDelegatorStakingRewardsData(address delegator) external view returns (
636         uint256 balance,
637         uint256 claimed,
638         address guardian,
639         uint256 lastDelegatorRewardsPerToken,
640         uint256 delegatorRewardsPerTokenDelta
641     );
642 
643     /// Returns an estimation for the delegator and guardian staking rewards for a given duration
644     /// @dev the returned value is an estimation, assuming no change in the PoS state
645     /// @dev the period calculated for start from the current block time until the current time + duration.
646     /// @param addr is the address to estimate rewards for
647     /// @param duration is the duration to calculate for in seconds
648     /// @return estimatedDelegatorStakingRewards is the estimated reward for the delegator role
649     /// @return estimatedGuardianStakingRewards is the estimated reward for the guardian role
650     function estimateFutureRewards(address addr, uint256 duration) external view returns (
651         uint256 estimatedDelegatorStakingRewards,
652         uint256 estimatedGuardianStakingRewards
653     );
654 
655     /// Sets the guardian's delegators staking reward portion
656     /// @dev by default uses the defaultDelegatorsStakingRewardsPercentMille
657     /// @param delegatorRewardsPercentMille is the delegators portion in percent-mille (0 - maxDelegatorsStakingRewardsPercentMille)
658     function setGuardianDelegatorsStakingRewardsPercentMille(uint32 delegatorRewardsPercentMille) external;
659 
660     /// Returns a guardian's delegators staking reward portion
661     /// @dev If not explicitly set, returns the defaultDelegatorsStakingRewardsPercentMille
662     /// @return delegatorRewardsRatioPercentMille is the delegators portion in percent-mille
663     function getGuardianDelegatorsStakingRewardsPercentMille(address guardian) external view returns (uint256 delegatorRewardsRatioPercentMille);
664 
665     /// Returns the amount of ORBS tokens in the staking rewards wallet allocated to staking rewards
666     /// @dev The staking wallet balance must always larger than the allocated value
667     /// @return allocated is the amount of tokens allocated in the staking rewards wallet
668     function getStakingRewardsWalletAllocatedTokens() external view returns (uint256 allocated);
669 
670     /// Returns the current annual staking reward rate
671     /// @dev calculated based on the current total committee weight
672     /// @return annualRate is the current staking reward rate in percent-mille
673     function getCurrentStakingRewardsRatePercentMille() external view returns (uint256 annualRate);
674 
675     /// Notifies an expected change in the committee membership of the guardian
676     /// @dev Called only by: the Committee contract
677     /// @dev called upon expected change in the committee membership of the guardian
678     /// @dev triggers update of the global rewards state and the guardian rewards state
679     /// @dev updates the rewards state based on the committee state prior to the change
680     /// @param guardian is the guardian who's committee membership is updated
681     /// @param weight is the weight of the guardian prior to the change
682     /// @param totalCommitteeWeight is the total committee weight prior to the change
683     /// @param inCommittee indicates whether the guardian was in the committee prior to the change
684     /// @param inCommitteeAfter indicates whether the guardian is in the committee after the change
685     function committeeMembershipWillChange(address guardian, uint256 weight, uint256 totalCommitteeWeight, bool inCommittee, bool inCommitteeAfter) external /* onlyCommitteeContract */;
686 
687     /// Notifies an expected change in a delegator and his guardian delegation state
688     /// @dev Called only by: the Delegation contract
689     /// @dev called upon expected change in a delegator's delegation state
690     /// @dev triggers update of the global rewards state, the guardian rewards state and the delegator rewards state
691     /// @dev on delegation change, updates also the new guardian and the delegator's lastDelegatorRewardsPerToken accordingly
692     /// @param guardian is the delegator's guardian prior to the change
693     /// @param guardianDelegatedStake is the delegated stake of the delegator's guardian prior to the change
694     /// @param delegator is the delegator about to change delegation state
695     /// @param delegatorStake is the stake of the delegator
696     /// @param nextGuardian is the delegator's guardian after to the change
697     /// @param nextGuardianDelegatedStake is the delegated stake of the delegator's guardian after to the change
698     function delegationWillChange(address guardian, uint256 guardianDelegatedStake, address delegator, uint256 delegatorStake, address nextGuardian, uint256 nextGuardianDelegatedStake) external /* onlyDelegationsContract */;
699 
700     /*
701      * Governance functions
702      */
703 
704     event AnnualStakingRewardsRateChanged(uint256 annualRateInPercentMille, uint256 annualCap);
705     event DefaultDelegatorsStakingRewardsChanged(uint32 defaultDelegatorsStakingRewardsPercentMille);
706     event MaxDelegatorsStakingRewardsChanged(uint32 maxDelegatorsStakingRewardsPercentMille);
707     event RewardDistributionActivated(uint256 startTime);
708     event RewardDistributionDeactivated();
709     event StakingRewardsBalanceMigrated(address indexed addr, uint256 guardianStakingRewards, uint256 delegatorStakingRewards, address toRewardsContract);
710     event StakingRewardsBalanceMigrationAccepted(address from, address indexed addr, uint256 guardianStakingRewards, uint256 delegatorStakingRewards);
711     event EmergencyWithdrawal(address addr, address token);
712 
713     /// Activates staking rewards allocation
714     /// @dev governance function called only by the initialization admin
715     /// @dev On migrations, startTime should be set to the previous contract deactivation time
716     /// @param startTime sets the last assignment time
717     function activateRewardDistribution(uint startTime) external /* onlyInitializationAdmin */;
718 
719     /// Deactivates fees and bootstrap allocation
720     /// @dev governance function called only by the migration manager
721     /// @dev guardians updates remain active based on the current perMember value
722     function deactivateRewardDistribution() external /* onlyMigrationManager */;
723     
724     /// Sets the default delegators staking reward portion
725     /// @dev governance function called only by the functional manager
726     /// @param defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille(0 - maxDelegatorsStakingRewardsPercentMille)
727     function setDefaultDelegatorsStakingRewardsPercentMille(uint32 defaultDelegatorsStakingRewardsPercentMille) external /* onlyFunctionalManager */;
728 
729     /// Returns the default delegators staking reward portion
730     /// @return defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille
731     function getDefaultDelegatorsStakingRewardsPercentMille() external view returns (uint32);
732 
733     /// Sets the maximum delegators staking reward portion
734     /// @dev governance function called only by the functional manager
735     /// @param maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille(0 - 100,000)
736     function setMaxDelegatorsStakingRewardsPercentMille(uint32 maxDelegatorsStakingRewardsPercentMille) external /* onlyFunctionalManager */;
737 
738     /// Returns the default delegators staking reward portion
739     /// @return maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille
740     function getMaxDelegatorsStakingRewardsPercentMille() external view returns (uint32);
741 
742     /// Sets the annual rate and cap for the staking reward
743     /// @dev governance function called only by the functional manager
744     /// @param annualRateInPercentMille is the annual rate in percent-mille
745     /// @param annualCap is the annual staking rewards cap
746     function setAnnualStakingRewardsRate(uint32 annualRateInPercentMille, uint96 annualCap) external /* onlyFunctionalManager */;
747 
748     /// Returns the annual staking reward rate
749     /// @return annualStakingRewardsRatePercentMille is the annual rate in percent-mille
750     function getAnnualStakingRewardsRatePercentMille() external view returns (uint32);
751 
752     /// Returns the annual staking rewards cap
753     /// @return annualStakingRewardsCap is the annual rate in percent-mille
754     function getAnnualStakingRewardsCap() external view returns (uint256);
755 
756     /// Checks if rewards allocation is active
757     /// @return rewardAllocationActive is a bool that indicates that rewards allocation is active
758     function isRewardAllocationActive() external view returns (bool);
759 
760     /// Returns the contract's settings
761     /// @return annualStakingRewardsCap is the annual rate in percent-mille
762     /// @return annualStakingRewardsRatePercentMille is the annual rate in percent-mille
763     /// @return defaultDelegatorsStakingRewardsPercentMille is the default delegators portion in percent-mille
764     /// @return maxDelegatorsStakingRewardsPercentMille is the maximum delegators portion in percent-mille
765     /// @return rewardAllocationActive is a bool that indicates that rewards allocation is active
766     function getSettings() external view returns (
767         uint annualStakingRewardsCap,
768         uint32 annualStakingRewardsRatePercentMille,
769         uint32 defaultDelegatorsStakingRewardsPercentMille,
770         uint32 maxDelegatorsStakingRewardsPercentMille,
771         bool rewardAllocationActive
772     );
773 
774     /// Migrates the staking rewards balance of the given addresses to a new staking rewards contract
775     /// @dev The new rewards contract is determined according to the contracts registry
776     /// @dev No impact of the calling contract if the currently configured contract in the registry
777     /// @dev may be called also while the contract is locked
778     /// @param addrs is the list of addresses to migrate
779     function migrateRewardsBalance(address[] calldata addrs) external;
780 
781     /// Accepts addresses balance migration from a previous rewards contract
782     /// @dev the function may be called by any caller that approves the amounts provided for transfer
783     /// @param addrs is the list migrated addresses
784     /// @param migratedGuardianStakingRewards is the list of received guardian rewards balance for each address
785     /// @param migratedDelegatorStakingRewards is the list of received delegator rewards balance for each address
786     /// @param totalAmount is the total amount of staking rewards migrated for all addresses in the list. Must match the sum of migratedGuardianStakingRewards and migratedDelegatorStakingRewards lists.
787     function acceptRewardsBalanceMigration(address[] calldata addrs, uint256[] calldata migratedGuardianStakingRewards, uint256[] calldata migratedDelegatorStakingRewards, uint256 totalAmount) external;
788 
789     /// Performs emergency withdrawal of the contract balance
790     /// @dev called with a token to withdraw, should be called twice with the fees and bootstrap tokens
791     /// @dev governance function called only by the migration manager
792     /// @param erc20 is the ERC20 token to withdraw
793     function emergencyWithdraw(address erc20) external /* onlyMigrationManager */;
794 }
795 
796 // File: contracts/spec_interfaces/IManagedContract.sol
797 
798 pragma solidity 0.6.12;
799 
800 /// @title managed contract interface, used by the contracts registry to notify the contract on updates
801 interface IManagedContract /* is ILockable, IContractRegistryAccessor, Initializable */ {
802 
803     /// Refreshes the address of the other contracts the contract interacts with
804     /// @dev called by the registry contract upon an update of a contract in the registry
805     function refreshContracts() external;
806 
807 }
808 
809 // File: contracts/spec_interfaces/IContractRegistry.sol
810 
811 pragma solidity 0.6.12;
812 
813 /// @title Contract registry contract interface
814 /// @dev The contract registry holds Orbs PoS contracts and managers lists
815 /// @dev The contract registry updates the managed contracts on changes in the contract list
816 /// @dev Governance functions restricted to managers access the registry to retrieve the manager address 
817 /// @dev The contract registry represents the source of truth for Orbs Ethereum contracts 
818 /// @dev By tracking the registry events or query before interaction, one can access the up to date contracts 
819 interface IContractRegistry {
820 
821 	event ContractAddressUpdated(string contractName, address addr, bool managedContract);
822 	event ManagerChanged(string role, address newManager);
823 	event ContractRegistryUpdated(address newContractRegistry);
824 
825 	/*
826 	* External functions
827 	*/
828 
829     /// Updates the contracts address and emits a corresponding event
830     /// @dev governance function called only by the migrationManager or registryAdmin
831     /// @param contractName is the contract name, used to identify it
832     /// @param addr is the contract updated address
833     /// @param managedContract indicates whether the contract is managed by the registry and notified on changes
834 	function setContract(string calldata contractName, address addr, bool managedContract) external /* onlyAdminOrMigrationManager */;
835 
836     /// Returns the current address of the given contracts
837     /// @param contractName is the contract name, used to identify it
838     /// @return addr is the contract updated address
839 	function getContract(string calldata contractName) external view returns (address);
840 
841     /// Returns the list of contract addresses managed by the registry
842     /// @dev Managed contracts are updated on changes in the registry contracts addresses 
843     /// @return addrs is the list of managed contracts
844 	function getManagedContracts() external view returns (address[] memory);
845 
846     /// Locks all the managed contracts 
847     /// @dev governance function called only by the migrationManager or registryAdmin
848     /// @dev When set all onlyWhenActive functions will revert
849 	function lockContracts() external /* onlyAdminOrMigrationManager */;
850 
851     /// Unlocks all the managed contracts 
852     /// @dev governance function called only by the migrationManager or registryAdmin
853 	function unlockContracts() external /* onlyAdminOrMigrationManager */;
854 	
855     /// Updates a manager address and emits a corresponding event
856     /// @dev governance function called only by the registryAdmin
857     /// @dev the managers list is a flexible list of role to the manager's address
858     /// @param role is the managers' role name, for example "functionalManager"
859     /// @param manager is the manager updated address
860 	function setManager(string calldata role, address manager) external /* onlyAdmin */;
861 
862     /// Returns the current address of the given manager
863     /// @param role is the manager name, used to identify it
864     /// @return addr is the manager updated address
865 	function getManager(string calldata role) external view returns (address);
866 
867     /// Sets a new contract registry to migrate to
868     /// @dev governance function called only by the registryAdmin
869     /// @dev updates the registry address record in all the managed contracts
870     /// @dev by tracking the emitted ContractRegistryUpdated, tools can track the up to date contracts
871     /// @param newRegistry is the new registry contract 
872 	function setNewContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;
873 
874     /// Returns the previous contract registry address 
875     /// @dev used when the setting the contract as a new registry to assure a valid registry
876     /// @return previousContractRegistry is the previous contract registry
877 	function getPreviousContractRegistry() external view returns (address);
878 }
879 
880 // File: contracts/spec_interfaces/IContractRegistryAccessor.sol
881 
882 pragma solidity 0.6.12;
883 
884 
885 interface IContractRegistryAccessor {
886 
887     /// Sets the contract registry address
888     /// @dev governance function called only by an admin
889     /// @param newRegistry is the new registry contract 
890     function setContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;
891 
892     /// Returns the contract registry address
893     /// @return contractRegistry is the contract registry address
894     function getContractRegistry() external view returns (IContractRegistry contractRegistry);
895 
896     function setRegistryAdmin(address _registryAdmin) external /* onlyInitializationAdmin */;
897 
898 }
899 
900 // File: @openzeppelin/contracts/GSN/Context.sol
901 
902 pragma solidity ^0.6.0;
903 
904 /*
905  * @dev Provides information about the current execution context, including the
906  * sender of the transaction and its data. While these are generally available
907  * via msg.sender and msg.data, they should not be accessed in such a direct
908  * manner, since when dealing with GSN meta-transactions the account sending and
909  * paying for execution may not be the actual sender (as far as an application
910  * is concerned).
911  *
912  * This contract is only required for intermediate, library-like contracts.
913  */
914 abstract contract Context {
915     function _msgSender() internal view virtual returns (address payable) {
916         return msg.sender;
917     }
918 
919     function _msgData() internal view virtual returns (bytes memory) {
920         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
921         return msg.data;
922     }
923 }
924 
925 // File: contracts/WithClaimableRegistryManagement.sol
926 
927 pragma solidity 0.6.12;
928 
929 
930 /**
931  * @title Claimable
932  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
933  * This allows the new owner to accept the transfer.
934  */
935 contract WithClaimableRegistryManagement is Context {
936     address private _registryAdmin;
937     address private _pendingRegistryAdmin;
938 
939     event RegistryManagementTransferred(address indexed previousRegistryAdmin, address indexed newRegistryAdmin);
940 
941     /**
942      * @dev Initializes the contract setting the deployer as the initial registryRegistryAdmin.
943      */
944     constructor () internal {
945         address msgSender = _msgSender();
946         _registryAdmin = msgSender;
947         emit RegistryManagementTransferred(address(0), msgSender);
948     }
949 
950     /**
951      * @dev Returns the address of the current registryAdmin.
952      */
953     function registryAdmin() public view returns (address) {
954         return _registryAdmin;
955     }
956 
957     /**
958      * @dev Throws if called by any account other than the registryAdmin.
959      */
960     modifier onlyRegistryAdmin() {
961         require(isRegistryAdmin(), "WithClaimableRegistryManagement: caller is not the registryAdmin");
962         _;
963     }
964 
965     /**
966      * @dev Returns true if the caller is the current registryAdmin.
967      */
968     function isRegistryAdmin() public view returns (bool) {
969         return _msgSender() == _registryAdmin;
970     }
971 
972     /**
973      * @dev Leaves the contract without registryAdmin. It will not be possible to call
974      * `onlyManager` functions anymore. Can only be called by the current registryAdmin.
975      *
976      * NOTE: Renouncing registryManagement will leave the contract without an registryAdmin,
977      * thereby removing any functionality that is only available to the registryAdmin.
978      */
979     function renounceRegistryManagement() public onlyRegistryAdmin {
980         emit RegistryManagementTransferred(_registryAdmin, address(0));
981         _registryAdmin = address(0);
982     }
983 
984     /**
985      * @dev Transfers registryManagement of the contract to a new account (`newManager`).
986      */
987     function _transferRegistryManagement(address newRegistryAdmin) internal {
988         require(newRegistryAdmin != address(0), "RegistryAdmin: new registryAdmin is the zero address");
989         emit RegistryManagementTransferred(_registryAdmin, newRegistryAdmin);
990         _registryAdmin = newRegistryAdmin;
991     }
992 
993     /**
994      * @dev Modifier throws if called by any account other than the pendingManager.
995      */
996     modifier onlyPendingRegistryAdmin() {
997         require(msg.sender == _pendingRegistryAdmin, "Caller is not the pending registryAdmin");
998         _;
999     }
1000     /**
1001      * @dev Allows the current registryAdmin to set the pendingManager address.
1002      * @param newRegistryAdmin The address to transfer registryManagement to.
1003      */
1004     function transferRegistryManagement(address newRegistryAdmin) public onlyRegistryAdmin {
1005         _pendingRegistryAdmin = newRegistryAdmin;
1006     }
1007 
1008     /**
1009      * @dev Allows the _pendingRegistryAdmin address to finalize the transfer.
1010      */
1011     function claimRegistryManagement() external onlyPendingRegistryAdmin {
1012         _transferRegistryManagement(_pendingRegistryAdmin);
1013         _pendingRegistryAdmin = address(0);
1014     }
1015 
1016     /**
1017      * @dev Returns the current pendingRegistryAdmin
1018     */
1019     function pendingRegistryAdmin() public view returns (address) {
1020        return _pendingRegistryAdmin;  
1021     }
1022 }
1023 
1024 // File: contracts/Initializable.sol
1025 
1026 pragma solidity 0.6.12;
1027 
1028 contract Initializable {
1029 
1030     address private _initializationAdmin;
1031 
1032     event InitializationComplete();
1033 
1034     /// Constructor
1035     /// Sets the initializationAdmin to the contract deployer
1036     /// The initialization admin may call any manager only function until initializationComplete
1037     constructor() public{
1038         _initializationAdmin = msg.sender;
1039     }
1040 
1041     modifier onlyInitializationAdmin() {
1042         require(msg.sender == initializationAdmin(), "sender is not the initialization admin");
1043 
1044         _;
1045     }
1046 
1047     /*
1048     * External functions
1049     */
1050 
1051     /// Returns the initializationAdmin address
1052     function initializationAdmin() public view returns (address) {
1053         return _initializationAdmin;
1054     }
1055 
1056     /// Finalizes the initialization and revokes the initializationAdmin role 
1057     function initializationComplete() external onlyInitializationAdmin {
1058         _initializationAdmin = address(0);
1059         emit InitializationComplete();
1060     }
1061 
1062     /// Checks if the initialization was completed
1063     function isInitializationComplete() public view returns (bool) {
1064         return _initializationAdmin == address(0);
1065     }
1066 
1067 }
1068 
1069 // File: contracts/ContractRegistryAccessor.sol
1070 
1071 pragma solidity 0.6.12;
1072 
1073 
1074 
1075 
1076 
1077 contract ContractRegistryAccessor is IContractRegistryAccessor, WithClaimableRegistryManagement, Initializable {
1078 
1079     IContractRegistry private contractRegistry;
1080 
1081     /// Constructor
1082     /// @param _contractRegistry is the contract registry address
1083     /// @param _registryAdmin is the registry admin address
1084     constructor(IContractRegistry _contractRegistry, address _registryAdmin) public {
1085         require(address(_contractRegistry) != address(0), "_contractRegistry cannot be 0");
1086         setContractRegistry(_contractRegistry);
1087         _transferRegistryManagement(_registryAdmin);
1088     }
1089 
1090     modifier onlyAdmin {
1091         require(isAdmin(), "sender is not an admin (registryManger or initializationAdmin)");
1092 
1093         _;
1094     }
1095 
1096     modifier onlyMigrationManager {
1097         require(isMigrationManager(), "sender is not the migration manager");
1098 
1099         _;
1100     }
1101 
1102     modifier onlyFunctionalManager {
1103         require(isFunctionalManager(), "sender is not the functional manager");
1104 
1105         _;
1106     }
1107 
1108     /// Checks whether the caller is Admin: either the contract registry, the registry admin, or the initialization admin
1109     function isAdmin() internal view returns (bool) {
1110         return msg.sender == address(contractRegistry) || msg.sender == registryAdmin() || msg.sender == initializationAdmin();
1111     }
1112 
1113     /// Checks whether the caller is a specific manager role or and Admin
1114     /// @dev queries the registry contract for the up to date manager assignment
1115     function isManager(string memory role) internal view returns (bool) {
1116         IContractRegistry _contractRegistry = contractRegistry;
1117         return isAdmin() || _contractRegistry != IContractRegistry(0) && contractRegistry.getManager(role) == msg.sender;
1118     }
1119 
1120     /// Checks whether the caller is the migration manager
1121     function isMigrationManager() internal view returns (bool) {
1122         return isManager('migrationManager');
1123     }
1124 
1125     /// Checks whether the caller is the functional manager
1126     function isFunctionalManager() internal view returns (bool) {
1127         return isManager('functionalManager');
1128     }
1129 
1130     /* 
1131      * Contract getters, return the address of a contract by calling the contract registry 
1132      */ 
1133 
1134     function getProtocolContract() internal view returns (address) {
1135         return contractRegistry.getContract("protocol");
1136     }
1137 
1138     function getStakingRewardsContract() internal view returns (address) {
1139         return contractRegistry.getContract("stakingRewards");
1140     }
1141 
1142     function getFeesAndBootstrapRewardsContract() internal view returns (address) {
1143         return contractRegistry.getContract("feesAndBootstrapRewards");
1144     }
1145 
1146     function getCommitteeContract() internal view returns (address) {
1147         return contractRegistry.getContract("committee");
1148     }
1149 
1150     function getElectionsContract() internal view returns (address) {
1151         return contractRegistry.getContract("elections");
1152     }
1153 
1154     function getDelegationsContract() internal view returns (address) {
1155         return contractRegistry.getContract("delegations");
1156     }
1157 
1158     function getGuardiansRegistrationContract() internal view returns (address) {
1159         return contractRegistry.getContract("guardiansRegistration");
1160     }
1161 
1162     function getCertificationContract() internal view returns (address) {
1163         return contractRegistry.getContract("certification");
1164     }
1165 
1166     function getStakingContract() internal view returns (address) {
1167         return contractRegistry.getContract("staking");
1168     }
1169 
1170     function getSubscriptionsContract() internal view returns (address) {
1171         return contractRegistry.getContract("subscriptions");
1172     }
1173 
1174     function getStakingRewardsWallet() internal view returns (address) {
1175         return contractRegistry.getContract("stakingRewardsWallet");
1176     }
1177 
1178     function getBootstrapRewardsWallet() internal view returns (address) {
1179         return contractRegistry.getContract("bootstrapRewardsWallet");
1180     }
1181 
1182     function getGeneralFeesWallet() internal view returns (address) {
1183         return contractRegistry.getContract("generalFeesWallet");
1184     }
1185 
1186     function getCertifiedFeesWallet() internal view returns (address) {
1187         return contractRegistry.getContract("certifiedFeesWallet");
1188     }
1189 
1190     function getStakingContractHandler() internal view returns (address) {
1191         return contractRegistry.getContract("stakingContractHandler");
1192     }
1193 
1194     /*
1195     * Governance functions
1196     */
1197 
1198     event ContractRegistryAddressUpdated(address addr);
1199 
1200     /// Sets the contract registry address
1201     /// @dev governance function called only by an admin
1202     /// @param newContractRegistry is the new registry contract 
1203     function setContractRegistry(IContractRegistry newContractRegistry) public override onlyAdmin {
1204         require(newContractRegistry.getPreviousContractRegistry() == address(contractRegistry), "new contract registry must provide the previous contract registry");
1205         contractRegistry = newContractRegistry;
1206         emit ContractRegistryAddressUpdated(address(newContractRegistry));
1207     }
1208 
1209     /// Returns the contract registry that the contract is set to use
1210     /// @return contractRegistry is the registry contract address
1211     function getContractRegistry() public override view returns (IContractRegistry) {
1212         return contractRegistry;
1213     }
1214 
1215     function setRegistryAdmin(address _registryAdmin) external override onlyInitializationAdmin {
1216         _transferRegistryManagement(_registryAdmin);
1217     }
1218 
1219 }
1220 
1221 // File: contracts/spec_interfaces/ILockable.sol
1222 
1223 pragma solidity 0.6.12;
1224 
1225 /// @title lockable contract interface, allows to lock a contract
1226 interface ILockable {
1227 
1228     event Locked();
1229     event Unlocked();
1230 
1231     /// Locks the contract to external non-governance function calls
1232     /// @dev governance function called only by the migration manager or an admin
1233     /// @dev typically called by the registry contract upon locking all managed contracts
1234     /// @dev getters and migration functions remain active also for locked contracts
1235     /// @dev checked by the onlyWhenActive modifier
1236     function lock() external /* onlyMigrationManager */;
1237 
1238     /// Unlocks the contract 
1239     /// @dev governance function called only by the migration manager or an admin
1240     /// @dev typically called by the registry contract upon unlocking all managed contracts
1241     function unlock() external /* onlyMigrationManager */;
1242 
1243     /// Returns the contract locking status
1244     /// @return isLocked is a bool indicating the contract is locked 
1245     function isLocked() view external returns (bool);
1246 
1247 }
1248 
1249 // File: contracts/Lockable.sol
1250 
1251 pragma solidity 0.6.12;
1252 
1253 
1254 
1255 /// @title lockable contract
1256 contract Lockable is ILockable, ContractRegistryAccessor {
1257 
1258     bool public locked;
1259 
1260     /// Constructor
1261     /// @param _contractRegistry is the contract registry address
1262     /// @param _registryAdmin is the registry admin address
1263     constructor(IContractRegistry _contractRegistry, address _registryAdmin) ContractRegistryAccessor(_contractRegistry, _registryAdmin) public {}
1264 
1265     /// Locks the contract to external non-governance function calls
1266     /// @dev governance function called only by the migration manager or an admin
1267     /// @dev typically called by the registry contract upon locking all managed contracts
1268     /// @dev getters and migration functions remain active also for locked contracts
1269     /// @dev checked by the onlyWhenActive modifier
1270     function lock() external override onlyMigrationManager {
1271         locked = true;
1272         emit Locked();
1273     }
1274 
1275     /// Unlocks the contract 
1276     /// @dev governance function called only by the migration manager or an admin
1277     /// @dev typically called by the registry contract upon unlocking all managed contracts
1278     function unlock() external override onlyMigrationManager {
1279         locked = false;
1280         emit Unlocked();
1281     }
1282 
1283     /// Returns the contract locking status
1284     /// @return isLocked is a bool indicating the contract is locked 
1285     function isLocked() external override view returns (bool) {
1286         return locked;
1287     }
1288 
1289     modifier onlyWhenActive() {
1290         require(!locked, "contract is locked for this operation");
1291 
1292         _;
1293     }
1294 }
1295 
1296 // File: contracts/ManagedContract.sol
1297 
1298 pragma solidity 0.6.12;
1299 
1300 
1301 
1302 /// @title managed contract
1303 contract ManagedContract is IManagedContract, Lockable {
1304 
1305     /// @param _contractRegistry is the contract registry address
1306     /// @param _registryAdmin is the registry admin address
1307     constructor(IContractRegistry _contractRegistry, address _registryAdmin) Lockable(_contractRegistry, _registryAdmin) public {}
1308 
1309     /// Refreshes the address of the other contracts the contract interacts with
1310     /// @dev called by the registry contract upon an update of a contract in the registry
1311     function refreshContracts() virtual override external {}
1312 
1313 }
1314 
1315 // File: contracts/Delegations.sol
1316 
1317 pragma solidity 0.6.12;
1318 
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 
1327 /// @title Delegations contract
1328 contract Delegations is IDelegations, IStakeChangeNotifier, ManagedContract {
1329 	using SafeMath for uint256;
1330 	using SafeMath96 for uint96;
1331 
1332 	address constant public VOID_ADDR = address(-1);
1333 
1334 	struct StakeOwnerData {
1335 		address delegation;
1336 		uint96 stake;
1337 	}
1338 	mapping(address => StakeOwnerData) public stakeOwnersData;
1339 	mapping(address => uint256) public uncappedDelegatedStake;
1340 
1341 	uint256 totalDelegatedStake;
1342 
1343 	struct DelegateStatus {
1344 		address addr;
1345 		uint256 uncappedDelegatedStake;
1346 		bool isSelfDelegating;
1347 		uint256 delegatedStake;
1348 		uint96 selfDelegatedStake;
1349 	}
1350 
1351     /// Constructor
1352     /// @param _contractRegistry is the contract registry address
1353     /// @param _registryAdmin is the registry admin address
1354 	constructor(IContractRegistry _contractRegistry, address _registryAdmin) ManagedContract(_contractRegistry, _registryAdmin) public {
1355 		address VOID_ADDRESS_DUMMY_DELEGATION = address(-2);
1356 		assert(VOID_ADDR != VOID_ADDRESS_DUMMY_DELEGATION && VOID_ADDR != address(0) && VOID_ADDRESS_DUMMY_DELEGATION != address(0));
1357 		stakeOwnersData[VOID_ADDR].delegation = VOID_ADDRESS_DUMMY_DELEGATION;
1358 	}
1359 
1360 	modifier onlyStakingContractHandler() {
1361 		require(msg.sender == address(stakingContractHandler), "caller is not the staking contract handler");
1362 
1363 		_;
1364 	}
1365 
1366 	/*
1367 	* External functions
1368 	*/
1369 
1370     /// Delegate your stake
1371     /// @dev updates the election contract on the changes in the delegated stake
1372     /// @dev updates the rewards contract on the upcoming change in the delegator's delegation state
1373     /// @param to is the address to delegate to
1374 	function delegate(address to) external override onlyWhenActive {
1375 		delegateFrom(msg.sender, to);
1376 	}
1377 
1378     /// Refresh the address stake for delegation power based on the staking contract
1379     /// @dev Disabled stake change update notifications from the staking contract may create mismatches
1380     /// @dev refreshStake re-syncs the stake data with the staking contract
1381     /// @param addr is the address to refresh its stake
1382 	function refreshStake(address addr) external override onlyWhenActive {
1383 		_stakeChange(addr, stakingContractHandler.getStakeBalanceOf(addr));
1384 	}
1385 
1386     /// Refresh the addresses stake for delegation power based on the staking contract
1387     /// @dev Batched version of refreshStake
1388     /// @dev Disabled stake change update notifications from the staking contract may create mismatches
1389     /// @dev refreshStakeBatch re-syncs the stake data with the staking contract
1390     /// @param addrs is the list of addresses to refresh their stake
1391 	function refreshStakeBatch(address[] calldata addrs) external override onlyWhenActive {
1392 		for (uint i = 0; i < addrs.length; i++) {
1393 			_stakeChange(addrs[i], stakingContractHandler.getStakeBalanceOf(addrs[i]));
1394 		}
1395 	}
1396 
1397     /// Returns the delegate address of the given address
1398     /// @param addr is the address to query
1399     /// @return delegation is the address the addr delegated to
1400 	function getDelegation(address addr) external override view returns (address) {
1401 		return getStakeOwnerData(addr).delegation;
1402 	}
1403 
1404     /// Returns a delegator info
1405     /// @param addr is the address to query
1406     /// @return delegation is the address the addr delegated to
1407     /// @return delegatorStake is the stake of the delegator as reflected in the delegation contract
1408 	function getDelegationInfo(address addr) external override view returns (address delegation, uint256 delegatorStake) {
1409 		StakeOwnerData memory data = getStakeOwnerData(addr);
1410 		return (data.delegation, data.stake);
1411 	}
1412 
1413     /// Returns the delegated stake of an addr 
1414     /// @dev an address that is not self delegating has a 0 delegated stake
1415     /// @param addr is the address to query
1416     /// @return delegatedStake is the address delegated stake
1417 	function getDelegatedStake(address addr) external override view returns (uint256) {
1418 		return getDelegateStatus(addr).delegatedStake;
1419 	}
1420 
1421     /// Returns the total delegated stake
1422     /// @dev delegatedStake - the total stake delegated to an address that is self delegating
1423     /// @dev the delegated stake of a non self-delegated address is 0
1424     /// @return totalDelegatedStake is the total delegatedStake of all the addresses
1425 	function getTotalDelegatedStake() external override view returns (uint256) {
1426 		return totalDelegatedStake;
1427 	}
1428 
1429 	/*
1430 	* Notifications from staking contract (IStakeChangeNotifier)
1431 	*/
1432 
1433     /// Notifies of stake change event.
1434     /// @param _stakeOwner is the address of the subject stake owner.
1435     /// @param _updatedStake is the updated total staked amount.
1436 	function stakeChange(address _stakeOwner, uint256, bool, uint256 _updatedStake) external override onlyStakingContractHandler onlyWhenActive {
1437 		_stakeChange(_stakeOwner, _updatedStake);
1438 	}
1439 
1440     /// Notifies of multiple stake change events.
1441     /// @param _stakeOwners is the addresses of subject stake owners.
1442     /// @param _amounts is the differences in total staked amounts.
1443     /// @param _signs is the signs of the added (true) or subtracted (false) amounts.
1444     /// @param _updatedStakes is the updated total staked amounts.
1445 	function stakeChangeBatch(address[] calldata _stakeOwners, uint256[] calldata _amounts, bool[] calldata _signs, uint256[] calldata _updatedStakes) external override onlyStakingContractHandler onlyWhenActive {
1446 		uint batchLength = _stakeOwners.length;
1447 		require(batchLength == _amounts.length, "_stakeOwners, _amounts - array length mismatch");
1448 		require(batchLength == _signs.length, "_stakeOwners, _signs - array length mismatch");
1449 		require(batchLength == _updatedStakes.length, "_stakeOwners, _updatedStakes - array length mismatch");
1450 
1451 		for (uint i = 0; i < _stakeOwners.length; i++) {
1452 			_stakeChange(_stakeOwners[i], _updatedStakes[i]);
1453 		}
1454 	}
1455 
1456     /// Notifies of stake migration event.
1457     /// @dev Empty function. A staking contract migration may be handled in the future in the StakingContractHandler 
1458     /// @param _stakeOwner address The address of the subject stake owner.
1459     /// @param _amount uint256 The migrated amount.
1460 	function stakeMigration(address _stakeOwner, uint256 _amount) external override onlyStakingContractHandler onlyWhenActive {}
1461 
1462 	/*
1463 	* Governance functions
1464 	*/
1465 
1466     /// Imports delegations during initial migration
1467     /// @dev initialization function called only by the initializationManager
1468     /// @dev Does not update the Rewards or Election contracts
1469     /// @dev assumes deactivated Rewards
1470     /// @param from is a list of delegator addresses
1471     /// @param to is the address the delegators delegate to
1472 	function importDelegations(address[] calldata from, address to) external override onlyInitializationAdmin {
1473 		require(to != address(0), "to must be a non zero address");
1474 		require(from.length > 0, "from array must contain at least one address");
1475 		(uint96 stakingRewardsPerWeight, ) = stakingRewardsContract.getStakingRewardsState();
1476 		require(stakingRewardsPerWeight == 0, "no rewards may be allocated prior to importing delegations");
1477 
1478 		uint256 uncappedDelegatedStakeDelta = 0;
1479 		StakeOwnerData memory data;
1480 		uint256 newTotalDelegatedStake = totalDelegatedStake;
1481 		DelegateStatus memory delegateStatus = getDelegateStatus(to);
1482 		IStakingContractHandler _stakingContractHandler = stakingContractHandler;
1483 		uint256 delegatorUncapped;
1484 		uint256[] memory delegatorsStakes = new uint256[](from.length);
1485 		for (uint i = 0; i < from.length; i++) {
1486 			data = stakeOwnersData[from[i]];
1487 			require(data.delegation == address(0), "import allowed only for uninitialized accounts. existing delegation detected");
1488 			require(from[i] != to, "import cannot be used for self-delegation (already self delegated)");
1489 			require(data.stake == 0 , "import allowed only for uninitialized accounts. existing stake detected");
1490 
1491 			// from[i] stops being self delegating. any uncappedDelegatedStake it has now stops being counted towards totalDelegatedStake
1492 			delegatorUncapped = uncappedDelegatedStake[from[i]];
1493 			if (delegatorUncapped > 0) {
1494 				newTotalDelegatedStake = newTotalDelegatedStake.sub(delegatorUncapped);
1495 				emit DelegatedStakeChanged(
1496 					from[i],
1497 					0,
1498 					0,
1499 					from[i],
1500 					0
1501 				);
1502 			}
1503 
1504 			// update state
1505 			data.delegation = to;
1506 			data.stake = uint96(_stakingContractHandler.getStakeBalanceOf(from[i]));
1507 			stakeOwnersData[from[i]] = data;
1508 
1509 			uncappedDelegatedStakeDelta = uncappedDelegatedStakeDelta.add(data.stake);
1510 
1511 			// store individual stake for event
1512 			delegatorsStakes[i] = data.stake;
1513 
1514 			emit Delegated(from[i], to);
1515 
1516 			emit DelegatedStakeChanged(
1517 				to,
1518 				delegateStatus.selfDelegatedStake,
1519 				delegateStatus.isSelfDelegating ? delegateStatus.delegatedStake.add(uncappedDelegatedStakeDelta) : 0,
1520 				from[i],
1521 				data.stake
1522 			);
1523 		}
1524 
1525 		// update totals
1526 		uncappedDelegatedStake[to] = uncappedDelegatedStake[to].add(uncappedDelegatedStakeDelta);
1527 
1528 		if (delegateStatus.isSelfDelegating) {
1529 			newTotalDelegatedStake = newTotalDelegatedStake.add(uncappedDelegatedStakeDelta);
1530 		}
1531 		totalDelegatedStake = newTotalDelegatedStake;
1532 
1533 		// emit events
1534 		emit DelegationsImported(from, to);
1535 	}
1536 
1537     /// Initializes the delegation of an address during initial migration 
1538     /// @dev initialization function called only by the initializationManager
1539     /// @dev behaves identically to a delegate transaction sent by the delegator
1540     /// @param from is the delegator addresses
1541     /// @param to is the delegator delegates to
1542 	function initDelegation(address from, address to) external override onlyInitializationAdmin {
1543 		delegateFrom(from, to);
1544 		emit DelegationInitialized(from, to);
1545 	}
1546 
1547 	/*
1548 	* Private functions
1549 	*/
1550 
1551     /// Generates and returns an internal memory structure with a Delegate status
1552     /// @dev updated based on the up to date state
1553     /// @dev status.addr is the queried address
1554     /// @dev status.uncappedDelegatedStake is the amount delegated to address including self-delegated stake
1555     /// @dev status.isSelfDelegating indicates whether the address is self-delegated
1556     /// @dev status.selfDelegatedStake if the addr is self-delegated is  the addr self stake. 0 if not self-delegated
1557     /// @dev status.delegatedStake if the addr is self-delegated is the mount delegated to address. 0 if not self-delegated
1558 	function getDelegateStatus(address addr) private view returns (DelegateStatus memory status) {
1559 		StakeOwnerData memory data = getStakeOwnerData(addr);
1560 
1561 		status.addr = addr;
1562 		status.uncappedDelegatedStake = uncappedDelegatedStake[addr];
1563 		status.isSelfDelegating = data.delegation == addr;
1564 		status.selfDelegatedStake = status.isSelfDelegating ? data.stake : 0;
1565 		status.delegatedStake = status.isSelfDelegating ? status.uncappedDelegatedStake : 0;
1566 
1567 		return status;
1568 	}
1569 
1570     /// Returns an address stake and delegation data. 
1571     /// @dev implicitly self-delegated addresses (delegation = 0) return delegation to the address
1572 	function getStakeOwnerData(address addr) private view returns (StakeOwnerData memory data) {
1573 		data = stakeOwnersData[addr];
1574 		data.delegation = (data.delegation == address(0)) ? addr : data.delegation;
1575 		return data;
1576 	}
1577 
1578 	struct DelegateFromVars {
1579 		DelegateStatus prevDelegateStatusBefore;
1580 		DelegateStatus newDelegateStatusBefore;
1581 		DelegateStatus prevDelegateStatusAfter;
1582 		DelegateStatus newDelegateStatusAfter;
1583 	}
1584 
1585     /// Handles a delegation change
1586     /// @dev notifies the rewards contract on the expected change (with data prior to the change)
1587     /// @dev updates the impacted delegates delegated stake and the total stake
1588     /// @dev notifies the election contract on changes in the impacted delegates delegated stake
1589     /// @param from is the delegator address 
1590     /// @param to is the delegate address
1591 	function delegateFrom(address from, address to) private {
1592 		require(to != address(0), "cannot delegate to a zero address");
1593 
1594 		DelegateFromVars memory vars;
1595 
1596 		StakeOwnerData memory delegatorData = getStakeOwnerData(from);
1597 		address prevDelegate = delegatorData.delegation;
1598 
1599 		if (to == prevDelegate) return; // Delegation hasn't changed
1600 
1601 		// Optimization - no need for the full flow in the case of a zero staked delegator with no delegations
1602 		if (delegatorData.stake == 0 && uncappedDelegatedStake[from] == 0) {
1603 			stakeOwnersData[from].delegation = to;
1604 			emit Delegated(from, to);
1605 			return;
1606 		}
1607 
1608 		vars.prevDelegateStatusBefore = getDelegateStatus(prevDelegate);
1609 		vars.newDelegateStatusBefore = getDelegateStatus(to);
1610 
1611 		stakingRewardsContract.delegationWillChange(prevDelegate, vars.prevDelegateStatusBefore.delegatedStake, from, delegatorData.stake, to, vars.newDelegateStatusBefore.delegatedStake);
1612 
1613 		stakeOwnersData[from].delegation = to;
1614 
1615 		uint256 delegatorStake = delegatorData.stake;
1616 
1617 		uncappedDelegatedStake[prevDelegate] = vars.prevDelegateStatusBefore.uncappedDelegatedStake.sub(delegatorStake);
1618 		uncappedDelegatedStake[to] = vars.newDelegateStatusBefore.uncappedDelegatedStake.add(delegatorStake);
1619 
1620 		vars.prevDelegateStatusAfter = getDelegateStatus(prevDelegate);
1621 		vars.newDelegateStatusAfter = getDelegateStatus(to);
1622 
1623 		uint256 _totalDelegatedStake = totalDelegatedStake.sub(
1624 			vars.prevDelegateStatusBefore.delegatedStake
1625 		).add(
1626 			vars.prevDelegateStatusAfter.delegatedStake
1627 		).sub(
1628 			vars.newDelegateStatusBefore.delegatedStake
1629 		).add(
1630 			vars.newDelegateStatusAfter.delegatedStake
1631 		);
1632 
1633 		totalDelegatedStake = _totalDelegatedStake;
1634 
1635 		emit Delegated(from, to);
1636 
1637 		IElections _electionsContract = electionsContract;
1638 
1639 		if (vars.prevDelegateStatusBefore.delegatedStake != vars.prevDelegateStatusAfter.delegatedStake) {
1640 			_electionsContract.delegatedStakeChange(
1641 				prevDelegate,
1642 				vars.prevDelegateStatusAfter.selfDelegatedStake,
1643 				vars.prevDelegateStatusAfter.delegatedStake,
1644 				_totalDelegatedStake
1645 			);
1646 
1647 			emit DelegatedStakeChanged(
1648 				prevDelegate,
1649 				vars.prevDelegateStatusAfter.selfDelegatedStake,
1650 				vars.prevDelegateStatusAfter.delegatedStake,
1651 				from,
1652 				0
1653 			);
1654 		}
1655 
1656 		if (vars.newDelegateStatusBefore.delegatedStake != vars.newDelegateStatusAfter.delegatedStake) {
1657 			_electionsContract.delegatedStakeChange(
1658 				to,
1659 				vars.newDelegateStatusAfter.selfDelegatedStake,
1660 				vars.newDelegateStatusAfter.delegatedStake,
1661 				_totalDelegatedStake
1662 			);
1663 
1664 			emit DelegatedStakeChanged(
1665 				to,
1666 				vars.newDelegateStatusAfter.selfDelegatedStake,
1667 				vars.newDelegateStatusAfter.delegatedStake,
1668 				from,
1669 				delegatorStake
1670 			);
1671 		}
1672 	}
1673 
1674     /// Handles a change in a stake owner stake
1675     /// @dev notifies the rewards contract on the expected change (with data prior to the change)
1676     /// @dev updates the impacted delegate delegated stake and the total stake
1677     /// @dev notifies the election contract on changes in the impacted delegate delegated stake
1678     /// @param _stakeOwner is the stake owner
1679     /// @param _updatedStake is the stake owner stake after the change
1680 	function _stakeChange(address _stakeOwner, uint256 _updatedStake) private {
1681 		StakeOwnerData memory stakeOwnerDataBefore = getStakeOwnerData(_stakeOwner);
1682 		DelegateStatus memory delegateStatusBefore = getDelegateStatus(stakeOwnerDataBefore.delegation);
1683 
1684 		uint256 prevUncappedStake = delegateStatusBefore.uncappedDelegatedStake;
1685 		uint256 newUncappedStake = prevUncappedStake.sub(stakeOwnerDataBefore.stake).add(_updatedStake);
1686 
1687 		stakingRewardsContract.delegationWillChange(stakeOwnerDataBefore.delegation, delegateStatusBefore.delegatedStake, _stakeOwner, stakeOwnerDataBefore.stake, stakeOwnerDataBefore.delegation, delegateStatusBefore.delegatedStake);
1688 
1689 		uncappedDelegatedStake[stakeOwnerDataBefore.delegation] = newUncappedStake;
1690 
1691 		require(uint256(uint96(_updatedStake)) == _updatedStake, "Delegations::updatedStakes value too big (>96 bits)");
1692 		stakeOwnersData[_stakeOwner].stake = uint96(_updatedStake);
1693 
1694 		uint256 _totalDelegatedStake = totalDelegatedStake;
1695 		if (delegateStatusBefore.isSelfDelegating) {
1696 			_totalDelegatedStake = _totalDelegatedStake.sub(stakeOwnerDataBefore.stake).add(_updatedStake);
1697 			totalDelegatedStake = _totalDelegatedStake;
1698 		}
1699 
1700 		DelegateStatus memory delegateStatusAfter = getDelegateStatus(stakeOwnerDataBefore.delegation);
1701 
1702 		electionsContract.delegatedStakeChange(
1703 			stakeOwnerDataBefore.delegation,
1704 			delegateStatusAfter.selfDelegatedStake,
1705 			delegateStatusAfter.delegatedStake,
1706 			_totalDelegatedStake
1707 		);
1708 
1709 		if (_updatedStake != stakeOwnerDataBefore.stake) {
1710 			emit DelegatedStakeChanged(
1711 				stakeOwnerDataBefore.delegation,
1712 				delegateStatusAfter.selfDelegatedStake,
1713 				delegateStatusAfter.delegatedStake,
1714 				_stakeOwner,
1715 				_updatedStake
1716 			);
1717 		}
1718 	}
1719 
1720 	/*
1721      * Contracts topology / registry interface
1722      */
1723 
1724 	IElections electionsContract;
1725 	IStakingRewards stakingRewardsContract;
1726 	IStakingContractHandler stakingContractHandler;
1727 
1728     /// Refreshes the address of the other contracts the contract interacts with
1729     /// @dev called by the registry contract upon an update of a contract in the registry
1730 	function refreshContracts() external override {
1731 		electionsContract = IElections(getElectionsContract());
1732 		stakingContractHandler = IStakingContractHandler(getStakingContractHandler());
1733 		stakingRewardsContract = IStakingRewards(getStakingRewardsContract());
1734 	}
1735 
1736 }