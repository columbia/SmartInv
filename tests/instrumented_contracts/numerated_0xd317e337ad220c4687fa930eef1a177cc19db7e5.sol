1 // SPDX-License-Identifier: MIT     
2 
3 //
4 //
5 // ██████╗ ██╗██╗     ██╗      ██████╗  ██████╗ ███████╗███████╗
6 // ██╔══██╗██║██║     ██║     ██╔═══██╗██╔═══██╗╚══███╔╝██╔════╝
7 // ██████╔╝██║██║     ██║     ██║   ██║██║   ██║  ███╔╝ █████╗  
8 // ██╔═══╝ ██║██║     ██║     ██║   ██║██║   ██║ ███╔╝  ██╔══╝  
9 // ██║     ██║███████╗███████╗╚██████╔╝╚██████╔╝███████╗███████╗
10 // ╚═╝     ╚═╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
11 //                                                            
12 //
13 // Web: https://pillooz.wtf
14 // Twitter: https://twitter.com/pilloozenft
15 //
16 
17 pragma solidity ^0.8.0;
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 pragma solidity ^0.8.0;
29 abstract contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor() {
35         _transferOwnership(_msgSender());
36     }
37 
38     modifier onlyOwner() {
39         _checkOwner();
40         _;
41     }
42 
43     function owner() public view virtual returns (address) {
44         return _owner;
45     }
46 
47     function _checkOwner() internal view virtual {
48         require(owner() == _msgSender(), "Ownable: caller is not the owner");
49     }
50 
51     function renounceOwnership() public virtual onlyOwner {
52         _transferOwnership(address(0));
53     }
54 
55 
56     function transferOwnership(address newOwner) public virtual onlyOwner {
57         require(newOwner != address(0), "Ownable: new owner is the zero address");
58         _transferOwnership(newOwner);
59     }
60 
61     function _transferOwnership(address newOwner) internal virtual {
62         address oldOwner = _owner;
63         _owner = newOwner;
64         emit OwnershipTransferred(oldOwner, newOwner);
65     }
66 }
67 
68 pragma solidity ^0.8.0;
69 
70 abstract contract ReentrancyGuard {
71 
72     uint256 private constant _NOT_ENTERED = 1;
73     uint256 private constant _ENTERED = 2;
74 
75     uint256 private _status;
76 
77     constructor() {
78         _status = _NOT_ENTERED;
79     }
80 
81     modifier nonReentrant() {
82         
83         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
84 
85         _status = _ENTERED;
86 
87         _;
88 
89         _status = _NOT_ENTERED;
90     }
91 }
92 
93 pragma solidity ^0.8.0;
94 
95 library Strings {
96     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
97     uint8 private constant _ADDRESS_LENGTH = 20;
98 
99     function toString(uint256 value) internal pure returns (string memory) {
100 
101         if (value == 0) {
102             return "0";
103         }
104         uint256 temp = value;
105         uint256 digits;
106         while (temp != 0) {
107             digits++;
108             temp /= 10;
109         }
110         bytes memory buffer = new bytes(digits);
111         while (value != 0) {
112             digits -= 1;
113             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
114             value /= 10;
115         }
116         return string(buffer);
117     }
118 
119     function toHexString(uint256 value) internal pure returns (string memory) {
120         if (value == 0) {
121             return "0x00";
122         }
123         uint256 temp = value;
124         uint256 length = 0;
125         while (temp != 0) {
126             length++;
127             temp >>= 8;
128         }
129         return toHexString(value, length);
130     }
131 
132     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
133         bytes memory buffer = new bytes(2 * length + 2);
134         buffer[0] = "0";
135         buffer[1] = "x";
136         for (uint256 i = 2 * length + 1; i > 1; --i) {
137             buffer[i] = _HEX_SYMBOLS[value & 0xf];
138             value >>= 4;
139         }
140         require(value == 0, "Strings: hex length insufficient");
141         return string(buffer);
142     }
143 
144     function toHexString(address addr) internal pure returns (string memory) {
145         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
146     }
147 }
148 
149 pragma solidity ^0.8.0;
150 
151 
152 library EnumerableSet {
153 
154 
155     struct Set {
156         // Storage of set values
157         bytes32[] _values;
158 
159         mapping(bytes32 => uint256) _indexes;
160     }
161 
162     function _add(Set storage set, bytes32 value) private returns (bool) {
163         if (!_contains(set, value)) {
164             set._values.push(value);
165 
166             set._indexes[value] = set._values.length;
167             return true;
168         } else {
169             return false;
170         }
171     }
172 
173     function _remove(Set storage set, bytes32 value) private returns (bool) {
174 
175         uint256 valueIndex = set._indexes[value];
176 
177         if (valueIndex != 0) {
178 
179             uint256 toDeleteIndex = valueIndex - 1;
180             uint256 lastIndex = set._values.length - 1;
181 
182             if (lastIndex != toDeleteIndex) {
183                 bytes32 lastValue = set._values[lastIndex];
184 
185                 set._values[toDeleteIndex] = lastValue;
186                 
187                 set._indexes[lastValue] = valueIndex; 
188             }
189 
190             set._values.pop();
191 
192             delete set._indexes[value];
193 
194             return true;
195         } else {
196             return false;
197         }
198     }
199 
200     function _contains(Set storage set, bytes32 value) private view returns (bool) {
201         return set._indexes[value] != 0;
202     }
203 
204     function _length(Set storage set) private view returns (uint256) {
205         return set._values.length;
206     }
207 
208     function _at(Set storage set, uint256 index) private view returns (bytes32) {
209         return set._values[index];
210     }
211 
212     function _values(Set storage set) private view returns (bytes32[] memory) {
213         return set._values;
214     }
215 
216     struct Bytes32Set {
217         Set _inner;
218     }
219 
220     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
221         return _add(set._inner, value);
222     }
223 
224     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
225         return _remove(set._inner, value);
226     }
227 
228     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
229         return _contains(set._inner, value);
230     }
231 
232     function length(Bytes32Set storage set) internal view returns (uint256) {
233         return _length(set._inner);
234     }
235 
236     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
237         return _at(set._inner, index);
238     }
239 
240     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
241         return _values(set._inner);
242     }
243 
244     struct AddressSet {
245         Set _inner;
246     }
247 
248     function add(AddressSet storage set, address value) internal returns (bool) {
249         return _add(set._inner, bytes32(uint256(uint160(value))));
250     }
251 
252     function remove(AddressSet storage set, address value) internal returns (bool) {
253         return _remove(set._inner, bytes32(uint256(uint160(value))));
254     }
255 
256     function contains(AddressSet storage set, address value) internal view returns (bool) {
257         return _contains(set._inner, bytes32(uint256(uint160(value))));
258     }
259 
260     function length(AddressSet storage set) internal view returns (uint256) {
261         return _length(set._inner);
262     }
263 
264     function at(AddressSet storage set, uint256 index) internal view returns (address) {
265         return address(uint160(uint256(_at(set._inner, index))));
266     }
267 
268     function values(AddressSet storage set) internal view returns (address[] memory) {
269         bytes32[] memory store = _values(set._inner);
270         address[] memory result;
271 
272         assembly {
273             result := store
274         }
275 
276         return result;
277     }
278 
279     struct UintSet {
280         Set _inner;
281     }
282 
283     function add(UintSet storage set, uint256 value) internal returns (bool) {
284         return _add(set._inner, bytes32(value));
285     }
286 
287     function remove(UintSet storage set, uint256 value) internal returns (bool) {
288         return _remove(set._inner, bytes32(value));
289     }
290 
291     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
292         return _contains(set._inner, bytes32(value));
293     }
294 
295     function length(UintSet storage set) internal view returns (uint256) {
296         return _length(set._inner);
297     }
298 
299     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
300         return uint256(_at(set._inner, index));
301     }
302 
303     function values(UintSet storage set) internal view returns (uint256[] memory) {
304         bytes32[] memory store = _values(set._inner);
305         uint256[] memory result;
306 
307         /// @solidity memory-safe-assembly
308         assembly {
309             result := store
310         }
311 
312         return result;
313     }
314 }
315 
316 pragma solidity ^0.8.4;
317 
318 interface IERC721A {
319 
320     error ApprovalCallerNotOwnerNorApproved();
321 
322     error ApprovalQueryForNonexistentToken();
323 
324     error BalanceQueryForZeroAddress();
325 
326     error MintToZeroAddress();
327 
328     error MintZeroQuantity();
329 
330     error OwnerQueryForNonexistentToken();
331 
332     error TransferCallerNotOwnerNorApproved();
333 
334     error TransferFromIncorrectOwner();
335 
336     error TransferToNonERC721ReceiverImplementer();
337 
338     error TransferToZeroAddress();
339 
340     error URIQueryForNonexistentToken();
341 
342     error MintERC2309QuantityExceedsLimit();
343 
344     error OwnershipNotInitializedForExtraData();
345 
346     struct TokenOwnership {
347 
348         address addr;
349 
350         uint64 startTimestamp;
351 
352         bool burned;
353 
354         uint24 extraData;
355     }
356 
357     function totalSupply() external view returns (uint256);
358 
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 
361     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
362 
363     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
364 
365     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
366 
367     function balanceOf(address owner) external view returns (uint256 balance);
368 
369     function ownerOf(uint256 tokenId) external view returns (address owner);
370 
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId,
375         bytes calldata data
376     ) external payable;
377 
378     function safeTransferFrom(
379         address from,
380         address to,
381         uint256 tokenId
382     ) external payable;
383 
384     function transferFrom(
385         address from,
386         address to,
387         uint256 tokenId
388     ) external payable;
389 
390     function approve(address to, uint256 tokenId) external payable;
391 
392     function setApprovalForAll(address operator, bool _approved) external;
393 
394     function getApproved(uint256 tokenId) external view returns (address operator);
395 
396     function isApprovedForAll(address owner, address operator) external view returns (bool);
397 
398     function name() external view returns (string memory);
399 
400     function symbol() external view returns (string memory);
401 
402     function tokenURI(uint256 tokenId) external view returns (string memory);
403 
404     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
405 }
406 
407 pragma solidity ^0.8.4;
408 
409 interface ERC721A__IERC721Receiver {
410     function onERC721Received(
411         address operator,
412         address from,
413         uint256 tokenId,
414         bytes calldata data
415     ) external returns (bytes4);
416 }
417 
418 contract ERC721A is IERC721A {
419 
420     struct TokenApprovalRef {
421         address value;
422     }
423 
424     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
425 
426     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
427 
428     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
429 
430     uint256 private constant _BITPOS_AUX = 192;
431 
432     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
433 
434     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
435 
436     uint256 private constant _BITMASK_BURNED = 1 << 224;
437 
438     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
439 
440     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
441 
442     uint256 private constant _BITPOS_EXTRA_DATA = 232;
443 
444     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
445 
446     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
447 
448     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
449 
450     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
451         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
452 
453     uint256 private _currentIndex;
454 
455     uint256 private _burnCounter;
456 
457     string private _name;
458 
459     string private _symbol;
460 
461     mapping(uint256 => uint256) private _packedOwnerships;
462 
463     mapping(address => uint256) private _packedAddressData;
464 
465     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
466 
467     mapping(address => mapping(address => bool)) private _operatorApprovals;
468 
469     constructor(string memory name_, string memory symbol_) {
470         _name = name_;
471         _symbol = symbol_;
472         _currentIndex = _startTokenId();
473     }
474 
475     function _startTokenId() internal view virtual returns (uint256) {
476         return 0;
477     }
478 
479     function _nextTokenId() internal view virtual returns (uint256) {
480         return _currentIndex;
481     }
482 
483     function totalSupply() public view virtual override returns (uint256) {
484 
485         unchecked {
486             return _currentIndex - _burnCounter - _startTokenId();
487         }
488     }
489 
490     function _totalMinted() internal view virtual returns (uint256) {
491 
492         unchecked {
493             return _currentIndex - _startTokenId();
494         }
495     }
496 
497     function _totalBurned() internal view virtual returns (uint256) {
498         return _burnCounter;
499     }
500 
501     function balanceOf(address owner) public view virtual override returns (uint256) {
502         if (owner == address(0)) revert BalanceQueryForZeroAddress();
503         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
504     }
505 
506     function _numberMinted(address owner) internal view returns (uint256) {
507         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
508     }
509 
510     function _numberBurned(address owner) internal view returns (uint256) {
511         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
512     }
513 
514     function _getAux(address owner) internal view returns (uint64) {
515         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
516     }
517 
518     function _setAux(address owner, uint64 aux) internal virtual {
519         uint256 packed = _packedAddressData[owner];
520         uint256 auxCasted;
521         // Cast `aux` with assembly to avoid redundant masking.
522         assembly {
523             auxCasted := aux
524         }
525         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
526         _packedAddressData[owner] = packed;
527     }
528 
529 
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531 
532         return
533             interfaceId == 0x01ffc9a7 || 
534             interfaceId == 0x80ac58cd || 
535             interfaceId == 0x5b5e139f; 
536     }
537 
538     function name() public view virtual override returns (string memory) {
539         return _name;
540     }
541 
542     function symbol() public view virtual override returns (string memory) {
543         return _symbol;
544     }
545 
546     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
547         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
548 
549         string memory baseURI = _baseURI();
550         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
551     }
552 
553     function _baseURI() internal view virtual returns (string memory) {
554         return '';
555     }
556 
557     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
558         return address(uint160(_packedOwnershipOf(tokenId)));
559     }
560 
561     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
562         return _unpackedOwnership(_packedOwnershipOf(tokenId));
563     }
564 
565     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
566         return _unpackedOwnership(_packedOwnerships[index]);
567     }
568 
569     function _initializeOwnershipAt(uint256 index) internal virtual {
570         if (_packedOwnerships[index] == 0) {
571             _packedOwnerships[index] = _packedOwnershipOf(index);
572         }
573     }
574 
575     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
576         uint256 curr = tokenId;
577 
578         unchecked {
579             if (_startTokenId() <= curr)
580                 if (curr < _currentIndex) {
581                     uint256 packed = _packedOwnerships[curr];
582 
583                     if (packed & _BITMASK_BURNED == 0) {
584 
585                         while (packed == 0) {
586                             packed = _packedOwnerships[--curr];
587                         }
588                         return packed;
589                     }
590                 }
591         }
592         revert OwnerQueryForNonexistentToken();
593     }
594 
595     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
596         ownership.addr = address(uint160(packed));
597         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
598         ownership.burned = packed & _BITMASK_BURNED != 0;
599         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
600     }
601 
602     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
603         assembly {
604             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
605             owner := and(owner, _BITMASK_ADDRESS)
606             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
607             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
608         }
609     }
610 
611     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
612         // For branchless setting of the `nextInitialized` flag.
613         assembly {
614             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
615             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
616         }
617     }
618 
619     function approve(address to, uint256 tokenId) public payable virtual override {
620         address owner = ownerOf(tokenId);
621 
622         if (_msgSenderERC721A() != owner)
623             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
624                 revert ApprovalCallerNotOwnerNorApproved();
625             }
626 
627         _tokenApprovals[tokenId].value = to;
628         emit Approval(owner, to, tokenId);
629     }
630 
631     function getApproved(uint256 tokenId) public view virtual override returns (address) {
632         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
633 
634         return _tokenApprovals[tokenId].value;
635     }
636 
637     function setApprovalForAll(address operator, bool approved) public virtual override {
638         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
639         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
640     }
641 
642     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
643         return _operatorApprovals[owner][operator];
644     }
645 
646     function _exists(uint256 tokenId) internal view virtual returns (bool) {
647         return
648             _startTokenId() <= tokenId &&
649             tokenId < _currentIndex && // If within bounds,
650             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
651     }
652 
653     function _isSenderApprovedOrOwner(
654         address approvedAddress,
655         address owner,
656         address msgSender
657     ) private pure returns (bool result) {
658         assembly {
659 
660             owner := and(owner, _BITMASK_ADDRESS)
661 
662             msgSender := and(msgSender, _BITMASK_ADDRESS)
663 
664             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
665         }
666     }
667 
668     function _getApprovedSlotAndAddress(uint256 tokenId)
669         private
670         view
671         returns (uint256 approvedAddressSlot, address approvedAddress)
672     {
673         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
674 
675         assembly {
676             approvedAddressSlot := tokenApproval.slot
677             approvedAddress := sload(approvedAddressSlot)
678         }
679     }
680 
681     function transferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) public payable virtual override {
686         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
687 
688         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
689 
690         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
691 
692         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
693             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
694 
695         if (to == address(0)) revert TransferToZeroAddress();
696 
697         _beforeTokenTransfers(from, to, tokenId, 1);
698 
699         assembly {
700             if approvedAddress {
701 
702                 sstore(approvedAddressSlot, 0)
703             }
704         }
705 
706         unchecked {
707 
708             --_packedAddressData[from]; 
709             ++_packedAddressData[to]; 
710 
711             _packedOwnerships[tokenId] = _packOwnershipData(
712                 to,
713                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
714             );
715 
716             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
717                 uint256 nextTokenId = tokenId + 1;
718 
719                 if (_packedOwnerships[nextTokenId] == 0) {
720 
721                     if (nextTokenId != _currentIndex) {
722 
723                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
724                     }
725                 }
726             }
727         }
728 
729         emit Transfer(from, to, tokenId);
730         _afterTokenTransfers(from, to, tokenId, 1);
731     }
732 
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId
737     ) public payable virtual override {
738         safeTransferFrom(from, to, tokenId, '');
739     }
740 
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId,
745         bytes memory _data
746     ) public payable virtual override {
747         transferFrom(from, to, tokenId);
748         if (to.code.length != 0)
749             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
750                 revert TransferToNonERC721ReceiverImplementer();
751             }
752     }
753 
754     function _beforeTokenTransfers(
755         address from,
756         address to,
757         uint256 startTokenId,
758         uint256 quantity
759     ) internal virtual {}
760 
761     function _afterTokenTransfers(
762         address from,
763         address to,
764         uint256 startTokenId,
765         uint256 quantity
766     ) internal virtual {}
767 
768     function _checkContractOnERC721Received(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) private returns (bool) {
774         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
775             bytes4 retval
776         ) {
777             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
778         } catch (bytes memory reason) {
779             if (reason.length == 0) {
780                 revert TransferToNonERC721ReceiverImplementer();
781             } else {
782                 assembly {
783                     revert(add(32, reason), mload(reason))
784                 }
785             }
786         }
787     }
788 
789     function _mint(address to, uint256 quantity) internal virtual {
790         uint256 startTokenId = _currentIndex;
791         if (quantity == 0) revert MintZeroQuantity();
792 
793         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
794 
795         unchecked {
796 
797             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
798 
799             _packedOwnerships[startTokenId] = _packOwnershipData(
800                 to,
801                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
802             );
803 
804             uint256 toMasked;
805             uint256 end = startTokenId + quantity;
806 
807             assembly {
808 
809                 toMasked := and(to, _BITMASK_ADDRESS)
810 
811                 log4(
812                     0, 
813                     0, 
814                     _TRANSFER_EVENT_SIGNATURE, 
815                     0, 
816                     toMasked, 
817                     startTokenId 
818                 )
819 
820                 for {
821                     let tokenId := add(startTokenId, 1)
822                 } iszero(eq(tokenId, end)) {
823                     tokenId := add(tokenId, 1)
824                 } {
825 
826                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
827                 }
828             }
829             if (toMasked == 0) revert MintToZeroAddress();
830 
831             _currentIndex = end;
832         }
833         _afterTokenTransfers(address(0), to, startTokenId, quantity);
834     }
835 
836     function _mintERC2309(address to, uint256 quantity) internal virtual {
837         uint256 startTokenId = _currentIndex;
838         if (to == address(0)) revert MintToZeroAddress();
839         if (quantity == 0) revert MintZeroQuantity();
840         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
841 
842         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
843 
844         unchecked {
845 
846             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
847 
848             _packedOwnerships[startTokenId] = _packOwnershipData(
849                 to,
850                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
851             );
852 
853             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
854 
855             _currentIndex = startTokenId + quantity;
856         }
857         _afterTokenTransfers(address(0), to, startTokenId, quantity);
858     }
859 
860     function _safeMint(
861         address to,
862         uint256 quantity,
863         bytes memory _data
864     ) internal virtual {
865         _mint(to, quantity);
866 
867         unchecked {
868             if (to.code.length != 0) {
869                 uint256 end = _currentIndex;
870                 uint256 index = end - quantity;
871                 do {
872                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
873                         revert TransferToNonERC721ReceiverImplementer();
874                     }
875                 } while (index < end);
876                 // Reentrancy protection.
877                 if (_currentIndex != end) revert();
878             }
879         }
880     }
881 
882     function _safeMint(address to, uint256 quantity) internal virtual {
883         _safeMint(to, quantity, '');
884     }
885 
886     function _burn(uint256 tokenId) internal virtual {
887         _burn(tokenId, false);
888     }
889 
890     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
891         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
892 
893         address from = address(uint160(prevOwnershipPacked));
894 
895         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
896 
897         if (approvalCheck) {
898             
899             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
900                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
901         }
902 
903         _beforeTokenTransfers(from, address(0), tokenId, 1);
904 
905         assembly {
906             if approvedAddress {
907                 
908                 sstore(approvedAddressSlot, 0)
909             }
910         }
911 
912         unchecked {
913 
914             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
915 
916             _packedOwnerships[tokenId] = _packOwnershipData(
917                 from,
918                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
919             );
920 
921             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
922                 uint256 nextTokenId = tokenId + 1;
923 
924                 if (_packedOwnerships[nextTokenId] == 0) {
925 
926                     if (nextTokenId != _currentIndex) {
927 
928                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
929                     }
930                 }
931             }
932         }
933 
934         emit Transfer(from, address(0), tokenId);
935         _afterTokenTransfers(from, address(0), tokenId, 1);
936 
937         unchecked {
938             _burnCounter++;
939         }
940     }
941 
942     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
943         uint256 packed = _packedOwnerships[index];
944         if (packed == 0) revert OwnershipNotInitializedForExtraData();
945         uint256 extraDataCasted;
946         assembly {
947             extraDataCasted := extraData
948         }
949         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
950         _packedOwnerships[index] = packed;
951     }
952 
953     function _extraData(
954         address from,
955         address to,
956         uint24 previousExtraData
957     ) internal view virtual returns (uint24) {}
958 
959     function _nextExtraData(
960         address from,
961         address to,
962         uint256 prevOwnershipPacked
963     ) private view returns (uint256) {
964         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
965         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
966     }
967 
968     function _msgSenderERC721A() internal view virtual returns (address) {
969         return msg.sender;
970     }
971 
972     function _toString(uint256 value) internal pure virtual returns (string memory str) {
973         assembly {
974 
975             let m := add(mload(0x40), 0xa0)
976 
977             mstore(0x40, m)
978 
979             str := sub(m, 0x20)
980 
981             mstore(str, 0)
982 
983             let end := str
984 
985             for { let temp := value } 1 {} {
986                 str := sub(str, 1)
987 
988                 mstore8(str, add(48, mod(temp, 10)))
989 
990                 temp := div(temp, 10)
991 
992                 if iszero(temp) { break }
993             }
994 
995             let length := sub(end, str)
996 
997             str := sub(str, 0x20)
998 
999             mstore(str, length)
1000         }
1001     }
1002 }
1003 
1004 pragma solidity ^0.8.13;
1005 
1006 contract OperatorFilterer {
1007     error OperatorNotAllowed(address operator);
1008 
1009     IOperatorFilterRegistry constant operatorFilterRegistry =
1010         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1011 
1012     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1013 
1014         if (address(operatorFilterRegistry).code.length > 0) {
1015             if (subscribe) {
1016                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1017             } else {
1018                 if (subscriptionOrRegistrantToCopy != address(0)) {
1019                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1020                 } else {
1021                     operatorFilterRegistry.register(address(this));
1022                 }
1023             }
1024         }
1025     }
1026 
1027     modifier onlyAllowedOperator() virtual {
1028 
1029         if (address(operatorFilterRegistry).code.length > 0) {
1030             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1031                 revert OperatorNotAllowed(msg.sender);
1032             }
1033         }
1034         _;
1035     }
1036 }
1037 
1038 pragma solidity ^0.8.13;
1039 
1040 contract DefaultOperatorFilterer is OperatorFilterer {
1041     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1042 
1043     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1044 }
1045 
1046 pragma solidity ^0.8.13;
1047 
1048 interface IOperatorFilterRegistry {
1049     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1050     function register(address registrant) external;
1051     function registerAndSubscribe(address registrant, address subscription) external;
1052     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1053     function updateOperator(address registrant, address operator, bool filtered) external;
1054     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1055     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1056     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1057     function subscribe(address registrant, address registrantToSubscribe) external;
1058     function unsubscribe(address registrant, bool copyExistingEntries) external;
1059     function subscriptionOf(address addr) external returns (address registrant);
1060     function subscribers(address registrant) external returns (address[] memory);
1061     function subscriberAt(address registrant, uint256 index) external returns (address);
1062     function copyEntriesOf(address registrant, address registrantToCopy) external;
1063     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1064     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1065     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1066     function filteredOperators(address addr) external returns (address[] memory);
1067     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1068     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1069     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1070     function isRegistered(address addr) external returns (bool);
1071     function codeHashOf(address addr) external returns (bytes32);
1072 }
1073 
1074 pragma solidity ^0.8.4;
1075 
1076 interface IERC721ABurnable is IERC721A {
1077 
1078     function burn(uint256 tokenId) external;
1079 }
1080 
1081 pragma solidity ^0.8.4;
1082 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1083     function burn(uint256 tokenId) public virtual override {
1084         _burn(tokenId, true);
1085     }
1086 }
1087 
1088 pragma solidity ^0.8.16;
1089 contract Pilloze is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable, DefaultOperatorFilterer{
1090 string public CONTRACT_URI = "";
1091 mapping(address => uint) public userHasMinted;
1092 bool public REVEALED;
1093 string public UNREVEALED_URI = "";
1094 string public BASE_URI = "";
1095 bool public isPublicMintEnabled = false;
1096 uint public COLLECTION_SIZE = 3333; 
1097 uint public MINT_PRICE = 0.003 ether; 
1098 uint public MAX_BATCH_SIZE = 21;
1099 uint public SUPPLY_PER_WALLET = 21;
1100 uint public FREE_SUPPLY_PER_WALLET = 1;
1101 constructor() ERC721A("Pillooze", "PILLOOZE") {}
1102 
1103 
1104     function MintVIP(uint256 quantity, address receiver) public onlyOwner {
1105         require(
1106             totalSupply() + quantity <= COLLECTION_SIZE,
1107             "No more Pillooze in stock!"
1108         );
1109         
1110         _safeMint(receiver, quantity);
1111     }
1112 
1113     modifier callerIsUser() {
1114         require(tx.origin == msg.sender, "The caller is another contract");
1115         _;
1116     }
1117 
1118     function getPrice(uint quantity) public view returns(uint){
1119         uint price;
1120         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1121         if (quantity >= free) {
1122             price = (MINT_PRICE) * (quantity - free);
1123         } else {
1124             price = 0;
1125         }
1126         return price;
1127     }
1128 
1129     function mint(uint quantity)
1130         external
1131         payable
1132         callerIsUser 
1133         nonReentrant
1134     {
1135         uint price;
1136         uint free = FREE_SUPPLY_PER_WALLET - userHasMinted[msg.sender];
1137         if (quantity >= free) {
1138             price = (MINT_PRICE) * (quantity - free);
1139             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
1140         } else {
1141             price = 0;
1142             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
1143         }
1144 
1145         require(isPublicMintEnabled, "Pillooze not ready yet!");
1146         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more Pillooze left!");
1147 
1148         require(balanceOf(msg.sender) + quantity <= SUPPLY_PER_WALLET, "Tried to mint Pillooze over over limit");
1149 
1150         require(quantity <= MAX_BATCH_SIZE, "Tried to mint Pillooze over limit, retry with reduced quantity");
1151         require(msg.value >= price, "Must send more money!");
1152 
1153         _safeMint(msg.sender, quantity);
1154 
1155         if (msg.value > price) {
1156             payable(msg.sender).transfer(msg.value - price);
1157         }
1158     }
1159     function setPublicMintEnabled() public onlyOwner {
1160         isPublicMintEnabled = !isPublicMintEnabled;
1161     }
1162 
1163     function withdrawFunds() external onlyOwner nonReentrant {
1164         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1165         require(success, "Transfer failed.");
1166     }
1167 
1168     function CollectionUrI(bool _revealed, string memory _baseURI) public onlyOwner {
1169         BASE_URI = _baseURI;
1170         REVEALED = _revealed;
1171     }
1172 
1173     function contractURI() public view returns (string memory) {
1174         return CONTRACT_URI;
1175     }
1176 
1177     function setContract(string memory _contractURI) public onlyOwner {
1178         CONTRACT_URI = _contractURI;
1179     }
1180 
1181     function ChangeCollectionSupply(uint256 _new) external onlyOwner {
1182         COLLECTION_SIZE = _new;
1183     }
1184 
1185     function ChangePrice(uint256 _newPrice) external onlyOwner {
1186         MINT_PRICE = _newPrice;
1187     }
1188 
1189     function ChangeFreePerWallet(uint256 _new) external onlyOwner {
1190         FREE_SUPPLY_PER_WALLET = _new;
1191     }
1192 
1193     function ChangeSupplyPerWallet(uint256 _new) external onlyOwner {
1194         SUPPLY_PER_WALLET = _new;
1195     }
1196 
1197     function SetMaxBatchSize(uint256 _new) external onlyOwner {
1198         MAX_BATCH_SIZE = _new;
1199     }
1200 
1201     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1202         super.transferFrom(from, to, tokenId);
1203     }
1204 
1205     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A, IERC721A) onlyAllowedOperator {
1206         super.safeTransferFrom(from, to, tokenId);
1207     }
1208 
1209     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1210         public payable
1211         override (ERC721A, IERC721A)
1212         onlyAllowedOperator
1213     {
1214         super.safeTransferFrom(from, to, tokenId, data);
1215     }
1216 
1217     function tokenURI(uint256 _tokenId)
1218         public
1219         view
1220         override (ERC721A, IERC721A)
1221         returns (string memory)
1222     {
1223         if (REVEALED) {
1224             return
1225                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1226         } else {
1227             return UNREVEALED_URI;
1228         }
1229     }
1230 
1231 }