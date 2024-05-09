1 pragma solidity ^0.4.24;
2 
3 contract CrabData {
4   modifier crabDataLength(uint256[] memory _crabData) {
5     require(_crabData.length == 8);
6     _;
7   }
8 
9   struct CrabPartData {
10     uint256 hp;
11     uint256 dps;
12     uint256 blockRate;
13     uint256 resistanceBonus;
14     uint256 hpBonus;
15     uint256 dpsBonus;
16     uint256 blockBonus;
17     uint256 mutiplierBonus;
18   }
19 
20   function arrayToCrabPartData(
21     uint256[] _partData
22   ) 
23     internal 
24     pure 
25     crabDataLength(_partData) 
26     returns (CrabPartData memory _parsedData) 
27   {
28     _parsedData = CrabPartData(
29       _partData[0],   // hp
30       _partData[1],   // dps
31       _partData[2],   // block rate
32       _partData[3],   // resistance bonus
33       _partData[4],   // hp bonus
34       _partData[5],   // dps bonus
35       _partData[6],   // block bonus
36       _partData[7]);  // multiplier bonus
37   }
38 
39   function crabPartDataToArray(CrabPartData _crabPartData) internal pure returns (uint256[] memory _resultData) {
40     _resultData = new uint256[](8);
41     _resultData[0] = _crabPartData.hp;
42     _resultData[1] = _crabPartData.dps;
43     _resultData[2] = _crabPartData.blockRate;
44     _resultData[3] = _crabPartData.resistanceBonus;
45     _resultData[4] = _crabPartData.hpBonus;
46     _resultData[5] = _crabPartData.dpsBonus;
47     _resultData[6] = _crabPartData.blockBonus;
48     _resultData[7] = _crabPartData.mutiplierBonus;
49   }
50 }
51 
52 contract GeneSurgeon {
53   //0 - filler, 1 - body, 2 - leg, 3 - left claw, 4 - right claw
54   uint256[] internal crabPartMultiplier = [0, 10**9, 10**6, 10**3, 1];
55 
56   function extractElementsFromGene(uint256 _gene) internal view returns (uint256[] memory _elements) {
57     _elements = new uint256[](4);
58     _elements[0] = _gene / crabPartMultiplier[1] / 100 % 10;
59     _elements[1] = _gene / crabPartMultiplier[2] / 100 % 10;
60     _elements[2] = _gene / crabPartMultiplier[3] / 100 % 10;
61     _elements[3] = _gene / crabPartMultiplier[4] / 100 % 10;
62   }
63 
64   function extractPartsFromGene(uint256 _gene) internal view returns (uint256[] memory _parts) {
65     _parts = new uint256[](4);
66     _parts[0] = _gene / crabPartMultiplier[1] % 100;
67     _parts[1] = _gene / crabPartMultiplier[2] % 100;
68     _parts[2] = _gene / crabPartMultiplier[3] % 100;
69     _parts[3] = _gene / crabPartMultiplier[4] % 100;
70   }
71 }
72 
73 interface GenesisCrabInterface {
74   function generateCrabGene(bool isPresale, bool hasLegendaryPart) external returns (uint256 _gene, uint256 _skin, uint256 _heartValue, uint256 _growthValue);
75   function mutateCrabPart(uint256 _part, uint256 _existingPartGene, uint256 _legendaryPercentage) external returns (uint256);
76   function generateCrabHeart() external view returns (uint256, uint256);
77 }
78 
79 contract LevelCalculator {
80   event LevelUp(address indexed tokenOwner, uint256 indexed tokenId, uint256 currentLevel, uint256 currentExp);
81   event ExpGained(address indexed tokenOwner, uint256 indexed tokenId, uint256 currentLevel, uint256 currentExp);
82 
83   function expRequiredToReachLevel(uint256 _level) internal pure returns (uint256 _exp) {
84     require(_level > 1);
85 
86     uint256 _expRequirement = 10;
87     for(uint256 i = 2 ; i < _level ; i++) {
88       _expRequirement += 12;
89     }
90     _exp = _expRequirement;
91   }
92 }
93 
94 contract Randomable {
95   // Generates a random number base on last block hash
96   function _generateRandom(bytes32 seed) view internal returns (bytes32) {
97     return keccak256(abi.encodePacked(blockhash(block.number-1), seed));
98   }
99 
100   function _generateRandomNumber(bytes32 seed, uint256 max) view internal returns (uint256) {
101     return uint256(_generateRandom(seed)) % max;
102   }
103 }
104 
105 contract CryptantCrabStoreInterface {
106   function createAddress(bytes32 key, address value) external returns (bool);
107   function createAddresses(bytes32[] keys, address[] values) external returns (bool);
108   function updateAddress(bytes32 key, address value) external returns (bool);
109   function updateAddresses(bytes32[] keys, address[] values) external returns (bool);
110   function removeAddress(bytes32 key) external returns (bool);
111   function removeAddresses(bytes32[] keys) external returns (bool);
112   function readAddress(bytes32 key) external view returns (address);
113   function readAddresses(bytes32[] keys) external view returns (address[]);
114   // Bool related functions
115   function createBool(bytes32 key, bool value) external returns (bool);
116   function createBools(bytes32[] keys, bool[] values) external returns (bool);
117   function updateBool(bytes32 key, bool value) external returns (bool);
118   function updateBools(bytes32[] keys, bool[] values) external returns (bool);
119   function removeBool(bytes32 key) external returns (bool);
120   function removeBools(bytes32[] keys) external returns (bool);
121   function readBool(bytes32 key) external view returns (bool);
122   function readBools(bytes32[] keys) external view returns (bool[]);
123   // Bytes32 related functions
124   function createBytes32(bytes32 key, bytes32 value) external returns (bool);
125   function createBytes32s(bytes32[] keys, bytes32[] values) external returns (bool);
126   function updateBytes32(bytes32 key, bytes32 value) external returns (bool);
127   function updateBytes32s(bytes32[] keys, bytes32[] values) external returns (bool);
128   function removeBytes32(bytes32 key) external returns (bool);
129   function removeBytes32s(bytes32[] keys) external returns (bool);
130   function readBytes32(bytes32 key) external view returns (bytes32);
131   function readBytes32s(bytes32[] keys) external view returns (bytes32[]);
132   // uint256 related functions
133   function createUint256(bytes32 key, uint256 value) external returns (bool);
134   function createUint256s(bytes32[] keys, uint256[] values) external returns (bool);
135   function updateUint256(bytes32 key, uint256 value) external returns (bool);
136   function updateUint256s(bytes32[] keys, uint256[] values) external returns (bool);
137   function removeUint256(bytes32 key) external returns (bool);
138   function removeUint256s(bytes32[] keys) external returns (bool);
139   function readUint256(bytes32 key) external view returns (uint256);
140   function readUint256s(bytes32[] keys) external view returns (uint256[]);
141   // int256 related functions
142   function createInt256(bytes32 key, int256 value) external returns (bool);
143   function createInt256s(bytes32[] keys, int256[] values) external returns (bool);
144   function updateInt256(bytes32 key, int256 value) external returns (bool);
145   function updateInt256s(bytes32[] keys, int256[] values) external returns (bool);
146   function removeInt256(bytes32 key) external returns (bool);
147   function removeInt256s(bytes32[] keys) external returns (bool);
148   function readInt256(bytes32 key) external view returns (int256);
149   function readInt256s(bytes32[] keys) external view returns (int256[]);
150   // internal functions
151   function parseKey(bytes32 key) internal pure returns (bytes32);
152   function parseKeys(bytes32[] _keys) internal pure returns (bytes32[]);
153 }
154 
155 contract StoreRBAC {
156   // stores: storeName -> key -> addr -> isAllowed
157   mapping(uint256 => mapping (uint256 => mapping(address => bool))) private stores;
158 
159   // store names
160   uint256 public constant STORE_RBAC = 1;
161   uint256 public constant STORE_FUNCTIONS = 2;
162   uint256 public constant STORE_KEYS = 3;
163   // rbac roles
164   uint256 public constant RBAC_ROLE_ADMIN = 1; // "admin"
165 
166   // events
167   event RoleAdded(uint256 storeName, address addr, uint256 role);
168   event RoleRemoved(uint256 storeName, address addr, uint256 role);
169 
170   constructor() public {
171     addRole(STORE_RBAC, msg.sender, RBAC_ROLE_ADMIN);
172   }
173 
174   function hasRole(uint256 storeName, address addr, uint256 role) public view returns (bool) {
175     return stores[storeName][role][addr];
176   }
177 
178   function checkRole(uint256 storeName, address addr, uint256 role) public view {
179     require(hasRole(storeName, addr, role));
180   }
181 
182   function addRole(uint256 storeName, address addr, uint256 role) internal {
183     stores[storeName][role][addr] = true;
184 
185     emit RoleAdded(storeName, addr, role);
186   }
187 
188   function removeRole(uint256 storeName, address addr, uint256 role) internal {
189     stores[storeName][role][addr] = false;
190 
191     emit RoleRemoved(storeName, addr, role);
192   }
193 
194   function adminAddRole(uint256 storeName, address addr, uint256 role) onlyAdmin public {
195     addRole(storeName, addr, role);
196   }
197 
198   function adminRemoveRole(uint256 storeName, address addr, uint256 role) onlyAdmin public {
199     removeRole(storeName, addr, role);
200   }
201 
202   modifier onlyRole(uint256 storeName, uint256 role) {
203     checkRole(storeName, msg.sender, role);
204     _;
205   }
206 
207   modifier onlyAdmin() {
208     checkRole(STORE_RBAC, msg.sender, RBAC_ROLE_ADMIN);
209     _;
210   }
211 }
212 
213 contract FunctionProtection is StoreRBAC { 
214   // standard roles
215   uint256 constant public FN_ROLE_CREATE = 2; // create
216   uint256 constant public FN_ROLE_UPDATE = 3; // update
217   uint256 constant public FN_ROLE_REMOVE = 4; // remove
218 
219   function canCreate() internal view returns (bool) {
220     return hasRole(STORE_FUNCTIONS, msg.sender, FN_ROLE_CREATE);
221   }
222   
223   function canUpdate() internal view returns (bool) {
224     return hasRole(STORE_FUNCTIONS, msg.sender, FN_ROLE_UPDATE);
225   }
226   
227   function canRemove() internal view returns (bool) {
228     return hasRole(STORE_FUNCTIONS, msg.sender, FN_ROLE_REMOVE);
229   }
230 
231   // external functions
232   function applyAllPermission(address _address) external onlyAdmin {
233     addRole(STORE_FUNCTIONS, _address, FN_ROLE_CREATE);
234     addRole(STORE_FUNCTIONS, _address, FN_ROLE_UPDATE);
235     addRole(STORE_FUNCTIONS, _address, FN_ROLE_REMOVE);
236   }
237 }
238 
239 contract CryptantCrabMarketStore is FunctionProtection {
240   // Structure of each traded record
241   struct TradeRecord {
242     uint256 tokenId;
243     uint256 auctionId;
244     uint256 price;
245     uint48 time;
246     address owner;
247     address seller;
248   }
249 
250   // Structure of each trading item
251   struct AuctionItem {
252     uint256 tokenId;
253     uint256 basePrice;
254     address seller;
255     uint48 startTime;
256     uint48 endTime;
257     uint8 state;              // 0 - on going, 1 - cancelled, 2 - claimed
258     uint256[] bidIndexes;     // storing bidId
259   }
260 
261   struct Bid {
262     uint256 auctionId;
263     uint256 price;
264     uint48 time;
265     address bidder;
266   }
267 
268   // Structure to store withdrawal information
269   struct WithdrawalRecord {
270     uint256 auctionId;
271     uint256 value;
272     uint48 time;
273     uint48 callTime;
274     bool hasWithdrawn;
275   }
276 
277   // stores awaiting withdrawal information
278   mapping(address => WithdrawalRecord[]) public withdrawalList;
279 
280   // stores last withdrawal index
281   mapping(address => uint256) public lastWithdrawnIndex;
282 
283   // All traded records will be stored here
284   TradeRecord[] public tradeRecords;
285 
286   // All auctioned items will be stored here
287   AuctionItem[] public auctionItems;
288 
289   Bid[] public bidHistory;
290 
291   event TradeRecordAdded(address indexed seller, address indexed buyer, uint256 tradeId, uint256 price, uint256 tokenId, uint256 indexed auctionId);
292 
293   event AuctionItemAdded(address indexed seller, uint256 auctionId, uint256 basePrice, uint256 duration, uint256 tokenId);
294 
295   event AuctionBid(address indexed bidder, address indexed previousBidder, uint256 auctionId, uint256 bidPrice, uint256 bidIndex, uint256 tokenId, uint256 endTime);
296 
297   event PendingWithdrawalCleared(address indexed withdrawer, uint256 withdrawnAmount);
298 
299   constructor() public 
300   {
301     // auctionItems index 0 should be dummy, 
302     // because TradeRecord might not have auctionId
303     auctionItems.push(AuctionItem(0, 0, address(0), 0, 0, 0, new uint256[](1)));
304 
305     // tradeRecords index 0 will be dummy
306     // just to follow the standards skipping the index 0
307     tradeRecords.push(TradeRecord(0, 0, 0, 0, address(0), address(0)));
308 
309     // bidHistory index 0 will be dummy
310     // just to follow the standards skipping the index 0
311     bidHistory.push(Bid(0, 0, uint48(0), address(0)));
312   }
313 
314   // external functions
315   // getters
316   function getWithdrawalList(address withdrawer) external view returns (
317     uint256[] memory _auctionIds,
318     uint256[] memory _values,
319     uint256[] memory _times,
320     uint256[] memory _callTimes,
321     bool[] memory _hasWithdrawn
322   ) {
323     WithdrawalRecord[] storage withdrawalRecords = withdrawalList[withdrawer];
324     _auctionIds = new uint256[](withdrawalRecords.length);
325     _values = new uint256[](withdrawalRecords.length);
326     _times = new uint256[](withdrawalRecords.length);
327     _callTimes = new uint256[](withdrawalRecords.length);
328     _hasWithdrawn = new bool[](withdrawalRecords.length);
329 
330     for(uint256 i = 0 ; i < withdrawalRecords.length ; i++) {
331       WithdrawalRecord storage withdrawalRecord = withdrawalRecords[i];
332       _auctionIds[i] = withdrawalRecord.auctionId;
333       _values[i] = withdrawalRecord.value; 
334       _times[i] = withdrawalRecord.time;
335       _callTimes[i] = withdrawalRecord.callTime;
336       _hasWithdrawn[i] = withdrawalRecord.hasWithdrawn;
337     }
338   }
339 
340   function getTradeRecord(uint256 _tradeId) external view returns (
341     uint256 _tokenId,
342     uint256 _auctionId,
343     uint256 _price,
344     uint256 _time,
345     address _owner,
346     address _seller
347   ) {
348     TradeRecord storage _tradeRecord = tradeRecords[_tradeId];
349     _tokenId = _tradeRecord.tokenId;
350     _auctionId = _tradeRecord.auctionId;
351     _price = _tradeRecord.price;
352     _time = _tradeRecord.time;
353     _owner = _tradeRecord.owner;
354     _seller = _tradeRecord.seller;
355   }
356 
357   function totalTradeRecords() external view returns (uint256) {
358     return tradeRecords.length - 1; // need to exclude the dummy
359   }
360 
361   function getPricesOfLatestTradeRecords(uint256 amount) external view returns (uint256[] memory _prices) {
362     _prices = new uint256[](amount);
363     uint256 startIndex = tradeRecords.length - amount;
364 
365     for(uint256 i = 0 ; i < amount ; i++) {
366       _prices[i] = tradeRecords[startIndex + i].price;
367     }
368   }
369 
370   function getAuctionItem(uint256 _auctionId) external view returns (
371     uint256 _tokenId,
372     uint256 _basePrice,
373     address _seller,
374     uint256 _startTime,
375     uint256 _endTime,
376     uint256 _state,
377     uint256[] _bidIndexes
378   ) {
379     AuctionItem storage _auctionItem = auctionItems[_auctionId];
380     _tokenId = _auctionItem.tokenId;
381     _basePrice = _auctionItem.basePrice;
382     _seller = _auctionItem.seller;
383     _startTime = _auctionItem.startTime;
384     _endTime = _auctionItem.endTime;
385     _state = _auctionItem.state;
386     _bidIndexes = _auctionItem.bidIndexes;
387   }
388 
389   function getAuctionItems(uint256[] _auctionIds) external view returns (
390     uint256[] _tokenId,
391     uint256[] _basePrice,
392     address[] _seller,
393     uint256[] _startTime,
394     uint256[] _endTime,
395     uint256[] _state,
396     uint256[] _lastBidId
397   ) {
398     _tokenId = new uint256[](_auctionIds.length);
399     _basePrice = new uint256[](_auctionIds.length);
400     _startTime = new uint256[](_auctionIds.length);
401     _endTime = new uint256[](_auctionIds.length);
402     _state = new uint256[](_auctionIds.length);
403     _lastBidId = new uint256[](_auctionIds.length);
404     _seller = new address[](_auctionIds.length);
405 
406     for(uint256 i = 0 ; i < _auctionIds.length ; i++) {
407       AuctionItem storage _auctionItem = auctionItems[_auctionIds[i]];
408       _tokenId[i] = (_auctionItem.tokenId);
409       _basePrice[i] = (_auctionItem.basePrice);
410       _seller[i] = (_auctionItem.seller);
411       _startTime[i] = (_auctionItem.startTime);
412       _endTime[i] = (_auctionItem.endTime);
413       _state[i] = (_auctionItem.state);
414 
415       for(uint256 j = _auctionItem.bidIndexes.length - 1 ; j > 0 ; j--) {
416         if(_auctionItem.bidIndexes[j] > 0) {
417           _lastBidId[i] = _auctionItem.bidIndexes[j];
418           break;
419         }
420       }
421     }
422   }
423 
424   function totalAuctionItems() external view returns (uint256) {
425     return auctionItems.length - 1; // need to exclude the dummy
426   }
427 
428   function getBid(uint256 _bidId) external view returns (
429     uint256 _auctionId,
430     uint256 _price,
431     uint256 _time,
432     address _bidder
433   ) {
434     Bid storage _bid = bidHistory[_bidId];
435     _auctionId = _bid.auctionId;
436     _price = _bid.price;
437     _time = _bid.time;
438     _bidder = _bid.bidder;
439   }
440 
441   function getBids(uint256[] _bidIds) external view returns (
442     uint256[] _auctionId,
443     uint256[] _price,
444     uint256[] _time,
445     address[] _bidder
446   ) {
447     _auctionId = new uint256[](_bidIds.length);
448     _price = new uint256[](_bidIds.length);
449     _time = new uint256[](_bidIds.length);
450     _bidder = new address[](_bidIds.length);
451 
452     for(uint256 i = 0 ; i < _bidIds.length ; i++) {
453       Bid storage _bid = bidHistory[_bidIds[i]];
454       _auctionId[i] = _bid.auctionId;
455       _price[i] = _bid.price;
456       _time[i] = _bid.time;
457       _bidder[i] = _bid.bidder;
458     }
459   }
460 
461   // setters 
462   function addTradeRecord
463   (
464     uint256 _tokenId,
465     uint256 _auctionId,
466     uint256 _price,
467     uint256 _time,
468     address _buyer,
469     address _seller
470   ) 
471   external 
472   returns (uint256 _tradeId)
473   {
474     require(canUpdate());
475 
476     _tradeId = tradeRecords.length;
477     tradeRecords.push(TradeRecord(_tokenId, _auctionId, _price, uint48(_time), _buyer, _seller));
478 
479     if(_auctionId > 0) {
480       auctionItems[_auctionId].state = uint8(2);
481     }
482 
483     emit TradeRecordAdded(_seller, _buyer, _tradeId, _price, _tokenId, _auctionId);
484   }
485 
486   function addAuctionItem
487   (
488     uint256 _tokenId,
489     uint256 _basePrice,
490     address _seller,
491     uint256 _endTime
492   ) 
493   external
494   returns (uint256 _auctionId)
495   {
496     require(canUpdate());
497 
498     _auctionId = auctionItems.length;
499     auctionItems.push(AuctionItem(
500       _tokenId,
501       _basePrice, 
502       _seller, 
503       uint48(now), 
504       uint48(_endTime),
505       0,
506       new uint256[](21)));
507 
508     emit AuctionItemAdded(_seller, _auctionId, _basePrice, _endTime - now, _tokenId);
509   }
510 
511   function updateAuctionTime(uint256 _auctionId, uint256 _time, uint256 _state) external {
512     require(canUpdate());
513 
514     AuctionItem storage _auctionItem = auctionItems[_auctionId];
515     _auctionItem.endTime = uint48(_time);
516     _auctionItem.state = uint8(_state);
517   }
518 
519   function addBidder(uint256 _auctionId, address _bidder, uint256 _price, uint256 _bidIndex) external {
520     require(canUpdate());
521 
522     uint256 _bidId = bidHistory.length;
523     bidHistory.push(Bid(_auctionId, _price, uint48(now), _bidder));
524 
525     AuctionItem storage _auctionItem = auctionItems[_auctionId];
526 
527     // find previous bidder
528     // Max bid index is 20, so maximum loop is 20 times
529     address _previousBidder = address(0);
530     for(uint256 i = _auctionItem.bidIndexes.length - 1 ; i > 0 ; i--) {
531       if(_auctionItem.bidIndexes[i] > 0) {
532         Bid memory _previousBid = bidHistory[_auctionItem.bidIndexes[i]];
533         _previousBidder = _previousBid.bidder;
534         break;
535       }
536     }
537 
538     _auctionItem.bidIndexes[_bidIndex] = _bidId;
539 
540     emit AuctionBid(_bidder, _previousBidder, _auctionId, _price, _bidIndex, _auctionItem.tokenId, _auctionItem.endTime);
541   }
542 
543   function addWithdrawal
544   (
545     address _withdrawer,
546     uint256 _auctionId,
547     uint256 _value,
548     uint256 _callTime
549   )
550   external 
551   {
552     require(canUpdate());
553 
554     WithdrawalRecord memory _withdrawal = WithdrawalRecord(_auctionId, _value, uint48(now), uint48(_callTime), false); 
555     withdrawalList[_withdrawer].push(_withdrawal);
556   }
557 
558   function clearPendingWithdrawal(address _withdrawer) external returns (uint256 _withdrawnAmount) {
559     require(canUpdate());
560 
561     WithdrawalRecord[] storage _withdrawalList = withdrawalList[_withdrawer];
562     uint256 _lastWithdrawnIndex = lastWithdrawnIndex[_withdrawer];
563 
564     for(uint256 i = _lastWithdrawnIndex ; i < _withdrawalList.length ; i++) {
565       WithdrawalRecord storage _withdrawalRecord = _withdrawalList[i];
566       _withdrawalRecord.hasWithdrawn = true;
567       _withdrawnAmount += _withdrawalRecord.value;
568     }
569 
570     // update the last withdrawn index so next time will start from this index
571     lastWithdrawnIndex[_withdrawer] = _withdrawalList.length - 1;
572 
573     emit PendingWithdrawalCleared(_withdrawer, _withdrawnAmount);
574   }
575 }
576 
577 library AddressUtils {
578 
579   /**
580    * Returns whether the target address is a contract
581    * @dev This function will return false if invoked during the constructor of a contract,
582    * as the code is not actually created until after the constructor finishes.
583    * @param addr address to check
584    * @return whether the target address is a contract
585    */
586   function isContract(address addr) internal view returns (bool) {
587     uint256 size;
588     // XXX Currently there is no better way to check if there is a contract in an address
589     // than to check the size of the code at that address.
590     // See https://ethereum.stackexchange.com/a/14016/36603
591     // for more details about how this works.
592     // TODO Check this again before the Serenity release, because all addresses will be
593     // contracts then.
594     // solium-disable-next-line security/no-inline-assembly
595     assembly { size := extcodesize(addr) }
596     return size > 0;
597   }
598 
599 }
600 
601 interface ERC165 {
602 
603   /**
604    * @notice Query if a contract implements an interface
605    * @param _interfaceId The interface identifier, as specified in ERC-165
606    * @dev Interface identification is specified in ERC-165. This function
607    * uses less than 30,000 gas.
608    */
609   function supportsInterface(bytes4 _interfaceId)
610     external
611     view
612     returns (bool);
613 }
614 
615 contract SupportsInterfaceWithLookup is ERC165 {
616   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
617   /**
618    * 0x01ffc9a7 ===
619    *   bytes4(keccak256('supportsInterface(bytes4)'))
620    */
621 
622   /**
623    * @dev a mapping of interface id to whether or not it's supported
624    */
625   mapping(bytes4 => bool) internal supportedInterfaces;
626 
627   /**
628    * @dev A contract implementing SupportsInterfaceWithLookup
629    * implement ERC165 itself
630    */
631   constructor()
632     public
633   {
634     _registerInterface(InterfaceId_ERC165);
635   }
636 
637   /**
638    * @dev implement supportsInterface(bytes4) using a lookup table
639    */
640   function supportsInterface(bytes4 _interfaceId)
641     external
642     view
643     returns (bool)
644   {
645     return supportedInterfaces[_interfaceId];
646   }
647 
648   /**
649    * @dev private method for registering an interface
650    */
651   function _registerInterface(bytes4 _interfaceId)
652     internal
653   {
654     require(_interfaceId != 0xffffffff);
655     supportedInterfaces[_interfaceId] = true;
656   }
657 }
658 
659 library SafeMath {
660 
661   /**
662   * @dev Multiplies two numbers, throws on overflow.
663   */
664   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
665     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
666     // benefit is lost if 'b' is also tested.
667     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
668     if (a == 0) {
669       return 0;
670     }
671 
672     c = a * b;
673     assert(c / a == b);
674     return c;
675   }
676 
677   /**
678   * @dev Integer division of two numbers, truncating the quotient.
679   */
680   function div(uint256 a, uint256 b) internal pure returns (uint256) {
681     // assert(b > 0); // Solidity automatically throws when dividing by 0
682     // uint256 c = a / b;
683     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
684     return a / b;
685   }
686 
687   /**
688   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
689   */
690   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
691     assert(b <= a);
692     return a - b;
693   }
694 
695   /**
696   * @dev Adds two numbers, throws on overflow.
697   */
698   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
699     c = a + b;
700     assert(c >= a);
701     return c;
702   }
703 }
704 
705 contract Ownable {
706   address public owner;
707 
708 
709   event OwnershipRenounced(address indexed previousOwner);
710   event OwnershipTransferred(
711     address indexed previousOwner,
712     address indexed newOwner
713   );
714 
715 
716   /**
717    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
718    * account.
719    */
720   constructor() public {
721     owner = msg.sender;
722   }
723 
724   /**
725    * @dev Throws if called by any account other than the owner.
726    */
727   modifier onlyOwner() {
728     require(msg.sender == owner);
729     _;
730   }
731 
732   /**
733    * @dev Allows the current owner to relinquish control of the contract.
734    * @notice Renouncing to ownership will leave the contract without an owner.
735    * It will not be possible to call the functions with the `onlyOwner`
736    * modifier anymore.
737    */
738   function renounceOwnership() public onlyOwner {
739     emit OwnershipRenounced(owner);
740     owner = address(0);
741   }
742 
743   /**
744    * @dev Allows the current owner to transfer control of the contract to a newOwner.
745    * @param _newOwner The address to transfer ownership to.
746    */
747   function transferOwnership(address _newOwner) public onlyOwner {
748     _transferOwnership(_newOwner);
749   }
750 
751   /**
752    * @dev Transfers control of the contract to a newOwner.
753    * @param _newOwner The address to transfer ownership to.
754    */
755   function _transferOwnership(address _newOwner) internal {
756     require(_newOwner != address(0));
757     emit OwnershipTransferred(owner, _newOwner);
758     owner = _newOwner;
759   }
760 }
761 
762 contract CryptantCrabBase is Ownable {
763   GenesisCrabInterface public genesisCrab;
764   CryptantCrabNFT public cryptantCrabToken;
765   CryptantCrabStoreInterface public cryptantCrabStorage;
766 
767   constructor(address _genesisCrabAddress, address _cryptantCrabTokenAddress, address _cryptantCrabStorageAddress) public {
768     // constructor
769     
770     _setAddresses(_genesisCrabAddress, _cryptantCrabTokenAddress, _cryptantCrabStorageAddress);
771   }
772 
773   function setAddresses(
774     address _genesisCrabAddress, 
775     address _cryptantCrabTokenAddress, 
776     address _cryptantCrabStorageAddress
777   ) 
778   external onlyOwner {
779     _setAddresses(_genesisCrabAddress, _cryptantCrabTokenAddress, _cryptantCrabStorageAddress);
780   }
781 
782   function _setAddresses(
783     address _genesisCrabAddress,
784     address _cryptantCrabTokenAddress,
785     address _cryptantCrabStorageAddress
786   )
787   internal 
788   {
789     if(_genesisCrabAddress != address(0)) {
790       GenesisCrabInterface genesisCrabContract = GenesisCrabInterface(_genesisCrabAddress);
791       genesisCrab = genesisCrabContract;
792     }
793     
794     if(_cryptantCrabTokenAddress != address(0)) {
795       CryptantCrabNFT cryptantCrabTokenContract = CryptantCrabNFT(_cryptantCrabTokenAddress);
796       cryptantCrabToken = cryptantCrabTokenContract;
797     }
798     
799     if(_cryptantCrabStorageAddress != address(0)) {
800       CryptantCrabStoreInterface cryptantCrabStorageContract = CryptantCrabStoreInterface(_cryptantCrabStorageAddress);
801       cryptantCrabStorage = cryptantCrabStorageContract;
802     }
803   }
804 }
805 
806 contract CryptantCrabInformant is CryptantCrabBase{
807   constructor
808   (
809     address _genesisCrabAddress, 
810     address _cryptantCrabTokenAddress, 
811     address _cryptantCrabStorageAddress
812   ) 
813   public 
814   CryptantCrabBase
815   (
816     _genesisCrabAddress, 
817     _cryptantCrabTokenAddress, 
818     _cryptantCrabStorageAddress
819   ) {
820     // constructor
821 
822   }
823 
824   function _getCrabData(uint256 _tokenId) internal view returns 
825   (
826     uint256 _gene, 
827     uint256 _level, 
828     uint256 _exp, 
829     uint256 _mutationCount,
830     uint256 _trophyCount,
831     uint256 _heartValue,
832     uint256 _growthValue
833   ) {
834     require(cryptantCrabStorage != address(0));
835 
836     bytes32[] memory keys = new bytes32[](7);
837     uint256[] memory values;
838 
839     keys[0] = keccak256(abi.encodePacked(_tokenId, "gene"));
840     keys[1] = keccak256(abi.encodePacked(_tokenId, "level"));
841     keys[2] = keccak256(abi.encodePacked(_tokenId, "exp"));
842     keys[3] = keccak256(abi.encodePacked(_tokenId, "mutationCount"));
843     keys[4] = keccak256(abi.encodePacked(_tokenId, "trophyCount"));
844     keys[5] = keccak256(abi.encodePacked(_tokenId, "heartValue"));
845     keys[6] = keccak256(abi.encodePacked(_tokenId, "growthValue"));
846 
847     values = cryptantCrabStorage.readUint256s(keys);
848 
849     // process heart value
850     uint256 _processedHeartValue;
851     for(uint256 i = 1 ; i <= 1000 ; i *= 10) {
852       if(uint256(values[5]) / i % 10 > 0) {
853         _processedHeartValue += i;
854       }
855     }
856 
857     _gene = values[0];
858     _level = values[1];
859     _exp = values[2];
860     _mutationCount = values[3];
861     _trophyCount = values[4];
862     _heartValue = _processedHeartValue;
863     _growthValue = values[6];
864   }
865 
866   function _geneOfCrab(uint256 _tokenId) internal view returns (uint256 _gene) {
867     require(cryptantCrabStorage != address(0));
868 
869     _gene = cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_tokenId, "gene")));
870   }
871 }
872 
873 contract CrabManager is CryptantCrabInformant, CrabData {
874   constructor
875   (
876     address _genesisCrabAddress, 
877     address _cryptantCrabTokenAddress, 
878     address _cryptantCrabStorageAddress
879   ) 
880   public 
881   CryptantCrabInformant
882   (
883     _genesisCrabAddress, 
884     _cryptantCrabTokenAddress, 
885     _cryptantCrabStorageAddress
886   ) {
887     // constructor
888   }
889 
890   function getCrabsOfOwner(address _owner) external view returns (uint256[]) {
891     uint256 _balance = cryptantCrabToken.balanceOf(_owner);
892     uint256[] memory _tokenIds = new uint256[](_balance);
893 
894     for(uint256 i = 0 ; i < _balance ; i++) {
895       _tokenIds[i] = cryptantCrabToken.tokenOfOwnerByIndex(_owner, i);
896     }
897 
898     return _tokenIds;
899   }
900 
901   function getCrab(uint256 _tokenId) external view returns (
902     uint256 _gene,
903     uint256 _level,
904     uint256 _exp,
905     uint256 _mutationCount,
906     uint256 _trophyCount,
907     uint256 _heartValue,
908     uint256 _growthValue,
909     uint256 _fossilType
910   ) {
911     require(cryptantCrabToken.exists(_tokenId));
912 
913     (_gene, _level, _exp, _mutationCount, _trophyCount, _heartValue, _growthValue) = _getCrabData(_tokenId);
914     _fossilType = cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_tokenId, "fossilType")));
915   }
916 
917   function getCrabStats(uint256 _tokenId) external view returns (
918     uint256 _hp,
919     uint256 _dps,
920     uint256 _block,
921     uint256[] _partBonuses,
922     uint256 _fossilAttribute
923   ) {
924     require(cryptantCrabToken.exists(_tokenId));
925 
926     uint256 _gene = _geneOfCrab(_tokenId);
927     (_hp, _dps, _block) = _getCrabTotalStats(_gene);
928     _partBonuses = _getCrabPartBonuses(_tokenId);
929     _fossilAttribute = cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_tokenId, "fossilAttribute")));
930   }
931 
932   function _getCrabTotalStats(uint256 _gene) internal view returns (
933     uint256 _hp, 
934     uint256 _dps,
935     uint256 _blockRate
936   ) {
937     CrabPartData[] memory crabPartData = _getCrabPartData(_gene);
938 
939     for(uint256 i = 0 ; i < crabPartData.length ; i++) {
940       _hp += crabPartData[i].hp;
941       _dps += crabPartData[i].dps;
942       _blockRate += crabPartData[i].blockRate;
943     }
944   }
945 
946   function _getCrabPartBonuses(uint256 _tokenId) internal view returns (uint256[] _partBonuses) {
947     bytes32[] memory _keys = new bytes32[](4);
948     _keys[0] = keccak256(abi.encodePacked(_tokenId, uint256(1), "partBonus"));
949     _keys[1] = keccak256(abi.encodePacked(_tokenId, uint256(2), "partBonus"));
950     _keys[2] = keccak256(abi.encodePacked(_tokenId, uint256(3), "partBonus"));
951     _keys[3] = keccak256(abi.encodePacked(_tokenId, uint256(4), "partBonus"));
952     _partBonuses = cryptantCrabStorage.readUint256s(_keys);
953   }
954 
955   function _getCrabPartData(uint256 _gene) internal view returns (CrabPartData[] memory _crabPartData) {
956     require(cryptantCrabToken != address(0));
957     uint256[] memory _bodyData;
958     uint256[] memory _legData;
959     uint256[] memory _leftClawData;
960     uint256[] memory _rightClawData;
961     
962     (_bodyData, _legData, _leftClawData, _rightClawData) = cryptantCrabToken.crabPartDataFromGene(_gene);
963 
964     _crabPartData = new CrabPartData[](4);
965     _crabPartData[0] = arrayToCrabPartData(_bodyData);
966     _crabPartData[1] = arrayToCrabPartData(_legData);
967     _crabPartData[2] = arrayToCrabPartData(_leftClawData);
968     _crabPartData[3] = arrayToCrabPartData(_rightClawData);
969   }
970 }
971 
972 contract CryptantCrabPurchasableLaunch is CryptantCrabInformant {
973   using SafeMath for uint256;
974 
975   Transmuter public transmuter;
976 
977   event CrabHatched(address indexed owner, uint256 tokenId, uint256 gene, uint256 specialSkin, uint256 crabPrice, uint256 growthValue);
978   event CryptantFragmentsAdded(address indexed cryptantOwner, uint256 amount, uint256 newBalance);
979   event CryptantFragmentsRemoved(address indexed cryptantOwner, uint256 amount, uint256 newBalance);
980   event Refund(address indexed refundReceiver, uint256 reqAmt, uint256 paid, uint256 refundAmt);
981 
982   constructor
983   (
984     address _genesisCrabAddress, 
985     address _cryptantCrabTokenAddress, 
986     address _cryptantCrabStorageAddress,
987     address _transmuterAddress
988   ) 
989   public 
990   CryptantCrabInformant
991   (
992     _genesisCrabAddress, 
993     _cryptantCrabTokenAddress, 
994     _cryptantCrabStorageAddress
995   ) {
996     // constructor
997     if(_transmuterAddress != address(0)) {
998       _setTransmuterAddress(_transmuterAddress);
999     }
1000   }
1001 
1002   function setAddresses(
1003     address _genesisCrabAddress, 
1004     address _cryptantCrabTokenAddress, 
1005     address _cryptantCrabStorageAddress,
1006     address _transmuterAddress
1007   ) 
1008   external onlyOwner {
1009     _setAddresses(_genesisCrabAddress, _cryptantCrabTokenAddress, _cryptantCrabStorageAddress);
1010 
1011     if(_transmuterAddress != address(0)) {
1012       _setTransmuterAddress(_transmuterAddress);
1013     }
1014   }
1015 
1016   function _setTransmuterAddress(address _transmuterAddress) internal {
1017     Transmuter _transmuterContract = Transmuter(_transmuterAddress);
1018     transmuter = _transmuterContract;
1019   }
1020 
1021   function getCryptantFragments(address _sender) public view returns (uint256) {
1022     return cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_sender, "cryptant")));
1023   }
1024 
1025   function createCrab(uint256 _customTokenId, uint256 _crabPrice, uint256 _customGene, uint256 _customSkin, bool _hasLegendary) external onlyOwner {
1026     _createCrab(_customTokenId, _crabPrice, _customGene, _customSkin, _hasLegendary);
1027   }
1028   function _addCryptantFragments(address _cryptantOwner, uint256 _amount) internal returns (uint256 _newBalance) {
1029     _newBalance = getCryptantFragments(_cryptantOwner).add(_amount);
1030     cryptantCrabStorage.updateUint256(keccak256(abi.encodePacked(_cryptantOwner, "cryptant")), _newBalance);
1031     emit CryptantFragmentsAdded(_cryptantOwner, _amount, _newBalance);
1032   }
1033 
1034   function _removeCryptantFragments(address _cryptantOwner, uint256 _amount) internal returns (uint256 _newBalance) {
1035     _newBalance = getCryptantFragments(_cryptantOwner).sub(_amount);
1036     cryptantCrabStorage.updateUint256(keccak256(abi.encodePacked(_cryptantOwner, "cryptant")), _newBalance);
1037     emit CryptantFragmentsRemoved(_cryptantOwner, _amount, _newBalance);
1038   }
1039 
1040   function _createCrab(uint256 _tokenId, uint256 _crabPrice, uint256 _customGene, uint256 _customSkin, bool _hasLegendary) internal {
1041     uint256[] memory _values = new uint256[](8);
1042     bytes32[] memory _keys = new bytes32[](8);
1043 
1044     uint256 _gene;
1045     uint256 _specialSkin;
1046     uint256 _heartValue;
1047     uint256 _growthValue;
1048     if(_customGene == 0) {
1049       (_gene, _specialSkin, _heartValue, _growthValue) = genesisCrab.generateCrabGene(false, _hasLegendary);
1050     } else {
1051       _gene = _customGene;
1052     }
1053 
1054     if(_customSkin != 0) {
1055       _specialSkin = _customSkin;
1056     }
1057 
1058     (_heartValue, _growthValue) = genesisCrab.generateCrabHeart();
1059     
1060     cryptantCrabToken.mintToken(msg.sender, _tokenId, _specialSkin);
1061 
1062     // Gene pair
1063     _keys[0] = keccak256(abi.encodePacked(_tokenId, "gene"));
1064     _values[0] = _gene;
1065 
1066     // Level pair
1067     _keys[1] = keccak256(abi.encodePacked(_tokenId, "level"));
1068     _values[1] = 1;
1069 
1070     // Heart Value pair
1071     _keys[2] = keccak256(abi.encodePacked(_tokenId, "heartValue"));
1072     _values[2] = _heartValue;
1073 
1074     // Growth Value pair
1075     _keys[3] = keccak256(abi.encodePacked(_tokenId, "growthValue"));
1076     _values[3] = _growthValue;
1077 
1078     // Handling Legendary Bonus
1079     uint256[] memory _partLegendaryBonuses = transmuter.generateBonusForGene(_gene);
1080     // body
1081     _keys[4] = keccak256(abi.encodePacked(_tokenId, uint256(1), "partBonus"));
1082     _values[4] = _partLegendaryBonuses[0];
1083 
1084     // legs
1085     _keys[5] = keccak256(abi.encodePacked(_tokenId, uint256(2), "partBonus"));
1086     _values[5] = _partLegendaryBonuses[1];
1087 
1088     // left claw
1089     _keys[6] = keccak256(abi.encodePacked(_tokenId, uint256(3), "partBonus"));
1090     _values[6] = _partLegendaryBonuses[2];
1091 
1092     // right claw
1093     _keys[7] = keccak256(abi.encodePacked(_tokenId, uint256(4), "partBonus"));
1094     _values[7] = _partLegendaryBonuses[3];
1095 
1096     require(cryptantCrabStorage.createUint256s(_keys, _values));
1097 
1098     emit CrabHatched(msg.sender, _tokenId, _gene, _specialSkin, _crabPrice, _growthValue);
1099   }
1100 
1101   function _refundExceededValue(uint256 _senderValue, uint256 _requiredValue) internal {
1102     uint256 _exceededValue = _senderValue.sub(_requiredValue);
1103 
1104     if(_exceededValue > 0) {
1105       msg.sender.transfer(_exceededValue);
1106 
1107       emit Refund(msg.sender, _requiredValue, _senderValue, _exceededValue);
1108     } 
1109   }
1110 }
1111 
1112 contract CryptantInformant is CryptantCrabInformant {
1113   using SafeMath for uint256;
1114 
1115   event CryptantFragmentsAdded(address indexed cryptantOwner, uint256 amount, uint256 newBalance);
1116   event CryptantFragmentsRemoved(address indexed cryptantOwner, uint256 amount, uint256 newBalance);
1117 
1118   constructor
1119   (
1120     address _genesisCrabAddress, 
1121     address _cryptantCrabTokenAddress, 
1122     address _cryptantCrabStorageAddress
1123   ) 
1124   public 
1125   CryptantCrabInformant
1126   (
1127     _genesisCrabAddress, 
1128     _cryptantCrabTokenAddress, 
1129     _cryptantCrabStorageAddress
1130   ) {
1131     // constructor
1132 
1133   }
1134 
1135   function getCryptantFragments(address _sender) public view returns (uint256) {
1136     return cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_sender, "cryptant")));
1137   }
1138 
1139   function _addCryptantFragments(address _cryptantOwner, uint256 _amount) internal returns (uint256 _newBalance) {
1140     _newBalance = getCryptantFragments(_cryptantOwner).add(_amount);
1141     cryptantCrabStorage.updateUint256(keccak256(abi.encodePacked(_cryptantOwner, "cryptant")), _newBalance);
1142     emit CryptantFragmentsAdded(_cryptantOwner, _amount, _newBalance);
1143   }
1144 
1145   function _removeCryptantFragments(address _cryptantOwner, uint256 _amount) internal returns (uint256 _newBalance) {
1146     _newBalance = getCryptantFragments(_cryptantOwner).sub(_amount);
1147     cryptantCrabStorage.updateUint256(keccak256(abi.encodePacked(_cryptantOwner, "cryptant")), _newBalance);
1148     emit CryptantFragmentsRemoved(_cryptantOwner, _amount, _newBalance);
1149   }
1150 }
1151 
1152 contract Transmuter is CryptantInformant, GeneSurgeon, Randomable, LevelCalculator {
1153   event Xenografted(address indexed tokenOwner, uint256 recipientTokenId, uint256 donorTokenId, uint256 oldPartGene, uint256 newPartGene, uint256 oldPartBonus, uint256 newPartBonus, uint256 xenograftPart);
1154   event Mutated(address indexed tokenOwner, uint256 tokenId, uint256 partIndex, uint256 oldGene, uint256 newGene, uint256 oldPartBonus, uint256 newPartBonus, uint256 mutationCount);
1155 
1156   /**
1157    * @dev Pre-generated keys to save gas
1158    * keys are generated with:
1159    * NORMAL_FOSSIL_RELIC_PERCENTAGE     = bytes4(keccak256("normalFossilRelicPercentage"))    = 0xcaf6fae2
1160    * PIONEER_FOSSIL_RELIC_PERCENTAGE    = bytes4(keccak256("pioneerFossilRelicPercentage"))   = 0x04988c65
1161    * LEGENDARY_FOSSIL_RELIC_PERCENTAGE  = bytes4(keccak256("legendaryFossilRelicPercentage")) = 0x277e613a
1162    * FOSSIL_ATTRIBUTE_COUNT             = bytes4(keccak256("fossilAttributesCount"))          = 0x06c475be
1163    * LEGENDARY_BONUS_COUNT              = bytes4(keccak256("legendaryBonusCount"))            = 0x45025094
1164    * LAST_PIONEER_TOKEN_ID              = bytes4(keccak256("lastPioneerTokenId"))             = 0xe562bae2
1165    */
1166   bytes4 internal constant NORMAL_FOSSIL_RELIC_PERCENTAGE = 0xcaf6fae2;
1167   bytes4 internal constant PIONEER_FOSSIL_RELIC_PERCENTAGE = 0x04988c65;
1168   bytes4 internal constant LEGENDARY_FOSSIL_RELIC_PERCENTAGE = 0x277e613a;
1169   bytes4 internal constant FOSSIL_ATTRIBUTE_COUNT = 0x06c475be;
1170   bytes4 internal constant LEGENDARY_BONUS_COUNT = 0x45025094;
1171   bytes4 internal constant LAST_PIONEER_TOKEN_ID = 0xe562bae2;
1172 
1173   mapping(bytes4 => uint256) internal internalUintVariable;
1174 
1175   // elements => legendary set index of that element
1176   mapping(uint256 => uint256[]) internal legendaryPartIndex;
1177 
1178   constructor
1179   (
1180     address _genesisCrabAddress, 
1181     address _cryptantCrabTokenAddress, 
1182     address _cryptantCrabStorageAddress
1183   ) 
1184   public 
1185   CryptantInformant
1186   (
1187     _genesisCrabAddress, 
1188     _cryptantCrabTokenAddress, 
1189     _cryptantCrabStorageAddress
1190   ) {
1191     // constructor
1192 
1193     // default values for relic percentages
1194     // normal crab relic is set to 5%
1195     _setUint(NORMAL_FOSSIL_RELIC_PERCENTAGE, 5000);
1196 
1197     // pioneer crab relic is set to 50%
1198     _setUint(PIONEER_FOSSIL_RELIC_PERCENTAGE, 50000);
1199 
1200     // legendary crab part relic is set to increase by 50%
1201     _setUint(LEGENDARY_FOSSIL_RELIC_PERCENTAGE, 50000);
1202 
1203     // The max number of attributes types
1204     // Every fossil will have 1 attribute
1205     _setUint(FOSSIL_ATTRIBUTE_COUNT, 6);
1206 
1207     // The max number of bonus types for legendary
1208     // Every legendary will have 1 bonus
1209     _setUint(LEGENDARY_BONUS_COUNT, 5);
1210 
1211     // The last pioneer token ID to be referred as Pioneer
1212     _setUint(LAST_PIONEER_TOKEN_ID, 1121);
1213   }
1214 
1215   function setPartIndex(uint256 _element, uint256[] _partIndexes) external onlyOwner {
1216     legendaryPartIndex[_element] = _partIndexes;
1217   }
1218 
1219   function getPartIndexes(uint256 _element) external view onlyOwner returns (uint256[] memory _partIndexes){
1220     _partIndexes = legendaryPartIndex[_element];
1221   }
1222 
1223   function getUint(bytes4 key) external view returns (uint256 value) {
1224     value = _getUint(key);
1225   }
1226 
1227   function setUint(bytes4 key, uint256 value) external onlyOwner {
1228     _setUint(key, value);
1229   }
1230 
1231   function _getUint(bytes4 key) internal view returns (uint256 value) {
1232     value = internalUintVariable[key];
1233   }
1234 
1235   function _setUint(bytes4 key, uint256 value) internal {
1236     internalUintVariable[key] = value;
1237   }
1238 
1239   function xenograft(uint256 _recipientTokenId, uint256 _donorTokenId, uint256 _xenograftPart) external {
1240     // get crab gene of both token
1241     // make sure both token is not fossil
1242     // replace the recipient part with donor part
1243     // mark donor as fosil
1244     // fosil will generate 1 attr
1245     // 3% of fosil will have relic
1246     // deduct 10 cryptant
1247     require(_xenograftPart != 1);  // part cannot be body (part index = 1)
1248     require(cryptantCrabToken.ownerOf(_recipientTokenId) == msg.sender);  // check ownership of both token
1249     require(cryptantCrabToken.ownerOf(_donorTokenId) == msg.sender);
1250 
1251     // due to stack too deep, need to use an array
1252     // to represent all the variables
1253     uint256[] memory _intValues = new uint256[](11);
1254     _intValues[0] = getCryptantFragments(msg.sender);
1255     // _intValues[0] = ownedCryptant
1256     // _intValues[1] = donorPartBonus
1257     // _intValues[2] = recipientGene
1258     // _intValues[3] = donorGene
1259     // _intValues[4] = recipientPart
1260     // _intValues[5] = donorPart
1261     // _intValues[6] = relicPercentage
1262     // _intValues[7] = fossilType
1263     // _intValues[8] = recipientExistingPartBonus
1264     // _intValues[9] = recipientLevel
1265     // _intValues[10] = recipientExp
1266 
1267     // perform transplant requires 5 cryptant
1268     require(_intValues[0] >= 5000);
1269 
1270     // make sure both tokens are not fossil
1271     uint256[] memory _values;
1272     bytes32[] memory _keys = new bytes32[](6);
1273 
1274     _keys[0] = keccak256(abi.encodePacked(_recipientTokenId, "fossilType"));
1275     _keys[1] = keccak256(abi.encodePacked(_donorTokenId, "fossilType"));
1276     _keys[2] = keccak256(abi.encodePacked(_donorTokenId, _xenograftPart, "partBonus"));
1277     _keys[3] = keccak256(abi.encodePacked(_recipientTokenId, _xenograftPart, "partBonus"));
1278     _keys[4] = keccak256(abi.encodePacked(_recipientTokenId, "level"));
1279     _keys[5] = keccak256(abi.encodePacked(_recipientTokenId, "exp"));
1280     _values = cryptantCrabStorage.readUint256s(_keys);
1281 
1282     require(_values[0] == 0);
1283     require(_values[1] == 0);
1284 
1285     _intValues[1] = _values[2];
1286     _intValues[8] = _values[3];
1287 
1288     // _values[5] = recipient Exp
1289     // _values[4] = recipient Level
1290     _intValues[9] = _values[4];
1291     _intValues[10] = _values[5];
1292 
1293     // Increase Exp
1294     _intValues[10] += 8;
1295 
1296     // check if crab level up
1297     uint256 _expRequired = expRequiredToReachLevel(_intValues[9] + 1);
1298     if(_intValues[10] >=_expRequired) {
1299       // increase level
1300       _intValues[9] += 1;
1301 
1302       // carry forward extra exp
1303       _intValues[10] -= _expRequired;
1304 
1305       emit LevelUp(msg.sender, _recipientTokenId, _intValues[9], _intValues[10]);
1306     } else {
1307       emit ExpGained(msg.sender, _recipientTokenId, _intValues[9], _intValues[10]);
1308     }
1309 
1310     // start performing Xenograft
1311     _intValues[2] = _geneOfCrab(_recipientTokenId);
1312     _intValues[3] = _geneOfCrab(_donorTokenId);
1313 
1314     // recipientPart
1315     _intValues[4] = _intValues[2] / crabPartMultiplier[_xenograftPart] % 1000;
1316     _intValues[5] = _intValues[3] / crabPartMultiplier[_xenograftPart] % 1000;
1317     
1318     int256 _partDiff = int256(_intValues[4]) - int256(_intValues[5]);
1319     _intValues[2] = uint256(int256(_intValues[2]) - (_partDiff * int256(crabPartMultiplier[_xenograftPart])));
1320     
1321     _values = new uint256[](6);
1322     _keys = new bytes32[](6);
1323 
1324     // Gene pair
1325     _keys[0] = keccak256(abi.encodePacked(_recipientTokenId, "gene"));
1326     _values[0] = _intValues[2];
1327 
1328     // Fossil Attribute
1329     _keys[1] = keccak256(abi.encodePacked(_donorTokenId, "fossilAttribute"));
1330     _values[1] = _generateRandomNumber(bytes32(_intValues[2] + _intValues[3] + _xenograftPart), _getUint(FOSSIL_ATTRIBUTE_COUNT)) + 1;
1331 
1332     
1333     // intVar1 will now use to store relic percentage variable
1334     if(isLegendaryPart(_intValues[3], 1)) {
1335       // if body part is legendary 100% become relic
1336       _intValues[7] = 2;
1337     } else {
1338       // Relic percentage will differ depending on the crab type / rarity
1339       _intValues[6] = _getUint(NORMAL_FOSSIL_RELIC_PERCENTAGE);
1340 
1341       if(_donorTokenId <= _getUint(LAST_PIONEER_TOKEN_ID)) {
1342         _intValues[6] = _getUint(PIONEER_FOSSIL_RELIC_PERCENTAGE);
1343       }
1344 
1345       if(isLegendaryPart(_intValues[3], 2) ||
1346         isLegendaryPart(_intValues[3], 3) || isLegendaryPart(_intValues[3], 4)) {
1347         _intValues[6] += _getUint(LEGENDARY_FOSSIL_RELIC_PERCENTAGE);
1348       }
1349 
1350       // Fossil Type
1351       // 1 = Normal Fossil
1352       // 2 = Relic Fossil
1353       _intValues[7] = 1;
1354       if(_generateRandomNumber(bytes32(_intValues[3] + _xenograftPart), 100000) < _intValues[6]) {
1355         _intValues[7] = 2;
1356       }
1357     }
1358 
1359     _keys[2] = keccak256(abi.encodePacked(_donorTokenId, "fossilType"));
1360     _values[2] = _intValues[7];
1361 
1362     // Part Attribute
1363     _keys[3] = keccak256(abi.encodePacked(_recipientTokenId, _xenograftPart, "partBonus"));
1364     _values[3] = _intValues[1];
1365 
1366     // Recipient Level
1367     _keys[4] = keccak256(abi.encodePacked(_recipientTokenId, "level"));
1368     _values[4] = _intValues[9];
1369 
1370     // Recipient Exp
1371     _keys[5] = keccak256(abi.encodePacked(_recipientTokenId, "exp"));
1372     _values[5] = _intValues[10];
1373 
1374     require(cryptantCrabStorage.updateUint256s(_keys, _values));
1375 
1376     _removeCryptantFragments(msg.sender, 5000);
1377 
1378     emit Xenografted(msg.sender, _recipientTokenId, _donorTokenId, _intValues[4], _intValues[5], _intValues[8], _intValues[1], _xenograftPart);
1379   }
1380 
1381   function mutate(uint256 _tokenId, uint256 _partIndex) external {
1382     // token must be owned by sender
1383     require(cryptantCrabToken.ownerOf(_tokenId) == msg.sender);
1384     // body part cannot mutate
1385     require(_partIndex > 1 && _partIndex < 5);
1386 
1387     // here not checking if sender has enough cryptant
1388     // is because _removeCryptantFragments uses safeMath
1389     // to do subtract, so it will revert if it's not enough
1390     _removeCryptantFragments(msg.sender, 1000);
1391 
1392     bytes32[] memory _keys = new bytes32[](5);
1393     _keys[0] = keccak256(abi.encodePacked(_tokenId, "gene"));
1394     _keys[1] = keccak256(abi.encodePacked(_tokenId, "level"));
1395     _keys[2] = keccak256(abi.encodePacked(_tokenId, "exp"));
1396     _keys[3] = keccak256(abi.encodePacked(_tokenId, "mutationCount"));
1397     _keys[4] = keccak256(abi.encodePacked(_tokenId, _partIndex, "partBonus"));
1398 
1399     uint256[] memory _values = new uint256[](5);
1400     (_values[0], _values[1], _values[2], _values[3], , , ) = _getCrabData(_tokenId);
1401 
1402     uint256[] memory _partsGene = new uint256[](5);
1403     uint256 i;
1404     for(i = 1 ; i <= 4 ; i++) {
1405       _partsGene[i] = _values[0] / crabPartMultiplier[i] % 1000;
1406     }
1407 
1408     // mutate starts from 3%, max is 20% which is 170 mutations
1409     if(_values[3] > 170) {
1410       _values[3] = 170;
1411     }
1412 
1413     uint256 newPartGene = genesisCrab.mutateCrabPart(_partIndex, _partsGene[_partIndex], (30 + _values[3]) * 100);
1414 
1415     //generate the new gene
1416     uint256 _oldPartBonus = cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_tokenId, _partIndex, "partBonus")));
1417     uint256 _partGene;  // this variable will be reused by oldGene
1418     uint256 _newGene;
1419     for(i = 1 ; i <= 4 ; i++) {
1420       _partGene = _partsGene[i];
1421 
1422       if(i == _partIndex) {
1423         _partGene = newPartGene;
1424       }
1425 
1426       _newGene += _partGene * crabPartMultiplier[i];
1427     }
1428 
1429     if(isLegendaryPart(_newGene, _partIndex)) {
1430       _values[4] = _generateRandomNumber(bytes32(_newGene + _partIndex + _tokenId), _getUint(LEGENDARY_BONUS_COUNT)) + 1;
1431     }
1432 
1433     // Reuse partGene as old gene
1434     _partGene = _values[0];
1435 
1436     // New Gene
1437     _values[0] = _newGene;
1438 
1439     // Increase Exp
1440     _values[2] += 8;
1441 
1442     // check if crab level up
1443     uint256 _expRequired = expRequiredToReachLevel(_values[1] + 1);
1444     if(_values[2] >=_expRequired) {
1445       // increase level
1446       _values[1] += 1;
1447 
1448       // carry forward extra exp
1449       _values[2] -= _expRequired;
1450 
1451       emit LevelUp(msg.sender, _tokenId, _values[1], _values[2]);
1452     } else {
1453       emit ExpGained(msg.sender, _tokenId, _values[1], _values[2]);
1454     }
1455 
1456     // Increase Mutation Count
1457     _values[3] += 1;
1458 
1459     require(cryptantCrabStorage.updateUint256s(_keys, _values));
1460 
1461     emit Mutated(msg.sender, _tokenId, _partIndex, _partGene, _newGene, _oldPartBonus, _values[4], _values[3]);
1462   }
1463 
1464   function generateBonusForGene(uint256 _gene) external view returns (uint256[] _bonuses) {
1465     _bonuses = new uint256[](4);
1466     uint256[] memory _elements = extractElementsFromGene(_gene);
1467     uint256[] memory _parts = extractPartsFromGene(_gene);    
1468     uint256[] memory _legendaryParts;
1469 
1470     for(uint256 i = 0 ; i < 4 ; i++) {
1471       _legendaryParts = legendaryPartIndex[_elements[i]];
1472 
1473       for(uint256 j = 0 ; j < _legendaryParts.length ; j++) {
1474         if(_legendaryParts[j] == _parts[i]) {
1475           // generate the bonus number and add it into the _bonuses array
1476           _bonuses[i] = _generateRandomNumber(bytes32(_gene + i), _getUint(LEGENDARY_BONUS_COUNT)) + 1;
1477           break;
1478         }
1479       }
1480     }
1481   }
1482 
1483   /**
1484    * @dev checks if the specified part of the given gene is a legendary part or not
1485    * returns true if its a legendary part, false otherwise.
1486    * @param _gene full body gene to be checked on
1487    * @param _part partIndex ranging from 1 = body, 2 = legs, 3 = left claw, 4 = right claw
1488    */
1489   function isLegendaryPart(uint256 _gene, uint256 _part) internal view returns (bool) {
1490     uint256[] memory _legendaryParts = legendaryPartIndex[extractElementsFromGene(_gene)[_part - 1]];
1491     for(uint256 i = 0 ; i < _legendaryParts.length ; i++) {
1492       if(_legendaryParts[i] == extractPartsFromGene(_gene)[_part - 1]) {
1493         return true;
1494       }
1495     }
1496     return false;
1497   }
1498 }
1499 
1500 contract Withdrawable is Ownable {
1501   address public withdrawer;
1502 
1503   /**
1504    * @dev Throws if called by any account other than the withdrawer.
1505    */
1506   modifier onlyWithdrawer() {
1507     require(msg.sender == withdrawer);
1508     _;
1509   }
1510 
1511   function setWithdrawer(address _newWithdrawer) external onlyOwner {
1512     withdrawer = _newWithdrawer;
1513   }
1514 
1515   /**
1516    * @dev withdraw the specified amount of ether from contract.
1517    * @param _amount the amount of ether to withdraw. Units in wei.
1518    */
1519   function withdraw(uint256 _amount) external onlyWithdrawer returns(bool) {
1520     require(_amount <= address(this).balance);
1521     withdrawer.transfer(_amount);
1522     return true;
1523   }
1524 }
1525 
1526 contract CryptantCrabMarket is CryptantCrabPurchasableLaunch, GeneSurgeon, Randomable, Withdrawable {
1527   event Purchased(address indexed owner, uint256 amount, uint256 cryptant, uint256 refund);
1528   event ReferralPurchase(address indexed referral, uint256 rewardAmount, address buyer);
1529   event CrabOnSaleStarted(address indexed seller, uint256 tokenId, uint256 sellingPrice, uint256 marketId, uint256 gene);
1530   event CrabOnSaleCancelled(address indexed seller, uint256 tokenId, uint256 marketId);
1531   event Traded(address indexed seller, address indexed buyer, uint256 tokenId, uint256 tradedPrice, uint256 marketId);   // Trade Type 0 = Purchase
1532 
1533   struct MarketItem {
1534     uint256 tokenId;
1535     uint256 sellingPrice;
1536     address seller;
1537     uint8 state;              // 1 - on going, 2 - cancelled, 3 - completed
1538   }
1539 
1540   PrizePool public prizePool;
1541 
1542   /**
1543    * @dev Pre-generated keys to save gas
1544    * keys are generated with:
1545    * MARKET_PRICE_UPDATE_PERIOD = bytes4(keccak256("marketPriceUpdatePeriod"))  = 0xf1305a10
1546    * CURRENT_TOKEN_ID           = bytes4(keccak256("currentTokenId"))           = 0x21339464
1547    * REFERRAL_CUT               = bytes4(keccak256("referralCut"))              = 0x40b0b13e
1548    * PURCHASE_PRIZE_POOL_CUT    = bytes4(keccak256("purchasePrizePoolCut"))     = 0x7625c58a
1549    * EXCHANGE_PRIZE_POOL_CUT    = bytes4(keccak256("exchangePrizePoolCut"))     = 0xb9e1adb0
1550    * EXCHANGE_DEVELOPER_CUT     = bytes4(keccak256("exchangeDeveloperCut"))     = 0xfe9ad0eb
1551    * LAST_TRANSACTION_PERIOD    = bytes4(keccak256("lastTransactionPeriod"))    = 0x1a01d5bb
1552    * LAST_TRANSACTION_PRICE     = bytes4(keccak256("lastTransactionPrice"))     = 0xf14adb6a
1553    */
1554   bytes4 internal constant MARKET_PRICE_UPDATE_PERIOD = 0xf1305a10;
1555   bytes4 internal constant CURRENT_TOKEN_ID = 0x21339464;
1556   bytes4 internal constant REFERRAL_CUT = 0x40b0b13e;
1557   bytes4 internal constant PURCHASE_PRIZE_POOL_CUT = 0x7625c58a;
1558   bytes4 internal constant EXCHANGE_PRIZE_POOL_CUT = 0xb9e1adb0;
1559   bytes4 internal constant EXCHANGE_DEVELOPER_CUT = 0xfe9ad0eb;
1560   bytes4 internal constant LAST_TRANSACTION_PERIOD = 0x1a01d5bb;
1561   bytes4 internal constant LAST_TRANSACTION_PRICE = 0xf14adb6a;
1562 
1563   /**
1564    * @dev The first 25 trading crab price will be fixed to 0.3 ether.
1565    * This only applies to crab bought from developer.
1566    * Crab on auction will depends on the price set by owner.
1567    */
1568   uint256 constant public initialCrabTradingPrice = 300 finney;
1569   
1570   // The initial cryptant price will be fixed to 0.03 ether.
1571   // It will changed to dynamic price after 25 crabs traded.
1572   // 1000 Cryptant Fragment = 1 Cryptant.
1573   uint256 constant public initialCryptantFragmentTradingPrice = 30 szabo;
1574 
1575   mapping(bytes4 => uint256) internal internalUintVariable;
1576 
1577   // All traded price will be stored here
1578   uint256[] public tradedPrices;
1579 
1580   // All auctioned items will be stored here
1581   MarketItem[] public marketItems;
1582 
1583   // PrizePool key, default value is 0xadd5d43f
1584   // 0xadd5d43f = bytes4(keccak256(bytes("firstPrizePool")));
1585   bytes4 public currentPrizePool = 0xadd5d43f;
1586 
1587   constructor
1588   (
1589     address _genesisCrabAddress, 
1590     address _cryptantCrabTokenAddress, 
1591     address _cryptantCrabStorageAddress,
1592     address _transmuterAddress,
1593     address _prizePoolAddress
1594   ) 
1595   public 
1596   CryptantCrabPurchasableLaunch
1597   (
1598     _genesisCrabAddress, 
1599     _cryptantCrabTokenAddress, 
1600     _cryptantCrabStorageAddress,
1601     _transmuterAddress
1602   ) {
1603     // constructor
1604     if(_prizePoolAddress != address(0)) {
1605       _setPrizePoolAddress(_prizePoolAddress);
1606     }
1607     
1608     // set the initial token id
1609     _setUint(CURRENT_TOKEN_ID, 1121);
1610 
1611     // The number of seconds that the market will stay at fixed price. 
1612     // Default set to 4 hours
1613     _setUint(MARKET_PRICE_UPDATE_PERIOD, 14400);
1614 
1615     // The percentage of referral cut
1616     // Default set to 10%
1617     _setUint(REFERRAL_CUT, 10000);
1618 
1619     // The percentage of price pool cut when purchase a new crab
1620     // Default set to 20%
1621     _setUint(PURCHASE_PRIZE_POOL_CUT, 20000);
1622 
1623     // The percentage of prize pool cut when market exchange traded
1624     // Default set to 2%
1625     _setUint(EXCHANGE_PRIZE_POOL_CUT, 2000);
1626 
1627     // The percentage of developer cut
1628     // Default set to 2.8%
1629     _setUint(EXCHANGE_DEVELOPER_CUT, 2800);
1630 
1631     // to prevent marketId = 0
1632     // put a dummy value for it
1633     marketItems.push(MarketItem(0, 0, address(0), 0));
1634   }
1635 
1636   function _setPrizePoolAddress(address _prizePoolAddress) internal {
1637     PrizePool _prizePoolContract = PrizePool(_prizePoolAddress);
1638     prizePool = _prizePoolContract;
1639   }
1640 
1641   function setAddresses(
1642     address _genesisCrabAddress, 
1643     address _cryptantCrabTokenAddress, 
1644     address _cryptantCrabStorageAddress,
1645     address _transmuterAddress,
1646     address _prizePoolAddress
1647   ) 
1648   external onlyOwner {
1649     _setAddresses(_genesisCrabAddress, _cryptantCrabTokenAddress, _cryptantCrabStorageAddress);
1650 
1651     if(_transmuterAddress != address(0)) {
1652       _setTransmuterAddress(_transmuterAddress);
1653     }
1654 
1655     if(_prizePoolAddress != address(0)) {
1656       _setPrizePoolAddress(_prizePoolAddress);
1657     }
1658   }
1659 
1660   function setCurrentPrizePool(bytes4 _newPrizePool) external onlyOwner {
1661     currentPrizePool = _newPrizePool;
1662   }
1663 
1664   function getUint(bytes4 key) external view returns (uint256 value) {
1665     value = _getUint(key);
1666   }
1667 
1668   function setUint(bytes4 key, uint256 value) external onlyOwner {
1669     _setUint(key, value);
1670   }
1671 
1672   function _getUint(bytes4 key) internal view returns (uint256 value) {
1673     value = internalUintVariable[key];
1674   }
1675 
1676   function _setUint(bytes4 key, uint256 value) internal {
1677     internalUintVariable[key] = value;
1678   }
1679 
1680   function purchase(uint256 _crabAmount, uint256 _cryptantFragmentAmount, address _referral) external payable {
1681     require(_crabAmount >= 0 && _crabAmount <= 10 );
1682     require(_cryptantFragmentAmount >= 0 && _cryptantFragmentAmount <= 10000);
1683     require(!(_crabAmount == 0 && _cryptantFragmentAmount == 0));
1684     require(_cryptantFragmentAmount % 1000 == 0);
1685     require(msg.sender != _referral);
1686 
1687     // check if ether payment is enough
1688     uint256 _singleCrabPrice = getCurrentCrabPrice();
1689     uint256 _totalCrabPrice = _singleCrabPrice * _crabAmount;
1690     uint256 _totalCryptantPrice = getCurrentCryptantFragmentPrice() * _cryptantFragmentAmount;
1691     uint256 _cryptantFragmentsGained = _cryptantFragmentAmount;
1692 
1693     // free 2 cryptant when purchasing 10
1694     if(_cryptantFragmentsGained == 10000) {
1695       _cryptantFragmentsGained += 2000;
1696     }
1697 
1698     uint256 _totalPrice = _totalCrabPrice + _totalCryptantPrice;
1699     uint256 _value = msg.value;
1700 
1701     require(_value >= _totalPrice);
1702 
1703     // Purchase 10 crabs will have 1 crab with legendary part
1704     // Default value for _crabWithLegendaryPart is just a unreacable number
1705     uint256 _currentTokenId = _getUint(CURRENT_TOKEN_ID);
1706     uint256 _crabWithLegendaryPart = 100;
1707     if(_crabAmount == 10) {
1708       // decide which crab will have the legendary part
1709       _crabWithLegendaryPart = _generateRandomNumber(bytes32(_currentTokenId), 10);
1710     }
1711 
1712     for(uint256 i = 0 ; i < _crabAmount ; i++) {
1713       // 5000 ~ 5500 is gift token
1714       // so if hit 5000 will skip to 5500 onwards
1715       if(_currentTokenId == 5000) {
1716         _currentTokenId = 5500;
1717       }
1718 
1719       _currentTokenId++;
1720       _createCrab(_currentTokenId, _singleCrabPrice, 0, 0, _crabWithLegendaryPart == i);
1721       tradedPrices.push(_singleCrabPrice);
1722     }
1723 
1724     if(_cryptantFragmentsGained > 0) {
1725       _addCryptantFragments(msg.sender, (_cryptantFragmentsGained));
1726     }
1727 
1728     _setUint(CURRENT_TOKEN_ID, _currentTokenId);
1729     
1730     // Refund exceeded value
1731     _refundExceededValue(_value, _totalPrice);
1732 
1733     // If there's referral, will transfer the referral reward to the referral
1734     if(_referral != address(0)) {
1735       uint256 _referralReward = _totalPrice * _getUint(REFERRAL_CUT) / 100000;
1736       _referral.transfer(_referralReward);
1737       emit ReferralPurchase(_referral, _referralReward, msg.sender);
1738     }
1739 
1740     // Send prize pool cut to prize pool
1741     uint256 _prizePoolAmount = _totalPrice * _getUint(PURCHASE_PRIZE_POOL_CUT) / 100000;
1742     prizePool.increasePrizePool.value(_prizePoolAmount)(currentPrizePool);
1743 
1744     _setUint(LAST_TRANSACTION_PERIOD, now / _getUint(MARKET_PRICE_UPDATE_PERIOD));
1745     _setUint(LAST_TRANSACTION_PRICE, _singleCrabPrice);
1746 
1747     emit Purchased(msg.sender, _crabAmount, _cryptantFragmentsGained, _value - _totalPrice);
1748   }
1749 
1750   function getCurrentPeriod() external view returns (uint256 _now, uint256 _currentPeriod) {
1751     _now = now;
1752     _currentPeriod = now / _getUint(MARKET_PRICE_UPDATE_PERIOD);
1753   }
1754 
1755   function getCurrentCrabPrice() public view returns (uint256) {
1756     if(totalCrabTraded() > 25) {
1757       uint256 _lastTransactionPeriod = _getUint(LAST_TRANSACTION_PERIOD);
1758       uint256 _lastTransactionPrice = _getUint(LAST_TRANSACTION_PRICE);
1759 
1760       if(_lastTransactionPeriod == now / _getUint(MARKET_PRICE_UPDATE_PERIOD) && _lastTransactionPrice != 0) {
1761         return _lastTransactionPrice;
1762       } else {
1763         uint256 totalPrice;
1764         for(uint256 i = 1 ; i <= 15 ; i++) {
1765           totalPrice += tradedPrices[tradedPrices.length - i];
1766         }
1767 
1768         // the actual calculation here is:
1769         // average price = totalPrice / 15
1770         return totalPrice / 15;
1771       }
1772     } else {
1773       return initialCrabTradingPrice;
1774     }
1775   }
1776 
1777   function getCurrentCryptantFragmentPrice() public view returns (uint256 _price) {
1778     if(totalCrabTraded() > 25) {
1779       // real calculation is 1 Cryptant = 10% of currentCrabPrice
1780       // should be written as getCurrentCrabPrice() * 10 / 100 / 1000
1781       return getCurrentCrabPrice() * 10 / 100000;
1782     } else {
1783       return initialCryptantFragmentTradingPrice;
1784     }
1785   }
1786 
1787   // After pre-sale crab tracking (excluding fossil transactions)
1788   function totalCrabTraded() public view returns (uint256) {
1789     return tradedPrices.length;
1790   }
1791 
1792   function sellCrab(uint256 _tokenId, uint256 _sellingPrice) external {
1793     require(cryptantCrabToken.ownerOf(_tokenId) == msg.sender);
1794     require(_sellingPrice >= 50 finney && _sellingPrice <= 100 ether);
1795 
1796     marketItems.push(MarketItem(_tokenId, _sellingPrice, msg.sender, 1));
1797 
1798     // escrow
1799     cryptantCrabToken.transferFrom(msg.sender, address(this), _tokenId);
1800 
1801     uint256 _gene = _geneOfCrab(_tokenId);
1802 
1803     emit CrabOnSaleStarted(msg.sender, _tokenId, _sellingPrice, marketItems.length - 1, _gene);
1804   }
1805 
1806   function cancelOnSaleCrab(uint256 _marketId) external {
1807     MarketItem storage marketItem = marketItems[_marketId];
1808 
1809     // Only able to cancel on sale Item
1810     require(marketItem.state == 1);
1811 
1812     // Set Market Item state to 2(Cancelled)
1813     marketItem.state = 2;
1814 
1815     // Only owner can cancel on sale item
1816     require(marketItem.seller == msg.sender);
1817 
1818     // Release escrow to the owner
1819     cryptantCrabToken.transferFrom(address(this), msg.sender, marketItem.tokenId);
1820 
1821     emit CrabOnSaleCancelled(msg.sender, marketItem.tokenId, _marketId);
1822   }
1823 
1824   function buyCrab(uint256 _marketId) external payable {
1825     MarketItem storage marketItem = marketItems[_marketId];
1826     require(marketItem.state == 1);   // make sure the sale is on going
1827     require(marketItem.sellingPrice == msg.value);
1828     require(marketItem.seller != msg.sender);
1829 
1830     cryptantCrabToken.safeTransferFrom(address(this), msg.sender, marketItem.tokenId);
1831 
1832     uint256 _developerCut = msg.value * _getUint(EXCHANGE_DEVELOPER_CUT) / 100000;
1833     uint256 _prizePoolCut = msg.value * _getUint(EXCHANGE_PRIZE_POOL_CUT) / 100000;
1834     uint256 _sellerAmount = msg.value - _developerCut - _prizePoolCut;
1835     marketItem.seller.transfer(_sellerAmount);
1836 
1837     // Send prize pool cut to prize pool
1838     prizePool.increasePrizePool.value(_prizePoolCut)(currentPrizePool);
1839 
1840     uint256 _fossilType = cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(marketItem.tokenId, "fossilType")));
1841     if(_fossilType > 0) {
1842       tradedPrices.push(marketItem.sellingPrice);
1843     }
1844 
1845     marketItem.state = 3;
1846 
1847     _setUint(LAST_TRANSACTION_PERIOD, now / _getUint(MARKET_PRICE_UPDATE_PERIOD));
1848     _setUint(LAST_TRANSACTION_PRICE, getCurrentCrabPrice());
1849 
1850     emit Traded(marketItem.seller, msg.sender, marketItem.tokenId, marketItem.sellingPrice, _marketId);
1851   }
1852 
1853   function() public payable {
1854     revert();
1855   }
1856 }
1857 
1858 contract HasNoEther is Ownable {
1859 
1860   /**
1861   * @dev Constructor that rejects incoming Ether
1862   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
1863   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
1864   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
1865   * we could use assembly to access msg.value.
1866   */
1867   constructor() public payable {
1868     require(msg.value == 0);
1869   }
1870 
1871   /**
1872    * @dev Disallows direct send by settings a default function without the `payable` flag.
1873    */
1874   function() external {
1875   }
1876 
1877   /**
1878    * @dev Transfer all Ether held by the contract to the owner.
1879    */
1880   function reclaimEther() external onlyOwner {
1881     owner.transfer(address(this).balance);
1882   }
1883 }
1884 
1885 contract RBAC {
1886   using Roles for Roles.Role;
1887 
1888   mapping (string => Roles.Role) private roles;
1889 
1890   event RoleAdded(address indexed operator, string role);
1891   event RoleRemoved(address indexed operator, string role);
1892 
1893   /**
1894    * @dev reverts if addr does not have role
1895    * @param _operator address
1896    * @param _role the name of the role
1897    * // reverts
1898    */
1899   function checkRole(address _operator, string _role)
1900     view
1901     public
1902   {
1903     roles[_role].check(_operator);
1904   }
1905 
1906   /**
1907    * @dev determine if addr has role
1908    * @param _operator address
1909    * @param _role the name of the role
1910    * @return bool
1911    */
1912   function hasRole(address _operator, string _role)
1913     view
1914     public
1915     returns (bool)
1916   {
1917     return roles[_role].has(_operator);
1918   }
1919 
1920   /**
1921    * @dev add a role to an address
1922    * @param _operator address
1923    * @param _role the name of the role
1924    */
1925   function addRole(address _operator, string _role)
1926     internal
1927   {
1928     roles[_role].add(_operator);
1929     emit RoleAdded(_operator, _role);
1930   }
1931 
1932   /**
1933    * @dev remove a role from an address
1934    * @param _operator address
1935    * @param _role the name of the role
1936    */
1937   function removeRole(address _operator, string _role)
1938     internal
1939   {
1940     roles[_role].remove(_operator);
1941     emit RoleRemoved(_operator, _role);
1942   }
1943 
1944   /**
1945    * @dev modifier to scope access to a single role (uses msg.sender as addr)
1946    * @param _role the name of the role
1947    * // reverts
1948    */
1949   modifier onlyRole(string _role)
1950   {
1951     checkRole(msg.sender, _role);
1952     _;
1953   }
1954 
1955   /**
1956    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
1957    * @param _roles the names of the roles to scope access to
1958    * // reverts
1959    *
1960    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
1961    *  see: https://github.com/ethereum/solidity/issues/2467
1962    */
1963   // modifier onlyRoles(string[] _roles) {
1964   //     bool hasAnyRole = false;
1965   //     for (uint8 i = 0; i < _roles.length; i++) {
1966   //         if (hasRole(msg.sender, _roles[i])) {
1967   //             hasAnyRole = true;
1968   //             break;
1969   //         }
1970   //     }
1971 
1972   //     require(hasAnyRole);
1973 
1974   //     _;
1975   // }
1976 }
1977 
1978 contract Whitelist is Ownable, RBAC {
1979   string public constant ROLE_WHITELISTED = "whitelist";
1980 
1981   /**
1982    * @dev Throws if operator is not whitelisted.
1983    * @param _operator address
1984    */
1985   modifier onlyIfWhitelisted(address _operator) {
1986     checkRole(_operator, ROLE_WHITELISTED);
1987     _;
1988   }
1989 
1990   /**
1991    * @dev add an address to the whitelist
1992    * @param _operator address
1993    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1994    */
1995   function addAddressToWhitelist(address _operator)
1996     onlyOwner
1997     public
1998   {
1999     addRole(_operator, ROLE_WHITELISTED);
2000   }
2001 
2002   /**
2003    * @dev getter to determine if address is in whitelist
2004    */
2005   function whitelist(address _operator)
2006     public
2007     view
2008     returns (bool)
2009   {
2010     return hasRole(_operator, ROLE_WHITELISTED);
2011   }
2012 
2013   /**
2014    * @dev add addresses to the whitelist
2015    * @param _operators addresses
2016    * @return true if at least one address was added to the whitelist,
2017    * false if all addresses were already in the whitelist
2018    */
2019   function addAddressesToWhitelist(address[] _operators)
2020     onlyOwner
2021     public
2022   {
2023     for (uint256 i = 0; i < _operators.length; i++) {
2024       addAddressToWhitelist(_operators[i]);
2025     }
2026   }
2027 
2028   /**
2029    * @dev remove an address from the whitelist
2030    * @param _operator address
2031    * @return true if the address was removed from the whitelist,
2032    * false if the address wasn't in the whitelist in the first place
2033    */
2034   function removeAddressFromWhitelist(address _operator)
2035     onlyOwner
2036     public
2037   {
2038     removeRole(_operator, ROLE_WHITELISTED);
2039   }
2040 
2041   /**
2042    * @dev remove addresses from the whitelist
2043    * @param _operators addresses
2044    * @return true if at least one address was removed from the whitelist,
2045    * false if all addresses weren't in the whitelist in the first place
2046    */
2047   function removeAddressesFromWhitelist(address[] _operators)
2048     onlyOwner
2049     public
2050   {
2051     for (uint256 i = 0; i < _operators.length; i++) {
2052       removeAddressFromWhitelist(_operators[i]);
2053     }
2054   }
2055 
2056 }
2057 
2058 contract PrizePool is Ownable, Whitelist, HasNoEther {
2059   event PrizePoolIncreased(uint256 amountIncreased, bytes4 prizePool, uint256 currentAmount);
2060   event WinnerAdded(address winner, bytes4 prizeTitle, uint256 claimableAmount);
2061   event PrizedClaimed(address winner, bytes4 prizeTitle, uint256 claimedAmount);
2062 
2063   // prizePool key => prizePool accumulated amount
2064   // this is just to track how much a prizePool has
2065   mapping(bytes4 => uint256) prizePools;
2066 
2067   // winner's address => prize title => amount
2068   // prize title itself need to be able to determine
2069   // the prize pool it is from
2070   mapping(address => mapping(bytes4 => uint256)) winners;
2071 
2072   constructor() public {
2073 
2074   }
2075 
2076   function increasePrizePool(bytes4 _prizePool) external payable onlyIfWhitelisted(msg.sender) {
2077     prizePools[_prizePool] += msg.value;
2078 
2079     emit PrizePoolIncreased(msg.value, _prizePool, prizePools[_prizePool]);
2080   }
2081 
2082   function addWinner(address _winner, bytes4 _prizeTitle, uint256 _claimableAmount) external onlyIfWhitelisted(msg.sender) {
2083     winners[_winner][_prizeTitle] = _claimableAmount;
2084 
2085     emit WinnerAdded(_winner, _prizeTitle, _claimableAmount);
2086   }
2087 
2088   function claimPrize(bytes4 _prizeTitle) external {
2089     uint256 _claimableAmount = winners[msg.sender][_prizeTitle];
2090 
2091     require(_claimableAmount > 0);
2092 
2093     msg.sender.transfer(_claimableAmount);
2094 
2095     winners[msg.sender][_prizeTitle] = 0;
2096 
2097     emit PrizedClaimed(msg.sender, _prizeTitle, _claimableAmount);
2098   }
2099 
2100   function claimableAmount(address _winner, bytes4 _prizeTitle) external view returns (uint256 _claimableAmount) {
2101     _claimableAmount = winners[_winner][_prizeTitle];
2102   }
2103 
2104   function prizePoolTotal(bytes4 _prizePool) external view returns (uint256 _prizePoolTotal) {
2105     _prizePoolTotal = prizePools[_prizePool];
2106   }
2107 }
2108 
2109 library Roles {
2110   struct Role {
2111     mapping (address => bool) bearer;
2112   }
2113 
2114   /**
2115    * @dev give an address access to this role
2116    */
2117   function add(Role storage role, address addr)
2118     internal
2119   {
2120     role.bearer[addr] = true;
2121   }
2122 
2123   /**
2124    * @dev remove an address' access to this role
2125    */
2126   function remove(Role storage role, address addr)
2127     internal
2128   {
2129     role.bearer[addr] = false;
2130   }
2131 
2132   /**
2133    * @dev check if an address has this role
2134    * // reverts
2135    */
2136   function check(Role storage role, address addr)
2137     view
2138     internal
2139   {
2140     require(has(role, addr));
2141   }
2142 
2143   /**
2144    * @dev check if an address has this role
2145    * @return bool
2146    */
2147   function has(Role storage role, address addr)
2148     view
2149     internal
2150     returns (bool)
2151   {
2152     return role.bearer[addr];
2153   }
2154 }
2155 
2156 contract ERC721Basic is ERC165 {
2157   event Transfer(
2158     address indexed _from,
2159     address indexed _to,
2160     uint256 indexed _tokenId
2161   );
2162   event Approval(
2163     address indexed _owner,
2164     address indexed _approved,
2165     uint256 indexed _tokenId
2166   );
2167   event ApprovalForAll(
2168     address indexed _owner,
2169     address indexed _operator,
2170     bool _approved
2171   );
2172 
2173   function balanceOf(address _owner) public view returns (uint256 _balance);
2174   function ownerOf(uint256 _tokenId) public view returns (address _owner);
2175   function exists(uint256 _tokenId) public view returns (bool _exists);
2176 
2177   function approve(address _to, uint256 _tokenId) public;
2178   function getApproved(uint256 _tokenId)
2179     public view returns (address _operator);
2180 
2181   function setApprovalForAll(address _operator, bool _approved) public;
2182   function isApprovedForAll(address _owner, address _operator)
2183     public view returns (bool);
2184 
2185   function transferFrom(address _from, address _to, uint256 _tokenId) public;
2186   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
2187     public;
2188 
2189   function safeTransferFrom(
2190     address _from,
2191     address _to,
2192     uint256 _tokenId,
2193     bytes _data
2194   )
2195     public;
2196 }
2197 
2198 contract ERC721Enumerable is ERC721Basic {
2199   function totalSupply() public view returns (uint256);
2200   function tokenOfOwnerByIndex(
2201     address _owner,
2202     uint256 _index
2203   )
2204     public
2205     view
2206     returns (uint256 _tokenId);
2207 
2208   function tokenByIndex(uint256 _index) public view returns (uint256);
2209 }
2210 
2211 contract ERC721Metadata is ERC721Basic {
2212   function name() external view returns (string _name);
2213   function symbol() external view returns (string _symbol);
2214   function tokenURI(uint256 _tokenId) public view returns (string);
2215 }
2216 
2217 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
2218 }
2219 
2220 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
2221 
2222   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
2223   /*
2224    * 0x80ac58cd ===
2225    *   bytes4(keccak256('balanceOf(address)')) ^
2226    *   bytes4(keccak256('ownerOf(uint256)')) ^
2227    *   bytes4(keccak256('approve(address,uint256)')) ^
2228    *   bytes4(keccak256('getApproved(uint256)')) ^
2229    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
2230    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
2231    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
2232    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
2233    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
2234    */
2235 
2236   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
2237   /*
2238    * 0x4f558e79 ===
2239    *   bytes4(keccak256('exists(uint256)'))
2240    */
2241 
2242   using SafeMath for uint256;
2243   using AddressUtils for address;
2244 
2245   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
2246   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
2247   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
2248 
2249   // Mapping from token ID to owner
2250   mapping (uint256 => address) internal tokenOwner;
2251 
2252   // Mapping from token ID to approved address
2253   mapping (uint256 => address) internal tokenApprovals;
2254 
2255   // Mapping from owner to number of owned token
2256   mapping (address => uint256) internal ownedTokensCount;
2257 
2258   // Mapping from owner to operator approvals
2259   mapping (address => mapping (address => bool)) internal operatorApprovals;
2260 
2261   /**
2262    * @dev Guarantees msg.sender is owner of the given token
2263    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
2264    */
2265   modifier onlyOwnerOf(uint256 _tokenId) {
2266     require(ownerOf(_tokenId) == msg.sender);
2267     _;
2268   }
2269 
2270   /**
2271    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
2272    * @param _tokenId uint256 ID of the token to validate
2273    */
2274   modifier canTransfer(uint256 _tokenId) {
2275     require(isApprovedOrOwner(msg.sender, _tokenId));
2276     _;
2277   }
2278 
2279   constructor()
2280     public
2281   {
2282     // register the supported interfaces to conform to ERC721 via ERC165
2283     _registerInterface(InterfaceId_ERC721);
2284     _registerInterface(InterfaceId_ERC721Exists);
2285   }
2286 
2287   /**
2288    * @dev Gets the balance of the specified address
2289    * @param _owner address to query the balance of
2290    * @return uint256 representing the amount owned by the passed address
2291    */
2292   function balanceOf(address _owner) public view returns (uint256) {
2293     require(_owner != address(0));
2294     return ownedTokensCount[_owner];
2295   }
2296 
2297   /**
2298    * @dev Gets the owner of the specified token ID
2299    * @param _tokenId uint256 ID of the token to query the owner of
2300    * @return owner address currently marked as the owner of the given token ID
2301    */
2302   function ownerOf(uint256 _tokenId) public view returns (address) {
2303     address owner = tokenOwner[_tokenId];
2304     require(owner != address(0));
2305     return owner;
2306   }
2307 
2308   /**
2309    * @dev Returns whether the specified token exists
2310    * @param _tokenId uint256 ID of the token to query the existence of
2311    * @return whether the token exists
2312    */
2313   function exists(uint256 _tokenId) public view returns (bool) {
2314     address owner = tokenOwner[_tokenId];
2315     return owner != address(0);
2316   }
2317 
2318   /**
2319    * @dev Approves another address to transfer the given token ID
2320    * The zero address indicates there is no approved address.
2321    * There can only be one approved address per token at a given time.
2322    * Can only be called by the token owner or an approved operator.
2323    * @param _to address to be approved for the given token ID
2324    * @param _tokenId uint256 ID of the token to be approved
2325    */
2326   function approve(address _to, uint256 _tokenId) public {
2327     address owner = ownerOf(_tokenId);
2328     require(_to != owner);
2329     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
2330 
2331     tokenApprovals[_tokenId] = _to;
2332     emit Approval(owner, _to, _tokenId);
2333   }
2334 
2335   /**
2336    * @dev Gets the approved address for a token ID, or zero if no address set
2337    * @param _tokenId uint256 ID of the token to query the approval of
2338    * @return address currently approved for the given token ID
2339    */
2340   function getApproved(uint256 _tokenId) public view returns (address) {
2341     return tokenApprovals[_tokenId];
2342   }
2343 
2344   /**
2345    * @dev Sets or unsets the approval of a given operator
2346    * An operator is allowed to transfer all tokens of the sender on their behalf
2347    * @param _to operator address to set the approval
2348    * @param _approved representing the status of the approval to be set
2349    */
2350   function setApprovalForAll(address _to, bool _approved) public {
2351     require(_to != msg.sender);
2352     operatorApprovals[msg.sender][_to] = _approved;
2353     emit ApprovalForAll(msg.sender, _to, _approved);
2354   }
2355 
2356   /**
2357    * @dev Tells whether an operator is approved by a given owner
2358    * @param _owner owner address which you want to query the approval of
2359    * @param _operator operator address which you want to query the approval of
2360    * @return bool whether the given operator is approved by the given owner
2361    */
2362   function isApprovedForAll(
2363     address _owner,
2364     address _operator
2365   )
2366     public
2367     view
2368     returns (bool)
2369   {
2370     return operatorApprovals[_owner][_operator];
2371   }
2372 
2373   /**
2374    * @dev Transfers the ownership of a given token ID to another address
2375    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
2376    * Requires the msg sender to be the owner, approved, or operator
2377    * @param _from current owner of the token
2378    * @param _to address to receive the ownership of the given token ID
2379    * @param _tokenId uint256 ID of the token to be transferred
2380   */
2381   function transferFrom(
2382     address _from,
2383     address _to,
2384     uint256 _tokenId
2385   )
2386     public
2387     canTransfer(_tokenId)
2388   {
2389     require(_from != address(0));
2390     require(_to != address(0));
2391 
2392     clearApproval(_from, _tokenId);
2393     removeTokenFrom(_from, _tokenId);
2394     addTokenTo(_to, _tokenId);
2395 
2396     emit Transfer(_from, _to, _tokenId);
2397   }
2398 
2399   /**
2400    * @dev Safely transfers the ownership of a given token ID to another address
2401    * If the target address is a contract, it must implement `onERC721Received`,
2402    * which is called upon a safe transfer, and return the magic value
2403    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
2404    * the transfer is reverted.
2405    *
2406    * Requires the msg sender to be the owner, approved, or operator
2407    * @param _from current owner of the token
2408    * @param _to address to receive the ownership of the given token ID
2409    * @param _tokenId uint256 ID of the token to be transferred
2410   */
2411   function safeTransferFrom(
2412     address _from,
2413     address _to,
2414     uint256 _tokenId
2415   )
2416     public
2417     canTransfer(_tokenId)
2418   {
2419     // solium-disable-next-line arg-overflow
2420     safeTransferFrom(_from, _to, _tokenId, "");
2421   }
2422 
2423   /**
2424    * @dev Safely transfers the ownership of a given token ID to another address
2425    * If the target address is a contract, it must implement `onERC721Received`,
2426    * which is called upon a safe transfer, and return the magic value
2427    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
2428    * the transfer is reverted.
2429    * Requires the msg sender to be the owner, approved, or operator
2430    * @param _from current owner of the token
2431    * @param _to address to receive the ownership of the given token ID
2432    * @param _tokenId uint256 ID of the token to be transferred
2433    * @param _data bytes data to send along with a safe transfer check
2434    */
2435   function safeTransferFrom(
2436     address _from,
2437     address _to,
2438     uint256 _tokenId,
2439     bytes _data
2440   )
2441     public
2442     canTransfer(_tokenId)
2443   {
2444     transferFrom(_from, _to, _tokenId);
2445     // solium-disable-next-line arg-overflow
2446     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
2447   }
2448 
2449   /**
2450    * @dev Returns whether the given spender can transfer a given token ID
2451    * @param _spender address of the spender to query
2452    * @param _tokenId uint256 ID of the token to be transferred
2453    * @return bool whether the msg.sender is approved for the given token ID,
2454    *  is an operator of the owner, or is the owner of the token
2455    */
2456   function isApprovedOrOwner(
2457     address _spender,
2458     uint256 _tokenId
2459   )
2460     internal
2461     view
2462     returns (bool)
2463   {
2464     address owner = ownerOf(_tokenId);
2465     // Disable solium check because of
2466     // https://github.com/duaraghav8/Solium/issues/175
2467     // solium-disable-next-line operator-whitespace
2468     return (
2469       _spender == owner ||
2470       getApproved(_tokenId) == _spender ||
2471       isApprovedForAll(owner, _spender)
2472     );
2473   }
2474 
2475   /**
2476    * @dev Internal function to mint a new token
2477    * Reverts if the given token ID already exists
2478    * @param _to The address that will own the minted token
2479    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
2480    */
2481   function _mint(address _to, uint256 _tokenId) internal {
2482     require(_to != address(0));
2483     addTokenTo(_to, _tokenId);
2484     emit Transfer(address(0), _to, _tokenId);
2485   }
2486 
2487   /**
2488    * @dev Internal function to burn a specific token
2489    * Reverts if the token does not exist
2490    * @param _tokenId uint256 ID of the token being burned by the msg.sender
2491    */
2492   function _burn(address _owner, uint256 _tokenId) internal {
2493     clearApproval(_owner, _tokenId);
2494     removeTokenFrom(_owner, _tokenId);
2495     emit Transfer(_owner, address(0), _tokenId);
2496   }
2497 
2498   /**
2499    * @dev Internal function to clear current approval of a given token ID
2500    * Reverts if the given address is not indeed the owner of the token
2501    * @param _owner owner of the token
2502    * @param _tokenId uint256 ID of the token to be transferred
2503    */
2504   function clearApproval(address _owner, uint256 _tokenId) internal {
2505     require(ownerOf(_tokenId) == _owner);
2506     if (tokenApprovals[_tokenId] != address(0)) {
2507       tokenApprovals[_tokenId] = address(0);
2508     }
2509   }
2510 
2511   /**
2512    * @dev Internal function to add a token ID to the list of a given address
2513    * @param _to address representing the new owner of the given token ID
2514    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
2515    */
2516   function addTokenTo(address _to, uint256 _tokenId) internal {
2517     require(tokenOwner[_tokenId] == address(0));
2518     tokenOwner[_tokenId] = _to;
2519     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
2520   }
2521 
2522   /**
2523    * @dev Internal function to remove a token ID from the list of a given address
2524    * @param _from address representing the previous owner of the given token ID
2525    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
2526    */
2527   function removeTokenFrom(address _from, uint256 _tokenId) internal {
2528     require(ownerOf(_tokenId) == _from);
2529     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
2530     tokenOwner[_tokenId] = address(0);
2531   }
2532 
2533   /**
2534    * @dev Internal function to invoke `onERC721Received` on a target address
2535    * The call is not executed if the target address is not a contract
2536    * @param _from address representing the previous owner of the given token ID
2537    * @param _to target address that will receive the tokens
2538    * @param _tokenId uint256 ID of the token to be transferred
2539    * @param _data bytes optional data to send along with the call
2540    * @return whether the call correctly returned the expected magic value
2541    */
2542   function checkAndCallSafeTransfer(
2543     address _from,
2544     address _to,
2545     uint256 _tokenId,
2546     bytes _data
2547   )
2548     internal
2549     returns (bool)
2550   {
2551     if (!_to.isContract()) {
2552       return true;
2553     }
2554     bytes4 retval = ERC721Receiver(_to).onERC721Received(
2555       msg.sender, _from, _tokenId, _data);
2556     return (retval == ERC721_RECEIVED);
2557   }
2558 }
2559 
2560 contract ERC721Receiver {
2561   /**
2562    * @dev Magic value to be returned upon successful reception of an NFT
2563    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
2564    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
2565    */
2566   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
2567 
2568   /**
2569    * @notice Handle the receipt of an NFT
2570    * @dev The ERC721 smart contract calls this function on the recipient
2571    * after a `safetransfer`. This function MAY throw to revert and reject the
2572    * transfer. Return of other than the magic value MUST result in the 
2573    * transaction being reverted.
2574    * Note: the contract address is always the message sender.
2575    * @param _operator The address which called `safeTransferFrom` function
2576    * @param _from The address which previously owned the token
2577    * @param _tokenId The NFT identifier which is being transfered
2578    * @param _data Additional data with no specified format
2579    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
2580    */
2581   function onERC721Received(
2582     address _operator,
2583     address _from,
2584     uint256 _tokenId,
2585     bytes _data
2586   )
2587     public
2588     returns(bytes4);
2589 }
2590 
2591 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
2592 
2593   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
2594   /**
2595    * 0x780e9d63 ===
2596    *   bytes4(keccak256('totalSupply()')) ^
2597    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
2598    *   bytes4(keccak256('tokenByIndex(uint256)'))
2599    */
2600 
2601   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
2602   /**
2603    * 0x5b5e139f ===
2604    *   bytes4(keccak256('name()')) ^
2605    *   bytes4(keccak256('symbol()')) ^
2606    *   bytes4(keccak256('tokenURI(uint256)'))
2607    */
2608 
2609   // Token name
2610   string internal name_;
2611 
2612   // Token symbol
2613   string internal symbol_;
2614 
2615   // Mapping from owner to list of owned token IDs
2616   mapping(address => uint256[]) internal ownedTokens;
2617 
2618   // Mapping from token ID to index of the owner tokens list
2619   mapping(uint256 => uint256) internal ownedTokensIndex;
2620 
2621   // Array with all token ids, used for enumeration
2622   uint256[] internal allTokens;
2623 
2624   // Mapping from token id to position in the allTokens array
2625   mapping(uint256 => uint256) internal allTokensIndex;
2626 
2627   // Optional mapping for token URIs
2628   mapping(uint256 => string) internal tokenURIs;
2629 
2630   /**
2631    * @dev Constructor function
2632    */
2633   constructor(string _name, string _symbol) public {
2634     name_ = _name;
2635     symbol_ = _symbol;
2636 
2637     // register the supported interfaces to conform to ERC721 via ERC165
2638     _registerInterface(InterfaceId_ERC721Enumerable);
2639     _registerInterface(InterfaceId_ERC721Metadata);
2640   }
2641 
2642   /**
2643    * @dev Gets the token name
2644    * @return string representing the token name
2645    */
2646   function name() external view returns (string) {
2647     return name_;
2648   }
2649 
2650   /**
2651    * @dev Gets the token symbol
2652    * @return string representing the token symbol
2653    */
2654   function symbol() external view returns (string) {
2655     return symbol_;
2656   }
2657 
2658   /**
2659    * @dev Returns an URI for a given token ID
2660    * Throws if the token ID does not exist. May return an empty string.
2661    * @param _tokenId uint256 ID of the token to query
2662    */
2663   function tokenURI(uint256 _tokenId) public view returns (string) {
2664     require(exists(_tokenId));
2665     return tokenURIs[_tokenId];
2666   }
2667 
2668   /**
2669    * @dev Gets the token ID at a given index of the tokens list of the requested owner
2670    * @param _owner address owning the tokens list to be accessed
2671    * @param _index uint256 representing the index to be accessed of the requested tokens list
2672    * @return uint256 token ID at the given index of the tokens list owned by the requested address
2673    */
2674   function tokenOfOwnerByIndex(
2675     address _owner,
2676     uint256 _index
2677   )
2678     public
2679     view
2680     returns (uint256)
2681   {
2682     require(_index < balanceOf(_owner));
2683     return ownedTokens[_owner][_index];
2684   }
2685 
2686   /**
2687    * @dev Gets the total amount of tokens stored by the contract
2688    * @return uint256 representing the total amount of tokens
2689    */
2690   function totalSupply() public view returns (uint256) {
2691     return allTokens.length;
2692   }
2693 
2694   /**
2695    * @dev Gets the token ID at a given index of all the tokens in this contract
2696    * Reverts if the index is greater or equal to the total number of tokens
2697    * @param _index uint256 representing the index to be accessed of the tokens list
2698    * @return uint256 token ID at the given index of the tokens list
2699    */
2700   function tokenByIndex(uint256 _index) public view returns (uint256) {
2701     require(_index < totalSupply());
2702     return allTokens[_index];
2703   }
2704 
2705   /**
2706    * @dev Internal function to set the token URI for a given token
2707    * Reverts if the token ID does not exist
2708    * @param _tokenId uint256 ID of the token to set its URI
2709    * @param _uri string URI to assign
2710    */
2711   function _setTokenURI(uint256 _tokenId, string _uri) internal {
2712     require(exists(_tokenId));
2713     tokenURIs[_tokenId] = _uri;
2714   }
2715 
2716   /**
2717    * @dev Internal function to add a token ID to the list of a given address
2718    * @param _to address representing the new owner of the given token ID
2719    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
2720    */
2721   function addTokenTo(address _to, uint256 _tokenId) internal {
2722     super.addTokenTo(_to, _tokenId);
2723     uint256 length = ownedTokens[_to].length;
2724     ownedTokens[_to].push(_tokenId);
2725     ownedTokensIndex[_tokenId] = length;
2726   }
2727 
2728   /**
2729    * @dev Internal function to remove a token ID from the list of a given address
2730    * @param _from address representing the previous owner of the given token ID
2731    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
2732    */
2733   function removeTokenFrom(address _from, uint256 _tokenId) internal {
2734     super.removeTokenFrom(_from, _tokenId);
2735 
2736     uint256 tokenIndex = ownedTokensIndex[_tokenId];
2737     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
2738     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
2739 
2740     ownedTokens[_from][tokenIndex] = lastToken;
2741     ownedTokens[_from][lastTokenIndex] = 0;
2742     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
2743     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
2744     // the lastToken to the first position, and then dropping the element placed in the last position of the list
2745 
2746     ownedTokens[_from].length--;
2747     ownedTokensIndex[_tokenId] = 0;
2748     ownedTokensIndex[lastToken] = tokenIndex;
2749   }
2750 
2751   /**
2752    * @dev Internal function to mint a new token
2753    * Reverts if the given token ID already exists
2754    * @param _to address the beneficiary that will own the minted token
2755    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
2756    */
2757   function _mint(address _to, uint256 _tokenId) internal {
2758     super._mint(_to, _tokenId);
2759 
2760     allTokensIndex[_tokenId] = allTokens.length;
2761     allTokens.push(_tokenId);
2762   }
2763 
2764   /**
2765    * @dev Internal function to burn a specific token
2766    * Reverts if the token does not exist
2767    * @param _owner owner of the token to burn
2768    * @param _tokenId uint256 ID of the token being burned by the msg.sender
2769    */
2770   function _burn(address _owner, uint256 _tokenId) internal {
2771     super._burn(_owner, _tokenId);
2772 
2773     // Clear metadata (if any)
2774     if (bytes(tokenURIs[_tokenId]).length != 0) {
2775       delete tokenURIs[_tokenId];
2776     }
2777 
2778     // Reorg all tokens array
2779     uint256 tokenIndex = allTokensIndex[_tokenId];
2780     uint256 lastTokenIndex = allTokens.length.sub(1);
2781     uint256 lastToken = allTokens[lastTokenIndex];
2782 
2783     allTokens[tokenIndex] = lastToken;
2784     allTokens[lastTokenIndex] = 0;
2785 
2786     allTokens.length--;
2787     allTokensIndex[_tokenId] = 0;
2788     allTokensIndex[lastToken] = tokenIndex;
2789   }
2790 
2791 }
2792 
2793 contract CryptantCrabNFT is ERC721Token, Whitelist, CrabData, GeneSurgeon {
2794   event CrabPartAdded(uint256 hp, uint256 dps, uint256 blockAmount);
2795   event GiftTransfered(address indexed _from, address indexed _to, uint256 indexed _tokenId);
2796   event DefaultMetadataURIChanged(string newUri);
2797 
2798   /**
2799    * @dev Pre-generated keys to save gas
2800    * keys are generated with:
2801    * CRAB_BODY       = bytes4(keccak256("crab_body"))       = 0xc398430e
2802    * CRAB_LEG        = bytes4(keccak256("crab_leg"))        = 0x889063b1
2803    * CRAB_LEFT_CLAW  = bytes4(keccak256("crab_left_claw"))  = 0xdb6290a2
2804    * CRAB_RIGHT_CLAW = bytes4(keccak256("crab_right_claw")) = 0x13453f89
2805    */
2806   bytes4 internal constant CRAB_BODY = 0xc398430e;
2807   bytes4 internal constant CRAB_LEG = 0x889063b1;
2808   bytes4 internal constant CRAB_LEFT_CLAW = 0xdb6290a2;
2809   bytes4 internal constant CRAB_RIGHT_CLAW = 0x13453f89;
2810 
2811   /**
2812    * @dev Stores all the crab data
2813    */
2814   mapping(bytes4 => mapping(uint256 => CrabPartData[])) internal crabPartData;
2815 
2816   /**
2817    * @dev Mapping from tokenId to its corresponding special skin
2818    * tokenId with default skin will not be stored. 
2819    */
2820   mapping(uint256 => uint256) internal crabSpecialSkins;
2821 
2822   /**
2823    * @dev default MetadataURI
2824    */
2825   string public defaultMetadataURI = "https://www.cryptantcrab.io/md/";
2826 
2827   constructor(string _name, string _symbol) public ERC721Token(_name, _symbol) {
2828     // constructor
2829     initiateCrabPartData();
2830   }
2831 
2832   /**
2833    * @dev Returns an URI for a given token ID
2834    * Throws if the token ID does not exist.
2835    * Will return the token's metadata URL if it has one, 
2836    * otherwise will just return base on the default metadata URI
2837    * @param _tokenId uint256 ID of the token to query
2838    */
2839   function tokenURI(uint256 _tokenId) public view returns (string) {
2840     require(exists(_tokenId));
2841 
2842     string memory _uri = tokenURIs[_tokenId];
2843 
2844     if(bytes(_uri).length == 0) {
2845       _uri = getMetadataURL(bytes(defaultMetadataURI), _tokenId);
2846     }
2847 
2848     return _uri;
2849   }
2850 
2851   /**
2852    * @dev Returns the data of a specific parts
2853    * @param _partIndex the part to retrieve. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
2854    * @param _element the element of part to retrieve. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
2855    * @param _setIndex the set index of for the specified part. This will starts from 1.
2856    */
2857   function dataOfPart(uint256 _partIndex, uint256 _element, uint256 _setIndex) public view returns (uint256[] memory _resultData) {
2858     bytes4 _key;
2859     if(_partIndex == 1) {
2860       _key = CRAB_BODY;
2861     } else if(_partIndex == 2) {
2862       _key = CRAB_LEG;
2863     } else if(_partIndex == 3) {
2864       _key = CRAB_LEFT_CLAW;
2865     } else if(_partIndex == 4) {
2866       _key = CRAB_RIGHT_CLAW;
2867     } else {
2868       revert();
2869     }
2870 
2871     CrabPartData storage _crabPartData = crabPartData[_key][_element][_setIndex];
2872 
2873     _resultData = crabPartDataToArray(_crabPartData);
2874   }
2875 
2876   /**
2877    * @dev Gift(Transfer) a token to another address. Caller must be token owner
2878    * @param _from current owner of the token
2879    * @param _to address to receive the ownership of the given token ID
2880    * @param _tokenId uint256 ID of the token to be transferred
2881    */
2882   function giftToken(address _from, address _to, uint256 _tokenId) external {
2883     safeTransferFrom(_from, _to, _tokenId);
2884 
2885     emit GiftTransfered(_from, _to, _tokenId);
2886   }
2887 
2888   /**
2889    * @dev External function to mint a new token, for whitelisted address only.
2890    * Reverts if the given token ID already exists
2891    * @param _tokenOwner address the beneficiary that will own the minted token
2892    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
2893    * @param _skinId the skin ID to be applied for all the token minted
2894    */
2895   function mintToken(address _tokenOwner, uint256 _tokenId, uint256 _skinId) external onlyIfWhitelisted(msg.sender) {
2896     super._mint(_tokenOwner, _tokenId);
2897 
2898     if(_skinId > 0) {
2899       crabSpecialSkins[_tokenId] = _skinId;
2900     }
2901   }
2902 
2903   /**
2904    * @dev Returns crab data base on the gene provided
2905    * @param _gene the gene info where crab data will be retrieved base on it
2906    * @return 4 uint arrays:
2907    * 1st Array = Body's Data
2908    * 2nd Array = Leg's Data
2909    * 3rd Array = Left Claw's Data
2910    * 4th Array = Right Claw's Data
2911    */
2912   function crabPartDataFromGene(uint256 _gene) external view returns (
2913     uint256[] _bodyData,
2914     uint256[] _legData,
2915     uint256[] _leftClawData,
2916     uint256[] _rightClawData
2917   ) {
2918     uint256[] memory _parts = extractPartsFromGene(_gene);
2919     uint256[] memory _elements = extractElementsFromGene(_gene);
2920 
2921     _bodyData = dataOfPart(1, _elements[0], _parts[0]);
2922     _legData = dataOfPart(2, _elements[1], _parts[1]);
2923     _leftClawData = dataOfPart(3, _elements[2], _parts[2]);
2924     _rightClawData = dataOfPart(4, _elements[3], _parts[3]);
2925   }
2926 
2927   /**
2928    * @dev For developer to add new parts, notice that this is the only method to add crab data
2929    * so that developer can add extra content. there's no other method for developer to modify
2930    * the data. This is to assure token owner actually owns their data.
2931    * @param _partIndex the part to add. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
2932    * @param _element the element of part to add. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
2933    * @param _partDataArray data of the parts.
2934    */
2935   function setPartData(uint256 _partIndex, uint256 _element, uint256[] _partDataArray) external onlyOwner {
2936     CrabPartData memory _partData = arrayToCrabPartData(_partDataArray);
2937 
2938     bytes4 _key;
2939     if(_partIndex == 1) {
2940       _key = CRAB_BODY;
2941     } else if(_partIndex == 2) {
2942       _key = CRAB_LEG;
2943     } else if(_partIndex == 3) {
2944       _key = CRAB_LEFT_CLAW;
2945     } else if(_partIndex == 4) {
2946       _key = CRAB_RIGHT_CLAW;
2947     }
2948 
2949     // if index 1 is empty will fill at index 1
2950     if(crabPartData[_key][_element][1].hp == 0 && crabPartData[_key][_element][1].dps == 0) {
2951       crabPartData[_key][_element][1] = _partData;
2952     } else {
2953       crabPartData[_key][_element].push(_partData);
2954     }
2955 
2956     emit CrabPartAdded(_partDataArray[0], _partDataArray[1], _partDataArray[2]);
2957   }
2958 
2959   /**
2960    * @dev Updates the default metadata URI
2961    * @param _defaultUri the new metadata URI
2962    */
2963   function setDefaultMetadataURI(string _defaultUri) external onlyOwner {
2964     defaultMetadataURI = _defaultUri;
2965 
2966     emit DefaultMetadataURIChanged(_defaultUri);
2967   }
2968 
2969   /**
2970    * @dev Updates the metadata URI for existing token
2971    * @param _tokenId the tokenID that metadata URI to be changed
2972    * @param _uri the new metadata URI for the specified token
2973    */
2974   function setTokenURI(uint256 _tokenId, string _uri) external onlyIfWhitelisted(msg.sender) {
2975     _setTokenURI(_tokenId, _uri);
2976   }
2977 
2978   /**
2979    * @dev Returns the special skin of the provided tokenId
2980    * @param _tokenId cryptant crab's tokenId
2981    * @return Special skin belongs to the _tokenId provided. 
2982    * 0 will be returned if no special skin found.
2983    */
2984   function specialSkinOfTokenId(uint256 _tokenId) external view returns (uint256) {
2985     return crabSpecialSkins[_tokenId];
2986   }
2987 
2988   /**
2989    * @dev This functions will adjust the length of crabPartData
2990    * so that when adding data the index can start with 1.
2991    * Reason of doing this is because gene cannot have parts with index 0.
2992    */
2993   function initiateCrabPartData() internal {
2994     require(crabPartData[CRAB_BODY][1].length == 0);
2995 
2996     for(uint256 i = 1 ; i <= 5 ; i++) {
2997       crabPartData[CRAB_BODY][i].length = 2;
2998       crabPartData[CRAB_LEG][i].length = 2;
2999       crabPartData[CRAB_LEFT_CLAW][i].length = 2;
3000       crabPartData[CRAB_RIGHT_CLAW][i].length = 2;
3001     }
3002   }
3003 
3004   /**
3005    * @dev Returns whether the given spender can transfer a given token ID
3006    * @param _spender address of the spender to query
3007    * @param _tokenId uint256 ID of the token to be transferred
3008    * @return bool whether the msg.sender is approved for the given token ID,
3009    *  is an operator of the owner, or is the owner of the token, 
3010    *  or has been whitelisted by contract owner
3011    */
3012   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
3013     address owner = ownerOf(_tokenId);
3014     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender) || whitelist(_spender);
3015   }
3016 
3017   /**
3018    * @dev Will merge the uri and tokenId together. 
3019    * @param _uri URI to be merge. This will be the first part of the result URL.
3020    * @param _tokenId tokenID to be merge. This will be the last part of the result URL.
3021    * @return the merged urL
3022    */
3023   function getMetadataURL(bytes _uri, uint256 _tokenId) internal pure returns (string) {
3024     uint256 _tmpTokenId = _tokenId;
3025     uint256 _tokenLength;
3026 
3027     // Getting the length(number of digits) of token ID
3028     do {
3029       _tokenLength++;
3030       _tmpTokenId /= 10;
3031     } while (_tmpTokenId > 0);
3032 
3033     // creating a byte array with the length of URL + token digits
3034     bytes memory _result = new bytes(_uri.length + _tokenLength);
3035 
3036     // cloning the uri bytes into the result bytes
3037     for(uint256 i = 0 ; i < _uri.length ; i ++) {
3038       _result[i] = _uri[i];
3039     }
3040 
3041     // appending the tokenId to the end of the result bytes
3042     uint256 lastIndex = _result.length - 1;
3043     for(_tmpTokenId = _tokenId ; _tmpTokenId > 0 ; _tmpTokenId /= 10) {
3044       _result[lastIndex--] = byte(48 + _tmpTokenId % 10);
3045     }
3046 
3047     return string(_result);
3048   }
3049 }