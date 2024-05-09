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
68 // File: @openzeppelin/contracts/utils/Strings.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev String operations.
77  */
78 library Strings {
79     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
80     uint8 private constant _ADDRESS_LENGTH = 20;
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 
138     /**
139      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
140      */
141     function toHexString(address addr) internal pure returns (string memory) {
142         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
143     }
144 }
145 
146 
147 // File: @openzeppelin/contracts/utils/Context.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Provides information about the current execution context, including the
156  * sender of the transaction and its data. While these are generally available
157  * via msg.sender and msg.data, they should not be accessed in such a direct
158  * manner, since when dealing with meta-transactions the account sending and
159  * paying for execution may not be the actual sender (as far as an application
160  * is concerned).
161  *
162  * This contract is only required for intermediate, library-like contracts.
163  */
164 abstract contract Context {
165     function _msgSender() internal view virtual returns (address) {
166         return msg.sender;
167     }
168 
169     function _msgData() internal view virtual returns (bytes calldata) {
170         return msg.data;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/access/Ownable.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @dev Contract module which provides a basic access control mechanism, where
184  * there is an account (an owner) that can be granted exclusive access to
185  * specific functions.
186  *
187  * By default, the owner account will be the one that deploys the contract. This
188  * can later be changed with {transferOwnership}.
189  *
190  * This module is used through inheritance. It will make available the modifier
191  * `onlyOwner`, which can be applied to your functions to restrict their use to
192  * the owner.
193  */
194 abstract contract Ownable is Context {
195     address private _owner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor() {
203         _transferOwnership(_msgSender());
204     }
205 
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         _checkOwner();
211         _;
212     }
213 
214     /**
215      * @dev Returns the address of the current owner.
216      */
217     function owner() public view virtual returns (address) {
218         return _owner;
219     }
220 
221     /**
222      * @dev Throws if the sender is not the owner.
223      */
224     function _checkOwner() internal view virtual {
225         require(owner() == _msgSender(), "Ownable: caller is not the owner");
226     }
227 
228     /**
229      * @dev Leaves the contract without owner. It will not be possible to call
230      * `onlyOwner` functions anymore. Can only be called by the current owner.
231      *
232      * NOTE: Renouncing ownership will leave the contract without an owner,
233      * thereby removing any functionality that is only available to the owner.
234      */
235     function renounceOwnership() public virtual onlyOwner {
236         _transferOwnership(address(0));
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Can only be called by the current owner.
242      */
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         _transferOwnership(newOwner);
246     }
247 
248     /**
249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
250      * Internal function without access restriction.
251      */
252     function _transferOwnership(address newOwner) internal virtual {
253         address oldOwner = _owner;
254         _owner = newOwner;
255         emit OwnershipTransferred(oldOwner, newOwner);
256     }
257 }
258 
259 // File: erc721a/contracts/IERC721A.sol
260 
261 
262 // ERC721A Contracts v4.1.0
263 // Creator: Chiru Labs
264 
265 pragma solidity ^0.8.4;
266 
267 /**
268  * @dev Interface of an ERC721A compliant contract.
269  */
270 interface IERC721A {
271     /**
272      * The caller must own the token or be an approved operator.
273      */
274     error ApprovalCallerNotOwnerNorApproved();
275 
276     /**
277      * The token does not exist.
278      */
279     error ApprovalQueryForNonexistentToken();
280 
281     /**
282      * The caller cannot approve to their own address.
283      */
284     error ApproveToCaller();
285 
286     /**
287      * Cannot query the balance for the zero address.
288      */
289     error BalanceQueryForZeroAddress();
290 
291     /**
292      * Cannot mint to the zero address.
293      */
294     error MintToZeroAddress();
295 
296     /**
297      * The quantity of tokens minted must be more than zero.
298      */
299     error MintZeroQuantity();
300 
301     /**
302      * The token does not exist.
303      */
304     error OwnerQueryForNonexistentToken();
305 
306     /**
307      * The caller must own the token or be an approved operator.
308      */
309     error TransferCallerNotOwnerNorApproved();
310 
311     /**
312      * The token must be owned by `from`.
313      */
314     error TransferFromIncorrectOwner();
315 
316     /**
317      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
318      */
319     error TransferToNonERC721ReceiverImplementer();
320 
321     /**
322      * Cannot transfer to the zero address.
323      */
324     error TransferToZeroAddress();
325 
326     /**
327      * The token does not exist.
328      */
329     error URIQueryForNonexistentToken();
330 
331     /**
332      * The `quantity` minted with ERC2309 exceeds the safety limit.
333      */
334     error MintERC2309QuantityExceedsLimit();
335 
336     /**
337      * The `extraData` cannot be set on an unintialized ownership slot.
338      */
339     error OwnershipNotInitializedForExtraData();
340 
341     struct TokenOwnership {
342         // The address of the owner.
343         address addr;
344         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
345         uint64 startTimestamp;
346         // Whether the token has been burned.
347         bool burned;
348         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
349         uint24 extraData;
350     }
351 
352     /**
353      * @dev Returns the total amount of tokens stored by the contract.
354      *
355      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
356      */
357     function totalSupply() external view returns (uint256);
358 
359     // ==============================
360     //            IERC165
361     // ==============================
362 
363     /**
364      * @dev Returns true if this contract implements the interface defined by
365      * `interfaceId`. See the corresponding
366      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
367      * to learn more about how these ids are created.
368      *
369      * This function call must use less than 30 000 gas.
370      */
371     function supportsInterface(bytes4 interfaceId) external view returns (bool);
372 
373     // ==============================
374     //            IERC721
375     // ==============================
376 
377     /**
378      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
379      */
380     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
381 
382     /**
383      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
384      */
385     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
386 
387     /**
388      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
389      */
390     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
391 
392     /**
393      * @dev Returns the number of tokens in ``owner``'s account.
394      */
395     function balanceOf(address owner) external view returns (uint256 balance);
396 
397     /**
398      * @dev Returns the owner of the `tokenId` token.
399      *
400      * Requirements:
401      *
402      * - `tokenId` must exist.
403      */
404     function ownerOf(uint256 tokenId) external view returns (address owner);
405 
406     /**
407      * @dev Safely transfers `tokenId` token from `from` to `to`.
408      *
409      * Requirements:
410      *
411      * - `from` cannot be the zero address.
412      * - `to` cannot be the zero address.
413      * - `tokenId` token must exist and be owned by `from`.
414      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
415      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416      *
417      * Emits a {Transfer} event.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId,
423         bytes calldata data
424     ) external;
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
428      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
468      * The approval is cleared when the token is transferred.
469      *
470      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
471      *
472      * Requirements:
473      *
474      * - The caller must own the token or be an approved operator.
475      * - `tokenId` must exist.
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address to, uint256 tokenId) external;
480 
481     /**
482      * @dev Approve or remove `operator` as an operator for the caller.
483      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
484      *
485      * Requirements:
486      *
487      * - The `operator` cannot be the caller.
488      *
489      * Emits an {ApprovalForAll} event.
490      */
491     function setApprovalForAll(address operator, bool _approved) external;
492 
493     /**
494      * @dev Returns the account approved for `tokenId` token.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must exist.
499      */
500     function getApproved(uint256 tokenId) external view returns (address operator);
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     // ==============================
510     //        IERC721Metadata
511     // ==============================
512 
513     /**
514      * @dev Returns the token collection name.
515      */
516     function name() external view returns (string memory);
517 
518     /**
519      * @dev Returns the token collection symbol.
520      */
521     function symbol() external view returns (string memory);
522 
523     /**
524      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
525      */
526     function tokenURI(uint256 tokenId) external view returns (string memory);
527 
528     // ==============================
529     //            IERC2309
530     // ==============================
531 
532     /**
533      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
534      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
535      */
536     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
537 }
538 
539 // File: erc721a/contracts/ERC721A.sol
540 
541 
542 // ERC721A Contracts v4.1.0
543 // Creator: Chiru Labs
544 
545 pragma solidity ^0.8.4;
546 
547 
548 /**
549  * @dev ERC721 token receiver interface.
550  */
551 interface ERC721A__IERC721Receiver {
552     function onERC721Received(
553         address operator,
554         address from,
555         uint256 tokenId,
556         bytes calldata data
557     ) external returns (bytes4);
558 }
559 
560 /**
561  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
562  * including the Metadata extension. Built to optimize for lower gas during batch mints.
563  *
564  * Assumes serials are sequentially minted starting at `_startTokenId()`
565  * (defaults to 0, e.g. 0, 1, 2, 3..).
566  *
567  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
568  *
569  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
570  */
571 contract ERC721A is IERC721A {
572     // Mask of an entry in packed address data.
573     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
574 
575     // The bit position of `numberMinted` in packed address data.
576     uint256 private constant BITPOS_NUMBER_MINTED = 64;
577 
578     // The bit position of `numberBurned` in packed address data.
579     uint256 private constant BITPOS_NUMBER_BURNED = 128;
580 
581     // The bit position of `aux` in packed address data.
582     uint256 private constant BITPOS_AUX = 192;
583 
584     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
585     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
586 
587     // The bit position of `startTimestamp` in packed ownership.
588     uint256 private constant BITPOS_START_TIMESTAMP = 160;
589 
590     // The bit mask of the `burned` bit in packed ownership.
591     uint256 private constant BITMASK_BURNED = 1 << 224;
592 
593     // The bit position of the `nextInitialized` bit in packed ownership.
594     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
595 
596     // The bit mask of the `nextInitialized` bit in packed ownership.
597     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
598 
599     // The bit position of `extraData` in packed ownership.
600     uint256 private constant BITPOS_EXTRA_DATA = 232;
601 
602     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
603     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
604 
605     // The mask of the lower 160 bits for addresses.
606     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
607 
608     // The maximum `quantity` that can be minted with `_mintERC2309`.
609     // This limit is to prevent overflows on the address data entries.
610     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
611     // is required to cause an overflow, which is unrealistic.
612     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
613 
614     // The tokenId of the next token to be minted.
615     uint256 private _currentIndex;
616 
617     // The number of tokens burned.
618     uint256 private _burnCounter;
619 
620     // Token name
621     string private _name;
622 
623     // Token symbol
624     string private _symbol;
625 
626     // Mapping from token ID to ownership details
627     // An empty struct value does not necessarily mean the token is unowned.
628     // See `_packedOwnershipOf` implementation for details.
629     //
630     // Bits Layout:
631     // - [0..159]   `addr`
632     // - [160..223] `startTimestamp`
633     // - [224]      `burned`
634     // - [225]      `nextInitialized`
635     // - [232..255] `extraData`
636     mapping(uint256 => uint256) private _packedOwnerships;
637 
638     // Mapping owner address to address data.
639     //
640     // Bits Layout:
641     // - [0..63]    `balance`
642     // - [64..127]  `numberMinted`
643     // - [128..191] `numberBurned`
644     // - [192..255] `aux`
645     mapping(address => uint256) private _packedAddressData;
646 
647     // Mapping from token ID to approved address.
648     mapping(uint256 => address) private _tokenApprovals;
649 
650     // Mapping from owner to operator approvals
651     mapping(address => mapping(address => bool)) private _operatorApprovals;
652 
653     constructor(string memory name_, string memory symbol_) {
654         _name = name_;
655         _symbol = symbol_;
656         _currentIndex = _startTokenId();
657     }
658 
659     /**
660      * @dev Returns the starting token ID.
661      * To change the starting token ID, please override this function.
662      */
663     function _startTokenId() internal view virtual returns (uint256) {
664         return 0;
665     }
666 
667     /**
668      * @dev Returns the next token ID to be minted.
669      */
670     function _nextTokenId() internal view returns (uint256) {
671         return _currentIndex;
672     }
673 
674     /**
675      * @dev Returns the total number of tokens in existence.
676      * Burned tokens will reduce the count.
677      * To get the total number of tokens minted, please see `_totalMinted`.
678      */
679     function totalSupply() public view override returns (uint256) {
680         // Counter underflow is impossible as _burnCounter cannot be incremented
681         // more than `_currentIndex - _startTokenId()` times.
682         unchecked {
683             return _currentIndex - _burnCounter - _startTokenId();
684         }
685     }
686 
687     /**
688      * @dev Returns the total amount of tokens minted in the contract.
689      */
690     function _totalMinted() internal view returns (uint256) {
691         // Counter underflow is impossible as _currentIndex does not decrement,
692         // and it is initialized to `_startTokenId()`
693         unchecked {
694             return _currentIndex - _startTokenId();
695         }
696     }
697 
698     /**
699      * @dev Returns the total number of tokens burned.
700      */
701     function _totalBurned() internal view returns (uint256) {
702         return _burnCounter;
703     }
704 
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709         // The interface IDs are constants representing the first 4 bytes of the XOR of
710         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
711         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
712         return
713             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
714             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
715             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
716     }
717 
718     /**
719      * @dev See {IERC721-balanceOf}.
720      */
721     function balanceOf(address owner) public view override returns (uint256) {
722         if (owner == address(0)) revert BalanceQueryForZeroAddress();
723         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
724     }
725 
726     /**
727      * Returns the number of tokens minted by `owner`.
728      */
729     function _numberMinted(address owner) internal view returns (uint256) {
730         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
731     }
732 
733     /**
734      * Returns the number of tokens burned by or on behalf of `owner`.
735      */
736     function _numberBurned(address owner) internal view returns (uint256) {
737         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
738     }
739 
740     /**
741      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
742      */
743     function _getAux(address owner) internal view returns (uint64) {
744         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
745     }
746 
747     /**
748      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
749      * If there are multiple variables, please pack them into a uint64.
750      */
751     function _setAux(address owner, uint64 aux) internal {
752         uint256 packed = _packedAddressData[owner];
753         uint256 auxCasted;
754         // Cast `aux` with assembly to avoid redundant masking.
755         assembly {
756             auxCasted := aux
757         }
758         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
759         _packedAddressData[owner] = packed;
760     }
761 
762     /**
763      * Returns the packed ownership data of `tokenId`.
764      */
765     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
766         uint256 curr = tokenId;
767 
768         unchecked {
769             if (_startTokenId() <= curr)
770                 if (curr < _currentIndex) {
771                     uint256 packed = _packedOwnerships[curr];
772                     // If not burned.
773                     if (packed & BITMASK_BURNED == 0) {
774                         // Invariant:
775                         // There will always be an ownership that has an address and is not burned
776                         // before an ownership that does not have an address and is not burned.
777                         // Hence, curr will not underflow.
778                         //
779                         // We can directly compare the packed value.
780                         // If the address is zero, packed is zero.
781                         while (packed == 0) {
782                             packed = _packedOwnerships[--curr];
783                         }
784                         return packed;
785                     }
786                 }
787         }
788         revert OwnerQueryForNonexistentToken();
789     }
790 
791     /**
792      * Returns the unpacked `TokenOwnership` struct from `packed`.
793      */
794     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
795         ownership.addr = address(uint160(packed));
796         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
797         ownership.burned = packed & BITMASK_BURNED != 0;
798         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
799     }
800 
801     /**
802      * Returns the unpacked `TokenOwnership` struct at `index`.
803      */
804     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
805         return _unpackedOwnership(_packedOwnerships[index]);
806     }
807 
808     /**
809      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
810      */
811     function _initializeOwnershipAt(uint256 index) internal {
812         if (_packedOwnerships[index] == 0) {
813             _packedOwnerships[index] = _packedOwnershipOf(index);
814         }
815     }
816 
817     /**
818      * Gas spent here starts off proportional to the maximum mint batch size.
819      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
820      */
821     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
822         return _unpackedOwnership(_packedOwnershipOf(tokenId));
823     }
824 
825     /**
826      * @dev Packs ownership data into a single uint256.
827      */
828     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
829         assembly {
830             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
831             owner := and(owner, BITMASK_ADDRESS)
832             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
833             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
834         }
835     }
836 
837     /**
838      * @dev See {IERC721-ownerOf}.
839      */
840     function ownerOf(uint256 tokenId) public view override returns (address) {
841         return address(uint160(_packedOwnershipOf(tokenId)));
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-name}.
846      */
847     function name() public view virtual override returns (string memory) {
848         return _name;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-symbol}.
853      */
854     function symbol() public view virtual override returns (string memory) {
855         return _symbol;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-tokenURI}.
860      */
861     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
862         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
863 
864         string memory baseURI = _baseURI();
865         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
866     }
867 
868     /**
869      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
870      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
871      * by default, it can be overridden in child contracts.
872      */
873     function _baseURI() internal view virtual returns (string memory) {
874         return '';
875     }
876 
877     /**
878      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
879      */
880     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
881         // For branchless setting of the `nextInitialized` flag.
882         assembly {
883             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
884             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
885         }
886     }
887 
888     /**
889      * @dev See {IERC721-approve}.
890      */
891     function approve(address to, uint256 tokenId) public override {
892         address owner = ownerOf(tokenId);
893 
894         if (_msgSenderERC721A() != owner)
895             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
896                 revert ApprovalCallerNotOwnerNorApproved();
897             }
898 
899         _tokenApprovals[tokenId] = to;
900         emit Approval(owner, to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-getApproved}.
905      */
906     function getApproved(uint256 tokenId) public view override returns (address) {
907         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
908 
909         return _tokenApprovals[tokenId];
910     }
911 
912     /**
913      * @dev See {IERC721-setApprovalForAll}.
914      */
915     function setApprovalForAll(address operator, bool approved) public virtual override {
916         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
917 
918         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
919         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
920     }
921 
922     /**
923      * @dev See {IERC721-isApprovedForAll}.
924      */
925     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
926         return _operatorApprovals[owner][operator];
927     }
928 
929     /**
930      * @dev See {IERC721-safeTransferFrom}.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId
936     ) public virtual override {
937         safeTransferFrom(from, to, tokenId, '');
938     }
939 
940     /**
941      * @dev See {IERC721-safeTransferFrom}.
942      */
943     function safeTransferFrom(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) public virtual override {
949         transferFrom(from, to, tokenId);
950         if (to.code.length != 0)
951             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
952                 revert TransferToNonERC721ReceiverImplementer();
953             }
954     }
955 
956     /**
957      * @dev Returns whether `tokenId` exists.
958      *
959      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
960      *
961      * Tokens start existing when they are minted (`_mint`),
962      */
963     function _exists(uint256 tokenId) internal view returns (bool) {
964         return
965             _startTokenId() <= tokenId &&
966             tokenId < _currentIndex && // If within bounds,
967             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
968     }
969 
970     /**
971      * @dev Equivalent to `_safeMint(to, quantity, '')`.
972      */
973     function _safeMint(address to, uint256 quantity) internal {
974         _safeMint(to, quantity, '');
975     }
976 
977     /**
978      * @dev Safely mints `quantity` tokens and transfers them to `to`.
979      *
980      * Requirements:
981      *
982      * - If `to` refers to a smart contract, it must implement
983      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
984      * - `quantity` must be greater than 0.
985      *
986      * See {_mint}.
987      *
988      * Emits a {Transfer} event for each mint.
989      */
990     function _safeMint(
991         address to,
992         uint256 quantity,
993         bytes memory _data
994     ) internal {
995         _mint(to, quantity);
996 
997         unchecked {
998             if (to.code.length != 0) {
999                 uint256 end = _currentIndex;
1000                 uint256 index = end - quantity;
1001                 do {
1002                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1003                         revert TransferToNonERC721ReceiverImplementer();
1004                     }
1005                 } while (index < end);
1006                 // Reentrancy protection.
1007                 if (_currentIndex != end) revert();
1008             }
1009         }
1010     }
1011 
1012     /**
1013      * @dev Mints `quantity` tokens and transfers them to `to`.
1014      *
1015      * Requirements:
1016      *
1017      * - `to` cannot be the zero address.
1018      * - `quantity` must be greater than 0.
1019      *
1020      * Emits a {Transfer} event for each mint.
1021      */
1022     function _mint(address to, uint256 quantity) internal {
1023         uint256 startTokenId = _currentIndex;
1024         if (to == address(0)) revert MintToZeroAddress();
1025         if (quantity == 0) revert MintZeroQuantity();
1026 
1027         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1028 
1029         // Overflows are incredibly unrealistic.
1030         // `balance` and `numberMinted` have a maximum limit of 2**64.
1031         // `tokenId` has a maximum limit of 2**256.
1032         unchecked {
1033             // Updates:
1034             // - `balance += quantity`.
1035             // - `numberMinted += quantity`.
1036             //
1037             // We can directly add to the `balance` and `numberMinted`.
1038             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1039 
1040             // Updates:
1041             // - `address` to the owner.
1042             // - `startTimestamp` to the timestamp of minting.
1043             // - `burned` to `false`.
1044             // - `nextInitialized` to `quantity == 1`.
1045             _packedOwnerships[startTokenId] = _packOwnershipData(
1046                 to,
1047                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1048             );
1049 
1050             uint256 tokenId = startTokenId;
1051             uint256 end = startTokenId + quantity;
1052             do {
1053                 emit Transfer(address(0), to, tokenId++);
1054             } while (tokenId < end);
1055 
1056             _currentIndex = end;
1057         }
1058         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1059     }
1060 
1061     /**
1062      * @dev Mints `quantity` tokens and transfers them to `to`.
1063      *
1064      * This function is intended for efficient minting only during contract creation.
1065      *
1066      * It emits only one {ConsecutiveTransfer} as defined in
1067      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1068      * instead of a sequence of {Transfer} event(s).
1069      *
1070      * Calling this function outside of contract creation WILL make your contract
1071      * non-compliant with the ERC721 standard.
1072      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1073      * {ConsecutiveTransfer} event is only permissible during contract creation.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - `quantity` must be greater than 0.
1079      *
1080      * Emits a {ConsecutiveTransfer} event.
1081      */
1082     function _mintERC2309(address to, uint256 quantity) internal {
1083         uint256 startTokenId = _currentIndex;
1084         if (to == address(0)) revert MintToZeroAddress();
1085         if (quantity == 0) revert MintZeroQuantity();
1086         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1087 
1088         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1089 
1090         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1091         unchecked {
1092             // Updates:
1093             // - `balance += quantity`.
1094             // - `numberMinted += quantity`.
1095             //
1096             // We can directly add to the `balance` and `numberMinted`.
1097             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1098 
1099             // Updates:
1100             // - `address` to the owner.
1101             // - `startTimestamp` to the timestamp of minting.
1102             // - `burned` to `false`.
1103             // - `nextInitialized` to `quantity == 1`.
1104             _packedOwnerships[startTokenId] = _packOwnershipData(
1105                 to,
1106                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1107             );
1108 
1109             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1110 
1111             _currentIndex = startTokenId + quantity;
1112         }
1113         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1114     }
1115 
1116     /**
1117      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1118      */
1119     function _getApprovedAddress(uint256 tokenId)
1120         private
1121         view
1122         returns (uint256 approvedAddressSlot, address approvedAddress)
1123     {
1124         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1125         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1126         assembly {
1127             // Compute the slot.
1128             mstore(0x00, tokenId)
1129             mstore(0x20, tokenApprovalsPtr.slot)
1130             approvedAddressSlot := keccak256(0x00, 0x40)
1131             // Load the slot's value from storage.
1132             approvedAddress := sload(approvedAddressSlot)
1133         }
1134     }
1135 
1136     /**
1137      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1138      */
1139     function _isOwnerOrApproved(
1140         address approvedAddress,
1141         address from,
1142         address msgSender
1143     ) private pure returns (bool result) {
1144         assembly {
1145             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1146             from := and(from, BITMASK_ADDRESS)
1147             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1148             msgSender := and(msgSender, BITMASK_ADDRESS)
1149             // `msgSender == from || msgSender == approvedAddress`.
1150             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1151         }
1152     }
1153 
1154     /**
1155      * @dev Transfers `tokenId` from `from` to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - `to` cannot be the zero address.
1160      * - `tokenId` token must be owned by `from`.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function transferFrom(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) public virtual override {
1169         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1170 
1171         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1172 
1173         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1174 
1175         // The nested ifs save around 20+ gas over a compound boolean condition.
1176         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1177             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1178 
1179         if (to == address(0)) revert TransferToZeroAddress();
1180 
1181         _beforeTokenTransfers(from, to, tokenId, 1);
1182 
1183         // Clear approvals from the previous owner.
1184         assembly {
1185             if approvedAddress {
1186                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1187                 sstore(approvedAddressSlot, 0)
1188             }
1189         }
1190 
1191         // Underflow of the sender's balance is impossible because we check for
1192         // ownership above and the recipient's balance can't realistically overflow.
1193         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1194         unchecked {
1195             // We can directly increment and decrement the balances.
1196             --_packedAddressData[from]; // Updates: `balance -= 1`.
1197             ++_packedAddressData[to]; // Updates: `balance += 1`.
1198 
1199             // Updates:
1200             // - `address` to the next owner.
1201             // - `startTimestamp` to the timestamp of transfering.
1202             // - `burned` to `false`.
1203             // - `nextInitialized` to `true`.
1204             _packedOwnerships[tokenId] = _packOwnershipData(
1205                 to,
1206                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1207             );
1208 
1209             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1210             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1211                 uint256 nextTokenId = tokenId + 1;
1212                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1213                 if (_packedOwnerships[nextTokenId] == 0) {
1214                     // If the next slot is within bounds.
1215                     if (nextTokenId != _currentIndex) {
1216                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1217                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1218                     }
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(from, to, tokenId);
1224         _afterTokenTransfers(from, to, tokenId, 1);
1225     }
1226 
1227     /**
1228      * @dev Equivalent to `_burn(tokenId, false)`.
1229      */
1230     function _burn(uint256 tokenId) internal virtual {
1231         _burn(tokenId, false);
1232     }
1233 
1234     /**
1235      * @dev Destroys `tokenId`.
1236      * The approval is cleared when the token is burned.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1245         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1246 
1247         address from = address(uint160(prevOwnershipPacked));
1248 
1249         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1250 
1251         if (approvalCheck) {
1252             // The nested ifs save around 20+ gas over a compound boolean condition.
1253             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1254                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1255         }
1256 
1257         _beforeTokenTransfers(from, address(0), tokenId, 1);
1258 
1259         // Clear approvals from the previous owner.
1260         assembly {
1261             if approvedAddress {
1262                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1263                 sstore(approvedAddressSlot, 0)
1264             }
1265         }
1266 
1267         // Underflow of the sender's balance is impossible because we check for
1268         // ownership above and the recipient's balance can't realistically overflow.
1269         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1270         unchecked {
1271             // Updates:
1272             // - `balance -= 1`.
1273             // - `numberBurned += 1`.
1274             //
1275             // We can directly decrement the balance, and increment the number burned.
1276             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1277             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1278 
1279             // Updates:
1280             // - `address` to the last owner.
1281             // - `startTimestamp` to the timestamp of burning.
1282             // - `burned` to `true`.
1283             // - `nextInitialized` to `true`.
1284             _packedOwnerships[tokenId] = _packOwnershipData(
1285                 from,
1286                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1287             );
1288 
1289             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1290             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1291                 uint256 nextTokenId = tokenId + 1;
1292                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1293                 if (_packedOwnerships[nextTokenId] == 0) {
1294                     // If the next slot is within bounds.
1295                     if (nextTokenId != _currentIndex) {
1296                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1297                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1298                     }
1299                 }
1300             }
1301         }
1302 
1303         emit Transfer(from, address(0), tokenId);
1304         _afterTokenTransfers(from, address(0), tokenId, 1);
1305 
1306         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1307         unchecked {
1308             _burnCounter++;
1309         }
1310     }
1311 
1312     /**
1313      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1314      *
1315      * @param from address representing the previous owner of the given token ID
1316      * @param to target address that will receive the tokens
1317      * @param tokenId uint256 ID of the token to be transferred
1318      * @param _data bytes optional data to send along with the call
1319      * @return bool whether the call correctly returned the expected magic value
1320      */
1321     function _checkContractOnERC721Received(
1322         address from,
1323         address to,
1324         uint256 tokenId,
1325         bytes memory _data
1326     ) private returns (bool) {
1327         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1328             bytes4 retval
1329         ) {
1330             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1331         } catch (bytes memory reason) {
1332             if (reason.length == 0) {
1333                 revert TransferToNonERC721ReceiverImplementer();
1334             } else {
1335                 assembly {
1336                     revert(add(32, reason), mload(reason))
1337                 }
1338             }
1339         }
1340     }
1341 
1342     /**
1343      * @dev Directly sets the extra data for the ownership data `index`.
1344      */
1345     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1346         uint256 packed = _packedOwnerships[index];
1347         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1348         uint256 extraDataCasted;
1349         // Cast `extraData` with assembly to avoid redundant masking.
1350         assembly {
1351             extraDataCasted := extraData
1352         }
1353         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1354         _packedOwnerships[index] = packed;
1355     }
1356 
1357     /**
1358      * @dev Returns the next extra data for the packed ownership data.
1359      * The returned result is shifted into position.
1360      */
1361     function _nextExtraData(
1362         address from,
1363         address to,
1364         uint256 prevOwnershipPacked
1365     ) private view returns (uint256) {
1366         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1367         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1368     }
1369 
1370     /**
1371      * @dev Called during each token transfer to set the 24bit `extraData` field.
1372      * Intended to be overridden by the cosumer contract.
1373      *
1374      * `previousExtraData` - the value of `extraData` before transfer.
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` will be minted for `to`.
1381      * - When `to` is zero, `tokenId` will be burned by `from`.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _extraData(
1385         address from,
1386         address to,
1387         uint24 previousExtraData
1388     ) internal view virtual returns (uint24) {}
1389 
1390     /**
1391      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1392      * This includes minting.
1393      * And also called before burning one token.
1394      *
1395      * startTokenId - the first token id to be transferred
1396      * quantity - the amount to be transferred
1397      *
1398      * Calling conditions:
1399      *
1400      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1401      * transferred to `to`.
1402      * - When `from` is zero, `tokenId` will be minted for `to`.
1403      * - When `to` is zero, `tokenId` will be burned by `from`.
1404      * - `from` and `to` are never both zero.
1405      */
1406     function _beforeTokenTransfers(
1407         address from,
1408         address to,
1409         uint256 startTokenId,
1410         uint256 quantity
1411     ) internal virtual {}
1412 
1413     /**
1414      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1415      * This includes minting.
1416      * And also called after one token has been burned.
1417      *
1418      * startTokenId - the first token id to be transferred
1419      * quantity - the amount to be transferred
1420      *
1421      * Calling conditions:
1422      *
1423      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1424      * transferred to `to`.
1425      * - When `from` is zero, `tokenId` has been minted for `to`.
1426      * - When `to` is zero, `tokenId` has been burned by `from`.
1427      * - `from` and `to` are never both zero.
1428      */
1429     function _afterTokenTransfers(
1430         address from,
1431         address to,
1432         uint256 startTokenId,
1433         uint256 quantity
1434     ) internal virtual {}
1435 
1436     /**
1437      * @dev Returns the message sender (defaults to `msg.sender`).
1438      *
1439      * If you are writing GSN compatible contracts, you need to override this function.
1440      */
1441     function _msgSenderERC721A() internal view virtual returns (address) {
1442         return msg.sender;
1443     }
1444 
1445     /**
1446      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1447      */
1448     function _toString(uint256 value) internal pure returns (string memory ptr) {
1449         assembly {
1450             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1451             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1452             // We will need 1 32-byte word to store the length,
1453             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1454             ptr := add(mload(0x40), 128)
1455             // Update the free memory pointer to allocate.
1456             mstore(0x40, ptr)
1457 
1458             // Cache the end of the memory to calculate the length later.
1459             let end := ptr
1460 
1461             // We write the string from the rightmost digit to the leftmost digit.
1462             // The following is essentially a do-while loop that also handles the zero case.
1463             // Costs a bit more than early returning for the zero case,
1464             // but cheaper in terms of deployment and overall runtime costs.
1465             for {
1466                 // Initialize and perform the first pass without check.
1467                 let temp := value
1468                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1469                 ptr := sub(ptr, 1)
1470                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1471                 mstore8(ptr, add(48, mod(temp, 10)))
1472                 temp := div(temp, 10)
1473             } temp {
1474                 // Keep dividing `temp` until zero.
1475                 temp := div(temp, 10)
1476             } {
1477                 // Body of the for loop.
1478                 ptr := sub(ptr, 1)
1479                 mstore8(ptr, add(48, mod(temp, 10)))
1480             }
1481 
1482             let length := sub(end, ptr)
1483             // Move the pointer 32 bytes leftwards to make room for the length.
1484             ptr := sub(ptr, 32)
1485             // Store the length.
1486             mstore(ptr, length)
1487         }
1488     }
1489 }
1490 
1491 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1492 
1493 
1494 // ERC721A Contracts v4.1.0
1495 // Creator: Chiru Labs
1496 
1497 pragma solidity ^0.8.4;
1498 
1499 
1500 /**
1501  * @dev Interface of an ERC721AQueryable compliant contract.
1502  */
1503 interface IERC721AQueryable is IERC721A {
1504     /**
1505      * Invalid query range (`start` >= `stop`).
1506      */
1507     error InvalidQueryRange();
1508 
1509     /**
1510      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1511      *
1512      * If the `tokenId` is out of bounds:
1513      *   - `addr` = `address(0)`
1514      *   - `startTimestamp` = `0`
1515      *   - `burned` = `false`
1516      *
1517      * If the `tokenId` is burned:
1518      *   - `addr` = `<Address of owner before token was burned>`
1519      *   - `startTimestamp` = `<Timestamp when token was burned>`
1520      *   - `burned = `true`
1521      *
1522      * Otherwise:
1523      *   - `addr` = `<Address of owner>`
1524      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1525      *   - `burned = `false`
1526      */
1527     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1528 
1529     /**
1530      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1531      * See {ERC721AQueryable-explicitOwnershipOf}
1532      */
1533     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1534 
1535     /**
1536      * @dev Returns an array of token IDs owned by `owner`,
1537      * in the range [`start`, `stop`)
1538      * (i.e. `start <= tokenId < stop`).
1539      *
1540      * This function allows for tokens to be queried if the collection
1541      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1542      *
1543      * Requirements:
1544      *
1545      * - `start` < `stop`
1546      */
1547     function tokensOfOwnerIn(
1548         address owner,
1549         uint256 start,
1550         uint256 stop
1551     ) external view returns (uint256[] memory);
1552 
1553     /**
1554      * @dev Returns an array of token IDs owned by `owner`.
1555      *
1556      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1557      * It is meant to be called off-chain.
1558      *
1559      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1560      * multiple smaller scans if the collection is large enough to cause
1561      * an out-of-gas error (10K pfp collections should be fine).
1562      */
1563     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1564 }
1565 
1566 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1567 
1568 
1569 // ERC721A Contracts v4.1.0
1570 // Creator: Chiru Labs
1571 
1572 pragma solidity ^0.8.4;
1573 
1574 
1575 
1576 /**
1577  * @title ERC721A Queryable
1578  * @dev ERC721A subclass with convenience query functions.
1579  */
1580 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1581     /**
1582      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1583      *
1584      * If the `tokenId` is out of bounds:
1585      *   - `addr` = `address(0)`
1586      *   - `startTimestamp` = `0`
1587      *   - `burned` = `false`
1588      *   - `extraData` = `0`
1589      *
1590      * If the `tokenId` is burned:
1591      *   - `addr` = `<Address of owner before token was burned>`
1592      *   - `startTimestamp` = `<Timestamp when token was burned>`
1593      *   - `burned = `true`
1594      *   - `extraData` = `<Extra data when token was burned>`
1595      *
1596      * Otherwise:
1597      *   - `addr` = `<Address of owner>`
1598      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1599      *   - `burned = `false`
1600      *   - `extraData` = `<Extra data at start of ownership>`
1601      */
1602     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1603         TokenOwnership memory ownership;
1604         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1605             return ownership;
1606         }
1607         ownership = _ownershipAt(tokenId);
1608         if (ownership.burned) {
1609             return ownership;
1610         }
1611         return _ownershipOf(tokenId);
1612     }
1613 
1614     /**
1615      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1616      * See {ERC721AQueryable-explicitOwnershipOf}
1617      */
1618     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1619         unchecked {
1620             uint256 tokenIdsLength = tokenIds.length;
1621             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1622             for (uint256 i; i != tokenIdsLength; ++i) {
1623                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1624             }
1625             return ownerships;
1626         }
1627     }
1628 
1629     /**
1630      * @dev Returns an array of token IDs owned by `owner`,
1631      * in the range [`start`, `stop`)
1632      * (i.e. `start <= tokenId < stop`).
1633      *
1634      * This function allows for tokens to be queried if the collection
1635      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1636      *
1637      * Requirements:
1638      *
1639      * - `start` < `stop`
1640      */
1641     function tokensOfOwnerIn(
1642         address owner,
1643         uint256 start,
1644         uint256 stop
1645     ) external view override returns (uint256[] memory) {
1646         unchecked {
1647             if (start >= stop) revert InvalidQueryRange();
1648             uint256 tokenIdsIdx;
1649             uint256 stopLimit = _nextTokenId();
1650             // Set `start = max(start, _startTokenId())`.
1651             if (start < _startTokenId()) {
1652                 start = _startTokenId();
1653             }
1654             // Set `stop = min(stop, stopLimit)`.
1655             if (stop > stopLimit) {
1656                 stop = stopLimit;
1657             }
1658             uint256 tokenIdsMaxLength = balanceOf(owner);
1659             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1660             // to cater for cases where `balanceOf(owner)` is too big.
1661             if (start < stop) {
1662                 uint256 rangeLength = stop - start;
1663                 if (rangeLength < tokenIdsMaxLength) {
1664                     tokenIdsMaxLength = rangeLength;
1665                 }
1666             } else {
1667                 tokenIdsMaxLength = 0;
1668             }
1669             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1670             if (tokenIdsMaxLength == 0) {
1671                 return tokenIds;
1672             }
1673             // We need to call `explicitOwnershipOf(start)`,
1674             // because the slot at `start` may not be initialized.
1675             TokenOwnership memory ownership = explicitOwnershipOf(start);
1676             address currOwnershipAddr;
1677             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1678             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1679             if (!ownership.burned) {
1680                 currOwnershipAddr = ownership.addr;
1681             }
1682             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1683                 ownership = _ownershipAt(i);
1684                 if (ownership.burned) {
1685                     continue;
1686                 }
1687                 if (ownership.addr != address(0)) {
1688                     currOwnershipAddr = ownership.addr;
1689                 }
1690                 if (currOwnershipAddr == owner) {
1691                     tokenIds[tokenIdsIdx++] = i;
1692                 }
1693             }
1694             // Downsize the array to fit.
1695             assembly {
1696                 mstore(tokenIds, tokenIdsIdx)
1697             }
1698             return tokenIds;
1699         }
1700     }
1701 
1702     /**
1703      * @dev Returns an array of token IDs owned by `owner`.
1704      *
1705      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1706      * It is meant to be called off-chain.
1707      *
1708      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1709      * multiple smaller scans if the collection is large enough to cause
1710      * an out-of-gas error (10K pfp collections should be fine).
1711      */
1712     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1713         unchecked {
1714             uint256 tokenIdsIdx;
1715             address currOwnershipAddr;
1716             uint256 tokenIdsLength = balanceOf(owner);
1717             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1718             TokenOwnership memory ownership;
1719             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1720                 ownership = _ownershipAt(i);
1721                 if (ownership.burned) {
1722                     continue;
1723                 }
1724                 if (ownership.addr != address(0)) {
1725                     currOwnershipAddr = ownership.addr;
1726                 }
1727                 if (currOwnershipAddr == owner) {
1728                     tokenIds[tokenIdsIdx++] = i;
1729                 }
1730             }
1731             return tokenIds;
1732         }
1733     }
1734 }
1735 
1736 
1737 pragma solidity >=0.8.9 <0.9.0;
1738 
1739 contract $8pes is ERC721AQueryable, Ownable, ReentrancyGuard {
1740     using Strings for uint256;
1741 
1742     address public constant Steve_Aoki = 0xe4bBCbFf51e61D0D95FcC5016609aC8354B177C4; //for the culture 
1743 
1744     uint256 public maxSupply = 3333;
1745 	uint256 public Ownermint = 1;
1746     uint256 public maxPerAddress = 100;
1747 	uint256 public maxPerTX = 3;
1748     uint256 public cost = 0.002 ether;
1749 	mapping(address => bool) public freeMinted; 
1750 
1751     bool public paused = true;
1752 
1753 	string public uriPrefix = '';
1754     string public uriSuffix = '.json';
1755 
1756     
1757 	
1758   constructor(string memory baseURI) ERC721A("8pes NFT", "8PES") {
1759       setUriPrefix(baseURI); 
1760       _safeMint(_msgSender(), Ownermint);
1761 
1762   }
1763 
1764   modifier callerIsUser() {
1765         require(tx.origin == msg.sender, "The caller is another contract");
1766         _;
1767     }
1768  modifier Steve_Aoki_Cannot_Mint() {
1769         require(_msgSender() != Steve_Aoki, 'You are Steve Aoki and Steve Aoki can not mint.');// just for the meme, unless ure Steve Aoki
1770         _;
1771     }
1772 
1773   function numberMinted(address owner) public view returns (uint256) {
1774         return _numberMinted(owner);
1775     }
1776 
1777   function mint(uint256 _mintAmount) public payable nonReentrant callerIsUser Steve_Aoki_Cannot_Mint{
1778         require(!paused, 'The contract is paused!');
1779         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1780         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1781         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1782 	if (freeMinted[_msgSender()]){
1783         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1784     }
1785     else{
1786 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1787         freeMinted[_msgSender()] = true;
1788 	}
1789 
1790     _safeMint(_msgSender(), _mintAmount);
1791   }
1792 
1793   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1794     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1795     string memory currentBaseURI = _baseURI();
1796     return bytes(currentBaseURI).length > 0
1797         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1798         : '';
1799   }
1800 
1801   function setPaused() public onlyOwner {
1802     paused = !paused;
1803   }
1804 
1805   function setCost(uint256 _cost) public onlyOwner {
1806     cost = _cost;
1807   }
1808 
1809   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1810     maxPerTX = _maxPerTX;
1811   }
1812 
1813   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1814     uriPrefix = _uriPrefix;
1815   }
1816 
1817   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1818     uriSuffix = _uriSuffix;
1819   }
1820 
1821   function withdraw() external onlyOwner{
1822     payable(msg.sender).transfer(address(this).balance);
1823   }
1824 
1825   function _startTokenId() internal view virtual override returns (uint256) {
1826     return 1;
1827   }
1828 
1829   function _baseURI() internal view virtual override returns (string memory) {
1830     return uriPrefix;
1831   }
1832 }