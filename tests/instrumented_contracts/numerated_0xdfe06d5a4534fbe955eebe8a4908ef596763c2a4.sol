1 pragma solidity ^0.4.17;
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
49  * @name        Token Manager Contract
50  * @package     BlockBitsIO
51  * @author      Micky Socaci <micky@nowlive.ro>
52 
53 */
54 
55 
56 
57 
58 
59 contract ABITokenManager is ABIApplicationAsset {
60 
61     address public TokenSCADAEntity;
62     address public TokenEntity;
63     address public MarketingMethodAddress;
64     bool OwnerTokenBalancesReleased = false;
65 
66     function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) public;
67     function getTokenSCADARequiresHardCap() public view returns (bool);
68     function mint(address _to, uint256 _amount) public returns (bool);
69     function finishMinting() public returns (bool);
70     function mintForMarketingPool(address _to, uint256 _amount) external returns (bool);
71     function ReleaseOwnersLockedTokens(address _multiSigOutputAddress) public returns (bool);
72 
73 }
74 
75 /*
76 
77  * source       https://github.com/blockbitsio/
78 
79  * @name        Marketing Funding Input Contract
80  * @package     BlockBitsIO
81  * @author      Micky Socaci <micky@nowlive.ro>
82 
83 
84  Classic funding method that receives ETH and mints tokens directly
85     - has hard cap.
86     - minted supply affects final token supply.
87     - does not use vaults, mints directly to sender address.
88     - accepts over cap payment and returns what's left back to sender.
89   Funds used exclusively for Marketing
90 
91 */
92 
93 
94 
95 
96 contract ExtraFundingInputMarketing {
97 
98     ABITokenManager public TokenManagerEntity;
99     address public outputWalletAddress;
100     uint256 public hardCap;
101     uint256 public tokensPerEth;
102 
103     uint256 public start_time;
104     uint256 public end_time;
105 
106     uint256 public AmountRaised = 0;
107 
108     address public deployer;
109     bool public settings_added = false;
110 
111     function ExtraFundingInputMarketing() public {
112         deployer = msg.sender;
113     }
114 
115     function addSettings(
116         address _tokenManager,
117         address _outputWalletAddress,
118         uint256 _cap,
119         uint256 _price,
120         uint256 _start_time,
121         uint256 _endtime
122     )
123         public
124     {
125         require(msg.sender == deployer);
126         require(settings_added == false);
127 
128         TokenManagerEntity = ABITokenManager(_tokenManager);
129         outputWalletAddress = _outputWalletAddress;
130         hardCap = _cap;
131         tokensPerEth = _price;
132         start_time = _start_time;
133         end_time = _endtime;
134         settings_added = true;
135     }
136 
137     event EventInputPaymentReceived(address sender, uint amount);
138 
139     function () public payable {
140         buy();
141     }
142 
143     function buy() public payable returns(bool) {
144         if(msg.value > 0) {
145             if( canAcceptPayment() ) {
146 
147                 uint256 contributed_value = msg.value;
148                 uint256 amountOverCap = getValueOverCurrentCap(contributed_value);
149                 if ( amountOverCap > 0 ) {
150                     // calculate how much we can accept
151 
152                     // update contributed value
153                     contributed_value -= amountOverCap;
154                 }
155 
156                 // update raised value
157                 AmountRaised+= contributed_value;
158 
159                 // allocate tokens to contributor based on value
160                 uint256 tokenAmount = getTokensForValue( contributed_value );
161                 TokenManagerEntity.mintForMarketingPool( msg.sender, tokenAmount);
162 
163                 // transfer contributed value to platform wallet
164                 if( !outputWalletAddress.send(contributed_value) ) {
165                     revert();
166                 }
167 
168                 if(amountOverCap > 0) {
169                     // last step, if we received more than we can accept, send remaining back
170                     // amountOverCap sent back
171                     if( msg.sender.send(this.balance) ) {
172                         return true;
173                     }
174                     else {
175                         revert();
176                     }
177                 } else {
178                     return true;
179                 }
180             } else {
181                 revert();
182             }
183         } else {
184             revert();
185         }
186     }
187 
188     function canAcceptPayment() public view returns (bool) {
189         if( (getTimestamp() >= start_time && getTimestamp() <= end_time) && (AmountRaised < hardCap) ) {
190             return true;
191         }
192         return false;
193     }
194 
195     function getTokensForValue( uint256 _value) public view returns (uint256) {
196         return _value * tokensPerEth;
197     }
198 
199     function getValueOverCurrentCap(uint256 _amount) public view returns (uint256) {
200         uint256 remaining = hardCap - AmountRaised;
201         if( _amount > remaining ) {
202             return _amount - remaining;
203         }
204         return 0;
205     }
206 
207     function getTimestamp() view public returns (uint256) {
208         return now;
209     }
210 
211 }