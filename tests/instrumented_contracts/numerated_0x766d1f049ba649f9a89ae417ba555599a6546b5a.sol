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
321 
322     !!! Links directly to Milestones
323 
324 */
325 
326 
327 
328 
329 
330 contract ABIFunding is ABIApplicationAsset {
331 
332     address public multiSigOutputAddress;
333     address public DirectInput;
334     address public MilestoneInput;
335     address public TokenManagerEntity;
336     address public FundingManagerEntity;
337 
338     struct FundingStage {
339         bytes32 name;
340         uint8   state;
341         uint256 time_start;
342         uint256 time_end;
343         uint256 amount_cap_soft;            // 0 = not enforced
344         uint256 amount_cap_hard;            // 0 = not enforced
345         uint256 amount_raised;              // 0 = not enforced
346         // funding method settings
347         uint256 minimum_entry;
348         uint8   methods;                    // FundingMethodIds
349         // token settings
350         uint256 fixed_tokens;
351         uint8   price_addition_percentage;  //
352         uint8   token_share_percentage;
353         uint8   index;
354     }
355 
356     mapping (uint8 => FundingStage) public Collection;
357     uint8 public FundingStageNum;
358     uint8 public currentFundingStage;
359     uint256 public AmountRaised;
360     uint256 public MilestoneAmountRaised;
361     uint256 public GlobalAmountCapSoft;
362     uint256 public GlobalAmountCapHard;
363     uint8 public TokenSellPercentage;
364     uint256 public Funding_Setting_funding_time_start;
365     uint256 public Funding_Setting_funding_time_end;
366     uint256 public Funding_Setting_cashback_time_start;
367     uint256 public Funding_Setting_cashback_time_end;
368     uint256 public Funding_Setting_cashback_before_start_wait_duration;
369     uint256 public Funding_Setting_cashback_duration;
370 
371 
372     function addFundingStage(
373         bytes32 _name,
374         uint256 _time_start,
375         uint256 _time_end,
376         uint256 _amount_cap_soft,
377         uint256 _amount_cap_hard,   // required > 0
378         uint8   _methods,
379         uint256 _minimum_entry,
380         uint256 _fixed_tokens,
381         uint8   _price_addition_percentage,
382         uint8   _token_share_percentage
383     )
384     public;
385 
386     function addSettings(address _outputAddress, uint256 soft_cap, uint256 hard_cap, uint8 sale_percentage, address _direct, address _milestone ) public;
387     function getStageAmount(uint8 StageId) public view returns ( uint256 );
388     function allowedPaymentMethod(uint8 _payment_method) public pure returns (bool);
389     function receivePayment(address _sender, uint8 _payment_method) payable public returns(bool);
390     function canAcceptPayment(uint256 _amount) public view returns (bool);
391     function getValueOverCurrentCap(uint256 _amount) public view returns (uint256);
392     function isFundingStageUpdateAllowed(uint8 _new_state ) public view returns (bool);
393     function getRecordStateRequiredChanges() public view returns (uint8);
394     function doStateChanges() public;
395     function hasRequiredStateChanges() public view returns (bool);
396     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
397 
398 }
399 
400 /*
401 
402  * source       https://github.com/blockbitsio/
403 
404  * @name        Token Contract
405  * @package     BlockBitsIO
406  * @author      Micky Socaci <micky@nowlive.ro>
407 
408  Zeppelin ERC20 Standard Token
409 
410 */
411 
412 
413 
414 contract ABIToken {
415 
416     string public  symbol;
417     string public  name;
418     uint8 public   decimals;
419     uint256 public totalSupply;
420     string public  version;
421     mapping (address => uint256) public balances;
422     mapping (address => mapping (address => uint256)) allowed;
423     address public manager;
424     address public deployer;
425     bool public mintingFinished = false;
426     bool public initialized = false;
427 
428     function transfer(address _to, uint256 _value) public returns (bool);
429     function balanceOf(address _owner) public view returns (uint256 balance);
430     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
431     function approve(address _spender, uint256 _value) public returns (bool);
432     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
433     function increaseApproval(address _spender, uint _addedValue) public returns (bool success);
434     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);
435     function mint(address _to, uint256 _amount) public returns (bool);
436     function finishMinting() public returns (bool);
437 
438     event Transfer(address indexed from, address indexed to, uint256 indexed value);
439     event Approval(address indexed owner, address indexed spender, uint256 indexed value);
440     event Mint(address indexed to, uint256 amount);
441     event MintFinished();
442 }
443 
444 /*
445 
446  * source       https://github.com/blockbitsio/
447 
448  * @name        Token Manager Contract
449  * @package     BlockBitsIO
450  * @author      Micky Socaci <micky@nowlive.ro>
451 
452 */
453 
454 
455 
456 
457 
458 contract ABITokenManager is ABIApplicationAsset {
459 
460     address public TokenSCADAEntity;
461     address public TokenEntity;
462     address public MarketingMethodAddress;
463     bool OwnerTokenBalancesReleased = false;
464 
465     function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) public;
466     function getTokenSCADARequiresHardCap() public view returns (bool);
467     function mint(address _to, uint256 _amount) public returns (bool);
468     function finishMinting() public returns (bool);
469     function mintForMarketingPool(address _to, uint256 _amount) external returns (bool);
470     function ReleaseOwnersLockedTokens(address _multiSigOutputAddress) public returns (bool);
471 
472 }
473 
474 /*
475 
476  * source       https://github.com/blockbitsio/
477 
478  * @name        Bounty Program Contract
479  * @package     BlockBitsIO
480  * @author      Micky Socaci <micky@nowlive.ro>
481 
482     Bounty program contract that holds and distributes tokens upon successful funding.
483 */
484 
485 
486 
487 
488 
489 
490 
491 
492 
493 contract BountyManager is ApplicationAsset {
494 
495     ABIFunding FundingEntity;
496     ABIToken TokenEntity;
497 
498     function runBeforeApplyingSettings()
499         internal
500         requireInitialised
501         requireSettingsNotApplied
502     {
503         address FundingAddress = getApplicationAssetAddressByName('Funding');
504         FundingEntity = ABIFunding(FundingAddress);
505 
506         address TokenManagerAddress = getApplicationAssetAddressByName('TokenManager');
507         ABITokenManager TokenManagerEntity = ABITokenManager(TokenManagerAddress);
508         TokenEntity = ABIToken(TokenManagerEntity.TokenEntity());
509 
510         EventRunBeforeApplyingSettings(assetName);
511     }
512 
513     function sendBounty( address _receiver, uint256 _amount )
514         public
515         requireInitialised
516         requireSettingsApplied
517         onlyDeployer
518     {
519         if( FundingEntity.CurrentEntityState() == FundingEntity.getEntityState("SUCCESSFUL_FINAL") ) {
520             TokenEntity.transfer( _receiver, _amount );
521         } else {
522             revert();
523         }
524     }
525 }