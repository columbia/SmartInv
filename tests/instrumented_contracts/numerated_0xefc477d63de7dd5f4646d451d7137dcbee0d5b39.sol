1 // SPDX-License-Identifier: MIT
2     
3 pragma solidity ^0.8.0;
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9 function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 pragma solidity ^0.8.0;
15 
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
69         // On the first call to nonReentrant, _notEntered will be true
70         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
71 
72         // Any calls to nonReentrant after this point will fail
73         _status = _ENTERED;
74 
75         _;
76 
77         _status = _NOT_ENTERED;
78     }
79 }
80 
81 pragma solidity ^0.8.0;
82 
83 library Strings {
84     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
85     uint8 private constant _ADDRESS_LENGTH = 20;
86 
87     function toString(uint256 value) internal pure returns (string memory) {
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     function toHexString(uint256 value) internal pure returns (string memory) {
108         if (value == 0) {
109             return "0x00";
110         }
111         uint256 temp = value;
112         uint256 length = 0;
113         while (temp != 0) {
114             length++;
115             temp >>= 8;
116         }
117         return toHexString(value, length);
118     }
119 
120     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
121         bytes memory buffer = new bytes(2 * length + 2);
122         buffer[0] = "0";
123         buffer[1] = "x";
124         for (uint256 i = 2 * length + 1; i > 1; --i) {
125             buffer[i] = _HEX_SYMBOLS[value & 0xf];
126             value >>= 4;
127         }
128         require(value == 0, "Strings: hex length insufficient");
129         return string(buffer);
130     }
131 
132     function toHexString(address addr) internal pure returns (string memory) {
133         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
134     }
135 }
136 
137 pragma solidity ^0.8.0;
138 
139 
140 library EnumerableSet {
141 
142 
143     struct Set {
144         // Storage of set values
145         bytes32[] _values;
146 
147         mapping(bytes32 => uint256) _indexes;
148     }
149 
150     function _add(Set storage set, bytes32 value) private returns (bool) {
151         if (!_contains(set, value)) {
152             set._values.push(value);
153 
154             set._indexes[value] = set._values.length;
155             return true;
156         } else {
157             return false;
158         }
159     }
160 
161     function _remove(Set storage set, bytes32 value) private returns (bool) {
162 
163         uint256 valueIndex = set._indexes[value];
164 
165         if (valueIndex != 0) {
166 
167             uint256 toDeleteIndex = valueIndex - 1;
168             uint256 lastIndex = set._values.length - 1;
169 
170             if (lastIndex != toDeleteIndex) {
171                 bytes32 lastValue = set._values[lastIndex];
172 
173                 set._values[toDeleteIndex] = lastValue;
174                 
175                 set._indexes[lastValue] = valueIndex; 
176             }
177 
178             // Delete the slot where the moved value was stored
179             set._values.pop();
180 
181             // Delete the index for the deleted slot
182             delete set._indexes[value];
183 
184             return true;
185         } else {
186             return false;
187         }
188     }
189 
190     function _contains(Set storage set, bytes32 value) private view returns (bool) {
191         return set._indexes[value] != 0;
192     }
193 
194     function _length(Set storage set) private view returns (uint256) {
195         return set._values.length;
196     }
197 
198     function _at(Set storage set, uint256 index) private view returns (bytes32) {
199         return set._values[index];
200     }
201 
202     function _values(Set storage set) private view returns (bytes32[] memory) {
203         return set._values;
204     }
205 
206     struct Bytes32Set {
207         Set _inner;
208     }
209 
210     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
211         return _add(set._inner, value);
212     }
213 
214     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
215         return _remove(set._inner, value);
216     }
217 
218     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
219         return _contains(set._inner, value);
220     }
221 
222     function length(Bytes32Set storage set) internal view returns (uint256) {
223         return _length(set._inner);
224     }
225 
226     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
227         return _at(set._inner, index);
228     }
229 
230     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
231         return _values(set._inner);
232     }
233 
234     struct AddressSet {
235         Set _inner;
236     }
237 
238     function add(AddressSet storage set, address value) internal returns (bool) {
239         return _add(set._inner, bytes32(uint256(uint160(value))));
240     }
241 
242     function remove(AddressSet storage set, address value) internal returns (bool) {
243         return _remove(set._inner, bytes32(uint256(uint160(value))));
244     }
245 
246     function contains(AddressSet storage set, address value) internal view returns (bool) {
247         return _contains(set._inner, bytes32(uint256(uint160(value))));
248     }
249 
250     function length(AddressSet storage set) internal view returns (uint256) {
251         return _length(set._inner);
252     }
253 
254     function at(AddressSet storage set, uint256 index) internal view returns (address) {
255         return address(uint160(uint256(_at(set._inner, index))));
256     }
257 
258     function values(AddressSet storage set) internal view returns (address[] memory) {
259         bytes32[] memory store = _values(set._inner);
260         address[] memory result;
261 
262         assembly {
263             result := store
264         }
265 
266         return result;
267     }
268 
269     struct UintSet {
270         Set _inner;
271     }
272 
273     function add(UintSet storage set, uint256 value) internal returns (bool) {
274         return _add(set._inner, bytes32(value));
275     }
276 
277     function remove(UintSet storage set, uint256 value) internal returns (bool) {
278         return _remove(set._inner, bytes32(value));
279     }
280 
281     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
282         return _contains(set._inner, bytes32(value));
283     }
284 
285     function length(UintSet storage set) internal view returns (uint256) {
286         return _length(set._inner);
287     }
288 
289     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
290         return uint256(_at(set._inner, index));
291     }
292 
293     function values(UintSet storage set) internal view returns (uint256[] memory) {
294         bytes32[] memory store = _values(set._inner);
295         uint256[] memory result;
296 
297         /// @solidity memory-safe-assembly
298         assembly {
299             result := store
300         }
301 
302         return result;
303     }
304 }
305 
306 pragma solidity ^0.8.4;
307 
308 interface IERC721A {
309 
310     error ApprovalCallerNotOwnerNorApproved();
311 
312     error ApprovalQueryForNonexistentToken();
313 
314     error BalanceQueryForZeroAddress();
315 
316     error MintToZeroAddress();
317 
318     error MintZeroQuantity();
319 
320     error OwnerQueryForNonexistentToken();
321 
322     error TransferCallerNotOwnerNorApproved();
323 
324     error TransferFromIncorrectOwner();
325 
326     error TransferToNonERC721ReceiverImplementer();
327 
328     error TransferToZeroAddress();
329 
330     error URIQueryForNonexistentToken();
331 
332     error MintERC2309QuantityExceedsLimit();
333 
334     error OwnershipNotInitializedForExtraData();
335 
336     struct TokenOwnership {
337 
338         address addr;
339 
340         uint64 startTimestamp;
341 
342         bool burned;
343 
344         uint24 extraData;
345     }
346 
347     function totalSupply() external view returns (uint256);
348 
349     function supportsInterface(bytes4 interfaceId) external view returns (bool);
350 
351     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
352 
353     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
354 
355     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
356 
357     function balanceOf(address owner) external view returns (uint256 balance);
358 
359     function ownerOf(uint256 tokenId) external view returns (address owner);
360 
361     function safeTransferFrom(
362         address from,
363         address to,
364         uint256 tokenId,
365         bytes calldata data
366     ) external payable;
367 
368     function safeTransferFrom(
369         address from,
370         address to,
371         uint256 tokenId
372     ) external payable;
373 
374     function transferFrom(
375         address from,
376         address to,
377         uint256 tokenId
378     ) external payable;
379 
380     function approve(address to, uint256 tokenId) external payable;
381 
382     function setApprovalForAll(address operator, bool _approved) external;
383 
384     function getApproved(uint256 tokenId) external view returns (address operator);
385 
386     function isApprovedForAll(address owner, address operator) external view returns (bool);
387 
388     function name() external view returns (string memory);
389 
390     function symbol() external view returns (string memory);
391 
392     function tokenURI(uint256 tokenId) external view returns (string memory);
393 
394     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
395 }
396 
397 pragma solidity ^0.8.4;
398 
399 interface ERC721A__IERC721Receiver {
400     function onERC721Received(
401         address operator,
402         address from,
403         uint256 tokenId,
404         bytes calldata data
405     ) external returns (bytes4);
406 }
407 
408 contract ERC721A is IERC721A {
409 
410     struct TokenApprovalRef {
411         address value;
412     }
413 
414     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
415 
416     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
417 
418     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
419 
420     uint256 private constant _BITPOS_AUX = 192;
421 
422     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
423 
424     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
425 
426     uint256 private constant _BITMASK_BURNED = 1 << 224;
427 
428     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
429 
430     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
431 
432     uint256 private constant _BITPOS_EXTRA_DATA = 232;
433 
434     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
435 
436     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
437 
438     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
439 
440     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
441         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
442 
443     uint256 private _currentIndex;
444 
445     uint256 private _burnCounter;
446 
447     string private _name;
448 
449     string private _symbol;
450 
451     mapping(uint256 => uint256) private _packedOwnerships;
452 
453     mapping(address => uint256) private _packedAddressData;
454 
455     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
456 
457     mapping(address => mapping(address => bool)) private _operatorApprovals;
458 
459     constructor(string memory name_, string memory symbol_) {
460         _name = name_;
461         _symbol = symbol_;
462         _currentIndex = _startTokenId();
463     }
464 
465     function _startTokenId() internal view virtual returns (uint256) {
466         return 0;
467     }
468 
469     function _nextTokenId() internal view virtual returns (uint256) {
470         return _currentIndex;
471     }
472 
473     function totalSupply() public view virtual override returns (uint256) {
474 
475         unchecked {
476             return _currentIndex - _burnCounter - _startTokenId();
477         }
478     }
479 
480     function _totalMinted() internal view virtual returns (uint256) {
481 
482         unchecked {
483             return _currentIndex - _startTokenId();
484         }
485     }
486 
487     function _totalBurned() internal view virtual returns (uint256) {
488         return _burnCounter;
489     }
490 
491     function balanceOf(address owner) public view virtual override returns (uint256) {
492         if (owner == address(0)) revert BalanceQueryForZeroAddress();
493         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
494     }
495 
496     function _numberMinted(address owner) internal view returns (uint256) {
497         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
498     }
499 
500     function _numberBurned(address owner) internal view returns (uint256) {
501         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
502     }
503 
504     function _getAux(address owner) internal view returns (uint64) {
505         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
506     }
507 
508     function _setAux(address owner, uint64 aux) internal virtual {
509         uint256 packed = _packedAddressData[owner];
510         uint256 auxCasted;
511         // Cast `aux` with assembly to avoid redundant masking.
512         assembly {
513             auxCasted := aux
514         }
515         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
516         _packedAddressData[owner] = packed;
517     }
518 
519 
520     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
521 
522         return
523             interfaceId == 0x01ffc9a7 || 
524             interfaceId == 0x80ac58cd || 
525             interfaceId == 0x5b5e139f; 
526     }
527 
528     function name() public view virtual override returns (string memory) {
529         return _name;
530     }
531 
532     function symbol() public view virtual override returns (string memory) {
533         return _symbol;
534     }
535 
536     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
537         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
538 
539         string memory baseURI = _baseURI();
540         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
541     }
542 
543     function _baseURI() internal view virtual returns (string memory) {
544         return '';
545     }
546 
547     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
548         return address(uint160(_packedOwnershipOf(tokenId)));
549     }
550 
551     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
552         return _unpackedOwnership(_packedOwnershipOf(tokenId));
553     }
554 
555     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
556         return _unpackedOwnership(_packedOwnerships[index]);
557     }
558 
559     function _initializeOwnershipAt(uint256 index) internal virtual {
560         if (_packedOwnerships[index] == 0) {
561             _packedOwnerships[index] = _packedOwnershipOf(index);
562         }
563     }
564 
565     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
566         uint256 curr = tokenId;
567 
568         unchecked {
569             if (_startTokenId() <= curr)
570                 if (curr < _currentIndex) {
571                     uint256 packed = _packedOwnerships[curr];
572 
573                     if (packed & _BITMASK_BURNED == 0) {
574 
575                         while (packed == 0) {
576                             packed = _packedOwnerships[--curr];
577                         }
578                         return packed;
579                     }
580                 }
581         }
582         revert OwnerQueryForNonexistentToken();
583     }
584 
585     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
586         ownership.addr = address(uint160(packed));
587         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
588         ownership.burned = packed & _BITMASK_BURNED != 0;
589         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
590     }
591 
592     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
593         assembly {
594             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
595             owner := and(owner, _BITMASK_ADDRESS)
596             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
597             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
598         }
599     }
600 
601     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
602         // For branchless setting of the `nextInitialized` flag.
603         assembly {
604             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
605             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
606         }
607     }
608 
609     function approve(address to, uint256 tokenId) public payable virtual override {
610         address owner = ownerOf(tokenId);
611 
612         if (_msgSenderERC721A() != owner)
613             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
614                 revert ApprovalCallerNotOwnerNorApproved();
615             }
616 
617         _tokenApprovals[tokenId].value = to;
618         emit Approval(owner, to, tokenId);
619     }
620 
621     function getApproved(uint256 tokenId) public view virtual override returns (address) {
622         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
623 
624         return _tokenApprovals[tokenId].value;
625     }
626 
627     function setApprovalForAll(address operator, bool approved) public virtual override {
628         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
629         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
630     }
631 
632     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
633         return _operatorApprovals[owner][operator];
634     }
635 
636     function _exists(uint256 tokenId) internal view virtual returns (bool) {
637         return
638             _startTokenId() <= tokenId &&
639             tokenId < _currentIndex && // If within bounds,
640             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
641     }
642 
643     function _isSenderApprovedOrOwner(
644         address approvedAddress,
645         address owner,
646         address msgSender
647     ) private pure returns (bool result) {
648         assembly {
649 
650             owner := and(owner, _BITMASK_ADDRESS)
651 
652             msgSender := and(msgSender, _BITMASK_ADDRESS)
653 
654             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
655         }
656     }
657 
658     function _getApprovedSlotAndAddress(uint256 tokenId)
659         private
660         view
661         returns (uint256 approvedAddressSlot, address approvedAddress)
662     {
663         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
664 
665         assembly {
666             approvedAddressSlot := tokenApproval.slot
667             approvedAddress := sload(approvedAddressSlot)
668         }
669     }
670 
671     function transferFrom(
672         address from,
673         address to,
674         uint256 tokenId
675     ) public payable virtual override {
676         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
677 
678         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
679 
680         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
681 
682         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
683             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
684 
685         if (to == address(0)) revert TransferToZeroAddress();
686 
687         _beforeTokenTransfers(from, to, tokenId, 1);
688 
689         assembly {
690             if approvedAddress {
691 
692                 sstore(approvedAddressSlot, 0)
693             }
694         }
695 
696         unchecked {
697 
698             --_packedAddressData[from]; 
699             ++_packedAddressData[to]; 
700 
701             _packedOwnerships[tokenId] = _packOwnershipData(
702                 to,
703                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
704             );
705 
706             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
707                 uint256 nextTokenId = tokenId + 1;
708 
709                 if (_packedOwnerships[nextTokenId] == 0) {
710 
711                     if (nextTokenId != _currentIndex) {
712 
713                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
714                     }
715                 }
716             }
717         }
718 
719         emit Transfer(from, to, tokenId);
720         _afterTokenTransfers(from, to, tokenId, 1);
721     }
722 
723     function safeTransferFrom(
724         address from,
725         address to,
726         uint256 tokenId
727     ) public payable virtual override {
728         safeTransferFrom(from, to, tokenId, '');
729     }
730 
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId,
735         bytes memory _data
736     ) public payable virtual override {
737         transferFrom(from, to, tokenId);
738         if (to.code.length != 0)
739             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
740                 revert TransferToNonERC721ReceiverImplementer();
741             }
742     }
743 
744     function _beforeTokenTransfers(
745         address from,
746         address to,
747         uint256 startTokenId,
748         uint256 quantity
749     ) internal virtual {}
750 
751     function _afterTokenTransfers(
752         address from,
753         address to,
754         uint256 startTokenId,
755         uint256 quantity
756     ) internal virtual {}
757 
758     function _checkContractOnERC721Received(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes memory _data
763     ) private returns (bool) {
764         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
765             bytes4 retval
766         ) {
767             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
768         } catch (bytes memory reason) {
769             if (reason.length == 0) {
770                 revert TransferToNonERC721ReceiverImplementer();
771             } else {
772                 assembly {
773                     revert(add(32, reason), mload(reason))
774                 }
775             }
776         }
777     }
778 
779     function _mint(address to, uint256 quantity) internal virtual {
780         uint256 startTokenId = _currentIndex;
781         if (quantity == 0) revert MintZeroQuantity();
782 
783         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
784 
785         unchecked {
786 
787             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
788 
789             _packedOwnerships[startTokenId] = _packOwnershipData(
790                 to,
791                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
792             );
793 
794             uint256 toMasked;
795             uint256 end = startTokenId + quantity;
796 
797             assembly {
798 
799                 toMasked := and(to, _BITMASK_ADDRESS)
800 
801                 log4(
802                     0, 
803                     0, 
804                     _TRANSFER_EVENT_SIGNATURE, 
805                     0, 
806                     toMasked, 
807                     startTokenId 
808                 )
809 
810                 for {
811                     let tokenId := add(startTokenId, 1)
812                 } iszero(eq(tokenId, end)) {
813                     tokenId := add(tokenId, 1)
814                 } {
815 
816                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
817                 }
818             }
819             if (toMasked == 0) revert MintToZeroAddress();
820 
821             _currentIndex = end;
822         }
823         _afterTokenTransfers(address(0), to, startTokenId, quantity);
824     }
825 
826     function _mintERC2309(address to, uint256 quantity) internal virtual {
827         uint256 startTokenId = _currentIndex;
828         if (to == address(0)) revert MintToZeroAddress();
829         if (quantity == 0) revert MintZeroQuantity();
830         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
831 
832         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
833 
834         unchecked {
835 
836             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
837 
838             _packedOwnerships[startTokenId] = _packOwnershipData(
839                 to,
840                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
841             );
842 
843             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
844 
845             _currentIndex = startTokenId + quantity;
846         }
847         _afterTokenTransfers(address(0), to, startTokenId, quantity);
848     }
849 
850     function _safeMint(
851         address to,
852         uint256 quantity,
853         bytes memory _data
854     ) internal virtual {
855         _mint(to, quantity);
856 
857         unchecked {
858             if (to.code.length != 0) {
859                 uint256 end = _currentIndex;
860                 uint256 index = end - quantity;
861                 do {
862                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
863                         revert TransferToNonERC721ReceiverImplementer();
864                     }
865                 } while (index < end);
866                 // Reentrancy protection.
867                 if (_currentIndex != end) revert();
868             }
869         }
870     }
871 
872     function _safeMint(address to, uint256 quantity) internal virtual {
873         _safeMint(to, quantity, '');
874     }
875 
876     function _burn(uint256 tokenId) internal virtual {
877         _burn(tokenId, false);
878     }
879 
880     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
881         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
882 
883         address from = address(uint160(prevOwnershipPacked));
884 
885         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
886 
887         if (approvalCheck) {
888             // The nested ifs save around 20+ gas over a compound boolean condition.
889             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
890                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
891         }
892 
893         _beforeTokenTransfers(from, address(0), tokenId, 1);
894 
895         // Clear approvals from the previous owner.
896         assembly {
897             if approvedAddress {
898                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
899                 sstore(approvedAddressSlot, 0)
900             }
901         }
902 
903         unchecked {
904 
905             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
906 
907             _packedOwnerships[tokenId] = _packOwnershipData(
908                 from,
909                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
910             );
911 
912             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
913                 uint256 nextTokenId = tokenId + 1;
914 
915                 if (_packedOwnerships[nextTokenId] == 0) {
916 
917                     if (nextTokenId != _currentIndex) {
918 
919                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
920                     }
921                 }
922             }
923         }
924 
925         emit Transfer(from, address(0), tokenId);
926         _afterTokenTransfers(from, address(0), tokenId, 1);
927 
928         unchecked {
929             _burnCounter++;
930         }
931     }
932 
933     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
934         uint256 packed = _packedOwnerships[index];
935         if (packed == 0) revert OwnershipNotInitializedForExtraData();
936         uint256 extraDataCasted;
937         assembly {
938             extraDataCasted := extraData
939         }
940         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
941         _packedOwnerships[index] = packed;
942     }
943 
944     function _extraData(
945         address from,
946         address to,
947         uint24 previousExtraData
948     ) internal view virtual returns (uint24) {}
949 
950     function _nextExtraData(
951         address from,
952         address to,
953         uint256 prevOwnershipPacked
954     ) private view returns (uint256) {
955         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
956         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
957     }
958 
959     function _msgSenderERC721A() internal view virtual returns (address) {
960         return msg.sender;
961     }
962 
963     function _toString(uint256 value) internal pure virtual returns (string memory str) {
964         assembly {
965 
966             let m := add(mload(0x40), 0xa0)
967 
968             mstore(0x40, m)
969 
970             str := sub(m, 0x20)
971 
972             mstore(str, 0)
973 
974             let end := str
975 
976             for { let temp := value } 1 {} {
977                 str := sub(str, 1)
978 
979                 mstore8(str, add(48, mod(temp, 10)))
980 
981                 temp := div(temp, 10)
982 
983                 if iszero(temp) { break }
984             }
985 
986             let length := sub(end, str)
987 
988             str := sub(str, 0x20)
989 
990             mstore(str, length)
991         }
992     }
993 }
994 
995 pragma solidity ^0.8.13;
996 
997 contract OperatorFilterer {
998     error OperatorNotAllowed(address operator);
999 
1000     IOperatorFilterRegistry constant operatorFilterRegistry =
1001         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1002 
1003     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1004 
1005         if (address(operatorFilterRegistry).code.length > 0) {
1006             if (subscribe) {
1007                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1008             } else {
1009                 if (subscriptionOrRegistrantToCopy != address(0)) {
1010                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1011                 } else {
1012                     operatorFilterRegistry.register(address(this));
1013                 }
1014             }
1015         }
1016     }
1017 
1018     modifier onlyAllowedOperator() virtual {
1019 
1020         if (address(operatorFilterRegistry).code.length > 0) {
1021             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1022                 revert OperatorNotAllowed(msg.sender);
1023             }
1024         }
1025         _;
1026     }
1027 }
1028 
1029 pragma solidity ^0.8.13;
1030 
1031 contract DefaultOperatorFilterer is OperatorFilterer {
1032     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1033 
1034     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1035 }
1036 
1037 pragma solidity ^0.8.13;
1038 
1039 interface IOperatorFilterRegistry {
1040     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1041     function register(address registrant) external;
1042     function registerAndSubscribe(address registrant, address subscription) external;
1043     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1044     function updateOperator(address registrant, address operator, bool filtered) external;
1045     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1046     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1047     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1048     function subscribe(address registrant, address registrantToSubscribe) external;
1049     function unsubscribe(address registrant, bool copyExistingEntries) external;
1050     function subscriptionOf(address addr) external returns (address registrant);
1051     function subscribers(address registrant) external returns (address[] memory);
1052     function subscriberAt(address registrant, uint256 index) external returns (address);
1053     function copyEntriesOf(address registrant, address registrantToCopy) external;
1054     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1055     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1056     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1057     function filteredOperators(address addr) external returns (address[] memory);
1058     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1059     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1060     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1061     function isRegistered(address addr) external returns (bool);
1062     function codeHashOf(address addr) external returns (bytes32);
1063 }
1064 
1065 pragma solidity ^0.8.4;
1066 
1067 interface IERC721ABurnable is IERC721A {
1068 
1069     function burn(uint256 tokenId) external;
1070 }
1071 
1072 pragma solidity ^0.8.4;
1073 
1074 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1075 
1076     function burn(uint256 tokenId) public virtual override {
1077         _burn(tokenId, true);
1078     }
1079 }
1080 
1081 pragma solidity ^0.8.16;
1082 
1083 contract MadGorilla is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1084 
1085 string public CONTRACT_URI = "https://api.madgorillaclan.com/";
1086 
1087     mapping(address => uint) public userHasMinted;
1088 
1089     bool public REVEALED;
1090 
1091     string public UNREVEALED_URI = "https://api.madgorillaclan.com/";
1092 
1093     string public BASE_URI = "https://api.madgorillaclan.com/";
1094 
1095     bool public isPublicMintEnabled = false;
1096 
1097     uint public COLLECTION_SIZE = 5555;
1098 
1099     uint public MINT_PRICE = 0.00444 ether;
1100 
1101     uint public MAX_BATCH_SIZE = 25;
1102 
1103     uint public SUPPLY_PER_WALLET = 25;
1104 
1105     uint public FREE_SUPPLY_PER_WALLET = 1;
1106 
1107     constructor() ERC721A("Mad Gorilla Clan Digital Trading Cards", "MGCDTC") {}
1108 
1109     function FreeMintWL(uint256 quantity, address receiver) public onlyOwner {
1110     require(
1111             totalSupply() + quantity <= COLLECTION_SIZE,
1112             "No more Trading Cards!"
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
1134     function mint(uint quantity)
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
1150         require(isPublicMintEnabled, "Sales has not begun yet");
1151         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more Trading Cards");
1152 
1153         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to total mint quanity per wallet over limit");
1154 
1155         require(quantity <= MAX_BATCH_SIZE, "Tried to mint quanity over limit, retry with reduced quantity");
1156         require(msg.value >= price, "Must send enough eth for public mint");
1157 
1158         _safeMint(msg.sender, quantity);
1159 
1160         if (msg.value > price) {
1161             payable(msg.sender).transfer(msg.value - price);
1162         }
1163     }
1164 
1165     function withdrawFunds() external onlyOwner nonReentrant {
1166         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1167         require(success, "Transfer failed.");
1168     }
1169 
1170     function setPublicMintEnabled() public onlyOwner {
1171         isPublicMintEnabled = !isPublicMintEnabled;
1172     }
1173 
1174     function setBaseURI(bool _revealed, string memory _baseURI) public onlyOwner {
1175         BASE_URI = _baseURI;
1176         REVEALED = _revealed;
1177     }
1178 
1179     function contractURI() public view returns (string memory) {
1180         return CONTRACT_URI;
1181     }
1182 
1183     function setContractURI(string memory _contractURI) public onlyOwner {
1184         CONTRACT_URI = _contractURI;
1185     }
1186 
1187     function set_COLLECTION_SIZE(uint256 _new) external onlyOwner {
1188         COLLECTION_SIZE = _new;
1189     }
1190 
1191     function setPrice(uint256 _newPrice) external onlyOwner {
1192         MINT_PRICE = _newPrice;
1193     }
1194 
1195     function set_FREE_SUPPLY_PER_WALLET(uint256 _new) external onlyOwner {
1196         FREE_SUPPLY_PER_WALLET = _new;
1197     }
1198 
1199     function set_SUPPLY_PER_WALLET(uint256 _new) external onlyOwner {
1200         SUPPLY_PER_WALLET = _new;
1201     }
1202 
1203     function set_MAX_BATCH_SIZE(uint256 _new) external onlyOwner {
1204         MAX_BATCH_SIZE = _new;
1205     }
1206 
1207     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1208         super.transferFrom(from, to, tokenId);
1209     }
1210 
1211     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1212         super.safeTransferFrom(from, to, tokenId);
1213     }
1214 
1215     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1216         public payable
1217         override (ERC721A, IERC721A)
1218         onlyAllowedOperator
1219     {
1220         super.safeTransferFrom(from, to, tokenId, data);
1221     }
1222 
1223     function tokenURI(uint256 _tokenId)
1224         public
1225         view
1226         override (ERC721A, IERC721A)
1227         returns (string memory)
1228     {
1229         if (REVEALED) {
1230             return
1231                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1232         } else {
1233             return UNREVEALED_URI;
1234         }
1235     }
1236 
1237 }