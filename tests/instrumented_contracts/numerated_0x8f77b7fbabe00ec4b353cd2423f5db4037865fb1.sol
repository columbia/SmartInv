1 /*
2 ████████╗███████╗███╗░░░███╗██████╗░███████╗██████╗░  ██████╗░██╗░░██╗██╗░░░██╗████████╗██╗░░██╗███╗░░░███╗
3 ╚══██╔══╝██╔════╝████╗░████║██╔══██╗██╔════╝██╔══██╗  ██╔══██╗██║░░██║╚██╗░██╔╝╚══██╔══╝██║░░██║████╗░████║
4 ░░░██║░░░█████╗░░██╔████╔██║██████╔╝█████╗░░██████╔╝  ██████╔╝███████║░╚████╔╝░░░░██║░░░███████║██╔████╔██║
5 ░░░██║░░░██╔══╝░░██║╚██╔╝██║██╔═══╝░██╔══╝░░██╔══██╗  ██╔══██╗██╔══██║░░╚██╔╝░░░░░██║░░░██╔══██║██║╚██╔╝██║
6 ░░░██║░░░███████╗██║░╚═╝░██║██║░░░░░███████╗██║░░██║  ██║░░██║██║░░██║░░░██║░░░░░░██║░░░██║░░██║██║░╚═╝░██║
7 ░░░╚═╝░░░╚══════╝╚═╝░░░░░╚═╝╚═╝░░░░░╚══════╝╚═╝░░╚═╝  ╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░░░░╚═╝
8 
9 ██████╗░██╗░░░██╗  ████████╗░█████╗░██████╗░░█████╗░░█████╗░░██████╗░█████╗░
10 ██╔══██╗╚██╗░██╔╝  ╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
11 ██████╦╝░╚████╔╝░  ░░░██║░░░███████║██████╔╝██║░░╚═╝██║░░██║╚█████╗░███████║
12 ██╔══██╗░░╚██╔╝░░  ░░░██║░░░██╔══██║██╔══██╗██║░░██╗██║░░██║░╚═══██╗██╔══██║
13 ██████╦╝░░░██║░░░  ░░░██║░░░██║░░██║██║░░██║╚█████╔╝╚█████╔╝██████╔╝██║░░██║
14 ╚═════╝░░░░╚═╝░░░  ░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░░╚════╝░╚═════╝░╚═╝░░╚═╝
15 */
16 // SPDX-License-Identifier: MIT
17 // Temper Rhythm by Tarcosa
18 
19 // File: @openzeppelin/contracts/utils/Strings.sol
20 
21 
22 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31     uint8 private constant _ADDRESS_LENGTH = 20;
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 
89     /**
90      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
91      */
92     function toHexString(address addr) internal pure returns (string memory) {
93         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
94     }
95 }
96 
97 // File: erc721a/contracts/IERC721A.sol
98 
99 
100 // ERC721A Contracts v4.2.2
101 // Creator: Chiru Labs
102 
103 pragma solidity ^0.8.4;
104 
105 /**
106  * @dev Interface of ERC721A.
107  */
108 interface IERC721A {
109     /**
110      * The caller must own the token or be an approved operator.
111      */
112     error ApprovalCallerNotOwnerNorApproved();
113 
114     /**
115      * The token does not exist.
116      */
117     error ApprovalQueryForNonexistentToken();
118 
119     /**
120      * The caller cannot approve to their own address.
121      */
122     error ApproveToCaller();
123 
124     /**
125      * Cannot query the balance for the zero address.
126      */
127     error BalanceQueryForZeroAddress();
128 
129     /**
130      * Cannot mint to the zero address.
131      */
132     error MintToZeroAddress();
133 
134     /**
135      * The quantity of tokens minted must be more than zero.
136      */
137     error MintZeroQuantity();
138 
139     /**
140      * The token does not exist.
141      */
142     error OwnerQueryForNonexistentToken();
143 
144     /**
145      * The caller must own the token or be an approved operator.
146      */
147     error TransferCallerNotOwnerNorApproved();
148 
149     /**
150      * The token must be owned by `from`.
151      */
152     error TransferFromIncorrectOwner();
153 
154     /**
155      * Cannot safely transfer to a contract that does not implement the
156      * ERC721Receiver interface.
157      */
158     error TransferToNonERC721ReceiverImplementer();
159 
160     /**
161      * Cannot transfer to the zero address.
162      */
163     error TransferToZeroAddress();
164 
165     /**
166      * The token does not exist.
167      */
168     error URIQueryForNonexistentToken();
169 
170     /**
171      * The `quantity` minted with ERC2309 exceeds the safety limit.
172      */
173     error MintERC2309QuantityExceedsLimit();
174 
175     /**
176      * The `extraData` cannot be set on an unintialized ownership slot.
177      */
178     error OwnershipNotInitializedForExtraData();
179 
180     // =============================================================
181     //                            STRUCTS
182     // =============================================================
183 
184     struct TokenOwnership {
185         // The address of the owner.
186         address addr;
187         // Stores the start time of ownership with minimal overhead for tokenomics.
188         uint64 startTimestamp;
189         // Whether the token has been burned.
190         bool burned;
191         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
192         uint24 extraData;
193     }
194 
195     // =============================================================
196     //                         TOKEN COUNTERS
197     // =============================================================
198 
199     /**
200      * @dev Returns the total number of tokens in existence.
201      * Burned tokens will reduce the count.
202      * To get the total number of tokens minted, please see {_totalMinted}.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     // =============================================================
207     //                            IERC165
208     // =============================================================
209 
210     /**
211      * @dev Returns true if this contract implements the interface defined by
212      * `interfaceId`. See the corresponding
213      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
214      * to learn more about how these ids are created.
215      *
216      * This function call must use less than 30000 gas.
217      */
218     function supportsInterface(bytes4 interfaceId) external view returns (bool);
219 
220     // =============================================================
221     //                            IERC721
222     // =============================================================
223 
224     /**
225      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
228 
229     /**
230      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
231      */
232     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
233 
234     /**
235      * @dev Emitted when `owner` enables or disables
236      * (`approved`) `operator` to manage all of its assets.
237      */
238     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
239 
240     /**
241      * @dev Returns the number of tokens in `owner`'s account.
242      */
243     function balanceOf(address owner) external view returns (uint256 balance);
244 
245     /**
246      * @dev Returns the owner of the `tokenId` token.
247      *
248      * Requirements:
249      *
250      * - `tokenId` must exist.
251      */
252     function ownerOf(uint256 tokenId) external view returns (address owner);
253 
254     /**
255      * @dev Safely transfers `tokenId` token from `from` to `to`,
256      * checking first that contract recipients are aware of the ERC721 protocol
257      * to prevent tokens from being forever locked.
258      *
259      * Requirements:
260      *
261      * - `from` cannot be the zero address.
262      * - `to` cannot be the zero address.
263      * - `tokenId` token must exist and be owned by `from`.
264      * - If the caller is not `from`, it must be have been allowed to move
265      * this token by either {approve} or {setApprovalForAll}.
266      * - If `to` refers to a smart contract, it must implement
267      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
268      *
269      * Emits a {Transfer} event.
270      */
271     function safeTransferFrom(
272         address from,
273         address to,
274         uint256 tokenId,
275         bytes calldata data
276     ) external;
277 
278     /**
279      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
280      */
281     function safeTransferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Transfers `tokenId` from `from` to `to`.
289      *
290      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
291      * whenever possible.
292      *
293      * Requirements:
294      *
295      * - `from` cannot be the zero address.
296      * - `to` cannot be the zero address.
297      * - `tokenId` token must be owned by `from`.
298      * - If the caller is not `from`, it must be approved to move this token
299      * by either {approve} or {setApprovalForAll}.
300      *
301      * Emits a {Transfer} event.
302      */
303     function transferFrom(
304         address from,
305         address to,
306         uint256 tokenId
307     ) external;
308 
309     /**
310      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
311      * The approval is cleared when the token is transferred.
312      *
313      * Only a single account can be approved at a time, so approving the
314      * zero address clears previous approvals.
315      *
316      * Requirements:
317      *
318      * - The caller must own the token or be an approved operator.
319      * - `tokenId` must exist.
320      *
321      * Emits an {Approval} event.
322      */
323     function approve(address to, uint256 tokenId) external;
324 
325     /**
326      * @dev Approve or remove `operator` as an operator for the caller.
327      * Operators can call {transferFrom} or {safeTransferFrom}
328      * for any token owned by the caller.
329      *
330      * Requirements:
331      *
332      * - The `operator` cannot be the caller.
333      *
334      * Emits an {ApprovalForAll} event.
335      */
336     function setApprovalForAll(address operator, bool _approved) external;
337 
338     /**
339      * @dev Returns the account approved for `tokenId` token.
340      *
341      * Requirements:
342      *
343      * - `tokenId` must exist.
344      */
345     function getApproved(uint256 tokenId) external view returns (address operator);
346 
347     /**
348      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
349      *
350      * See {setApprovalForAll}.
351      */
352     function isApprovedForAll(address owner, address operator) external view returns (bool);
353 
354     // =============================================================
355     //                        IERC721Metadata
356     // =============================================================
357 
358     /**
359      * @dev Returns the token collection name.
360      */
361     function name() external view returns (string memory);
362 
363     /**
364      * @dev Returns the token collection symbol.
365      */
366     function symbol() external view returns (string memory);
367 
368     /**
369      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
370      */
371     function tokenURI(uint256 tokenId) external view returns (string memory);
372 
373     // =============================================================
374     //                           IERC2309
375     // =============================================================
376 
377     /**
378      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
379      * (inclusive) is transferred from `from` to `to`, as defined in the
380      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
381      *
382      * See {_mintERC2309} for more details.
383      */
384     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
385 }
386 
387 // File: erc721a/contracts/ERC721A.sol
388 
389 
390 // ERC721A Contracts v4.2.2
391 // Creator: Chiru Labs
392 
393 pragma solidity ^0.8.4;
394 
395 
396 /**
397  * @dev Interface of ERC721 token receiver.
398  */
399 interface ERC721A__IERC721Receiver {
400     function onERC721Received(
401         address operator,
402         address from,
403         uint256 tokenId,
404         bytes calldata data
405     ) external returns (bytes4);
406 }
407 
408 /**
409  * @title ERC721A
410  *
411  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
412  * Non-Fungible Token Standard, including the Metadata extension.
413  * Optimized for lower gas during batch mints.
414  *
415  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
416  * starting from `_startTokenId()`.
417  *
418  * Assumptions:
419  *
420  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
421  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
422  */
423 contract ERC721A is IERC721A {
424     // Reference type for token approval.
425     struct TokenApprovalRef {
426         address value;
427     }
428 
429     // =============================================================
430     //                           CONSTANTS
431     // =============================================================
432 
433     // Mask of an entry in packed address data.
434     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
435 
436     // The bit position of `numberMinted` in packed address data.
437     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
438 
439     // The bit position of `numberBurned` in packed address data.
440     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
441 
442     // The bit position of `aux` in packed address data.
443     uint256 private constant _BITPOS_AUX = 192;
444 
445     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
446     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
447 
448     // The bit position of `startTimestamp` in packed ownership.
449     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
450 
451     // The bit mask of the `burned` bit in packed ownership.
452     uint256 private constant _BITMASK_BURNED = 1 << 224;
453 
454     // The bit position of the `nextInitialized` bit in packed ownership.
455     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
456 
457     // The bit mask of the `nextInitialized` bit in packed ownership.
458     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
459 
460     // The bit position of `extraData` in packed ownership.
461     uint256 private constant _BITPOS_EXTRA_DATA = 232;
462 
463     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
464     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
465 
466     // The mask of the lower 160 bits for addresses.
467     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
468 
469     // The maximum `quantity` that can be minted with {_mintERC2309}.
470     // This limit is to prevent overflows on the address data entries.
471     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
472     // is required to cause an overflow, which is unrealistic.
473     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
474 
475     // The `Transfer` event signature is given by:
476     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
477     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
478         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
479 
480     // =============================================================
481     //                            STORAGE
482     // =============================================================
483 
484     // The next token ID to be minted.
485     uint256 private _currentIndex;
486 
487     // The number of tokens burned.
488     uint256 private _burnCounter;
489 
490     // Token name
491     string private _name;
492 
493     // Token symbol
494     string private _symbol;
495 
496     // Mapping from token ID to ownership details
497     // An empty struct value does not necessarily mean the token is unowned.
498     // See {_packedOwnershipOf} implementation for details.
499     //
500     // Bits Layout:
501     // - [0..159]   `addr`
502     // - [160..223] `startTimestamp`
503     // - [224]      `burned`
504     // - [225]      `nextInitialized`
505     // - [232..255] `extraData`
506     mapping(uint256 => uint256) private _packedOwnerships;
507 
508     // Mapping owner address to address data.
509     //
510     // Bits Layout:
511     // - [0..63]    `balance`
512     // - [64..127]  `numberMinted`
513     // - [128..191] `numberBurned`
514     // - [192..255] `aux`
515     mapping(address => uint256) private _packedAddressData;
516 
517     // Mapping from token ID to approved address.
518     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
519 
520     // Mapping from owner to operator approvals
521     mapping(address => mapping(address => bool)) private _operatorApprovals;
522 
523     // =============================================================
524     //                          CONSTRUCTOR
525     // =============================================================
526 
527     constructor(string memory name_, string memory symbol_) {
528         _name = name_;
529         _symbol = symbol_;
530         _currentIndex = _startTokenId();
531     }
532 
533     // =============================================================
534     //                   TOKEN COUNTING OPERATIONS
535     // =============================================================
536 
537     /**
538      * @dev Returns the starting token ID.
539      * To change the starting token ID, please override this function.
540      */
541     function _startTokenId() internal view virtual returns (uint256) {
542         return 0;
543     }
544 
545     /**
546      * @dev Returns the next token ID to be minted.
547      */
548     function _nextTokenId() internal view virtual returns (uint256) {
549         return _currentIndex;
550     }
551 
552     /**
553      * @dev Returns the total number of tokens in existence.
554      * Burned tokens will reduce the count.
555      * To get the total number of tokens minted, please see {_totalMinted}.
556      */
557     function totalSupply() public view virtual override returns (uint256) {
558         // Counter underflow is impossible as _burnCounter cannot be incremented
559         // more than `_currentIndex - _startTokenId()` times.
560         unchecked {
561             return _currentIndex - _burnCounter - _startTokenId();
562         }
563     }
564 
565     /**
566      * @dev Returns the total amount of tokens minted in the contract.
567      */
568     function _totalMinted() internal view virtual returns (uint256) {
569         // Counter underflow is impossible as `_currentIndex` does not decrement,
570         // and it is initialized to `_startTokenId()`.
571         unchecked {
572             return _currentIndex - _startTokenId();
573         }
574     }
575 
576     /**
577      * @dev Returns the total number of tokens burned.
578      */
579     function _totalBurned() internal view virtual returns (uint256) {
580         return _burnCounter;
581     }
582 
583     // =============================================================
584     //                    ADDRESS DATA OPERATIONS
585     // =============================================================
586 
587     /**
588      * @dev Returns the number of tokens in `owner`'s account.
589      */
590     function balanceOf(address owner) public view virtual override returns (uint256) {
591         if (owner == address(0)) revert BalanceQueryForZeroAddress();
592         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
593     }
594 
595     /**
596      * Returns the number of tokens minted by `owner`.
597      */
598     function _numberMinted(address owner) internal view returns (uint256) {
599         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
600     }
601 
602     /**
603      * Returns the number of tokens burned by or on behalf of `owner`.
604      */
605     function _numberBurned(address owner) internal view returns (uint256) {
606         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
607     }
608 
609     /**
610      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
611      */
612     function _getAux(address owner) internal view returns (uint64) {
613         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
614     }
615 
616     /**
617      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
618      * If there are multiple variables, please pack them into a uint64.
619      */
620     function _setAux(address owner, uint64 aux) internal virtual {
621         uint256 packed = _packedAddressData[owner];
622         uint256 auxCasted;
623         // Cast `aux` with assembly to avoid redundant masking.
624         assembly {
625             auxCasted := aux
626         }
627         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
628         _packedAddressData[owner] = packed;
629     }
630 
631     // =============================================================
632     //                            IERC165
633     // =============================================================
634 
635     /**
636      * @dev Returns true if this contract implements the interface defined by
637      * `interfaceId`. See the corresponding
638      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
639      * to learn more about how these ids are created.
640      *
641      * This function call must use less than 30000 gas.
642      */
643     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
644         // The interface IDs are constants representing the first 4 bytes
645         // of the XOR of all function selectors in the interface.
646         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
647         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
648         return
649             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
650             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
651             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
652     }
653 
654     // =============================================================
655     //                        IERC721Metadata
656     // =============================================================
657 
658     /**
659      * @dev Returns the token collection name.
660      */
661     function name() public view virtual override returns (string memory) {
662         return _name;
663     }
664 
665     /**
666      * @dev Returns the token collection symbol.
667      */
668     function symbol() public view virtual override returns (string memory) {
669         return _symbol;
670     }
671 
672     /**
673      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
674      */
675     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
676         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
677 
678         string memory baseURI = _baseURI();
679         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
680     }
681 
682     /**
683      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
684      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
685      * by default, it can be overridden in child contracts.
686      */
687     function _baseURI() internal view virtual returns (string memory) {
688         return '';
689     }
690 
691     // =============================================================
692     //                     OWNERSHIPS OPERATIONS
693     // =============================================================
694 
695     /**
696      * @dev Returns the owner of the `tokenId` token.
697      *
698      * Requirements:
699      *
700      * - `tokenId` must exist.
701      */
702     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
703         return address(uint160(_packedOwnershipOf(tokenId)));
704     }
705 
706     /**
707      * @dev Gas spent here starts off proportional to the maximum mint batch size.
708      * It gradually moves to O(1) as tokens get transferred around over time.
709      */
710     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
711         return _unpackedOwnership(_packedOwnershipOf(tokenId));
712     }
713 
714     /**
715      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
716      */
717     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
718         return _unpackedOwnership(_packedOwnerships[index]);
719     }
720 
721     /**
722      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
723      */
724     function _initializeOwnershipAt(uint256 index) internal virtual {
725         if (_packedOwnerships[index] == 0) {
726             _packedOwnerships[index] = _packedOwnershipOf(index);
727         }
728     }
729 
730     /**
731      * Returns the packed ownership data of `tokenId`.
732      */
733     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
734         uint256 curr = tokenId;
735 
736         unchecked {
737             if (_startTokenId() <= curr)
738                 if (curr < _currentIndex) {
739                     uint256 packed = _packedOwnerships[curr];
740                     // If not burned.
741                     if (packed & _BITMASK_BURNED == 0) {
742                         // Invariant:
743                         // There will always be an initialized ownership slot
744                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
745                         // before an unintialized ownership slot
746                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
747                         // Hence, `curr` will not underflow.
748                         //
749                         // We can directly compare the packed value.
750                         // If the address is zero, packed will be zero.
751                         while (packed == 0) {
752                             packed = _packedOwnerships[--curr];
753                         }
754                         return packed;
755                     }
756                 }
757         }
758         revert OwnerQueryForNonexistentToken();
759     }
760 
761     /**
762      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
763      */
764     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
765         ownership.addr = address(uint160(packed));
766         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
767         ownership.burned = packed & _BITMASK_BURNED != 0;
768         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
769     }
770 
771     /**
772      * @dev Packs ownership data into a single uint256.
773      */
774     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
775         assembly {
776             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
777             owner := and(owner, _BITMASK_ADDRESS)
778             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
779             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
780         }
781     }
782 
783     /**
784      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
785      */
786     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
787         // For branchless setting of the `nextInitialized` flag.
788         assembly {
789             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
790             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
791         }
792     }
793 
794     // =============================================================
795     //                      APPROVAL OPERATIONS
796     // =============================================================
797 
798     /**
799      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
800      * The approval is cleared when the token is transferred.
801      *
802      * Only a single account can be approved at a time, so approving the
803      * zero address clears previous approvals.
804      *
805      * Requirements:
806      *
807      * - The caller must own the token or be an approved operator.
808      * - `tokenId` must exist.
809      *
810      * Emits an {Approval} event.
811      */
812     function approve(address to, uint256 tokenId) public virtual override {
813         address owner = ownerOf(tokenId);
814 
815         if (_msgSenderERC721A() != owner)
816             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
817                 revert ApprovalCallerNotOwnerNorApproved();
818             }
819 
820         _tokenApprovals[tokenId].value = to;
821         emit Approval(owner, to, tokenId);
822     }
823 
824     /**
825      * @dev Returns the account approved for `tokenId` token.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must exist.
830      */
831     function getApproved(uint256 tokenId) public view virtual override returns (address) {
832         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
833 
834         return _tokenApprovals[tokenId].value;
835     }
836 
837     /**
838      * @dev Approve or remove `operator` as an operator for the caller.
839      * Operators can call {transferFrom} or {safeTransferFrom}
840      * for any token owned by the caller.
841      *
842      * Requirements:
843      *
844      * - The `operator` cannot be the caller.
845      *
846      * Emits an {ApprovalForAll} event.
847      */
848     function setApprovalForAll(address operator, bool approved) public virtual override {
849         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
850 
851         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
852         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
853     }
854 
855     /**
856      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
857      *
858      * See {setApprovalForAll}.
859      */
860     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
861         return _operatorApprovals[owner][operator];
862     }
863 
864     /**
865      * @dev Returns whether `tokenId` exists.
866      *
867      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
868      *
869      * Tokens start existing when they are minted. See {_mint}.
870      */
871     function _exists(uint256 tokenId) internal view virtual returns (bool) {
872         return
873             _startTokenId() <= tokenId &&
874             tokenId < _currentIndex && // If within bounds,
875             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
876     }
877 
878     /**
879      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
880      */
881     function _isSenderApprovedOrOwner(
882         address approvedAddress,
883         address owner,
884         address msgSender
885     ) private pure returns (bool result) {
886         assembly {
887             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
888             owner := and(owner, _BITMASK_ADDRESS)
889             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
890             msgSender := and(msgSender, _BITMASK_ADDRESS)
891             // `msgSender == owner || msgSender == approvedAddress`.
892             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
893         }
894     }
895 
896     /**
897      * @dev Returns the storage slot and value for the approved address of `tokenId`.
898      */
899     function _getApprovedSlotAndAddress(uint256 tokenId)
900         private
901         view
902         returns (uint256 approvedAddressSlot, address approvedAddress)
903     {
904         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
905         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
906         assembly {
907             approvedAddressSlot := tokenApproval.slot
908             approvedAddress := sload(approvedAddressSlot)
909         }
910     }
911 
912     // =============================================================
913     //                      TRANSFER OPERATIONS
914     // =============================================================
915 
916     /**
917      * @dev Transfers `tokenId` from `from` to `to`.
918      *
919      * Requirements:
920      *
921      * - `from` cannot be the zero address.
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must be owned by `from`.
924      * - If the caller is not `from`, it must be approved to move this token
925      * by either {approve} or {setApprovalForAll}.
926      *
927      * Emits a {Transfer} event.
928      */
929     function transferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public virtual override {
934         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
935 
936         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
937 
938         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
939 
940         // The nested ifs save around 20+ gas over a compound boolean condition.
941         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
942             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
943 
944         if (to == address(0)) revert TransferToZeroAddress();
945 
946         _beforeTokenTransfers(from, to, tokenId, 1);
947 
948         // Clear approvals from the previous owner.
949         assembly {
950             if approvedAddress {
951                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
952                 sstore(approvedAddressSlot, 0)
953             }
954         }
955 
956         // Underflow of the sender's balance is impossible because we check for
957         // ownership above and the recipient's balance can't realistically overflow.
958         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
959         unchecked {
960             // We can directly increment and decrement the balances.
961             --_packedAddressData[from]; // Updates: `balance -= 1`.
962             ++_packedAddressData[to]; // Updates: `balance += 1`.
963 
964             // Updates:
965             // - `address` to the next owner.
966             // - `startTimestamp` to the timestamp of transfering.
967             // - `burned` to `false`.
968             // - `nextInitialized` to `true`.
969             _packedOwnerships[tokenId] = _packOwnershipData(
970                 to,
971                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
972             );
973 
974             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
975             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
976                 uint256 nextTokenId = tokenId + 1;
977                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
978                 if (_packedOwnerships[nextTokenId] == 0) {
979                     // If the next slot is within bounds.
980                     if (nextTokenId != _currentIndex) {
981                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
982                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
983                     }
984                 }
985             }
986         }
987 
988         emit Transfer(from, to, tokenId);
989         _afterTokenTransfers(from, to, tokenId, 1);
990     }
991 
992     /**
993      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
994      */
995     function safeTransferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) public virtual override {
1000         safeTransferFrom(from, to, tokenId, '');
1001     }
1002 
1003     /**
1004      * @dev Safely transfers `tokenId` token from `from` to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must exist and be owned by `from`.
1011      * - If the caller is not `from`, it must be approved to move this token
1012      * by either {approve} or {setApprovalForAll}.
1013      * - If `to` refers to a smart contract, it must implement
1014      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) public virtual override {
1024         transferFrom(from, to, tokenId);
1025         if (to.code.length != 0)
1026             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1027                 revert TransferToNonERC721ReceiverImplementer();
1028             }
1029     }
1030 
1031     /**
1032      * @dev Hook that is called before a set of serially-ordered token IDs
1033      * are about to be transferred. This includes minting.
1034      * And also called before burning one token.
1035      *
1036      * `startTokenId` - the first token ID to be transferred.
1037      * `quantity` - the amount to be transferred.
1038      *
1039      * Calling conditions:
1040      *
1041      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1042      * transferred to `to`.
1043      * - When `from` is zero, `tokenId` will be minted for `to`.
1044      * - When `to` is zero, `tokenId` will be burned by `from`.
1045      * - `from` and `to` are never both zero.
1046      */
1047     function _beforeTokenTransfers(
1048         address from,
1049         address to,
1050         uint256 startTokenId,
1051         uint256 quantity
1052     ) internal virtual {}
1053 
1054     /**
1055      * @dev Hook that is called after a set of serially-ordered token IDs
1056      * have been transferred. This includes minting.
1057      * And also called after one token has been burned.
1058      *
1059      * `startTokenId` - the first token ID to be transferred.
1060      * `quantity` - the amount to be transferred.
1061      *
1062      * Calling conditions:
1063      *
1064      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1065      * transferred to `to`.
1066      * - When `from` is zero, `tokenId` has been minted for `to`.
1067      * - When `to` is zero, `tokenId` has been burned by `from`.
1068      * - `from` and `to` are never both zero.
1069      */
1070     function _afterTokenTransfers(
1071         address from,
1072         address to,
1073         uint256 startTokenId,
1074         uint256 quantity
1075     ) internal virtual {}
1076 
1077     /**
1078      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1079      *
1080      * `from` - Previous owner of the given token ID.
1081      * `to` - Target address that will receive the token.
1082      * `tokenId` - Token ID to be transferred.
1083      * `_data` - Optional data to send along with the call.
1084      *
1085      * Returns whether the call correctly returned the expected magic value.
1086      */
1087     function _checkContractOnERC721Received(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) private returns (bool) {
1093         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1094             bytes4 retval
1095         ) {
1096             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1097         } catch (bytes memory reason) {
1098             if (reason.length == 0) {
1099                 revert TransferToNonERC721ReceiverImplementer();
1100             } else {
1101                 assembly {
1102                     revert(add(32, reason), mload(reason))
1103                 }
1104             }
1105         }
1106     }
1107 
1108     // =============================================================
1109     //                        MINT OPERATIONS
1110     // =============================================================
1111 
1112     /**
1113      * @dev Mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `to` cannot be the zero address.
1118      * - `quantity` must be greater than 0.
1119      *
1120      * Emits a {Transfer} event for each mint.
1121      */
1122     function _mint(address to, uint256 quantity) internal virtual {
1123         uint256 startTokenId = _currentIndex;
1124         if (quantity == 0) revert MintZeroQuantity();
1125 
1126         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1127 
1128         // Overflows are incredibly unrealistic.
1129         // `balance` and `numberMinted` have a maximum limit of 2**64.
1130         // `tokenId` has a maximum limit of 2**256.
1131         unchecked {
1132             // Updates:
1133             // - `balance += quantity`.
1134             // - `numberMinted += quantity`.
1135             //
1136             // We can directly add to the `balance` and `numberMinted`.
1137             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1138 
1139             // Updates:
1140             // - `address` to the owner.
1141             // - `startTimestamp` to the timestamp of minting.
1142             // - `burned` to `false`.
1143             // - `nextInitialized` to `quantity == 1`.
1144             _packedOwnerships[startTokenId] = _packOwnershipData(
1145                 to,
1146                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1147             );
1148 
1149             uint256 toMasked;
1150             uint256 end = startTokenId + quantity;
1151 
1152             // Use assembly to loop and emit the `Transfer` event for gas savings.
1153             assembly {
1154                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1155                 toMasked := and(to, _BITMASK_ADDRESS)
1156                 // Emit the `Transfer` event.
1157                 log4(
1158                     0, // Start of data (0, since no data).
1159                     0, // End of data (0, since no data).
1160                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1161                     0, // `address(0)`.
1162                     toMasked, // `to`.
1163                     startTokenId // `tokenId`.
1164                 )
1165 
1166                 for {
1167                     let tokenId := add(startTokenId, 1)
1168                 } iszero(eq(tokenId, end)) {
1169                     tokenId := add(tokenId, 1)
1170                 } {
1171                     // Emit the `Transfer` event. Similar to above.
1172                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1173                 }
1174             }
1175             if (toMasked == 0) revert MintToZeroAddress();
1176 
1177             _currentIndex = end;
1178         }
1179         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1180     }
1181 
1182     /**
1183      * @dev Mints `quantity` tokens and transfers them to `to`.
1184      *
1185      * This function is intended for efficient minting only during contract creation.
1186      *
1187      * It emits only one {ConsecutiveTransfer} as defined in
1188      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1189      * instead of a sequence of {Transfer} event(s).
1190      *
1191      * Calling this function outside of contract creation WILL make your contract
1192      * non-compliant with the ERC721 standard.
1193      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1194      * {ConsecutiveTransfer} event is only permissible during contract creation.
1195      *
1196      * Requirements:
1197      *
1198      * - `to` cannot be the zero address.
1199      * - `quantity` must be greater than 0.
1200      *
1201      * Emits a {ConsecutiveTransfer} event.
1202      */
1203     function _mintERC2309(address to, uint256 quantity) internal virtual {
1204         uint256 startTokenId = _currentIndex;
1205         if (to == address(0)) revert MintToZeroAddress();
1206         if (quantity == 0) revert MintZeroQuantity();
1207         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1208 
1209         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1210 
1211         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1212         unchecked {
1213             // Updates:
1214             // - `balance += quantity`.
1215             // - `numberMinted += quantity`.
1216             //
1217             // We can directly add to the `balance` and `numberMinted`.
1218             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1219 
1220             // Updates:
1221             // - `address` to the owner.
1222             // - `startTimestamp` to the timestamp of minting.
1223             // - `burned` to `false`.
1224             // - `nextInitialized` to `quantity == 1`.
1225             _packedOwnerships[startTokenId] = _packOwnershipData(
1226                 to,
1227                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1228             );
1229 
1230             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1231 
1232             _currentIndex = startTokenId + quantity;
1233         }
1234         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1235     }
1236 
1237     /**
1238      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - If `to` refers to a smart contract, it must implement
1243      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1244      * - `quantity` must be greater than 0.
1245      *
1246      * See {_mint}.
1247      *
1248      * Emits a {Transfer} event for each mint.
1249      */
1250     function _safeMint(
1251         address to,
1252         uint256 quantity,
1253         bytes memory _data
1254     ) internal virtual {
1255         _mint(to, quantity);
1256 
1257         unchecked {
1258             if (to.code.length != 0) {
1259                 uint256 end = _currentIndex;
1260                 uint256 index = end - quantity;
1261                 do {
1262                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1263                         revert TransferToNonERC721ReceiverImplementer();
1264                     }
1265                 } while (index < end);
1266                 // Reentrancy protection.
1267                 if (_currentIndex != end) revert();
1268             }
1269         }
1270     }
1271 
1272     /**
1273      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1274      */
1275     function _safeMint(address to, uint256 quantity) internal virtual {
1276         _safeMint(to, quantity, '');
1277     }
1278 
1279     // =============================================================
1280     //                        BURN OPERATIONS
1281     // =============================================================
1282 
1283     /**
1284      * @dev Equivalent to `_burn(tokenId, false)`.
1285      */
1286     function _burn(uint256 tokenId) internal virtual {
1287         _burn(tokenId, false);
1288     }
1289 
1290     /**
1291      * @dev Destroys `tokenId`.
1292      * The approval is cleared when the token is burned.
1293      *
1294      * Requirements:
1295      *
1296      * - `tokenId` must exist.
1297      *
1298      * Emits a {Transfer} event.
1299      */
1300     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1301         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1302 
1303         address from = address(uint160(prevOwnershipPacked));
1304 
1305         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1306 
1307         if (approvalCheck) {
1308             // The nested ifs save around 20+ gas over a compound boolean condition.
1309             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1310                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1311         }
1312 
1313         _beforeTokenTransfers(from, address(0), tokenId, 1);
1314 
1315         // Clear approvals from the previous owner.
1316         assembly {
1317             if approvedAddress {
1318                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1319                 sstore(approvedAddressSlot, 0)
1320             }
1321         }
1322 
1323         // Underflow of the sender's balance is impossible because we check for
1324         // ownership above and the recipient's balance can't realistically overflow.
1325         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1326         unchecked {
1327             // Updates:
1328             // - `balance -= 1`.
1329             // - `numberBurned += 1`.
1330             //
1331             // We can directly decrement the balance, and increment the number burned.
1332             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1333             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1334 
1335             // Updates:
1336             // - `address` to the last owner.
1337             // - `startTimestamp` to the timestamp of burning.
1338             // - `burned` to `true`.
1339             // - `nextInitialized` to `true`.
1340             _packedOwnerships[tokenId] = _packOwnershipData(
1341                 from,
1342                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1343             );
1344 
1345             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1346             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1347                 uint256 nextTokenId = tokenId + 1;
1348                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1349                 if (_packedOwnerships[nextTokenId] == 0) {
1350                     // If the next slot is within bounds.
1351                     if (nextTokenId != _currentIndex) {
1352                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1353                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1354                     }
1355                 }
1356             }
1357         }
1358 
1359         emit Transfer(from, address(0), tokenId);
1360         _afterTokenTransfers(from, address(0), tokenId, 1);
1361 
1362         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1363         unchecked {
1364             _burnCounter++;
1365         }
1366     }
1367 
1368     // =============================================================
1369     //                     EXTRA DATA OPERATIONS
1370     // =============================================================
1371 
1372     /**
1373      * @dev Directly sets the extra data for the ownership data `index`.
1374      */
1375     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1376         uint256 packed = _packedOwnerships[index];
1377         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1378         uint256 extraDataCasted;
1379         // Cast `extraData` with assembly to avoid redundant masking.
1380         assembly {
1381             extraDataCasted := extraData
1382         }
1383         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1384         _packedOwnerships[index] = packed;
1385     }
1386 
1387     /**
1388      * @dev Called during each token transfer to set the 24bit `extraData` field.
1389      * Intended to be overridden by the cosumer contract.
1390      *
1391      * `previousExtraData` - the value of `extraData` before transfer.
1392      *
1393      * Calling conditions:
1394      *
1395      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1396      * transferred to `to`.
1397      * - When `from` is zero, `tokenId` will be minted for `to`.
1398      * - When `to` is zero, `tokenId` will be burned by `from`.
1399      * - `from` and `to` are never both zero.
1400      */
1401     function _extraData(
1402         address from,
1403         address to,
1404         uint24 previousExtraData
1405     ) internal view virtual returns (uint24) {}
1406 
1407     /**
1408      * @dev Returns the next extra data for the packed ownership data.
1409      * The returned result is shifted into position.
1410      */
1411     function _nextExtraData(
1412         address from,
1413         address to,
1414         uint256 prevOwnershipPacked
1415     ) private view returns (uint256) {
1416         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1417         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1418     }
1419 
1420     // =============================================================
1421     //                       OTHER OPERATIONS
1422     // =============================================================
1423 
1424     /**
1425      * @dev Returns the message sender (defaults to `msg.sender`).
1426      *
1427      * If you are writing GSN compatible contracts, you need to override this function.
1428      */
1429     function _msgSenderERC721A() internal view virtual returns (address) {
1430         return msg.sender;
1431     }
1432 
1433     /**
1434      * @dev Converts a uint256 to its ASCII string decimal representation.
1435      */
1436     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1437         assembly {
1438             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1439             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1440             // We will need 1 32-byte word to store the length,
1441             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1442             str := add(mload(0x40), 0x80)
1443             // Update the free memory pointer to allocate.
1444             mstore(0x40, str)
1445 
1446             // Cache the end of the memory to calculate the length later.
1447             let end := str
1448 
1449             // We write the string from rightmost digit to leftmost digit.
1450             // The following is essentially a do-while loop that also handles the zero case.
1451             // prettier-ignore
1452             for { let temp := value } 1 {} {
1453                 str := sub(str, 1)
1454                 // Write the character to the pointer.
1455                 // The ASCII index of the '0' character is 48.
1456                 mstore8(str, add(48, mod(temp, 10)))
1457                 // Keep dividing `temp` until zero.
1458                 temp := div(temp, 10)
1459                 // prettier-ignore
1460                 if iszero(temp) { break }
1461             }
1462 
1463             let length := sub(end, str)
1464             // Move the pointer 32 bytes leftwards to make room for the length.
1465             str := sub(str, 0x20)
1466             // Store the length.
1467             mstore(str, length)
1468         }
1469     }
1470 }
1471 
1472 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1473 
1474 
1475 // ERC721A Contracts v4.2.2
1476 // Creator: Chiru Labs
1477 
1478 pragma solidity ^0.8.4;
1479 
1480 
1481 /**
1482  * @dev Interface of ERC721AQueryable.
1483  */
1484 interface IERC721AQueryable is IERC721A {
1485     /**
1486      * Invalid query range (`start` >= `stop`).
1487      */
1488     error InvalidQueryRange();
1489 
1490     /**
1491      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1492      *
1493      * If the `tokenId` is out of bounds:
1494      *
1495      * - `addr = address(0)`
1496      * - `startTimestamp = 0`
1497      * - `burned = false`
1498      * - `extraData = 0`
1499      *
1500      * If the `tokenId` is burned:
1501      *
1502      * - `addr = <Address of owner before token was burned>`
1503      * - `startTimestamp = <Timestamp when token was burned>`
1504      * - `burned = true`
1505      * - `extraData = <Extra data when token was burned>`
1506      *
1507      * Otherwise:
1508      *
1509      * - `addr = <Address of owner>`
1510      * - `startTimestamp = <Timestamp of start of ownership>`
1511      * - `burned = false`
1512      * - `extraData = <Extra data at start of ownership>`
1513      */
1514     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1515 
1516     /**
1517      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1518      * See {ERC721AQueryable-explicitOwnershipOf}
1519      */
1520     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1521 
1522     /**
1523      * @dev Returns an array of token IDs owned by `owner`,
1524      * in the range [`start`, `stop`)
1525      * (i.e. `start <= tokenId < stop`).
1526      *
1527      * This function allows for tokens to be queried if the collection
1528      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1529      *
1530      * Requirements:
1531      *
1532      * - `start < stop`
1533      */
1534     function tokensOfOwnerIn(
1535         address owner,
1536         uint256 start,
1537         uint256 stop
1538     ) external view returns (uint256[] memory);
1539 
1540     /**
1541      * @dev Returns an array of token IDs owned by `owner`.
1542      *
1543      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1544      * It is meant to be called off-chain.
1545      *
1546      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1547      * multiple smaller scans if the collection is large enough to cause
1548      * an out-of-gas error (10K collections should be fine).
1549      */
1550     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1551 }
1552 
1553 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1554 
1555 
1556 // ERC721A Contracts v4.2.2
1557 // Creator: Chiru Labs
1558 
1559 pragma solidity ^0.8.4;
1560 
1561 
1562 
1563 /**
1564  * @title ERC721AQueryable.
1565  *
1566  * @dev ERC721A subclass with convenience query functions.
1567  */
1568 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1569     /**
1570      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1571      *
1572      * If the `tokenId` is out of bounds:
1573      *
1574      * - `addr = address(0)`
1575      * - `startTimestamp = 0`
1576      * - `burned = false`
1577      * - `extraData = 0`
1578      *
1579      * If the `tokenId` is burned:
1580      *
1581      * - `addr = <Address of owner before token was burned>`
1582      * - `startTimestamp = <Timestamp when token was burned>`
1583      * - `burned = true`
1584      * - `extraData = <Extra data when token was burned>`
1585      *
1586      * Otherwise:
1587      *
1588      * - `addr = <Address of owner>`
1589      * - `startTimestamp = <Timestamp of start of ownership>`
1590      * - `burned = false`
1591      * - `extraData = <Extra data at start of ownership>`
1592      */
1593     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1594         TokenOwnership memory ownership;
1595         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1596             return ownership;
1597         }
1598         ownership = _ownershipAt(tokenId);
1599         if (ownership.burned) {
1600             return ownership;
1601         }
1602         return _ownershipOf(tokenId);
1603     }
1604 
1605     /**
1606      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1607      * See {ERC721AQueryable-explicitOwnershipOf}
1608      */
1609     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1610         external
1611         view
1612         virtual
1613         override
1614         returns (TokenOwnership[] memory)
1615     {
1616         unchecked {
1617             uint256 tokenIdsLength = tokenIds.length;
1618             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1619             for (uint256 i; i != tokenIdsLength; ++i) {
1620                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1621             }
1622             return ownerships;
1623         }
1624     }
1625 
1626     /**
1627      * @dev Returns an array of token IDs owned by `owner`,
1628      * in the range [`start`, `stop`)
1629      * (i.e. `start <= tokenId < stop`).
1630      *
1631      * This function allows for tokens to be queried if the collection
1632      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1633      *
1634      * Requirements:
1635      *
1636      * - `start < stop`
1637      */
1638     function tokensOfOwnerIn(
1639         address owner,
1640         uint256 start,
1641         uint256 stop
1642     ) external view virtual override returns (uint256[] memory) {
1643         unchecked {
1644             if (start >= stop) revert InvalidQueryRange();
1645             uint256 tokenIdsIdx;
1646             uint256 stopLimit = _nextTokenId();
1647             // Set `start = max(start, _startTokenId())`.
1648             if (start < _startTokenId()) {
1649                 start = _startTokenId();
1650             }
1651             // Set `stop = min(stop, stopLimit)`.
1652             if (stop > stopLimit) {
1653                 stop = stopLimit;
1654             }
1655             uint256 tokenIdsMaxLength = balanceOf(owner);
1656             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1657             // to cater for cases where `balanceOf(owner)` is too big.
1658             if (start < stop) {
1659                 uint256 rangeLength = stop - start;
1660                 if (rangeLength < tokenIdsMaxLength) {
1661                     tokenIdsMaxLength = rangeLength;
1662                 }
1663             } else {
1664                 tokenIdsMaxLength = 0;
1665             }
1666             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1667             if (tokenIdsMaxLength == 0) {
1668                 return tokenIds;
1669             }
1670             // We need to call `explicitOwnershipOf(start)`,
1671             // because the slot at `start` may not be initialized.
1672             TokenOwnership memory ownership = explicitOwnershipOf(start);
1673             address currOwnershipAddr;
1674             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1675             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1676             if (!ownership.burned) {
1677                 currOwnershipAddr = ownership.addr;
1678             }
1679             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1680                 ownership = _ownershipAt(i);
1681                 if (ownership.burned) {
1682                     continue;
1683                 }
1684                 if (ownership.addr != address(0)) {
1685                     currOwnershipAddr = ownership.addr;
1686                 }
1687                 if (currOwnershipAddr == owner) {
1688                     tokenIds[tokenIdsIdx++] = i;
1689                 }
1690             }
1691             // Downsize the array to fit.
1692             assembly {
1693                 mstore(tokenIds, tokenIdsIdx)
1694             }
1695             return tokenIds;
1696         }
1697     }
1698 
1699     /**
1700      * @dev Returns an array of token IDs owned by `owner`.
1701      *
1702      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1703      * It is meant to be called off-chain.
1704      *
1705      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1706      * multiple smaller scans if the collection is large enough to cause
1707      * an out-of-gas error (10K collections should be fine).
1708      */
1709     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1710         unchecked {
1711             uint256 tokenIdsIdx;
1712             address currOwnershipAddr;
1713             uint256 tokenIdsLength = balanceOf(owner);
1714             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1715             TokenOwnership memory ownership;
1716             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1717                 ownership = _ownershipAt(i);
1718                 if (ownership.burned) {
1719                     continue;
1720                 }
1721                 if (ownership.addr != address(0)) {
1722                     currOwnershipAddr = ownership.addr;
1723                 }
1724                 if (currOwnershipAddr == owner) {
1725                     tokenIds[tokenIdsIdx++] = i;
1726                 }
1727             }
1728             return tokenIds;
1729         }
1730     }
1731 }
1732 
1733 // File: @openzeppelin/contracts/utils/Context.sol
1734 
1735 
1736 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1737 
1738 pragma solidity ^0.8.0;
1739 
1740 /**
1741  * @dev Provides information about the current execution context, including the
1742  * sender of the transaction and its data. While these are generally available
1743  * via msg.sender and msg.data, they should not be accessed in such a direct
1744  * manner, since when dealing with meta-transactions the account sending and
1745  * paying for execution may not be the actual sender (as far as an application
1746  * is concerned).
1747  *
1748  * This contract is only required for intermediate, library-like contracts.
1749  */
1750 abstract contract Context {
1751     function _msgSender() internal view virtual returns (address) {
1752         return msg.sender;
1753     }
1754 
1755     function _msgData() internal view virtual returns (bytes calldata) {
1756         return msg.data;
1757     }
1758 }
1759 
1760 // File: @openzeppelin/contracts/access/Ownable.sol
1761 
1762 
1763 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1764 
1765 pragma solidity ^0.8.0;
1766 
1767 
1768 /**
1769  * @dev Contract module which provides a basic access control mechanism, where
1770  * there is an account (an owner) that can be granted exclusive access to
1771  * specific functions.
1772  *
1773  * By default, the owner account will be the one that deploys the contract. This
1774  * can later be changed with {transferOwnership}.
1775  *
1776  * This module is used through inheritance. It will make available the modifier
1777  * `onlyOwner`, which can be applied to your functions to restrict their use to
1778  * the owner.
1779  */
1780 abstract contract Ownable is Context {
1781     address private _owner;
1782 
1783     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1784 
1785     /**
1786      * @dev Initializes the contract setting the deployer as the initial owner.
1787      */
1788     constructor() {
1789         _transferOwnership(_msgSender());
1790     }
1791 
1792     /**
1793      * @dev Throws if called by any account other than the owner.
1794      */
1795     modifier onlyOwner() {
1796         _checkOwner();
1797         _;
1798     }
1799 
1800     /**
1801      * @dev Returns the address of the current owner.
1802      */
1803     function owner() public view virtual returns (address) {
1804         return _owner;
1805     }
1806 
1807     /**
1808      * @dev Throws if the sender is not the owner.
1809      */
1810     function _checkOwner() internal view virtual {
1811         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1812     }
1813 
1814     /**
1815      * @dev Leaves the contract without owner. It will not be possible to call
1816      * `onlyOwner` functions anymore. Can only be called by the current owner.
1817      *
1818      * NOTE: Renouncing ownership will leave the contract without an owner,
1819      * thereby removing any functionality that is only available to the owner.
1820      */
1821     function renounceOwnership() public virtual onlyOwner {
1822         _transferOwnership(address(0));
1823     }
1824 
1825     /**
1826      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1827      * Can only be called by the current owner.
1828      */
1829     function transferOwnership(address newOwner) public virtual onlyOwner {
1830         require(newOwner != address(0), "Ownable: new owner is the zero address");
1831         _transferOwnership(newOwner);
1832     }
1833 
1834     /**
1835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1836      * Internal function without access restriction.
1837      */
1838     function _transferOwnership(address newOwner) internal virtual {
1839         address oldOwner = _owner;
1840         _owner = newOwner;
1841         emit OwnershipTransferred(oldOwner, newOwner);
1842     }
1843 }
1844 
1845 // File: contracts/TemperRhythm.sol
1846 
1847 
1848 
1849 pragma solidity ^0.8.4;
1850 
1851 
1852 
1853 
1854 contract TemperRhythm is ERC721AQueryable, Ownable {
1855   using Strings for uint256;
1856   uint256 public EXTRA_MINT_PRICE = 0.003 ether;
1857   uint256 public MAX_SUPPLY = 999;
1858   uint256 public MAX_PER = 10;
1859 
1860   string uriPrefix = "";
1861 
1862   bool public paused = true;
1863 
1864   mapping(address => uint256) private _freeMintedCount;
1865 
1866   constructor() ERC721A("Temper Rhythm by Tarcosa", "TR") {}
1867 
1868   function mint(uint256 _mintAmount) external payable {
1869       require(!paused, "Minting Paused");
1870 
1871       uint256 _totalSupply = totalSupply();
1872 
1873       require(_totalSupply + _mintAmount < MAX_SUPPLY + 1, "SOLD OUT");
1874       require(_mintAmount < MAX_PER + 1, "Max Per Transaction Is 10");
1875 
1876       uint256 payForCount = _mintAmount;
1877       uint256 freeMintCount = _freeMintedCount[msg.sender];
1878 
1879       if (freeMintCount < 1) {
1880         if (_mintAmount > 1) {
1881           payForCount = _mintAmount - 1;
1882         } else {
1883           payForCount = 0;
1884         }
1885 
1886         _freeMintedCount[msg.sender] = 1;
1887       }
1888 
1889       require(
1890         msg.value >= payForCount * EXTRA_MINT_PRICE,
1891         "INCORRECT ETH AMOUNT"
1892       );
1893 
1894       _mint(msg.sender, _mintAmount);
1895     
1896   }
1897   
1898   function devMint(uint256 _mintAmount, address _receiver) public onlyOwner {
1899     _safeMint(_receiver, _mintAmount);
1900   }
1901 
1902   function freeMintedCount(address owner) external view returns (uint256) {
1903     return _freeMintedCount[owner];
1904   }
1905 
1906   function _startTokenId() internal pure override returns (uint256) {
1907     return 1;
1908   }
1909   
1910   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1911     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1912 
1913 
1914     string memory currentBaseURI = _baseURI();
1915     return bytes(currentBaseURI).length > 0
1916         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1917         : '';
1918   }
1919 
1920   function _baseURI() internal view virtual override returns (string memory) {
1921     return uriPrefix;
1922   }
1923 
1924   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1925     uriPrefix = _uriPrefix;
1926   }
1927 
1928   function setPaused(bool _state) public onlyOwner {
1929     paused = _state;
1930   }
1931 
1932   function withdraw() public onlyOwner {
1933     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1934     require(os);
1935   }
1936 }