1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
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
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79     uint8 private constant _ADDRESS_LENGTH = 20;
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
83      */
84     function toString(uint256 value) internal pure returns (string memory) {
85         // Inspired by OraclizeAPI's implementation - MIT licence
86         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
108      */
109     function toHexString(uint256 value) internal pure returns (string memory) {
110         if (value == 0) {
111             return "0x00";
112         }
113         uint256 temp = value;
114         uint256 length = 0;
115         while (temp != 0) {
116             length++;
117             temp >>= 8;
118         }
119         return toHexString(value, length);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
124      */
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 
137     /**
138      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
139      */
140     function toHexString(address addr) internal pure returns (string memory) {
141         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
142     }
143 }
144 
145 
146 // File: @openzeppelin/contracts/utils/Context.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes calldata) {
169         return msg.data;
170     }
171 }
172 
173 // File: @openzeppelin/contracts/access/Ownable.sol
174 
175 
176 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 
181 /**
182  * @dev Contract module which provides a basic access control mechanism, where
183  * there is an account (an owner) that can be granted exclusive access to
184  * specific functions.
185  *
186  * By default, the owner account will be the one that deploys the contract. This
187  * can later be changed with {transferOwnership}.
188  *
189  * This module is used through inheritance. It will make available the modifier
190  * `onlyOwner`, which can be applied to your functions to restrict their use to
191  * the owner.
192  */
193 abstract contract Ownable is Context {
194     address private _owner;
195 
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198     /**
199      * @dev Initializes the contract setting the deployer as the initial owner.
200      */
201     constructor() {
202         _transferOwnership(_msgSender());
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         _checkOwner();
210         _;
211     }
212 
213     /**
214      * @dev Returns the address of the current owner.
215      */
216     function owner() public view virtual returns (address) {
217         return _owner;
218     }
219 
220     /**
221      * @dev Throws if the sender is not the owner.
222      */
223     function _checkOwner() internal view virtual {
224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
225     }
226 
227     /**
228      * @dev Leaves the contract without owner. It will not be possible to call
229      * `onlyOwner` functions anymore. Can only be called by the current owner.
230      *
231      * NOTE: Renouncing ownership will leave the contract without an owner,
232      * thereby removing any functionality that is only available to the owner.
233      */
234     function renounceOwnership() public virtual onlyOwner {
235         _transferOwnership(address(0));
236     }
237 
238     /**
239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
240      * Can only be called by the current owner.
241      */
242     function transferOwnership(address newOwner) public virtual onlyOwner {
243         require(newOwner != address(0), "Ownable: new owner is the zero address");
244         _transferOwnership(newOwner);
245     }
246 
247     /**
248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
249      * Internal function without access restriction.
250      */
251     function _transferOwnership(address newOwner) internal virtual {
252         address oldOwner = _owner;
253         _owner = newOwner;
254         emit OwnershipTransferred(oldOwner, newOwner);
255     }
256 }
257 
258 // File: erc721a/contracts/IERC721A.sol
259 
260 
261 // ERC721A Contracts v4.1.0
262 // Creator: Chiru Labs
263 
264 pragma solidity ^0.8.4;
265 
266 /**
267  * @dev Interface of an ERC721A compliant contract.
268  */
269 interface IERC721A {
270     /**
271      * The caller must own the token or be an approved operator.
272      */
273     error ApprovalCallerNotOwnerNorApproved();
274 
275     /**
276      * The token does not exist.
277      */
278     error ApprovalQueryForNonexistentToken();
279 
280     /**
281      * The caller cannot approve to their own address.
282      */
283     error ApproveToCaller();
284 
285     /**
286      * Cannot query the balance for the zero address.
287      */
288     error BalanceQueryForZeroAddress();
289 
290     /**
291      * Cannot mint to the zero address.
292      */
293     error MintToZeroAddress();
294 
295     /**
296      * The quantity of tokens minted must be more than zero.
297      */
298     error MintZeroQuantity();
299 
300     /**
301      * The token does not exist.
302      */
303     error OwnerQueryForNonexistentToken();
304 
305     /**
306      * The caller must own the token or be an approved operator.
307      */
308     error TransferCallerNotOwnerNorApproved();
309 
310     /**
311      * The token must be owned by `from`.
312      */
313     error TransferFromIncorrectOwner();
314 
315     /**
316      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
317      */
318     error TransferToNonERC721ReceiverImplementer();
319 
320     /**
321      * Cannot transfer to the zero address.
322      */
323     error TransferToZeroAddress();
324 
325     /**
326      * The token does not exist.
327      */
328     error URIQueryForNonexistentToken();
329 
330     /**
331      * The `quantity` minted with ERC2309 exceeds the safety limit.
332      */
333     error MintERC2309QuantityExceedsLimit();
334 
335     /**
336      * The `extraData` cannot be set on an unintialized ownership slot.
337      */
338     error OwnershipNotInitializedForExtraData();
339 
340     struct TokenOwnership {
341         // The address of the owner.
342         address addr;
343         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
344         uint64 startTimestamp;
345         // Whether the token has been burned.
346         bool burned;
347         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
348         uint24 extraData;
349     }
350 
351     /**
352      * @dev Returns the total amount of tokens stored by the contract.
353      *
354      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
355      */
356     function totalSupply() external view returns (uint256);
357 
358     // ==============================
359     //            IERC165
360     // ==============================
361 
362     /**
363      * @dev Returns true if this contract implements the interface defined by
364      * `interfaceId`. See the corresponding
365      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
366      * to learn more about how these ids are created.
367      *
368      * This function call must use less than 30 000 gas.
369      */
370     function supportsInterface(bytes4 interfaceId) external view returns (bool);
371 
372     // ==============================
373     //            IERC721
374     // ==============================
375 
376     /**
377      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
383      */
384     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
388      */
389     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
390 
391     /**
392      * @dev Returns the number of tokens in ``owner``'s account.
393      */
394     function balanceOf(address owner) external view returns (uint256 balance);
395 
396     /**
397      * @dev Returns the owner of the `tokenId` token.
398      *
399      * Requirements:
400      *
401      * - `tokenId` must exist.
402      */
403     function ownerOf(uint256 tokenId) external view returns (address owner);
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must exist and be owned by `from`.
413      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
414      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
415      *
416      * Emits a {Transfer} event.
417      */
418     function safeTransferFrom(
419         address from,
420         address to,
421         uint256 tokenId,
422         bytes calldata data
423     ) external;
424 
425     /**
426      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
427      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Transfers `tokenId` token from `from` to `to`.
447      *
448      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must be owned by `from`.
455      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
456      *
457      * Emits a {Transfer} event.
458      */
459     function transferFrom(
460         address from,
461         address to,
462         uint256 tokenId
463     ) external;
464 
465     /**
466      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
467      * The approval is cleared when the token is transferred.
468      *
469      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
470      *
471      * Requirements:
472      *
473      * - The caller must own the token or be an approved operator.
474      * - `tokenId` must exist.
475      *
476      * Emits an {Approval} event.
477      */
478     function approve(address to, uint256 tokenId) external;
479 
480     /**
481      * @dev Approve or remove `operator` as an operator for the caller.
482      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
483      *
484      * Requirements:
485      *
486      * - The `operator` cannot be the caller.
487      *
488      * Emits an {ApprovalForAll} event.
489      */
490     function setApprovalForAll(address operator, bool _approved) external;
491 
492     /**
493      * @dev Returns the account approved for `tokenId` token.
494      *
495      * Requirements:
496      *
497      * - `tokenId` must exist.
498      */
499     function getApproved(uint256 tokenId) external view returns (address operator);
500 
501     /**
502      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
503      *
504      * See {setApprovalForAll}
505      */
506     function isApprovedForAll(address owner, address operator) external view returns (bool);
507 
508     // ==============================
509     //        IERC721Metadata
510     // ==============================
511 
512     /**
513      * @dev Returns the token collection name.
514      */
515     function name() external view returns (string memory);
516 
517     /**
518      * @dev Returns the token collection symbol.
519      */
520     function symbol() external view returns (string memory);
521 
522     /**
523      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
524      */
525     function tokenURI(uint256 tokenId) external view returns (string memory);
526 
527     // ==============================
528     //            IERC2309
529     // ==============================
530 
531     /**
532      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
533      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
534      */
535     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
536 }
537 
538 // File: erc721a/contracts/ERC721A.sol
539 
540 
541 // ERC721A Contracts v4.1.0
542 // Creator: Chiru Labs
543 
544 pragma solidity ^0.8.4;
545 
546 
547 /**
548  * @dev ERC721 token receiver interface.
549  */
550 interface ERC721A__IERC721Receiver {
551     function onERC721Received(
552         address operator,
553         address from,
554         uint256 tokenId,
555         bytes calldata data
556     ) external returns (bytes4);
557 }
558 
559 /**
560  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
561  * including the Metadata extension. Built to optimize for lower gas during batch mints.
562  *
563  * Assumes serials are sequentially minted starting at `_startTokenId()`
564  * (defaults to 0, e.g. 0, 1, 2, 3..).
565  *
566  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
567  *
568  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
569  */
570 contract ERC721A is IERC721A {
571     // Mask of an entry in packed address data.
572     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
573 
574     // The bit position of `numberMinted` in packed address data.
575     uint256 private constant BITPOS_NUMBER_MINTED = 64;
576 
577     // The bit position of `numberBurned` in packed address data.
578     uint256 private constant BITPOS_NUMBER_BURNED = 128;
579 
580     // The bit position of `aux` in packed address data.
581     uint256 private constant BITPOS_AUX = 192;
582 
583     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
584     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
585 
586     // The bit position of `startTimestamp` in packed ownership.
587     uint256 private constant BITPOS_START_TIMESTAMP = 160;
588 
589     // The bit mask of the `burned` bit in packed ownership.
590     uint256 private constant BITMASK_BURNED = 1 << 224;
591 
592     // The bit position of the `nextInitialized` bit in packed ownership.
593     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
594 
595     // The bit mask of the `nextInitialized` bit in packed ownership.
596     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
597 
598     // The bit position of `extraData` in packed ownership.
599     uint256 private constant BITPOS_EXTRA_DATA = 232;
600 
601     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
602     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
603 
604     // The mask of the lower 160 bits for addresses.
605     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
606 
607     // The maximum `quantity` that can be minted with `_mintERC2309`.
608     // This limit is to prevent overflows on the address data entries.
609     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
610     // is required to cause an overflow, which is unrealistic.
611     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
612 
613     // The tokenId of the next token to be minted.
614     uint256 private _currentIndex;
615 
616     // The number of tokens burned.
617     uint256 private _burnCounter;
618 
619     // Token name
620     string private _name;
621 
622     // Token symbol
623     string private _symbol;
624 
625     // Mapping from token ID to ownership details
626     // An empty struct value does not necessarily mean the token is unowned.
627     // See `_packedOwnershipOf` implementation for details.
628     //
629     // Bits Layout:
630     // - [0..159]   `addr`
631     // - [160..223] `startTimestamp`
632     // - [224]      `burned`
633     // - [225]      `nextInitialized`
634     // - [232..255] `extraData`
635     mapping(uint256 => uint256) private _packedOwnerships;
636 
637     // Mapping owner address to address data.
638     //
639     // Bits Layout:
640     // - [0..63]    `balance`
641     // - [64..127]  `numberMinted`
642     // - [128..191] `numberBurned`
643     // - [192..255] `aux`
644     mapping(address => uint256) private _packedAddressData;
645 
646     // Mapping from token ID to approved address.
647     mapping(uint256 => address) private _tokenApprovals;
648 
649     // Mapping from owner to operator approvals
650     mapping(address => mapping(address => bool)) private _operatorApprovals;
651 
652     constructor(string memory name_, string memory symbol_) {
653         _name = name_;
654         _symbol = symbol_;
655         _currentIndex = _startTokenId();
656     }
657 
658     /**
659      * @dev Returns the starting token ID.
660      * To change the starting token ID, please override this function.
661      */
662     function _startTokenId() internal view virtual returns (uint256) {
663         return 0;
664     }
665 
666     /**
667      * @dev Returns the next token ID to be minted.
668      */
669     function _nextTokenId() internal view returns (uint256) {
670         return _currentIndex;
671     }
672 
673     /**
674      * @dev Returns the total number of tokens in existence.
675      * Burned tokens will reduce the count.
676      * To get the total number of tokens minted, please see `_totalMinted`.
677      */
678     function totalSupply() public view override returns (uint256) {
679         // Counter underflow is impossible as _burnCounter cannot be incremented
680         // more than `_currentIndex - _startTokenId()` times.
681         unchecked {
682             return _currentIndex - _burnCounter - _startTokenId();
683         }
684     }
685 
686     /**
687      * @dev Returns the total amount of tokens minted in the contract.
688      */
689     function _totalMinted() internal view returns (uint256) {
690         // Counter underflow is impossible as _currentIndex does not decrement,
691         // and it is initialized to `_startTokenId()`
692         unchecked {
693             return _currentIndex - _startTokenId();
694         }
695     }
696 
697     /**
698      * @dev Returns the total number of tokens burned.
699      */
700     function _totalBurned() internal view returns (uint256) {
701         return _burnCounter;
702     }
703 
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
708         // The interface IDs are constants representing the first 4 bytes of the XOR of
709         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
710         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
711         return
712             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
713             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
714             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
715     }
716 
717     /**
718      * @dev See {IERC721-balanceOf}.
719      */
720     function balanceOf(address owner) public view override returns (uint256) {
721         if (owner == address(0)) revert BalanceQueryForZeroAddress();
722         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
723     }
724 
725     /**
726      * Returns the number of tokens minted by `owner`.
727      */
728     function _numberMinted(address owner) internal view returns (uint256) {
729         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
730     }
731 
732     /**
733      * Returns the number of tokens burned by or on behalf of `owner`.
734      */
735     function _numberBurned(address owner) internal view returns (uint256) {
736         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
737     }
738 
739     /**
740      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
741      */
742     function _getAux(address owner) internal view returns (uint64) {
743         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
744     }
745 
746     /**
747      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
748      * If there are multiple variables, please pack them into a uint64.
749      */
750     function _setAux(address owner, uint64 aux) internal {
751         uint256 packed = _packedAddressData[owner];
752         uint256 auxCasted;
753         // Cast `aux` with assembly to avoid redundant masking.
754         assembly {
755             auxCasted := aux
756         }
757         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
758         _packedAddressData[owner] = packed;
759     }
760 
761     /**
762      * Returns the packed ownership data of `tokenId`.
763      */
764     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
765         uint256 curr = tokenId;
766 
767         unchecked {
768             if (_startTokenId() <= curr)
769                 if (curr < _currentIndex) {
770                     uint256 packed = _packedOwnerships[curr];
771                     // If not burned.
772                     if (packed & BITMASK_BURNED == 0) {
773                         // Invariant:
774                         // There will always be an ownership that has an address and is not burned
775                         // before an ownership that does not have an address and is not burned.
776                         // Hence, curr will not underflow.
777                         //
778                         // We can directly compare the packed value.
779                         // If the address is zero, packed is zero.
780                         while (packed == 0) {
781                             packed = _packedOwnerships[--curr];
782                         }
783                         return packed;
784                     }
785                 }
786         }
787         revert OwnerQueryForNonexistentToken();
788     }
789 
790     /**
791      * Returns the unpacked `TokenOwnership` struct from `packed`.
792      */
793     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
794         ownership.addr = address(uint160(packed));
795         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
796         ownership.burned = packed & BITMASK_BURNED != 0;
797         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
798     }
799 
800     /**
801      * Returns the unpacked `TokenOwnership` struct at `index`.
802      */
803     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
804         return _unpackedOwnership(_packedOwnerships[index]);
805     }
806 
807     /**
808      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
809      */
810     function _initializeOwnershipAt(uint256 index) internal {
811         if (_packedOwnerships[index] == 0) {
812             _packedOwnerships[index] = _packedOwnershipOf(index);
813         }
814     }
815 
816     /**
817      * Gas spent here starts off proportional to the maximum mint batch size.
818      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
819      */
820     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
821         return _unpackedOwnership(_packedOwnershipOf(tokenId));
822     }
823 
824     /**
825      * @dev Packs ownership data into a single uint256.
826      */
827     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
828         assembly {
829             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
830             owner := and(owner, BITMASK_ADDRESS)
831             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
832             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
833         }
834     }
835 
836     /**
837      * @dev See {IERC721-ownerOf}.
838      */
839     function ownerOf(uint256 tokenId) public view override returns (address) {
840         return address(uint160(_packedOwnershipOf(tokenId)));
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-name}.
845      */
846     function name() public view virtual override returns (string memory) {
847         return _name;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-symbol}.
852      */
853     function symbol() public view virtual override returns (string memory) {
854         return _symbol;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-tokenURI}.
859      */
860     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
861         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
862 
863         string memory baseURI = _baseURI();
864         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
865     }
866 
867     /**
868      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
869      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
870      * by default, it can be overridden in child contracts.
871      */
872     function _baseURI() internal view virtual returns (string memory) {
873         return '';
874     }
875 
876     /**
877      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
878      */
879     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
880         // For branchless setting of the `nextInitialized` flag.
881         assembly {
882             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
883             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
884         }
885     }
886 
887     /**
888      * @dev See {IERC721-approve}.
889      */
890     function approve(address to, uint256 tokenId) public override {
891         address owner = ownerOf(tokenId);
892 
893         if (_msgSenderERC721A() != owner)
894             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
895                 revert ApprovalCallerNotOwnerNorApproved();
896             }
897 
898         _tokenApprovals[tokenId] = to;
899         emit Approval(owner, to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-getApproved}.
904      */
905     function getApproved(uint256 tokenId) public view override returns (address) {
906         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
907 
908         return _tokenApprovals[tokenId];
909     }
910 
911     /**
912      * @dev See {IERC721-setApprovalForAll}.
913      */
914     function setApprovalForAll(address operator, bool approved) public virtual override {
915         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
916 
917         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
918         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
919     }
920 
921     /**
922      * @dev See {IERC721-isApprovedForAll}.
923      */
924     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
925         return _operatorApprovals[owner][operator];
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public virtual override {
936         safeTransferFrom(from, to, tokenId, '');
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) public virtual override {
948         transferFrom(from, to, tokenId);
949         if (to.code.length != 0)
950             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
951                 revert TransferToNonERC721ReceiverImplementer();
952             }
953     }
954 
955     /**
956      * @dev Returns whether `tokenId` exists.
957      *
958      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
959      *
960      * Tokens start existing when they are minted (`_mint`),
961      */
962     function _exists(uint256 tokenId) internal view returns (bool) {
963         return
964             _startTokenId() <= tokenId &&
965             tokenId < _currentIndex && // If within bounds,
966             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
967     }
968 
969     /**
970      * @dev Equivalent to `_safeMint(to, quantity, '')`.
971      */
972     function _safeMint(address to, uint256 quantity) internal {
973         _safeMint(to, quantity, '');
974     }
975 
976     /**
977      * @dev Safely mints `quantity` tokens and transfers them to `to`.
978      *
979      * Requirements:
980      *
981      * - If `to` refers to a smart contract, it must implement
982      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
983      * - `quantity` must be greater than 0.
984      *
985      * See {_mint}.
986      *
987      * Emits a {Transfer} event for each mint.
988      */
989     function _safeMint(
990         address to,
991         uint256 quantity,
992         bytes memory _data
993     ) internal {
994         _mint(to, quantity);
995 
996         unchecked {
997             if (to.code.length != 0) {
998                 uint256 end = _currentIndex;
999                 uint256 index = end - quantity;
1000                 do {
1001                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1002                         revert TransferToNonERC721ReceiverImplementer();
1003                     }
1004                 } while (index < end);
1005                 // Reentrancy protection.
1006                 if (_currentIndex != end) revert();
1007             }
1008         }
1009     }
1010 
1011     /**
1012      * @dev Mints `quantity` tokens and transfers them to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `quantity` must be greater than 0.
1018      *
1019      * Emits a {Transfer} event for each mint.
1020      */
1021     function _mint(address to, uint256 quantity) internal {
1022         uint256 startTokenId = _currentIndex;
1023         if (to == address(0)) revert MintToZeroAddress();
1024         if (quantity == 0) revert MintZeroQuantity();
1025 
1026         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1027 
1028         // Overflows are incredibly unrealistic.
1029         // `balance` and `numberMinted` have a maximum limit of 2**64.
1030         // `tokenId` has a maximum limit of 2**256.
1031         unchecked {
1032             // Updates:
1033             // - `balance += quantity`.
1034             // - `numberMinted += quantity`.
1035             //
1036             // We can directly add to the `balance` and `numberMinted`.
1037             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1038 
1039             // Updates:
1040             // - `address` to the owner.
1041             // - `startTimestamp` to the timestamp of minting.
1042             // - `burned` to `false`.
1043             // - `nextInitialized` to `quantity == 1`.
1044             _packedOwnerships[startTokenId] = _packOwnershipData(
1045                 to,
1046                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1047             );
1048 
1049             uint256 tokenId = startTokenId;
1050             uint256 end = startTokenId + quantity;
1051             do {
1052                 emit Transfer(address(0), to, tokenId++);
1053             } while (tokenId < end);
1054 
1055             _currentIndex = end;
1056         }
1057         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1058     }
1059 
1060     /**
1061      * @dev Mints `quantity` tokens and transfers them to `to`.
1062      *
1063      * This function is intended for efficient minting only during contract creation.
1064      *
1065      * It emits only one {ConsecutiveTransfer} as defined in
1066      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1067      * instead of a sequence of {Transfer} event(s).
1068      *
1069      * Calling this function outside of contract creation WILL make your contract
1070      * non-compliant with the ERC721 standard.
1071      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1072      * {ConsecutiveTransfer} event is only permissible during contract creation.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `quantity` must be greater than 0.
1078      *
1079      * Emits a {ConsecutiveTransfer} event.
1080      */
1081     function _mintERC2309(address to, uint256 quantity) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1086 
1087         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1088 
1089         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1090         unchecked {
1091             // Updates:
1092             // - `balance += quantity`.
1093             // - `numberMinted += quantity`.
1094             //
1095             // We can directly add to the `balance` and `numberMinted`.
1096             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1097 
1098             // Updates:
1099             // - `address` to the owner.
1100             // - `startTimestamp` to the timestamp of minting.
1101             // - `burned` to `false`.
1102             // - `nextInitialized` to `quantity == 1`.
1103             _packedOwnerships[startTokenId] = _packOwnershipData(
1104                 to,
1105                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1106             );
1107 
1108             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1109 
1110             _currentIndex = startTokenId + quantity;
1111         }
1112         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1113     }
1114 
1115     /**
1116      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1117      */
1118     function _getApprovedAddress(uint256 tokenId)
1119         private
1120         view
1121         returns (uint256 approvedAddressSlot, address approvedAddress)
1122     {
1123         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1124         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1125         assembly {
1126             // Compute the slot.
1127             mstore(0x00, tokenId)
1128             mstore(0x20, tokenApprovalsPtr.slot)
1129             approvedAddressSlot := keccak256(0x00, 0x40)
1130             // Load the slot's value from storage.
1131             approvedAddress := sload(approvedAddressSlot)
1132         }
1133     }
1134 
1135     /**
1136      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1137      */
1138     function _isOwnerOrApproved(
1139         address approvedAddress,
1140         address from,
1141         address msgSender
1142     ) private pure returns (bool result) {
1143         assembly {
1144             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1145             from := and(from, BITMASK_ADDRESS)
1146             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1147             msgSender := and(msgSender, BITMASK_ADDRESS)
1148             // `msgSender == from || msgSender == approvedAddress`.
1149             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1150         }
1151     }
1152 
1153     /**
1154      * @dev Transfers `tokenId` from `from` to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must be owned by `from`.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function transferFrom(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) public virtual override {
1168         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1169 
1170         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1171 
1172         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1173 
1174         // The nested ifs save around 20+ gas over a compound boolean condition.
1175         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1176             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1177 
1178         if (to == address(0)) revert TransferToZeroAddress();
1179 
1180         _beforeTokenTransfers(from, to, tokenId, 1);
1181 
1182         // Clear approvals from the previous owner.
1183         assembly {
1184             if approvedAddress {
1185                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1186                 sstore(approvedAddressSlot, 0)
1187             }
1188         }
1189 
1190         // Underflow of the sender's balance is impossible because we check for
1191         // ownership above and the recipient's balance can't realistically overflow.
1192         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1193         unchecked {
1194             // We can directly increment and decrement the balances.
1195             --_packedAddressData[from]; // Updates: `balance -= 1`.
1196             ++_packedAddressData[to]; // Updates: `balance += 1`.
1197 
1198             // Updates:
1199             // - `address` to the next owner.
1200             // - `startTimestamp` to the timestamp of transfering.
1201             // - `burned` to `false`.
1202             // - `nextInitialized` to `true`.
1203             _packedOwnerships[tokenId] = _packOwnershipData(
1204                 to,
1205                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1206             );
1207 
1208             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1209             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1210                 uint256 nextTokenId = tokenId + 1;
1211                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1212                 if (_packedOwnerships[nextTokenId] == 0) {
1213                     // If the next slot is within bounds.
1214                     if (nextTokenId != _currentIndex) {
1215                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1216                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1217                     }
1218                 }
1219             }
1220         }
1221 
1222         emit Transfer(from, to, tokenId);
1223         _afterTokenTransfers(from, to, tokenId, 1);
1224     }
1225 
1226     /**
1227      * @dev Equivalent to `_burn(tokenId, false)`.
1228      */
1229     function _burn(uint256 tokenId) internal virtual {
1230         _burn(tokenId, false);
1231     }
1232 
1233     /**
1234      * @dev Destroys `tokenId`.
1235      * The approval is cleared when the token is burned.
1236      *
1237      * Requirements:
1238      *
1239      * - `tokenId` must exist.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1244         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1245 
1246         address from = address(uint160(prevOwnershipPacked));
1247 
1248         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1249 
1250         if (approvalCheck) {
1251             // The nested ifs save around 20+ gas over a compound boolean condition.
1252             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1253                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1254         }
1255 
1256         _beforeTokenTransfers(from, address(0), tokenId, 1);
1257 
1258         // Clear approvals from the previous owner.
1259         assembly {
1260             if approvedAddress {
1261                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1262                 sstore(approvedAddressSlot, 0)
1263             }
1264         }
1265 
1266         // Underflow of the sender's balance is impossible because we check for
1267         // ownership above and the recipient's balance can't realistically overflow.
1268         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1269         unchecked {
1270             // Updates:
1271             // - `balance -= 1`.
1272             // - `numberBurned += 1`.
1273             //
1274             // We can directly decrement the balance, and increment the number burned.
1275             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1276             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1277 
1278             // Updates:
1279             // - `address` to the last owner.
1280             // - `startTimestamp` to the timestamp of burning.
1281             // - `burned` to `true`.
1282             // - `nextInitialized` to `true`.
1283             _packedOwnerships[tokenId] = _packOwnershipData(
1284                 from,
1285                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1286             );
1287 
1288             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1289             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1290                 uint256 nextTokenId = tokenId + 1;
1291                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1292                 if (_packedOwnerships[nextTokenId] == 0) {
1293                     // If the next slot is within bounds.
1294                     if (nextTokenId != _currentIndex) {
1295                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1296                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1297                     }
1298                 }
1299             }
1300         }
1301 
1302         emit Transfer(from, address(0), tokenId);
1303         _afterTokenTransfers(from, address(0), tokenId, 1);
1304 
1305         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1306         unchecked {
1307             _burnCounter++;
1308         }
1309     }
1310 
1311     /**
1312      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1313      *
1314      * @param from address representing the previous owner of the given token ID
1315      * @param to target address that will receive the tokens
1316      * @param tokenId uint256 ID of the token to be transferred
1317      * @param _data bytes optional data to send along with the call
1318      * @return bool whether the call correctly returned the expected magic value
1319      */
1320     function _checkContractOnERC721Received(
1321         address from,
1322         address to,
1323         uint256 tokenId,
1324         bytes memory _data
1325     ) private returns (bool) {
1326         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1327             bytes4 retval
1328         ) {
1329             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1330         } catch (bytes memory reason) {
1331             if (reason.length == 0) {
1332                 revert TransferToNonERC721ReceiverImplementer();
1333             } else {
1334                 assembly {
1335                     revert(add(32, reason), mload(reason))
1336                 }
1337             }
1338         }
1339     }
1340 
1341     /**
1342      * @dev Directly sets the extra data for the ownership data `index`.
1343      */
1344     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1345         uint256 packed = _packedOwnerships[index];
1346         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1347         uint256 extraDataCasted;
1348         // Cast `extraData` with assembly to avoid redundant masking.
1349         assembly {
1350             extraDataCasted := extraData
1351         }
1352         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1353         _packedOwnerships[index] = packed;
1354     }
1355 
1356     /**
1357      * @dev Returns the next extra data for the packed ownership data.
1358      * The returned result is shifted into position.
1359      */
1360     function _nextExtraData(
1361         address from,
1362         address to,
1363         uint256 prevOwnershipPacked
1364     ) private view returns (uint256) {
1365         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1366         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1367     }
1368 
1369     /**
1370      * @dev Called during each token transfer to set the 24bit `extraData` field.
1371      * Intended to be overridden by the cosumer contract.
1372      *
1373      * `previousExtraData` - the value of `extraData` before transfer.
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` will be minted for `to`.
1380      * - When `to` is zero, `tokenId` will be burned by `from`.
1381      * - `from` and `to` are never both zero.
1382      */
1383     function _extraData(
1384         address from,
1385         address to,
1386         uint24 previousExtraData
1387     ) internal view virtual returns (uint24) {}
1388 
1389     /**
1390      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1391      * This includes minting.
1392      * And also called before burning one token.
1393      *
1394      * startTokenId - the first token id to be transferred
1395      * quantity - the amount to be transferred
1396      *
1397      * Calling conditions:
1398      *
1399      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1400      * transferred to `to`.
1401      * - When `from` is zero, `tokenId` will be minted for `to`.
1402      * - When `to` is zero, `tokenId` will be burned by `from`.
1403      * - `from` and `to` are never both zero.
1404      */
1405     function _beforeTokenTransfers(
1406         address from,
1407         address to,
1408         uint256 startTokenId,
1409         uint256 quantity
1410     ) internal virtual {}
1411 
1412     /**
1413      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1414      * This includes minting.
1415      * And also called after one token has been burned.
1416      *
1417      * startTokenId - the first token id to be transferred
1418      * quantity - the amount to be transferred
1419      *
1420      * Calling conditions:
1421      *
1422      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1423      * transferred to `to`.
1424      * - When `from` is zero, `tokenId` has been minted for `to`.
1425      * - When `to` is zero, `tokenId` has been burned by `from`.
1426      * - `from` and `to` are never both zero.
1427      */
1428     function _afterTokenTransfers(
1429         address from,
1430         address to,
1431         uint256 startTokenId,
1432         uint256 quantity
1433     ) internal virtual {}
1434 
1435     /**
1436      * @dev Returns the message sender (defaults to `msg.sender`).
1437      *
1438      * If you are writing GSN compatible contracts, you need to override this function.
1439      */
1440     function _msgSenderERC721A() internal view virtual returns (address) {
1441         return msg.sender;
1442     }
1443 
1444     /**
1445      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1446      */
1447     function _toString(uint256 value) internal pure returns (string memory ptr) {
1448         assembly {
1449             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1450             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1451             // We will need 1 32-byte word to store the length,
1452             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1453             ptr := add(mload(0x40), 128)
1454             // Update the free memory pointer to allocate.
1455             mstore(0x40, ptr)
1456 
1457             // Cache the end of the memory to calculate the length later.
1458             let end := ptr
1459 
1460             // We write the string from the rightmost digit to the leftmost digit.
1461             // The following is essentially a do-while loop that also handles the zero case.
1462             // Costs a bit more than early returning for the zero case,
1463             // but cheaper in terms of deployment and overall runtime costs.
1464             for {
1465                 // Initialize and perform the first pass without check.
1466                 let temp := value
1467                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1468                 ptr := sub(ptr, 1)
1469                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1470                 mstore8(ptr, add(48, mod(temp, 10)))
1471                 temp := div(temp, 10)
1472             } temp {
1473                 // Keep dividing `temp` until zero.
1474                 temp := div(temp, 10)
1475             } {
1476                 // Body of the for loop.
1477                 ptr := sub(ptr, 1)
1478                 mstore8(ptr, add(48, mod(temp, 10)))
1479             }
1480 
1481             let length := sub(end, ptr)
1482             // Move the pointer 32 bytes leftwards to make room for the length.
1483             ptr := sub(ptr, 32)
1484             // Store the length.
1485             mstore(ptr, length)
1486         }
1487     }
1488 }
1489 
1490 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1491 
1492 
1493 // ERC721A Contracts v4.1.0
1494 // Creator: Chiru Labs
1495 
1496 pragma solidity ^0.8.4;
1497 
1498 
1499 /**
1500  * @dev Interface of an ERC721AQueryable compliant contract.
1501  */
1502 interface IERC721AQueryable is IERC721A {
1503     /**
1504      * Invalid query range (`start` >= `stop`).
1505      */
1506     error InvalidQueryRange();
1507 
1508     /**
1509      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1510      *
1511      * If the `tokenId` is out of bounds:
1512      *   - `addr` = `address(0)`
1513      *   - `startTimestamp` = `0`
1514      *   - `burned` = `false`
1515      *
1516      * If the `tokenId` is burned:
1517      *   - `addr` = `<Address of owner before token was burned>`
1518      *   - `startTimestamp` = `<Timestamp when token was burned>`
1519      *   - `burned = `true`
1520      *
1521      * Otherwise:
1522      *   - `addr` = `<Address of owner>`
1523      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1524      *   - `burned = `false`
1525      */
1526     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1527 
1528     /**
1529      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1530      * See {ERC721AQueryable-explicitOwnershipOf}
1531      */
1532     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1533 
1534     /**
1535      * @dev Returns an array of token IDs owned by `owner`,
1536      * in the range [`start`, `stop`)
1537      * (i.e. `start <= tokenId < stop`).
1538      *
1539      * This function allows for tokens to be queried if the collection
1540      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1541      *
1542      * Requirements:
1543      *
1544      * - `start` < `stop`
1545      */
1546     function tokensOfOwnerIn(
1547         address owner,
1548         uint256 start,
1549         uint256 stop
1550     ) external view returns (uint256[] memory);
1551 
1552     /**
1553      * @dev Returns an array of token IDs owned by `owner`.
1554      *
1555      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1556      * It is meant to be called off-chain.
1557      *
1558      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1559      * multiple smaller scans if the collection is large enough to cause
1560      * an out-of-gas error (10K pfp collections should be fine).
1561      */
1562     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1563 }
1564 
1565 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1566 
1567 
1568 // ERC721A Contracts v4.1.0
1569 // Creator: Chiru Labs
1570 
1571 pragma solidity ^0.8.4;
1572 
1573 
1574 
1575 /**
1576  * @title ERC721A Queryable
1577  * @dev ERC721A subclass with convenience query functions.
1578  */
1579 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1580     /**
1581      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1582      *
1583      * If the `tokenId` is out of bounds:
1584      *   - `addr` = `address(0)`
1585      *   - `startTimestamp` = `0`
1586      *   - `burned` = `false`
1587      *   - `extraData` = `0`
1588      *
1589      * If the `tokenId` is burned:
1590      *   - `addr` = `<Address of owner before token was burned>`
1591      *   - `startTimestamp` = `<Timestamp when token was burned>`
1592      *   - `burned = `true`
1593      *   - `extraData` = `<Extra data when token was burned>`
1594      *
1595      * Otherwise:
1596      *   - `addr` = `<Address of owner>`
1597      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1598      *   - `burned = `false`
1599      *   - `extraData` = `<Extra data at start of ownership>`
1600      */
1601     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1602         TokenOwnership memory ownership;
1603         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1604             return ownership;
1605         }
1606         ownership = _ownershipAt(tokenId);
1607         if (ownership.burned) {
1608             return ownership;
1609         }
1610         return _ownershipOf(tokenId);
1611     }
1612 
1613     /**
1614      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1615      * See {ERC721AQueryable-explicitOwnershipOf}
1616      */
1617     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1618         unchecked {
1619             uint256 tokenIdsLength = tokenIds.length;
1620             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1621             for (uint256 i; i != tokenIdsLength; ++i) {
1622                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1623             }
1624             return ownerships;
1625         }
1626     }
1627 
1628     /**
1629      * @dev Returns an array of token IDs owned by `owner`,
1630      * in the range [`start`, `stop`)
1631      * (i.e. `start <= tokenId < stop`).
1632      *
1633      * This function allows for tokens to be queried if the collection
1634      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1635      *
1636      * Requirements:
1637      *
1638      * - `start` < `stop`
1639      */
1640     function tokensOfOwnerIn(
1641         address owner,
1642         uint256 start,
1643         uint256 stop
1644     ) external view override returns (uint256[] memory) {
1645         unchecked {
1646             if (start >= stop) revert InvalidQueryRange();
1647             uint256 tokenIdsIdx;
1648             uint256 stopLimit = _nextTokenId();
1649             // Set `start = max(start, _startTokenId())`.
1650             if (start < _startTokenId()) {
1651                 start = _startTokenId();
1652             }
1653             // Set `stop = min(stop, stopLimit)`.
1654             if (stop > stopLimit) {
1655                 stop = stopLimit;
1656             }
1657             uint256 tokenIdsMaxLength = balanceOf(owner);
1658             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1659             // to cater for cases where `balanceOf(owner)` is too big.
1660             if (start < stop) {
1661                 uint256 rangeLength = stop - start;
1662                 if (rangeLength < tokenIdsMaxLength) {
1663                     tokenIdsMaxLength = rangeLength;
1664                 }
1665             } else {
1666                 tokenIdsMaxLength = 0;
1667             }
1668             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1669             if (tokenIdsMaxLength == 0) {
1670                 return tokenIds;
1671             }
1672             // We need to call `explicitOwnershipOf(start)`,
1673             // because the slot at `start` may not be initialized.
1674             TokenOwnership memory ownership = explicitOwnershipOf(start);
1675             address currOwnershipAddr;
1676             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1677             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1678             if (!ownership.burned) {
1679                 currOwnershipAddr = ownership.addr;
1680             }
1681             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1682                 ownership = _ownershipAt(i);
1683                 if (ownership.burned) {
1684                     continue;
1685                 }
1686                 if (ownership.addr != address(0)) {
1687                     currOwnershipAddr = ownership.addr;
1688                 }
1689                 if (currOwnershipAddr == owner) {
1690                     tokenIds[tokenIdsIdx++] = i;
1691                 }
1692             }
1693             // Downsize the array to fit.
1694             assembly {
1695                 mstore(tokenIds, tokenIdsIdx)
1696             }
1697             return tokenIds;
1698         }
1699     }
1700 
1701     /**
1702      * @dev Returns an array of token IDs owned by `owner`.
1703      *
1704      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1705      * It is meant to be called off-chain.
1706      *
1707      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1708      * multiple smaller scans if the collection is large enough to cause
1709      * an out-of-gas error (10K pfp collections should be fine).
1710      */
1711     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1712         unchecked {
1713             uint256 tokenIdsIdx;
1714             address currOwnershipAddr;
1715             uint256 tokenIdsLength = balanceOf(owner);
1716             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1717             TokenOwnership memory ownership;
1718             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1719                 ownership = _ownershipAt(i);
1720                 if (ownership.burned) {
1721                     continue;
1722                 }
1723                 if (ownership.addr != address(0)) {
1724                     currOwnershipAddr = ownership.addr;
1725                 }
1726                 if (currOwnershipAddr == owner) {
1727                     tokenIds[tokenIdsIdx++] = i;
1728                 }
1729             }
1730             return tokenIds;
1731         }
1732     }
1733 }
1734 
1735 
1736 
1737 pragma solidity >=0.8.9 <0.9.0;
1738 
1739 contract HasbullaYachtClub is ERC721AQueryable, Ownable, ReentrancyGuard {
1740     using Strings for uint256;
1741 
1742     uint256 public maxSupply = 6969;
1743 	uint256 public Ownermint = 1;
1744     uint256 public maxPerAddress = 100;
1745 	uint256 public maxPerTX = 10;
1746     uint256 public cost = 0.002 ether;
1747 	mapping(address => bool) public freeMinted; 
1748 
1749     bool public paused = true;
1750 
1751 	string public uriPrefix = '';
1752     string public uriSuffix = '.json';
1753 	
1754   constructor(string memory baseURI) ERC721A("Hasbulla Yacht Club", "HBYC") {
1755       setUriPrefix(baseURI); 
1756       _safeMint(_msgSender(), Ownermint);
1757 
1758   }
1759 
1760   modifier callerIsUser() {
1761         require(tx.origin == msg.sender, "The caller is another contract");
1762         _;
1763   }
1764 
1765   function numberMinted(address owner) public view returns (uint256) {
1766         return _numberMinted(owner);
1767   }
1768 
1769   function Hasbullish (uint256 _mintAmount) public payable nonReentrant callerIsUser{
1770         require(!paused, 'The contract is paused!');
1771         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1772         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1773         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1774 	if (freeMinted[_msgSender()]){
1775         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1776   }
1777     else{
1778 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1779         freeMinted[_msgSender()] = true;
1780   }
1781 
1782     _safeMint(_msgSender(), _mintAmount);
1783   }
1784 
1785   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1786     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1787     string memory currentBaseURI = _baseURI();
1788     return bytes(currentBaseURI).length > 0
1789         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1790         : '';
1791   }
1792 
1793   function unpause() public onlyOwner {
1794     paused = !paused;
1795   }
1796 
1797   function setCost(uint256 _cost) public onlyOwner {
1798     cost = _cost;
1799   }
1800 
1801   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1802     maxPerTX = _maxPerTX;
1803   }
1804 
1805   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1806     uriPrefix = _uriPrefix;
1807   }
1808  
1809   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1810     uriSuffix = _uriSuffix;
1811   }
1812 
1813   function withdraw() external onlyOwner {
1814         payable(msg.sender).transfer(address(this).balance);
1815   }
1816 
1817   function _startTokenId() internal view virtual override returns (uint256) {
1818     return 1;
1819   }
1820 
1821   function _baseURI() internal view virtual override returns (string memory) {
1822     return uriPrefix;
1823   }
1824 }