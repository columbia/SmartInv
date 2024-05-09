1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.13;
4 
5 library Strings {
6     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
7 
8     /**
9      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
10      */
11     function toString(uint256 value) internal pure returns (string memory) {
12         // Inspired by OraclizeAPI's implementation - MIT licence
13         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
14 
15         if (value == 0) {
16             return "0";
17         }
18         uint256 temp = value;
19         uint256 digits;
20         while (temp != 0) {
21             digits++;
22             temp /= 10;
23         }
24         bytes memory buffer = new bytes(digits);
25         while (value != 0) {
26             digits -= 1;
27             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
28             value /= 10;
29         }
30         return string(buffer);
31     }
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
35      */
36     function toHexString(uint256 value) internal pure returns (string memory) {
37         if (value == 0) {
38             return "0x00";
39         }
40         uint256 temp = value;
41         uint256 length = 0;
42         while (temp != 0) {
43             length++;
44             temp >>= 8;
45         }
46         return toHexString(value, length);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
51      */
52     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
53         bytes memory buffer = new bytes(2 * length + 2);
54         buffer[0] = "0";
55         buffer[1] = "x";
56         for (uint256 i = 2 * length + 1; i > 1; --i) {
57             buffer[i] = _HEX_SYMBOLS[value & 0xf];
58             value >>= 4;
59         }
60         require(value == 0, "Strings: hex length insufficient");
61         return string(buffer);
62     }
63 }
64 
65 /**
66  * @dev Interface of ERC721A.
67  */
68 interface IERC721A {
69     /**
70      * The caller must own the token or be an approved operator.
71      */
72     error ApprovalCallerNotOwnerNorApproved();
73 
74     /**
75      * The token does not exist.
76      */
77     error ApprovalQueryForNonexistentToken();
78 
79     /**
80      * Cannot query the balance for the zero address.
81      */
82     error BalanceQueryForZeroAddress();
83 
84     /**
85      * Cannot mint to the zero address.
86      */
87     error MintToZeroAddress();
88 
89     /**
90      * The quantity of tokens minted must be more than zero.
91      */
92     error MintZeroQuantity();
93 
94     /**
95      * The token does not exist.
96      */
97     error OwnerQueryForNonexistentToken();
98 
99     /**
100      * The caller must own the token or be an approved operator.
101      */
102     error TransferCallerNotOwnerNorApproved();
103 
104     /**
105      * The token must be owned by `from`.
106      */
107     error TransferFromIncorrectOwner();
108 
109     /**
110      * Cannot safely transfer to a contract that does not implement the
111      * ERC721Receiver interface.
112      */
113     error TransferToNonERC721ReceiverImplementer();
114 
115     /**
116      * Cannot transfer to the zero address.
117      */
118     error TransferToZeroAddress();
119 
120     /**
121      * The token does not exist.
122      */
123     error URIQueryForNonexistentToken();
124 
125     /**
126      * The `quantity` minted with ERC2309 exceeds the safety limit.
127      */
128     error MintERC2309QuantityExceedsLimit();
129 
130     /**
131      * The `extraData` cannot be set on an unintialized ownership slot.
132      */
133     error OwnershipNotInitializedForExtraData();
134 
135     // =============================================================
136     //                            STRUCTS
137     // =============================================================
138 
139     struct TokenOwnership {
140         // The address of the owner.
141         address addr;
142         // Stores the start time of ownership with minimal overhead for tokenomics.
143         uint64 startTimestamp;
144         // Whether the token has been burned.
145         bool burned;
146         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
147         uint24 extraData;
148     }
149 
150     // =============================================================
151     //                         TOKEN COUNTERS
152     // =============================================================
153 
154     /**
155      * @dev Returns the total number of tokens in existence.
156      * Burned tokens will reduce the count.
157      * To get the total number of tokens minted, please see {_totalMinted}.
158      */
159     function totalSupply() external view returns (uint256);
160 
161     // =============================================================
162     //                            IERC165
163     // =============================================================
164 
165     /**
166      * @dev Returns true if this contract implements the interface defined by
167      * `interfaceId`. See the corresponding
168      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
169      * to learn more about how these ids are created.
170      *
171      * This function call must use less than 30000 gas.
172      */
173     function supportsInterface(bytes4 interfaceId) external view returns (bool);
174 
175     // =============================================================
176     //                            IERC721
177     // =============================================================
178 
179     /**
180      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
183 
184     /**
185      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
186      */
187     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
188 
189     /**
190      * @dev Emitted when `owner` enables or disables
191      * (`approved`) `operator` to manage all of its assets.
192      */
193     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
194 
195     /**
196      * @dev Returns the number of tokens in `owner`'s account.
197      */
198     function balanceOf(address owner) external view returns (uint256 balance);
199 
200     /**
201      * @dev Returns the owner of the `tokenId` token.
202      *
203      * Requirements:
204      *
205      * - `tokenId` must exist.
206      */
207     function ownerOf(uint256 tokenId) external view returns (address owner);
208 
209     /**
210      * @dev Safely transfers `tokenId` token from `from` to `to`,
211      * checking first that contract recipients are aware of the ERC721 protocol
212      * to prevent tokens from being forever locked.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must exist and be owned by `from`.
219      * - If the caller is not `from`, it must be have been allowed to move
220      * this token by either {approve} or {setApprovalForAll}.
221      * - If `to` refers to a smart contract, it must implement
222      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
223      *
224      * Emits a {Transfer} event.
225      */
226     function safeTransferFrom(
227         address from,
228         address to,
229         uint256 tokenId,
230         bytes calldata data
231     ) external payable;
232 
233     /**
234      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
235      */
236     function safeTransferFrom(
237         address from,
238         address to,
239         uint256 tokenId
240     ) external payable;
241 
242     /**
243      * @dev Transfers `tokenId` from `from` to `to`.
244      *
245      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
246      * whenever possible.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token
254      * by either {approve} or {setApprovalForAll}.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transferFrom(
259         address from,
260         address to,
261         uint256 tokenId
262     ) external payable;
263 
264     /**
265      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
266      * The approval is cleared when the token is transferred.
267      *
268      * Only a single account can be approved at a time, so approving the
269      * zero address clears previous approvals.
270      *
271      * Requirements:
272      *
273      * - The caller must own the token or be an approved operator.
274      * - `tokenId` must exist.
275      *
276      * Emits an {Approval} event.
277      */
278     function approve(address to, uint256 tokenId) external payable;
279 
280     /**
281      * @dev Approve or remove `operator` as an operator for the caller.
282      * Operators can call {transferFrom} or {safeTransferFrom}
283      * for any token owned by the caller.
284      *
285      * Requirements:
286      *
287      * - The `operator` cannot be the caller.
288      *
289      * Emits an {ApprovalForAll} event.
290      */
291     function setApprovalForAll(address operator, bool _approved) external;
292 
293     /**
294      * @dev Returns the account approved for `tokenId` token.
295      *
296      * Requirements:
297      *
298      * - `tokenId` must exist.
299      */
300     function getApproved(uint256 tokenId) external view returns (address operator);
301 
302     /**
303      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
304      *
305      * See {setApprovalForAll}.
306      */
307     function isApprovedForAll(address owner, address operator) external view returns (bool);
308 
309     // =============================================================
310     //                        IERC721Metadata
311     // =============================================================
312 
313     /**
314      * @dev Returns the token collection name.
315      */
316     function name() external view returns (string memory);
317 
318     /**
319      * @dev Returns the token collection symbol.
320      */
321     function symbol() external view returns (string memory);
322 
323     /**
324      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
325      */
326     function tokenURI(uint256 tokenId) external view returns (string memory);
327 
328     // =============================================================
329     //                           IERC2309
330     // =============================================================
331 
332     /**
333      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
334      * (inclusive) is transferred from `from` to `to`, as defined in the
335      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
336      *
337      * See {_mintERC2309} for more details.
338      */
339     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
340 }
341 
342 pragma solidity ^0.8.4;
343 
344 /**
345  * @dev Interface of ERC721 token receiver.
346  */
347 interface ERC721A__IERC721Receiver {
348     function onERC721Received(
349         address operator,
350         address from,
351         uint256 tokenId,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 
356 /**
357  * @title ERC721A
358  *
359  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
360  * Non-Fungible Token Standard, including the Metadata extension.
361  * Optimized for lower gas during batch mints.
362  *
363  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
364  * starting from `_startTokenId()`.
365  *
366  * Assumptions:
367  *
368  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
369  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
370  */
371 contract ERC721A is IERC721A {
372     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
373     struct TokenApprovalRef {
374         address value;
375     }
376 
377     // =============================================================
378     //                           CONSTANTS
379     // =============================================================
380 
381     // Mask of an entry in packed address data.
382     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
383 
384     // The bit position of `numberMinted` in packed address data.
385     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
386 
387     // The bit position of `numberBurned` in packed address data.
388     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
389 
390     // The bit position of `aux` in packed address data.
391     uint256 private constant _BITPOS_AUX = 192;
392 
393     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
394     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
395 
396     // The bit position of `startTimestamp` in packed ownership.
397     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
398 
399     // The bit mask of the `burned` bit in packed ownership.
400     uint256 private constant _BITMASK_BURNED = 1 << 224;
401 
402     // The bit position of the `nextInitialized` bit in packed ownership.
403     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
404 
405     // The bit mask of the `nextInitialized` bit in packed ownership.
406     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
407 
408     // The bit position of `extraData` in packed ownership.
409     uint256 private constant _BITPOS_EXTRA_DATA = 232;
410 
411     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
412     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
413 
414     // The mask of the lower 160 bits for addresses.
415     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
416 
417     // The maximum `quantity` that can be minted with {_mintERC2309}.
418     // This limit is to prevent overflows on the address data entries.
419     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
420     // is required to cause an overflow, which is unrealistic.
421     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
422 
423     // The `Transfer` event signature is given by:
424     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
425     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
426         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
427 
428     // =============================================================
429     //                            STORAGE
430     // =============================================================
431 
432     // The next token ID to be minted.
433     uint256 private _currentIndex;
434 
435     // The number of tokens burned.
436     uint256 private _burnCounter;
437 
438     // Token name
439     string private _name;
440 
441     // Token symbol
442     string private _symbol;
443 
444     // Mapping from token ID to ownership details
445     // An empty struct value does not necessarily mean the token is unowned.
446     // See {_packedOwnershipOf} implementation for details.
447     //
448     // Bits Layout:
449     // - [0..159]   `addr`
450     // - [160..223] `startTimestamp`
451     // - [224]      `burned`
452     // - [225]      `nextInitialized`
453     // - [232..255] `extraData`
454     mapping(uint256 => uint256) private _packedOwnerships;
455 
456     // Mapping owner address to address data.
457     //
458     // Bits Layout:
459     // - [0..63]    `balance`
460     // - [64..127]  `numberMinted`
461     // - [128..191] `numberBurned`
462     // - [192..255] `aux`
463     mapping(address => uint256) private _packedAddressData;
464 
465     // Mapping from token ID to approved address.
466     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
467 
468     // Mapping from owner to operator approvals
469     mapping(address => mapping(address => bool)) private _operatorApprovals;
470 
471     // =============================================================
472     //                          CONSTRUCTOR
473     // =============================================================
474 
475     constructor(string memory name_, string memory symbol_) {
476         _name = name_;
477         _symbol = symbol_;
478         _currentIndex = _startTokenId();
479     }
480 
481     // =============================================================
482     //                   TOKEN COUNTING OPERATIONS
483     // =============================================================
484 
485     /**
486      * @dev Returns the starting token ID.
487      * To change the starting token ID, please override this function.
488      */
489     function _startTokenId() internal view virtual returns (uint256) {
490         return 0;
491     }
492 
493     /**
494      * @dev Returns the next token ID to be minted.
495      */
496     function _nextTokenId() internal view virtual returns (uint256) {
497         return _currentIndex;
498     }
499 
500     /**
501      * @dev Returns the total number of tokens in existence.
502      * Burned tokens will reduce the count.
503      * To get the total number of tokens minted, please see {_totalMinted}.
504      */
505     function totalSupply() public view virtual override returns (uint256) {
506         // Counter underflow is impossible as _burnCounter cannot be incremented
507         // more than `_currentIndex - _startTokenId()` times.
508         unchecked {
509             return _currentIndex - _burnCounter - _startTokenId();
510         }
511     }
512 
513     /**
514      * @dev Returns the total amount of tokens minted in the contract.
515      */
516     function _totalMinted() internal view virtual returns (uint256) {
517         // Counter underflow is impossible as `_currentIndex` does not decrement,
518         // and it is initialized to `_startTokenId()`.
519         unchecked {
520             return _currentIndex - _startTokenId();
521         }
522     }
523 
524     /**
525      * @dev Returns the total number of tokens burned.
526      */
527     function _totalBurned() internal view virtual returns (uint256) {
528         return _burnCounter;
529     }
530 
531     // =============================================================
532     //                    ADDRESS DATA OPERATIONS
533     // =============================================================
534 
535     /**
536      * @dev Returns the number of tokens in `owner`'s account.
537      */
538     function balanceOf(address owner) public view virtual override returns (uint256) {
539         if (owner == address(0)) revert BalanceQueryForZeroAddress();
540         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
541     }
542 
543     /**
544      * Returns the number of tokens minted by `owner`.
545      */
546     function _numberMinted(address owner) internal view returns (uint256) {
547         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
548     }
549 
550     /**
551      * Returns the number of tokens burned by or on behalf of `owner`.
552      */
553     function _numberBurned(address owner) internal view returns (uint256) {
554         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
555     }
556 
557     /**
558      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
559      */
560     function _getAux(address owner) internal view returns (uint64) {
561         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
562     }
563 
564     /**
565      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
566      * If there are multiple variables, please pack them into a uint64.
567      */
568     function _setAux(address owner, uint64 aux) internal virtual {
569         uint256 packed = _packedAddressData[owner];
570         uint256 auxCasted;
571         // Cast `aux` with assembly to avoid redundant masking.
572         assembly {
573             auxCasted := aux
574         }
575         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
576         _packedAddressData[owner] = packed;
577     }
578 
579     // =============================================================
580     //                            IERC165
581     // =============================================================
582 
583     /**
584      * @dev Returns true if this contract implements the interface defined by
585      * `interfaceId`. See the corresponding
586      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
587      * to learn more about how these ids are created.
588      *
589      * This function call must use less than 30000 gas.
590      */
591     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
592         // The interface IDs are constants representing the first 4 bytes
593         // of the XOR of all function selectors in the interface.
594         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
595         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
596         return
597             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
598             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
599             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
600     }
601 
602     // =============================================================
603     //                        IERC721Metadata
604     // =============================================================
605 
606     /**
607      * @dev Returns the token collection name.
608      */
609     function name() public view virtual override returns (string memory) {
610         return _name;
611     }
612 
613     /**
614      * @dev Returns the token collection symbol.
615      */
616     function symbol() public view virtual override returns (string memory) {
617         return _symbol;
618     }
619 
620     /**
621      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
622      */
623     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
624         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
625 
626         string memory baseURI = _baseURI();
627         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
628     }
629 
630     /**
631      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
632      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
633      * by default, it can be overridden in child contracts.
634      */
635     function _baseURI() internal view virtual returns (string memory) {
636         return '';
637     }
638 
639     // =============================================================
640     //                     OWNERSHIPS OPERATIONS
641     // =============================================================
642 
643     /**
644      * @dev Returns the owner of the `tokenId` token.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
651         return address(uint160(_packedOwnershipOf(tokenId)));
652     }
653 
654     /**
655      * @dev Gas spent here starts off proportional to the maximum mint batch size.
656      * It gradually moves to O(1) as tokens get transferred around over time.
657      */
658     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
659         return _unpackedOwnership(_packedOwnershipOf(tokenId));
660     }
661 
662     /**
663      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
664      */
665     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
666         return _unpackedOwnership(_packedOwnerships[index]);
667     }
668 
669     /**
670      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
671      */
672     function _initializeOwnershipAt(uint256 index) internal virtual {
673         if (_packedOwnerships[index] == 0) {
674             _packedOwnerships[index] = _packedOwnershipOf(index);
675         }
676     }
677 
678     /**
679      * Returns the packed ownership data of `tokenId`.
680      */
681     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
682         uint256 curr = tokenId;
683 
684         unchecked {
685             if (_startTokenId() <= curr)
686                 if (curr < _currentIndex) {
687                     uint256 packed = _packedOwnerships[curr];
688                     // If not burned.
689                     if (packed & _BITMASK_BURNED == 0) {
690                         // Invariant:
691                         // There will always be an initialized ownership slot
692                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
693                         // before an unintialized ownership slot
694                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
695                         // Hence, `curr` will not underflow.
696                         //
697                         // We can directly compare the packed value.
698                         // If the address is zero, packed will be zero.
699                         while (packed == 0) {
700                             packed = _packedOwnerships[--curr];
701                         }
702                         return packed;
703                     }
704                 }
705         }
706         revert OwnerQueryForNonexistentToken();
707     }
708 
709     /**
710      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
711      */
712     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
713         ownership.addr = address(uint160(packed));
714         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
715         ownership.burned = packed & _BITMASK_BURNED != 0;
716         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
717     }
718 
719     /**
720      * @dev Packs ownership data into a single uint256.
721      */
722     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
723         assembly {
724             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
725             owner := and(owner, _BITMASK_ADDRESS)
726             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
727             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
728         }
729     }
730 
731     /**
732      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
733      */
734     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
735         // For branchless setting of the `nextInitialized` flag.
736         assembly {
737             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
738             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
739         }
740     }
741 
742     // =============================================================
743     //                      APPROVAL OPERATIONS
744     // =============================================================
745 
746     /**
747      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
748      *
749      * Requirements:
750      *
751      * - The caller must own the token or be an approved operator.
752      */
753     function approve(address to, uint256 tokenId) public payable virtual override {
754         _approve(to, tokenId, true);
755     }
756 
757     /**
758      * @dev Returns the account approved for `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function getApproved(uint256 tokenId) public view virtual override returns (address) {
765         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
766 
767         return _tokenApprovals[tokenId].value;
768     }
769 
770     /**
771      * @dev Approve or remove `operator` as an operator for the caller.
772      * Operators can call {transferFrom} or {safeTransferFrom}
773      * for any token owned by the caller.
774      *
775      * Requirements:
776      *
777      * - The `operator` cannot be the caller.
778      *
779      * Emits an {ApprovalForAll} event.
780      */
781     function setApprovalForAll(address operator, bool approved) public virtual override {
782         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
783         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
784     }
785 
786     /**
787      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
788      *
789      * See {setApprovalForAll}.
790      */
791     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
792         return _operatorApprovals[owner][operator];
793     }
794 
795     /**
796      * @dev Returns whether `tokenId` exists.
797      *
798      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
799      *
800      * Tokens start existing when they are minted. See {_mint}.
801      */
802     function _exists(uint256 tokenId) internal view virtual returns (bool) {
803         return
804             _startTokenId() <= tokenId &&
805             tokenId < _currentIndex && // If within bounds,
806             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
807     }
808 
809     /**
810      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
811      */
812     function _isSenderApprovedOrOwner(
813         address approvedAddress,
814         address owner,
815         address msgSender
816     ) private pure returns (bool result) {
817         assembly {
818             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
819             owner := and(owner, _BITMASK_ADDRESS)
820             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
821             msgSender := and(msgSender, _BITMASK_ADDRESS)
822             // `msgSender == owner || msgSender == approvedAddress`.
823             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
824         }
825     }
826 
827     /**
828      * @dev Returns the storage slot and value for the approved address of `tokenId`.
829      */
830     function _getApprovedSlotAndAddress(uint256 tokenId)
831         private
832         view
833         returns (uint256 approvedAddressSlot, address approvedAddress)
834     {
835         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
836         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
837         assembly {
838             approvedAddressSlot := tokenApproval.slot
839             approvedAddress := sload(approvedAddressSlot)
840         }
841     }
842 
843     // =============================================================
844     //                      TRANSFER OPERATIONS
845     // =============================================================
846 
847     /**
848      * @dev Transfers `tokenId` from `from` to `to`.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must be owned by `from`.
855      * - If the caller is not `from`, it must be approved to move this token
856      * by either {approve} or {setApprovalForAll}.
857      *
858      * Emits a {Transfer} event.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public payable virtual override {
865         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
866 
867         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
868 
869         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
870 
871         // The nested ifs save around 20+ gas over a compound boolean condition.
872         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
873             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
874 
875         if (to == address(0)) revert TransferToZeroAddress();
876 
877         _beforeTokenTransfers(from, to, tokenId, 1);
878 
879         // Clear approvals from the previous owner.
880         assembly {
881             if approvedAddress {
882                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
883                 sstore(approvedAddressSlot, 0)
884             }
885         }
886 
887         // Underflow of the sender's balance is impossible because we check for
888         // ownership above and the recipient's balance can't realistically overflow.
889         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
890         unchecked {
891             // We can directly increment and decrement the balances.
892             --_packedAddressData[from]; // Updates: `balance -= 1`.
893             ++_packedAddressData[to]; // Updates: `balance += 1`.
894 
895             // Updates:
896             // - `address` to the next owner.
897             // - `startTimestamp` to the timestamp of transfering.
898             // - `burned` to `false`.
899             // - `nextInitialized` to `true`.
900             _packedOwnerships[tokenId] = _packOwnershipData(
901                 to,
902                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
903             );
904 
905             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
906             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
907                 uint256 nextTokenId = tokenId + 1;
908                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
909                 if (_packedOwnerships[nextTokenId] == 0) {
910                     // If the next slot is within bounds.
911                     if (nextTokenId != _currentIndex) {
912                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
913                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
914                     }
915                 }
916             }
917         }
918 
919         emit Transfer(from, to, tokenId);
920         _afterTokenTransfers(from, to, tokenId, 1);
921     }
922 
923     /**
924      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public payable virtual override {
931         safeTransferFrom(from, to, tokenId, '');
932     }
933 
934     /**
935      * @dev Safely transfers `tokenId` token from `from` to `to`.
936      *
937      * Requirements:
938      *
939      * - `from` cannot be the zero address.
940      * - `to` cannot be the zero address.
941      * - `tokenId` token must exist and be owned by `from`.
942      * - If the caller is not `from`, it must be approved to move this token
943      * by either {approve} or {setApprovalForAll}.
944      * - If `to` refers to a smart contract, it must implement
945      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) public payable virtual override {
955         transferFrom(from, to, tokenId);
956         if (to.code.length != 0)
957             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
958                 revert TransferToNonERC721ReceiverImplementer();
959             }
960     }
961 
962     /**
963      * @dev Hook that is called before a set of serially-ordered token IDs
964      * are about to be transferred. This includes minting.
965      * And also called before burning one token.
966      *
967      * `startTokenId` - the first token ID to be transferred.
968      * `quantity` - the amount to be transferred.
969      *
970      * Calling conditions:
971      *
972      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
973      * transferred to `to`.
974      * - When `from` is zero, `tokenId` will be minted for `to`.
975      * - When `to` is zero, `tokenId` will be burned by `from`.
976      * - `from` and `to` are never both zero.
977      */
978     function _beforeTokenTransfers(
979         address from,
980         address to,
981         uint256 startTokenId,
982         uint256 quantity
983     ) internal virtual {}
984 
985     /**
986      * @dev Hook that is called after a set of serially-ordered token IDs
987      * have been transferred. This includes minting.
988      * And also called after one token has been burned.
989      *
990      * `startTokenId` - the first token ID to be transferred.
991      * `quantity` - the amount to be transferred.
992      *
993      * Calling conditions:
994      *
995      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
996      * transferred to `to`.
997      * - When `from` is zero, `tokenId` has been minted for `to`.
998      * - When `to` is zero, `tokenId` has been burned by `from`.
999      * - `from` and `to` are never both zero.
1000      */
1001     function _afterTokenTransfers(
1002         address from,
1003         address to,
1004         uint256 startTokenId,
1005         uint256 quantity
1006     ) internal virtual {}
1007 
1008     /**
1009      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1010      *
1011      * `from` - Previous owner of the given token ID.
1012      * `to` - Target address that will receive the token.
1013      * `tokenId` - Token ID to be transferred.
1014      * `_data` - Optional data to send along with the call.
1015      *
1016      * Returns whether the call correctly returned the expected magic value.
1017      */
1018     function _checkContractOnERC721Received(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) private returns (bool) {
1024         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1025             bytes4 retval
1026         ) {
1027             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1028         } catch (bytes memory reason) {
1029             if (reason.length == 0) {
1030                 revert TransferToNonERC721ReceiverImplementer();
1031             } else {
1032                 assembly {
1033                     revert(add(32, reason), mload(reason))
1034                 }
1035             }
1036         }
1037     }
1038 
1039     // =============================================================
1040     //                        MINT OPERATIONS
1041     // =============================================================
1042 
1043     /**
1044      * @dev Mints `quantity` tokens and transfers them to `to`.
1045      *
1046      * Requirements:
1047      *
1048      * - `to` cannot be the zero address.
1049      * - `quantity` must be greater than 0.
1050      *
1051      * Emits a {Transfer} event for each mint.
1052      */
1053     function _mint(address to, uint256 quantity) internal virtual {
1054         uint256 startTokenId = _currentIndex;
1055         if (quantity == 0) revert MintZeroQuantity();
1056 
1057         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1058 
1059         // Overflows are incredibly unrealistic.
1060         // `balance` and `numberMinted` have a maximum limit of 2**64.
1061         // `tokenId` has a maximum limit of 2**256.
1062         unchecked {
1063             // Updates:
1064             // - `balance += quantity`.
1065             // - `numberMinted += quantity`.
1066             //
1067             // We can directly add to the `balance` and `numberMinted`.
1068             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1069 
1070             // Updates:
1071             // - `address` to the owner.
1072             // - `startTimestamp` to the timestamp of minting.
1073             // - `burned` to `false`.
1074             // - `nextInitialized` to `quantity == 1`.
1075             _packedOwnerships[startTokenId] = _packOwnershipData(
1076                 to,
1077                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1078             );
1079 
1080             uint256 toMasked;
1081             uint256 end = startTokenId + quantity;
1082 
1083             // Use assembly to loop and emit the `Transfer` event for gas savings.
1084             // The duplicated `log4` removes an extra check and reduces stack juggling.
1085             // The assembly, together with the surrounding Solidity code, have been
1086             // delicately arranged to nudge the compiler into producing optimized opcodes.
1087             assembly {
1088                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1089                 toMasked := and(to, _BITMASK_ADDRESS)
1090                 // Emit the `Transfer` event.
1091                 log4(
1092                     0, // Start of data (0, since no data).
1093                     0, // End of data (0, since no data).
1094                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1095                     0, // `address(0)`.
1096                     toMasked, // `to`.
1097                     startTokenId // `tokenId`.
1098                 )
1099 
1100                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1101                 // that overflows uint256 will make the loop run out of gas.
1102                 // The compiler will optimize the `iszero` away for performance.
1103                 for {
1104                     let tokenId := add(startTokenId, 1)
1105                 } iszero(eq(tokenId, end)) {
1106                     tokenId := add(tokenId, 1)
1107                 } {
1108                     // Emit the `Transfer` event. Similar to above.
1109                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1110                 }
1111             }
1112             if (toMasked == 0) revert MintToZeroAddress();
1113 
1114             _currentIndex = end;
1115         }
1116         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1117     }
1118 
1119     /**
1120      * @dev Mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * This function is intended for efficient minting only during contract creation.
1123      *
1124      * It emits only one {ConsecutiveTransfer} as defined in
1125      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1126      * instead of a sequence of {Transfer} event(s).
1127      *
1128      * Calling this function outside of contract creation WILL make your contract
1129      * non-compliant with the ERC721 standard.
1130      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1131      * {ConsecutiveTransfer} event is only permissible during contract creation.
1132      *
1133      * Requirements:
1134      *
1135      * - `to` cannot be the zero address.
1136      * - `quantity` must be greater than 0.
1137      *
1138      * Emits a {ConsecutiveTransfer} event.
1139      */
1140     function _mintERC2309(address to, uint256 quantity) internal virtual {
1141         uint256 startTokenId = _currentIndex;
1142         if (to == address(0)) revert MintToZeroAddress();
1143         if (quantity == 0) revert MintZeroQuantity();
1144         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1145 
1146         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1147 
1148         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1149         unchecked {
1150             // Updates:
1151             // - `balance += quantity`.
1152             // - `numberMinted += quantity`.
1153             //
1154             // We can directly add to the `balance` and `numberMinted`.
1155             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1156 
1157             // Updates:
1158             // - `address` to the owner.
1159             // - `startTimestamp` to the timestamp of minting.
1160             // - `burned` to `false`.
1161             // - `nextInitialized` to `quantity == 1`.
1162             _packedOwnerships[startTokenId] = _packOwnershipData(
1163                 to,
1164                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1165             );
1166 
1167             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1168 
1169             _currentIndex = startTokenId + quantity;
1170         }
1171         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1172     }
1173 
1174     /**
1175      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1176      *
1177      * Requirements:
1178      *
1179      * - If `to` refers to a smart contract, it must implement
1180      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1181      * - `quantity` must be greater than 0.
1182      *
1183      * See {_mint}.
1184      *
1185      * Emits a {Transfer} event for each mint.
1186      */
1187     function _safeMint(
1188         address to,
1189         uint256 quantity,
1190         bytes memory _data
1191     ) internal virtual {
1192         _mint(to, quantity);
1193 
1194         unchecked {
1195             if (to.code.length != 0) {
1196                 uint256 end = _currentIndex;
1197                 uint256 index = end - quantity;
1198                 do {
1199                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1200                         revert TransferToNonERC721ReceiverImplementer();
1201                     }
1202                 } while (index < end);
1203                 // Reentrancy protection.
1204                 if (_currentIndex != end) revert();
1205             }
1206         }
1207     }
1208 
1209     /**
1210      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1211      */
1212     function _safeMint(address to, uint256 quantity) internal virtual {
1213         _safeMint(to, quantity, '');
1214     }
1215 
1216     // =============================================================
1217     //                       APPROVAL OPERATIONS
1218     // =============================================================
1219 
1220 
1221     /**
1222      * @dev Equivalent to `_approve(to, tokenId, false)`.
1223      */
1224     function _approve(address to, uint256 tokenId) internal virtual {
1225         _approve(to, tokenId, false);
1226     }
1227 
1228     /**
1229      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1230      * The approval is cleared when the token is transferred.
1231      *
1232      * Only a single account can be approved at a time, so approving the
1233      * zero address clears previous approvals.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      *
1239      * Emits an {Approval} event.
1240      */
1241     function _approve(address to, uint256 tokenId, bool approvalCheck) internal virtual {
1242         address owner = ownerOf(tokenId);
1243 
1244         if (approvalCheck && _msgSenderERC721A() != owner)
1245             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1246                 revert ApprovalCallerNotOwnerNorApproved();
1247             }
1248 
1249         _tokenApprovals[tokenId].value = to;
1250         emit Approval(owner, to, tokenId);
1251     }
1252 
1253     // =============================================================
1254     //                        BURN OPERATIONS
1255     // =============================================================
1256 
1257     /**
1258      * @dev Equivalent to `_burn(tokenId, false)`.
1259      */
1260     function _burn(uint256 tokenId) internal virtual {
1261         _burn(tokenId, false);
1262     }
1263 
1264     /**
1265      * @dev Destroys `tokenId`.
1266      * The approval is cleared when the token is burned.
1267      *
1268      * Requirements:
1269      *
1270      * - `tokenId` must exist.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1275         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1276 
1277         address from = address(uint160(prevOwnershipPacked));
1278 
1279         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1280 
1281         if (approvalCheck) {
1282             // The nested ifs save around 20+ gas over a compound boolean condition.
1283             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1284                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1285         }
1286 
1287         _beforeTokenTransfers(from, address(0), tokenId, 1);
1288 
1289         // Clear approvals from the previous owner.
1290         assembly {
1291             if approvedAddress {
1292                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1293                 sstore(approvedAddressSlot, 0)
1294             }
1295         }
1296 
1297         // Underflow of the sender's balance is impossible because we check for
1298         // ownership above and the recipient's balance can't realistically overflow.
1299         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1300         unchecked {
1301             // Updates:
1302             // - `balance -= 1`.
1303             // - `numberBurned += 1`.
1304             //
1305             // We can directly decrement the balance, and increment the number burned.
1306             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1307             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1308 
1309             // Updates:
1310             // - `address` to the last owner.
1311             // - `startTimestamp` to the timestamp of burning.
1312             // - `burned` to `true`.
1313             // - `nextInitialized` to `true`.
1314             _packedOwnerships[tokenId] = _packOwnershipData(
1315                 from,
1316                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1317             );
1318 
1319             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1320             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1321                 uint256 nextTokenId = tokenId + 1;
1322                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1323                 if (_packedOwnerships[nextTokenId] == 0) {
1324                     // If the next slot is within bounds.
1325                     if (nextTokenId != _currentIndex) {
1326                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1327                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1328                     }
1329                 }
1330             }
1331         }
1332 
1333         emit Transfer(from, address(0), tokenId);
1334         _afterTokenTransfers(from, address(0), tokenId, 1);
1335 
1336         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1337         unchecked {
1338             _burnCounter++;
1339         }
1340     }
1341 
1342     // =============================================================
1343     //                     EXTRA DATA OPERATIONS
1344     // =============================================================
1345 
1346     /**
1347      * @dev Directly sets the extra data for the ownership data `index`.
1348      */
1349     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1350         uint256 packed = _packedOwnerships[index];
1351         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1352         uint256 extraDataCasted;
1353         // Cast `extraData` with assembly to avoid redundant masking.
1354         assembly {
1355             extraDataCasted := extraData
1356         }
1357         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1358         _packedOwnerships[index] = packed;
1359     }
1360 
1361     /**
1362      * @dev Called during each token transfer to set the 24bit `extraData` field.
1363      * Intended to be overridden by the cosumer contract.
1364      *
1365      * `previousExtraData` - the value of `extraData` before transfer.
1366      *
1367      * Calling conditions:
1368      *
1369      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1370      * transferred to `to`.
1371      * - When `from` is zero, `tokenId` will be minted for `to`.
1372      * - When `to` is zero, `tokenId` will be burned by `from`.
1373      * - `from` and `to` are never both zero.
1374      */
1375     function _extraData(
1376         address from,
1377         address to,
1378         uint24 previousExtraData
1379     ) internal view virtual returns (uint24) {}
1380 
1381     /**
1382      * @dev Returns the next extra data for the packed ownership data.
1383      * The returned result is shifted into position.
1384      */
1385     function _nextExtraData(
1386         address from,
1387         address to,
1388         uint256 prevOwnershipPacked
1389     ) private view returns (uint256) {
1390         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1391         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1392     }
1393 
1394     // =============================================================
1395     //                       OTHER OPERATIONS
1396     // =============================================================
1397 
1398     /**
1399      * @dev Returns the message sender (defaults to `msg.sender`).
1400      *
1401      * If you are writing GSN compatible contracts, you need to override this function.
1402      */
1403     function _msgSenderERC721A() internal view virtual returns (address) {
1404         return msg.sender;
1405     }
1406 
1407     /**
1408      * @dev Converts a uint256 to its ASCII string decimal representation.
1409      */
1410     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1411         assembly {
1412             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1413             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1414             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1415             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1416             let m := add(mload(0x40), 0xa0)
1417             // Update the free memory pointer to allocate.
1418             mstore(0x40, m)
1419             // Assign the `str` to the end.
1420             str := sub(m, 0x20)
1421             // Zeroize the slot after the string.
1422             mstore(str, 0)
1423 
1424             // Cache the end of the memory to calculate the length later.
1425             let end := str
1426 
1427             // We write the string from rightmost digit to leftmost digit.
1428             // The following is essentially a do-while loop that also handles the zero case.
1429             // prettier-ignore
1430             for { let temp := value } 1 {} {
1431                 str := sub(str, 1)
1432                 // Write the character to the pointer.
1433                 // The ASCII index of the '0' character is 48.
1434                 mstore8(str, add(48, mod(temp, 10)))
1435                 // Keep dividing `temp` until zero.
1436                 temp := div(temp, 10)
1437                 // prettier-ignore
1438                 if iszero(temp) { break }
1439             }
1440 
1441             let length := sub(end, str)
1442             // Move the pointer 32 bytes leftwards to make room for the length.
1443             str := sub(str, 0x20)
1444             // Store the length.
1445             mstore(str, length)
1446         }
1447     }
1448 }
1449 
1450 abstract contract Ownable {
1451     address public owner; 
1452     constructor() { owner = msg.sender; }
1453     modifier onlyOwner { require(owner == msg.sender, "Not Owner!"); _; }
1454     function transferOwnership(address new_) external onlyOwner { owner = new_; }
1455 }
1456 
1457 interface IOperatorFilterRegistry {
1458     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1459     function register(address registrant) external;
1460     function registerAndSubscribe(address registrant, address subscription) external;
1461     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1462     function unregister(address addr) external;
1463     function updateOperator(address registrant, address operator, bool filtered) external;
1464     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1465     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1466     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1467     function subscribe(address registrant, address registrantToSubscribe) external;
1468     function unsubscribe(address registrant, bool copyExistingEntries) external;
1469     function subscriptionOf(address addr) external returns (address registrant);
1470     function subscribers(address registrant) external returns (address[] memory);
1471     function subscriberAt(address registrant, uint256 index) external returns (address);
1472     function copyEntriesOf(address registrant, address registrantToCopy) external;
1473     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1474     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1475     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1476     function filteredOperators(address addr) external returns (address[] memory);
1477     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1478     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1479     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1480     function isRegistered(address addr) external returns (bool);
1481     function codeHashOf(address addr) external returns (bytes32);
1482 }
1483 
1484 abstract contract OperatorFilterer {
1485     error OperatorNotAllowed(address operator);
1486 
1487     IOperatorFilterRegistry constant operatorFilterRegistry =
1488         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1489 
1490     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1491         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1492         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1493         // order for the modifier to filter addresses.
1494         if (address(operatorFilterRegistry).code.length > 0) {
1495             if (subscribe) {
1496                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1497             } else {
1498                 if (subscriptionOrRegistrantToCopy != address(0)) {
1499                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1500                 } else {
1501                     operatorFilterRegistry.register(address(this));
1502                 }
1503             }
1504         }
1505     }
1506 
1507     modifier onlyAllowedOperator(address from) virtual {
1508         // Check registry code length to facilitate testing in environments without a deployed registry.
1509         if (address(operatorFilterRegistry).code.length > 0) {
1510             // Allow spending tokens from addresses with balance
1511             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1512             // from an EOA.
1513             if (from == msg.sender) {
1514                 _;
1515                 return;
1516             }
1517             if (
1518                 !(
1519                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1520                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1521                 )
1522             ) {
1523                 revert OperatorNotAllowed(msg.sender);
1524             }
1525         }
1526         _;
1527     }
1528 }
1529 
1530 abstract contract MerkleProof {
1531     bytes32 internal _merkleRoot;
1532     bytes32 internal _merkleRoot2;
1533     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
1534         _merkleRoot = merkleRoot_;
1535     }
1536 
1537     function _setMerkleRoot2(bytes32 merkleRoot_) internal virtual {
1538         _merkleRoot2 = merkleRoot_;
1539     }
1540 
1541     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
1542         bytes32 _leaf = keccak256(abi.encodePacked(address_));
1543         for (uint256 i = 0; i < proof_.length; i++) {
1544             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
1545         }
1546         return _leaf == _merkleRoot;
1547     }
1548 
1549     function isWhitelisted2(address address_, bytes32[] memory proof_) public view returns (bool) {
1550         bytes32 _leaf = keccak256(abi.encodePacked(address_));
1551         for (uint256 i = 0; i < proof_.length; i++) {
1552             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
1553         }
1554         return _leaf == _merkleRoot2;
1555     }
1556 }
1557 
1558 /*
1559 /
1560 //
1561 ///
1562 //
1563 /
1564 */
1565 
1566 contract ProofOfChad is ERC721A, Ownable, OperatorFilterer, MerkleProof {
1567 
1568     uint256 public maxToken = 5555;
1569     uint256 public mintMax = 5; 
1570     uint256 public chadlistMintMax = 3; 
1571 
1572     // booleans for if mint is enabled
1573     bool public publicMintEnabled = false;
1574     bool public chadlistMintEnabled = false;
1575 
1576     uint256 public chadlistMintPrice = 0.007 ether;
1577     uint256 public pbmintPrice = 0.01 ether;
1578 
1579     string private baseTokenURI;
1580 
1581     mapping(address => uint256) public chadlistMinted;
1582     mapping(address => uint256) public pbMinted;
1583 
1584     constructor() ERC721A("Proof of Chad", "POC") OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), true) {
1585         // sethiddenBaseURI("im chad");
1586     }
1587 
1588     //mint function
1589 
1590     function ownerMint(uint256 _amount, address _address) public onlyOwner { 
1591         require(_amount + totalSupply() <= maxToken, "No more NFTs");
1592 
1593         _safeMint(_address, _amount);
1594     }
1595 
1596     function chadlistMint(uint256 _amount, bytes32[] memory proof_) public payable onlySender { 
1597         require(chadlistMintEnabled == true, "Sale inactive");
1598         require(_amount + totalSupply() <= maxToken, "No more NFTs");
1599         require(chadlistMintMax >= _amount, "You've reached max per tx");
1600         require(chadlistMintMax >= chadlistMinted[msg.sender] + _amount, "You've reached max per address");
1601         require(isWhitelisted(msg.sender, proof_), "You are not whitelisted!");
1602         require(msg.value >= chadlistMintPrice * _amount, "Value sent is not correct");
1603         payable(owner).transfer(msg.value);
1604         chadlistMinted[msg.sender] += _amount;
1605         _safeMint(msg.sender, _amount);
1606     }
1607 
1608 
1609     function pbMint(uint256 _amount) public payable onlySender { 
1610         require(publicMintEnabled == true, "Sale inactive");
1611         require(_amount + totalSupply() <= maxToken, "No more NFTs");
1612         require(mintMax >= _amount, "Exceed max per tx");
1613         require(mintMax >= pbMinted[msg.sender] + _amount, "Exceed max per address");
1614         require(msg.value >= pbmintPrice * _amount, "Value sent is not correct");
1615         payable(owner).transfer(msg.value);
1616         pbMinted[msg.sender] += _amount;
1617         _safeMint(msg.sender, _amount);
1618     }
1619 
1620     function teamMint(uint256 _amount, bytes32[] memory proof_) public payable onlySender { 
1621         require(isWhitelisted2(msg.sender, proof_), "You are not whitelisted!");
1622         require(msg.value >= pbmintPrice * _amount, "Value sent is not correct");
1623         payable(owner).transfer(msg.value);
1624 
1625         _safeMint(msg.sender, _amount);
1626     }
1627     //owner function
1628 
1629     function togglePublicMint() external onlyOwner {
1630         publicMintEnabled = !publicMintEnabled;
1631     }
1632 
1633     function toggleChadlistMint() external onlyOwner {
1634         chadlistMintEnabled = !chadlistMintEnabled;
1635     }
1636 
1637     function letsGo(bool soldOut) external onlyOwner {
1638         chadlistMintEnabled = soldOut;
1639         publicMintEnabled = soldOut;
1640     }
1641 
1642     function setMaxMint(uint256 newMax) external onlyOwner {
1643         mintMax = newMax;
1644     }
1645 
1646     function cutSupply(uint256 newMaxToken) external onlyOwner {
1647         maxToken = newMaxToken;
1648     }
1649 
1650     function setPbPrice(uint256 newPrice) external onlyOwner {
1651         pbmintPrice = newPrice;
1652     }
1653 
1654     function setChadlistPrice(uint256 newChadlistPrice) external onlyOwner {
1655         chadlistMintPrice = newChadlistPrice;
1656     }
1657 
1658     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
1659         _setMerkleRoot(merkleRoot_);
1660     }
1661 
1662     function setMerkleRoot2(bytes32 merkleRoot2_) external onlyOwner {
1663         _setMerkleRoot2(merkleRoot2_);
1664     }
1665 
1666     function setBaseURI(string memory uri_) public onlyOwner {
1667         baseTokenURI = uri_;
1668     }
1669 
1670     function withdraw() public onlyOwner {
1671         uint256 sendAmount = address(this).balance;
1672 
1673         address aa = payable(0x8af0828085Ff896a254d43c63175a750694045a8);
1674 
1675         bool success;
1676 
1677         (success, ) = aa.call{value: (sendAmount * 1000/1000)}("");
1678         require(success, "Failed to withdraw Ether");
1679     }
1680 
1681     //view function
1682 
1683     function _startTokenId() internal view virtual override returns (uint256) {
1684         return 1;
1685     }
1686 
1687     function currentBaseURI() private view returns (string memory){
1688         return baseTokenURI;
1689     }
1690 
1691     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1692         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1693         return string(abi.encodePacked(currentBaseURI(), Strings.toString(tokenId), ".json"));
1694     }
1695 
1696     //modifier
1697 
1698     modifier onlySender() {
1699         require(msg.sender == tx.origin, "No smart contract");
1700         _;
1701     }
1702 
1703     //filterer
1704 
1705     function transferFrom(address from, address to, uint256 tokenId)
1706         public
1707         payable
1708         override
1709         onlyAllowedOperator(from)
1710     {
1711         super.transferFrom(from, to, tokenId);
1712     }
1713 
1714     function reserveBulk(address[] memory to) external onlyOwner {
1715         for (uint i = 0; i < to.length;i++) {
1716             _safeMint(to[i], 1);
1717         }
1718     }
1719 
1720     function safeTransferFrom(address from, address to, uint256 tokenId)
1721         public
1722         payable
1723         override
1724         onlyAllowedOperator(from)
1725     {
1726         super.safeTransferFrom(from, to, tokenId);
1727     }
1728 
1729     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1730         public
1731         payable
1732         override
1733         onlyAllowedOperator(from)
1734     {
1735         super.safeTransferFrom(from, to, tokenId, data);
1736     }
1737 }