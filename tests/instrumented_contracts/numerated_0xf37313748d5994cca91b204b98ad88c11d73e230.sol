1 // SPDX-License-Identifier: MIT    
2 
3 // 
4 //  ██████  ██████   █████  ███    ██  ██████  ███████ 
5 // ██    ██ ██   ██ ██   ██ ████   ██ ██       ██      
6 // ██    ██ ██████  ███████ ██ ██  ██ ██   ███ █████   
7 // ██    ██ ██   ██ ██   ██ ██  ██ ██ ██    ██ ██      
8 //  ██████  ██   ██ ██   ██ ██   ████  ██████  ███████ 
9 //                                                     
10                                                     
11 pragma solidity ^0.8.0;
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 pragma solidity ^0.8.0;
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     constructor() {
29         _transferOwnership(_msgSender());
30     }
31 
32     modifier onlyOwner() {
33         _checkOwner();
34         _;
35     }
36 
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     function _checkOwner() internal view virtual {
42         require(owner() == _msgSender(), "Ownable: caller is not the owner");
43     }
44 
45     function renounceOwnership() public virtual onlyOwner {
46         _transferOwnership(address(0));
47     }
48 
49 
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         _transferOwnership(newOwner);
53     }
54 
55     function _transferOwnership(address newOwner) internal virtual {
56         address oldOwner = _owner;
57         _owner = newOwner;
58         emit OwnershipTransferred(oldOwner, newOwner);
59     }
60 }
61 
62 pragma solidity ^0.8.0;
63 
64 abstract contract ReentrancyGuard {
65 
66     uint256 private constant _NOT_ENTERED = 1;
67     uint256 private constant _ENTERED = 2;
68 
69     uint256 private _status;
70 
71     constructor() {
72         _status = _NOT_ENTERED;
73     }
74 
75     modifier nonReentrant() {
76         
77         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
78 
79         _status = _ENTERED;
80 
81         _;
82 
83         _status = _NOT_ENTERED;
84     }
85 }
86 
87 pragma solidity ^0.8.0;
88 
89 library Strings {
90     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
91     uint8 private constant _ADDRESS_LENGTH = 20;
92 
93     function toString(uint256 value) internal pure returns (string memory) {
94 
95         if (value == 0) {
96             return "0";
97         }
98         uint256 temp = value;
99         uint256 digits;
100         while (temp != 0) {
101             digits++;
102             temp /= 10;
103         }
104         bytes memory buffer = new bytes(digits);
105         while (value != 0) {
106             digits -= 1;
107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
108             value /= 10;
109         }
110         return string(buffer);
111     }
112 
113     function toHexString(uint256 value) internal pure returns (string memory) {
114         if (value == 0) {
115             return "0x00";
116         }
117         uint256 temp = value;
118         uint256 length = 0;
119         while (temp != 0) {
120             length++;
121             temp >>= 8;
122         }
123         return toHexString(value, length);
124     }
125 
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 
138     function toHexString(address addr) internal pure returns (string memory) {
139         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
140     }
141 }
142 
143 pragma solidity ^0.8.0;
144 
145 
146 library EnumerableSet {
147 
148 
149     struct Set {
150         // Storage of set values
151         bytes32[] _values;
152 
153         mapping(bytes32 => uint256) _indexes;
154     }
155 
156     function _add(Set storage set, bytes32 value) private returns (bool) {
157         if (!_contains(set, value)) {
158             set._values.push(value);
159 
160             set._indexes[value] = set._values.length;
161             return true;
162         } else {
163             return false;
164         }
165     }
166 
167     function _remove(Set storage set, bytes32 value) private returns (bool) {
168 
169         uint256 valueIndex = set._indexes[value];
170 
171         if (valueIndex != 0) {
172 
173             uint256 toDeleteIndex = valueIndex - 1;
174             uint256 lastIndex = set._values.length - 1;
175 
176             if (lastIndex != toDeleteIndex) {
177                 bytes32 lastValue = set._values[lastIndex];
178 
179                 set._values[toDeleteIndex] = lastValue;
180                 
181                 set._indexes[lastValue] = valueIndex; 
182             }
183 
184             set._values.pop();
185 
186             delete set._indexes[value];
187 
188             return true;
189         } else {
190             return false;
191         }
192     }
193 
194     function _contains(Set storage set, bytes32 value) private view returns (bool) {
195         return set._indexes[value] != 0;
196     }
197 
198     function _length(Set storage set) private view returns (uint256) {
199         return set._values.length;
200     }
201 
202     function _at(Set storage set, uint256 index) private view returns (bytes32) {
203         return set._values[index];
204     }
205 
206     function _values(Set storage set) private view returns (bytes32[] memory) {
207         return set._values;
208     }
209 
210     struct Bytes32Set {
211         Set _inner;
212     }
213 
214     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
215         return _add(set._inner, value);
216     }
217 
218     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
219         return _remove(set._inner, value);
220     }
221 
222     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
223         return _contains(set._inner, value);
224     }
225 
226     function length(Bytes32Set storage set) internal view returns (uint256) {
227         return _length(set._inner);
228     }
229 
230     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
231         return _at(set._inner, index);
232     }
233 
234     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
235         return _values(set._inner);
236     }
237 
238     struct AddressSet {
239         Set _inner;
240     }
241 
242     function add(AddressSet storage set, address value) internal returns (bool) {
243         return _add(set._inner, bytes32(uint256(uint160(value))));
244     }
245 
246     function remove(AddressSet storage set, address value) internal returns (bool) {
247         return _remove(set._inner, bytes32(uint256(uint160(value))));
248     }
249 
250     function contains(AddressSet storage set, address value) internal view returns (bool) {
251         return _contains(set._inner, bytes32(uint256(uint160(value))));
252     }
253 
254     function length(AddressSet storage set) internal view returns (uint256) {
255         return _length(set._inner);
256     }
257 
258     function at(AddressSet storage set, uint256 index) internal view returns (address) {
259         return address(uint160(uint256(_at(set._inner, index))));
260     }
261 
262     function values(AddressSet storage set) internal view returns (address[] memory) {
263         bytes32[] memory store = _values(set._inner);
264         address[] memory result;
265 
266         assembly {
267             result := store
268         }
269 
270         return result;
271     }
272 
273     struct UintSet {
274         Set _inner;
275     }
276 
277     function add(UintSet storage set, uint256 value) internal returns (bool) {
278         return _add(set._inner, bytes32(value));
279     }
280 
281     function remove(UintSet storage set, uint256 value) internal returns (bool) {
282         return _remove(set._inner, bytes32(value));
283     }
284 
285     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
286         return _contains(set._inner, bytes32(value));
287     }
288 
289     function length(UintSet storage set) internal view returns (uint256) {
290         return _length(set._inner);
291     }
292 
293     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
294         return uint256(_at(set._inner, index));
295     }
296 
297     function values(UintSet storage set) internal view returns (uint256[] memory) {
298         bytes32[] memory store = _values(set._inner);
299         uint256[] memory result;
300 
301         /// @solidity memory-safe-assembly
302         assembly {
303             result := store
304         }
305 
306         return result;
307     }
308 }
309 
310 pragma solidity ^0.8.4;
311 
312 interface IERC721A {
313 
314     error ApprovalCallerNotOwnerNorApproved();
315 
316     error ApprovalQueryForNonexistentToken();
317 
318     error BalanceQueryForZeroAddress();
319 
320     error MintToZeroAddress();
321 
322     error MintZeroQuantity();
323 
324     error OwnerQueryForNonexistentToken();
325 
326     error TransferCallerNotOwnerNorApproved();
327 
328     error TransferFromIncorrectOwner();
329 
330     error TransferToNonERC721ReceiverImplementer();
331 
332     error TransferToZeroAddress();
333 
334     error URIQueryForNonexistentToken();
335 
336     error MintERC2309QuantityExceedsLimit();
337 
338     error OwnershipNotInitializedForExtraData();
339 
340     struct TokenOwnership {
341 
342         address addr;
343 
344         uint64 startTimestamp;
345 
346         bool burned;
347 
348         uint24 extraData;
349     }
350 
351     function totalSupply() external view returns (uint256);
352 
353     function supportsInterface(bytes4 interfaceId) external view returns (bool);
354 
355     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
356 
357     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
358 
359     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
360 
361     function balanceOf(address owner) external view returns (uint256 balance);
362 
363     function ownerOf(uint256 tokenId) external view returns (address owner);
364 
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId,
369         bytes calldata data
370     ) external payable;
371 
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) external payable;
377 
378     function transferFrom(
379         address from,
380         address to,
381         uint256 tokenId
382     ) external payable;
383 
384     function approve(address to, uint256 tokenId) external payable;
385 
386     function setApprovalForAll(address operator, bool _approved) external;
387 
388     function getApproved(uint256 tokenId) external view returns (address operator);
389 
390     function isApprovedForAll(address owner, address operator) external view returns (bool);
391 
392     function name() external view returns (string memory);
393 
394     function symbol() external view returns (string memory);
395 
396     function tokenURI(uint256 tokenId) external view returns (string memory);
397 
398     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to); 
399 }
400 
401 pragma solidity ^0.8.4;
402 
403 interface ERC721A__IERC721Receiver {
404     function onERC721Received(
405         address operator,
406         address from,
407         uint256 tokenId,
408         bytes calldata data
409     ) external returns (bytes4);
410 }
411 
412 contract ERC721A is IERC721A {
413 
414     struct TokenApprovalRef {
415         address value;
416     }
417 
418     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
419 
420     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
421 
422     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
423 
424     uint256 private constant _BITPOS_AUX = 192;
425 
426     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
427 
428     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
429 
430     uint256 private constant _BITMASK_BURNED = 1 << 224;
431 
432     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
433 
434     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
435 
436     uint256 private constant _BITPOS_EXTRA_DATA = 232;
437 
438     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
439 
440     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
441 
442     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
443 
444     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
445         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
446 
447     uint256 private _currentIndex;
448 
449     uint256 private _burnCounter;
450 
451     string private _name;
452 
453     string private _symbol;
454 
455     mapping(uint256 => uint256) private _packedOwnerships;
456 
457     mapping(address => uint256) private _packedAddressData;
458 
459     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
460 
461     mapping(address => mapping(address => bool)) private _operatorApprovals;
462 
463     constructor(string memory name_, string memory symbol_) {
464         _name = name_;
465         _symbol = symbol_;
466         _currentIndex = _startTokenId();
467     }
468 
469     function _startTokenId() internal view virtual returns (uint256) {
470         return 0;
471     }
472 
473     function _nextTokenId() internal view virtual returns (uint256) {
474         return _currentIndex;
475     }
476 
477     function totalSupply() public view virtual override returns (uint256) {
478 
479         unchecked {
480             return _currentIndex - _burnCounter - _startTokenId();
481         }
482     }
483 
484     function _totalMinted() internal view virtual returns (uint256) {
485 
486         unchecked {
487             return _currentIndex - _startTokenId();
488         }
489     }
490 
491     function _totalBurned() internal view virtual returns (uint256) {
492         return _burnCounter;
493     }
494 
495     function balanceOf(address owner) public view virtual override returns (uint256) {
496         if (owner == address(0)) revert BalanceQueryForZeroAddress();
497         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
498     }
499 
500     function _numberMinted(address owner) internal view returns (uint256) {
501         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
502     }
503 
504     function _numberBurned(address owner) internal view returns (uint256) {
505         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
506     }
507 
508     function _getAux(address owner) internal view returns (uint64) {
509         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
510     }
511 
512     function _setAux(address owner, uint64 aux) internal virtual {
513         uint256 packed = _packedAddressData[owner];
514         uint256 auxCasted;
515         // Cast `aux` with assembly to avoid redundant masking.
516         assembly {
517             auxCasted := aux
518         }
519         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
520         _packedAddressData[owner] = packed;
521     }
522 
523 
524     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525 
526         return
527             interfaceId == 0x01ffc9a7 || 
528             interfaceId == 0x80ac58cd || 
529             interfaceId == 0x5b5e139f; 
530     }
531 
532     function name() public view virtual override returns (string memory) {
533         return _name;
534     }
535 
536     function symbol() public view virtual override returns (string memory) {
537         return _symbol;
538     }
539 
540     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
541         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
542 
543         string memory baseURI = _baseURI();
544         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
545     }
546 
547     function _baseURI() internal view virtual returns (string memory) {
548         return '';
549     }
550 
551     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
552         return address(uint160(_packedOwnershipOf(tokenId)));
553     }
554 
555     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
556         return _unpackedOwnership(_packedOwnershipOf(tokenId));
557     }
558 
559     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
560         return _unpackedOwnership(_packedOwnerships[index]);
561     }
562 
563     function _initializeOwnershipAt(uint256 index) internal virtual {
564         if (_packedOwnerships[index] == 0) {
565             _packedOwnerships[index] = _packedOwnershipOf(index);
566         }
567     }
568 
569     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
570         uint256 curr = tokenId;
571 
572         unchecked {
573             if (_startTokenId() <= curr)
574                 if (curr < _currentIndex) {
575                     uint256 packed = _packedOwnerships[curr];
576 
577                     if (packed & _BITMASK_BURNED == 0) {
578 
579                         while (packed == 0) {
580                             packed = _packedOwnerships[--curr];
581                         }
582                         return packed;
583                     }
584                 }
585         }
586         revert OwnerQueryForNonexistentToken();
587     }
588 
589     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
590         ownership.addr = address(uint160(packed));
591         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
592         ownership.burned = packed & _BITMASK_BURNED != 0;
593         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
594     }
595 
596     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
597         assembly {
598            
599             owner := and(owner, _BITMASK_ADDRESS)
600            
601             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
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
1035     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1036 
1037     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1038 }
1039 
1040 pragma solidity ^0.8.13;
1041 
1042 interface IOperatorFilterRegistry {
1043     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1044     function register(address registrant) external;
1045     function registerAndSubscribe(address registrant, address subscription) external;
1046     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1047     function updateOperator(address registrant, address operator, bool filtered) external;
1048     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1049     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1050     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1051     function subscribe(address registrant, address registrantToSubscribe) external;
1052     function unsubscribe(address registrant, bool copyExistingEntries) external;
1053     function subscriptionOf(address addr) external returns (address registrant);
1054     function subscribers(address registrant) external returns (address[] memory);
1055     function subscriberAt(address registrant, uint256 index) external returns (address);
1056     function copyEntriesOf(address registrant, address registrantToCopy) external;
1057     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1058     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1059     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1060     function filteredOperators(address addr) external returns (address[] memory);
1061     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1062     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1063     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1064     function isRegistered(address addr) external returns (bool);
1065     function codeHashOf(address addr) external returns (bytes32);
1066 }
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 interface IERC20 {
1071 
1072     event Transfer(address indexed from, address indexed to, uint256 value);
1073 
1074     event Approval(address indexed owner, address indexed spender, uint256 value);
1075 
1076     function totalSupply() external view returns (uint256);
1077 
1078     function balanceOf(address account) external view returns (uint256);
1079 
1080     function transfer(address to, uint256 amount) external returns (bool);
1081 
1082     function allowance(address owner, address spender) external view returns (uint256);
1083 
1084     function approve(address spender, uint256 amount) external returns (bool);
1085 
1086     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1087 }
1088 
1089 
1090 pragma solidity ^0.8.16;
1091 
1092 contract Oranges is Ownable, ERC721A, ReentrancyGuard, DefaultOperatorFilterer{
1093     string public CONTRACT_URI = "";
1094     mapping(address => uint) public userHasMinted;
1095     bool public REVEALED;
1096     string public UNREVEALED_URI = "";
1097     string public BASE_URI = "";
1098     bool public isPublicMintEnabled = false;
1099     uint public COLLECTION_SIZE = 1096; 
1100     uint public FREE_SUPPLY_PER_WALLET = 1;
1101 
1102     address public token1address = 0xBAF07C6B271886B09E975ca990c7184D064E8cB0;
1103     address public token2address = 0xE3C783d9647d72F7f13ACe64892630e7E33BC968;
1104 
1105     constructor() ERC721A("ORANGE GANG", "OG") {}
1106 
1107     function Airdrop(uint256 quantity, address receiver) public onlyOwner {
1108         require(
1109             totalSupply() + quantity <= COLLECTION_SIZE,
1110             "No more Oranges in stock!"
1111         );
1112         
1113         _safeMint(receiver, quantity);
1114     }
1115 
1116     modifier callerIsUser() {
1117         require(tx.origin == msg.sender, "The caller is another contract");
1118         _;
1119     }
1120 
1121     function mint(uint quantity)
1122         external
1123         callerIsUser 
1124         nonReentrant
1125     {
1126 
1127         uint token1 = IERC721A(token1address).balanceOf(msg.sender);
1128         uint token2 = IERC721A(token2address).balanceOf(msg.sender);
1129 
1130         require(token1 > 0 && token2 > 0);
1131 
1132         require(isPublicMintEnabled, "Mint not ready yet!");
1133         require(totalSupply() + quantity <= COLLECTION_SIZE, "No more Oranges left!");
1134 
1135         require(balanceOf(msg.sender) + quantity <= FREE_SUPPLY_PER_WALLET, "Tried to mint Oranges over limit");
1136 
1137         _safeMint(msg.sender, quantity);
1138 
1139     }
1140 
1141     function setPublicMintEnabled() public onlyOwner {
1142         isPublicMintEnabled = !isPublicMintEnabled;
1143     }
1144 
1145     function withdrawFunds() external onlyOwner nonReentrant {
1146         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1147         require(success, "Transfer failed.");
1148     }
1149 
1150     function CollectionUrI(bool _revealed, string memory _baseURI) public onlyOwner {
1151         BASE_URI = _baseURI;
1152         REVEALED = _revealed;
1153     }
1154 
1155     function contractURI() public view returns (string memory) {
1156         return CONTRACT_URI;
1157     }
1158 
1159     function setContract(string memory _contractURI) public onlyOwner {
1160         CONTRACT_URI = _contractURI;
1161     }
1162 
1163     function ChangeFreePerWallet(uint256 _new) external onlyOwner {
1164         FREE_SUPPLY_PER_WALLET = _new;
1165     }
1166 
1167     function transferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A) onlyAllowedOperator {
1168         super.transferFrom(from, to, tokenId);
1169     }
1170 
1171     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override (ERC721A) onlyAllowedOperator {
1172         super.safeTransferFrom(from, to, tokenId);
1173     }
1174 
1175     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1176         public payable
1177         override (ERC721A)
1178         onlyAllowedOperator
1179     {
1180         super.safeTransferFrom(from, to, tokenId, data);
1181     }
1182 
1183     function tokenURI(uint256 _tokenId)
1184         public
1185         view
1186         override (ERC721A)
1187         returns (string memory)
1188     {
1189         if (REVEALED) {
1190             return
1191                 string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
1192         } else {
1193             return UNREVEALED_URI;
1194         }
1195     }
1196 
1197 }