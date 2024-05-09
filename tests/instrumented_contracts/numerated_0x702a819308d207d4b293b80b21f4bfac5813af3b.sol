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
165 
166 pragma solidity 0.6.12;
167 
168 /// @title Elections contract interface
169 interface IElections {
170 	
171 	// Election state change events
172 	event StakeChanged(address indexed addr, uint256 selfStake, uint256 delegatedStake, uint256 effectiveStake);
173 	event GuardianStatusUpdated(address indexed guardian, bool readyToSync, bool readyForCommittee);
174 
175 	// Vote out / Vote unready
176 	event GuardianVotedUnready(address indexed guardian);
177 	event VoteUnreadyCasted(address indexed voter, address indexed subject, uint256 expiration);
178 	event GuardianVotedOut(address indexed guardian);
179 	event VoteOutCasted(address indexed voter, address indexed subject);
180 
181 	/*
182 	 * External functions
183 	 */
184 
185 	/// @dev Called by a guardian when ready to start syncing with other nodes
186 	function readyToSync() external;
187 
188 	/// @dev Called by a guardian when ready to join the committee, typically after syncing is complete or after being voted out
189 	function readyForCommittee() external;
190 
191 	/// @dev Called to test if a guardian calling readyForCommittee() will lead to joining the committee
192 	function canJoinCommittee(address guardian) external view returns (bool);
193 
194 	/// @dev Returns an address effective stake
195 	function getEffectiveStake(address guardian) external view returns (uint effectiveStake);
196 
197 	/// @dev returns the current committee
198 	/// used also by the rewards and fees contracts
199 	function getCommittee() external view returns (address[] memory committee, uint256[] memory weights, address[] memory orbsAddrs, bool[] memory certification, bytes4[] memory ips);
200 
201 	// Vote-unready
202 
203 	/// @dev Called by a guardian as part of the automatic vote-unready flow
204 	function voteUnready(address subject, uint expiration) external;
205 
206 	function getVoteUnreadyVote(address voter, address subject) external view returns (bool valid, uint256 expiration);
207 
208 	/// @dev Returns the current vote-unready status of a subject guardian.
209 	/// votes indicates wether the specific committee member voted the guardian unready
210 	function getVoteUnreadyStatus(address subject) external view returns (
211 		address[] memory committee,
212 		uint256[] memory weights,
213 		bool[] memory certification,
214 		bool[] memory votes,
215 		bool subjectInCommittee,
216 		bool subjectInCertifiedCommittee
217 	);
218 
219 	// Vote-out
220 
221 	/// @dev Casts a voteOut vote by the sender to the given address
222 	function voteOut(address subject) external;
223 
224 	/// @dev Returns the subject address the addr has voted-out against
225 	function getVoteOutVote(address voter) external view returns (address);
226 
227 	/// @dev Returns the governance voteOut status of a guardian.
228 	/// A guardian is voted out if votedStake / totalDelegatedStake (in percent mille) > threshold
229 	function getVoteOutStatus(address subject) external view returns (bool votedOut, uint votedStake, uint totalDelegatedStake);
230 
231 	/*
232 	 * Notification functions from other PoS contracts
233 	 */
234 
235 	/// @dev Called by: delegation contract
236 	/// Notifies a delegated stake change event
237 	/// total_delegated_stake = 0 if addr delegates to another guardian
238 	function delegatedStakeChange(address delegate, uint256 selfStake, uint256 delegatedStake, uint256 totalDelegatedStake) external /* onlyDelegationsContract onlyWhenActive */;
239 
240 	/// @dev Called by: guardian registration contract
241 	/// Notifies a new guardian was unregistered
242 	function guardianUnregistered(address guardian) external /* onlyGuardiansRegistrationContract */;
243 
244 	/// @dev Called by: guardian registration contract
245 	/// Notifies on a guardian certification change
246 	function guardianCertificationChanged(address guardian, bool isCertified) external /* onlyCertificationContract */;
247 
248 
249 	/*
250      * Governance functions
251 	 */
252 
253 	event VoteUnreadyTimeoutSecondsChanged(uint32 newValue, uint32 oldValue);
254 	event VoteOutPercentMilleThresholdChanged(uint32 newValue, uint32 oldValue);
255 	event VoteUnreadyPercentMilleThresholdChanged(uint32 newValue, uint32 oldValue);
256 	event MinSelfStakePercentMilleChanged(uint32 newValue, uint32 oldValue);
257 
258 	/// @dev Sets the minimum self-stake required for the effective stake
259 	/// minSelfStakePercentMille - the minimum self stake in percent-mille (0-100,000)
260 	function setMinSelfStakePercentMille(uint32 minSelfStakePercentMille) external /* onlyFunctionalManager onlyWhenActive */;
261 
262 	/// @dev Returns the minimum self-stake required for the effective stake
263 	function getMinSelfStakePercentMille() external view returns (uint32);
264 
265 	/// @dev Sets the vote-out threshold
266 	/// voteOutPercentMilleThreshold - the minimum threshold in percent-mille (0-100,000)
267 	function setVoteOutPercentMilleThreshold(uint32 voteUnreadyPercentMilleThreshold) external /* onlyFunctionalManager onlyWhenActive */;
268 
269 	/// @dev Returns the vote-out threshold
270 	function getVoteOutPercentMilleThreshold() external view returns (uint32);
271 
272 	/// @dev Sets the vote-unready threshold
273 	/// voteUnreadyPercentMilleThreshold - the minimum threshold in percent-mille (0-100,000)
274 	function setVoteUnreadyPercentMilleThreshold(uint32 voteUnreadyPercentMilleThreshold) external /* onlyFunctionalManager onlyWhenActive */;
275 
276 	/// @dev Returns the vote-unready threshold
277 	function getVoteUnreadyPercentMilleThreshold() external view returns (uint32);
278 
279 	/// @dev Returns the contract's settings 
280 	function getSettings() external view returns (
281 		uint32 minSelfStakePercentMille,
282 		uint32 voteUnreadyPercentMilleThreshold,
283 		uint32 voteOutPercentMilleThreshold
284 	);
285 
286 	function initReadyForCommittee(address[] calldata guardians) external /* onlyInitializationAdmin */;
287 
288 }
289 
290 // File: contracts/spec_interfaces/IDelegation.sol
291 
292 
293 pragma solidity 0.6.12;
294 
295 /// @title Delegations contract interface
296 interface IDelegations /* is IStakeChangeNotifier */ {
297 
298     // Delegation state change events
299 	event DelegatedStakeChanged(address indexed addr, uint256 selfDelegatedStake, uint256 delegatedStake, address indexed delegator, uint256 delegatorContributedStake);
300 
301     // Function calls
302 	event Delegated(address indexed from, address indexed to);
303 
304 	/*
305      * External functions
306      */
307 
308 	/// @dev Stake delegation
309 	function delegate(address to) external /* onlyWhenActive */;
310 
311 	function refreshStake(address addr) external /* onlyWhenActive */;
312 
313 	function getDelegatedStake(address addr) external view returns (uint256);
314 
315 	function getDelegation(address addr) external view returns (address);
316 
317 	function getDelegationInfo(address addr) external view returns (address delegation, uint256 delegatorStake);
318 
319 	function getTotalDelegatedStake() external view returns (uint256) ;
320 
321 	/*
322 	 * Governance functions
323 	 */
324 
325 	event DelegationsImported(address[] from, address indexed to);
326 
327 	event DelegationInitialized(address indexed from, address indexed to);
328 
329 	function importDelegations(address[] calldata from, address to) external /* onlyMigrationManager onlyDuringDelegationImport */;
330 
331 	function initDelegation(address from, address to) external /* onlyInitializationAdmin */;
332 }
333 
334 // File: contracts/spec_interfaces/IGuardiansRegistration.sol
335 
336 
337 pragma solidity 0.6.12;
338 
339 /// @title Guardian registration contract interface
340 interface IGuardiansRegistration {
341 	event GuardianRegistered(address indexed guardian);
342 	event GuardianUnregistered(address indexed guardian);
343 	event GuardianDataUpdated(address indexed guardian, bool isRegistered, bytes4 ip, address orbsAddr, string name, string website);
344 	event GuardianMetadataChanged(address indexed guardian, string key, string newValue, string oldValue);
345 
346 	/*
347      * External methods
348      */
349 
350     /// @dev Called by a participant who wishes to register as a guardian
351 	function registerGuardian(bytes4 ip, address orbsAddr, string calldata name, string calldata website) external;
352 
353     /// @dev Called by a participant who wishes to update its propertires
354 	function updateGuardian(bytes4 ip, address orbsAddr, string calldata name, string calldata website) external;
355 
356 	/// @dev Called by a participant who wishes to update its IP address (can be call by both main and Orbs addresses)
357 	function updateGuardianIp(bytes4 ip) external /* onlyWhenActive */;
358 
359     /// @dev Called by a participant to update additional guardian metadata properties.
360     function setMetadata(string calldata key, string calldata value) external;
361 
362     /// @dev Called by a participant to get additional guardian metadata properties.
363     function getMetadata(address guardian, string calldata key) external view returns (string memory);
364 
365     /// @dev Called by a participant who wishes to unregister
366 	function unregisterGuardian() external;
367 
368     /// @dev Returns a guardian's data
369 	function getGuardianData(address guardian) external view returns (bytes4 ip, address orbsAddr, string memory name, string memory website, uint registrationTime, uint lastUpdateTime);
370 
371 	/// @dev Returns the Orbs addresses of a list of guardians
372 	function getGuardiansOrbsAddress(address[] calldata guardianAddrs) external view returns (address[] memory orbsAddrs);
373 
374 	/// @dev Returns a guardian's ip
375 	function getGuardianIp(address guardian) external view returns (bytes4 ip);
376 
377 	/// @dev Returns guardian ips
378 	function getGuardianIps(address[] calldata guardian) external view returns (bytes4[] memory ips);
379 
380 	/// @dev Returns true if the given address is of a registered guardian
381 	function isRegistered(address guardian) external view returns (bool);
382 
383 	/// @dev Translates a list guardians Orbs addresses to guardian addresses
384 	function getGuardianAddresses(address[] calldata orbsAddrs) external view returns (address[] memory guardianAddrs);
385 
386 	/// @dev Resolves the guardian address for a guardian, given a Guardian/Orbs address
387 	function resolveGuardianAddress(address guardianOrOrbsAddress) external view returns (address guardianAddress);
388 
389 	/*
390 	 * Governance functions
391 	 */
392 
393 	function migrateGuardians(address[] calldata guardiansToMigrate, IGuardiansRegistration previousContract) external /* onlyInitializationAdmin */;
394 
395 }
396 
397 // File: contracts/spec_interfaces/ICommittee.sol
398 
399 
400 pragma solidity 0.6.12;
401 
402 /// @title Committee contract interface
403 interface ICommittee {
404 	event CommitteeChange(address indexed addr, uint256 weight, bool certification, bool inCommittee);
405 	event CommitteeSnapshot(address[] addrs, uint256[] weights, bool[] certification);
406 
407 	// No external functions
408 
409 	/*
410      * External functions
411      */
412 
413 	/// @dev Called by: Elections contract
414 	/// Notifies a weight change of certification change of a member
415 	function memberWeightChange(address addr, uint256 weight) external /* onlyElectionsContract onlyWhenActive */;
416 
417 	function memberCertificationChange(address addr, bool isCertified) external /* onlyElectionsContract onlyWhenActive */;
418 
419 	/// @dev Called by: Elections contract
420 	/// Notifies a a member removal for example due to voteOut / voteUnready
421 	function removeMember(address addr) external returns (bool memberRemoved, uint removedMemberWeight, bool removedMemberCertified)/* onlyElectionContract */;
422 
423 	/// @dev Called by: Elections contract
424 	/// Notifies a new member applicable for committee (due to registration, unbanning, certification change)
425 	function addMember(address addr, uint256 weight, bool isCertified) external returns (bool memberAdded)  /* onlyElectionsContract */;
426 
427 	/// @dev Called by: Elections contract
428 	/// Checks if addMember() would add a the member to the committee
429 	function checkAddMember(address addr, uint256 weight) external view returns (bool wouldAddMember);
430 
431 	/// @dev Called by: Elections contract
432 	/// Returns the committee members and their weights
433 	function getCommittee() external view returns (address[] memory addrs, uint256[] memory weights, bool[] memory certification);
434 
435 	function getCommitteeStats() external view returns (uint generalCommitteeSize, uint certifiedCommitteeSize, uint totalStake);
436 
437 	function getMemberInfo(address addr) external view returns (bool inCommittee, uint weight, bool isCertified, uint totalCommitteeWeight);
438 
439 	function emitCommitteeSnapshot() external;
440 
441 	/*
442 	 * Governance functions
443 	 */
444 
445 	event MaxCommitteeSizeChanged(uint8 newValue, uint8 oldValue);
446 
447 	function setMaxCommitteeSize(uint8 maxCommitteeSize) external /* onlyFunctionalManager onlyWhenActive */;
448 
449 	function getMaxCommitteeSize() external view returns (uint8);
450 
451 	function importMembers(ICommittee previousCommitteeContract) external /* onlyInitializationAdmin */;
452 }
453 
454 // File: contracts/spec_interfaces/ICertification.sol
455 
456 
457 pragma solidity 0.6.12;
458 
459 /// @title Elections contract interface
460 interface ICertification /* is Ownable */ {
461 	event GuardianCertificationUpdate(address indexed guardian, bool isCertified);
462 
463 	/*
464      * External methods
465      */
466 
467 	/// @dev Returns the certification status of a guardian
468 	function isGuardianCertified(address guardian) external view returns (bool isCertified);
469 
470 	/// @dev Sets the guardian certification status
471 	function setGuardianCertification(address guardian, bool isCertified) external /* Owner only */ ;
472 }
473 
474 // File: contracts/spec_interfaces/IContractRegistry.sol
475 
476 
477 pragma solidity 0.6.12;
478 
479 interface IContractRegistry {
480 
481 	event ContractAddressUpdated(string contractName, address addr, bool managedContract);
482 	event ManagerChanged(string role, address newManager);
483 	event ContractRegistryUpdated(address newContractRegistry);
484 
485 	/*
486 	* External functions
487 	*/
488 
489 	/// @dev updates the contracts address and emits a corresponding event
490 	/// managedContract indicates whether the contract is managed by the registry and notified on changes
491 	function setContract(string calldata contractName, address addr, bool managedContract) external /* onlyAdmin */;
492 
493 	/// @dev returns the current address of the given contracts
494 	function getContract(string calldata contractName) external view returns (address);
495 
496 	/// @dev returns the list of contract addresses managed by the registry
497 	function getManagedContracts() external view returns (address[] memory);
498 
499 	function setManager(string calldata role, address manager) external /* onlyAdmin */;
500 
501 	function getManager(string calldata role) external view returns (address);
502 
503 	function lockContracts() external /* onlyAdmin */;
504 
505 	function unlockContracts() external /* onlyAdmin */;
506 
507 	function setNewContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;
508 
509 	function getPreviousContractRegistry() external view returns (address);
510 
511 }
512 
513 // File: @openzeppelin/contracts/GSN/Context.sol
514 
515 
516 pragma solidity ^0.6.0;
517 
518 /*
519  * @dev Provides information about the current execution context, including the
520  * sender of the transaction and its data. While these are generally available
521  * via msg.sender and msg.data, they should not be accessed in such a direct
522  * manner, since when dealing with GSN meta-transactions the account sending and
523  * paying for execution may not be the actual sender (as far as an application
524  * is concerned).
525  *
526  * This contract is only required for intermediate, library-like contracts.
527  */
528 abstract contract Context {
529     function _msgSender() internal view virtual returns (address payable) {
530         return msg.sender;
531     }
532 
533     function _msgData() internal view virtual returns (bytes memory) {
534         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
535         return msg.data;
536     }
537 }
538 
539 // File: contracts/WithClaimableRegistryManagement.sol
540 
541 
542 pragma solidity 0.6.12;
543 
544 
545 /**
546  * @title Claimable
547  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
548  * This allows the new owner to accept the transfer.
549  */
550 contract WithClaimableRegistryManagement is Context {
551     address private _registryAdmin;
552     address private _pendingRegistryAdmin;
553 
554     event RegistryManagementTransferred(address indexed previousRegistryAdmin, address indexed newRegistryAdmin);
555 
556     /**
557      * @dev Initializes the contract setting the deployer as the initial registryRegistryAdmin.
558      */
559     constructor () internal {
560         address msgSender = _msgSender();
561         _registryAdmin = msgSender;
562         emit RegistryManagementTransferred(address(0), msgSender);
563     }
564 
565     /**
566      * @dev Returns the address of the current registryAdmin.
567      */
568     function registryAdmin() public view returns (address) {
569         return _registryAdmin;
570     }
571 
572     /**
573      * @dev Throws if called by any account other than the registryAdmin.
574      */
575     modifier onlyRegistryAdmin() {
576         require(isRegistryAdmin(), "WithClaimableRegistryManagement: caller is not the registryAdmin");
577         _;
578     }
579 
580     /**
581      * @dev Returns true if the caller is the current registryAdmin.
582      */
583     function isRegistryAdmin() public view returns (bool) {
584         return _msgSender() == _registryAdmin;
585     }
586 
587     /**
588      * @dev Leaves the contract without registryAdmin. It will not be possible to call
589      * `onlyManager` functions anymore. Can only be called by the current registryAdmin.
590      *
591      * NOTE: Renouncing registryManagement will leave the contract without an registryAdmin,
592      * thereby removing any functionality that is only available to the registryAdmin.
593      */
594     function renounceRegistryManagement() public onlyRegistryAdmin {
595         emit RegistryManagementTransferred(_registryAdmin, address(0));
596         _registryAdmin = address(0);
597     }
598 
599     /**
600      * @dev Transfers registryManagement of the contract to a new account (`newManager`).
601      */
602     function _transferRegistryManagement(address newRegistryAdmin) internal {
603         require(newRegistryAdmin != address(0), "RegistryAdmin: new registryAdmin is the zero address");
604         emit RegistryManagementTransferred(_registryAdmin, newRegistryAdmin);
605         _registryAdmin = newRegistryAdmin;
606     }
607 
608     /**
609      * @dev Modifier throws if called by any account other than the pendingManager.
610      */
611     modifier onlyPendingRegistryAdmin() {
612         require(msg.sender == _pendingRegistryAdmin, "Caller is not the pending registryAdmin");
613         _;
614     }
615     /**
616      * @dev Allows the current registryAdmin to set the pendingManager address.
617      * @param newRegistryAdmin The address to transfer registryManagement to.
618      */
619     function transferRegistryManagement(address newRegistryAdmin) public onlyRegistryAdmin {
620         _pendingRegistryAdmin = newRegistryAdmin;
621     }
622 
623     /**
624      * @dev Allows the _pendingRegistryAdmin address to finalize the transfer.
625      */
626     function claimRegistryManagement() external onlyPendingRegistryAdmin {
627         _transferRegistryManagement(_pendingRegistryAdmin);
628         _pendingRegistryAdmin = address(0);
629     }
630 
631     /**
632      * @dev Returns the current pendingRegistryAdmin
633     */
634     function pendingRegistryAdmin() public view returns (address) {
635        return _pendingRegistryAdmin;  
636     }
637 }
638 
639 // File: contracts/Initializable.sol
640 
641 
642 pragma solidity 0.6.12;
643 
644 contract Initializable {
645 
646     address private _initializationAdmin;
647 
648     event InitializationComplete();
649 
650     constructor() public{
651         _initializationAdmin = msg.sender;
652     }
653 
654     modifier onlyInitializationAdmin() {
655         require(msg.sender == initializationAdmin(), "sender is not the initialization admin");
656 
657         _;
658     }
659 
660     /*
661     * External functions
662     */
663 
664     function initializationAdmin() public view returns (address) {
665         return _initializationAdmin;
666     }
667 
668     function initializationComplete() external onlyInitializationAdmin {
669         _initializationAdmin = address(0);
670         emit InitializationComplete();
671     }
672 
673     function isInitializationComplete() public view returns (bool) {
674         return _initializationAdmin == address(0);
675     }
676 
677 }
678 
679 // File: contracts/ContractRegistryAccessor.sol
680 
681 
682 pragma solidity 0.6.12;
683 
684 
685 
686 
687 contract ContractRegistryAccessor is WithClaimableRegistryManagement, Initializable {
688 
689     IContractRegistry private contractRegistry;
690 
691     constructor(IContractRegistry _contractRegistry, address _registryAdmin) public {
692         require(address(_contractRegistry) != address(0), "_contractRegistry cannot be 0");
693         setContractRegistry(_contractRegistry);
694         _transferRegistryManagement(_registryAdmin);
695     }
696 
697     modifier onlyAdmin {
698         require(isAdmin(), "sender is not an admin (registryManger or initializationAdmin)");
699 
700         _;
701     }
702 
703     function isManager(string memory role) internal view returns (bool) {
704         IContractRegistry _contractRegistry = contractRegistry;
705         return isAdmin() || _contractRegistry != IContractRegistry(0) && contractRegistry.getManager(role) == msg.sender;
706     }
707 
708     function isAdmin() internal view returns (bool) {
709         return msg.sender == registryAdmin() || msg.sender == initializationAdmin() || msg.sender == address(contractRegistry);
710     }
711 
712     function getProtocolContract() internal view returns (address) {
713         return contractRegistry.getContract("protocol");
714     }
715 
716     function getStakingRewardsContract() internal view returns (address) {
717         return contractRegistry.getContract("stakingRewards");
718     }
719 
720     function getFeesAndBootstrapRewardsContract() internal view returns (address) {
721         return contractRegistry.getContract("feesAndBootstrapRewards");
722     }
723 
724     function getCommitteeContract() internal view returns (address) {
725         return contractRegistry.getContract("committee");
726     }
727 
728     function getElectionsContract() internal view returns (address) {
729         return contractRegistry.getContract("elections");
730     }
731 
732     function getDelegationsContract() internal view returns (address) {
733         return contractRegistry.getContract("delegations");
734     }
735 
736     function getGuardiansRegistrationContract() internal view returns (address) {
737         return contractRegistry.getContract("guardiansRegistration");
738     }
739 
740     function getCertificationContract() internal view returns (address) {
741         return contractRegistry.getContract("certification");
742     }
743 
744     function getStakingContract() internal view returns (address) {
745         return contractRegistry.getContract("staking");
746     }
747 
748     function getSubscriptionsContract() internal view returns (address) {
749         return contractRegistry.getContract("subscriptions");
750     }
751 
752     function getStakingRewardsWallet() internal view returns (address) {
753         return contractRegistry.getContract("stakingRewardsWallet");
754     }
755 
756     function getBootstrapRewardsWallet() internal view returns (address) {
757         return contractRegistry.getContract("bootstrapRewardsWallet");
758     }
759 
760     function getGeneralFeesWallet() internal view returns (address) {
761         return contractRegistry.getContract("generalFeesWallet");
762     }
763 
764     function getCertifiedFeesWallet() internal view returns (address) {
765         return contractRegistry.getContract("certifiedFeesWallet");
766     }
767 
768     function getStakingContractHandler() internal view returns (address) {
769         return contractRegistry.getContract("stakingContractHandler");
770     }
771 
772     /*
773     * Governance functions
774     */
775 
776     event ContractRegistryAddressUpdated(address addr);
777 
778     function setContractRegistry(IContractRegistry newContractRegistry) public onlyAdmin {
779         require(newContractRegistry.getPreviousContractRegistry() == address(contractRegistry), "new contract registry must provide the previous contract registry");
780         contractRegistry = newContractRegistry;
781         emit ContractRegistryAddressUpdated(address(newContractRegistry));
782     }
783 
784     function getContractRegistry() public view returns (IContractRegistry) {
785         return contractRegistry;
786     }
787 
788 }
789 
790 // File: contracts/spec_interfaces/ILockable.sol
791 
792 
793 pragma solidity 0.6.12;
794 
795 interface ILockable {
796 
797     event Locked();
798     event Unlocked();
799 
800     function lock() external /* onlyLockOwner */;
801     function unlock() external /* onlyLockOwner */;
802     function isLocked() view external returns (bool);
803 
804 }
805 
806 // File: contracts/Lockable.sol
807 
808 
809 pragma solidity 0.6.12;
810 
811 
812 
813 contract Lockable is ILockable, ContractRegistryAccessor {
814 
815     bool public locked;
816 
817     constructor(IContractRegistry _contractRegistry, address _registryAdmin) ContractRegistryAccessor(_contractRegistry, _registryAdmin) public {}
818 
819     modifier onlyLockOwner() {
820         require(msg.sender == registryAdmin() || msg.sender == address(getContractRegistry()), "caller is not a lock owner");
821 
822         _;
823     }
824 
825     function lock() external override onlyLockOwner {
826         locked = true;
827         emit Locked();
828     }
829 
830     function unlock() external override onlyLockOwner {
831         locked = false;
832         emit Unlocked();
833     }
834 
835     function isLocked() external override view returns (bool) {
836         return locked;
837     }
838 
839     modifier onlyWhenActive() {
840         require(!locked, "contract is locked for this operation");
841 
842         _;
843     }
844 }
845 
846 // File: contracts/ManagedContract.sol
847 
848 
849 pragma solidity 0.6.12;
850 
851 
852 contract ManagedContract is Lockable {
853 
854     constructor(IContractRegistry _contractRegistry, address _registryAdmin) Lockable(_contractRegistry, _registryAdmin) public {}
855 
856     modifier onlyMigrationManager {
857         require(isManager("migrationManager"), "sender is not the migration manager");
858 
859         _;
860     }
861 
862     modifier onlyFunctionalManager {
863         require(isManager("functionalManager"), "sender is not the functional manager");
864 
865         _;
866     }
867 
868     function refreshContracts() virtual external {}
869 
870 }
871 
872 // File: contracts/Elections.sol
873 
874 
875 pragma solidity 0.6.12;
876 
877 
878 
879 
880 
881 
882 
883 
884 contract Elections is IElections, ManagedContract {
885 	using SafeMath for uint256;
886 
887 	uint32 constant PERCENT_MILLIE_BASE = 100000;
888 
889 	mapping(address => mapping(address => uint256)) voteUnreadyVotes; // by => to => expiration
890 	mapping(address => uint256) public votersStake;
891 	mapping(address => address) voteOutVotes; // by => to
892 	mapping(address => uint256) accumulatedStakesForVoteOut; // addr => total stake
893 	mapping(address => bool) votedOutGuardians;
894 
895 	struct Settings {
896 		uint32 minSelfStakePercentMille;
897 		uint32 voteUnreadyPercentMilleThreshold;
898 		uint32 voteOutPercentMilleThreshold;
899 	}
900 	Settings settings;
901 
902 	constructor(IContractRegistry _contractRegistry, address _registryAdmin, uint32 minSelfStakePercentMille, uint32 voteUnreadyPercentMilleThreshold, uint32 voteOutPercentMilleThreshold) ManagedContract(_contractRegistry, _registryAdmin) public {
903 		setMinSelfStakePercentMille(minSelfStakePercentMille);
904 		setVoteOutPercentMilleThreshold(voteOutPercentMilleThreshold);
905 		setVoteUnreadyPercentMilleThreshold(voteUnreadyPercentMilleThreshold);
906 	}
907 
908 	modifier onlyDelegationsContract() {
909 		require(msg.sender == address(delegationsContract), "caller is not the delegations contract");
910 
911 		_;
912 	}
913 
914 	modifier onlyGuardiansRegistrationContract() {
915 		require(msg.sender == address(guardianRegistrationContract), "caller is not the guardian registrations contract");
916 
917 		_;
918 	}
919 
920 	modifier onlyCertificationContract() {
921 		require(msg.sender == address(certificationContract), "caller is not the certification contract");
922 
923 		_;
924 	}
925 
926 	/*
927 	 * External functions
928 	 */
929 
930 	function readyToSync() external override onlyWhenActive {
931 		address guardian = guardianRegistrationContract.resolveGuardianAddress(msg.sender); // this validates registration
932 		require(!isVotedOut(guardian), "caller is voted-out");
933 
934 		emit GuardianStatusUpdated(guardian, true, false);
935 
936 		committeeContract.removeMember(guardian);
937 	}
938 
939 	function readyForCommittee() external override onlyWhenActive {
940 		_readyForCommittee(msg.sender);
941 	}
942 
943 	function canJoinCommittee(address guardian) external view override returns (bool) {
944 		guardian = guardianRegistrationContract.resolveGuardianAddress(guardian); // this validates registration
945 
946 		if (isVotedOut(guardian)) {
947 			return false;
948 		}
949 
950 		(, uint256 effectiveStake, ) = getGuardianStakeInfo(guardian, settings);
951 		return committeeContract.checkAddMember(guardian, effectiveStake);
952 	}
953 
954 	function getEffectiveStake(address guardian) external override view returns (uint effectiveStake) {
955 		(, effectiveStake, ) = getGuardianStakeInfo(guardian, settings);
956 	}
957 
958 	/// @dev returns the current committee
959 	function getCommittee() external override view returns (address[] memory committee, uint256[] memory weights, address[] memory orbsAddrs, bool[] memory certification, bytes4[] memory ips) {
960 		IGuardiansRegistration _guardianRegistrationContract = guardianRegistrationContract;
961 		(committee, weights, certification) = committeeContract.getCommittee();
962 		orbsAddrs = _guardianRegistrationContract.getGuardiansOrbsAddress(committee);
963 		ips = _guardianRegistrationContract.getGuardianIps(committee);
964 	}
965 
966 	// Vote-unready
967 
968 	function voteUnready(address subject, uint voteExpiration) external override onlyWhenActive {
969 		require(voteExpiration >= block.timestamp, "vote expiration time must not be in the past");
970 
971 		address voter = guardianRegistrationContract.resolveGuardianAddress(msg.sender);
972 		voteUnreadyVotes[voter][subject] = voteExpiration;
973 		emit VoteUnreadyCasted(voter, subject, voteExpiration);
974 
975 		(address[] memory generalCommittee, uint256[] memory generalWeights, bool[] memory certification) = committeeContract.getCommittee();
976 
977 		bool votedUnready = isCommitteeVoteUnreadyThresholdReached(generalCommittee, generalWeights, certification, subject);
978 		if (votedUnready) {
979 			clearCommitteeUnreadyVotes(generalCommittee, subject);
980 			emit GuardianVotedUnready(subject);
981 
982 			emit GuardianStatusUpdated(subject, false, false);
983 			committeeContract.removeMember(subject);
984 		}
985 	}
986 
987 	function getVoteUnreadyVote(address voter, address subject) public override view returns (bool valid, uint256 expiration) {
988 		expiration = voteUnreadyVotes[voter][subject];
989 		valid = expiration != 0 && block.timestamp < expiration;
990 	}
991 
992 	function getVoteUnreadyStatus(address subject) external override view returns (address[] memory committee, uint256[] memory weights, bool[] memory certification, bool[] memory votes, bool subjectInCommittee, bool subjectInCertifiedCommittee) {
993 		(committee, weights, certification) = committeeContract.getCommittee();
994 
995 		votes = new bool[](committee.length);
996 		for (uint i = 0; i < committee.length; i++) {
997 			address memberAddr = committee[i];
998 			if (block.timestamp < voteUnreadyVotes[memberAddr][subject]) {
999 				votes[i] = true;
1000 			}
1001 
1002 			if (memberAddr == subject) {
1003 				subjectInCommittee = true;
1004 				subjectInCertifiedCommittee = certification[i];
1005 			}
1006 		}
1007 	}
1008 
1009 	// Vote-out
1010 
1011 	function voteOut(address subject) external override onlyWhenActive {
1012 		Settings memory _settings = settings;
1013 
1014 		address voter = msg.sender;
1015 		address prevSubject = voteOutVotes[voter];
1016 
1017 		voteOutVotes[voter] = subject;
1018 		emit VoteOutCasted(voter, subject);
1019 
1020 		uint256 voterStake = delegationsContract.getDelegatedStake(voter);
1021 
1022 		if (prevSubject == address(0)) {
1023 			votersStake[voter] = voterStake;
1024 		}
1025 
1026 		if (subject == address(0)) {
1027 			delete votersStake[voter];
1028 		}
1029 
1030 		uint totalStake = delegationsContract.getTotalDelegatedStake();
1031 
1032 		if (prevSubject != address(0) && prevSubject != subject) {
1033 			applyVoteOutVotesFor(prevSubject, 0, voterStake, totalStake, _settings);
1034 		}
1035 
1036 		if (subject != address(0)) {
1037 			uint voteStakeAdded = prevSubject != subject ? voterStake : 0;
1038 			applyVoteOutVotesFor(subject, voteStakeAdded, 0, totalStake, _settings); // recheck also if not new
1039 		}
1040 	}
1041 
1042 	function getVoteOutVote(address voter) external override view returns (address) {
1043 		return voteOutVotes[voter];
1044 	}
1045 
1046 	function getVoteOutStatus(address subject) external override view returns (bool votedOut, uint votedStake, uint totalDelegatedStake) {
1047 		votedOut = isVotedOut(subject);
1048 		votedStake = accumulatedStakesForVoteOut[subject];
1049 		totalDelegatedStake = delegationsContract.getTotalDelegatedStake();
1050 	}
1051 
1052 	/*
1053 	 * Notification functions from other PoS contracts
1054 	 */
1055 
1056 	function delegatedStakeChange(address delegate, uint256 selfStake, uint256 delegatedStake, uint256 totalDelegatedStake) external override onlyDelegationsContract onlyWhenActive {
1057 		Settings memory _settings = settings;
1058 
1059 		uint effectiveStake = calcEffectiveStake(selfStake, delegatedStake, _settings);
1060 		emit StakeChanged(delegate, selfStake, delegatedStake, effectiveStake);
1061 
1062 		committeeContract.memberWeightChange(delegate, effectiveStake);
1063 
1064 		applyStakesToVoteOutBy(delegate, delegatedStake, totalDelegatedStake, _settings);
1065 	}
1066 
1067 	/// @dev Called by: guardian registration contract
1068 	/// Notifies a new guardian was unregistered
1069 	function guardianUnregistered(address guardian) external override onlyGuardiansRegistrationContract onlyWhenActive {
1070 		emit GuardianStatusUpdated(guardian, false, false);
1071 		committeeContract.removeMember(guardian);
1072 	}
1073 
1074 	/// @dev Called by: guardian registration contract§
1075 	/// Notifies on a guardian certification change
1076 	function guardianCertificationChanged(address guardian, bool isCertified) external override onlyCertificationContract onlyWhenActive {
1077 		committeeContract.memberCertificationChange(guardian, isCertified);
1078 	}
1079 
1080 	/*
1081      * Governance functions
1082 	 */
1083 
1084 	function setMinSelfStakePercentMille(uint32 minSelfStakePercentMille) public override onlyFunctionalManager {
1085 		require(minSelfStakePercentMille <= PERCENT_MILLIE_BASE, "minSelfStakePercentMille must be 100000 at most");
1086 		emit MinSelfStakePercentMilleChanged(minSelfStakePercentMille, settings.minSelfStakePercentMille);
1087 		settings.minSelfStakePercentMille = minSelfStakePercentMille;
1088 	}
1089 
1090 	function getMinSelfStakePercentMille() external override view returns (uint32) {
1091 		return settings.minSelfStakePercentMille;
1092 	}
1093 
1094 	function setVoteOutPercentMilleThreshold(uint32 voteOutPercentMilleThreshold) public override onlyFunctionalManager {
1095 		require(voteOutPercentMilleThreshold <= PERCENT_MILLIE_BASE, "voteOutPercentMilleThreshold must not be larger than 100000");
1096 		emit VoteOutPercentMilleThresholdChanged(voteOutPercentMilleThreshold, settings.voteOutPercentMilleThreshold);
1097 		settings.voteOutPercentMilleThreshold = voteOutPercentMilleThreshold;
1098 	}
1099 
1100 	function getVoteOutPercentMilleThreshold() external override view returns (uint32) {
1101 		return settings.voteOutPercentMilleThreshold;
1102 	}
1103 
1104 	function setVoteUnreadyPercentMilleThreshold(uint32 voteUnreadyPercentMilleThreshold) public override onlyFunctionalManager {
1105 		require(voteUnreadyPercentMilleThreshold <= PERCENT_MILLIE_BASE, "voteUnreadyPercentMilleThreshold must not be larger than 100000");
1106 		emit VoteUnreadyPercentMilleThresholdChanged(voteUnreadyPercentMilleThreshold, settings.voteUnreadyPercentMilleThreshold);
1107 		settings.voteUnreadyPercentMilleThreshold = voteUnreadyPercentMilleThreshold;
1108 	}
1109 
1110 	function getVoteUnreadyPercentMilleThreshold() external override view returns (uint32) {
1111 		return settings.voteUnreadyPercentMilleThreshold;
1112 	}
1113 
1114 	function getSettings() external override view returns (
1115 		uint32 minSelfStakePercentMille,
1116 		uint32 voteUnreadyPercentMilleThreshold,
1117 		uint32 voteOutPercentMilleThreshold
1118 	) {
1119 		Settings memory _settings = settings;
1120 		minSelfStakePercentMille = _settings.minSelfStakePercentMille;
1121 		voteUnreadyPercentMilleThreshold = _settings.voteUnreadyPercentMilleThreshold;
1122 		voteOutPercentMilleThreshold = _settings.voteOutPercentMilleThreshold;
1123 	}
1124 
1125 	function initReadyForCommittee(address[] calldata guardians) external override onlyInitializationAdmin {
1126 		for (uint i = 0; i < guardians.length; i++) {
1127 			_readyForCommittee(guardians[i]);
1128 		}
1129 	}
1130 
1131 	/*
1132      * Private functions
1133 	 */
1134 
1135 	function _readyForCommittee(address guardian) private {
1136 		guardian = guardianRegistrationContract.resolveGuardianAddress(guardian); // this validates registration
1137 		require(!isVotedOut(guardian), "caller is voted-out");
1138 
1139 		emit GuardianStatusUpdated(guardian, true, true);
1140 
1141 		(, uint256 effectiveStake, ) = getGuardianStakeInfo(guardian, settings);
1142 		committeeContract.addMember(guardian, effectiveStake, certificationContract.isGuardianCertified(guardian));
1143 	}
1144 
1145 	function calcEffectiveStake(uint256 selfStake, uint256 delegatedStake, Settings memory _settings) private pure returns (uint256) {
1146 		if (selfStake.mul(PERCENT_MILLIE_BASE) >= delegatedStake.mul(_settings.minSelfStakePercentMille)) {
1147 			return delegatedStake;
1148 		}
1149 		return selfStake.mul(PERCENT_MILLIE_BASE).div(_settings.minSelfStakePercentMille); // never overflows or divides by zero
1150 	}
1151 
1152 	function getGuardianStakeInfo(address guardian, Settings memory _settings) private view returns (uint256 selfStake, uint256 effectiveStake, uint256 delegatedStake) {
1153 		IDelegations _delegationsContract = delegationsContract;
1154 		(,selfStake) = _delegationsContract.getDelegationInfo(guardian);
1155 		delegatedStake = _delegationsContract.getDelegatedStake(guardian);
1156 		effectiveStake = calcEffectiveStake(selfStake, delegatedStake, _settings);
1157 	}
1158 
1159 	// Vote-unready
1160 
1161 	function isCommitteeVoteUnreadyThresholdReached(address[] memory committee, uint256[] memory weights, bool[] memory certification, address subject) private returns (bool) {
1162 		Settings memory _settings = settings;
1163 
1164 		uint256 totalCommitteeStake = 0;
1165 		uint256 totalVoteUnreadyStake = 0;
1166 		uint256 totalCertifiedStake = 0;
1167 		uint256 totalCertifiedVoteUnreadyStake = 0;
1168 
1169 		address member;
1170 		uint256 memberStake;
1171 		bool isSubjectCertified;
1172 		for (uint i = 0; i < committee.length; i++) {
1173 			member = committee[i];
1174 			memberStake = weights[i];
1175 
1176 			if (member == subject && certification[i]) {
1177 				isSubjectCertified = true;
1178 			}
1179 
1180 			totalCommitteeStake = totalCommitteeStake.add(memberStake);
1181 			if (certification[i]) {
1182 				totalCertifiedStake = totalCertifiedStake.add(memberStake);
1183 			}
1184 
1185 			(bool valid, uint256 expiration) = getVoteUnreadyVote(member, subject);
1186 			if (valid) {
1187 				totalVoteUnreadyStake = totalVoteUnreadyStake.add(memberStake);
1188 				if (certification[i]) {
1189 					totalCertifiedVoteUnreadyStake = totalCertifiedVoteUnreadyStake.add(memberStake);
1190 				}
1191 			} else if (expiration != 0) {
1192 				// Vote is stale, delete from state
1193 				delete voteUnreadyVotes[member][subject];
1194 			}
1195 		}
1196 
1197 		return (
1198 			totalCommitteeStake > 0 &&
1199 			totalVoteUnreadyStake.mul(PERCENT_MILLIE_BASE) >= uint256(_settings.voteUnreadyPercentMilleThreshold).mul(totalCommitteeStake)
1200 		) || (
1201 			isSubjectCertified &&
1202 			totalCertifiedStake > 0 &&
1203 			totalCertifiedVoteUnreadyStake.mul(PERCENT_MILLIE_BASE) >= uint256(_settings.voteUnreadyPercentMilleThreshold).mul(totalCertifiedStake)
1204 		);
1205 	}
1206 
1207 	function clearCommitteeUnreadyVotes(address[] memory committee, address subject) private {
1208 		for (uint i = 0; i < committee.length; i++) {
1209 			voteUnreadyVotes[committee[i]][subject] = 0; // clear vote-outs
1210 		}
1211 	}
1212 
1213 	// Vote-out
1214 
1215 	function applyStakesToVoteOutBy(address voter, uint256 currentVoterStake, uint256 totalGovernanceStake, Settings memory _settings) private {
1216 		address subject = voteOutVotes[voter];
1217 		if (subject == address(0)) return;
1218 
1219 		uint256 prevVoterStake = votersStake[voter];
1220 		votersStake[voter] = currentVoterStake;
1221 
1222 		applyVoteOutVotesFor(subject, currentVoterStake, prevVoterStake, totalGovernanceStake, _settings);
1223 	}
1224 
1225     function applyVoteOutVotesFor(address subject, uint256 voteOutStakeAdded, uint256 voteOutStakeRemoved, uint256 totalGovernanceStake, Settings memory _settings) private {
1226 		if (isVotedOut(subject)) {
1227 			return;
1228 		}
1229 
1230 		uint256 accumulated = accumulatedStakesForVoteOut[subject].
1231 			sub(voteOutStakeRemoved).
1232 			add(voteOutStakeAdded);
1233 
1234 		bool shouldBeVotedOut = totalGovernanceStake > 0 && accumulated.mul(PERCENT_MILLIE_BASE) >= uint256(_settings.voteOutPercentMilleThreshold).mul(totalGovernanceStake);
1235 		if (shouldBeVotedOut) {
1236 			votedOutGuardians[subject] = true;
1237 			emit GuardianVotedOut(subject);
1238 
1239 			emit GuardianStatusUpdated(subject, false, false);
1240 			committeeContract.removeMember(subject);
1241 		}
1242 
1243 		accumulatedStakesForVoteOut[subject] = accumulated;
1244 	}
1245 
1246 	function isVotedOut(address guardian) private view returns (bool) {
1247 		return votedOutGuardians[guardian];
1248 	}
1249 
1250 	/*
1251      * Contracts topology / registry interface
1252      */
1253 
1254 	ICommittee committeeContract;
1255 	IDelegations delegationsContract;
1256 	IGuardiansRegistration guardianRegistrationContract;
1257 	ICertification certificationContract;
1258 	function refreshContracts() external override {
1259 		committeeContract = ICommittee(getCommitteeContract());
1260 		delegationsContract = IDelegations(getDelegationsContract());
1261 		guardianRegistrationContract = IGuardiansRegistration(getGuardiansRegistrationContract());
1262 		certificationContract = ICertification(getCertificationContract());
1263 	}
1264 
1265 }