1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {ReentrancyGuard} from "solmate/utils/ReentrancyGuard.sol";
5 import {ERC20} from "solmate/tokens/ERC20.sol";
6 import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
7 import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";
8 import {UpxEth} from "./tokens/UpxEth.sol";
9 import {Errors} from "./libraries/Errors.sol";
10 import {DataTypes} from "./libraries/DataTypes.sol";
11 import {ValidatorQueue} from "./libraries/ValidatorQueue.sol";
12 import {IOracleAdapter} from "./interfaces/IOracleAdapter.sol";
13 import {IPirexEth} from "./interfaces/IPirexEth.sol";
14 import {IDepositContract} from "./interfaces/IDepositContract.sol";
15 import {AutoPxEth} from "./AutoPxEth.sol";
16 import {PxEth} from "./PxEth.sol";
17 
18 /**
19  * @title  PirexEthValidators
20  * @notice Manages validators and deposits for the Eth2.0 deposit contract
21  * @dev    This contract includes functionality for handling validator-related operations and deposits.
22  * @author redactedcartel.finance
23  */
24 abstract contract PirexEthValidators is
25     ReentrancyGuard,
26     AccessControlDefaultAdminRules,
27     IPirexEth
28 {
29     /**
30      * @dev This library provides enhanced safety features for ERC20 token transfers, reducing the risk of common vulnerabilities.
31      */
32     using ValidatorQueue for DataTypes.ValidatorDeque;
33     /**
34      * @dev This library extends the functionality of the DataTypes.ValidatorDeque data structure to facilitate validator management.
35      */
36     using SafeTransferLib for ERC20;
37 
38     /**
39      * @notice Denominator used for mathematical calculations.
40      * @dev    This constant is used as a divisor in various mathematical calculations
41      *         throughout the contract to achieve precise percentages and ratios.
42      */
43     uint256 internal constant DENOMINATOR = 1_000_000;
44 
45     // Roles
46     /**
47      * @notice The role assigned to external keepers responsible for specific protocol functions.
48      * @dev    This role is assigned to external entities that are responsible for performing specific
49      *         functions within the protocol, such as validator upkeep and maintenance.
50      */
51     bytes32 internal constant KEEPER_ROLE = keccak256("KEEPER_ROLE");
52 
53     /**
54      * @notice The role assigned to governance entities responsible for managing protocol parameters.
55      * @dev    This role is assigned to governance entities that have the authority to manage and
56      *         update various protocol parameters, ensuring the smooth operation and evolution of the protocol.
57      */
58     bytes32 internal constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");
59 
60     /**
61      * @notice Paused status indicator when depositing Ether is not paused.
62      * @dev    This constant represents the status indicator when depositing Ether is not paused.
63      *         It is used as a reference for the depositEtherPaused state variable to determine whether
64      *         depositing Ether is currently allowed or paused.
65      */
66     uint256 internal constant _NOT_PAUSED = 1;
67 
68     /**
69      * @notice Paused status indicator when depositing Ether is paused.
70      * @dev    This constant represents the status indicator when depositing Ether is paused.
71      *         It is used as a reference for the depositEtherPaused state variable to determine
72      *         whether depositing Ether is currently allowed or paused.
73      */
74     uint256 internal constant _PAUSED = 2;
75 
76     /**
77      * @notice The address of the external beacon chain deposit contract.
78      * @dev    This variable holds the immutable address of the external beacon chain deposit contract.
79      *         It is used to interact with the contract for depositing validators to the Ethereum 2.0 beacon chain.
80      */
81     address public immutable beaconChainDepositContract;
82 
83     /**
84      * @notice The amount of Ether that a validator must deposit before being added to the initialized validator queue.
85      * @dev    This variable represents the immutable pre-deposit amount required for a validator to be added to the initialized validator queue.
86      *         Validators need to deposit this amount of Ether to be put in initialized validator queue.
87      */
88     uint256 public immutable preDepositAmount;
89 
90     /**
91      * @notice The default deposit size for validators, set once during contract initialization.
92      * @dev    This variable represents the immutable default deposit size for validators.
93      *         It is set during the contract initialization and represents the amount of Ether a validator needs to deposit
94      *         to participate in the Ethereum 2.0 staking process.
95      */
96     uint256 public immutable DEPOSIT_SIZE;
97 
98     /**
99      * @notice The withdrawal credentials used when processing validator withdrawals.
100      * @dev    This variable holds the withdrawal credentials, which are used to receive valdiator rewards
101      */
102     bytes public withdrawalCredentials;
103 
104     /**
105      * @notice Buffer for instant withdrawals and emergency top-ups.
106      * @dev    This variable represents the buffer amount,
107      *         which is utilized for immediate withdrawals and emergency top-ups.
108      *         It serves as a reserve to facilitate rapid withdrawals or cover unexpected events within the protocol.
109      */
110     uint256 public buffer;
111 
112     /**
113      * @notice Maximum buffer size for instant withdrawals and emergency top-ups.
114      * @dev    This variable represents the upper limit for the buffer size,
115      *         determining the maximum amount that can be reserved for immediate withdrawals,
116      *         and emergency top-ups in the protocol.
117      */
118     uint256 public maxBufferSize;
119 
120     /**
121      * @notice Percentage of pxEth total supply allocated to determine the max buffer size.
122      * @dev    This variable represents the percentage of the total supply of pxEth that is allocated
123      *         to determine the maximum buffer size. It influences the dynamic adjustment of the buffer
124      *         size based on the total supply of pxEth in the protocol.
125      */
126     uint256 public maxBufferSizePct;
127 
128     /**
129      * @notice Maximum count of validators to be processed in a single `_deposit` call.
130      * @dev    This variable determines the maximum number of validators that can be processed in a single call to the `_deposit` function.
131      *         It helps control the efficiency and gas cost of the depositing process.
132      */
133     uint256 public maxProcessedValidatorCount = 20;
134 
135     // Pirex contracts
136     /**
137      * @notice The UpxEth contract responsible for managing the upxEth token.
138      * @dev    This variable holds the address of the UpxEth contract,
139      *         which represents pending redemption.
140      */
141     UpxEth public upxEth;
142 
143     /**
144      * @notice The PxEth contract responsible for managing the pxEth token.
145      * @dev    This variable holds the address of the PxEth contract,
146      *         which represents ETH deposit made to Dinero protocol.
147      */
148     PxEth public pxEth;
149 
150     /**
151      * @notice The AutoPxEth contract responsible for automated management of the pxEth token.
152      * @dev    This variable holds the address of the AutoPxEth contract,
153      *         which represents pxEth deposit to auto compounding vault.
154      */
155     AutoPxEth public autoPxEth;
156 
157     /**
158      * @notice The OracleAdapter contract responsible for interfacing with the oracle for protocol data.
159      * @dev    This variable holds the address of the OracleAdapter contract,
160      *         which is used to request validator exit and update its status to dissolves or slashed.
161      */
162     IOracleAdapter public oracleAdapter;
163 
164     /**
165      * @notice The address designated as the reward recipient for protocol incentives.
166      * @dev    This variable holds the address of the entity designated to receive consensus,
167      *         execution and MEV rewards.
168      */
169     address public rewardRecipient;
170 
171     /**
172      * @notice Indicator for whether depositing Ether to the beacon chain deposit contract is paused or not.
173      * @dev    This variable holds the status indicator (paused or not) for depositing Ether to the beacon chain deposit contract.
174      */
175     uint256 public depositEtherPaused;
176 
177     /**
178      * @notice Buffer for pending deposits to be staked, r
179      *         equired to be greater than or equal to multiples of DEPOSIT_SIZE, including preDepositAmount.
180      * @dev    This variable holds the amount of pending deposits that are waiting to be staked.
181      *         It ensures that the buffer size is sufficient for multiples of DEPOSIT_SIZE, including preDepositAmount.
182      */
183     uint256 public pendingDeposit;
184 
185     /**
186      * @notice Queue to prioritize validator spinning on a FIFO basis.
187      * @dev    This internal variable represents a deque (double-ended queue) used to prioritize validator
188      *         spinning based on a First-In-First-Out (FIFO) basis.
189      */
190     DataTypes.ValidatorDeque internal _initializedValidators;
191 
192     /**
193      * @notice Queue to prioritize the next validator to be exited when required on a FIFO basis.
194      * @dev    This internal variable represents a deque (double-ended queue) used to prioritize validators
195      *         for exiting based on a First-In-First-Out (FIFO) basis.
196      */
197     DataTypes.ValidatorDeque internal _stakingValidators;
198 
199     /**
200      * @notice Buffer for withdrawals to be unstaked, required to be greater than or equal to multiples of DEPOSIT_SIZE.
201      * @dev    This variable holds the amount of Ether that is pending withdrawal,
202      *         and it must be greater than or equal to multiples of DEPOSIT_SIZE.
203      */
204     uint256 public pendingWithdrawal;
205 
206     /**
207      * @notice ETH available for redemptions.
208      * @dev    This variable represents the amount of Ether available for redemptions by burning upxEth.
209      */
210     uint256 public outstandingRedemptions;
211 
212     /**
213      * @notice Batch Id for validator's voluntary exit.
214      * @dev    This variable represents the batch ID for a validator's voluntary exit.
215      */
216     uint256 public batchId;
217 
218     /**
219      * @notice End block for the ETH rewards calculation.
220      * @dev    This variable represents the block number until which ETH rewards are computed.
221      */
222     uint256 public endBlock;
223 
224     /**
225      * @notice Validator statuses, mapping from validator public key to their status.
226      * @dev    This mapping tracks the status of each validator, using their public key as the identifier.
227      */
228     mapping(bytes => DataTypes.ValidatorStatus) public status;
229 
230     /**
231      * @notice Mapping from batchId to validator public key.
232      * @dev    This mapping tracks the batch ID of each unstaked validator
233      */
234     mapping(uint256 => bytes) public batchIdToValidator;
235 
236     /**
237      * @notice Accounts designated for burning pxEth when the buffer is used for top-up and the validator is slashed.
238      * @dev    This mapping identifies accounts designated for burning pxEth under specific conditions.
239      */
240     mapping(address => bool) public burnerAccounts;
241 
242     // Events
243     /**
244      * @notice Emitted when a validator is deposited, indicating the addition of a new validator.
245      * @dev    This event is triggered when a user deposits ETH for staking, creating a new validator.
246      *         Validators play a crucial role in the proof-of-stake consensus mechanism and contribute
247      *         to the security and functionality of the network. The `pubKey` parameter represents the public key of the deposited validator.
248      * @param pubKey bytes Public key of the deposited validator.
249      */
250     event ValidatorDeposit(bytes pubKey);
251 
252     /**
253      * @notice Emitted when a contract address is set.
254      * @dev    This event is triggered when a contract address is set for a specific contract type.
255      * @param  c                DataTypes.Contract  The type of the contract being set.
256      * @param  contractAddress  address             The address of the contract being set.
257      */
258     event SetContract(DataTypes.Contract indexed c, address contractAddress);
259 
260     /**
261      * @notice Emitted when the status of depositing Ether is paused or unpaused.
262      * @dev    This event is triggered when there is a change in the status of depositing Ether.
263      *         The `newStatus` parameter indicates whether depositing Ether is currently paused or unpaused.
264      *         Pausing depositing Ether can be useful in certain scenarios, such as during contract upgrades or emergency situations.
265      * @param  newStatus  uint256  The new status indicating whether depositing Ether is paused or unpaused.
266      */
267     event DepositEtherPaused(uint256 newStatus);
268 
269     /**
270      * @notice Emitted when harvesting rewards.
271      * @dev    This event is triggered when rewards are harvested. The `amount` parameter indicates the amount of rewards harvested,
272      *         and the `endBlock` parameter specifies the block until which ETH rewards are computed.
273      * @param  amount    uint256  The amount of rewards harvested.
274      * @param  endBlock  uint256  The block until which ETH rewards are computed.
275      */
276     event Harvest(uint256 amount, uint256 endBlock);
277 
278     /**
279      * @notice Emitted when the max buffer size percentage is set.
280      * @dev    This event is triggered when the max buffer size percentage is updated.
281      *         The `pct` parameter represents the new max buffer size percentage.
282      * @param  pct  uint256  The new max buffer size percentage.
283      */
284     event SetMaxBufferSizePct(uint256 pct);
285 
286     /**
287      * @notice Emitted when a burner account is approved.
288      * @dev    This event is triggered when a burner account is approved.
289      *         The `account` parameter represents the approved burner account.
290      * @param  account  address  The approved burner account.
291      */
292     event ApproveBurnerAccount(address indexed account);
293 
294     /**
295      * @notice Emitted when a burner account is revoked.
296      * @dev    This event is triggered when a burner account is revoked.
297      *         The `account` parameter represents the revoked burner account.
298      * @param  account  address  The revoked burner account.
299      */
300     event RevokeBurnerAccount(address indexed account);
301 
302     /**
303      * @notice Emitted when a validator is dissolved.
304      * @dev    This event is triggered when a validator is dissolved, indicating the update of the validator state.
305      * @param  pubKey  bytes  Public key of the dissolved validator.
306      */
307     event DissolveValidator(bytes pubKey);
308 
309     /**
310      * @notice Emitted when a validator is slashed.
311      * @dev    This event is triggered when a validator is slashed, indicating the slashing action and its details.
312      * @param  pubKey          bytes    Public key of the slashed validator.
313      * @param  useBuffer       bool     Indicates whether a buffer is used during slashing.
314      * @param  releasedAmount  uint256  Amount released from the Beacon chain.
315      * @param  penalty         uint256  Penalty amount.
316      */
317     event SlashValidator(
318         bytes pubKey,
319         bool useBuffer,
320         uint256 releasedAmount,
321         uint256 penalty
322     );
323 
324     /**
325      * @notice Emitted when a validator's stake is topped up.
326      * @dev    This event is triggered when a validator's stake is topped up, indicating the top-up action and its details.
327      * @param  pubKey       bytes    Public key of the topped-up validator.
328      * @param  useBuffer    bool     Indicates whether a buffer is used during topping up.
329      * @param  topUpAmount  uint256  Amount topped up.
330      */
331     event TopUp(bytes pubKey, bool useBuffer, uint256 topUpAmount);
332 
333     /**
334      * @notice Emitted when the maximum processed validator count is set.
335      * @dev    This event is triggered when the maximum count of processed validators is set, indicating a change in the processing limit.
336      * @param  count  uint256  The new maximum count of processed validators.
337      */
338     event SetMaxProcessedValidatorCount(uint256 count);
339 
340     /**
341      * @notice Emitted when the max buffer size is updated.
342      * @dev    This event is triggered when max buffer size is updated
343      * @param  maxBufferSize  uint256  The updated maximum buffer size.
344      */
345     event UpdateMaxBufferSize(uint256 maxBufferSize);
346 
347     /**
348      * @notice Emitted when the withdrawal credentials are set.
349      * @dev    This event is triggered when the withdrawal credentials are updated, indicating a change in the credentials used for validator withdrawals.
350      * @param  withdrawalCredentials  bytes  The new withdrawal credentials.
351      */
352     event SetWithdrawCredentials(bytes withdrawalCredentials);
353 
354     // Modifiers
355     /**
356      * @dev Reverts if the sender is not the specified reward recipient. Used to control access to functions that
357      *      are intended for the designated recipient of rewards.
358      */
359     modifier onlyRewardRecipient() {
360         if (msg.sender != rewardRecipient) revert Errors.NotRewardRecipient();
361         _;
362     }
363 
364     /**
365      * @dev Reverts if depositing Ether is not paused. Used to control access to functions that should only be
366      *      callable when depositing Ether is in a paused state.
367      */
368     modifier onlyWhenDepositEtherPaused() {
369         if (depositEtherPaused == _NOT_PAUSED)
370             revert Errors.DepositingEtherNotPaused();
371         _;
372     }
373 
374     /*//////////////////////////////////////////////////////////////
375                         CONSTRUCTOR/INITIALIZATION LOGIC
376     //////////////////////////////////////////////////////////////*/
377 
378     /**
379      * @notice Initializes the PirexEthValidators contract.
380      * @dev    Initializes the contract with the provided parameters and sets up the initial state.
381      * @param  _pxEth                      address  PxETH contract address
382      * @param  _admin                      address  Admin address
383      * @param  _beaconChainDepositContract address  The address of the deposit precompile
384      * @param  _upxEth                     address  UpxETH address
385      * @param  _depositSize                uint256  Amount of ETH to stake
386      * @param  _preDepositAmount           uint256  Amount of ETH for pre-deposit
387      * @param  _initialDelay               uint48   Delay required to schedule the acceptance
388      *                                              of an access control transfer started
389      */
390     constructor(
391         address _pxEth,
392         address _admin,
393         address _beaconChainDepositContract,
394         address _upxEth,
395         uint256 _depositSize,
396         uint256 _preDepositAmount,
397         uint48 _initialDelay
398     ) AccessControlDefaultAdminRules(_initialDelay, _admin) {
399         if (_pxEth == address(0)) revert Errors.ZeroAddress();
400         if (_beaconChainDepositContract == address(0))
401             revert Errors.ZeroAddress();
402         if (_upxEth == address(0)) revert Errors.ZeroAddress();
403         if (_depositSize < 1 ether && _depositSize % 1 gwei != 0)
404             revert Errors.ZeroMultiplier();
405         if (
406             _preDepositAmount > _depositSize ||
407             _preDepositAmount < 1 ether ||
408             _preDepositAmount % 1 gwei != 0
409         ) revert Errors.ZeroMultiplier();
410 
411         pxEth = PxEth(_pxEth);
412         DEPOSIT_SIZE = _depositSize;
413         beaconChainDepositContract = _beaconChainDepositContract;
414         preDepositAmount = _preDepositAmount;
415         upxEth = UpxEth(_upxEth);
416         depositEtherPaused = _NOT_PAUSED;
417     }
418 
419     /*//////////////////////////////////////////////////////////////
420                                 VIEW
421     //////////////////////////////////////////////////////////////*/
422 
423     /**
424      * @notice Get the number of initialized validators
425      * @dev    Returns the count of validators that are ready to be staked.
426      * @return uint256 count of validators ready to be staked
427      */
428     function getInitializedValidatorCount() external view returns (uint256) {
429         return _initializedValidators.count();
430     }
431 
432     /**
433      * @notice Get the number of staked validators
434      * @dev    Returns the count of validators with staking status.
435      * @return uint256 count of validators with staking status
436      */
437     function getStakingValidatorCount() public view returns (uint256) {
438         return _stakingValidators.count();
439     }
440 
441     /**
442      * @notice Get the initialized validator info at the specified index
443      * @dev    Returns the details of the initialized validator at the given index.
444      * @param  _i  uint256  Index
445      * @return     bytes    Public key
446      * @return     bytes    Withdrawal credentials
447      * @return     bytes    Signature
448      * @return     bytes32  Deposit data root hash
449      * @return     address  pxETH receiver
450      */
451     function getInitializedValidatorAt(
452         uint256 _i
453     )
454         external
455         view
456         returns (bytes memory, bytes memory, bytes memory, bytes32, address)
457     {
458         return _initializedValidators.get(withdrawalCredentials, _i);
459     }
460 
461     /**
462      * @notice Get the staking validator info at the specified index
463      * @dev    Returns the details of the staking validator at the given index.
464      * @param  _i  uint256  Index
465      * @return     bytes    Public key
466      * @return     bytes    Withdrawal credentials
467      * @return     bytes    Signature
468      * @return     bytes32  Deposit data root hash
469      * @return     address  pxETH receiver
470      */
471     function getStakingValidatorAt(
472         uint256 _i
473     )
474         external
475         view
476         returns (bytes memory, bytes memory, bytes memory, bytes32, address)
477     {
478         return _stakingValidators.get(withdrawalCredentials, _i);
479     }
480 
481     /*//////////////////////////////////////////////////////////////
482                         RESTRICTED FUNCTIONS
483     //////////////////////////////////////////////////////////////*/
484 
485     /**
486      * @notice Set a contract address
487      * @dev    Allows the governance role to set the address for a contract in the system.
488      * @param  _contract        DataTypes.Contract  Contract
489      * @param  contractAddress  address             Contract address
490      */
491     function setContract(
492         DataTypes.Contract _contract,
493         address contractAddress
494     ) external onlyRole(GOVERNANCE_ROLE) {
495         if (contractAddress == address(0)) revert Errors.ZeroAddress();
496 
497         emit SetContract(_contract, contractAddress);
498 
499         if (_contract == DataTypes.Contract.UpxEth) {
500             upxEth = UpxEth(contractAddress);
501         } else if (_contract == DataTypes.Contract.PxEth) {
502             pxEth = PxEth(contractAddress);
503         } else if (_contract == DataTypes.Contract.AutoPxEth) {
504             ERC20 pxEthERC20 = ERC20(address(pxEth));
505             address oldVault = address(autoPxEth);
506 
507             if (oldVault != address(0)) {
508                 pxEthERC20.safeApprove(oldVault, 0);
509             }
510 
511             autoPxEth = AutoPxEth(contractAddress);
512             pxEthERC20.safeApprove(address(autoPxEth), type(uint256).max);
513         } else if (_contract == DataTypes.Contract.OracleAdapter) {
514             oracleAdapter = IOracleAdapter(contractAddress);
515         } else if (_contract == DataTypes.Contract.RewardRecipient) {
516             rewardRecipient = contractAddress;
517             withdrawalCredentials = abi.encodePacked(
518                 bytes1(0x01),
519                 bytes11(0x0),
520                 contractAddress
521             );
522 
523             emit SetWithdrawCredentials(withdrawalCredentials);
524         } else {
525             revert Errors.UnrecorgnisedContract();
526         }
527     }
528 
529     /**
530      * @notice Set the percentage that will be applied to total supply of pxEth to determine maxBufferSize
531      * @dev    Allows the governance role to set the percentage of the total supply of pxEth that will be used as maxBufferSize.
532      * @param  _pct  uint256  Max buffer size percentage
533      */
534     function setMaxBufferSizePct(
535         uint256 _pct
536     ) external onlyRole(GOVERNANCE_ROLE) {
537         if (_pct > DENOMINATOR) {
538             revert Errors.ExceedsMax();
539         }
540 
541         maxBufferSizePct = _pct;
542 
543         emit SetMaxBufferSizePct(_pct);
544     }
545 
546     /**
547      * @notice Set the maximum count of validators to be processed in a single _deposit call
548      * @dev    Only the role with the GOVERNANCE_ROLE can execute this function.
549      * @param _count  uint256  Maximum count of validators to be processed
550      */
551     function setMaxProcessedValidatorCount(
552         uint256 _count
553     ) external onlyRole(GOVERNANCE_ROLE) {
554         if (_count == 0) {
555             revert Errors.InvalidMaxProcessedCount();
556         }
557 
558         maxProcessedValidatorCount = _count;
559 
560         emit SetMaxProcessedValidatorCount(_count);
561     }
562 
563     /**
564      * @notice Toggle the ability to deposit ETH to validators
565      * @dev    Only the role with the GOVERNANCE_ROLE can execute this function.
566      */
567     function togglePauseDepositEther() external onlyRole(GOVERNANCE_ROLE) {
568         depositEtherPaused = depositEtherPaused == _NOT_PAUSED
569             ? _PAUSED
570             : _NOT_PAUSED;
571 
572         emit DepositEtherPaused(depositEtherPaused);
573     }
574 
575     /**
576      * @notice Approve or revoke addresses as burner accounts
577      * @dev    Only the role with the GOVERNANCE_ROLE can execute this function.
578      * @param _accounts  address[]  An array of addresses to be approved or revoked as burner accounts.
579      * @param _state     bool       A boolean indicating whether to approve (true) or revoke (false) the burner account state.
580      */
581     function toggleBurnerAccounts(
582         address[] calldata _accounts,
583         bool _state
584     ) external onlyRole(GOVERNANCE_ROLE) {
585         uint256 _len = _accounts.length;
586 
587         for (uint256 _i; _i < _len; ) {
588             address account = _accounts[_i];
589 
590             burnerAccounts[account] = _state;
591 
592             if (_state) {
593                 emit ApproveBurnerAccount(account);
594             } else {
595                 emit RevokeBurnerAccount(account);
596             }
597 
598             unchecked {
599                 ++_i;
600             }
601         }
602     }
603 
604     /*//////////////////////////////////////////////////////////////
605                             MUTATIVE FUNCTIONS
606     //////////////////////////////////////////////////////////////*/
607 
608     /**
609      * @notice Update validator to Dissolve once Oracle confirms ETH release
610      * @dev    Only the reward recipient can initiate the dissolution process.
611      * @param  _pubKey  bytes  The public key of the validator to be dissolved.
612      */
613     function dissolveValidator(
614         bytes calldata _pubKey
615     ) external payable override onlyRewardRecipient {
616         uint256 _amount = msg.value;
617         if (_amount != DEPOSIT_SIZE) revert Errors.InvalidAmount();
618         if (status[_pubKey] != DataTypes.ValidatorStatus.Withdrawable)
619             revert Errors.NotWithdrawable();
620 
621         status[_pubKey] = DataTypes.ValidatorStatus.Dissolved;
622 
623         outstandingRedemptions += _amount;
624 
625         emit DissolveValidator(_pubKey);
626     }
627 
628     /**
629      * @notice Update validator state to be slashed
630      * @dev    Only the reward recipient can initiate the slashing process.
631      * @param  _pubKey          bytes                      The public key of the validator to be slashed.
632      * @param  _removeIndex     uint256                    Index of the validator to be slashed.
633      * @param  _amount          uint256                    ETH amount released from the Beacon chain.
634      * @param  _unordered       bool                       Whether to remove from the staking validator queue in order or not.
635      * @param  _useBuffer       bool                       Whether to use the buffer to compensate for the loss.
636      * @param  _burnerAccounts  DataTypes.BurnerAccount[]  Burner accounts providing additional compensation.
637      */
638     function slashValidator(
639         bytes calldata _pubKey,
640         uint256 _removeIndex,
641         uint256 _amount,
642         bool _unordered,
643         bool _useBuffer,
644         DataTypes.BurnerAccount[] calldata _burnerAccounts
645     ) external payable override onlyRewardRecipient {
646         uint256 _ethAmount = msg.value;
647         uint256 _defaultDepositSize = DEPOSIT_SIZE;
648         DataTypes.ValidatorStatus _status = status[_pubKey];
649 
650         if (
651             _status != DataTypes.ValidatorStatus.Staking &&
652             _status != DataTypes.ValidatorStatus.Withdrawable
653         ) revert Errors.StatusNotWithdrawableOrStaking();
654 
655         if (_useBuffer) {
656             _updateBuffer(_defaultDepositSize - _ethAmount, _burnerAccounts);
657         } else if (_ethAmount != _defaultDepositSize) {
658             revert Errors.InvalidAmount();
659         }
660 
661         // It is possible that validator can be slashed while exiting
662         if (_status == DataTypes.ValidatorStatus.Staking) {
663             bytes memory _removedPubKey;
664 
665             if (!_unordered) {
666                 _removedPubKey = _stakingValidators.removeOrdered(_removeIndex);
667             } else {
668                 _removedPubKey = _stakingValidators.removeUnordered(
669                     _removeIndex
670                 );
671             }
672 
673             assert(keccak256(_pubKey) == keccak256(_removedPubKey));
674 
675             _addPendingDeposit(_defaultDepositSize);
676         } else {
677             outstandingRedemptions += _defaultDepositSize;
678         }
679         status[_pubKey] = DataTypes.ValidatorStatus.Slashed;
680 
681         emit SlashValidator(
682             _pubKey,
683             _useBuffer,
684             _amount,
685             DEPOSIT_SIZE - _amount
686         );
687     }
688 
689     /**
690      * @notice Add multiple synced validators in the queue to be ready for staking.
691      * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
692      * @param  _validators  DataTypes.Validator[]  An array of validator details (public key, withdrawal credentials, etc.).
693      */
694     function addInitializedValidators(
695         DataTypes.Validator[] memory _validators
696     ) external onlyWhenDepositEtherPaused onlyRole(GOVERNANCE_ROLE) {
697         uint256 _arrayLength = _validators.length;
698         for (uint256 _i; _i < _arrayLength; ) {
699             if (
700                 status[_validators[_i].pubKey] != DataTypes.ValidatorStatus.None
701             ) revert Errors.NoUsedValidator();
702 
703             _initializedValidators.add(_validators[_i], withdrawalCredentials);
704 
705             unchecked {
706                 ++_i;
707             }
708         }
709     }
710 
711     /**
712      * @notice Swap initialized validators specified by the indexes.
713      * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
714      * @param  _fromIndex  uint256  The index of the validator to be swapped from.
715      * @param  _toIndex    uint256  The index of the validator to be swapped to.
716      */
717     function swapInitializedValidator(
718         uint256 _fromIndex,
719         uint256 _toIndex
720     ) external onlyWhenDepositEtherPaused onlyRole(GOVERNANCE_ROLE) {
721         _initializedValidators.swap(_fromIndex, _toIndex);
722     }
723 
724     /**
725      * @notice Pop initialized validators from the queue.
726      * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
727      * @param  _times  uint256  The count of pop operations to be performed.
728      */
729     function popInitializedValidator(
730         uint256 _times
731     ) external onlyWhenDepositEtherPaused onlyRole(GOVERNANCE_ROLE) {
732         _initializedValidators.pop(_times);
733     }
734 
735     /**
736      * @notice Remove an initialized validator from the queue.
737      * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
738      * @param  _pubKey       bytes    The public key of the validator to be removed.
739      * @param  _removeIndex  uint256  The index of the validator to be removed.
740      * @param  _unordered    bool     A flag indicating whether removal should be unordered (true) or ordered (false).
741      */
742     function removeInitializedValidator(
743         bytes calldata _pubKey,
744         uint256 _removeIndex,
745         bool _unordered
746     ) external onlyWhenDepositEtherPaused onlyRole(GOVERNANCE_ROLE) {
747         bytes memory _removedPubKey;
748 
749         if (_unordered) {
750             _removedPubKey = _initializedValidators.removeUnordered(
751                 _removeIndex
752             );
753         } else {
754             _removedPubKey = _initializedValidators.removeOrdered(_removeIndex);
755         }
756 
757         assert(keccak256(_removedPubKey) == keccak256(_pubKey));
758     }
759 
760     /**
761      * @notice Clear all initialized validators from the queue.
762      * @dev    Only callable when depositing Ether is paused and by a user with the GOVERNANCE_ROLE.
763      */
764     function clearInitializedValidator()
765         external
766         onlyWhenDepositEtherPaused
767         onlyRole(GOVERNANCE_ROLE)
768     {
769         _initializedValidators.clear();
770     }
771 
772     /**
773      * @notice Trigger a privileged deposit to the ETH 2.0 deposit contract.
774      * @dev    Only callable by a user with the KEEPER_ROLE and ensures that depositing Ether is not paused.
775      *         This function initiates the deposit process to the ETH 2.0 deposit contract.
776      */
777     function depositPrivileged() external nonReentrant onlyRole(KEEPER_ROLE) {
778         // Initial pause check
779         if (depositEtherPaused == _PAUSED)
780             revert Errors.DepositingEtherPaused();
781 
782         _deposit();
783     }
784 
785     /**
786      * @notice Top up ETH to a staking validator if the current balance drops below the effective balance.
787      * @dev    Only callable by a user with the KEEPER_ROLE.
788      * @param  _pubKey           bytes                      Validator public key.
789      * @param  _signature        bytes                      A BLS12-381 signature.
790      * @param  _depositDataRoot  bytes32                    The SHA-256 hash of the SSZ-encoded DepositData object.
791      * @param  _topUpAmount      uint256                    Top-up amount in ETH.
792      * @param  _useBuffer        bool                       Whether to use a buffer to compensate for the loss.
793      * @param  _burnerAccounts   DataTypes.BurnerAccount[]  Array of burner accounts.
794      */
795     function topUpStake(
796         bytes calldata _pubKey,
797         bytes calldata _signature,
798         bytes32 _depositDataRoot,
799         uint256 _topUpAmount,
800         bool _useBuffer,
801         DataTypes.BurnerAccount[] calldata _burnerAccounts
802     ) external payable nonReentrant onlyRole(KEEPER_ROLE) {
803         if (status[_pubKey] != DataTypes.ValidatorStatus.Staking)
804             revert Errors.ValidatorNotStaking();
805 
806         if (_useBuffer) {
807             if (msg.value > 0) {
808                 revert Errors.NoETHAllowed();
809             }
810             _updateBuffer(_topUpAmount, _burnerAccounts);
811         } else if (msg.value != _topUpAmount) {
812             revert Errors.NoETH();
813         }
814 
815         (bool success, ) = beaconChainDepositContract.call{value: _topUpAmount}(
816             abi.encodeCall(
817                 IDepositContract.deposit,
818                 (_pubKey, withdrawalCredentials, _signature, _depositDataRoot)
819             )
820         );
821 
822         assert(success);
823 
824         emit TopUp(_pubKey, _useBuffer, _topUpAmount);
825     }
826 
827     /**
828      * @notice Harvest and mint staking rewards when available.
829      * @dev    Only callable by the reward recipient.
830      * @param  _endBlock  uint256  Block until which ETH rewards are computed.
831      */
832     function harvest(
833         uint256 _endBlock
834     ) external payable override onlyRewardRecipient {
835         if (msg.value != 0) {
836             // update end block
837             endBlock = _endBlock;
838 
839             // Mint pxETH directly for the vault
840             _mintPxEth(address(autoPxEth), msg.value);
841 
842             // Update rewards tracking with the newly added rewards
843             autoPxEth.notifyRewardAmount();
844 
845             // Direct the excess balance for pending deposit
846             _addPendingDeposit(msg.value);
847 
848             emit Harvest(msg.value, _endBlock);
849         }
850     }
851 
852     /*//////////////////////////////////////////////////////////////
853                         INTERNAL FUNCTIONS
854     //////////////////////////////////////////////////////////////*/
855 
856     /**
857      * @dev   Mints the specified amount of pxETH and updates the maximum buffer size.
858      * @param _account  address  The address to which pxETH will be minted.
859      * @param _amount   uint256  The amount of pxETH to be minted.
860      */
861     function _mintPxEth(address _account, uint256 _amount) internal {
862         pxEth.mint(_account, _amount);
863         uint256 _maxBufferSize = (pxEth.totalSupply() * maxBufferSizePct) /
864             DENOMINATOR;
865         maxBufferSize = _maxBufferSize;
866         emit UpdateMaxBufferSize(_maxBufferSize);
867     }
868 
869     /**
870      * @dev   Burns the specified amount of pxETH from the given account and updates the maximum buffer size.
871      * @param _account  address  The address from which pxETH will be burned.
872      * @param _amount   uint256  The amount of pxETH to be burned.
873      */
874     function _burnPxEth(address _account, uint256 _amount) internal {
875         pxEth.burn(_account, _amount);
876         uint256 _maxBufferSize = (pxEth.totalSupply() * maxBufferSizePct) /
877             DENOMINATOR;
878         maxBufferSize = _maxBufferSize;
879         emit UpdateMaxBufferSize(_maxBufferSize);
880     }
881 
882     /**
883      * @dev Processes the deposit of validators, taking into account the maximum processed validator count,
884      *      the remaining deposit amount, and the status of initialized validators. It iterates through initialized
885      *      validators, deposits them into the Beacon chain, mints pxETH if needed, and updates the validator status.
886      */
887     function _deposit() internal {
888         uint256 remainingCount = maxProcessedValidatorCount;
889         uint256 _remainingdepositAmount = DEPOSIT_SIZE - preDepositAmount;
890 
891         while (
892             _initializedValidators.count() != 0 &&
893             pendingDeposit >= _remainingdepositAmount &&
894             remainingCount > 0
895         ) {
896             // Get validator information
897             (
898                 bytes memory _pubKey,
899                 bytes memory _withdrawalCredentials,
900                 bytes memory _signature,
901                 bytes32 _depositDataRoot,
902                 address _receiver
903             ) = _initializedValidators.getNext(withdrawalCredentials);
904 
905             // Make sure the validator hasn't been deposited into already
906             // to prevent sending an extra eth equal to `_remainingdepositAmount`
907             // until withdrawals are allowed
908             if (status[_pubKey] != DataTypes.ValidatorStatus.None)
909                 revert Errors.NoUsedValidator();
910 
911             (bool success, ) = beaconChainDepositContract.call{
912                 value: _remainingdepositAmount
913             }(
914                 abi.encodeCall(
915                     IDepositContract.deposit,
916                     (
917                         _pubKey,
918                         _withdrawalCredentials,
919                         _signature,
920                         _depositDataRoot
921                     )
922                 )
923             );
924 
925             assert(success);
926 
927             pendingDeposit -= _remainingdepositAmount;
928 
929             if (preDepositAmount != 0) {
930                 _mintPxEth(_receiver, preDepositAmount);
931             }
932 
933             unchecked {
934                 --remainingCount;
935             }
936 
937             status[_pubKey] = DataTypes.ValidatorStatus.Staking;
938 
939             _stakingValidators.add(
940                 DataTypes.Validator(
941                     _pubKey,
942                     _signature,
943                     _depositDataRoot,
944                     _receiver
945                 ),
946                 _withdrawalCredentials
947             );
948 
949             emit ValidatorDeposit(_pubKey);
950         }
951     }
952 
953     /**
954      * @dev   Adds the specified amount to the pending deposit, considering the available buffer space and deposit pause status.
955      *        If the buffer space is available, it may be fully or partially utilized. The method then checks if depositing
956      *        ETH is not paused and spins up a validator if conditions are met.
957      * @param _amount  uint256  The amount of ETH to be added to the pending deposit.
958      */
959     function _addPendingDeposit(uint256 _amount) internal virtual {
960         uint256 _remainingBufferSpace = (
961             maxBufferSize > buffer ? maxBufferSize - buffer : 0
962         );
963         uint256 _remainingAmount = _amount;
964 
965         if (_remainingBufferSpace != 0) {
966             bool _canBufferSpaceFullyUtilized = _remainingBufferSpace <=
967                 _remainingAmount;
968             buffer += _canBufferSpaceFullyUtilized
969                 ? _remainingBufferSpace
970                 : _remainingAmount;
971             _remainingAmount -= _canBufferSpaceFullyUtilized
972                 ? _remainingBufferSpace
973                 : _remainingAmount;
974         }
975 
976         pendingDeposit += _remainingAmount;
977 
978         if (depositEtherPaused == _NOT_PAUSED) {
979             // Spin up a validator when possible
980             _deposit();
981         }
982     }
983 
984     /**
985      * @dev   Initiates the redemption process by adding the specified amount of pxETH to the pending withdrawal.
986      *        Iteratively processes pending withdrawals in multiples of DEPOSIT_SIZE, triggering validator exits, updating
987      *        batch information, and changing validator statuses accordingly. The process continues until the remaining
988      *        pending withdrawal is less than DEPOSIT_SIZE. If `_shouldTriggerValidatorExit` is true and there's remaining
989      *        pxETH after the redemption process, the function reverts, preventing partial initiation of redemption.
990      * @param _pxEthAmount                 uint256  The amount of pxETH to be redeemed.
991      * @param _receiver                    address  The receiver address for upxETH.
992      * @param _shouldTriggerValidatorExit  bool     Whether to initiate partial redemption with a validator exit or not.
993      */
994     function _initiateRedemption(
995         uint256 _pxEthAmount,
996         address _receiver,
997         bool _shouldTriggerValidatorExit
998     ) internal {
999         pendingWithdrawal += _pxEthAmount;
1000 
1001         while (pendingWithdrawal / DEPOSIT_SIZE != 0) {
1002             uint256 _allocationPossible = DEPOSIT_SIZE +
1003                 _pxEthAmount -
1004                 pendingWithdrawal;
1005 
1006             upxEth.mint(_receiver, batchId, _allocationPossible, "");
1007 
1008             (bytes memory _pubKey, , , , ) = _stakingValidators.getNext(
1009                 withdrawalCredentials
1010             );
1011 
1012             pendingWithdrawal -= DEPOSIT_SIZE;
1013             _pxEthAmount -= _allocationPossible;
1014 
1015             oracleAdapter.requestVoluntaryExit(_pubKey);
1016 
1017             batchIdToValidator[batchId++] = _pubKey;
1018             status[_pubKey] = DataTypes.ValidatorStatus.Withdrawable;
1019         }
1020 
1021         if (_shouldTriggerValidatorExit && _pxEthAmount > 0)
1022             revert Errors.NoPartialInitiateRedemption();
1023 
1024         if (_pxEthAmount > 0) {
1025             upxEth.mint(_receiver, batchId, _pxEthAmount, "");
1026         }
1027     }
1028 
1029     /**
1030      * @dev   Checks if the contract has enough buffer to cover the specified amount. Iterates through the provided
1031      *        `_burnerAccounts`, verifies each account's approval status, burns the corresponding amount of pxETH, and
1032      *        updates the buffer accordingly. Reverts if there is insufficient buffer, if an account is not approved, or
1033      *        if the sum of burned amounts does not match the specified amount.
1034      * @param _amount          uint256                    The amount to be updated in the buffer.
1035      * @param _burnerAccounts  DataTypes.BurnerAccount[]  An array of burner account details (account and amount).
1036      */
1037     function _updateBuffer(
1038         uint256 _amount,
1039         DataTypes.BurnerAccount[] calldata _burnerAccounts
1040     ) private {
1041         if (buffer < _amount) {
1042             revert Errors.NotEnoughBuffer();
1043         }
1044         uint256 _len = _burnerAccounts.length;
1045         uint256 _sum;
1046 
1047         for (uint256 _i; _i < _len; ) {
1048             if (!burnerAccounts[_burnerAccounts[_i].account])
1049                 revert Errors.AccountNotApproved();
1050 
1051             _sum += _burnerAccounts[_i].amount;
1052 
1053             _burnPxEth(_burnerAccounts[_i].account, _burnerAccounts[_i].amount);
1054 
1055             unchecked {
1056                 ++_i;
1057             }
1058         }
1059 
1060         assert(_sum == _amount);
1061         buffer -= _amount;
1062     }
1063 }
