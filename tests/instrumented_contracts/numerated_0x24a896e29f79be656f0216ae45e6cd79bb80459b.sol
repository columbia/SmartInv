1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/generators/IColourGenerator.sol
70 
71 pragma solidity ^0.5.0;
72 
73 interface IColourGenerator {
74     function generate(address _sender)
75     external
76     returns (uint256 exteriorColorway, uint256 backgroundColorway);
77 }
78 
79 // File: contracts/generators/ILogicGenerator.sol
80 
81 pragma solidity ^0.5.0;
82 
83 interface ILogicGenerator {
84     function generate(address _sender)
85     external
86     returns (uint256 city, uint256 building, uint256 base, uint256 body, uint256 roof, uint256 special);
87 }
88 
89 // File: openzeppelin-solidity/contracts/access/Roles.sol
90 
91 pragma solidity ^0.5.0;
92 
93 /**
94  * @title Roles
95  * @dev Library for managing addresses assigned to a Role.
96  */
97 library Roles {
98     struct Role {
99         mapping (address => bool) bearer;
100     }
101 
102     /**
103      * @dev give an account access to this role
104      */
105     function add(Role storage role, address account) internal {
106         require(account != address(0));
107         require(!has(role, account));
108 
109         role.bearer[account] = true;
110     }
111 
112     /**
113      * @dev remove an account's access to this role
114      */
115     function remove(Role storage role, address account) internal {
116         require(account != address(0));
117         require(has(role, account));
118 
119         role.bearer[account] = false;
120     }
121 
122     /**
123      * @dev check if an account has this role
124      * @return bool
125      */
126     function has(Role storage role, address account) internal view returns (bool) {
127         require(account != address(0));
128         return role.bearer[account];
129     }
130 }
131 
132 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
133 
134 pragma solidity ^0.5.0;
135 
136 
137 /**
138  * @title WhitelistAdminRole
139  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
140  */
141 contract WhitelistAdminRole {
142     using Roles for Roles.Role;
143 
144     event WhitelistAdminAdded(address indexed account);
145     event WhitelistAdminRemoved(address indexed account);
146 
147     Roles.Role private _whitelistAdmins;
148 
149     constructor () internal {
150         _addWhitelistAdmin(msg.sender);
151     }
152 
153     modifier onlyWhitelistAdmin() {
154         require(isWhitelistAdmin(msg.sender));
155         _;
156     }
157 
158     function isWhitelistAdmin(address account) public view returns (bool) {
159         return _whitelistAdmins.has(account);
160     }
161 
162     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
163         _addWhitelistAdmin(account);
164     }
165 
166     function renounceWhitelistAdmin() public {
167         _removeWhitelistAdmin(msg.sender);
168     }
169 
170     function _addWhitelistAdmin(address account) internal {
171         _whitelistAdmins.add(account);
172         emit WhitelistAdminAdded(account);
173     }
174 
175     function _removeWhitelistAdmin(address account) internal {
176         _whitelistAdmins.remove(account);
177         emit WhitelistAdminRemoved(account);
178     }
179 }
180 
181 // File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
182 
183 pragma solidity ^0.5.0;
184 
185 
186 
187 /**
188  * @title WhitelistedRole
189  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
190  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
191  * it), and not Whitelisteds themselves.
192  */
193 contract WhitelistedRole is WhitelistAdminRole {
194     using Roles for Roles.Role;
195 
196     event WhitelistedAdded(address indexed account);
197     event WhitelistedRemoved(address indexed account);
198 
199     Roles.Role private _whitelisteds;
200 
201     modifier onlyWhitelisted() {
202         require(isWhitelisted(msg.sender));
203         _;
204     }
205 
206     function isWhitelisted(address account) public view returns (bool) {
207         return _whitelisteds.has(account);
208     }
209 
210     function addWhitelisted(address account) public onlyWhitelistAdmin {
211         _addWhitelisted(account);
212     }
213 
214     function removeWhitelisted(address account) public onlyWhitelistAdmin {
215         _removeWhitelisted(account);
216     }
217 
218     function renounceWhitelisted() public {
219         _removeWhitelisted(msg.sender);
220     }
221 
222     function _addWhitelisted(address account) internal {
223         _whitelisteds.add(account);
224         emit WhitelistedAdded(account);
225     }
226 
227     function _removeWhitelisted(address account) internal {
228         _whitelisteds.remove(account);
229         emit WhitelistedRemoved(account);
230     }
231 }
232 
233 // File: contracts/FundsSplitterV2.sol
234 
235 pragma solidity ^0.5.0;
236 
237 
238 
239 contract FundsSplitterV2 is WhitelistedRole {
240     using SafeMath for uint256;
241 
242     address payable public platform;
243     address payable public partner;
244 
245     uint256 public partnerRate = 15;
246 
247     constructor (address payable _platform, address payable _partner) public {
248         platform = _platform;
249         partner = _partner;
250     }
251 
252     function splitFunds(uint256 _totalPrice) internal {
253         if (msg.value > 0) {
254             uint256 refund = msg.value.sub(_totalPrice);
255 
256             // overpaid...
257             if (refund > 0) {
258                 msg.sender.transfer(refund);
259             }
260 
261             // work out the amount to split and send it
262             uint256 partnerAmount = _totalPrice.div(100).mul(partnerRate);
263             partner.transfer(partnerAmount);
264 
265             // send remaining amount to blockCities wallet
266             uint256 remaining = _totalPrice.sub(partnerAmount);
267             platform.transfer(remaining);
268         }
269     }
270 
271     function updatePartnerAddress(address payable _partner) onlyWhitelisted public {
272         partner = _partner;
273     }
274 
275     function updatePartnerRate(uint256 _techPartnerRate) onlyWhitelisted public {
276         partnerRate = _techPartnerRate;
277     }
278 
279     function updatePlatformAddress(address payable _platform) onlyWhitelisted public {
280         platform = _platform;
281     }
282 }
283 
284 // File: contracts/libs/Strings.sol
285 
286 pragma solidity ^0.5.0;
287 
288 library Strings {
289 
290     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
291     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
292         bytes memory _ba = bytes(_a);
293         bytes memory _bb = bytes(_b);
294         bytes memory _bc = bytes(_c);
295         bytes memory _bd = bytes(_d);
296         bytes memory _be = bytes(_e);
297         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
298         bytes memory babcde = bytes(abcde);
299         uint k = 0;
300         uint i = 0;
301         for (i = 0; i < _ba.length; i++) {
302             babcde[k++] = _ba[i];
303         }
304         for (i = 0; i < _bb.length; i++) {
305             babcde[k++] = _bb[i];
306         }
307         for (i = 0; i < _bc.length; i++) {
308             babcde[k++] = _bc[i];
309         }
310         for (i = 0; i < _bd.length; i++) {
311             babcde[k++] = _bd[i];
312         }
313         for (i = 0; i < _be.length; i++) {
314             babcde[k++] = _be[i];
315         }
316         return string(babcde);
317     }
318 
319     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
320         return strConcat(_a, _b, "", "", "");
321     }
322 
323     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
324         return strConcat(_a, _b, _c, "", "");
325     }
326 
327     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
328         if (_i == 0) {
329             return "0";
330         }
331         uint j = _i;
332         uint len;
333         while (j != 0) {
334             len++;
335             j /= 10;
336         }
337         bytes memory bstr = new bytes(len);
338         uint k = len - 1;
339         while (_i != 0) {
340             bstr[k--] = byte(uint8(48 + _i % 10));
341             _i /= 10;
342         }
343         return string(bstr);
344     }
345 }
346 
347 // File: contracts/IBlockCitiesCreator.sol
348 
349 pragma solidity ^0.5.0;
350 
351 interface IBlockCitiesCreator {
352     function createBuilding(
353         uint256 _exteriorColorway,
354         uint256 _backgroundColorway,
355         uint256 _city,
356         uint256 _building,
357         uint256 _base,
358         uint256 _body,
359         uint256 _roof,
360         uint256 _special,
361         address _architect
362     ) external returns (uint256 _tokenId);
363 }
364 
365 // File: contracts/BlockCitiesVendingMachineV2.sol
366 
367 pragma solidity ^0.5.0;
368 
369 
370 
371 
372 
373 
374 
375 contract BlockCitiesVendingMachineV2 is FundsSplitterV2 {
376     using SafeMath for uint256;
377 
378     event VendingMachineTriggered(
379         uint256 indexed _tokenId,
380         address indexed _architect
381     );
382 
383     event CreditAdded(address indexed _to, uint256 _amount);
384 
385     event PriceDiscountBandsChanged(uint256[2] _priceDiscountBands);
386 
387     event PriceStepInWeiChanged(
388         uint256 _oldPriceStepInWei,
389         uint256 _newPriceStepInWei
390     );
391 
392     event FloorPricePerBuildingInWeiChanged(
393         uint256 _oldFloorPricePerBuildingInWei,
394         uint256 _newFloorPricePerBuildingInWei
395     );
396 
397     event CeilingPricePerBuildingInWeiChanged(
398         uint256 _oldCeilingPricePerBuildingInWei,
399         uint256 _newCeilingPricePerBuildingInWei
400     );
401 
402     event BlockStepChanged(
403         uint256 _oldBlockStep,
404         uint256 _newBlockStep
405     );
406 
407     event LastSaleBlockChanged(
408         uint256 _oldLastSaleBlock,
409         uint256 _newLastSaleBlock
410     );
411 
412     event LastSalePriceChanged(
413         uint256 _oldLastSalePrice,
414         uint256 _newLastSalePrice
415     );
416 
417     struct Colour {
418         uint256 exteriorColorway;
419         uint256 backgroundColorway;
420     }
421 
422     struct Building {
423         uint256 city;
424         uint256 building;
425         uint256 base;
426         uint256 body;
427         uint256 roof;
428         uint256 special;
429     }
430 
431     ILogicGenerator public logicGenerator;
432 
433     IColourGenerator public colourGenerator;
434 
435     IBlockCitiesCreator public blockCities;
436 
437     mapping(address => uint256) public credits;
438 
439     uint256 public totalPurchasesInWei = 0;
440     uint256[2] public priceDiscountBands = [80, 70];
441 
442     uint256 public floorPricePerBuildingInWei = 0.05 ether;
443 
444     uint256 public ceilingPricePerBuildingInWei = 0.15 ether;
445 
446     uint256 public priceStepInWei = 0.0003 ether;
447 
448     uint256 public blockStep = 10;
449 
450     uint256 public lastSaleBlock = 0;
451     uint256 public lastSalePrice = 0.075 ether;
452 
453     constructor (
454         ILogicGenerator _logicGenerator,
455         IColourGenerator _colourGenerator,
456         IBlockCitiesCreator _blockCities,
457         address payable _platform,
458         address payable _partnerAddress
459     ) public FundsSplitterV2(_platform, _partnerAddress) {
460         logicGenerator = _logicGenerator;
461         colourGenerator = _colourGenerator;
462         blockCities = _blockCities;
463 
464         lastSaleBlock = block.number;
465 
466         super.addWhitelisted(msg.sender);
467     }
468 
469     function mintBuilding() public payable returns (uint256 _tokenId) {
470         uint256 currentPrice = totalPrice(1);
471         require(
472             credits[msg.sender] > 0 || msg.value >= currentPrice,
473             "Must supply at least the required minimum purchase value or have credit"
474         );
475 
476         _reconcileCreditsAndFunds(currentPrice, 1);
477 
478         uint256 tokenId = _generate(msg.sender);
479 
480         _stepIncrease();
481 
482         return tokenId;
483     }
484 
485     function mintBuildingTo(address _to) public payable returns (uint256 _tokenId) {
486         uint256 currentPrice = totalPrice(1);
487         require(
488             credits[msg.sender] > 0 || msg.value >= currentPrice,
489             "Must supply at least the required minimum purchase value or have credit"
490         );
491 
492         _reconcileCreditsAndFunds(currentPrice, 1);
493 
494         uint256 tokenId = _generate(_to);
495 
496         _stepIncrease();
497 
498         return tokenId;
499     }
500 
501     function mintBatch(uint256 _numberOfBuildings) public payable returns (uint256[] memory _tokenIds) {
502         uint256 currentPrice = totalPrice(_numberOfBuildings);
503         require(
504             credits[msg.sender] >= _numberOfBuildings || msg.value >= currentPrice,
505             "Must supply at least the required minimum purchase value or have credit"
506         );
507 
508         _reconcileCreditsAndFunds(currentPrice, _numberOfBuildings);
509 
510         uint256[] memory generatedTokenIds = new uint256[](_numberOfBuildings);
511 
512         for (uint i = 0; i < _numberOfBuildings; i++) {
513             generatedTokenIds[i] = _generate(msg.sender);
514         }
515 
516         _stepIncrease();
517 
518         return generatedTokenIds;
519     }
520 
521     function mintBatchTo(address _to, uint256 _numberOfBuildings) public payable returns (uint256[] memory _tokenIds) {
522         uint256 currentPrice = totalPrice(_numberOfBuildings);
523         require(
524             credits[msg.sender] >= _numberOfBuildings || msg.value >= currentPrice,
525             "Must supply at least the required minimum purchase value or have credit"
526         );
527 
528         _reconcileCreditsAndFunds(currentPrice, _numberOfBuildings);
529 
530         uint256[] memory generatedTokenIds = new uint256[](_numberOfBuildings);
531 
532         for (uint i = 0; i < _numberOfBuildings; i++) {
533             generatedTokenIds[i] = _generate(_to);
534         }
535 
536         _stepIncrease();
537 
538         return generatedTokenIds;
539     }
540 
541     function _generate(address _to) internal returns (uint256 _tokenId) {
542         Building memory building = _generateBuilding();
543         Colour memory colour = _generateColours();
544 
545         uint256 tokenId = blockCities.createBuilding(
546             colour.exteriorColorway,
547             colour.backgroundColorway,
548             building.city,
549             building.building,
550             building.base,
551             building.body,
552             building.roof,
553             building.special,
554             _to
555         );
556 
557         emit VendingMachineTriggered(tokenId, _to);
558 
559         return tokenId;
560     }
561 
562     function _generateColours() internal returns (Colour memory){
563         (uint256 _exteriorColorway, uint256 _backgroundColorway) = colourGenerator.generate(msg.sender);
564 
565         return Colour({
566             exteriorColorway : _exteriorColorway,
567             backgroundColorway : _backgroundColorway
568             });
569     }
570 
571     function _generateBuilding() internal returns (Building memory){
572         (uint256 _city, uint256 _building, uint256 _base, uint256 _body, uint256 _roof, uint256 _special) = logicGenerator.generate(msg.sender);
573 
574         return Building({
575             city : _city,
576             building : _building,
577             base : _base,
578             body : _body,
579             roof : _roof,
580             special : _special
581             });
582     }
583 
584     function _reconcileCreditsAndFunds(uint256 _currentPrice, uint256 _numberOfBuildings) internal {
585         // use credits first
586         if (credits[msg.sender] >= _numberOfBuildings) {
587             credits[msg.sender] = credits[msg.sender].sub(_numberOfBuildings);
588 
589             // refund msg.value when using up credits
590             if (msg.value > 0) {
591                 msg.sender.transfer(msg.value);
592             }
593         } else {
594             splitFunds(_currentPrice);
595             totalPurchasesInWei = totalPurchasesInWei.add(_currentPrice);
596         }
597     }
598 
599     function _stepIncrease() internal {
600 
601         lastSalePrice = totalPrice(1).add(priceStepInWei);
602         lastSaleBlock = block.number;
603 
604         if (lastSalePrice >= ceilingPricePerBuildingInWei) {
605             lastSalePrice = ceilingPricePerBuildingInWei;
606         }
607     }
608 
609     function totalPrice(uint256 _numberOfBuildings) public view returns (uint256) {
610 
611         uint256 calculatedPrice = lastSalePrice;
612 
613         uint256 blocksPassed = block.number - lastSaleBlock;
614         uint256 reduce = blocksPassed.div(blockStep).mul(priceStepInWei);
615 
616         if (reduce > calculatedPrice) {
617             calculatedPrice = floorPricePerBuildingInWei;
618         }
619         else {
620             calculatedPrice = calculatedPrice.sub(reduce);
621 
622             if (calculatedPrice < floorPricePerBuildingInWei) {
623                 calculatedPrice = floorPricePerBuildingInWei;
624             }
625         }
626 
627         if (_numberOfBuildings < 5) {
628             return _numberOfBuildings.mul(calculatedPrice);
629         }
630         else if (_numberOfBuildings < 10) {
631             return _numberOfBuildings.mul(calculatedPrice).div(100).mul(priceDiscountBands[0]);
632         }
633 
634         return _numberOfBuildings.mul(calculatedPrice).div(100).mul(priceDiscountBands[1]);
635     }
636 
637     function setPriceStepInWei(uint256 _priceStepInWei) public onlyWhitelisted returns (bool) {
638         emit PriceStepInWeiChanged(priceStepInWei, _priceStepInWei);
639         priceStepInWei = _priceStepInWei;
640         return true;
641     }
642 
643     function setPriceDiscountBands(uint256[2] memory _newPriceDiscountBands) public onlyWhitelisted returns (bool) {
644         priceDiscountBands = _newPriceDiscountBands;
645 
646         emit PriceDiscountBandsChanged(_newPriceDiscountBands);
647 
648         return true;
649     }
650 
651     function addCredit(address _to) public onlyWhitelisted returns (bool) {
652         credits[_to] = credits[_to].add(1);
653 
654         emit CreditAdded(_to, 1);
655 
656         return true;
657     }
658 
659     function addCreditAmount(address _to, uint256 _amount) public onlyWhitelisted returns (bool) {
660         credits[_to] = credits[_to].add(_amount);
661 
662         emit CreditAdded(_to, _amount);
663 
664         return true;
665     }
666 
667     function addCreditBatch(address[] memory _addresses, uint256 _amount) public onlyWhitelisted returns (bool) {
668         for (uint i = 0; i < _addresses.length; i++) {
669             addCreditAmount(_addresses[i], _amount);
670         }
671 
672         return true;
673     }
674 
675     function setFloorPricePerBuildingInWei(uint256 _floorPricePerBuildingInWei) public onlyWhitelisted returns (bool) {
676         emit FloorPricePerBuildingInWeiChanged(floorPricePerBuildingInWei, _floorPricePerBuildingInWei);
677         floorPricePerBuildingInWei = _floorPricePerBuildingInWei;
678         return true;
679     }
680 
681     function setCeilingPricePerBuildingInWei(uint256 _ceilingPricePerBuildingInWei) public onlyWhitelisted returns (bool) {
682         emit CeilingPricePerBuildingInWeiChanged(ceilingPricePerBuildingInWei, _ceilingPricePerBuildingInWei);
683         ceilingPricePerBuildingInWei = _ceilingPricePerBuildingInWei;
684         return true;
685     }
686 
687     function setBlockStep(uint256 _blockStep) public onlyWhitelisted returns (bool) {
688         emit BlockStepChanged(blockStep, _blockStep);
689         blockStep = _blockStep;
690         return true;
691     }
692 
693     function setLastSaleBlock(uint256 _lastSaleBlock) public onlyWhitelisted returns (bool) {
694         emit LastSaleBlockChanged(lastSaleBlock, _lastSaleBlock);
695         lastSaleBlock = _lastSaleBlock;
696         return true;
697     }
698 
699     function setLastSalePrice(uint256 _lastSalePrice) public onlyWhitelisted returns (bool) {
700         emit LastSalePriceChanged(lastSalePrice, _lastSalePrice);
701         lastSalePrice = _lastSalePrice;
702         return true;
703     }
704 
705     function setLogicGenerator(ILogicGenerator _logicGenerator) public onlyWhitelisted returns (bool) {
706         logicGenerator = _logicGenerator;
707         return true;
708     }
709 
710     function setColourGenerator(IColourGenerator _colourGenerator) public onlyWhitelisted returns (bool) {
711         colourGenerator = _colourGenerator;
712         return true;
713     }
714 }