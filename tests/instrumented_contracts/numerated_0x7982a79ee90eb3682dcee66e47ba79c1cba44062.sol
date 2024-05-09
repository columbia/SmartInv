1 pragma solidity ^0.4.22;
2 
3 contract ERC721 {
4     // Required methods
5     function totalSupply() public view returns (uint256 total);
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function ownerOf(uint256 _tokenId) external view returns (address owner);
8     function approve(address _to, uint256 _tokenId) external;
9     function transfer(address _to, uint256 _tokenId) external;
10     function transferFrom(address _from, address _to, uint256 _tokenId) external;
11 
12     // Events
13     event Transfer(address from, address to, uint256 tokenId);
14     event Approval(address owner, address approved, uint256 tokenId);
15 
16     // Optional
17     // function name() public view returns (string name);
18     // function symbol() public view returns (string symbol);
19     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
20     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
21 
22     function tokenMetadata(uint256 _tokenId) public view returns (string);
23 
24     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
25     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
26 }
27 
28 contract ERC721Metadata {
29     function getMetadata(uint256 _tokenId) public pure returns (string) {
30         string memory infoUrl;
31         infoUrl = strConcat('https://cryptoflowers.io/v/', uint2str(_tokenId));
32         return infoUrl;
33     }
34 
35     function uint2str(uint i) internal pure returns (string){
36         if (i == 0) return "0";
37         uint j = i;
38         uint length;
39         while (j != 0){
40             length++;
41             j /= 10;
42         }
43         bytes memory bstr = new bytes(length);
44         uint k = length - 1;
45         while (i != 0){
46             bstr[k--] = byte(48 + i % 10);
47             i /= 10;
48         }
49         return string(bstr);
50     }
51 
52     function strConcat(string _a, string _b) internal pure returns (string) {
53         bytes memory _ba = bytes(_a);
54         bytes memory _bb = bytes(_b);
55         string memory ab = new string(_ba.length + _bb.length);
56         bytes memory bab = bytes(ab);
57         uint k = 0;
58         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
59         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
60 
61         return string(bab);
62     }
63 }
64 
65 contract GenomeInterface {
66     function isGenome() public pure returns (bool);
67     function mixGenes(uint256 genes1, uint256 genes2) public returns (uint256);
68 }
69 
70 // @dev admin access and stop/unstop the game
71 contract FlowerAdminAccess {
72     event ContractUpgrade(address newContract);
73 
74     address public rootAddress;
75     address public adminAddress;
76 
77     address public gen0SellerAddress;
78 
79     bool public stopped = false;
80 
81     modifier onlyRoot() {
82         require(msg.sender == rootAddress);
83         _;
84     }
85 
86     modifier onlyAdmin()  {
87         require(msg.sender == adminAddress);
88         _;
89     }
90 
91     modifier onlyAdministrator() {
92         require(msg.sender == rootAddress || msg.sender == adminAddress);
93         _;
94     }
95 
96     function setRoot(address _newRoot) external onlyAdministrator {
97         require(_newRoot != address(0));
98         rootAddress = _newRoot;
99     }
100 
101     function setAdmin(address _newAdmin) external onlyRoot {
102         require(_newAdmin != address(0));
103         adminAddress = _newAdmin;
104     }
105 
106     modifier whenNotStopped() {
107         require(!stopped);
108         _;
109     }
110 
111     modifier whenStopped {
112         require(stopped);
113         _;
114     }
115 
116     function setStop() public onlyAdministrator whenNotStopped {
117         stopped = true;
118     }
119 
120     function setStart() public onlyAdministrator whenStopped {
121         stopped = false;
122     }
123 }
124 
125 contract FlowerBase is FlowerAdminAccess {
126 
127     struct Flower {
128         uint256 genes;
129         uint64 birthTime;
130         uint64 cooldownEndBlock;
131         uint32 matronId;
132         uint32 sireId;
133         uint16 cooldownIndex;
134         uint16 generation;
135     }
136 
137     Flower[] flowers;
138 
139     // Сooldown duration
140     uint32[14] public cooldowns = [
141     uint32(1 minutes),
142     uint32(2 minutes),
143     uint32(5 minutes),
144     uint32(10 minutes),
145     uint32(30 minutes),
146     uint32(1 hours),
147     uint32(2 hours),
148     uint32(4 hours),
149     uint32(8 hours),
150     uint32(16 hours),
151     uint32(1 days),
152     uint32(2 days),
153     uint32(4 days),
154     uint32(7 days)
155     ];
156 
157     uint256 public secondsPerBlock = 15;
158 
159     mapping (uint256 => address) public flowerIndexToOwner;
160     mapping (address => uint256) ownerFlowersCount;
161     mapping (uint256 => address) public flowerIndexToApproved;
162 
163     event Birth(address owner, uint256 flowerId, uint256 matronId, uint256 sireId, uint256 genes);
164     event Transfer(address from, address to, uint256 tokenId);
165     event Money(address from, string actionType, uint256 sum, uint256 cut, uint256 tokenId, uint256 blockNumber);
166 
167     SaleClockAuction public saleAuction;
168     BreedingClockAuction public breedingAuction;
169 
170     function _transfer(address _from, address _to, uint256 _flowerId) internal {
171         ownerFlowersCount[_to]++;
172         flowerIndexToOwner[_flowerId] = _to;
173         if (_from != address(0)) {
174             ownerFlowersCount[_from]--;
175             delete flowerIndexToApproved[_flowerId];
176         }
177         emit Transfer(_from, _to, _flowerId);
178     }
179 
180     function _createFlower(uint256 _matronId, uint256 _sireId, uint256 _generation, uint256 _genes, address _owner) internal returns (uint) {
181         require(_matronId == uint256(uint32(_matronId)));
182         require(_sireId == uint256(uint32(_sireId)));
183         require(_generation == uint256(uint16(_generation)));
184 
185         uint16 cooldownIndex = uint16(_generation / 2);
186         if (cooldownIndex > 13) {
187             cooldownIndex = 13;
188         }
189 
190         Flower memory _flower = Flower({
191             genes: _genes,
192             birthTime: uint64(now),
193             cooldownEndBlock: 0,
194             matronId: uint32(_matronId),
195             sireId: uint32(_sireId),
196             cooldownIndex: cooldownIndex,
197             generation: uint16(_generation)
198             });
199 
200         uint256 newFlowerId = flowers.push(_flower) - 1;
201 
202         require(newFlowerId == uint256(uint32(newFlowerId)));
203 
204         emit Birth(_owner, newFlowerId, uint256(_flower.matronId), uint256(_flower.sireId), _flower.genes);
205 
206         _transfer(0, _owner, newFlowerId);
207 
208         return newFlowerId;
209     }
210 
211     function setSecondsPerBlock(uint256 secs) external onlyAdministrator {
212         require(secs < cooldowns[0]);
213         secondsPerBlock = secs;
214     }
215 }
216 
217 contract FlowerOwnership is FlowerBase, ERC721 {
218 
219     string public constant name = "CryptoFlowers";
220     string public constant symbol = "CF";
221 
222     // Return flower metadata (URL)
223     ERC721Metadata public erc721Metadata;
224 
225     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
226 
227     bytes4 constant InterfaceSignature_ERC721 =
228     bytes4(keccak256('name()')) ^
229     bytes4(keccak256('symbol()')) ^
230     bytes4(keccak256('totalSupply()')) ^
231     bytes4(keccak256('balanceOf(address)')) ^
232     bytes4(keccak256('ownerOf(uint256)')) ^
233     bytes4(keccak256('approve(address,uint256)')) ^
234     bytes4(keccak256('transfer(address,uint256)')) ^
235     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
236     bytes4(keccak256('tokensOfOwner(address)')) ^
237     bytes4(keccak256('tokenMetadata(uint256)'));
238 
239     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
240     ///  Returns true for any standardized interfaces implemented by this contract. We implement
241     ///  ERC-165 (obviously!) and ERC-721.
242     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
243         // DEBUG ONLY
244         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0xf6546c19));
245 
246         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
247     }
248 
249     function setMetadataAddress(address _contractAddress) public onlyAdministrator {
250         erc721Metadata = ERC721Metadata(_contractAddress);
251     }
252 
253     function _owns(address _address, uint256 _flowerId) internal view returns (bool) {
254         return flowerIndexToOwner[_flowerId] == _address;
255     }
256 
257     function balanceOf(address _owner) public view returns (uint256 count) {
258         return ownerFlowersCount[_owner];
259     }
260 
261     function ownerOf(uint256 _flowerId) external view returns (address owner) {
262         owner = flowerIndexToOwner[_flowerId];
263         require(owner != address(0));
264     }
265 
266     function _approve(uint256 _flowerId, address _address) internal {
267         flowerIndexToApproved[_flowerId] = _address;
268     }
269 
270     function _approvedFor(address _address, uint256 _flowerId) internal view returns (bool) {
271         return flowerIndexToApproved[_flowerId] == _address;
272     }
273 
274     function transfer(address _to, uint256 _flowerId) external whenNotStopped {
275         require(_to != address(0));
276         require(_to != address(this));
277 
278         require(_owns(msg.sender, _flowerId));
279         _transfer(msg.sender, _to, _flowerId);
280     }
281 
282     function approve(address _to, uint256 _flowerId) external whenNotStopped {
283         require(_owns(msg.sender, _flowerId));
284 
285         _approve(_flowerId, _to);
286 
287         emit Approval(msg.sender, _to, _flowerId);
288     }
289 
290     function transferFrom(address _from, address _to, uint256 _flowerId) external whenNotStopped {
291         require(_to != address(0));
292         require(_to != address(this));
293         require(_approvedFor(msg.sender, _flowerId));
294         require(_owns(_from, _flowerId));
295 
296         _transfer(_from, _to, _flowerId);
297     }
298 
299     // Count all flowers
300     function totalSupply() public view returns (uint) {
301         return flowers.length - 1;
302     }
303 
304     // List owner flowers
305     function tokensOfOwner(address _owner) external view returns(uint256[] ownerFlowers) {
306         uint256 count = balanceOf(_owner);
307 
308         if (count == 0) {
309             return new uint256[](0);
310         } else {
311             uint256[] memory result = new uint256[](count);
312             uint256 totalFlowers = totalSupply();
313             uint256 resultIndex = 0;
314 
315             uint256 flowerId;
316             for (flowerId = 1; flowerId <= totalFlowers; flowerId++) {
317                 if (flowerIndexToOwner[flowerId] == _owner) {
318                     result[resultIndex] = flowerId;
319                     resultIndex++;
320                 }
321             }
322 
323             return result;
324         }
325     }
326 
327     function tokenMetadata(uint256 _tokenId) public view returns (string) {
328         require(erc721Metadata != address(0));
329         string memory url;
330         url = erc721Metadata.getMetadata(_tokenId);
331         return url;
332     }
333 }
334 
335 
336 contract Ownable {
337     address public owner;
338     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
339 
340     constructor() public {
341         owner = msg.sender;
342     }
343 
344     modifier onlyOwner() {
345         require(msg.sender == owner);
346         _;
347     }
348 
349     function transferOwnership(address newOwner) public onlyOwner {
350         require(newOwner != address(0));
351         owner = newOwner;
352         emit OwnershipTransferred(owner, newOwner);
353     }
354 }
355 
356 contract ClockAuctionBase {
357 
358     struct Auction {
359         address seller;
360         uint128 startingPrice;
361         uint128 endingPrice;
362         uint64 duration;
363         uint64 startedAt;
364     }
365 
366     ERC721 public nonFungibleContract;
367 
368     uint256 public ownerCut;
369 
370     mapping (uint256 => Auction) tokenIdToAuction;
371 
372     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
373     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
374     event AuctionCancelled(uint256 tokenId);
375     event Money(address from, string actionType, uint256 sum, uint256 cut, uint256 tokenId, uint256 blockNumber);
376 
377     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
378         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
379     }
380 
381     function _escrow(address _owner, uint256 _tokenId) internal {
382         nonFungibleContract.transferFrom(_owner, this, _tokenId);
383     }
384 
385     function _transfer(address _receiver, uint256 _tokenId) internal {
386         nonFungibleContract.transfer(_receiver, _tokenId);
387     }
388 
389     function _addAuction(uint256 _tokenId, Auction _auction) internal {
390         require(_auction.duration >= 1 minutes);
391 
392         tokenIdToAuction[_tokenId] = _auction;
393 
394         emit AuctionCreated(uint256(_tokenId), uint256(_auction.startingPrice), uint256(_auction.endingPrice), uint256(_auction.duration));
395     }
396 
397     function _cancelAuction(uint256 _tokenId, address _seller) internal {
398         _removeAuction(_tokenId);
399         _transfer(_seller, _tokenId);
400         emit AuctionCancelled(_tokenId);
401     }
402 
403     function _bid(uint256 _tokenId, uint256 _bidAmount, address _sender) internal returns (uint256) {
404         Auction storage auction = tokenIdToAuction[_tokenId];
405 
406         require(_isOnAuction(auction));
407 
408         uint256 price = _currentPrice(auction);
409         require(_bidAmount >= price);
410 
411         address seller = auction.seller;
412 
413         _removeAuction(_tokenId);
414 
415         if (price > 0) {
416             uint256 auctioneerCut = _computeCut(price);
417             uint256 sellerProceeds = price - auctioneerCut;
418             seller.transfer(sellerProceeds);
419 
420             emit Money(_sender, "AuctionSuccessful", price, auctioneerCut, _tokenId, block.number);
421         }
422 
423         uint256 bidExcess = _bidAmount - price;
424 
425         _sender.transfer(bidExcess);
426 
427         emit AuctionSuccessful(_tokenId, price, _sender);
428 
429         return price;
430     }
431 
432     function _removeAuction(uint256 _tokenId) internal {
433         delete tokenIdToAuction[_tokenId];
434     }
435 
436     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
437         return (_auction.startedAt > 0 && _auction.startedAt < now);
438     }
439 
440     function _currentPrice(Auction storage _auction) internal view returns (uint256) {
441         uint256 secondsPassed = 0;
442 
443         if (now > _auction.startedAt) {
444             secondsPassed = now - _auction.startedAt;
445         }
446 
447         return _computeCurrentPrice(_auction.startingPrice, _auction.endingPrice, _auction.duration, secondsPassed);
448     }
449 
450     function _computeCurrentPrice(uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, uint256 _secondsPassed) internal pure returns (uint256) {
451         if (_secondsPassed >= _duration) {
452             return _endingPrice;
453         } else {
454             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
455 
456             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
457 
458             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
459 
460             return uint256(currentPrice);
461         }
462     }
463 
464     function _computeCut(uint256 _price) internal view returns (uint256) {
465         return uint256(_price * ownerCut / 10000);
466     }
467 }
468 
469 contract Pausable is Ownable {
470     event Pause();
471     event Unpause();
472 
473     bool public paused = false;
474 
475     modifier whenNotPaused() {
476         require(!paused);
477         _;
478     }
479 
480     modifier whenPaused {
481         require(paused);
482         _;
483     }
484 
485     function pause() public onlyOwner whenNotPaused returns (bool) {
486         paused = true;
487         emit Pause();
488         return true;
489     }
490 
491     function unpause() public onlyOwner whenPaused returns (bool) {
492         paused = false;
493         emit Unpause();
494         return true;
495     }
496 }
497 
498 contract ClockAuction is Pausable, ClockAuctionBase {
499     bytes4 constant InterfaceSignature_ERC721 = bytes4(0xf6546c19);
500     constructor(address _nftAddress, uint256 _cut) public {
501         require(_cut <= 10000);
502         ownerCut = _cut;
503 
504         ERC721 candidateContract = ERC721(_nftAddress);
505         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
506         nonFungibleContract = candidateContract;
507     }
508 
509     function withdrawBalance() external {
510         address nftAddress = address(nonFungibleContract);
511 
512         require(msg.sender == owner || msg.sender == nftAddress);
513 
514         owner.transfer(address(this).balance);
515     }
516 
517     function createAuction(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _seller, uint64 _startAt) external whenNotPaused {
518         require(_startingPrice == uint256(uint128(_startingPrice)));
519         require(_endingPrice == uint256(uint128(_endingPrice)));
520         require(_duration == uint256(uint64(_duration)));
521         require(_owns(msg.sender, _tokenId));
522         _escrow(msg.sender, _tokenId);
523         uint64 startAt = _startAt;
524         if (_startAt == 0) {
525             startAt = uint64(now);
526         }
527         Auction memory auction = Auction(
528             _seller,
529             uint128(_startingPrice),
530             uint128(_endingPrice),
531             uint64(_duration),
532             uint64(startAt)
533         );
534         _addAuction(_tokenId, auction);
535     }
536 
537     function bid(uint256 _tokenId, address _sender) external payable whenNotPaused {
538         _bid(_tokenId, msg.value, _sender);
539         _transfer(_sender, _tokenId);
540     }
541 
542     function cancelAuction(uint256 _tokenId) external {
543         Auction storage auction = tokenIdToAuction[_tokenId];
544         require(_isOnAuction(auction));
545         address seller = auction.seller;
546         require(msg.sender == seller);
547         _cancelAuction(_tokenId, seller);
548     }
549 
550     function cancelAuctionByAdmin(uint256 _tokenId) onlyOwner external {
551         Auction storage auction = tokenIdToAuction[_tokenId];
552         require(_isOnAuction(auction));
553         _cancelAuction(_tokenId, auction.seller);
554     }
555 
556     function getAuction(uint256 _tokenId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt) {
557         Auction storage auction = tokenIdToAuction[_tokenId];
558         require(_isOnAuction(auction));
559         return (auction.seller, auction.startingPrice, auction.endingPrice, auction.duration, auction.startedAt);
560     }
561 
562     function getCurrentPrice(uint256 _tokenId) external view returns (uint256){
563         Auction storage auction = tokenIdToAuction[_tokenId];
564         require(_isOnAuction(auction));
565         return _currentPrice(auction);
566     }
567 
568     // TMP
569     function getContractBalance() external view returns (uint256) {
570         return address(this).balance;
571     }
572 }
573 
574 contract BreedingClockAuction is ClockAuction {
575 
576     bool public isBreedingClockAuction = true;
577 
578     constructor(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
579 
580     function bid(uint256 _tokenId, address _sender) external payable {
581         require(msg.sender == address(nonFungibleContract));
582         address seller = tokenIdToAuction[_tokenId].seller;
583         _bid(_tokenId, msg.value, _sender);
584         _transfer(seller, _tokenId);
585     }
586 
587     function getCurrentPrice(uint256 _tokenId) external view returns (uint256) {
588         Auction storage auction = tokenIdToAuction[_tokenId];
589         require(_isOnAuction(auction));
590         return _currentPrice(auction);
591     }
592 
593     function createAuction(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _seller, uint64 _startAt) external {
594         require(_startingPrice == uint256(uint128(_startingPrice)));
595         require(_endingPrice == uint256(uint128(_endingPrice)));
596         require(_duration == uint256(uint64(_duration)));
597 
598         require(msg.sender == address(nonFungibleContract));
599         _escrow(_seller, _tokenId);
600         uint64 startAt = _startAt;
601         if (_startAt == 0) {
602             startAt = uint64(now);
603         }
604         Auction memory auction = Auction(_seller, uint128(_startingPrice), uint128(_endingPrice), uint64(_duration), uint64(startAt));
605         _addAuction(_tokenId, auction);
606     }
607 }
608 
609 
610 
611 
612 
613 contract SaleClockAuction is ClockAuction {
614 
615     bool public isSaleClockAuction = true;
616 
617     uint256 public gen0SaleCount;
618     uint256[5] public lastGen0SalePrices;
619 
620     constructor(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
621 
622     address public gen0SellerAddress;
623     function setGen0SellerAddress(address _newAddress) external {
624         require(msg.sender == address(nonFungibleContract));
625         gen0SellerAddress = _newAddress;
626     }
627 
628     function createAuction(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _seller, uint64 _startAt) external {
629         require(_startingPrice == uint256(uint128(_startingPrice)));
630         require(_endingPrice == uint256(uint128(_endingPrice)));
631         require(_duration == uint256(uint64(_duration)));
632 
633         require(msg.sender == address(nonFungibleContract));
634         _escrow(_seller, _tokenId);
635         uint64 startAt = _startAt;
636         if (_startAt == 0) {
637             startAt = uint64(now);
638         }
639         Auction memory auction = Auction(_seller, uint128(_startingPrice), uint128(_endingPrice), uint64(_duration), uint64(startAt));
640         _addAuction(_tokenId, auction);
641     }
642 
643     function bid(uint256 _tokenId) external payable {
644         // _bid verifies token ID size
645         address seller = tokenIdToAuction[_tokenId].seller;
646         uint256 price = _bid(_tokenId, msg.value, msg.sender);
647         _transfer(msg.sender, _tokenId);
648 
649         // If not a gen0 auction, exit
650         if (seller == address(gen0SellerAddress)) {
651             // Track gen0 sale prices
652             lastGen0SalePrices[gen0SaleCount % 5] = price;
653             gen0SaleCount++;
654         }
655     }
656 
657     function bidGift(uint256 _tokenId, address _to) external payable {
658         // _bid verifies token ID size
659         address seller = tokenIdToAuction[_tokenId].seller;
660         uint256 price = _bid(_tokenId, msg.value, msg.sender);
661         _transfer(_to, _tokenId);
662 
663         // If not a gen0 auction, exit
664         if (seller == address(gen0SellerAddress)) {
665             // Track gen0 sale prices
666             lastGen0SalePrices[gen0SaleCount % 5] = price;
667             gen0SaleCount++;
668         }
669     }
670 
671     function averageGen0SalePrice() external view returns (uint256) {
672         uint256 sum = 0;
673         for (uint256 i = 0; i < 5; i++) {
674             sum += lastGen0SalePrices[i];
675         }
676         return sum / 5;
677     }
678 
679     function computeCut(uint256 _price) public view returns (uint256) {
680         return _computeCut(_price);
681     }
682 
683     function getSeller(uint256 _tokenId) public view returns (address) {
684         return address(tokenIdToAuction[_tokenId].seller);
685     }
686 }
687 
688 // Flowers crossing
689 contract FlowerBreeding is FlowerOwnership {
690 
691     // Fee for breeding
692     uint256 public autoBirthFee = 2 finney;
693 
694     GenomeInterface public geneScience;
695 
696     // Set Genome contract address
697     function setGenomeContractAddress(address _address) external onlyAdministrator {
698         geneScience = GenomeInterface(_address);
699     }
700 
701     function _isReadyToAction(Flower _flower) internal view returns (bool) {
702         return _flower.cooldownEndBlock <= uint64(block.number);
703     }
704 
705     function isReadyToAction(uint256 _flowerId) public view returns (bool) {
706         require(_flowerId > 0);
707         Flower storage flower = flowers[_flowerId];
708         return _isReadyToAction(flower);
709     }
710 
711     function _setCooldown(Flower storage _flower) internal {
712         _flower.cooldownEndBlock = uint64((cooldowns[_flower.cooldownIndex]/secondsPerBlock) + block.number);
713 
714         if (_flower.cooldownIndex < 13) {
715             _flower.cooldownIndex += 1;
716         }
717     }
718 
719     // Updates the minimum payment required for calling giveBirthAuto()
720     function setAutoBirthFee(uint256 val) external onlyAdministrator {
721         autoBirthFee = val;
722     }
723 
724     // Check if a given sire and matron are a valid crossing pair
725     function _isValidPair(Flower storage _matron, uint256 _matronId, Flower storage _sire, uint256 _sireId) private view returns(bool) {
726         if (_matronId == _sireId) {
727             return false;
728         }
729 
730         // Generation zero can crossing
731         if (_sire.matronId == 0 || _matron.matronId == 0) {
732             return true;
733         }
734 
735         // Do not crossing with it parrents
736         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
737             return false;
738         }
739         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
740             return false;
741         }
742 
743         // Can't crossing with brothers and sisters
744         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
745             return false;
746         }
747         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
748             return false;
749         }
750 
751         return true;
752     }
753 
754     function canBreedWith(uint256 _matronId, uint256 _sireId) external view returns (bool) {
755         return _canBreedWith(_matronId, _sireId);
756     }
757 
758     function _canBreedWith(uint256 _matronId, uint256 _sireId) internal view returns (bool) {
759         require(_matronId > 0);
760         require(_sireId > 0);
761         Flower storage matron = flowers[_matronId];
762         Flower storage sire = flowers[_sireId];
763         return _isValidPair(matron, _matronId, sire, _sireId);
764     }
765 
766     function born(uint256 _matronId, uint256 _sireId) external {
767         _born(_matronId, _sireId);
768     }
769 
770     function _born(uint256 _matronId, uint256 _sireId) internal {
771         Flower storage sire = flowers[_sireId];
772         Flower storage matron = flowers[_matronId];
773 
774         uint16 parentGen = matron.generation;
775         if (sire.generation > matron.generation) {
776             parentGen = sire.generation;
777         }
778 
779         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes);
780         address owner = flowerIndexToOwner[_matronId];
781         uint256 flowerId = _createFlower(_matronId, _sireId, parentGen + 1, childGenes, owner);
782 
783         Flower storage child = flowers[flowerId];
784 
785         _setCooldown(sire);
786         _setCooldown(matron);
787         _setCooldown(child);
788     }
789 
790     // Crossing two of owner flowers
791     function breedOwn(uint256 _matronId, uint256 _sireId) external payable whenNotStopped {
792         require(msg.value >= autoBirthFee);
793         require(_owns(msg.sender, _matronId));
794         require(_owns(msg.sender, _sireId));
795 
796         Flower storage matron = flowers[_matronId];
797         require(_isReadyToAction(matron));
798 
799         Flower storage sire = flowers[_sireId];
800         require(_isReadyToAction(sire));
801 
802         require(_isValidPair(matron, _matronId, sire, _sireId));
803 
804         _born(_matronId, _sireId);
805 
806         gen0SellerAddress.transfer(autoBirthFee);
807 
808         emit Money(msg.sender, "BirthFee-own", autoBirthFee, autoBirthFee, _sireId, block.number);
809     }
810 }
811 
812 // Handles creating auctions for sale and siring
813 contract FlowerAuction is FlowerBreeding {
814 
815     // Set sale auction contract address
816     function setSaleAuctionAddress(address _address) external onlyAdministrator {
817         SaleClockAuction candidateContract = SaleClockAuction(_address);
818         require(candidateContract.isSaleClockAuction());
819         saleAuction = candidateContract;
820     }
821 
822     // Set siring auction contract address
823     function setBreedingAuctionAddress(address _address) external onlyAdministrator {
824         BreedingClockAuction candidateContract = BreedingClockAuction(_address);
825         require(candidateContract.isBreedingClockAuction());
826         breedingAuction = candidateContract;
827     }
828 
829     // Flower sale auction
830     function createSaleAuction(uint256 _flowerId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external whenNotStopped {
831         require(_owns(msg.sender, _flowerId));
832         require(isReadyToAction(_flowerId));
833         _approve(_flowerId, saleAuction);
834         saleAuction.createAuction(_flowerId, _startingPrice, _endingPrice, _duration, msg.sender, 0);
835     }
836 
837     // Create siring auction
838     function createBreedingAuction(uint256 _flowerId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external whenNotStopped {
839         require(_owns(msg.sender, _flowerId));
840         require(isReadyToAction(_flowerId));
841         _approve(_flowerId, breedingAuction);
842         breedingAuction.createAuction(_flowerId, _startingPrice, _endingPrice, _duration, msg.sender, 0);
843     }
844 
845     // Siring auction complete
846     function bidOnBreedingAuction(uint256 _sireId, uint256 _matronId) external payable whenNotStopped {
847         require(_owns(msg.sender, _matronId));
848         require(isReadyToAction(_matronId));
849         require(isReadyToAction(_sireId));
850         require(_canBreedWith(_matronId, _sireId));
851 
852         uint256 currentPrice = breedingAuction.getCurrentPrice(_sireId);
853         require(msg.value >= currentPrice + autoBirthFee);
854 
855         // Siring auction will throw if the bid fails.
856         breedingAuction.bid.value(msg.value - autoBirthFee)(_sireId, msg.sender);
857         _born(uint32(_matronId), uint32(_sireId));
858         gen0SellerAddress.transfer(autoBirthFee);
859         emit Money(msg.sender, "BirthFee-bid", autoBirthFee, autoBirthFee, _sireId, block.number);
860     }
861 
862     // Transfers the balance of the sale auction contract to the Core contract
863     function withdrawAuctionBalances() external onlyAdministrator {
864         saleAuction.withdrawBalance();
865         breedingAuction.withdrawBalance();
866     }
867 
868     function sendGift(uint256 _flowerId, address _to) external payable whenNotStopped {
869         require(_owns(msg.sender, _flowerId));
870         require(isReadyToAction(_flowerId));
871 
872         _transfer(msg.sender, _to, _flowerId);
873     }
874 }
875 
876 contract FlowerMinting is FlowerAuction {
877     // Limits the number of flowers the contract owner can ever create
878     uint256 public constant PROMO_CREATION_LIMIT = 5000;
879     uint256 public constant GEN0_CREATION_LIMIT = 45000;
880     // Constants for gen0 auctions.
881     uint256 public constant GEN0_STARTING_PRICE = 10 finney;
882     uint256 public constant GEN0_AUCTION_DURATION = 1 days;
883     // Counts the number of cats the contract owner has created
884     uint256 public promoCreatedCount;
885     uint256 public gen0CreatedCount;
886 
887     // Create promo flower
888     function createPromoFlower(uint256 _genes, address _owner) external onlyAdministrator {
889         address flowerOwner = _owner;
890         if (flowerOwner == address(0)) {
891             flowerOwner = adminAddress;
892         }
893         require(promoCreatedCount < PROMO_CREATION_LIMIT);
894         promoCreatedCount++;
895         gen0CreatedCount++;
896         _createFlower(0, 0, 0, _genes, flowerOwner);
897     }
898 
899     function createGen0Auction(uint256 _genes, uint64 _auctionStartAt) external onlyAdministrator {
900         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
901         uint256 flowerId = _createFlower(0, 0, 0, _genes, address(gen0SellerAddress));
902         _approve(flowerId, saleAuction);
903 
904         gen0CreatedCount++;
905 
906         saleAuction.createAuction(flowerId, _computeNextGen0Price(), 0, GEN0_AUCTION_DURATION, address(gen0SellerAddress), _auctionStartAt);
907     }
908 
909     // Computes the next gen0 auction starting price, given the average of the past 5 prices + 50%.
910     function _computeNextGen0Price() internal view returns (uint256) {
911         uint256 avePrice = saleAuction.averageGen0SalePrice();
912 
913         // Sanity check to ensure we don't overflow arithmetic
914         require(avePrice == uint256(uint128(avePrice)));
915 
916         uint256 nextPrice = avePrice + (avePrice / 2);
917 
918         // We never auction for less than starting price
919         if (nextPrice < GEN0_STARTING_PRICE) {
920             nextPrice = GEN0_STARTING_PRICE;
921         }
922 
923         return nextPrice;
924     }
925 }
926 
927 contract FlowerCore is FlowerMinting {
928     // Set in case the core contract is broken and an upgrade is required
929     address public newContractAddress;
930 
931     function setGen0SellerAddress(address _newAddress) external onlyAdministrator {
932         gen0SellerAddress = _newAddress;
933         saleAuction.setGen0SellerAddress(_newAddress);
934     }
935 
936     constructor() public {
937         stopped = true;
938         rootAddress = msg.sender;
939         adminAddress = msg.sender;
940         _createFlower(0, 0, 0, uint256(-1), address(0));
941     }
942 
943     // Set new contract address
944     function setNewAddress(address _v2Address) external onlyAdministrator whenStopped {
945         newContractAddress = _v2Address;
946         emit ContractUpgrade(_v2Address);
947     }
948 
949     // Get flower information
950     function getFlower(uint256 _id) external view returns (bool isReady, uint256 cooldownIndex, uint256 nextActionAt, uint256 birthTime, uint256 matronId, uint256 sireId, uint256 generation, uint256 genes) {
951         Flower storage flower = flowers[_id];
952         isReady = (flower.cooldownEndBlock <= block.number);
953         cooldownIndex = uint256(flower.cooldownIndex);
954         nextActionAt = uint256(flower.cooldownEndBlock);
955         birthTime = uint256(flower.birthTime);
956         matronId = uint256(flower.matronId);
957         sireId = uint256(flower.sireId);
958         generation = uint256(flower.generation);
959         genes = flower.genes;
960     }
961 
962     // Start the game
963     function unstop() public onlyAdministrator whenStopped {
964         require(geneScience != address(0));
965         require(newContractAddress == address(0));
966 
967         super.setStart();
968     }
969 
970     // Allows admin to capture the balance available to the contract
971     function withdrawBalance() external onlyAdministrator {
972         uint256 balance = address(this).balance;
973         //        uint256 subtractFees = 3 * autoBirthFee;
974 
975         if (balance > 0) {
976             //            rootAddress.transfer(balance - subtractFees);
977             rootAddress.transfer(balance);
978         }
979     }
980 
981     // TMP
982     function getContractBalance() external view returns (uint256) {
983         return address(this).balance;
984     }
985 }