1 pragma solidity 0.4.17;
2 
3 /*
4 
5  * source       https://github.com/blockbitsio/
6 
7  * @name        Application Asset Contract ABI
8  * @package     BlockBitsIO
9  * @author      Micky Socaci <micky@nowlive.ro>
10 
11  Any contract inheriting this will be usable as an Asset in the Application Entity
12 
13 */
14 
15 
16 
17 contract ABIApplicationAsset {
18 
19     bytes32 public assetName;
20     uint8 public CurrentEntityState;
21     uint8 public RecordNum;
22     bool public _initialized;
23     bool public _settingsApplied;
24     address public owner;
25     address public deployerAddress;
26     mapping (bytes32 => uint8) public EntityStates;
27     mapping (bytes32 => uint8) public RecordStates;
28 
29     function setInitialApplicationAddress(address _ownerAddress) public;
30     function setInitialOwnerAndName(bytes32 _name) external returns (bool);
31     function getRecordState(bytes32 name) public view returns (uint8);
32     function getEntityState(bytes32 name) public view returns (uint8);
33     function applyAndLockSettings() public returns(bool);
34     function transferToNewOwner(address _newOwner) public returns (bool);
35     function getApplicationAssetAddressByName(bytes32 _name) public returns(address);
36     function getApplicationState() public view returns (uint8);
37     function getApplicationEntityState(bytes32 name) public view returns (uint8);
38     function getAppBylawUint256(bytes32 name) public view returns (uint256);
39     function getAppBylawBytes32(bytes32 name) public view returns (bytes32);
40     function getTimestamp() view public returns (uint256);
41 
42 
43 }
44 
45 /*
46 
47  * source       https://github.com/blockbitsio/
48 
49  * @name        Funding Contract ABI
50  * @package     BlockBitsIO
51  * @author      Micky Socaci <micky@nowlive.ro>
52 
53  Contains the Funding Contract code deployed and linked to the Application Entity
54 
55 
56     !!! Links directly to Milestones
57 
58 */
59 
60 
61 
62 
63 
64 contract ABIFunding is ABIApplicationAsset {
65 
66     address public multiSigOutputAddress;
67     address public DirectInput;
68     address public MilestoneInput;
69     address public TokenManagerEntity;
70     address public FundingManagerEntity;
71 
72     struct FundingStage {
73         bytes32 name;
74         uint8   state;
75         uint256 time_start;
76         uint256 time_end;
77         uint256 amount_cap_soft;            // 0 = not enforced
78         uint256 amount_cap_hard;            // 0 = not enforced
79         uint256 amount_raised;              // 0 = not enforced
80         // funding method settings
81         uint256 minimum_entry;
82         uint8   methods;                    // FundingMethodIds
83         // token settings
84         uint256 fixed_tokens;
85         uint8   price_addition_percentage;  //
86         uint8   token_share_percentage;
87         uint8   index;
88     }
89 
90     mapping (uint8 => FundingStage) public Collection;
91     uint8 public FundingStageNum;
92     uint8 public currentFundingStage;
93     uint256 public AmountRaised;
94     uint256 public MilestoneAmountRaised;
95     uint256 public GlobalAmountCapSoft;
96     uint256 public GlobalAmountCapHard;
97     uint8 public TokenSellPercentage;
98     uint256 public Funding_Setting_funding_time_start;
99     uint256 public Funding_Setting_funding_time_end;
100     uint256 public Funding_Setting_cashback_time_start;
101     uint256 public Funding_Setting_cashback_time_end;
102     uint256 public Funding_Setting_cashback_before_start_wait_duration;
103     uint256 public Funding_Setting_cashback_duration;
104 
105 
106     function addFundingStage(
107         bytes32 _name,
108         uint256 _time_start,
109         uint256 _time_end,
110         uint256 _amount_cap_soft,
111         uint256 _amount_cap_hard,   // required > 0
112         uint8   _methods,
113         uint256 _minimum_entry,
114         uint256 _fixed_tokens,
115         uint8   _price_addition_percentage,
116         uint8   _token_share_percentage
117     )
118     public;
119 
120     function addSettings(address _outputAddress, uint256 soft_cap, uint256 hard_cap, uint8 sale_percentage, address _direct, address _milestone ) public;
121     function getStageAmount(uint8 StageId) public view returns ( uint256 );
122     function allowedPaymentMethod(uint8 _payment_method) public pure returns (bool);
123     function receivePayment(address _sender, uint8 _payment_method) payable public returns(bool);
124     function canAcceptPayment(uint256 _amount) public view returns (bool);
125     function getValueOverCurrentCap(uint256 _amount) public view returns (uint256);
126     function isFundingStageUpdateAllowed(uint8 _new_state ) public view returns (bool);
127     function getRecordStateRequiredChanges() public view returns (uint8);
128     function doStateChanges() public;
129     function hasRequiredStateChanges() public view returns (bool);
130     function getRequiredStateChanges() public view returns (uint8, uint8, uint8);
131 
132 }
133 
134 /*
135 
136  * source       https://github.com/blockbitsio/
137 
138  * @name        Funding Vault ABI
139  * @package     BlockBitsIO
140  * @author      Micky Socaci <micky@nowlive.ro>
141 
142  each purchase creates a separate funding vault contract
143 
144 */
145 
146 
147 contract ABIFundingVault {
148 
149     bool public _initialized;
150     address public vaultOwner;
151     address public outputAddress;
152     address public managerAddress;
153     bool public allFundingProcessed;
154     bool public DirectFundingProcessed;
155     uint256 public amount_direct;
156     uint256 public amount_milestone;
157     bool public emergencyFundReleased;
158 
159     struct PurchaseStruct {
160         uint256 unix_time;
161         uint8 payment_method;
162         uint256 amount;
163         uint8 funding_stage;
164         uint16 index;
165     }
166 
167     bool public BalancesInitialised;
168     uint8 public BalanceNum;
169     uint16 public purchaseRecordsNum;
170     mapping(uint16 => PurchaseStruct) public purchaseRecords;
171     mapping (uint8 => uint256) public stageAmounts;
172     mapping (uint8 => uint256) public stageAmountsDirect;
173     mapping (uint8 => uint256) public etherBalances;
174     mapping (uint8 => uint256) public tokenBalances;
175 
176     function initialize( address _owner, address _output, address _fundingAddress, address _milestoneAddress, address _proposalsAddress ) public returns(bool);
177     function addPayment(uint8 _payment_method, uint8 _funding_stage ) public payable returns (bool);
178     function getBoughtTokens() public view returns (uint256);
179     function getDirectBoughtTokens() public view returns (uint256);
180     function ReleaseFundsAndTokens() public returns (bool);
181     function releaseTokensAndEtherForEmergencyFund() public returns (bool);
182     function ReleaseFundsToInvestor() public;
183     function canCashBack() public view returns (bool);
184     function checkFundingStateFailed() public view returns (bool);
185     function checkMilestoneStateInvestorVotedNoVotingEndedNo() public view returns (bool);
186     function checkOwnerFailedToSetTimeOnMeeting() public view returns (bool);
187 }
188 
189 /*
190 
191  * source       https://github.com/blockbitsio/
192  * @name        Token Stake Calculation And Distribution Algorithm - Type 3 - Sell a variable amount of tokens for a fixed price
193  * @package     BlockBitsIO
194  * @author      Micky Socaci <micky@nowlive.ro>
195 
196 
197     Inputs:
198 
199     Defined number of tokens per wei ( X Tokens = 1 wei )
200     Received amount of ETH
201     Generates:
202 
203     Total Supply of tokens available in Funding Phase respectively Project
204     Observations:
205 
206     Will sell the whole supply of Tokens available to Current Funding Phase
207     Use cases:
208 
209     Any Funding Phase where you want the first Funding Phase to determine the token supply of the whole Project
210 
211 */
212 
213 
214 
215 
216 
217 
218 
219 contract TokenSCADAVariable {
220 
221     ABIFunding FundingEntity;
222 
223     bool public SCADA_requires_hard_cap = true;
224     bool public initialized = false;
225     address public deployerAddress;
226 
227     function TokenSCADAVariable() public {
228         deployerAddress = msg.sender;
229     }
230 
231     function addSettings(address _fundingContract) onlyDeployer public {
232         require(initialized == false);
233         FundingEntity = ABIFunding(_fundingContract);
234         initialized = true;
235     }
236 
237     function requiresHardCap() public view returns (bool) {
238         return SCADA_requires_hard_cap;
239     }
240 
241     function getTokensForValueInCurrentStage(uint256 _value) public view returns (uint256) {
242         return getTokensForValueInStage(FundingEntity.currentFundingStage(), _value);
243     }
244 
245     function getTokensForValueInStage(uint8 _stage, uint256 _value) public view returns (uint256) {
246         uint256 amount = FundingEntity.getStageAmount(_stage);
247         return _value * amount;
248     }
249 
250     function getBoughtTokens( address _vaultAddress, bool _direct ) public view returns (uint256) {
251         ABIFundingVault vault = ABIFundingVault(_vaultAddress);
252 
253         if(_direct) {
254             uint256 DirectTokens = getTokensForValueInStage(1, vault.stageAmountsDirect(1));
255             DirectTokens+= getTokensForValueInStage(2, vault.stageAmountsDirect(2));
256             return DirectTokens;
257         } else {
258             uint256 TotalTokens = getTokensForValueInStage(1, vault.stageAmounts(1));
259             TotalTokens+= getTokensForValueInStage(2, vault.stageAmounts(2));
260             return TotalTokens;
261         }
262     }
263 
264     modifier onlyDeployer() {
265         require(msg.sender == deployerAddress);
266         _;
267     }
268 }