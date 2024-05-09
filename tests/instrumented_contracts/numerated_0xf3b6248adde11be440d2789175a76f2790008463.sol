1 // SPDX-License-Identifier: MIT     
2 
3 //
4 // • ▌ ▄ ·.        ▐ ▄ .▄▄ · ▄▄▄▄▄▄▄▄ .▄▄▄      ▄▄▄▄▄▄▄▄  ▄• ▄▌ ▄▄· ▄ •▄ .▄▄ · 
5 //. ·██ ▐███▪▪     •█▌▐█▐█ ▀. •██  ▀▄.▀·▀▄ █·    •██  ▀▄ █·█▪██▌▐█ ▌▪█▌▄▌▪▐█ ▀. 
6 //. ▐█ ▌▐▌▐█· ▄█▀▄ ▐█▐▐▌▄▀▀▀█▄ ▐█.▪▐▀▀▪▄▐▀▀▄      ▐█.▪▐▀▀▄ █▌▐█▌██ ▄▄▐▀▀▄·▄▀▀▀█▄
7 //. ██ ██▌▐█▌▐█▌.▐▌██▐█▌▐█▄▪▐█ ▐█▌·▐█▄▄▌▐█•█▌     ▐█▌·▐█•█▌▐█▄█▌▐███▌▐█.█▌▐█▄▪▐█
8 //. ▀▀  █▪▀▀▀ ▀█▄▀▪▀▀ █▪ ▀▀▀▀  ▀▀▀  ▀▀▀ .▀  ▀     ▀▀▀ .▀  ▀ ▀▀▀ ·▀▀▀ ·▀  ▀ ▀▀▀▀ 
9 //
10 //
11 
12 pragma solidity ^0.8.0;
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 pragma solidity ^0.8.0;
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     modifier onlyOwner() {
34         _checkOwner();
35         _;
36     }
37 
38     function owner() public view virtual returns (address) {
39         return _owner;
40     }
41 
42     function _checkOwner() internal view virtual {
43         require(owner() == _msgSender(), "Ownable: caller is not the owner");
44     }
45 
46     function renounceOwnership() public virtual onlyOwner {
47         _transferOwnership(address(0));
48     }
49 
50 
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(newOwner != address(0), "Ownable: new owner is the zero address");
53         _transferOwnership(newOwner);
54     }
55 
56     function _transferOwnership(address newOwner) internal virtual {
57         address oldOwner = _owner;
58         _owner = newOwner;
59         emit OwnershipTransferred(oldOwner, newOwner);
60     }
61 }
62 
63 pragma solidity ^0.8.0;
64 
65 abstract contract ReentrancyGuard {
66 
67     uint256 private constant _NOT_ENTERED = 1;
68     uint256 private constant _ENTERED = 2;
69 
70     uint256 private _status;
71 
72     constructor() {
73         _status = _NOT_ENTERED;
74     }
75 
76     modifier nonReentrant() {
77         
78         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
79 
80         _status = _ENTERED;
81 
82         _;
83 
84         _status = _NOT_ENTERED;
85     }
86 }
87 
88 pragma solidity ^0.8.0;
89 
90 library Strings {
91     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
92     uint8 private constant _ADDRESS_LENGTH = 20;
93 
94     function toString(uint256 value) internal pure returns (string memory) {
95 
96         if (value == 0) {
97             return "0";
98         }
99         uint256 temp = value;
100         uint256 digits;
101         while (temp != 0) {
102             digits++;
103             temp /= 10;
104         }
105         bytes memory buffer = new bytes(digits);
106         while (value != 0) {
107             digits -= 1;
108             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
109             value /= 10;
110         }
111         return string(buffer);
112     }
113 
114     function toHexString(uint256 value) internal pure returns (string memory) {
115         if (value == 0) {
116             return "0x00";
117         }
118         uint256 temp = value;
119         uint256 length = 0;
120         while (temp != 0) {
121             length++;
122             temp >>= 8;
123         }
124         return toHexString(value, length);
125     }
126 
127     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
128         bytes memory buffer = new bytes(2 * length + 2);
129         buffer[0] = "0";
130         buffer[1] = "x";
131         for (uint256 i = 2 * length + 1; i > 1; --i) {
132             buffer[i] = _HEX_SYMBOLS[value & 0xf];
133             value >>= 4;
134         }
135         require(value == 0, "Strings: hex length insufficient");
136         return string(buffer);
137     }
138 
139     function toHexString(address addr) internal pure returns (string memory) {
140         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
141     }
142 }
143 
144 pragma solidity ^0.8.0;
145 
146 
147 library EnumerableSet {
148 
149 
150     struct Set {
151         // Storage of set values
152         bytes32[] _values;
153 
154         mapping(bytes32 => uint256) _indexes;
155     }
156 
157     function _add(Set storage set, bytes32 value) private returns (bool) {
158         if (!_contains(set, value)) {
159             set._values.push(value);
160 
161             set._indexes[value] = set._values.length;
162             return true;
163         } else {
164             return false;
165         }
166     }
167 
168     function _remove(Set storage set, bytes32 value) private returns (bool) {
169 
170         uint256 valueIndex = set._indexes[value];
171 
172         if (valueIndex != 0) {
173 
174             uint256 toDeleteIndex = valueIndex - 1;
175             uint256 lastIndex = set._values.length - 1;
176 
177             if (lastIndex != toDeleteIndex) {
178                 bytes32 lastValue = set._values[lastIndex];
179 
180                 set._values[toDeleteIndex] = lastValue;
181                 
182                 set._indexes[lastValue] = valueIndex; 
183             }
184 
185             set._values.pop();
186 
187             delete set._indexes[value];
188 
189             return true;
190         } else {
191             return false;
192         }
193     }
194 
195     function _contains(Set storage set, bytes32 value) private view returns (bool) {
196         return set._indexes[value] != 0;
197     }
198 
199     function _length(Set storage set) private view returns (uint256) {
200         return set._values.length;
201     }
202 
203     function _at(Set storage set, uint256 index) private view returns (bytes32) {
204         return set._values[index];
205     }
206 
207     function _values(Set storage set) private view returns (bytes32[] memory) {
208         return set._values;
209     }
210 
211     struct Bytes32Set {
212         Set _inner;
213     }
214 
215     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
216         return _add(set._inner, value);
217     }
218 
219     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
220         return _remove(set._inner, value);
221     }
222 
223     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
224         return _contains(set._inner, value);
225     }
226 
227     function length(Bytes32Set storage set) internal view returns (uint256) {
228         return _length(set._inner);
229     }
230 
231     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
232         return _at(set._inner, index);
233     }
234 
235     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
236         return _values(set._inner);
237     }
238 
239     struct AddressSet {
240         Set _inner;
241     }
242 
243     function add(AddressSet storage set, address value) internal returns (bool) {
244         return _add(set._inner, bytes32(uint256(uint160(value))));
245     }
246 
247     function remove(AddressSet storage set, address value) internal returns (bool) {
248         return _remove(set._inner, bytes32(uint256(uint160(value))));
249     }
250 
251     function contains(AddressSet storage set, address value) internal view returns (bool) {
252         return _contains(set._inner, bytes32(uint256(uint160(value))));
253     }
254 
255     function length(AddressSet storage set) internal view returns (uint256) {
256         return _length(set._inner);
257     }
258 
259     function at(AddressSet storage set, uint256 index) internal view returns (address) {
260         return address(uint160(uint256(_at(set._inner, index))));
261     }
262 
263     function values(AddressSet storage set) internal view returns (address[] memory) {
264         bytes32[] memory store = _values(set._inner);
265         address[] memory result;
266 
267         assembly {
268             result := store
269         }
270 
271         return result;
272     }
273 
274     struct UintSet {
275         Set _inner;
276     }
277 
278     function add(UintSet storage set, uint256 value) internal returns (bool) {
279         return _add(set._inner, bytes32(value));
280     }
281 
282     function remove(UintSet storage set, uint256 value) internal returns (bool) {
283         return _remove(set._inner, bytes32(value));
284     }
285 
286     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
287         return _contains(set._inner, bytes32(value));
288     }
289 
290     function length(UintSet storage set) internal view returns (uint256) {
291         return _length(set._inner);
292     }
293 
294     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
295         return uint256(_at(set._inner, index));
296     }
297 
298     function values(UintSet storage set) internal view returns (uint256[] memory) {
299         bytes32[] memory store = _values(set._inner);
300         uint256[] memory result;
301 
302         /// @solidity memory-safe-assembly
303         assembly {
304             result := store
305         }
306 
307         return result;
308     }
309 }
310 
311 pragma solidity ^0.8.4;
312 
313 interface IERC721A {
314 
315     error ApprovalCallerNotOwnerNorApproved();
316 
317     error ApprovalQueryForNonexistentToken();
318 
319     error BalanceQueryForZeroAddress();
320 
321     error MintToZeroAddress();
322 
323     error MintZeroQuantity();
324 
325     error OwnerQueryForNonexistentToken();
326 
327     error TransferCallerNotOwnerNorApproved();
328 
329     error TransferFromIncorrectOwner();
330 
331     error TransferToNonERC721ReceiverImplementer();
332 
333     error TransferToZeroAddress();
334 
335     error URIQueryForNonexistentToken();
336 
337     error MintERC2309QuantityExceedsLimit();
338 
339     error OwnershipNotInitializedForExtraData();
340 
341     struct TokenOwnership {
342 
343         address addr;
344 
345         uint64 startTimestamp;
346 
347         bool burned;
348 
349         uint24 extraData;
350     }
351 
352     function totalSupply() external view returns (uint256);
353 
354     function supportsInterface(bytes4 interfaceId) external view returns (bool);
355 
356     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
357 
358     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
359 
360     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
361 
362     function balanceOf(address owner) external view returns (uint256 balance);
363 
364     function ownerOf(uint256 tokenId) external view returns (address owner);
365 
366     function safeTransferFrom(
367         address from,
368         address to,
369         uint256 tokenId,
370         bytes calldata data
371     ) external payable;
372 
373     function safeTransferFrom(
374         address from,
375         address to,
376         uint256 tokenId
377     ) external payable;
378 
379     function transferFrom(
380         address from,
381         address to,
382         uint256 tokenId
383     ) external payable;
384 
385     function approve(address to, uint256 tokenId) external payable;
386 
387     function setApprovalForAll(address operator, bool _approved) external;
388 
389     function getApproved(uint256 tokenId) external view returns (address operator);
390 
391     function isApprovedForAll(address owner, address operator) external view returns (bool);
392 
393     function name() external view returns (string memory);
394 
395     function symbol() external view returns (string memory);
396 
397     function tokenURI(uint256 tokenId) external view returns (string memory);
398 
399     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
400 }
401 
402 pragma solidity ^0.8.4;
403 
404 interface ERC721A__IERC721Receiver {
405     function onERC721Received(
406         address operator,
407         address from,
408         uint256 tokenId,
409         bytes calldata data
410     ) external returns (bytes4);
411 }
412 
413 contract ERC721A is IERC721A {
414 
415     struct TokenApprovalRef {
416         address value;
417     }
418 
419     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
420 
421     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
422 
423     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
424 
425     uint256 private constant _BITPOS_AUX = 192;
426 
427     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
428 
429     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
430 
431     uint256 private constant _BITMASK_BURNED = 1 << 224;
432 
433     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
434 
435     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
436 
437     uint256 private constant _BITPOS_EXTRA_DATA = 232;
438 
439     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
440 
441     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
442 
443     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
444 
445     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
446         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
447 
448     uint256 private _currentIndex;
449 
450     uint256 private _burnCounter;
451 
452     string private _name;
453 
454     string private _symbol;
455 
456     mapping(uint256 => uint256) private _packedOwnerships;
457 
458     mapping(address => uint256) private _packedAddressData;
459 
460     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
461 
462     mapping(address => mapping(address => bool)) private _operatorApprovals;
463 
464     constructor(string memory name_, string memory symbol_) {
465         _name = name_;
466         _symbol = symbol_;
467         _currentIndex = _startTokenId();
468     }
469 
470     function _startTokenId() internal view virtual returns (uint256) {
471         return 0;
472     }
473 
474     function _nextTokenId() internal view virtual returns (uint256) {
475         return _currentIndex;
476     }
477 
478     function totalSupply() public view virtual override returns (uint256) {
479 
480         unchecked {
481             return _currentIndex - _burnCounter - _startTokenId();
482         }
483     }
484 
485     function _totalMinted() internal view virtual returns (uint256) {
486 
487         unchecked {
488             return _currentIndex - _startTokenId();
489         }
490     }
491 
492     function _totalBurned() internal view virtual returns (uint256) {
493         return _burnCounter;
494     }
495 
496     function balanceOf(address owner) public view virtual override returns (uint256) {
497         if (owner == address(0)) revert BalanceQueryForZeroAddress();
498         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
499     }
500 
501     function _numberMinted(address owner) internal view returns (uint256) {
502         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
503     }
504 
505     function _numberBurned(address owner) internal view returns (uint256) {
506         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
507     }
508 
509     function _getAux(address owner) internal view returns (uint64) {
510         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
511     }
512 
513     function _setAux(address owner, uint64 aux) internal virtual {
514         uint256 packed = _packedAddressData[owner];
515         uint256 auxCasted;
516         // Cast `aux` with assembly to avoid redundant masking.
517         assembly {
518             auxCasted := aux
519         }
520         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
521         _packedAddressData[owner] = packed;
522     }
523 
524 
525     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526 
527         return
528             interfaceId == 0x01ffc9a7 || 
529             interfaceId == 0x80ac58cd || 
530             interfaceId == 0x5b5e139f; 
531     }
532 
533     function name() public view virtual override returns (string memory) {
534         return _name;
535     }
536 
537     function symbol() public view virtual override returns (string memory) {
538         return _symbol;
539     }
540 
541     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
542         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
543 
544         string memory baseURI = _baseURI();
545         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
546     }
547 
548     function _baseURI() internal view virtual returns (string memory) {
549         return '';
550     }
551 
552     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
553         return address(uint160(_packedOwnershipOf(tokenId)));
554     }
555 
556     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
557         return _unpackedOwnership(_packedOwnershipOf(tokenId));
558     }
559 
560     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
561         return _unpackedOwnership(_packedOwnerships[index]);
562     }
563 
564     function _initializeOwnershipAt(uint256 index) internal virtual {
565         if (_packedOwnerships[index] == 0) {
566             _packedOwnerships[index] = _packedOwnershipOf(index);
567         }
568     }
569 
570     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
571         uint256 curr = tokenId;
572 
573         unchecked {
574             if (_startTokenId() <= curr)
575                 if (curr < _currentIndex) {
576                     uint256 packed = _packedOwnerships[curr];
577 
578                     if (packed & _BITMASK_BURNED == 0) {
579 
580                         while (packed == 0) {
581                             packed = _packedOwnerships[--curr];
582                         }
583                         return packed;
584                     }
585                 }
586         }
587         revert OwnerQueryForNonexistentToken();
588     }
589 
590     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
591         ownership.addr = address(uint160(packed));
592         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
593         ownership.burned = packed & _BITMASK_BURNED != 0;
594         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
595     }
596 
597     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
598         assembly {
599             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
600             owner := and(owner, _BITMASK_ADDRESS)
601             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
602             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
603         }
604     }
605 
606     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
607         // For branchless setting of the `nextInitialized` flag.
608         assembly {
609             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
610             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
611         }
612     }
613 
614     function approve(address to, uint256 tokenId) public payable virtual override {
615         address owner = ownerOf(tokenId);
616 
617         if (_msgSenderERC721A() != owner)
618             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
619                 revert ApprovalCallerNotOwnerNorApproved();
620             }
621 
622         _tokenApprovals[tokenId].value = to;
623         emit Approval(owner, to, tokenId);
624     }
625 
626     function getApproved(uint256 tokenId) public view virtual override returns (address) {
627         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
628 
629         return _tokenApprovals[tokenId].value;
630     }
631 
632     function setApprovalForAll(address operator, bool approved) public virtual override {
633         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
634         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
635     }
636 
637     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
638         return _operatorApprovals[owner][operator];
639     }
640 
641     function _exists(uint256 tokenId) internal view virtual returns (bool) {
642         return
643             _startTokenId() <= tokenId &&
644             tokenId < _currentIndex && // If within bounds,
645             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
646     }
647 
648     function _isSenderApprovedOrOwner(
649         address approvedAddress,
650         address owner,
651         address msgSender
652     ) private pure returns (bool result) {
653         assembly {
654 
655             owner := and(owner, _BITMASK_ADDRESS)
656 
657             msgSender := and(msgSender, _BITMASK_ADDRESS)
658 
659             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
660         }
661     }
662 
663     function _getApprovedSlotAndAddress(uint256 tokenId)
664         private
665         view
666         returns (uint256 approvedAddressSlot, address approvedAddress)
667     {
668         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
669 
670         assembly {
671             approvedAddressSlot := tokenApproval.slot
672             approvedAddress := sload(approvedAddressSlot)
673         }
674     }
675 
676     function transferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) public payable virtual override {
681         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
682 
683         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
684 
685         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
686 
687         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
688             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
689 
690         if (to == address(0)) revert TransferToZeroAddress();
691 
692         _beforeTokenTransfers(from, to, tokenId, 1);
693 
694         assembly {
695             if approvedAddress {
696 
697                 sstore(approvedAddressSlot, 0)
698             }
699         }
700 
701         unchecked {
702 
703             --_packedAddressData[from]; 
704             ++_packedAddressData[to]; 
705 
706             _packedOwnerships[tokenId] = _packOwnershipData(
707                 to,
708                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
709             );
710 
711             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
712                 uint256 nextTokenId = tokenId + 1;
713 
714                 if (_packedOwnerships[nextTokenId] == 0) {
715 
716                     if (nextTokenId != _currentIndex) {
717 
718                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
719                     }
720                 }
721             }
722         }
723 
724         emit Transfer(from, to, tokenId);
725         _afterTokenTransfers(from, to, tokenId, 1);
726     }
727 
728     function safeTransferFrom(
729         address from,
730         address to,
731         uint256 tokenId
732     ) public payable virtual override {
733         safeTransferFrom(from, to, tokenId, '');
734     }
735 
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId,
740         bytes memory _data
741     ) public payable virtual override {
742         transferFrom(from, to, tokenId);
743         if (to.code.length != 0)
744             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
745                 revert TransferToNonERC721ReceiverImplementer();
746             }
747     }
748 
749     function _beforeTokenTransfers(
750         address from,
751         address to,
752         uint256 startTokenId,
753         uint256 quantity
754     ) internal virtual {}
755 
756     function _afterTokenTransfers(
757         address from,
758         address to,
759         uint256 startTokenId,
760         uint256 quantity
761     ) internal virtual {}
762 
763     function _checkContractOnERC721Received(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes memory _data
768     ) private returns (bool) {
769         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
770             bytes4 retval
771         ) {
772             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
773         } catch (bytes memory reason) {
774             if (reason.length == 0) {
775                 revert TransferToNonERC721ReceiverImplementer();
776             } else {
777                 assembly {
778                     revert(add(32, reason), mload(reason))
779                 }
780             }
781         }
782     }
783 
784     function _mint(address to, uint256 quantity) internal virtual {
785         uint256 startTokenId = _currentIndex;
786         if (quantity == 0) revert MintZeroQuantity();
787 
788         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
789 
790         unchecked {
791 
792             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
793 
794             _packedOwnerships[startTokenId] = _packOwnershipData(
795                 to,
796                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
797             );
798 
799             uint256 toMasked;
800             uint256 end = startTokenId + quantity;
801 
802             assembly {
803 
804                 toMasked := and(to, _BITMASK_ADDRESS)
805 
806                 log4(
807                     0, 
808                     0, 
809                     _TRANSFER_EVENT_SIGNATURE, 
810                     0, 
811                     toMasked, 
812                     startTokenId 
813                 )
814 
815                 for {
816                     let tokenId := add(startTokenId, 1)
817                 } iszero(eq(tokenId, end)) {
818                     tokenId := add(tokenId, 1)
819                 } {
820 
821                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
822                 }
823             }
824             if (toMasked == 0) revert MintToZeroAddress();
825 
826             _currentIndex = end;
827         }
828         _afterTokenTransfers(address(0), to, startTokenId, quantity);
829     }
830 
831     function _mintERC2309(address to, uint256 quantity) internal virtual {
832         uint256 startTokenId = _currentIndex;
833         if (to == address(0)) revert MintToZeroAddress();
834         if (quantity == 0) revert MintZeroQuantity();
835         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
836 
837         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
838 
839         unchecked {
840 
841             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
842 
843             _packedOwnerships[startTokenId] = _packOwnershipData(
844                 to,
845                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
846             );
847 
848             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
849 
850             _currentIndex = startTokenId + quantity;
851         }
852         _afterTokenTransfers(address(0), to, startTokenId, quantity);
853     }
854 
855     function _safeMint(
856         address to,
857         uint256 quantity,
858         bytes memory _data
859     ) internal virtual {
860         _mint(to, quantity);
861 
862         unchecked {
863             if (to.code.length != 0) {
864                 uint256 end = _currentIndex;
865                 uint256 index = end - quantity;
866                 do {
867                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
868                         revert TransferToNonERC721ReceiverImplementer();
869                     }
870                 } while (index < end);
871                 // Reentrancy protection.
872                 if (_currentIndex != end) revert();
873             }
874         }
875     }
876 
877     function _safeMint(address to, uint256 quantity) internal virtual {
878         _safeMint(to, quantity, '');
879     }
880 
881     function _burn(uint256 tokenId) internal virtual {
882         _burn(tokenId, false);
883     }
884 
885     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
886         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
887 
888         address from = address(uint160(prevOwnershipPacked));
889 
890         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
891 
892         if (approvalCheck) {
893             
894             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
895                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
896         }
897 
898         _beforeTokenTransfers(from, address(0), tokenId, 1);
899 
900         assembly {
901             if approvedAddress {
902                 
903                 sstore(approvedAddressSlot, 0)
904             }
905         }
906 
907         unchecked {
908 
909             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
910 
911             _packedOwnerships[tokenId] = _packOwnershipData(
912                 from,
913                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
914             );
915 
916             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
917                 uint256 nextTokenId = tokenId + 1;
918 
919                 if (_packedOwnerships[nextTokenId] == 0) {
920 
921                     if (nextTokenId != _currentIndex) {
922 
923                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
924                     }
925                 }
926             }
927         }
928 
929         emit Transfer(from, address(0), tokenId);
930         _afterTokenTransfers(from, address(0), tokenId, 1);
931 
932         unchecked {
933             _burnCounter++;
934         }
935     }
936 
937     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
938         uint256 packed = _packedOwnerships[index];
939         if (packed == 0) revert OwnershipNotInitializedForExtraData();
940         uint256 extraDataCasted;
941         assembly {
942             extraDataCasted := extraData
943         }
944         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
945         _packedOwnerships[index] = packed;
946     }
947 
948     function _extraData(
949         address from,
950         address to,
951         uint24 previousExtraData
952     ) internal view virtual returns (uint24) {}
953 
954     function _nextExtraData(
955         address from,
956         address to,
957         uint256 prevOwnershipPacked
958     ) private view returns (uint256) {
959         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
960         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
961     }
962 
963     function _msgSenderERC721A() internal view virtual returns (address) {
964         return msg.sender;
965     }
966 
967     function _toString(uint256 value) internal pure virtual returns (string memory str) {
968         assembly {
969 
970             let m := add(mload(0x40), 0xa0)
971 
972             mstore(0x40, m)
973 
974             str := sub(m, 0x20)
975 
976             mstore(str, 0)
977 
978             let end := str
979 
980             for { let temp := value } 1 {} {
981                 str := sub(str, 1)
982 
983                 mstore8(str, add(48, mod(temp, 10)))
984 
985                 temp := div(temp, 10)
986 
987                 if iszero(temp) { break }
988             }
989 
990             let length := sub(end, str)
991 
992             str := sub(str, 0x20)
993 
994             mstore(str, length)
995         }
996     }
997 }
998 
999 pragma solidity ^0.8.13;
1000 
1001 contract OperatorFilterer {
1002     error OperatorNotAllowed(address operator);
1003 
1004     IOperatorFilterRegistry constant operatorFilterRegistry =
1005         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1006 
1007     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1008 
1009         if (address(operatorFilterRegistry).code.length > 0) {
1010             if (subscribe) {
1011                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1012             } else {
1013                 if (subscriptionOrRegistrantToCopy != address(0)) {
1014                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1015                 } else {
1016                     operatorFilterRegistry.register(address(this));
1017                 }
1018             }
1019         }
1020     }
1021 
1022     modifier onlyAllowedOperator() virtual {
1023 
1024         if (address(operatorFilterRegistry).code.length > 0) {
1025             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1026                 revert OperatorNotAllowed(msg.sender);
1027             }
1028         }
1029         _;
1030     }
1031 }
1032 
1033 pragma solidity ^0.8.13;
1034 
1035 contract DefaultOperatorFilterer is OperatorFilterer {
1036     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1037 
1038     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1039 }
1040 
1041 pragma solidity ^0.8.13;
1042 
1043 interface IOperatorFilterRegistry {
1044     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1045     function register(address registrant) external;
1046     function registerAndSubscribe(address registrant, address subscription) external;
1047     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1048     function updateOperator(address registrant, address operator, bool filtered) external;
1049     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1050     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1051     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1052     function subscribe(address registrant, address registrantToSubscribe) external;
1053     function unsubscribe(address registrant, bool copyExistingEntries) external;
1054     function subscriptionOf(address addr) external returns (address registrant);
1055     function subscribers(address registrant) external returns (address[] memory);
1056     function subscriberAt(address registrant, uint256 index) external returns (address);
1057     function copyEntriesOf(address registrant, address registrantToCopy) external;
1058     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1059     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1060     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1061     function filteredOperators(address addr) external returns (address[] memory);
1062     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1063     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1064     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1065     function isRegistered(address addr) external returns (bool);
1066     function codeHashOf(address addr) external returns (bytes32);
1067 }
1068 
1069 pragma solidity ^0.8.4;
1070 
1071 interface IERC721ABurnable is IERC721A {
1072 
1073     function burn(uint256 tokenId) external;
1074 }
1075 
1076 pragma solidity ^0.8.4;
1077 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1078     function burn(uint256 tokenId) public virtual override {
1079         _burn(tokenId, true);
1080     }
1081 }
1082 
1083 pragma solidity ^0.8.16;
1084 contract MonsterTrucks is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1085 string public CONTRACT_URI = "";
1086 mapping(address => uint) public userHasMinted;
1087 bool public REVEALED;
1088 string public UNREVEALED_URI = "";
1089 string public BASE_URI = "";
1090 bool public isPublicMintEnabled = false;
1091 uint public COLLECTION_SIZE = 4444;
1092 uint public MINT_PRICE = 0.0033 ether;
1093 uint public MAX_BATCH_SIZE = 21;
1094 uint public SUPPLY_PER_WALLET = 21;
1095 uint public FREE_SUPPLY_PER_WALLET = 1;
1096 constructor() ERC721A("Monster Trucks Collection", "TRUCK") {}
1097  
1098    function FreeMint(uint quantity)
1099         external
1100         payable
1101         callerIsUser 
1102         nonReentrant
1103     {
1104         uint price;
1105         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1106         if (quantity >= free) {
1107             price = (MINT_PRICE) * (quantity - free);
1108             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1109         } else {
1110             price = 0;
1111             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1112         }
1113 
1114         require(isPublicMintEnabled, "Mint not ready yet!");
1115         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more tokens!");
1116 
1117         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to total mint over limit");
1118 
1119         require(quantity <= MAX_BATCH_SIZE, "Tried to mint over limit, retry with reduced quantity");
1120         require(msg.value >= price, "Must send more eth");
1121 
1122         _safeMint(msg.sender, quantity);
1123 
1124         if (msg.value > price) {
1125             payable(msg.sender).transfer(msg.value - price);
1126         }
1127     }
1128 
1129     function MintViaWhitelist(uint256 quantity, address receiver) public onlyOwner {
1130         require(
1131             totalSupply() + quantity <= COLLECTION_SIZE,
1132             "No more tokens in stock!"
1133         );
1134         
1135         _safeMint(receiver, quantity);
1136     }
1137 
1138     modifier callerIsUser() {
1139         require(tx.origin == msg.sender, "The caller is another contract");
1140         _;
1141     }
1142 
1143     function getPrice(uint quantity) public view returns(uint){
1144         uint price;
1145         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1146         if (quantity >= free) {
1147             price = (MINT_PRICE) * (quantity - free);
1148         } else {
1149             price = 0;
1150         }
1151         return price;
1152     }
1153 
1154     function mint(uint quantity)
1155         external
1156         payable
1157         callerIsUser 
1158         nonReentrant
1159     {
1160         uint price;
1161         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1162         if (quantity >= free) {
1163             price = (MINT_PRICE) * (quantity - free);
1164             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1165         } else {
1166             price = 0;
1167             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1168         }
1169 
1170         require(isPublicMintEnabled, "Mint not ready yet!");
1171         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more tokens!");
1172 
1173         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to total mint over over limit");
1174 
1175         require(quantity <= MAX_BATCH_SIZE, "Tried to mint over limit, retry with reduced quantity");
1176         require(msg.value >= price, "Must send more eth");
1177 
1178         _safeMint(msg.sender, quantity);
1179 
1180         if (msg.value > price) {
1181             payable(msg.sender).transfer(msg.value - price);
1182         }
1183     }
1184     function setPublicMintEnabled() public onlyOwner {
1185         isPublicMintEnabled = !isPublicMintEnabled;
1186     }
1187 
1188     function withdrawFunds() external onlyOwner nonReentrant {
1189         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1190         require(success, "Transfer failed.");
1191     }
1192 
1193     function RevealCollection(bool _revealed, string memory _baseURI) public onlyOwner {
1194         BASE_URI = _baseURI;
1195         REVEALED = _revealed;
1196     }
1197 
1198     function contractURI() public view returns (string memory) {
1199         return CONTRACT_URI;
1200     }
1201 
1202     function setContract(string memory _contractURI) public onlyOwner {
1203         CONTRACT_URI = _contractURI;
1204     }
1205 
1206     function ChangeCollectionSupply(uint256 _new) external onlyOwner {
1207         COLLECTION_SIZE = _new;
1208     }
1209 
1210     function ChangePrice(uint256 _newPrice) external onlyOwner {
1211         MINT_PRICE = _newPrice;
1212     }
1213 
1214     function ChangeFreePerWallet(uint256 _new) external onlyOwner {
1215         FREE_SUPPLY_PER_WALLET = _new;
1216     }
1217 
1218     function ChangeSupplyPerWallet(uint256 _new) external onlyOwner {
1219         SUPPLY_PER_WALLET = _new;
1220     }
1221 
1222     function SetMaxBatchSize(uint256 _new) external onlyOwner {
1223         MAX_BATCH_SIZE = _new;
1224     }
1225 
1226     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1227         super.transferFrom(from, to, tokenId);
1228     }
1229 
1230     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1231         super.safeTransferFrom(from, to, tokenId);
1232     }
1233 
1234     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1235         public payable
1236         override (ERC721A, IERC721A)
1237         onlyAllowedOperator
1238     {
1239         super.safeTransferFrom(from, to, tokenId, data);
1240     }
1241 
1242     function tokenURI(uint256 _tokenId)
1243         public
1244         view
1245         override (ERC721A, IERC721A)
1246         returns (string memory)
1247     {
1248         if (REVEALED) {
1249             return
1250                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1251         } else {
1252             return UNREVEALED_URI;
1253         }
1254     }
1255 
1256 }