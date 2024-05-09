1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: contracts/IERC721A.sol
80 
81 
82 // ERC721A Contracts v4.1.0
83 // Creator: Chiru Labs
84 
85 pragma solidity ^0.8.4;
86 
87 /**
88  * @dev Interface of an ERC721A compliant contract.
89  */
90 interface IERC721A {
91     /**
92      * The caller must own the token or be an approved operator.
93      */
94     error ApprovalCallerNotOwnerNorApproved();
95 
96     /**
97      * The token does not exist.
98      */
99     error ApprovalQueryForNonexistentToken();
100 
101     /**
102      * The caller cannot approve to their own address.
103      */
104     error ApproveToCaller();
105 
106     /**
107      * Cannot query the balance for the zero address.
108      */
109     error BalanceQueryForZeroAddress();
110 
111     /**
112      * Cannot mint to the zero address.
113      */
114     error MintToZeroAddress();
115 
116     /**
117      * The quantity of tokens minted must be more than zero.
118      */
119     error MintZeroQuantity();
120 
121     /**
122      * The token does not exist.
123      */
124     error OwnerQueryForNonexistentToken();
125 
126     /**
127      * The caller must own the token or be an approved operator.
128      */
129     error TransferCallerNotOwnerNorApproved();
130 
131     /**
132      * The token must be owned by `from`.
133      */
134     error TransferFromIncorrectOwner();
135 
136     /**
137      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
138      */
139     error TransferToNonERC721ReceiverImplementer();
140 
141     /**
142      * Cannot transfer to the zero address.
143      */
144     error TransferToZeroAddress();
145 
146     /**
147      * The token does not exist.
148      */
149     error URIQueryForNonexistentToken();
150 
151     /**
152      * The `quantity` minted with ERC2309 exceeds the safety limit.
153      */
154     error MintERC2309QuantityExceedsLimit();
155 
156     /**
157      * The `extraData` cannot be set on an unintialized ownership slot.
158      */
159     error OwnershipNotInitializedForExtraData();
160 
161     struct TokenOwnership {
162         // The address of the owner.
163         address addr;
164         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
165         uint64 startTimestamp;
166         // Whether the token has been burned.
167         bool burned;
168         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
169         uint24 extraData;
170     }
171 
172     /**
173      * @dev Returns the total amount of tokens stored by the contract.
174      *
175      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     // ==============================
180     //            IERC165
181     // ==============================
182 
183     /**
184      * @dev Returns true if this contract implements the interface defined by
185      * `interfaceId`. See the corresponding
186      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
187      * to learn more about how these ids are created.
188      *
189      * This function call must use less than 30 000 gas.
190      */
191     function supportsInterface(bytes4 interfaceId) external view returns (bool);
192 
193     // ==============================
194     //            IERC721
195     // ==============================
196 
197     /**
198      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
199      */
200     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
201 
202     /**
203      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
204      */
205     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
206 
207     /**
208      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
209      */
210     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
211 
212     /**
213      * @dev Returns the number of tokens in ``owner``'s account.
214      */
215     function balanceOf(address owner) external view returns (uint256 balance);
216 
217     /**
218      * @dev Returns the owner of the `tokenId` token.
219      *
220      * Requirements:
221      *
222      * - `tokenId` must exist.
223      */
224     function ownerOf(uint256 tokenId) external view returns (address owner);
225 
226     /**
227      * @dev Safely transfers `tokenId` token from `from` to `to`.
228      *
229      * Requirements:
230      *
231      * - `from` cannot be the zero address.
232      * - `to` cannot be the zero address.
233      * - `tokenId` token must exist and be owned by `from`.
234      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
235      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
236      *
237      * Emits a {Transfer} event.
238      */
239     function safeTransferFrom(
240         address from,
241         address to,
242         uint256 tokenId,
243         bytes calldata data
244     ) external;
245 
246     /**
247      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
248      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must exist and be owned by `from`.
255      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
257      *
258      * Emits a {Transfer} event.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId
264     ) external;
265 
266     /**
267      * @dev Transfers `tokenId` token from `from` to `to`.
268      *
269      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must be owned by `from`.
276      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transferFrom(
281         address from,
282         address to,
283         uint256 tokenId
284     ) external;
285 
286     /**
287      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
288      * The approval is cleared when the token is transferred.
289      *
290      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
291      *
292      * Requirements:
293      *
294      * - The caller must own the token or be an approved operator.
295      * - `tokenId` must exist.
296      *
297      * Emits an {Approval} event.
298      */
299     function approve(address to, uint256 tokenId) external;
300 
301     /**
302      * @dev Approve or remove `operator` as an operator for the caller.
303      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
304      *
305      * Requirements:
306      *
307      * - The `operator` cannot be the caller.
308      *
309      * Emits an {ApprovalForAll} event.
310      */
311     function setApprovalForAll(address operator, bool _approved) external;
312 
313     /**
314      * @dev Returns the account approved for `tokenId` token.
315      *
316      * Requirements:
317      *
318      * - `tokenId` must exist.
319      */
320     function getApproved(uint256 tokenId) external view returns (address operator);
321 
322     /**
323      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
324      *
325      * See {setApprovalForAll}
326      */
327     function isApprovedForAll(address owner, address operator) external view returns (bool);
328 
329     // ==============================
330     //        IERC721Metadata
331     // ==============================
332 
333     /**
334      * @dev Returns the token collection name.
335      */
336     function name() external view returns (string memory);
337 
338     /**
339      * @dev Returns the token collection symbol.
340      */
341     function symbol() external view returns (string memory);
342 
343     /**
344      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
345      */
346     function tokenURI(uint256 tokenId) external view returns (string memory);
347 
348     // ==============================
349     //            IERC2309
350     // ==============================
351 
352     /**
353      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
354      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
355      */
356     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
357 }
358 
359 // File: contracts/ERC721A.sol
360 
361 
362 // ERC721A Contracts v4.1.0
363 // Creator: Chiru Labs
364 
365 pragma solidity ^0.8.4;
366 
367 
368 /**
369  * @dev ERC721 token receiver interface.
370  */
371 interface ERC721A__IERC721Receiver {
372     function onERC721Received(
373         address operator,
374         address from,
375         uint256 tokenId,
376         bytes calldata data
377     ) external returns (bytes4);
378 }
379 
380 /**
381  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
382  * including the Metadata extension. Built to optimize for lower gas during batch mints.
383  *
384  * Assumes serials are sequentially minted starting at `_startTokenId()`
385  * (defaults to 0, e.g. 0, 1, 2, 3..).
386  *
387  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
388  *
389  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
390  */
391 contract ERC721A is IERC721A {
392     // Mask of an entry in packed address data.
393     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
394 
395     // The bit position of `numberMinted` in packed address data.
396     uint256 private constant BITPOS_NUMBER_MINTED = 64;
397 
398     // The bit position of `numberBurned` in packed address data.
399     uint256 private constant BITPOS_NUMBER_BURNED = 128;
400 
401     // The bit position of `aux` in packed address data.
402     uint256 private constant BITPOS_AUX = 192;
403 
404     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
405     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
406 
407     // The bit position of `startTimestamp` in packed ownership.
408     uint256 private constant BITPOS_START_TIMESTAMP = 160;
409 
410     // The bit mask of the `burned` bit in packed ownership.
411     uint256 private constant BITMASK_BURNED = 1 << 224;
412 
413     // The bit position of the `nextInitialized` bit in packed ownership.
414     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
415 
416     // The bit mask of the `nextInitialized` bit in packed ownership.
417     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
418 
419     // The bit position of `extraData` in packed ownership.
420     uint256 private constant BITPOS_EXTRA_DATA = 232;
421 
422     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
423     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
424 
425     // The mask of the lower 160 bits for addresses.
426     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
427 
428     // The maximum `quantity` that can be minted with `_mintERC2309`.
429     // This limit is to prevent overflows on the address data entries.
430     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
431     // is required to cause an overflow, which is unrealistic.
432     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
433 
434     // The tokenId of the next token to be minted.
435     uint256 private _currentIndex;
436 
437     // The number of tokens burned.
438     uint256 private _burnCounter;
439 
440     // Token name
441     string private _name;
442 
443     // Token symbol
444     string private _symbol;
445 
446     // Mapping from token ID to ownership details
447     // An empty struct value does not necessarily mean the token is unowned.
448     // See `_packedOwnershipOf` implementation for details.
449     //
450     // Bits Layout:
451     // - [0..159]   `addr`
452     // - [160..223] `startTimestamp`
453     // - [224]      `burned`
454     // - [225]      `nextInitialized`
455     // - [232..255] `extraData`
456     mapping(uint256 => uint256) private _packedOwnerships;
457 
458     // Mapping owner address to address data.
459     //
460     // Bits Layout:
461     // - [0..63]    `balance`
462     // - [64..127]  `numberMinted`
463     // - [128..191] `numberBurned`
464     // - [192..255] `aux`
465     mapping(address => uint256) private _packedAddressData;
466 
467     // Mapping from token ID to approved address.
468     mapping(uint256 => address) private _tokenApprovals;
469 
470     // Mapping from owner to operator approvals
471     mapping(address => mapping(address => bool)) private _operatorApprovals;
472 
473     constructor(string memory name_, string memory symbol_) {
474         _name = name_;
475         _symbol = symbol_;
476         _currentIndex = _startTokenId();
477     }
478 
479     /**
480      * @dev Returns the starting token ID.
481      * To change the starting token ID, please override this function.
482      */
483     function _startTokenId() internal view virtual returns (uint256) {
484         return 0;
485     }
486 
487     /**
488      * @dev Returns the next token ID to be minted.
489      */
490     function _nextTokenId() internal view virtual returns (uint256) {
491         return _currentIndex;
492     }
493 
494     /**
495      * @dev Returns the total number of tokens in existence.
496      * Burned tokens will reduce the count.
497      * To get the total number of tokens minted, please see `_totalMinted`.
498      */
499     function totalSupply() public view virtual override returns (uint256) {
500         // Counter underflow is impossible as _burnCounter cannot be incremented
501         // more than `_currentIndex - _startTokenId()` times.
502         unchecked {
503             return _currentIndex - _burnCounter - _startTokenId();
504         }
505     }
506 
507     /**
508      * @dev Returns the total amount of tokens minted in the contract.
509      */
510     function _totalMinted() internal view virtual returns (uint256) {
511         // Counter underflow is impossible as _currentIndex does not decrement,
512         // and it is initialized to `_startTokenId()`
513         unchecked {
514             return _currentIndex - _startTokenId();
515         }
516     }
517 
518     /**
519      * @dev Returns the total number of tokens burned.
520      */
521     function _totalBurned() internal view virtual returns (uint256) {
522         return _burnCounter;
523     }
524 
525     /**
526      * @dev See {IERC165-supportsInterface}.
527      */
528     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529         // The interface IDs are constants representing the first 4 bytes of the XOR of
530         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
531         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
532         return
533             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
534             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
535             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
536     }
537 
538     /**
539      * @dev See {IERC721-balanceOf}.
540      */
541     function balanceOf(address owner) public view virtual override returns (uint256) {
542         if (owner == address(0)) revert BalanceQueryForZeroAddress();
543         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
544     }
545 
546     /**
547      * Returns the number of tokens minted by `owner`.
548      */
549     function _numberMinted(address owner) internal view virtual returns (uint256) {
550         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
551     }
552 
553     /**
554      * Returns the number of tokens burned by or on behalf of `owner`.
555      */
556     function _numberBurned(address owner) internal view virtual returns (uint256) {
557         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
558     }
559 
560     /**
561      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
562      */
563     function _getAux(address owner) internal view virtual returns (uint64) {
564         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
565     }
566 
567     /**
568      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
569      * If there are multiple variables, please pack them into a uint64.
570      */
571     function _setAux(address owner, uint64 aux) internal virtual {
572         uint256 packed = _packedAddressData[owner];
573         uint256 auxCasted;
574         // Cast `aux` with assembly to avoid redundant masking.
575         assembly {
576             auxCasted := aux
577         }
578         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
579         _packedAddressData[owner] = packed;
580     }
581 
582     /**
583      * Returns the packed ownership data of `tokenId`.
584      */
585     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
586         uint256 curr = tokenId;
587 
588         unchecked {
589             if (_startTokenId() <= curr)
590                 if (curr < _currentIndex) {
591                     uint256 packed = _packedOwnerships[curr];
592                     // If not burned.
593                     if (packed & BITMASK_BURNED == 0) {
594                         // Invariant:
595                         // There will always be an ownership that has an address and is not burned
596                         // before an ownership that does not have an address and is not burned.
597                         // Hence, curr will not underflow.
598                         //
599                         // We can directly compare the packed value.
600                         // If the address is zero, packed is zero.
601                         while (packed == 0) {
602                             packed = _packedOwnerships[--curr];
603                         }
604                         return packed;
605                     }
606                 }
607         }
608         revert OwnerQueryForNonexistentToken();
609     }
610 
611     /**
612      * Returns the unpacked `TokenOwnership` struct from `packed`.
613      */
614     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
615         ownership.addr = address(uint160(packed));
616         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
617         ownership.burned = packed & BITMASK_BURNED != 0;
618         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
619     }
620 
621     /**
622      * Returns the unpacked `TokenOwnership` struct at `index`.
623      */
624     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
625         return _unpackedOwnership(_packedOwnerships[index]);
626     }
627 
628     /**
629      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
630      */
631     function _initializeOwnershipAt(uint256 index) internal virtual {
632         if (_packedOwnerships[index] == 0) {
633             _packedOwnerships[index] = _packedOwnershipOf(index);
634         }
635     }
636 
637     /**
638      * Gas spent here starts off proportional to the maximum mint batch size.
639      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
640      */
641     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
642         return _unpackedOwnership(_packedOwnershipOf(tokenId));
643     }
644 
645     /**
646      * @dev Packs ownership data into a single uint256.
647      */
648     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
649         assembly {
650             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
651             owner := and(owner, BITMASK_ADDRESS)
652             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
653             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
654         }
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
661         return address(uint160(_packedOwnershipOf(tokenId)));
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-name}.
666      */
667     function name() public view virtual override returns (string memory) {
668         return _name;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-symbol}.
673      */
674     function symbol() public view virtual override returns (string memory) {
675         return _symbol;
676     }
677 
678     /**
679      * @dev See {IERC721Metadata-tokenURI}.
680      */
681     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
682         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
683 
684         string memory baseURI = _baseURI();
685         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
686     }
687 
688     /**
689      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
690      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
691      * by default, it can be overridden in child contracts.
692      */
693     function _baseURI() internal view virtual returns (string memory) {
694         return '';
695     }
696 
697     /**
698      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
699      */
700     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
701         // For branchless setting of the `nextInitialized` flag.
702         assembly {
703             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
704             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
705         }
706     }
707 
708     /**
709      * @dev See {IERC721-approve}.
710      */
711     function approve(address to, uint256 tokenId) public virtual override {
712         address owner = ownerOf(tokenId);
713 
714         if (_msgSenderERC721A() != owner)
715             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
716                 revert ApprovalCallerNotOwnerNorApproved();
717             }
718 
719         _tokenApprovals[tokenId] = to;
720         emit Approval(owner, to, tokenId);
721     }
722 
723     /**
724      * @dev See {IERC721-getApproved}.
725      */
726     function getApproved(uint256 tokenId) public view virtual override returns (address) {
727         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
728 
729         return _tokenApprovals[tokenId];
730     }
731 
732     /**
733      * @dev See {IERC721-setApprovalForAll}.
734      */
735     function setApprovalForAll(address operator, bool approved) public virtual override {
736         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
737 
738         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
739         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
740     }
741 
742     /**
743      * @dev See {IERC721-isApprovedForAll}.
744      */
745     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
746         return _operatorApprovals[owner][operator];
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId
756     ) public virtual override {
757         safeTransferFrom(from, to, tokenId, '');
758     }
759 
760     /**
761      * @dev See {IERC721-safeTransferFrom}.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes memory _data
768     ) public virtual override {
769         transferFrom(from, to, tokenId);
770         if (to.code.length != 0)
771             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
772                 revert TransferToNonERC721ReceiverImplementer();
773             }
774     }
775 
776     /**
777      * @dev Returns whether `tokenId` exists.
778      *
779      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
780      *
781      * Tokens start existing when they are minted (`_mint`),
782      */
783     function _exists(uint256 tokenId) internal view virtual returns (bool) {
784         return
785             _startTokenId() <= tokenId &&
786             tokenId < _currentIndex && // If within bounds,
787             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
788     }
789 
790     /**
791      * @dev Equivalent to `_safeMint(to, quantity, '')`.
792      */
793     function _safeMint(address to, uint256 quantity) internal virtual {
794         _safeMint(to, quantity, '');
795     }
796 
797     /**
798      * @dev Safely mints `quantity` tokens and transfers them to `to`.
799      *
800      * Requirements:
801      *
802      * - If `to` refers to a smart contract, it must implement
803      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
804      * - `quantity` must be greater than 0.
805      *
806      * See {_mint}.
807      *
808      * Emits a {Transfer} event for each mint.
809      */
810     function _safeMint(
811         address to,
812         uint256 quantity,
813         bytes memory _data
814     ) internal virtual {
815         _mint(to, quantity);
816 
817         unchecked {
818             if (to.code.length != 0) {
819                 uint256 end = _currentIndex;
820                 uint256 index = end - quantity;
821                 do {
822                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
823                         revert TransferToNonERC721ReceiverImplementer();
824                     }
825                 } while (index < end);
826                 // Reentrancy protection.
827                 if (_currentIndex != end) revert();
828             }
829         }
830     }
831 
832     /**
833      * @dev Mints `quantity` tokens and transfers them to `to`.
834      *
835      * Requirements:
836      *
837      * - `to` cannot be the zero address.
838      * - `quantity` must be greater than 0.
839      *
840      * Emits a {Transfer} event for each mint.
841      */
842     function _mint(address to, uint256 quantity) internal virtual {
843         uint256 startTokenId = _currentIndex;
844         if (to == address(0)) revert MintToZeroAddress();
845         if (quantity == 0) revert MintZeroQuantity();
846 
847         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
848 
849         // Overflows are incredibly unrealistic.
850         // `balance` and `numberMinted` have a maximum limit of 2**64.
851         // `tokenId` has a maximum limit of 2**256.
852         unchecked {
853             // Updates:
854             // - `balance += quantity`.
855             // - `numberMinted += quantity`.
856             //
857             // We can directly add to the `balance` and `numberMinted`.
858             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
859 
860             // Updates:
861             // - `address` to the owner.
862             // - `startTimestamp` to the timestamp of minting.
863             // - `burned` to `false`.
864             // - `nextInitialized` to `quantity == 1`.
865             _packedOwnerships[startTokenId] = _packOwnershipData(
866                 to,
867                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
868             );
869 
870             uint256 tokenId = startTokenId;
871             uint256 end = startTokenId + quantity;
872             do {
873                 emit Transfer(address(0), to, tokenId++);
874             } while (tokenId < end);
875 
876             _currentIndex = end;
877         }
878         _afterTokenTransfers(address(0), to, startTokenId, quantity);
879     }
880 
881     /**
882      * @dev Mints `quantity` tokens and transfers them to `to`.
883      *
884      * This function is intended for efficient minting only during contract creation.
885      *
886      * It emits only one {ConsecutiveTransfer} as defined in
887      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
888      * instead of a sequence of {Transfer} event(s).
889      *
890      * Calling this function outside of contract creation WILL make your contract
891      * non-compliant with the ERC721 standard.
892      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
893      * {ConsecutiveTransfer} event is only permissible during contract creation.
894      *
895      * Requirements:
896      *
897      * - `to` cannot be the zero address.
898      * - `quantity` must be greater than 0.
899      *
900      * Emits a {ConsecutiveTransfer} event.
901      */
902     function _mintERC2309(address to, uint256 quantity) internal virtual {
903         uint256 startTokenId = _currentIndex;
904         if (to == address(0)) revert MintToZeroAddress();
905         if (quantity == 0) revert MintZeroQuantity();
906         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
907 
908         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
909 
910         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
911         unchecked {
912             // Updates:
913             // - `balance += quantity`.
914             // - `numberMinted += quantity`.
915             //
916             // We can directly add to the `balance` and `numberMinted`.
917             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
918 
919             // Updates:
920             // - `address` to the owner.
921             // - `startTimestamp` to the timestamp of minting.
922             // - `burned` to `false`.
923             // - `nextInitialized` to `quantity == 1`.
924             _packedOwnerships[startTokenId] = _packOwnershipData(
925                 to,
926                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
927             );
928 
929             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
930 
931             _currentIndex = startTokenId + quantity;
932         }
933         _afterTokenTransfers(address(0), to, startTokenId, quantity);
934     }
935 
936     /**
937      * @dev Returns the storage slot and value for the approved address of `tokenId`.
938      */
939     function _getApprovedAddress(uint256 tokenId)
940         private
941         view
942         returns (uint256 approvedAddressSlot, address approvedAddress)
943     {
944         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
945         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
946         assembly {
947             // Compute the slot.
948             mstore(0x00, tokenId)
949             mstore(0x20, tokenApprovalsPtr.slot)
950             approvedAddressSlot := keccak256(0x00, 0x40)
951             // Load the slot's value from storage.
952             approvedAddress := sload(approvedAddressSlot)
953         }
954     }
955 
956     /**
957      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
958      */
959     function _isOwnerOrApproved(
960         address approvedAddress,
961         address from,
962         address msgSender
963     ) private pure returns (bool result) {
964         assembly {
965             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
966             from := and(from, BITMASK_ADDRESS)
967             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
968             msgSender := and(msgSender, BITMASK_ADDRESS)
969             // `msgSender == from || msgSender == approvedAddress`.
970             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
971         }
972     }
973 
974     /**
975      * @dev Transfers `tokenId` from `from` to `to`.
976      *
977      * Requirements:
978      *
979      * - `to` cannot be the zero address.
980      * - `tokenId` token must be owned by `from`.
981      *
982      * Emits a {Transfer} event.
983      */
984     function transferFrom(
985         address from,
986         address to,
987         uint256 tokenId
988     ) public virtual override {
989         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
990 
991         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
992 
993         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
994 
995         // The nested ifs save around 20+ gas over a compound boolean condition.
996         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
997             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
998 
999         if (to == address(0)) revert TransferToZeroAddress();
1000 
1001         _beforeTokenTransfers(from, to, tokenId, 1);
1002 
1003         // Clear approvals from the previous owner.
1004         assembly {
1005             if approvedAddress {
1006                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1007                 sstore(approvedAddressSlot, 0)
1008             }
1009         }
1010 
1011         // Underflow of the sender's balance is impossible because we check for
1012         // ownership above and the recipient's balance can't realistically overflow.
1013         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1014         unchecked {
1015             // We can directly increment and decrement the balances.
1016             --_packedAddressData[from]; // Updates: `balance -= 1`.
1017             ++_packedAddressData[to]; // Updates: `balance += 1`.
1018 
1019             // Updates:
1020             // - `address` to the next owner.
1021             // - `startTimestamp` to the timestamp of transfering.
1022             // - `burned` to `false`.
1023             // - `nextInitialized` to `true`.
1024             _packedOwnerships[tokenId] = _packOwnershipData(
1025                 to,
1026                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1027             );
1028 
1029             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1030             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1031                 uint256 nextTokenId = tokenId + 1;
1032                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1033                 if (_packedOwnerships[nextTokenId] == 0) {
1034                     // If the next slot is within bounds.
1035                     if (nextTokenId != _currentIndex) {
1036                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1037                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1038                     }
1039                 }
1040             }
1041         }
1042 
1043         emit Transfer(from, to, tokenId);
1044         _afterTokenTransfers(from, to, tokenId, 1);
1045     }
1046 
1047     /**
1048      * @dev Equivalent to `_burn(tokenId, false)`.
1049      */
1050     function _burn(uint256 tokenId) internal virtual {
1051         _burn(tokenId, false);
1052     }
1053 
1054     /**
1055      * @dev Destroys `tokenId`.
1056      * The approval is cleared when the token is burned.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must exist.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1065         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1066 
1067         address from = address(uint160(prevOwnershipPacked));
1068 
1069         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1070 
1071         if (approvalCheck) {
1072             // The nested ifs save around 20+ gas over a compound boolean condition.
1073             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1074                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1075         }
1076 
1077         _beforeTokenTransfers(from, address(0), tokenId, 1);
1078 
1079         // Clear approvals from the previous owner.
1080         assembly {
1081             if approvedAddress {
1082                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1083                 sstore(approvedAddressSlot, 0)
1084             }
1085         }
1086 
1087         // Underflow of the sender's balance is impossible because we check for
1088         // ownership above and the recipient's balance can't realistically overflow.
1089         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1090         unchecked {
1091             // Updates:
1092             // - `balance -= 1`.
1093             // - `numberBurned += 1`.
1094             //
1095             // We can directly decrement the balance, and increment the number burned.
1096             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1097             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1098 
1099             // Updates:
1100             // - `address` to the last owner.
1101             // - `startTimestamp` to the timestamp of burning.
1102             // - `burned` to `true`.
1103             // - `nextInitialized` to `true`.
1104             _packedOwnerships[tokenId] = _packOwnershipData(
1105                 from,
1106                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1107             );
1108 
1109             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1110             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1111                 uint256 nextTokenId = tokenId + 1;
1112                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1113                 if (_packedOwnerships[nextTokenId] == 0) {
1114                     // If the next slot is within bounds.
1115                     if (nextTokenId != _currentIndex) {
1116                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1117                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1118                     }
1119                 }
1120             }
1121         }
1122 
1123         emit Transfer(from, address(0), tokenId);
1124         _afterTokenTransfers(from, address(0), tokenId, 1);
1125 
1126         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1127         unchecked {
1128             _burnCounter++;
1129         }
1130     }
1131 
1132     /**
1133      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1134      *
1135      * @param from address representing the previous owner of the given token ID
1136      * @param to target address that will receive the tokens
1137      * @param tokenId uint256 ID of the token to be transferred
1138      * @param _data bytes optional data to send along with the call
1139      * @return bool whether the call correctly returned the expected magic value
1140      */
1141     function _checkContractOnERC721Received(
1142         address from,
1143         address to,
1144         uint256 tokenId,
1145         bytes memory _data
1146     ) private returns (bool) {
1147         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1148             bytes4 retval
1149         ) {
1150             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1151         } catch (bytes memory reason) {
1152             if (reason.length == 0) {
1153                 revert TransferToNonERC721ReceiverImplementer();
1154             } else {
1155                 assembly {
1156                     revert(add(32, reason), mload(reason))
1157                 }
1158             }
1159         }
1160     }
1161 
1162     /**
1163      * @dev Directly sets the extra data for the ownership data `index`.
1164      */
1165     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1166         uint256 packed = _packedOwnerships[index];
1167         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1168         uint256 extraDataCasted;
1169         // Cast `extraData` with assembly to avoid redundant masking.
1170         assembly {
1171             extraDataCasted := extraData
1172         }
1173         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1174         _packedOwnerships[index] = packed;
1175     }
1176 
1177     /**
1178      * @dev Returns the next extra data for the packed ownership data.
1179      * The returned result is shifted into position.
1180      */
1181     function _nextExtraData(
1182         address from,
1183         address to,
1184         uint256 prevOwnershipPacked
1185     ) private view returns (uint256) {
1186         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1187         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1188     }
1189 
1190     /**
1191      * @dev Called during each token transfer to set the 24bit `extraData` field.
1192      * Intended to be overridden by the cosumer contract.
1193      *
1194      * `previousExtraData` - the value of `extraData` before transfer.
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      * - When `to` is zero, `tokenId` will be burned by `from`.
1202      * - `from` and `to` are never both zero.
1203      */
1204     function _extraData(
1205         address from,
1206         address to,
1207         uint24 previousExtraData
1208     ) internal view virtual returns (uint24) {}
1209 
1210     /**
1211      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1212      * This includes minting.
1213      * And also called before burning one token.
1214      *
1215      * startTokenId - the first token id to be transferred
1216      * quantity - the amount to be transferred
1217      *
1218      * Calling conditions:
1219      *
1220      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1221      * transferred to `to`.
1222      * - When `from` is zero, `tokenId` will be minted for `to`.
1223      * - When `to` is zero, `tokenId` will be burned by `from`.
1224      * - `from` and `to` are never both zero.
1225      */
1226     function _beforeTokenTransfers(
1227         address from,
1228         address to,
1229         uint256 startTokenId,
1230         uint256 quantity
1231     ) internal virtual {}
1232 
1233     /**
1234      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1235      * This includes minting.
1236      * And also called after one token has been burned.
1237      *
1238      * startTokenId - the first token id to be transferred
1239      * quantity - the amount to be transferred
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` has been minted for `to`.
1246      * - When `to` is zero, `tokenId` has been burned by `from`.
1247      * - `from` and `to` are never both zero.
1248      */
1249     function _afterTokenTransfers(
1250         address from,
1251         address to,
1252         uint256 startTokenId,
1253         uint256 quantity
1254     ) internal virtual {}
1255 
1256     /**
1257      * @dev Returns the message sender (defaults to `msg.sender`).
1258      *
1259      * If you are writing GSN compatible contracts, you need to override this function.
1260      */
1261     function _msgSenderERC721A() internal view virtual returns (address) {
1262         return msg.sender;
1263     }
1264 
1265     /**
1266      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1267      */
1268     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1269         assembly {
1270             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1271             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1272             // We will need 1 32-byte word to store the length,
1273             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1274             ptr := add(mload(0x40), 128)
1275             // Update the free memory pointer to allocate.
1276             mstore(0x40, ptr)
1277 
1278             // Cache the end of the memory to calculate the length later.
1279             let end := ptr
1280 
1281             // We write the string from the rightmost digit to the leftmost digit.
1282             // The following is essentially a do-while loop that also handles the zero case.
1283             // Costs a bit more than early returning for the zero case,
1284             // but cheaper in terms of deployment and overall runtime costs.
1285             for {
1286                 // Initialize and perform the first pass without check.
1287                 let temp := value
1288                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1289                 ptr := sub(ptr, 1)
1290                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1291                 mstore8(ptr, add(48, mod(temp, 10)))
1292                 temp := div(temp, 10)
1293             } temp {
1294                 // Keep dividing `temp` until zero.
1295                 temp := div(temp, 10)
1296             } {
1297                 // Body of the for loop.
1298                 ptr := sub(ptr, 1)
1299                 mstore8(ptr, add(48, mod(temp, 10)))
1300             }
1301 
1302             let length := sub(end, ptr)
1303             // Move the pointer 32 bytes leftwards to make room for the length.
1304             ptr := sub(ptr, 32)
1305             // Store the length.
1306             mstore(ptr, length)
1307         }
1308     }
1309 }
1310 
1311 // File: @openzeppelin/contracts/utils/Context.sol
1312 
1313 
1314 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1315 
1316 pragma solidity ^0.8.0;
1317 
1318 /**
1319  * @dev Provides information about the current execution context, including the
1320  * sender of the transaction and its data. While these are generally available
1321  * via msg.sender and msg.data, they should not be accessed in such a direct
1322  * manner, since when dealing with meta-transactions the account sending and
1323  * paying for execution may not be the actual sender (as far as an application
1324  * is concerned).
1325  *
1326  * This contract is only required for intermediate, library-like contracts.
1327  */
1328 abstract contract Context {
1329     function _msgSender() internal view virtual returns (address) {
1330         return msg.sender;
1331     }
1332 
1333     function _msgData() internal view virtual returns (bytes calldata) {
1334         return msg.data;
1335     }
1336 }
1337 
1338 // File: @openzeppelin/contracts/security/Pausable.sol
1339 
1340 
1341 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 
1346 /**
1347  * @dev Contract module which allows children to implement an emergency stop
1348  * mechanism that can be triggered by an authorized account.
1349  *
1350  * This module is used through inheritance. It will make available the
1351  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1352  * the functions of your contract. Note that they will not be pausable by
1353  * simply including this module, only once the modifiers are put in place.
1354  */
1355 abstract contract Pausable is Context {
1356     /**
1357      * @dev Emitted when the pause is triggered by `account`.
1358      */
1359     event Paused(address account);
1360 
1361     /**
1362      * @dev Emitted when the pause is lifted by `account`.
1363      */
1364     event Unpaused(address account);
1365 
1366     bool private _paused;
1367 
1368     /**
1369      * @dev Initializes the contract in unpaused state.
1370      */
1371     constructor() {
1372         _paused = false;
1373     }
1374 
1375     /**
1376      * @dev Modifier to make a function callable only when the contract is not paused.
1377      *
1378      * Requirements:
1379      *
1380      * - The contract must not be paused.
1381      */
1382     modifier whenNotPaused() {
1383         _requireNotPaused();
1384         _;
1385     }
1386 
1387     /**
1388      * @dev Modifier to make a function callable only when the contract is paused.
1389      *
1390      * Requirements:
1391      *
1392      * - The contract must be paused.
1393      */
1394     modifier whenPaused() {
1395         _requirePaused();
1396         _;
1397     }
1398 
1399     /**
1400      * @dev Returns true if the contract is paused, and false otherwise.
1401      */
1402     function paused() public view virtual returns (bool) {
1403         return _paused;
1404     }
1405 
1406     /**
1407      * @dev Throws if the contract is paused.
1408      */
1409     function _requireNotPaused() internal view virtual {
1410         require(!paused(), "Pausable: paused");
1411     }
1412 
1413     /**
1414      * @dev Throws if the contract is not paused.
1415      */
1416     function _requirePaused() internal view virtual {
1417         require(paused(), "Pausable: not paused");
1418     }
1419 
1420     /**
1421      * @dev Triggers stopped state.
1422      *
1423      * Requirements:
1424      *
1425      * - The contract must not be paused.
1426      */
1427     function _pause() internal virtual whenNotPaused {
1428         _paused = true;
1429         emit Paused(_msgSender());
1430     }
1431 
1432     /**
1433      * @dev Returns to normal state.
1434      *
1435      * Requirements:
1436      *
1437      * - The contract must be paused.
1438      */
1439     function _unpause() internal virtual whenPaused {
1440         _paused = false;
1441         emit Unpaused(_msgSender());
1442     }
1443 }
1444 
1445 // File: @openzeppelin/contracts/access/Ownable.sol
1446 
1447 
1448 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1449 
1450 pragma solidity ^0.8.0;
1451 
1452 
1453 /**
1454  * @dev Contract module which provides a basic access control mechanism, where
1455  * there is an account (an owner) that can be granted exclusive access to
1456  * specific functions.
1457  *
1458  * By default, the owner account will be the one that deploys the contract. This
1459  * can later be changed with {transferOwnership}.
1460  *
1461  * This module is used through inheritance. It will make available the modifier
1462  * `onlyOwner`, which can be applied to your functions to restrict their use to
1463  * the owner.
1464  */
1465 abstract contract Ownable is Context {
1466     address private _owner;
1467 
1468     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1469 
1470     /**
1471      * @dev Initializes the contract setting the deployer as the initial owner.
1472      */
1473     constructor() {
1474         _transferOwnership(_msgSender());
1475     }
1476 
1477     /**
1478      * @dev Throws if called by any account other than the owner.
1479      */
1480     modifier onlyOwner() {
1481         _checkOwner();
1482         _;
1483     }
1484 
1485     /**
1486      * @dev Returns the address of the current owner.
1487      */
1488     function owner() public view virtual returns (address) {
1489         return _owner;
1490     }
1491 
1492     /**
1493      * @dev Throws if the sender is not the owner.
1494      */
1495     function _checkOwner() internal view virtual {
1496         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1497     }
1498 
1499     /**
1500      * @dev Leaves the contract without owner. It will not be possible to call
1501      * `onlyOwner` functions anymore. Can only be called by the current owner.
1502      *
1503      * NOTE: Renouncing ownership will leave the contract without an owner,
1504      * thereby removing any functionality that is only available to the owner.
1505      */
1506     function renounceOwnership() public virtual onlyOwner {
1507         _transferOwnership(address(0));
1508     }
1509 
1510     /**
1511      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1512      * Can only be called by the current owner.
1513      */
1514     function transferOwnership(address newOwner) public virtual onlyOwner {
1515         require(newOwner != address(0), "Ownable: new owner is the zero address");
1516         _transferOwnership(newOwner);
1517     }
1518 
1519     /**
1520      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1521      * Internal function without access restriction.
1522      */
1523     function _transferOwnership(address newOwner) internal virtual {
1524         address oldOwner = _owner;
1525         _owner = newOwner;
1526         emit OwnershipTransferred(oldOwner, newOwner);
1527     }
1528 }
1529 
1530 // File: contracts/QOL.sol
1531 
1532 
1533 pragma solidity 0.8.7;
1534 
1535 
1536 
1537 
1538 
1539 contract QueenOfLust is Ownable, ERC721A, Pausable {
1540     using Strings for uint256;
1541 
1542     struct SaleInfo {
1543         uint8 step;
1544         uint16 amount;
1545         uint256 price;
1546         uint256 mintStartTime;
1547     }
1548 
1549     uint8 private constant MINT_LIST_STEP = 0;
1550     uint8 private constant WHITE_LIST_STEP = 1;
1551     uint8 private constant PUBLIC_STEP = 2;
1552     uint8 private constant STEP_COUNT = 3;
1553 
1554     string private metadataUri;
1555     string private metadataSuffix = ".json";
1556     uint256 public constant maxSupply = 5000;
1557 
1558     mapping(address => uint8) public mintListAddress;
1559     mapping(address => uint8) public whiteListAddress;
1560 
1561     SaleInfo[] public saleInfoList;
1562     uint256[] private accumulatedSaleAmount;
1563 
1564     bool private isRevealed = false;
1565 
1566     constructor(
1567         uint16[] memory _amounts,
1568         uint256[] memory _prices,
1569         uint256[] memory _mintStartTimes,
1570         string memory _metadataUri
1571     ) ERC721A("MIB19Queen", "MIBQ") {
1572         require(
1573             _amounts.length + _prices.length + _mintStartTimes.length == (STEP_COUNT) * 3,
1574             "Invalid Argument : param length"
1575         );
1576         require(_amounts[0] + _amounts[1] + _amounts[2] <= maxSupply, "Invalid Argument : maxSupply");
1577 
1578         for (uint8 i = 0; i < STEP_COUNT; i++) {
1579             saleInfoList.push(SaleInfo(i, _amounts[i], _prices[i], _mintStartTimes[i]));
1580 
1581             if (i > 0) {
1582                 accumulatedSaleAmount.push(accumulatedSaleAmount[i - 1] + _amounts[i]);
1583             } else {
1584                 accumulatedSaleAmount.push(_amounts[i]);
1585             }
1586         }
1587 
1588         metadataUri = _metadataUri;
1589     }
1590 
1591     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1592         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1593         if (!isRevealed) {
1594             return string(abi.encodePacked(metadataUri, "prereveal", metadataSuffix));
1595         }
1596         return string(abi.encodePacked(metadataUri, Strings.toString(_tokenId), metadataSuffix));
1597     }
1598 
1599     function contractURI() public view returns (string memory) {
1600         return string(abi.encodePacked(metadataUri, "contract", metadataSuffix));
1601     }
1602 
1603     function mint(uint8 amount, uint8 step) external payable whenNotPaused {
1604         require(_checkMintStepValid(step), "Not exist mint step");
1605 
1606         uint8 _currStep = getCurrentStep();
1607         if (_currStep != step) {
1608             revert("Steps that have not started or are finished");
1609         }
1610 
1611         uint256 _price = saleInfoList[step].price * amount;
1612         require(msg.value == _price, "Invalid ETH balance");
1613 
1614         require(_totalMinted() + amount <= accumulatedSaleAmount[step], "Sold out in this step");
1615         if (step == MINT_LIST_STEP) {
1616             _mintForEachStep(amount, mintListAddress);
1617         } else if (step == WHITE_LIST_STEP) {
1618             _mintForEachStep(amount, whiteListAddress);
1619         } else if (step == PUBLIC_STEP) {
1620             _safeMint(msg.sender, amount);
1621         }
1622         
1623     }
1624 
1625     function getCurrentStep() public view returns (uint8) {
1626         uint8 _step;
1627         for (_step = STEP_COUNT - 1; _step >= 0; _step--) {
1628             if (block.timestamp >= saleInfoList[_step].mintStartTime) {
1629                 return _step;
1630             }
1631         }
1632         revert("Minting hasn't started yet");
1633     }
1634 
1635     function isSoldout(uint8 step) public view returns (bool) {
1636         require(_checkMintStepValid(step), "Not exist mint step");
1637         return _totalMinted() == accumulatedSaleAmount[step];
1638     }
1639 
1640     function getMintableAmount(uint8 step) public view returns (uint256) {
1641         require(_checkMintStepValid(step), "Not exist mint step");
1642         return accumulatedSaleAmount[step] - _totalMinted();
1643     }
1644 
1645     function _mintForEachStep(uint8 amount, mapping(address => uint8) storage allowList) private {
1646         require(allowList[msg.sender] - amount >= 0, "Don't have mint authority");
1647         allowList[msg.sender] -= amount;
1648         _safeMint(msg.sender, amount);
1649     }
1650 
1651     function _checkMintStepValid(uint8 step) internal pure returns (bool) {
1652         return step < STEP_COUNT;
1653     }
1654 
1655     function burn(uint256 tokenId) external onlyOwner {
1656         _burn(tokenId);
1657     }
1658 
1659     function withdraw() external onlyOwner {
1660         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1661         if (!success) {
1662             revert("Ether transfer failed");
1663         }
1664     }
1665 
1666     function pause() external onlyOwner {
1667         _pause();
1668     }
1669 
1670     function unpause() external onlyOwner {
1671         _unpause();
1672     }
1673 
1674     function _setMintAuthority(
1675         address _address,
1676         uint8 step,
1677         uint8 _amount
1678     ) private {
1679         require(_address != address(0), "address can't be 0");
1680         require(_checkMintStepValid(step), "Not exist mint step");
1681 
1682         if (step == MINT_LIST_STEP) {
1683             mintListAddress[_address] = _amount;
1684         } else if (step == WHITE_LIST_STEP) {
1685             whiteListAddress[_address] = _amount;
1686         } else {
1687             revert("Not exist mint step");
1688         }
1689     }
1690 
1691     function setBulkMintAuthority(
1692         address[] calldata _addressList,
1693         uint8 step,
1694         uint8[] calldata _amountList
1695     ) external onlyOwner {
1696         require(_addressList.length == _amountList.length, "Invalid argument : different argument size");
1697 
1698         for (uint256 i = 0; i < _addressList.length; i++) {
1699             _setMintAuthority(_addressList[i], step, _amountList[i]);
1700         }
1701     }
1702 
1703     function setSaleAmount(uint16[] memory _amounts) external onlyOwner {
1704         require(_amounts.length == STEP_COUNT, "Invalid argument");
1705         for (uint8 i = 0; i < STEP_COUNT; i++) {
1706             saleInfoList[i].amount = _amounts[i];
1707             if (i > 0) {
1708                 accumulatedSaleAmount[i] = accumulatedSaleAmount[i - 1] + _amounts[i];
1709             } else {
1710                 accumulatedSaleAmount[i] = _amounts[i];
1711             }
1712         }
1713 
1714         require(maxSupply >= accumulatedSaleAmount[STEP_COUNT - 1], "Invalid argument : exceed maxSupply");
1715     }
1716 
1717     function setSalePrice(uint256[] memory _prices) external onlyOwner {
1718         require(_prices.length == STEP_COUNT, "Invalid argument");
1719         for (uint8 i = 0; i < STEP_COUNT; i++) {
1720             if (i > 0) {
1721                 require(saleInfoList[i - 1].price <= _prices[i], "Invalid argument");
1722             }
1723             saleInfoList[i].price = _prices[i];
1724         }
1725     }
1726 
1727     function setMintStartTime(uint256[] memory _mintStartTimes) external onlyOwner {
1728         require(_mintStartTimes.length == STEP_COUNT, "Invalid argument");
1729         for (uint8 i = 0; i < STEP_COUNT; i++) {
1730             if (i > 0) {
1731                 require(saleInfoList[i - 1].mintStartTime <= _mintStartTimes[i], "Invalid argument");
1732             }
1733             saleInfoList[i].mintStartTime = _mintStartTimes[i];
1734         }
1735     }
1736 
1737     function setMetadataUri(string calldata _metadataUri, string calldata _metadataSuffix) external onlyOwner {
1738         metadataUri = _metadataUri;
1739         metadataSuffix = _metadataSuffix;
1740     }
1741 
1742     function setIsReveal(bool _isReveal) external onlyOwner {
1743         isRevealed = _isReveal;
1744     }
1745 }