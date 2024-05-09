1 // Sources flattened with hardhat v2.11.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.3
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 
70 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 
98 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
99 
100 
101 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _transferOwnership(_msgSender());
127     }
128 
129     /**
130      * @dev Throws if called by any account other than the owner.
131      */
132     modifier onlyOwner() {
133         _checkOwner();
134         _;
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view virtual returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if the sender is not the owner.
146      */
147     function _checkOwner() internal view virtual {
148         require(owner() == _msgSender(), "Ownable: caller is not the owner");
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public virtual onlyOwner {
159         _transferOwnership(address(0));
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Can only be called by the current owner.
165      */
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         _transferOwnership(newOwner);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Internal function without access restriction.
174      */
175     function _transferOwnership(address newOwner) internal virtual {
176         address oldOwner = _owner;
177         _owner = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 
183 // File erc721a/contracts/IERC721A.sol@v4.2.3
184 
185 
186 // ERC721A Contracts v4.2.3
187 // Creator: Chiru Labs
188 
189 pragma solidity ^0.8.4;
190 
191 /**
192  * @dev Interface of ERC721A.
193  */
194 interface IERC721A {
195     /**
196      * The caller must own the token or be an approved operator.
197      */
198     error ApprovalCallerNotOwnerNorApproved();
199 
200     /**
201      * The token does not exist.
202      */
203     error ApprovalQueryForNonexistentToken();
204 
205     /**
206      * Cannot query the balance for the zero address.
207      */
208     error BalanceQueryForZeroAddress();
209 
210     /**
211      * Cannot mint to the zero address.
212      */
213     error MintToZeroAddress();
214 
215     /**
216      * The quantity of tokens minted must be more than zero.
217      */
218     error MintZeroQuantity();
219 
220     /**
221      * The token does not exist.
222      */
223     error OwnerQueryForNonexistentToken();
224 
225     /**
226      * The caller must own the token or be an approved operator.
227      */
228     error TransferCallerNotOwnerNorApproved();
229 
230     /**
231      * The token must be owned by `from`.
232      */
233     error TransferFromIncorrectOwner();
234 
235     /**
236      * Cannot safely transfer to a contract that does not implement the
237      * ERC721Receiver interface.
238      */
239     error TransferToNonERC721ReceiverImplementer();
240 
241     /**
242      * Cannot transfer to the zero address.
243      */
244     error TransferToZeroAddress();
245 
246     /**
247      * The token does not exist.
248      */
249     error URIQueryForNonexistentToken();
250 
251     /**
252      * The `quantity` minted with ERC2309 exceeds the safety limit.
253      */
254     error MintERC2309QuantityExceedsLimit();
255 
256     /**
257      * The `extraData` cannot be set on an unintialized ownership slot.
258      */
259     error OwnershipNotInitializedForExtraData();
260 
261     // =============================================================
262     //                            STRUCTS
263     // =============================================================
264 
265     struct TokenOwnership {
266         // The address of the owner.
267         address addr;
268         // Stores the start time of ownership with minimal overhead for tokenomics.
269         uint64 startTimestamp;
270         // Whether the token has been burned.
271         bool burned;
272         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
273         uint24 extraData;
274     }
275 
276     // =============================================================
277     //                         TOKEN COUNTERS
278     // =============================================================
279 
280     /**
281      * @dev Returns the total number of tokens in existence.
282      * Burned tokens will reduce the count.
283      * To get the total number of tokens minted, please see {_totalMinted}.
284      */
285     function totalSupply() external view returns (uint256);
286 
287     // =============================================================
288     //                            IERC165
289     // =============================================================
290 
291     /**
292      * @dev Returns true if this contract implements the interface defined by
293      * `interfaceId`. See the corresponding
294      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
295      * to learn more about how these ids are created.
296      *
297      * This function call must use less than 30000 gas.
298      */
299     function supportsInterface(bytes4 interfaceId) external view returns (bool);
300 
301     // =============================================================
302     //                            IERC721
303     // =============================================================
304 
305     /**
306      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
307      */
308     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
309 
310     /**
311      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
312      */
313     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
314 
315     /**
316      * @dev Emitted when `owner` enables or disables
317      * (`approved`) `operator` to manage all of its assets.
318      */
319     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
320 
321     /**
322      * @dev Returns the number of tokens in `owner`'s account.
323      */
324     function balanceOf(address owner) external view returns (uint256 balance);
325 
326     /**
327      * @dev Returns the owner of the `tokenId` token.
328      *
329      * Requirements:
330      *
331      * - `tokenId` must exist.
332      */
333     function ownerOf(uint256 tokenId) external view returns (address owner);
334 
335     /**
336      * @dev Safely transfers `tokenId` token from `from` to `to`,
337      * checking first that contract recipients are aware of the ERC721 protocol
338      * to prevent tokens from being forever locked.
339      *
340      * Requirements:
341      *
342      * - `from` cannot be the zero address.
343      * - `to` cannot be the zero address.
344      * - `tokenId` token must exist and be owned by `from`.
345      * - If the caller is not `from`, it must be have been allowed to move
346      * this token by either {approve} or {setApprovalForAll}.
347      * - If `to` refers to a smart contract, it must implement
348      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
349      *
350      * Emits a {Transfer} event.
351      */
352     function safeTransferFrom(
353         address from,
354         address to,
355         uint256 tokenId,
356         bytes calldata data
357     ) external payable;
358 
359     /**
360      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
361      */
362     function safeTransferFrom(
363         address from,
364         address to,
365         uint256 tokenId
366     ) external payable;
367 
368     /**
369      * @dev Transfers `tokenId` from `from` to `to`.
370      *
371      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
372      * whenever possible.
373      *
374      * Requirements:
375      *
376      * - `from` cannot be the zero address.
377      * - `to` cannot be the zero address.
378      * - `tokenId` token must be owned by `from`.
379      * - If the caller is not `from`, it must be approved to move this token
380      * by either {approve} or {setApprovalForAll}.
381      *
382      * Emits a {Transfer} event.
383      */
384     function transferFrom(
385         address from,
386         address to,
387         uint256 tokenId
388     ) external payable;
389 
390     /**
391      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
392      * The approval is cleared when the token is transferred.
393      *
394      * Only a single account can be approved at a time, so approving the
395      * zero address clears previous approvals.
396      *
397      * Requirements:
398      *
399      * - The caller must own the token or be an approved operator.
400      * - `tokenId` must exist.
401      *
402      * Emits an {Approval} event.
403      */
404     function approve(address to, uint256 tokenId) external payable;
405 
406     /**
407      * @dev Approve or remove `operator` as an operator for the caller.
408      * Operators can call {transferFrom} or {safeTransferFrom}
409      * for any token owned by the caller.
410      *
411      * Requirements:
412      *
413      * - The `operator` cannot be the caller.
414      *
415      * Emits an {ApprovalForAll} event.
416      */
417     function setApprovalForAll(address operator, bool _approved) external;
418 
419     /**
420      * @dev Returns the account approved for `tokenId` token.
421      *
422      * Requirements:
423      *
424      * - `tokenId` must exist.
425      */
426     function getApproved(uint256 tokenId) external view returns (address operator);
427 
428     /**
429      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
430      *
431      * See {setApprovalForAll}.
432      */
433     function isApprovedForAll(address owner, address operator) external view returns (bool);
434 
435     // =============================================================
436     //                        IERC721Metadata
437     // =============================================================
438 
439     /**
440      * @dev Returns the token collection name.
441      */
442     function name() external view returns (string memory);
443 
444     /**
445      * @dev Returns the token collection symbol.
446      */
447     function symbol() external view returns (string memory);
448 
449     /**
450      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
451      */
452     function tokenURI(uint256 tokenId) external view returns (string memory);
453 
454     // =============================================================
455     //                           IERC2309
456     // =============================================================
457 
458     /**
459      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
460      * (inclusive) is transferred from `from` to `to`, as defined in the
461      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
462      *
463      * See {_mintERC2309} for more details.
464      */
465     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
466 }
467 
468 
469 // File erc721a/contracts/ERC721A.sol@v4.2.3
470 
471 
472 // ERC721A Contracts v4.2.3
473 // Creator: Chiru Labs
474 
475 pragma solidity ^0.8.4;
476 
477 /**
478  * @dev Interface of ERC721 token receiver.
479  */
480 interface ERC721A__IERC721Receiver {
481     function onERC721Received(
482         address operator,
483         address from,
484         uint256 tokenId,
485         bytes calldata data
486     ) external returns (bytes4);
487 }
488 
489 /**
490  * @title ERC721A
491  *
492  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
493  * Non-Fungible Token Standard, including the Metadata extension.
494  * Optimized for lower gas during batch mints.
495  *
496  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
497  * starting from `_startTokenId()`.
498  *
499  * Assumptions:
500  *
501  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
502  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
503  */
504 contract ERC721A is IERC721A {
505     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
506     struct TokenApprovalRef {
507         address value;
508     }
509 
510     // =============================================================
511     //                           CONSTANTS
512     // =============================================================
513 
514     // Mask of an entry in packed address data.
515     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
516 
517     // The bit position of `numberMinted` in packed address data.
518     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
519 
520     // The bit position of `numberBurned` in packed address data.
521     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
522 
523     // The bit position of `aux` in packed address data.
524     uint256 private constant _BITPOS_AUX = 192;
525 
526     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
527     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
528 
529     // The bit position of `startTimestamp` in packed ownership.
530     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
531 
532     // The bit mask of the `burned` bit in packed ownership.
533     uint256 private constant _BITMASK_BURNED = 1 << 224;
534 
535     // The bit position of the `nextInitialized` bit in packed ownership.
536     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
537 
538     // The bit mask of the `nextInitialized` bit in packed ownership.
539     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
540 
541     // The bit position of `extraData` in packed ownership.
542     uint256 private constant _BITPOS_EXTRA_DATA = 232;
543 
544     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
545     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
546 
547     // The mask of the lower 160 bits for addresses.
548     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
549 
550     // The maximum `quantity` that can be minted with {_mintERC2309}.
551     // This limit is to prevent overflows on the address data entries.
552     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
553     // is required to cause an overflow, which is unrealistic.
554     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
555 
556     // The `Transfer` event signature is given by:
557     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
558     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
559         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
560 
561     // =============================================================
562     //                            STORAGE
563     // =============================================================
564 
565     // The next token ID to be minted.
566     uint256 private _currentIndex;
567 
568     // The number of tokens burned.
569     uint256 private _burnCounter;
570 
571     // Token name
572     string private _name;
573 
574     // Token symbol
575     string private _symbol;
576 
577     // Mapping from token ID to ownership details
578     // An empty struct value does not necessarily mean the token is unowned.
579     // See {_packedOwnershipOf} implementation for details.
580     //
581     // Bits Layout:
582     // - [0..159]   `addr`
583     // - [160..223] `startTimestamp`
584     // - [224]      `burned`
585     // - [225]      `nextInitialized`
586     // - [232..255] `extraData`
587     mapping(uint256 => uint256) private _packedOwnerships;
588 
589     // Mapping owner address to address data.
590     //
591     // Bits Layout:
592     // - [0..63]    `balance`
593     // - [64..127]  `numberMinted`
594     // - [128..191] `numberBurned`
595     // - [192..255] `aux`
596     mapping(address => uint256) private _packedAddressData;
597 
598     // Mapping from token ID to approved address.
599     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
600 
601     // Mapping from owner to operator approvals
602     mapping(address => mapping(address => bool)) private _operatorApprovals;
603 
604     // =============================================================
605     //                          CONSTRUCTOR
606     // =============================================================
607 
608     constructor(string memory name_, string memory symbol_) {
609         _name = name_;
610         _symbol = symbol_;
611         _currentIndex = _startTokenId();
612     }
613 
614     // =============================================================
615     //                   TOKEN COUNTING OPERATIONS
616     // =============================================================
617 
618     /**
619      * @dev Returns the starting token ID.
620      * To change the starting token ID, please override this function.
621      */
622     function _startTokenId() internal view virtual returns (uint256) {
623         return 0;
624     }
625 
626     /**
627      * @dev Returns the next token ID to be minted.
628      */
629     function _nextTokenId() internal view virtual returns (uint256) {
630         return _currentIndex;
631     }
632 
633     /**
634      * @dev Returns the total number of tokens in existence.
635      * Burned tokens will reduce the count.
636      * To get the total number of tokens minted, please see {_totalMinted}.
637      */
638     function totalSupply() public view virtual override returns (uint256) {
639         // Counter underflow is impossible as _burnCounter cannot be incremented
640         // more than `_currentIndex - _startTokenId()` times.
641         unchecked {
642             return _currentIndex - _burnCounter - _startTokenId();
643         }
644     }
645 
646     /**
647      * @dev Returns the total amount of tokens minted in the contract.
648      */
649     function _totalMinted() internal view virtual returns (uint256) {
650         // Counter underflow is impossible as `_currentIndex` does not decrement,
651         // and it is initialized to `_startTokenId()`.
652         unchecked {
653             return _currentIndex - _startTokenId();
654         }
655     }
656 
657     /**
658      * @dev Returns the total number of tokens burned.
659      */
660     function _totalBurned() internal view virtual returns (uint256) {
661         return _burnCounter;
662     }
663 
664     // =============================================================
665     //                    ADDRESS DATA OPERATIONS
666     // =============================================================
667 
668     /**
669      * @dev Returns the number of tokens in `owner`'s account.
670      */
671     function balanceOf(address owner) public view virtual override returns (uint256) {
672         if (owner == address(0)) revert BalanceQueryForZeroAddress();
673         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
674     }
675 
676     /**
677      * Returns the number of tokens minted by `owner`.
678      */
679     function _numberMinted(address owner) internal view returns (uint256) {
680         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
681     }
682 
683     /**
684      * Returns the number of tokens burned by or on behalf of `owner`.
685      */
686     function _numberBurned(address owner) internal view returns (uint256) {
687         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
688     }
689 
690     /**
691      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
692      */
693     function _getAux(address owner) internal view returns (uint64) {
694         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
695     }
696 
697     /**
698      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
699      * If there are multiple variables, please pack them into a uint64.
700      */
701     function _setAux(address owner, uint64 aux) internal virtual {
702         uint256 packed = _packedAddressData[owner];
703         uint256 auxCasted;
704         // Cast `aux` with assembly to avoid redundant masking.
705         assembly {
706             auxCasted := aux
707         }
708         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
709         _packedAddressData[owner] = packed;
710     }
711 
712     // =============================================================
713     //                            IERC165
714     // =============================================================
715 
716     /**
717      * @dev Returns true if this contract implements the interface defined by
718      * `interfaceId`. See the corresponding
719      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
720      * to learn more about how these ids are created.
721      *
722      * This function call must use less than 30000 gas.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
725         // The interface IDs are constants representing the first 4 bytes
726         // of the XOR of all function selectors in the interface.
727         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
728         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
729         return
730             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
731             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
732             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
733     }
734 
735     // =============================================================
736     //                        IERC721Metadata
737     // =============================================================
738 
739     /**
740      * @dev Returns the token collection name.
741      */
742     function name() public view virtual override returns (string memory) {
743         return _name;
744     }
745 
746     /**
747      * @dev Returns the token collection symbol.
748      */
749     function symbol() public view virtual override returns (string memory) {
750         return _symbol;
751     }
752 
753     /**
754      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
755      */
756     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
757         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
758 
759         string memory baseURI = _baseURI();
760         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
761     }
762 
763     /**
764      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
765      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
766      * by default, it can be overridden in child contracts.
767      */
768     function _baseURI() internal view virtual returns (string memory) {
769         return '';
770     }
771 
772     // =============================================================
773     //                     OWNERSHIPS OPERATIONS
774     // =============================================================
775 
776     /**
777      * @dev Returns the owner of the `tokenId` token.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
784         return address(uint160(_packedOwnershipOf(tokenId)));
785     }
786 
787     /**
788      * @dev Gas spent here starts off proportional to the maximum mint batch size.
789      * It gradually moves to O(1) as tokens get transferred around over time.
790      */
791     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
792         return _unpackedOwnership(_packedOwnershipOf(tokenId));
793     }
794 
795     /**
796      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
797      */
798     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
799         return _unpackedOwnership(_packedOwnerships[index]);
800     }
801 
802     /**
803      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
804      */
805     function _initializeOwnershipAt(uint256 index) internal virtual {
806         if (_packedOwnerships[index] == 0) {
807             _packedOwnerships[index] = _packedOwnershipOf(index);
808         }
809     }
810 
811     /**
812      * Returns the packed ownership data of `tokenId`.
813      */
814     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
815         uint256 curr = tokenId;
816 
817         unchecked {
818             if (_startTokenId() <= curr)
819                 if (curr < _currentIndex) {
820                     uint256 packed = _packedOwnerships[curr];
821                     // If not burned.
822                     if (packed & _BITMASK_BURNED == 0) {
823                         // Invariant:
824                         // There will always be an initialized ownership slot
825                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
826                         // before an unintialized ownership slot
827                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
828                         // Hence, `curr` will not underflow.
829                         //
830                         // We can directly compare the packed value.
831                         // If the address is zero, packed will be zero.
832                         while (packed == 0) {
833                             packed = _packedOwnerships[--curr];
834                         }
835                         return packed;
836                     }
837                 }
838         }
839         revert OwnerQueryForNonexistentToken();
840     }
841 
842     /**
843      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
844      */
845     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
846         ownership.addr = address(uint160(packed));
847         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
848         ownership.burned = packed & _BITMASK_BURNED != 0;
849         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
850     }
851 
852     /**
853      * @dev Packs ownership data into a single uint256.
854      */
855     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
856         assembly {
857             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
858             owner := and(owner, _BITMASK_ADDRESS)
859             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
860             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
861         }
862     }
863 
864     /**
865      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
866      */
867     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
868         // For branchless setting of the `nextInitialized` flag.
869         assembly {
870             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
871             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
872         }
873     }
874 
875     // =============================================================
876     //                      APPROVAL OPERATIONS
877     // =============================================================
878 
879     /**
880      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
881      * The approval is cleared when the token is transferred.
882      *
883      * Only a single account can be approved at a time, so approving the
884      * zero address clears previous approvals.
885      *
886      * Requirements:
887      *
888      * - The caller must own the token or be an approved operator.
889      * - `tokenId` must exist.
890      *
891      * Emits an {Approval} event.
892      */
893     function approve(address to, uint256 tokenId) public payable virtual override {
894         address owner = ownerOf(tokenId);
895 
896         if (_msgSenderERC721A() != owner)
897             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
898                 revert ApprovalCallerNotOwnerNorApproved();
899             }
900 
901         _tokenApprovals[tokenId].value = to;
902         emit Approval(owner, to, tokenId);
903     }
904 
905     /**
906      * @dev Returns the account approved for `tokenId` token.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      */
912     function getApproved(uint256 tokenId) public view virtual override returns (address) {
913         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
914 
915         return _tokenApprovals[tokenId].value;
916     }
917 
918     /**
919      * @dev Approve or remove `operator` as an operator for the caller.
920      * Operators can call {transferFrom} or {safeTransferFrom}
921      * for any token owned by the caller.
922      *
923      * Requirements:
924      *
925      * - The `operator` cannot be the caller.
926      *
927      * Emits an {ApprovalForAll} event.
928      */
929     function setApprovalForAll(address operator, bool approved) public virtual override {
930         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
931         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
932     }
933 
934     /**
935      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
936      *
937      * See {setApprovalForAll}.
938      */
939     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
940         return _operatorApprovals[owner][operator];
941     }
942 
943     /**
944      * @dev Returns whether `tokenId` exists.
945      *
946      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
947      *
948      * Tokens start existing when they are minted. See {_mint}.
949      */
950     function _exists(uint256 tokenId) internal view virtual returns (bool) {
951         return
952             _startTokenId() <= tokenId &&
953             tokenId < _currentIndex && // If within bounds,
954             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
955     }
956 
957     /**
958      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
959      */
960     function _isSenderApprovedOrOwner(
961         address approvedAddress,
962         address owner,
963         address msgSender
964     ) private pure returns (bool result) {
965         assembly {
966             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
967             owner := and(owner, _BITMASK_ADDRESS)
968             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
969             msgSender := and(msgSender, _BITMASK_ADDRESS)
970             // `msgSender == owner || msgSender == approvedAddress`.
971             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
972         }
973     }
974 
975     /**
976      * @dev Returns the storage slot and value for the approved address of `tokenId`.
977      */
978     function _getApprovedSlotAndAddress(uint256 tokenId)
979         private
980         view
981         returns (uint256 approvedAddressSlot, address approvedAddress)
982     {
983         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
984         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
985         assembly {
986             approvedAddressSlot := tokenApproval.slot
987             approvedAddress := sload(approvedAddressSlot)
988         }
989     }
990 
991     // =============================================================
992     //                      TRANSFER OPERATIONS
993     // =============================================================
994 
995     /**
996      * @dev Transfers `tokenId` from `from` to `to`.
997      *
998      * Requirements:
999      *
1000      * - `from` cannot be the zero address.
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      * - If the caller is not `from`, it must be approved to move this token
1004      * by either {approve} or {setApprovalForAll}.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function transferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public payable virtual override {
1013         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1014 
1015         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1016 
1017         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1018 
1019         // The nested ifs save around 20+ gas over a compound boolean condition.
1020         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1021             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1022 
1023         if (to == address(0)) revert TransferToZeroAddress();
1024 
1025         _beforeTokenTransfers(from, to, tokenId, 1);
1026 
1027         // Clear approvals from the previous owner.
1028         assembly {
1029             if approvedAddress {
1030                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1031                 sstore(approvedAddressSlot, 0)
1032             }
1033         }
1034 
1035         // Underflow of the sender's balance is impossible because we check for
1036         // ownership above and the recipient's balance can't realistically overflow.
1037         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1038         unchecked {
1039             // We can directly increment and decrement the balances.
1040             --_packedAddressData[from]; // Updates: `balance -= 1`.
1041             ++_packedAddressData[to]; // Updates: `balance += 1`.
1042 
1043             // Updates:
1044             // - `address` to the next owner.
1045             // - `startTimestamp` to the timestamp of transfering.
1046             // - `burned` to `false`.
1047             // - `nextInitialized` to `true`.
1048             _packedOwnerships[tokenId] = _packOwnershipData(
1049                 to,
1050                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1051             );
1052 
1053             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1054             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1055                 uint256 nextTokenId = tokenId + 1;
1056                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1057                 if (_packedOwnerships[nextTokenId] == 0) {
1058                     // If the next slot is within bounds.
1059                     if (nextTokenId != _currentIndex) {
1060                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1061                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1062                     }
1063                 }
1064             }
1065         }
1066 
1067         emit Transfer(from, to, tokenId);
1068         _afterTokenTransfers(from, to, tokenId, 1);
1069     }
1070 
1071     /**
1072      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) public payable virtual override {
1079         safeTransferFrom(from, to, tokenId, '');
1080     }
1081 
1082     /**
1083      * @dev Safely transfers `tokenId` token from `from` to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must exist and be owned by `from`.
1090      * - If the caller is not `from`, it must be approved to move this token
1091      * by either {approve} or {setApprovalForAll}.
1092      * - If `to` refers to a smart contract, it must implement
1093      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) public payable virtual override {
1103         transferFrom(from, to, tokenId);
1104         if (to.code.length != 0)
1105             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1106                 revert TransferToNonERC721ReceiverImplementer();
1107             }
1108     }
1109 
1110     /**
1111      * @dev Hook that is called before a set of serially-ordered token IDs
1112      * are about to be transferred. This includes minting.
1113      * And also called before burning one token.
1114      *
1115      * `startTokenId` - the first token ID to be transferred.
1116      * `quantity` - the amount to be transferred.
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` will be minted for `to`.
1123      * - When `to` is zero, `tokenId` will be burned by `from`.
1124      * - `from` and `to` are never both zero.
1125      */
1126     function _beforeTokenTransfers(
1127         address from,
1128         address to,
1129         uint256 startTokenId,
1130         uint256 quantity
1131     ) internal virtual {}
1132 
1133     /**
1134      * @dev Hook that is called after a set of serially-ordered token IDs
1135      * have been transferred. This includes minting.
1136      * And also called after one token has been burned.
1137      *
1138      * `startTokenId` - the first token ID to be transferred.
1139      * `quantity` - the amount to be transferred.
1140      *
1141      * Calling conditions:
1142      *
1143      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1144      * transferred to `to`.
1145      * - When `from` is zero, `tokenId` has been minted for `to`.
1146      * - When `to` is zero, `tokenId` has been burned by `from`.
1147      * - `from` and `to` are never both zero.
1148      */
1149     function _afterTokenTransfers(
1150         address from,
1151         address to,
1152         uint256 startTokenId,
1153         uint256 quantity
1154     ) internal virtual {}
1155 
1156     /**
1157      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1158      *
1159      * `from` - Previous owner of the given token ID.
1160      * `to` - Target address that will receive the token.
1161      * `tokenId` - Token ID to be transferred.
1162      * `_data` - Optional data to send along with the call.
1163      *
1164      * Returns whether the call correctly returned the expected magic value.
1165      */
1166     function _checkContractOnERC721Received(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes memory _data
1171     ) private returns (bool) {
1172         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1173             bytes4 retval
1174         ) {
1175             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1176         } catch (bytes memory reason) {
1177             if (reason.length == 0) {
1178                 revert TransferToNonERC721ReceiverImplementer();
1179             } else {
1180                 assembly {
1181                     revert(add(32, reason), mload(reason))
1182                 }
1183             }
1184         }
1185     }
1186 
1187     // =============================================================
1188     //                        MINT OPERATIONS
1189     // =============================================================
1190 
1191     /**
1192      * @dev Mints `quantity` tokens and transfers them to `to`.
1193      *
1194      * Requirements:
1195      *
1196      * - `to` cannot be the zero address.
1197      * - `quantity` must be greater than 0.
1198      *
1199      * Emits a {Transfer} event for each mint.
1200      */
1201     function _mint(address to, uint256 quantity) internal virtual {
1202         uint256 startTokenId = _currentIndex;
1203         if (quantity == 0) revert MintZeroQuantity();
1204 
1205         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1206 
1207         // Overflows are incredibly unrealistic.
1208         // `balance` and `numberMinted` have a maximum limit of 2**64.
1209         // `tokenId` has a maximum limit of 2**256.
1210         unchecked {
1211             // Updates:
1212             // - `balance += quantity`.
1213             // - `numberMinted += quantity`.
1214             //
1215             // We can directly add to the `balance` and `numberMinted`.
1216             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1217 
1218             // Updates:
1219             // - `address` to the owner.
1220             // - `startTimestamp` to the timestamp of minting.
1221             // - `burned` to `false`.
1222             // - `nextInitialized` to `quantity == 1`.
1223             _packedOwnerships[startTokenId] = _packOwnershipData(
1224                 to,
1225                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1226             );
1227 
1228             uint256 toMasked;
1229             uint256 end = startTokenId + quantity;
1230 
1231             // Use assembly to loop and emit the `Transfer` event for gas savings.
1232             // The duplicated `log4` removes an extra check and reduces stack juggling.
1233             // The assembly, together with the surrounding Solidity code, have been
1234             // delicately arranged to nudge the compiler into producing optimized opcodes.
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
1248                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1249                 // that overflows uint256 will make the loop run out of gas.
1250                 // The compiler will optimize the `iszero` away for performance.
1251                 for {
1252                     let tokenId := add(startTokenId, 1)
1253                 } iszero(eq(tokenId, end)) {
1254                     tokenId := add(tokenId, 1)
1255                 } {
1256                     // Emit the `Transfer` event. Similar to above.
1257                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1258                 }
1259             }
1260             if (toMasked == 0) revert MintToZeroAddress();
1261 
1262             _currentIndex = end;
1263         }
1264         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1265     }
1266 
1267     /**
1268      * @dev Mints `quantity` tokens and transfers them to `to`.
1269      *
1270      * This function is intended for efficient minting only during contract creation.
1271      *
1272      * It emits only one {ConsecutiveTransfer} as defined in
1273      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1274      * instead of a sequence of {Transfer} event(s).
1275      *
1276      * Calling this function outside of contract creation WILL make your contract
1277      * non-compliant with the ERC721 standard.
1278      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1279      * {ConsecutiveTransfer} event is only permissible during contract creation.
1280      *
1281      * Requirements:
1282      *
1283      * - `to` cannot be the zero address.
1284      * - `quantity` must be greater than 0.
1285      *
1286      * Emits a {ConsecutiveTransfer} event.
1287      */
1288     function _mintERC2309(address to, uint256 quantity) internal virtual {
1289         uint256 startTokenId = _currentIndex;
1290         if (to == address(0)) revert MintToZeroAddress();
1291         if (quantity == 0) revert MintZeroQuantity();
1292         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1293 
1294         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1295 
1296         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1297         unchecked {
1298             // Updates:
1299             // - `balance += quantity`.
1300             // - `numberMinted += quantity`.
1301             //
1302             // We can directly add to the `balance` and `numberMinted`.
1303             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1304 
1305             // Updates:
1306             // - `address` to the owner.
1307             // - `startTimestamp` to the timestamp of minting.
1308             // - `burned` to `false`.
1309             // - `nextInitialized` to `quantity == 1`.
1310             _packedOwnerships[startTokenId] = _packOwnershipData(
1311                 to,
1312                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1313             );
1314 
1315             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1316 
1317             _currentIndex = startTokenId + quantity;
1318         }
1319         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1320     }
1321 
1322     /**
1323      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1324      *
1325      * Requirements:
1326      *
1327      * - If `to` refers to a smart contract, it must implement
1328      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1329      * - `quantity` must be greater than 0.
1330      *
1331      * See {_mint}.
1332      *
1333      * Emits a {Transfer} event for each mint.
1334      */
1335     function _safeMint(
1336         address to,
1337         uint256 quantity,
1338         bytes memory _data
1339     ) internal virtual {
1340         _mint(to, quantity);
1341 
1342         unchecked {
1343             if (to.code.length != 0) {
1344                 uint256 end = _currentIndex;
1345                 uint256 index = end - quantity;
1346                 do {
1347                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1348                         revert TransferToNonERC721ReceiverImplementer();
1349                     }
1350                 } while (index < end);
1351                 // Reentrancy protection.
1352                 if (_currentIndex != end) revert();
1353             }
1354         }
1355     }
1356 
1357     /**
1358      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1359      */
1360     function _safeMint(address to, uint256 quantity) internal virtual {
1361         _safeMint(to, quantity, '');
1362     }
1363 
1364     // =============================================================
1365     //                        BURN OPERATIONS
1366     // =============================================================
1367 
1368     /**
1369      * @dev Equivalent to `_burn(tokenId, false)`.
1370      */
1371     function _burn(uint256 tokenId) internal virtual {
1372         _burn(tokenId, false);
1373     }
1374 
1375     /**
1376      * @dev Destroys `tokenId`.
1377      * The approval is cleared when the token is burned.
1378      *
1379      * Requirements:
1380      *
1381      * - `tokenId` must exist.
1382      *
1383      * Emits a {Transfer} event.
1384      */
1385     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1386         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1387 
1388         address from = address(uint160(prevOwnershipPacked));
1389 
1390         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1391 
1392         if (approvalCheck) {
1393             // The nested ifs save around 20+ gas over a compound boolean condition.
1394             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1395                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1396         }
1397 
1398         _beforeTokenTransfers(from, address(0), tokenId, 1);
1399 
1400         // Clear approvals from the previous owner.
1401         assembly {
1402             if approvedAddress {
1403                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1404                 sstore(approvedAddressSlot, 0)
1405             }
1406         }
1407 
1408         // Underflow of the sender's balance is impossible because we check for
1409         // ownership above and the recipient's balance can't realistically overflow.
1410         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1411         unchecked {
1412             // Updates:
1413             // - `balance -= 1`.
1414             // - `numberBurned += 1`.
1415             //
1416             // We can directly decrement the balance, and increment the number burned.
1417             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1418             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1419 
1420             // Updates:
1421             // - `address` to the last owner.
1422             // - `startTimestamp` to the timestamp of burning.
1423             // - `burned` to `true`.
1424             // - `nextInitialized` to `true`.
1425             _packedOwnerships[tokenId] = _packOwnershipData(
1426                 from,
1427                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1428             );
1429 
1430             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1431             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1432                 uint256 nextTokenId = tokenId + 1;
1433                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1434                 if (_packedOwnerships[nextTokenId] == 0) {
1435                     // If the next slot is within bounds.
1436                     if (nextTokenId != _currentIndex) {
1437                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1438                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1439                     }
1440                 }
1441             }
1442         }
1443 
1444         emit Transfer(from, address(0), tokenId);
1445         _afterTokenTransfers(from, address(0), tokenId, 1);
1446 
1447         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1448         unchecked {
1449             _burnCounter++;
1450         }
1451     }
1452 
1453     // =============================================================
1454     //                     EXTRA DATA OPERATIONS
1455     // =============================================================
1456 
1457     /**
1458      * @dev Directly sets the extra data for the ownership data `index`.
1459      */
1460     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1461         uint256 packed = _packedOwnerships[index];
1462         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1463         uint256 extraDataCasted;
1464         // Cast `extraData` with assembly to avoid redundant masking.
1465         assembly {
1466             extraDataCasted := extraData
1467         }
1468         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1469         _packedOwnerships[index] = packed;
1470     }
1471 
1472     /**
1473      * @dev Called during each token transfer to set the 24bit `extraData` field.
1474      * Intended to be overridden by the cosumer contract.
1475      *
1476      * `previousExtraData` - the value of `extraData` before transfer.
1477      *
1478      * Calling conditions:
1479      *
1480      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1481      * transferred to `to`.
1482      * - When `from` is zero, `tokenId` will be minted for `to`.
1483      * - When `to` is zero, `tokenId` will be burned by `from`.
1484      * - `from` and `to` are never both zero.
1485      */
1486     function _extraData(
1487         address from,
1488         address to,
1489         uint24 previousExtraData
1490     ) internal view virtual returns (uint24) {}
1491 
1492     /**
1493      * @dev Returns the next extra data for the packed ownership data.
1494      * The returned result is shifted into position.
1495      */
1496     function _nextExtraData(
1497         address from,
1498         address to,
1499         uint256 prevOwnershipPacked
1500     ) private view returns (uint256) {
1501         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1502         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1503     }
1504 
1505     // =============================================================
1506     //                       OTHER OPERATIONS
1507     // =============================================================
1508 
1509     /**
1510      * @dev Returns the message sender (defaults to `msg.sender`).
1511      *
1512      * If you are writing GSN compatible contracts, you need to override this function.
1513      */
1514     function _msgSenderERC721A() internal view virtual returns (address) {
1515         return msg.sender;
1516     }
1517 
1518     /**
1519      * @dev Converts a uint256 to its ASCII string decimal representation.
1520      */
1521     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1522         assembly {
1523             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1524             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1525             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1526             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1527             let m := add(mload(0x40), 0xa0)
1528             // Update the free memory pointer to allocate.
1529             mstore(0x40, m)
1530             // Assign the `str` to the end.
1531             str := sub(m, 0x20)
1532             // Zeroize the slot after the string.
1533             mstore(str, 0)
1534 
1535             // Cache the end of the memory to calculate the length later.
1536             let end := str
1537 
1538             // We write the string from rightmost digit to leftmost digit.
1539             // The following is essentially a do-while loop that also handles the zero case.
1540             // prettier-ignore
1541             for { let temp := value } 1 {} {
1542                 str := sub(str, 1)
1543                 // Write the character to the pointer.
1544                 // The ASCII index of the '0' character is 48.
1545                 mstore8(str, add(48, mod(temp, 10)))
1546                 // Keep dividing `temp` until zero.
1547                 temp := div(temp, 10)
1548                 // prettier-ignore
1549                 if iszero(temp) { break }
1550             }
1551 
1552             let length := sub(end, str)
1553             // Move the pointer 32 bytes leftwards to make room for the length.
1554             str := sub(str, 0x20)
1555             // Store the length.
1556             mstore(str, length)
1557         }
1558     }
1559 }
1560 
1561 
1562 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.2.3
1563 
1564 
1565 // ERC721A Contracts v4.2.3
1566 // Creator: Chiru Labs
1567 
1568 pragma solidity ^0.8.4;
1569 
1570 /**
1571  * @dev Interface of ERC721AQueryable.
1572  */
1573 interface IERC721AQueryable is IERC721A {
1574     /**
1575      * Invalid query range (`start` >= `stop`).
1576      */
1577     error InvalidQueryRange();
1578 
1579     /**
1580      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1581      *
1582      * If the `tokenId` is out of bounds:
1583      *
1584      * - `addr = address(0)`
1585      * - `startTimestamp = 0`
1586      * - `burned = false`
1587      * - `extraData = 0`
1588      *
1589      * If the `tokenId` is burned:
1590      *
1591      * - `addr = <Address of owner before token was burned>`
1592      * - `startTimestamp = <Timestamp when token was burned>`
1593      * - `burned = true`
1594      * - `extraData = <Extra data when token was burned>`
1595      *
1596      * Otherwise:
1597      *
1598      * - `addr = <Address of owner>`
1599      * - `startTimestamp = <Timestamp of start of ownership>`
1600      * - `burned = false`
1601      * - `extraData = <Extra data at start of ownership>`
1602      */
1603     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1604 
1605     /**
1606      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1607      * See {ERC721AQueryable-explicitOwnershipOf}
1608      */
1609     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1610 
1611     /**
1612      * @dev Returns an array of token IDs owned by `owner`,
1613      * in the range [`start`, `stop`)
1614      * (i.e. `start <= tokenId < stop`).
1615      *
1616      * This function allows for tokens to be queried if the collection
1617      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1618      *
1619      * Requirements:
1620      *
1621      * - `start < stop`
1622      */
1623     function tokensOfOwnerIn(
1624         address owner,
1625         uint256 start,
1626         uint256 stop
1627     ) external view returns (uint256[] memory);
1628 
1629     /**
1630      * @dev Returns an array of token IDs owned by `owner`.
1631      *
1632      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1633      * It is meant to be called off-chain.
1634      *
1635      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1636      * multiple smaller scans if the collection is large enough to cause
1637      * an out-of-gas error (10K collections should be fine).
1638      */
1639     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1640 }
1641 
1642 
1643 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.2.3
1644 
1645 
1646 // ERC721A Contracts v4.2.3
1647 // Creator: Chiru Labs
1648 
1649 pragma solidity ^0.8.4;
1650 
1651 
1652 /**
1653  * @title ERC721AQueryable.
1654  *
1655  * @dev ERC721A subclass with convenience query functions.
1656  */
1657 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1658     /**
1659      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1660      *
1661      * If the `tokenId` is out of bounds:
1662      *
1663      * - `addr = address(0)`
1664      * - `startTimestamp = 0`
1665      * - `burned = false`
1666      * - `extraData = 0`
1667      *
1668      * If the `tokenId` is burned:
1669      *
1670      * - `addr = <Address of owner before token was burned>`
1671      * - `startTimestamp = <Timestamp when token was burned>`
1672      * - `burned = true`
1673      * - `extraData = <Extra data when token was burned>`
1674      *
1675      * Otherwise:
1676      *
1677      * - `addr = <Address of owner>`
1678      * - `startTimestamp = <Timestamp of start of ownership>`
1679      * - `burned = false`
1680      * - `extraData = <Extra data at start of ownership>`
1681      */
1682     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1683         TokenOwnership memory ownership;
1684         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1685             return ownership;
1686         }
1687         ownership = _ownershipAt(tokenId);
1688         if (ownership.burned) {
1689             return ownership;
1690         }
1691         return _ownershipOf(tokenId);
1692     }
1693 
1694     /**
1695      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1696      * See {ERC721AQueryable-explicitOwnershipOf}
1697      */
1698     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1699         external
1700         view
1701         virtual
1702         override
1703         returns (TokenOwnership[] memory)
1704     {
1705         unchecked {
1706             uint256 tokenIdsLength = tokenIds.length;
1707             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1708             for (uint256 i; i != tokenIdsLength; ++i) {
1709                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1710             }
1711             return ownerships;
1712         }
1713     }
1714 
1715     /**
1716      * @dev Returns an array of token IDs owned by `owner`,
1717      * in the range [`start`, `stop`)
1718      * (i.e. `start <= tokenId < stop`).
1719      *
1720      * This function allows for tokens to be queried if the collection
1721      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1722      *
1723      * Requirements:
1724      *
1725      * - `start < stop`
1726      */
1727     function tokensOfOwnerIn(
1728         address owner,
1729         uint256 start,
1730         uint256 stop
1731     ) external view virtual override returns (uint256[] memory) {
1732         unchecked {
1733             if (start >= stop) revert InvalidQueryRange();
1734             uint256 tokenIdsIdx;
1735             uint256 stopLimit = _nextTokenId();
1736             // Set `start = max(start, _startTokenId())`.
1737             if (start < _startTokenId()) {
1738                 start = _startTokenId();
1739             }
1740             // Set `stop = min(stop, stopLimit)`.
1741             if (stop > stopLimit) {
1742                 stop = stopLimit;
1743             }
1744             uint256 tokenIdsMaxLength = balanceOf(owner);
1745             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1746             // to cater for cases where `balanceOf(owner)` is too big.
1747             if (start < stop) {
1748                 uint256 rangeLength = stop - start;
1749                 if (rangeLength < tokenIdsMaxLength) {
1750                     tokenIdsMaxLength = rangeLength;
1751                 }
1752             } else {
1753                 tokenIdsMaxLength = 0;
1754             }
1755             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1756             if (tokenIdsMaxLength == 0) {
1757                 return tokenIds;
1758             }
1759             // We need to call `explicitOwnershipOf(start)`,
1760             // because the slot at `start` may not be initialized.
1761             TokenOwnership memory ownership = explicitOwnershipOf(start);
1762             address currOwnershipAddr;
1763             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1764             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1765             if (!ownership.burned) {
1766                 currOwnershipAddr = ownership.addr;
1767             }
1768             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1769                 ownership = _ownershipAt(i);
1770                 if (ownership.burned) {
1771                     continue;
1772                 }
1773                 if (ownership.addr != address(0)) {
1774                     currOwnershipAddr = ownership.addr;
1775                 }
1776                 if (currOwnershipAddr == owner) {
1777                     tokenIds[tokenIdsIdx++] = i;
1778                 }
1779             }
1780             // Downsize the array to fit.
1781             assembly {
1782                 mstore(tokenIds, tokenIdsIdx)
1783             }
1784             return tokenIds;
1785         }
1786     }
1787 
1788     /**
1789      * @dev Returns an array of token IDs owned by `owner`.
1790      *
1791      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1792      * It is meant to be called off-chain.
1793      *
1794      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1795      * multiple smaller scans if the collection is large enough to cause
1796      * an out-of-gas error (10K collections should be fine).
1797      */
1798     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1799         unchecked {
1800             uint256 tokenIdsIdx;
1801             address currOwnershipAddr;
1802             uint256 tokenIdsLength = balanceOf(owner);
1803             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1804             TokenOwnership memory ownership;
1805             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1806                 ownership = _ownershipAt(i);
1807                 if (ownership.burned) {
1808                     continue;
1809                 }
1810                 if (ownership.addr != address(0)) {
1811                     currOwnershipAddr = ownership.addr;
1812                 }
1813                 if (currOwnershipAddr == owner) {
1814                     tokenIds[tokenIdsIdx++] = i;
1815                 }
1816             }
1817             return tokenIds;
1818         }
1819     }
1820 }
1821 
1822 
1823 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.3
1824 
1825 
1826 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1827 
1828 pragma solidity ^0.8.0;
1829 
1830 /**
1831  * @dev String operations.
1832  */
1833 library Strings {
1834     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1835     uint8 private constant _ADDRESS_LENGTH = 20;
1836 
1837     /**
1838      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1839      */
1840     function toString(uint256 value) internal pure returns (string memory) {
1841         // Inspired by OraclizeAPI's implementation - MIT licence
1842         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1843 
1844         if (value == 0) {
1845             return "0";
1846         }
1847         uint256 temp = value;
1848         uint256 digits;
1849         while (temp != 0) {
1850             digits++;
1851             temp /= 10;
1852         }
1853         bytes memory buffer = new bytes(digits);
1854         while (value != 0) {
1855             digits -= 1;
1856             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1857             value /= 10;
1858         }
1859         return string(buffer);
1860     }
1861 
1862     /**
1863      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1864      */
1865     function toHexString(uint256 value) internal pure returns (string memory) {
1866         if (value == 0) {
1867             return "0x00";
1868         }
1869         uint256 temp = value;
1870         uint256 length = 0;
1871         while (temp != 0) {
1872             length++;
1873             temp >>= 8;
1874         }
1875         return toHexString(value, length);
1876     }
1877 
1878     /**
1879      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1880      */
1881     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1882         bytes memory buffer = new bytes(2 * length + 2);
1883         buffer[0] = "0";
1884         buffer[1] = "x";
1885         for (uint256 i = 2 * length + 1; i > 1; --i) {
1886             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1887             value >>= 4;
1888         }
1889         require(value == 0, "Strings: hex length insufficient");
1890         return string(buffer);
1891     }
1892 
1893     /**
1894      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1895      */
1896     function toHexString(address addr) internal pure returns (string memory) {
1897         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1898     }
1899 }
1900 
1901 
1902 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.7.3
1903 
1904 
1905 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
1906 
1907 pragma solidity ^0.8.0;
1908 
1909 /**
1910  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1911  *
1912  * These functions can be used to verify that a message was signed by the holder
1913  * of the private keys of a given address.
1914  */
1915 library ECDSA {
1916     enum RecoverError {
1917         NoError,
1918         InvalidSignature,
1919         InvalidSignatureLength,
1920         InvalidSignatureS,
1921         InvalidSignatureV
1922     }
1923 
1924     function _throwError(RecoverError error) private pure {
1925         if (error == RecoverError.NoError) {
1926             return; // no error: do nothing
1927         } else if (error == RecoverError.InvalidSignature) {
1928             revert("ECDSA: invalid signature");
1929         } else if (error == RecoverError.InvalidSignatureLength) {
1930             revert("ECDSA: invalid signature length");
1931         } else if (error == RecoverError.InvalidSignatureS) {
1932             revert("ECDSA: invalid signature 's' value");
1933         } else if (error == RecoverError.InvalidSignatureV) {
1934             revert("ECDSA: invalid signature 'v' value");
1935         }
1936     }
1937 
1938     /**
1939      * @dev Returns the address that signed a hashed message (`hash`) with
1940      * `signature` or error string. This address can then be used for verification purposes.
1941      *
1942      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1943      * this function rejects them by requiring the `s` value to be in the lower
1944      * half order, and the `v` value to be either 27 or 28.
1945      *
1946      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1947      * verification to be secure: it is possible to craft signatures that
1948      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1949      * this is by receiving a hash of the original message (which may otherwise
1950      * be too long), and then calling {toEthSignedMessageHash} on it.
1951      *
1952      * Documentation for signature generation:
1953      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1954      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1955      *
1956      * _Available since v4.3._
1957      */
1958     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1959         if (signature.length == 65) {
1960             bytes32 r;
1961             bytes32 s;
1962             uint8 v;
1963             // ecrecover takes the signature parameters, and the only way to get them
1964             // currently is to use assembly.
1965             /// @solidity memory-safe-assembly
1966             assembly {
1967                 r := mload(add(signature, 0x20))
1968                 s := mload(add(signature, 0x40))
1969                 v := byte(0, mload(add(signature, 0x60)))
1970             }
1971             return tryRecover(hash, v, r, s);
1972         } else {
1973             return (address(0), RecoverError.InvalidSignatureLength);
1974         }
1975     }
1976 
1977     /**
1978      * @dev Returns the address that signed a hashed message (`hash`) with
1979      * `signature`. This address can then be used for verification purposes.
1980      *
1981      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1982      * this function rejects them by requiring the `s` value to be in the lower
1983      * half order, and the `v` value to be either 27 or 28.
1984      *
1985      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1986      * verification to be secure: it is possible to craft signatures that
1987      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1988      * this is by receiving a hash of the original message (which may otherwise
1989      * be too long), and then calling {toEthSignedMessageHash} on it.
1990      */
1991     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1992         (address recovered, RecoverError error) = tryRecover(hash, signature);
1993         _throwError(error);
1994         return recovered;
1995     }
1996 
1997     /**
1998      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1999      *
2000      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2001      *
2002      * _Available since v4.3._
2003      */
2004     function tryRecover(
2005         bytes32 hash,
2006         bytes32 r,
2007         bytes32 vs
2008     ) internal pure returns (address, RecoverError) {
2009         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
2010         uint8 v = uint8((uint256(vs) >> 255) + 27);
2011         return tryRecover(hash, v, r, s);
2012     }
2013 
2014     /**
2015      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2016      *
2017      * _Available since v4.2._
2018      */
2019     function recover(
2020         bytes32 hash,
2021         bytes32 r,
2022         bytes32 vs
2023     ) internal pure returns (address) {
2024         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2025         _throwError(error);
2026         return recovered;
2027     }
2028 
2029     /**
2030      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2031      * `r` and `s` signature fields separately.
2032      *
2033      * _Available since v4.3._
2034      */
2035     function tryRecover(
2036         bytes32 hash,
2037         uint8 v,
2038         bytes32 r,
2039         bytes32 s
2040     ) internal pure returns (address, RecoverError) {
2041         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2042         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2043         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2044         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2045         //
2046         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2047         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2048         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2049         // these malleable signatures as well.
2050         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2051             return (address(0), RecoverError.InvalidSignatureS);
2052         }
2053         if (v != 27 && v != 28) {
2054             return (address(0), RecoverError.InvalidSignatureV);
2055         }
2056 
2057         // If the signature is valid (and not malleable), return the signer address
2058         address signer = ecrecover(hash, v, r, s);
2059         if (signer == address(0)) {
2060             return (address(0), RecoverError.InvalidSignature);
2061         }
2062 
2063         return (signer, RecoverError.NoError);
2064     }
2065 
2066     /**
2067      * @dev Overload of {ECDSA-recover} that receives the `v`,
2068      * `r` and `s` signature fields separately.
2069      */
2070     function recover(
2071         bytes32 hash,
2072         uint8 v,
2073         bytes32 r,
2074         bytes32 s
2075     ) internal pure returns (address) {
2076         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2077         _throwError(error);
2078         return recovered;
2079     }
2080 
2081     /**
2082      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2083      * produces hash corresponding to the one signed with the
2084      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2085      * JSON-RPC method as part of EIP-191.
2086      *
2087      * See {recover}.
2088      */
2089     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2090         // 32 is the length in bytes of hash,
2091         // enforced by the type signature above
2092         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2093     }
2094 
2095     /**
2096      * @dev Returns an Ethereum Signed Message, created from `s`. This
2097      * produces hash corresponding to the one signed with the
2098      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2099      * JSON-RPC method as part of EIP-191.
2100      *
2101      * See {recover}.
2102      */
2103     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2104         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2105     }
2106 
2107     /**
2108      * @dev Returns an Ethereum Signed Typed Data, created from a
2109      * `domainSeparator` and a `structHash`. This produces hash corresponding
2110      * to the one signed with the
2111      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2112      * JSON-RPC method as part of EIP-712.
2113      *
2114      * See {recover}.
2115      */
2116     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2117         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2118     }
2119 }
2120 
2121 
2122 // File contracts/TestMarketplace1.sol
2123 
2124 
2125 pragma solidity ^0.8.0;
2126 contract Woodlanderz_SmartContract is ERC721A, ERC721AQueryable, Ownable, ReentrancyGuard {
2127 	
2128 	using ECDSA for bytes32;
2129 	
2130 	/*
2131 	 * Variables 
2132 	 */
2133 	struct Settings {
2134 		uint256 whitelist1Price;
2135 		uint256 whitelist2Price;
2136 		uint256 whitelist3Price;
2137 		
2138 		uint256 whitelist1MaxCount;
2139 		uint256 whitelist2MaxCount;
2140 		uint256 whitelist3MaxCount;
2141 		
2142 		uint256 publicPrice;
2143 		uint256 publicMaxCount;
2144 		
2145 		uint256 holderRatio;
2146 	}
2147 	
2148 	struct Signers {
2149 		address signerAddress1;
2150 		address signerAddress2;
2151 		address signerAddress3;
2152 		address signerAddress4;
2153 	}
2154 	
2155 	Settings public settings;
2156 	
2157 	Signers public signers;
2158 	
2159 	string public unrevealedTokenURI;
2160 
2161     string public baseTokenURI;
2162 	
2163 	uint256 public constant MAX_SUPPLY = 7777;
2164 	
2165 	uint256 public constant MAX_VAULT_MINT = 77;
2166 	
2167 	uint256 public vaultMinted;
2168 	
2169 	mapping(address => bool) public freeHolderAddresses;
2170 	
2171 	bool public isRevealed;
2172 	bool public isPresaled;
2173 	bool public isPaused;
2174 	bool public isPublicMint;
2175 	bool public isHolderFreeMint;
2176 	
2177 	/*
2178 	 * Modiefiers
2179 	 */
2180 	modifier callerIsUser() {
2181         require(tx.origin == msg.sender, "The caller is another contract");
2182         _;
2183     }
2184 	
2185     constructor() ERC721A("Woodlanderz", "WDLZ") {
2186 
2187 	}
2188 
2189     function whitelist1Mint(uint256 quantity, bytes memory signature) external payable callerIsUser {
2190         
2191 		require(!isPaused, "Not Yet Active.");
2192 		require(isPresaled, "Presaled mint is disabled.");
2193 		require(recoverSigner(signature) == signers.signerAddress1, "Address is not allowlisted");
2194 		require(((_numberMinted(msg.sender) + quantity) <= settings.whitelist1MaxCount), "Illegal count NFTs");
2195 		require((totalSupply() + quantity) <= MAX_SUPPLY, "Total supply exceeded!");
2196 		require(msg.value >= (settings.whitelist1Price * quantity), "Payment is below the price");
2197 		
2198         _safeMint(msg.sender, quantity);
2199     }
2200 	
2201 	function whitelist2Mint(uint256 quantity, bytes memory signature) external payable callerIsUser {
2202         
2203 		require(!isPaused, "Not Yet Active.");
2204 		require(isPresaled, "Presaled mint is disabled.");
2205 		require(recoverSigner(signature) == signers.signerAddress2, "Address is not allowlisted");
2206 		require(((_numberMinted(msg.sender) + quantity) <= settings.whitelist2MaxCount), "Illegal count NFTs");
2207 		require((totalSupply() + quantity) <= MAX_SUPPLY, "Total supply exceeded!");
2208 		require(msg.value >= (settings.whitelist2Price * quantity), "Payment is below the price");
2209 		
2210         _safeMint(msg.sender, quantity);
2211     }
2212 	
2213 	function whitelist3Mint(uint256 quantity, bytes memory signature) external payable callerIsUser {
2214         
2215 		require(!isPaused, "Not Yet Active.");
2216 		require(recoverSigner(signature) == signers.signerAddress3, "Address is not allowlisted");
2217 		require(((_numberMinted(msg.sender) + quantity) <= settings.whitelist3MaxCount), "Illegal count NFTs");
2218 		require((totalSupply() + quantity) <= MAX_SUPPLY, "Total supply exceeded!");
2219 		require(msg.value >= (settings.whitelist3Price * quantity), "Payment is below the price");
2220 		
2221         _safeMint(msg.sender, quantity);
2222     }
2223 	
2224 	function holderMint(bytes memory signature) external callerIsUser {
2225         
2226 		require(!isPaused, "Not Yet Active.");
2227 		require(isHolderFreeMint, "Holder free mint is disabled.");
2228 		require(!freeHolderAddresses[msg.sender], "Free Holder mint has been used");
2229 		require(recoverSigner(signature) == signers.signerAddress4, "Address is not allowlisted");
2230 		
2231 		uint256 availableNewNFT = settings.holderRatio * balanceOf(msg.sender);
2232 		
2233 		require((availableNewNFT > 0), "Incorrect number of NFTs");
2234 		require((totalSupply() + availableNewNFT) <= MAX_SUPPLY, "Total supply exceeded!");
2235 		
2236 		for(uint i = 0; i < availableNewNFT; i = i + 10) {
2237 			if((i + 10) >= availableNewNFT) {
2238 				_safeMint(msg.sender, (availableNewNFT - i));
2239 			} else {
2240 				_safeMint(msg.sender, 10);
2241 			}
2242 		}
2243 		
2244 		freeHolderAddresses[msg.sender] = true;
2245     }
2246 	
2247 	function publicMint(uint256 quantity) external payable callerIsUser {
2248 		
2249 		require(!isPaused, "Not Yet Active.");
2250 		require(isPublicMint, "Public mint is disabled.");
2251 		require((quantity <= settings.publicMaxCount), "Illegal count NFTs");
2252 		require((totalSupply() + quantity) <= MAX_SUPPLY, "Total supply exceeded!");
2253 		require(msg.value >= (settings.publicPrice * quantity), "Payment is below the price");
2254 		
2255 		_safeMint(msg.sender, quantity);
2256 	}
2257 	
2258 	function numberMinted(address owner) public view returns (uint256) {
2259 		
2260 		return _numberMinted(owner);
2261 	}
2262 	
2263 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2264 		
2265         require(_exists(tokenId), "URI query for nonexistent token");
2266 
2267         if(!isRevealed){
2268 			return bytes(unrevealedTokenURI).length > 0 ? string(abi.encodePacked(unrevealedTokenURI, _toString(tokenId), ".json")) : "";
2269         } else {
2270 			return bytes(baseTokenURI).length > 0 ? string(abi.encodePacked(baseTokenURI, _toString(tokenId), ".json")) : "";
2271 		}
2272     }
2273 	
2274 	function _baseURI() internal view virtual override returns (string memory) {
2275 		
2276 		return baseTokenURI;
2277 	}
2278 	
2279 	function setBaseTokenUri(string memory baseURI) external onlyOwner {
2280 		
2281 		baseTokenURI = baseURI;
2282 	}
2283 	
2284 	function setPlaceholderTokenUri(string memory unrevealedURI) external onlyOwner {
2285 		
2286 		unrevealedTokenURI = unrevealedURI;
2287 	}
2288 	
2289 	function setRevealed() external onlyOwner {
2290 		
2291 		isRevealed = true;
2292 	}
2293 	
2294 	function togglePresale() external onlyOwner {
2295 		
2296 		isPresaled = !isPresaled;
2297 	}
2298 	
2299 	function togglePause() external onlyOwner {
2300 		
2301 		isPaused = !isPaused;
2302 	}
2303 	
2304 	function togglePublicMint() external onlyOwner {
2305 		
2306 		isPublicMint = !isPublicMint;
2307 	}
2308 	
2309 	function toggleHolderFreeMint() external onlyOwner {
2310 		
2311 		isHolderFreeMint = !isHolderFreeMint;
2312 	}
2313 
2314 	function recoverSigner(bytes memory signature)
2315         private
2316         view
2317         returns (address)
2318     {
2319         bytes32 messageDigest = keccak256(
2320             abi.encodePacked(
2321                 "\x19Ethereum Signed Message:\n32",
2322                 keccak256(abi.encodePacked(msg.sender))
2323             )
2324         );
2325         return messageDigest.recover(signature);
2326     }
2327 	
2328 	function setSettings(uint256 _whitelist1Price, 
2329 						 uint256 _whitelist2Price, 
2330 						 uint256 _whitelist3Price, 
2331 						 uint256 _whitelist1MaxCount, 
2332 						 uint256 _whitelist2MaxCount, 
2333 						 uint256 _whitelist3MaxCount, 
2334 						 uint256 _publicPrice, 
2335 						 uint256 _publicMaxCount, 
2336 						 uint256 _holderRatio
2337 						 ) external onlyOwner {
2338 	
2339 		settings.whitelist1Price = _whitelist1Price;
2340 		settings.whitelist2Price = _whitelist2Price;
2341 		settings.whitelist3Price = _whitelist3Price;
2342 	
2343 		settings.whitelist1MaxCount = _whitelist1MaxCount;
2344 		settings.whitelist2MaxCount = _whitelist2MaxCount;
2345 		settings.whitelist3MaxCount = _whitelist3MaxCount;
2346 	
2347 		settings.publicPrice = _publicPrice;
2348 		settings.publicMaxCount = _publicMaxCount;
2349 		
2350 		settings.holderRatio = _holderRatio;
2351 	}
2352 	
2353 	function setSigners(address _signerAddress1, address _signerAddress2, address _signerAddress3, address _signerAddress4) external onlyOwner {
2354 		
2355 		signers.signerAddress1 = _signerAddress1;
2356 		signers.signerAddress2 = _signerAddress2;
2357 		signers.signerAddress3 = _signerAddress3;
2358 		signers.signerAddress4 = _signerAddress4;
2359 	}
2360 
2361 	function vaultMint(uint256 quantity, address receiver) external onlyOwner {
2362 		
2363 		require((totalSupply() + quantity) <= MAX_SUPPLY, "Total supply exceeded!");
2364 		require((vaultMinted + quantity) <= MAX_VAULT_MINT , "Max vault minted exceeded!");
2365 		
2366 		for(uint i = 0; i < quantity; i = i + 10) {
2367 			if((i + 10) >= quantity) {
2368 				_safeMint(receiver, (quantity - i));
2369 			} else {
2370 				_safeMint(receiver, 10);
2371 			}
2372 		}
2373 		
2374 		vaultMinted += quantity;
2375 	}
2376 	
2377 	function withdraw(uint256 amountPercent, address receiver) external onlyOwner nonReentrant {
2378 		
2379 		require((amountPercent <= 100), "The maximum value is 100 percent");
2380 		
2381         uint256 withdrawAmount = address(this).balance * amountPercent / 100;
2382 		
2383 		(bool succ1, ) = payable(receiver).call{value: withdrawAmount}("");
2384         require(succ1, "Transfer receiver failed");
2385 		
2386 		(bool succ2, ) = payable(msg.sender).call{value: address(this).balance}("");
2387         require(succ2, "Transfer market failed");
2388 	}
2389 }