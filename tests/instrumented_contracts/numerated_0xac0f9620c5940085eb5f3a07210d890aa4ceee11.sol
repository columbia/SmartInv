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
71 // File: contracts/lib/platform/Client.sol
72 
73 contract Client1 {
74     /// @dev callback that provider will call after Dispatch.query() call
75     /// @param id request id
76     /// @param response1 first provider-specified param
77     function callback(uint256 id, string response1) external;
78 }
79 contract Client2 {
80     /// @dev callback that provider will call after Dispatch.query() call
81     /// @param id request id
82     /// @param response1 first provider-specified param
83     /// @param response2 second provider-specified param
84     function callback(uint256 id, string response1, string response2) external;
85 }
86 contract Client3 {
87     /// @dev callback that provider will call after Dispatch.query() call
88     /// @param id request id
89     /// @param response1 first provider-specified param
90     /// @param response2 second provider-specified param
91     /// @param response3 third provider-specified param
92     function callback(uint256 id, string response1, string response2, string response3) external;
93 }
94 contract Client4 {
95     /// @dev callback that provider will call after Dispatch.query() call
96     /// @param id request id
97     /// @param response1 first provider-specified param
98     /// @param response2 second provider-specified param
99     /// @param response3 third provider-specified param
100     /// @param response4 fourth provider-specified param
101     function callback(uint256 id, string response1, string response2, string response3, string response4) external;
102 }
103 
104 contract ClientBytes32Array {
105     /// @dev callback that provider will call after Dispatch.query() call
106     /// @param id request id
107     /// @param response bytes32 array
108     function callback(uint256 id, bytes32[] response) external;
109 }
110 
111 contract ClientIntArray{
112     /// @dev callback that provider will call after Dispatch.query() call
113     /// @param id request id
114     /// @param response int array
115     function callback(uint256 id, int[] response) external;
116 }
117 
118 // File: contracts/lib/platform/OnChainProvider.sol
119 
120 contract OnChainProvider {
121     /// @dev function for requesting data from on-chain provider
122     /// @param id request id
123     /// @param userQuery query string
124     /// @param endpoint endpoint specifier ala 'smart_contract'
125     /// @param endpointParams endpoint-specific params
126     function receive(uint256 id, string userQuery, bytes32 endpoint, bytes32[] endpointParams, bool onchainSubscriber) external;
127 }
128 
129 // File: contracts/platform/bondage/BondageInterface.sol
130 
131 contract BondageInterface {
132     function bond(address, bytes32, uint256) external returns(uint256);
133     function unbond(address, bytes32, uint256) external returns (uint256);
134     function delegateBond(address, address, bytes32, uint256) external returns(uint256);
135     function escrowDots(address, address, bytes32, uint256) external returns (bool);
136     function releaseDots(address, address, bytes32, uint256) external returns (bool);
137     function returnDots(address, address, bytes32, uint256) external returns (bool success);
138     function calcZapForDots(address, bytes32, uint256) external view returns (uint256);
139     function currentCostOfDot(address, bytes32, uint256) public view returns (uint256);
140     function getDotsIssued(address, bytes32) public view returns (uint256);
141     function getBoundDots(address, address, bytes32) public view returns (uint256);
142     function getZapBound(address, bytes32) public view returns (uint256);
143     function dotLimit( address, bytes32) public view returns (uint256);
144 }
145 
146 // File: contracts/platform/dispatch/DispatchInterface.sol
147 
148 interface DispatchInterface {
149     function query(address, string, bytes32, bytes32[]) external returns (uint256);
150     function respond1(uint256, string) external returns (bool);
151     function respond2(uint256, string, string) external returns (bool);
152     function respond3(uint256, string, string, string) external returns (bool);
153     function respond4(uint256, string, string, string, string) external returns (bool);
154     function respondBytes32Array(uint256, bytes32[]) external returns (bool);
155     function respondIntArray(uint256,int[] ) external returns (bool);
156     function cancelQuery(uint256) external;
157     function getProvider(uint256 id) public view returns (address);
158     function getSubscriber(uint256 id) public view returns (address);
159     function getEndpoint(uint256 id) public view returns (bytes32);
160     function getStatus(uint256 id) public view returns (uint256);
161     function getCancel(uint256 id) public view returns (uint256);
162     function getUserQuery(uint256 id) public view returns (string);
163     function getSubscriberOnchain(uint256 id) public view returns (bool);
164 }
165 
166 // File: contracts/platform/database/DatabaseInterface.sol
167 
168 contract DatabaseInterface is Ownable {
169 	function setStorageContract(address _storageContract, bool _allowed) public;
170 	/*** Bytes32 ***/
171 	function getBytes32(bytes32 key) external view returns(bytes32);
172 	function setBytes32(bytes32 key, bytes32 value) external;
173 	/*** Number **/
174 	function getNumber(bytes32 key) external view returns(uint256);
175 	function setNumber(bytes32 key, uint256 value) external;
176 	/*** Bytes ***/
177 	function getBytes(bytes32 key) external view returns(bytes);
178 	function setBytes(bytes32 key, bytes value) external;
179 	/*** String ***/
180 	function getString(bytes32 key) external view returns(string);
181 	function setString(bytes32 key, string value) external;
182 	/*** Bytes Array ***/
183 	function getBytesArray(bytes32 key) external view returns (bytes32[]);
184 	function getBytesArrayIndex(bytes32 key, uint256 index) external view returns (bytes32);
185 	function getBytesArrayLength(bytes32 key) external view returns (uint256);
186 	function pushBytesArray(bytes32 key, bytes32 value) external;
187 	function setBytesArrayIndex(bytes32 key, uint256 index, bytes32 value) external;
188 	function setBytesArray(bytes32 key, bytes32[] value) external;
189 	/*** Int Array ***/
190 	function getIntArray(bytes32 key) external view returns (int[]);
191 	function getIntArrayIndex(bytes32 key, uint256 index) external view returns (int);
192 	function getIntArrayLength(bytes32 key) external view returns (uint256);
193 	function pushIntArray(bytes32 key, int value) external;
194 	function setIntArrayIndex(bytes32 key, uint256 index, int value) external;
195 	function setIntArray(bytes32 key, int[] value) external;
196 	/*** Address Array ***/
197 	function getAddressArray(bytes32 key) external view returns (address[]);
198 	function getAddressArrayIndex(bytes32 key, uint256 index) external view returns (address);
199 	function getAddressArrayLength(bytes32 key) external view returns (uint256);
200 	function pushAddressArray(bytes32 key, address value) external;
201 	function setAddressArrayIndex(bytes32 key, uint256 index, address value) external;
202 	function setAddressArray(bytes32 key, address[] value) external;
203 }
204 
205 // File: contracts/platform/dispatch/Dispatch.sol
206 
207 // v1.0
208 
209 
210 
211 
212 
213 
214 
215 
216 contract Dispatch is Destructible, DispatchInterface, Upgradable { 
217 
218     enum Status { Pending, Fulfilled, Canceled }
219 
220     //event data provider is listening for, containing all relevant request parameters
221     event Incoming(
222         uint256 indexed id,
223         address indexed provider,
224         address indexed subscriber,
225         string query,
226         bytes32 endpoint,
227         bytes32[] endpointParams,
228         bool onchainSubscriber
229     );
230 
231     event FulfillQuery(
232         address indexed subscriber,
233         address indexed provider,
234         bytes32 indexed endpoint
235     );
236 
237     event OffchainResponse(
238         uint256 indexed id,
239         address indexed subscriber,
240         address indexed provider,
241         bytes32[] response
242     );
243 
244     event OffchainResponseInt(
245         uint256 indexed id,
246         address indexed subscriber,
247         address indexed provider,
248         int[] response
249     );
250 
251     event OffchainResult1(
252         uint256 indexed id,
253         address indexed subscriber,
254         address indexed provider,
255         string response1
256     );
257 
258     event OffchainResult2(
259         uint256 indexed id,
260         address indexed subscriber,
261         address indexed provider,
262         string response1,
263         string response2
264     );
265 
266     event OffchainResult3(
267         uint256 indexed id,
268         address indexed subscriber,
269         address indexed provider,
270         string response1,
271         string response2,
272         string response3
273     );
274 
275     event OffchainResult4(
276         uint256 indexed id,
277         address indexed subscriber,
278         address indexed provider,
279         string response1,
280         string response2,
281         string response3,
282         string response4
283     );
284 
285     event CanceledRequest(
286         uint256 indexed id,
287         address indexed subscriber,
288         address indexed provider
289     );
290 
291     event RevertCancelation(
292         uint256 indexed id,
293         address indexed subscriber,
294         address indexed provider
295     );
296 
297     BondageInterface public bondage;
298     address public bondageAddress;
299 
300     DatabaseInterface public db;
301 
302     constructor(address c) Upgradable(c) public {
303         //_updateDependencies();
304     }
305 
306     function _updateDependencies() internal {
307         address databaseAddress = coordinator.getContract("DATABASE");
308         db = DatabaseInterface(databaseAddress);
309 
310         bondageAddress = coordinator.getContract("BONDAGE");
311         bondage = BondageInterface(bondageAddress);
312     }
313 
314     /// @notice Escrow dot for oracle request
315     /// @dev Called by user contract
316     function query(
317         address provider,           // data provider address
318         string userQuery,           // query string
319         bytes32 endpoint,           // endpoint specifier ala 'smart_contract'
320         bytes32[] endpointParams   // endpoint-specific params
321         )
322         external
323         returns (uint256 id)
324     {
325         uint256 dots = bondage.getBoundDots(msg.sender, provider, endpoint);
326         bool onchainProvider = isContract(provider);
327         bool onchainSubscriber = isContract(msg.sender);
328         if(dots >= 1) {
329             //enough dots
330             bondage.escrowDots(msg.sender, provider, endpoint, 1);
331 
332             id = uint256(keccak256(abi.encodePacked(block.number, now, userQuery, msg.sender, provider)));
333 
334             createQuery(id, provider, msg.sender, endpoint, userQuery, onchainSubscriber);
335             if(onchainProvider) {
336                 OnChainProvider(provider).receive(id, userQuery, endpoint, endpointParams, onchainSubscriber); 
337             } else{
338                 emit Incoming(id, provider, msg.sender, userQuery, endpoint, endpointParams, onchainSubscriber);
339             }
340         } else { // NOT ENOUGH DOTS
341             revert("Subscriber does not have any dots.");
342         }
343     }
344 
345     /// @notice Transfer dots from Bondage escrow to data provider's Holder object under its own address
346     /// @dev Called upon data-provider request fulfillment
347     function fulfillQuery(uint256 id) private returns (bool) {
348         Status status = Status(getStatus(id));
349 
350         require(status != Status.Fulfilled, "Error: Status already fulfilled");
351 
352         address subscriber = getSubscriber(id);
353         address provider = getProvider(id);
354         bytes32 endpoint = getEndpoint(id);
355         
356         if ( status == Status.Canceled ) {
357             uint256 canceled = getCancel(id);
358 
359             // Make sure we've canceled in the past,
360             // if it's current block ignore the cancel
361             require(block.number == canceled, "Error: Cancel ignored");
362 
363             // Uncancel the query
364             setCanceled(id, false);
365 
366             // Re-escrow the previously returned dots
367             bondage.escrowDots(subscriber, provider, endpoint, 1);
368 
369             // Emit the events
370             emit RevertCancelation(id, subscriber, provider);
371         }
372 
373         setFulfilled(id);
374 
375         bondage.releaseDots(subscriber, provider, endpoint, 1);
376 
377         emit FulfillQuery(subscriber, provider, endpoint);
378 
379         return true;
380     }
381 
382     /// @notice Cancel a query.
383     /// @dev If responded on the same block, ignore the cancel.
384     function cancelQuery(uint256 id) external {
385         address subscriber = getSubscriber(id);
386         address provider = getProvider(id);
387         bytes32 endpoint = getEndpoint(id);
388 
389         require(subscriber == msg.sender, "Error: Wrong subscriber");
390         require(Status(getStatus(id)) == Status.Pending, "Error: Query is not pending");
391 
392         // Cancel the query
393         setCanceled(id, true);
394 
395         // Return the dots to the subscriber
396         bondage.returnDots(subscriber, provider, endpoint, 1);
397 
398         // Release an event
399         emit CanceledRequest(id, getSubscriber(id), getProvider(id));
400     }
401 
402     /// @dev Parameter-count specific method called by data provider in response
403     function respondBytes32Array(
404         uint256 id,
405         bytes32[] response
406     )
407         external
408         returns (bool)
409     {
410         if (getProvider(id) != msg.sender || !fulfillQuery(id))
411             revert();
412         if(getSubscriberOnchain(id)) {
413             ClientBytes32Array(getSubscriber(id)).callback(id, response);
414         }
415         else {
416             emit OffchainResponse(id, getSubscriber(id), msg.sender, response);
417         }
418         return true;
419     }
420 
421     /// @dev Parameter-count specific method called by data provider in response
422     function respondIntArray(
423         uint256 id,
424         int[] response
425     )
426         external
427         returns (bool)
428     {
429         if (getProvider(id) != msg.sender || !fulfillQuery(id))
430             revert();
431         if(getSubscriberOnchain(id)) {
432             ClientIntArray(getSubscriber(id)).callback(id, response);
433         }
434         else {
435             emit OffchainResponseInt(id, getSubscriber(id), msg.sender, response);
436         }
437         return true;
438     }
439 
440 
441     /// @dev Parameter-count specific method called by data provider in response
442     function respond1(
443         uint256 id,
444         string response
445     )
446         external
447         returns (bool)
448     {
449         if (getProvider(id) != msg.sender || !fulfillQuery(id))
450             revert();
451 
452         if(getSubscriberOnchain(id)) {
453             Client1(getSubscriber(id)).callback(id, response);
454         }
455         else {
456             emit OffchainResult1(id, getSubscriber(id), msg.sender, response);
457         }
458         return true;
459     }
460 
461     /// @dev Parameter-count specific method called by data provider in response
462     function respond2(
463         uint256 id,
464         string response1,
465         string response2
466     )
467         external
468         returns (bool)
469     {
470         if (getProvider(id) != msg.sender || !fulfillQuery(id))
471             revert();
472 
473         if(getSubscriberOnchain(id)) {
474             Client2(getSubscriber(id)).callback(id, response1, response2);
475         }
476         else {
477             emit OffchainResult2(id, getSubscriber(id), msg.sender, response1, response2);
478         }
479 
480         return true;
481     }
482 
483     /// @dev Parameter-count specific method called by data provider in response
484     function respond3(
485         uint256 id,
486         string response1,
487         string response2,
488         string response3
489     )
490         external
491         returns (bool)
492     {
493         if (getProvider(id) != msg.sender || !fulfillQuery(id))
494             revert();
495 
496         if(getSubscriberOnchain(id)) {
497             Client3(getSubscriber(id)).callback(id, response1, response2, response3);
498         }
499         else {
500             emit OffchainResult3(id, getSubscriber(id), msg.sender, response1, response2, response3);
501         }
502 
503         return true;
504     }
505 
506     /// @dev Parameter-count specific method called by data provider in response
507     function respond4(
508         uint256 id,
509         string response1,
510         string response2,
511         string response3,
512         string response4
513     )
514         external
515         returns (bool)
516     {
517         if (getProvider(id) != msg.sender || !fulfillQuery(id))
518             revert();
519 
520         if(getSubscriberOnchain(id)) {
521             Client4(getSubscriber(id)).callback(id, response1, response2, response3, response4);
522         }
523         else {
524             emit OffchainResult4(id, getSubscriber(id), msg.sender, response1, response2, response3, response4);
525         }
526 
527         return true;
528     }
529 
530     /*** STORAGE METHODS ***/
531 
532     /// @dev get provider address of request
533     /// @param id request id
534     function getProvider(uint256 id) public view returns (address) {
535         return address(db.getNumber(keccak256(abi.encodePacked('queries', id, 'provider'))));
536     }
537 
538     /// @dev get subscriber address of request
539     /// @param id request id
540     function getSubscriber(uint256 id) public view returns (address) {
541         return address(db.getNumber(keccak256(abi.encodePacked('queries', id, 'subscriber'))));
542     }
543 
544     /// @dev get endpoint of request
545     /// @param id request id
546     function getEndpoint(uint256 id) public view returns (bytes32) {
547         return db.getBytes32(keccak256(abi.encodePacked('queries', id, 'endpoint')));
548     }
549 
550     /// @dev get status of request
551     /// @param id request id
552     function getStatus(uint256 id) public view returns (uint256) {
553         return db.getNumber(keccak256(abi.encodePacked('queries', id, 'status')));
554     }
555 
556     /// @dev get the cancelation block of a request
557     /// @param id request id
558     function getCancel(uint256 id) public view returns (uint256) {
559         return db.getNumber(keccak256(abi.encodePacked('queries', id, 'cancelBlock')));
560     }
561 
562     /// @dev get user specified query of request
563     /// @param id request id
564     function getUserQuery(uint256 id) public view returns (string) {
565         return db.getString(keccak256(abi.encodePacked('queries', id, 'userQuery')));
566     }
567 
568     /// @dev is subscriber contract or offchain 
569     /// @param id request id
570     function getSubscriberOnchain(uint256 id) public view returns (bool) {
571         uint res = db.getNumber(keccak256(abi.encodePacked('queries', id, 'onchainSubscriber')));
572         return res == 1 ? true : false;
573     }
574  
575     /**** Set Methods ****/
576     function createQuery(
577         uint256 id,
578         address provider,
579         address subscriber,
580         bytes32 endpoint,
581         string userQuery,
582         bool onchainSubscriber
583     ) 
584         private
585     {
586         db.setNumber(keccak256(abi.encodePacked('queries', id, 'provider')), uint256(provider));
587         db.setNumber(keccak256(abi.encodePacked('queries', id, 'subscriber')), uint256(subscriber));
588         db.setBytes32(keccak256(abi.encodePacked('queries', id, 'endpoint')), endpoint);
589         db.setString(keccak256(abi.encodePacked('queries', id, 'userQuery')), userQuery);
590         db.setNumber(keccak256(abi.encodePacked('queries', id, 'status')), uint256(Status.Pending));
591         db.setNumber(keccak256(abi.encodePacked('queries', id, 'onchainSubscriber')), onchainSubscriber ? 1 : 0);
592     }
593 
594     function setFulfilled(uint256 id) private {
595         db.setNumber(keccak256(abi.encodePacked('queries', id, 'status')), uint256(Status.Fulfilled));
596     }
597 
598     function setCanceled(uint256 id, bool canceled) private {
599         if ( canceled ) {
600             db.setNumber(keccak256(abi.encodePacked('queries', id, 'cancelBlock')), block.number);
601             db.setNumber(keccak256(abi.encodePacked('queries', id, 'status')), uint256(Status.Canceled));
602         }
603         else {
604             db.setNumber(keccak256(abi.encodePacked('queries', id, 'cancelBlock')), 0);
605             db.setNumber(keccak256(abi.encodePacked('queries', id, 'status')), uint256(Status.Pending));            
606         }
607     }
608 
609     function isContract(address addr) private view returns (bool) {
610         uint size;
611         assembly { size := extcodesize(addr) }
612         return size > 0;
613     }
614 }
615 
616 /*
617 /* For use in example contract, see TestContracts.sol
618 /*
619 /* When User Contract calls ZapDispatch.query(),
620 /* 1 oracle specific dot is escrowed by ZapBondage and Incoming event is ted.
621 /*
622 /* When provider's client hears an Incoming event containing provider's address and responds,
623 /* the provider calls a ZapDispatch.respondX function corresponding to number of response params.
624 /*
625 /* Dots are moved from ZapBondage escrow to data-provider's bond Holder struct,
626 /* with data provider address set as self's address.
627 /*/ 
628 
629 /*************************************** STORAGE ****************************************
630 * 'queries', id, 'provider' => {address} address of provider that this query was sent to
631 * 'queries', id, 'subscriber' => {address} address of subscriber that this query was sent by
632 * 'queries', id, 'endpoint' => {bytes32} endpoint that this query was sent to
633 * 'queries', id, 'status' => {Status} current status of this query
634 * 'queries', id, 'cancelBlock' => {uint256} the block number of the cancellation request (0 if none)
635 * 'queries', id, 'userQuery' => {uint256} the query that was sent with this queryId
636 * 'queries', id, 'onchainSubscriber' => {uint256} 1 -> onchainSubscriber, 0 -> offchainSubscriber
637 ****************************************************************************************/