1 pragma solidity ^0.4.23;
2 
3 // File: contracts/zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/Acceptable.sol
46 
47 // @title Acceptable
48 // @author Takayuki Jimba
49 // @dev Provide basic access control.
50 contract Acceptable is Ownable {
51     address public sender;
52 
53     // @dev Throws if called by any address other than the sender.
54     modifier onlyAcceptable {
55         require(msg.sender == sender);
56         _;
57     }
58 
59     // @dev Change acceptable address
60     // @param _sender The address to new sender
61     function setAcceptable(address _sender) public onlyOwner {
62         sender = _sender;
63     }
64 }
65 
66 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
67 
68 /**
69  * @title ERC721 Non-Fungible Token Standard basic interface
70  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
71  */
72 contract ERC721Basic {
73   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
74   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
75   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
76 
77   function balanceOf(address _owner) public view returns (uint256 _balance);
78   function ownerOf(uint256 _tokenId) public view returns (address _owner);
79   function exists(uint256 _tokenId) public view returns (bool _exists);
80   
81   function approve(address _to, uint256 _tokenId) public;
82   function getApproved(uint256 _tokenId) public view returns (address _operator);
83   
84   function setApprovalForAll(address _operator, bool _approved) public;
85   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
86 
87   function transferFrom(address _from, address _to, uint256 _tokenId) public;
88   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
89   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
90 }
91 
92 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721.sol
93 
94 /**
95  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
96  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
97  */
98 contract ERC721Enumerable is ERC721Basic {
99   function totalSupply() public view returns (uint256);
100   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
101   function tokenByIndex(uint256 _index) public view returns (uint256);
102 }
103 
104 /**
105  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
106  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
107  */
108 contract ERC721Metadata is ERC721Basic {
109   function name() public view returns (string _name);
110   function symbol() public view returns (string _symbol);
111   function tokenURI(uint256 _tokenId) public view returns (string);
112 }
113 
114 /**
115  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
116  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
117  */
118 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
119 }
120 
121 // File: contracts/CrystalBaseIF.sol
122 
123 // @title CrystalBaseIF
124 // @author Takayuki Jimba
125 contract CrystalBaseIF is ERC721 {
126     function mint(address _owner, uint256 _gene, uint256 _kind, uint256 _weight) public returns(uint256);
127     function burn(address _owner, uint256 _tokenId) public;
128     function _transferFrom(address _from, address _to, uint256 _tokenId) public;
129     function getCrystalKindWeight(uint256 _tokenId) public view returns(uint256 kind, uint256 weight);
130     function getCrystalGeneKindWeight(uint256 _tokenId) public view returns(uint256 gene, uint256 kind, uint256 weight);
131 }
132 
133 // File: contracts/zeppelin-solidity/contracts/math/SafeMath.sol
134 
135 /**
136  * @title SafeMath
137  * @dev Math operations with safety checks that throw on error
138  */
139 library SafeMath {
140 
141   /**
142   * @dev Multiplies two numbers, throws on overflow.
143   */
144   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145     if (a == 0) {
146       return 0;
147     }
148     uint256 c = a * b;
149     assert(c / a == b);
150     return c;
151   }
152 
153   /**
154   * @dev Integer division of two numbers, truncating the quotient.
155   */
156   function div(uint256 a, uint256 b) internal pure returns (uint256) {
157     // assert(b > 0); // Solidity automatically throws when dividing by 0
158     uint256 c = a / b;
159     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160     return c;
161   }
162 
163   /**
164   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
165   */
166   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167     assert(b <= a);
168     return a - b;
169   }
170 
171   /**
172   * @dev Adds two numbers, throws on overflow.
173   */
174   function add(uint256 a, uint256 b) internal pure returns (uint256) {
175     uint256 c = a + b;
176     assert(c >= a);
177     return c;
178   }
179 }
180 
181 // File: contracts/MiningSupplier.sol
182 
183 // @title MiningSupplier
184 // @author Takayuki Jimba
185 contract MiningSupplier {
186     using SafeMath for uint256;
187 
188     uint256 public constant secondsPerYear = 1 years * 1 seconds;
189     uint256 public constant secondsPerDay = 1 days * 1 seconds;
190 
191     // @dev Number of blocks per year
192     function _getBlocksPerYear(
193         uint256 _secondsPerBlock
194     ) public pure returns(uint256) {
195         return secondsPerYear.div(_secondsPerBlock);
196     }
197 
198     // @dev 0-based block number index
199     //      First block number index of every years is 0
200     function _getBlockIndexAtYear(
201         uint256 _initialBlockNumber,
202         uint256 _currentBlockNumber,
203         uint256 _secondsPerBlock
204     ) public pure returns(uint256) {
205         //require(_currentBlockNumber >= _initialBlockNumber, "current is large than or equal to initial");
206         require(_currentBlockNumber >= _initialBlockNumber);
207         uint256 _blockIndex = _currentBlockNumber.sub(_initialBlockNumber);
208         uint256 _blocksPerYear = _getBlocksPerYear(_secondsPerBlock);
209         return _blockIndex.sub(_blockIndex.div(_blocksPerYear).mul(_blocksPerYear));
210     }
211 
212     // @dev Map block number to block index.
213     //      First block is number 0.
214     function _getBlockIndex(
215         uint256 _initialBlockNumber,
216         uint256 _currentBlockNumber
217     ) public pure returns(uint256) {
218         //require(_currentBlockNumber >= _initialBlockNumber, "current is large than or equal to initial");
219         require(_currentBlockNumber >= _initialBlockNumber);
220         return _currentBlockNumber.sub(_initialBlockNumber);
221     }
222 
223     // @dev Map block number to year index.
224     //      First (blocksPerYear - 1) blocks are number 0.
225     function _getYearIndex(
226         uint256 _secondsPerBlock,
227         uint256 _initialBlockNumber,
228         uint256 _currentBlockNumber
229     ) public pure returns(uint256) {
230         uint256 _blockIndex =  _getBlockIndex(_initialBlockNumber, _currentBlockNumber);
231         uint256 _blocksPerYear = _getBlocksPerYear(_secondsPerBlock);
232         return _blockIndex.div(_blocksPerYear);
233     }
234 
235     // @dev
236     function _getWaitingBlocks(
237         uint256 _secondsPerBlock
238     ) public pure returns(uint256) {
239         return secondsPerDay.div(_secondsPerBlock);
240     }
241 
242     function _getWeightUntil(
243         uint256 _totalWeight,
244         uint256 _yearIndex
245     ) public pure returns(uint256) {
246         uint256 _sum = 0;
247         for(uint256 i = 0; i < _yearIndex; i++) {
248             _sum = _sum.add(_totalWeight / (2 ** (i + 1)));
249         }
250         return _sum;
251     }
252 
253     function _estimateSupply(
254         uint256 _secondsPerBlock,
255         uint256 _initialBlockNumber,
256         uint256 _currentBlockNumber,
257         uint256 _totalWeight
258     ) public pure returns(uint256){
259         uint256 _yearIndex = _getYearIndex(_secondsPerBlock, _initialBlockNumber, _currentBlockNumber); // 0-based
260         uint256 _blockIndex = _getBlockIndexAtYear(_initialBlockNumber, _currentBlockNumber, _secondsPerBlock) + 1;
261         uint256 _numerator = _totalWeight.mul(_secondsPerBlock).mul(_blockIndex);
262         uint256 _yearFactor = 2 ** (_yearIndex + 1);
263         uint256 _denominator =  _yearFactor.mul(secondsPerYear);
264         uint256 _supply = _numerator.div(_denominator).add(_getWeightUntil(_totalWeight, _yearIndex));
265         return _supply; // mg
266     }
267 
268     function _estimateWeight(
269         uint256 _secondsPerBlock,
270         uint256 _initialBlockNumber,
271         uint256 _currentBlockNumber,
272         uint256 _totalWeight,
273         uint256 _currentWeight
274     ) public pure returns(uint256) {
275         uint256 _supply = _estimateSupply(
276             _secondsPerBlock,
277             _initialBlockNumber,
278             _currentBlockNumber,
279             _totalWeight
280         );
281         uint256 _yearIndex = _getYearIndex(
282             _secondsPerBlock,
283             _initialBlockNumber,
284             _currentBlockNumber
285         ); // 0-based
286         uint256 _yearFactor = 2 ** _yearIndex;
287         uint256 _defaultWeight = 10000; // mg
288 
289         if(_currentWeight > _supply) {
290             // (_supply / _currentWeight) * _defaultWeight / _yearFactor
291             return _supply.mul(_defaultWeight).div(_currentWeight).div(_yearFactor);
292         } else {
293             // _defaultWeight / _yearFactor
294             return _defaultWeight.div(_yearFactor);
295         }
296     }
297 
298     function _updateNeeded(
299         uint256 _secondsPerBlock,
300         uint256 _currentBlockNumber,
301         uint256 _blockNumberUpdated
302     ) public pure returns(bool) {
303         if (_blockNumberUpdated == 0) {
304             return true;
305         }
306         uint256 _waitingBlocks = _getWaitingBlocks(_secondsPerBlock);
307         return _currentBlockNumber >= _blockNumberUpdated + _waitingBlocks;
308     }
309 }
310 
311 // File: contracts/CrystalWeightManager.sol
312 
313 // @title CrystalWeightManager
314 // @author Takayuki Jimba
315 contract CrystalWeightManager is MiningSupplier {
316     // Amounts of deposit of all crystals.
317     // Each unit of weight is milligrams
318     // e.g. 50000000000 means 50t.
319     uint256[100] crystalWeights = [
320         50000000000,226800000000,1312500000000,31500000000,235830000000,
321         151200000000,655200000000,829500000000,7177734375,762300000000,
322         684600000000,676200000000,5037226562,30761718750,102539062500,
323         102539062500,102539062500,5126953125,31500000000,5040000000,
324         20507812500,20507812500,10253906250,5024414062,6300000000,
325         20507812500,102539062500,102539062500,102539062500,102539062500,
326         102539062500,7690429687,15380859375,69300000000,10253906250,
327         547050000000,15380859375,20507812500,15380859375,15380859375,
328         20507812500,15380859375,7690429687,153808593750,92285156250,
329         102539062500,71777343750,82031250000,256347656250,1384277343750,
330         820312500000,743408203125,461425781250,563964843750,538330078125,
331         358886718750,256347656250,358886718750,102539062500,307617187500,
332         256347656250,51269531250,41015625000,307617187500,307617187500,
333         2050781250,3588867187,2563476562,5126953125,399902343750,
334         615234375000,563964843750,461425781250,358886718750,717773437500,
335         41015625000,41015625000,2050781250,102539062500,102539062500,
336         51269531250,102539062500,30761718750,41015625000,102539062500,
337         102539062500,102539062500,205078125000,205078125000,556500000000,
338         657300000000,41015625000,102539062500,30761718750,102539062500,
339         20507812500,20507812500,20507812500,20507812500,82031250000
340     ];
341 
342     uint256 public secondsPerBlock = 12;
343     uint256 public initialBlockNumber = block.number;
344     uint256 public constant originalTotalWeight = 21 * 10**13; // mg
345     uint256 public currentWeight = 0;
346     uint256 public estimatedWeight = 0;
347     uint256 public blockNumberUpdated = 0;
348 
349     event UpdateEstimatedWeight(uint256 weight, uint256 nextUpdateBlockNumber);
350 
351     function setEstimatedWeight(uint256 _minedWeight) internal {
352         currentWeight = currentWeight.add(_minedWeight);
353 
354         uint256 _currentBlockNumber = block.number;
355 
356         bool _isUpdate = _updateNeeded(
357             secondsPerBlock,
358             _currentBlockNumber,
359             blockNumberUpdated
360         );
361 
362         if(_isUpdate) {
363             estimatedWeight = _estimateWeight(
364                 secondsPerBlock,
365                 initialBlockNumber,
366                 _currentBlockNumber,
367                 originalTotalWeight,
368                 currentWeight
369             );
370             blockNumberUpdated = _currentBlockNumber;
371 
372             emit UpdateEstimatedWeight(estimatedWeight, _currentBlockNumber);
373         }
374     }
375 
376     function getCrystalWeights() external view returns(uint256[100]) {
377         return crystalWeights;
378     }
379 }
380 
381 // File: contracts/EOACallable.sol
382 
383 // @title EOACallable
384 // @author Takayuki Jimba
385 contract EOACallable {
386     function isContract(address addr) internal view returns (bool) {
387         uint size;
388         assembly { size := extcodesize(addr) }
389         return size > 0;
390     }
391 
392     modifier onlyEOA {
393         require(!isContract(msg.sender));
394         _;
395     }
396 }
397 
398 // File: contracts/ExchangeBaseIF.sol
399 
400 // @title ExchangeBaseIF
401 // @author Takayuki Jimba
402 contract ExchangeBaseIF {
403     function create(
404         address _owner,
405         uint256 _ownerTokenId,
406         uint256 _ownerTokenGene,
407         uint256 _ownerTokenKind,
408         uint256 _ownerTokenWeight,
409         uint256 _kind,
410         uint256 _weight,
411         uint256 _createdAt
412     ) public returns(uint256);
413     function remove(uint256 _id) public;
414     function getExchange(uint256 _id) public view returns(
415         address owner,
416         uint256 tokenId,
417         uint256 kind,
418         uint256 weight,
419         uint256 createdAt
420     );
421     function getTokenId(uint256 _id) public view returns(uint256);
422     function ownerOf(uint256 _id) public view returns(address);
423     function isOnExchange(uint256 _tokenId) public view returns(bool);
424     function isOnExchangeById(uint256 _id) public view returns(bool);
425 }
426 
427 // File: contracts/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
428 
429 /**
430  * @title ERC20Basic
431  * @dev Simpler version of ERC20 interface
432  * @dev see https://github.com/ethereum/EIPs/issues/179
433  */
434 contract ERC20Basic {
435   function totalSupply() public view returns (uint256);
436   function balanceOf(address who) public view returns (uint256);
437   function transfer(address to, uint256 value) public returns (bool);
438   event Transfer(address indexed from, address indexed to, uint256 value);
439 }
440 
441 // File: contracts/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
442 
443 /**
444  * @title ERC20 interface
445  * @dev see https://github.com/ethereum/EIPs/issues/20
446  */
447 contract ERC20 is ERC20Basic {
448   function allowance(address owner, address spender) public view returns (uint256);
449   function transferFrom(address from, address to, uint256 value) public returns (bool);
450   function approve(address spender, uint256 value) public returns (bool);
451   event Approval(address indexed owner, address indexed spender, uint256 value);
452 }
453 
454 // File: contracts/PickaxeIF.sol
455 
456 // @title PickaxeIF
457 // @author Takayuki Jimba
458 contract PickaxeIF is ERC20 {
459     function transferFromOwner(address _to, uint256 _amount) public;
460     function burn(address _from, uint256 _amount) public;
461 }
462 
463 // File: contracts/RandomGeneratorIF.sol
464 
465 // @title RandomGeneratorIF
466 // @author Takayuki Jimba
467 contract RandomGeneratorIF {
468     function generate() public returns(uint64);
469 }
470 
471 // File: contracts/Sellable.sol
472 
473 // @title Sellable
474 // @author Takayuki Jimba
475 // @dev Sell tokens.
476 //      Token is supposed to be Pickaxe contract in our contracts.
477 //      Actual transferring tokens operation is to be implemented in inherited contract.
478 contract Sellable is Ownable {
479     using SafeMath for uint256;
480 
481     address public wallet;
482     uint256 public rate;
483 
484     address public donationWallet;
485     uint256 public donationRate;
486 
487     uint256 public constant MIN_WEI_AMOUNT = 5 * 10**15;
488 
489     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
490     event ForwardFunds(address sender, uint256 value, uint256 deposit);
491     event Donation(address sender, uint256 value);
492 
493     constructor(address _wallet, address _donationWallet, uint256 _donationRate) public {
494         // 1 token = 0.005 ETH
495         rate = 200;
496         wallet = _wallet;
497         donationWallet = _donationWallet;
498         donationRate = _donationRate;
499     }
500 
501     function setWallet(address _wallet) external onlyOwner {
502         wallet = _wallet;
503     }
504 
505     function setEthereumWallet(address _donationWallet) external onlyOwner {
506         donationWallet = _donationWallet;
507     }
508 
509     function () external payable {
510         require(msg.value >= MIN_WEI_AMOUNT);
511         buyPickaxes(msg.sender);
512     }
513 
514     function buyPickaxes(address _beneficiary) public payable {
515         require(msg.value >= MIN_WEI_AMOUNT);
516 
517         uint256 _weiAmount = msg.value;
518         uint256 _tokens = _weiAmount.mul(rate).div(1 ether);
519 
520         require(_tokens.mul(1 ether).div(rate) == _weiAmount);
521 
522         _transferFromOwner(msg.sender, _tokens);
523         emit TokenPurchase(msg.sender, _beneficiary, _weiAmount, _tokens);
524         _forwardFunds();
525     }
526 
527     function _transferFromOwner(address _to, uint256 _value) internal {
528         /* MUST override */
529     }
530 
531     function _forwardFunds() internal {
532         uint256 donation = msg.value.div(donationRate); // 2%
533         uint256 value = msg.value - donation;
534 
535         wallet.transfer(value);
536 
537         emit ForwardFunds(msg.sender, value, donation);
538 
539         uint256 donationEth = 2014000000000000000; // 2.014 ether
540         if(address(this).balance >= donationEth) {
541             donationWallet.transfer(donationEth);
542             emit Donation(msg.sender, donationEth);
543         }
544     }
545 }
546 
547 // File: contracts/CryptoCrystal.sol
548 
549 // @title CryptoCrystal
550 // @author Takayuki Jimba
551 // @dev Almost all application specific logic is in this contract.
552 //      CryptoCrystal acts as a facade to Pixaxe(ERC20), CrystalBase(ERC721), ExchangeBase as to transactions.
553 contract CryptoCrystal is Sellable, EOACallable, CrystalWeightManager {
554     PickaxeIF public pickaxe;
555     CrystalBaseIF public crystal;
556     ExchangeBaseIF public exchange;
557     RandomGeneratorIF public generator;
558 
559     //event RandomGenerated(uint256 number);
560 
561     event MineCrystals(
562         // miner of the crystal
563         address indexed owner,
564         // time of mining
565         uint256 indexed minedAt,
566         // tokenIds of mined crystals
567         uint256[] tokenIds,
568         // kinds of mined crystals
569         uint256[] kinds,
570         // weights of mined crystals
571         uint256[] weights,
572         // genes of mined crystals
573         uint256[] genes
574     );
575 
576     event MeltCrystals(
577         // melter of the crystals
578         address indexed owner,
579         // time of melting
580         uint256 indexed meltedAt,
581         // tokenIds of melted crystals
582         uint256[] meltedTokenIds,
583         // tokenId of newly generated crystal
584         uint256 tokenId,
585         // kind of newly generated crystal
586         uint256 kind,
587         // weight of newly generated crystal
588         uint256 weight,
589         // gene of newly generated crystal
590         uint256 gene
591     );
592 
593     event CreateExchange(
594         // id of exchange
595         uint256 indexed id,
596         // creator of the exchange
597         address owner,
598         // tokenId of exhibited crystal
599         uint256 ownerTokenId,
600         // gene of exhibited crystal
601         uint256 ownerTokenGene,
602         // kind of exhibited crystal
603         uint256 ownerTokenKind,
604         // weight of exhibited crystal
605         uint256 ownerTokenWeight,
606         // kind of condition for exchange
607         uint256 kind,
608         // weight of condition for exchange
609         uint256 weight,
610         // time of exchange creation
611         uint256 createdAt
612     );
613 
614     event CancelExchange(
615         // id of excahnge
616         uint256 indexed id,
617         // creator of the exchange
618         address owner,
619         // tokenId of exhibited crystal
620         uint256 ownerTokenId,
621         // kind of exhibited crystal
622         uint256 ownerTokenKind,
623         // weight of exhibited crystal
624         uint256 ownerTokenWeight,
625         // time of exchange cancelling
626         uint256 cancelledAt
627     );
628 
629     event BidExchange(
630         // id of exchange
631         uint256 indexed id,
632         // creator of the exchange
633         address owner,
634         // tokenId of exhibited crystal
635         uint256 ownerTokenId,
636         // gene of exhibited crystal
637         uint256 ownerTokenGene,
638         // kind of exhibited crystal
639         uint256 ownerTokenKind,
640         // weight of exhibited crystal
641         uint256 ownerTokenWeight,
642         // exchanger who bid to exchange
643         address exchanger,
644         // tokenId of crystal to exchange
645         uint256 exchangerTokenId,
646         // kind of crystal to exchange
647         uint256 exchangerTokenKind,
648         // weight of crystal to exchange (may not be the same to weight condition)
649         uint256 exchangerTokenWeight,
650         // time of bidding
651         uint256 bidAt
652     );
653 
654     struct ExchangeWrapper {
655         uint256 id;
656         address owner;
657         uint256 tokenId;
658         uint256 kind;
659         uint256 weight;
660         uint256 createdAt;
661     }
662 
663     struct CrystalWrapper {
664         address owner;
665         uint256 tokenId;
666         uint256 gene;
667         uint256 kind;
668         uint256 weight;
669     }
670 
671     constructor(
672         PickaxeIF _pickaxe,
673         CrystalBaseIF _crystal,
674         ExchangeBaseIF _exchange,
675         RandomGeneratorIF _generator,
676         address _wallet,
677         address _donationWallet,
678         uint256 _donationRate
679     ) Sellable(_wallet, _donationWallet, _donationRate) public {
680         pickaxe = _pickaxe;
681         crystal = _crystal;
682         exchange = _exchange;
683         generator = _generator;
684         setEstimatedWeight(0);
685     }
686 
687     // @dev mineCrystals consists of two basic operations that burn pickaxes and mint crystals.
688     // @param _pkxAmount uint256 the amount of tokens to be burned
689     function mineCrystals(uint256 _pkxAmount) external onlyEOA {
690         address _owner = msg.sender;
691         require(pickaxe.balanceOf(msg.sender) >= _pkxAmount);
692         require(0 < _pkxAmount && _pkxAmount <= 100);
693 
694         uint256 _crystalAmount = _getRandom(5);
695 
696         uint256[] memory _tokenIds = new uint256[](_crystalAmount);
697         uint256[] memory _kinds = new uint256[](_crystalAmount);
698         uint256[] memory _weights = new uint256[](_crystalAmount);
699         uint256[] memory _genes = new uint256[](_crystalAmount);
700 
701         uint256[] memory _crystalWeightsCumsum = new uint256[](100);
702         _crystalWeightsCumsum[0] = crystalWeights[0];
703         for(uint256 i = 1; i < 100; i++) {
704             _crystalWeightsCumsum[i] = _crystalWeightsCumsum[i - 1].add(crystalWeights[i]);
705         }
706         uint256 _totalWeight = _crystalWeightsCumsum[_crystalWeightsCumsum.length - 1];
707         uint256 _weightRandomSum = 0;
708         uint256 _weightSum = 0;
709 
710         for(i = 0; i < _crystalAmount; i++) {
711             _weights[i] = _getRandom(100);
712             _weightRandomSum = _weightRandomSum.add(_weights[i]);
713         }
714 
715         for(i = 0; i < _crystalAmount; i++) {
716             // Kind is decided randomly according to remaining crystal weights.
717             // That means crystals of large quantity are chosen with high probability.
718             _kinds[i] = _getFirstIndex(_getRandom(_totalWeight), _crystalWeightsCumsum);
719 
720             // Weight is decided randomly according to estimatedWeight.
721             // EstimatedWeight is fixed (calculated in advance) in one mining.
722             // EstimatedWeight is randomly divided into each of weight.
723             // That means sum of weights is equal to EstimatedWeight.
724             uint256 actualWeight = estimatedWeight.mul(_pkxAmount);
725             _weights[i] = _weights[i].mul(actualWeight).div(_weightRandomSum);
726 
727             // Gene is decided randomly.
728             _genes[i] = _generateGene();
729 
730             require(_weights[i] > 0);
731 
732             _tokenIds[i] = crystal.mint(_owner, _genes[i], _kinds[i], _weights[i]);
733 
734             crystalWeights[_kinds[i]] = crystalWeights[_kinds[i]].sub(_weights[i]);
735 
736             _weightSum = _weightSum.add(_weights[i]);
737         }
738 
739         setEstimatedWeight(_weightSum);
740         pickaxe.burn(msg.sender, _pkxAmount);
741 
742         emit MineCrystals(
743         _owner,
744         now,
745         _tokenIds,
746         _kinds,
747         _weights,
748         _genes
749         );
750     }
751 
752     // @dev meltCrystals consists of two basic operations.
753     //      It burns old crystals and mint new crystal.
754     //      The weight of new crystal is the same to total weight of bunred crystals.
755     // @notice meltCrystals may have bugs. We will fix later.
756     // @param uint256[] _tokenIds the token ids of crystals to be melt
757     function meltCrystals(uint256[] _tokenIds) external onlyEOA {
758         uint256 _length = _tokenIds.length;
759         address _owner = msg.sender;
760 
761         require(2 <= _length && _length <= 10);
762 
763         uint256[] memory _kinds = new uint256[](_length);
764         uint256 _weight;
765         uint256 _totalWeight = 0;
766 
767         for(uint256 i = 0; i < _length; i++) {
768             require(crystal.ownerOf(_tokenIds[i]) == _owner);
769             (_kinds[i], _weight) = crystal.getCrystalKindWeight(_tokenIds[i]);
770             if (i != 0) {
771                 require(_kinds[i] == _kinds[i - 1]);
772             }
773 
774             _totalWeight = _totalWeight.add(_weight);
775             crystal.burn(_owner, _tokenIds[i]);
776         }
777 
778         uint256 _gene = _generateGene();
779         uint256 _tokenId = crystal.mint(_owner, _gene, _kinds[0], _totalWeight);
780 
781         emit MeltCrystals(_owner, now, _tokenIds, _tokenId, _kinds[0], _totalWeight, _gene);
782     }
783 
784     // @dev create exchange
785     // @param uint256 _tokenId tokenId you want to exchange
786     // @param uint256 _kind crystal kind you want to get
787     // @param uint256 _weight minimum crystal weight you want to get
788     function createExchange(uint256 _tokenId, uint256 _kind, uint256 _weight) external onlyEOA {
789         ExchangeWrapper memory _ew = ExchangeWrapper({
790             id: 0, // specify after
791             owner: msg.sender,
792             tokenId: _tokenId,
793             kind: _kind,
794             weight: _weight,
795             createdAt: 0
796             });
797 
798         CrystalWrapper memory _cw = getCrystalWrapper(msg.sender, _tokenId);
799 
800         require(crystal.ownerOf(_tokenId) == _cw.owner);
801         require(_kind < 100);
802 
803         // escrow crystal to exchange contract
804         crystal._transferFrom(_cw.owner, exchange, _tokenId);
805 
806         _ew.id = exchange.create(_ew.owner, _tokenId, _cw.gene, _cw.kind, _cw.weight, _ew.kind, _ew.weight, now);
807 
808         emit CreateExchange(_ew.id, _ew.owner, _ew.tokenId, _cw.gene, _cw.kind, _cw.weight, _ew.kind, _ew.weight, now);
809     }
810 
811     function getCrystalWrapper(address _owner, uint256 _tokenId) internal returns(CrystalWrapper) {
812         CrystalWrapper memory _cw;
813         _cw.owner = _owner;
814         _cw.tokenId = _tokenId;
815         (_cw.gene, _cw.kind, _cw.weight) = crystal.getCrystalGeneKindWeight(_tokenId);
816         return _cw;
817     }
818 
819     // @dev cancel exchange
820     // @param uint256 _id exchangeId you want to cancel
821     function cancelExchange(uint256 _id) external onlyEOA {
822         require(exchange.ownerOf(_id) == msg.sender);
823 
824         uint256 _tokenId = exchange.getTokenId(_id);
825 
826         CrystalWrapper memory _cw = getCrystalWrapper(msg.sender, _tokenId);
827 
828         // withdraw crystal from exchange contract
829         crystal._transferFrom(exchange, _cw.owner, _cw.tokenId);
830 
831         exchange.remove(_id);
832 
833         emit CancelExchange(_id, _cw.owner, _cw.tokenId, _cw.kind, _cw.weight, now);
834     }
835 
836     // @dev bid exchange
837     // @param uint256 _exchangeId exchange id you want to bid
838     // @param uint256 _tokenId token id of your crystal to be exchanged
839     function bidExchange(uint256 _exchangeId, uint256 _tokenId) external onlyEOA {
840         // exchange
841         ExchangeWrapper memory _ew;
842         _ew.id = _exchangeId;
843         (_ew.owner, _ew.tokenId, _ew.kind, _ew.weight, _ew.createdAt) = exchange.getExchange(_ew.id); // check existence
844 
845         // crystal of exchanger
846         CrystalWrapper memory _cwe = getCrystalWrapper(msg.sender, _tokenId);
847 
848         // crystal of creator of exchange
849         CrystalWrapper memory _cwo = getCrystalWrapper(_ew.owner, _ew.tokenId);
850 
851         require(_cwe.owner != _ew.owner);
852         require(_cwe.kind == _ew.kind);
853         require(_cwe.weight >= _ew.weight);
854 
855         // transfer my crystal to owner of exchange
856         crystal._transferFrom(_cwe.owner, _ew.owner, _cwe.tokenId);
857 
858         // transfer escrowed crystal to me.
859         crystal._transferFrom(exchange, _cwe.owner, _ew.tokenId);
860 
861         exchange.remove(_ew.id);
862 
863         emit BidExchange(_ew.id, _ew.owner, _ew.tokenId, _cwo.gene, _cwo.kind, _cwo.weight, _cwe.owner, _cwe.tokenId, _cwe.kind, _cwe.weight, now);
864     }
865 
866     // @dev get index when cumsum[i] exceeds _in first.
867     // @param uint256 _min
868     // @param uint256[] _sorted array is required to be sorted by ascending order
869     function _getFirstIndex(uint256 _min, uint256[] _sorted) public pure returns(uint256) {
870         for(uint256 i = 0; i < _sorted.length; i++) {
871             if(_min < _sorted[i]) {
872                 return i;
873             }
874         }
875         return _sorted.length - 1;
876     }
877 
878     function _transferFromOwner(address _to, uint256 _value) internal {
879         pickaxe.transferFromOwner(_to, _value);
880     }
881 
882     function _generateGene() internal returns(uint256) {
883         return _getRandom(~uint256(0));
884     }
885 
886     function _getRandom(uint256 _max) public returns(uint256){
887         bytes32 hash = keccak256(generator.generate());
888         uint256 number = (uint256(hash) % _max) + 1;
889         //emit RandomGenerated(number);
890         return number;
891     }
892 
893     // @dev change random generator
894     // @param RandomGeneratorIF randomGenerator contract address
895     function setRandomGenerator(RandomGeneratorIF _generator) external onlyOwner {
896         generator = _generator;
897     }
898 }