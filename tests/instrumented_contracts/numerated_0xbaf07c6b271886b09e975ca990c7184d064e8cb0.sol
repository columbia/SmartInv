1 // SPDX-License-Identifier: MIT     
2 // FREE of charge and as a sign of respect for all $PSYOP holders
3 
4 pragma solidity ^0.8.0;
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 pragma solidity ^0.8.0;
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor() {
22         _transferOwnership(_msgSender());
23     }
24 
25     modifier onlyOwner() {
26         _checkOwner();
27         _;
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     function _checkOwner() internal view virtual {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36     }
37 
38     function renounceOwnership() public virtual onlyOwner {
39         _transferOwnership(address(0));
40     }
41 
42 
43     function transferOwnership(address newOwner) public virtual onlyOwner {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
45         _transferOwnership(newOwner);
46     }
47 
48     function _transferOwnership(address newOwner) internal virtual {
49         address oldOwner = _owner;
50         _owner = newOwner;
51         emit OwnershipTransferred(oldOwner, newOwner);
52     }
53 }
54 
55 pragma solidity ^0.8.0;
56 
57 abstract contract ReentrancyGuard {
58 
59     uint256 private constant _NOT_ENTERED = 1;
60     uint256 private constant _ENTERED = 2;
61 
62     uint256 private _status;
63 
64     constructor() {
65         _status = _NOT_ENTERED;
66     }
67 
68     modifier nonReentrant() {
69         
70         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
71 
72         _status = _ENTERED;
73 
74         _;
75 
76         _status = _NOT_ENTERED;
77     }
78 }
79 
80 pragma solidity ^0.8.0;
81 
82 library Strings {
83     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
84     uint8 private constant _ADDRESS_LENGTH = 20;
85 
86     function toString(uint256 value) internal pure returns (string memory) {
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
120         bytes memory buffer = new bytes(2 * length + 2);
121         buffer[0] = "0";
122         buffer[1] = "x";
123         for (uint256 i = 2 * length + 1; i > 1; --i) {
124             buffer[i] = _HEX_SYMBOLS[value & 0xf];
125             value >>= 4;
126         }
127         require(value == 0, "Strings: hex length insufficient");
128         return string(buffer);
129     }
130 
131     function toHexString(address addr) internal pure returns (string memory) {
132         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
133     }
134 }
135 
136 pragma solidity ^0.8.0;
137 
138 
139 library EnumerableSet {
140 
141 
142     struct Set {
143         // Storage of set values
144         bytes32[] _values;
145 
146         mapping(bytes32 => uint256) _indexes;
147     }
148 
149     function _add(Set storage set, bytes32 value) private returns (bool) {
150         if (!_contains(set, value)) {
151             set._values.push(value);
152 
153             set._indexes[value] = set._values.length;
154             return true;
155         } else {
156             return false;
157         }
158     }
159 
160     function _remove(Set storage set, bytes32 value) private returns (bool) {
161 
162         uint256 valueIndex = set._indexes[value];
163 
164         if (valueIndex != 0) {
165 
166             uint256 toDeleteIndex = valueIndex - 1;
167             uint256 lastIndex = set._values.length - 1;
168 
169             if (lastIndex != toDeleteIndex) {
170                 bytes32 lastValue = set._values[lastIndex];
171 
172                 set._values[toDeleteIndex] = lastValue;
173                 
174                 set._indexes[lastValue] = valueIndex; 
175             }
176 
177             set._values.pop();
178 
179             delete set._indexes[value];
180 
181             return true;
182         } else {
183             return false;
184         }
185     }
186 
187     function _contains(Set storage set, bytes32 value) private view returns (bool) {
188         return set._indexes[value] != 0;
189     }
190 
191     function _length(Set storage set) private view returns (uint256) {
192         return set._values.length;
193     }
194 
195     function _at(Set storage set, uint256 index) private view returns (bytes32) {
196         return set._values[index];
197     }
198 
199     function _values(Set storage set) private view returns (bytes32[] memory) {
200         return set._values;
201     }
202 
203     struct Bytes32Set {
204         Set _inner;
205     }
206 
207     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
208         return _add(set._inner, value);
209     }
210 
211     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
212         return _remove(set._inner, value);
213     }
214 
215     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
216         return _contains(set._inner, value);
217     }
218 
219     function length(Bytes32Set storage set) internal view returns (uint256) {
220         return _length(set._inner);
221     }
222 
223     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
224         return _at(set._inner, index);
225     }
226 
227     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
228         return _values(set._inner);
229     }
230 
231     struct AddressSet {
232         Set _inner;
233     }
234 
235     function add(AddressSet storage set, address value) internal returns (bool) {
236         return _add(set._inner, bytes32(uint256(uint160(value))));
237     }
238 
239     function remove(AddressSet storage set, address value) internal returns (bool) {
240         return _remove(set._inner, bytes32(uint256(uint160(value))));
241     }
242 
243     function contains(AddressSet storage set, address value) internal view returns (bool) {
244         return _contains(set._inner, bytes32(uint256(uint160(value))));
245     }
246 
247     function length(AddressSet storage set) internal view returns (uint256) {
248         return _length(set._inner);
249     }
250 
251     function at(AddressSet storage set, uint256 index) internal view returns (address) {
252         return address(uint160(uint256(_at(set._inner, index))));
253     }
254 
255     function values(AddressSet storage set) internal view returns (address[] memory) {
256         bytes32[] memory store = _values(set._inner);
257         address[] memory result;
258 
259         assembly {
260             result := store
261         }
262 
263         return result;
264     }
265 
266     struct UintSet {
267         Set _inner;
268     }
269 
270     function add(UintSet storage set, uint256 value) internal returns (bool) {
271         return _add(set._inner, bytes32(value));
272     }
273 
274     function remove(UintSet storage set, uint256 value) internal returns (bool) {
275         return _remove(set._inner, bytes32(value));
276     }
277 
278     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
279         return _contains(set._inner, bytes32(value));
280     }
281 
282     function length(UintSet storage set) internal view returns (uint256) {
283         return _length(set._inner);
284     }
285 
286     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
287         return uint256(_at(set._inner, index));
288     }
289 
290     function values(UintSet storage set) internal view returns (uint256[] memory) {
291         bytes32[] memory store = _values(set._inner);
292         uint256[] memory result;
293 
294         /// @solidity memory-safe-assembly
295         assembly {
296             result := store
297         }
298 
299         return result;
300     }
301 }
302 
303 pragma solidity ^0.8.4;
304 
305 interface IERC721A {
306 
307     error ApprovalCallerNotOwnerNorApproved();
308 
309     error ApprovalQueryForNonexistentToken();
310 
311     error BalanceQueryForZeroAddress();
312 
313     error MintToZeroAddress();
314 
315     error MintZeroQuantity();
316 
317     error OwnerQueryForNonexistentToken();
318 
319     error TransferCallerNotOwnerNorApproved();
320 
321     error TransferFromIncorrectOwner();
322 
323     error TransferToNonERC721ReceiverImplementer();
324 
325     error TransferToZeroAddress();
326 
327     error URIQueryForNonexistentToken();
328 
329     error MintERC2309QuantityExceedsLimit();
330 
331     error OwnershipNotInitializedForExtraData();
332 
333     struct TokenOwnership {
334 
335         address addr;
336 
337         uint64 startTimestamp;
338 
339         bool burned;
340 
341         uint24 extraData;
342     }
343 
344     function totalSupply() external view returns (uint256);
345 
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 
348     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
349 
350     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
351 
352     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
353 
354     function balanceOf(address owner) external view returns (uint256 balance);
355 
356     function ownerOf(uint256 tokenId) external view returns (address owner);
357 
358     function safeTransferFrom(
359         address from,
360         address to,
361         uint256 tokenId,
362         bytes calldata data
363     ) external payable;
364 
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId
369     ) external payable;
370 
371     function transferFrom(
372         address from,
373         address to,
374         uint256 tokenId
375     ) external payable;
376 
377     function approve(address to, uint256 tokenId) external payable;
378 
379     function setApprovalForAll(address operator, bool _approved) external;
380 
381     function getApproved(uint256 tokenId) external view returns (address operator);
382 
383     function isApprovedForAll(address owner, address operator) external view returns (bool);
384 
385     function name() external view returns (string memory);
386 
387     function symbol() external view returns (string memory);
388 
389     function tokenURI(uint256 tokenId) external view returns (string memory);
390 
391     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
392 }
393 
394 pragma solidity ^0.8.4;
395 
396 interface ERC721A__IERC721Receiver {
397     function onERC721Received(
398         address operator,
399         address from,
400         uint256 tokenId,
401         bytes calldata data
402     ) external returns (bytes4);
403 }
404 
405 contract ERC721A is IERC721A {
406 
407     struct TokenApprovalRef {
408         address value;
409     }
410 
411     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
412 
413     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
414 
415     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
416 
417     uint256 private constant _BITPOS_AUX = 192;
418 
419     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
420 
421     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
422 
423     uint256 private constant _BITMASK_BURNED = 1 << 224;
424 
425     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
426 
427     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
428 
429     uint256 private constant _BITPOS_EXTRA_DATA = 232;
430 
431     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
432 
433     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
434 
435     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
436 
437     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
438         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
439 
440     uint256 private _currentIndex;
441 
442     uint256 private _burnCounter;
443 
444     string private _name;
445 
446     string private _symbol;
447 
448     mapping(uint256 => uint256) private _packedOwnerships;
449 
450     mapping(address => uint256) private _packedAddressData;
451 
452     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
453 
454     mapping(address => mapping(address => bool)) private _operatorApprovals;
455 
456     constructor(string memory name_, string memory symbol_) {
457         _name = name_;
458         _symbol = symbol_;
459         _currentIndex = _startTokenId();
460     }
461 
462     function _startTokenId() internal view virtual returns (uint256) {
463         return 0;
464     }
465 
466     function _nextTokenId() internal view virtual returns (uint256) {
467         return _currentIndex;
468     }
469 
470     function totalSupply() public view virtual override returns (uint256) {
471 
472         unchecked {
473             return _currentIndex - _burnCounter - _startTokenId();
474         }
475     }
476 
477     function _totalMinted() internal view virtual returns (uint256) {
478 
479         unchecked {
480             return _currentIndex - _startTokenId();
481         }
482     }
483 
484     function _totalBurned() internal view virtual returns (uint256) {
485         return _burnCounter;
486     }
487 
488     function balanceOf(address owner) public view virtual override returns (uint256) {
489         if (owner == address(0)) revert BalanceQueryForZeroAddress();
490         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
491     }
492 
493     function _numberMinted(address owner) internal view returns (uint256) {
494         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
495     }
496 
497     function _numberBurned(address owner) internal view returns (uint256) {
498         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
499     }
500 
501     function _getAux(address owner) internal view returns (uint64) {
502         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
503     }
504 
505     function _setAux(address owner, uint64 aux) internal virtual {
506         uint256 packed = _packedAddressData[owner];
507         uint256 auxCasted;
508         // Cast `aux` with assembly to avoid redundant masking.
509         assembly {
510             auxCasted := aux
511         }
512         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
513         _packedAddressData[owner] = packed;
514     }
515 
516 
517     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518 
519         return
520             interfaceId == 0x01ffc9a7 || 
521             interfaceId == 0x80ac58cd || 
522             interfaceId == 0x5b5e139f; 
523     }
524 
525     function name() public view virtual override returns (string memory) {
526         return _name;
527     }
528 
529     function symbol() public view virtual override returns (string memory) {
530         return _symbol;
531     }
532 
533     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
534         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
535 
536         string memory baseURI = _baseURI();
537         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
538     }
539 
540     function _baseURI() internal view virtual returns (string memory) {
541         return '';
542     }
543 
544     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
545         return address(uint160(_packedOwnershipOf(tokenId)));
546     }
547 
548     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
549         return _unpackedOwnership(_packedOwnershipOf(tokenId));
550     }
551 
552     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
553         return _unpackedOwnership(_packedOwnerships[index]);
554     }
555 
556     function _initializeOwnershipAt(uint256 index) internal virtual {
557         if (_packedOwnerships[index] == 0) {
558             _packedOwnerships[index] = _packedOwnershipOf(index);
559         }
560     }
561 
562     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
563         uint256 curr = tokenId;
564 
565         unchecked {
566             if (_startTokenId() <= curr)
567                 if (curr < _currentIndex) {
568                     uint256 packed = _packedOwnerships[curr];
569 
570                     if (packed & _BITMASK_BURNED == 0) {
571 
572                         while (packed == 0) {
573                             packed = _packedOwnerships[--curr];
574                         }
575                         return packed;
576                     }
577                 }
578         }
579         revert OwnerQueryForNonexistentToken();
580     }
581 
582     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
583         ownership.addr = address(uint160(packed));
584         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
585         ownership.burned = packed & _BITMASK_BURNED != 0;
586         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
587     }
588 
589     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
590         assembly {
591             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
592             owner := and(owner, _BITMASK_ADDRESS)
593             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
594             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
595         }
596     }
597 
598     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
599         // For branchless setting of the `nextInitialized` flag.
600         assembly {
601             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
602             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
603         }
604     }
605 
606     function approve(address to, uint256 tokenId) public payable virtual override {
607         address owner = ownerOf(tokenId);
608 
609         if (_msgSenderERC721A() != owner)
610             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
611                 revert ApprovalCallerNotOwnerNorApproved();
612             }
613 
614         _tokenApprovals[tokenId].value = to;
615         emit Approval(owner, to, tokenId);
616     }
617 
618     function getApproved(uint256 tokenId) public view virtual override returns (address) {
619         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
620 
621         return _tokenApprovals[tokenId].value;
622     }
623 
624     function setApprovalForAll(address operator, bool approved) public virtual override {
625         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
626         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
627     }
628 
629     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
630         return _operatorApprovals[owner][operator];
631     }
632 
633     function _exists(uint256 tokenId) internal view virtual returns (bool) {
634         return
635             _startTokenId() <= tokenId &&
636             tokenId < _currentIndex && // If within bounds,
637             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
638     }
639 
640     function _isSenderApprovedOrOwner(
641         address approvedAddress,
642         address owner,
643         address msgSender
644     ) private pure returns (bool result) {
645         assembly {
646 
647             owner := and(owner, _BITMASK_ADDRESS)
648 
649             msgSender := and(msgSender, _BITMASK_ADDRESS)
650 
651             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
652         }
653     }
654 
655     function _getApprovedSlotAndAddress(uint256 tokenId)
656         private
657         view
658         returns (uint256 approvedAddressSlot, address approvedAddress)
659     {
660         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
661 
662         assembly {
663             approvedAddressSlot := tokenApproval.slot
664             approvedAddress := sload(approvedAddressSlot)
665         }
666     }
667 
668     function transferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) public payable virtual override {
673         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
674 
675         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
676 
677         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
678 
679         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
680             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
681 
682         if (to == address(0)) revert TransferToZeroAddress();
683 
684         _beforeTokenTransfers(from, to, tokenId, 1);
685 
686         assembly {
687             if approvedAddress {
688 
689                 sstore(approvedAddressSlot, 0)
690             }
691         }
692 
693         unchecked {
694 
695             --_packedAddressData[from]; 
696             ++_packedAddressData[to]; 
697 
698             _packedOwnerships[tokenId] = _packOwnershipData(
699                 to,
700                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
701             );
702 
703             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
704                 uint256 nextTokenId = tokenId + 1;
705 
706                 if (_packedOwnerships[nextTokenId] == 0) {
707 
708                     if (nextTokenId != _currentIndex) {
709 
710                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
711                     }
712                 }
713             }
714         }
715 
716         emit Transfer(from, to, tokenId);
717         _afterTokenTransfers(from, to, tokenId, 1);
718     }
719 
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) public payable virtual override {
725         safeTransferFrom(from, to, tokenId, '');
726     }
727 
728     function safeTransferFrom(
729         address from,
730         address to,
731         uint256 tokenId,
732         bytes memory _data
733     ) public payable virtual override {
734         transferFrom(from, to, tokenId);
735         if (to.code.length != 0)
736             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
737                 revert TransferToNonERC721ReceiverImplementer();
738             }
739     }
740 
741     function _beforeTokenTransfers(
742         address from,
743         address to,
744         uint256 startTokenId,
745         uint256 quantity
746     ) internal virtual {}
747 
748     function _afterTokenTransfers(
749         address from,
750         address to,
751         uint256 startTokenId,
752         uint256 quantity
753     ) internal virtual {}
754 
755     function _checkContractOnERC721Received(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes memory _data
760     ) private returns (bool) {
761         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
762             bytes4 retval
763         ) {
764             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
765         } catch (bytes memory reason) {
766             if (reason.length == 0) {
767                 revert TransferToNonERC721ReceiverImplementer();
768             } else {
769                 assembly {
770                     revert(add(32, reason), mload(reason))
771                 }
772             }
773         }
774     }
775 
776     function _mint(address to, uint256 quantity) internal virtual {
777         uint256 startTokenId = _currentIndex;
778         if (quantity == 0) revert MintZeroQuantity();
779 
780         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
781 
782         unchecked {
783 
784             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
785 
786             _packedOwnerships[startTokenId] = _packOwnershipData(
787                 to,
788                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
789             );
790 
791             uint256 toMasked;
792             uint256 end = startTokenId + quantity;
793 
794             assembly {
795 
796                 toMasked := and(to, _BITMASK_ADDRESS)
797 
798                 log4(
799                     0, 
800                     0, 
801                     _TRANSFER_EVENT_SIGNATURE, 
802                     0, 
803                     toMasked, 
804                     startTokenId 
805                 )
806 
807                 for {
808                     let tokenId := add(startTokenId, 1)
809                 } iszero(eq(tokenId, end)) {
810                     tokenId := add(tokenId, 1)
811                 } {
812 
813                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
814                 }
815             }
816             if (toMasked == 0) revert MintToZeroAddress();
817 
818             _currentIndex = end;
819         }
820         _afterTokenTransfers(address(0), to, startTokenId, quantity);
821     }
822 
823     function _mintERC2309(address to, uint256 quantity) internal virtual {
824         uint256 startTokenId = _currentIndex;
825         if (to == address(0)) revert MintToZeroAddress();
826         if (quantity == 0) revert MintZeroQuantity();
827         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
828 
829         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
830 
831         unchecked {
832 
833             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
834 
835             _packedOwnerships[startTokenId] = _packOwnershipData(
836                 to,
837                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
838             );
839 
840             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
841 
842             _currentIndex = startTokenId + quantity;
843         }
844         _afterTokenTransfers(address(0), to, startTokenId, quantity);
845     }
846 
847     function _safeMint(
848         address to,
849         uint256 quantity,
850         bytes memory _data
851     ) internal virtual {
852         _mint(to, quantity);
853 
854         unchecked {
855             if (to.code.length != 0) {
856                 uint256 end = _currentIndex;
857                 uint256 index = end - quantity;
858                 do {
859                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
860                         revert TransferToNonERC721ReceiverImplementer();
861                     }
862                 } while (index < end);
863                 // Reentrancy protection.
864                 if (_currentIndex != end) revert();
865             }
866         }
867     }
868 
869     function _safeMint(address to, uint256 quantity) internal virtual {
870         _safeMint(to, quantity, '');
871     }
872 
873     function _burn(uint256 tokenId) internal virtual {
874         _burn(tokenId, false);
875     }
876 
877     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
878         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
879 
880         address from = address(uint160(prevOwnershipPacked));
881 
882         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
883 
884         if (approvalCheck) {
885             
886             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
887                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
888         }
889 
890         _beforeTokenTransfers(from, address(0), tokenId, 1);
891 
892         assembly {
893             if approvedAddress {
894                 
895                 sstore(approvedAddressSlot, 0)
896             }
897         }
898 
899         unchecked {
900 
901             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
902 
903             _packedOwnerships[tokenId] = _packOwnershipData(
904                 from,
905                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
906             );
907 
908             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
909                 uint256 nextTokenId = tokenId + 1;
910 
911                 if (_packedOwnerships[nextTokenId] == 0) {
912 
913                     if (nextTokenId != _currentIndex) {
914 
915                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
916                     }
917                 }
918             }
919         }
920 
921         emit Transfer(from, address(0), tokenId);
922         _afterTokenTransfers(from, address(0), tokenId, 1);
923 
924         unchecked {
925             _burnCounter++;
926         }
927     }
928 
929     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
930         uint256 packed = _packedOwnerships[index];
931         if (packed == 0) revert OwnershipNotInitializedForExtraData();
932         uint256 extraDataCasted;
933         assembly {
934             extraDataCasted := extraData
935         }
936         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
937         _packedOwnerships[index] = packed;
938     }
939 
940     function _extraData(
941         address from,
942         address to,
943         uint24 previousExtraData
944     ) internal view virtual returns (uint24) {}
945 
946     function _nextExtraData(
947         address from,
948         address to,
949         uint256 prevOwnershipPacked
950     ) private view returns (uint256) {
951         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
952         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
953     }
954 
955     function _msgSenderERC721A() internal view virtual returns (address) {
956         return msg.sender;
957     }
958 
959     function _toString(uint256 value) internal pure virtual returns (string memory str) {
960         assembly {
961 
962             let m := add(mload(0x40), 0xa0)
963 
964             mstore(0x40, m)
965 
966             str := sub(m, 0x20)
967 
968             mstore(str, 0)
969 
970             let end := str
971 
972             for { let temp := value } 1 {} {
973                 str := sub(str, 1)
974 
975                 mstore8(str, add(48, mod(temp, 10)))
976 
977                 temp := div(temp, 10)
978 
979                 if iszero(temp) { break }
980             }
981 
982             let length := sub(end, str)
983 
984             str := sub(str, 0x20)
985 
986             mstore(str, length)
987         }
988     }
989 }
990 
991 pragma solidity ^0.8.13;
992 
993 contract OperatorFilterer {
994     error OperatorNotAllowed(address operator);
995 
996     IOperatorFilterRegistry constant operatorFilterRegistry =
997         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
998 
999     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1000 
1001         if (address(operatorFilterRegistry).code.length > 0) {
1002             if (subscribe) {
1003                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1004             } else {
1005                 if (subscriptionOrRegistrantToCopy != address(0)) {
1006                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1007                 } else {
1008                     operatorFilterRegistry.register(address(this));
1009                 }
1010             }
1011         }
1012     }
1013 
1014     modifier onlyAllowedOperator() virtual {
1015 
1016         if (address(operatorFilterRegistry).code.length > 0) {
1017             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1018                 revert OperatorNotAllowed(msg.sender);
1019             }
1020         }
1021         _;
1022     }
1023 }
1024 
1025 pragma solidity ^0.8.13;
1026 
1027 contract DefaultOperatorFilterer is OperatorFilterer {
1028     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1029 
1030     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1031 }
1032 
1033 pragma solidity ^0.8.13;
1034 
1035 interface IOperatorFilterRegistry {
1036     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1037     function register(address registrant) external;
1038     function registerAndSubscribe(address registrant, address subscription) external;
1039     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1040     function updateOperator(address registrant, address operator, bool filtered) external;
1041     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1042     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1043     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1044     function subscribe(address registrant, address registrantToSubscribe) external;
1045     function unsubscribe(address registrant, bool copyExistingEntries) external;
1046     function subscriptionOf(address addr) external returns (address registrant);
1047     function subscribers(address registrant) external returns (address[] memory);
1048     function subscriberAt(address registrant, uint256 index) external returns (address);
1049     function copyEntriesOf(address registrant, address registrantToCopy) external;
1050     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1051     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1052     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1053     function filteredOperators(address addr) external returns (address[] memory);
1054     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1055     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1056     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1057     function isRegistered(address addr) external returns (bool);
1058     function codeHashOf(address addr) external returns (bytes32);
1059 }
1060 
1061 pragma solidity ^0.8.4;
1062 
1063 interface IERC721ABurnable is IERC721A {
1064 
1065     function burn(uint256 tokenId) external;
1066 }
1067 
1068 pragma solidity ^0.8.4;
1069 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1070     function burn(uint256 tokenId) public virtual override {
1071         _burn(tokenId, true);
1072     }
1073 }
1074 
1075 
1076 pragma solidity ^0.8.16;
1077 contract Psyop is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1078 string public CONTRACT_URI = "";
1079 mapping(address => uint) public userHasMinted;
1080 bool public REVEALED;
1081 string public UNREVEALED_URI = "";
1082 string public BASE_URI = "";
1083 bool public isPublicMintEnabled = false;
1084 uint public COLLECTION_SIZE = 10000; 
1085 uint public MINT_PRICE = 0.003 ether; 
1086 uint public MAX_BATCH_SIZE = 25;
1087 uint public SUPPLY_PER_WALLET = 57;
1088 uint public FREE_SUPPLY_PER_WALLET = 2;
1089 constructor() ERC721A("PSYOP GANG", "PSYOP") {}
1090 
1091 
1092     function TeamMint(uint256 quantity, address receiver) public onlyOwner {
1093         require(
1094             totalSupply() + quantity <= COLLECTION_SIZE,
1095             "No more PSYOP in stock!"
1096         );
1097         
1098         _safeMint(receiver, quantity);
1099     }
1100 
1101     modifier callerIsUser() {
1102         require(tx.origin == msg.sender, "The caller is another contract");
1103         _;
1104     }
1105 
1106     function getPrice(uint quantity) public view returns(uint){
1107         uint price;
1108         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1109         if (quantity >= free) {
1110             price = (MINT_PRICE) * (quantity - free);
1111         } else {
1112             price = 0;
1113         }
1114         return price;
1115     }
1116 
1117     function mint(uint quantity)
1118         external
1119         payable
1120         callerIsUser 
1121         nonReentrant
1122     {
1123         uint price;
1124         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1125         if (quantity >= free) {
1126             price = (MINT_PRICE) * (quantity - free);
1127             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1128         } else {
1129             price = 0;
1130             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1131         }
1132 
1133         require(isPublicMintEnabled, "Mint not ready yet!");
1134         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more left!");
1135 
1136         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to mint over over limit");
1137 
1138         require(quantity <= MAX_BATCH_SIZE, "Tried to mint over limit, retry with reduced quantity");
1139         require(msg.value >= price, "Must send more money!");
1140 
1141         _safeMint(msg.sender, quantity);
1142 
1143         if (msg.value > price) {
1144             payable(msg.sender).transfer(msg.value - price);
1145         }
1146     }
1147     function setPublicMintEnabled() public onlyOwner {
1148         isPublicMintEnabled = !isPublicMintEnabled;
1149     }
1150 
1151     function withdrawFunds() external onlyOwner nonReentrant {
1152         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1153         require(success, "Transfer failed.");
1154     }
1155 
1156     function CollectionUrI(bool _revealed, string memory _baseURI) public onlyOwner {
1157         BASE_URI = _baseURI;
1158         REVEALED = _revealed;
1159     }
1160 
1161     function contractURI() public view returns (string memory) {
1162         return CONTRACT_URI;
1163     }
1164 
1165     function setContract(string memory _contractURI) public onlyOwner {
1166         CONTRACT_URI = _contractURI;
1167     }
1168 
1169     function ChangeCollectionSupply(uint256 _new) external onlyOwner {
1170         COLLECTION_SIZE = _new;
1171     }
1172 
1173     function ChangePrice(uint256 _newPrice) external onlyOwner {
1174         MINT_PRICE = _newPrice;
1175     }
1176 
1177     function ChangeFreePerWallet(uint256 _new) external onlyOwner {
1178         FREE_SUPPLY_PER_WALLET = _new;
1179     }
1180 
1181     function ChangeSupplyPerWallet(uint256 _new) external onlyOwner {
1182         SUPPLY_PER_WALLET = _new;
1183     }
1184 
1185     function SetMaxBatchSize(uint256 _new) external onlyOwner {
1186         MAX_BATCH_SIZE = _new;
1187     }
1188 
1189     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1190         super.transferFrom(from, to, tokenId);
1191     }
1192 
1193     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1194         super.safeTransferFrom(from, to, tokenId);
1195     }
1196 
1197     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1198         public payable
1199         override (ERC721A, IERC721A)
1200         onlyAllowedOperator
1201     {
1202         super.safeTransferFrom(from, to, tokenId, data);
1203     }
1204 
1205     function tokenURI(uint256 _tokenId)
1206         public
1207         view
1208         override (ERC721A, IERC721A)
1209         returns (string memory)
1210     {
1211         if (REVEALED) {
1212             return
1213                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1214         } else {
1215             return UNREVEALED_URI;
1216         }
1217     }
1218 
1219 }