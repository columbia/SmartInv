1 pragma solidity ^0.4.24;
2 
3 // File: contracts/lib/ownership/Ownable.sol
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
21        require(newOwner != address(0));
22        emit OwnershipTransferred(owner, newOwner);
23        owner = newOwner;
24     }
25 }
26 
27 // File: contracts/lib/lifecycle/Destructible.sol
28 
29 contract Destructible is Ownable {
30 	function selfDestruct() public onlyOwner {
31 		selfdestruct(owner);
32 	}
33 }
34 
35 // File: contracts/lib/ownership/ZapCoordinatorInterface.sol
36 
37 contract ZapCoordinatorInterface is Ownable {
38 	function addImmutableContract(string contractName, address newAddress) external;
39 	function updateContract(string contractName, address newAddress) external;
40 	function getContractName(uint index) public view returns (string);
41 	function getContract(string contractName) public view returns (address);
42 	function updateAllDependencies() external;
43 }
44 
45 // File: contracts/lib/ownership/Upgradable.sol
46 
47 pragma solidity ^0.4.24;
48 
49 contract Upgradable {
50 
51 	address coordinatorAddr;
52 	ZapCoordinatorInterface coordinator;
53 
54 	constructor(address c) public{
55 		coordinatorAddr = c;
56 		coordinator = ZapCoordinatorInterface(c);
57 	}
58 
59     function updateDependencies() external coordinatorOnly {
60        _updateDependencies();
61     }
62 
63     function _updateDependencies() internal;
64 
65     modifier coordinatorOnly() {
66     	require(msg.sender == coordinatorAddr, "Error: Coordinator Only Function");
67     	_;
68     }
69 }
70 
71 // File: contracts/lib/ERC20.sol
72 
73 contract ERC20Basic {
74     uint256 public totalSupply;
75     function balanceOf(address who) public constant returns (uint256);
76     function transfer(address to, uint256 value) public returns (bool);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 contract ERC20 is ERC20Basic {
81     string public name;
82     string public symbol;
83     uint256 public decimals;
84     function allowance(address owner, address spender) public constant returns (uint256);
85     function transferFrom(address from, address to, uint256 value) public returns (bool);
86     function approve(address spender, uint256 value) public returns (bool);
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 // File: contracts/platform/database/DatabaseInterface.sol
91 
92 contract DatabaseInterface is Ownable {
93 	function setStorageContract(address _storageContract, bool _allowed) public;
94 	/*** Bytes32 ***/
95 	function getBytes32(bytes32 key) external view returns(bytes32);
96 	function setBytes32(bytes32 key, bytes32 value) external;
97 	/*** Number **/
98 	function getNumber(bytes32 key) external view returns(uint256);
99 	function setNumber(bytes32 key, uint256 value) external;
100 	/*** Bytes ***/
101 	function getBytes(bytes32 key) external view returns(bytes);
102 	function setBytes(bytes32 key, bytes value) external;
103 	/*** String ***/
104 	function getString(bytes32 key) external view returns(string);
105 	function setString(bytes32 key, string value) external;
106 	/*** Bytes Array ***/
107 	function getBytesArray(bytes32 key) external view returns (bytes32[]);
108 	function getBytesArrayIndex(bytes32 key, uint256 index) external view returns (bytes32);
109 	function getBytesArrayLength(bytes32 key) external view returns (uint256);
110 	function pushBytesArray(bytes32 key, bytes32 value) external;
111 	function setBytesArrayIndex(bytes32 key, uint256 index, bytes32 value) external;
112 	function setBytesArray(bytes32 key, bytes32[] value) external;
113 	/*** Int Array ***/
114 	function getIntArray(bytes32 key) external view returns (int[]);
115 	function getIntArrayIndex(bytes32 key, uint256 index) external view returns (int);
116 	function getIntArrayLength(bytes32 key) external view returns (uint256);
117 	function pushIntArray(bytes32 key, int value) external;
118 	function setIntArrayIndex(bytes32 key, uint256 index, int value) external;
119 	function setIntArray(bytes32 key, int[] value) external;
120 	/*** Address Array ***/
121 	function getAddressArray(bytes32 key) external view returns (address[]);
122 	function getAddressArrayIndex(bytes32 key, uint256 index) external view returns (address);
123 	function getAddressArrayLength(bytes32 key) external view returns (uint256);
124 	function pushAddressArray(bytes32 key, address value) external;
125 	function setAddressArrayIndex(bytes32 key, uint256 index, address value) external;
126 	function setAddressArray(bytes32 key, address[] value) external;
127 }
128 
129 // File: contracts/platform/bondage/currentCost/CurrentCostInterface.sol
130 
131 contract CurrentCostInterface {    
132     function _currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
133     function _dotLimit(address, bytes32) public view returns (uint256);
134     function _costOfNDots(address, bytes32, uint256, uint256) public view returns (uint256);
135 }
136 
137 // File: contracts/platform/bondage/BondageInterface.sol
138 
139 contract BondageInterface {
140     function bond(address, bytes32, uint256) external returns(uint256);
141     function unbond(address, bytes32, uint256) external returns (uint256);
142     function delegateBond(address, address, bytes32, uint256) external returns(uint256);
143     function escrowDots(address, address, bytes32, uint256) external returns (bool);
144     function releaseDots(address, address, bytes32, uint256) external returns (bool);
145     function returnDots(address, address, bytes32, uint256) external returns (bool success);
146     function calcZapForDots(address, bytes32, uint256) external view returns (uint256);
147     function currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
148     function getDotsIssued(address, bytes32) public view returns (uint256);
149     function getBoundDots(address, address, bytes32) public view returns (uint256);
150     function getZapBound(address, bytes32) public view returns (uint256);
151     function dotLimit( address, bytes32) public view returns (uint256);
152 }
153 
154 // File: contracts/platform/bondage/Bondage.sol
155 
156 contract Bondage is Destructible, BondageInterface, Upgradable {
157     DatabaseInterface public db;
158 
159     event Bound(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numZap, uint256 numDots);
160     event Unbound(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numDots);
161     event Escrowed(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numDots);
162     event Released(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numDots);
163     event Returned(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numDots);
164 
165 
166     CurrentCostInterface currentCost;
167     ERC20 token;
168 
169     address public arbiterAddress;
170     address public dispatchAddress;
171 
172     // For restricting dot escrow/transfer method calls to Dispatch and Arbiter
173     modifier operatorOnly() {
174         require(msg.sender == arbiterAddress || msg.sender == dispatchAddress, "Error: Operator Only Error");
175         _;
176     }
177 
178     /// @dev Initialize Storage, Token, anc CurrentCost Contracts
179     constructor(address c) Upgradable(c) public {
180         _updateDependencies();
181     }
182 
183     function _updateDependencies() internal {
184         address databaseAddress = coordinator.getContract("DATABASE");
185         db = DatabaseInterface(databaseAddress);
186         arbiterAddress = coordinator.getContract("ARBITER");
187         dispatchAddress = coordinator.getContract("DISPATCH");
188         token = ERC20(coordinator.getContract("ZAP_TOKEN")); 
189         currentCost = CurrentCostInterface(coordinator.getContract("CURRENT_COST")); 
190     }
191 
192     /// @dev will bond to an oracle
193     /// @return total ZAP bound to oracle
194     function bond(address oracleAddress, bytes32 endpoint, uint256 numDots) external returns (uint256 bound) {
195         bound = _bond(msg.sender, oracleAddress, endpoint, numDots);
196         emit Bound(msg.sender, oracleAddress, endpoint, bound, numDots);
197     }
198 
199     /// @return total ZAP unbound from oracle
200     function unbond(address oracleAddress, bytes32 endpoint, uint256 numDots) external returns (uint256 unbound) {
201         unbound = _unbond(msg.sender, oracleAddress, endpoint, numDots);
202         emit Unbound(msg.sender, oracleAddress, endpoint, numDots);
203     }        
204 
205     /// @dev will bond to an oracle on behalf of some holder
206     /// @return total ZAP bound to oracle
207     function delegateBond(address holderAddress, address oracleAddress, bytes32 endpoint, uint256 numDots) external returns (uint256 boundZap) {
208         boundZap = _bond(holderAddress, oracleAddress, endpoint, numDots);
209         emit Bound(holderAddress, oracleAddress, endpoint, boundZap, numDots);
210     }
211 
212     /// @dev Move numDots dots from provider-requester to bondage according to 
213     /// data-provider address, holder address, and endpoint specifier (ala 'smart_contract')
214     /// Called only by Dispatch or Arbiter Contracts
215     function escrowDots(        
216         address holderAddress,
217         address oracleAddress,
218         bytes32 endpoint,
219         uint256 numDots
220     )
221         external
222         operatorOnly        
223         returns (bool success)
224     {
225         uint256 boundDots = getBoundDots(holderAddress, oracleAddress, endpoint);
226         require(numDots <= boundDots, "Error: Not enough dots bound");
227         updateEscrow(holderAddress, oracleAddress, endpoint, numDots, "add");
228         updateBondValue(holderAddress, oracleAddress, endpoint, numDots, "sub");
229         emit Escrowed(holderAddress, oracleAddress, endpoint, numDots);
230         return true;
231     }
232 
233     /// @dev Transfer N dots from fromAddress to destAddress. 
234     /// Called only by Disptach or Arbiter Contracts
235     /// In smart contract endpoint, occurs per satisfied request. 
236     /// In socket endpoint called on termination of subscription.
237     function releaseDots(
238         address holderAddress,
239         address oracleAddress,
240         bytes32 endpoint,
241         uint256 numDots
242     )
243         external
244         operatorOnly 
245         returns (bool success)
246     {
247         uint256 numEscrowed = getNumEscrow(holderAddress, oracleAddress, endpoint);
248         require(numDots <= numEscrowed, "Error: Not enough dots Escrowed");
249         updateEscrow(holderAddress, oracleAddress, endpoint, numDots, "sub");
250         updateBondValue(oracleAddress, oracleAddress, endpoint, numDots, "add");
251         emit Released(holderAddress, oracleAddress, endpoint, numDots);
252         return true;
253     }
254 
255     /// @dev Transfer N dots from destAddress to fromAddress. 
256     /// Called only by Disptach or Arbiter Contracts
257     /// In smart contract endpoint, occurs per satisfied request. 
258     /// In socket endpoint called on termination of subscription.
259     function returnDots(
260         address holderAddress,
261         address oracleAddress,
262         bytes32 endpoint,
263         uint256 numDots
264     )
265         external
266         operatorOnly 
267         returns (bool success)
268     {
269         uint256 numEscrowed = getNumEscrow(holderAddress, oracleAddress, endpoint);
270         require(numDots <= numEscrowed, "Error: Not enough dots escrowed");
271         updateEscrow(holderAddress, oracleAddress, endpoint, numDots, "sub");
272         updateBondValue(holderAddress, oracleAddress, endpoint, numDots, "add");
273         emit Returned(holderAddress, oracleAddress, endpoint, numDots);
274         return true;
275     }
276 
277 
278     /// @dev Calculate quantity of tokens required for specified amount of dots
279     /// for endpoint defined by endpoint and data provider defined by oracleAddress
280     function calcZapForDots(
281         address oracleAddress,
282         bytes32 endpoint,
283         uint256 numDots       
284     ) 
285         external
286         view
287         returns (uint256 numZap)
288     {
289         uint256 issued = getDotsIssued(oracleAddress, endpoint);
290         return currentCost._costOfNDots(oracleAddress, endpoint, issued + 1, numDots - 1);
291     }
292 
293     /// @dev Get the current cost of a dot.
294     /// @param endpoint specifier
295     /// @param oracleAddress data-provider
296     /// @param totalBound current number of dots
297     function currentCostOfDot(
298         address oracleAddress,
299         bytes32 endpoint,
300         uint256 totalBound
301     )
302         public
303         view
304         returns (uint256 cost)
305     {
306         return currentCost._currentCostOfDot(oracleAddress, endpoint, totalBound);
307     }
308 
309     /// @dev Get issuance limit of dots 
310     /// @param endpoint specifier
311     /// @param oracleAddress data-provider
312     function dotLimit(
313         address oracleAddress,
314         bytes32 endpoint
315     )
316         public
317         view
318         returns (uint256 limit)
319     {
320         return currentCost._dotLimit(oracleAddress, endpoint);
321     }
322 
323 
324     /// @return total ZAP held by contract
325     function getZapBound(address oracleAddress, bytes32 endpoint) public view returns (uint256) {
326         return getNumZap(oracleAddress, endpoint);
327     }
328 
329     function _bond(
330         address holderAddress,
331         address oracleAddress,
332         bytes32 endpoint,
333         uint256 numDots        
334     )
335         private
336         returns (uint256) 
337     {   
338 
339         address broker = getEndpointBroker(oracleAddress, endpoint);
340 
341         if( broker != address(0)){
342             require(msg.sender == broker, "Error: Only the broker has access to this function");
343         }
344 
345         // This also checks if oracle is registered w/an initialized curve
346         uint256 issued = getDotsIssued(oracleAddress, endpoint);
347         require(issued + numDots <= dotLimit(oracleAddress, endpoint), "Error: Dot limit exceeded");
348         
349         uint256 numZap = currentCost._costOfNDots(oracleAddress, endpoint, issued + 1, numDots - 1);
350 
351         // User must have approved contract to transfer working ZAP
352         require(token.transferFrom(msg.sender, this, numZap), "Error: User must have approved contract to transfer ZAP");
353 
354         if (!isProviderInitialized(holderAddress, oracleAddress)) {            
355             setProviderInitialized(holderAddress, oracleAddress);
356             addHolderOracle(holderAddress, oracleAddress);
357         }
358 
359         updateBondValue(holderAddress, oracleAddress, endpoint, numDots, "add");        
360         updateTotalIssued(oracleAddress, endpoint, numDots, "add");
361         updateTotalBound(oracleAddress, endpoint, numZap, "add");
362 
363         return numZap;
364     }
365 
366     function _unbond(        
367         address holderAddress,
368         address oracleAddress,
369         bytes32 endpoint,
370         uint256 numDots
371     )
372         private
373         returns (uint256 numZap)
374     {
375         address broker = getEndpointBroker(oracleAddress, endpoint);
376 
377         if( broker != address(0)){
378             require(msg.sender == broker, "Error: Only the broker has access to this function");
379         }
380 
381         // Make sure the user has enough to bond with some additional sanity checks
382         uint256 amountBound = getBoundDots(holderAddress, oracleAddress, endpoint);
383         require(amountBound >= numDots, "Error: Not enough dots bonded");
384         require(numDots > 0, "Error: Dots to unbond must be more than zero");
385 
386         // Get the value of the dots
387         uint256 issued = getDotsIssued(oracleAddress, endpoint);
388         numZap = currentCost._costOfNDots(oracleAddress, endpoint, issued + 1 - numDots, numDots - 1);
389 
390         // Update the storage values
391         updateTotalBound(oracleAddress, endpoint, numZap, "sub");
392         updateTotalIssued(oracleAddress, endpoint, numDots, "sub");
393         updateBondValue(holderAddress, oracleAddress, endpoint, numDots, "sub");
394 
395         // Do the transfer
396         require(token.transfer(msg.sender, numZap), "Error: Transfer failed");
397 
398         return numZap;
399     }
400 
401     /**** Get Methods ****/
402     function isProviderInitialized(address holderAddress, address oracleAddress) public view returns (bool) {
403         return db.getNumber(keccak256(abi.encodePacked('holders', holderAddress, 'initialized', oracleAddress))) == 1 ? true : false;
404     }
405 
406     /// @dev get broker address for endpoint
407     function getEndpointBroker(address oracleAddress, bytes32 endpoint) public view returns (address) {
408         return address(db.getBytes32(keccak256(abi.encodePacked('oracles', oracleAddress, endpoint, 'broker'))));
409     }
410 
411     function getNumEscrow(address holderAddress, address oracleAddress, bytes32 endpoint) public view returns (uint256) {
412         return db.getNumber(keccak256(abi.encodePacked('escrow', holderAddress, oracleAddress, endpoint)));
413     }
414 
415     function getNumZap(address oracleAddress, bytes32 endpoint) public view returns (uint256) {
416         return db.getNumber(keccak256(abi.encodePacked('totalBound', oracleAddress, endpoint)));
417     }
418 
419     function getDotsIssued(address oracleAddress, bytes32 endpoint) public view returns (uint256) {
420         return db.getNumber(keccak256(abi.encodePacked('totalIssued', oracleAddress, endpoint)));
421     }
422 
423     function getBoundDots(address holderAddress, address oracleAddress, bytes32 endpoint) public view returns (uint256) {
424         return db.getNumber(keccak256(abi.encodePacked('holders', holderAddress, 'bonds', oracleAddress, endpoint)));
425     }
426 
427     function getIndexSize(address holderAddress) external view returns (uint256) {
428         return db.getAddressArrayLength(keccak256(abi.encodePacked('holders', holderAddress, 'oracleList')));
429     }
430 
431     function getOracleAddress(address holderAddress, uint256 index) public view returns (address) {
432         return db.getAddressArrayIndex(keccak256(abi.encodePacked('holders', holderAddress, 'oracleList')), index);
433     }
434 
435     /**** Set Methods ****/
436     function addHolderOracle(address holderAddress, address oracleAddress) internal {
437         db.pushAddressArray(keccak256(abi.encodePacked('holders', holderAddress, 'oracleList')), oracleAddress);
438     }
439 
440     function setProviderInitialized(address holderAddress, address oracleAddress) internal {
441         db.setNumber(keccak256(abi.encodePacked('holders', holderAddress, 'initialized', oracleAddress)), 1);
442     }
443 
444     function updateEscrow(address holderAddress, address oracleAddress, bytes32 endpoint, uint256 numDots, bytes32 op) internal {
445         uint256 newEscrow = db.getNumber(keccak256(abi.encodePacked('escrow', holderAddress, oracleAddress, endpoint)));
446 
447         if ( op == "sub" ) {
448             newEscrow -= numDots;
449         } else if ( op == "add" ) {
450             newEscrow += numDots;
451         }
452         else {
453             revert();
454         }
455 
456         db.setNumber(keccak256(abi.encodePacked('escrow', holderAddress, oracleAddress, endpoint)), newEscrow);
457     }
458 
459     function updateBondValue(address holderAddress, address oracleAddress, bytes32 endpoint, uint256 numDots, bytes32 op) internal {
460         uint256 bondValue = db.getNumber(keccak256(abi.encodePacked('holders', holderAddress, 'bonds', oracleAddress, endpoint)));
461         
462         if (op == "sub") {
463             bondValue -= numDots;
464         } else if (op == "add") {
465             bondValue += numDots;
466         }
467 
468         db.setNumber(keccak256(abi.encodePacked('holders', holderAddress, 'bonds', oracleAddress, endpoint)), bondValue);
469     }
470 
471     function updateTotalBound(address oracleAddress, bytes32 endpoint, uint256 numZap, bytes32 op) internal {
472         uint256 totalBound = db.getNumber(keccak256(abi.encodePacked('totalBound', oracleAddress, endpoint)));
473         
474         if (op == "sub"){
475             totalBound -= numZap;
476         } else if (op == "add") {
477             totalBound += numZap;
478         }
479         else {
480             revert();
481         }
482         
483         db.setNumber(keccak256(abi.encodePacked('totalBound', oracleAddress, endpoint)), totalBound);
484     }
485 
486     function updateTotalIssued(address oracleAddress, bytes32 endpoint, uint256 numDots, bytes32 op) internal {
487         uint256 totalIssued = db.getNumber(keccak256(abi.encodePacked('totalIssued', oracleAddress, endpoint)));
488         
489         if (op == "sub"){
490             totalIssued -= numDots;
491         } else if (op == "add") {
492             totalIssued += numDots;
493         }
494         else {
495             revert();
496         }
497     
498         db.setNumber(keccak256(abi.encodePacked('totalIssued', oracleAddress, endpoint)), totalIssued);
499     }
500 }
501 
502     /*************************************** STORAGE ****************************************
503     * 'holders', holderAddress, 'initialized', oracleAddress => {uint256} 1 -> provider-subscriber initialized, 0 -> not initialized 
504     * 'holders', holderAddress, 'bonds', oracleAddress, endpoint => {uint256} number of dots this address has bound to this endpoint
505     * 'oracles', oracleAddress, endpoint, 'broker' => {address} address of endpoint broker, 0 if none
506     * 'escrow', holderAddress, oracleAddress, endpoint => {uint256} amount of Zap that have been escrowed
507     * 'totalBound', oracleAddress, endpoint => {uint256} amount of Zap bound to this endpoint
508     * 'totalIssued', oracleAddress, endpoint => {uint256} number of dots issued by this endpoint
509     * 'holders', holderAddress, 'oracleList' => {address[]} array of oracle addresses associated with this holder
510     ****************************************************************************************/