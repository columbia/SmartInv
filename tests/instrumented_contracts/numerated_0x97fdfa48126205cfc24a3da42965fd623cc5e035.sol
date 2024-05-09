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
36 // File: contracts/interfaces/IPaintings.sol
37 
38 contract IPaintings {
39     function createPainting(uint _tokenId) external;
40     function sendAsGift(address _to, uint _tokenId) external;
41     function collectionOf(address _of) public constant returns (
42         uint[] tokens,
43         bool[] pending,
44         bool[] forSale,
45         bool[] locked,
46         uint8[] generations,
47         uint8[] speeds
48     );
49     function collectionCountsOf(address _of)
50         public constant returns (uint total, uint pending, uint forSale);
51     function signature() external constant returns (uint _signature);
52 }
53 
54 // File: contracts/interfaces/IStorage.sol
55 
56 contract IStorage {
57     function isOwner(address _address) public constant returns (bool);
58 
59     function isAllowed(address _address) external constant returns (bool);
60     function developer() public constant returns (address);
61     function setDeveloper(address _address) public;
62     function addAdmin(address _address) public;
63     function isAdmin(address _address) public constant returns (bool);
64     function removeAdmin(address _address) public;
65     function contracts(uint _signature) public returns (address _address);
66 
67     function exists(uint _tokenId) external constant returns (bool);
68     function paintingsCount() public constant returns (uint);
69     function increaseOwnershipTokenCount(address _address) public;
70     function decreaseOwnershipTokenCount(address _address) public;
71     function setOwnership(uint _tokenId, address _address) public;
72     function getPainting(uint _tokenId)
73         external constant returns (address, uint, uint, uint, uint8, uint8);
74     function createPainting(
75         address _owner,
76         uint _tokenId,
77         uint _parentId,
78         uint8 _generation,
79         uint8 _speed,
80         uint _artistId,
81         uint _releasedAt) public;
82     function approve(uint _tokenId, address _claimant) external;
83     function isApprovedFor(uint _tokenId, address _claimant)
84         external constant returns (bool);
85     function createEditionMeta(uint _tokenId) public;
86     function getPaintingOwner(uint _tokenId)
87         external constant returns (address);
88     function getPaintingGeneration(uint _tokenId)
89         public constant returns (uint8);
90     function getPaintingSpeed(uint _tokenId)
91         external constant returns (uint8);
92     function getPaintingArtistId(uint _tokenId)
93         public constant returns (uint artistId);
94     function getOwnershipTokenCount(address _address)
95         external constant returns (uint);
96     function isReady(uint _tokenId) public constant returns (bool);
97     function getPaintingIdAtIndex(uint _index) public constant returns (uint);
98     function lastEditionOf(uint _index) public constant returns (uint);
99     function getPaintingOriginal(uint _tokenId)
100         external constant returns (uint);
101     function canBeBidden(uint _tokenId) public constant returns (bool _can);
102 
103     function addAuction(
104         uint _tokenId,
105         uint _startingPrice,
106         uint _endingPrice,
107         uint _duration,
108         address _seller) public;
109     function addReleaseAuction(
110         uint _tokenId,
111         uint _startingPrice,
112         uint _endingPrice,
113         uint _startedAt,
114         uint _duration) public;
115     function initAuction(
116         uint _tokenId,
117         uint _startingPrice,
118         uint _endingPrice,
119         uint _startedAt,
120         uint _duration,
121         address _seller,
122         bool _byTeam) public;
123     function _isOnAuction(uint _tokenId) internal constant returns (bool);
124     function isOnAuction(uint _tokenId) external constant returns (bool);
125     function removeAuction(uint _tokenId) public;
126     function getAuction(uint256 _tokenId)
127         external constant returns (
128         address seller,
129         uint256 startingPrice,
130         uint256 endingPrice,
131         uint256 duration,
132         uint256 startedAt);
133     function getAuctionSeller(uint256 _tokenId)
134         public constant returns (address);
135     function getAuctionEnd(uint _tokenId)
136         public constant returns (uint);
137     function canBeCanceled(uint _tokenId) external constant returns (bool);
138     function getAuctionsCount() public constant returns (uint);
139     function getTokensOnAuction() public constant returns (uint[]);
140     function getTokenIdAtIndex(uint _index) public constant returns (uint);
141     function getAuctionStartedAt(uint256 _tokenId) public constant returns (uint);
142 
143     function getOffsetIndex() public constant returns (uint);
144     function nextOffsetIndex() public returns (uint);
145     function canCreateEdition(uint _tokenId, uint8 _generation)
146         public constant returns (bool);
147     function isValidGeneration(uint8 _generation)
148         public constant returns (bool);
149     function increaseGenerationCount(uint _tokenId, uint8 _generation) public;
150     function getEditionsCount(uint _tokenId) external constant returns (uint8[3]);
151     function setLastEditionOf(uint _tokenId, uint _editionId) public;
152     function setEditionLimits(uint _tokenId, uint8 _gen1, uint8 _gen2, uint8 _gen3) public;
153     function getEditionLimits(uint _tokenId) external constant returns (uint8[3]);
154 
155     function hasEditionInProgress(uint _tokenId) external constant returns (bool);
156     function hasEmptyEditionSlots(uint _tokenId) external constant returns (bool);
157 
158     function setPaintingName(uint _tokenId, string _name) public;
159     function setPaintingArtist(uint _tokenId, string _name) public;
160     function purgeInformation(uint _tokenId) public;
161     function resetEditionLimits(uint _tokenId) public;
162     function resetPainting(uint _tokenId) public;
163     function decreaseSpeed(uint _tokenId) public;
164     function isCanceled(uint _tokenId) public constant returns (bool _is);
165     function totalPaintingsCount() public constant returns (uint _total);
166     function isSecondary(uint _tokenId) public constant returns (bool _is);
167     function secondarySaleCut() public constant returns (uint8 _cut);
168     function sealForChanges(uint _tokenId) public;
169     function canBeChanged(uint _tokenId) public constant returns (bool _can);
170 
171     function getPaintingName(uint _tokenId) public constant returns (string);
172     function getPaintingArtist(uint _tokenId) public constant returns (string);
173 
174     function signature() external constant returns (bytes4);
175 }
176 
177 // File: contracts/libs/Ownable.sol
178 
179 /**
180 * @title Ownable
181 * @dev Manages ownership of the contracts
182 */
183 contract Ownable {
184 
185     address public owner;
186 
187     function Ownable() public {
188         owner = msg.sender;
189     }
190 
191     modifier onlyOwner() {
192         require(msg.sender == owner);
193         _;
194     }
195 
196     function isOwner(address _address) public constant returns (bool) {
197         return _address == owner;
198     }
199 
200     function transferOwnership(address newOwner) external onlyOwner {
201         require(newOwner != address(0));
202         owner = newOwner;
203     }
204 
205 }
206 
207 // File: contracts/libs/Pausable.sol
208 
209 /**
210  * @title Pausable
211  * @dev Base contract which allows children to implement an emergency stop mechanism.
212  */
213 contract Pausable is Ownable {
214     event Pause();
215     event Unpause();
216 
217     bool public paused = false;
218 
219     /**
220     * @dev modifier to allow actions only when the contract IS paused
221     */
222     modifier whenNotPaused() {
223         require(!paused);
224         _;
225     }
226 
227     /**
228     * @dev modifier to allow actions only when the contract IS NOT paused
229     */
230     modifier whenPaused {
231         require(paused);
232         _;
233     }
234 
235     /**
236     * @dev called by the owner to pause, triggers stopped state
237     */
238     function _pause() internal whenNotPaused {
239         paused = true;
240         Pause();
241     }
242 
243     /**
244      * @dev called by the owner to unpause, returns to normal state
245      */
246     function _unpause() internal whenPaused {
247         paused = false;
248         Unpause();
249     }
250 }
251 
252 // File: contracts/libs/BitpaintingBase.sol
253 
254 contract BitpaintingBase is Pausable {
255     /*** EVENTS ***/
256     event Create(uint _tokenId,
257         address _owner,
258         uint _parentId,
259         uint8 _generation,
260         uint _createdAt,
261         uint _completedAt);
262 
263     event Transfer(address from, address to, uint256 tokenId);
264 
265     IStorage public bitpaintingStorage;
266 
267     modifier canPauseUnpause() {
268         require(msg.sender == owner || msg.sender == bitpaintingStorage.developer());
269         _;
270     }
271 
272     function setBitpaintingStorage(address _address) public onlyOwner {
273         require(_address != address(0));
274         bitpaintingStorage = IStorage(_address);
275     }
276 
277     /**
278     * @dev called by the owner to pause, triggers stopped state
279     */
280     function pause() public canPauseUnpause whenNotPaused {
281         super._pause();
282     }
283 
284     /**
285      * @dev called by the owner to unpause, returns to normal state
286      */
287     function unpause() external canPauseUnpause whenPaused {
288         super._unpause();
289     }
290 
291     function canUserReleaseArtwork(address _address)
292         public constant returns (bool _can) {
293         return (bitpaintingStorage.isOwner(_address)
294             || bitpaintingStorage.isAdmin(_address)
295             || bitpaintingStorage.isAllowed(_address));
296     }
297 
298     function canUserCancelArtwork(address _address)
299         public constant returns (bool _can) {
300         return (bitpaintingStorage.isOwner(_address)
301             || bitpaintingStorage.isAdmin(_address));
302     }
303 
304     modifier canReleaseArtwork() {
305         require(canUserReleaseArtwork(msg.sender));
306         _;
307     }
308 
309     modifier canCancelArtwork() {
310         require(canUserCancelArtwork(msg.sender));
311         _;
312     }
313 
314     /// @dev Assigns ownership of a specific Painting to an address.
315     function _transfer(address _from, address _to, uint256 _tokenId)
316         internal {
317         bitpaintingStorage.setOwnership(_tokenId, _to);
318         Transfer(_from, _to, _tokenId);
319     }
320 
321     function _createOriginalPainting(uint _tokenId, uint _artistId, uint _releasedAt) internal {
322         address _owner = owner;
323         uint _parentId = 0;
324         uint8 _generation = 0;
325         uint8 _speed = 10;
326         _createPainting(_owner, _tokenId, _parentId, _generation, _speed, _artistId, _releasedAt);
327     }
328 
329     function _createPainting(
330         address _owner,
331         uint _tokenId,
332         uint _parentId,
333         uint8 _generation,
334         uint8 _speed,
335         uint _artistId,
336         uint _releasedAt
337     )
338         internal
339     {
340         require(_tokenId == uint256(uint32(_tokenId)));
341         require(_parentId == uint256(uint32(_parentId)));
342         require(_generation == uint256(uint8(_generation)));
343 
344         bitpaintingStorage.createPainting(
345             _owner, _tokenId, _parentId, _generation, _speed, _artistId, _releasedAt);
346 
347         uint _createdAt;
348         uint _completedAt;
349         (,,_createdAt, _completedAt,,) = bitpaintingStorage.getPainting(_tokenId);
350 
351         // emit the create event
352         Create(
353             _tokenId,
354             _owner,
355             _parentId,
356             _generation,
357             _createdAt,
358             _completedAt
359         );
360 
361         // This will assign ownership, and also emit the Transfer event as
362         // per ERC721 draft
363         _transfer(0, _owner, _tokenId);
364     }
365 
366 }
367 
368 // File: contracts/libs/ERC721.sol
369 
370 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
371 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
372 contract ERC721 {
373     // Required methods
374     function totalSupply() public constant returns (uint256 total);
375     function balanceOf(address _owner) public constant returns (uint256 balance);
376     function ownerOf(uint256 _tokenId) external constant returns (address owner);
377     function approve(address _to, uint256 _tokenId) external;
378     function transfer(address _to, uint256 _tokenId) external;
379     function transferFrom(address _from, address _to, uint256 _tokenId) external;
380 
381     // Events
382     event Transfer(address from, address to, uint256 tokenId);
383     event Approval(address owner, address approved, uint256 tokenId);
384 
385     // Optional
386     // function name() public view returns (string name);
387     // function symbol() public view returns (string symbol);
388     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
389     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
390 
391     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
392     function supportsInterface(bytes4 _interfaceID) external constant returns (bool);
393 }
394 
395 // File: contracts/libs/ERC721Metadata.sol
396 
397 /// @title The external contract that is responsible for generating metadata for the kitties,
398 ///  it has one function that will return the data as bytes.
399 contract ERC721Metadata {
400     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
401     function getMetadata(uint256 _tokenId, string) public constant returns (bytes32[4] buffer, uint256 count) {
402         if (_tokenId == 1) {
403             buffer[0] = "Hello World! :D";
404             count = 15;
405         } else if (_tokenId == 2) {
406             buffer[0] = "I would definitely choose a medi";
407             buffer[1] = "um length string.";
408             count = 49;
409         } else if (_tokenId == 3) {
410             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
411             buffer[1] = "st accumsan dapibus augue lorem,";
412             buffer[2] = " tristique vestibulum id, libero";
413             buffer[3] = " suscipit varius sapien aliquam.";
414             count = 128;
415         }
416     }
417 }
418 
419 // File: contracts/libs/PaintingOwnership.sol
420 
421 contract PaintingOwnership is BitpaintingBase, ERC721 {
422 
423     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
424     string public constant name = "BitPaintings";
425     string public constant symbol = "BP";
426 
427     ERC721Metadata public erc721Metadata;
428 
429     bytes4 constant InterfaceSignature_ERC165 =
430         bytes4(keccak256('supportsInterface(bytes4)'));
431 
432     bytes4 constant InterfaceSignature_ERC721 =
433         bytes4(keccak256('name()')) ^
434         bytes4(keccak256('symbol()')) ^
435         bytes4(keccak256('totalSupply()')) ^
436         bytes4(keccak256('balanceOf(address)')) ^
437         bytes4(keccak256('ownerOf(uint256)')) ^
438         bytes4(keccak256('approve(address,uint256)')) ^
439         bytes4(keccak256('transfer(address,uint256)')) ^
440         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
441         bytes4(keccak256('tokensOfOwner(address)')) ^
442         bytes4(keccak256('tokenMetadata(uint256,string)'));
443 
444     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
445     ///  Returns true for any standardized interfaces implemented by this contract. We implement
446     ///  ERC-165 (obviously!) and ERC-721.
447     function supportsInterface(bytes4 _interfaceID) external constant returns (bool)
448     {
449         // DEBUG ONLY
450         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
451 
452         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
453     }
454 
455     /// @dev Set the address of the sibling contract that tracks metadata.
456     ///  CEO only.
457     function setMetadataAddress(address _contractAddress) public onlyOwner {
458         erc721Metadata = ERC721Metadata(_contractAddress);
459     }
460 
461     function _owns(address _claimant, uint256 _tokenId) internal constant returns (bool) {
462         return bitpaintingStorage.getPaintingOwner(_tokenId) == _claimant;
463     }
464 
465     function balanceOf(address _owner) public constant returns (uint256 count) {
466         return bitpaintingStorage.getOwnershipTokenCount(_owner);
467     }
468 
469     function _approve(uint256 _tokenId, address _approved) internal {
470         bitpaintingStorage.approve(_tokenId, _approved);
471     }
472 
473     function _approvedFor(address _claimant, uint256 _tokenId)
474         internal constant returns (bool) {
475         return bitpaintingStorage.isApprovedFor(_tokenId, _claimant);
476     }
477 
478     function transfer(
479         address _to,
480         uint256 _tokenId
481     )
482         external
483         whenNotPaused
484     {
485         require(_to != address(0));
486         require(_to != address(this));
487         require(_owns(msg.sender, _tokenId));
488 
489         _transfer(msg.sender, _to, _tokenId);
490     }
491 
492     function approve(
493       address _to,
494       uint256 _tokenId
495     )
496       external
497       whenNotPaused
498     {
499       require(_owns(msg.sender, _tokenId));
500       _approve(_tokenId, _to);
501 
502       Approval(msg.sender, _to, _tokenId);
503     }
504 
505     function transferFrom(
506       address _from,
507       address _to,
508       uint256 _tokenId
509     )
510         external whenNotPaused {
511         _transferFrom(_from, _to, _tokenId);
512     }
513 
514     function _transferFrom(
515       address _from,
516       address _to,
517       uint256 _tokenId
518     )
519         internal
520         whenNotPaused
521     {
522         require(_to != address(0));
523         require(_to != address(this));
524         require(_approvedFor(msg.sender, _tokenId));
525         require(_owns(_from, _tokenId));
526 
527         _transfer(_from, _to, _tokenId);
528     }
529 
530     function totalSupply() public constant returns (uint) {
531       return bitpaintingStorage.paintingsCount();
532     }
533 
534     function ownerOf(uint256 _tokenId)
535         external constant returns (address) {
536         return _ownerOf(_tokenId);
537     }
538 
539     function _ownerOf(uint256 _tokenId)
540         internal constant returns (address) {
541         return bitpaintingStorage.getPaintingOwner(_tokenId);
542     }
543 
544     function tokensOfOwner(address _owner)
545         external constant returns(uint256[]) {
546         uint256 tokenCount = balanceOf(_owner);
547 
548         if (tokenCount == 0) {
549           return new uint256[](0);
550         }
551 
552         uint256[] memory result = new uint256[](tokenCount);
553         uint256 totalCats = totalSupply();
554         uint256 resultIndex = 0;
555 
556         uint256 paintingId;
557 
558         for (paintingId = 1; paintingId <= totalCats; paintingId++) {
559             if (bitpaintingStorage.getPaintingOwner(paintingId) == _owner) {
560                 result[resultIndex] = paintingId;
561                 resultIndex++;
562             }
563         }
564 
565         return result;
566     }
567 
568     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
569     ///  This method is licenced under the Apache License.
570     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
571     function _memcpy(uint _dest, uint _src, uint _len) private constant {
572       // Copy word-length chunks while possible
573       for(; _len >= 32; _len -= 32) {
574           assembly {
575               mstore(_dest, mload(_src))
576           }
577           _dest += 32;
578           _src += 32;
579       }
580 
581       // Copy remaining bytes
582       uint256 mask = 256 ** (32 - _len) - 1;
583       assembly {
584           let srcpart := and(mload(_src), not(mask))
585           let destpart := and(mload(_dest), mask)
586           mstore(_dest, or(destpart, srcpart))
587       }
588     }
589 
590     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
591     ///  This method is licenced under the Apache License.
592     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
593     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private constant returns (string) {
594       var outputString = new string(_stringLength);
595       uint256 outputPtr;
596       uint256 bytesPtr;
597 
598       assembly {
599           outputPtr := add(outputString, 32)
600           bytesPtr := _rawBytes
601       }
602 
603       _memcpy(outputPtr, bytesPtr, _stringLength);
604 
605       return outputString;
606     }
607 
608     /// @notice Returns a URI pointing to a metadata package for this token conforming to
609     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
610     /// @param _tokenId The ID number of the Kitty whose metadata should be returned.
611     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external constant returns (string infoUrl) {
612       require(erc721Metadata != address(0));
613       bytes32[4] memory buffer;
614       uint256 count;
615       (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
616 
617       return _toString(buffer, count);
618     }
619 
620     function withdraw() external onlyOwner {
621         owner.transfer(this.balance);
622     }
623 }
624 
625 // File: contracts/BitpaintingPaintings.sol
626 
627 contract BitpaintingPaintings is PaintingOwnership, IPaintings {
628 
629     uint version = 2;
630 
631     function release(
632         uint _tokenId,
633         uint _artistId,
634         uint _releasedAt,
635         uint8[] _gens,
636         uint _auctionStartingPrice,
637         uint _auctionEndingPrice,
638         uint _auctionDuration,
639         string _artist,
640         string _name
641     ) external canReleaseArtwork whenNotPaused {
642         _createOriginalPainting(_tokenId, _artistId, _releasedAt);
643         _approve(_tokenId, owner);
644         bitpaintingStorage.setEditionLimits(_tokenId, _gens[0], _gens[1],_gens[2]);
645         auctionsContract().createReleaseAuction(
646             _tokenId,
647             _auctionStartingPrice,
648             _auctionEndingPrice,
649             _releasedAt,
650             _auctionDuration);
651         bitpaintingStorage.setPaintingArtist(_tokenId, _artist);
652         bitpaintingStorage.setPaintingName(_tokenId, _name);
653     }
654 
655     function releaseNow(
656         uint _tokenId,
657         uint _artistId,
658         uint8[] _gens,
659         uint _auctionStartingPrice,
660         uint _auctionEndingPrice,
661         uint _auctionDuration,
662         string _artist,
663         string _name
664     ) external canReleaseArtwork whenNotPaused {
665         uint _releasedAt = now;
666         _createOriginalPainting(_tokenId, _artistId, _releasedAt);
667         _approve(_tokenId, owner);
668         bitpaintingStorage.setEditionLimits(_tokenId, _gens[0], _gens[1],_gens[2]);
669         auctionsContract().createReleaseAuction(
670             _tokenId,
671             _auctionStartingPrice,
672             _auctionEndingPrice,
673             now, // _releasedAt
674             _auctionDuration);
675         bitpaintingStorage.setPaintingArtist(_tokenId, _artist);
676         bitpaintingStorage.setPaintingName(_tokenId, _name);
677     }
678 
679     function cancel(uint _tokenId) external canCancelArtwork whenNotPaused {
680         require(bitpaintingStorage.isOnAuction(_tokenId));
681         require(bitpaintingStorage.canBeChanged(_tokenId));
682 
683         bitpaintingStorage.resetPainting(_tokenId);
684         bitpaintingStorage.removeAuction(_tokenId);
685         bitpaintingStorage.resetEditionLimits(_tokenId);
686         bitpaintingStorage.purgeInformation(_tokenId);
687     }
688 
689     function auctionsContract() internal returns (IAuctions auctions){
690         uint _signature = uint(keccak256("auctions"));
691         return IAuctions(bitpaintingStorage.contracts(_signature));
692     }
693 
694     function createPainting(uint _tokenId)
695         external canReleaseArtwork whenNotPaused {
696         _createOriginalPainting(_tokenId, 1, now);
697         _approve(_tokenId, owner);
698     }
699 
700     function sendAsGift(address _to, uint _tokenId) external whenNotPaused {
701         require(_to != address(0));
702         require(_to != address(this));
703         require(_owns(msg.sender, _tokenId));
704         require(bitpaintingStorage.isReady(_tokenId));
705         require(!bitpaintingStorage.hasEditionInProgress(_tokenId));
706 
707         if (bitpaintingStorage.isOnAuction(_tokenId)) {
708             bitpaintingStorage.removeAuction(_tokenId);
709         }
710 
711         bitpaintingStorage.sealForChanges(_tokenId);
712         _transfer(msg.sender, _to, _tokenId);
713         bitpaintingStorage.increaseOwnershipTokenCount(_to);
714         bitpaintingStorage.decreaseOwnershipTokenCount(msg.sender);
715     }
716 
717     function allTokenIds() public constant returns (uint[] tokenIds) {
718         uint len = bitpaintingStorage.totalPaintingsCount();
719         uint resultLen = bitpaintingStorage.paintingsCount();
720         tokenIds = new uint[](resultLen);
721         uint pointer = 0;
722         for (uint index = 0; index < len; index++) {
723             uint token = bitpaintingStorage.getPaintingIdAtIndex(index);
724             if (bitpaintingStorage.isCanceled(token)) {
725                 continue;
726             }
727             tokenIds[pointer] = token;
728             pointer++;
729         }
730     }
731 
732     function collectionOf(address _of) public constant returns (
733             uint[] tokens,
734             bool[] pending,
735             bool[] forSale,
736             bool[] locked,
737             uint8[] generations,
738             uint8[] speeds
739         ) {
740 
741         uint tokenCount = bitpaintingStorage.totalPaintingsCount();
742         uint length = balanceOf(_of);
743         uint pointer;
744 
745         tokens = new uint[](length);
746         pending = new bool[](length);
747         forSale = new bool[](length);
748         locked = new bool[](length);
749         generations = new uint8[](length);
750         speeds = new uint8[](length);
751 
752         for(uint index = 0; index < tokenCount; index++) {
753             uint tokenId = bitpaintingStorage.getPaintingIdAtIndex(index);
754 
755             if (_ownerOf(tokenId) != _of) {
756                 continue;
757             }
758 
759             uint _createdAt;
760             (,,_createdAt,,,) = bitpaintingStorage.getPainting(tokenId);
761             if (_createdAt == 0) {
762                 continue;
763             }
764 
765             tokens[pointer] = tokenId;
766             pending[pointer] = !bitpaintingStorage.isReady(tokenId);
767             forSale[pointer] = (bitpaintingStorage.getAuctionStartedAt(tokenId) > 0);
768             uint edition = bitpaintingStorage.lastEditionOf(tokenId);
769             if (edition == 0) {
770                 locked[pointer] = false;
771             } else {
772                 locked[pointer] = !bitpaintingStorage.isReady(edition);
773             }
774             generations[pointer] = bitpaintingStorage.getPaintingGeneration(tokenId);
775             speeds[pointer] = bitpaintingStorage.getPaintingSpeed(tokenId);
776 
777             pointer++;
778         }
779 
780     }
781 
782     function collectionCountsOf(address _of) public constant
783         returns (uint total, uint pending, uint forSale) {
784         uint tokenCount = totalSupply();
785 
786         for(uint index = 0; index < tokenCount; index++) {
787             uint tokenId = bitpaintingStorage.getPaintingIdAtIndex(index);
788 
789             if (_ownerOf(tokenId) != _of) {
790                 continue;
791             }
792 
793             total++;
794 
795             if (bitpaintingStorage.isReady(tokenId)) {
796                 if (bitpaintingStorage.getAuctionStartedAt(tokenId) > 0) {
797                     forSale++;
798                 }
799 
800                 continue;
801             }
802 
803             if (!bitpaintingStorage.isReady(tokenId)) {
804                 pending++;
805                 continue;
806             }
807 
808         }
809 
810     }
811 
812     function signature() external constant returns (uint _signature) {
813         return uint(keccak256("paintings"));
814     }
815 
816 }