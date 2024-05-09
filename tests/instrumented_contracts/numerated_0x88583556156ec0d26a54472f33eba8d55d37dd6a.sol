1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
77 
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @title SafeMath
82  * @dev Unsigned math operations with safety checks that revert on error
83  */
84 library SafeMath {
85     /**
86     * @dev Multiplies two unsigned integers, reverts on overflow.
87     */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
104     */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116     */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125     * @dev Adds two unsigned integers, reverts on overflow.
126     */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a);
130 
131         return c;
132     }
133 
134     /**
135     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
136     * reverts when dividing by zero.
137     */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         require(b != 0);
140         return a % b;
141     }
142 }
143 
144 // File: contracts/generators/ColourGenerator.sol
145 
146 pragma solidity ^0.5.0;
147 
148 
149 contract ColourGenerator is Ownable {
150 
151     uint256 internal randNonce = 0;
152 
153     event Colours(uint256 exteriorColorway, uint256 backgroundColorway);
154 
155     uint256 public exteriors = 20;
156     uint256 public backgrounds = 8;
157 
158     function generate(address _sender)
159     external
160     returns (
161         uint256 exteriorColorway,
162         uint256 backgroundColorway
163     ) {
164         bytes32 hash = blockhash(block.number);
165 
166         uint256 exteriorColorwayRandom = generate(hash, _sender, exteriors);
167         uint256 backgroundColorwayRandom = generate(hash, _sender, backgrounds);
168 
169         emit Colours(exteriorColorwayRandom, backgroundColorwayRandom);
170 
171         return (exteriorColorwayRandom, backgroundColorwayRandom);
172     }
173 
174     function generate(bytes32 _hash, address _sender, uint256 _max) internal returns (uint256) {
175         randNonce++;
176         bytes memory packed = abi.encodePacked(_hash, _sender, randNonce);
177         return uint256(keccak256(packed)) % _max;
178     }
179 
180     function updateExteriors(uint256 _exteriors) public onlyOwner {
181         exteriors = _exteriors;
182     }
183 
184     function updateBackgrounds(uint256 _backgrounds) public onlyOwner {
185         backgrounds = _backgrounds;
186     }
187 }
188 
189 // File: contracts/generators/LogicGenerator.sol
190 
191 pragma solidity ^0.5.0;
192 
193 
194 contract LogicGenerator is Ownable {
195 
196     uint256 internal randNonce = 0;
197 
198     event Generated(
199         uint256 city,
200         uint256 building,
201         uint256 base,
202         uint256 body,
203         uint256 roof,
204         uint256 special
205     );
206 
207     uint256[] public cityPercentages;
208 
209     mapping(uint256 => uint256[]) public cityMappings;
210 
211     mapping(uint256 => uint256[]) public buildingBaseMappings;
212     mapping(uint256 => uint256[]) public buildingBodyMappings;
213     mapping(uint256 => uint256[]) public buildingRoofMappings;
214 
215     uint256 public specialModulo = 7;
216     uint256 public specialNo = 11;
217 
218     function generate(address _sender)
219     external
220     returns (uint256 city, uint256 building, uint256 base, uint256 body, uint256 roof, uint256 special) {
221         bytes32 hash = blockhash(block.number);
222 
223         uint256 aCity = cityPercentages[generate(hash, _sender, cityPercentages.length)];
224 
225         uint256 aBuilding = cityMappings[aCity][generate(hash, _sender, cityMappings[aCity].length)];
226 
227         uint256 aBase = buildingBaseMappings[aBuilding][generate(hash, _sender, buildingBaseMappings[aBuilding].length)];
228         uint256 aBody = buildingBodyMappings[aBuilding][generate(hash, _sender, buildingBodyMappings[aBuilding].length)];
229         uint256 aRoof = buildingRoofMappings[aBuilding][generate(hash, _sender, buildingRoofMappings[aBuilding].length)];
230         uint256 aSpecial = 0;
231 
232         // 1 in X roughly
233         if (isSpecial(block.number)) {
234             aSpecial = generate(hash, _sender, specialNo);
235         }
236 
237         emit Generated(aCity, aBuilding, aBase, aBody, aRoof, aSpecial);
238 
239         return (aCity, aBuilding, aBase, aBody, aRoof, aSpecial);
240     }
241 
242     function generate(bytes32 _hash, address _sender, uint256 _max) internal returns (uint256) {
243         randNonce++;
244         bytes memory packed = abi.encodePacked(_hash, _sender, randNonce);
245         return uint256(keccak256(packed)) % _max;
246     }
247 
248     function isSpecial(uint256 _blocknumber) public view returns (bool) {
249         return (_blocknumber % specialModulo) == 0;
250     }
251 
252     function updateBuildingBaseMappings(uint256 _building, uint256[] memory _params) public onlyOwner {
253         buildingBaseMappings[_building] = _params;
254     }
255 
256     function updateBuildingBodyMappings(uint256 _building, uint256[] memory _params) public onlyOwner {
257         buildingBodyMappings[_building] = _params;
258     }
259 
260     function updateBuildingRoofMappings(uint256 _building, uint256[] memory _params) public onlyOwner {
261         buildingRoofMappings[_building] = _params;
262     }
263 
264     function updateSpecialModulo(uint256 _specialModulo) public onlyOwner {
265         specialModulo = _specialModulo;
266     }
267 
268     function updateSpecialNo(uint256 _specialNo) public onlyOwner {
269         specialNo = _specialNo;
270     }
271 
272     function updateCityPercentages(uint256[] memory _params) public onlyOwner {
273         cityPercentages = _params;
274     }
275 
276     function updateCityMappings(uint256 _cityIndex, uint256[] memory _params) public onlyOwner {
277         cityMappings[_cityIndex] = _params;
278     }
279 
280 }
281 
282 // File: contracts/FundsSplitter.sol
283 
284 pragma solidity ^0.5.0;
285 
286 
287 
288 contract FundsSplitter is Ownable {
289     using SafeMath for uint256;
290 
291     address payable public blockcities;
292     address payable public partner;
293 
294     uint256 public partnerRate = 15;
295 
296     constructor (address payable _blockcities, address payable _partner) public {
297         blockcities = _blockcities;
298         partner = _partner;
299     }
300 
301     function splitFunds(uint256 _totalPrice) internal {
302         if (msg.value > 0) {
303             uint256 refund = msg.value.sub(_totalPrice);
304 
305             // overpaid...
306             if (refund > 0) {
307                 msg.sender.transfer(refund);
308             }
309 
310             // work out the amount to split and send it
311             uint256 partnerAmount = _totalPrice.div(100).mul(partnerRate);
312             partner.transfer(partnerAmount);
313 
314             // send remaining amount to blockCities wallet
315             uint256 remaining = _totalPrice.sub(partnerAmount);
316             blockcities.transfer(remaining);
317         }
318     }
319 
320     function updatePartnerAddress(address payable _partner) onlyOwner public {
321         partner = _partner;
322     }
323 
324     function updatePartnerRate(uint256 _techPartnerRate) onlyOwner public {
325         partnerRate = _techPartnerRate;
326     }
327 
328     function updateBlockcitiesAddress(address payable _blockcities) onlyOwner public {
329         blockcities = _blockcities;
330     }
331 }
332 
333 // File: contracts/libs/Strings.sol
334 
335 pragma solidity ^0.5.0;
336 
337 library Strings {
338 
339     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
340     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
341         bytes memory _ba = bytes(_a);
342         bytes memory _bb = bytes(_b);
343         bytes memory _bc = bytes(_c);
344         bytes memory _bd = bytes(_d);
345         bytes memory _be = bytes(_e);
346         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
347         bytes memory babcde = bytes(abcde);
348         uint k = 0;
349         uint i = 0;
350         for (i = 0; i < _ba.length; i++) {
351             babcde[k++] = _ba[i];
352         }
353         for (i = 0; i < _bb.length; i++) {
354             babcde[k++] = _bb[i];
355         }
356         for (i = 0; i < _bc.length; i++) {
357             babcde[k++] = _bc[i];
358         }
359         for (i = 0; i < _bd.length; i++) {
360             babcde[k++] = _bd[i];
361         }
362         for (i = 0; i < _be.length; i++) {
363             babcde[k++] = _be[i];
364         }
365         return string(babcde);
366     }
367 
368     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
369         return strConcat(_a, _b, "", "", "");
370     }
371 
372     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
373         return strConcat(_a, _b, _c, "", "");
374     }
375 
376     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
377         if (_i == 0) {
378             return "0";
379         }
380         uint j = _i;
381         uint len;
382         while (j != 0) {
383             len++;
384             j /= 10;
385         }
386         bytes memory bstr = new bytes(len);
387         uint k = len - 1;
388         while (_i != 0) {
389             bstr[k--] = byte(uint8(48 + _i % 10));
390             _i /= 10;
391         }
392         return string(bstr);
393     }
394 }
395 
396 // File: contracts/IBlockCitiesCreator.sol
397 
398 pragma solidity ^0.5.0;
399 
400 interface IBlockCitiesCreator {
401     function createBuilding(
402         uint256 _exteriorColorway,
403         uint256 _backgroundColorway,
404         uint256 _city,
405         uint256 _building,
406         uint256 _base,
407         uint256 _body,
408         uint256 _roof,
409         uint256 _special,
410         address _architect
411     ) external returns (uint256 _tokenId);
412 }
413 
414 // File: contracts/BlockCitiesVendingMachine.sol
415 
416 pragma solidity ^0.5.0;
417 
418 
419 
420 
421 
422 
423 
424 
425 contract BlockCitiesVendingMachine is Ownable, FundsSplitter {
426     using SafeMath for uint256;
427 
428     event VendingMachineTriggered(
429         uint256 indexed _tokenId,
430         address indexed _architect
431     );
432 
433     event CreditAdded(address indexed _to, uint256 _amount);
434 
435     event PriceDiscountBandsChanged(uint256[2] _priceDiscountBands);
436 
437     event PriceStepInWeiChanged(
438         uint256 _oldPriceStepInWei,
439         uint256 _newPriceStepInWei
440     );
441 
442     event PricePerBuildingInWeiChanged(
443         uint256 _oldPricePerBuildingInWei,
444         uint256 _newPricePerBuildingInWei
445     );
446 
447     event FloorPricePerBuildingInWeiChanged(
448         uint256 _oldFloorPricePerBuildingInWei,
449         uint256 _newFloorPricePerBuildingInWei
450     );
451 
452     event CeilingPricePerBuildingInWeiChanged(
453         uint256 _oldCeilingPricePerBuildingInWei,
454         uint256 _newCeilingPricePerBuildingInWei
455     );
456 
457     event BlockStepChanged(
458         uint256 _oldBlockStep,
459         uint256 _newBlockStep
460     );
461 
462     event LastSaleBlockChanged(
463         uint256 _oldLastSaleBlock,
464         uint256 _newLastSaleBlock
465     );
466 
467     struct Colour {
468         uint256 exteriorColorway;
469         uint256 backgroundColorway;
470     }
471 
472     struct Building {
473         uint256 city;
474         uint256 building;
475         uint256 base;
476         uint256 body;
477         uint256 roof;
478         uint256 special;
479     }
480 
481     LogicGenerator public logicGenerator;
482 
483     ColourGenerator public colourGenerator;
484 
485     IBlockCitiesCreator public blockCities;
486 
487     mapping(address => uint256) public credits;
488 
489     uint256 public totalPurchasesInWei = 0;
490     uint256[2] public priceDiscountBands = [80, 70];
491 
492     uint256 public floorPricePerBuildingInWei = 0.05 ether;
493 
494     uint256 public ceilingPricePerBuildingInWei = 0.15 ether;
495 
496     // use totalPrice() to calculate current weighted price
497     uint256 pricePerBuildingInWei = 0.075 ether;
498 
499     uint256 public priceStepInWei = 0.0003 ether;
500 
501     // 120 is approx 30 mins
502     uint256 public blockStep = 120;
503 
504     uint256 public lastSaleBlock = 0;
505     uint256 public lastSalePrice = 0;
506 
507     constructor (
508         LogicGenerator _logicGenerator,
509         ColourGenerator _colourGenerator,
510         IBlockCitiesCreator _blockCities,
511         address payable _blockCitiesAddress,
512         address payable _partnerAddress
513     ) public FundsSplitter(_blockCitiesAddress, _partnerAddress) {
514         logicGenerator = _logicGenerator;
515         colourGenerator = _colourGenerator;
516         blockCities = _blockCities;
517     }
518 
519     function mintBuilding() public payable returns (uint256 _tokenId) {
520         uint256 currentPrice = totalPrice(1);
521         require(
522             credits[msg.sender] > 0 || msg.value >= currentPrice,
523             "Must supply at least the required minimum purchase value or have credit"
524         );
525 
526         _adjustCredits(currentPrice, 1);
527 
528         uint256 tokenId = _generate(msg.sender);
529 
530         _stepIncrease();
531 
532         return tokenId;
533     }
534 
535     function mintBuildingTo(address _to) public payable returns (uint256 _tokenId) {
536         uint256 currentPrice = totalPrice(1);
537         require(
538             credits[msg.sender] > 0 || msg.value >= currentPrice,
539             "Must supply at least the required minimum purchase value or have credit"
540         );
541 
542         _adjustCredits(currentPrice, 1);
543 
544         uint256 tokenId = _generate(_to);
545 
546         _stepIncrease();
547 
548         return tokenId;
549     }
550 
551     function mintBatch(uint256 _numberOfBuildings) public payable returns (uint256[] memory _tokenIds) {
552         uint256 currentPrice = totalPrice(_numberOfBuildings);
553         require(
554             credits[msg.sender] >= _numberOfBuildings || msg.value >= currentPrice,
555             "Must supply at least the required minimum purchase value or have credit"
556         );
557 
558         _adjustCredits(currentPrice, _numberOfBuildings);
559 
560         uint256[] memory generatedTokenIds = new uint256[](_numberOfBuildings);
561 
562         for (uint i = 0; i < _numberOfBuildings; i++) {
563             generatedTokenIds[i] = _generate(msg.sender);
564         }
565 
566         _stepIncrease();
567 
568         return generatedTokenIds;
569     }
570 
571     function mintBatchTo(address _to, uint256 _numberOfBuildings) public payable returns (uint256[] memory _tokenIds) {
572         uint256 currentPrice = totalPrice(_numberOfBuildings);
573         require(
574             credits[msg.sender] >= _numberOfBuildings || msg.value >= currentPrice,
575             "Must supply at least the required minimum purchase value or have credit"
576         );
577 
578         _adjustCredits(currentPrice, _numberOfBuildings);
579 
580         uint256[] memory generatedTokenIds = new uint256[](_numberOfBuildings);
581 
582         for (uint i = 0; i < _numberOfBuildings; i++) {
583             generatedTokenIds[i] = _generate(_to);
584         }
585 
586         _stepIncrease();
587 
588         return generatedTokenIds;
589     }
590 
591     function _generate(address _to) internal returns (uint256 _tokenId) {
592         Building memory building = _generateBuilding();
593         Colour memory colour = _generateColours();
594 
595         uint256 tokenId = blockCities.createBuilding(
596             colour.exteriorColorway,
597             colour.backgroundColorway,
598             building.city,
599             building.building,
600             building.base,
601             building.body,
602             building.roof,
603             building.special,
604             _to
605         );
606 
607         emit VendingMachineTriggered(tokenId, _to);
608 
609         return tokenId;
610     }
611 
612     function _generateColours() internal returns (Colour memory){
613         (uint256 _exteriorColorway, uint256 _backgroundColorway) = colourGenerator.generate(msg.sender);
614 
615         return Colour({
616             exteriorColorway : _exteriorColorway,
617             backgroundColorway : _backgroundColorway
618             });
619     }
620 
621     function _generateBuilding() internal returns (Building memory){
622         (uint256 _city, uint256 _building, uint256 _base, uint256 _body, uint256 _roof, uint256 _special) = logicGenerator.generate(msg.sender);
623 
624         return Building({
625             city : _city,
626             building : _building,
627             base : _base,
628             body : _body,
629             roof : _roof,
630             special : _special
631             });
632     }
633 
634     function _adjustCredits(uint256 _currentPrice, uint256 _numberOfBuildings) internal {
635         // use credits first
636         if (credits[msg.sender] >= _numberOfBuildings) {
637             credits[msg.sender] = credits[msg.sender].sub(_numberOfBuildings);
638 
639             // refund msg.value when using up credits
640             if (msg.value > 0) {
641                 msg.sender.transfer(msg.value);
642             }
643         } else {
644             splitFunds(_currentPrice);
645             totalPurchasesInWei = totalPurchasesInWei.add(_currentPrice);
646         }
647     }
648 
649     function _stepIncrease() internal {
650         lastSalePrice = pricePerBuildingInWei;
651         lastSaleBlock = block.number;
652 
653         pricePerBuildingInWei = pricePerBuildingInWei.add(priceStepInWei);
654 
655         if (pricePerBuildingInWei >= ceilingPricePerBuildingInWei) {
656             pricePerBuildingInWei = ceilingPricePerBuildingInWei;
657         }
658     }
659 
660     function totalPrice(uint256 _numberOfBuildings) public view returns (uint256) {
661 
662         uint256 calculatedPrice = pricePerBuildingInWei;
663 
664         uint256 blocksPassed = block.number - lastSaleBlock;
665         uint256 reduce = blocksPassed.div(blockStep).mul(priceStepInWei);
666 
667         if (reduce > calculatedPrice) {
668             calculatedPrice = floorPricePerBuildingInWei;
669         }
670         else {
671             calculatedPrice = calculatedPrice.sub(reduce);
672         }
673 
674         if (calculatedPrice < floorPricePerBuildingInWei) {
675             calculatedPrice = floorPricePerBuildingInWei;
676         }
677 
678         if (_numberOfBuildings < 5) {
679             return _numberOfBuildings.mul(calculatedPrice);
680         }
681         else if (_numberOfBuildings < 10) {
682             return _numberOfBuildings.mul(calculatedPrice).div(100).mul(priceDiscountBands[0]);
683         }
684 
685         return _numberOfBuildings.mul(calculatedPrice).div(100).mul(priceDiscountBands[1]);
686     }
687 
688     function setPricePerBuildingInWei(uint256 _pricePerBuildingInWei) public onlyOwner returns (bool) {
689         emit PricePerBuildingInWeiChanged(pricePerBuildingInWei, _pricePerBuildingInWei);
690         pricePerBuildingInWei = _pricePerBuildingInWei;
691         return true;
692     }
693 
694     function setPriceStepInWei(uint256 _priceStepInWei) public onlyOwner returns (bool) {
695         emit PriceStepInWeiChanged(priceStepInWei, _priceStepInWei);
696         priceStepInWei = _priceStepInWei;
697         return true;
698     }
699 
700     function setPriceDiscountBands(uint256[2] memory _newPriceDiscountBands) public onlyOwner returns (bool) {
701         priceDiscountBands = _newPriceDiscountBands;
702 
703         emit PriceDiscountBandsChanged(_newPriceDiscountBands);
704 
705         return true;
706     }
707 
708     function addCredit(address _to) public onlyOwner returns (bool) {
709         credits[_to] = credits[_to].add(1);
710 
711         emit CreditAdded(_to, 1);
712 
713         return true;
714     }
715 
716     function addCreditAmount(address _to, uint256 _amount) public onlyOwner returns (bool) {
717         credits[_to] = credits[_to].add(_amount);
718 
719         emit CreditAdded(_to, _amount);
720 
721         return true;
722     }
723 
724     function addCreditBatch(address[] memory _addresses, uint256 _amount) public onlyOwner returns (bool) {
725         for (uint i = 0; i < _addresses.length; i++) {
726             addCreditAmount(_addresses[i], _amount);
727         }
728 
729         return true;
730     }
731 
732     function setFloorPricePerBuildingInWei(uint256 _floorPricePerBuildingInWei) public onlyOwner returns (bool) {
733         emit FloorPricePerBuildingInWeiChanged(floorPricePerBuildingInWei, _floorPricePerBuildingInWei);
734         floorPricePerBuildingInWei = _floorPricePerBuildingInWei;
735         return true;
736     }
737 
738     function setCeilingPricePerBuildingInWei(uint256 _ceilingPricePerBuildingInWei) public onlyOwner returns (bool) {
739         emit CeilingPricePerBuildingInWeiChanged(ceilingPricePerBuildingInWei, _ceilingPricePerBuildingInWei);
740         ceilingPricePerBuildingInWei = _ceilingPricePerBuildingInWei;
741         return true;
742     }
743 
744     function setBlockStep(uint256 _blockStep) public onlyOwner returns (bool) {
745         emit BlockStepChanged(blockStep, _blockStep);
746         blockStep = _blockStep;
747         return true;
748     }
749 
750     function setLastSaleBlock(uint256 _lastSaleBlock) public onlyOwner returns (bool) {
751         emit LastSaleBlockChanged(lastSaleBlock, _lastSaleBlock);
752         lastSaleBlock = _lastSaleBlock;
753         return true;
754     }
755 
756     function setLogicGenerator(LogicGenerator _logicGenerator) public onlyOwner returns (bool) {
757         logicGenerator = _logicGenerator;
758         return true;
759     }
760 
761     function setColourGenerator(ColourGenerator _colourGenerator) public onlyOwner returns (bool) {
762         colourGenerator = _colourGenerator;
763         return true;
764     }
765 }