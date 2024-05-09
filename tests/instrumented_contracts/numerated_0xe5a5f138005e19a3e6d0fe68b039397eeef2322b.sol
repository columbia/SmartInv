1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
68 
69 /**
70  * @title Claimable
71  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
72  * This allows the new owner to accept the transfer.
73  */
74 contract Claimable is Ownable {
75   address public pendingOwner;
76 
77   /**
78    * @dev Modifier throws if called by any account other than the pendingOwner.
79    */
80   modifier onlyPendingOwner() {
81     require(msg.sender == pendingOwner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to set the pendingOwner address.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     pendingOwner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the pendingOwner address to finalize the transfer.
95    */
96   function claimOwnership() public onlyPendingOwner {
97     emit OwnershipTransferred(owner, pendingOwner);
98     owner = pendingOwner;
99     pendingOwner = address(0);
100   }
101 }
102 
103 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
104 
105 /**
106  * @title ERC20Basic
107  * @dev Simpler version of ERC20 interface
108  * See https://github.com/ethereum/EIPs/issues/179
109  */
110 contract ERC20Basic {
111   function totalSupply() public view returns (uint256);
112   function balanceOf(address _who) public view returns (uint256);
113   function transfer(address _to, uint256 _value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115 }
116 
117 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address _owner, address _spender)
125     public view returns (uint256);
126 
127   function transferFrom(address _from, address _to, uint256 _value)
128     public returns (bool);
129 
130   function approve(address _spender, uint256 _value) public returns (bool);
131   event Approval(
132     address indexed owner,
133     address indexed spender,
134     uint256 value
135   );
136 }
137 
138 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
139 
140 /**
141  * @title SafeERC20
142  * @dev Wrappers around ERC20 operations that throw on failure.
143  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
144  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
145  */
146 library SafeERC20 {
147   function safeTransfer(
148     ERC20Basic _token,
149     address _to,
150     uint256 _value
151   )
152     internal
153   {
154     require(_token.transfer(_to, _value));
155   }
156 
157   function safeTransferFrom(
158     ERC20 _token,
159     address _from,
160     address _to,
161     uint256 _value
162   )
163     internal
164   {
165     require(_token.transferFrom(_from, _to, _value));
166   }
167 
168   function safeApprove(
169     ERC20 _token,
170     address _spender,
171     uint256 _value
172   )
173     internal
174   {
175     require(_token.approve(_spender, _value));
176   }
177 }
178 
179 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
180 
181 /**
182  * @title Contracts that should be able to recover tokens
183  * @author SylTi
184  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
185  * This will prevent any accidental loss of tokens.
186  */
187 contract CanReclaimToken is Ownable {
188   using SafeERC20 for ERC20Basic;
189 
190   /**
191    * @dev Reclaim all ERC20Basic compatible tokens
192    * @param _token ERC20Basic The address of the token contract
193    */
194   function reclaimToken(ERC20Basic _token) external onlyOwner {
195     uint256 balance = _token.balanceOf(this);
196     _token.safeTransfer(owner, balance);
197   }
198 
199 }
200 
201 // File: contracts/utils/OwnableContract.sol
202 
203 // empty block is used as this contract just inherits others.
204 contract OwnableContract is CanReclaimToken, Claimable { } /* solhint-disable-line no-empty-blocks */
205 
206 // File: contracts/controller/ControllerInterface.sol
207 
208 interface ControllerInterface {
209     function mint(address to, uint amount) external returns (bool);
210     function burn(uint value) external returns (bool);
211     function isCustodian(address addr) external view returns (bool);
212     function isMerchant(address addr) external view returns (bool);
213     function getWBTC() external view returns (ERC20);
214 }
215 
216 // File: contracts/factory/Factory.sol
217 
218 contract Factory is OwnableContract {
219 
220     enum RequestStatus {PENDING, CANCELED, APPROVED, REJECTED}
221 
222     struct Request {
223         address requester; // sender of the request.
224         uint amount; // amount of wbtc to mint/burn.
225         string btcDepositAddress; // custodian's btc address in mint, merchant's btc address in burn.
226         string btcTxid; // bitcoin txid for sending/redeeming btc in the mint/burn process.
227         uint nonce; // serial number allocated for each request.
228         uint timestamp; // time of the request creation.
229         RequestStatus status; // status of the request.
230     }
231 
232     ControllerInterface public controller;
233 
234     // mapping between merchant to the corresponding custodian deposit address, used in the minting process.
235     // by using a different deposit address per merchant the custodian can identify which merchant deposited.
236     mapping(address=>string) public custodianBtcDepositAddress;
237 
238     // mapping between merchant to the its deposit address where btc should be moved to, used in the burning process.
239     mapping(address=>string) public merchantBtcDepositAddress;
240 
241     // mapping between a mint request hash and the corresponding request nonce. 
242     mapping(bytes32=>uint) public mintRequestNonce;
243 
244     // mapping between a burn request hash and the corresponding request nonce.
245     mapping(bytes32=>uint) public burnRequestNonce;
246 
247     Request[] public mintRequests;
248     Request[] public burnRequests;
249 
250     constructor(ControllerInterface _controller) public {
251         require(_controller != address(0), "invalid _controller address");
252         controller = _controller;
253         owner = _controller;
254     }
255 
256     modifier onlyMerchant() {
257         require(controller.isMerchant(msg.sender), "sender not a merchant.");
258         _;
259     }
260 
261     modifier onlyCustodian() {
262         require(controller.isCustodian(msg.sender), "sender not a custodian.");
263         _;
264     }
265 
266     event CustodianBtcDepositAddressSet(address indexed merchant, address indexed sender, string btcDepositAddress);
267 
268     function setCustodianBtcDepositAddress(
269         address merchant,
270         string btcDepositAddress
271     )
272         external
273         onlyCustodian
274         returns (bool) 
275     {
276         require(merchant != 0, "invalid merchant address");
277         require(controller.isMerchant(merchant), "merchant address is not a real merchant.");
278         require(!isEmptyString(btcDepositAddress), "invalid btc deposit address");
279 
280         custodianBtcDepositAddress[merchant] = btcDepositAddress;
281         emit CustodianBtcDepositAddressSet(merchant, msg.sender, btcDepositAddress);
282         return true;
283     }
284 
285     event MerchantBtcDepositAddressSet(address indexed merchant, string btcDepositAddress);
286 
287     function setMerchantBtcDepositAddress(string btcDepositAddress) external onlyMerchant returns (bool) {
288         require(!isEmptyString(btcDepositAddress), "invalid btc deposit address");
289 
290         merchantBtcDepositAddress[msg.sender] = btcDepositAddress;
291         emit MerchantBtcDepositAddressSet(msg.sender, btcDepositAddress);
292         return true; 
293     }
294 
295     event MintRequestAdd(
296         uint indexed nonce,
297         address indexed requester,
298         uint amount,
299         string btcDepositAddress,
300         string btcTxid,
301         uint timestamp,
302         bytes32 requestHash
303     );
304 
305     function addMintRequest(
306         uint amount,
307         string btcTxid,
308         string btcDepositAddress
309     )
310         external
311         onlyMerchant
312         returns (bool)
313     {
314         require(!isEmptyString(btcDepositAddress), "invalid btc deposit address"); 
315         require(compareStrings(btcDepositAddress, custodianBtcDepositAddress[msg.sender]), "wrong btc deposit address");
316 
317         uint nonce = mintRequests.length;
318         uint timestamp = getTimestamp();
319 
320         Request memory request = Request({
321             requester: msg.sender,
322             amount: amount,
323             btcDepositAddress: btcDepositAddress,
324             btcTxid: btcTxid,
325             nonce: nonce,
326             timestamp: timestamp,
327             status: RequestStatus.PENDING
328         });
329 
330         bytes32 requestHash = calcRequestHash(request);
331         mintRequestNonce[requestHash] = nonce; 
332         mintRequests.push(request);
333 
334         emit MintRequestAdd(nonce, msg.sender, amount, btcDepositAddress, btcTxid, timestamp, requestHash);
335         return true;
336     }
337 
338     event MintRequestCancel(uint indexed nonce, address indexed requester, bytes32 requestHash);
339 
340     function cancelMintRequest(bytes32 requestHash) external onlyMerchant returns (bool) {
341         uint nonce;
342         Request memory request;
343 
344         (nonce, request) = getPendingMintRequest(requestHash);
345 
346         require(msg.sender == request.requester, "cancel sender is different than pending request initiator");
347         mintRequests[nonce].status = RequestStatus.CANCELED;
348 
349         emit MintRequestCancel(nonce, msg.sender, requestHash);
350         return true;
351     }
352 
353     event MintConfirmed(
354         uint indexed nonce,
355         address indexed requester,
356         uint amount,
357         string btcDepositAddress,
358         string btcTxid,
359         uint timestamp,
360         bytes32 requestHash
361     );
362 
363     function confirmMintRequest(bytes32 requestHash) external onlyCustodian returns (bool) {
364         uint nonce;
365         Request memory request;
366 
367         (nonce, request) = getPendingMintRequest(requestHash);
368 
369         mintRequests[nonce].status = RequestStatus.APPROVED;
370         require(controller.mint(request.requester, request.amount), "mint failed");
371 
372         emit MintConfirmed(
373             request.nonce,
374             request.requester,
375             request.amount,
376             request.btcDepositAddress,
377             request.btcTxid,
378             request.timestamp,
379             requestHash
380         );
381         return true;
382     }
383 
384     event MintRejected(
385         uint indexed nonce,
386         address indexed requester,
387         uint amount,
388         string btcDepositAddress,
389         string btcTxid,
390         uint timestamp,
391         bytes32 requestHash
392     );
393 
394     function rejectMintRequest(bytes32 requestHash) external onlyCustodian returns (bool) {
395         uint nonce;
396         Request memory request;
397 
398         (nonce, request) = getPendingMintRequest(requestHash);
399 
400         mintRequests[nonce].status = RequestStatus.REJECTED;
401 
402         emit MintRejected(
403             request.nonce,
404             request.requester,
405             request.amount,
406             request.btcDepositAddress,
407             request.btcTxid,
408             request.timestamp,
409             requestHash
410         );
411         return true;
412     }
413 
414     event Burned(
415         uint indexed nonce,
416         address indexed requester,
417         uint amount,
418         string btcDepositAddress,
419         uint timestamp,
420         bytes32 requestHash
421     );
422 
423     function burn(uint amount) external onlyMerchant returns (bool) {
424         string memory btcDepositAddress = merchantBtcDepositAddress[msg.sender];
425         require(!isEmptyString(btcDepositAddress), "merchant btc deposit address was not set"); 
426 
427         uint nonce = burnRequests.length;
428         uint timestamp = getTimestamp();
429 
430         // set txid as empty since it is not known yet.
431         string memory btcTxid = "";
432 
433         Request memory request = Request({
434             requester: msg.sender,
435             amount: amount,
436             btcDepositAddress: btcDepositAddress,
437             btcTxid: btcTxid,
438             nonce: nonce,
439             timestamp: timestamp,
440             status: RequestStatus.PENDING
441         });
442 
443         bytes32 requestHash = calcRequestHash(request);
444         burnRequestNonce[requestHash] = nonce; 
445         burnRequests.push(request);
446 
447         require(controller.getWBTC().transferFrom(msg.sender, controller, amount), "trasnfer tokens to burn failed");
448         require(controller.burn(amount), "burn failed");
449 
450         emit Burned(nonce, msg.sender, amount, btcDepositAddress, timestamp, requestHash);
451         return true;
452     }
453 
454     event BurnConfirmed(
455         uint indexed nonce,
456         address indexed requester,
457         uint amount,
458         string btcDepositAddress,
459         string btcTxid,
460         uint timestamp,
461         bytes32 inputRequestHash
462     );
463 
464     function confirmBurnRequest(bytes32 requestHash, string btcTxid) external onlyCustodian returns (bool) {
465         uint nonce;
466         Request memory request;
467 
468         (nonce, request) = getPendingBurnRequest(requestHash);
469 
470         burnRequests[nonce].btcTxid = btcTxid;
471         burnRequests[nonce].status = RequestStatus.APPROVED;
472         burnRequestNonce[calcRequestHash(burnRequests[nonce])] = nonce;
473 
474         emit BurnConfirmed(
475             request.nonce,
476             request.requester,
477             request.amount,
478             request.btcDepositAddress,
479             btcTxid,
480             request.timestamp,
481             requestHash
482         );
483         return true;
484     }
485 
486     function getMintRequest(uint nonce)
487         external
488         view
489         returns (
490             uint requestNonce,
491             address requester,
492             uint amount,
493             string btcDepositAddress,
494             string btcTxid,
495             uint timestamp,
496             string status,
497             bytes32 requestHash
498         )
499     {
500         Request memory request = mintRequests[nonce];
501         string memory statusString = getStatusString(request.status); 
502 
503         requestNonce = request.nonce;
504         requester = request.requester;
505         amount = request.amount;
506         btcDepositAddress = request.btcDepositAddress;
507         btcTxid = request.btcTxid;
508         timestamp = request.timestamp;
509         status = statusString;
510         requestHash = calcRequestHash(request);
511     }
512 
513     function getMintRequestsLength() external view returns (uint length) {
514         return mintRequests.length;
515     }
516 
517     function getBurnRequest(uint nonce)
518         external
519         view
520         returns (
521             uint requestNonce,
522             address requester,
523             uint amount,
524             string btcDepositAddress,
525             string btcTxid,
526             uint timestamp,
527             string status,
528             bytes32 requestHash
529         )
530     {
531         Request storage request = burnRequests[nonce];
532         string memory statusString = getStatusString(request.status); 
533 
534         requestNonce = request.nonce;
535         requester = request.requester;
536         amount = request.amount;
537         btcDepositAddress = request.btcDepositAddress;
538         btcTxid = request.btcTxid;
539         timestamp = request.timestamp;
540         status = statusString;
541         requestHash = calcRequestHash(request);
542     }
543 
544     function getBurnRequestsLength() external view returns (uint length) {
545         return burnRequests.length;
546     }
547 
548     function getTimestamp() internal view returns (uint) {
549         // timestamp is only used for data maintaining purpose, it is not relied on for critical logic.
550         return block.timestamp; // solhint-disable-line not-rely-on-time
551     }
552 
553     function getPendingMintRequest(bytes32 requestHash) internal view returns (uint nonce, Request memory request) {
554         require(requestHash != 0, "request hash is 0");
555         nonce = mintRequestNonce[requestHash];
556         request = mintRequests[nonce];
557         validatePendingRequest(request, requestHash);
558     }
559 
560     function getPendingBurnRequest(bytes32 requestHash) internal view returns (uint nonce, Request memory request) {
561         require(requestHash != 0, "request hash is 0");
562         nonce = burnRequestNonce[requestHash];
563         request = burnRequests[nonce];
564         validatePendingRequest(request, requestHash);
565     }
566 
567     function validatePendingRequest(Request memory request, bytes32 requestHash) internal pure {
568         require(request.status == RequestStatus.PENDING, "request is not pending");
569         require(requestHash == calcRequestHash(request), "given request hash does not match a pending request");
570     }
571 
572     function calcRequestHash(Request request) internal pure returns (bytes32) {
573         return keccak256(abi.encode(
574             request.requester,
575             request.amount,
576             request.btcDepositAddress,
577             request.btcTxid,
578             request.nonce,
579             request.timestamp
580         ));
581     }
582 
583     function compareStrings (string a, string b) internal pure returns (bool) {
584         return (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)));
585     }
586 
587     function isEmptyString (string a) internal pure returns (bool) {
588         return (compareStrings(a, ""));
589     }
590 
591     function getStatusString(RequestStatus status) internal pure returns (string) {
592         if (status == RequestStatus.PENDING) {
593             return "pending";
594         } else if (status == RequestStatus.CANCELED) {
595             return "canceled";
596         } else if (status == RequestStatus.APPROVED) {
597             return "approved";
598         } else if (status == RequestStatus.REJECTED) {
599             return "rejected";
600         } else {
601             // this fallback can never be reached.
602             return "unknown";
603         }
604     }
605 }