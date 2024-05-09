1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.12;
3 
4 library Strings {
5     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
6 
7     function toString(uint256 value) internal pure returns (string memory) {
8         if (value == 0) {
9             return "0";
10         }
11         uint256 temp = value;
12         uint256 digits;
13         while (temp != 0) {
14             digits++;
15             temp /= 10;
16         }
17         bytes memory buffer = new bytes(digits);
18         while (value != 0) {
19             digits -= 1;
20             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
21             value /= 10;
22         }
23         return string(buffer);
24     }
25 }
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 }
32 
33 abstract contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     /**
39      * @dev Initializes the contract setting the deployer as the initial owner.
40      */
41     constructor() {
42         _transferOwnership(_msgSender());
43     }
44 
45     /**
46      * @dev Throws if called by any account other than the owner.
47      */
48     modifier onlyOwner() {
49         _checkOwner();
50         _;
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if the sender is not the owner.
62      */
63     function _checkOwner() internal view virtual {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 interface IERC721A {
99     error ApprovalCallerNotOwnerNorApproved();
100     error ApprovalQueryForNonexistentToken();
101     error ApproveToCaller();
102     error BalanceQueryForZeroAddress();
103     error MintToZeroAddress();
104     error MintZeroQuantity();
105     error OwnerQueryForNonexistentToken();
106     error TransferCallerNotOwnerNorApproved();
107     error TransferFromIncorrectOwner();
108     error TransferToNonERC721ReceiverImplementer();
109     error TransferToZeroAddress();
110     error URIQueryForNonexistentToken();
111     error MintERC2309QuantityExceedsLimit();
112     error OwnershipNotInitializedForExtraData();
113 
114     struct TokenOwnership {
115         address addr;
116         uint64 startTimestamp;
117         uint24 extraData;
118     }
119 
120     function totalSupply() external view returns (uint256);
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
123     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
124     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
125     function balanceOf(address owner) external view returns (uint256 balance);
126     function ownerOf(uint256 tokenId) external view returns (address owner);
127     function safeTransferFrom(
128         address from,
129         address to,
130         uint256 tokenId,
131         bytes calldata data
132     ) external;
133 
134     function safeTransferFrom(
135         address from,
136         address to,
137         uint256 tokenId
138     ) external;
139 
140     function transferFrom(
141         address from,
142         address to,
143         uint256 tokenId
144     ) external;
145 
146     function approve(address to, uint256 tokenId) external;
147     function setApprovalForAll(address operator, bool _approved) external;
148     function getApproved(uint256 tokenId) external view returns (address operator);
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150     function name() external view returns (string memory);
151     function symbol() external view returns (string memory);
152     function tokenURI(uint256 tokenId) external view returns (string memory);
153 }
154 
155 /**
156  * @dev ERC721 token receiver interface.
157  */
158 interface ERC721A__IERC721Receiver {
159     function onERC721Received(
160         address operator,
161         address from,
162         uint256 tokenId,
163         bytes calldata data
164     ) external returns (bytes4);
165 }
166 
167 contract ERC721A is IERC721A {
168     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
169     uint256 private constant BITPOS_NUMBER_MINTED = 64;
170     uint256 private constant BITPOS_NUMBER_BURNED = 128;
171     uint256 private constant BITPOS_AUX = 192;
172     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
173     uint256 private constant BITPOS_START_TIMESTAMP = 160;
174     uint256 private constant BITMASK_BURNED = 1 << 224;
175     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
176     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
177     uint256 private constant BITPOS_EXTRA_DATA = 232;
178     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
179     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
180     uint256 private _currentIndex;
181     string private _name;
182     string private _symbol;
183     mapping(uint256 => uint256) private _packedOwnerships;
184     mapping(address => uint256) private _packedAddressData;
185     mapping(uint256 => address) private _tokenApprovals;
186     mapping(address => mapping(address => bool)) private _operatorApprovals;
187 
188     constructor(string memory name_, string memory symbol_) {
189         _name = name_;
190         _symbol = symbol_;
191         _currentIndex = _startTokenId();
192     }
193 
194     function _startTokenId() internal view virtual returns (uint256) {
195         return 1;
196     }
197 
198     function _nextTokenId() internal view virtual returns (uint256) {
199         return _currentIndex;
200     }
201 
202     function totalSupply() public view virtual override returns (uint256) {
203         // Counter underflow is impossible as _burnCounter cannot be incremented
204         // more than `_currentIndex - _startTokenId()` times.
205         unchecked {
206             return _currentIndex - _startTokenId();
207         }
208     }
209 
210 
211     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
212         return
213             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
214             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
215             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
216     }
217 
218     function balanceOf(address owner) public view virtual override returns (uint256) {
219         if (owner == address(0)) revert BalanceQueryForZeroAddress();
220         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
221     }
222 
223     function _numberMinted(address owner) internal view virtual returns (uint256) {
224         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
225     }
226 
227     function _getAux(address owner) internal view virtual returns (uint64) {
228         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
229     }
230 
231     function _setAux(address owner, uint64 aux) internal virtual {
232         uint256 packed = _packedAddressData[owner];
233         uint256 auxCasted;
234         // Cast `aux` with assembly to avoid redundant masking.
235         assembly {
236             auxCasted := aux
237         }
238         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
239         _packedAddressData[owner] = packed;
240     }
241 
242     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
243         uint256 curr = tokenId;
244 
245         unchecked {
246             if (_startTokenId() <= curr)
247                 if (curr < _currentIndex) {
248                     uint256 packed = _packedOwnerships[curr];
249                     // If not burned.
250                     if (packed & BITMASK_BURNED == 0) {
251                         // Invariant:
252                         // There will always be an ownership that has an address and is not burned
253                         // before an ownership that does not have an address and is not burned.
254                         // Hence, curr will not underflow.
255                         //
256                         // We can directly compare the packed value.
257                         // If the address is zero, packed is zero.
258                         while (packed == 0) {
259                             packed = _packedOwnerships[--curr];
260                         }
261                         return packed;
262                     }
263                 }
264         }
265         revert OwnerQueryForNonexistentToken();
266     }
267 
268     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
269         ownership.addr = address(uint160(packed));
270         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
271         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
272     }
273 
274     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
275         return _unpackedOwnership(_packedOwnerships[index]);
276     }
277 
278     function _initializeOwnershipAt(uint256 index) internal virtual {
279         if (_packedOwnerships[index] == 0) {
280             _packedOwnerships[index] = _packedOwnershipOf(index);
281         }
282     }
283 
284     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
285         return _unpackedOwnership(_packedOwnershipOf(tokenId));
286     }
287 
288     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
289         assembly {
290             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
291             owner := and(owner, BITMASK_ADDRESS)
292             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
293             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
294         }
295     }
296 
297     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
298         return address(uint160(_packedOwnershipOf(tokenId)));
299     }
300 
301     function name() public view virtual override returns (string memory) {
302         return _name;
303     }
304 
305     function symbol() public view virtual override returns (string memory) {
306         return _symbol;
307     }
308 
309     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
310         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
311 
312         string memory baseURI = _baseURI();
313         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
314     }
315 
316     function _baseURI() internal view virtual returns (string memory) {
317         return '';
318     }
319 
320     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
321         // For branchless setting of the `nextInitialized` flag.
322         assembly {
323             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
324             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
325         }
326     }
327 
328     function approve(address to, uint256 tokenId) public virtual override {
329         address owner = ownerOf(tokenId);
330 
331         if (_msgSenderERC721A() != owner)
332             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
333                 revert ApprovalCallerNotOwnerNorApproved();
334             }
335 
336         _tokenApprovals[tokenId] = to;
337         emit Approval(owner, to, tokenId);
338     }
339 
340     function getApproved(uint256 tokenId) public view virtual override returns (address) {
341         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
342 
343         return _tokenApprovals[tokenId];
344     }
345 
346     function setApprovalForAll(address operator, bool approved) public virtual override {
347         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
348 
349         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
350         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
351     }
352 
353     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
354         return _operatorApprovals[owner][operator];
355     }
356 
357     function safeTransferFrom(
358         address from,
359         address to,
360         uint256 tokenId
361     ) public virtual override {
362         safeTransferFrom(from, to, tokenId, '');
363     }
364 
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId,
369         bytes memory _data
370     ) public virtual override {
371         transferFrom(from, to, tokenId);
372         if (to.code.length != 0)
373             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
374                 revert TransferToNonERC721ReceiverImplementer();
375             }
376     }
377 
378     function _exists(uint256 tokenId) internal view virtual returns (bool) {
379         return
380             _startTokenId() <= tokenId &&
381             tokenId < _currentIndex && // If within bounds,
382             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
383     }
384 
385     function _safeMint(address to, uint256 quantity) internal virtual {
386         _safeMint(to, quantity, '');
387     }
388 
389     function _safeMint(
390         address to,
391         uint256 quantity,
392         bytes memory _data
393     ) internal virtual {
394         _mint(to, quantity);
395 
396         unchecked {
397             if (to.code.length != 0) {
398                 uint256 end = _currentIndex;
399                 uint256 index = end - quantity;
400                 do {
401                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
402                         revert TransferToNonERC721ReceiverImplementer();
403                     }
404                 } while (index < end);
405                 // Reentrancy protection.
406                 if (_currentIndex != end) revert();
407             }
408         }
409     }
410 
411     function _mint(address to, uint256 quantity) internal virtual {
412         uint256 startTokenId = _currentIndex;
413         if (to == address(0)) revert MintToZeroAddress();
414         if (quantity == 0) revert MintZeroQuantity();
415 
416         // Overflows are incredibly unrealistic.
417         // `balance` and `numberMinted` have a maximum limit of 2**64.
418         // `tokenId` has a maximum limit of 2**256.
419         unchecked {
420             // Updates:
421             // - `balance += quantity`.
422             // - `numberMinted += quantity`.
423             //
424             // We can directly add to the `balance` and `numberMinted`.
425             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
426 
427             // Updates:
428             // - `address` to the owner.
429             // - `startTimestamp` to the timestamp of minting.
430             // - `burned` to `false`.
431             // - `nextInitialized` to `quantity == 1`.
432             _packedOwnerships[startTokenId] = _packOwnershipData(
433                 to,
434                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
435             );
436 
437             uint256 tokenId = startTokenId;
438             uint256 end = startTokenId + quantity;
439             do {
440                 emit Transfer(address(0), to, tokenId++);
441             } while (tokenId < end);
442 
443             _currentIndex = end;
444         }
445     }
446 
447     function _getApprovedAddress(uint256 tokenId)
448         private
449         view
450         returns (uint256 approvedAddressSlot, address approvedAddress)
451     {
452         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
453         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
454         assembly {
455             // Compute the slot.
456             mstore(0x00, tokenId)
457             mstore(0x20, tokenApprovalsPtr.slot)
458             approvedAddressSlot := keccak256(0x00, 0x40)
459             // Load the slot's value from storage.
460             approvedAddress := sload(approvedAddressSlot)
461         }
462     }
463 
464     function _isOwnerOrApproved(
465         address approvedAddress,
466         address from,
467         address msgSender
468     ) private pure returns (bool result) {
469         assembly {
470             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
471             from := and(from, BITMASK_ADDRESS)
472             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
473             msgSender := and(msgSender, BITMASK_ADDRESS)
474             // `msgSender == from || msgSender == approvedAddress`.
475             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
476         }
477     }
478 
479     function transferFrom(
480         address from,
481         address to,
482         uint256 tokenId
483     ) public virtual override {
484         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
485 
486         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
487 
488         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
489 
490         // The nested ifs save around 20+ gas over a compound boolean condition.
491         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
492             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
493 
494         if (to == address(0)) revert TransferToZeroAddress();
495 
496         // Clear approvals from the previous owner.
497         assembly {
498             if approvedAddress {
499                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
500                 sstore(approvedAddressSlot, 0)
501             }
502         }
503 
504         // Underflow of the sender's balance is impossible because we check for
505         // ownership above and the recipient's balance can't realistically overflow.
506         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
507         unchecked {
508             // We can directly increment and decrement the balances.
509             --_packedAddressData[from]; // Updates: `balance -= 1`.
510             ++_packedAddressData[to]; // Updates: `balance += 1`.
511 
512             // Updates:
513             // - `address` to the next owner.
514             // - `startTimestamp` to the timestamp of transfering.
515             // - `burned` to `false`.
516             // - `nextInitialized` to `true`.
517             _packedOwnerships[tokenId] = _packOwnershipData(
518                 to,
519                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
520             );
521 
522             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
523             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
524                 uint256 nextTokenId = tokenId + 1;
525                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
526                 if (_packedOwnerships[nextTokenId] == 0) {
527                     // If the next slot is within bounds.
528                     if (nextTokenId != _currentIndex) {
529                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
530                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
531                     }
532                 }
533             }
534         }
535 
536         emit Transfer(from, to, tokenId);
537     }
538 
539     function _checkContractOnERC721Received(
540         address from,
541         address to,
542         uint256 tokenId,
543         bytes memory _data
544     ) private returns (bool) {
545         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
546             bytes4 retval
547         ) {
548             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
549         } catch (bytes memory reason) {
550             if (reason.length == 0) {
551                 revert TransferToNonERC721ReceiverImplementer();
552             } else {
553                 assembly {
554                     revert(add(32, reason), mload(reason))
555                 }
556             }
557         }
558     }
559 
560     function _nextExtraData(
561         address from,
562         address to,
563         uint256 prevOwnershipPacked
564     ) private view returns (uint256) {
565         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
566         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
567     }
568 
569     function _extraData(
570         address from,
571         address to,
572         uint24 previousExtraData
573     ) internal view virtual returns (uint24) {}
574 
575     function _msgSenderERC721A() internal view virtual returns (address) {
576         return msg.sender;
577     }
578 
579     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
580         assembly {
581             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
582             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
583             // We will need 1 32-byte word to store the length,
584             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
585             ptr := add(mload(0x40), 128)
586             // Update the free memory pointer to allocate.
587             mstore(0x40, ptr)
588 
589             // Cache the end of the memory to calculate the length later.
590             let end := ptr
591 
592             // We write the string from the rightmost digit to the leftmost digit.
593             // The following is essentially a do-while loop that also handles the zero case.
594             // Costs a bit more than early returning for the zero case,
595             // but cheaper in terms of deployment and overall runtime costs.
596             for {
597                 // Initialize and perform the first pass without check.
598                 let temp := value
599                 // Move the pointer 1 byte leftwards to point to an empty character slot.
600                 ptr := sub(ptr, 1)
601                 // Write the character to the pointer. 48 is the ASCII index of '0'.
602                 mstore8(ptr, add(48, mod(temp, 10)))
603                 temp := div(temp, 10)
604             } temp {
605                 // Keep dividing `temp` until zero.
606                 temp := div(temp, 10)
607             } {
608                 // Body of the for loop.
609                 ptr := sub(ptr, 1)
610                 mstore8(ptr, add(48, mod(temp, 10)))
611             }
612 
613             let length := sub(end, ptr)
614             // Move the pointer 32 bytes leftwards to make room for the length.
615             ptr := sub(ptr, 32)
616             // Store the length.
617             mstore(ptr, length)
618         }
619     }
620 }
621 
622 contract FreeMintsAreCommunism is ERC721A, Ownable {
623     bool _revealed = false;
624     string private baseURI = "ipfs://QmWiYFdz7cCgiVWMBcsRjgDLHTwVhj3A4X2ssrNuQSdKgQ";
625 
626     constructor() ERC721A("Free Mints = Communism", "FM=C") {}
627 
628     receive() external payable {
629         if(msg.value > 0) {
630             (bool sent, ) = payable(owner()).call{value: msg.value}("");
631             require(sent, "Failed to send Ether");
632         }
633 
634         unchecked {
635             if(1 + totalSupply() <= 1917) {
636                 _safeMint(msg.sender, 1);
637             }
638         }
639     }
640     
641     function setURI(bool revealed, string calldata _baseURI) external onlyOwner {
642         _revealed = revealed;
643         baseURI = _baseURI;
644     }
645 
646     function tokenURI(uint256 tokenId)
647         public
648         view
649         virtual
650         override
651         returns (string memory)
652     {
653         if (_revealed) {
654             return string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"));
655         } else {
656             return string(abi.encodePacked(baseURI));
657         }
658     }
659 }