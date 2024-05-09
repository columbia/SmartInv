1 // Sources flattened with hardhat v2.11.1 https://hardhat.org
2 // Sorry for everyone trying to read this, etherscan was giving me fits trying to verify!
3 
4 // File lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
5 
6  // SPDX-License-Identifier: MIT
7 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 
33 // File lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol
34 
35  
36 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Interface for the NFT Royalty Standard.
42  *
43  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
44  * support for royalty payments across all NFT marketplaces and ecosystem participants.
45  *
46  * _Available since v4.5._
47  */
48 interface IERC2981 is IERC165 {
49     /**
50      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
51      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
52      */
53     function royaltyInfo(uint256 tokenId, uint256 salePrice)
54         external
55         view
56         returns (address receiver, uint256 royaltyAmount);
57 }
58 
59 
60 // File src/interfaces/ISeaDropTokenContractMetadata.sol
61 
62  
63 pragma solidity 0.8.17;
64 
65 interface ISeaDropTokenContractMetadata is IERC2981 {
66     /**
67      * @notice Throw if the max supply exceeds uint64, a limit
68      *         due to the storage of bit-packed variables in ERC721A.
69      */
70     error CannotExceedMaxSupplyOfUint64(uint256 newMaxSupply);
71 
72     /**
73      * @dev Revert with an error when attempting to set the provenance
74      *      hash after the mint has started.
75      */
76     error ProvenanceHashCannotBeSetAfterMintStarted();
77 
78     /**
79      * @dev Revert if the royalty basis points is greater than 10_000.
80      */
81     error InvalidRoyaltyBasisPoints(uint256 basisPoints);
82 
83     /**
84      * @dev Revert if the royalty address is being set to the zero address.
85      */
86     error RoyaltyAddressCannotBeZeroAddress();
87 
88     /**
89      * @dev Emit an event for token metadata reveals/updates,
90      *      according to EIP-4906.
91      *
92      * @param _fromTokenId The start token id.
93      * @param _toTokenId   The end token id.
94      */
95     event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
96 
97     /**
98      * @dev Emit an event when the URI for the collection-level metadata
99      *      is updated.
100      */
101     event ContractURIUpdated(string newContractURI);
102 
103     /**
104      * @dev Emit an event when the max token supply is updated.
105      */
106     event MaxSupplyUpdated(uint256 newMaxSupply);
107 
108     /**
109      * @dev Emit an event with the previous and new provenance hash after
110      *      being updated.
111      */
112     event ProvenanceHashUpdated(bytes32 previousHash, bytes32 newHash);
113 
114     /**
115      * @dev Emit an event when the royalties info is updated.
116      */
117     event RoyaltyInfoUpdated(address receiver, uint256 bps);
118 
119     /**
120      * @notice A struct defining royalty info for the contract.
121      */
122     struct RoyaltyInfo {
123         address royaltyAddress;
124         uint96 royaltyBps;
125     }
126 
127     /**
128      * @notice Sets the base URI for the token metadata and emits an event.
129      *
130      * @param tokenURI The new base URI to set.
131      */
132     function setBaseURI(string calldata tokenURI) external;
133 
134     /**
135      * @notice Sets the contract URI for contract metadata.
136      *
137      * @param newContractURI The new contract URI.
138      */
139     function setContractURI(string calldata newContractURI) external;
140 
141     /**
142      * @notice Sets the max supply and emits an event.
143      *
144      * @param newMaxSupply The new max supply to set.
145      */
146     function setMaxSupply(uint256 newMaxSupply) external;
147 
148     /**
149      * @notice Sets the provenance hash and emits an event.
150      *
151      *         The provenance hash is used for random reveals, which
152      *         is a hash of the ordered metadata to show it has not been
153      *         modified after mint started.
154      *
155      *         This function will revert after the first item has been minted.
156      *
157      * @param newProvenanceHash The new provenance hash to set.
158      */
159     function setProvenanceHash(bytes32 newProvenanceHash) external;
160 
161     /**
162      * @notice Sets the address and basis points for royalties.
163      *
164      * @param newInfo The struct to configure royalties.
165      */
166     function setRoyaltyInfo(RoyaltyInfo calldata newInfo) external;
167 
168     /**
169      * @notice Returns the base URI for token metadata.
170      */
171     function baseURI() external view returns (string memory);
172 
173     /**
174      * @notice Returns the contract URI.
175      */
176     function contractURI() external view returns (string memory);
177 
178     /**
179      * @notice Returns the max token supply.
180      */
181     function maxSupply() external view returns (uint256);
182 
183     /**
184      * @notice Returns the provenance hash.
185      *         The provenance hash is used for random reveals, which
186      *         is a hash of the ordered metadata to show it is unmodified
187      *         after mint has started.
188      */
189     function provenanceHash() external view returns (bytes32);
190 
191     /**
192      * @notice Returns the address that receives royalties.
193      */
194     function royaltyAddress() external view returns (address);
195 
196     /**
197      * @notice Returns the royalty basis points out of 10_000.
198      */
199     function royaltyBasisPoints() external view returns (uint256);
200 }
201 
202 
203 // File lib/ERC721A/contracts/IERC721A.sol
204 
205  
206 // ERC721A Contracts v4.2.3
207 // Creator: Chiru Labs
208 
209 pragma solidity ^0.8.4;
210 
211 /**
212  * @dev Interface of ERC721A.
213  */
214 interface IERC721A {
215     /**
216      * The caller must own the token or be an approved operator.
217      */
218     error ApprovalCallerNotOwnerNorApproved();
219 
220     /**
221      * The token does not exist.
222      */
223     error ApprovalQueryForNonexistentToken();
224 
225     /**
226      * Cannot query the balance for the zero address.
227      */
228     error BalanceQueryForZeroAddress();
229 
230     /**
231      * Cannot mint to the zero address.
232      */
233     error MintToZeroAddress();
234 
235     /**
236      * The quantity of tokens minted must be more than zero.
237      */
238     error MintZeroQuantity();
239 
240     /**
241      * The token does not exist.
242      */
243     error OwnerQueryForNonexistentToken();
244 
245     /**
246      * The caller must own the token or be an approved operator.
247      */
248     error TransferCallerNotOwnerNorApproved();
249 
250     /**
251      * The token must be owned by `from`.
252      */
253     error TransferFromIncorrectOwner();
254 
255     /**
256      * Cannot safely transfer to a contract that does not implement the
257      * ERC721Receiver interface.
258      */
259     error TransferToNonERC721ReceiverImplementer();
260 
261     /**
262      * Cannot transfer to the zero address.
263      */
264     error TransferToZeroAddress();
265 
266     /**
267      * The token does not exist.
268      */
269     error URIQueryForNonexistentToken();
270 
271     /**
272      * The `quantity` minted with ERC2309 exceeds the safety limit.
273      */
274     error MintERC2309QuantityExceedsLimit();
275 
276     /**
277      * The `extraData` cannot be set on an unintialized ownership slot.
278      */
279     error OwnershipNotInitializedForExtraData();
280 
281     // =============================================================
282     //                            STRUCTS
283     // =============================================================
284 
285     struct TokenOwnership {
286         // The address of the owner.
287         address addr;
288         // Stores the start time of ownership with minimal overhead for tokenomics.
289         uint64 startTimestamp;
290         // Whether the token has been burned.
291         bool burned;
292         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
293         uint24 extraData;
294     }
295 
296     // =============================================================
297     //                         TOKEN COUNTERS
298     // =============================================================
299 
300     /**
301      * @dev Returns the total number of tokens in existence.
302      * Burned tokens will reduce the count.
303      * To get the total number of tokens minted, please see {_totalMinted}.
304      */
305     function totalSupply() external view returns (uint256);
306 
307     // =============================================================
308     //                            IERC165
309     // =============================================================
310 
311     /**
312      * @dev Returns true if this contract implements the interface defined by
313      * `interfaceId`. See the corresponding
314      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
315      * to learn more about how these ids are created.
316      *
317      * This function call must use less than 30000 gas.
318      */
319     function supportsInterface(bytes4 interfaceId) external view returns (bool);
320 
321     // =============================================================
322     //                            IERC721
323     // =============================================================
324 
325     /**
326      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
327      */
328     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
329 
330     /**
331      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
332      */
333     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
334 
335     /**
336      * @dev Emitted when `owner` enables or disables
337      * (`approved`) `operator` to manage all of its assets.
338      */
339     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
340 
341     /**
342      * @dev Returns the number of tokens in `owner`'s account.
343      */
344     function balanceOf(address owner) external view returns (uint256 balance);
345 
346     /**
347      * @dev Returns the owner of the `tokenId` token.
348      *
349      * Requirements:
350      *
351      * - `tokenId` must exist.
352      */
353     function ownerOf(uint256 tokenId) external view returns (address owner);
354 
355     /**
356      * @dev Safely transfers `tokenId` token from `from` to `to`,
357      * checking first that contract recipients are aware of the ERC721 protocol
358      * to prevent tokens from being forever locked.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be have been allowed to move
366      * this token by either {approve} or {setApprovalForAll}.
367      * - If `to` refers to a smart contract, it must implement
368      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId,
376         bytes calldata data
377     ) external payable;
378 
379     /**
380      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
381      */
382     function safeTransferFrom(
383         address from,
384         address to,
385         uint256 tokenId
386     ) external payable;
387 
388     /**
389      * @dev Transfers `tokenId` from `from` to `to`.
390      *
391      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
392      * whenever possible.
393      *
394      * Requirements:
395      *
396      * - `from` cannot be the zero address.
397      * - `to` cannot be the zero address.
398      * - `tokenId` token must be owned by `from`.
399      * - If the caller is not `from`, it must be approved to move this token
400      * by either {approve} or {setApprovalForAll}.
401      *
402      * Emits a {Transfer} event.
403      */
404     function transferFrom(
405         address from,
406         address to,
407         uint256 tokenId
408     ) external payable;
409 
410     /**
411      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
412      * The approval is cleared when the token is transferred.
413      *
414      * Only a single account can be approved at a time, so approving the
415      * zero address clears previous approvals.
416      *
417      * Requirements:
418      *
419      * - The caller must own the token or be an approved operator.
420      * - `tokenId` must exist.
421      *
422      * Emits an {Approval} event.
423      */
424     function approve(address to, uint256 tokenId) external payable;
425 
426     /**
427      * @dev Approve or remove `operator` as an operator for the caller.
428      * Operators can call {transferFrom} or {safeTransferFrom}
429      * for any token owned by the caller.
430      *
431      * Requirements:
432      *
433      * - The `operator` cannot be the caller.
434      *
435      * Emits an {ApprovalForAll} event.
436      */
437     function setApprovalForAll(address operator, bool _approved) external;
438 
439     /**
440      * @dev Returns the account approved for `tokenId` token.
441      *
442      * Requirements:
443      *
444      * - `tokenId` must exist.
445      */
446     function getApproved(uint256 tokenId) external view returns (address operator);
447 
448     /**
449      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
450      *
451      * See {setApprovalForAll}.
452      */
453     function isApprovedForAll(address owner, address operator) external view returns (bool);
454 
455     // =============================================================
456     //                        IERC721Metadata
457     // =============================================================
458 
459     /**
460      * @dev Returns the token collection name.
461      */
462     function name() external view returns (string memory);
463 
464     /**
465      * @dev Returns the token collection symbol.
466      */
467     function symbol() external view returns (string memory);
468 
469     /**
470      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
471      */
472     function tokenURI(uint256 tokenId) external view returns (string memory);
473 
474     // =============================================================
475     //                           IERC2309
476     // =============================================================
477 
478     /**
479      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
480      * (inclusive) is transferred from `from` to `to`, as defined in the
481      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
482      *
483      * See {_mintERC2309} for more details.
484      */
485     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
486 }
487 
488 
489 // File lib/ERC721A/contracts/ERC721A.sol
490 
491  
492 // ERC721A Contracts v4.2.3
493 // Creator: Chiru Labs
494 
495 pragma solidity ^0.8.4;
496 
497 /**
498  * @dev Interface of ERC721 token receiver.
499  */
500 interface ERC721A__IERC721Receiver {
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 /**
510  * @title ERC721A
511  *
512  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
513  * Non-Fungible Token Standard, including the Metadata extension.
514  * Optimized for lower gas during batch mints.
515  *
516  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
517  * starting from `_startTokenId()`.
518  *
519  * Assumptions:
520  *
521  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
522  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
523  */
524 contract ERC721A is IERC721A {
525     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
526     struct TokenApprovalRef {
527         address value;
528     }
529 
530     // =============================================================
531     //                           CONSTANTS
532     // =============================================================
533 
534     // Mask of an entry in packed address data.
535     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
536 
537     // The bit position of `numberMinted` in packed address data.
538     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
539 
540     // The bit position of `numberBurned` in packed address data.
541     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
542 
543     // The bit position of `aux` in packed address data.
544     uint256 private constant _BITPOS_AUX = 192;
545 
546     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
547     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
548 
549     // The bit position of `startTimestamp` in packed ownership.
550     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
551 
552     // The bit mask of the `burned` bit in packed ownership.
553     uint256 private constant _BITMASK_BURNED = 1 << 224;
554 
555     // The bit position of the `nextInitialized` bit in packed ownership.
556     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
557 
558     // The bit mask of the `nextInitialized` bit in packed ownership.
559     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
560 
561     // The bit position of `extraData` in packed ownership.
562     uint256 private constant _BITPOS_EXTRA_DATA = 232;
563 
564     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
565     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
566 
567     // The mask of the lower 160 bits for addresses.
568     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
569 
570     // The maximum `quantity` that can be minted with {_mintERC2309}.
571     // This limit is to prevent overflows on the address data entries.
572     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
573     // is required to cause an overflow, which is unrealistic.
574     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
575 
576     // The `Transfer` event signature is given by:
577     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
578     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
579         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
580 
581     // =============================================================
582     //                            STORAGE
583     // =============================================================
584 
585     // The next token ID to be minted.
586     uint256 private _currentIndex;
587 
588     // The number of tokens burned.
589     uint256 private _burnCounter;
590 
591     // Token name
592     string private _name;
593 
594     // Token symbol
595     string private _symbol;
596 
597     // Mapping from token ID to ownership details
598     // An empty struct value does not necessarily mean the token is unowned.
599     // See {_packedOwnershipOf} implementation for details.
600     //
601     // Bits Layout:
602     // - [0..159]   `addr`
603     // - [160..223] `startTimestamp`
604     // - [224]      `burned`
605     // - [225]      `nextInitialized`
606     // - [232..255] `extraData`
607     mapping(uint256 => uint256) private _packedOwnerships;
608 
609     // Mapping owner address to address data.
610     //
611     // Bits Layout:
612     // - [0..63]    `balance`
613     // - [64..127]  `numberMinted`
614     // - [128..191] `numberBurned`
615     // - [192..255] `aux`
616     mapping(address => uint256) private _packedAddressData;
617 
618     // Mapping from token ID to approved address.
619     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
620 
621     // Mapping from owner to operator approvals
622     mapping(address => mapping(address => bool)) private _operatorApprovals;
623 
624     // =============================================================
625     //                          CONSTRUCTOR
626     // =============================================================
627 
628     constructor(string memory name_, string memory symbol_) {
629         _name = name_;
630         _symbol = symbol_;
631         _currentIndex = _startTokenId();
632     }
633 
634     // =============================================================
635     //                   TOKEN COUNTING OPERATIONS
636     // =============================================================
637 
638     /**
639      * @dev Returns the starting token ID.
640      * To change the starting token ID, please override this function.
641      */
642     function _startTokenId() internal view virtual returns (uint256) {
643         return 0;
644     }
645 
646     /**
647      * @dev Returns the next token ID to be minted.
648      */
649     function _nextTokenId() internal view virtual returns (uint256) {
650         return _currentIndex;
651     }
652 
653     /**
654      * @dev Returns the total number of tokens in existence.
655      * Burned tokens will reduce the count.
656      * To get the total number of tokens minted, please see {_totalMinted}.
657      */
658     function totalSupply() public view virtual override returns (uint256) {
659         // Counter underflow is impossible as _burnCounter cannot be incremented
660         // more than `_currentIndex - _startTokenId()` times.
661         unchecked {
662             return _currentIndex - _burnCounter - _startTokenId();
663         }
664     }
665 
666     /**
667      * @dev Returns the total amount of tokens minted in the contract.
668      */
669     function _totalMinted() internal view virtual returns (uint256) {
670         // Counter underflow is impossible as `_currentIndex` does not decrement,
671         // and it is initialized to `_startTokenId()`.
672         unchecked {
673             return _currentIndex - _startTokenId();
674         }
675     }
676 
677     /**
678      * @dev Returns the total number of tokens burned.
679      */
680     function _totalBurned() internal view virtual returns (uint256) {
681         return _burnCounter;
682     }
683 
684     // =============================================================
685     //                    ADDRESS DATA OPERATIONS
686     // =============================================================
687 
688     /**
689      * @dev Returns the number of tokens in `owner`'s account.
690      */
691     function balanceOf(address owner) public view virtual override returns (uint256) {
692         if (owner == address(0)) revert BalanceQueryForZeroAddress();
693         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
694     }
695 
696     /**
697      * Returns the number of tokens minted by `owner`.
698      */
699     function _numberMinted(address owner) internal view returns (uint256) {
700         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
701     }
702 
703     /**
704      * Returns the number of tokens burned by or on behalf of `owner`.
705      */
706     function _numberBurned(address owner) internal view returns (uint256) {
707         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
708     }
709 
710     /**
711      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
712      */
713     function _getAux(address owner) internal view returns (uint64) {
714         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
715     }
716 
717     /**
718      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
719      * If there are multiple variables, please pack them into a uint64.
720      */
721     function _setAux(address owner, uint64 aux) internal virtual {
722         uint256 packed = _packedAddressData[owner];
723         uint256 auxCasted;
724         // Cast `aux` with assembly to avoid redundant masking.
725         assembly {
726             auxCasted := aux
727         }
728         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
729         _packedAddressData[owner] = packed;
730     }
731 
732     // =============================================================
733     //                            IERC165
734     // =============================================================
735 
736     /**
737      * @dev Returns true if this contract implements the interface defined by
738      * `interfaceId`. See the corresponding
739      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
740      * to learn more about how these ids are created.
741      *
742      * This function call must use less than 30000 gas.
743      */
744     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
745         // The interface IDs are constants representing the first 4 bytes
746         // of the XOR of all function selectors in the interface.
747         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
748         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
749         return
750             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
751             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
752             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
753     }
754 
755     // =============================================================
756     //                        IERC721Metadata
757     // =============================================================
758 
759     /**
760      * @dev Returns the token collection name.
761      */
762     function name() public view virtual override returns (string memory) {
763         return _name;
764     }
765 
766     /**
767      * @dev Returns the token collection symbol.
768      */
769     function symbol() public view virtual override returns (string memory) {
770         return _symbol;
771     }
772 
773     /**
774      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
775      */
776     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
777         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
778 
779         string memory baseURI = _baseURI();
780         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
781     }
782 
783     /**
784      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
785      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
786      * by default, it can be overridden in child contracts.
787      */
788     function _baseURI() internal view virtual returns (string memory) {
789         return '';
790     }
791 
792     // =============================================================
793     //                     OWNERSHIPS OPERATIONS
794     // =============================================================
795 
796     /**
797      * @dev Returns the owner of the `tokenId` token.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
804         return address(uint160(_packedOwnershipOf(tokenId)));
805     }
806 
807     /**
808      * @dev Gas spent here starts off proportional to the maximum mint batch size.
809      * It gradually moves to O(1) as tokens get transferred around over time.
810      */
811     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
812         return _unpackedOwnership(_packedOwnershipOf(tokenId));
813     }
814 
815     /**
816      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
817      */
818     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
819         return _unpackedOwnership(_packedOwnerships[index]);
820     }
821 
822     /**
823      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
824      */
825     function _initializeOwnershipAt(uint256 index) internal virtual {
826         if (_packedOwnerships[index] == 0) {
827             _packedOwnerships[index] = _packedOwnershipOf(index);
828         }
829     }
830 
831     /**
832      * Returns the packed ownership data of `tokenId`.
833      */
834     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
835         uint256 curr = tokenId;
836 
837         unchecked {
838             if (_startTokenId() <= curr)
839                 if (curr < _currentIndex) {
840                     uint256 packed = _packedOwnerships[curr];
841                     // If not burned.
842                     if (packed & _BITMASK_BURNED == 0) {
843                         // Invariant:
844                         // There will always be an initialized ownership slot
845                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
846                         // before an unintialized ownership slot
847                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
848                         // Hence, `curr` will not underflow.
849                         //
850                         // We can directly compare the packed value.
851                         // If the address is zero, packed will be zero.
852                         while (packed == 0) {
853                             packed = _packedOwnerships[--curr];
854                         }
855                         return packed;
856                     }
857                 }
858         }
859         revert OwnerQueryForNonexistentToken();
860     }
861 
862     /**
863      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
864      */
865     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
866         ownership.addr = address(uint160(packed));
867         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
868         ownership.burned = packed & _BITMASK_BURNED != 0;
869         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
870     }
871 
872     /**
873      * @dev Packs ownership data into a single uint256.
874      */
875     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
876         assembly {
877             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
878             owner := and(owner, _BITMASK_ADDRESS)
879             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
880             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
881         }
882     }
883 
884     /**
885      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
886      */
887     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
888         // For branchless setting of the `nextInitialized` flag.
889         assembly {
890             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
891             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
892         }
893     }
894 
895     // =============================================================
896     //                      APPROVAL OPERATIONS
897     // =============================================================
898 
899     /**
900      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
901      * The approval is cleared when the token is transferred.
902      *
903      * Only a single account can be approved at a time, so approving the
904      * zero address clears previous approvals.
905      *
906      * Requirements:
907      *
908      * - The caller must own the token or be an approved operator.
909      * - `tokenId` must exist.
910      *
911      * Emits an {Approval} event.
912      */
913     function approve(address to, uint256 tokenId) public payable virtual override {
914         address owner = ownerOf(tokenId);
915 
916         if (_msgSenderERC721A() != owner)
917             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
918                 revert ApprovalCallerNotOwnerNorApproved();
919             }
920 
921         _tokenApprovals[tokenId].value = to;
922         emit Approval(owner, to, tokenId);
923     }
924 
925     /**
926      * @dev Returns the account approved for `tokenId` token.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      */
932     function getApproved(uint256 tokenId) public view virtual override returns (address) {
933         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
934 
935         return _tokenApprovals[tokenId].value;
936     }
937 
938     /**
939      * @dev Approve or remove `operator` as an operator for the caller.
940      * Operators can call {transferFrom} or {safeTransferFrom}
941      * for any token owned by the caller.
942      *
943      * Requirements:
944      *
945      * - The `operator` cannot be the caller.
946      *
947      * Emits an {ApprovalForAll} event.
948      */
949     function setApprovalForAll(address operator, bool approved) public virtual override {
950         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
951         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
952     }
953 
954     /**
955      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
956      *
957      * See {setApprovalForAll}.
958      */
959     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
960         return _operatorApprovals[owner][operator];
961     }
962 
963     /**
964      * @dev Returns whether `tokenId` exists.
965      *
966      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
967      *
968      * Tokens start existing when they are minted. See {_mint}.
969      */
970     function _exists(uint256 tokenId) internal view virtual returns (bool) {
971         return
972             _startTokenId() <= tokenId &&
973             tokenId < _currentIndex && // If within bounds,
974             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
975     }
976 
977     /**
978      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
979      */
980     function _isSenderApprovedOrOwner(
981         address approvedAddress,
982         address owner,
983         address msgSender
984     ) private pure returns (bool result) {
985         assembly {
986             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
987             owner := and(owner, _BITMASK_ADDRESS)
988             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
989             msgSender := and(msgSender, _BITMASK_ADDRESS)
990             // `msgSender == owner || msgSender == approvedAddress`.
991             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
992         }
993     }
994 
995     /**
996      * @dev Returns the storage slot and value for the approved address of `tokenId`.
997      */
998     function _getApprovedSlotAndAddress(uint256 tokenId)
999         private
1000         view
1001         returns (uint256 approvedAddressSlot, address approvedAddress)
1002     {
1003         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1004         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1005         assembly {
1006             approvedAddressSlot := tokenApproval.slot
1007             approvedAddress := sload(approvedAddressSlot)
1008         }
1009     }
1010 
1011     // =============================================================
1012     //                      TRANSFER OPERATIONS
1013     // =============================================================
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `from` cannot be the zero address.
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must be owned by `from`.
1023      * - If the caller is not `from`, it must be approved to move this token
1024      * by either {approve} or {setApprovalForAll}.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function transferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public payable virtual override {
1033         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1034 
1035         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1036 
1037         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1038 
1039         // The nested ifs save around 20+ gas over a compound boolean condition.
1040         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1041             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1042 
1043         if (to == address(0)) revert TransferToZeroAddress();
1044 
1045         _beforeTokenTransfers(from, to, tokenId, 1);
1046 
1047         // Clear approvals from the previous owner.
1048         assembly {
1049             if approvedAddress {
1050                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1051                 sstore(approvedAddressSlot, 0)
1052             }
1053         }
1054 
1055         // Underflow of the sender's balance is impossible because we check for
1056         // ownership above and the recipient's balance can't realistically overflow.
1057         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1058         unchecked {
1059             // We can directly increment and decrement the balances.
1060             --_packedAddressData[from]; // Updates: `balance -= 1`.
1061             ++_packedAddressData[to]; // Updates: `balance += 1`.
1062 
1063             // Updates:
1064             // - `address` to the next owner.
1065             // - `startTimestamp` to the timestamp of transfering.
1066             // - `burned` to `false`.
1067             // - `nextInitialized` to `true`.
1068             _packedOwnerships[tokenId] = _packOwnershipData(
1069                 to,
1070                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1071             );
1072 
1073             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1074             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1075                 uint256 nextTokenId = tokenId + 1;
1076                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1077                 if (_packedOwnerships[nextTokenId] == 0) {
1078                     // If the next slot is within bounds.
1079                     if (nextTokenId != _currentIndex) {
1080                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1081                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1082                     }
1083                 }
1084             }
1085         }
1086 
1087         emit Transfer(from, to, tokenId);
1088         _afterTokenTransfers(from, to, tokenId, 1);
1089     }
1090 
1091     /**
1092      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1093      */
1094     function safeTransferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) public payable virtual override {
1099         safeTransferFrom(from, to, tokenId, '');
1100     }
1101 
1102     /**
1103      * @dev Safely transfers `tokenId` token from `from` to `to`.
1104      *
1105      * Requirements:
1106      *
1107      * - `from` cannot be the zero address.
1108      * - `to` cannot be the zero address.
1109      * - `tokenId` token must exist and be owned by `from`.
1110      * - If the caller is not `from`, it must be approved to move this token
1111      * by either {approve} or {setApprovalForAll}.
1112      * - If `to` refers to a smart contract, it must implement
1113      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function safeTransferFrom(
1118         address from,
1119         address to,
1120         uint256 tokenId,
1121         bytes memory _data
1122     ) public payable virtual override {
1123         transferFrom(from, to, tokenId);
1124         if (to.code.length != 0)
1125             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1126                 revert TransferToNonERC721ReceiverImplementer();
1127             }
1128     }
1129 
1130     /**
1131      * @dev Hook that is called before a set of serially-ordered token IDs
1132      * are about to be transferred. This includes minting.
1133      * And also called before burning one token.
1134      *
1135      * `startTokenId` - the first token ID to be transferred.
1136      * `quantity` - the amount to be transferred.
1137      *
1138      * Calling conditions:
1139      *
1140      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1141      * transferred to `to`.
1142      * - When `from` is zero, `tokenId` will be minted for `to`.
1143      * - When `to` is zero, `tokenId` will be burned by `from`.
1144      * - `from` and `to` are never both zero.
1145      */
1146     function _beforeTokenTransfers(
1147         address from,
1148         address to,
1149         uint256 startTokenId,
1150         uint256 quantity
1151     ) internal virtual {}
1152 
1153     /**
1154      * @dev Hook that is called after a set of serially-ordered token IDs
1155      * have been transferred. This includes minting.
1156      * And also called after one token has been burned.
1157      *
1158      * `startTokenId` - the first token ID to be transferred.
1159      * `quantity` - the amount to be transferred.
1160      *
1161      * Calling conditions:
1162      *
1163      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1164      * transferred to `to`.
1165      * - When `from` is zero, `tokenId` has been minted for `to`.
1166      * - When `to` is zero, `tokenId` has been burned by `from`.
1167      * - `from` and `to` are never both zero.
1168      */
1169     function _afterTokenTransfers(
1170         address from,
1171         address to,
1172         uint256 startTokenId,
1173         uint256 quantity
1174     ) internal virtual {}
1175 
1176     /**
1177      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1178      *
1179      * `from` - Previous owner of the given token ID.
1180      * `to` - Target address that will receive the token.
1181      * `tokenId` - Token ID to be transferred.
1182      * `_data` - Optional data to send along with the call.
1183      *
1184      * Returns whether the call correctly returned the expected magic value.
1185      */
1186     function _checkContractOnERC721Received(
1187         address from,
1188         address to,
1189         uint256 tokenId,
1190         bytes memory _data
1191     ) private returns (bool) {
1192         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1193             bytes4 retval
1194         ) {
1195             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1196         } catch (bytes memory reason) {
1197             if (reason.length == 0) {
1198                 revert TransferToNonERC721ReceiverImplementer();
1199             } else {
1200                 assembly {
1201                     revert(add(32, reason), mload(reason))
1202                 }
1203             }
1204         }
1205     }
1206 
1207     // =============================================================
1208     //                        MINT OPERATIONS
1209     // =============================================================
1210 
1211     /**
1212      * @dev Mints `quantity` tokens and transfers them to `to`.
1213      *
1214      * Requirements:
1215      *
1216      * - `to` cannot be the zero address.
1217      * - `quantity` must be greater than 0.
1218      *
1219      * Emits a {Transfer} event for each mint.
1220      */
1221     function _mint(address to, uint256 quantity) internal virtual {
1222         uint256 startTokenId = _currentIndex;
1223         if (quantity == 0) revert MintZeroQuantity();
1224 
1225         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1226 
1227         // Overflows are incredibly unrealistic.
1228         // `balance` and `numberMinted` have a maximum limit of 2**64.
1229         // `tokenId` has a maximum limit of 2**256.
1230         unchecked {
1231             // Updates:
1232             // - `balance += quantity`.
1233             // - `numberMinted += quantity`.
1234             //
1235             // We can directly add to the `balance` and `numberMinted`.
1236             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1237 
1238             // Updates:
1239             // - `address` to the owner.
1240             // - `startTimestamp` to the timestamp of minting.
1241             // - `burned` to `false`.
1242             // - `nextInitialized` to `quantity == 1`.
1243             _packedOwnerships[startTokenId] = _packOwnershipData(
1244                 to,
1245                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1246             );
1247 
1248             uint256 toMasked;
1249             uint256 end = startTokenId + quantity;
1250 
1251             // Use assembly to loop and emit the `Transfer` event for gas savings.
1252             // The duplicated `log4` removes an extra check and reduces stack juggling.
1253             // The assembly, together with the surrounding Solidity code, have been
1254             // delicately arranged to nudge the compiler into producing optimized opcodes.
1255             assembly {
1256                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1257                 toMasked := and(to, _BITMASK_ADDRESS)
1258                 // Emit the `Transfer` event.
1259                 log4(
1260                     0, // Start of data (0, since no data).
1261                     0, // End of data (0, since no data).
1262                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1263                     0, // `address(0)`.
1264                     toMasked, // `to`.
1265                     startTokenId // `tokenId`.
1266                 )
1267 
1268                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1269                 // that overflows uint256 will make the loop run out of gas.
1270                 // The compiler will optimize the `iszero` away for performance.
1271                 for {
1272                     let tokenId := add(startTokenId, 1)
1273                 } iszero(eq(tokenId, end)) {
1274                     tokenId := add(tokenId, 1)
1275                 } {
1276                     // Emit the `Transfer` event. Similar to above.
1277                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1278                 }
1279             }
1280             if (toMasked == 0) revert MintToZeroAddress();
1281 
1282             _currentIndex = end;
1283         }
1284         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1285     }
1286 
1287     /**
1288      * @dev Mints `quantity` tokens and transfers them to `to`.
1289      *
1290      * This function is intended for efficient minting only during contract creation.
1291      *
1292      * It emits only one {ConsecutiveTransfer} as defined in
1293      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1294      * instead of a sequence of {Transfer} event(s).
1295      *
1296      * Calling this function outside of contract creation WILL make your contract
1297      * non-compliant with the ERC721 standard.
1298      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1299      * {ConsecutiveTransfer} event is only permissible during contract creation.
1300      *
1301      * Requirements:
1302      *
1303      * - `to` cannot be the zero address.
1304      * - `quantity` must be greater than 0.
1305      *
1306      * Emits a {ConsecutiveTransfer} event.
1307      */
1308     function _mintERC2309(address to, uint256 quantity) internal virtual {
1309         uint256 startTokenId = _currentIndex;
1310         if (to == address(0)) revert MintToZeroAddress();
1311         if (quantity == 0) revert MintZeroQuantity();
1312         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1313 
1314         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1315 
1316         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1317         unchecked {
1318             // Updates:
1319             // - `balance += quantity`.
1320             // - `numberMinted += quantity`.
1321             //
1322             // We can directly add to the `balance` and `numberMinted`.
1323             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1324 
1325             // Updates:
1326             // - `address` to the owner.
1327             // - `startTimestamp` to the timestamp of minting.
1328             // - `burned` to `false`.
1329             // - `nextInitialized` to `quantity == 1`.
1330             _packedOwnerships[startTokenId] = _packOwnershipData(
1331                 to,
1332                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1333             );
1334 
1335             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1336 
1337             _currentIndex = startTokenId + quantity;
1338         }
1339         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1340     }
1341 
1342     /**
1343      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1344      *
1345      * Requirements:
1346      *
1347      * - If `to` refers to a smart contract, it must implement
1348      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1349      * - `quantity` must be greater than 0.
1350      *
1351      * See {_mint}.
1352      *
1353      * Emits a {Transfer} event for each mint.
1354      */
1355     function _safeMint(
1356         address to,
1357         uint256 quantity,
1358         bytes memory _data
1359     ) internal virtual {
1360         _mint(to, quantity);
1361 
1362         unchecked {
1363             if (to.code.length != 0) {
1364                 uint256 end = _currentIndex;
1365                 uint256 index = end - quantity;
1366                 do {
1367                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1368                         revert TransferToNonERC721ReceiverImplementer();
1369                     }
1370                 } while (index < end);
1371                 // Reentrancy protection.
1372                 if (_currentIndex != end) revert();
1373             }
1374         }
1375     }
1376 
1377     /**
1378      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1379      */
1380     function _safeMint(address to, uint256 quantity) internal virtual {
1381         _safeMint(to, quantity, '');
1382     }
1383 
1384     // =============================================================
1385     //                        BURN OPERATIONS
1386     // =============================================================
1387 
1388     /**
1389      * @dev Equivalent to `_burn(tokenId, false)`.
1390      */
1391     function _burn(uint256 tokenId) internal virtual {
1392         _burn(tokenId, false);
1393     }
1394 
1395     /**
1396      * @dev Destroys `tokenId`.
1397      * The approval is cleared when the token is burned.
1398      *
1399      * Requirements:
1400      *
1401      * - `tokenId` must exist.
1402      *
1403      * Emits a {Transfer} event.
1404      */
1405     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1406         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1407 
1408         address from = address(uint160(prevOwnershipPacked));
1409 
1410         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1411 
1412         if (approvalCheck) {
1413             // The nested ifs save around 20+ gas over a compound boolean condition.
1414             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1415                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1416         }
1417 
1418         _beforeTokenTransfers(from, address(0), tokenId, 1);
1419 
1420         // Clear approvals from the previous owner.
1421         assembly {
1422             if approvedAddress {
1423                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1424                 sstore(approvedAddressSlot, 0)
1425             }
1426         }
1427 
1428         // Underflow of the sender's balance is impossible because we check for
1429         // ownership above and the recipient's balance can't realistically overflow.
1430         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1431         unchecked {
1432             // Updates:
1433             // - `balance -= 1`.
1434             // - `numberBurned += 1`.
1435             //
1436             // We can directly decrement the balance, and increment the number burned.
1437             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1438             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1439 
1440             // Updates:
1441             // - `address` to the last owner.
1442             // - `startTimestamp` to the timestamp of burning.
1443             // - `burned` to `true`.
1444             // - `nextInitialized` to `true`.
1445             _packedOwnerships[tokenId] = _packOwnershipData(
1446                 from,
1447                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1448             );
1449 
1450             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1451             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1452                 uint256 nextTokenId = tokenId + 1;
1453                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1454                 if (_packedOwnerships[nextTokenId] == 0) {
1455                     // If the next slot is within bounds.
1456                     if (nextTokenId != _currentIndex) {
1457                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1458                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1459                     }
1460                 }
1461             }
1462         }
1463 
1464         emit Transfer(from, address(0), tokenId);
1465         _afterTokenTransfers(from, address(0), tokenId, 1);
1466 
1467         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1468         unchecked {
1469             _burnCounter++;
1470         }
1471     }
1472 
1473     // =============================================================
1474     //                     EXTRA DATA OPERATIONS
1475     // =============================================================
1476 
1477     /**
1478      * @dev Directly sets the extra data for the ownership data `index`.
1479      */
1480     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1481         uint256 packed = _packedOwnerships[index];
1482         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1483         uint256 extraDataCasted;
1484         // Cast `extraData` with assembly to avoid redundant masking.
1485         assembly {
1486             extraDataCasted := extraData
1487         }
1488         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1489         _packedOwnerships[index] = packed;
1490     }
1491 
1492     /**
1493      * @dev Called during each token transfer to set the 24bit `extraData` field.
1494      * Intended to be overridden by the cosumer contract.
1495      *
1496      * `previousExtraData` - the value of `extraData` before transfer.
1497      *
1498      * Calling conditions:
1499      *
1500      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1501      * transferred to `to`.
1502      * - When `from` is zero, `tokenId` will be minted for `to`.
1503      * - When `to` is zero, `tokenId` will be burned by `from`.
1504      * - `from` and `to` are never both zero.
1505      */
1506     function _extraData(
1507         address from,
1508         address to,
1509         uint24 previousExtraData
1510     ) internal view virtual returns (uint24) {}
1511 
1512     /**
1513      * @dev Returns the next extra data for the packed ownership data.
1514      * The returned result is shifted into position.
1515      */
1516     function _nextExtraData(
1517         address from,
1518         address to,
1519         uint256 prevOwnershipPacked
1520     ) private view returns (uint256) {
1521         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1522         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1523     }
1524 
1525     // =============================================================
1526     //                       OTHER OPERATIONS
1527     // =============================================================
1528 
1529     /**
1530      * @dev Returns the message sender (defaults to `msg.sender`).
1531      *
1532      * If you are writing GSN compatible contracts, you need to override this function.
1533      */
1534     function _msgSenderERC721A() internal view virtual returns (address) {
1535         return msg.sender;
1536     }
1537 
1538     /**
1539      * @dev Converts a uint256 to its ASCII string decimal representation.
1540      */
1541     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1542         assembly {
1543             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1544             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1545             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1546             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1547             let m := add(mload(0x40), 0xa0)
1548             // Update the free memory pointer to allocate.
1549             mstore(0x40, m)
1550             // Assign the `str` to the end.
1551             str := sub(m, 0x20)
1552             // Zeroize the slot after the string.
1553             mstore(str, 0)
1554 
1555             // Cache the end of the memory to calculate the length later.
1556             let end := str
1557 
1558             // We write the string from rightmost digit to leftmost digit.
1559             // The following is essentially a do-while loop that also handles the zero case.
1560             // prettier-ignore
1561             for { let temp := value } 1 {} {
1562                 str := sub(str, 1)
1563                 // Write the character to the pointer.
1564                 // The ASCII index of the '0' character is 48.
1565                 mstore8(str, add(48, mod(temp, 10)))
1566                 // Keep dividing `temp` until zero.
1567                 temp := div(temp, 10)
1568                 // prettier-ignore
1569                 if iszero(temp) { break }
1570             }
1571 
1572             let length := sub(end, str)
1573             // Move the pointer 32 bytes leftwards to make room for the length.
1574             str := sub(str, 0x20)
1575             // Store the length.
1576             mstore(str, length)
1577         }
1578     }
1579 }
1580 
1581 
1582 // File lib/utility-contracts/src/ConstructorInitializable.sol
1583 
1584  
1585 pragma solidity >=0.8.4;
1586 
1587 /**
1588  * @author emo.eth
1589  * @notice Abstract smart contract that provides an onlyUninitialized modifier which only allows calling when
1590  *         from within a constructor of some sort, whether directly instantiating an inherting contract,
1591  *         or when delegatecalling from a proxy
1592  */
1593 abstract contract ConstructorInitializable {
1594     error AlreadyInitialized();
1595 
1596     modifier onlyConstructor() {
1597         if (address(this).code.length != 0) {
1598             revert AlreadyInitialized();
1599         }
1600         _;
1601     }
1602 }
1603 
1604 
1605 // File lib/utility-contracts/src/TwoStepOwnable.sol
1606 
1607  
1608 pragma solidity >=0.8.4;
1609 
1610 /**
1611 @notice A two-step extension of Ownable, where the new owner must claim ownership of the contract after owner initiates transfer
1612 Owner can cancel the transfer at any point before the new owner claims ownership.
1613 Helpful in guarding against transferring ownership to an address that is unable to act as the Owner.
1614 */
1615 abstract contract TwoStepOwnable is ConstructorInitializable {
1616     address private _owner;
1617 
1618     event OwnershipTransferred(
1619         address indexed previousOwner,
1620         address indexed newOwner
1621     );
1622 
1623     address internal potentialOwner;
1624 
1625     event PotentialOwnerUpdated(address newPotentialAdministrator);
1626 
1627     error NewOwnerIsZeroAddress();
1628     error NotNextOwner();
1629     error OnlyOwner();
1630 
1631     modifier onlyOwner() {
1632         _checkOwner();
1633         _;
1634     }
1635 
1636     constructor() {
1637         _initialize();
1638     }
1639 
1640     function _initialize() private onlyConstructor {
1641         _transferOwnership(msg.sender);
1642     }
1643 
1644     ///@notice Initiate ownership transfer to newPotentialOwner. Note: new owner will have to manually acceptOwnership
1645     ///@param newPotentialOwner address of potential new owner
1646     function transferOwnership(address newPotentialOwner)
1647         public
1648         virtual
1649         onlyOwner
1650     {
1651         if (newPotentialOwner == address(0)) {
1652             revert NewOwnerIsZeroAddress();
1653         }
1654         potentialOwner = newPotentialOwner;
1655         emit PotentialOwnerUpdated(newPotentialOwner);
1656     }
1657 
1658     ///@notice Claim ownership of smart contract, after the current owner has initiated the process with transferOwnership
1659     function acceptOwnership() public virtual {
1660         address _potentialOwner = potentialOwner;
1661         if (msg.sender != _potentialOwner) {
1662             revert NotNextOwner();
1663         }
1664         delete potentialOwner;
1665         emit PotentialOwnerUpdated(address(0));
1666         _transferOwnership(_potentialOwner);
1667     }
1668 
1669     ///@notice cancel ownership transfer
1670     function cancelOwnershipTransfer() public virtual onlyOwner {
1671         delete potentialOwner;
1672         emit PotentialOwnerUpdated(address(0));
1673     }
1674 
1675     function owner() public view virtual returns (address) {
1676         return _owner;
1677     }
1678 
1679     /**
1680      * @dev Throws if the sender is not the owner.
1681      */
1682     function _checkOwner() internal view virtual {
1683         if (_owner != msg.sender) {
1684             revert OnlyOwner();
1685         }
1686     }
1687 
1688     /**
1689      * @dev Leaves the contract without owner. It will not be possible to call
1690      * `onlyOwner` functions anymore. Can only be called by the current owner.
1691      *
1692      * NOTE: Renouncing ownership will leave the contract without an owner,
1693      * thereby removing any functionality that is only available to the owner.
1694      */
1695     function renounceOwnership() public virtual onlyOwner {
1696         _transferOwnership(address(0));
1697     }
1698 
1699     /**
1700      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1701      * Internal function without access restriction.
1702      */
1703     function _transferOwnership(address newOwner) internal virtual {
1704         address oldOwner = _owner;
1705         _owner = newOwner;
1706         emit OwnershipTransferred(oldOwner, newOwner);
1707     }
1708 }
1709 
1710 
1711 // File src/ERC721ContractMetadata.sol
1712 
1713  
1714 pragma solidity 0.8.17;
1715 
1716 /**
1717  * @title  ERC721ContractMetadata
1718  * @author James Wenzel (emo.eth)
1719  * @author Ryan Ghods (ralxz.eth)
1720  * @author Stephan Min (stephanm.eth)
1721  * @notice ERC721ContractMetadata is a token contract that extends ERC721A
1722  *         with additional metadata and ownership capabilities.
1723  */
1724 contract ERC721ContractMetadata is
1725     ERC721A,
1726     TwoStepOwnable,
1727     ISeaDropTokenContractMetadata
1728 {
1729     /// @notice Track the max supply.
1730     uint256 _maxSupply;
1731 
1732     /// @notice Track the base URI for token metadata.
1733     string _tokenBaseURI;
1734 
1735     /// @notice Track the contract URI for contract metadata.
1736     string _contractURI;
1737 
1738     /// @notice Track the provenance hash for guaranteeing metadata order
1739     ///         for random reveals.
1740     bytes32 _provenanceHash;
1741 
1742     /// @notice Track the royalty info: address to receive royalties, and
1743     ///         royalty basis points.
1744     RoyaltyInfo _royaltyInfo;
1745 
1746     /**
1747      * @dev Reverts if the sender is not the owner or the contract itself.
1748      *      This function is inlined instead of being a modifier
1749      *      to save contract space from being inlined N times.
1750      */
1751     function _onlyOwnerOrSelf() internal view {
1752         if (
1753             _cast(msg.sender == owner()) | _cast(msg.sender == address(this)) ==
1754             0
1755         ) {
1756             revert OnlyOwner();
1757         }
1758     }
1759 
1760     /**
1761      * @notice Deploy the token contract with its name and symbol.
1762      */
1763     constructor(string memory name, string memory symbol)
1764         ERC721A(name, symbol)
1765     {}
1766 
1767     /**
1768      * @notice Sets the base URI for the token metadata and emits an event.
1769      *
1770      * @param newBaseURI The new base URI to set.
1771      */
1772     function setBaseURI(string calldata newBaseURI) external override {
1773         // Ensure the sender is only the owner or contract itself.
1774         _onlyOwnerOrSelf();
1775 
1776         // Set the new base URI.
1777         _tokenBaseURI = newBaseURI;
1778 
1779         // Emit an event with the update.
1780         if (totalSupply() != 0) {
1781             emit BatchMetadataUpdate(1, _nextTokenId() - 1);
1782         }
1783     }
1784 
1785     /**
1786      * @notice Sets the contract URI for contract metadata.
1787      *
1788      * @param newContractURI The new contract URI.
1789      */
1790     function setContractURI(string calldata newContractURI) external override {
1791         // Ensure the sender is only the owner or contract itself.
1792         _onlyOwnerOrSelf();
1793 
1794         // Set the new contract URI.
1795         _contractURI = newContractURI;
1796 
1797         // Emit an event with the update.
1798         emit ContractURIUpdated(newContractURI);
1799     }
1800 
1801     /**
1802      * @notice Emit an event notifying metadata updates for
1803      *         a range of token ids, according to EIP-4906.
1804      *
1805      * @param fromTokenId The start token id.
1806      * @param toTokenId   The end token id.
1807      */
1808     function emitBatchMetadataUpdate(uint256 fromTokenId, uint256 toTokenId)
1809         external
1810     {
1811         // Ensure the sender is only the owner or contract itself.
1812         _onlyOwnerOrSelf();
1813 
1814         // Emit an event with the update.
1815         emit BatchMetadataUpdate(fromTokenId, toTokenId);
1816     }
1817 
1818     /**
1819      * @notice Sets the max token supply and emits an event.
1820      *
1821      * @param newMaxSupply The new max supply to set.
1822      */
1823     function setMaxSupply(uint256 newMaxSupply) external {
1824         // Ensure the sender is only the owner or contract itself.
1825         _onlyOwnerOrSelf();
1826 
1827         // Ensure the max supply does not exceed the maximum value of uint64.
1828         if (newMaxSupply > 2**64 - 1) {
1829             revert CannotExceedMaxSupplyOfUint64(newMaxSupply);
1830         }
1831 
1832         // Set the new max supply.
1833         _maxSupply = newMaxSupply;
1834 
1835         // Emit an event with the update.
1836         emit MaxSupplyUpdated(newMaxSupply);
1837     }
1838 
1839     /**
1840      * @notice Sets the provenance hash and emits an event.
1841      *
1842      *         The provenance hash is used for random reveals, which
1843      *         is a hash of the ordered metadata to show it has not been
1844      *         modified after mint started.
1845      *
1846      *         This function will revert after the first item has been minted.
1847      *
1848      * @param newProvenanceHash The new provenance hash to set.
1849      */
1850     function setProvenanceHash(bytes32 newProvenanceHash) external {
1851         // Ensure the sender is only the owner or contract itself.
1852         _onlyOwnerOrSelf();
1853 
1854         // Revert if any items have been minted.
1855         if (_totalMinted() > 0) {
1856             revert ProvenanceHashCannotBeSetAfterMintStarted();
1857         }
1858 
1859         // Keep track of the old provenance hash for emitting with the event.
1860         bytes32 oldProvenanceHash = _provenanceHash;
1861 
1862         // Set the new provenance hash.
1863         _provenanceHash = newProvenanceHash;
1864 
1865         // Emit an event with the update.
1866         emit ProvenanceHashUpdated(oldProvenanceHash, newProvenanceHash);
1867     }
1868 
1869     /**
1870      * @notice Sets the address and basis points for royalties.
1871      *
1872      * @param newInfo The struct to configure royalties.
1873      */
1874     function setRoyaltyInfo(RoyaltyInfo calldata newInfo) external {
1875         // Ensure the sender is only the owner or contract itself.
1876         _onlyOwnerOrSelf();
1877 
1878         // Revert if the new royalty address is the zero address.
1879         if (newInfo.royaltyAddress == address(0)) {
1880             revert RoyaltyAddressCannotBeZeroAddress();
1881         }
1882 
1883         // Revert if the new basis points is greater than 10_000.
1884         if (newInfo.royaltyBps > 10_000) {
1885             revert InvalidRoyaltyBasisPoints(newInfo.royaltyBps);
1886         }
1887 
1888         // Set the new royalty info.
1889         _royaltyInfo = newInfo;
1890 
1891         // Emit an event with the updated params.
1892         emit RoyaltyInfoUpdated(newInfo.royaltyAddress, newInfo.royaltyBps);
1893     }
1894 
1895     /**
1896      * @notice Returns the base URI for token metadata.
1897      */
1898     function baseURI() external view override returns (string memory) {
1899         return _baseURI();
1900     }
1901 
1902     /**
1903      * @notice Returns the base URI for the contract, which ERC721A uses
1904      *         to return tokenURI.
1905      */
1906     function _baseURI() internal view virtual override returns (string memory) {
1907         return _tokenBaseURI;
1908     }
1909 
1910     /**
1911      * @notice Returns the contract URI for contract metadata.
1912      */
1913     function contractURI() external view override returns (string memory) {
1914         return _contractURI;
1915     }
1916 
1917     /**
1918      * @notice Returns the max token supply.
1919      */
1920     function maxSupply() public view returns (uint256) {
1921         return _maxSupply;
1922     }
1923 
1924     /**
1925      * @notice Returns the provenance hash.
1926      *         The provenance hash is used for random reveals, which
1927      *         is a hash of the ordered metadata to show it is unmodified
1928      *         after mint has started.
1929      */
1930     function provenanceHash() external view override returns (bytes32) {
1931         return _provenanceHash;
1932     }
1933 
1934     /**
1935      * @notice Returns the address that receives royalties.
1936      */
1937     function royaltyAddress() external view returns (address) {
1938         return _royaltyInfo.royaltyAddress;
1939     }
1940 
1941     /**
1942      * @notice Returns the royalty basis points out of 10_000.
1943      */
1944     function royaltyBasisPoints() external view returns (uint256) {
1945         return _royaltyInfo.royaltyBps;
1946     }
1947 
1948     /**
1949      * @notice Called with the sale price to determine how much royalty
1950      *         is owed and to whom.
1951      *
1952      * @ param  _tokenId     The NFT asset queried for royalty information.
1953      * @param  _salePrice    The sale price of the NFT asset specified by
1954      *                       _tokenId.
1955      *
1956      * @return receiver      Address of who should be sent the royalty payment.
1957      * @return royaltyAmount The royalty payment amount for _salePrice.
1958      */
1959     function royaltyInfo(
1960         uint256, /* _tokenId */
1961         uint256 _salePrice
1962     ) external view returns (address receiver, uint256 royaltyAmount) {
1963         // Put the royalty info on the stack for more efficient access.
1964         RoyaltyInfo storage info = _royaltyInfo;
1965 
1966         // Set the royalty amount to the sale price times the royalty basis
1967         // points divided by 10_000.
1968         royaltyAmount = (_salePrice * info.royaltyBps) / 10_000;
1969 
1970         // Set the receiver of the royalty.
1971         receiver = info.royaltyAddress;
1972     }
1973 
1974     /**
1975      * @notice Returns whether the interface is supported.
1976      *
1977      * @param interfaceId The interface id to check against.
1978      */
1979     function supportsInterface(bytes4 interfaceId)
1980         public
1981         view
1982         virtual
1983         override(IERC165, ERC721A)
1984         returns (bool)
1985     {
1986         return
1987             interfaceId == type(IERC2981).interfaceId ||
1988             interfaceId == 0x49064906 || // ERC-4906
1989             super.supportsInterface(interfaceId);
1990     }
1991 
1992     /**
1993      * @dev Internal pure function to cast a `bool` value to a `uint256` value.
1994      *
1995      * @param b The `bool` value to cast.
1996      *
1997      * @return u The `uint256` value.
1998      */
1999     function _cast(bool b) internal pure returns (uint256 u) {
2000         assembly {
2001             u := b
2002         }
2003     }
2004 }
2005 
2006 
2007 // File src/lib/SeaDropStructs.sol
2008 
2009  
2010 pragma solidity 0.8.17;
2011 
2012 /**
2013  * @notice A struct defining public drop data.
2014  *         Designed to fit efficiently in one storage slot.
2015  * 
2016  * @param mintPrice                The mint price per token. (Up to 1.2m
2017  *                                 of native token, e.g. ETH, MATIC)
2018  * @param startTime                The start time, ensure this is not zero.
2019  * @param endTIme                  The end time, ensure this is not zero.
2020  * @param maxTotalMintableByWallet Maximum total number of mints a user is
2021  *                                 allowed. (The limit for this field is
2022  *                                 2^16 - 1)
2023  * @param feeBps                   Fee out of 10_000 basis points to be
2024  *                                 collected.
2025  * @param restrictFeeRecipients    If false, allow any fee recipient;
2026  *                                 if true, check fee recipient is allowed.
2027  */
2028 struct PublicDrop {
2029     uint80 mintPrice; // 80/256 bits
2030     uint48 startTime; // 128/256 bits
2031     uint48 endTime; // 176/256 bits
2032     uint16 maxTotalMintableByWallet; // 224/256 bits
2033     uint16 feeBps; // 240/256 bits
2034     bool restrictFeeRecipients; // 248/256 bits
2035 }
2036 
2037 /**
2038  * @notice A struct defining token gated drop stage data.
2039  *         Designed to fit efficiently in one storage slot.
2040  * 
2041  * @param mintPrice                The mint price per token. (Up to 1.2m 
2042  *                                 of native token, e.g.: ETH, MATIC)
2043  * @param maxTotalMintableByWallet Maximum total number of mints a user is
2044  *                                 allowed. (The limit for this field is
2045  *                                 2^16 - 1)
2046  * @param startTime                The start time, ensure this is not zero.
2047  * @param endTime                  The end time, ensure this is not zero.
2048  * @param dropStageIndex           The drop stage index to emit with the event
2049  *                                 for analytical purposes. This should be 
2050  *                                 non-zero since the public mint emits
2051  *                                 with index zero.
2052  * @param maxTokenSupplyForStage   The limit of token supply this stage can
2053  *                                 mint within. (The limit for this field is
2054  *                                 2^16 - 1)
2055  * @param feeBps                   Fee out of 10_000 basis points to be
2056  *                                 collected.
2057  * @param restrictFeeRecipients    If false, allow any fee recipient;
2058  *                                 if true, check fee recipient is allowed.
2059  */
2060 struct TokenGatedDropStage {
2061     uint80 mintPrice; // 80/256 bits
2062     uint16 maxTotalMintableByWallet; // 96/256 bits
2063     uint48 startTime; // 144/256 bits
2064     uint48 endTime; // 192/256 bits
2065     uint8 dropStageIndex; // non-zero. 200/256 bits
2066     uint32 maxTokenSupplyForStage; // 232/256 bits
2067     uint16 feeBps; // 248/256 bits
2068     bool restrictFeeRecipients; // 256/256 bits
2069 }
2070 
2071 /**
2072  * @notice A struct defining mint params for an allow list.
2073  *         An allow list leaf will be composed of `msg.sender` and
2074  *         the following params.
2075  * 
2076  *         Note: Since feeBps is encoded in the leaf, backend should ensure
2077  *         that feeBps is acceptable before generating a proof.
2078  * 
2079  * @param mintPrice                The mint price per token.
2080  * @param maxTotalMintableByWallet Maximum total number of mints a user is
2081  *                                 allowed.
2082  * @param startTime                The start time, ensure this is not zero.
2083  * @param endTime                  The end time, ensure this is not zero.
2084  * @param dropStageIndex           The drop stage index to emit with the event
2085  *                                 for analytical purposes. This should be
2086  *                                 non-zero since the public mint emits with
2087  *                                 index zero.
2088  * @param maxTokenSupplyForStage   The limit of token supply this stage can
2089  *                                 mint within.
2090  * @param feeBps                   Fee out of 10_000 basis points to be
2091  *                                 collected.
2092  * @param restrictFeeRecipients    If false, allow any fee recipient;
2093  *                                 if true, check fee recipient is allowed.
2094  */
2095 struct MintParams {
2096     uint256 mintPrice; 
2097     uint256 maxTotalMintableByWallet;
2098     uint256 startTime;
2099     uint256 endTime;
2100     uint256 dropStageIndex; // non-zero
2101     uint256 maxTokenSupplyForStage;
2102     uint256 feeBps;
2103     bool restrictFeeRecipients;
2104 }
2105 
2106 /**
2107  * @notice A struct defining token gated mint params.
2108  * 
2109  * @param allowedNftToken    The allowed nft token contract address.
2110  * @param allowedNftTokenIds The token ids to redeem.
2111  */
2112 struct TokenGatedMintParams {
2113     address allowedNftToken;
2114     uint256[] allowedNftTokenIds;
2115 }
2116 
2117 /**
2118  * @notice A struct defining allow list data (for minting an allow list).
2119  * 
2120  * @param merkleRoot    The merkle root for the allow list.
2121  * @param publicKeyURIs If the allowListURI is encrypted, a list of URIs
2122  *                      pointing to the public keys. Empty if unencrypted.
2123  * @param allowListURI  The URI for the allow list.
2124  */
2125 struct AllowListData {
2126     bytes32 merkleRoot;
2127     string[] publicKeyURIs;
2128     string allowListURI;
2129 }
2130 
2131 /**
2132  * @notice A struct defining minimum and maximum parameters to validate for 
2133  *         signed mints, to minimize negative effects of a compromised signer.
2134  *
2135  * @param minMintPrice                The minimum mint price allowed.
2136  * @param maxMaxTotalMintableByWallet The maximum total number of mints allowed
2137  *                                    by a wallet.
2138  * @param minStartTime                The minimum start time allowed.
2139  * @param maxEndTime                  The maximum end time allowed.
2140  * @param maxMaxTokenSupplyForStage   The maximum token supply allowed.
2141  * @param minFeeBps                   The minimum fee allowed.
2142  * @param maxFeeBps                   The maximum fee allowed.
2143  */
2144 struct SignedMintValidationParams {
2145     uint80 minMintPrice; // 80/256 bits
2146     uint24 maxMaxTotalMintableByWallet; // 104/256 bits
2147     uint40 minStartTime; // 144/256 bits
2148     uint40 maxEndTime; // 184/256 bits
2149     uint40 maxMaxTokenSupplyForStage; // 224/256 bits
2150     uint16 minFeeBps; // 240/256 bits
2151     uint16 maxFeeBps; // 256/256 bits
2152 }
2153 
2154 
2155 // File src/interfaces/INonFungibleSeaDropToken.sol
2156 
2157  
2158 pragma solidity 0.8.17;
2159 
2160 interface INonFungibleSeaDropToken is ISeaDropTokenContractMetadata {
2161     /**
2162      * @dev Revert with an error if a contract is not an allowed
2163      *      SeaDrop address.
2164      */
2165     error OnlyAllowedSeaDrop();
2166 
2167     /**
2168      * @dev Emit an event when allowed SeaDrop contracts are updated.
2169      */
2170     event AllowedSeaDropUpdated(address[] allowedSeaDrop);
2171 
2172     /**
2173      * @notice Update the allowed SeaDrop contracts.
2174      *         Only the owner or administrator can use this function.
2175      *
2176      * @param allowedSeaDrop The allowed SeaDrop addresses.
2177      */
2178     function updateAllowedSeaDrop(address[] calldata allowedSeaDrop) external;
2179 
2180     /**
2181      * @notice Mint tokens, restricted to the SeaDrop contract.
2182      *
2183      * @dev    NOTE: If a token registers itself with multiple SeaDrop
2184      *         contracts, the implementation of this function should guard
2185      *         against reentrancy. If the implementing token uses
2186      *         _safeMint(), or a feeRecipient with a malicious receive() hook
2187      *         is specified, the token or fee recipients may be able to execute
2188      *         another mint in the same transaction via a separate SeaDrop
2189      *         contract.
2190      *         This is dangerous if an implementing token does not correctly
2191      *         update the minterNumMinted and currentTotalSupply values before
2192      *         transferring minted tokens, as SeaDrop references these values
2193      *         to enforce token limits on a per-wallet and per-stage basis.
2194      *
2195      * @param minter   The address to mint to.
2196      * @param quantity The number of tokens to mint.
2197      */
2198     function mintSeaDrop(address minter, uint256 quantity) external;
2199 
2200     /**
2201      * @notice Returns a set of mint stats for the address.
2202      *         This assists SeaDrop in enforcing maxSupply,
2203      *         maxTotalMintableByWallet, and maxTokenSupplyForStage checks.
2204      *
2205      * @dev    NOTE: Implementing contracts should always update these numbers
2206      *         before transferring any tokens with _safeMint() to mitigate
2207      *         consequences of malicious onERC721Received() hooks.
2208      *
2209      * @param minter The minter address.
2210      */
2211     function getMintStats(address minter)
2212         external
2213         view
2214         returns (
2215             uint256 minterNumMinted,
2216             uint256 currentTotalSupply,
2217             uint256 maxSupply
2218         );
2219 
2220     /**
2221      * @notice Update the public drop data for this nft contract on SeaDrop.
2222      *         Only the owner or administrator can use this function.
2223      *
2224      *         The administrator can only update `feeBps`.
2225      *
2226      * @param seaDropImpl The allowed SeaDrop contract.
2227      * @param publicDrop  The public drop data.
2228      */
2229     function updatePublicDrop(
2230         address seaDropImpl,
2231         PublicDrop calldata publicDrop
2232     ) external;
2233 
2234     /**
2235      * @notice Update the allow list data for this nft contract on SeaDrop.
2236      *         Only the owner or administrator can use this function.
2237      *
2238      * @param seaDropImpl   The allowed SeaDrop contract.
2239      * @param allowListData The allow list data.
2240      */
2241     function updateAllowList(
2242         address seaDropImpl,
2243         AllowListData calldata allowListData
2244     ) external;
2245 
2246     /**
2247      * @notice Update the token gated drop stage data for this nft contract
2248      *         on SeaDrop.
2249      *         Only the owner or administrator can use this function.
2250      *
2251      *         The administrator, when present, must first set `feeBps`.
2252      *
2253      *         Note: If two INonFungibleSeaDropToken tokens are doing
2254      *         simultaneous token gated drop promotions for each other,
2255      *         they can be minted by the same actor until
2256      *         `maxTokenSupplyForStage` is reached. Please ensure the
2257      *         `allowedNftToken` is not running an active drop during the
2258      *         `dropStage` time period.
2259      *
2260      *
2261      * @param seaDropImpl     The allowed SeaDrop contract.
2262      * @param allowedNftToken The allowed nft token.
2263      * @param dropStage       The token gated drop stage data.
2264      */
2265     function updateTokenGatedDrop(
2266         address seaDropImpl,
2267         address allowedNftToken,
2268         TokenGatedDropStage calldata dropStage
2269     ) external;
2270 
2271     /**
2272      * @notice Update the drop URI for this nft contract on SeaDrop.
2273      *         Only the owner or administrator can use this function.
2274      *
2275      * @param seaDropImpl The allowed SeaDrop contract.
2276      * @param dropURI     The new drop URI.
2277      */
2278     function updateDropURI(address seaDropImpl, string calldata dropURI)
2279         external;
2280 
2281     /**
2282      * @notice Update the creator payout address for this nft contract on
2283      *         SeaDrop.
2284      *         Only the owner can set the creator payout address.
2285      *
2286      * @param seaDropImpl   The allowed SeaDrop contract.
2287      * @param payoutAddress The new payout address.
2288      */
2289     function updateCreatorPayoutAddress(
2290         address seaDropImpl,
2291         address payoutAddress
2292     ) external;
2293 
2294     /**
2295      * @notice Update the allowed fee recipient for this nft contract
2296      *         on SeaDrop.
2297      *         Only the administrator can set the allowed fee recipient.
2298      *
2299      * @param seaDropImpl  The allowed SeaDrop contract.
2300      * @param feeRecipient The new fee recipient.
2301      */
2302     function updateAllowedFeeRecipient(
2303         address seaDropImpl,
2304         address feeRecipient,
2305         bool allowed
2306     ) external;
2307 
2308     /**
2309      * @notice Update the server-side signers for this nft contract
2310      *         on SeaDrop.
2311      *         Only the owner or administrator can use this function.
2312      *
2313      * @param seaDropImpl                The allowed SeaDrop contract.
2314      * @param signer                     The signer to update.
2315      * @param signedMintValidationParams Minimum and maximum parameters
2316      *                                   to enforce for signed mints.
2317      */
2318     function updateSignedMintValidationParams(
2319         address seaDropImpl,
2320         address signer,
2321         SignedMintValidationParams memory signedMintValidationParams
2322     ) external;
2323 
2324     /**
2325      * @notice Update the allowed payers for this nft contract on SeaDrop.
2326      *         Only the owner or administrator can use this function.
2327      *
2328      * @param seaDropImpl The allowed SeaDrop contract.
2329      * @param payer       The payer to update.
2330      * @param allowed     Whether the payer is allowed.
2331      */
2332     function updatePayer(
2333         address seaDropImpl,
2334         address payer,
2335         bool allowed
2336     ) external;
2337 }
2338 
2339 
2340 // File src/lib/SeaDropErrorsAndEvents.sol
2341 
2342  
2343 pragma solidity 0.8.17;
2344 
2345 interface SeaDropErrorsAndEvents {
2346     /**
2347      * @dev Revert with an error if the drop stage is not active.
2348      */
2349     error NotActive(
2350         uint256 currentTimestamp,
2351         uint256 startTimestamp,
2352         uint256 endTimestamp
2353     );
2354 
2355     /**
2356      * @dev Revert with an error if the mint quantity is zero.
2357      */
2358     error MintQuantityCannotBeZero();
2359 
2360     /**
2361      * @dev Revert with an error if the mint quantity exceeds the max allowed
2362      *      to be minted per wallet.
2363      */
2364     error MintQuantityExceedsMaxMintedPerWallet(uint256 total, uint256 allowed);
2365 
2366     /**
2367      * @dev Revert with an error if the mint quantity exceeds the max token
2368      *      supply.
2369      */
2370     error MintQuantityExceedsMaxSupply(uint256 total, uint256 maxSupply);
2371 
2372     /**
2373      * @dev Revert with an error if the mint quantity exceeds the max token
2374      *      supply for the stage.
2375      *      Note: The `maxTokenSupplyForStage` for public mint is
2376      *      always `type(uint).max`.
2377      */
2378     error MintQuantityExceedsMaxTokenSupplyForStage(
2379         uint256 total, 
2380         uint256 maxTokenSupplyForStage
2381     );
2382     
2383     /**
2384      * @dev Revert if the fee recipient is the zero address.
2385      */
2386     error FeeRecipientCannotBeZeroAddress();
2387 
2388     /**
2389      * @dev Revert if the fee recipient is not already included.
2390      */
2391     error FeeRecipientNotPresent();
2392 
2393     /**
2394      * @dev Revert if the fee basis points is greater than 10_000.
2395      */
2396     error InvalidFeeBps(uint256 feeBps);
2397 
2398     /**
2399      * @dev Revert if the fee recipient is already included.
2400      */
2401     error DuplicateFeeRecipient();
2402 
2403     /**
2404      * @dev Revert if the fee recipient is restricted and not allowed.
2405      */
2406     error FeeRecipientNotAllowed();
2407 
2408     /**
2409      * @dev Revert if the creator payout address is the zero address.
2410      */
2411     error CreatorPayoutAddressCannotBeZeroAddress();
2412 
2413     /**
2414      * @dev Revert with an error if the received payment is incorrect.
2415      */
2416     error IncorrectPayment(uint256 got, uint256 want);
2417 
2418     /**
2419      * @dev Revert with an error if the allow list proof is invalid.
2420      */
2421     error InvalidProof();
2422 
2423     /**
2424      * @dev Revert if a supplied signer address is the zero address.
2425      */
2426     error SignerCannotBeZeroAddress();
2427 
2428     /**
2429      * @dev Revert with an error if signer's signature is invalid.
2430      */
2431     error InvalidSignature(address recoveredSigner);
2432 
2433     /**
2434      * @dev Revert with an error if a signer is not included in
2435      *      the enumeration when removing.
2436      */
2437     error SignerNotPresent();
2438 
2439     /**
2440      * @dev Revert with an error if a payer is not included in
2441      *      the enumeration when removing.
2442      */
2443     error PayerNotPresent();
2444 
2445     /**
2446      * @dev Revert with an error if a payer is already included in mapping
2447      *      when adding.
2448      *      Note: only applies when adding a single payer, as duplicates in
2449      *      enumeration can be removed with updatePayer.
2450      */
2451     error DuplicatePayer();
2452 
2453     /**
2454      * @dev Revert with an error if the payer is not allowed. The minter must
2455      *      pay for their own mint.
2456      */
2457     error PayerNotAllowed();
2458 
2459     /**
2460      * @dev Revert if a supplied payer address is the zero address.
2461      */
2462     error PayerCannotBeZeroAddress();
2463 
2464     /**
2465      * @dev Revert with an error if the sender does not
2466      *      match the INonFungibleSeaDropToken interface.
2467      */
2468     error OnlyINonFungibleSeaDropToken(address sender);
2469 
2470     /**
2471      * @dev Revert with an error if the sender of a token gated supplied
2472      *      drop stage redeem is not the owner of the token.
2473      */
2474     error TokenGatedNotTokenOwner(
2475         address nftContract,
2476         address allowedNftToken,
2477         uint256 allowedNftTokenId
2478     );
2479 
2480     /**
2481      * @dev Revert with an error if the token id has already been used to
2482      *      redeem a token gated drop stage.
2483      */
2484     error TokenGatedTokenIdAlreadyRedeemed(
2485         address nftContract,
2486         address allowedNftToken,
2487         uint256 allowedNftTokenId
2488     );
2489 
2490     /**
2491      * @dev Revert with an error if an empty TokenGatedDropStage is provided
2492      *      for an already-empty TokenGatedDropStage.
2493      */
2494      error TokenGatedDropStageNotPresent();
2495 
2496     /**
2497      * @dev Revert with an error if an allowedNftToken is set to
2498      *      the zero address.
2499      */
2500      error TokenGatedDropAllowedNftTokenCannotBeZeroAddress();
2501 
2502     /**
2503      * @dev Revert with an error if an allowedNftToken is set to
2504      *      the drop token itself.
2505      */
2506      error TokenGatedDropAllowedNftTokenCannotBeDropToken();
2507 
2508 
2509     /**
2510      * @dev Revert with an error if supplied signed mint price is less than
2511      *      the minimum specified.
2512      */
2513     error InvalidSignedMintPrice(uint256 got, uint256 minimum);
2514 
2515     /**
2516      * @dev Revert with an error if supplied signed maxTotalMintableByWallet
2517      *      is greater than the maximum specified.
2518      */
2519     error InvalidSignedMaxTotalMintableByWallet(uint256 got, uint256 maximum);
2520 
2521     /**
2522      * @dev Revert with an error if supplied signed start time is less than
2523      *      the minimum specified.
2524      */
2525     error InvalidSignedStartTime(uint256 got, uint256 minimum);
2526     
2527     /**
2528      * @dev Revert with an error if supplied signed end time is greater than
2529      *      the maximum specified.
2530      */
2531     error InvalidSignedEndTime(uint256 got, uint256 maximum);
2532 
2533     /**
2534      * @dev Revert with an error if supplied signed maxTokenSupplyForStage
2535      *      is greater than the maximum specified.
2536      */
2537      error InvalidSignedMaxTokenSupplyForStage(uint256 got, uint256 maximum);
2538     
2539      /**
2540      * @dev Revert with an error if supplied signed feeBps is greater than
2541      *      the maximum specified, or less than the minimum.
2542      */
2543     error InvalidSignedFeeBps(uint256 got, uint256 minimumOrMaximum);
2544 
2545     /**
2546      * @dev Revert with an error if signed mint did not specify to restrict
2547      *      fee recipients.
2548      */
2549     error SignedMintsMustRestrictFeeRecipients();
2550 
2551     /**
2552      * @dev Revert with an error if a signature for a signed mint has already
2553      *      been used.
2554      */
2555     error SignatureAlreadyUsed();
2556 
2557     /**
2558      * @dev An event with details of a SeaDrop mint, for analytical purposes.
2559      * 
2560      * @param nftContract    The nft contract.
2561      * @param minter         The mint recipient.
2562      * @param feeRecipient   The fee recipient.
2563      * @param payer          The address who payed for the tx.
2564      * @param quantityMinted The number of tokens minted.
2565      * @param unitMintPrice  The amount paid for each token.
2566      * @param feeBps         The fee out of 10_000 basis points collected.
2567      * @param dropStageIndex The drop stage index. Items minted
2568      *                       through mintPublic() have
2569      *                       dropStageIndex of 0.
2570      */
2571     event SeaDropMint(
2572         address indexed nftContract,
2573         address indexed minter,
2574         address indexed feeRecipient,
2575         address payer,
2576         uint256 quantityMinted,
2577         uint256 unitMintPrice,
2578         uint256 feeBps,
2579         uint256 dropStageIndex
2580     );
2581 
2582     /**
2583      * @dev An event with updated public drop data for an nft contract.
2584      */
2585     event PublicDropUpdated(
2586         address indexed nftContract,
2587         PublicDrop publicDrop
2588     );
2589 
2590     /**
2591      * @dev An event with updated token gated drop stage data
2592      *      for an nft contract.
2593      */
2594     event TokenGatedDropStageUpdated(
2595         address indexed nftContract,
2596         address indexed allowedNftToken,
2597         TokenGatedDropStage dropStage
2598     );
2599 
2600     /**
2601      * @dev An event with updated allow list data for an nft contract.
2602      * 
2603      * @param nftContract        The nft contract.
2604      * @param previousMerkleRoot The previous allow list merkle root.
2605      * @param newMerkleRoot      The new allow list merkle root.
2606      * @param publicKeyURI       If the allow list is encrypted, the public key
2607      *                           URIs that can decrypt the list.
2608      *                           Empty if unencrypted.
2609      * @param allowListURI       The URI for the allow list.
2610      */
2611     event AllowListUpdated(
2612         address indexed nftContract,
2613         bytes32 indexed previousMerkleRoot,
2614         bytes32 indexed newMerkleRoot,
2615         string[] publicKeyURI,
2616         string allowListURI
2617     );
2618 
2619     /**
2620      * @dev An event with updated drop URI for an nft contract.
2621      */
2622     event DropURIUpdated(address indexed nftContract, string newDropURI);
2623 
2624     /**
2625      * @dev An event with the updated creator payout address for an nft
2626      *      contract.
2627      */
2628     event CreatorPayoutAddressUpdated(
2629         address indexed nftContract,
2630         address indexed newPayoutAddress
2631     );
2632 
2633     /**
2634      * @dev An event with the updated allowed fee recipient for an nft
2635      *      contract.
2636      */
2637     event AllowedFeeRecipientUpdated(
2638         address indexed nftContract,
2639         address indexed feeRecipient,
2640         bool indexed allowed
2641     );
2642 
2643     /**
2644      * @dev An event with the updated validation parameters for server-side
2645      *      signers.
2646      */
2647     event SignedMintValidationParamsUpdated(
2648         address indexed nftContract,
2649         address indexed signer,
2650         SignedMintValidationParams signedMintValidationParams
2651     );   
2652 
2653     /**
2654      * @dev An event with the updated payer for an nft contract.
2655      */
2656     event PayerUpdated(
2657         address indexed nftContract,
2658         address indexed payer,
2659         bool indexed allowed
2660     );
2661 }
2662 
2663 
2664 // File src/interfaces/ISeaDrop.sol
2665 
2666  
2667 pragma solidity 0.8.17;
2668 
2669 interface ISeaDrop is SeaDropErrorsAndEvents {
2670     /**
2671      * @notice Mint a public drop.
2672      *
2673      * @param nftContract      The nft contract to mint.
2674      * @param feeRecipient     The fee recipient.
2675      * @param minterIfNotPayer The mint recipient if different than the payer.
2676      * @param quantity         The number of tokens to mint.
2677      */
2678     function mintPublic(
2679         address nftContract,
2680         address feeRecipient,
2681         address minterIfNotPayer,
2682         uint256 quantity
2683     ) external payable;
2684 
2685     /**
2686      * @notice Mint from an allow list.
2687      *
2688      * @param nftContract      The nft contract to mint.
2689      * @param feeRecipient     The fee recipient.
2690      * @param minterIfNotPayer The mint recipient if different than the payer.
2691      * @param quantity         The number of tokens to mint.
2692      * @param mintParams       The mint parameters.
2693      * @param proof            The proof for the leaf of the allow list.
2694      */
2695     function mintAllowList(
2696         address nftContract,
2697         address feeRecipient,
2698         address minterIfNotPayer,
2699         uint256 quantity,
2700         MintParams calldata mintParams,
2701         bytes32[] calldata proof
2702     ) external payable;
2703 
2704     /**
2705      * @notice Mint with a server-side signature.
2706      *         Note that a signature can only be used once.
2707      *
2708      * @param nftContract      The nft contract to mint.
2709      * @param feeRecipient     The fee recipient.
2710      * @param minterIfNotPayer The mint recipient if different than the payer.
2711      * @param quantity         The number of tokens to mint.
2712      * @param mintParams       The mint parameters.
2713      * @param salt             The sale for the signed mint.
2714      * @param signature        The server-side signature, must be an allowed
2715      *                         signer.
2716      */
2717     function mintSigned(
2718         address nftContract,
2719         address feeRecipient,
2720         address minterIfNotPayer,
2721         uint256 quantity,
2722         MintParams calldata mintParams,
2723         uint256 salt,
2724         bytes calldata signature
2725     ) external payable;
2726 
2727     /**
2728      * @notice Mint as an allowed token holder.
2729      *         This will mark the token id as redeemed and will revert if the
2730      *         same token id is attempted to be redeemed twice.
2731      *
2732      * @param nftContract      The nft contract to mint.
2733      * @param feeRecipient     The fee recipient.
2734      * @param minterIfNotPayer The mint recipient if different than the payer.
2735      * @param mintParams       The token gated mint params.
2736      */
2737     function mintAllowedTokenHolder(
2738         address nftContract,
2739         address feeRecipient,
2740         address minterIfNotPayer,
2741         TokenGatedMintParams calldata mintParams
2742     ) external payable;
2743 
2744     /**
2745      * @notice Emits an event to notify update of the drop URI.
2746      *
2747      *         This method assume msg.sender is an nft contract and its
2748      *         ERC165 interface id matches INonFungibleSeaDropToken.
2749      *
2750      *         Note: Be sure only authorized users can call this from
2751      *         token contracts that implement INonFungibleSeaDropToken.
2752      *
2753      * @param dropURI The new drop URI.
2754      */
2755     function updateDropURI(string calldata dropURI) external;
2756 
2757     /**
2758      * @notice Updates the public drop data for the nft contract
2759      *         and emits an event.
2760      *
2761      *         This method assume msg.sender is an nft contract and its
2762      *         ERC165 interface id matches INonFungibleSeaDropToken.
2763      *
2764      *         Note: Be sure only authorized users can call this from
2765      *         token contracts that implement INonFungibleSeaDropToken.
2766      *
2767      * @param publicDrop The public drop data.
2768      */
2769     function updatePublicDrop(PublicDrop calldata publicDrop) external;
2770 
2771     /**
2772      * @notice Updates the allow list merkle root for the nft contract
2773      *         and emits an event.
2774      *
2775      *         This method assume msg.sender is an nft contract and its
2776      *         ERC165 interface id matches INonFungibleSeaDropToken.
2777      *
2778      *         Note: Be sure only authorized users can call this from
2779      *         token contracts that implement INonFungibleSeaDropToken.
2780      *
2781      * @param allowListData The allow list data.
2782      */
2783     function updateAllowList(AllowListData calldata allowListData) external;
2784 
2785     /**
2786      * @notice Updates the token gated drop stage for the nft contract
2787      *         and emits an event.
2788      *
2789      *         This method assume msg.sender is an nft contract and its
2790      *         ERC165 interface id matches INonFungibleSeaDropToken.
2791      *
2792      *         Note: Be sure only authorized users can call this from
2793      *         token contracts that implement INonFungibleSeaDropToken.
2794      *
2795      *         Note: If two INonFungibleSeaDropToken tokens are doing
2796      *         simultaneous token gated drop promotions for each other,
2797      *         they can be minted by the same actor until
2798      *         `maxTokenSupplyForStage` is reached. Please ensure the
2799      *         `allowedNftToken` is not running an active drop during
2800      *         the `dropStage` time period.
2801      *
2802      * @param allowedNftToken The token gated nft token.
2803      * @param dropStage       The token gated drop stage data.
2804      */
2805     function updateTokenGatedDrop(
2806         address allowedNftToken,
2807         TokenGatedDropStage calldata dropStage
2808     ) external;
2809 
2810     /**
2811      * @notice Updates the creator payout address and emits an event.
2812      *
2813      *         This method assume msg.sender is an nft contract and its
2814      *         ERC165 interface id matches INonFungibleSeaDropToken.
2815      *
2816      *         Note: Be sure only authorized users can call this from
2817      *         token contracts that implement INonFungibleSeaDropToken.
2818      *
2819      * @param payoutAddress The creator payout address.
2820      */
2821     function updateCreatorPayoutAddress(address payoutAddress) external;
2822 
2823     /**
2824      * @notice Updates the allowed fee recipient and emits an event.
2825      *
2826      *         This method assume msg.sender is an nft contract and its
2827      *         ERC165 interface id matches INonFungibleSeaDropToken.
2828      *
2829      *         Note: Be sure only authorized users can call this from
2830      *         token contracts that implement INonFungibleSeaDropToken.
2831      *
2832      * @param feeRecipient The fee recipient.
2833      * @param allowed      If the fee recipient is allowed.
2834      */
2835     function updateAllowedFeeRecipient(address feeRecipient, bool allowed)
2836         external;
2837 
2838     /**
2839      * @notice Updates the allowed server-side signers and emits an event.
2840      *
2841      *         This method assume msg.sender is an nft contract and its
2842      *         ERC165 interface id matches INonFungibleSeaDropToken.
2843      *
2844      *         Note: Be sure only authorized users can call this from
2845      *         token contracts that implement INonFungibleSeaDropToken.
2846      *
2847      * @param signer                     The signer to update.
2848      * @param signedMintValidationParams Minimum and maximum parameters
2849      *                                   to enforce for signed mints.
2850      */
2851     function updateSignedMintValidationParams(
2852         address signer,
2853         SignedMintValidationParams calldata signedMintValidationParams
2854     ) external;
2855 
2856     /**
2857      * @notice Updates the allowed payer and emits an event.
2858      *
2859      *         This method assume msg.sender is an nft contract and its
2860      *         ERC165 interface id matches INonFungibleSeaDropToken.
2861      *
2862      *         Note: Be sure only authorized users can call this from
2863      *         token contracts that implement INonFungibleSeaDropToken.
2864      *
2865      * @param payer   The payer to add or remove.
2866      * @param allowed Whether to add or remove the payer.
2867      */
2868     function updatePayer(address payer, bool allowed) external;
2869 
2870     /**
2871      * @notice Returns the public drop data for the nft contract.
2872      *
2873      * @param nftContract The nft contract.
2874      */
2875     function getPublicDrop(address nftContract)
2876         external
2877         view
2878         returns (PublicDrop memory);
2879 
2880     /**
2881      * @notice Returns the creator payout address for the nft contract.
2882      *
2883      * @param nftContract The nft contract.
2884      */
2885     function getCreatorPayoutAddress(address nftContract)
2886         external
2887         view
2888         returns (address);
2889 
2890     /**
2891      * @notice Returns the allow list merkle root for the nft contract.
2892      *
2893      * @param nftContract The nft contract.
2894      */
2895     function getAllowListMerkleRoot(address nftContract)
2896         external
2897         view
2898         returns (bytes32);
2899 
2900     /**
2901      * @notice Returns if the specified fee recipient is allowed
2902      *         for the nft contract.
2903      *
2904      * @param nftContract  The nft contract.
2905      * @param feeRecipient The fee recipient.
2906      */
2907     function getFeeRecipientIsAllowed(address nftContract, address feeRecipient)
2908         external
2909         view
2910         returns (bool);
2911 
2912     /**
2913      * @notice Returns an enumeration of allowed fee recipients for an
2914      *         nft contract when fee recipients are enforced
2915      *
2916      * @param nftContract The nft contract.
2917      */
2918     function getAllowedFeeRecipients(address nftContract)
2919         external
2920         view
2921         returns (address[] memory);
2922 
2923     /**
2924      * @notice Returns the server-side signers for the nft contract.
2925      *
2926      * @param nftContract The nft contract.
2927      */
2928     function getSigners(address nftContract)
2929         external
2930         view
2931         returns (address[] memory);
2932 
2933     /**
2934      * @notice Returns the struct of SignedMintValidationParams for a signer.
2935      *
2936      * @param nftContract The nft contract.
2937      * @param signer      The signer.
2938      */
2939     function getSignedMintValidationParams(address nftContract, address signer)
2940         external
2941         view
2942         returns (SignedMintValidationParams memory);
2943 
2944     /**
2945      * @notice Returns the payers for the nft contract.
2946      *
2947      * @param nftContract The nft contract.
2948      */
2949     function getPayers(address nftContract)
2950         external
2951         view
2952         returns (address[] memory);
2953 
2954     /**
2955      * @notice Returns if the specified payer is allowed
2956      *         for the nft contract.
2957      *
2958      * @param nftContract The nft contract.
2959      * @param payer       The payer.
2960      */
2961     function getPayerIsAllowed(address nftContract, address payer)
2962         external
2963         view
2964         returns (bool);
2965 
2966     /**
2967      * @notice Returns the allowed token gated drop tokens for the nft contract.
2968      *
2969      * @param nftContract The nft contract.
2970      */
2971     function getTokenGatedAllowedTokens(address nftContract)
2972         external
2973         view
2974         returns (address[] memory);
2975 
2976     /**
2977      * @notice Returns the token gated drop data for the nft contract
2978      *         and token gated nft.
2979      *
2980      * @param nftContract     The nft contract.
2981      * @param allowedNftToken The token gated nft token.
2982      */
2983     function getTokenGatedDrop(address nftContract, address allowedNftToken)
2984         external
2985         view
2986         returns (TokenGatedDropStage memory);
2987 
2988     /**
2989      * @notice Returns whether the token id for a token gated drop has been
2990      *         redeemed.
2991      *
2992      * @param nftContract       The nft contract.
2993      * @param allowedNftToken   The token gated nft token.
2994      * @param allowedNftTokenId The token gated nft token id to check.
2995      */
2996     function getAllowedNftTokenIdIsRedeemed(
2997         address nftContract,
2998         address allowedNftToken,
2999         uint256 allowedNftTokenId
3000     ) external view returns (bool);
3001 }
3002 
3003 
3004 // File src/lib/ERC721SeaDropStructsErrorsAndEvents.sol
3005 
3006  
3007 pragma solidity 0.8.17;
3008 
3009 interface ERC721SeaDropStructsErrorsAndEvents {
3010   /**
3011    * @notice Revert with an error if mint exceeds the max supply.
3012    */
3013   error MintQuantityExceedsMaxSupply(uint256 total, uint256 maxSupply);
3014 
3015   /**
3016    * @notice Revert with an error if the number of token gated 
3017    *         allowedNftTokens doesn't match the length of supplied
3018    *         drop stages.
3019    */
3020   error TokenGatedMismatch();
3021 
3022   /**
3023    *  @notice Revert with an error if the number of signers doesn't match
3024    *          the length of supplied signedMintValidationParams
3025    */
3026   error SignersMismatch();
3027 
3028   /**
3029    * @notice An event to signify that a SeaDrop token contract was deployed.
3030    */
3031   event SeaDropTokenDeployed();
3032 
3033   /**
3034    * @notice A struct to configure multiple contract options at a time.
3035    */
3036   struct MultiConfigureStruct {
3037     uint256 maxSupply;
3038     string baseURI;
3039     string contractURI;
3040     address seaDropImpl;
3041     PublicDrop publicDrop;
3042     string dropURI;
3043     AllowListData allowListData;
3044     address creatorPayoutAddress;
3045     bytes32 provenanceHash;
3046 
3047     address[] allowedFeeRecipients;
3048     address[] disallowedFeeRecipients;
3049 
3050     address[] allowedPayers;
3051     address[] disallowedPayers;
3052 
3053     // Token-gated
3054     address[] tokenGatedAllowedNftTokens;
3055     TokenGatedDropStage[] tokenGatedDropStages;
3056     address[] disallowedTokenGatedAllowedNftTokens;
3057 
3058     // Server-signed
3059     address[] signers;
3060     SignedMintValidationParams[] signedMintValidationParams;
3061     address[] disallowedSigners;
3062   }
3063 }
3064 
3065 
3066 // File lib/operator-filter-registry/src/IOperatorFilterRegistry.sol
3067 
3068  
3069 pragma solidity ^0.8.13;
3070 
3071 interface IOperatorFilterRegistry {
3072     /**
3073      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
3074      *         true if supplied registrant address is not registered.
3075      */
3076     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
3077 
3078     /**
3079      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
3080      */
3081     function register(address registrant) external;
3082 
3083     /**
3084      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
3085      */
3086     function registerAndSubscribe(address registrant, address subscription) external;
3087 
3088     /**
3089      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
3090      *         address without subscribing.
3091      */
3092     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
3093 
3094     /**
3095      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
3096      *         Note that this does not remove any filtered addresses or codeHashes.
3097      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
3098      */
3099     function unregister(address addr) external;
3100 
3101     /**
3102      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
3103      */
3104     function updateOperator(address registrant, address operator, bool filtered) external;
3105 
3106     /**
3107      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
3108      */
3109     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
3110 
3111     /**
3112      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
3113      */
3114     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
3115 
3116     /**
3117      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
3118      */
3119     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
3120 
3121     /**
3122      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
3123      *         subscription if present.
3124      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
3125      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
3126      *         used.
3127      */
3128     function subscribe(address registrant, address registrantToSubscribe) external;
3129 
3130     /**
3131      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
3132      */
3133     function unsubscribe(address registrant, bool copyExistingEntries) external;
3134 
3135     /**
3136      * @notice Get the subscription address of a given registrant, if any.
3137      */
3138     function subscriptionOf(address addr) external returns (address registrant);
3139 
3140     /**
3141      * @notice Get the set of addresses subscribed to a given registrant.
3142      *         Note that order is not guaranteed as updates are made.
3143      */
3144     function subscribers(address registrant) external returns (address[] memory);
3145 
3146     /**
3147      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
3148      *         Note that order is not guaranteed as updates are made.
3149      */
3150     function subscriberAt(address registrant, uint256 index) external returns (address);
3151 
3152     /**
3153      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
3154      */
3155     function copyEntriesOf(address registrant, address registrantToCopy) external;
3156 
3157     /**
3158      * @notice Returns true if operator is filtered by a given address or its subscription.
3159      */
3160     function isOperatorFiltered(address registrant, address operator) external returns (bool);
3161 
3162     /**
3163      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
3164      */
3165     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
3166 
3167     /**
3168      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
3169      */
3170     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
3171 
3172     /**
3173      * @notice Returns a list of filtered operators for a given address or its subscription.
3174      */
3175     function filteredOperators(address addr) external returns (address[] memory);
3176 
3177     /**
3178      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
3179      *         Note that order is not guaranteed as updates are made.
3180      */
3181     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
3182 
3183     /**
3184      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
3185      *         its subscription.
3186      *         Note that order is not guaranteed as updates are made.
3187      */
3188     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
3189 
3190     /**
3191      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
3192      *         its subscription.
3193      *         Note that order is not guaranteed as updates are made.
3194      */
3195     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
3196 
3197     /**
3198      * @notice Returns true if an address has registered
3199      */
3200     function isRegistered(address addr) external returns (bool);
3201 
3202     /**
3203      * @dev Convenience method to compute the code hash of an arbitrary contract
3204      */
3205     function codeHashOf(address addr) external returns (bytes32);
3206 }
3207 
3208 
3209 // File lib/operator-filter-registry/src/lib/Constants.sol
3210 
3211  
3212 pragma solidity ^0.8.17;
3213 
3214 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
3215 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
3216 
3217 
3218 // File lib/operator-filter-registry/src/OperatorFilterer.sol
3219 
3220  
3221 pragma solidity ^0.8.13;
3222 
3223 
3224 /**
3225  * @title  OperatorFilterer
3226  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
3227  *         registrant's entries in the OperatorFilterRegistry.
3228  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
3229  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
3230  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
3231  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
3232  *         administration methods on the contract itself to interact with the registry otherwise the subscription
3233  *         will be locked to the options set during construction.
3234  */
3235 
3236 abstract contract OperatorFilterer {
3237     /// @dev Emitted when an operator is not allowed.
3238     error OperatorNotAllowed(address operator);
3239 
3240     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
3241         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
3242 
3243     /// @dev The constructor that is called when the contract is being deployed.
3244     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
3245         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
3246         // will not revert, but the contract will need to be registered with the registry once it is deployed in
3247         // order for the modifier to filter addresses.
3248         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3249             if (subscribe) {
3250                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
3251             } else {
3252                 if (subscriptionOrRegistrantToCopy != address(0)) {
3253                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
3254                 } else {
3255                     OPERATOR_FILTER_REGISTRY.register(address(this));
3256                 }
3257             }
3258         }
3259     }
3260 
3261     /**
3262      * @dev A helper function to check if an operator is allowed.
3263      */
3264     modifier onlyAllowedOperator(address from) virtual {
3265         // Allow spending tokens from addresses with balance
3266         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
3267         // from an EOA.
3268         if (from != msg.sender) {
3269             _checkFilterOperator(msg.sender);
3270         }
3271         _;
3272     }
3273 
3274     /**
3275      * @dev A helper function to check if an operator approval is allowed.
3276      */
3277     modifier onlyAllowedOperatorApproval(address operator) virtual {
3278         _checkFilterOperator(operator);
3279         _;
3280     }
3281 
3282     /**
3283      * @dev A helper function to check if an operator is allowed.
3284      */
3285     function _checkFilterOperator(address operator) internal view virtual {
3286         // Check registry code length to facilitate testing in environments without a deployed registry.
3287         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3288             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
3289             // may specify their own OperatorFilterRegistry implementations, which may behave differently
3290             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
3291                 revert OperatorNotAllowed(operator);
3292             }
3293         }
3294     }
3295 }
3296 
3297 
3298 // File lib/operator-filter-registry/src/DefaultOperatorFilterer.sol
3299 
3300  
3301 pragma solidity ^0.8.13;
3302 
3303 
3304 /**
3305  * @title  DefaultOperatorFilterer
3306  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
3307  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
3308  *         administration methods on the contract itself to interact with the registry otherwise the subscription
3309  *         will be locked to the options set during construction.
3310  */
3311 
3312 abstract contract DefaultOperatorFilterer is OperatorFilterer {
3313     /// @dev The constructor that is called when the contract is being deployed.
3314     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
3315 }
3316 
3317 
3318 // File lib/solmate/src/utils/ReentrancyGuard.sol
3319 
3320  
3321 pragma solidity >=0.8.0;
3322 
3323 /// @notice Gas optimized reentrancy protection for smart contracts.
3324 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
3325 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
3326 abstract contract ReentrancyGuard {
3327     uint256 private reentrancyStatus = 1;
3328 
3329     modifier nonReentrant() {
3330         require(reentrancyStatus == 1, "REENTRANCY");
3331 
3332         reentrancyStatus = 2;
3333 
3334         _;
3335 
3336         reentrancyStatus = 1;
3337     }
3338 }
3339 
3340 
3341 // File src/ERC721SeaDrop.sol
3342 
3343  
3344 pragma solidity 0.8.17;
3345 
3346 /**
3347  * @title  ERC721SeaDrop
3348  * @author James Wenzel (emo.eth)
3349  * @author Ryan Ghods (ralxz.eth)
3350  * @author Stephan Min (stephanm.eth)
3351  * @author Michael Cohen (notmichael.eth)
3352  * @notice ERC721SeaDrop is a token contract that contains methods
3353  *         to properly interact with SeaDrop.
3354  */
3355 contract ERC721SeaDrop is
3356     ERC721ContractMetadata,
3357     INonFungibleSeaDropToken,
3358     ERC721SeaDropStructsErrorsAndEvents,
3359     ReentrancyGuard,
3360     DefaultOperatorFilterer
3361 {
3362     /// @notice Track the allowed SeaDrop addresses.
3363     mapping(address => bool) internal _allowedSeaDrop;
3364 
3365     /// @notice Track the enumerated allowed SeaDrop addresses.
3366     address[] internal _enumeratedAllowedSeaDrop;
3367 
3368     /**
3369      * @dev Reverts if not an allowed SeaDrop contract.
3370      *      This function is inlined instead of being a modifier
3371      *      to save contract space from being inlined N times.
3372      *
3373      * @param seaDrop The SeaDrop address to check if allowed.
3374      */
3375     function _onlyAllowedSeaDrop(address seaDrop) internal view {
3376         if (_allowedSeaDrop[seaDrop] != true) {
3377             revert OnlyAllowedSeaDrop();
3378         }
3379     }
3380 
3381     /**
3382      * @notice Deploy the token contract with its name, symbol,
3383      *         and allowed SeaDrop addresses.
3384      */
3385     constructor(
3386         string memory name,
3387         string memory symbol,
3388         address[] memory allowedSeaDrop
3389     ) ERC721ContractMetadata(name, symbol) {
3390         // Put the length on the stack for more efficient access.
3391         uint256 allowedSeaDropLength = allowedSeaDrop.length;
3392 
3393         // Set the mapping for allowed SeaDrop contracts.
3394         for (uint256 i = 0; i < allowedSeaDropLength; ) {
3395             _allowedSeaDrop[allowedSeaDrop[i]] = true;
3396             unchecked {
3397                 ++i;
3398             }
3399         }
3400 
3401         // Set the enumeration.
3402         _enumeratedAllowedSeaDrop = allowedSeaDrop;
3403 
3404         // Emit an event noting the contract deployment.
3405         emit SeaDropTokenDeployed();
3406     }
3407 
3408     /**
3409      * @notice Update the allowed SeaDrop contracts.
3410      *         Only the owner or administrator can use this function.
3411      *
3412      * @param allowedSeaDrop The allowed SeaDrop addresses.
3413      */
3414     function updateAllowedSeaDrop(address[] calldata allowedSeaDrop)
3415         external
3416         virtual
3417         override
3418         onlyOwner
3419     {
3420         _updateAllowedSeaDrop(allowedSeaDrop);
3421     }
3422 
3423     /**
3424      * @notice Internal function to update the allowed SeaDrop contracts.
3425      *
3426      * @param allowedSeaDrop The allowed SeaDrop addresses.
3427      */
3428     function _updateAllowedSeaDrop(address[] calldata allowedSeaDrop) internal {
3429         // Put the length on the stack for more efficient access.
3430         uint256 enumeratedAllowedSeaDropLength = _enumeratedAllowedSeaDrop
3431             .length;
3432         uint256 allowedSeaDropLength = allowedSeaDrop.length;
3433 
3434         // Reset the old mapping.
3435         for (uint256 i = 0; i < enumeratedAllowedSeaDropLength; ) {
3436             _allowedSeaDrop[_enumeratedAllowedSeaDrop[i]] = false;
3437             unchecked {
3438                 ++i;
3439             }
3440         }
3441 
3442         // Set the new mapping for allowed SeaDrop contracts.
3443         for (uint256 i = 0; i < allowedSeaDropLength; ) {
3444             _allowedSeaDrop[allowedSeaDrop[i]] = true;
3445             unchecked {
3446                 ++i;
3447             }
3448         }
3449 
3450         // Set the enumeration.
3451         _enumeratedAllowedSeaDrop = allowedSeaDrop;
3452 
3453         // Emit an event for the update.
3454         emit AllowedSeaDropUpdated(allowedSeaDrop);
3455     }
3456 
3457     /**
3458      * @dev Overrides the `_startTokenId` function from ERC721A
3459      *      to start at token id `1`.
3460      *
3461      *      This is to avoid future possible problems since `0` is usually
3462      *      used to signal values that have not been set or have been removed.
3463      */
3464     function _startTokenId() internal view virtual override returns (uint256) {
3465         return 1;
3466     }
3467 
3468     /**
3469      * @dev Overrides the `tokenURI()` function from ERC721A
3470      *      to return just the base URI if it is implied to not be a directory.
3471      *
3472      *      This is to help with ERC721 contracts in which the same token URI
3473      *      is desired for each token, such as when the tokenURI is 'unrevealed'.
3474      */
3475     function tokenURI(uint256 tokenId)
3476         public
3477         view
3478         virtual
3479         override
3480         returns (string memory)
3481     {
3482         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
3483 
3484         string memory baseURI = _baseURI();
3485 
3486         // Exit early if the baseURI is empty.
3487         if (bytes(baseURI).length == 0) {
3488             return "";
3489         }
3490 
3491         // Check if the last character in baseURI is a slash.
3492         if (bytes(baseURI)[bytes(baseURI).length - 1] != bytes("/")[0]) {
3493             return baseURI;
3494         }
3495 
3496         return string(abi.encodePacked(baseURI, _toString(tokenId)));
3497     }
3498 
3499     /**
3500      * @notice Mint tokens, restricted to the SeaDrop contract.
3501      *
3502      * @dev    NOTE: If a token registers itself with multiple SeaDrop
3503      *         contracts, the implementation of this function should guard
3504      *         against reentrancy. If the implementing token uses
3505      *         _safeMint(), or a feeRecipient with a malicious receive() hook
3506      *         is specified, the token or fee recipients may be able to execute
3507      *         another mint in the same transaction via a separate SeaDrop
3508      *         contract.
3509      *         This is dangerous if an implementing token does not correctly
3510      *         update the minterNumMinted and currentTotalSupply values before
3511      *         transferring minted tokens, as SeaDrop references these values
3512      *         to enforce token limits on a per-wallet and per-stage basis.
3513      *
3514      *         ERC721A tracks these values automatically, but this note and
3515      *         nonReentrant modifier are left here to encourage best-practices
3516      *         when referencing this contract.
3517      *
3518      * @param minter   The address to mint to.
3519      * @param quantity The number of tokens to mint.
3520      */
3521     function mintSeaDrop(address minter, uint256 quantity)
3522         external
3523         virtual
3524         override
3525         nonReentrant
3526     {
3527         // Ensure the SeaDrop is allowed.
3528         _onlyAllowedSeaDrop(msg.sender);
3529 
3530         // Extra safety check to ensure the max supply is not exceeded.
3531         if (_totalMinted() + quantity > maxSupply()) {
3532             revert MintQuantityExceedsMaxSupply(
3533                 _totalMinted() + quantity,
3534                 maxSupply()
3535             );
3536         }
3537 
3538         // Mint the quantity of tokens to the minter.
3539         _safeMint(minter, quantity);
3540     }
3541 
3542     /**
3543      * @notice Update the public drop data for this nft contract on SeaDrop.
3544      *         Only the owner can use this function.
3545      *
3546      * @param seaDropImpl The allowed SeaDrop contract.
3547      * @param publicDrop  The public drop data.
3548      */
3549     function updatePublicDrop(
3550         address seaDropImpl,
3551         PublicDrop calldata publicDrop
3552     ) external virtual override {
3553         // Ensure the sender is only the owner or contract itself.
3554         _onlyOwnerOrSelf();
3555 
3556         // Ensure the SeaDrop is allowed.
3557         _onlyAllowedSeaDrop(seaDropImpl);
3558 
3559         // Update the public drop data on SeaDrop.
3560         ISeaDrop(seaDropImpl).updatePublicDrop(publicDrop);
3561     }
3562 
3563     /**
3564      * @notice Update the allow list data for this nft contract on SeaDrop.
3565      *         Only the owner can use this function.
3566      *
3567      * @param seaDropImpl   The allowed SeaDrop contract.
3568      * @param allowListData The allow list data.
3569      */
3570     function updateAllowList(
3571         address seaDropImpl,
3572         AllowListData calldata allowListData
3573     ) external virtual override {
3574         // Ensure the sender is only the owner or contract itself.
3575         _onlyOwnerOrSelf();
3576 
3577         // Ensure the SeaDrop is allowed.
3578         _onlyAllowedSeaDrop(seaDropImpl);
3579 
3580         // Update the allow list on SeaDrop.
3581         ISeaDrop(seaDropImpl).updateAllowList(allowListData);
3582     }
3583 
3584     /**
3585      * @notice Update the token gated drop stage data for this nft contract
3586      *         on SeaDrop.
3587      *         Only the owner can use this function.
3588      *
3589      *         Note: If two INonFungibleSeaDropToken tokens are doing
3590      *         simultaneous token gated drop promotions for each other,
3591      *         they can be minted by the same actor until
3592      *         `maxTokenSupplyForStage` is reached. Please ensure the
3593      *         `allowedNftToken` is not running an active drop during the
3594      *         `dropStage` time period.
3595      *
3596      * @param seaDropImpl     The allowed SeaDrop contract.
3597      * @param allowedNftToken The allowed nft token.
3598      * @param dropStage       The token gated drop stage data.
3599      */
3600     function updateTokenGatedDrop(
3601         address seaDropImpl,
3602         address allowedNftToken,
3603         TokenGatedDropStage calldata dropStage
3604     ) external virtual override {
3605         // Ensure the sender is only the owner or contract itself.
3606         _onlyOwnerOrSelf();
3607 
3608         // Ensure the SeaDrop is allowed.
3609         _onlyAllowedSeaDrop(seaDropImpl);
3610 
3611         // Update the token gated drop stage.
3612         ISeaDrop(seaDropImpl).updateTokenGatedDrop(allowedNftToken, dropStage);
3613     }
3614 
3615     /**
3616      * @notice Update the drop URI for this nft contract on SeaDrop.
3617      *         Only the owner can use this function.
3618      *
3619      * @param seaDropImpl The allowed SeaDrop contract.
3620      * @param dropURI     The new drop URI.
3621      */
3622     function updateDropURI(address seaDropImpl, string calldata dropURI)
3623         external
3624         virtual
3625         override
3626     {
3627         // Ensure the sender is only the owner or contract itself.
3628         _onlyOwnerOrSelf();
3629 
3630         // Ensure the SeaDrop is allowed.
3631         _onlyAllowedSeaDrop(seaDropImpl);
3632 
3633         // Update the drop URI.
3634         ISeaDrop(seaDropImpl).updateDropURI(dropURI);
3635     }
3636 
3637     /**
3638      * @notice Update the creator payout address for this nft contract on
3639      *         SeaDrop.
3640      *         Only the owner can set the creator payout address.
3641      *
3642      * @param seaDropImpl   The allowed SeaDrop contract.
3643      * @param payoutAddress The new payout address.
3644      */
3645     function updateCreatorPayoutAddress(
3646         address seaDropImpl,
3647         address payoutAddress
3648     ) external {
3649         // Ensure the sender is only the owner or contract itself.
3650         _onlyOwnerOrSelf();
3651 
3652         // Ensure the SeaDrop is allowed.
3653         _onlyAllowedSeaDrop(seaDropImpl);
3654 
3655         // Update the creator payout address.
3656         ISeaDrop(seaDropImpl).updateCreatorPayoutAddress(payoutAddress);
3657     }
3658 
3659     /**
3660      * @notice Update the allowed fee recipient for this nft contract
3661      *         on SeaDrop.
3662      *         Only the owner can set the allowed fee recipient.
3663      *
3664      * @param seaDropImpl  The allowed SeaDrop contract.
3665      * @param feeRecipient The new fee recipient.
3666      * @param allowed      If the fee recipient is allowed.
3667      */
3668     function updateAllowedFeeRecipient(
3669         address seaDropImpl,
3670         address feeRecipient,
3671         bool allowed
3672     ) external virtual {
3673         // Ensure the sender is only the owner or contract itself.
3674         _onlyOwnerOrSelf();
3675 
3676         // Ensure the SeaDrop is allowed.
3677         _onlyAllowedSeaDrop(seaDropImpl);
3678 
3679         // Update the allowed fee recipient.
3680         ISeaDrop(seaDropImpl).updateAllowedFeeRecipient(feeRecipient, allowed);
3681     }
3682 
3683     /**
3684      * @notice Update the server-side signers for this nft contract
3685      *         on SeaDrop.
3686      *         Only the owner can use this function.
3687      *
3688      * @param seaDropImpl                The allowed SeaDrop contract.
3689      * @param signer                     The signer to update.
3690      * @param signedMintValidationParams Minimum and maximum parameters to
3691      *                                   enforce for signed mints.
3692      */
3693     function updateSignedMintValidationParams(
3694         address seaDropImpl,
3695         address signer,
3696         SignedMintValidationParams memory signedMintValidationParams
3697     ) external virtual override {
3698         // Ensure the sender is only the owner or contract itself.
3699         _onlyOwnerOrSelf();
3700 
3701         // Ensure the SeaDrop is allowed.
3702         _onlyAllowedSeaDrop(seaDropImpl);
3703 
3704         // Update the signer.
3705         ISeaDrop(seaDropImpl).updateSignedMintValidationParams(
3706             signer,
3707             signedMintValidationParams
3708         );
3709     }
3710 
3711     /**
3712      * @notice Update the allowed payers for this nft contract on SeaDrop.
3713      *         Only the owner can use this function.
3714      *
3715      * @param seaDropImpl The allowed SeaDrop contract.
3716      * @param payer       The payer to update.
3717      * @param allowed     Whether the payer is allowed.
3718      */
3719     function updatePayer(
3720         address seaDropImpl,
3721         address payer,
3722         bool allowed
3723     ) external virtual override {
3724         // Ensure the sender is only the owner or contract itself.
3725         _onlyOwnerOrSelf();
3726 
3727         // Ensure the SeaDrop is allowed.
3728         _onlyAllowedSeaDrop(seaDropImpl);
3729 
3730         // Update the payer.
3731         ISeaDrop(seaDropImpl).updatePayer(payer, allowed);
3732     }
3733 
3734     /**
3735      * @notice Returns a set of mint stats for the address.
3736      *         This assists SeaDrop in enforcing maxSupply,
3737      *         maxTotalMintableByWallet, and maxTokenSupplyForStage checks.
3738      *
3739      * @dev    NOTE: Implementing contracts should always update these numbers
3740      *         before transferring any tokens with _safeMint() to mitigate
3741      *         consequences of malicious onERC721Received() hooks.
3742      *
3743      * @param minter The minter address.
3744      */
3745     function getMintStats(address minter)
3746         external
3747         view
3748         override
3749         returns (
3750             uint256 minterNumMinted,
3751             uint256 currentTotalSupply,
3752             uint256 maxSupply
3753         )
3754     {
3755         minterNumMinted = _numberMinted(minter);
3756         currentTotalSupply = _totalMinted();
3757         maxSupply = _maxSupply;
3758     }
3759 
3760     /**
3761      * @notice Returns whether the interface is supported.
3762      *
3763      * @param interfaceId The interface id to check against.
3764      */
3765     function supportsInterface(bytes4 interfaceId)
3766         public
3767         view
3768         virtual
3769         override(IERC165, ERC721ContractMetadata)
3770         returns (bool)
3771     {
3772         return
3773             interfaceId == type(INonFungibleSeaDropToken).interfaceId ||
3774             interfaceId == type(ISeaDropTokenContractMetadata).interfaceId ||
3775             // ERC721ContractMetadata returns supportsInterface true for
3776             //     EIP-2981
3777             // ERC721A returns supportsInterface true for
3778             //     ERC165, ERC721, ERC721Metadata
3779             super.supportsInterface(interfaceId);
3780     }
3781 
3782     /**
3783      * @dev Approve or remove `operator` as an operator for the caller.
3784      * Operators can call {transferFrom} or {safeTransferFrom}
3785      * for any token owned by the caller.
3786      *
3787      * Requirements:
3788      *
3789      * - The `operator` cannot be the caller.
3790      * - The `operator` must be allowed.
3791      *
3792      * Emits an {ApprovalForAll} event.
3793      */
3794     function setApprovalForAll(address operator, bool approved)
3795         public
3796         override
3797         onlyAllowedOperatorApproval(operator)
3798     {
3799         super.setApprovalForAll(operator, approved);
3800     }
3801 
3802     /**
3803      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
3804      * The approval is cleared when the token is transferred.
3805      *
3806      * Only a single account can be approved at a time, so approving the
3807      * zero address clears previous approvals.
3808      *
3809      * Requirements:
3810      *
3811      * - The caller must own the token or be an approved operator.
3812      * - `tokenId` must exist.
3813      * - The `operator` mut be allowed.
3814      *
3815      * Emits an {Approval} event.
3816      */
3817     function approve(address operator, uint256 tokenId)
3818         public
3819         override
3820         payable
3821         onlyAllowedOperatorApproval(operator)
3822     {
3823         super.approve(operator, tokenId);
3824     }
3825 
3826     /**
3827      * @dev Transfers `tokenId` from `from` to `to`.
3828      *
3829      * Requirements:
3830      *
3831      * - `from` cannot be the zero address.
3832      * - `to` cannot be the zero address.
3833      * - `tokenId` token must be owned by `from`.
3834      * - If the caller is not `from`, it must be approved to move this token
3835      * by either {approve} or {setApprovalForAll}.
3836      * - The operator must be allowed.
3837      *
3838      * Emits a {Transfer} event.
3839      */
3840     function transferFrom(
3841         address from,
3842         address to,
3843         uint256 tokenId
3844     ) public override payable onlyAllowedOperator(from) {
3845         super.transferFrom(from, to, tokenId);
3846     }
3847 
3848     /**
3849      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
3850      */
3851     function safeTransferFrom(
3852         address from,
3853         address to,
3854         uint256 tokenId
3855     ) public override payable onlyAllowedOperator(from) {
3856         super.safeTransferFrom(from, to, tokenId);
3857     }
3858 
3859     /**
3860      * @dev Safely transfers `tokenId` token from `from` to `to`.
3861      *
3862      * Requirements:
3863      *
3864      * - `from` cannot be the zero address.
3865      * - `to` cannot be the zero address.
3866      * - `tokenId` token must exist and be owned by `from`.
3867      * - If the caller is not `from`, it must be approved to move this token
3868      * by either {approve} or {setApprovalForAll}.
3869      * - If `to` refers to a smart contract, it must implement
3870      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3871      * - The operator must be allowed.
3872      *
3873      * Emits a {Transfer} event.
3874      */
3875     function safeTransferFrom(
3876         address from,
3877         address to,
3878         uint256 tokenId,
3879         bytes memory data
3880     ) public override payable onlyAllowedOperator(from) {
3881         super.safeTransferFrom(from, to, tokenId, data);
3882     }
3883 
3884     /**
3885      * @notice Configure multiple properties at a time.
3886      *
3887      *         Note: The individual configure methods should be used
3888      *         to unset or reset any properties to zero, as this method
3889      *         will ignore zero-value properties in the config struct.
3890      *
3891      * @param config The configuration struct.
3892      */
3893     function multiConfigure(MultiConfigureStruct calldata config)
3894         external
3895         onlyOwner
3896     {
3897         if (config.maxSupply > 0) {
3898             this.setMaxSupply(config.maxSupply);
3899         }
3900         if (bytes(config.baseURI).length != 0) {
3901             this.setBaseURI(config.baseURI);
3902         }
3903         if (bytes(config.contractURI).length != 0) {
3904             this.setContractURI(config.contractURI);
3905         }
3906         if (
3907             _cast(config.publicDrop.startTime != 0) |
3908                 _cast(config.publicDrop.endTime != 0) ==
3909             1
3910         ) {
3911             this.updatePublicDrop(config.seaDropImpl, config.publicDrop);
3912         }
3913         if (bytes(config.dropURI).length != 0) {
3914             this.updateDropURI(config.seaDropImpl, config.dropURI);
3915         }
3916         if (config.allowListData.merkleRoot != bytes32(0)) {
3917             this.updateAllowList(config.seaDropImpl, config.allowListData);
3918         }
3919         if (config.creatorPayoutAddress != address(0)) {
3920             this.updateCreatorPayoutAddress(
3921                 config.seaDropImpl,
3922                 config.creatorPayoutAddress
3923             );
3924         }
3925         if (config.provenanceHash != bytes32(0)) {
3926             this.setProvenanceHash(config.provenanceHash);
3927         }
3928         if (config.allowedFeeRecipients.length > 0) {
3929             for (uint256 i = 0; i < config.allowedFeeRecipients.length; ) {
3930                 this.updateAllowedFeeRecipient(
3931                     config.seaDropImpl,
3932                     config.allowedFeeRecipients[i],
3933                     true
3934                 );
3935                 unchecked {
3936                     ++i;
3937                 }
3938             }
3939         }
3940         if (config.disallowedFeeRecipients.length > 0) {
3941             for (uint256 i = 0; i < config.disallowedFeeRecipients.length; ) {
3942                 this.updateAllowedFeeRecipient(
3943                     config.seaDropImpl,
3944                     config.disallowedFeeRecipients[i],
3945                     false
3946                 );
3947                 unchecked {
3948                     ++i;
3949                 }
3950             }
3951         }
3952         if (config.allowedPayers.length > 0) {
3953             for (uint256 i = 0; i < config.allowedPayers.length; ) {
3954                 this.updatePayer(
3955                     config.seaDropImpl,
3956                     config.allowedPayers[i],
3957                     true
3958                 );
3959                 unchecked {
3960                     ++i;
3961                 }
3962             }
3963         }
3964         if (config.disallowedPayers.length > 0) {
3965             for (uint256 i = 0; i < config.disallowedPayers.length; ) {
3966                 this.updatePayer(
3967                     config.seaDropImpl,
3968                     config.disallowedPayers[i],
3969                     false
3970                 );
3971                 unchecked {
3972                     ++i;
3973                 }
3974             }
3975         }
3976         if (config.tokenGatedDropStages.length > 0) {
3977             if (
3978                 config.tokenGatedDropStages.length !=
3979                 config.tokenGatedAllowedNftTokens.length
3980             ) {
3981                 revert TokenGatedMismatch();
3982             }
3983             for (uint256 i = 0; i < config.tokenGatedDropStages.length; ) {
3984                 this.updateTokenGatedDrop(
3985                     config.seaDropImpl,
3986                     config.tokenGatedAllowedNftTokens[i],
3987                     config.tokenGatedDropStages[i]
3988                 );
3989                 unchecked {
3990                     ++i;
3991                 }
3992             }
3993         }
3994         if (config.disallowedTokenGatedAllowedNftTokens.length > 0) {
3995             for (
3996                 uint256 i = 0;
3997                 i < config.disallowedTokenGatedAllowedNftTokens.length;
3998 
3999             ) {
4000                 TokenGatedDropStage memory emptyStage;
4001                 this.updateTokenGatedDrop(
4002                     config.seaDropImpl,
4003                     config.disallowedTokenGatedAllowedNftTokens[i],
4004                     emptyStage
4005                 );
4006                 unchecked {
4007                     ++i;
4008                 }
4009             }
4010         }
4011         if (config.signedMintValidationParams.length > 0) {
4012             if (
4013                 config.signedMintValidationParams.length !=
4014                 config.signers.length
4015             ) {
4016                 revert SignersMismatch();
4017             }
4018             for (
4019                 uint256 i = 0;
4020                 i < config.signedMintValidationParams.length;
4021 
4022             ) {
4023                 this.updateSignedMintValidationParams(
4024                     config.seaDropImpl,
4025                     config.signers[i],
4026                     config.signedMintValidationParams[i]
4027                 );
4028                 unchecked {
4029                     ++i;
4030                 }
4031             }
4032         }
4033         if (config.disallowedSigners.length > 0) {
4034             for (uint256 i = 0; i < config.disallowedSigners.length; ) {
4035                 SignedMintValidationParams memory emptyParams;
4036                 this.updateSignedMintValidationParams(
4037                     config.seaDropImpl,
4038                     config.disallowedSigners[i],
4039                     emptyParams
4040                 );
4041                 unchecked {
4042                     ++i;
4043                 }
4044             }
4045         }
4046     }
4047 }
4048 
4049 
4050 // File lib/utility-contracts/src/TwoStepAdministered.sol
4051 
4052  
4053 pragma solidity >=0.8.0;
4054 
4055 contract TwoStepAdministered is TwoStepOwnable {
4056     event AdministratorUpdated(
4057         address indexed previousAdministrator,
4058         address indexed newAdministrator
4059     );
4060     event PotentialAdministratorUpdated(address newPotentialAdministrator);
4061 
4062     error OnlyAdministrator();
4063     error OnlyOwnerOrAdministrator();
4064     error NotNextAdministrator();
4065     error NewAdministratorIsZeroAddress();
4066 
4067     address public administrator;
4068     address public potentialAdministrator;
4069 
4070     modifier onlyAdministrator() virtual {
4071         if (msg.sender != administrator) {
4072             revert OnlyAdministrator();
4073         }
4074 
4075         _;
4076     }
4077 
4078     modifier onlyOwnerOrAdministrator() virtual {
4079         if (msg.sender != owner()) {
4080             if (msg.sender != administrator) {
4081                 revert OnlyOwnerOrAdministrator();
4082             }
4083         }
4084         _;
4085     }
4086 
4087     constructor(address _administrator) {
4088         _initialize(_administrator);
4089     }
4090 
4091     function _initialize(address _administrator) private onlyConstructor {
4092         administrator = _administrator;
4093         emit AdministratorUpdated(address(0), _administrator);
4094     }
4095 
4096     function transferAdministration(address newAdministrator)
4097         public
4098         virtual
4099         onlyAdministrator
4100     {
4101         if (newAdministrator == address(0)) {
4102             revert NewAdministratorIsZeroAddress();
4103         }
4104         potentialAdministrator = newAdministrator;
4105         emit PotentialAdministratorUpdated(newAdministrator);
4106     }
4107 
4108     function _transferAdministration(address newAdministrator)
4109         internal
4110         virtual
4111     {
4112         administrator = newAdministrator;
4113 
4114         emit AdministratorUpdated(msg.sender, newAdministrator);
4115     }
4116 
4117     ///@notice Acept administration of smart contract, after the current administrator has initiated the process with transferAdministration
4118     function acceptAdministration() public virtual {
4119         address _potentialAdministrator = potentialAdministrator;
4120         if (msg.sender != _potentialAdministrator) {
4121             revert NotNextAdministrator();
4122         }
4123         _transferAdministration(_potentialAdministrator);
4124         delete potentialAdministrator;
4125     }
4126 
4127     ///@notice cancel administration transfer
4128     function cancelAdministrationTransfer() public virtual onlyAdministrator {
4129         delete potentialAdministrator;
4130         emit PotentialAdministratorUpdated(address(0));
4131     }
4132 
4133     function renounceAdministration() public virtual onlyAdministrator {
4134         delete administrator;
4135         emit AdministratorUpdated(msg.sender, address(0));
4136     }
4137 }
4138 
4139 
4140 // File src/ERC721PartnerSeaDrop.sol
4141 
4142  
4143 pragma solidity 0.8.17;
4144 
4145 /**
4146  * @title  ERC721PartnerSeaDrop
4147  * @author James Wenzel (emo.eth)
4148  * @author Ryan Ghods (ralxz.eth)
4149  * @author Stephan Min (stephanm.eth)
4150  * @notice ERC721PartnerSeaDrop is a token contract that contains methods
4151  *         to properly interact with SeaDrop, with additional administrative
4152  *         functionality tailored for business requirements around partnered
4153  *         mints with off-chain agreements in place between two parties.
4154  *
4155  *         The "Owner" should control mint specifics such as price and start.
4156  *         The "Administrator" should control fee parameters.
4157  *
4158  *         Otherwise, for ease of administration, either Owner or Administrator
4159  *         should be able to configure mint parameters. They have the ability
4160  *         to override each other's actions in many circumstances, which is
4161  *         why the establishment of off-chain trust is important.
4162  *
4163  *         Note: An Administrator is not required to interface with SeaDrop.
4164  */
4165 contract ERC721PartnerSeaDrop is ERC721SeaDrop, TwoStepAdministered {
4166     /// @notice To prevent Owner from overriding fees, Administrator must
4167     ///         first initialize with fee.
4168     error AdministratorMustInitializeWithFee();
4169 
4170     /**
4171      * @notice Deploy the token contract with its name, symbol,
4172      *         administrator, and allowed SeaDrop addresses.
4173      */
4174     constructor(
4175         string memory name,
4176         string memory symbol,
4177         address administrator,
4178         address[] memory allowedSeaDrop
4179     )
4180         ERC721SeaDrop(name, symbol, allowedSeaDrop)
4181         TwoStepAdministered(administrator)
4182     {}
4183 
4184     /**
4185      * @notice Mint tokens, restricted to the SeaDrop contract.
4186      *
4187      * @param minter   The address to mint to.
4188      * @param quantity The number of tokens to mint.
4189      */
4190     function mintSeaDrop(address minter, uint256 quantity)
4191         external
4192         virtual
4193         override
4194     {
4195         // Ensure the SeaDrop is allowed.
4196         _onlyAllowedSeaDrop(msg.sender);
4197 
4198         // Extra safety check to ensure the max supply is not exceeded.
4199         if (_totalMinted() + quantity > maxSupply()) {
4200             revert MintQuantityExceedsMaxSupply(
4201                 _totalMinted() + quantity,
4202                 maxSupply()
4203             );
4204         }
4205 
4206         // Mint the quantity of tokens to the minter.
4207         _mint(minter, quantity);
4208     }
4209 
4210     /**
4211      * @notice Update the allowed SeaDrop contracts.
4212      *         Only the owner or administrator can use this function.
4213      *
4214      * @param allowedSeaDrop The allowed SeaDrop addresses.
4215      */
4216     function updateAllowedSeaDrop(address[] calldata allowedSeaDrop)
4217         external
4218         override
4219         onlyOwnerOrAdministrator
4220     {
4221         _updateAllowedSeaDrop(allowedSeaDrop);
4222     }
4223 
4224     /**
4225      * @notice Update the public drop data for this nft contract on SeaDrop.
4226      *         Only the owner or administrator can use this function.
4227      *
4228      *         The administrator can only update `feeBps`.
4229      *
4230      * @param seaDropImpl The allowed SeaDrop contract.
4231      * @param publicDrop  The public drop data.
4232      */
4233     function updatePublicDrop(
4234         address seaDropImpl,
4235         PublicDrop calldata publicDrop
4236     ) external virtual override onlyOwnerOrAdministrator {
4237         // Ensure the SeaDrop is allowed.
4238         _onlyAllowedSeaDrop(seaDropImpl);
4239 
4240         // Track the previous public drop data.
4241         PublicDrop memory retrieved = ISeaDrop(seaDropImpl).getPublicDrop(
4242             address(this)
4243         );
4244 
4245         // Track the newly supplied drop data.
4246         PublicDrop memory supplied = publicDrop;
4247 
4248         // Only the administrator (OpenSea) can set feeBps.
4249         if (msg.sender != administrator) {
4250             // Administrator must first set fee.
4251             if (retrieved.maxTotalMintableByWallet == 0) {
4252                 revert AdministratorMustInitializeWithFee();
4253             }
4254             supplied.feeBps = retrieved.feeBps;
4255             supplied.restrictFeeRecipients = true;
4256         } else {
4257             // Administrator can only initialize
4258             // (maxTotalMintableByWallet > 0) and set
4259             // feeBps/restrictFeeRecipients.
4260             uint16 maxTotalMintableByWallet = retrieved
4261                 .maxTotalMintableByWallet;
4262             retrieved.maxTotalMintableByWallet = maxTotalMintableByWallet > 0
4263                 ? maxTotalMintableByWallet
4264                 : 1;
4265             retrieved.feeBps = supplied.feeBps;
4266             retrieved.restrictFeeRecipients = true;
4267             supplied = retrieved;
4268         }
4269 
4270         // Update the public drop data on SeaDrop.
4271         ISeaDrop(seaDropImpl).updatePublicDrop(supplied);
4272     }
4273 
4274     /**
4275      * @notice Update the allow list data for this nft contract on SeaDrop.
4276      *         Only the owner or administrator can use this function.
4277      *
4278      * @param seaDropImpl   The allowed SeaDrop contract.
4279      * @param allowListData The allow list data.
4280      */
4281     function updateAllowList(
4282         address seaDropImpl,
4283         AllowListData calldata allowListData
4284     ) external virtual override onlyOwnerOrAdministrator {
4285         // Ensure the SeaDrop is allowed.
4286         _onlyAllowedSeaDrop(seaDropImpl);
4287 
4288         // Update the allow list on SeaDrop.
4289         ISeaDrop(seaDropImpl).updateAllowList(allowListData);
4290     }
4291 
4292     /**
4293      * @notice Update the token gated drop stage data for this nft contract
4294      *         on SeaDrop.
4295      *         Only the owner or administrator can use this function.
4296      *
4297      *         The administrator must first set `feeBps`.
4298      *
4299      *         Note: If two INonFungibleSeaDropToken tokens are doing
4300      *         simultaneous token gated drop promotions for each other,
4301      *         they can be minted by the same actor until
4302      *         `maxTokenSupplyForStage` is reached. Please ensure the
4303      *         `allowedNftToken` is not running an active drop during the
4304      *         `dropStage` time period.
4305      *
4306      * @param seaDropImpl     The allowed SeaDrop contract.
4307      * @param allowedNftToken The allowed nft token.
4308      * @param dropStage       The token gated drop stage data.
4309      */
4310     function updateTokenGatedDrop(
4311         address seaDropImpl,
4312         address allowedNftToken,
4313         TokenGatedDropStage calldata dropStage
4314     ) external virtual override onlyOwnerOrAdministrator {
4315         // Ensure the SeaDrop is allowed.
4316         _onlyAllowedSeaDrop(seaDropImpl);
4317 
4318         // Track the previous drop stage data.
4319         TokenGatedDropStage memory retrieved = ISeaDrop(seaDropImpl)
4320             .getTokenGatedDrop(address(this), allowedNftToken);
4321 
4322         // Track the newly supplied drop data.
4323         TokenGatedDropStage memory supplied = dropStage;
4324 
4325         // Only the administrator (OpenSea) can set feeBps on Partner
4326         // contracts.
4327         if (msg.sender != administrator) {
4328             // Administrator must first set fee.
4329             if (retrieved.maxTotalMintableByWallet == 0) {
4330                 revert AdministratorMustInitializeWithFee();
4331             }
4332             supplied.feeBps = retrieved.feeBps;
4333             supplied.restrictFeeRecipients = true;
4334         } else {
4335             // Administrator can only initialize
4336             // (maxTotalMintableByWallet > 0) and set
4337             // feeBps/restrictFeeRecipients.
4338             uint16 maxTotalMintableByWallet = retrieved
4339                 .maxTotalMintableByWallet;
4340             retrieved.maxTotalMintableByWallet = maxTotalMintableByWallet > 0
4341                 ? maxTotalMintableByWallet
4342                 : 1;
4343             retrieved.feeBps = supplied.feeBps;
4344             retrieved.restrictFeeRecipients = true;
4345             supplied = retrieved;
4346         }
4347 
4348         // Update the token gated drop stage.
4349         ISeaDrop(seaDropImpl).updateTokenGatedDrop(allowedNftToken, supplied);
4350     }
4351 
4352     /**
4353      * @notice Update the drop URI for this nft contract on SeaDrop.
4354      *         Only the owner or administrator can use this function.
4355      *
4356      * @param seaDropImpl The allowed SeaDrop contract.
4357      * @param dropURI     The new drop URI.
4358      */
4359     function updateDropURI(address seaDropImpl, string calldata dropURI)
4360         external
4361         virtual
4362         override
4363         onlyOwnerOrAdministrator
4364     {
4365         // Ensure the SeaDrop is allowed.
4366         _onlyAllowedSeaDrop(seaDropImpl);
4367 
4368         // Update the drop URI.
4369         ISeaDrop(seaDropImpl).updateDropURI(dropURI);
4370     }
4371 
4372     /**
4373      * @notice Update the allowed fee recipient for this nft contract
4374      *         on SeaDrop.
4375      *         Only the administrator can set the allowed fee recipient.
4376      *
4377      * @param seaDropImpl  The allowed SeaDrop contract.
4378      * @param feeRecipient The new fee recipient.
4379      * @param allowed      If the fee recipient is allowed.
4380      */
4381     function updateAllowedFeeRecipient(
4382         address seaDropImpl,
4383         address feeRecipient,
4384         bool allowed
4385     ) external override onlyAdministrator {
4386         // Ensure the SeaDrop is allowed.
4387         _onlyAllowedSeaDrop(seaDropImpl);
4388 
4389         // Update the allowed fee recipient.
4390         ISeaDrop(seaDropImpl).updateAllowedFeeRecipient(feeRecipient, allowed);
4391     }
4392 
4393     /**
4394      * @notice Update the server-side signers for this nft contract
4395      *         on SeaDrop.
4396      *         Only the owner or administrator can use this function.
4397      *
4398      * @param seaDropImpl                The allowed SeaDrop contract.
4399      * @param signer                     The signer to update.
4400      * @param signedMintValidationParams Minimum and maximum parameters to
4401      *                                   enforce for signed mints.
4402      */
4403     function updateSignedMintValidationParams(
4404         address seaDropImpl,
4405         address signer,
4406         SignedMintValidationParams memory signedMintValidationParams
4407     ) external virtual override onlyOwnerOrAdministrator {
4408         // Ensure the SeaDrop is allowed.
4409         _onlyAllowedSeaDrop(seaDropImpl);
4410 
4411         // Track the previous signed mint validation params.
4412         SignedMintValidationParams memory retrieved = ISeaDrop(seaDropImpl)
4413             .getSignedMintValidationParams(address(this), signer);
4414 
4415         // Track the newly supplied params.
4416         SignedMintValidationParams memory supplied = signedMintValidationParams;
4417 
4418         // Only the administrator (OpenSea) can set feeBps on Partner
4419         // contracts.
4420         if (msg.sender != administrator) {
4421             // Administrator must first set fee.
4422             if (retrieved.maxMaxTotalMintableByWallet == 0) {
4423                 revert AdministratorMustInitializeWithFee();
4424             }
4425             supplied.minFeeBps = retrieved.minFeeBps;
4426             supplied.maxFeeBps = retrieved.maxFeeBps;
4427         } else {
4428             // Administrator can only initialize
4429             // (maxTotalMintableByWallet > 0) and set
4430             // feeBps/restrictFeeRecipients.
4431             uint24 maxMaxTotalMintableByWallet = retrieved
4432                 .maxMaxTotalMintableByWallet;
4433             retrieved
4434                 .maxMaxTotalMintableByWallet = maxMaxTotalMintableByWallet > 0
4435                 ? maxMaxTotalMintableByWallet
4436                 : 1;
4437             retrieved.minFeeBps = supplied.minFeeBps;
4438             retrieved.maxFeeBps = supplied.maxFeeBps;
4439             supplied = retrieved;
4440         }
4441 
4442         // Update the signed mint validation params.
4443         ISeaDrop(seaDropImpl).updateSignedMintValidationParams(
4444             signer,
4445             supplied
4446         );
4447     }
4448 
4449     /**
4450      * @notice Update the allowed payers for this nft contract on SeaDrop.
4451      *         Only the owner or administrator can use this function.
4452      *
4453      * @param seaDropImpl The allowed SeaDrop contract.
4454      * @param payer       The payer to update.
4455      * @param allowed     Whether the payer is allowed.
4456      */
4457     function updatePayer(
4458         address seaDropImpl,
4459         address payer,
4460         bool allowed
4461     ) external virtual override onlyOwnerOrAdministrator {
4462         // Ensure the SeaDrop is allowed.
4463         _onlyAllowedSeaDrop(seaDropImpl);
4464 
4465         // Update the payer.
4466         ISeaDrop(seaDropImpl).updatePayer(payer, allowed);
4467     }
4468 }
4469 
4470 
4471 // File src/extensions/ERC721PartnerSeaDropBurnable.sol
4472 
4473  
4474 pragma solidity 0.8.17;
4475 
4476 /**
4477  * @title  ERC721PartnerSeaDropBurnable
4478  * @author James Wenzel (emo.eth)
4479  * @author Ryan Ghods (ralxz.eth)
4480  * @author Stephan Min (stephanm.eth)
4481  * @notice ERC721PartnerSeaDropBurnable is a token contract that extends
4482  *         ERC721PartnerSeaDrop to additionally provide a burn function.
4483  */
4484 contract ERC721PartnerSeaDropBurnable is ERC721PartnerSeaDrop {
4485     /**
4486      * @notice Deploy the token contract with its name, symbol,
4487      *         administrator, and allowed SeaDrop addresses.
4488      */
4489     constructor(
4490         string memory name,
4491         string memory symbol,
4492         address administrator,
4493         address[] memory allowedSeaDrop
4494     ) ERC721PartnerSeaDrop(name, symbol, administrator, allowedSeaDrop) {}
4495 
4496     /**
4497      * @notice Burns `tokenId`. The caller must own `tokenId` or be an
4498      *         approved operator.
4499      *
4500      * @param tokenId The token id to burn.
4501      */
4502     // solhint-disable-next-line comprehensive-interface
4503     function burn(uint256 tokenId) external {
4504         _burn(tokenId, true);
4505     }
4506 }
4507 
4508 
4509 // File src/interfaces/IFrens.sol
4510 
4511  
4512 pragma solidity ^0.8.17;
4513 
4514 // Many thanks to the dev of the fantastic Checks smart contract 
4515 
4516 interface IFrens {
4517 
4518     struct Fren {
4519         uint8 palette;   // The palette ID (0-255)
4520         uint8 colors;    // The number of colors ()
4521         uint8 rotation;  // Number of steps the palette should be rotated
4522         string direction; // Forward or backward
4523         string segment;   // Full, H1, H2, Q1, Q2, Q3, Q4, T1, T2, T3
4524         bool inverted;    // Yes/No
4525         bool attention;     // Yes/No
4526         uint32 epoch;      // Each fren is revealed in an epoch
4527         bool isRevealed;      // Whether the fren is revealed
4528         uint256 seed;        // The instantiated seed for pseudo-randomisation
4529     }
4530 
4531     struct Epoch {
4532         uint128 randomness;    // The source of randomness for tokens from this epoch
4533         uint64 revealBlock;   // The block at which this epoch was / is revealed
4534         bool committed;      // Whether the epoch has been instantiated
4535         bool revealed;      // Whether the epoch has been revealed
4536     }
4537 
4538     event NewEpoch(
4539         uint256 indexed epoch,
4540         uint64 indexed revealBlock
4541     );
4542 
4543     error NotAllowed();
4544     error InvalidTokenCount();
4545     error ZeroFren__InvalidFren();
4546 
4547 }
4548 
4549 
4550 // File src/libraries/Utilities.sol
4551 
4552 
4553 pragma solidity ^0.8.17;
4554 
4555 library Utilities {
4556 
4557     /// @dev unpack one of 32 bit-packed uint8s from a uint256 (zero-indexed position)
4558     function unpack(uint256 input, uint8 position) internal pure returns (uint8) {
4559       return uint8(input >> (8*(position+1)));
4560     }
4561 
4562     /// @dev unpack a uint8s from a uint256 (zero-indexed offset)
4563     function unpack_arbitrary(uint256 input, uint8 offset) internal pure returns (uint8) {
4564       return uint8(input >> offset);
4565     }
4566 
4567     /// @dev Zero-index based pseudorandom number based on one input and max bound
4568     function random(uint256 input, uint256 _max) internal pure returns (uint256) {
4569         return (uint256(keccak256(abi.encodePacked(input))) % _max);
4570     }
4571 
4572     /// @dev Zero-index based salted pseudorandom number based on two inputs and max bound
4573     function random(uint256 input, string memory salt, uint256 _max) internal pure returns (uint256) {
4574         return (uint256(keccak256(abi.encodePacked(input, salt))) % _max);
4575     }
4576 
4577     /// @dev Convert an integer to a string
4578     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
4579         if (_i == 0) {
4580             return "0";
4581         }
4582         uint256 j = _i;
4583         uint256 len;
4584         while (j != 0) {
4585             ++len;
4586             j /= 10;
4587         }
4588         bytes memory bstr = new bytes(len);
4589         uint256 k = len;
4590         while (_i != 0) {
4591             k = k - 1;
4592             uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
4593             bytes1 b1 = bytes1(temp);
4594             bstr[k] = b1;
4595             _i /= 10;
4596         }
4597         return string(bstr);
4598     }
4599 
4600     /// @dev Get the smallest non zero number
4601     function minGt0(uint8 one, uint8 two) internal pure returns (uint8) {
4602         return one > two
4603             ? two > 0
4604                 ? two
4605                 : one
4606             : one;
4607     }
4608 
4609     /// @dev Get the smaller number
4610     function min(uint8 one, uint8 two) internal pure returns (uint8) {
4611         return one < two ? one : two;
4612     }
4613 
4614     /// @dev Get the larger number
4615     function max(uint8 one, uint8 two) internal pure returns (uint8) {
4616         return one > two ? one : two;
4617     }
4618 
4619     /// @dev Get the average between two numbers
4620     function avg(uint8 one, uint8 two) internal pure returns (uint8 result) {
4621         unchecked {
4622             result = (one >> 1) + (two >> 1) + (one & two & 1);
4623         }
4624     }
4625 
4626     /// @dev Get the days since another date (input is seconds)
4627     function day(uint256 from, uint256 to) internal pure returns (uint24) {
4628         return uint24((to - from) / 24 hours + 1);
4629     }
4630 }
4631 
4632 
4633 // File src/libraries/FrensTraits.sol
4634 
4635 
4636 pragma solidity ^0.8.17;
4637 
4638 /**
4639 
4640 @title  FrensMetadata
4641 @author Ryan Meyers
4642 @notice Renders ERC721 compatible metadata for Frens.
4643 */
4644 library FrensTraits {
4645 
4646     function colors(
4647       uint128 rando
4648     ) public pure returns (uint8){
4649       uint8 unpacked = Utilities.unpack(rando, 0);
4650       if (unpacked > 254) return 64;
4651       if (unpacked > 192) return 4;
4652       if (unpacked > 128) return 3;
4653       if (unpacked > 64) return 7;
4654       if (unpacked > 32) return 6;
4655       if (unpacked > 16) return 2;
4656       if (unpacked > 8) return 16;
4657       if (unpacked > 4) return 8;
4658       if (unpacked > 2) return 32;
4659       if (unpacked > 1) return 1;
4660       return 0;
4661     }
4662 
4663     function palette(
4664       uint128 rando
4665     ) public pure returns (uint8){
4666       return Utilities.unpack(rando, 1);
4667     }
4668 
4669     function rotation(
4670       uint128 rando
4671     ) public pure returns (uint8) {
4672       uint8 unpacked = Utilities.unpack(rando, 2);
4673       return unpacked % 8;
4674     }
4675 
4676     function direction(
4677       uint128 rando
4678     ) public pure returns (string memory) {
4679       uint8 unpacked = Utilities.unpack(rando, 3);
4680       return unpacked % 2 == 0 ? "FORWARD" : "REVERSE";
4681     }
4682 
4683     function segment(
4684       uint128 rando
4685     ) public pure returns (string memory){
4686       uint8 unpacked = Utilities.unpack(rando, 4);
4687       if (unpacked > 64) return "FULL";
4688       if (unpacked > 42) return "H2";
4689       if (unpacked > 20) return "H1";
4690       if (unpacked > 16) return "T3";
4691       if (unpacked > 12) return "T2";
4692       if (unpacked > 8) return "T1";
4693       if (unpacked > 6) return "Q4";
4694       if (unpacked > 4) return "Q3";
4695       if (unpacked > 2) return "Q2";
4696       return "Q1";
4697     }
4698 
4699 }
4700 
4701 
4702 // File lib/openzeppelin-contracts/contracts/utils/Base64.sol
4703 
4704  
4705 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
4706 
4707 pragma solidity ^0.8.0;
4708 
4709 /**
4710  * @dev Provides a set of functions to operate with Base64 strings.
4711  *
4712  * _Available since v4.5._
4713  */
4714 library Base64 {
4715     /**
4716      * @dev Base64 Encoding/Decoding Table
4717      */
4718     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
4719 
4720     /**
4721      * @dev Converts a `bytes` to its Bytes64 `string` representation.
4722      */
4723     function encode(bytes memory data) internal pure returns (string memory) {
4724         /**
4725          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
4726          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
4727          */
4728         if (data.length == 0) return "";
4729 
4730         // Loads the table into memory
4731         string memory table = _TABLE;
4732 
4733         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
4734         // and split into 4 numbers of 6 bits.
4735         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
4736         // - `data.length + 2`  -> Round up
4737         // - `/ 3`              -> Number of 3-bytes chunks
4738         // - `4 *`              -> 4 characters for each chunk
4739         string memory result = new string(4 * ((data.length + 2) / 3));
4740 
4741         /// @solidity memory-safe-assembly
4742         assembly {
4743             // Prepare the lookup table (skip the first "length" byte)
4744             let tablePtr := add(table, 1)
4745 
4746             // Prepare result pointer, jump over length
4747             let resultPtr := add(result, 32)
4748 
4749             // Run over the input, 3 bytes at a time
4750             for {
4751                 let dataPtr := data
4752                 let endPtr := add(data, mload(data))
4753             } lt(dataPtr, endPtr) {
4754 
4755             } {
4756                 // Advance 3 bytes
4757                 dataPtr := add(dataPtr, 3)
4758                 let input := mload(dataPtr)
4759 
4760                 // To write each character, shift the 3 bytes (18 bits) chunk
4761                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
4762                 // and apply logical AND with 0x3F which is the number of
4763                 // the previous character in the ASCII table prior to the Base64 Table
4764                 // The result is then added to the table to get the character to write,
4765                 // and finally write it in the result pointer but with a left shift
4766                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
4767 
4768                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
4769                 resultPtr := add(resultPtr, 1) // Advance
4770 
4771                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
4772                 resultPtr := add(resultPtr, 1) // Advance
4773 
4774                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
4775                 resultPtr := add(resultPtr, 1) // Advance
4776 
4777                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
4778                 resultPtr := add(resultPtr, 1) // Advance
4779             }
4780 
4781             // When data `bytes` is not exactly 3 bytes long
4782             // it is padded with `=` characters at the end
4783             switch mod(mload(data), 3)
4784             case 1 {
4785                 mstore8(sub(resultPtr, 1), 0x3d)
4786                 mstore8(sub(resultPtr, 2), 0x3d)
4787             }
4788             case 2 {
4789                 mstore8(sub(resultPtr, 1), 0x3d)
4790             }
4791         }
4792 
4793         return result;
4794     }
4795 }
4796 
4797 
4798 // File src/libraries/FrensMetadata.sol
4799 
4800 
4801 pragma solidity ^0.8.17;
4802 
4803 
4804 
4805 
4806 /**
4807 
4808 @title  FrensMetadata
4809 @author VisualizeValue
4810 @notice Renders ERC721 compatible metadata for Frens.
4811 */
4812 library FrensMetadata {
4813 
4814 
4815     /// @dev Get the Fren information given randomness + tokenId
4816     /// @param tokenId The id of the token to render.
4817     /// @param randomness The randomness generated by the epoch commit/reveal.
4818     function tokenURI(
4819       uint256 tokenId, uint128 randomness, string calldata baseURI
4820     ) public pure returns (string memory) {
4821       IFrens.Fren memory fren;
4822       uint128 rando = 0;
4823 
4824       if (randomness > 0) {
4825         fren.isRevealed = true;
4826         rando = uint128(uint256(keccak256(
4827                 abi.encodePacked(
4828                     randomness,
4829                     tokenId
4830                 ))) % (2 ** 128 - 1)
4831         );
4832 
4833         fren.palette = FrensTraits.palette(rando);
4834         fren.colors = FrensTraits.colors(rando);
4835         fren.rotation = FrensTraits.rotation(rando);
4836         fren.direction = FrensTraits.direction(rando);
4837         fren.segment = FrensTraits.segment(rando);
4838         fren.inverted = rando % 1000 == 0;
4839         fren.attention = rando % 2000 == 0;
4840       }
4841       
4842 
4843       bytes memory metadata = abi.encodePacked(
4844             '{',
4845                 '"name": "Frens #', Utilities.uint2str(tokenId), '",',
4846                 '"description": "These frens may or may not be notable.",',
4847                 '"image": "',
4848                     baseURI,
4849                     Utilities.uint2str(rando),
4850                     '.png',
4851                     '",',
4852                 '"attributes": [', attributes(fren), ']',
4853             '}'
4854         );
4855       
4856       return string(
4857             abi.encodePacked(
4858                 "data:application/json;base64,",
4859                 Base64.encode(metadata)
4860             )
4861         );
4862       
4863     }
4864 
4865 
4866 
4867     /// @dev Render the JSON atributes for a given Frens token.
4868     /// @param fren The fren to render.
4869     function attributes(IFrens.Fren memory fren) public pure returns (bytes memory) {
4870 
4871         return abi.encodePacked(
4872             fren.isRevealed
4873                 ? trait('Color Palette', string(abi.encodePacked('#',Utilities.uint2str(fren.palette))), ',')
4874                 : trait('Revealed', 'No', ','),
4875             fren.isRevealed
4876                 ? trait('# Colors', string(abi.encodePacked(Utilities.uint2str(fren.colors), ' COLORS')), ',')
4877                 : '',
4878             fren.isRevealed
4879                 ? trait('Palette Segment', fren.segment, ',')
4880                 : '',
4881             fren.isRevealed
4882                 ? trait('Palette Rotation', string(abi.encodePacked(Utilities.uint2str(fren.rotation), 'x')), ',')
4883                 : '',
4884             fren.isRevealed
4885                 ? trait('Palette Direction', fren.direction, ',')
4886                 : '',
4887             fren.inverted
4888                 ? trait('Inverted', 'Yes', ',')
4889                 : '',
4890             fren.attention
4891                 ? trait('Benefits', 'Yes', ',')
4892                 : '',
4893             trait('Artist', 'Gabe Weis', '')
4894         );
4895     }
4896 
4897     
4898 
4899     /// @dev Generate the JSON for a single attribute.
4900     /// @param traitType The `trait_type` for this trait.
4901     /// @param traitValue The `value` for this trait.
4902     /// @param append Helper to append a comma.
4903     function trait(
4904         string memory traitType, string memory traitValue, string memory append
4905     ) public pure returns (string memory) {
4906         return string(abi.encodePacked(
4907             '{',
4908                 '"trait_type": "', traitType, '",'
4909                 '"value": "', traitValue, '"'
4910             '}',
4911             append
4912         ));
4913     }
4914 
4915     
4916 
4917 }
4918 
4919 
4920 // File lib/ERC721A/contracts/extensions/IERC721AQueryable.sol
4921 
4922  
4923 // ERC721A Contracts v4.2.3
4924 // Creator: Chiru Labs
4925 
4926 pragma solidity ^0.8.4;
4927 
4928 /**
4929  * @dev Interface of ERC721AQueryable.
4930  */
4931 interface IERC721AQueryable is IERC721A {
4932     /**
4933      * Invalid query range (`start` >= `stop`).
4934      */
4935     error InvalidQueryRange();
4936 
4937     /**
4938      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
4939      *
4940      * If the `tokenId` is out of bounds:
4941      *
4942      * - `addr = address(0)`
4943      * - `startTimestamp = 0`
4944      * - `burned = false`
4945      * - `extraData = 0`
4946      *
4947      * If the `tokenId` is burned:
4948      *
4949      * - `addr = <Address of owner before token was burned>`
4950      * - `startTimestamp = <Timestamp when token was burned>`
4951      * - `burned = true`
4952      * - `extraData = <Extra data when token was burned>`
4953      *
4954      * Otherwise:
4955      *
4956      * - `addr = <Address of owner>`
4957      * - `startTimestamp = <Timestamp of start of ownership>`
4958      * - `burned = false`
4959      * - `extraData = <Extra data at start of ownership>`
4960      */
4961     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
4962 
4963     /**
4964      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
4965      * See {ERC721AQueryable-explicitOwnershipOf}
4966      */
4967     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
4968 
4969     /**
4970      * @dev Returns an array of token IDs owned by `owner`,
4971      * in the range [`start`, `stop`)
4972      * (i.e. `start <= tokenId < stop`).
4973      *
4974      * This function allows for tokens to be queried if the collection
4975      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
4976      *
4977      * Requirements:
4978      *
4979      * - `start < stop`
4980      */
4981     function tokensOfOwnerIn(
4982         address owner,
4983         uint256 start,
4984         uint256 stop
4985     ) external view returns (uint256[] memory);
4986 
4987     /**
4988      * @dev Returns an array of token IDs owned by `owner`.
4989      *
4990      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
4991      * It is meant to be called off-chain.
4992      *
4993      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
4994      * multiple smaller scans if the collection is large enough to cause
4995      * an out-of-gas error (10K collections should be fine).
4996      */
4997     function tokensOfOwner(address owner) external view returns (uint256[] memory);
4998 }
4999 
5000 
5001 // File lib/ERC721A/contracts/interfaces/IERC721AQueryable.sol
5002 
5003  
5004 // ERC721A Contracts v4.2.3
5005 // Creator: Chiru Labs
5006 
5007 pragma solidity ^0.8.4;
5008 
5009 
5010 // File src/Frens.sol
5011 
5012  
5013 pragma solidity ^0.8.17;
5014 
5015 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5016 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5017 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5018 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5019 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5020 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5021 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5022 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓████████╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5023 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬████▀│▄▓███╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓█▒╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5024 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬███▀│▄████▀██░╙▀╣╬╬╬╬╬╬╬╬╬╬▓▀╙▐█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5025 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬███╙░▄███▄▄▄▒██▒░░░░╙▀▓╬╬▓╝▀└   █╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5026 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██│░]███▀░░░░╚███▒░░░░▄▓██▄'    ▐█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5027 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██│░▄██░╠╠╠╠╠╠╠██▌╙█▄▓╬╬╬╬╬╬╬▓▄  █╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5028 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██│░▐██▒▄▓▀▀▀#╠╠███▀│██╬╬╬╬╬╬╬╬╬▓▓█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5029 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██░░░██░░░▄▄▄▄▄░╠██▌░░░╟█╬╬╬╬╬╬╬╬╬█╙█▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5030 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╟█▌░░▓█▓██████▀▀█████░░░░██╬╬╬╬╬╬╬╫▌░░│▀█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5031 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██░░░████▄▄███▓▓▓████░░░░░█▒╬╬╬╬╬╬█░░░░░│▀█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5032 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣██░░░██▒░╚╚▀▀▀▀╚░╠╟██░░░░░╟█╬╬╬╬╬█▒╚╚╚╟▌░░│▀█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5033 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╫▌▌░░░██▒╠╠╠╠╠╠╠╠╠╠╟██▒░░░░░█╬╬╬╬╬█▄▄▄▄▄█░░░░│▀█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5034 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▓▌░░░██╠▒▒╠╠░▄▄▄░╠╟██▒░░░░░╫█╬╬╬██╬╬██░█░░░░░░│█▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5035 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▒▌░░░██╚▀▀▀╠▒╚╚░░▒╠██▌░░░░░╟█╬╬╣█╟▌░░▄▓▀░░░░░░░░╙█╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5036 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▌▌░░░█████████████████░░░░░║█╬╬█▒╠█░░╟▒░█╚▌░█╬█▄▄██╬╬╬╬╬╬╬╬╬╬╬╬╬
5037 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▌█░░░████▀▀▀▀▀▀▀╙╙╠█▀█░░░░░▐█╬╣█╠╠╟▌░░╙╙░░█╣▒╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5038 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▌╫░░░╟█         .▓▀│░█░░░░░]█╬█░╠╠╠█░░░░░░█╫╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5039 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▌╚▌░░░▀▀██'    ▄█│░░░█▒░░░░▐█╫▌╠╠╠╠╟▌░░░▓▀██▀█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5040 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣▒▄▄█░▄███░█'  .▓▀▄╪▀╪░╫▌░░░░╟██▒╠╠╠╠╠█░░╫█#▀▀▓█▒╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5041 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠╬╬╬╬╬╬█╬█╙╙' .█│░▄██▓▄╟▌░░░░╫█▌╠╠╠╠╠╠╫▌░░╫▄▄▄█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5042 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█╫⌐   .█░░╙█╫███░█░░░░██╠╠╠╠╠╠╠╠█░░░░███▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5043 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬███▌    █▒░░░│╙╙│░░█░░░]█▒╠╠╠╠╠╠╠╠█▌░░░░░╫█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5044 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓.   ▐▌░░░░░░░░;▄█▒░░╫█╠╠╠╠╠╠╠╠╠╠█░░░░½█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5045 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█╙.  │█░░░░░░░░░╙╬█▒░░█▓▓▌╠╠╠╠╠╠╠╠█▌░░░█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5046 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▌    j▌░░░░░░░░░░░▐╬███▓▓▒╠╠╠╠╠╠╠▄█▒░░██╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5047 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▌    ▐▌░░░░░░░░░░░▐╬█▒╠╠╠╠╠╠╠╠╠╠█▀░░░██╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5048 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█    j▌░░░░░░░░]▓▀▓█▀▌╠╠╠╠╠╠╠╬█▀░░░╓██╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5049 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█,  '█░░░░░░░░█#▀▀▀▄█╠╠╠╠╠▒█▀░░░░▓██╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5050 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓▓▄╟▌░░░░░░░╟▄▄▄▄▓░╠╠╠▄█▀░░░░▄█▒██╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5051 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣██▓▓▄▄▄▄░░░╙╫▒╠▒▓█▒░░░░▓█╬╬╫█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5052 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█╙█▄░░│╙╠█▀▀▓▓█▀░░░░▄█╬╬╬╬╬██╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5053 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█░░╙▀▓▄░░▀▀▀╙░░▄▄██╬╬╬╬╬╬╬╬█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5054 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▒░░░░│█╬▀▀▀▀╬█╬╬╬╬╬╬╬╬╬╬╬╟█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5055 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▒░░░░░█╠╠╠╠╠╠▀█▒╬╬╬╬╬╬╬╬╬╫█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5056 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█░░░░░░█╠╠╠╠╠╠▓█╬╬╬╬╬╬╬╬╬╬╫█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5057 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣█░░░░│▄█╠╠╠╠╠╠█╬╬╬╬╬╬╬╬╬╬╬╫▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5058 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▒░░░▓█░╠╠╠╠╠╠╠╫▒╬╬╬╬╬╬╬╬╬╬╫█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5059 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣█░░░░░██▒╠╠╠╠╠╠╟█╬╬╬╬╬╬╬╬╬╬╫█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5060 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█░░░░░░░██▒╠╠╠╠╠╟█╬╬╬╬╬╬╬╬╬╬╣█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5061 // ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬█▌░░░░░░░░███▒╠╠╠╠█╬╬╬╬╬╬╬╬╬╬╬██╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬
5062 // 
5063 // FRENS are fun, colorful art by Gabe Weis 
5064 // FRENS are fun, colorful code by Ryan Meyers
5065 //
5066 // The world will be saved by beauty
5067 //
5068 
5069 
5070 
5071 
5072 contract FRENS is IFrens, ERC721PartnerSeaDropBurnable {
5073 
5074     mapping(uint24 => Epoch) epochs; // All epochs
5075     uint24 public epoch;  // The current epoch index
5076     mapping(uint256 => bool) stoicsClaimed;
5077     bool public breakupsAllowed;
5078 
5079     IERC721AQueryable public Stoics;
5080     
5081 
5082     /**
5083      * @notice Deploy the token contract with its name, symbol,
5084      *         administrator, and allowed SeaDrop addresses.
5085      */
5086     constructor(
5087         string memory name,
5088         string memory symbol,
5089         address administrator,
5090         address[] memory allowedSeaDrop
5091     ) ERC721PartnerSeaDropBurnable(name, symbol, administrator, allowedSeaDrop) {
5092         epoch = 1;
5093         Stoics = IERC721AQueryable(0x12632d6E11C6Bbc0c53f3e281eA675e5899a5DF5);
5094     }
5095 
5096     /**
5097      * @notice Mint tokens, restricted to the SeaDrop contract.
5098      *
5099      * @param minter   The address to mint to.
5100      * @param quantity The number of tokens to mint.
5101      */
5102     function mintSeaDrop(address minter, uint256 quantity)
5103         external
5104         virtual
5105         override
5106     {
5107         // BOGO for Stoics
5108         uint256 stoicsBalance = Stoics.balanceOf(minter);
5109 
5110         if (stoicsBalance > 0){
5111             uint extraFrens = 0;
5112             uint[] memory ownedStoics = Stoics.tokensOfOwner(minter);
5113             for(uint i = 0; i < stoicsBalance && extraFrens < quantity;){
5114                 if(!stoicsClaimed[ownedStoics[i]]) {
5115                     unchecked { extraFrens++; }
5116                     stoicsClaimed[ownedStoics[i]] = true;
5117                 }
5118                 unchecked { i++; }
5119             }
5120             unchecked { quantity += extraFrens; }
5121         }
5122         // Ensure the SeaDrop is allowed.
5123         _onlyAllowedSeaDrop(msg.sender);
5124         // Mint the quantity of tokens to the minter.
5125         _mint(minter, quantity);
5126     }
5127 
5128     function _mint(address to, uint256 quantity) internal override {
5129         uint256 nextTokenId = _nextTokenId();
5130         resolveEpochIfNecessary();
5131         super._mint(to, quantity);
5132         // Store the epoch in the erc721a extraData
5133         _setExtraDataAt(nextTokenId, epoch);
5134     }
5135 
5136     function breakup(
5137         uint256 tokenOne, uint256 tokenTwo
5138     ) public {
5139         _burn(tokenOne, true);
5140         _burn(tokenTwo, true);
5141         _mint(msg.sender, 1);
5142     }
5143 
5144     function toggleBreakups() public onlyOwnerOrAdministrator {
5145         breakupsAllowed = !breakupsAllowed;
5146     }
5147 
5148 
5149     /// @notice Initializes and closes epochs.
5150     /// @dev Based on the commit-reveal scheme proposed by MouseDev.
5151     function resolveEpochIfNecessary() public {
5152         Epoch storage currentEpoch = epochs[epoch];
5153 
5154         if (
5155             // If epoch has not been committed,
5156             currentEpoch.committed == false ||
5157             // Or the reveal commitment timed out.
5158             (currentEpoch.revealed == false && currentEpoch.revealBlock < block.number - 256)
5159         ) {
5160             // This means the epoch has not been committed, OR the epoch was committed but has expired.
5161             // Set committed to true, and record the reveal block:
5162             currentEpoch.revealBlock = uint64(block.number + 50);
5163             currentEpoch.committed = true;
5164 
5165         } else if (block.number > currentEpoch.revealBlock) {
5166             // Epoch has been committed and is within range to be revealed.
5167             // Set its randomness to the target block hash.
5168             currentEpoch.randomness = uint128(uint256(keccak256(
5169                 abi.encodePacked(
5170                     blockhash(currentEpoch.revealBlock),
5171                     block.difficulty
5172                 ))) % (2 ** 128 - 1)
5173             );
5174             currentEpoch.revealed = true;
5175 
5176             // Notify DAPPs about the new epoch.
5177             emit NewEpoch(epoch, currentEpoch.revealBlock);
5178 
5179             // Initialize the next epoch
5180             epoch++;
5181             resolveEpochIfNecessary();
5182         }
5183     }
5184 
5185     function tokenURI(uint256 tokenId) public view override returns (string memory) {
5186         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
5187         Epoch storage tokenEpoch = epochs[_ownershipOf(tokenId).extraData];
5188         return FrensMetadata.tokenURI(tokenId, tokenEpoch.randomness, _baseURI());
5189     }
5190 
5191     function _extraData(address, address, uint24 previousExtraData) internal pure override returns (uint24) {
5192         return previousExtraData;
5193     }
5194 
5195     
5196 
5197 }