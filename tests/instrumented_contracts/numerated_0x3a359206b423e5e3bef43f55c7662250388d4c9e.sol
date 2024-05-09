1 // SPDX-License-Identifier: MIT
2 
3 //
4 //
5 //█  █▀ ▄███▄     ▄▄▄▄▀ ▄▄▄▄▄   ▄███▄   █▄▄▄▄ ████▄ 
6 //█▄█   █▀   ▀ ▀▀▀ █   █     ▀▄ █▀   ▀  █  ▄▀ █   █ 
7 //█▀▄   ██▄▄       █ ▄  ▀▀▀▀▄   ██▄▄    █▀▀▌  █   █ 
8 //█  █  █▄   ▄▀   █   ▀▄▄▄▄▀    █▄   ▄▀ █  █  ▀████ 
9 //  █   ▀███▀    ▀              ▀███▀     █         
10 // ▀                                     ▀          
11 //                                                 
12                                                                                                       
13 pragma solidity ^0.8.0;
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 pragma solidity ^0.8.0;
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34     modifier onlyOwner() {
35         _checkOwner();
36         _;
37     }
38 
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     function _checkOwner() internal view virtual {
44         require(owner() == _msgSender(), "Ownable: caller is not the owner");
45     }
46 
47     function renounceOwnership() public virtual onlyOwner {
48         _transferOwnership(address(0));
49     }
50 
51 
52     function transferOwnership(address newOwner) public virtual onlyOwner {
53         require(newOwner != address(0), "Ownable: new owner is the zero address");
54         _transferOwnership(newOwner);
55     }
56 
57     function _transferOwnership(address newOwner) internal virtual {
58         address oldOwner = _owner;
59         _owner = newOwner;
60         emit OwnershipTransferred(oldOwner, newOwner);
61     }
62 }
63 
64 pragma solidity ^0.8.0;
65 
66 abstract contract ReentrancyGuard {
67 
68     uint256 private constant _NOT_ENTERED = 1;
69     uint256 private constant _ENTERED = 2;
70 
71     uint256 private _status;
72 
73     constructor() {
74         _status = _NOT_ENTERED;
75     }
76 
77     modifier nonReentrant() {
78         // On the first call to nonReentrant, _notEntered will be true
79         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
80 
81         // Any calls to nonReentrant after this point will fail
82         _status = _ENTERED;
83 
84         _;
85 
86         _status = _NOT_ENTERED;
87     }
88 }
89 
90 pragma solidity ^0.8.0;
91 
92 library Strings {
93     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
94     uint8 private constant _ADDRESS_LENGTH = 20;
95 
96     function toString(uint256 value) internal pure returns (string memory) {
97 
98         if (value == 0) {
99             return "0";
100         }
101         uint256 temp = value;
102         uint256 digits;
103         while (temp != 0) {
104             digits++;
105             temp /= 10;
106         }
107         bytes memory buffer = new bytes(digits);
108         while (value != 0) {
109             digits -= 1;
110             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
111             value /= 10;
112         }
113         return string(buffer);
114     }
115 
116     function toHexString(uint256 value) internal pure returns (string memory) {
117         if (value == 0) {
118             return "0x00";
119         }
120         uint256 temp = value;
121         uint256 length = 0;
122         while (temp != 0) {
123             length++;
124             temp >>= 8;
125         }
126         return toHexString(value, length);
127     }
128 
129     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
130         bytes memory buffer = new bytes(2 * length + 2);
131         buffer[0] = "0";
132         buffer[1] = "x";
133         for (uint256 i = 2 * length + 1; i > 1; --i) {
134             buffer[i] = _HEX_SYMBOLS[value & 0xf];
135             value >>= 4;
136         }
137         require(value == 0, "Strings: hex length insufficient");
138         return string(buffer);
139     }
140 
141     function toHexString(address addr) internal pure returns (string memory) {
142         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
143     }
144 }
145 
146 pragma solidity ^0.8.0;
147 
148 
149 library EnumerableSet {
150 
151 
152     struct Set {
153         // Storage of set values
154         bytes32[] _values;
155 
156         mapping(bytes32 => uint256) _indexes;
157     }
158 
159     function _add(Set storage set, bytes32 value) private returns (bool) {
160         if (!_contains(set, value)) {
161             set._values.push(value);
162 
163             set._indexes[value] = set._values.length;
164             return true;
165         } else {
166             return false;
167         }
168     }
169 
170     function _remove(Set storage set, bytes32 value) private returns (bool) {
171 
172         uint256 valueIndex = set._indexes[value];
173 
174         if (valueIndex != 0) {
175 
176             uint256 toDeleteIndex = valueIndex - 1;
177             uint256 lastIndex = set._values.length - 1;
178 
179             if (lastIndex != toDeleteIndex) {
180                 bytes32 lastValue = set._values[lastIndex];
181 
182                 set._values[toDeleteIndex] = lastValue;
183                 
184                 set._indexes[lastValue] = valueIndex; 
185             }
186 
187             // Delete the slot where the moved value was stored
188             set._values.pop();
189 
190             // Delete the index for the deleted slot
191             delete set._indexes[value];
192 
193             return true;
194         } else {
195             return false;
196         }
197     }
198 
199     function _contains(Set storage set, bytes32 value) private view returns (bool) {
200         return set._indexes[value] != 0;
201     }
202 
203     function _length(Set storage set) private view returns (uint256) {
204         return set._values.length;
205     }
206 
207     function _at(Set storage set, uint256 index) private view returns (bytes32) {
208         return set._values[index];
209     }
210 
211     function _values(Set storage set) private view returns (bytes32[] memory) {
212         return set._values;
213     }
214 
215     struct Bytes32Set {
216         Set _inner;
217     }
218 
219     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
220         return _add(set._inner, value);
221     }
222 
223     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
224         return _remove(set._inner, value);
225     }
226 
227     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
228         return _contains(set._inner, value);
229     }
230 
231     function length(Bytes32Set storage set) internal view returns (uint256) {
232         return _length(set._inner);
233     }
234 
235     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
236         return _at(set._inner, index);
237     }
238 
239     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
240         return _values(set._inner);
241     }
242 
243     struct AddressSet {
244         Set _inner;
245     }
246 
247     function add(AddressSet storage set, address value) internal returns (bool) {
248         return _add(set._inner, bytes32(uint256(uint160(value))));
249     }
250 
251     function remove(AddressSet storage set, address value) internal returns (bool) {
252         return _remove(set._inner, bytes32(uint256(uint160(value))));
253     }
254 
255     function contains(AddressSet storage set, address value) internal view returns (bool) {
256         return _contains(set._inner, bytes32(uint256(uint160(value))));
257     }
258 
259     function length(AddressSet storage set) internal view returns (uint256) {
260         return _length(set._inner);
261     }
262 
263     function at(AddressSet storage set, uint256 index) internal view returns (address) {
264         return address(uint160(uint256(_at(set._inner, index))));
265     }
266 
267     function values(AddressSet storage set) internal view returns (address[] memory) {
268         bytes32[] memory store = _values(set._inner);
269         address[] memory result;
270 
271         assembly {
272             result := store
273         }
274 
275         return result;
276     }
277 
278     struct UintSet {
279         Set _inner;
280     }
281 
282     function add(UintSet storage set, uint256 value) internal returns (bool) {
283         return _add(set._inner, bytes32(value));
284     }
285 
286     function remove(UintSet storage set, uint256 value) internal returns (bool) {
287         return _remove(set._inner, bytes32(value));
288     }
289 
290     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
291         return _contains(set._inner, bytes32(value));
292     }
293 
294     function length(UintSet storage set) internal view returns (uint256) {
295         return _length(set._inner);
296     }
297 
298     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
299         return uint256(_at(set._inner, index));
300     }
301 
302     function values(UintSet storage set) internal view returns (uint256[] memory) {
303         bytes32[] memory store = _values(set._inner);
304         uint256[] memory result;
305 
306         /// @solidity memory-safe-assembly
307         assembly {
308             result := store
309         }
310 
311         return result;
312     }
313 }
314 
315 pragma solidity ^0.8.4;
316 
317 interface IERC721A {
318 
319     error ApprovalCallerNotOwnerNorApproved();
320 
321     error ApprovalQueryForNonexistentToken();
322 
323     error BalanceQueryForZeroAddress();
324 
325     error MintToZeroAddress();
326 
327     error MintZeroQuantity();
328 
329     error OwnerQueryForNonexistentToken();
330 
331     error TransferCallerNotOwnerNorApproved();
332 
333     error TransferFromIncorrectOwner();
334 
335     error TransferToNonERC721ReceiverImplementer();
336 
337     error TransferToZeroAddress();
338 
339     error URIQueryForNonexistentToken();
340 
341     error MintERC2309QuantityExceedsLimit();
342 
343     error OwnershipNotInitializedForExtraData();
344 
345     struct TokenOwnership {
346 
347         address addr;
348 
349         uint64 startTimestamp;
350 
351         bool burned;
352 
353         uint24 extraData;
354     }
355 
356     function totalSupply() external view returns (uint256);
357 
358     function supportsInterface(bytes4 interfaceId) external view returns (bool);
359 
360     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
361 
362     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
363 
364     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
365 
366     function balanceOf(address owner) external view returns (uint256 balance);
367 
368     function ownerOf(uint256 tokenId) external view returns (address owner);
369 
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId,
374         bytes calldata data
375     ) external payable;
376 
377     function safeTransferFrom(
378         address from,
379         address to,
380         uint256 tokenId
381     ) external payable;
382 
383     function transferFrom(
384         address from,
385         address to,
386         uint256 tokenId
387     ) external payable;
388 
389     function approve(address to, uint256 tokenId) external payable;
390 
391     function setApprovalForAll(address operator, bool _approved) external;
392 
393     function getApproved(uint256 tokenId) external view returns (address operator);
394 
395     function isApprovedForAll(address owner, address operator) external view returns (bool);
396 
397     function name() external view returns (string memory);
398 
399     function symbol() external view returns (string memory);
400 
401     function tokenURI(uint256 tokenId) external view returns (string memory);
402 
403     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
404 }
405 
406 pragma solidity ^0.8.4;
407 
408 interface ERC721A__IERC721Receiver {
409     function onERC721Received(
410         address operator,
411         address from,
412         uint256 tokenId,
413         bytes calldata data
414     ) external returns (bytes4);
415 }
416 
417 contract ERC721A is IERC721A {
418 
419     struct TokenApprovalRef {
420         address value;
421     }
422 
423     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
424 
425     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
426 
427     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
428 
429     uint256 private constant _BITPOS_AUX = 192;
430 
431     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
432 
433     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
434 
435     uint256 private constant _BITMASK_BURNED = 1 << 224;
436 
437     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
438 
439     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
440 
441     uint256 private constant _BITPOS_EXTRA_DATA = 232;
442 
443     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
444 
445     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
446 
447     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
448 
449     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
450         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
451 
452     uint256 private _currentIndex;
453 
454     uint256 private _burnCounter;
455 
456     string private _name;
457 
458     string private _symbol;
459 
460     mapping(uint256 => uint256) private _packedOwnerships;
461 
462     mapping(address => uint256) private _packedAddressData;
463 
464     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
465 
466     mapping(address => mapping(address => bool)) private _operatorApprovals;
467 
468     constructor(string memory name_, string memory symbol_) {
469         _name = name_;
470         _symbol = symbol_;
471         _currentIndex = _startTokenId();
472     }
473 
474     function _startTokenId() internal view virtual returns (uint256) {
475         return 0;
476     }
477 
478     function _nextTokenId() internal view virtual returns (uint256) {
479         return _currentIndex;
480     }
481 
482     function totalSupply() public view virtual override returns (uint256) {
483 
484         unchecked {
485             return _currentIndex - _burnCounter - _startTokenId();
486         }
487     }
488 
489     function _totalMinted() internal view virtual returns (uint256) {
490 
491         unchecked {
492             return _currentIndex - _startTokenId();
493         }
494     }
495 
496     function _totalBurned() internal view virtual returns (uint256) {
497         return _burnCounter;
498     }
499 
500     function balanceOf(address owner) public view virtual override returns (uint256) {
501         if (owner == address(0)) revert BalanceQueryForZeroAddress();
502         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
503     }
504 
505     function _numberMinted(address owner) internal view returns (uint256) {
506         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
507     }
508 
509     function _numberBurned(address owner) internal view returns (uint256) {
510         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
511     }
512 
513     function _getAux(address owner) internal view returns (uint64) {
514         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
515     }
516 
517     function _setAux(address owner, uint64 aux) internal virtual {
518         uint256 packed = _packedAddressData[owner];
519         uint256 auxCasted;
520         // Cast `aux` with assembly to avoid redundant masking.
521         assembly {
522             auxCasted := aux
523         }
524         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
525         _packedAddressData[owner] = packed;
526     }
527 
528 
529     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530 
531         return
532             interfaceId == 0x01ffc9a7 || 
533             interfaceId == 0x80ac58cd || 
534             interfaceId == 0x5b5e139f; 
535     }
536 
537     function name() public view virtual override returns (string memory) {
538         return _name;
539     }
540 
541     function symbol() public view virtual override returns (string memory) {
542         return _symbol;
543     }
544 
545     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
546         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
547 
548         string memory baseURI = _baseURI();
549         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
550     }
551 
552     function _baseURI() internal view virtual returns (string memory) {
553         return '';
554     }
555 
556     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
557         return address(uint160(_packedOwnershipOf(tokenId)));
558     }
559 
560     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
561         return _unpackedOwnership(_packedOwnershipOf(tokenId));
562     }
563 
564     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
565         return _unpackedOwnership(_packedOwnerships[index]);
566     }
567 
568     function _initializeOwnershipAt(uint256 index) internal virtual {
569         if (_packedOwnerships[index] == 0) {
570             _packedOwnerships[index] = _packedOwnershipOf(index);
571         }
572     }
573 
574     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
575         uint256 curr = tokenId;
576 
577         unchecked {
578             if (_startTokenId() <= curr)
579                 if (curr < _currentIndex) {
580                     uint256 packed = _packedOwnerships[curr];
581 
582                     if (packed & _BITMASK_BURNED == 0) {
583 
584                         while (packed == 0) {
585                             packed = _packedOwnerships[--curr];
586                         }
587                         return packed;
588                     }
589                 }
590         }
591         revert OwnerQueryForNonexistentToken();
592     }
593 
594     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
595         ownership.addr = address(uint160(packed));
596         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
597         ownership.burned = packed & _BITMASK_BURNED != 0;
598         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
599     }
600 
601     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
602         assembly {
603             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
604             owner := and(owner, _BITMASK_ADDRESS)
605             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
606             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
607         }
608     }
609 
610     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
611         // For branchless setting of the `nextInitialized` flag.
612         assembly {
613             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
614             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
615         }
616     }
617 
618     function approve(address to, uint256 tokenId) public payable virtual override {
619         address owner = ownerOf(tokenId);
620 
621         if (_msgSenderERC721A() != owner)
622             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
623                 revert ApprovalCallerNotOwnerNorApproved();
624             }
625 
626         _tokenApprovals[tokenId].value = to;
627         emit Approval(owner, to, tokenId);
628     }
629 
630     function getApproved(uint256 tokenId) public view virtual override returns (address) {
631         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
632 
633         return _tokenApprovals[tokenId].value;
634     }
635 
636     function setApprovalForAll(address operator, bool approved) public virtual override {
637         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
638         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
639     }
640 
641     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
642         return _operatorApprovals[owner][operator];
643     }
644 
645     function _exists(uint256 tokenId) internal view virtual returns (bool) {
646         return
647             _startTokenId() <= tokenId &&
648             tokenId < _currentIndex && // If within bounds,
649             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
650     }
651 
652     function _isSenderApprovedOrOwner(
653         address approvedAddress,
654         address owner,
655         address msgSender
656     ) private pure returns (bool result) {
657         assembly {
658 
659             owner := and(owner, _BITMASK_ADDRESS)
660 
661             msgSender := and(msgSender, _BITMASK_ADDRESS)
662 
663             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
664         }
665     }
666 
667     function _getApprovedSlotAndAddress(uint256 tokenId)
668         private
669         view
670         returns (uint256 approvedAddressSlot, address approvedAddress)
671     {
672         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
673 
674         assembly {
675             approvedAddressSlot := tokenApproval.slot
676             approvedAddress := sload(approvedAddressSlot)
677         }
678     }
679 
680     function transferFrom(
681         address from,
682         address to,
683         uint256 tokenId
684     ) public payable virtual override {
685         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
686 
687         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
688 
689         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
690 
691         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
692             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
693 
694         if (to == address(0)) revert TransferToZeroAddress();
695 
696         _beforeTokenTransfers(from, to, tokenId, 1);
697 
698         assembly {
699             if approvedAddress {
700 
701                 sstore(approvedAddressSlot, 0)
702             }
703         }
704 
705         unchecked {
706 
707             --_packedAddressData[from]; 
708             ++_packedAddressData[to]; 
709 
710             _packedOwnerships[tokenId] = _packOwnershipData(
711                 to,
712                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
713             );
714 
715             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
716                 uint256 nextTokenId = tokenId + 1;
717 
718                 if (_packedOwnerships[nextTokenId] == 0) {
719 
720                     if (nextTokenId != _currentIndex) {
721 
722                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
723                     }
724                 }
725             }
726         }
727 
728         emit Transfer(from, to, tokenId);
729         _afterTokenTransfers(from, to, tokenId, 1);
730     }
731 
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public payable virtual override {
737         safeTransferFrom(from, to, tokenId, '');
738     }
739 
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId,
744         bytes memory _data
745     ) public payable virtual override {
746         transferFrom(from, to, tokenId);
747         if (to.code.length != 0)
748             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
749                 revert TransferToNonERC721ReceiverImplementer();
750             }
751     }
752 
753     function _beforeTokenTransfers(
754         address from,
755         address to,
756         uint256 startTokenId,
757         uint256 quantity
758     ) internal virtual {}
759 
760     function _afterTokenTransfers(
761         address from,
762         address to,
763         uint256 startTokenId,
764         uint256 quantity
765     ) internal virtual {}
766 
767     function _checkContractOnERC721Received(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) private returns (bool) {
773         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
774             bytes4 retval
775         ) {
776             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
777         } catch (bytes memory reason) {
778             if (reason.length == 0) {
779                 revert TransferToNonERC721ReceiverImplementer();
780             } else {
781                 assembly {
782                     revert(add(32, reason), mload(reason))
783                 }
784             }
785         }
786     }
787 
788     function _mint(address to, uint256 quantity) internal virtual {
789         uint256 startTokenId = _currentIndex;
790         if (quantity == 0) revert MintZeroQuantity();
791 
792         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
793 
794         unchecked {
795 
796             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
797 
798             _packedOwnerships[startTokenId] = _packOwnershipData(
799                 to,
800                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
801             );
802 
803             uint256 toMasked;
804             uint256 end = startTokenId + quantity;
805 
806             assembly {
807 
808                 toMasked := and(to, _BITMASK_ADDRESS)
809 
810                 log4(
811                     0, 
812                     0, 
813                     _TRANSFER_EVENT_SIGNATURE, 
814                     0, 
815                     toMasked, 
816                     startTokenId 
817                 )
818 
819                 for {
820                     let tokenId := add(startTokenId, 1)
821                 } iszero(eq(tokenId, end)) {
822                     tokenId := add(tokenId, 1)
823                 } {
824 
825                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
826                 }
827             }
828             if (toMasked == 0) revert MintToZeroAddress();
829 
830             _currentIndex = end;
831         }
832         _afterTokenTransfers(address(0), to, startTokenId, quantity);
833     }
834 
835     function _mintERC2309(address to, uint256 quantity) internal virtual {
836         uint256 startTokenId = _currentIndex;
837         if (to == address(0)) revert MintToZeroAddress();
838         if (quantity == 0) revert MintZeroQuantity();
839         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
840 
841         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
842 
843         unchecked {
844 
845             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
846 
847             _packedOwnerships[startTokenId] = _packOwnershipData(
848                 to,
849                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
850             );
851 
852             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
853 
854             _currentIndex = startTokenId + quantity;
855         }
856         _afterTokenTransfers(address(0), to, startTokenId, quantity);
857     }
858 
859     function _safeMint(
860         address to,
861         uint256 quantity,
862         bytes memory _data
863     ) internal virtual {
864         _mint(to, quantity);
865 
866         unchecked {
867             if (to.code.length != 0) {
868                 uint256 end = _currentIndex;
869                 uint256 index = end - quantity;
870                 do {
871                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
872                         revert TransferToNonERC721ReceiverImplementer();
873                     }
874                 } while (index < end);
875                 // Reentrancy protection.
876                 if (_currentIndex != end) revert();
877             }
878         }
879     }
880 
881     function _safeMint(address to, uint256 quantity) internal virtual {
882         _safeMint(to, quantity, '');
883     }
884 
885     function _burn(uint256 tokenId) internal virtual {
886         _burn(tokenId, false);
887     }
888 
889     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
890         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
891 
892         address from = address(uint160(prevOwnershipPacked));
893 
894         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
895 
896         if (approvalCheck) {
897             
898             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
899                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
900         }
901 
902         _beforeTokenTransfers(from, address(0), tokenId, 1);
903 
904         assembly {
905             if approvedAddress {
906                 
907                 sstore(approvedAddressSlot, 0)
908             }
909         }
910 
911         unchecked {
912 
913             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
914 
915             _packedOwnerships[tokenId] = _packOwnershipData(
916                 from,
917                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
918             );
919 
920             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
921                 uint256 nextTokenId = tokenId + 1;
922 
923                 if (_packedOwnerships[nextTokenId] == 0) {
924 
925                     if (nextTokenId != _currentIndex) {
926 
927                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
928                     }
929                 }
930             }
931         }
932 
933         emit Transfer(from, address(0), tokenId);
934         _afterTokenTransfers(from, address(0), tokenId, 1);
935 
936         unchecked {
937             _burnCounter++;
938         }
939     }
940 
941     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
942         uint256 packed = _packedOwnerships[index];
943         if (packed == 0) revert OwnershipNotInitializedForExtraData();
944         uint256 extraDataCasted;
945         assembly {
946             extraDataCasted := extraData
947         }
948         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
949         _packedOwnerships[index] = packed;
950     }
951 
952     function _extraData(
953         address from,
954         address to,
955         uint24 previousExtraData
956     ) internal view virtual returns (uint24) {}
957 
958     function _nextExtraData(
959         address from,
960         address to,
961         uint256 prevOwnershipPacked
962     ) private view returns (uint256) {
963         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
964         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
965     }
966 
967     function _msgSenderERC721A() internal view virtual returns (address) {
968         return msg.sender;
969     }
970 
971     function _toString(uint256 value) internal pure virtual returns (string memory str) {
972         assembly {
973 
974             let m := add(mload(0x40), 0xa0)
975 
976             mstore(0x40, m)
977 
978             str := sub(m, 0x20)
979 
980             mstore(str, 0)
981 
982             let end := str
983 
984             for { let temp := value } 1 {} {
985                 str := sub(str, 1)
986 
987                 mstore8(str, add(48, mod(temp, 10)))
988 
989                 temp := div(temp, 10)
990 
991                 if iszero(temp) { break }
992             }
993 
994             let length := sub(end, str)
995 
996             str := sub(str, 0x20)
997 
998             mstore(str, length)
999         }
1000     }
1001 }
1002 
1003 pragma solidity ^0.8.13;
1004 
1005 contract OperatorFilterer {
1006     error OperatorNotAllowed(address operator);
1007 
1008     IOperatorFilterRegistry constant operatorFilterRegistry =
1009         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1010 
1011     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1012 
1013         if (address(operatorFilterRegistry).code.length > 0) {
1014             if (subscribe) {
1015                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1016             } else {
1017                 if (subscriptionOrRegistrantToCopy != address(0)) {
1018                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1019                 } else {
1020                     operatorFilterRegistry.register(address(this));
1021                 }
1022             }
1023         }
1024     }
1025 
1026     modifier onlyAllowedOperator() virtual {
1027 
1028         if (address(operatorFilterRegistry).code.length > 0) {
1029             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1030                 revert OperatorNotAllowed(msg.sender);
1031             }
1032         }
1033         _;
1034     }
1035 }
1036 
1037 pragma solidity ^0.8.13;
1038 
1039 contract DefaultOperatorFilterer is OperatorFilterer {
1040     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1041 
1042     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1043 }
1044 
1045 pragma solidity ^0.8.13;
1046 
1047 interface IOperatorFilterRegistry {
1048     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1049     function register(address registrant) external;
1050     function registerAndSubscribe(address registrant, address subscription) external;
1051     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1052     function updateOperator(address registrant, address operator, bool filtered) external;
1053     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1054     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1055     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1056     function subscribe(address registrant, address registrantToSubscribe) external;
1057     function unsubscribe(address registrant, bool copyExistingEntries) external;
1058     function subscriptionOf(address addr) external returns (address registrant);
1059     function subscribers(address registrant) external returns (address[] memory);
1060     function subscriberAt(address registrant, uint256 index) external returns (address);
1061     function copyEntriesOf(address registrant, address registrantToCopy) external;
1062     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1063     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1064     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1065     function filteredOperators(address addr) external returns (address[] memory);
1066     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1067     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1068     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1069     function isRegistered(address addr) external returns (bool);
1070     function codeHashOf(address addr) external returns (bytes32);
1071 }
1072 
1073 pragma solidity ^0.8.4;
1074 
1075 interface IERC721ABurnable is IERC721A {
1076 
1077     function burn(uint256 tokenId) external;
1078 }
1079 
1080 pragma solidity ^0.8.4;
1081 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1082     function burn(uint256 tokenId) public virtual override {
1083         _burn(tokenId, true);
1084     }
1085 }
1086 
1087 pragma solidity ^0.8.16;
1088 contract Ketsero is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1089 
1090 string public CONTRACT_URI = "https://api.ketsero.xyz/";
1091 
1092     mapping(address => uint) public userHasMinted;
1093 
1094     bool public REVEALED;
1095 
1096     string public UNREVEALED_URI = "https://api.ketsero.xyz/";
1097 
1098     string public BASE_URI = "https://api.ketsero.xyz/";
1099 
1100     bool public isPublicMintEnabled = false;
1101 
1102     uint public COLLECTION_SIZE = 2000;
1103 
1104     uint public MINT_PRICE = 0.005 ether;
1105 
1106     uint public MAX_BATCH_SIZE = 25;
1107 
1108     uint public SUPPLY_PER_WALLET = 25;
1109     
1110     uint public FREE_SUPPLY_PER_WALLET = 1;
1111 
1112     constructor() ERC721A("Ketsero", "KETSERO") {}
1113 
1114 
1115     function MintByInvite(uint256 quantity, address receiver) public onlyOwner {
1116         require(
1117             totalSupply() + quantity <= COLLECTION_SIZE,
1118             "No more tokens in stock!"
1119         );
1120         
1121         _safeMint(receiver, quantity);
1122     }
1123 
1124     modifier callerIsUser() {
1125         require(tx.origin == msg.sender, "The caller is another contract");
1126         _;
1127     }
1128 
1129     function getPrice(uint quantity) public view returns(uint){
1130         uint price;
1131         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1132         if (quantity >= free) {
1133             price = (MINT_PRICE) * (quantity - free);
1134         } else {
1135             price = 0;
1136         }
1137         return price;
1138     }
1139 
1140     function MintFree(uint quantity)
1141         external
1142         payable
1143         callerIsUser 
1144         nonReentrant
1145     {
1146         uint price;
1147         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1148         if (quantity >= free) {
1149             price = (MINT_PRICE) * (quantity - free);
1150             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1151         } else {
1152             price = 0;
1153             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1154         }
1155 
1156         require(isPublicMintEnabled, "Tokens not ready yet!");
1157         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more Tokens!");
1158 
1159         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to total mint quanity per wallet over limit");
1160 
1161         require(quantity <= MAX_BATCH_SIZE, "Tried to mint quanity over limit, retry with reduced quantity");
1162         require(msg.value >= price, "Must send enough eth");
1163 
1164         _safeMint(msg.sender, quantity);
1165 
1166         if (msg.value > price) {
1167             payable(msg.sender).transfer(msg.value - price);
1168         }
1169     }
1170 
1171     function mint(uint quantity)
1172         external
1173         payable
1174         callerIsUser 
1175         nonReentrant
1176     {
1177         uint price;
1178         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1179         if (quantity >= free) {
1180             price = (MINT_PRICE) * (quantity - free);
1181             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1182         } else {
1183             price = 0;
1184             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1185         }
1186 
1187         require(isPublicMintEnabled, "Tokens not ready yet!");
1188         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more Tokens!");
1189 
1190         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to total mint quanity per wallet over limit");
1191 
1192         require(quantity <= MAX_BATCH_SIZE, "Tried to mint quanity over limit, retry with reduced quantity");
1193         require(msg.value >= price, "Must send enough eth");
1194 
1195         _safeMint(msg.sender, quantity);
1196 
1197         if (msg.value > price) {
1198             payable(msg.sender).transfer(msg.value - price);
1199         }
1200     }
1201 
1202     function withdrawFunds() external onlyOwner nonReentrant {
1203         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1204         require(success, "Transfer failed.");
1205     }
1206 
1207     function setPublicMintEnabled() public onlyOwner {
1208         isPublicMintEnabled = !isPublicMintEnabled;
1209     }
1210 
1211     function setBaseURI(bool _revealed, string memory _baseURI) public onlyOwner {
1212         BASE_URI = _baseURI;
1213         REVEALED = _revealed;
1214     }
1215 
1216     function contractURI() public view returns (string memory) {
1217         return CONTRACT_URI;
1218     }
1219 
1220     function setContractURI(string memory _contractURI) public onlyOwner {
1221         CONTRACT_URI = _contractURI;
1222     }
1223 
1224     function setCOLLECTIONsIZE(uint256 _new) external onlyOwner {
1225         COLLECTION_SIZE = _new;
1226     }
1227 
1228     function setPrice(uint256 _newPrice) external onlyOwner {
1229         MINT_PRICE = _newPrice;
1230     }
1231 
1232     function set_FREE_SUPPLY_PER_WALLET(uint256 _new) external onlyOwner {
1233         FREE_SUPPLY_PER_WALLET = _new;
1234     }
1235 
1236     function set_SUPPLY_PER_WALLET(uint256 _new) external onlyOwner {
1237         SUPPLY_PER_WALLET = _new;
1238     }
1239 
1240     function set_MAX_BATCH_SIZE(uint256 _new) external onlyOwner {
1241         MAX_BATCH_SIZE = _new;
1242     }
1243 
1244     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1245         super.transferFrom(from, to, tokenId);
1246     }
1247 
1248     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1249         super.safeTransferFrom(from, to, tokenId);
1250     }
1251 
1252     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1253         public payable
1254         override (ERC721A, IERC721A)
1255         onlyAllowedOperator
1256     {
1257         super.safeTransferFrom(from, to, tokenId, data);
1258     }
1259 
1260     function tokenURI(uint256 _tokenId)
1261         public
1262         view
1263         override (ERC721A, IERC721A)
1264         returns (string memory)
1265     {
1266         if (REVEALED) {
1267             return
1268                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1269         } else {
1270             return UNREVEALED_URI;
1271         }
1272     }
1273 
1274 }