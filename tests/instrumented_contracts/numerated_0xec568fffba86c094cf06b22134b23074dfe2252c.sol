1 // SPDX-License-Identifier: agpl-3.0
2 pragma solidity 0.7.5;
3 pragma abicoder v2;
4 
5 function getChainId() pure returns (uint256) {
6   uint256 chainId;
7   assembly {
8     chainId := chainid()
9   }
10   return chainId;
11 }
12 
13 function isContract(address account) view returns (bool) {
14   // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
15   // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
16   // for accounts without code, i.e. `keccak256('')`
17   bytes32 codehash;
18   bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
19   // solhint-disable-next-line no-inline-assembly
20   assembly {
21     codehash := extcodehash(account)
22   }
23   return (codehash != accountHash && codehash != 0x0);
24 }
25 
26 /*
27  * @dev Provides information about the current execution context, including the
28  * sender of the transaction and its data. While these are generally available
29  * via msg.sender and msg.data, they should not be accessed in such a direct
30  * manner, since when dealing with GSN meta-transactions the account sending and
31  * paying for execution may not be the actual sender (as far as an application
32  * is concerned).
33  *
34  * This contract is only required for intermediate, library-like contracts.
35  */
36 abstract contract Context {
37   function _msgSender() internal view virtual returns (address payable) {
38     return msg.sender;
39   }
40 
41   function _msgData() internal view virtual returns (bytes memory) {
42     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
43     return msg.data;
44   }
45 }
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 contract Ownable is Context {
60   address private _owner;
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64   /**
65    * @dev Initializes the contract setting the deployer as the initial owner.
66    */
67   constructor() {
68     address msgSender = _msgSender();
69     _owner = msgSender;
70     emit OwnershipTransferred(address(0), msgSender);
71   }
72 
73   /**
74    * @dev Returns the address of the current owner.
75    */
76   function owner() public view returns (address) {
77     return _owner;
78   }
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
85     _;
86   }
87 
88   /**
89    * @dev Leaves the contract without owner. It will not be possible to call
90    * `onlyOwner` functions anymore. Can only be called by the current owner.
91    *
92    * NOTE: Renouncing ownership will leave the contract without an owner,
93    * thereby removing any functionality that is only available to the owner.
94    */
95   function renounceOwnership() public virtual onlyOwner {
96     emit OwnershipTransferred(_owner, address(0));
97     _owner = address(0);
98   }
99 
100   /**
101    * @dev Transfers ownership of the contract to a new account (`newOwner`).
102    * Can only be called by the current owner.
103    */
104   function transferOwnership(address newOwner) public virtual onlyOwner {
105     require(newOwner != address(0), 'Ownable: new owner is the zero address');
106     emit OwnershipTransferred(_owner, newOwner);
107     _owner = newOwner;
108   }
109 }
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125   /**
126    * @dev Returns the addition of two unsigned integers, reverting on
127    * overflow.
128    *
129    * Counterpart to Solidity's `+` operator.
130    *
131    * Requirements:
132    * - Addition cannot overflow.
133    */
134   function add(uint256 a, uint256 b) internal pure returns (uint256) {
135     uint256 c = a + b;
136     require(c >= a, 'SafeMath: addition overflow');
137 
138     return c;
139   }
140 
141   /**
142    * @dev Returns the subtraction of two unsigned integers, reverting on
143    * overflow (when the result is negative).
144    *
145    * Counterpart to Solidity's `-` operator.
146    *
147    * Requirements:
148    * - Subtraction cannot overflow.
149    */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     return sub(a, b, 'SafeMath: subtraction overflow');
152   }
153 
154   /**
155    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156    * overflow (when the result is negative).
157    *
158    * Counterpart to Solidity's `-` operator.
159    *
160    * Requirements:
161    * - Subtraction cannot overflow.
162    */
163   function sub(
164     uint256 a,
165     uint256 b,
166     string memory errorMessage
167   ) internal pure returns (uint256) {
168     require(b <= a, errorMessage);
169     uint256 c = a - b;
170 
171     return c;
172   }
173 
174   /**
175    * @dev Returns the multiplication of two unsigned integers, reverting on
176    * overflow.
177    *
178    * Counterpart to Solidity's `*` operator.
179    *
180    * Requirements:
181    * - Multiplication cannot overflow.
182    */
183   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185     // benefit is lost if 'b' is also tested.
186     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187     if (a == 0) {
188       return 0;
189     }
190 
191     uint256 c = a * b;
192     require(c / a == b, 'SafeMath: multiplication overflow');
193 
194     return c;
195   }
196 
197   /**
198    * @dev Returns the integer division of two unsigned integers. Reverts on
199    * division by zero. The result is rounded towards zero.
200    *
201    * Counterpart to Solidity's `/` operator. Note: this function uses a
202    * `revert` opcode (which leaves remaining gas untouched) while Solidity
203    * uses an invalid opcode to revert (consuming all remaining gas).
204    *
205    * Requirements:
206    * - The divisor cannot be zero.
207    */
208   function div(uint256 a, uint256 b) internal pure returns (uint256) {
209     return div(a, b, 'SafeMath: division by zero');
210   }
211 
212   /**
213    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214    * division by zero. The result is rounded towards zero.
215    *
216    * Counterpart to Solidity's `/` operator. Note: this function uses a
217    * `revert` opcode (which leaves remaining gas untouched) while Solidity
218    * uses an invalid opcode to revert (consuming all remaining gas).
219    *
220    * Requirements:
221    * - The divisor cannot be zero.
222    */
223   function div(
224     uint256 a,
225     uint256 b,
226     string memory errorMessage
227   ) internal pure returns (uint256) {
228     // Solidity only automatically asserts when dividing by 0
229     require(b > 0, errorMessage);
230     uint256 c = a / b;
231     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233     return c;
234   }
235 
236   /**
237    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238    * Reverts when dividing by zero.
239    *
240    * Counterpart to Solidity's `%` operator. This function uses a `revert`
241    * opcode (which leaves remaining gas untouched) while Solidity uses an
242    * invalid opcode to revert (consuming all remaining gas).
243    *
244    * Requirements:
245    * - The divisor cannot be zero.
246    */
247   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248     return mod(a, b, 'SafeMath: modulo by zero');
249   }
250 
251   /**
252    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253    * Reverts with custom message when dividing by zero.
254    *
255    * Counterpart to Solidity's `%` operator. This function uses a `revert`
256    * opcode (which leaves remaining gas untouched) while Solidity uses an
257    * invalid opcode to revert (consuming all remaining gas).
258    *
259    * Requirements:
260    * - The divisor cannot be zero.
261    */
262   function mod(
263     uint256 a,
264     uint256 b,
265     string memory errorMessage
266   ) internal pure returns (uint256) {
267     require(b != 0, errorMessage);
268     return a % b;
269   }
270 }
271 
272 interface IVotingStrategy {
273   function getVotingPowerAt(address user, uint256 blockNumber) external view returns (uint256);
274 }
275 
276 interface IProposalValidator {
277   /**
278    * @dev Called to validate a proposal (e.g when creating new proposal in Governance)
279    * @param governance Governance Contract
280    * @param user Address of the proposal creator
281    * @param blockNumber Block Number against which to make the test (e.g proposal creation block -1).
282    * @return boolean, true if can be created
283    **/
284   function validateCreatorOfProposal(
285     IAaveGovernanceV2 governance,
286     address user,
287     uint256 blockNumber
288   ) external view returns (bool);
289 
290   /**
291    * @dev Called to validate the cancellation of a proposal
292    * @param governance Governance Contract
293    * @param user Address of the proposal creator
294    * @param blockNumber Block Number against which to make the test (e.g proposal creation block -1).
295    * @return boolean, true if can be cancelled
296    **/
297   function validateProposalCancellation(
298     IAaveGovernanceV2 governance,
299     address user,
300     uint256 blockNumber
301   ) external view returns (bool);
302 
303   /**
304    * @dev Returns whether a user has enough Proposition Power to make a proposal.
305    * @param governance Governance Contract
306    * @param user Address of the user to be challenged.
307    * @param blockNumber Block Number against which to make the challenge.
308    * @return true if user has enough power
309    **/
310   function isPropositionPowerEnough(
311     IAaveGovernanceV2 governance,
312     address user,
313     uint256 blockNumber
314   ) external view returns (bool);
315 
316   /**
317    * @dev Returns the minimum Proposition Power needed to create a proposition.
318    * @param governance Governance Contract
319    * @param blockNumber Blocknumber at which to evaluate
320    * @return minimum Proposition Power needed
321    **/
322   function getMinimumPropositionPowerNeeded(IAaveGovernanceV2 governance, uint256 blockNumber)
323     external
324     view
325     returns (uint256);
326 
327   /**
328    * @dev Returns whether a proposal passed or not
329    * @param governance Governance Contract
330    * @param proposalId Id of the proposal to set
331    * @return true if proposal passed
332    **/
333   function isProposalPassed(IAaveGovernanceV2 governance, uint256 proposalId)
334     external
335     view
336     returns (bool);
337 
338   /**
339    * @dev Check whether a proposal has reached quorum, ie has enough FOR-voting-power
340    * Here quorum is not to understand as number of votes reached, but number of for-votes reached
341    * @param governance Governance Contract
342    * @param proposalId Id of the proposal to verify
343    * @return voting power needed for a proposal to pass
344    **/
345   function isQuorumValid(IAaveGovernanceV2 governance, uint256 proposalId)
346     external
347     view
348     returns (bool);
349 
350   /**
351    * @dev Check whether a proposal has enough extra FOR-votes than AGAINST-votes
352    * FOR VOTES - AGAINST VOTES > VOTE_DIFFERENTIAL * voting supply
353    * @param governance Governance Contract
354    * @param proposalId Id of the proposal to verify
355    * @return true if enough For-Votes
356    **/
357   function isVoteDifferentialValid(IAaveGovernanceV2 governance, uint256 proposalId)
358     external
359     view
360     returns (bool);
361 
362   /**
363    * @dev Calculates the minimum amount of Voting Power needed for a proposal to Pass
364    * @param votingSupply Total number of oustanding voting tokens
365    * @return voting power needed for a proposal to pass
366    **/
367   function getMinimumVotingPowerNeeded(uint256 votingSupply) external view returns (uint256);
368 
369   /**
370    * @dev Get proposition threshold constant value
371    * @return the proposition threshold value (100 <=> 1%)
372    **/
373   function PROPOSITION_THRESHOLD() external view returns (uint256);
374 
375   /**
376    * @dev Get voting duration constant value
377    * @return the voting duration value in seconds
378    **/
379   function VOTING_DURATION() external view returns (uint256);
380 
381   /**
382    * @dev Get the vote differential threshold constant value
383    * to compare with % of for votes/total supply - % of against votes/total supply
384    * @return the vote differential threshold value (100 <=> 1%)
385    **/
386   function VOTE_DIFFERENTIAL() external view returns (uint256);
387 
388   /**
389    * @dev Get quorum threshold constant value
390    * to compare with % of for votes/total supply
391    * @return the quorum threshold value (100 <=> 1%)
392    **/
393   function MINIMUM_QUORUM() external view returns (uint256);
394 
395   /**
396    * @dev precision helper: 100% = 10000
397    * @return one hundred percents with our chosen precision
398    **/
399   function ONE_HUNDRED_WITH_PRECISION() external view returns (uint256);
400 }
401 
402 interface IGovernanceStrategy {
403   /**
404    * @dev Returns the Proposition Power of a user at a specific block number.
405    * @param user Address of the user.
406    * @param blockNumber Blocknumber at which to fetch Proposition Power
407    * @return Power number
408    **/
409   function getPropositionPowerAt(address user, uint256 blockNumber) external view returns (uint256);
410 
411   /**
412    * @dev Returns the total supply of Outstanding Proposition Tokens
413    * @param blockNumber Blocknumber at which to evaluate
414    * @return total supply at blockNumber
415    **/
416   function getTotalPropositionSupplyAt(uint256 blockNumber) external view returns (uint256);
417 
418   /**
419    * @dev Returns the total supply of Outstanding Voting Tokens
420    * @param blockNumber Blocknumber at which to evaluate
421    * @return total supply at blockNumber
422    **/
423   function getTotalVotingSupplyAt(uint256 blockNumber) external view returns (uint256);
424 
425   /**
426    * @dev Returns the Vote Power of a user at a specific block number.
427    * @param user Address of the user.
428    * @param blockNumber Blocknumber at which to fetch Vote Power
429    * @return Vote number
430    **/
431   function getVotingPowerAt(address user, uint256 blockNumber) external view returns (uint256);
432 }
433 
434 interface IExecutorWithTimelock {
435   /**
436    * @dev emitted when a new pending admin is set
437    * @param newPendingAdmin address of the new pending admin
438    **/
439   event NewPendingAdmin(address newPendingAdmin);
440 
441   /**
442    * @dev emitted when a new admin is set
443    * @param newAdmin address of the new admin
444    **/
445   event NewAdmin(address newAdmin);
446 
447   /**
448    * @dev emitted when a new delay (between queueing and execution) is set
449    * @param delay new delay
450    **/
451   event NewDelay(uint256 delay);
452 
453   /**
454    * @dev emitted when a new (trans)action is Queued.
455    * @param actionHash hash of the action
456    * @param target address of the targeted contract
457    * @param value wei value of the transaction
458    * @param signature function signature of the transaction
459    * @param data function arguments of the transaction or callData if signature empty
460    * @param executionTime time at which to execute the transaction
461    * @param withDelegatecall boolean, true = transaction delegatecalls the target, else calls the target
462    **/
463   event QueuedAction(
464     bytes32 actionHash,
465     address indexed target,
466     uint256 value,
467     string signature,
468     bytes data,
469     uint256 executionTime,
470     bool withDelegatecall
471   );
472 
473   /**
474    * @dev emitted when an action is Cancelled
475    * @param actionHash hash of the action
476    * @param target address of the targeted contract
477    * @param value wei value of the transaction
478    * @param signature function signature of the transaction
479    * @param data function arguments of the transaction or callData if signature empty
480    * @param executionTime time at which to execute the transaction
481    * @param withDelegatecall boolean, true = transaction delegatecalls the target, else calls the target
482    **/
483   event CancelledAction(
484     bytes32 actionHash,
485     address indexed target,
486     uint256 value,
487     string signature,
488     bytes data,
489     uint256 executionTime,
490     bool withDelegatecall
491   );
492 
493   /**
494    * @dev emitted when an action is Cancelled
495    * @param actionHash hash of the action
496    * @param target address of the targeted contract
497    * @param value wei value of the transaction
498    * @param signature function signature of the transaction
499    * @param data function arguments of the transaction or callData if signature empty
500    * @param executionTime time at which to execute the transaction
501    * @param withDelegatecall boolean, true = transaction delegatecalls the target, else calls the target
502    * @param resultData the actual callData used on the target
503    **/
504   event ExecutedAction(
505     bytes32 actionHash,
506     address indexed target,
507     uint256 value,
508     string signature,
509     bytes data,
510     uint256 executionTime,
511     bool withDelegatecall,
512     bytes resultData
513   );
514 
515   /**
516    * @dev Getter of the current admin address (should be governance)
517    * @return The address of the current admin
518    **/
519   function getAdmin() external view returns (address);
520 
521   /**
522    * @dev Getter of the current pending admin address
523    * @return The address of the pending admin
524    **/
525   function getPendingAdmin() external view returns (address);
526 
527   /**
528    * @dev Getter of the delay between queuing and execution
529    * @return The delay in seconds
530    **/
531   function getDelay() external view returns (uint256);
532 
533   /**
534    * @dev Returns whether an action (via actionHash) is queued
535    * @param actionHash hash of the action to be checked
536    * keccak256(abi.encode(target, value, signature, data, executionTime, withDelegatecall))
537    * @return true if underlying action of actionHash is queued
538    **/
539   function isActionQueued(bytes32 actionHash) external view returns (bool);
540 
541   /**
542    * @dev Checks whether a proposal is over its grace period
543    * @param governance Governance contract
544    * @param proposalId Id of the proposal against which to test
545    * @return true of proposal is over grace period
546    **/
547   function isProposalOverGracePeriod(IAaveGovernanceV2 governance, uint256 proposalId)
548     external
549     view
550     returns (bool);
551 
552   /**
553    * @dev Getter of grace period constant
554    * @return grace period in seconds
555    **/
556   function GRACE_PERIOD() external view returns (uint256);
557 
558   /**
559    * @dev Getter of minimum delay constant
560    * @return minimum delay in seconds
561    **/
562   function MINIMUM_DELAY() external view returns (uint256);
563 
564   /**
565    * @dev Getter of maximum delay constant
566    * @return maximum delay in seconds
567    **/
568   function MAXIMUM_DELAY() external view returns (uint256);
569 
570   /**
571    * @dev Function, called by Governance, that queue a transaction, returns action hash
572    * @param target smart contract target
573    * @param value wei value of the transaction
574    * @param signature function signature of the transaction
575    * @param data function arguments of the transaction or callData if signature empty
576    * @param executionTime time at which to execute the transaction
577    * @param withDelegatecall boolean, true = transaction delegatecalls the target, else calls the target
578    **/
579   function queueTransaction(
580     address target,
581     uint256 value,
582     string memory signature,
583     bytes memory data,
584     uint256 executionTime,
585     bool withDelegatecall
586   ) external returns (bytes32);
587 
588   /**
589    * @dev Function, called by Governance, that cancels a transaction, returns the callData executed
590    * @param target smart contract target
591    * @param value wei value of the transaction
592    * @param signature function signature of the transaction
593    * @param data function arguments of the transaction or callData if signature empty
594    * @param executionTime time at which to execute the transaction
595    * @param withDelegatecall boolean, true = transaction delegatecalls the target, else calls the target
596    **/
597   function executeTransaction(
598     address target,
599     uint256 value,
600     string memory signature,
601     bytes memory data,
602     uint256 executionTime,
603     bool withDelegatecall
604   ) external payable returns (bytes memory);
605 
606   /**
607    * @dev Function, called by Governance, that cancels a transaction, returns action hash
608    * @param target smart contract target
609    * @param value wei value of the transaction
610    * @param signature function signature of the transaction
611    * @param data function arguments of the transaction or callData if signature empty
612    * @param executionTime time at which to execute the transaction
613    * @param withDelegatecall boolean, true = transaction delegatecalls the target, else calls the target
614    **/
615   function cancelTransaction(
616     address target,
617     uint256 value,
618     string memory signature,
619     bytes memory data,
620     uint256 executionTime,
621     bool withDelegatecall
622   ) external returns (bytes32);
623 }
624 
625 interface IAaveGovernanceV2 {
626   enum ProposalState {Pending, Canceled, Active, Failed, Succeeded, Queued, Expired, Executed}
627 
628   struct Vote {
629     bool support;
630     uint248 votingPower;
631   }
632 
633   struct Proposal {
634     uint256 id;
635     address creator;
636     IExecutorWithTimelock executor;
637     address[] targets;
638     uint256[] values;
639     string[] signatures;
640     bytes[] calldatas;
641     bool[] withDelegatecalls;
642     uint256 startBlock;
643     uint256 endBlock;
644     uint256 executionTime;
645     uint256 forVotes;
646     uint256 againstVotes;
647     bool executed;
648     bool canceled;
649     address strategy;
650     bytes32 ipfsHash;
651     mapping(address => Vote) votes;
652   }
653 
654   struct ProposalWithoutVotes {
655     uint256 id;
656     address creator;
657     IExecutorWithTimelock executor;
658     address[] targets;
659     uint256[] values;
660     string[] signatures;
661     bytes[] calldatas;
662     bool[] withDelegatecalls;
663     uint256 startBlock;
664     uint256 endBlock;
665     uint256 executionTime;
666     uint256 forVotes;
667     uint256 againstVotes;
668     bool executed;
669     bool canceled;
670     address strategy;
671     bytes32 ipfsHash;
672   }
673 
674   /**
675    * @dev emitted when a new proposal is created
676    * @param id Id of the proposal
677    * @param creator address of the creator
678    * @param executor The ExecutorWithTimelock contract that will execute the proposal
679    * @param targets list of contracts called by proposal's associated transactions
680    * @param values list of value in wei for each propoposal's associated transaction
681    * @param signatures list of function signatures (can be empty) to be used when created the callData
682    * @param calldatas list of calldatas: if associated signature empty, calldata ready, else calldata is arguments
683    * @param withDelegatecalls boolean, true = transaction delegatecalls the taget, else calls the target
684    * @param startBlock block number when vote starts
685    * @param endBlock block number when vote ends
686    * @param strategy address of the governanceStrategy contract
687    * @param ipfsHash IPFS hash of the proposal
688    **/
689   event ProposalCreated(
690     uint256 id,
691     address indexed creator,
692     IExecutorWithTimelock indexed executor,
693     address[] targets,
694     uint256[] values,
695     string[] signatures,
696     bytes[] calldatas,
697     bool[] withDelegatecalls,
698     uint256 startBlock,
699     uint256 endBlock,
700     address strategy,
701     bytes32 ipfsHash
702   );
703 
704   /**
705    * @dev emitted when a proposal is canceled
706    * @param id Id of the proposal
707    **/
708   event ProposalCanceled(uint256 id);
709 
710   /**
711    * @dev emitted when a proposal is queued
712    * @param id Id of the proposal
713    * @param executionTime time when proposal underlying transactions can be executed
714    * @param initiatorQueueing address of the initiator of the queuing transaction
715    **/
716   event ProposalQueued(uint256 id, uint256 executionTime, address indexed initiatorQueueing);
717   /**
718    * @dev emitted when a proposal is executed
719    * @param id Id of the proposal
720    * @param initiatorExecution address of the initiator of the execution transaction
721    **/
722   event ProposalExecuted(uint256 id, address indexed initiatorExecution);
723   /**
724    * @dev emitted when a vote is registered
725    * @param id Id of the proposal
726    * @param voter address of the voter
727    * @param support boolean, true = vote for, false = vote against
728    * @param votingPower Power of the voter/vote
729    **/
730   event VoteEmitted(uint256 id, address indexed voter, bool support, uint256 votingPower);
731 
732   event GovernanceStrategyChanged(address indexed newStrategy, address indexed initiatorChange);
733 
734   event VotingDelayChanged(uint256 newVotingDelay, address indexed initiatorChange);
735 
736   event ExecutorAuthorized(address executor);
737 
738   event ExecutorUnauthorized(address executor);
739 
740   /**
741    * @dev Creates a Proposal (needs Proposition Power of creator > Threshold)
742    * @param executor The ExecutorWithTimelock contract that will execute the proposal
743    * @param targets list of contracts called by proposal's associated transactions
744    * @param values list of value in wei for each propoposal's associated transaction
745    * @param signatures list of function signatures (can be empty) to be used when created the callData
746    * @param calldatas list of calldatas: if associated signature empty, calldata ready, else calldata is arguments
747    * @param withDelegatecalls if true, transaction delegatecalls the taget, else calls the target
748    * @param ipfsHash IPFS hash of the proposal
749    **/
750   function create(
751     IExecutorWithTimelock executor,
752     address[] memory targets,
753     uint256[] memory values,
754     string[] memory signatures,
755     bytes[] memory calldatas,
756     bool[] memory withDelegatecalls,
757     bytes32 ipfsHash
758   ) external returns (uint256);
759 
760   /**
761    * @dev Cancels a Proposal,
762    * either at anytime by guardian
763    * or when proposal is Pending/Active and threshold no longer reached
764    * @param proposalId id of the proposal
765    **/
766   function cancel(uint256 proposalId) external;
767 
768   /**
769    * @dev Queue the proposal (If Proposal Succeeded)
770    * @param proposalId id of the proposal to queue
771    **/
772   function queue(uint256 proposalId) external;
773 
774   /**
775    * @dev Execute the proposal (If Proposal Queued)
776    * @param proposalId id of the proposal to execute
777    **/
778   function execute(uint256 proposalId) external payable;
779 
780   /**
781    * @dev Function allowing msg.sender to vote for/against a proposal
782    * @param proposalId id of the proposal
783    * @param support boolean, true = vote for, false = vote against
784    **/
785   function submitVote(uint256 proposalId, bool support) external;
786 
787   /**
788    * @dev Function to register the vote of user that has voted offchain via signature
789    * @param proposalId id of the proposal
790    * @param support boolean, true = vote for, false = vote against
791    * @param v v part of the voter signature
792    * @param r r part of the voter signature
793    * @param s s part of the voter signature
794    **/
795   function submitVoteBySignature(
796     uint256 proposalId,
797     bool support,
798     uint8 v,
799     bytes32 r,
800     bytes32 s
801   ) external;
802 
803   /**
804    * @dev Set new GovernanceStrategy
805    * Note: owner should be a timelocked executor, so needs to make a proposal
806    * @param governanceStrategy new Address of the GovernanceStrategy contract
807    **/
808   function setGovernanceStrategy(address governanceStrategy) external;
809 
810   /**
811    * @dev Set new Voting Delay (delay before a newly created proposal can be voted on)
812    * Note: owner should be a timelocked executor, so needs to make a proposal
813    * @param votingDelay new voting delay in seconds
814    **/
815   function setVotingDelay(uint256 votingDelay) external;
816 
817   /**
818    * @dev Add new addresses to the list of authorized executors
819    * @param executors list of new addresses to be authorized executors
820    **/
821   function authorizeExecutors(address[] memory executors) external;
822 
823   /**
824    * @dev Remove addresses to the list of authorized executors
825    * @param executors list of addresses to be removed as authorized executors
826    **/
827   function unauthorizeExecutors(address[] memory executors) external;
828 
829   /**
830    * @dev Let the guardian abdicate from its priviledged rights
831    **/
832   function __abdicate() external;
833 
834   /**
835    * @dev Getter of the current GovernanceStrategy address
836    * @return The address of the current GovernanceStrategy contracts
837    **/
838   function getGovernanceStrategy() external view returns (address);
839 
840   /**
841    * @dev Getter of the current Voting Delay (delay before a created proposal can be voted on)
842    * Different from the voting duration
843    * @return The voting delay in seconds
844    **/
845   function getVotingDelay() external view returns (uint256);
846 
847   /**
848    * @dev Returns whether an address is an authorized executor
849    * @param executor address to evaluate as authorized executor
850    * @return true if authorized
851    **/
852   function isExecutorAuthorized(address executor) external view returns (bool);
853 
854   /**
855    * @dev Getter the address of the guardian, that can mainly cancel proposals
856    * @return The address of the guardian
857    **/
858   function getGuardian() external view returns (address);
859 
860   /**
861    * @dev Getter of the proposal count (the current number of proposals ever created)
862    * @return the proposal count
863    **/
864   function getProposalsCount() external view returns (uint256);
865 
866   /**
867    * @dev Getter of a proposal by id
868    * @param proposalId id of the proposal to get
869    * @return the proposal as ProposalWithoutVotes memory object
870    **/
871   function getProposalById(uint256 proposalId) external view returns (ProposalWithoutVotes memory);
872 
873   /**
874    * @dev Getter of the Vote of a voter about a proposal
875    * Note: Vote is a struct: ({bool support, uint248 votingPower})
876    * @param proposalId id of the proposal
877    * @param voter address of the voter
878    * @return The associated Vote memory object
879    **/
880   function getVoteOnProposal(uint256 proposalId, address voter) external view returns (Vote memory);
881 
882   /**
883    * @dev Get the current state of a proposal
884    * @param proposalId id of the proposal
885    * @return The current state if the proposal
886    **/
887   function getProposalState(uint256 proposalId) external view returns (ProposalState);
888 }
889 
890 /**
891  * @title Governance V2 contract
892  * @dev Main point of interaction with Aave protocol's governance
893  * - Create a Proposal
894  * - Cancel a Proposal
895  * - Queue a Proposal
896  * - Execute a Proposal
897  * - Submit Vote to a Proposal
898  * Proposal States : Pending => Active => Succeeded(/Failed) => Queued => Executed(/Expired)
899  *                   The transition to "Canceled" can appear in multiple states
900  * @author Aave
901  **/
902 contract AaveGovernanceV2 is Ownable, IAaveGovernanceV2 {
903   using SafeMath for uint256;
904 
905   address private _governanceStrategy;
906   uint256 private _votingDelay;
907 
908   uint256 private _proposalsCount;
909   mapping(uint256 => Proposal) private _proposals;
910   mapping(address => bool) private _authorizedExecutors;
911 
912   address private _guardian;
913 
914   bytes32 public constant DOMAIN_TYPEHASH = keccak256(
915     'EIP712Domain(string name,uint256 chainId,address verifyingContract)'
916   );
917   bytes32 public constant VOTE_EMITTED_TYPEHASH = keccak256('VoteEmitted(uint256 id,bool support)');
918   string public constant NAME = 'Aave Governance v2';
919 
920   modifier onlyGuardian() {
921     require(msg.sender == _guardian, 'ONLY_BY_GUARDIAN');
922     _;
923   }
924 
925   constructor(
926     address governanceStrategy,
927     uint256 votingDelay,
928     address guardian,
929     address[] memory executors
930   ) {
931     _setGovernanceStrategy(governanceStrategy);
932     _setVotingDelay(votingDelay);
933     _guardian = guardian;
934 
935     authorizeExecutors(executors);
936   }
937 
938   struct CreateVars {
939     uint256 startBlock;
940     uint256 endBlock;
941     uint256 previousProposalsCount;
942   }
943 
944   /**
945    * @dev Creates a Proposal (needs to be validated by the Proposal Validator)
946    * @param executor The ExecutorWithTimelock contract that will execute the proposal
947    * @param targets list of contracts called by proposal's associated transactions
948    * @param values list of value in wei for each propoposal's associated transaction
949    * @param signatures list of function signatures (can be empty) to be used when created the callData
950    * @param calldatas list of calldatas: if associated signature empty, calldata ready, else calldata is arguments
951    * @param withDelegatecalls boolean, true = transaction delegatecalls the taget, else calls the target
952    * @param ipfsHash IPFS hash of the proposal
953    **/
954   function create(
955     IExecutorWithTimelock executor,
956     address[] memory targets,
957     uint256[] memory values,
958     string[] memory signatures,
959     bytes[] memory calldatas,
960     bool[] memory withDelegatecalls,
961     bytes32 ipfsHash
962   ) external override returns (uint256) {
963     require(targets.length != 0, 'INVALID_EMPTY_TARGETS');
964     require(
965       targets.length == values.length &&
966         targets.length == signatures.length &&
967         targets.length == calldatas.length &&
968         targets.length == withDelegatecalls.length,
969       'INCONSISTENT_PARAMS_LENGTH'
970     );
971 
972     require(isExecutorAuthorized(address(executor)), 'EXECUTOR_NOT_AUTHORIZED');
973 
974     require(
975       IProposalValidator(address(executor)).validateCreatorOfProposal(
976         this,
977         msg.sender,
978         block.number - 1
979       ),
980       'PROPOSITION_CREATION_INVALID'
981     );
982 
983     CreateVars memory vars;
984 
985     vars.startBlock = block.number.add(_votingDelay);
986     vars.endBlock = vars.startBlock.add(IProposalValidator(address(executor)).VOTING_DURATION());
987 
988     vars.previousProposalsCount = _proposalsCount;
989 
990     Proposal storage newProposal = _proposals[vars.previousProposalsCount];
991     newProposal.id = vars.previousProposalsCount;
992     newProposal.creator = msg.sender;
993     newProposal.executor = executor;
994     newProposal.targets = targets;
995     newProposal.values = values;
996     newProposal.signatures = signatures;
997     newProposal.calldatas = calldatas;
998     newProposal.withDelegatecalls = withDelegatecalls;
999     newProposal.startBlock = vars.startBlock;
1000     newProposal.endBlock = vars.endBlock;
1001     newProposal.strategy = _governanceStrategy;
1002     newProposal.ipfsHash = ipfsHash;
1003     _proposalsCount++;
1004 
1005     emit ProposalCreated(
1006       vars.previousProposalsCount,
1007       msg.sender,
1008       executor,
1009       targets,
1010       values,
1011       signatures,
1012       calldatas,
1013       withDelegatecalls,
1014       vars.startBlock,
1015       vars.endBlock,
1016       _governanceStrategy,
1017       ipfsHash
1018     );
1019 
1020     return newProposal.id;
1021   }
1022 
1023   /**
1024    * @dev Cancels a Proposal.
1025    * - Callable by the _guardian with relaxed conditions, or by anybody if the conditions of
1026    *   cancellation on the executor are fulfilled
1027    * @param proposalId id of the proposal
1028    **/
1029   function cancel(uint256 proposalId) external override {
1030     ProposalState state = getProposalState(proposalId);
1031     require(
1032       state != ProposalState.Executed &&
1033         state != ProposalState.Canceled &&
1034         state != ProposalState.Expired,
1035       'ONLY_BEFORE_EXECUTED'
1036     );
1037 
1038     Proposal storage proposal = _proposals[proposalId];
1039     require(
1040       msg.sender == _guardian ||
1041         IProposalValidator(address(proposal.executor)).validateProposalCancellation(
1042           this,
1043           proposal.creator,
1044           block.number - 1
1045         ),
1046       'PROPOSITION_CANCELLATION_INVALID'
1047     );
1048     proposal.canceled = true;
1049     for (uint256 i = 0; i < proposal.targets.length; i++) {
1050       proposal.executor.cancelTransaction(
1051         proposal.targets[i],
1052         proposal.values[i],
1053         proposal.signatures[i],
1054         proposal.calldatas[i],
1055         proposal.executionTime,
1056         proposal.withDelegatecalls[i]
1057       );
1058     }
1059 
1060     emit ProposalCanceled(proposalId);
1061   }
1062 
1063   /**
1064    * @dev Queue the proposal (If Proposal Succeeded)
1065    * @param proposalId id of the proposal to queue
1066    **/
1067   function queue(uint256 proposalId) external override {
1068     require(getProposalState(proposalId) == ProposalState.Succeeded, 'INVALID_STATE_FOR_QUEUE');
1069     Proposal storage proposal = _proposals[proposalId];
1070     uint256 executionTime = block.timestamp.add(proposal.executor.getDelay());
1071     for (uint256 i = 0; i < proposal.targets.length; i++) {
1072       _queueOrRevert(
1073         proposal.executor,
1074         proposal.targets[i],
1075         proposal.values[i],
1076         proposal.signatures[i],
1077         proposal.calldatas[i],
1078         executionTime,
1079         proposal.withDelegatecalls[i]
1080       );
1081     }
1082     proposal.executionTime = executionTime;
1083 
1084     emit ProposalQueued(proposalId, executionTime, msg.sender);
1085   }
1086 
1087   /**
1088    * @dev Execute the proposal (If Proposal Queued)
1089    * @param proposalId id of the proposal to execute
1090    **/
1091   function execute(uint256 proposalId) external payable override {
1092     require(getProposalState(proposalId) == ProposalState.Queued, 'ONLY_QUEUED_PROPOSALS');
1093     Proposal storage proposal = _proposals[proposalId];
1094     proposal.executed = true;
1095     for (uint256 i = 0; i < proposal.targets.length; i++) {
1096       proposal.executor.executeTransaction{value: proposal.values[i]}(
1097         proposal.targets[i],
1098         proposal.values[i],
1099         proposal.signatures[i],
1100         proposal.calldatas[i],
1101         proposal.executionTime,
1102         proposal.withDelegatecalls[i]
1103       );
1104     }
1105     emit ProposalExecuted(proposalId, msg.sender);
1106   }
1107 
1108   /**
1109    * @dev Function allowing msg.sender to vote for/against a proposal
1110    * @param proposalId id of the proposal
1111    * @param support boolean, true = vote for, false = vote against
1112    **/
1113   function submitVote(uint256 proposalId, bool support) external override {
1114     return _submitVote(msg.sender, proposalId, support);
1115   }
1116 
1117   /**
1118    * @dev Function to register the vote of user that has voted offchain via signature
1119    * @param proposalId id of the proposal
1120    * @param support boolean, true = vote for, false = vote against
1121    * @param v v part of the voter signature
1122    * @param r r part of the voter signature
1123    * @param s s part of the voter signature
1124    **/
1125   function submitVoteBySignature(
1126     uint256 proposalId,
1127     bool support,
1128     uint8 v,
1129     bytes32 r,
1130     bytes32 s
1131   ) external override {
1132     bytes32 digest = keccak256(
1133       abi.encodePacked(
1134         '\x19\x01',
1135         keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(NAME)), getChainId(), address(this))),
1136         keccak256(abi.encode(VOTE_EMITTED_TYPEHASH, proposalId, support))
1137       )
1138     );
1139     address signer = ecrecover(digest, v, r, s);
1140     require(signer != address(0), 'INVALID_SIGNATURE');
1141     return _submitVote(signer, proposalId, support);
1142   }
1143 
1144   /**
1145    * @dev Set new GovernanceStrategy
1146    * Note: owner should be a timelocked executor, so needs to make a proposal
1147    * @param governanceStrategy new Address of the GovernanceStrategy contract
1148    **/
1149   function setGovernanceStrategy(address governanceStrategy) external override onlyOwner {
1150     _setGovernanceStrategy(governanceStrategy);
1151   }
1152 
1153   /**
1154    * @dev Set new Voting Delay (delay before a newly created proposal can be voted on)
1155    * Note: owner should be a timelocked executor, so needs to make a proposal
1156    * @param votingDelay new voting delay in terms of blocks
1157    **/
1158   function setVotingDelay(uint256 votingDelay) external override onlyOwner {
1159     _setVotingDelay(votingDelay);
1160   }
1161 
1162   /**
1163    * @dev Add new addresses to the list of authorized executors
1164    * @param executors list of new addresses to be authorized executors
1165    **/
1166   function authorizeExecutors(address[] memory executors) public override onlyOwner {
1167     for (uint256 i = 0; i < executors.length; i++) {
1168       _authorizeExecutor(executors[i]);
1169     }
1170   }
1171 
1172   /**
1173    * @dev Remove addresses to the list of authorized executors
1174    * @param executors list of addresses to be removed as authorized executors
1175    **/
1176   function unauthorizeExecutors(address[] memory executors) public override onlyOwner {
1177     for (uint256 i = 0; i < executors.length; i++) {
1178       _unauthorizeExecutor(executors[i]);
1179     }
1180   }
1181 
1182   /**
1183    * @dev Let the guardian abdicate from its priviledged rights
1184    **/
1185   function __abdicate() external override onlyGuardian {
1186     _guardian = address(0);
1187   }
1188 
1189   /**
1190    * @dev Getter of the current GovernanceStrategy address
1191    * @return The address of the current GovernanceStrategy contracts
1192    **/
1193   function getGovernanceStrategy() external view override returns (address) {
1194     return _governanceStrategy;
1195   }
1196 
1197   /**
1198    * @dev Getter of the current Voting Delay (delay before a created proposal can be voted on)
1199    * Different from the voting duration
1200    * @return The voting delay in number of blocks
1201    **/
1202   function getVotingDelay() external view override returns (uint256) {
1203     return _votingDelay;
1204   }
1205 
1206   /**
1207    * @dev Returns whether an address is an authorized executor
1208    * @param executor address to evaluate as authorized executor
1209    * @return true if authorized
1210    **/
1211   function isExecutorAuthorized(address executor) public view override returns (bool) {
1212     return _authorizedExecutors[executor];
1213   }
1214 
1215   /**
1216    * @dev Getter the address of the guardian, that can mainly cancel proposals
1217    * @return The address of the guardian
1218    **/
1219   function getGuardian() external view override returns (address) {
1220     return _guardian;
1221   }
1222 
1223   /**
1224    * @dev Getter of the proposal count (the current number of proposals ever created)
1225    * @return the proposal count
1226    **/
1227   function getProposalsCount() external view override returns (uint256) {
1228     return _proposalsCount;
1229   }
1230 
1231   /**
1232    * @dev Getter of a proposal by id
1233    * @param proposalId id of the proposal to get
1234    * @return the proposal as ProposalWithoutVotes memory object
1235    **/
1236   function getProposalById(uint256 proposalId)
1237     external
1238     view
1239     override
1240     returns (ProposalWithoutVotes memory)
1241   {
1242     Proposal storage proposal = _proposals[proposalId];
1243     ProposalWithoutVotes memory proposalWithoutVotes = ProposalWithoutVotes({
1244       id: proposal.id,
1245       creator: proposal.creator,
1246       executor: proposal.executor,
1247       targets: proposal.targets,
1248       values: proposal.values,
1249       signatures: proposal.signatures,
1250       calldatas: proposal.calldatas,
1251       withDelegatecalls: proposal.withDelegatecalls,
1252       startBlock: proposal.startBlock,
1253       endBlock: proposal.endBlock,
1254       executionTime: proposal.executionTime,
1255       forVotes: proposal.forVotes,
1256       againstVotes: proposal.againstVotes,
1257       executed: proposal.executed,
1258       canceled: proposal.canceled,
1259       strategy: proposal.strategy,
1260       ipfsHash: proposal.ipfsHash
1261     });
1262 
1263     return proposalWithoutVotes;
1264   }
1265 
1266   /**
1267    * @dev Getter of the Vote of a voter about a proposal
1268    * Note: Vote is a struct: ({bool support, uint248 votingPower})
1269    * @param proposalId id of the proposal
1270    * @param voter address of the voter
1271    * @return The associated Vote memory object
1272    **/
1273   function getVoteOnProposal(uint256 proposalId, address voter)
1274     external
1275     view
1276     override
1277     returns (Vote memory)
1278   {
1279     return _proposals[proposalId].votes[voter];
1280   }
1281 
1282   /**
1283    * @dev Get the current state of a proposal
1284    * @param proposalId id of the proposal
1285    * @return The current state if the proposal
1286    **/
1287   function getProposalState(uint256 proposalId) public view override returns (ProposalState) {
1288     require(_proposalsCount >= proposalId, 'INVALID_PROPOSAL_ID');
1289     Proposal storage proposal = _proposals[proposalId];
1290     if (proposal.canceled) {
1291       return ProposalState.Canceled;
1292     } else if (block.number <= proposal.startBlock) {
1293       return ProposalState.Pending;
1294     } else if (block.number <= proposal.endBlock) {
1295       return ProposalState.Active;
1296     } else if (!IProposalValidator(address(proposal.executor)).isProposalPassed(this, proposalId)) {
1297       return ProposalState.Failed;
1298     } else if (proposal.executionTime == 0) {
1299       return ProposalState.Succeeded;
1300     } else if (proposal.executed) {
1301       return ProposalState.Executed;
1302     } else if (proposal.executor.isProposalOverGracePeriod(this, proposalId)) {
1303       return ProposalState.Expired;
1304     } else {
1305       return ProposalState.Queued;
1306     }
1307   }
1308 
1309   function _queueOrRevert(
1310     IExecutorWithTimelock executor,
1311     address target,
1312     uint256 value,
1313     string memory signature,
1314     bytes memory callData,
1315     uint256 executionTime,
1316     bool withDelegatecall
1317   ) internal {
1318     require(
1319       !executor.isActionQueued(
1320         keccak256(abi.encode(target, value, signature, callData, executionTime, withDelegatecall))
1321       ),
1322       'DUPLICATED_ACTION'
1323     );
1324     executor.queueTransaction(target, value, signature, callData, executionTime, withDelegatecall);
1325   }
1326 
1327   function _submitVote(
1328     address voter,
1329     uint256 proposalId,
1330     bool support
1331   ) internal {
1332     require(getProposalState(proposalId) == ProposalState.Active, 'VOTING_CLOSED');
1333     Proposal storage proposal = _proposals[proposalId];
1334     Vote storage vote = proposal.votes[voter];
1335 
1336     require(vote.votingPower == 0, 'VOTE_ALREADY_SUBMITTED');
1337 
1338     uint256 votingPower = IVotingStrategy(proposal.strategy).getVotingPowerAt(
1339       voter,
1340       proposal.startBlock
1341     );
1342 
1343     if (support) {
1344       proposal.forVotes = proposal.forVotes.add(votingPower);
1345     } else {
1346       proposal.againstVotes = proposal.againstVotes.add(votingPower);
1347     }
1348 
1349     vote.support = support;
1350     vote.votingPower = uint248(votingPower);
1351 
1352     emit VoteEmitted(proposalId, voter, support, votingPower);
1353   }
1354 
1355   function _setGovernanceStrategy(address governanceStrategy) internal {
1356     _governanceStrategy = governanceStrategy;
1357 
1358     emit GovernanceStrategyChanged(governanceStrategy, msg.sender);
1359   }
1360 
1361   function _setVotingDelay(uint256 votingDelay) internal {
1362     _votingDelay = votingDelay;
1363 
1364     emit VotingDelayChanged(votingDelay, msg.sender);
1365   }
1366 
1367   function _authorizeExecutor(address executor) internal {
1368     _authorizedExecutors[executor] = true;
1369     emit ExecutorAuthorized(executor);
1370   }
1371 
1372   function _unauthorizeExecutor(address executor) internal {
1373     _authorizedExecutors[executor] = false;
1374     emit ExecutorUnauthorized(executor);
1375   }
1376 }