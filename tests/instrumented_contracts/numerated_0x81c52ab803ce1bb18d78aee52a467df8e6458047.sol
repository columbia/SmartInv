1 /*
2               ███████╗ █████╗ ████████╗ ██████╗       ███████╗ █████╗ ███╗   ██╗
3               ██╔════╝██╔══██╗╚══██╔══╝██╔═══██╗      ██╔════╝██╔══██╗████╗  ██║
4               ███████╗███████║   ██║   ██║   ██║█████╗███████╗███████║██╔██╗ ██║
5               ╚════██║██╔══██║   ██║   ██║   ██║╚════╝╚════██║██╔══██║██║╚██╗██║
6               ███████║██║  ██║   ██║   ╚██████╔╝      ███████║██║  ██║██║ ╚████║
7               ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝       ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝
8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
9 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
10 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
11 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
12 %%%%%%%%%%%%%%%%%%%%%%%%      %%%%%%%   #%%%%%%%%%.   %%%%%%%%%%%%%%%%%%%%%%%%%%
13 %%%%%%%%%%%%%%%%%%%%%%%%      %%%%%%%   #%%%%%%%%%.   %%%%%%%%%%%%%%%%%%%%%%%%%%
14 %%%%%%%%%%%%%%%%%%%%%%%%%%%                       #%%%   %%%%%%%%%%%%%%%%%%%%%%%
15 %%%%%%%%%%%%%%%%%%%%%%%%                              %%%%%%.   %%%%%%%%%%%%%%%%
16 %%%%%%%%%%%%%%%%%                                           #%%%%%%%%%%%%%%%%%%%
17 %%%%%%%%%%%%%%%%%                                           #%%%%%%%%%%%%%%%%%%%
18 %%%%%%%%%%%%%%   %%%          ....                              %%%%%%%%%%%%%%%%
19 %%%%%%%%%%%%%%%%%%%%       .......   .......   ...                 %%%%%%%%%%%%%
20 %%%%%%%%%%%%%%%%%       @@@@@@..........&@@@@@@@@@.                %%%%%%%%%%%%%
21 %%%%%%%%%%%%%%%%%       @@@@@@,.........@@@@@@@@@@.                %%%%%%%%%%%%%
22 %%%%%%%%%%%%%%%%%%%%..................................   ...    %%%%%%%%%%%%%%%%
23 %%%%%%%%%%%%%%%%%**********(((@@@@@@@@@@/*********((((@@@@@@@@@@%%%%%%%%%%%%%%%%
24 %%%%%%%%%%%%%%%%%**********.............**********.......@@@@@@@%%%%%%%%%%%%%%%%
25 %%%%%%%%%%%%%%%%%**********.............**********.......@@@@@@@%%%%%%%%%%%%%%%%
26 %%%%%%%%%%%%%%%%%%%%..............@@@.................@@@@@@%%%%%%%%%%%%%%%%%%%%
27 %%%%%%%%%%%%%%%%%%%%..............@@@.................@@@%%%%%%%%%%%%%%%%%%%%%%%
28 %%%%%%%%%%%%%%%%%%%%%%%%..............................@@@%%%%%%%%%%%%%%%%%%%%%%%
29 %%%%%%%%%%%%%%%%%%%%%%%%..............................@@@%%%%%%%%%%%%%%%%%%%%%%%
30 %%%%%%%%%%%%%%%%%%%%%%%%..............................@@@%%%%%%%%%%%%%%%%%%%%%%%
31 %%%%%%%%%%%%%%%%%%%%%%%%............(´-ι_-｀).....&@@@@@@%%%%%%%%%%%%%%%%%%%%%%%
32 %%%%%%%%%%%%%%%%%%%%%%%%@@@....................@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%
33 %%%%%%%%%%%%%%%%%%%%%%%%@@@....................@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%
34 %%%%%%%%%%%%%%%%%%%%%%%%%%%@@@##########@@@@@@@@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%
35 %%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@......&@@@%%%%%%%%%%%%%%%%%%%%%%%%%%
36 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%................&@@@%%%%%%%%%%%%%%%%%%%%%%%%%%
37 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%................&@@@%%%%%%%%%%%%%%%%%%%%%%%%%%
38 %%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@................&@@@@@@@@@@@@@@@@%%%%%%%%%%%%%
39 %%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%                                                            
40 */
41 // SPDX-License-Identifier: MIT
42 // File: @openzeppelin/contracts/utils/Context.sol
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev Provides information about the current execution context, including the
51  * sender of the transaction and its data. While these are generally available
52  * via msg.sender and msg.data, they should not be accessed in such a direct
53  * manner, since when dealing with meta-transactions the account sending and
54  * paying for execution may not be the actual sender (as far as an application
55  * is concerned).
56  *
57  * This contract is only required for intermediate, library-like contracts.
58  */
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes calldata) {
65         return msg.data;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/access/Ownable.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 
77 /**
78  * @dev Contract module which provides a basic access control mechanism, where
79  * there is an account (an owner) that can be granted exclusive access to
80  * specific functions.
81  *
82  * By default, the owner account will be the one that deploys the contract. This
83  * can later be changed with {transferOwnership}.
84  *
85  * This module is used through inheritance. It will make available the modifier
86  * `onlyOwner`, which can be applied to your functions to restrict their use to
87  * the owner.
88  */
89 abstract contract Ownable is Context {
90     address private _owner;
91 
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     /**
95      * @dev Initializes the contract setting the deployer as the initial owner.
96      */
97     constructor() {
98         _transferOwnership(_msgSender());
99     }
100 
101     /**
102      * @dev Returns the address of the current owner.
103      */
104     function owner() public view virtual returns (address) {
105         return _owner;
106     }
107 
108     /**
109      * @dev Throws if called by any account other than the owner.
110      */
111     modifier onlyOwner() {
112         require(owner() == _msgSender(), "Ownable: caller is not the owner");
113         _;
114     }
115 
116     /**
117      * @dev Leaves the contract without owner. It will not be possible to call
118      * `onlyOwner` functions anymore. Can only be called by the current owner.
119      *
120      * NOTE: Renouncing ownership will leave the contract without an owner,
121      * thereby removing any functionality that is only available to the owner.
122      */
123     function renounceOwnership() public virtual onlyOwner {
124         _transferOwnership(address(0));
125     }
126 
127     /**
128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
129      * Can only be called by the current owner.
130      */
131     function transferOwnership(address newOwner) public virtual onlyOwner {
132         require(newOwner != address(0), "Ownable: new owner is the zero address");
133         _transferOwnership(newOwner);
134     }
135 
136     /**
137      * @dev Transfers ownership of the contract to a new account (`newOwner`).
138      * Internal function without access restriction.
139      */
140     function _transferOwnership(address newOwner) internal virtual {
141         address oldOwner = _owner;
142         _owner = newOwner;
143         emit OwnershipTransferred(oldOwner, newOwner);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Contract module that helps prevent reentrant calls to a function.
156  *
157  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
158  * available, which can be applied to functions to make sure there are no nested
159  * (reentrant) calls to them.
160  *
161  * Note that because there is a single `nonReentrant` guard, functions marked as
162  * `nonReentrant` may not call one another. This can be worked around by making
163  * those functions `private`, and then adding `external` `nonReentrant` entry
164  * points to them.
165  *
166  * TIP: If you would like to learn more about reentrancy and alternative ways
167  * to protect against it, check out our blog post
168  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
169  */
170 abstract contract ReentrancyGuard {
171     // Booleans are more expensive than uint256 or any type that takes up a full
172     // word because each write operation emits an extra SLOAD to first read the
173     // slot's contents, replace the bits taken up by the boolean, and then write
174     // back. This is the compiler's defense against contract upgrades and
175     // pointer aliasing, and it cannot be disabled.
176 
177     // The values being non-zero value makes deployment a bit more expensive,
178     // but in exchange the refund on every call to nonReentrant will be lower in
179     // amount. Since refunds are capped to a percentage of the total
180     // transaction's gas, it is best to keep them low in cases like this one, to
181     // increase the likelihood of the full refund coming into effect.
182     uint256 private constant _NOT_ENTERED = 1;
183     uint256 private constant _ENTERED = 2;
184 
185     uint256 private _status;
186 
187     constructor() {
188         _status = _NOT_ENTERED;
189     }
190 
191     /**
192      * @dev Prevents a contract from calling itself, directly or indirectly.
193      * Calling a `nonReentrant` function from another `nonReentrant`
194      * function is not supported. It is possible to prevent this from happening
195      * by making the `nonReentrant` function external, and making it call a
196      * `private` function that does the actual work.
197      */
198     modifier nonReentrant() {
199         // On the first call to nonReentrant, _notEntered will be true
200         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
201 
202         // Any calls to nonReentrant after this point will fail
203         _status = _ENTERED;
204 
205         _;
206 
207         // By storing the original value once again, a refund is triggered (see
208         // https://eips.ethereum.org/EIPS/eip-2200)
209         _status = _NOT_ENTERED;
210     }
211 }
212 
213 // File: erc721a/contracts/IERC721A.sol
214 
215 
216 // ERC721A Contracts v4.1.0
217 // Creator: Chiru Labs
218 
219 pragma solidity ^0.8.4;
220 
221 /**
222  * @dev Interface of an ERC721A compliant contract.
223  */
224 interface IERC721A {
225     /**
226      * The caller must own the token or be an approved operator.
227      */
228     error ApprovalCallerNotOwnerNorApproved();
229 
230     /**
231      * The token does not exist.
232      */
233     error ApprovalQueryForNonexistentToken();
234 
235     /**
236      * The caller cannot approve to their own address.
237      */
238     error ApproveToCaller();
239 
240     /**
241      * Cannot query the balance for the zero address.
242      */
243     error BalanceQueryForZeroAddress();
244 
245     /**
246      * Cannot mint to the zero address.
247      */
248     error MintToZeroAddress();
249 
250     /**
251      * The quantity of tokens minted must be more than zero.
252      */
253     error MintZeroQuantity();
254 
255     /**
256      * The token does not exist.
257      */
258     error OwnerQueryForNonexistentToken();
259 
260     /**
261      * The caller must own the token or be an approved operator.
262      */
263     error TransferCallerNotOwnerNorApproved();
264 
265     /**
266      * The token must be owned by `from`.
267      */
268     error TransferFromIncorrectOwner();
269 
270     /**
271      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
272      */
273     error TransferToNonERC721ReceiverImplementer();
274 
275     /**
276      * Cannot transfer to the zero address.
277      */
278     error TransferToZeroAddress();
279 
280     /**
281      * The token does not exist.
282      */
283     error URIQueryForNonexistentToken();
284 
285     /**
286      * The `quantity` minted with ERC2309 exceeds the safety limit.
287      */
288     error MintERC2309QuantityExceedsLimit();
289 
290     /**
291      * The `extraData` cannot be set on an unintialized ownership slot.
292      */
293     error OwnershipNotInitializedForExtraData();
294 
295     struct TokenOwnership {
296         // The address of the owner.
297         address addr;
298         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
299         uint64 startTimestamp;
300         // Whether the token has been burned.
301         bool burned;
302         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
303         uint24 extraData;
304     }
305 
306     /**
307      * @dev Returns the total amount of tokens stored by the contract.
308      *
309      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
310      */
311     function totalSupply() external view returns (uint256);
312 
313     // ==============================
314     //            IERC165
315     // ==============================
316 
317     /**
318      * @dev Returns true if this contract implements the interface defined by
319      * `interfaceId`. See the corresponding
320      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
321      * to learn more about how these ids are created.
322      *
323      * This function call must use less than 30 000 gas.
324      */
325     function supportsInterface(bytes4 interfaceId) external view returns (bool);
326 
327     // ==============================
328     //            IERC721
329     // ==============================
330 
331     /**
332      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
333      */
334     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
335 
336     /**
337      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
338      */
339     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
340 
341     /**
342      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
343      */
344     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
345 
346     /**
347      * @dev Returns the number of tokens in ``owner``'s account.
348      */
349     function balanceOf(address owner) external view returns (uint256 balance);
350 
351     /**
352      * @dev Returns the owner of the `tokenId` token.
353      *
354      * Requirements:
355      *
356      * - `tokenId` must exist.
357      */
358     function ownerOf(uint256 tokenId) external view returns (address owner);
359 
360     /**
361      * @dev Safely transfers `tokenId` token from `from` to `to`.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `tokenId` token must exist and be owned by `from`.
368      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
369      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
370      *
371      * Emits a {Transfer} event.
372      */
373     function safeTransferFrom(
374         address from,
375         address to,
376         uint256 tokenId,
377         bytes calldata data
378     ) external;
379 
380     /**
381      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
382      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
383      *
384      * Requirements:
385      *
386      * - `from` cannot be the zero address.
387      * - `to` cannot be the zero address.
388      * - `tokenId` token must exist and be owned by `from`.
389      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
391      *
392      * Emits a {Transfer} event.
393      */
394     function safeTransferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) external;
399 
400     /**
401      * @dev Transfers `tokenId` token from `from` to `to`.
402      *
403      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must be owned by `from`.
410      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
411      *
412      * Emits a {Transfer} event.
413      */
414     function transferFrom(
415         address from,
416         address to,
417         uint256 tokenId
418     ) external;
419 
420     /**
421      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
422      * The approval is cleared when the token is transferred.
423      *
424      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
425      *
426      * Requirements:
427      *
428      * - The caller must own the token or be an approved operator.
429      * - `tokenId` must exist.
430      *
431      * Emits an {Approval} event.
432      */
433     function approve(address to, uint256 tokenId) external;
434 
435     /**
436      * @dev Approve or remove `operator` as an operator for the caller.
437      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
438      *
439      * Requirements:
440      *
441      * - The `operator` cannot be the caller.
442      *
443      * Emits an {ApprovalForAll} event.
444      */
445     function setApprovalForAll(address operator, bool _approved) external;
446 
447     /**
448      * @dev Returns the account approved for `tokenId` token.
449      *
450      * Requirements:
451      *
452      * - `tokenId` must exist.
453      */
454     function getApproved(uint256 tokenId) external view returns (address operator);
455 
456     /**
457      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
458      *
459      * See {setApprovalForAll}
460      */
461     function isApprovedForAll(address owner, address operator) external view returns (bool);
462 
463     // ==============================
464     //        IERC721Metadata
465     // ==============================
466 
467     /**
468      * @dev Returns the token collection name.
469      */
470     function name() external view returns (string memory);
471 
472     /**
473      * @dev Returns the token collection symbol.
474      */
475     function symbol() external view returns (string memory);
476 
477     /**
478      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
479      */
480     function tokenURI(uint256 tokenId) external view returns (string memory);
481 
482     // ==============================
483     //            IERC2309
484     // ==============================
485 
486     /**
487      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
488      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
489      */
490     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
491 }
492 
493 // File: erc721a/contracts/ERC721A.sol
494 
495 
496 // ERC721A Contracts v4.1.0
497 // Creator: Chiru Labs
498 
499 pragma solidity ^0.8.4;
500 
501 
502 /**
503  * @dev ERC721 token receiver interface.
504  */
505 interface ERC721A__IERC721Receiver {
506     function onERC721Received(
507         address operator,
508         address from,
509         uint256 tokenId,
510         bytes calldata data
511     ) external returns (bytes4);
512 }
513 
514 /**
515  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
516  * including the Metadata extension. Built to optimize for lower gas during batch mints.
517  *
518  * Assumes serials are sequentially minted starting at `_startTokenId()`
519  * (defaults to 0, e.g. 0, 1, 2, 3..).
520  *
521  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
522  *
523  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
524  */
525 contract ERC721A is IERC721A {
526     // Mask of an entry in packed address data.
527     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
528 
529     // The bit position of `numberMinted` in packed address data.
530     uint256 private constant BITPOS_NUMBER_MINTED = 64;
531 
532     // The bit position of `numberBurned` in packed address data.
533     uint256 private constant BITPOS_NUMBER_BURNED = 128;
534 
535     // The bit position of `aux` in packed address data.
536     uint256 private constant BITPOS_AUX = 192;
537 
538     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
539     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
540 
541     // The bit position of `startTimestamp` in packed ownership.
542     uint256 private constant BITPOS_START_TIMESTAMP = 160;
543 
544     // The bit mask of the `burned` bit in packed ownership.
545     uint256 private constant BITMASK_BURNED = 1 << 224;
546 
547     // The bit position of the `nextInitialized` bit in packed ownership.
548     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
549 
550     // The bit mask of the `nextInitialized` bit in packed ownership.
551     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
552 
553     // The bit position of `extraData` in packed ownership.
554     uint256 private constant BITPOS_EXTRA_DATA = 232;
555 
556     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
557     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
558 
559     // The mask of the lower 160 bits for addresses.
560     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
561 
562     // The maximum `quantity` that can be minted with `_mintERC2309`.
563     // This limit is to prevent overflows on the address data entries.
564     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
565     // is required to cause an overflow, which is unrealistic.
566     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
567 
568     // The tokenId of the next token to be minted.
569     uint256 private _currentIndex;
570 
571     // The number of tokens burned.
572     uint256 private _burnCounter;
573 
574     // Token name
575     string private _name;
576 
577     // Token symbol
578     string private _symbol;
579 
580     // Mapping from token ID to ownership details
581     // An empty struct value does not necessarily mean the token is unowned.
582     // See `_packedOwnershipOf` implementation for details.
583     //
584     // Bits Layout:
585     // - [0..159]   `addr`
586     // - [160..223] `startTimestamp`
587     // - [224]      `burned`
588     // - [225]      `nextInitialized`
589     // - [232..255] `extraData`
590     mapping(uint256 => uint256) private _packedOwnerships;
591 
592     // Mapping owner address to address data.
593     //
594     // Bits Layout:
595     // - [0..63]    `balance`
596     // - [64..127]  `numberMinted`
597     // - [128..191] `numberBurned`
598     // - [192..255] `aux`
599     mapping(address => uint256) private _packedAddressData;
600 
601     // Mapping from token ID to approved address.
602     mapping(uint256 => address) private _tokenApprovals;
603 
604     // Mapping from owner to operator approvals
605     mapping(address => mapping(address => bool)) private _operatorApprovals;
606 
607     constructor(string memory name_, string memory symbol_) {
608         _name = name_;
609         _symbol = symbol_;
610         _currentIndex = _startTokenId();
611     }
612 
613     /**
614      * @dev Returns the starting token ID.
615      * To change the starting token ID, please override this function.
616      */
617     function _startTokenId() internal view virtual returns (uint256) {
618         return 1;
619     }
620 
621     /**
622      * @dev Returns the next token ID to be minted.
623      */
624     function _nextTokenId() internal view returns (uint256) {
625         return _currentIndex;
626     }
627 
628     /**
629      * @dev Returns the total number of tokens in existence.
630      * Burned tokens will reduce the count.
631      * To get the total number of tokens minted, please see `_totalMinted`.
632      */
633     function totalSupply() public view override returns (uint256) {
634         // Counter underflow is impossible as _burnCounter cannot be incremented
635         // more than `_currentIndex - _startTokenId()` times.
636         unchecked {
637             return _currentIndex - _burnCounter - _startTokenId();
638         }
639     }
640 
641     /**
642      * @dev Returns the total amount of tokens minted in the contract.
643      */
644     function _totalMinted() internal view returns (uint256) {
645         // Counter underflow is impossible as _currentIndex does not decrement,
646         // and it is initialized to `_startTokenId()`
647         unchecked {
648             return _currentIndex - _startTokenId();
649         }
650     }
651 
652     /**
653      * @dev Returns the total number of tokens burned.
654      */
655     function _totalBurned() internal view returns (uint256) {
656         return _burnCounter;
657     }
658 
659     /**
660      * @dev See {IERC165-supportsInterface}.
661      */
662     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
663         // The interface IDs are constants representing the first 4 bytes of the XOR of
664         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
665         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
666         return
667             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
668             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
669             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
670     }
671 
672     /**
673      * @dev See {IERC721-balanceOf}.
674      */
675     function balanceOf(address owner) public view override returns (uint256) {
676         if (owner == address(0)) revert BalanceQueryForZeroAddress();
677         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
678     }
679 
680     /**
681      * Returns the number of tokens minted by `owner`.
682      */
683     function _numberMinted(address owner) internal view returns (uint256) {
684         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
685     }
686 
687     /**
688      * Returns the number of tokens burned by or on behalf of `owner`.
689      */
690     function _numberBurned(address owner) internal view returns (uint256) {
691         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
692     }
693 
694     /**
695      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
696      */
697     function _getAux(address owner) internal view returns (uint64) {
698         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
699     }
700 
701     /**
702      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
703      * If there are multiple variables, please pack them into a uint64.
704      */
705     function _setAux(address owner, uint64 aux) internal {
706         uint256 packed = _packedAddressData[owner];
707         uint256 auxCasted;
708         // Cast `aux` with assembly to avoid redundant masking.
709         assembly {
710             auxCasted := aux
711         }
712         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
713         _packedAddressData[owner] = packed;
714     }
715 
716     /**
717      * Returns the packed ownership data of `tokenId`.
718      */
719     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
720         uint256 curr = tokenId;
721 
722         unchecked {
723             if (_startTokenId() <= curr)
724                 if (curr < _currentIndex) {
725                     uint256 packed = _packedOwnerships[curr];
726                     // If not burned.
727                     if (packed & BITMASK_BURNED == 0) {
728                         // Invariant:
729                         // There will always be an ownership that has an address and is not burned
730                         // before an ownership that does not have an address and is not burned.
731                         // Hence, curr will not underflow.
732                         //
733                         // We can directly compare the packed value.
734                         // If the address is zero, packed is zero.
735                         while (packed == 0) {
736                             packed = _packedOwnerships[--curr];
737                         }
738                         return packed;
739                     }
740                 }
741         }
742         revert OwnerQueryForNonexistentToken();
743     }
744 
745     /**
746      * Returns the unpacked `TokenOwnership` struct from `packed`.
747      */
748     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
749         ownership.addr = address(uint160(packed));
750         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
751         ownership.burned = packed & BITMASK_BURNED != 0;
752         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
753     }
754 
755     /**
756      * Returns the unpacked `TokenOwnership` struct at `index`.
757      */
758     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
759         return _unpackedOwnership(_packedOwnerships[index]);
760     }
761 
762     /**
763      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
764      */
765     function _initializeOwnershipAt(uint256 index) internal {
766         if (_packedOwnerships[index] == 0) {
767             _packedOwnerships[index] = _packedOwnershipOf(index);
768         }
769     }
770 
771     /**
772      * Gas spent here starts off proportional to the maximum mint batch size.
773      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
774      */
775     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
776         return _unpackedOwnership(_packedOwnershipOf(tokenId));
777     }
778 
779     /**
780      * @dev Packs ownership data into a single uint256.
781      */
782     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
783         assembly {
784             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
785             owner := and(owner, BITMASK_ADDRESS)
786             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
787             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
788         }
789     }
790 
791     /**
792      * @dev See {IERC721-ownerOf}.
793      */
794     function ownerOf(uint256 tokenId) public view override returns (address) {
795         return address(uint160(_packedOwnershipOf(tokenId)));
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-name}.
800      */
801     function name() public view virtual override returns (string memory) {
802         return _name;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-symbol}.
807      */
808     function symbol() public view virtual override returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-tokenURI}.
814      */
815     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
816         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
817 
818         string memory baseURI = _baseURI();
819         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
820     }
821 
822     /**
823      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
824      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
825      * by default, it can be overridden in child contracts.
826      */
827     function _baseURI() internal view virtual returns (string memory) {
828         return '';
829     }
830 
831     /**
832      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
833      */
834     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
835         // For branchless setting of the `nextInitialized` flag.
836         assembly {
837             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
838             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
839         }
840     }
841 
842     /**
843      * @dev See {IERC721-approve}.
844      */
845     function approve(address to, uint256 tokenId) public override {
846         address owner = ownerOf(tokenId);
847 
848         if (_msgSenderERC721A() != owner)
849             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
850                 revert ApprovalCallerNotOwnerNorApproved();
851             }
852 
853         _tokenApprovals[tokenId] = to;
854         emit Approval(owner, to, tokenId);
855     }
856 
857     /**
858      * @dev See {IERC721-getApproved}.
859      */
860     function getApproved(uint256 tokenId) public view override returns (address) {
861         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
862 
863         return _tokenApprovals[tokenId];
864     }
865 
866     /**
867      * @dev See {IERC721-setApprovalForAll}.
868      */
869     function setApprovalForAll(address operator, bool approved) public virtual override {
870         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
871 
872         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
873         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
874     }
875 
876     /**
877      * @dev See {IERC721-isApprovedForAll}.
878      */
879     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
880         return _operatorApprovals[owner][operator];
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         safeTransferFrom(from, to, tokenId, '');
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) public virtual override {
903         transferFrom(from, to, tokenId);
904         if (to.code.length != 0)
905             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
906                 revert TransferToNonERC721ReceiverImplementer();
907             }
908     }
909 
910     /**
911      * @dev Returns whether `tokenId` exists.
912      *
913      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
914      *
915      * Tokens start existing when they are minted (`_mint`),
916      */
917     function _exists(uint256 tokenId) internal view returns (bool) {
918         return
919             _startTokenId() <= tokenId &&
920             tokenId < _currentIndex && // If within bounds,
921             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
922     }
923 
924     /**
925      * @dev Equivalent to `_safeMint(to, quantity, '')`.
926      */
927     function _safeMint(address to, uint256 quantity) internal {
928         _safeMint(to, quantity, '');
929     }
930 
931     /**
932      * @dev Safely mints `quantity` tokens and transfers them to `to`.
933      *
934      * Requirements:
935      *
936      * - If `to` refers to a smart contract, it must implement
937      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
938      * - `quantity` must be greater than 0.
939      *
940      * See {_mint}.
941      *
942      * Emits a {Transfer} event for each mint.
943      */
944     function _safeMint(
945         address to,
946         uint256 quantity,
947         bytes memory _data
948     ) internal {
949         _mint(to, quantity);
950 
951         unchecked {
952             if (to.code.length != 0) {
953                 uint256 end = _currentIndex;
954                 uint256 index = end - quantity;
955                 do {
956                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
957                         revert TransferToNonERC721ReceiverImplementer();
958                     }
959                 } while (index < end);
960                 // Reentrancy protection.
961                 if (_currentIndex != end) revert();
962             }
963         }
964     }
965 
966     /**
967      * @dev Mints `quantity` tokens and transfers them to `to`.
968      *
969      * Requirements:
970      *
971      * - `to` cannot be the zero address.
972      * - `quantity` must be greater than 0.
973      *
974      * Emits a {Transfer} event for each mint.
975      */
976     function _mint(address to, uint256 quantity) internal {
977         uint256 startTokenId = _currentIndex;
978         if (to == address(0)) revert MintToZeroAddress();
979         if (quantity == 0) revert MintZeroQuantity();
980 
981         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
982 
983         // Overflows are incredibly unrealistic.
984         // `balance` and `numberMinted` have a maximum limit of 2**64.
985         // `tokenId` has a maximum limit of 2**256.
986         unchecked {
987             // Updates:
988             // - `balance += quantity`.
989             // - `numberMinted += quantity`.
990             //
991             // We can directly add to the `balance` and `numberMinted`.
992             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
993 
994             // Updates:
995             // - `address` to the owner.
996             // - `startTimestamp` to the timestamp of minting.
997             // - `burned` to `false`.
998             // - `nextInitialized` to `quantity == 1`.
999             _packedOwnerships[startTokenId] = _packOwnershipData(
1000                 to,
1001                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1002             );
1003 
1004             uint256 tokenId = startTokenId;
1005             uint256 end = startTokenId + quantity;
1006             do {
1007                 emit Transfer(address(0), to, tokenId++);
1008             } while (tokenId < end);
1009 
1010             _currentIndex = end;
1011         }
1012         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1013     }
1014 
1015     /**
1016      * @dev Mints `quantity` tokens and transfers them to `to`.
1017      *
1018      * This function is intended for efficient minting only during contract creation.
1019      *
1020      * It emits only one {ConsecutiveTransfer} as defined in
1021      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1022      * instead of a sequence of {Transfer} event(s).
1023      *
1024      * Calling this function outside of contract creation WILL make your contract
1025      * non-compliant with the ERC721 standard.
1026      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1027      * {ConsecutiveTransfer} event is only permissible during contract creation.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `quantity` must be greater than 0.
1033      *
1034      * Emits a {ConsecutiveTransfer} event.
1035      */
1036     function _mintERC2309(address to, uint256 quantity) internal {
1037         uint256 startTokenId = _currentIndex;
1038         if (to == address(0)) revert MintToZeroAddress();
1039         if (quantity == 0) revert MintZeroQuantity();
1040         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1041 
1042         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1043 
1044         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1045         unchecked {
1046             // Updates:
1047             // - `balance += quantity`.
1048             // - `numberMinted += quantity`.
1049             //
1050             // We can directly add to the `balance` and `numberMinted`.
1051             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1052 
1053             // Updates:
1054             // - `address` to the owner.
1055             // - `startTimestamp` to the timestamp of minting.
1056             // - `burned` to `false`.
1057             // - `nextInitialized` to `quantity == 1`.
1058             _packedOwnerships[startTokenId] = _packOwnershipData(
1059                 to,
1060                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1061             );
1062 
1063             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1064 
1065             _currentIndex = startTokenId + quantity;
1066         }
1067         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1068     }
1069 
1070     /**
1071      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1072      */
1073     function _getApprovedAddress(uint256 tokenId)
1074         private
1075         view
1076         returns (uint256 approvedAddressSlot, address approvedAddress)
1077     {
1078         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1079         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1080         assembly {
1081             // Compute the slot.
1082             mstore(0x00, tokenId)
1083             mstore(0x20, tokenApprovalsPtr.slot)
1084             approvedAddressSlot := keccak256(0x00, 0x40)
1085             // Load the slot's value from storage.
1086             approvedAddress := sload(approvedAddressSlot)
1087         }
1088     }
1089 
1090     /**
1091      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1092      */
1093     function _isOwnerOrApproved(
1094         address approvedAddress,
1095         address from,
1096         address msgSender
1097     ) private pure returns (bool result) {
1098         assembly {
1099             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1100             from := and(from, BITMASK_ADDRESS)
1101             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1102             msgSender := and(msgSender, BITMASK_ADDRESS)
1103             // `msgSender == from || msgSender == approvedAddress`.
1104             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1105         }
1106     }
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `tokenId` token must be owned by `from`.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function transferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) public virtual override {
1123         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1124 
1125         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1126 
1127         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1128 
1129         // The nested ifs save around 20+ gas over a compound boolean condition.
1130         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1131             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1132 
1133         if (to == address(0)) revert TransferToZeroAddress();
1134 
1135         _beforeTokenTransfers(from, to, tokenId, 1);
1136 
1137         // Clear approvals from the previous owner.
1138         assembly {
1139             if approvedAddress {
1140                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1141                 sstore(approvedAddressSlot, 0)
1142             }
1143         }
1144 
1145         // Underflow of the sender's balance is impossible because we check for
1146         // ownership above and the recipient's balance can't realistically overflow.
1147         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1148         unchecked {
1149             // We can directly increment and decrement the balances.
1150             --_packedAddressData[from]; // Updates: `balance -= 1`.
1151             ++_packedAddressData[to]; // Updates: `balance += 1`.
1152 
1153             // Updates:
1154             // - `address` to the next owner.
1155             // - `startTimestamp` to the timestamp of transfering.
1156             // - `burned` to `false`.
1157             // - `nextInitialized` to `true`.
1158             _packedOwnerships[tokenId] = _packOwnershipData(
1159                 to,
1160                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1161             );
1162 
1163             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1164             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1165                 uint256 nextTokenId = tokenId + 1;
1166                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1167                 if (_packedOwnerships[nextTokenId] == 0) {
1168                     // If the next slot is within bounds.
1169                     if (nextTokenId != _currentIndex) {
1170                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1171                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1172                     }
1173                 }
1174             }
1175         }
1176 
1177         emit Transfer(from, to, tokenId);
1178         _afterTokenTransfers(from, to, tokenId, 1);
1179     }
1180 
1181     /**
1182      * @dev Equivalent to `_burn(tokenId, false)`.
1183      */
1184     function _burn(uint256 tokenId) internal virtual {
1185         _burn(tokenId, false);
1186     }
1187 
1188     /**
1189      * @dev Destroys `tokenId`.
1190      * The approval is cleared when the token is burned.
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must exist.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1199         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1200 
1201         address from = address(uint160(prevOwnershipPacked));
1202 
1203         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1204 
1205         if (approvalCheck) {
1206             // The nested ifs save around 20+ gas over a compound boolean condition.
1207             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1208                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1209         }
1210 
1211         _beforeTokenTransfers(from, address(0), tokenId, 1);
1212 
1213         // Clear approvals from the previous owner.
1214         assembly {
1215             if approvedAddress {
1216                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1217                 sstore(approvedAddressSlot, 0)
1218             }
1219         }
1220 
1221         // Underflow of the sender's balance is impossible because we check for
1222         // ownership above and the recipient's balance can't realistically overflow.
1223         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1224         unchecked {
1225             // Updates:
1226             // - `balance -= 1`.
1227             // - `numberBurned += 1`.
1228             //
1229             // We can directly decrement the balance, and increment the number burned.
1230             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1231             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1232 
1233             // Updates:
1234             // - `address` to the last owner.
1235             // - `startTimestamp` to the timestamp of burning.
1236             // - `burned` to `true`.
1237             // - `nextInitialized` to `true`.
1238             _packedOwnerships[tokenId] = _packOwnershipData(
1239                 from,
1240                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1241             );
1242 
1243             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1244             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1245                 uint256 nextTokenId = tokenId + 1;
1246                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1247                 if (_packedOwnerships[nextTokenId] == 0) {
1248                     // If the next slot is within bounds.
1249                     if (nextTokenId != _currentIndex) {
1250                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1251                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1252                     }
1253                 }
1254             }
1255         }
1256 
1257         emit Transfer(from, address(0), tokenId);
1258         _afterTokenTransfers(from, address(0), tokenId, 1);
1259 
1260         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1261         unchecked {
1262             _burnCounter++;
1263         }
1264     }
1265 
1266     /**
1267      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1268      *
1269      * @param from address representing the previous owner of the given token ID
1270      * @param to target address that will receive the tokens
1271      * @param tokenId uint256 ID of the token to be transferred
1272      * @param _data bytes optional data to send along with the call
1273      * @return bool whether the call correctly returned the expected magic value
1274      */
1275     function _checkContractOnERC721Received(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory _data
1280     ) private returns (bool) {
1281         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1282             bytes4 retval
1283         ) {
1284             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1285         } catch (bytes memory reason) {
1286             if (reason.length == 0) {
1287                 revert TransferToNonERC721ReceiverImplementer();
1288             } else {
1289                 assembly {
1290                     revert(add(32, reason), mload(reason))
1291                 }
1292             }
1293         }
1294     }
1295 
1296     /**
1297      * @dev Directly sets the extra data for the ownership data `index`.
1298      */
1299     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1300         uint256 packed = _packedOwnerships[index];
1301         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1302         uint256 extraDataCasted;
1303         // Cast `extraData` with assembly to avoid redundant masking.
1304         assembly {
1305             extraDataCasted := extraData
1306         }
1307         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1308         _packedOwnerships[index] = packed;
1309     }
1310 
1311     /**
1312      * @dev Returns the next extra data for the packed ownership data.
1313      * The returned result is shifted into position.
1314      */
1315     function _nextExtraData(
1316         address from,
1317         address to,
1318         uint256 prevOwnershipPacked
1319     ) private view returns (uint256) {
1320         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1321         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1322     }
1323 
1324     /**
1325      * @dev Called during each token transfer to set the 24bit `extraData` field.
1326      * Intended to be overridden by the cosumer contract.
1327      *
1328      * `previousExtraData` - the value of `extraData` before transfer.
1329      *
1330      * Calling conditions:
1331      *
1332      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1333      * transferred to `to`.
1334      * - When `from` is zero, `tokenId` will be minted for `to`.
1335      * - When `to` is zero, `tokenId` will be burned by `from`.
1336      * - `from` and `to` are never both zero.
1337      */
1338     function _extraData(
1339         address from,
1340         address to,
1341         uint24 previousExtraData
1342     ) internal view virtual returns (uint24) {}
1343 
1344     /**
1345      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1346      * This includes minting.
1347      * And also called before burning one token.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` will be minted for `to`.
1357      * - When `to` is zero, `tokenId` will be burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _beforeTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 
1367     /**
1368      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1369      * This includes minting.
1370      * And also called after one token has been burned.
1371      *
1372      * startTokenId - the first token id to be transferred
1373      * quantity - the amount to be transferred
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` has been minted for `to`.
1380      * - When `to` is zero, `tokenId` has been burned by `from`.
1381      * - `from` and `to` are never both zero.
1382      */
1383     function _afterTokenTransfers(
1384         address from,
1385         address to,
1386         uint256 startTokenId,
1387         uint256 quantity
1388     ) internal virtual {}
1389 
1390     /**
1391      * @dev Returns the message sender (defaults to `msg.sender`).
1392      *
1393      * If you are writing GSN compatible contracts, you need to override this function.
1394      */
1395     function _msgSenderERC721A() internal view virtual returns (address) {
1396         return msg.sender;
1397     }
1398 
1399     /**
1400      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1401      */
1402     function _toString(uint256 value) internal pure returns (string memory ptr) {
1403         assembly {
1404             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1405             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1406             // We will need 1 32-byte word to store the length,
1407             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1408             ptr := add(mload(0x40), 128)
1409             // Update the free memory pointer to allocate.
1410             mstore(0x40, ptr)
1411 
1412             // Cache the end of the memory to calculate the length later.
1413             let end := ptr
1414 
1415             // We write the string from the rightmost digit to the leftmost digit.
1416             // The following is essentially a do-while loop that also handles the zero case.
1417             // Costs a bit more than early returning for the zero case,
1418             // but cheaper in terms of deployment and overall runtime costs.
1419             for {
1420                 // Initialize and perform the first pass without check.
1421                 let temp := value
1422                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1423                 ptr := sub(ptr, 1)
1424                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1425                 mstore8(ptr, add(48, mod(temp, 10)))
1426                 temp := div(temp, 10)
1427             } temp {
1428                 // Keep dividing `temp` until zero.
1429                 temp := div(temp, 10)
1430             } {
1431                 // Body of the for loop.
1432                 ptr := sub(ptr, 1)
1433                 mstore8(ptr, add(48, mod(temp, 10)))
1434             }
1435 
1436             let length := sub(end, ptr)
1437             // Move the pointer 32 bytes leftwards to make room for the length.
1438             ptr := sub(ptr, 32)
1439             // Store the length.
1440             mstore(ptr, length)
1441         }
1442     }
1443 }
1444 
1445 // File: contracts/satosan.sol
1446 
1447 pragma solidity ^0.8.4;
1448 
1449 
1450 
1451 
1452 contract Satosan is Ownable, ERC721A, ReentrancyGuard {
1453     mapping(address => uint256) public minted;
1454 
1455     constructor() ERC721A("Sato-san", "SATOSAN") {
1456         satosanConfig.pause = false;
1457         satosanConfig.price = 10000000000000000;
1458         satosanConfig.maxMint = 2;
1459         satosanConfig.maxSupply = 10000;
1460     }
1461 
1462     struct SatosanConfig {
1463         bool pause;
1464         uint256 price;
1465         uint256 maxMint;
1466         uint256 maxSupply;
1467     }
1468     SatosanConfig public satosanConfig;
1469 
1470     function getSatosan(uint256 quantity) external payable {
1471         SatosanConfig memory config = satosanConfig;
1472         bool pause = bool(config.pause);
1473         uint256 price = uint256(config.price);
1474         uint256 maxMint = uint256(config.maxMint);
1475 
1476         require(
1477             !pause,
1478             "Mint paused."
1479         );
1480 
1481         require(
1482             totalSupply() + quantity <= getMaxSupply(),
1483             "No more satosan."
1484         );
1485     
1486         require(
1487             getAddressBuyed(msg.sender) + quantity <= maxMint,
1488             "Exceed maxmium mint."
1489         );
1490 
1491         bool requirePay = (quantity > 1 || getAddressBuyed(msg.sender) >= 1) ? true : false;
1492         if (requirePay) {
1493             require(
1494                 price <= msg.value,
1495                 "No enough eth."
1496             );
1497         }
1498 
1499         _safeMint(msg.sender, quantity);
1500         minted[msg.sender] += quantity;
1501     }
1502 
1503     function makeSatosan(uint256 quantity) external onlyOwner {
1504         require(
1505             totalSupply() + quantity <= getMaxSupply(),
1506             "No more satosan."
1507         );
1508 
1509         _safeMint(msg.sender, quantity);
1510     }
1511 
1512     function getAddressBuyed(address owner) public view returns (uint256) {
1513         return minted[owner];
1514     }
1515     
1516     function getMaxSupply() private view returns (uint256) {
1517         SatosanConfig memory config = satosanConfig;
1518         uint256 max = uint256(config.maxSupply);
1519         return max;
1520     }
1521 
1522     string private _baseTokenURI;
1523 
1524     function _baseURI() internal view virtual override returns (string memory) {
1525         return _baseTokenURI;
1526     }
1527 
1528     function setSatosanURI(string calldata baseURI) external onlyOwner {
1529         _baseTokenURI = baseURI;
1530     }
1531 
1532     function setSatosanPrice(uint256 _price) external onlyOwner {
1533         satosanConfig.price = _price;
1534     }
1535 
1536     function setPause(bool _pause) external onlyOwner {
1537         satosanConfig.pause = _pause;
1538     }
1539 
1540     function withdraw() external onlyOwner nonReentrant {
1541         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1542         require(success, "...");
1543     }
1544 }