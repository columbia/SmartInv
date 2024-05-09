1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Throws if called by any account other than the owner.
128      */
129     modifier onlyOwner() {
130         _checkOwner();
131         _;
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if the sender is not the owner.
143      */
144     function _checkOwner() internal view virtual {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: erc721a/contracts/IERC721A.sol
180 
181 
182 // ERC721A Contracts v4.2.2
183 // Creator: Chiru Labs
184 
185 pragma solidity ^0.8.4;
186 
187 /**
188  * @dev Interface of ERC721A.
189  */
190 interface IERC721A {
191     /**
192      * The caller must own the token or be an approved operator.
193      */
194     error ApprovalCallerNotOwnerNorApproved();
195 
196     /**
197      * The token does not exist.
198      */
199     error ApprovalQueryForNonexistentToken();
200 
201     /**
202      * The caller cannot approve to their own address.
203      */
204     error ApproveToCaller();
205 
206     /**
207      * Cannot query the balance for the zero address.
208      */
209     error BalanceQueryForZeroAddress();
210 
211     /**
212      * Cannot mint to the zero address.
213      */
214     error MintToZeroAddress();
215 
216     /**
217      * The quantity of tokens minted must be more than zero.
218      */
219     error MintZeroQuantity();
220 
221     /**
222      * The token does not exist.
223      */
224     error OwnerQueryForNonexistentToken();
225 
226     /**
227      * The caller must own the token or be an approved operator.
228      */
229     error TransferCallerNotOwnerNorApproved();
230 
231     /**
232      * The token must be owned by `from`.
233      */
234     error TransferFromIncorrectOwner();
235 
236     /**
237      * Cannot safely transfer to a contract that does not implement the
238      * ERC721Receiver interface.
239      */
240     error TransferToNonERC721ReceiverImplementer();
241 
242     /**
243      * Cannot transfer to the zero address.
244      */
245     error TransferToZeroAddress();
246 
247     /**
248      * The token does not exist.
249      */
250     error URIQueryForNonexistentToken();
251 
252     /**
253      * The `quantity` minted with ERC2309 exceeds the safety limit.
254      */
255     error MintERC2309QuantityExceedsLimit();
256 
257     /**
258      * The `extraData` cannot be set on an unintialized ownership slot.
259      */
260     error OwnershipNotInitializedForExtraData();
261 
262     // =============================================================
263     //                            STRUCTS
264     // =============================================================
265 
266     struct TokenOwnership {
267         // The address of the owner.
268         address addr;
269         // Stores the start time of ownership with minimal overhead for tokenomics.
270         uint64 startTimestamp;
271         // Whether the token has been burned.
272         bool burned;
273         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
274         uint24 extraData;
275     }
276 
277     // =============================================================
278     //                         TOKEN COUNTERS
279     // =============================================================
280 
281     /**
282      * @dev Returns the total number of tokens in existence.
283      * Burned tokens will reduce the count.
284      * To get the total number of tokens minted, please see {_totalMinted}.
285      */
286     function totalSupply() external view returns (uint256);
287 
288     // =============================================================
289     //                            IERC165
290     // =============================================================
291 
292     /**
293      * @dev Returns true if this contract implements the interface defined by
294      * `interfaceId`. See the corresponding
295      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
296      * to learn more about how these ids are created.
297      *
298      * This function call must use less than 30000 gas.
299      */
300     function supportsInterface(bytes4 interfaceId) external view returns (bool);
301 
302     // =============================================================
303     //                            IERC721
304     // =============================================================
305 
306     /**
307      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
308      */
309     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
310 
311     /**
312      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
313      */
314     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
315 
316     /**
317      * @dev Emitted when `owner` enables or disables
318      * (`approved`) `operator` to manage all of its assets.
319      */
320     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
321 
322     /**
323      * @dev Returns the number of tokens in `owner`'s account.
324      */
325     function balanceOf(address owner) external view returns (uint256 balance);
326 
327     /**
328      * @dev Returns the owner of the `tokenId` token.
329      *
330      * Requirements:
331      *
332      * - `tokenId` must exist.
333      */
334     function ownerOf(uint256 tokenId) external view returns (address owner);
335 
336     /**
337      * @dev Safely transfers `tokenId` token from `from` to `to`,
338      * checking first that contract recipients are aware of the ERC721 protocol
339      * to prevent tokens from being forever locked.
340      *
341      * Requirements:
342      *
343      * - `from` cannot be the zero address.
344      * - `to` cannot be the zero address.
345      * - `tokenId` token must exist and be owned by `from`.
346      * - If the caller is not `from`, it must be have been allowed to move
347      * this token by either {approve} or {setApprovalForAll}.
348      * - If `to` refers to a smart contract, it must implement
349      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
350      *
351      * Emits a {Transfer} event.
352      */
353     function safeTransferFrom(
354         address from,
355         address to,
356         uint256 tokenId,
357         bytes calldata data
358     ) external;
359 
360     /**
361      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
362      */
363     function safeTransferFrom(
364         address from,
365         address to,
366         uint256 tokenId
367     ) external;
368 
369     /**
370      * @dev Transfers `tokenId` from `from` to `to`.
371      *
372      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
373      * whenever possible.
374      *
375      * Requirements:
376      *
377      * - `from` cannot be the zero address.
378      * - `to` cannot be the zero address.
379      * - `tokenId` token must be owned by `from`.
380      * - If the caller is not `from`, it must be approved to move this token
381      * by either {approve} or {setApprovalForAll}.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transferFrom(
386         address from,
387         address to,
388         uint256 tokenId
389     ) external;
390 
391     /**
392      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
393      * The approval is cleared when the token is transferred.
394      *
395      * Only a single account can be approved at a time, so approving the
396      * zero address clears previous approvals.
397      *
398      * Requirements:
399      *
400      * - The caller must own the token or be an approved operator.
401      * - `tokenId` must exist.
402      *
403      * Emits an {Approval} event.
404      */
405     function approve(address to, uint256 tokenId) external;
406 
407     /**
408      * @dev Approve or remove `operator` as an operator for the caller.
409      * Operators can call {transferFrom} or {safeTransferFrom}
410      * for any token owned by the caller.
411      *
412      * Requirements:
413      *
414      * - The `operator` cannot be the caller.
415      *
416      * Emits an {ApprovalForAll} event.
417      */
418     function setApprovalForAll(address operator, bool _approved) external;
419 
420     /**
421      * @dev Returns the account approved for `tokenId` token.
422      *
423      * Requirements:
424      *
425      * - `tokenId` must exist.
426      */
427     function getApproved(uint256 tokenId) external view returns (address operator);
428 
429     /**
430      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
431      *
432      * See {setApprovalForAll}.
433      */
434     function isApprovedForAll(address owner, address operator) external view returns (bool);
435 
436     // =============================================================
437     //                        IERC721Metadata
438     // =============================================================
439 
440     /**
441      * @dev Returns the token collection name.
442      */
443     function name() external view returns (string memory);
444 
445     /**
446      * @dev Returns the token collection symbol.
447      */
448     function symbol() external view returns (string memory);
449 
450     /**
451      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
452      */
453     function tokenURI(uint256 tokenId) external view returns (string memory);
454 
455     // =============================================================
456     //                           IERC2309
457     // =============================================================
458 
459     /**
460      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
461      * (inclusive) is transferred from `from` to `to`, as defined in the
462      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
463      *
464      * See {_mintERC2309} for more details.
465      */
466     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
467 }
468 
469 // File: erc721a/contracts/ERC721A.sol
470 
471 
472 // ERC721A Contracts v4.2.2
473 // Creator: Chiru Labs
474 
475 pragma solidity ^0.8.4;
476 
477 
478 /**
479  * @dev Interface of ERC721 token receiver.
480  */
481 interface ERC721A__IERC721Receiver {
482     function onERC721Received(
483         address operator,
484         address from,
485         uint256 tokenId,
486         bytes calldata data
487     ) external returns (bytes4);
488 }
489 
490 /**
491  * @title ERC721A
492  *
493  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
494  * Non-Fungible Token Standard, including the Metadata extension.
495  * Optimized for lower gas during batch mints.
496  *
497  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
498  * starting from `_startTokenId()`.
499  *
500  * Assumptions:
501  *
502  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
503  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
504  */
505 contract ERC721A is IERC721A {
506     // Reference type for token approval.
507     struct TokenApprovalRef {
508         address value;
509     }
510 
511     // =============================================================
512     //                           CONSTANTS
513     // =============================================================
514 
515     // Mask of an entry in packed address data.
516     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
517 
518     // The bit position of `numberMinted` in packed address data.
519     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
520 
521     // The bit position of `numberBurned` in packed address data.
522     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
523 
524     // The bit position of `aux` in packed address data.
525     uint256 private constant _BITPOS_AUX = 192;
526 
527     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
528     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
529 
530     // The bit position of `startTimestamp` in packed ownership.
531     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
532 
533     // The bit mask of the `burned` bit in packed ownership.
534     uint256 private constant _BITMASK_BURNED = 1 << 224;
535 
536     // The bit position of the `nextInitialized` bit in packed ownership.
537     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
538 
539     // The bit mask of the `nextInitialized` bit in packed ownership.
540     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
541 
542     // The bit position of `extraData` in packed ownership.
543     uint256 private constant _BITPOS_EXTRA_DATA = 232;
544 
545     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
546     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
547 
548     // The mask of the lower 160 bits for addresses.
549     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
550 
551     // The maximum `quantity` that can be minted with {_mintERC2309}.
552     // This limit is to prevent overflows on the address data entries.
553     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
554     // is required to cause an overflow, which is unrealistic.
555     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
556 
557     // The `Transfer` event signature is given by:
558     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
559     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
560         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
561 
562     // =============================================================
563     //                            STORAGE
564     // =============================================================
565 
566     // The next token ID to be minted.
567     uint256 private _currentIndex;
568 
569     // The number of tokens burned.
570     uint256 private _burnCounter;
571 
572     // Token name
573     string private _name;
574 
575     // Token symbol
576     string private _symbol;
577 
578     // Mapping from token ID to ownership details
579     // An empty struct value does not necessarily mean the token is unowned.
580     // See {_packedOwnershipOf} implementation for details.
581     //
582     // Bits Layout:
583     // - [0..159]   `addr`
584     // - [160..223] `startTimestamp`
585     // - [224]      `burned`
586     // - [225]      `nextInitialized`
587     // - [232..255] `extraData`
588     mapping(uint256 => uint256) private _packedOwnerships;
589 
590     // Mapping owner address to address data.
591     //
592     // Bits Layout:
593     // - [0..63]    `balance`
594     // - [64..127]  `numberMinted`
595     // - [128..191] `numberBurned`
596     // - [192..255] `aux`
597     mapping(address => uint256) private _packedAddressData;
598 
599     // Mapping from token ID to approved address.
600     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
601 
602     // Mapping from owner to operator approvals
603     mapping(address => mapping(address => bool)) private _operatorApprovals;
604 
605     // =============================================================
606     //                          CONSTRUCTOR
607     // =============================================================
608 
609     constructor(string memory name_, string memory symbol_) {
610         _name = name_;
611         _symbol = symbol_;
612         _currentIndex = _startTokenId();
613     }
614 
615     // =============================================================
616     //                   TOKEN COUNTING OPERATIONS
617     // =============================================================
618 
619     /**
620      * @dev Returns the starting token ID.
621      * To change the starting token ID, please override this function.
622      */
623     function _startTokenId() internal view virtual returns (uint256) {
624         return 0;
625     }
626 
627     /**
628      * @dev Returns the next token ID to be minted.
629      */
630     function _nextTokenId() internal view virtual returns (uint256) {
631         return _currentIndex;
632     }
633 
634     /**
635      * @dev Returns the total number of tokens in existence.
636      * Burned tokens will reduce the count.
637      * To get the total number of tokens minted, please see {_totalMinted}.
638      */
639     function totalSupply() public view virtual override returns (uint256) {
640         // Counter underflow is impossible as _burnCounter cannot be incremented
641         // more than `_currentIndex - _startTokenId()` times.
642         unchecked {
643             return _currentIndex - _burnCounter - _startTokenId();
644         }
645     }
646 
647     /**
648      * @dev Returns the total amount of tokens minted in the contract.
649      */
650     function _totalMinted() internal view virtual returns (uint256) {
651         // Counter underflow is impossible as `_currentIndex` does not decrement,
652         // and it is initialized to `_startTokenId()`.
653         unchecked {
654             return _currentIndex - _startTokenId();
655         }
656     }
657 
658     /**
659      * @dev Returns the total number of tokens burned.
660      */
661     function _totalBurned() internal view virtual returns (uint256) {
662         return _burnCounter;
663     }
664 
665     // =============================================================
666     //                    ADDRESS DATA OPERATIONS
667     // =============================================================
668 
669     /**
670      * @dev Returns the number of tokens in `owner`'s account.
671      */
672     function balanceOf(address owner) public view virtual override returns (uint256) {
673         if (owner == address(0)) revert BalanceQueryForZeroAddress();
674         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
675     }
676 
677     /**
678      * Returns the number of tokens minted by `owner`.
679      */
680     function _numberMinted(address owner) internal view returns (uint256) {
681         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
682     }
683 
684     /**
685      * Returns the number of tokens burned by or on behalf of `owner`.
686      */
687     function _numberBurned(address owner) internal view returns (uint256) {
688         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
689     }
690 
691     /**
692      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
693      */
694     function _getAux(address owner) internal view returns (uint64) {
695         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
696     }
697 
698     /**
699      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
700      * If there are multiple variables, please pack them into a uint64.
701      */
702     function _setAux(address owner, uint64 aux) internal virtual {
703         uint256 packed = _packedAddressData[owner];
704         uint256 auxCasted;
705         // Cast `aux` with assembly to avoid redundant masking.
706         assembly {
707             auxCasted := aux
708         }
709         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
710         _packedAddressData[owner] = packed;
711     }
712 
713     // =============================================================
714     //                            IERC165
715     // =============================================================
716 
717     /**
718      * @dev Returns true if this contract implements the interface defined by
719      * `interfaceId`. See the corresponding
720      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
721      * to learn more about how these ids are created.
722      *
723      * This function call must use less than 30000 gas.
724      */
725     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
726         // The interface IDs are constants representing the first 4 bytes
727         // of the XOR of all function selectors in the interface.
728         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
729         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
730         return
731             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
732             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
733             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
734     }
735 
736     // =============================================================
737     //                        IERC721Metadata
738     // =============================================================
739 
740     /**
741      * @dev Returns the token collection name.
742      */
743     function name() public view virtual override returns (string memory) {
744         return _name;
745     }
746 
747     /**
748      * @dev Returns the token collection symbol.
749      */
750     function symbol() public view virtual override returns (string memory) {
751         return _symbol;
752     }
753 
754     /**
755      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
756      */
757     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
758         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
759 
760         string memory baseURI = _baseURI();
761         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
762     }
763 
764     /**
765      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
766      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
767      * by default, it can be overridden in child contracts.
768      */
769     function _baseURI() internal view virtual returns (string memory) {
770         return '';
771     }
772 
773     // =============================================================
774     //                     OWNERSHIPS OPERATIONS
775     // =============================================================
776 
777     /**
778      * @dev Returns the owner of the `tokenId` token.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      */
784     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
785         return address(uint160(_packedOwnershipOf(tokenId)));
786     }
787 
788     /**
789      * @dev Gas spent here starts off proportional to the maximum mint batch size.
790      * It gradually moves to O(1) as tokens get transferred around over time.
791      */
792     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
793         return _unpackedOwnership(_packedOwnershipOf(tokenId));
794     }
795 
796     /**
797      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
798      */
799     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
800         return _unpackedOwnership(_packedOwnerships[index]);
801     }
802 
803     /**
804      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
805      */
806     function _initializeOwnershipAt(uint256 index) internal virtual {
807         if (_packedOwnerships[index] == 0) {
808             _packedOwnerships[index] = _packedOwnershipOf(index);
809         }
810     }
811 
812     /**
813      * Returns the packed ownership data of `tokenId`.
814      */
815     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
816         uint256 curr = tokenId;
817 
818         unchecked {
819             if (_startTokenId() <= curr)
820                 if (curr < _currentIndex) {
821                     uint256 packed = _packedOwnerships[curr];
822                     // If not burned.
823                     if (packed & _BITMASK_BURNED == 0) {
824                         // Invariant:
825                         // There will always be an initialized ownership slot
826                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
827                         // before an unintialized ownership slot
828                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
829                         // Hence, `curr` will not underflow.
830                         //
831                         // We can directly compare the packed value.
832                         // If the address is zero, packed will be zero.
833                         while (packed == 0) {
834                             packed = _packedOwnerships[--curr];
835                         }
836                         return packed;
837                     }
838                 }
839         }
840         revert OwnerQueryForNonexistentToken();
841     }
842 
843     /**
844      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
845      */
846     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
847         ownership.addr = address(uint160(packed));
848         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
849         ownership.burned = packed & _BITMASK_BURNED != 0;
850         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
851     }
852 
853     /**
854      * @dev Packs ownership data into a single uint256.
855      */
856     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
857         assembly {
858             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
859             owner := and(owner, _BITMASK_ADDRESS)
860             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
861             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
862         }
863     }
864 
865     /**
866      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
867      */
868     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
869         // For branchless setting of the `nextInitialized` flag.
870         assembly {
871             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
872             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
873         }
874     }
875 
876     // =============================================================
877     //                      APPROVAL OPERATIONS
878     // =============================================================
879 
880     /**
881      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
882      * The approval is cleared when the token is transferred.
883      *
884      * Only a single account can be approved at a time, so approving the
885      * zero address clears previous approvals.
886      *
887      * Requirements:
888      *
889      * - The caller must own the token or be an approved operator.
890      * - `tokenId` must exist.
891      *
892      * Emits an {Approval} event.
893      */
894     function approve(address to, uint256 tokenId) public virtual override {
895         address owner = ownerOf(tokenId);
896 
897         if (_msgSenderERC721A() != owner)
898             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
899                 revert ApprovalCallerNotOwnerNorApproved();
900             }
901 
902         _tokenApprovals[tokenId].value = to;
903         emit Approval(owner, to, tokenId);
904     }
905 
906     /**
907      * @dev Returns the account approved for `tokenId` token.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must exist.
912      */
913     function getApproved(uint256 tokenId) public view virtual override returns (address) {
914         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
915 
916         return _tokenApprovals[tokenId].value;
917     }
918 
919     /**
920      * @dev Approve or remove `operator` as an operator for the caller.
921      * Operators can call {transferFrom} or {safeTransferFrom}
922      * for any token owned by the caller.
923      *
924      * Requirements:
925      *
926      * - The `operator` cannot be the caller.
927      *
928      * Emits an {ApprovalForAll} event.
929      */
930     function setApprovalForAll(address operator, bool approved) public virtual override {
931         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
932 
933         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
934         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
935     }
936 
937     /**
938      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
939      *
940      * See {setApprovalForAll}.
941      */
942     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
943         return _operatorApprovals[owner][operator];
944     }
945 
946     /**
947      * @dev Returns whether `tokenId` exists.
948      *
949      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
950      *
951      * Tokens start existing when they are minted. See {_mint}.
952      */
953     function _exists(uint256 tokenId) internal view virtual returns (bool) {
954         return
955             _startTokenId() <= tokenId &&
956             tokenId < _currentIndex && // If within bounds,
957             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
958     }
959 
960     /**
961      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
962      */
963     function _isSenderApprovedOrOwner(
964         address approvedAddress,
965         address owner,
966         address msgSender
967     ) private pure returns (bool result) {
968         assembly {
969             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
970             owner := and(owner, _BITMASK_ADDRESS)
971             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
972             msgSender := and(msgSender, _BITMASK_ADDRESS)
973             // `msgSender == owner || msgSender == approvedAddress`.
974             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
975         }
976     }
977 
978     /**
979      * @dev Returns the storage slot and value for the approved address of `tokenId`.
980      */
981     function _getApprovedSlotAndAddress(uint256 tokenId)
982         private
983         view
984         returns (uint256 approvedAddressSlot, address approvedAddress)
985     {
986         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
987         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
988         assembly {
989             approvedAddressSlot := tokenApproval.slot
990             approvedAddress := sload(approvedAddressSlot)
991         }
992     }
993 
994     // =============================================================
995     //                      TRANSFER OPERATIONS
996     // =============================================================
997 
998     /**
999      * @dev Transfers `tokenId` from `from` to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `from` cannot be the zero address.
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must be owned by `from`.
1006      * - If the caller is not `from`, it must be approved to move this token
1007      * by either {approve} or {setApprovalForAll}.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function transferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) public virtual override {
1016         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1017 
1018         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1019 
1020         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1021 
1022         // The nested ifs save around 20+ gas over a compound boolean condition.
1023         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1024             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1025 
1026         if (to == address(0)) revert TransferToZeroAddress();
1027 
1028         _beforeTokenTransfers(from, to, tokenId, 1);
1029 
1030         // Clear approvals from the previous owner.
1031         assembly {
1032             if approvedAddress {
1033                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1034                 sstore(approvedAddressSlot, 0)
1035             }
1036         }
1037 
1038         // Underflow of the sender's balance is impossible because we check for
1039         // ownership above and the recipient's balance can't realistically overflow.
1040         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1041         unchecked {
1042             // We can directly increment and decrement the balances.
1043             --_packedAddressData[from]; // Updates: `balance -= 1`.
1044             ++_packedAddressData[to]; // Updates: `balance += 1`.
1045 
1046             // Updates:
1047             // - `address` to the next owner.
1048             // - `startTimestamp` to the timestamp of transfering.
1049             // - `burned` to `false`.
1050             // - `nextInitialized` to `true`.
1051             _packedOwnerships[tokenId] = _packOwnershipData(
1052                 to,
1053                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1054             );
1055 
1056             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1057             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1058                 uint256 nextTokenId = tokenId + 1;
1059                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1060                 if (_packedOwnerships[nextTokenId] == 0) {
1061                     // If the next slot is within bounds.
1062                     if (nextTokenId != _currentIndex) {
1063                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1064                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1065                     }
1066                 }
1067             }
1068         }
1069 
1070         emit Transfer(from, to, tokenId);
1071         _afterTokenTransfers(from, to, tokenId, 1);
1072     }
1073 
1074     /**
1075      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) public virtual override {
1082         safeTransferFrom(from, to, tokenId, '');
1083     }
1084 
1085     /**
1086      * @dev Safely transfers `tokenId` token from `from` to `to`.
1087      *
1088      * Requirements:
1089      *
1090      * - `from` cannot be the zero address.
1091      * - `to` cannot be the zero address.
1092      * - `tokenId` token must exist and be owned by `from`.
1093      * - If the caller is not `from`, it must be approved to move this token
1094      * by either {approve} or {setApprovalForAll}.
1095      * - If `to` refers to a smart contract, it must implement
1096      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) public virtual override {
1106         transferFrom(from, to, tokenId);
1107         if (to.code.length != 0)
1108             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1109                 revert TransferToNonERC721ReceiverImplementer();
1110             }
1111     }
1112 
1113     /**
1114      * @dev Hook that is called before a set of serially-ordered token IDs
1115      * are about to be transferred. This includes minting.
1116      * And also called before burning one token.
1117      *
1118      * `startTokenId` - the first token ID to be transferred.
1119      * `quantity` - the amount to be transferred.
1120      *
1121      * Calling conditions:
1122      *
1123      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1124      * transferred to `to`.
1125      * - When `from` is zero, `tokenId` will be minted for `to`.
1126      * - When `to` is zero, `tokenId` will be burned by `from`.
1127      * - `from` and `to` are never both zero.
1128      */
1129     function _beforeTokenTransfers(
1130         address from,
1131         address to,
1132         uint256 startTokenId,
1133         uint256 quantity
1134     ) internal virtual {}
1135 
1136     /**
1137      * @dev Hook that is called after a set of serially-ordered token IDs
1138      * have been transferred. This includes minting.
1139      * And also called after one token has been burned.
1140      *
1141      * `startTokenId` - the first token ID to be transferred.
1142      * `quantity` - the amount to be transferred.
1143      *
1144      * Calling conditions:
1145      *
1146      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1147      * transferred to `to`.
1148      * - When `from` is zero, `tokenId` has been minted for `to`.
1149      * - When `to` is zero, `tokenId` has been burned by `from`.
1150      * - `from` and `to` are never both zero.
1151      */
1152     function _afterTokenTransfers(
1153         address from,
1154         address to,
1155         uint256 startTokenId,
1156         uint256 quantity
1157     ) internal virtual {}
1158 
1159     /**
1160      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1161      *
1162      * `from` - Previous owner of the given token ID.
1163      * `to` - Target address that will receive the token.
1164      * `tokenId` - Token ID to be transferred.
1165      * `_data` - Optional data to send along with the call.
1166      *
1167      * Returns whether the call correctly returned the expected magic value.
1168      */
1169     function _checkContractOnERC721Received(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) private returns (bool) {
1175         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1176             bytes4 retval
1177         ) {
1178             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1179         } catch (bytes memory reason) {
1180             if (reason.length == 0) {
1181                 revert TransferToNonERC721ReceiverImplementer();
1182             } else {
1183                 assembly {
1184                     revert(add(32, reason), mload(reason))
1185                 }
1186             }
1187         }
1188     }
1189 
1190     // =============================================================
1191     //                        MINT OPERATIONS
1192     // =============================================================
1193 
1194     /**
1195      * @dev Mints `quantity` tokens and transfers them to `to`.
1196      *
1197      * Requirements:
1198      *
1199      * - `to` cannot be the zero address.
1200      * - `quantity` must be greater than 0.
1201      *
1202      * Emits a {Transfer} event for each mint.
1203      */
1204     function _mint(address to, uint256 quantity) internal virtual {
1205         uint256 startTokenId = _currentIndex;
1206         if (quantity == 0) revert MintZeroQuantity();
1207 
1208         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1209 
1210         // Overflows are incredibly unrealistic.
1211         // `balance` and `numberMinted` have a maximum limit of 2**64.
1212         // `tokenId` has a maximum limit of 2**256.
1213         unchecked {
1214             // Updates:
1215             // - `balance += quantity`.
1216             // - `numberMinted += quantity`.
1217             //
1218             // We can directly add to the `balance` and `numberMinted`.
1219             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1220 
1221             // Updates:
1222             // - `address` to the owner.
1223             // - `startTimestamp` to the timestamp of minting.
1224             // - `burned` to `false`.
1225             // - `nextInitialized` to `quantity == 1`.
1226             _packedOwnerships[startTokenId] = _packOwnershipData(
1227                 to,
1228                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1229             );
1230 
1231             uint256 toMasked;
1232             uint256 end = startTokenId + quantity;
1233 
1234             // Use assembly to loop and emit the `Transfer` event for gas savings.
1235             assembly {
1236                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1237                 toMasked := and(to, _BITMASK_ADDRESS)
1238                 // Emit the `Transfer` event.
1239                 log4(
1240                     0, // Start of data (0, since no data).
1241                     0, // End of data (0, since no data).
1242                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1243                     0, // `address(0)`.
1244                     toMasked, // `to`.
1245                     startTokenId // `tokenId`.
1246                 )
1247 
1248                 for {
1249                     let tokenId := add(startTokenId, 1)
1250                 } iszero(eq(tokenId, end)) {
1251                     tokenId := add(tokenId, 1)
1252                 } {
1253                     // Emit the `Transfer` event. Similar to above.
1254                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1255                 }
1256             }
1257             if (toMasked == 0) revert MintToZeroAddress();
1258 
1259             _currentIndex = end;
1260         }
1261         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1262     }
1263 
1264     /**
1265      * @dev Mints `quantity` tokens and transfers them to `to`.
1266      *
1267      * This function is intended for efficient minting only during contract creation.
1268      *
1269      * It emits only one {ConsecutiveTransfer} as defined in
1270      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1271      * instead of a sequence of {Transfer} event(s).
1272      *
1273      * Calling this function outside of contract creation WILL make your contract
1274      * non-compliant with the ERC721 standard.
1275      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1276      * {ConsecutiveTransfer} event is only permissible during contract creation.
1277      *
1278      * Requirements:
1279      *
1280      * - `to` cannot be the zero address.
1281      * - `quantity` must be greater than 0.
1282      *
1283      * Emits a {ConsecutiveTransfer} event.
1284      */
1285     function _mintERC2309(address to, uint256 quantity) internal virtual {
1286         uint256 startTokenId = _currentIndex;
1287         if (to == address(0)) revert MintToZeroAddress();
1288         if (quantity == 0) revert MintZeroQuantity();
1289         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1290 
1291         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1292 
1293         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1294         unchecked {
1295             // Updates:
1296             // - `balance += quantity`.
1297             // - `numberMinted += quantity`.
1298             //
1299             // We can directly add to the `balance` and `numberMinted`.
1300             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1301 
1302             // Updates:
1303             // - `address` to the owner.
1304             // - `startTimestamp` to the timestamp of minting.
1305             // - `burned` to `false`.
1306             // - `nextInitialized` to `quantity == 1`.
1307             _packedOwnerships[startTokenId] = _packOwnershipData(
1308                 to,
1309                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1310             );
1311 
1312             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1313 
1314             _currentIndex = startTokenId + quantity;
1315         }
1316         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1317     }
1318 
1319     /**
1320      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1321      *
1322      * Requirements:
1323      *
1324      * - If `to` refers to a smart contract, it must implement
1325      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1326      * - `quantity` must be greater than 0.
1327      *
1328      * See {_mint}.
1329      *
1330      * Emits a {Transfer} event for each mint.
1331      */
1332     function _safeMint(
1333         address to,
1334         uint256 quantity,
1335         bytes memory _data
1336     ) internal virtual {
1337         _mint(to, quantity);
1338 
1339         unchecked {
1340             if (to.code.length != 0) {
1341                 uint256 end = _currentIndex;
1342                 uint256 index = end - quantity;
1343                 do {
1344                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1345                         revert TransferToNonERC721ReceiverImplementer();
1346                     }
1347                 } while (index < end);
1348                 // Reentrancy protection.
1349                 if (_currentIndex != end) revert();
1350             }
1351         }
1352     }
1353 
1354     /**
1355      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1356      */
1357     function _safeMint(address to, uint256 quantity) internal virtual {
1358         _safeMint(to, quantity, '');
1359     }
1360 
1361     // =============================================================
1362     //                        BURN OPERATIONS
1363     // =============================================================
1364 
1365     /**
1366      * @dev Equivalent to `_burn(tokenId, false)`.
1367      */
1368     function _burn(uint256 tokenId) internal virtual {
1369         _burn(tokenId, false);
1370     }
1371 
1372     /**
1373      * @dev Destroys `tokenId`.
1374      * The approval is cleared when the token is burned.
1375      *
1376      * Requirements:
1377      *
1378      * - `tokenId` must exist.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1383         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1384 
1385         address from = address(uint160(prevOwnershipPacked));
1386 
1387         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1388 
1389         if (approvalCheck) {
1390             // The nested ifs save around 20+ gas over a compound boolean condition.
1391             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1392                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1393         }
1394 
1395         _beforeTokenTransfers(from, address(0), tokenId, 1);
1396 
1397         // Clear approvals from the previous owner.
1398         assembly {
1399             if approvedAddress {
1400                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1401                 sstore(approvedAddressSlot, 0)
1402             }
1403         }
1404 
1405         // Underflow of the sender's balance is impossible because we check for
1406         // ownership above and the recipient's balance can't realistically overflow.
1407         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1408         unchecked {
1409             // Updates:
1410             // - `balance -= 1`.
1411             // - `numberBurned += 1`.
1412             //
1413             // We can directly decrement the balance, and increment the number burned.
1414             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1415             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1416 
1417             // Updates:
1418             // - `address` to the last owner.
1419             // - `startTimestamp` to the timestamp of burning.
1420             // - `burned` to `true`.
1421             // - `nextInitialized` to `true`.
1422             _packedOwnerships[tokenId] = _packOwnershipData(
1423                 from,
1424                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1425             );
1426 
1427             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1428             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1429                 uint256 nextTokenId = tokenId + 1;
1430                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1431                 if (_packedOwnerships[nextTokenId] == 0) {
1432                     // If the next slot is within bounds.
1433                     if (nextTokenId != _currentIndex) {
1434                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1435                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1436                     }
1437                 }
1438             }
1439         }
1440 
1441         emit Transfer(from, address(0), tokenId);
1442         _afterTokenTransfers(from, address(0), tokenId, 1);
1443 
1444         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1445         unchecked {
1446             _burnCounter++;
1447         }
1448     }
1449 
1450     // =============================================================
1451     //                     EXTRA DATA OPERATIONS
1452     // =============================================================
1453 
1454     /**
1455      * @dev Directly sets the extra data for the ownership data `index`.
1456      */
1457     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1458         uint256 packed = _packedOwnerships[index];
1459         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1460         uint256 extraDataCasted;
1461         // Cast `extraData` with assembly to avoid redundant masking.
1462         assembly {
1463             extraDataCasted := extraData
1464         }
1465         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1466         _packedOwnerships[index] = packed;
1467     }
1468 
1469     /**
1470      * @dev Called during each token transfer to set the 24bit `extraData` field.
1471      * Intended to be overridden by the cosumer contract.
1472      *
1473      * `previousExtraData` - the value of `extraData` before transfer.
1474      *
1475      * Calling conditions:
1476      *
1477      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1478      * transferred to `to`.
1479      * - When `from` is zero, `tokenId` will be minted for `to`.
1480      * - When `to` is zero, `tokenId` will be burned by `from`.
1481      * - `from` and `to` are never both zero.
1482      */
1483     function _extraData(
1484         address from,
1485         address to,
1486         uint24 previousExtraData
1487     ) internal view virtual returns (uint24) {}
1488 
1489     /**
1490      * @dev Returns the next extra data for the packed ownership data.
1491      * The returned result is shifted into position.
1492      */
1493     function _nextExtraData(
1494         address from,
1495         address to,
1496         uint256 prevOwnershipPacked
1497     ) private view returns (uint256) {
1498         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1499         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1500     }
1501 
1502     // =============================================================
1503     //                       OTHER OPERATIONS
1504     // =============================================================
1505 
1506     /**
1507      * @dev Returns the message sender (defaults to `msg.sender`).
1508      *
1509      * If you are writing GSN compatible contracts, you need to override this function.
1510      */
1511     function _msgSenderERC721A() internal view virtual returns (address) {
1512         return msg.sender;
1513     }
1514 
1515     /**
1516      * @dev Converts a uint256 to its ASCII string decimal representation.
1517      */
1518     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1519         assembly {
1520             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1521             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1522             // We will need 1 32-byte word to store the length,
1523             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1524             str := add(mload(0x40), 0x80)
1525             // Update the free memory pointer to allocate.
1526             mstore(0x40, str)
1527 
1528             // Cache the end of the memory to calculate the length later.
1529             let end := str
1530 
1531             // We write the string from rightmost digit to leftmost digit.
1532             // The following is essentially a do-while loop that also handles the zero case.
1533             // prettier-ignore
1534             for { let temp := value } 1 {} {
1535                 str := sub(str, 1)
1536                 // Write the character to the pointer.
1537                 // The ASCII index of the '0' character is 48.
1538                 mstore8(str, add(48, mod(temp, 10)))
1539                 // Keep dividing `temp` until zero.
1540                 temp := div(temp, 10)
1541                 // prettier-ignore
1542                 if iszero(temp) { break }
1543             }
1544 
1545             let length := sub(end, str)
1546             // Move the pointer 32 bytes leftwards to make room for the length.
1547             str := sub(str, 0x20)
1548             // Store the length.
1549             mstore(str, length)
1550         }
1551     }
1552 }
1553 
1554 // File: contracts/CreateCards.sol
1555 
1556 
1557 
1558 pragma solidity ^0.8.7;
1559 
1560 
1561 
1562 
1563 
1564 interface IVoyagers {
1565     function ownerOf(uint256 tokenId) external view returns (address);
1566 }
1567 
1568 contract CreateCards is ERC721A, Ownable, ReentrancyGuard {
1569 
1570     event CardMinted(uint256 tokenId);
1571     event PointsSpent(uint256 points);
1572 
1573     struct Card {
1574         uint256 savedCredits;
1575         uint256 savedBlock;
1576     }
1577 
1578   mapping(uint256 => Card) public cards;
1579   mapping(address => bool) public isAdmin;
1580   mapping(uint256 => bool) public hasVoyagerMinted;
1581   
1582   address public voyagersContract = 0x4591c791790f352685a29111eca67Abdc878863E;
1583   bool public VOYAGER_MINT_ACTIVE = false;
1584   bool public PUBLIC_MINT_ACTIVE = false;
1585   uint256 public constant MAX_SUPPLY = 10000;
1586 
1587   string public metadataURI;
1588 
1589   constructor() ERC721A("Create Cards", "CREATECARDS") {}
1590 
1591   // MINT ---------------------------------------------
1592 
1593   function voyagerMint(uint256 voyagerId) public {
1594       uint256 tokenId = totalSupply();
1595 
1596       require(VOYAGER_MINT_ACTIVE, "Voyager mint not active.");
1597       require(IVoyagers(voyagersContract).ownerOf(voyagerId) == msg.sender, "You do not own that Voyager.");
1598       require(!hasVoyagerMinted[voyagerId], "Already claimed.");
1599       require(totalSupply() + 1 <= MAX_SUPPLY, "Sold out.");   
1600 
1601       hasVoyagerMinted[voyagerId] = true;  
1602       cards[tokenId].savedBlock = block.number; 
1603       _safeMint(msg.sender, 1);
1604 
1605     emit CardMinted(tokenId);
1606   }
1607 
1608   function publicMint() public payable nonReentrant {
1609       uint256 tokenId = totalSupply();
1610 
1611       require(PUBLIC_MINT_ACTIVE, "Public mint not active.");
1612       require(totalSupply() + 1 <= MAX_SUPPLY, "Sold out.");
1613       require(msg.value == .03 ether, "Incorrect ETH sent.");
1614       
1615       cards[tokenId].savedBlock = block.number; 
1616       _safeMint(msg.sender, 1);
1617 
1618       emit CardMinted(tokenId);
1619   }
1620 
1621   // CREDITS ---------------------------------------------
1622 
1623   function getCredits(uint256 tokenId) public view returns (uint256) {
1624     return block.number - cards[tokenId].savedBlock + cards[tokenId].savedCredits;
1625   }
1626 
1627   function spendCredits(uint256 tokenId, uint256 quantity) public {
1628     uint256 currentCredits = getCredits(tokenId);
1629 
1630     require(msg.sender == ownerOf(tokenId) || isAdmin[msg.sender], "You do not have permission to spend credits.");
1631     require(quantity <= currentCredits, "Not enough credits.");
1632 
1633     cards[tokenId].savedCredits = currentCredits - quantity;
1634     cards[tokenId].savedBlock = block.number;
1635 
1636     emit PointsSpent(quantity);
1637   }
1638 
1639   // CONTRACT MANAGEMENT ---------------------------------------------
1640   
1641   function setMetadataURI(string memory _metadataURI) public onlyOwner {
1642     metadataURI = _metadataURI;
1643   }
1644 
1645   function toggleVoyagerMint() public onlyOwner {
1646     VOYAGER_MINT_ACTIVE = !VOYAGER_MINT_ACTIVE;
1647   }
1648 
1649   function togglePublicMint() public onlyOwner {
1650     PUBLIC_MINT_ACTIVE = !PUBLIC_MINT_ACTIVE;
1651   }
1652 
1653   // ADMIN ---------------------------------------------
1654 
1655   function addAdmin(address _address) public onlyOwner {
1656     isAdmin[_address] = true;
1657   }
1658 
1659   function removeAdmin(address _address) public onlyOwner {
1660     isAdmin[_address] = false;
1661   }
1662 
1663   // OVERRIDES ---------------------------------------------
1664 
1665   function _baseURI() internal view override returns (string memory) {
1666     return metadataURI;
1667   }
1668 
1669   // WITHDRAW ---------------------------------------------
1670 
1671   function withdraw() public onlyOwner {
1672       (bool success,) = msg.sender.call{value: address(this).balance}("");
1673       require(success, "Failed to withdraw ETH.");
1674   }
1675 }