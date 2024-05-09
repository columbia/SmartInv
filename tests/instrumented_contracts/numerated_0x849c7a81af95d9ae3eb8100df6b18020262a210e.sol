1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 // ERC721A Contracts v3.3.0
5 // Creator: Chiru Labs
6 
7 interface IERC721A {
8 
9     error ApprovalCallerNotOwnerNorApproved();
10 
11     error ApprovalQueryForNonexistentToken();
12 
13     error ApproveToCaller();
14 
15     error ApprovalToCurrentOwner();
16 
17     error BalanceQueryForZeroAddress();
18 
19     error MintToZeroAddress();
20 
21     error MintZeroQuantity();
22 
23     error OwnerQueryForNonexistentToken();
24 
25     error TransferCallerNotOwnerNorApproved();
26 
27     error TransferFromIncorrectOwner();
28 
29     error TransferToNonERC721ReceiverImplementer();
30 
31     error TransferToZeroAddress();
32 
33     error URIQueryForNonexistentToken();
34 
35     struct TokenOwnership {
36         // The address of the owner.
37         address addr;
38         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
39         uint64 startTimestamp;
40         // Whether the token has been burned.
41         bool burned;
42     }
43 
44     //function totalSupply() external view returns (uint256);
45 
46     // ==============================
47     //            IERC165
48     // ==============================
49 
50     function supportsInterface(bytes4 interfaceId) external view returns (bool);
51 
52     // ==============================
53     //            IERC721
54     // ==============================
55 
56     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
57 
58     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
59 
60     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
61 
62     function balanceOf(address owner) external view returns (uint256 balance);
63 
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     function safeTransferFrom(
67         address from,
68         address to,
69         uint256 tokenId,
70         bytes calldata data
71     ) external;
72 
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     function transferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     function approve(address to, uint256 tokenId) external;
86 
87     function setApprovalForAll(address operator, bool _approved) external;
88 
89     function getApproved(uint256 tokenId) external view returns (address operator);
90 
91     function isApprovedForAll(address owner, address operator) external view returns (bool);
92 
93     // ==============================
94     //        IERC721Metadata
95     // ==============================
96 
97     function name() external view returns (string memory);
98 
99     function symbol() external view returns (string memory);
100 
101     function tokenURI(uint256 tokenId) external view returns (string memory);
102 }
103 
104 // ERC721A Contracts v3.3.0
105 // Creator: Chiru Labs
106 
107 interface ERC721A__IERC721Receiver {
108     function onERC721Received(
109         address operator,
110         address from,
111         uint256 tokenId,
112         bytes calldata data
113     ) external returns (bytes4);
114 }
115 
116 contract ERC721A is IERC721A {
117     // Mask of an entry in packed address data.
118     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
119 
120     // The bit position of `numberMinted` in packed address data.
121     uint256 private constant BITPOS_NUMBER_MINTED = 64;
122 
123     // The bit position of `numberBurned` in packed address data.
124     uint256 private constant BITPOS_NUMBER_BURNED = 128;
125 
126     // The bit position of `aux` in packed address data.
127     uint256 private constant BITPOS_AUX = 192;
128 
129     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
130     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
131 
132     // The bit position of `startTimestamp` in packed ownership.
133     uint256 private constant BITPOS_START_TIMESTAMP = 160;
134 
135     // The bit mask of the `burned` bit in packed ownership.
136     uint256 private constant BITMASK_BURNED = 1 << 224;
137 
138     // The bit position of the `nextInitialized` bit in packed ownership.
139     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
140 
141     // The bit mask of the `nextInitialized` bit in packed ownership.
142     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
143 
144     // The tokenId of the next token to be minted.
145     uint256 private _currentIndex;
146 
147     // The number of tokens burned.
148     uint256 private _burnCounter;
149 
150     // Token name
151     string private _name;
152 
153     // Token symbol
154     string private _symbol;
155 
156     // Mapping from token ID to ownership details
157     // An empty struct value does not necessarily mean the token is unowned.
158     // See `_packedOwnershipOf` implementation for details.
159     //
160     // Bits Layout:
161     // - [0..159]   `addr`
162     // - [160..223] `startTimestamp`
163     // - [224]      `burned`
164     // - [225]      `nextInitialized`
165     mapping(uint256 => uint256) private _packedOwnerships;
166 
167     // Mapping owner address to address data.
168     //
169     // Bits Layout:
170     // - [0..63]    `balance`
171     // - [64..127]  `numberMinted`
172     // - [128..191] `numberBurned`
173     // - [192..255] `aux`
174     mapping(address => uint256) private _packedAddressData;
175 
176     // Mapping from token ID to approved address.
177     mapping(uint256 => address) private _tokenApprovals;
178 
179     // Mapping from owner to operator approvals
180     mapping(address => mapping(address => bool)) private _operatorApprovals;
181 
182     constructor(string memory name_, string memory symbol_) {
183         _name = name_;
184         _symbol = symbol_;
185         _currentIndex = _startTokenId();
186     }
187 
188     function _setName(string memory name_) internal {
189         _name = name_;
190     }
191 
192     function _setSymbol(string memory symbol_) internal {
193         _symbol = symbol_;
194     }
195 
196     function _startTokenId() internal view virtual returns (uint256) {
197         return 0;
198     }
199 
200     function _nextTokenId() internal view returns (uint256) {
201         return _currentIndex;
202     }
203 
204     function totalSupply() public view virtual returns (uint256) {
205         // Counter underflow is impossible as _burnCounter cannot be incremented
206         // more than `_currentIndex - _startTokenId()` times.
207         unchecked {
208             return _currentIndex - _burnCounter - _startTokenId();
209         }
210     }
211 
212     function _totalMinted() internal view returns (uint256) {
213         // Counter underflow is impossible as _currentIndex does not decrement,
214         // and it is initialized to `_startTokenId()`
215         unchecked {
216             return _currentIndex - _startTokenId();
217         }
218     }
219 
220     function _totalBurned() internal view returns (uint256) {
221         return _burnCounter;
222     }
223 
224     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
225         // The interface IDs are constants representing the first 4 bytes of the XOR of
226         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
227         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
228         return
229             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
230             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
231             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
232     }
233 
234     function balanceOf(address owner) public view override returns (uint256) {
235         if (owner == address(0)) revert BalanceQueryForZeroAddress();
236         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
237     }
238 
239     function _numberMinted(address owner) internal view returns (uint256) {
240         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
241     }
242 
243     function _numberBurned(address owner) internal view returns (uint256) {
244         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
245     }
246 
247     function _getAux(address owner) internal view returns (uint64) {
248         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
249     }
250 
251     function _setAux(address owner, uint64 aux) internal {
252         uint256 packed = _packedAddressData[owner];
253         uint256 auxCasted;
254         assembly { // Cast aux without masking.
255             auxCasted := aux
256         }
257         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
258         _packedAddressData[owner] = packed;
259     }
260 
261     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
262         uint256 curr = tokenId;
263 
264         unchecked {
265             if (_startTokenId() <= curr)
266                 if (curr < _currentIndex) {
267                     uint256 packed = _packedOwnerships[curr];
268                     // If not burned.
269                     if (packed & BITMASK_BURNED == 0) {
270                         // Invariant:
271                         // There will always be an ownership that has an address and is not burned
272                         // before an ownership that does not have an address and is not burned.
273                         // Hence, curr will not underflow.
274                         //
275                         // We can directly compare the packed value.
276                         // If the address is zero, packed is zero.
277                         while (packed == 0) {
278                             packed = _packedOwnerships[--curr];
279                         }
280                         return packed;
281                     }
282                 }
283         }
284         revert OwnerQueryForNonexistentToken();
285     }
286 
287     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
288         ownership.addr = address(uint160(packed));
289         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
290         ownership.burned = packed & BITMASK_BURNED != 0;
291     }
292 
293     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
294         return _unpackedOwnership(_packedOwnerships[index]);
295     }
296 
297     function _initializeOwnershipAt(uint256 index) internal {
298         if (_packedOwnerships[index] == 0) {
299             _packedOwnerships[index] = _packedOwnershipOf(index);
300         }
301     }
302 
303     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
304         return _unpackedOwnership(_packedOwnershipOf(tokenId));
305     }
306 
307     function ownerOf(uint256 tokenId) public view override returns (address) {
308         return address(uint160(_packedOwnershipOf(tokenId)));
309     }
310 
311     function name() public view virtual override returns (string memory) {
312         return _name;
313     }
314 
315     function symbol() public view virtual override returns (string memory) {
316         return _symbol;
317     }
318 
319     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
320         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
321 
322         string memory baseURI = _baseURI();
323         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
324     }
325 
326     function _baseURI() internal view virtual returns (string memory) {
327         return '';
328     }
329 
330     function _addressToUint256(address value) private pure returns (uint256 result) {
331         assembly {
332             result := value
333         }
334     }
335 
336     function _boolToUint256(bool value) private pure returns (uint256 result) {
337         assembly {
338             result := value
339         }
340     }
341 
342     function approve(address to, uint256 tokenId) public override {
343         address owner = address(uint160(_packedOwnershipOf(tokenId)));
344         if (to == owner) revert ApprovalToCurrentOwner();
345 
346         if (_msgSenderERC721A() != owner)
347             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
348                 revert ApprovalCallerNotOwnerNorApproved();
349             }
350 
351         _tokenApprovals[tokenId] = to;
352         emit Approval(owner, to, tokenId);
353     }
354 
355     function getApproved(uint256 tokenId) public view override returns (address) {
356         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
357 
358         return _tokenApprovals[tokenId];
359     }
360 
361     function setApprovalForAll(address operator, bool approved) public virtual override {
362         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
363 
364         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
365         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
366     }
367 
368     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
369         return _operatorApprovals[owner][operator];
370     }
371 
372     function transferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) public virtual override {
377         _transfer(from, to, tokenId);
378     }
379 
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) public virtual override {
385         safeTransferFrom(from, to, tokenId, '');
386     }
387 
388     function safeTransferFrom(
389         address from,
390         address to,
391         uint256 tokenId,
392         bytes memory _data
393     ) public virtual override {
394         _transfer(from, to, tokenId);
395         if (to.code.length != 0)
396             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
397                 revert TransferToNonERC721ReceiverImplementer();
398             }
399     }
400 
401     function _exists(uint256 tokenId) internal view returns (bool) {
402         return
403             _startTokenId() <= tokenId &&
404             tokenId < _currentIndex && // If within bounds,
405             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
406     }
407 
408     function _safeMint(address to, uint256 quantity) internal {
409         _safeMint(to, quantity, '');
410     }
411 
412     function _safeMint(
413         address to,
414         uint256 quantity,
415         bytes memory _data
416     ) internal {
417         uint256 startTokenId = _currentIndex;
418         if (to == address(0)) revert MintToZeroAddress();
419         if (quantity == 0) revert MintZeroQuantity();
420 
421         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
422 
423         // Overflows are incredibly unrealistic.
424         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
425         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
426         unchecked {
427             // Updates:
428             // - `balance += quantity`.
429             // - `numberMinted += quantity`.
430             //
431             // We can directly add to the balance and number minted.
432             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
433 
434             // Updates:
435             // - `address` to the owner.
436             // - `startTimestamp` to the timestamp of minting.
437             // - `burned` to `false`.
438             // - `nextInitialized` to `quantity == 1`.
439             _packedOwnerships[startTokenId] =
440                 _addressToUint256(to) |
441                 (block.timestamp << BITPOS_START_TIMESTAMP) |
442                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
443 
444             uint256 updatedIndex = startTokenId;
445             uint256 end = updatedIndex + quantity;
446 
447             if (to.code.length != 0) {
448                 do {
449                     emit Transfer(address(0), to, updatedIndex);
450                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
451                         revert TransferToNonERC721ReceiverImplementer();
452                     }
453                 } while (updatedIndex < end);
454                 // Reentrancy protection
455                 if (_currentIndex != startTokenId) revert();
456             } else {
457                 do {
458                     emit Transfer(address(0), to, updatedIndex++);
459                 } while (updatedIndex < end);
460             }
461             _currentIndex = updatedIndex;
462         }
463         _afterTokenTransfers(address(0), to, startTokenId, quantity);
464     }
465 
466     function _mint(address to, uint256 quantity) internal {
467         uint256 startTokenId = _currentIndex;
468         if (to == address(0)) revert MintToZeroAddress();
469         if (quantity == 0) revert MintZeroQuantity();
470 
471         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
472 
473         // Overflows are incredibly unrealistic.
474         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
475         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
476         unchecked {
477             // Updates:
478             // - `balance += quantity`.
479             // - `numberMinted += quantity`.
480             //
481             // We can directly add to the balance and number minted.
482             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
483 
484             // Updates:
485             // - `address` to the owner.
486             // - `startTimestamp` to the timestamp of minting.
487             // - `burned` to `false`.
488             // - `nextInitialized` to `quantity == 1`.
489             _packedOwnerships[startTokenId] =
490                 _addressToUint256(to) |
491                 (block.timestamp << BITPOS_START_TIMESTAMP) |
492                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
493 
494             uint256 updatedIndex = startTokenId;
495             uint256 end = updatedIndex + quantity;
496 
497             do {
498                 emit Transfer(address(0), to, updatedIndex++);
499             } while (updatedIndex < end);
500 
501             _currentIndex = updatedIndex;
502         }
503         _afterTokenTransfers(address(0), to, startTokenId, quantity);
504     }
505 
506     function _transfer(
507         address from,
508         address to,
509         uint256 tokenId
510     ) private {
511         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
512 
513         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
514 
515         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
516             isApprovedForAll(from, _msgSenderERC721A()) ||
517             getApproved(tokenId) == _msgSenderERC721A());
518 
519         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
520         if (to == address(0)) revert TransferToZeroAddress();
521 
522         _beforeTokenTransfers(from, to, tokenId, 1);
523 
524         // Clear approvals from the previous owner.
525         delete _tokenApprovals[tokenId];
526 
527         // Underflow of the sender's balance is impossible because we check for
528         // ownership above and the recipient's balance can't realistically overflow.
529         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
530         unchecked {
531             // We can directly increment and decrement the balances.
532             --_packedAddressData[from]; // Updates: `balance -= 1`.
533             ++_packedAddressData[to]; // Updates: `balance += 1`.
534 
535             // Updates:
536             // - `address` to the next owner.
537             // - `startTimestamp` to the timestamp of transfering.
538             // - `burned` to `false`.
539             // - `nextInitialized` to `true`.
540             _packedOwnerships[tokenId] =
541                 _addressToUint256(to) |
542                 (block.timestamp << BITPOS_START_TIMESTAMP) |
543                 BITMASK_NEXT_INITIALIZED;
544 
545             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
546             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
547                 uint256 nextTokenId = tokenId + 1;
548                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
549                 if (_packedOwnerships[nextTokenId] == 0) {
550                     // If the next slot is within bounds.
551                     if (nextTokenId != _currentIndex) {
552                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
553                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
554                     }
555                 }
556             }
557         }
558 
559         emit Transfer(from, to, tokenId);
560         _afterTokenTransfers(from, to, tokenId, 1);
561     }
562 
563     function _burn(uint256 tokenId) internal virtual {
564         _burn(tokenId, false);
565     }
566 
567     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
568         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
569 
570         address from = address(uint160(prevOwnershipPacked));
571 
572         if (approvalCheck) {
573             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
574                 isApprovedForAll(from, _msgSenderERC721A()) ||
575                 getApproved(tokenId) == _msgSenderERC721A());
576 
577             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
578         }
579 
580         _beforeTokenTransfers(from, address(0), tokenId, 1);
581 
582         // Clear approvals from the previous owner.
583         delete _tokenApprovals[tokenId];
584 
585         // Underflow of the sender's balance is impossible because we check for
586         // ownership above and the recipient's balance can't realistically overflow.
587         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
588         unchecked {
589             // Updates:
590             // - `balance -= 1`.
591             // - `numberBurned += 1`.
592             //
593             // We can directly decrement the balance, and increment the number burned.
594             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
595             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
596 
597             // Updates:
598             // - `address` to the last owner.
599             // - `startTimestamp` to the timestamp of burning.
600             // - `burned` to `true`.
601             // - `nextInitialized` to `true`.
602             _packedOwnerships[tokenId] =
603                 _addressToUint256(from) |
604                 (block.timestamp << BITPOS_START_TIMESTAMP) |
605                 BITMASK_BURNED |
606 
607                 BITMASK_NEXT_INITIALIZED;
608 
609             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
610             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
611                 uint256 nextTokenId = tokenId + 1;
612                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
613                 if (_packedOwnerships[nextTokenId] == 0) {
614                     // If the next slot is within bounds.
615                     if (nextTokenId != _currentIndex) {
616                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
617                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
618                     }
619                 }
620             }
621         }
622 
623         emit Transfer(from, address(0), tokenId);
624         _afterTokenTransfers(from, address(0), tokenId, 1);
625 
626         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
627         unchecked {
628             _burnCounter++;
629         }
630     }
631 
632     function _checkContractOnERC721Received(
633         address from,
634         address to,
635         uint256 tokenId,
636         bytes memory _data
637     ) private returns (bool) {
638         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
639             bytes4 retval
640         ) {
641             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
642         } catch (bytes memory reason) {
643             if (reason.length == 0) {
644                 revert TransferToNonERC721ReceiverImplementer();
645             } else {
646                 assembly {
647                     revert(add(32, reason), mload(reason))
648                 }
649             }
650         }
651     }
652 
653     function _beforeTokenTransfers(
654         address from,
655         address to,
656         uint256 startTokenId,
657         uint256 quantity
658     ) internal virtual {}
659 
660     function _afterTokenTransfers(
661         address from,
662         address to,
663         uint256 startTokenId,
664         uint256 quantity
665     ) internal virtual {}
666 
667     function _msgSenderERC721A() internal view virtual returns (address) {
668         return msg.sender;
669     }
670 
671     function _toString(uint256 value) internal pure returns (string memory ptr) {
672         assembly {
673             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
674 
675             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
676             // We will need 1 32-byte word to store the length,
677 
678             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
679             ptr := add(mload(0x40), 128)
680             // Update the free memory pointer to allocate.
681             mstore(0x40, ptr)
682 
683             // Cache the end of the memory to calculate the length later.
684             let end := ptr
685 
686             // We write the string from the rightmost digit to the leftmost digit.
687             // The following is essentially a do-while loop that also handles the zero case.
688             // Costs a bit more than early returning for the zero case,
689             // but cheaper in terms of deployment and overall runtime costs.
690             for {
691 
692                 // Initialize and perform the first pass without check.
693                 let temp := value
694                 // Move the pointer 1 byte leftwards to point to an empty character slot.
695                 ptr := sub(ptr, 1)
696                 // Write the character to the pointer. 48 is the ASCII index of '0'.
697                 mstore8(ptr, add(48, mod(temp, 10)))
698                 temp := div(temp, 10)
699             } temp {
700 
701                 // Keep dividing `temp` until zero.
702                 temp := div(temp, 10)
703             } { // Body of the for loop.
704                 ptr := sub(ptr, 1)
705                 mstore8(ptr, add(48, mod(temp, 10)))
706             }
707 
708             let length := sub(end, ptr)
709             // Move the pointer 32 bytes leftwards to make room for the length.
710             ptr := sub(ptr, 32)
711             // Store the length.
712             mstore(ptr, length)
713         }
714     }
715 }
716 
717 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
718 
719 abstract contract Context {
720     function _msgSender() internal view virtual returns (address) {
721         return msg.sender;
722     }
723 
724     function _msgData() internal view virtual returns (bytes calldata) {
725         return msg.data;
726     }
727 }
728 
729 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
730 
731 abstract contract Ownable is Context {
732     address private _owner;
733 
734     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
735 
736     constructor() {
737         _transferOwnership(_msgSender());
738     }
739 
740     function owner() public view virtual returns (address) {
741         return _owner;
742     }
743 
744     modifier onlyOwner() {
745         require(owner() == _msgSender(), "Ownable: caller is not the owner");
746         _;
747     }
748 
749     function renounceOwnership() public virtual onlyOwner {
750         _transferOwnership(address(0));
751     }
752 
753     function transferOwnership(address newOwner) public virtual onlyOwner {
754         require(newOwner != address(0), "Ownable: new owner is the zero address");
755         _transferOwnership(newOwner);
756     }
757 
758     function _transferOwnership(address newOwner) internal virtual {
759         address oldOwner = _owner;
760         _owner = newOwner;
761         emit OwnershipTransferred(oldOwner, newOwner);
762     }
763 }
764 
765 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
766 
767 library Strings {
768     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
769 
770     function toString(uint256 value) internal pure returns (string memory) {
771         // Inspired by OraclizeAPI's implementation - MIT licence
772         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
773 
774         if (value == 0) {
775             return "0";
776         }
777         uint256 temp = value;
778         uint256 digits;
779         while (temp != 0) {
780             digits++;
781             temp /= 10;
782         }
783         bytes memory buffer = new bytes(digits);
784         while (value != 0) {
785             digits -= 1;
786             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
787             value /= 10;
788         }
789         return string(buffer);
790     }
791 
792     function toHexString(uint256 value) internal pure returns (string memory) {
793         if (value == 0) {
794             return "0x00";
795         }
796         uint256 temp = value;
797         uint256 length = 0;
798         while (temp != 0) {
799             length++;
800             temp >>= 8;
801         }
802         return toHexString(value, length);
803     }
804 
805     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
806         bytes memory buffer = new bytes(2 * length + 2);
807         buffer[0] = "0";
808         buffer[1] = "x";
809         for (uint256 i = 2 * length + 1; i > 1; --i) {
810             buffer[i] = _HEX_SYMBOLS[value & 0xf];
811             value >>= 4;
812         }
813         require(value == 0, "Strings: hex length insufficient");
814         return string(buffer);
815     }
816 }
817 
818 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
819 
820 library Address {
821 
822     function isContract(address account) internal view returns (bool) {
823         // This method relies on extcodesize/address.code.length, which returns 0
824         // for contracts in construction, since the code is only stored at the end
825         // of the constructor execution.
826 
827         return account.code.length > 0;
828     }
829 
830     function sendValue(address payable recipient, uint256 amount) internal {
831         require(address(this).balance >= amount, "Address: insufficient balance");
832 
833         (bool success, ) = recipient.call{value: amount}("");
834         require(success, "Address: unable to send value, recipient may have reverted");
835     }
836 
837     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
838         return functionCall(target, data, "Address: low-level call failed");
839     }
840 
841     function functionCall(
842         address target,
843         bytes memory data,
844         string memory errorMessage
845     ) internal returns (bytes memory) {
846         return functionCallWithValue(target, data, 0, errorMessage);
847     }
848 
849     function functionCallWithValue(
850         address target,
851         bytes memory data,
852         uint256 value
853     ) internal returns (bytes memory) {
854         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
855     }
856 
857     function functionCallWithValue(
858         address target,
859         bytes memory data,
860         uint256 value,
861         string memory errorMessage
862     ) internal returns (bytes memory) {
863         require(address(this).balance >= value, "Address: insufficient balance for call");
864         require(isContract(target), "Address: call to non-contract");
865 
866         (bool success, bytes memory returndata) = target.call{value: value}(data);
867         return verifyCallResult(success, returndata, errorMessage);
868     }
869 
870     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
871         return functionStaticCall(target, data, "Address: low-level static call failed");
872     }
873 
874     function functionStaticCall(
875         address target,
876         bytes memory data,
877         string memory errorMessage
878     ) internal view returns (bytes memory) {
879         require(isContract(target), "Address: static call to non-contract");
880 
881         (bool success, bytes memory returndata) = target.staticcall(data);
882         return verifyCallResult(success, returndata, errorMessage);
883     }
884 
885     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
886         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
887     }
888 
889     function functionDelegateCall(
890         address target,
891         bytes memory data,
892         string memory errorMessage
893     ) internal returns (bytes memory) {
894         require(isContract(target), "Address: delegate call to non-contract");
895 
896         (bool success, bytes memory returndata) = target.delegatecall(data);
897         return verifyCallResult(success, returndata, errorMessage);
898     }
899 
900     function verifyCallResult(
901         bool success,
902         bytes memory returndata,
903         string memory errorMessage
904     ) internal pure returns (bytes memory) {
905         if (success) {
906             return returndata;
907         } else {
908             // Look for revert reason and bubble it up if present
909             if (returndata.length > 0) {
910                 // The easiest way to bubble the revert reason is using memory via assembly
911 
912                 assembly {
913                     let returndata_size := mload(returndata)
914                     revert(add(32, returndata), returndata_size)
915                 }
916             } else {
917                 revert(errorMessage);
918             }
919         }
920     }
921 }
922 
923 //(/|  |^ )(\*)(.+|) \s+\n \n\n
924 contract Darkbirds is ERC721A, Ownable {
925     using Address for address;
926     using Strings for uint256;
927 
928     uint256 private maxTokens;
929     uint256 private _maxFreeMints;
930 
931     uint256 private _currentFreeMints;
932 
933     bool private _saleEnabled = false;
934     bool private _freeMintEnabled = false;
935 
936     string private _contractURI;
937     string  private _baseTokenURI;
938 
939     uint256 price = 1 ether;
940 
941     mapping (address => uint256) freeMints;
942 
943     constructor(uint256 maxTokens_, bool saleEnabled_, bool freeMintEnabled_, string memory baseURI_, uint256 maxFreeMints_, uint256 price_) ERC721A("Darkbirds","Darkbird") {
944         maxTokens = maxTokens_;
945         _saleEnabled = saleEnabled_;
946         _freeMintEnabled = freeMintEnabled_;
947         _baseTokenURI = baseURI_;
948         _maxFreeMints = maxFreeMints_;
949         price = price_;
950     }
951 
952     function hasFreeMint(address target) public view returns(bool){
953         return _freeMintEnabled && freeMints[target] < 1 && _currentFreeMints < _maxFreeMints;
954     }
955 
956     function freeMintEnabled() external view returns(bool){
957         return _freeMintEnabled;
958     }
959 
960     function freeMintSet(bool v) external onlyOwner {
961         _freeMintEnabled = v;
962     }
963 
964     function saleEnabled() external view returns(bool){
965         return _saleEnabled;
966     }
967 
968     function saleSet(bool v) external onlyOwner {
969         _saleEnabled = v;
970     }
971 
972     function getMaxTokens()  external view returns(uint256) {
973         return maxTokens;
974     }
975 
976     function totalSupply() public view override returns(uint256) {
977         return _totalMinted();
978     }
979 
980     function setPrice(uint256 price_) external onlyOwner {
981         price = price_;
982     }
983 
984     function setMaxTokens(uint256 _maxTokens) external onlyOwner {
985         maxTokens = _maxTokens;
986     }
987 
988     function setMaxFreeMints(uint256 maxFreeMints_) external onlyOwner {
989         _maxFreeMints = maxFreeMints_;
990     }
991 
992     function mintTo(address _to, uint256 amount) external onlyOwner {
993         require(tokensAvailable() >= amount, "Max tokens reached");
994         _safeMint(_to, amount);
995     }
996 
997     function mintBirds(uint256 amount) external payable {
998         require(_saleEnabled, "Sale off");
999         require(msg.value >= amount*price, "Insufficient value to mint");
1000         require(tokensAvailable() >= amount, "Max tokens reached");
1001         _safeMint(msg.sender, amount);
1002     }
1003 
1004     function freeBird() external {
1005         require(_freeMintEnabled, "Free mint off");
1006         require(freeMints[msg.sender] < 1, "You reached max free tokens");
1007         require(_currentFreeMints < _maxFreeMints, "You reached max free tokens");
1008         _safeMint(msg.sender, 1);
1009         freeMints[msg.sender] += 1;
1010         _currentFreeMints += 1;
1011     }
1012 
1013     function contractURI() public view returns (string memory) {
1014     	return _contractURI;
1015     }
1016 
1017     function withdraw() external onlyOwner
1018     {
1019         Address.sendValue(payable(msg.sender), address(this).balance);
1020     }
1021 
1022     function tokensAvailable() public view returns (uint256) {
1023         return maxTokens - _totalMinted();
1024     }
1025 
1026     function currentFreeMints() public view returns (uint256) {
1027         return _maxFreeMints - _currentFreeMints;
1028     }
1029 
1030     function _baseURI() internal view override  returns (string memory) {
1031         return _baseTokenURI;
1032     }
1033 
1034     function setBaseURI(string memory uri) external onlyOwner {
1035         _baseTokenURI = uri;
1036     }
1037 
1038     function setContractURI(string memory uri) external onlyOwner {
1039         _contractURI = uri;
1040     }
1041 
1042     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1043         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1044         string memory baseURI = _baseURI();
1045         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1046     }
1047 
1048     function URI(uint256 tokenId) external view virtual returns (string memory) {
1049         return tokenURI(tokenId);
1050     }
1051 }