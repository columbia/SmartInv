1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
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
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     /**
129      * @dev Returns the address of the current owner.
130      */
131     function owner() public view virtual returns (address) {
132         return _owner;
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     /**
144      * @dev Leaves the contract without owner. It will not be possible to call
145      * `onlyOwner` functions anymore. Can only be called by the current owner.
146      *
147      * NOTE: Renouncing ownership will leave the contract without an owner,
148      * thereby removing any functionality that is only available to the owner.
149      */
150     function renounceOwnership() public virtual onlyOwner {
151         _transferOwnership(address(0));
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Can only be called by the current owner.
157      */
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         _transferOwnership(newOwner);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Internal function without access restriction.
166      */
167     function _transferOwnership(address newOwner) internal virtual {
168         address oldOwner = _owner;
169         _owner = newOwner;
170         emit OwnershipTransferred(oldOwner, newOwner);
171     }
172 }
173 
174 // File: erc721a/contracts/IERC721A.sol
175 
176 
177 // ERC721A Contracts v4.0.0
178 // Creator: Chiru Labs
179 
180 pragma solidity ^0.8.4;
181 
182 /**
183  * @dev Interface of an ERC721A compliant contract.
184  */
185 interface IERC721A {
186     /**
187      * The caller must own the token or be an approved operator.
188      */
189     error ApprovalCallerNotOwnerNorApproved();
190 
191     /**
192      * The token does not exist.
193      */
194     error ApprovalQueryForNonexistentToken();
195 
196     /**
197      * The caller cannot approve to their own address.
198      */
199     error ApproveToCaller();
200 
201     /**
202      * The caller cannot approve to the current owner.
203      */
204     error ApprovalToCurrentOwner();
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
237      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
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
251     struct TokenOwnership {
252         // The address of the owner.
253         address addr;
254         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
255         uint64 startTimestamp;
256         // Whether the token has been burned.
257         bool burned;
258     }
259 
260     /**
261      * @dev Returns the total amount of tokens stored by the contract.
262      *
263      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
264      */
265     function totalSupply() external view returns (uint256);
266 
267     // ==============================
268     //            IERC165
269     // ==============================
270 
271     /**
272      * @dev Returns true if this contract implements the interface defined by
273      * `interfaceId`. See the corresponding
274      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
275      * to learn more about how these ids are created.
276      *
277      * This function call must use less than 30 000 gas.
278      */
279     function supportsInterface(bytes4 interfaceId) external view returns (bool);
280 
281     // ==============================
282     //            IERC721
283     // ==============================
284 
285     /**
286      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
287      */
288     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
289 
290     /**
291      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
292      */
293     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
294 
295     /**
296      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
297      */
298     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
299 
300     /**
301      * @dev Returns the number of tokens in ``owner``'s account.
302      */
303     function balanceOf(address owner) external view returns (uint256 balance);
304 
305     /**
306      * @dev Returns the owner of the `tokenId` token.
307      *
308      * Requirements:
309      *
310      * - `tokenId` must exist.
311      */
312     function ownerOf(uint256 tokenId) external view returns (address owner);
313 
314     /**
315      * @dev Safely transfers `tokenId` token from `from` to `to`.
316      *
317      * Requirements:
318      *
319      * - `from` cannot be the zero address.
320      * - `to` cannot be the zero address.
321      * - `tokenId` token must exist and be owned by `from`.
322      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
323      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
324      *
325      * Emits a {Transfer} event.
326      */
327     function safeTransferFrom(
328         address from,
329         address to,
330         uint256 tokenId,
331         bytes calldata data
332     ) external;
333 
334     /**
335      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
336      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
337      *
338      * Requirements:
339      *
340      * - `from` cannot be the zero address.
341      * - `to` cannot be the zero address.
342      * - `tokenId` token must exist and be owned by `from`.
343      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
344      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
345      *
346      * Emits a {Transfer} event.
347      */
348     function safeTransferFrom(
349         address from,
350         address to,
351         uint256 tokenId
352     ) external;
353 
354     /**
355      * @dev Transfers `tokenId` token from `from` to `to`.
356      *
357      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      *
366      * Emits a {Transfer} event.
367      */
368     function transferFrom(
369         address from,
370         address to,
371         uint256 tokenId
372     ) external;
373 
374     /**
375      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
376      * The approval is cleared when the token is transferred.
377      *
378      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
379      *
380      * Requirements:
381      *
382      * - The caller must own the token or be an approved operator.
383      * - `tokenId` must exist.
384      *
385      * Emits an {Approval} event.
386      */
387     function approve(address to, uint256 tokenId) external;
388 
389     /**
390      * @dev Approve or remove `operator` as an operator for the caller.
391      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
392      *
393      * Requirements:
394      *
395      * - The `operator` cannot be the caller.
396      *
397      * Emits an {ApprovalForAll} event.
398      */
399     function setApprovalForAll(address operator, bool _approved) external;
400 
401     /**
402      * @dev Returns the account approved for `tokenId` token.
403      *
404      * Requirements:
405      *
406      * - `tokenId` must exist.
407      */
408     function getApproved(uint256 tokenId) external view returns (address operator);
409 
410     /**
411      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
412      *
413      * See {setApprovalForAll}
414      */
415     function isApprovedForAll(address owner, address operator) external view returns (bool);
416 
417     // ==============================
418     //        IERC721Metadata
419     // ==============================
420 
421     /**
422      * @dev Returns the token collection name.
423      */
424     function name() external view returns (string memory);
425 
426     /**
427      * @dev Returns the token collection symbol.
428      */
429     function symbol() external view returns (string memory);
430 
431     /**
432      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
433      */
434     function tokenURI(uint256 tokenId) external view returns (string memory);
435 }
436 
437 // File: erc721a/contracts/ERC721A.sol
438 
439 
440 // ERC721A Contracts v4.0.0
441 // Creator: Chiru Labs
442 
443 pragma solidity ^0.8.4;
444 
445 
446 /**
447  * @dev ERC721 token receiver interface.
448  */
449 interface ERC721A__IERC721Receiver {
450     function onERC721Received(
451         address operator,
452         address from,
453         uint256 tokenId,
454         bytes calldata data
455     ) external returns (bytes4);
456 }
457 
458 /**
459  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
460  * the Metadata extension. Built to optimize for lower gas during batch mints.
461  *
462  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
463  *
464  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
465  *
466  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
467  */
468 contract ERC721A is IERC721A {
469     // Mask of an entry in packed address data.
470     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
471 
472     // The bit position of `numberMinted` in packed address data.
473     uint256 private constant BITPOS_NUMBER_MINTED = 64;
474 
475     // The bit position of `numberBurned` in packed address data.
476     uint256 private constant BITPOS_NUMBER_BURNED = 128;
477 
478     // The bit position of `aux` in packed address data.
479     uint256 private constant BITPOS_AUX = 192;
480 
481     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
482     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
483 
484     // The bit position of `startTimestamp` in packed ownership.
485     uint256 private constant BITPOS_START_TIMESTAMP = 160;
486 
487     // The bit mask of the `burned` bit in packed ownership.
488     uint256 private constant BITMASK_BURNED = 1 << 224;
489     
490     // The bit position of the `nextInitialized` bit in packed ownership.
491     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
492 
493     // The bit mask of the `nextInitialized` bit in packed ownership.
494     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
495 
496     // The tokenId of the next token to be minted.
497     uint256 private _currentIndex;
498 
499     // The number of tokens burned.
500     uint256 private _burnCounter;
501 
502     // Token name
503     string private _name;
504 
505     // Token symbol
506     string private _symbol;
507 
508     // Mapping from token ID to ownership details
509     // An empty struct value does not necessarily mean the token is unowned.
510     // See `_packedOwnershipOf` implementation for details.
511     //
512     // Bits Layout:
513     // - [0..159]   `addr`
514     // - [160..223] `startTimestamp`
515     // - [224]      `burned`
516     // - [225]      `nextInitialized`
517     mapping(uint256 => uint256) private _packedOwnerships;
518 
519     // Mapping owner address to address data.
520     //
521     // Bits Layout:
522     // - [0..63]    `balance`
523     // - [64..127]  `numberMinted`
524     // - [128..191] `numberBurned`
525     // - [192..255] `aux`
526     mapping(address => uint256) private _packedAddressData;
527 
528     // Mapping from token ID to approved address.
529     mapping(uint256 => address) private _tokenApprovals;
530 
531     // Mapping from owner to operator approvals
532     mapping(address => mapping(address => bool)) private _operatorApprovals;
533 
534     constructor(string memory name_, string memory symbol_) {
535         _name = name_;
536         _symbol = symbol_;
537         _currentIndex = _startTokenId();
538     }
539 
540     /**
541      * @dev Returns the starting token ID. 
542      * To change the starting token ID, please override this function.
543      */
544     function _startTokenId() internal view virtual returns (uint256) {
545         return 0;
546     }
547 
548     /**
549      * @dev Returns the next token ID to be minted.
550      */
551     function _nextTokenId() internal view returns (uint256) {
552         return _currentIndex;
553     }
554 
555     /**
556      * @dev Returns the total number of tokens in existence.
557      * Burned tokens will reduce the count. 
558      * To get the total number of tokens minted, please see `_totalMinted`.
559      */
560     function totalSupply() public view override returns (uint256) {
561         // Counter underflow is impossible as _burnCounter cannot be incremented
562         // more than `_currentIndex - _startTokenId()` times.
563         unchecked {
564             return _currentIndex - _burnCounter - _startTokenId();
565         }
566     }
567 
568     /**
569      * @dev Returns the total amount of tokens minted in the contract.
570      */
571     function _totalMinted() internal view returns (uint256) {
572         // Counter underflow is impossible as _currentIndex does not decrement,
573         // and it is initialized to `_startTokenId()`
574         unchecked {
575             return _currentIndex - _startTokenId();
576         }
577     }
578 
579     /**
580      * @dev Returns the total number of tokens burned.
581      */
582     function _totalBurned() internal view returns (uint256) {
583         return _burnCounter;
584     }
585 
586     /**
587      * @dev See {IERC165-supportsInterface}.
588      */
589     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
590         // The interface IDs are constants representing the first 4 bytes of the XOR of
591         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
592         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
593         return
594             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
595             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
596             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
597     }
598 
599     /**
600      * @dev See {IERC721-balanceOf}.
601      */
602     function balanceOf(address owner) public view override returns (uint256) {
603         if (owner == address(0)) revert BalanceQueryForZeroAddress();
604         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
605     }
606 
607     /**
608      * Returns the number of tokens minted by `owner`.
609      */
610     function _numberMinted(address owner) internal view returns (uint256) {
611         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
612     }
613 
614     /**
615      * Returns the number of tokens burned by or on behalf of `owner`.
616      */
617     function _numberBurned(address owner) internal view returns (uint256) {
618         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
619     }
620 
621     /**
622      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
623      */
624     function _getAux(address owner) internal view returns (uint64) {
625         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
626     }
627 
628     /**
629      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
630      * If there are multiple variables, please pack them into a uint64.
631      */
632     function _setAux(address owner, uint64 aux) internal {
633         uint256 packed = _packedAddressData[owner];
634         uint256 auxCasted;
635         assembly { // Cast aux without masking.
636             auxCasted := aux
637         }
638         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
639         _packedAddressData[owner] = packed;
640     }
641 
642     /**
643      * Returns the packed ownership data of `tokenId`.
644      */
645     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
646         uint256 curr = tokenId;
647 
648         unchecked {
649             if (_startTokenId() <= curr)
650                 if (curr < _currentIndex) {
651                     uint256 packed = _packedOwnerships[curr];
652                     // If not burned.
653                     if (packed & BITMASK_BURNED == 0) {
654                         // Invariant:
655                         // There will always be an ownership that has an address and is not burned
656                         // before an ownership that does not have an address and is not burned.
657                         // Hence, curr will not underflow.
658                         //
659                         // We can directly compare the packed value.
660                         // If the address is zero, packed is zero.
661                         while (packed == 0) {
662                             packed = _packedOwnerships[--curr];
663                         }
664                         return packed;
665                     }
666                 }
667         }
668         revert OwnerQueryForNonexistentToken();
669     }
670 
671     /**
672      * Returns the unpacked `TokenOwnership` struct from `packed`.
673      */
674     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
675         ownership.addr = address(uint160(packed));
676         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
677         ownership.burned = packed & BITMASK_BURNED != 0;
678     }
679 
680     /**
681      * Returns the unpacked `TokenOwnership` struct at `index`.
682      */
683     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
684         return _unpackedOwnership(_packedOwnerships[index]);
685     }
686 
687     /**
688      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
689      */
690     function _initializeOwnershipAt(uint256 index) internal {
691         if (_packedOwnerships[index] == 0) {
692             _packedOwnerships[index] = _packedOwnershipOf(index);
693         }
694     }
695 
696     /**
697      * Gas spent here starts off proportional to the maximum mint batch size.
698      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
699      */
700     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
701         return _unpackedOwnership(_packedOwnershipOf(tokenId));
702     }
703 
704     /**
705      * @dev See {IERC721-ownerOf}.
706      */
707     function ownerOf(uint256 tokenId) public view override returns (address) {
708         return address(uint160(_packedOwnershipOf(tokenId)));
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-name}.
713      */
714     function name() public view virtual override returns (string memory) {
715         return _name;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-symbol}.
720      */
721     function symbol() public view virtual override returns (string memory) {
722         return _symbol;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-tokenURI}.
727      */
728     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
729         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
730 
731         string memory baseURI = _baseURI();
732         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
733     }
734 
735     /**
736      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
737      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
738      * by default, can be overriden in child contracts.
739      */
740     function _baseURI() internal view virtual returns (string memory) {
741         return '';
742     }
743 
744     /**
745      * @dev Casts the address to uint256 without masking.
746      */
747     function _addressToUint256(address value) private pure returns (uint256 result) {
748         assembly {
749             result := value
750         }
751     }
752 
753     /**
754      * @dev Casts the boolean to uint256 without branching.
755      */
756     function _boolToUint256(bool value) private pure returns (uint256 result) {
757         assembly {
758             result := value
759         }
760     }
761 
762     /**
763      * @dev See {IERC721-approve}.
764      */
765     function approve(address to, uint256 tokenId) public override {
766         address owner = address(uint160(_packedOwnershipOf(tokenId)));
767         if (to == owner) revert ApprovalToCurrentOwner();
768 
769         if (_msgSenderERC721A() != owner)
770             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
771                 revert ApprovalCallerNotOwnerNorApproved();
772             }
773 
774         _tokenApprovals[tokenId] = to;
775         emit Approval(owner, to, tokenId);
776     }
777 
778     /**
779      * @dev See {IERC721-getApproved}.
780      */
781     function getApproved(uint256 tokenId) public view override returns (address) {
782         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
783 
784         return _tokenApprovals[tokenId];
785     }
786 
787     /**
788      * @dev See {IERC721-setApprovalForAll}.
789      */
790     function setApprovalForAll(address operator, bool approved) public virtual override {
791         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
792 
793         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
794         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
795     }
796 
797     /**
798      * @dev See {IERC721-isApprovedForAll}.
799      */
800     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
801         return _operatorApprovals[owner][operator];
802     }
803 
804     /**
805      * @dev See {IERC721-transferFrom}.
806      */
807     function transferFrom(
808         address from,
809         address to,
810         uint256 tokenId
811     ) public virtual override {
812         _transfer(from, to, tokenId);
813     }
814 
815     /**
816      * @dev See {IERC721-safeTransferFrom}.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) public virtual override {
823         safeTransferFrom(from, to, tokenId, '');
824     }
825 
826     /**
827      * @dev See {IERC721-safeTransferFrom}.
828      */
829     function safeTransferFrom(
830         address from,
831         address to,
832         uint256 tokenId,
833         bytes memory _data
834     ) public virtual override {
835         _transfer(from, to, tokenId);
836         if (to.code.length != 0)
837             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
838                 revert TransferToNonERC721ReceiverImplementer();
839             }
840     }
841 
842     /**
843      * @dev Returns whether `tokenId` exists.
844      *
845      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
846      *
847      * Tokens start existing when they are minted (`_mint`),
848      */
849     function _exists(uint256 tokenId) internal view returns (bool) {
850         return
851             _startTokenId() <= tokenId &&
852             tokenId < _currentIndex && // If within bounds,
853             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
854     }
855 
856     /**
857      * @dev Equivalent to `_safeMint(to, quantity, '')`.
858      */
859     function _safeMint(address to, uint256 quantity) internal {
860         _safeMint(to, quantity, '');
861     }
862 
863     /**
864      * @dev Safely mints `quantity` tokens and transfers them to `to`.
865      *
866      * Requirements:
867      *
868      * - If `to` refers to a smart contract, it must implement
869      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
870      * - `quantity` must be greater than 0.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _safeMint(
875         address to,
876         uint256 quantity,
877         bytes memory _data
878     ) internal {
879         uint256 startTokenId = _currentIndex;
880         if (to == address(0)) revert MintToZeroAddress();
881         if (quantity == 0) revert MintZeroQuantity();
882 
883         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
884 
885         // Overflows are incredibly unrealistic.
886         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
887         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
888         unchecked {
889             // Updates:
890             // - `balance += quantity`.
891             // - `numberMinted += quantity`.
892             //
893             // We can directly add to the balance and number minted.
894             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
895 
896             // Updates:
897             // - `address` to the owner.
898             // - `startTimestamp` to the timestamp of minting.
899             // - `burned` to `false`.
900             // - `nextInitialized` to `quantity == 1`.
901             _packedOwnerships[startTokenId] =
902                 _addressToUint256(to) |
903                 (block.timestamp << BITPOS_START_TIMESTAMP) |
904                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
905 
906             uint256 updatedIndex = startTokenId;
907             uint256 end = updatedIndex + quantity;
908 
909             if (to.code.length != 0) {
910                 do {
911                     emit Transfer(address(0), to, updatedIndex);
912                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
913                         revert TransferToNonERC721ReceiverImplementer();
914                     }
915                 } while (updatedIndex < end);
916                 // Reentrancy protection
917                 if (_currentIndex != startTokenId) revert();
918             } else {
919                 do {
920                     emit Transfer(address(0), to, updatedIndex++);
921                 } while (updatedIndex < end);
922             }
923             _currentIndex = updatedIndex;
924         }
925         _afterTokenTransfers(address(0), to, startTokenId, quantity);
926     }
927 
928     /**
929      * @dev Mints `quantity` tokens and transfers them to `to`.
930      *
931      * Requirements:
932      *
933      * - `to` cannot be the zero address.
934      * - `quantity` must be greater than 0.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _mint(address to, uint256 quantity) internal {
939         uint256 startTokenId = _currentIndex;
940         if (to == address(0)) revert MintToZeroAddress();
941         if (quantity == 0) revert MintZeroQuantity();
942 
943         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
944 
945         // Overflows are incredibly unrealistic.
946         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
947         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
948         unchecked {
949             // Updates:
950             // - `balance += quantity`.
951             // - `numberMinted += quantity`.
952             //
953             // We can directly add to the balance and number minted.
954             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
955 
956             // Updates:
957             // - `address` to the owner.
958             // - `startTimestamp` to the timestamp of minting.
959             // - `burned` to `false`.
960             // - `nextInitialized` to `quantity == 1`.
961             _packedOwnerships[startTokenId] =
962                 _addressToUint256(to) |
963                 (block.timestamp << BITPOS_START_TIMESTAMP) |
964                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
965 
966             uint256 updatedIndex = startTokenId;
967             uint256 end = updatedIndex + quantity;
968 
969             do {
970                 emit Transfer(address(0), to, updatedIndex++);
971             } while (updatedIndex < end);
972 
973             _currentIndex = updatedIndex;
974         }
975         _afterTokenTransfers(address(0), to, startTokenId, quantity);
976     }
977 
978     /**
979      * @dev Transfers `tokenId` from `from` to `to`.
980      *
981      * Requirements:
982      *
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must be owned by `from`.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _transfer(
989         address from,
990         address to,
991         uint256 tokenId
992     ) private {
993         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
994 
995         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
996 
997         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
998             isApprovedForAll(from, _msgSenderERC721A()) ||
999             getApproved(tokenId) == _msgSenderERC721A());
1000 
1001         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1002         if (to == address(0)) revert TransferToZeroAddress();
1003 
1004         _beforeTokenTransfers(from, to, tokenId, 1);
1005 
1006         // Clear approvals from the previous owner.
1007         delete _tokenApprovals[tokenId];
1008 
1009         // Underflow of the sender's balance is impossible because we check for
1010         // ownership above and the recipient's balance can't realistically overflow.
1011         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1012         unchecked {
1013             // We can directly increment and decrement the balances.
1014             --_packedAddressData[from]; // Updates: `balance -= 1`.
1015             ++_packedAddressData[to]; // Updates: `balance += 1`.
1016 
1017             // Updates:
1018             // - `address` to the next owner.
1019             // - `startTimestamp` to the timestamp of transfering.
1020             // - `burned` to `false`.
1021             // - `nextInitialized` to `true`.
1022             _packedOwnerships[tokenId] =
1023                 _addressToUint256(to) |
1024                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1025                 BITMASK_NEXT_INITIALIZED;
1026 
1027             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1028             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1029                 uint256 nextTokenId = tokenId + 1;
1030                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1031                 if (_packedOwnerships[nextTokenId] == 0) {
1032                     // If the next slot is within bounds.
1033                     if (nextTokenId != _currentIndex) {
1034                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1035                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1036                     }
1037                 }
1038             }
1039         }
1040 
1041         emit Transfer(from, to, tokenId);
1042         _afterTokenTransfers(from, to, tokenId, 1);
1043     }
1044 
1045     /**
1046      * @dev Equivalent to `_burn(tokenId, false)`.
1047      */
1048     function _burn(uint256 tokenId) internal virtual {
1049         _burn(tokenId, false);
1050     }
1051 
1052     /**
1053      * @dev Destroys `tokenId`.
1054      * The approval is cleared when the token is burned.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1063         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1064 
1065         address from = address(uint160(prevOwnershipPacked));
1066 
1067         if (approvalCheck) {
1068             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1069                 isApprovedForAll(from, _msgSenderERC721A()) ||
1070                 getApproved(tokenId) == _msgSenderERC721A());
1071 
1072             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1073         }
1074 
1075         _beforeTokenTransfers(from, address(0), tokenId, 1);
1076 
1077         // Clear approvals from the previous owner.
1078         delete _tokenApprovals[tokenId];
1079 
1080         // Underflow of the sender's balance is impossible because we check for
1081         // ownership above and the recipient's balance can't realistically overflow.
1082         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1083         unchecked {
1084             // Updates:
1085             // - `balance -= 1`.
1086             // - `numberBurned += 1`.
1087             //
1088             // We can directly decrement the balance, and increment the number burned.
1089             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1090             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1091 
1092             // Updates:
1093             // - `address` to the last owner.
1094             // - `startTimestamp` to the timestamp of burning.
1095             // - `burned` to `true`.
1096             // - `nextInitialized` to `true`.
1097             _packedOwnerships[tokenId] =
1098                 _addressToUint256(from) |
1099                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1100                 BITMASK_BURNED | 
1101                 BITMASK_NEXT_INITIALIZED;
1102 
1103             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1104             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1105                 uint256 nextTokenId = tokenId + 1;
1106                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1107                 if (_packedOwnerships[nextTokenId] == 0) {
1108                     // If the next slot is within bounds.
1109                     if (nextTokenId != _currentIndex) {
1110                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1111                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1112                     }
1113                 }
1114             }
1115         }
1116 
1117         emit Transfer(from, address(0), tokenId);
1118         _afterTokenTransfers(from, address(0), tokenId, 1);
1119 
1120         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1121         unchecked {
1122             _burnCounter++;
1123         }
1124     }
1125 
1126     /**
1127      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1128      *
1129      * @param from address representing the previous owner of the given token ID
1130      * @param to target address that will receive the tokens
1131      * @param tokenId uint256 ID of the token to be transferred
1132      * @param _data bytes optional data to send along with the call
1133      * @return bool whether the call correctly returned the expected magic value
1134      */
1135     function _checkContractOnERC721Received(
1136         address from,
1137         address to,
1138         uint256 tokenId,
1139         bytes memory _data
1140     ) private returns (bool) {
1141         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1142             bytes4 retval
1143         ) {
1144             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1145         } catch (bytes memory reason) {
1146             if (reason.length == 0) {
1147                 revert TransferToNonERC721ReceiverImplementer();
1148             } else {
1149                 assembly {
1150                     revert(add(32, reason), mload(reason))
1151                 }
1152             }
1153         }
1154     }
1155 
1156     /**
1157      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1158      * And also called before burning one token.
1159      *
1160      * startTokenId - the first token id to be transferred
1161      * quantity - the amount to be transferred
1162      *
1163      * Calling conditions:
1164      *
1165      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1166      * transferred to `to`.
1167      * - When `from` is zero, `tokenId` will be minted for `to`.
1168      * - When `to` is zero, `tokenId` will be burned by `from`.
1169      * - `from` and `to` are never both zero.
1170      */
1171     function _beforeTokenTransfers(
1172         address from,
1173         address to,
1174         uint256 startTokenId,
1175         uint256 quantity
1176     ) internal virtual {}
1177 
1178     /**
1179      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1180      * minting.
1181      * And also called after one token has been burned.
1182      *
1183      * startTokenId - the first token id to be transferred
1184      * quantity - the amount to be transferred
1185      *
1186      * Calling conditions:
1187      *
1188      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1189      * transferred to `to`.
1190      * - When `from` is zero, `tokenId` has been minted for `to`.
1191      * - When `to` is zero, `tokenId` has been burned by `from`.
1192      * - `from` and `to` are never both zero.
1193      */
1194     function _afterTokenTransfers(
1195         address from,
1196         address to,
1197         uint256 startTokenId,
1198         uint256 quantity
1199     ) internal virtual {}
1200 
1201     /**
1202      * @dev Returns the message sender (defaults to `msg.sender`).
1203      *
1204      * If you are writing GSN compatible contracts, you need to override this function.
1205      */
1206     function _msgSenderERC721A() internal view virtual returns (address) {
1207         return msg.sender;
1208     }
1209 
1210     /**
1211      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1212      */
1213     function _toString(uint256 value) internal pure returns (string memory ptr) {
1214         assembly {
1215             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1216             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1217             // We will need 1 32-byte word to store the length, 
1218             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1219             ptr := add(mload(0x40), 128)
1220             // Update the free memory pointer to allocate.
1221             mstore(0x40, ptr)
1222 
1223             // Cache the end of the memory to calculate the length later.
1224             let end := ptr
1225 
1226             // We write the string from the rightmost digit to the leftmost digit.
1227             // The following is essentially a do-while loop that also handles the zero case.
1228             // Costs a bit more than early returning for the zero case,
1229             // but cheaper in terms of deployment and overall runtime costs.
1230             for { 
1231                 // Initialize and perform the first pass without check.
1232                 let temp := value
1233                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1234                 ptr := sub(ptr, 1)
1235                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1236                 mstore8(ptr, add(48, mod(temp, 10)))
1237                 temp := div(temp, 10)
1238             } temp { 
1239                 // Keep dividing `temp` until zero.
1240                 temp := div(temp, 10)
1241             } { // Body of the for loop.
1242                 ptr := sub(ptr, 1)
1243                 mstore8(ptr, add(48, mod(temp, 10)))
1244             }
1245             
1246             let length := sub(end, ptr)
1247             // Move the pointer 32 bytes leftwards to make room for the length.
1248             ptr := sub(ptr, 32)
1249             // Store the length.
1250             mstore(ptr, length)
1251         }
1252     }
1253 }
1254 
1255 // File: contracts/fmfers.sol
1256 
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 
1261 contract fmfers is ERC721A, Ownable, ReentrancyGuard {
1262     string public baseURI;
1263     string public endPoint = ".json";
1264     string public hiddenMetadataUri = "ipfs://Qmf1PfN8dfEJcH7PjkugsC48KK51ZY6MoNP5V4KXyrt6Mg/hidden.json";
1265     bool public revealed = false;
1266 
1267     uint256 public price = 0 ether;
1268     uint256 public maxPerTx = 5;
1269     uint256 public maxPerWallet = 5;
1270     uint256 public maxSupply = 6969;
1271 
1272     constructor() ERC721A("fmfers", "fmfers")  {}
1273 
1274     
1275     function toggleRevealed() external onlyOwner {
1276         revealed = !revealed;
1277     }
1278     
1279     function setBaseURI(string calldata baseURI_) external onlyOwner {
1280         baseURI = baseURI_;
1281     }
1282 
1283     function mint(uint256 amount) external payable {
1284 
1285         require(msg.sender == tx.origin, "You can't mint from a contract.");
1286         require(msg.value == amount * price, "Please send the exact amount in order to mint.");
1287         require(totalSupply() + amount <= maxSupply, "Sold out.");
1288         require(numberMinted(msg.sender) + amount <= maxPerWallet, "You have exceeded the mint limit per wallet.");
1289         require(amount <= maxPerTx, "You have exceeded the mint limit per transaction.");
1290 
1291         _safeMint(msg.sender, amount);
1292     }
1293 
1294     function ownerMint(uint256 amount) external onlyOwner {
1295         require(totalSupply() + amount <= maxSupply, "Can't mint");
1296 
1297         _safeMint(msg.sender, amount);
1298     }
1299     
1300     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1301         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1302         if (revealed == false) {
1303         return hiddenMetadataUri;
1304         }
1305 
1306         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), endPoint)) : '';
1307     }
1308 
1309     function _startTokenId() internal view virtual override returns (uint256) {
1310         return 1;
1311     }
1312 
1313     function numberMinted(address owner) public view returns (uint256) {
1314         return _numberMinted(owner);
1315     }
1316 
1317     function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1318       maxSupply = maxSupply_;
1319     }
1320 
1321     function _baseURI() internal view virtual override returns (string memory) {
1322     return baseURI;
1323     }
1324 
1325     function withdraw() external onlyOwner nonReentrant {
1326         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1327         require(success, "Transfer failed.");
1328     }
1329 }