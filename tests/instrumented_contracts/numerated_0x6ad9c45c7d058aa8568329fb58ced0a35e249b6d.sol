1 pragma solidity ^0.4.15;
2 
3 // File: contracts/interfaces/IEditions.sol
4 
5 contract IEditions {
6 
7     function createEdition(uint _tokenId) external;
8     function pendingEditionsOf(address _of) public constant returns (
9         uint[] tokens,
10         uint[] startedAt,
11         uint[] completedAt,
12         uint8[] currentCounts,
13         uint8[] limitCounts
14     );
15     function counter(uint _tokenId) public
16         constant returns (uint8 current, uint8 limit);
17     function signature() external constant returns (uint _signature);
18 }
19 
20 // File: contracts/interfaces/IStorage.sol
21 
22 contract IStorage {
23     function isOwner(address _address) public constant returns (bool);
24 
25     function isAllowed(address _address) external constant returns (bool);
26     function developer() public constant returns (address);
27     function setDeveloper(address _address) public;
28     function addAdmin(address _address) public;
29     function isAdmin(address _address) public constant returns (bool);
30     function removeAdmin(address _address) public;
31     function contracts(uint _signature) public returns (address _address);
32 
33     function exists(uint _tokenId) external constant returns (bool);
34     function paintingsCount() public constant returns (uint);
35     function increaseOwnershipTokenCount(address _address) public;
36     function decreaseOwnershipTokenCount(address _address) public;
37     function setOwnership(uint _tokenId, address _address) public;
38     function getPainting(uint _tokenId)
39         external constant returns (address, uint, uint, uint, uint8, uint8);
40     function createPainting(
41         address _owner,
42         uint _tokenId,
43         uint _parentId,
44         uint8 _generation,
45         uint8 _speed,
46         uint _artistId,
47         uint _releasedAt) public;
48     function approve(uint _tokenId, address _claimant) external;
49     function isApprovedFor(uint _tokenId, address _claimant)
50         external constant returns (bool);
51     function createEditionMeta(uint _tokenId) public;
52     function getPaintingOwner(uint _tokenId)
53         external constant returns (address);
54     function getPaintingGeneration(uint _tokenId)
55         public constant returns (uint8);
56     function getPaintingSpeed(uint _tokenId)
57         external constant returns (uint8);
58     function getPaintingArtistId(uint _tokenId)
59         public constant returns (uint artistId);
60     function getOwnershipTokenCount(address _address)
61         external constant returns (uint);
62     function isReady(uint _tokenId) public constant returns (bool);
63     function getPaintingIdAtIndex(uint _index) public constant returns (uint);
64     function lastEditionOf(uint _index) public constant returns (uint);
65     function getPaintingOriginal(uint _tokenId)
66         external constant returns (uint);
67     function canBeBidden(uint _tokenId) public constant returns (bool _can);
68 
69     function addAuction(
70         uint _tokenId,
71         uint _startingPrice,
72         uint _endingPrice,
73         uint _duration,
74         address _seller) public;
75     function addReleaseAuction(
76         uint _tokenId,
77         uint _startingPrice,
78         uint _endingPrice,
79         uint _startedAt,
80         uint _duration) public;
81     function initAuction(
82         uint _tokenId,
83         uint _startingPrice,
84         uint _endingPrice,
85         uint _startedAt,
86         uint _duration,
87         address _seller,
88         bool _byTeam) public;
89     function _isOnAuction(uint _tokenId) internal constant returns (bool);
90     function isOnAuction(uint _tokenId) external constant returns (bool);
91     function removeAuction(uint _tokenId) public;
92     function getAuction(uint256 _tokenId)
93         external constant returns (
94         address seller,
95         uint256 startingPrice,
96         uint256 endingPrice,
97         uint256 duration,
98         uint256 startedAt);
99     function getAuctionSeller(uint256 _tokenId)
100         public constant returns (address);
101     function getAuctionEnd(uint _tokenId)
102         public constant returns (uint);
103     function canBeCanceled(uint _tokenId) external constant returns (bool);
104     function getAuctionsCount() public constant returns (uint);
105     function getTokensOnAuction() public constant returns (uint[]);
106     function getTokenIdAtIndex(uint _index) public constant returns (uint);
107     function getAuctionStartedAt(uint256 _tokenId) public constant returns (uint);
108 
109     function getOffsetIndex() public constant returns (uint);
110     function nextOffsetIndex() public returns (uint);
111     function canCreateEdition(uint _tokenId, uint8 _generation)
112         public constant returns (bool);
113     function isValidGeneration(uint8 _generation)
114         public constant returns (bool);
115     function increaseGenerationCount(uint _tokenId, uint8 _generation) public;
116     function getEditionsCount(uint _tokenId) external constant returns (uint8[3]);
117     function setLastEditionOf(uint _tokenId, uint _editionId) public;
118     function setEditionLimits(uint _tokenId, uint8 _gen1, uint8 _gen2, uint8 _gen3) public;
119     function getEditionLimits(uint _tokenId) external constant returns (uint8[3]);
120 
121     function hasEditionInProgress(uint _tokenId) external constant returns (bool);
122     function hasEmptyEditionSlots(uint _tokenId) external constant returns (bool);
123 
124     function setPaintingName(uint _tokenId, string _name) public;
125     function setPaintingArtist(uint _tokenId, string _name) public;
126     function purgeInformation(uint _tokenId) public;
127     function resetEditionLimits(uint _tokenId) public;
128     function resetPainting(uint _tokenId) public;
129     function decreaseSpeed(uint _tokenId) public;
130     function isCanceled(uint _tokenId) public constant returns (bool _is);
131     function totalPaintingsCount() public constant returns (uint _total);
132     function isSecondary(uint _tokenId) public constant returns (bool _is);
133     function secondarySaleCut() public constant returns (uint8 _cut);
134     function sealForChanges(uint _tokenId) public;
135     function canBeChanged(uint _tokenId) public constant returns (bool _can);
136 
137     function getPaintingName(uint _tokenId) public constant returns (string);
138     function getPaintingArtist(uint _tokenId) public constant returns (string);
139 
140     function signature() external constant returns (bytes4);
141 }
142 
143 // File: contracts/libs/Ownable.sol
144 
145 /**
146 * @title Ownable
147 * @dev Manages ownership of the contracts
148 */
149 contract Ownable {
150 
151     address public owner;
152 
153     function Ownable() public {
154         owner = msg.sender;
155     }
156 
157     modifier onlyOwner() {
158         require(msg.sender == owner);
159         _;
160     }
161 
162     function isOwner(address _address) public constant returns (bool) {
163         return _address == owner;
164     }
165 
166     function transferOwnership(address newOwner) external onlyOwner {
167         require(newOwner != address(0));
168         owner = newOwner;
169     }
170 
171 }
172 
173 // File: contracts/libs/Pausable.sol
174 
175 /**
176  * @title Pausable
177  * @dev Base contract which allows children to implement an emergency stop mechanism.
178  */
179 contract Pausable is Ownable {
180     event Pause();
181     event Unpause();
182 
183     bool public paused = false;
184 
185     /**
186     * @dev modifier to allow actions only when the contract IS paused
187     */
188     modifier whenNotPaused() {
189         require(!paused);
190         _;
191     }
192 
193     /**
194     * @dev modifier to allow actions only when the contract IS NOT paused
195     */
196     modifier whenPaused {
197         require(paused);
198         _;
199     }
200 
201     /**
202     * @dev called by the owner to pause, triggers stopped state
203     */
204     function _pause() internal whenNotPaused {
205         paused = true;
206         Pause();
207     }
208 
209     /**
210      * @dev called by the owner to unpause, returns to normal state
211      */
212     function _unpause() internal whenPaused {
213         paused = false;
214         Unpause();
215     }
216 }
217 
218 // File: contracts/libs/BitpaintingBase.sol
219 
220 contract BitpaintingBase is Pausable {
221     /*** EVENTS ***/
222     event Create(uint _tokenId,
223         address _owner,
224         uint _parentId,
225         uint8 _generation,
226         uint _createdAt,
227         uint _completedAt);
228 
229     event Transfer(address from, address to, uint256 tokenId);
230 
231     IStorage public bitpaintingStorage;
232 
233     modifier canPauseUnpause() {
234         require(msg.sender == owner || msg.sender == bitpaintingStorage.developer());
235         _;
236     }
237 
238     function setBitpaintingStorage(address _address) public onlyOwner {
239         require(_address != address(0));
240         bitpaintingStorage = IStorage(_address);
241     }
242 
243     /**
244     * @dev called by the owner to pause, triggers stopped state
245     */
246     function pause() public canPauseUnpause whenNotPaused {
247         super._pause();
248     }
249 
250     /**
251      * @dev called by the owner to unpause, returns to normal state
252      */
253     function unpause() external canPauseUnpause whenPaused {
254         super._unpause();
255     }
256 
257     function canUserReleaseArtwork(address _address)
258         public constant returns (bool _can) {
259         return (bitpaintingStorage.isOwner(_address)
260             || bitpaintingStorage.isAdmin(_address)
261             || bitpaintingStorage.isAllowed(_address));
262     }
263 
264     function canUserCancelArtwork(address _address)
265         public constant returns (bool _can) {
266         return (bitpaintingStorage.isOwner(_address)
267             || bitpaintingStorage.isAdmin(_address));
268     }
269 
270     modifier canReleaseArtwork() {
271         require(canUserReleaseArtwork(msg.sender));
272         _;
273     }
274 
275     modifier canCancelArtwork() {
276         require(canUserCancelArtwork(msg.sender));
277         _;
278     }
279 
280     /// @dev Assigns ownership of a specific Painting to an address.
281     function _transfer(address _from, address _to, uint256 _tokenId)
282         internal {
283         bitpaintingStorage.setOwnership(_tokenId, _to);
284         Transfer(_from, _to, _tokenId);
285     }
286 
287     function _createOriginalPainting(uint _tokenId, uint _artistId, uint _releasedAt) internal {
288         address _owner = owner;
289         uint _parentId = 0;
290         uint8 _generation = 0;
291         uint8 _speed = 10;
292         _createPainting(_owner, _tokenId, _parentId, _generation, _speed, _artistId, _releasedAt);
293     }
294 
295     function _createPainting(
296         address _owner,
297         uint _tokenId,
298         uint _parentId,
299         uint8 _generation,
300         uint8 _speed,
301         uint _artistId,
302         uint _releasedAt
303     )
304         internal
305     {
306         require(_tokenId == uint256(uint32(_tokenId)));
307         require(_parentId == uint256(uint32(_parentId)));
308         require(_generation == uint256(uint8(_generation)));
309 
310         bitpaintingStorage.createPainting(
311             _owner, _tokenId, _parentId, _generation, _speed, _artistId, _releasedAt);
312 
313         uint _createdAt;
314         uint _completedAt;
315         (,,_createdAt, _completedAt,,) = bitpaintingStorage.getPainting(_tokenId);
316 
317         // emit the create event
318         Create(
319             _tokenId,
320             _owner,
321             _parentId,
322             _generation,
323             _createdAt,
324             _completedAt
325         );
326 
327         // This will assign ownership, and also emit the Transfer event as
328         // per ERC721 draft
329         _transfer(0, _owner, _tokenId);
330     }
331 
332 }
333 
334 // File: contracts/libs/ERC721.sol
335 
336 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
337 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
338 contract ERC721 {
339     // Required methods
340     function totalSupply() public constant returns (uint256 total);
341     function balanceOf(address _owner) public constant returns (uint256 balance);
342     function ownerOf(uint256 _tokenId) external constant returns (address owner);
343     function approve(address _to, uint256 _tokenId) external;
344     function transfer(address _to, uint256 _tokenId) external;
345     function transferFrom(address _from, address _to, uint256 _tokenId) external;
346 
347     // Events
348     event Transfer(address from, address to, uint256 tokenId);
349     event Approval(address owner, address approved, uint256 tokenId);
350 
351     // Optional
352     // function name() public view returns (string name);
353     // function symbol() public view returns (string symbol);
354     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
355     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
356 
357     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
358     function supportsInterface(bytes4 _interfaceID) external constant returns (bool);
359 }
360 
361 // File: contracts/libs/ERC721Metadata.sol
362 
363 /// @title The external contract that is responsible for generating metadata for the kitties,
364 ///  it has one function that will return the data as bytes.
365 contract ERC721Metadata {
366     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
367     function getMetadata(uint256 _tokenId, string) public constant returns (bytes32[4] buffer, uint256 count) {
368         if (_tokenId == 1) {
369             buffer[0] = "Hello World! :D";
370             count = 15;
371         } else if (_tokenId == 2) {
372             buffer[0] = "I would definitely choose a medi";
373             buffer[1] = "um length string.";
374             count = 49;
375         } else if (_tokenId == 3) {
376             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
377             buffer[1] = "st accumsan dapibus augue lorem,";
378             buffer[2] = " tristique vestibulum id, libero";
379             buffer[3] = " suscipit varius sapien aliquam.";
380             count = 128;
381         }
382     }
383 }
384 
385 // File: contracts/libs/PaintingOwnership.sol
386 
387 contract PaintingOwnership is BitpaintingBase, ERC721 {
388 
389     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
390     string public constant name = "BitPaintings";
391     string public constant symbol = "BP";
392 
393     ERC721Metadata public erc721Metadata;
394 
395     bytes4 constant InterfaceSignature_ERC165 =
396         bytes4(keccak256('supportsInterface(bytes4)'));
397 
398     bytes4 constant InterfaceSignature_ERC721 =
399         bytes4(keccak256('name()')) ^
400         bytes4(keccak256('symbol()')) ^
401         bytes4(keccak256('totalSupply()')) ^
402         bytes4(keccak256('balanceOf(address)')) ^
403         bytes4(keccak256('ownerOf(uint256)')) ^
404         bytes4(keccak256('approve(address,uint256)')) ^
405         bytes4(keccak256('transfer(address,uint256)')) ^
406         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
407         bytes4(keccak256('tokensOfOwner(address)')) ^
408         bytes4(keccak256('tokenMetadata(uint256,string)'));
409 
410     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
411     ///  Returns true for any standardized interfaces implemented by this contract. We implement
412     ///  ERC-165 (obviously!) and ERC-721.
413     function supportsInterface(bytes4 _interfaceID) external constant returns (bool)
414     {
415         // DEBUG ONLY
416         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
417 
418         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
419     }
420 
421     /// @dev Set the address of the sibling contract that tracks metadata.
422     ///  CEO only.
423     function setMetadataAddress(address _contractAddress) public onlyOwner {
424         erc721Metadata = ERC721Metadata(_contractAddress);
425     }
426 
427     function _owns(address _claimant, uint256 _tokenId) internal constant returns (bool) {
428         return bitpaintingStorage.getPaintingOwner(_tokenId) == _claimant;
429     }
430 
431     function balanceOf(address _owner) public constant returns (uint256 count) {
432         return bitpaintingStorage.getOwnershipTokenCount(_owner);
433     }
434 
435     function _approve(uint256 _tokenId, address _approved) internal {
436         bitpaintingStorage.approve(_tokenId, _approved);
437     }
438 
439     function _approvedFor(address _claimant, uint256 _tokenId)
440         internal constant returns (bool) {
441         return bitpaintingStorage.isApprovedFor(_tokenId, _claimant);
442     }
443 
444     function transfer(
445         address _to,
446         uint256 _tokenId
447     )
448         external
449         whenNotPaused
450     {
451         require(_to != address(0));
452         require(_to != address(this));
453         require(_owns(msg.sender, _tokenId));
454 
455         _transfer(msg.sender, _to, _tokenId);
456     }
457 
458     function approve(
459       address _to,
460       uint256 _tokenId
461     )
462       external
463       whenNotPaused
464     {
465       require(_owns(msg.sender, _tokenId));
466       _approve(_tokenId, _to);
467 
468       Approval(msg.sender, _to, _tokenId);
469     }
470 
471     function transferFrom(
472       address _from,
473       address _to,
474       uint256 _tokenId
475     )
476         external whenNotPaused {
477         _transferFrom(_from, _to, _tokenId);
478     }
479 
480     function _transferFrom(
481       address _from,
482       address _to,
483       uint256 _tokenId
484     )
485         internal
486         whenNotPaused
487     {
488         require(_to != address(0));
489         require(_to != address(this));
490         require(_approvedFor(msg.sender, _tokenId));
491         require(_owns(_from, _tokenId));
492 
493         _transfer(_from, _to, _tokenId);
494     }
495 
496     function totalSupply() public constant returns (uint) {
497       return bitpaintingStorage.paintingsCount();
498     }
499 
500     function ownerOf(uint256 _tokenId)
501         external constant returns (address) {
502         return _ownerOf(_tokenId);
503     }
504 
505     function _ownerOf(uint256 _tokenId)
506         internal constant returns (address) {
507         return bitpaintingStorage.getPaintingOwner(_tokenId);
508     }
509 
510     function tokensOfOwner(address _owner)
511         external constant returns(uint256[]) {
512         uint256 tokenCount = balanceOf(_owner);
513 
514         if (tokenCount == 0) {
515           return new uint256[](0);
516         }
517 
518         uint256[] memory result = new uint256[](tokenCount);
519         uint256 totalCats = totalSupply();
520         uint256 resultIndex = 0;
521 
522         uint256 paintingId;
523 
524         for (paintingId = 1; paintingId <= totalCats; paintingId++) {
525             if (bitpaintingStorage.getPaintingOwner(paintingId) == _owner) {
526                 result[resultIndex] = paintingId;
527                 resultIndex++;
528             }
529         }
530 
531         return result;
532     }
533 
534     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
535     ///  This method is licenced under the Apache License.
536     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
537     function _memcpy(uint _dest, uint _src, uint _len) private constant {
538       // Copy word-length chunks while possible
539       for(; _len >= 32; _len -= 32) {
540           assembly {
541               mstore(_dest, mload(_src))
542           }
543           _dest += 32;
544           _src += 32;
545       }
546 
547       // Copy remaining bytes
548       uint256 mask = 256 ** (32 - _len) - 1;
549       assembly {
550           let srcpart := and(mload(_src), not(mask))
551           let destpart := and(mload(_dest), mask)
552           mstore(_dest, or(destpart, srcpart))
553       }
554     }
555 
556     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
557     ///  This method is licenced under the Apache License.
558     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
559     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private constant returns (string) {
560       var outputString = new string(_stringLength);
561       uint256 outputPtr;
562       uint256 bytesPtr;
563 
564       assembly {
565           outputPtr := add(outputString, 32)
566           bytesPtr := _rawBytes
567       }
568 
569       _memcpy(outputPtr, bytesPtr, _stringLength);
570 
571       return outputString;
572     }
573 
574     /// @notice Returns a URI pointing to a metadata package for this token conforming to
575     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
576     /// @param _tokenId The ID number of the Kitty whose metadata should be returned.
577     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external constant returns (string infoUrl) {
578       require(erc721Metadata != address(0));
579       bytes32[4] memory buffer;
580       uint256 count;
581       (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
582 
583       return _toString(buffer, count);
584     }
585 
586     function withdraw() external onlyOwner {
587         owner.transfer(this.balance);
588     }
589 }
590 
591 // File: contracts/BitpaintingEditions.sol
592 
593 contract BitpaintingEditions is PaintingOwnership, IEditions {
594 
595     event EditionCreated(
596         address creator,
597         uint parentId,
598         uint editionId,
599         uint8 parentSpeed);
600 
601     function createEdition(uint _tokenId) external whenNotPaused {
602         address creator = msg.sender;
603         require(creator == _ownerOf(_tokenId));
604         require(bitpaintingStorage.isReady(_tokenId));
605         require(!bitpaintingStorage.hasEditionInProgress(_tokenId));
606         require(bitpaintingStorage.hasEmptyEditionSlots(_tokenId));
607         require(!bitpaintingStorage.isOnAuction(_tokenId));
608 
609         bitpaintingStorage.createEditionMeta(_tokenId);
610         uint editionId = bitpaintingStorage.getOffsetIndex();
611         uint8 _generation =
612             bitpaintingStorage.getPaintingGeneration(_tokenId) + 1;
613         uint8 _speed = 10;
614         uint _artistId = bitpaintingStorage.getPaintingArtistId(_tokenId);
615         _createPainting(creator, editionId, _tokenId, _generation, _speed, _artistId, now + 1);
616         bitpaintingStorage.decreaseSpeed(_tokenId);
617 
618         uint8 speed = bitpaintingStorage.getPaintingSpeed(_tokenId);
619         EditionCreated(creator, _tokenId, editionId, speed);
620     }
621 
622     function pendingEditionsOf(address _of) public constant returns (
623             uint[] tokens,
624             uint[] startedAt,
625             uint[] completedAt,
626             uint8[] currentCounts,
627             uint8[] limitCounts
628         ) {
629 
630         uint tokenCount = totalSupply();
631         uint length = balanceOf(_of);
632         uint pointer;
633 
634         tokens = new uint[](length);
635         startedAt = new uint[](length);
636         completedAt = new uint[](length);
637         currentCounts = new uint8[](length);
638         limitCounts = new uint8[](length);
639 
640         for(uint index = 0; index < tokenCount; index++) {
641             uint tokenId = bitpaintingStorage.getPaintingIdAtIndex(index);
642 
643             if (tokenId == 0) {
644                 continue;
645             }
646 
647             if (_ownerOf(tokenId) != _of) {
648                 continue;
649             }
650 
651             if (bitpaintingStorage.isReady(tokenId)) {
652                 continue;
653             }
654 
655             uint _startedAt;
656             uint _completedAt;
657             (,,_startedAt, _completedAt,,) = bitpaintingStorage.getPainting(tokenId);
658             uint8 _current;
659             uint8 _limit;
660             (_current, _limit) = counter(tokenId);
661 
662             tokens[pointer] = tokenId;
663             startedAt[pointer] = _startedAt;
664             completedAt[pointer] = _completedAt;
665             currentCounts[pointer] = _current;
666             limitCounts[pointer] = _limit;
667 
668             pointer++;
669         }
670     }
671 
672     function counter(uint _tokenId) public
673         constant returns (uint8 current, uint8 limit) {
674 
675         uint8 gen = bitpaintingStorage.getPaintingGeneration(_tokenId);
676         if (gen == 0) {
677             current = 1;
678             limit = 1;
679         } else {
680             uint original = bitpaintingStorage.getPaintingOriginal(_tokenId);
681             uint8[3] memory counts = bitpaintingStorage.getEditionsCount(original);
682             uint8[3] memory limits = bitpaintingStorage.getEditionLimits(original);
683             current = counts[gen - 1];
684             limit = limits[gen - 1];
685         }
686     }
687 
688     function signature() external constant returns (uint _signature) {
689         return uint(keccak256("editions"));
690     }
691 
692 }