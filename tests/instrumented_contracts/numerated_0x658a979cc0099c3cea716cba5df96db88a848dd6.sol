1 // SPDX-License-Identifier: MIT
2 
3 //  *       *  ***  *****     *       ***  ******  ******
4 //  **     **   *   *     *   *        *   *       *
5 //  * *   * *   *   *      *  *        *   *       *
6 //  *  * *  *   *   *      *  *        *   ****    ******
7 //  *   *   *   *   *      *  *        *   *       *
8 //  *       *   *   *     *   *        *   *       *
9 //  *       *  ***  *****     ******  ***  *       ******
10 
11 //     *****   *******    ***      ****    ***    ****
12 //   *      *  *      *    *     *      *   *   *      *
13 //  *          *     *     *     *          *   *
14 //  *          ******      *       ****     *     ****
15 //  *          *     *     *            *   *          *
16 //   *      *  *      *    *     *      *   *   *      *
17 //     *****   *       *  ***      ****    ***    ****
18 
19 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
20 
21 
22 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Contract module that helps prevent reentrant calls to a function.
28  *
29  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
30  * available, which can be applied to functions to make sure there are no nested
31  * (reentrant) calls to them.
32  *
33  * Note that because there is a single `nonReentrant` guard, functions marked as
34  * `nonReentrant` may not call one another. This can be worked around by making
35  * those functions `private`, and then adding `external` `nonReentrant` entry
36  * points to them.
37  *
38  * TIP: If you would like to learn more about reentrancy and alternative ways
39  * to protect against it, check out our blog post
40  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
41  */
42 abstract contract ReentrancyGuard {
43     // Booleans are more expensive than uint256 or any type that takes up a full
44     // word because each write operation emits an extra SLOAD to first read the
45     // slot's contents, replace the bits taken up by the boolean, and then write
46     // back. This is the compiler's defense against contract upgrades and
47     // pointer aliasing, and it cannot be disabled.
48 
49     // The values being non-zero value makes deployment a bit more expensive,
50     // but in exchange the refund on every call to nonReentrant will be lower in
51     // amount. Since refunds are capped to a percentage of the total
52     // transaction's gas, it is best to keep them low in cases like this one, to
53     // increase the likelihood of the full refund coming into effect.
54     uint256 private constant _NOT_ENTERED = 1;
55     uint256 private constant _ENTERED = 2;
56 
57     uint256 private _status;
58 
59     constructor() {
60         _status = _NOT_ENTERED;
61     }
62 
63     /**
64      * @dev Prevents a contract from calling itself, directly or indirectly.
65      * Calling a `nonReentrant` function from another `nonReentrant`
66      * function is not supported. It is possible to prevent this from happening
67      * by making the `nonReentrant` function external, and making it call a
68      * `private` function that does the actual work.
69      */
70     modifier nonReentrant() {
71         // On the first call to nonReentrant, _notEntered will be true
72         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
73 
74         // Any calls to nonReentrant after this point will fail
75         _status = _ENTERED;
76 
77         _;
78 
79         // By storing the original value once again, a refund is triggered (see
80         // https://eips.ethereum.org/EIPS/eip-2200)
81         _status = _NOT_ENTERED;
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Context.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Provides information about the current execution context, including the
94  * sender of the transaction and its data. While these are generally available
95  * via msg.sender and msg.data, they should not be accessed in such a direct
96  * manner, since when dealing with meta-transactions the account sending and
97  * paying for execution may not be the actual sender (as far as an application
98  * is concerned).
99  *
100  * This contract is only required for intermediate, library-like contracts.
101  */
102 abstract contract Context {
103     function _msgSender() internal view virtual returns (address) {
104         return msg.sender;
105     }
106 
107     function _msgData() internal view virtual returns (bytes calldata) {
108         return msg.data;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/access/Ownable.sol
113 
114 
115 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 
120 /**
121  * @dev Contract module which provides a basic access control mechanism, where
122  * there is an account (an owner) that can be granted exclusive access to
123  * specific functions.
124  *
125  * By default, the owner account will be the one that deploys the contract. This
126  * can later be changed with {transferOwnership}.
127  *
128  * This module is used through inheritance. It will make available the modifier
129  * `onlyOwner`, which can be applied to your functions to restrict their use to
130  * the owner.
131  */
132 abstract contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     /**
138      * @dev Initializes the contract setting the deployer as the initial owner.
139      */
140     constructor() {
141         _transferOwnership(_msgSender());
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         _checkOwner();
149         _;
150     }
151 
152     /**
153      * @dev Returns the address of the current owner.
154      */
155     function owner() public view virtual returns (address) {
156         return _owner;
157     }
158 
159     /**
160      * @dev Throws if the sender is not the owner.
161      */
162     function _checkOwner() internal view virtual {
163         require(owner() == _msgSender(), "Ownable: caller is not the owner");
164     }
165 
166     /**
167      * @dev Leaves the contract without owner. It will not be possible to call
168      * `onlyOwner` functions anymore. Can only be called by the current owner.
169      *
170      * NOTE: Renouncing ownership will leave the contract without an owner,
171      * thereby removing any functionality that is only available to the owner.
172      */
173     function renounceOwnership() public virtual onlyOwner {
174         _transferOwnership(address(0));
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Can only be called by the current owner.
180      */
181     function transferOwnership(address newOwner) public virtual onlyOwner {
182         require(newOwner != address(0), "Ownable: new owner is the zero address");
183         _transferOwnership(newOwner);
184     }
185 
186     /**
187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
188      * Internal function without access restriction.
189      */
190     function _transferOwnership(address newOwner) internal virtual {
191         address oldOwner = _owner;
192         _owner = newOwner;
193         emit OwnershipTransferred(oldOwner, newOwner);
194     }
195 }
196 
197 // File: erc721a/contracts/IERC721A.sol
198 
199 
200 // ERC721A Contracts v4.2.3
201 // Creator: Chiru Labs
202 
203 pragma solidity ^0.8.4;
204 
205 /**
206  * @dev Interface of ERC721A.
207  */
208 interface IERC721A {
209     /**
210      * The caller must own the token or be an approved operator.
211      */
212     error ApprovalCallerNotOwnerNorApproved();
213 
214     /**
215      * The token does not exist.
216      */
217     error ApprovalQueryForNonexistentToken();
218 
219     /**
220      * Cannot query the balance for the zero address.
221      */
222     error BalanceQueryForZeroAddress();
223 
224     /**
225      * Cannot mint to the zero address.
226      */
227     error MintToZeroAddress();
228 
229     /**
230      * The quantity of tokens minted must be more than zero.
231      */
232     error MintZeroQuantity();
233 
234     /**
235      * The token does not exist.
236      */
237     error OwnerQueryForNonexistentToken();
238 
239     /**
240      * The caller must own the token or be an approved operator.
241      */
242     error TransferCallerNotOwnerNorApproved();
243 
244     /**
245      * The token must be owned by `from`.
246      */
247     error TransferFromIncorrectOwner();
248 
249     /**
250      * Cannot safely transfer to a contract that does not implement the
251      * ERC721Receiver interface.
252      */
253     error TransferToNonERC721ReceiverImplementer();
254 
255     /**
256      * Cannot transfer to the zero address.
257      */
258     error TransferToZeroAddress();
259 
260     /**
261      * The token does not exist.
262      */
263     error URIQueryForNonexistentToken();
264 
265     /**
266      * The `quantity` minted with ERC2309 exceeds the safety limit.
267      */
268     error MintERC2309QuantityExceedsLimit();
269 
270     /**
271      * The `extraData` cannot be set on an unintialized ownership slot.
272      */
273     error OwnershipNotInitializedForExtraData();
274 
275     // =============================================================
276     //                            STRUCTS
277     // =============================================================
278 
279     struct TokenOwnership {
280         // The address of the owner.
281         address addr;
282         // Stores the start time of ownership with minimal overhead for tokenomics.
283         uint64 startTimestamp;
284         // Whether the token has been burned.
285         bool burned;
286         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
287         uint24 extraData;
288     }
289 
290     // =============================================================
291     //                         TOKEN COUNTERS
292     // =============================================================
293 
294     /**
295      * @dev Returns the total number of tokens in existence.
296      * Burned tokens will reduce the count.
297      * To get the total number of tokens minted, please see {_totalMinted}.
298      */
299     function totalSupply() external view returns (uint256);
300 
301     // =============================================================
302     //                            IERC165
303     // =============================================================
304 
305     /**
306      * @dev Returns true if this contract implements the interface defined by
307      * `interfaceId`. See the corresponding
308      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
309      * to learn more about how these ids are created.
310      *
311      * This function call must use less than 30000 gas.
312      */
313     function supportsInterface(bytes4 interfaceId) external view returns (bool);
314 
315     // =============================================================
316     //                            IERC721
317     // =============================================================
318 
319     /**
320      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
321      */
322     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
323 
324     /**
325      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
326      */
327     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
328 
329     /**
330      * @dev Emitted when `owner` enables or disables
331      * (`approved`) `operator` to manage all of its assets.
332      */
333     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
334 
335     /**
336      * @dev Returns the number of tokens in `owner`'s account.
337      */
338     function balanceOf(address owner) external view returns (uint256 balance);
339 
340     /**
341      * @dev Returns the owner of the `tokenId` token.
342      *
343      * Requirements:
344      *
345      * - `tokenId` must exist.
346      */
347     function ownerOf(uint256 tokenId) external view returns (address owner);
348 
349     /**
350      * @dev Safely transfers `tokenId` token from `from` to `to`,
351      * checking first that contract recipients are aware of the ERC721 protocol
352      * to prevent tokens from being forever locked.
353      *
354      * Requirements:
355      *
356      * - `from` cannot be the zero address.
357      * - `to` cannot be the zero address.
358      * - `tokenId` token must exist and be owned by `from`.
359      * - If the caller is not `from`, it must be have been allowed to move
360      * this token by either {approve} or {setApprovalForAll}.
361      * - If `to` refers to a smart contract, it must implement
362      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
363      *
364      * Emits a {Transfer} event.
365      */
366     function safeTransferFrom(
367         address from,
368         address to,
369         uint256 tokenId,
370         bytes calldata data
371     ) external payable;
372 
373     /**
374      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
375      */
376     function safeTransferFrom(
377         address from,
378         address to,
379         uint256 tokenId
380     ) external payable;
381 
382     /**
383      * @dev Transfers `tokenId` from `from` to `to`.
384      *
385      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
386      * whenever possible.
387      *
388      * Requirements:
389      *
390      * - `from` cannot be the zero address.
391      * - `to` cannot be the zero address.
392      * - `tokenId` token must be owned by `from`.
393      * - If the caller is not `from`, it must be approved to move this token
394      * by either {approve} or {setApprovalForAll}.
395      *
396      * Emits a {Transfer} event.
397      */
398     function transferFrom(
399         address from,
400         address to,
401         uint256 tokenId
402     ) external payable;
403 
404     /**
405      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
406      * The approval is cleared when the token is transferred.
407      *
408      * Only a single account can be approved at a time, so approving the
409      * zero address clears previous approvals.
410      *
411      * Requirements:
412      *
413      * - The caller must own the token or be an approved operator.
414      * - `tokenId` must exist.
415      *
416      * Emits an {Approval} event.
417      */
418     function approve(address to, uint256 tokenId) external payable;
419 
420     /**
421      * @dev Approve or remove `operator` as an operator for the caller.
422      * Operators can call {transferFrom} or {safeTransferFrom}
423      * for any token owned by the caller.
424      *
425      * Requirements:
426      *
427      * - The `operator` cannot be the caller.
428      *
429      * Emits an {ApprovalForAll} event.
430      */
431     function setApprovalForAll(address operator, bool _approved) external;
432 
433     /**
434      * @dev Returns the account approved for `tokenId` token.
435      *
436      * Requirements:
437      *
438      * - `tokenId` must exist.
439      */
440     function getApproved(uint256 tokenId) external view returns (address operator);
441 
442     /**
443      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
444      *
445      * See {setApprovalForAll}.
446      */
447     function isApprovedForAll(address owner, address operator) external view returns (bool);
448 
449     // =============================================================
450     //                        IERC721Metadata
451     // =============================================================
452 
453     /**
454      * @dev Returns the token collection name.
455      */
456     function name() external view returns (string memory);
457 
458     /**
459      * @dev Returns the token collection symbol.
460      */
461     function symbol() external view returns (string memory);
462 
463     /**
464      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
465      */
466     function tokenURI(uint256 tokenId) external view returns (string memory);
467 
468     // =============================================================
469     //                           IERC2309
470     // =============================================================
471 
472     /**
473      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
474      * (inclusive) is transferred from `from` to `to`, as defined in the
475      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
476      *
477      * See {_mintERC2309} for more details.
478      */
479     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
480 }
481 
482 // File: erc721a/contracts/ERC721A.sol
483 
484 
485 // ERC721A Contracts v4.2.3
486 // Creator: Chiru Labs
487 
488 pragma solidity ^0.8.4;
489 
490 
491 /**
492  * @dev Interface of ERC721 token receiver.
493  */
494 interface ERC721A__IERC721Receiver {
495     function onERC721Received(
496         address operator,
497         address from,
498         uint256 tokenId,
499         bytes calldata data
500     ) external returns (bytes4);
501 }
502 
503 /**
504  * @title ERC721A
505  *
506  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
507  * Non-Fungible Token Standard, including the Metadata extension.
508  * Optimized for lower gas during batch mints.
509  *
510  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
511  * starting from `_startTokenId()`.
512  *
513  * Assumptions:
514  *
515  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
516  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
517  */
518 contract ERC721A is IERC721A {
519     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
520     struct TokenApprovalRef {
521         address value;
522     }
523 
524     // =============================================================
525     //                           CONSTANTS
526     // =============================================================
527 
528     // Mask of an entry in packed address data.
529     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
530 
531     // The bit position of `numberMinted` in packed address data.
532     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
533 
534     // The bit position of `numberBurned` in packed address data.
535     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
536 
537     // The bit position of `aux` in packed address data.
538     uint256 private constant _BITPOS_AUX = 192;
539 
540     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
541     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
542 
543     // The bit position of `startTimestamp` in packed ownership.
544     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
545 
546     // The bit mask of the `burned` bit in packed ownership.
547     uint256 private constant _BITMASK_BURNED = 1 << 224;
548 
549     // The bit position of the `nextInitialized` bit in packed ownership.
550     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
551 
552     // The bit mask of the `nextInitialized` bit in packed ownership.
553     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
554 
555     // The bit position of `extraData` in packed ownership.
556     uint256 private constant _BITPOS_EXTRA_DATA = 232;
557 
558     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
559     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
560 
561     // The mask of the lower 160 bits for addresses.
562     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
563 
564     // The maximum `quantity` that can be minted with {_mintERC2309}.
565     // This limit is to prevent overflows on the address data entries.
566     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
567     // is required to cause an overflow, which is unrealistic.
568     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
569 
570     // The `Transfer` event signature is given by:
571     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
572     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
573         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
574 
575     // =============================================================
576     //                            STORAGE
577     // =============================================================
578 
579     // The next token ID to be minted.
580     uint256 private _currentIndex;
581 
582     // The number of tokens burned.
583     uint256 private _burnCounter;
584 
585     // Token name
586     string private _name;
587 
588     // Token symbol
589     string private _symbol;
590 
591     // Mapping from token ID to ownership details
592     // An empty struct value does not necessarily mean the token is unowned.
593     // See {_packedOwnershipOf} implementation for details.
594     //
595     // Bits Layout:
596     // - [0..159]   `addr`
597     // - [160..223] `startTimestamp`
598     // - [224]      `burned`
599     // - [225]      `nextInitialized`
600     // - [232..255] `extraData`
601     mapping(uint256 => uint256) private _packedOwnerships;
602 
603     // Mapping owner address to address data.
604     //
605     // Bits Layout:
606     // - [0..63]    `balance`
607     // - [64..127]  `numberMinted`
608     // - [128..191] `numberBurned`
609     // - [192..255] `aux`
610     mapping(address => uint256) private _packedAddressData;
611 
612     // Mapping from token ID to approved address.
613     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
614 
615     // Mapping from owner to operator approvals
616     mapping(address => mapping(address => bool)) private _operatorApprovals;
617 
618     // =============================================================
619     //                          CONSTRUCTOR
620     // =============================================================
621 
622     constructor(string memory name_, string memory symbol_) {
623         _name = name_;
624         _symbol = symbol_;
625         _currentIndex = _startTokenId();
626     }
627 
628     // =============================================================
629     //                   TOKEN COUNTING OPERATIONS
630     // =============================================================
631 
632     /**
633      * @dev Returns the starting token ID.
634      * To change the starting token ID, please override this function.
635      */
636     function _startTokenId() internal view virtual returns (uint256) {
637         return 0;
638     }
639 
640     /**
641      * @dev Returns the next token ID to be minted.
642      */
643     function _nextTokenId() internal view virtual returns (uint256) {
644         return _currentIndex;
645     }
646 
647     /**
648      * @dev Returns the total number of tokens in existence.
649      * Burned tokens will reduce the count.
650      * To get the total number of tokens minted, please see {_totalMinted}.
651      */
652     function totalSupply() public view virtual override returns (uint256) {
653         // Counter underflow is impossible as _burnCounter cannot be incremented
654         // more than `_currentIndex - _startTokenId()` times.
655         unchecked {
656             return _currentIndex - _burnCounter - _startTokenId();
657         }
658     }
659 
660     /**
661      * @dev Returns the total amount of tokens minted in the contract.
662      */
663     function _totalMinted() internal view virtual returns (uint256) {
664         // Counter underflow is impossible as `_currentIndex` does not decrement,
665         // and it is initialized to `_startTokenId()`.
666         unchecked {
667             return _currentIndex - _startTokenId();
668         }
669     }
670 
671     /**
672      * @dev Returns the total number of tokens burned.
673      */
674     function _totalBurned() internal view virtual returns (uint256) {
675         return _burnCounter;
676     }
677 
678     // =============================================================
679     //                    ADDRESS DATA OPERATIONS
680     // =============================================================
681 
682     /**
683      * @dev Returns the number of tokens in `owner`'s account.
684      */
685     function balanceOf(address owner) public view virtual override returns (uint256) {
686         if (owner == address(0)) revert BalanceQueryForZeroAddress();
687         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
688     }
689 
690     /**
691      * Returns the number of tokens minted by `owner`.
692      */
693     function _numberMinted(address owner) internal view returns (uint256) {
694         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
695     }
696 
697     /**
698      * Returns the number of tokens burned by or on behalf of `owner`.
699      */
700     function _numberBurned(address owner) internal view returns (uint256) {
701         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
702     }
703 
704     /**
705      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
706      */
707     function _getAux(address owner) internal view returns (uint64) {
708         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
709     }
710 
711     /**
712      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
713      * If there are multiple variables, please pack them into a uint64.
714      */
715     function _setAux(address owner, uint64 aux) internal virtual {
716         uint256 packed = _packedAddressData[owner];
717         uint256 auxCasted;
718         // Cast `aux` with assembly to avoid redundant masking.
719         assembly {
720             auxCasted := aux
721         }
722         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
723         _packedAddressData[owner] = packed;
724     }
725 
726     // =============================================================
727     //                            IERC165
728     // =============================================================
729 
730     /**
731      * @dev Returns true if this contract implements the interface defined by
732      * `interfaceId`. See the corresponding
733      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
734      * to learn more about how these ids are created.
735      *
736      * This function call must use less than 30000 gas.
737      */
738     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
739         // The interface IDs are constants representing the first 4 bytes
740         // of the XOR of all function selectors in the interface.
741         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
742         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
743         return
744             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
745             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
746             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
747     }
748 
749     // =============================================================
750     //                        IERC721Metadata
751     // =============================================================
752 
753     /**
754      * @dev Returns the token collection name.
755      */
756     function name() public view virtual override returns (string memory) {
757         return _name;
758     }
759 
760     /**
761      * @dev Returns the token collection symbol.
762      */
763     function symbol() public view virtual override returns (string memory) {
764         return _symbol;
765     }
766 
767     /**
768      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
769      */
770     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
771         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
772 
773         string memory baseURI = _baseURI();
774         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
775     }
776 
777     /**
778      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
779      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
780      * by default, it can be overridden in child contracts.
781      */
782     function _baseURI() internal view virtual returns (string memory) {
783         return '';
784     }
785 
786     // =============================================================
787     //                     OWNERSHIPS OPERATIONS
788     // =============================================================
789 
790     /**
791      * @dev Returns the owner of the `tokenId` token.
792      *
793      * Requirements:
794      *
795      * - `tokenId` must exist.
796      */
797     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
798         return address(uint160(_packedOwnershipOf(tokenId)));
799     }
800 
801     /**
802      * @dev Gas spent here starts off proportional to the maximum mint batch size.
803      * It gradually moves to O(1) as tokens get transferred around over time.
804      */
805     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
806         return _unpackedOwnership(_packedOwnershipOf(tokenId));
807     }
808 
809     /**
810      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
811      */
812     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
813         return _unpackedOwnership(_packedOwnerships[index]);
814     }
815 
816     /**
817      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
818      */
819     function _initializeOwnershipAt(uint256 index) internal virtual {
820         if (_packedOwnerships[index] == 0) {
821             _packedOwnerships[index] = _packedOwnershipOf(index);
822         }
823     }
824 
825     /**
826      * Returns the packed ownership data of `tokenId`.
827      */
828     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
829         uint256 curr = tokenId;
830 
831         unchecked {
832             if (_startTokenId() <= curr)
833                 if (curr < _currentIndex) {
834                     uint256 packed = _packedOwnerships[curr];
835                     // If not burned.
836                     if (packed & _BITMASK_BURNED == 0) {
837                         // Invariant:
838                         // There will always be an initialized ownership slot
839                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
840                         // before an unintialized ownership slot
841                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
842                         // Hence, `curr` will not underflow.
843                         //
844                         // We can directly compare the packed value.
845                         // If the address is zero, packed will be zero.
846                         while (packed == 0) {
847                             packed = _packedOwnerships[--curr];
848                         }
849                         return packed;
850                     }
851                 }
852         }
853         revert OwnerQueryForNonexistentToken();
854     }
855 
856     /**
857      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
858      */
859     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
860         ownership.addr = address(uint160(packed));
861         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
862         ownership.burned = packed & _BITMASK_BURNED != 0;
863         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
864     }
865 
866     /**
867      * @dev Packs ownership data into a single uint256.
868      */
869     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
870         assembly {
871             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
872             owner := and(owner, _BITMASK_ADDRESS)
873             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
874             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
875         }
876     }
877 
878     /**
879      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
880      */
881     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
882         // For branchless setting of the `nextInitialized` flag.
883         assembly {
884             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
885             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
886         }
887     }
888 
889     // =============================================================
890     //                      APPROVAL OPERATIONS
891     // =============================================================
892 
893     /**
894      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
895      * The approval is cleared when the token is transferred.
896      *
897      * Only a single account can be approved at a time, so approving the
898      * zero address clears previous approvals.
899      *
900      * Requirements:
901      *
902      * - The caller must own the token or be an approved operator.
903      * - `tokenId` must exist.
904      *
905      * Emits an {Approval} event.
906      */
907     function approve(address to, uint256 tokenId) public payable virtual override {
908         address owner = ownerOf(tokenId);
909 
910         if (_msgSenderERC721A() != owner)
911             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
912                 revert ApprovalCallerNotOwnerNorApproved();
913             }
914 
915         _tokenApprovals[tokenId].value = to;
916         emit Approval(owner, to, tokenId);
917     }
918 
919     /**
920      * @dev Returns the account approved for `tokenId` token.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      */
926     function getApproved(uint256 tokenId) public view virtual override returns (address) {
927         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
928 
929         return _tokenApprovals[tokenId].value;
930     }
931 
932     /**
933      * @dev Approve or remove `operator` as an operator for the caller.
934      * Operators can call {transferFrom} or {safeTransferFrom}
935      * for any token owned by the caller.
936      *
937      * Requirements:
938      *
939      * - The `operator` cannot be the caller.
940      *
941      * Emits an {ApprovalForAll} event.
942      */
943     function setApprovalForAll(address operator, bool approved) public virtual override {
944         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
945         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
946     }
947 
948     /**
949      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
950      *
951      * See {setApprovalForAll}.
952      */
953     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
954         return _operatorApprovals[owner][operator];
955     }
956 
957     /**
958      * @dev Returns whether `tokenId` exists.
959      *
960      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
961      *
962      * Tokens start existing when they are minted. See {_mint}.
963      */
964     function _exists(uint256 tokenId) internal view virtual returns (bool) {
965         return
966             _startTokenId() <= tokenId &&
967             tokenId < _currentIndex && // If within bounds,
968             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
969     }
970 
971     /**
972      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
973      */
974     function _isSenderApprovedOrOwner(
975         address approvedAddress,
976         address owner,
977         address msgSender
978     ) private pure returns (bool result) {
979         assembly {
980             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
981             owner := and(owner, _BITMASK_ADDRESS)
982             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
983             msgSender := and(msgSender, _BITMASK_ADDRESS)
984             // `msgSender == owner || msgSender == approvedAddress`.
985             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
986         }
987     }
988 
989     /**
990      * @dev Returns the storage slot and value for the approved address of `tokenId`.
991      */
992     function _getApprovedSlotAndAddress(uint256 tokenId)
993         private
994         view
995         returns (uint256 approvedAddressSlot, address approvedAddress)
996     {
997         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
998         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
999         assembly {
1000             approvedAddressSlot := tokenApproval.slot
1001             approvedAddress := sload(approvedAddressSlot)
1002         }
1003     }
1004 
1005     // =============================================================
1006     //                      TRANSFER OPERATIONS
1007     // =============================================================
1008 
1009     /**
1010      * @dev Transfers `tokenId` from `from` to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must be owned by `from`.
1017      * - If the caller is not `from`, it must be approved to move this token
1018      * by either {approve} or {setApprovalForAll}.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function transferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public payable virtual override {
1027         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1028 
1029         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1030 
1031         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1032 
1033         // The nested ifs save around 20+ gas over a compound boolean condition.
1034         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1035             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1036 
1037         if (to == address(0)) revert TransferToZeroAddress();
1038 
1039         _beforeTokenTransfers(from, to, tokenId, 1);
1040 
1041         // Clear approvals from the previous owner.
1042         assembly {
1043             if approvedAddress {
1044                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1045                 sstore(approvedAddressSlot, 0)
1046             }
1047         }
1048 
1049         // Underflow of the sender's balance is impossible because we check for
1050         // ownership above and the recipient's balance can't realistically overflow.
1051         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1052         unchecked {
1053             // We can directly increment and decrement the balances.
1054             --_packedAddressData[from]; // Updates: `balance -= 1`.
1055             ++_packedAddressData[to]; // Updates: `balance += 1`.
1056 
1057             // Updates:
1058             // - `address` to the next owner.
1059             // - `startTimestamp` to the timestamp of transfering.
1060             // - `burned` to `false`.
1061             // - `nextInitialized` to `true`.
1062             _packedOwnerships[tokenId] = _packOwnershipData(
1063                 to,
1064                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1065             );
1066 
1067             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1068             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1069                 uint256 nextTokenId = tokenId + 1;
1070                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1071                 if (_packedOwnerships[nextTokenId] == 0) {
1072                     // If the next slot is within bounds.
1073                     if (nextTokenId != _currentIndex) {
1074                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1075                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1076                     }
1077                 }
1078             }
1079         }
1080 
1081         emit Transfer(from, to, tokenId);
1082         _afterTokenTransfers(from, to, tokenId, 1);
1083     }
1084 
1085     /**
1086      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1087      */
1088     function safeTransferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) public payable virtual override {
1093         safeTransferFrom(from, to, tokenId, '');
1094     }
1095 
1096     /**
1097      * @dev Safely transfers `tokenId` token from `from` to `to`.
1098      *
1099      * Requirements:
1100      *
1101      * - `from` cannot be the zero address.
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must exist and be owned by `from`.
1104      * - If the caller is not `from`, it must be approved to move this token
1105      * by either {approve} or {setApprovalForAll}.
1106      * - If `to` refers to a smart contract, it must implement
1107      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function safeTransferFrom(
1112         address from,
1113         address to,
1114         uint256 tokenId,
1115         bytes memory _data
1116     ) public payable virtual override {
1117         transferFrom(from, to, tokenId);
1118         if (to.code.length != 0)
1119             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1120                 revert TransferToNonERC721ReceiverImplementer();
1121             }
1122     }
1123 
1124     /**
1125      * @dev Hook that is called before a set of serially-ordered token IDs
1126      * are about to be transferred. This includes minting.
1127      * And also called before burning one token.
1128      *
1129      * `startTokenId` - the first token ID to be transferred.
1130      * `quantity` - the amount to be transferred.
1131      *
1132      * Calling conditions:
1133      *
1134      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1135      * transferred to `to`.
1136      * - When `from` is zero, `tokenId` will be minted for `to`.
1137      * - When `to` is zero, `tokenId` will be burned by `from`.
1138      * - `from` and `to` are never both zero.
1139      */
1140     function _beforeTokenTransfers(
1141         address from,
1142         address to,
1143         uint256 startTokenId,
1144         uint256 quantity
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after a set of serially-ordered token IDs
1149      * have been transferred. This includes minting.
1150      * And also called after one token has been burned.
1151      *
1152      * `startTokenId` - the first token ID to be transferred.
1153      * `quantity` - the amount to be transferred.
1154      *
1155      * Calling conditions:
1156      *
1157      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1158      * transferred to `to`.
1159      * - When `from` is zero, `tokenId` has been minted for `to`.
1160      * - When `to` is zero, `tokenId` has been burned by `from`.
1161      * - `from` and `to` are never both zero.
1162      */
1163     function _afterTokenTransfers(
1164         address from,
1165         address to,
1166         uint256 startTokenId,
1167         uint256 quantity
1168     ) internal virtual {}
1169 
1170     /**
1171      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1172      *
1173      * `from` - Previous owner of the given token ID.
1174      * `to` - Target address that will receive the token.
1175      * `tokenId` - Token ID to be transferred.
1176      * `_data` - Optional data to send along with the call.
1177      *
1178      * Returns whether the call correctly returned the expected magic value.
1179      */
1180     function _checkContractOnERC721Received(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) private returns (bool) {
1186         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1187             bytes4 retval
1188         ) {
1189             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1190         } catch (bytes memory reason) {
1191             if (reason.length == 0) {
1192                 revert TransferToNonERC721ReceiverImplementer();
1193             } else {
1194                 assembly {
1195                     revert(add(32, reason), mload(reason))
1196                 }
1197             }
1198         }
1199     }
1200 
1201     // =============================================================
1202     //                        MINT OPERATIONS
1203     // =============================================================
1204 
1205     /**
1206      * @dev Mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * Emits a {Transfer} event for each mint.
1214      */
1215     function _mint(address to, uint256 quantity) internal virtual {
1216         uint256 startTokenId = _currentIndex;
1217         if (quantity == 0) revert MintZeroQuantity();
1218 
1219         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1220 
1221         // Overflows are incredibly unrealistic.
1222         // `balance` and `numberMinted` have a maximum limit of 2**64.
1223         // `tokenId` has a maximum limit of 2**256.
1224         unchecked {
1225             // Updates:
1226             // - `balance += quantity`.
1227             // - `numberMinted += quantity`.
1228             //
1229             // We can directly add to the `balance` and `numberMinted`.
1230             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1231 
1232             // Updates:
1233             // - `address` to the owner.
1234             // - `startTimestamp` to the timestamp of minting.
1235             // - `burned` to `false`.
1236             // - `nextInitialized` to `quantity == 1`.
1237             _packedOwnerships[startTokenId] = _packOwnershipData(
1238                 to,
1239                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1240             );
1241 
1242             uint256 toMasked;
1243             uint256 end = startTokenId + quantity;
1244 
1245             // Use assembly to loop and emit the `Transfer` event for gas savings.
1246             // The duplicated `log4` removes an extra check and reduces stack juggling.
1247             // The assembly, together with the surrounding Solidity code, have been
1248             // delicately arranged to nudge the compiler into producing optimized opcodes.
1249             assembly {
1250                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1251                 toMasked := and(to, _BITMASK_ADDRESS)
1252                 // Emit the `Transfer` event.
1253                 log4(
1254                     0, // Start of data (0, since no data).
1255                     0, // End of data (0, since no data).
1256                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1257                     0, // `address(0)`.
1258                     toMasked, // `to`.
1259                     startTokenId // `tokenId`.
1260                 )
1261 
1262                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1263                 // that overflows uint256 will make the loop run out of gas.
1264                 // The compiler will optimize the `iszero` away for performance.
1265                 for {
1266                     let tokenId := add(startTokenId, 1)
1267                 } iszero(eq(tokenId, end)) {
1268                     tokenId := add(tokenId, 1)
1269                 } {
1270                     // Emit the `Transfer` event. Similar to above.
1271                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1272                 }
1273             }
1274             if (toMasked == 0) revert MintToZeroAddress();
1275 
1276             _currentIndex = end;
1277         }
1278         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1279     }
1280 
1281     /**
1282      * @dev Mints `quantity` tokens and transfers them to `to`.
1283      *
1284      * This function is intended for efficient minting only during contract creation.
1285      *
1286      * It emits only one {ConsecutiveTransfer} as defined in
1287      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1288      * instead of a sequence of {Transfer} event(s).
1289      *
1290      * Calling this function outside of contract creation WILL make your contract
1291      * non-compliant with the ERC721 standard.
1292      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1293      * {ConsecutiveTransfer} event is only permissible during contract creation.
1294      *
1295      * Requirements:
1296      *
1297      * - `to` cannot be the zero address.
1298      * - `quantity` must be greater than 0.
1299      *
1300      * Emits a {ConsecutiveTransfer} event.
1301      */
1302     function _mintERC2309(address to, uint256 quantity) internal virtual {
1303         uint256 startTokenId = _currentIndex;
1304         if (to == address(0)) revert MintToZeroAddress();
1305         if (quantity == 0) revert MintZeroQuantity();
1306         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1307 
1308         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1309 
1310         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1311         unchecked {
1312             // Updates:
1313             // - `balance += quantity`.
1314             // - `numberMinted += quantity`.
1315             //
1316             // We can directly add to the `balance` and `numberMinted`.
1317             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1318 
1319             // Updates:
1320             // - `address` to the owner.
1321             // - `startTimestamp` to the timestamp of minting.
1322             // - `burned` to `false`.
1323             // - `nextInitialized` to `quantity == 1`.
1324             _packedOwnerships[startTokenId] = _packOwnershipData(
1325                 to,
1326                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1327             );
1328 
1329             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1330 
1331             _currentIndex = startTokenId + quantity;
1332         }
1333         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1334     }
1335 
1336     /**
1337      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1338      *
1339      * Requirements:
1340      *
1341      * - If `to` refers to a smart contract, it must implement
1342      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1343      * - `quantity` must be greater than 0.
1344      *
1345      * See {_mint}.
1346      *
1347      * Emits a {Transfer} event for each mint.
1348      */
1349     function _safeMint(
1350         address to,
1351         uint256 quantity,
1352         bytes memory _data
1353     ) internal virtual {
1354         _mint(to, quantity);
1355 
1356         unchecked {
1357             if (to.code.length != 0) {
1358                 uint256 end = _currentIndex;
1359                 uint256 index = end - quantity;
1360                 do {
1361                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1362                         revert TransferToNonERC721ReceiverImplementer();
1363                     }
1364                 } while (index < end);
1365                 // Reentrancy protection.
1366                 if (_currentIndex != end) revert();
1367             }
1368         }
1369     }
1370 
1371     /**
1372      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1373      */
1374     function _safeMint(address to, uint256 quantity) internal virtual {
1375         _safeMint(to, quantity, '');
1376     }
1377 
1378     // =============================================================
1379     //                        BURN OPERATIONS
1380     // =============================================================
1381 
1382     /**
1383      * @dev Equivalent to `_burn(tokenId, false)`.
1384      */
1385     function _burn(uint256 tokenId) internal virtual {
1386         _burn(tokenId, false);
1387     }
1388 
1389     /**
1390      * @dev Destroys `tokenId`.
1391      * The approval is cleared when the token is burned.
1392      *
1393      * Requirements:
1394      *
1395      * - `tokenId` must exist.
1396      *
1397      * Emits a {Transfer} event.
1398      */
1399     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1400         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1401 
1402         address from = address(uint160(prevOwnershipPacked));
1403 
1404         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1405 
1406         if (approvalCheck) {
1407             // The nested ifs save around 20+ gas over a compound boolean condition.
1408             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1409                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1410         }
1411 
1412         _beforeTokenTransfers(from, address(0), tokenId, 1);
1413 
1414         // Clear approvals from the previous owner.
1415         assembly {
1416             if approvedAddress {
1417                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1418                 sstore(approvedAddressSlot, 0)
1419             }
1420         }
1421 
1422         // Underflow of the sender's balance is impossible because we check for
1423         // ownership above and the recipient's balance can't realistically overflow.
1424         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1425         unchecked {
1426             // Updates:
1427             // - `balance -= 1`.
1428             // - `numberBurned += 1`.
1429             //
1430             // We can directly decrement the balance, and increment the number burned.
1431             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1432             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1433 
1434             // Updates:
1435             // - `address` to the last owner.
1436             // - `startTimestamp` to the timestamp of burning.
1437             // - `burned` to `true`.
1438             // - `nextInitialized` to `true`.
1439             _packedOwnerships[tokenId] = _packOwnershipData(
1440                 from,
1441                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1442             );
1443 
1444             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1445             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1446                 uint256 nextTokenId = tokenId + 1;
1447                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1448                 if (_packedOwnerships[nextTokenId] == 0) {
1449                     // If the next slot is within bounds.
1450                     if (nextTokenId != _currentIndex) {
1451                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1452                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1453                     }
1454                 }
1455             }
1456         }
1457 
1458         emit Transfer(from, address(0), tokenId);
1459         _afterTokenTransfers(from, address(0), tokenId, 1);
1460 
1461         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1462         unchecked {
1463             _burnCounter++;
1464         }
1465     }
1466 
1467     // =============================================================
1468     //                     EXTRA DATA OPERATIONS
1469     // =============================================================
1470 
1471     /**
1472      * @dev Directly sets the extra data for the ownership data `index`.
1473      */
1474     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1475         uint256 packed = _packedOwnerships[index];
1476         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1477         uint256 extraDataCasted;
1478         // Cast `extraData` with assembly to avoid redundant masking.
1479         assembly {
1480             extraDataCasted := extraData
1481         }
1482         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1483         _packedOwnerships[index] = packed;
1484     }
1485 
1486     /**
1487      * @dev Called during each token transfer to set the 24bit `extraData` field.
1488      * Intended to be overridden by the cosumer contract.
1489      *
1490      * `previousExtraData` - the value of `extraData` before transfer.
1491      *
1492      * Calling conditions:
1493      *
1494      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1495      * transferred to `to`.
1496      * - When `from` is zero, `tokenId` will be minted for `to`.
1497      * - When `to` is zero, `tokenId` will be burned by `from`.
1498      * - `from` and `to` are never both zero.
1499      */
1500     function _extraData(
1501         address from,
1502         address to,
1503         uint24 previousExtraData
1504     ) internal view virtual returns (uint24) {}
1505 
1506     /**
1507      * @dev Returns the next extra data for the packed ownership data.
1508      * The returned result is shifted into position.
1509      */
1510     function _nextExtraData(
1511         address from,
1512         address to,
1513         uint256 prevOwnershipPacked
1514     ) private view returns (uint256) {
1515         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1516         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1517     }
1518 
1519     // =============================================================
1520     //                       OTHER OPERATIONS
1521     // =============================================================
1522 
1523     /**
1524      * @dev Returns the message sender (defaults to `msg.sender`).
1525      *
1526      * If you are writing GSN compatible contracts, you need to override this function.
1527      */
1528     function _msgSenderERC721A() internal view virtual returns (address) {
1529         return msg.sender;
1530     }
1531 
1532     /**
1533      * @dev Converts a uint256 to its ASCII string decimal representation.
1534      */
1535     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1536         assembly {
1537             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1538             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1539             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1540             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1541             let m := add(mload(0x40), 0xa0)
1542             // Update the free memory pointer to allocate.
1543             mstore(0x40, m)
1544             // Assign the `str` to the end.
1545             str := sub(m, 0x20)
1546             // Zeroize the slot after the string.
1547             mstore(str, 0)
1548 
1549             // Cache the end of the memory to calculate the length later.
1550             let end := str
1551 
1552             // We write the string from rightmost digit to leftmost digit.
1553             // The following is essentially a do-while loop that also handles the zero case.
1554             // prettier-ignore
1555             for { let temp := value } 1 {} {
1556                 str := sub(str, 1)
1557                 // Write the character to the pointer.
1558                 // The ASCII index of the '0' character is 48.
1559                 mstore8(str, add(48, mod(temp, 10)))
1560                 // Keep dividing `temp` until zero.
1561                 temp := div(temp, 10)
1562                 // prettier-ignore
1563                 if iszero(temp) { break }
1564             }
1565 
1566             let length := sub(end, str)
1567             // Move the pointer 32 bytes leftwards to make room for the length.
1568             str := sub(str, 0x20)
1569             // Store the length.
1570             mstore(str, length)
1571         }
1572     }
1573 }
1574 
1575 // File: contracts/MidlifeCrisis.sol
1576 
1577 
1578 
1579 pragma solidity ^0.8.4;
1580 
1581 
1582 
1583 
1584 contract MidlifeCrisis is ERC721A, Ownable, ReentrancyGuard {
1585   string public uriPrefix = '';
1586   string public uriSuffix = '.json';
1587   string public baseUri = 'ipfs://QmXSWr7W5nyBNTAc66VGCAzLXBoEiqNbWvXxYMb4MeThvi/hide.json';
1588 
1589   uint256 public cost = 0.001 ether;
1590   uint256 public maxSupply = 5555;
1591   uint256 public maxMintAmountPerTx = 5;
1592 
1593   bool public paused = true;
1594   bool public revealed = false;
1595 
1596   constructor(
1597     string memory _tokenName,
1598     string memory _tokenSymbol
1599   ) ERC721A(_tokenName, _tokenSymbol) {
1600     _safeMint(msg.sender, 1);
1601   }
1602 
1603   modifier mintCompliance(uint256 _mintAmount) {
1604     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1605     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1606     _;
1607   }
1608 
1609   modifier mintPriceCompliance(uint256 _mintAmount) {
1610     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1611     _;
1612   }
1613 
1614   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1615     require(!paused, 'The contract is paused!');
1616 
1617     _safeMint(msg.sender, _mintAmount);
1618   }
1619   
1620   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1621     _safeMint(_receiver, _mintAmount);
1622   }
1623 
1624   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1625     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1626 
1627     if (!revealed) {
1628       return baseUri;
1629     }
1630 
1631     string memory currentBaseURI = _baseURI();
1632     return bytes(currentBaseURI).length > 0
1633         ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId), uriSuffix))
1634         : '';
1635   }
1636 
1637   function setCost(uint256 _cost) public onlyOwner {
1638     cost = _cost;
1639   }
1640 
1641   function setBaseUri(string memory _uri) public onlyOwner {
1642     baseUri = _uri;
1643   }
1644 
1645   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1646     uriPrefix = _uriPrefix;
1647   }
1648 
1649   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1650     uriSuffix = _uriSuffix;
1651   }
1652 
1653   function setPaused(bool _state) public onlyOwner {
1654     paused = _state;
1655   }
1656 
1657   function setRevealed(bool _revealed) public onlyOwner {
1658     revealed = _revealed;
1659   }
1660 
1661   function withdraw() public onlyOwner nonReentrant {
1662     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1663     require(os);
1664   }
1665 
1666   function _baseURI() internal view virtual override returns (string memory) {
1667     return uriPrefix;
1668   }
1669 }