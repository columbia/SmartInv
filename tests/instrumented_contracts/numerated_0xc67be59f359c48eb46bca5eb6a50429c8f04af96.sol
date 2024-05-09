1 //SPDX-License-Identifier: MIT
2 
3 //`7MM"""Mq.`7MM"""Mq.   .g8""8q.     `7MMF'`7MM"""YMM    .g8"""bgd MMP""MM""YMM
4 //  MM   `MM. MM   `MM..dP'    `YM.     MM    MM    `7  .dP'     `M P'   MM   `7
5 //  MM   ,M9  MM   ,M9 dM'      `MM     MM    MM   d    dM'       `      MM
6 //  MMmmdM9   MMmmdM9  MM        MM     MM    MMmmMM    MM               MM
7 //  MM        MM   `Mb.`Mb.    ,dP'(O)  MM    MM     ,M `Mb.     ,'      MM
8 //.JMML.    .JMML. .JMM. `"bmmd"'   Ymmm9   .JMMmmmmMMM   `"bmmmd'     .JMML.
9 
10 //`7MM"""Yb. `7MMF'   `7MF'`7MM"""Yb. `7MM"""YMM   .M"""bgd
11 //  MM    `Yb. MM       M    MM    `Yb. MM    `7  ,MI    "Y
12 //  MM     `Mb MM       M    MM     `Mb MM   d    `MMb.
13 //  MM      MM MM       M    MM      MM MMmmMM      `YMMNq.
14 //  MM     ,MP MM       M    MM     ,MP MM   Y  , .     `MM
15 //  MM    ,dP' YM.     ,M    MM    ,dP' MM     ,M Mb     dM 
16 //.JMMmmmdP'    `bmmmmd"'  .JMMmmmdP' .JMMmmmmMMM P"Ybmmd"
17   
18 
19 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
20 
21 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Contract module that helps prevent reentrant calls to a function.
27  *
28  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
29  * available, which can be applied to functions to make sure there are no nested
30  * (reentrant) calls to them.
31  *
32  * Note that because there is a single `nonReentrant` guard, functions marked as
33  * `nonReentrant` may not call one another. This can be worked around by making
34  * those functions `private`, and then adding `external` `nonReentrant` entry
35  * points to them.
36  *
37  * TIP: If you would like to learn more about reentrancy and alternative ways
38  * to protect against it, check out our blog post
39  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
40  */
41 abstract contract ReentrancyGuard {
42     // Booleans are more expensive than uint256 or any type that takes up a full
43     // word because each write operation emits an extra SLOAD to first read the
44     // slot's contents, replace the bits taken up by the boolean, and then write
45     // back. This is the compiler's defense against contract upgrades and
46     // pointer aliasing, and it cannot be disabled.
47 
48     // The values being non-zero value makes deployment a bit more expensive,
49     // but in exchange the refund on every call to nonReentrant will be lower in
50     // amount. Since refunds are capped to a percentage of the total
51     // transaction's gas, it is best to keep them low in cases like this one, to
52     // increase the likelihood of the full refund coming into effect.
53     uint256 private constant _NOT_ENTERED = 1;
54     uint256 private constant _ENTERED = 2;
55 
56     uint256 private _status;
57 
58     constructor() {
59         _status = _NOT_ENTERED;
60     }
61 
62     /**
63      * @dev Prevents a contract from calling itself, directly or indirectly.
64      * Calling a `nonReentrant` function from another `nonReentrant`
65      * function is not supported. It is possible to prevent this from happening
66      * by making the `nonReentrant` function external, and making it call a
67      * `private` function that does the actual work.
68      */
69     modifier nonReentrant() {
70         // On the first call to nonReentrant, _notEntered will be true
71         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
72 
73         // Any calls to nonReentrant after this point will fail
74         _status = _ENTERED;
75 
76         _;
77 
78         // By storing the original value once again, a refund is triggered (see
79         // https://eips.ethereum.org/EIPS/eip-2200)
80         _status = _NOT_ENTERED;
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Strings.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev String operations.
93  */
94 library Strings {
95     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
99      */
100     function toString(uint256 value) internal pure returns (string memory) {
101         // Inspired by OraclizeAPI's implementation - MIT licence
102         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
103 
104         if (value == 0) {
105             return "0";
106         }
107         uint256 temp = value;
108         uint256 digits;
109         while (temp != 0) {
110             digits++;
111             temp /= 10;
112         }
113         bytes memory buffer = new bytes(digits);
114         while (value != 0) {
115             digits -= 1;
116             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
117             value /= 10;
118         }
119         return string(buffer);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
124      */
125     function toHexString(uint256 value) internal pure returns (string memory) {
126         if (value == 0) {
127             return "0x00";
128         }
129         uint256 temp = value;
130         uint256 length = 0;
131         while (temp != 0) {
132             length++;
133             temp >>= 8;
134         }
135         return toHexString(value, length);
136     }
137 
138     /**
139      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
140      */
141     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
142         bytes memory buffer = new bytes(2 * length + 2);
143         buffer[0] = "0";
144         buffer[1] = "x";
145         for (uint256 i = 2 * length + 1; i > 1; --i) {
146             buffer[i] = _HEX_SYMBOLS[value & 0xf];
147             value >>= 4;
148         }
149         require(value == 0, "Strings: hex length insufficient");
150         return string(buffer);
151     }
152 }
153 
154 // File: @openzeppelin/contracts/utils/Context.sol
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 /**
162  * @dev Provides information about the current execution context, including the
163  * sender of the transaction and its data. While these are generally available
164  * via msg.sender and msg.data, they should not be accessed in such a direct
165  * manner, since when dealing with meta-transactions the account sending and
166  * paying for execution may not be the actual sender (as far as an application
167  * is concerned).
168  *
169  * This contract is only required for intermediate, library-like contracts.
170  */
171 abstract contract Context {
172     function _msgSender() internal view virtual returns (address) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view virtual returns (bytes calldata) {
177         return msg.data;
178     }
179 }
180 
181 // File: @openzeppelin/contracts/access/Ownable.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 
189 /**
190  * @dev Contract module which provides a basic access control mechanism, where
191  * there is an account (an owner) that can be granted exclusive access to
192  * specific functions.
193  *
194  * By default, the owner account will be the one that deploys the contract. This
195  * can later be changed with {transferOwnership}.
196  *
197  * This module is used through inheritance. It will make available the modifier
198  * `onlyOwner`, which can be applied to your functions to restrict their use to
199  * the owner.
200  */
201 abstract contract Ownable is Context {
202     address private _owner;
203 
204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205 
206     /**
207      * @dev Initializes the contract setting the deployer as the initial owner.
208      */
209     constructor() {
210         _transferOwnership(_msgSender());
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
221      * @dev Throws if called by any account other than the owner.
222      */
223     modifier onlyOwner() {
224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
225         _;
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
1491 // File: contracts/ProjectDudes.sol
1492 // The following code was written by MrMoon.
1493 // Unless it doesn't work, then I have no idea who wrote it.
1494 
1495 pragma solidity ^0.8.4;
1496 
1497 contract ProjectDudes is ERC721A, Ownable, ReentrancyGuard {
1498     using Strings for uint256;
1499     address private constant _creator1 = 0xF5C57Ebd20741492C17bE7BFB56b52DA0026F747;
1500     address private constant _creator2 = 0x914912F14fE6FD17Ac83E672c0E5EB8A29cd8Fd1;
1501     address private constant _creator3 = 0xd5ea12B40648168394B4554EC7572d65465098B4;
1502     
1503     string public constant needsHug = "(>0.0)><(0.0<)";   
1504     uint256 public MAX_SUPPLY = 10000;
1505     uint256 public FREE_SUPPLY = 2000;
1506     uint256 public publicPrice = 0.08 ether;
1507     uint256 private MINT_PER_FREE_TX = 2;
1508     uint256 private maxFreePerWallet = 2;
1509     
1510     uint256 private MAX_MINTS_PER_TX = 10;
1511     uint256 constant public limitAmountPerWallet = 20;
1512 
1513     string public constant missingIngredient = "TheSauce";
1514     string public uriPrefix = '';
1515     string public uriSuffix = '';
1516     string public notRevealedUri = "ipfs://QmRh8YrvjF4fTg1R83yPcBSufrNMYPmWHFfgNbC3AQ7wVy/";
1517 
1518     bool public paused = true;
1519     bool public revealed = false;
1520 
1521     mapping(address => bool) public userMintedFree;
1522     mapping(address => uint256) public mintedWallets;
1523 
1524     constructor() ERC721A("Project Dudes", "DUDES") {
1525         _mint(msg.sender, 96);
1526     }
1527 
1528     modifier callerIsUser() {
1529         require(!paused, "Contract is paused");
1530         require(tx.origin == msg.sender, "No contract minting");
1531         _;
1532     }
1533    
1534     function _startTokenId() internal view virtual override returns (uint256) {
1535         return 1;
1536     }
1537 
1538     function freeMint(uint256 quantity)        
1539         external
1540         payable
1541         nonReentrant
1542         callerIsUser
1543     {
1544 
1545         require(msg.value == 0, "This phase is free");
1546         require(quantity <= 2, "Only 2 free");
1547         require(mintedWallets[msg.sender] + quantity <= maxFreePerWallet, "mints per wallet exceeded");
1548         
1549         if (totalSupply() + MINT_PER_FREE_TX > (MAX_SUPPLY - FREE_SUPPLY)) revert("Amount exceeds supply");
1550         if (quantity > MAX_MINTS_PER_TX) revert("Amount exceeds transaction limit");
1551         
1552         mintedWallets[msg.sender] += quantity;
1553 
1554         _safeMint(msg.sender, MINT_PER_FREE_TX);
1555     }
1556     // Anyone Got 5$?
1557     function saleMint(uint256 quantity)
1558         external
1559         payable
1560         nonReentrant
1561         callerIsUser
1562     {   
1563         if (quantity > MAX_MINTS_PER_TX)
1564             revert("Amount exceeds transaction limit");
1565         if (totalSupply() + quantity > (MAX_SUPPLY - FREE_SUPPLY))
1566             revert("Amount exceeds supply");
1567         if (getPublicPrice() * quantity > msg.value)
1568             revert("Insufficient payment");
1569         
1570 
1571         _safeMint(msg.sender, quantity);
1572     }
1573      
1574     function walletOfOwner(address _owner) public view returns (uint256[] memory)
1575     {
1576         uint256 ownerTokenCount = balanceOf(_owner);
1577         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1578         uint256 currentTokenId = 1;
1579         uint256 ownedTokenIndex = 0;
1580 
1581         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1582             address currentTokenOwner = ownerOf(currentTokenId);
1583 
1584             if (currentTokenOwner == _owner) {
1585                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1586 
1587                 ownedTokenIndex++;
1588             }
1589 
1590         currentTokenId++;
1591         }
1592 
1593         return ownedTokenIds;
1594     }
1595     
1596     function _baseURI() internal view virtual override returns (string memory) {
1597         return uriPrefix;
1598     }
1599     
1600     function numberMinted(address owner) public view returns (uint256) {
1601         return _numberMinted(owner);
1602     }
1603     //Drip. Drip. Drip.
1604     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1605         uriPrefix = _uriPrefix;
1606     }
1607 
1608     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1609         uriSuffix = _uriSuffix;
1610     }
1611 
1612     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
1613         notRevealedUri = _notRevealedURI;
1614     }
1615     
1616     function reveal() external onlyOwner {
1617         revealed = !revealed;
1618     }
1619 
1620     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1621         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1622 
1623     if (revealed == false) {
1624         return notRevealedUri;
1625     }
1626 
1627     string memory currentBaseURI = _baseURI();
1628     return bytes(currentBaseURI).length > 0
1629         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1630         : '';
1631     }
1632 
1633     function setPaused(bool _state) public onlyOwner {
1634         paused = _state;
1635     }
1636     
1637     function setPublicPrice(uint256 price) external onlyOwner {
1638         publicPrice = price;
1639     }
1640     
1641     function getPublicPrice() public view returns (uint256) {
1642         return publicPrice;
1643     }
1644     
1645     function setMaxMintPerTx(uint256 maxMint) external onlyOwner {
1646         MAX_MINTS_PER_TX = maxMint;
1647     }
1648 
1649     function mintToUser(uint256 quantity, address receiver) public onlyOwner callerIsUser {
1650         _safeMint(receiver, quantity);
1651     }
1652 
1653     function withdrawAll() external onlyOwner {
1654         uint256 amountToCreator2 = (address(this).balance * 140) / 1000; // 14%
1655         uint256 amountToCreator3 = (address(this).balance * 190) / 1000; // 19%
1656 
1657         withdraw(_creator2, amountToCreator2);
1658         withdraw(_creator3, amountToCreator3);
1659 
1660         uint256 amountToCreator1 = address(this).balance; // ~85%
1661         withdraw(_creator1, amountToCreator1);
1662     }
1663 
1664     function withdraw(address account, uint256 amount) internal {
1665         (bool os, ) = payable(account).call{value: amount}("");
1666         require(os, "Failed to send ether");
1667     }
1668 
1669 }
1670     // When I wrote this, only God and I understood what I was doing.
1671     // Now, God only knows.
1672     // :P