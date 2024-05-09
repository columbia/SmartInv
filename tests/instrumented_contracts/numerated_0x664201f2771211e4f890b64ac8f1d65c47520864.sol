1 // File: contracts/lib/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 contract Ownable {
6     address public owner;
7     event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
8 
9     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
10     constructor() public { owner = msg.sender; }
11 
12     /// @dev Throws if called by any contract other than latest designated caller
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
19     /// @param newOwner The address to transfer ownership to.
20     function transferOwnership(address newOwner) public onlyOwner {
21         require(newOwner != address(0));
22         emit OwnershipTransferred(owner, newOwner);
23         owner = newOwner;
24     }
25 }
26 
27 // File: contracts/lib/token/FactoryTokenInterface.sol
28 
29 pragma solidity ^0.4.24;
30 
31 
32 contract FactoryTokenInterface is Ownable {
33     function balanceOf(address _owner) public view returns (uint256);
34     function transfer(address _to, uint256 _value) public returns (bool);
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
36     function approve(address _spender, uint256 _value) public returns (bool);
37     function allowance(address _owner, address _spender) public view returns (uint256);
38     function mint(address _to, uint256 _amount) public returns (bool);
39     function burnFrom(address _from, uint256 _value) public;
40 }
41 
42 // File: contracts/lib/token/TokenFactoryInterface.sol
43 
44 pragma solidity ^0.4.24;
45 
46 
47 contract TokenFactoryInterface {
48     function create(string _name, string _symbol) public returns (FactoryTokenInterface);
49 }
50 
51 // File: contracts/lib/ownership/ZapCoordinatorInterface.sol
52 
53 pragma solidity ^0.4.24;
54 
55 
56 contract ZapCoordinatorInterface is Ownable {
57     function addImmutableContract(string contractName, address newAddress) external;
58     function updateContract(string contractName, address newAddress) external;
59     function getContractName(uint index) public view returns (string);
60     function getContract(string contractName) public view returns (address);
61     function updateAllDependencies() external;
62 }
63 
64 // File: contracts/platform/bondage/BondageInterface.sol
65 
66 pragma solidity ^0.4.24;
67 
68 contract BondageInterface {
69     function bond(address, bytes32, uint256) external returns(uint256);
70     function unbond(address, bytes32, uint256) external returns (uint256);
71     function delegateBond(address, address, bytes32, uint256) external returns(uint256);
72     function escrowDots(address, address, bytes32, uint256) external returns (bool);
73     function releaseDots(address, address, bytes32, uint256) external returns (bool);
74     function returnDots(address, address, bytes32, uint256) external returns (bool success);
75     function calcZapForDots(address, bytes32, uint256) external view returns (uint256);
76     function currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
77     function getDotsIssued(address, bytes32) public view returns (uint256);
78     function getBoundDots(address, address, bytes32) public view returns (uint256);
79     function getZapBound(address, bytes32) public view returns (uint256);
80     function dotLimit( address, bytes32) public view returns (uint256);
81 }
82 
83 // File: contracts/platform/bondage/currentCost/CurrentCostInterface.sol
84 
85 pragma solidity ^0.4.24;
86 
87 contract CurrentCostInterface {
88     function _currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
89     function _dotLimit(address, bytes32) public view returns (uint256);
90     function _costOfNDots(address, bytes32, uint256, uint256) public view returns (uint256);
91 }
92 
93 // File: contracts/platform/registry/RegistryInterface.sol
94 
95 pragma solidity ^0.4.24;
96 
97 contract RegistryInterface {
98     function initiateProvider(uint256, bytes32) public returns (bool);
99     function initiateProviderCurve(bytes32, int256[], address) public returns (bool);
100     function setEndpointParams(bytes32, bytes32[]) public;
101     function getEndpointParams(address, bytes32) public view returns (bytes32[]);
102     function getProviderPublicKey(address) public view returns (uint256);
103     function getProviderTitle(address) public view returns (bytes32);
104     function setProviderParameter(bytes32, bytes) public;
105     function setProviderTitle(bytes32) public;
106     function clearEndpoint(bytes32) public;
107     function getProviderParameter(address, bytes32) public view returns (bytes);
108     function getAllProviderParams(address) public view returns (bytes32[]);
109     function getProviderCurveLength(address, bytes32) public view returns (uint256);
110     function getProviderCurve(address, bytes32) public view returns (int[]);
111     function isProviderInitiated(address) public view returns (bool);
112     function getAllOracles() external view returns (address[]);
113     function getProviderEndpoints(address) public view returns (bytes32[]);
114     function getEndpointBroker(address, bytes32) public view returns (address);
115 }
116 
117 // File: contracts/lib/platform/SampleContest.sol
118 
119 /*
120 Contest where users can bond to contestant curves which mint tokens( unbondabe*), 
121 winner decided by oracle
122 contract unbonds from loser curves
123 holders of winning token allowed to take share of reserve token(zap) which was unbonded from loser curves
124 
125 Starting Contest:
126     
127     deploys with contest uninitialized: status = Uninitialized
128     
129     anyone can initialize new token:backed curve 
130     
131     owner initializes contest with oracle: status = Initialized
132 
133 Ending Contest:
134     
135     owner calls close: status = ReadyToSettle
136     
137     oracle calls judge to set winning curve: status = Judged
138     
139     anyone calls settle, contest unbonds from losing curves: status = Settled
140     
141     holders of winnning token call redeem to retrieve their share of reserve token 
142     based on their holding of winning token
143     
144     *holders of winning token can optionally unbond 
145 */
146 
147 contract SampleContest is Ownable {
148 
149     CurrentCostInterface currentCost;
150     FactoryTokenInterface public reserveToken;
151     ZapCoordinatorInterface public coord;
152     TokenFactoryInterface public tokenFactory;
153     BondageInterface bondage;
154 
155     enum ContestStatus { 
156         Uninitialized,    //  
157         Initialized,      // ready for buys
158         ReadyToSettle,    // ready for judgement 
159         Judged,           // winner determined 
160         Settled           // value of winning tokens determined 
161     }
162 
163     address public oracle;    // address of oracle who will choose the winner
164     bytes32 public winner;    // curve identifier of the winner 
165     uint256 public winValue;  // final value of the winning token
166     ContestStatus public status; //state of contest
167 
168     mapping(bytes32 => address) public curves; // map of endpoint specifier to token-backed dotaddress
169     bytes32[] public curves_list; // array of endpoint specifiers
170 
171     mapping(address => uint8) public redeemed; // map of address redemption state
172     address[] public redeemed_list;
173     
174     event DotTokenCreated(address tokenAddress);
175     event Bonded(bytes32 indexed endpoint, uint256 indexed numDots, address indexed sender); 
176     event Unbonded(bytes32 indexed endpoint, uint256 indexed numDots, address indexed sender);
177 
178     event Initialized(address indexed oracle);
179     event Closed();
180     event Judged(bytes32 winner);
181     event Settled(uint256 winValue, uint256 winTokens); 
182     event Reset();
183 
184     constructor(
185         address coordinator, 
186         address factory,
187         uint256 providerPubKey,
188         bytes32 providerTitle 
189     ){
190         coord = ZapCoordinatorInterface(coordinator); 
191         reserveToken = FactoryTokenInterface(coord.getContract("ZAP_TOKEN"));
192         //always allow bondage to transfer from wallet
193         reserveToken.approve(coord.getContract("BONDAGE"), ~uint256(0));
194         tokenFactory = TokenFactoryInterface(factory);
195 
196         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
197         registry.initiateProvider(providerPubKey, providerTitle);
198         status = ContestStatus.Uninitialized;
199     }
200 
201 // contest lifecycle
202  
203     function initializeContest(
204         address oracleAddress
205     ) onlyOwner public {
206         require( status == ContestStatus.Uninitialized, "Contest already initialized");
207         oracle = oracleAddress;
208         status = ContestStatus.Initialized;
209         emit Initialized(oracle);
210     }
211 
212     function close() onlyOwner {
213         status = ContestStatus.ReadyToSettle; 
214         emit Closed();
215     }
216 
217     function judge(bytes32 endpoint) {
218         require( status == ContestStatus.ReadyToSettle, "not closed" );
219         require( msg.sender == oracle, "not oracle");
220         winner = endpoint;
221         status = ContestStatus.Judged;
222         emit Judged(winner);
223     }
224 
225     function settle() {
226         require( status == ContestStatus.Judged, "winner not determined");
227 
228         bondage = BondageInterface(coord.getContract("BONDAGE"));
229         uint256 dots;
230         for( uint256 i = 0; i < curves_list.length; i++) {
231 
232             if(curves_list[i] != winner) {
233                 dots =  bondage.getDotsIssued(address(this), curves_list[i]);  
234                 if( dots > 0) {
235                     bondage.unbond(address(this), curves_list[i], dots);                 
236                 }  
237             }
238         } 
239 
240         // how many winning dots    
241         uint256 numWin =  bondage.getDotsIssued(address(this), winner);  
242         // redeemable value of each dot token
243         winValue = reserveToken.balanceOf(address(this)) / numWin;
244         status = ContestStatus.Settled;
245         emit Settled(winValue, numWin);
246     }
247 
248 
249     //TODO ensure all has been redeemed or enough time has elasped 
250     function reset() public {
251         require(status == ContestStatus.Settled, "contest not settled");
252         require(msg.sender == oracle);
253         
254         delete redeemed_list;
255         delete curves_list;
256         status = ContestStatus.Initialized; 
257         emit Reset();
258     }
259 
260 /// TokenDotFactory methods
261 
262     function initializeCurve(
263         bytes32 endpoint, 
264         bytes32 symbol, 
265         int256[] curve
266     ) public returns(address) {
267         
268         require(curves[endpoint] == 0, "Curve endpoint already exists or used in the past. Please choose new");
269         
270         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
271         require(registry.isProviderInitiated(address(this)), "Provider not intiialized");
272 
273         registry.initiateProviderCurve(endpoint, curve, address(this));
274         curves[endpoint] = newToken(bytes32ToString(endpoint), bytes32ToString(symbol));
275         curves_list.push(endpoint);        
276         registry.setProviderParameter(endpoint, toBytes(curves[endpoint]));
277         
278         DotTokenCreated(curves[endpoint]);
279         return curves[endpoint];
280     }
281 
282     //whether this contract holds tokens or coming from msg.sender,etc
283     function bond(bytes32 endpoint, uint numDots) public  {
284 
285         require( status == ContestStatus.Initialized, " contest not live"); 
286 
287         bondage = BondageInterface(coord.getContract("BONDAGE"));
288         uint256 issued = bondage.getDotsIssued(address(this), endpoint);
289 
290         CurrentCostInterface cost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
291         uint256 numReserve = cost._costOfNDots(address(this), endpoint, issued + 1, numDots - 1);
292 
293         require(
294             reserveToken.transferFrom(msg.sender, address(this), numReserve),
295             "insufficient accepted token numDots approved for transfer"
296         );
297 
298         reserveToken.approve(address(bondage), numReserve);
299         bondage.bond(address(this), endpoint, numDots);
300         FactoryTokenInterface(curves[endpoint]).mint(msg.sender, numDots);
301         emit Bonded(endpoint, numDots, msg.sender);
302     }
303 
304     //whether this contract holds tokens or coming from msg.sender,etc
305     function unbond(bytes32 endpoint, uint numDots) public {
306 
307         require( status == ContestStatus.Settled, " contest not settled"); 
308         require(redeemed[msg.sender] == 0, "already redeeemed");
309         require(winner==endpoint, "only winners can unbond"); 
310 
311         bondage = BondageInterface(coord.getContract("BONDAGE"));
312         uint issued = bondage.getDotsIssued(address(this), winner);
313 
314         currentCost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
315         uint reserveCost = currentCost._costOfNDots(address(this), winner, issued + 1 - numDots, numDots - 1);
316         //unbond dots
317         bondage.unbond(address(this), winner, numDots);
318 
319         //burn dot backed token
320         FactoryTokenInterface curveToken = FactoryTokenInterface(curves[winner]);
321 
322         uint reward = winValue * FactoryTokenInterface(getTokenAddress(winner)).balanceOf(msg.sender);
323         
324         //burn user's unbonded tokens
325         curveToken.burnFrom(msg.sender, numDots);
326 
327         reserveToken.transfer(msg.sender, reward);
328         redeemed[msg.sender] = 1;
329 
330         emit Unbonded(winner, numDots, msg.sender);
331     }
332 
333     function newToken(
334         string name,
335         string symbol
336     ) 
337         public
338         returns (address tokenAddress) 
339     {
340         FactoryTokenInterface token = tokenFactory.create(name, symbol);
341         tokenAddress = address(token);
342         return tokenAddress;
343     }
344 
345     function getTokenAddress(bytes32 endpoint) public view returns(address) {
346         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
347         return bytesToAddr(registry.getProviderParameter(address(this), endpoint));
348     }
349 
350     // https://ethereum.stackexchange.com/questions/884/how-to-convert-an-address-to-bytes-in-solidity
351     function toBytes(address x) public pure returns (bytes b) {
352         b = new bytes(20);
353         for (uint i = 0; i < 20; i++)
354             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
355     }
356 
357     //https://ethereum.stackexchange.com/questions/2519/how-to-convert-a-bytes32-to-string
358     function bytes32ToString(bytes32 x) public pure returns (string) {
359         bytes memory bytesString = new bytes(32);
360         bytesString = abi.encodePacked(x);
361         return string(bytesString);
362     }
363 
364     //https://ethereum.stackexchange.com/questions/15350/how-to-convert-an-bytes-to-address-in-solidity
365     function bytesToAddr (bytes b) public pure returns (address) {
366         uint result = 0;
367         for (uint i = b.length-1; i+1 > 0; i--) {
368             uint c = uint(b[i]);
369             uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
370             result += to_inc;
371         }
372         return address(result);
373     }
374 }