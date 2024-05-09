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
606                 BITMASK_NEXT_INITIALIZED;
607 
608             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
609             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
610                 uint256 nextTokenId = tokenId + 1;
611                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
612                 if (_packedOwnerships[nextTokenId] == 0) {
613                     // If the next slot is within bounds.
614                     if (nextTokenId != _currentIndex) {
615                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
616                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
617                     }
618                 }
619             }
620         }
621 
622         emit Transfer(from, address(0), tokenId);
623         _afterTokenTransfers(from, address(0), tokenId, 1);
624 
625         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
626         unchecked {
627             _burnCounter++;
628         }
629     }
630 
631     function _checkContractOnERC721Received(
632         address from,
633         address to,
634         uint256 tokenId,
635         bytes memory _data
636     ) private returns (bool) {
637         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
638             bytes4 retval
639         ) {
640             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
641         } catch (bytes memory reason) {
642             if (reason.length == 0) {
643                 revert TransferToNonERC721ReceiverImplementer();
644             } else {
645                 assembly {
646                     revert(add(32, reason), mload(reason))
647                 }
648             }
649         }
650     }
651 
652     function _beforeTokenTransfers(
653         address from,
654         address to,
655         uint256 startTokenId,
656         uint256 quantity
657     ) internal virtual {}
658 
659     function _afterTokenTransfers(
660         address from,
661         address to,
662         uint256 startTokenId,
663         uint256 quantity
664     ) internal virtual {}
665 
666     function _msgSenderERC721A() internal view virtual returns (address) {
667         return msg.sender;
668     }
669 
670     function _toString(uint256 value) internal pure returns (string memory ptr) {
671         assembly {
672             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
673             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
674             // We will need 1 32-byte word to store the length, 
675             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
676             ptr := add(mload(0x40), 128)
677             // Update the free memory pointer to allocate.
678             mstore(0x40, ptr)
679 
680             // Cache the end of the memory to calculate the length later.
681             let end := ptr
682 
683             // We write the string from the rightmost digit to the leftmost digit.
684             // The following is essentially a do-while loop that also handles the zero case.
685             // Costs a bit more than early returning for the zero case,
686             // but cheaper in terms of deployment and overall runtime costs.
687             for { 
688                 // Initialize and perform the first pass without check.
689                 let temp := value
690                 // Move the pointer 1 byte leftwards to point to an empty character slot.
691                 ptr := sub(ptr, 1)
692                 // Write the character to the pointer. 48 is the ASCII index of '0'.
693                 mstore8(ptr, add(48, mod(temp, 10)))
694                 temp := div(temp, 10)
695             } temp { 
696                 // Keep dividing `temp` until zero.
697                 temp := div(temp, 10)
698             } { // Body of the for loop.
699                 ptr := sub(ptr, 1)
700                 mstore8(ptr, add(48, mod(temp, 10)))
701             }
702 
703             let length := sub(end, ptr)
704             // Move the pointer 32 bytes leftwards to make room for the length.
705             ptr := sub(ptr, 32)
706             // Store the length.
707             mstore(ptr, length)
708         }
709     }
710 }
711 
712 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
713 
714 abstract contract Context {
715     function _msgSender() internal view virtual returns (address) {
716         return msg.sender;
717     }
718 
719     function _msgData() internal view virtual returns (bytes calldata) {
720         return msg.data;
721     }
722 }
723 
724 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
725 
726 abstract contract Ownable is Context {
727     address private _owner;
728 
729     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
730 
731     constructor() {
732         _transferOwnership(_msgSender());
733     }
734 
735     function owner() public view virtual returns (address) {
736         return _owner;
737     }
738 
739     modifier onlyOwner() {
740         require(owner() == _msgSender(), "Ownable: caller is not the owner");
741         _;
742     }
743 
744     function renounceOwnership() public virtual onlyOwner {
745         _transferOwnership(address(0));
746     }
747 
748     function transferOwnership(address newOwner) public virtual onlyOwner {
749         require(newOwner != address(0), "Ownable: new owner is the zero address");
750         _transferOwnership(newOwner);
751     }
752 
753     function _transferOwnership(address newOwner) internal virtual {
754         address oldOwner = _owner;
755         _owner = newOwner;
756         emit OwnershipTransferred(oldOwner, newOwner);
757     }
758 }
759 
760 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
761 
762 library Strings {
763     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
764 
765     function toString(uint256 value) internal pure returns (string memory) {
766         // Inspired by OraclizeAPI's implementation - MIT licence
767         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
768 
769         if (value == 0) {
770             return "0";
771         }
772         uint256 temp = value;
773         uint256 digits;
774         while (temp != 0) {
775             digits++;
776             temp /= 10;
777         }
778         bytes memory buffer = new bytes(digits);
779         while (value != 0) {
780             digits -= 1;
781             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
782             value /= 10;
783         }
784         return string(buffer);
785     }
786 
787     function toHexString(uint256 value) internal pure returns (string memory) {
788         if (value == 0) {
789             return "0x00";
790         }
791         uint256 temp = value;
792         uint256 length = 0;
793         while (temp != 0) {
794             length++;
795             temp >>= 8;
796         }
797         return toHexString(value, length);
798     }
799 
800     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
801         bytes memory buffer = new bytes(2 * length + 2);
802         buffer[0] = "0";
803         buffer[1] = "x";
804         for (uint256 i = 2 * length + 1; i > 1; --i) {
805             buffer[i] = _HEX_SYMBOLS[value & 0xf];
806             value >>= 4;
807         }
808         require(value == 0, "Strings: hex length insufficient");
809         return string(buffer);
810     }
811 }
812 
813 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
814 
815 library Address {
816 
817     function isContract(address account) internal view returns (bool) {
818         // This method relies on extcodesize/address.code.length, which returns 0
819         // for contracts in construction, since the code is only stored at the end
820         // of the constructor execution.
821 
822         return account.code.length > 0;
823     }
824 
825     function sendValue(address payable recipient, uint256 amount) internal {
826         require(address(this).balance >= amount, "Address: insufficient balance");
827 
828         (bool success, ) = recipient.call{value: amount}("");
829         require(success, "Address: unable to send value, recipient may have reverted");
830     }
831 
832     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
833         return functionCall(target, data, "Address: low-level call failed");
834     }
835 
836     function functionCall(
837         address target,
838         bytes memory data,
839         string memory errorMessage
840     ) internal returns (bytes memory) {
841         return functionCallWithValue(target, data, 0, errorMessage);
842     }
843 
844     function functionCallWithValue(
845         address target,
846         bytes memory data,
847         uint256 value
848     ) internal returns (bytes memory) {
849         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
850     }
851 
852     function functionCallWithValue(
853         address target,
854         bytes memory data,
855         uint256 value,
856         string memory errorMessage
857     ) internal returns (bytes memory) {
858         require(address(this).balance >= value, "Address: insufficient balance for call");
859         require(isContract(target), "Address: call to non-contract");
860 
861         (bool success, bytes memory returndata) = target.call{value: value}(data);
862         return verifyCallResult(success, returndata, errorMessage);
863     }
864 
865     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
866         return functionStaticCall(target, data, "Address: low-level static call failed");
867     }
868 
869     function functionStaticCall(
870         address target,
871         bytes memory data,
872         string memory errorMessage
873     ) internal view returns (bytes memory) {
874         require(isContract(target), "Address: static call to non-contract");
875 
876         (bool success, bytes memory returndata) = target.staticcall(data);
877         return verifyCallResult(success, returndata, errorMessage);
878     }
879 
880     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
881         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
882     }
883 
884     function functionDelegateCall(
885         address target,
886         bytes memory data,
887         string memory errorMessage
888     ) internal returns (bytes memory) {
889         require(isContract(target), "Address: delegate call to non-contract");
890 
891         (bool success, bytes memory returndata) = target.delegatecall(data);
892         return verifyCallResult(success, returndata, errorMessage);
893     }
894 
895     function verifyCallResult(
896         bool success,
897         bytes memory returndata,
898         string memory errorMessage
899     ) internal pure returns (bytes memory) {
900         if (success) {
901             return returndata;
902         } else {
903             // Look for revert reason and bubble it up if present
904             if (returndata.length > 0) {
905                 // The easiest way to bubble the revert reason is using memory via assembly
906 
907                 assembly {
908                     let returndata_size := mload(returndata)
909                     revert(add(32, returndata), returndata_size)
910                 }
911             } else {
912                 revert(errorMessage);
913             }
914         }
915     }
916 }
917 
918 contract Apesons is ERC721A, Ownable {
919     using Address for address;
920     using Strings for uint256;
921 
922     uint256 private maxTokens;
923 
924     mapping(uint256 => string) private customTokensURIs;
925 
926     bool private _saleEnabled = false;
927 
928     bool private _freeMintEnabled = false;
929 
930     uint256 private _maxMintForUser;
931 
932     uint256 private _maxFreeMints;
933 
934     uint256 private _currentFreeMints;
935 
936     string private _contractURI;
937     string  private _baseTokenURI;
938 
939     uint256 price = 1 ether;
940 
941     mapping (address => uint256) freeMints;
942 
943     constructor(uint256 maxTokens_, bool saleEnabled_, bool freeMintEnabled_, string memory baseURI_, uint256 maxMintForUser_, uint256 maxFreeMints_, uint256 price_) ERC721A("Apesons","Apesons") {
944         maxTokens = maxTokens_;
945 
946         _saleEnabled = saleEnabled_;
947 
948         _freeMintEnabled = freeMintEnabled_;
949 
950         _baseTokenURI = baseURI_;
951 
952         _maxMintForUser = maxMintForUser_;
953 
954         _maxFreeMints = maxFreeMints_;
955 
956         price = price_;
957     }
958 
959     function setMaxTokens(uint256 _maxTokens) external onlyOwner {
960         maxTokens = _maxTokens;
961     }
962 
963     function setLimitFreeMintForUser(uint256 maxMintForUser_) external onlyOwner {
964         _maxMintForUser = maxMintForUser_;
965     }
966 
967     function setMaxFreeMints(uint256 maxFreeMints_) external onlyOwner {
968         _maxFreeMints = maxFreeMints_;
969     }
970 
971     function getMaxTokens()  external view returns(uint256) {
972         return maxTokens;
973     }
974 
975     function hasFreeMint(address target) public view returns(bool){
976         return _freeMintEnabled && freeMints[target] < _maxMintForUser && _currentFreeMints < _maxFreeMints;
977     }
978 
979     function freeMintEnabled() external view returns(bool){
980         return _freeMintEnabled;
981     }
982 
983     function freeMintSet(bool v) external onlyOwner {
984         _freeMintEnabled = v;
985     }
986 
987     function saleEnabled() external view returns(bool){
988         return _saleEnabled;
989     }
990 
991     function saleSet(bool v) external onlyOwner {
992         _saleEnabled = v;
993     }
994 
995     function totalSupply() public view override returns(uint256) {
996         return _totalMinted();
997     }
998 
999     function setPrice(uint256 price_) external onlyOwner {
1000         price = price_;
1001     }
1002 
1003     function mintTo(address _to, uint256 count) external onlyOwner {
1004         require(tokensAvailable() >= count, "Max tokens reached");
1005         _safeMint(_to, count);
1006     }
1007 
1008     function mint(uint256 count) external payable {
1009         require(_saleEnabled, "Sale off");
1010         require(msg.value >= count*price, "Insufficient value to mint");
1011         require(tokensAvailable() >= count, "Max tokens reached");
1012         _safeMint(msg.sender, count);
1013     }
1014 
1015     function freeMint(uint256 count) external {
1016         require(_freeMintEnabled, "Free mint off");
1017         require(freeMints[msg.sender] + count <= _maxMintForUser, "You have max tokens");
1018         require(_currentFreeMints + count <= _maxFreeMints, "You have max tokens");
1019         _safeMint(msg.sender, count);
1020         freeMints[msg.sender] += count;
1021         _currentFreeMints += count;
1022     }
1023 
1024     function contractURI() public view returns (string memory) {
1025     	return _contractURI;
1026     }
1027 
1028     function withdraw() external onlyOwner
1029     {
1030         Address.sendValue(payable(msg.sender), address(this).balance);
1031     }
1032 
1033     function tokensAvailable() public view returns (uint256) {
1034         return maxTokens - _totalMinted();
1035     }
1036 
1037     function currentFreeMints() public view returns (uint256) {
1038         return _maxFreeMints - _currentFreeMints;
1039     }
1040 
1041     function _baseURI() internal view override  returns (string memory) {
1042         return _baseTokenURI;
1043     }
1044 
1045     function setBaseURI(string memory uri) external onlyOwner {
1046         _baseTokenURI = uri;
1047     }
1048 
1049     function setContractURI(string memory uri) external onlyOwner {
1050         _contractURI = uri;
1051     }
1052 
1053     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1054         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1055         if(bytes(customTokensURIs[tokenId]).length != 0) return customTokensURIs[tokenId];
1056         string memory baseURI = _baseURI();
1057         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1058     }
1059 
1060     function URI(uint256 tokenId) external view virtual returns (string memory) {
1061         return tokenURI(tokenId);
1062     }
1063 }