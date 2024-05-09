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
83  * @name        Gateway Interface Contract
84  * @package     BlockBitsIO
85  * @author      Micky Socaci <micky@nowlive.ro>
86 
87  Used as a resolver to retrieve the latest deployed version of the Application
88 
89  ENS: gateway.main.blockbits.eth will point directly to this contract.
90 
91     ADD ENS domain ownership / transfer methods
92 
93 */
94 
95 
96 
97 
98 
99 contract ABIGatewayInterface {
100     address public currentApplicationEntityAddress;
101     ApplicationEntityABI private currentApp;
102     address public deployerAddress;
103 
104     function getApplicationAddress() external view returns (address);
105     function requestCodeUpgrade( address _newAddress, bytes32 _sourceCodeUrl ) external returns (bool);
106     function approveCodeUpgrade( address _newAddress ) external returns (bool);
107     function link( address _newAddress ) internal returns (bool);
108     function getNewsContractAddress() external view returns (address);
109     function getListingContractAddress() external view returns (address);
110 }
111 
112 /*
113 
114  * source       https://github.com/blockbitsio/
115 
116  * @name        Application Asset Contract ABI
117  * @package     BlockBitsIO
118  * @author      Micky Socaci <micky@nowlive.ro>
119 
120  Any contract inheriting this will be usable as an Asset in the Application Entity
121 
122 */
123 
124 
125 
126 contract ABIApplicationAsset {
127 
128     bytes32 public assetName;
129     uint8 public CurrentEntityState;
130     uint8 public RecordNum;
131     bool public _initialized;
132     bool public _settingsApplied;
133     address public owner;
134     address public deployerAddress;
135     mapping (bytes32 => uint8) public EntityStates;
136     mapping (bytes32 => uint8) public RecordStates;
137 
138     function setInitialApplicationAddress(address _ownerAddress) public;
139     function setInitialOwnerAndName(bytes32 _name) external returns (bool);
140     function getRecordState(bytes32 name) public view returns (uint8);
141     function getEntityState(bytes32 name) public view returns (uint8);
142     function applyAndLockSettings() public returns(bool);
143     function transferToNewOwner(address _newOwner) public returns (bool);
144     function getApplicationAssetAddressByName(bytes32 _name) public returns(address);
145     function getApplicationState() public view returns (uint8);
146     function getApplicationEntityState(bytes32 name) public view returns (uint8);
147     function getAppBylawUint256(bytes32 name) public view returns (uint256);
148     function getAppBylawBytes32(bytes32 name) public view returns (bytes32);
149     function getTimestamp() view public returns (uint256);
150 
151 
152 }
153 
154 /*
155 
156  * source       https://github.com/blockbitsio/
157 
158  * @name        Proposals Contract
159  * @package     BlockBitsIO
160  * @author      Micky Socaci <micky@nowlive.ro>
161 
162  Contains the Proposals Contract code deployed and linked to the Application Entity
163 
164 */
165 
166 
167 
168 
169 
170 contract ABIProposals is ABIApplicationAsset {
171 
172     address public Application;
173     address public ListingContractEntity;
174     address public FundingEntity;
175     address public FundingManagerEntity;
176     address public TokenManagerEntity;
177     address public TokenEntity;
178     address public MilestonesEntity;
179 
180     struct ProposalRecord {
181         address creator;
182         bytes32 name;
183         uint8 actionType;
184         uint8 state;
185         bytes32 hash;                       // action name + args hash
186         address addr;
187         bytes32 sourceCodeUrl;
188         uint256 extra;
189         uint256 time_start;
190         uint256 time_end;
191         uint256 index;
192     }
193 
194     struct VoteStruct {
195         address voter;
196         uint256 time;
197         bool    vote;
198         uint256 power;
199         bool    annulled;
200         uint256 index;
201     }
202 
203     struct ResultRecord {
204         uint256 totalAvailable;
205         uint256 requiredForResult;
206         uint256 totalSoFar;
207         uint256 yes;
208         uint256 no;
209         bool    requiresCounting;
210     }
211 
212     uint8 public ActiveProposalNum;
213     uint256 public VoteCountPerProcess;
214     bool public EmergencyFundingReleaseApproved;
215 
216     mapping (bytes32 => uint8) public ActionTypes;
217     mapping (uint8 => uint256) public ActiveProposalIds;
218     mapping (uint256 => bool) public ExpiredProposalIds;
219     mapping (uint256 => ProposalRecord) public ProposalsById;
220     mapping (bytes32 => uint256) public ProposalIdByHash;
221     mapping (uint256 => mapping (uint256 => VoteStruct) ) public VotesByProposalId;
222     mapping (uint256 => mapping (address => VoteStruct) ) public VotesByCaster;
223     mapping (uint256 => uint256) public VotesNumByProposalId;
224     mapping (uint256 => ResultRecord ) public ResultsByProposalId;
225     mapping (uint256 => uint256) public lastProcessedVoteIdByProposal;
226     mapping (uint256 => uint256) public ProcessedVotesByProposal;
227     mapping (uint256 => uint256) public VoteCountAtProcessingStartByProposal;
228 
229     function getRecordState(bytes32 name) public view returns (uint8);
230     function getActionType(bytes32 name) public view returns (uint8);
231     function getProposalState(uint256 _proposalId) public view returns (uint8);
232     function getBylawsProposalVotingDuration() public view returns (uint256);
233     function getBylawsMilestoneMinPostponing() public view returns (uint256);
234     function getBylawsMilestoneMaxPostponing() public view returns (uint256);
235     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 );
236     function process() public;
237     function hasRequiredStateChanges() public view returns (bool);
238     function getRequiredStateChanges() public view returns (uint8);
239     function addCodeUpgradeProposal(address _addr, bytes32 _sourceCodeUrl) external returns (uint256);
240     function createMilestoneAcceptanceProposal() external returns (uint256);
241     function createMilestonePostponingProposal(uint256 _duration) external returns (uint256);
242     function getCurrentMilestonePostponingProposalDuration() public view returns (uint256);
243     function getCurrentMilestoneProposalStatusForType(uint8 _actionType ) public view returns (uint8);
244     function createEmergencyFundReleaseProposal() external returns (uint256);
245     function createDelistingProposal(uint256 _projectId) external returns (uint256);
246     function RegisterVote(uint256 _proposalId, bool _myVote) public;
247     function hasPreviousVote(uint256 _proposalId, address _voter) public view returns (bool);
248     function getTotalTokenVotingPower(address _voter) public view returns ( uint256 );
249     function getVotingPower(uint256 _proposalId, address _voter) public view returns ( uint256 );
250     function setVoteCountPerProcess(uint256 _perProcess) external;
251     function ProcessVoteTotals(uint256 _proposalId, uint256 length) public;
252     function canEndVoting(uint256 _proposalId) public view returns (bool);
253     function getProposalType(uint256 _proposalId) public view returns (uint8);
254     function expiryChangesState(uint256 _proposalId) public view returns (bool);
255     function needsProcessing(uint256 _proposalId) public view returns (bool);
256     function getMyVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
257     function getHasVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
258     function getMyVote(uint256 _proposalId, address _voter) public view returns (bool);
259 
260 }
261 
262 /*
263 
264  * source       https://github.com/blockbitsio/
265 
266  * @name        Funding Contract ABI
267  * @package     BlockBitsIO
268  * @author      Micky Socaci <micky@nowlive.ro>
269 
270  Contains the Funding Contract code deployed and linked to the Application Entity
271 
272 
273     !!! Links directly to Milestones
274 
275 */
276 
277 
278 
279 
280 
281 contract ABIFunding is ABIApplicationAsset {
282 
283     address public multiSigOutputAddress;
284     address public DirectInput;
285     address public MilestoneInput;
286     address public TokenManagerEntity;
287     address public FundingManagerEntity;
288 
289     struct FundingStage {
290         bytes32 name;
291         uint8   state;
292         uint256 time_start;
293         uint256 time_end;
294         uint256 amount_cap_soft;            // 0 = not enforced
295         uint256 amount_cap_hard;            // 0 = not enforced
296         uint256 amount_raised;              // 0 = not enforced
297         // funding method settings
298         uint256 minimum_entry;
299         uint8   methods;                    // FundingMethodIds
300         // token settings
301         uint256 fixed_tokens;
302         uint8   price_addition_percentage;  //
303         uint8   token_share_percentage;
304         uint8   index;
305     }
306 
307     mapping (uint8 => FundingStage) public Collection;
308     uint8 public FundingStageNum;
309     uint8 public currentFundingStage;
310     uint256 public AmountRaised;
311     uint256 public MilestoneAmountRaised;
312     uint256 public GlobalAmountCapSoft;
313     uint256 public GlobalAmountCapHard;
314     uint8 public TokenSellPercentage;
315     uint256 public Funding_Setting_funding_time_start;
316     uint256 public Funding_Setting_funding_time_end;
317     uint256 public Funding_Setting_cashback_time_start;
318     uint256 public Funding_Setting_cashback_time_end;
319     uint256 public Funding_Setting_cashback_before_start_wait_duration;
320     uint256 public Funding_Setting_cashback_duration;
321 
322 
323     function addFundingStage(
324         bytes32 _name,
325         uint256 _time_start,
326         uint256 _time_end,
327         uint256 _amount_cap_soft,
328         uint256 _amount_cap_hard,   // required > 0
329         uint8   _methods,
330         uint256 _minimum_entry,
331         uint256 _fixed_tokens,
332         uint8   _price_addition_percentage,
333         uint8   _token_share_percentage
334     )
335     public;
336 
337     function addSettings(address _outputAddress, uint256 soft_cap, uint256 hard_cap, uint8 sale_percentage, address _direct, address _milestone ) public;
338     function getStageAmount(uint8 StageId) public view returns ( uint256 );
339     function allowedPaymentMethod(uint8 _payment_method) public pure returns (bool);
340     function receivePayment(address _sender, uint8 _payment_method) payable public returns(bool);
341     function canAcceptPayment(uint256 _amount) public view returns (bool);
342     function getValueOverCurrentCap(uint256 _amount) public view returns (uint256);
343     function isFundingStageUpdateAllowed(uint8 _new_state ) public view returns (bool);
344     function getRecordStateRequiredChanges() public view returns (uint8);
345     function doStateChanges() public;
346     function hasRequiredStateChanges() public view returns (bool);
347     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
348 
349 }
350 
351 /*
352 
353  * source       https://github.com/blockbitsio/
354 
355  * @name        Meetings Contract ABI
356  * @package     BlockBitsIO
357  * @author      Micky Socaci <micky@nowlive.ro>
358 
359  Contains the Meetings Contract code deployed and linked to the Application Entity
360 
361 */
362 
363 
364 
365 
366 
367 contract ABIMeetings is ABIApplicationAsset {
368     struct Record {
369         bytes32 hash;
370         bytes32 name;
371         uint8 state;
372         uint256 time_start;                     // start at unixtimestamp
373         uint256 duration;
374         uint8 index;
375     }
376     mapping (uint8 => Record) public Collection;
377 }
378 
379 /*
380 
381  * source       https://github.com/blockbitsio/
382 
383  * @name        Milestones Contract
384  * @package     BlockBitsIO
385  * @author      Micky Socaci <micky@nowlive.ro>
386 
387  Contains the Milestones Contract code deployed and linked to the Application Entity
388 
389 */
390 
391 
392 
393 
394 
395 contract ABIMilestones is ABIApplicationAsset {
396 
397     struct Record {
398         bytes32 name;
399         string description;                     // will change to hash pointer ( external storage )
400         uint8 state;
401         uint256 duration;
402         uint256 time_start;                     // start at unixtimestamp
403         uint256 last_state_change_time;         // time of last state change
404         uint256 time_end;                       // estimated end time >> can be increased by proposal
405         uint256 time_ended;                     // actual end time
406         uint256 meeting_time;
407         uint8 funding_percentage;
408         uint8 index;
409     }
410 
411     uint8 public currentRecord;
412     uint256 public MilestoneCashBackTime = 0;
413     mapping (uint8 => Record) public Collection;
414     mapping (bytes32 => bool) public MilestonePostponingHash;
415     mapping (bytes32 => uint256) public ProposalIdByHash;
416 
417     function getBylawsProjectDevelopmentStart() public view returns (uint256);
418     function getBylawsMinTimeInTheFutureForMeetingCreation() public view returns (uint256);
419     function getBylawsCashBackVoteRejectedDuration() public view returns (uint256);
420     function addRecord( bytes32 _name, string _description, uint256 _duration, uint8 _perc ) public;
421     function getMilestoneFundingPercentage(uint8 recordId) public view returns (uint8);
422     function doStateChanges() public;
423     function getRecordStateRequiredChanges() public view returns (uint8);
424     function hasRequiredStateChanges() public view returns (bool);
425     function afterVoteNoCashBackTime() public view returns ( bool );
426     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 );
427     function getCurrentHash() public view returns ( bytes32 );
428     function getCurrentProposalId() internal view returns ( uint256 );
429     function setCurrentMilestoneMeetingTime(uint256 _meeting_time) public;
430     function isRecordUpdateAllowed(uint8 _new_state ) public view returns (bool);
431     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
432     function ApplicationIsInDevelopment() public view returns(bool);
433     function MeetingTimeSetFailure() public view returns (bool);
434 
435 }
436 
437 /*
438 
439  * source       https://github.com/blockbitsio/
440 
441  * @name        Bounty Program Contract ABI
442  * @package     BlockBitsIO
443  * @author      Micky Socaci <micky@nowlive.ro>
444 
445   Bounty program contract that holds and distributes tokens upon successful funding.
446 
447 */
448 
449 
450 
451 
452 
453 contract ABIBountyManager is ABIApplicationAsset {
454     function sendBounty( address _receiver, uint256 _amount ) public;
455 }
456 
457 /*
458 
459  * source       https://github.com/blockbitsio/
460 
461  * @name        Token Manager Contract
462  * @package     BlockBitsIO
463  * @author      Micky Socaci <micky@nowlive.ro>
464 
465 */
466 
467 
468 
469 
470 
471 contract ABITokenManager is ABIApplicationAsset {
472 
473     address public TokenSCADAEntity;
474     address public TokenEntity;
475     address public MarketingMethodAddress;
476     bool OwnerTokenBalancesReleased = false;
477 
478     function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) public;
479     function getTokenSCADARequiresHardCap() public view returns (bool);
480     function mint(address _to, uint256 _amount) public returns (bool);
481     function finishMinting() public returns (bool);
482     function mintForMarketingPool(address _to, uint256 _amount) external returns (bool);
483     function ReleaseOwnersLockedTokens(address _multiSigOutputAddress) public returns (bool);
484 
485 }
486 
487 /*
488 
489  * source       https://github.com/blockbitsio/
490 
491  * @name        Funding Contract ABI
492  * @package     BlockBitsIO
493  * @author      Micky Socaci <micky@nowlive.ro>
494 
495  Contains the Funding Contract code deployed and linked to the Application Entity
496 
497 */
498 
499 
500 
501 
502 
503 contract ABIFundingManager is ABIApplicationAsset {
504 
505     bool public fundingProcessed;
506     bool FundingPoolBalancesAllocated;
507     uint8 public VaultCountPerProcess;
508     uint256 public lastProcessedVaultId;
509     uint256 public vaultNum;
510     uint256 public LockedVotingTokens;
511     bytes32 public currentTask;
512     mapping (bytes32 => bool) public taskByHash;
513     mapping  (address => address) public vaultList;
514     mapping  (uint256 => address) public vaultById;
515 
516     function receivePayment(address _sender, uint8 _payment_method, uint8 _funding_stage) payable public returns(bool);
517     function getMyVaultAddress(address _sender) public view returns (address);
518     function setVaultCountPerProcess(uint8 _perProcess) external;
519     function getHash(bytes32 actionType, bytes32 arg1) public pure returns ( bytes32 );
520     function getCurrentMilestoneProcessed() public view returns (bool);
521     function processFundingFailedFinished() public view returns (bool);
522     function processFundingSuccessfulFinished() public view returns (bool);
523     function getCurrentMilestoneIdHash() internal view returns (bytes32);
524     function processMilestoneFinished() public view returns (bool);
525     function processEmergencyFundReleaseFinished() public view returns (bool);
526     function getAfterTransferLockedTokenBalances(address vaultAddress, bool excludeCurrent) public view returns (uint256);
527     function VaultRequestedUpdateForLockedVotingTokens(address owner) public;
528     function doStateChanges() public;
529     function hasRequiredStateChanges() public view returns (bool);
530     function getRequiredStateChanges() public view returns (uint8, uint8);
531     function ApplicationInFundingOrDevelopment() public view returns(bool);
532 
533 }
534 
535 /*
536 
537  * source       https://github.com/blockbitsio/
538 
539  * @name        Listing Contract ABI
540  * @package     BlockBitsIO
541  * @author      Micky Socaci <micky@nowlive.ro>
542 
543 */
544 
545 
546 
547 
548 
549 contract ABIListingContract is ABIApplicationAsset {
550 
551     address public managerAddress;
552     // child items
553     struct item {
554         bytes32 name;
555         address itemAddress;
556         bool    status;
557         uint256 index;
558     }
559 
560     mapping ( uint256 => item ) public items;
561     uint256 public itemNum;
562 
563     function setManagerAddress(address _manager) public;
564     function addItem(bytes32 _name, address _address) public;
565     function getNewsContractAddress(uint256 _childId) external view returns (address);
566     function canBeDelisted(uint256 _childId) public view returns (bool);
567     function getChildStatus( uint256 _childId ) public view returns (bool);
568     function delistChild( uint256 _childId ) public;
569 
570 }
571 
572 /*
573 
574  * source       https://github.com/blockbitsio/
575 
576  * @name        News Contract ABI
577  * @package     BlockBitsIO
578  * @author      Micky Socaci <micky@nowlive.ro>
579 
580 */
581 
582 
583 
584 
585 
586 contract ABINewsContract is ABIApplicationAsset {
587 
588     struct item {
589         string hash;
590         uint8 itemType;
591         uint256 length;
592     }
593 
594     uint256 public itemNum = 0;
595     mapping ( uint256 => item ) public items;
596 
597     function addInternalMessage(uint8 state) public;
598     function addItem(string _hash, uint256 _length) public;
599 }
600 
601 /*
602 
603  * source       https://github.com/blockbitsio/
604 
605  * @name        Application Entity Contract
606  * @package     BlockBitsIO
607  * @author      Micky Socaci <micky@nowlive.ro>
608 
609  Contains the main company Entity Contract code deployed and linked to the Gateway Interface.
610 
611 */
612 
613 
614 
615 
616 
617 
618 
619 
620 
621 
622 
623 
624 
625 
626 contract ApplicationEntity {
627 
628     /* Source Code Url */
629     bytes32 sourceCodeUrl;
630 
631     /* Entity initialised or not */
632     bool public _initialized = false;
633 
634     /* Entity locked or not */
635     bool public _locked = false;
636 
637     /* Current Entity State */
638     uint8 public CurrentEntityState;
639 
640     /* Available Entity State */
641     mapping (bytes32 => uint8) public EntityStates;
642 
643     /* GatewayInterface address */
644     address public GatewayInterfaceAddress;
645 
646     /* Parent Entity Instance */
647     ABIGatewayInterface GatewayInterfaceEntity;
648 
649     /* Asset Entities */
650     ABIProposals public ProposalsEntity;
651     ABIFunding public FundingEntity;
652     ABIMilestones public MilestonesEntity;
653     ABIMeetings public MeetingsEntity;
654     ABIBountyManager public BountyManagerEntity;
655     ABITokenManager public TokenManagerEntity;
656     ABIListingContract public ListingContractEntity;
657     ABIFundingManager public FundingManagerEntity;
658     ABINewsContract public NewsContractEntity;
659 
660     /* Asset Collection */
661     mapping (bytes32 => address) public AssetCollection;
662     mapping (uint8 => bytes32) public AssetCollectionIdToName;
663     uint8 public AssetCollectionNum = 0;
664 
665     event EventAppEntityReady ( address indexed _address );
666     event EventAppEntityCodeUpgradeProposal ( address indexed _address, bytes32 indexed _sourceCodeUrl );
667     event EventAppEntityInitAsset ( bytes32 indexed _name, address indexed _address );
668     event EventAppEntityInitAssetsToThis ( uint8 indexed _assetNum );
669     event EventAppEntityAssetsToNewApplication ( address indexed _address );
670     event EventAppEntityLocked ( address indexed _address );
671 
672     address public deployerAddress;
673 
674     function ApplicationEntity() public {
675         deployerAddress = msg.sender;
676         setEntityStates();
677         CurrentEntityState = getEntityState("NEW");
678     }
679 
680     function setEntityStates() internal {
681 
682         // ApplicationEntity States
683         EntityStates["__IGNORED__"]                 = 0;
684         EntityStates["NEW"]                         = 1;
685         EntityStates["WAITING"]                     = 2;
686 
687         EntityStates["IN_FUNDING"]                  = 3;
688 
689         EntityStates["IN_DEVELOPMENT"]              = 5;
690         EntityStates["IN_CODE_UPGRADE"]             = 50;
691 
692         EntityStates["UPGRADED"]                    = 100;
693 
694         EntityStates["IN_GLOBAL_CASHBACK"]          = 150;
695         EntityStates["LOCKED"]                      = 200;
696 
697         EntityStates["DEVELOPMENT_COMPLETE"]        = 250;
698     }
699 
700     function getEntityState(bytes32 name) public view returns (uint8) {
701         return EntityStates[name];
702     }
703 
704     /*
705     * Initialize Application and it's assets
706     * If gateway is freshly deployed, just link
707     * else, create a voting proposal that needs to be accepted for the linking
708     *
709     * @param        address _newAddress
710     * @param        bytes32 _sourceCodeUrl
711     *
712     * @modifiers    requireNoParent, requireNotInitialised
713     */
714     function linkToGateway(
715         address _GatewayInterfaceAddress,
716         bytes32 _sourceCodeUrl
717     )
718         external
719         requireNoParent
720         requireNotInitialised
721         onlyDeployer
722     {
723         GatewayInterfaceAddress = _GatewayInterfaceAddress;
724         sourceCodeUrl = _sourceCodeUrl;
725 
726         // init gateway entity and set app address
727         GatewayInterfaceEntity = ABIGatewayInterface(GatewayInterfaceAddress);
728         GatewayInterfaceEntity.requestCodeUpgrade( address(this), sourceCodeUrl );
729     }
730 
731     function setUpgradeState(uint8 state) public onlyGatewayInterface {
732         CurrentEntityState = state;
733     }
734 
735     /*
736         For the sake of simplicity, and solidity warnings about "unknown gas usage" do this.. instead of sending
737         an array of addresses
738     */
739     function addAssetProposals(address _assetAddresses) external requireNotInitialised onlyDeployer {
740         ProposalsEntity = ABIProposals(_assetAddresses);
741         assetInitialized("Proposals", _assetAddresses);
742     }
743 
744     function addAssetFunding(address _assetAddresses) external requireNotInitialised onlyDeployer {
745         FundingEntity = ABIFunding(_assetAddresses);
746         assetInitialized("Funding", _assetAddresses);
747     }
748 
749     function addAssetMilestones(address _assetAddresses) external requireNotInitialised onlyDeployer {
750         MilestonesEntity = ABIMilestones(_assetAddresses);
751         assetInitialized("Milestones", _assetAddresses);
752     }
753 
754     function addAssetMeetings(address _assetAddresses) external requireNotInitialised onlyDeployer {
755         MeetingsEntity = ABIMeetings(_assetAddresses);
756         assetInitialized("Meetings", _assetAddresses);
757     }
758 
759     function addAssetBountyManager(address _assetAddresses) external requireNotInitialised onlyDeployer {
760         BountyManagerEntity = ABIBountyManager(_assetAddresses);
761         assetInitialized("BountyManager", _assetAddresses);
762     }
763 
764     function addAssetTokenManager(address _assetAddresses) external requireNotInitialised onlyDeployer {
765         TokenManagerEntity = ABITokenManager(_assetAddresses);
766         assetInitialized("TokenManager", _assetAddresses);
767     }
768 
769     function addAssetFundingManager(address _assetAddresses) external requireNotInitialised onlyDeployer {
770         FundingManagerEntity = ABIFundingManager(_assetAddresses);
771         assetInitialized("FundingManager", _assetAddresses);
772     }
773 
774     function addAssetListingContract(address _assetAddresses) external requireNotInitialised onlyDeployer {
775         ListingContractEntity = ABIListingContract(_assetAddresses);
776         assetInitialized("ListingContract", _assetAddresses);
777     }
778 
779     function addAssetNewsContract(address _assetAddresses) external requireNotInitialised onlyDeployer {
780         NewsContractEntity = ABINewsContract(_assetAddresses);
781         assetInitialized("NewsContract", _assetAddresses);
782     }
783 
784     function assetInitialized(bytes32 name, address _assetAddresses) internal {
785         if(AssetCollection[name] == 0x0) {
786             AssetCollectionIdToName[AssetCollectionNum] = name;
787             AssetCollection[name] = _assetAddresses;
788             AssetCollectionNum++;
789         } else {
790             // just replace
791             AssetCollection[name] = _assetAddresses;
792         }
793         EventAppEntityInitAsset(name, _assetAddresses);
794     }
795 
796     function getAssetAddressByName(bytes32 _name) public view returns (address) {
797         return AssetCollection[_name];
798     }
799 
800     /* Application Bylaws mapping */
801     mapping (bytes32 => uint256) public BylawsUint256;
802     mapping (bytes32 => bytes32) public BylawsBytes32;
803 
804 
805     function setBylawUint256(bytes32 name, uint256 value) public requireNotInitialised onlyDeployer {
806         BylawsUint256[name] = value;
807     }
808 
809     function getBylawUint256(bytes32 name) public view requireInitialised returns (uint256) {
810         return BylawsUint256[name];
811     }
812 
813     function setBylawBytes32(bytes32 name, bytes32 value) public requireNotInitialised onlyDeployer {
814         BylawsBytes32[name] = value;
815     }
816 
817     function getBylawBytes32(bytes32 name) public view requireInitialised returns (bytes32) {
818         return BylawsBytes32[name];
819     }
820 
821     function initialize() external requireNotInitialised onlyGatewayInterface returns (bool) {
822         _initialized = true;
823         EventAppEntityReady( address(this) );
824         return true;
825     }
826 
827     function getParentAddress() external view returns(address) {
828         return GatewayInterfaceAddress;
829     }
830 
831     function createCodeUpgradeProposal(
832         address _newAddress,
833         bytes32 _sourceCodeUrl
834     )
835         external
836         requireInitialised
837         onlyGatewayInterface
838         returns (uint256)
839     {
840         // proposals create new.. code upgrade proposal
841         EventAppEntityCodeUpgradeProposal ( _newAddress, _sourceCodeUrl );
842 
843         // return true;
844         return ProposalsEntity.addCodeUpgradeProposal(_newAddress, _sourceCodeUrl);
845     }
846 
847     /*
848     * Only a proposal can update the ApplicationEntity Contract address
849     *
850     * @param        address _newAddress
851     * @modifiers    onlyProposalsAsset
852     */
853     function acceptCodeUpgradeProposal(address _newAddress) external onlyProposalsAsset  {
854         GatewayInterfaceEntity.approveCodeUpgrade( _newAddress );
855     }
856 
857     function initializeAssetsToThisApplication() external onlyGatewayInterface returns (bool) {
858 
859         for(uint8 i = 0; i < AssetCollectionNum; i++ ) {
860             bytes32 _name = AssetCollectionIdToName[i];
861             address current = AssetCollection[_name];
862             if(current != address(0x0)) {
863                 if(!current.call(bytes4(keccak256("setInitialOwnerAndName(bytes32)")), _name) ) {
864                     revert();
865                 }
866             } else {
867                 revert();
868             }
869         }
870         EventAppEntityInitAssetsToThis( AssetCollectionNum );
871 
872         return true;
873     }
874 
875     function transferAssetsToNewApplication(address _newAddress) external onlyGatewayInterface returns (bool){
876         for(uint8 i = 0; i < AssetCollectionNum; i++ ) {
877             
878             bytes32 _name = AssetCollectionIdToName[i];
879             address current = AssetCollection[_name];
880             if(current != address(0x0)) {
881                 if(!current.call(bytes4(keccak256("transferToNewOwner(address)")), _newAddress) ) {
882                     revert();
883                 }
884             } else {
885                 revert();
886             }
887         }
888         EventAppEntityAssetsToNewApplication ( _newAddress );
889         return true;
890     }
891 
892     /*
893     * Only the gateway interface can lock current app after a successful code upgrade proposal
894     *
895     * @modifiers    onlyGatewayInterface
896     */
897     function lock() external onlyGatewayInterface returns (bool) {
898         _locked = true;
899         CurrentEntityState = getEntityState("UPGRADED");
900         EventAppEntityLocked(address(this));
901         return true;
902     }
903 
904     /*
905         DUMMY METHOD, to be replaced in a future Code Upgrade with a check to determine if sender should be able to initiate a code upgrade
906         specifically used after milestone development completes
907     */
908     address testAddressAllowUpgradeFrom;
909     function canInitiateCodeUpgrade(address _sender) public view returns(bool) {
910         // suppress warning
911         if(testAddressAllowUpgradeFrom != 0x0 && testAddressAllowUpgradeFrom == _sender) {
912             return true;
913         }
914         return false;
915     }
916 
917     /*
918     * Throws if called by any other entity except GatewayInterface
919     */
920     modifier onlyGatewayInterface() {
921         require(GatewayInterfaceAddress != address(0) && msg.sender == GatewayInterfaceAddress);
922         _;
923     }
924 
925     /*
926     * Throws if called by any other entity except Proposals Asset Contract
927     */
928     modifier onlyProposalsAsset() {
929         require(msg.sender == address(ProposalsEntity));
930         _;
931     }
932 
933     modifier requireNoParent() {
934         require(GatewayInterfaceAddress == address(0x0));
935         _;
936     }
937 
938     modifier requireNotInitialised() {
939         require(_initialized == false && _locked == false);
940         _;
941     }
942 
943     modifier requireInitialised() {
944         require(_initialized == true && _locked == false);
945         _;
946     }
947 
948     modifier onlyDeployer() {
949         require(msg.sender == deployerAddress);
950         _;
951     }
952 
953     event DebugApplicationRequiredChanges( uint8 indexed _current, uint8 indexed _required );
954     event EventApplicationEntityProcessor(uint8 indexed _current, uint8 indexed _required);
955 
956     /*
957         We could create a generic method that iterates through all assets, and using assembly language get the return
958         value of the "hasRequiredStateChanges" method on each asset. Based on return, run doStateChanges on them or not.
959 
960         Or we could be using a generic ABI contract that only defines the "hasRequiredStateChanges" and "doStateChanges"
961         methods thus not requiring any assembly variable / memory management
962 
963         Problem with both cases is the fact that our application needs to change only specific asset states depending
964         on it's own current state, thus making a generic call wasteful in gas usage.
965 
966         Let's stay away from that and follow the same approach as we do inside an asset.
967         - view method: -> get required state changes
968         - view method: -> has state changes
969         - processor that does the actual changes.
970         - doStateChanges recursive method that runs the processor if views require it to.
971 
972         // pretty similar to FundingManager
973     */
974 
975     function doStateChanges() public {
976 
977         if(!_locked) {
978             // process assets first so we can initialize them from NEW to WAITING
979             AssetProcessor();
980 
981             var (returnedCurrentEntityState, EntityStateRequired) = getRequiredStateChanges();
982             bool callAgain = false;
983 
984             DebugApplicationRequiredChanges( returnedCurrentEntityState, EntityStateRequired );
985 
986             if(EntityStateRequired != getEntityState("__IGNORED__") ) {
987                 EntityProcessor(EntityStateRequired);
988                 callAgain = true;
989             }
990         } else {
991             revert();
992         }
993     }
994 
995     function hasRequiredStateChanges() public view returns (bool) {
996         bool hasChanges = false;
997         if(!_locked) {
998             var (returnedCurrentEntityState, EntityStateRequired) = getRequiredStateChanges();
999             // suppress unused local variable warning
1000             returnedCurrentEntityState = 0;
1001             if(EntityStateRequired != getEntityState("__IGNORED__") ) {
1002                 hasChanges = true;
1003             }
1004 
1005             if(anyAssetHasChanges()) {
1006                 hasChanges = true;
1007             }
1008         }
1009         return hasChanges;
1010     }
1011 
1012     function anyAssetHasChanges() public view returns (bool) {
1013         if( FundingEntity.hasRequiredStateChanges() ) {
1014             return true;
1015         }
1016         if( FundingManagerEntity.hasRequiredStateChanges() ) {
1017             return true;
1018         }
1019         if( MilestonesEntity.hasRequiredStateChanges() ) {
1020             return true;
1021         }
1022         if( ProposalsEntity.hasRequiredStateChanges() ) {
1023             return true;
1024         }
1025 
1026         return extendedAnyAssetHasChanges();
1027     }
1028 
1029     // use this when extending "has changes"
1030     function extendedAnyAssetHasChanges() internal view returns (bool) {
1031         if(_initialized) {}
1032         return false;
1033     }
1034 
1035     // use this when extending "asset state processor"
1036     function extendedAssetProcessor() internal  {
1037         // does not exist, but we check anyway to bypass compier warning about function state mutability
1038         if ( CurrentEntityState == 255 ) {
1039             ProposalsEntity.process();
1040         }
1041     }
1042 
1043     // view methods decide if changes are to be made
1044     // in case of tasks, we do them in the Processors.
1045 
1046     function AssetProcessor() internal {
1047 
1048 
1049         if ( CurrentEntityState == getEntityState("NEW") ) {
1050 
1051             // move all assets that have states to "WAITING"
1052             if(FundingEntity.hasRequiredStateChanges()) {
1053                 FundingEntity.doStateChanges();
1054             }
1055 
1056             if(FundingManagerEntity.hasRequiredStateChanges()) {
1057                 FundingManagerEntity.doStateChanges();
1058             }
1059 
1060             if( MilestonesEntity.hasRequiredStateChanges() ) {
1061                 MilestonesEntity.doStateChanges();
1062             }
1063 
1064         } else if ( CurrentEntityState == getEntityState("WAITING") ) {
1065 
1066             if( FundingEntity.hasRequiredStateChanges() ) {
1067                 FundingEntity.doStateChanges();
1068             }
1069         }
1070         else if ( CurrentEntityState == getEntityState("IN_FUNDING") ) {
1071 
1072             if( FundingEntity.hasRequiredStateChanges() ) {
1073                 FundingEntity.doStateChanges();
1074             }
1075 
1076             if( FundingManagerEntity.hasRequiredStateChanges() ) {
1077                 FundingManagerEntity.doStateChanges();
1078             }
1079         }
1080         else if ( CurrentEntityState == getEntityState("IN_DEVELOPMENT") ) {
1081 
1082             if( FundingManagerEntity.hasRequiredStateChanges() ) {
1083                 FundingManagerEntity.doStateChanges();
1084             }
1085 
1086             if(MilestonesEntity.hasRequiredStateChanges()) {
1087                 MilestonesEntity.doStateChanges();
1088             }
1089 
1090             if(ProposalsEntity.hasRequiredStateChanges()) {
1091                 ProposalsEntity.process();
1092             }
1093         }
1094         else if ( CurrentEntityState == getEntityState("DEVELOPMENT_COMPLETE") ) {
1095 
1096             if(ProposalsEntity.hasRequiredStateChanges()) {
1097                 ProposalsEntity.process();
1098             }
1099         }
1100 
1101         extendedAssetProcessor();
1102     }
1103 
1104     function EntityProcessor(uint8 EntityStateRequired) internal {
1105 
1106         EventApplicationEntityProcessor( CurrentEntityState, EntityStateRequired );
1107 
1108         // Update our Entity State
1109         CurrentEntityState = EntityStateRequired;
1110 
1111         // Do State Specific Updates
1112 
1113         if ( EntityStateRequired == getEntityState("IN_FUNDING") ) {
1114             // run Funding state changer
1115             // doStateChanges
1116         }
1117 
1118         // EntityStateRequired = getEntityState("IN_FUNDING");
1119 
1120 
1121         // Funding Failed
1122         /*
1123         if ( EntityStateRequired == getEntityState("FUNDING_FAILED_START") ) {
1124             // set ProcessVaultList Task
1125             currentTask = getHash("FUNDING_FAILED_START", "");
1126             CurrentEntityState = getEntityState("FUNDING_FAILED_PROGRESS");
1127         } else if ( EntityStateRequired == getEntityState("FUNDING_FAILED_PROGRESS") ) {
1128             ProcessVaultList(VaultCountPerProcess);
1129 
1130             // Funding Successful
1131         } else if ( EntityStateRequired == getEntityState("FUNDING_SUCCESSFUL_START") ) {
1132 
1133             // init SCADA variable cache.
1134             if(TokenSCADAEntity.initCacheForVariables()) {
1135                 // start processing vaults
1136                 currentTask = getHash("FUNDING_SUCCESSFUL_START", "");
1137                 CurrentEntityState = getEntityState("FUNDING_SUCCESSFUL_PROGRESS");
1138             } else {
1139                 // something went really wrong, just bail out for now
1140                 CurrentEntityState = getEntityState("FUNDING_FAILED_START");
1141             }
1142         } else if ( EntityStateRequired == getEntityState("FUNDING_SUCCESSFUL_PROGRESS") ) {
1143             ProcessVaultList(VaultCountPerProcess);
1144             // Milestones
1145         } else if ( EntityStateRequired == getEntityState("MILESTONE_PROCESS_START") ) {
1146             currentTask = getHash("MILESTONE_PROCESS_START", getCurrentMilestoneId() );
1147             CurrentEntityState = getEntityState("MILESTONE_PROCESS_PROGRESS");
1148         } else if ( EntityStateRequired == getEntityState("MILESTONE_PROCESS_PROGRESS") ) {
1149             ProcessVaultList(VaultCountPerProcess);
1150 
1151             // Completion
1152         } else if ( EntityStateRequired == getEntityState("COMPLETE_PROCESS_START") ) {
1153             currentTask = getHash("COMPLETE_PROCESS_START", "");
1154             CurrentEntityState = getEntityState("COMPLETE_PROCESS_PROGRESS");
1155         } else if ( EntityStateRequired == getEntityState("COMPLETE_PROCESS_PROGRESS") ) {
1156             ProcessVaultList(VaultCountPerProcess);
1157         }
1158         */
1159     }
1160 
1161     /*
1162      * Method: Get Entity Required State Changes
1163      *
1164      * @access       public
1165      * @type         method
1166      *
1167      * @return       ( uint8 CurrentEntityState, uint8 EntityStateRequired )
1168      */
1169     function getRequiredStateChanges() public view returns (uint8, uint8) {
1170 
1171         uint8 EntityStateRequired = getEntityState("__IGNORED__");
1172 
1173         if( CurrentEntityState == getEntityState("NEW") ) {
1174             // general so we know we initialized
1175             EntityStateRequired = getEntityState("WAITING");
1176 
1177         } else if ( CurrentEntityState == getEntityState("WAITING") ) {
1178 
1179             // Funding Started
1180             if( FundingEntity.CurrentEntityState() == FundingEntity.getEntityState("IN_PROGRESS") ) {
1181                 EntityStateRequired = getEntityState("IN_FUNDING");
1182             }
1183 
1184         } else if ( CurrentEntityState == getEntityState("IN_FUNDING") ) {
1185 
1186             if(FundingEntity.CurrentEntityState() == FundingEntity.getEntityState("SUCCESSFUL_FINAL")) {
1187                 // SUCCESSFUL_FINAL means FUNDING was successful, and FundingManager has finished distributing tokens and ether
1188                 EntityStateRequired = getEntityState("IN_DEVELOPMENT");
1189 
1190             } else if(FundingEntity.CurrentEntityState() == FundingEntity.getEntityState("FAILED_FINAL")) {
1191                 // Funding failed..
1192                 EntityStateRequired = getEntityState("IN_GLOBAL_CASHBACK");
1193             }
1194 
1195         } else if ( CurrentEntityState == getEntityState("IN_DEVELOPMENT") ) {
1196 
1197             // this is where most things happen
1198             // milestones get developed
1199             // code upgrades get initiated
1200             // proposals get created and voted
1201 
1202             /*
1203             if(ProposalsEntity.CurrentEntityState() == ProposalsEntity.getEntityState("CODE_UPGRADE_ACCEPTED")) {
1204                 // check if we have an upgrade proposal that is accepted and move into said state
1205                 EntityStateRequired = getEntityState("START_CODE_UPGRADE");
1206             }
1207             else
1208             */
1209 
1210             if(MilestonesEntity.CurrentEntityState() == MilestonesEntity.getEntityState("DEVELOPMENT_COMPLETE")) {
1211                 // check if we finished developing all milestones .. and if so move state to complete.
1212                 EntityStateRequired = getEntityState("DEVELOPMENT_COMPLETE");
1213             }
1214 
1215             if(MilestonesEntity.CurrentEntityState() == MilestonesEntity.getEntityState("DEADLINE_MEETING_TIME_FAILED")) {
1216                 EntityStateRequired = getEntityState("IN_GLOBAL_CASHBACK");
1217             }
1218 
1219         } else if ( CurrentEntityState == getEntityState("START_CODE_UPGRADE") ) {
1220 
1221             // check stuff to move into IN_CODE_UPGRADE
1222             // EntityStateRequired = getEntityState("IN_CODE_UPGRADE");
1223 
1224         } else if ( CurrentEntityState == getEntityState("IN_CODE_UPGRADE") ) {
1225 
1226             // check stuff to finish
1227             // EntityStateRequired = getEntityState("FINISHED_CODE_UPGRADE");
1228 
1229         } else if ( CurrentEntityState == getEntityState("FINISHED_CODE_UPGRADE") ) {
1230 
1231             // move to IN_DEVELOPMENT or DEVELOPMENT_COMPLETE based on state before START_CODE_UPGRADE.
1232             // EntityStateRequired = getEntityState("DEVELOPMENT_COMPLETE");
1233             // EntityStateRequired = getEntityState("FINISHED_CODE_UPGRADE");
1234 
1235         }
1236 
1237         return (CurrentEntityState, EntityStateRequired);
1238     }
1239 
1240     function getTimestamp() view public returns (uint256) {
1241         return now;
1242     }
1243 
1244 }