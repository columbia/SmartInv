1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 //
6 //
7 // ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄        ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
8 //▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌      ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
9 //▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ 
10 //▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌          
11 //▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌     ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ 
12 //▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌          ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
13 //▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌     ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌      ▀▀▀▀▀▀▀▀▀█░▌
14 //▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌          ▐░▌       ▐░▌     ▐░▌               ▐░▌
15 //▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌      ▄▄▄▄▄▄▄▄▄█░▌
16 //▐░░░░░░░░░░▌ ▐░▌       ▐░▌▐░░░░░░░░░░▌      ▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
17 // ▀▀▀▀▀▀▀▀▀▀   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀        ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀ 
18 //                                                                                                
19 //
20 
21 // Contract developed by Cats
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 pragma solidity ^0.8.0;
34 
35 abstract contract Ownable is Context {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() {
41         _transferOwnership(_msgSender());
42     }
43 
44     modifier onlyOwner() {
45         _checkOwner();
46         _;
47     }
48 
49     function owner() public view virtual returns (address) {
50         return _owner;
51     }
52 
53     function _checkOwner() internal view virtual {
54         require(owner() == _msgSender(), "Ownable: caller is not the owner");
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         _transferOwnership(address(0));
59     }
60 
61 
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         _transferOwnership(newOwner);
65     }
66 
67     function _transferOwnership(address newOwner) internal virtual {
68         address oldOwner = _owner;
69         _owner = newOwner;
70         emit OwnershipTransferred(oldOwner, newOwner);
71     }
72 }
73 
74 pragma solidity ^0.8.0;
75 
76 abstract contract ReentrancyGuard {
77 
78     uint256 private constant _NOT_ENTERED = 1;
79     uint256 private constant _ENTERED = 2;
80 
81     uint256 private _status;
82 
83     constructor() {
84         _status = _NOT_ENTERED;
85     }
86 
87     modifier nonReentrant() {
88         // On the first call to nonReentrant, _notEntered will be true
89         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
90 
91         // Any calls to nonReentrant after this point will fail
92         _status = _ENTERED;
93 
94         _;
95 
96         _status = _NOT_ENTERED;
97     }
98 }
99 
100 pragma solidity ^0.8.0;
101 
102 library Strings {
103     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
104     uint8 private constant _ADDRESS_LENGTH = 20;
105 
106     function toString(uint256 value) internal pure returns (string memory) {
107 
108         if (value == 0) {
109             return "0";
110         }
111         uint256 temp = value;
112         uint256 digits;
113         while (temp != 0) {
114             digits++;
115             temp /= 10;
116         }
117         bytes memory buffer = new bytes(digits);
118         while (value != 0) {
119             digits -= 1;
120             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
121             value /= 10;
122         }
123         return string(buffer);
124     }
125 
126     function toHexString(uint256 value) internal pure returns (string memory) {
127         if (value == 0) {
128             return "0x00";
129         }
130         uint256 temp = value;
131         uint256 length = 0;
132         while (temp != 0) {
133             length++;
134             temp >>= 8;
135         }
136         return toHexString(value, length);
137     }
138 
139     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
140         bytes memory buffer = new bytes(2 * length + 2);
141         buffer[0] = "0";
142         buffer[1] = "x";
143         for (uint256 i = 2 * length + 1; i > 1; --i) {
144             buffer[i] = _HEX_SYMBOLS[value & 0xf];
145             value >>= 4;
146         }
147         require(value == 0, "Strings: hex length insufficient");
148         return string(buffer);
149     }
150 
151     function toHexString(address addr) internal pure returns (string memory) {
152         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
153     }
154 }
155 
156 pragma solidity ^0.8.0;
157 
158 
159 library EnumerableSet {
160 
161 
162     struct Set {
163         // Storage of set values
164         bytes32[] _values;
165 
166         mapping(bytes32 => uint256) _indexes;
167     }
168 
169     function _add(Set storage set, bytes32 value) private returns (bool) {
170         if (!_contains(set, value)) {
171             set._values.push(value);
172 
173             set._indexes[value] = set._values.length;
174             return true;
175         } else {
176             return false;
177         }
178     }
179 
180     function _remove(Set storage set, bytes32 value) private returns (bool) {
181 
182         uint256 valueIndex = set._indexes[value];
183 
184         if (valueIndex != 0) {
185 
186             uint256 toDeleteIndex = valueIndex - 1;
187             uint256 lastIndex = set._values.length - 1;
188 
189             if (lastIndex != toDeleteIndex) {
190                 bytes32 lastValue = set._values[lastIndex];
191 
192                 set._values[toDeleteIndex] = lastValue;
193                 
194                 set._indexes[lastValue] = valueIndex; 
195             }
196 
197             // Delete the slot where the moved value was stored
198             set._values.pop();
199 
200             // Delete the index for the deleted slot
201             delete set._indexes[value];
202 
203             return true;
204         } else {
205             return false;
206         }
207     }
208 
209     function _contains(Set storage set, bytes32 value) private view returns (bool) {
210         return set._indexes[value] != 0;
211     }
212 
213     function _length(Set storage set) private view returns (uint256) {
214         return set._values.length;
215     }
216 
217     function _at(Set storage set, uint256 index) private view returns (bytes32) {
218         return set._values[index];
219     }
220 
221     function _values(Set storage set) private view returns (bytes32[] memory) {
222         return set._values;
223     }
224 
225     struct Bytes32Set {
226         Set _inner;
227     }
228 
229     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
230         return _add(set._inner, value);
231     }
232 
233     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
234         return _remove(set._inner, value);
235     }
236 
237     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
238         return _contains(set._inner, value);
239     }
240 
241     function length(Bytes32Set storage set) internal view returns (uint256) {
242         return _length(set._inner);
243     }
244 
245     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
246         return _at(set._inner, index);
247     }
248 
249     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
250         return _values(set._inner);
251     }
252 
253     struct AddressSet {
254         Set _inner;
255     }
256 
257     function add(AddressSet storage set, address value) internal returns (bool) {
258         return _add(set._inner, bytes32(uint256(uint160(value))));
259     }
260 
261     function remove(AddressSet storage set, address value) internal returns (bool) {
262         return _remove(set._inner, bytes32(uint256(uint160(value))));
263     }
264 
265     function contains(AddressSet storage set, address value) internal view returns (bool) {
266         return _contains(set._inner, bytes32(uint256(uint160(value))));
267     }
268 
269     function length(AddressSet storage set) internal view returns (uint256) {
270         return _length(set._inner);
271     }
272 
273     function at(AddressSet storage set, uint256 index) internal view returns (address) {
274         return address(uint160(uint256(_at(set._inner, index))));
275     }
276 
277     function values(AddressSet storage set) internal view returns (address[] memory) {
278         bytes32[] memory store = _values(set._inner);
279         address[] memory result;
280 
281         assembly {
282             result := store
283         }
284 
285         return result;
286     }
287 
288     struct UintSet {
289         Set _inner;
290     }
291 
292     function add(UintSet storage set, uint256 value) internal returns (bool) {
293         return _add(set._inner, bytes32(value));
294     }
295 
296     function remove(UintSet storage set, uint256 value) internal returns (bool) {
297         return _remove(set._inner, bytes32(value));
298     }
299 
300     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
301         return _contains(set._inner, bytes32(value));
302     }
303 
304     function length(UintSet storage set) internal view returns (uint256) {
305         return _length(set._inner);
306     }
307 
308     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
309         return uint256(_at(set._inner, index));
310     }
311 
312     function values(UintSet storage set) internal view returns (uint256[] memory) {
313         bytes32[] memory store = _values(set._inner);
314         uint256[] memory result;
315 
316         /// @solidity memory-safe-assembly
317         assembly {
318             result := store
319         }
320 
321         return result;
322     }
323 }
324 
325 pragma solidity ^0.8.4;
326 
327 interface IERC721A {
328 
329     error ApprovalCallerNotOwnerNorApproved();
330 
331     error ApprovalQueryForNonexistentToken();
332 
333     error BalanceQueryForZeroAddress();
334 
335     error MintToZeroAddress();
336 
337     error MintZeroQuantity();
338 
339     error OwnerQueryForNonexistentToken();
340 
341     error TransferCallerNotOwnerNorApproved();
342 
343     error TransferFromIncorrectOwner();
344 
345     error TransferToNonERC721ReceiverImplementer();
346 
347     error TransferToZeroAddress();
348 
349     error URIQueryForNonexistentToken();
350 
351     error MintERC2309QuantityExceedsLimit();
352 
353     error OwnershipNotInitializedForExtraData();
354 
355     struct TokenOwnership {
356 
357         address addr;
358 
359         uint64 startTimestamp;
360 
361         bool burned;
362 
363         uint24 extraData;
364     }
365 
366     function totalSupply() external view returns (uint256);
367 
368     function supportsInterface(bytes4 interfaceId) external view returns (bool);
369 
370     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
371 
372     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
373 
374     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
375 
376     function balanceOf(address owner) external view returns (uint256 balance);
377 
378     function ownerOf(uint256 tokenId) external view returns (address owner);
379 
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 tokenId,
384         bytes calldata data
385     ) external payable;
386 
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) external payable;
392 
393     function transferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) external payable;
398 
399     function approve(address to, uint256 tokenId) external payable;
400 
401     function setApprovalForAll(address operator, bool _approved) external;
402 
403     function getApproved(uint256 tokenId) external view returns (address operator);
404 
405     function isApprovedForAll(address owner, address operator) external view returns (bool);
406 
407     function name() external view returns (string memory);
408 
409     function symbol() external view returns (string memory);
410 
411     function tokenURI(uint256 tokenId) external view returns (string memory);
412 
413     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
414 }
415 
416 pragma solidity ^0.8.4;
417 
418 interface ERC721A__IERC721Receiver {
419     function onERC721Received(
420         address operator,
421         address from,
422         uint256 tokenId,
423         bytes calldata data
424     ) external returns (bytes4);
425 }
426 
427 contract ERC721A is IERC721A {
428 
429     struct TokenApprovalRef {
430         address value;
431     }
432 
433     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
434 
435     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
436 
437     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
438 
439     uint256 private constant _BITPOS_AUX = 192;
440 
441     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
442 
443     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
444 
445     uint256 private constant _BITMASK_BURNED = 1 << 224;
446 
447     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
448 
449     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
450 
451     uint256 private constant _BITPOS_EXTRA_DATA = 232;
452 
453     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
454 
455     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
456 
457     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
458 
459     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
460         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
461 
462     uint256 private _currentIndex;
463 
464     uint256 private _burnCounter;
465 
466     string private _name;
467 
468     string private _symbol;
469 
470     mapping(uint256 => uint256) private _packedOwnerships;
471 
472     mapping(address => uint256) private _packedAddressData;
473 
474     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
475 
476     mapping(address => mapping(address => bool)) private _operatorApprovals;
477 
478     constructor(string memory name_, string memory symbol_) {
479         _name = name_;
480         _symbol = symbol_;
481         _currentIndex = _startTokenId();
482     }
483 
484     function _startTokenId() internal view virtual returns (uint256) {
485         return 0;
486     }
487 
488     function _nextTokenId() internal view virtual returns (uint256) {
489         return _currentIndex;
490     }
491 
492     function totalSupply() public view virtual override returns (uint256) {
493 
494         unchecked {
495             return _currentIndex - _burnCounter - _startTokenId();
496         }
497     }
498 
499     function _totalMinted() internal view virtual returns (uint256) {
500 
501         unchecked {
502             return _currentIndex - _startTokenId();
503         }
504     }
505 
506     function _totalBurned() internal view virtual returns (uint256) {
507         return _burnCounter;
508     }
509 
510     function balanceOf(address owner) public view virtual override returns (uint256) {
511         if (owner == address(0)) revert BalanceQueryForZeroAddress();
512         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
513     }
514 
515     function _numberMinted(address owner) internal view returns (uint256) {
516         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
517     }
518 
519     function _numberBurned(address owner) internal view returns (uint256) {
520         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
521     }
522 
523     function _getAux(address owner) internal view returns (uint64) {
524         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
525     }
526 
527     function _setAux(address owner, uint64 aux) internal virtual {
528         uint256 packed = _packedAddressData[owner];
529         uint256 auxCasted;
530         // Cast `aux` with assembly to avoid redundant masking.
531         assembly {
532             auxCasted := aux
533         }
534         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
535         _packedAddressData[owner] = packed;
536     }
537 
538 
539     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540 
541         return
542             interfaceId == 0x01ffc9a7 || 
543             interfaceId == 0x80ac58cd || 
544             interfaceId == 0x5b5e139f; 
545     }
546 
547     function name() public view virtual override returns (string memory) {
548         return _name;
549     }
550 
551     function symbol() public view virtual override returns (string memory) {
552         return _symbol;
553     }
554 
555     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
556         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
557 
558         string memory baseURI = _baseURI();
559         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
560     }
561 
562     function _baseURI() internal view virtual returns (string memory) {
563         return '';
564     }
565 
566     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
567         return address(uint160(_packedOwnershipOf(tokenId)));
568     }
569 
570     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
571         return _unpackedOwnership(_packedOwnershipOf(tokenId));
572     }
573 
574     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
575         return _unpackedOwnership(_packedOwnerships[index]);
576     }
577 
578     function _initializeOwnershipAt(uint256 index) internal virtual {
579         if (_packedOwnerships[index] == 0) {
580             _packedOwnerships[index] = _packedOwnershipOf(index);
581         }
582     }
583 
584     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
585         uint256 curr = tokenId;
586 
587         unchecked {
588             if (_startTokenId() <= curr)
589                 if (curr < _currentIndex) {
590                     uint256 packed = _packedOwnerships[curr];
591 
592                     if (packed & _BITMASK_BURNED == 0) {
593 
594                         while (packed == 0) {
595                             packed = _packedOwnerships[--curr];
596                         }
597                         return packed;
598                     }
599                 }
600         }
601         revert OwnerQueryForNonexistentToken();
602     }
603 
604     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
605         ownership.addr = address(uint160(packed));
606         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
607         ownership.burned = packed & _BITMASK_BURNED != 0;
608         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
609     }
610 
611     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
612         assembly {
613             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
614             owner := and(owner, _BITMASK_ADDRESS)
615             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
616             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
617         }
618     }
619 
620     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
621         // For branchless setting of the `nextInitialized` flag.
622         assembly {
623             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
624             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
625         }
626     }
627 
628     function approve(address to, uint256 tokenId) public payable virtual override {
629         address owner = ownerOf(tokenId);
630 
631         if (_msgSenderERC721A() != owner)
632             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
633                 revert ApprovalCallerNotOwnerNorApproved();
634             }
635 
636         _tokenApprovals[tokenId].value = to;
637         emit Approval(owner, to, tokenId);
638     }
639 
640     function getApproved(uint256 tokenId) public view virtual override returns (address) {
641         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
642 
643         return _tokenApprovals[tokenId].value;
644     }
645 
646     function setApprovalForAll(address operator, bool approved) public virtual override {
647         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
648         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
649     }
650 
651     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
652         return _operatorApprovals[owner][operator];
653     }
654 
655     function _exists(uint256 tokenId) internal view virtual returns (bool) {
656         return
657             _startTokenId() <= tokenId &&
658             tokenId < _currentIndex && // If within bounds,
659             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
660     }
661 
662     function _isSenderApprovedOrOwner(
663         address approvedAddress,
664         address owner,
665         address msgSender
666     ) private pure returns (bool result) {
667         assembly {
668 
669             owner := and(owner, _BITMASK_ADDRESS)
670 
671             msgSender := and(msgSender, _BITMASK_ADDRESS)
672 
673             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
674         }
675     }
676 
677     function _getApprovedSlotAndAddress(uint256 tokenId)
678         private
679         view
680         returns (uint256 approvedAddressSlot, address approvedAddress)
681     {
682         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
683 
684         assembly {
685             approvedAddressSlot := tokenApproval.slot
686             approvedAddress := sload(approvedAddressSlot)
687         }
688     }
689 
690     function transferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) public payable virtual override {
695         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
696 
697         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
698 
699         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
700 
701         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
702             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
703 
704         if (to == address(0)) revert TransferToZeroAddress();
705 
706         _beforeTokenTransfers(from, to, tokenId, 1);
707 
708         assembly {
709             if approvedAddress {
710 
711                 sstore(approvedAddressSlot, 0)
712             }
713         }
714 
715         unchecked {
716 
717             --_packedAddressData[from]; 
718             ++_packedAddressData[to]; 
719 
720             _packedOwnerships[tokenId] = _packOwnershipData(
721                 to,
722                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
723             );
724 
725             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
726                 uint256 nextTokenId = tokenId + 1;
727 
728                 if (_packedOwnerships[nextTokenId] == 0) {
729 
730                     if (nextTokenId != _currentIndex) {
731 
732                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
733                     }
734                 }
735             }
736         }
737 
738         emit Transfer(from, to, tokenId);
739         _afterTokenTransfers(from, to, tokenId, 1);
740     }
741 
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) public payable virtual override {
747         safeTransferFrom(from, to, tokenId, '');
748     }
749 
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) public payable virtual override {
756         transferFrom(from, to, tokenId);
757         if (to.code.length != 0)
758             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
759                 revert TransferToNonERC721ReceiverImplementer();
760             }
761     }
762 
763     function _beforeTokenTransfers(
764         address from,
765         address to,
766         uint256 startTokenId,
767         uint256 quantity
768     ) internal virtual {}
769 
770     function _afterTokenTransfers(
771         address from,
772         address to,
773         uint256 startTokenId,
774         uint256 quantity
775     ) internal virtual {}
776 
777     function _checkContractOnERC721Received(
778         address from,
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) private returns (bool) {
783         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
784             bytes4 retval
785         ) {
786             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
787         } catch (bytes memory reason) {
788             if (reason.length == 0) {
789                 revert TransferToNonERC721ReceiverImplementer();
790             } else {
791                 assembly {
792                     revert(add(32, reason), mload(reason))
793                 }
794             }
795         }
796     }
797 
798     function _mint(address to, uint256 quantity) internal virtual {
799         uint256 startTokenId = _currentIndex;
800         if (quantity == 0) revert MintZeroQuantity();
801 
802         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
803 
804         unchecked {
805 
806             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
807 
808             _packedOwnerships[startTokenId] = _packOwnershipData(
809                 to,
810                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
811             );
812 
813             uint256 toMasked;
814             uint256 end = startTokenId + quantity;
815 
816             assembly {
817 
818                 toMasked := and(to, _BITMASK_ADDRESS)
819 
820                 log4(
821                     0, 
822                     0, 
823                     _TRANSFER_EVENT_SIGNATURE, 
824                     0, 
825                     toMasked, 
826                     startTokenId 
827                 )
828 
829                 for {
830                     let tokenId := add(startTokenId, 1)
831                 } iszero(eq(tokenId, end)) {
832                     tokenId := add(tokenId, 1)
833                 } {
834 
835                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
836                 }
837             }
838             if (toMasked == 0) revert MintToZeroAddress();
839 
840             _currentIndex = end;
841         }
842         _afterTokenTransfers(address(0), to, startTokenId, quantity);
843     }
844 
845     function _mintERC2309(address to, uint256 quantity) internal virtual {
846         uint256 startTokenId = _currentIndex;
847         if (to == address(0)) revert MintToZeroAddress();
848         if (quantity == 0) revert MintZeroQuantity();
849         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
850 
851         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
852 
853         unchecked {
854 
855             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
856 
857             _packedOwnerships[startTokenId] = _packOwnershipData(
858                 to,
859                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
860             );
861 
862             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
863 
864             _currentIndex = startTokenId + quantity;
865         }
866         _afterTokenTransfers(address(0), to, startTokenId, quantity);
867     }
868 
869     function _safeMint(
870         address to,
871         uint256 quantity,
872         bytes memory _data
873     ) internal virtual {
874         _mint(to, quantity);
875 
876         unchecked {
877             if (to.code.length != 0) {
878                 uint256 end = _currentIndex;
879                 uint256 index = end - quantity;
880                 do {
881                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
882                         revert TransferToNonERC721ReceiverImplementer();
883                     }
884                 } while (index < end);
885                 // Reentrancy protection.
886                 if (_currentIndex != end) revert();
887             }
888         }
889     }
890 
891     function _safeMint(address to, uint256 quantity) internal virtual {
892         _safeMint(to, quantity, '');
893     }
894 
895     function _burn(uint256 tokenId) internal virtual {
896         _burn(tokenId, false);
897     }
898 
899     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
900         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
901 
902         address from = address(uint160(prevOwnershipPacked));
903 
904         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
905 
906         if (approvalCheck) {
907             
908             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
909                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
910         }
911 
912         _beforeTokenTransfers(from, address(0), tokenId, 1);
913 
914         assembly {
915             if approvedAddress {
916                 
917                 sstore(approvedAddressSlot, 0)
918             }
919         }
920 
921         unchecked {
922 
923             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
924 
925             _packedOwnerships[tokenId] = _packOwnershipData(
926                 from,
927                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
928             );
929 
930             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
931                 uint256 nextTokenId = tokenId + 1;
932 
933                 if (_packedOwnerships[nextTokenId] == 0) {
934 
935                     if (nextTokenId != _currentIndex) {
936 
937                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
938                     }
939                 }
940             }
941         }
942 
943         emit Transfer(from, address(0), tokenId);
944         _afterTokenTransfers(from, address(0), tokenId, 1);
945 
946         unchecked {
947             _burnCounter++;
948         }
949     }
950 
951     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
952         uint256 packed = _packedOwnerships[index];
953         if (packed == 0) revert OwnershipNotInitializedForExtraData();
954         uint256 extraDataCasted;
955         assembly {
956             extraDataCasted := extraData
957         }
958         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
959         _packedOwnerships[index] = packed;
960     }
961 
962     function _extraData(
963         address from,
964         address to,
965         uint24 previousExtraData
966     ) internal view virtual returns (uint24) {}
967 
968     function _nextExtraData(
969         address from,
970         address to,
971         uint256 prevOwnershipPacked
972     ) private view returns (uint256) {
973         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
974         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
975     }
976 
977     function _msgSenderERC721A() internal view virtual returns (address) {
978         return msg.sender;
979     }
980 
981     function _toString(uint256 value) internal pure virtual returns (string memory str) {
982         assembly {
983 
984             let m := add(mload(0x40), 0xa0)
985 
986             mstore(0x40, m)
987 
988             str := sub(m, 0x20)
989 
990             mstore(str, 0)
991 
992             let end := str
993 
994             for { let temp := value } 1 {} {
995                 str := sub(str, 1)
996 
997                 mstore8(str, add(48, mod(temp, 10)))
998 
999                 temp := div(temp, 10)
1000 
1001                 if iszero(temp) { break }
1002             }
1003 
1004             let length := sub(end, str)
1005 
1006             str := sub(str, 0x20)
1007 
1008             mstore(str, length)
1009         }
1010     }
1011 }
1012 
1013 pragma solidity ^0.8.13;
1014 
1015 contract OperatorFilterer {
1016     error OperatorNotAllowed(address operator);
1017 
1018     IOperatorFilterRegistry constant operatorFilterRegistry =
1019         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1020 
1021     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1022 
1023         if (address(operatorFilterRegistry).code.length > 0) {
1024             if (subscribe) {
1025                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1026             } else {
1027                 if (subscriptionOrRegistrantToCopy != address(0)) {
1028                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1029                 } else {
1030                     operatorFilterRegistry.register(address(this));
1031                 }
1032             }
1033         }
1034     }
1035 
1036     modifier onlyAllowedOperator() virtual {
1037 
1038         if (address(operatorFilterRegistry).code.length > 0) {
1039             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1040                 revert OperatorNotAllowed(msg.sender);
1041             }
1042         }
1043         _;
1044     }
1045 }
1046 
1047 pragma solidity ^0.8.13;
1048 
1049 contract DefaultOperatorFilterer is OperatorFilterer {
1050     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1051 
1052     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1053 }
1054 
1055 pragma solidity ^0.8.13;
1056 
1057 interface IOperatorFilterRegistry {
1058     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1059     function register(address registrant) external;
1060     function registerAndSubscribe(address registrant, address subscription) external;
1061     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1062     function updateOperator(address registrant, address operator, bool filtered) external;
1063     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1064     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1065     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1066     function subscribe(address registrant, address registrantToSubscribe) external;
1067     function unsubscribe(address registrant, bool copyExistingEntries) external;
1068     function subscriptionOf(address addr) external returns (address registrant);
1069     function subscribers(address registrant) external returns (address[] memory);
1070     function subscriberAt(address registrant, uint256 index) external returns (address);
1071     function copyEntriesOf(address registrant, address registrantToCopy) external;
1072     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1073     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1074     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1075     function filteredOperators(address addr) external returns (address[] memory);
1076     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1077     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1078     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1079     function isRegistered(address addr) external returns (bool);
1080     function codeHashOf(address addr) external returns (bytes32);
1081 }
1082 
1083 pragma solidity ^0.8.4;
1084 
1085 interface IERC721ABurnable is IERC721A {
1086 
1087     function burn(uint256 tokenId) external;
1088 }
1089 
1090 pragma solidity ^0.8.4;
1091 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1092     function burn(uint256 tokenId) public virtual override {
1093         _burn(tokenId, true);
1094     }
1095 }
1096 
1097 pragma solidity ^0.8.16;
1098 contract BadCatsGang is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1099 
1100 string public CONTRACT_URI = "https://opensea.badcatsgang.club/";
1101     mapping(address => uint) public userHasMinted;
1102     bool public REVEALED;
1103     string public UNREVEALED_URI = "https://opensea.badcatsgang.club/";
1104     string public BASE_URI = "https://opensea.badcatsgang.club/";
1105     bool public isPublicMintEnabled = false;
1106     uint public COLLECTION_SIZE = 4444;
1107     uint public MINT_PRICE = 0.00165 ether;
1108     uint public MAX_BATCH_SIZE = 21;
1109     uint public SUPPLY_PER_WALLET = 21;
1110     uint public FREE_SUPPLY_PER_WALLET = 1;
1111 
1112     constructor() ERC721A("Bad Cats Gang", "BCG") {}
1113     function FreeMintVip(uint256 quantity, address receiver) public onlyOwner {
1114         require(
1115             totalSupply() + quantity <= COLLECTION_SIZE,
1116             "No more Cats in stock!"
1117         );
1118         
1119         _safeMint(receiver, quantity);
1120     }
1121 
1122     modifier callerIsUser() {
1123         require(tx.origin == msg.sender, "The caller is another contract");
1124         _;
1125     }
1126 
1127     function getPrice(uint quantity) public view returns(uint){
1128         uint price;
1129         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1130         if (quantity >= free) {
1131             price = (MINT_PRICE) * (quantity - free);
1132         } else {
1133             price = 0;
1134         }
1135         return price;
1136     }
1137 
1138     function mint(uint quantity)
1139         external
1140         payable
1141         callerIsUser 
1142         nonReentrant
1143     {
1144         uint price;
1145         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1146         if (quantity >= free) {
1147             price = (MINT_PRICE) * (quantity - free);
1148             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1149         } else {
1150             price = 0;
1151             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1152         }
1153 
1154         require(isPublicMintEnabled, "Cats not ready yet!");
1155         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more Bad Cats!");
1156 
1157         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to total mint quanity per wallet over limit");
1158 
1159         require(quantity <= MAX_BATCH_SIZE, "Tried to mint quanity over limit, retry with reduced quantity");
1160         require(msg.value >= price, "Must send enough eth to adopt cat");
1161 
1162         _safeMint(msg.sender, quantity);
1163 
1164         if (msg.value > price) {
1165             payable(msg.sender).transfer(msg.value - price);
1166         }
1167     }
1168 
1169     function withdrawFunds() external onlyOwner nonReentrant {
1170         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1171         require(success, "Transfer failed.");
1172     }
1173 
1174     function setPublicMintEnabled() public onlyOwner {
1175         isPublicMintEnabled = !isPublicMintEnabled;
1176     }
1177 
1178     function setBaseURI(bool _revealed, string memory _baseURI) public onlyOwner {
1179         BASE_URI = _baseURI;
1180         REVEALED = _revealed;
1181     }
1182 
1183     function contractURI() public view returns (string memory) {
1184         return CONTRACT_URI;
1185     }
1186 
1187     function setContractURI(string memory _contractURI) public onlyOwner {
1188         CONTRACT_URI = _contractURI;
1189     }
1190 
1191     function set_COLLECTION_SIZE(uint256 _new) external onlyOwner {
1192         COLLECTION_SIZE = _new;
1193     }
1194 
1195     function setPrice(uint256 _newPrice) external onlyOwner {
1196         MINT_PRICE = _newPrice;
1197     }
1198 
1199     function set_FREE_SUPPLY_PER_WALLET(uint256 _new) external onlyOwner {
1200         FREE_SUPPLY_PER_WALLET = _new;
1201     }
1202 
1203     function set_SUPPLY_PER_WALLET(uint256 _new) external onlyOwner {
1204         SUPPLY_PER_WALLET = _new;
1205     }
1206 
1207     function set_MAX_BATCH_SIZE(uint256 _new) external onlyOwner {
1208         MAX_BATCH_SIZE = _new;
1209     }
1210 
1211     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1212         super.transferFrom(from, to, tokenId);
1213     }
1214 
1215     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1216         super.safeTransferFrom(from, to, tokenId);
1217     }
1218 
1219     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1220         public payable
1221         override (ERC721A, IERC721A)
1222         onlyAllowedOperator
1223     {
1224         super.safeTransferFrom(from, to, tokenId, data);
1225     }
1226 
1227     function tokenURI(uint256 _tokenId)
1228         public
1229         view
1230         override (ERC721A, IERC721A)
1231         returns (string memory)
1232     {
1233         if (REVEALED) {
1234             return
1235                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1236         } else {
1237             return UNREVEALED_URI;
1238         }
1239     }
1240 
1241 }