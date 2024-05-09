1 pragma solidity ^0.4.19;
2 
3 /**
4  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  * license: MIT
8  */
9 contract OwnableSimple {
10     address public owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     function OwnableSimple() public {
19         owner = msg.sender;
20     }
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) public onlyOwner {
35         require(newOwner != address(0));
36         OwnershipTransferred(owner, newOwner);
37         owner = newOwner;
38     }
39 }
40 
41 // based on axiomzen, MIT license
42 contract RandomApi {
43     uint64 _seed = 0;
44 
45     function random(uint64 maxExclusive) public returns (uint64 randomNumber) {
46         // the blockhash of the current block (and future block) is 0 because it doesn't exist
47         _seed = uint64(keccak256(keccak256(block.blockhash(block.number - 1), _seed), block.timestamp));
48         return _seed % maxExclusive;
49     }
50 
51     function random256() public returns (uint256 randomNumber) {
52         uint256 rand = uint256(keccak256(keccak256(block.blockhash(block.number - 1), _seed), block.timestamp));
53         _seed = uint64(rand);
54         return rand;
55     }
56 }
57 
58 // @title ERC-165: Standard interface detection
59 // https://github.com/ethereum/EIPs/issues/165
60 contract ERC165 {
61     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
62 }
63 
64 // @title ERC-721: Non-Fungible Tokens
65 // @author Dieter Shirley (https://github.com/dete)
66 // @dev https://github.com/ethereum/eips/issues/721
67 contract ERC721 is ERC165 {
68     // Required methods
69     function totalSupply() public view returns (uint256 total);
70     function balanceOf(address _owner) public view returns (uint256 count);
71     function ownerOf(uint256 _tokenId) external view returns (address owner);
72     function approve(address _to, uint256 _tokenId) external;
73     function transfer(address _to, uint256 _tokenId) external;
74     function transferFrom(address _from, address _to, uint256 _tokenId) external;
75     
76     // described in old version of the standard
77     // use the more flexible transferFrom
78     function takeOwnership(uint256 _tokenId) external;
79 
80     // Events
81     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
82     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
83 
84     // Optional
85     // function name() public view returns (string);
86     // function symbol() public view returns (string);
87     function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
88     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl);
89     
90     // Optional, described in old version of the standard
91     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
92     function tokenMetadata(uint256 _tokenId) external view returns (string infoUrl);
93 }
94 
95 // Based on strings library by Nick Johnson <arachnid@notdot.net>
96 // Apache license
97 // https://github.com/Arachnid/solidity-stringutils
98 library strings {
99     struct slice {
100         uint _len;
101         uint _ptr;
102     }
103     
104     function memcpy(uint dest, uint src, uint len) private pure {
105         // Copy word-length chunks while possible
106         for(; len >= 32; len -= 32) {
107             assembly {
108                 mstore(dest, mload(src))
109             }
110             dest += 32;
111             src += 32;
112         }
113 
114         // Copy remaining bytes
115         uint mask = 256 ** (32 - len) - 1;
116         assembly {
117             let srcpart := and(mload(src), not(mask))
118             let destpart := and(mload(dest), mask)
119             mstore(dest, or(destpart, srcpart))
120         }
121     }
122     
123     function toSlice(string self) internal pure returns (slice) {
124         uint ptr;
125         assembly {
126             ptr := add(self, 0x20)
127         }
128         return slice(bytes(self).length, ptr);
129     }
130     
131     function toString(slice self) internal pure returns (string) {
132         var ret = new string(self._len);
133         uint retptr;
134         assembly { retptr := add(ret, 32) }
135 
136         memcpy(retptr, self._ptr, self._len);
137         return ret;
138     }
139     
140     function len(slice self) internal pure returns (uint l) {
141         // Starting at ptr-31 means the LSB will be the byte we care about
142         var ptr = self._ptr - 31;
143         var end = ptr + self._len;
144         for (l = 0; ptr < end; l++) {
145             uint8 b;
146             assembly { b := and(mload(ptr), 0xFF) }
147             if (b < 0x80) {
148                 ptr += 1;
149             } else if(b < 0xE0) {
150                 ptr += 2;
151             } else if(b < 0xF0) {
152                 ptr += 3;
153             } else if(b < 0xF8) {
154                 ptr += 4;
155             } else if(b < 0xFC) {
156                 ptr += 5;
157             } else {
158                 ptr += 6;
159             }
160         }
161     }
162     
163     function len(bytes32 self) internal pure returns (uint) {
164         uint ret;
165         if (self == 0)
166             return 0;
167         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
168             ret += 16;
169             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
170         }
171         if (self & 0xffffffffffffffff == 0) {
172             ret += 8;
173             self = bytes32(uint(self) / 0x10000000000000000);
174         }
175         if (self & 0xffffffff == 0) {
176             ret += 4;
177             self = bytes32(uint(self) / 0x100000000);
178         }
179         if (self & 0xffff == 0) {
180             ret += 2;
181             self = bytes32(uint(self) / 0x10000);
182         }
183         if (self & 0xff == 0) {
184             ret += 1;
185         }
186         return 32 - ret;
187     }
188     
189     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
190         assembly {
191             let ptr := mload(0x40)
192             mstore(0x40, add(ptr, 0x20))
193             mstore(ptr, self)
194             mstore(add(ret, 0x20), ptr)
195         }
196         ret._len = len(self);
197     }
198     
199     function concat(slice self, slice other) internal pure returns (string) {
200         var ret = new string(self._len + other._len);
201         uint retptr;
202         assembly { retptr := add(ret, 32) }
203         memcpy(retptr, self._ptr, self._len);
204         memcpy(retptr + self._len, other._ptr, other._len);
205         return ret;
206     }
207 }
208 
209 /**
210  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
211  * @title Pausable
212  * @dev Base contract which allows children to implement an emergency stop mechanism.
213  */
214 contract PausableSimple is OwnableSimple {
215     event Pause();
216     event Unpause();
217 
218     bool public paused = true;
219 
220     /**
221      * @dev Modifier to make a function callable only when the contract is not paused.
222      */
223     modifier whenNotPaused() {
224         require(!paused);
225         _;
226     }
227 
228     /**
229      * @dev Modifier to make a function callable only when the contract is paused.
230      */
231     modifier whenPaused() {
232         require(paused);
233         _;
234     }
235 
236     /**
237      * @dev called by the owner to pause, triggers stopped state
238      */
239     function pause() onlyOwner whenNotPaused public {
240         paused = true;
241         Pause();
242     }
243 
244     /**
245      * @dev called by the owner to unpause, returns to normal state
246      */
247     function unpause() onlyOwner whenPaused public {
248         paused = false;
249         Unpause();
250     }
251 }
252 
253 // heavily modified from https://github.com/dob/auctionhouse/blob/master/contracts/AuctionHouse.sol
254 // license: MIT
255 // original author: Doug Petkanics (petkanics@gmail.com) https://github.com/dob
256 contract PresaleMarket is PausableSimple {
257     struct Auction {
258         address seller;
259         uint256 price;           // In wei, can be 0
260     }
261 
262     ERC721 public artworkContract;
263     mapping (uint256 => Auction) artworkIdToAuction;
264 
265     //      0 means everything goes to the seller
266     //   1000 means 1%
267     //   2500 means 2.5%
268     //   4000 means 4%
269     //  50000 means 50%
270     // 100000 means everything goes to us
271     uint256 public distributionCut = 2500;
272     bool public constant isPresaleMarket = true;
273 
274     event AuctionCreated(uint256 _artworkId, uint256 _price);
275     event AuctionConcluded(uint256 _artworkId, uint256 _price, address _buyer);
276     event AuctionCancelled(uint256 _artworkId);
277 
278     // mapping(address => uint256[]) public auctionsRunByUser;
279     // No need to have a dedicated variable
280     // Can be found by
281     //  iterate all artwork ids owned by this auction contract
282     //    get the auction object from artworkIdToAuction
283     //      get the seller property
284     //        return artwork id
285     // however it would be a lot better if our second layer keeps track of it
286     function auctionsRunByUser(address _address) external view returns(uint256[]) {
287         uint256 allArtworkCount = artworkContract.balanceOf(this);
288 
289         uint256 artworkCount = 0;
290         uint256[] memory allArtworkIds = new uint256[](allArtworkCount);
291         for(uint256 i = 0; i < allArtworkCount; i++) {
292             uint256 artworkId = artworkContract.tokenOfOwnerByIndex(this, i);
293             Auction storage auction = artworkIdToAuction[artworkId];
294             if(auction.seller == _address) {
295                 allArtworkIds[artworkCount++] = artworkId;
296             }
297         }
298 
299         uint256[] memory result = new uint256[](artworkCount);
300         for(i = 0; i < artworkCount; i++) {
301             result[i] = allArtworkIds[i];
302         }
303 
304         return result;
305     }
306 
307     // constructor. rename this if you rename the contract
308     function PresaleMarket(address _artworkContract) public {
309         artworkContract = ERC721(_artworkContract);
310     }
311 
312     function bid(uint256 _artworkId) external payable whenNotPaused {
313         require(_isAuctionExist(_artworkId));
314         Auction storage auction = artworkIdToAuction[_artworkId];
315         require(auction.seller != msg.sender);
316         uint256 price = auction.price;
317         require(msg.value == price);
318 
319         address seller = auction.seller;
320         delete artworkIdToAuction[_artworkId];
321 
322         if(price > 0) {
323             uint256 myCut =  price * distributionCut / 100000;
324             uint256 sellerCut = price - myCut;
325             seller.transfer(sellerCut);
326         }
327 
328         AuctionConcluded(_artworkId, price, msg.sender);
329         artworkContract.transfer(msg.sender, _artworkId);
330     }
331 
332     function getAuction(uint256 _artworkId) external view returns(address seller, uint256 price) {
333         require(_isAuctionExist(_artworkId));
334         Auction storage auction = artworkIdToAuction[_artworkId];
335         return (auction.seller, auction.price);
336     }
337 
338     function createAuction(uint256 _artworkId, uint256 _price, address _originalOwner) external whenNotPaused {
339         require(msg.sender == address(artworkContract));
340 
341         // Will check to see if the seller owns the asset at the contract
342         _takeOwnership(_originalOwner, _artworkId);
343 
344         Auction memory auction;
345 
346         auction.seller = _originalOwner;
347         auction.price = _price;
348 
349         _createAuction(_artworkId, auction);
350     }
351 
352     function _createAuction(uint256 _artworkId, Auction _auction) internal {
353         artworkIdToAuction[_artworkId] = _auction;
354         AuctionCreated(_artworkId, _auction.price);
355     }
356 
357     function cancelAuction(uint256 _artworkId) external {
358         require(_isAuctionExist(_artworkId));
359         Auction storage auction = artworkIdToAuction[_artworkId];
360         address seller = auction.seller;
361         require(msg.sender == seller);
362         _cancelAuction(_artworkId, seller);
363     }
364 
365     function _cancelAuction(uint256 _artworkId, address _owner) internal {
366         delete artworkIdToAuction[_artworkId];
367         artworkContract.transfer(_owner, _artworkId);
368         AuctionCancelled(_artworkId);
369     }
370 
371     function withdraw() public onlyOwner {
372         msg.sender.transfer(this.balance);
373     }
374 
375     // only if there is a bug discovered and we need to migrate to a new market contract
376     function cancelAuctionEmergency(uint256 _artworkId) external whenPaused onlyOwner {
377         require(_isAuctionExist(_artworkId));
378         Auction storage auction = artworkIdToAuction[_artworkId];
379         _cancelAuction(_artworkId, auction.seller);
380     }
381 
382     // simple methods
383 
384     function _isAuctionExist(uint256 _artworkId) internal view returns(bool) {
385         return artworkIdToAuction[_artworkId].seller != address(0);
386     }
387 
388     function _owns(address _address, uint256 _artworkId) internal view returns(bool) {
389         return artworkContract.ownerOf(_artworkId) == _address;
390     }
391 
392     function _takeOwnership(address _originalOwner, uint256 _artworkId) internal {
393         artworkContract.transferFrom(_originalOwner, this, _artworkId);
394     }
395 }
396 
397 contract Presale is OwnableSimple, RandomApi, ERC721 {
398     using strings for *;
399 
400     // There are 4 batches available for presale.
401     // A batch is a set of artworks and
402     // we plan to release batches monthly.
403     uint256 public batchCount;
404     mapping(uint256 => uint256) public prices;
405     mapping(uint256 => uint256) public supplies;
406     mapping(uint256 => uint256) public sold;
407 
408     // Before each batch is released on the main contract,
409     // we will disable transfers (including trading)
410     // on this contract.
411     // This is to prevent someone selling an artwork
412     // on the presale contract when we are migrating
413     // the artworks to the main contract.
414     mapping(uint256 => bool) public isTransferDisabled;
415 
416     uint256[] public dnas;
417     mapping(address => uint256) public ownerToTokenCount;
418     mapping (uint256 => address) public artworkIdToOwner;
419     mapping (uint256 => address) public artworkIdToTransferApproved;
420 
421     PresaleMarket public presaleMarket;
422 
423     bytes4 constant ERC165Signature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
424 
425     // Latest version of ERC721 perhaps
426     bytes4 constant ERC165Signature_ERC721A =
427     bytes4(keccak256('totalSupply()')) ^
428     bytes4(keccak256('balanceOf(address)')) ^
429     bytes4(keccak256('ownerOf(uint256)')) ^
430     bytes4(keccak256('approve(address,uint256)')) ^
431     bytes4(keccak256('transfer(address,uint256)')) ^
432     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
433     bytes4(keccak256('name()')) ^
434     bytes4(keccak256('symbol()')) ^
435     bytes4(keccak256('tokensOfOwner(address)')) ^
436     bytes4(keccak256('tokenMetadata(uint256,string)'));
437 
438     // as described in https://github.com/ethereum/eips/issues/721
439     // as of January 23, 2018
440     bytes4 constant ERC165Signature_ERC721B =
441     bytes4(keccak256('name()')) ^
442     bytes4(keccak256('symbol()')) ^
443     bytes4(keccak256('totalSupply()')) ^
444     bytes4(keccak256('balanceOf(address)')) ^
445     bytes4(keccak256('ownerOf(uint256)')) ^
446     bytes4(keccak256('approve(address,uint256)')) ^
447     bytes4(keccak256('takeOwnership(uint256)')) ^
448     bytes4(keccak256('transfer(address,uint256)')) ^
449     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
450     bytes4(keccak256('tokenMetadata(uint256)'));
451 
452     function Presale() public {
453         // Artworks are released in batches, which we plan to release
454         // every month if possible. New batches might contain new characters,
455         // or old characters in new poses. Later batches will definitely be
456         // more rare.
457 
458         // By buying at presale, you have a chance to buy the
459         // artwork at potentially 50% of the public release initial sales price.
460         // Note that because the public release uses a sliding price system,
461         // once an artwork is in the marketplace, the price will get lower until
462         // someone buys it.
463 
464         // Example: You bought a batch 1 artwork at presale for 0.05 eth.
465         // When the game launches, the first batch 1 artworks are generated
466         // on the marketplace with the initial price of 0.1 eth. You sell yours
467         // on the marketplace for 0.08 eth which is lower than the public release
468         // initial sales price. If someone buys your artwork, you will get profit.
469 
470         // Note that we do not guarantee any profit whatsoever. The price of an
471         // item we sell will get cheaper until someone buys it. So other people might wait
472         // for the public release artworks to get cheaper and buy it instead of
473         // buying yours.
474 
475         // Distribution of presale artworks:
476         // When the game is released, all batch 1 presale artworks
477         // will be immediately available for trading.
478 
479         // When other batches are released, first we will generate 10 artworks
480         // on the marketplace. After that we will distribute the presale
481         // artworks with the rate of around 10 every minute.
482         // Note that because of mining uncertainties we cannot guarantee any
483         // specific timings.
484 
485         // public release initial sales price >= 0.1 ether
486         _addPresale(0.05 ether, 450);
487 
488         // public release initial sales price >= 0.24 ether
489         _addPresale(0.12 ether, 325);
490 
491         // public release initial sales price >= 0.7 ether
492         _addPresale(0.35 ether, 150);
493 
494         // public release initial sales price >= 2.0 ether
495         _addPresale(1.0 ether, 75);
496     }
497 
498     function buy(uint256 _batch) public payable {
499         require(_batch < batchCount);
500         require(msg.value == prices[_batch]); // we don't want to deal with refunds
501         require(sold[_batch] < supplies[_batch]);
502 
503         sold[_batch]++;
504         uint256 dna = _generateRandomDna(_batch);
505 
506         uint256 artworkId = dnas.push(dna) - 1;
507         ownerToTokenCount[msg.sender]++;
508         artworkIdToOwner[artworkId] = msg.sender;
509 
510         Transfer(0, msg.sender, artworkId);
511     }
512 
513     function getArtworkInfo(uint256 _id) external view returns (
514         uint256 dna, address owner) {
515         require(_id < totalSupply());
516 
517         dna = dnas[_id];
518         owner = artworkIdToOwner[_id];
519     }
520 
521     function withdraw() public onlyOwner {
522         msg.sender.transfer(this.balance);
523     }
524 
525     function getBatchInfo(uint256 _batch) external view returns(uint256 price, uint256 supply, uint256 soldAmount) {
526         require(_batch < batchCount);
527 
528         return (prices[_batch], supplies[_batch], sold[_batch]);
529     }
530 
531     function setTransferDisabled(uint256 _batch, bool _isDisabled) external onlyOwner {
532         require(_batch < batchCount);
533 
534         isTransferDisabled[_batch] = _isDisabled;
535     }
536 
537     function setPresaleMarketAddress(address _address) public onlyOwner {
538         PresaleMarket presaleMarketTest = PresaleMarket(_address);
539         require(presaleMarketTest.isPresaleMarket());
540         presaleMarket = presaleMarketTest;
541     }
542 
543     function sell(uint256 _artworkId, uint256 _price) external {
544         require(_isOwnerOf(msg.sender, _artworkId));
545         require(_canTransferBatch(_artworkId));
546         _approveTransfer(_artworkId, presaleMarket);
547         presaleMarket.createAuction(_artworkId, _price, msg.sender);
548     }
549 
550     // Helper methods
551 
552     function _addPresale(uint256 _price, uint256 _supply) private {
553         prices[batchCount] = _price;
554         supplies[batchCount] = _supply;
555 
556         batchCount++;
557     }
558 
559     function _generateRandomDna(uint256 _batch) private returns(uint256 dna) {
560         uint256 rand = random256() % (10 ** 76);
561 
562         // set batch digits
563         rand = rand / 100000000 * 100000000 + _batch;
564 
565         return rand;
566     }
567 
568     function _isOwnerOf(address _address, uint256 _tokenId) private view returns (bool) {
569         return artworkIdToOwner[_tokenId] == _address;
570     }
571 
572     function _approveTransfer(uint256 _tokenId, address _address) internal {
573         artworkIdToTransferApproved[_tokenId] = _address;
574     }
575 
576     function _transfer(address _from, address _to, uint256 _tokenId) internal {
577         artworkIdToOwner[_tokenId] = _to;
578         ownerToTokenCount[_to]++;
579 
580         ownerToTokenCount[_from]--;
581         delete artworkIdToTransferApproved[_tokenId];
582 
583         Transfer(_from, _to, _tokenId);
584     }
585 
586     function _approvedForTransfer(address _address, uint256 _tokenId) internal view returns (bool) {
587         return artworkIdToTransferApproved[_tokenId] == _address;
588     }
589 
590     function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
591         require(_isOwnerOf(_from, _tokenId));
592         require(_approvedForTransfer(msg.sender, _tokenId));
593 
594         // prevent accidental transfer
595         require(_to != address(0));
596         require(_to != address(this));
597 
598         // perform the transfer and emit Transfer event
599         _transfer(_from, _to, _tokenId);
600     }
601 
602     function _canTransferBatch(uint256 _tokenId) internal view returns(bool) {
603         uint256 batch = dnas[_tokenId] % 10;
604         return !isTransferDisabled[batch];
605     }
606 
607     function _tokenMetadata(uint256 _tokenId, string _preferredTransport) internal view returns (string infoUrl) {
608         _preferredTransport; // we don't use this parameter
609 
610         require(_tokenId < totalSupply());
611 
612         strings.slice memory tokenIdSlice = _uintToBytes(_tokenId).toSliceB32();
613         return "/http/etherwaifu.com/presale/artwork/".toSlice().concat(tokenIdSlice);
614     }
615 
616     // Author: pipermerriam
617     // MIT license
618     // https://github.com/pipermerriam/ethereum-string-utils
619     function _uintToBytes(uint256 v) internal pure returns(bytes32 ret) {
620         if (v == 0) {
621             ret = '0';
622         }
623         else {
624             while (v > 0) {
625                 ret = bytes32(uint256(ret) / (2 ** 8));
626                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
627                 v /= 10;
628             }
629         }
630         return ret;
631     }
632 
633     // Required methods of ERC721
634 
635     function totalSupply() public view returns (uint256) {
636         return dnas.length;
637     }
638 
639     function balanceOf(address _owner) public view returns (uint256) {
640         return ownerToTokenCount[_owner];
641     }
642 
643     function ownerOf(uint256 _tokenId) external view returns (address) {
644         address theOwner = artworkIdToOwner[_tokenId];
645         require(theOwner != address(0));
646         return theOwner;
647     }
648 
649     function approve(address _to, uint256 _tokenId) external {
650         require(_canTransferBatch(_tokenId));
651 
652         require(_isOwnerOf(msg.sender, _tokenId));
653 
654         // MUST throw if _tokenID does not represent an NFT
655         // but if it is not NFT, owner is address(0)
656         // which means it is impossible because msg.sender is a nonzero address
657 
658         require(msg.sender != _to);
659 
660         address prevApprovedAddress = artworkIdToTransferApproved[_tokenId];
661         _approveTransfer(_tokenId, _to);
662 
663         // Don't send Approval event if it is just
664         // reaffirming that there is no one approved
665         if(!(prevApprovedAddress == address(0) && _to == address(0))) {
666             Approval(msg.sender, _to, _tokenId);
667         }
668     }
669 
670     function transfer(address _to, uint256 _tokenId) external {
671         require(_canTransferBatch(_tokenId));
672         require(_isOwnerOf(msg.sender, _tokenId));
673 
674         // prevent accidental transfers
675         require(_to != address(0));
676         require(_to != address(this));
677         require(_to != address(presaleMarket));
678 
679         // perform the transfer and emit Transfer event
680         _transfer(msg.sender, _to, _tokenId);
681     }
682 
683     function transferFrom(address _from, address _to, uint256 _tokenId) external {
684         require(_canTransferBatch(_tokenId));
685         _transferFrom(_from, _to, _tokenId);
686     }
687 
688     function takeOwnership(uint256 _tokenId) external {
689         require(_canTransferBatch(_tokenId));
690         address owner = artworkIdToOwner[_tokenId];
691         _transferFrom(owner, msg.sender, _tokenId);
692     }
693 
694     // Optional methods of ERC721
695 
696     function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds) {
697         uint256 count = balanceOf(_owner);
698 
699         uint256[] memory res = new uint256[](count);
700         uint256 allArtworkCount = totalSupply();
701         uint256 i = 0;
702 
703         for(uint256 artworkId = 1; artworkId <= allArtworkCount && i < count; artworkId++) {
704             if(artworkIdToOwner[artworkId] == _owner) {
705                 res[i++] = artworkId;
706             }
707         }
708 
709         return res;
710     }
711 
712     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
713         return _tokenMetadata(_tokenId, _preferredTransport);
714     }
715 
716     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId) {
717         require(_index < balanceOf(_owner));
718 
719         // not strictly needed because if the state is consistent then
720         // a match will be found
721         uint256 allArtworkCount = totalSupply();
722 
723         uint256 i = 0;
724         for(uint256 artworkId = 0; artworkId < allArtworkCount; artworkId++) {
725             if(artworkIdToOwner[artworkId] == _owner) {
726                 if(i == _index) {
727                     return artworkId;
728                 } else {
729                     i++;
730                 }
731             }
732         }
733         assert(false); // should never reach here
734     }
735 
736     function tokenMetadata(uint256 _tokenId) external view returns (string infoUrl) {
737         return _tokenMetadata(_tokenId, "http");
738     }
739 
740     // ERC-165 Standard interface detection (required)
741 
742     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
743     {
744         return _interfaceID == ERC165Signature_ERC165 ||
745         _interfaceID == ERC165Signature_ERC721A ||
746         _interfaceID == ERC165Signature_ERC721B;
747     }
748 }