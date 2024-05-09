1 pragma solidity ^0.4.15;
2 
3 // File: contracts/interfaces/IAuctions.sol
4 
5 contract IAuctions {
6 
7     function currentPrice(uint _tokenId) public constant returns (uint256);
8     function createAuction(
9         uint256 _tokenId,
10         uint256 _startingPrice,
11         uint256 _endingPrice,
12         uint256 _duration) public;
13     function createReleaseAuction(
14         uint _tokenId,
15         uint _startingPrice,
16         uint _endingPrice,
17         uint _startedAt,
18         uint _duration) public;
19     function cancelAuction(uint256 _tokenId) external;
20     function cancelAuctionWhenPaused(uint256 _tokenId) external;
21     function bid(uint256 _tokenId, address _owner) external payable;
22     function market() public constant returns (
23         uint[] tokens,
24         address[] sellers,
25         uint8[] generations,
26         uint8[] speeds,
27         uint[] prices
28     );
29     function auctionsOf(address _of) public constant returns (
30         uint[] tokens,
31         uint[] prices
32     );
33     function signature() external constant returns (uint _signature);
34 }
35 
36 // File: contracts/interfaces/IStorage.sol
37 
38 contract IStorage {
39     function isOwner(address _address) public constant returns (bool);
40 
41     function isAllowed(address _address) external constant returns (bool);
42     function developer() public constant returns (address);
43     function setDeveloper(address _address) public;
44     function addAdmin(address _address) public;
45     function isAdmin(address _address) public constant returns (bool);
46     function removeAdmin(address _address) public;
47     function contracts(uint _signature) public returns (address _address);
48 
49     function exists(uint _tokenId) external constant returns (bool);
50     function paintingsCount() public constant returns (uint);
51     function increaseOwnershipTokenCount(address _address) public;
52     function decreaseOwnershipTokenCount(address _address) public;
53     function setOwnership(uint _tokenId, address _address) public;
54     function getPainting(uint _tokenId)
55         external constant returns (address, uint, uint, uint, uint8, uint8);
56     function createPainting(
57         address _owner,
58         uint _tokenId,
59         uint _parentId,
60         uint8 _generation,
61         uint8 _speed,
62         uint _artistId,
63         uint _releasedAt) public;
64     function approve(uint _tokenId, address _claimant) external;
65     function isApprovedFor(uint _tokenId, address _claimant)
66         external constant returns (bool);
67     function createEditionMeta(uint _tokenId) public;
68     function getPaintingOwner(uint _tokenId)
69         external constant returns (address);
70     function getPaintingGeneration(uint _tokenId)
71         public constant returns (uint8);
72     function getPaintingSpeed(uint _tokenId)
73         external constant returns (uint8);
74     function getPaintingArtistId(uint _tokenId)
75         public constant returns (uint artistId);
76     function getOwnershipTokenCount(address _address)
77         external constant returns (uint);
78     function isReady(uint _tokenId) public constant returns (bool);
79     function getPaintingIdAtIndex(uint _index) public constant returns (uint);
80     function lastEditionOf(uint _index) public constant returns (uint);
81     function getPaintingOriginal(uint _tokenId)
82         external constant returns (uint);
83     function canBeBidden(uint _tokenId) public constant returns (bool _can);
84 
85     function addAuction(
86         uint _tokenId,
87         uint _startingPrice,
88         uint _endingPrice,
89         uint _duration,
90         address _seller) public;
91     function addReleaseAuction(
92         uint _tokenId,
93         uint _startingPrice,
94         uint _endingPrice,
95         uint _startedAt,
96         uint _duration) public;
97     function initAuction(
98         uint _tokenId,
99         uint _startingPrice,
100         uint _endingPrice,
101         uint _startedAt,
102         uint _duration,
103         address _seller,
104         bool _byTeam) public;
105     function _isOnAuction(uint _tokenId) internal constant returns (bool);
106     function isOnAuction(uint _tokenId) external constant returns (bool);
107     function removeAuction(uint _tokenId) public;
108     function getAuction(uint256 _tokenId)
109         external constant returns (
110         address seller,
111         uint256 startingPrice,
112         uint256 endingPrice,
113         uint256 duration,
114         uint256 startedAt);
115     function getAuctionSeller(uint256 _tokenId)
116         public constant returns (address);
117     function getAuctionEnd(uint _tokenId)
118         public constant returns (uint);
119     function canBeCanceled(uint _tokenId) external constant returns (bool);
120     function getAuctionsCount() public constant returns (uint);
121     function getTokensOnAuction() public constant returns (uint[]);
122     function getTokenIdAtIndex(uint _index) public constant returns (uint);
123     function getAuctionStartedAt(uint256 _tokenId) public constant returns (uint);
124 
125     function getOffsetIndex() public constant returns (uint);
126     function nextOffsetIndex() public returns (uint);
127     function canCreateEdition(uint _tokenId, uint8 _generation)
128         public constant returns (bool);
129     function isValidGeneration(uint8 _generation)
130         public constant returns (bool);
131     function increaseGenerationCount(uint _tokenId, uint8 _generation) public;
132     function getEditionsCount(uint _tokenId) external constant returns (uint8[3]);
133     function setLastEditionOf(uint _tokenId, uint _editionId) public;
134     function setEditionLimits(uint _tokenId, uint8 _gen1, uint8 _gen2, uint8 _gen3) public;
135     function getEditionLimits(uint _tokenId) external constant returns (uint8[3]);
136 
137     function hasEditionInProgress(uint _tokenId) external constant returns (bool);
138     function hasEmptyEditionSlots(uint _tokenId) external constant returns (bool);
139 
140     function setPaintingName(uint _tokenId, string _name) public;
141     function setPaintingArtist(uint _tokenId, string _name) public;
142     function purgeInformation(uint _tokenId) public;
143     function resetEditionLimits(uint _tokenId) public;
144     function resetPainting(uint _tokenId) public;
145     function decreaseSpeed(uint _tokenId) public;
146     function isCanceled(uint _tokenId) public constant returns (bool _is);
147     function totalPaintingsCount() public constant returns (uint _total);
148     function isSecondary(uint _tokenId) public constant returns (bool _is);
149     function secondarySaleCut() public constant returns (uint8 _cut);
150     function sealForChanges(uint _tokenId) public;
151     function canBeChanged(uint _tokenId) public constant returns (bool _can);
152 
153     function getPaintingName(uint _tokenId) public constant returns (string);
154     function getPaintingArtist(uint _tokenId) public constant returns (string);
155 
156     function signature() external constant returns (bytes4);
157 }
158 
159 // File: contracts/libs/Ownable.sol
160 
161 /**
162 * @title Ownable
163 * @dev Manages ownership of the contracts
164 */
165 contract Ownable {
166 
167     address public owner;
168 
169     function Ownable() public {
170         owner = msg.sender;
171     }
172 
173     modifier onlyOwner() {
174         require(msg.sender == owner);
175         _;
176     }
177 
178     function isOwner(address _address) public constant returns (bool) {
179         return _address == owner;
180     }
181 
182     function transferOwnership(address newOwner) external onlyOwner {
183         require(newOwner != address(0));
184         owner = newOwner;
185     }
186 
187 }
188 
189 // File: contracts/libs/Pausable.sol
190 
191 /**
192  * @title Pausable
193  * @dev Base contract which allows children to implement an emergency stop mechanism.
194  */
195 contract Pausable is Ownable {
196     event Pause();
197     event Unpause();
198 
199     bool public paused = false;
200 
201     /**
202     * @dev modifier to allow actions only when the contract IS paused
203     */
204     modifier whenNotPaused() {
205         require(!paused);
206         _;
207     }
208 
209     /**
210     * @dev modifier to allow actions only when the contract IS NOT paused
211     */
212     modifier whenPaused {
213         require(paused);
214         _;
215     }
216 
217     /**
218     * @dev called by the owner to pause, triggers stopped state
219     */
220     function _pause() internal whenNotPaused {
221         paused = true;
222         Pause();
223     }
224 
225     /**
226      * @dev called by the owner to unpause, returns to normal state
227      */
228     function _unpause() internal whenPaused {
229         paused = false;
230         Unpause();
231     }
232 }
233 
234 // File: contracts/libs/BitpaintingBase.sol
235 
236 contract BitpaintingBase is Pausable {
237     /*** EVENTS ***/
238     event Create(uint _tokenId,
239         address _owner,
240         uint _parentId,
241         uint8 _generation,
242         uint _createdAt,
243         uint _completedAt);
244 
245     event Transfer(address from, address to, uint256 tokenId);
246 
247     IStorage public bitpaintingStorage;
248 
249     modifier canPauseUnpause() {
250         require(msg.sender == owner || msg.sender == bitpaintingStorage.developer());
251         _;
252     }
253 
254     function setBitpaintingStorage(address _address) public onlyOwner {
255         require(_address != address(0));
256         bitpaintingStorage = IStorage(_address);
257     }
258 
259     /**
260     * @dev called by the owner to pause, triggers stopped state
261     */
262     function pause() public canPauseUnpause whenNotPaused {
263         super._pause();
264     }
265 
266     /**
267      * @dev called by the owner to unpause, returns to normal state
268      */
269     function unpause() external canPauseUnpause whenPaused {
270         super._unpause();
271     }
272 
273     function canUserReleaseArtwork(address _address)
274         public constant returns (bool _can) {
275         return (bitpaintingStorage.isOwner(_address)
276             || bitpaintingStorage.isAdmin(_address)
277             || bitpaintingStorage.isAllowed(_address));
278     }
279 
280     function canUserCancelArtwork(address _address)
281         public constant returns (bool _can) {
282         return (bitpaintingStorage.isOwner(_address)
283             || bitpaintingStorage.isAdmin(_address));
284     }
285 
286     modifier canReleaseArtwork() {
287         require(canUserReleaseArtwork(msg.sender));
288         _;
289     }
290 
291     modifier canCancelArtwork() {
292         require(canUserCancelArtwork(msg.sender));
293         _;
294     }
295 
296     /// @dev Assigns ownership of a specific Painting to an address.
297     function _transfer(address _from, address _to, uint256 _tokenId)
298         internal {
299         bitpaintingStorage.setOwnership(_tokenId, _to);
300         Transfer(_from, _to, _tokenId);
301     }
302 
303     function _createOriginalPainting(uint _tokenId, uint _artistId, uint _releasedAt) internal {
304         address _owner = owner;
305         uint _parentId = 0;
306         uint8 _generation = 0;
307         uint8 _speed = 10;
308         _createPainting(_owner, _tokenId, _parentId, _generation, _speed, _artistId, _releasedAt);
309     }
310 
311     function _createPainting(
312         address _owner,
313         uint _tokenId,
314         uint _parentId,
315         uint8 _generation,
316         uint8 _speed,
317         uint _artistId,
318         uint _releasedAt
319     )
320         internal
321     {
322         require(_tokenId == uint256(uint32(_tokenId)));
323         require(_parentId == uint256(uint32(_parentId)));
324         require(_generation == uint256(uint8(_generation)));
325 
326         bitpaintingStorage.createPainting(
327             _owner, _tokenId, _parentId, _generation, _speed, _artistId, _releasedAt);
328 
329         uint _createdAt;
330         uint _completedAt;
331         (,,_createdAt, _completedAt,,) = bitpaintingStorage.getPainting(_tokenId);
332 
333         // emit the create event
334         Create(
335             _tokenId,
336             _owner,
337             _parentId,
338             _generation,
339             _createdAt,
340             _completedAt
341         );
342 
343         // This will assign ownership, and also emit the Transfer event as
344         // per ERC721 draft
345         _transfer(0, _owner, _tokenId);
346     }
347 
348 }
349 
350 // File: contracts/libs/ERC721.sol
351 
352 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
353 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
354 contract ERC721 {
355     // Required methods
356     function totalSupply() public constant returns (uint256 total);
357     function balanceOf(address _owner) public constant returns (uint256 balance);
358     function ownerOf(uint256 _tokenId) external constant returns (address owner);
359     function approve(address _to, uint256 _tokenId) external;
360     function transfer(address _to, uint256 _tokenId) external;
361     function transferFrom(address _from, address _to, uint256 _tokenId) external;
362 
363     // Events
364     event Transfer(address from, address to, uint256 tokenId);
365     event Approval(address owner, address approved, uint256 tokenId);
366 
367     // Optional
368     // function name() public view returns (string name);
369     // function symbol() public view returns (string symbol);
370     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
371     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
372 
373     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
374     function supportsInterface(bytes4 _interfaceID) external constant returns (bool);
375 }
376 
377 // File: contracts/libs/ERC721Metadata.sol
378 
379 /// @title The external contract that is responsible for generating metadata for the kitties,
380 ///  it has one function that will return the data as bytes.
381 contract ERC721Metadata {
382     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
383     function getMetadata(uint256 _tokenId, string) public constant returns (bytes32[4] buffer, uint256 count) {
384         if (_tokenId == 1) {
385             buffer[0] = "Hello World! :D";
386             count = 15;
387         } else if (_tokenId == 2) {
388             buffer[0] = "I would definitely choose a medi";
389             buffer[1] = "um length string.";
390             count = 49;
391         } else if (_tokenId == 3) {
392             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
393             buffer[1] = "st accumsan dapibus augue lorem,";
394             buffer[2] = " tristique vestibulum id, libero";
395             buffer[3] = " suscipit varius sapien aliquam.";
396             count = 128;
397         }
398     }
399 }
400 
401 // File: contracts/libs/PaintingOwnership.sol
402 
403 contract PaintingOwnership is BitpaintingBase, ERC721 {
404 
405     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
406     string public constant name = "BitPaintings";
407     string public constant symbol = "BP";
408 
409     ERC721Metadata public erc721Metadata;
410 
411     bytes4 constant InterfaceSignature_ERC165 =
412         bytes4(keccak256('supportsInterface(bytes4)'));
413 
414     bytes4 constant InterfaceSignature_ERC721 =
415         bytes4(keccak256('name()')) ^
416         bytes4(keccak256('symbol()')) ^
417         bytes4(keccak256('totalSupply()')) ^
418         bytes4(keccak256('balanceOf(address)')) ^
419         bytes4(keccak256('ownerOf(uint256)')) ^
420         bytes4(keccak256('approve(address,uint256)')) ^
421         bytes4(keccak256('transfer(address,uint256)')) ^
422         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
423         bytes4(keccak256('tokensOfOwner(address)')) ^
424         bytes4(keccak256('tokenMetadata(uint256,string)'));
425 
426     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
427     ///  Returns true for any standardized interfaces implemented by this contract. We implement
428     ///  ERC-165 (obviously!) and ERC-721.
429     function supportsInterface(bytes4 _interfaceID) external constant returns (bool)
430     {
431         // DEBUG ONLY
432         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
433 
434         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
435     }
436 
437     /// @dev Set the address of the sibling contract that tracks metadata.
438     ///  CEO only.
439     function setMetadataAddress(address _contractAddress) public onlyOwner {
440         erc721Metadata = ERC721Metadata(_contractAddress);
441     }
442 
443     function _owns(address _claimant, uint256 _tokenId) internal constant returns (bool) {
444         return bitpaintingStorage.getPaintingOwner(_tokenId) == _claimant;
445     }
446 
447     function balanceOf(address _owner) public constant returns (uint256 count) {
448         return bitpaintingStorage.getOwnershipTokenCount(_owner);
449     }
450 
451     function _approve(uint256 _tokenId, address _approved) internal {
452         bitpaintingStorage.approve(_tokenId, _approved);
453     }
454 
455     function _approvedFor(address _claimant, uint256 _tokenId)
456         internal constant returns (bool) {
457         return bitpaintingStorage.isApprovedFor(_tokenId, _claimant);
458     }
459 
460     function transfer(
461         address _to,
462         uint256 _tokenId
463     )
464         external
465         whenNotPaused
466     {
467         require(_to != address(0));
468         require(_to != address(this));
469         require(_owns(msg.sender, _tokenId));
470 
471         _transfer(msg.sender, _to, _tokenId);
472     }
473 
474     function approve(
475       address _to,
476       uint256 _tokenId
477     )
478       external
479       whenNotPaused
480     {
481       require(_owns(msg.sender, _tokenId));
482       _approve(_tokenId, _to);
483 
484       Approval(msg.sender, _to, _tokenId);
485     }
486 
487     function transferFrom(
488       address _from,
489       address _to,
490       uint256 _tokenId
491     )
492         external whenNotPaused {
493         _transferFrom(_from, _to, _tokenId);
494     }
495 
496     function _transferFrom(
497       address _from,
498       address _to,
499       uint256 _tokenId
500     )
501         internal
502         whenNotPaused
503     {
504         require(_to != address(0));
505         require(_to != address(this));
506         require(_approvedFor(msg.sender, _tokenId));
507         require(_owns(_from, _tokenId));
508 
509         _transfer(_from, _to, _tokenId);
510     }
511 
512     function totalSupply() public constant returns (uint) {
513       return bitpaintingStorage.paintingsCount();
514     }
515 
516     function ownerOf(uint256 _tokenId)
517         external constant returns (address) {
518         return _ownerOf(_tokenId);
519     }
520 
521     function _ownerOf(uint256 _tokenId)
522         internal constant returns (address) {
523         return bitpaintingStorage.getPaintingOwner(_tokenId);
524     }
525 
526     function tokensOfOwner(address _owner)
527         external constant returns(uint256[]) {
528         uint256 tokenCount = balanceOf(_owner);
529 
530         if (tokenCount == 0) {
531           return new uint256[](0);
532         }
533 
534         uint256[] memory result = new uint256[](tokenCount);
535         uint256 totalCats = totalSupply();
536         uint256 resultIndex = 0;
537 
538         uint256 paintingId;
539 
540         for (paintingId = 1; paintingId <= totalCats; paintingId++) {
541             if (bitpaintingStorage.getPaintingOwner(paintingId) == _owner) {
542                 result[resultIndex] = paintingId;
543                 resultIndex++;
544             }
545         }
546 
547         return result;
548     }
549 
550     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
551     ///  This method is licenced under the Apache License.
552     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
553     function _memcpy(uint _dest, uint _src, uint _len) private constant {
554       // Copy word-length chunks while possible
555       for(; _len >= 32; _len -= 32) {
556           assembly {
557               mstore(_dest, mload(_src))
558           }
559           _dest += 32;
560           _src += 32;
561       }
562 
563       // Copy remaining bytes
564       uint256 mask = 256 ** (32 - _len) - 1;
565       assembly {
566           let srcpart := and(mload(_src), not(mask))
567           let destpart := and(mload(_dest), mask)
568           mstore(_dest, or(destpart, srcpart))
569       }
570     }
571 
572     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
573     ///  This method is licenced under the Apache License.
574     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
575     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private constant returns (string) {
576       var outputString = new string(_stringLength);
577       uint256 outputPtr;
578       uint256 bytesPtr;
579 
580       assembly {
581           outputPtr := add(outputString, 32)
582           bytesPtr := _rawBytes
583       }
584 
585       _memcpy(outputPtr, bytesPtr, _stringLength);
586 
587       return outputString;
588     }
589 
590     /// @notice Returns a URI pointing to a metadata package for this token conforming to
591     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
592     /// @param _tokenId The ID number of the Kitty whose metadata should be returned.
593     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external constant returns (string infoUrl) {
594       require(erc721Metadata != address(0));
595       bytes32[4] memory buffer;
596       uint256 count;
597       (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
598 
599       return _toString(buffer, count);
600     }
601 
602     function withdraw() external onlyOwner {
603         owner.transfer(this.balance);
604     }
605 }
606 
607 // File: contracts/BitpaintingAuctions.sol
608 
609 contract BitpaintingAuctions is PaintingOwnership, IAuctions {
610 
611     event AuctionCreated(
612         uint tokenId,
613         address seller,
614         uint startingPrice,
615         uint endingPrice,
616         uint duration);
617     event AuctionCancelled(uint tokenId, address seller);
618     event AuctionSuccessful(uint tokenId, uint totalPrice, address winner);
619 
620     function currentPrice(uint _tokenId)
621         public
622         constant
623         returns (uint)
624     {
625         require(bitpaintingStorage.isOnAuction(_tokenId));
626         uint secondsPassed = 0;
627         address seller;
628         uint startingPrice;
629         uint endingPrice;
630         uint duration;
631         uint startedAt;
632         (seller, startingPrice, endingPrice, duration, startedAt)
633             = bitpaintingStorage.getAuction(_tokenId);
634 
635         // move that as class/contract member
636         uint weis_in_gwei = 1000000000;
637         if (now < startedAt) {
638             return (startingPrice / weis_in_gwei);
639         }
640 
641         if (now > startedAt) {
642             secondsPassed = now - startedAt;
643         }
644 
645         return _computeCurrentPrice(
646             startingPrice,
647             endingPrice,
648             duration,
649             secondsPassed
650         );
651     }
652 
653     /// returns the price in gwei instead of wei
654     function _computeCurrentPrice(
655         uint _startingPrice,
656         uint _endingPrice,
657         uint _duration,
658         uint _secondsPassed
659     )
660         internal
661         constant
662         returns (uint)
663     {
664         uint weis_in_gwei = 1000000000;
665         if (_secondsPassed >= _duration) {
666             return _endingPrice / weis_in_gwei;
667         }
668 
669         int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
670         int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
671         int256 _currentPrice = int256(_startingPrice) + currentPriceChange;
672 
673         return uint(_currentPrice) / weis_in_gwei;
674     }
675 
676     function _bid(uint _tokenId, uint _amount) private {
677         require(bitpaintingStorage.isOnAuction(_tokenId));
678         require(bitpaintingStorage.canBeBidden(_tokenId));
679 
680         uint weis_in_gwei = 1000000000;
681         address seller = bitpaintingStorage.getAuctionSeller(_tokenId);
682         uint price = currentPrice(_tokenId) * weis_in_gwei;
683         require(_amount >= price);
684 
685         if (bitpaintingStorage.isSecondary(_tokenId)) {
686             uint8 cut = bitpaintingStorage.secondarySaleCut();
687             uint forSeller = ((100 - cut) * _amount) / 100;
688             seller.transfer(forSeller);
689         }
690         bitpaintingStorage.removeAuction(_tokenId);
691         bitpaintingStorage.increaseOwnershipTokenCount(msg.sender);
692         bitpaintingStorage.decreaseOwnershipTokenCount(seller);
693         bitpaintingStorage.sealForChanges(_tokenId);
694 
695         AuctionSuccessful(_tokenId, price, msg.sender);
696     }
697 
698     function _escrow(address _owner, uint _tokenId) internal {
699         _transferFrom(_owner, this, _tokenId);
700     }
701 
702     /// @dev Cancels an auction unconditionally.
703     function _cancelAuction(uint _tokenId) internal {
704         bitpaintingStorage.removeAuction(_tokenId);
705         AuctionCancelled(_tokenId, msg.sender);
706     }
707 
708     /// @dev Creates and begins a new auction.
709     /// @param _tokenId - ID of token to auction, sender must be owner.
710     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
711     /// @param _endingPrice - Price of item (in wei) at end of auction.
712     /// @param _duration - Length of time to move between starting
713     ///  price and ending price (in seconds).
714     /// @param _seller - Seller, if not the message sender
715     function _createAuction(
716         uint _tokenId,
717         uint _startingPrice,
718         uint _endingPrice,
719         uint _duration,
720         address _seller
721     )
722         public
723         whenNotPaused
724     {
725         // Sanity check that no inputs overflow how many bits we've allocated
726         // to store them in the auction struct.
727         require(_startingPrice == uint(uint128(_startingPrice)));
728         require(_endingPrice == uint(uint128(_endingPrice)));
729         require(_duration == uint(uint64(_duration)));
730 
731         bitpaintingStorage.addAuction(_tokenId, _startingPrice, _endingPrice, _duration, _seller);
732 
733         AuctionCreated(
734             uint(_tokenId),
735             _seller,
736             uint(_startingPrice),
737             uint(_endingPrice),
738             uint(_duration)
739         );
740     }
741 
742     function _createReleaseAuction(
743         uint _tokenId,
744         uint _startingPrice,
745         uint _endingPrice,
746         uint _startedAt,
747         uint _duration
748     ) internal {
749         // Sanity check that no inputs overflow how many bits we've allocated
750         // to store them in the auction struct.
751         require(_startingPrice == uint(uint128(_startingPrice)));
752         require(_endingPrice == uint(uint128(_endingPrice)));
753         require(_duration == uint(uint64(_duration)));
754 
755         bitpaintingStorage.addReleaseAuction(
756             _tokenId,
757             _startingPrice,
758             _endingPrice,
759             _startedAt,
760             _duration);
761     }
762 
763     /// @dev Put a painting up for auction.
764     ///  Does some ownership trickery to create auctions in one tx.
765     function createReleaseAuction(
766         uint _tokenId,
767         uint _startingPrice,
768         uint _endingPrice,
769         uint _startedAt,
770         uint _duration
771     ) public whenNotPaused canReleaseArtwork {
772         require(_startingPrice > _endingPrice);
773         _createReleaseAuction(
774             _tokenId,
775             _startingPrice,
776             _endingPrice,
777             _startedAt,
778             _duration
779         );
780     }
781 
782     /// @dev Put a painting up for auction.
783     ///  Does some ownership trickery to create auctions in one tx.
784     function createAuction(
785         uint _tokenId,
786         uint _startingPrice,
787         uint _endingPrice,
788         uint _duration
789     )
790         public
791         whenNotPaused
792     {
793         require(bitpaintingStorage.getPaintingOwner(_tokenId) == msg.sender);
794         require(!bitpaintingStorage.hasEditionInProgress(_tokenId));
795         require(bitpaintingStorage.isReady(_tokenId));
796         require(!bitpaintingStorage.isOnAuction(_tokenId));
797         require(_startingPrice > _endingPrice);
798 
799         _approve(_tokenId, msg.sender);
800         _createAuction(
801             _tokenId,
802             _startingPrice,
803             _endingPrice,
804             _duration,
805             msg.sender
806         );
807     }
808 
809     function cancelAuction(uint _tokenId) external whenNotPaused {
810         require(bitpaintingStorage.isOnAuction(_tokenId));
811         address seller = bitpaintingStorage.getAuctionSeller(_tokenId);
812         require(msg.sender == seller);
813         _cancelAuction(_tokenId);
814     }
815 
816     function cancelAuctionWhenPaused(uint _tokenId)
817         external whenPaused onlyOwner {
818         require(bitpaintingStorage.isOnAuction(_tokenId));
819         address seller = bitpaintingStorage.getAuctionSeller(_tokenId);
820         require(msg.sender == seller);
821         _cancelAuction(_tokenId);
822     }
823 
824     function bid(uint _tokenId, address _owner) external payable whenNotPaused {
825         address seller = bitpaintingStorage.getAuctionSeller(_tokenId);
826         require(seller == _owner);
827         _bid(_tokenId, msg.value);
828         _transfer(seller, msg.sender, _tokenId);
829     }
830 
831     function market() public constant returns (
832         uint[] tokens,
833         address[] sellers,
834         uint8[] generations,
835         uint8[] speeds,
836         uint[] prices
837         ) {
838         uint length = bitpaintingStorage.totalPaintingsCount();
839         uint count = bitpaintingStorage.getAuctionsCount();
840         tokens = new uint[](count);
841         generations = new uint8[](count);
842         sellers = new address[](count);
843         speeds = new uint8[](count);
844         prices = new uint[](count);
845         uint pointer = 0;
846 
847         for(uint index = 0; index < length; index++) {
848             uint tokenId = bitpaintingStorage.getPaintingIdAtIndex(index);
849 
850             if (bitpaintingStorage.isCanceled(tokenId)) {
851                 continue;
852             }
853 
854             if (!bitpaintingStorage.isOnAuction(tokenId)) {
855                 continue;
856             }
857 
858             tokens[pointer] = tokenId;
859             generations[pointer] = bitpaintingStorage.getPaintingGeneration(tokenId);
860             sellers[pointer] = _ownerOf(tokenId);
861             speeds[pointer] = bitpaintingStorage.getPaintingSpeed(tokenId);
862             prices[pointer] = currentPrice(tokenId);
863             pointer++;
864         }
865     }
866 
867     function auctionsOf(address _of) public constant returns (
868             uint[] tokens,
869             uint[] prices
870         ) {
871 
872         uint tokenCount = totalSupply();
873         uint length = balanceOf(_of);
874         uint pointer;
875 
876         tokens = new uint[](length);
877         prices = new uint[](length);
878 
879         for(uint index = 0; index < tokenCount; index++) {
880             uint tokenId = bitpaintingStorage.getPaintingIdAtIndex(index);
881 
882             if (_ownerOf(tokenId) != _of) {
883                 continue;
884             }
885 
886             if (!bitpaintingStorage.isReady(tokenId)) {
887                 continue;
888             }
889 
890             if (!bitpaintingStorage.isOnAuction(tokenId)) {
891                 continue;
892             }
893 
894             tokens[pointer] = tokenId;
895             prices[pointer] = currentPrice(tokenId);
896             pointer++;
897         }
898     }
899 
900     function signature() external constant returns (uint _signature) {
901         return uint(keccak256("auctions"));
902     }
903 }