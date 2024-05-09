1 // SPDX-License-Identifier: MIT  
2 /**
3 ..................................................
4 ..................................................
5 .................*%%%%@@@@@*......................
6 ...............#*+++++++++++*%....................
7 .............:%++++++++++++++++@+.................
8 ............#*+++++++++++++++++++#:...............
9 ...........*+++++++++++++++++++++++*..............
10 ..........=+++++++++++++++++++++++++#.............
11 ..........++++++++++++++++++++++++++#.............
12 .........%+++++**++++#+++++++++***#*+:............
13 .........++++++++++++++++++++++++++++=............
14 ........+++++*+++++++++*++++*+++++++#+............
15 ........#+++#++++*@@@@@#+#++*+++++**+@............
16 ........%+++*++##@@@@  #*#+++++@@#  ##............
17 ........%+++++@.#@@@@.  :%++++=#@@@  @............
18 ........#++++#  =@@@@    *++++=%@@@  @............
19 ........*++#+    =@@+  -*+++++++#%. =#............
20 ........%+##+#++*####*++++++++++###*+@............
21 ........%++++++++++++++*#+++++++++++#%............
22 ........%++++++++++++++++++++++++++++#............
23 ........*++++++++++++++++++++++++++++*............
24 .......:*+++++++++++++++++++++++++++++-...........
25 ........#++++++#+++#%#***%%%%%%%%%%#++%...........
26 ........@+++++*+%#**************+****%+...........
27 ........+++++++#*********************+@=..........
28 .........+++++@************************#..........
29 .........*++#+#******+*********+**#****#..........
30 .........#++*+#*****+*#%%######*********..........
31 .........#++++@************************%..........
32 .........*+++++#*********************+##..........
33 .........=++++++%********************%+#..........
34 .........-++++++++%*++*************%#++#..........
35 .........-+++++++++++#%#*+++***#@%*++++-..........
36 .........-++++++++++++++++++++++++++++%...........
37 .........-+++++++++++++++++++++++++++@............
38 .........=+++++++++++++++++++++++++++@............
39 ......=%##+++++++++++++++++++++++++++%............
40 .....-####++++++++++++++++++++++++++++............
41 .....%####+++++++++++++++++++++++++++:............
42 .....#####%+++++++++++++++++++++++++#%............
43 .....######%++++++++++++++++++++#+++%#%...........
44 .....########*++++++++++++*###*+++*%###%..........
45 .....##########%*+++++++++++**++#%######+.........
46 .....########%#####%#####################-........
47 .....%######################%%%%%%%%%%####:.......
48 .....*###########%%%#####%##########%#####%.......
49 .....+%######*#*+++++%#%##########%########%......
50 ......#%#####++#++**#%###########%##########@.....
51 ......%#%###*#++%###############%###########%.....
52 ......@#####################################+.....
53 */
54 
55 pragma solidity ^0.8.0;
56 abstract contract Context {
57 function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view virtual returns (bytes calldata) {
62         return msg.data;
63     }
64 }
65 
66 pragma solidity ^0.8.0;
67 abstract contract Ownable is Context {
68 address private _owner;
69 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71 constructor() {
72         _transferOwnership(_msgSender());
73     }
74 
75     modifier onlyOwner() {
76         _checkOwner();
77         _;
78     }
79 
80     function owner() public view virtual returns (address) {
81         return _owner;
82     }
83 
84     function _checkOwner() internal view virtual {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92 
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 pragma solidity ^0.8.0;
106 
107 abstract contract ReentrancyGuard {
108 
109     uint256 private constant _NOT_ENTERED = 1;
110     uint256 private constant _ENTERED = 2;
111 
112     uint256 private _status;
113 
114     constructor() {
115         _status = _NOT_ENTERED;
116     }
117 
118     modifier nonReentrant() {
119         
120         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
121 
122         _status = _ENTERED;
123 
124         _;
125 
126         _status = _NOT_ENTERED;
127     }
128 }
129 
130 pragma solidity ^0.8.0;
131 
132 library Strings {
133     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
134     uint8 private constant _ADDRESS_LENGTH = 20;
135 
136     function toString(uint256 value) internal pure returns (string memory) {
137 
138         if (value == 0) {
139             return "0";
140         }
141         uint256 temp = value;
142         uint256 digits;
143         while (temp != 0) {
144             digits++;
145             temp /= 10;
146         }
147         bytes memory buffer = new bytes(digits);
148         while (value != 0) {
149             digits -= 1;
150             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
151             value /= 10;
152         }
153         return string(buffer);
154     }
155 
156     function toHexString(uint256 value) internal pure returns (string memory) {
157         if (value == 0) {
158             return "0x00";
159         }
160         uint256 temp = value;
161         uint256 length = 0;
162         while (temp != 0) {
163             length++;
164             temp >>= 8;
165         }
166         return toHexString(value, length);
167     }
168 
169     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
170         bytes memory buffer = new bytes(2 * length + 2);
171         buffer[0] = "0";
172         buffer[1] = "x";
173         for (uint256 i = 2 * length + 1; i > 1; --i) {
174             buffer[i] = _HEX_SYMBOLS[value & 0xf];
175             value >>= 4;
176         }
177         require(value == 0, "Strings: hex length insufficient");
178         return string(buffer);
179     }
180 
181     function toHexString(address addr) internal pure returns (string memory) {
182         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
183     }
184 }
185 
186 pragma solidity ^0.8.0;
187 
188 
189 library EnumerableSet {
190 
191 
192     struct Set {
193         // Storage of set values
194         bytes32[] _values;
195 
196         mapping(bytes32 => uint256) _indexes;
197     }
198 
199     function _add(Set storage set, bytes32 value) private returns (bool) {
200         if (!_contains(set, value)) {
201             set._values.push(value);
202 
203             set._indexes[value] = set._values.length;
204             return true;
205         } else {
206             return false;
207         }
208     }
209 
210     function _remove(Set storage set, bytes32 value) private returns (bool) {
211 
212         uint256 valueIndex = set._indexes[value];
213 
214         if (valueIndex != 0) {
215 
216             uint256 toDeleteIndex = valueIndex - 1;
217             uint256 lastIndex = set._values.length - 1;
218 
219             if (lastIndex != toDeleteIndex) {
220                 bytes32 lastValue = set._values[lastIndex];
221 
222                 set._values[toDeleteIndex] = lastValue;
223                 
224                 set._indexes[lastValue] = valueIndex; 
225             }
226 
227             set._values.pop();
228 
229             delete set._indexes[value];
230 
231             return true;
232         } else {
233             return false;
234         }
235     }
236 
237     function _contains(Set storage set, bytes32 value) private view returns (bool) {
238         return set._indexes[value] != 0;
239     }
240 
241     function _length(Set storage set) private view returns (uint256) {
242         return set._values.length;
243     }
244 
245     function _at(Set storage set, uint256 index) private view returns (bytes32) {
246         return set._values[index];
247     }
248 
249     function _values(Set storage set) private view returns (bytes32[] memory) {
250         return set._values;
251     }
252 
253     struct Bytes32Set {
254         Set _inner;
255     }
256 
257     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
258         return _add(set._inner, value);
259     }
260 
261     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
262         return _remove(set._inner, value);
263     }
264 
265     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
266         return _contains(set._inner, value);
267     }
268 
269     function length(Bytes32Set storage set) internal view returns (uint256) {
270         return _length(set._inner);
271     }
272 
273     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
274         return _at(set._inner, index);
275     }
276 
277     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
278         return _values(set._inner);
279     }
280 
281     struct AddressSet {
282         Set _inner;
283     }
284 
285     function add(AddressSet storage set, address value) internal returns (bool) {
286         return _add(set._inner, bytes32(uint256(uint160(value))));
287     }
288 
289     function remove(AddressSet storage set, address value) internal returns (bool) {
290         return _remove(set._inner, bytes32(uint256(uint160(value))));
291     }
292 
293     function contains(AddressSet storage set, address value) internal view returns (bool) {
294         return _contains(set._inner, bytes32(uint256(uint160(value))));
295     }
296 
297     function length(AddressSet storage set) internal view returns (uint256) {
298         return _length(set._inner);
299     }
300 
301     function at(AddressSet storage set, uint256 index) internal view returns (address) {
302         return address(uint160(uint256(_at(set._inner, index))));
303     }
304 
305     function values(AddressSet storage set) internal view returns (address[] memory) {
306         bytes32[] memory store = _values(set._inner);
307         address[] memory result;
308 
309         assembly {
310             result := store
311         }
312 
313         return result;
314     }
315 
316     struct UintSet {
317         Set _inner;
318     }
319 
320     function add(UintSet storage set, uint256 value) internal returns (bool) {
321         return _add(set._inner, bytes32(value));
322     }
323 
324     function remove(UintSet storage set, uint256 value) internal returns (bool) {
325         return _remove(set._inner, bytes32(value));
326     }
327 
328     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
329         return _contains(set._inner, bytes32(value));
330     }
331 
332     function length(UintSet storage set) internal view returns (uint256) {
333         return _length(set._inner);
334     }
335 
336     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
337         return uint256(_at(set._inner, index));
338     }
339 
340     function values(UintSet storage set) internal view returns (uint256[] memory) {
341         bytes32[] memory store = _values(set._inner);
342         uint256[] memory result;
343 
344         /// @solidity memory-safe-assembly
345         assembly {
346             result := store
347         }
348 
349         return result;
350     }
351 }
352 
353 pragma solidity ^0.8.4;
354 
355 interface IERC721A {
356 error ApprovalCallerNotOwnerNorApproved();
357 error ApprovalQueryForNonexistentToken();
358 error BalanceQueryForZeroAddress();
359 error MintToZeroAddress();
360 error MintZeroQuantity();
361 error OwnerQueryForNonexistentToken();
362 error TransferCallerNotOwnerNorApproved();
363 error TransferFromIncorrectOwner();
364 error TransferToNonERC721ReceiverImplementer();
365 error TransferToZeroAddress();
366 error URIQueryForNonexistentToken();
367 error MintERC2309QuantityExceedsLimit();
368 error OwnershipNotInitializedForExtraData();
369 
370     struct TokenOwnership {
371 
372         address addr;
373 
374         uint64 startTimestamp;
375 
376         bool burned;
377 
378         uint24 extraData;
379     }
380 
381 function totalSupply() external view returns (uint256);
382 function supportsInterface(bytes4 interfaceId) external view returns (bool);
383 event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
384 event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
385 event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
386 function balanceOf(address owner) external view returns (uint256 balance);
387 function ownerOf(uint256 tokenId) external view returns (address owner);
388 
389     function safeTransferFrom(
390         address from,
391         address to,
392         uint256 tokenId,
393         bytes calldata data
394     ) external payable;
395 
396     function safeTransferFrom(
397         address from,
398         address to,
399         uint256 tokenId
400     ) external payable;
401 
402     function transferFrom(
403         address from,
404         address to,
405         uint256 tokenId
406     ) external payable;
407 
408     function approve(address to, uint256 tokenId) external payable;
409 
410     function setApprovalForAll(address operator, bool _approved) external;
411 
412     function getApproved(uint256 tokenId) external view returns (address operator);
413 
414     function isApprovedForAll(address owner, address operator) external view returns (bool);
415 
416     function name() external view returns (string memory);
417 
418     function symbol() external view returns (string memory);
419 
420     function tokenURI(uint256 tokenId) external view returns (string memory);
421 
422     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
423 }
424 
425 pragma solidity ^0.8.4;
426 
427 interface ERC721A__IERC721Receiver {
428     function onERC721Received(
429         address operator,
430         address from,
431         uint256 tokenId,
432         bytes calldata data
433     ) external returns (bytes4);
434 }
435 
436 contract ERC721A is IERC721A {
437 
438     struct TokenApprovalRef {
439         address value;
440     }
441 
442     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
443     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
444     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
445     uint256 private constant _BITPOS_AUX = 192;
446     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
447     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
448     uint256 private constant _BITMASK_BURNED = 1 << 224;
449     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
450     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
451     uint256 private constant _BITPOS_EXTRA_DATA = 232;
452     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
453     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
454     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
455     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
456     0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
457 uint256 private _currentIndex;
458 uint256 private _burnCounter;
459 string private _name;
460 string private _symbol;
461 mapping(uint256 => uint256) private _packedOwnerships;
462 mapping(address => uint256) private _packedAddressData;
463 mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
464 mapping(address => mapping(address => bool)) private _operatorApprovals;
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
545 string memory baseURI = _baseURI();
546 return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
547     }
548 
549     function _baseURI() internal view virtual returns (string memory) {
550         return '';
551     }
552 
553     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
554         return address(uint160(_packedOwnershipOf(tokenId)));
555     }
556 
557     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
558         return _unpackedOwnership(_packedOwnershipOf(tokenId));
559     }
560 
561     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
562         return _unpackedOwnership(_packedOwnerships[index]);
563     }
564 
565     function _initializeOwnershipAt(uint256 index) internal virtual {
566         if (_packedOwnerships[index] == 0) {
567             _packedOwnerships[index] = _packedOwnershipOf(index);
568         }
569     }
570 
571     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
572         uint256 curr = tokenId;
573 
574         unchecked {
575             if (_startTokenId() <= curr)
576                 if (curr < _currentIndex) {
577                     uint256 packed = _packedOwnerships[curr];
578 
579                     if (packed & _BITMASK_BURNED == 0) {
580 
581                         while (packed == 0) {
582                             packed = _packedOwnerships[--curr];
583                         }
584                         return packed;
585                     }
586                 }
587         }
588         revert OwnerQueryForNonexistentToken();
589     }
590 
591     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
592         ownership.addr = address(uint160(packed));
593         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
594         ownership.burned = packed & _BITMASK_BURNED != 0;
595         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
596     }
597 
598     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
599         assembly {
600 owner := and(owner, _BITMASK_ADDRESS)
601 result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
602         }
603     }
604 
605     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
606 
607         assembly {
608 
609             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
610         }
611     }
612 
613     function approve(address to, uint256 tokenId) public payable virtual override {
614         address owner = ownerOf(tokenId);
615 
616         if (_msgSenderERC721A() != owner)
617             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
618                 revert ApprovalCallerNotOwnerNorApproved();
619             }
620 
621         _tokenApprovals[tokenId].value = to;
622         emit Approval(owner, to, tokenId);
623     }
624 
625     function getApproved(uint256 tokenId) public view virtual override returns (address) {
626         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
627 
628         return _tokenApprovals[tokenId].value;
629     }
630 
631     function setApprovalForAll(address operator, bool approved) public virtual override {
632         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
633         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
634     }
635 
636     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
637         return _operatorApprovals[owner][operator];
638     }
639 
640     function _exists(uint256 tokenId) internal view virtual returns (bool) {
641         return
642             _startTokenId() <= tokenId &&
643             tokenId < _currentIndex && 
644             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0;
645     }
646 
647     function _isSenderApprovedOrOwner(
648         address approvedAddress,
649         address owner,
650         address msgSender
651     ) private pure returns (bool result) {
652         assembly {
653 
654             owner := and(owner, _BITMASK_ADDRESS)
655 
656             msgSender := and(msgSender, _BITMASK_ADDRESS)
657 
658             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
659         }
660     }
661 
662     function _getApprovedSlotAndAddress(uint256 tokenId)
663         private
664         view
665         returns (uint256 approvedAddressSlot, address approvedAddress)
666     {
667         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
668 
669         assembly {
670             approvedAddressSlot := tokenApproval.slot
671             approvedAddress := sload(approvedAddressSlot)
672         }
673     }
674 
675     function transferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) public payable virtual override {
680         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
681 
682         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
683 
684         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
685 
686         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
687             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
688 
689         if (to == address(0)) revert TransferToZeroAddress();
690 
691         _beforeTokenTransfers(from, to, tokenId, 1);
692 
693         assembly {
694             if approvedAddress {
695 
696                 sstore(approvedAddressSlot, 0)
697             }
698         }
699 
700         unchecked {
701 
702             --_packedAddressData[from]; 
703             ++_packedAddressData[to]; 
704 
705             _packedOwnerships[tokenId] = _packOwnershipData(
706                 to,
707                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
708             );
709 
710             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
711                 uint256 nextTokenId = tokenId + 1;
712 
713                 if (_packedOwnerships[nextTokenId] == 0) {
714 
715                     if (nextTokenId != _currentIndex) {
716 
717                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
718                     }
719                 }
720             }
721         }
722 
723         emit Transfer(from, to, tokenId);
724         _afterTokenTransfers(from, to, tokenId, 1);
725     }
726 
727     function safeTransferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public payable virtual override {
732         safeTransferFrom(from, to, tokenId, '');
733     }
734 
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId,
739         bytes memory _data
740     ) public payable virtual override {
741         transferFrom(from, to, tokenId);
742         if (to.code.length != 0)
743             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
744                 revert TransferToNonERC721ReceiverImplementer();
745             }
746     }
747 
748     function _beforeTokenTransfers(
749         address from,
750         address to,
751         uint256 startTokenId,
752         uint256 quantity
753     ) internal virtual {}
754 
755     function _afterTokenTransfers(
756         address from,
757         address to,
758         uint256 startTokenId,
759         uint256 quantity
760     ) internal virtual {}
761 
762     function _checkContractOnERC721Received(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) private returns (bool) {
768         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
769             bytes4 retval
770         ) {
771             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
772         } catch (bytes memory reason) {
773             if (reason.length == 0) {
774                 revert TransferToNonERC721ReceiverImplementer();
775             } else {
776                 assembly {
777                     revert(add(32, reason), mload(reason))
778                 }
779             }
780         }
781     }
782 
783     function _mint(address to, uint256 quantity) internal virtual {
784         uint256 startTokenId = _currentIndex;
785         if (quantity == 0) revert MintZeroQuantity();
786 
787         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
788 
789         unchecked {
790 
791             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
792 
793             _packedOwnerships[startTokenId] = _packOwnershipData(
794                 to,
795                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
796             );
797 
798             uint256 toMasked;
799             uint256 end = startTokenId + quantity;
800 
801             assembly {
802 
803                 toMasked := and(to, _BITMASK_ADDRESS)
804 
805                 log4(
806                     0, 
807                     0, 
808                     _TRANSFER_EVENT_SIGNATURE, 
809                     0, 
810                     toMasked, 
811                     startTokenId 
812                 )
813 
814                 for {
815                     let tokenId := add(startTokenId, 1)
816                 } iszero(eq(tokenId, end)) {
817                     tokenId := add(tokenId, 1)
818                 } {
819 
820                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
821                 }
822             }
823             if (toMasked == 0) revert MintToZeroAddress();
824 
825             _currentIndex = end;
826         }
827         _afterTokenTransfers(address(0), to, startTokenId, quantity);
828     }
829 
830     function _mintERC2309(address to, uint256 quantity) internal virtual {
831         uint256 startTokenId = _currentIndex;
832         if (to == address(0)) revert MintToZeroAddress();
833         if (quantity == 0) revert MintZeroQuantity();
834         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
835 
836         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
837 
838         unchecked {
839 
840             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
841 
842             _packedOwnerships[startTokenId] = _packOwnershipData(
843                 to,
844                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
845             );
846 
847             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
848 
849             _currentIndex = startTokenId + quantity;
850         }
851         _afterTokenTransfers(address(0), to, startTokenId, quantity);
852     }
853 
854     function _safeMint(
855         address to,
856         uint256 quantity,
857         bytes memory _data
858     ) internal virtual {
859         _mint(to, quantity);
860 
861         unchecked {
862             if (to.code.length != 0) {
863                 uint256 end = _currentIndex;
864                 uint256 index = end - quantity;
865                 do {
866                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
867                         revert TransferToNonERC721ReceiverImplementer();
868                     }
869                 } while (index < end);
870                 // Reentrancy protection.
871                 if (_currentIndex != end) revert();
872             }
873         }
874     }
875 
876     function _safeMint(address to, uint256 quantity) internal virtual {
877         _safeMint(to, quantity, '');
878     }
879 
880     function _burn(uint256 tokenId) internal virtual {
881         _burn(tokenId, false);
882     }
883 
884     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
885         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
886 
887         address from = address(uint160(prevOwnershipPacked));
888 
889         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
890 
891         if (approvalCheck) {
892             
893             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
894                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
895         }
896 
897         _beforeTokenTransfers(from, address(0), tokenId, 1);
898 
899         assembly {
900             if approvedAddress {
901                 
902                 sstore(approvedAddressSlot, 0)
903             }
904         }
905 
906         unchecked {
907 
908             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
909 
910             _packedOwnerships[tokenId] = _packOwnershipData(
911                 from,
912                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
913             );
914 
915             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
916                 uint256 nextTokenId = tokenId + 1;
917 
918                 if (_packedOwnerships[nextTokenId] == 0) {
919 
920                     if (nextTokenId != _currentIndex) {
921 
922                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
923                     }
924                 }
925             }
926         }
927 
928         emit Transfer(from, address(0), tokenId);
929         _afterTokenTransfers(from, address(0), tokenId, 1);
930 
931         unchecked {
932             _burnCounter++;
933         }
934     }
935 
936     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
937         uint256 packed = _packedOwnerships[index];
938         if (packed == 0) revert OwnershipNotInitializedForExtraData();
939         uint256 extraDataCasted;
940         assembly {
941             extraDataCasted := extraData
942         }
943         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
944         _packedOwnerships[index] = packed;
945     }
946 
947     function _extraData(
948         address from,
949         address to,
950         uint24 previousExtraData
951     ) internal view virtual returns (uint24) {}
952 
953     function _nextExtraData(
954         address from,
955         address to,
956         uint256 prevOwnershipPacked
957     ) private view returns (uint256) {
958         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
959         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
960     }
961 
962     function _msgSenderERC721A() internal view virtual returns (address) {
963         return msg.sender;
964     }
965 
966     function _toString(uint256 value) internal pure virtual returns (string memory str) {
967         assembly {
968 
969             let m := add(mload(0x40), 0xa0)
970 
971             mstore(0x40, m)
972 
973             str := sub(m, 0x20)
974 
975             mstore(str, 0)
976 
977             let end := str
978 
979             for { let temp := value } 1 {} {
980                 str := sub(str, 1)
981 
982                 mstore8(str, add(48, mod(temp, 10)))
983 
984                 temp := div(temp, 10)
985 
986                 if iszero(temp) { break }
987             }
988 
989             let length := sub(end, str)
990 
991             str := sub(str, 0x20)
992 
993             mstore(str, length)
994         }
995     }
996 }
997 
998 pragma solidity ^0.8.13;
999 
1000 contract OperatorFilterer {
1001     error OperatorNotAllowed(address operator);
1002 
1003     IOperatorFilterRegistry constant operatorFilterRegistry =
1004         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1005 
1006     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1007 
1008         if (address(operatorFilterRegistry).code.length > 0) {
1009             if (subscribe) {
1010                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1011             } else {
1012                 if (subscriptionOrRegistrantToCopy != address(0)) {
1013                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1014                 } else {
1015                     operatorFilterRegistry.register(address(this));
1016                 }
1017             }
1018         }
1019     }
1020 
1021     modifier onlyAllowedOperator() virtual {
1022 
1023         if (address(operatorFilterRegistry).code.length > 0) {
1024             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1025                 revert OperatorNotAllowed(msg.sender);
1026             }
1027         }
1028         _;
1029     }
1030 }
1031 
1032 pragma solidity ^0.8.13;
1033 
1034 contract DefaultOperatorFilterer is OperatorFilterer {
1035 address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1036 constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1037 }
1038 
1039 pragma solidity ^0.8.13;
1040 
1041 interface IOperatorFilterRegistry {
1042     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1043     function register(address registrant) external;
1044     function registerAndSubscribe(address registrant, address subscription) external;
1045     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1046     function updateOperator(address registrant, address operator, bool filtered) external;
1047     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1048     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1049     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1050     function subscribe(address registrant, address registrantToSubscribe) external;
1051     function unsubscribe(address registrant, bool copyExistingEntries) external;
1052     function subscriptionOf(address addr) external returns (address registrant);
1053     function subscribers(address registrant) external returns (address[] memory);
1054     function subscriberAt(address registrant, uint256 index) external returns (address);
1055     function copyEntriesOf(address registrant, address registrantToCopy) external;
1056     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1057     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1058     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1059     function filteredOperators(address addr) external returns (address[] memory);
1060     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1061     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1062     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1063     function isRegistered(address addr) external returns (bool);
1064     function codeHashOf(address addr) external returns (bytes32);
1065 }
1066 
1067 pragma solidity ^0.8.4;
1068 
1069 interface IERC721ABurnable is IERC721A {
1070 function burn(uint256 tokenId) external;
1071 }
1072 
1073 pragma solidity ^0.8.4;
1074 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1075 function burn(uint256 tokenId) public virtual override {
1076         _burn(tokenId, true);
1077     }
1078 }
1079 
1080 pragma solidity ^0.8.16;
1081 contract BobIsHere is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1082 string public CONTRACT_URI = "";
1083 mapping(address => uint) public userHasMinted;
1084 bool public REVEALED;
1085 string public UNREVEALED_URI = "";
1086 string public BASE_URI = "";
1087 bool public isPublicMintEnabled = false;
1088 uint public COLLECTION_SIZE = 10000; 
1089 uint public MINT_PRICE = 0.003 ether; 
1090 uint public MAX_BATCH_SIZE = 25;
1091 uint public SUPPLY_PER_WALLET = 25;
1092 uint public FREE_SUPPLY_PER_WALLET = 3;
1093 constructor() ERC721A("BOB IS HERE", "BOB") {}
1094 
1095     function MintTo (uint256 quantity, address receiver) public onlyOwner {
1096         require(
1097             totalSupply() + quantity <= COLLECTION_SIZE,
1098             "No more in stock!"
1099         );
1100         
1101         _safeMint(receiver, quantity);
1102     }
1103 
1104     modifier callerIsUser() {
1105         require(tx.origin == msg.sender, "The caller is another contract");
1106         _;
1107     }
1108 
1109     function getPrice(uint quantity) public view returns(uint){
1110         uint price;
1111         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1112         if (quantity >= free) {
1113             price = (MINT_PRICE) * (quantity - free);
1114         } else {
1115             price = 0;
1116         }
1117         return price;
1118     }
1119 
1120     function mint(uint quantity)
1121         external
1122         payable
1123         callerIsUser 
1124         nonReentrant
1125     {
1126         uint price;
1127         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1128         if (quantity >= free) {
1129             price = (MINT_PRICE) * (quantity - free);
1130             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1131         } else {
1132             price = 0;
1133             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1134         }
1135 
1136 require(isPublicMintEnabled, "Not Live yet!");
1137 require(totalSupply() + quantity <= COLLECTION_SIZE, "No more in Stock");
1138 require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to mint over over limit");
1139 require(quantity <= MAX_BATCH_SIZE, "Tried to mint over limit, retry with reduced quantity");
1140 require(msg.value >= price, "Must send more eth");
1141 
1142         _safeMint(msg.sender, quantity);
1143 
1144         if (msg.value > price) {
1145             payable(msg.sender).transfer(msg.value - price);
1146         }
1147     }
1148     function setPublicMintEnabled() public onlyOwner {
1149         isPublicMintEnabled = !isPublicMintEnabled;
1150     }
1151 
1152     function withdrawFunds() external onlyOwner nonReentrant {
1153         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1154         require(success, "Transfer failed.");
1155     }
1156 
1157     function SetCollectionUrI(bool _revealed, string memory _baseURI) public onlyOwner {
1158         BASE_URI = _baseURI;
1159         REVEALED = _revealed;
1160     }
1161 
1162     function contractURI() public view returns (string memory) {
1163         return CONTRACT_URI;
1164     }
1165 
1166     function setContract(string memory _contractURI) public onlyOwner {
1167         CONTRACT_URI = _contractURI;
1168     }
1169 
1170     function SetSupply(uint256 _new) external onlyOwner {
1171         COLLECTION_SIZE = _new;
1172     }
1173 
1174     function SetPrice(uint256 _newPrice) external onlyOwner {
1175         MINT_PRICE = _newPrice;
1176     }
1177 
1178     function SetFreePerWallet(uint256 _new) external onlyOwner {
1179         FREE_SUPPLY_PER_WALLET = _new;
1180     }
1181 
1182     function SetSupplyPerWallet(uint256 _new) external onlyOwner {
1183         SUPPLY_PER_WALLET = _new;
1184     }
1185 
1186     function SetMaxBatchSize(uint256 _new) external onlyOwner {
1187         MAX_BATCH_SIZE = _new;
1188     }
1189 
1190     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator { 
1191         super.transferFrom(from, to, tokenId);
1192     }
1193 
1194     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1195         super.safeTransferFrom(from, to, tokenId);
1196     }
1197 
1198     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1199         public payable
1200         override (ERC721A, IERC721A)
1201         onlyAllowedOperator
1202     {
1203         super.safeTransferFrom(from, to, tokenId, data);
1204     }
1205 
1206     function tokenURI(uint256 _tokenId)
1207         public
1208         view
1209         override (ERC721A, IERC721A)
1210         returns (string memory)
1211     {
1212         if (REVEALED) {
1213             return
1214                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1215         } else {
1216             return UNREVEALED_URI;
1217         }
1218     }
1219 
1220 }