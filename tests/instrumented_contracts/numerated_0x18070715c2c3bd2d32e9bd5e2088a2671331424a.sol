1 // SPDX-License-Identifier: MIT     
2 
3 pragma solidity ^0.8.0;
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 pragma solidity ^0.8.0;
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor() {
21         _transferOwnership(_msgSender());
22     }
23 
24     modifier onlyOwner() {
25         _checkOwner();
26         _;
27     }
28 
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     function _checkOwner() internal view virtual {
34         require(owner() == _msgSender(), "Ownable: caller is not the owner");
35     }
36 
37     function renounceOwnership() public virtual onlyOwner {
38         _transferOwnership(address(0));
39     }
40 
41 
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46 
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 pragma solidity ^0.8.0;
55 
56 abstract contract ReentrancyGuard {
57 
58     uint256 private constant _NOT_ENTERED = 1;
59     uint256 private constant _ENTERED = 2;
60 
61     uint256 private _status;
62 
63     constructor() {
64         _status = _NOT_ENTERED;
65     }
66 
67     modifier nonReentrant() {
68         
69         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
70 
71         _status = _ENTERED;
72 
73         _;
74 
75         _status = _NOT_ENTERED;
76     }
77 }
78 
79 pragma solidity ^0.8.0;
80 
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83     uint8 private constant _ADDRESS_LENGTH = 20;
84 
85     function toString(uint256 value) internal pure returns (string memory) {
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
119         bytes memory buffer = new bytes(2 * length + 2);
120         buffer[0] = "0";
121         buffer[1] = "x";
122         for (uint256 i = 2 * length + 1; i > 1; --i) {
123             buffer[i] = _HEX_SYMBOLS[value & 0xf];
124             value >>= 4;
125         }
126         require(value == 0, "Strings: hex length insufficient");
127         return string(buffer);
128     }
129 
130     function toHexString(address addr) internal pure returns (string memory) {
131         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
132     }
133 }
134 
135 pragma solidity ^0.8.0;
136 
137 
138 library EnumerableSet {
139 
140 
141     struct Set {
142         // Storage of set values
143         bytes32[] _values;
144 
145         mapping(bytes32 => uint256) _indexes;
146     }
147 
148     function _add(Set storage set, bytes32 value) private returns (bool) {
149         if (!_contains(set, value)) {
150             set._values.push(value);
151 
152             set._indexes[value] = set._values.length;
153             return true;
154         } else {
155             return false;
156         }
157     }
158 
159     function _remove(Set storage set, bytes32 value) private returns (bool) {
160 
161         uint256 valueIndex = set._indexes[value];
162 
163         if (valueIndex != 0) {
164 
165             uint256 toDeleteIndex = valueIndex - 1;
166             uint256 lastIndex = set._values.length - 1;
167 
168             if (lastIndex != toDeleteIndex) {
169                 bytes32 lastValue = set._values[lastIndex];
170 
171                 set._values[toDeleteIndex] = lastValue;
172                 
173                 set._indexes[lastValue] = valueIndex; 
174             }
175 
176             set._values.pop();
177 
178             delete set._indexes[value];
179 
180             return true;
181         } else {
182             return false;
183         }
184     }
185 
186     function _contains(Set storage set, bytes32 value) private view returns (bool) {
187         return set._indexes[value] != 0;
188     }
189 
190     function _length(Set storage set) private view returns (uint256) {
191         return set._values.length;
192     }
193 
194     function _at(Set storage set, uint256 index) private view returns (bytes32) {
195         return set._values[index];
196     }
197 
198     function _values(Set storage set) private view returns (bytes32[] memory) {
199         return set._values;
200     }
201 
202     struct Bytes32Set {
203         Set _inner;
204     }
205 
206     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
207         return _add(set._inner, value);
208     }
209 
210     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
211         return _remove(set._inner, value);
212     }
213 
214     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
215         return _contains(set._inner, value);
216     }
217 
218     function length(Bytes32Set storage set) internal view returns (uint256) {
219         return _length(set._inner);
220     }
221 
222     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
223         return _at(set._inner, index);
224     }
225 
226     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
227         return _values(set._inner);
228     }
229 
230     struct AddressSet {
231         Set _inner;
232     }
233 
234     function add(AddressSet storage set, address value) internal returns (bool) {
235         return _add(set._inner, bytes32(uint256(uint160(value))));
236     }
237 
238     function remove(AddressSet storage set, address value) internal returns (bool) {
239         return _remove(set._inner, bytes32(uint256(uint160(value))));
240     }
241 
242     function contains(AddressSet storage set, address value) internal view returns (bool) {
243         return _contains(set._inner, bytes32(uint256(uint160(value))));
244     }
245 
246     function length(AddressSet storage set) internal view returns (uint256) {
247         return _length(set._inner);
248     }
249 
250     function at(AddressSet storage set, uint256 index) internal view returns (address) {
251         return address(uint160(uint256(_at(set._inner, index))));
252     }
253 
254     function values(AddressSet storage set) internal view returns (address[] memory) {
255         bytes32[] memory store = _values(set._inner);
256         address[] memory result;
257 
258         assembly {
259             result := store
260         }
261 
262         return result;
263     }
264 
265     struct UintSet {
266         Set _inner;
267     }
268 
269     function add(UintSet storage set, uint256 value) internal returns (bool) {
270         return _add(set._inner, bytes32(value));
271     }
272 
273     function remove(UintSet storage set, uint256 value) internal returns (bool) {
274         return _remove(set._inner, bytes32(value));
275     }
276 
277     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
278         return _contains(set._inner, bytes32(value));
279     }
280 
281     function length(UintSet storage set) internal view returns (uint256) {
282         return _length(set._inner);
283     }
284 
285     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
286         return uint256(_at(set._inner, index));
287     }
288 
289     function values(UintSet storage set) internal view returns (uint256[] memory) {
290         bytes32[] memory store = _values(set._inner);
291         uint256[] memory result;
292 
293         /// @solidity memory-safe-assembly
294         assembly {
295             result := store
296         }
297 
298         return result;
299     }
300 }
301 
302 pragma solidity ^0.8.4;
303 
304 interface IERC721A {
305 
306     error ApprovalCallerNotOwnerNorApproved();
307 
308     error ApprovalQueryForNonexistentToken();
309 
310     error BalanceQueryForZeroAddress();
311 
312     error MintToZeroAddress();
313 
314     error MintZeroQuantity();
315 
316     error OwnerQueryForNonexistentToken();
317 
318     error TransferCallerNotOwnerNorApproved();
319 
320     error TransferFromIncorrectOwner();
321 
322     error TransferToNonERC721ReceiverImplementer();
323 
324     error TransferToZeroAddress();
325 
326     error URIQueryForNonexistentToken();
327 
328     error MintERC2309QuantityExceedsLimit();
329 
330     error OwnershipNotInitializedForExtraData();
331 
332     struct TokenOwnership {
333 
334         address addr;
335 
336         uint64 startTimestamp;
337 
338         bool burned;
339 
340         uint24 extraData;
341     }
342 
343     function totalSupply() external view returns (uint256);
344 
345     function supportsInterface(bytes4 interfaceId) external view returns (bool);
346 
347     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
348 
349     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
350 
351     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
352 
353     function balanceOf(address owner) external view returns (uint256 balance);
354 
355     function ownerOf(uint256 tokenId) external view returns (address owner);
356 
357     function safeTransferFrom(
358         address from,
359         address to,
360         uint256 tokenId,
361         bytes calldata data
362     ) external payable;
363 
364     function safeTransferFrom(
365         address from,
366         address to,
367         uint256 tokenId
368     ) external payable;
369 
370     function transferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external payable;
375 
376     function approve(address to, uint256 tokenId) external payable;
377 
378     function setApprovalForAll(address operator, bool _approved) external;
379 
380     function getApproved(uint256 tokenId) external view returns (address operator);
381 
382     function isApprovedForAll(address owner, address operator) external view returns (bool);
383 
384     function name() external view returns (string memory);
385 
386     function symbol() external view returns (string memory);
387 
388     function tokenURI(uint256 tokenId) external view returns (string memory);
389 
390     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
391 }
392 
393 pragma solidity ^0.8.4;
394 
395 interface ERC721A__IERC721Receiver {
396     function onERC721Received(
397         address operator,
398         address from,
399         uint256 tokenId,
400         bytes calldata data
401     ) external returns (bytes4);
402 }
403 
404 contract ERC721A is IERC721A {
405 
406     struct TokenApprovalRef {
407         address value;
408     }
409 
410     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
411 
412     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
413 
414     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
415 
416     uint256 private constant _BITPOS_AUX = 192;
417 
418     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
419 
420     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
421 
422     uint256 private constant _BITMASK_BURNED = 1 << 224;
423 
424     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
425 
426     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
427 
428     uint256 private constant _BITPOS_EXTRA_DATA = 232;
429 
430     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
431 
432     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
433 
434     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
435 
436     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
437         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
438 
439     uint256 private _currentIndex;
440 
441     uint256 private _burnCounter;
442 
443     string private _name;
444 
445     string private _symbol;
446 
447     mapping(uint256 => uint256) private _packedOwnerships;
448 
449     mapping(address => uint256) private _packedAddressData;
450 
451     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
452 
453     mapping(address => mapping(address => bool)) private _operatorApprovals;
454 
455     constructor(string memory name_, string memory symbol_) {
456         _name = name_;
457         _symbol = symbol_;
458         _currentIndex = _startTokenId();
459     }
460 
461     function _startTokenId() internal view virtual returns (uint256) {
462         return 0;
463     }
464 
465     function _nextTokenId() internal view virtual returns (uint256) {
466         return _currentIndex;
467     }
468 
469     function totalSupply() public view virtual override returns (uint256) {
470 
471         unchecked {
472             return _currentIndex - _burnCounter - _startTokenId();
473         }
474     }
475 
476     function _totalMinted() internal view virtual returns (uint256) {
477 
478         unchecked {
479             return _currentIndex - _startTokenId();
480         }
481     }
482 
483     function _totalBurned() internal view virtual returns (uint256) {
484         return _burnCounter;
485     }
486 
487     function balanceOf(address owner) public view virtual override returns (uint256) {
488         if (owner == address(0)) revert BalanceQueryForZeroAddress();
489         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
490     }
491 
492     function _numberMinted(address owner) internal view returns (uint256) {
493         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
494     }
495 
496     function _numberBurned(address owner) internal view returns (uint256) {
497         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
498     }
499 
500     function _getAux(address owner) internal view returns (uint64) {
501         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
502     }
503 
504     function _setAux(address owner, uint64 aux) internal virtual {
505         uint256 packed = _packedAddressData[owner];
506         uint256 auxCasted;
507         // Cast `aux` with assembly to avoid redundant masking.
508         assembly {
509             auxCasted := aux
510         }
511         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
512         _packedAddressData[owner] = packed;
513     }
514 
515 
516     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517 
518         return
519             interfaceId == 0x01ffc9a7 || 
520             interfaceId == 0x80ac58cd || 
521             interfaceId == 0x5b5e139f; 
522     }
523 
524     function name() public view virtual override returns (string memory) {
525         return _name;
526     }
527 
528     function symbol() public view virtual override returns (string memory) {
529         return _symbol;
530     }
531 
532     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
533         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
534 
535         string memory baseURI = _baseURI();
536         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
537     }
538 
539     function _baseURI() internal view virtual returns (string memory) {
540         return '';
541     }
542 
543     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
544         return address(uint160(_packedOwnershipOf(tokenId)));
545     }
546 
547     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
548         return _unpackedOwnership(_packedOwnershipOf(tokenId));
549     }
550 
551     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
552         return _unpackedOwnership(_packedOwnerships[index]);
553     }
554 
555     function _initializeOwnershipAt(uint256 index) internal virtual {
556         if (_packedOwnerships[index] == 0) {
557             _packedOwnerships[index] = _packedOwnershipOf(index);
558         }
559     }
560 
561     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
562         uint256 curr = tokenId;
563 
564         unchecked {
565             if (_startTokenId() <= curr)
566                 if (curr < _currentIndex) {
567                     uint256 packed = _packedOwnerships[curr];
568 
569                     if (packed & _BITMASK_BURNED == 0) {
570 
571                         while (packed == 0) {
572                             packed = _packedOwnerships[--curr];
573                         }
574                         return packed;
575                     }
576                 }
577         }
578         revert OwnerQueryForNonexistentToken();
579     }
580 
581     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
582         ownership.addr = address(uint160(packed));
583         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
584         ownership.burned = packed & _BITMASK_BURNED != 0;
585         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
586     }
587 
588     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
589         assembly {
590             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
591             owner := and(owner, _BITMASK_ADDRESS)
592             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
593             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
594         }
595     }
596 
597     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
598         // For branchless setting of the `nextInitialized` flag.
599         assembly {
600             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
601             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
602         }
603     }
604 
605     function approve(address to, uint256 tokenId) public payable virtual override {
606         address owner = ownerOf(tokenId);
607 
608         if (_msgSenderERC721A() != owner)
609             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
610                 revert ApprovalCallerNotOwnerNorApproved();
611             }
612 
613         _tokenApprovals[tokenId].value = to;
614         emit Approval(owner, to, tokenId);
615     }
616 
617     function getApproved(uint256 tokenId) public view virtual override returns (address) {
618         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
619 
620         return _tokenApprovals[tokenId].value;
621     }
622 
623     function setApprovalForAll(address operator, bool approved) public virtual override {
624         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
625         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
626     }
627 
628     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
629         return _operatorApprovals[owner][operator];
630     }
631 
632     function _exists(uint256 tokenId) internal view virtual returns (bool) {
633         return
634             _startTokenId() <= tokenId &&
635             tokenId < _currentIndex && // If within bounds,
636             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
637     }
638 
639     function _isSenderApprovedOrOwner(
640         address approvedAddress,
641         address owner,
642         address msgSender
643     ) private pure returns (bool result) {
644         assembly {
645 
646             owner := and(owner, _BITMASK_ADDRESS)
647 
648             msgSender := and(msgSender, _BITMASK_ADDRESS)
649 
650             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
651         }
652     }
653 
654     function _getApprovedSlotAndAddress(uint256 tokenId)
655         private
656         view
657         returns (uint256 approvedAddressSlot, address approvedAddress)
658     {
659         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
660 
661         assembly {
662             approvedAddressSlot := tokenApproval.slot
663             approvedAddress := sload(approvedAddressSlot)
664         }
665     }
666 
667     function transferFrom(
668         address from,
669         address to,
670         uint256 tokenId
671     ) public payable virtual override {
672         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
673 
674         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
675 
676         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
677 
678         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
679             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
680 
681         if (to == address(0)) revert TransferToZeroAddress();
682 
683         _beforeTokenTransfers(from, to, tokenId, 1);
684 
685         assembly {
686             if approvedAddress {
687 
688                 sstore(approvedAddressSlot, 0)
689             }
690         }
691 
692         unchecked {
693 
694             --_packedAddressData[from]; 
695             ++_packedAddressData[to]; 
696 
697             _packedOwnerships[tokenId] = _packOwnershipData(
698                 to,
699                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
700             );
701 
702             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
703                 uint256 nextTokenId = tokenId + 1;
704 
705                 if (_packedOwnerships[nextTokenId] == 0) {
706 
707                     if (nextTokenId != _currentIndex) {
708 
709                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
710                     }
711                 }
712             }
713         }
714 
715         emit Transfer(from, to, tokenId);
716         _afterTokenTransfers(from, to, tokenId, 1);
717     }
718 
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) public payable virtual override {
724         safeTransferFrom(from, to, tokenId, '');
725     }
726 
727     function safeTransferFrom(
728         address from,
729         address to,
730         uint256 tokenId,
731         bytes memory _data
732     ) public payable virtual override {
733         transferFrom(from, to, tokenId);
734         if (to.code.length != 0)
735             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
736                 revert TransferToNonERC721ReceiverImplementer();
737             }
738     }
739 
740     function _beforeTokenTransfers(
741         address from,
742         address to,
743         uint256 startTokenId,
744         uint256 quantity
745     ) internal virtual {}
746 
747     function _afterTokenTransfers(
748         address from,
749         address to,
750         uint256 startTokenId,
751         uint256 quantity
752     ) internal virtual {}
753 
754     function _checkContractOnERC721Received(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) private returns (bool) {
760         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
761             bytes4 retval
762         ) {
763             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
764         } catch (bytes memory reason) {
765             if (reason.length == 0) {
766                 revert TransferToNonERC721ReceiverImplementer();
767             } else {
768                 assembly {
769                     revert(add(32, reason), mload(reason))
770                 }
771             }
772         }
773     }
774 
775     function _mint(address to, uint256 quantity) internal virtual {
776         uint256 startTokenId = _currentIndex;
777         if (quantity == 0) revert MintZeroQuantity();
778 
779         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
780 
781         unchecked {
782 
783             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
784 
785             _packedOwnerships[startTokenId] = _packOwnershipData(
786                 to,
787                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
788             );
789 
790             uint256 toMasked;
791             uint256 end = startTokenId + quantity;
792 
793             assembly {
794 
795                 toMasked := and(to, _BITMASK_ADDRESS)
796 
797                 log4(
798                     0, 
799                     0, 
800                     _TRANSFER_EVENT_SIGNATURE, 
801                     0, 
802                     toMasked, 
803                     startTokenId 
804                 )
805 
806                 for {
807                     let tokenId := add(startTokenId, 1)
808                 } iszero(eq(tokenId, end)) {
809                     tokenId := add(tokenId, 1)
810                 } {
811 
812                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
813                 }
814             }
815             if (toMasked == 0) revert MintToZeroAddress();
816 
817             _currentIndex = end;
818         }
819         _afterTokenTransfers(address(0), to, startTokenId, quantity);
820     }
821 
822     function _mintERC2309(address to, uint256 quantity) internal virtual {
823         uint256 startTokenId = _currentIndex;
824         if (to == address(0)) revert MintToZeroAddress();
825         if (quantity == 0) revert MintZeroQuantity();
826         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
827 
828         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
829 
830         unchecked {
831 
832             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
833 
834             _packedOwnerships[startTokenId] = _packOwnershipData(
835                 to,
836                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
837             );
838 
839             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
840 
841             _currentIndex = startTokenId + quantity;
842         }
843         _afterTokenTransfers(address(0), to, startTokenId, quantity);
844     }
845 
846     function _safeMint(
847         address to,
848         uint256 quantity,
849         bytes memory _data
850     ) internal virtual {
851         _mint(to, quantity);
852 
853         unchecked {
854             if (to.code.length != 0) {
855                 uint256 end = _currentIndex;
856                 uint256 index = end - quantity;
857                 do {
858                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
859                         revert TransferToNonERC721ReceiverImplementer();
860                     }
861                 } while (index < end);
862                 // Reentrancy protection.
863                 if (_currentIndex != end) revert();
864             }
865         }
866     }
867 
868     function _safeMint(address to, uint256 quantity) internal virtual {
869         _safeMint(to, quantity, '');
870     }
871 
872     function _burn(uint256 tokenId) internal virtual {
873         _burn(tokenId, false);
874     }
875 
876     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
877         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
878 
879         address from = address(uint160(prevOwnershipPacked));
880 
881         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
882 
883         if (approvalCheck) {
884             
885             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
886                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
887         }
888 
889         _beforeTokenTransfers(from, address(0), tokenId, 1);
890 
891         assembly {
892             if approvedAddress {
893                 
894                 sstore(approvedAddressSlot, 0)
895             }
896         }
897 
898         unchecked {
899 
900             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
901 
902             _packedOwnerships[tokenId] = _packOwnershipData(
903                 from,
904                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
905             );
906 
907             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
908                 uint256 nextTokenId = tokenId + 1;
909 
910                 if (_packedOwnerships[nextTokenId] == 0) {
911 
912                     if (nextTokenId != _currentIndex) {
913 
914                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
915                     }
916                 }
917             }
918         }
919 
920         emit Transfer(from, address(0), tokenId);
921         _afterTokenTransfers(from, address(0), tokenId, 1);
922 
923         unchecked {
924             _burnCounter++;
925         }
926     }
927 
928     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
929         uint256 packed = _packedOwnerships[index];
930         if (packed == 0) revert OwnershipNotInitializedForExtraData();
931         uint256 extraDataCasted;
932         assembly {
933             extraDataCasted := extraData
934         }
935         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
936         _packedOwnerships[index] = packed;
937     }
938 
939     function _extraData(
940         address from,
941         address to,
942         uint24 previousExtraData
943     ) internal view virtual returns (uint24) {}
944 
945     function _nextExtraData(
946         address from,
947         address to,
948         uint256 prevOwnershipPacked
949     ) private view returns (uint256) {
950         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
951         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
952     }
953 
954     function _msgSenderERC721A() internal view virtual returns (address) {
955         return msg.sender;
956     }
957 
958     function _toString(uint256 value) internal pure virtual returns (string memory str) {
959         assembly {
960 
961             let m := add(mload(0x40), 0xa0)
962 
963             mstore(0x40, m)
964 
965             str := sub(m, 0x20)
966 
967             mstore(str, 0)
968 
969             let end := str
970 
971             for { let temp := value } 1 {} {
972                 str := sub(str, 1)
973 
974                 mstore8(str, add(48, mod(temp, 10)))
975 
976                 temp := div(temp, 10)
977 
978                 if iszero(temp) { break }
979             }
980 
981             let length := sub(end, str)
982 
983             str := sub(str, 0x20)
984 
985             mstore(str, length)
986         }
987     }
988 }
989 
990 pragma solidity ^0.8.13;
991 
992 contract OperatorFilterer {
993     error OperatorNotAllowed(address operator);
994 
995     IOperatorFilterRegistry constant operatorFilterRegistry =
996         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
997 
998     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
999 
1000         if (address(operatorFilterRegistry).code.length > 0) {
1001             if (subscribe) {
1002                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1003             } else {
1004                 if (subscriptionOrRegistrantToCopy != address(0)) {
1005                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1006                 } else {
1007                     operatorFilterRegistry.register(address(this));
1008                 }
1009             }
1010         }
1011     }
1012 
1013     modifier onlyAllowedOperator() virtual {
1014 
1015         if (address(operatorFilterRegistry).code.length > 0) {
1016             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1017                 revert OperatorNotAllowed(msg.sender);
1018             }
1019         }
1020         _;
1021     }
1022 }
1023 
1024 pragma solidity ^0.8.13;
1025 
1026 contract DefaultOperatorFilterer is OperatorFilterer {
1027     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1028 
1029     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1030 }
1031 
1032 pragma solidity ^0.8.13;
1033 
1034 interface IOperatorFilterRegistry {
1035     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1036     function register(address registrant) external;
1037     function registerAndSubscribe(address registrant, address subscription) external;
1038     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1039     function updateOperator(address registrant, address operator, bool filtered) external;
1040     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1041     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1042     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1043     function subscribe(address registrant, address registrantToSubscribe) external;
1044     function unsubscribe(address registrant, bool copyExistingEntries) external;
1045     function subscriptionOf(address addr) external returns (address registrant);
1046     function subscribers(address registrant) external returns (address[] memory);
1047     function subscriberAt(address registrant, uint256 index) external returns (address);
1048     function copyEntriesOf(address registrant, address registrantToCopy) external;
1049     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1050     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1051     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1052     function filteredOperators(address addr) external returns (address[] memory);
1053     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1054     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1055     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1056     function isRegistered(address addr) external returns (bool);
1057     function codeHashOf(address addr) external returns (bytes32);
1058 }
1059 
1060 pragma solidity ^0.8.4;
1061 
1062 interface IERC721ABurnable is IERC721A {
1063 
1064     function burn(uint256 tokenId) external;
1065 }
1066 
1067 pragma solidity ^0.8.4;
1068 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1069     function burn(uint256 tokenId) public virtual override {
1070         _burn(tokenId, true);
1071     }
1072 }
1073 
1074 
1075 pragma solidity ^0.8.16;
1076 contract PopAnimals is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1077 string public CONTRACT_URI = "";
1078 mapping(address => uint) public userHasMinted;
1079 bool public REVEALED;
1080 string public UNREVEALED_URI = "";
1081 string public BASE_URI = "";
1082 bool public isPublicMintEnabled = false;
1083 uint public COLLECTION_SIZE = 1024; 
1084 uint public MINT_PRICE = 0.002 ether; 
1085 uint public MAX_BATCH_SIZE = 25;
1086 uint public SUPPLY_PER_WALLET = 25;
1087 uint public FREE_SUPPLY_PER_WALLET = 1;
1088 constructor() ERC721A("PopAnimals", "PopAnimals") {}
1089 
1090 
1091     function MintByAI(uint256 quantity, address receiver) public onlyOwner {
1092         require(
1093             totalSupply() + quantity <= COLLECTION_SIZE,
1094             "No more Animals in stock!"
1095         );
1096         
1097         _safeMint(receiver, quantity);
1098     }
1099 
1100     modifier callerIsUser() {
1101         require(tx.origin == msg.sender, "The caller is another contract");
1102         _;
1103     }
1104 
1105     function getPrice(uint quantity) public view returns(uint){
1106         uint price;
1107         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1108         if (quantity >= free) {
1109             price = (MINT_PRICE) * (quantity - free);
1110         } else {
1111             price = 0;
1112         }
1113         return price;
1114     }
1115 
1116     function mint(uint quantity)
1117         external
1118         payable
1119         callerIsUser 
1120         nonReentrant
1121     {
1122         uint price;
1123         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1124         if (quantity >= free) {
1125             price = (MINT_PRICE) * (quantity - free);
1126             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1127         } else {
1128             price = 0;
1129             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1130         }
1131 
1132         require(isPublicMintEnabled, "Mint not ready yet!");
1133         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more left!");
1134 
1135         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to mint over over limit");
1136 
1137         require(quantity <= MAX_BATCH_SIZE, "Tried to mint over limit, retry with reduced quantity");
1138         require(msg.value >= price, "Must send more money!");
1139 
1140         _safeMint(msg.sender, quantity);
1141 
1142         if (msg.value > price) {
1143             payable(msg.sender).transfer(msg.value - price);
1144         }
1145     }
1146     function setPublicMintEnabled() public onlyOwner {
1147         isPublicMintEnabled = !isPublicMintEnabled;
1148     }
1149 
1150     function withdrawFunds() external onlyOwner nonReentrant {
1151         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1152         require(success, "Transfer failed.");
1153     }
1154 
1155     function CollectionUrI(bool _revealed, string memory _baseURI) public onlyOwner {
1156         BASE_URI = _baseURI;
1157         REVEALED = _revealed;
1158     }
1159 
1160     function contractURI() public view returns (string memory) {
1161         return CONTRACT_URI;
1162     }
1163 
1164     function setContract(string memory _contractURI) public onlyOwner {
1165         CONTRACT_URI = _contractURI;
1166     }
1167 
1168     function ChangeCollectionSupply(uint256 _new) external onlyOwner {
1169         COLLECTION_SIZE = _new;
1170     }
1171 
1172     function ChangePrice(uint256 _newPrice) external onlyOwner {
1173         MINT_PRICE = _newPrice;
1174     }
1175 
1176     function ChangeFreePerWallet(uint256 _new) external onlyOwner {
1177         FREE_SUPPLY_PER_WALLET = _new;
1178     }
1179 
1180     function ChangeSupplyPerWallet(uint256 _new) external onlyOwner {
1181         SUPPLY_PER_WALLET = _new;
1182     }
1183 
1184     function SetMaxBatchSize(uint256 _new) external onlyOwner {
1185         MAX_BATCH_SIZE = _new;
1186     }
1187 
1188     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1189         super.transferFrom(from, to, tokenId);
1190     }
1191 
1192     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1193         super.safeTransferFrom(from, to, tokenId);
1194     }
1195 
1196     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1197         public payable
1198         override (ERC721A, IERC721A)
1199         onlyAllowedOperator
1200     {
1201         super.safeTransferFrom(from, to, tokenId, data);
1202     }
1203 
1204     function tokenURI(uint256 _tokenId)
1205         public
1206         view
1207         override (ERC721A, IERC721A)
1208         returns (string memory)
1209     {
1210         if (REVEALED) {
1211             return
1212                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1213         } else {
1214             return UNREVEALED_URI;
1215         }
1216     }
1217 
1218 }