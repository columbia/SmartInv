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
158         // ReadyToSettle,    // ready for judgement
159         Judged,           // winner determined
160         Settled,           // value of winning tokens determined
161         Canceled          // oracle did not respond in time
162     }
163 
164     address public oracle;    // address of oracle who will choose the winner
165     uint256 public ttl;    // time allowed before, close and judge. if time expired, allow unbond from all curves
166     // uint256 public expired = 2**256 -1;    // time allowed before, close and judge. if time expired, allow unbond from all curves
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
179     event Unbonded(bytes32 indexed endpoint,uint256 indexed amount, address indexed sender);
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
212         ttl = _ttl + block.number;
213         status = ContestStatus.Initialized;
214         emit Initialized(oracle);
215     }
216 
217     // function close() onlyOwner {
218     //     status = ContestStatus.ReadyToSettle;
219     //     expired = block.number + ttl;
220     //     emit Closed();
221     // }
222 
223     function judge(bytes32 endpoint) {
224         require( status == ContestStatus.Initialized, "Contest not initialized" );
225         require( msg.sender == oracle, "Only designated Oracle can judge");
226         require(block.number < ttl, "Contest expired, refund in process");
227         winner = endpoint;
228         status = ContestStatus.Judged;
229         emit Judged(winner);
230     }
231 
232     function settle() public {
233         require( status == ContestStatus.Judged, "winner not determined");
234 
235         bondage = BondageInterface(coord.getContract("BONDAGE"));
236         // how many winning dots
237         uint256 numWin =  bondage.getDotsIssued(address(this), winner);
238         // redeemable value of each dot token
239         uint256 dots;
240         for( uint256 i = 0; i < curves_list.length; i++) {
241           if(curves_list[i]!=winner){
242             dots =  bondage.getDotsIssued(address(this), curves_list[i]);
243             if( dots > 0) {
244                 bondage.unbond(address(this), curves_list[i], dots);
245             }
246           }
247         }
248         winValue = reserveToken.balanceOf(address(this)) / numWin;
249 
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
276         // require(status==ContestStatus.Initialized,"Contest is not initalized")
277         require(curves[endpoint] == 0, "Curve endpoint already exists or used in the past. Please choose a new endpoint");
278 
279         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY"));
280         registry.initiateProviderCurve(endpoint, curve, address(this));
281 
282         curves[endpoint] = newToken(bytes32ToString(endpoint), bytes32ToString(symbol));
283         curves_list.push(endpoint);
284         registry.setProviderParameter(endpoint, toBytes(curves[endpoint]));
285 
286         DotTokenCreated(curves[endpoint]);
287         return curves[endpoint];
288     }
289 
290     //whether this contract holds tokens or coming from msg.sender,etc
291     function bond(bytes32 endpoint, uint numDots) public  {
292         require( status == ContestStatus.Initialized, " contest is not initiated");
293 
294         bondage = BondageInterface(coord.getContract("BONDAGE"));
295         uint256 issued = bondage.getDotsIssued(address(this), endpoint);
296 
297         CurrentCostInterface cost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
298         uint256 numReserve = cost._costOfNDots(address(this), endpoint, issued + 1, numDots - 1);
299 
300         require(
301             reserveToken.transferFrom(msg.sender, address(this), numReserve),
302             "insufficient accepted token numDots approved for transfer"
303         );
304 
305         reserveToken.approve(address(bondage), numReserve);
306         bondage.bond(address(this), endpoint, numDots);
307         FactoryTokenInterface(curves[endpoint]).mint(msg.sender, numDots);
308         emit Bonded(endpoint, numDots, msg.sender);
309     }
310 
311     //whether this contract holds tokens or coming from msg.sender,etc
312     function unbond(bytes32 endpoint, uint numDots) public returns(uint256) {
313 
314         require(status == ContestStatus.Settled, "not ready");
315 
316         bondage = BondageInterface(coord.getContract("BONDAGE"));
317         uint issued = bondage.getDotsIssued(address(this), endpoint);
318 
319         //unbond dots
320         bondage.unbond(address(this), winner, numDots);
321 
322         currentCost = CurrentCostInterface(coord.getContract("CURRENT_COST"));
323         //get reserve value to send
324         uint reserveCost = currentCost._costOfNDots(address(this), endpoint, issued + 1 - numDots, numDots - 1);
325 
326         FactoryTokenInterface curveToken = FactoryTokenInterface(curves[endpoint]);
327 
328         if( status == ContestStatus.Initialized || status == ContestStatus.Canceled) {
329             //oracle has taken too long to judge winner so unbonds will be allowed for all
330             require(block.number > ttl, "oracle query not expired.");
331             // require(status == ContestStatus.Settled, "contest not settled");
332             status = ContestStatus.Canceled;
333 
334             //unbond dots
335             //TODO get bound dot then unbond the correct amount ? or unbond all in 1 call
336             // bondage.unbond(address(this), endpoint, numDots);
337 
338             //burn dot backed token
339             //FIXME only burn the bound tokens ?
340             curveToken.burnFrom(msg.sender, numDots);
341 
342             require(reserveToken.transfer(msg.sender, reserveCost), "transfer failed");
343             emit Unbonded(endpoint, reserveCost, msg.sender);
344             return reserveCost;
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
357             // curveToken.approve(address(this),numDots);
358             curveToken.burnFrom(msg.sender, numDots);
359 
360             reserveToken.transfer(msg.sender, reward);
361             redeemed[msg.sender] = 1;
362 
363             // emit Unbonded(winner, reward, msg.sender);
364             return reward;
365         }
366     }
367 
368     function newToken(
369         string name,
370         string symbol
371     )
372         internal
373         returns (address tokenAddress)
374     {
375         FactoryTokenInterface token = tokenFactory.create(name, symbol);
376         tokenAddress = address(token);
377         return tokenAddress;
378     }
379 
380     function getTokenAddress(bytes32 endpoint) public view returns(address) {
381         RegistryInterface registry = RegistryInterface(coord.getContract("REGISTRY"));
382         return bytesToAddr(registry.getProviderParameter(address(this), endpoint));
383     }
384 
385     function getEndpoints() public view returns(bytes32[]){
386       return curves_list;
387     }
388 
389     function getStatus() public view returns(uint256){
390       return uint(status);
391     }
392 
393     function isEndpointValid(bytes32 _endpoint) public view returns(bool){
394       for(uint256 i=0; i<curves_list.length;i++){
395         if(_endpoint == curves_list[i]){
396           return true;
397         }
398       }
399       return false;
400     }
401 
402     // https://ethereum.stackexchange.com/questions/884/how-to-convert-an-address-to-bytes-in-solidity
403     function toBytes(address x) public pure returns (bytes b) {
404         b = new bytes(20);
405         for (uint i = 0; i < 20; i++)
406             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
407     }
408 
409     //https://ethereum.stackexchange.com/questions/2519/how-to-convert-a-bytes32-to-string
410     function bytes32ToString(bytes32 x) public pure returns (string) {
411         bytes memory bytesString = new bytes(32);
412         bytesString = abi.encodePacked(x);
413         return string(bytesString);
414     }
415 
416     //https://ethereum.stackexchange.com/questions/15350/how-to-convert-an-bytes-to-address-in-solidity
417     function bytesToAddr (bytes b) public pure returns (address) {
418         uint result = 0;
419         for (uint i = b.length-1; i+1 > 0; i--) {
420             uint c = uint(b[i]);
421             uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
422             result += to_inc;
423         }
424         return address(result);
425     }
426 }