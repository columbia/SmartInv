1 /**
2   ___ ___ ___ _______ ___    _______ _______ _______ _______ 
3  |   Y   |   |   _   |   |  |   _   |   _   |   _   |   _   |
4  |.  1   |.  |.  1___|.  |  |.  1   |.  1___|.  1   |.  1___|
5  |.  _   |.  |.  __) |.  |  |.  ____|.  __)_|.  ____|.  __)_ 
6  |:  |   |:  |:  |   |:  |  |:  |   |:  1   |:  |   |:  1   |
7  |::.|:. |::.|::.|   |::.|  |::.|   |::.. . |::.|   |::.. . |
8  `--- ---`---`---'   `---'  `---'   `-------`---'   `-------'
9                                                              
10 */
11 
12 // SPDX-License-Identifier: MIT     
13 
14 pragma solidity ^0.8.0;
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 pragma solidity ^0.8.0;
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     modifier onlyOwner() {
36         _checkOwner();
37         _;
38     }
39 
40     function owner() public view virtual returns (address) {
41         return _owner;
42     }
43 
44     function _checkOwner() internal view virtual {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46     }
47 
48     function renounceOwnership() public virtual onlyOwner {
49         _transferOwnership(address(0));
50     }
51 
52 
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         _transferOwnership(newOwner);
56     }
57 
58     function _transferOwnership(address newOwner) internal virtual {
59         address oldOwner = _owner;
60         _owner = newOwner;
61         emit OwnershipTransferred(oldOwner, newOwner);
62     }
63 }
64 
65 pragma solidity ^0.8.0;
66 
67 abstract contract ReentrancyGuard {
68 
69     uint256 private constant _NOT_ENTERED = 1;
70     uint256 private constant _ENTERED = 2;
71 
72     uint256 private _status;
73 
74     constructor() {
75         _status = _NOT_ENTERED;
76     }
77 
78     modifier nonReentrant() {
79         
80         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
81 
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
187             set._values.pop();
188 
189             delete set._indexes[value];
190 
191             return true;
192         } else {
193             return false;
194         }
195     }
196 
197     function _contains(Set storage set, bytes32 value) private view returns (bool) {
198         return set._indexes[value] != 0;
199     }
200 
201     function _length(Set storage set) private view returns (uint256) {
202         return set._values.length;
203     }
204 
205     function _at(Set storage set, uint256 index) private view returns (bytes32) {
206         return set._values[index];
207     }
208 
209     function _values(Set storage set) private view returns (bytes32[] memory) {
210         return set._values;
211     }
212 
213     struct Bytes32Set {
214         Set _inner;
215     }
216 
217     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
218         return _add(set._inner, value);
219     }
220 
221     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
222         return _remove(set._inner, value);
223     }
224 
225     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
226         return _contains(set._inner, value);
227     }
228 
229     function length(Bytes32Set storage set) internal view returns (uint256) {
230         return _length(set._inner);
231     }
232 
233     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
234         return _at(set._inner, index);
235     }
236 
237     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
238         return _values(set._inner);
239     }
240 
241     struct AddressSet {
242         Set _inner;
243     }
244 
245     function add(AddressSet storage set, address value) internal returns (bool) {
246         return _add(set._inner, bytes32(uint256(uint160(value))));
247     }
248 
249     function remove(AddressSet storage set, address value) internal returns (bool) {
250         return _remove(set._inner, bytes32(uint256(uint160(value))));
251     }
252 
253     function contains(AddressSet storage set, address value) internal view returns (bool) {
254         return _contains(set._inner, bytes32(uint256(uint160(value))));
255     }
256 
257     function length(AddressSet storage set) internal view returns (uint256) {
258         return _length(set._inner);
259     }
260 
261     function at(AddressSet storage set, uint256 index) internal view returns (address) {
262         return address(uint160(uint256(_at(set._inner, index))));
263     }
264 
265     function values(AddressSet storage set) internal view returns (address[] memory) {
266         bytes32[] memory store = _values(set._inner);
267         address[] memory result;
268 
269         assembly {
270             result := store
271         }
272 
273         return result;
274     }
275 
276     struct UintSet {
277         Set _inner;
278     }
279 
280     function add(UintSet storage set, uint256 value) internal returns (bool) {
281         return _add(set._inner, bytes32(value));
282     }
283 
284     function remove(UintSet storage set, uint256 value) internal returns (bool) {
285         return _remove(set._inner, bytes32(value));
286     }
287 
288     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
289         return _contains(set._inner, bytes32(value));
290     }
291 
292     function length(UintSet storage set) internal view returns (uint256) {
293         return _length(set._inner);
294     }
295 
296     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
297         return uint256(_at(set._inner, index));
298     }
299 
300     function values(UintSet storage set) internal view returns (uint256[] memory) {
301         bytes32[] memory store = _values(set._inner);
302         uint256[] memory result;
303 
304         /// @solidity memory-safe-assembly
305         assembly {
306             result := store
307         }
308 
309         return result;
310     }
311 }
312 
313 pragma solidity ^0.8.4;
314 
315 interface IERC721A {
316 
317     error ApprovalCallerNotOwnerNorApproved();
318 
319     error ApprovalQueryForNonexistentToken();
320 
321     error BalanceQueryForZeroAddress();
322 
323     error MintToZeroAddress();
324 
325     error MintZeroQuantity();
326 
327     error OwnerQueryForNonexistentToken();
328 
329     error TransferCallerNotOwnerNorApproved();
330 
331     error TransferFromIncorrectOwner();
332 
333     error TransferToNonERC721ReceiverImplementer();
334 
335     error TransferToZeroAddress();
336 
337     error URIQueryForNonexistentToken();
338 
339     error MintERC2309QuantityExceedsLimit();
340 
341     error OwnershipNotInitializedForExtraData();
342 
343     struct TokenOwnership {
344 
345         address addr;
346 
347         uint64 startTimestamp;
348 
349         bool burned;
350 
351         uint24 extraData;
352     }
353 
354     function totalSupply() external view returns (uint256);
355 
356     function supportsInterface(bytes4 interfaceId) external view returns (bool);
357 
358     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
359 
360     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
361 
362     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
363 
364     function balanceOf(address owner) external view returns (uint256 balance);
365 
366     function ownerOf(uint256 tokenId) external view returns (address owner);
367 
368     function safeTransferFrom(
369         address from,
370         address to,
371         uint256 tokenId,
372         bytes calldata data
373     ) external payable;
374 
375     function safeTransferFrom(
376         address from,
377         address to,
378         uint256 tokenId
379     ) external payable;
380 
381     function transferFrom(
382         address from,
383         address to,
384         uint256 tokenId
385     ) external payable;
386 
387     function approve(address to, uint256 tokenId) external payable;
388 
389     function setApprovalForAll(address operator, bool _approved) external;
390 
391     function getApproved(uint256 tokenId) external view returns (address operator);
392 
393     function isApprovedForAll(address owner, address operator) external view returns (bool);
394 
395     function name() external view returns (string memory);
396 
397     function symbol() external view returns (string memory);
398 
399     function tokenURI(uint256 tokenId) external view returns (string memory);
400 
401     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
402 }
403 
404 pragma solidity ^0.8.4;
405 
406 interface ERC721A__IERC721Receiver {
407     function onERC721Received(
408         address operator,
409         address from,
410         uint256 tokenId,
411         bytes calldata data
412     ) external returns (bytes4);
413 }
414 
415 contract ERC721A is IERC721A {
416 
417     struct TokenApprovalRef {
418         address value;
419     }
420 
421     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
422 
423     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
424 
425     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
426 
427     uint256 private constant _BITPOS_AUX = 192;
428 
429     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
430 
431     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
432 
433     uint256 private constant _BITMASK_BURNED = 1 << 224;
434 
435     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
436 
437     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
438 
439     uint256 private constant _BITPOS_EXTRA_DATA = 232;
440 
441     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
442 
443     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
444 
445     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
446 
447     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
448         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
449 
450     uint256 private _currentIndex;
451 
452     uint256 private _burnCounter;
453 
454     string private _name;
455 
456     string private _symbol;
457 
458     mapping(uint256 => uint256) private _packedOwnerships;
459 
460     mapping(address => uint256) private _packedAddressData;
461 
462     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
463 
464     mapping(address => mapping(address => bool)) private _operatorApprovals;
465 
466     constructor(string memory name_, string memory symbol_) {
467         _name = name_;
468         _symbol = symbol_;
469         _currentIndex = _startTokenId();
470     }
471 
472     function _startTokenId() internal view virtual returns (uint256) {
473         return 0;
474     }
475 
476     function _nextTokenId() internal view virtual returns (uint256) {
477         return _currentIndex;
478     }
479 
480     function totalSupply() public view virtual override returns (uint256) {
481 
482         unchecked {
483             return _currentIndex - _burnCounter - _startTokenId();
484         }
485     }
486 
487     function _totalMinted() internal view virtual returns (uint256) {
488 
489         unchecked {
490             return _currentIndex - _startTokenId();
491         }
492     }
493 
494     function _totalBurned() internal view virtual returns (uint256) {
495         return _burnCounter;
496     }
497 
498     function balanceOf(address owner) public view virtual override returns (uint256) {
499         if (owner == address(0)) revert BalanceQueryForZeroAddress();
500         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
501     }
502 
503     function _numberMinted(address owner) internal view returns (uint256) {
504         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
505     }
506 
507     function _numberBurned(address owner) internal view returns (uint256) {
508         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
509     }
510 
511     function _getAux(address owner) internal view returns (uint64) {
512         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
513     }
514 
515     function _setAux(address owner, uint64 aux) internal virtual {
516         uint256 packed = _packedAddressData[owner];
517         uint256 auxCasted;
518         // Cast `aux` with assembly to avoid redundant masking.
519         assembly {
520             auxCasted := aux
521         }
522         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
523         _packedAddressData[owner] = packed;
524     }
525 
526 
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528 
529         return
530             interfaceId == 0x01ffc9a7 || 
531             interfaceId == 0x80ac58cd || 
532             interfaceId == 0x5b5e139f; 
533     }
534 
535     function name() public view virtual override returns (string memory) {
536         return _name;
537     }
538 
539     function symbol() public view virtual override returns (string memory) {
540         return _symbol;
541     }
542 
543     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
544         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
545 
546         string memory baseURI = _baseURI();
547         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
548     }
549 
550     function _baseURI() internal view virtual returns (string memory) {
551         return '';
552     }
553 
554     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
555         return address(uint160(_packedOwnershipOf(tokenId)));
556     }
557 
558     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
559         return _unpackedOwnership(_packedOwnershipOf(tokenId));
560     }
561 
562     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
563         return _unpackedOwnership(_packedOwnerships[index]);
564     }
565 
566     function _initializeOwnershipAt(uint256 index) internal virtual {
567         if (_packedOwnerships[index] == 0) {
568             _packedOwnerships[index] = _packedOwnershipOf(index);
569         }
570     }
571 
572     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
573         uint256 curr = tokenId;
574 
575         unchecked {
576             if (_startTokenId() <= curr)
577                 if (curr < _currentIndex) {
578                     uint256 packed = _packedOwnerships[curr];
579 
580                     if (packed & _BITMASK_BURNED == 0) {
581 
582                         while (packed == 0) {
583                             packed = _packedOwnerships[--curr];
584                         }
585                         return packed;
586                     }
587                 }
588         }
589         revert OwnerQueryForNonexistentToken();
590     }
591 
592     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
593         ownership.addr = address(uint160(packed));
594         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
595         ownership.burned = packed & _BITMASK_BURNED != 0;
596         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
597     }
598 
599     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
600         assembly {
601             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
602             owner := and(owner, _BITMASK_ADDRESS)
603             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
604             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
605         }
606     }
607 
608     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
609         // For branchless setting of the `nextInitialized` flag.
610         assembly {
611             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
612             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
613         }
614     }
615 
616     function approve(address to, uint256 tokenId) public payable virtual override {
617         address owner = ownerOf(tokenId);
618 
619         if (_msgSenderERC721A() != owner)
620             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
621                 revert ApprovalCallerNotOwnerNorApproved();
622             }
623 
624         _tokenApprovals[tokenId].value = to;
625         emit Approval(owner, to, tokenId);
626     }
627 
628     function getApproved(uint256 tokenId) public view virtual override returns (address) {
629         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
630 
631         return _tokenApprovals[tokenId].value;
632     }
633 
634     function setApprovalForAll(address operator, bool approved) public virtual override {
635         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
636         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
637     }
638 
639     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
640         return _operatorApprovals[owner][operator];
641     }
642 
643     function _exists(uint256 tokenId) internal view virtual returns (bool) {
644         return
645             _startTokenId() <= tokenId &&
646             tokenId < _currentIndex && // If within bounds,
647             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
648     }
649 
650     function _isSenderApprovedOrOwner(
651         address approvedAddress,
652         address owner,
653         address msgSender
654     ) private pure returns (bool result) {
655         assembly {
656 
657             owner := and(owner, _BITMASK_ADDRESS)
658 
659             msgSender := and(msgSender, _BITMASK_ADDRESS)
660 
661             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
662         }
663     }
664 
665     function _getApprovedSlotAndAddress(uint256 tokenId)
666         private
667         view
668         returns (uint256 approvedAddressSlot, address approvedAddress)
669     {
670         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
671 
672         assembly {
673             approvedAddressSlot := tokenApproval.slot
674             approvedAddress := sload(approvedAddressSlot)
675         }
676     }
677 
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) public payable virtual override {
683         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
684 
685         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
686 
687         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
688 
689         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
690             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
691 
692         if (to == address(0)) revert TransferToZeroAddress();
693 
694         _beforeTokenTransfers(from, to, tokenId, 1);
695 
696         assembly {
697             if approvedAddress {
698 
699                 sstore(approvedAddressSlot, 0)
700             }
701         }
702 
703         unchecked {
704 
705             --_packedAddressData[from]; 
706             ++_packedAddressData[to]; 
707 
708             _packedOwnerships[tokenId] = _packOwnershipData(
709                 to,
710                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
711             );
712 
713             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
714                 uint256 nextTokenId = tokenId + 1;
715 
716                 if (_packedOwnerships[nextTokenId] == 0) {
717 
718                     if (nextTokenId != _currentIndex) {
719 
720                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
721                     }
722                 }
723             }
724         }
725 
726         emit Transfer(from, to, tokenId);
727         _afterTokenTransfers(from, to, tokenId, 1);
728     }
729 
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId
734     ) public payable virtual override {
735         safeTransferFrom(from, to, tokenId, '');
736     }
737 
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId,
742         bytes memory _data
743     ) public payable virtual override {
744         transferFrom(from, to, tokenId);
745         if (to.code.length != 0)
746             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
747                 revert TransferToNonERC721ReceiverImplementer();
748             }
749     }
750 
751     function _beforeTokenTransfers(
752         address from,
753         address to,
754         uint256 startTokenId,
755         uint256 quantity
756     ) internal virtual {}
757 
758     function _afterTokenTransfers(
759         address from,
760         address to,
761         uint256 startTokenId,
762         uint256 quantity
763     ) internal virtual {}
764 
765     function _checkContractOnERC721Received(
766         address from,
767         address to,
768         uint256 tokenId,
769         bytes memory _data
770     ) private returns (bool) {
771         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
772             bytes4 retval
773         ) {
774             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
775         } catch (bytes memory reason) {
776             if (reason.length == 0) {
777                 revert TransferToNonERC721ReceiverImplementer();
778             } else {
779                 assembly {
780                     revert(add(32, reason), mload(reason))
781                 }
782             }
783         }
784     }
785 
786     function _mint(address to, uint256 quantity) internal virtual {
787         uint256 startTokenId = _currentIndex;
788         if (quantity == 0) revert MintZeroQuantity();
789 
790         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
791 
792         unchecked {
793 
794             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
795 
796             _packedOwnerships[startTokenId] = _packOwnershipData(
797                 to,
798                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
799             );
800 
801             uint256 toMasked;
802             uint256 end = startTokenId + quantity;
803 
804             assembly {
805 
806                 toMasked := and(to, _BITMASK_ADDRESS)
807 
808                 log4(
809                     0, 
810                     0, 
811                     _TRANSFER_EVENT_SIGNATURE, 
812                     0, 
813                     toMasked, 
814                     startTokenId 
815                 )
816 
817                 for {
818                     let tokenId := add(startTokenId, 1)
819                 } iszero(eq(tokenId, end)) {
820                     tokenId := add(tokenId, 1)
821                 } {
822 
823                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
824                 }
825             }
826             if (toMasked == 0) revert MintToZeroAddress();
827 
828             _currentIndex = end;
829         }
830         _afterTokenTransfers(address(0), to, startTokenId, quantity);
831     }
832 
833     function _mintERC2309(address to, uint256 quantity) internal virtual {
834         uint256 startTokenId = _currentIndex;
835         if (to == address(0)) revert MintToZeroAddress();
836         if (quantity == 0) revert MintZeroQuantity();
837         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
838 
839         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
840 
841         unchecked {
842 
843             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
844 
845             _packedOwnerships[startTokenId] = _packOwnershipData(
846                 to,
847                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
848             );
849 
850             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
851 
852             _currentIndex = startTokenId + quantity;
853         }
854         _afterTokenTransfers(address(0), to, startTokenId, quantity);
855     }
856 
857     function _safeMint(
858         address to,
859         uint256 quantity,
860         bytes memory _data
861     ) internal virtual {
862         _mint(to, quantity);
863 
864         unchecked {
865             if (to.code.length != 0) {
866                 uint256 end = _currentIndex;
867                 uint256 index = end - quantity;
868                 do {
869                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
870                         revert TransferToNonERC721ReceiverImplementer();
871                     }
872                 } while (index < end);
873                 // Reentrancy protection.
874                 if (_currentIndex != end) revert();
875             }
876         }
877     }
878 
879     function _safeMint(address to, uint256 quantity) internal virtual {
880         _safeMint(to, quantity, '');
881     }
882 
883     function _burn(uint256 tokenId) internal virtual {
884         _burn(tokenId, false);
885     }
886 
887     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
888         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
889 
890         address from = address(uint160(prevOwnershipPacked));
891 
892         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
893 
894         if (approvalCheck) {
895             
896             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
897                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
898         }
899 
900         _beforeTokenTransfers(from, address(0), tokenId, 1);
901 
902         assembly {
903             if approvedAddress {
904                 
905                 sstore(approvedAddressSlot, 0)
906             }
907         }
908 
909         unchecked {
910 
911             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
912 
913             _packedOwnerships[tokenId] = _packOwnershipData(
914                 from,
915                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
916             );
917 
918             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
919                 uint256 nextTokenId = tokenId + 1;
920 
921                 if (_packedOwnerships[nextTokenId] == 0) {
922 
923                     if (nextTokenId != _currentIndex) {
924 
925                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
926                     }
927                 }
928             }
929         }
930 
931         emit Transfer(from, address(0), tokenId);
932         _afterTokenTransfers(from, address(0), tokenId, 1);
933 
934         unchecked {
935             _burnCounter++;
936         }
937     }
938 
939     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
940         uint256 packed = _packedOwnerships[index];
941         if (packed == 0) revert OwnershipNotInitializedForExtraData();
942         uint256 extraDataCasted;
943         assembly {
944             extraDataCasted := extraData
945         }
946         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
947         _packedOwnerships[index] = packed;
948     }
949 
950     function _extraData(
951         address from,
952         address to,
953         uint24 previousExtraData
954     ) internal view virtual returns (uint24) {}
955 
956     function _nextExtraData(
957         address from,
958         address to,
959         uint256 prevOwnershipPacked
960     ) private view returns (uint256) {
961         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
962         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
963     }
964 
965     function _msgSenderERC721A() internal view virtual returns (address) {
966         return msg.sender;
967     }
968 
969     function _toString(uint256 value) internal pure virtual returns (string memory str) {
970         assembly {
971 
972             let m := add(mload(0x40), 0xa0)
973 
974             mstore(0x40, m)
975 
976             str := sub(m, 0x20)
977 
978             mstore(str, 0)
979 
980             let end := str
981 
982             for { let temp := value } 1 {} {
983                 str := sub(str, 1)
984 
985                 mstore8(str, add(48, mod(temp, 10)))
986 
987                 temp := div(temp, 10)
988 
989                 if iszero(temp) { break }
990             }
991 
992             let length := sub(end, str)
993 
994             str := sub(str, 0x20)
995 
996             mstore(str, length)
997         }
998     }
999 }
1000 
1001 pragma solidity ^0.8.13;
1002 
1003 contract OperatorFilterer {
1004     error OperatorNotAllowed(address operator);
1005 
1006     IOperatorFilterRegistry constant operatorFilterRegistry =
1007         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1008 
1009     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1010 
1011         if (address(operatorFilterRegistry).code.length > 0) {
1012             if (subscribe) {
1013                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1014             } else {
1015                 if (subscriptionOrRegistrantToCopy != address(0)) {
1016                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1017                 } else {
1018                     operatorFilterRegistry.register(address(this));
1019                 }
1020             }
1021         }
1022     }
1023 
1024     modifier onlyAllowedOperator() virtual {
1025 
1026         if (address(operatorFilterRegistry).code.length > 0) {
1027             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1028                 revert OperatorNotAllowed(msg.sender);
1029             }
1030         }
1031         _;
1032     }
1033 }
1034 
1035 pragma solidity ^0.8.13;
1036 
1037 contract DefaultOperatorFilterer is OperatorFilterer {
1038     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1039 
1040     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1041 }
1042 
1043 pragma solidity ^0.8.13;
1044 
1045 interface IOperatorFilterRegistry {
1046     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1047     function register(address registrant) external;
1048     function registerAndSubscribe(address registrant, address subscription) external;
1049     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1050     function updateOperator(address registrant, address operator, bool filtered) external;
1051     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1052     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1053     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1054     function subscribe(address registrant, address registrantToSubscribe) external;
1055     function unsubscribe(address registrant, bool copyExistingEntries) external;
1056     function subscriptionOf(address addr) external returns (address registrant);
1057     function subscribers(address registrant) external returns (address[] memory);
1058     function subscriberAt(address registrant, uint256 index) external returns (address);
1059     function copyEntriesOf(address registrant, address registrantToCopy) external;
1060     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1061     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1062     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1063     function filteredOperators(address addr) external returns (address[] memory);
1064     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1065     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1066     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1067     function isRegistered(address addr) external returns (bool);
1068     function codeHashOf(address addr) external returns (bytes32);
1069 }
1070 
1071 pragma solidity ^0.8.4;
1072 
1073 interface IERC721ABurnable is IERC721A {
1074 
1075     function burn(uint256 tokenId) external;
1076 }
1077 
1078 pragma solidity ^0.8.4;
1079 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1080     function burn(uint256 tokenId) public virtual override {
1081         _burn(tokenId, true);
1082     }
1083 }
1084 
1085 
1086 pragma solidity ^0.8.16;
1087 contract HIFIPEPE is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1088 string public CONTRACT_URI = "";
1089 mapping(address => uint) public userHasMinted;
1090 bool public REVEALED;
1091 string public UNREVEALED_URI = "";
1092 string public BASE_URI = "https://nftstorage.link/ipfs/bafybeibzjqwnshv5bkaw47td2f32ofaobp4d2wuadbsdhtso2wm3n7mrfm/";
1093 bool public isPublicMintEnabled = false;
1094 uint public COLLECTION_SIZE = 6969; 
1095 uint public MINT_PRICE = 0.004 ether; 
1096 uint public MAX_BATCH_SIZE = 25;
1097 uint public SUPPLY_PER_WALLET = 57;
1098 uint public FREE_SUPPLY_PER_WALLET = 2;
1099 constructor() ERC721A("HIFI PEPE", "HIFI") {}
1100 
1101 
1102     function TeamMint(uint256 quantity, address receiver) public onlyOwner {
1103         require(
1104             totalSupply() + quantity <= COLLECTION_SIZE,
1105             "No more Pepe in stock!"
1106         );
1107         
1108         _safeMint(receiver, quantity);
1109     }
1110 
1111     modifier callerIsUser() {
1112         require(tx.origin == msg.sender, "The caller is another contract");
1113         _;
1114     }
1115 
1116     function getPrice(uint quantity) public view returns(uint){
1117         uint price;
1118         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1119         if (quantity >= free) {
1120             price = (MINT_PRICE) * (quantity - free);
1121         } else {
1122             price = 0;
1123         }
1124         return price;
1125     }
1126 
1127     function mint(uint quantity)
1128         external
1129         payable
1130         callerIsUser 
1131         nonReentrant
1132     {
1133         uint price;
1134         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1135         if (quantity >= free) {
1136             price = (MINT_PRICE) * (quantity - free);
1137             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1138         } else {
1139             price = 0;
1140             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1141         }
1142 
1143         require(isPublicMintEnabled, "Mint not ready yet!");
1144         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more left!");
1145 
1146         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to mint over over limit");
1147 
1148         require(quantity <= MAX_BATCH_SIZE, "Tried to mint over limit, retry with reduced quantity");
1149         require(msg.value >= price, "Must send more money!");
1150 
1151         _safeMint(msg.sender, quantity);
1152 
1153         if (msg.value > price) {
1154             payable(msg.sender).transfer(msg.value - price);
1155         }
1156     }
1157     function setPublicMintEnabled() public onlyOwner {
1158         isPublicMintEnabled = !isPublicMintEnabled;
1159     }
1160 
1161     function withdrawFunds() external onlyOwner nonReentrant {
1162         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1163         require(success, "Transfer failed.");
1164     }
1165 
1166     function CollectionUrI(bool _revealed, string memory _baseURI) public onlyOwner {
1167         BASE_URI = _baseURI;
1168         REVEALED = _revealed;
1169     }
1170 
1171     function contractURI() public view returns (string memory) {
1172         return CONTRACT_URI;
1173     }
1174 
1175     function setContract(string memory _contractURI) public onlyOwner {
1176         CONTRACT_URI = _contractURI;
1177     }
1178 
1179     function ChangeCollectionSupply(uint256 _new) external onlyOwner {
1180         COLLECTION_SIZE = _new;
1181     }
1182 
1183     function ChangePrice(uint256 _newPrice) external onlyOwner {
1184         MINT_PRICE = _newPrice;
1185     }
1186 
1187     function ChangeFreePerWallet(uint256 _new) external onlyOwner {
1188         FREE_SUPPLY_PER_WALLET = _new;
1189     }
1190 
1191     function ChangeSupplyPerWallet(uint256 _new) external onlyOwner {
1192         SUPPLY_PER_WALLET = _new;
1193     }
1194 
1195     function SetMaxBatchSize(uint256 _new) external onlyOwner {
1196         MAX_BATCH_SIZE = _new;
1197     }
1198 
1199     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1200         super.transferFrom(from, to, tokenId);
1201     }
1202 
1203     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1204         super.safeTransferFrom(from, to, tokenId);
1205     }
1206 
1207     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1208         public payable
1209         override (ERC721A, IERC721A)
1210         onlyAllowedOperator
1211     {
1212         super.safeTransferFrom(from, to, tokenId, data);
1213     }
1214 
1215     function tokenURI(uint256 _tokenId)
1216         public
1217         view
1218         override (ERC721A, IERC721A)
1219         returns (string memory)
1220     {
1221         if (REVEALED) {
1222             return
1223                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1224         } else {
1225             return UNREVEALED_URI;
1226         }
1227     }
1228 
1229 }