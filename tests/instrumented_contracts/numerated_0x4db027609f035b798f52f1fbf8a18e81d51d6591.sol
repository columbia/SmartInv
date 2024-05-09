1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and making it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/Strings.sol
67 
68 
69 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev String operations.
75  */
76 library Strings {
77     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
78     uint8 private constant _ADDRESS_LENGTH = 20;
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 
136     /**
137      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
138      */
139     function toHexString(address addr) internal pure returns (string memory) {
140         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
141     }
142 }
143 
144 
145 // File: @openzeppelin/contracts/utils/Context.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/access/Ownable.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 abstract contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() {
201         _transferOwnership(_msgSender());
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         _checkOwner();
209         _;
210     }
211 
212     /**
213      * @dev Returns the address of the current owner.
214      */
215     function owner() public view virtual returns (address) {
216         return _owner;
217     }
218 
219     /**
220      * @dev Throws if the sender is not the owner.
221      */
222     function _checkOwner() internal view virtual {
223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
224     }
225 
226     /**
227      * @dev Leaves the contract without owner. It will not be possible to call
228      * `onlyOwner` functions anymore. Can only be called by the current owner.
229      *
230      * NOTE: Renouncing ownership will leave the contract without an owner,
231      * thereby removing any functionality that is only available to the owner.
232      */
233     function renounceOwnership() public virtual onlyOwner {
234         _transferOwnership(address(0));
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         _transferOwnership(newOwner);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Internal function without access restriction.
249      */
250     function _transferOwnership(address newOwner) internal virtual {
251         address oldOwner = _owner;
252         _owner = newOwner;
253         emit OwnershipTransferred(oldOwner, newOwner);
254     }
255 }
256 
257 // File: erc721a/contracts/IERC721A.sol
258 
259 
260 // ERC721A Contracts v4.1.0
261 // Creator: Chiru Labs
262 
263 pragma solidity ^0.8.4;
264 
265 /**
266  * @dev Interface of an ERC721A compliant contract.
267  */
268 interface IERC721A {
269     /**
270      * The caller must own the token or be an approved operator.
271      */
272     error ApprovalCallerNotOwnerNorApproved();
273 
274     /**
275      * The token does not exist.
276      */
277     error ApprovalQueryForNonexistentToken();
278 
279     /**
280      * The caller cannot approve to their own address.
281      */
282     error ApproveToCaller();
283 
284     /**
285      * Cannot query the balance for the zero address.
286      */
287     error BalanceQueryForZeroAddress();
288 
289     /**
290      * Cannot mint to the zero address.
291      */
292     error MintToZeroAddress();
293 
294     /**
295      * The quantity of tokens minted must be more than zero.
296      */
297     error MintZeroQuantity();
298 
299     /**
300      * The token does not exist.
301      */
302     error OwnerQueryForNonexistentToken();
303 
304     /**
305      * The caller must own the token or be an approved operator.
306      */
307     error TransferCallerNotOwnerNorApproved();
308 
309     /**
310      * The token must be owned by `from`.
311      */
312     error TransferFromIncorrectOwner();
313 
314     /**
315      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
316      */
317     error TransferToNonERC721ReceiverImplementer();
318 
319     /**
320      * Cannot transfer to the zero address.
321      */
322     error TransferToZeroAddress();
323 
324     /**
325      * The token does not exist.
326      */
327     error URIQueryForNonexistentToken();
328 
329     /**
330      * The `quantity` minted with ERC2309 exceeds the safety limit.
331      */
332     error MintERC2309QuantityExceedsLimit();
333 
334     /**
335      * The `extraData` cannot be set on an unintialized ownership slot.
336      */
337     error OwnershipNotInitializedForExtraData();
338 
339     struct TokenOwnership {
340         // The address of the owner.
341         address addr;
342         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
343         uint64 startTimestamp;
344         // Whether the token has been burned.
345         bool burned;
346         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
347         uint24 extraData;
348     }
349 
350     /**
351      * @dev Returns the total amount of tokens stored by the contract.
352      *
353      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
354      */
355     function totalSupply() external view returns (uint256);
356 
357     // ==============================
358     //            IERC165
359     // ==============================
360 
361     /**
362      * @dev Returns true if this contract implements the interface defined by
363      * `interfaceId`. See the corresponding
364      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
365      * to learn more about how these ids are created.
366      *
367      * This function call must use less than 30 000 gas.
368      */
369     function supportsInterface(bytes4 interfaceId) external view returns (bool);
370 
371     // ==============================
372     //            IERC721
373     // ==============================
374 
375     /**
376      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
377      */
378     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
379 
380     /**
381      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
382      */
383     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
384 
385     /**
386      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
387      */
388     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
389 
390     /**
391      * @dev Returns the number of tokens in ``owner``'s account.
392      */
393     function balanceOf(address owner) external view returns (uint256 balance);
394 
395     /**
396      * @dev Returns the owner of the `tokenId` token.
397      *
398      * Requirements:
399      *
400      * - `tokenId` must exist.
401      */
402     function ownerOf(uint256 tokenId) external view returns (address owner);
403 
404     /**
405      * @dev Safely transfers `tokenId` token from `from` to `to`.
406      *
407      * Requirements:
408      *
409      * - `from` cannot be the zero address.
410      * - `to` cannot be the zero address.
411      * - `tokenId` token must exist and be owned by `from`.
412      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
413      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
414      *
415      * Emits a {Transfer} event.
416      */
417     function safeTransferFrom(
418         address from,
419         address to,
420         uint256 tokenId,
421         bytes calldata data
422     ) external;
423 
424     /**
425      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
426      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `tokenId` token must exist and be owned by `from`.
433      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
435      *
436      * Emits a {Transfer} event.
437      */
438     function safeTransferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) external;
443 
444     /**
445      * @dev Transfers `tokenId` token from `from` to `to`.
446      *
447      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `tokenId` token must be owned by `from`.
454      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
455      *
456      * Emits a {Transfer} event.
457      */
458     function transferFrom(
459         address from,
460         address to,
461         uint256 tokenId
462     ) external;
463 
464     /**
465      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
466      * The approval is cleared when the token is transferred.
467      *
468      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
469      *
470      * Requirements:
471      *
472      * - The caller must own the token or be an approved operator.
473      * - `tokenId` must exist.
474      *
475      * Emits an {Approval} event.
476      */
477     function approve(address to, uint256 tokenId) external;
478 
479     /**
480      * @dev Approve or remove `operator` as an operator for the caller.
481      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
482      *
483      * Requirements:
484      *
485      * - The `operator` cannot be the caller.
486      *
487      * Emits an {ApprovalForAll} event.
488      */
489     function setApprovalForAll(address operator, bool _approved) external;
490 
491     /**
492      * @dev Returns the account approved for `tokenId` token.
493      *
494      * Requirements:
495      *
496      * - `tokenId` must exist.
497      */
498     function getApproved(uint256 tokenId) external view returns (address operator);
499 
500     /**
501      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
502      *
503      * See {setApprovalForAll}
504      */
505     function isApprovedForAll(address owner, address operator) external view returns (bool);
506 
507     // ==============================
508     //        IERC721Metadata
509     // ==============================
510 
511     /**
512      * @dev Returns the token collection name.
513      */
514     function name() external view returns (string memory);
515 
516     /**
517      * @dev Returns the token collection symbol.
518      */
519     function symbol() external view returns (string memory);
520 
521     /**
522      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
523      */
524     function tokenURI(uint256 tokenId) external view returns (string memory);
525 
526     // ==============================
527     //            IERC2309
528     // ==============================
529 
530     /**
531      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
532      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
533      */
534     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
535 }
536 
537 // File: erc721a/contracts/ERC721A.sol
538 
539 
540 // ERC721A Contracts v4.1.0
541 // Creator: Chiru Labs
542 
543 pragma solidity ^0.8.4;
544 
545 
546 /**
547  * @dev ERC721 token receiver interface.
548  */
549 interface ERC721A__IERC721Receiver {
550     function onERC721Received(
551         address operator,
552         address from,
553         uint256 tokenId,
554         bytes calldata data
555     ) external returns (bytes4);
556 }
557 
558 /**
559  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
560  * including the Metadata extension. Built to optimize for lower gas during batch mints.
561  *
562  * Assumes serials are sequentially minted starting at `_startTokenId()`
563  * (defaults to 0, e.g. 0, 1, 2, 3..).
564  *
565  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
566  *
567  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
568  */
569 contract ERC721A is IERC721A {
570     // Mask of an entry in packed address data.
571     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
572 
573     // The bit position of `numberMinted` in packed address data.
574     uint256 private constant BITPOS_NUMBER_MINTED = 64;
575 
576     // The bit position of `numberBurned` in packed address data.
577     uint256 private constant BITPOS_NUMBER_BURNED = 128;
578 
579     // The bit position of `aux` in packed address data.
580     uint256 private constant BITPOS_AUX = 192;
581 
582     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
583     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
584 
585     // The bit position of `startTimestamp` in packed ownership.
586     uint256 private constant BITPOS_START_TIMESTAMP = 160;
587 
588     // The bit mask of the `burned` bit in packed ownership.
589     uint256 private constant BITMASK_BURNED = 1 << 224;
590 
591     // The bit position of the `nextInitialized` bit in packed ownership.
592     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
593 
594     // The bit mask of the `nextInitialized` bit in packed ownership.
595     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
596 
597     // The bit position of `extraData` in packed ownership.
598     uint256 private constant BITPOS_EXTRA_DATA = 232;
599 
600     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
601     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
602 
603     // The mask of the lower 160 bits for addresses.
604     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
605 
606     // The maximum `quantity` that can be minted with `_mintERC2309`.
607     // This limit is to prevent overflows on the address data entries.
608     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
609     // is required to cause an overflow, which is unrealistic.
610     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
611 
612     // The tokenId of the next token to be minted.
613     uint256 private _currentIndex;
614 
615     // The number of tokens burned.
616     uint256 private _burnCounter;
617 
618     // Token name
619     string private _name;
620 
621     // Token symbol
622     string private _symbol;
623 
624     // Mapping from token ID to ownership details
625     // An empty struct value does not necessarily mean the token is unowned.
626     // See `_packedOwnershipOf` implementation for details.
627     //
628     // Bits Layout:
629     // - [0..159]   `addr`
630     // - [160..223] `startTimestamp`
631     // - [224]      `burned`
632     // - [225]      `nextInitialized`
633     // - [232..255] `extraData`
634     mapping(uint256 => uint256) private _packedOwnerships;
635 
636     // Mapping owner address to address data.
637     //
638     // Bits Layout:
639     // - [0..63]    `balance`
640     // - [64..127]  `numberMinted`
641     // - [128..191] `numberBurned`
642     // - [192..255] `aux`
643     mapping(address => uint256) private _packedAddressData;
644 
645     // Mapping from token ID to approved address.
646     mapping(uint256 => address) private _tokenApprovals;
647 
648     // Mapping from owner to operator approvals
649     mapping(address => mapping(address => bool)) private _operatorApprovals;
650 
651     constructor(string memory name_, string memory symbol_) {
652         _name = name_;
653         _symbol = symbol_;
654         _currentIndex = _startTokenId();
655     }
656 
657     /**
658      * @dev Returns the starting token ID.
659      * To change the starting token ID, please override this function.
660      */
661     function _startTokenId() internal view virtual returns (uint256) {
662         return 0;
663     }
664 
665     /**
666      * @dev Returns the next token ID to be minted.
667      */
668     function _nextTokenId() internal view returns (uint256) {
669         return _currentIndex;
670     }
671 
672     /**
673      * @dev Returns the total number of tokens in existence.
674      * Burned tokens will reduce the count.
675      * To get the total number of tokens minted, please see `_totalMinted`.
676      */
677     function totalSupply() public view override returns (uint256) {
678         // Counter underflow is impossible as _burnCounter cannot be incremented
679         // more than `_currentIndex - _startTokenId()` times.
680         unchecked {
681             return _currentIndex - _burnCounter - _startTokenId();
682         }
683     }
684 
685     /**
686      * @dev Returns the total amount of tokens minted in the contract.
687      */
688     function _totalMinted() internal view returns (uint256) {
689         // Counter underflow is impossible as _currentIndex does not decrement,
690         // and it is initialized to `_startTokenId()`
691         unchecked {
692             return _currentIndex - _startTokenId();
693         }
694     }
695 
696     /**
697      * @dev Returns the total number of tokens burned.
698      */
699     function _totalBurned() internal view returns (uint256) {
700         return _burnCounter;
701     }
702 
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707         // The interface IDs are constants representing the first 4 bytes of the XOR of
708         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
709         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
710         return
711             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
712             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
713             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
714     }
715 
716     /**
717      * @dev See {IERC721-balanceOf}.
718      */
719     function balanceOf(address owner) public view override returns (uint256) {
720         if (owner == address(0)) revert BalanceQueryForZeroAddress();
721         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
722     }
723 
724     /**
725      * Returns the number of tokens minted by `owner`.
726      */
727     function _numberMinted(address owner) internal view returns (uint256) {
728         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
729     }
730 
731     /**
732      * Returns the number of tokens burned by or on behalf of `owner`.
733      */
734     function _numberBurned(address owner) internal view returns (uint256) {
735         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
736     }
737 
738     /**
739      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
740      */
741     function _getAux(address owner) internal view returns (uint64) {
742         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
743     }
744 
745     /**
746      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
747      * If there are multiple variables, please pack them into a uint64.
748      */
749     function _setAux(address owner, uint64 aux) internal {
750         uint256 packed = _packedAddressData[owner];
751         uint256 auxCasted;
752         // Cast `aux` with assembly to avoid redundant masking.
753         assembly {
754             auxCasted := aux
755         }
756         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
757         _packedAddressData[owner] = packed;
758     }
759 
760     /**
761      * Returns the packed ownership data of `tokenId`.
762      */
763     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
764         uint256 curr = tokenId;
765 
766         unchecked {
767             if (_startTokenId() <= curr)
768                 if (curr < _currentIndex) {
769                     uint256 packed = _packedOwnerships[curr];
770                     // If not burned.
771                     if (packed & BITMASK_BURNED == 0) {
772                         // Invariant:
773                         // There will always be an ownership that has an address and is not burned
774                         // before an ownership that does not have an address and is not burned.
775                         // Hence, curr will not underflow.
776                         //
777                         // We can directly compare the packed value.
778                         // If the address is zero, packed is zero.
779                         while (packed == 0) {
780                             packed = _packedOwnerships[--curr];
781                         }
782                         return packed;
783                     }
784                 }
785         }
786         revert OwnerQueryForNonexistentToken();
787     }
788 
789     /**
790      * Returns the unpacked `TokenOwnership` struct from `packed`.
791      */
792     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
793         ownership.addr = address(uint160(packed));
794         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
795         ownership.burned = packed & BITMASK_BURNED != 0;
796         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
797     }
798 
799     /**
800      * Returns the unpacked `TokenOwnership` struct at `index`.
801      */
802     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
803         return _unpackedOwnership(_packedOwnerships[index]);
804     }
805 
806     /**
807      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
808      */
809     function _initializeOwnershipAt(uint256 index) internal {
810         if (_packedOwnerships[index] == 0) {
811             _packedOwnerships[index] = _packedOwnershipOf(index);
812         }
813     }
814 
815     /**
816      * Gas spent here starts off proportional to the maximum mint batch size.
817      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
818      */
819     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
820         return _unpackedOwnership(_packedOwnershipOf(tokenId));
821     }
822 
823     /**
824      * @dev Packs ownership data into a single uint256.
825      */
826     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
827         assembly {
828             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
829             owner := and(owner, BITMASK_ADDRESS)
830             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
831             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
832         }
833     }
834 
835     /**
836      * @dev See {IERC721-ownerOf}.
837      */
838     function ownerOf(uint256 tokenId) public view override returns (address) {
839         return address(uint160(_packedOwnershipOf(tokenId)));
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-name}.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-symbol}.
851      */
852     function symbol() public view virtual override returns (string memory) {
853         return _symbol;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-tokenURI}.
858      */
859     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
860         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
861 
862         string memory baseURI = _baseURI();
863         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
864     }
865 
866     /**
867      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
868      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
869      * by default, it can be overridden in child contracts.
870      */
871     function _baseURI() internal view virtual returns (string memory) {
872         return '';
873     }
874 
875     /**
876      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
877      */
878     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
879         // For branchless setting of the `nextInitialized` flag.
880         assembly {
881             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
882             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
883         }
884     }
885 
886     /**
887      * @dev See {IERC721-approve}.
888      */
889     function approve(address to, uint256 tokenId) public override {
890         address owner = ownerOf(tokenId);
891 
892         if (_msgSenderERC721A() != owner)
893             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
894                 revert ApprovalCallerNotOwnerNorApproved();
895             }
896 
897         _tokenApprovals[tokenId] = to;
898         emit Approval(owner, to, tokenId);
899     }
900 
901     /**
902      * @dev See {IERC721-getApproved}.
903      */
904     function getApproved(uint256 tokenId) public view override returns (address) {
905         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
906 
907         return _tokenApprovals[tokenId];
908     }
909 
910     /**
911      * @dev See {IERC721-setApprovalForAll}.
912      */
913     function setApprovalForAll(address operator, bool approved) public virtual override {
914         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
915 
916         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
917         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
918     }
919 
920     /**
921      * @dev See {IERC721-isApprovedForAll}.
922      */
923     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
924         return _operatorApprovals[owner][operator];
925     }
926 
927     /**
928      * @dev See {IERC721-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public virtual override {
935         safeTransferFrom(from, to, tokenId, '');
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) public virtual override {
947         transferFrom(from, to, tokenId);
948         if (to.code.length != 0)
949             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
950                 revert TransferToNonERC721ReceiverImplementer();
951             }
952     }
953 
954     /**
955      * @dev Returns whether `tokenId` exists.
956      *
957      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
958      *
959      * Tokens start existing when they are minted (`_mint`),
960      */
961     function _exists(uint256 tokenId) internal view returns (bool) {
962         return
963             _startTokenId() <= tokenId &&
964             tokenId < _currentIndex && // If within bounds,
965             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
966     }
967 
968     /**
969      * @dev Equivalent to `_safeMint(to, quantity, '')`.
970      */
971     function _safeMint(address to, uint256 quantity) internal {
972         _safeMint(to, quantity, '');
973     }
974 
975     /**
976      * @dev Safely mints `quantity` tokens and transfers them to `to`.
977      *
978      * Requirements:
979      *
980      * - If `to` refers to a smart contract, it must implement
981      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
982      * - `quantity` must be greater than 0.
983      *
984      * See {_mint}.
985      *
986      * Emits a {Transfer} event for each mint.
987      */
988     function _safeMint(
989         address to,
990         uint256 quantity,
991         bytes memory _data
992     ) internal {
993         _mint(to, quantity);
994 
995         unchecked {
996             if (to.code.length != 0) {
997                 uint256 end = _currentIndex;
998                 uint256 index = end - quantity;
999                 do {
1000                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1001                         revert TransferToNonERC721ReceiverImplementer();
1002                     }
1003                 } while (index < end);
1004                 // Reentrancy protection.
1005                 if (_currentIndex != end) revert();
1006             }
1007         }
1008     }
1009 
1010     /**
1011      * @dev Mints `quantity` tokens and transfers them to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `quantity` must be greater than 0.
1017      *
1018      * Emits a {Transfer} event for each mint.
1019      */
1020     function _mint(address to, uint256 quantity) internal {
1021         uint256 startTokenId = _currentIndex;
1022         if (to == address(0)) revert MintToZeroAddress();
1023         if (quantity == 0) revert MintZeroQuantity();
1024 
1025         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1026 
1027         // Overflows are incredibly unrealistic.
1028         // `balance` and `numberMinted` have a maximum limit of 2**64.
1029         // `tokenId` has a maximum limit of 2**256.
1030         unchecked {
1031             // Updates:
1032             // - `balance += quantity`.
1033             // - `numberMinted += quantity`.
1034             //
1035             // We can directly add to the `balance` and `numberMinted`.
1036             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1037 
1038             // Updates:
1039             // - `address` to the owner.
1040             // - `startTimestamp` to the timestamp of minting.
1041             // - `burned` to `false`.
1042             // - `nextInitialized` to `quantity == 1`.
1043             _packedOwnerships[startTokenId] = _packOwnershipData(
1044                 to,
1045                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1046             );
1047 
1048             uint256 tokenId = startTokenId;
1049             uint256 end = startTokenId + quantity;
1050             do {
1051                 emit Transfer(address(0), to, tokenId++);
1052             } while (tokenId < end);
1053 
1054             _currentIndex = end;
1055         }
1056         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1057     }
1058 
1059     /**
1060      * @dev Mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * This function is intended for efficient minting only during contract creation.
1063      *
1064      * It emits only one {ConsecutiveTransfer} as defined in
1065      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1066      * instead of a sequence of {Transfer} event(s).
1067      *
1068      * Calling this function outside of contract creation WILL make your contract
1069      * non-compliant with the ERC721 standard.
1070      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1071      * {ConsecutiveTransfer} event is only permissible during contract creation.
1072      *
1073      * Requirements:
1074      *
1075      * - `to` cannot be the zero address.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {ConsecutiveTransfer} event.
1079      */
1080     function _mintERC2309(address to, uint256 quantity) internal {
1081         uint256 startTokenId = _currentIndex;
1082         if (to == address(0)) revert MintToZeroAddress();
1083         if (quantity == 0) revert MintZeroQuantity();
1084         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1089         unchecked {
1090             // Updates:
1091             // - `balance += quantity`.
1092             // - `numberMinted += quantity`.
1093             //
1094             // We can directly add to the `balance` and `numberMinted`.
1095             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1096 
1097             // Updates:
1098             // - `address` to the owner.
1099             // - `startTimestamp` to the timestamp of minting.
1100             // - `burned` to `false`.
1101             // - `nextInitialized` to `quantity == 1`.
1102             _packedOwnerships[startTokenId] = _packOwnershipData(
1103                 to,
1104                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1105             );
1106 
1107             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1108 
1109             _currentIndex = startTokenId + quantity;
1110         }
1111         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1112     }
1113 
1114     /**
1115      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1116      */
1117     function _getApprovedAddress(uint256 tokenId)
1118         private
1119         view
1120         returns (uint256 approvedAddressSlot, address approvedAddress)
1121     {
1122         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1123         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1124         assembly {
1125             // Compute the slot.
1126             mstore(0x00, tokenId)
1127             mstore(0x20, tokenApprovalsPtr.slot)
1128             approvedAddressSlot := keccak256(0x00, 0x40)
1129             // Load the slot's value from storage.
1130             approvedAddress := sload(approvedAddressSlot)
1131         }
1132     }
1133 
1134     /**
1135      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1136      */
1137     function _isOwnerOrApproved(
1138         address approvedAddress,
1139         address from,
1140         address msgSender
1141     ) private pure returns (bool result) {
1142         assembly {
1143             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1144             from := and(from, BITMASK_ADDRESS)
1145             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1146             msgSender := and(msgSender, BITMASK_ADDRESS)
1147             // `msgSender == from || msgSender == approvedAddress`.
1148             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1149         }
1150     }
1151 
1152     /**
1153      * @dev Transfers `tokenId` from `from` to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - `to` cannot be the zero address.
1158      * - `tokenId` token must be owned by `from`.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function transferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public virtual override {
1167         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1168 
1169         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1170 
1171         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1172 
1173         // The nested ifs save around 20+ gas over a compound boolean condition.
1174         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1175             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1176 
1177         if (to == address(0)) revert TransferToZeroAddress();
1178 
1179         _beforeTokenTransfers(from, to, tokenId, 1);
1180 
1181         // Clear approvals from the previous owner.
1182         assembly {
1183             if approvedAddress {
1184                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1185                 sstore(approvedAddressSlot, 0)
1186             }
1187         }
1188 
1189         // Underflow of the sender's balance is impossible because we check for
1190         // ownership above and the recipient's balance can't realistically overflow.
1191         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1192         unchecked {
1193             // We can directly increment and decrement the balances.
1194             --_packedAddressData[from]; // Updates: `balance -= 1`.
1195             ++_packedAddressData[to]; // Updates: `balance += 1`.
1196 
1197             // Updates:
1198             // - `address` to the next owner.
1199             // - `startTimestamp` to the timestamp of transfering.
1200             // - `burned` to `false`.
1201             // - `nextInitialized` to `true`.
1202             _packedOwnerships[tokenId] = _packOwnershipData(
1203                 to,
1204                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1205             );
1206 
1207             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1208             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1209                 uint256 nextTokenId = tokenId + 1;
1210                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1211                 if (_packedOwnerships[nextTokenId] == 0) {
1212                     // If the next slot is within bounds.
1213                     if (nextTokenId != _currentIndex) {
1214                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1215                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1216                     }
1217                 }
1218             }
1219         }
1220 
1221         emit Transfer(from, to, tokenId);
1222         _afterTokenTransfers(from, to, tokenId, 1);
1223     }
1224 
1225     /**
1226      * @dev Equivalent to `_burn(tokenId, false)`.
1227      */
1228     function _burn(uint256 tokenId) internal virtual {
1229         _burn(tokenId, false);
1230     }
1231 
1232     /**
1233      * @dev Destroys `tokenId`.
1234      * The approval is cleared when the token is burned.
1235      *
1236      * Requirements:
1237      *
1238      * - `tokenId` must exist.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1243         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1244 
1245         address from = address(uint160(prevOwnershipPacked));
1246 
1247         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1248 
1249         if (approvalCheck) {
1250             // The nested ifs save around 20+ gas over a compound boolean condition.
1251             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1252                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1253         }
1254 
1255         _beforeTokenTransfers(from, address(0), tokenId, 1);
1256 
1257         // Clear approvals from the previous owner.
1258         assembly {
1259             if approvedAddress {
1260                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1261                 sstore(approvedAddressSlot, 0)
1262             }
1263         }
1264 
1265         // Underflow of the sender's balance is impossible because we check for
1266         // ownership above and the recipient's balance can't realistically overflow.
1267         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1268         unchecked {
1269             // Updates:
1270             // - `balance -= 1`.
1271             // - `numberBurned += 1`.
1272             //
1273             // We can directly decrement the balance, and increment the number burned.
1274             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1275             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1276 
1277             // Updates:
1278             // - `address` to the last owner.
1279             // - `startTimestamp` to the timestamp of burning.
1280             // - `burned` to `true`.
1281             // - `nextInitialized` to `true`.
1282             _packedOwnerships[tokenId] = _packOwnershipData(
1283                 from,
1284                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1285             );
1286 
1287             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1288             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1289                 uint256 nextTokenId = tokenId + 1;
1290                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1291                 if (_packedOwnerships[nextTokenId] == 0) {
1292                     // If the next slot is within bounds.
1293                     if (nextTokenId != _currentIndex) {
1294                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1295                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1296                     }
1297                 }
1298             }
1299         }
1300 
1301         emit Transfer(from, address(0), tokenId);
1302         _afterTokenTransfers(from, address(0), tokenId, 1);
1303 
1304         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1305         unchecked {
1306             _burnCounter++;
1307         }
1308     }
1309 
1310     /**
1311      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1312      *
1313      * @param from address representing the previous owner of the given token ID
1314      * @param to target address that will receive the tokens
1315      * @param tokenId uint256 ID of the token to be transferred
1316      * @param _data bytes optional data to send along with the call
1317      * @return bool whether the call correctly returned the expected magic value
1318      */
1319     function _checkContractOnERC721Received(
1320         address from,
1321         address to,
1322         uint256 tokenId,
1323         bytes memory _data
1324     ) private returns (bool) {
1325         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1326             bytes4 retval
1327         ) {
1328             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1329         } catch (bytes memory reason) {
1330             if (reason.length == 0) {
1331                 revert TransferToNonERC721ReceiverImplementer();
1332             } else {
1333                 assembly {
1334                     revert(add(32, reason), mload(reason))
1335                 }
1336             }
1337         }
1338     }
1339 
1340     /**
1341      * @dev Directly sets the extra data for the ownership data `index`.
1342      */
1343     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1344         uint256 packed = _packedOwnerships[index];
1345         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1346         uint256 extraDataCasted;
1347         // Cast `extraData` with assembly to avoid redundant masking.
1348         assembly {
1349             extraDataCasted := extraData
1350         }
1351         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1352         _packedOwnerships[index] = packed;
1353     }
1354 
1355     /**
1356      * @dev Returns the next extra data for the packed ownership data.
1357      * The returned result is shifted into position.
1358      */
1359     function _nextExtraData(
1360         address from,
1361         address to,
1362         uint256 prevOwnershipPacked
1363     ) private view returns (uint256) {
1364         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1365         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1366     }
1367 
1368     /**
1369      * @dev Called during each token transfer to set the 24bit `extraData` field.
1370      * Intended to be overridden by the cosumer contract.
1371      *
1372      * `previousExtraData` - the value of `extraData` before transfer.
1373      *
1374      * Calling conditions:
1375      *
1376      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1377      * transferred to `to`.
1378      * - When `from` is zero, `tokenId` will be minted for `to`.
1379      * - When `to` is zero, `tokenId` will be burned by `from`.
1380      * - `from` and `to` are never both zero.
1381      */
1382     function _extraData(
1383         address from,
1384         address to,
1385         uint24 previousExtraData
1386     ) internal view virtual returns (uint24) {}
1387 
1388     /**
1389      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1390      * This includes minting.
1391      * And also called before burning one token.
1392      *
1393      * startTokenId - the first token id to be transferred
1394      * quantity - the amount to be transferred
1395      *
1396      * Calling conditions:
1397      *
1398      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1399      * transferred to `to`.
1400      * - When `from` is zero, `tokenId` will be minted for `to`.
1401      * - When `to` is zero, `tokenId` will be burned by `from`.
1402      * - `from` and `to` are never both zero.
1403      */
1404     function _beforeTokenTransfers(
1405         address from,
1406         address to,
1407         uint256 startTokenId,
1408         uint256 quantity
1409     ) internal virtual {}
1410 
1411     /**
1412      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1413      * This includes minting.
1414      * And also called after one token has been burned.
1415      *
1416      * startTokenId - the first token id to be transferred
1417      * quantity - the amount to be transferred
1418      *
1419      * Calling conditions:
1420      *
1421      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1422      * transferred to `to`.
1423      * - When `from` is zero, `tokenId` has been minted for `to`.
1424      * - When `to` is zero, `tokenId` has been burned by `from`.
1425      * - `from` and `to` are never both zero.
1426      */
1427     function _afterTokenTransfers(
1428         address from,
1429         address to,
1430         uint256 startTokenId,
1431         uint256 quantity
1432     ) internal virtual {}
1433 
1434     /**
1435      * @dev Returns the message sender (defaults to `msg.sender`).
1436      *
1437      * If you are writing GSN compatible contracts, you need to override this function.
1438      */
1439     function _msgSenderERC721A() internal view virtual returns (address) {
1440         return msg.sender;
1441     }
1442 
1443     /**
1444      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1445      */
1446     function _toString(uint256 value) internal pure returns (string memory ptr) {
1447         assembly {
1448             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1449             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1450             // We will need 1 32-byte word to store the length,
1451             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1452             ptr := add(mload(0x40), 128)
1453             // Update the free memory pointer to allocate.
1454             mstore(0x40, ptr)
1455 
1456             // Cache the end of the memory to calculate the length later.
1457             let end := ptr
1458 
1459             // We write the string from the rightmost digit to the leftmost digit.
1460             // The following is essentially a do-while loop that also handles the zero case.
1461             // Costs a bit more than early returning for the zero case,
1462             // but cheaper in terms of deployment and overall runtime costs.
1463             for {
1464                 // Initialize and perform the first pass without check.
1465                 let temp := value
1466                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1467                 ptr := sub(ptr, 1)
1468                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1469                 mstore8(ptr, add(48, mod(temp, 10)))
1470                 temp := div(temp, 10)
1471             } temp {
1472                 // Keep dividing `temp` until zero.
1473                 temp := div(temp, 10)
1474             } {
1475                 // Body of the for loop.
1476                 ptr := sub(ptr, 1)
1477                 mstore8(ptr, add(48, mod(temp, 10)))
1478             }
1479 
1480             let length := sub(end, ptr)
1481             // Move the pointer 32 bytes leftwards to make room for the length.
1482             ptr := sub(ptr, 32)
1483             // Store the length.
1484             mstore(ptr, length)
1485         }
1486     }
1487 }
1488 
1489 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1490 
1491 
1492 // ERC721A Contracts v4.1.0
1493 // Creator: Chiru Labs
1494 
1495 pragma solidity ^0.8.4;
1496 
1497 
1498 /**
1499  * @dev Interface of an ERC721AQueryable compliant contract.
1500  */
1501 interface IERC721AQueryable is IERC721A {
1502     /**
1503      * Invalid query range (`start` >= `stop`).
1504      */
1505     error InvalidQueryRange();
1506 
1507     /**
1508      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1509      *
1510      * If the `tokenId` is out of bounds:
1511      *   - `addr` = `address(0)`
1512      *   - `startTimestamp` = `0`
1513      *   - `burned` = `false`
1514      *
1515      * If the `tokenId` is burned:
1516      *   - `addr` = `<Address of owner before token was burned>`
1517      *   - `startTimestamp` = `<Timestamp when token was burned>`
1518      *   - `burned = `true`
1519      *
1520      * Otherwise:
1521      *   - `addr` = `<Address of owner>`
1522      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1523      *   - `burned = `false`
1524      */
1525     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1526 
1527     /**
1528      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1529      * See {ERC721AQueryable-explicitOwnershipOf}
1530      */
1531     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1532 
1533     /**
1534      * @dev Returns an array of token IDs owned by `owner`,
1535      * in the range [`start`, `stop`)
1536      * (i.e. `start <= tokenId < stop`).
1537      *
1538      * This function allows for tokens to be queried if the collection
1539      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1540      *
1541      * Requirements:
1542      *
1543      * - `start` < `stop`
1544      */
1545     function tokensOfOwnerIn(
1546         address owner,
1547         uint256 start,
1548         uint256 stop
1549     ) external view returns (uint256[] memory);
1550 
1551     /**
1552      * @dev Returns an array of token IDs owned by `owner`.
1553      *
1554      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1555      * It is meant to be called off-chain.
1556      *
1557      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1558      * multiple smaller scans if the collection is large enough to cause
1559      * an out-of-gas error (10K pfp collections should be fine).
1560      */
1561     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1562 }
1563 
1564 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1565 
1566 
1567 // ERC721A Contracts v4.1.0
1568 // Creator: Chiru Labs
1569 
1570 pragma solidity ^0.8.4;
1571 
1572 
1573 
1574 /**
1575  * @title ERC721A Queryable
1576  * @dev ERC721A subclass with convenience query functions.
1577  */
1578 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1579     /**
1580      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1581      *
1582      * If the `tokenId` is out of bounds:
1583      *   - `addr` = `address(0)`
1584      *   - `startTimestamp` = `0`
1585      *   - `burned` = `false`
1586      *   - `extraData` = `0`
1587      *
1588      * If the `tokenId` is burned:
1589      *   - `addr` = `<Address of owner before token was burned>`
1590      *   - `startTimestamp` = `<Timestamp when token was burned>`
1591      *   - `burned = `true`
1592      *   - `extraData` = `<Extra data when token was burned>`
1593      *
1594      * Otherwise:
1595      *   - `addr` = `<Address of owner>`
1596      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1597      *   - `burned = `false`
1598      *   - `extraData` = `<Extra data at start of ownership>`
1599      */
1600     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1601         TokenOwnership memory ownership;
1602         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1603             return ownership;
1604         }
1605         ownership = _ownershipAt(tokenId);
1606         if (ownership.burned) {
1607             return ownership;
1608         }
1609         return _ownershipOf(tokenId);
1610     }
1611 
1612     /**
1613      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1614      * See {ERC721AQueryable-explicitOwnershipOf}
1615      */
1616     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1617         unchecked {
1618             uint256 tokenIdsLength = tokenIds.length;
1619             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1620             for (uint256 i; i != tokenIdsLength; ++i) {
1621                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1622             }
1623             return ownerships;
1624         }
1625     }
1626 
1627     /**
1628      * @dev Returns an array of token IDs owned by `owner`,
1629      * in the range [`start`, `stop`)
1630      * (i.e. `start <= tokenId < stop`).
1631      *
1632      * This function allows for tokens to be queried if the collection
1633      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1634      *
1635      * Requirements:
1636      *
1637      * - `start` < `stop`
1638      */
1639     function tokensOfOwnerIn(
1640         address owner,
1641         uint256 start,
1642         uint256 stop
1643     ) external view override returns (uint256[] memory) {
1644         unchecked {
1645             if (start >= stop) revert InvalidQueryRange();
1646             uint256 tokenIdsIdx;
1647             uint256 stopLimit = _nextTokenId();
1648             // Set `start = max(start, _startTokenId())`.
1649             if (start < _startTokenId()) {
1650                 start = _startTokenId();
1651             }
1652             // Set `stop = min(stop, stopLimit)`.
1653             if (stop > stopLimit) {
1654                 stop = stopLimit;
1655             }
1656             uint256 tokenIdsMaxLength = balanceOf(owner);
1657             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1658             // to cater for cases where `balanceOf(owner)` is too big.
1659             if (start < stop) {
1660                 uint256 rangeLength = stop - start;
1661                 if (rangeLength < tokenIdsMaxLength) {
1662                     tokenIdsMaxLength = rangeLength;
1663                 }
1664             } else {
1665                 tokenIdsMaxLength = 0;
1666             }
1667             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1668             if (tokenIdsMaxLength == 0) {
1669                 return tokenIds;
1670             }
1671             // We need to call `explicitOwnershipOf(start)`,
1672             // because the slot at `start` may not be initialized.
1673             TokenOwnership memory ownership = explicitOwnershipOf(start);
1674             address currOwnershipAddr;
1675             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1676             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1677             if (!ownership.burned) {
1678                 currOwnershipAddr = ownership.addr;
1679             }
1680             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1681                 ownership = _ownershipAt(i);
1682                 if (ownership.burned) {
1683                     continue;
1684                 }
1685                 if (ownership.addr != address(0)) {
1686                     currOwnershipAddr = ownership.addr;
1687                 }
1688                 if (currOwnershipAddr == owner) {
1689                     tokenIds[tokenIdsIdx++] = i;
1690                 }
1691             }
1692             // Downsize the array to fit.
1693             assembly {
1694                 mstore(tokenIds, tokenIdsIdx)
1695             }
1696             return tokenIds;
1697         }
1698     }
1699 
1700     /**
1701      * @dev Returns an array of token IDs owned by `owner`.
1702      *
1703      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1704      * It is meant to be called off-chain.
1705      *
1706      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1707      * multiple smaller scans if the collection is large enough to cause
1708      * an out-of-gas error (10K pfp collections should be fine).
1709      */
1710     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1711         unchecked {
1712             uint256 tokenIdsIdx;
1713             address currOwnershipAddr;
1714             uint256 tokenIdsLength = balanceOf(owner);
1715             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1716             TokenOwnership memory ownership;
1717             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1718                 ownership = _ownershipAt(i);
1719                 if (ownership.burned) {
1720                     continue;
1721                 }
1722                 if (ownership.addr != address(0)) {
1723                     currOwnershipAddr = ownership.addr;
1724                 }
1725                 if (currOwnershipAddr == owner) {
1726                     tokenIds[tokenIdsIdx++] = i;
1727                 }
1728             }
1729             return tokenIds;
1730         }
1731     }
1732 }
1733 
1734 
1735 
1736 pragma solidity >=0.8.9 <0.9.0;
1737 
1738 contract NotCelMates is ERC721AQueryable, Ownable, ReentrancyGuard {
1739     using Strings for uint256;
1740 
1741     uint256 public maxSupply = 8888;
1742 	uint256 public Ownermint = 5;
1743     uint256 public maxPerAddress = 10;
1744 	uint256 public maxPerTX = 10;
1745     uint256 public cost = 0.003 ether;
1746 	mapping(address => bool) public freeMinted; 
1747 
1748     bool public paused = true;
1749 
1750 	string public uriPrefix = '';
1751     string public uriSuffix = '.json';
1752 	
1753   constructor(string memory baseURI) ERC721A("NotCelMates", "NCM") {
1754       setUriPrefix(baseURI); 
1755       _safeMint(_msgSender(), Ownermint);
1756 
1757   }
1758 
1759   modifier callerIsUser() {
1760         require(tx.origin == msg.sender, "The caller is another contract");
1761         _;
1762   }
1763 
1764   function numberMinted(address owner) public view returns (uint256) {
1765         return _numberMinted(owner);
1766   }
1767 
1768   function mint(uint256 _mintAmount) public payable nonReentrant callerIsUser{
1769         require(!paused, 'The contract is paused!');
1770         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1771         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1772         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1773 	if (freeMinted[_msgSender()]){
1774         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1775   }
1776     else{
1777 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1778         freeMinted[_msgSender()] = true;
1779   }
1780 
1781     _safeMint(_msgSender(), _mintAmount);
1782   }
1783 
1784   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1785     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1786     string memory currentBaseURI = _baseURI();
1787     return bytes(currentBaseURI).length > 0
1788         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1789         : '';
1790   }
1791 
1792   function setPaused() public onlyOwner {
1793     paused = !paused;
1794   }
1795 
1796   function setCost(uint256 _cost) public onlyOwner {
1797     cost = _cost;
1798   }
1799 
1800   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1801     maxPerTX = _maxPerTX;
1802   }
1803 
1804   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1805     uriPrefix = _uriPrefix;
1806   }
1807  
1808   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1809     uriSuffix = _uriSuffix;
1810   }
1811 
1812   function withdraw() external onlyOwner {
1813         payable(msg.sender).transfer(address(this).balance);
1814   }
1815 
1816   function _startTokenId() internal view virtual override returns (uint256) {
1817     return 1;
1818   }
1819 
1820   function _baseURI() internal view virtual override returns (string memory) {
1821     return uriPrefix;
1822   }
1823 }