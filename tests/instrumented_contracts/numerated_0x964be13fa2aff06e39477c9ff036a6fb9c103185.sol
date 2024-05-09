1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
79      */
80     function toString(uint256 value) internal pure returns (string memory) {
81         // Inspired by OraclizeAPI's implementation - MIT licence
82         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
83 
84         if (value == 0) {
85             return "0";
86         }
87         uint256 temp = value;
88         uint256 digits;
89         while (temp != 0) {
90             digits++;
91             temp /= 10;
92         }
93         bytes memory buffer = new bytes(digits);
94         while (value != 0) {
95             digits -= 1;
96             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
97             value /= 10;
98         }
99         return string(buffer);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
104      */
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
120      */
121     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
122         bytes memory buffer = new bytes(2 * length + 2);
123         buffer[0] = "0";
124         buffer[1] = "x";
125         for (uint256 i = 2 * length + 1; i > 1; --i) {
126             buffer[i] = _HEX_SYMBOLS[value & 0xf];
127             value >>= 4;
128         }
129         require(value == 0, "Strings: hex length insufficient");
130         return string(buffer);
131     }
132 }
133 
134 // File: contracts/IERC721A.sol
135 
136 
137 // ERC721A Contracts v4.2.2
138 // Creator: Chiru Labs
139 
140 pragma solidity ^0.8.4;
141 
142 /**
143  * @dev Interface of ERC721A.
144  */
145 interface IERC721A {
146     /**
147      * The caller must own the token or be an approved operator.
148      */
149     error ApprovalCallerNotOwnerNorApproved();
150 
151     /**
152      * The token does not exist.
153      */
154     error ApprovalQueryForNonexistentToken();
155 
156     /**
157      * Cannot query the balance for the zero address.
158      */
159     error BalanceQueryForZeroAddress();
160 
161     /**
162      * Cannot mint to the zero address.
163      */
164     error MintToZeroAddress();
165 
166     /**
167      * The quantity of tokens minted must be more than zero.
168      */
169     error MintZeroQuantity();
170 
171     /**
172      * The token does not exist.
173      */
174     error OwnerQueryForNonexistentToken();
175 
176     /**
177      * The caller must own the token or be an approved operator.
178      */
179     error TransferCallerNotOwnerNorApproved();
180 
181     /**
182      * The token must be owned by `from`.
183      */
184     error TransferFromIncorrectOwner();
185 
186     /**
187      * Cannot safely transfer to a contract that does not implement the
188      * ERC721Receiver interface.
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
212     // =============================================================
213     //                            STRUCTS
214     // =============================================================
215 
216     struct TokenOwnership {
217         // The address of the owner.
218         address addr;
219         // Stores the start time of ownership with minimal overhead for tokenomics.
220         uint64 startTimestamp;
221         // Whether the token has been burned.
222         bool burned;
223         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
224         uint24 extraData;
225     }
226 
227     // =============================================================
228     //                         TOKEN COUNTERS
229     // =============================================================
230 
231     /**
232      * @dev Returns the total number of tokens in existence.
233      * Burned tokens will reduce the count.
234      * To get the total number of tokens minted, please see {_totalMinted}.
235      */
236     function totalSupply() external view returns (uint256);
237 
238     // =============================================================
239     //                            IERC165
240     // =============================================================
241 
242     /**
243      * @dev Returns true if this contract implements the interface defined by
244      * `interfaceId`. See the corresponding
245      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
246      * to learn more about how these ids are created.
247      *
248      * This function call must use less than 30000 gas.
249      */
250     function supportsInterface(bytes4 interfaceId) external view returns (bool);
251 
252     // =============================================================
253     //                            IERC721
254     // =============================================================
255 
256     /**
257      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
258      */
259     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
260 
261     /**
262      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
263      */
264     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
265 
266     /**
267      * @dev Emitted when `owner` enables or disables
268      * (`approved`) `operator` to manage all of its assets.
269      */
270     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
271 
272     /**
273      * @dev Returns the number of tokens in `owner`'s account.
274      */
275     function balanceOf(address owner) external view returns (uint256 balance);
276 
277     /**
278      * @dev Returns the owner of the `tokenId` token.
279      *
280      * Requirements:
281      *
282      * - `tokenId` must exist.
283      */
284     function ownerOf(uint256 tokenId) external view returns (address owner);
285 
286     /**
287      * @dev Safely transfers `tokenId` token from `from` to `to`,
288      * checking first that contract recipients are aware of the ERC721 protocol
289      * to prevent tokens from being forever locked.
290      *
291      * Requirements:
292      *
293      * - `from` cannot be the zero address.
294      * - `to` cannot be the zero address.
295      * - `tokenId` token must exist and be owned by `from`.
296      * - If the caller is not `from`, it must be have been allowed to move
297      * this token by either {approve} or {setApprovalForAll}.
298      * - If `to` refers to a smart contract, it must implement
299      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
300      *
301      * Emits a {Transfer} event.
302      */
303     function safeTransferFrom(
304         address from,
305         address to,
306         uint256 tokenId,
307         bytes calldata data
308     ) external;
309 
310     /**
311      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
312      */
313     function safeTransferFrom(
314         address from,
315         address to,
316         uint256 tokenId
317     ) external;
318 
319     /**
320      * @dev Transfers `tokenId` from `from` to `to`.
321      *
322      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
323      * whenever possible.
324      *
325      * Requirements:
326      *
327      * - `from` cannot be the zero address.
328      * - `to` cannot be the zero address.
329      * - `tokenId` token must be owned by `from`.
330      * - If the caller is not `from`, it must be approved to move this token
331      * by either {approve} or {setApprovalForAll}.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transferFrom(
336         address from,
337         address to,
338         uint256 tokenId
339     ) external;
340 
341     /**
342      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
343      * The approval is cleared when the token is transferred.
344      *
345      * Only a single account can be approved at a time, so approving the
346      * zero address clears previous approvals.
347      *
348      * Requirements:
349      *
350      * - The caller must own the token or be an approved operator.
351      * - `tokenId` must exist.
352      *
353      * Emits an {Approval} event.
354      */
355     function approve(address to, uint256 tokenId) external;
356 
357     /**
358      * @dev Approve or remove `operator` as an operator for the caller.
359      * Operators can call {transferFrom} or {safeTransferFrom}
360      * for any token owned by the caller.
361      *
362      * Requirements:
363      *
364      * - The `operator` cannot be the caller.
365      *
366      * Emits an {ApprovalForAll} event.
367      */
368     function setApprovalForAll(address operator, bool _approved) external;
369 
370     /**
371      * @dev Returns the account approved for `tokenId` token.
372      *
373      * Requirements:
374      *
375      * - `tokenId` must exist.
376      */
377     function getApproved(uint256 tokenId) external view returns (address operator);
378 
379     /**
380      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
381      *
382      * See {setApprovalForAll}.
383      */
384     function isApprovedForAll(address owner, address operator) external view returns (bool);
385 
386     // =============================================================
387     //                        IERC721Metadata
388     // =============================================================
389 
390     /**
391      * @dev Returns the token collection name.
392      */
393     function name() external view returns (string memory);
394 
395     /**
396      * @dev Returns the token collection symbol.
397      */
398     function symbol() external view returns (string memory);
399 
400     /**
401      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
402      */
403     function tokenURI(uint256 tokenId) external view returns (string memory);
404 
405     // =============================================================
406     //                           IERC2309
407     // =============================================================
408 
409     /**
410      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
411      * (inclusive) is transferred from `from` to `to`, as defined in the
412      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
413      *
414      * See {_mintERC2309} for more details.
415      */
416     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
417 }
418 // File: contracts/ERC721A.sol
419 
420 
421 // ERC721A Contracts v4.2.2
422 // Creator: Chiru Labs
423 
424 pragma solidity ^0.8.4;
425 
426 
427 /**
428  * @dev Interface of ERC721 token receiver.
429  */
430 interface ERC721A__IERC721Receiver {
431     function onERC721Received(
432         address operator,
433         address from,
434         uint256 tokenId,
435         bytes calldata data
436     ) external returns (bytes4);
437 }
438 
439 /**
440  * @title ERC721A
441  *
442  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
443  * Non-Fungible Token Standard, including the Metadata extension.
444  * Optimized for lower gas during batch mints.
445  *
446  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
447  * starting from `_startTokenId()`.
448  *
449  * Assumptions:
450  *
451  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
452  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
453  */
454 contract ERC721A is IERC721A {
455     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
456     struct TokenApprovalRef {
457         address value;
458     }
459 
460     // =============================================================
461     //                           CONSTANTS
462     // =============================================================
463 
464     // Mask of an entry in packed address data.
465     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
466 
467     // The bit position of `numberMinted` in packed address data.
468     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
469 
470     // The bit position of `numberBurned` in packed address data.
471     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
472 
473     // The bit position of `aux` in packed address data.
474     uint256 private constant _BITPOS_AUX = 192;
475 
476     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
477     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
478 
479     // The bit position of `startTimestamp` in packed ownership.
480     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
481 
482     // The bit mask of the `burned` bit in packed ownership.
483     uint256 private constant _BITMASK_BURNED = 1 << 224;
484 
485     // The bit position of the `nextInitialized` bit in packed ownership.
486     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
487 
488     // The bit mask of the `nextInitialized` bit in packed ownership.
489     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
490 
491     // The bit position of `extraData` in packed ownership.
492     uint256 private constant _BITPOS_EXTRA_DATA = 232;
493 
494     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
495     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
496 
497     // The mask of the lower 160 bits for addresses.
498     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
499 
500     // The maximum `quantity` that can be minted with {_mintERC2309}.
501     // This limit is to prevent overflows on the address data entries.
502     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
503     // is required to cause an overflow, which is unrealistic.
504     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
505 
506     // The `Transfer` event signature is given by:
507     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
508     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
509         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
510 
511     // =============================================================
512     //                            STORAGE
513     // =============================================================
514 
515     // The next token ID to be minted.
516     uint256 private _currentIndex;
517 
518     // The number of tokens burned.
519     uint256 private _burnCounter;
520 
521     // Token name
522     string private _name;
523 
524     // Token symbol
525     string private _symbol;
526 
527     // Mapping from token ID to ownership details
528     // An empty struct value does not necessarily mean the token is unowned.
529     // See {_packedOwnershipOf} implementation for details.
530     //
531     // Bits Layout:
532     // - [0..159]   `addr`
533     // - [160..223] `startTimestamp`
534     // - [224]      `burned`
535     // - [225]      `nextInitialized`
536     // - [232..255] `extraData`
537     mapping(uint256 => uint256) private _packedOwnerships;
538 
539     // Mapping owner address to address data.
540     //
541     // Bits Layout:
542     // - [0..63]    `balance`
543     // - [64..127]  `numberMinted`
544     // - [128..191] `numberBurned`
545     // - [192..255] `aux`
546     mapping(address => uint256) private _packedAddressData;
547 
548     // Mapping from token ID to approved address.
549     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
550 
551     // Mapping from owner to operator approvals
552     mapping(address => mapping(address => bool)) private _operatorApprovals;
553 
554     // =============================================================
555     //                          CONSTRUCTOR
556     // =============================================================
557 
558     constructor(string memory name_, string memory symbol_) {
559         _name = name_;
560         _symbol = symbol_;
561         _currentIndex = _startTokenId();
562     }
563 
564     // =============================================================
565     //                   TOKEN COUNTING OPERATIONS
566     // =============================================================
567 
568     /**
569      * @dev Returns the starting token ID.
570      * To change the starting token ID, please override this function.
571      */
572     function _startTokenId() internal view virtual returns (uint256) {
573         return 0;
574     }
575 
576     /**
577      * @dev Returns the next token ID to be minted.
578      */
579     function _nextTokenId() internal view virtual returns (uint256) {
580         return _currentIndex;
581     }
582 
583     /**
584      * @dev Returns the total number of tokens in existence.
585      * Burned tokens will reduce the count.
586      * To get the total number of tokens minted, please see {_totalMinted}.
587      */
588     function totalSupply() public view virtual override returns (uint256) {
589         // Counter underflow is impossible as _burnCounter cannot be incremented
590         // more than `_currentIndex - _startTokenId()` times.
591         unchecked {
592             return _currentIndex - _burnCounter - _startTokenId();
593         }
594     }
595 
596     /**
597      * @dev Returns the total amount of tokens minted in the contract.
598      */
599     function _totalMinted() internal view virtual returns (uint256) {
600         // Counter underflow is impossible as `_currentIndex` does not decrement,
601         // and it is initialized to `_startTokenId()`.
602         unchecked {
603             return _currentIndex - _startTokenId();
604         }
605     }
606 
607     /**
608      * @dev Returns the total number of tokens burned.
609      */
610     function _totalBurned() internal view virtual returns (uint256) {
611         return _burnCounter;
612     }
613 
614     // =============================================================
615     //                    ADDRESS DATA OPERATIONS
616     // =============================================================
617 
618     /**
619      * @dev Returns the number of tokens in `owner`'s account.
620      */
621     function balanceOf(address owner) public view virtual override returns (uint256) {
622         if (owner == address(0)) revert BalanceQueryForZeroAddress();
623         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
624     }
625 
626     /**
627      * Returns the number of tokens minted by `owner`.
628      */
629     function _numberMinted(address owner) internal view returns (uint256) {
630         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
631     }
632 
633     /**
634      * Returns the number of tokens burned by or on behalf of `owner`.
635      */
636     function _numberBurned(address owner) internal view returns (uint256) {
637         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
638     }
639 
640     /**
641      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
642      */
643     function _getAux(address owner) internal view returns (uint64) {
644         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
645     }
646 
647     /**
648      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
649      * If there are multiple variables, please pack them into a uint64.
650      */
651     function _setAux(address owner, uint64 aux) internal virtual {
652         uint256 packed = _packedAddressData[owner];
653         uint256 auxCasted;
654         // Cast `aux` with assembly to avoid redundant masking.
655         assembly {
656             auxCasted := aux
657         }
658         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
659         _packedAddressData[owner] = packed;
660     }
661 
662     // =============================================================
663     //                            IERC165
664     // =============================================================
665 
666     /**
667      * @dev Returns true if this contract implements the interface defined by
668      * `interfaceId`. See the corresponding
669      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
670      * to learn more about how these ids are created.
671      *
672      * This function call must use less than 30000 gas.
673      */
674     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
675         // The interface IDs are constants representing the first 4 bytes
676         // of the XOR of all function selectors in the interface.
677         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
678         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
679         return
680             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
681             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
682             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
683     }
684 
685     // =============================================================
686     //                        IERC721Metadata
687     // =============================================================
688 
689     /**
690      * @dev Returns the token collection name.
691      */
692     function name() public view virtual override returns (string memory) {
693         return _name;
694     }
695 
696     /**
697      * @dev Returns the token collection symbol.
698      */
699     function symbol() public view virtual override returns (string memory) {
700         return _symbol;
701     }
702 
703     /**
704      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
705      */
706     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
707         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
708 
709         string memory baseURI = _baseURI();
710         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
711     }
712 
713     /**
714      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
715      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
716      * by default, it can be overridden in child contracts.
717      */
718     function _baseURI() internal view virtual returns (string memory) {
719         return '';
720     }
721 
722     // =============================================================
723     //                     OWNERSHIPS OPERATIONS
724     // =============================================================
725 
726     /**
727      * @dev Returns the owner of the `tokenId` token.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
734         return address(uint160(_packedOwnershipOf(tokenId)));
735     }
736 
737     /**
738      * @dev Gas spent here starts off proportional to the maximum mint batch size.
739      * It gradually moves to O(1) as tokens get transferred around over time.
740      */
741     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
742         return _unpackedOwnership(_packedOwnershipOf(tokenId));
743     }
744 
745     /**
746      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
747      */
748     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
749         return _unpackedOwnership(_packedOwnerships[index]);
750     }
751 
752     /**
753      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
754      */
755     function _initializeOwnershipAt(uint256 index) internal virtual {
756         if (_packedOwnerships[index] == 0) {
757             _packedOwnerships[index] = _packedOwnershipOf(index);
758         }
759     }
760 
761     /**
762      * Returns the packed ownership data of `tokenId`.
763      */
764     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
765         uint256 curr = tokenId;
766 
767         unchecked {
768             if (_startTokenId() <= curr)
769                 if (curr < _currentIndex) {
770                     uint256 packed = _packedOwnerships[curr];
771                     // If not burned.
772                     if (packed & _BITMASK_BURNED == 0) {
773                         // Invariant:
774                         // There will always be an initialized ownership slot
775                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
776                         // before an unintialized ownership slot
777                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
778                         // Hence, `curr` will not underflow.
779                         //
780                         // We can directly compare the packed value.
781                         // If the address is zero, packed will be zero.
782                         while (packed == 0) {
783                             packed = _packedOwnerships[--curr];
784                         }
785                         return packed;
786                     }
787                 }
788         }
789         revert OwnerQueryForNonexistentToken();
790     }
791 
792     /**
793      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
794      */
795     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
796         ownership.addr = address(uint160(packed));
797         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
798         ownership.burned = packed & _BITMASK_BURNED != 0;
799         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
800     }
801 
802     /**
803      * @dev Packs ownership data into a single uint256.
804      */
805     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
806         assembly {
807             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
808             owner := and(owner, _BITMASK_ADDRESS)
809             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
810             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
811         }
812     }
813 
814     /**
815      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
816      */
817     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
818         // For branchless setting of the `nextInitialized` flag.
819         assembly {
820             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
821             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
822         }
823     }
824 
825     // =============================================================
826     //                      APPROVAL OPERATIONS
827     // =============================================================
828 
829     /**
830      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
831      * The approval is cleared when the token is transferred.
832      *
833      * Only a single account can be approved at a time, so approving the
834      * zero address clears previous approvals.
835      *
836      * Requirements:
837      *
838      * - The caller must own the token or be an approved operator.
839      * - `tokenId` must exist.
840      *
841      * Emits an {Approval} event.
842      */
843     function approve(address to, uint256 tokenId) public virtual override {
844         address owner = ownerOf(tokenId);
845 
846         if (_msgSenderERC721A() != owner)
847             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
848                 revert ApprovalCallerNotOwnerNorApproved();
849             }
850 
851         _tokenApprovals[tokenId].value = to;
852         emit Approval(owner, to, tokenId);
853     }
854 
855     /**
856      * @dev Returns the account approved for `tokenId` token.
857      *
858      * Requirements:
859      *
860      * - `tokenId` must exist.
861      */
862     function getApproved(uint256 tokenId) public view virtual override returns (address) {
863         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
864 
865         return _tokenApprovals[tokenId].value;
866     }
867 
868     /**
869      * @dev Approve or remove `operator` as an operator for the caller.
870      * Operators can call {transferFrom} or {safeTransferFrom}
871      * for any token owned by the caller.
872      *
873      * Requirements:
874      *
875      * - The `operator` cannot be the caller.
876      *
877      * Emits an {ApprovalForAll} event.
878      */
879     function setApprovalForAll(address operator, bool approved) public virtual override {
880         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
881         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
882     }
883 
884     /**
885      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
886      *
887      * See {setApprovalForAll}.
888      */
889     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
890         return _operatorApprovals[owner][operator];
891     }
892 
893     /**
894      * @dev Returns whether `tokenId` exists.
895      *
896      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
897      *
898      * Tokens start existing when they are minted. See {_mint}.
899      */
900     function _exists(uint256 tokenId) internal view virtual returns (bool) {
901         return
902             _startTokenId() <= tokenId &&
903             tokenId < _currentIndex && // If within bounds,
904             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
905     }
906 
907     /**
908      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
909      */
910     function _isSenderApprovedOrOwner(
911         address approvedAddress,
912         address owner,
913         address msgSender
914     ) private pure returns (bool result) {
915         assembly {
916             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
917             owner := and(owner, _BITMASK_ADDRESS)
918             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
919             msgSender := and(msgSender, _BITMASK_ADDRESS)
920             // `msgSender == owner || msgSender == approvedAddress`.
921             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
922         }
923     }
924 
925     /**
926      * @dev Returns the storage slot and value for the approved address of `tokenId`.
927      */
928     function _getApprovedSlotAndAddress(uint256 tokenId)
929         private
930         view
931         returns (uint256 approvedAddressSlot, address approvedAddress)
932     {
933         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
934         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
935         assembly {
936             approvedAddressSlot := tokenApproval.slot
937             approvedAddress := sload(approvedAddressSlot)
938         }
939     }
940 
941     // =============================================================
942     //                      TRANSFER OPERATIONS
943     // =============================================================
944 
945     /**
946      * @dev Transfers `tokenId` from `from` to `to`.
947      *
948      * Requirements:
949      *
950      * - `from` cannot be the zero address.
951      * - `to` cannot be the zero address.
952      * - `tokenId` token must be owned by `from`.
953      * - If the caller is not `from`, it must be approved to move this token
954      * by either {approve} or {setApprovalForAll}.
955      *
956      * Emits a {Transfer} event.
957      */
958     function transferFrom(
959         address from,
960         address to,
961         uint256 tokenId
962     ) public virtual override {
963         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
964 
965         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
966 
967         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
968 
969         // The nested ifs save around 20+ gas over a compound boolean condition.
970         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
971             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
972 
973         if (to == address(0)) revert TransferToZeroAddress();
974 
975         _beforeTokenTransfers(from, to, tokenId, 1);
976 
977         // Clear approvals from the previous owner.
978         assembly {
979             if approvedAddress {
980                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
981                 sstore(approvedAddressSlot, 0)
982             }
983         }
984 
985         // Underflow of the sender's balance is impossible because we check for
986         // ownership above and the recipient's balance can't realistically overflow.
987         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
988         unchecked {
989             // We can directly increment and decrement the balances.
990             --_packedAddressData[from]; // Updates: `balance -= 1`.
991             ++_packedAddressData[to]; // Updates: `balance += 1`.
992 
993             // Updates:
994             // - `address` to the next owner.
995             // - `startTimestamp` to the timestamp of transfering.
996             // - `burned` to `false`.
997             // - `nextInitialized` to `true`.
998             _packedOwnerships[tokenId] = _packOwnershipData(
999                 to,
1000                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1001             );
1002 
1003             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1004             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1005                 uint256 nextTokenId = tokenId + 1;
1006                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1007                 if (_packedOwnerships[nextTokenId] == 0) {
1008                     // If the next slot is within bounds.
1009                     if (nextTokenId != _currentIndex) {
1010                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1011                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1012                     }
1013                 }
1014             }
1015         }
1016 
1017         emit Transfer(from, to, tokenId);
1018         _afterTokenTransfers(from, to, tokenId, 1);
1019     }
1020 
1021     /**
1022      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         safeTransferFrom(from, to, tokenId, '');
1030     }
1031 
1032     /**
1033      * @dev Safely transfers `tokenId` token from `from` to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - `from` cannot be the zero address.
1038      * - `to` cannot be the zero address.
1039      * - `tokenId` token must exist and be owned by `from`.
1040      * - If the caller is not `from`, it must be approved to move this token
1041      * by either {approve} or {setApprovalForAll}.
1042      * - If `to` refers to a smart contract, it must implement
1043      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) public virtual override {
1053         transferFrom(from, to, tokenId);
1054         if (to.code.length != 0)
1055             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1056                 revert TransferToNonERC721ReceiverImplementer();
1057             }
1058     }
1059 
1060     /**
1061      * @dev Hook that is called before a set of serially-ordered token IDs
1062      * are about to be transferred. This includes minting.
1063      * And also called before burning one token.
1064      *
1065      * `startTokenId` - the first token ID to be transferred.
1066      * `quantity` - the amount to be transferred.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      * - When `to` is zero, `tokenId` will be burned by `from`.
1074      * - `from` and `to` are never both zero.
1075      */
1076     function _beforeTokenTransfers(
1077         address from,
1078         address to,
1079         uint256 startTokenId,
1080         uint256 quantity
1081     ) internal virtual {}
1082 
1083     /**
1084      * @dev Hook that is called after a set of serially-ordered token IDs
1085      * have been transferred. This includes minting.
1086      * And also called after one token has been burned.
1087      *
1088      * `startTokenId` - the first token ID to be transferred.
1089      * `quantity` - the amount to be transferred.
1090      *
1091      * Calling conditions:
1092      *
1093      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1094      * transferred to `to`.
1095      * - When `from` is zero, `tokenId` has been minted for `to`.
1096      * - When `to` is zero, `tokenId` has been burned by `from`.
1097      * - `from` and `to` are never both zero.
1098      */
1099     function _afterTokenTransfers(
1100         address from,
1101         address to,
1102         uint256 startTokenId,
1103         uint256 quantity
1104     ) internal virtual {}
1105 
1106     /**
1107      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1108      *
1109      * `from` - Previous owner of the given token ID.
1110      * `to` - Target address that will receive the token.
1111      * `tokenId` - Token ID to be transferred.
1112      * `_data` - Optional data to send along with the call.
1113      *
1114      * Returns whether the call correctly returned the expected magic value.
1115      */
1116     function _checkContractOnERC721Received(
1117         address from,
1118         address to,
1119         uint256 tokenId,
1120         bytes memory _data
1121     ) private returns (bool) {
1122         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1123             bytes4 retval
1124         ) {
1125             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1126         } catch (bytes memory reason) {
1127             if (reason.length == 0) {
1128                 revert TransferToNonERC721ReceiverImplementer();
1129             } else {
1130                 assembly {
1131                     revert(add(32, reason), mload(reason))
1132                 }
1133             }
1134         }
1135     }
1136 
1137     // =============================================================
1138     //                        MINT OPERATIONS
1139     // =============================================================
1140 
1141     /**
1142      * @dev Mints `quantity` tokens and transfers them to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - `to` cannot be the zero address.
1147      * - `quantity` must be greater than 0.
1148      *
1149      * Emits a {Transfer} event for each mint.
1150      */
1151     function _mint(address to, uint256 quantity) internal virtual {
1152         uint256 startTokenId = _currentIndex;
1153         if (quantity == 0) revert MintZeroQuantity();
1154 
1155         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1156 
1157         // Overflows are incredibly unrealistic.
1158         // `balance` and `numberMinted` have a maximum limit of 2**64.
1159         // `tokenId` has a maximum limit of 2**256.
1160         unchecked {
1161             // Updates:
1162             // - `balance += quantity`.
1163             // - `numberMinted += quantity`.
1164             //
1165             // We can directly add to the `balance` and `numberMinted`.
1166             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1167 
1168             // Updates:
1169             // - `address` to the owner.
1170             // - `startTimestamp` to the timestamp of minting.
1171             // - `burned` to `false`.
1172             // - `nextInitialized` to `quantity == 1`.
1173             _packedOwnerships[startTokenId] = _packOwnershipData(
1174                 to,
1175                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1176             );
1177 
1178             uint256 toMasked;
1179             uint256 end = startTokenId + quantity;
1180 
1181             // Use assembly to loop and emit the `Transfer` event for gas savings.
1182             // The duplicated `log4` removes an extra check and reduces stack juggling.
1183             // The assembly, together with the surrounding Solidity code, have been
1184             // delicately arranged to nudge the compiler into producing optimized opcodes.
1185             assembly {
1186                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1187                 toMasked := and(to, _BITMASK_ADDRESS)
1188                 // Emit the `Transfer` event.
1189                 log4(
1190                     0, // Start of data (0, since no data).
1191                     0, // End of data (0, since no data).
1192                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1193                     0, // `address(0)`.
1194                     toMasked, // `to`.
1195                     startTokenId // `tokenId`.
1196                 )
1197 
1198                 for {
1199                     let tokenId := add(startTokenId, 1)
1200                 } iszero(eq(tokenId, end)) {
1201                     tokenId := add(tokenId, 1)
1202                 } {
1203                     // Emit the `Transfer` event. Similar to above.
1204                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1205                 }
1206             }
1207             if (toMasked == 0) revert MintToZeroAddress();
1208 
1209             _currentIndex = end;
1210         }
1211         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1212     }
1213 
1214     /**
1215      * @dev Mints `quantity` tokens and transfers them to `to`.
1216      *
1217      * This function is intended for efficient minting only during contract creation.
1218      *
1219      * It emits only one {ConsecutiveTransfer} as defined in
1220      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1221      * instead of a sequence of {Transfer} event(s).
1222      *
1223      * Calling this function outside of contract creation WILL make your contract
1224      * non-compliant with the ERC721 standard.
1225      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1226      * {ConsecutiveTransfer} event is only permissible during contract creation.
1227      *
1228      * Requirements:
1229      *
1230      * - `to` cannot be the zero address.
1231      * - `quantity` must be greater than 0.
1232      *
1233      * Emits a {ConsecutiveTransfer} event.
1234      */
1235     function _mintERC2309(address to, uint256 quantity) internal virtual {
1236         uint256 startTokenId = _currentIndex;
1237         if (to == address(0)) revert MintToZeroAddress();
1238         if (quantity == 0) revert MintZeroQuantity();
1239         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1240 
1241         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1242 
1243         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1244         unchecked {
1245             // Updates:
1246             // - `balance += quantity`.
1247             // - `numberMinted += quantity`.
1248             //
1249             // We can directly add to the `balance` and `numberMinted`.
1250             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1251 
1252             // Updates:
1253             // - `address` to the owner.
1254             // - `startTimestamp` to the timestamp of minting.
1255             // - `burned` to `false`.
1256             // - `nextInitialized` to `quantity == 1`.
1257             _packedOwnerships[startTokenId] = _packOwnershipData(
1258                 to,
1259                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1260             );
1261 
1262             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1263 
1264             _currentIndex = startTokenId + quantity;
1265         }
1266         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1267     }
1268 
1269     /**
1270      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1271      *
1272      * Requirements:
1273      *
1274      * - If `to` refers to a smart contract, it must implement
1275      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1276      * - `quantity` must be greater than 0.
1277      *
1278      * See {_mint}.
1279      *
1280      * Emits a {Transfer} event for each mint.
1281      */
1282     function _safeMint(
1283         address to,
1284         uint256 quantity,
1285         bytes memory _data
1286     ) internal virtual {
1287         _mint(to, quantity);
1288 
1289         unchecked {
1290             if (to.code.length != 0) {
1291                 uint256 end = _currentIndex;
1292                 uint256 index = end - quantity;
1293                 do {
1294                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1295                         revert TransferToNonERC721ReceiverImplementer();
1296                     }
1297                 } while (index < end);
1298                 // Reentrancy protection.
1299                 if (_currentIndex != end) revert();
1300             }
1301         }
1302     }
1303 
1304     /**
1305      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1306      */
1307     function _safeMint(address to, uint256 quantity) internal virtual {
1308         _safeMint(to, quantity, '');
1309     }
1310 
1311     // =============================================================
1312     //                        BURN OPERATIONS
1313     // =============================================================
1314 
1315     /**
1316      * @dev Equivalent to `_burn(tokenId, false)`.
1317      */
1318     function _burn(uint256 tokenId) internal virtual {
1319         _burn(tokenId, false);
1320     }
1321 
1322     /**
1323      * @dev Destroys `tokenId`.
1324      * The approval is cleared when the token is burned.
1325      *
1326      * Requirements:
1327      *
1328      * - `tokenId` must exist.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1333         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1334 
1335         address from = address(uint160(prevOwnershipPacked));
1336 
1337         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1338 
1339         if (approvalCheck) {
1340             // The nested ifs save around 20+ gas over a compound boolean condition.
1341             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1342                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1343         }
1344 
1345         _beforeTokenTransfers(from, address(0), tokenId, 1);
1346 
1347         // Clear approvals from the previous owner.
1348         assembly {
1349             if approvedAddress {
1350                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1351                 sstore(approvedAddressSlot, 0)
1352             }
1353         }
1354 
1355         // Underflow of the sender's balance is impossible because we check for
1356         // ownership above and the recipient's balance can't realistically overflow.
1357         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1358         unchecked {
1359             // Updates:
1360             // - `balance -= 1`.
1361             // - `numberBurned += 1`.
1362             //
1363             // We can directly decrement the balance, and increment the number burned.
1364             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1365             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1366 
1367             // Updates:
1368             // - `address` to the last owner.
1369             // - `startTimestamp` to the timestamp of burning.
1370             // - `burned` to `true`.
1371             // - `nextInitialized` to `true`.
1372             _packedOwnerships[tokenId] = _packOwnershipData(
1373                 from,
1374                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1375             );
1376 
1377             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1378             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1379                 uint256 nextTokenId = tokenId + 1;
1380                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1381                 if (_packedOwnerships[nextTokenId] == 0) {
1382                     // If the next slot is within bounds.
1383                     if (nextTokenId != _currentIndex) {
1384                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1385                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1386                     }
1387                 }
1388             }
1389         }
1390 
1391         emit Transfer(from, address(0), tokenId);
1392         _afterTokenTransfers(from, address(0), tokenId, 1);
1393 
1394         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1395         unchecked {
1396             _burnCounter++;
1397         }
1398     }
1399 
1400     // =============================================================
1401     //                     EXTRA DATA OPERATIONS
1402     // =============================================================
1403 
1404     /**
1405      * @dev Directly sets the extra data for the ownership data `index`.
1406      */
1407     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1408         uint256 packed = _packedOwnerships[index];
1409         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1410         uint256 extraDataCasted;
1411         // Cast `extraData` with assembly to avoid redundant masking.
1412         assembly {
1413             extraDataCasted := extraData
1414         }
1415         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1416         _packedOwnerships[index] = packed;
1417     }
1418 
1419     /**
1420      * @dev Called during each token transfer to set the 24bit `extraData` field.
1421      * Intended to be overridden by the cosumer contract.
1422      *
1423      * `previousExtraData` - the value of `extraData` before transfer.
1424      *
1425      * Calling conditions:
1426      *
1427      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1428      * transferred to `to`.
1429      * - When `from` is zero, `tokenId` will be minted for `to`.
1430      * - When `to` is zero, `tokenId` will be burned by `from`.
1431      * - `from` and `to` are never both zero.
1432      */
1433     function _extraData(
1434         address from,
1435         address to,
1436         uint24 previousExtraData
1437     ) internal view virtual returns (uint24) {}
1438 
1439     /**
1440      * @dev Returns the next extra data for the packed ownership data.
1441      * The returned result is shifted into position.
1442      */
1443     function _nextExtraData(
1444         address from,
1445         address to,
1446         uint256 prevOwnershipPacked
1447     ) private view returns (uint256) {
1448         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1449         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1450     }
1451 
1452     // =============================================================
1453     //                       OTHER OPERATIONS
1454     // =============================================================
1455 
1456     /**
1457      * @dev Returns the message sender (defaults to `msg.sender`).
1458      *
1459      * If you are writing GSN compatible contracts, you need to override this function.
1460      */
1461     function _msgSenderERC721A() internal view virtual returns (address) {
1462         return msg.sender;
1463     }
1464 
1465     /**
1466      * @dev Converts a uint256 to its ASCII string decimal representation.
1467      */
1468     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1469         assembly {
1470             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1471             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1472             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1473             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1474             let m := add(mload(0x40), 0xa0)
1475             // Update the free memory pointer to allocate.
1476             mstore(0x40, m)
1477             // Assign the `str` to the end.
1478             str := sub(m, 0x20)
1479             // Zeroize the slot after the string.
1480             mstore(str, 0)
1481 
1482             // Cache the end of the memory to calculate the length later.
1483             let end := str
1484 
1485             // We write the string from rightmost digit to leftmost digit.
1486             // The following is essentially a do-while loop that also handles the zero case.
1487             // prettier-ignore
1488             for { let temp := value } 1 {} {
1489                 str := sub(str, 1)
1490                 // Write the character to the pointer.
1491                 // The ASCII index of the '0' character is 48.
1492                 mstore8(str, add(48, mod(temp, 10)))
1493                 // Keep dividing `temp` until zero.
1494                 temp := div(temp, 10)
1495                 // prettier-ignore
1496                 if iszero(temp) { break }
1497             }
1498 
1499             let length := sub(end, str)
1500             // Move the pointer 32 bytes leftwards to make room for the length.
1501             str := sub(str, 0x20)
1502             // Store the length.
1503             mstore(str, length)
1504         }
1505     }
1506 }
1507 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1508 
1509 
1510 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1511 
1512 pragma solidity ^0.8.0;
1513 
1514 /**
1515  * @dev Contract module that helps prevent reentrant calls to a function.
1516  *
1517  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1518  * available, which can be applied to functions to make sure there are no nested
1519  * (reentrant) calls to them.
1520  *
1521  * Note that because there is a single `nonReentrant` guard, functions marked as
1522  * `nonReentrant` may not call one another. This can be worked around by making
1523  * those functions `private`, and then adding `external` `nonReentrant` entry
1524  * points to them.
1525  *
1526  * TIP: If you would like to learn more about reentrancy and alternative ways
1527  * to protect against it, check out our blog post
1528  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1529  */
1530 abstract contract ReentrancyGuard {
1531     // Booleans are more expensive than uint256 or any type that takes up a full
1532     // word because each write operation emits an extra SLOAD to first read the
1533     // slot's contents, replace the bits taken up by the boolean, and then write
1534     // back. This is the compiler's defense against contract upgrades and
1535     // pointer aliasing, and it cannot be disabled.
1536 
1537     // The values being non-zero value makes deployment a bit more expensive,
1538     // but in exchange the refund on every call to nonReentrant will be lower in
1539     // amount. Since refunds are capped to a percentage of the total
1540     // transaction's gas, it is best to keep them low in cases like this one, to
1541     // increase the likelihood of the full refund coming into effect.
1542     uint256 private constant _NOT_ENTERED = 1;
1543     uint256 private constant _ENTERED = 2;
1544 
1545     uint256 private _status;
1546 
1547     constructor() {
1548         _status = _NOT_ENTERED;
1549     }
1550 
1551     /**
1552      * @dev Prevents a contract from calling itself, directly or indirectly.
1553      * Calling a `nonReentrant` function from another `nonReentrant`
1554      * function is not supported. It is possible to prevent this from happening
1555      * by making the `nonReentrant` function external, and making it call a
1556      * `private` function that does the actual work.
1557      */
1558     modifier nonReentrant() {
1559         // On the first call to nonReentrant, _notEntered will be true
1560         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1561 
1562         // Any calls to nonReentrant after this point will fail
1563         _status = _ENTERED;
1564 
1565         _;
1566 
1567         // By storing the original value once again, a refund is triggered (see
1568         // https://eips.ethereum.org/EIPS/eip-2200)
1569         _status = _NOT_ENTERED;
1570     }
1571 }
1572 
1573 // File: @openzeppelin/contracts/utils/Context.sol
1574 
1575 
1576 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1577 
1578 pragma solidity ^0.8.0;
1579 
1580 /**
1581  * @dev Provides information about the current execution context, including the
1582  * sender of the transaction and its data. While these are generally available
1583  * via msg.sender and msg.data, they should not be accessed in such a direct
1584  * manner, since when dealing with meta-transactions the account sending and
1585  * paying for execution may not be the actual sender (as far as an application
1586  * is concerned).
1587  *
1588  * This contract is only required for intermediate, library-like contracts.
1589  */
1590 abstract contract Context {
1591     function _msgSender() internal view virtual returns (address) {
1592         return msg.sender;
1593     }
1594 
1595     function _msgData() internal view virtual returns (bytes calldata) {
1596         return msg.data;
1597     }
1598 }
1599 
1600 // File: @openzeppelin/contracts/access/Ownable.sol
1601 
1602 
1603 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1604 
1605 pragma solidity ^0.8.0;
1606 
1607 
1608 /**
1609  * @dev Contract module which provides a basic access control mechanism, where
1610  * there is an account (an owner) that can be granted exclusive access to
1611  * specific functions.
1612  *
1613  * By default, the owner account will be the one that deploys the contract. This
1614  * can later be changed with {transferOwnership}.
1615  *
1616  * This module is used through inheritance. It will make available the modifier
1617  * `onlyOwner`, which can be applied to your functions to restrict their use to
1618  * the owner.
1619  */
1620 abstract contract Ownable is Context {
1621     address private _owner;
1622 
1623     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1624 
1625     /**
1626      * @dev Initializes the contract setting the deployer as the initial owner.
1627      */
1628     constructor() {
1629         _transferOwnership(_msgSender());
1630     }
1631 
1632     /**
1633      * @dev Returns the address of the current owner.
1634      */
1635     function owner() public view virtual returns (address) {
1636         return _owner;
1637     }
1638 
1639     /**
1640      * @dev Throws if called by any account other than the owner.
1641      */
1642     modifier onlyOwner() {
1643         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1644         _;
1645     }
1646 
1647     /**
1648      * @dev Leaves the contract without owner. It will not be possible to call
1649      * `onlyOwner` functions anymore. Can only be called by the current owner.
1650      *
1651      * NOTE: Renouncing ownership will leave the contract without an owner,
1652      * thereby removing any functionality that is only available to the owner.
1653      */
1654     function renounceOwnership() public virtual onlyOwner {
1655         _transferOwnership(address(0));
1656     }
1657 
1658     /**
1659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1660      * Can only be called by the current owner.
1661      */
1662     function transferOwnership(address newOwner) public virtual onlyOwner {
1663         require(newOwner != address(0), "Ownable: new owner is the zero address");
1664         _transferOwnership(newOwner);
1665     }
1666 
1667     /**
1668      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1669      * Internal function without access restriction.
1670      */
1671     function _transferOwnership(address newOwner) internal virtual {
1672         address oldOwner = _owner;
1673         _owner = newOwner;
1674         emit OwnershipTransferred(oldOwner, newOwner);
1675     }
1676 }
1677 
1678 // File: contracts/Cactus.sol
1679 
1680 
1681 
1682 pragma solidity ^0.8.0;
1683 
1684 
1685 
1686 
1687 
1688 
1689 contract Cactus is Ownable, ERC721A, ReentrancyGuard {
1690 
1691     bool private isPublicSaleOn = false;
1692     uint private constant MAX_SUPPLY = 3000;
1693     bytes32 public whiteListRoot;
1694   
1695     bool private whitelistOn = false;
1696     mapping(address => uint256) public whiteListClaimed;
1697     mapping(address => bool) public whiteListClaimedChecker;
1698     
1699 
1700 
1701     constructor() ERC721A("Cactus", "ACC") {}
1702 
1703     modifier callerIsUser() {
1704         require(tx.origin == msg.sender, "The caller is another contract");
1705         _;
1706     }
1707 
1708 
1709     function reserveGiveaway(uint256 num, address walletAddress)
1710         public
1711         onlyOwner
1712     {
1713         require(totalSupply() + num <= MAX_SUPPLY, "Exceeds total supply");
1714         _safeMint(walletAddress, num);
1715     }
1716 
1717     function whiteListMint(bytes32[] calldata _merkleProof, uint256 quantity) external payable callerIsUser {
1718         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1719         require(MerkleProof.verify(_merkleProof, whiteListRoot, leaf),
1720             "Invalid Merkle Proof.");
1721         require(whitelistOn, "whitelist sale has not begun yet");
1722         require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds total supply");
1723         if (!whiteListClaimedChecker[msg.sender]) {
1724             whiteListClaimedChecker[msg.sender] = true;
1725             whiteListClaimed[msg.sender] = 3;
1726         }
1727         require(whiteListClaimed[msg.sender] - quantity >= 0, "Address already minted num of tokens allowed");
1728         whiteListClaimed[msg.sender] = whiteListClaimed[msg.sender] - quantity;
1729         _safeMint(msg.sender, quantity);
1730         
1731     }
1732 
1733 
1734     function publicSaleMint(uint256 quantity)
1735         external
1736         payable
1737         callerIsUser
1738     {
1739       
1740         require(
1741             isPublicSaleOn,
1742             "public sale has not begun yet"
1743         );
1744         require(
1745             totalSupply() + quantity <= MAX_SUPPLY,
1746             "reached max supply"
1747         );
1748        
1749         _safeMint(msg.sender, quantity);
1750   
1751     }
1752 
1753 
1754     function setPublicSale(bool flag) external onlyOwner {
1755         isPublicSaleOn = flag;
1756     }
1757 
1758     function setWhitelistFlag(bool flag) external onlyOwner {
1759         whitelistOn = flag;
1760     }
1761 
1762     function setWhiteListRoot(bytes32 merkle_root) external onlyOwner {
1763         whiteListRoot = merkle_root;
1764     }
1765 
1766     string private _baseTokenURI;
1767 
1768     function _baseURI() internal view virtual override returns (string memory) {
1769         return _baseTokenURI;
1770     }
1771 
1772     function setBaseURI(string calldata baseURI) external onlyOwner {
1773         _baseTokenURI = baseURI;
1774     }
1775 
1776     function withdraw() external onlyOwner nonReentrant {
1777          (bool success, ) = msg.sender.call{value: address(this).balance}("");
1778          require(success, "Transfer failed.");
1779     }
1780 
1781     function numberMinted(address owner) public view returns (uint256) {
1782         return _numberMinted(owner);
1783     }
1784 
1785 }