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
273  * @name        Token Contract
274  * @package     BlockBitsIO
275  * @author      Micky Socaci <micky@nowlive.ro>
276 
277  Zeppelin ERC20 Standard Token
278 
279 */
280 
281 
282 
283 contract ABIToken {
284 
285     string public  symbol;
286     string public  name;
287     uint8 public   decimals;
288     uint256 public totalSupply;
289     string public  version;
290     mapping (address => uint256) public balances;
291     mapping (address => mapping (address => uint256)) allowed;
292     address public manager;
293     address public deployer;
294     bool public mintingFinished = false;
295     bool public initialized = false;
296 
297     function transfer(address _to, uint256 _value) public returns (bool);
298     function balanceOf(address _owner) public view returns (uint256 balance);
299     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
300     function approve(address _spender, uint256 _value) public returns (bool);
301     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
302     function increaseApproval(address _spender, uint _addedValue) public returns (bool success);
303     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);
304     function mint(address _to, uint256 _amount) public returns (bool);
305     function finishMinting() public returns (bool);
306 
307     event Transfer(address indexed from, address indexed to, uint256 indexed value);
308     event Approval(address indexed owner, address indexed spender, uint256 indexed value);
309     event Mint(address indexed to, uint256 amount);
310     event MintFinished();
311 }
312 
313 /*
314 
315  * source       https://github.com/blockbitsio/
316 
317  * @name        Application Asset Contract ABI
318  * @package     BlockBitsIO
319  * @author      Micky Socaci <micky@nowlive.ro>
320 
321  Any contract inheriting this will be usable as an Asset in the Application Entity
322 
323 */
324 
325 
326 
327 contract ABIApplicationAsset {
328 
329     bytes32 public assetName;
330     uint8 public CurrentEntityState;
331     uint8 public RecordNum;
332     bool public _initialized;
333     bool public _settingsApplied;
334     address public owner;
335     address public deployerAddress;
336     mapping (bytes32 => uint8) public EntityStates;
337     mapping (bytes32 => uint8) public RecordStates;
338 
339     function setInitialApplicationAddress(address _ownerAddress) public;
340     function setInitialOwnerAndName(bytes32 _name) external returns (bool);
341     function getRecordState(bytes32 name) public view returns (uint8);
342     function getEntityState(bytes32 name) public view returns (uint8);
343     function applyAndLockSettings() public returns(bool);
344     function transferToNewOwner(address _newOwner) public returns (bool);
345     function getApplicationAssetAddressByName(bytes32 _name) public returns(address);
346     function getApplicationState() public view returns (uint8);
347     function getApplicationEntityState(bytes32 name) public view returns (uint8);
348     function getAppBylawUint256(bytes32 name) public view returns (uint256);
349     function getAppBylawBytes32(bytes32 name) public view returns (bytes32);
350     function getTimestamp() view public returns (uint256);
351 
352 
353 }
354 
355 /*
356 
357  * source       https://github.com/blockbitsio/
358 
359  * @name        Token Manager Contract
360  * @package     BlockBitsIO
361  * @author      Micky Socaci <micky@nowlive.ro>
362 
363 */
364 
365 
366 
367 
368 
369 contract ABITokenManager is ABIApplicationAsset {
370 
371     address public TokenSCADAEntity;
372     address public TokenEntity;
373     address public MarketingMethodAddress;
374     bool OwnerTokenBalancesReleased = false;
375 
376     function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) public;
377     function getTokenSCADARequiresHardCap() public view returns (bool);
378     function mint(address _to, uint256 _amount) public returns (bool);
379     function finishMinting() public returns (bool);
380     function mintForMarketingPool(address _to, uint256 _amount) external returns (bool);
381     function ReleaseOwnersLockedTokens(address _multiSigOutputAddress) public returns (bool);
382 
383 }
384 
385 /*
386 
387  * source       https://github.com/blockbitsio/
388 
389  * @name        Listing Contract ABI
390  * @package     BlockBitsIO
391  * @author      Micky Socaci <micky@nowlive.ro>
392 
393 */
394 
395 
396 
397 
398 
399 contract ABIListingContract is ABIApplicationAsset {
400 
401     address public managerAddress;
402     // child items
403     struct item {
404         bytes32 name;
405         address itemAddress;
406         bool    status;
407         uint256 index;
408     }
409 
410     mapping ( uint256 => item ) public items;
411     uint256 public itemNum;
412 
413     function setManagerAddress(address _manager) public;
414     function addItem(bytes32 _name, address _address) public;
415     function getNewsContractAddress(uint256 _childId) external view returns (address);
416     function canBeDelisted(uint256 _childId) public view returns (bool);
417     function getChildStatus( uint256 _childId ) public view returns (bool);
418     function delistChild( uint256 _childId ) public;
419 
420 }
421 
422 /*
423 
424  * source       https://github.com/blockbitsio/
425 
426  * @name        Funding Contract ABI
427  * @package     BlockBitsIO
428  * @author      Micky Socaci <micky@nowlive.ro>
429 
430  Contains the Funding Contract code deployed and linked to the Application Entity
431 
432 
433     !!! Links directly to Milestones
434 
435 */
436 
437 
438 
439 
440 
441 contract ABIFunding is ABIApplicationAsset {
442 
443     address public multiSigOutputAddress;
444     address public DirectInput;
445     address public MilestoneInput;
446     address public TokenManagerEntity;
447     address public FundingManagerEntity;
448 
449     struct FundingStage {
450         bytes32 name;
451         uint8   state;
452         uint256 time_start;
453         uint256 time_end;
454         uint256 amount_cap_soft;            // 0 = not enforced
455         uint256 amount_cap_hard;            // 0 = not enforced
456         uint256 amount_raised;              // 0 = not enforced
457         // funding method settings
458         uint256 minimum_entry;
459         uint8   methods;                    // FundingMethodIds
460         // token settings
461         uint256 fixed_tokens;
462         uint8   price_addition_percentage;  //
463         uint8   token_share_percentage;
464         uint8   index;
465     }
466 
467     mapping (uint8 => FundingStage) public Collection;
468     uint8 public FundingStageNum;
469     uint8 public currentFundingStage;
470     uint256 public AmountRaised;
471     uint256 public MilestoneAmountRaised;
472     uint256 public GlobalAmountCapSoft;
473     uint256 public GlobalAmountCapHard;
474     uint8 public TokenSellPercentage;
475     uint256 public Funding_Setting_funding_time_start;
476     uint256 public Funding_Setting_funding_time_end;
477     uint256 public Funding_Setting_cashback_time_start;
478     uint256 public Funding_Setting_cashback_time_end;
479     uint256 public Funding_Setting_cashback_before_start_wait_duration;
480     uint256 public Funding_Setting_cashback_duration;
481 
482 
483     function addFundingStage(
484         bytes32 _name,
485         uint256 _time_start,
486         uint256 _time_end,
487         uint256 _amount_cap_soft,
488         uint256 _amount_cap_hard,   // required > 0
489         uint8   _methods,
490         uint256 _minimum_entry,
491         uint256 _fixed_tokens,
492         uint8   _price_addition_percentage,
493         uint8   _token_share_percentage
494     )
495     public;
496 
497     function addSettings(address _outputAddress, uint256 soft_cap, uint256 hard_cap, uint8 sale_percentage, address _direct, address _milestone ) public;
498     function getStageAmount(uint8 StageId) public view returns ( uint256 );
499     function allowedPaymentMethod(uint8 _payment_method) public pure returns (bool);
500     function receivePayment(address _sender, uint8 _payment_method) payable public returns(bool);
501     function canAcceptPayment(uint256 _amount) public view returns (bool);
502     function getValueOverCurrentCap(uint256 _amount) public view returns (uint256);
503     function isFundingStageUpdateAllowed(uint8 _new_state ) public view returns (bool);
504     function getRecordStateRequiredChanges() public view returns (uint8);
505     function doStateChanges() public;
506     function hasRequiredStateChanges() public view returns (bool);
507     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
508 
509 }
510 
511 /*
512 
513  * source       https://github.com/blockbitsio/
514 
515  * @name        Funding Contract ABI
516  * @package     BlockBitsIO
517  * @author      Micky Socaci <micky@nowlive.ro>
518 
519  Contains the Funding Contract code deployed and linked to the Application Entity
520 
521 */
522 
523 
524 
525 
526 
527 contract ABIFundingManager is ABIApplicationAsset {
528 
529     bool public fundingProcessed;
530     bool FundingPoolBalancesAllocated;
531     uint8 public VaultCountPerProcess;
532     uint256 public lastProcessedVaultId;
533     uint256 public vaultNum;
534     uint256 public LockedVotingTokens;
535     bytes32 public currentTask;
536     mapping (bytes32 => bool) public taskByHash;
537     mapping  (address => address) public vaultList;
538     mapping  (uint256 => address) public vaultById;
539 
540     function receivePayment(address _sender, uint8 _payment_method, uint8 _funding_stage) payable public returns(bool);
541     function getMyVaultAddress(address _sender) public view returns (address);
542     function setVaultCountPerProcess(uint8 _perProcess) external;
543     function getHash(bytes32 actionType, bytes32 arg1) public pure returns ( bytes32 );
544     function getCurrentMilestoneProcessed() public view returns (bool);
545     function processFundingFailedFinished() public view returns (bool);
546     function processFundingSuccessfulFinished() public view returns (bool);
547     function getCurrentMilestoneIdHash() internal view returns (bytes32);
548     function processMilestoneFinished() public view returns (bool);
549     function processEmergencyFundReleaseFinished() public view returns (bool);
550     function getAfterTransferLockedTokenBalances(address vaultAddress, bool excludeCurrent) public view returns (uint256);
551     function VaultRequestedUpdateForLockedVotingTokens(address owner) public;
552     function doStateChanges() public;
553     function hasRequiredStateChanges() public view returns (bool);
554     function getRequiredStateChanges() public view returns (uint8, uint8);
555     function ApplicationInFundingOrDevelopment() public view returns(bool);
556 
557 }
558 
559 /*
560 
561  * source       https://github.com/blockbitsio/
562 
563  * @name        Milestones Contract
564  * @package     BlockBitsIO
565  * @author      Micky Socaci <micky@nowlive.ro>
566 
567  Contains the Milestones Contract code deployed and linked to the Application Entity
568 
569 */
570 
571 
572 
573 
574 
575 contract ABIMilestones is ABIApplicationAsset {
576 
577     struct Record {
578         bytes32 name;
579         string description;                     // will change to hash pointer ( external storage )
580         uint8 state;
581         uint256 duration;
582         uint256 time_start;                     // start at unixtimestamp
583         uint256 last_state_change_time;         // time of last state change
584         uint256 time_end;                       // estimated end time >> can be increased by proposal
585         uint256 time_ended;                     // actual end time
586         uint256 meeting_time;
587         uint8 funding_percentage;
588         uint8 index;
589     }
590 
591     uint8 public currentRecord;
592     uint256 public MilestoneCashBackTime = 0;
593     mapping (uint8 => Record) public Collection;
594     mapping (bytes32 => bool) public MilestonePostponingHash;
595     mapping (bytes32 => uint256) public ProposalIdByHash;
596 
597     function getBylawsProjectDevelopmentStart() public view returns (uint256);
598     function getBylawsMinTimeInTheFutureForMeetingCreation() public view returns (uint256);
599     function getBylawsCashBackVoteRejectedDuration() public view returns (uint256);
600     function addRecord( bytes32 _name, string _description, uint256 _duration, uint8 _perc ) public;
601     function getMilestoneFundingPercentage(uint8 recordId) public view returns (uint8);
602     function doStateChanges() public;
603     function getRecordStateRequiredChanges() public view returns (uint8);
604     function hasRequiredStateChanges() public view returns (bool);
605     function afterVoteNoCashBackTime() public view returns ( bool );
606     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 );
607     function getCurrentHash() public view returns ( bytes32 );
608     function getCurrentProposalId() internal view returns ( uint256 );
609     function setCurrentMilestoneMeetingTime(uint256 _meeting_time) public;
610     function isRecordUpdateAllowed(uint8 _new_state ) public view returns (bool);
611     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
612     function ApplicationIsInDevelopment() public view returns(bool);
613     function MeetingTimeSetFailure() public view returns (bool);
614 
615 }
616 
617 /*
618 
619  * source       https://github.com/blockbitsio/
620 
621  * @name        Proposals Contract
622  * @package     BlockBitsIO
623  * @author      Micky Socaci <micky@nowlive.ro>
624 
625  Contains the Proposals Contract code deployed and linked to the Application Entity
626 
627 */
628 
629 
630 
631 
632 
633 
634 
635 
636 
637 
638 
639 
640 
641 
642 contract Proposals is ApplicationAsset {
643 
644     ApplicationEntityABI public Application;
645     ABIListingContract public ListingContractEntity;
646     ABIFunding public FundingEntity;
647     ABIFundingManager public FundingManagerEntity;
648     ABITokenManager public TokenManagerEntity;
649     ABIToken public TokenEntity;
650     ABIMilestones public MilestonesEntity;
651 
652     function getRecordState(bytes32 name) public view returns (uint8) {
653         return RecordStates[name];
654     }
655 
656     function getActionType(bytes32 name) public view returns (uint8) {
657         return ActionTypes[name];
658     }
659 
660     function getProposalState(uint256 _proposalId) public view returns (uint8) {
661         return ProposalsById[_proposalId].state;
662     }
663 
664     mapping (bytes32 => uint8) public ActionTypes;
665 
666     function setActionTypes() internal {
667         // owner initiated
668         ActionTypes["MILESTONE_DEADLINE"] = 1;
669         ActionTypes["MILESTONE_POSTPONING"] = 2;
670         ActionTypes["EMERGENCY_FUND_RELEASE"] = 60;
671         ActionTypes["IN_DEVELOPMENT_CODE_UPGRADE"] = 50;
672 
673         // shareholder initiated
674         ActionTypes["AFTER_COMPLETE_CODE_UPGRADE"] = 51;
675         ActionTypes["PROJECT_DELISTING"] = 75;
676     }
677 
678 
679     function setAssetStates() internal {
680 
681         setActionTypes();
682 
683         RecordStates["NEW"]                 = 1;
684         RecordStates["ACCEPTING_VOTES"]     = 2;
685         RecordStates["VOTING_ENDED"]        = 3;
686         RecordStates["VOTING_RESULT_YES"]   = 10;
687         RecordStates["VOTING_RESULT_NO"]    = 20;
688     }
689 
690     event EventNewProposalCreated ( bytes32 indexed _hash, uint256 indexed _proposalId );
691 
692     function runBeforeApplyingSettings()
693         internal
694         requireInitialised
695         requireSettingsNotApplied
696     {
697         address FundingAddress = getApplicationAssetAddressByName('Funding');
698         FundingEntity = ABIFunding(FundingAddress);
699 
700         address FundingManagerAddress = getApplicationAssetAddressByName('FundingManager');
701         FundingManagerEntity = ABIFundingManager(FundingManagerAddress);
702 
703         address TokenManagerAddress = getApplicationAssetAddressByName('TokenManager');
704         TokenManagerEntity = ABITokenManager(TokenManagerAddress);
705         TokenEntity = ABIToken(TokenManagerEntity.TokenEntity());
706 
707         address ListingContractAddress = getApplicationAssetAddressByName('ListingContract');
708         ListingContractEntity = ABIListingContract(ListingContractAddress);
709 
710         address MilestonesContractAddress = getApplicationAssetAddressByName('Milestones');
711         MilestonesEntity = ABIMilestones(MilestonesContractAddress);
712 
713         EventRunBeforeApplyingSettings(assetName);
714     }
715 
716     function getBylawsProposalVotingDuration() public view returns (uint256) {
717         return getAppBylawUint256("proposal_voting_duration");
718     }
719 
720     function getBylawsMilestoneMinPostponing() public view returns (uint256) {
721         return getAppBylawUint256("min_postponing");
722     }
723 
724     function getBylawsMilestoneMaxPostponing() public view returns (uint256) {
725         return getAppBylawUint256("max_postponing");
726     }
727 
728     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 ) {
729         return keccak256(actionType, arg1, arg2);
730     }
731 
732 
733     // need to implement a way to just iterate through active proposals, and remove the ones we already processed
734     // otherwise someone with malicious intent could add a ton of proposals, just to make our contract cost a ton of gas.
735 
736     // to that end, we allow individual proposal processing. so that we don't get affected by people with too much
737     // money and time on their hands.
738 
739     // whenever the system created a proposal, it will store the id, and process it when required.
740 
741     // not that much of an issue at this stage because:
742     // NOW:
743     // - only the system can create - MILESTONE_DEADLINE
744     // - only the deployer can create - MILESTONE_POSTPONING / EMERGENCY_FUND_RELEASE / IN_DEVELOPMENT_CODE_UPGRADE
745 
746     // FUTURE:
747     // - PROJECT_DELISTING is tied into an existing "listing id" which will be created by the system ( if requested by
748     // someone, but at quite a significant cost )
749     // - AFTER_COMPLETE_CODE_UPGRADE
750 
751     mapping (uint8 => uint256) public ActiveProposalIds;
752     uint8 public ActiveProposalNum = 0;
753 
754     mapping (uint256 => bool) public ExpiredProposalIds;
755 
756     function process() public onlyApplicationEntity {
757         for(uint8 i = 0; i < ActiveProposalNum; i++) {
758 
759             if(
760                 getProposalType(ActiveProposalIds[i]) == getActionType("PROJECT_DELISTING") ||
761                 getProposalType(ActiveProposalIds[i]) == getActionType("AFTER_COMPLETE_CODE_UPGRADE")
762             ) {
763                 ProcessVoteTotals( ActiveProposalIds[i], VoteCountPerProcess );
764             } else {
765                 // try expiry ending
766                 tryEndVoting(ActiveProposalIds[i]);
767             }
768 
769         }
770     }
771 
772     function hasRequiredStateChanges() public view returns (bool) {
773         for(uint8 i = 0; i < ActiveProposalNum; i++) {
774             if( needsProcessing( ActiveProposalIds[i] ) ) {
775                 return true;
776             }
777         }
778         return false;
779     }
780 
781     function getRequiredStateChanges() public view returns (uint8) {
782         if(hasRequiredStateChanges()) {
783             return ActiveProposalNum;
784         }
785         return 0;
786     }
787 
788     function addCodeUpgradeProposal(address _addr, bytes32 _sourceCodeUrl)
789         external
790         onlyApplicationEntity   // shareholder check is done directly in Gateway by calling applicationEntity to confirm
791         returns (uint256)
792     {
793 
794         // hash enforces only 1 possible voting of this type per record.
795         // basically if a vote failed, you need to deploy it with changes to a new address. that simple.
796 
797         // depending on the application overall state, we have 2 different voting implementations.
798 
799         uint8 thisAction;
800 
801         if(getApplicationState() == getApplicationEntityState("IN_DEVELOPMENT") ) {
802             thisAction = getActionType("IN_DEVELOPMENT_CODE_UPGRADE");
803 
804         } else if(getApplicationState() == getApplicationEntityState("DEVELOPMENT_COMPLETE") ) {
805             thisAction = getActionType("AFTER_COMPLETE_CODE_UPGRADE");
806         }
807 
808         return createProposal(
809             msg.sender,
810             "CODE_UPGRADE",
811             getHash( thisAction, bytes32(_addr), 0 ),
812             thisAction,
813             _addr,
814             _sourceCodeUrl,
815             0
816         );
817     }
818 
819 
820     function createMilestoneAcceptanceProposal()
821         external
822         onlyAsset("Milestones")
823         returns (uint256)
824     {
825 
826         uint8 recordId = MilestonesEntity.currentRecord();
827         return createProposal(
828             msg.sender,
829             "MILESTONE_DEADLINE",
830             getHash( getActionType("MILESTONE_DEADLINE"), bytes32( recordId ), 0 ),
831             getActionType("MILESTONE_DEADLINE"),
832             0,
833             0,
834             uint256(recordId)
835         );
836     }
837 
838     function createMilestonePostponingProposal(uint256 _duration)
839         external
840         onlyDeployer
841         returns (uint256)
842     {
843         if(_duration >= getBylawsMilestoneMinPostponing() && _duration <= getBylawsMilestoneMaxPostponing() ) {
844 
845             uint8 recordId = MilestonesEntity.currentRecord();
846             return createProposal(
847                 msg.sender,
848                 "MILESTONE_POSTPONING",
849                 getHash( getActionType("MILESTONE_POSTPONING"), bytes32( recordId ), 0 ),
850                 getActionType("MILESTONE_POSTPONING"),
851                 0,
852                 0,
853                 _duration
854             );
855         } else {
856             revert();
857         }
858     }
859 
860     function getCurrentMilestonePostponingProposalDuration() public view returns (uint256) {
861         uint8 recordId = MilestonesEntity.currentRecord();
862         bytes32 hash = getHash( getActionType("MILESTONE_POSTPONING"), bytes32( recordId ), 0 );
863         ProposalRecord memory proposal = ProposalsById[ ProposalIdByHash[hash] ];
864         return proposal.extra;
865     }
866 
867     function getCurrentMilestoneProposalStatusForType(uint8 _actionType ) public view returns (uint8) {
868 
869         if(_actionType == getActionType("MILESTONE_DEADLINE") || _actionType == getActionType("MILESTONE_POSTPONING")) {
870             uint8 recordId = MilestonesEntity.currentRecord();
871             bytes32 hash = getHash( _actionType, bytes32( recordId ), 0 );
872             uint256 ProposalId = ProposalIdByHash[hash];
873             ProposalRecord memory proposal = ProposalsById[ProposalId];
874             return proposal.state;
875         }
876         return 0;
877     }
878 
879     function createEmergencyFundReleaseProposal()
880         external
881         onlyDeployer
882         returns (uint256)
883     {
884         return createProposal(
885             msg.sender,
886             "EMERGENCY_FUND_RELEASE",
887             getHash( getActionType("EMERGENCY_FUND_RELEASE"), 0, 0 ),
888             getActionType("EMERGENCY_FUND_RELEASE"),
889             0,
890             0,
891             0
892         );
893     }
894 
895     function createDelistingProposal(uint256 _projectId)
896         external
897         onlyTokenHolder
898         returns (uint256)
899     {
900         // let's validate the project is actually listed first in order to remove any spamming ability.
901         if( ListingContractEntity.canBeDelisted(_projectId) == true) {
902 
903             return createProposal(
904                 msg.sender,
905                 "PROJECT_DELISTING",
906                 getHash( getActionType("PROJECT_DELISTING"), bytes32(_projectId), 0 ),
907                 getActionType("PROJECT_DELISTING"),
908                 0,
909                 0,
910                 _projectId
911             );
912         } else {
913             revert();
914         }
915     }
916 
917     modifier onlyTokenHolder() {
918         require( getTotalTokenVotingPower(msg.sender) > 0 );
919         _;
920     }
921 
922     struct ProposalRecord {
923         address creator;
924         bytes32 name;
925         uint8 actionType;
926         uint8 state;
927         bytes32 hash;                       // action name + args hash
928         address addr;
929         bytes32 sourceCodeUrl;
930         uint256 extra;
931         uint256 time_start;
932         uint256 time_end;
933         uint256 index;
934     }
935 
936     mapping (uint256 => ProposalRecord) public ProposalsById;
937     mapping (bytes32 => uint256) public ProposalIdByHash;
938 
939     function createProposal(
940         address _creator,
941         bytes32 _name,
942         bytes32 _hash,
943         uint8   _action,
944         address _addr,
945         bytes32 _sourceCodeUrl,
946         uint256 _extra
947     )
948         internal
949         returns (uint256)
950     {
951 
952         // if(_action > 0) {
953 
954         if(ProposalIdByHash[_hash] == 0) {
955 
956             ProposalRecord storage proposal = ProposalsById[++RecordNum];
957             proposal.creator        = _creator;
958             proposal.name           = _name;
959             proposal.actionType     = _action;
960             proposal.addr           = _addr;
961             proposal.sourceCodeUrl  = _sourceCodeUrl;
962             proposal.extra          = _extra;
963             proposal.hash           = _hash;
964             proposal.state          = getRecordState("NEW");
965             proposal.time_start     = getTimestamp();
966             proposal.time_end       = getTimestamp() + getBylawsProposalVotingDuration();
967             proposal.index          = RecordNum;
968 
969             ProposalIdByHash[_hash] = RecordNum;
970 
971         } else {
972             // already exists!
973             revert();
974         }
975 
976         initProposalVoting(RecordNum);
977         EventNewProposalCreated ( _hash, RecordNum );
978         return RecordNum;
979 
980         /*
981         } else {
982             // no action?!
983             revert();
984         }
985         */
986     }
987 
988     function acceptCodeUpgrade(uint256 _proposalId) internal {
989         ProposalRecord storage proposal = ProposalsById[_proposalId];
990         // reinitialize this each time, because we rely on "owner" as the address, and it will change
991         Application = ApplicationEntityABI(owner);
992         Application.acceptCodeUpgradeProposal(proposal.addr);
993     }
994 
995 
996     function initProposalVoting(uint256 _proposalId) internal {
997 
998         ResultRecord storage result = ResultsByProposalId[_proposalId];
999         ProposalRecord storage proposal = ProposalsById[_proposalId];
1000 
1001         if(getApplicationState() == getApplicationEntityState("IN_DEVELOPMENT") ) {
1002 
1003             if(proposal.actionType == getActionType("PROJECT_DELISTING") ) {
1004                 // while in development project delisting can be voted by all available tokens, except owner
1005                 uint256 ownerLockedTokens = TokenEntity.balanceOf(TokenManagerEntity);
1006                 result.totalAvailable = TokenEntity.totalSupply() - ownerLockedTokens;
1007 
1008                 // since we're counting unlocked tokens, we need to recount votes each time we want to end the voting period
1009                 result.requiresCounting = true;
1010 
1011             } else {
1012                 // any other proposal is only voted by "locked ether", thus we use locked tokens
1013                 result.totalAvailable = FundingManagerEntity.LockedVotingTokens();
1014 
1015                 // locked tokens do not require recounting.
1016                 result.requiresCounting = false;
1017             }
1018 
1019         } else if(getApplicationState() == getApplicationEntityState("DEVELOPMENT_COMPLETE") ) {
1020             // remove residual token balance from TokenManagerEntity.
1021             uint256 residualLockedTokens = TokenEntity.balanceOf(TokenManagerEntity);
1022             result.totalAvailable = TokenEntity.totalSupply() - residualLockedTokens;
1023 
1024             // since we're counting unlocked tokens, we need to recount votes each time we want to end the voting period
1025             result.requiresCounting = true;
1026         }
1027         result.requiredForResult = result.totalAvailable / 2;   // 50%
1028 
1029         proposal.state = getRecordState("ACCEPTING_VOTES");
1030         addActiveProposal(_proposalId);
1031 
1032         tryFinaliseNonLockedTokensProposal(_proposalId);
1033     }
1034 
1035 
1036 
1037     /*
1038 
1039     Voting
1040 
1041     */
1042 
1043     struct VoteStruct {
1044         address voter;
1045         uint256 time;
1046         bool    vote;
1047         uint256 power;
1048         bool    annulled;
1049         uint256 index;
1050     }
1051 
1052     struct ResultRecord {
1053         uint256 totalAvailable;
1054         uint256 requiredForResult;
1055         uint256 totalSoFar;
1056         uint256 yes;
1057         uint256 no;
1058         bool    requiresCounting;
1059     }
1060 
1061 
1062     mapping (uint256 => mapping (uint256 => VoteStruct) ) public VotesByProposalId;
1063     mapping (uint256 => mapping (address => VoteStruct) ) public VotesByCaster;
1064     mapping (uint256 => uint256 ) public VotesNumByProposalId;
1065     mapping (uint256 => ResultRecord ) public ResultsByProposalId;
1066 
1067     function RegisterVote(uint256 _proposalId, bool _myVote) public {
1068         address Voter = msg.sender;
1069 
1070         // get voting power
1071         uint256 VoterPower = getVotingPower(_proposalId, Voter);
1072 
1073         // get proposal for state
1074         ProposalRecord storage proposal = ProposalsById[_proposalId];
1075 
1076         // make sure voting power is greater than 0
1077         // make sure proposal.state allows receiving votes
1078         // make sure proposal.time_end has not passed.
1079 
1080         if(VoterPower > 0 && proposal.state == getRecordState("ACCEPTING_VOTES")) {
1081 
1082             // first check if this Voter has a record registered,
1083             // and if they did, annul initial vote, update results, and add new one
1084             if( hasPreviousVote(_proposalId, Voter) ) {
1085                 undoPreviousVote(_proposalId, Voter);
1086             }
1087 
1088             registerNewVote(_proposalId, Voter, _myVote, VoterPower);
1089 
1090             // this is where we can end voting before time if result.yes or result.no > totalSoFar
1091             tryEndVoting(_proposalId);
1092 
1093         } else {
1094             revert();
1095         }
1096     }
1097 
1098     function hasPreviousVote(uint256 _proposalId, address _voter) public view returns (bool) {
1099         VoteStruct storage previousVoteByCaster = VotesByCaster[_proposalId][_voter];
1100         if( previousVoteByCaster.power > 0 ) {
1101             return true;
1102         }
1103         return false;
1104     }
1105 
1106     function undoPreviousVote(uint256 _proposalId, address _voter) internal {
1107 
1108         VoteStruct storage previousVoteByCaster = VotesByCaster[_proposalId][_voter];
1109 
1110         // if( previousVoteByCaster.power > 0 ) {
1111             previousVoteByCaster.annulled = true;
1112 
1113             VoteStruct storage previousVoteByProposalId = VotesByProposalId[_proposalId][previousVoteByCaster.index];
1114             previousVoteByProposalId.annulled = true;
1115 
1116             ResultRecord storage result = ResultsByProposalId[_proposalId];
1117 
1118             // update total so far as well
1119             result.totalSoFar-= previousVoteByProposalId.power;
1120 
1121             if(previousVoteByProposalId.vote == true) {
1122                 result.yes-= previousVoteByProposalId.power;
1123             // } else if(previousVoteByProposalId.vote == false) {
1124             } else {
1125                 result.no-= previousVoteByProposalId.power;
1126             }
1127         // }
1128 
1129     }
1130 
1131     function registerNewVote(uint256 _proposalId, address _voter, bool _myVote, uint256 _power) internal {
1132 
1133         // handle new vote
1134         uint256 currentVoteId = VotesNumByProposalId[_proposalId]++;
1135         VoteStruct storage vote = VotesByProposalId[_proposalId][currentVoteId];
1136             vote.voter = _voter;
1137             vote.time = getTimestamp();
1138             vote.vote = _myVote;
1139             vote.power = _power;
1140             vote.index = currentVoteId;
1141 
1142         VotesByCaster[_proposalId][_voter] = VotesByProposalId[_proposalId][currentVoteId];
1143 
1144         addVoteIntoResult(_proposalId, _myVote, _power );
1145     }
1146 
1147     event EventAddVoteIntoResult ( uint256 indexed _proposalId, bool indexed _type, uint256 indexed _power );
1148 
1149     function addVoteIntoResult(uint256 _proposalId, bool _type, uint256 _power ) internal {
1150 
1151         EventAddVoteIntoResult(_proposalId, _type, _power );
1152 
1153         ResultRecord storage newResult = ResultsByProposalId[_proposalId];
1154         newResult.totalSoFar+= _power;
1155         if(_type == true) {
1156             newResult.yes+= _power;
1157         } else {
1158             newResult.no+= _power;
1159         }
1160     }
1161 
1162     function getTotalTokenVotingPower(address _voter) public view returns ( uint256 ) {
1163         address VaultAddress = FundingManagerEntity.getMyVaultAddress(_voter);
1164         uint256 VotingPower = TokenEntity.balanceOf(VaultAddress);
1165         VotingPower+= TokenEntity.balanceOf(_voter);
1166         return VotingPower;
1167     }
1168 
1169     function getVotingPower(uint256 _proposalId, address _voter) public view returns ( uint256 ) {
1170         uint256 VotingPower = 0;
1171         ProposalRecord storage proposal = ProposalsById[_proposalId];
1172 
1173         if(proposal.actionType == getActionType("AFTER_COMPLETE_CODE_UPGRADE")) {
1174 
1175             return TokenEntity.balanceOf(_voter);
1176 
1177         } else {
1178 
1179             address VaultAddress = FundingManagerEntity.getMyVaultAddress(_voter);
1180             if(VaultAddress != address(0x0)) {
1181                 VotingPower = TokenEntity.balanceOf(VaultAddress);
1182 
1183                 if( proposal.actionType == getActionType("PROJECT_DELISTING") ) {
1184                     // for project delisting, we want to also include tokens in the voter's wallet.
1185                     VotingPower+= TokenEntity.balanceOf(_voter);
1186                 }
1187             }
1188         }
1189         return VotingPower;
1190     }
1191 
1192 
1193     mapping( uint256 => uint256 ) public lastProcessedVoteIdByProposal;
1194     mapping( uint256 => uint256 ) public ProcessedVotesByProposal;
1195     mapping( uint256 => uint256 ) public VoteCountAtProcessingStartByProposal;
1196     uint256 public VoteCountPerProcess = 10;
1197 
1198     function setVoteCountPerProcess(uint256 _perProcess) external onlyDeployer {
1199         if(_perProcess > 0) {
1200             VoteCountPerProcess = _perProcess;
1201         } else {
1202             revert();
1203         }
1204     }
1205 
1206     event EventProcessVoteTotals ( uint256 indexed _proposalId, uint256 indexed start, uint256 indexed end );
1207 
1208     function ProcessVoteTotals(uint256 _proposalId, uint256 length) public onlyApplicationEntity {
1209 
1210         uint256 start = lastProcessedVoteIdByProposal[_proposalId] + 1;
1211         uint256 end = start + length - 1;
1212         if(end > VotesNumByProposalId[_proposalId]) {
1213             end = VotesNumByProposalId[_proposalId];
1214         }
1215 
1216         EventProcessVoteTotals(_proposalId, start, end);
1217 
1218         // first run
1219         if(start == 1) {
1220             // save vote count at start, so we can reset if it changes
1221             VoteCountAtProcessingStartByProposal[_proposalId] = VotesNumByProposalId[_proposalId];
1222 
1223             // reset vote totals to 0
1224             ResultRecord storage result = ResultsByProposalId[_proposalId];
1225             result.yes = 0;
1226             result.no = 0;
1227             result.totalSoFar = 0;
1228         }
1229 
1230         // reset to start if vote count has changed in the middle of processing run
1231         if(VoteCountAtProcessingStartByProposal[_proposalId] != VotesNumByProposalId[_proposalId]) {
1232             // we received votes while counting
1233             // reset from start
1234             lastProcessedVoteIdByProposal[_proposalId] = 0;
1235             // exit
1236             return;
1237         }
1238 
1239         for(uint256 i = start; i <= end; i++) {
1240 
1241             VoteStruct storage vote = VotesByProposalId[_proposalId][i - 1];
1242             // process vote into totals.
1243             if(vote.annulled != true) {
1244                 addVoteIntoResult(_proposalId, vote.vote, vote.power );
1245             }
1246 
1247             lastProcessedVoteIdByProposal[_proposalId]++;
1248         }
1249 
1250         // reset iterator so we can call it again.
1251         if(lastProcessedVoteIdByProposal[_proposalId] >= VotesNumByProposalId[_proposalId] ) {
1252 
1253             ProcessedVotesByProposal[_proposalId] = lastProcessedVoteIdByProposal[_proposalId];
1254             lastProcessedVoteIdByProposal[_proposalId] = 0;
1255             tryEndVoting(_proposalId);
1256         }
1257     }
1258 
1259     function canEndVoting(uint256 _proposalId) public view returns (bool) {
1260 
1261         ResultRecord memory result = ResultsByProposalId[_proposalId];
1262         if(result.requiresCounting == false) {
1263             if(result.yes > result.requiredForResult || result.no > result.requiredForResult) {
1264                 return true;
1265             }
1266         }
1267         else {
1268 
1269             if(ProcessedVotesByProposal[_proposalId] == VotesNumByProposalId[_proposalId]) {
1270                 if(result.yes > result.requiredForResult || result.no > result.requiredForResult) {
1271                     return true;
1272                 }
1273             }
1274 
1275         }
1276         return false;
1277     }
1278 
1279     function getProposalType(uint256 _proposalId) public view returns (uint8) {
1280         return ProposalsById[_proposalId].actionType;
1281     }
1282 
1283     function expiryChangesState(uint256 _proposalId) public view returns (bool) {
1284         ProposalRecord memory proposal = ProposalsById[_proposalId];
1285         if( proposal.state == getRecordState("ACCEPTING_VOTES") && proposal.time_end < getTimestamp() ) {
1286             return true;
1287         }
1288         return false;
1289     }
1290 
1291     function needsProcessing(uint256 _proposalId) public view returns (bool) {
1292         if( expiryChangesState(_proposalId) ) {
1293             return true;
1294         }
1295 
1296         ResultRecord memory result = ResultsByProposalId[_proposalId];
1297         if(result.requiresCounting == true) {
1298             if( lastProcessedVoteIdByProposal[_proposalId] < VotesNumByProposalId[_proposalId] ) {
1299                 if(ProcessedVotesByProposal[_proposalId] == VotesNumByProposalId[_proposalId]) {
1300                     return false;
1301                 }
1302             }
1303 
1304         } else {
1305             return false;
1306         }
1307 
1308         return true;
1309     }
1310 
1311     function tryEndVoting(uint256 _proposalId) internal {
1312         if(canEndVoting(_proposalId)) {
1313             finaliseProposal(_proposalId);
1314         }
1315 
1316         if(expiryChangesState(_proposalId) ) {
1317             finaliseExpiredProposal(_proposalId);
1318         }
1319     }
1320 
1321     function finaliseProposal(uint256 _proposalId) internal {
1322 
1323         ResultRecord storage result = ResultsByProposalId[_proposalId];
1324         ProposalRecord storage proposal = ProposalsById[_proposalId];
1325 
1326         // Milestone Deadline proposals cannot be ended "by majority vote", we rely on finaliseExpiredProposal here
1327         // because we want to allow everyone to be able to vote "NO" if they choose to cashback.
1328 
1329         if( proposal.actionType != getActionType("MILESTONE_DEADLINE")) {
1330             // read results,
1331             if(result.yes > result.requiredForResult) {
1332                 // voting resulted in YES
1333                 proposal.state = getRecordState("VOTING_RESULT_YES");
1334             } else if (result.no >= result.requiredForResult) {
1335                 // voting resulted in NO
1336                 proposal.state = getRecordState("VOTING_RESULT_NO");
1337             }
1338         }
1339 
1340         runActionAfterResult(_proposalId);
1341     }
1342 
1343     function finaliseExpiredProposal(uint256 _proposalId) internal {
1344 
1345         ResultRecord storage result = ResultsByProposalId[_proposalId];
1346         ProposalRecord storage proposal = ProposalsById[_proposalId];
1347 
1348         // an expired proposal with no votes will end as YES
1349         if(result.yes == 0 && result.no == 0) {
1350             proposal.state = getRecordState("VOTING_RESULT_YES");
1351         } else {
1352             // read results,
1353             if(result.yes > result.no) {
1354                 // voting resulted in YES
1355                 proposal.state = getRecordState("VOTING_RESULT_YES");
1356             } else if (result.no >= result.yes) {
1357                 // tie equals no
1358                 // voting resulted in NO
1359                 proposal.state = getRecordState("VOTING_RESULT_NO");
1360             }
1361         }
1362         runActionAfterResult(_proposalId);
1363     }
1364 
1365     function tryFinaliseNonLockedTokensProposal(uint256 _proposalId) internal {
1366 
1367         ResultRecord storage result = ResultsByProposalId[_proposalId];
1368         ProposalRecord storage proposal = ProposalsById[_proposalId];
1369 
1370         if(result.requiredForResult == 0) {
1371             proposal.state = getRecordState("VOTING_RESULT_YES");
1372             runActionAfterResult(_proposalId);
1373         }
1374     }
1375 
1376     function addActiveProposal(uint256 _proposalId) internal {
1377         ActiveProposalIds[ActiveProposalNum++]= _proposalId;
1378     }
1379 
1380     function removeAndReindexActive(uint256 _proposalId) internal {
1381 
1382         bool found = false;
1383         for (uint8 i = 0; i < ActiveProposalNum; i++) {
1384             if(ActiveProposalIds[i] == _proposalId) {
1385                 found = true;
1386             }
1387             if(found) {
1388                 ActiveProposalIds[i] = ActiveProposalIds[i+1];
1389             }
1390         }
1391 
1392         ActiveProposalNum--;
1393     }
1394 
1395 
1396     bool public EmergencyFundingReleaseApproved = false;
1397 
1398     function runActionAfterResult(uint256 _proposalId) internal {
1399 
1400         ProposalRecord storage proposal = ProposalsById[_proposalId];
1401 
1402         if(proposal.state == getRecordState("VOTING_RESULT_YES")) {
1403 
1404             if(proposal.actionType == getActionType("MILESTONE_DEADLINE")) {
1405 
1406             } else if (proposal.actionType == getActionType("MILESTONE_POSTPONING")) {
1407 
1408             } else if (proposal.actionType == getActionType("EMERGENCY_FUND_RELEASE")) {
1409                 EmergencyFundingReleaseApproved = true;
1410 
1411             } else if (proposal.actionType == getActionType("PROJECT_DELISTING")) {
1412 
1413                 ListingContractEntity.delistChild( proposal.extra );
1414 
1415             } else if (
1416                 proposal.actionType == getActionType("IN_DEVELOPMENT_CODE_UPGRADE") ||
1417                 proposal.actionType == getActionType("AFTER_COMPLETE_CODE_UPGRADE")
1418             ) {
1419 
1420                 // initiate code upgrade
1421                 acceptCodeUpgrade(_proposalId);
1422             }
1423 
1424             removeAndReindexActive(_proposalId);
1425 
1426         } else if(proposal.state == getRecordState("VOTING_RESULT_NO")) {
1427 
1428             //
1429             if(proposal.actionType == getActionType("MILESTONE_DEADLINE")) {
1430 
1431             } else {
1432                 removeAndReindexActive(_proposalId);
1433             }
1434         }
1435     }
1436 
1437     // used by vault cash back
1438     function getMyVoteForCurrentMilestoneRelease(address _voter) public view returns (bool) {
1439         // find proposal id for current milestone
1440         uint8 recordId = MilestonesEntity.currentRecord();
1441         bytes32 hash = getHash( getActionType("MILESTONE_DEADLINE"), bytes32( recordId ), 0 );
1442         uint256 proposalId = ProposalIdByHash[hash];
1443         // based on that proposal id, find my vote
1444         VoteStruct memory vote = VotesByCaster[proposalId][_voter];
1445         return vote.vote;
1446     }
1447 
1448     function getHasVoteForCurrentMilestoneRelease(address _voter) public view returns (bool) {
1449         // find proposal id for current milestone
1450         uint8 recordId = MilestonesEntity.currentRecord();
1451         bytes32 hash = getHash( getActionType("MILESTONE_DEADLINE"), bytes32( recordId ), 0 );
1452         uint256 proposalId = ProposalIdByHash[hash];
1453         return hasPreviousVote(proposalId, _voter);
1454     }
1455 
1456     function getMyVote(uint256 _proposalId, address _voter) public view returns (bool) {
1457         VoteStruct memory vote = VotesByCaster[_proposalId][_voter];
1458         return vote.vote;
1459     }
1460 
1461 }