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
182 // ERC721A Contracts v4.2.3
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
202      * Cannot query the balance for the zero address.
203      */
204     error BalanceQueryForZeroAddress();
205 
206     /**
207      * Cannot mint to the zero address.
208      */
209     error MintToZeroAddress();
210 
211     /**
212      * The quantity of tokens minted must be more than zero.
213      */
214     error MintZeroQuantity();
215 
216     /**
217      * The token does not exist.
218      */
219     error OwnerQueryForNonexistentToken();
220 
221     /**
222      * The caller must own the token or be an approved operator.
223      */
224     error TransferCallerNotOwnerNorApproved();
225 
226     /**
227      * The token must be owned by `from`.
228      */
229     error TransferFromIncorrectOwner();
230 
231     /**
232      * Cannot safely transfer to a contract that does not implement the
233      * ERC721Receiver interface.
234      */
235     error TransferToNonERC721ReceiverImplementer();
236 
237     /**
238      * Cannot transfer to the zero address.
239      */
240     error TransferToZeroAddress();
241 
242     /**
243      * The token does not exist.
244      */
245     error URIQueryForNonexistentToken();
246 
247     /**
248      * The `quantity` minted with ERC2309 exceeds the safety limit.
249      */
250     error MintERC2309QuantityExceedsLimit();
251 
252     /**
253      * The `extraData` cannot be set on an unintialized ownership slot.
254      */
255     error OwnershipNotInitializedForExtraData();
256 
257     // =============================================================
258     //                            STRUCTS
259     // =============================================================
260 
261     struct TokenOwnership {
262         // The address of the owner.
263         address addr;
264         // Stores the start time of ownership with minimal overhead for tokenomics.
265         uint64 startTimestamp;
266         // Whether the token has been burned.
267         bool burned;
268         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
269         uint24 extraData;
270     }
271 
272     // =============================================================
273     //                         TOKEN COUNTERS
274     // =============================================================
275 
276     /**
277      * @dev Returns the total number of tokens in existence.
278      * Burned tokens will reduce the count.
279      * To get the total number of tokens minted, please see {_totalMinted}.
280      */
281     function totalSupply() external view returns (uint256);
282 
283     // =============================================================
284     //                            IERC165
285     // =============================================================
286 
287     /**
288      * @dev Returns true if this contract implements the interface defined by
289      * `interfaceId`. See the corresponding
290      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
291      * to learn more about how these ids are created.
292      *
293      * This function call must use less than 30000 gas.
294      */
295     function supportsInterface(bytes4 interfaceId) external view returns (bool);
296 
297     // =============================================================
298     //                            IERC721
299     // =============================================================
300 
301     /**
302      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
303      */
304     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
305 
306     /**
307      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
308      */
309     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
310 
311     /**
312      * @dev Emitted when `owner` enables or disables
313      * (`approved`) `operator` to manage all of its assets.
314      */
315     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
316 
317     /**
318      * @dev Returns the number of tokens in `owner`'s account.
319      */
320     function balanceOf(address owner) external view returns (uint256 balance);
321 
322     /**
323      * @dev Returns the owner of the `tokenId` token.
324      *
325      * Requirements:
326      *
327      * - `tokenId` must exist.
328      */
329     function ownerOf(uint256 tokenId) external view returns (address owner);
330 
331     /**
332      * @dev Safely transfers `tokenId` token from `from` to `to`,
333      * checking first that contract recipients are aware of the ERC721 protocol
334      * to prevent tokens from being forever locked.
335      *
336      * Requirements:
337      *
338      * - `from` cannot be the zero address.
339      * - `to` cannot be the zero address.
340      * - `tokenId` token must exist and be owned by `from`.
341      * - If the caller is not `from`, it must be have been allowed to move
342      * this token by either {approve} or {setApprovalForAll}.
343      * - If `to` refers to a smart contract, it must implement
344      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
345      *
346      * Emits a {Transfer} event.
347      */
348     function safeTransferFrom(
349         address from,
350         address to,
351         uint256 tokenId,
352         bytes calldata data
353     ) external payable;
354 
355     /**
356      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
357      */
358     function safeTransferFrom(
359         address from,
360         address to,
361         uint256 tokenId
362     ) external payable;
363 
364     /**
365      * @dev Transfers `tokenId` from `from` to `to`.
366      *
367      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
368      * whenever possible.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must be owned by `from`.
375      * - If the caller is not `from`, it must be approved to move this token
376      * by either {approve} or {setApprovalForAll}.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) external payable;
385 
386     /**
387      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
388      * The approval is cleared when the token is transferred.
389      *
390      * Only a single account can be approved at a time, so approving the
391      * zero address clears previous approvals.
392      *
393      * Requirements:
394      *
395      * - The caller must own the token or be an approved operator.
396      * - `tokenId` must exist.
397      *
398      * Emits an {Approval} event.
399      */
400     function approve(address to, uint256 tokenId) external payable;
401 
402     /**
403      * @dev Approve or remove `operator` as an operator for the caller.
404      * Operators can call {transferFrom} or {safeTransferFrom}
405      * for any token owned by the caller.
406      *
407      * Requirements:
408      *
409      * - The `operator` cannot be the caller.
410      *
411      * Emits an {ApprovalForAll} event.
412      */
413     function setApprovalForAll(address operator, bool _approved) external;
414 
415     /**
416      * @dev Returns the account approved for `tokenId` token.
417      *
418      * Requirements:
419      *
420      * - `tokenId` must exist.
421      */
422     function getApproved(uint256 tokenId) external view returns (address operator);
423 
424     /**
425      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
426      *
427      * See {setApprovalForAll}.
428      */
429     function isApprovedForAll(address owner, address operator) external view returns (bool);
430 
431     // =============================================================
432     //                        IERC721Metadata
433     // =============================================================
434 
435     /**
436      * @dev Returns the token collection name.
437      */
438     function name() external view returns (string memory);
439 
440     /**
441      * @dev Returns the token collection symbol.
442      */
443     function symbol() external view returns (string memory);
444 
445     /**
446      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
447      */
448     function tokenURI(uint256 tokenId) external view returns (string memory);
449 
450     // =============================================================
451     //                           IERC2309
452     // =============================================================
453 
454     /**
455      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
456      * (inclusive) is transferred from `from` to `to`, as defined in the
457      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
458      *
459      * See {_mintERC2309} for more details.
460      */
461     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
462 }
463 
464 // File: erc721a/contracts/ERC721A.sol
465 
466 
467 // ERC721A Contracts v4.2.3
468 // Creator: Chiru Labs
469 
470 pragma solidity ^0.8.4;
471 
472 
473 /**
474  * @dev Interface of ERC721 token receiver.
475  */
476 interface ERC721A__IERC721Receiver {
477     function onERC721Received(
478         address operator,
479         address from,
480         uint256 tokenId,
481         bytes calldata data
482     ) external returns (bytes4);
483 }
484 
485 /**
486  * @title ERC721A
487  *
488  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
489  * Non-Fungible Token Standard, including the Metadata extension.
490  * Optimized for lower gas during batch mints.
491  *
492  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
493  * starting from `_startTokenId()`.
494  *
495  * Assumptions:
496  *
497  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
498  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
499  */
500 contract ERC721A is IERC721A {
501     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
502     struct TokenApprovalRef {
503         address value;
504     }
505 
506     // =============================================================
507     //                           CONSTANTS
508     // =============================================================
509 
510     // Mask of an entry in packed address data.
511     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
512 
513     // The bit position of `numberMinted` in packed address data.
514     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
515 
516     // The bit position of `numberBurned` in packed address data.
517     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
518 
519     // The bit position of `aux` in packed address data.
520     uint256 private constant _BITPOS_AUX = 192;
521 
522     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
523     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
524 
525     // The bit position of `startTimestamp` in packed ownership.
526     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
527 
528     // The bit mask of the `burned` bit in packed ownership.
529     uint256 private constant _BITMASK_BURNED = 1 << 224;
530 
531     // The bit position of the `nextInitialized` bit in packed ownership.
532     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
533 
534     // The bit mask of the `nextInitialized` bit in packed ownership.
535     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
536 
537     // The bit position of `extraData` in packed ownership.
538     uint256 private constant _BITPOS_EXTRA_DATA = 232;
539 
540     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
541     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
542 
543     // The mask of the lower 160 bits for addresses.
544     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
545 
546     // The maximum `quantity` that can be minted with {_mintERC2309}.
547     // This limit is to prevent overflows on the address data entries.
548     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
549     // is required to cause an overflow, which is unrealistic.
550     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
551 
552     // The `Transfer` event signature is given by:
553     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
554     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
555         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
556 
557     // =============================================================
558     //                            STORAGE
559     // =============================================================
560 
561     // The next token ID to be minted.
562     uint256 private _currentIndex;
563 
564     // The number of tokens burned.
565     uint256 private _burnCounter;
566 
567     // Token name
568     string private _name;
569 
570     // Token symbol
571     string private _symbol;
572 
573     // Mapping from token ID to ownership details
574     // An empty struct value does not necessarily mean the token is unowned.
575     // See {_packedOwnershipOf} implementation for details.
576     //
577     // Bits Layout:
578     // - [0..159]   `addr`
579     // - [160..223] `startTimestamp`
580     // - [224]      `burned`
581     // - [225]      `nextInitialized`
582     // - [232..255] `extraData`
583     mapping(uint256 => uint256) private _packedOwnerships;
584 
585     // Mapping owner address to address data.
586     //
587     // Bits Layout:
588     // - [0..63]    `balance`
589     // - [64..127]  `numberMinted`
590     // - [128..191] `numberBurned`
591     // - [192..255] `aux`
592     mapping(address => uint256) private _packedAddressData;
593 
594     // Mapping from token ID to approved address.
595     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
596 
597     // Mapping from owner to operator approvals
598     mapping(address => mapping(address => bool)) private _operatorApprovals;
599 
600     // =============================================================
601     //                          CONSTRUCTOR
602     // =============================================================
603 
604     constructor(string memory name_, string memory symbol_) {
605         _name = name_;
606         _symbol = symbol_;
607         _currentIndex = _startTokenId();
608     }
609 
610     // =============================================================
611     //                   TOKEN COUNTING OPERATIONS
612     // =============================================================
613 
614     /**
615      * @dev Returns the starting token ID.
616      * To change the starting token ID, please override this function.
617      */
618     function _startTokenId() internal view virtual returns (uint256) {
619         return 0;
620     }
621 
622     /**
623      * @dev Returns the next token ID to be minted.
624      */
625     function _nextTokenId() internal view virtual returns (uint256) {
626         return _currentIndex;
627     }
628 
629     /**
630      * @dev Returns the total number of tokens in existence.
631      * Burned tokens will reduce the count.
632      * To get the total number of tokens minted, please see {_totalMinted}.
633      */
634     function totalSupply() public view virtual override returns (uint256) {
635         // Counter underflow is impossible as _burnCounter cannot be incremented
636         // more than `_currentIndex - _startTokenId()` times.
637         unchecked {
638             return _currentIndex - _burnCounter - _startTokenId();
639         }
640     }
641 
642     /**
643      * @dev Returns the total amount of tokens minted in the contract.
644      */
645     function _totalMinted() internal view virtual returns (uint256) {
646         // Counter underflow is impossible as `_currentIndex` does not decrement,
647         // and it is initialized to `_startTokenId()`.
648         unchecked {
649             return _currentIndex - _startTokenId();
650         }
651     }
652 
653     /**
654      * @dev Returns the total number of tokens burned.
655      */
656     function _totalBurned() internal view virtual returns (uint256) {
657         return _burnCounter;
658     }
659 
660     // =============================================================
661     //                    ADDRESS DATA OPERATIONS
662     // =============================================================
663 
664     /**
665      * @dev Returns the number of tokens in `owner`'s account.
666      */
667     function balanceOf(address owner) public view virtual override returns (uint256) {
668         if (owner == address(0)) revert BalanceQueryForZeroAddress();
669         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
670     }
671 
672     /**
673      * Returns the number of tokens minted by `owner`.
674      */
675     function _numberMinted(address owner) internal view returns (uint256) {
676         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
677     }
678 
679     /**
680      * Returns the number of tokens burned by or on behalf of `owner`.
681      */
682     function _numberBurned(address owner) internal view returns (uint256) {
683         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
684     }
685 
686     /**
687      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
688      */
689     function _getAux(address owner) internal view returns (uint64) {
690         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
691     }
692 
693     /**
694      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
695      * If there are multiple variables, please pack them into a uint64.
696      */
697     function _setAux(address owner, uint64 aux) internal virtual {
698         uint256 packed = _packedAddressData[owner];
699         uint256 auxCasted;
700         // Cast `aux` with assembly to avoid redundant masking.
701         assembly {
702             auxCasted := aux
703         }
704         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
705         _packedAddressData[owner] = packed;
706     }
707 
708     // =============================================================
709     //                            IERC165
710     // =============================================================
711 
712     /**
713      * @dev Returns true if this contract implements the interface defined by
714      * `interfaceId`. See the corresponding
715      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
716      * to learn more about how these ids are created.
717      *
718      * This function call must use less than 30000 gas.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
721         // The interface IDs are constants representing the first 4 bytes
722         // of the XOR of all function selectors in the interface.
723         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
724         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
725         return
726             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
727             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
728             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
729     }
730 
731     // =============================================================
732     //                        IERC721Metadata
733     // =============================================================
734 
735     /**
736      * @dev Returns the token collection name.
737      */
738     function name() public view virtual override returns (string memory) {
739         return _name;
740     }
741 
742     /**
743      * @dev Returns the token collection symbol.
744      */
745     function symbol() public view virtual override returns (string memory) {
746         return _symbol;
747     }
748 
749     /**
750      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
751      */
752     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
753         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
754 
755         string memory baseURI = _baseURI();
756         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
757     }
758 
759     /**
760      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
761      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
762      * by default, it can be overridden in child contracts.
763      */
764     function _baseURI() internal view virtual returns (string memory) {
765         return '';
766     }
767 
768     // =============================================================
769     //                     OWNERSHIPS OPERATIONS
770     // =============================================================
771 
772     /**
773      * @dev Returns the owner of the `tokenId` token.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must exist.
778      */
779     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
780         return address(uint160(_packedOwnershipOf(tokenId)));
781     }
782 
783     /**
784      * @dev Gas spent here starts off proportional to the maximum mint batch size.
785      * It gradually moves to O(1) as tokens get transferred around over time.
786      */
787     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
788         return _unpackedOwnership(_packedOwnershipOf(tokenId));
789     }
790 
791     /**
792      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
793      */
794     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
795         return _unpackedOwnership(_packedOwnerships[index]);
796     }
797 
798     /**
799      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
800      */
801     function _initializeOwnershipAt(uint256 index) internal virtual {
802         if (_packedOwnerships[index] == 0) {
803             _packedOwnerships[index] = _packedOwnershipOf(index);
804         }
805     }
806 
807     /**
808      * Returns the packed ownership data of `tokenId`.
809      */
810     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
811         uint256 curr = tokenId;
812 
813         unchecked {
814             if (_startTokenId() <= curr)
815                 if (curr < _currentIndex) {
816                     uint256 packed = _packedOwnerships[curr];
817                     // If not burned.
818                     if (packed & _BITMASK_BURNED == 0) {
819                         // Invariant:
820                         // There will always be an initialized ownership slot
821                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
822                         // before an unintialized ownership slot
823                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
824                         // Hence, `curr` will not underflow.
825                         //
826                         // We can directly compare the packed value.
827                         // If the address is zero, packed will be zero.
828                         while (packed == 0) {
829                             packed = _packedOwnerships[--curr];
830                         }
831                         return packed;
832                     }
833                 }
834         }
835         revert OwnerQueryForNonexistentToken();
836     }
837 
838     /**
839      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
840      */
841     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
842         ownership.addr = address(uint160(packed));
843         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
844         ownership.burned = packed & _BITMASK_BURNED != 0;
845         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
846     }
847 
848     /**
849      * @dev Packs ownership data into a single uint256.
850      */
851     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
852         assembly {
853             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
854             owner := and(owner, _BITMASK_ADDRESS)
855             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
856             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
857         }
858     }
859 
860     /**
861      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
862      */
863     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
864         // For branchless setting of the `nextInitialized` flag.
865         assembly {
866             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
867             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
868         }
869     }
870 
871     // =============================================================
872     //                      APPROVAL OPERATIONS
873     // =============================================================
874 
875     /**
876      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
877      * The approval is cleared when the token is transferred.
878      *
879      * Only a single account can be approved at a time, so approving the
880      * zero address clears previous approvals.
881      *
882      * Requirements:
883      *
884      * - The caller must own the token or be an approved operator.
885      * - `tokenId` must exist.
886      *
887      * Emits an {Approval} event.
888      */
889     function approve(address to, uint256 tokenId) public payable virtual override {
890         address owner = ownerOf(tokenId);
891 
892         if (_msgSenderERC721A() != owner)
893             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
894                 revert ApprovalCallerNotOwnerNorApproved();
895             }
896 
897         _tokenApprovals[tokenId].value = to;
898         emit Approval(owner, to, tokenId);
899     }
900 
901     /**
902      * @dev Returns the account approved for `tokenId` token.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      */
908     function getApproved(uint256 tokenId) public view virtual override returns (address) {
909         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
910 
911         return _tokenApprovals[tokenId].value;
912     }
913 
914     /**
915      * @dev Approve or remove `operator` as an operator for the caller.
916      * Operators can call {transferFrom} or {safeTransferFrom}
917      * for any token owned by the caller.
918      *
919      * Requirements:
920      *
921      * - The `operator` cannot be the caller.
922      *
923      * Emits an {ApprovalForAll} event.
924      */
925     function setApprovalForAll(address operator, bool approved) public virtual override {
926         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
927         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
928     }
929 
930     /**
931      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
932      *
933      * See {setApprovalForAll}.
934      */
935     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
936         return _operatorApprovals[owner][operator];
937     }
938 
939     /**
940      * @dev Returns whether `tokenId` exists.
941      *
942      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
943      *
944      * Tokens start existing when they are minted. See {_mint}.
945      */
946     function _exists(uint256 tokenId) internal view virtual returns (bool) {
947         return
948             _startTokenId() <= tokenId &&
949             tokenId < _currentIndex && // If within bounds,
950             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
951     }
952 
953     /**
954      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
955      */
956     function _isSenderApprovedOrOwner(
957         address approvedAddress,
958         address owner,
959         address msgSender
960     ) private pure returns (bool result) {
961         assembly {
962             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
963             owner := and(owner, _BITMASK_ADDRESS)
964             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
965             msgSender := and(msgSender, _BITMASK_ADDRESS)
966             // `msgSender == owner || msgSender == approvedAddress`.
967             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
968         }
969     }
970 
971     /**
972      * @dev Returns the storage slot and value for the approved address of `tokenId`.
973      */
974     function _getApprovedSlotAndAddress(uint256 tokenId)
975         private
976         view
977         returns (uint256 approvedAddressSlot, address approvedAddress)
978     {
979         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
980         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
981         assembly {
982             approvedAddressSlot := tokenApproval.slot
983             approvedAddress := sload(approvedAddressSlot)
984         }
985     }
986 
987     // =============================================================
988     //                      TRANSFER OPERATIONS
989     // =============================================================
990 
991     /**
992      * @dev Transfers `tokenId` from `from` to `to`.
993      *
994      * Requirements:
995      *
996      * - `from` cannot be the zero address.
997      * - `to` cannot be the zero address.
998      * - `tokenId` token must be owned by `from`.
999      * - If the caller is not `from`, it must be approved to move this token
1000      * by either {approve} or {setApprovalForAll}.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function transferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public payable virtual override {
1009         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1010 
1011         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1012 
1013         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1014 
1015         // The nested ifs save around 20+ gas over a compound boolean condition.
1016         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1017             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1018 
1019         if (to == address(0)) revert TransferToZeroAddress();
1020 
1021         _beforeTokenTransfers(from, to, tokenId, 1);
1022 
1023         // Clear approvals from the previous owner.
1024         assembly {
1025             if approvedAddress {
1026                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1027                 sstore(approvedAddressSlot, 0)
1028             }
1029         }
1030 
1031         // Underflow of the sender's balance is impossible because we check for
1032         // ownership above and the recipient's balance can't realistically overflow.
1033         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1034         unchecked {
1035             // We can directly increment and decrement the balances.
1036             --_packedAddressData[from]; // Updates: `balance -= 1`.
1037             ++_packedAddressData[to]; // Updates: `balance += 1`.
1038 
1039             // Updates:
1040             // - `address` to the next owner.
1041             // - `startTimestamp` to the timestamp of transfering.
1042             // - `burned` to `false`.
1043             // - `nextInitialized` to `true`.
1044             _packedOwnerships[tokenId] = _packOwnershipData(
1045                 to,
1046                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1047             );
1048 
1049             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1050             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1051                 uint256 nextTokenId = tokenId + 1;
1052                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1053                 if (_packedOwnerships[nextTokenId] == 0) {
1054                     // If the next slot is within bounds.
1055                     if (nextTokenId != _currentIndex) {
1056                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1057                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1058                     }
1059                 }
1060             }
1061         }
1062 
1063         emit Transfer(from, to, tokenId);
1064         _afterTokenTransfers(from, to, tokenId, 1);
1065     }
1066 
1067     /**
1068      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1069      */
1070     function safeTransferFrom(
1071         address from,
1072         address to,
1073         uint256 tokenId
1074     ) public payable virtual override {
1075         safeTransferFrom(from, to, tokenId, '');
1076     }
1077 
1078     /**
1079      * @dev Safely transfers `tokenId` token from `from` to `to`.
1080      *
1081      * Requirements:
1082      *
1083      * - `from` cannot be the zero address.
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must exist and be owned by `from`.
1086      * - If the caller is not `from`, it must be approved to move this token
1087      * by either {approve} or {setApprovalForAll}.
1088      * - If `to` refers to a smart contract, it must implement
1089      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function safeTransferFrom(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) public payable virtual override {
1099         transferFrom(from, to, tokenId);
1100         if (to.code.length != 0)
1101             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1102                 revert TransferToNonERC721ReceiverImplementer();
1103             }
1104     }
1105 
1106     /**
1107      * @dev Hook that is called before a set of serially-ordered token IDs
1108      * are about to be transferred. This includes minting.
1109      * And also called before burning one token.
1110      *
1111      * `startTokenId` - the first token ID to be transferred.
1112      * `quantity` - the amount to be transferred.
1113      *
1114      * Calling conditions:
1115      *
1116      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1117      * transferred to `to`.
1118      * - When `from` is zero, `tokenId` will be minted for `to`.
1119      * - When `to` is zero, `tokenId` will be burned by `from`.
1120      * - `from` and `to` are never both zero.
1121      */
1122     function _beforeTokenTransfers(
1123         address from,
1124         address to,
1125         uint256 startTokenId,
1126         uint256 quantity
1127     ) internal virtual {}
1128 
1129     /**
1130      * @dev Hook that is called after a set of serially-ordered token IDs
1131      * have been transferred. This includes minting.
1132      * And also called after one token has been burned.
1133      *
1134      * `startTokenId` - the first token ID to be transferred.
1135      * `quantity` - the amount to be transferred.
1136      *
1137      * Calling conditions:
1138      *
1139      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1140      * transferred to `to`.
1141      * - When `from` is zero, `tokenId` has been minted for `to`.
1142      * - When `to` is zero, `tokenId` has been burned by `from`.
1143      * - `from` and `to` are never both zero.
1144      */
1145     function _afterTokenTransfers(
1146         address from,
1147         address to,
1148         uint256 startTokenId,
1149         uint256 quantity
1150     ) internal virtual {}
1151 
1152     /**
1153      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1154      *
1155      * `from` - Previous owner of the given token ID.
1156      * `to` - Target address that will receive the token.
1157      * `tokenId` - Token ID to be transferred.
1158      * `_data` - Optional data to send along with the call.
1159      *
1160      * Returns whether the call correctly returned the expected magic value.
1161      */
1162     function _checkContractOnERC721Received(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) private returns (bool) {
1168         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1169             bytes4 retval
1170         ) {
1171             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1172         } catch (bytes memory reason) {
1173             if (reason.length == 0) {
1174                 revert TransferToNonERC721ReceiverImplementer();
1175             } else {
1176                 assembly {
1177                     revert(add(32, reason), mload(reason))
1178                 }
1179             }
1180         }
1181     }
1182 
1183     // =============================================================
1184     //                        MINT OPERATIONS
1185     // =============================================================
1186 
1187     /**
1188      * @dev Mints `quantity` tokens and transfers them to `to`.
1189      *
1190      * Requirements:
1191      *
1192      * - `to` cannot be the zero address.
1193      * - `quantity` must be greater than 0.
1194      *
1195      * Emits a {Transfer} event for each mint.
1196      */
1197     function _mint(address to, uint256 quantity) internal virtual {
1198         uint256 startTokenId = _currentIndex;
1199         if (quantity == 0) revert MintZeroQuantity();
1200 
1201         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1202 
1203         // Overflows are incredibly unrealistic.
1204         // `balance` and `numberMinted` have a maximum limit of 2**64.
1205         // `tokenId` has a maximum limit of 2**256.
1206         unchecked {
1207             // Updates:
1208             // - `balance += quantity`.
1209             // - `numberMinted += quantity`.
1210             //
1211             // We can directly add to the `balance` and `numberMinted`.
1212             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1213 
1214             // Updates:
1215             // - `address` to the owner.
1216             // - `startTimestamp` to the timestamp of minting.
1217             // - `burned` to `false`.
1218             // - `nextInitialized` to `quantity == 1`.
1219             _packedOwnerships[startTokenId] = _packOwnershipData(
1220                 to,
1221                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1222             );
1223 
1224             uint256 toMasked;
1225             uint256 end = startTokenId + quantity;
1226 
1227             // Use assembly to loop and emit the `Transfer` event for gas savings.
1228             // The duplicated `log4` removes an extra check and reduces stack juggling.
1229             // The assembly, together with the surrounding Solidity code, have been
1230             // delicately arranged to nudge the compiler into producing optimized opcodes.
1231             assembly {
1232                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1233                 toMasked := and(to, _BITMASK_ADDRESS)
1234                 // Emit the `Transfer` event.
1235                 log4(
1236                     0, // Start of data (0, since no data).
1237                     0, // End of data (0, since no data).
1238                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1239                     0, // `address(0)`.
1240                     toMasked, // `to`.
1241                     startTokenId // `tokenId`.
1242                 )
1243 
1244                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1245                 // that overflows uint256 will make the loop run out of gas.
1246                 // The compiler will optimize the `iszero` away for performance.
1247                 for {
1248                     let tokenId := add(startTokenId, 1)
1249                 } iszero(eq(tokenId, end)) {
1250                     tokenId := add(tokenId, 1)
1251                 } {
1252                     // Emit the `Transfer` event. Similar to above.
1253                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1254                 }
1255             }
1256             if (toMasked == 0) revert MintToZeroAddress();
1257 
1258             _currentIndex = end;
1259         }
1260         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1261     }
1262 
1263     /**
1264      * @dev Mints `quantity` tokens and transfers them to `to`.
1265      *
1266      * This function is intended for efficient minting only during contract creation.
1267      *
1268      * It emits only one {ConsecutiveTransfer} as defined in
1269      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1270      * instead of a sequence of {Transfer} event(s).
1271      *
1272      * Calling this function outside of contract creation WILL make your contract
1273      * non-compliant with the ERC721 standard.
1274      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1275      * {ConsecutiveTransfer} event is only permissible during contract creation.
1276      *
1277      * Requirements:
1278      *
1279      * - `to` cannot be the zero address.
1280      * - `quantity` must be greater than 0.
1281      *
1282      * Emits a {ConsecutiveTransfer} event.
1283      */
1284     function _mintERC2309(address to, uint256 quantity) internal virtual {
1285         uint256 startTokenId = _currentIndex;
1286         if (to == address(0)) revert MintToZeroAddress();
1287         if (quantity == 0) revert MintZeroQuantity();
1288         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1289 
1290         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1291 
1292         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1293         unchecked {
1294             // Updates:
1295             // - `balance += quantity`.
1296             // - `numberMinted += quantity`.
1297             //
1298             // We can directly add to the `balance` and `numberMinted`.
1299             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1300 
1301             // Updates:
1302             // - `address` to the owner.
1303             // - `startTimestamp` to the timestamp of minting.
1304             // - `burned` to `false`.
1305             // - `nextInitialized` to `quantity == 1`.
1306             _packedOwnerships[startTokenId] = _packOwnershipData(
1307                 to,
1308                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1309             );
1310 
1311             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1312 
1313             _currentIndex = startTokenId + quantity;
1314         }
1315         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1316     }
1317 
1318     /**
1319      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1320      *
1321      * Requirements:
1322      *
1323      * - If `to` refers to a smart contract, it must implement
1324      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1325      * - `quantity` must be greater than 0.
1326      *
1327      * See {_mint}.
1328      *
1329      * Emits a {Transfer} event for each mint.
1330      */
1331     function _safeMint(
1332         address to,
1333         uint256 quantity,
1334         bytes memory _data
1335     ) internal virtual {
1336         _mint(to, quantity);
1337 
1338         unchecked {
1339             if (to.code.length != 0) {
1340                 uint256 end = _currentIndex;
1341                 uint256 index = end - quantity;
1342                 do {
1343                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1344                         revert TransferToNonERC721ReceiverImplementer();
1345                     }
1346                 } while (index < end);
1347                 // Reentrancy protection.
1348                 if (_currentIndex != end) revert();
1349             }
1350         }
1351     }
1352 
1353     /**
1354      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1355      */
1356     function _safeMint(address to, uint256 quantity) internal virtual {
1357         _safeMint(to, quantity, '');
1358     }
1359 
1360     // =============================================================
1361     //                        BURN OPERATIONS
1362     // =============================================================
1363 
1364     /**
1365      * @dev Equivalent to `_burn(tokenId, false)`.
1366      */
1367     function _burn(uint256 tokenId) internal virtual {
1368         _burn(tokenId, false);
1369     }
1370 
1371     /**
1372      * @dev Destroys `tokenId`.
1373      * The approval is cleared when the token is burned.
1374      *
1375      * Requirements:
1376      *
1377      * - `tokenId` must exist.
1378      *
1379      * Emits a {Transfer} event.
1380      */
1381     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1382         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1383 
1384         address from = address(uint160(prevOwnershipPacked));
1385 
1386         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1387 
1388         if (approvalCheck) {
1389             // The nested ifs save around 20+ gas over a compound boolean condition.
1390             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1391                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1392         }
1393 
1394         _beforeTokenTransfers(from, address(0), tokenId, 1);
1395 
1396         // Clear approvals from the previous owner.
1397         assembly {
1398             if approvedAddress {
1399                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1400                 sstore(approvedAddressSlot, 0)
1401             }
1402         }
1403 
1404         // Underflow of the sender's balance is impossible because we check for
1405         // ownership above and the recipient's balance can't realistically overflow.
1406         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1407         unchecked {
1408             // Updates:
1409             // - `balance -= 1`.
1410             // - `numberBurned += 1`.
1411             //
1412             // We can directly decrement the balance, and increment the number burned.
1413             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1414             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1415 
1416             // Updates:
1417             // - `address` to the last owner.
1418             // - `startTimestamp` to the timestamp of burning.
1419             // - `burned` to `true`.
1420             // - `nextInitialized` to `true`.
1421             _packedOwnerships[tokenId] = _packOwnershipData(
1422                 from,
1423                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1424             );
1425 
1426             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1427             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1428                 uint256 nextTokenId = tokenId + 1;
1429                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1430                 if (_packedOwnerships[nextTokenId] == 0) {
1431                     // If the next slot is within bounds.
1432                     if (nextTokenId != _currentIndex) {
1433                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1434                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1435                     }
1436                 }
1437             }
1438         }
1439 
1440         emit Transfer(from, address(0), tokenId);
1441         _afterTokenTransfers(from, address(0), tokenId, 1);
1442 
1443         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1444         unchecked {
1445             _burnCounter++;
1446         }
1447     }
1448 
1449     // =============================================================
1450     //                     EXTRA DATA OPERATIONS
1451     // =============================================================
1452 
1453     /**
1454      * @dev Directly sets the extra data for the ownership data `index`.
1455      */
1456     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1457         uint256 packed = _packedOwnerships[index];
1458         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1459         uint256 extraDataCasted;
1460         // Cast `extraData` with assembly to avoid redundant masking.
1461         assembly {
1462             extraDataCasted := extraData
1463         }
1464         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1465         _packedOwnerships[index] = packed;
1466     }
1467 
1468     /**
1469      * @dev Called during each token transfer to set the 24bit `extraData` field.
1470      * Intended to be overridden by the cosumer contract.
1471      *
1472      * `previousExtraData` - the value of `extraData` before transfer.
1473      *
1474      * Calling conditions:
1475      *
1476      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1477      * transferred to `to`.
1478      * - When `from` is zero, `tokenId` will be minted for `to`.
1479      * - When `to` is zero, `tokenId` will be burned by `from`.
1480      * - `from` and `to` are never both zero.
1481      */
1482     function _extraData(
1483         address from,
1484         address to,
1485         uint24 previousExtraData
1486     ) internal view virtual returns (uint24) {}
1487 
1488     /**
1489      * @dev Returns the next extra data for the packed ownership data.
1490      * The returned result is shifted into position.
1491      */
1492     function _nextExtraData(
1493         address from,
1494         address to,
1495         uint256 prevOwnershipPacked
1496     ) private view returns (uint256) {
1497         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1498         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1499     }
1500 
1501     // =============================================================
1502     //                       OTHER OPERATIONS
1503     // =============================================================
1504 
1505     /**
1506      * @dev Returns the message sender (defaults to `msg.sender`).
1507      *
1508      * If you are writing GSN compatible contracts, you need to override this function.
1509      */
1510     function _msgSenderERC721A() internal view virtual returns (address) {
1511         return msg.sender;
1512     }
1513 
1514     /**
1515      * @dev Converts a uint256 to its ASCII string decimal representation.
1516      */
1517     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1518         assembly {
1519             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1520             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1521             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1522             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1523             let m := add(mload(0x40), 0xa0)
1524             // Update the free memory pointer to allocate.
1525             mstore(0x40, m)
1526             // Assign the `str` to the end.
1527             str := sub(m, 0x20)
1528             // Zeroize the slot after the string.
1529             mstore(str, 0)
1530 
1531             // Cache the end of the memory to calculate the length later.
1532             let end := str
1533 
1534             // We write the string from rightmost digit to leftmost digit.
1535             // The following is essentially a do-while loop that also handles the zero case.
1536             // prettier-ignore
1537             for { let temp := value } 1 {} {
1538                 str := sub(str, 1)
1539                 // Write the character to the pointer.
1540                 // The ASCII index of the '0' character is 48.
1541                 mstore8(str, add(48, mod(temp, 10)))
1542                 // Keep dividing `temp` until zero.
1543                 temp := div(temp, 10)
1544                 // prettier-ignore
1545                 if iszero(temp) { break }
1546             }
1547 
1548             let length := sub(end, str)
1549             // Move the pointer 32 bytes leftwards to make room for the length.
1550             str := sub(str, 0x20)
1551             // Store the length.
1552             mstore(str, length)
1553         }
1554     }
1555 }
1556 
1557 // File: contracts/Mosaic.sol
1558 
1559 
1560 
1561 pragma solidity ^0.8.7;
1562 
1563 
1564 
1565 
1566 interface ICreateCards {
1567     function ownerOf(uint256 tokenId) external view returns (address);
1568     function getCredits(uint256 tokenId) external view returns (uint256);
1569 }
1570 
1571 contract Mosaic is ERC721A, Ownable, ReentrancyGuard {
1572 
1573   mapping(uint256 => bool) public hasCreateCardMinted;
1574   
1575   address public createCardContract = 0x5e7Dd1e569E75A7C2c1395d625daC3275Dc94012;
1576   bool public MINT_ACTIVE = false;
1577   uint256 public constant MAX_SUPPLY = 3002;
1578 
1579   string public metadataURI;
1580 
1581   constructor() ERC721A("Mosaic", "MOSAIC") {}
1582 
1583   // MINT ---------------------------------------------
1584 
1585   function mint(uint256 createCardId) public {
1586       require(MINT_ACTIVE, "Mint inactive.");
1587       require(ICreateCards(createCardContract).ownerOf(createCardId) == msg.sender, "You don't own that Create Card.");
1588       require(!hasCreateCardMinted[createCardId], "Already minted.");
1589       require(totalSupply() + 1 <= MAX_SUPPLY, "Sold out.");
1590       require(ICreateCards(createCardContract).getCredits(createCardId) >= 5000, "You must have 5k Create Credits.");
1591 
1592       hasCreateCardMinted[createCardId] = true;  
1593       _safeMint(msg.sender, 1);
1594   }
1595 
1596   // CONTRACT MANAGEMENT ---------------------------------------------
1597   
1598   function setMetadataURI(string memory _metadataURI) public onlyOwner {
1599     metadataURI = _metadataURI;
1600   }
1601 
1602   function toggleMint() public onlyOwner {
1603     MINT_ACTIVE = !MINT_ACTIVE;
1604   }
1605 
1606   // OVERRIDES ---------------------------------------------
1607 
1608   function _baseURI() internal view override returns (string memory) {
1609     return metadataURI;
1610   }
1611 
1612   // WITHDRAW ---------------------------------------------
1613 
1614   function withdraw() public onlyOwner {
1615       (bool success,) = msg.sender.call{value: address(this).balance}("");
1616       require(success, "Failed to withdraw ETH.");
1617   }
1618 }