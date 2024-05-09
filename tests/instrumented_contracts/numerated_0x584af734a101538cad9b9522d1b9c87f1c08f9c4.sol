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
317  * @name        Token Stake Calculation And Distribution Algorithm - Type 3 - Sell a variable amount of tokens for a fixed price
318  * @package     BlockBitsIO
319  * @author      Micky Socaci <micky@nowlive.ro>
320 
321 
322     Inputs:
323 
324     Defined number of tokens per wei ( X Tokens = 1 wei )
325     Received amount of ETH
326     Generates:
327 
328     Total Supply of tokens available in Funding Phase respectively Project
329     Observations:
330 
331     Will sell the whole supply of Tokens available to Current Funding Phase
332     Use cases:
333 
334     Any Funding Phase where you want the first Funding Phase to determine the token supply of the whole Project
335 
336 */
337 
338 
339 
340 
341 contract ABITokenSCADAVariable {
342     bool public SCADA_requires_hard_cap = true;
343     bool public initialized;
344     address public deployerAddress;
345     function addSettings(address _fundingContract) public;
346     function requiresHardCap() public view returns (bool);
347     function getTokensForValueInCurrentStage(uint256 _value) public view returns (uint256);
348     function getTokensForValueInStage(uint8 _stage, uint256 _value) public view returns (uint256);
349     function getBoughtTokens( address _vaultAddress, bool _direct ) public view returns (uint256);
350 }
351 
352 /*
353 
354  * source       https://github.com/blockbitsio/
355 
356  * @name        Token Manager Contract
357  * @package     BlockBitsIO
358  * @author      Micky Socaci <micky@nowlive.ro>
359 
360 */
361 
362 
363 
364 
365 
366 
367 
368 contract TokenManager is ApplicationAsset {
369 
370     ABITokenSCADAVariable public TokenSCADAEntity;
371     ABIToken public TokenEntity;
372     address public MarketingMethodAddress;
373 
374     function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) onlyDeployer public {
375         TokenSCADAEntity = ABITokenSCADAVariable(_scadaAddress);
376         TokenEntity = ABIToken(_tokenAddress);
377         MarketingMethodAddress = _marketing;
378     }
379 
380     function getTokenSCADARequiresHardCap() public view returns (bool) {
381         return TokenSCADAEntity.requiresHardCap();
382     }
383 
384     function mint(address _to, uint256 _amount)
385         onlyAsset('FundingManager')
386         public
387         returns (bool)
388     {
389         return TokenEntity.mint(_to, _amount);
390     }
391 
392     function finishMinting()
393         onlyAsset('FundingManager')
394         public
395         returns (bool)
396     {
397         return TokenEntity.finishMinting();
398     }
399 
400     function mintForMarketingPool(address _to, uint256 _amount)
401         onlyMarketingPoolAsset
402         requireSettingsApplied
403         external
404         returns (bool)
405     {
406         return TokenEntity.mint(_to, _amount);
407     }
408 
409     modifier onlyMarketingPoolAsset() {
410         require(msg.sender == MarketingMethodAddress);
411         _;
412     }
413 
414     // Development stage complete, release tokens to Project Owners
415     event EventOwnerTokenBalancesReleased(address _addr, uint256 _value);
416     bool OwnerTokenBalancesReleased = false;
417 
418     function ReleaseOwnersLockedTokens(address _multiSigOutputAddress)
419         public
420         onlyAsset('FundingManager')
421         returns (bool)
422     {
423         require(OwnerTokenBalancesReleased == false);
424         uint256 lockedBalance = TokenEntity.balanceOf(address(this));
425         TokenEntity.transfer( _multiSigOutputAddress, lockedBalance );
426         EventOwnerTokenBalancesReleased(_multiSigOutputAddress, lockedBalance);
427         OwnerTokenBalancesReleased = true;
428         return true;
429     }
430 
431 }