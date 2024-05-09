1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/security/Pausable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which allows children to implement an emergency stop
38  * mechanism that can be triggered by an authorized account.
39  *
40  * This module is used through inheritance. It will make available the
41  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
42  * the functions of your contract. Note that they will not be pausable by
43  * simply including this module, only once the modifiers are put in place.
44  */
45 abstract contract Pausable is Context {
46     /**
47      * @dev Emitted when the pause is triggered by `account`.
48      */
49     event Paused(address account);
50 
51     /**
52      * @dev Emitted when the pause is lifted by `account`.
53      */
54     event Unpaused(address account);
55 
56     bool private _paused;
57 
58     /**
59      * @dev Initializes the contract in unpaused state.
60      */
61     constructor() {
62         _paused = false;
63     }
64 
65     /**
66      * @dev Modifier to make a function callable only when the contract is not paused.
67      *
68      * Requirements:
69      *
70      * - The contract must not be paused.
71      */
72     modifier whenNotPaused() {
73         _requireNotPaused();
74         _;
75     }
76 
77     /**
78      * @dev Modifier to make a function callable only when the contract is paused.
79      *
80      * Requirements:
81      *
82      * - The contract must be paused.
83      */
84     modifier whenPaused() {
85         _requirePaused();
86         _;
87     }
88 
89     /**
90      * @dev Returns true if the contract is paused, and false otherwise.
91      */
92     function paused() public view virtual returns (bool) {
93         return _paused;
94     }
95 
96     /**
97      * @dev Throws if the contract is paused.
98      */
99     function _requireNotPaused() internal view virtual {
100         require(!paused(), "Pausable: paused");
101     }
102 
103     /**
104      * @dev Throws if the contract is not paused.
105      */
106     function _requirePaused() internal view virtual {
107         require(paused(), "Pausable: not paused");
108     }
109 
110     /**
111      * @dev Triggers stopped state.
112      *
113      * Requirements:
114      *
115      * - The contract must not be paused.
116      */
117     function _pause() internal virtual whenNotPaused {
118         _paused = true;
119         emit Paused(_msgSender());
120     }
121 
122     /**
123      * @dev Returns to normal state.
124      *
125      * Requirements:
126      *
127      * - The contract must be paused.
128      */
129     function _unpause() internal virtual whenPaused {
130         _paused = false;
131         emit Unpaused(_msgSender());
132     }
133 }
134 
135 // File: @openzeppelin/contracts/access/Ownable.sol
136 
137 
138 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 
143 /**
144  * @dev Contract module which provides a basic access control mechanism, where
145  * there is an account (an owner) that can be granted exclusive access to
146  * specific functions.
147  *
148  * By default, the owner account will be the one that deploys the contract. This
149  * can later be changed with {transferOwnership}.
150  *
151  * This module is used through inheritance. It will make available the modifier
152  * `onlyOwner`, which can be applied to your functions to restrict their use to
153  * the owner.
154  */
155 abstract contract Ownable is Context {
156     address private _owner;
157 
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160     /**
161      * @dev Initializes the contract setting the deployer as the initial owner.
162      */
163     constructor() {
164         _transferOwnership(_msgSender());
165     }
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         _checkOwner();
172         _;
173     }
174 
175     /**
176      * @dev Returns the address of the current owner.
177      */
178     function owner() public view virtual returns (address) {
179         return _owner;
180     }
181 
182     /**
183      * @dev Throws if the sender is not the owner.
184      */
185     function _checkOwner() internal view virtual {
186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
187     }
188 
189     /**
190      * @dev Leaves the contract without owner. It will not be possible to call
191      * `onlyOwner` functions anymore. Can only be called by the current owner.
192      *
193      * NOTE: Renouncing ownership will leave the contract without an owner,
194      * thereby removing any functionality that is only available to the owner.
195      */
196     function renounceOwnership() public virtual onlyOwner {
197         _transferOwnership(address(0));
198     }
199 
200     /**
201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
202      * Can only be called by the current owner.
203      */
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         _transferOwnership(newOwner);
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Internal function without access restriction.
212      */
213     function _transferOwnership(address newOwner) internal virtual {
214         address oldOwner = _owner;
215         _owner = newOwner;
216         emit OwnershipTransferred(oldOwner, newOwner);
217     }
218 }
219 
220 // File: erc721a/contracts/IERC721A.sol
221 
222 
223 // ERC721A Contracts v4.2.2
224 // Creator: Chiru Labs
225 
226 pragma solidity ^0.8.4;
227 
228 /**
229  * @dev Interface of ERC721A.
230  */
231 interface IERC721A {
232     /**
233      * The caller must own the token or be an approved operator.
234      */
235     error ApprovalCallerNotOwnerNorApproved();
236 
237     /**
238      * The token does not exist.
239      */
240     error ApprovalQueryForNonexistentToken();
241 
242     /**
243      * The caller cannot approve to their own address.
244      */
245     error ApproveToCaller();
246 
247     /**
248      * Cannot query the balance for the zero address.
249      */
250     error BalanceQueryForZeroAddress();
251 
252     /**
253      * Cannot mint to the zero address.
254      */
255     error MintToZeroAddress();
256 
257     /**
258      * The quantity of tokens minted must be more than zero.
259      */
260     error MintZeroQuantity();
261 
262     /**
263      * The token does not exist.
264      */
265     error OwnerQueryForNonexistentToken();
266 
267     /**
268      * The caller must own the token or be an approved operator.
269      */
270     error TransferCallerNotOwnerNorApproved();
271 
272     /**
273      * The token must be owned by `from`.
274      */
275     error TransferFromIncorrectOwner();
276 
277     /**
278      * Cannot safely transfer to a contract that does not implement the
279      * ERC721Receiver interface.
280      */
281     error TransferToNonERC721ReceiverImplementer();
282 
283     /**
284      * Cannot transfer to the zero address.
285      */
286     error TransferToZeroAddress();
287 
288     /**
289      * The token does not exist.
290      */
291     error URIQueryForNonexistentToken();
292 
293     /**
294      * The `quantity` minted with ERC2309 exceeds the safety limit.
295      */
296     error MintERC2309QuantityExceedsLimit();
297 
298     /**
299      * The `extraData` cannot be set on an unintialized ownership slot.
300      */
301     error OwnershipNotInitializedForExtraData();
302 
303     // =============================================================
304     //                            STRUCTS
305     // =============================================================
306 
307     struct TokenOwnership {
308         // The address of the owner.
309         address addr;
310         // Stores the start time of ownership with minimal overhead for tokenomics.
311         uint64 startTimestamp;
312         // Whether the token has been burned.
313         bool burned;
314         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
315         uint24 extraData;
316     }
317 
318     // =============================================================
319     //                         TOKEN COUNTERS
320     // =============================================================
321 
322     /**
323      * @dev Returns the total number of tokens in existence.
324      * Burned tokens will reduce the count.
325      * To get the total number of tokens minted, please see {_totalMinted}.
326      */
327     function totalSupply() external view returns (uint256);
328 
329     // =============================================================
330     //                            IERC165
331     // =============================================================
332 
333     /**
334      * @dev Returns true if this contract implements the interface defined by
335      * `interfaceId`. See the corresponding
336      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
337      * to learn more about how these ids are created.
338      *
339      * This function call must use less than 30000 gas.
340      */
341     function supportsInterface(bytes4 interfaceId) external view returns (bool);
342 
343     // =============================================================
344     //                            IERC721
345     // =============================================================
346 
347     /**
348      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
349      */
350     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
354      */
355     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
356 
357     /**
358      * @dev Emitted when `owner` enables or disables
359      * (`approved`) `operator` to manage all of its assets.
360      */
361     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
362 
363     /**
364      * @dev Returns the number of tokens in `owner`'s account.
365      */
366     function balanceOf(address owner) external view returns (uint256 balance);
367 
368     /**
369      * @dev Returns the owner of the `tokenId` token.
370      *
371      * Requirements:
372      *
373      * - `tokenId` must exist.
374      */
375     function ownerOf(uint256 tokenId) external view returns (address owner);
376 
377     /**
378      * @dev Safely transfers `tokenId` token from `from` to `to`,
379      * checking first that contract recipients are aware of the ERC721 protocol
380      * to prevent tokens from being forever locked.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `tokenId` token must exist and be owned by `from`.
387      * - If the caller is not `from`, it must be have been allowed to move
388      * this token by either {approve} or {setApprovalForAll}.
389      * - If `to` refers to a smart contract, it must implement
390      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
391      *
392      * Emits a {Transfer} event.
393      */
394     function safeTransferFrom(
395         address from,
396         address to,
397         uint256 tokenId,
398         bytes calldata data
399     ) external;
400 
401     /**
402      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
403      */
404     function safeTransferFrom(
405         address from,
406         address to,
407         uint256 tokenId
408     ) external;
409 
410     /**
411      * @dev Transfers `tokenId` from `from` to `to`.
412      *
413      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
414      * whenever possible.
415      *
416      * Requirements:
417      *
418      * - `from` cannot be the zero address.
419      * - `to` cannot be the zero address.
420      * - `tokenId` token must be owned by `from`.
421      * - If the caller is not `from`, it must be approved to move this token
422      * by either {approve} or {setApprovalForAll}.
423      *
424      * Emits a {Transfer} event.
425      */
426     function transferFrom(
427         address from,
428         address to,
429         uint256 tokenId
430     ) external;
431 
432     /**
433      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
434      * The approval is cleared when the token is transferred.
435      *
436      * Only a single account can be approved at a time, so approving the
437      * zero address clears previous approvals.
438      *
439      * Requirements:
440      *
441      * - The caller must own the token or be an approved operator.
442      * - `tokenId` must exist.
443      *
444      * Emits an {Approval} event.
445      */
446     function approve(address to, uint256 tokenId) external;
447 
448     /**
449      * @dev Approve or remove `operator` as an operator for the caller.
450      * Operators can call {transferFrom} or {safeTransferFrom}
451      * for any token owned by the caller.
452      *
453      * Requirements:
454      *
455      * - The `operator` cannot be the caller.
456      *
457      * Emits an {ApprovalForAll} event.
458      */
459     function setApprovalForAll(address operator, bool _approved) external;
460 
461     /**
462      * @dev Returns the account approved for `tokenId` token.
463      *
464      * Requirements:
465      *
466      * - `tokenId` must exist.
467      */
468     function getApproved(uint256 tokenId) external view returns (address operator);
469 
470     /**
471      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
472      *
473      * See {setApprovalForAll}.
474      */
475     function isApprovedForAll(address owner, address operator) external view returns (bool);
476 
477     // =============================================================
478     //                        IERC721Metadata
479     // =============================================================
480 
481     /**
482      * @dev Returns the token collection name.
483      */
484     function name() external view returns (string memory);
485 
486     /**
487      * @dev Returns the token collection symbol.
488      */
489     function symbol() external view returns (string memory);
490 
491     /**
492      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
493      */
494     function tokenURI(uint256 tokenId) external view returns (string memory);
495 
496     // =============================================================
497     //                           IERC2309
498     // =============================================================
499 
500     /**
501      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
502      * (inclusive) is transferred from `from` to `to`, as defined in the
503      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
504      *
505      * See {_mintERC2309} for more details.
506      */
507     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
508 }
509 
510 // File: erc721a/contracts/ERC721A.sol
511 
512 
513 // ERC721A Contracts v4.2.2
514 // Creator: Chiru Labs
515 
516 pragma solidity ^0.8.4;
517 
518 
519 /**
520  * @dev Interface of ERC721 token receiver.
521  */
522 interface ERC721A__IERC721Receiver {
523     function onERC721Received(
524         address operator,
525         address from,
526         uint256 tokenId,
527         bytes calldata data
528     ) external returns (bytes4);
529 }
530 
531 /**
532  * @title ERC721A
533  *
534  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
535  * Non-Fungible Token Standard, including the Metadata extension.
536  * Optimized for lower gas during batch mints.
537  *
538  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
539  * starting from `_startTokenId()`.
540  *
541  * Assumptions:
542  *
543  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
544  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
545  */
546 contract ERC721A is IERC721A {
547     // Reference type for token approval.
548     struct TokenApprovalRef {
549         address value;
550     }
551 
552     // =============================================================
553     //                           CONSTANTS
554     // =============================================================
555 
556     // Mask of an entry in packed address data.
557     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
558 
559     // The bit position of `numberMinted` in packed address data.
560     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
561 
562     // The bit position of `numberBurned` in packed address data.
563     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
564 
565     // The bit position of `aux` in packed address data.
566     uint256 private constant _BITPOS_AUX = 192;
567 
568     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
569     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
570 
571     // The bit position of `startTimestamp` in packed ownership.
572     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
573 
574     // The bit mask of the `burned` bit in packed ownership.
575     uint256 private constant _BITMASK_BURNED = 1 << 224;
576 
577     // The bit position of the `nextInitialized` bit in packed ownership.
578     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
579 
580     // The bit mask of the `nextInitialized` bit in packed ownership.
581     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
582 
583     // The bit position of `extraData` in packed ownership.
584     uint256 private constant _BITPOS_EXTRA_DATA = 232;
585 
586     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
587     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
588 
589     // The mask of the lower 160 bits for addresses.
590     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
591 
592     // The maximum `quantity` that can be minted with {_mintERC2309}.
593     // This limit is to prevent overflows on the address data entries.
594     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
595     // is required to cause an overflow, which is unrealistic.
596     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
597 
598     // The `Transfer` event signature is given by:
599     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
600     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
601         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
602 
603     // =============================================================
604     //                            STORAGE
605     // =============================================================
606 
607     // The next token ID to be minted.
608     uint256 private _currentIndex;
609 
610     // The number of tokens burned.
611     uint256 private _burnCounter;
612 
613     // Token name
614     string private _name;
615 
616     // Token symbol
617     string private _symbol;
618 
619     // Mapping from token ID to ownership details
620     // An empty struct value does not necessarily mean the token is unowned.
621     // See {_packedOwnershipOf} implementation for details.
622     //
623     // Bits Layout:
624     // - [0..159]   `addr`
625     // - [160..223] `startTimestamp`
626     // - [224]      `burned`
627     // - [225]      `nextInitialized`
628     // - [232..255] `extraData`
629     mapping(uint256 => uint256) private _packedOwnerships;
630 
631     // Mapping owner address to address data.
632     //
633     // Bits Layout:
634     // - [0..63]    `balance`
635     // - [64..127]  `numberMinted`
636     // - [128..191] `numberBurned`
637     // - [192..255] `aux`
638     mapping(address => uint256) private _packedAddressData;
639 
640     // Mapping from token ID to approved address.
641     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
642 
643     // Mapping from owner to operator approvals
644     mapping(address => mapping(address => bool)) private _operatorApprovals;
645 
646     // =============================================================
647     //                          CONSTRUCTOR
648     // =============================================================
649 
650     constructor(string memory name_, string memory symbol_) {
651         _name = name_;
652         _symbol = symbol_;
653         _currentIndex = _startTokenId();
654     }
655 
656     // =============================================================
657     //                   TOKEN COUNTING OPERATIONS
658     // =============================================================
659 
660     /**
661      * @dev Returns the starting token ID.
662      * To change the starting token ID, please override this function.
663      */
664     function _startTokenId() internal view virtual returns (uint256) {
665         return 0;
666     }
667 
668     /**
669      * @dev Returns the next token ID to be minted.
670      */
671     function _nextTokenId() internal view virtual returns (uint256) {
672         return _currentIndex;
673     }
674 
675     /**
676      * @dev Returns the total number of tokens in existence.
677      * Burned tokens will reduce the count.
678      * To get the total number of tokens minted, please see {_totalMinted}.
679      */
680     function totalSupply() public view virtual override returns (uint256) {
681         // Counter underflow is impossible as _burnCounter cannot be incremented
682         // more than `_currentIndex - _startTokenId()` times.
683         unchecked {
684             return _currentIndex - _burnCounter - _startTokenId();
685         }
686     }
687 
688     /**
689      * @dev Returns the total amount of tokens minted in the contract.
690      */
691     function _totalMinted() internal view virtual returns (uint256) {
692         // Counter underflow is impossible as `_currentIndex` does not decrement,
693         // and it is initialized to `_startTokenId()`.
694         unchecked {
695             return _currentIndex - _startTokenId();
696         }
697     }
698 
699     /**
700      * @dev Returns the total number of tokens burned.
701      */
702     function _totalBurned() internal view virtual returns (uint256) {
703         return _burnCounter;
704     }
705 
706     // =============================================================
707     //                    ADDRESS DATA OPERATIONS
708     // =============================================================
709 
710     /**
711      * @dev Returns the number of tokens in `owner`'s account.
712      */
713     function balanceOf(address owner) public view virtual override returns (uint256) {
714         if (owner == address(0)) revert BalanceQueryForZeroAddress();
715         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
716     }
717 
718     /**
719      * Returns the number of tokens minted by `owner`.
720      */
721     function _numberMinted(address owner) internal view returns (uint256) {
722         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
723     }
724 
725     /**
726      * Returns the number of tokens burned by or on behalf of `owner`.
727      */
728     function _numberBurned(address owner) internal view returns (uint256) {
729         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
730     }
731 
732     /**
733      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
734      */
735     function _getAux(address owner) internal view returns (uint64) {
736         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
737     }
738 
739     /**
740      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
741      * If there are multiple variables, please pack them into a uint64.
742      */
743     function _setAux(address owner, uint64 aux) internal virtual {
744         uint256 packed = _packedAddressData[owner];
745         uint256 auxCasted;
746         // Cast `aux` with assembly to avoid redundant masking.
747         assembly {
748             auxCasted := aux
749         }
750         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
751         _packedAddressData[owner] = packed;
752     }
753 
754     // =============================================================
755     //                            IERC165
756     // =============================================================
757 
758     /**
759      * @dev Returns true if this contract implements the interface defined by
760      * `interfaceId`. See the corresponding
761      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
762      * to learn more about how these ids are created.
763      *
764      * This function call must use less than 30000 gas.
765      */
766     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
767         // The interface IDs are constants representing the first 4 bytes
768         // of the XOR of all function selectors in the interface.
769         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
770         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
771         return
772             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
773             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
774             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
775     }
776 
777     // =============================================================
778     //                        IERC721Metadata
779     // =============================================================
780 
781     /**
782      * @dev Returns the token collection name.
783      */
784     function name() public view virtual override returns (string memory) {
785         return _name;
786     }
787 
788     /**
789      * @dev Returns the token collection symbol.
790      */
791     function symbol() public view virtual override returns (string memory) {
792         return _symbol;
793     }
794 
795     /**
796      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
797      */
798     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
799         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
800 
801         string memory baseURI = _baseURI();
802         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
803     }
804 
805     /**
806      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
807      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
808      * by default, it can be overridden in child contracts.
809      */
810     function _baseURI() internal view virtual returns (string memory) {
811         return '';
812     }
813 
814     // =============================================================
815     //                     OWNERSHIPS OPERATIONS
816     // =============================================================
817 
818     /**
819      * @dev Returns the owner of the `tokenId` token.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
826         return address(uint160(_packedOwnershipOf(tokenId)));
827     }
828 
829     /**
830      * @dev Gas spent here starts off proportional to the maximum mint batch size.
831      * It gradually moves to O(1) as tokens get transferred around over time.
832      */
833     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
834         return _unpackedOwnership(_packedOwnershipOf(tokenId));
835     }
836 
837     /**
838      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
839      */
840     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
841         return _unpackedOwnership(_packedOwnerships[index]);
842     }
843 
844     /**
845      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
846      */
847     function _initializeOwnershipAt(uint256 index) internal virtual {
848         if (_packedOwnerships[index] == 0) {
849             _packedOwnerships[index] = _packedOwnershipOf(index);
850         }
851     }
852 
853     /**
854      * Returns the packed ownership data of `tokenId`.
855      */
856     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
857         uint256 curr = tokenId;
858 
859         unchecked {
860             if (_startTokenId() <= curr)
861                 if (curr < _currentIndex) {
862                     uint256 packed = _packedOwnerships[curr];
863                     // If not burned.
864                     if (packed & _BITMASK_BURNED == 0) {
865                         // Invariant:
866                         // There will always be an initialized ownership slot
867                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
868                         // before an unintialized ownership slot
869                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
870                         // Hence, `curr` will not underflow.
871                         //
872                         // We can directly compare the packed value.
873                         // If the address is zero, packed will be zero.
874                         while (packed == 0) {
875                             packed = _packedOwnerships[--curr];
876                         }
877                         return packed;
878                     }
879                 }
880         }
881         revert OwnerQueryForNonexistentToken();
882     }
883 
884     /**
885      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
886      */
887     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
888         ownership.addr = address(uint160(packed));
889         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
890         ownership.burned = packed & _BITMASK_BURNED != 0;
891         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
892     }
893 
894     /**
895      * @dev Packs ownership data into a single uint256.
896      */
897     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
898         assembly {
899             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
900             owner := and(owner, _BITMASK_ADDRESS)
901             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
902             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
903         }
904     }
905 
906     /**
907      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
908      */
909     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
910         // For branchless setting of the `nextInitialized` flag.
911         assembly {
912             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
913             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
914         }
915     }
916 
917     // =============================================================
918     //                      APPROVAL OPERATIONS
919     // =============================================================
920 
921     /**
922      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
923      * The approval is cleared when the token is transferred.
924      *
925      * Only a single account can be approved at a time, so approving the
926      * zero address clears previous approvals.
927      *
928      * Requirements:
929      *
930      * - The caller must own the token or be an approved operator.
931      * - `tokenId` must exist.
932      *
933      * Emits an {Approval} event.
934      */
935     function approve(address to, uint256 tokenId) public virtual override {
936         address owner = ownerOf(tokenId);
937 
938         if (_msgSenderERC721A() != owner)
939             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
940                 revert ApprovalCallerNotOwnerNorApproved();
941             }
942 
943         _tokenApprovals[tokenId].value = to;
944         emit Approval(owner, to, tokenId);
945     }
946 
947     /**
948      * @dev Returns the account approved for `tokenId` token.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      */
954     function getApproved(uint256 tokenId) public view virtual override returns (address) {
955         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
956 
957         return _tokenApprovals[tokenId].value;
958     }
959 
960     /**
961      * @dev Approve or remove `operator` as an operator for the caller.
962      * Operators can call {transferFrom} or {safeTransferFrom}
963      * for any token owned by the caller.
964      *
965      * Requirements:
966      *
967      * - The `operator` cannot be the caller.
968      *
969      * Emits an {ApprovalForAll} event.
970      */
971     function setApprovalForAll(address operator, bool approved) public virtual override {
972         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
973 
974         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
975         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
976     }
977 
978     /**
979      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
980      *
981      * See {setApprovalForAll}.
982      */
983     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
984         return _operatorApprovals[owner][operator];
985     }
986 
987     /**
988      * @dev Returns whether `tokenId` exists.
989      *
990      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
991      *
992      * Tokens start existing when they are minted. See {_mint}.
993      */
994     function _exists(uint256 tokenId) internal view virtual returns (bool) {
995         return
996             _startTokenId() <= tokenId &&
997             tokenId < _currentIndex && // If within bounds,
998             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
999     }
1000 
1001     /**
1002      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1003      */
1004     function _isSenderApprovedOrOwner(
1005         address approvedAddress,
1006         address owner,
1007         address msgSender
1008     ) private pure returns (bool result) {
1009         assembly {
1010             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1011             owner := and(owner, _BITMASK_ADDRESS)
1012             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1013             msgSender := and(msgSender, _BITMASK_ADDRESS)
1014             // `msgSender == owner || msgSender == approvedAddress`.
1015             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1016         }
1017     }
1018 
1019     /**
1020      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1021      */
1022     function _getApprovedSlotAndAddress(uint256 tokenId)
1023         private
1024         view
1025         returns (uint256 approvedAddressSlot, address approvedAddress)
1026     {
1027         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1028         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1029         assembly {
1030             approvedAddressSlot := tokenApproval.slot
1031             approvedAddress := sload(approvedAddressSlot)
1032         }
1033     }
1034 
1035     // =============================================================
1036     //                      TRANSFER OPERATIONS
1037     // =============================================================
1038 
1039     /**
1040      * @dev Transfers `tokenId` from `from` to `to`.
1041      *
1042      * Requirements:
1043      *
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must be owned by `from`.
1047      * - If the caller is not `from`, it must be approved to move this token
1048      * by either {approve} or {setApprovalForAll}.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function transferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) public virtual override {
1057         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1058 
1059         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1060 
1061         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1062 
1063         // The nested ifs save around 20+ gas over a compound boolean condition.
1064         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1065             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1066 
1067         if (to == address(0)) revert TransferToZeroAddress();
1068 
1069         _beforeTokenTransfers(from, to, tokenId, 1);
1070 
1071         // Clear approvals from the previous owner.
1072         assembly {
1073             if approvedAddress {
1074                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1075                 sstore(approvedAddressSlot, 0)
1076             }
1077         }
1078 
1079         // Underflow of the sender's balance is impossible because we check for
1080         // ownership above and the recipient's balance can't realistically overflow.
1081         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1082         unchecked {
1083             // We can directly increment and decrement the balances.
1084             --_packedAddressData[from]; // Updates: `balance -= 1`.
1085             ++_packedAddressData[to]; // Updates: `balance += 1`.
1086 
1087             // Updates:
1088             // - `address` to the next owner.
1089             // - `startTimestamp` to the timestamp of transfering.
1090             // - `burned` to `false`.
1091             // - `nextInitialized` to `true`.
1092             _packedOwnerships[tokenId] = _packOwnershipData(
1093                 to,
1094                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1095             );
1096 
1097             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1098             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1099                 uint256 nextTokenId = tokenId + 1;
1100                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1101                 if (_packedOwnerships[nextTokenId] == 0) {
1102                     // If the next slot is within bounds.
1103                     if (nextTokenId != _currentIndex) {
1104                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1105                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1106                     }
1107                 }
1108             }
1109         }
1110 
1111         emit Transfer(from, to, tokenId);
1112         _afterTokenTransfers(from, to, tokenId, 1);
1113     }
1114 
1115     /**
1116      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1117      */
1118     function safeTransferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) public virtual override {
1123         safeTransferFrom(from, to, tokenId, '');
1124     }
1125 
1126     /**
1127      * @dev Safely transfers `tokenId` token from `from` to `to`.
1128      *
1129      * Requirements:
1130      *
1131      * - `from` cannot be the zero address.
1132      * - `to` cannot be the zero address.
1133      * - `tokenId` token must exist and be owned by `from`.
1134      * - If the caller is not `from`, it must be approved to move this token
1135      * by either {approve} or {setApprovalForAll}.
1136      * - If `to` refers to a smart contract, it must implement
1137      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function safeTransferFrom(
1142         address from,
1143         address to,
1144         uint256 tokenId,
1145         bytes memory _data
1146     ) public virtual override {
1147         transferFrom(from, to, tokenId);
1148         if (to.code.length != 0)
1149             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1150                 revert TransferToNonERC721ReceiverImplementer();
1151             }
1152     }
1153 
1154     /**
1155      * @dev Hook that is called before a set of serially-ordered token IDs
1156      * are about to be transferred. This includes minting.
1157      * And also called before burning one token.
1158      *
1159      * `startTokenId` - the first token ID to be transferred.
1160      * `quantity` - the amount to be transferred.
1161      *
1162      * Calling conditions:
1163      *
1164      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1165      * transferred to `to`.
1166      * - When `from` is zero, `tokenId` will be minted for `to`.
1167      * - When `to` is zero, `tokenId` will be burned by `from`.
1168      * - `from` and `to` are never both zero.
1169      */
1170     function _beforeTokenTransfers(
1171         address from,
1172         address to,
1173         uint256 startTokenId,
1174         uint256 quantity
1175     ) internal virtual {}
1176 
1177     /**
1178      * @dev Hook that is called after a set of serially-ordered token IDs
1179      * have been transferred. This includes minting.
1180      * And also called after one token has been burned.
1181      *
1182      * `startTokenId` - the first token ID to be transferred.
1183      * `quantity` - the amount to be transferred.
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` has been minted for `to`.
1190      * - When `to` is zero, `tokenId` has been burned by `from`.
1191      * - `from` and `to` are never both zero.
1192      */
1193     function _afterTokenTransfers(
1194         address from,
1195         address to,
1196         uint256 startTokenId,
1197         uint256 quantity
1198     ) internal virtual {}
1199 
1200     /**
1201      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1202      *
1203      * `from` - Previous owner of the given token ID.
1204      * `to` - Target address that will receive the token.
1205      * `tokenId` - Token ID to be transferred.
1206      * `_data` - Optional data to send along with the call.
1207      *
1208      * Returns whether the call correctly returned the expected magic value.
1209      */
1210     function _checkContractOnERC721Received(
1211         address from,
1212         address to,
1213         uint256 tokenId,
1214         bytes memory _data
1215     ) private returns (bool) {
1216         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1217             bytes4 retval
1218         ) {
1219             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1220         } catch (bytes memory reason) {
1221             if (reason.length == 0) {
1222                 revert TransferToNonERC721ReceiverImplementer();
1223             } else {
1224                 assembly {
1225                     revert(add(32, reason), mload(reason))
1226                 }
1227             }
1228         }
1229     }
1230 
1231     // =============================================================
1232     //                        MINT OPERATIONS
1233     // =============================================================
1234 
1235     /**
1236      * @dev Mints `quantity` tokens and transfers them to `to`.
1237      *
1238      * Requirements:
1239      *
1240      * - `to` cannot be the zero address.
1241      * - `quantity` must be greater than 0.
1242      *
1243      * Emits a {Transfer} event for each mint.
1244      */
1245     function _mint(address to, uint256 quantity) internal virtual {
1246         uint256 startTokenId = _currentIndex;
1247         if (quantity == 0) revert MintZeroQuantity();
1248 
1249         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1250 
1251         // Overflows are incredibly unrealistic.
1252         // `balance` and `numberMinted` have a maximum limit of 2**64.
1253         // `tokenId` has a maximum limit of 2**256.
1254         unchecked {
1255             // Updates:
1256             // - `balance += quantity`.
1257             // - `numberMinted += quantity`.
1258             //
1259             // We can directly add to the `balance` and `numberMinted`.
1260             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1261 
1262             // Updates:
1263             // - `address` to the owner.
1264             // - `startTimestamp` to the timestamp of minting.
1265             // - `burned` to `false`.
1266             // - `nextInitialized` to `quantity == 1`.
1267             _packedOwnerships[startTokenId] = _packOwnershipData(
1268                 to,
1269                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1270             );
1271 
1272             uint256 toMasked;
1273             uint256 end = startTokenId + quantity;
1274 
1275             // Use assembly to loop and emit the `Transfer` event for gas savings.
1276             assembly {
1277                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1278                 toMasked := and(to, _BITMASK_ADDRESS)
1279                 // Emit the `Transfer` event.
1280                 log4(
1281                     0, // Start of data (0, since no data).
1282                     0, // End of data (0, since no data).
1283                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1284                     0, // `address(0)`.
1285                     toMasked, // `to`.
1286                     startTokenId // `tokenId`.
1287                 )
1288 
1289                 for {
1290                     let tokenId := add(startTokenId, 1)
1291                 } iszero(eq(tokenId, end)) {
1292                     tokenId := add(tokenId, 1)
1293                 } {
1294                     // Emit the `Transfer` event. Similar to above.
1295                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1296                 }
1297             }
1298             if (toMasked == 0) revert MintToZeroAddress();
1299 
1300             _currentIndex = end;
1301         }
1302         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1303     }
1304 
1305     /**
1306      * @dev Mints `quantity` tokens and transfers them to `to`.
1307      *
1308      * This function is intended for efficient minting only during contract creation.
1309      *
1310      * It emits only one {ConsecutiveTransfer} as defined in
1311      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1312      * instead of a sequence of {Transfer} event(s).
1313      *
1314      * Calling this function outside of contract creation WILL make your contract
1315      * non-compliant with the ERC721 standard.
1316      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1317      * {ConsecutiveTransfer} event is only permissible during contract creation.
1318      *
1319      * Requirements:
1320      *
1321      * - `to` cannot be the zero address.
1322      * - `quantity` must be greater than 0.
1323      *
1324      * Emits a {ConsecutiveTransfer} event.
1325      */
1326     function _mintERC2309(address to, uint256 quantity) internal virtual {
1327         uint256 startTokenId = _currentIndex;
1328         if (to == address(0)) revert MintToZeroAddress();
1329         if (quantity == 0) revert MintZeroQuantity();
1330         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1331 
1332         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1333 
1334         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1335         unchecked {
1336             // Updates:
1337             // - `balance += quantity`.
1338             // - `numberMinted += quantity`.
1339             //
1340             // We can directly add to the `balance` and `numberMinted`.
1341             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1342 
1343             // Updates:
1344             // - `address` to the owner.
1345             // - `startTimestamp` to the timestamp of minting.
1346             // - `burned` to `false`.
1347             // - `nextInitialized` to `quantity == 1`.
1348             _packedOwnerships[startTokenId] = _packOwnershipData(
1349                 to,
1350                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1351             );
1352 
1353             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1354 
1355             _currentIndex = startTokenId + quantity;
1356         }
1357         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1358     }
1359 
1360     /**
1361      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1362      *
1363      * Requirements:
1364      *
1365      * - If `to` refers to a smart contract, it must implement
1366      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1367      * - `quantity` must be greater than 0.
1368      *
1369      * See {_mint}.
1370      *
1371      * Emits a {Transfer} event for each mint.
1372      */
1373     function _safeMint(
1374         address to,
1375         uint256 quantity,
1376         bytes memory _data
1377     ) internal virtual {
1378         _mint(to, quantity);
1379 
1380         unchecked {
1381             if (to.code.length != 0) {
1382                 uint256 end = _currentIndex;
1383                 uint256 index = end - quantity;
1384                 do {
1385                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1386                         revert TransferToNonERC721ReceiverImplementer();
1387                     }
1388                 } while (index < end);
1389                 // Reentrancy protection.
1390                 if (_currentIndex != end) revert();
1391             }
1392         }
1393     }
1394 
1395     /**
1396      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1397      */
1398     function _safeMint(address to, uint256 quantity) internal virtual {
1399         _safeMint(to, quantity, '');
1400     }
1401 
1402     // =============================================================
1403     //                        BURN OPERATIONS
1404     // =============================================================
1405 
1406     /**
1407      * @dev Equivalent to `_burn(tokenId, false)`.
1408      */
1409     function _burn(uint256 tokenId) internal virtual {
1410         _burn(tokenId, false);
1411     }
1412 
1413     /**
1414      * @dev Destroys `tokenId`.
1415      * The approval is cleared when the token is burned.
1416      *
1417      * Requirements:
1418      *
1419      * - `tokenId` must exist.
1420      *
1421      * Emits a {Transfer} event.
1422      */
1423     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1424         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1425 
1426         address from = address(uint160(prevOwnershipPacked));
1427 
1428         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1429 
1430         if (approvalCheck) {
1431             // The nested ifs save around 20+ gas over a compound boolean condition.
1432             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1433                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1434         }
1435 
1436         _beforeTokenTransfers(from, address(0), tokenId, 1);
1437 
1438         // Clear approvals from the previous owner.
1439         assembly {
1440             if approvedAddress {
1441                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1442                 sstore(approvedAddressSlot, 0)
1443             }
1444         }
1445 
1446         // Underflow of the sender's balance is impossible because we check for
1447         // ownership above and the recipient's balance can't realistically overflow.
1448         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1449         unchecked {
1450             // Updates:
1451             // - `balance -= 1`.
1452             // - `numberBurned += 1`.
1453             //
1454             // We can directly decrement the balance, and increment the number burned.
1455             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1456             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1457 
1458             // Updates:
1459             // - `address` to the last owner.
1460             // - `startTimestamp` to the timestamp of burning.
1461             // - `burned` to `true`.
1462             // - `nextInitialized` to `true`.
1463             _packedOwnerships[tokenId] = _packOwnershipData(
1464                 from,
1465                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1466             );
1467 
1468             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1469             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1470                 uint256 nextTokenId = tokenId + 1;
1471                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1472                 if (_packedOwnerships[nextTokenId] == 0) {
1473                     // If the next slot is within bounds.
1474                     if (nextTokenId != _currentIndex) {
1475                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1476                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1477                     }
1478                 }
1479             }
1480         }
1481 
1482         emit Transfer(from, address(0), tokenId);
1483         _afterTokenTransfers(from, address(0), tokenId, 1);
1484 
1485         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1486         unchecked {
1487             _burnCounter++;
1488         }
1489     }
1490 
1491     // =============================================================
1492     //                     EXTRA DATA OPERATIONS
1493     // =============================================================
1494 
1495     /**
1496      * @dev Directly sets the extra data for the ownership data `index`.
1497      */
1498     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1499         uint256 packed = _packedOwnerships[index];
1500         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1501         uint256 extraDataCasted;
1502         // Cast `extraData` with assembly to avoid redundant masking.
1503         assembly {
1504             extraDataCasted := extraData
1505         }
1506         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1507         _packedOwnerships[index] = packed;
1508     }
1509 
1510     /**
1511      * @dev Called during each token transfer to set the 24bit `extraData` field.
1512      * Intended to be overridden by the cosumer contract.
1513      *
1514      * `previousExtraData` - the value of `extraData` before transfer.
1515      *
1516      * Calling conditions:
1517      *
1518      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1519      * transferred to `to`.
1520      * - When `from` is zero, `tokenId` will be minted for `to`.
1521      * - When `to` is zero, `tokenId` will be burned by `from`.
1522      * - `from` and `to` are never both zero.
1523      */
1524     function _extraData(
1525         address from,
1526         address to,
1527         uint24 previousExtraData
1528     ) internal view virtual returns (uint24) {}
1529 
1530     /**
1531      * @dev Returns the next extra data for the packed ownership data.
1532      * The returned result is shifted into position.
1533      */
1534     function _nextExtraData(
1535         address from,
1536         address to,
1537         uint256 prevOwnershipPacked
1538     ) private view returns (uint256) {
1539         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1540         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1541     }
1542 
1543     // =============================================================
1544     //                       OTHER OPERATIONS
1545     // =============================================================
1546 
1547     /**
1548      * @dev Returns the message sender (defaults to `msg.sender`).
1549      *
1550      * If you are writing GSN compatible contracts, you need to override this function.
1551      */
1552     function _msgSenderERC721A() internal view virtual returns (address) {
1553         return msg.sender;
1554     }
1555 
1556     /**
1557      * @dev Converts a uint256 to its ASCII string decimal representation.
1558      */
1559     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1560         assembly {
1561             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1562             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1563             // We will need 1 32-byte word to store the length,
1564             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1565             str := add(mload(0x40), 0x80)
1566             // Update the free memory pointer to allocate.
1567             mstore(0x40, str)
1568 
1569             // Cache the end of the memory to calculate the length later.
1570             let end := str
1571 
1572             // We write the string from rightmost digit to leftmost digit.
1573             // The following is essentially a do-while loop that also handles the zero case.
1574             // prettier-ignore
1575             for { let temp := value } 1 {} {
1576                 str := sub(str, 1)
1577                 // Write the character to the pointer.
1578                 // The ASCII index of the '0' character is 48.
1579                 mstore8(str, add(48, mod(temp, 10)))
1580                 // Keep dividing `temp` until zero.
1581                 temp := div(temp, 10)
1582                 // prettier-ignore
1583                 if iszero(temp) { break }
1584             }
1585 
1586             let length := sub(end, str)
1587             // Move the pointer 32 bytes leftwards to make room for the length.
1588             str := sub(str, 0x20)
1589             // Store the length.
1590             mstore(str, length)
1591         }
1592     }
1593 }
1594 
1595 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1596 
1597 
1598 // ERC721A Contracts v4.2.2
1599 // Creator: Chiru Labs
1600 
1601 pragma solidity ^0.8.4;
1602 
1603 
1604 /**
1605  * @dev Interface of ERC721AQueryable.
1606  */
1607 interface IERC721AQueryable is IERC721A {
1608     /**
1609      * Invalid query range (`start` >= `stop`).
1610      */
1611     error InvalidQueryRange();
1612 
1613     /**
1614      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1615      *
1616      * If the `tokenId` is out of bounds:
1617      *
1618      * - `addr = address(0)`
1619      * - `startTimestamp = 0`
1620      * - `burned = false`
1621      * - `extraData = 0`
1622      *
1623      * If the `tokenId` is burned:
1624      *
1625      * - `addr = <Address of owner before token was burned>`
1626      * - `startTimestamp = <Timestamp when token was burned>`
1627      * - `burned = true`
1628      * - `extraData = <Extra data when token was burned>`
1629      *
1630      * Otherwise:
1631      *
1632      * - `addr = <Address of owner>`
1633      * - `startTimestamp = <Timestamp of start of ownership>`
1634      * - `burned = false`
1635      * - `extraData = <Extra data at start of ownership>`
1636      */
1637     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1638 
1639     /**
1640      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1641      * See {ERC721AQueryable-explicitOwnershipOf}
1642      */
1643     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1644 
1645     /**
1646      * @dev Returns an array of token IDs owned by `owner`,
1647      * in the range [`start`, `stop`)
1648      * (i.e. `start <= tokenId < stop`).
1649      *
1650      * This function allows for tokens to be queried if the collection
1651      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1652      *
1653      * Requirements:
1654      *
1655      * - `start < stop`
1656      */
1657     function tokensOfOwnerIn(
1658         address owner,
1659         uint256 start,
1660         uint256 stop
1661     ) external view returns (uint256[] memory);
1662 
1663     /**
1664      * @dev Returns an array of token IDs owned by `owner`.
1665      *
1666      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1667      * It is meant to be called off-chain.
1668      *
1669      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1670      * multiple smaller scans if the collection is large enough to cause
1671      * an out-of-gas error (10K collections should be fine).
1672      */
1673     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1674 }
1675 
1676 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1677 
1678 
1679 // ERC721A Contracts v4.2.2
1680 // Creator: Chiru Labs
1681 
1682 pragma solidity ^0.8.4;
1683 
1684 
1685 
1686 /**
1687  * @title ERC721AQueryable.
1688  *
1689  * @dev ERC721A subclass with convenience query functions.
1690  */
1691 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1692     /**
1693      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1694      *
1695      * If the `tokenId` is out of bounds:
1696      *
1697      * - `addr = address(0)`
1698      * - `startTimestamp = 0`
1699      * - `burned = false`
1700      * - `extraData = 0`
1701      *
1702      * If the `tokenId` is burned:
1703      *
1704      * - `addr = <Address of owner before token was burned>`
1705      * - `startTimestamp = <Timestamp when token was burned>`
1706      * - `burned = true`
1707      * - `extraData = <Extra data when token was burned>`
1708      *
1709      * Otherwise:
1710      *
1711      * - `addr = <Address of owner>`
1712      * - `startTimestamp = <Timestamp of start of ownership>`
1713      * - `burned = false`
1714      * - `extraData = <Extra data at start of ownership>`
1715      */
1716     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1717         TokenOwnership memory ownership;
1718         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1719             return ownership;
1720         }
1721         ownership = _ownershipAt(tokenId);
1722         if (ownership.burned) {
1723             return ownership;
1724         }
1725         return _ownershipOf(tokenId);
1726     }
1727 
1728     /**
1729      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1730      * See {ERC721AQueryable-explicitOwnershipOf}
1731      */
1732     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1733         external
1734         view
1735         virtual
1736         override
1737         returns (TokenOwnership[] memory)
1738     {
1739         unchecked {
1740             uint256 tokenIdsLength = tokenIds.length;
1741             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1742             for (uint256 i; i != tokenIdsLength; ++i) {
1743                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1744             }
1745             return ownerships;
1746         }
1747     }
1748 
1749     /**
1750      * @dev Returns an array of token IDs owned by `owner`,
1751      * in the range [`start`, `stop`)
1752      * (i.e. `start <= tokenId < stop`).
1753      *
1754      * This function allows for tokens to be queried if the collection
1755      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1756      *
1757      * Requirements:
1758      *
1759      * - `start < stop`
1760      */
1761     function tokensOfOwnerIn(
1762         address owner,
1763         uint256 start,
1764         uint256 stop
1765     ) external view virtual override returns (uint256[] memory) {
1766         unchecked {
1767             if (start >= stop) revert InvalidQueryRange();
1768             uint256 tokenIdsIdx;
1769             uint256 stopLimit = _nextTokenId();
1770             // Set `start = max(start, _startTokenId())`.
1771             if (start < _startTokenId()) {
1772                 start = _startTokenId();
1773             }
1774             // Set `stop = min(stop, stopLimit)`.
1775             if (stop > stopLimit) {
1776                 stop = stopLimit;
1777             }
1778             uint256 tokenIdsMaxLength = balanceOf(owner);
1779             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1780             // to cater for cases where `balanceOf(owner)` is too big.
1781             if (start < stop) {
1782                 uint256 rangeLength = stop - start;
1783                 if (rangeLength < tokenIdsMaxLength) {
1784                     tokenIdsMaxLength = rangeLength;
1785                 }
1786             } else {
1787                 tokenIdsMaxLength = 0;
1788             }
1789             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1790             if (tokenIdsMaxLength == 0) {
1791                 return tokenIds;
1792             }
1793             // We need to call `explicitOwnershipOf(start)`,
1794             // because the slot at `start` may not be initialized.
1795             TokenOwnership memory ownership = explicitOwnershipOf(start);
1796             address currOwnershipAddr;
1797             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1798             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1799             if (!ownership.burned) {
1800                 currOwnershipAddr = ownership.addr;
1801             }
1802             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1803                 ownership = _ownershipAt(i);
1804                 if (ownership.burned) {
1805                     continue;
1806                 }
1807                 if (ownership.addr != address(0)) {
1808                     currOwnershipAddr = ownership.addr;
1809                 }
1810                 if (currOwnershipAddr == owner) {
1811                     tokenIds[tokenIdsIdx++] = i;
1812                 }
1813             }
1814             // Downsize the array to fit.
1815             assembly {
1816                 mstore(tokenIds, tokenIdsIdx)
1817             }
1818             return tokenIds;
1819         }
1820     }
1821 
1822     /**
1823      * @dev Returns an array of token IDs owned by `owner`.
1824      *
1825      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1826      * It is meant to be called off-chain.
1827      *
1828      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1829      * multiple smaller scans if the collection is large enough to cause
1830      * an out-of-gas error (10K collections should be fine).
1831      */
1832     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1833         unchecked {
1834             uint256 tokenIdsIdx;
1835             address currOwnershipAddr;
1836             uint256 tokenIdsLength = balanceOf(owner);
1837             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1838             TokenOwnership memory ownership;
1839             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1840                 ownership = _ownershipAt(i);
1841                 if (ownership.burned) {
1842                     continue;
1843                 }
1844                 if (ownership.addr != address(0)) {
1845                     currOwnershipAddr = ownership.addr;
1846                 }
1847                 if (currOwnershipAddr == owner) {
1848                     tokenIds[tokenIdsIdx++] = i;
1849                 }
1850             }
1851             return tokenIds;
1852         }
1853     }
1854 }
1855 
1856 // File: contracts/MOONLIZZY-A.sol
1857 
1858 
1859 pragma solidity ^0.8.4;
1860 
1861 
1862 
1863 
1864 contract MOONLIZZYS is ERC721AQueryable, Ownable, Pausable {
1865     uint256 public MAX_MINTS = 100;
1866     uint256 public MAX_SUPPLY = 4999;
1867     uint256 public price = 0.005 ether;
1868     bool public freemint = true;
1869     uint256 freeQuantity = 3;
1870 
1871     string public baseURI;
1872 
1873     mapping (address => bool) public claimedFree;
1874     uint256 public claimCounter;
1875 
1876     constructor() ERC721A("MOON LIZZYS", "MLIZ") {}
1877 
1878     function mint(uint256 quantity) external payable {
1879         // _safeMint's second argument now takes in a quantity, not a tokenId.
1880         require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "mint: Exceeded the limit per wallet");
1881         require(totalSupply() + quantity <= MAX_SUPPLY, "mint: Not enough tokens left");
1882         require(msg.value >= (price * quantity), "mint: Not enough ether sent");
1883 
1884         _safeMint(msg.sender, quantity);
1885     }
1886 
1887     function freeMint() external {
1888         require(claimedFree[msg.sender] == false, "freeMint: wallet already claimed");
1889         require(freemint == true, "freeMint: Free mint is not active");
1890         claimedFree[msg.sender] = true;
1891         claimCounter += freeQuantity;
1892         _safeMint(msg.sender, freeQuantity);
1893     }
1894 
1895     function airDrop(address[] calldata addrs, uint256 quantity) external onlyOwner {
1896         uint256 len = addrs.length;
1897         require(totalSupply() + (quantity * len) <= MAX_SUPPLY, "airDrop: Not enough tokens to airdrop");
1898         for (uint256 i = 0; i < len; i++) {
1899             _safeMint(addrs[i], quantity);
1900         }
1901     }
1902 
1903     function _baseURI() internal view override returns (string memory) {
1904         return baseURI;
1905     }
1906 
1907     function setPrice(uint256 _price) external onlyOwner {
1908         price = _price;
1909     }
1910 
1911     function setMaxMint(uint256 _max) external onlyOwner {
1912         MAX_MINTS = _max;
1913     }
1914 
1915     function toggleFreeMint() external onlyOwner {
1916         freemint = !freemint;
1917     }
1918 
1919     function toggleAllMintPause() external onlyOwner {
1920         paused() ? _unpause() : _pause();
1921     }
1922 
1923     function setBaseURI(string memory _uri) external onlyOwner {
1924         baseURI = _uri;
1925     }
1926 
1927     function updateFreeQuantity(uint256 _num) external onlyOwner {
1928         freeQuantity = _num;
1929     }
1930 
1931     function updateMaxSupply(uint256 _max) external onlyOwner {
1932         MAX_SUPPLY = _max;
1933     }
1934 
1935     function withdraw() external onlyOwner {
1936         require(address(this).balance > 0, "withdraw: contract balance must be greater than 0"); 
1937         uint256 balance = address(this).balance; 
1938         payable(msg.sender).transfer(balance);
1939     }
1940 
1941 }