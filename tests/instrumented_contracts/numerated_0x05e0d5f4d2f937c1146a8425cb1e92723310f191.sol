1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7; 
3 library MerkleProof {
4     function verify(
5         bytes32[] memory proof,
6         bytes32 root,
7         bytes32 leaf
8     ) internal pure returns (bool) {
9         return processProof(proof, leaf) == root;
10     }
11    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
12         bytes32 computedHash = leaf;
13         for (uint256 i = 0; i < proof.length; i++) {
14             bytes32 proofElement = proof[i];
15             if (computedHash <= proofElement) {
16                 computedHash = _efficientHash(computedHash, proofElement);
17             } else {
18                 computedHash = _efficientHash(proofElement, computedHash);
19             }
20         }
21         return computedHash;
22     }
23 
24     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
25         assembly {
26             mstore(0x00, a)
27             mstore(0x20, b)
28             value := keccak256(0x00, 0x40)
29         }
30     }
31 }
32 abstract contract ReentrancyGuard { 
33     uint256 private constant _NOT_ENTERED = 1;
34     uint256 private constant _ENTERED = 2;
35 
36     uint256 private _status;
37 
38     constructor() {
39         _status = _NOT_ENTERED;
40     }
41     modifier nonReentrant() {
42         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
43    _status = _ENTERED;
44 
45         _;
46         _status = _NOT_ENTERED;
47     }
48 }
49 
50 library Strings {
51     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
52  
53     function toString(uint256 value) internal pure returns (string memory) { 
54         if (value == 0) {
55             return "0";
56         }
57         uint256 temp = value;
58         uint256 digits;
59         while (temp != 0) {
60             digits++;
61             temp /= 10;
62         }
63         bytes memory buffer = new bytes(digits);
64         while (value != 0) {
65             digits -= 1;
66             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
67             value /= 10;
68         }
69         return string(buffer);
70     }
71  
72     function toHexString(uint256 value) internal pure returns (string memory) {
73         if (value == 0) {
74             return "0x00";
75         }
76         uint256 temp = value;
77         uint256 length = 0;
78         while (temp != 0) {
79             length++;
80             temp >>= 8;
81         }
82         return toHexString(value, length);
83     }
84  
85     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
86         bytes memory buffer = new bytes(2 * length + 2);
87         buffer[0] = "0";
88         buffer[1] = "x";
89         for (uint256 i = 2 * length + 1; i > 1; --i) {
90             buffer[i] = _HEX_SYMBOLS[value & 0xf];
91             value >>= 4;
92         }
93         require(value == 0, "Strings: hex length insufficient");
94         return string(buffer);
95     }
96 }
97  
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes calldata) {
104         return msg.data;
105     }
106 }
107  
108 abstract contract Ownable is Context {
109     address private _owner;
110 
111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112  
113     constructor() {
114         _transferOwnership(_msgSender());
115     }
116  
117     function owner() public view virtual returns (address) {
118         return _owner;
119     } 
120     modifier onlyOwner() {
121         require(owner() == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124  
125     function renounceOwnership() public virtual onlyOwner {
126         _transferOwnership(address(0));
127     }
128  
129     function transferOwnership(address newOwner) public virtual onlyOwner {
130         require(newOwner != address(0), "Ownable: new owner is the zero address");
131         _transferOwnership(newOwner);
132     }
133  
134     function _transferOwnership(address newOwner) internal virtual {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 interface IERC721A {
142     /**
143      * The caller must own the token or be an approved operator.
144      */
145     error ApprovalCallerNotOwnerNorApproved();
146 
147     /**
148      * The token does not exist.
149      */
150     error ApprovalQueryForNonexistentToken();
151 
152     /**
153      * The caller cannot approve to their own address.
154      */
155     error ApproveToCaller();
156 
157     /**
158      * Cannot query the balance for the zero address.
159      */
160     error BalanceQueryForZeroAddress();
161 
162     /**
163      * Cannot mint to the zero address.
164      */
165     error MintToZeroAddress();
166 
167     /**
168      * The quantity of tokens minted must be more than zero.
169      */
170     error MintZeroQuantity();
171 
172     /**
173      * The token does not exist.
174      */
175     error OwnerQueryForNonexistentToken();
176 
177     /**
178      * The caller must own the token or be an approved operator.
179      */
180     error TransferCallerNotOwnerNorApproved();
181 
182     /**
183      * The token must be owned by `from`.
184      */
185     error TransferFromIncorrectOwner();
186 
187     /**
188      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
189      */
190     error TransferToNonERC721ReceiverImplementer();
191 
192     /**
193      * Cannot transfer to the zero address.
194      */
195     error TransferToZeroAddress();
196 
197     /**
198      * The token does not exist.
199      */
200     error URIQueryForNonexistentToken();
201 
202     /**
203      * The `quantity` minted with ERC2309 exceeds the safety limit.
204      */
205     error MintERC2309QuantityExceedsLimit();
206 
207     /**
208      * The `extraData` cannot be set on an unintialized ownership slot.
209      */
210     error OwnershipNotInitializedForExtraData();
211 
212     struct TokenOwnership {
213         // The address of the owner.
214         address addr;
215         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
216         uint64 startTimestamp;
217         // Whether the token has been burned.
218         bool burned;
219         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
220         uint24 extraData;
221     }
222 
223     /**
224      * @dev Returns the total amount of tokens stored by the contract.
225      *
226      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     // ==============================
231     //            IERC165
232     // ==============================
233 
234     /**
235      * @dev Returns true if this contract implements the interface defined by
236      * `interfaceId`. See the corresponding
237      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
238      * to learn more about how these ids are created.
239      *
240      * This function call must use less than 30 000 gas.
241      */
242     function supportsInterface(bytes4 interfaceId) external view returns (bool);
243 
244     // ==============================
245     //            IERC721
246     // ==============================
247 
248     /**
249      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
252 
253     /**
254      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
255      */
256     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
257 
258     /**
259      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
260      */
261     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
262 
263     /**
264      * @dev Returns the number of tokens in ``owner``'s account.
265      */
266     function balanceOf(address owner) external view returns (uint256 balance);
267 
268     /**
269      * @dev Returns the owner of the `tokenId` token.
270      *
271      * Requirements:
272      *
273      * - `tokenId` must exist.
274      */
275     function ownerOf(uint256 tokenId) external view returns (address owner);
276 
277     /**
278      * @dev Safely transfers `tokenId` token from `from` to `to`.
279      *
280      * Requirements:
281      *
282      * - `from` cannot be the zero address.
283      * - `to` cannot be the zero address.
284      * - `tokenId` token must exist and be owned by `from`.
285      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
286      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
287      *
288      * Emits a {Transfer} event.
289      */
290     function safeTransferFrom(
291         address from,
292         address to,
293         uint256 tokenId,
294         bytes calldata data
295     ) external;
296 
297     /**
298      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
299      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
300      *
301      * Requirements:
302      *
303      * - `from` cannot be the zero address.
304      * - `to` cannot be the zero address.
305      * - `tokenId` token must exist and be owned by `from`.
306      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
307      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
308      *
309      * Emits a {Transfer} event.
310      */
311     function safeTransferFrom(
312         address from,
313         address to,
314         uint256 tokenId
315     ) external;
316 
317     /**
318      * @dev Transfers `tokenId` token from `from` to `to`.
319      *
320      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
321      *
322      * Requirements:
323      *
324      * - `from` cannot be the zero address.
325      * - `to` cannot be the zero address.
326      * - `tokenId` token must be owned by `from`.
327      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transferFrom(
332         address from,
333         address to,
334         uint256 tokenId
335     ) external;
336 
337     /**
338      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
339      * The approval is cleared when the token is transferred.
340      *
341      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
342      *
343      * Requirements:
344      *
345      * - The caller must own the token or be an approved operator.
346      * - `tokenId` must exist.
347      *
348      * Emits an {Approval} event.
349      */
350     function approve(address to, uint256 tokenId) external;
351 
352     /**
353      * @dev Approve or remove `operator` as an operator for the caller.
354      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
355      *
356      * Requirements:
357      *
358      * - The `operator` cannot be the caller.
359      *
360      * Emits an {ApprovalForAll} event.
361      */
362     function setApprovalForAll(address operator, bool _approved) external;
363 
364     /**
365      * @dev Returns the account approved for `tokenId` token.
366      *
367      * Requirements:
368      *
369      * - `tokenId` must exist.
370      */
371     function getApproved(uint256 tokenId) external view returns (address operator);
372 
373     /**
374      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
375      *
376      * See {setApprovalForAll}
377      */
378     function isApprovedForAll(address owner, address operator) external view returns (bool);
379 
380     // ==============================
381     //        IERC721Metadata
382     // ==============================
383 
384     /**
385      * @dev Returns the token collection name.
386      */
387     function name() external view returns (string memory);
388 
389     /**
390      * @dev Returns the token collection symbol.
391      */
392     function symbol() external view returns (string memory);
393 
394     /**
395      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
396      */
397     function tokenURI(uint256 tokenId) external view returns (string memory);
398 
399     // ==============================
400     //            IERC2309
401     // ==============================
402 
403     /**
404      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
405      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
406      */
407     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
408 
409 
410 }
411 
412 interface ERC721A__IERC721Receiver {
413     function onERC721Received(
414         address operator,
415         address from,
416         uint256 tokenId,
417         bytes calldata data
418     ) external returns (bytes4);
419 }
420 
421 contract ERC721A is IERC721A {
422     // Mask of an entry in packed address data.
423     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
424 
425     // The bit position of `numberMinted` in packed address data.
426     uint256 private constant BITPOS_NUMBER_MINTED = 64;
427 
428     // The bit position of `numberBurned` in packed address data.
429     uint256 private constant BITPOS_NUMBER_BURNED = 128;
430 
431     // The bit position of `aux` in packed address data.
432     uint256 private constant BITPOS_AUX = 192;
433 
434     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
435     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
436 
437     // The bit position of `startTimestamp` in packed ownership.
438     uint256 private constant BITPOS_START_TIMESTAMP = 160;
439 
440     // The bit mask of the `burned` bit in packed ownership.
441     uint256 private constant BITMASK_BURNED = 1 << 224;
442 
443     // The bit position of the `nextInitialized` bit in packed ownership.
444     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
445 
446     // The bit mask of the `nextInitialized` bit in packed ownership.
447     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
448 
449     // The bit position of `extraData` in packed ownership.
450     uint256 private constant BITPOS_EXTRA_DATA = 232;
451 
452     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
453     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
454 
455     // The mask of the lower 160 bits for addresses.
456     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
457 
458     // The maximum `quantity` that can be minted with `_mintERC2309`.
459     // This limit is to prevent overflows on the address data entries.
460     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
461     // is required to cause an overflow, which is unrealistic.
462     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
463 
464     // The tokenId of the next token to be minted.
465     uint256 private _currentIndex;
466 
467     // The number of tokens burned.
468     uint256 private _burnCounter;
469 
470     // Token name
471     string private _name;
472 
473     // Token symbol
474     string private _symbol;
475 
476     // Mapping from token ID to ownership details
477     // An empty struct value does not necessarily mean the token is unowned.
478     // See `_packedOwnershipOf` implementation for details.
479     //
480     // Bits Layout:
481     // - [0..159]   `addr`
482     // - [160..223] `startTimestamp`
483     // - [224]      `burned`
484     // - [225]      `nextInitialized`
485     // - [232..255] `extraData`
486     mapping(uint256 => uint256) private _packedOwnerships;
487 
488     // Mapping owner address to address data.
489     //
490     // Bits Layout:
491     // - [0..63]    `balance`
492     // - [64..127]  `numberMinted`
493     // - [128..191] `numberBurned`
494     // - [192..255] `aux`
495     mapping(address => uint256) private _packedAddressData;
496 
497     // Mapping from token ID to approved address.
498     mapping(uint256 => address) private _tokenApprovals;
499 
500     // Mapping from owner to operator approvals
501     mapping(address => mapping(address => bool)) private _operatorApprovals;
502 
503     constructor(string memory name_, string memory symbol_) {
504         _name = name_;
505         _symbol = symbol_;
506         _currentIndex = _startTokenId();
507     }
508 
509     /**
510      * @dev Returns the starting token ID.
511      * To change the starting token ID, please override this function.
512      */
513     function _startTokenId() internal view virtual returns (uint256) {
514         return 0;
515     }
516 
517     /**
518      * @dev Returns the next token ID to be minted.
519      */
520     function _nextTokenId() internal view returns (uint256) {
521         return _currentIndex;
522     }
523 
524     /**
525      * @dev Returns the total number of tokens in existence.
526      * Burned tokens will reduce the count.
527      * To get the total number of tokens minted, please see `_totalMinted`.
528      */
529     function totalSupply() public view override returns (uint256) {
530         // Counter underflow is impossible as _burnCounter cannot be incremented
531         // more than `_currentIndex - _startTokenId()` times.
532         unchecked {
533             return _currentIndex - _burnCounter - _startTokenId();
534         }
535     }
536 
537     /**
538      * @dev Returns the total amount of tokens minted in the contract.
539      */
540     function _totalMinted() internal view returns (uint256) {
541         // Counter underflow is impossible as _currentIndex does not decrement,
542         // and it is initialized to `_startTokenId()`
543         unchecked {
544             return _currentIndex - _startTokenId();
545         }
546     }
547 
548     /**
549      * @dev Returns the total number of tokens burned.
550      */
551     function _totalBurned() internal view returns (uint256) {
552         return _burnCounter;
553     }
554 
555     /**
556      * @dev See {IERC165-supportsInterface}.
557      */
558     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559         // The interface IDs are constants representing the first 4 bytes of the XOR of
560         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
561         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
562         return
563             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
564             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
565             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
566     }
567 
568     /**
569      * @dev See {IERC721-balanceOf}.
570      */
571     function balanceOf(address owner) public view override returns (uint256) {
572         if (owner == address(0)) revert BalanceQueryForZeroAddress();
573         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
574     }
575 
576     /**
577      * Returns the number of tokens minted by `owner`.
578      */
579     function _numberMinted(address owner) internal view returns (uint256) {
580         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
581     }
582 
583     /**
584      * Returns the number of tokens burned by or on behalf of `owner`.
585      */
586     function _numberBurned(address owner) internal view returns (uint256) {
587         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
588     }
589 
590     /**
591      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
592      */
593     function _getAux(address owner) internal view returns (uint64) {
594         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
595     }
596 
597     /**
598      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
599      * If there are multiple variables, please pack them into a uint64.
600      */
601     function _setAux(address owner, uint64 aux) internal {
602         uint256 packed = _packedAddressData[owner];
603         uint256 auxCasted;
604         // Cast `aux` with assembly to avoid redundant masking.
605         assembly {
606             auxCasted := aux
607         }
608         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
609         _packedAddressData[owner] = packed;
610     }
611 
612     /**
613      * Returns the packed ownership data of `tokenId`.
614      */
615     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
616         uint256 curr = tokenId;
617 
618         unchecked {
619             if (_startTokenId() <= curr)
620                 if (curr < _currentIndex) {
621                     uint256 packed = _packedOwnerships[curr];
622                     // If not burned.
623                     if (packed & BITMASK_BURNED == 0) {
624                         // Invariant:
625                         // There will always be an ownership that has an address and is not burned
626                         // before an ownership that does not have an address and is not burned.
627                         // Hence, curr will not underflow.
628                         //
629                         // We can directly compare the packed value.
630                         // If the address is zero, packed is zero.
631                         while (packed == 0) {
632                             packed = _packedOwnerships[--curr];
633                         }
634                         return packed;
635                     }
636                 }
637         }
638         revert OwnerQueryForNonexistentToken();
639     }
640 
641     /**
642      * Returns the unpacked `TokenOwnership` struct from `packed`.
643      */
644     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
645         ownership.addr = address(uint160(packed));
646         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
647         ownership.burned = packed & BITMASK_BURNED != 0;
648         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
649     }
650 
651     /**
652      * Returns the unpacked `TokenOwnership` struct at `index`.
653      */
654     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
655         return _unpackedOwnership(_packedOwnerships[index]);
656     }
657 
658     /**
659      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
660      */
661     function _initializeOwnershipAt(uint256 index) internal {
662         if (_packedOwnerships[index] == 0) {
663             _packedOwnerships[index] = _packedOwnershipOf(index);
664         }
665     }
666 
667     /**
668      * Gas spent here starts off proportional to the maximum mint batch size.
669      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
670      */
671     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
672         return _unpackedOwnership(_packedOwnershipOf(tokenId));
673     }
674 
675     /**
676      * @dev Packs ownership data into a single uint256.
677      */
678     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
679         assembly {
680             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
681             owner := and(owner, BITMASK_ADDRESS)
682             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
683             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
684         }
685     }
686 
687     /**
688      * @dev See {IERC721-ownerOf}.
689      */
690     function ownerOf(uint256 tokenId) public view override returns (address) {
691         return address(uint160(_packedOwnershipOf(tokenId)));
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-name}.
696      */
697     function name() public view virtual override returns (string memory) {
698         return _name;
699     }
700 
701     /**
702      * @dev See {IERC721Metadata-symbol}.
703      */
704     function symbol() public view virtual override returns (string memory) {
705         return _symbol;
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-tokenURI}.
710      */
711     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
712         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
713 
714         string memory baseURI = _baseURI();
715         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
716     }
717 
718     /**
719      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
720      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
721      * by default, it can be overridden in child contracts.
722      */
723     function _baseURI() internal view virtual returns (string memory) {
724         return '';
725     }
726 
727     /**
728      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
729      */
730     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
731         // For branchless setting of the `nextInitialized` flag.
732         assembly {
733             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
734             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
735         }
736     }
737 
738     /**
739      * @dev See {IERC721-approve}.
740      */
741     function approve(address to, uint256 tokenId) public override {
742         address owner = ownerOf(tokenId);
743 
744         if (_msgSenderERC721A() != owner)
745             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
746                 revert ApprovalCallerNotOwnerNorApproved();
747             }
748 
749         _tokenApprovals[tokenId] = to;
750         emit Approval(owner, to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-getApproved}.
755      */
756     function getApproved(uint256 tokenId) public view override returns (address) {
757         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
758 
759         return _tokenApprovals[tokenId];
760     }
761 
762     /**
763      * @dev See {IERC721-setApprovalForAll}.
764      */
765     function setApprovalForAll(address operator, bool approved) public virtual override {
766         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
767 
768         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
769         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
770     }
771 
772     /**
773      * @dev See {IERC721-isApprovedForAll}.
774      */
775     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
776         return _operatorApprovals[owner][operator];
777     }
778 
779     /**
780      * @dev See {IERC721-safeTransferFrom}.
781      */
782     function safeTransferFrom(
783         address from,
784         address to,
785         uint256 tokenId
786     ) public virtual override {
787         safeTransferFrom(from, to, tokenId, '');
788     }
789 
790     /**
791      * @dev See {IERC721-safeTransferFrom}.
792      */
793     function safeTransferFrom(
794         address from,
795         address to,
796         uint256 tokenId,
797         bytes memory _data
798     ) public virtual override {
799         transferFrom(from, to, tokenId);
800         if (to.code.length != 0)
801             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
802                 revert TransferToNonERC721ReceiverImplementer();
803             }
804     }
805 
806     /**
807      * @dev Returns whether `tokenId` exists.
808      *
809      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
810      *
811      * Tokens start existing when they are minted (`_mint`),
812      */
813     function _exists(uint256 tokenId) internal view returns (bool) {
814         return
815             _startTokenId() <= tokenId &&
816             tokenId < _currentIndex && // If within bounds,
817             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
818     }
819 
820     /**
821      * @dev Equivalent to `_safeMint(to, quantity, '')`.
822      */
823     function _safeMint(address to, uint256 quantity) internal {
824         _safeMint(to, quantity, '');
825     }
826 
827     /**
828      * @dev Safely mints `quantity` tokens and transfers them to `to`.
829      *
830      * Requirements:
831      *
832      * - If `to` refers to a smart contract, it must implement
833      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
834      * - `quantity` must be greater than 0.
835      *
836      * See {_mint}.
837      *
838      * Emits a {Transfer} event for each mint.
839      */
840     function _safeMint(
841         address to,
842         uint256 quantity,
843         bytes memory _data
844     ) internal {
845         _mint(to, quantity);
846 
847         unchecked {
848             if (to.code.length != 0) {
849                 uint256 end = _currentIndex;
850                 uint256 index = end - quantity;
851                 do {
852                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
853                         revert TransferToNonERC721ReceiverImplementer();
854                     }
855                 } while (index < end);
856                 // Reentrancy protection.
857                 if (_currentIndex != end) revert();
858             }
859         }
860     }
861 
862     /**
863      * @dev Mints `quantity` tokens and transfers them to `to`.
864      *
865      * Requirements:
866      *
867      * - `to` cannot be the zero address.
868      * - `quantity` must be greater than 0.
869      *
870      * Emits a {Transfer} event for each mint.
871      */
872     function _mint(address to, uint256 quantity) internal {
873         uint256 startTokenId = _currentIndex;
874         if (to == address(0)) revert MintToZeroAddress();
875         if (quantity == 0) revert MintZeroQuantity();
876 
877         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
878 
879         // Overflows are incredibly unrealistic.
880         // `balance` and `numberMinted` have a maximum limit of 2**64.
881         // `tokenId` has a maximum limit of 2**256.
882         unchecked {
883             // Updates:
884             // - `balance += quantity`.
885             // - `numberMinted += quantity`.
886             //
887             // We can directly add to the `balance` and `numberMinted`.
888             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
889 
890             // Updates:
891             // - `address` to the owner.
892             // - `startTimestamp` to the timestamp of minting.
893             // - `burned` to `false`.
894             // - `nextInitialized` to `quantity == 1`.
895             _packedOwnerships[startTokenId] = _packOwnershipData(
896                 to,
897                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
898             );
899 
900             uint256 tokenId = startTokenId;
901             uint256 end = startTokenId + quantity;
902             do {
903                 emit Transfer(address(0), to, tokenId++);
904             } while (tokenId < end);
905 
906             _currentIndex = end;
907         }
908         _afterTokenTransfers(address(0), to, startTokenId, quantity);
909     }
910 
911     /**
912      * @dev Mints `quantity` tokens and transfers them to `to`.
913      *
914      * This function is intended for efficient minting only during contract creation.
915      *
916      * It emits only one {ConsecutiveTransfer} as defined in
917      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
918      * instead of a sequence of {Transfer} event(s).
919      *
920      * Calling this function outside of contract creation WILL make your contract
921      * non-compliant with the ERC721 standard.
922      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
923      * {ConsecutiveTransfer} event is only permissible during contract creation.
924      *
925      * Requirements:
926      *
927      * - `to` cannot be the zero address.
928      * - `quantity` must be greater than 0.
929      *
930      * Emits a {ConsecutiveTransfer} event.
931      */
932     function _mintERC2309(address to, uint256 quantity) internal {
933         uint256 startTokenId = _currentIndex;
934         if (to == address(0)) revert MintToZeroAddress();
935         if (quantity == 0) revert MintZeroQuantity();
936         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
937 
938         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
939 
940         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
941         unchecked {
942             // Updates:
943             // - `balance += quantity`.
944             // - `numberMinted += quantity`.
945             //
946             // We can directly add to the `balance` and `numberMinted`.
947             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
948 
949             // Updates:
950             // - `address` to the owner.
951             // - `startTimestamp` to the timestamp of minting.
952             // - `burned` to `false`.
953             // - `nextInitialized` to `quantity == 1`.
954             _packedOwnerships[startTokenId] = _packOwnershipData(
955                 to,
956                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
957             );
958 
959             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
960 
961             _currentIndex = startTokenId + quantity;
962         }
963         _afterTokenTransfers(address(0), to, startTokenId, quantity);
964     }
965 
966     /**
967      * @dev Returns the storage slot and value for the approved address of `tokenId`.
968      */
969     function _getApprovedAddress(uint256 tokenId)
970         private
971         view
972         returns (uint256 approvedAddressSlot, address approvedAddress)
973     {
974         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
975         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
976         assembly {
977             // Compute the slot.
978             mstore(0x00, tokenId)
979             mstore(0x20, tokenApprovalsPtr.slot)
980             approvedAddressSlot := keccak256(0x00, 0x40)
981             // Load the slot's value from storage.
982             approvedAddress := sload(approvedAddressSlot)
983         }
984     }
985 
986     /**
987      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
988      */
989     function _isOwnerOrApproved(
990         address approvedAddress,
991         address from,
992         address msgSender
993     ) private pure returns (bool result) {
994         assembly {
995             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
996             from := and(from, BITMASK_ADDRESS)
997             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
998             msgSender := and(msgSender, BITMASK_ADDRESS)
999             // `msgSender == from || msgSender == approvedAddress`.
1000             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1001         }
1002     }
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function transferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1020 
1021         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1022 
1023         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1024 
1025         // The nested ifs save around 20+ gas over a compound boolean condition.
1026         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1027             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1028 
1029         if (to == address(0)) revert TransferToZeroAddress();
1030 
1031         _beforeTokenTransfers(from, to, tokenId, 1);
1032 
1033         // Clear approvals from the previous owner.
1034         assembly {
1035             if approvedAddress {
1036                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1037                 sstore(approvedAddressSlot, 0)
1038             }
1039         }
1040 
1041         // Underflow of the sender's balance is impossible because we check for
1042         // ownership above and the recipient's balance can't realistically overflow.
1043         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1044         unchecked {
1045             // We can directly increment and decrement the balances.
1046             --_packedAddressData[from]; // Updates: `balance -= 1`.
1047             ++_packedAddressData[to]; // Updates: `balance += 1`.
1048 
1049             // Updates:
1050             // - `address` to the next owner.
1051             // - `startTimestamp` to the timestamp of transfering.
1052             // - `burned` to `false`.
1053             // - `nextInitialized` to `true`.
1054             _packedOwnerships[tokenId] = _packOwnershipData(
1055                 to,
1056                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1057             );
1058 
1059             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1060             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1061                 uint256 nextTokenId = tokenId + 1;
1062                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1063                 if (_packedOwnerships[nextTokenId] == 0) {
1064                     // If the next slot is within bounds.
1065                     if (nextTokenId != _currentIndex) {
1066                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1067                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1068                     }
1069                 }
1070             }
1071         }
1072 
1073         emit Transfer(from, to, tokenId);
1074         _afterTokenTransfers(from, to, tokenId, 1);
1075     }
1076 
1077     /**
1078      * @dev Equivalent to `_burn(tokenId, false)`.
1079      */
1080     function _burn(uint256 tokenId) public virtual {
1081         _burn(tokenId, false);
1082     }
1083 
1084     /**
1085      * @dev Destroys `tokenId`.
1086      * The approval is cleared when the token is burned.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1095         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1096 
1097         address from = address(uint160(prevOwnershipPacked));
1098 
1099         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1100 
1101         if (approvalCheck) {
1102             // The nested ifs save around 20+ gas over a compound boolean condition.
1103             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1104                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1105         }
1106 
1107         _beforeTokenTransfers(from, address(0), tokenId, 1);
1108 
1109         // Clear approvals from the previous owner.
1110         assembly {
1111             if approvedAddress {
1112                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1113                 sstore(approvedAddressSlot, 0)
1114             }
1115         }
1116 
1117         // Underflow of the sender's balance is impossible because we check for
1118         // ownership above and the recipient's balance can't realistically overflow.
1119         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1120         unchecked {
1121             // Updates:
1122             // - `balance -= 1`.
1123             // - `numberBurned += 1`.
1124             //
1125             // We can directly decrement the balance, and increment the number burned.
1126             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1127             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1128 
1129             // Updates:
1130             // - `address` to the last owner.
1131             // - `startTimestamp` to the timestamp of burning.
1132             // - `burned` to `true`.
1133             // - `nextInitialized` to `true`.
1134             _packedOwnerships[tokenId] = _packOwnershipData(
1135                 from,
1136                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1137             );
1138 
1139             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1140             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1141                 uint256 nextTokenId = tokenId + 1;
1142                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1143                 if (_packedOwnerships[nextTokenId] == 0) {
1144                     // If the next slot is within bounds.
1145                     if (nextTokenId != _currentIndex) {
1146                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1147                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1148                     }
1149                 }
1150             }
1151         }
1152 
1153         emit Transfer(from, address(0), tokenId);
1154         _afterTokenTransfers(from, address(0), tokenId, 1);
1155 
1156         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1157         unchecked {
1158             _burnCounter++;
1159         }
1160     }
1161 
1162     /**
1163      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1164      *
1165      * @param from address representing the previous owner of the given token ID
1166      * @param to target address that will receive the tokens
1167      * @param tokenId uint256 ID of the token to be transferred
1168      * @param _data bytes optional data to send along with the call
1169      * @return bool whether the call correctly returned the expected magic value
1170      */
1171     function _checkContractOnERC721Received(
1172         address from,
1173         address to,
1174         uint256 tokenId,
1175         bytes memory _data
1176     ) private returns (bool) {
1177         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1178             bytes4 retval
1179         ) {
1180             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1181         } catch (bytes memory reason) {
1182             if (reason.length == 0) {
1183                 revert TransferToNonERC721ReceiverImplementer();
1184             } else {
1185                 assembly {
1186                     revert(add(32, reason), mload(reason))
1187                 }
1188             }
1189         }
1190     }
1191 
1192     /**
1193      * @dev Directly sets the extra data for the ownership data `index`.
1194      */
1195     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1196         uint256 packed = _packedOwnerships[index];
1197         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1198         uint256 extraDataCasted;
1199         // Cast `extraData` with assembly to avoid redundant masking.
1200         assembly {
1201             extraDataCasted := extraData
1202         }
1203         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1204         _packedOwnerships[index] = packed;
1205     }
1206 
1207     /**
1208      * @dev Returns the next extra data for the packed ownership data.
1209      * The returned result is shifted into position.
1210      */
1211     function _nextExtraData(
1212         address from,
1213         address to,
1214         uint256 prevOwnershipPacked
1215     ) private view returns (uint256) {
1216         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1217         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1218     }
1219 
1220     /**
1221      * @dev Called during each token transfer to set the 24bit `extraData` field.
1222      * Intended to be overridden by the cosumer contract.
1223      *
1224      * `previousExtraData` - the value of `extraData` before transfer.
1225      *
1226      * Calling conditions:
1227      *
1228      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1229      * transferred to `to`.
1230      * - When `from` is zero, `tokenId` will be minted for `to`.
1231      * - When `to` is zero, `tokenId` will be burned by `from`.
1232      * - `from` and `to` are never both zero.
1233      */
1234     function _extraData(
1235         address from,
1236         address to,
1237         uint24 previousExtraData
1238     ) internal view virtual returns (uint24) {}
1239 
1240     /**
1241      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1242      * This includes minting.
1243      * And also called before burning one token.
1244      *
1245      * startTokenId - the first token id to be transferred
1246      * quantity - the amount to be transferred
1247      *
1248      * Calling conditions:
1249      *
1250      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1251      * transferred to `to`.
1252      * - When `from` is zero, `tokenId` will be minted for `to`.
1253      * - When `to` is zero, `tokenId` will be burned by `from`.
1254      * - `from` and `to` are never both zero.
1255      */
1256     function _beforeTokenTransfers(
1257         address from,
1258         address to,
1259         uint256 startTokenId,
1260         uint256 quantity
1261     ) internal virtual {}
1262 
1263     /**
1264      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1265      * This includes minting.
1266      * And also called after one token has been burned.
1267      *
1268      * startTokenId - the first token id to be transferred
1269      * quantity - the amount to be transferred
1270      *
1271      * Calling conditions:
1272      *
1273      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1274      * transferred to `to`.
1275      * - When `from` is zero, `tokenId` has been minted for `to`.
1276      * - When `to` is zero, `tokenId` has been burned by `from`.
1277      * - `from` and `to` are never both zero.
1278      */
1279     function _afterTokenTransfers(
1280         address from,
1281         address to,
1282         uint256 startTokenId,
1283         uint256 quantity
1284     ) internal virtual {}
1285 
1286     /**
1287      * @dev Returns the message sender (defaults to `msg.sender`).
1288      *
1289      * If you are writing GSN compatible contracts, you need to override this function.
1290      */
1291     function _msgSenderERC721A() internal view virtual returns (address) {
1292         return msg.sender;
1293     }
1294 
1295     /**
1296      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1297      */
1298     function _toString(uint256 value) internal pure returns (string memory ptr) {
1299         assembly {
1300             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1301             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1302             // We will need 1 32-byte word to store the length,
1303             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1304             ptr := add(mload(0x40), 128)
1305             // Update the free memory pointer to allocate.
1306             mstore(0x40, ptr)
1307 
1308             // Cache the end of the memory to calculate the length later.
1309             let end := ptr
1310 
1311             // We write the string from the rightmost digit to the leftmost digit.
1312             // The following is essentially a do-while loop that also handles the zero case.
1313             // Costs a bit more than early returning for the zero case,
1314             // but cheaper in terms of deployment and overall runtime costs.
1315             for {
1316                 // Initialize and perform the first pass without check.
1317                 let temp := value
1318                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1319                 ptr := sub(ptr, 1)
1320                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1321                 mstore8(ptr, add(48, mod(temp, 10)))
1322                 temp := div(temp, 10)
1323             } temp {
1324                 // Keep dividing `temp` until zero.
1325                 temp := div(temp, 10)
1326             } {
1327                 // Body of the for loop.
1328                 ptr := sub(ptr, 1)
1329                 mstore8(ptr, add(48, mod(temp, 10)))
1330             }
1331 
1332             let length := sub(end, ptr)
1333             // Move the pointer 32 bytes leftwards to make room for the length.
1334             ptr := sub(ptr, 32)
1335             // Store the length.
1336             mstore(ptr, length)
1337         }
1338     }
1339 }
1340 
1341 contract WhoDoneIt is Ownable, ERC721A, ReentrancyGuard  {
1342     using Strings for uint256;
1343     string public uri;
1344 
1345     uint public status = 0;
1346     uint MAX_PER_ADDRESS_PRESALE = 2;
1347     uint MAX_PER_ADDRESS_PUBLICSALE = 2;
1348     uint COLLECTION_SIZE = 3333;
1349 
1350     // uint public WhoDunIt_2_status = 0;
1351     address public Season_2_Address;
1352     // function setWhoDunIt_2_Status(uint s) public onlyOwner{
1353     //     WhoDunIt_2_status = s;
1354     // }
1355     function set_Season_2_Address(address a) public onlyOwner{
1356         Season_2_Address = a;
1357     }
1358 
1359     bytes32 public merkleRoot = 0xa6938c1d2dab3b17b942ea8c0c214f87c95a145b8726e8466e2e8118f7d0d8cd;
1360     function setMerkleRoot(bytes32 m) public onlyOwner{
1361         merkleRoot = m;
1362     }
1363 
1364     function _burn(uint tokenId) public override{
1365         require(msg.sender == Season_2_Address, "Unauthorized burn");
1366         _burn(tokenId, false);
1367     }
1368 
1369     modifier callerIsUser() {
1370         require(tx.origin == msg.sender, "The caller is another contract");
1371         _;
1372     }
1373 
1374     constructor() ERC721A("WhoDunIt", "WDI") {
1375         uri = "https://bafybeifpqrrktm4caokbnhkezhbdzc5qg4ff7c7hc2wxtvxd2n7zmuatru.ipfs.nftstorage.link/";
1376     }
1377 
1378     function presaleMint(uint256 quantity, bytes32[] calldata merkleproof) public callerIsUser{
1379         require(status == 1, "Whitelist not active!!");
1380         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1381         require(MerkleProof.verify( merkleproof, merkleRoot, leaf),"Not whitelisted");
1382         require(numberMinted(msg.sender) + quantity <= MAX_PER_ADDRESS_PRESALE, "Minted max on presale!!");
1383         require(totalSupply() <= COLLECTION_SIZE, "SOLD OUT!!");
1384         
1385         _safeMint(msg.sender, quantity, "");
1386     }
1387 
1388     function mint(uint256 quantity) public callerIsUser{
1389         require(status == 2, "Public Sale not active!!");
1390         require(numberMinted(msg.sender) + quantity <= MAX_PER_ADDRESS_PUBLICSALE, "Minted max on Public Sale!!");
1391         require(totalSupply() <= COLLECTION_SIZE, "SOLD OUT!!");
1392 
1393         _safeMint(msg.sender, quantity, "");
1394     }
1395 
1396     function numberMinted(address owner) public view returns (uint256) {
1397         return _numberMinted(owner);
1398     }
1399 
1400     function giveaway(address to, uint256 quantity) public onlyOwner callerIsUser{
1401         require(totalSupply() <= COLLECTION_SIZE, "SOLD OUT!!");
1402         _safeMint(to, quantity, "");
1403     }
1404 
1405     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1406         require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token!");
1407         return bytes(baseURI()).length > 0 ? string(abi.encodePacked(baseURI(), tokenId.toString(), ".json")) : "";
1408     }
1409 
1410     function baseURI() public view returns (string memory) {
1411         return uri;
1412     }
1413 
1414     function setBaseURI(string memory u) public onlyOwner{
1415         uri = u;
1416     }
1417 
1418     function setWalletLimits(uint presale, uint publicSale) public onlyOwner{
1419         MAX_PER_ADDRESS_PRESALE = presale;
1420         MAX_PER_ADDRESS_PUBLICSALE = publicSale;
1421     }
1422 
1423     function setStatus(uint s) public onlyOwner{
1424         status = s;
1425     }
1426 
1427     function _startTokenId() pure internal override returns (uint256) {
1428         return 1;
1429     }
1430 }