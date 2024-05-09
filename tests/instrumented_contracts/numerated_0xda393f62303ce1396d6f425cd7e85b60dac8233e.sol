1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/math/Math.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /**
165  * @dev Standard math utilities missing in the Solidity language.
166  */
167 library Math {
168     /**
169      * @dev Returns the largest of two numbers.
170      */
171     function max(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a >= b ? a : b;
173     }
174 
175     /**
176      * @dev Returns the smallest of two numbers.
177      */
178     function min(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a < b ? a : b;
180     }
181 
182     /**
183      * @dev Returns the average of two numbers. The result is rounded towards
184      * zero.
185      */
186     function average(uint256 a, uint256 b) internal pure returns (uint256) {
187         // (a + b) / 2 can overflow, so we distribute
188         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
189     }
190 }
191 
192 // File: contracts/spec_interfaces/ICommitteeListener.sol
193 
194 pragma solidity 0.5.16;
195 
196 interface ICommitteeListener {
197     function committeeChanged(address[] calldata addrs, uint256[] calldata stakes) external;
198 }
199 
200 // File: contracts/spec_interfaces/IContractRegistry.sol
201 
202 pragma solidity 0.5.16;
203 
204 interface IContractRegistry {
205 
206 	event ContractAddressUpdated(string contractName, address addr);
207 
208 	/// @dev updates the contracts address and emits a corresponding event
209 	function set(string calldata contractName, address addr) external /* onlyGovernor */;
210 
211 	/// @dev returns the current address of the
212 	function get(string calldata contractName) external view returns (address);
213 }
214 
215 // File: contracts/spec_interfaces/IDelegation.sol
216 
217 pragma solidity 0.5.16;
218 
219 
220 /// @title Elections contract interface
221 interface IDelegations /* is IStakeChangeNotifier */ {
222     // Delegation state change events
223 	event DelegatedStakeChanged(address indexed addr, uint256 selfDelegatedStake, uint256 delegatedStake, address[] delegators, uint256[] delegatorTotalStakes);
224 
225     // Function calls
226 	event Delegated(address indexed from, address indexed to);
227 
228 	/*
229      * External methods
230      */
231 
232 	/// @dev Stake delegation
233 	function delegate(address to) external /* onlyWhenActive */;
234 
235 	function refreshStakeNotification(address addr) external /* onlyWhenActive */;
236 
237 	/*
238 	 * Governance
239 	 */
240 
241     /// @dev Updates the address calldata of the contract registry
242 	function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;
243 
244 	function importDelegations(address[] calldata from, address[] calldata to, bool notifyElections) external /* onlyMigrationOwner onlyDuringDelegationImport */;
245 	function finalizeDelegationImport() external /* onlyMigrationOwner onlyDuringDelegationImport */;
246 
247 	event DelegationsImported(address[] from, address[] to, bool notifiedElections);
248 	event DelegationImportFinalized();
249 
250 	/*
251 	 * Getters
252 	 */
253 
254 	function getDelegatedStakes(address addr) external view returns (uint256);
255 	function getSelfDelegatedStake(address addr) external view returns (uint256);
256 	function getDelegation(address addr) external view returns (address);
257 	function getTotalDelegatedStake() external view returns (uint256) ;
258 
259 
260 }
261 
262 // File: contracts/IStakeChangeNotifier.sol
263 
264 pragma solidity 0.5.16;
265 
266 /// @title An interface for notifying of stake change events (e.g., stake, unstake, partial unstake, restate, etc.).
267 interface IStakeChangeNotifier {
268     /// @dev Notifies of stake change event.
269     /// @param _stakeOwner address The address of the subject stake owner.
270     /// @param _amount uint256 The difference in the total staked amount.
271     /// @param _sign bool The sign of the added (true) or subtracted (false) amount.
272     /// @param _updatedStake uint256 The updated total staked amount.
273     function stakeChange(address _stakeOwner, uint256 _amount, bool _sign, uint256 _updatedStake) external;
274 
275     /// @dev Notifies of multiple stake change events.
276     /// @param _stakeOwners address[] The addresses of subject stake owners.
277     /// @param _amounts uint256[] The differences in total staked amounts.
278     /// @param _signs bool[] The signs of the added (true) or subtracted (false) amounts.
279     /// @param _updatedStakes uint256[] The updated total staked amounts.
280     function stakeChangeBatch(address[] calldata _stakeOwners, uint256[] calldata _amounts, bool[] calldata _signs,
281         uint256[] calldata _updatedStakes) external;
282 
283     /// @dev Notifies of stake migration event.
284     /// @param _stakeOwner address The address of the subject stake owner.
285     /// @param _amount uint256 The migrated amount.
286     function stakeMigration(address _stakeOwner, uint256 _amount) external;
287 }
288 
289 // File: contracts/interfaces/IElections.sol
290 
291 pragma solidity 0.5.16;
292 
293 
294 
295 /// @title Elections contract interface
296 interface IElections /* is IStakeChangeNotifier */ {
297 	// Election state change events
298 	event GuardianVotedUnready(address guardian);
299 	event GuardianVotedOut(address guardian);
300 
301 	// Function calls
302 	event VoteUnreadyCasted(address voter, address subject);
303 	event VoteOutCasted(address voter, address subject);
304 	event StakeChanged(address addr, uint256 selfStake, uint256 delegated_stake, uint256 effective_stake);
305 
306 	event GuardianStatusUpdated(address addr, bool readyToSync, bool readyForCommittee);
307 
308 	// Governance
309 	event VoteUnreadyTimeoutSecondsChanged(uint32 newValue, uint32 oldValue);
310 	event MinSelfStakePercentMilleChanged(uint32 newValue, uint32 oldValue);
311 	event VoteOutPercentageThresholdChanged(uint8 newValue, uint8 oldValue);
312 	event VoteUnreadyPercentageThresholdChanged(uint8 newValue, uint8 oldValue);
313 
314 	/*
315 	 * External methods
316 	 */
317 
318 	/// @dev Called by a guardian as part of the automatic vote-out flow
319 	function voteUnready(address subject_addr) external;
320 
321 	/// @dev casts a voteOut vote by the sender to the given address
322 	function voteOut(address subjectAddr) external;
323 
324 	/// @dev Called by a guardian when ready to start syncing with other nodes
325 	function readyToSync() external;
326 
327 	/// @dev Called by a guardian when ready to join the committee, typically after syncing is complete or after being voted out
328 	function readyForCommittee() external;
329 
330 	/*
331 	 * Methods restricted to other Orbs contracts
332 	 */
333 
334 	/// @dev Called by: delegation contract
335 	/// Notifies a delegated stake change event
336 	/// total_delegated_stake = 0 if addr delegates to another guardian
337 	function delegatedStakeChange(address addr, uint256 selfStake, uint256 delegatedStake, uint256 totalDelegatedStake) external /* onlyDelegationContract */;
338 
339 	/// @dev Called by: guardian registration contract
340 	/// Notifies a new guardian was registered
341 	function guardianRegistered(address addr) external /* onlyGuardiansRegistrationContract */;
342 
343 	/// @dev Called by: guardian registration contract
344 	/// Notifies a new guardian was unregistered
345 	function guardianUnregistered(address addr) external /* onlyGuardiansRegistrationContract */;
346 
347 	/// @dev Called by: guardian registration contract
348 	/// Notifies on a guardian certification change
349 	function guardianCertificationChanged(address addr, bool isCertified) external /* onlyCertificationContract */;
350 
351 	/*
352      * Governance
353 	 */
354 
355 	/// @dev Updates the address of the contract registry
356 	function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;
357 
358 	function setVoteUnreadyTimeoutSeconds(uint32 voteUnreadyTimeoutSeconds) external /* onlyFunctionalOwner onlyWhenActive */;
359 	function setMinSelfStakePercentMille(uint32 minSelfStakePercentMille) external /* onlyFunctionalOwner onlyWhenActive */;
360 	function setVoteOutPercentageThreshold(uint8 voteUnreadyPercentageThreshold) external /* onlyFunctionalOwner onlyWhenActive */;
361 	function setVoteUnreadyPercentageThreshold(uint8 voteUnreadyPercentageThreshold) external /* onlyFunctionalOwner onlyWhenActive */;
362 	function getSettings() external view returns (
363 		uint32 voteUnreadyTimeoutSeconds,
364 		uint32 minSelfStakePercentMille,
365 		uint8 voteUnreadyPercentageThreshold,
366 		uint8 voteOutPercentageThreshold
367 	);
368 }
369 
370 // File: contracts/spec_interfaces/IGuardiansRegistration.sol
371 
372 pragma solidity 0.5.16;
373 
374 
375 /// @title Elections contract interface
376 interface IGuardiansRegistration {
377 	event GuardianRegistered(address addr);
378 	event GuardianDataUpdated(address addr, bytes4 ip, address orbsAddr, string name, string website, string contact);
379 	event GuardianUnregistered(address addr);
380 	event GuardianMetadataChanged(address addr, string key, string newValue, string oldValue);
381 
382 	/*
383      * External methods
384      */
385 
386     /// @dev Called by a participant who wishes to register as a guardian
387 	function registerGuardian(bytes4 ip, address orbsAddr, string calldata name, string calldata website, string calldata contact) external;
388 
389     /// @dev Called by a participant who wishes to update its propertires
390 	function updateGuardian(bytes4 ip, address orbsAddr, string calldata name, string calldata website, string calldata contact) external;
391 
392 	/// @dev Called by a participant who wishes to update its IP address (can be call by both main and Orbs addresses)
393 	function updateGuardianIp(bytes4 ip) external /* onlyWhenActive */;
394 
395     /// @dev Called by a participant to update additional guardian metadata properties.
396     function setMetadata(string calldata key, string calldata value) external;
397 
398     /// @dev Called by a participant to get additional guardian metadata properties.
399     function getMetadata(address addr, string calldata key) external view returns (string memory);
400 
401     /// @dev Called by a participant who wishes to unregister
402 	function unregisterGuardian() external;
403 
404     /// @dev Returns a guardian's data
405     /// Used also by the Election contract
406 	function getGuardianData(address addr) external view returns (bytes4 ip, address orbsAddr, string memory name, string memory website, string memory contact, uint registration_time, uint last_update_time);
407 
408 	/// @dev Returns the Orbs addresses of a list of guardians
409 	/// Used also by the committee contract
410 	function getGuardiansOrbsAddress(address[] calldata addrs) external view returns (address[] memory orbsAddrs);
411 
412 	/// @dev Returns a guardian's ip
413 	/// Used also by the Election contract
414 	function getGuardianIp(address addr) external view returns (bytes4 ip);
415 
416 	/// @dev Returns guardian ips
417 	function getGuardianIps(address[] calldata addr) external view returns (bytes4[] memory ips);
418 
419 
420 	/// @dev Returns true if the given address is of a registered guardian
421 	/// Used also by the Election contract
422 	function isRegistered(address addr) external view returns (bool);
423 
424 	/*
425      * Methods restricted to other Orbs contracts
426      */
427 
428     /// @dev Translates a list guardians Ethereum addresses to Orbs addresses
429     /// Used by the Election contract
430 	function getOrbsAddresses(address[] calldata ethereumAddrs) external view returns (address[] memory orbsAddr);
431 
432 	/// @dev Translates a list guardians Orbs addresses to Ethereum addresses
433 	/// Used by the Election contract
434 	function getEthereumAddresses(address[] calldata orbsAddrs) external view returns (address[] memory ethereumAddr);
435 
436 	/// @dev Resolves the ethereum address for a guardian, given an Ethereum/Orbs address
437 	function resolveGuardianAddress(address ethereumOrOrbsAddress) external view returns (address mainAddress);
438 
439 }
440 
441 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
442 
443 pragma solidity ^0.5.0;
444 
445 /**
446  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
447  * the optional functions; to access them see {ERC20Detailed}.
448  */
449 interface IERC20 {
450     /**
451      * @dev Returns the amount of tokens in existence.
452      */
453     function totalSupply() external view returns (uint256);
454 
455     /**
456      * @dev Returns the amount of tokens owned by `account`.
457      */
458     function balanceOf(address account) external view returns (uint256);
459 
460     /**
461      * @dev Moves `amount` tokens from the caller's account to `recipient`.
462      *
463      * Returns a boolean value indicating whether the operation succeeded.
464      *
465      * Emits a {Transfer} event.
466      */
467     function transfer(address recipient, uint256 amount) external returns (bool);
468 
469     /**
470      * @dev Returns the remaining number of tokens that `spender` will be
471      * allowed to spend on behalf of `owner` through {transferFrom}. This is
472      * zero by default.
473      *
474      * This value changes when {approve} or {transferFrom} are called.
475      */
476     function allowance(address owner, address spender) external view returns (uint256);
477 
478     /**
479      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
480      *
481      * Returns a boolean value indicating whether the operation succeeded.
482      *
483      * IMPORTANT: Beware that changing an allowance with this method brings the risk
484      * that someone may use both the old and the new allowance by unfortunate
485      * transaction ordering. One possible solution to mitigate this race
486      * condition is to first reduce the spender's allowance to 0 and set the
487      * desired value afterwards:
488      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
489      *
490      * Emits an {Approval} event.
491      */
492     function approve(address spender, uint256 amount) external returns (bool);
493 
494     /**
495      * @dev Moves `amount` tokens from `sender` to `recipient` using the
496      * allowance mechanism. `amount` is then deducted from the caller's
497      * allowance.
498      *
499      * Returns a boolean value indicating whether the operation succeeded.
500      *
501      * Emits a {Transfer} event.
502      */
503     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
504 
505     /**
506      * @dev Emitted when `value` tokens are moved from one account (`from`) to
507      * another (`to`).
508      *
509      * Note that `value` may be zero.
510      */
511     event Transfer(address indexed from, address indexed to, uint256 value);
512 
513     /**
514      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
515      * a call to {approve}. `value` is the new allowance.
516      */
517     event Approval(address indexed owner, address indexed spender, uint256 value);
518 }
519 
520 // File: contracts/IMigratableStakingContract.sol
521 
522 pragma solidity 0.5.16;
523 
524 
525 /// @title An interface for staking contracts which support stake migration.
526 interface IMigratableStakingContract {
527     /// @dev Returns the address of the underlying staked token.
528     /// @return IERC20 The address of the token.
529     function getToken() external view returns (IERC20);
530 
531     /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
532     /// the required amount using ERC20 approve.
533     /// @param _stakeOwner address The specified stake owner.
534     /// @param _amount uint256 The number of tokens to stake.
535     function acceptMigration(address _stakeOwner, uint256 _amount) external;
536 
537     event AcceptedMigration(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
538 }
539 
540 // File: contracts/IStakingContract.sol
541 
542 pragma solidity 0.5.16;
543 
544 
545 /// @title An interface for staking contracts.
546 interface IStakingContract {
547     /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
548     /// the required amount using ERC20 approve.
549     /// @param _amount uint256 The amount of tokens to stake.
550     function stake(uint256 _amount) external;
551 
552     /// @dev Unstakes ORBS tokens from msg.sender. If successful, this will start the cooldown period, after which
553     /// msg.sender would be able to withdraw all of his tokens.
554     /// @param _amount uint256 The amount of tokens to unstake.
555     function unstake(uint256 _amount) external;
556 
557     /// @dev Requests to withdraw all of staked ORBS tokens back to msg.sender. Stake owners can withdraw their ORBS
558     /// tokens only after previously unstaking them and after the cooldown period has passed (unless the contract was
559     /// requested to release all stakes).
560     function withdraw() external;
561 
562     /// @dev Restakes unstaked ORBS tokens (in or after cooldown) for msg.sender.
563     function restake() external;
564 
565     /// @dev Distributes staking rewards to a list of addresses by directly adding rewards to their stakes. This method
566     /// assumes that the user has already approved at least the required amount using ERC20 approve. Since this is a
567     /// convenience method, we aren't concerned about reaching block gas limit by using large lists. We assume that
568     /// callers will be able to properly batch/paginate their requests.
569     /// @param _totalAmount uint256 The total amount of rewards to distributes.
570     /// @param _stakeOwners address[] The addresses of the stake owners.
571     /// @param _amounts uint256[] The amounts of the rewards.
572     function distributeRewards(uint256 _totalAmount, address[] calldata _stakeOwners, uint256[] calldata _amounts) external;
573 
574     /// @dev Returns the stake of the specified stake owner (excluding unstaked tokens).
575     /// @param _stakeOwner address The address to check.
576     /// @return uint256 The total stake.
577     function getStakeBalanceOf(address _stakeOwner) external view returns (uint256);
578 
579     /// @dev Returns the total amount staked tokens (excluding unstaked tokens).
580     /// @return uint256 The total staked tokens of all stake owners.
581     function getTotalStakedTokens() external view returns (uint256);
582 
583     /// @dev Returns the time that the cooldown period ends (or ended) and the amount of tokens to be released.
584     /// @param _stakeOwner address The address to check.
585     /// @return cooldownAmount uint256 The total tokens in cooldown.
586     /// @return cooldownEndTime uint256 The time when the cooldown period ends (in seconds).
587     function getUnstakeStatus(address _stakeOwner) external view returns (uint256 cooldownAmount,
588         uint256 cooldownEndTime);
589 
590     /// @dev Migrates the stake of msg.sender from this staking contract to a new approved staking contract.
591     /// @param _newStakingContract IMigratableStakingContract The new staking contract which supports stake migration.
592     /// @param _amount uint256 The amount of tokens to migrate.
593     function migrateStakedTokens(IMigratableStakingContract _newStakingContract, uint256 _amount) external;
594 
595     event Staked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
596     event Unstaked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
597     event Withdrew(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
598     event Restaked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
599     event MigratedStake(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
600 }
601 
602 // File: contracts/spec_interfaces/ICommittee.sol
603 
604 pragma solidity 0.5.16;
605 
606 
607 /// @title Elections contract interface
608 interface ICommittee {
609 	event GuardianCommitteeChange(address addr, uint256 weight, bool certification, bool inCommittee);
610 	event CommitteeSnapshot(address[] addrs, uint256[] weights, bool[] certification);
611 
612 	// No external functions
613 
614 	/*
615      * Methods restricted to other Orbs contracts
616      */
617 
618 	/// @dev Called by: Elections contract
619 	/// Notifies a weight change for sorting to a relevant committee member.
620     /// weight = 0 indicates removal of the member from the committee (for exmaple on unregister, voteUnready, voteOut)
621 	function memberWeightChange(address addr, uint256 weight) external returns (bool committeeChanged) /* onlyElectionContract */;
622 
623 	/// @dev Called by: Elections contract
624 	/// Notifies a guardian certification change
625 	function memberCertificationChange(address addr, bool isCertified) external returns (bool committeeChanged) /* onlyElectionsContract */;
626 
627 	/// @dev Called by: Elections contract
628 	/// Notifies a a member removal for exampl	e due to voteOut / voteUnready
629 	function removeMember(address addr) external returns (bool committeeChanged) /* onlyElectionContract */;
630 
631 	/// @dev Called by: Elections contract
632 	/// Notifies a new member applicable for committee (due to registration, unbanning, certification change)
633 	function addMember(address addr, uint256 weight, bool isCertified) external returns (bool committeeChanged) /* onlyElectionsContract */;
634 
635 	/// @dev Called by: Elections contract
636 	/// Returns the committee members and their weights
637 	function getCommittee() external view returns (address[] memory addrs, uint256[] memory weights, bool[] memory certification);
638 
639 	/*
640 	 * Governance
641 	 */
642 
643 	function setMaxTimeBetweenRewardAssignments(uint32 maxTimeBetweenRewardAssignments) external /* onlyFunctionalOwner onlyWhenActive */;
644 	function setMaxCommittee(uint8 maxCommitteeSize) external /* onlyFunctionalOwner onlyWhenActive */;
645 
646 	event MaxTimeBetweenRewardAssignmentsChanged(uint32 newValue, uint32 oldValue);
647 	event MaxCommitteeSizeChanged(uint8 newValue, uint8 oldValue);
648 
649     /// @dev Updates the address calldata of the contract registry
650 	function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;
651 
652     /*
653      * Getters
654      */
655 
656     /// @dev returns the current committee
657     /// used also by the rewards and fees contracts
658 	function getCommitteeInfo() external view returns (address[] memory addrs, uint256[] memory weights, address[] memory orbsAddrs, bool[] memory certification, bytes4[] memory ips);
659 
660 	/// @dev returns the current settings of the committee contract
661 	function getSettings() external view returns (uint32 maxTimeBetweenRewardAssignments, uint8 maxCommitteeSize);
662 }
663 
664 // File: contracts/spec_interfaces/ICertification.sol
665 
666 pragma solidity 0.5.16;
667 
668 
669 
670 /// @title Elections contract interface
671 interface ICertification /* is Ownable */ {
672 	event GuardianCertificationUpdate(address guardian, bool isCertified);
673 
674 	/*
675      * External methods
676      */
677 
678     /// @dev Called by a guardian as part of the automatic vote unready flow
679     /// Used by the Election contract
680 	function isGuardianCertified(address addr) external view returns (bool isCertified);
681 
682     /// @dev Called by a guardian as part of the automatic vote unready flow
683     /// Used by the Election contract
684 	function setGuardianCertification(address addr, bool isCertified) external /* Owner only */ ;
685 
686 	/*
687 	 * Governance
688 	 */
689 
690     /// @dev Updates the address calldata of the contract registry
691 	function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;
692 
693 }
694 
695 // File: contracts/spec_interfaces/IProtocol.sol
696 
697 pragma solidity 0.5.16;
698 
699 interface IProtocol {
700     event ProtocolVersionChanged(string deploymentSubset, uint256 currentVersion, uint256 nextVersion, uint256 fromTimestamp);
701 
702     /*
703      *   External methods
704      */
705 
706     /// @dev returns true if the given deployment subset exists (i.e - is registered with a protocol version)
707     function deploymentSubsetExists(string calldata deploymentSubset) external view returns (bool);
708 
709     /// @dev returns the current protocol version for the given deployment subset.
710     function getProtocolVersion(string calldata deploymentSubset) external view returns (uint256);
711 
712     /*
713      *   Governor methods
714      */
715 
716     /// @dev create a new deployment subset.
717     function createDeploymentSubset(string calldata deploymentSubset, uint256 initialProtocolVersion) external /* onlyFunctionalOwner */;
718 
719     /// @dev schedules a protocol version upgrade for the given deployment subset.
720     function setProtocolVersion(string calldata deploymentSubset, uint256 nextVersion, uint256 fromTimestamp) external /* onlyFunctionalOwner */;
721 }
722 
723 // File: contracts/spec_interfaces/ISubscriptions.sol
724 
725 pragma solidity 0.5.16;
726 
727 
728 /// @title Subscriptions contract interface
729 interface ISubscriptions {
730     event SubscriptionChanged(uint256 vcid, uint256 genRefTime, uint256 expiresAt, string tier, string deploymentSubset);
731     event Payment(uint256 vcid, address by, uint256 amount, string tier, uint256 rate);
732     event VcConfigRecordChanged(uint256 vcid, string key, string value);
733     event SubscriberAdded(address subscriber);
734     event VcCreated(uint256 vcid, address owner); // TODO what about isCertified, deploymentSubset?
735     event VcOwnerChanged(uint256 vcid, address previousOwner, address newOwner);
736 
737     /*
738      *   Methods restricted to other Orbs contracts
739      */
740 
741     /// @dev Called by: authorized subscriber (plan) contracts
742     /// Creates a new VC
743     function createVC(string calldata tier, uint256 rate, uint256 amount, address owner, bool isCertified, string calldata deploymentSubset) external returns (uint, uint);
744 
745     /// @dev Called by: authorized subscriber (plan) contracts
746     /// Extends the subscription of an existing VC.
747     function extendSubscription(uint256 vcid, uint256 amount, address payer) external;
748 
749     /// @dev called by VC owner to set a VC config record. Emits a VcConfigRecordChanged event.
750     function setVcConfigRecord(uint256 vcid, string calldata key, string calldata value) external /* onlyVcOwner */;
751 
752     /// @dev returns the value of a VC config record
753     function getVcConfigRecord(uint256 vcid, string calldata key) external view returns (string memory);
754 
755     /// @dev Transfers VC ownership to a new owner (can only be called by the current owner)
756     function setVcOwner(uint256 vcid, address owner) external /* onlyVcOwner */;
757 
758     /// @dev Returns the genesis ref time delay
759     function getGenesisRefTimeDelay() external view returns (uint256);
760 
761     /*
762      *   Governance methods
763      */
764 
765     /// @dev Called by the owner to authorize a subscriber (plan)
766     function addSubscriber(address addr) external /* onlyFunctionalOwner */;
767 
768     /// @dev Called by the owner to set the genesis ref time delay
769     function setGenesisRefTimeDelay(uint256 newGenesisRefTimeDelay) external /* onlyFunctionalOwner */;
770 
771     /// @dev Updates the address of the contract registry
772     function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;
773 
774 }
775 
776 // File: contracts/interfaces/IRewards.sol
777 
778 pragma solidity 0.5.16;
779 
780 
781 
782 /// @title Rewards contract interface
783 interface IRewards {
784 
785     function assignRewards() external;
786     function assignRewardsToCommittee(address[] calldata generalCommittee, uint256[] calldata generalCommitteeWeights, bool[] calldata certification) external /* onlyCommitteeContract */;
787 
788     // staking
789 
790     event StakingRewardsDistributed(address indexed distributer, uint256 fromBlock, uint256 toBlock, uint split, uint txIndex, address[] to, uint256[] amounts);
791     event StakingRewardsAssigned(address[] assignees, uint256[] amounts); // todo balance?
792     event StakingRewardsAddedToPool(uint256 added, uint256 total);
793     event MaxDelegatorsStakingRewardsChanged(uint32 maxDelegatorsStakingRewardsPercentMille);
794 
795     /// @return Returns the currently unclaimed orbs token reward balance of the given address.
796     function getStakingRewardBalance(address addr) external view returns (uint256 balance);
797 
798     /// @dev Distributes msg.sender's orbs token rewards to a list of addresses, by transferring directly into the staking contract.
799     /// @dev `to[0]` must be the sender's main address
800     /// @dev Total delegators reward (`to[1:n]`) must be less then maxDelegatorsStakingRewardsPercentMille of total amount
801     function distributeOrbsTokenStakingRewards(uint256 totalAmount, uint256 fromBlock, uint256 toBlock, uint split, uint txIndex, address[] calldata to, uint256[] calldata amounts) external;
802 
803     /// @dev Transfers the given amount of orbs tokens form the sender to this contract an update the pool.
804     function topUpStakingRewardsPool(uint256 amount) external;
805 
806     /*
807     *   Reward-governor methods
808     */
809 
810     /// @dev Assigns rewards and sets a new monthly rate for the pro-rata pool.
811     function setAnnualStakingRewardsRate(uint256 annual_rate_in_percent_mille, uint256 annual_cap) external /* onlyFunctionalOwner */;
812 
813 
814     // fees
815 
816     event FeesAssigned(uint256 generalGuardianAmount, uint256 certifiedGuardianAmount);
817     event FeesWithdrawn(address guardian, uint256 amount);
818     event FeesWithdrawnFromBucket(uint256 bucketId, uint256 withdrawn, uint256 total, bool isCertified);
819     event FeesAddedToBucket(uint256 bucketId, uint256 added, uint256 total, bool isCertified);
820 
821     /*
822      *   External methods
823      */
824 
825     /// @return Returns the currently unclaimed orbs token reward balance of the given address.
826     function getFeeBalance(address addr) external view returns (uint256 balance);
827 
828     /// @dev Transfer all of msg.sender's outstanding balance to their account
829     function withdrawFeeFunds() external;
830 
831     /// @dev Called by: subscriptions contract
832     /// Top-ups the certification fee pool with the given amount at the given rate (typically called by the subscriptions contract)
833     function fillCertificationFeeBuckets(uint256 amount, uint256 monthlyRate, uint256 fromTimestamp) external;
834 
835     /// @dev Called by: subscriptions contract
836     /// Top-ups the general fee pool with the given amount at the given rate (typically called by the subscriptions contract)
837     function fillGeneralFeeBuckets(uint256 amount, uint256 monthlyRate, uint256 fromTimestamp) external;
838 
839     function getTotalBalances() external view returns (uint256 feesTotalBalance, uint256 stakingRewardsTotalBalance, uint256 bootstrapRewardsTotalBalance);
840 
841     // bootstrap
842 
843     event BootstrapRewardsAssigned(uint256 generalGuardianAmount, uint256 certifiedGuardianAmount);
844     event BootstrapAddedToPool(uint256 added, uint256 total);
845     event BootstrapRewardsWithdrawn(address guardian, uint256 amount);
846 
847     /*
848      *   External methods
849      */
850 
851     /// @return Returns the currently unclaimed bootstrap balance of the given address.
852     function getBootstrapBalance(address addr) external view returns (uint256 balance);
853 
854     /// @dev Transfer all of msg.sender's outstanding balance to their account
855     function withdrawBootstrapFunds() external;
856 
857     /// @return The timestamp of the last reward assignment.
858     function getLastRewardAssignmentTime() external view returns (uint256 time);
859 
860     /// @dev Transfers the given amount of bootstrap tokens form the sender to this contract and update the pool.
861     /// Assumes the tokens were approved for transfer
862     function topUpBootstrapPool(uint256 amount) external;
863 
864     /*
865      * Reward-governor methods
866      */
867 
868     /// @dev Assigns rewards and sets a new monthly rate for the geenral commitee bootstrap.
869     function setGeneralCommitteeAnnualBootstrap(uint256 annual_amount) external /* onlyFunctionalOwner */;
870 
871     /// @dev Assigns rewards and sets a new monthly rate for the certification commitee bootstrap.
872     function setCertificationCommitteeAnnualBootstrap(uint256 annual_amount) external /* onlyFunctionalOwner */;
873 
874     event EmergencyWithdrawal(address addr);
875 
876     function emergencyWithdraw() external /* onlyMigrationManager */;
877 
878     /*
879      * General governance
880      */
881 
882     /// @dev Updates the address of the contract registry
883     function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;
884 
885 
886 }
887 
888 // File: @openzeppelin/contracts/GSN/Context.sol
889 
890 pragma solidity ^0.5.0;
891 
892 /*
893  * @dev Provides information about the current execution context, including the
894  * sender of the transaction and its data. While these are generally available
895  * via msg.sender and msg.data, they should not be accessed in such a direct
896  * manner, since when dealing with GSN meta-transactions the account sending and
897  * paying for execution may not be the actual sender (as far as an application
898  * is concerned).
899  *
900  * This contract is only required for intermediate, library-like contracts.
901  */
902 contract Context {
903     // Empty internal constructor, to prevent people from mistakenly deploying
904     // an instance of this contract, which should be used via inheritance.
905     constructor () internal { }
906     // solhint-disable-previous-line no-empty-blocks
907 
908     function _msgSender() internal view returns (address payable) {
909         return msg.sender;
910     }
911 
912     function _msgData() internal view returns (bytes memory) {
913         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
914         return msg.data;
915     }
916 }
917 
918 // File: contracts/WithClaimableMigrationOwnership.sol
919 
920 pragma solidity 0.5.16;
921 
922 
923 /**
924  * @title Claimable
925  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
926  * This allows the new owner to accept the transfer.
927  */
928 contract WithClaimableMigrationOwnership is Context{
929     address private _migrationOwner;
930     address pendingMigrationOwner;
931 
932     event MigrationOwnershipTransferred(address indexed previousMigrationOwner, address indexed newMigrationOwner);
933 
934     /**
935      * @dev Initializes the contract setting the deployer as the initial migrationMigrationOwner.
936      */
937     constructor () internal {
938         address msgSender = _msgSender();
939         _migrationOwner = msgSender;
940         emit MigrationOwnershipTransferred(address(0), msgSender);
941     }
942 
943     /**
944      * @dev Returns the address of the current migrationOwner.
945      */
946     function migrationOwner() public view returns (address) {
947         return _migrationOwner;
948     }
949 
950     /**
951      * @dev Throws if called by any account other than the migrationOwner.
952      */
953     modifier onlyMigrationOwner() {
954         require(isMigrationOwner(), "WithClaimableMigrationOwnership: caller is not the migrationOwner");
955         _;
956     }
957 
958     /**
959      * @dev Returns true if the caller is the current migrationOwner.
960      */
961     function isMigrationOwner() public view returns (bool) {
962         return _msgSender() == _migrationOwner;
963     }
964 
965     /**
966      * @dev Leaves the contract without migrationOwner. It will not be possible to call
967      * `onlyOwner` functions anymore. Can only be called by the current migrationOwner.
968      *
969      * NOTE: Renouncing migrationOwnership will leave the contract without an migrationOwner,
970      * thereby removing any functionality that is only available to the migrationOwner.
971      */
972     function renounceMigrationOwnership() public onlyMigrationOwner {
973         emit MigrationOwnershipTransferred(_migrationOwner, address(0));
974         _migrationOwner = address(0);
975     }
976 
977     /**
978      * @dev Transfers migrationOwnership of the contract to a new account (`newOwner`).
979      */
980     function _transferMigrationOwnership(address newMigrationOwner) internal {
981         require(newMigrationOwner != address(0), "MigrationOwner: new migrationOwner is the zero address");
982         emit MigrationOwnershipTransferred(_migrationOwner, newMigrationOwner);
983         _migrationOwner = newMigrationOwner;
984     }
985 
986     /**
987      * @dev Modifier throws if called by any account other than the pendingOwner.
988      */
989     modifier onlyPendingMigrationOwner() {
990         require(msg.sender == pendingMigrationOwner, "Caller is not the pending migrationOwner");
991         _;
992     }
993     /**
994      * @dev Allows the current migrationOwner to set the pendingOwner address.
995      * @param newMigrationOwner The address to transfer migrationOwnership to.
996      */
997     function transferMigrationOwnership(address newMigrationOwner) public onlyMigrationOwner {
998         pendingMigrationOwner = newMigrationOwner;
999     }
1000     /**
1001      * @dev Allows the pendingMigrationOwner address to finalize the transfer.
1002      */
1003     function claimMigrationOwnership() external onlyPendingMigrationOwner {
1004         _transferMigrationOwnership(pendingMigrationOwner);
1005         pendingMigrationOwner = address(0);
1006     }
1007 }
1008 
1009 // File: contracts/Lockable.sol
1010 
1011 pragma solidity 0.5.16;
1012 
1013 
1014 
1015 /**
1016  * @title Claimable
1017  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
1018  * This allows the new owner to accept the transfer.
1019  */
1020 contract Lockable is WithClaimableMigrationOwnership {
1021 
1022     bool public locked;
1023 
1024     event Locked();
1025     event Unlocked();
1026 
1027     function lock() external onlyMigrationOwner {
1028         locked = true;
1029         emit Locked();
1030     }
1031 
1032     function unlock() external onlyMigrationOwner {
1033         locked = false;
1034         emit Unlocked();
1035     }
1036 
1037     modifier onlyWhenActive() {
1038         require(!locked, "contract is locked for this operation");
1039 
1040         _;
1041     }
1042 }
1043 
1044 // File: contracts/spec_interfaces/IProtocolWallet.sol
1045 
1046 pragma solidity 0.5.16;
1047 
1048 
1049 
1050 pragma solidity 0.5.16;
1051 
1052 /// @title Protocol Wallet interface
1053 interface IProtocolWallet {
1054     event FundsAddedToPool(uint256 added, uint256 total);
1055     event ClientSet(address client);
1056     event MaxAnnualRateSet(uint256 maxAnnualRate);
1057     event EmergencyWithdrawal(address addr);
1058 
1059     /// @dev Returns the address of the underlying staked token.
1060     /// @return IERC20 The address of the token.
1061     function getToken() external view returns (IERC20);
1062 
1063     /// @dev Returns the address of the underlying staked token.
1064     /// @return IERC20 The address of the token.
1065     function getBalance() external view returns (uint256 balance);
1066 
1067     /// @dev Transfers the given amount of orbs tokens form the sender to this contract an update the pool.
1068     function topUp(uint256 amount) external;
1069 
1070     /// @dev Withdraw from pool to a the sender's address, limited by the pool's MaxRate.
1071     /// A maximum of MaxRate x time period since the last Orbs transfer may be transferred out.
1072     /// Flow:
1073     /// PoolWallet.approveTransfer(amount);
1074     /// ERC20.transferFrom(PoolWallet, client, amount)
1075     function withdraw(uint256 amount) external; /* onlyClient */
1076 
1077     /* Governance */
1078     /// @dev Sets a new transfer rate for the Orbs pool.
1079     function setMaxAnnualRate(uint256 annual_rate) external; /* onlyMigrationManager */
1080 
1081     /// @dev transfer the entire pool's balance to a new wallet.
1082     function emergencyWithdraw() external; /* onlyMigrationManager */
1083 
1084     /// @dev sets the address of the new contract
1085     function setClient(address client) external; /* onlyFunctionalManager */
1086 }
1087 
1088 // File: contracts/ContractRegistryAccessor.sol
1089 
1090 pragma solidity 0.5.16;
1091 
1092 
1093 
1094 
1095 
1096 
1097 
1098 
1099 
1100 
1101 
1102 
1103 
1104 contract ContractRegistryAccessor is WithClaimableMigrationOwnership {
1105 
1106     IContractRegistry contractRegistry;
1107 
1108     event ContractRegistryAddressUpdated(address addr);
1109 
1110     function setContractRegistry(IContractRegistry _contractRegistry) external onlyMigrationOwner {
1111         contractRegistry = _contractRegistry;
1112         emit ContractRegistryAddressUpdated(address(_contractRegistry));
1113     }
1114 
1115     function getProtocolContract() public view returns (IProtocol) {
1116         return IProtocol(contractRegistry.get("protocol"));
1117     }
1118 
1119     function getRewardsContract() public view returns (IRewards) {
1120         return IRewards(contractRegistry.get("rewards"));
1121     }
1122 
1123     function getCommitteeContract() public view returns (ICommittee) {
1124         return ICommittee(contractRegistry.get("committee"));
1125     }
1126 
1127     function getElectionsContract() public view returns (IElections) {
1128         return IElections(contractRegistry.get("elections"));
1129     }
1130 
1131     function getDelegationsContract() public view returns (IDelegations) {
1132         return IDelegations(contractRegistry.get("delegations"));
1133     }
1134 
1135     function getGuardiansRegistrationContract() public view returns (IGuardiansRegistration) {
1136         return IGuardiansRegistration(contractRegistry.get("guardiansRegistration"));
1137     }
1138 
1139     function getCertificationContract() public view returns (ICertification) {
1140         return ICertification(contractRegistry.get("certification"));
1141     }
1142 
1143     function getStakingContract() public view returns (IStakingContract) {
1144         return IStakingContract(contractRegistry.get("staking"));
1145     }
1146 
1147     function getSubscriptionsContract() public view returns (ISubscriptions) {
1148         return ISubscriptions(contractRegistry.get("subscriptions"));
1149     }
1150 
1151     function getStakingRewardsWallet() public view returns (IProtocolWallet) {
1152         return IProtocolWallet(contractRegistry.get("stakingRewardsWallet"));
1153     }
1154 
1155     function getBootstrapRewardsWallet() public view returns (IProtocolWallet) {
1156         return IProtocolWallet(contractRegistry.get("bootstrapRewardsWallet"));
1157     }
1158 
1159 }
1160 
1161 // File: contracts/WithClaimableFunctionalOwnership.sol
1162 
1163 pragma solidity 0.5.16;
1164 
1165 
1166 /**
1167  * @title Claimable
1168  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
1169  * This allows the new owner to accept the transfer.
1170  */
1171 contract WithClaimableFunctionalOwnership is Context{
1172     address private _functionalOwner;
1173     address pendingFunctionalOwner;
1174 
1175     event FunctionalOwnershipTransferred(address indexed previousFunctionalOwner, address indexed newFunctionalOwner);
1176 
1177     /**
1178      * @dev Initializes the contract setting the deployer as the initial functionalFunctionalOwner.
1179      */
1180     constructor () internal {
1181         address msgSender = _msgSender();
1182         _functionalOwner = msgSender;
1183         emit FunctionalOwnershipTransferred(address(0), msgSender);
1184     }
1185 
1186     /**
1187      * @dev Returns the address of the current functionalOwner.
1188      */
1189     function functionalOwner() public view returns (address) {
1190         return _functionalOwner;
1191     }
1192 
1193     /**
1194      * @dev Throws if called by any account other than the functionalOwner.
1195      */
1196     modifier onlyFunctionalOwner() {
1197         require(isFunctionalOwner(), "WithClaimableFunctionalOwnership: caller is not the functionalOwner");
1198         _;
1199     }
1200 
1201     /**
1202      * @dev Returns true if the caller is the current functionalOwner.
1203      */
1204     function isFunctionalOwner() public view returns (bool) {
1205         return _msgSender() == _functionalOwner;
1206     }
1207 
1208     /**
1209      * @dev Leaves the contract without functionalOwner. It will not be possible to call
1210      * `onlyOwner` functions anymore. Can only be called by the current functionalOwner.
1211      *
1212      * NOTE: Renouncing functionalOwnership will leave the contract without an functionalOwner,
1213      * thereby removing any functionality that is only available to the functionalOwner.
1214      */
1215     function renounceFunctionalOwnership() public onlyFunctionalOwner {
1216         emit FunctionalOwnershipTransferred(_functionalOwner, address(0));
1217         _functionalOwner = address(0);
1218     }
1219 
1220     /**
1221      * @dev Transfers functionalOwnership of the contract to a new account (`newOwner`).
1222      */
1223     function _transferFunctionalOwnership(address newFunctionalOwner) internal {
1224         require(newFunctionalOwner != address(0), "FunctionalOwner: new functionalOwner is the zero address");
1225         emit FunctionalOwnershipTransferred(_functionalOwner, newFunctionalOwner);
1226         _functionalOwner = newFunctionalOwner;
1227     }
1228 
1229     /**
1230      * @dev Modifier throws if called by any account other than the pendingOwner.
1231      */
1232     modifier onlyPendingFunctionalOwner() {
1233         require(msg.sender == pendingFunctionalOwner, "Caller is not the pending functionalOwner");
1234         _;
1235     }
1236     /**
1237      * @dev Allows the current functionalOwner to set the pendingOwner address.
1238      * @param newFunctionalOwner The address to transfer functionalOwnership to.
1239      */
1240     function transferFunctionalOwnership(address newFunctionalOwner) public onlyFunctionalOwner {
1241         pendingFunctionalOwner = newFunctionalOwner;
1242     }
1243     /**
1244      * @dev Allows the pendingFunctionalOwner address to finalize the transfer.
1245      */
1246     function claimFunctionalOwnership() external onlyPendingFunctionalOwner {
1247         _transferFunctionalOwnership(pendingFunctionalOwner);
1248         pendingFunctionalOwner = address(0);
1249     }
1250 }
1251 
1252 // File: ../contracts/Elections.sol
1253 
1254 pragma solidity 0.5.16;
1255 
1256 
1257 
1258 
1259 
1260 
1261 
1262 
1263 
1264 
1265 
1266 
1267 
1268 contract Elections is IElections, ContractRegistryAccessor, WithClaimableFunctionalOwnership, Lockable {
1269 	using SafeMath for uint256;
1270 
1271 	mapping (address => mapping (address => uint256)) votedUnreadyVotes; // by => to => timestamp
1272 	mapping (address => uint256) votersStake;
1273 	mapping (address => address) voteOutVotes; // by => to
1274 	mapping (address => uint256) accumulatedStakesForVoteOut; // addr => total stake
1275 	mapping (address => bool) votedOutGuardians;
1276 
1277 	struct Settings {
1278 		uint32 voteUnreadyTimeoutSeconds;
1279 		uint32 minSelfStakePercentMille;
1280 		uint8 voteUnreadyPercentageThreshold;
1281 		uint8 voteOutPercentageThreshold;
1282 	}
1283 	Settings settings;
1284 
1285 	modifier onlyDelegationsContract() {
1286 		require(msg.sender == address(getDelegationsContract()), "caller is not the delegations contract");
1287 
1288 		_;
1289 	}
1290 
1291 	modifier onlyGuardiansRegistrationContract() {
1292 		require(msg.sender == address(getGuardiansRegistrationContract()), "caller is not the guardian registrations contract");
1293 
1294 		_;
1295 	}
1296 
1297 	constructor(uint32 minSelfStakePercentMille, uint8 voteUnreadyPercentageThreshold, uint32 voteUnreadyTimeoutSeconds, uint8 voteOutPercentageThreshold) public {
1298 		require(minSelfStakePercentMille <= 100000, "minSelfStakePercentMille must be at most 100000");
1299 		require(voteUnreadyPercentageThreshold >= 0 && voteUnreadyPercentageThreshold <= 100, "voteUnreadyPercentageThreshold must be between 0 and 100");
1300 		require(voteOutPercentageThreshold >= 0 && voteOutPercentageThreshold <= 100, "voteOutPercentageThreshold must be between 0 and 100");
1301 
1302 		settings = Settings({
1303 			minSelfStakePercentMille: minSelfStakePercentMille,
1304 			voteUnreadyPercentageThreshold: voteUnreadyPercentageThreshold,
1305 			voteUnreadyTimeoutSeconds: voteUnreadyTimeoutSeconds,
1306 			voteOutPercentageThreshold: voteOutPercentageThreshold
1307 		});
1308 	}
1309 
1310 	/// @dev Called by: guardian registration contract
1311 	/// Notifies a new guardian was registered
1312 	function guardianRegistered(address addr) external onlyGuardiansRegistrationContract {
1313 	}
1314 
1315 	/// @dev Called by: guardian registration contract
1316 	/// Notifies a new guardian was unregistered
1317 	function guardianUnregistered(address addr) external onlyGuardiansRegistrationContract {
1318 		emit GuardianStatusUpdated(addr, false, false);
1319 		getCommitteeContract().removeMember(addr);
1320 	}
1321 
1322 	/// @dev Called by: guardian registration contract
1323 	/// Notifies on a guardian certification change
1324 	function guardianCertificationChanged(address addr, bool isCertified) external {
1325 		getCommitteeContract().memberCertificationChange(addr, isCertified);
1326 	}
1327 
1328 	function requireNotVotedOut(address addr) private view {
1329 		require(!isVotedOut(addr), "caller is voted-out");
1330 	}
1331 
1332 	function readyForCommittee() external {
1333 		address guardianAddr = getGuardiansRegistrationContract().resolveGuardianAddress(msg.sender); // this validates registration
1334 		require(!isVotedOut(guardianAddr), "caller is voted-out");
1335 
1336 		emit GuardianStatusUpdated(guardianAddr, true, true);
1337 		getCommitteeContract().addMember(guardianAddr, getCommitteeEffectiveStake(guardianAddr, settings), getCertificationContract().isGuardianCertified(guardianAddr));
1338 	}
1339 
1340 	function readyToSync() external {
1341 		address guardianAddr = getGuardiansRegistrationContract().resolveGuardianAddress(msg.sender); // this validates registration
1342 		require(!isVotedOut(guardianAddr), "caller is voted-out");
1343 
1344 		emit GuardianStatusUpdated(guardianAddr, true, false);
1345 		getCommitteeContract().removeMember(guardianAddr);
1346 	}
1347 
1348 	function clearCommitteeUnreadyVotes(address[] memory committee, address votee) private {
1349 		for (uint i = 0; i < committee.length; i++) {
1350 			votedUnreadyVotes[committee[i]][votee] = 0; // clear vote-outs
1351 		}
1352 	}
1353 
1354 	function isCommitteeVoteUnreadyThresholdReached(address[] memory committee, uint256[] memory weights, bool[] memory certification, address votee) private returns (bool) {
1355 		Settings memory _settings = settings;
1356 
1357 		uint256 totalCommitteeStake = 0;
1358 		uint256 totalVoteUnreadyStake = 0;
1359 		uint256 totalCertifiedStake = 0;
1360 		uint256 totalCertifiedVoteUnreadyStake = 0;
1361 
1362 		address member;
1363 		uint256 memberStake;
1364 		bool isVoteeCertified;
1365 		for (uint i = 0; i < committee.length; i++) {
1366 			member = committee[i];
1367 			memberStake = weights[i];
1368 
1369 			if (member == votee && certification[i]) {
1370 				isVoteeCertified = true;
1371 			}
1372 
1373 			totalCommitteeStake = totalCommitteeStake.add(memberStake);
1374 			if (certification[i]) {
1375 				totalCertifiedStake = totalCertifiedStake.add(memberStake);
1376 			}
1377 
1378 			uint256 votedAt = votedUnreadyVotes[member][votee];
1379 			if (votedAt != 0) {
1380 				if (now.sub(votedAt) < _settings.voteUnreadyTimeoutSeconds) {
1381 					// Vote is valid
1382 					totalVoteUnreadyStake = totalVoteUnreadyStake.add(memberStake);
1383 					if (certification[i]) {
1384 						totalCertifiedVoteUnreadyStake = totalCertifiedVoteUnreadyStake.add(memberStake);
1385 					}
1386 				} else {
1387 					// Vote is stale, delete from state
1388 					votedUnreadyVotes[member][votee] = 0;
1389 				}
1390 			}
1391 		}
1392 
1393 		return (totalCommitteeStake > 0 && totalVoteUnreadyStake.mul(100).div(totalCommitteeStake) >= _settings.voteUnreadyPercentageThreshold)
1394 			|| (isVoteeCertified && totalCertifiedStake > 0 && totalCertifiedVoteUnreadyStake.mul(100).div(totalCertifiedStake) >= _settings.voteUnreadyPercentageThreshold);
1395 	}
1396 
1397 	function voteUnready(address subjectAddr) external onlyWhenActive {
1398 		address sender = getMainAddrFromOrbsAddr(msg.sender);
1399 		votedUnreadyVotes[sender][subjectAddr] = now;
1400 		emit VoteUnreadyCasted(sender, subjectAddr);
1401 
1402 		(address[] memory generalCommittee, uint256[] memory generalWeights, bool[] memory certification) = getCommitteeContract().getCommittee();
1403 
1404 		bool votedUnready = isCommitteeVoteUnreadyThresholdReached(generalCommittee, generalWeights, certification, subjectAddr);
1405 		if (votedUnready) {
1406 			clearCommitteeUnreadyVotes(generalCommittee, subjectAddr);
1407 			emit GuardianVotedUnready(subjectAddr);
1408 			emit GuardianStatusUpdated(subjectAddr, false, false);
1409             getCommitteeContract().removeMember(subjectAddr);
1410 		}
1411 	}
1412 
1413 	function voteOut(address subject) external onlyWhenActive {
1414 		Settings memory _settings = settings;
1415 
1416 		address prevSubject = voteOutVotes[msg.sender];
1417 		voteOutVotes[msg.sender] = subject;
1418 
1419 		uint256 voterStake = getDelegationsContract().getDelegatedStakes(msg.sender);
1420 
1421 		if (prevSubject == address(0)) {
1422 			votersStake[msg.sender] = voterStake;
1423 		}
1424 
1425 		if (subject == address(0)) {
1426 			delete votersStake[msg.sender];
1427 		}
1428 
1429 		uint totalStake = getDelegationsContract().getTotalDelegatedStake();
1430 
1431 		if (prevSubject != address(0) && prevSubject != subject) {
1432 			_applyVoteOutVotesFor(prevSubject, 0, voterStake, totalStake, _settings);
1433 		}
1434 
1435 		if (subject != address(0)) {
1436 			uint voteStakeAdded = prevSubject != subject ? voterStake : 0;
1437 			_applyVoteOutVotesFor(subject, voteStakeAdded, 0, totalStake, _settings); // recheck also if not new
1438 		}
1439 		emit VoteOutCasted(msg.sender, subject);
1440 	}
1441 
1442 	function calcGovernanceEffectiveStake(bool selfDelegating, uint256 totalDelegatedStake) private pure returns (uint256) {
1443 		return selfDelegating ? totalDelegatedStake : 0;
1444 	}
1445 
1446 	function getVoteOutVote(address addr) external view returns (address) {
1447 		return voteOutVotes[addr];
1448 	}
1449 
1450 	function getAccumulatedStakesForVoteOut(address addr) external view returns (uint256) {
1451 		return accumulatedStakesForVoteOut[addr];
1452 	}
1453 
1454 	function _applyStakesToVoteOutBy(address voter, uint256 currentVoterStake, uint256 totalGovernanceStake, Settings memory _settings) private {
1455 		address subjectAddr = voteOutVotes[voter];
1456 		if (subjectAddr == address(0)) return;
1457 
1458 		uint256 prevVoterStake = votersStake[voter];
1459 		votersStake[voter] = currentVoterStake;
1460 
1461 		_applyVoteOutVotesFor(subjectAddr, currentVoterStake, prevVoterStake, totalGovernanceStake, _settings);
1462 	}
1463 
1464     function _applyVoteOutVotesFor(address subjectAddr, uint256 voteOutStakeAdded, uint256 voteOutStakeRemoved, uint256 totalGovernanceStake, Settings memory _settings) private {
1465 		if (isVotedOut(subjectAddr)) {
1466 			return;
1467 		}
1468 
1469 		uint256 accumulated = accumulatedStakesForVoteOut[subjectAddr].
1470 			sub(voteOutStakeRemoved).
1471 			add(voteOutStakeAdded);
1472 
1473 		bool shouldBeVotedOut = totalGovernanceStake > 0 && accumulated.mul(100).div(totalGovernanceStake) >= _settings.voteOutPercentageThreshold;
1474 		if (shouldBeVotedOut) {
1475 			votedOutGuardians[subjectAddr] = true;
1476 			emit GuardianVotedOut(subjectAddr);
1477 
1478 			emit GuardianStatusUpdated(subjectAddr, false, false);
1479 			getCommitteeContract().removeMember(subjectAddr);
1480 
1481 			accumulated = 0;
1482 		}
1483 
1484 		accumulatedStakesForVoteOut[subjectAddr] = accumulated;
1485 	}
1486 
1487 	function isVotedOut(address addr) private view returns (bool) {
1488 		return votedOutGuardians[addr];
1489 	}
1490 
1491 	function delegatedStakeChange(address addr, uint256 selfStake, uint256 delegatedStake, uint256 totalDelegatedStake) external onlyDelegationsContract onlyWhenActive {
1492 		Settings memory _settings = settings;
1493 		_applyDelegatedStake(addr, selfStake, delegatedStake, _settings);
1494 		_applyStakesToVoteOutBy(addr, delegatedStake, totalDelegatedStake, _settings);
1495 	}
1496 
1497 	function getMainAddrFromOrbsAddr(address orbsAddr) private view returns (address) {
1498 		address[] memory orbsAddrArr = new address[](1);
1499 		orbsAddrArr[0] = orbsAddr;
1500 		address sender = getGuardiansRegistrationContract().getEthereumAddresses(orbsAddrArr)[0];
1501 		require(sender != address(0), "unknown orbs address");
1502 		return sender;
1503 	}
1504 
1505 	function _applyDelegatedStake(address addr, uint256 selfStake, uint256 delegatedStake, Settings memory _settings) private {
1506 		uint effectiveStake = getCommitteeEffectiveStake(selfStake, delegatedStake, _settings);
1507 		emit StakeChanged(addr, selfStake, delegatedStake, effectiveStake);
1508 
1509 		getCommitteeContract().memberWeightChange(addr, effectiveStake);
1510 	}
1511 
1512 	function getCommitteeEffectiveStake(uint256 selfStake, uint256 delegatedStake, Settings memory _settings) private view returns (uint256) {
1513 		if (selfStake == 0) {
1514 			return 0;
1515 		}
1516 
1517 		if (selfStake.mul(100000) >= delegatedStake.mul(_settings.minSelfStakePercentMille)) {
1518 			return delegatedStake;
1519 		}
1520 
1521 		return selfStake.mul(100000).div(_settings.minSelfStakePercentMille); // never overflows or divides by zero
1522 	}
1523 
1524 	function getCommitteeEffectiveStake(address v, Settings memory _settings) private view returns (uint256) {
1525 		return getCommitteeEffectiveStake(getStakingContract().getStakeBalanceOf(v), getDelegationsContract().getDelegatedStakes(v), _settings);
1526 	}
1527 
1528 	function removeMemberFromCommittees(address addr) private {
1529 		getCommitteeContract().removeMember(addr);
1530 	}
1531 
1532 	function addMemberToCommittees(address addr, Settings memory _settings) private {
1533 		getCommitteeContract().addMember(addr, getCommitteeEffectiveStake(addr, _settings), getCertificationContract().isGuardianCertified(addr));
1534 	}
1535 
1536 	function setVoteUnreadyTimeoutSeconds(uint32 voteUnreadyTimeoutSeconds) external onlyFunctionalOwner /* todo onlyWhenActive */ {
1537 		emit VoteUnreadyTimeoutSecondsChanged(voteUnreadyTimeoutSeconds, settings.voteUnreadyTimeoutSeconds);
1538 		settings.voteUnreadyTimeoutSeconds = voteUnreadyTimeoutSeconds;
1539 	}
1540 
1541 	function setMinSelfStakePercentMille(uint32 minSelfStakePercentMille) external onlyFunctionalOwner /* todo onlyWhenActive */ {
1542 		require(minSelfStakePercentMille <= 100000, "minSelfStakePercentMille must be 100000 at most");
1543 		emit MinSelfStakePercentMilleChanged(minSelfStakePercentMille, settings.minSelfStakePercentMille);
1544 		settings.minSelfStakePercentMille = minSelfStakePercentMille;
1545 	}
1546 
1547 	function setVoteOutPercentageThreshold(uint8 voteOutPercentageThreshold) external onlyFunctionalOwner /* todo onlyWhenActive */ {
1548 		require(voteOutPercentageThreshold <= 100, "voteOutPercentageThreshold must not be larger than 100");
1549 		emit VoteOutPercentageThresholdChanged(voteOutPercentageThreshold, settings.voteOutPercentageThreshold);
1550 		settings.voteOutPercentageThreshold = voteOutPercentageThreshold;
1551 	}
1552 
1553 	function setVoteUnreadyPercentageThreshold(uint8 voteUnreadyPercentageThreshold) external onlyFunctionalOwner /* todo onlyWhenActive */ {
1554 		require(voteUnreadyPercentageThreshold <= 100, "voteUnreadyPercentageThreshold must not be larger than 100");
1555 		emit VoteUnreadyPercentageThresholdChanged(voteUnreadyPercentageThreshold, settings.voteUnreadyPercentageThreshold);
1556 		settings.voteUnreadyPercentageThreshold = voteUnreadyPercentageThreshold;
1557 	}
1558 
1559 	function getSettings() external view returns (
1560 		uint32 voteUnreadyTimeoutSeconds,
1561 		uint32 minSelfStakePercentMille,
1562 		uint8 voteUnreadyPercentageThreshold,
1563 		uint8 voteOutPercentageThreshold
1564 	) {
1565 		Settings memory _settings = settings;
1566 		voteUnreadyTimeoutSeconds = _settings.voteUnreadyTimeoutSeconds;
1567 		minSelfStakePercentMille = _settings.minSelfStakePercentMille;
1568 		voteUnreadyPercentageThreshold = _settings.voteUnreadyPercentageThreshold;
1569 		voteOutPercentageThreshold = _settings.voteUnreadyPercentageThreshold;
1570 	}
1571 
1572 }