1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Interface of the ERC165 standard, as defined in the
123  * https://eips.ethereum.org/EIPS/eip-165[EIP].
124  *
125  * Implementers can declare support of contract interfaces, which can then be
126  * queried by others ({ERC165Checker}).
127  *
128  * For an implementation, see {ERC165}.
129  */
130 interface IERC165 {
131     /**
132      * @dev Returns true if this contract implements the interface defined by
133      * `interfaceId`. See the corresponding
134      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
135      * to learn more about how these ids are created.
136      *
137      * This function call must use less than 30 000 gas.
138      */
139     function supportsInterface(bytes4 interfaceId) external view returns (bool);
140 }
141 
142 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 
150 /**
151  * @dev Implementation of the {IERC165} interface.
152  *
153  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
154  * for the additional interface id that will be supported. For example:
155  *
156  * ```solidity
157  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
158  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
159  * }
160  * ```
161  *
162  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
163  */
164 abstract contract ERC165 is IERC165 {
165     /**
166      * @dev See {IERC165-supportsInterface}.
167      */
168     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
169         return interfaceId == type(IERC165).interfaceId;
170     }
171 }
172 
173 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
174 
175 
176 // ERC721A Contracts v4.2.2
177 // Creator: Chiru Labs
178 
179 pragma solidity ^0.8.4;
180 
181 /**
182  * @dev Interface of ERC721A.
183  */
184 interface IERC721A {
185     /**
186      * The caller must own the token or be an approved operator.
187      */
188     error ApprovalCallerNotOwnerNorApproved();
189 
190     /**
191      * The token does not exist.
192      */
193     error ApprovalQueryForNonexistentToken();
194 
195     /**
196      * The caller cannot approve to their own address.
197      */
198     error ApproveToCaller();
199 
200     /**
201      * Cannot query the balance for the zero address.
202      */
203     error BalanceQueryForZeroAddress();
204 
205     /**
206      * Cannot mint to the zero address.
207      */
208     error MintToZeroAddress();
209 
210     /**
211      * The quantity of tokens minted must be more than zero.
212      */
213     error MintZeroQuantity();
214 
215     /**
216      * The token does not exist.
217      */
218     error OwnerQueryForNonexistentToken();
219 
220     /**
221      * The caller must own the token or be an approved operator.
222      */
223     error TransferCallerNotOwnerNorApproved();
224 
225     /**
226      * The token must be owned by `from`.
227      */
228     error TransferFromIncorrectOwner();
229 
230     /**
231      * Cannot safely transfer to a contract that does not implement the
232      * ERC721Receiver interface.
233      */
234     error TransferToNonERC721ReceiverImplementer();
235 
236     /**
237      * Cannot transfer to the zero address.
238      */
239     error TransferToZeroAddress();
240 
241     /**
242      * The token does not exist.
243      */
244     error URIQueryForNonexistentToken();
245 
246     /**
247      * The `quantity` minted with ERC2309 exceeds the safety limit.
248      */
249     error MintERC2309QuantityExceedsLimit();
250 
251     /**
252      * The `extraData` cannot be set on an unintialized ownership slot.
253      */
254     error OwnershipNotInitializedForExtraData();
255 
256     // =============================================================
257     //                            STRUCTS
258     // =============================================================
259 
260     struct TokenOwnership {
261         // The address of the owner.
262         address addr;
263         // Stores the start time of ownership with minimal overhead for tokenomics.
264         uint64 startTimestamp;
265         // Whether the token has been burned.
266         bool burned;
267         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
268         uint24 extraData;
269     }
270 
271     // =============================================================
272     //                         TOKEN COUNTERS
273     // =============================================================
274 
275     /**
276      * @dev Returns the total number of tokens in existence.
277      * Burned tokens will reduce the count.
278      * To get the total number of tokens minted, please see {_totalMinted}.
279      */
280     function totalSupply() external view returns (uint256);
281 
282     // =============================================================
283     //                            IERC165
284     // =============================================================
285 
286     /**
287      * @dev Returns true if this contract implements the interface defined by
288      * `interfaceId`. See the corresponding
289      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
290      * to learn more about how these ids are created.
291      *
292      * This function call must use less than 30000 gas.
293      */
294     function supportsInterface(bytes4 interfaceId) external view returns (bool);
295 
296     // =============================================================
297     //                            IERC721
298     // =============================================================
299 
300     /**
301      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
302      */
303     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
304 
305     /**
306      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
307      */
308     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
309 
310     /**
311      * @dev Emitted when `owner` enables or disables
312      * (`approved`) `operator` to manage all of its assets.
313      */
314     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
315 
316     /**
317      * @dev Returns the number of tokens in `owner`'s account.
318      */
319     function balanceOf(address owner) external view returns (uint256 balance);
320 
321     /**
322      * @dev Returns the owner of the `tokenId` token.
323      *
324      * Requirements:
325      *
326      * - `tokenId` must exist.
327      */
328     function ownerOf(uint256 tokenId) external view returns (address owner);
329 
330     /**
331      * @dev Safely transfers `tokenId` token from `from` to `to`,
332      * checking first that contract recipients are aware of the ERC721 protocol
333      * to prevent tokens from being forever locked.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `tokenId` token must exist and be owned by `from`.
340      * - If the caller is not `from`, it must be have been allowed to move
341      * this token by either {approve} or {setApprovalForAll}.
342      * - If `to` refers to a smart contract, it must implement
343      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
344      *
345      * Emits a {Transfer} event.
346      */
347     function safeTransferFrom(
348         address from,
349         address to,
350         uint256 tokenId,
351         bytes calldata data
352     ) external;
353 
354     /**
355      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
356      */
357     function safeTransferFrom(
358         address from,
359         address to,
360         uint256 tokenId
361     ) external;
362 
363     /**
364      * @dev Transfers `tokenId` from `from` to `to`.
365      *
366      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
367      * whenever possible.
368      *
369      * Requirements:
370      *
371      * - `from` cannot be the zero address.
372      * - `to` cannot be the zero address.
373      * - `tokenId` token must be owned by `from`.
374      * - If the caller is not `from`, it must be approved to move this token
375      * by either {approve} or {setApprovalForAll}.
376      *
377      * Emits a {Transfer} event.
378      */
379     function transferFrom(
380         address from,
381         address to,
382         uint256 tokenId
383     ) external;
384 
385     /**
386      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
387      * The approval is cleared when the token is transferred.
388      *
389      * Only a single account can be approved at a time, so approving the
390      * zero address clears previous approvals.
391      *
392      * Requirements:
393      *
394      * - The caller must own the token or be an approved operator.
395      * - `tokenId` must exist.
396      *
397      * Emits an {Approval} event.
398      */
399     function approve(address to, uint256 tokenId) external;
400 
401     /**
402      * @dev Approve or remove `operator` as an operator for the caller.
403      * Operators can call {transferFrom} or {safeTransferFrom}
404      * for any token owned by the caller.
405      *
406      * Requirements:
407      *
408      * - The `operator` cannot be the caller.
409      *
410      * Emits an {ApprovalForAll} event.
411      */
412     function setApprovalForAll(address operator, bool _approved) external;
413 
414     /**
415      * @dev Returns the account approved for `tokenId` token.
416      *
417      * Requirements:
418      *
419      * - `tokenId` must exist.
420      */
421     function getApproved(uint256 tokenId) external view returns (address operator);
422 
423     /**
424      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
425      *
426      * See {setApprovalForAll}.
427      */
428     function isApprovedForAll(address owner, address operator) external view returns (bool);
429 
430     // =============================================================
431     //                        IERC721Metadata
432     // =============================================================
433 
434     /**
435      * @dev Returns the token collection name.
436      */
437     function name() external view returns (string memory);
438 
439     /**
440      * @dev Returns the token collection symbol.
441      */
442     function symbol() external view returns (string memory);
443 
444     /**
445      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
446      */
447     function tokenURI(uint256 tokenId) external view returns (string memory);
448 
449     // =============================================================
450     //                           IERC2309
451     // =============================================================
452 
453     /**
454      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
455      * (inclusive) is transferred from `from` to `to`, as defined in the
456      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
457      *
458      * See {_mintERC2309} for more details.
459      */
460     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
461 }
462 
463 // File: contracts/Romail.sol
464 
465 
466 
467 pragma solidity ^0.8.4;
468 
469 
470 
471 /**
472  * @dev Interface of ERC721 token receiver.
473  */
474 interface ERC721A__IERC721Receiver {
475     function onERC721Received(
476         address operator,
477         address from,
478         uint256 tokenId,
479         bytes calldata data
480     ) external returns (bytes4);
481 }
482 
483 /**
484  * @title ERC721A
485  *
486  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
487  * Non-Fungible Token Standard, including the Metadata extension.
488  * Optimized for lower gas during batch mints.
489  *
490  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
491  * starting from `_startTokenId()`.
492  *
493  * Assumptions:
494  *
495  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
496  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
497  */
498 contract ERC721A is IERC721A {
499     // Reference type for token approval.
500     struct TokenApprovalRef {
501         address value;
502     }
503 
504     // =============================================================
505     //                           CONSTANTS
506     // =============================================================
507 
508     // Mask of an entry in packed address data.
509     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
510 
511     // The bit position of `numberMinted` in packed address data.
512     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
513 
514     // The bit position of `numberBurned` in packed address data.
515     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
516 
517     // The bit position of `aux` in packed address data.
518     uint256 private constant _BITPOS_AUX = 192;
519 
520     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
521     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
522 
523     // The bit position of `startTimestamp` in packed ownership.
524     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
525 
526     // The bit mask of the `burned` bit in packed ownership.
527     uint256 private constant _BITMASK_BURNED = 1 << 224;
528 
529     // The bit position of the `nextInitialized` bit in packed ownership.
530     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
531 
532     // The bit mask of the `nextInitialized` bit in packed ownership.
533     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
534 
535     // The bit position of `extraData` in packed ownership.
536     uint256 private constant _BITPOS_EXTRA_DATA = 232;
537 
538     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
539     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
540 
541     // The mask of the lower 160 bits for addresses.
542     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
543 
544     // The maximum `quantity` that can be minted with {_mintERC2309}.
545     // This limit is to prevent overflows on the address data entries.
546     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
547     // is required to cause an overflow, which is unrealistic.
548     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
549 
550     // The `Transfer` event signature is given by:
551     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
552     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
553         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
554 
555     // =============================================================
556     //                            STORAGE
557     // =============================================================
558 
559     // The next token ID to be minted.
560     uint256 private _currentIndex;
561 
562     // The number of tokens burned.
563     uint256 private _burnCounter;
564 
565     // Token name
566     string private _name;
567 
568     // Token symbol
569     string private _symbol;
570 
571     // Mapping from token ID to ownership details
572     // An empty struct value does not necessarily mean the token is unowned.
573     // See {_packedOwnershipOf} implementation for details.
574     //
575     // Bits Layout:
576     // - [0..159]   `addr`
577     // - [160..223] `startTimestamp`
578     // - [224]      `burned`
579     // - [225]      `nextInitialized`
580     // - [232..255] `extraData`
581     mapping(uint256 => uint256) private _packedOwnerships;
582 
583     // Mapping owner address to address data.
584     //
585     // Bits Layout:
586     // - [0..63]    `balance`
587     // - [64..127]  `numberMinted`
588     // - [128..191] `numberBurned`
589     // - [192..255] `aux`
590     mapping(address => uint256) private _packedAddressData;
591 
592     // Mapping from token ID to approved address.
593     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
594 
595     // Mapping from owner to operator approvals
596     mapping(address => mapping(address => bool)) private _operatorApprovals;
597 
598     // =============================================================
599     //                          CONSTRUCTOR
600     // =============================================================
601 
602     constructor(string memory name_, string memory symbol_) {
603         _name = name_;
604         _symbol = symbol_;
605         _currentIndex = _startTokenId();
606     }
607 
608     // =============================================================
609     //                   TOKEN COUNTING OPERATIONS
610     // =============================================================
611 
612     /**
613      * @dev Returns the starting token ID.
614      * To change the starting token ID, please override this function.
615      */
616     function _startTokenId() internal view virtual returns (uint256) {
617         return 1;
618     }
619 
620     /**
621      * @dev Returns the next token ID to be minted.
622      */
623     function _nextTokenId() internal view virtual returns (uint256) {
624         return _currentIndex;
625     }
626 
627     /**
628      * @dev Returns the total number of tokens in existence.
629      * Burned tokens will reduce the count.
630      * To get the total number of tokens minted, please see {_totalMinted}.
631      */
632     function totalSupply() public view virtual override returns (uint256) {
633         // Counter underflow is impossible as _burnCounter cannot be incremented
634         // more than `_currentIndex - _startTokenId()` times.
635         unchecked {
636             return _currentIndex - _burnCounter - _startTokenId();
637         }
638     }
639 
640     /**
641      * @dev Returns the total amount of tokens minted in the contract.
642      */
643     function _totalMinted() internal view virtual returns (uint256) {
644         // Counter underflow is impossible as `_currentIndex` does not decrement,
645         // and it is initialized to `_startTokenId()`.
646         unchecked {
647             return _currentIndex - _startTokenId();
648         }
649     }
650 
651     /**
652      * @dev Returns the total number of tokens burned.
653      */
654     function _totalBurned() internal view virtual returns (uint256) {
655         return _burnCounter;
656     }
657 
658     // =============================================================
659     //                    ADDRESS DATA OPERATIONS
660     // =============================================================
661 
662     /**
663      * @dev Returns the number of tokens in `owner`'s account.
664      */
665     function balanceOf(address owner) public view virtual override returns (uint256) {
666         if (owner == address(0)) revert BalanceQueryForZeroAddress();
667         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
668     }
669 
670     /**
671      * Returns the number of tokens minted by `owner`.
672      */
673     function _numberMinted(address owner) internal view returns (uint256) {
674         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
675     }
676 
677     /**
678      * Returns the number of tokens burned by or on behalf of `owner`.
679      */
680     function _numberBurned(address owner) internal view returns (uint256) {
681         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
682     }
683 
684     /**
685      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
686      */
687     function _getAux(address owner) internal view returns (uint64) {
688         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
689     }
690 
691     /**
692      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
693      * If there are multiple variables, please pack them into a uint64.
694      */
695     function _setAux(address owner, uint64 aux) internal virtual {
696         uint256 packed = _packedAddressData[owner];
697         uint256 auxCasted;
698         // Cast `aux` with assembly to avoid redundant masking.
699         assembly {
700             auxCasted := aux
701         }
702         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
703         _packedAddressData[owner] = packed;
704     }
705 
706     // =============================================================
707     //                            IERC165
708     // =============================================================
709 
710     /**
711      * @dev Returns true if this contract implements the interface defined by
712      * `interfaceId`. See the corresponding
713      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
714      * to learn more about how these ids are created.
715      *
716      * This function call must use less than 30000 gas.
717      */
718     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719         // The interface IDs are constants representing the first 4 bytes
720         // of the XOR of all function selectors in the interface.
721         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
722         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
723         return
724             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
725             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
726             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
727     }
728 
729     // =============================================================
730     //                        IERC721Metadata
731     // =============================================================
732 
733     /**
734      * @dev Returns the token collection name.
735      */
736     function name() public view virtual override returns (string memory) {
737         return _name;
738     }
739 
740     /**
741      * @dev Returns the token collection symbol.
742      */
743     function symbol() public view virtual override returns (string memory) {
744         return _symbol;
745     }
746 
747     /**
748      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
749      */
750     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
751         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
752 
753         string memory baseURI = _baseURI();
754         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
755     }
756 
757     /**
758      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
759      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
760      * by default, it can be overridden in child contracts.
761      */
762     function _baseURI() internal view virtual returns (string memory) {
763         return '';
764     }
765 
766     // =============================================================
767     //                     OWNERSHIPS OPERATIONS
768     // =============================================================
769 
770     /**
771      * @dev Returns the owner of the `tokenId` token.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must exist.
776      */
777     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
778         return address(uint160(_packedOwnershipOf(tokenId)));
779     }
780 
781     /**
782      * @dev Gas spent here starts off proportional to the maximum mint batch size.
783      * It gradually moves to O(1) as tokens get transferred around over time.
784      */
785     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
786         return _unpackedOwnership(_packedOwnershipOf(tokenId));
787     }
788 
789     /**
790      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
791      */
792     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
793         return _unpackedOwnership(_packedOwnerships[index]);
794     }
795 
796     /**
797      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
798      */
799     function _initializeOwnershipAt(uint256 index) internal virtual {
800         if (_packedOwnerships[index] == 0) {
801             _packedOwnerships[index] = _packedOwnershipOf(index);
802         }
803     }
804 
805     /**
806      * Returns the packed ownership data of `tokenId`.
807      */
808     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
809         uint256 curr = tokenId;
810 
811         unchecked {
812             if (_startTokenId() <= curr)
813                 if (curr < _currentIndex) {
814                     uint256 packed = _packedOwnerships[curr];
815                     // If not burned.
816                     if (packed & _BITMASK_BURNED == 0) {
817                         // Invariant:
818                         // There will always be an initialized ownership slot
819                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
820                         // before an unintialized ownership slot
821                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
822                         // Hence, `curr` will not underflow.
823                         //
824                         // We can directly compare the packed value.
825                         // If the address is zero, packed will be zero.
826                         while (packed == 0) {
827                             packed = _packedOwnerships[--curr];
828                         }
829                         return packed;
830                     }
831                 }
832         }
833         revert OwnerQueryForNonexistentToken();
834     }
835 
836     /**
837      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
838      */
839     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
840         ownership.addr = address(uint160(packed));
841         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
842         ownership.burned = packed & _BITMASK_BURNED != 0;
843         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
844     }
845 
846     /**
847      * @dev Packs ownership data into a single uint256.
848      */
849     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
850         assembly {
851             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
852             owner := and(owner, _BITMASK_ADDRESS)
853             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
854             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
855         }
856     }
857 
858     /**
859      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
860      */
861     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
862         // For branchless setting of the `nextInitialized` flag.
863         assembly {
864             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
865             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
866         }
867     }
868 
869     // =============================================================
870     //                      APPROVAL OPERATIONS
871     // =============================================================
872 
873     /**
874      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
875      * The approval is cleared when the token is transferred.
876      *
877      * Only a single account can be approved at a time, so approving the
878      * zero address clears previous approvals.
879      *
880      * Requirements:
881      *
882      * - The caller must own the token or be an approved operator.
883      * - `tokenId` must exist.
884      *
885      * Emits an {Approval} event.
886      */
887     function approve(address to, uint256 tokenId) public virtual override {
888         address owner = ownerOf(tokenId);
889 
890         if (_msgSenderERC721A() != owner)
891             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
892                 revert ApprovalCallerNotOwnerNorApproved();
893             }
894 
895         _tokenApprovals[tokenId].value = to;
896         emit Approval(owner, to, tokenId);
897     }
898 
899     /**
900      * @dev Returns the account approved for `tokenId` token.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      */
906     function getApproved(uint256 tokenId) public view virtual override returns (address) {
907         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
908 
909         return _tokenApprovals[tokenId].value;
910     }
911 
912     /**
913      * @dev Approve or remove `operator` as an operator for the caller.
914      * Operators can call {transferFrom} or {safeTransferFrom}
915      * for any token owned by the caller.
916      *
917      * Requirements:
918      *
919      * - The `operator` cannot be the caller.
920      *
921      * Emits an {ApprovalForAll} event.
922      */
923     function setApprovalForAll(address operator, bool approved) public virtual override {
924         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
925         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
926     }
927 
928     /**
929      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
930      *
931      * See {setApprovalForAll}.
932      */
933     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
934         return _operatorApprovals[owner][operator];
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted. See {_mint}.
943      */
944     function _exists(uint256 tokenId) internal view virtual returns (bool) {
945         return
946             _startTokenId() <= tokenId &&
947             tokenId < _currentIndex && // If within bounds,
948             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
949     }
950 
951     /**
952      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
953      */
954     function _isSenderApprovedOrOwner(
955         address approvedAddress,
956         address owner,
957         address msgSender
958     ) private pure returns (bool result) {
959         assembly {
960             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
961             owner := and(owner, _BITMASK_ADDRESS)
962             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
963             msgSender := and(msgSender, _BITMASK_ADDRESS)
964             // `msgSender == owner || msgSender == approvedAddress`.
965             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
966         }
967     }
968 
969     /**
970      * @dev Returns the storage slot and value for the approved address of `tokenId`.
971      */
972     function _getApprovedSlotAndAddress(uint256 tokenId)
973         private
974         view
975         returns (uint256 approvedAddressSlot, address approvedAddress)
976     {
977         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
978         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
979         assembly {
980             approvedAddressSlot := tokenApproval.slot
981             approvedAddress := sload(approvedAddressSlot)
982         }
983     }
984 
985     // =============================================================
986     //                      TRANSFER OPERATIONS
987     // =============================================================
988 
989     /**
990      * @dev Transfers `tokenId` from `from` to `to`.
991      *
992      * Requirements:
993      *
994      * - `from` cannot be the zero address.
995      * - `to` cannot be the zero address.
996      * - `tokenId` token must be owned by `from`.
997      * - If the caller is not `from`, it must be approved to move this token
998      * by either {approve} or {setApprovalForAll}.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1008 
1009         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1010 
1011         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1012 
1013         // The nested ifs save around 20+ gas over a compound boolean condition.
1014         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1015             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1016 
1017         if (to == address(0)) revert TransferToZeroAddress();
1018 
1019         _beforeTokenTransfers(from, to, tokenId, 1);
1020 
1021         // Clear approvals from the previous owner.
1022         assembly {
1023             if approvedAddress {
1024                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1025                 sstore(approvedAddressSlot, 0)
1026             }
1027         }
1028 
1029         // Underflow of the sender's balance is impossible because we check for
1030         // ownership above and the recipient's balance can't realistically overflow.
1031         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1032         unchecked {
1033             // We can directly increment and decrement the balances.
1034             --_packedAddressData[from]; // Updates: `balance -= 1`.
1035             ++_packedAddressData[to]; // Updates: `balance += 1`.
1036 
1037             // Updates:
1038             // - `address` to the next owner.
1039             // - `startTimestamp` to the timestamp of transfering.
1040             // - `burned` to `false`.
1041             // - `nextInitialized` to `true`.
1042             _packedOwnerships[tokenId] = _packOwnershipData(
1043                 to,
1044                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1045             );
1046 
1047             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1048             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1049                 uint256 nextTokenId = tokenId + 1;
1050                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1051                 if (_packedOwnerships[nextTokenId] == 0) {
1052                     // If the next slot is within bounds.
1053                     if (nextTokenId != _currentIndex) {
1054                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1055                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1056                     }
1057                 }
1058             }
1059         }
1060 
1061         emit Transfer(from, to, tokenId);
1062         _afterTokenTransfers(from, to, tokenId, 1);
1063     }
1064 
1065     /**
1066      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1067      */
1068     function safeTransferFrom(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) public virtual override {
1073         safeTransferFrom(from, to, tokenId, '');
1074     }
1075 
1076     /**
1077      * @dev Safely transfers `tokenId` token from `from` to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - `from` cannot be the zero address.
1082      * - `to` cannot be the zero address.
1083      * - `tokenId` token must exist and be owned by `from`.
1084      * - If the caller is not `from`, it must be approved to move this token
1085      * by either {approve} or {setApprovalForAll}.
1086      * - If `to` refers to a smart contract, it must implement
1087      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) public virtual override {
1097         transferFrom(from, to, tokenId);
1098         if (to.code.length != 0)
1099             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1100                 revert TransferToNonERC721ReceiverImplementer();
1101             }
1102     }
1103 
1104     /**
1105      * @dev Hook that is called before a set of serially-ordered token IDs
1106      * are about to be transferred. This includes minting.
1107      * And also called before burning one token.
1108      *
1109      * `startTokenId` - the first token ID to be transferred.
1110      * `quantity` - the amount to be transferred.
1111      *
1112      * Calling conditions:
1113      *
1114      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1115      * transferred to `to`.
1116      * - When `from` is zero, `tokenId` will be minted for `to`.
1117      * - When `to` is zero, `tokenId` will be burned by `from`.
1118      * - `from` and `to` are never both zero.
1119      */
1120     function _beforeTokenTransfers(
1121         address from,
1122         address to,
1123         uint256 startTokenId,
1124         uint256 quantity
1125     ) internal virtual {}
1126 
1127     /**
1128      * @dev Hook that is called after a set of serially-ordered token IDs
1129      * have been transferred. This includes minting.
1130      * And also called after one token has been burned.
1131      *
1132      * `startTokenId` - the first token ID to be transferred.
1133      * `quantity` - the amount to be transferred.
1134      *
1135      * Calling conditions:
1136      *
1137      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1138      * transferred to `to`.
1139      * - When `from` is zero, `tokenId` has been minted for `to`.
1140      * - When `to` is zero, `tokenId` has been burned by `from`.
1141      * - `from` and `to` are never both zero.
1142      */
1143     function _afterTokenTransfers(
1144         address from,
1145         address to,
1146         uint256 startTokenId,
1147         uint256 quantity
1148     ) internal virtual {}
1149 
1150     /**
1151      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1152      *
1153      * `from` - Previous owner of the given token ID.
1154      * `to` - Target address that will receive the token.
1155      * `tokenId` - Token ID to be transferred.
1156      * `_data` - Optional data to send along with the call.
1157      *
1158      * Returns whether the call correctly returned the expected magic value.
1159      */
1160     function _checkContractOnERC721Received(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) private returns (bool) {
1166         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1167             bytes4 retval
1168         ) {
1169             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1170         } catch (bytes memory reason) {
1171             if (reason.length == 0) {
1172                 revert TransferToNonERC721ReceiverImplementer();
1173             } else {
1174                 assembly {
1175                     revert(add(32, reason), mload(reason))
1176                 }
1177             }
1178         }
1179     }
1180 
1181     // =============================================================
1182     //                        MINT OPERATIONS
1183     // =============================================================
1184 
1185     /**
1186      * @dev Mints `quantity` tokens and transfers them to `to`.
1187      *
1188      * Requirements:
1189      *
1190      * - `to` cannot be the zero address.
1191      * - `quantity` must be greater than 0.
1192      *
1193      * Emits a {Transfer} event for each mint.
1194      */
1195     function _mint(address to, uint256 quantity) internal virtual {
1196         uint256 startTokenId = _currentIndex;
1197         if (quantity == 0) revert MintZeroQuantity();
1198 
1199         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1200 
1201         // Overflows are incredibly unrealistic.
1202         // `balance` and `numberMinted` have a maximum limit of 2**64.
1203         // `tokenId` has a maximum limit of 2**256.
1204         unchecked {
1205             // Updates:
1206             // - `balance += quantity`.
1207             // - `numberMinted += quantity`.
1208             //
1209             // We can directly add to the `balance` and `numberMinted`.
1210             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1211 
1212             // Updates:
1213             // - `address` to the owner.
1214             // - `startTimestamp` to the timestamp of minting.
1215             // - `burned` to `false`.
1216             // - `nextInitialized` to `quantity == 1`.
1217             _packedOwnerships[startTokenId] = _packOwnershipData(
1218                 to,
1219                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1220             );
1221 
1222             uint256 toMasked;
1223             uint256 end = startTokenId + quantity;
1224 
1225             // Use assembly to loop and emit the `Transfer` event for gas savings.
1226             // The duplicated `log4` removes an extra check and reduces stack juggling.
1227             // The assembly, together with the surrounding Solidity code, have been
1228             // delicately arranged to nudge the compiler into producing optimized opcodes.
1229             assembly {
1230                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1231                 toMasked := and(to, _BITMASK_ADDRESS)
1232                 // Emit the `Transfer` event.
1233                 log4(
1234                     0, // Start of data (0, since no data).
1235                     0, // End of data (0, since no data).
1236                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1237                     0, // `address(0)`.
1238                     toMasked, // `to`.
1239                     startTokenId // `tokenId`.
1240                 )
1241 
1242                 for {
1243                     let tokenId := add(startTokenId, 1)
1244                 } iszero(eq(tokenId, end)) {
1245                     tokenId := add(tokenId, 1)
1246                 } {
1247                     // Emit the `Transfer` event. Similar to above.
1248                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1249                 }
1250             }
1251             if (toMasked == 0) revert MintToZeroAddress();
1252 
1253             _currentIndex = end;
1254         }
1255         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1256     }
1257 
1258     /**
1259      * @dev Mints `quantity` tokens and transfers them to `to`.
1260      *
1261      * This function is intended for efficient minting only during contract creation.
1262      *
1263      * It emits only one {ConsecutiveTransfer} as defined in
1264      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1265      * instead of a sequence of {Transfer} event(s).
1266      *
1267      * Calling this function outside of contract creation WILL make your contract
1268      * non-compliant with the ERC721 standard.
1269      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1270      * {ConsecutiveTransfer} event is only permissible during contract creation.
1271      *
1272      * Requirements:
1273      *
1274      * - `to` cannot be the zero address.
1275      * - `quantity` must be greater than 0.
1276      *
1277      * Emits a {ConsecutiveTransfer} event.
1278      */
1279     function _mintERC2309(address to, uint256 quantity) internal virtual {
1280         uint256 startTokenId = _currentIndex;
1281         if (to == address(0)) revert MintToZeroAddress();
1282         if (quantity == 0) revert MintZeroQuantity();
1283         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1284 
1285         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1286 
1287         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1288         unchecked {
1289             // Updates:
1290             // - `balance += quantity`.
1291             // - `numberMinted += quantity`.
1292             //
1293             // We can directly add to the `balance` and `numberMinted`.
1294             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1295 
1296             // Updates:
1297             // - `address` to the owner.
1298             // - `startTimestamp` to the timestamp of minting.
1299             // - `burned` to `false`.
1300             // - `nextInitialized` to `quantity == 1`.
1301             _packedOwnerships[startTokenId] = _packOwnershipData(
1302                 to,
1303                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1304             );
1305 
1306             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1307 
1308             _currentIndex = startTokenId + quantity;
1309         }
1310         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1311     }
1312 
1313     /**
1314      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1315      *
1316      * Requirements:
1317      *
1318      * - If `to` refers to a smart contract, it must implement
1319      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1320      * - `quantity` must be greater than 0.
1321      *
1322      * See {_mint}.
1323      *
1324      * Emits a {Transfer} event for each mint.
1325      */
1326     function _safeMint(
1327         address to,
1328         uint256 quantity,
1329         bytes memory _data
1330     ) internal virtual {
1331         _mint(to, quantity);
1332 
1333         unchecked {
1334             if (to.code.length != 0) {
1335                 uint256 end = _currentIndex;
1336                 uint256 index = end - quantity;
1337                 do {
1338                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1339                         revert TransferToNonERC721ReceiverImplementer();
1340                     }
1341                 } while (index < end);
1342                 // Reentrancy protection.
1343                 if (_currentIndex != end) revert();
1344             }
1345         }
1346     }
1347 
1348     /**
1349      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1350      */
1351     function _safeMint(address to, uint256 quantity) internal virtual {
1352         _safeMint(to, quantity, '');
1353     }
1354 
1355     // =============================================================
1356     //                        BURN OPERATIONS
1357     // =============================================================
1358 
1359     /**
1360      * @dev Equivalent to `_burn(tokenId, false)`.
1361      */
1362     function _burn(uint256 tokenId) internal virtual {
1363         _burn(tokenId, false);
1364     }
1365 
1366     /**
1367      * @dev Destroys `tokenId`.
1368      * The approval is cleared when the token is burned.
1369      *
1370      * Requirements:
1371      *
1372      * - `tokenId` must exist.
1373      *
1374      * Emits a {Transfer} event.
1375      */
1376     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1377         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1378 
1379         address from = address(uint160(prevOwnershipPacked));
1380 
1381         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1382 
1383         if (approvalCheck) {
1384             // The nested ifs save around 20+ gas over a compound boolean condition.
1385             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1386                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1387         }
1388 
1389         _beforeTokenTransfers(from, address(0), tokenId, 1);
1390 
1391         // Clear approvals from the previous owner.
1392         assembly {
1393             if approvedAddress {
1394                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1395                 sstore(approvedAddressSlot, 0)
1396             }
1397         }
1398 
1399         // Underflow of the sender's balance is impossible because we check for
1400         // ownership above and the recipient's balance can't realistically overflow.
1401         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1402         unchecked {
1403             // Updates:
1404             // - `balance -= 1`.
1405             // - `numberBurned += 1`.
1406             //
1407             // We can directly decrement the balance, and increment the number burned.
1408             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1409             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1410 
1411             // Updates:
1412             // - `address` to the last owner.
1413             // - `startTimestamp` to the timestamp of burning.
1414             // - `burned` to `true`.
1415             // - `nextInitialized` to `true`.
1416             _packedOwnerships[tokenId] = _packOwnershipData(
1417                 from,
1418                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1419             );
1420 
1421             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1422             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1423                 uint256 nextTokenId = tokenId + 1;
1424                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1425                 if (_packedOwnerships[nextTokenId] == 0) {
1426                     // If the next slot is within bounds.
1427                     if (nextTokenId != _currentIndex) {
1428                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1429                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1430                     }
1431                 }
1432             }
1433         }
1434 
1435         emit Transfer(from, address(0), tokenId);
1436         _afterTokenTransfers(from, address(0), tokenId, 1);
1437 
1438         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1439         unchecked {
1440             _burnCounter++;
1441         }
1442     }
1443 
1444     // =============================================================
1445     //                     EXTRA DATA OPERATIONS
1446     // =============================================================
1447 
1448     /**
1449      * @dev Directly sets the extra data for the ownership data `index`.
1450      */
1451     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1452         uint256 packed = _packedOwnerships[index];
1453         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1454         uint256 extraDataCasted;
1455         // Cast `extraData` with assembly to avoid redundant masking.
1456         assembly {
1457             extraDataCasted := extraData
1458         }
1459         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1460         _packedOwnerships[index] = packed;
1461     }
1462 
1463     /**
1464      * @dev Called during each token transfer to set the 24bit `extraData` field.
1465      * Intended to be overridden by the cosumer contract.
1466      *
1467      * `previousExtraData` - the value of `extraData` before transfer.
1468      *
1469      * Calling conditions:
1470      *
1471      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1472      * transferred to `to`.
1473      * - When `from` is zero, `tokenId` will be minted for `to`.
1474      * - When `to` is zero, `tokenId` will be burned by `from`.
1475      * - `from` and `to` are never both zero.
1476      */
1477     function _extraData(
1478         address from,
1479         address to,
1480         uint24 previousExtraData
1481     ) internal view virtual returns (uint24) {}
1482 
1483     /**
1484      * @dev Returns the next extra data for the packed ownership data.
1485      * The returned result is shifted into position.
1486      */
1487     function _nextExtraData(
1488         address from,
1489         address to,
1490         uint256 prevOwnershipPacked
1491     ) private view returns (uint256) {
1492         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1493         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1494     }
1495 
1496     // =============================================================
1497     //                       OTHER OPERATIONS
1498     // =============================================================
1499 
1500     /**
1501      * @dev Returns the message sender (defaults to `msg.sender`).
1502      *
1503      * If you are writing GSN compatible contracts, you need to override this function.
1504      */
1505     function _msgSenderERC721A() internal view virtual returns (address) {
1506         return msg.sender;
1507     }
1508 
1509     /**
1510      * @dev Converts a uint256 to its ASCII string decimal representation.
1511      */
1512     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1513         assembly {
1514             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1515             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1516             // We will need 1 32-byte word to store the length,
1517             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1518             str := add(mload(0x40), 0x80)
1519             // Update the free memory pointer to allocate.
1520             mstore(0x40, str)
1521 
1522             // Cache the end of the memory to calculate the length later.
1523             let end := str
1524 
1525             // We write the string from rightmost digit to leftmost digit.
1526             // The following is essentially a do-while loop that also handles the zero case.
1527             // prettier-ignore
1528             for { let temp := value } 1 {} {
1529                 str := sub(str, 1)
1530                 // Write the character to the pointer.
1531                 // The ASCII index of the '0' character is 48.
1532                 mstore8(str, add(48, mod(temp, 10)))
1533                 // Keep dividing `temp` until zero.
1534                 temp := div(temp, 10)
1535                 // prettier-ignore
1536                 if iszero(temp) { break }
1537             }
1538 
1539             let length := sub(end, str)
1540             // Move the pointer 32 bytes leftwards to make room for the length.
1541             str := sub(str, 0x20)
1542             // Store the length.
1543             mstore(str, length)
1544         }
1545     }
1546 }
1547 
1548 interface IERC721 is IERC165 {
1549     /**
1550      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1551      */
1552     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1553 
1554     /**
1555      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1556      */
1557     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1558 
1559     /**
1560      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1561      */
1562     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1563 
1564     /**
1565      * @dev Returns the number of tokens in ``owner``'s account.
1566      */
1567     function balanceOf(address owner) external view returns (uint256 balance);
1568 
1569     /**
1570      * @dev Returns the owner of the `tokenId` token.
1571      *
1572      * Requirements:
1573      *
1574      * - `tokenId` must exist.
1575      */
1576     function ownerOf(uint256 tokenId) external view returns (address owner);
1577 
1578     /**
1579      * @dev Safely transfers `tokenId` token from `from` to `to`.
1580      *
1581      * Requirements:
1582      *
1583      * - `from` cannot be the zero address.
1584      * - `to` cannot be the zero address.
1585      * - `tokenId` token must exist and be owned by `from`.
1586      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1588      *
1589      * Emits a {Transfer} event.
1590      */
1591     function safeTransferFrom(
1592         address from,
1593         address to,
1594         uint256 tokenId,
1595         bytes calldata data
1596     ) external;
1597 
1598     /**
1599      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1600      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1601      *
1602      * Requirements:
1603      *
1604      * - `from` cannot be the zero address.
1605      * - `to` cannot be the zero address.
1606      * - `tokenId` token must exist and be owned by `from`.
1607      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1609      *
1610      * Emits a {Transfer} event.
1611      */
1612     function safeTransferFrom(
1613         address from,
1614         address to,
1615         uint256 tokenId
1616     ) external;
1617 
1618     /**
1619      * @dev Transfers `tokenId` token from `from` to `to`.
1620      *
1621      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1622      *
1623      * Requirements:
1624      *
1625      * - `from` cannot be the zero address.
1626      * - `to` cannot be the zero address.
1627      * - `tokenId` token must be owned by `from`.
1628      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function transferFrom(
1633         address from,
1634         address to,
1635         uint256 tokenId
1636     ) external;
1637 
1638     /**
1639      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1640      * The approval is cleared when the token is transferred.
1641      *
1642      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1643      *
1644      * Requirements:
1645      *
1646      * - The caller must own the token or be an approved operator.
1647      * - `tokenId` must exist.
1648      *
1649      * Emits an {Approval} event.
1650      */
1651     function approve(address to, uint256 tokenId) external;
1652 
1653     /**
1654      * @dev Approve or remove `operator` as an operator for the caller.
1655      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1656      *
1657      * Requirements:
1658      *
1659      * - The `operator` cannot be the caller.
1660      *
1661      * Emits an {ApprovalForAll} event.
1662      */
1663     function setApprovalForAll(address operator, bool _approved) external;
1664 
1665     /**
1666      * @dev Returns the account approved for `tokenId` token.
1667      *
1668      * Requirements:
1669      *
1670      * - `tokenId` must exist.
1671      */
1672     function getApproved(uint256 tokenId) external view returns (address operator);
1673 
1674     /**
1675      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1676      *
1677      * See {setApprovalForAll}
1678      */
1679     function isApprovedForAll(address owner, address operator) external view returns (bool);
1680 
1681     function walletOfOwner(address _owner) external view returns (uint256[] memory);
1682   
1683 }
1684 
1685 pragma solidity 0.8.15;
1686 
1687 
1688 contract BabyLazyBunnies is ERC721A, Ownable {
1689 
1690     IERC721 ERC721Interface;
1691     uint256 MAX_SUPPLY;
1692     string public baseURI = "ipfs://QmRBwswnJdR35SjDebmKW5sb1Ve2roPJezTc1XTxKj5WDR/";
1693     string public uriSuffix = ".json";
1694     mapping(address => uint8) claimed;
1695     mapping(uint => bool) public nftSold;
1696     
1697 
1698     constructor(address _NFTAddress, uint256 _supply) ERC721A("Baby Lazy Bunnies", "BBLZB") {
1699         ERC721Interface = IERC721(_NFTAddress);
1700         MAX_SUPPLY = _supply;
1701     }
1702 
1703     function mint(uint256 quantity) internal {
1704         _safeMint(msg.sender, quantity);
1705     }
1706 
1707     function claimAirdrop() external {
1708         uint NftOwned = ERC721Interface.walletOfOwner(msg.sender).length;
1709         require(NftOwned > 0, "Not owner of NFT collection");
1710         uint nftToMint = 0;
1711         
1712         for(uint i = 0; i<NftOwned; i++){
1713             if(!nftSold[ERC721Interface.walletOfOwner(msg.sender)[i]]){
1714                 nftSold[ERC721Interface.walletOfOwner(msg.sender)[i]] = true;
1715                 nftToMint++;
1716             }           
1717         }
1718         require(nftToMint > 0, "No NFTs to claim");
1719         mint(nftToMint);
1720     }
1721 
1722 
1723     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1724     require(_exists(tokenId), "Err: ERC721AMetadata - URI query for nonexistent token");
1725 
1726     return bytes(baseURI).length > 0
1727         ? string(abi.encodePacked(baseURI, _toString(tokenId), uriSuffix))
1728         : "";
1729     }
1730 
1731     function withdraw() public payable onlyOwner {
1732  
1733     // =============================================================================
1734     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1735     require(os);
1736     // =============================================================================
1737   }
1738 
1739     function _baseURI() internal view override returns (string memory) {
1740         return baseURI;
1741     }
1742 
1743     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1744     baseURI = _newBaseURI;
1745   }
1746 
1747   function claimQuantity() public view returns (uint) {
1748     uint NftOwned = ERC721Interface.walletOfOwner(msg.sender).length;
1749     return NftOwned;
1750   }
1751 }