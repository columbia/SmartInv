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
223 // ERC721A Contracts v4.1.0
224 // Creator: Chiru Labs
225 
226 pragma solidity ^0.8.4;
227 
228 /**
229  * @dev Interface of an ERC721A compliant contract.
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
278      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
279      */
280     error TransferToNonERC721ReceiverImplementer();
281 
282     /**
283      * Cannot transfer to the zero address.
284      */
285     error TransferToZeroAddress();
286 
287     /**
288      * The token does not exist.
289      */
290     error URIQueryForNonexistentToken();
291 
292     /**
293      * The `quantity` minted with ERC2309 exceeds the safety limit.
294      */
295     error MintERC2309QuantityExceedsLimit();
296 
297     /**
298      * The `extraData` cannot be set on an unintialized ownership slot.
299      */
300     error OwnershipNotInitializedForExtraData();
301 
302     struct TokenOwnership {
303         // The address of the owner.
304         address addr;
305         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
306         uint64 startTimestamp;
307         // Whether the token has been burned.
308         bool burned;
309         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
310         uint24 extraData;
311     }
312 
313     /**
314      * @dev Returns the total amount of tokens stored by the contract.
315      *
316      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
317      */
318     function totalSupply() external view returns (uint256);
319 
320     // ==============================
321     //            IERC165
322     // ==============================
323 
324     /**
325      * @dev Returns true if this contract implements the interface defined by
326      * `interfaceId`. See the corresponding
327      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
328      * to learn more about how these ids are created.
329      *
330      * This function call must use less than 30 000 gas.
331      */
332     function supportsInterface(bytes4 interfaceId) external view returns (bool);
333 
334     // ==============================
335     //            IERC721
336     // ==============================
337 
338     /**
339      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
340      */
341     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
342 
343     /**
344      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
345      */
346     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
347 
348     /**
349      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
350      */
351     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
352 
353     /**
354      * @dev Returns the number of tokens in ``owner``'s account.
355      */
356     function balanceOf(address owner) external view returns (uint256 balance);
357 
358     /**
359      * @dev Returns the owner of the `tokenId` token.
360      *
361      * Requirements:
362      *
363      * - `tokenId` must exist.
364      */
365     function ownerOf(uint256 tokenId) external view returns (address owner);
366 
367     /**
368      * @dev Safely transfers `tokenId` token from `from` to `to`.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must exist and be owned by `from`.
375      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
376      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
377      *
378      * Emits a {Transfer} event.
379      */
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 tokenId,
384         bytes calldata data
385     ) external;
386 
387     /**
388      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
389      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
390      *
391      * Requirements:
392      *
393      * - `from` cannot be the zero address.
394      * - `to` cannot be the zero address.
395      * - `tokenId` token must exist and be owned by `from`.
396      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
397      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
398      *
399      * Emits a {Transfer} event.
400      */
401     function safeTransferFrom(
402         address from,
403         address to,
404         uint256 tokenId
405     ) external;
406 
407     /**
408      * @dev Transfers `tokenId` token from `from` to `to`.
409      *
410      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
411      *
412      * Requirements:
413      *
414      * - `from` cannot be the zero address.
415      * - `to` cannot be the zero address.
416      * - `tokenId` token must be owned by `from`.
417      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(
422         address from,
423         address to,
424         uint256 tokenId
425     ) external;
426 
427     /**
428      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
429      * The approval is cleared when the token is transferred.
430      *
431      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
432      *
433      * Requirements:
434      *
435      * - The caller must own the token or be an approved operator.
436      * - `tokenId` must exist.
437      *
438      * Emits an {Approval} event.
439      */
440     function approve(address to, uint256 tokenId) external;
441 
442     /**
443      * @dev Approve or remove `operator` as an operator for the caller.
444      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
445      *
446      * Requirements:
447      *
448      * - The `operator` cannot be the caller.
449      *
450      * Emits an {ApprovalForAll} event.
451      */
452     function setApprovalForAll(address operator, bool _approved) external;
453 
454     /**
455      * @dev Returns the account approved for `tokenId` token.
456      *
457      * Requirements:
458      *
459      * - `tokenId` must exist.
460      */
461     function getApproved(uint256 tokenId) external view returns (address operator);
462 
463     /**
464      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
465      *
466      * See {setApprovalForAll}
467      */
468     function isApprovedForAll(address owner, address operator) external view returns (bool);
469 
470     // ==============================
471     //        IERC721Metadata
472     // ==============================
473 
474     /**
475      * @dev Returns the token collection name.
476      */
477     function name() external view returns (string memory);
478 
479     /**
480      * @dev Returns the token collection symbol.
481      */
482     function symbol() external view returns (string memory);
483 
484     /**
485      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
486      */
487     function tokenURI(uint256 tokenId) external view returns (string memory);
488 
489     // ==============================
490     //            IERC2309
491     // ==============================
492 
493     /**
494      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
495      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
496      */
497     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
498 }
499 
500 // File: erc721a/contracts/ERC721A.sol
501 
502 
503 // ERC721A Contracts v4.1.0
504 // Creator: Chiru Labs
505 
506 pragma solidity ^0.8.4;
507 
508 
509 /**
510  * @dev ERC721 token receiver interface.
511  */
512 interface ERC721A__IERC721Receiver {
513     function onERC721Received(
514         address operator,
515         address from,
516         uint256 tokenId,
517         bytes calldata data
518     ) external returns (bytes4);
519 }
520 
521 /**
522  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
523  * including the Metadata extension. Built to optimize for lower gas during batch mints.
524  *
525  * Assumes serials are sequentially minted starting at `_startTokenId()`
526  * (defaults to 0, e.g. 0, 1, 2, 3..).
527  *
528  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
529  *
530  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
531  */
532 contract ERC721A is IERC721A {
533     // Mask of an entry in packed address data.
534     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
535 
536     // The bit position of `numberMinted` in packed address data.
537     uint256 private constant BITPOS_NUMBER_MINTED = 64;
538 
539     // The bit position of `numberBurned` in packed address data.
540     uint256 private constant BITPOS_NUMBER_BURNED = 128;
541 
542     // The bit position of `aux` in packed address data.
543     uint256 private constant BITPOS_AUX = 192;
544 
545     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
546     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
547 
548     // The bit position of `startTimestamp` in packed ownership.
549     uint256 private constant BITPOS_START_TIMESTAMP = 160;
550 
551     // The bit mask of the `burned` bit in packed ownership.
552     uint256 private constant BITMASK_BURNED = 1 << 224;
553 
554     // The bit position of the `nextInitialized` bit in packed ownership.
555     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
556 
557     // The bit mask of the `nextInitialized` bit in packed ownership.
558     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
559 
560     // The bit position of `extraData` in packed ownership.
561     uint256 private constant BITPOS_EXTRA_DATA = 232;
562 
563     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
564     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
565 
566     // The mask of the lower 160 bits for addresses.
567     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
568 
569     // The maximum `quantity` that can be minted with `_mintERC2309`.
570     // This limit is to prevent overflows on the address data entries.
571     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
572     // is required to cause an overflow, which is unrealistic.
573     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
574 
575     // The tokenId of the next token to be minted.
576     uint256 private _currentIndex;
577 
578     // The number of tokens burned.
579     uint256 private _burnCounter;
580 
581     // Token name
582     string private _name;
583 
584     // Token symbol
585     string private _symbol;
586 
587     // Mapping from token ID to ownership details
588     // An empty struct value does not necessarily mean the token is unowned.
589     // See `_packedOwnershipOf` implementation for details.
590     //
591     // Bits Layout:
592     // - [0..159]   `addr`
593     // - [160..223] `startTimestamp`
594     // - [224]      `burned`
595     // - [225]      `nextInitialized`
596     // - [232..255] `extraData`
597     mapping(uint256 => uint256) private _packedOwnerships;
598 
599     // Mapping owner address to address data.
600     //
601     // Bits Layout:
602     // - [0..63]    `balance`
603     // - [64..127]  `numberMinted`
604     // - [128..191] `numberBurned`
605     // - [192..255] `aux`
606     mapping(address => uint256) private _packedAddressData;
607 
608     // Mapping from token ID to approved address.
609     mapping(uint256 => address) private _tokenApprovals;
610 
611     // Mapping from owner to operator approvals
612     mapping(address => mapping(address => bool)) private _operatorApprovals;
613 
614     constructor(string memory name_, string memory symbol_) {
615         _name = name_;
616         _symbol = symbol_;
617         _currentIndex = _startTokenId();
618     }
619 
620     /**
621      * @dev Returns the starting token ID.
622      * To change the starting token ID, please override this function.
623      */
624     function _startTokenId() internal view virtual returns (uint256) {
625         return 0;
626     }
627 
628     /**
629      * @dev Returns the next token ID to be minted.
630      */
631     function _nextTokenId() internal view returns (uint256) {
632         return _currentIndex;
633     }
634 
635     /**
636      * @dev Returns the total number of tokens in existence.
637      * Burned tokens will reduce the count.
638      * To get the total number of tokens minted, please see `_totalMinted`.
639      */
640     function totalSupply() public view override returns (uint256) {
641         // Counter underflow is impossible as _burnCounter cannot be incremented
642         // more than `_currentIndex - _startTokenId()` times.
643         unchecked {
644             return _currentIndex - _burnCounter - _startTokenId();
645         }
646     }
647 
648     /**
649      * @dev Returns the total amount of tokens minted in the contract.
650      */
651     function _totalMinted() internal view returns (uint256) {
652         // Counter underflow is impossible as _currentIndex does not decrement,
653         // and it is initialized to `_startTokenId()`
654         unchecked {
655             return _currentIndex - _startTokenId();
656         }
657     }
658 
659     /**
660      * @dev Returns the total number of tokens burned.
661      */
662     function _totalBurned() internal view returns (uint256) {
663         return _burnCounter;
664     }
665 
666     /**
667      * @dev See {IERC165-supportsInterface}.
668      */
669     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
670         // The interface IDs are constants representing the first 4 bytes of the XOR of
671         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
672         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
673         return
674             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
675             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
676             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
677     }
678 
679     /**
680      * @dev See {IERC721-balanceOf}.
681      */
682     function balanceOf(address owner) public view override returns (uint256) {
683         if (owner == address(0)) revert BalanceQueryForZeroAddress();
684         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
685     }
686 
687     /**
688      * Returns the number of tokens minted by `owner`.
689      */
690     function _numberMinted(address owner) internal view returns (uint256) {
691         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
692     }
693 
694     /**
695      * Returns the number of tokens burned by or on behalf of `owner`.
696      */
697     function _numberBurned(address owner) internal view returns (uint256) {
698         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
699     }
700 
701     /**
702      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
703      */
704     function _getAux(address owner) internal view returns (uint64) {
705         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
706     }
707 
708     /**
709      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
710      * If there are multiple variables, please pack them into a uint64.
711      */
712     function _setAux(address owner, uint64 aux) internal {
713         uint256 packed = _packedAddressData[owner];
714         uint256 auxCasted;
715         // Cast `aux` with assembly to avoid redundant masking.
716         assembly {
717             auxCasted := aux
718         }
719         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
720         _packedAddressData[owner] = packed;
721     }
722 
723     /**
724      * Returns the packed ownership data of `tokenId`.
725      */
726     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
727         uint256 curr = tokenId;
728 
729         unchecked {
730             if (_startTokenId() <= curr)
731                 if (curr < _currentIndex) {
732                     uint256 packed = _packedOwnerships[curr];
733                     // If not burned.
734                     if (packed & BITMASK_BURNED == 0) {
735                         // Invariant:
736                         // There will always be an ownership that has an address and is not burned
737                         // before an ownership that does not have an address and is not burned.
738                         // Hence, curr will not underflow.
739                         //
740                         // We can directly compare the packed value.
741                         // If the address is zero, packed is zero.
742                         while (packed == 0) {
743                             packed = _packedOwnerships[--curr];
744                         }
745                         return packed;
746                     }
747                 }
748         }
749         revert OwnerQueryForNonexistentToken();
750     }
751 
752     /**
753      * Returns the unpacked `TokenOwnership` struct from `packed`.
754      */
755     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
756         ownership.addr = address(uint160(packed));
757         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
758         ownership.burned = packed & BITMASK_BURNED != 0;
759         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
760     }
761 
762     /**
763      * Returns the unpacked `TokenOwnership` struct at `index`.
764      */
765     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
766         return _unpackedOwnership(_packedOwnerships[index]);
767     }
768 
769     /**
770      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
771      */
772     function _initializeOwnershipAt(uint256 index) internal {
773         if (_packedOwnerships[index] == 0) {
774             _packedOwnerships[index] = _packedOwnershipOf(index);
775         }
776     }
777 
778     /**
779      * Gas spent here starts off proportional to the maximum mint batch size.
780      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
781      */
782     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
783         return _unpackedOwnership(_packedOwnershipOf(tokenId));
784     }
785 
786     /**
787      * @dev Packs ownership data into a single uint256.
788      */
789     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
790         assembly {
791             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
792             owner := and(owner, BITMASK_ADDRESS)
793             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
794             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
795         }
796     }
797 
798     /**
799      * @dev See {IERC721-ownerOf}.
800      */
801     function ownerOf(uint256 tokenId) public view override returns (address) {
802         return address(uint160(_packedOwnershipOf(tokenId)));
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-name}.
807      */
808     function name() public view virtual override returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-symbol}.
814      */
815     function symbol() public view virtual override returns (string memory) {
816         return _symbol;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-tokenURI}.
821      */
822     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
823         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
824 
825         string memory baseURI = _baseURI();
826         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
827     }
828 
829     /**
830      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
831      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
832      * by default, it can be overridden in child contracts.
833      */
834     function _baseURI() internal view virtual returns (string memory) {
835         return '';
836     }
837 
838     /**
839      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
840      */
841     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
842         // For branchless setting of the `nextInitialized` flag.
843         assembly {
844             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
845             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
846         }
847     }
848 
849     /**
850      * @dev See {IERC721-approve}.
851      */
852     function approve(address to, uint256 tokenId) public override {
853         address owner = ownerOf(tokenId);
854 
855         if (_msgSenderERC721A() != owner)
856             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
857                 revert ApprovalCallerNotOwnerNorApproved();
858             }
859 
860         _tokenApprovals[tokenId] = to;
861         emit Approval(owner, to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-getApproved}.
866      */
867     function getApproved(uint256 tokenId) public view override returns (address) {
868         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
869 
870         return _tokenApprovals[tokenId];
871     }
872 
873     /**
874      * @dev See {IERC721-setApprovalForAll}.
875      */
876     function setApprovalForAll(address operator, bool approved) public virtual override {
877         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
878 
879         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
880         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
881     }
882 
883     /**
884      * @dev See {IERC721-isApprovedForAll}.
885      */
886     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
887         return _operatorApprovals[owner][operator];
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         safeTransferFrom(from, to, tokenId, '');
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) public virtual override {
910         transferFrom(from, to, tokenId);
911         if (to.code.length != 0)
912             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
913                 revert TransferToNonERC721ReceiverImplementer();
914             }
915     }
916 
917     /**
918      * @dev Returns whether `tokenId` exists.
919      *
920      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
921      *
922      * Tokens start existing when they are minted (`_mint`),
923      */
924     function _exists(uint256 tokenId) internal view returns (bool) {
925         return
926             _startTokenId() <= tokenId &&
927             tokenId < _currentIndex && // If within bounds,
928             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
929     }
930 
931     /**
932      * @dev Equivalent to `_safeMint(to, quantity, '')`.
933      */
934     function _safeMint(address to, uint256 quantity) internal {
935         _safeMint(to, quantity, '');
936     }
937 
938     /**
939      * @dev Safely mints `quantity` tokens and transfers them to `to`.
940      *
941      * Requirements:
942      *
943      * - If `to` refers to a smart contract, it must implement
944      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
945      * - `quantity` must be greater than 0.
946      *
947      * See {_mint}.
948      *
949      * Emits a {Transfer} event for each mint.
950      */
951     function _safeMint(
952         address to,
953         uint256 quantity,
954         bytes memory _data
955     ) internal {
956         _mint(to, quantity);
957 
958         unchecked {
959             if (to.code.length != 0) {
960                 uint256 end = _currentIndex;
961                 uint256 index = end - quantity;
962                 do {
963                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
964                         revert TransferToNonERC721ReceiverImplementer();
965                     }
966                 } while (index < end);
967                 // Reentrancy protection.
968                 if (_currentIndex != end) revert();
969             }
970         }
971     }
972 
973     /**
974      * @dev Mints `quantity` tokens and transfers them to `to`.
975      *
976      * Requirements:
977      *
978      * - `to` cannot be the zero address.
979      * - `quantity` must be greater than 0.
980      *
981      * Emits a {Transfer} event for each mint.
982      */
983     function _mint(address to, uint256 quantity) internal {
984         uint256 startTokenId = _currentIndex;
985         if (to == address(0)) revert MintToZeroAddress();
986         if (quantity == 0) revert MintZeroQuantity();
987 
988         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
989 
990         // Overflows are incredibly unrealistic.
991         // `balance` and `numberMinted` have a maximum limit of 2**64.
992         // `tokenId` has a maximum limit of 2**256.
993         unchecked {
994             // Updates:
995             // - `balance += quantity`.
996             // - `numberMinted += quantity`.
997             //
998             // We can directly add to the `balance` and `numberMinted`.
999             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1000 
1001             // Updates:
1002             // - `address` to the owner.
1003             // - `startTimestamp` to the timestamp of minting.
1004             // - `burned` to `false`.
1005             // - `nextInitialized` to `quantity == 1`.
1006             _packedOwnerships[startTokenId] = _packOwnershipData(
1007                 to,
1008                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1009             );
1010 
1011             uint256 tokenId = startTokenId;
1012             uint256 end = startTokenId + quantity;
1013             do {
1014                 emit Transfer(address(0), to, tokenId++);
1015             } while (tokenId < end);
1016 
1017             _currentIndex = end;
1018         }
1019         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1020     }
1021 
1022     /**
1023      * @dev Mints `quantity` tokens and transfers them to `to`.
1024      *
1025      * This function is intended for efficient minting only during contract creation.
1026      *
1027      * It emits only one {ConsecutiveTransfer} as defined in
1028      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1029      * instead of a sequence of {Transfer} event(s).
1030      *
1031      * Calling this function outside of contract creation WILL make your contract
1032      * non-compliant with the ERC721 standard.
1033      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1034      * {ConsecutiveTransfer} event is only permissible during contract creation.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `quantity` must be greater than 0.
1040      *
1041      * Emits a {ConsecutiveTransfer} event.
1042      */
1043     function _mintERC2309(address to, uint256 quantity) internal {
1044         uint256 startTokenId = _currentIndex;
1045         if (to == address(0)) revert MintToZeroAddress();
1046         if (quantity == 0) revert MintZeroQuantity();
1047         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1048 
1049         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1050 
1051         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1052         unchecked {
1053             // Updates:
1054             // - `balance += quantity`.
1055             // - `numberMinted += quantity`.
1056             //
1057             // We can directly add to the `balance` and `numberMinted`.
1058             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1059 
1060             // Updates:
1061             // - `address` to the owner.
1062             // - `startTimestamp` to the timestamp of minting.
1063             // - `burned` to `false`.
1064             // - `nextInitialized` to `quantity == 1`.
1065             _packedOwnerships[startTokenId] = _packOwnershipData(
1066                 to,
1067                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1068             );
1069 
1070             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1071 
1072             _currentIndex = startTokenId + quantity;
1073         }
1074         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1075     }
1076 
1077     /**
1078      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1079      */
1080     function _getApprovedAddress(uint256 tokenId)
1081         private
1082         view
1083         returns (uint256 approvedAddressSlot, address approvedAddress)
1084     {
1085         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1086         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1087         assembly {
1088             // Compute the slot.
1089             mstore(0x00, tokenId)
1090             mstore(0x20, tokenApprovalsPtr.slot)
1091             approvedAddressSlot := keccak256(0x00, 0x40)
1092             // Load the slot's value from storage.
1093             approvedAddress := sload(approvedAddressSlot)
1094         }
1095     }
1096 
1097     /**
1098      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1099      */
1100     function _isOwnerOrApproved(
1101         address approvedAddress,
1102         address from,
1103         address msgSender
1104     ) private pure returns (bool result) {
1105         assembly {
1106             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1107             from := and(from, BITMASK_ADDRESS)
1108             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1109             msgSender := and(msgSender, BITMASK_ADDRESS)
1110             // `msgSender == from || msgSender == approvedAddress`.
1111             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1112         }
1113     }
1114 
1115     /**
1116      * @dev Transfers `tokenId` from `from` to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `to` cannot be the zero address.
1121      * - `tokenId` token must be owned by `from`.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function transferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) public virtual override {
1130         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1131 
1132         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1133 
1134         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1135 
1136         // The nested ifs save around 20+ gas over a compound boolean condition.
1137         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1138             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1139 
1140         if (to == address(0)) revert TransferToZeroAddress();
1141 
1142         _beforeTokenTransfers(from, to, tokenId, 1);
1143 
1144         // Clear approvals from the previous owner.
1145         assembly {
1146             if approvedAddress {
1147                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1148                 sstore(approvedAddressSlot, 0)
1149             }
1150         }
1151 
1152         // Underflow of the sender's balance is impossible because we check for
1153         // ownership above and the recipient's balance can't realistically overflow.
1154         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1155         unchecked {
1156             // We can directly increment and decrement the balances.
1157             --_packedAddressData[from]; // Updates: `balance -= 1`.
1158             ++_packedAddressData[to]; // Updates: `balance += 1`.
1159 
1160             // Updates:
1161             // - `address` to the next owner.
1162             // - `startTimestamp` to the timestamp of transfering.
1163             // - `burned` to `false`.
1164             // - `nextInitialized` to `true`.
1165             _packedOwnerships[tokenId] = _packOwnershipData(
1166                 to,
1167                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1168             );
1169 
1170             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1171             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1172                 uint256 nextTokenId = tokenId + 1;
1173                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1174                 if (_packedOwnerships[nextTokenId] == 0) {
1175                     // If the next slot is within bounds.
1176                     if (nextTokenId != _currentIndex) {
1177                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1178                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1179                     }
1180                 }
1181             }
1182         }
1183 
1184         emit Transfer(from, to, tokenId);
1185         _afterTokenTransfers(from, to, tokenId, 1);
1186     }
1187 
1188     /**
1189      * @dev Equivalent to `_burn(tokenId, false)`.
1190      */
1191     function _burn(uint256 tokenId) internal virtual {
1192         _burn(tokenId, false);
1193     }
1194 
1195     /**
1196      * @dev Destroys `tokenId`.
1197      * The approval is cleared when the token is burned.
1198      *
1199      * Requirements:
1200      *
1201      * - `tokenId` must exist.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1206         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1207 
1208         address from = address(uint160(prevOwnershipPacked));
1209 
1210         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1211 
1212         if (approvalCheck) {
1213             // The nested ifs save around 20+ gas over a compound boolean condition.
1214             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1215                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1216         }
1217 
1218         _beforeTokenTransfers(from, address(0), tokenId, 1);
1219 
1220         // Clear approvals from the previous owner.
1221         assembly {
1222             if approvedAddress {
1223                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1224                 sstore(approvedAddressSlot, 0)
1225             }
1226         }
1227 
1228         // Underflow of the sender's balance is impossible because we check for
1229         // ownership above and the recipient's balance can't realistically overflow.
1230         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1231         unchecked {
1232             // Updates:
1233             // - `balance -= 1`.
1234             // - `numberBurned += 1`.
1235             //
1236             // We can directly decrement the balance, and increment the number burned.
1237             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1238             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1239 
1240             // Updates:
1241             // - `address` to the last owner.
1242             // - `startTimestamp` to the timestamp of burning.
1243             // - `burned` to `true`.
1244             // - `nextInitialized` to `true`.
1245             _packedOwnerships[tokenId] = _packOwnershipData(
1246                 from,
1247                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1248             );
1249 
1250             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1251             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1252                 uint256 nextTokenId = tokenId + 1;
1253                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1254                 if (_packedOwnerships[nextTokenId] == 0) {
1255                     // If the next slot is within bounds.
1256                     if (nextTokenId != _currentIndex) {
1257                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1258                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1259                     }
1260                 }
1261             }
1262         }
1263 
1264         emit Transfer(from, address(0), tokenId);
1265         _afterTokenTransfers(from, address(0), tokenId, 1);
1266 
1267         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1268         unchecked {
1269             _burnCounter++;
1270         }
1271     }
1272 
1273     /**
1274      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1275      *
1276      * @param from address representing the previous owner of the given token ID
1277      * @param to target address that will receive the tokens
1278      * @param tokenId uint256 ID of the token to be transferred
1279      * @param _data bytes optional data to send along with the call
1280      * @return bool whether the call correctly returned the expected magic value
1281      */
1282     function _checkContractOnERC721Received(
1283         address from,
1284         address to,
1285         uint256 tokenId,
1286         bytes memory _data
1287     ) private returns (bool) {
1288         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1289             bytes4 retval
1290         ) {
1291             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1292         } catch (bytes memory reason) {
1293             if (reason.length == 0) {
1294                 revert TransferToNonERC721ReceiverImplementer();
1295             } else {
1296                 assembly {
1297                     revert(add(32, reason), mload(reason))
1298                 }
1299             }
1300         }
1301     }
1302 
1303     /**
1304      * @dev Directly sets the extra data for the ownership data `index`.
1305      */
1306     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1307         uint256 packed = _packedOwnerships[index];
1308         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1309         uint256 extraDataCasted;
1310         // Cast `extraData` with assembly to avoid redundant masking.
1311         assembly {
1312             extraDataCasted := extraData
1313         }
1314         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1315         _packedOwnerships[index] = packed;
1316     }
1317 
1318     /**
1319      * @dev Returns the next extra data for the packed ownership data.
1320      * The returned result is shifted into position.
1321      */
1322     function _nextExtraData(
1323         address from,
1324         address to,
1325         uint256 prevOwnershipPacked
1326     ) private view returns (uint256) {
1327         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1328         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1329     }
1330 
1331     /**
1332      * @dev Called during each token transfer to set the 24bit `extraData` field.
1333      * Intended to be overridden by the cosumer contract.
1334      *
1335      * `previousExtraData` - the value of `extraData` before transfer.
1336      *
1337      * Calling conditions:
1338      *
1339      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1340      * transferred to `to`.
1341      * - When `from` is zero, `tokenId` will be minted for `to`.
1342      * - When `to` is zero, `tokenId` will be burned by `from`.
1343      * - `from` and `to` are never both zero.
1344      */
1345     function _extraData(
1346         address from,
1347         address to,
1348         uint24 previousExtraData
1349     ) internal view virtual returns (uint24) {}
1350 
1351     /**
1352      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1353      * This includes minting.
1354      * And also called before burning one token.
1355      *
1356      * startTokenId - the first token id to be transferred
1357      * quantity - the amount to be transferred
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` will be minted for `to`.
1364      * - When `to` is zero, `tokenId` will be burned by `from`.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _beforeTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 
1374     /**
1375      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1376      * This includes minting.
1377      * And also called after one token has been burned.
1378      *
1379      * startTokenId - the first token id to be transferred
1380      * quantity - the amount to be transferred
1381      *
1382      * Calling conditions:
1383      *
1384      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1385      * transferred to `to`.
1386      * - When `from` is zero, `tokenId` has been minted for `to`.
1387      * - When `to` is zero, `tokenId` has been burned by `from`.
1388      * - `from` and `to` are never both zero.
1389      */
1390     function _afterTokenTransfers(
1391         address from,
1392         address to,
1393         uint256 startTokenId,
1394         uint256 quantity
1395     ) internal virtual {}
1396 
1397     /**
1398      * @dev Returns the message sender (defaults to `msg.sender`).
1399      *
1400      * If you are writing GSN compatible contracts, you need to override this function.
1401      */
1402     function _msgSenderERC721A() internal view virtual returns (address) {
1403         return msg.sender;
1404     }
1405 
1406     /**
1407      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1408      */
1409     function _toString(uint256 value) internal pure returns (string memory ptr) {
1410         assembly {
1411             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1412             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1413             // We will need 1 32-byte word to store the length,
1414             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1415             ptr := add(mload(0x40), 128)
1416             // Update the free memory pointer to allocate.
1417             mstore(0x40, ptr)
1418 
1419             // Cache the end of the memory to calculate the length later.
1420             let end := ptr
1421 
1422             // We write the string from the rightmost digit to the leftmost digit.
1423             // The following is essentially a do-while loop that also handles the zero case.
1424             // Costs a bit more than early returning for the zero case,
1425             // but cheaper in terms of deployment and overall runtime costs.
1426             for {
1427                 // Initialize and perform the first pass without check.
1428                 let temp := value
1429                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1430                 ptr := sub(ptr, 1)
1431                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1432                 mstore8(ptr, add(48, mod(temp, 10)))
1433                 temp := div(temp, 10)
1434             } temp {
1435                 // Keep dividing `temp` until zero.
1436                 temp := div(temp, 10)
1437             } {
1438                 // Body of the for loop.
1439                 ptr := sub(ptr, 1)
1440                 mstore8(ptr, add(48, mod(temp, 10)))
1441             }
1442 
1443             let length := sub(end, ptr)
1444             // Move the pointer 32 bytes leftwards to make room for the length.
1445             ptr := sub(ptr, 32)
1446             // Store the length.
1447             mstore(ptr, length)
1448         }
1449     }
1450 }
1451 
1452 // File: contracts/Wench.sol
1453 
1454 
1455 
1456 // Because pancakes are better than waffles.
1457 
1458 pragma solidity ^0.8.0;
1459 
1460 
1461 
1462 
1463 contract Wench is ERC721A, Ownable, Pausable {
1464     uint256 public mintPrice = .0069 ether;
1465     uint256 public maxSupply = 2043;
1466     uint256 public maxMint = 20;
1467     string public baseURI;
1468 
1469     constructor() ERC721A("Wench 2043 Rebooted", "WENCH") {
1470         setBaseURI("ipfs://bafybeicbljctj7w5b3r3ccdjan2fanamkurmjwd5k2d232xv2abajtgspa/");
1471         _pause();
1472     }
1473 
1474     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1475         baseURI = _newBaseURI;
1476     }
1477 
1478     function mint(uint256 amount) external payable whenNotPaused {
1479         require(
1480             msg.value >= mintPrice * amount,
1481             "Not enough ETH for purchase."
1482         );
1483         require(amount <= maxMint, "exceeded max mint amount.");
1484         require(totalSupply() + amount <= maxSupply, "Not enough remaining.");
1485         _safeMint(msg.sender, amount);
1486     }
1487 
1488     function devMint(address to, uint256 amount) external onlyOwner {
1489         require(totalSupply() + amount <= maxSupply, "Not enough remaining.");
1490         _safeMint(to, amount);
1491     }
1492 
1493     function setPrice(uint256 newPrice) public onlyOwner {
1494         mintPrice = newPrice;
1495     }
1496 
1497     function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
1498         maxMint = _newMaxMintAmount;
1499     }
1500 
1501     function lowerMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1502         require(
1503             _newMaxSupply < maxSupply,
1504             "New supply must be less than current."
1505         );
1506         maxSupply = _newMaxSupply;
1507     }
1508 
1509     function withdraw() public onlyOwner {
1510         payable(msg.sender).transfer(address(this).balance);
1511     }
1512 
1513     function _baseURI() internal view virtual override returns (string memory) {
1514         return baseURI;
1515     }
1516 
1517     function pause() public onlyOwner {
1518         _pause();
1519     }
1520 
1521     function unpause() public onlyOwner {
1522         _unpause();
1523     }
1524 
1525     function _startTokenId() internal view override returns (uint256) {
1526         return 1;
1527     }
1528 }