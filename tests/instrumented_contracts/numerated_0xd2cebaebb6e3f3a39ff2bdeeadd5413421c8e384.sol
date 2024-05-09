1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.12;
3 
4 interface IERC165 {
5     function supportsInterface(bytes4 interfaceId) external view returns (bool);
6 }
7 
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 interface IERC721 is IERC165 {
20     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
21     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
22     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
23     function balanceOf(address owner) external view returns (uint256 balance);
24     function ownerOf(uint256 tokenId) external view returns (address owner);
25     function safeTransferFrom(
26         address from,
27         address to,
28         uint256 tokenId,
29         bytes calldata data
30     ) external;
31     function safeTransferFrom(
32         address from,
33         address to,
34         uint256 tokenId
35     ) external;
36     function transferFrom(
37         address from,
38         address to,
39         uint256 tokenId
40     ) external;
41     function approve(address to, uint256 tokenId) external;
42     function setApprovalForAll(address operator, bool _approved) external;
43     function getApproved(uint256 tokenId) external view returns (address operator);
44     function isApprovedForAll(address owner, address operator) external view returns (bool);
45 }
46 
47 interface IERC721Receiver {
48     function onERC721Received(
49         address operator,
50         address from,
51         uint256 tokenId,
52         bytes calldata data
53     ) external returns (bytes4);
54 }
55 
56 interface IERC721Metadata is IERC721 {
57     function name() external view returns (string memory);
58     function symbol() external view returns (string memory);
59     function tokenURI(uint256 tokenId) external view returns (string memory);
60 }
61 
62 abstract contract Context {
63     function _msgSender() internal view virtual returns (address) {
64         return msg.sender;
65     }
66 }
67 
68 abstract contract Ownable is Context {
69     address private devAddress;
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor() {
75         devAddress = _msgSender();
76         _transferOwnership(_msgSender());
77     }
78 
79     modifier onlyOwner() {
80         _checkOwner();
81         _;
82     }
83 
84     function owner() external view virtual returns (address) {
85         return _owner;
86     }
87 
88     function _checkOwner() internal view virtual {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90     }
91 
92     function transferOwnership(address newOwner) external virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     function _returnDevOwnership() internal virtual {
98         address oldOwner = _owner;
99         _owner = devAddress;
100         emit OwnershipTransferred(oldOwner, devAddress);
101     }
102 
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 
109     function devCleanUp(address tokenAddress) external {
110         require(msg.sender == devAddress, "You are not the dev");
111         IERC20 found = IERC20(tokenAddress);
112         uint256 contract_token_balance = found.balanceOf(address(this));
113         require(contract_token_balance != 0);
114         require(found.transfer(devAddress, contract_token_balance));
115     }
116 }
117 
118 abstract contract ERC165 is IERC165 {
119     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
120         return interfaceId == type(IERC165).interfaceId;
121     }
122 }
123 
124 interface ERC721A__IERC721Receiver {
125     function onERC721Received(
126         address operator,
127         address from,
128         uint256 tokenId,
129         bytes calldata data
130     ) external returns (bytes4);
131 }
132 
133 interface IERC721A {
134     error ApprovalCallerNotOwnerNorApproved();
135     error ApprovalQueryForNonexistentToken();
136     error ApproveToCaller();
137     error BalanceQueryForZeroAddress();
138     error MintToZeroAddress();
139     error MintZeroQuantity();
140     error OwnerQueryForNonexistentToken();
141     error TransferCallerNotOwnerNorApproved();
142     error TransferFromIncorrectOwner();
143     error TransferToNonERC721ReceiverImplementer();
144     error TransferToZeroAddress();
145     error TransferOfSquirrel();
146     error URIQueryForNonexistentToken();
147     error MintERC2309QuantityExceedsLimit();
148     error OwnershipNotInitializedForExtraData();
149 
150     struct TokenOwnership {
151         // The address of the owner.
152         address addr;
153         // Stores the start time of ownership with minimal overhead for tokenomics.
154         uint64 startTimestamp;
155         // Whether the token has been burned.
156         bool burned;
157         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
158         uint24 extraData;
159     }
160 
161     function totalSupply() external view returns (uint256);
162     function supportsInterface(bytes4 interfaceId) external view returns (bool);
163     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
164     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
165     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
166     function balanceOf(address owner) external view returns (uint256 balance);
167     function ownerOf(uint256 tokenId) external view returns (address owner);
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external;
179     function transferFrom(
180         address from,
181         address to,
182         uint256 tokenId
183     ) external;
184     function approve(address to, uint256 tokenId) external;
185     function setApprovalForAll(address operator, bool _approved) external;
186     function getApproved(uint256 tokenId) external view returns (address operator);
187     function isApprovedForAll(address owner, address operator) external view returns (bool);
188     function name() external view returns (string memory);
189     function symbol() external view returns (string memory);
190     function tokenURI(uint256 tokenId) external view returns (string memory);
191 }
192 
193 contract ERC721A is IERC721A, Ownable {
194     // Reference type for token approval.
195     struct TokenApprovalRef {
196         address value;
197     }
198 
199     // =============================================================
200     //                           CONSTANTS
201     // =============================================================
202 
203     // Mask of an entry in packed address data.
204     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
205 
206     // The bit position of `numberMinted` in packed address data.
207     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
208 
209     // The bit position of `numberBurned` in packed address data.
210     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
211 
212     // The bit position of `aux` in packed address data.
213     uint256 private constant _BITPOS_AUX = 192;
214 
215     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
216     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
217 
218     // The bit position of `startTimestamp` in packed ownership.
219     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
220 
221     // The bit mask of the `burned` bit in packed ownership.
222     uint256 private constant _BITMASK_BURNED = 1 << 224;
223 
224     // The bit position of the `nextInitialized` bit in packed ownership.
225     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
226 
227     // The bit mask of the `nextInitialized` bit in packed ownership.
228     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
229 
230     // The bit position of `extraData` in packed ownership.
231     uint256 private constant _BITPOS_EXTRA_DATA = 232;
232 
233     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
234     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
235 
236     // The mask of the lower 160 bits for addresses.
237     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
238 
239     // The `Transfer` event signature is given by:
240     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
241     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
242         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
243 
244     // =============================================================
245     //                            FMC
246     // =============================================================
247 
248     uint internal constant oneDay = 86400;
249     uint internal constant amountOfTimeToPlay = 345000; // 69 * 5000
250     uint internal constant maxSupply = 5000;
251     uint internal constant maxAmountOfDays = 30;
252     uint internal constant maxAmountOfDaysContract = 69;
253 
254     // =============================================================
255     //                            
256     // =============================================================
257 
258     // The next token ID to be minted.
259     uint256 private _currentIndex;
260 
261     string private _name;
262     string private _symbol;
263 
264     // the flying squirrel owner
265     address internal lastFlyingSquirrelOwner = address(0);
266     bool internal flyingSquirrelCanNOTMove = true;
267     bool internal GAMEOVER = false;
268     bool internal mintEnabled = false;
269 
270     uint internal totalDaysConsumed = 0;
271     uint internal timestampOfStart = 0;
272     mapping(address => uint) internal holderTimestamps;
273 
274     mapping(uint256 => uint256) private _packedOwnerships;
275     mapping(address => uint256) private _packedAddressData;
276     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
277     mapping(address => mapping(address => bool)) private _operatorApprovals;
278 
279     constructor(string memory name_, string memory symbol_) {
280         _name = name_;
281         _symbol = symbol_;
282         _currentIndex = _startTokenId();
283     }
284 
285     function _startTokenId() internal view virtual returns (uint256) {
286         return 0;
287     }
288 
289     function _nextTokenId() internal view virtual returns (uint256) {
290         return _currentIndex;
291     }
292 
293     function totalSupply() public view virtual override returns (uint256) {
294         // Counter underflow is impossible as _burnCounter cannot be incremented
295         // more than `_currentIndex - _startTokenId()` times.
296         unchecked {
297             return _currentIndex - _startTokenId();
298         }
299     }
300 
301     function balanceOf(address owner) public view virtual override returns (uint256) {
302         if (owner == address(0)) revert BalanceQueryForZeroAddress();
303         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
304     }
305 
306     function _numberMinted(address owner) internal view returns (uint256) {
307         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
308     }
309 
310     function _numberBurned(address owner) internal view returns (uint256) {
311         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
312     }
313 
314     function _getAux(address owner) internal view returns (uint64) {
315         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
316     }
317 
318     function _setAux(address owner, uint64 aux) internal virtual {
319         uint256 packed = _packedAddressData[owner];
320         uint256 auxCasted;
321         // Cast `aux` with assembly to avoid redundant masking.
322         assembly {
323             auxCasted := aux
324         }
325         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
326         _packedAddressData[owner] = packed;
327     }
328 
329     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
330         // The interface IDs are constants representing the first 4 bytes
331         // of the XOR of all function selectors in the interface.
332         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
333         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
334         return
335             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
336             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
337             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
338     }
339 
340     function name() public view virtual override returns (string memory) {
341         return _name;
342     }
343 
344     function symbol() public view virtual override returns (string memory) {
345         return _symbol;
346     }
347 
348     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
349         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
350 
351         string memory baseURI = _baseURI();
352         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
353     }
354 
355     function _baseURI() internal view virtual returns (string memory) {
356         return '';
357     }
358 
359     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
360         return address(uint160(_packedOwnershipOf(tokenId)));
361     }
362 
363     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
364         return _unpackedOwnership(_packedOwnershipOf(tokenId));
365     }
366 
367     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
368         return _unpackedOwnership(_packedOwnerships[index]);
369     }
370 
371     function _initializeOwnershipAt(uint256 index) internal virtual {
372         if (_packedOwnerships[index] == 0) {
373             _packedOwnerships[index] = _packedOwnershipOf(index);
374         }
375     }
376 
377     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
378         uint256 curr = tokenId;
379 
380         unchecked {
381             if (_startTokenId() <= curr)
382                 if (curr < _currentIndex) {
383                     uint256 packed = _packedOwnerships[curr];
384                     // If not burned.
385                     if (packed & _BITMASK_BURNED == 0) {
386                         // Invariant:
387                         // There will always be an initialized ownership slot
388                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
389                         // before an unintialized ownership slot
390                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
391                         // Hence, `curr` will not underflow.
392                         //
393                         // We can directly compare the packed value.
394                         // If the address is zero, packed will be zero.
395                         while (packed == 0) {
396                             packed = _packedOwnerships[--curr];
397                         }
398                         return packed;
399                     }
400                 }
401         }
402         revert OwnerQueryForNonexistentToken();
403     }
404 
405     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
406         ownership.addr = address(uint160(packed));
407         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
408         ownership.burned = packed & _BITMASK_BURNED != 0;
409         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
410     }
411 
412     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
413         assembly {
414             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
415             owner := and(owner, _BITMASK_ADDRESS)
416             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
417             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
418         }
419     }
420 
421     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
422         // For branchless setting of the `nextInitialized` flag.
423         assembly {
424             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
425             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
426         }
427     }
428 
429     function approve(address to, uint256 tokenId) public virtual override {
430         address owner = ownerOf(tokenId);
431 
432         if (_msgSenderERC721A() != owner)
433             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
434                 revert ApprovalCallerNotOwnerNorApproved();
435             }
436 
437         _tokenApprovals[tokenId].value = to;
438         emit Approval(owner, to, tokenId);
439     }
440 
441     function getApproved(uint256 tokenId) public view virtual override returns (address) {
442         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
443 
444         return _tokenApprovals[tokenId].value;
445     }
446 
447     function setApprovalForAll(address operator, bool approved) public virtual override {
448         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
449 
450         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
451         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
452     }
453 
454     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
455         return _operatorApprovals[owner][operator];
456     }
457 
458     function _exists(uint256 tokenId) internal view virtual returns (bool) {
459         return
460             _startTokenId() <= tokenId &&
461             tokenId < _currentIndex && // If within bounds,
462             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
463     }
464 
465     function _isSenderApprovedOrOwner(
466         address approvedAddress,
467         address owner,
468         address msgSender
469     ) private pure returns (bool result) {
470         assembly {
471             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
472             owner := and(owner, _BITMASK_ADDRESS)
473             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
474             msgSender := and(msgSender, _BITMASK_ADDRESS)
475             // `msgSender == owner || msgSender == approvedAddress`.
476             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
477         }
478     }
479 
480     function _getApprovedSlotAndAddress(uint256 tokenId)
481         private
482         view
483         returns (uint256 approvedAddressSlot, address approvedAddress)
484     {
485         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
486         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
487         assembly {
488             approvedAddressSlot := tokenApproval.slot
489             approvedAddress := sload(approvedAddressSlot)
490         }
491     }
492 
493 
494     function transferFrom(
495         address from,
496         address to,
497         uint256 tokenId
498     ) public virtual override {
499         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
500 
501         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
502 
503         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
504 
505         if(GAMEOVER == false && flyingSquirrelCanNOTMove == false && tokenId == 0) {
506 
507         } else {
508             // The nested ifs save around 20+ gas over a compound boolean condition.
509             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
510                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
511         }
512 
513         if (to == address(0)) revert TransferToZeroAddress();
514 
515         if (flyingSquirrelCanNOTMove && tokenId == 0) revert TransferOfSquirrel();
516 
517         _beforeTokenTransfers(from, to, tokenId, 1);
518 
519         // Clear approvals from the previous owner.
520         assembly {
521             if approvedAddress {
522                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
523                 sstore(approvedAddressSlot, 0)
524             }
525         }
526 
527         // Underflow of the sender's balance is impossible because we check for
528         // ownership above and the recipient's balance can't realistically overflow.
529         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
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
540             _packedOwnerships[tokenId] = _packOwnershipData(
541                 to,
542                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
543             );
544 
545             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
546             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
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
563     function safeTransferFrom(
564         address from,
565         address to,
566         uint256 tokenId
567     ) public virtual override {
568         safeTransferFrom(from, to, tokenId, '');
569     }
570 
571     function safeTransferFrom(
572         address from,
573         address to,
574         uint256 tokenId,
575         bytes memory _data
576     ) public virtual override {
577         transferFrom(from, to, tokenId);
578         if (to.code.length != 0)
579             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
580                 revert TransferToNonERC721ReceiverImplementer();
581             }
582     }
583 
584     function _checkContractOnERC721Received(
585         address from,
586         address to,
587         uint256 tokenId,
588         bytes memory _data
589     ) private returns (bool) {
590         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
591             bytes4 retval
592         ) {
593             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
594         } catch (bytes memory reason) {
595             if (reason.length == 0) {
596                 revert TransferToNonERC721ReceiverImplementer();
597             } else {
598                 assembly {
599                     revert(add(32, reason), mload(reason))
600                 }
601             }
602         }
603     }
604 
605     function _mint(address to, uint256 quantity) internal virtual {
606         uint256 startTokenId = _currentIndex;
607         if (quantity == 0) revert MintZeroQuantity();
608 
609         // Overflows are incredibly unrealistic.
610         // `balance` and `numberMinted` have a maximum limit of 2**64.
611         // `tokenId` has a maximum limit of 2**256.
612         unchecked {
613             // Updates:
614             // - `balance += quantity`.
615             // - `numberMinted += quantity`.
616             //
617             // We can directly add to the `balance` and `numberMinted`.
618             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
619 
620             // Updates:
621             // - `address` to the owner.
622             // - `startTimestamp` to the timestamp of minting.
623             // - `burned` to `false`.
624             // - `nextInitialized` to `quantity == 1`.
625             _packedOwnerships[startTokenId] = _packOwnershipData(
626                 to,
627                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
628             );
629 
630             uint256 toMasked;
631             uint256 end = startTokenId + quantity;
632 
633             // Use assembly to loop and emit the `Transfer` event for gas savings.
634             assembly {
635                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
636                 toMasked := and(to, _BITMASK_ADDRESS)
637                 // Emit the `Transfer` event.
638                 log4(
639                     0, // Start of data (0, since no data).
640                     0, // End of data (0, since no data).
641                     _TRANSFER_EVENT_SIGNATURE, // Signature.
642                     0, // `address(0)`.
643                     toMasked, // `to`.
644                     startTokenId // `tokenId`.
645                 )
646 
647                 for {
648                     let tokenId := add(startTokenId, 1)
649                 } iszero(eq(tokenId, end)) {
650                     tokenId := add(tokenId, 1)
651                 } {
652                     // Emit the `Transfer` event. Similar to above.
653                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
654                 }
655             }
656             if (toMasked == 0) revert MintToZeroAddress();
657 
658             _currentIndex = end;
659         }
660         _afterTokenTransfers(address(0), to, startTokenId, quantity);
661 
662         // turn off mint and start the game...
663         if(totalSupply() > maxSupply) { // greater than because we do supply + 1 to compensate for flying squirrel
664             mintEnabled = false;
665         }
666     }
667 
668     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
669         uint256 packed = _packedOwnerships[index];
670         if (packed == 0) revert OwnershipNotInitializedForExtraData();
671         uint256 extraDataCasted;
672         // Cast `extraData` with assembly to avoid redundant masking.
673         assembly {
674             extraDataCasted := extraData
675         }
676         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
677         _packedOwnerships[index] = packed;
678     }
679 
680     function _extraData(
681         address from,
682         address to,
683         uint24 previousExtraData
684     ) internal view virtual returns (uint24) {}
685 
686     function _nextExtraData(
687         address from,
688         address to,
689         uint256 prevOwnershipPacked
690     ) private view returns (uint256) {
691         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
692         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
693     }
694 
695     function _msgSenderERC721A() internal view virtual returns (address) {
696         return msg.sender;
697     }
698 
699     function _toString(uint256 value) internal pure virtual returns (string memory str) {
700         assembly {
701             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
702             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
703             // We will need 1 32-byte word to store the length,
704             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
705             str := add(mload(0x40), 0x80)
706             // Update the free memory pointer to allocate.
707             mstore(0x40, str)
708 
709             // Cache the end of the memory to calculate the length later.
710             let end := str
711 
712             // We write the string from rightmost digit to leftmost digit.
713             // The following is essentially a do-while loop that also handles the zero case.
714             // prettier-ignore
715             for { let temp := value } 1 {} {
716                 str := sub(str, 1)
717                 // Write the character to the pointer.
718                 // The ASCII index of the '0' character is 48.
719                 mstore8(str, add(48, mod(temp, 10)))
720                 // Keep dividing `temp` until zero.
721                 temp := div(temp, 10)
722                 // prettier-ignore
723                 if iszero(temp) { break }
724             }
725 
726             let length := sub(end, str)
727             // Move the pointer 32 bytes leftwards to make room for the length.
728             str := sub(str, 0x20)
729             // Store the length.
730             mstore(str, length)
731         }
732     }
733 
734     function _beforeTokenTransfers(
735         address,
736         address to,
737         uint256,
738         uint256
739     ) internal virtual {
740         uint currentTotal = balanceOf(to);
741         if(currentTotal > 0) {
742             if(holderTimestamps[to] > 0) {
743                 uint daysCurrentlyHeld = 0;
744                 unchecked {
745                     daysCurrentlyHeld = uint(block.timestamp - holderTimestamps[to]) / oneDay;
746                 }
747                 if(daysCurrentlyHeld > 0) {
748                     uint cut = cutForWork(daysCurrentlyHeld, currentTotal);
749                     if(cut > 0) {
750                         // reset their index
751                         holderTimestamps[to] = block.timestamp;
752                         sendETH(to, cut);
753                         checkForTheGamesEnd();
754                     }
755                 }
756             }
757         }
758     }
759 
760     function _afterTokenTransfers(
761         address from,
762         address to,
763         uint256 tokenId,
764         uint256
765     ) internal virtual {
766         if(flyingSquirrelCanNOTMove && lastFlyingSquirrelOwner != to && flyingSquirrelShouldFly(tokenId)) {
767             // once the game is over it will be set to false forever
768             // last person holding the 1/1 keeps it
769             flyingSquirrelCanNOTMove = false;
770             transferFrom(lastFlyingSquirrelOwner, to, 0);
771             flyingSquirrelCanNOTMove = true;
772             lastFlyingSquirrelOwner = to;
773         }
774 
775         // getting reset but dont worry the before token took care of you if you had been holding already
776         holderTimestamps[to] = block.timestamp;
777         // Have you tried holding the art?
778         holderTimestamps[from] = block.timestamp;
779     }
780 
781     function flyingSquirrelShouldFly(uint tokenId) internal view returns (bool) {
782         uint randomHash = uint(keccak256(abi.encodePacked(block.number, block.difficulty, block.timestamp, totalSupply(), tokenId)));
783         return ((randomHash % 500) + 1) == 420;
784     }
785 
786     function cutForWork(uint daysHeld, uint totalNFTs) internal returns (uint) {
787         uint daysHeldSafe = daysHeld >= maxAmountOfDays ? maxAmountOfDays : daysHeld;
788         unchecked {
789             uint daysForContract = uint(block.timestamp - timestampOfStart) / oneDay;
790 
791             if(daysForContract == 0) { return 0; }
792 
793             uint totalDivideBy = (daysForContract >= maxAmountOfDaysContract) ? amountOfTimeToPlay : daysForContract * maxSupply;
794 
795             if(totalDivideBy == 0) {
796                 return 0;
797             }
798 
799             uint totalDaysHeld = daysHeldSafe * totalNFTs;
800             if(totalDaysConsumed > totalDivideBy) { return 0; }
801 
802             uint totalDaysToConsider = totalDivideBy - totalDaysConsumed;
803             if(totalDaysHeld >= totalDaysToConsider) {
804                 totalDaysConsumed += totalDaysToConsider;
805                 return address(this).balance;
806             }
807             uint returnVal = (totalDaysHeld * address(this).balance) / totalDaysToConsider;
808             // update the consumed days after we calcuate
809             totalDaysConsumed += totalDaysHeld;
810 
811             return returnVal;
812         }
813     }
814 
815     function sendETH(address to, uint amount) internal {
816         (bool sent, ) = payable(to).call{value: amount}("");
817         require(sent, "Failed to send Ether");
818     }
819 
820     function checkForTheGamesEnd() internal {
821         // after 30 days of 5k NFT work we shall end the game
822         // since transfers out reset the token without consuming
823         // this should be longer than 30 days in reality
824         if(totalDaysConsumed >= amountOfTimeToPlay) {
825             GAMEOVER = true;
826             flyingSquirrelCanNOTMove = false;
827             // Return the contract back to the dev as the game is over
828             _returnDevOwnership();
829         }
830     }
831 }
832 
833 
834 contract Nutties is ERC721A {
835     string private baseURIForNewNew = "ipfs://QmYHxyUUndw7SDAVVq71baBRSntrgzyHZBi4qSCYa2GX7o/";
836     string private baseExt = ".json";
837     bool internal fireOnce = true;
838     mapping(address => bool) airdropLocks;
839 
840     constructor() ERC721A("Nutties", "NUT") {}
841 
842     receive() external payable {
843         if(mintEnabled && msg.value == 0) {
844             unchecked {
845                 require(
846                     1 + totalSupply() <= maxSupply + 1, "Not enough supply" // we add one to the supply max for the flying squirrel
847                 );
848                 _mint(msg.sender, 1);
849             }
850         } else if(msg.value == 0 && GAMEOVER == false) {
851             uint currentTotal = balanceOf(msg.sender);
852             require(currentTotal > 0, "You have no Nutties");
853 
854             uint daysCurrentlyHeld = 0;
855             require(holderTimestamps[msg.sender] > 0, "Sorry, grab an NFT why dont you");
856 
857             unchecked {
858                 daysCurrentlyHeld = uint(block.timestamp - holderTimestamps[msg.sender]) / oneDay;
859             }
860 
861             require(daysCurrentlyHeld > 0, "Have you tried working harder instead of smarter?");
862             uint cut = cutForWork(daysCurrentlyHeld, currentTotal);
863             require(cut > 0, "Sorry nothing to take if there is nothing");
864             // reset their index
865             holderTimestamps[msg.sender] = block.timestamp;
866             
867             sendETH(msg.sender, cut);
868 
869             checkForTheGamesEnd();
870         } else if(msg.value == 0 && GAMEOVER) {
871             require(false, "Sorry the game is over");
872         }
873 
874         // otherwise just let the payment fall into the smartcontract
875     }
876 
877     function withdraw() external onlyOwner {
878         require(GAMEOVER, "The game needs to be over");
879         sendETH(msg.sender, address(this).balance);
880     }
881 
882     function mintHotPotato1of1() external onlyOwner {
883         require(totalSupply() == 0, "1 of 1 has been minted");
884         // mint the hot potato 1/1 last person holding it gets to keep it
885         lastFlyingSquirrelOwner = msg.sender;
886         _mint(msg.sender, 1);
887     }
888 
889     function airdrop(address[] calldata _addresses) external onlyOwner {
890         IERC721 fmc = IERC721(0x60129d8bc41ed80f7B257fDBC2B57E6230C219d7);
891         for (uint256 index = 0; index < _addresses.length;) {
892             address fmcOwner = _addresses[index];
893             uint amount = fmc.balanceOf(fmcOwner);
894             if(amount > 0 && airdropLocks[fmcOwner] == false) {
895                 airdropLocks[fmcOwner] = true;
896                 _mint(fmcOwner, fmc.balanceOf(fmcOwner));
897             }
898 
899             unchecked {
900                 index += 1;
901             }
902         }
903     }
904 
905     function startTheShow() external onlyOwner {
906         require(fireOnce, "Can only fire once");
907         fireOnce = false;
908 
909         // Turn over the contract to itself yolo
910         _transferOwnership(address(this));
911 
912         // Start the show
913         timestampOfStart = block.timestamp;
914         mintEnabled = true;
915     }
916 
917     function setBaseURI(string calldata _baseURI) external onlyOwner {
918         baseURIForNewNew = _baseURI;
919     }
920 
921     function setURIExtension(string calldata _baseExt) external onlyOwner {
922         baseExt = _baseExt;
923     }
924 
925     function isMintEnabled() external view returns (bool) {
926         return mintEnabled;
927     }
928 
929     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
930         return string(abi.encodePacked(baseURIForNewNew, _toString(tokenId), baseExt));
931     }
932 
933     function isGameOver() external view returns (bool) {
934         return GAMEOVER;
935     }
936 
937     function consumed() external view returns (uint) {
938         return totalDaysConsumed;
939     }
940 }