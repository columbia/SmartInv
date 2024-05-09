1 // SPDX-License-Identifier: MIT                                          
2 
3 
4 
5 /*
6  ▄█     █▄     ▄████████       ▄█     █▄   ▄█   ▄█        ▄█               ▄████████  ▄██████▄   ▄████████    ▄█   ▄█▄ 
7 ███     ███   ███    ███      ███     ███ ███  ███       ███              ███    ███ ███    ███ ███    ███   ███ ▄███▀ 
8 ███     ███   ███    █▀       ███     ███ ███▌ ███       ███              ███    ███ ███    ███ ███    █▀    ███▐██▀   
9 ███     ███  ▄███▄▄▄          ███     ███ ███▌ ███       ███             ▄███▄▄▄▄██▀ ███    ███ ███         ▄█████▀    
10 ███     ███ ▀▀███▀▀▀          ███     ███ ███▌ ███       ███            ▀▀███▀▀▀▀▀   ███    ███ ███        ▀▀█████▄    
11 ███     ███   ███    █▄       ███     ███ ███  ███       ███            ▀███████████ ███    ███ ███    █▄    ███▐██▄   
12 ███ ▄█▄ ███   ███    ███      ███ ▄█▄ ███ ███  ███▌    ▄ ███▌    ▄        ███    ███ ███    ███ ███    ███   ███ ▀███▄ 
13  ▀███▀███▀    ██████████       ▀███▀███▀  █▀   █████▄▄██ █████▄▄██        ███    ███  ▀██████▀  ████████▀    ███   ▀█▀ 
14                                                ▀         ▀                ███    ███                         ▀         
15 */
16 
17 
18 
19 pragma solidity ^0.8.0;
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 pragma solidity ^0.8.0;
31 abstract contract Ownable is Context {
32     address private _owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     constructor() {
37         _transferOwnership(_msgSender());
38     }
39 
40     modifier onlyOwner() {
41         _checkOwner();
42         _;
43     }
44 
45     function owner() public view virtual returns (address) {
46         return _owner;
47     }
48 
49     function _checkOwner() internal view virtual {
50         require(owner() == _msgSender(), "Ownable: caller is not the owner");
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         _transferOwnership(address(0));
55     }
56 
57 
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         _transferOwnership(newOwner);
61     }
62 
63     function _transferOwnership(address newOwner) internal virtual {
64         address oldOwner = _owner;
65         _owner = newOwner;
66         emit OwnershipTransferred(oldOwner, newOwner);
67     }
68 }
69 
70 pragma solidity ^0.8.0;
71 
72 abstract contract ReentrancyGuard {
73 
74     uint256 private constant _NOT_ENTERED = 1;
75     uint256 private constant _ENTERED = 2;
76 
77     uint256 private _status;
78 
79     constructor() {
80         _status = _NOT_ENTERED;
81     }
82 
83     modifier nonReentrant() {
84         // On the first call to nonReentrant, _notEntered will be true
85         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
86 
87         // Any calls to nonReentrant after this point will fail
88         _status = _ENTERED;
89 
90         _;
91 
92         _status = _NOT_ENTERED;
93     }
94 }
95 
96 pragma solidity ^0.8.0;
97 
98 library Strings {
99     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
100     uint8 private constant _ADDRESS_LENGTH = 20;
101 
102     function toString(uint256 value) internal pure returns (string memory) {
103 
104         if (value == 0) {
105             return "0";
106         }
107         uint256 temp = value;
108         uint256 digits;
109         while (temp != 0) {
110             digits++;
111             temp /= 10;
112         }
113         bytes memory buffer = new bytes(digits);
114         while (value != 0) {
115             digits -= 1;
116             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
117             value /= 10;
118         }
119         return string(buffer);
120     }
121 
122     function toHexString(uint256 value) internal pure returns (string memory) {
123         if (value == 0) {
124             return "0x00";
125         }
126         uint256 temp = value;
127         uint256 length = 0;
128         while (temp != 0) {
129             length++;
130             temp >>= 8;
131         }
132         return toHexString(value, length);
133     }
134 
135     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
136         bytes memory buffer = new bytes(2 * length + 2);
137         buffer[0] = "0";
138         buffer[1] = "x";
139         for (uint256 i = 2 * length + 1; i > 1; --i) {
140             buffer[i] = _HEX_SYMBOLS[value & 0xf];
141             value >>= 4;
142         }
143         require(value == 0, "Strings: hex length insufficient");
144         return string(buffer);
145     }
146 
147     function toHexString(address addr) internal pure returns (string memory) {
148         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
149     }
150 }
151 
152 pragma solidity ^0.8.0;
153 
154 
155 library EnumerableSet {
156 
157 
158     struct Set {
159         // Storage of set values
160         bytes32[] _values;
161 
162         mapping(bytes32 => uint256) _indexes;
163     }
164 
165     function _add(Set storage set, bytes32 value) private returns (bool) {
166         if (!_contains(set, value)) {
167             set._values.push(value);
168 
169             set._indexes[value] = set._values.length;
170             return true;
171         } else {
172             return false;
173         }
174     }
175 
176     function _remove(Set storage set, bytes32 value) private returns (bool) {
177 
178         uint256 valueIndex = set._indexes[value];
179 
180         if (valueIndex != 0) {
181 
182             uint256 toDeleteIndex = valueIndex - 1;
183             uint256 lastIndex = set._values.length - 1;
184 
185             if (lastIndex != toDeleteIndex) {
186                 bytes32 lastValue = set._values[lastIndex];
187 
188                 set._values[toDeleteIndex] = lastValue;
189                 
190                 set._indexes[lastValue] = valueIndex; 
191             }
192 
193             // Delete the slot where the moved value was stored
194             set._values.pop();
195 
196             // Delete the index for the deleted slot
197             delete set._indexes[value];
198 
199             return true;
200         } else {
201             return false;
202         }
203     }
204 
205     function _contains(Set storage set, bytes32 value) private view returns (bool) {
206         return set._indexes[value] != 0;
207     }
208 
209     function _length(Set storage set) private view returns (uint256) {
210         return set._values.length;
211     }
212 
213     function _at(Set storage set, uint256 index) private view returns (bytes32) {
214         return set._values[index];
215     }
216 
217     function _values(Set storage set) private view returns (bytes32[] memory) {
218         return set._values;
219     }
220 
221     struct Bytes32Set {
222         Set _inner;
223     }
224 
225     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
226         return _add(set._inner, value);
227     }
228 
229     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
230         return _remove(set._inner, value);
231     }
232 
233     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
234         return _contains(set._inner, value);
235     }
236 
237     function length(Bytes32Set storage set) internal view returns (uint256) {
238         return _length(set._inner);
239     }
240 
241     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
242         return _at(set._inner, index);
243     }
244 
245     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
246         return _values(set._inner);
247     }
248 
249     struct AddressSet {
250         Set _inner;
251     }
252 
253     function add(AddressSet storage set, address value) internal returns (bool) {
254         return _add(set._inner, bytes32(uint256(uint160(value))));
255     }
256 
257     function remove(AddressSet storage set, address value) internal returns (bool) {
258         return _remove(set._inner, bytes32(uint256(uint160(value))));
259     }
260 
261     function contains(AddressSet storage set, address value) internal view returns (bool) {
262         return _contains(set._inner, bytes32(uint256(uint160(value))));
263     }
264 
265     function length(AddressSet storage set) internal view returns (uint256) {
266         return _length(set._inner);
267     }
268 
269     function at(AddressSet storage set, uint256 index) internal view returns (address) {
270         return address(uint160(uint256(_at(set._inner, index))));
271     }
272 
273     function values(AddressSet storage set) internal view returns (address[] memory) {
274         bytes32[] memory store = _values(set._inner);
275         address[] memory result;
276 
277         assembly {
278             result := store
279         }
280 
281         return result;
282     }
283 
284     struct UintSet {
285         Set _inner;
286     }
287 
288     function add(UintSet storage set, uint256 value) internal returns (bool) {
289         return _add(set._inner, bytes32(value));
290     }
291 
292     function remove(UintSet storage set, uint256 value) internal returns (bool) {
293         return _remove(set._inner, bytes32(value));
294     }
295 
296     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
297         return _contains(set._inner, bytes32(value));
298     }
299 
300     function length(UintSet storage set) internal view returns (uint256) {
301         return _length(set._inner);
302     }
303 
304     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
305         return uint256(_at(set._inner, index));
306     }
307 
308     function values(UintSet storage set) internal view returns (uint256[] memory) {
309         bytes32[] memory store = _values(set._inner);
310         uint256[] memory result;
311 
312         /// @solidity memory-safe-assembly
313         assembly {
314             result := store
315         }
316 
317         return result;
318     }
319 }
320 
321 pragma solidity ^0.8.4;
322 
323 interface IERC721A {
324 
325     error ApprovalCallerNotOwnerNorApproved();
326 
327     error ApprovalQueryForNonexistentToken();
328 
329     error BalanceQueryForZeroAddress();
330 
331     error MintToZeroAddress();
332 
333     error MintZeroQuantity();
334 
335     error OwnerQueryForNonexistentToken();
336 
337     error TransferCallerNotOwnerNorApproved();
338 
339     error TransferFromIncorrectOwner();
340 
341     error TransferToNonERC721ReceiverImplementer();
342 
343     error TransferToZeroAddress();
344 
345     error URIQueryForNonexistentToken();
346 
347     error MintERC2309QuantityExceedsLimit();
348 
349     error OwnershipNotInitializedForExtraData();
350 
351     struct TokenOwnership {
352 
353         address addr;
354 
355         uint64 startTimestamp;
356 
357         bool burned;
358 
359         uint24 extraData;
360     }
361 
362     function totalSupply() external view returns (uint256);
363 
364     function supportsInterface(bytes4 interfaceId) external view returns (bool);
365 
366     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
367 
368     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
369 
370     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
371 
372     function balanceOf(address owner) external view returns (uint256 balance);
373 
374     function ownerOf(uint256 tokenId) external view returns (address owner);
375 
376     function safeTransferFrom(
377         address from,
378         address to,
379         uint256 tokenId,
380         bytes calldata data
381     ) external payable;
382 
383     function safeTransferFrom(
384         address from,
385         address to,
386         uint256 tokenId
387     ) external payable;
388 
389     function transferFrom(
390         address from,
391         address to,
392         uint256 tokenId
393     ) external payable;
394 
395     function approve(address to, uint256 tokenId) external payable;
396 
397     function setApprovalForAll(address operator, bool _approved) external;
398 
399     function getApproved(uint256 tokenId) external view returns (address operator);
400 
401     function isApprovedForAll(address owner, address operator) external view returns (bool);
402 
403     function name() external view returns (string memory);
404 
405     function symbol() external view returns (string memory);
406 
407     function tokenURI(uint256 tokenId) external view returns (string memory);
408 
409     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
410 }
411 
412 pragma solidity ^0.8.4;
413 
414 interface ERC721A__IERC721Receiver {
415     function onERC721Received(
416         address operator,
417         address from,
418         uint256 tokenId,
419         bytes calldata data
420     ) external returns (bytes4);
421 }
422 
423 contract ERC721A is IERC721A {
424 
425     struct TokenApprovalRef {
426         address value;
427     }
428 
429     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
430 
431     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
432 
433     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
434 
435     uint256 private constant _BITPOS_AUX = 192;
436 
437     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
438 
439     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
440 
441     uint256 private constant _BITMASK_BURNED = 1 << 224;
442 
443     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
444 
445     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
446 
447     uint256 private constant _BITPOS_EXTRA_DATA = 232;
448 
449     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
450 
451     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
452 
453     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
454 
455     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
456         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
457 
458     uint256 private _currentIndex;
459 
460     uint256 private _burnCounter;
461 
462     string private _name;
463 
464     string private _symbol;
465 
466     mapping(uint256 => uint256) private _packedOwnerships;
467 
468     mapping(address => uint256) private _packedAddressData;
469 
470     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
471 
472     mapping(address => mapping(address => bool)) private _operatorApprovals;
473 
474     constructor(string memory name_, string memory symbol_) {
475         _name = name_;
476         _symbol = symbol_;
477         _currentIndex = _startTokenId();
478     }
479 
480     function _startTokenId() internal view virtual returns (uint256) {
481         return 0;
482     }
483 
484     function _nextTokenId() internal view virtual returns (uint256) {
485         return _currentIndex;
486     }
487 
488     function totalSupply() public view virtual override returns (uint256) {
489 
490         unchecked {
491             return _currentIndex - _burnCounter - _startTokenId();
492         }
493     }
494 
495     function _totalMinted() internal view virtual returns (uint256) {
496 
497         unchecked {
498             return _currentIndex - _startTokenId();
499         }
500     }
501 
502     function _totalBurned() internal view virtual returns (uint256) {
503         return _burnCounter;
504     }
505 
506     function balanceOf(address owner) public view virtual override returns (uint256) {
507         if (owner == address(0)) revert BalanceQueryForZeroAddress();
508         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
509     }
510 
511     function _numberMinted(address owner) internal view returns (uint256) {
512         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
513     }
514 
515     function _numberBurned(address owner) internal view returns (uint256) {
516         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
517     }
518 
519     function _getAux(address owner) internal view returns (uint64) {
520         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
521     }
522 
523     function _setAux(address owner, uint64 aux) internal virtual {
524         uint256 packed = _packedAddressData[owner];
525         uint256 auxCasted;
526         // Cast `aux` with assembly to avoid redundant masking.
527         assembly {
528             auxCasted := aux
529         }
530         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
531         _packedAddressData[owner] = packed;
532     }
533 
534 
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536 
537         return
538             interfaceId == 0x01ffc9a7 || 
539             interfaceId == 0x80ac58cd || 
540             interfaceId == 0x5b5e139f; 
541     }
542 
543     function name() public view virtual override returns (string memory) {
544         return _name;
545     }
546 
547     function symbol() public view virtual override returns (string memory) {
548         return _symbol;
549     }
550 
551     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
552         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
553 
554         string memory baseURI = _baseURI();
555         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
556     }
557 
558     function _baseURI() internal view virtual returns (string memory) {
559         return '';
560     }
561 
562     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
563         return address(uint160(_packedOwnershipOf(tokenId)));
564     }
565 
566     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
567         return _unpackedOwnership(_packedOwnershipOf(tokenId));
568     }
569 
570     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
571         return _unpackedOwnership(_packedOwnerships[index]);
572     }
573 
574     function _initializeOwnershipAt(uint256 index) internal virtual {
575         if (_packedOwnerships[index] == 0) {
576             _packedOwnerships[index] = _packedOwnershipOf(index);
577         }
578     }
579 
580     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
581         uint256 curr = tokenId;
582 
583         unchecked {
584             if (_startTokenId() <= curr)
585                 if (curr < _currentIndex) {
586                     uint256 packed = _packedOwnerships[curr];
587 
588                     if (packed & _BITMASK_BURNED == 0) {
589 
590                         while (packed == 0) {
591                             packed = _packedOwnerships[--curr];
592                         }
593                         return packed;
594                     }
595                 }
596         }
597         revert OwnerQueryForNonexistentToken();
598     }
599 
600     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
601         ownership.addr = address(uint160(packed));
602         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
603         ownership.burned = packed & _BITMASK_BURNED != 0;
604         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
605     }
606 
607     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
608         assembly {
609             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
610             owner := and(owner, _BITMASK_ADDRESS)
611             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
612             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
613         }
614     }
615 
616     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
617         // For branchless setting of the `nextInitialized` flag.
618         assembly {
619             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
620             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
621         }
622     }
623 
624     function approve(address to, uint256 tokenId) public payable virtual override {
625         address owner = ownerOf(tokenId);
626 
627         if (_msgSenderERC721A() != owner)
628             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
629                 revert ApprovalCallerNotOwnerNorApproved();
630             }
631 
632         _tokenApprovals[tokenId].value = to;
633         emit Approval(owner, to, tokenId);
634     }
635 
636     function getApproved(uint256 tokenId) public view virtual override returns (address) {
637         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
638 
639         return _tokenApprovals[tokenId].value;
640     }
641 
642     function setApprovalForAll(address operator, bool approved) public virtual override {
643         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
644         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
645     }
646 
647     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
648         return _operatorApprovals[owner][operator];
649     }
650 
651     function _exists(uint256 tokenId) internal view virtual returns (bool) {
652         return
653             _startTokenId() <= tokenId &&
654             tokenId < _currentIndex && // If within bounds,
655             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
656     }
657 
658     function _isSenderApprovedOrOwner(
659         address approvedAddress,
660         address owner,
661         address msgSender
662     ) private pure returns (bool result) {
663         assembly {
664 
665             owner := and(owner, _BITMASK_ADDRESS)
666 
667             msgSender := and(msgSender, _BITMASK_ADDRESS)
668 
669             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
670         }
671     }
672 
673     function _getApprovedSlotAndAddress(uint256 tokenId)
674         private
675         view
676         returns (uint256 approvedAddressSlot, address approvedAddress)
677     {
678         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
679 
680         assembly {
681             approvedAddressSlot := tokenApproval.slot
682             approvedAddress := sload(approvedAddressSlot)
683         }
684     }
685 
686     function transferFrom(
687         address from,
688         address to,
689         uint256 tokenId
690     ) public payable virtual override {
691         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
692 
693         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
694 
695         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
696 
697         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
698             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
699 
700         if (to == address(0)) revert TransferToZeroAddress();
701 
702         _beforeTokenTransfers(from, to, tokenId, 1);
703 
704         assembly {
705             if approvedAddress {
706 
707                 sstore(approvedAddressSlot, 0)
708             }
709         }
710 
711         unchecked {
712 
713             --_packedAddressData[from]; 
714             ++_packedAddressData[to]; 
715 
716             _packedOwnerships[tokenId] = _packOwnershipData(
717                 to,
718                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
719             );
720 
721             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
722                 uint256 nextTokenId = tokenId + 1;
723 
724                 if (_packedOwnerships[nextTokenId] == 0) {
725 
726                     if (nextTokenId != _currentIndex) {
727 
728                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
729                     }
730                 }
731             }
732         }
733 
734         emit Transfer(from, to, tokenId);
735         _afterTokenTransfers(from, to, tokenId, 1);
736     }
737 
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId
742     ) public payable virtual override {
743         safeTransferFrom(from, to, tokenId, '');
744     }
745 
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes memory _data
751     ) public payable virtual override {
752         transferFrom(from, to, tokenId);
753         if (to.code.length != 0)
754             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
755                 revert TransferToNonERC721ReceiverImplementer();
756             }
757     }
758 
759     function _beforeTokenTransfers(
760         address from,
761         address to,
762         uint256 startTokenId,
763         uint256 quantity
764     ) internal virtual {}
765 
766     function _afterTokenTransfers(
767         address from,
768         address to,
769         uint256 startTokenId,
770         uint256 quantity
771     ) internal virtual {}
772 
773     function _checkContractOnERC721Received(
774         address from,
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) private returns (bool) {
779         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
780             bytes4 retval
781         ) {
782             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
783         } catch (bytes memory reason) {
784             if (reason.length == 0) {
785                 revert TransferToNonERC721ReceiverImplementer();
786             } else {
787                 assembly {
788                     revert(add(32, reason), mload(reason))
789                 }
790             }
791         }
792     }
793 
794     function _mint(address to, uint256 quantity) internal virtual {
795         uint256 startTokenId = _currentIndex;
796         if (quantity == 0) revert MintZeroQuantity();
797 
798         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
799 
800         unchecked {
801 
802             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
803 
804             _packedOwnerships[startTokenId] = _packOwnershipData(
805                 to,
806                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
807             );
808 
809             uint256 toMasked;
810             uint256 end = startTokenId + quantity;
811 
812             assembly {
813 
814                 toMasked := and(to, _BITMASK_ADDRESS)
815 
816                 log4(
817                     0, 
818                     0, 
819                     _TRANSFER_EVENT_SIGNATURE, 
820                     0, 
821                     toMasked, 
822                     startTokenId 
823                 )
824 
825                 for {
826                     let tokenId := add(startTokenId, 1)
827                 } iszero(eq(tokenId, end)) {
828                     tokenId := add(tokenId, 1)
829                 } {
830 
831                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
832                 }
833             }
834             if (toMasked == 0) revert MintToZeroAddress();
835 
836             _currentIndex = end;
837         }
838         _afterTokenTransfers(address(0), to, startTokenId, quantity);
839     }
840 
841     function _mintERC2309(address to, uint256 quantity) internal virtual {
842         uint256 startTokenId = _currentIndex;
843         if (to == address(0)) revert MintToZeroAddress();
844         if (quantity == 0) revert MintZeroQuantity();
845         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
846 
847         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
848 
849         unchecked {
850 
851             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
852 
853             _packedOwnerships[startTokenId] = _packOwnershipData(
854                 to,
855                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
856             );
857 
858             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
859 
860             _currentIndex = startTokenId + quantity;
861         }
862         _afterTokenTransfers(address(0), to, startTokenId, quantity);
863     }
864 
865     function _safeMint(
866         address to,
867         uint256 quantity,
868         bytes memory _data
869     ) internal virtual {
870         _mint(to, quantity);
871 
872         unchecked {
873             if (to.code.length != 0) {
874                 uint256 end = _currentIndex;
875                 uint256 index = end - quantity;
876                 do {
877                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
878                         revert TransferToNonERC721ReceiverImplementer();
879                     }
880                 } while (index < end);
881                 // Reentrancy protection.
882                 if (_currentIndex != end) revert();
883             }
884         }
885     }
886 
887     function _safeMint(address to, uint256 quantity) internal virtual {
888         _safeMint(to, quantity, '');
889     }
890 
891     function _burn(uint256 tokenId) internal virtual {
892         _burn(tokenId, false);
893     }
894 
895     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
896         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
897 
898         address from = address(uint160(prevOwnershipPacked));
899 
900         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
901 
902         if (approvalCheck) {
903             
904             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
905                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
906         }
907 
908         _beforeTokenTransfers(from, address(0), tokenId, 1);
909 
910         assembly {
911             if approvedAddress {
912                 
913                 sstore(approvedAddressSlot, 0)
914             }
915         }
916 
917         unchecked {
918 
919             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
920 
921             _packedOwnerships[tokenId] = _packOwnershipData(
922                 from,
923                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
924             );
925 
926             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
927                 uint256 nextTokenId = tokenId + 1;
928 
929                 if (_packedOwnerships[nextTokenId] == 0) {
930 
931                     if (nextTokenId != _currentIndex) {
932 
933                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
934                     }
935                 }
936             }
937         }
938 
939         emit Transfer(from, address(0), tokenId);
940         _afterTokenTransfers(from, address(0), tokenId, 1);
941 
942         unchecked {
943             _burnCounter++;
944         }
945     }
946 
947     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
948         uint256 packed = _packedOwnerships[index];
949         if (packed == 0) revert OwnershipNotInitializedForExtraData();
950         uint256 extraDataCasted;
951         assembly {
952             extraDataCasted := extraData
953         }
954         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
955         _packedOwnerships[index] = packed;
956     }
957 
958     function _extraData(
959         address from,
960         address to,
961         uint24 previousExtraData
962     ) internal view virtual returns (uint24) {}
963 
964     function _nextExtraData(
965         address from,
966         address to,
967         uint256 prevOwnershipPacked
968     ) private view returns (uint256) {
969         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
970         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
971     }
972 
973     function _msgSenderERC721A() internal view virtual returns (address) {
974         return msg.sender;
975     }
976 
977     function _toString(uint256 value) internal pure virtual returns (string memory str) {
978         assembly {
979 
980             let m := add(mload(0x40), 0xa0)
981 
982             mstore(0x40, m)
983 
984             str := sub(m, 0x20)
985 
986             mstore(str, 0)
987 
988             let end := str
989 
990             for { let temp := value } 1 {} {
991                 str := sub(str, 1)
992 
993                 mstore8(str, add(48, mod(temp, 10)))
994 
995                 temp := div(temp, 10)
996 
997                 if iszero(temp) { break }
998             }
999 
1000             let length := sub(end, str)
1001 
1002             str := sub(str, 0x20)
1003 
1004             mstore(str, length)
1005         }
1006     }
1007 }
1008 
1009 pragma solidity ^0.8.13;
1010 
1011 contract OperatorFilterer {
1012     error OperatorNotAllowed(address operator);
1013 
1014     IOperatorFilterRegistry constant operatorFilterRegistry =
1015         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1016 
1017     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1018 
1019         if (address(operatorFilterRegistry).code.length > 0) {
1020             if (subscribe) {
1021                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1022             } else {
1023                 if (subscriptionOrRegistrantToCopy != address(0)) {
1024                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1025                 } else {
1026                     operatorFilterRegistry.register(address(this));
1027                 }
1028             }
1029         }
1030     }
1031 
1032     modifier onlyAllowedOperator() virtual {
1033 
1034         if (address(operatorFilterRegistry).code.length > 0) {
1035             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1036                 revert OperatorNotAllowed(msg.sender);
1037             }
1038         }
1039         _;
1040     }
1041 }
1042 
1043 pragma solidity ^0.8.13;
1044 
1045 contract DefaultOperatorFilterer is OperatorFilterer {
1046     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1047 
1048     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1049 }
1050 
1051 pragma solidity ^0.8.13;
1052 
1053 interface IOperatorFilterRegistry {
1054     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1055     function register(address registrant) external;
1056     function registerAndSubscribe(address registrant, address subscription) external;
1057     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1058     function updateOperator(address registrant, address operator, bool filtered) external;
1059     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1060     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1061     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1062     function subscribe(address registrant, address registrantToSubscribe) external;
1063     function unsubscribe(address registrant, bool copyExistingEntries) external;
1064     function subscriptionOf(address addr) external returns (address registrant);
1065     function subscribers(address registrant) external returns (address[] memory);
1066     function subscriberAt(address registrant, uint256 index) external returns (address);
1067     function copyEntriesOf(address registrant, address registrantToCopy) external;
1068     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1069     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1070     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1071     function filteredOperators(address addr) external returns (address[] memory);
1072     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1073     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1074     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1075     function isRegistered(address addr) external returns (bool);
1076     function codeHashOf(address addr) external returns (bytes32);
1077 }
1078 
1079 pragma solidity ^0.8.4;
1080 
1081 interface IERC721ABurnable is IERC721A {
1082 
1083     function burn(uint256 tokenId) external;
1084 }
1085 
1086 pragma solidity ^0.8.4;
1087 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1088     function burn(uint256 tokenId) public virtual override {
1089         _burn(tokenId, true);
1090     }
1091 }
1092 
1093 pragma solidity ^0.8.16;
1094 contract Rocks is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1095 string public CONTRACT_URI = "";
1096 mapping(address => uint) public userHasMinted;
1097 bool public REVEALED;
1098 string public UNREVEALED_URI = "";
1099 string public BASE_URI = "";
1100 bool public isPublicMintEnabled = false;
1101 uint public COLLECTION_SIZE = 3333;
1102 uint public MINT_PRICE = 0.003333 ether;
1103 uint public MAX_BATCH_SIZE = 25;
1104 uint public SUPPLY_PER_WALLET = 25;
1105 uint public FREE_SUPPLY_PER_WALLET = 1;
1106 constructor() ERC721A("we will rock you!", "ROCKS") {}
1107 
1108 
1109     function MintWL(uint256 quantity, address receiver) public onlyOwner {
1110         require(
1111             totalSupply() + quantity <= COLLECTION_SIZE,
1112             "No more tokens in stock!"
1113         );
1114         
1115         _safeMint(receiver, quantity);
1116     }
1117 
1118     modifier callerIsUser() {
1119         require(tx.origin == msg.sender, "The caller is another contract");
1120         _;
1121     }
1122 
1123     function getPrice(uint quantity) public view returns(uint){
1124         uint price;
1125         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1126         if (quantity >= free) {
1127             price = (MINT_PRICE) * (quantity - free);
1128         } else {
1129             price = 0;
1130         }
1131         return price;
1132     }
1133 
1134     function Mint1Free(uint quantity)
1135         external
1136         payable
1137         callerIsUser 
1138         nonReentrant
1139     {
1140         uint price;
1141         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1142         if (quantity >= free) {
1143             price = (MINT_PRICE) * (quantity - free);
1144             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1145         } else {
1146             price = 0;
1147             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1148         }
1149 
1150         require(isPublicMintEnabled, "Rocks not ready yet!");
1151         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more Rocks!");
1152 
1153         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to total mint Rocks per wallet over limit");
1154 
1155         require(quantity <= MAX_BATCH_SIZE, "Tried to mint Rocks over limit, retry with reduced quantity");
1156         require(msg.value >= price, "Must send enough eth");
1157 
1158         _safeMint(msg.sender, quantity);
1159 
1160         if (msg.value > price) {
1161             payable(msg.sender).transfer(msg.value - price);
1162         }
1163     }
1164 
1165     function mint(uint quantity)
1166         external
1167         payable
1168         callerIsUser 
1169         nonReentrant
1170     {
1171         uint price;
1172         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1173         if (quantity >= free) {
1174             price = (MINT_PRICE) * (quantity - free);
1175             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1176         } else {
1177             price = 0;
1178             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1179         }
1180 
1181         require(isPublicMintEnabled, "Rocks not ready yet!");
1182         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more Rocks!");
1183 
1184         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to total mint Rocks per wallet over limit");
1185 
1186         require(quantity <= MAX_BATCH_SIZE, "Tried to mint Rocks over limit, retry with reduced quantity");
1187         require(msg.value >= price, "Must send enough eth");
1188 
1189         _safeMint(msg.sender, quantity);
1190 
1191         if (msg.value > price) {
1192             payable(msg.sender).transfer(msg.value - price);
1193         }
1194     }
1195 
1196     function withdrawFunds() external onlyOwner nonReentrant {
1197         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1198         require(success, "Transfer failed.");
1199     }
1200 
1201     function setPublicMintEnabled() public onlyOwner {
1202         isPublicMintEnabled = !isPublicMintEnabled;
1203     }
1204 
1205     function setBaseURI(bool _revealed, string memory _baseURI) public onlyOwner {
1206         BASE_URI = _baseURI;
1207         REVEALED = _revealed;
1208     }
1209 
1210     function contractURI() public view returns (string memory) {
1211         return CONTRACT_URI;
1212     }
1213 
1214     function setContractURI(string memory _contractURI) public onlyOwner {
1215         CONTRACT_URI = _contractURI;
1216     }
1217 
1218     function setCOLLECTIONsIZE(uint256 _new) external onlyOwner {
1219         COLLECTION_SIZE = _new;
1220     }
1221 
1222     function setPrice(uint256 _newPrice) external onlyOwner {
1223         MINT_PRICE = _newPrice;
1224     }
1225 
1226     function set_FREE_SUPPLY_PER_WALLET(uint256 _new) external onlyOwner {
1227         FREE_SUPPLY_PER_WALLET = _new;
1228     }
1229 
1230     function set_SUPPLY_PER_WALLET(uint256 _new) external onlyOwner {
1231         SUPPLY_PER_WALLET = _new;
1232     }
1233 
1234     function set_MAX_BATCH_SIZE(uint256 _new) external onlyOwner {
1235         MAX_BATCH_SIZE = _new;
1236     }
1237 
1238     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1239         super.transferFrom(from, to, tokenId);
1240     }
1241 
1242     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1243         super.safeTransferFrom(from, to, tokenId);
1244     }
1245 
1246     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1247         public payable
1248         override (ERC721A, IERC721A)
1249         onlyAllowedOperator
1250     {
1251         super.safeTransferFrom(from, to, tokenId, data);
1252     }
1253 
1254     function tokenURI(uint256 _tokenId)
1255         public
1256         view
1257         override (ERC721A, IERC721A)
1258         returns (string memory)
1259     {
1260         if (REVEALED) {
1261             return
1262                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1263         } else {
1264             return UNREVEALED_URI;
1265         }
1266     }
1267 
1268 }