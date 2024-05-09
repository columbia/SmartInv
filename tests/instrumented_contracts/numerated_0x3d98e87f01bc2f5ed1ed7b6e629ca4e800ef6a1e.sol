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
160         Settled,           // value of winning tokens determined 
161         Canceled          // oracle did not respond in time
162     }
163 
164     address public oracle;    // address of oracle who will choose the winner
165     uint256 public ttl;    // time allowed before, close and judge. if time expired, allow unbond from all curves 
166     uint256 public expired = 2**256 -1;    // time allowed before, close and judge. if time expired, allow unbond from all curves 
167     bytes32 public winner;    // curve identifier of the winner 
168     uint256 public winValue;  // final value of the winning token
169     ContestStatus public status; //state of contest
170 
171     mapping(bytes32 => address) public curves; // map of endpoint specifier to token-backed dotaddress
172     bytes32[] public curves_list; // array of endpoint specifiers
173 
174     mapping(address => uint8) public redeemed; // map of address redemption state
175     address[] public redeemed_list;
176     
177     event DotTokenCreated(address tokenAddress);
178     event Bonded(bytes32 indexed endpoint, uint256 indexed numDots, address indexed sender); 
179     event Unbonded(bytes32 indexed endpoint, uint256 indexed numDots, address indexed sender);
180 
181     event Initialized(address indexed oracle);
182     event Closed();
183     event Judged(bytes32 winner);
184     event Settled(uint256 winValue, uint256 winTokens); 
185     event Reset();
186 
187     constructor(
188         address coordinator, 
189         address factory,
190         uint256 providerPubKey,
191         bytes32 providerTitle 
192     ){
193         coord = ZapCoordinatorInterface(coordinator); 
194         reserveToken = FactoryTokenInterface(coord.getContract("ZAP_TOKEN"));
195         //always allow bondage to transfer from wallet
196         reserveToken.approve(coord.getContract("BONDAGE"), ~uint256(0));
197         tokenFactory = TokenFactoryInterface(factory);
198 
199         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
200         registry.initiateProvider(providerPubKey, providerTitle);
201         status = ContestStatus.Uninitialized;
202     }
203 
204 // contest lifecycle
205  
206     function initializeContest(
207         address oracleAddress,
208         uint256 _ttl
209     ) onlyOwner public {
210         require( status == ContestStatus.Uninitialized, "Contest already initialized");
211         oracle = oracleAddress;
212         ttl = _ttl;
213         status = ContestStatus.Initialized;
214         emit Initialized(oracle);
215     }
216 
217     function close() onlyOwner {
218         status = ContestStatus.ReadyToSettle; 
219         expired = block.number + ttl; 
220         emit Closed();
221     }
222 
223     function judge(bytes32 endpoint) {
224         require( status == ContestStatus.ReadyToSettle, "not closed" );
225         require( msg.sender == oracle, "not oracle");
226         winner = endpoint;
227         status = ContestStatus.Judged;
228         emit Judged(winner);
229     }
230 
231     function settle() {
232         require( status == ContestStatus.Judged, "winner not determined");
233 
234         bondage = BondageInterface(coord.getContract("BONDAGE"));
235         uint256 dots;
236         for( uint256 i = 0; i < curves_list.length; i++) {
237 
238             if(curves_list[i] != winner) {
239                 dots =  bondage.getDotsIssued(address(this), curves_list[i]);  
240                 if( dots > 0) {
241                     bondage.unbond(address(this), curves_list[i], dots);                 
242                 }  
243             }
244         } 
245 
246         // how many winning dots    
247         uint256 numWin =  bondage.getDotsIssued(address(this), winner);  
248         // redeemable value of each dot token
249         winValue = reserveToken.balanceOf(address(this)) / numWin;
250         status = ContestStatus.Settled;
251         emit Settled(winValue, numWin);
252     }
253 
254 
255     //TODO ensure all has been redeemed or enough time has elasped 
256     function reset() public {
257         require(msg.sender == oracle);
258         require(status == ContestStatus.Settled || status == ContestStatus.Canceled, "contest not settled");
259         if( status == ContestStatus.Canceled ) {
260             require(reserveToken.balanceOf(address(this)) == 0, "funds remain");
261         }
262 
263         delete redeemed_list;
264         delete curves_list;
265         status = ContestStatus.Initialized; 
266         emit Reset();
267     }
268 
269 /// TokenDotFactory methods
270 
271     function initializeCurve(
272         bytes32 endpoint, 
273         bytes32 symbol, 
274         int256[] curve
275     ) public returns(address) {
276         
277         require(curves[endpoint] == 0, "Curve endpoint already exists or used in the past. Please choose new");
278         
279         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
280         require(registry.isProviderInitiated(address(this)), "Provider not intiialized");
281 
282         registry.initiateProviderCurve(endpoint, curve, address(this));
283         curves[endpoint] = newToken(bytes32ToString(endpoint), bytes32ToString(symbol));
284         curves_list.push(endpoint);        
285         registry.setProviderParameter(endpoint, toBytes(curves[endpoint]));
286         
287         DotTokenCreated(curves[endpoint]);
288         return curves[endpoint];
289     }
290 
291     //whether this contract holds tokens or coming from msg.sender,etc
292     function bond(bytes32 endpoint, uint numDots) public  {
293 
294         require( status == ContestStatus.Initialized, " contest not live"); 
295 
296         bondage = BondageInterface(coord.getContract("BONDAGE"));
297         uint256 issued = bondage.getDotsIssued(address(this), endpoint);
298 
299         CurrentCostInterface cost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
300         uint256 numReserve = cost._costOfNDots(address(this), endpoint, issued + 1, numDots - 1);
301 
302         require(
303             reserveToken.transferFrom(msg.sender, address(this), numReserve),
304             "insufficient accepted token numDots approved for transfer"
305         );
306 
307         reserveToken.approve(address(bondage), numReserve);
308         bondage.bond(address(this), endpoint, numDots);
309         FactoryTokenInterface(curves[endpoint]).mint(msg.sender, numDots);
310         emit Bonded(endpoint, numDots, msg.sender);
311     }
312 
313     //whether this contract holds tokens or coming from msg.sender,etc
314     function unbond(bytes32 endpoint, uint numDots) public {
315 
316         require( status == ContestStatus.ReadyToSettle || status == ContestStatus.Settled, "not ready");
317 
318         bondage = BondageInterface(coord.getContract("BONDAGE"));
319         uint issued = bondage.getDotsIssued(address(this), endpoint);
320 
321         //unbond dots
322         bondage.unbond(address(this), winner, numDots);
323 
324         currentCost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
325         //get reserve value to send 
326         uint reserveCost = currentCost._costOfNDots(address(this), endpoint, issued + 1 - numDots, numDots - 1);
327 
328         FactoryTokenInterface curveToken = FactoryTokenInterface(curves[endpoint]);
329 
330         if( status == ContestStatus.ReadyToSettle || status == ContestStatus.Canceled) {
331             
332             status = ContestStatus.Canceled;
333             //oracle has taken too long to judge winner so unbonds will be allowed for all
334             require(block.number > expired, "oracle query not expired.");
335             require( status == ContestStatus.ReadyToSettle, "contest not ready to settle");
336 
337             //unbond dots
338             bondage.unbond(address(this), endpoint, numDots);
339 
340             //burn dot backed token
341             curveToken.burnFrom(msg.sender, numDots);
342 
343             require(reserveToken.transfer(msg.sender, reserveCost), "transfer failed");
344             Unbonded(endpoint, numDots, msg.sender);
345         }
346 
347         else {
348 
349             require( status == ContestStatus.Settled, " contest not settled"); 
350             require(redeemed[msg.sender] == 0, "already redeeemed");
351             require(winner==endpoint, "only winners can unbond for rewards"); 
352 
353             //reward user's winning tokens unbond value + share of losing curves reserve token proportional to winning token holdings
354             uint reward = ( winValue * FactoryTokenInterface(getTokenAddress(winner)).balanceOf(msg.sender) ) + reserveCost;
355             
356             //burn user's unbonded tokens
357             curveToken.burnFrom(msg.sender, numDots);
358 
359             reserveToken.transfer(msg.sender, reward);
360             redeemed[msg.sender] = 1;
361 
362             emit Unbonded(winner, numDots, msg.sender);
363         }
364     }
365 
366     function newToken(
367         string name,
368         string symbol
369     ) 
370         public
371         returns (address tokenAddress) 
372     {
373         FactoryTokenInterface token = tokenFactory.create(name, symbol);
374         tokenAddress = address(token);
375         return tokenAddress;
376     }
377 
378     function getTokenAddress(bytes32 endpoint) public view returns(address) {
379         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY")); 
380         return bytesToAddr(registry.getProviderParameter(address(this), endpoint));
381     }
382 
383     // https://ethereum.stackexchange.com/questions/884/how-to-convert-an-address-to-bytes-in-solidity
384     function toBytes(address x) public pure returns (bytes b) {
385         b = new bytes(20);
386         for (uint i = 0; i < 20; i++)
387             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
388     }
389 
390     //https://ethereum.stackexchange.com/questions/2519/how-to-convert-a-bytes32-to-string
391     function bytes32ToString(bytes32 x) public pure returns (string) {
392         bytes memory bytesString = new bytes(32);
393         bytesString = abi.encodePacked(x);
394         return string(bytesString);
395     }
396 
397     //https://ethereum.stackexchange.com/questions/15350/how-to-convert-an-bytes-to-address-in-solidity
398     function bytesToAddr (bytes b) public pure returns (address) {
399         uint result = 0;
400         for (uint i = b.length-1; i+1 > 0; i--) {
401             uint c = uint(b[i]);
402             uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
403             result += to_inc;
404         }
405         return address(result);
406     }
407 }