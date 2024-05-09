1 pragma solidity 0.4.24;
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
75   function mutateCrabPart(uint256 _part, uint256 _existingPartGene, uint256 _legendaryPercentage) external view returns (uint256);
76   function generateCrabHeart() external view returns (uint256, uint256);
77 }
78 
79 contract Randomable {
80   // Generates a random number base on last block hash
81   function _generateRandom(bytes32 seed) view internal returns (bytes32) {
82     return keccak256(abi.encodePacked(blockhash(block.number-1), seed));
83   }
84 
85   function _generateRandomNumber(bytes32 seed, uint256 max) view internal returns (uint256) {
86     return uint256(_generateRandom(seed)) % max;
87   }
88 }
89 
90 contract CryptantCrabStoreInterface {
91   function createAddress(bytes32 key, address value) external returns (bool);
92   function createAddresses(bytes32[] keys, address[] values) external returns (bool);
93   function updateAddress(bytes32 key, address value) external returns (bool);
94   function updateAddresses(bytes32[] keys, address[] values) external returns (bool);
95   function removeAddress(bytes32 key) external returns (bool);
96   function removeAddresses(bytes32[] keys) external returns (bool);
97   function readAddress(bytes32 key) external view returns (address);
98   function readAddresses(bytes32[] keys) external view returns (address[]);
99   // Bool related functions
100   function createBool(bytes32 key, bool value) external returns (bool);
101   function createBools(bytes32[] keys, bool[] values) external returns (bool);
102   function updateBool(bytes32 key, bool value) external returns (bool);
103   function updateBools(bytes32[] keys, bool[] values) external returns (bool);
104   function removeBool(bytes32 key) external returns (bool);
105   function removeBools(bytes32[] keys) external returns (bool);
106   function readBool(bytes32 key) external view returns (bool);
107   function readBools(bytes32[] keys) external view returns (bool[]);
108   // Bytes32 related functions
109   function createBytes32(bytes32 key, bytes32 value) external returns (bool);
110   function createBytes32s(bytes32[] keys, bytes32[] values) external returns (bool);
111   function updateBytes32(bytes32 key, bytes32 value) external returns (bool);
112   function updateBytes32s(bytes32[] keys, bytes32[] values) external returns (bool);
113   function removeBytes32(bytes32 key) external returns (bool);
114   function removeBytes32s(bytes32[] keys) external returns (bool);
115   function readBytes32(bytes32 key) external view returns (bytes32);
116   function readBytes32s(bytes32[] keys) external view returns (bytes32[]);
117   // uint256 related functions
118   function createUint256(bytes32 key, uint256 value) external returns (bool);
119   function createUint256s(bytes32[] keys, uint256[] values) external returns (bool);
120   function updateUint256(bytes32 key, uint256 value) external returns (bool);
121   function updateUint256s(bytes32[] keys, uint256[] values) external returns (bool);
122   function removeUint256(bytes32 key) external returns (bool);
123   function removeUint256s(bytes32[] keys) external returns (bool);
124   function readUint256(bytes32 key) external view returns (uint256);
125   function readUint256s(bytes32[] keys) external view returns (uint256[]);
126   // int256 related functions
127   function createInt256(bytes32 key, int256 value) external returns (bool);
128   function createInt256s(bytes32[] keys, int256[] values) external returns (bool);
129   function updateInt256(bytes32 key, int256 value) external returns (bool);
130   function updateInt256s(bytes32[] keys, int256[] values) external returns (bool);
131   function removeInt256(bytes32 key) external returns (bool);
132   function removeInt256s(bytes32[] keys) external returns (bool);
133   function readInt256(bytes32 key) external view returns (int256);
134   function readInt256s(bytes32[] keys) external view returns (int256[]);
135   // internal functions
136   function parseKey(bytes32 key) internal pure returns (bytes32);
137   function parseKeys(bytes32[] _keys) internal pure returns (bytes32[]);
138 }
139 
140 library AddressUtils {
141 
142   /**
143    * Returns whether the target address is a contract
144    * @dev This function will return false if invoked during the constructor of a contract,
145    * as the code is not actually created until after the constructor finishes.
146    * @param addr address to check
147    * @return whether the target address is a contract
148    */
149   function isContract(address addr) internal view returns (bool) {
150     uint256 size;
151     // XXX Currently there is no better way to check if there is a contract in an address
152     // than to check the size of the code at that address.
153     // See https://ethereum.stackexchange.com/a/14016/36603
154     // for more details about how this works.
155     // TODO Check this again before the Serenity release, because all addresses will be
156     // contracts then.
157     // solium-disable-next-line security/no-inline-assembly
158     assembly { size := extcodesize(addr) }
159     return size > 0;
160   }
161 
162 }
163 
164 interface ERC165 {
165 
166   /**
167    * @notice Query if a contract implements an interface
168    * @param _interfaceId The interface identifier, as specified in ERC-165
169    * @dev Interface identification is specified in ERC-165. This function
170    * uses less than 30,000 gas.
171    */
172   function supportsInterface(bytes4 _interfaceId)
173     external
174     view
175     returns (bool);
176 }
177 
178 contract SupportsInterfaceWithLookup is ERC165 {
179   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
180   /**
181    * 0x01ffc9a7 ===
182    *   bytes4(keccak256('supportsInterface(bytes4)'))
183    */
184 
185   /**
186    * @dev a mapping of interface id to whether or not it's supported
187    */
188   mapping(bytes4 => bool) internal supportedInterfaces;
189 
190   /**
191    * @dev A contract implementing SupportsInterfaceWithLookup
192    * implement ERC165 itself
193    */
194   constructor()
195     public
196   {
197     _registerInterface(InterfaceId_ERC165);
198   }
199 
200   /**
201    * @dev implement supportsInterface(bytes4) using a lookup table
202    */
203   function supportsInterface(bytes4 _interfaceId)
204     external
205     view
206     returns (bool)
207   {
208     return supportedInterfaces[_interfaceId];
209   }
210 
211   /**
212    * @dev private method for registering an interface
213    */
214   function _registerInterface(bytes4 _interfaceId)
215     internal
216   {
217     require(_interfaceId != 0xffffffff);
218     supportedInterfaces[_interfaceId] = true;
219   }
220 }
221 
222 library SafeMath {
223 
224   /**
225   * @dev Multiplies two numbers, throws on overflow.
226   */
227   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
228     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
229     // benefit is lost if 'b' is also tested.
230     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
231     if (a == 0) {
232       return 0;
233     }
234 
235     c = a * b;
236     assert(c / a == b);
237     return c;
238   }
239 
240   /**
241   * @dev Integer division of two numbers, truncating the quotient.
242   */
243   function div(uint256 a, uint256 b) internal pure returns (uint256) {
244     // assert(b > 0); // Solidity automatically throws when dividing by 0
245     // uint256 c = a / b;
246     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247     return a / b;
248   }
249 
250   /**
251   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
252   */
253   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
254     assert(b <= a);
255     return a - b;
256   }
257 
258   /**
259   * @dev Adds two numbers, throws on overflow.
260   */
261   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
262     c = a + b;
263     assert(c >= a);
264     return c;
265   }
266 }
267 
268 contract Ownable {
269   address public owner;
270 
271 
272   event OwnershipRenounced(address indexed previousOwner);
273   event OwnershipTransferred(
274     address indexed previousOwner,
275     address indexed newOwner
276   );
277 
278 
279   /**
280    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
281    * account.
282    */
283   constructor() public {
284     owner = msg.sender;
285   }
286 
287   /**
288    * @dev Throws if called by any account other than the owner.
289    */
290   modifier onlyOwner() {
291     require(msg.sender == owner);
292     _;
293   }
294 
295   /**
296    * @dev Allows the current owner to relinquish control of the contract.
297    * @notice Renouncing to ownership will leave the contract without an owner.
298    * It will not be possible to call the functions with the `onlyOwner`
299    * modifier anymore.
300    */
301   function renounceOwnership() public onlyOwner {
302     emit OwnershipRenounced(owner);
303     owner = address(0);
304   }
305 
306   /**
307    * @dev Allows the current owner to transfer control of the contract to a newOwner.
308    * @param _newOwner The address to transfer ownership to.
309    */
310   function transferOwnership(address _newOwner) public onlyOwner {
311     _transferOwnership(_newOwner);
312   }
313 
314   /**
315    * @dev Transfers control of the contract to a newOwner.
316    * @param _newOwner The address to transfer ownership to.
317    */
318   function _transferOwnership(address _newOwner) internal {
319     require(_newOwner != address(0));
320     emit OwnershipTransferred(owner, _newOwner);
321     owner = _newOwner;
322   }
323 }
324 
325 contract CryptantCrabBase is Ownable {
326   GenesisCrabInterface public genesisCrab;
327   CryptantCrabNFT public cryptantCrabToken;
328   CryptantCrabStoreInterface public cryptantCrabStorage;
329 
330   constructor(address _genesisCrabAddress, address _cryptantCrabTokenAddress, address _cryptantCrabStorageAddress) public {
331     // constructor
332     
333     _setAddresses(_genesisCrabAddress, _cryptantCrabTokenAddress, _cryptantCrabStorageAddress);
334   }
335 
336   function setAddresses(
337     address _genesisCrabAddress, 
338     address _cryptantCrabTokenAddress, 
339     address _cryptantCrabStorageAddress
340   ) 
341   external onlyOwner {
342     _setAddresses(_genesisCrabAddress, _cryptantCrabTokenAddress, _cryptantCrabStorageAddress);
343   }
344 
345   function _setAddresses(
346     address _genesisCrabAddress,
347     address _cryptantCrabTokenAddress,
348     address _cryptantCrabStorageAddress
349   )
350   internal 
351   {
352     if(_genesisCrabAddress != address(0)) {
353       GenesisCrabInterface genesisCrabContract = GenesisCrabInterface(_genesisCrabAddress);
354       genesisCrab = genesisCrabContract;
355     }
356     
357     if(_cryptantCrabTokenAddress != address(0)) {
358       CryptantCrabNFT cryptantCrabTokenContract = CryptantCrabNFT(_cryptantCrabTokenAddress);
359       cryptantCrabToken = cryptantCrabTokenContract;
360     }
361     
362     if(_cryptantCrabStorageAddress != address(0)) {
363       CryptantCrabStoreInterface cryptantCrabStorageContract = CryptantCrabStoreInterface(_cryptantCrabStorageAddress);
364       cryptantCrabStorage = cryptantCrabStorageContract;
365     }
366   }
367 }
368 
369 contract CryptantCrabInformant is CryptantCrabBase{
370   constructor
371   (
372     address _genesisCrabAddress, 
373     address _cryptantCrabTokenAddress, 
374     address _cryptantCrabStorageAddress
375   ) 
376   public 
377   CryptantCrabBase
378   (
379     _genesisCrabAddress, 
380     _cryptantCrabTokenAddress, 
381     _cryptantCrabStorageAddress
382   ) {
383     // constructor
384 
385   }
386 
387   function _getCrabData(uint256 _tokenId) internal view returns 
388   (
389     uint256 _gene, 
390     uint256 _level, 
391     uint256 _exp, 
392     uint256 _mutationCount,
393     uint256 _trophyCount,
394     uint256 _heartValue,
395     uint256 _growthValue
396   ) {
397     require(cryptantCrabStorage != address(0));
398 
399     bytes32[] memory keys = new bytes32[](7);
400     uint256[] memory values;
401 
402     keys[0] = keccak256(abi.encodePacked(_tokenId, "gene"));
403     keys[1] = keccak256(abi.encodePacked(_tokenId, "level"));
404     keys[2] = keccak256(abi.encodePacked(_tokenId, "exp"));
405     keys[3] = keccak256(abi.encodePacked(_tokenId, "mutationCount"));
406     keys[4] = keccak256(abi.encodePacked(_tokenId, "trophyCount"));
407     keys[5] = keccak256(abi.encodePacked(_tokenId, "heartValue"));
408     keys[6] = keccak256(abi.encodePacked(_tokenId, "growthValue"));
409 
410     values = cryptantCrabStorage.readUint256s(keys);
411 
412     // process heart value
413     uint256 _processedHeartValue;
414     for(uint256 i = 1 ; i <= 1000 ; i *= 10) {
415       if(uint256(values[5]) / i % 10 > 0) {
416         _processedHeartValue += i;
417       }
418     }
419 
420     _gene = values[0];
421     _level = values[1];
422     _exp = values[2];
423     _mutationCount = values[3];
424     _trophyCount = values[4];
425     _heartValue = _processedHeartValue;
426     _growthValue = values[6];
427   }
428 
429   function _geneOfCrab(uint256 _tokenId) internal view returns (uint256 _gene) {
430     require(cryptantCrabStorage != address(0));
431 
432     _gene = cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_tokenId, "gene")));
433   }
434 }
435 
436 contract CryptantCrabPurchasable is CryptantCrabInformant {
437   using SafeMath for uint256;
438 
439   event CrabHatched(address indexed owner, uint256 tokenId, uint256 gene, uint256 specialSkin, uint256 crabPrice, uint256 growthValue);
440   event CryptantFragmentsAdded(address indexed cryptantOwner, uint256 amount, uint256 newBalance);
441   event CryptantFragmentsRemoved(address indexed cryptantOwner, uint256 amount, uint256 newBalance);
442   event Refund(address indexed refundReceiver, uint256 reqAmt, uint256 paid, uint256 refundAmt);
443 
444   constructor
445   (
446     address _genesisCrabAddress, 
447     address _cryptantCrabTokenAddress, 
448     address _cryptantCrabStorageAddress
449   ) 
450   public 
451   CryptantCrabInformant
452   (
453     _genesisCrabAddress, 
454     _cryptantCrabTokenAddress, 
455     _cryptantCrabStorageAddress
456   ) {
457     // constructor
458 
459   }
460 
461   function getCryptantFragments(address _sender) public view returns (uint256) {
462     return cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_sender, "cryptant")));
463   }
464 
465   function createCrab(uint256 _customTokenId, uint256 _crabPrice, uint256 _customGene, uint256 _customSkin, uint256 _customHeart, bool _hasLegendary) external onlyOwner {
466     return _createCrab(false, _customTokenId, _crabPrice, _customGene, _customSkin, _customHeart, _hasLegendary);
467   }
468 
469   function _addCryptantFragments(address _cryptantOwner, uint256 _amount) internal returns (uint256 _newBalance) {
470     _newBalance = getCryptantFragments(_cryptantOwner).add(_amount);
471     cryptantCrabStorage.updateUint256(keccak256(abi.encodePacked(_cryptantOwner, "cryptant")), _newBalance);
472     emit CryptantFragmentsAdded(_cryptantOwner, _amount, _newBalance);
473   }
474 
475   function _removeCryptantFragments(address _cryptantOwner, uint256 _amount) internal returns (uint256 _newBalance) {
476     _newBalance = getCryptantFragments(_cryptantOwner).sub(_amount);
477     cryptantCrabStorage.updateUint256(keccak256(abi.encodePacked(_cryptantOwner, "cryptant")), _newBalance);
478     emit CryptantFragmentsRemoved(_cryptantOwner, _amount, _newBalance);
479   }
480 
481   function _createCrab(bool _isPresale, uint256 _tokenId, uint256 _crabPrice, uint256 _customGene, uint256 _customSkin, uint256 _customHeart, bool _hasLegendary) internal {
482     uint256[] memory _values = new uint256[](4);
483     bytes32[] memory _keys = new bytes32[](4);
484 
485     uint256 _gene;
486     uint256 _specialSkin;
487     uint256 _heartValue;
488     uint256 _growthValue;
489     if(_customGene == 0) {
490       (_gene, _specialSkin, _heartValue, _growthValue) = genesisCrab.generateCrabGene(_isPresale, _hasLegendary);
491     } else {
492       _gene = _customGene;
493     }
494 
495     if(_customSkin != 0) {
496       _specialSkin = _customSkin;
497     }
498 
499     if(_customHeart != 0) {
500       _heartValue = _customHeart;
501     } else if (_heartValue == 0) {
502       (_heartValue, _growthValue) = genesisCrab.generateCrabHeart();
503     }
504     
505     cryptantCrabToken.mintToken(msg.sender, _tokenId, _specialSkin);
506 
507     // Gene pair
508     _keys[0] = keccak256(abi.encodePacked(_tokenId, "gene"));
509     _values[0] = _gene;
510 
511     // Level pair
512     _keys[1] = keccak256(abi.encodePacked(_tokenId, "level"));
513     _values[1] = 1;
514 
515     // Heart Value pair
516     _keys[2] = keccak256(abi.encodePacked(_tokenId, "heartValue"));
517     _values[2] = _heartValue;
518 
519     // Growth Value pair
520     _keys[3] = keccak256(abi.encodePacked(_tokenId, "growthValue"));
521     _values[3] = _growthValue;
522 
523     require(cryptantCrabStorage.createUint256s(_keys, _values));
524 
525     emit CrabHatched(msg.sender, _tokenId, _gene, _specialSkin, _crabPrice, _growthValue);
526   }
527 
528   function _refundExceededValue(uint256 _senderValue, uint256 _requiredValue) internal {
529     uint256 _exceededValue = _senderValue.sub(_requiredValue);
530 
531     if(_exceededValue > 0) {
532       msg.sender.transfer(_exceededValue);
533 
534       emit Refund(msg.sender, _requiredValue, _senderValue, _exceededValue);
535     } 
536   }
537 }
538 
539 contract Withdrawable is Ownable {
540   address public withdrawer;
541 
542   /**
543    * @dev Throws if called by any account other than the withdrawer.
544    */
545   modifier onlyWithdrawer() {
546     require(msg.sender == withdrawer);
547     _;
548   }
549 
550   function setWithdrawer(address _newWithdrawer) external onlyOwner {
551     withdrawer = _newWithdrawer;
552   }
553 
554   /**
555    * @dev withdraw the specified amount of ether from contract.
556    * @param _amount the amount of ether to withdraw. Units in wei.
557    */
558   function withdraw(uint256 _amount) external onlyWithdrawer returns(bool) {
559     require(_amount <= address(this).balance);
560     withdrawer.transfer(_amount);
561     return true;
562   }
563 }
564 
565 contract HasNoEther is Ownable {
566 
567   /**
568   * @dev Constructor that rejects incoming Ether
569   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
570   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
571   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
572   * we could use assembly to access msg.value.
573   */
574   constructor() public payable {
575     require(msg.value == 0);
576   }
577 
578   /**
579    * @dev Disallows direct send by settings a default function without the `payable` flag.
580    */
581   function() external {
582   }
583 
584   /**
585    * @dev Transfer all Ether held by the contract to the owner.
586    */
587   function reclaimEther() external onlyOwner {
588     owner.transfer(address(this).balance);
589   }
590 }
591 
592 contract CryptantCrabPresale is CryptantCrabPurchasable, HasNoEther, Withdrawable, Randomable {
593   event PresalePurchased(address indexed owner, uint256 amount, uint256 cryptant, uint256 refund);
594 
595   uint256 constant public PRICE_INCREMENT = 1 finney;
596 
597   uint256 constant public PRESALE_LIMIT = 5000;
598 
599   uint256 constant public PRESALE_MAX_PRICE = 490 finney;
600 
601   /**
602    * @dev Currently is set to 17/11/2018 00:00:00
603    */
604   uint256 public presaleEndTime = 1542412800;
605 
606   /**
607    * @dev Initial presale price is 0.12 ether
608    */
609   uint256 public currentPresalePrice = 120 finney;
610 
611   /**
612    * @dev The number of seconds that the presale price will stay fixed. 
613    */
614   uint256 constant public presalePriceUpdatePeriod = 3600;
615 
616   /**
617    * @dev Keep tracks on the presale price period.
618    *  initial period = (GMT): Thursday, October 25, 2018 12:00:00 AM
619    */
620   uint256 public currentPresalePeriod = 427896;
621 
622   /** 
623    * @dev tracks the current token id, starts from 10
624    */
625   uint256 public currentTokenId = 10;
626 
627   /** 
628    * @dev tracks the current giveaway token id, starts from 5001
629    */
630   uint256 public giveawayTokenId = 5001;
631 
632   constructor
633   (
634     address _genesisCrabAddress, 
635     address _cryptantCrabTokenAddress, 
636     address _cryptantCrabStorageAddress
637   ) 
638   public 
639   CryptantCrabPurchasable
640   (
641     _genesisCrabAddress, 
642     _cryptantCrabTokenAddress, 
643     _cryptantCrabStorageAddress
644   ) {
645     // constructor
646 
647   }
648 
649   function setPresaleEndtime(uint256 _newEndTime) external onlyOwner {
650     presaleEndTime = _newEndTime;
651   }
652 
653   function getPresalePrice() public returns (uint256) {
654     uint256 _currentPresalePeriod = now / presalePriceUpdatePeriod;
655 
656     if(_currentPresalePeriod > currentPresalePeriod) {
657       // need to update current presale price
658       uint256 _periodDifference = _currentPresalePeriod - currentPresalePeriod;
659 
660       uint256 _newPrice = PRICE_INCREMENT * _periodDifference;
661 
662       if(_newPrice <= PRESALE_MAX_PRICE) {
663         currentPresalePrice += _newPrice;
664         currentPresalePeriod = _currentPresalePeriod;
665       } else {
666         if (currentPresalePrice != PRESALE_MAX_PRICE) {
667           currentPresalePrice = PRESALE_MAX_PRICE;
668           currentPresalePeriod = _currentPresalePeriod;
669         }
670       }
671 
672       return currentPresalePrice;
673     } else {
674       return currentPresalePrice;
675     }
676   }
677 
678   function purchase(uint256 _amount) external payable {
679     require(genesisCrab != address(0));
680     require(cryptantCrabToken != address(0));
681     require(cryptantCrabStorage != address(0));
682     require(_amount > 0 && _amount <= 10);
683     require(isPresale());
684     require(PRESALE_LIMIT >= currentTokenId + _amount);
685 
686     uint256 _value = msg.value;
687     uint256 _currentPresalePrice = getPresalePrice();
688     uint256 _totalRequiredAmount = _currentPresalePrice * _amount;
689 
690     require(_value >= _totalRequiredAmount);
691 
692     // Purchase 10 crabs will have 1 crab with legendary part
693     // Default value for _crabWithLegendaryPart is just a unreacable number
694     uint256 _crabWithLegendaryPart = 100;
695     if(_amount == 10) {
696       // decide which crab will have the legendary part
697       _crabWithLegendaryPart = _generateRandomNumber(bytes32(currentTokenId), 10);
698     }
699 
700     for(uint256 i = 0 ; i < _amount ; i++) {
701       currentTokenId++;
702       _createCrab(true, currentTokenId, _currentPresalePrice, 0, 0, 0, _crabWithLegendaryPart == i);
703     }
704 
705     // Presale crab will get free cryptant fragments
706     _addCryptantFragments(msg.sender, (i * 3000));
707 
708     // Refund exceeded value
709     _refundExceededValue(_value, _totalRequiredAmount);
710 
711     emit PresalePurchased(msg.sender, _amount, i * 3000, _value - _totalRequiredAmount);
712   }
713 
714   function createCrab(uint256 _customTokenId, uint256 _crabPrice, uint256 _customGene, uint256 _customSkin, uint256 _customHeart, bool _hasLegendary) external onlyOwner {
715     return _createCrab(true, _customTokenId, _crabPrice, _customGene, _customSkin, _customHeart, _hasLegendary);
716   }
717 
718   function generateGiveawayCrabs(uint256 _amount) external onlyOwner {
719     for(uint256 i = 0 ; i < _amount ; i++) {
720       _createCrab(false, giveawayTokenId++, 120 finney, 0, 0, 0, false);
721     }
722   }
723 
724   function isPresale() internal view returns (bool) {
725     return now < presaleEndTime;
726   }
727 
728   function setCurrentPresalePeriod(uint256 _newPresalePeriod) external onlyOwner {
729     currentPresalePeriod = _newPresalePeriod;
730   }
731 }
732 
733 contract RBAC {
734   using Roles for Roles.Role;
735 
736   mapping (string => Roles.Role) private roles;
737 
738   event RoleAdded(address indexed operator, string role);
739   event RoleRemoved(address indexed operator, string role);
740 
741   /**
742    * @dev reverts if addr does not have role
743    * @param _operator address
744    * @param _role the name of the role
745    * // reverts
746    */
747   function checkRole(address _operator, string _role)
748     view
749     public
750   {
751     roles[_role].check(_operator);
752   }
753 
754   /**
755    * @dev determine if addr has role
756    * @param _operator address
757    * @param _role the name of the role
758    * @return bool
759    */
760   function hasRole(address _operator, string _role)
761     view
762     public
763     returns (bool)
764   {
765     return roles[_role].has(_operator);
766   }
767 
768   /**
769    * @dev add a role to an address
770    * @param _operator address
771    * @param _role the name of the role
772    */
773   function addRole(address _operator, string _role)
774     internal
775   {
776     roles[_role].add(_operator);
777     emit RoleAdded(_operator, _role);
778   }
779 
780   /**
781    * @dev remove a role from an address
782    * @param _operator address
783    * @param _role the name of the role
784    */
785   function removeRole(address _operator, string _role)
786     internal
787   {
788     roles[_role].remove(_operator);
789     emit RoleRemoved(_operator, _role);
790   }
791 
792   /**
793    * @dev modifier to scope access to a single role (uses msg.sender as addr)
794    * @param _role the name of the role
795    * // reverts
796    */
797   modifier onlyRole(string _role)
798   {
799     checkRole(msg.sender, _role);
800     _;
801   }
802 
803   /**
804    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
805    * @param _roles the names of the roles to scope access to
806    * // reverts
807    *
808    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
809    *  see: https://github.com/ethereum/solidity/issues/2467
810    */
811   // modifier onlyRoles(string[] _roles) {
812   //     bool hasAnyRole = false;
813   //     for (uint8 i = 0; i < _roles.length; i++) {
814   //         if (hasRole(msg.sender, _roles[i])) {
815   //             hasAnyRole = true;
816   //             break;
817   //         }
818   //     }
819 
820   //     require(hasAnyRole);
821 
822   //     _;
823   // }
824 }
825 
826 contract Whitelist is Ownable, RBAC {
827   string public constant ROLE_WHITELISTED = "whitelist";
828 
829   /**
830    * @dev Throws if operator is not whitelisted.
831    * @param _operator address
832    */
833   modifier onlyIfWhitelisted(address _operator) {
834     checkRole(_operator, ROLE_WHITELISTED);
835     _;
836   }
837 
838   /**
839    * @dev add an address to the whitelist
840    * @param _operator address
841    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
842    */
843   function addAddressToWhitelist(address _operator)
844     onlyOwner
845     public
846   {
847     addRole(_operator, ROLE_WHITELISTED);
848   }
849 
850   /**
851    * @dev getter to determine if address is in whitelist
852    */
853   function whitelist(address _operator)
854     public
855     view
856     returns (bool)
857   {
858     return hasRole(_operator, ROLE_WHITELISTED);
859   }
860 
861   /**
862    * @dev add addresses to the whitelist
863    * @param _operators addresses
864    * @return true if at least one address was added to the whitelist,
865    * false if all addresses were already in the whitelist
866    */
867   function addAddressesToWhitelist(address[] _operators)
868     onlyOwner
869     public
870   {
871     for (uint256 i = 0; i < _operators.length; i++) {
872       addAddressToWhitelist(_operators[i]);
873     }
874   }
875 
876   /**
877    * @dev remove an address from the whitelist
878    * @param _operator address
879    * @return true if the address was removed from the whitelist,
880    * false if the address wasn't in the whitelist in the first place
881    */
882   function removeAddressFromWhitelist(address _operator)
883     onlyOwner
884     public
885   {
886     removeRole(_operator, ROLE_WHITELISTED);
887   }
888 
889   /**
890    * @dev remove addresses from the whitelist
891    * @param _operators addresses
892    * @return true if at least one address was removed from the whitelist,
893    * false if all addresses weren't in the whitelist in the first place
894    */
895   function removeAddressesFromWhitelist(address[] _operators)
896     onlyOwner
897     public
898   {
899     for (uint256 i = 0; i < _operators.length; i++) {
900       removeAddressFromWhitelist(_operators[i]);
901     }
902   }
903 
904 }
905 
906 library Roles {
907   struct Role {
908     mapping (address => bool) bearer;
909   }
910 
911   /**
912    * @dev give an address access to this role
913    */
914   function add(Role storage role, address addr)
915     internal
916   {
917     role.bearer[addr] = true;
918   }
919 
920   /**
921    * @dev remove an address' access to this role
922    */
923   function remove(Role storage role, address addr)
924     internal
925   {
926     role.bearer[addr] = false;
927   }
928 
929   /**
930    * @dev check if an address has this role
931    * // reverts
932    */
933   function check(Role storage role, address addr)
934     view
935     internal
936   {
937     require(has(role, addr));
938   }
939 
940   /**
941    * @dev check if an address has this role
942    * @return bool
943    */
944   function has(Role storage role, address addr)
945     view
946     internal
947     returns (bool)
948   {
949     return role.bearer[addr];
950   }
951 }
952 
953 contract ERC721Basic is ERC165 {
954   event Transfer(
955     address indexed _from,
956     address indexed _to,
957     uint256 indexed _tokenId
958   );
959   event Approval(
960     address indexed _owner,
961     address indexed _approved,
962     uint256 indexed _tokenId
963   );
964   event ApprovalForAll(
965     address indexed _owner,
966     address indexed _operator,
967     bool _approved
968   );
969 
970   function balanceOf(address _owner) public view returns (uint256 _balance);
971   function ownerOf(uint256 _tokenId) public view returns (address _owner);
972   function exists(uint256 _tokenId) public view returns (bool _exists);
973 
974   function approve(address _to, uint256 _tokenId) public;
975   function getApproved(uint256 _tokenId)
976     public view returns (address _operator);
977 
978   function setApprovalForAll(address _operator, bool _approved) public;
979   function isApprovedForAll(address _owner, address _operator)
980     public view returns (bool);
981 
982   function transferFrom(address _from, address _to, uint256 _tokenId) public;
983   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
984     public;
985 
986   function safeTransferFrom(
987     address _from,
988     address _to,
989     uint256 _tokenId,
990     bytes _data
991   )
992     public;
993 }
994 
995 contract ERC721Enumerable is ERC721Basic {
996   function totalSupply() public view returns (uint256);
997   function tokenOfOwnerByIndex(
998     address _owner,
999     uint256 _index
1000   )
1001     public
1002     view
1003     returns (uint256 _tokenId);
1004 
1005   function tokenByIndex(uint256 _index) public view returns (uint256);
1006 }
1007 
1008 contract ERC721Metadata is ERC721Basic {
1009   function name() external view returns (string _name);
1010   function symbol() external view returns (string _symbol);
1011   function tokenURI(uint256 _tokenId) public view returns (string);
1012 }
1013 
1014 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
1015 }
1016 
1017 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
1018 
1019   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
1020   /*
1021    * 0x80ac58cd ===
1022    *   bytes4(keccak256('balanceOf(address)')) ^
1023    *   bytes4(keccak256('ownerOf(uint256)')) ^
1024    *   bytes4(keccak256('approve(address,uint256)')) ^
1025    *   bytes4(keccak256('getApproved(uint256)')) ^
1026    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1027    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
1028    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1029    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1030    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1031    */
1032 
1033   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
1034   /*
1035    * 0x4f558e79 ===
1036    *   bytes4(keccak256('exists(uint256)'))
1037    */
1038 
1039   using SafeMath for uint256;
1040   using AddressUtils for address;
1041 
1042   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1043   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
1044   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
1045 
1046   // Mapping from token ID to owner
1047   mapping (uint256 => address) internal tokenOwner;
1048 
1049   // Mapping from token ID to approved address
1050   mapping (uint256 => address) internal tokenApprovals;
1051 
1052   // Mapping from owner to number of owned token
1053   mapping (address => uint256) internal ownedTokensCount;
1054 
1055   // Mapping from owner to operator approvals
1056   mapping (address => mapping (address => bool)) internal operatorApprovals;
1057 
1058   /**
1059    * @dev Guarantees msg.sender is owner of the given token
1060    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
1061    */
1062   modifier onlyOwnerOf(uint256 _tokenId) {
1063     require(ownerOf(_tokenId) == msg.sender);
1064     _;
1065   }
1066 
1067   /**
1068    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
1069    * @param _tokenId uint256 ID of the token to validate
1070    */
1071   modifier canTransfer(uint256 _tokenId) {
1072     require(isApprovedOrOwner(msg.sender, _tokenId));
1073     _;
1074   }
1075 
1076   constructor()
1077     public
1078   {
1079     // register the supported interfaces to conform to ERC721 via ERC165
1080     _registerInterface(InterfaceId_ERC721);
1081     _registerInterface(InterfaceId_ERC721Exists);
1082   }
1083 
1084   /**
1085    * @dev Gets the balance of the specified address
1086    * @param _owner address to query the balance of
1087    * @return uint256 representing the amount owned by the passed address
1088    */
1089   function balanceOf(address _owner) public view returns (uint256) {
1090     require(_owner != address(0));
1091     return ownedTokensCount[_owner];
1092   }
1093 
1094   /**
1095    * @dev Gets the owner of the specified token ID
1096    * @param _tokenId uint256 ID of the token to query the owner of
1097    * @return owner address currently marked as the owner of the given token ID
1098    */
1099   function ownerOf(uint256 _tokenId) public view returns (address) {
1100     address owner = tokenOwner[_tokenId];
1101     require(owner != address(0));
1102     return owner;
1103   }
1104 
1105   /**
1106    * @dev Returns whether the specified token exists
1107    * @param _tokenId uint256 ID of the token to query the existence of
1108    * @return whether the token exists
1109    */
1110   function exists(uint256 _tokenId) public view returns (bool) {
1111     address owner = tokenOwner[_tokenId];
1112     return owner != address(0);
1113   }
1114 
1115   /**
1116    * @dev Approves another address to transfer the given token ID
1117    * The zero address indicates there is no approved address.
1118    * There can only be one approved address per token at a given time.
1119    * Can only be called by the token owner or an approved operator.
1120    * @param _to address to be approved for the given token ID
1121    * @param _tokenId uint256 ID of the token to be approved
1122    */
1123   function approve(address _to, uint256 _tokenId) public {
1124     address owner = ownerOf(_tokenId);
1125     require(_to != owner);
1126     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1127 
1128     tokenApprovals[_tokenId] = _to;
1129     emit Approval(owner, _to, _tokenId);
1130   }
1131 
1132   /**
1133    * @dev Gets the approved address for a token ID, or zero if no address set
1134    * @param _tokenId uint256 ID of the token to query the approval of
1135    * @return address currently approved for the given token ID
1136    */
1137   function getApproved(uint256 _tokenId) public view returns (address) {
1138     return tokenApprovals[_tokenId];
1139   }
1140 
1141   /**
1142    * @dev Sets or unsets the approval of a given operator
1143    * An operator is allowed to transfer all tokens of the sender on their behalf
1144    * @param _to operator address to set the approval
1145    * @param _approved representing the status of the approval to be set
1146    */
1147   function setApprovalForAll(address _to, bool _approved) public {
1148     require(_to != msg.sender);
1149     operatorApprovals[msg.sender][_to] = _approved;
1150     emit ApprovalForAll(msg.sender, _to, _approved);
1151   }
1152 
1153   /**
1154    * @dev Tells whether an operator is approved by a given owner
1155    * @param _owner owner address which you want to query the approval of
1156    * @param _operator operator address which you want to query the approval of
1157    * @return bool whether the given operator is approved by the given owner
1158    */
1159   function isApprovedForAll(
1160     address _owner,
1161     address _operator
1162   )
1163     public
1164     view
1165     returns (bool)
1166   {
1167     return operatorApprovals[_owner][_operator];
1168   }
1169 
1170   /**
1171    * @dev Transfers the ownership of a given token ID to another address
1172    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1173    * Requires the msg sender to be the owner, approved, or operator
1174    * @param _from current owner of the token
1175    * @param _to address to receive the ownership of the given token ID
1176    * @param _tokenId uint256 ID of the token to be transferred
1177   */
1178   function transferFrom(
1179     address _from,
1180     address _to,
1181     uint256 _tokenId
1182   )
1183     public
1184     canTransfer(_tokenId)
1185   {
1186     require(_from != address(0));
1187     require(_to != address(0));
1188 
1189     clearApproval(_from, _tokenId);
1190     removeTokenFrom(_from, _tokenId);
1191     addTokenTo(_to, _tokenId);
1192 
1193     emit Transfer(_from, _to, _tokenId);
1194   }
1195 
1196   /**
1197    * @dev Safely transfers the ownership of a given token ID to another address
1198    * If the target address is a contract, it must implement `onERC721Received`,
1199    * which is called upon a safe transfer, and return the magic value
1200    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1201    * the transfer is reverted.
1202    *
1203    * Requires the msg sender to be the owner, approved, or operator
1204    * @param _from current owner of the token
1205    * @param _to address to receive the ownership of the given token ID
1206    * @param _tokenId uint256 ID of the token to be transferred
1207   */
1208   function safeTransferFrom(
1209     address _from,
1210     address _to,
1211     uint256 _tokenId
1212   )
1213     public
1214     canTransfer(_tokenId)
1215   {
1216     // solium-disable-next-line arg-overflow
1217     safeTransferFrom(_from, _to, _tokenId, "");
1218   }
1219 
1220   /**
1221    * @dev Safely transfers the ownership of a given token ID to another address
1222    * If the target address is a contract, it must implement `onERC721Received`,
1223    * which is called upon a safe transfer, and return the magic value
1224    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1225    * the transfer is reverted.
1226    * Requires the msg sender to be the owner, approved, or operator
1227    * @param _from current owner of the token
1228    * @param _to address to receive the ownership of the given token ID
1229    * @param _tokenId uint256 ID of the token to be transferred
1230    * @param _data bytes data to send along with a safe transfer check
1231    */
1232   function safeTransferFrom(
1233     address _from,
1234     address _to,
1235     uint256 _tokenId,
1236     bytes _data
1237   )
1238     public
1239     canTransfer(_tokenId)
1240   {
1241     transferFrom(_from, _to, _tokenId);
1242     // solium-disable-next-line arg-overflow
1243     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1244   }
1245 
1246   /**
1247    * @dev Returns whether the given spender can transfer a given token ID
1248    * @param _spender address of the spender to query
1249    * @param _tokenId uint256 ID of the token to be transferred
1250    * @return bool whether the msg.sender is approved for the given token ID,
1251    *  is an operator of the owner, or is the owner of the token
1252    */
1253   function isApprovedOrOwner(
1254     address _spender,
1255     uint256 _tokenId
1256   )
1257     internal
1258     view
1259     returns (bool)
1260   {
1261     address owner = ownerOf(_tokenId);
1262     // Disable solium check because of
1263     // https://github.com/duaraghav8/Solium/issues/175
1264     // solium-disable-next-line operator-whitespace
1265     return (
1266       _spender == owner ||
1267       getApproved(_tokenId) == _spender ||
1268       isApprovedForAll(owner, _spender)
1269     );
1270   }
1271 
1272   /**
1273    * @dev Internal function to mint a new token
1274    * Reverts if the given token ID already exists
1275    * @param _to The address that will own the minted token
1276    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1277    */
1278   function _mint(address _to, uint256 _tokenId) internal {
1279     require(_to != address(0));
1280     addTokenTo(_to, _tokenId);
1281     emit Transfer(address(0), _to, _tokenId);
1282   }
1283 
1284   /**
1285    * @dev Internal function to burn a specific token
1286    * Reverts if the token does not exist
1287    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1288    */
1289   function _burn(address _owner, uint256 _tokenId) internal {
1290     clearApproval(_owner, _tokenId);
1291     removeTokenFrom(_owner, _tokenId);
1292     emit Transfer(_owner, address(0), _tokenId);
1293   }
1294 
1295   /**
1296    * @dev Internal function to clear current approval of a given token ID
1297    * Reverts if the given address is not indeed the owner of the token
1298    * @param _owner owner of the token
1299    * @param _tokenId uint256 ID of the token to be transferred
1300    */
1301   function clearApproval(address _owner, uint256 _tokenId) internal {
1302     require(ownerOf(_tokenId) == _owner);
1303     if (tokenApprovals[_tokenId] != address(0)) {
1304       tokenApprovals[_tokenId] = address(0);
1305     }
1306   }
1307 
1308   /**
1309    * @dev Internal function to add a token ID to the list of a given address
1310    * @param _to address representing the new owner of the given token ID
1311    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1312    */
1313   function addTokenTo(address _to, uint256 _tokenId) internal {
1314     require(tokenOwner[_tokenId] == address(0));
1315     tokenOwner[_tokenId] = _to;
1316     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1317   }
1318 
1319   /**
1320    * @dev Internal function to remove a token ID from the list of a given address
1321    * @param _from address representing the previous owner of the given token ID
1322    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1323    */
1324   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1325     require(ownerOf(_tokenId) == _from);
1326     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1327     tokenOwner[_tokenId] = address(0);
1328   }
1329 
1330   /**
1331    * @dev Internal function to invoke `onERC721Received` on a target address
1332    * The call is not executed if the target address is not a contract
1333    * @param _from address representing the previous owner of the given token ID
1334    * @param _to target address that will receive the tokens
1335    * @param _tokenId uint256 ID of the token to be transferred
1336    * @param _data bytes optional data to send along with the call
1337    * @return whether the call correctly returned the expected magic value
1338    */
1339   function checkAndCallSafeTransfer(
1340     address _from,
1341     address _to,
1342     uint256 _tokenId,
1343     bytes _data
1344   )
1345     internal
1346     returns (bool)
1347   {
1348     if (!_to.isContract()) {
1349       return true;
1350     }
1351     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1352       msg.sender, _from, _tokenId, _data);
1353     return (retval == ERC721_RECEIVED);
1354   }
1355 }
1356 
1357 contract ERC721Receiver {
1358   /**
1359    * @dev Magic value to be returned upon successful reception of an NFT
1360    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
1361    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
1362    */
1363   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
1364 
1365   /**
1366    * @notice Handle the receipt of an NFT
1367    * @dev The ERC721 smart contract calls this function on the recipient
1368    * after a `safetransfer`. This function MAY throw to revert and reject the
1369    * transfer. Return of other than the magic value MUST result in the 
1370    * transaction being reverted.
1371    * Note: the contract address is always the message sender.
1372    * @param _operator The address which called `safeTransferFrom` function
1373    * @param _from The address which previously owned the token
1374    * @param _tokenId The NFT identifier which is being transfered
1375    * @param _data Additional data with no specified format
1376    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1377    */
1378   function onERC721Received(
1379     address _operator,
1380     address _from,
1381     uint256 _tokenId,
1382     bytes _data
1383   )
1384     public
1385     returns(bytes4);
1386 }
1387 
1388 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1389 
1390   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
1391   /**
1392    * 0x780e9d63 ===
1393    *   bytes4(keccak256('totalSupply()')) ^
1394    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
1395    *   bytes4(keccak256('tokenByIndex(uint256)'))
1396    */
1397 
1398   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
1399   /**
1400    * 0x5b5e139f ===
1401    *   bytes4(keccak256('name()')) ^
1402    *   bytes4(keccak256('symbol()')) ^
1403    *   bytes4(keccak256('tokenURI(uint256)'))
1404    */
1405 
1406   // Token name
1407   string internal name_;
1408 
1409   // Token symbol
1410   string internal symbol_;
1411 
1412   // Mapping from owner to list of owned token IDs
1413   mapping(address => uint256[]) internal ownedTokens;
1414 
1415   // Mapping from token ID to index of the owner tokens list
1416   mapping(uint256 => uint256) internal ownedTokensIndex;
1417 
1418   // Array with all token ids, used for enumeration
1419   uint256[] internal allTokens;
1420 
1421   // Mapping from token id to position in the allTokens array
1422   mapping(uint256 => uint256) internal allTokensIndex;
1423 
1424   // Optional mapping for token URIs
1425   mapping(uint256 => string) internal tokenURIs;
1426 
1427   /**
1428    * @dev Constructor function
1429    */
1430   constructor(string _name, string _symbol) public {
1431     name_ = _name;
1432     symbol_ = _symbol;
1433 
1434     // register the supported interfaces to conform to ERC721 via ERC165
1435     _registerInterface(InterfaceId_ERC721Enumerable);
1436     _registerInterface(InterfaceId_ERC721Metadata);
1437   }
1438 
1439   /**
1440    * @dev Gets the token name
1441    * @return string representing the token name
1442    */
1443   function name() external view returns (string) {
1444     return name_;
1445   }
1446 
1447   /**
1448    * @dev Gets the token symbol
1449    * @return string representing the token symbol
1450    */
1451   function symbol() external view returns (string) {
1452     return symbol_;
1453   }
1454 
1455   /**
1456    * @dev Returns an URI for a given token ID
1457    * Throws if the token ID does not exist. May return an empty string.
1458    * @param _tokenId uint256 ID of the token to query
1459    */
1460   function tokenURI(uint256 _tokenId) public view returns (string) {
1461     require(exists(_tokenId));
1462     return tokenURIs[_tokenId];
1463   }
1464 
1465   /**
1466    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1467    * @param _owner address owning the tokens list to be accessed
1468    * @param _index uint256 representing the index to be accessed of the requested tokens list
1469    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1470    */
1471   function tokenOfOwnerByIndex(
1472     address _owner,
1473     uint256 _index
1474   )
1475     public
1476     view
1477     returns (uint256)
1478   {
1479     require(_index < balanceOf(_owner));
1480     return ownedTokens[_owner][_index];
1481   }
1482 
1483   /**
1484    * @dev Gets the total amount of tokens stored by the contract
1485    * @return uint256 representing the total amount of tokens
1486    */
1487   function totalSupply() public view returns (uint256) {
1488     return allTokens.length;
1489   }
1490 
1491   /**
1492    * @dev Gets the token ID at a given index of all the tokens in this contract
1493    * Reverts if the index is greater or equal to the total number of tokens
1494    * @param _index uint256 representing the index to be accessed of the tokens list
1495    * @return uint256 token ID at the given index of the tokens list
1496    */
1497   function tokenByIndex(uint256 _index) public view returns (uint256) {
1498     require(_index < totalSupply());
1499     return allTokens[_index];
1500   }
1501 
1502   /**
1503    * @dev Internal function to set the token URI for a given token
1504    * Reverts if the token ID does not exist
1505    * @param _tokenId uint256 ID of the token to set its URI
1506    * @param _uri string URI to assign
1507    */
1508   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1509     require(exists(_tokenId));
1510     tokenURIs[_tokenId] = _uri;
1511   }
1512 
1513   /**
1514    * @dev Internal function to add a token ID to the list of a given address
1515    * @param _to address representing the new owner of the given token ID
1516    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1517    */
1518   function addTokenTo(address _to, uint256 _tokenId) internal {
1519     super.addTokenTo(_to, _tokenId);
1520     uint256 length = ownedTokens[_to].length;
1521     ownedTokens[_to].push(_tokenId);
1522     ownedTokensIndex[_tokenId] = length;
1523   }
1524 
1525   /**
1526    * @dev Internal function to remove a token ID from the list of a given address
1527    * @param _from address representing the previous owner of the given token ID
1528    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1529    */
1530   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1531     super.removeTokenFrom(_from, _tokenId);
1532 
1533     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1534     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1535     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1536 
1537     ownedTokens[_from][tokenIndex] = lastToken;
1538     ownedTokens[_from][lastTokenIndex] = 0;
1539     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1540     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1541     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1542 
1543     ownedTokens[_from].length--;
1544     ownedTokensIndex[_tokenId] = 0;
1545     ownedTokensIndex[lastToken] = tokenIndex;
1546   }
1547 
1548   /**
1549    * @dev Internal function to mint a new token
1550    * Reverts if the given token ID already exists
1551    * @param _to address the beneficiary that will own the minted token
1552    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1553    */
1554   function _mint(address _to, uint256 _tokenId) internal {
1555     super._mint(_to, _tokenId);
1556 
1557     allTokensIndex[_tokenId] = allTokens.length;
1558     allTokens.push(_tokenId);
1559   }
1560 
1561   /**
1562    * @dev Internal function to burn a specific token
1563    * Reverts if the token does not exist
1564    * @param _owner owner of the token to burn
1565    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1566    */
1567   function _burn(address _owner, uint256 _tokenId) internal {
1568     super._burn(_owner, _tokenId);
1569 
1570     // Clear metadata (if any)
1571     if (bytes(tokenURIs[_tokenId]).length != 0) {
1572       delete tokenURIs[_tokenId];
1573     }
1574 
1575     // Reorg all tokens array
1576     uint256 tokenIndex = allTokensIndex[_tokenId];
1577     uint256 lastTokenIndex = allTokens.length.sub(1);
1578     uint256 lastToken = allTokens[lastTokenIndex];
1579 
1580     allTokens[tokenIndex] = lastToken;
1581     allTokens[lastTokenIndex] = 0;
1582 
1583     allTokens.length--;
1584     allTokensIndex[_tokenId] = 0;
1585     allTokensIndex[lastToken] = tokenIndex;
1586   }
1587 
1588 }
1589 
1590 contract CryptantCrabNFT is ERC721Token, Whitelist, CrabData, GeneSurgeon {
1591   event CrabPartAdded(uint256 hp, uint256 dps, uint256 blockAmount);
1592   event GiftTransfered(address indexed _from, address indexed _to, uint256 indexed _tokenId);
1593   event DefaultMetadataURIChanged(string newUri);
1594 
1595   /**
1596    * @dev Pre-generated keys to save gas
1597    * keys are generated with:
1598    * CRAB_BODY       = bytes4(keccak256("crab_body"))       = 0xc398430e
1599    * CRAB_LEG        = bytes4(keccak256("crab_leg"))        = 0x889063b1
1600    * CRAB_LEFT_CLAW  = bytes4(keccak256("crab_left_claw"))  = 0xdb6290a2
1601    * CRAB_RIGHT_CLAW = bytes4(keccak256("crab_right_claw")) = 0x13453f89
1602    */
1603   bytes4 internal constant CRAB_BODY = 0xc398430e;
1604   bytes4 internal constant CRAB_LEG = 0x889063b1;
1605   bytes4 internal constant CRAB_LEFT_CLAW = 0xdb6290a2;
1606   bytes4 internal constant CRAB_RIGHT_CLAW = 0x13453f89;
1607 
1608   /**
1609    * @dev Stores all the crab data
1610    */
1611   mapping(bytes4 => mapping(uint256 => CrabPartData[])) internal crabPartData;
1612 
1613   /**
1614    * @dev Mapping from tokenId to its corresponding special skin
1615    * tokenId with default skin will not be stored. 
1616    */
1617   mapping(uint256 => uint256) internal crabSpecialSkins;
1618 
1619   /**
1620    * @dev default MetadataURI
1621    */
1622   string public defaultMetadataURI = "https://www.cryptantcrab.io/md/";
1623 
1624   constructor(string _name, string _symbol) public ERC721Token(_name, _symbol) {
1625     // constructor
1626     initiateCrabPartData();
1627   }
1628 
1629   /**
1630    * @dev Returns an URI for a given token ID
1631    * Throws if the token ID does not exist.
1632    * Will return the token's metadata URL if it has one, 
1633    * otherwise will just return base on the default metadata URI
1634    * @param _tokenId uint256 ID of the token to query
1635    */
1636   function tokenURI(uint256 _tokenId) public view returns (string) {
1637     require(exists(_tokenId));
1638 
1639     string memory _uri = tokenURIs[_tokenId];
1640 
1641     if(bytes(_uri).length == 0) {
1642       _uri = getMetadataURL(bytes(defaultMetadataURI), _tokenId);
1643     }
1644 
1645     return _uri;
1646   }
1647 
1648   /**
1649    * @dev Returns the data of a specific parts
1650    * @param _partIndex the part to retrieve. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
1651    * @param _element the element of part to retrieve. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
1652    * @param _setIndex the set index of for the specified part. This will starts from 1.
1653    */
1654   function dataOfPart(uint256 _partIndex, uint256 _element, uint256 _setIndex) public view returns (uint256[] memory _resultData) {
1655     bytes4 _key;
1656     if(_partIndex == 1) {
1657       _key = CRAB_BODY;
1658     } else if(_partIndex == 2) {
1659       _key = CRAB_LEG;
1660     } else if(_partIndex == 3) {
1661       _key = CRAB_LEFT_CLAW;
1662     } else if(_partIndex == 4) {
1663       _key = CRAB_RIGHT_CLAW;
1664     } else {
1665       revert();
1666     }
1667 
1668     CrabPartData storage _crabPartData = crabPartData[_key][_element][_setIndex];
1669 
1670     _resultData = crabPartDataToArray(_crabPartData);
1671   }
1672 
1673   /**
1674    * @dev Gift(Transfer) a token to another address. Caller must be token owner
1675    * @param _from current owner of the token
1676    * @param _to address to receive the ownership of the given token ID
1677    * @param _tokenId uint256 ID of the token to be transferred
1678    */
1679   function giftToken(address _from, address _to, uint256 _tokenId) external {
1680     safeTransferFrom(_from, _to, _tokenId);
1681 
1682     emit GiftTransfered(_from, _to, _tokenId);
1683   }
1684 
1685   /**
1686    * @dev External function to mint a new token, for whitelisted address only.
1687    * Reverts if the given token ID already exists
1688    * @param _tokenOwner address the beneficiary that will own the minted token
1689    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1690    * @param _skinId the skin ID to be applied for all the token minted
1691    */
1692   function mintToken(address _tokenOwner, uint256 _tokenId, uint256 _skinId) external onlyIfWhitelisted(msg.sender) {
1693     super._mint(_tokenOwner, _tokenId);
1694 
1695     if(_skinId > 0) {
1696       crabSpecialSkins[_tokenId] = _skinId;
1697     }
1698   }
1699 
1700   /**
1701    * @dev Returns crab data base on the gene provided
1702    * @param _gene the gene info where crab data will be retrieved base on it
1703    * @return 4 uint arrays:
1704    * 1st Array = Body's Data
1705    * 2nd Array = Leg's Data
1706    * 3rd Array = Left Claw's Data
1707    * 4th Array = Right Claw's Data
1708    */
1709   function crabPartDataFromGene(uint256 _gene) external view returns (
1710     uint256[] _bodyData,
1711     uint256[] _legData,
1712     uint256[] _leftClawData,
1713     uint256[] _rightClawData
1714   ) {
1715     uint256[] memory _parts = extractPartsFromGene(_gene);
1716     uint256[] memory _elements = extractElementsFromGene(_gene);
1717 
1718     _bodyData = dataOfPart(1, _elements[0], _parts[0]);
1719     _legData = dataOfPart(2, _elements[1], _parts[1]);
1720     _leftClawData = dataOfPart(3, _elements[2], _parts[2]);
1721     _rightClawData = dataOfPart(4, _elements[3], _parts[3]);
1722   }
1723 
1724   /**
1725    * @dev For developer to add new parts, notice that this is the only method to add crab data
1726    * so that developer can add extra content. there's no other method for developer to modify
1727    * the data. This is to assure token owner actually owns their data.
1728    * @param _partIndex the part to add. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
1729    * @param _element the element of part to add. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
1730    * @param _partDataArray data of the parts.
1731    */
1732   function setPartData(uint256 _partIndex, uint256 _element, uint256[] _partDataArray) external onlyOwner {
1733     CrabPartData memory _partData = arrayToCrabPartData(_partDataArray);
1734 
1735     bytes4 _key;
1736     if(_partIndex == 1) {
1737       _key = CRAB_BODY;
1738     } else if(_partIndex == 2) {
1739       _key = CRAB_LEG;
1740     } else if(_partIndex == 3) {
1741       _key = CRAB_LEFT_CLAW;
1742     } else if(_partIndex == 4) {
1743       _key = CRAB_RIGHT_CLAW;
1744     }
1745 
1746     // if index 1 is empty will fill at index 1
1747     if(crabPartData[_key][_element][1].hp == 0 && crabPartData[_key][_element][1].dps == 0) {
1748       crabPartData[_key][_element][1] = _partData;
1749     } else {
1750       crabPartData[_key][_element].push(_partData);
1751     }
1752 
1753     emit CrabPartAdded(_partDataArray[0], _partDataArray[1], _partDataArray[2]);
1754   }
1755 
1756   /**
1757    * @dev Updates the default metadata URI
1758    * @param _defaultUri the new metadata URI
1759    */
1760   function setDefaultMetadataURI(string _defaultUri) external onlyOwner {
1761     defaultMetadataURI = _defaultUri;
1762 
1763     emit DefaultMetadataURIChanged(_defaultUri);
1764   }
1765 
1766   /**
1767    * @dev Updates the metadata URI for existing token
1768    * @param _tokenId the tokenID that metadata URI to be changed
1769    * @param _uri the new metadata URI for the specified token
1770    */
1771   function setTokenURI(uint256 _tokenId, string _uri) external onlyIfWhitelisted(msg.sender) {
1772     _setTokenURI(_tokenId, _uri);
1773   }
1774 
1775   /**
1776    * @dev Returns the special skin of the provided tokenId
1777    * @param _tokenId cryptant crab's tokenId
1778    * @return Special skin belongs to the _tokenId provided. 
1779    * 0 will be returned if no special skin found.
1780    */
1781   function specialSkinOfTokenId(uint256 _tokenId) external view returns (uint256) {
1782     return crabSpecialSkins[_tokenId];
1783   }
1784 
1785   /**
1786    * @dev This functions will adjust the length of crabPartData
1787    * so that when adding data the index can start with 1.
1788    * Reason of doing this is because gene cannot have parts with index 0.
1789    */
1790   function initiateCrabPartData() internal {
1791     require(crabPartData[CRAB_BODY][1].length == 0);
1792 
1793     for(uint256 i = 1 ; i <= 5 ; i++) {
1794       crabPartData[CRAB_BODY][i].length = 2;
1795       crabPartData[CRAB_LEG][i].length = 2;
1796       crabPartData[CRAB_LEFT_CLAW][i].length = 2;
1797       crabPartData[CRAB_RIGHT_CLAW][i].length = 2;
1798     }
1799   }
1800 
1801   /**
1802    * @dev Returns whether the given spender can transfer a given token ID
1803    * @param _spender address of the spender to query
1804    * @param _tokenId uint256 ID of the token to be transferred
1805    * @return bool whether the msg.sender is approved for the given token ID,
1806    *  is an operator of the owner, or is the owner of the token, 
1807    *  or has been whitelisted by contract owner
1808    */
1809   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
1810     address owner = ownerOf(_tokenId);
1811     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender) || whitelist(_spender);
1812   }
1813 
1814   /**
1815    * @dev Will merge the uri and tokenId together. 
1816    * @param _uri URI to be merge. This will be the first part of the result URL.
1817    * @param _tokenId tokenID to be merge. This will be the last part of the result URL.
1818    * @return the merged urL
1819    */
1820   function getMetadataURL(bytes _uri, uint256 _tokenId) internal pure returns (string) {
1821     uint256 _tmpTokenId = _tokenId;
1822     uint256 _tokenLength;
1823 
1824     // Getting the length(number of digits) of token ID
1825     do {
1826       _tokenLength++;
1827       _tmpTokenId /= 10;
1828     } while (_tmpTokenId > 0);
1829 
1830     // creating a byte array with the length of URL + token digits
1831     bytes memory _result = new bytes(_uri.length + _tokenLength);
1832 
1833     // cloning the uri bytes into the result bytes
1834     for(uint256 i = 0 ; i < _uri.length ; i ++) {
1835       _result[i] = _uri[i];
1836     }
1837 
1838     // appending the tokenId to the end of the result bytes
1839     uint256 lastIndex = _result.length - 1;
1840     for(_tmpTokenId = _tokenId ; _tmpTokenId > 0 ; _tmpTokenId /= 10) {
1841       _result[lastIndex--] = byte(48 + _tmpTokenId % 10);
1842     }
1843 
1844     return string(_result);
1845   }
1846 }