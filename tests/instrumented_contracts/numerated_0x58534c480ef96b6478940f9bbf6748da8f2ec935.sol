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
363  * @name        Token Manager Contract
364  * @package     BlockBitsIO
365  * @author      Micky Socaci <micky@nowlive.ro>
366 
367 */
368 
369 
370 
371 
372 
373 contract ABITokenManager is ABIApplicationAsset {
374 
375     address public TokenSCADAEntity;
376     address public TokenEntity;
377     address public MarketingMethodAddress;
378     bool OwnerTokenBalancesReleased = false;
379 
380     function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) public;
381     function getTokenSCADARequiresHardCap() public view returns (bool);
382     function mint(address _to, uint256 _amount) public returns (bool);
383     function finishMinting() public returns (bool);
384     function mintForMarketingPool(address _to, uint256 _amount) external returns (bool);
385     function ReleaseOwnersLockedTokens(address _multiSigOutputAddress) public returns (bool);
386 
387 }
388 
389 /*
390 
391  * source       https://github.com/blockbitsio/
392 
393  * @name        General Funding Input Contract ABI
394  * @package     BlockBitsIO
395  * @author      Micky Socaci <micky@nowlive.ro>
396 
397 */
398 
399 
400 
401 contract ABIFundingInputGeneral {
402 
403     bool public initialized = false;
404     uint8 public typeId;
405     address public FundingAssetAddress;
406 
407     event EventInputPaymentReceived(address sender, uint amount, uint8 _type);
408 
409     function setFundingAssetAddress(address _addr) public;
410     function () public payable;
411     function buy() public payable returns(bool);
412 }
413 
414 /*
415 
416  * source       https://github.com/blockbitsio/
417 
418  * @name        Funding Contract
419  * @package     BlockBitsIO
420  * @author      Micky Socaci <micky@nowlive.ro>
421 
422  Contains the Funding Contract code deployed and linked to the Application Entity
423 
424  !!! Links directly to Milestones
425 
426 */
427 
428 
429 
430 
431 
432 
433 
434 
435 
436 
437 contract Funding is ApplicationAsset {
438 
439     address public multiSigOutputAddress;
440     ABIFundingInputGeneral public DirectInput;
441     ABIFundingInputGeneral public MilestoneInput;
442 
443     // mapping (bytes32 => uint8) public FundingMethods;
444     enum FundingMethodIds {
445         __IGNORED__,
446         DIRECT_ONLY, 				//
447         MILESTONE_ONLY, 		    //
448         DIRECT_AND_MILESTONE		//
449     }
450 
451     ABITokenManager public TokenManagerEntity;
452     ABIFundingManager public FundingManagerEntity;
453 
454     event FundingStageCreated( uint8 indexed index, bytes32 indexed name );
455 
456     struct FundingStage {
457         bytes32 name;
458         uint8   state;
459         uint256 time_start;
460         uint256 time_end;
461         uint256 amount_cap_soft;            // 0 = not enforced
462         uint256 amount_cap_hard;            // 0 = not enforced
463         uint256 amount_raised;              // 0 = not enforced
464         // funding method settings
465         uint256 minimum_entry;
466         uint8   methods;                    // FundingMethodIds
467         // token settings
468         uint256 fixed_tokens;
469         uint8   price_addition_percentage;  //
470         uint8   token_share_percentage;
471         uint8   index;
472     }
473 
474     mapping (uint8 => FundingStage) public Collection;
475     uint8 public FundingStageNum = 0;
476     uint8 public currentFundingStage = 1;
477 
478     // funding settings
479     uint256 public AmountRaised = 0;
480     uint256 public MilestoneAmountRaised = 0;
481 
482     uint256 public GlobalAmountCapSoft = 0;
483     uint256 public GlobalAmountCapHard = 0;
484 
485     uint8 public TokenSellPercentage = 0;
486 
487     uint256 public Funding_Setting_funding_time_start = 0;
488     uint256 public Funding_Setting_funding_time_end = 0;
489 
490     uint256 public Funding_Setting_cashback_time_start = 0;
491     // end time is ignored at this stage, anyone can cashback forever if funding fails.
492     uint256 public Funding_Setting_cashback_time_end = 0;
493 
494     // to be taken from application bylaws
495     uint256 public Funding_Setting_cashback_before_start_wait_duration = 7 days;
496     uint256 public Funding_Setting_cashback_duration = 365 days;
497 
498     event LifeCycle();
499     event DebugRecordRequiredChanges( bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required );
500     event DebugCallAgain(uint8 indexed _who);
501 
502     event EventEntityProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);
503     event EventRecordProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);
504 
505     event DebugAction(bytes32 indexed _name, bool indexed _allowed);
506 
507 
508     event EventFundingReceivedPayment(address indexed _sender, uint8 indexed _payment_method, uint256 indexed _amount );
509 
510     function runBeforeInitialization() internal requireNotInitialised {
511 
512         // instantiate token manager, moved from runBeforeApplyingSettings
513         TokenManagerEntity = ABITokenManager( getApplicationAssetAddressByName('TokenManager') );
514         FundingManagerEntity = ABIFundingManager( getApplicationAssetAddressByName('FundingManager') );
515 
516         EventRunBeforeInit(assetName);
517     }
518 
519     function setAssetStates() internal {
520         // Asset States
521         EntityStates["__IGNORED__"]     = 0;
522         EntityStates["NEW"]             = 1;
523         EntityStates["WAITING"]         = 2;
524         EntityStates["IN_PROGRESS"]     = 3;
525         EntityStates["COOLDOWN"]        = 4;
526         EntityStates["FUNDING_ENDED"]   = 5;
527         EntityStates["FAILED"]          = 6;
528         EntityStates["FAILED_FINAL"]    = 7;
529         EntityStates["SUCCESSFUL"]      = 8;
530         EntityStates["SUCCESSFUL_FINAL"]= 9;
531 
532         // Funding Stage States
533         RecordStates["__IGNORED__"]     = 0;
534         RecordStates["NEW"]             = 1;
535         RecordStates["IN_PROGRESS"]     = 2;
536         RecordStates["FINAL"]           = 3;
537     }
538 
539     function addSettings(address _outputAddress, uint256 soft_cap, uint256 hard_cap, uint8 sale_percentage, address _direct, address _milestone )
540         public
541         requireInitialised
542         requireSettingsNotApplied
543     {
544         if(soft_cap > hard_cap) {
545             revert();
546         }
547 
548         multiSigOutputAddress = _outputAddress;
549         GlobalAmountCapSoft = soft_cap;
550         GlobalAmountCapHard = hard_cap;
551 
552         if(sale_percentage > 90) {
553             revert();
554         }
555 
556         TokenSellPercentage = sale_percentage;
557 
558         DirectInput = ABIFundingInputGeneral(_direct);
559         MilestoneInput = ABIFundingInputGeneral(_milestone);
560     }
561 
562     function addFundingStage(
563         bytes32 _name,
564         uint256 _time_start,
565         uint256 _time_end,
566         uint256 _amount_cap_soft,
567         uint256 _amount_cap_hard,   // required > 0
568         uint8   _methods,
569         uint256 _minimum_entry,
570         uint256 _fixed_tokens,
571         uint8   _price_addition_percentage,
572         uint8   _token_share_percentage
573     )
574         public
575         onlyDeployer
576         requireInitialised
577         requireSettingsNotApplied
578     {
579 
580         // make sure end time is later than start time
581         if(_time_end <= _time_start) {
582             revert();
583         }
584 
585         // make sure hard cap exists!
586         if(_amount_cap_hard == 0) {
587             revert();
588         }
589 
590         // make sure soft cap is not higher than hard cap
591         if(_amount_cap_soft > _amount_cap_hard) {
592             revert();
593         }
594 
595         if(_token_share_percentage > 0) {
596             revert();
597         }
598 
599         FundingStage storage prevRecord = Collection[FundingStageNum];
600         if(FundingStageNum > 0) {
601 
602             // new stage does not start before the previous one ends
603             if( _time_start <= prevRecord.time_end ) {
604                 revert();
605             }
606         }
607 
608         FundingStage storage record = Collection[++FundingStageNum];
609         record.name             = _name;
610         record.time_start       = _time_start;
611         record.time_end         = _time_end;
612         record.amount_cap_soft  = _amount_cap_soft;
613         record.amount_cap_hard  = _amount_cap_hard;
614 
615         // funding method settings
616         record.methods          = _methods;
617         record.minimum_entry    = _minimum_entry;
618 
619         // token settings
620         record.fixed_tokens              = _fixed_tokens;
621         record.price_addition_percentage = _price_addition_percentage;
622         record.token_share_percentage    = _token_share_percentage;
623 
624         // state new
625         record.state = getRecordState("NEW");
626         record.index = FundingStageNum;
627 
628         FundingStageCreated( FundingStageNum, _name );
629 
630         adjustFundingSettingsBasedOnNewFundingStage();
631     }
632 
633     function adjustFundingSettingsBasedOnNewFundingStage() internal {
634 
635         // set funding start
636         Funding_Setting_funding_time_start = Collection[1].time_start;
637         // set funding end
638         Funding_Setting_funding_time_end = Collection[FundingStageNum].time_end;
639 
640         // cashback starts 1 day after funding status is failed
641         Funding_Setting_cashback_time_start = Funding_Setting_funding_time_end + Funding_Setting_cashback_before_start_wait_duration;
642         Funding_Setting_cashback_time_end = Funding_Setting_cashback_time_start + Funding_Setting_cashback_duration;
643     }
644 
645     function getStageAmount(uint8 StageId) public view returns ( uint256 ) {
646         return Collection[StageId].fixed_tokens;
647     }
648 
649     function allowedPaymentMethod(uint8 _payment_method) public pure returns (bool) {
650         if(
651         _payment_method == uint8(FundingMethodIds.DIRECT_ONLY) ||
652         _payment_method == uint8(FundingMethodIds.MILESTONE_ONLY)
653         ){
654             return true;
655         } else {
656             return false;
657         }
658     }
659 
660     function receivePayment(address _sender, uint8 _payment_method)
661         payable
662         public
663         requireInitialised
664         onlyInputPaymentMethod
665         returns(bool)
666     {
667         // check that msg.value is higher than 0, don't really want to have to deal with minus in case the network breaks this somehow
668         if(allowedPaymentMethod(_payment_method) && canAcceptPayment(msg.value) ) {
669 
670             uint256 contributed_value = msg.value;
671 
672             uint256 amountOverCap = getValueOverCurrentCap(contributed_value);
673             if ( amountOverCap > 0 ) {
674                 // calculate how much we can accept
675 
676                 // update contributed value
677                 contributed_value -= amountOverCap;
678             }
679 
680             Collection[currentFundingStage].amount_raised+= contributed_value;
681             AmountRaised+= contributed_value;
682 
683             if(_payment_method == uint8(FundingMethodIds.MILESTONE_ONLY)) {
684                 MilestoneAmountRaised+=contributed_value;
685             }
686 
687             EventFundingReceivedPayment(_sender, _payment_method, contributed_value);
688 
689             if( FundingManagerEntity.receivePayment.value(contributed_value)( _sender, _payment_method, currentFundingStage ) ) {
690 
691                 if(amountOverCap > 0) {
692                     // last step, if we received more than we can accept, send remaining back
693                     // amountOverCap sent back
694                     if( _sender.send(this.balance) ) {
695                         return true;
696                     }
697                     else {
698                         revert();
699                     }
700                 } else {
701                     return true;
702                 }
703             } else {
704                 revert();
705             }
706 
707         } else {
708             revert();
709         }
710     }
711 
712     modifier onlyInputPaymentMethod() {
713         require(msg.sender != 0x0 && ( msg.sender == address(DirectInput) || msg.sender == address(MilestoneInput) ));
714         _;
715     }
716 
717     function canAcceptPayment(uint256 _amount) public view returns (bool) {
718         if( _amount > 0 ) {
719             // funding state should be IN_PROGRESS, no state changes should be required
720             if( CurrentEntityState == getEntityState("IN_PROGRESS") && hasRequiredStateChanges() == false) {
721                 return true;
722             }
723         }
724         return false;
725     }
726 
727     function getValueOverCurrentCap(uint256 _amount) public view returns (uint256) {
728         FundingStage memory record = Collection[currentFundingStage];
729         uint256 remaining = record.amount_cap_hard - AmountRaised;
730         if( _amount > remaining ) {
731             return _amount - remaining;
732         }
733         return 0;
734     }
735 
736 
737     /*
738     * Update Existing FundingStage
739     *
740     * @param        uint8 _record_id
741     * @param        uint8 _new_state
742     * @param        uint8 _duration
743     *
744     * @access       public
745     * @type         method
746     * @modifiers    onlyOwner, requireInitialised, updateAllowed
747     *
748     * @return       void
749     */
750 
751     function updateFundingStage( uint8 _new_state )
752         internal
753         requireInitialised
754         FundingStageUpdateAllowed(_new_state)
755         returns (bool)
756     {
757         FundingStage storage rec = Collection[currentFundingStage];
758         rec.state       = _new_state;
759         return true;
760     }
761 
762 
763     /*
764     * Modifier: Validate if record updates are allowed
765     *
766     * @type         modifier
767     *
768     * @param        uint8 _record_id
769     * @param        uint8 _new_state
770     * @param        uint256 _duration
771     *
772     * @return       bool
773     */
774 
775     modifier FundingStageUpdateAllowed(uint8 _new_state) {
776         require( isFundingStageUpdateAllowed( _new_state )  );
777         _;
778     }
779 
780     /*
781      * Method: Validate if record can be updated to requested state
782      *
783      * @access       public
784      * @type         method
785      *
786      * @param        uint8 _record_id
787      * @param        uint8 _new_state
788      *
789      * @return       bool
790      */
791     function isFundingStageUpdateAllowed(uint8 _new_state ) public view returns (bool) {
792 
793         var (CurrentRecordState, RecordStateRequired, EntityStateRequired) = getRequiredStateChanges();
794 
795         CurrentRecordState = 0;
796         EntityStateRequired = 0;
797 
798         if(_new_state == uint8(RecordStateRequired)) {
799             return true;
800         }
801         return false;
802     }
803 
804     /*
805      * Funding Phase changes
806      *
807      * Method: Get FundingStage Required State Changes
808      *
809      * @access       public
810      * @type         method
811      * @modifiers    onlyOwner
812      *
813      * @return       uint8 RecordStateRequired
814      */
815     function getRecordStateRequiredChanges() public view returns (uint8) {
816 
817         FundingStage memory record = Collection[currentFundingStage];
818         uint8 RecordStateRequired = getRecordState("__IGNORED__");
819 
820         if(record.state == getRecordState("FINAL")) {
821             return getRecordState("__IGNORED__");
822         }
823 
824         /*
825             If funding stage is not started and timestamp is after start time:
826             - we need to change state to IN_PROGRESS so we can start receiving funds
827         */
828         if( getTimestamp() >= record.time_start ) {
829             RecordStateRequired = getRecordState("IN_PROGRESS");
830         }
831 
832         /*
833             This is where we're accepting payments unless we can change state to FINAL
834 
835             1. Check if timestamp is after record time_end
836             2. Check hard caps
837             All lead to state change => FINAL
838         */
839 
840         // Time check
841         if(getTimestamp() >= record.time_end) {
842             // Funding Phase ended passed
843             return getRecordState("FINAL");
844         }
845 
846         // will trigger in pre-ico
847         // Record Hard Cap Check
848         if(AmountRaised >= record.amount_cap_hard) {
849             // record hard cap reached
850             return getRecordState("FINAL");
851         }
852 
853         // will trigger in ico
854         // Global Hard Cap Check
855         if(AmountRaised >= GlobalAmountCapHard) {
856             // hard cap reached
857             return getRecordState("FINAL");
858         }
859 
860         if( record.state == RecordStateRequired ) {
861             RecordStateRequired = getRecordState("__IGNORED__");
862         }
863 
864         return RecordStateRequired;
865     }
866 
867     function doStateChanges() public {
868         var (CurrentRecordState, RecordStateRequired, EntityStateRequired) = getRequiredStateChanges();
869         bool callAgain = false;
870 
871         DebugRecordRequiredChanges( assetName, CurrentRecordState, RecordStateRequired );
872         DebugEntityRequiredChanges( assetName, CurrentEntityState, EntityStateRequired );
873 
874         if( RecordStateRequired != getRecordState("__IGNORED__") ) {
875             // process record changes.
876             RecordProcessor(CurrentRecordState, RecordStateRequired);
877             DebugCallAgain(2);
878             callAgain = true;
879         }
880 
881         if(EntityStateRequired != getEntityState("__IGNORED__") ) {
882             // process entity changes.
883             // if(CurrentEntityState != EntityStateRequired) {
884             EntityProcessor(EntityStateRequired);
885             DebugCallAgain(1);
886             callAgain = true;
887             //}
888         }
889     }
890 
891     function hasRequiredStateChanges() public view returns (bool) {
892         bool hasChanges = false;
893 
894         var (CurrentRecordState, RecordStateRequired, EntityStateRequired) = getRequiredStateChanges();
895         CurrentRecordState = 0;
896 
897         if( RecordStateRequired != getRecordState("__IGNORED__") ) {
898             hasChanges = true;
899         }
900         if(EntityStateRequired != getEntityState("__IGNORED__") ) {
901             hasChanges = true;
902         }
903         return hasChanges;
904     }
905 
906     // view methods decide if changes are to be made
907     // in case of tasks, we do them in the Processors.
908 
909     function RecordProcessor(uint8 CurrentRecordState, uint8 RecordStateRequired) internal {
910         EventRecordProcessor( assetName, CurrentRecordState, RecordStateRequired );
911         updateFundingStage( RecordStateRequired );
912         if( RecordStateRequired == getRecordState("FINAL") ) {
913             if(currentFundingStage < FundingStageNum) {
914                 // jump to next stage
915                 currentFundingStage++;
916             }
917         }
918     }
919 
920     function EntityProcessor(uint8 EntityStateRequired) internal {
921         EventEntityProcessor( assetName, CurrentEntityState, EntityStateRequired );
922 
923         // Do State Specific Updates
924         // Update our Entity State
925         CurrentEntityState = EntityStateRequired;
926 
927         if ( EntityStateRequired == getEntityState("FUNDING_ENDED") ) {
928             /*
929                 STATE: FUNDING_ENDED
930                 @Processor hook
931                 Action: Check if funding is successful or not, and move state to "FAILED" or "SUCCESSFUL"
932             */
933 
934             // Global Hard Cap Check
935             if(AmountRaised >= GlobalAmountCapSoft) {
936                 // hard cap reached
937                 CurrentEntityState = getEntityState("SUCCESSFUL");
938             } else {
939                 CurrentEntityState = getEntityState("FAILED");
940             }
941         }
942 
943 
944     }
945 
946     /*
947      * Method: Get Record and Entity State Changes
948      *
949      * @access       public
950      * @type         method
951      * @modifiers    onlyOwner
952      *
953      * @return       ( uint8 CurrentRecordState, uint8 RecordStateRequired, uint8 EntityStateRequired)
954      */
955     function getRequiredStateChanges() public view returns (uint8, uint8, uint8) {
956 
957         // get FundingStage current state
958         FundingStage memory record = Collection[currentFundingStage];
959 
960         uint8 CurrentRecordState = record.state;
961         uint8 RecordStateRequired = getRecordStateRequiredChanges();
962         uint8 EntityStateRequired = getEntityState("__IGNORED__");
963 
964 
965         // Funding Record State Overrides
966         // if(CurrentRecordState != RecordStateRequired) {
967         if(RecordStateRequired != getRecordState("__IGNORED__"))
968         {
969             // direct state overrides by funding stage
970             if(RecordStateRequired == getRecordState("IN_PROGRESS") ) {
971                 // both funding stage and entity states need to move to IN_PROGRESS
972                 EntityStateRequired = getEntityState("IN_PROGRESS");
973 
974             } else if (RecordStateRequired == getRecordState("FINAL")) {
975                 // funding stage moves to FINAL
976 
977                 if (currentFundingStage == FundingStageNum) {
978                     // if current funding is last
979                     EntityStateRequired = getEntityState("FUNDING_ENDED");
980                 }
981                 else {
982                     // start cooldown between funding stages
983                     EntityStateRequired = getEntityState("COOLDOWN");
984                 }
985             }
986 
987         } else {
988 
989             // Records do not require any updates.
990             // Do Entity Checks
991 
992             if( CurrentEntityState == getEntityState("NEW") ) {
993                 /*
994                     STATE: NEW
995                     Processor Action: Allocate Tokens to Funding / Owners then Update to WAITING
996                 */
997                 EntityStateRequired = getEntityState("WAITING");
998             } else  if ( CurrentEntityState == getEntityState("FUNDING_ENDED") ) {
999                 /*
1000                     STATE: FUNDING_ENDED
1001                     Processor Action: Check if funding is successful or not, and move state to "SUCCESSFUL" or "FAILED"
1002                 */
1003             } else if ( CurrentEntityState == getEntityState("SUCCESSFUL") ) {
1004                 /*
1005                     STATE: SUCCESSFUL
1006                     Processor Action: none
1007 
1008                     External Action:
1009                     FundingManager - Run Internal Processor ( deliver tokens, deliver direct funding eth )
1010                 */
1011 
1012                 // check funding manager has processed the FUNDING_SUCCESSFUL Task, if true => FUNDING_SUCCESSFUL_DONE
1013                 if(FundingManagerEntity.taskByHash( FundingManagerEntity.getHash("FUNDING_SUCCESSFUL_START", "") ) == true) {
1014                     EntityStateRequired = getEntityState("SUCCESSFUL_FINAL");
1015                 }
1016                 /*
1017                 if( FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState("FUNDING_SUCCESSFUL_DONE") ) {
1018                     EntityStateRequired = getEntityState("SUCCESSFUL_FINAL");
1019                 }
1020                 */
1021 
1022             } else if ( CurrentEntityState == getEntityState("FAILED") ) {
1023                 /*
1024                     STATE: FAILED
1025                     Processor Action: none
1026 
1027                     External Action:
1028                     FundingManager - Run Internal Processor (release tokens to owner) ( Cashback is available )
1029                 */
1030 
1031                 // check funding manager state, if FUNDING_NOT_PROCESSED -> getEntityState("__IGNORED__")
1032                 // if FUNDING_FAILED_DONE
1033 
1034                 if(FundingManagerEntity.taskByHash( FundingManagerEntity.getHash("FUNDING_FAILED_START", "") ) == true) {
1035                     EntityStateRequired = getEntityState("FAILED_FINAL");
1036                 }
1037             } else if ( CurrentEntityState == getEntityState("SUCCESSFUL_FINAL") ) {
1038                 /*
1039                     STATE: SUCCESSFUL_FINAL
1040                     Processor Action: none
1041 
1042                     External Action:
1043                     Application: Run Internal Processor ( Change State to IN_DEVELOPMENT )
1044                 */
1045             } else if ( CurrentEntityState == getEntityState("FAILED_FINAL") ) {
1046                 /*
1047                     STATE: FINAL_FAILED
1048                     Processor Action: none
1049 
1050                     External Action:
1051                     Application: Run Internal Processor ( Change State to FUNDING_FAILED )
1052                 */
1053             }
1054         }
1055 
1056         return (CurrentRecordState, RecordStateRequired, EntityStateRequired);
1057     }
1058 
1059 }