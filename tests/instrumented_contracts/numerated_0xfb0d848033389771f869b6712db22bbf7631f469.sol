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
183 // ERC721A Contracts v4.2.3
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
203      * Cannot query the balance for the zero address.
204      */
205     error BalanceQueryForZeroAddress();
206 
207     /**
208      * Cannot mint to the zero address.
209      */
210     error MintToZeroAddress();
211 
212     /**
213      * The quantity of tokens minted must be more than zero.
214      */
215     error MintZeroQuantity();
216 
217     /**
218      * The token does not exist.
219      */
220     error OwnerQueryForNonexistentToken();
221 
222     /**
223      * The caller must own the token or be an approved operator.
224      */
225     error TransferCallerNotOwnerNorApproved();
226 
227     /**
228      * The token must be owned by `from`.
229      */
230     error TransferFromIncorrectOwner();
231 
232     /**
233      * Cannot safely transfer to a contract that does not implement the
234      * ERC721Receiver interface.
235      */
236     error TransferToNonERC721ReceiverImplementer();
237 
238     /**
239      * Cannot transfer to the zero address.
240      */
241     error TransferToZeroAddress();
242 
243     /**
244      * The token does not exist.
245      */
246     error URIQueryForNonexistentToken();
247 
248     /**
249      * The `quantity` minted with ERC2309 exceeds the safety limit.
250      */
251     error MintERC2309QuantityExceedsLimit();
252 
253     /**
254      * The `extraData` cannot be set on an unintialized ownership slot.
255      */
256     error OwnershipNotInitializedForExtraData();
257 
258     // =============================================================
259     //                            STRUCTS
260     // =============================================================
261 
262     struct TokenOwnership {
263         // The address of the owner.
264         address addr;
265         // Stores the start time of ownership with minimal overhead for tokenomics.
266         uint64 startTimestamp;
267         // Whether the token has been burned.
268         bool burned;
269         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
270         uint24 extraData;
271     }
272 
273     // =============================================================
274     //                         TOKEN COUNTERS
275     // =============================================================
276 
277     /**
278      * @dev Returns the total number of tokens in existence.
279      * Burned tokens will reduce the count.
280      * To get the total number of tokens minted, please see {_totalMinted}.
281      */
282     function totalSupply() external view returns (uint256);
283 
284     // =============================================================
285     //                            IERC165
286     // =============================================================
287 
288     /**
289      * @dev Returns true if this contract implements the interface defined by
290      * `interfaceId`. See the corresponding
291      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
292      * to learn more about how these ids are created.
293      *
294      * This function call must use less than 30000 gas.
295      */
296     function supportsInterface(bytes4 interfaceId) external view returns (bool);
297 
298     // =============================================================
299     //                            IERC721
300     // =============================================================
301 
302     /**
303      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
304      */
305     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
306 
307     /**
308      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
309      */
310     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
311 
312     /**
313      * @dev Emitted when `owner` enables or disables
314      * (`approved`) `operator` to manage all of its assets.
315      */
316     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
317 
318     /**
319      * @dev Returns the number of tokens in `owner`'s account.
320      */
321     function balanceOf(address owner) external view returns (uint256 balance);
322 
323     /**
324      * @dev Returns the owner of the `tokenId` token.
325      *
326      * Requirements:
327      *
328      * - `tokenId` must exist.
329      */
330     function ownerOf(uint256 tokenId) external view returns (address owner);
331 
332     /**
333      * @dev Safely transfers `tokenId` token from `from` to `to`,
334      * checking first that contract recipients are aware of the ERC721 protocol
335      * to prevent tokens from being forever locked.
336      *
337      * Requirements:
338      *
339      * - `from` cannot be the zero address.
340      * - `to` cannot be the zero address.
341      * - `tokenId` token must exist and be owned by `from`.
342      * - If the caller is not `from`, it must be have been allowed to move
343      * this token by either {approve} or {setApprovalForAll}.
344      * - If `to` refers to a smart contract, it must implement
345      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
346      *
347      * Emits a {Transfer} event.
348      */
349     function safeTransferFrom(
350         address from,
351         address to,
352         uint256 tokenId,
353         bytes calldata data
354     ) external payable;
355 
356     /**
357      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
358      */
359     function safeTransferFrom(
360         address from,
361         address to,
362         uint256 tokenId
363     ) external payable;
364 
365     /**
366      * @dev Transfers `tokenId` from `from` to `to`.
367      *
368      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
369      * whenever possible.
370      *
371      * Requirements:
372      *
373      * - `from` cannot be the zero address.
374      * - `to` cannot be the zero address.
375      * - `tokenId` token must be owned by `from`.
376      * - If the caller is not `from`, it must be approved to move this token
377      * by either {approve} or {setApprovalForAll}.
378      *
379      * Emits a {Transfer} event.
380      */
381     function transferFrom(
382         address from,
383         address to,
384         uint256 tokenId
385     ) external payable;
386 
387     /**
388      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
389      * The approval is cleared when the token is transferred.
390      *
391      * Only a single account can be approved at a time, so approving the
392      * zero address clears previous approvals.
393      *
394      * Requirements:
395      *
396      * - The caller must own the token or be an approved operator.
397      * - `tokenId` must exist.
398      *
399      * Emits an {Approval} event.
400      */
401     function approve(address to, uint256 tokenId) external payable;
402 
403     /**
404      * @dev Approve or remove `operator` as an operator for the caller.
405      * Operators can call {transferFrom} or {safeTransferFrom}
406      * for any token owned by the caller.
407      *
408      * Requirements:
409      *
410      * - The `operator` cannot be the caller.
411      *
412      * Emits an {ApprovalForAll} event.
413      */
414     function setApprovalForAll(address operator, bool _approved) external;
415 
416     /**
417      * @dev Returns the account approved for `tokenId` token.
418      *
419      * Requirements:
420      *
421      * - `tokenId` must exist.
422      */
423     function getApproved(uint256 tokenId) external view returns (address operator);
424 
425     /**
426      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
427      *
428      * See {setApprovalForAll}.
429      */
430     function isApprovedForAll(address owner, address operator) external view returns (bool);
431 
432     // =============================================================
433     //                        IERC721Metadata
434     // =============================================================
435 
436     /**
437      * @dev Returns the token collection name.
438      */
439     function name() external view returns (string memory);
440 
441     /**
442      * @dev Returns the token collection symbol.
443      */
444     function symbol() external view returns (string memory);
445 
446     /**
447      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
448      */
449     function tokenURI(uint256 tokenId) external view returns (string memory);
450 
451     // =============================================================
452     //                           IERC2309
453     // =============================================================
454 
455     /**
456      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
457      * (inclusive) is transferred from `from` to `to`, as defined in the
458      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
459      *
460      * See {_mintERC2309} for more details.
461      */
462     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
463 }
464 
465 // File: erc721a/contracts/ERC721A.sol
466 
467 
468 // ERC721A Contracts v4.2.3
469 // Creator: Chiru Labs
470 
471 pragma solidity ^0.8.4;
472 
473 
474 /**
475  * @dev Interface of ERC721 token receiver.
476  */
477 interface ERC721A__IERC721Receiver {
478     function onERC721Received(
479         address operator,
480         address from,
481         uint256 tokenId,
482         bytes calldata data
483     ) external returns (bytes4);
484 }
485 
486 /**
487  * @title ERC721A
488  *
489  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
490  * Non-Fungible Token Standard, including the Metadata extension.
491  * Optimized for lower gas during batch mints.
492  *
493  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
494  * starting from `_startTokenId()`.
495  *
496  * Assumptions:
497  *
498  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
499  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
500  */
501 contract ERC721A is IERC721A {
502     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
503     struct TokenApprovalRef {
504         address value;
505     }
506 
507     // =============================================================
508     //                           CONSTANTS
509     // =============================================================
510 
511     // Mask of an entry in packed address data.
512     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
513 
514     // The bit position of `numberMinted` in packed address data.
515     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
516 
517     // The bit position of `numberBurned` in packed address data.
518     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
519 
520     // The bit position of `aux` in packed address data.
521     uint256 private constant _BITPOS_AUX = 192;
522 
523     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
524     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
525 
526     // The bit position of `startTimestamp` in packed ownership.
527     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
528 
529     // The bit mask of the `burned` bit in packed ownership.
530     uint256 private constant _BITMASK_BURNED = 1 << 224;
531 
532     // The bit position of the `nextInitialized` bit in packed ownership.
533     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
534 
535     // The bit mask of the `nextInitialized` bit in packed ownership.
536     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
537 
538     // The bit position of `extraData` in packed ownership.
539     uint256 private constant _BITPOS_EXTRA_DATA = 232;
540 
541     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
542     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
543 
544     // The mask of the lower 160 bits for addresses.
545     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
546 
547     // The maximum `quantity` that can be minted with {_mintERC2309}.
548     // This limit is to prevent overflows on the address data entries.
549     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
550     // is required to cause an overflow, which is unrealistic.
551     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
552 
553     // The `Transfer` event signature is given by:
554     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
555     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
556         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
557 
558     // =============================================================
559     //                            STORAGE
560     // =============================================================
561 
562     // The next token ID to be minted.
563     uint256 private _currentIndex;
564 
565     // The number of tokens burned.
566     uint256 private _burnCounter;
567 
568     // Token name
569     string private _name;
570 
571     // Token symbol
572     string private _symbol;
573 
574     // Mapping from token ID to ownership details
575     // An empty struct value does not necessarily mean the token is unowned.
576     // See {_packedOwnershipOf} implementation for details.
577     //
578     // Bits Layout:
579     // - [0..159]   `addr`
580     // - [160..223] `startTimestamp`
581     // - [224]      `burned`
582     // - [225]      `nextInitialized`
583     // - [232..255] `extraData`
584     mapping(uint256 => uint256) private _packedOwnerships;
585 
586     // Mapping owner address to address data.
587     //
588     // Bits Layout:
589     // - [0..63]    `balance`
590     // - [64..127]  `numberMinted`
591     // - [128..191] `numberBurned`
592     // - [192..255] `aux`
593     mapping(address => uint256) private _packedAddressData;
594 
595     // Mapping from token ID to approved address.
596     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
597 
598     // Mapping from owner to operator approvals
599     mapping(address => mapping(address => bool)) private _operatorApprovals;
600 
601     // =============================================================
602     //                          CONSTRUCTOR
603     // =============================================================
604 
605     constructor(string memory name_, string memory symbol_) {
606         _name = name_;
607         _symbol = symbol_;
608         _currentIndex = _startTokenId();
609     }
610 
611     // =============================================================
612     //                   TOKEN COUNTING OPERATIONS
613     // =============================================================
614 
615     /**
616      * @dev Returns the starting token ID.
617      * To change the starting token ID, please override this function.
618      */
619     function _startTokenId() internal view virtual returns (uint256) {
620         return 0;
621     }
622 
623     /**
624      * @dev Returns the next token ID to be minted.
625      */
626     function _nextTokenId() internal view virtual returns (uint256) {
627         return _currentIndex;
628     }
629 
630     /**
631      * @dev Returns the total number of tokens in existence.
632      * Burned tokens will reduce the count.
633      * To get the total number of tokens minted, please see {_totalMinted}.
634      */
635     function totalSupply() public view virtual override returns (uint256) {
636         // Counter underflow is impossible as _burnCounter cannot be incremented
637         // more than `_currentIndex - _startTokenId()` times.
638         unchecked {
639             return _currentIndex - _burnCounter - _startTokenId();
640         }
641     }
642 
643     /**
644      * @dev Returns the total amount of tokens minted in the contract.
645      */
646     function _totalMinted() internal view virtual returns (uint256) {
647         // Counter underflow is impossible as `_currentIndex` does not decrement,
648         // and it is initialized to `_startTokenId()`.
649         unchecked {
650             return _currentIndex - _startTokenId();
651         }
652     }
653 
654     /**
655      * @dev Returns the total number of tokens burned.
656      */
657     function _totalBurned() internal view virtual returns (uint256) {
658         return _burnCounter;
659     }
660 
661     // =============================================================
662     //                    ADDRESS DATA OPERATIONS
663     // =============================================================
664 
665     /**
666      * @dev Returns the number of tokens in `owner`'s account.
667      */
668     function balanceOf(address owner) public view virtual override returns (uint256) {
669         if (owner == address(0)) revert BalanceQueryForZeroAddress();
670         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
671     }
672 
673     /**
674      * Returns the number of tokens minted by `owner`.
675      */
676     function _numberMinted(address owner) internal view returns (uint256) {
677         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
678     }
679 
680     /**
681      * Returns the number of tokens burned by or on behalf of `owner`.
682      */
683     function _numberBurned(address owner) internal view returns (uint256) {
684         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
685     }
686 
687     /**
688      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
689      */
690     function _getAux(address owner) internal view returns (uint64) {
691         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
692     }
693 
694     /**
695      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
696      * If there are multiple variables, please pack them into a uint64.
697      */
698     function _setAux(address owner, uint64 aux) internal virtual {
699         uint256 packed = _packedAddressData[owner];
700         uint256 auxCasted;
701         // Cast `aux` with assembly to avoid redundant masking.
702         assembly {
703             auxCasted := aux
704         }
705         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
706         _packedAddressData[owner] = packed;
707     }
708 
709     // =============================================================
710     //                            IERC165
711     // =============================================================
712 
713     /**
714      * @dev Returns true if this contract implements the interface defined by
715      * `interfaceId`. See the corresponding
716      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
717      * to learn more about how these ids are created.
718      *
719      * This function call must use less than 30000 gas.
720      */
721     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
722         // The interface IDs are constants representing the first 4 bytes
723         // of the XOR of all function selectors in the interface.
724         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
725         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
726         return
727             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
728             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
729             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
730     }
731 
732     // =============================================================
733     //                        IERC721Metadata
734     // =============================================================
735 
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() public view virtual override returns (string memory) {
740         return _name;
741     }
742 
743     /**
744      * @dev Returns the token collection symbol.
745      */
746     function symbol() public view virtual override returns (string memory) {
747         return _symbol;
748     }
749 
750     /**
751      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
752      */
753     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
754         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
755 
756         string memory baseURI = _baseURI();
757         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
758     }
759 
760     /**
761      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
762      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
763      * by default, it can be overridden in child contracts.
764      */
765     function _baseURI() internal view virtual returns (string memory) {
766         return '';
767     }
768 
769     // =============================================================
770     //                     OWNERSHIPS OPERATIONS
771     // =============================================================
772 
773     /**
774      * @dev Returns the owner of the `tokenId` token.
775      *
776      * Requirements:
777      *
778      * - `tokenId` must exist.
779      */
780     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
781         return address(uint160(_packedOwnershipOf(tokenId)));
782     }
783 
784     /**
785      * @dev Gas spent here starts off proportional to the maximum mint batch size.
786      * It gradually moves to O(1) as tokens get transferred around over time.
787      */
788     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
789         return _unpackedOwnership(_packedOwnershipOf(tokenId));
790     }
791 
792     /**
793      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
794      */
795     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
796         return _unpackedOwnership(_packedOwnerships[index]);
797     }
798 
799     /**
800      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
801      */
802     function _initializeOwnershipAt(uint256 index) internal virtual {
803         if (_packedOwnerships[index] == 0) {
804             _packedOwnerships[index] = _packedOwnershipOf(index);
805         }
806     }
807 
808     /**
809      * Returns the packed ownership data of `tokenId`.
810      */
811     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
812         uint256 curr = tokenId;
813 
814         unchecked {
815             if (_startTokenId() <= curr)
816                 if (curr < _currentIndex) {
817                     uint256 packed = _packedOwnerships[curr];
818                     // If not burned.
819                     if (packed & _BITMASK_BURNED == 0) {
820                         // Invariant:
821                         // There will always be an initialized ownership slot
822                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
823                         // before an unintialized ownership slot
824                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
825                         // Hence, `curr` will not underflow.
826                         //
827                         // We can directly compare the packed value.
828                         // If the address is zero, packed will be zero.
829                         while (packed == 0) {
830                             packed = _packedOwnerships[--curr];
831                         }
832                         return packed;
833                     }
834                 }
835         }
836         revert OwnerQueryForNonexistentToken();
837     }
838 
839     /**
840      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
841      */
842     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
843         ownership.addr = address(uint160(packed));
844         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
845         ownership.burned = packed & _BITMASK_BURNED != 0;
846         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
847     }
848 
849     /**
850      * @dev Packs ownership data into a single uint256.
851      */
852     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
853         assembly {
854             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
855             owner := and(owner, _BITMASK_ADDRESS)
856             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
857             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
858         }
859     }
860 
861     /**
862      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
863      */
864     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
865         // For branchless setting of the `nextInitialized` flag.
866         assembly {
867             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
868             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
869         }
870     }
871 
872     // =============================================================
873     //                      APPROVAL OPERATIONS
874     // =============================================================
875 
876     /**
877      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
878      * The approval is cleared when the token is transferred.
879      *
880      * Only a single account can be approved at a time, so approving the
881      * zero address clears previous approvals.
882      *
883      * Requirements:
884      *
885      * - The caller must own the token or be an approved operator.
886      * - `tokenId` must exist.
887      *
888      * Emits an {Approval} event.
889      */
890     function approve(address to, uint256 tokenId) public payable virtual override {
891         address owner = ownerOf(tokenId);
892 
893         if (_msgSenderERC721A() != owner)
894             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
895                 revert ApprovalCallerNotOwnerNorApproved();
896             }
897 
898         _tokenApprovals[tokenId].value = to;
899         emit Approval(owner, to, tokenId);
900     }
901 
902     /**
903      * @dev Returns the account approved for `tokenId` token.
904      *
905      * Requirements:
906      *
907      * - `tokenId` must exist.
908      */
909     function getApproved(uint256 tokenId) public view virtual override returns (address) {
910         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
911 
912         return _tokenApprovals[tokenId].value;
913     }
914 
915     /**
916      * @dev Approve or remove `operator` as an operator for the caller.
917      * Operators can call {transferFrom} or {safeTransferFrom}
918      * for any token owned by the caller.
919      *
920      * Requirements:
921      *
922      * - The `operator` cannot be the caller.
923      *
924      * Emits an {ApprovalForAll} event.
925      */
926     function setApprovalForAll(address operator, bool approved) public virtual override {
927         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
928         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
929     }
930 
931     /**
932      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
933      *
934      * See {setApprovalForAll}.
935      */
936     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev Returns whether `tokenId` exists.
942      *
943      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
944      *
945      * Tokens start existing when they are minted. See {_mint}.
946      */
947     function _exists(uint256 tokenId) internal view virtual returns (bool) {
948         return
949             _startTokenId() <= tokenId &&
950             tokenId < _currentIndex && // If within bounds,
951             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
952     }
953 
954     /**
955      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
956      */
957     function _isSenderApprovedOrOwner(
958         address approvedAddress,
959         address owner,
960         address msgSender
961     ) private pure returns (bool result) {
962         assembly {
963             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
964             owner := and(owner, _BITMASK_ADDRESS)
965             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
966             msgSender := and(msgSender, _BITMASK_ADDRESS)
967             // `msgSender == owner || msgSender == approvedAddress`.
968             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
969         }
970     }
971 
972     /**
973      * @dev Returns the storage slot and value for the approved address of `tokenId`.
974      */
975     function _getApprovedSlotAndAddress(uint256 tokenId)
976         private
977         view
978         returns (uint256 approvedAddressSlot, address approvedAddress)
979     {
980         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
981         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
982         assembly {
983             approvedAddressSlot := tokenApproval.slot
984             approvedAddress := sload(approvedAddressSlot)
985         }
986     }
987 
988     // =============================================================
989     //                      TRANSFER OPERATIONS
990     // =============================================================
991 
992     /**
993      * @dev Transfers `tokenId` from `from` to `to`.
994      *
995      * Requirements:
996      *
997      * - `from` cannot be the zero address.
998      * - `to` cannot be the zero address.
999      * - `tokenId` token must be owned by `from`.
1000      * - If the caller is not `from`, it must be approved to move this token
1001      * by either {approve} or {setApprovalForAll}.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function transferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public payable virtual override {
1010         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1011 
1012         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1013 
1014         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1015 
1016         // The nested ifs save around 20+ gas over a compound boolean condition.
1017         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1018             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1019 
1020         if (to == address(0)) revert TransferToZeroAddress();
1021 
1022         _beforeTokenTransfers(from, to, tokenId, 1);
1023 
1024         // Clear approvals from the previous owner.
1025         assembly {
1026             if approvedAddress {
1027                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1028                 sstore(approvedAddressSlot, 0)
1029             }
1030         }
1031 
1032         // Underflow of the sender's balance is impossible because we check for
1033         // ownership above and the recipient's balance can't realistically overflow.
1034         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1035         unchecked {
1036             // We can directly increment and decrement the balances.
1037             --_packedAddressData[from]; // Updates: `balance -= 1`.
1038             ++_packedAddressData[to]; // Updates: `balance += 1`.
1039 
1040             // Updates:
1041             // - `address` to the next owner.
1042             // - `startTimestamp` to the timestamp of transfering.
1043             // - `burned` to `false`.
1044             // - `nextInitialized` to `true`.
1045             _packedOwnerships[tokenId] = _packOwnershipData(
1046                 to,
1047                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1048             );
1049 
1050             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1051             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1052                 uint256 nextTokenId = tokenId + 1;
1053                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1054                 if (_packedOwnerships[nextTokenId] == 0) {
1055                     // If the next slot is within bounds.
1056                     if (nextTokenId != _currentIndex) {
1057                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1058                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1059                     }
1060                 }
1061             }
1062         }
1063 
1064         emit Transfer(from, to, tokenId);
1065         _afterTokenTransfers(from, to, tokenId, 1);
1066     }
1067 
1068     /**
1069      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1070      */
1071     function safeTransferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) public payable virtual override {
1076         safeTransferFrom(from, to, tokenId, '');
1077     }
1078 
1079     /**
1080      * @dev Safely transfers `tokenId` token from `from` to `to`.
1081      *
1082      * Requirements:
1083      *
1084      * - `from` cannot be the zero address.
1085      * - `to` cannot be the zero address.
1086      * - `tokenId` token must exist and be owned by `from`.
1087      * - If the caller is not `from`, it must be approved to move this token
1088      * by either {approve} or {setApprovalForAll}.
1089      * - If `to` refers to a smart contract, it must implement
1090      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function safeTransferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId,
1098         bytes memory _data
1099     ) public payable virtual override {
1100         transferFrom(from, to, tokenId);
1101         if (to.code.length != 0)
1102             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1103                 revert TransferToNonERC721ReceiverImplementer();
1104             }
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before a set of serially-ordered token IDs
1109      * are about to be transferred. This includes minting.
1110      * And also called before burning one token.
1111      *
1112      * `startTokenId` - the first token ID to be transferred.
1113      * `quantity` - the amount to be transferred.
1114      *
1115      * Calling conditions:
1116      *
1117      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1118      * transferred to `to`.
1119      * - When `from` is zero, `tokenId` will be minted for `to`.
1120      * - When `to` is zero, `tokenId` will be burned by `from`.
1121      * - `from` and `to` are never both zero.
1122      */
1123     function _beforeTokenTransfers(
1124         address from,
1125         address to,
1126         uint256 startTokenId,
1127         uint256 quantity
1128     ) internal virtual {}
1129 
1130     /**
1131      * @dev Hook that is called after a set of serially-ordered token IDs
1132      * have been transferred. This includes minting.
1133      * And also called after one token has been burned.
1134      *
1135      * `startTokenId` - the first token ID to be transferred.
1136      * `quantity` - the amount to be transferred.
1137      *
1138      * Calling conditions:
1139      *
1140      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1141      * transferred to `to`.
1142      * - When `from` is zero, `tokenId` has been minted for `to`.
1143      * - When `to` is zero, `tokenId` has been burned by `from`.
1144      * - `from` and `to` are never both zero.
1145      */
1146     function _afterTokenTransfers(
1147         address from,
1148         address to,
1149         uint256 startTokenId,
1150         uint256 quantity
1151     ) internal virtual {}
1152 
1153     /**
1154      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1155      *
1156      * `from` - Previous owner of the given token ID.
1157      * `to` - Target address that will receive the token.
1158      * `tokenId` - Token ID to be transferred.
1159      * `_data` - Optional data to send along with the call.
1160      *
1161      * Returns whether the call correctly returned the expected magic value.
1162      */
1163     function _checkContractOnERC721Received(
1164         address from,
1165         address to,
1166         uint256 tokenId,
1167         bytes memory _data
1168     ) private returns (bool) {
1169         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1170             bytes4 retval
1171         ) {
1172             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1173         } catch (bytes memory reason) {
1174             if (reason.length == 0) {
1175                 revert TransferToNonERC721ReceiverImplementer();
1176             } else {
1177                 assembly {
1178                     revert(add(32, reason), mload(reason))
1179                 }
1180             }
1181         }
1182     }
1183 
1184     // =============================================================
1185     //                        MINT OPERATIONS
1186     // =============================================================
1187 
1188     /**
1189      * @dev Mints `quantity` tokens and transfers them to `to`.
1190      *
1191      * Requirements:
1192      *
1193      * - `to` cannot be the zero address.
1194      * - `quantity` must be greater than 0.
1195      *
1196      * Emits a {Transfer} event for each mint.
1197      */
1198     function _mint(address to, uint256 quantity) internal virtual {
1199         uint256 startTokenId = _currentIndex;
1200         if (quantity == 0) revert MintZeroQuantity();
1201 
1202         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1203 
1204         // Overflows are incredibly unrealistic.
1205         // `balance` and `numberMinted` have a maximum limit of 2**64.
1206         // `tokenId` has a maximum limit of 2**256.
1207         unchecked {
1208             // Updates:
1209             // - `balance += quantity`.
1210             // - `numberMinted += quantity`.
1211             //
1212             // We can directly add to the `balance` and `numberMinted`.
1213             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1214 
1215             // Updates:
1216             // - `address` to the owner.
1217             // - `startTimestamp` to the timestamp of minting.
1218             // - `burned` to `false`.
1219             // - `nextInitialized` to `quantity == 1`.
1220             _packedOwnerships[startTokenId] = _packOwnershipData(
1221                 to,
1222                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1223             );
1224 
1225             uint256 toMasked;
1226             uint256 end = startTokenId + quantity;
1227 
1228             // Use assembly to loop and emit the `Transfer` event for gas savings.
1229             // The duplicated `log4` removes an extra check and reduces stack juggling.
1230             // The assembly, together with the surrounding Solidity code, have been
1231             // delicately arranged to nudge the compiler into producing optimized opcodes.
1232             assembly {
1233                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1234                 toMasked := and(to, _BITMASK_ADDRESS)
1235                 // Emit the `Transfer` event.
1236                 log4(
1237                     0, // Start of data (0, since no data).
1238                     0, // End of data (0, since no data).
1239                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1240                     0, // `address(0)`.
1241                     toMasked, // `to`.
1242                     startTokenId // `tokenId`.
1243                 )
1244 
1245                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1246                 // that overflows uint256 will make the loop run out of gas.
1247                 // The compiler will optimize the `iszero` away for performance.
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
1520             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1521             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1522             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1523             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1524             let m := add(mload(0x40), 0xa0)
1525             // Update the free memory pointer to allocate.
1526             mstore(0x40, m)
1527             // Assign the `str` to the end.
1528             str := sub(m, 0x20)
1529             // Zeroize the slot after the string.
1530             mstore(str, 0)
1531 
1532             // Cache the end of the memory to calculate the length later.
1533             let end := str
1534 
1535             // We write the string from rightmost digit to leftmost digit.
1536             // The following is essentially a do-while loop that also handles the zero case.
1537             // prettier-ignore
1538             for { let temp := value } 1 {} {
1539                 str := sub(str, 1)
1540                 // Write the character to the pointer.
1541                 // The ASCII index of the '0' character is 48.
1542                 mstore8(str, add(48, mod(temp, 10)))
1543                 // Keep dividing `temp` until zero.
1544                 temp := div(temp, 10)
1545                 // prettier-ignore
1546                 if iszero(temp) { break }
1547             }
1548 
1549             let length := sub(end, str)
1550             // Move the pointer 32 bytes leftwards to make room for the length.
1551             str := sub(str, 0x20)
1552             // Store the length.
1553             mstore(str, length)
1554         }
1555     }
1556 }
1557 
1558 // File: contracts/PixelPixel.sol
1559 
1560 
1561 
1562 pragma solidity ^0.8.4;
1563 
1564 
1565 
1566 
1567 contract PixelPixel is ERC721A, Ownable, ReentrancyGuard {
1568   string public uriPrefix = '';
1569   string public uriSuffix = '.json';
1570   string public baseUri = 'ipfs://QmTkqGjZwNGnTy7oXXRF99P3gLojrMhoFUXrLbZ2uVgvni/hide.json';
1571 
1572   uint256 public cost = 0.002 ether;
1573   uint256 public maxSupply = 1888;
1574   uint256 public maxMintAmountPerTx = 5;
1575 
1576   bool public paused = true;
1577   bool public revealed = false;
1578 
1579   constructor(
1580     string memory _tokenName,
1581     string memory _tokenSymbol
1582   ) ERC721A(_tokenName, _tokenSymbol) {
1583     _safeMint(msg.sender, 1);
1584   }
1585 
1586   modifier mintCompliance(uint256 _mintAmount) {
1587     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1588     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1589     _;
1590   }
1591 
1592   modifier mintPriceCompliance(uint256 _mintAmount) {
1593     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1594     _;
1595   }
1596 
1597   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1598     require(!paused, 'The contract is paused!');
1599 
1600     _safeMint(msg.sender, _mintAmount);
1601   }
1602   
1603   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1604     _safeMint(_receiver, _mintAmount);
1605   }
1606 
1607   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1608     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1609 
1610     if (!revealed) {
1611       return baseUri;
1612     }
1613 
1614     string memory currentBaseURI = _baseURI();
1615     return bytes(currentBaseURI).length > 0
1616         ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId), uriSuffix))
1617         : '';
1618   }
1619 
1620   function setCost(uint256 _cost) public onlyOwner {
1621     cost = _cost;
1622   }
1623 
1624   function setBaseUri(string memory _uri) public onlyOwner {
1625     baseUri = _uri;
1626   }
1627 
1628   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1629     uriPrefix = _uriPrefix;
1630   }
1631 
1632   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1633     uriSuffix = _uriSuffix;
1634   }
1635 
1636   function setPaused(bool _state) public onlyOwner {
1637     paused = _state;
1638   }
1639 
1640   function setRevealed(bool _revealed) public onlyOwner {
1641     revealed = _revealed;
1642   }
1643 
1644   function withdraw() public onlyOwner nonReentrant {
1645     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1646     require(os);
1647   }
1648 
1649   function _baseURI() internal view virtual override returns (string memory) {
1650     return uriPrefix;
1651   }
1652 }