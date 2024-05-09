1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/access/Ownable.sol
101 
102 
103 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Throws if called by any account other than the owner.
134      */
135     modifier onlyOwner() {
136         _checkOwner();
137         _;
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view virtual returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if the sender is not the owner.
149      */
150     function _checkOwner() internal view virtual {
151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
152     }
153 
154     /**
155      * @dev Leaves the contract without owner. It will not be possible to call
156      * `onlyOwner` functions anymore. Can only be called by the current owner.
157      *
158      * NOTE: Renouncing ownership will leave the contract without an owner,
159      * thereby removing any functionality that is only available to the owner.
160      */
161     function renounceOwnership() public virtual onlyOwner {
162         _transferOwnership(address(0));
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Internal function without access restriction.
177      */
178     function _transferOwnership(address newOwner) internal virtual {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 }
184 
185 // File: erc721a/contracts/IERC721A.sol
186 
187 
188 // ERC721A Contracts v4.2.3
189 // Creator: Chiru Labs
190 
191 pragma solidity ^0.8.4;
192 
193 /**
194  * @dev Interface of ERC721A.
195  */
196 interface IERC721A {
197     /**
198      * The caller must own the token or be an approved operator.
199      */
200     error ApprovalCallerNotOwnerNorApproved();
201 
202     /**
203      * The token does not exist.
204      */
205     error ApprovalQueryForNonexistentToken();
206 
207     /**
208      * Cannot query the balance for the zero address.
209      */
210     error BalanceQueryForZeroAddress();
211 
212     /**
213      * Cannot mint to the zero address.
214      */
215     error MintToZeroAddress();
216 
217     /**
218      * The quantity of tokens minted must be more than zero.
219      */
220     error MintZeroQuantity();
221 
222     /**
223      * The token does not exist.
224      */
225     error OwnerQueryForNonexistentToken();
226 
227     /**
228      * The caller must own the token or be an approved operator.
229      */
230     error TransferCallerNotOwnerNorApproved();
231 
232     /**
233      * The token must be owned by `from`.
234      */
235     error TransferFromIncorrectOwner();
236 
237     /**
238      * Cannot safely transfer to a contract that does not implement the
239      * ERC721Receiver interface.
240      */
241     error TransferToNonERC721ReceiverImplementer();
242 
243     /**
244      * Cannot transfer to the zero address.
245      */
246     error TransferToZeroAddress();
247 
248     /**
249      * The token does not exist.
250      */
251     error URIQueryForNonexistentToken();
252 
253     /**
254      * The `quantity` minted with ERC2309 exceeds the safety limit.
255      */
256     error MintERC2309QuantityExceedsLimit();
257 
258     /**
259      * The `extraData` cannot be set on an unintialized ownership slot.
260      */
261     error OwnershipNotInitializedForExtraData();
262 
263     // =============================================================
264     //                            STRUCTS
265     // =============================================================
266 
267     struct TokenOwnership {
268         // The address of the owner.
269         address addr;
270         // Stores the start time of ownership with minimal overhead for tokenomics.
271         uint64 startTimestamp;
272         // Whether the token has been burned.
273         bool burned;
274         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
275         uint24 extraData;
276     }
277 
278     // =============================================================
279     //                         TOKEN COUNTERS
280     // =============================================================
281 
282     /**
283      * @dev Returns the total number of tokens in existence.
284      * Burned tokens will reduce the count.
285      * To get the total number of tokens minted, please see {_totalMinted}.
286      */
287     function totalSupply() external view returns (uint256);
288 
289     // =============================================================
290     //                            IERC165
291     // =============================================================
292 
293     /**
294      * @dev Returns true if this contract implements the interface defined by
295      * `interfaceId`. See the corresponding
296      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
297      * to learn more about how these ids are created.
298      *
299      * This function call must use less than 30000 gas.
300      */
301     function supportsInterface(bytes4 interfaceId) external view returns (bool);
302 
303     // =============================================================
304     //                            IERC721
305     // =============================================================
306 
307     /**
308      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
309      */
310     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
311 
312     /**
313      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
314      */
315     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
316 
317     /**
318      * @dev Emitted when `owner` enables or disables
319      * (`approved`) `operator` to manage all of its assets.
320      */
321     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
322 
323     /**
324      * @dev Returns the number of tokens in `owner`'s account.
325      */
326     function balanceOf(address owner) external view returns (uint256 balance);
327 
328     /**
329      * @dev Returns the owner of the `tokenId` token.
330      *
331      * Requirements:
332      *
333      * - `tokenId` must exist.
334      */
335     function ownerOf(uint256 tokenId) external view returns (address owner);
336 
337     /**
338      * @dev Safely transfers `tokenId` token from `from` to `to`,
339      * checking first that contract recipients are aware of the ERC721 protocol
340      * to prevent tokens from being forever locked.
341      *
342      * Requirements:
343      *
344      * - `from` cannot be the zero address.
345      * - `to` cannot be the zero address.
346      * - `tokenId` token must exist and be owned by `from`.
347      * - If the caller is not `from`, it must be have been allowed to move
348      * this token by either {approve} or {setApprovalForAll}.
349      * - If `to` refers to a smart contract, it must implement
350      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
351      *
352      * Emits a {Transfer} event.
353      */
354     function safeTransferFrom(
355         address from,
356         address to,
357         uint256 tokenId,
358         bytes calldata data
359     ) external payable;
360 
361     /**
362      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
363      */
364     function safeTransferFrom(
365         address from,
366         address to,
367         uint256 tokenId
368     ) external payable;
369 
370     /**
371      * @dev Transfers `tokenId` from `from` to `to`.
372      *
373      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
374      * whenever possible.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `tokenId` token must be owned by `from`.
381      * - If the caller is not `from`, it must be approved to move this token
382      * by either {approve} or {setApprovalForAll}.
383      *
384      * Emits a {Transfer} event.
385      */
386     function transferFrom(
387         address from,
388         address to,
389         uint256 tokenId
390     ) external payable;
391 
392     /**
393      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
394      * The approval is cleared when the token is transferred.
395      *
396      * Only a single account can be approved at a time, so approving the
397      * zero address clears previous approvals.
398      *
399      * Requirements:
400      *
401      * - The caller must own the token or be an approved operator.
402      * - `tokenId` must exist.
403      *
404      * Emits an {Approval} event.
405      */
406     function approve(address to, uint256 tokenId) external payable;
407 
408     /**
409      * @dev Approve or remove `operator` as an operator for the caller.
410      * Operators can call {transferFrom} or {safeTransferFrom}
411      * for any token owned by the caller.
412      *
413      * Requirements:
414      *
415      * - The `operator` cannot be the caller.
416      *
417      * Emits an {ApprovalForAll} event.
418      */
419     function setApprovalForAll(address operator, bool _approved) external;
420 
421     /**
422      * @dev Returns the account approved for `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function getApproved(uint256 tokenId) external view returns (address operator);
429 
430     /**
431      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
432      *
433      * See {setApprovalForAll}.
434      */
435     function isApprovedForAll(address owner, address operator) external view returns (bool);
436 
437     // =============================================================
438     //                        IERC721Metadata
439     // =============================================================
440 
441     /**
442      * @dev Returns the token collection name.
443      */
444     function name() external view returns (string memory);
445 
446     /**
447      * @dev Returns the token collection symbol.
448      */
449     function symbol() external view returns (string memory);
450 
451     /**
452      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
453      */
454     function tokenURI(uint256 tokenId) external view returns (string memory);
455 
456     // =============================================================
457     //                           IERC2309
458     // =============================================================
459 
460     /**
461      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
462      * (inclusive) is transferred from `from` to `to`, as defined in the
463      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
464      *
465      * See {_mintERC2309} for more details.
466      */
467     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
468 }
469 
470 // File: erc721a/contracts/ERC721A.sol
471 
472 
473 // ERC721A Contracts v4.2.3
474 // Creator: Chiru Labs
475 
476 pragma solidity ^0.8.4;
477 
478 
479 /**
480  * @dev Interface of ERC721 token receiver.
481  */
482 interface ERC721A__IERC721Receiver {
483     function onERC721Received(
484         address operator,
485         address from,
486         uint256 tokenId,
487         bytes calldata data
488     ) external returns (bytes4);
489 }
490 
491 /**
492  * @title ERC721A
493  *
494  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
495  * Non-Fungible Token Standard, including the Metadata extension.
496  * Optimized for lower gas during batch mints.
497  *
498  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
499  * starting from `_startTokenId()`.
500  *
501  * Assumptions:
502  *
503  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
504  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
505  */
506 contract ERC721A is IERC721A {
507     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
508     struct TokenApprovalRef {
509         address value;
510     }
511 
512     // =============================================================
513     //                           CONSTANTS
514     // =============================================================
515 
516     // Mask of an entry in packed address data.
517     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
518 
519     // The bit position of `numberMinted` in packed address data.
520     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
521 
522     // The bit position of `numberBurned` in packed address data.
523     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
524 
525     // The bit position of `aux` in packed address data.
526     uint256 private constant _BITPOS_AUX = 192;
527 
528     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
529     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
530 
531     // The bit position of `startTimestamp` in packed ownership.
532     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
533 
534     // The bit mask of the `burned` bit in packed ownership.
535     uint256 private constant _BITMASK_BURNED = 1 << 224;
536 
537     // The bit position of the `nextInitialized` bit in packed ownership.
538     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
539 
540     // The bit mask of the `nextInitialized` bit in packed ownership.
541     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
542 
543     // The bit position of `extraData` in packed ownership.
544     uint256 private constant _BITPOS_EXTRA_DATA = 232;
545 
546     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
547     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
548 
549     // The mask of the lower 160 bits for addresses.
550     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
551 
552     // The maximum `quantity` that can be minted with {_mintERC2309}.
553     // This limit is to prevent overflows on the address data entries.
554     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
555     // is required to cause an overflow, which is unrealistic.
556     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
557 
558     // The `Transfer` event signature is given by:
559     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
560     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
561         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
562 
563     // =============================================================
564     //                            STORAGE
565     // =============================================================
566 
567     // The next token ID to be minted.
568     uint256 private _currentIndex;
569 
570     // The number of tokens burned.
571     uint256 private _burnCounter;
572 
573     // Token name
574     string private _name;
575 
576     // Token symbol
577     string private _symbol;
578 
579     // Mapping from token ID to ownership details
580     // An empty struct value does not necessarily mean the token is unowned.
581     // See {_packedOwnershipOf} implementation for details.
582     //
583     // Bits Layout:
584     // - [0..159]   `addr`
585     // - [160..223] `startTimestamp`
586     // - [224]      `burned`
587     // - [225]      `nextInitialized`
588     // - [232..255] `extraData`
589     mapping(uint256 => uint256) private _packedOwnerships;
590 
591     // Mapping owner address to address data.
592     //
593     // Bits Layout:
594     // - [0..63]    `balance`
595     // - [64..127]  `numberMinted`
596     // - [128..191] `numberBurned`
597     // - [192..255] `aux`
598     mapping(address => uint256) private _packedAddressData;
599 
600     // Mapping from token ID to approved address.
601     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
602 
603     // Mapping from owner to operator approvals
604     mapping(address => mapping(address => bool)) private _operatorApprovals;
605 
606     // =============================================================
607     //                          CONSTRUCTOR
608     // =============================================================
609 
610     constructor(string memory name_, string memory symbol_) {
611         _name = name_;
612         _symbol = symbol_;
613         _currentIndex = _startTokenId();
614     }
615 
616     // =============================================================
617     //                   TOKEN COUNTING OPERATIONS
618     // =============================================================
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
631     function _nextTokenId() internal view virtual returns (uint256) {
632         return _currentIndex;
633     }
634 
635     /**
636      * @dev Returns the total number of tokens in existence.
637      * Burned tokens will reduce the count.
638      * To get the total number of tokens minted, please see {_totalMinted}.
639      */
640     function totalSupply() public view virtual override returns (uint256) {
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
651     function _totalMinted() internal view virtual returns (uint256) {
652         // Counter underflow is impossible as `_currentIndex` does not decrement,
653         // and it is initialized to `_startTokenId()`.
654         unchecked {
655             return _currentIndex - _startTokenId();
656         }
657     }
658 
659     /**
660      * @dev Returns the total number of tokens burned.
661      */
662     function _totalBurned() internal view virtual returns (uint256) {
663         return _burnCounter;
664     }
665 
666     // =============================================================
667     //                    ADDRESS DATA OPERATIONS
668     // =============================================================
669 
670     /**
671      * @dev Returns the number of tokens in `owner`'s account.
672      */
673     function balanceOf(address owner) public view virtual override returns (uint256) {
674         if (owner == address(0)) revert BalanceQueryForZeroAddress();
675         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
676     }
677 
678     /**
679      * Returns the number of tokens minted by `owner`.
680      */
681     function _numberMinted(address owner) internal view returns (uint256) {
682         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
683     }
684 
685     /**
686      * Returns the number of tokens burned by or on behalf of `owner`.
687      */
688     function _numberBurned(address owner) internal view returns (uint256) {
689         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
690     }
691 
692     /**
693      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
694      */
695     function _getAux(address owner) internal view returns (uint64) {
696         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
697     }
698 
699     /**
700      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
701      * If there are multiple variables, please pack them into a uint64.
702      */
703     function _setAux(address owner, uint64 aux) internal virtual {
704         uint256 packed = _packedAddressData[owner];
705         uint256 auxCasted;
706         // Cast `aux` with assembly to avoid redundant masking.
707         assembly {
708             auxCasted := aux
709         }
710         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
711         _packedAddressData[owner] = packed;
712     }
713 
714     // =============================================================
715     //                            IERC165
716     // =============================================================
717 
718     /**
719      * @dev Returns true if this contract implements the interface defined by
720      * `interfaceId`. See the corresponding
721      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
722      * to learn more about how these ids are created.
723      *
724      * This function call must use less than 30000 gas.
725      */
726     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727         // The interface IDs are constants representing the first 4 bytes
728         // of the XOR of all function selectors in the interface.
729         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
730         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
731         return
732             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
733             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
734             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
735     }
736 
737     // =============================================================
738     //                        IERC721Metadata
739     // =============================================================
740 
741     /**
742      * @dev Returns the token collection name.
743      */
744     function name() public view virtual override returns (string memory) {
745         return _name;
746     }
747 
748     /**
749      * @dev Returns the token collection symbol.
750      */
751     function symbol() public view virtual override returns (string memory) {
752         return _symbol;
753     }
754 
755     /**
756      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
757      */
758     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
759         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
760 
761         string memory baseURI = _baseURI();
762         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
763     }
764 
765     /**
766      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
767      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
768      * by default, it can be overridden in child contracts.
769      */
770     function _baseURI() internal view virtual returns (string memory) {
771         return '';
772     }
773 
774     // =============================================================
775     //                     OWNERSHIPS OPERATIONS
776     // =============================================================
777 
778     /**
779      * @dev Returns the owner of the `tokenId` token.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      */
785     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
786         return address(uint160(_packedOwnershipOf(tokenId)));
787     }
788 
789     /**
790      * @dev Gas spent here starts off proportional to the maximum mint batch size.
791      * It gradually moves to O(1) as tokens get transferred around over time.
792      */
793     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
794         return _unpackedOwnership(_packedOwnershipOf(tokenId));
795     }
796 
797     /**
798      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
799      */
800     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
801         return _unpackedOwnership(_packedOwnerships[index]);
802     }
803 
804     /**
805      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
806      */
807     function _initializeOwnershipAt(uint256 index) internal virtual {
808         if (_packedOwnerships[index] == 0) {
809             _packedOwnerships[index] = _packedOwnershipOf(index);
810         }
811     }
812 
813     /**
814      * Returns the packed ownership data of `tokenId`.
815      */
816     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
817         uint256 curr = tokenId;
818 
819         unchecked {
820             if (_startTokenId() <= curr)
821                 if (curr < _currentIndex) {
822                     uint256 packed = _packedOwnerships[curr];
823                     // If not burned.
824                     if (packed & _BITMASK_BURNED == 0) {
825                         // Invariant:
826                         // There will always be an initialized ownership slot
827                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
828                         // before an unintialized ownership slot
829                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
830                         // Hence, `curr` will not underflow.
831                         //
832                         // We can directly compare the packed value.
833                         // If the address is zero, packed will be zero.
834                         while (packed == 0) {
835                             packed = _packedOwnerships[--curr];
836                         }
837                         return packed;
838                     }
839                 }
840         }
841         revert OwnerQueryForNonexistentToken();
842     }
843 
844     /**
845      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
846      */
847     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
848         ownership.addr = address(uint160(packed));
849         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
850         ownership.burned = packed & _BITMASK_BURNED != 0;
851         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
852     }
853 
854     /**
855      * @dev Packs ownership data into a single uint256.
856      */
857     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
858         assembly {
859             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
860             owner := and(owner, _BITMASK_ADDRESS)
861             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
862             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
863         }
864     }
865 
866     /**
867      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
868      */
869     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
870         // For branchless setting of the `nextInitialized` flag.
871         assembly {
872             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
873             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
874         }
875     }
876 
877     // =============================================================
878     //                      APPROVAL OPERATIONS
879     // =============================================================
880 
881     /**
882      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
883      * The approval is cleared when the token is transferred.
884      *
885      * Only a single account can be approved at a time, so approving the
886      * zero address clears previous approvals.
887      *
888      * Requirements:
889      *
890      * - The caller must own the token or be an approved operator.
891      * - `tokenId` must exist.
892      *
893      * Emits an {Approval} event.
894      */
895     function approve(address to, uint256 tokenId) public payable virtual override {
896         address owner = ownerOf(tokenId);
897 
898         if (_msgSenderERC721A() != owner)
899             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
900                 revert ApprovalCallerNotOwnerNorApproved();
901             }
902 
903         _tokenApprovals[tokenId].value = to;
904         emit Approval(owner, to, tokenId);
905     }
906 
907     /**
908      * @dev Returns the account approved for `tokenId` token.
909      *
910      * Requirements:
911      *
912      * - `tokenId` must exist.
913      */
914     function getApproved(uint256 tokenId) public view virtual override returns (address) {
915         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
916 
917         return _tokenApprovals[tokenId].value;
918     }
919 
920     /**
921      * @dev Approve or remove `operator` as an operator for the caller.
922      * Operators can call {transferFrom} or {safeTransferFrom}
923      * for any token owned by the caller.
924      *
925      * Requirements:
926      *
927      * - The `operator` cannot be the caller.
928      *
929      * Emits an {ApprovalForAll} event.
930      */
931     function setApprovalForAll(address operator, bool approved) public virtual override {
932         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
933         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
934     }
935 
936     /**
937      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
938      *
939      * See {setApprovalForAll}.
940      */
941     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
942         return _operatorApprovals[owner][operator];
943     }
944 
945     /**
946      * @dev Returns whether `tokenId` exists.
947      *
948      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
949      *
950      * Tokens start existing when they are minted. See {_mint}.
951      */
952     function _exists(uint256 tokenId) internal view virtual returns (bool) {
953         return
954             _startTokenId() <= tokenId &&
955             tokenId < _currentIndex && // If within bounds,
956             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
957     }
958 
959     /**
960      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
961      */
962     function _isSenderApprovedOrOwner(
963         address approvedAddress,
964         address owner,
965         address msgSender
966     ) private pure returns (bool result) {
967         assembly {
968             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
969             owner := and(owner, _BITMASK_ADDRESS)
970             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
971             msgSender := and(msgSender, _BITMASK_ADDRESS)
972             // `msgSender == owner || msgSender == approvedAddress`.
973             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
974         }
975     }
976 
977     /**
978      * @dev Returns the storage slot and value for the approved address of `tokenId`.
979      */
980     function _getApprovedSlotAndAddress(uint256 tokenId)
981         private
982         view
983         returns (uint256 approvedAddressSlot, address approvedAddress)
984     {
985         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
986         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
987         assembly {
988             approvedAddressSlot := tokenApproval.slot
989             approvedAddress := sload(approvedAddressSlot)
990         }
991     }
992 
993     // =============================================================
994     //                      TRANSFER OPERATIONS
995     // =============================================================
996 
997     /**
998      * @dev Transfers `tokenId` from `from` to `to`.
999      *
1000      * Requirements:
1001      *
1002      * - `from` cannot be the zero address.
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must be owned by `from`.
1005      * - If the caller is not `from`, it must be approved to move this token
1006      * by either {approve} or {setApprovalForAll}.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function transferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public payable virtual override {
1015         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1016 
1017         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1018 
1019         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1020 
1021         // The nested ifs save around 20+ gas over a compound boolean condition.
1022         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1023             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1024 
1025         if (to == address(0)) revert TransferToZeroAddress();
1026 
1027         _beforeTokenTransfers(from, to, tokenId, 1);
1028 
1029         // Clear approvals from the previous owner.
1030         assembly {
1031             if approvedAddress {
1032                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1033                 sstore(approvedAddressSlot, 0)
1034             }
1035         }
1036 
1037         // Underflow of the sender's balance is impossible because we check for
1038         // ownership above and the recipient's balance can't realistically overflow.
1039         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1040         unchecked {
1041             // We can directly increment and decrement the balances.
1042             --_packedAddressData[from]; // Updates: `balance -= 1`.
1043             ++_packedAddressData[to]; // Updates: `balance += 1`.
1044 
1045             // Updates:
1046             // - `address` to the next owner.
1047             // - `startTimestamp` to the timestamp of transfering.
1048             // - `burned` to `false`.
1049             // - `nextInitialized` to `true`.
1050             _packedOwnerships[tokenId] = _packOwnershipData(
1051                 to,
1052                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1053             );
1054 
1055             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1056             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1057                 uint256 nextTokenId = tokenId + 1;
1058                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1059                 if (_packedOwnerships[nextTokenId] == 0) {
1060                     // If the next slot is within bounds.
1061                     if (nextTokenId != _currentIndex) {
1062                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1063                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1064                     }
1065                 }
1066             }
1067         }
1068 
1069         emit Transfer(from, to, tokenId);
1070         _afterTokenTransfers(from, to, tokenId, 1);
1071     }
1072 
1073     /**
1074      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) public payable virtual override {
1081         safeTransferFrom(from, to, tokenId, '');
1082     }
1083 
1084     /**
1085      * @dev Safely transfers `tokenId` token from `from` to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - `from` cannot be the zero address.
1090      * - `to` cannot be the zero address.
1091      * - `tokenId` token must exist and be owned by `from`.
1092      * - If the caller is not `from`, it must be approved to move this token
1093      * by either {approve} or {setApprovalForAll}.
1094      * - If `to` refers to a smart contract, it must implement
1095      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function safeTransferFrom(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) public payable virtual override {
1105         transferFrom(from, to, tokenId);
1106         if (to.code.length != 0)
1107             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1108                 revert TransferToNonERC721ReceiverImplementer();
1109             }
1110     }
1111 
1112     /**
1113      * @dev Hook that is called before a set of serially-ordered token IDs
1114      * are about to be transferred. This includes minting.
1115      * And also called before burning one token.
1116      *
1117      * `startTokenId` - the first token ID to be transferred.
1118      * `quantity` - the amount to be transferred.
1119      *
1120      * Calling conditions:
1121      *
1122      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1123      * transferred to `to`.
1124      * - When `from` is zero, `tokenId` will be minted for `to`.
1125      * - When `to` is zero, `tokenId` will be burned by `from`.
1126      * - `from` and `to` are never both zero.
1127      */
1128     function _beforeTokenTransfers(
1129         address from,
1130         address to,
1131         uint256 startTokenId,
1132         uint256 quantity
1133     ) internal virtual {}
1134 
1135     /**
1136      * @dev Hook that is called after a set of serially-ordered token IDs
1137      * have been transferred. This includes minting.
1138      * And also called after one token has been burned.
1139      *
1140      * `startTokenId` - the first token ID to be transferred.
1141      * `quantity` - the amount to be transferred.
1142      *
1143      * Calling conditions:
1144      *
1145      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1146      * transferred to `to`.
1147      * - When `from` is zero, `tokenId` has been minted for `to`.
1148      * - When `to` is zero, `tokenId` has been burned by `from`.
1149      * - `from` and `to` are never both zero.
1150      */
1151     function _afterTokenTransfers(
1152         address from,
1153         address to,
1154         uint256 startTokenId,
1155         uint256 quantity
1156     ) internal virtual {}
1157 
1158     /**
1159      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1160      *
1161      * `from` - Previous owner of the given token ID.
1162      * `to` - Target address that will receive the token.
1163      * `tokenId` - Token ID to be transferred.
1164      * `_data` - Optional data to send along with the call.
1165      *
1166      * Returns whether the call correctly returned the expected magic value.
1167      */
1168     function _checkContractOnERC721Received(
1169         address from,
1170         address to,
1171         uint256 tokenId,
1172         bytes memory _data
1173     ) private returns (bool) {
1174         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1175             bytes4 retval
1176         ) {
1177             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1178         } catch (bytes memory reason) {
1179             if (reason.length == 0) {
1180                 revert TransferToNonERC721ReceiverImplementer();
1181             } else {
1182                 assembly {
1183                     revert(add(32, reason), mload(reason))
1184                 }
1185             }
1186         }
1187     }
1188 
1189     // =============================================================
1190     //                        MINT OPERATIONS
1191     // =============================================================
1192 
1193     /**
1194      * @dev Mints `quantity` tokens and transfers them to `to`.
1195      *
1196      * Requirements:
1197      *
1198      * - `to` cannot be the zero address.
1199      * - `quantity` must be greater than 0.
1200      *
1201      * Emits a {Transfer} event for each mint.
1202      */
1203     function _mint(address to, uint256 quantity) internal virtual {
1204         uint256 startTokenId = _currentIndex;
1205         if (quantity == 0) revert MintZeroQuantity();
1206 
1207         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1208 
1209         // Overflows are incredibly unrealistic.
1210         // `balance` and `numberMinted` have a maximum limit of 2**64.
1211         // `tokenId` has a maximum limit of 2**256.
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
1230             uint256 toMasked;
1231             uint256 end = startTokenId + quantity;
1232 
1233             // Use assembly to loop and emit the `Transfer` event for gas savings.
1234             // The duplicated `log4` removes an extra check and reduces stack juggling.
1235             // The assembly, together with the surrounding Solidity code, have been
1236             // delicately arranged to nudge the compiler into producing optimized opcodes.
1237             assembly {
1238                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1239                 toMasked := and(to, _BITMASK_ADDRESS)
1240                 // Emit the `Transfer` event.
1241                 log4(
1242                     0, // Start of data (0, since no data).
1243                     0, // End of data (0, since no data).
1244                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1245                     0, // `address(0)`.
1246                     toMasked, // `to`.
1247                     startTokenId // `tokenId`.
1248                 )
1249 
1250                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1251                 // that overflows uint256 will make the loop run out of gas.
1252                 // The compiler will optimize the `iszero` away for performance.
1253                 for {
1254                     let tokenId := add(startTokenId, 1)
1255                 } iszero(eq(tokenId, end)) {
1256                     tokenId := add(tokenId, 1)
1257                 } {
1258                     // Emit the `Transfer` event. Similar to above.
1259                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1260                 }
1261             }
1262             if (toMasked == 0) revert MintToZeroAddress();
1263 
1264             _currentIndex = end;
1265         }
1266         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1267     }
1268 
1269     /**
1270      * @dev Mints `quantity` tokens and transfers them to `to`.
1271      *
1272      * This function is intended for efficient minting only during contract creation.
1273      *
1274      * It emits only one {ConsecutiveTransfer} as defined in
1275      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1276      * instead of a sequence of {Transfer} event(s).
1277      *
1278      * Calling this function outside of contract creation WILL make your contract
1279      * non-compliant with the ERC721 standard.
1280      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1281      * {ConsecutiveTransfer} event is only permissible during contract creation.
1282      *
1283      * Requirements:
1284      *
1285      * - `to` cannot be the zero address.
1286      * - `quantity` must be greater than 0.
1287      *
1288      * Emits a {ConsecutiveTransfer} event.
1289      */
1290     function _mintERC2309(address to, uint256 quantity) internal virtual {
1291         uint256 startTokenId = _currentIndex;
1292         if (to == address(0)) revert MintToZeroAddress();
1293         if (quantity == 0) revert MintZeroQuantity();
1294         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1295 
1296         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1297 
1298         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1299         unchecked {
1300             // Updates:
1301             // - `balance += quantity`.
1302             // - `numberMinted += quantity`.
1303             //
1304             // We can directly add to the `balance` and `numberMinted`.
1305             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1306 
1307             // Updates:
1308             // - `address` to the owner.
1309             // - `startTimestamp` to the timestamp of minting.
1310             // - `burned` to `false`.
1311             // - `nextInitialized` to `quantity == 1`.
1312             _packedOwnerships[startTokenId] = _packOwnershipData(
1313                 to,
1314                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1315             );
1316 
1317             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1318 
1319             _currentIndex = startTokenId + quantity;
1320         }
1321         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1322     }
1323 
1324     /**
1325      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1326      *
1327      * Requirements:
1328      *
1329      * - If `to` refers to a smart contract, it must implement
1330      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1331      * - `quantity` must be greater than 0.
1332      *
1333      * See {_mint}.
1334      *
1335      * Emits a {Transfer} event for each mint.
1336      */
1337     function _safeMint(
1338         address to,
1339         uint256 quantity,
1340         bytes memory _data
1341     ) internal virtual {
1342         _mint(to, quantity);
1343 
1344         unchecked {
1345             if (to.code.length != 0) {
1346                 uint256 end = _currentIndex;
1347                 uint256 index = end - quantity;
1348                 do {
1349                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1350                         revert TransferToNonERC721ReceiverImplementer();
1351                     }
1352                 } while (index < end);
1353                 // Reentrancy protection.
1354                 if (_currentIndex != end) revert();
1355             }
1356         }
1357     }
1358 
1359     /**
1360      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1361      */
1362     function _safeMint(address to, uint256 quantity) internal virtual {
1363         _safeMint(to, quantity, '');
1364     }
1365 
1366     // =============================================================
1367     //                        BURN OPERATIONS
1368     // =============================================================
1369 
1370     /**
1371      * @dev Equivalent to `_burn(tokenId, false)`.
1372      */
1373     function _burn(uint256 tokenId) internal virtual {
1374         _burn(tokenId, false);
1375     }
1376 
1377     /**
1378      * @dev Destroys `tokenId`.
1379      * The approval is cleared when the token is burned.
1380      *
1381      * Requirements:
1382      *
1383      * - `tokenId` must exist.
1384      *
1385      * Emits a {Transfer} event.
1386      */
1387     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1388         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1389 
1390         address from = address(uint160(prevOwnershipPacked));
1391 
1392         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1393 
1394         if (approvalCheck) {
1395             // The nested ifs save around 20+ gas over a compound boolean condition.
1396             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1397                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1398         }
1399 
1400         _beforeTokenTransfers(from, address(0), tokenId, 1);
1401 
1402         // Clear approvals from the previous owner.
1403         assembly {
1404             if approvedAddress {
1405                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1406                 sstore(approvedAddressSlot, 0)
1407             }
1408         }
1409 
1410         // Underflow of the sender's balance is impossible because we check for
1411         // ownership above and the recipient's balance can't realistically overflow.
1412         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1413         unchecked {
1414             // Updates:
1415             // - `balance -= 1`.
1416             // - `numberBurned += 1`.
1417             //
1418             // We can directly decrement the balance, and increment the number burned.
1419             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1420             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1421 
1422             // Updates:
1423             // - `address` to the last owner.
1424             // - `startTimestamp` to the timestamp of burning.
1425             // - `burned` to `true`.
1426             // - `nextInitialized` to `true`.
1427             _packedOwnerships[tokenId] = _packOwnershipData(
1428                 from,
1429                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1430             );
1431 
1432             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1433             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1434                 uint256 nextTokenId = tokenId + 1;
1435                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1436                 if (_packedOwnerships[nextTokenId] == 0) {
1437                     // If the next slot is within bounds.
1438                     if (nextTokenId != _currentIndex) {
1439                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1440                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1441                     }
1442                 }
1443             }
1444         }
1445 
1446         emit Transfer(from, address(0), tokenId);
1447         _afterTokenTransfers(from, address(0), tokenId, 1);
1448 
1449         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1450         unchecked {
1451             _burnCounter++;
1452         }
1453     }
1454 
1455     // =============================================================
1456     //                     EXTRA DATA OPERATIONS
1457     // =============================================================
1458 
1459     /**
1460      * @dev Directly sets the extra data for the ownership data `index`.
1461      */
1462     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1463         uint256 packed = _packedOwnerships[index];
1464         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1465         uint256 extraDataCasted;
1466         // Cast `extraData` with assembly to avoid redundant masking.
1467         assembly {
1468             extraDataCasted := extraData
1469         }
1470         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1471         _packedOwnerships[index] = packed;
1472     }
1473 
1474     /**
1475      * @dev Called during each token transfer to set the 24bit `extraData` field.
1476      * Intended to be overridden by the cosumer contract.
1477      *
1478      * `previousExtraData` - the value of `extraData` before transfer.
1479      *
1480      * Calling conditions:
1481      *
1482      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1483      * transferred to `to`.
1484      * - When `from` is zero, `tokenId` will be minted for `to`.
1485      * - When `to` is zero, `tokenId` will be burned by `from`.
1486      * - `from` and `to` are never both zero.
1487      */
1488     function _extraData(
1489         address from,
1490         address to,
1491         uint24 previousExtraData
1492     ) internal view virtual returns (uint24) {}
1493 
1494     /**
1495      * @dev Returns the next extra data for the packed ownership data.
1496      * The returned result is shifted into position.
1497      */
1498     function _nextExtraData(
1499         address from,
1500         address to,
1501         uint256 prevOwnershipPacked
1502     ) private view returns (uint256) {
1503         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1504         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1505     }
1506 
1507     // =============================================================
1508     //                       OTHER OPERATIONS
1509     // =============================================================
1510 
1511     /**
1512      * @dev Returns the message sender (defaults to `msg.sender`).
1513      *
1514      * If you are writing GSN compatible contracts, you need to override this function.
1515      */
1516     function _msgSenderERC721A() internal view virtual returns (address) {
1517         return msg.sender;
1518     }
1519 
1520     /**
1521      * @dev Converts a uint256 to its ASCII string decimal representation.
1522      */
1523     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1524         assembly {
1525             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1526             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1527             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1528             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1529             let m := add(mload(0x40), 0xa0)
1530             // Update the free memory pointer to allocate.
1531             mstore(0x40, m)
1532             // Assign the `str` to the end.
1533             str := sub(m, 0x20)
1534             // Zeroize the slot after the string.
1535             mstore(str, 0)
1536 
1537             // Cache the end of the memory to calculate the length later.
1538             let end := str
1539 
1540             // We write the string from rightmost digit to leftmost digit.
1541             // The following is essentially a do-while loop that also handles the zero case.
1542             // prettier-ignore
1543             for { let temp := value } 1 {} {
1544                 str := sub(str, 1)
1545                 // Write the character to the pointer.
1546                 // The ASCII index of the '0' character is 48.
1547                 mstore8(str, add(48, mod(temp, 10)))
1548                 // Keep dividing `temp` until zero.
1549                 temp := div(temp, 10)
1550                 // prettier-ignore
1551                 if iszero(temp) { break }
1552             }
1553 
1554             let length := sub(end, str)
1555             // Move the pointer 32 bytes leftwards to make room for the length.
1556             str := sub(str, 0x20)
1557             // Store the length.
1558             mstore(str, length)
1559         }
1560     }
1561 }
1562 
1563 // File: contracts/aciOS.sol
1564 
1565 
1566 
1567 pragma solidity ^0.8.7;
1568 
1569 
1570 
1571 
1572 interface ICreateCards {
1573     function ownerOf(uint256 tokenId) external view returns (address);
1574 }
1575 
1576 contract aciOS is ERC721A, Ownable, ReentrancyGuard {
1577 
1578     address public createCardContract = 0x5e7Dd1e569E75A7C2c1395d625daC3275Dc94012;
1579 
1580     mapping(uint256 => bool) public hasCreateCardMinted;
1581 
1582     bool public MINT_ACTIVE = false;
1583     uint256 public constant MAX_SUPPLY = 6004;
1584     uint256 public constant CREATE_CARD_SUPPLY = 3002;
1585     uint256 public constant PUBLIC_SUPPLY = 3002;
1586     uint256 public publicCount = 0;
1587 
1588     string public metadataURI;
1589     
1590     constructor() ERC721A("aciOS", "ACIOS") {}
1591 
1592     // MINT ---------------------------------------------
1593 
1594     function create_card_mint(uint256 createCardId) public {
1595         require(MINT_ACTIVE, "Mint inactive.");
1596         require(ICreateCards(createCardContract).ownerOf(createCardId) == msg.sender, "You don't own that Create Card.");
1597         require(!hasCreateCardMinted[createCardId], "Already minted.");
1598         require(totalSupply() < MAX_SUPPLY, "Sold out.");
1599 
1600         hasCreateCardMinted[createCardId] = true;
1601 
1602         _safeMint(msg.sender, 1);
1603     }
1604 
1605     function public_mint() public payable nonReentrant {
1606         require(MINT_ACTIVE, "Mint inactive.");
1607         require(msg.value == 0.02 ether, "Incorrect ETH sent.");
1608         require(publicCount < PUBLIC_SUPPLY, "Sold out.");
1609         require(totalSupply() < MAX_SUPPLY, "Sold out.");
1610 
1611         publicCount++;
1612 
1613         _safeMint(msg.sender, 1);
1614     }
1615 
1616     // CONTRACT MANAGEMENT ---------------------------------------------
1617   
1618     function setMetadataURI(string memory _metadataURI) public onlyOwner {
1619         metadataURI = _metadataURI;
1620     }
1621 
1622     function toggleMint() public onlyOwner {
1623         MINT_ACTIVE = !MINT_ACTIVE;
1624     }
1625 
1626     // OVERRIDES ---------------------------------------------
1627 
1628     function _baseURI() internal view override returns (string memory) {
1629         return metadataURI;
1630     }
1631 
1632     // WITHDRAW ---------------------------------------------
1633 
1634     function withdraw() public onlyOwner {
1635       (bool success,) = msg.sender.call{value: address(this).balance}("");
1636       require(success, "Failed to withdraw ETH.");
1637     }
1638 }