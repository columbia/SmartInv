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
315  * @name        Funding Contract ABI
316  * @package     BlockBitsIO
317  * @author      Micky Socaci <micky@nowlive.ro>
318 
319  Contains the Funding Contract code deployed and linked to the Application Entity
320 
321 */
322 
323 
324 
325 
326 
327 contract ABIFundingManager is ABIApplicationAsset {
328 
329     bool public fundingProcessed;
330     bool FundingPoolBalancesAllocated;
331     uint8 public VaultCountPerProcess;
332     uint256 public lastProcessedVaultId;
333     uint256 public vaultNum;
334     uint256 public LockedVotingTokens;
335     bytes32 public currentTask;
336     mapping (bytes32 => bool) public taskByHash;
337     mapping  (address => address) public vaultList;
338     mapping  (uint256 => address) public vaultById;
339 
340     function receivePayment(address _sender, uint8 _payment_method, uint8 _funding_stage) payable public returns(bool);
341     function getMyVaultAddress(address _sender) public view returns (address);
342     function setVaultCountPerProcess(uint8 _perProcess) external;
343     function getHash(bytes32 actionType, bytes32 arg1) public pure returns ( bytes32 );
344     function getCurrentMilestoneProcessed() public view returns (bool);
345     function processFundingFailedFinished() public view returns (bool);
346     function processFundingSuccessfulFinished() public view returns (bool);
347     function getCurrentMilestoneIdHash() internal view returns (bytes32);
348     function processMilestoneFinished() public view returns (bool);
349     function processEmergencyFundReleaseFinished() public view returns (bool);
350     function getAfterTransferLockedTokenBalances(address vaultAddress, bool excludeCurrent) public view returns (uint256);
351     function VaultRequestedUpdateForLockedVotingTokens(address owner) public;
352     function doStateChanges() public;
353     function hasRequiredStateChanges() public view returns (bool);
354     function getRequiredStateChanges() public view returns (uint8, uint8);
355     function ApplicationInFundingOrDevelopment() public view returns(bool);
356 
357 }
358 
359 /*
360 
361  * source       https://github.com/blockbitsio/
362 
363  * @name        Meetings Contract ABI
364  * @package     BlockBitsIO
365  * @author      Micky Socaci <micky@nowlive.ro>
366 
367  Contains the Meetings Contract code deployed and linked to the Application Entity
368 
369 */
370 
371 
372 
373 
374 
375 contract ABIMeetings is ABIApplicationAsset {
376     struct Record {
377         bytes32 hash;
378         bytes32 name;
379         uint8 state;
380         uint256 time_start;                     // start at unixtimestamp
381         uint256 duration;
382         uint8 index;
383     }
384     mapping (uint8 => Record) public Collection;
385 }
386 
387 /*
388 
389  * source       https://github.com/blockbitsio/
390 
391  * @name        Proposals Contract
392  * @package     BlockBitsIO
393  * @author      Micky Socaci <micky@nowlive.ro>
394 
395  Contains the Proposals Contract code deployed and linked to the Application Entity
396 
397 */
398 
399 
400 
401 
402 
403 contract ABIProposals is ABIApplicationAsset {
404 
405     address public Application;
406     address public ListingContractEntity;
407     address public FundingEntity;
408     address public FundingManagerEntity;
409     address public TokenManagerEntity;
410     address public TokenEntity;
411     address public MilestonesEntity;
412 
413     struct ProposalRecord {
414         address creator;
415         bytes32 name;
416         uint8 actionType;
417         uint8 state;
418         bytes32 hash;                       // action name + args hash
419         address addr;
420         bytes32 sourceCodeUrl;
421         uint256 extra;
422         uint256 time_start;
423         uint256 time_end;
424         uint256 index;
425     }
426 
427     struct VoteStruct {
428         address voter;
429         uint256 time;
430         bool    vote;
431         uint256 power;
432         bool    annulled;
433         uint256 index;
434     }
435 
436     struct ResultRecord {
437         uint256 totalAvailable;
438         uint256 requiredForResult;
439         uint256 totalSoFar;
440         uint256 yes;
441         uint256 no;
442         bool    requiresCounting;
443     }
444 
445     uint8 public ActiveProposalNum;
446     uint256 public VoteCountPerProcess;
447     bool public EmergencyFundingReleaseApproved;
448 
449     mapping (bytes32 => uint8) public ActionTypes;
450     mapping (uint8 => uint256) public ActiveProposalIds;
451     mapping (uint256 => bool) public ExpiredProposalIds;
452     mapping (uint256 => ProposalRecord) public ProposalsById;
453     mapping (bytes32 => uint256) public ProposalIdByHash;
454     mapping (uint256 => mapping (uint256 => VoteStruct) ) public VotesByProposalId;
455     mapping (uint256 => mapping (address => VoteStruct) ) public VotesByCaster;
456     mapping (uint256 => uint256) public VotesNumByProposalId;
457     mapping (uint256 => ResultRecord ) public ResultsByProposalId;
458     mapping (uint256 => uint256) public lastProcessedVoteIdByProposal;
459     mapping (uint256 => uint256) public ProcessedVotesByProposal;
460     mapping (uint256 => uint256) public VoteCountAtProcessingStartByProposal;
461 
462     function getRecordState(bytes32 name) public view returns (uint8);
463     function getActionType(bytes32 name) public view returns (uint8);
464     function getProposalState(uint256 _proposalId) public view returns (uint8);
465     function getBylawsProposalVotingDuration() public view returns (uint256);
466     function getBylawsMilestoneMinPostponing() public view returns (uint256);
467     function getBylawsMilestoneMaxPostponing() public view returns (uint256);
468     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 );
469     function process() public;
470     function hasRequiredStateChanges() public view returns (bool);
471     function getRequiredStateChanges() public view returns (uint8);
472     function addCodeUpgradeProposal(address _addr, bytes32 _sourceCodeUrl) external returns (uint256);
473     function createMilestoneAcceptanceProposal() external returns (uint256);
474     function createMilestonePostponingProposal(uint256 _duration) external returns (uint256);
475     function getCurrentMilestonePostponingProposalDuration() public view returns (uint256);
476     function getCurrentMilestoneProposalStatusForType(uint8 _actionType ) public view returns (uint8);
477     function createEmergencyFundReleaseProposal() external returns (uint256);
478     function createDelistingProposal(uint256 _projectId) external returns (uint256);
479     function RegisterVote(uint256 _proposalId, bool _myVote) public;
480     function hasPreviousVote(uint256 _proposalId, address _voter) public view returns (bool);
481     function getTotalTokenVotingPower(address _voter) public view returns ( uint256 );
482     function getVotingPower(uint256 _proposalId, address _voter) public view returns ( uint256 );
483     function setVoteCountPerProcess(uint256 _perProcess) external;
484     function ProcessVoteTotals(uint256 _proposalId, uint256 length) public;
485     function canEndVoting(uint256 _proposalId) public view returns (bool);
486     function getProposalType(uint256 _proposalId) public view returns (uint8);
487     function expiryChangesState(uint256 _proposalId) public view returns (bool);
488     function needsProcessing(uint256 _proposalId) public view returns (bool);
489     function getMyVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
490     function getHasVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
491     function getMyVote(uint256 _proposalId, address _voter) public view returns (bool);
492 
493 }
494 
495 /*
496 
497  * source       https://github.com/blockbitsio/
498 
499  * @name        Milestones Contract
500  * @package     BlockBitsIO
501  * @author      Micky Socaci <micky@nowlive.ro>
502 
503  Contains the Milestones Contract code deployed and linked to the Application Entity
504 
505 */
506 
507 
508 
509 
510 
511 
512 
513 
514 
515 contract Milestones is ApplicationAsset {
516 
517     ABIFundingManager FundingManagerEntity;
518     ABIProposals ProposalsEntity;
519     ABIMeetings MeetingsEntity;
520 
521     struct Record {
522         bytes32 name;
523         string description;                     // will change to hash pointer ( external storage )
524         uint8 state;
525         uint256 duration;
526         uint256 time_start;                     // start at unixtimestamp
527         uint256 last_state_change_time;         // time of last state change
528         uint256 time_end;                       // estimated end time >> can be increased by proposal
529         uint256 time_ended;                     // actual end time
530         uint256 meeting_time;
531         uint8 funding_percentage;
532         uint8 index;
533     }
534 
535     mapping (uint8 => Record) public Collection;
536     uint8 public currentRecord = 1;
537 
538     event DebugRecordRequiredChanges( bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required );
539     event DebugCallAgain(uint8 indexed _who);
540 
541     event EventEntityProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);
542     event EventRecordProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);
543 
544     event DebugAction(bytes32 indexed _name, bool indexed _allowed);
545 
546 
547     function setAssetStates() internal {
548 
549         // Contract States
550         EntityStates["__IGNORED__"]                  = 0;
551         EntityStates["NEW"]                          = 1;
552         EntityStates["WAITING"]                      = 2;
553 
554         EntityStates["IN_DEVELOPMENT"]               = 5;
555 
556         EntityStates["WAITING_MEETING_TIME"]         = 10;
557         EntityStates["DEADLINE_MEETING_TIME_YES"]    = 11;
558         EntityStates["DEADLINE_MEETING_TIME_FAILED"] = 12;
559 
560         EntityStates["VOTING_IN_PROGRESS"]           = 20;
561         // EntityStates["VOTING_ENDED"]              = 21;
562         EntityStates["VOTING_ENDED_YES"]             = 22;
563         EntityStates["VOTING_ENDED_NO"]              = 23;
564         EntityStates["VOTING_ENDED_NO_FINAL"]        = 25;
565 
566         EntityStates["VOTING_FUNDS_PROCESSED"]       = 30;
567         EntityStates["FINAL"]                        = 50;
568 
569         EntityStates["CASHBACK_OWNER_MIA"]           = 99;
570         EntityStates["DEVELOPMENT_COMPLETE"]         = 250;
571 
572         // Funding Stage States
573         RecordStates["__IGNORED__"]     = 0;
574         RecordStates["NEW"]             = 1;
575         RecordStates["IN_PROGRESS"]     = 2;
576         RecordStates["FINAL"]           = 3;
577     }
578 
579     function runBeforeInitialization() internal requireNotInitialised {
580         FundingManagerEntity = ABIFundingManager( getApplicationAssetAddressByName('FundingManager') );
581         MeetingsEntity = ABIMeetings( getApplicationAssetAddressByName('Meetings') );
582         ProposalsEntity = ABIProposals( getApplicationAssetAddressByName('Proposals') );
583         EventRunBeforeInit(assetName);
584     }
585 
586     function runBeforeApplyingSettings() internal requireInitialised requireSettingsNotApplied  {
587         // setup first milestone
588         Record storage rec = Collection[currentRecord];
589             rec.time_start = getBylawsProjectDevelopmentStart();
590             rec.time_end = rec.time_start + rec.duration;
591         EventRunBeforeApplyingSettings(assetName);
592     }
593 
594     function getBylawsProjectDevelopmentStart() public view returns (uint256) {
595         return getAppBylawUint256("development_start");
596     }
597 
598     function getBylawsMinTimeInTheFutureForMeetingCreation() public view returns (uint256) {
599         return getAppBylawUint256("meeting_time_set_req");
600     }
601 
602     function getBylawsCashBackVoteRejectedDuration() public view returns (uint256) {
603         return getAppBylawUint256("cashback_investor_no");
604     }
605 
606     /*
607     * Add Record
608     *
609     * @param        bytes32 _name
610     * @param        string _description
611     * @param        uint256 _duration
612     * @param        uint256 _funding_percentage
613     *
614     * @access       public
615     * @type         method
616     * @modifiers    onlyDeployer, requireNotInitialised
617     */
618     function addRecord(
619         bytes32 _name,
620         string _description,
621         uint256 _duration,
622         uint8   _perc
623     )
624         public
625         onlyDeployer
626         requireSettingsNotApplied
627     {
628 
629         Record storage rec = Collection[++RecordNum];
630 
631         rec.name                = _name;
632         rec.description         = _description;
633         rec.duration            = _duration;
634         rec.funding_percentage  = _perc;
635         rec.state               = getRecordState("NEW");
636         rec.index               = RecordNum;
637     }
638 
639     function getMilestoneFundingPercentage(uint8 recordId) public view returns (uint8){
640         return Collection[recordId].funding_percentage;
641     }
642 
643     function doStateChanges() public {
644 
645         var (CurrentRecordState, RecordStateRequired, EntityStateRequired) = getRequiredStateChanges();
646         bool callAgain = false;
647 
648         DebugRecordRequiredChanges( assetName, CurrentRecordState, RecordStateRequired );
649         DebugEntityRequiredChanges( assetName, CurrentEntityState, EntityStateRequired );
650 
651         if( RecordStateRequired != getRecordState("__IGNORED__") ) {
652             // process record changes.
653             RecordProcessor(CurrentRecordState, RecordStateRequired);
654             DebugCallAgain(2);
655             callAgain = true;
656         }
657 
658         if(EntityStateRequired != getEntityState("__IGNORED__") ) {
659             // process entity changes.
660             EntityProcessor(EntityStateRequired);
661             DebugCallAgain(1);
662             callAgain = true;
663         }
664 
665 
666     }
667 
668     function MilestonesCanChange() internal view returns (bool) {
669         if(
670             CurrentEntityState == getEntityState("WAITING") ||
671             CurrentEntityState == getEntityState("IN_DEVELOPMENT") ||
672             CurrentEntityState == getEntityState("VOTING_FUNDS_PROCESSED")
673         ) {
674             return true;
675         }
676         return false;
677     }
678 
679 
680     /*
681      * Method: Get Record Required State Changes
682      *
683      * @access       public
684      * @type         method
685      *
686      * @return       uint8 RecordStateRequired
687      */
688     function getRecordStateRequiredChanges() public view returns (uint8) {
689         Record memory record = Collection[currentRecord];
690         uint8 RecordStateRequired = getRecordState("__IGNORED__");
691 
692         if( ApplicationIsInDevelopment() && MilestonesCanChange() ) {
693 
694             if( record.state == getRecordState("NEW") ) {
695 
696                 if( getTimestamp() >= record.time_start ) {
697                     RecordStateRequired = getRecordState("IN_PROGRESS");
698                 }
699 
700             } else if( record.state == getRecordState("IN_PROGRESS") ) {
701 
702                 if( getTimestamp() >= record.time_end || ( getTimestamp() >= record.meeting_time && record.meeting_time > 0 ) ) {
703                     RecordStateRequired = getRecordState("FINAL");
704                 }
705             }
706 
707             if( record.state == RecordStateRequired ) {
708                 RecordStateRequired = getRecordState("__IGNORED__");
709             }
710         }
711         return RecordStateRequired;
712     }
713 
714 
715     function hasRequiredStateChanges() public view returns (bool) {
716         bool hasChanges = false;
717         var (CurrentRecordState, RecordStateRequired, EntityStateRequired) = getRequiredStateChanges();
718         CurrentRecordState = 0;
719 
720         if( RecordStateRequired != getRecordState("__IGNORED__") ) {
721             hasChanges = true;
722         }
723         if(EntityStateRequired != getEntityState("__IGNORED__") ) {
724             hasChanges = true;
725         }
726 
727         return hasChanges;
728     }
729 
730     // view methods decide if changes are to be made
731     // in case of tasks, we do them in the Processors.
732 
733     function RecordProcessor(uint8 CurrentRecordState, uint8 RecordStateRequired) internal {
734         EventRecordProcessor( assetName, CurrentRecordState, RecordStateRequired );
735         updateRecord( RecordStateRequired );
736     }
737 
738 
739     function EntityProcessor(uint8 EntityStateRequired) internal {
740         EventEntityProcessor( assetName, CurrentEntityState, EntityStateRequired );
741 
742         // Do State Specific Updates
743         // Update our Entity State
744         CurrentEntityState = EntityStateRequired;
745 
746         if ( CurrentEntityState == getEntityState("DEADLINE_MEETING_TIME_YES") ) {
747             // create meeting
748             // Meetings.create("internal", "MILESTONE_END", "");
749 
750         } else if( CurrentEntityState == getEntityState("VOTING_IN_PROGRESS") ) {
751             // create proposal and start voting on it
752             createMilestoneAcceptanceProposal();
753 
754         } else if( CurrentEntityState == getEntityState("WAITING_MEETING_TIME") ) {
755 
756             PostponeMeetingIfApproved();
757 
758         } else if( CurrentEntityState == getEntityState("VOTING_ENDED_YES") ) {
759 
760         } else if( CurrentEntityState == getEntityState("VOTING_ENDED_NO") ) {
761 
762             // possible cashback time starts from now
763             MilestoneCashBackTime = getTimestamp();
764 
765         } else if( CurrentEntityState == getEntityState("VOTING_FUNDS_PROCESSED") ) {
766             MilestoneCashBackTime = 0;
767             startNextMilestone();
768         }
769 
770     }
771 
772     mapping (bytes32 => bool) public MilestonePostponingHash;
773 
774     function PostponeMeetingIfApproved() internal {
775         if(MilestonePostponingHash[ bytes32(currentRecord) ] == false ) {
776             if(PostponeForCurrentMilestoneIsApproved()) {
777                 uint256 time = ProposalsEntity.getCurrentMilestonePostponingProposalDuration();
778                 Record storage record = Collection[currentRecord];
779                 record.time_end = record.time_end + time;
780                 MilestonePostponingHash[ bytes32(currentRecord) ] = true;
781             }
782         }
783     }
784 
785     function PostponeForCurrentMilestoneIsApproved() internal view returns ( bool ) {
786         uint8 ProposalActionType = ProposalsEntity.getActionType("MILESTONE_POSTPONING");
787         uint8 ProposalRecordState = ProposalsEntity.getCurrentMilestoneProposalStatusForType( ProposalActionType  );
788         if(ProposalRecordState == ProposalsEntity.getRecordState("VOTING_RESULT_YES") ) {
789             return true;
790         }
791         return false;
792     }
793 
794     uint256 public MilestoneCashBackTime = 0;
795 
796     function afterVoteNoCashBackTime() public view returns ( bool ) {
797         uint256 time =  MilestoneCashBackTime + getBylawsCashBackVoteRejectedDuration();
798         // after cash back time
799         if(getTimestamp() > time) {
800             return true;
801         }
802         return false;
803     }
804 
805     function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 ) {
806         return keccak256(actionType, arg1, arg2);
807     }
808 
809     function getCurrentHash() public view returns ( bytes32 ) {
810         return getHash(1, bytes32(currentRecord), 0);
811     }
812 
813     mapping (bytes32 => uint256) public ProposalIdByHash;
814     function createMilestoneAcceptanceProposal() internal {
815         if(ProposalIdByHash[ getCurrentHash() ] == 0x0 ) {
816             ProposalIdByHash[ getCurrentHash() ] = ProposalsEntity.createMilestoneAcceptanceProposal();
817         }
818     }
819 
820     function getCurrentProposalId() internal view returns ( uint256 ) {
821         return ProposalIdByHash[ getCurrentHash() ];
822     }
823 
824     function setCurrentMilestoneMeetingTime(uint256 _meeting_time) public onlyDeployer {
825         if ( CurrentEntityState == getEntityState("WAITING_MEETING_TIME") ) {
826             if(MeetingTimeSetFailure() == false ) {
827                 Record storage record = Collection[currentRecord];
828                 // minimum x days into the future
829                 uint256 min = getTimestamp() + getBylawsMinTimeInTheFutureForMeetingCreation();
830                 // minimum days before end date
831                 uint256 max = record.time_end + 24 * 3600;
832                 if(_meeting_time > min && _meeting_time < max ) {
833                     record.meeting_time = _meeting_time;
834                 }
835             } else {
836                 revert();
837             }
838         } else {
839             revert();
840         }
841     }
842 
843     function startNextMilestone() internal {
844         Record storage rec = Collection[currentRecord];
845 
846         // set current record end date etc
847         rec.time_ended = getTimestamp();
848         rec.state = getRecordState("FINAL");
849 
850         if(currentRecord < RecordNum) {
851             // jump to next milestone
852             currentRecord++;
853 
854             Record storage nextRec = Collection[currentRecord];
855                 nextRec.time_start = rec.time_ended;
856                 nextRec.time_end = rec.time_ended + nextRec.duration;
857         }
858 
859     }
860 
861     /*
862     * Update Existing Record
863     *
864     * @param        uint8 _record_id
865     * @param        uint8 _new_state
866     * @param        uint8 _duration
867     *
868     * @access       public
869     * @type         method
870     * @modifiers    onlyOwner, requireInitialised, RecordUpdateAllowed
871     *
872     * @return       void
873     */
874 
875     function updateRecord( uint8 _new_state )
876         internal
877         requireInitialised
878         RecordUpdateAllowed(_new_state)
879         returns (bool)
880     {
881         Record storage rec = Collection[currentRecord];
882         rec.state       = _new_state;
883         return true;
884     }
885 
886 
887     /*
888     * Modifier: Validate if record updates are allowed
889     *
890     * @type         modifier
891     *
892     * @param        uint8 _record_id
893     * @param        uint8 _new_state
894     * @param        uint256 _duration
895     *
896     * @return       bool
897     */
898 
899     modifier RecordUpdateAllowed(uint8 _new_state) {
900         require( isRecordUpdateAllowed( _new_state )  );
901         _;
902     }
903 
904     /*
905      * Method: Validate if record can be updated to requested state
906      *
907      * @access       public
908      * @type         method
909      *
910      * @param        uint8 _record_id
911      * @param        uint8 _new_state
912      *
913      * @return       bool
914      */
915     function isRecordUpdateAllowed(uint8 _new_state ) public view returns (bool) {
916 
917         var (CurrentRecordState, RecordStateRequired, EntityStateRequired) = getRequiredStateChanges();
918 
919         CurrentRecordState = 0;
920         EntityStateRequired = 0;
921 
922         if(_new_state == uint8(RecordStateRequired)) {
923             return true;
924         }
925         return false;
926     }
927 
928     /*
929      * Method: Get Record and Entity State Changes
930      *
931      * @access       public
932      * @type         method
933      *
934      * @return       ( uint8 CurrentRecordState, uint8 RecordStateRequired, uint8 EntityStateRequired)
935      */
936     function getRequiredStateChanges() public view returns (uint8, uint8, uint8) {
937 
938         Record memory record = Collection[currentRecord];
939 
940         uint8 CurrentRecordState = record.state;
941         uint8 RecordStateRequired = getRecordStateRequiredChanges();
942         uint8 EntityStateRequired = getEntityState("__IGNORED__");
943 
944         if( ApplicationIsInDevelopment() ) {
945 
946             // Do Entity Checks
947 
948             if ( CurrentEntityState == getEntityState("WAITING") ) {
949 
950                 if(RecordStateRequired == getRecordState("IN_PROGRESS") ) {
951                     // both record and entity states need to move to IN_PROGRESS
952                     EntityStateRequired = getEntityState("IN_DEVELOPMENT");
953                 }
954 
955             } else if ( CurrentEntityState == getEntityState("IN_DEVELOPMENT") ) {
956 
957                 EntityStateRequired = getEntityState("WAITING_MEETING_TIME");
958 
959             } else if ( CurrentEntityState == getEntityState("WAITING_MEETING_TIME") ) {
960 
961                 if(record.meeting_time > 0) {
962 
963                     EntityStateRequired = getEntityState("DEADLINE_MEETING_TIME_YES");
964 
965                 } else {
966 
967                     if(MilestonePostponingHash[ bytes32(currentRecord) ] == false) {
968                         if(PostponeForCurrentMilestoneIsApproved()) {
969                             EntityStateRequired = getEntityState("WAITING_MEETING_TIME");
970                         }
971                     }
972 
973                     if(MeetingTimeSetFailure()) {
974                         // Force Owner Missing in Action - Cash Back Procedure
975                         EntityStateRequired = getEntityState("DEADLINE_MEETING_TIME_FAILED");
976                     }
977                 }
978 
979             } else if ( CurrentEntityState == getEntityState("DEADLINE_MEETING_TIME_FAILED") ) {
980 
981 
982             } else if ( CurrentEntityState == getEntityState("DEADLINE_MEETING_TIME_YES") ) {
983 
984                 // create proposal
985                 // start voting if time passed
986                 if(getTimestamp() >= record.meeting_time ) {
987                     EntityStateRequired = getEntityState("VOTING_IN_PROGRESS");
988                 }
989 
990             } else if ( CurrentEntityState == getEntityState("VOTING_IN_PROGRESS") ) {
991 
992                 uint8 ProposalRecordState = ProposalsEntity.getProposalState( getCurrentProposalId() );
993 
994                 if ( ProposalRecordState == ProposalsEntity.getRecordState("VOTING_RESULT_YES") ) {
995                     EntityStateRequired = getEntityState("VOTING_ENDED_YES");
996                 }
997 
998                 if (ProposalRecordState == ProposalsEntity.getRecordState("VOTING_RESULT_NO") ) {
999                     EntityStateRequired = getEntityState("VOTING_ENDED_NO");
1000                 }
1001 
1002             } else if ( CurrentEntityState == getEntityState("VOTING_ENDED_YES") ) {
1003 
1004                 if( FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState("MILESTONE_PROCESS_DONE")) {
1005                     EntityStateRequired = getEntityState("VOTING_FUNDS_PROCESSED");
1006                 }
1007 
1008             } else if ( CurrentEntityState == getEntityState("VOTING_ENDED_NO") ) {
1009 
1010                 // check if milestone cashout period has passed and if so process fund releases
1011                 if(afterVoteNoCashBackTime()) {
1012                     EntityStateRequired = getEntityState("VOTING_ENDED_NO_FINAL");
1013                 }
1014 
1015             } else if ( CurrentEntityState == getEntityState("VOTING_ENDED_NO_FINAL") ) {
1016 
1017                 if( FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState("MILESTONE_PROCESS_DONE")) {
1018                     EntityStateRequired = getEntityState("VOTING_FUNDS_PROCESSED");
1019                 }
1020 
1021             } else if ( CurrentEntityState == getEntityState("VOTING_FUNDS_PROCESSED") ) {
1022 
1023 
1024                 if(currentRecord < RecordNum) {
1025                     EntityStateRequired = getEntityState("IN_DEVELOPMENT");
1026                 } else {
1027 
1028                     if(FundingManagerEntity.getCurrentMilestoneProcessed() == true) {
1029                         if(FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState("COMPLETE_PROCESS_DONE")) {
1030                             EntityStateRequired = getEntityState("DEVELOPMENT_COMPLETE");
1031                         } else {
1032                             EntityStateRequired = getEntityState("VOTING_FUNDS_PROCESSED");
1033                         }
1034                     } else {
1035                         EntityStateRequired = getEntityState("IN_DEVELOPMENT");
1036                     }
1037                 }
1038 
1039             }
1040             /*
1041             else if ( CurrentEntityState == getEntityState("DEVELOPMENT_COMPLETE") ) {
1042 
1043             }
1044             */
1045 
1046         } else {
1047 
1048             if( CurrentEntityState == getEntityState("NEW") ) {
1049                 EntityStateRequired = getEntityState("WAITING");
1050             }
1051         }
1052 
1053         return (CurrentRecordState, RecordStateRequired, EntityStateRequired);
1054     }
1055 
1056     function ApplicationIsInDevelopment() public view returns(bool) {
1057         if( getApplicationState() == getApplicationEntityState("IN_DEVELOPMENT") ) {
1058             return true;
1059         }
1060         return false;
1061     }
1062 
1063     function MeetingTimeSetFailure() public view returns (bool) {
1064         Record memory record = Collection[currentRecord];
1065         uint256 meetingCreationMaxTime = record.time_end - getBylawsMinTimeInTheFutureForMeetingCreation();
1066         if(getTimestamp() >= meetingCreationMaxTime ) {
1067             return true;
1068         }
1069         return false;
1070     }
1071 
1072 }