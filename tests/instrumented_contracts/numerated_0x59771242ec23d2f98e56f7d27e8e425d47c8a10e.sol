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
594   event ReferralPurchase(address indexed referral, uint256 rewardAmount, address buyer);
595 
596   uint256 constant public PRESALE_LIMIT = 5000;
597 
598   /**
599    * @dev Currently is set to 26/12/2018 00:00:00
600    */
601   uint256 public presaleEndTime = 1545782400;
602 
603   /**
604    * @dev Initial presale price is 0.25 ether
605    */
606   uint256 public currentPresalePrice = 250 finney;
607 
608   /** 
609    * @dev tracks the current token id, starts from 1004
610    */
611   uint256 public currentTokenId = 1004;
612 
613   /** 
614    * @dev tracks the current giveaway token id, starts from 5102
615    */
616   uint256 public giveawayTokenId = 5102;
617 
618   /**
619    * @dev The percentage of referral cut
620    */
621   uint256 public referralCut = 10;
622 
623   constructor
624   (
625     address _genesisCrabAddress, 
626     address _cryptantCrabTokenAddress, 
627     address _cryptantCrabStorageAddress
628   ) 
629   public 
630   CryptantCrabPurchasable
631   (
632     _genesisCrabAddress, 
633     _cryptantCrabTokenAddress, 
634     _cryptantCrabStorageAddress
635   ) {
636     // constructor
637 
638   }
639 
640   function setCurrentTokenId(uint256 _newTokenId) external onlyOwner {
641     currentTokenId = _newTokenId;
642   }
643 
644   function setPresaleEndtime(uint256 _newEndTime) external onlyOwner {
645     presaleEndTime = _newEndTime;
646   }
647 
648   function setReferralCut(uint256 _newReferralCut) external onlyOwner {
649     referralCut = _newReferralCut;
650   }
651 
652   function getPresalePrice() public view returns (uint256) {
653     return currentPresalePrice;
654   }
655 
656   function purchase(uint256 _amount) external payable {
657     purchaseWithReferral(_amount, address(0));
658   }
659 
660   function purchaseWithReferral(uint256 _amount, address _referral) public payable {
661     require(genesisCrab != address(0));
662     require(cryptantCrabToken != address(0));
663     require(cryptantCrabStorage != address(0));
664     require(msg.sender != _referral);
665     require(_amount > 0 && _amount <= 10);
666     require(isPresale());
667     require(PRESALE_LIMIT >= currentTokenId + _amount);
668 
669     uint256 _value = msg.value;
670     uint256 _currentPresalePrice = getPresalePrice();
671     uint256 _totalRequiredAmount = _currentPresalePrice * _amount;
672 
673     require(_value >= _totalRequiredAmount);
674 
675     // Purchase 10 crabs will have 1 crab with legendary part
676     // Default value for _crabWithLegendaryPart is just a unreacable number
677     uint256 _crabWithLegendaryPart = 100;
678     if(_amount == 10) {
679       // decide which crab will have the legendary part
680       _crabWithLegendaryPart = _generateRandomNumber(bytes32(currentTokenId), 10);
681     }
682 
683     for(uint256 i = 0 ; i < _amount ; i++) {
684       currentTokenId++;
685       _createCrab(true, currentTokenId, _currentPresalePrice, 0, 0, 0, _crabWithLegendaryPart == i);
686     }
687 
688     // Presale crab will get free cryptant fragments
689     _addCryptantFragments(msg.sender, (i * 3000));
690 
691     // Refund exceeded value
692     _refundExceededValue(_value, _totalRequiredAmount);
693 
694     // If there's referral, will transfer the referral reward to the referral
695     if(_referral != address(0)) {
696       uint256 _referralReward = _totalRequiredAmount * referralCut / 100;
697       _referral.transfer(_referralReward);
698       emit ReferralPurchase(_referral, _referralReward, msg.sender);
699     }
700 
701     emit PresalePurchased(msg.sender, _amount, i * 3000, _value - _totalRequiredAmount);
702   }
703 
704   function createCrab(uint256 _customTokenId, uint256 _crabPrice, uint256 _customGene, uint256 _customSkin, uint256 _customHeart, bool _hasLegendary) external onlyOwner {
705     return _createCrab(true, _customTokenId, _crabPrice, _customGene, _customSkin, _customHeart, _hasLegendary);
706   }
707 
708   function generateGiveawayCrabs(uint256 _amount) external onlyOwner {
709     for(uint256 i = 0 ; i < _amount ; i++) {
710       _createCrab(false, giveawayTokenId++, 120 finney, 0, 0, 0, false);
711     }
712   }
713 
714   function isPresale() internal view returns (bool) {
715     return now < presaleEndTime;
716   }
717 }
718 
719 contract RBAC {
720   using Roles for Roles.Role;
721 
722   mapping (string => Roles.Role) private roles;
723 
724   event RoleAdded(address indexed operator, string role);
725   event RoleRemoved(address indexed operator, string role);
726 
727   /**
728    * @dev reverts if addr does not have role
729    * @param _operator address
730    * @param _role the name of the role
731    * // reverts
732    */
733   function checkRole(address _operator, string _role)
734     view
735     public
736   {
737     roles[_role].check(_operator);
738   }
739 
740   /**
741    * @dev determine if addr has role
742    * @param _operator address
743    * @param _role the name of the role
744    * @return bool
745    */
746   function hasRole(address _operator, string _role)
747     view
748     public
749     returns (bool)
750   {
751     return roles[_role].has(_operator);
752   }
753 
754   /**
755    * @dev add a role to an address
756    * @param _operator address
757    * @param _role the name of the role
758    */
759   function addRole(address _operator, string _role)
760     internal
761   {
762     roles[_role].add(_operator);
763     emit RoleAdded(_operator, _role);
764   }
765 
766   /**
767    * @dev remove a role from an address
768    * @param _operator address
769    * @param _role the name of the role
770    */
771   function removeRole(address _operator, string _role)
772     internal
773   {
774     roles[_role].remove(_operator);
775     emit RoleRemoved(_operator, _role);
776   }
777 
778   /**
779    * @dev modifier to scope access to a single role (uses msg.sender as addr)
780    * @param _role the name of the role
781    * // reverts
782    */
783   modifier onlyRole(string _role)
784   {
785     checkRole(msg.sender, _role);
786     _;
787   }
788 
789   /**
790    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
791    * @param _roles the names of the roles to scope access to
792    * // reverts
793    *
794    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
795    *  see: https://github.com/ethereum/solidity/issues/2467
796    */
797   // modifier onlyRoles(string[] _roles) {
798   //     bool hasAnyRole = false;
799   //     for (uint8 i = 0; i < _roles.length; i++) {
800   //         if (hasRole(msg.sender, _roles[i])) {
801   //             hasAnyRole = true;
802   //             break;
803   //         }
804   //     }
805 
806   //     require(hasAnyRole);
807 
808   //     _;
809   // }
810 }
811 
812 contract Whitelist is Ownable, RBAC {
813   string public constant ROLE_WHITELISTED = "whitelist";
814 
815   /**
816    * @dev Throws if operator is not whitelisted.
817    * @param _operator address
818    */
819   modifier onlyIfWhitelisted(address _operator) {
820     checkRole(_operator, ROLE_WHITELISTED);
821     _;
822   }
823 
824   /**
825    * @dev add an address to the whitelist
826    * @param _operator address
827    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
828    */
829   function addAddressToWhitelist(address _operator)
830     onlyOwner
831     public
832   {
833     addRole(_operator, ROLE_WHITELISTED);
834   }
835 
836   /**
837    * @dev getter to determine if address is in whitelist
838    */
839   function whitelist(address _operator)
840     public
841     view
842     returns (bool)
843   {
844     return hasRole(_operator, ROLE_WHITELISTED);
845   }
846 
847   /**
848    * @dev add addresses to the whitelist
849    * @param _operators addresses
850    * @return true if at least one address was added to the whitelist,
851    * false if all addresses were already in the whitelist
852    */
853   function addAddressesToWhitelist(address[] _operators)
854     onlyOwner
855     public
856   {
857     for (uint256 i = 0; i < _operators.length; i++) {
858       addAddressToWhitelist(_operators[i]);
859     }
860   }
861 
862   /**
863    * @dev remove an address from the whitelist
864    * @param _operator address
865    * @return true if the address was removed from the whitelist,
866    * false if the address wasn't in the whitelist in the first place
867    */
868   function removeAddressFromWhitelist(address _operator)
869     onlyOwner
870     public
871   {
872     removeRole(_operator, ROLE_WHITELISTED);
873   }
874 
875   /**
876    * @dev remove addresses from the whitelist
877    * @param _operators addresses
878    * @return true if at least one address was removed from the whitelist,
879    * false if all addresses weren't in the whitelist in the first place
880    */
881   function removeAddressesFromWhitelist(address[] _operators)
882     onlyOwner
883     public
884   {
885     for (uint256 i = 0; i < _operators.length; i++) {
886       removeAddressFromWhitelist(_operators[i]);
887     }
888   }
889 
890 }
891 
892 library Roles {
893   struct Role {
894     mapping (address => bool) bearer;
895   }
896 
897   /**
898    * @dev give an address access to this role
899    */
900   function add(Role storage role, address addr)
901     internal
902   {
903     role.bearer[addr] = true;
904   }
905 
906   /**
907    * @dev remove an address' access to this role
908    */
909   function remove(Role storage role, address addr)
910     internal
911   {
912     role.bearer[addr] = false;
913   }
914 
915   /**
916    * @dev check if an address has this role
917    * // reverts
918    */
919   function check(Role storage role, address addr)
920     view
921     internal
922   {
923     require(has(role, addr));
924   }
925 
926   /**
927    * @dev check if an address has this role
928    * @return bool
929    */
930   function has(Role storage role, address addr)
931     view
932     internal
933     returns (bool)
934   {
935     return role.bearer[addr];
936   }
937 }
938 
939 contract ERC721Basic is ERC165 {
940   event Transfer(
941     address indexed _from,
942     address indexed _to,
943     uint256 indexed _tokenId
944   );
945   event Approval(
946     address indexed _owner,
947     address indexed _approved,
948     uint256 indexed _tokenId
949   );
950   event ApprovalForAll(
951     address indexed _owner,
952     address indexed _operator,
953     bool _approved
954   );
955 
956   function balanceOf(address _owner) public view returns (uint256 _balance);
957   function ownerOf(uint256 _tokenId) public view returns (address _owner);
958   function exists(uint256 _tokenId) public view returns (bool _exists);
959 
960   function approve(address _to, uint256 _tokenId) public;
961   function getApproved(uint256 _tokenId)
962     public view returns (address _operator);
963 
964   function setApprovalForAll(address _operator, bool _approved) public;
965   function isApprovedForAll(address _owner, address _operator)
966     public view returns (bool);
967 
968   function transferFrom(address _from, address _to, uint256 _tokenId) public;
969   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
970     public;
971 
972   function safeTransferFrom(
973     address _from,
974     address _to,
975     uint256 _tokenId,
976     bytes _data
977   )
978     public;
979 }
980 
981 contract ERC721Enumerable is ERC721Basic {
982   function totalSupply() public view returns (uint256);
983   function tokenOfOwnerByIndex(
984     address _owner,
985     uint256 _index
986   )
987     public
988     view
989     returns (uint256 _tokenId);
990 
991   function tokenByIndex(uint256 _index) public view returns (uint256);
992 }
993 
994 contract ERC721Metadata is ERC721Basic {
995   function name() external view returns (string _name);
996   function symbol() external view returns (string _symbol);
997   function tokenURI(uint256 _tokenId) public view returns (string);
998 }
999 
1000 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
1001 }
1002 
1003 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
1004 
1005   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
1006   /*
1007    * 0x80ac58cd ===
1008    *   bytes4(keccak256('balanceOf(address)')) ^
1009    *   bytes4(keccak256('ownerOf(uint256)')) ^
1010    *   bytes4(keccak256('approve(address,uint256)')) ^
1011    *   bytes4(keccak256('getApproved(uint256)')) ^
1012    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1013    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
1014    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1015    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1016    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1017    */
1018 
1019   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
1020   /*
1021    * 0x4f558e79 ===
1022    *   bytes4(keccak256('exists(uint256)'))
1023    */
1024 
1025   using SafeMath for uint256;
1026   using AddressUtils for address;
1027 
1028   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1029   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
1030   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
1031 
1032   // Mapping from token ID to owner
1033   mapping (uint256 => address) internal tokenOwner;
1034 
1035   // Mapping from token ID to approved address
1036   mapping (uint256 => address) internal tokenApprovals;
1037 
1038   // Mapping from owner to number of owned token
1039   mapping (address => uint256) internal ownedTokensCount;
1040 
1041   // Mapping from owner to operator approvals
1042   mapping (address => mapping (address => bool)) internal operatorApprovals;
1043 
1044   /**
1045    * @dev Guarantees msg.sender is owner of the given token
1046    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
1047    */
1048   modifier onlyOwnerOf(uint256 _tokenId) {
1049     require(ownerOf(_tokenId) == msg.sender);
1050     _;
1051   }
1052 
1053   /**
1054    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
1055    * @param _tokenId uint256 ID of the token to validate
1056    */
1057   modifier canTransfer(uint256 _tokenId) {
1058     require(isApprovedOrOwner(msg.sender, _tokenId));
1059     _;
1060   }
1061 
1062   constructor()
1063     public
1064   {
1065     // register the supported interfaces to conform to ERC721 via ERC165
1066     _registerInterface(InterfaceId_ERC721);
1067     _registerInterface(InterfaceId_ERC721Exists);
1068   }
1069 
1070   /**
1071    * @dev Gets the balance of the specified address
1072    * @param _owner address to query the balance of
1073    * @return uint256 representing the amount owned by the passed address
1074    */
1075   function balanceOf(address _owner) public view returns (uint256) {
1076     require(_owner != address(0));
1077     return ownedTokensCount[_owner];
1078   }
1079 
1080   /**
1081    * @dev Gets the owner of the specified token ID
1082    * @param _tokenId uint256 ID of the token to query the owner of
1083    * @return owner address currently marked as the owner of the given token ID
1084    */
1085   function ownerOf(uint256 _tokenId) public view returns (address) {
1086     address owner = tokenOwner[_tokenId];
1087     require(owner != address(0));
1088     return owner;
1089   }
1090 
1091   /**
1092    * @dev Returns whether the specified token exists
1093    * @param _tokenId uint256 ID of the token to query the existence of
1094    * @return whether the token exists
1095    */
1096   function exists(uint256 _tokenId) public view returns (bool) {
1097     address owner = tokenOwner[_tokenId];
1098     return owner != address(0);
1099   }
1100 
1101   /**
1102    * @dev Approves another address to transfer the given token ID
1103    * The zero address indicates there is no approved address.
1104    * There can only be one approved address per token at a given time.
1105    * Can only be called by the token owner or an approved operator.
1106    * @param _to address to be approved for the given token ID
1107    * @param _tokenId uint256 ID of the token to be approved
1108    */
1109   function approve(address _to, uint256 _tokenId) public {
1110     address owner = ownerOf(_tokenId);
1111     require(_to != owner);
1112     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1113 
1114     tokenApprovals[_tokenId] = _to;
1115     emit Approval(owner, _to, _tokenId);
1116   }
1117 
1118   /**
1119    * @dev Gets the approved address for a token ID, or zero if no address set
1120    * @param _tokenId uint256 ID of the token to query the approval of
1121    * @return address currently approved for the given token ID
1122    */
1123   function getApproved(uint256 _tokenId) public view returns (address) {
1124     return tokenApprovals[_tokenId];
1125   }
1126 
1127   /**
1128    * @dev Sets or unsets the approval of a given operator
1129    * An operator is allowed to transfer all tokens of the sender on their behalf
1130    * @param _to operator address to set the approval
1131    * @param _approved representing the status of the approval to be set
1132    */
1133   function setApprovalForAll(address _to, bool _approved) public {
1134     require(_to != msg.sender);
1135     operatorApprovals[msg.sender][_to] = _approved;
1136     emit ApprovalForAll(msg.sender, _to, _approved);
1137   }
1138 
1139   /**
1140    * @dev Tells whether an operator is approved by a given owner
1141    * @param _owner owner address which you want to query the approval of
1142    * @param _operator operator address which you want to query the approval of
1143    * @return bool whether the given operator is approved by the given owner
1144    */
1145   function isApprovedForAll(
1146     address _owner,
1147     address _operator
1148   )
1149     public
1150     view
1151     returns (bool)
1152   {
1153     return operatorApprovals[_owner][_operator];
1154   }
1155 
1156   /**
1157    * @dev Transfers the ownership of a given token ID to another address
1158    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1159    * Requires the msg sender to be the owner, approved, or operator
1160    * @param _from current owner of the token
1161    * @param _to address to receive the ownership of the given token ID
1162    * @param _tokenId uint256 ID of the token to be transferred
1163   */
1164   function transferFrom(
1165     address _from,
1166     address _to,
1167     uint256 _tokenId
1168   )
1169     public
1170     canTransfer(_tokenId)
1171   {
1172     require(_from != address(0));
1173     require(_to != address(0));
1174 
1175     clearApproval(_from, _tokenId);
1176     removeTokenFrom(_from, _tokenId);
1177     addTokenTo(_to, _tokenId);
1178 
1179     emit Transfer(_from, _to, _tokenId);
1180   }
1181 
1182   /**
1183    * @dev Safely transfers the ownership of a given token ID to another address
1184    * If the target address is a contract, it must implement `onERC721Received`,
1185    * which is called upon a safe transfer, and return the magic value
1186    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1187    * the transfer is reverted.
1188    *
1189    * Requires the msg sender to be the owner, approved, or operator
1190    * @param _from current owner of the token
1191    * @param _to address to receive the ownership of the given token ID
1192    * @param _tokenId uint256 ID of the token to be transferred
1193   */
1194   function safeTransferFrom(
1195     address _from,
1196     address _to,
1197     uint256 _tokenId
1198   )
1199     public
1200     canTransfer(_tokenId)
1201   {
1202     // solium-disable-next-line arg-overflow
1203     safeTransferFrom(_from, _to, _tokenId, "");
1204   }
1205 
1206   /**
1207    * @dev Safely transfers the ownership of a given token ID to another address
1208    * If the target address is a contract, it must implement `onERC721Received`,
1209    * which is called upon a safe transfer, and return the magic value
1210    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1211    * the transfer is reverted.
1212    * Requires the msg sender to be the owner, approved, or operator
1213    * @param _from current owner of the token
1214    * @param _to address to receive the ownership of the given token ID
1215    * @param _tokenId uint256 ID of the token to be transferred
1216    * @param _data bytes data to send along with a safe transfer check
1217    */
1218   function safeTransferFrom(
1219     address _from,
1220     address _to,
1221     uint256 _tokenId,
1222     bytes _data
1223   )
1224     public
1225     canTransfer(_tokenId)
1226   {
1227     transferFrom(_from, _to, _tokenId);
1228     // solium-disable-next-line arg-overflow
1229     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1230   }
1231 
1232   /**
1233    * @dev Returns whether the given spender can transfer a given token ID
1234    * @param _spender address of the spender to query
1235    * @param _tokenId uint256 ID of the token to be transferred
1236    * @return bool whether the msg.sender is approved for the given token ID,
1237    *  is an operator of the owner, or is the owner of the token
1238    */
1239   function isApprovedOrOwner(
1240     address _spender,
1241     uint256 _tokenId
1242   )
1243     internal
1244     view
1245     returns (bool)
1246   {
1247     address owner = ownerOf(_tokenId);
1248     // Disable solium check because of
1249     // https://github.com/duaraghav8/Solium/issues/175
1250     // solium-disable-next-line operator-whitespace
1251     return (
1252       _spender == owner ||
1253       getApproved(_tokenId) == _spender ||
1254       isApprovedForAll(owner, _spender)
1255     );
1256   }
1257 
1258   /**
1259    * @dev Internal function to mint a new token
1260    * Reverts if the given token ID already exists
1261    * @param _to The address that will own the minted token
1262    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1263    */
1264   function _mint(address _to, uint256 _tokenId) internal {
1265     require(_to != address(0));
1266     addTokenTo(_to, _tokenId);
1267     emit Transfer(address(0), _to, _tokenId);
1268   }
1269 
1270   /**
1271    * @dev Internal function to burn a specific token
1272    * Reverts if the token does not exist
1273    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1274    */
1275   function _burn(address _owner, uint256 _tokenId) internal {
1276     clearApproval(_owner, _tokenId);
1277     removeTokenFrom(_owner, _tokenId);
1278     emit Transfer(_owner, address(0), _tokenId);
1279   }
1280 
1281   /**
1282    * @dev Internal function to clear current approval of a given token ID
1283    * Reverts if the given address is not indeed the owner of the token
1284    * @param _owner owner of the token
1285    * @param _tokenId uint256 ID of the token to be transferred
1286    */
1287   function clearApproval(address _owner, uint256 _tokenId) internal {
1288     require(ownerOf(_tokenId) == _owner);
1289     if (tokenApprovals[_tokenId] != address(0)) {
1290       tokenApprovals[_tokenId] = address(0);
1291     }
1292   }
1293 
1294   /**
1295    * @dev Internal function to add a token ID to the list of a given address
1296    * @param _to address representing the new owner of the given token ID
1297    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1298    */
1299   function addTokenTo(address _to, uint256 _tokenId) internal {
1300     require(tokenOwner[_tokenId] == address(0));
1301     tokenOwner[_tokenId] = _to;
1302     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1303   }
1304 
1305   /**
1306    * @dev Internal function to remove a token ID from the list of a given address
1307    * @param _from address representing the previous owner of the given token ID
1308    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1309    */
1310   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1311     require(ownerOf(_tokenId) == _from);
1312     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1313     tokenOwner[_tokenId] = address(0);
1314   }
1315 
1316   /**
1317    * @dev Internal function to invoke `onERC721Received` on a target address
1318    * The call is not executed if the target address is not a contract
1319    * @param _from address representing the previous owner of the given token ID
1320    * @param _to target address that will receive the tokens
1321    * @param _tokenId uint256 ID of the token to be transferred
1322    * @param _data bytes optional data to send along with the call
1323    * @return whether the call correctly returned the expected magic value
1324    */
1325   function checkAndCallSafeTransfer(
1326     address _from,
1327     address _to,
1328     uint256 _tokenId,
1329     bytes _data
1330   )
1331     internal
1332     returns (bool)
1333   {
1334     if (!_to.isContract()) {
1335       return true;
1336     }
1337     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1338       msg.sender, _from, _tokenId, _data);
1339     return (retval == ERC721_RECEIVED);
1340   }
1341 }
1342 
1343 contract ERC721Receiver {
1344   /**
1345    * @dev Magic value to be returned upon successful reception of an NFT
1346    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
1347    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
1348    */
1349   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
1350 
1351   /**
1352    * @notice Handle the receipt of an NFT
1353    * @dev The ERC721 smart contract calls this function on the recipient
1354    * after a `safetransfer`. This function MAY throw to revert and reject the
1355    * transfer. Return of other than the magic value MUST result in the 
1356    * transaction being reverted.
1357    * Note: the contract address is always the message sender.
1358    * @param _operator The address which called `safeTransferFrom` function
1359    * @param _from The address which previously owned the token
1360    * @param _tokenId The NFT identifier which is being transfered
1361    * @param _data Additional data with no specified format
1362    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1363    */
1364   function onERC721Received(
1365     address _operator,
1366     address _from,
1367     uint256 _tokenId,
1368     bytes _data
1369   )
1370     public
1371     returns(bytes4);
1372 }
1373 
1374 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1375 
1376   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
1377   /**
1378    * 0x780e9d63 ===
1379    *   bytes4(keccak256('totalSupply()')) ^
1380    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
1381    *   bytes4(keccak256('tokenByIndex(uint256)'))
1382    */
1383 
1384   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
1385   /**
1386    * 0x5b5e139f ===
1387    *   bytes4(keccak256('name()')) ^
1388    *   bytes4(keccak256('symbol()')) ^
1389    *   bytes4(keccak256('tokenURI(uint256)'))
1390    */
1391 
1392   // Token name
1393   string internal name_;
1394 
1395   // Token symbol
1396   string internal symbol_;
1397 
1398   // Mapping from owner to list of owned token IDs
1399   mapping(address => uint256[]) internal ownedTokens;
1400 
1401   // Mapping from token ID to index of the owner tokens list
1402   mapping(uint256 => uint256) internal ownedTokensIndex;
1403 
1404   // Array with all token ids, used for enumeration
1405   uint256[] internal allTokens;
1406 
1407   // Mapping from token id to position in the allTokens array
1408   mapping(uint256 => uint256) internal allTokensIndex;
1409 
1410   // Optional mapping for token URIs
1411   mapping(uint256 => string) internal tokenURIs;
1412 
1413   /**
1414    * @dev Constructor function
1415    */
1416   constructor(string _name, string _symbol) public {
1417     name_ = _name;
1418     symbol_ = _symbol;
1419 
1420     // register the supported interfaces to conform to ERC721 via ERC165
1421     _registerInterface(InterfaceId_ERC721Enumerable);
1422     _registerInterface(InterfaceId_ERC721Metadata);
1423   }
1424 
1425   /**
1426    * @dev Gets the token name
1427    * @return string representing the token name
1428    */
1429   function name() external view returns (string) {
1430     return name_;
1431   }
1432 
1433   /**
1434    * @dev Gets the token symbol
1435    * @return string representing the token symbol
1436    */
1437   function symbol() external view returns (string) {
1438     return symbol_;
1439   }
1440 
1441   /**
1442    * @dev Returns an URI for a given token ID
1443    * Throws if the token ID does not exist. May return an empty string.
1444    * @param _tokenId uint256 ID of the token to query
1445    */
1446   function tokenURI(uint256 _tokenId) public view returns (string) {
1447     require(exists(_tokenId));
1448     return tokenURIs[_tokenId];
1449   }
1450 
1451   /**
1452    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1453    * @param _owner address owning the tokens list to be accessed
1454    * @param _index uint256 representing the index to be accessed of the requested tokens list
1455    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1456    */
1457   function tokenOfOwnerByIndex(
1458     address _owner,
1459     uint256 _index
1460   )
1461     public
1462     view
1463     returns (uint256)
1464   {
1465     require(_index < balanceOf(_owner));
1466     return ownedTokens[_owner][_index];
1467   }
1468 
1469   /**
1470    * @dev Gets the total amount of tokens stored by the contract
1471    * @return uint256 representing the total amount of tokens
1472    */
1473   function totalSupply() public view returns (uint256) {
1474     return allTokens.length;
1475   }
1476 
1477   /**
1478    * @dev Gets the token ID at a given index of all the tokens in this contract
1479    * Reverts if the index is greater or equal to the total number of tokens
1480    * @param _index uint256 representing the index to be accessed of the tokens list
1481    * @return uint256 token ID at the given index of the tokens list
1482    */
1483   function tokenByIndex(uint256 _index) public view returns (uint256) {
1484     require(_index < totalSupply());
1485     return allTokens[_index];
1486   }
1487 
1488   /**
1489    * @dev Internal function to set the token URI for a given token
1490    * Reverts if the token ID does not exist
1491    * @param _tokenId uint256 ID of the token to set its URI
1492    * @param _uri string URI to assign
1493    */
1494   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1495     require(exists(_tokenId));
1496     tokenURIs[_tokenId] = _uri;
1497   }
1498 
1499   /**
1500    * @dev Internal function to add a token ID to the list of a given address
1501    * @param _to address representing the new owner of the given token ID
1502    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1503    */
1504   function addTokenTo(address _to, uint256 _tokenId) internal {
1505     super.addTokenTo(_to, _tokenId);
1506     uint256 length = ownedTokens[_to].length;
1507     ownedTokens[_to].push(_tokenId);
1508     ownedTokensIndex[_tokenId] = length;
1509   }
1510 
1511   /**
1512    * @dev Internal function to remove a token ID from the list of a given address
1513    * @param _from address representing the previous owner of the given token ID
1514    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1515    */
1516   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1517     super.removeTokenFrom(_from, _tokenId);
1518 
1519     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1520     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1521     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1522 
1523     ownedTokens[_from][tokenIndex] = lastToken;
1524     ownedTokens[_from][lastTokenIndex] = 0;
1525     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1526     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1527     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1528 
1529     ownedTokens[_from].length--;
1530     ownedTokensIndex[_tokenId] = 0;
1531     ownedTokensIndex[lastToken] = tokenIndex;
1532   }
1533 
1534   /**
1535    * @dev Internal function to mint a new token
1536    * Reverts if the given token ID already exists
1537    * @param _to address the beneficiary that will own the minted token
1538    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1539    */
1540   function _mint(address _to, uint256 _tokenId) internal {
1541     super._mint(_to, _tokenId);
1542 
1543     allTokensIndex[_tokenId] = allTokens.length;
1544     allTokens.push(_tokenId);
1545   }
1546 
1547   /**
1548    * @dev Internal function to burn a specific token
1549    * Reverts if the token does not exist
1550    * @param _owner owner of the token to burn
1551    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1552    */
1553   function _burn(address _owner, uint256 _tokenId) internal {
1554     super._burn(_owner, _tokenId);
1555 
1556     // Clear metadata (if any)
1557     if (bytes(tokenURIs[_tokenId]).length != 0) {
1558       delete tokenURIs[_tokenId];
1559     }
1560 
1561     // Reorg all tokens array
1562     uint256 tokenIndex = allTokensIndex[_tokenId];
1563     uint256 lastTokenIndex = allTokens.length.sub(1);
1564     uint256 lastToken = allTokens[lastTokenIndex];
1565 
1566     allTokens[tokenIndex] = lastToken;
1567     allTokens[lastTokenIndex] = 0;
1568 
1569     allTokens.length--;
1570     allTokensIndex[_tokenId] = 0;
1571     allTokensIndex[lastToken] = tokenIndex;
1572   }
1573 
1574 }
1575 
1576 contract CryptantCrabNFT is ERC721Token, Whitelist, CrabData, GeneSurgeon {
1577   event CrabPartAdded(uint256 hp, uint256 dps, uint256 blockAmount);
1578   event GiftTransfered(address indexed _from, address indexed _to, uint256 indexed _tokenId);
1579   event DefaultMetadataURIChanged(string newUri);
1580 
1581   /**
1582    * @dev Pre-generated keys to save gas
1583    * keys are generated with:
1584    * CRAB_BODY       = bytes4(keccak256("crab_body"))       = 0xc398430e
1585    * CRAB_LEG        = bytes4(keccak256("crab_leg"))        = 0x889063b1
1586    * CRAB_LEFT_CLAW  = bytes4(keccak256("crab_left_claw"))  = 0xdb6290a2
1587    * CRAB_RIGHT_CLAW = bytes4(keccak256("crab_right_claw")) = 0x13453f89
1588    */
1589   bytes4 internal constant CRAB_BODY = 0xc398430e;
1590   bytes4 internal constant CRAB_LEG = 0x889063b1;
1591   bytes4 internal constant CRAB_LEFT_CLAW = 0xdb6290a2;
1592   bytes4 internal constant CRAB_RIGHT_CLAW = 0x13453f89;
1593 
1594   /**
1595    * @dev Stores all the crab data
1596    */
1597   mapping(bytes4 => mapping(uint256 => CrabPartData[])) internal crabPartData;
1598 
1599   /**
1600    * @dev Mapping from tokenId to its corresponding special skin
1601    * tokenId with default skin will not be stored. 
1602    */
1603   mapping(uint256 => uint256) internal crabSpecialSkins;
1604 
1605   /**
1606    * @dev default MetadataURI
1607    */
1608   string public defaultMetadataURI = "https://www.cryptantcrab.io/md/";
1609 
1610   constructor(string _name, string _symbol) public ERC721Token(_name, _symbol) {
1611     // constructor
1612     initiateCrabPartData();
1613   }
1614 
1615   /**
1616    * @dev Returns an URI for a given token ID
1617    * Throws if the token ID does not exist.
1618    * Will return the token's metadata URL if it has one, 
1619    * otherwise will just return base on the default metadata URI
1620    * @param _tokenId uint256 ID of the token to query
1621    */
1622   function tokenURI(uint256 _tokenId) public view returns (string) {
1623     require(exists(_tokenId));
1624 
1625     string memory _uri = tokenURIs[_tokenId];
1626 
1627     if(bytes(_uri).length == 0) {
1628       _uri = getMetadataURL(bytes(defaultMetadataURI), _tokenId);
1629     }
1630 
1631     return _uri;
1632   }
1633 
1634   /**
1635    * @dev Returns the data of a specific parts
1636    * @param _partIndex the part to retrieve. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
1637    * @param _element the element of part to retrieve. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
1638    * @param _setIndex the set index of for the specified part. This will starts from 1.
1639    */
1640   function dataOfPart(uint256 _partIndex, uint256 _element, uint256 _setIndex) public view returns (uint256[] memory _resultData) {
1641     bytes4 _key;
1642     if(_partIndex == 1) {
1643       _key = CRAB_BODY;
1644     } else if(_partIndex == 2) {
1645       _key = CRAB_LEG;
1646     } else if(_partIndex == 3) {
1647       _key = CRAB_LEFT_CLAW;
1648     } else if(_partIndex == 4) {
1649       _key = CRAB_RIGHT_CLAW;
1650     } else {
1651       revert();
1652     }
1653 
1654     CrabPartData storage _crabPartData = crabPartData[_key][_element][_setIndex];
1655 
1656     _resultData = crabPartDataToArray(_crabPartData);
1657   }
1658 
1659   /**
1660    * @dev Gift(Transfer) a token to another address. Caller must be token owner
1661    * @param _from current owner of the token
1662    * @param _to address to receive the ownership of the given token ID
1663    * @param _tokenId uint256 ID of the token to be transferred
1664    */
1665   function giftToken(address _from, address _to, uint256 _tokenId) external {
1666     safeTransferFrom(_from, _to, _tokenId);
1667 
1668     emit GiftTransfered(_from, _to, _tokenId);
1669   }
1670 
1671   /**
1672    * @dev External function to mint a new token, for whitelisted address only.
1673    * Reverts if the given token ID already exists
1674    * @param _tokenOwner address the beneficiary that will own the minted token
1675    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1676    * @param _skinId the skin ID to be applied for all the token minted
1677    */
1678   function mintToken(address _tokenOwner, uint256 _tokenId, uint256 _skinId) external onlyIfWhitelisted(msg.sender) {
1679     super._mint(_tokenOwner, _tokenId);
1680 
1681     if(_skinId > 0) {
1682       crabSpecialSkins[_tokenId] = _skinId;
1683     }
1684   }
1685 
1686   /**
1687    * @dev Returns crab data base on the gene provided
1688    * @param _gene the gene info where crab data will be retrieved base on it
1689    * @return 4 uint arrays:
1690    * 1st Array = Body's Data
1691    * 2nd Array = Leg's Data
1692    * 3rd Array = Left Claw's Data
1693    * 4th Array = Right Claw's Data
1694    */
1695   function crabPartDataFromGene(uint256 _gene) external view returns (
1696     uint256[] _bodyData,
1697     uint256[] _legData,
1698     uint256[] _leftClawData,
1699     uint256[] _rightClawData
1700   ) {
1701     uint256[] memory _parts = extractPartsFromGene(_gene);
1702     uint256[] memory _elements = extractElementsFromGene(_gene);
1703 
1704     _bodyData = dataOfPart(1, _elements[0], _parts[0]);
1705     _legData = dataOfPart(2, _elements[1], _parts[1]);
1706     _leftClawData = dataOfPart(3, _elements[2], _parts[2]);
1707     _rightClawData = dataOfPart(4, _elements[3], _parts[3]);
1708   }
1709 
1710   /**
1711    * @dev For developer to add new parts, notice that this is the only method to add crab data
1712    * so that developer can add extra content. there's no other method for developer to modify
1713    * the data. This is to assure token owner actually owns their data.
1714    * @param _partIndex the part to add. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
1715    * @param _element the element of part to add. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
1716    * @param _partDataArray data of the parts.
1717    */
1718   function setPartData(uint256 _partIndex, uint256 _element, uint256[] _partDataArray) external onlyOwner {
1719     CrabPartData memory _partData = arrayToCrabPartData(_partDataArray);
1720 
1721     bytes4 _key;
1722     if(_partIndex == 1) {
1723       _key = CRAB_BODY;
1724     } else if(_partIndex == 2) {
1725       _key = CRAB_LEG;
1726     } else if(_partIndex == 3) {
1727       _key = CRAB_LEFT_CLAW;
1728     } else if(_partIndex == 4) {
1729       _key = CRAB_RIGHT_CLAW;
1730     }
1731 
1732     // if index 1 is empty will fill at index 1
1733     if(crabPartData[_key][_element][1].hp == 0 && crabPartData[_key][_element][1].dps == 0) {
1734       crabPartData[_key][_element][1] = _partData;
1735     } else {
1736       crabPartData[_key][_element].push(_partData);
1737     }
1738 
1739     emit CrabPartAdded(_partDataArray[0], _partDataArray[1], _partDataArray[2]);
1740   }
1741 
1742   /**
1743    * @dev Updates the default metadata URI
1744    * @param _defaultUri the new metadata URI
1745    */
1746   function setDefaultMetadataURI(string _defaultUri) external onlyOwner {
1747     defaultMetadataURI = _defaultUri;
1748 
1749     emit DefaultMetadataURIChanged(_defaultUri);
1750   }
1751 
1752   /**
1753    * @dev Updates the metadata URI for existing token
1754    * @param _tokenId the tokenID that metadata URI to be changed
1755    * @param _uri the new metadata URI for the specified token
1756    */
1757   function setTokenURI(uint256 _tokenId, string _uri) external onlyIfWhitelisted(msg.sender) {
1758     _setTokenURI(_tokenId, _uri);
1759   }
1760 
1761   /**
1762    * @dev Returns the special skin of the provided tokenId
1763    * @param _tokenId cryptant crab's tokenId
1764    * @return Special skin belongs to the _tokenId provided. 
1765    * 0 will be returned if no special skin found.
1766    */
1767   function specialSkinOfTokenId(uint256 _tokenId) external view returns (uint256) {
1768     return crabSpecialSkins[_tokenId];
1769   }
1770 
1771   /**
1772    * @dev This functions will adjust the length of crabPartData
1773    * so that when adding data the index can start with 1.
1774    * Reason of doing this is because gene cannot have parts with index 0.
1775    */
1776   function initiateCrabPartData() internal {
1777     require(crabPartData[CRAB_BODY][1].length == 0);
1778 
1779     for(uint256 i = 1 ; i <= 5 ; i++) {
1780       crabPartData[CRAB_BODY][i].length = 2;
1781       crabPartData[CRAB_LEG][i].length = 2;
1782       crabPartData[CRAB_LEFT_CLAW][i].length = 2;
1783       crabPartData[CRAB_RIGHT_CLAW][i].length = 2;
1784     }
1785   }
1786 
1787   /**
1788    * @dev Returns whether the given spender can transfer a given token ID
1789    * @param _spender address of the spender to query
1790    * @param _tokenId uint256 ID of the token to be transferred
1791    * @return bool whether the msg.sender is approved for the given token ID,
1792    *  is an operator of the owner, or is the owner of the token, 
1793    *  or has been whitelisted by contract owner
1794    */
1795   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
1796     address owner = ownerOf(_tokenId);
1797     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender) || whitelist(_spender);
1798   }
1799 
1800   /**
1801    * @dev Will merge the uri and tokenId together. 
1802    * @param _uri URI to be merge. This will be the first part of the result URL.
1803    * @param _tokenId tokenID to be merge. This will be the last part of the result URL.
1804    * @return the merged urL
1805    */
1806   function getMetadataURL(bytes _uri, uint256 _tokenId) internal pure returns (string) {
1807     uint256 _tmpTokenId = _tokenId;
1808     uint256 _tokenLength;
1809 
1810     // Getting the length(number of digits) of token ID
1811     do {
1812       _tokenLength++;
1813       _tmpTokenId /= 10;
1814     } while (_tmpTokenId > 0);
1815 
1816     // creating a byte array with the length of URL + token digits
1817     bytes memory _result = new bytes(_uri.length + _tokenLength);
1818 
1819     // cloning the uri bytes into the result bytes
1820     for(uint256 i = 0 ; i < _uri.length ; i ++) {
1821       _result[i] = _uri[i];
1822     }
1823 
1824     // appending the tokenId to the end of the result bytes
1825     uint256 lastIndex = _result.length - 1;
1826     for(_tmpTokenId = _tokenId ; _tmpTokenId > 0 ; _tmpTokenId /= 10) {
1827       _result[lastIndex--] = byte(48 + _tmpTokenId % 10);
1828     }
1829 
1830     return string(_result);
1831   }
1832 }