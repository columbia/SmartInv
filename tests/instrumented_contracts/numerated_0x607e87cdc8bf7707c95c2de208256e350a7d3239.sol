1 pragma solidity ^0.4.21;
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
20     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
21 
22     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
23     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
24 }
25 
26 contract Ownable {
27     address public owner;
28 
29     event OwnershipTransferred(address previousOwner, address newOwner);
30 
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract StorageBase is Ownable {
48 
49     function withdrawBalance() external onlyOwner returns (bool) {
50         // The owner has a method to withdraw balance from multiple contracts together,
51         // use send here to make sure even if one withdrawBalance fails the others will still work
52         bool res = msg.sender.send(address(this).balance);
53         return res;
54     }
55 }
56 
57 contract ClockAuctionStorage is StorageBase {
58 
59     // Represents an auction on an NFT
60     struct Auction {
61         // Current owner of NFT
62         address seller;
63         // Price (in wei) at beginning of auction
64         uint128 startingPrice;
65         // Price (in wei) at end of auction
66         uint128 endingPrice;
67         // Duration (in seconds) of auction
68         uint64 duration;
69         // Time when auction started
70         // NOTE: 0 if this auction has been concluded
71         uint64 startedAt;
72     }
73 
74     // Map from token ID to their corresponding auction.
75     mapping (uint256 => Auction) tokenIdToAuction;
76 
77     function addAuction(
78         uint256 _tokenId,
79         address _seller,
80         uint128 _startingPrice,
81         uint128 _endingPrice,
82         uint64 _duration,
83         uint64 _startedAt
84     )
85         external
86         onlyOwner
87     {
88         tokenIdToAuction[_tokenId] = Auction(
89             _seller,
90             _startingPrice,
91             _endingPrice,
92             _duration,
93             _startedAt
94         );
95     }
96 
97     function removeAuction(uint256 _tokenId) public onlyOwner {
98         delete tokenIdToAuction[_tokenId];
99     }
100 
101     function getAuction(uint256 _tokenId)
102         external
103         view
104         returns (
105             address seller,
106             uint128 startingPrice,
107             uint128 endingPrice,
108             uint64 duration,
109             uint64 startedAt
110         )
111     {
112         Auction storage auction = tokenIdToAuction[_tokenId];
113         return (
114             auction.seller,
115             auction.startingPrice,
116             auction.endingPrice,
117             auction.duration,
118             auction.startedAt
119         );
120     }
121 
122     function isOnAuction(uint256 _tokenId) external view returns (bool) {
123         return (tokenIdToAuction[_tokenId].startedAt > 0);
124     }
125 
126     function getSeller(uint256 _tokenId) external view returns (address) {
127         return tokenIdToAuction[_tokenId].seller;
128     }
129 
130     function transfer(ERC721 _nonFungibleContract, address _receiver, uint256 _tokenId) external onlyOwner {
131         // it will throw if transfer fails
132         _nonFungibleContract.transfer(_receiver, _tokenId);
133     }
134 }
135 
136 contract SaleClockAuctionStorage is ClockAuctionStorage {
137     bool public isSaleClockAuctionStorage = true;
138 
139     // total accumulate sold count
140     uint256 public totalSoldCount;
141 
142     // last 3 sale price
143     uint256[3] public lastSoldPrices;
144 
145     // current on sale auction count from system
146     uint256 public systemOnSaleCount;
147 
148     // map of on sale token ids from system
149     mapping (uint256 => bool) systemOnSaleTokens;
150 
151     function removeAuction(uint256 _tokenId) public onlyOwner {
152         // first remove auction from state variable
153         super.removeAuction(_tokenId);
154 
155         // update system on sale record
156         if (systemOnSaleTokens[_tokenId]) {
157             delete systemOnSaleTokens[_tokenId];
158             
159             if (systemOnSaleCount > 0) {
160                 systemOnSaleCount--;
161             }
162         }
163     }
164 
165     function recordSystemOnSaleToken(uint256 _tokenId) external onlyOwner {
166         if (!systemOnSaleTokens[_tokenId]) {
167             systemOnSaleTokens[_tokenId] = true;
168             systemOnSaleCount++;
169         }
170     }
171 
172     function recordSoldPrice(uint256 _price) external onlyOwner {
173         lastSoldPrices[totalSoldCount % 3] = _price;
174         totalSoldCount++;
175     }
176 
177     function averageSoldPrice() external view returns (uint256) {
178         if (totalSoldCount == 0) return 0;
179         
180         uint256 sum = 0;
181         uint256 len = (totalSoldCount < 3 ? totalSoldCount : 3);
182         for (uint256 i = 0; i < len; i++) {
183             sum += lastSoldPrices[i];
184         }
185         return sum / len;
186     }
187 }
188 
189 contract Pausable is Ownable {
190     event Pause();
191     event Unpause();
192 
193     bool public paused = false;
194 
195     modifier whenNotPaused() {
196         require(!paused);
197         _;
198     }
199 
200     modifier whenPaused {
201         require(paused);
202         _;
203     }
204 
205     function pause() public onlyOwner whenNotPaused {
206         paused = true;
207         emit Pause();
208     }
209 
210     function unpause() public onlyOwner whenPaused {
211         paused = false;
212         emit Unpause();
213     }
214 }
215 
216 contract HasNoContracts is Pausable {
217 
218     function reclaimContract(address _contractAddr) external onlyOwner whenPaused {
219         Ownable contractInst = Ownable(_contractAddr);
220         contractInst.transferOwnership(owner);
221     }
222 }
223 
224 contract LogicBase is HasNoContracts {
225 
226     /// The ERC-165 interface signature for ERC-721.
227     ///  Ref: https://github.com/ethereum/EIPs/issues/165
228     ///  Ref: https://github.com/ethereum/EIPs/issues/721
229     bytes4 constant InterfaceSignature_NFC = bytes4(0x9f40b779);
230 
231     // Reference to contract tracking NFT ownership
232     ERC721 public nonFungibleContract;
233 
234     // Reference to storage contract
235     StorageBase public storageContract;
236 
237     function LogicBase(address _nftAddress, address _storageAddress) public {
238         // paused by default
239         paused = true;
240 
241         setNFTAddress(_nftAddress);
242 
243         require(_storageAddress != address(0));
244         storageContract = StorageBase(_storageAddress);
245     }
246 
247     // Very dangerous action, only when new contract has been proved working
248     // Requires storageContract already transferOwnership to the new contract
249     // This method is only used to transfer the balance to owner
250     function destroy() external onlyOwner whenPaused {
251         address storageOwner = storageContract.owner();
252         // owner of storageContract must not be the current contract otherwise the storageContract will forever not accessible
253         require(storageOwner != address(this));
254         // Transfers the current balance to the owner and terminates the contract
255         selfdestruct(owner);
256     }
257 
258     // Very dangerous action, only when new contract has been proved working
259     // Requires storageContract already transferOwnership to the new contract
260     // This method is only used to transfer the balance to the new contract
261     function destroyAndSendToStorageOwner() external onlyOwner whenPaused {
262         address storageOwner = storageContract.owner();
263         // owner of storageContract must not be the current contract otherwise the storageContract will forever not accessible
264         require(storageOwner != address(this));
265         // Transfers the current balance to the new owner of the storage contract and terminates the contract
266         selfdestruct(storageOwner);
267     }
268 
269     // override to make sure everything is initialized before the unpause
270     function unpause() public onlyOwner whenPaused {
271         // can not unpause when the logic contract is not initialzed
272         require(nonFungibleContract != address(0));
273         require(storageContract != address(0));
274         // can not unpause when ownership of storage contract is not the current contract
275         require(storageContract.owner() == address(this));
276 
277         super.unpause();
278     }
279 
280     function setNFTAddress(address _nftAddress) public onlyOwner {
281         require(_nftAddress != address(0));
282         ERC721 candidateContract = ERC721(_nftAddress);
283         require(candidateContract.supportsInterface(InterfaceSignature_NFC));
284         nonFungibleContract = candidateContract;
285     }
286 
287     // Withdraw balance to the Core Contract
288     function withdrawBalance() external returns (bool) {
289         address nftAddress = address(nonFungibleContract);
290         // either Owner or Core Contract can trigger the withdraw
291         require(msg.sender == owner || msg.sender == nftAddress);
292         // The owner has a method to withdraw balance from multiple contracts together,
293         // use send here to make sure even if one withdrawBalance fails the others will still work
294         bool res = nftAddress.send(address(this).balance);
295         return res;
296     }
297 
298     function withdrawBalanceFromStorageContract() external returns (bool) {
299         address nftAddress = address(nonFungibleContract);
300         // either Owner or Core Contract can trigger the withdraw
301         require(msg.sender == owner || msg.sender == nftAddress);
302         // The owner has a method to withdraw balance from multiple contracts together,
303         // use send here to make sure even if one withdrawBalance fails the others will still work
304         bool res = storageContract.withdrawBalance();
305         return res;
306     }
307 }
308 
309 contract ClockAuction is LogicBase {
310     
311     // Reference to contract tracking auction state variables
312     ClockAuctionStorage public clockAuctionStorage;
313 
314     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
315     // Values 0-10,000 map to 0%-100%
316     uint256 public ownerCut;
317 
318     // Minimum cut value on each auction (in WEI)
319     uint256 public minCutValue;
320 
321     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
322     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner, address seller, uint256 sellerProceeds);
323     event AuctionCancelled(uint256 tokenId);
324 
325     function ClockAuction(address _nftAddress, address _storageAddress, uint256 _cut, uint256 _minCutValue) 
326         LogicBase(_nftAddress, _storageAddress) public
327     {
328         setOwnerCut(_cut);
329         setMinCutValue(_minCutValue);
330 
331         clockAuctionStorage = ClockAuctionStorage(_storageAddress);
332     }
333 
334     function setOwnerCut(uint256 _cut) public onlyOwner {
335         require(_cut <= 10000);
336         ownerCut = _cut;
337     }
338 
339     function setMinCutValue(uint256 _minCutValue) public onlyOwner {
340         minCutValue = _minCutValue;
341     }
342 
343     function getMinPrice() public view returns (uint256) {
344         // return ownerCut > 0 ? (minCutValue / ownerCut * 10000) : 0;
345         // use minCutValue directly, when the price == minCutValue seller will get no profit
346         return minCutValue;
347     }
348 
349     // Only auction from none system user need to verify the price
350     // System auction can set any price
351     function isValidPrice(uint256 _startingPrice, uint256 _endingPrice) public view returns (bool) {
352         return (_startingPrice < _endingPrice ? _startingPrice : _endingPrice) >= getMinPrice();
353     }
354 
355     function createAuction(
356         uint256 _tokenId,
357         uint256 _startingPrice,
358         uint256 _endingPrice,
359         uint256 _duration,
360         address _seller
361     )
362         public
363         whenNotPaused
364     {
365         require(_startingPrice == uint256(uint128(_startingPrice)));
366         require(_endingPrice == uint256(uint128(_endingPrice)));
367         require(_duration == uint256(uint64(_duration)));
368 
369         require(msg.sender == address(nonFungibleContract));
370         
371         // assigning ownership to this clockAuctionStorage when in auction
372         // it will throw if transfer fails
373         nonFungibleContract.transferFrom(_seller, address(clockAuctionStorage), _tokenId);
374 
375         // Require that all auctions have a duration of at least one minute.
376         require(_duration >= 1 minutes);
377 
378         clockAuctionStorage.addAuction(
379             _tokenId,
380             _seller,
381             uint128(_startingPrice),
382             uint128(_endingPrice),
383             uint64(_duration),
384             uint64(now)
385         );
386 
387         emit AuctionCreated(_tokenId, _startingPrice, _endingPrice, _duration);
388     }
389 
390     function cancelAuction(uint256 _tokenId) external {
391         require(clockAuctionStorage.isOnAuction(_tokenId));
392         address seller = clockAuctionStorage.getSeller(_tokenId);
393         require(msg.sender == seller);
394         _cancelAuction(_tokenId, seller);
395     }
396 
397     function cancelAuctionWhenPaused(uint256 _tokenId) external whenPaused onlyOwner {
398         require(clockAuctionStorage.isOnAuction(_tokenId));
399         address seller = clockAuctionStorage.getSeller(_tokenId);
400         _cancelAuction(_tokenId, seller);
401     }
402 
403     function getAuction(uint256 _tokenId)
404         public
405         view
406         returns
407     (
408         address seller,
409         uint256 startingPrice,
410         uint256 endingPrice,
411         uint256 duration,
412         uint256 startedAt
413     ) {
414         require(clockAuctionStorage.isOnAuction(_tokenId));
415         return clockAuctionStorage.getAuction(_tokenId);
416     }
417 
418     function getCurrentPrice(uint256 _tokenId)
419         external
420         view
421         returns (uint256)
422     {
423         require(clockAuctionStorage.isOnAuction(_tokenId));
424         return _currentPrice(_tokenId);
425     }
426 
427     function _cancelAuction(uint256 _tokenId, address _seller) internal {
428         clockAuctionStorage.removeAuction(_tokenId);
429         clockAuctionStorage.transfer(nonFungibleContract, _seller, _tokenId);
430         emit AuctionCancelled(_tokenId);
431     }
432 
433     function _bid(uint256 _tokenId, uint256 _bidAmount, address bidder) internal returns (uint256) {
434 
435         require(clockAuctionStorage.isOnAuction(_tokenId));
436 
437         // Check that the bid is greater than or equal to the current price
438         uint256 price = _currentPrice(_tokenId);
439         require(_bidAmount >= price);
440 
441         address seller = clockAuctionStorage.getSeller(_tokenId);
442         uint256 sellerProceeds = 0;
443 
444         // Remove the auction before sending the fees to the sender so we can't have a reentrancy attack
445         clockAuctionStorage.removeAuction(_tokenId);
446 
447         // Transfer proceeds to seller (if there are any!)
448         if (price > 0) {
449             // Calculate the auctioneer's cut, so this subtraction can't go negative
450             uint256 auctioneerCut = _computeCut(price);
451             sellerProceeds = price - auctioneerCut;
452 
453             // transfer the sellerProceeds
454             seller.transfer(sellerProceeds);
455         }
456 
457         // Calculate any excess funds included with the bid
458         // transfer it back to bidder.
459         // this cannot underflow.
460         uint256 bidExcess = _bidAmount - price;
461         bidder.transfer(bidExcess);
462 
463         emit AuctionSuccessful(_tokenId, price, bidder, seller, sellerProceeds);
464 
465         return price;
466     }
467 
468     function _currentPrice(uint256 _tokenId) internal view returns (uint256) {
469 
470         uint256 secondsPassed = 0;
471 
472         address seller;
473         uint128 startingPrice;
474         uint128 endingPrice;
475         uint64 duration;
476         uint64 startedAt;
477         (seller, startingPrice, endingPrice, duration, startedAt) = clockAuctionStorage.getAuction(_tokenId);
478 
479         if (now > startedAt) {
480             secondsPassed = now - startedAt;
481         }
482 
483         return _computeCurrentPrice(
484             startingPrice,
485             endingPrice,
486             duration,
487             secondsPassed
488         );
489     }
490 
491     function _computeCurrentPrice(
492         uint256 _startingPrice,
493         uint256 _endingPrice,
494         uint256 _duration,
495         uint256 _secondsPassed
496     )
497         internal
498         pure
499         returns (uint256)
500     {
501         if (_secondsPassed >= _duration) {
502             return _endingPrice;
503         } else {
504             // this delta can be negative.
505             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
506 
507             // This multiplication can't overflow, _secondsPassed will easily fit within
508             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
509             // will always fit within 256-bits.
510             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
511 
512             // this result will always end up positive.
513             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
514 
515             return uint256(currentPrice);
516         }
517     }
518 
519     function _computeCut(uint256 _price) internal view returns (uint256) {
520         uint256 cutValue = _price * ownerCut / 10000;
521         if (_price < minCutValue) return cutValue;
522         if (cutValue > minCutValue) return cutValue;
523         return minCutValue;
524     }
525 }
526 
527 contract SaleClockAuction is ClockAuction {
528 
529     bool public isSaleClockAuction = true;
530 
531     address public systemSaleAddress;
532     uint256 public systemStartingPriceMin = 20 finney;
533     uint256 public systemEndingPrice = 0;
534     uint256 public systemAuctionDuration = 1 days;
535 
536     function SaleClockAuction(address _nftAddr, address _storageAddress, address _systemSaleAddress, uint256 _cut, uint256 _minCutValue) 
537         ClockAuction(_nftAddr, _storageAddress, _cut, _minCutValue) public
538     {
539         require(SaleClockAuctionStorage(_storageAddress).isSaleClockAuctionStorage());
540         
541         setSystemSaleAddress(_systemSaleAddress);
542     }
543   
544     function bid(uint256 _tokenId) external payable {
545         uint256 price = _bid(_tokenId, msg.value, msg.sender);
546         
547         clockAuctionStorage.transfer(nonFungibleContract, msg.sender, _tokenId);
548         
549         SaleClockAuctionStorage(clockAuctionStorage).recordSoldPrice(price);
550     }
551 
552     function createSystemAuction(uint256 _tokenId) external {
553         require(msg.sender == address(nonFungibleContract));
554 
555         createAuction(
556             _tokenId,
557             computeNextSystemSalePrice(),
558             systemEndingPrice,
559             systemAuctionDuration,
560             systemSaleAddress
561         );
562 
563         SaleClockAuctionStorage(clockAuctionStorage).recordSystemOnSaleToken(_tokenId);
564     }
565 
566     function setSystemSaleAddress(address _systemSaleAddress) public onlyOwner {
567         require(_systemSaleAddress != address(0));
568         systemSaleAddress = _systemSaleAddress;
569     }
570 
571     function setSystemStartingPriceMin(uint256 _startingPrice) external onlyOwner {
572         require(_startingPrice == uint256(uint128(_startingPrice)));
573         systemStartingPriceMin = _startingPrice;
574     }
575 
576     function setSystemEndingPrice(uint256 _endingPrice) external onlyOwner {
577         require(_endingPrice == uint256(uint128(_endingPrice)));
578         systemEndingPrice = _endingPrice;
579     }
580 
581     function setSystemAuctionDuration(uint256 _duration) external onlyOwner {
582         require(_duration == uint256(uint64(_duration)));
583         systemAuctionDuration = _duration;
584     }
585 
586     function totalSoldCount() external view returns (uint256) {
587         return SaleClockAuctionStorage(clockAuctionStorage).totalSoldCount();
588     }
589 
590     function systemOnSaleCount() external view returns (uint256) {
591         return SaleClockAuctionStorage(clockAuctionStorage).systemOnSaleCount();
592     }
593 
594     function averageSoldPrice() external view returns (uint256) {
595         return SaleClockAuctionStorage(clockAuctionStorage).averageSoldPrice();
596     }
597 
598     function computeNextSystemSalePrice() public view returns (uint256) {
599         uint256 avePrice = SaleClockAuctionStorage(clockAuctionStorage).averageSoldPrice();
600 
601         require(avePrice == uint256(uint128(avePrice)));
602 
603         uint256 nextPrice = avePrice + (avePrice / 2);
604 
605         if (nextPrice < systemStartingPriceMin) {
606             nextPrice = systemStartingPriceMin;
607         }
608 
609         return nextPrice;
610     }
611 }