1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         if (newOwner != address(0)) {
18             owner = newOwner;
19         }
20     }
21 }
22 
23 
24 contract ERC721 {
25     
26     function totalSupply() public view returns (uint256 total);
27     function balanceOf(address _owner) public view returns (uint256 balance);
28     function ownerOf(uint256 _tokenId) external view returns (address owner);
29     function approve(address _to, uint256 _tokenId) external;
30     function transfer(address _to, uint256 _tokenId) external;
31     function transferFrom(address _from, address _to, uint256 _tokenId) external;
32 
33     event Transfer(address from, address to, uint256 tokenId);
34     event Approval(address owner, address approved, uint256 tokenId);
35 
36     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
37 }
38 
39 
40 contract GeneScienceInterface {
41     
42     function isGeneScience() public pure returns (bool);
43 
44     function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
45 }
46 
47 
48 contract VariationInterface {
49 
50     function isVariation() public pure returns(bool);
51     
52     function createVariation(uint256 _gene, uint256 _totalSupply) public returns (uint8);
53     
54     function registerVariation(uint256 _dogId, address _owner) public;
55 }
56 
57 
58 contract LotteryInterface {
59     
60     function isLottery() public pure returns (bool);
61 
62     function checkLottery(uint256 genes) public pure returns (uint8 lotclass);
63     
64     function registerLottery(uint256 _dogId) public payable returns (uint8);
65 
66     function getCLottery() 
67         public 
68         view 
69         returns (
70             uint8[7]        luckyGenes1,
71             uint256         totalAmount1,
72             uint256         openBlock1,
73             bool            isReward1,
74             uint256         term1,
75             uint8           currentGenes1,
76             uint256         tSupply,
77             uint256         sPoolAmount1,
78             uint256[]       reward1
79         );
80 }
81 
82 
83 contract DogAccessControl {
84     
85     event ContractUpgrade(address newContract);
86 
87     address public ceoAddress;
88     address public cfoAddress;
89     address public cooAddress;
90 
91     bool public paused = false;
92 
93     modifier onlyCEO() {
94         require(msg.sender == ceoAddress);
95         _;
96     }
97 
98     modifier onlyCFO() {
99         require(msg.sender == cfoAddress);
100         _;
101     }
102 
103     modifier onlyCOO() {
104         require(msg.sender == cooAddress);
105         _;
106     }
107 
108     modifier onlyCLevel() {
109         require(msg.sender == cooAddress || msg.sender == ceoAddress || msg.sender == cfoAddress);
110         _;
111     }
112 
113     function setCEO(address _newCEO) external onlyCEO {
114         require(_newCEO != address(0));
115 
116         ceoAddress = _newCEO;
117     }
118 
119     function setCFO(address _newCFO) external onlyCEO {
120         require(_newCFO != address(0));
121 
122         cfoAddress = _newCFO;
123     }
124 
125     function setCOO(address _newCOO) external onlyCEO {
126         require(_newCOO != address(0));
127 
128         cooAddress = _newCOO;
129     }
130 
131     modifier whenNotPaused() {
132         require(!paused);
133         _;
134     }
135 
136     modifier whenPaused {
137         require(paused);
138         _;
139     }
140 
141     function pause() external onlyCLevel whenNotPaused {
142         paused = true;
143     }
144 
145     function unpause() public onlyCEO whenPaused {
146         paused = false;
147     }
148 }
149 
150 
151 contract DogBase is DogAccessControl {
152 
153     event Birth(address owner, uint256 dogId, uint256 matronId, uint256 sireId, uint256 genes, uint16 generation, uint8 variation, uint256 gen0, uint256 birthTime, uint256 income, uint16 cooldownIndex);
154 
155     event Transfer(address from, address to, uint256 tokenId);
156 
157     struct Dog {
158         
159         uint256 genes;
160 
161         uint256 birthTime;
162 
163         uint64 cooldownEndBlock;
164 
165         uint32 matronId;
166 
167         uint32 sireId;
168 
169         uint32 siringWithId;
170 
171         uint16 cooldownIndex;
172 
173         uint16 generation;
174 
175         uint8  variation;
176 
177         uint256 gen0;
178     }
179 
180     uint32[14] public cooldowns = [
181         uint32(1 minutes),
182         uint32(2 minutes),
183         uint32(5 minutes),
184         uint32(10 minutes),
185         uint32(30 minutes),
186         uint32(1 hours),
187         uint32(2 hours),
188         uint32(4 hours),
189         uint32(8 hours),
190         uint32(16 hours),
191         uint32(24 hours),
192         uint32(2 days),
193         uint32(3 days),
194         uint32(5 days)
195     ];
196 
197     uint256 public secondsPerBlock = 15;
198 
199     Dog[] dogs;
200 
201     mapping (uint256 => address) dogIndexToOwner;
202 
203     mapping (address => uint256) ownershipTokenCount;
204 
205     mapping (uint256 => address) public dogIndexToApproved;
206 
207     mapping (uint256 => address) public sireAllowedToAddress;
208 
209     SaleClockAuction public saleAuction;
210 
211     SiringClockAuction public siringAuction;
212 
213     VariationInterface public variation;
214 
215     LotteryInterface public lottery;
216 
217     uint256 public autoBirthFee = 7500 szabo;
218 
219     uint256 public gen0Profit = 500 szabo;
220     
221     uint256 public creationProfit = 1000 szabo;
222 
223     mapping (address => uint256) public profit;
224 
225     function _sendMoney(address _to, uint256 _money) internal {
226         spendMoney += _money;
227         require(address(this).balance >= spendMoney);
228         profit[_to] += _money;
229     }
230 
231     function sendMoney(address _to, uint256 _money) external {
232         require(msg.sender == address(lottery) || msg.sender == address(variation));
233         _sendMoney(_to, _money);
234     }
235 
236     event Withdraw(address _owner, uint256 _value);
237 
238     function withdraw() public {
239         uint256 value = profit[msg.sender];
240         require(value > 0);
241         msg.sender.transfer(value);
242         spendMoney -= value;
243         delete profit[msg.sender];
244 
245         Withdraw(msg.sender, value);
246     }
247 
248     uint256 public spendMoney;
249 
250     function setGen0Profit(uint256 _value) public onlyCEO {        
251         uint256 ration = _value * 100 / autoBirthFee;
252         require(ration > 0);
253         require(_value <= 100);
254         gen0Profit = _value;
255     }
256 
257     function setCreationProfit(uint256 _value) public onlyCEO {        
258         uint256 ration = _value * 100 / autoBirthFee;
259         require(ration > 0);
260         require(_value <= 100);
261         creationProfit = _value;
262     }
263 
264     function _transfer(address _from, address _to, uint256 _tokenId) internal {
265         ownershipTokenCount[_to]++;
266         dogIndexToOwner[_tokenId] = _to;
267         if (_from != address(0)) {
268             ownershipTokenCount[_from]--;
269             delete sireAllowedToAddress[_tokenId];
270             delete dogIndexToApproved[_tokenId];
271         }
272 
273         Transfer(_from, _to, _tokenId);
274     }
275 
276     function _createDog(
277         uint256 _matronId,
278         uint256 _sireId,
279         uint256 _generation,
280         uint256 _genes,
281         address _owner,
282         uint8 _variation,
283         uint256 _gen0,
284         bool _isGen0Siring
285     )
286         internal
287         returns (uint)
288     {
289         require(_matronId == uint256(uint32(_matronId)));
290         require(_sireId == uint256(uint32(_sireId)));
291         require(_generation == uint256(uint16(_generation)));
292 
293         uint16 cooldownIndex = uint16(_generation / 2);
294         if (cooldownIndex > 13) {
295             cooldownIndex = 13;
296         }
297 
298         Dog memory _dog = Dog({
299             genes: _genes,
300             birthTime: block.number,
301             cooldownEndBlock: 0,
302             matronId: uint32(_matronId),
303             sireId: uint32(_sireId),
304             siringWithId: 0,
305             cooldownIndex: cooldownIndex,
306             generation: uint16(_generation),
307             variation : uint8(_variation),
308             gen0 : _gen0
309         });
310         uint256 newDogId = dogs.push(_dog) - 1;
311 
312         require(newDogId < 23887872);
313 
314         Birth(
315             _owner,
316             newDogId,
317             uint256(_dog.matronId),
318             uint256(_dog.sireId),
319             _dog.genes,
320             uint16(_generation),
321             _variation,
322             _gen0,
323             block.number,
324             _isGen0Siring ? 0 : gen0Profit,
325             cooldownIndex
326         );
327 
328         _transfer(0, _owner, newDogId);
329 
330         return newDogId;
331     }
332 
333     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
334         require(secs < cooldowns[0]);
335         secondsPerBlock = secs;
336     }
337 }
338 
339 
340 contract DogOwnership is DogBase, ERC721 {
341 
342     string public constant name = "HelloDog";
343     string public constant symbol = "HD";
344 
345     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
346 
347     bytes4 constant InterfaceSignature_ERC721 =
348         bytes4(keccak256("name()")) ^
349         bytes4(keccak256("symbol()")) ^
350         bytes4(keccak256("totalSupply()")) ^
351         bytes4(keccak256("balanceOf(address)")) ^
352         bytes4(keccak256("ownerOf(uint256)")) ^
353         bytes4(keccak256("approve(address,uint256)")) ^
354         bytes4(keccak256("transfer(address,uint256)")) ^
355     bytes4(keccak256("transferFrom(address,address,uint256)"));
356 
357     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
358     {
359         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
360     }
361 
362     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
363         return dogIndexToOwner[_tokenId] == _claimant;
364     }
365 
366     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
367         return dogIndexToApproved[_tokenId] == _claimant;
368     }
369 
370     function _approve(uint256 _tokenId, address _approved) internal {
371         dogIndexToApproved[_tokenId] = _approved;
372     }
373 
374     function balanceOf(address _owner) public view returns (uint256 count) {
375         return ownershipTokenCount[_owner];
376     }
377 
378     function transfer(
379         address _to,
380         uint256 _tokenId
381     )
382         external
383         whenNotPaused
384     {
385         require(_to != address(0));
386         require(_to != address(this));
387         require(_to != address(saleAuction));
388         require(_to != address(siringAuction));
389 
390         require(_owns(msg.sender, _tokenId));
391 
392         _transfer(msg.sender, _to, _tokenId);
393     }
394 
395     function approve(
396         address _to,
397         uint256 _tokenId
398     )
399         external
400         whenNotPaused
401     {
402         require(_owns(msg.sender, _tokenId));
403 
404         _approve(_tokenId, _to);
405 
406         Approval(msg.sender, _to, _tokenId);
407     }
408 
409     function transferFrom(
410         address _from,
411         address _to,
412         uint256 _tokenId
413     )
414         external
415         whenNotPaused
416     {
417         require(_to != address(0));
418         require(_to != address(this));
419 
420         require(_approvedFor(msg.sender, _tokenId));
421         require(_owns(_from, _tokenId));
422 
423         _transfer(_from, _to, _tokenId);
424     }
425 
426     function totalSupply() public view returns (uint) {
427         return dogs.length - 1;
428     }
429 
430     function ownerOf(uint256 _tokenId)
431         external
432         view
433         returns (address owner)
434     {
435         owner = dogIndexToOwner[_tokenId];
436 
437         require(owner != address(0));
438     }
439 }
440 
441 
442 contract DogBreeding is DogOwnership {
443 
444     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 matronCooldownEndBlock, uint256 sireCooldownEndBlock, uint256 matronCooldownIndex, uint256 sireCooldownIndex);
445 
446     uint256 public pregnantDogs;
447 
448     GeneScienceInterface public geneScience;
449 
450     function setGeneScienceAddress(address _address) external onlyCEO {
451         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
452 
453         require(candidateContract.isGeneScience());
454 
455         geneScience = candidateContract;
456     }
457 
458     function _isReadyToBreed(Dog _dog) internal view returns (bool) {
459         return (_dog.siringWithId == 0) && (_dog.cooldownEndBlock <= uint64(block.number));
460     }
461 
462     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
463         address matronOwner = dogIndexToOwner[_matronId];
464         address sireOwner = dogIndexToOwner[_sireId];
465 
466         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
467     }
468 
469     function _triggerCooldown(Dog storage _dog) internal {
470         _dog.cooldownEndBlock = uint64((cooldowns[_dog.cooldownIndex]/secondsPerBlock) + block.number);
471 
472         if (_dog.cooldownIndex < 13) {
473             _dog.cooldownIndex += 1;
474         }
475     }
476 
477     function approveSiring(address _addr, uint256 _sireId)
478         external
479         whenNotPaused
480     {
481         require(_owns(msg.sender, _sireId));
482         sireAllowedToAddress[_sireId] = _addr;
483     }
484 
485     function setAutoBirthFee(uint256 val) external onlyCEO {
486         require(val > 0);
487         autoBirthFee = val;
488     }
489 
490     function _isReadyToGiveBirth(Dog _matron) private view returns (bool) {
491         return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
492     }
493 
494     function isReadyToBreed(uint256 _dogId)
495         public
496         view
497         returns (bool)
498     {
499         require(_dogId > 1);
500         Dog storage dog = dogs[_dogId];
501         return _isReadyToBreed(dog);
502     }
503 
504     function isPregnant(uint256 _dogId)
505         public
506         view
507         returns (bool)
508     {
509         return dogs[_dogId].siringWithId != 0;
510     }
511 
512     function _isValidMatingPair(
513         Dog storage _matron,
514         uint256 _matronId,
515         Dog storage _sire,
516         uint256 _sireId
517     )
518         private
519         view
520         returns(bool)
521     {
522         if (_matronId == _sireId) {
523             return false;
524         }
525 
526         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
527             return false;
528         }
529         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
530             return false;
531         }
532 
533         if (_sire.matronId == 0 || _matron.matronId == 0) {
534             return true;
535         }
536 
537         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
538             return false;
539         }
540         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
541             return false;
542         }
543 
544         return true;
545     }
546 
547     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
548         internal
549         view
550         returns (bool)
551     {
552         Dog storage matron = dogs[_matronId];
553         Dog storage sire = dogs[_sireId];
554         return _isValidMatingPair(matron, _matronId, sire, _sireId);
555     }
556     
557     function getOwner(uint256 _tokenId) public view returns(address){
558         address owner = dogIndexToOwner[_tokenId];
559         if(owner == address(saleAuction)){
560             return saleAuction.getSeller(_tokenId);
561         } else if (owner == address(siringAuction)){
562             return siringAuction.getSeller(_tokenId);
563         } else if (owner == address(this)){
564             return address(0);
565         }
566         return owner;
567     }
568 
569     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
570         require(_matronId > 1);
571         require(_sireId > 1);
572         
573         Dog storage sire = dogs[_sireId];
574         Dog storage matron = dogs[_matronId];
575 
576         require(sire.variation == 0);
577         require(matron.variation == 0);
578 
579         if (matron.generation > 0) {
580             var(,,openBlock,,,,,,) = lottery.getCLottery();
581             if (matron.birthTime < openBlock) {
582                 require(lottery.checkLottery(matron.genes) == 100);
583             }
584         }
585 
586         matron.siringWithId = uint32(_sireId);
587 
588         _triggerCooldown(sire);
589         _triggerCooldown(matron);
590 
591         delete sireAllowedToAddress[_matronId];
592         delete sireAllowedToAddress[_sireId];
593 
594         pregnantDogs++;
595 
596         cfoAddress.transfer(autoBirthFee);
597 
598         address owner = getOwner(0);
599         if(owner != address(0)){
600             _sendMoney(owner, creationProfit);
601         }
602         owner = getOwner(1);
603         if(owner != address(0)){
604             _sendMoney(owner, creationProfit);
605         }
606 
607         if (matron.generation > 0) {
608             owner = getOwner(matron.gen0);
609             if(owner != address(0)){
610                 _sendMoney(owner, gen0Profit);
611             }
612         }
613 
614         Pregnant(dogIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock, sire.cooldownEndBlock, matron.cooldownIndex, sire.cooldownIndex);
615     }
616 
617     function breedWithAuto(uint256 _matronId, uint256 _sireId)
618         external
619         payable
620         whenNotPaused
621     {        
622         uint256 totalFee = autoBirthFee + creationProfit + creationProfit;
623         Dog storage matron = dogs[_matronId];
624         if (matron.generation > 0) {
625             totalFee += gen0Profit;
626         }
627 
628         require(msg.value >= totalFee);
629 
630         require(_owns(msg.sender, _matronId));
631 
632         require(_isSiringPermitted(_sireId, _matronId));
633 
634         require(_isReadyToBreed(matron));
635 
636         Dog storage sire = dogs[_sireId];
637 
638         require(_isReadyToBreed(sire));
639 
640         require(_isValidMatingPair(matron, _matronId, sire, _sireId));
641 
642         _breedWith(_matronId, _sireId);
643 
644         uint256 breedExcess = msg.value - totalFee;
645         if (breedExcess > 0) {
646             msg.sender.transfer(breedExcess);
647         }
648     }
649 
650     bool public giveBirthByUser = false;
651 
652     function setGiveBirthType(bool _value) public onlyCEO {
653         giveBirthByUser = _value;
654     }
655 
656     function giveBirth(uint256 _matronId, uint256 genes)
657         external
658         whenNotPaused
659         returns(uint256)
660     {
661         Dog storage matron = dogs[_matronId];
662 
663         require(matron.birthTime != 0);
664 
665         require(_isReadyToGiveBirth(matron));
666 
667         uint256 sireId = matron.siringWithId;
668         Dog storage sire = dogs[sireId];
669 
670         uint16 parentGen = matron.generation;
671         if (sire.generation > matron.generation) {
672             parentGen = sire.generation;
673         }
674 
675         uint256 gen0 = matron.generation == 0 ? _matronId : matron.gen0;
676 
677         uint256 childGenes = genes;
678         if(giveBirthByUser){
679             require(address(geneScience) != address(0));
680             childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
681         } else {
682             require(msg.sender == ceoAddress || msg.sender == cooAddress || msg.sender == cfoAddress);
683         }
684         
685         address owner = dogIndexToOwner[_matronId];
686 
687         uint8 _variation = variation.createVariation(childGenes, dogs.length);
688 
689         bool isGen0Siring = matron.generation == 0;
690 
691         uint256 kittenId = _createDog(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner, _variation, gen0, isGen0Siring);
692 
693         delete matron.siringWithId;
694 
695         pregnantDogs--;
696        
697         if(_variation != 0){              
698             variation.registerVariation(kittenId, owner);      
699             _transfer(owner, address(variation), kittenId);
700         }
701 
702         return kittenId;
703     }
704 }
705 
706 
707 contract ClockAuctionBase {
708 
709     struct Auction {
710         
711         address seller;
712         
713         uint128 startingPrice;
714         
715         uint128 endingPrice;
716         
717         uint64 duration;
718         
719         uint64 startedAt;
720     }
721 
722     ERC721 public nonFungibleContract;
723 
724     uint256 public ownerCut;
725 
726     mapping (uint256 => Auction) tokenIdToAuction;
727 
728     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
729     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
730     event AuctionCancelled(uint256 tokenId);
731 
732     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
733         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
734     }
735 
736     function _escrow(address _owner, uint256 _tokenId) internal {
737         nonFungibleContract.transferFrom(_owner, this, _tokenId);
738     }
739 
740     function _transfer(address _receiver, uint256 _tokenId) internal {
741         nonFungibleContract.transfer(_receiver, _tokenId);
742     }
743 
744     function _addAuction(uint256 _tokenId, Auction _auction) internal {
745         require(_auction.duration >= 1 minutes);
746 
747         tokenIdToAuction[_tokenId] = _auction;
748 
749         AuctionCreated(
750             uint256(_tokenId),
751             uint256(_auction.startingPrice),
752             uint256(_auction.endingPrice),
753             uint256(_auction.duration)
754         );
755     }
756 
757     function _cancelAuction(uint256 _tokenId, address _seller) internal {
758         _removeAuction(_tokenId);
759         _transfer(_seller, _tokenId);
760         AuctionCancelled(_tokenId);
761     }
762 
763     function _bid(uint256 _tokenId, uint256 _bidAmount, address _to)
764         internal
765         returns (uint256)
766     {
767         Auction storage auction = tokenIdToAuction[_tokenId];
768 
769         require(_isOnAuction(auction));
770 
771         uint256 price = _currentPrice(auction);
772         uint256 auctioneerCut = computeCut(price);
773 
774         uint256 fee = 0;
775         if (_tokenId == 0 || _tokenId == 1) {
776             fee = price / 5;
777         }        
778         require((_bidAmount + auctioneerCut + fee) >= price);
779 
780         address seller = auction.seller;
781 
782         _removeAuction(_tokenId);
783 
784         if (price > 0) {
785             uint256 sellerProceeds = price - auctioneerCut - fee;
786 
787             seller.transfer(sellerProceeds);
788         }
789 
790         AuctionSuccessful(_tokenId, price, _to);
791 
792         return price;
793     }
794 
795     function _removeAuction(uint256 _tokenId) internal {
796         delete tokenIdToAuction[_tokenId];
797     }
798 
799     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
800         return (_auction.startedAt > 0);
801     }
802 
803     function _currentPrice(Auction storage _auction)
804         internal
805         view
806         returns (uint256)
807     {
808         uint256 secondsPassed = 0;
809 
810         if (now > _auction.startedAt) {
811             secondsPassed = now - _auction.startedAt;
812         }
813 
814         return _computeCurrentPrice(
815             _auction.startingPrice,
816             _auction.endingPrice,
817             _auction.duration,
818             secondsPassed
819         );
820     }
821 
822     function _computeCurrentPrice(
823         uint256 _startingPrice,
824         uint256 _endingPrice,
825         uint256 _duration,
826         uint256 _secondsPassed
827     )
828         internal
829         pure
830         returns (uint256)
831     {
832         if (_secondsPassed >= _duration) {
833             return _endingPrice;
834         } else {
835             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
836 
837             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
838 
839             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
840 
841             return uint256(currentPrice);
842         }
843     }
844 
845     function computeCut(uint256 _price) public view returns (uint256) {
846         return _price * ownerCut / 10000;
847     }
848 }
849 
850 
851 contract Pausable is Ownable {
852     event Pause();
853     event Unpause();
854 
855     bool public paused = false;
856 
857     modifier whenNotPaused() {
858         require(!paused);
859         _;
860     }
861 
862     modifier whenPaused {
863         require(paused);
864         _;
865     }
866 
867     function pause() public onlyOwner whenNotPaused returns (bool) {
868         paused = true;
869         Pause();
870         return true;
871     }
872 
873     function unpause() public onlyOwner whenPaused returns (bool) {
874         paused = false;
875         Unpause();
876         return true;
877     }
878 }
879 
880 
881 contract ClockAuction is Pausable, ClockAuctionBase {
882 
883     bytes4 constant InterfaceSignature_ERC721 =
884         bytes4(keccak256("name()")) ^
885         bytes4(keccak256("symbol()")) ^
886         bytes4(keccak256("totalSupply()")) ^
887         bytes4(keccak256("balanceOf(address)")) ^
888         bytes4(keccak256("ownerOf(uint256)")) ^
889         bytes4(keccak256("approve(address,uint256)")) ^
890         bytes4(keccak256("transfer(address,uint256)")) ^
891     bytes4(keccak256("transferFrom(address,address,uint256)"));
892 
893     function ClockAuction(address _nftAddress, uint256 _cut) public {
894         require(_cut <= 10000);
895         ownerCut = _cut;
896 
897         ERC721 candidateContract = ERC721(_nftAddress);
898         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
899         nonFungibleContract = candidateContract;
900     }
901 
902     function withdrawBalance() external {
903         address nftAddress = address(nonFungibleContract);
904 
905         require(
906             msg.sender == owner ||
907             msg.sender == nftAddress
908         );
909         nftAddress.transfer(address(this).balance);
910     }
911 
912     function cancelAuction(uint256 _tokenId)
913         external
914     {
915         require(_tokenId > 1);
916 
917         Auction storage auction = tokenIdToAuction[_tokenId];
918         require(_isOnAuction(auction));
919         address seller = auction.seller;
920         require(msg.sender == seller);
921         _cancelAuction(_tokenId, seller);
922     }
923 
924     function cancelAuctionWhenPaused(uint256 _tokenId)
925         whenPaused
926         onlyOwner
927         external
928     {
929         Auction storage auction = tokenIdToAuction[_tokenId];
930         require(_isOnAuction(auction));
931         _cancelAuction(_tokenId, auction.seller);
932     }
933 
934     function getAuction(uint256 _tokenId)
935         external
936         view
937         returns
938     (
939         address seller,
940         uint256 startingPrice,
941         uint256 endingPrice,
942         uint256 duration,
943         uint256 startedAt
944     ) {
945         Auction storage auction = tokenIdToAuction[_tokenId];
946         require(_isOnAuction(auction));
947         return (
948             auction.seller,
949             auction.startingPrice,
950             auction.endingPrice,
951             auction.duration,
952             auction.startedAt
953         );
954     }
955 
956     function getSeller(uint256 _tokenId) external view returns(address){
957         Auction storage auction = tokenIdToAuction[_tokenId];
958         if(_isOnAuction(auction)){
959             return auction.seller;
960         } else {
961             return nonFungibleContract.ownerOf(_tokenId);
962         }
963     }
964 
965     function getCurrentPrice(uint256 _tokenId)
966         external
967         view
968         returns (uint256)
969     {
970         Auction storage auction = tokenIdToAuction[_tokenId];
971         require(_isOnAuction(auction));
972         return _currentPrice(auction);
973     }
974 
975 }
976 
977 
978 contract SiringClockAuction is ClockAuction {
979 
980     bool public isSiringClockAuction = true;
981 
982     function SiringClockAuction(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
983 
984     function createAuction(
985         uint256 _tokenId,
986         uint256 _startingPrice,
987         uint256 _endingPrice,
988         uint256 _duration,
989         address _seller
990     )
991         external
992     {
993         require(_startingPrice == uint256(uint128(_startingPrice)));
994         require(_endingPrice == uint256(uint128(_endingPrice)));
995         require(_duration == uint256(uint64(_duration)));
996 
997         require(msg.sender == address(nonFungibleContract));
998         _escrow(_seller, _tokenId);
999         Auction memory auction = Auction(
1000             _seller,
1001             uint128(_startingPrice),
1002             uint128(_endingPrice),
1003             uint64(_duration),
1004             uint64(now)
1005         );
1006         _addAuction(_tokenId, auction);
1007     }
1008 
1009     function bid(uint256 _tokenId, address _to)
1010         external
1011         payable
1012     {
1013         require(msg.sender == address(nonFungibleContract));
1014         address seller = tokenIdToAuction[_tokenId].seller;
1015         _bid(_tokenId, msg.value, _to);
1016         _transfer(seller, _tokenId);
1017     }
1018 
1019 }
1020 
1021 
1022 contract SaleClockAuction is ClockAuction {
1023 
1024     bool public isSaleClockAuction = true;
1025 
1026     uint256 public gen0SaleCount;
1027 
1028     uint256[5] public lastGen0SalePrices;
1029 
1030     function SaleClockAuction(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
1031 
1032     function createAuction(
1033         uint256 _tokenId,
1034         uint256 _startingPrice,
1035         uint256 _endingPrice,
1036         uint256 _duration,
1037         address _seller
1038     )
1039         external
1040     {
1041         require(_startingPrice == uint256(uint128(_startingPrice)));
1042         require(_endingPrice == uint256(uint128(_endingPrice)));
1043         require(_duration == uint256(uint64(_duration)));
1044 
1045         require(msg.sender == address(nonFungibleContract));
1046         _escrow(_seller, _tokenId);
1047         Auction memory auction = Auction(
1048             _seller,
1049             uint128(_startingPrice),
1050             uint128(_endingPrice),
1051             uint64(_duration),
1052             uint64(now)
1053         );
1054         _addAuction(_tokenId, auction);
1055     }
1056 
1057     function bid(uint256 _tokenId, address _to)
1058         external
1059         payable
1060     {
1061         require(msg.sender == address(nonFungibleContract));
1062 
1063         address seller = tokenIdToAuction[_tokenId].seller;  
1064 
1065         require(seller != _to);
1066 
1067         uint256 price = _bid(_tokenId, msg.value, _to);
1068         
1069         _transfer(_to, _tokenId);
1070    
1071         if (seller == address(nonFungibleContract)) {
1072             lastGen0SalePrices[gen0SaleCount % 5] = price;
1073             gen0SaleCount++;
1074         }
1075     }
1076 
1077     function averageGen0SalePrice() external view returns (uint256) {
1078         uint256 sum = 0;
1079         for (uint256 i = 0; i < 5; i++) {
1080             sum += lastGen0SalePrices[i];
1081         }
1082         return sum / 5;
1083     }
1084 
1085 }
1086 
1087 
1088 contract DogAuction is DogBreeding {
1089 
1090     uint256 public constant GEN0_AUCTION_DURATION = 1 days;
1091 
1092     function setSaleAuctionAddress(address _address) external onlyCEO {
1093         SaleClockAuction candidateContract = SaleClockAuction(_address);
1094 
1095         require(candidateContract.isSaleClockAuction());
1096 
1097         saleAuction = candidateContract;
1098     }
1099 
1100     function setSiringAuctionAddress(address _address) external onlyCEO {
1101         SiringClockAuction candidateContract = SiringClockAuction(_address);
1102 
1103         require(candidateContract.isSiringClockAuction());
1104 
1105         siringAuction = candidateContract;
1106     }
1107 
1108     function createSaleAuction(
1109         uint256 _dogId,
1110         uint256 _startingPrice,
1111         uint256 _endingPrice,
1112         uint256 _duration
1113     )
1114         external
1115         whenNotPaused
1116     {
1117         require(_owns(msg.sender, _dogId) || _approvedFor(msg.sender, _dogId));
1118         require(!isPregnant(_dogId));
1119         _approve(_dogId, saleAuction);
1120         saleAuction.createAuction(
1121             _dogId,
1122             _startingPrice,
1123             _endingPrice,
1124             _duration,
1125             dogIndexToOwner[_dogId]
1126         );
1127     }
1128 
1129     function createSiringAuction(
1130         uint256 _dogId,
1131         uint256 _startingPrice,
1132         uint256 _endingPrice,
1133         uint256 _duration
1134     )
1135         external
1136         whenNotPaused
1137     {    
1138         Dog storage dog = dogs[_dogId];    
1139         require(dog.variation == 0);
1140 
1141         require(_owns(msg.sender, _dogId));
1142         require(isReadyToBreed(_dogId));
1143         _approve(_dogId, siringAuction);
1144         siringAuction.createAuction(
1145             _dogId,
1146             _startingPrice,
1147             _endingPrice,
1148             _duration,
1149             msg.sender
1150         );
1151     }
1152 
1153     function bidOnSiringAuction(
1154         uint256 _sireId,
1155         uint256 _matronId
1156     )
1157         external
1158         payable
1159         whenNotPaused
1160     {
1161         require(_owns(msg.sender, _matronId));
1162         require(isReadyToBreed(_matronId));
1163         require(_canBreedWithViaAuction(_matronId, _sireId));
1164 
1165         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
1166         
1167         uint256 totalFee = currentPrice + autoBirthFee + creationProfit + creationProfit;
1168         Dog storage matron = dogs[_matronId];
1169         if (matron.generation > 0) {
1170             totalFee += gen0Profit;
1171         }        
1172         require(msg.value >= totalFee);
1173 
1174         uint256 auctioneerCut = saleAuction.computeCut(currentPrice);
1175         siringAuction.bid.value(currentPrice - auctioneerCut)(_sireId, msg.sender);
1176         _breedWith(uint32(_matronId), uint32(_sireId));
1177 
1178         uint256 bidExcess = msg.value - totalFee;
1179         if (bidExcess > 0) {
1180             msg.sender.transfer(bidExcess);
1181         }
1182     }
1183 
1184     function bidOnSaleAuction(
1185         uint256 _dogId
1186     )
1187         external
1188         payable
1189         whenNotPaused
1190     {
1191         Dog storage dog = dogs[_dogId];
1192 
1193         if (dog.generation > 0) {
1194             var(,,openBlock,,,,,,) = lottery.getCLottery();
1195             if (dog.birthTime < openBlock) {
1196                 require(lottery.checkLottery(dog.genes) == 100);
1197             }
1198         }
1199 
1200         uint256 currentPrice = saleAuction.getCurrentPrice(_dogId);
1201 
1202         require(msg.value >= currentPrice);
1203 
1204         bool isCreationKitty = _dogId == 0 || _dogId == 1;
1205         uint256 fee = 0;
1206         if (isCreationKitty) {
1207             fee = uint256(currentPrice / 5);
1208         }
1209         uint256 auctioneerCut = saleAuction.computeCut(currentPrice);
1210         saleAuction.bid.value(currentPrice - (auctioneerCut + fee))(_dogId, msg.sender);
1211 
1212         if (isCreationKitty) {
1213             cfoAddress.transfer(fee);
1214 
1215             uint256 nextPrice = uint256(uint128(2 * currentPrice));
1216             if (nextPrice < currentPrice) {
1217                 nextPrice = currentPrice;
1218             }
1219             _approve(_dogId, saleAuction);
1220             saleAuction.createAuction(
1221                 _dogId,
1222                 nextPrice,
1223                 nextPrice,                                               
1224                 GEN0_AUCTION_DURATION,
1225                 msg.sender);
1226         }
1227 
1228         uint256 bidExcess = msg.value - currentPrice;
1229         if (bidExcess > 0) {
1230             msg.sender.transfer(bidExcess);
1231         }
1232     }
1233 }
1234 
1235 
1236 contract DogMinting is DogAuction {
1237 
1238     uint256 public constant GEN0_CREATION_LIMIT = 40000;
1239 
1240     uint256 public constant GEN0_STARTING_PRICE = 200 finney;
1241 
1242     uint256 public gen0CreatedCount;
1243 
1244     function createGen0Dog(uint256 _genes) external onlyCLevel returns(uint256) {
1245         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1246         
1247         uint256 dogId = _createDog(0, 0, 0, _genes, address(this), 0, 0, false);
1248         
1249         _approve(dogId, msg.sender);
1250 
1251         gen0CreatedCount++;
1252         return dogId;
1253     }
1254 
1255     function computeNextGen0Price() public view returns (uint256) {
1256         uint256 avePrice = saleAuction.averageGen0SalePrice();
1257 
1258         require(avePrice == uint256(uint128(avePrice)));
1259 
1260         uint256 nextPrice = avePrice + (avePrice / 2);
1261 
1262         if (nextPrice < GEN0_STARTING_PRICE) {
1263             nextPrice = GEN0_STARTING_PRICE;
1264         }
1265 
1266         return nextPrice;
1267     }
1268 }
1269 
1270 
1271 contract DogCore is DogMinting {
1272 
1273     address public newContractAddress;
1274 
1275     function DogCore() public {
1276         
1277         paused = true;
1278 
1279         ceoAddress = msg.sender;
1280 
1281         cooAddress = msg.sender;
1282 
1283         _createDog(0, 0, 0, uint256(0), address(this), 0, 0, false);   
1284         _approve(0, cooAddress);     
1285         _createDog(0, 0, 0, uint256(0), address(this), 0, 0, false);   
1286         _approve(1, cooAddress);
1287     }
1288 
1289     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1290         newContractAddress = _v2Address;
1291         ContractUpgrade(_v2Address);
1292     }
1293 
1294     function() external payable {
1295         require(
1296             msg.sender == address(saleAuction) ||
1297             msg.sender == address(siringAuction) ||
1298             msg.sender == ceoAddress
1299         );
1300     }
1301 
1302     function getDog(uint256 _id)
1303         external
1304         view
1305         returns (
1306         uint256 cooldownIndex,
1307         uint256 nextActionAt,
1308         uint256 siringWithId,
1309         uint256 birthTime,
1310         uint256 matronId,
1311         uint256 sireId,
1312         uint256 generation,
1313         uint256 genes,
1314         uint8 variation,
1315         uint256 gen0
1316     ) {
1317         Dog storage dog = dogs[_id];
1318 
1319         cooldownIndex = uint256(dog.cooldownIndex);
1320         nextActionAt = uint256(dog.cooldownEndBlock);
1321         siringWithId = uint256(dog.siringWithId);
1322         birthTime = uint256(dog.birthTime);
1323         matronId = uint256(dog.matronId);
1324         sireId = uint256(dog.sireId);
1325         generation = uint256(dog.generation);
1326         genes = uint256(dog.genes);
1327         variation = uint8(dog.variation);
1328         gen0 = uint256(dog.gen0);
1329     }
1330 
1331     function unpause() public onlyCEO whenPaused {
1332         require(saleAuction != address(0));
1333         require(siringAuction != address(0));
1334         require(lottery != address(0));
1335         require(variation != address(0));
1336         require(newContractAddress == address(0));
1337 
1338         super.unpause();
1339     }
1340       
1341     function setLotteryAddress(address _address) external onlyCEO {
1342         require(address(lottery) == address(0));
1343 
1344         LotteryInterface candidateContract = LotteryInterface(_address);
1345 
1346         require(candidateContract.isLottery());
1347 
1348         lottery = candidateContract;
1349     }  
1350       
1351     function setVariationAddress(address _address) external onlyCEO {
1352         require(address(variation) == address(0));
1353 
1354         VariationInterface candidateContract = VariationInterface(_address);
1355 
1356         require(candidateContract.isVariation());
1357 
1358         variation = candidateContract;
1359     }  
1360 
1361     function registerLottery(uint256 _dogId) external returns (uint8) {
1362         require(_owns(msg.sender, _dogId));
1363         require(lottery.registerLottery(_dogId) == 0);    
1364         _transfer(msg.sender, address(lottery), _dogId);
1365     }
1366     
1367     function getAvailableBlance() external view returns(uint256){
1368         return address(this).balance - spendMoney;
1369     }
1370 }