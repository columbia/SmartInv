1 // SPDX-License-Identifier: MIT    
2 
3 /**
4 In the beginning of all time, the Creator brought forth the chicken above all creations, 
5 gazed upon it, and deemed it good. And He blessed it to watch 
6 over all the creations that would come after it.
7 */
8 
9 pragma solidity ^0.8.0;
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 pragma solidity ^0.8.0;
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     modifier onlyOwner() {
31         _checkOwner();
32         _;
33     }
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     function _checkOwner() internal view virtual {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41     }
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _transferOwnership(address(0));
45     }
46 
47 
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(newOwner != address(0), "Ownable: new owner is the zero address");
50         _transferOwnership(newOwner);
51     }
52 
53     function _transferOwnership(address newOwner) internal virtual {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 pragma solidity ^0.8.0;
61 
62 abstract contract ReentrancyGuard {
63 
64     uint256 private constant _NOT_ENTERED = 1;
65     uint256 private constant _ENTERED = 2;
66 
67     uint256 private _status;
68 
69     constructor() {
70         _status = _NOT_ENTERED;
71     }
72 
73     modifier nonReentrant() {
74         
75         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
76 
77         _status = _ENTERED;
78 
79         _;
80 
81         _status = _NOT_ENTERED;
82     }
83 }
84 
85 pragma solidity ^0.8.0;
86 
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89     uint8 private constant _ADDRESS_LENGTH = 20;
90 
91     function toString(uint256 value) internal pure returns (string memory) {
92 
93         if (value == 0) {
94             return "0";
95         }
96         uint256 temp = value;
97         uint256 digits;
98         while (temp != 0) {
99             digits++;
100             temp /= 10;
101         }
102         bytes memory buffer = new bytes(digits);
103         while (value != 0) {
104             digits -= 1;
105             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
106             value /= 10;
107         }
108         return string(buffer);
109     }
110 
111     function toHexString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0x00";
114         }
115         uint256 temp = value;
116         uint256 length = 0;
117         while (temp != 0) {
118             length++;
119             temp >>= 8;
120         }
121         return toHexString(value, length);
122     }
123 
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 
136     function toHexString(address addr) internal pure returns (string memory) {
137         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
138     }
139 }
140 
141 pragma solidity ^0.8.0;
142 
143 
144 library EnumerableSet {
145 
146 
147     struct Set {
148         // Storage of set values
149         bytes32[] _values;
150 
151         mapping(bytes32 => uint256) _indexes;
152     }
153 
154     function _add(Set storage set, bytes32 value) private returns (bool) {
155         if (!_contains(set, value)) {
156             set._values.push(value);
157 
158             set._indexes[value] = set._values.length;
159             return true;
160         } else {
161             return false;
162         }
163     }
164 
165     function _remove(Set storage set, bytes32 value) private returns (bool) {
166 
167         uint256 valueIndex = set._indexes[value];
168 
169         if (valueIndex != 0) {
170 
171             uint256 toDeleteIndex = valueIndex - 1;
172             uint256 lastIndex = set._values.length - 1;
173 
174             if (lastIndex != toDeleteIndex) {
175                 bytes32 lastValue = set._values[lastIndex];
176 
177                 set._values[toDeleteIndex] = lastValue;
178                 
179                 set._indexes[lastValue] = valueIndex; 
180             }
181 
182             set._values.pop();
183 
184             delete set._indexes[value];
185 
186             return true;
187         } else {
188             return false;
189         }
190     }
191 
192     function _contains(Set storage set, bytes32 value) private view returns (bool) {
193         return set._indexes[value] != 0;
194     }
195 
196     function _length(Set storage set) private view returns (uint256) {
197         return set._values.length;
198     }
199 
200     function _at(Set storage set, uint256 index) private view returns (bytes32) {
201         return set._values[index];
202     }
203 
204     function _values(Set storage set) private view returns (bytes32[] memory) {
205         return set._values;
206     }
207 
208     struct Bytes32Set {
209         Set _inner;
210     }
211 
212     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
213         return _add(set._inner, value);
214     }
215 
216     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
217         return _remove(set._inner, value);
218     }
219 
220     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
221         return _contains(set._inner, value);
222     }
223 
224     function length(Bytes32Set storage set) internal view returns (uint256) {
225         return _length(set._inner);
226     }
227 
228     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
229         return _at(set._inner, index);
230     }
231 
232     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
233         return _values(set._inner);
234     }
235 
236     struct AddressSet {
237         Set _inner;
238     }
239 
240     function add(AddressSet storage set, address value) internal returns (bool) {
241         return _add(set._inner, bytes32(uint256(uint160(value))));
242     }
243 
244     function remove(AddressSet storage set, address value) internal returns (bool) {
245         return _remove(set._inner, bytes32(uint256(uint160(value))));
246     }
247 
248     function contains(AddressSet storage set, address value) internal view returns (bool) {
249         return _contains(set._inner, bytes32(uint256(uint160(value))));
250     }
251 
252     function length(AddressSet storage set) internal view returns (uint256) {
253         return _length(set._inner);
254     }
255 
256     function at(AddressSet storage set, uint256 index) internal view returns (address) {
257         return address(uint160(uint256(_at(set._inner, index))));
258     }
259 
260     function values(AddressSet storage set) internal view returns (address[] memory) {
261         bytes32[] memory store = _values(set._inner);
262         address[] memory result;
263 
264         assembly {
265             result := store
266         }
267 
268         return result;
269     }
270 
271     struct UintSet {
272         Set _inner;
273     }
274 
275     function add(UintSet storage set, uint256 value) internal returns (bool) {
276         return _add(set._inner, bytes32(value));
277     }
278 
279     function remove(UintSet storage set, uint256 value) internal returns (bool) {
280         return _remove(set._inner, bytes32(value));
281     }
282 
283     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
284         return _contains(set._inner, bytes32(value));
285     }
286 
287     function length(UintSet storage set) internal view returns (uint256) {
288         return _length(set._inner);
289     }
290 
291     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
292         return uint256(_at(set._inner, index));
293     }
294 
295     function values(UintSet storage set) internal view returns (uint256[] memory) {
296         bytes32[] memory store = _values(set._inner);
297         uint256[] memory result;
298 
299         /// @solidity memory-safe-assembly
300         assembly {
301             result := store
302         }
303 
304         return result;
305     }
306 }
307 
308 pragma solidity ^0.8.4;
309 
310 interface IERC721A {
311 
312     error ApprovalCallerNotOwnerNorApproved();
313 
314     error ApprovalQueryForNonexistentToken();
315 
316     error BalanceQueryForZeroAddress();
317 
318     error MintToZeroAddress();
319 
320     error MintZeroQuantity();
321 
322     error OwnerQueryForNonexistentToken();
323 
324     error TransferCallerNotOwnerNorApproved();
325 
326     error TransferFromIncorrectOwner();
327 
328     error TransferToNonERC721ReceiverImplementer();
329 
330     error TransferToZeroAddress();
331 
332     error URIQueryForNonexistentToken();
333 
334     error MintERC2309QuantityExceedsLimit();
335 
336     error OwnershipNotInitializedForExtraData();
337 
338     struct TokenOwnership {
339 
340         address addr;
341 
342         uint64 startTimestamp;
343 
344         bool burned;
345 
346         uint24 extraData;
347     }
348 
349     function totalSupply() external view returns (uint256);
350 
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 
353     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
354 
355     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
356 
357     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
358 
359     function balanceOf(address owner) external view returns (uint256 balance);
360 
361     function ownerOf(uint256 tokenId) external view returns (address owner);
362 
363     function safeTransferFrom(
364         address from,
365         address to,
366         uint256 tokenId,
367         bytes calldata data
368     ) external payable;
369 
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external payable;
375 
376     function transferFrom(
377         address from,
378         address to,
379         uint256 tokenId
380     ) external payable;
381 
382     function approve(address to, uint256 tokenId) external payable;
383 
384     function setApprovalForAll(address operator, bool _approved) external;
385 
386     function getApproved(uint256 tokenId) external view returns (address operator);
387 
388     function isApprovedForAll(address owner, address operator) external view returns (bool);
389 
390     function name() external view returns (string memory);
391 
392     function symbol() external view returns (string memory);
393 
394     function tokenURI(uint256 tokenId) external view returns (string memory);
395 
396     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
397 }
398 
399 pragma solidity ^0.8.4;
400 
401 interface ERC721A__IERC721Receiver {
402     function onERC721Received(
403         address operator,
404         address from,
405         uint256 tokenId,
406         bytes calldata data
407     ) external returns (bytes4);
408 }
409 
410 contract ERC721A is IERC721A {
411 
412     struct TokenApprovalRef {
413         address value;
414     }
415 
416     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
417 
418     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
419 
420     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
421 
422     uint256 private constant _BITPOS_AUX = 192;
423 
424     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
425 
426     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
427 
428     uint256 private constant _BITMASK_BURNED = 1 << 224;
429 
430     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
431 
432     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
433 
434     uint256 private constant _BITPOS_EXTRA_DATA = 232;
435 
436     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
437 
438     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
439 
440     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
441 
442     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
443         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
444 
445     uint256 private _currentIndex;
446 
447     uint256 private _burnCounter;
448 
449     string private _name;
450 
451     string private _symbol;
452 
453     mapping(uint256 => uint256) private _packedOwnerships;
454 
455     mapping(address => uint256) private _packedAddressData;
456 
457     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
458 
459     mapping(address => mapping(address => bool)) private _operatorApprovals;
460 
461     constructor(string memory name_, string memory symbol_) {
462         _name = name_;
463         _symbol = symbol_;
464         _currentIndex = _startTokenId();
465     }
466 
467     /**
468     And God decreed that the next perfect creation shall be the egg, the chicken's egg. 
469     It shall be so perfect that the whole world shall praise this creation.
470     */
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
646             tokenId < _currentIndex && 
647             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0;
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
665     /**
666     And lo, before creating the chicken, the Creator devised many jests about the chicken, 
667     for it was good, for the chicken is not like the goose; the chicken is loved every day, 
668     not just on Thanksgiving Day.
669     */
670 
671     function _getApprovedSlotAndAddress(uint256 tokenId)
672         private
673         view
674         returns (uint256 approvedAddressSlot, address approvedAddress)
675     {
676         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
677 
678         assembly {
679             approvedAddressSlot := tokenApproval.slot
680             approvedAddress := sload(approvedAddressSlot)
681         }
682     }
683 
684     function transferFrom(
685         address from,
686         address to,
687         uint256 tokenId
688     ) public payable virtual override {
689         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
690 
691         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
692 
693         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
694 
695         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
696             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
697 
698         if (to == address(0)) revert TransferToZeroAddress();
699 
700         _beforeTokenTransfers(from, to, tokenId, 1);
701 
702         assembly {
703             if approvedAddress {
704 
705                 sstore(approvedAddressSlot, 0)
706             }
707         }
708 
709         unchecked {
710 
711             --_packedAddressData[from]; 
712             ++_packedAddressData[to]; 
713 
714             _packedOwnerships[tokenId] = _packOwnershipData(
715                 to,
716                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
717             );
718 
719             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
720                 uint256 nextTokenId = tokenId + 1;
721 
722                 if (_packedOwnerships[nextTokenId] == 0) {
723 
724                     if (nextTokenId != _currentIndex) {
725 
726                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
727                     }
728                 }
729             }
730         }
731 
732         emit Transfer(from, to, tokenId);
733         _afterTokenTransfers(from, to, tokenId, 1);
734     }
735 
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public payable virtual override {
741         safeTransferFrom(from, to, tokenId, '');
742     }
743 
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId,
748         bytes memory _data
749     ) public payable virtual override {
750         transferFrom(from, to, tokenId);
751         if (to.code.length != 0)
752             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
753                 revert TransferToNonERC721ReceiverImplementer();
754             }
755     }
756 
757     function _beforeTokenTransfers(
758         address from,
759         address to,
760         uint256 startTokenId,
761         uint256 quantity
762     ) internal virtual {}
763 
764     function _afterTokenTransfers(
765         address from,
766         address to,
767         uint256 startTokenId,
768         uint256 quantity
769     ) internal virtual {}
770 
771     function _checkContractOnERC721Received(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes memory _data
776     ) private returns (bool) {
777         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
778             bytes4 retval
779         ) {
780             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
781         } catch (bytes memory reason) {
782             if (reason.length == 0) {
783                 revert TransferToNonERC721ReceiverImplementer();
784             } else {
785                 assembly {
786                     revert(add(32, reason), mload(reason))
787                 }
788             }
789         }
790     }
791 
792     function _mint(address to, uint256 quantity) internal virtual {
793         uint256 startTokenId = _currentIndex;
794         if (quantity == 0) revert MintZeroQuantity();
795 
796         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
797 
798         unchecked {
799 
800             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
801 
802             _packedOwnerships[startTokenId] = _packOwnershipData(
803                 to,
804                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
805             );
806 
807             uint256 toMasked;
808             uint256 end = startTokenId + quantity;
809 
810             assembly {
811 
812                 toMasked := and(to, _BITMASK_ADDRESS)
813 
814                 log4(
815                     0, 
816                     0, 
817                     _TRANSFER_EVENT_SIGNATURE, 
818                     0, 
819                     toMasked, 
820                     startTokenId 
821                 )
822 
823                 for {
824                     let tokenId := add(startTokenId, 1)
825                 } iszero(eq(tokenId, end)) {
826                     tokenId := add(tokenId, 1)
827                 } {
828 
829                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
830                 }
831             }
832             if (toMasked == 0) revert MintToZeroAddress();
833 
834             _currentIndex = end;
835         }
836         _afterTokenTransfers(address(0), to, startTokenId, quantity);
837     }
838 
839     function _mintERC2309(address to, uint256 quantity) internal virtual {
840         uint256 startTokenId = _currentIndex;
841         if (to == address(0)) revert MintToZeroAddress();
842         if (quantity == 0) revert MintZeroQuantity();
843         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
844 
845         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
846 
847         unchecked {
848 
849             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
850 
851             _packedOwnerships[startTokenId] = _packOwnershipData(
852                 to,
853                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
854             );
855 
856             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
857 
858             _currentIndex = startTokenId + quantity;
859         }
860         _afterTokenTransfers(address(0), to, startTokenId, quantity);
861     }
862 
863     function _safeMint(
864         address to,
865         uint256 quantity,
866         bytes memory _data
867     ) internal virtual {
868         _mint(to, quantity);
869 
870         unchecked {
871             if (to.code.length != 0) {
872                 uint256 end = _currentIndex;
873                 uint256 index = end - quantity;
874                 do {
875                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
876                         revert TransferToNonERC721ReceiverImplementer();
877                     }
878                 } while (index < end);
879                 // Reentrancy protection.
880                 if (_currentIndex != end) revert();
881             }
882         }
883     }
884 
885     function _safeMint(address to, uint256 quantity) internal virtual {
886         _safeMint(to, quantity, '');
887     }
888 
889     function _burn(uint256 tokenId) internal virtual {
890         _burn(tokenId, false);
891     }
892 
893     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
894         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
895 
896         address from = address(uint160(prevOwnershipPacked));
897 
898         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
899 
900         if (approvalCheck) {
901             
902             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
903                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
904         }
905 
906         _beforeTokenTransfers(from, address(0), tokenId, 1);
907 
908         assembly {
909             if approvedAddress {
910                 
911                 sstore(approvedAddressSlot, 0)
912             }
913         }
914 
915         unchecked {
916 
917             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
918 
919             _packedOwnerships[tokenId] = _packOwnershipData(
920                 from,
921                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
922             );
923 
924             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
925                 uint256 nextTokenId = tokenId + 1;
926 
927                 if (_packedOwnerships[nextTokenId] == 0) {
928 
929                     if (nextTokenId != _currentIndex) {
930 
931                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
932                     }
933                 }
934             }
935         }
936 
937         emit Transfer(from, address(0), tokenId);
938         _afterTokenTransfers(from, address(0), tokenId, 1);
939 
940         unchecked {
941             _burnCounter++;
942         }
943     }
944 
945     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
946         uint256 packed = _packedOwnerships[index];
947         if (packed == 0) revert OwnershipNotInitializedForExtraData();
948         uint256 extraDataCasted;
949         assembly {
950             extraDataCasted := extraData
951         }
952         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
953         _packedOwnerships[index] = packed;
954     }
955 
956     function _extraData(
957         address from,
958         address to,
959         uint24 previousExtraData
960     ) internal view virtual returns (uint24) {}
961 
962     function _nextExtraData(
963         address from,
964         address to,
965         uint256 prevOwnershipPacked
966     ) private view returns (uint256) {
967         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
968         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
969     }
970 
971     function _msgSenderERC721A() internal view virtual returns (address) {
972         return msg.sender;
973     }
974 
975     function _toString(uint256 value) internal pure virtual returns (string memory str) {
976         assembly {
977 
978             let m := add(mload(0x40), 0xa0)
979 
980             mstore(0x40, m)
981 
982             str := sub(m, 0x20)
983 
984             mstore(str, 0)
985 
986             let end := str
987 
988             for { let temp := value } 1 {} {
989                 str := sub(str, 1)
990 
991                 mstore8(str, add(48, mod(temp, 10)))
992 
993                 temp := div(temp, 10)
994 
995                 if iszero(temp) { break }
996             }
997 
998             let length := sub(end, str)
999 
1000             str := sub(str, 0x20)
1001 
1002             mstore(str, length)
1003         }
1004     }
1005 }
1006 
1007 pragma solidity ^0.8.13;
1008 
1009 contract OperatorFilterer {
1010     error OperatorNotAllowed(address operator);
1011 
1012     IOperatorFilterRegistry constant operatorFilterRegistry =
1013         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1014 
1015     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1016 
1017         if (address(operatorFilterRegistry).code.length > 0) {
1018             if (subscribe) {
1019                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1020             } else {
1021                 if (subscriptionOrRegistrantToCopy != address(0)) {
1022                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1023                 } else {
1024                     operatorFilterRegistry.register(address(this));
1025                 }
1026             }
1027         }
1028     }
1029 
1030     modifier onlyAllowedOperator() virtual {
1031 
1032         if (address(operatorFilterRegistry).code.length > 0) {
1033             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1034                 revert OperatorNotAllowed(msg.sender);
1035             }
1036         }
1037         _;
1038     }
1039 }
1040 
1041 pragma solidity ^0.8.13;
1042 
1043 contract DefaultOperatorFilterer is OperatorFilterer {
1044     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1045 
1046     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1047 }
1048 
1049 pragma solidity ^0.8.13;
1050 
1051 interface IOperatorFilterRegistry {
1052     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1053     function register(address registrant) external;
1054     function registerAndSubscribe(address registrant, address subscription) external;
1055     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1056     function updateOperator(address registrant, address operator, bool filtered) external;
1057     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1058     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1059     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1060     function subscribe(address registrant, address registrantToSubscribe) external;
1061     function unsubscribe(address registrant, bool copyExistingEntries) external;
1062     function subscriptionOf(address addr) external returns (address registrant);
1063     function subscribers(address registrant) external returns (address[] memory);
1064     function subscriberAt(address registrant, uint256 index) external returns (address);
1065     function copyEntriesOf(address registrant, address registrantToCopy) external;
1066     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1067     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1068     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1069     function filteredOperators(address addr) external returns (address[] memory);
1070     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1071     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1072     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1073     function isRegistered(address addr) external returns (bool);
1074     function codeHashOf(address addr) external returns (bytes32);
1075 }
1076 
1077 pragma solidity ^0.8.4;
1078 
1079 interface IERC721ABurnable is IERC721A {
1080 
1081     function burn(uint256 tokenId) external;
1082 }
1083 
1084 pragma solidity ^0.8.4;
1085 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1086     function burn(uint256 tokenId) public virtual override {
1087         _burn(tokenId, true);
1088     }
1089 }
1090 
1091 /**
1092 And the hens journeyed to the ends of the Universe to watch over all the creations of the Creator, 
1093 and they were just and wise. They offered recommendations to the Creator and provided helpful advice, 
1094 for though He was Almighty, He desired to rest after seven days of creation, converse with Mary Jane, 
1095 and socialize with the Other Creators of the Universes to boast of His achievements. 
1096 For the grand prize would go to the creator with the perfect Universe and perfect Creations... 
1097 Oops... We may have ventured ahead, revealing the secret competition among the Gods.
1098 */
1099 
1100 pragma solidity ^0.8.16;
1101 contract ChickGenerator is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1102 
1103 string public CONTRACT_URI = "";
1104 mapping(address => uint) public userHasMinted;
1105 bool public REVEALED;
1106 
1107 string public UNREVEALED_URI = "";
1108 string public BASE_URI = "";
1109 
1110 bool public isPublicMintEnabled = false;
1111 uint public COLLECTION_SIZE = 4444; 
1112 uint public MINT_PRICE = 0.0005 ether; 
1113 uint public MAX_BATCH_SIZE = 35;
1114 
1115 uint public SUPPLY_PER_WALLET = 100;
1116 uint public FREE_SUPPLY_PER_WALLET = 3;
1117 
1118 /**
1119 
1120 In the name of Chick and the Great Blessed Egg, the Lord bestows His divine blessing upon all His creations. Amen.
1121 
1122 */
1123 
1124 constructor() ERC721A("Chick Generator", "CHICK") {}
1125 
1126     function ChickAirdrop (uint256 quantity, address receiver) public onlyOwner {
1127         require(
1128             totalSupply() + quantity <= COLLECTION_SIZE,
1129             "No more chicks in stock!"
1130         );
1131         
1132         _safeMint(receiver, quantity);
1133     }
1134 
1135     modifier callerIsUser() {
1136         require(tx.origin == msg.sender, "The caller is another contract");
1137         _;
1138     }
1139 
1140     function getPrice(uint quantity) public view returns(uint){
1141         uint price;
1142         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1143         if (quantity >= free) {
1144             price = (MINT_PRICE) * (quantity - free);
1145         } else {
1146             price = 0;
1147         }
1148         return price;
1149     }
1150 
1151     /**
1152 
1153     Chicks were the crowning glory of the Creator's handiwork, they were perfect, they were splendid. 
1154     Some of them ventured into the Darkness to preach the name of the Creator, and the darkness consumed them; 
1155     some went to the Sun, and the fire embraced them. Even the Angels were vexed that the chickens were the Crown 
1156     of the Creator's creation, for they deemed themselves as such.
1157 
1158     */
1159 
1160     function mint(uint quantity)
1161         external
1162         payable
1163         callerIsUser 
1164         nonReentrant
1165     {
1166         uint price;
1167         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1168         if (quantity >= free) {
1169             price = (MINT_PRICE) * (quantity - free);
1170             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1171         } else {
1172             price = 0;
1173             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1174         }
1175 
1176         require(isPublicMintEnabled, "Chicks not ready yet!");
1177         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more left!");
1178 
1179         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to mint chicks over over limit");
1180 
1181         require(quantity <= MAX_BATCH_SIZE, "Tried to mint chicks over limit, retry with reduced quantitys");
1182         require(msg.value >= price, "Must send more eth to get Chicks");
1183 
1184         _safeMint(msg.sender, quantity);
1185 
1186         if (msg.value > price) {
1187             payable(msg.sender).transfer(msg.value - price);
1188         }
1189     }
1190     function setPublicMintEnabled() public onlyOwner {
1191         isPublicMintEnabled = !isPublicMintEnabled;
1192     }
1193 
1194     function withdrawFunds() external onlyOwner nonReentrant {
1195         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1196         require(success, "Transfer failed.");
1197     }
1198 
1199     function CollectionUrI(bool _revealed, string memory _baseURI) public onlyOwner {
1200         BASE_URI = _baseURI;
1201         REVEALED = _revealed;
1202     }
1203 
1204     function contractURI() public view returns (string memory) {
1205         return CONTRACT_URI;
1206     }
1207 
1208     function setContract(string memory _contractURI) public onlyOwner {
1209         CONTRACT_URI = _contractURI;
1210     }
1211 
1212     function ChangeCollectionSupply(uint256 _new) external onlyOwner {
1213         COLLECTION_SIZE = _new;
1214     }
1215 
1216     function ChangePrice(uint256 _newPrice) external onlyOwner {
1217         MINT_PRICE = _newPrice;
1218     }
1219 
1220     function ChangeFreePerWallet(uint256 _new) external onlyOwner {
1221         FREE_SUPPLY_PER_WALLET = _new;
1222     }
1223 
1224     function ChangeSupplyPerWallet(uint256 _new) external onlyOwner {
1225         SUPPLY_PER_WALLET = _new;
1226     }
1227 
1228     function SetMaxBatchSize(uint256 _new) external onlyOwner {
1229         MAX_BATCH_SIZE = _new;
1230     }
1231 
1232     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator { // Chicks
1233         super.transferFrom(from, to, tokenId);
1234     }
1235 
1236     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1237         super.safeTransferFrom(from, to, tokenId);
1238     }
1239 
1240     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1241         public payable
1242         override (ERC721A, IERC721A)
1243         onlyAllowedOperator
1244     {
1245         super.safeTransferFrom(from, to, tokenId, data);
1246     }
1247 
1248     function tokenURI(uint256 _tokenId)
1249         public
1250         view
1251         override (ERC721A, IERC721A)
1252         returns (string memory)
1253     {
1254         if (REVEALED) {
1255             return
1256                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1257         } else {
1258             return UNREVEALED_URI;
1259         }
1260     }
1261 
1262 }