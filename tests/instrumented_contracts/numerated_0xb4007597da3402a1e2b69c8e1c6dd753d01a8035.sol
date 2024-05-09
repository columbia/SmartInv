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
83  * @name        Application Asset Contract
84  * @package     BlockBitsIO
85  * @author      Micky Socaci <micky@nowlive.ro>
86 
87  Any contract inheriting this will be usable as an Asset in the Application Entity
88 
89 */
90 
91 
92 
93 
94 contract ApplicationAsset {
95 
96     event EventAppAssetOwnerSet(bytes32 indexed _name, address indexed _owner);
97     event EventRunBeforeInit(bytes32 indexed _name);
98     event EventRunBeforeApplyingSettings(bytes32 indexed _name);
99 
100 
101     mapping (bytes32 => uint8) public EntityStates;
102     mapping (bytes32 => uint8) public RecordStates;
103     uint8 public CurrentEntityState;
104 
105     event EventEntityProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);
106     event DebugEntityRequiredChanges( bytes32 _assetName, uint8 indexed _current, uint8 indexed _required );
107 
108     bytes32 public assetName;
109 
110     /* Asset records */
111     uint8 public RecordNum = 0;
112 
113     /* Asset initialised or not */
114     bool public _initialized = false;
115 
116     /* Asset settings present or not */
117     bool public _settingsApplied = false;
118 
119     /* Asset owner ( ApplicationEntity address ) */
120     address public owner = address(0x0) ;
121     address public deployerAddress;
122 
123     function ApplicationAsset() public {
124         deployerAddress = msg.sender;
125     }
126 
127     function setInitialApplicationAddress(address _ownerAddress) public onlyDeployer requireNotInitialised {
128         owner = _ownerAddress;
129     }
130 
131     function setInitialOwnerAndName(bytes32 _name) external
132         requireNotInitialised
133         onlyOwner
134         returns (bool)
135     {
136         // init states
137         setAssetStates();
138         assetName = _name;
139         // set initial state
140         CurrentEntityState = getEntityState("NEW");
141         runBeforeInitialization();
142         _initialized = true;
143         EventAppAssetOwnerSet(_name, owner);
144         return true;
145     }
146 
147     function setAssetStates() internal {
148         // Asset States
149         EntityStates["__IGNORED__"]     = 0;
150         EntityStates["NEW"]             = 1;
151         // Funding Stage States
152         RecordStates["__IGNORED__"]     = 0;
153     }
154 
155     function getRecordState(bytes32 name) public view returns (uint8) {
156         return RecordStates[name];
157     }
158 
159     function getEntityState(bytes32 name) public view returns (uint8) {
160         return EntityStates[name];
161     }
162 
163     function runBeforeInitialization() internal requireNotInitialised  {
164         EventRunBeforeInit(assetName);
165     }
166 
167     function applyAndLockSettings()
168         public
169         onlyDeployer
170         requireInitialised
171         requireSettingsNotApplied
172         returns(bool)
173     {
174         runBeforeApplyingSettings();
175         _settingsApplied = true;
176         return true;
177     }
178 
179     function runBeforeApplyingSettings() internal requireInitialised requireSettingsNotApplied  {
180         EventRunBeforeApplyingSettings(assetName);
181     }
182 
183     function transferToNewOwner(address _newOwner) public requireInitialised onlyOwner returns (bool) {
184         require(owner != address(0x0) && _newOwner != address(0x0));
185         owner = _newOwner;
186         EventAppAssetOwnerSet(assetName, owner);
187         return true;
188     }
189 
190     function getApplicationAssetAddressByName(bytes32 _name)
191         public
192         view
193         returns(address)
194     {
195         address asset = ApplicationEntityABI(owner).getAssetAddressByName(_name);
196         if( asset != address(0x0) ) {
197             return asset;
198         } else {
199             revert();
200         }
201     }
202 
203     function getApplicationState() public view returns (uint8) {
204         return ApplicationEntityABI(owner).CurrentEntityState();
205     }
206 
207     function getApplicationEntityState(bytes32 name) public view returns (uint8) {
208         return ApplicationEntityABI(owner).getEntityState(name);
209     }
210 
211     function getAppBylawUint256(bytes32 name) public view requireInitialised returns (uint256) {
212         ApplicationEntityABI CurrentApp = ApplicationEntityABI(owner);
213         return CurrentApp.getBylawUint256(name);
214     }
215 
216     function getAppBylawBytes32(bytes32 name) public view requireInitialised returns (bytes32) {
217         ApplicationEntityABI CurrentApp = ApplicationEntityABI(owner);
218         return CurrentApp.getBylawBytes32(name);
219     }
220 
221     modifier onlyOwner() {
222         require(msg.sender == owner);
223         _;
224     }
225 
226     modifier onlyApplicationEntity() {
227         require(msg.sender == owner);
228         _;
229     }
230 
231     modifier requireInitialised() {
232         require(_initialized == true);
233         _;
234     }
235 
236     modifier requireNotInitialised() {
237         require(_initialized == false);
238         _;
239     }
240 
241     modifier requireSettingsApplied() {
242         require(_settingsApplied == true);
243         _;
244     }
245 
246     modifier requireSettingsNotApplied() {
247         require(_settingsApplied == false);
248         _;
249     }
250 
251     modifier onlyDeployer() {
252         require(msg.sender == deployerAddress);
253         _;
254     }
255 
256     modifier onlyAsset(bytes32 _name) {
257         address AssetAddress = getApplicationAssetAddressByName(_name);
258         require( msg.sender == AssetAddress);
259         _;
260     }
261 
262     function getTimestamp() view public returns (uint256) {
263         return now;
264     }
265 
266 
267 }
268 
269 /*
270 
271  * source       https://github.com/blockbitsio/
272 
273  * @name        Application Asset Contract ABI
274  * @package     BlockBitsIO
275  * @author      Micky Socaci <micky@nowlive.ro>
276 
277  Any contract inheriting this will be usable as an Asset in the Application Entity
278 
279 */
280 
281 
282 
283 contract ABIApplicationAsset {
284 
285     bytes32 public assetName;
286     uint8 public CurrentEntityState;
287     uint8 public RecordNum;
288     bool public _initialized;
289     bool public _settingsApplied;
290     address public owner;
291     address public deployerAddress;
292     mapping (bytes32 => uint8) public EntityStates;
293     mapping (bytes32 => uint8) public RecordStates;
294 
295     function setInitialApplicationAddress(address _ownerAddress) public;
296     function setInitialOwnerAndName(bytes32 _name) external returns (bool);
297     function getRecordState(bytes32 name) public view returns (uint8);
298     function getEntityState(bytes32 name) public view returns (uint8);
299     function applyAndLockSettings() public returns(bool);
300     function transferToNewOwner(address _newOwner) public returns (bool);
301     function getApplicationAssetAddressByName(bytes32 _name) public returns(address);
302     function getApplicationState() public view returns (uint8);
303     function getApplicationEntityState(bytes32 name) public view returns (uint8);
304     function getAppBylawUint256(bytes32 name) public view returns (uint256);
305     function getAppBylawBytes32(bytes32 name) public view returns (bytes32);
306     function getTimestamp() view public returns (uint256);
307 
308 
309 }
310 
311 /*
312 
313  * source       https://github.com/blockbitsio/
314 
315  * @name        Token Manager Contract
316  * @package     BlockBitsIO
317  * @author      Micky Socaci <micky@nowlive.ro>
318 
319 */
320 
321 
322 
323 
324 
325 contract ABITokenManager is ABIApplicationAsset {
326 
327     address public TokenSCADAEntity;
328     address public TokenEntity;
329     address public MarketingMethodAddress;
330     bool OwnerTokenBalancesReleased = false;
331 
332     function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) public;
333     function getTokenSCADARequiresHardCap() public view returns (bool);
334     function mint(address _to, uint256 _amount) public returns (bool);
335     function finishMinting() public returns (bool);
336     function mintForMarketingPool(address _to, uint256 _amount) external returns (bool);
337     function ReleaseOwnersLockedTokens(address _multiSigOutputAddress) public returns (bool);
338 
339 }
340 
341 /*
342 
343  * source       https://github.com/blockbitsio/
344 
345  * @name        Proposals Contract
346  * @package     BlockBitsIO
347  * @author      Micky Socaci <micky@nowlive.ro>
348 
349  Contains the Proposals Contract code deployed and linked to the Application Entity
350 
351 */
352 
353 
354 
355 
356 
357 contract ABIProposals is ABIApplicationAsset {
358 
359     address public Application;
360     address public ListingContractEntity;
361     address public FundingEntity;
362     address public FundingManagerEntity;
363     address public TokenManagerEntity;
364     address public TokenEntity;
365     address public MilestonesEntity;
366 
367     struct ProposalRecord {
368         address creator;
369         bytes32 name;
370         uint8 actionType;
371         uint8 state;
372         bytes32 hash;                       // action name + args hash
373         address addr;
374         bytes32 sourceCodeUrl;
375         uint256 extra;
376         uint256 time_start;
377         uint256 time_end;
378         uint256 index;
379     }
380 
381     struct VoteStruct {
382         address voter;
383         uint256 time;
384         bool    vote;
385         uint256 power;
386         bool    annulled;
387         uint256 index;
388     }
389 
390     struct ResultRecord {
391         uint256 totalAvailable;
392         uint256 requiredForResult;
393         uint256 totalSoFar;
394         uint256 yes;
395         uint256 no;
396         bool    requiresCounting;
397     }
398 
399     uint8 public ActiveProposalNum;
400     uint256 public VoteCountPerProcess;
401     bool public EmergencyFundingReleaseApproved;
402 
403     mapping (bytes32 => uint8) public ActionTypes;
404     mapping (uint8 => uint256) public ActiveProposalIds;
405     mapping (uint256 => bool) public ExpiredProposalIds;
406     mapping (uint256 => ProposalRecord) public ProposalsById;
407     mapping (bytes32 => uint256) public ProposalIdByHash;
408     mapping (uint256 => mapping (uint256 => VoteStruct) ) public VotesByProposalId;
409     mapping (uint256 => mapping (address => VoteStruct) ) public VotesByCaster;
410     mapping (uint256 => uint256) public VotesNumByProposalId;
411     mapping (uint256 => ResultRecord ) public ResultsByProposalId;
412     mapping (uint256 => uint256) public lastProcessedVoteIdByProposal;
413     mapping (uint256 => uint256) public ProcessedVotesByProposal;
414     mapping (uint256 => uint256) public VoteCountAtProcessingStartByProposal;
415 
416     function getRecordState(bytes32 name) public view returns (uint8);
417     function getActionType(bytes32 name) public view returns (uint8);
418     function getProposalState(uint256 _proposalId) public view returns (uint8);
419     function getBylawsProposalVotingDuration() public view returns (uint256);
420     function getBylawsMilestoneMinPostponing() public view returns (uint256);
421     function getBylawsMilestoneMaxPostponing() public view returns (uint256);
422     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 );
423     function process() public;
424     function hasRequiredStateChanges() public view returns (bool);
425     function getRequiredStateChanges() public view returns (uint8);
426     function addCodeUpgradeProposal(address _addr, bytes32 _sourceCodeUrl) external returns (uint256);
427     function createMilestoneAcceptanceProposal() external returns (uint256);
428     function createMilestonePostponingProposal(uint256 _duration) external returns (uint256);
429     function getCurrentMilestonePostponingProposalDuration() public view returns (uint256);
430     function getCurrentMilestoneProposalStatusForType(uint8 _actionType ) public view returns (uint8);
431     function createEmergencyFundReleaseProposal() external returns (uint256);
432     function createDelistingProposal(uint256 _projectId) external returns (uint256);
433     function RegisterVote(uint256 _proposalId, bool _myVote) public;
434     function hasPreviousVote(uint256 _proposalId, address _voter) public view returns (bool);
435     function getTotalTokenVotingPower(address _voter) public view returns ( uint256 );
436     function getVotingPower(uint256 _proposalId, address _voter) public view returns ( uint256 );
437     function setVoteCountPerProcess(uint256 _perProcess) external;
438     function ProcessVoteTotals(uint256 _proposalId, uint256 length) public;
439     function canEndVoting(uint256 _proposalId) public view returns (bool);
440     function getProposalType(uint256 _proposalId) public view returns (uint8);
441     function expiryChangesState(uint256 _proposalId) public view returns (bool);
442     function needsProcessing(uint256 _proposalId) public view returns (bool);
443     function getMyVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
444     function getHasVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
445     function getMyVote(uint256 _proposalId, address _voter) public view returns (bool);
446 
447 }
448 
449 /*
450 
451  * source       https://github.com/blockbitsio/
452 
453  * @name        Milestones Contract
454  * @package     BlockBitsIO
455  * @author      Micky Socaci <micky@nowlive.ro>
456 
457  Contains the Milestones Contract code deployed and linked to the Application Entity
458 
459 */
460 
461 
462 
463 
464 
465 contract ABIMilestones is ABIApplicationAsset {
466 
467     struct Record {
468         bytes32 name;
469         string description;                     // will change to hash pointer ( external storage )
470         uint8 state;
471         uint256 duration;
472         uint256 time_start;                     // start at unixtimestamp
473         uint256 last_state_change_time;         // time of last state change
474         uint256 time_end;                       // estimated end time >> can be increased by proposal
475         uint256 time_ended;                     // actual end time
476         uint256 meeting_time;
477         uint8 funding_percentage;
478         uint8 index;
479     }
480 
481     uint8 public currentRecord;
482     uint256 public MilestoneCashBackTime = 0;
483     mapping (uint8 => Record) public Collection;
484     mapping (bytes32 => bool) public MilestonePostponingHash;
485     mapping (bytes32 => uint256) public ProposalIdByHash;
486 
487     function getBylawsProjectDevelopmentStart() public view returns (uint256);
488     function getBylawsMinTimeInTheFutureForMeetingCreation() public view returns (uint256);
489     function getBylawsCashBackVoteRejectedDuration() public view returns (uint256);
490     function addRecord( bytes32 _name, string _description, uint256 _duration, uint8 _perc ) public;
491     function getMilestoneFundingPercentage(uint8 recordId) public view returns (uint8);
492     function doStateChanges() public;
493     function getRecordStateRequiredChanges() public view returns (uint8);
494     function hasRequiredStateChanges() public view returns (bool);
495     function afterVoteNoCashBackTime() public view returns ( bool );
496     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 );
497     function getCurrentHash() public view returns ( bytes32 );
498     function getCurrentProposalId() internal view returns ( uint256 );
499     function setCurrentMilestoneMeetingTime(uint256 _meeting_time) public;
500     function isRecordUpdateAllowed(uint8 _new_state ) public view returns (bool);
501     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
502     function ApplicationIsInDevelopment() public view returns(bool);
503     function MeetingTimeSetFailure() public view returns (bool);
504 
505 }
506 
507 /*
508 
509  * source       https://github.com/blockbitsio/
510 
511  * @name        Funding Contract ABI
512  * @package     BlockBitsIO
513  * @author      Micky Socaci <micky@nowlive.ro>
514 
515  Contains the Funding Contract code deployed and linked to the Application Entity
516 
517 
518     !!! Links directly to Milestones
519 
520 */
521 
522 
523 
524 
525 
526 contract ABIFunding is ABIApplicationAsset {
527 
528     address public multiSigOutputAddress;
529     address public DirectInput;
530     address public MilestoneInput;
531     address public TokenManagerEntity;
532     address public FundingManagerEntity;
533 
534     struct FundingStage {
535         bytes32 name;
536         uint8   state;
537         uint256 time_start;
538         uint256 time_end;
539         uint256 amount_cap_soft;            // 0 = not enforced
540         uint256 amount_cap_hard;            // 0 = not enforced
541         uint256 amount_raised;              // 0 = not enforced
542         // funding method settings
543         uint256 minimum_entry;
544         uint8   methods;                    // FundingMethodIds
545         // token settings
546         uint256 fixed_tokens;
547         uint8   price_addition_percentage;  //
548         uint8   token_share_percentage;
549         uint8   index;
550     }
551 
552     mapping (uint8 => FundingStage) public Collection;
553     uint8 public FundingStageNum;
554     uint8 public currentFundingStage;
555     uint256 public AmountRaised;
556     uint256 public MilestoneAmountRaised;
557     uint256 public GlobalAmountCapSoft;
558     uint256 public GlobalAmountCapHard;
559     uint8 public TokenSellPercentage;
560     uint256 public Funding_Setting_funding_time_start;
561     uint256 public Funding_Setting_funding_time_end;
562     uint256 public Funding_Setting_cashback_time_start;
563     uint256 public Funding_Setting_cashback_time_end;
564     uint256 public Funding_Setting_cashback_before_start_wait_duration;
565     uint256 public Funding_Setting_cashback_duration;
566 
567 
568     function addFundingStage(
569         bytes32 _name,
570         uint256 _time_start,
571         uint256 _time_end,
572         uint256 _amount_cap_soft,
573         uint256 _amount_cap_hard,   // required > 0
574         uint8   _methods,
575         uint256 _minimum_entry,
576         uint256 _fixed_tokens,
577         uint8   _price_addition_percentage,
578         uint8   _token_share_percentage
579     )
580     public;
581 
582     function addSettings(address _outputAddress, uint256 soft_cap, uint256 hard_cap, uint8 sale_percentage, address _direct, address _milestone ) public;
583     function getStageAmount(uint8 StageId) public view returns ( uint256 );
584     function allowedPaymentMethod(uint8 _payment_method) public pure returns (bool);
585     function receivePayment(address _sender, uint8 _payment_method) payable public returns(bool);
586     function canAcceptPayment(uint256 _amount) public view returns (bool);
587     function getValueOverCurrentCap(uint256 _amount) public view returns (uint256);
588     function isFundingStageUpdateAllowed(uint8 _new_state ) public view returns (bool);
589     function getRecordStateRequiredChanges() public view returns (uint8);
590     function doStateChanges() public;
591     function hasRequiredStateChanges() public view returns (bool);
592     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
593 
594 }
595 
596 /*
597 
598  * source       https://github.com/blockbitsio/
599 
600  * @name        Token Contract
601  * @package     BlockBitsIO
602  * @author      Micky Socaci <micky@nowlive.ro>
603 
604  Zeppelin ERC20 Standard Token
605 
606 */
607 
608 
609 
610 contract ABIToken {
611 
612     string public  symbol;
613     string public  name;
614     uint8 public   decimals;
615     uint256 public totalSupply;
616     string public  version;
617     mapping (address => uint256) public balances;
618     mapping (address => mapping (address => uint256)) allowed;
619     address public manager;
620     address public deployer;
621     bool public mintingFinished = false;
622     bool public initialized = false;
623 
624     function transfer(address _to, uint256 _value) public returns (bool);
625     function balanceOf(address _owner) public view returns (uint256 balance);
626     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
627     function approve(address _spender, uint256 _value) public returns (bool);
628     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
629     function increaseApproval(address _spender, uint _addedValue) public returns (bool success);
630     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);
631     function mint(address _to, uint256 _amount) public returns (bool);
632     function finishMinting() public returns (bool);
633 
634     event Transfer(address indexed from, address indexed to, uint256 indexed value);
635     event Approval(address indexed owner, address indexed spender, uint256 indexed value);
636     event Mint(address indexed to, uint256 amount);
637     event MintFinished();
638 }
639 
640 /*
641 
642  * source       https://github.com/blockbitsio/
643 
644  * @name        Token Stake Calculation And Distribution Algorithm - Type 3 - Sell a variable amount of tokens for a fixed price
645  * @package     BlockBitsIO
646  * @author      Micky Socaci <micky@nowlive.ro>
647 
648 
649     Inputs:
650 
651     Defined number of tokens per wei ( X Tokens = 1 wei )
652     Received amount of ETH
653     Generates:
654 
655     Total Supply of tokens available in Funding Phase respectively Project
656     Observations:
657 
658     Will sell the whole supply of Tokens available to Current Funding Phase
659     Use cases:
660 
661     Any Funding Phase where you want the first Funding Phase to determine the token supply of the whole Project
662 
663 */
664 
665 
666 
667 
668 contract ABITokenSCADAVariable {
669     bool public SCADA_requires_hard_cap = true;
670     bool public initialized;
671     address public deployerAddress;
672     function addSettings(address _fundingContract) public;
673     function requiresHardCap() public view returns (bool);
674     function getTokensForValueInCurrentStage(uint256 _value) public view returns (uint256);
675     function getTokensForValueInStage(uint8 _stage, uint256 _value) public view returns (uint256);
676     function getBoughtTokens( address _vaultAddress, bool _direct ) public view returns (uint256);
677 }
678 
679 /*
680 
681  * source       https://github.com/blockbitsio/
682 
683  * @name        Funding Contract ABI
684  * @package     BlockBitsIO
685  * @author      Micky Socaci <micky@nowlive.ro>
686 
687  Contains the Funding Contract code deployed and linked to the Application Entity
688 
689 */
690 
691 
692 
693 
694 
695 contract ABIFundingManager is ABIApplicationAsset {
696 
697     bool public fundingProcessed;
698     bool FundingPoolBalancesAllocated;
699     uint8 public VaultCountPerProcess;
700     uint256 public lastProcessedVaultId;
701     uint256 public vaultNum;
702     uint256 public LockedVotingTokens;
703     bytes32 public currentTask;
704     mapping (bytes32 => bool) public taskByHash;
705     mapping  (address => address) public vaultList;
706     mapping  (uint256 => address) public vaultById;
707 
708     function receivePayment(address _sender, uint8 _payment_method, uint8 _funding_stage) payable public returns(bool);
709     function getMyVaultAddress(address _sender) public view returns (address);
710     function setVaultCountPerProcess(uint8 _perProcess) external;
711     function getHash(bytes32 actionType, bytes32 arg1) public pure returns ( bytes32 );
712     function getCurrentMilestoneProcessed() public view returns (bool);
713     function processFundingFailedFinished() public view returns (bool);
714     function processFundingSuccessfulFinished() public view returns (bool);
715     function getCurrentMilestoneIdHash() internal view returns (bytes32);
716     function processMilestoneFinished() public view returns (bool);
717     function processEmergencyFundReleaseFinished() public view returns (bool);
718     function getAfterTransferLockedTokenBalances(address vaultAddress, bool excludeCurrent) public view returns (uint256);
719     function VaultRequestedUpdateForLockedVotingTokens(address owner) public;
720     function doStateChanges() public;
721     function hasRequiredStateChanges() public view returns (bool);
722     function getRequiredStateChanges() public view returns (uint8, uint8);
723     function ApplicationInFundingOrDevelopment() public view returns(bool);
724 
725 }
726 
727 /*
728 
729  * source       https://github.com/blockbitsio/
730 
731  * @name        Funding Vault
732  * @package     BlockBitsIO
733  * @author      Micky Socaci <micky@nowlive.ro>
734 
735     each purchase creates a separate funding vault contract
736 */
737 
738 
739 
740 
741 
742 
743 
744 
745 
746 
747 
748 
749 
750 contract FundingVault {
751 
752     /* Asset initialised or not */
753     bool public _initialized = false;
754 
755     /*
756         Addresses:
757         vaultOwner - the address of the wallet that stores purchases in this vault ( investor address )
758         outputAddress - address where funds go upon successful funding or successful milestone release
759         managerAddress - address of the "FundingManager"
760     */
761     address public vaultOwner ;
762     address public outputAddress;
763     address public managerAddress;
764 
765     /*
766         Lock and BlackHole settings
767     */
768 
769     bool public allFundingProcessed = false;
770     bool public DirectFundingProcessed = false;
771 
772     /*
773         Assets
774     */
775     // ApplicationEntityABI public ApplicationEntity;
776     ABIFunding FundingEntity;
777     ABIFundingManager FundingManagerEntity;
778     ABIMilestones MilestonesEntity;
779     ABIProposals ProposalsEntity;
780     ABITokenSCADAVariable TokenSCADAEntity;
781     ABIToken TokenEntity ;
782 
783     /*
784         Globals
785     */
786     uint256 public amount_direct = 0;
787     uint256 public amount_milestone = 0;
788 
789     // bylaws
790     bool public emergencyFundReleased = false;
791     uint8 emergencyFundPercentage = 0;
792     uint256 BylawsCashBackOwnerMiaDuration;
793     uint256 BylawsCashBackVoteRejectedDuration;
794     uint256 BylawsProposalVotingDuration;
795 
796     struct PurchaseStruct {
797         uint256 unix_time;
798         uint8 payment_method;
799         uint256 amount;
800         uint8 funding_stage;
801         uint16 index;
802     }
803 
804     mapping(uint16 => PurchaseStruct) public purchaseRecords;
805     uint16 public purchaseRecordsNum;
806 
807     event EventPaymentReceived(uint8 indexed _payment_method, uint256 indexed _amount, uint16 indexed _index );
808     event VaultInitialized(address indexed _owner);
809 
810     function initialize(
811         address _owner,
812         address _output,
813         address _fundingAddress,
814         address _milestoneAddress,
815         address _proposalsAddress
816     )
817         public
818         requireNotInitialised
819         returns(bool)
820     {
821         VaultInitialized(_owner);
822 
823         outputAddress = _output;
824         vaultOwner = _owner;
825 
826         // whomever creates this contract is the manager.
827         managerAddress = msg.sender;
828 
829         // assets
830         FundingEntity = ABIFunding(_fundingAddress);
831         FundingManagerEntity = ABIFundingManager(managerAddress);
832         MilestonesEntity = ABIMilestones(_milestoneAddress);
833         ProposalsEntity = ABIProposals(_proposalsAddress);
834 
835         address TokenManagerAddress = FundingEntity.getApplicationAssetAddressByName("TokenManager");
836         ABITokenManager TokenManagerEntity = ABITokenManager(TokenManagerAddress);
837 
838         address TokenAddress = TokenManagerEntity.TokenEntity();
839         TokenEntity = ABIToken(TokenAddress);
840 
841         address TokenSCADAAddress = TokenManagerEntity.TokenSCADAEntity();
842         TokenSCADAEntity = ABITokenSCADAVariable(TokenSCADAAddress);
843 
844         // set Emergency Fund Percentage if available.
845         address ApplicationEntityAddress = TokenManagerEntity.owner();
846         ApplicationEntityABI ApplicationEntity = ApplicationEntityABI(ApplicationEntityAddress);
847 
848         // get Application Bylaws
849         emergencyFundPercentage             = uint8( ApplicationEntity.getBylawUint256("emergency_fund_percentage") );
850         BylawsCashBackOwnerMiaDuration      = ApplicationEntity.getBylawUint256("cashback_owner_mia_dur") ;
851         BylawsCashBackVoteRejectedDuration  = ApplicationEntity.getBylawUint256("cashback_investor_no") ;
852         BylawsProposalVotingDuration        = ApplicationEntity.getBylawUint256("proposal_voting_duration") ;
853 
854         // init
855         _initialized = true;
856         return true;
857     }
858 
859 
860 
861     /*
862         The funding contract decides if a vault should receive payments or not, since it's the one that creates them,
863         no point in creating one if you can't accept payments.
864     */
865 
866     mapping (uint8 => uint256) public stageAmounts;
867     mapping (uint8 => uint256) public stageAmountsDirect;
868 
869     function addPayment(
870         uint8 _payment_method,
871         uint8 _funding_stage
872     )
873         public
874         payable
875         requireInitialised
876         onlyManager
877         returns (bool)
878     {
879         if(msg.value > 0 && FundingEntity.allowedPaymentMethod(_payment_method)) {
880 
881             // store payment
882             PurchaseStruct storage purchase = purchaseRecords[++purchaseRecordsNum];
883                 purchase.unix_time = now;
884                 purchase.payment_method = _payment_method;
885                 purchase.amount = msg.value;
886                 purchase.funding_stage = _funding_stage;
887                 purchase.index = purchaseRecordsNum;
888 
889             // assign payment to direct or milestone
890             if(_payment_method == 1) {
891                 amount_direct+= purchase.amount;
892                 stageAmountsDirect[_funding_stage]+=purchase.amount;
893             }
894 
895             if(_payment_method == 2) {
896                 amount_milestone+= purchase.amount;
897             }
898 
899             // in order to not iterate through purchase records, we just increase funding stage amount.
900             // issue with iterating over them, while processing vaults, would be that someone could create a large
901             // number of payments, which would result in an "out of gas" / stack overflow issue, that would lock
902             // our contract, so we don't really want to do that.
903             // doing it this way also saves some gas
904             stageAmounts[_funding_stage]+=purchase.amount;
905 
906             EventPaymentReceived( purchase.payment_method, purchase.amount, purchase.index );
907             return true;
908         } else {
909             revert();
910         }
911     }
912 
913     function getBoughtTokens() public view returns (uint256) {
914         return TokenSCADAEntity.getBoughtTokens( address(this), false );
915     }
916 
917     function getDirectBoughtTokens() public view returns (uint256) {
918         return TokenSCADAEntity.getBoughtTokens( address(this), true );
919     }
920 
921 
922     mapping (uint8 => uint256) public etherBalances;
923     mapping (uint8 => uint256) public tokenBalances;
924     uint8 public BalanceNum = 0;
925 
926     bool public BalancesInitialised = false;
927     function initMilestoneTokenAndEtherBalances() internal
928     {
929         if(BalancesInitialised == false) {
930 
931             uint256 milestoneTokenBalance = TokenEntity.balanceOf(address(this));
932             uint256 milestoneEtherBalance = this.balance;
933 
934             // no need to worry about fractions because at the last milestone, we send everything that's left.
935 
936             // emergency fund takes it's percentage from initial balances.
937             if(emergencyFundPercentage > 0) {
938                 tokenBalances[0] = milestoneTokenBalance / 100 * emergencyFundPercentage;
939                 etherBalances[0] = milestoneEtherBalance / 100 * emergencyFundPercentage;
940 
941                 milestoneTokenBalance-=tokenBalances[0];
942                 milestoneEtherBalance-=etherBalances[0];
943             }
944 
945             // milestones percentages are then taken from what's left.
946             for(uint8 i = 1; i <= MilestonesEntity.RecordNum(); i++) {
947 
948                 uint8 perc = MilestonesEntity.getMilestoneFundingPercentage(i);
949                 tokenBalances[i] = milestoneTokenBalance / 100 * perc;
950                 etherBalances[i] = milestoneEtherBalance / 100 * perc;
951             }
952 
953             BalanceNum = i;
954             BalancesInitialised = true;
955         }
956     }
957 
958     function ReleaseFundsAndTokens()
959         public
960         requireInitialised
961         onlyManager
962         returns (bool)
963     {
964         // first make sure cashback is not possible, and that we've not processed everything in this vault
965         if(!canCashBack() && allFundingProcessed == false) {
966 
967             if(FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState("FUNDING_SUCCESSFUL_PROGRESS")) {
968 
969                 // case 1, direct funding only
970                 if(amount_direct > 0 && amount_milestone == 0) {
971 
972                     // if we have direct funding and no milestone balance, transfer everything and lock vault
973                     // to save gas in future processing runs.
974 
975                     // transfer tokens to the investor
976                     TokenEntity.transfer(vaultOwner, TokenEntity.balanceOf( address(this) ) );
977 
978                     // transfer ether to the owner's wallet
979                     outputAddress.transfer(this.balance);
980 
981                     // lock vault.. and enable black hole methods
982                     allFundingProcessed = true;
983 
984                 } else {
985                 // case 2 and 3, direct funding only
986 
987                     if(amount_direct > 0 && DirectFundingProcessed == false ) {
988                         TokenEntity.transfer(vaultOwner, getDirectBoughtTokens() );
989                         // transfer "direct funding" ether to the owner's wallet
990                         outputAddress.transfer(amount_direct);
991                         DirectFundingProcessed = true;
992                     }
993 
994                     // process and initialize milestone balances, emergency fund, etc, once
995                     initMilestoneTokenAndEtherBalances();
996                 }
997                 return true;
998 
999             } else if(FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState("MILESTONE_PROCESS_PROGRESS")) {
1000 
1001                 // get current milestone so we know which one we need to release funds for.
1002                 uint8 milestoneId = MilestonesEntity.currentRecord();
1003 
1004                 uint256 transferTokens = tokenBalances[milestoneId];
1005                 uint256 transferEther = etherBalances[milestoneId];
1006 
1007                 if(milestoneId == BalanceNum - 1) {
1008                     // we're processing the last milestone and balance, this means we're transferring everything left.
1009                     // this is done to make sure we've transferred everything, even "ether that got mistakenly sent to this address"
1010                     // as well as the emergency fund if it has not been used.
1011                     transferTokens = TokenEntity.balanceOf(address(this));
1012                     transferEther = this.balance;
1013                 }
1014 
1015                 // set balances to 0 so we can't transfer multiple times.
1016                 // tokenBalances[milestoneId] = 0;
1017                 // etherBalances[milestoneId] = 0;
1018 
1019                 // transfer tokens to the investor
1020                 TokenEntity.transfer(vaultOwner, transferTokens );
1021 
1022                 // transfer ether to the owner's wallet
1023                 outputAddress.transfer(transferEther);
1024 
1025                 if(milestoneId == BalanceNum - 1) {
1026                     // lock vault.. and enable black hole methods
1027                     allFundingProcessed = true;
1028                 }
1029 
1030                 return true;
1031             }
1032         }
1033 
1034         return false;
1035     }
1036 
1037 
1038     function releaseTokensAndEtherForEmergencyFund()
1039         public
1040         requireInitialised
1041         onlyManager
1042         returns (bool)
1043     {
1044         if( emergencyFundReleased == false && emergencyFundPercentage > 0) {
1045 
1046             // transfer tokens to the investor
1047             TokenEntity.transfer(vaultOwner, tokenBalances[0] );
1048 
1049             // transfer ether to the owner's wallet
1050             outputAddress.transfer(etherBalances[0]);
1051 
1052             emergencyFundReleased = true;
1053             return true;
1054         }
1055         return false;
1056     }
1057 
1058     function ReleaseFundsToInvestor()
1059         public
1060         requireInitialised
1061         isOwner
1062     {
1063         if(canCashBack()) {
1064 
1065             // IF we're doing a cashback
1066             // transfer vault tokens back to owner address
1067             // send all ether to wallet owner
1068 
1069             // get token balance
1070             uint256 myBalance = TokenEntity.balanceOf(address(this));
1071             // transfer all vault tokens to owner
1072             if(myBalance > 0) {
1073                 TokenEntity.transfer(outputAddress, myBalance );
1074             }
1075 
1076             // now transfer all remaining ether back to investor address
1077             vaultOwner.transfer(this.balance);
1078 
1079             // update FundingManager Locked Token Amount, so we don't break voting
1080             FundingManagerEntity.VaultRequestedUpdateForLockedVotingTokens( vaultOwner );
1081 
1082             // disallow further processing, so we don't break Funding Manager.
1083             // this method can still be called to collect future black hole ether to this vault.
1084             allFundingProcessed = true;
1085         }
1086     }
1087 
1088     /*
1089         1 - if the funding of the project Failed, allows investors to claim their locked ether back.
1090         2 - if the Investor votes NO to a Development Milestone Completion Proposal, where the majority
1091             also votes NO allows investors to claim their locked ether back.
1092         3 - project owner misses to set the time for a Development Milestone Completion Meeting allows investors
1093         to claim their locked ether back.
1094     */
1095     function canCashBack() public view requireInitialised returns (bool) {
1096 
1097         // case 1
1098         if(checkFundingStateFailed()) {
1099             return true;
1100         }
1101         // case 2
1102         if(checkMilestoneStateInvestorVotedNoVotingEndedNo()) {
1103             return true;
1104         }
1105         // case 3
1106         if(checkOwnerFailedToSetTimeOnMeeting()) {
1107             return true;
1108         }
1109 
1110         return false;
1111     }
1112 
1113     function checkFundingStateFailed() public view returns (bool) {
1114         if(FundingEntity.CurrentEntityState() == FundingEntity.getEntityState("FAILED_FINAL") ) {
1115             return true;
1116         }
1117 
1118         // also check if funding period ended, and 7 days have passed and no processing was done.
1119         if( FundingEntity.getTimestamp() >= FundingEntity.Funding_Setting_cashback_time_start() ) {
1120 
1121             // should only be possible if funding entity has been stuck in processing for more than 7 days.
1122             if( FundingEntity.CurrentEntityState() != FundingEntity.getEntityState("SUCCESSFUL_FINAL") ) {
1123                 return true;
1124             }
1125         }
1126 
1127         return false;
1128     }
1129 
1130     function checkMilestoneStateInvestorVotedNoVotingEndedNo() public view returns (bool) {
1131         if(MilestonesEntity.CurrentEntityState() == MilestonesEntity.getEntityState("VOTING_ENDED_NO") ) {
1132             // first we need to make sure we actually voted.
1133             if( ProposalsEntity.getHasVoteForCurrentMilestoneRelease(vaultOwner) == true) {
1134                 // now make sure we voted NO, and if so return true
1135                 if( ProposalsEntity.getMyVoteForCurrentMilestoneRelease( vaultOwner ) == false) {
1136                     return true;
1137                 }
1138             }
1139         }
1140         return false;
1141     }
1142 
1143     function checkOwnerFailedToSetTimeOnMeeting() public view returns (bool) {
1144         // Looks like the project owner is missing in action
1145         // they only have to do 1 thing, which is set the meeting time 7 days before the end of the milestone so that
1146         // investors know when they need to show up for a progress report meeting
1147 
1148         // as they did not, we consider them missing in action and allow investors to retrieve their locked ether back
1149         if( MilestonesEntity.CurrentEntityState() == MilestonesEntity.getEntityState("DEADLINE_MEETING_TIME_FAILED") ) {
1150             return true;
1151         }
1152         return false;
1153     }
1154 
1155 
1156     modifier isOwner() {
1157         require(msg.sender == vaultOwner);
1158         _;
1159     }
1160 
1161     modifier onlyManager() {
1162         require(msg.sender == managerAddress);
1163         _;
1164     }
1165 
1166     modifier requireInitialised() {
1167         require(_initialized == true);
1168         _;
1169     }
1170 
1171     modifier requireNotInitialised() {
1172         require(_initialized == false);
1173         _;
1174     }
1175 }
1176 
1177 /*
1178 
1179  * source       https://github.com/blockbitsio/
1180 
1181  * @name        Funding Contract
1182  * @package     BlockBitsIO
1183  * @author      Micky Socaci <micky@nowlive.ro>
1184 
1185  Contains the Funding Contract code deployed and linked to the Application Entity
1186 
1187 */
1188 
1189 
1190 
1191 
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 
1200 
1201 
1202 
1203 contract FundingManager is ApplicationAsset {
1204 
1205     ABIFunding FundingEntity;
1206     ABITokenManager TokenManagerEntity;
1207     ABIToken TokenEntity;
1208     ABITokenSCADAVariable TokenSCADAEntity;
1209     ABIProposals ProposalsEntity;
1210     ABIMilestones MilestonesEntity;
1211 
1212     uint256 public LockedVotingTokens = 0;
1213 
1214     event EventFundingManagerReceivedPayment(address indexed _vault, uint8 indexed _payment_method, uint256 indexed _amount );
1215     event EventFundingManagerProcessedVault(address _vault, uint256 id );
1216 
1217     mapping  (address => address) public vaultList;
1218     mapping  (uint256 => address) public vaultById;
1219     uint256 public vaultNum = 0;
1220 
1221     function setAssetStates() internal {
1222         // Asset States
1223         EntityStates["__IGNORED__"]                 = 0;
1224         EntityStates["NEW"]                         = 1;
1225         EntityStates["WAITING"]                     = 2;
1226 
1227         EntityStates["FUNDING_FAILED_START"]        = 10;
1228         EntityStates["FUNDING_FAILED_PROGRESS"]     = 11;
1229         EntityStates["FUNDING_FAILED_DONE"]         = 12;
1230 
1231         EntityStates["FUNDING_SUCCESSFUL_START"]    = 20;
1232         EntityStates["FUNDING_SUCCESSFUL_PROGRESS"] = 21;
1233         EntityStates["FUNDING_SUCCESSFUL_DONE"]     = 22;
1234         EntityStates["FUNDING_SUCCESSFUL_ALLOCATE"] = 25;
1235 
1236 
1237         EntityStates["MILESTONE_PROCESS_START"]     = 30;
1238         EntityStates["MILESTONE_PROCESS_PROGRESS"]  = 31;
1239         EntityStates["MILESTONE_PROCESS_DONE"]      = 32;
1240 
1241         EntityStates["EMERGENCY_PROCESS_START"]     = 40;
1242         EntityStates["EMERGENCY_PROCESS_PROGRESS"]  = 41;
1243         EntityStates["EMERGENCY_PROCESS_DONE"]      = 42;
1244 
1245 
1246         EntityStates["COMPLETE_PROCESS_START"]     = 100;
1247         EntityStates["COMPLETE_PROCESS_PROGRESS"]  = 101;
1248         EntityStates["COMPLETE_PROCESS_DONE"]      = 102;
1249 
1250         // Funding Stage States
1251         RecordStates["__IGNORED__"]     = 0;
1252 
1253     }
1254 
1255     function runBeforeApplyingSettings()
1256         internal
1257         requireInitialised
1258         requireSettingsNotApplied
1259     {
1260         address FundingAddress = getApplicationAssetAddressByName('Funding');
1261         FundingEntity = ABIFunding(FundingAddress);
1262         EventRunBeforeApplyingSettings(assetName);
1263 
1264         address TokenManagerAddress = getApplicationAssetAddressByName('TokenManager');
1265         TokenManagerEntity = ABITokenManager(TokenManagerAddress);
1266 
1267         TokenEntity = ABIToken(TokenManagerEntity.TokenEntity());
1268 
1269         address TokenSCADAAddress = TokenManagerEntity.TokenSCADAEntity();
1270         TokenSCADAEntity = ABITokenSCADAVariable(TokenSCADAAddress) ;
1271 
1272         address MilestonesAddress = getApplicationAssetAddressByName('Milestones');
1273         MilestonesEntity = ABIMilestones(MilestonesAddress) ;
1274 
1275         address ProposalsAddress = getApplicationAssetAddressByName('Proposals');
1276         ProposalsEntity = ABIProposals(ProposalsAddress) ;
1277     }
1278 
1279 
1280 
1281     function receivePayment(address _sender, uint8 _payment_method, uint8 _funding_stage)
1282         payable
1283         public
1284         requireInitialised
1285         onlyAsset('Funding')
1286         returns(bool)
1287     {
1288         // check that msg.value is higher than 0, don't really want to have to deal with minus in case the network breaks this somehow
1289         if(msg.value > 0) {
1290             FundingVault vault;
1291 
1292             // no vault present
1293             if(!hasVault(_sender)) {
1294                 // create and initialize a new one
1295                 vault = new FundingVault();
1296                 if(vault.initialize(
1297                     _sender,
1298                     FundingEntity.multiSigOutputAddress(),
1299                     address(FundingEntity),
1300                     address(getApplicationAssetAddressByName('Milestones')),
1301                     address(getApplicationAssetAddressByName('Proposals'))
1302                 )) {
1303                     // store new vault address.
1304                     vaultList[_sender] = vault;
1305                     // increase internal vault number
1306                     vaultNum++;
1307                     // assign vault to by int registry
1308                     vaultById[vaultNum] = vault;
1309 
1310                 } else {
1311                     revert();
1312                 }
1313             } else {
1314                 // use existing vault
1315                 vault = FundingVault(vaultList[_sender]);
1316             }
1317 
1318             EventFundingManagerReceivedPayment(vault, _payment_method, msg.value);
1319 
1320             if( vault.addPayment.value(msg.value)( _payment_method, _funding_stage ) ) {
1321 
1322                 // if payment is received in the vault then mint tokens based on the received value!
1323                 TokenManagerEntity.mint( vault, TokenSCADAEntity.getTokensForValueInCurrentStage(msg.value) );
1324 
1325                 return true;
1326             } else {
1327                 revert();
1328             }
1329         } else {
1330             revert();
1331         }
1332     }
1333 
1334     function getMyVaultAddress(address _sender) public view returns (address) {
1335         return vaultList[_sender];
1336     }
1337 
1338     function hasVault(address _sender) internal view returns(bool) {
1339         if(vaultList[_sender] != address(0x0)) {
1340             return true;
1341         } else {
1342             return false;
1343         }
1344     }
1345 
1346     bool public fundingProcessed = false;
1347     uint256 public lastProcessedVaultId = 0;
1348     uint8 public VaultCountPerProcess = 10;
1349     bytes32 public currentTask = "";
1350 
1351     mapping (bytes32 => bool) public taskByHash;
1352 
1353     function setVaultCountPerProcess(uint8 _perProcess) external onlyDeployer {
1354         if(_perProcess > 0) {
1355             VaultCountPerProcess = _perProcess;
1356         } else {
1357             revert();
1358         }
1359     }
1360 
1361     function getHash(bytes32 actionType, bytes32 arg1) public pure returns ( bytes32 ) {
1362         return keccak256(actionType, arg1);
1363     }
1364 
1365     function getCurrentMilestoneProcessed() public view returns (bool) {
1366         return taskByHash[ getHash("MILESTONE_PROCESS_START", getCurrentMilestoneIdHash() ) ];
1367     }
1368 
1369 
1370 
1371     function ProcessVaultList(uint8 length) internal {
1372 
1373         if(taskByHash[currentTask] == false) {
1374             if(
1375                 CurrentEntityState == getEntityState("FUNDING_FAILED_PROGRESS") ||
1376                 CurrentEntityState == getEntityState("FUNDING_SUCCESSFUL_PROGRESS") ||
1377                 CurrentEntityState == getEntityState("MILESTONE_PROCESS_PROGRESS") ||
1378                 CurrentEntityState == getEntityState("EMERGENCY_PROCESS_PROGRESS") ||
1379                 CurrentEntityState == getEntityState("COMPLETE_PROCESS_PROGRESS")
1380             ) {
1381 
1382                 uint256 start = lastProcessedVaultId + 1;
1383                 uint256 end = start + length - 1;
1384 
1385                 if(end > vaultNum) {
1386                     end = vaultNum;
1387                 }
1388 
1389                 // first run
1390                 if(start == 1) {
1391                     // reset LockedVotingTokens, as we reindex them
1392                     LockedVotingTokens = 0;
1393                 }
1394 
1395                 for(uint256 i = start; i <= end; i++) {
1396                     address currentVault = vaultById[i];
1397                     EventFundingManagerProcessedVault(currentVault, i);
1398                     ProcessFundingVault(currentVault);
1399                     lastProcessedVaultId++;
1400                 }
1401                 if(lastProcessedVaultId >= vaultNum ) {
1402                     // reset iterator and set task state to true so we can't call it again.
1403                     lastProcessedVaultId = 0;
1404                     taskByHash[currentTask] = true;
1405                 }
1406             } else {
1407                 revert();
1408             }
1409         } else {
1410             revert();
1411         }
1412     }
1413 
1414     function processFundingFailedFinished() public view returns (bool) {
1415         bytes32 thisHash = getHash("FUNDING_FAILED_START", "");
1416         return taskByHash[thisHash];
1417     }
1418 
1419     function processFundingSuccessfulFinished() public view returns (bool) {
1420         bytes32 thisHash = getHash("FUNDING_SUCCESSFUL_START", "");
1421         return taskByHash[thisHash];
1422     }
1423 
1424     function getCurrentMilestoneIdHash() internal view returns (bytes32) {
1425         return bytes32(MilestonesEntity.currentRecord());
1426     }
1427 
1428     function processMilestoneFinished() public view returns (bool) {
1429         bytes32 thisHash = getHash("MILESTONE_PROCESS_START", getCurrentMilestoneIdHash());
1430         return taskByHash[thisHash];
1431     }
1432 
1433     function processEmergencyFundReleaseFinished() public view returns (bool) {
1434         bytes32 thisHash = getHash("EMERGENCY_PROCESS_START", bytes32(0));
1435         return taskByHash[thisHash];
1436     }
1437 
1438     function ProcessFundingVault(address vaultAddress ) internal {
1439         FundingVault vault = FundingVault(vaultAddress);
1440 
1441         if(vault.allFundingProcessed() == false) {
1442 
1443             if(CurrentEntityState == getEntityState("FUNDING_SUCCESSFUL_PROGRESS")) {
1444 
1445                 // tokens are minted and allocated to this vault when it receives payments.
1446                 // vault should now hold as many tokens as the investor bought using direct and milestone funding,
1447                 // as well as the ether they sent
1448                 // "direct funding" release -> funds to owner / tokens to investor
1449                 if(!vault.ReleaseFundsAndTokens()) {
1450                     revert();
1451                 }
1452 
1453             } else if(CurrentEntityState == getEntityState("MILESTONE_PROCESS_PROGRESS")) {
1454                 // release funds to owner / tokens to investor
1455                 if(!vault.ReleaseFundsAndTokens()) {
1456                     revert();
1457                 }
1458 
1459             } else if(CurrentEntityState == getEntityState("EMERGENCY_PROCESS_PROGRESS")) {
1460                 // release emergency funds to owner / tokens to investor
1461                 if(!vault.releaseTokensAndEtherForEmergencyFund()) {
1462                     revert();
1463                 }
1464             }
1465 
1466             // For proposal voting, we need to know how many investor locked tokens remain.
1467             LockedVotingTokens+= getAfterTransferLockedTokenBalances(vaultAddress, true);
1468 
1469         }
1470     }
1471 
1472     function getAfterTransferLockedTokenBalances(address vaultAddress, bool excludeCurrent) public view returns (uint256) {
1473         FundingVault vault = FundingVault(vaultAddress);
1474         uint8 currentMilestone = MilestonesEntity.currentRecord();
1475 
1476         uint256 LockedBalance = 0;
1477         // handle emergency funding first
1478         if(vault.emergencyFundReleased() == false) {
1479             LockedBalance+=vault.tokenBalances(0);
1480         }
1481 
1482         // get token balances starting from current
1483         uint8 start = currentMilestone;
1484 
1485         if(CurrentEntityState != getEntityState("FUNDING_SUCCESSFUL_PROGRESS")) {
1486             if(excludeCurrent == true) {
1487                 start++;
1488             }
1489         }
1490 
1491         for(uint8 i = start; i < vault.BalanceNum() ; i++) {
1492             LockedBalance+=vault.tokenBalances(i);
1493         }
1494         return LockedBalance;
1495 
1496     }
1497 
1498     function VaultRequestedUpdateForLockedVotingTokens(address owner) public {
1499         // validate sender
1500         address vaultAddress = vaultList[owner];
1501         if(msg.sender == vaultAddress){
1502             // get token balances starting from current
1503             LockedVotingTokens-= getAfterTransferLockedTokenBalances(vaultAddress, false);
1504         }
1505     }
1506 
1507     bool FundingPoolBalancesAllocated = false;
1508 
1509     function AllocateAfterFundingBalances() internal {
1510         // allocate owner, advisor, bounty pools
1511         if(FundingPoolBalancesAllocated == false) {
1512 
1513             // mint em!
1514             uint256 mintedSupply = TokenEntity.totalSupply();
1515             uint256 salePercent = getAppBylawUint256("token_sale_percentage");
1516 
1517             // find one percent
1518             uint256 onePercent = (mintedSupply * 1 / salePercent * 100) / 100;
1519 
1520             // bounty tokens
1521             uint256 bountyPercent = getAppBylawUint256("token_bounty_percentage");
1522             uint256 bountyValue = onePercent * bountyPercent;
1523 
1524             address BountyManagerAddress = getApplicationAssetAddressByName("BountyManager");
1525             TokenManagerEntity.mint( BountyManagerAddress, bountyValue );
1526 
1527             // project tokens
1528             // should be 40
1529             uint256 projectPercent = 100 - salePercent - bountyPercent;
1530             uint256 projectValue = onePercent * projectPercent;
1531 
1532             // project tokens get minted to Token Manager's address, and are locked there
1533             TokenManagerEntity.mint( TokenManagerEntity, projectValue );
1534             TokenManagerEntity.finishMinting();
1535 
1536             FundingPoolBalancesAllocated = true;
1537         }
1538     }
1539 
1540 
1541     function doStateChanges() public {
1542 
1543         var (returnedCurrentEntityState, EntityStateRequired) = getRequiredStateChanges();
1544         bool callAgain = false;
1545 
1546         DebugEntityRequiredChanges( assetName, returnedCurrentEntityState, EntityStateRequired );
1547 
1548         if(EntityStateRequired != getEntityState("__IGNORED__") ) {
1549             EntityProcessor(EntityStateRequired);
1550             callAgain = true;
1551         }
1552     }
1553 
1554     function hasRequiredStateChanges() public view returns (bool) {
1555         bool hasChanges = false;
1556         var (returnedCurrentEntityState, EntityStateRequired) = getRequiredStateChanges();
1557         // suppress unused local variable warning
1558         returnedCurrentEntityState = 0;
1559         if(EntityStateRequired != getEntityState("__IGNORED__") ) {
1560             hasChanges = true;
1561         }
1562         return hasChanges;
1563     }
1564 
1565     function EntityProcessor(uint8 EntityStateRequired) internal {
1566 
1567         EventEntityProcessor( assetName, CurrentEntityState, EntityStateRequired );
1568 
1569         // Update our Entity State
1570         CurrentEntityState = EntityStateRequired;
1571         // Do State Specific Updates
1572 
1573 // Funding Failed
1574         if ( EntityStateRequired == getEntityState("FUNDING_FAILED_START") ) {
1575             // set ProcessVaultList Task
1576             currentTask = getHash("FUNDING_FAILED_START", "");
1577             CurrentEntityState = getEntityState("FUNDING_FAILED_PROGRESS");
1578         } else if ( EntityStateRequired == getEntityState("FUNDING_FAILED_PROGRESS") ) {
1579             ProcessVaultList(VaultCountPerProcess);
1580 
1581 // Funding Successful
1582         } else if ( EntityStateRequired == getEntityState("FUNDING_SUCCESSFUL_START") ) {
1583 
1584             // init SCADA variable cache.
1585             //if(TokenSCADAEntity.initCacheForVariables()) {
1586 
1587             // start processing vaults
1588             currentTask = getHash("FUNDING_SUCCESSFUL_START", "");
1589             CurrentEntityState = getEntityState("FUNDING_SUCCESSFUL_PROGRESS");
1590 
1591         } else if ( EntityStateRequired == getEntityState("FUNDING_SUCCESSFUL_PROGRESS") ) {
1592             ProcessVaultList(VaultCountPerProcess);
1593 
1594         } else if ( EntityStateRequired == getEntityState("FUNDING_SUCCESSFUL_ALLOCATE") ) {
1595             AllocateAfterFundingBalances();
1596 
1597 // Milestones
1598         } else if ( EntityStateRequired == getEntityState("MILESTONE_PROCESS_START") ) {
1599             currentTask = getHash("MILESTONE_PROCESS_START", getCurrentMilestoneIdHash() );
1600             CurrentEntityState = getEntityState("MILESTONE_PROCESS_PROGRESS");
1601 
1602         } else if ( EntityStateRequired == getEntityState("MILESTONE_PROCESS_PROGRESS") ) {
1603             ProcessVaultList(VaultCountPerProcess);
1604 
1605 // Emergency funding release
1606         } else if ( EntityStateRequired == getEntityState("EMERGENCY_PROCESS_START") ) {
1607             currentTask = getHash("EMERGENCY_PROCESS_START", bytes32(0) );
1608             CurrentEntityState = getEntityState("EMERGENCY_PROCESS_PROGRESS");
1609         } else if ( EntityStateRequired == getEntityState("EMERGENCY_PROCESS_PROGRESS") ) {
1610             ProcessVaultList(VaultCountPerProcess);
1611 
1612 // Completion
1613         } else if ( EntityStateRequired == getEntityState("COMPLETE_PROCESS_START") ) {
1614             currentTask = getHash("COMPLETE_PROCESS_START", "");
1615             CurrentEntityState = getEntityState("COMPLETE_PROCESS_PROGRESS");
1616 
1617         } else if ( EntityStateRequired == getEntityState("COMPLETE_PROCESS_PROGRESS") ) {
1618             // release platform owner tokens from token manager
1619             TokenManagerEntity.ReleaseOwnersLockedTokens( FundingEntity.multiSigOutputAddress() );
1620             CurrentEntityState = getEntityState("COMPLETE_PROCESS_DONE");
1621         }
1622 
1623     }
1624 
1625     /*
1626      * Method: Get Entity Required State Changes
1627      *
1628      * @access       public
1629      * @type         method
1630      *
1631      * @return       ( uint8 CurrentEntityState, uint8 EntityStateRequired )
1632      */
1633     function getRequiredStateChanges() public view returns (uint8, uint8) {
1634 
1635         uint8 EntityStateRequired = getEntityState("__IGNORED__");
1636 
1637         if(ApplicationInFundingOrDevelopment()) {
1638 
1639             if ( CurrentEntityState == getEntityState("WAITING") ) {
1640                 /*
1641                     This is where we decide if we should process something
1642                 */
1643 
1644                 // For funding
1645                 if(FundingEntity.CurrentEntityState() == FundingEntity.getEntityState("FAILED")) {
1646                     EntityStateRequired = getEntityState("FUNDING_FAILED_START");
1647                 }
1648                 else if(FundingEntity.CurrentEntityState() == FundingEntity.getEntityState("SUCCESSFUL")) {
1649                     // make sure we haven't processed this yet
1650                     if(taskByHash[ getHash("FUNDING_SUCCESSFUL_START", "") ] == false) {
1651                         EntityStateRequired = getEntityState("FUNDING_SUCCESSFUL_START");
1652                     }
1653                 }
1654                 else if(FundingEntity.CurrentEntityState() == FundingEntity.getEntityState("SUCCESSFUL_FINAL")) {
1655 
1656                     if ( processMilestoneFinished() == false) {
1657                         if(
1658                             MilestonesEntity.CurrentEntityState() == MilestonesEntity.getEntityState("VOTING_ENDED_YES") ||
1659                             MilestonesEntity.CurrentEntityState() == MilestonesEntity.getEntityState("VOTING_ENDED_NO_FINAL")
1660                         ) {
1661                             EntityStateRequired = getEntityState("MILESTONE_PROCESS_START");
1662                         }
1663                     }
1664 
1665                     if(processEmergencyFundReleaseFinished() == false) {
1666                         if(ProposalsEntity.EmergencyFundingReleaseApproved() == true) {
1667                             EntityStateRequired = getEntityState("EMERGENCY_PROCESS_START");
1668                         }
1669                     }
1670 
1671                     // else, check if all milestones have been processed and try finalising development process
1672                     // EntityStateRequired = getEntityState("COMPLETE_PROCESS_START");
1673 
1674 
1675                 }
1676 
1677             } else if ( CurrentEntityState == getEntityState("FUNDING_SUCCESSFUL_PROGRESS") ) {
1678                 // still in progress? check if we should move to done
1679                 if ( processFundingSuccessfulFinished() ) {
1680                     EntityStateRequired = getEntityState("FUNDING_SUCCESSFUL_ALLOCATE");
1681                 } else {
1682                     EntityStateRequired = getEntityState("FUNDING_SUCCESSFUL_PROGRESS");
1683                 }
1684 
1685             } else if ( CurrentEntityState == getEntityState("FUNDING_SUCCESSFUL_ALLOCATE") ) {
1686 
1687                 if(FundingPoolBalancesAllocated) {
1688                     EntityStateRequired = getEntityState("FUNDING_SUCCESSFUL_DONE");
1689                 }
1690 
1691             } else if ( CurrentEntityState == getEntityState("FUNDING_SUCCESSFUL_DONE") ) {
1692                 EntityStateRequired = getEntityState("WAITING");
1693 
1694     // Funding Failed
1695             } else if ( CurrentEntityState == getEntityState("FUNDING_FAILED_PROGRESS") ) {
1696                 // still in progress? check if we should move to done
1697                 if ( processFundingFailedFinished() ) {
1698                     EntityStateRequired = getEntityState("FUNDING_FAILED_DONE");
1699                 } else {
1700                     EntityStateRequired = getEntityState("FUNDING_FAILED_PROGRESS");
1701                 }
1702 
1703     // Milestone process
1704             } else if ( CurrentEntityState == getEntityState("MILESTONE_PROCESS_PROGRESS") ) {
1705                 // still in progress? check if we should move to done
1706 
1707                 if ( processMilestoneFinished() ) {
1708                     EntityStateRequired = getEntityState("MILESTONE_PROCESS_DONE");
1709                 } else {
1710                     EntityStateRequired = getEntityState("MILESTONE_PROCESS_PROGRESS");
1711                 }
1712 
1713             } else if ( CurrentEntityState == getEntityState("MILESTONE_PROCESS_DONE") ) {
1714 
1715                 if(processMilestoneFinished() == false) {
1716                     EntityStateRequired = getEntityState("WAITING");
1717 
1718                 } else if(MilestonesEntity.currentRecord() == MilestonesEntity.RecordNum()) {
1719                     EntityStateRequired = getEntityState("COMPLETE_PROCESS_START");
1720                 }
1721 
1722     // Emergency funding release
1723             } else if ( CurrentEntityState == getEntityState("EMERGENCY_PROCESS_PROGRESS") ) {
1724                 // still in progress? check if we should move to done
1725 
1726                 if ( processEmergencyFundReleaseFinished() ) {
1727                     EntityStateRequired = getEntityState("EMERGENCY_PROCESS_DONE");
1728                 } else {
1729                     EntityStateRequired = getEntityState("EMERGENCY_PROCESS_PROGRESS");
1730                 }
1731             } else if ( CurrentEntityState == getEntityState("EMERGENCY_PROCESS_DONE") ) {
1732                 EntityStateRequired = getEntityState("WAITING");
1733 
1734     // Completion
1735             } else if ( CurrentEntityState == getEntityState("COMPLETE_PROCESS_PROGRESS") ) {
1736                 EntityStateRequired = getEntityState("COMPLETE_PROCESS_PROGRESS");
1737             }
1738         } else {
1739 
1740             if( CurrentEntityState == getEntityState("NEW") ) {
1741                 // general so we know we initialized
1742                 EntityStateRequired = getEntityState("WAITING");
1743             }
1744         }
1745 
1746         return (CurrentEntityState, EntityStateRequired);
1747     }
1748 
1749     function ApplicationInFundingOrDevelopment() public view returns(bool) {
1750         uint8 AppState = getApplicationState();
1751         if(
1752             AppState == getApplicationEntityState("IN_FUNDING") ||
1753             AppState == getApplicationEntityState("IN_DEVELOPMENT")
1754         ) {
1755             return true;
1756         }
1757         return false;
1758     }
1759 
1760 
1761 
1762 }