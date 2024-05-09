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
27 // File: contracts/lib/ownership/ZapCoordinatorInterface.sol
28 
29 contract ZapCoordinatorInterface is Ownable {
30 	function addImmutableContract(string contractName, address newAddress) external;
31 	function updateContract(string contractName, address newAddress) external;
32 	function getContractName(uint index) public view returns (string);
33 	function getContract(string contractName) public view returns (address);
34 	function updateAllDependencies() external;
35 }
36 
37 // File: contracts/lib/ownership/Upgradable.sol
38 
39 pragma solidity ^0.4.24;
40 
41 contract Upgradable {
42 
43 	address coordinatorAddr;
44 	ZapCoordinatorInterface coordinator;
45 
46 	constructor(address c) public{
47 		coordinatorAddr = c;
48 		coordinator = ZapCoordinatorInterface(c);
49 	}
50 
51     function updateDependencies() external coordinatorOnly {
52        _updateDependencies();
53     }
54 
55     function _updateDependencies() internal;
56 
57     modifier coordinatorOnly() {
58     	require(msg.sender == coordinatorAddr, "Error: Coordinator Only Function");
59     	_;
60     }
61 }
62 
63 // File: contracts/lib/lifecycle/Destructible.sol
64 
65 contract Destructible is Ownable {
66 	function selfDestruct() public onlyOwner {
67 		selfdestruct(owner);
68 	}
69 }
70 
71 // File: contracts/platform/bondage/BondageInterface.sol
72 
73 contract BondageInterface {
74     function bond(address, bytes32, uint256) external returns(uint256);
75     function unbond(address, bytes32, uint256) external returns (uint256);
76     function delegateBond(address, address, bytes32, uint256) external returns(uint256);
77     function escrowDots(address, address, bytes32, uint256) external returns (bool);
78     function releaseDots(address, address, bytes32, uint256) external returns (bool);
79     function returnDots(address, address, bytes32, uint256) external returns (bool success);
80     function calcZapForDots(address, bytes32, uint256) external view returns (uint256);
81     function currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
82     function getDotsIssued(address, bytes32) public view returns (uint256);
83     function getBoundDots(address, address, bytes32) public view returns (uint256);
84     function getZapBound(address, bytes32) public view returns (uint256);
85     function dotLimit( address, bytes32) public view returns (uint256);
86 }
87 
88 // File: contracts/platform/arbiter/ArbiterInterface.sol
89 
90 contract ArbiterInterface {
91     function initiateSubscription(address, bytes32, bytes32[], uint256, uint64) public;
92     function getSubscription(address, address, bytes32) public view returns (uint64, uint96, uint96);
93     function endSubscriptionProvider(address, bytes32) public;
94     function endSubscriptionSubscriber(address, bytes32) public;
95     function passParams(address receiver, bytes32 endpoint, bytes32[] params) public;
96 }
97 
98 // File: contracts/platform/database/DatabaseInterface.sol
99 
100 contract DatabaseInterface is Ownable {
101 	function setStorageContract(address _storageContract, bool _allowed) public;
102 	/*** Bytes32 ***/
103 	function getBytes32(bytes32 key) external view returns(bytes32);
104 	function setBytes32(bytes32 key, bytes32 value) external;
105 	/*** Number **/
106 	function getNumber(bytes32 key) external view returns(uint256);
107 	function setNumber(bytes32 key, uint256 value) external;
108 	/*** Bytes ***/
109 	function getBytes(bytes32 key) external view returns(bytes);
110 	function setBytes(bytes32 key, bytes value) external;
111 	/*** String ***/
112 	function getString(bytes32 key) external view returns(string);
113 	function setString(bytes32 key, string value) external;
114 	/*** Bytes Array ***/
115 	function getBytesArray(bytes32 key) external view returns (bytes32[]);
116 	function getBytesArrayIndex(bytes32 key, uint256 index) external view returns (bytes32);
117 	function getBytesArrayLength(bytes32 key) external view returns (uint256);
118 	function pushBytesArray(bytes32 key, bytes32 value) external;
119 	function setBytesArrayIndex(bytes32 key, uint256 index, bytes32 value) external;
120 	function setBytesArray(bytes32 key, bytes32[] value) external;
121 	/*** Int Array ***/
122 	function getIntArray(bytes32 key) external view returns (int[]);
123 	function getIntArrayIndex(bytes32 key, uint256 index) external view returns (int);
124 	function getIntArrayLength(bytes32 key) external view returns (uint256);
125 	function pushIntArray(bytes32 key, int value) external;
126 	function setIntArrayIndex(bytes32 key, uint256 index, int value) external;
127 	function setIntArray(bytes32 key, int[] value) external;
128 	/*** Address Array ***/
129 	function getAddressArray(bytes32 key) external view returns (address[]);
130 	function getAddressArrayIndex(bytes32 key, uint256 index) external view returns (address);
131 	function getAddressArrayLength(bytes32 key) external view returns (uint256);
132 	function pushAddressArray(bytes32 key, address value) external;
133 	function setAddressArrayIndex(bytes32 key, uint256 index, address value) external;
134 	function setAddressArray(bytes32 key, address[] value) external;
135 }
136 
137 // File: contracts/platform/arbiter/Arbiter.sol
138 
139 // v1.0
140 
141 
142 
143 
144 
145 
146 
147 contract Arbiter is Destructible, ArbiterInterface, Upgradable {
148     // Called when a data purchase is initiated
149     event DataPurchase(
150         address indexed provider,          // Etheruem address of the provider
151         address indexed subscriber,        // Ethereum address of the subscriber
152         uint256 publicKey,                 // Public key of the subscriber
153         uint256 indexed amount,            // Amount (in 1/100 ZAP) of ethereum sent
154         bytes32[] endpointParams,          // Endpoint specific(nonce,encrypted_uuid),
155         bytes32 endpoint                   // Endpoint specifier
156     );
157 
158     // Called when a data subscription is ended by either provider or terminator
159     event DataSubscriptionEnd(
160         address indexed provider,                      // Provider from the subscription
161         address indexed subscriber,                    // Subscriber from the subscription
162         SubscriptionTerminator indexed terminator      // Which terminated the contract
163     ); 
164 
165     // Called when party passes arguments to another party
166     event ParamsPassed(
167         address indexed sender,
168         address indexed receiver,
169         bytes32 endpoint,
170         bytes32[] params
171     );
172 
173     // Used to specify who is the terminator of a contract
174     enum SubscriptionTerminator { Provider, Subscriber }
175 
176     BondageInterface bondage;
177     address public bondageAddress;
178 
179     // database address and reference
180     DatabaseInterface public db;
181 
182     constructor(address c) Upgradable(c) public {
183         _updateDependencies();
184     }
185 
186     function _updateDependencies() internal {
187         bondageAddress = coordinator.getContract("BONDAGE");
188         bondage = BondageInterface(bondageAddress);
189 
190         address databaseAddress = coordinator.getContract("DATABASE");
191         db = DatabaseInterface(databaseAddress);
192     }
193 
194     //@dev broadcast parameters from sender to offchain receiver
195     /// @param receiver address
196     /// @param endpoint Endpoint specifier
197     /// @param params arbitrary params to be passed
198     function passParams(address receiver, bytes32 endpoint, bytes32[] params) public {
199 
200         emit ParamsPassed(msg.sender, receiver, endpoint, params);    
201     }
202 
203     /// @dev subscribe to specified number of blocks of provider
204     /// @param providerAddress Provider address
205     /// @param endpoint Endpoint specifier
206     /// @param endpointParams Endpoint specific params
207     /// @param publicKey Public key of the purchaser
208     /// @param blocks Number of blocks subscribed, 1block=1dot
209     function initiateSubscription(
210         address providerAddress,   //
211         bytes32 endpoint,          //
212         bytes32[] endpointParams,  //
213         uint256 publicKey,         // Public key of the purchaser
214         uint64 blocks              //
215     ) 
216         public 
217     {   
218         // Must be atleast one block
219         require(blocks > 0, "Error: Must be at least one block");
220 
221         // Can't reinitiate a currently active contract
222         require(getDots(providerAddress, msg.sender, endpoint) == 0, "Error: Cannot reinstantiate a currently active contract");
223 
224         // Escrow the necessary amount of dots
225         bondage.escrowDots(msg.sender, providerAddress, endpoint, blocks);
226         
227         // Initiate the subscription struct
228         setSubscription(
229             providerAddress,
230             msg.sender,
231             endpoint,
232             blocks,
233             uint96(block.number),
234             uint96(block.number) + uint96(blocks)
235         );
236 
237         emit DataPurchase(
238             providerAddress,
239             msg.sender,
240             publicKey,
241             blocks,
242             endpointParams,
243             endpoint
244         );
245     }
246 
247     /// @dev get subscription info
248     function getSubscription(address providerAddress, address subscriberAddress, bytes32 endpoint)
249         public
250         view
251         returns (uint64 dots, uint96 blockStart, uint96 preBlockEnd)
252     {
253         return (
254             getDots(providerAddress, subscriberAddress, endpoint),
255             getBlockStart(providerAddress, subscriberAddress, endpoint),
256             getPreBlockEnd(providerAddress, subscriberAddress, endpoint)
257         );
258     }
259 
260     /// @dev Finish the data feed from the provider
261     function endSubscriptionProvider(        
262         address subscriberAddress,
263         bytes32 endpoint
264     )
265         public 
266     {
267         // Emit an event on success about who ended the contract
268         if (endSubscription(msg.sender, subscriberAddress, endpoint))
269             emit DataSubscriptionEnd(
270                 msg.sender, 
271                 subscriberAddress, 
272                 SubscriptionTerminator.Provider
273             );
274     }
275 
276     /// @dev Finish the data feed from the subscriber
277     function endSubscriptionSubscriber(
278         address providerAddress,
279         bytes32 endpoint
280     )
281         public 
282     {
283         // Emit an event on success about who ended the contract
284         if (endSubscription(providerAddress, msg.sender, endpoint))
285             emit DataSubscriptionEnd(
286                 providerAddress,
287                 msg.sender,
288                 SubscriptionTerminator.Subscriber
289             );
290     }
291 
292     /// @dev Finish the data feed
293     function endSubscription(        
294         address providerAddress,
295         address subscriberAddress,
296         bytes32 endpoint
297     )
298         private
299         returns (bool)
300     {   
301         // get the total value/block length of this subscription
302         uint256 dots = getDots(providerAddress, subscriberAddress, endpoint);
303         uint256 preblockend = getPreBlockEnd(providerAddress, subscriberAddress, endpoint);
304         // Make sure the subscriber has a subscription
305         require(dots > 0, "Error: Subscriber must have a subscription");
306 
307         if (block.number < preblockend) {
308             // Subscription ended early
309             uint256 earnedDots = block.number - getBlockStart(providerAddress, subscriberAddress, endpoint);
310             uint256 returnedDots = dots - earnedDots;
311 
312             // Transfer the earned dots to the provider
313             bondage.releaseDots(
314                 subscriberAddress,
315                 providerAddress,
316                 endpoint,
317                 earnedDots
318             );
319             //  Transfer the returned dots to the subscriber
320             bondage.returnDots(
321                 subscriberAddress,
322                 providerAddress,
323                 endpoint,
324                 returnedDots
325             );
326         } else {
327             // Transfer all the dots
328             bondage.releaseDots(
329                 subscriberAddress,
330                 providerAddress,
331                 endpoint,
332                 dots
333             );
334         }
335         // Kill the subscription
336         deleteSubscription(providerAddress, subscriberAddress, endpoint);
337         return true;
338     }    
339 
340 
341     /*** --- *** STORAGE METHODS *** --- ***/
342 
343     /// @dev get subscriber dots remaining for specified provider endpoint
344     function getDots(
345         address providerAddress,
346         address subscriberAddress,
347         bytes32 endpoint
348     )
349         public
350         view
351         returns (uint64)
352     {
353         return uint64(db.getNumber(keccak256(abi.encodePacked('subscriptions', providerAddress, subscriberAddress, endpoint, 'dots'))));
354     }
355 
356     /// @dev get first subscription block number
357     function getBlockStart(
358         address providerAddress,
359         address subscriberAddress,
360         bytes32 endpoint
361     )
362         public
363         view
364         returns (uint96)
365     {
366         return uint96(db.getNumber(keccak256(abi.encodePacked('subscriptions', providerAddress, subscriberAddress, endpoint, 'blockStart'))));
367     }
368 
369     /// @dev get last subscription block number
370     function getPreBlockEnd(
371         address providerAddress,
372         address subscriberAddress,
373         bytes32 endpoint
374     )
375         public
376         view
377         returns (uint96)
378     {
379         return uint96(db.getNumber(keccak256(abi.encodePacked('subscriptions', providerAddress, subscriberAddress, endpoint, 'preBlockEnd'))));
380     }
381 
382     /**** Set Methods ****/
383 
384     /// @dev store new subscription
385     function setSubscription(
386         address providerAddress,
387         address subscriberAddress,
388         bytes32 endpoint,
389         uint64 dots,
390         uint96 blockStart,
391         uint96 preBlockEnd
392     )
393         private
394     {
395         db.setNumber(keccak256(abi.encodePacked('subscriptions', providerAddress, subscriberAddress, endpoint, 'dots')), dots);
396         db.setNumber(keccak256(abi.encodePacked('subscriptions', providerAddress, subscriberAddress, endpoint, 'blockStart')), uint256(blockStart));
397         db.setNumber(keccak256(abi.encodePacked('subscriptions', providerAddress, subscriberAddress, endpoint, 'preBlockEnd')), uint256(preBlockEnd));
398     }
399 
400     /**** Delete Methods ****/
401 
402     /// @dev remove subscription
403     function deleteSubscription(
404         address providerAddress,
405         address subscriberAddress,
406         bytes32 endpoint
407     )
408         private
409     {
410         db.setNumber(keccak256(abi.encodePacked('subscriptions', providerAddress, subscriberAddress, endpoint, 'dots')), 0);
411         db.setNumber(keccak256(abi.encodePacked('subscriptions', providerAddress, subscriberAddress, endpoint, 'blockStart')), uint256(0));
412         db.setNumber(keccak256(abi.encodePacked('subscriptions', providerAddress, subscriberAddress, endpoint, 'preBlockEnd')), uint256(0));
413     }
414 }
415 
416     /*************************************** STORAGE ****************************************
417     * 'holders', holderAddress, 'initialized', oracleAddress => {uint256} 1 -> provider-subscriber initialized, 0 -> not initialized 
418     * 'holders', holderAddress, 'bonds', oracleAddress, endpoint => {uint256} number of dots this address has bound to this endpoint
419     * 'oracles', oracleAddress, endpoint, 'broker' => {address} address of endpoint broker, 0 if none
420     * 'escrow', holderAddress, oracleAddress, endpoint => {uint256} amount of Zap that have been escrowed
421     * 'totalBound', oracleAddress, endpoint => {uint256} amount of Zap bound to this endpoint
422     * 'totalIssued', oracleAddress, endpoint => {uint256} number of dots issued by this endpoint
423     * 'holders', holderAddress, 'oracleList' => {address[]} array of oracle addresses associated with this holder
424     ****************************************************************************************/