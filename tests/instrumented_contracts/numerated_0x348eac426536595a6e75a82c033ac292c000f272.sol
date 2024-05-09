1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Context.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Provides information about the current execution context, including the
77  * sender of the transaction and its data. While these are generally available
78  * via msg.sender and msg.data, they should not be accessed in such a direct
79  * manner, since when dealing with meta-transactions the account sending and
80  * paying for execution may not be the actual sender (as far as an application
81  * is concerned).
82  *
83  * This contract is only required for intermediate, library-like contracts.
84  */
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89 
90     function _msgData() internal view virtual returns (bytes calldata) {
91         return msg.data;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/access/Ownable.sol
96 
97 
98 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor() {
124         _transferOwnership(_msgSender());
125     }
126 
127     /**
128      * @dev Throws if called by any account other than the owner.
129      */
130     modifier onlyOwner() {
131         _checkOwner();
132         _;
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view virtual returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if the sender is not the owner.
144      */
145     function _checkOwner() internal view virtual {
146         require(owner() == _msgSender(), "Ownable: caller is not the owner");
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Internal function without access restriction.
172      */
173     function _transferOwnership(address newOwner) internal virtual {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 // File: erc721a/contracts/IERC721A.sol
181 
182 
183 // ERC721A Contracts v4.2.2
184 // Creator: Chiru Labs
185 
186 pragma solidity ^0.8.4;
187 
188 /**
189  * @dev Interface of ERC721A.
190  */
191 interface IERC721A {
192     /**
193      * The caller must own the token or be an approved operator.
194      */
195     error ApprovalCallerNotOwnerNorApproved();
196 
197     /**
198      * The token does not exist.
199      */
200     error ApprovalQueryForNonexistentToken();
201 
202     /**
203      * The caller cannot approve to their own address.
204      */
205     error ApproveToCaller();
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
359     ) external;
360 
361     /**
362      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
363      */
364     function safeTransferFrom(
365         address from,
366         address to,
367         uint256 tokenId
368     ) external;
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
390     ) external;
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
406     function approve(address to, uint256 tokenId) external;
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
473 // ERC721A Contracts v4.2.2
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
507     // Reference type for token approval.
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
895     function approve(address to, uint256 tokenId) public virtual override {
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
932         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
933 
934         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
935         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
936     }
937 
938     /**
939      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
940      *
941      * See {setApprovalForAll}.
942      */
943     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
944         return _operatorApprovals[owner][operator];
945     }
946 
947     /**
948      * @dev Returns whether `tokenId` exists.
949      *
950      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
951      *
952      * Tokens start existing when they are minted. See {_mint}.
953      */
954     function _exists(uint256 tokenId) internal view virtual returns (bool) {
955         return
956             _startTokenId() <= tokenId &&
957             tokenId < _currentIndex && // If within bounds,
958             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
959     }
960 
961     /**
962      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
963      */
964     function _isSenderApprovedOrOwner(
965         address approvedAddress,
966         address owner,
967         address msgSender
968     ) private pure returns (bool result) {
969         assembly {
970             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
971             owner := and(owner, _BITMASK_ADDRESS)
972             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
973             msgSender := and(msgSender, _BITMASK_ADDRESS)
974             // `msgSender == owner || msgSender == approvedAddress`.
975             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
976         }
977     }
978 
979     /**
980      * @dev Returns the storage slot and value for the approved address of `tokenId`.
981      */
982     function _getApprovedSlotAndAddress(uint256 tokenId)
983         private
984         view
985         returns (uint256 approvedAddressSlot, address approvedAddress)
986     {
987         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
988         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
989         assembly {
990             approvedAddressSlot := tokenApproval.slot
991             approvedAddress := sload(approvedAddressSlot)
992         }
993     }
994 
995     // =============================================================
996     //                      TRANSFER OPERATIONS
997     // =============================================================
998 
999     /**
1000      * @dev Transfers `tokenId` from `from` to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must be owned by `from`.
1007      * - If the caller is not `from`, it must be approved to move this token
1008      * by either {approve} or {setApprovalForAll}.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function transferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1018 
1019         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1020 
1021         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1022 
1023         // The nested ifs save around 20+ gas over a compound boolean condition.
1024         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1025             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1026 
1027         if (to == address(0)) revert TransferToZeroAddress();
1028 
1029         _beforeTokenTransfers(from, to, tokenId, 1);
1030 
1031         // Clear approvals from the previous owner.
1032         assembly {
1033             if approvedAddress {
1034                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1035                 sstore(approvedAddressSlot, 0)
1036             }
1037         }
1038 
1039         // Underflow of the sender's balance is impossible because we check for
1040         // ownership above and the recipient's balance can't realistically overflow.
1041         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1042         unchecked {
1043             // We can directly increment and decrement the balances.
1044             --_packedAddressData[from]; // Updates: `balance -= 1`.
1045             ++_packedAddressData[to]; // Updates: `balance += 1`.
1046 
1047             // Updates:
1048             // - `address` to the next owner.
1049             // - `startTimestamp` to the timestamp of transfering.
1050             // - `burned` to `false`.
1051             // - `nextInitialized` to `true`.
1052             _packedOwnerships[tokenId] = _packOwnershipData(
1053                 to,
1054                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1055             );
1056 
1057             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1058             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1059                 uint256 nextTokenId = tokenId + 1;
1060                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1061                 if (_packedOwnerships[nextTokenId] == 0) {
1062                     // If the next slot is within bounds.
1063                     if (nextTokenId != _currentIndex) {
1064                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1065                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1066                     }
1067                 }
1068             }
1069         }
1070 
1071         emit Transfer(from, to, tokenId);
1072         _afterTokenTransfers(from, to, tokenId, 1);
1073     }
1074 
1075     /**
1076      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) public virtual override {
1083         safeTransferFrom(from, to, tokenId, '');
1084     }
1085 
1086     /**
1087      * @dev Safely transfers `tokenId` token from `from` to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `from` cannot be the zero address.
1092      * - `to` cannot be the zero address.
1093      * - `tokenId` token must exist and be owned by `from`.
1094      * - If the caller is not `from`, it must be approved to move this token
1095      * by either {approve} or {setApprovalForAll}.
1096      * - If `to` refers to a smart contract, it must implement
1097      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function safeTransferFrom(
1102         address from,
1103         address to,
1104         uint256 tokenId,
1105         bytes memory _data
1106     ) public virtual override {
1107         transferFrom(from, to, tokenId);
1108         if (to.code.length != 0)
1109             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1110                 revert TransferToNonERC721ReceiverImplementer();
1111             }
1112     }
1113 
1114     /**
1115      * @dev Hook that is called before a set of serially-ordered token IDs
1116      * are about to be transferred. This includes minting.
1117      * And also called before burning one token.
1118      *
1119      * `startTokenId` - the first token ID to be transferred.
1120      * `quantity` - the amount to be transferred.
1121      *
1122      * Calling conditions:
1123      *
1124      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1125      * transferred to `to`.
1126      * - When `from` is zero, `tokenId` will be minted for `to`.
1127      * - When `to` is zero, `tokenId` will be burned by `from`.
1128      * - `from` and `to` are never both zero.
1129      */
1130     function _beforeTokenTransfers(
1131         address from,
1132         address to,
1133         uint256 startTokenId,
1134         uint256 quantity
1135     ) internal virtual {}
1136 
1137     /**
1138      * @dev Hook that is called after a set of serially-ordered token IDs
1139      * have been transferred. This includes minting.
1140      * And also called after one token has been burned.
1141      *
1142      * `startTokenId` - the first token ID to be transferred.
1143      * `quantity` - the amount to be transferred.
1144      *
1145      * Calling conditions:
1146      *
1147      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1148      * transferred to `to`.
1149      * - When `from` is zero, `tokenId` has been minted for `to`.
1150      * - When `to` is zero, `tokenId` has been burned by `from`.
1151      * - `from` and `to` are never both zero.
1152      */
1153     function _afterTokenTransfers(
1154         address from,
1155         address to,
1156         uint256 startTokenId,
1157         uint256 quantity
1158     ) internal virtual {}
1159 
1160     /**
1161      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1162      *
1163      * `from` - Previous owner of the given token ID.
1164      * `to` - Target address that will receive the token.
1165      * `tokenId` - Token ID to be transferred.
1166      * `_data` - Optional data to send along with the call.
1167      *
1168      * Returns whether the call correctly returned the expected magic value.
1169      */
1170     function _checkContractOnERC721Received(
1171         address from,
1172         address to,
1173         uint256 tokenId,
1174         bytes memory _data
1175     ) private returns (bool) {
1176         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1177             bytes4 retval
1178         ) {
1179             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1180         } catch (bytes memory reason) {
1181             if (reason.length == 0) {
1182                 revert TransferToNonERC721ReceiverImplementer();
1183             } else {
1184                 assembly {
1185                     revert(add(32, reason), mload(reason))
1186                 }
1187             }
1188         }
1189     }
1190 
1191     // =============================================================
1192     //                        MINT OPERATIONS
1193     // =============================================================
1194 
1195     /**
1196      * @dev Mints `quantity` tokens and transfers them to `to`.
1197      *
1198      * Requirements:
1199      *
1200      * - `to` cannot be the zero address.
1201      * - `quantity` must be greater than 0.
1202      *
1203      * Emits a {Transfer} event for each mint.
1204      */
1205     function _mint(address to, uint256 quantity) internal virtual {
1206         uint256 startTokenId = _currentIndex;
1207         if (quantity == 0) revert MintZeroQuantity();
1208 
1209         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1210 
1211         // Overflows are incredibly unrealistic.
1212         // `balance` and `numberMinted` have a maximum limit of 2**64.
1213         // `tokenId` has a maximum limit of 2**256.
1214         unchecked {
1215             // Updates:
1216             // - `balance += quantity`.
1217             // - `numberMinted += quantity`.
1218             //
1219             // We can directly add to the `balance` and `numberMinted`.
1220             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1221 
1222             // Updates:
1223             // - `address` to the owner.
1224             // - `startTimestamp` to the timestamp of minting.
1225             // - `burned` to `false`.
1226             // - `nextInitialized` to `quantity == 1`.
1227             _packedOwnerships[startTokenId] = _packOwnershipData(
1228                 to,
1229                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1230             );
1231 
1232             uint256 toMasked;
1233             uint256 end = startTokenId + quantity;
1234 
1235             // Use assembly to loop and emit the `Transfer` event for gas savings.
1236             assembly {
1237                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1238                 toMasked := and(to, _BITMASK_ADDRESS)
1239                 // Emit the `Transfer` event.
1240                 log4(
1241                     0, // Start of data (0, since no data).
1242                     0, // End of data (0, since no data).
1243                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1244                     0, // `address(0)`.
1245                     toMasked, // `to`.
1246                     startTokenId // `tokenId`.
1247                 )
1248 
1249                 for {
1250                     let tokenId := add(startTokenId, 1)
1251                 } iszero(eq(tokenId, end)) {
1252                     tokenId := add(tokenId, 1)
1253                 } {
1254                     // Emit the `Transfer` event. Similar to above.
1255                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1256                 }
1257             }
1258             if (toMasked == 0) revert MintToZeroAddress();
1259 
1260             _currentIndex = end;
1261         }
1262         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1263     }
1264 
1265     /**
1266      * @dev Mints `quantity` tokens and transfers them to `to`.
1267      *
1268      * This function is intended for efficient minting only during contract creation.
1269      *
1270      * It emits only one {ConsecutiveTransfer} as defined in
1271      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1272      * instead of a sequence of {Transfer} event(s).
1273      *
1274      * Calling this function outside of contract creation WILL make your contract
1275      * non-compliant with the ERC721 standard.
1276      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1277      * {ConsecutiveTransfer} event is only permissible during contract creation.
1278      *
1279      * Requirements:
1280      *
1281      * - `to` cannot be the zero address.
1282      * - `quantity` must be greater than 0.
1283      *
1284      * Emits a {ConsecutiveTransfer} event.
1285      */
1286     function _mintERC2309(address to, uint256 quantity) internal virtual {
1287         uint256 startTokenId = _currentIndex;
1288         if (to == address(0)) revert MintToZeroAddress();
1289         if (quantity == 0) revert MintZeroQuantity();
1290         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1291 
1292         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1293 
1294         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1295         unchecked {
1296             // Updates:
1297             // - `balance += quantity`.
1298             // - `numberMinted += quantity`.
1299             //
1300             // We can directly add to the `balance` and `numberMinted`.
1301             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1302 
1303             // Updates:
1304             // - `address` to the owner.
1305             // - `startTimestamp` to the timestamp of minting.
1306             // - `burned` to `false`.
1307             // - `nextInitialized` to `quantity == 1`.
1308             _packedOwnerships[startTokenId] = _packOwnershipData(
1309                 to,
1310                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1311             );
1312 
1313             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1314 
1315             _currentIndex = startTokenId + quantity;
1316         }
1317         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1318     }
1319 
1320     /**
1321      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1322      *
1323      * Requirements:
1324      *
1325      * - If `to` refers to a smart contract, it must implement
1326      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1327      * - `quantity` must be greater than 0.
1328      *
1329      * See {_mint}.
1330      *
1331      * Emits a {Transfer} event for each mint.
1332      */
1333     function _safeMint(
1334         address to,
1335         uint256 quantity,
1336         bytes memory _data
1337     ) internal virtual {
1338         _mint(to, quantity);
1339 
1340         unchecked {
1341             if (to.code.length != 0) {
1342                 uint256 end = _currentIndex;
1343                 uint256 index = end - quantity;
1344                 do {
1345                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1346                         revert TransferToNonERC721ReceiverImplementer();
1347                     }
1348                 } while (index < end);
1349                 // Reentrancy protection.
1350                 if (_currentIndex != end) revert();
1351             }
1352         }
1353     }
1354 
1355     /**
1356      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1357      */
1358     function _safeMint(address to, uint256 quantity) internal virtual {
1359         _safeMint(to, quantity, '');
1360     }
1361 
1362     // =============================================================
1363     //                        BURN OPERATIONS
1364     // =============================================================
1365 
1366     /**
1367      * @dev Equivalent to `_burn(tokenId, false)`.
1368      */
1369     function _burn(uint256 tokenId) internal virtual {
1370         _burn(tokenId, false);
1371     }
1372 
1373     /**
1374      * @dev Destroys `tokenId`.
1375      * The approval is cleared when the token is burned.
1376      *
1377      * Requirements:
1378      *
1379      * - `tokenId` must exist.
1380      *
1381      * Emits a {Transfer} event.
1382      */
1383     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1384         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1385 
1386         address from = address(uint160(prevOwnershipPacked));
1387 
1388         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1389 
1390         if (approvalCheck) {
1391             // The nested ifs save around 20+ gas over a compound boolean condition.
1392             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1393                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1394         }
1395 
1396         _beforeTokenTransfers(from, address(0), tokenId, 1);
1397 
1398         // Clear approvals from the previous owner.
1399         assembly {
1400             if approvedAddress {
1401                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1402                 sstore(approvedAddressSlot, 0)
1403             }
1404         }
1405 
1406         // Underflow of the sender's balance is impossible because we check for
1407         // ownership above and the recipient's balance can't realistically overflow.
1408         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1409         unchecked {
1410             // Updates:
1411             // - `balance -= 1`.
1412             // - `numberBurned += 1`.
1413             //
1414             // We can directly decrement the balance, and increment the number burned.
1415             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1416             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1417 
1418             // Updates:
1419             // - `address` to the last owner.
1420             // - `startTimestamp` to the timestamp of burning.
1421             // - `burned` to `true`.
1422             // - `nextInitialized` to `true`.
1423             _packedOwnerships[tokenId] = _packOwnershipData(
1424                 from,
1425                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1426             );
1427 
1428             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1429             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1430                 uint256 nextTokenId = tokenId + 1;
1431                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1432                 if (_packedOwnerships[nextTokenId] == 0) {
1433                     // If the next slot is within bounds.
1434                     if (nextTokenId != _currentIndex) {
1435                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1436                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1437                     }
1438                 }
1439             }
1440         }
1441 
1442         emit Transfer(from, address(0), tokenId);
1443         _afterTokenTransfers(from, address(0), tokenId, 1);
1444 
1445         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1446         unchecked {
1447             _burnCounter++;
1448         }
1449     }
1450 
1451     // =============================================================
1452     //                     EXTRA DATA OPERATIONS
1453     // =============================================================
1454 
1455     /**
1456      * @dev Directly sets the extra data for the ownership data `index`.
1457      */
1458     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1459         uint256 packed = _packedOwnerships[index];
1460         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1461         uint256 extraDataCasted;
1462         // Cast `extraData` with assembly to avoid redundant masking.
1463         assembly {
1464             extraDataCasted := extraData
1465         }
1466         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1467         _packedOwnerships[index] = packed;
1468     }
1469 
1470     /**
1471      * @dev Called during each token transfer to set the 24bit `extraData` field.
1472      * Intended to be overridden by the cosumer contract.
1473      *
1474      * `previousExtraData` - the value of `extraData` before transfer.
1475      *
1476      * Calling conditions:
1477      *
1478      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1479      * transferred to `to`.
1480      * - When `from` is zero, `tokenId` will be minted for `to`.
1481      * - When `to` is zero, `tokenId` will be burned by `from`.
1482      * - `from` and `to` are never both zero.
1483      */
1484     function _extraData(
1485         address from,
1486         address to,
1487         uint24 previousExtraData
1488     ) internal view virtual returns (uint24) {}
1489 
1490     /**
1491      * @dev Returns the next extra data for the packed ownership data.
1492      * The returned result is shifted into position.
1493      */
1494     function _nextExtraData(
1495         address from,
1496         address to,
1497         uint256 prevOwnershipPacked
1498     ) private view returns (uint256) {
1499         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1500         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1501     }
1502 
1503     // =============================================================
1504     //                       OTHER OPERATIONS
1505     // =============================================================
1506 
1507     /**
1508      * @dev Returns the message sender (defaults to `msg.sender`).
1509      *
1510      * If you are writing GSN compatible contracts, you need to override this function.
1511      */
1512     function _msgSenderERC721A() internal view virtual returns (address) {
1513         return msg.sender;
1514     }
1515 
1516     /**
1517      * @dev Converts a uint256 to its ASCII string decimal representation.
1518      */
1519     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1520         assembly {
1521             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1522             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1523             // We will need 1 32-byte word to store the length,
1524             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1525             str := add(mload(0x40), 0x80)
1526             // Update the free memory pointer to allocate.
1527             mstore(0x40, str)
1528 
1529             // Cache the end of the memory to calculate the length later.
1530             let end := str
1531 
1532             // We write the string from rightmost digit to leftmost digit.
1533             // The following is essentially a do-while loop that also handles the zero case.
1534             // prettier-ignore
1535             for { let temp := value } 1 {} {
1536                 str := sub(str, 1)
1537                 // Write the character to the pointer.
1538                 // The ASCII index of the '0' character is 48.
1539                 mstore8(str, add(48, mod(temp, 10)))
1540                 // Keep dividing `temp` until zero.
1541                 temp := div(temp, 10)
1542                 // prettier-ignore
1543                 if iszero(temp) { break }
1544             }
1545 
1546             let length := sub(end, str)
1547             // Move the pointer 32 bytes leftwards to make room for the length.
1548             str := sub(str, 0x20)
1549             // Store the length.
1550             mstore(str, length)
1551         }
1552     }
1553 }
1554 
1555 // File: contracts/OrangutanWorld.sol
1556 
1557 
1558 
1559 pragma solidity ^0.8.4;
1560 
1561 
1562 
1563 
1564 contract OrangutanWorld is ERC721A, Ownable, ReentrancyGuard {
1565   string public uriPrefix = '';
1566   string public uriSuffix = '.json';
1567   string public baseUri = 'ipfs://QmPzfkdTPjZ5K1sqjTTD9mtagjzfBABcZtDStT4ggjh2RE';
1568 
1569   uint256 public cost = 0.002 ether;
1570   uint256 public maxSupply = 1200;
1571   uint256 public maxMintAmountPerTx = 5;
1572   uint8   public maxFreePerWallet = 1;
1573   mapping(address => uint256) public _mintedFreeAmount;
1574 
1575   bool public paused = true;
1576   bool public revealed = false;
1577 
1578   constructor(
1579     string memory _tokenName,
1580     string memory _tokenSymbol
1581   ) ERC721A(_tokenName, _tokenSymbol) {
1582     _safeMint(msg.sender, 20);
1583   }
1584 
1585   modifier mintCompliance(uint256 _mintAmount) {
1586     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1587     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1588     _;
1589   }
1590 
1591   modifier mintPriceCompliance(uint256 _mintAmount) {
1592     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1593     _;
1594   }
1595 
1596   modifier freeMintCountCompliance(uint256 _mintAmount) {
1597     require(_mintAmount == 1, 'Mint amount must be equal to 1');
1598     require(_mintedFreeAmount[msg.sender] < maxFreePerWallet, 'Max free supply exceeded!');
1599     _;
1600   }
1601 
1602   function freeMint(uint256 _mintAmount) public payable freeMintCountCompliance(_mintAmount) {
1603     require(!paused, 'The contract is paused!');
1604     _mintedFreeAmount[msg.sender] = maxFreePerWallet;
1605     _safeMint(msg.sender, _mintAmount);
1606   }
1607 
1608   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1609     require(!paused, 'The contract is paused!');
1610 
1611     _safeMint(msg.sender, _mintAmount);
1612   }
1613   
1614   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1615     _safeMint(_receiver, _mintAmount);
1616   }
1617 
1618   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1619     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1620 
1621     if (!revealed) {
1622       return baseUri;
1623     }
1624 
1625     string memory currentBaseURI = _baseURI();
1626     return bytes(currentBaseURI).length > 0
1627         ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId), uriSuffix))
1628         : '';
1629   }
1630 
1631   function setCost(uint256 _cost) public onlyOwner {
1632     cost = _cost;
1633   }
1634 
1635   function setBaseUri(string memory _uri) public onlyOwner {
1636     baseUri = _uri;
1637   }
1638 
1639   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1640     uriPrefix = _uriPrefix;
1641   }
1642 
1643   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1644     uriSuffix = _uriSuffix;
1645   }
1646 
1647   function setPaused(bool _state) public onlyOwner {
1648     paused = _state;
1649   }
1650 
1651   function setRevealed(bool _revealed) public onlyOwner {
1652     revealed = _revealed;
1653   }
1654 
1655   function withdraw() public onlyOwner nonReentrant {
1656     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1657     require(os);
1658   }
1659 
1660   function _baseURI() internal view virtual override returns (string memory) {
1661     return uriPrefix;
1662   }
1663 }