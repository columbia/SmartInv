1 pragma solidity ^0.4.11;
2 
3 
4 contract Ownable {
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
25     function totalSupply() public view returns (uint256 total);
26     function balanceOf(address _owner) public view returns (uint256 balance);
27     function ownerOf(uint256 _tokenId) external view returns (address owner);
28     function approve(address _to, uint256 _tokenId) external;
29     function transfer(address _to, uint256 _tokenId) external;
30     function transferFrom(address _from, address _to, uint256 _tokenId) external;
31     event Transfer(address from, address to, uint256 tokenId);
32     event Approval(address owner, address approved, uint256 tokenId);
33 }
34 
35 contract GeneScienceInterface {
36     function isGeneScience() public pure returns (bool);
37     function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
38 }
39 
40 contract NinjaAccessControl {
41     event ContractUpgrade(address newContract);
42     address public ceoAddress;
43     address public cfoAddress;
44     address public cooAddress;
45     bool public paused = false;
46 
47     modifier onlyCEO() {
48         require(msg.sender == ceoAddress);
49         _;
50     }
51 
52     modifier onlyCFO() {
53         require(msg.sender == cfoAddress);
54         _;
55     }
56 
57     modifier onlyCOO() {
58         require(msg.sender == cooAddress);
59         _;
60     }
61 
62     modifier onlyCLevel() {
63         require(
64             msg.sender == cooAddress ||
65             msg.sender == ceoAddress ||
66             msg.sender == cfoAddress
67         );
68         _;
69     }
70 
71     function setCEO(address _newCEO) external onlyCEO {
72         require(_newCEO != address(0));
73 
74         ceoAddress = _newCEO;
75     }
76 
77     function setCFO(address _newCFO) external onlyCEO {
78         require(_newCFO != address(0));
79 
80         cfoAddress = _newCFO;
81     }
82 
83     function setCOO(address _newCOO) external onlyCEO {
84         require(_newCOO != address(0));
85 
86         cooAddress = _newCOO;
87     }
88 
89     modifier whenNotPaused() {
90         require(!paused);
91         _;
92     }
93 
94     modifier whenPaused {
95         require(paused);
96         _;
97     }
98 
99     function pause() external onlyCLevel whenNotPaused {
100         paused = true;
101     }
102 
103     function unpause() public onlyCEO whenPaused {
104         paused = false;
105     }
106 }
107 
108 
109 contract NinjaBase is NinjaAccessControl {
110     event Birth(
111       address owner,
112       uint256 ninjaId,
113       uint256 matronId,
114       uint256 sireId,
115       uint256 genes,
116       uint256 birthTime
117     );
118 
119     event Transfer(address from, address to, uint256 tokenId);
120 
121     struct Ninja {
122         uint256 genes;
123         uint64 birthTime;
124         uint64 cooldownEndBlock;
125         uint32 matronId;
126         uint32 sireId;
127         uint32 siringWithId;
128         uint16 cooldownIndex;
129         uint16 generation;
130     }
131 
132     uint32[14] public cooldowns = [
133         uint32(1 minutes),
134         uint32(2 minutes),
135         uint32(5 minutes),
136         uint32(10 minutes),
137         uint32(30 minutes),
138         uint32(1 hours),
139         uint32(2 hours),
140         uint32(4 hours),
141         uint32(8 hours),
142         uint32(16 hours),
143         uint32(1 days),
144         uint32(2 days),
145         uint32(4 days),
146         uint32(7 days)
147     ];
148 
149     uint256 public secondsPerBlock = 15;
150 
151     Ninja[] ninjas;
152 
153     mapping (uint256 => address) public ninjaIndexToOwner;
154     mapping (address => uint256) ownershipTokenCount;
155     mapping (uint256 => address) public ninjaIndexToApproved;
156     mapping (uint256 => address) public sireAllowedToAddress;
157     uint32 public destroyedNinjas;
158     SaleClockAuction public saleAuction;
159     SiringClockAuction public siringAuction;
160 
161     function _transfer(address _from, address _to, uint256 _tokenId) internal {
162         if (_to == address(0)) {
163             delete ninjaIndexToOwner[_tokenId];
164         } else {
165             ownershipTokenCount[_to]++;
166             ninjaIndexToOwner[_tokenId] = _to;
167         }
168         if (_from != address(0)) {
169             ownershipTokenCount[_from]--;
170             delete sireAllowedToAddress[_tokenId];
171             delete ninjaIndexToApproved[_tokenId];
172         }
173         Transfer(_from, _to, _tokenId);
174     }
175 
176     function _createNinja(
177         uint256 _matronId,
178         uint256 _sireId,
179         uint256 _generation,
180         uint256 _genes,
181         address _owner
182     )
183         internal
184         returns (uint)
185     {
186         require(_matronId == uint256(uint32(_matronId)));
187         require(_sireId == uint256(uint32(_sireId)));
188         require(_generation == uint256(uint16(_generation)));
189 
190         uint16 cooldownIndex = uint16(_generation / 2);
191         if (cooldownIndex > 13) {
192             cooldownIndex = 13;
193         }
194 
195         Ninja memory _ninja = Ninja({
196             genes: _genes,
197             birthTime: uint64(now),
198             cooldownEndBlock: 0,
199             matronId: uint32(_matronId),
200             sireId: uint32(_sireId),
201             siringWithId: 0,
202             cooldownIndex: cooldownIndex,
203             generation: uint16(_generation)
204         });
205         uint256 newNinjaId = ninjas.push(_ninja) - 1;
206 
207         require(newNinjaId == uint256(uint32(newNinjaId)));
208 
209         Birth(
210             _owner,
211             newNinjaId,
212             uint256(_ninja.matronId),
213             uint256(_ninja.sireId),
214             _ninja.genes,
215             uint256(_ninja.birthTime)
216        );
217 
218         _transfer(0, _owner, newNinjaId);
219 
220         return newNinjaId;
221     }
222 
223     function _destroyNinja(uint256 _ninjaId) internal {
224         require(_ninjaId > 0);
225         address from = ninjaIndexToOwner[_ninjaId];
226         require(from != address(0));
227         destroyedNinjas++;
228         _transfer(from, 0, _ninjaId);
229     }
230 
231     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
232         require(secs < cooldowns[0]);
233         secondsPerBlock = secs;
234     }
235 }
236 
237 
238 contract NinjaExtension is NinjaBase {
239     event Lock(uint256 ninjaId, uint16 mask);
240     mapping (address => bool) extensions;
241     mapping (uint256 => uint16) locks;
242     uint16 constant LOCK_BREEDING = 1;
243     uint16 constant LOCK_TRANSFER = 2;
244     uint16 constant LOCK_ALL = LOCK_BREEDING | LOCK_TRANSFER;
245 
246     function addExtension(address _contract) external onlyCEO {
247         extensions[_contract] = true;
248     }
249 
250     function removeExtension(address _contract) external onlyCEO {
251         delete extensions[_contract];
252     }
253 
254     modifier onlyExtension() {
255         require(extensions[msg.sender] == true);
256         _;
257     }
258 
259     function extCreateNinja(
260         uint256 _matronId,
261         uint256 _sireId,
262         uint256 _generation,
263         uint256 _genes,
264         address _owner
265     )
266         public
267         onlyExtension
268         returns (uint)
269     {
270         return _createNinja(_matronId, _sireId, _generation, _genes, _owner);
271     }
272 
273     function extDestroyNinja(uint256 _ninjaId)
274         public
275         onlyExtension
276     {
277         require(locks[_ninjaId] == 0);
278 
279         _destroyNinja(_ninjaId);
280     }
281 
282     function extLockNinja(uint256 _ninjaId, uint16 _mask)
283         public
284         onlyExtension
285     {
286         _lockNinja(_ninjaId, _mask);
287     }
288 
289     function _lockNinja(uint256 _ninjaId, uint16 _mask)
290         internal
291     {
292         require(_mask > 0);
293 
294         uint16 mask = locks[_ninjaId];
295         require(mask & _mask == 0);
296 
297         if (_mask & LOCK_BREEDING > 0) {
298             Ninja storage ninja = ninjas[_ninjaId];
299             require(ninja.siringWithId == 0);
300         }
301 
302         if (_mask & LOCK_TRANSFER > 0) {
303             address owner = ninjaIndexToOwner[_ninjaId];
304             require(owner != address(saleAuction));
305             require(owner != address(siringAuction));
306         }
307 
308         mask |= _mask;
309 
310         locks[_ninjaId] = mask;
311 
312         Lock(_ninjaId, mask);
313     }
314 
315     function extUnlockNinja(uint256 _ninjaId, uint16 _mask)
316         public
317         onlyExtension
318         returns (uint16)
319     {
320         _unlockNinja(_ninjaId, _mask);
321     }
322 
323     function _unlockNinja(uint256 _ninjaId, uint16 _mask)
324         internal
325     {
326         require(_mask > 0);
327 
328         uint16 mask = locks[_ninjaId];
329         require(mask & _mask == _mask);
330         mask ^= _mask;
331 
332         locks[_ninjaId] = mask;
333 
334         Lock(_ninjaId, mask);
335     }
336 
337     function extGetLock(uint256 _ninjaId)
338         public
339         view
340         onlyExtension
341         returns (uint16)
342     {
343         return locks[_ninjaId];
344     }
345 }
346 
347 
348 contract NinjaOwnership is NinjaExtension, ERC721 {
349     string public constant name = "CryptoNinjas";
350     string public constant symbol = "CBT";
351 
352     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
353         return ninjaIndexToOwner[_tokenId] == _claimant;
354     }
355 
356     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
357         return ninjaIndexToApproved[_tokenId] == _claimant;
358     }
359 
360     function _approve(uint256 _tokenId, address _approved) internal {
361         ninjaIndexToApproved[_tokenId] = _approved;
362     }
363 
364     function balanceOf(address _owner) public view returns (uint256 count) {
365         return ownershipTokenCount[_owner];
366     }
367 
368     function transfer(
369         address _to,
370         uint256 _tokenId
371     )
372         external
373         whenNotPaused
374     {
375         require(_to != address(0));
376         require(_to != address(this));
377         require(_to != address(saleAuction));
378         require(_to != address(siringAuction));
379         require(_owns(msg.sender, _tokenId));
380         require(locks[_tokenId] & LOCK_TRANSFER == 0);
381         _transfer(msg.sender, _to, _tokenId);
382     }
383 
384     function approve(
385         address _to,
386         uint256 _tokenId
387     )
388         external
389         whenNotPaused
390     {
391         require(_owns(msg.sender, _tokenId));
392         require(locks[_tokenId] & LOCK_TRANSFER == 0);
393         _approve(_tokenId, _to);
394         Approval(msg.sender, _to, _tokenId);
395     }
396 
397     function transferFrom(
398         address _from,
399         address _to,
400         uint256 _tokenId
401     )
402         external
403         whenNotPaused
404     {
405         require(_to != address(0));
406         require(_to != address(this));
407         require(_approvedFor(msg.sender, _tokenId));
408         require(_owns(_from, _tokenId));
409         require(locks[_tokenId] & LOCK_TRANSFER == 0);
410         _transfer(_from, _to, _tokenId);
411     }
412 
413     function totalSupply() public view returns (uint) {
414         return ninjas.length - destroyedNinjas;
415     }
416 
417     function ownerOf(uint256 _tokenId)
418         external
419         view
420         returns (address owner)
421     {
422         owner = ninjaIndexToOwner[_tokenId];
423         require(owner != address(0));
424     }
425 
426     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
427         uint256 tokenCount = balanceOf(_owner);
428 
429         if (tokenCount == 0) {
430             return new uint256[](0);
431         } else {
432             uint256[] memory result = new uint256[](tokenCount);
433             uint256 totalNinjas = ninjas.length - 1;
434             uint256 resultIndex = 0;
435             uint256 ninjaId;
436             for (ninjaId = 0; ninjaId <= totalNinjas; ninjaId++) {
437                 if (ninjaIndexToOwner[ninjaId] == _owner) {
438                     result[resultIndex] = ninjaId;
439                     resultIndex++;
440                 }
441             }
442 
443             return result;
444         }
445     }
446 }
447 
448 
449 contract NinjaBreeding is NinjaOwnership {
450     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);
451     uint256 public autoBirthFee = 2 finney;
452     uint256 public pregnantNinjas;
453     GeneScienceInterface public geneScience;
454 
455     function setGeneScienceAddress(address _address) external onlyCEO {
456         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
457         require(candidateContract.isGeneScience());
458         geneScience = candidateContract;
459     }
460 
461     function _isReadyToBreed(uint256 _ninjaId, Ninja _ninja) internal view returns (bool) {
462         return
463             (_ninja.siringWithId == 0) &&
464             (_ninja.cooldownEndBlock <= uint64(block.number)) &&
465             (locks[_ninjaId] & LOCK_BREEDING == 0);
466     }
467 
468     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
469         address matronOwner = ninjaIndexToOwner[_matronId];
470         address sireOwner = ninjaIndexToOwner[_sireId];
471         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
472     }
473 
474     function _triggerCooldown(Ninja storage _ninja) internal {
475         _ninja.cooldownEndBlock = uint64((cooldowns[_ninja.cooldownIndex]/secondsPerBlock) + block.number);
476         if (_ninja.cooldownIndex < 13) {
477             _ninja.cooldownIndex += 1;
478         }
479     }
480 
481     function approveSiring(address _addr, uint256 _sireId)
482         external
483         whenNotPaused
484     {
485         require(_owns(msg.sender, _sireId));
486         sireAllowedToAddress[_sireId] = _addr;
487     }
488 
489     function setAutoBirthFee(uint256 val) external onlyCOO {
490         autoBirthFee = val;
491     }
492 
493     function _isReadyToGiveBirth(Ninja _matron) private view returns (bool) {
494         return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
495     }
496 
497     function isReadyToBreed(uint256 _ninjaId)
498         public
499         view
500         returns (bool)
501     {
502         Ninja storage ninja = ninjas[_ninjaId];
503         return _ninjaId > 0 && _isReadyToBreed(_ninjaId, ninja);
504     }
505 
506     function isPregnant(uint256 _ninjaId)
507         public
508         view
509         returns (bool)
510     {
511         return _ninjaId > 0 && ninjas[_ninjaId].siringWithId != 0;
512     }
513 
514     function _isValidMatingPair(
515         Ninja storage _matron,
516         uint256 _matronId,
517         Ninja storage _sire,
518         uint256 _sireId
519     )
520         private
521         view
522         returns(bool)
523     {
524         if (_matronId == _sireId) {
525             return false;
526         }
527         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
528             return false;
529         }
530         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
531             return false;
532         }
533         if (_sire.matronId == 0 || _matron.matronId == 0) {
534             return true;
535         }
536         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
537             return false;
538         }
539         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
540             return false;
541         }
542         return true;
543     }
544 
545     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
546         internal
547         view
548         returns (bool)
549     {
550         Ninja storage matron = ninjas[_matronId];
551         Ninja storage sire = ninjas[_sireId];
552         return _isValidMatingPair(matron, _matronId, sire, _sireId);
553     }
554 
555     function canBreedWith(uint256 _matronId, uint256 _sireId)
556         external
557         view
558         returns(bool)
559     {
560         require(_matronId > 0);
561         require(_sireId > 0);
562         Ninja storage matron = ninjas[_matronId];
563         Ninja storage sire = ninjas[_sireId];
564         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
565             _isSiringPermitted(_sireId, _matronId);
566     }
567 
568     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
569         Ninja storage sire = ninjas[_sireId];
570         Ninja storage matron = ninjas[_matronId];
571         matron.siringWithId = uint32(_sireId);
572         _triggerCooldown(sire);
573         _triggerCooldown(matron);
574         delete sireAllowedToAddress[_matronId];
575         delete sireAllowedToAddress[_sireId];
576         pregnantNinjas++;
577         Pregnant(ninjaIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock);
578     }
579 
580     function breedWithAuto(uint256 _matronId, uint256 _sireId)
581         external
582         payable
583         whenNotPaused
584     {
585         require(msg.value >= autoBirthFee);
586         require(_owns(msg.sender, _matronId));
587         require(_isSiringPermitted(_sireId, _matronId));
588         Ninja storage matron = ninjas[_matronId];
589         require(_isReadyToBreed(_matronId, matron));
590         Ninja storage sire = ninjas[_sireId];
591         require(_isReadyToBreed(_sireId, sire));
592         require(_isValidMatingPair(
593             matron,
594             _matronId,
595             sire,
596             _sireId
597         ));
598         _breedWith(_matronId, _sireId);
599     }
600 
601     function giveBirth(uint256 _matronId)
602         external
603         whenNotPaused
604         returns(uint256)
605     {
606         Ninja storage matron = ninjas[_matronId];
607         require(matron.birthTime != 0);
608         require(_isReadyToGiveBirth(matron));
609         uint256 sireId = matron.siringWithId;
610         Ninja storage sire = ninjas[sireId];
611         uint16 parentGen = matron.generation;
612         if (sire.generation > matron.generation) {
613             parentGen = sire.generation;
614         }
615         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
616         address owner = ninjaIndexToOwner[_matronId];
617         uint256 ninjaId = _createNinja(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner);
618         delete matron.siringWithId;
619         pregnantNinjas--;
620         msg.sender.send(autoBirthFee);
621         return ninjaId;
622     }
623 }
624 
625 
626 contract ClockAuctionBase {
627     struct Auction {
628         address seller;
629         uint128 startingPrice;
630         uint128 endingPrice;
631         uint64 duration;
632         uint64 startedAt;
633     }
634     ERC721 public nonFungibleContract;
635     uint256 public ownerCut;
636     mapping (uint256 => Auction) tokenIdToAuction;
637     event AuctionCreated(
638       address seller,
639       uint256 tokenId,
640       uint256 startingPrice,
641       uint256 endingPrice,
642       uint256 creationTime,
643       uint256 duration
644     );
645     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address seller, address winner, uint256 time);
646     event AuctionCancelled(uint256 tokenId, address seller, uint256 time);
647 
648     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
649         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
650     }
651 
652     function _escrow(address _owner, uint256 _tokenId) internal {
653         nonFungibleContract.transferFrom(_owner, this, _tokenId);
654     }
655 
656     function _transfer(address _receiver, uint256 _tokenId) internal {
657         nonFungibleContract.transfer(_receiver, _tokenId);
658     }
659 
660     function _addAuction(uint256 _tokenId, Auction _auction) internal {
661         require(_auction.duration >= 1 minutes);
662         tokenIdToAuction[_tokenId] = _auction;
663         AuctionCreated(
664             _auction.seller,
665             uint256(_tokenId),
666             uint256(_auction.startingPrice),
667             uint256(_auction.endingPrice),
668             uint256(_auction.startedAt),
669             uint256(_auction.duration)
670         );
671     }
672 
673     function _cancelAuction(uint256 _tokenId, address _seller) internal {
674         _removeAuction(_tokenId);
675         _transfer(_seller, _tokenId);
676         AuctionCancelled(_tokenId, _seller, uint256(now));
677     }
678 
679     function _bid(uint256 _tokenId, uint256 _bidAmount)
680         internal
681         returns (uint256)
682     {
683         Auction storage auction = tokenIdToAuction[_tokenId];
684         require(_isOnAuction(auction));
685         uint256 price = _currentPrice(auction);
686         require(_bidAmount >= price);
687         address seller = auction.seller;
688         _removeAuction(_tokenId);
689         if (price > 0) {
690             uint256 auctioneerCut = _computeCut(price);
691             uint256 sellerProceeds = price - auctioneerCut;
692             seller.transfer(sellerProceeds);
693         }
694         uint256 bidExcess = _bidAmount - price;
695         msg.sender.transfer(bidExcess);
696         AuctionSuccessful(_tokenId, price, seller, msg.sender, uint256(now));
697         return price;
698     }
699 
700     function _removeAuction(uint256 _tokenId) internal {
701         delete tokenIdToAuction[_tokenId];
702     }
703 
704     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
705         return (_auction.startedAt > 0);
706     }
707 
708     function _currentPrice(Auction storage _auction)
709         internal
710         view
711         returns (uint256)
712     {
713         uint256 secondsPassed = 0;
714         if (now > _auction.startedAt) {
715             secondsPassed = now - _auction.startedAt;
716         }
717         return _computeCurrentPrice(
718             _auction.startingPrice,
719             _auction.endingPrice,
720             _auction.duration,
721             secondsPassed
722         );
723     }
724 
725     function _computeCurrentPrice(
726         uint256 _startingPrice,
727         uint256 _endingPrice,
728         uint256 _duration,
729         uint256 _secondsPassed
730     )
731         internal
732         pure
733         returns (uint256)
734     {
735         if (_secondsPassed >= _duration) {
736             return _endingPrice;
737         } else {
738             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
739             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
740             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
741             return uint256(currentPrice);
742         }
743     }
744 
745     function _computeCut(uint256 _price) internal view returns (uint256) {
746         return _price * ownerCut / 10000;
747     }
748 }
749 
750 
751 contract Pausable is Ownable {
752     event Pause();
753     event Unpause();
754     bool public paused = false;
755 
756     modifier whenNotPaused() {
757         require(!paused);
758         _;
759     }
760 
761     modifier whenPaused {
762         require(paused);
763         _;
764     }
765 
766     function pause() public onlyOwner whenNotPaused returns (bool) {
767         paused = true;
768         Pause();
769         return true;
770     }
771 
772     function unpause() public onlyOwner whenPaused returns (bool) {
773         paused = false;
774         Unpause();
775         return true;
776     }
777 }
778 
779 
780 contract ClockAuction is Pausable, ClockAuctionBase {
781     function ClockAuction(address _nftAddress, uint256 _cut) public {
782         require(_cut <= 10000);
783         ownerCut = _cut;
784 
785         ERC721 candidateContract = ERC721(_nftAddress);
786         nonFungibleContract = candidateContract;
787     }
788 
789     function withdrawBalance() external {
790         address nftAddress = address(nonFungibleContract);
791         require(
792             msg.sender == owner ||
793             msg.sender == nftAddress
794         );
795         bool res = nftAddress.send(this.balance);
796     }
797 
798     function createAuction(
799         uint256 _tokenId,
800         uint256 _startingPrice,
801         uint256 _endingPrice,
802         uint256 _duration,
803         address _seller
804     )
805         external
806         whenNotPaused
807     {
808         require(_startingPrice == uint256(uint128(_startingPrice)));
809         require(_endingPrice == uint256(uint128(_endingPrice)));
810         require(_duration == uint256(uint64(_duration)));
811         require(_owns(msg.sender, _tokenId));
812         _escrow(msg.sender, _tokenId);
813         Auction memory auction = Auction(
814             _seller,
815             uint128(_startingPrice),
816             uint128(_endingPrice),
817             uint64(_duration),
818             uint64(now)
819         );
820         _addAuction(_tokenId, auction);
821     }
822 
823     function bid(uint256 _tokenId)
824         external
825         payable
826         whenNotPaused
827     {
828         _bid(_tokenId, msg.value);
829         _transfer(msg.sender, _tokenId);
830     }
831 
832     function cancelAuction(uint256 _tokenId)
833         external
834     {
835         Auction storage auction = tokenIdToAuction[_tokenId];
836         require(_isOnAuction(auction));
837         address seller = auction.seller;
838         require(msg.sender == seller);
839         _cancelAuction(_tokenId, seller);
840     }
841 
842     function cancelAuctionWhenPaused(uint256 _tokenId)
843         external
844         whenPaused
845         onlyOwner
846     {
847         Auction storage auction = tokenIdToAuction[_tokenId];
848         require(_isOnAuction(auction));
849         _cancelAuction(_tokenId, auction.seller);
850     }
851 
852     function getAuction(uint256 _tokenId)
853         external
854         view
855         returns
856     (
857         address seller,
858         uint256 startingPrice,
859         uint256 endingPrice,
860         uint256 duration,
861         uint256 startedAt
862     )
863     {
864         Auction storage auction = tokenIdToAuction[_tokenId];
865         require(_isOnAuction(auction));
866         return (
867             auction.seller,
868             auction.startingPrice,
869             auction.endingPrice,
870             auction.duration,
871             auction.startedAt
872         );
873     }
874 
875     function getCurrentPrice(uint256 _tokenId)
876         external
877         view
878         returns (uint256)
879     {
880         Auction storage auction = tokenIdToAuction[_tokenId];
881         require(_isOnAuction(auction));
882         return _currentPrice(auction);
883     }
884 
885 }
886 
887 
888 contract SiringClockAuction is ClockAuction {
889     bool public isSiringClockAuction = true;
890 
891     function SiringClockAuction(address _nftAddr, uint256 _cut) public
892         ClockAuction(_nftAddr, _cut) {}
893 
894     function createAuction(
895         uint256 _tokenId,
896         uint256 _startingPrice,
897         uint256 _endingPrice,
898         uint256 _duration,
899         address _seller
900     )
901         external
902     {
903         require(_startingPrice == uint256(uint128(_startingPrice)));
904         require(_endingPrice == uint256(uint128(_endingPrice)));
905         require(_duration == uint256(uint64(_duration)));
906         require(msg.sender == address(nonFungibleContract));
907         _escrow(_seller, _tokenId);
908         Auction memory auction = Auction(
909             _seller,
910             uint128(_startingPrice),
911             uint128(_endingPrice),
912             uint64(_duration),
913             uint64(now)
914         );
915         _addAuction(_tokenId, auction);
916     }
917 
918     function bid(uint256 _tokenId)
919         external
920         payable
921     {
922         require(msg.sender == address(nonFungibleContract));
923         address seller = tokenIdToAuction[_tokenId].seller;
924         _bid(_tokenId, msg.value);
925         _transfer(seller, _tokenId);
926     }
927 
928 }
929 
930 
931 contract SaleClockAuction is ClockAuction {
932     bool public isSaleClockAuction = true;
933     uint256 public gen0SaleCount;
934     uint256[5] public lastGen0SalePrices;
935 
936     function SaleClockAuction(address _nftAddr, uint256 _cut) public
937         ClockAuction(_nftAddr, _cut) {}
938 
939     function createAuction(
940         uint256 _tokenId,
941         uint256 _startingPrice,
942         uint256 _endingPrice,
943         uint256 _duration,
944         address _seller
945     )
946         external
947     {
948         require(_startingPrice == uint256(uint128(_startingPrice)));
949         require(_endingPrice == uint256(uint128(_endingPrice)));
950         require(_duration == uint256(uint64(_duration)));
951         require(msg.sender == address(nonFungibleContract));
952         _escrow(_seller, _tokenId);
953         Auction memory auction = Auction(
954             _seller,
955             uint128(_startingPrice),
956             uint128(_endingPrice),
957             uint64(_duration),
958             uint64(now)
959         );
960         _addAuction(_tokenId, auction);
961     }
962 
963     function bid(uint256 _tokenId)
964         external
965         payable
966     {
967         address seller = tokenIdToAuction[_tokenId].seller;
968         uint256 price = _bid(_tokenId, msg.value);
969         _transfer(msg.sender, _tokenId);
970         if (seller == address(nonFungibleContract)) {
971             lastGen0SalePrices[gen0SaleCount % 5] = price;
972             gen0SaleCount++;
973         }
974     }
975 
976     function averageGen0SalePrice() external view returns (uint256) {
977         uint256 sum = 0;
978         for (uint256 i = 0; i < 5; i++) {
979             sum += lastGen0SalePrices[i];
980         }
981         return sum / 5;
982     }
983 
984 }
985 
986 
987 contract NinjaAuction is NinjaBreeding {
988     function setSaleAuctionAddress(address _address) external onlyCEO {
989         SaleClockAuction candidateContract = SaleClockAuction(_address);
990         require(candidateContract.isSaleClockAuction());
991         saleAuction = candidateContract;
992     }
993 
994     function setSiringAuctionAddress(address _address) external onlyCEO {
995         SiringClockAuction candidateContract = SiringClockAuction(_address);
996         require(candidateContract.isSiringClockAuction());
997         siringAuction = candidateContract;
998     }
999 
1000     function createSaleAuction(
1001         uint256 _ninjaId,
1002         uint256 _startingPrice,
1003         uint256 _endingPrice,
1004         uint256 _duration
1005     )
1006         external
1007         whenNotPaused
1008     {
1009         require(_owns(msg.sender, _ninjaId));
1010         require(!isPregnant(_ninjaId));
1011         _approve(_ninjaId, saleAuction);
1012         saleAuction.createAuction(
1013             _ninjaId,
1014             _startingPrice,
1015             _endingPrice,
1016             _duration,
1017             msg.sender
1018         );
1019     }
1020 
1021     function createSiringAuction(
1022         uint256 _ninjaId,
1023         uint256 _startingPrice,
1024         uint256 _endingPrice,
1025         uint256 _duration
1026     )
1027         external
1028         whenNotPaused
1029     {
1030         require(_owns(msg.sender, _ninjaId));
1031         require(isReadyToBreed(_ninjaId));
1032         _approve(_ninjaId, siringAuction);
1033         siringAuction.createAuction(
1034             _ninjaId,
1035             _startingPrice,
1036             _endingPrice,
1037             _duration,
1038             msg.sender
1039         );
1040     }
1041 
1042     function bidOnSiringAuction(
1043         uint256 _sireId,
1044         uint256 _matronId
1045     )
1046         external
1047         payable
1048         whenNotPaused
1049     {
1050         require(_owns(msg.sender, _matronId));
1051         require(isReadyToBreed(_matronId));
1052         require(_canBreedWithViaAuction(_matronId, _sireId));
1053         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
1054         require(msg.value >= currentPrice + autoBirthFee);
1055         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
1056         _breedWith(uint32(_matronId), uint32(_sireId));
1057     }
1058 
1059     function withdrawAuctionBalances() external onlyCLevel {
1060         saleAuction.withdrawBalance();
1061         siringAuction.withdrawBalance();
1062     }
1063 }
1064 
1065 
1066 contract NinjaMinting is NinjaAuction {
1067     uint256 public constant PROMO_CREATION_LIMIT = 5000;
1068     uint256 public constant GEN0_CREATION_LIMIT = 45000;
1069     uint256 public constant GEN0_STARTING_PRICE = 10 finney;
1070     uint256 public constant GEN0_AUCTION_DURATION = 1 days;
1071     uint256 public promoCreatedCount;
1072     uint256 public gen0CreatedCount;
1073 
1074     function createPromoNinja(uint256 _genes, address _owner) external onlyCOO {
1075         address ninjaOwner = _owner;
1076         if (ninjaOwner == address(0)) {
1077             ninjaOwner = cooAddress;
1078         }
1079         require(promoCreatedCount < PROMO_CREATION_LIMIT);
1080 
1081         promoCreatedCount++;
1082         _createNinja(0, 0, 0, _genes, ninjaOwner);
1083     }
1084 
1085     function createGen0Auction(uint256 _genes) external onlyCOO {
1086         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1087 
1088         uint256 ninjaId = _createNinja(0, 0, 0, _genes, address(this));
1089         _approve(ninjaId, saleAuction);
1090 
1091         saleAuction.createAuction(
1092             ninjaId,
1093             _computeNextGen0Price(),
1094             0,
1095             GEN0_AUCTION_DURATION,
1096             address(this)
1097         );
1098 
1099         gen0CreatedCount++;
1100     }
1101 
1102     function _computeNextGen0Price() internal view returns (uint256) {
1103         uint256 avePrice = saleAuction.averageGen0SalePrice();
1104         require(avePrice == uint256(uint128(avePrice)));
1105         uint256 nextPrice = avePrice + (avePrice / 2);
1106         if (nextPrice < GEN0_STARTING_PRICE) {
1107             nextPrice = GEN0_STARTING_PRICE;
1108         }
1109         return nextPrice;
1110     }
1111 }
1112 
1113 
1114 contract NinjaCore is NinjaMinting {
1115     address public newContractAddress;
1116 
1117     function NinjaCore() public {
1118         paused = true;
1119         ceoAddress = msg.sender;
1120         cooAddress = msg.sender;
1121         _createNinja(0, 0, 0, uint256(-1), msg.sender);
1122     }
1123 
1124     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1125         newContractAddress = _v2Address;
1126         ContractUpgrade(_v2Address);
1127     }
1128 
1129     function() external payable {
1130         require(
1131             msg.sender == address(saleAuction) ||
1132             msg.sender == address(siringAuction)
1133         );
1134     }
1135 
1136     function getNinja(uint256 _id)
1137         external
1138         view
1139         returns (
1140         bool isGestating,
1141         bool isReady,
1142         uint256 cooldownIndex,
1143         uint256 nextActionAt,
1144         uint256 siringWithId,
1145         uint256 birthTime,
1146         uint256 matronId,
1147         uint256 sireId,
1148         uint256 generation,
1149         uint256 genes
1150     )
1151     {
1152         require(ninjaIndexToOwner[_id] != address(0));
1153         Ninja storage ninja = ninjas[_id];
1154         isGestating = (ninja.siringWithId != 0);
1155         isReady = (ninja.cooldownEndBlock <= block.number);
1156         cooldownIndex = uint256(ninja.cooldownIndex);
1157         nextActionAt = uint256(ninja.cooldownEndBlock);
1158         siringWithId = uint256(ninja.siringWithId);
1159         birthTime = uint256(ninja.birthTime);
1160         matronId = uint256(ninja.matronId);
1161         sireId = uint256(ninja.sireId);
1162         generation = uint256(ninja.generation);
1163         genes = ninja.genes;
1164     }
1165 
1166     function unpause() public onlyCEO whenPaused {
1167         require(saleAuction != address(0));
1168         require(siringAuction != address(0));
1169         require(geneScience != address(0));
1170         require(newContractAddress == address(0));
1171         super.unpause();
1172     }
1173 
1174     function withdrawBalance() external onlyCFO {
1175         uint256 balance = this.balance;
1176         uint256 subtractFees = (pregnantNinjas + 1) * autoBirthFee;
1177         if (balance > subtractFees) {
1178             cfoAddress.send(balance - subtractFees);
1179         }
1180     }
1181 
1182     function destroyNinja(uint256 _ninjaId) external onlyCEO {
1183         require(locks[_ninjaId] == 0);
1184         _destroyNinja(_ninjaId);
1185     }
1186 }