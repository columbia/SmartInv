1 // SPDX-License-Identifier: MIT     
2 
3 /**
4 
5 Banks and stocks, they're going down,
6 Crypto's up and then it's drowned.
7 But don't you fret, don't you frown,
8 We've got something that's a gem, a crown.
9 
10 It's not a stock, it's not a bond,
11 It's not a coin that's going beyond.
12 It's Eggsplotion, the NFT craze,
13 A collection of eggs that'll amaze.
14 
15 And don't you worry, don't you fear,
16 We're not saying it'll make you a millionaire.
17 But just like fine wine that ages with time,
18 These eggs will only get better, it's no crime.
19 
20 And let's not forget, about the balls of steel,
21 Elon Musk's got them, they're the real deal.
22 But these eggs, they're something new,
23 They'll hatch into something great, it's true.
24 
25 So don't miss out, don't be a fool,
26 Get your hands on these eggs, they're cool.
27 Just like the chicken and the egg debate,
28 These eggs are what you need, it's fate.
29 
30 */
31 
32 pragma solidity ^0.8.0;
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 pragma solidity ^0.8.0;
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     modifier onlyOwner() {
54         _checkOwner();
55         _;
56     }
57 
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     function _checkOwner() internal view virtual {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64     }
65 
66     function renounceOwnership() public virtual onlyOwner {
67         _transferOwnership(address(0));
68     }
69 
70 
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         _transferOwnership(newOwner);
74     }
75 
76     function _transferOwnership(address newOwner) internal virtual {
77         address oldOwner = _owner;
78         _owner = newOwner;
79         emit OwnershipTransferred(oldOwner, newOwner);
80     }
81 }
82 
83 pragma solidity ^0.8.0;
84 
85 abstract contract ReentrancyGuard {
86 
87     uint256 private constant _NOT_ENTERED = 1;
88     uint256 private constant _ENTERED = 2;
89 
90     uint256 private _status;
91 
92     constructor() {
93         _status = _NOT_ENTERED;
94     }
95 
96     modifier nonReentrant() {
97         
98         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
99 
100         _status = _ENTERED;
101 
102         _;
103 
104         _status = _NOT_ENTERED;
105     }
106 }
107 
108 pragma solidity ^0.8.0;
109 
110 library Strings {
111     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
112     uint8 private constant _ADDRESS_LENGTH = 20;
113 
114     function toString(uint256 value) internal pure returns (string memory) {
115 
116         if (value == 0) {
117             return "0";
118         }
119         uint256 temp = value;
120         uint256 digits;
121         while (temp != 0) {
122             digits++;
123             temp /= 10;
124         }
125         bytes memory buffer = new bytes(digits);
126         while (value != 0) {
127             digits -= 1;
128             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
129             value /= 10;
130         }
131         return string(buffer);
132     }
133 
134     function toHexString(uint256 value) internal pure returns (string memory) {
135         if (value == 0) {
136             return "0x00";
137         }
138         uint256 temp = value;
139         uint256 length = 0;
140         while (temp != 0) {
141             length++;
142             temp >>= 8;
143         }
144         return toHexString(value, length);
145     }
146 
147     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
148         bytes memory buffer = new bytes(2 * length + 2);
149         buffer[0] = "0";
150         buffer[1] = "x";
151         for (uint256 i = 2 * length + 1; i > 1; --i) {
152             buffer[i] = _HEX_SYMBOLS[value & 0xf];
153             value >>= 4;
154         }
155         require(value == 0, "Strings: hex length insufficient");
156         return string(buffer);
157     }
158 
159     function toHexString(address addr) internal pure returns (string memory) {
160         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
161     }
162 }
163 
164 pragma solidity ^0.8.0;
165 
166 
167 library EnumerableSet {
168 
169 
170     struct Set {
171         // Storage of set values
172         bytes32[] _values;
173 
174         mapping(bytes32 => uint256) _indexes;
175     }
176 
177     function _add(Set storage set, bytes32 value) private returns (bool) {
178         if (!_contains(set, value)) {
179             set._values.push(value);
180 
181             set._indexes[value] = set._values.length;
182             return true;
183         } else {
184             return false;
185         }
186     }
187 
188     function _remove(Set storage set, bytes32 value) private returns (bool) {
189 
190         uint256 valueIndex = set._indexes[value];
191 
192         if (valueIndex != 0) {
193 
194             uint256 toDeleteIndex = valueIndex - 1;
195             uint256 lastIndex = set._values.length - 1;
196 
197             if (lastIndex != toDeleteIndex) {
198                 bytes32 lastValue = set._values[lastIndex];
199 
200                 set._values[toDeleteIndex] = lastValue;
201                 
202                 set._indexes[lastValue] = valueIndex; 
203             }
204 
205             set._values.pop();
206 
207             delete set._indexes[value];
208 
209             return true;
210         } else {
211             return false;
212         }
213     }
214 
215     function _contains(Set storage set, bytes32 value) private view returns (bool) {
216         return set._indexes[value] != 0;
217     }
218 
219     function _length(Set storage set) private view returns (uint256) {
220         return set._values.length;
221     }
222 
223     function _at(Set storage set, uint256 index) private view returns (bytes32) {
224         return set._values[index];
225     }
226 
227     function _values(Set storage set) private view returns (bytes32[] memory) {
228         return set._values;
229     }
230 
231     struct Bytes32Set {
232         Set _inner;
233     }
234 
235     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
236         return _add(set._inner, value);
237     }
238 
239     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
240         return _remove(set._inner, value);
241     }
242 
243     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
244         return _contains(set._inner, value);
245     }
246 
247     function length(Bytes32Set storage set) internal view returns (uint256) {
248         return _length(set._inner);
249     }
250 
251     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
252         return _at(set._inner, index);
253     }
254 
255     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
256         return _values(set._inner);
257     }
258 
259     struct AddressSet {
260         Set _inner;
261     }
262 
263     function add(AddressSet storage set, address value) internal returns (bool) {
264         return _add(set._inner, bytes32(uint256(uint160(value))));
265     }
266 
267     function remove(AddressSet storage set, address value) internal returns (bool) {
268         return _remove(set._inner, bytes32(uint256(uint160(value))));
269     }
270 
271     function contains(AddressSet storage set, address value) internal view returns (bool) {
272         return _contains(set._inner, bytes32(uint256(uint160(value))));
273     }
274 
275     function length(AddressSet storage set) internal view returns (uint256) {
276         return _length(set._inner);
277     }
278 
279     function at(AddressSet storage set, uint256 index) internal view returns (address) {
280         return address(uint160(uint256(_at(set._inner, index))));
281     }
282 
283     function values(AddressSet storage set) internal view returns (address[] memory) {
284         bytes32[] memory store = _values(set._inner);
285         address[] memory result;
286 
287         assembly {
288             result := store
289         }
290 
291         return result;
292     }
293 
294     struct UintSet {
295         Set _inner;
296     }
297 
298     function add(UintSet storage set, uint256 value) internal returns (bool) {
299         return _add(set._inner, bytes32(value));
300     }
301 
302     function remove(UintSet storage set, uint256 value) internal returns (bool) {
303         return _remove(set._inner, bytes32(value));
304     }
305 
306     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
307         return _contains(set._inner, bytes32(value));
308     }
309 
310     function length(UintSet storage set) internal view returns (uint256) {
311         return _length(set._inner);
312     }
313 
314     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
315         return uint256(_at(set._inner, index));
316     }
317 
318     function values(UintSet storage set) internal view returns (uint256[] memory) {
319         bytes32[] memory store = _values(set._inner);
320         uint256[] memory result;
321 
322         /// @solidity memory-safe-assembly
323         assembly {
324             result := store
325         }
326 
327         return result;
328     }
329 }
330 
331 pragma solidity ^0.8.4;
332 
333 interface IERC721A {
334 
335     error ApprovalCallerNotOwnerNorApproved();
336 
337     error ApprovalQueryForNonexistentToken();
338 
339     error BalanceQueryForZeroAddress();
340 
341     error MintToZeroAddress();
342 
343     error MintZeroQuantity();
344 
345     error OwnerQueryForNonexistentToken();
346 
347     error TransferCallerNotOwnerNorApproved();
348 
349     error TransferFromIncorrectOwner();
350 
351     error TransferToNonERC721ReceiverImplementer();
352 
353     error TransferToZeroAddress();
354 
355     error URIQueryForNonexistentToken();
356 
357     error MintERC2309QuantityExceedsLimit();
358 
359     error OwnershipNotInitializedForExtraData();
360 
361     struct TokenOwnership {
362 
363         address addr;
364 
365         uint64 startTimestamp;
366 
367         bool burned;
368 
369         uint24 extraData;
370     }
371 
372     function totalSupply() external view returns (uint256);
373 
374     function supportsInterface(bytes4 interfaceId) external view returns (bool);
375 
376     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
377 
378     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
379 
380     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
381 
382     function balanceOf(address owner) external view returns (uint256 balance);
383 
384     function ownerOf(uint256 tokenId) external view returns (address owner);
385 
386     function safeTransferFrom(
387         address from,
388         address to,
389         uint256 tokenId,
390         bytes calldata data
391     ) external payable;
392 
393     function safeTransferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) external payable;
398 
399     function transferFrom(
400         address from,
401         address to,
402         uint256 tokenId
403     ) external payable;
404 
405     function approve(address to, uint256 tokenId) external payable;
406 
407     function setApprovalForAll(address operator, bool _approved) external;
408 
409     function getApproved(uint256 tokenId) external view returns (address operator);
410 
411     function isApprovedForAll(address owner, address operator) external view returns (bool);
412 
413     function name() external view returns (string memory);
414 
415     function symbol() external view returns (string memory);
416 
417     function tokenURI(uint256 tokenId) external view returns (string memory);
418 
419     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
420 }
421 
422 pragma solidity ^0.8.4;
423 
424 interface ERC721A__IERC721Receiver {
425     function onERC721Received(
426         address operator,
427         address from,
428         uint256 tokenId,
429         bytes calldata data
430     ) external returns (bytes4);
431 }
432 
433 contract ERC721A is IERC721A {
434 
435     struct TokenApprovalRef {
436         address value;
437     }
438 
439     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
440 
441     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
442 
443     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
444 
445     uint256 private constant _BITPOS_AUX = 192;
446 
447     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
448 
449     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
450 
451     uint256 private constant _BITMASK_BURNED = 1 << 224;
452 
453     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
454 
455     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
456 
457     uint256 private constant _BITPOS_EXTRA_DATA = 232;
458 
459     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
460 
461     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
462 
463     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
464 
465     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
466         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
467 
468     uint256 private _currentIndex;
469 
470     uint256 private _burnCounter;
471 
472     string private _name;
473 
474     string private _symbol;
475 
476     mapping(uint256 => uint256) private _packedOwnerships;
477 
478     mapping(address => uint256) private _packedAddressData;
479 
480     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
481 
482     mapping(address => mapping(address => bool)) private _operatorApprovals;
483 
484     constructor(string memory name_, string memory symbol_) {
485         _name = name_;
486         _symbol = symbol_;
487         _currentIndex = _startTokenId();
488     }
489 
490     function _startTokenId() internal view virtual returns (uint256) {
491         return 0;
492     }
493 
494     function _nextTokenId() internal view virtual returns (uint256) {
495         return _currentIndex;
496     }
497 
498     function totalSupply() public view virtual override returns (uint256) {
499 
500         unchecked {
501             return _currentIndex - _burnCounter - _startTokenId();
502         }
503     }
504 
505     function _totalMinted() internal view virtual returns (uint256) {
506 
507         unchecked {
508             return _currentIndex - _startTokenId();
509         }
510     }
511 
512     function _totalBurned() internal view virtual returns (uint256) {
513         return _burnCounter;
514     }
515 
516     function balanceOf(address owner) public view virtual override returns (uint256) {
517         if (owner == address(0)) revert BalanceQueryForZeroAddress();
518         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
519     }
520 
521     function _numberMinted(address owner) internal view returns (uint256) {
522         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
523     }
524 
525     function _numberBurned(address owner) internal view returns (uint256) {
526         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
527     }
528 
529     function _getAux(address owner) internal view returns (uint64) {
530         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
531     }
532 
533     function _setAux(address owner, uint64 aux) internal virtual {
534         uint256 packed = _packedAddressData[owner];
535         uint256 auxCasted;
536         // Cast `aux` with assembly to avoid redundant masking.
537         assembly {
538             auxCasted := aux
539         }
540         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
541         _packedAddressData[owner] = packed;
542     }
543 
544 
545     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546 
547         return
548             interfaceId == 0x01ffc9a7 || 
549             interfaceId == 0x80ac58cd || 
550             interfaceId == 0x5b5e139f; 
551     }
552 
553     function name() public view virtual override returns (string memory) {
554         return _name;
555     }
556 
557     function symbol() public view virtual override returns (string memory) {
558         return _symbol;
559     }
560 
561     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
562         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
563 
564         string memory baseURI = _baseURI();
565         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
566     }
567 
568     function _baseURI() internal view virtual returns (string memory) {
569         return '';
570     }
571 
572     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
573         return address(uint160(_packedOwnershipOf(tokenId)));
574     }
575 
576     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
577         return _unpackedOwnership(_packedOwnershipOf(tokenId));
578     }
579 
580     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
581         return _unpackedOwnership(_packedOwnerships[index]);
582     }
583 
584     function _initializeOwnershipAt(uint256 index) internal virtual {
585         if (_packedOwnerships[index] == 0) {
586             _packedOwnerships[index] = _packedOwnershipOf(index);
587         }
588     }
589 
590     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
591         uint256 curr = tokenId;
592 
593         unchecked {
594             if (_startTokenId() <= curr)
595                 if (curr < _currentIndex) {
596                     uint256 packed = _packedOwnerships[curr];
597 
598                     if (packed & _BITMASK_BURNED == 0) {
599 
600                         while (packed == 0) {
601                             packed = _packedOwnerships[--curr];
602                         }
603                         return packed;
604                     }
605                 }
606         }
607         revert OwnerQueryForNonexistentToken();
608     }
609 
610     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
611         ownership.addr = address(uint160(packed));
612         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
613         ownership.burned = packed & _BITMASK_BURNED != 0;
614         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
615     }
616 
617     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
618         assembly {
619             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
620             owner := and(owner, _BITMASK_ADDRESS)
621             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
622             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
623         }
624     }
625 
626     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
627         // For branchless setting of the `nextInitialized` flag.
628         assembly {
629             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
630             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
631         }
632     }
633 
634     function approve(address to, uint256 tokenId) public payable virtual override {
635         address owner = ownerOf(tokenId);
636 
637         if (_msgSenderERC721A() != owner)
638             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
639                 revert ApprovalCallerNotOwnerNorApproved();
640             }
641 
642         _tokenApprovals[tokenId].value = to;
643         emit Approval(owner, to, tokenId);
644     }
645 
646     function getApproved(uint256 tokenId) public view virtual override returns (address) {
647         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
648 
649         return _tokenApprovals[tokenId].value;
650     }
651 
652     function setApprovalForAll(address operator, bool approved) public virtual override {
653         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
654         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
655     }
656 
657     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
658         return _operatorApprovals[owner][operator];
659     }
660 
661     function _exists(uint256 tokenId) internal view virtual returns (bool) {
662         return
663             _startTokenId() <= tokenId &&
664             tokenId < _currentIndex && // If within bounds,
665             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
666     }
667 
668     function _isSenderApprovedOrOwner(
669         address approvedAddress,
670         address owner,
671         address msgSender
672     ) private pure returns (bool result) {
673         assembly {
674 
675             owner := and(owner, _BITMASK_ADDRESS)
676 
677             msgSender := and(msgSender, _BITMASK_ADDRESS)
678 
679             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
680         }
681     }
682 
683     function _getApprovedSlotAndAddress(uint256 tokenId)
684         private
685         view
686         returns (uint256 approvedAddressSlot, address approvedAddress)
687     {
688         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
689 
690         assembly {
691             approvedAddressSlot := tokenApproval.slot
692             approvedAddress := sload(approvedAddressSlot)
693         }
694     }
695 
696     function transferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) public payable virtual override {
701         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
702 
703         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
704 
705         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
706 
707         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
708             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
709 
710         if (to == address(0)) revert TransferToZeroAddress();
711 
712         _beforeTokenTransfers(from, to, tokenId, 1);
713 
714         assembly {
715             if approvedAddress {
716 
717                 sstore(approvedAddressSlot, 0)
718             }
719         }
720 
721         unchecked {
722 
723             --_packedAddressData[from]; 
724             ++_packedAddressData[to]; 
725 
726             _packedOwnerships[tokenId] = _packOwnershipData(
727                 to,
728                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
729             );
730 
731             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
732                 uint256 nextTokenId = tokenId + 1;
733 
734                 if (_packedOwnerships[nextTokenId] == 0) {
735 
736                     if (nextTokenId != _currentIndex) {
737 
738                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
739                     }
740                 }
741             }
742         }
743 
744         emit Transfer(from, to, tokenId);
745         _afterTokenTransfers(from, to, tokenId, 1);
746     }
747 
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId
752     ) public payable virtual override {
753         safeTransferFrom(from, to, tokenId, '');
754     }
755 
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) public payable virtual override {
762         transferFrom(from, to, tokenId);
763         if (to.code.length != 0)
764             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
765                 revert TransferToNonERC721ReceiverImplementer();
766             }
767     }
768 
769     function _beforeTokenTransfers(
770         address from,
771         address to,
772         uint256 startTokenId,
773         uint256 quantity
774     ) internal virtual {}
775 
776     function _afterTokenTransfers(
777         address from,
778         address to,
779         uint256 startTokenId,
780         uint256 quantity
781     ) internal virtual {}
782 
783     function _checkContractOnERC721Received(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes memory _data
788     ) private returns (bool) {
789         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
790             bytes4 retval
791         ) {
792             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
793         } catch (bytes memory reason) {
794             if (reason.length == 0) {
795                 revert TransferToNonERC721ReceiverImplementer();
796             } else {
797                 assembly {
798                     revert(add(32, reason), mload(reason))
799                 }
800             }
801         }
802     }
803 
804     function _mint(address to, uint256 quantity) internal virtual {
805         uint256 startTokenId = _currentIndex;
806         if (quantity == 0) revert MintZeroQuantity();
807 
808         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
809 
810         unchecked {
811 
812             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
813 
814             _packedOwnerships[startTokenId] = _packOwnershipData(
815                 to,
816                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
817             );
818 
819             uint256 toMasked;
820             uint256 end = startTokenId + quantity;
821 
822             assembly {
823 
824                 toMasked := and(to, _BITMASK_ADDRESS)
825 
826                 log4(
827                     0, 
828                     0, 
829                     _TRANSFER_EVENT_SIGNATURE, 
830                     0, 
831                     toMasked, 
832                     startTokenId 
833                 )
834 
835                 for {
836                     let tokenId := add(startTokenId, 1)
837                 } iszero(eq(tokenId, end)) {
838                     tokenId := add(tokenId, 1)
839                 } {
840 
841                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
842                 }
843             }
844             if (toMasked == 0) revert MintToZeroAddress();
845 
846             _currentIndex = end;
847         }
848         _afterTokenTransfers(address(0), to, startTokenId, quantity);
849     }
850 
851     function _mintERC2309(address to, uint256 quantity) internal virtual {
852         uint256 startTokenId = _currentIndex;
853         if (to == address(0)) revert MintToZeroAddress();
854         if (quantity == 0) revert MintZeroQuantity();
855         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
856 
857         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
858 
859         unchecked {
860 
861             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
862 
863             _packedOwnerships[startTokenId] = _packOwnershipData(
864                 to,
865                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
866             );
867 
868             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
869 
870             _currentIndex = startTokenId + quantity;
871         }
872         _afterTokenTransfers(address(0), to, startTokenId, quantity);
873     }
874 
875     function _safeMint(
876         address to,
877         uint256 quantity,
878         bytes memory _data
879     ) internal virtual {
880         _mint(to, quantity);
881 
882         unchecked {
883             if (to.code.length != 0) {
884                 uint256 end = _currentIndex;
885                 uint256 index = end - quantity;
886                 do {
887                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
888                         revert TransferToNonERC721ReceiverImplementer();
889                     }
890                 } while (index < end);
891                 // Reentrancy protection.
892                 if (_currentIndex != end) revert();
893             }
894         }
895     }
896 
897     function _safeMint(address to, uint256 quantity) internal virtual {
898         _safeMint(to, quantity, '');
899     }
900 
901     function _burn(uint256 tokenId) internal virtual {
902         _burn(tokenId, false);
903     }
904 
905     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
906         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
907 
908         address from = address(uint160(prevOwnershipPacked));
909 
910         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
911 
912         if (approvalCheck) {
913             
914             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
915                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
916         }
917 
918         _beforeTokenTransfers(from, address(0), tokenId, 1);
919 
920         assembly {
921             if approvedAddress {
922                 
923                 sstore(approvedAddressSlot, 0)
924             }
925         }
926 
927         unchecked {
928 
929             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
930 
931             _packedOwnerships[tokenId] = _packOwnershipData(
932                 from,
933                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
934             );
935 
936             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
937                 uint256 nextTokenId = tokenId + 1;
938 
939                 if (_packedOwnerships[nextTokenId] == 0) {
940 
941                     if (nextTokenId != _currentIndex) {
942 
943                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
944                     }
945                 }
946             }
947         }
948 
949         emit Transfer(from, address(0), tokenId);
950         _afterTokenTransfers(from, address(0), tokenId, 1);
951 
952         unchecked {
953             _burnCounter++;
954         }
955     }
956 
957     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
958         uint256 packed = _packedOwnerships[index];
959         if (packed == 0) revert OwnershipNotInitializedForExtraData();
960         uint256 extraDataCasted;
961         assembly {
962             extraDataCasted := extraData
963         }
964         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
965         _packedOwnerships[index] = packed;
966     }
967 
968     function _extraData(
969         address from,
970         address to,
971         uint24 previousExtraData
972     ) internal view virtual returns (uint24) {}
973 
974     function _nextExtraData(
975         address from,
976         address to,
977         uint256 prevOwnershipPacked
978     ) private view returns (uint256) {
979         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
980         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
981     }
982 
983     function _msgSenderERC721A() internal view virtual returns (address) {
984         return msg.sender;
985     }
986 
987     function _toString(uint256 value) internal pure virtual returns (string memory str) {
988         assembly {
989 
990             let m := add(mload(0x40), 0xa0)
991 
992             mstore(0x40, m)
993 
994             str := sub(m, 0x20)
995 
996             mstore(str, 0)
997 
998             let end := str
999 
1000             for { let temp := value } 1 {} {
1001                 str := sub(str, 1)
1002 
1003                 mstore8(str, add(48, mod(temp, 10)))
1004 
1005                 temp := div(temp, 10)
1006 
1007                 if iszero(temp) { break }
1008             }
1009 
1010             let length := sub(end, str)
1011 
1012             str := sub(str, 0x20)
1013 
1014             mstore(str, length)
1015         }
1016     }
1017 }
1018 
1019 pragma solidity ^0.8.13;
1020 
1021 contract OperatorFilterer {
1022     error OperatorNotAllowed(address operator);
1023 
1024     IOperatorFilterRegistry constant operatorFilterRegistry =
1025         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1026 
1027     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1028 
1029         if (address(operatorFilterRegistry).code.length > 0) {
1030             if (subscribe) {
1031                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1032             } else {
1033                 if (subscriptionOrRegistrantToCopy != address(0)) {
1034                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1035                 } else {
1036                     operatorFilterRegistry.register(address(this));
1037                 }
1038             }
1039         }
1040     }
1041 
1042     modifier onlyAllowedOperator() virtual {
1043 
1044         if (address(operatorFilterRegistry).code.length > 0) {
1045             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1046                 revert OperatorNotAllowed(msg.sender);
1047             }
1048         }
1049         _;
1050     }
1051 }
1052 
1053 pragma solidity ^0.8.13;
1054 
1055 contract DefaultOperatorFilterer is OperatorFilterer {
1056     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1057 
1058     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1059 }
1060 
1061 pragma solidity ^0.8.13;
1062 
1063 interface IOperatorFilterRegistry {
1064     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1065     function register(address registrant) external;
1066     function registerAndSubscribe(address registrant, address subscription) external;
1067     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1068     function updateOperator(address registrant, address operator, bool filtered) external;
1069     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1070     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1071     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1072     function subscribe(address registrant, address registrantToSubscribe) external;
1073     function unsubscribe(address registrant, bool copyExistingEntries) external;
1074     function subscriptionOf(address addr) external returns (address registrant);
1075     function subscribers(address registrant) external returns (address[] memory);
1076     function subscriberAt(address registrant, uint256 index) external returns (address);
1077     function copyEntriesOf(address registrant, address registrantToCopy) external;
1078     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1079     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1080     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1081     function filteredOperators(address addr) external returns (address[] memory);
1082     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1083     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1084     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1085     function isRegistered(address addr) external returns (bool);
1086     function codeHashOf(address addr) external returns (bytes32);
1087 }
1088 
1089 pragma solidity ^0.8.4;
1090 
1091 interface IERC721ABurnable is IERC721A {
1092 
1093     function burn(uint256 tokenId) external;
1094 }
1095 
1096 pragma solidity ^0.8.4;
1097 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1098     function burn(uint256 tokenId) public virtual override {
1099         _burn(tokenId, true);
1100     }
1101 }
1102 
1103 pragma solidity ^0.8.16;
1104 contract Eggsplosion is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1105 string public CONTRACT_URI = "";
1106 mapping(address => uint) public userHasMinted;
1107 bool public REVEALED;
1108 string public UNREVEALED_URI = "";
1109 string public BASE_URI = "";
1110 bool public isPublicMintEnabled = false;
1111 uint public COLLECTION_SIZE = 4444; 
1112 uint public MINT_PRICE = 0.002 ether; 
1113 uint public MAX_BATCH_SIZE = 25;
1114 uint public SUPPLY_PER_WALLET = 50;
1115 uint public FREE_SUPPLY_PER_WALLET = 5;
1116 constructor() ERC721A("Eggsplosion", "Eggsplosion") {}
1117 
1118 
1119     function MintViP(uint256 quantity, address receiver) public onlyOwner {
1120         require(
1121             totalSupply() + quantity <= COLLECTION_SIZE,
1122             "No more Eggs in stock!"
1123         );
1124         
1125         _safeMint(receiver, quantity);
1126     }
1127 
1128     modifier callerIsUser() {
1129         require(tx.origin == msg.sender, "The caller is another contract");
1130         _;
1131     }
1132 
1133     function getPrice(uint quantity) public view returns(uint){
1134         uint price;
1135         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1136         if (quantity >= free) {
1137             price = (MINT_PRICE) * (quantity - free);
1138         } else {
1139             price = 0;
1140         }
1141         return price;
1142     }
1143 
1144     function mint(uint quantity)
1145         external
1146         payable
1147         callerIsUser 
1148         nonReentrant
1149     {
1150         uint price;
1151         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1152         if (quantity >= free) {
1153             price = (MINT_PRICE) * (quantity - free);
1154             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1155         } else {
1156             price = 0;
1157             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1158         }
1159 
1160         require(isPublicMintEnabled, "Eggs not ready yet!");
1161         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more Eggs left!");
1162 
1163         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to mint Eggs over over limit");
1164 
1165         require(quantity <= MAX_BATCH_SIZE, "Tried to mint Eggs over limit, retry with reduced quantity");
1166         require(msg.value >= price, "Must send more money!");
1167 
1168         _safeMint(msg.sender, quantity);
1169 
1170         if (msg.value > price) {
1171             payable(msg.sender).transfer(msg.value - price);
1172         }
1173     }
1174     function setPublicMintEnabled() public onlyOwner {
1175         isPublicMintEnabled = !isPublicMintEnabled;
1176     }
1177 
1178     function withdrawFunds() external onlyOwner nonReentrant {
1179         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1180         require(success, "Transfer failed.");
1181     }
1182 
1183     function CollectionUrI(bool _revealed, string memory _baseURI) public onlyOwner {
1184         BASE_URI = _baseURI;
1185         REVEALED = _revealed;
1186     }
1187 
1188     function contractURI() public view returns (string memory) {
1189         return CONTRACT_URI;
1190     }
1191 
1192     function setContract(string memory _contractURI) public onlyOwner {
1193         CONTRACT_URI = _contractURI;
1194     }
1195 
1196     function ChangeCollectionSupply(uint256 _new) external onlyOwner {
1197         COLLECTION_SIZE = _new;
1198     }
1199 
1200     function ChangePrice(uint256 _newPrice) external onlyOwner {
1201         MINT_PRICE = _newPrice;
1202     }
1203 
1204     function ChangeFreePerWallet(uint256 _new) external onlyOwner {
1205         FREE_SUPPLY_PER_WALLET = _new;
1206     }
1207 
1208     function ChangeSupplyPerWallet(uint256 _new) external onlyOwner {
1209         SUPPLY_PER_WALLET = _new;
1210     }
1211 
1212     function SetMaxBatchSize(uint256 _new) external onlyOwner {
1213         MAX_BATCH_SIZE = _new;
1214     }
1215 
1216     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1217         super.transferFrom(from, to, tokenId);
1218     }
1219 
1220     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1221         super.safeTransferFrom(from, to, tokenId);
1222     }
1223 
1224     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1225         public payable
1226         override (ERC721A, IERC721A)
1227         onlyAllowedOperator
1228     {
1229         super.safeTransferFrom(from, to, tokenId, data);
1230     }
1231 
1232     function tokenURI(uint256 _tokenId)
1233         public
1234         view
1235         override (ERC721A, IERC721A)
1236         returns (string memory)
1237     {
1238         if (REVEALED) {
1239             return
1240                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1241         } else {
1242             return UNREVEALED_URI;
1243         }
1244     }
1245 
1246 }