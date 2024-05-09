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
163 // File: contracts/spec_interfaces/IElections.sol
164 
165 pragma solidity 0.6.12;
166 
167 /// @title Elections contract interface
168 interface IElections {
169 	
170 	// Election state change events
171 	event StakeChanged(address indexed addr, uint256 selfDelegatedStake, uint256 delegatedStake, uint256 effectiveStake);
172 	event GuardianStatusUpdated(address indexed guardian, bool readyToSync, bool readyForCommittee);
173 
174 	// Vote out / Vote unready
175 	event GuardianVotedUnready(address indexed guardian);
176 	event VoteUnreadyCasted(address indexed voter, address indexed subject, uint256 expiration);
177 	event GuardianVotedOut(address indexed guardian);
178 	event VoteOutCasted(address indexed voter, address indexed subject);
179 
180 	/*
181 	 * External functions
182 	 */
183 
184     /// Notifies that the guardian is ready to sync with other nodes
185     /// @dev may be called with either the guardian address or the guardian's orbs address
186     /// @dev ready to sync state is not managed in the contract that only emits an event
187     /// @dev readyToSync clears the readyForCommittee state
188 	function readyToSync() external;
189 
190     /// Notifies that the guardian is ready to join the committee
191     /// @dev may be called with either the guardian address or the guardian's orbs address
192     /// @dev a qualified guardian calling readyForCommittee is added to the committee
193 	function readyForCommittee() external;
194 
195     /// Checks if a guardian is qualified to join the committee
196     /// @dev when true, calling readyForCommittee() will result in adding the guardian to the committee
197     /// @dev called periodically by guardians to check if they are qualified to join the committee
198     /// @param guardian is the guardian to check
199     /// @return canJoin indicating that the guardian can join the current committee
200 	function canJoinCommittee(address guardian) external view returns (bool);
201 
202     /// Returns an address effective stake
203     /// The effective stake is derived from a guardian delegate stake and selfs stake  
204     /// @return effectiveStake is the guardian's effective stake
205 	function getEffectiveStake(address guardian) external view returns (uint effectiveStake);
206 
207     /// Returns the current committee along with the guardians' Orbs address and IP
208     /// @return committee is a list of the committee members' guardian addresses
209     /// @return weights is a list of the committee members' weight (effective stake)
210     /// @return orbsAddrs is a list of the committee members' orbs address
211     /// @return certification is a list of bool indicating the committee members certification
212     /// @return ips is a list of the committee members' ip
213 	function getCommittee() external view returns (address[] memory committee, uint256[] memory weights, address[] memory orbsAddrs, bool[] memory certification, bytes4[] memory ips);
214 
215 	// Vote-unready
216 
217     /// Casts an unready vote on a subject guardian
218     /// @dev Called by a guardian as part of the automatic vote-unready flow
219     /// @dev The transaction may be sent from the guardian or orbs address.
220     /// @param subject is the subject guardian to vote out
221     /// @param voteExpiration is the expiration time of the vote unready to prevent counting of a vote that is already irrelevant.
222 	function voteUnready(address subject, uint voteExpiration) external;
223 
224     /// Returns the current vote unready vote for a voter and a subject pair
225     /// @param voter is the voting guardian address
226     /// @param subject is the subject guardian address
227     /// @return valid indicates whether there is a valid vote
228     /// @return expiration returns the votes expiration time
229 	function getVoteUnreadyVote(address voter, address subject) external view returns (bool valid, uint256 expiration);
230 
231     /// Returns the current vote-unready status of a subject guardian.
232     /// @dev the committee and certification data is used to check the certified and committee threshold
233     /// @param subject is the subject guardian address
234     /// @return committee is a list of the current committee members
235     /// @return weights is a list of the current committee members weight
236     /// @return certification is a list of bool indicating the committee members certification
237     /// @return votes is a list of bool indicating the members that votes the subject unready
238     /// @return subjectInCommittee indicates that the subject is in the committee
239     /// @return subjectInCertifiedCommittee indicates that the subject is in the certified committee
240 	function getVoteUnreadyStatus(address subject) external view returns (
241 		address[] memory committee,
242 		uint256[] memory weights,
243 		bool[] memory certification,
244 		bool[] memory votes,
245 		bool subjectInCommittee,
246 		bool subjectInCertifiedCommittee
247 	);
248 
249 	// Vote-out
250 
251     /// Casts a voteOut vote by the sender to the given address
252     /// @dev the transaction is sent from the guardian address
253     /// @param subject is the subject guardian address
254 	function voteOut(address subject) external;
255 
256     /// Returns the subject address the addr has voted-out against
257     /// @param voter is the voting guardian address
258     /// @return subject is the subject the voter has voted out
259 	function getVoteOutVote(address voter) external view returns (address);
260 
261     /// Returns the governance voteOut status of a guardian.
262     /// @dev A guardian is voted out if votedStake / totalDelegatedStake (in percent mille) > threshold
263     /// @param subject is the subject guardian address
264     /// @return votedOut indicates whether the subject was voted out
265     /// @return votedStake is the total stake voting against the subject
266     /// @return totalDelegatedStake is the total delegated stake
267 	function getVoteOutStatus(address subject) external view returns (bool votedOut, uint votedStake, uint totalDelegatedStake);
268 
269 	/*
270 	 * Notification functions from other PoS contracts
271 	 */
272 
273     /// Notifies a delegated stake change event
274     /// @dev Called by: delegation contract
275     /// @param delegate is the delegate to update
276     /// @param selfDelegatedStake is the delegate self stake (0 if not self-delegating)
277     /// @param delegatedStake is the delegate delegated stake (0 if not self-delegating)
278     /// @param totalDelegatedStake is the total delegated stake
279 	function delegatedStakeChange(address delegate, uint256 selfDelegatedStake, uint256 delegatedStake, uint256 totalDelegatedStake) external /* onlyDelegationsContract onlyWhenActive */;
280 
281     /// Notifies a new guardian was unregistered
282     /// @dev Called by: guardian registration contract
283     /// @dev when a guardian unregisters its status is updated to not ready to sync and is removed from the committee
284     /// @param guardian is the address of the guardian that unregistered
285 	function guardianUnregistered(address guardian) external /* onlyGuardiansRegistrationContract */;
286 
287     /// Notifies on a guardian certification change
288     /// @dev Called by: guardian registration contract
289     /// @param guardian is the address of the guardian to update
290     /// @param isCertified indicates whether the guardian is certified
291 	function guardianCertificationChanged(address guardian, bool isCertified) external /* onlyCertificationContract */;
292 
293 
294 	/*
295      * Governance functions
296 	 */
297 
298 	event VoteUnreadyTimeoutSecondsChanged(uint32 newValue, uint32 oldValue);
299 	event VoteOutPercentMilleThresholdChanged(uint32 newValue, uint32 oldValue);
300 	event VoteUnreadyPercentMilleThresholdChanged(uint32 newValue, uint32 oldValue);
301 	event MinSelfStakePercentMilleChanged(uint32 newValue, uint32 oldValue);
302 
303     /// Sets the minimum self stake requirement for the effective stake
304     /// @dev governance function called only by the functional manager
305     /// @param minSelfStakePercentMille is the minimum self stake in percent-mille (0-100,000) 
306 	function setMinSelfStakePercentMille(uint32 minSelfStakePercentMille) external /* onlyFunctionalManager */;
307 
308     /// Returns the minimum self-stake required for the effective stake
309     /// @return minSelfStakePercentMille is the minimum self stake in percent-mille 
310 	function getMinSelfStakePercentMille() external view returns (uint32);
311 
312     /// Sets the vote-out threshold
313     /// @dev governance function called only by the functional manager
314     /// @param voteOutPercentMilleThreshold is the minimum threshold in percent-mille (0-100,000)
315 	function setVoteOutPercentMilleThreshold(uint32 voteOutPercentMilleThreshold) external /* onlyFunctionalManager */;
316 
317     /// Returns the vote-out threshold
318     /// @return voteOutPercentMilleThreshold is the minimum threshold in percent-mille
319 	function getVoteOutPercentMilleThreshold() external view returns (uint32);
320 
321     /// Sets the vote-unready threshold
322     /// @dev governance function called only by the functional manager
323     /// @param voteUnreadyPercentMilleThreshold is the minimum threshold in percent-mille (0-100,000)
324 	function setVoteUnreadyPercentMilleThreshold(uint32 voteUnreadyPercentMilleThreshold) external /* onlyFunctionalManager */;
325 
326     /// Returns the vote-unready threshold
327     /// @return voteUnreadyPercentMilleThreshold is the minimum threshold in percent-mille
328 	function getVoteUnreadyPercentMilleThreshold() external view returns (uint32);
329 
330     /// Returns the contract's settings 
331     /// @return minSelfStakePercentMille is the minimum self stake in percent-mille
332     /// @return voteUnreadyPercentMilleThreshold is the minimum threshold in percent-mille
333     /// @return voteOutPercentMilleThreshold is the minimum threshold in percent-mille
334 	function getSettings() external view returns (
335 		uint32 minSelfStakePercentMille,
336 		uint32 voteUnreadyPercentMilleThreshold,
337 		uint32 voteOutPercentMilleThreshold
338 	);
339 
340     /// Initializes the ready for committee notification for the committee guardians
341     /// @dev governance function called only by the initialization admin during migration 
342     /// @dev identical behaviour as if each guardian sent readyForCommittee() 
343     /// @param guardians a list of guardians addresses to update
344 	function initReadyForCommittee(address[] calldata guardians) external /* onlyInitializationAdmin */;
345 
346 }
347 
348 // File: contracts/spec_interfaces/IDelegations.sol
349 
350 pragma solidity 0.6.12;
351 
352 /// @title Delegations contract interface
353 interface IDelegations /* is IStakeChangeNotifier */ {
354 
355     // Delegation state change events
356 	event DelegatedStakeChanged(address indexed addr, uint256 selfDelegatedStake, uint256 delegatedStake, address indexed delegator, uint256 delegatorContributedStake);
357 
358     // Function calls
359 	event Delegated(address indexed from, address indexed to);
360 
361 	/*
362      * External functions
363      */
364 
365     /// Delegate your stake
366     /// @dev updates the election contract on the changes in the delegated stake
367     /// @dev updates the rewards contract on the upcoming change in the delegator's delegation state
368     /// @param to is the address to delegate to
369 	function delegate(address to) external /* onlyWhenActive */;
370 
371     /// Refresh the address stake for delegation power based on the staking contract
372     /// @dev Disabled stake change update notifications from the staking contract may create mismatches
373     /// @dev refreshStake re-syncs the stake data with the staking contract
374     /// @param addr is the address to refresh its stake
375 	function refreshStake(address addr) external /* onlyWhenActive */;
376 
377     /// Refresh the addresses stake for delegation power based on the staking contract
378     /// @dev Batched version of refreshStake
379     /// @dev Disabled stake change update notifications from the staking contract may create mismatches
380     /// @dev refreshStakeBatch re-syncs the stake data with the staking contract
381     /// @param addrs is the list of addresses to refresh their stake
382 	function refreshStakeBatch(address[] calldata addrs) external /* onlyWhenActive */;
383 
384     /// Returns the delegate address of the given address
385     /// @param addr is the address to query
386     /// @return delegation is the address the addr delegated to
387 	function getDelegation(address addr) external view returns (address);
388 
389     /// Returns a delegator info
390     /// @param addr is the address to query
391     /// @return delegation is the address the addr delegated to
392     /// @return delegatorStake is the stake of the delegator as reflected in the delegation contract
393 	function getDelegationInfo(address addr) external view returns (address delegation, uint256 delegatorStake);
394 	
395     /// Returns the delegated stake of an addr 
396     /// @dev an address that is not self delegating has a 0 delegated stake
397     /// @param addr is the address to query
398     /// @return delegatedStake is the address delegated stake
399 	function getDelegatedStake(address addr) external view returns (uint256);
400 
401     /// Returns the total delegated stake
402     /// @dev delegatedStake - the total stake delegated to an address that is self delegating
403     /// @dev the delegated stake of a non self-delegated address is 0
404     /// @return totalDelegatedStake is the total delegatedStake of all the addresses
405 	function getTotalDelegatedStake() external view returns (uint256) ;
406 
407 	/*
408 	 * Governance functions
409 	 */
410 
411 	event DelegationsImported(address[] from, address indexed to);
412 
413 	event DelegationInitialized(address indexed from, address indexed to);
414 
415     /// Imports delegations during initial migration
416     /// @dev initialization function called only by the initializationManager
417     /// @dev Does not update the Rewards or Election contracts
418     /// @dev assumes deactivated Rewards
419     /// @param from is a list of delegator addresses
420     /// @param to is the address the delegators delegate to
421 	function importDelegations(address[] calldata from, address to) external /* onlyMigrationManager onlyDuringDelegationImport */;
422 
423     /// Initializes the delegation of an address during initial migration 
424     /// @dev initialization function called only by the initializationManager
425     /// @dev behaves identically to a delegate transaction sent by the delegator
426     /// @param from is the delegator addresses
427     /// @param to is the delegator delegates to
428 	function initDelegation(address from, address to) external /* onlyInitializationAdmin */;
429 }
430 
431 // File: contracts/spec_interfaces/IGuardiansRegistration.sol
432 
433 pragma solidity 0.6.12;
434 
435 /// @title Guardian registration contract interface
436 interface IGuardiansRegistration {
437 	event GuardianRegistered(address indexed guardian);
438 	event GuardianUnregistered(address indexed guardian);
439 	event GuardianDataUpdated(address indexed guardian, bool isRegistered, bytes4 ip, address orbsAddr, string name, string website, uint256 registrationTime);
440 	event GuardianMetadataChanged(address indexed guardian, string key, string newValue, string oldValue);
441 
442 	/*
443      * External methods
444      */
445 
446     /// Registers a new guardian
447     /// @dev called using the guardian's address that holds the guardian self-stake and used for delegation
448     /// @param ip is the guardian's node ipv4 address as a 32b number 
449     /// @param orbsAddr is the guardian's Orbs node address 
450     /// @param name is the guardian's name as a string
451     /// @param website is the guardian's website as a string, publishing a name and website provide information for delegators
452 	function registerGuardian(bytes4 ip, address orbsAddr, string calldata name, string calldata website) external;
453 
454     /// Updates a registered guardian data
455     /// @dev may be called only by a registered guardian
456     /// @param ip is the guardian's node ipv4 address as a 32b number 
457     /// @param orbsAddr is the guardian's Orbs node address 
458     /// @param name is the guardian's name as a string
459     /// @param website is the guardian's website as a string, publishing a name and website provide information for delegators
460 	function updateGuardian(bytes4 ip, address orbsAddr, string calldata name, string calldata website) external;
461 
462     /// Updates a registered guardian ip address
463     /// @dev may be called only by a registered guardian
464     /// @dev may be called with either the guardian address or the guardian's orbs address
465     /// @param ip is the guardian's node ipv4 address as a 32b number 
466 	function updateGuardianIp(bytes4 ip) external /* onlyWhenActive */;
467 
468     /// Updates a guardian's metadata property
469     /// @dev called using the guardian's address
470     /// @dev any key may be updated to be used by Orbs platform and tools
471     /// @param key is the name of the property to update
472     /// @param value is the value of the property to update in a string format
473     function setMetadata(string calldata key, string calldata value) external;
474 
475     /// Returns a guardian's metadata property
476     /// @dev a property that wasn't set returns an empty string
477     /// @param guardian is the guardian to query
478     /// @param key is the name of the metadata property to query
479     /// @return value is the value of the queried property in a string format
480     function getMetadata(address guardian, string calldata key) external view returns (string memory);
481 
482     /// Unregisters a guardian
483     /// @dev may be called only by a registered guardian
484     /// @dev unregistering does not clear the guardian's metadata properties
485 	function unregisterGuardian() external;
486 
487     /// Returns a guardian's data
488     /// @param guardian is the guardian to query
489     /// @param ip is the guardian's node ipv4 address as a 32b number 
490     /// @param orbsAddr is the guardian's Orbs node address 
491     /// @param name is the guardian's name as a string
492     /// @param website is the guardian's website as a string
493     /// @param registrationTime is the timestamp of the guardian's registration
494     /// @param lastUpdateTime is the timestamp of the guardian's last update
495 	function getGuardianData(address guardian) external view returns (bytes4 ip, address orbsAddr, string memory name, string memory website, uint registrationTime, uint lastUpdateTime);
496 
497     /// Returns the Orbs addresses of a list of guardians
498     /// @dev an unregistered guardian returns address(0) Orbs address
499     /// @param guardianAddrs is a list of guardians' addresses to query
500     /// @return orbsAddrs is a list of the guardians' Orbs addresses 
501 	function getGuardiansOrbsAddress(address[] calldata guardianAddrs) external view returns (address[] memory orbsAddrs);
502 
503     /// Returns a guardian's ip
504     /// @dev an unregistered guardian returns 0 ip address
505     /// @param guardian is the guardian to query
506     /// @return ip is the guardian's node ipv4 address as a 32b number 
507 	function getGuardianIp(address guardian) external view returns (bytes4 ip);
508 
509     /// Returns the ip of a list of guardians
510     /// @dev an unregistered guardian returns 0 ip address
511     /// @param guardianAddrs is a list of guardians' addresses to query
512     /// @param ips is a list of the guardians' node ipv4 addresses as a 32b numbers
513 	function getGuardianIps(address[] calldata guardianAddrs) external view returns (bytes4[] memory ips);
514 
515     /// Checks if a guardian is registered
516     /// @param guardian is the guardian to query
517     /// @return registered is a bool indicating a guardian address is registered
518 	function isRegistered(address guardian) external view returns (bool);
519 
520     /// Translates a list guardians Orbs addresses to guardian addresses
521     /// @dev an Orbs address that does not correspond to any registered guardian returns address(0)
522     /// @param orbsAddrs is a list of the guardians' Orbs addresses to query
523     /// @return guardianAddrs is a list of guardians' addresses that matches the Orbs addresses
524 	function getGuardianAddresses(address[] calldata orbsAddrs) external view returns (address[] memory guardianAddrs);
525 
526     /// Resolves the guardian address for a guardian, given a Guardian/Orbs address
527     /// @dev revert if the address does not correspond to a registered guardian address or Orbs address
528     /// @dev designed to be used for contracts calls, validating a registered guardian
529     /// @dev should be used with caution when called by tools as the call may revert
530     /// @dev in case of a conflict matching both guardian and Orbs address, the Guardian address takes precedence
531     /// @param guardianOrOrbsAddress is the address to query representing a guardian address or Orbs address
532     /// @return guardianAddress is the guardian address that matches the queried address
533 	function resolveGuardianAddress(address guardianOrOrbsAddress) external view returns (address guardianAddress);
534 
535 	/*
536 	 * Governance functions
537 	 */
538 
539     /// Migrates a list of guardians from a previous guardians registration contract
540     /// @dev governance function called only by the initialization admin
541     /// @dev reads the migrated guardians data by calling getGuardianData in the previous contract
542     /// @dev imports also the guardians' registration time and last update
543     /// @dev emits a GuardianDataUpdated for each guardian to allow tracking by tools
544     /// @param guardiansToMigrate is a list of guardians' addresses to migrate
545     /// @param previousContract is the previous registration contract address
546 	function migrateGuardians(address[] calldata guardiansToMigrate, IGuardiansRegistration previousContract) external /* onlyInitializationAdmin */;
547 
548 }
549 
550 // File: contracts/spec_interfaces/ICommittee.sol
551 
552 pragma solidity 0.6.12;
553 
554 /// @title Committee contract interface
555 interface ICommittee {
556 	event CommitteeChange(address indexed addr, uint256 weight, bool certification, bool inCommittee);
557 	event CommitteeSnapshot(address[] addrs, uint256[] weights, bool[] certification);
558 
559 	// No external functions
560 
561 	/*
562      * External functions
563      */
564 
565     /// Notifies a weight change of a member
566     /// @dev Called only by: Elections contract
567     /// @param addr is the committee member address
568     /// @param weight is the updated weight of the committee member
569 	function memberWeightChange(address addr, uint256 weight) external /* onlyElectionsContract onlyWhenActive */;
570 
571     /// Notifies a change in the certification of a member
572     /// @dev Called only by: Elections contract
573     /// @param addr is the committee member address
574     /// @param isCertified is the updated certification state of the member
575 	function memberCertificationChange(address addr, bool isCertified) external /* onlyElectionsContract onlyWhenActive */;
576 
577     /// Notifies a member removal for example due to voteOut or voteUnready
578     /// @dev Called only by: Elections contract
579     /// @param memberRemoved is the removed committee member address
580     /// @return memberRemoved indicates whether the member was removed from the committee
581     /// @return removedMemberWeight indicates the removed member weight
582     /// @return removedMemberCertified indicates whether the member was in the certified committee
583 	function removeMember(address addr) external returns (bool memberRemoved, uint removedMemberWeight, bool removedMemberCertified)/* onlyElectionContract */;
584 
585     /// Notifies a new member applicable for committee (due to registration, unbanning, certification change)
586     /// The new member will be added only if it is qualified to join the committee 
587     /// @dev Called only by: Elections contract
588     /// @param addr is the added committee member address
589     /// @param weight is the added member weight
590     /// @param isCertified is the added member certification state
591     /// @return memberAdded bool indicates whether the member was added
592 	function addMember(address addr, uint256 weight, bool isCertified) external returns (bool memberAdded)  /* onlyElectionsContract */;
593 
594     /// Checks if addMember() would add a the member to the committee (qualified to join)
595     /// @param addr is the candidate committee member address
596     /// @param weight is the candidate committee member weight
597     /// @return wouldAddMember bool indicates whether the member will be added
598 	function checkAddMember(address addr, uint256 weight) external view returns (bool wouldAddMember);
599 
600     /// Returns the committee members and their weights
601     /// @return addrs is the committee members list
602     /// @return weights is an array of uint, indicating committee members list weight
603     /// @return certification is an array of bool, indicating the committee members certification status
604 	function getCommittee() external view returns (address[] memory addrs, uint256[] memory weights, bool[] memory certification);
605 
606     /// Returns the currently appointed committee data
607     /// @return generalCommitteeSize is the number of members in the committee
608     /// @return certifiedCommitteeSize is the number of certified members in the committee
609     /// @return totalWeight is the total effective stake (weight) of the committee
610 	function getCommitteeStats() external view returns (uint generalCommitteeSize, uint certifiedCommitteeSize, uint totalWeight);
611 
612     /// Returns a committee member data
613     /// @param addr is the committee member address
614     /// @return inCommittee indicates whether the queried address is a member in the committee
615     /// @return weight is the committee member weight
616     /// @return isCertified indicates whether the committee member is certified
617     /// @return totalCommitteeWeight is the total weight of the committee.
618 	function getMemberInfo(address addr) external view returns (bool inCommittee, uint weight, bool isCertified, uint totalCommitteeWeight);
619 
620     /// Emits a CommitteeSnapshot events with current committee info
621     /// @dev a CommitteeSnapshot is useful on contract migration or to remove the need to track past events.
622 	function emitCommitteeSnapshot() external;
623 
624 	/*
625 	 * Governance functions
626 	 */
627 
628 	event MaxCommitteeSizeChanged(uint8 newValue, uint8 oldValue);
629 
630     /// Sets the maximum number of committee members
631     /// @dev governance function called only by the functional manager
632     /// @dev when reducing the number of members, the bottom ones are removed from the committee
633     /// @param _maxCommitteeSize is the maximum number of committee members 
634 	function setMaxCommitteeSize(uint8 _maxCommitteeSize) external /* onlyFunctionalManager */;
635 
636     /// Returns the maximum number of committee members
637     /// @return maxCommitteeSize is the maximum number of committee members 
638 	function getMaxCommitteeSize() external view returns (uint8);
639 	
640     /// Imports the committee members from a previous committee contract during migration
641     /// @dev initialization function called only by the initializationManager
642     /// @dev does not update the reward contract to avoid incorrect notifications 
643     /// @param previousCommitteeContract is the address of the previous committee contract
644 	function importMembers(ICommittee previousCommitteeContract) external /* onlyInitializationAdmin */;
645 }
646 
647 // File: contracts/spec_interfaces/ICertification.sol
648 
649 pragma solidity 0.6.12;
650 
651 /// @title Certification contract interface
652 interface ICertification /* is Ownable */ {
653 	event GuardianCertificationUpdate(address indexed guardian, bool isCertified);
654 
655 	/*
656      * External methods
657      */
658 
659     /// Returns the certification status of a guardian
660     /// @param guardian is the guardian to query
661 	function isGuardianCertified(address guardian) external view returns (bool isCertified);
662 
663     /// Sets the guardian certification status
664     /// @dev governance function called only by the certification manager
665     /// @param guardian is the guardian to update
666     /// @param isCertified bool indication whether the guardian is certified
667 	function setGuardianCertification(address guardian, bool isCertified) external /* onlyCertificationManager */ ;
668 }
669 
670 // File: contracts/spec_interfaces/IManagedContract.sol
671 
672 pragma solidity 0.6.12;
673 
674 /// @title managed contract interface, used by the contracts registry to notify the contract on updates
675 interface IManagedContract /* is ILockable, IContractRegistryAccessor, Initializable */ {
676 
677     /// Refreshes the address of the other contracts the contract interacts with
678     /// @dev called by the registry contract upon an update of a contract in the registry
679     function refreshContracts() external;
680 
681 }
682 
683 // File: contracts/spec_interfaces/IContractRegistry.sol
684 
685 pragma solidity 0.6.12;
686 
687 /// @title Contract registry contract interface
688 /// @dev The contract registry holds Orbs PoS contracts and managers lists
689 /// @dev The contract registry updates the managed contracts on changes in the contract list
690 /// @dev Governance functions restricted to managers access the registry to retrieve the manager address 
691 /// @dev The contract registry represents the source of truth for Orbs Ethereum contracts 
692 /// @dev By tracking the registry events or query before interaction, one can access the up to date contracts 
693 interface IContractRegistry {
694 
695 	event ContractAddressUpdated(string contractName, address addr, bool managedContract);
696 	event ManagerChanged(string role, address newManager);
697 	event ContractRegistryUpdated(address newContractRegistry);
698 
699 	/*
700 	* External functions
701 	*/
702 
703     /// Updates the contracts address and emits a corresponding event
704     /// @dev governance function called only by the migrationManager or registryAdmin
705     /// @param contractName is the contract name, used to identify it
706     /// @param addr is the contract updated address
707     /// @param managedContract indicates whether the contract is managed by the registry and notified on changes
708 	function setContract(string calldata contractName, address addr, bool managedContract) external /* onlyAdminOrMigrationManager */;
709 
710     /// Returns the current address of the given contracts
711     /// @param contractName is the contract name, used to identify it
712     /// @return addr is the contract updated address
713 	function getContract(string calldata contractName) external view returns (address);
714 
715     /// Returns the list of contract addresses managed by the registry
716     /// @dev Managed contracts are updated on changes in the registry contracts addresses 
717     /// @return addrs is the list of managed contracts
718 	function getManagedContracts() external view returns (address[] memory);
719 
720     /// Locks all the managed contracts 
721     /// @dev governance function called only by the migrationManager or registryAdmin
722     /// @dev When set all onlyWhenActive functions will revert
723 	function lockContracts() external /* onlyAdminOrMigrationManager */;
724 
725     /// Unlocks all the managed contracts 
726     /// @dev governance function called only by the migrationManager or registryAdmin
727 	function unlockContracts() external /* onlyAdminOrMigrationManager */;
728 	
729     /// Updates a manager address and emits a corresponding event
730     /// @dev governance function called only by the registryAdmin
731     /// @dev the managers list is a flexible list of role to the manager's address
732     /// @param role is the managers' role name, for example "functionalManager"
733     /// @param manager is the manager updated address
734 	function setManager(string calldata role, address manager) external /* onlyAdmin */;
735 
736     /// Returns the current address of the given manager
737     /// @param role is the manager name, used to identify it
738     /// @return addr is the manager updated address
739 	function getManager(string calldata role) external view returns (address);
740 
741     /// Sets a new contract registry to migrate to
742     /// @dev governance function called only by the registryAdmin
743     /// @dev updates the registry address record in all the managed contracts
744     /// @dev by tracking the emitted ContractRegistryUpdated, tools can track the up to date contracts
745     /// @param newRegistry is the new registry contract 
746 	function setNewContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;
747 
748     /// Returns the previous contract registry address 
749     /// @dev used when the setting the contract as a new registry to assure a valid registry
750     /// @return previousContractRegistry is the previous contract registry
751 	function getPreviousContractRegistry() external view returns (address);
752 }
753 
754 // File: contracts/spec_interfaces/IContractRegistryAccessor.sol
755 
756 pragma solidity 0.6.12;
757 
758 
759 interface IContractRegistryAccessor {
760 
761     /// Sets the contract registry address
762     /// @dev governance function called only by an admin
763     /// @param newRegistry is the new registry contract 
764     function setContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;
765 
766     /// Returns the contract registry address
767     /// @return contractRegistry is the contract registry address
768     function getContractRegistry() external view returns (IContractRegistry contractRegistry);
769 
770     function setRegistryAdmin(address _registryAdmin) external /* onlyInitializationAdmin */;
771 
772 }
773 
774 // File: @openzeppelin/contracts/GSN/Context.sol
775 
776 pragma solidity ^0.6.0;
777 
778 /*
779  * @dev Provides information about the current execution context, including the
780  * sender of the transaction and its data. While these are generally available
781  * via msg.sender and msg.data, they should not be accessed in such a direct
782  * manner, since when dealing with GSN meta-transactions the account sending and
783  * paying for execution may not be the actual sender (as far as an application
784  * is concerned).
785  *
786  * This contract is only required for intermediate, library-like contracts.
787  */
788 abstract contract Context {
789     function _msgSender() internal view virtual returns (address payable) {
790         return msg.sender;
791     }
792 
793     function _msgData() internal view virtual returns (bytes memory) {
794         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
795         return msg.data;
796     }
797 }
798 
799 // File: contracts/WithClaimableRegistryManagement.sol
800 
801 pragma solidity 0.6.12;
802 
803 
804 /**
805  * @title Claimable
806  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
807  * This allows the new owner to accept the transfer.
808  */
809 contract WithClaimableRegistryManagement is Context {
810     address private _registryAdmin;
811     address private _pendingRegistryAdmin;
812 
813     event RegistryManagementTransferred(address indexed previousRegistryAdmin, address indexed newRegistryAdmin);
814 
815     /**
816      * @dev Initializes the contract setting the deployer as the initial registryRegistryAdmin.
817      */
818     constructor () internal {
819         address msgSender = _msgSender();
820         _registryAdmin = msgSender;
821         emit RegistryManagementTransferred(address(0), msgSender);
822     }
823 
824     /**
825      * @dev Returns the address of the current registryAdmin.
826      */
827     function registryAdmin() public view returns (address) {
828         return _registryAdmin;
829     }
830 
831     /**
832      * @dev Throws if called by any account other than the registryAdmin.
833      */
834     modifier onlyRegistryAdmin() {
835         require(isRegistryAdmin(), "WithClaimableRegistryManagement: caller is not the registryAdmin");
836         _;
837     }
838 
839     /**
840      * @dev Returns true if the caller is the current registryAdmin.
841      */
842     function isRegistryAdmin() public view returns (bool) {
843         return _msgSender() == _registryAdmin;
844     }
845 
846     /**
847      * @dev Leaves the contract without registryAdmin. It will not be possible to call
848      * `onlyManager` functions anymore. Can only be called by the current registryAdmin.
849      *
850      * NOTE: Renouncing registryManagement will leave the contract without an registryAdmin,
851      * thereby removing any functionality that is only available to the registryAdmin.
852      */
853     function renounceRegistryManagement() public onlyRegistryAdmin {
854         emit RegistryManagementTransferred(_registryAdmin, address(0));
855         _registryAdmin = address(0);
856     }
857 
858     /**
859      * @dev Transfers registryManagement of the contract to a new account (`newManager`).
860      */
861     function _transferRegistryManagement(address newRegistryAdmin) internal {
862         require(newRegistryAdmin != address(0), "RegistryAdmin: new registryAdmin is the zero address");
863         emit RegistryManagementTransferred(_registryAdmin, newRegistryAdmin);
864         _registryAdmin = newRegistryAdmin;
865     }
866 
867     /**
868      * @dev Modifier throws if called by any account other than the pendingManager.
869      */
870     modifier onlyPendingRegistryAdmin() {
871         require(msg.sender == _pendingRegistryAdmin, "Caller is not the pending registryAdmin");
872         _;
873     }
874     /**
875      * @dev Allows the current registryAdmin to set the pendingManager address.
876      * @param newRegistryAdmin The address to transfer registryManagement to.
877      */
878     function transferRegistryManagement(address newRegistryAdmin) public onlyRegistryAdmin {
879         _pendingRegistryAdmin = newRegistryAdmin;
880     }
881 
882     /**
883      * @dev Allows the _pendingRegistryAdmin address to finalize the transfer.
884      */
885     function claimRegistryManagement() external onlyPendingRegistryAdmin {
886         _transferRegistryManagement(_pendingRegistryAdmin);
887         _pendingRegistryAdmin = address(0);
888     }
889 
890     /**
891      * @dev Returns the current pendingRegistryAdmin
892     */
893     function pendingRegistryAdmin() public view returns (address) {
894        return _pendingRegistryAdmin;  
895     }
896 }
897 
898 // File: contracts/Initializable.sol
899 
900 pragma solidity 0.6.12;
901 
902 contract Initializable {
903 
904     address private _initializationAdmin;
905 
906     event InitializationComplete();
907 
908     /// Constructor
909     /// Sets the initializationAdmin to the contract deployer
910     /// The initialization admin may call any manager only function until initializationComplete
911     constructor() public{
912         _initializationAdmin = msg.sender;
913     }
914 
915     modifier onlyInitializationAdmin() {
916         require(msg.sender == initializationAdmin(), "sender is not the initialization admin");
917 
918         _;
919     }
920 
921     /*
922     * External functions
923     */
924 
925     /// Returns the initializationAdmin address
926     function initializationAdmin() public view returns (address) {
927         return _initializationAdmin;
928     }
929 
930     /// Finalizes the initialization and revokes the initializationAdmin role 
931     function initializationComplete() external onlyInitializationAdmin {
932         _initializationAdmin = address(0);
933         emit InitializationComplete();
934     }
935 
936     /// Checks if the initialization was completed
937     function isInitializationComplete() public view returns (bool) {
938         return _initializationAdmin == address(0);
939     }
940 
941 }
942 
943 // File: contracts/ContractRegistryAccessor.sol
944 
945 pragma solidity 0.6.12;
946 
947 
948 
949 
950 
951 contract ContractRegistryAccessor is IContractRegistryAccessor, WithClaimableRegistryManagement, Initializable {
952 
953     IContractRegistry private contractRegistry;
954 
955     /// Constructor
956     /// @param _contractRegistry is the contract registry address
957     /// @param _registryAdmin is the registry admin address
958     constructor(IContractRegistry _contractRegistry, address _registryAdmin) public {
959         require(address(_contractRegistry) != address(0), "_contractRegistry cannot be 0");
960         setContractRegistry(_contractRegistry);
961         _transferRegistryManagement(_registryAdmin);
962     }
963 
964     modifier onlyAdmin {
965         require(isAdmin(), "sender is not an admin (registryManger or initializationAdmin)");
966 
967         _;
968     }
969 
970     modifier onlyMigrationManager {
971         require(isMigrationManager(), "sender is not the migration manager");
972 
973         _;
974     }
975 
976     modifier onlyFunctionalManager {
977         require(isFunctionalManager(), "sender is not the functional manager");
978 
979         _;
980     }
981 
982     /// Checks whether the caller is Admin: either the contract registry, the registry admin, or the initialization admin
983     function isAdmin() internal view returns (bool) {
984         return msg.sender == address(contractRegistry) || msg.sender == registryAdmin() || msg.sender == initializationAdmin();
985     }
986 
987     /// Checks whether the caller is a specific manager role or and Admin
988     /// @dev queries the registry contract for the up to date manager assignment
989     function isManager(string memory role) internal view returns (bool) {
990         IContractRegistry _contractRegistry = contractRegistry;
991         return isAdmin() || _contractRegistry != IContractRegistry(0) && contractRegistry.getManager(role) == msg.sender;
992     }
993 
994     /// Checks whether the caller is the migration manager
995     function isMigrationManager() internal view returns (bool) {
996         return isManager('migrationManager');
997     }
998 
999     /// Checks whether the caller is the functional manager
1000     function isFunctionalManager() internal view returns (bool) {
1001         return isManager('functionalManager');
1002     }
1003 
1004     /* 
1005      * Contract getters, return the address of a contract by calling the contract registry 
1006      */ 
1007 
1008     function getProtocolContract() internal view returns (address) {
1009         return contractRegistry.getContract("protocol");
1010     }
1011 
1012     function getStakingRewardsContract() internal view returns (address) {
1013         return contractRegistry.getContract("stakingRewards");
1014     }
1015 
1016     function getFeesAndBootstrapRewardsContract() internal view returns (address) {
1017         return contractRegistry.getContract("feesAndBootstrapRewards");
1018     }
1019 
1020     function getCommitteeContract() internal view returns (address) {
1021         return contractRegistry.getContract("committee");
1022     }
1023 
1024     function getElectionsContract() internal view returns (address) {
1025         return contractRegistry.getContract("elections");
1026     }
1027 
1028     function getDelegationsContract() internal view returns (address) {
1029         return contractRegistry.getContract("delegations");
1030     }
1031 
1032     function getGuardiansRegistrationContract() internal view returns (address) {
1033         return contractRegistry.getContract("guardiansRegistration");
1034     }
1035 
1036     function getCertificationContract() internal view returns (address) {
1037         return contractRegistry.getContract("certification");
1038     }
1039 
1040     function getStakingContract() internal view returns (address) {
1041         return contractRegistry.getContract("staking");
1042     }
1043 
1044     function getSubscriptionsContract() internal view returns (address) {
1045         return contractRegistry.getContract("subscriptions");
1046     }
1047 
1048     function getStakingRewardsWallet() internal view returns (address) {
1049         return contractRegistry.getContract("stakingRewardsWallet");
1050     }
1051 
1052     function getBootstrapRewardsWallet() internal view returns (address) {
1053         return contractRegistry.getContract("bootstrapRewardsWallet");
1054     }
1055 
1056     function getGeneralFeesWallet() internal view returns (address) {
1057         return contractRegistry.getContract("generalFeesWallet");
1058     }
1059 
1060     function getCertifiedFeesWallet() internal view returns (address) {
1061         return contractRegistry.getContract("certifiedFeesWallet");
1062     }
1063 
1064     function getStakingContractHandler() internal view returns (address) {
1065         return contractRegistry.getContract("stakingContractHandler");
1066     }
1067 
1068     /*
1069     * Governance functions
1070     */
1071 
1072     event ContractRegistryAddressUpdated(address addr);
1073 
1074     /// Sets the contract registry address
1075     /// @dev governance function called only by an admin
1076     /// @param newContractRegistry is the new registry contract 
1077     function setContractRegistry(IContractRegistry newContractRegistry) public override onlyAdmin {
1078         require(newContractRegistry.getPreviousContractRegistry() == address(contractRegistry), "new contract registry must provide the previous contract registry");
1079         contractRegistry = newContractRegistry;
1080         emit ContractRegistryAddressUpdated(address(newContractRegistry));
1081     }
1082 
1083     /// Returns the contract registry that the contract is set to use
1084     /// @return contractRegistry is the registry contract address
1085     function getContractRegistry() public override view returns (IContractRegistry) {
1086         return contractRegistry;
1087     }
1088 
1089     function setRegistryAdmin(address _registryAdmin) external override onlyInitializationAdmin {
1090         _transferRegistryManagement(_registryAdmin);
1091     }
1092 
1093 }
1094 
1095 // File: contracts/spec_interfaces/ILockable.sol
1096 
1097 pragma solidity 0.6.12;
1098 
1099 /// @title lockable contract interface, allows to lock a contract
1100 interface ILockable {
1101 
1102     event Locked();
1103     event Unlocked();
1104 
1105     /// Locks the contract to external non-governance function calls
1106     /// @dev governance function called only by the migration manager or an admin
1107     /// @dev typically called by the registry contract upon locking all managed contracts
1108     /// @dev getters and migration functions remain active also for locked contracts
1109     /// @dev checked by the onlyWhenActive modifier
1110     function lock() external /* onlyMigrationManager */;
1111 
1112     /// Unlocks the contract 
1113     /// @dev governance function called only by the migration manager or an admin
1114     /// @dev typically called by the registry contract upon unlocking all managed contracts
1115     function unlock() external /* onlyMigrationManager */;
1116 
1117     /// Returns the contract locking status
1118     /// @return isLocked is a bool indicating the contract is locked 
1119     function isLocked() view external returns (bool);
1120 
1121 }
1122 
1123 // File: contracts/Lockable.sol
1124 
1125 pragma solidity 0.6.12;
1126 
1127 
1128 
1129 /// @title lockable contract
1130 contract Lockable is ILockable, ContractRegistryAccessor {
1131 
1132     bool public locked;
1133 
1134     /// Constructor
1135     /// @param _contractRegistry is the contract registry address
1136     /// @param _registryAdmin is the registry admin address
1137     constructor(IContractRegistry _contractRegistry, address _registryAdmin) ContractRegistryAccessor(_contractRegistry, _registryAdmin) public {}
1138 
1139     /// Locks the contract to external non-governance function calls
1140     /// @dev governance function called only by the migration manager or an admin
1141     /// @dev typically called by the registry contract upon locking all managed contracts
1142     /// @dev getters and migration functions remain active also for locked contracts
1143     /// @dev checked by the onlyWhenActive modifier
1144     function lock() external override onlyMigrationManager {
1145         locked = true;
1146         emit Locked();
1147     }
1148 
1149     /// Unlocks the contract 
1150     /// @dev governance function called only by the migration manager or an admin
1151     /// @dev typically called by the registry contract upon unlocking all managed contracts
1152     function unlock() external override onlyMigrationManager {
1153         locked = false;
1154         emit Unlocked();
1155     }
1156 
1157     /// Returns the contract locking status
1158     /// @return isLocked is a bool indicating the contract is locked 
1159     function isLocked() external override view returns (bool) {
1160         return locked;
1161     }
1162 
1163     modifier onlyWhenActive() {
1164         require(!locked, "contract is locked for this operation");
1165 
1166         _;
1167     }
1168 }
1169 
1170 // File: contracts/ManagedContract.sol
1171 
1172 pragma solidity 0.6.12;
1173 
1174 
1175 
1176 /// @title managed contract
1177 contract ManagedContract is IManagedContract, Lockable {
1178 
1179     /// @param _contractRegistry is the contract registry address
1180     /// @param _registryAdmin is the registry admin address
1181     constructor(IContractRegistry _contractRegistry, address _registryAdmin) Lockable(_contractRegistry, _registryAdmin) public {}
1182 
1183     /// Refreshes the address of the other contracts the contract interacts with
1184     /// @dev called by the registry contract upon an update of a contract in the registry
1185     function refreshContracts() virtual override external {}
1186 
1187 }
1188 
1189 // File: contracts/Elections.sol
1190 
1191 pragma solidity 0.6.12;
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 
1200 /// @title Elections contract
1201 contract Elections is IElections, ManagedContract {
1202 	using SafeMath for uint256;
1203 
1204 	uint32 constant PERCENT_MILLIE_BASE = 100000;
1205 
1206 	mapping(address => mapping(address => uint256)) voteUnreadyVotes; // by => to => expiration
1207 	mapping(address => uint256) public votersStake;
1208 	mapping(address => address) voteOutVotes; // by => to
1209 	mapping(address => uint256) accumulatedStakesForVoteOut; // addr => total stake
1210 	mapping(address => bool) votedOutGuardians;
1211 
1212 	struct Settings {
1213 		uint32 minSelfStakePercentMille;
1214 		uint32 voteUnreadyPercentMilleThreshold;
1215 		uint32 voteOutPercentMilleThreshold;
1216 	}
1217 	Settings settings;
1218 
1219     /// Constructor
1220     /// @param _contractRegistry is the contract registry address
1221     /// @param _registryAdmin is the registry admin address
1222     /// @param minSelfStakePercentMille is the minimum self stake in percent-mille (0-100,000) 
1223     /// @param voteUnreadyPercentMilleThreshold is the minimum vote-unready threshold in percent-mille (0-100,000)
1224     /// @param voteOutPercentMilleThreshold is the minimum vote-out threshold in percent-mille (0-100,000)
1225 	constructor(IContractRegistry _contractRegistry, address _registryAdmin, uint32 minSelfStakePercentMille, uint32 voteUnreadyPercentMilleThreshold, uint32 voteOutPercentMilleThreshold) ManagedContract(_contractRegistry, _registryAdmin) public {
1226 		setMinSelfStakePercentMille(minSelfStakePercentMille);
1227 		setVoteOutPercentMilleThreshold(voteOutPercentMilleThreshold);
1228 		setVoteUnreadyPercentMilleThreshold(voteUnreadyPercentMilleThreshold);
1229 	}
1230 
1231 	modifier onlyDelegationsContract() {
1232 		require(msg.sender == address(delegationsContract), "caller is not the delegations contract");
1233 
1234 		_;
1235 	}
1236 
1237 	modifier onlyGuardiansRegistrationContract() {
1238 		require(msg.sender == address(guardianRegistrationContract), "caller is not the guardian registrations contract");
1239 
1240 		_;
1241 	}
1242 
1243 	modifier onlyCertificationContract() {
1244 		require(msg.sender == address(certificationContract), "caller is not the certification contract");
1245 
1246 		_;
1247 	}
1248 
1249 	/*
1250 	 * External functions
1251 	 */
1252 
1253     /// Notifies that the guardian is ready to sync with other nodes
1254     /// @dev ready to sync state is not managed in the contract that only emits an event
1255     /// @dev readyToSync clears the readyForCommittee state
1256 	function readyToSync() external override onlyWhenActive {
1257 		address guardian = guardianRegistrationContract.resolveGuardianAddress(msg.sender); // this validates registration
1258 		require(!isVotedOut(guardian), "caller is voted-out");
1259 
1260 		emit GuardianStatusUpdated(guardian, true, false);
1261 
1262 		committeeContract.removeMember(guardian);
1263 	}
1264 
1265     /// Notifies that the guardian is ready to join the committee
1266     /// @dev a qualified guardian calling readyForCommittee is added to the committee
1267 	function readyForCommittee() external override onlyWhenActive {
1268 		_readyForCommittee(msg.sender);
1269 	}
1270 
1271     /// Checks if a guardian is qualified to join the committee
1272     /// @dev when true, calling readyForCommittee() will result in adding the guardian to the committee
1273     /// @dev called periodically by guardians to check if they are qualified to join the committee
1274     /// @param guardian is the guardian to check
1275     /// @return canJoin indicating that the guardian can join the current committee
1276 	function canJoinCommittee(address guardian) external view override returns (bool) {
1277 		guardian = guardianRegistrationContract.resolveGuardianAddress(guardian); // this validates registration
1278 
1279 		if (isVotedOut(guardian)) {
1280 			return false;
1281 		}
1282 
1283 		uint256 effectiveStake = getGuardianEffectiveStake(guardian, settings);
1284 		return committeeContract.checkAddMember(guardian, effectiveStake);
1285 	}
1286 
1287     /// Returns an address effective stake
1288     /// The effective stake is derived from a guardian delegate stake and selfs stake  
1289     /// @return effectiveStake is the guardian's effective stake
1290 	function getEffectiveStake(address guardian) external override view returns (uint effectiveStake) {
1291 		return getGuardianEffectiveStake(guardian, settings);
1292 	}
1293 
1294     /// Returns the current committee along with the guardians' Orbs address and IP
1295     /// @return committee is a list of the committee members' guardian addresses
1296     /// @return weights is a list of the committee members' weight (effective stake)
1297     /// @return orbsAddrs is a list of the committee members' orbs address
1298     /// @return certification is a list of bool indicating the committee members certification
1299     /// @return ips is a list of the committee members' ip
1300 	function getCommittee() external override view returns (address[] memory committee, uint256[] memory weights, address[] memory orbsAddrs, bool[] memory certification, bytes4[] memory ips) {
1301 		IGuardiansRegistration _guardianRegistrationContract = guardianRegistrationContract;
1302 		(committee, weights, certification) = committeeContract.getCommittee();
1303 		orbsAddrs = _guardianRegistrationContract.getGuardiansOrbsAddress(committee);
1304 		ips = _guardianRegistrationContract.getGuardianIps(committee);
1305 	}
1306 
1307 	// Vote-unready
1308 
1309     /// Casts an unready vote on a subject guardian
1310     /// @dev Called by a guardian as part of the automatic vote-unready flow
1311     /// @dev The transaction may be sent from the guardian or orbs address.
1312     /// @param subject is the subject guardian to vote out
1313     /// @param voteExpiration is the expiration time of the vote unready to prevent counting of a vote that is already irrelevant.
1314 	function voteUnready(address subject, uint voteExpiration) external override onlyWhenActive {
1315 		require(voteExpiration >= block.timestamp, "vote expiration time must not be in the past");
1316 
1317 		address voter = guardianRegistrationContract.resolveGuardianAddress(msg.sender);
1318 		voteUnreadyVotes[voter][subject] = voteExpiration;
1319 		emit VoteUnreadyCasted(voter, subject, voteExpiration);
1320 
1321 		(address[] memory generalCommittee, uint256[] memory generalWeights, bool[] memory certification) = committeeContract.getCommittee();
1322 
1323 		bool votedUnready = isCommitteeVoteUnreadyThresholdReached(generalCommittee, generalWeights, certification, subject);
1324 		if (votedUnready) {
1325 			clearCommitteeUnreadyVotes(generalCommittee, subject);
1326 			emit GuardianVotedUnready(subject);
1327 
1328 			emit GuardianStatusUpdated(subject, false, false);
1329 			committeeContract.removeMember(subject);
1330 		}
1331 	}
1332 
1333     /// Returns the current vote unready vote for a voter and a subject pair
1334     /// @param voter is the voting guardian address
1335     /// @param subject is the subject guardian address
1336     /// @return valid indicates whether there is a valid vote
1337     /// @return expiration returns the votes expiration time
1338 	function getVoteUnreadyVote(address voter, address subject) public override view returns (bool valid, uint256 expiration) {
1339 		expiration = voteUnreadyVotes[voter][subject];
1340 		valid = expiration != 0 && block.timestamp < expiration;
1341 	}
1342 
1343     /// Returns the current vote-unready status of a subject guardian.
1344     /// @dev the committee and certification data is used to check the certified and committee threshold
1345     /// @param subject is the subject guardian address
1346     /// @return committee is a list of the current committee members
1347     /// @return weights is a list of the current committee members weight
1348     /// @return certification is a list of bool indicating the committee members certification
1349     /// @return votes is a list of bool indicating the members that votes the subject unready
1350     /// @return subjectInCommittee indicates that the subject is in the committee
1351     /// @return subjectInCertifiedCommittee indicates that the subject is in the certified committee
1352 	function getVoteUnreadyStatus(address subject) external override view returns (address[] memory committee, uint256[] memory weights, bool[] memory certification, bool[] memory votes, bool subjectInCommittee, bool subjectInCertifiedCommittee) {
1353 		(committee, weights, certification) = committeeContract.getCommittee();
1354 
1355 		votes = new bool[](committee.length);
1356 		for (uint i = 0; i < committee.length; i++) {
1357 			address memberAddr = committee[i];
1358 			if (block.timestamp < voteUnreadyVotes[memberAddr][subject]) {
1359 				votes[i] = true;
1360 			}
1361 
1362 			if (memberAddr == subject) {
1363 				subjectInCommittee = true;
1364 				subjectInCertifiedCommittee = certification[i];
1365 			}
1366 		}
1367 	}
1368 
1369 	// Vote-out
1370 
1371     /// Casts a voteOut vote by the sender to the given address
1372     /// @dev the transaction is sent from the guardian address
1373     /// @param subject is the subject guardian address
1374 	function voteOut(address subject) external override onlyWhenActive {
1375 		Settings memory _settings = settings;
1376 
1377 		address voter = msg.sender;
1378 		address prevSubject = voteOutVotes[voter];
1379 
1380 		voteOutVotes[voter] = subject;
1381 		emit VoteOutCasted(voter, subject);
1382 
1383 		uint256 voterStake = delegationsContract.getDelegatedStake(voter);
1384 
1385 		if (prevSubject == address(0)) {
1386 			votersStake[voter] = voterStake;
1387 		}
1388 
1389 		if (subject == address(0)) {
1390 			delete votersStake[voter];
1391 		}
1392 
1393 		uint totalStake = delegationsContract.getTotalDelegatedStake();
1394 
1395 		if (prevSubject != address(0) && prevSubject != subject) {
1396 			applyVoteOutVotesFor(prevSubject, 0, voterStake, totalStake, _settings);
1397 		}
1398 
1399 		if (subject != address(0)) {
1400 			uint voteStakeAdded = prevSubject != subject ? voterStake : 0;
1401 			applyVoteOutVotesFor(subject, voteStakeAdded, 0, totalStake, _settings); // recheck also if not new
1402 		}
1403 	}
1404 
1405     /// Returns the subject address the addr has voted-out against
1406     /// @param voter is the voting guardian address
1407     /// @return subject is the subject the voter has voted out
1408 	function getVoteOutVote(address voter) external override view returns (address) {
1409 		return voteOutVotes[voter];
1410 	}
1411 
1412     /// Returns the governance voteOut status of a guardian.
1413     /// @dev A guardian is voted out if votedStake / totalDelegatedStake (in percent mille) > threshold
1414     /// @param subject is the subject guardian address
1415     /// @return votedOut indicates whether the subject was voted out
1416     /// @return votedStake is the total stake voting against the subject
1417     /// @return totalDelegatedStake is the total delegated stake
1418 	function getVoteOutStatus(address subject) external override view returns (bool votedOut, uint votedStake, uint totalDelegatedStake) {
1419 		votedOut = isVotedOut(subject);
1420 		votedStake = accumulatedStakesForVoteOut[subject];
1421 		totalDelegatedStake = delegationsContract.getTotalDelegatedStake();
1422 	}
1423 
1424 	/*
1425 	 * Notification functions from other PoS contracts
1426 	 */
1427 
1428     /// Notifies a delegated stake change event
1429     /// @dev Called by: delegation contract
1430     /// @param delegate is the delegate to update
1431     /// @param selfDelegatedStake is the delegate self stake (0 if not self-delegating)
1432     /// @param delegatedStake is the delegate delegated stake (0 if not self-delegating)
1433     /// @param totalDelegatedStake is the total delegated stake
1434 	function delegatedStakeChange(address delegate, uint256 selfDelegatedStake, uint256 delegatedStake, uint256 totalDelegatedStake) external override onlyDelegationsContract onlyWhenActive {
1435 		Settings memory _settings = settings;
1436 
1437 		uint effectiveStake = calcEffectiveStake(selfDelegatedStake, delegatedStake, _settings);
1438 		emit StakeChanged(delegate, selfDelegatedStake, delegatedStake, effectiveStake);
1439 
1440 		committeeContract.memberWeightChange(delegate, effectiveStake);
1441 
1442 		applyStakesToVoteOutBy(delegate, delegatedStake, totalDelegatedStake, _settings);
1443 	}
1444 
1445     /// Notifies a new guardian was unregistered
1446     /// @dev Called by: guardian registration contract
1447     /// @dev when a guardian unregisters its status is updated to not ready to sync and is removed from the committee
1448     /// @param guardian is the address of the guardian that unregistered
1449 	function guardianUnregistered(address guardian) external override onlyGuardiansRegistrationContract onlyWhenActive {
1450 		emit GuardianStatusUpdated(guardian, false, false);
1451 		committeeContract.removeMember(guardian);
1452 	}
1453 
1454     /// Notifies on a guardian certification change
1455     /// @dev Called by: guardian registration contract
1456     /// @param guardian is the address of the guardian to update
1457     /// @param isCertified indicates whether the guardian is certified
1458 	function guardianCertificationChanged(address guardian, bool isCertified) external override onlyCertificationContract onlyWhenActive {
1459 		committeeContract.memberCertificationChange(guardian, isCertified);
1460 	}
1461 
1462 	/*
1463      * Governance functions
1464 	 */
1465 
1466     /// Sets the minimum self stake requirement for the effective stake
1467     /// @dev governance function called only by the functional manager
1468     /// @param minSelfStakePercentMille is the minimum self stake in percent-mille (0-100,000) 
1469 	function setMinSelfStakePercentMille(uint32 minSelfStakePercentMille) public override onlyFunctionalManager {
1470 		require(minSelfStakePercentMille <= PERCENT_MILLIE_BASE, "minSelfStakePercentMille must be 100000 at most");
1471 		emit MinSelfStakePercentMilleChanged(minSelfStakePercentMille, settings.minSelfStakePercentMille);
1472 		settings.minSelfStakePercentMille = minSelfStakePercentMille;
1473 	}
1474 
1475     /// Returns the minimum self-stake required for the effective stake
1476     /// @return minSelfStakePercentMille is the minimum self stake in percent-mille 
1477 	function getMinSelfStakePercentMille() external override view returns (uint32) {
1478 		return settings.minSelfStakePercentMille;
1479 	}
1480 
1481     /// Sets the vote-out threshold
1482     /// @dev governance function called only by the functional manager
1483     /// @param voteOutPercentMilleThreshold is the minimum threshold in percent-mille (0-100,000)
1484 	function setVoteOutPercentMilleThreshold(uint32 voteOutPercentMilleThreshold) public override onlyFunctionalManager {
1485 		require(voteOutPercentMilleThreshold <= PERCENT_MILLIE_BASE, "voteOutPercentMilleThreshold must not be larger than 100000");
1486 		emit VoteOutPercentMilleThresholdChanged(voteOutPercentMilleThreshold, settings.voteOutPercentMilleThreshold);
1487 		settings.voteOutPercentMilleThreshold = voteOutPercentMilleThreshold;
1488 	}
1489 
1490     /// Returns the vote-out threshold
1491     /// @return voteOutPercentMilleThreshold is the minimum threshold in percent-mille
1492 	function getVoteOutPercentMilleThreshold() external override view returns (uint32) {
1493 		return settings.voteOutPercentMilleThreshold;
1494 	}
1495 
1496     /// Sets the vote-unready threshold
1497     /// @dev governance function called only by the functional manager
1498     /// @param voteUnreadyPercentMilleThreshold is the minimum threshold in percent-mille (0-100,000)
1499 	function setVoteUnreadyPercentMilleThreshold(uint32 voteUnreadyPercentMilleThreshold) public override onlyFunctionalManager {
1500 		require(voteUnreadyPercentMilleThreshold <= PERCENT_MILLIE_BASE, "voteUnreadyPercentMilleThreshold must not be larger than 100000");
1501 		emit VoteUnreadyPercentMilleThresholdChanged(voteUnreadyPercentMilleThreshold, settings.voteUnreadyPercentMilleThreshold);
1502 		settings.voteUnreadyPercentMilleThreshold = voteUnreadyPercentMilleThreshold;
1503 	}
1504 
1505     /// Returns the vote-unready threshold
1506     /// @return voteUnreadyPercentMilleThreshold is the minimum threshold in percent-mille
1507 	function getVoteUnreadyPercentMilleThreshold() external override view returns (uint32) {
1508 		return settings.voteUnreadyPercentMilleThreshold;
1509 	}
1510 
1511     /// Returns the contract's settings 
1512     /// @return minSelfStakePercentMille is the minimum self stake in percent-mille
1513     /// @return voteUnreadyPercentMilleThreshold is the minimum threshold in percent-mille
1514     /// @return voteOutPercentMilleThreshold is the minimum threshold in percent-mille
1515 	function getSettings() external override view returns (
1516 		uint32 minSelfStakePercentMille,
1517 		uint32 voteUnreadyPercentMilleThreshold,
1518 		uint32 voteOutPercentMilleThreshold
1519 	) {
1520 		Settings memory _settings = settings;
1521 		minSelfStakePercentMille = _settings.minSelfStakePercentMille;
1522 		voteUnreadyPercentMilleThreshold = _settings.voteUnreadyPercentMilleThreshold;
1523 		voteOutPercentMilleThreshold = _settings.voteOutPercentMilleThreshold;
1524 	}
1525 
1526     /// Initializes the ready for committee notification for the committee guardians
1527     /// @dev governance function called only by the initialization admin during migration 
1528     /// @dev identical behaviour as if each guardian sent readyForCommittee() 
1529     /// @param guardians a list of guardians addresses to update
1530 	function initReadyForCommittee(address[] calldata guardians) external override onlyInitializationAdmin {
1531 		for (uint i = 0; i < guardians.length; i++) {
1532 			_readyForCommittee(guardians[i]);
1533 		}
1534 	}
1535 
1536 	/*
1537      * Private functions
1538 	 */
1539 
1540 
1541     /// Handles a readyForCommittee notification
1542     /// @dev may be called with either the guardian address or the guardian's orbs address
1543     /// @dev notifies the committee contract that will add the guardian if qualified
1544     /// @param guardian is the guardian ready for committee
1545 	function _readyForCommittee(address guardian) private {
1546 		guardian = guardianRegistrationContract.resolveGuardianAddress(guardian); // this validates registration
1547 		require(!isVotedOut(guardian), "caller is voted-out");
1548 
1549 		emit GuardianStatusUpdated(guardian, true, true);
1550 
1551 		uint256 effectiveStake = getGuardianEffectiveStake(guardian, settings);
1552 		committeeContract.addMember(guardian, effectiveStake, certificationContract.isGuardianCertified(guardian));
1553 	}
1554 
1555     /// Calculates a guardian effective stake based on its self-stake and delegated stake
1556 	function calcEffectiveStake(uint256 selfStake, uint256 delegatedStake, Settings memory _settings) private pure returns (uint256) {
1557 		if (selfStake.mul(PERCENT_MILLIE_BASE) >= delegatedStake.mul(_settings.minSelfStakePercentMille)) {
1558 			return delegatedStake;
1559 		}
1560 		return selfStake.mul(PERCENT_MILLIE_BASE).div(_settings.minSelfStakePercentMille); // never overflows or divides by zero
1561 	}
1562 
1563     /// Returns the effective state of a guardian 
1564     /// @dev calls the delegation contract to retrieve the guardian current stake and delegated stake
1565     /// @param guardian is the guardian to query
1566     /// @param _settings is the contract settings struct
1567     /// @return effectiveStake is the guardian's effective stake
1568 	function getGuardianEffectiveStake(address guardian, Settings memory _settings) private view returns (uint256 effectiveStake) {
1569 		IDelegations _delegationsContract = delegationsContract;
1570 		(,uint256 selfStake) = _delegationsContract.getDelegationInfo(guardian);
1571 		uint256 delegatedStake = _delegationsContract.getDelegatedStake(guardian);
1572 		return calcEffectiveStake(selfStake, delegatedStake, _settings);
1573 	}
1574 
1575 	// Vote-unready
1576 
1577     /// Checks if the vote unready threshold was reached for a given subject
1578     /// @dev a subject is voted-unready if either it reaches the threshold in the general committee or a certified subject reaches the threshold in the certified committee
1579     /// @param committee is a list of the current committee members
1580     /// @param weights is a list of the current committee members weight
1581     /// @param certification is a list of bool indicating the committee members certification
1582     /// @param subject is the subject guardian address
1583     /// @return thresholdReached is a bool indicating that the threshold was reached
1584 	function isCommitteeVoteUnreadyThresholdReached(address[] memory committee, uint256[] memory weights, bool[] memory certification, address subject) private returns (bool) {
1585 		Settings memory _settings = settings;
1586 
1587 		uint256 totalCommitteeStake = 0;
1588 		uint256 totalVoteUnreadyStake = 0;
1589 		uint256 totalCertifiedStake = 0;
1590 		uint256 totalCertifiedVoteUnreadyStake = 0;
1591 
1592 		address member;
1593 		uint256 memberStake;
1594 		bool isSubjectCertified;
1595 		for (uint i = 0; i < committee.length; i++) {
1596 			member = committee[i];
1597 			memberStake = weights[i];
1598 
1599 			if (member == subject && certification[i]) {
1600 				isSubjectCertified = true;
1601 			}
1602 
1603 			totalCommitteeStake = totalCommitteeStake.add(memberStake);
1604 			if (certification[i]) {
1605 				totalCertifiedStake = totalCertifiedStake.add(memberStake);
1606 			}
1607 
1608 			(bool valid, uint256 expiration) = getVoteUnreadyVote(member, subject);
1609 			if (valid) {
1610 				totalVoteUnreadyStake = totalVoteUnreadyStake.add(memberStake);
1611 				if (certification[i]) {
1612 					totalCertifiedVoteUnreadyStake = totalCertifiedVoteUnreadyStake.add(memberStake);
1613 				}
1614 			} else if (expiration != 0) {
1615 				// Vote is stale, delete from state
1616 				delete voteUnreadyVotes[member][subject];
1617 			}
1618 		}
1619 
1620 		return (
1621 			totalCommitteeStake > 0 &&
1622 			totalVoteUnreadyStake.mul(PERCENT_MILLIE_BASE) >= uint256(_settings.voteUnreadyPercentMilleThreshold).mul(totalCommitteeStake)
1623 		) || (
1624 			isSubjectCertified &&
1625 			totalCertifiedStake > 0 &&
1626 			totalCertifiedVoteUnreadyStake.mul(PERCENT_MILLIE_BASE) >= uint256(_settings.voteUnreadyPercentMilleThreshold).mul(totalCertifiedStake)
1627 		);
1628 	}
1629 
1630     /// Clears the committee members vote-unready state upon declaring a guardian unready
1631     /// @param committee is a list of the current committee members
1632     /// @param subject is the subject guardian address
1633 	function clearCommitteeUnreadyVotes(address[] memory committee, address subject) private {
1634 		for (uint i = 0; i < committee.length; i++) {
1635 			voteUnreadyVotes[committee[i]][subject] = 0; // clear vote-outs
1636 		}
1637 	}
1638 
1639 	// Vote-out
1640 
1641     /// Updates the vote-out state upon a stake change notification
1642     /// @param voter is the voter address
1643     /// @param currentVoterStake is the voter delegated stake
1644     /// @param totalDelegatedStake is the total delegated stake
1645     /// @param _settings is the contract settings struct
1646 	function applyStakesToVoteOutBy(address voter, uint256 currentVoterStake, uint256 totalDelegatedStake, Settings memory _settings) private {
1647 		address subject = voteOutVotes[voter];
1648 		if (subject == address(0)) return;
1649 
1650 		uint256 prevVoterStake = votersStake[voter];
1651 		votersStake[voter] = currentVoterStake;
1652 
1653 		applyVoteOutVotesFor(subject, currentVoterStake, prevVoterStake, totalDelegatedStake, _settings);
1654 	}
1655 
1656     /// Applies updates in a vote-out subject state and checks whether its threshold was reached
1657     /// @param subject is the vote-out subject
1658     /// @param voteOutStakeAdded is the added votes against the subject
1659     /// @param voteOutStakeRemoved is the removed votes against the subject
1660     /// @param totalDelegatedStake is the total delegated stake used to check the vote-out threshold
1661     /// @param _settings is the contract settings struct
1662     function applyVoteOutVotesFor(address subject, uint256 voteOutStakeAdded, uint256 voteOutStakeRemoved, uint256 totalDelegatedStake, Settings memory _settings) private {
1663 		if (isVotedOut(subject)) {
1664 			return;
1665 		}
1666 
1667 		uint256 accumulated = accumulatedStakesForVoteOut[subject].
1668 			sub(voteOutStakeRemoved).
1669 			add(voteOutStakeAdded);
1670 
1671 		bool shouldBeVotedOut = totalDelegatedStake > 0 && accumulated.mul(PERCENT_MILLIE_BASE) >= uint256(_settings.voteOutPercentMilleThreshold).mul(totalDelegatedStake);
1672 		if (shouldBeVotedOut) {
1673 			votedOutGuardians[subject] = true;
1674 			emit GuardianVotedOut(subject);
1675 
1676 			emit GuardianStatusUpdated(subject, false, false);
1677 			committeeContract.removeMember(subject);
1678 		}
1679 
1680 		accumulatedStakesForVoteOut[subject] = accumulated;
1681 	}
1682 
1683     /// Checks whether a guardian was voted out
1684 	function isVotedOut(address guardian) private view returns (bool) {
1685 		return votedOutGuardians[guardian];
1686 	}
1687 
1688 	/*
1689      * Contracts topology / registry interface
1690      */
1691 
1692 	ICommittee committeeContract;
1693 	IDelegations delegationsContract;
1694 	IGuardiansRegistration guardianRegistrationContract;
1695 	ICertification certificationContract;
1696 
1697     /// Refreshes the address of the other contracts the contract interacts with
1698     /// @dev called by the registry contract upon an update of a contract in the registry
1699 	function refreshContracts() external override {
1700 		committeeContract = ICommittee(getCommitteeContract());
1701 		delegationsContract = IDelegations(getDelegationsContract());
1702 		guardianRegistrationContract = IGuardiansRegistration(getGuardiansRegistrationContract());
1703 		certificationContract = ICertification(getCertificationContract());
1704 	}
1705 
1706 }