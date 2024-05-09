1 pragma solidity ^0.4.15;
2 
3 // File: contracts/libs/Ownable.sol
4 
5 /**
6 * @title Ownable
7 * @dev Manages ownership of the contracts
8 */
9 contract Ownable {
10 
11     address public owner;
12 
13     function Ownable() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function isOwner(address _address) public constant returns (bool) {
23         return _address == owner;
24     }
25 
26     function transferOwnership(address newOwner) external onlyOwner {
27         require(newOwner != address(0));
28         owner = newOwner;
29     }
30 
31 }
32 
33 // File: contracts/libs/Pausable.sol
34 
35 /**
36  * @title Pausable
37  * @dev Base contract which allows children to implement an emergency stop mechanism.
38  */
39 contract Pausable is Ownable {
40     event Pause();
41     event Unpause();
42 
43     bool public paused = false;
44 
45     /**
46     * @dev modifier to allow actions only when the contract IS paused
47     */
48     modifier whenNotPaused() {
49         require(!paused);
50         _;
51     }
52 
53     /**
54     * @dev modifier to allow actions only when the contract IS NOT paused
55     */
56     modifier whenPaused {
57         require(paused);
58         _;
59     }
60 
61     /**
62     * @dev called by the owner to pause, triggers stopped state
63     */
64     function _pause() internal whenNotPaused {
65         paused = true;
66         Pause();
67     }
68 
69     /**
70      * @dev called by the owner to unpause, returns to normal state
71      */
72     function _unpause() internal whenPaused {
73         paused = false;
74         Unpause();
75     }
76 }
77 
78 // File: contracts/libs/BaseStorage.sol
79 
80 contract BaseStorage is Pausable {
81 
82     event AccessAllowed(address _address);
83     event AccessDenied(address _address);
84 
85     mapping (address => bool) public allowed;
86     address public developer;
87 
88 
89     modifier canWrite() {
90         require(allowed[msg.sender] || isOwner(msg.sender)
91             || (msg.sender == developer));
92         _;
93     }
94 
95     function setDeveloper(address _address) public onlyOwner {
96         require(_address != address(0));
97         developer = _address;
98     }
99 
100     function allow(address _address) external canWrite {
101         require(_address != address(0));
102         allowed[_address] = true;
103         AccessAllowed(_address);
104     }
105 
106     function denied(address _address) external canWrite {
107         delete allowed[_address];
108         AccessDenied(_address);
109     }
110 
111     function isAllowed(address _address) external constant returns (bool) {
112         return allowed[_address];
113     }
114 }
115 
116 // File: contracts/libs/AccessControlStorage.sol
117 
118 contract AccessControlStorage is BaseStorage {
119 
120 
121     mapping (address => bool) public admins;
122     mapping (uint => address) public contracts;
123 
124     function addAdmin(address _address) public onlyOwner {
125         require(_address != address(0));
126         admins[_address] = true;
127     }
128 
129     function isAdmin(address _address) public constant returns (bool) {
130         return admins[_address];
131     }
132 
133     function removeAdmin(address _address) public onlyOwner {
134         require(_address != address(0));
135         delete admins[_address];
136     }
137 
138     function setContract(uint _signature, address _address) external canWrite {
139         contracts[_signature] = _address;
140     }
141 }
142 
143 // File: contracts/libs/AuctionStorage.sol
144 
145 contract AuctionStorage is BaseStorage {
146 
147     // Represents an auction on an NFT
148     struct Auction {
149         // Current owner of NFT
150         address seller;
151         // Price (in wei) at beginning of auction
152         uint128 startingPrice;
153         // Price (in wei) at end of auction
154         uint128 endingPrice;
155         // Duration (in seconds) of auction
156         uint64 duration;
157         // Time when auction started
158         // NOTE: 0 if this auction has been concluded
159         uint startedAt;
160         // true = started by team, false = started by ordinary user
161         bool byTeam;
162     }
163 
164     // Map from token ID to their corresponding auction.
165     mapping (uint => Auction) public tokenIdToAuction;
166     uint auctionsCounter = 0;
167     uint8 public secondarySaleCut = 4;
168 
169     function addAuction(
170         uint _tokenId,
171         uint _startingPrice,
172         uint _endingPrice,
173         uint _duration,
174         address _seller) public canWrite {
175         require(!_isOnAuction(_tokenId));
176         tokenIdToAuction[_tokenId] = Auction({
177             seller: _seller,
178             startingPrice: uint128(_startingPrice),
179             endingPrice: uint128(_endingPrice),
180             duration: uint64(_duration),
181             startedAt: now,
182             byTeam: false
183         });
184         auctionsCounter++;
185     }
186 
187     function initAuction(
188         uint _tokenId,
189         uint _startingPrice,
190         uint _endingPrice,
191         uint _startedAt,
192         uint _duration,
193         address _seller,
194         bool _byTeam) public canWrite {
195         require(!_isOnAuction(_tokenId));
196         tokenIdToAuction[_tokenId] = Auction({
197             seller: _seller,
198             startingPrice: uint128(_startingPrice),
199             endingPrice: uint128(_endingPrice),
200             duration: uint64(_duration),
201             startedAt: _startedAt,
202             byTeam: _byTeam
203         });
204         auctionsCounter++;
205     }
206 
207     function addReleaseAuction(
208         uint _tokenId,
209         uint _startingPrice,
210         uint _endingPrice,
211         uint _startedAt,
212         uint _duration) public canWrite {
213         bool _byTeam = true;
214         address _seller = owner;
215         initAuction(
216             _tokenId,
217             _startingPrice,
218             _endingPrice,
219             _startedAt,
220             _duration,
221             _seller,
222             _byTeam
223         );
224     }
225 
226     function _isOnAuction(uint _tokenId)
227         internal constant returns (bool) {
228         return (tokenIdToAuction[_tokenId].startedAt > 0);
229     }
230 
231     function isOnAuction(uint _tokenId)
232         external constant returns (bool) {
233         return _isOnAuction(_tokenId);
234     }
235 
236     function removeAuction(uint _tokenId) public canWrite {
237         require(_isOnAuction(_tokenId));
238         delete tokenIdToAuction[_tokenId];
239         auctionsCounter--;
240     }
241 
242     /// @dev Returns auction info for an NFT on auction.
243     /// @param _tokenId - ID of NFT on auction.
244     function getAuction(uint256 _tokenId)
245         external
246         constant
247         returns
248     (
249         address seller,
250         uint256 startingPrice,
251         uint256 endingPrice,
252         uint256 duration,
253         uint256 startedAt
254     ) {
255         Auction memory auction = tokenIdToAuction[_tokenId];
256         require(_isOnAuction(_tokenId));
257         return (
258             auction.seller,
259             auction.startingPrice,
260             auction.endingPrice,
261             auction.duration,
262             auction.startedAt
263         );
264     }
265 
266     function getAuctionSeller(uint256 _tokenId)
267         public constant returns (address) {
268         return tokenIdToAuction[_tokenId].seller;
269     }
270 
271     function getAuctionStartedAt(uint256 _tokenId)
272         public constant returns (uint) {
273         return tokenIdToAuction[_tokenId].startedAt;
274     }
275 
276     function getAuctionEnd(uint _tokenId)
277         public constant returns (uint) {
278         Auction memory auction = tokenIdToAuction[_tokenId];
279         return auction.startedAt + auction.duration;
280     }
281 
282     function getAuctionsCount() public constant returns (uint) {
283         return auctionsCounter;
284     }
285 
286     function canBeCanceled(uint _tokenId) external constant returns (bool) {
287         return getAuctionEnd(_tokenId) <= now;
288     }
289 
290     function isSecondary(uint _tokenId) public constant returns (bool _is) {
291         return (tokenIdToAuction[_tokenId].byTeam == false);
292     }
293 
294 }
295 
296 // File: contracts/libs/EditionStorage.sol
297 
298 contract EditionStorage is BaseStorage {
299 
300     uint public offset = 1000000;
301     uint public offsetIndex = 1;
302     uint8[3] public defaultEditionLimits = [10, 89, 200];
303     mapping (uint => mapping (uint8 => uint8)) public editionCounts;
304     mapping (uint => mapping (uint8 => uint8)) public editionLimits;
305     mapping (uint => uint) public lastEditionOf;
306 
307     function setOffset(uint _offset) external onlyOwner {
308         offset = _offset;
309     }
310 
311     function getOffsetIndex() public constant returns (uint) {
312         return offset + offsetIndex;
313     }
314 
315     function nextOffsetIndex() public canWrite {
316         offsetIndex++;
317     }
318 
319     function canCreateEdition(uint _tokenId, uint8 _generation)
320         public constant returns (bool) {
321         uint8 actual = editionCounts[_tokenId][_generation - 1];
322         uint limit = editionLimits[_tokenId][_generation - 1];
323         return (actual < limit);
324     }
325 
326     function isValidGeneration(uint8 _generation)
327         public constant returns (bool) {
328         return (_generation >= 1 && _generation <= 3);
329     }
330 
331     function increaseGenerationCount(uint _tokenId, uint8 _generation)
332         public canWrite {
333         require(canCreateEdition(_tokenId, _generation));
334         require(isValidGeneration(_generation));
335         uint8 _generationIndex = _generation - 1;
336         editionCounts[_tokenId][_generationIndex]++;
337     }
338 
339     function getEditionsCount(uint _tokenId)
340         external constant returns (uint8[3])  {
341         return [
342             editionCounts[_tokenId][0],
343             editionCounts[_tokenId][1],
344             editionCounts[_tokenId][2]
345         ];
346     }
347 
348     function setLastEditionOf(uint _tokenId, uint _editionId)
349         public canWrite {
350         lastEditionOf[_tokenId] = _editionId;
351     }
352 
353     function getEditionLimits(uint _tokenId)
354         external constant returns (uint8[3])  {
355         return [
356             editionLimits[_tokenId][0],
357             editionLimits[_tokenId][1],
358             editionLimits[_tokenId][2]
359         ];
360     }
361 
362 
363 }
364 
365 // File: contracts/libs/PaintingInformationStorage.sol
366 
367 contract PaintingInformationStorage {
368 
369     struct PaintingInformation {
370         string name;
371         string artist;
372     }
373 
374     mapping (uint => PaintingInformation) public information;
375 }
376 
377 // File: contracts/libs/PaintingStorage.sol
378 
379 contract PaintingStorage is BaseStorage {
380 
381     struct Painting {
382         uint parentId;
383         uint originalId;
384         uint createdAt;
385         uint completedAt;
386         uint8 generation;
387         uint8 speedIndex;
388         uint artistId;
389         uint releasedAt;
390         bool isFinal;
391     }
392 
393     uint32[10] public speeds = [
394         uint32(8760 hours), // 365 days
395         uint32(6480 hours), // 270 days
396         uint32(4320 hours), // 180 days
397         uint32(2880 hours), // 120 days
398         uint32(1920 hours), // 80 days
399         uint32(960 hours), // 40 days
400         uint32(480 hours), // 20 days
401         uint32(240 hours), // 10 days
402         uint32(120 hours), // 5 days
403         uint32(24 hours) // 1 day
404     ];
405 
406     uint32[10] public speedsTest = [
407         uint32(8760 seconds),
408         uint32(6480 seconds),
409         uint32(4320 seconds),
410         uint32(2880 seconds),
411         uint32(1920 seconds),
412         uint32(960 seconds),
413         uint32(480 seconds),
414         uint32(240 seconds),
415         uint32(120 seconds),
416         uint32(24 seconds)
417     ];
418 
419     uint32[10] public speedsDev = [
420         uint32(0 seconds),
421         uint32(0 seconds),
422         uint32(0 seconds),
423         uint32(0 seconds),
424         uint32(0 seconds),
425         uint32(0 seconds),
426         uint32(0 seconds),
427         uint32(0 seconds),
428         uint32(0 seconds),
429         uint32(0 seconds)
430     ];
431 
432     mapping (uint => address) public paintingIndexToOwner;
433     mapping (uint => Painting) public paintings;
434     mapping (uint => address) public paintingIndexToApproved;
435     uint[] public paintingIds;
436     mapping (uint => uint) public paintingIdToIndex;
437     uint public paintingsCount;
438     uint public totalPaintingsCount;
439     mapping (uint => bool) public isCanceled;
440     mapping (uint => bool) public isReleased;
441 
442     // @dev A mapping from owner address to count of tokens that address owns.
443     // Used internally inside balanceOf() to resolve ownership count.
444     mapping (address => uint256) public ownershipTokenCount;
445 
446     modifier isNew(uint _tokenId) {
447         require(paintings[_tokenId].createdAt == 0);
448         _;
449     }
450 
451     function exists(uint _tokenId) external constant returns (bool) {
452         return paintings[_tokenId].createdAt != 0;
453     }
454 
455     function increaseOwnershipTokenCount(address _address) public canWrite {
456         ownershipTokenCount[_address]++;
457     }
458 
459     function decreaseOwnershipTokenCount(address _address) public canWrite {
460         ownershipTokenCount[_address]--;
461     }
462 
463     function setOwnership(uint _tokenId, address _address) public canWrite {
464         paintingIndexToOwner[_tokenId] = _address;
465     }
466 
467     function getPainting(uint _tokenId) external constant returns (
468         address owner,
469         uint parent,
470         uint createdAt,
471         uint completedAt,
472         uint8 generation,
473         uint8 speed) {
474         return (
475             paintingIndexToOwner[_tokenId],
476             paintings[_tokenId].parentId,
477             paintings[_tokenId].createdAt,
478             paintings[_tokenId].completedAt,
479             paintings[_tokenId].generation,
480             paintings[_tokenId].speedIndex + 1
481         );
482     }
483 
484     function approve(uint _tokenId, address _claimant) external canWrite {
485         paintingIndexToApproved[_tokenId] = _claimant;
486     }
487 
488     function isApprovedFor(uint _tokenId, address _claimant) external constant returns (bool) {
489         return paintingIndexToApproved[_tokenId] == _claimant;
490     }
491 
492     function decreaseSpeed(uint _tokenId) public canWrite() {
493         uint8 _speed = paintings[_tokenId].speedIndex;
494 
495         if (_speed > 0) {
496             paintings[_tokenId].speedIndex--;
497         }
498     }
499 
500     function getPaintingOwner(uint _tokenId)
501         external constant returns (address) {
502         return paintingIndexToOwner[_tokenId];
503     }
504 
505     function getPaintingGeneration(uint _tokenId)
506         public constant returns (uint8) {
507         return paintings[_tokenId].generation;
508     }
509 
510     function getPaintingArtistId(uint _tokenId)
511         public constant returns (uint artistId) {
512         return paintings[_tokenId].artistId;
513     }
514 
515     function getPaintingSpeed(uint _tokenId)
516         external constant returns (uint8) {
517         return paintings[_tokenId].speedIndex + 1;
518     }
519 
520     function getPaintingOriginal(uint _tokenId)
521         external constant returns (uint) {
522         return paintings[_tokenId].originalId;
523     }
524 
525     function getOwnershipTokenCount(address _address)
526         external constant returns (uint) {
527         return ownershipTokenCount[_address];
528     }
529 
530     function isReady(uint _tokenId)
531         public constant returns (bool) {
532         return paintings[_tokenId].completedAt <= now;
533     }
534 
535     function getPaintingIdAtIndex(uint _index)
536         public constant returns (uint) {
537         return paintingIds[_index];
538     }
539 
540     function canBeChanged(uint _tokenId) public constant returns (bool _can) {
541         return paintings[_tokenId].isFinal == false;
542     }
543 
544     function sealForChanges(uint _tokenId) public canWrite {
545         if (paintings[_tokenId].isFinal == false) {
546             paintings[_tokenId].isFinal = true;
547         }
548     }
549 
550     function canBeBidden(uint _tokenId) public constant returns (bool _can) {
551         return (paintings[_tokenId].releasedAt <= now);
552     }
553 
554 }
555 
556 // File: contracts/BitpaintingStorage.sol
557 
558 contract BitpaintingStorage is PaintingStorage, PaintingInformationStorage, AccessControlStorage, AuctionStorage, EditionStorage {
559 
560     /// 0 = production mode
561     /// 1 = testing mode
562     /// 2 = development mode
563     uint8 mode;
564 
565     function BitpaintingStorage(uint8 _mode) public {
566         require(_mode >= 0 && _mode <=2);
567         mode = _mode;
568     }
569 
570     function hasEditionInProgress(uint _tokenId)
571         external constant returns (bool) {
572         uint edition = lastEditionOf[_tokenId];
573         if (edition == 0) {
574             return false;
575         }
576 
577         return !isReady(edition);
578     }
579 
580     function hasEmptyEditionSlots(uint _tokenId)
581         external constant returns (bool) {
582         uint originalId = paintings[_tokenId].originalId;
583         if (originalId == 0) {
584             originalId = _tokenId;
585         }
586         uint8 generation = paintings[_tokenId].generation;
587         uint8 limit = editionLimits[originalId][generation];
588         uint8 current = editionCounts[originalId][generation];
589         return (current < limit);
590     }
591 
592     function resetPainting(uint _tokenId) public canWrite {
593         require(canBeChanged(_tokenId));
594 
595         isCanceled[_tokenId] = true;
596         paintingsCount--;
597         delete paintings[_tokenId];
598     }
599 
600     function createPainting(
601         address _owner,
602         uint _tokenId,
603         uint _parentId,
604         uint8 _generation,
605         uint8 _speed,
606         uint _artistId,
607         uint _releasedAt
608     ) public isNew(_tokenId) canWrite {
609         require(now <= _releasedAt);
610         require(_speed >= 1 && _speed <= 10);
611         _speed--;
612 
613         uint _createdAt = now;
614         uint _completedAt;
615         if (_generation == 0) {
616             _completedAt = now;
617         } else {
618             uint _parentSpeed = paintings[_parentId].speedIndex;
619             if (mode == 2) {
620                 _completedAt = now + speedsDev[_parentSpeed];
621             } else {
622                 if (mode == 1) {
623                     _completedAt = now + speedsTest[_parentSpeed];
624                 } else {
625                     _completedAt = now + speeds[_parentSpeed];
626                 }
627             }
628         }
629 
630         uint _originalId;
631         if (_generation == 0) {
632             _originalId = _tokenId;
633         } else {
634             if (_generation == 1) {
635                 _originalId = _parentId;
636             } else {
637                 _originalId = paintings[_parentId].originalId;
638             }
639         }
640 
641         paintings[_tokenId] = Painting({
642             parentId: _parentId,
643             originalId: _originalId,
644             createdAt: _createdAt,
645             generation: _generation,
646             speedIndex: _speed,
647             completedAt: _completedAt,
648             artistId: _artistId,
649             releasedAt: _releasedAt,
650             isFinal: (_generation != 0) // if generation == 1 or 2 or 3, so it cannot be changed
651         });
652 
653         if (!isReleased[_tokenId]) {
654             isReleased[_tokenId] = true;
655             paintingIds.push(_tokenId);
656             paintingIdToIndex[_tokenId] = totalPaintingsCount;
657             increaseOwnershipTokenCount(_owner);
658             totalPaintingsCount++;
659         }
660         isCanceled[_tokenId] = false;
661         setOwnership(_tokenId, _owner);
662         paintingsCount++;
663     }
664 
665     function setEditionLimits(
666         uint _tokenId,
667         uint8 _gen1,
668         uint8 _gen2,
669         uint8 _gen3)
670         public canWrite {
671         require(canBeChanged(_tokenId));
672 
673         editionLimits[_tokenId][0] = _gen1;
674         editionLimits[_tokenId][1] = _gen2;
675         editionLimits[_tokenId][2] = _gen3;
676     }
677 
678     function resetEditionLimits(uint _tokenId) public canWrite {
679         setEditionLimits(_tokenId, 0, 0, 0);
680     }
681 
682     function createEditionMeta(uint _tokenId) public canWrite {
683         uint _originalId = paintings[_tokenId].originalId;
684         nextOffsetIndex();
685         uint editionId = getOffsetIndex();
686         setLastEditionOf(_tokenId, editionId);
687 
688         uint8 _generation = getPaintingGeneration(_tokenId) + 1;
689         increaseGenerationCount(_originalId, _generation);
690     }
691 
692     function purgeInformation(uint _tokenId) public canWrite {
693         require(canBeChanged(_tokenId));
694 
695         delete information[_tokenId];
696     }
697 
698     function setPaintingName(uint _tokenId, string _name) public canWrite {
699         information[_tokenId].name = _name;
700     }
701 
702     function setPaintingArtist(uint _tokenId, string _name) public canWrite {
703         information[_tokenId].artist = _name;
704     }
705 
706     function getTokensOnAuction() public constant returns (uint[] tokens) {
707         tokens = new uint[](auctionsCounter);
708         uint pointer = 0;
709 
710         for(uint index = 0; index < totalPaintingsCount; index++) {
711             uint tokenId = getPaintingIdAtIndex(index);
712 
713             if (isCanceled[tokenId]) {
714                 continue;
715             }
716 
717             if (!_isOnAuction(tokenId)) {
718                 continue;
719             }
720 
721             tokens[pointer] = tokenId;
722             pointer++;
723         }
724     }
725 
726     function getPaintingName(uint _tokenId) public constant returns (string) {
727         uint id = paintings[_tokenId].originalId;
728         return information[id].name;
729     }
730 
731     function getPaintingArtist(uint _tokenId)
732         public constant returns (string) {
733         uint id = paintings[_tokenId].originalId;
734         return information[id].artist;
735     }
736 
737     function signature() external constant returns (bytes4) {
738         return bytes4(keccak256("storage"));
739     }
740 
741 
742 }