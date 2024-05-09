1 pragma solidity ^0.4.17;
2 
3 /*
4 
5  * source       https://github.com/blockbitsio/
6 
7  * @name        Application Entity Generic Contract
8  * @package     BlockBitsIO
9  * @author      Micky Socaci <micky@nowlive.ro>
10 
11     Used for the ABI interface when assets need to call Application Entity.
12 
13     This is required, otherwise we end up loading the assets themselves when we load the ApplicationEntity contract
14     and end up in a loop
15 */
16 
17 
18 
19 contract ApplicationEntityABI {
20 
21     address public ProposalsEntity;
22     address public FundingEntity;
23     address public MilestonesEntity;
24     address public MeetingsEntity;
25     address public BountyManagerEntity;
26     address public TokenManagerEntity;
27     address public ListingContractEntity;
28     address public FundingManagerEntity;
29     address public NewsContractEntity;
30 
31     bool public _initialized = false;
32     bool public _locked = false;
33     uint8 public CurrentEntityState;
34     uint8 public AssetCollectionNum;
35     address public GatewayInterfaceAddress;
36     address public deployerAddress;
37     address testAddressAllowUpgradeFrom;
38     mapping (bytes32 => uint8) public EntityStates;
39     mapping (bytes32 => address) public AssetCollection;
40     mapping (uint8 => bytes32) public AssetCollectionIdToName;
41     mapping (bytes32 => uint256) public BylawsUint256;
42     mapping (bytes32 => bytes32) public BylawsBytes32;
43 
44     function ApplicationEntity() public;
45     function getEntityState(bytes32 name) public view returns (uint8);
46     function linkToGateway( address _GatewayInterfaceAddress, bytes32 _sourceCodeUrl ) external;
47     function setUpgradeState(uint8 state) public ;
48     function addAssetProposals(address _assetAddresses) external;
49     function addAssetFunding(address _assetAddresses) external;
50     function addAssetMilestones(address _assetAddresses) external;
51     function addAssetMeetings(address _assetAddresses) external;
52     function addAssetBountyManager(address _assetAddresses) external;
53     function addAssetTokenManager(address _assetAddresses) external;
54     function addAssetFundingManager(address _assetAddresses) external;
55     function addAssetListingContract(address _assetAddresses) external;
56     function addAssetNewsContract(address _assetAddresses) external;
57     function getAssetAddressByName(bytes32 _name) public view returns (address);
58     function setBylawUint256(bytes32 name, uint256 value) public;
59     function getBylawUint256(bytes32 name) public view returns (uint256);
60     function setBylawBytes32(bytes32 name, bytes32 value) public;
61     function getBylawBytes32(bytes32 name) public view returns (bytes32);
62     function initialize() external returns (bool);
63     function getParentAddress() external view returns(address);
64     function createCodeUpgradeProposal( address _newAddress, bytes32 _sourceCodeUrl ) external returns (uint256);
65     function acceptCodeUpgradeProposal(address _newAddress) external;
66     function initializeAssetsToThisApplication() external returns (bool);
67     function transferAssetsToNewApplication(address _newAddress) external returns (bool);
68     function lock() external returns (bool);
69     function canInitiateCodeUpgrade(address _sender) public view returns(bool);
70     function doStateChanges() public;
71     function hasRequiredStateChanges() public view returns (bool);
72     function anyAssetHasChanges() public view returns (bool);
73     function extendedAnyAssetHasChanges() internal view returns (bool);
74     function getRequiredStateChanges() public view returns (uint8, uint8);
75     function getTimestamp() view public returns (uint256);
76 
77 }
78 
79 /*
80 
81  * source       https://github.com/blockbitsio/
82 
83  * @name        Token Contract
84  * @package     BlockBitsIO
85  * @author      Micky Socaci <micky@nowlive.ro>
86 
87  Zeppelin ERC20 Standard Token
88 
89 */
90 
91 
92 
93 contract ABIToken {
94 
95     string public  symbol;
96     string public  name;
97     uint8 public   decimals;
98     uint256 public totalSupply;
99     string public  version;
100     mapping (address => uint256) public balances;
101     mapping (address => mapping (address => uint256)) allowed;
102     address public manager;
103     address public deployer;
104     bool public mintingFinished = false;
105     bool public initialized = false;
106 
107     function transfer(address _to, uint256 _value) public returns (bool);
108     function balanceOf(address _owner) public view returns (uint256 balance);
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
110     function approve(address _spender, uint256 _value) public returns (bool);
111     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
112     function increaseApproval(address _spender, uint _addedValue) public returns (bool success);
113     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);
114     function mint(address _to, uint256 _amount) public returns (bool);
115     function finishMinting() public returns (bool);
116 
117     event Transfer(address indexed from, address indexed to, uint256 indexed value);
118     event Approval(address indexed owner, address indexed spender, uint256 indexed value);
119     event Mint(address indexed to, uint256 amount);
120     event MintFinished();
121 }
122 
123 /*
124 
125  * source       https://github.com/blockbitsio/
126 
127  * @name        Application Asset Contract ABI
128  * @package     BlockBitsIO
129  * @author      Micky Socaci <micky@nowlive.ro>
130 
131  Any contract inheriting this will be usable as an Asset in the Application Entity
132 
133 */
134 
135 
136 
137 contract ABIApplicationAsset {
138 
139     bytes32 public assetName;
140     uint8 public CurrentEntityState;
141     uint8 public RecordNum;
142     bool public _initialized;
143     bool public _settingsApplied;
144     address public owner;
145     address public deployerAddress;
146     mapping (bytes32 => uint8) public EntityStates;
147     mapping (bytes32 => uint8) public RecordStates;
148 
149     function setInitialApplicationAddress(address _ownerAddress) public;
150     function setInitialOwnerAndName(bytes32 _name) external returns (bool);
151     function getRecordState(bytes32 name) public view returns (uint8);
152     function getEntityState(bytes32 name) public view returns (uint8);
153     function applyAndLockSettings() public returns(bool);
154     function transferToNewOwner(address _newOwner) public returns (bool);
155     function getApplicationAssetAddressByName(bytes32 _name) public returns(address);
156     function getApplicationState() public view returns (uint8);
157     function getApplicationEntityState(bytes32 name) public view returns (uint8);
158     function getAppBylawUint256(bytes32 name) public view returns (uint256);
159     function getAppBylawBytes32(bytes32 name) public view returns (bytes32);
160     function getTimestamp() view public returns (uint256);
161 
162 
163 }
164 
165 /*
166 
167  * source       https://github.com/blockbitsio/
168 
169  * @name        Funding Contract ABI
170  * @package     BlockBitsIO
171  * @author      Micky Socaci <micky@nowlive.ro>
172 
173  Contains the Funding Contract code deployed and linked to the Application Entity
174 
175 
176     !!! Links directly to Milestones
177 
178 */
179 
180 
181 
182 
183 
184 contract ABIFunding is ABIApplicationAsset {
185 
186     address public multiSigOutputAddress;
187     address public DirectInput;
188     address public MilestoneInput;
189     address public TokenManagerEntity;
190     address public FundingManagerEntity;
191 
192     struct FundingStage {
193         bytes32 name;
194         uint8   state;
195         uint256 time_start;
196         uint256 time_end;
197         uint256 amount_cap_soft;            // 0 = not enforced
198         uint256 amount_cap_hard;            // 0 = not enforced
199         uint256 amount_raised;              // 0 = not enforced
200         // funding method settings
201         uint256 minimum_entry;
202         uint8   methods;                    // FundingMethodIds
203         // token settings
204         uint256 fixed_tokens;
205         uint8   price_addition_percentage;  //
206         uint8   token_share_percentage;
207         uint8   index;
208     }
209 
210     mapping (uint8 => FundingStage) public Collection;
211     uint8 public FundingStageNum;
212     uint8 public currentFundingStage;
213     uint256 public AmountRaised;
214     uint256 public MilestoneAmountRaised;
215     uint256 public GlobalAmountCapSoft;
216     uint256 public GlobalAmountCapHard;
217     uint8 public TokenSellPercentage;
218     uint256 public Funding_Setting_funding_time_start;
219     uint256 public Funding_Setting_funding_time_end;
220     uint256 public Funding_Setting_cashback_time_start;
221     uint256 public Funding_Setting_cashback_time_end;
222     uint256 public Funding_Setting_cashback_before_start_wait_duration;
223     uint256 public Funding_Setting_cashback_duration;
224 
225 
226     function addFundingStage(
227         bytes32 _name,
228         uint256 _time_start,
229         uint256 _time_end,
230         uint256 _amount_cap_soft,
231         uint256 _amount_cap_hard,   // required > 0
232         uint8   _methods,
233         uint256 _minimum_entry,
234         uint256 _fixed_tokens,
235         uint8   _price_addition_percentage,
236         uint8   _token_share_percentage
237     )
238     public;
239 
240     function addSettings(address _outputAddress, uint256 soft_cap, uint256 hard_cap, uint8 sale_percentage, address _direct, address _milestone ) public;
241     function getStageAmount(uint8 StageId) public view returns ( uint256 );
242     function allowedPaymentMethod(uint8 _payment_method) public pure returns (bool);
243     function receivePayment(address _sender, uint8 _payment_method) payable public returns(bool);
244     function canAcceptPayment(uint256 _amount) public view returns (bool);
245     function getValueOverCurrentCap(uint256 _amount) public view returns (uint256);
246     function isFundingStageUpdateAllowed(uint8 _new_state ) public view returns (bool);
247     function getRecordStateRequiredChanges() public view returns (uint8);
248     function doStateChanges() public;
249     function hasRequiredStateChanges() public view returns (bool);
250     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
251 
252 }
253 
254 /*
255 
256  * source       https://github.com/blockbitsio/
257 
258  * @name        Milestones Contract
259  * @package     BlockBitsIO
260  * @author      Micky Socaci <micky@nowlive.ro>
261 
262  Contains the Milestones Contract code deployed and linked to the Application Entity
263 
264 */
265 
266 
267 
268 
269 
270 contract ABIMilestones is ABIApplicationAsset {
271 
272     struct Record {
273         bytes32 name;
274         string description;                     // will change to hash pointer ( external storage )
275         uint8 state;
276         uint256 duration;
277         uint256 time_start;                     // start at unixtimestamp
278         uint256 last_state_change_time;         // time of last state change
279         uint256 time_end;                       // estimated end time >> can be increased by proposal
280         uint256 time_ended;                     // actual end time
281         uint256 meeting_time;
282         uint8 funding_percentage;
283         uint8 index;
284     }
285 
286     uint8 public currentRecord;
287     uint256 public MilestoneCashBackTime = 0;
288     mapping (uint8 => Record) public Collection;
289     mapping (bytes32 => bool) public MilestonePostponingHash;
290     mapping (bytes32 => uint256) public ProposalIdByHash;
291 
292     function getBylawsProjectDevelopmentStart() public view returns (uint256);
293     function getBylawsMinTimeInTheFutureForMeetingCreation() public view returns (uint256);
294     function getBylawsCashBackVoteRejectedDuration() public view returns (uint256);
295     function addRecord( bytes32 _name, string _description, uint256 _duration, uint8 _perc ) public;
296     function getMilestoneFundingPercentage(uint8 recordId) public view returns (uint8);
297     function doStateChanges() public;
298     function getRecordStateRequiredChanges() public view returns (uint8);
299     function hasRequiredStateChanges() public view returns (bool);
300     function afterVoteNoCashBackTime() public view returns ( bool );
301     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 );
302     function getCurrentHash() public view returns ( bytes32 );
303     function getCurrentProposalId() internal view returns ( uint256 );
304     function setCurrentMilestoneMeetingTime(uint256 _meeting_time) public;
305     function isRecordUpdateAllowed(uint8 _new_state ) public view returns (bool);
306     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
307     function ApplicationIsInDevelopment() public view returns(bool);
308     function MeetingTimeSetFailure() public view returns (bool);
309 
310 }
311 
312 /*
313 
314  * source       https://github.com/blockbitsio/
315 
316  * @name        Proposals Contract
317  * @package     BlockBitsIO
318  * @author      Micky Socaci <micky@nowlive.ro>
319 
320  Contains the Proposals Contract code deployed and linked to the Application Entity
321 
322 */
323 
324 
325 
326 
327 
328 contract ABIProposals is ABIApplicationAsset {
329 
330     address public Application;
331     address public ListingContractEntity;
332     address public FundingEntity;
333     address public FundingManagerEntity;
334     address public TokenManagerEntity;
335     address public TokenEntity;
336     address public MilestonesEntity;
337 
338     struct ProposalRecord {
339         address creator;
340         bytes32 name;
341         uint8 actionType;
342         uint8 state;
343         bytes32 hash;                       // action name + args hash
344         address addr;
345         bytes32 sourceCodeUrl;
346         uint256 extra;
347         uint256 time_start;
348         uint256 time_end;
349         uint256 index;
350     }
351 
352     struct VoteStruct {
353         address voter;
354         uint256 time;
355         bool    vote;
356         uint256 power;
357         bool    annulled;
358         uint256 index;
359     }
360 
361     struct ResultRecord {
362         uint256 totalAvailable;
363         uint256 requiredForResult;
364         uint256 totalSoFar;
365         uint256 yes;
366         uint256 no;
367         bool    requiresCounting;
368     }
369 
370     uint8 public ActiveProposalNum;
371     uint256 public VoteCountPerProcess;
372     bool public EmergencyFundingReleaseApproved;
373 
374     mapping (bytes32 => uint8) public ActionTypes;
375     mapping (uint8 => uint256) public ActiveProposalIds;
376     mapping (uint256 => bool) public ExpiredProposalIds;
377     mapping (uint256 => ProposalRecord) public ProposalsById;
378     mapping (bytes32 => uint256) public ProposalIdByHash;
379     mapping (uint256 => mapping (uint256 => VoteStruct) ) public VotesByProposalId;
380     mapping (uint256 => mapping (address => VoteStruct) ) public VotesByCaster;
381     mapping (uint256 => uint256) public VotesNumByProposalId;
382     mapping (uint256 => ResultRecord ) public ResultsByProposalId;
383     mapping (uint256 => uint256) public lastProcessedVoteIdByProposal;
384     mapping (uint256 => uint256) public ProcessedVotesByProposal;
385     mapping (uint256 => uint256) public VoteCountAtProcessingStartByProposal;
386 
387     function getRecordState(bytes32 name) public view returns (uint8);
388     function getActionType(bytes32 name) public view returns (uint8);
389     function getProposalState(uint256 _proposalId) public view returns (uint8);
390     function getBylawsProposalVotingDuration() public view returns (uint256);
391     function getBylawsMilestoneMinPostponing() public view returns (uint256);
392     function getBylawsMilestoneMaxPostponing() public view returns (uint256);
393     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 );
394     function process() public;
395     function hasRequiredStateChanges() public view returns (bool);
396     function getRequiredStateChanges() public view returns (uint8);
397     function addCodeUpgradeProposal(address _addr, bytes32 _sourceCodeUrl) external returns (uint256);
398     function createMilestoneAcceptanceProposal() external returns (uint256);
399     function createMilestonePostponingProposal(uint256 _duration) external returns (uint256);
400     function getCurrentMilestonePostponingProposalDuration() public view returns (uint256);
401     function getCurrentMilestoneProposalStatusForType(uint8 _actionType ) public view returns (uint8);
402     function createEmergencyFundReleaseProposal() external returns (uint256);
403     function createDelistingProposal(uint256 _projectId) external returns (uint256);
404     function RegisterVote(uint256 _proposalId, bool _myVote) public;
405     function hasPreviousVote(uint256 _proposalId, address _voter) public view returns (bool);
406     function getTotalTokenVotingPower(address _voter) public view returns ( uint256 );
407     function getVotingPower(uint256 _proposalId, address _voter) public view returns ( uint256 );
408     function setVoteCountPerProcess(uint256 _perProcess) external;
409     function ProcessVoteTotals(uint256 _proposalId, uint256 length) public;
410     function canEndVoting(uint256 _proposalId) public view returns (bool);
411     function getProposalType(uint256 _proposalId) public view returns (uint8);
412     function expiryChangesState(uint256 _proposalId) public view returns (bool);
413     function needsProcessing(uint256 _proposalId) public view returns (bool);
414     function getMyVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
415     function getHasVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
416     function getMyVote(uint256 _proposalId, address _voter) public view returns (bool);
417 
418 }
419 
420 /*
421 
422  * source       https://github.com/blockbitsio/
423 
424  * @name        Token Manager Contract
425  * @package     BlockBitsIO
426  * @author      Micky Socaci <micky@nowlive.ro>
427 
428 */
429 
430 
431 
432 
433 
434 contract ABITokenManager is ABIApplicationAsset {
435 
436     address public TokenSCADAEntity;
437     address public TokenEntity;
438     address public MarketingMethodAddress;
439     bool OwnerTokenBalancesReleased = false;
440 
441     function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) public;
442     function getTokenSCADARequiresHardCap() public view returns (bool);
443     function mint(address _to, uint256 _amount) public returns (bool);
444     function finishMinting() public returns (bool);
445     function mintForMarketingPool(address _to, uint256 _amount) external returns (bool);
446     function ReleaseOwnersLockedTokens(address _multiSigOutputAddress) public returns (bool);
447 
448 }
449 
450 /*
451 
452  * source       https://github.com/blockbitsio/
453 
454  * @name        Funding Contract ABI
455  * @package     BlockBitsIO
456  * @author      Micky Socaci <micky@nowlive.ro>
457 
458  Contains the Funding Contract code deployed and linked to the Application Entity
459 
460 */
461 
462 
463 
464 
465 
466 contract ABIFundingManager is ABIApplicationAsset {
467 
468     bool public fundingProcessed;
469     bool FundingPoolBalancesAllocated;
470     uint8 public VaultCountPerProcess;
471     uint256 public lastProcessedVaultId;
472     uint256 public vaultNum;
473     uint256 public LockedVotingTokens;
474     bytes32 public currentTask;
475     mapping (bytes32 => bool) public taskByHash;
476     mapping  (address => address) public vaultList;
477     mapping  (uint256 => address) public vaultById;
478 
479     function receivePayment(address _sender, uint8 _payment_method, uint8 _funding_stage) payable public returns(bool);
480     function getMyVaultAddress(address _sender) public view returns (address);
481     function setVaultCountPerProcess(uint8 _perProcess) external;
482     function getHash(bytes32 actionType, bytes32 arg1) public pure returns ( bytes32 );
483     function getCurrentMilestoneProcessed() public view returns (bool);
484     function processFundingFailedFinished() public view returns (bool);
485     function processFundingSuccessfulFinished() public view returns (bool);
486     function getCurrentMilestoneIdHash() internal view returns (bytes32);
487     function processMilestoneFinished() public view returns (bool);
488     function processEmergencyFundReleaseFinished() public view returns (bool);
489     function getAfterTransferLockedTokenBalances(address vaultAddress, bool excludeCurrent) public view returns (uint256);
490     function VaultRequestedUpdateForLockedVotingTokens(address owner) public;
491     function doStateChanges() public;
492     function hasRequiredStateChanges() public view returns (bool);
493     function getRequiredStateChanges() public view returns (uint8, uint8);
494     function ApplicationInFundingOrDevelopment() public view returns(bool);
495 
496 }
497 
498 /*
499 
500  * source       https://github.com/blockbitsio/
501 
502  * @name        Token Stake Calculation And Distribution Algorithm - Type 3 - Sell a variable amount of tokens for a fixed price
503  * @package     BlockBitsIO
504  * @author      Micky Socaci <micky@nowlive.ro>
505 
506 
507     Inputs:
508 
509     Defined number of tokens per wei ( X Tokens = 1 wei )
510     Received amount of ETH
511     Generates:
512 
513     Total Supply of tokens available in Funding Phase respectively Project
514     Observations:
515 
516     Will sell the whole supply of Tokens available to Current Funding Phase
517     Use cases:
518 
519     Any Funding Phase where you want the first Funding Phase to determine the token supply of the whole Project
520 
521 */
522 
523 
524 
525 
526 contract ABITokenSCADAVariable {
527     bool public SCADA_requires_hard_cap = true;
528     bool public initialized;
529     address public deployerAddress;
530     function addSettings(address _fundingContract) public;
531     function requiresHardCap() public view returns (bool);
532     function getTokensForValueInCurrentStage(uint256 _value) public view returns (uint256);
533     function getTokensForValueInStage(uint8 _stage, uint256 _value) public view returns (uint256);
534     function getBoughtTokens( address _vaultAddress, bool _direct ) public view returns (uint256);
535 }
536 
537 /*
538 
539  * source       https://github.com/blockbitsio/
540 
541  * @name        Funding Vault
542  * @package     BlockBitsIO
543  * @author      Micky Socaci <micky@nowlive.ro>
544 
545     each purchase creates a separate funding vault contract
546 */
547 
548 
549 contract FundingVault {
550 
551     /* Asset initialised or not */
552     bool public _initialized = false;
553 
554     /*
555         Addresses:
556         vaultOwner - the address of the wallet that stores purchases in this vault ( investor address )
557         outputAddress - address where funds go upon successful funding or successful milestone release
558         managerAddress - address of the "FundingManager"
559     */
560     address public vaultOwner ;
561     address public outputAddress;
562     address public managerAddress;
563 
564     /*
565         Lock and BlackHole settings
566     */
567 
568     bool public allFundingProcessed = false;
569     bool public DirectFundingProcessed = false;
570 
571     /*
572         Assets
573     */
574     // ApplicationEntityABI public ApplicationEntity;
575     ABIFunding FundingEntity;
576     ABIFundingManager FundingManagerEntity;
577     ABIMilestones MilestonesEntity;
578     ABIProposals ProposalsEntity;
579     ABITokenSCADAVariable TokenSCADAEntity;
580     ABIToken TokenEntity ;
581 
582     /*
583         Globals
584     */
585     uint256 public amount_direct = 0;
586     uint256 public amount_milestone = 0;
587 
588     // bylaws
589     bool public emergencyFundReleased = false;
590     uint8 emergencyFundPercentage = 0;
591     uint256 BylawsCashBackOwnerMiaDuration;
592     uint256 BylawsCashBackVoteRejectedDuration;
593     uint256 BylawsProposalVotingDuration;
594 
595     struct PurchaseStruct {
596         uint256 unix_time;
597         uint8 payment_method;
598         uint256 amount;
599         uint8 funding_stage;
600         uint16 index;
601     }
602 
603     mapping(uint16 => PurchaseStruct) public purchaseRecords;
604     uint16 public purchaseRecordsNum;
605 
606     event EventPaymentReceived(uint8 indexed _payment_method, uint256 indexed _amount, uint16 indexed _index );
607     event VaultInitialized(address indexed _owner);
608 
609     function initialize(
610         address _owner,
611         address _output,
612         address _fundingAddress,
613         address _milestoneAddress,
614         address _proposalsAddress
615     )
616         public
617         requireNotInitialised
618         returns(bool)
619     {
620         VaultInitialized(_owner);
621 
622         outputAddress = _output;
623         vaultOwner = _owner;
624 
625         // whomever creates this contract is the manager.
626         managerAddress = msg.sender;
627 
628         // assets
629         FundingEntity = ABIFunding(_fundingAddress);
630         FundingManagerEntity = ABIFundingManager(managerAddress);
631         MilestonesEntity = ABIMilestones(_milestoneAddress);
632         ProposalsEntity = ABIProposals(_proposalsAddress);
633 
634         address TokenManagerAddress = FundingEntity.getApplicationAssetAddressByName("TokenManager");
635         ABITokenManager TokenManagerEntity = ABITokenManager(TokenManagerAddress);
636 
637         address TokenAddress = TokenManagerEntity.TokenEntity();
638         TokenEntity = ABIToken(TokenAddress);
639 
640         address TokenSCADAAddress = TokenManagerEntity.TokenSCADAEntity();
641         TokenSCADAEntity = ABITokenSCADAVariable(TokenSCADAAddress);
642 
643         // set Emergency Fund Percentage if available.
644         address ApplicationEntityAddress = TokenManagerEntity.owner();
645         ApplicationEntityABI ApplicationEntity = ApplicationEntityABI(ApplicationEntityAddress);
646 
647         // get Application Bylaws
648         emergencyFundPercentage             = uint8( ApplicationEntity.getBylawUint256("emergency_fund_percentage") );
649         BylawsCashBackOwnerMiaDuration      = ApplicationEntity.getBylawUint256("cashback_owner_mia_dur") ;
650         BylawsCashBackVoteRejectedDuration  = ApplicationEntity.getBylawUint256("cashback_investor_no") ;
651         BylawsProposalVotingDuration        = ApplicationEntity.getBylawUint256("proposal_voting_duration") ;
652 
653         // init
654         _initialized = true;
655         return true;
656     }
657 
658 
659 
660     /*
661         The funding contract decides if a vault should receive payments or not, since it's the one that creates them,
662         no point in creating one if you can't accept payments.
663     */
664 
665     mapping (uint8 => uint256) public stageAmounts;
666     mapping (uint8 => uint256) public stageAmountsDirect;
667 
668     function addPayment(
669         uint8 _payment_method,
670         uint8 _funding_stage
671     )
672         public
673         payable
674         requireInitialised
675         onlyManager
676         returns (bool)
677     {
678         if(msg.value > 0 && FundingEntity.allowedPaymentMethod(_payment_method)) {
679 
680             // store payment
681             PurchaseStruct storage purchase = purchaseRecords[++purchaseRecordsNum];
682                 purchase.unix_time = now;
683                 purchase.payment_method = _payment_method;
684                 purchase.amount = msg.value;
685                 purchase.funding_stage = _funding_stage;
686                 purchase.index = purchaseRecordsNum;
687 
688             // assign payment to direct or milestone
689             if(_payment_method == 1) {
690                 amount_direct+= purchase.amount;
691                 stageAmountsDirect[_funding_stage]+=purchase.amount;
692             }
693 
694             if(_payment_method == 2) {
695                 amount_milestone+= purchase.amount;
696             }
697 
698             // in order to not iterate through purchase records, we just increase funding stage amount.
699             // issue with iterating over them, while processing vaults, would be that someone could create a large
700             // number of payments, which would result in an "out of gas" / stack overflow issue, that would lock
701             // our contract, so we don't really want to do that.
702             // doing it this way also saves some gas
703             stageAmounts[_funding_stage]+=purchase.amount;
704 
705             EventPaymentReceived( purchase.payment_method, purchase.amount, purchase.index );
706             return true;
707         } else {
708             revert();
709         }
710     }
711 
712     function getBoughtTokens() public view returns (uint256) {
713         return TokenSCADAEntity.getBoughtTokens( address(this), false );
714     }
715 
716     function getDirectBoughtTokens() public view returns (uint256) {
717         return TokenSCADAEntity.getBoughtTokens( address(this), true );
718     }
719 
720 
721     mapping (uint8 => uint256) public etherBalances;
722     mapping (uint8 => uint256) public tokenBalances;
723     uint8 public BalanceNum = 0;
724 
725     bool public BalancesInitialised = false;
726     function initMilestoneTokenAndEtherBalances() internal
727     {
728         if(BalancesInitialised == false) {
729 
730             uint256 milestoneTokenBalance = TokenEntity.balanceOf(address(this));
731             uint256 milestoneEtherBalance = this.balance;
732 
733             // no need to worry about fractions because at the last milestone, we send everything that's left.
734 
735             // emergency fund takes it's percentage from initial balances.
736             if(emergencyFundPercentage > 0) {
737                 tokenBalances[0] = milestoneTokenBalance / 100 * emergencyFundPercentage;
738                 etherBalances[0] = milestoneEtherBalance / 100 * emergencyFundPercentage;
739 
740                 milestoneTokenBalance-=tokenBalances[0];
741                 milestoneEtherBalance-=etherBalances[0];
742             }
743 
744             // milestones percentages are then taken from what's left.
745             for(uint8 i = 1; i <= MilestonesEntity.RecordNum(); i++) {
746 
747                 uint8 perc = MilestonesEntity.getMilestoneFundingPercentage(i);
748                 tokenBalances[i] = milestoneTokenBalance / 100 * perc;
749                 etherBalances[i] = milestoneEtherBalance / 100 * perc;
750             }
751 
752             BalanceNum = i;
753             BalancesInitialised = true;
754         }
755     }
756 
757     function ReleaseFundsAndTokens()
758         public
759         requireInitialised
760         onlyManager
761         returns (bool)
762     {
763         // first make sure cashback is not possible, and that we've not processed everything in this vault
764         if(!canCashBack() && allFundingProcessed == false) {
765 
766             if(FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState("FUNDING_SUCCESSFUL_PROGRESS")) {
767 
768                 // case 1, direct funding only
769                 if(amount_direct > 0 && amount_milestone == 0) {
770 
771                     // if we have direct funding and no milestone balance, transfer everything and lock vault
772                     // to save gas in future processing runs.
773 
774                     // transfer tokens to the investor
775                     TokenEntity.transfer(vaultOwner, TokenEntity.balanceOf( address(this) ) );
776 
777                     // transfer ether to the owner's wallet
778                     outputAddress.transfer(this.balance);
779 
780                     // lock vault.. and enable black hole methods
781                     allFundingProcessed = true;
782 
783                 } else {
784                 // case 2 and 3, direct funding only
785 
786                     if(amount_direct > 0 && DirectFundingProcessed == false ) {
787                         TokenEntity.transfer(vaultOwner, getDirectBoughtTokens() );
788                         // transfer "direct funding" ether to the owner's wallet
789                         outputAddress.transfer(amount_direct);
790                         DirectFundingProcessed = true;
791                     }
792 
793                     // process and initialize milestone balances, emergency fund, etc, once
794                     initMilestoneTokenAndEtherBalances();
795                 }
796                 return true;
797 
798             } else if(FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState("MILESTONE_PROCESS_PROGRESS")) {
799 
800                 // get current milestone so we know which one we need to release funds for.
801                 uint8 milestoneId = MilestonesEntity.currentRecord();
802 
803                 uint256 transferTokens = tokenBalances[milestoneId];
804                 uint256 transferEther = etherBalances[milestoneId];
805 
806                 if(milestoneId == BalanceNum - 1) {
807                     // we're processing the last milestone and balance, this means we're transferring everything left.
808                     // this is done to make sure we've transferred everything, even "ether that got mistakenly sent to this address"
809                     // as well as the emergency fund if it has not been used.
810                     transferTokens = TokenEntity.balanceOf(address(this));
811                     transferEther = this.balance;
812                 }
813 
814                 // set balances to 0 so we can't transfer multiple times.
815                 // tokenBalances[milestoneId] = 0;
816                 // etherBalances[milestoneId] = 0;
817 
818                 // transfer tokens to the investor
819                 TokenEntity.transfer(vaultOwner, transferTokens );
820 
821                 // transfer ether to the owner's wallet
822                 outputAddress.transfer(transferEther);
823 
824                 if(milestoneId == BalanceNum - 1) {
825                     // lock vault.. and enable black hole methods
826                     allFundingProcessed = true;
827                 }
828 
829                 return true;
830             }
831         }
832 
833         return false;
834     }
835 
836 
837     function releaseTokensAndEtherForEmergencyFund()
838         public
839         requireInitialised
840         onlyManager
841         returns (bool)
842     {
843         if( emergencyFundReleased == false && emergencyFundPercentage > 0) {
844 
845             // transfer tokens to the investor
846             TokenEntity.transfer(vaultOwner, tokenBalances[0] );
847 
848             // transfer ether to the owner's wallet
849             outputAddress.transfer(etherBalances[0]);
850 
851             emergencyFundReleased = true;
852             return true;
853         }
854         return false;
855     }
856 
857     function ReleaseFundsToInvestor()
858         public
859         requireInitialised
860         isOwner
861     {
862         if(canCashBack()) {
863 
864             // IF we're doing a cashback
865             // transfer vault tokens back to owner address
866             // send all ether to wallet owner
867 
868             // get token balance
869             uint256 myBalance = TokenEntity.balanceOf(address(this));
870             // transfer all vault tokens to owner
871             if(myBalance > 0) {
872                 TokenEntity.transfer(outputAddress, myBalance );
873             }
874 
875             // now transfer all remaining ether back to investor address
876             vaultOwner.transfer(this.balance);
877 
878             // update FundingManager Locked Token Amount, so we don't break voting
879             FundingManagerEntity.VaultRequestedUpdateForLockedVotingTokens( vaultOwner );
880 
881             // disallow further processing, so we don't break Funding Manager.
882             // this method can still be called to collect future black hole ether to this vault.
883             allFundingProcessed = true;
884         }
885     }
886 
887     /*
888         1 - if the funding of the project Failed, allows investors to claim their locked ether back.
889         2 - if the Investor votes NO to a Development Milestone Completion Proposal, where the majority
890             also votes NO allows investors to claim their locked ether back.
891         3 - project owner misses to set the time for a Development Milestone Completion Meeting allows investors
892         to claim their locked ether back.
893     */
894     function canCashBack() public view requireInitialised returns (bool) {
895 
896         // case 1
897         if(checkFundingStateFailed()) {
898             return true;
899         }
900         // case 2
901         if(checkMilestoneStateInvestorVotedNoVotingEndedNo()) {
902             return true;
903         }
904         // case 3
905         if(checkOwnerFailedToSetTimeOnMeeting()) {
906             return true;
907         }
908 
909         return false;
910     }
911 
912     function checkFundingStateFailed() public view returns (bool) {
913         if(FundingEntity.CurrentEntityState() == FundingEntity.getEntityState("FAILED_FINAL") ) {
914             return true;
915         }
916 
917         // also check if funding period ended, and 7 days have passed and no processing was done.
918         if( FundingEntity.getTimestamp() >= FundingEntity.Funding_Setting_cashback_time_start() ) {
919 
920             // should only be possible if funding entity has been stuck in processing for more than 7 days.
921             if( FundingEntity.CurrentEntityState() != FundingEntity.getEntityState("SUCCESSFUL_FINAL") ) {
922                 return true;
923             }
924         }
925 
926         return false;
927     }
928 
929     function checkMilestoneStateInvestorVotedNoVotingEndedNo() public view returns (bool) {
930         if(MilestonesEntity.CurrentEntityState() == MilestonesEntity.getEntityState("VOTING_ENDED_NO") ) {
931             // first we need to make sure we actually voted.
932             if( ProposalsEntity.getHasVoteForCurrentMilestoneRelease(vaultOwner) == true) {
933                 // now make sure we voted NO, and if so return true
934                 if( ProposalsEntity.getMyVoteForCurrentMilestoneRelease( vaultOwner ) == false) {
935                     return true;
936                 }
937             }
938         }
939         return false;
940     }
941 
942     function checkOwnerFailedToSetTimeOnMeeting() public view returns (bool) {
943         // Looks like the project owner is missing in action
944         // they only have to do 1 thing, which is set the meeting time 7 days before the end of the milestone so that
945         // investors know when they need to show up for a progress report meeting
946 
947         // as they did not, we consider them missing in action and allow investors to retrieve their locked ether back
948         if( MilestonesEntity.CurrentEntityState() == MilestonesEntity.getEntityState("DEADLINE_MEETING_TIME_FAILED") ) {
949             return true;
950         }
951         return false;
952     }
953 
954 
955     modifier isOwner() {
956         require(msg.sender == vaultOwner);
957         _;
958     }
959 
960     modifier onlyManager() {
961         require(msg.sender == managerAddress);
962         _;
963     }
964 
965     modifier requireInitialised() {
966         require(_initialized == true);
967         _;
968     }
969 
970     modifier requireNotInitialised() {
971         require(_initialized == false);
972         _;
973     }
974 }