1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4          ___     ___                 _             
5   /\  /\/   \   / _ \___ _ __  _   _(_)_ __   ___  
6  / /_/ / /\ /  / /_\/ _ \ '_ \| | | | | '_ \ / _ \ 
7 / __  / /_//  / /_\\  __/ | | | |_| | | | | |  __/ 
8 \/ /_/___,'   \____/\___|_| |_|\__,_|_|_| |_|\___| 
9                                                    
10                  _                _                
11  /\ /\ _ __   __| | ___  __ _  __| |               
12 / / \ \ '_ \ / _` |/ _ \/ _` |/ _` |               
13 \ \_/ / | | | (_| |  __/ (_| | (_| |               
14  \___/|_| |_|\__,_|\___|\__,_|\__,_|               
15                                                                                                                                                                                                                                                                                                                                                                                                                             
16 */
17 
18 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev Contract module that helps prevent reentrant calls to a function.
24  *
25  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
26  * available, which can be applied to functions to make sure there are no nested
27  * (reentrant) calls to them.
28  *
29  * Note that because there is a single `nonReentrant` guard, functions marked as
30  * `nonReentrant` may not call one another. This can be worked around by making
31  * those functions `private`, and then adding `external` `nonReentrant` entry
32  * points to them.
33  *
34  * TIP: If you would like to learn more about reentrancy and alternative ways
35  * to protect against it, check out our blog post
36  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
37  */
38 abstract contract ReentrancyGuard {
39     // Booleans are more expensive than uint256 or any type that takes up a full
40     // word because each write operation emits an extra SLOAD to first read the
41     // slot's contents, replace the bits taken up by the boolean, and then write
42     // back. This is the compiler's defense against contract upgrades and
43     // pointer aliasing, and it cannot be disabled.
44 
45     // The values being non-zero value makes deployment a bit more expensive,
46     // but in exchange the refund on every call to nonReentrant will be lower in
47     // amount. Since refunds are capped to a percentage of the total
48     // transaction's gas, it is best to keep them low in cases like this one, to
49     // increase the likelihood of the full refund coming into effect.
50     uint256 private constant _NOT_ENTERED = 1;
51     uint256 private constant _ENTERED = 2;
52 
53     uint256 private _status;
54 
55     constructor() {
56         _status = _NOT_ENTERED;
57     }
58 
59     /**
60      * @dev Prevents a contract from calling itself, directly or indirectly.
61      * Calling a `nonReentrant` function from another `nonReentrant`
62      * function is not supported. It is possible to prevent this from happening
63      * by making the `nonReentrant` function external, and making it call a
64      * `private` function that does the actual work.
65      */
66     modifier nonReentrant() {
67         // On the first call to nonReentrant, _notEntered will be true
68         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
69 
70         // Any calls to nonReentrant after this point will fail
71         _status = _ENTERED;
72 
73         _;
74 
75         // By storing the original value once again, a refund is triggered (see
76         // https://eips.ethereum.org/EIPS/eip-2200)
77         _status = _NOT_ENTERED;
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Strings.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev String operations.
90  */
91 library Strings {
92     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
93     uint8 private constant _ADDRESS_LENGTH = 20;
94 
95     /**
96      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
97      */
98     function toString(uint256 value) internal pure returns (string memory) {
99         // Inspired by OraclizeAPI's implementation - MIT licence
100         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
101 
102         if (value == 0) {
103             return "0";
104         }
105         uint256 temp = value;
106         uint256 digits;
107         while (temp != 0) {
108             digits++;
109             temp /= 10;
110         }
111         bytes memory buffer = new bytes(digits);
112         while (value != 0) {
113             digits -= 1;
114             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
115             value /= 10;
116         }
117         return string(buffer);
118     }
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
122      */
123     function toHexString(uint256 value) internal pure returns (string memory) {
124         if (value == 0) {
125             return "0x00";
126         }
127         uint256 temp = value;
128         uint256 length = 0;
129         while (temp != 0) {
130             length++;
131             temp >>= 8;
132         }
133         return toHexString(value, length);
134     }
135 
136     /**
137      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
138      */
139     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
140         bytes memory buffer = new bytes(2 * length + 2);
141         buffer[0] = "0";
142         buffer[1] = "x";
143         for (uint256 i = 2 * length + 1; i > 1; --i) {
144             buffer[i] = _HEX_SYMBOLS[value & 0xf];
145             value >>= 4;
146         }
147         require(value == 0, "Strings: hex length insufficient");
148         return string(buffer);
149     }
150 
151     /**
152      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
153      */
154     function toHexString(address addr) internal pure returns (string memory) {
155         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
156     }
157 }
158 
159 
160 // File: @openzeppelin/contracts/utils/Context.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 /**
168  * @dev Provides information about the current execution context, including the
169  * sender of the transaction and its data. While these are generally available
170  * via msg.sender and msg.data, they should not be accessed in such a direct
171  * manner, since when dealing with meta-transactions the account sending and
172  * paying for execution may not be the actual sender (as far as an application
173  * is concerned).
174  *
175  * This contract is only required for intermediate, library-like contracts.
176  */
177 abstract contract Context {
178     function _msgSender() internal view virtual returns (address) {
179         return msg.sender;
180     }
181 
182     function _msgData() internal view virtual returns (bytes calldata) {
183         return msg.data;
184     }
185 }
186 
187 // File: @openzeppelin/contracts/access/Ownable.sol
188 
189 
190 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 
195 /**
196  * @dev Contract module which provides a basic access control mechanism, where
197  * there is an account (an owner) that can be granted exclusive access to
198  * specific functions.
199  *
200  * By default, the owner account will be the one that deploys the contract. This
201  * can later be changed with {transferOwnership}.
202  *
203  * This module is used through inheritance. It will make available the modifier
204  * `onlyOwner`, which can be applied to your functions to restrict their use to
205  * the owner.
206  */
207 abstract contract Ownable is Context {
208     address private _owner;
209 
210     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
211 
212     /**
213      * @dev Initializes the contract setting the deployer as the initial owner.
214      */
215     constructor() {
216         _transferOwnership(_msgSender());
217     }
218 
219     /**
220      * @dev Throws if called by any account other than the owner.
221      */
222     modifier onlyOwner() {
223         _checkOwner();
224         _;
225     }
226 
227     /**
228      * @dev Returns the address of the current owner.
229      */
230     function owner() public view virtual returns (address) {
231         return _owner;
232     }
233 
234     /**
235      * @dev Throws if the sender is not the owner.
236      */
237     function _checkOwner() internal view virtual {
238         require(owner() == _msgSender(), "Ownable: caller is not the owner");
239     }
240 
241     /**
242      * @dev Leaves the contract without owner. It will not be possible to call
243      * `onlyOwner` functions anymore. Can only be called by the current owner.
244      *
245      * NOTE: Renouncing ownership will leave the contract without an owner,
246      * thereby removing any functionality that is only available to the owner.
247      */
248     function renounceOwnership() public virtual onlyOwner {
249         _transferOwnership(address(0));
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      * Can only be called by the current owner.
255      */
256     function transferOwnership(address newOwner) public virtual onlyOwner {
257         require(newOwner != address(0), "Ownable: new owner is the zero address");
258         _transferOwnership(newOwner);
259     }
260 
261     /**
262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
263      * Internal function without access restriction.
264      */
265     function _transferOwnership(address newOwner) internal virtual {
266         address oldOwner = _owner;
267         _owner = newOwner;
268         emit OwnershipTransferred(oldOwner, newOwner);
269     }
270 }
271 
272 // File: erc721a/contracts/IERC721A.sol
273 
274 
275 // ERC721A Contracts v4.1.0
276 // Creator: Chiru Labs
277 
278 pragma solidity ^0.8.4;
279 
280 /**
281  * @dev Interface of an ERC721A compliant contract.
282  */
283 interface IERC721A {
284     /**
285      * The caller must own the token or be an approved operator.
286      */
287     error ApprovalCallerNotOwnerNorApproved();
288 
289     /**
290      * The token does not exist.
291      */
292     error ApprovalQueryForNonexistentToken();
293 
294     /**
295      * The caller cannot approve to their own address.
296      */
297     error ApproveToCaller();
298 
299     /**
300      * Cannot query the balance for the zero address.
301      */
302     error BalanceQueryForZeroAddress();
303 
304     /**
305      * Cannot mint to the zero address.
306      */
307     error MintToZeroAddress();
308 
309     /**
310      * The quantity of tokens minted must be more than zero.
311      */
312     error MintZeroQuantity();
313 
314     /**
315      * The token does not exist.
316      */
317     error OwnerQueryForNonexistentToken();
318 
319     /**
320      * The caller must own the token or be an approved operator.
321      */
322     error TransferCallerNotOwnerNorApproved();
323 
324     /**
325      * The token must be owned by `from`.
326      */
327     error TransferFromIncorrectOwner();
328 
329     /**
330      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
331      */
332     error TransferToNonERC721ReceiverImplementer();
333 
334     /**
335      * Cannot transfer to the zero address.
336      */
337     error TransferToZeroAddress();
338 
339     /**
340      * The token does not exist.
341      */
342     error URIQueryForNonexistentToken();
343 
344     /**
345      * The `quantity` minted with ERC2309 exceeds the safety limit.
346      */
347     error MintERC2309QuantityExceedsLimit();
348 
349     /**
350      * The `extraData` cannot be set on an unintialized ownership slot.
351      */
352     error OwnershipNotInitializedForExtraData();
353 
354     struct TokenOwnership {
355         // The address of the owner.
356         address addr;
357         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
358         uint64 startTimestamp;
359         // Whether the token has been burned.
360         bool burned;
361         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
362         uint24 extraData;
363     }
364 
365     /**
366      * @dev Returns the total amount of tokens stored by the contract.
367      *
368      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
369      */
370     function totalSupply() external view returns (uint256);
371 
372     // ==============================
373     //            IERC165
374     // ==============================
375 
376     /**
377      * @dev Returns true if this contract implements the interface defined by
378      * `interfaceId`. See the corresponding
379      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
380      * to learn more about how these ids are created.
381      *
382      * This function call must use less than 30 000 gas.
383      */
384     function supportsInterface(bytes4 interfaceId) external view returns (bool);
385 
386     // ==============================
387     //            IERC721
388     // ==============================
389 
390     /**
391      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
392      */
393     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
394 
395     /**
396      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
397      */
398     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
399 
400     /**
401      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
402      */
403     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
404 
405     /**
406      * @dev Returns the number of tokens in ``owner``'s account.
407      */
408     function balanceOf(address owner) external view returns (uint256 balance);
409 
410     /**
411      * @dev Returns the owner of the `tokenId` token.
412      *
413      * Requirements:
414      *
415      * - `tokenId` must exist.
416      */
417     function ownerOf(uint256 tokenId) external view returns (address owner);
418 
419     /**
420      * @dev Safely transfers `tokenId` token from `from` to `to`.
421      *
422      * Requirements:
423      *
424      * - `from` cannot be the zero address.
425      * - `to` cannot be the zero address.
426      * - `tokenId` token must exist and be owned by `from`.
427      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
428      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
429      *
430      * Emits a {Transfer} event.
431      */
432     function safeTransferFrom(
433         address from,
434         address to,
435         uint256 tokenId,
436         bytes calldata data
437     ) external;
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
441      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
442      *
443      * Requirements:
444      *
445      * - `from` cannot be the zero address.
446      * - `to` cannot be the zero address.
447      * - `tokenId` token must exist and be owned by `from`.
448      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
449      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
450      *
451      * Emits a {Transfer} event.
452      */
453     function safeTransferFrom(
454         address from,
455         address to,
456         uint256 tokenId
457     ) external;
458 
459     /**
460      * @dev Transfers `tokenId` token from `from` to `to`.
461      *
462      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
463      *
464      * Requirements:
465      *
466      * - `from` cannot be the zero address.
467      * - `to` cannot be the zero address.
468      * - `tokenId` token must be owned by `from`.
469      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
470      *
471      * Emits a {Transfer} event.
472      */
473     function transferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external;
478 
479     /**
480      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
481      * The approval is cleared when the token is transferred.
482      *
483      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
484      *
485      * Requirements:
486      *
487      * - The caller must own the token or be an approved operator.
488      * - `tokenId` must exist.
489      *
490      * Emits an {Approval} event.
491      */
492     function approve(address to, uint256 tokenId) external;
493 
494     /**
495      * @dev Approve or remove `operator` as an operator for the caller.
496      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
497      *
498      * Requirements:
499      *
500      * - The `operator` cannot be the caller.
501      *
502      * Emits an {ApprovalForAll} event.
503      */
504     function setApprovalForAll(address operator, bool _approved) external;
505 
506     /**
507      * @dev Returns the account approved for `tokenId` token.
508      *
509      * Requirements:
510      *
511      * - `tokenId` must exist.
512      */
513     function getApproved(uint256 tokenId) external view returns (address operator);
514 
515     /**
516      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
517      *
518      * See {setApprovalForAll}
519      */
520     function isApprovedForAll(address owner, address operator) external view returns (bool);
521 
522     // ==============================
523     //        IERC721Metadata
524     // ==============================
525 
526     /**
527      * @dev Returns the token collection name.
528      */
529     function name() external view returns (string memory);
530 
531     /**
532      * @dev Returns the token collection symbol.
533      */
534     function symbol() external view returns (string memory);
535 
536     /**
537      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
538      */
539     function tokenURI(uint256 tokenId) external view returns (string memory);
540 
541     // ==============================
542     //            IERC2309
543     // ==============================
544 
545     /**
546      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
547      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
548      */
549     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
550 }
551 
552 // File: erc721a/contracts/ERC721A.sol
553 
554 
555 // ERC721A Contracts v4.1.0
556 // Creator: Chiru Labs
557 
558 pragma solidity ^0.8.4;
559 
560 
561 /**
562  * @dev ERC721 token receiver interface.
563  */
564 interface ERC721A__IERC721Receiver {
565     function onERC721Received(
566         address operator,
567         address from,
568         uint256 tokenId,
569         bytes calldata data
570     ) external returns (bytes4);
571 }
572 
573 /**
574  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
575  * including the Metadata extension. Built to optimize for lower gas during batch mints.
576  *
577  * Assumes serials are sequentially minted starting at `_startTokenId()`
578  * (defaults to 0, e.g. 0, 1, 2, 3..).
579  *
580  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
581  *
582  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
583  */
584 contract ERC721A is IERC721A {
585     // Mask of an entry in packed address data.
586     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
587 
588     // The bit position of `numberMinted` in packed address data.
589     uint256 private constant BITPOS_NUMBER_MINTED = 64;
590 
591     // The bit position of `numberBurned` in packed address data.
592     uint256 private constant BITPOS_NUMBER_BURNED = 128;
593 
594     // The bit position of `aux` in packed address data.
595     uint256 private constant BITPOS_AUX = 192;
596 
597     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
598     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
599 
600     // The bit position of `startTimestamp` in packed ownership.
601     uint256 private constant BITPOS_START_TIMESTAMP = 160;
602 
603     // The bit mask of the `burned` bit in packed ownership.
604     uint256 private constant BITMASK_BURNED = 1 << 224;
605 
606     // The bit position of the `nextInitialized` bit in packed ownership.
607     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
608 
609     // The bit mask of the `nextInitialized` bit in packed ownership.
610     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
611 
612     // The bit position of `extraData` in packed ownership.
613     uint256 private constant BITPOS_EXTRA_DATA = 232;
614 
615     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
616     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
617 
618     // The mask of the lower 160 bits for addresses.
619     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
620 
621     // The maximum `quantity` that can be minted with `_mintERC2309`.
622     // This limit is to prevent overflows on the address data entries.
623     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
624     // is required to cause an overflow, which is unrealistic.
625     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
626 
627     // The tokenId of the next token to be minted.
628     uint256 private _currentIndex;
629 
630     // The number of tokens burned.
631     uint256 private _burnCounter;
632 
633     // Token name
634     string private _name;
635 
636     // Token symbol
637     string private _symbol;
638 
639     // Mapping from token ID to ownership details
640     // An empty struct value does not necessarily mean the token is unowned.
641     // See `_packedOwnershipOf` implementation for details.
642     //
643     // Bits Layout:
644     // - [0..159]   `addr`
645     // - [160..223] `startTimestamp`
646     // - [224]      `burned`
647     // - [225]      `nextInitialized`
648     // - [232..255] `extraData`
649     mapping(uint256 => uint256) private _packedOwnerships;
650 
651     // Mapping owner address to address data.
652     //
653     // Bits Layout:
654     // - [0..63]    `balance`
655     // - [64..127]  `numberMinted`
656     // - [128..191] `numberBurned`
657     // - [192..255] `aux`
658     mapping(address => uint256) private _packedAddressData;
659 
660     // Mapping from token ID to approved address.
661     mapping(uint256 => address) private _tokenApprovals;
662 
663     // Mapping from owner to operator approvals
664     mapping(address => mapping(address => bool)) private _operatorApprovals;
665 
666     constructor(string memory name_, string memory symbol_) {
667         _name = name_;
668         _symbol = symbol_;
669         _currentIndex = _startTokenId();
670     }
671 
672     /**
673      * @dev Returns the starting token ID.
674      * To change the starting token ID, please override this function.
675      */
676     function _startTokenId() internal view virtual returns (uint256) {
677         return 0;
678     }
679 
680     /**
681      * @dev Returns the next token ID to be minted.
682      */
683     function _nextTokenId() internal view returns (uint256) {
684         return _currentIndex;
685     }
686 
687     /**
688      * @dev Returns the total number of tokens in existence.
689      * Burned tokens will reduce the count.
690      * To get the total number of tokens minted, please see `_totalMinted`.
691      */
692     function totalSupply() public view override returns (uint256) {
693         // Counter underflow is impossible as _burnCounter cannot be incremented
694         // more than `_currentIndex - _startTokenId()` times.
695         unchecked {
696             return _currentIndex - _burnCounter - _startTokenId();
697         }
698     }
699 
700     /**
701      * @dev Returns the total amount of tokens minted in the contract.
702      */
703     function _totalMinted() internal view returns (uint256) {
704         // Counter underflow is impossible as _currentIndex does not decrement,
705         // and it is initialized to `_startTokenId()`
706         unchecked {
707             return _currentIndex - _startTokenId();
708         }
709     }
710 
711     /**
712      * @dev Returns the total number of tokens burned.
713      */
714     function _totalBurned() internal view returns (uint256) {
715         return _burnCounter;
716     }
717 
718     /**
719      * @dev See {IERC165-supportsInterface}.
720      */
721     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
722         // The interface IDs are constants representing the first 4 bytes of the XOR of
723         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
724         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
725         return
726             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
727             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
728             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
729     }
730 
731     /**
732      * @dev See {IERC721-balanceOf}.
733      */
734     function balanceOf(address owner) public view override returns (uint256) {
735         if (owner == address(0)) revert BalanceQueryForZeroAddress();
736         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
737     }
738 
739     /**
740      * Returns the number of tokens minted by `owner`.
741      */
742     function _numberMinted(address owner) internal view returns (uint256) {
743         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
744     }
745 
746     /**
747      * Returns the number of tokens burned by or on behalf of `owner`.
748      */
749     function _numberBurned(address owner) internal view returns (uint256) {
750         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
751     }
752 
753     /**
754      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
755      */
756     function _getAux(address owner) internal view returns (uint64) {
757         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
758     }
759 
760     /**
761      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
762      * If there are multiple variables, please pack them into a uint64.
763      */
764     function _setAux(address owner, uint64 aux) internal {
765         uint256 packed = _packedAddressData[owner];
766         uint256 auxCasted;
767         // Cast `aux` with assembly to avoid redundant masking.
768         assembly {
769             auxCasted := aux
770         }
771         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
772         _packedAddressData[owner] = packed;
773     }
774 
775     /**
776      * Returns the packed ownership data of `tokenId`.
777      */
778     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
779         uint256 curr = tokenId;
780 
781         unchecked {
782             if (_startTokenId() <= curr)
783                 if (curr < _currentIndex) {
784                     uint256 packed = _packedOwnerships[curr];
785                     // If not burned.
786                     if (packed & BITMASK_BURNED == 0) {
787                         // Invariant:
788                         // There will always be an ownership that has an address and is not burned
789                         // before an ownership that does not have an address and is not burned.
790                         // Hence, curr will not underflow.
791                         //
792                         // We can directly compare the packed value.
793                         // If the address is zero, packed is zero.
794                         while (packed == 0) {
795                             packed = _packedOwnerships[--curr];
796                         }
797                         return packed;
798                     }
799                 }
800         }
801         revert OwnerQueryForNonexistentToken();
802     }
803 
804     /**
805      * Returns the unpacked `TokenOwnership` struct from `packed`.
806      */
807     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
808         ownership.addr = address(uint160(packed));
809         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
810         ownership.burned = packed & BITMASK_BURNED != 0;
811         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
812     }
813 
814     /**
815      * Returns the unpacked `TokenOwnership` struct at `index`.
816      */
817     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
818         return _unpackedOwnership(_packedOwnerships[index]);
819     }
820 
821     /**
822      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
823      */
824     function _initializeOwnershipAt(uint256 index) internal {
825         if (_packedOwnerships[index] == 0) {
826             _packedOwnerships[index] = _packedOwnershipOf(index);
827         }
828     }
829 
830     /**
831      * Gas spent here starts off proportional to the maximum mint batch size.
832      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
833      */
834     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
835         return _unpackedOwnership(_packedOwnershipOf(tokenId));
836     }
837 
838     /**
839      * @dev Packs ownership data into a single uint256.
840      */
841     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
842         assembly {
843             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
844             owner := and(owner, BITMASK_ADDRESS)
845             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
846             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
847         }
848     }
849 
850     /**
851      * @dev See {IERC721-ownerOf}.
852      */
853     function ownerOf(uint256 tokenId) public view override returns (address) {
854         return address(uint160(_packedOwnershipOf(tokenId)));
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-name}.
859      */
860     function name() public view virtual override returns (string memory) {
861         return _name;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-symbol}.
866      */
867     function symbol() public view virtual override returns (string memory) {
868         return _symbol;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-tokenURI}.
873      */
874     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
875         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
876 
877         string memory baseURI = _baseURI();
878         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
879     }
880 
881     /**
882      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
883      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
884      * by default, it can be overridden in child contracts.
885      */
886     function _baseURI() internal view virtual returns (string memory) {
887         return '';
888     }
889 
890     /**
891      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
892      */
893     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
894         // For branchless setting of the `nextInitialized` flag.
895         assembly {
896             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
897             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
898         }
899     }
900 
901     /**
902      * @dev See {IERC721-approve}.
903      */
904     function approve(address to, uint256 tokenId) public override {
905         address owner = ownerOf(tokenId);
906 
907         if (_msgSenderERC721A() != owner)
908             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
909                 revert ApprovalCallerNotOwnerNorApproved();
910             }
911 
912         _tokenApprovals[tokenId] = to;
913         emit Approval(owner, to, tokenId);
914     }
915 
916     /**
917      * @dev See {IERC721-getApproved}.
918      */
919     function getApproved(uint256 tokenId) public view override returns (address) {
920         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
921 
922         return _tokenApprovals[tokenId];
923     }
924 
925     /**
926      * @dev See {IERC721-setApprovalForAll}.
927      */
928     function setApprovalForAll(address operator, bool approved) public virtual override {
929         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
930 
931         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
932         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
933     }
934 
935     /**
936      * @dev See {IERC721-isApprovedForAll}.
937      */
938     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
939         return _operatorApprovals[owner][operator];
940     }
941 
942     /**
943      * @dev See {IERC721-safeTransferFrom}.
944      */
945     function safeTransferFrom(
946         address from,
947         address to,
948         uint256 tokenId
949     ) public virtual override {
950         safeTransferFrom(from, to, tokenId, '');
951     }
952 
953     /**
954      * @dev See {IERC721-safeTransferFrom}.
955      */
956     function safeTransferFrom(
957         address from,
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) public virtual override {
962         transferFrom(from, to, tokenId);
963         if (to.code.length != 0)
964             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
965                 revert TransferToNonERC721ReceiverImplementer();
966             }
967     }
968 
969     /**
970      * @dev Returns whether `tokenId` exists.
971      *
972      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
973      *
974      * Tokens start existing when they are minted (`_mint`),
975      */
976     function _exists(uint256 tokenId) internal view returns (bool) {
977         return
978             _startTokenId() <= tokenId &&
979             tokenId < _currentIndex && // If within bounds,
980             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
981     }
982 
983     /**
984      * @dev Equivalent to `_safeMint(to, quantity, '')`.
985      */
986     function _safeMint(address to, uint256 quantity) internal {
987         _safeMint(to, quantity, '');
988     }
989 
990     /**
991      * @dev Safely mints `quantity` tokens and transfers them to `to`.
992      *
993      * Requirements:
994      *
995      * - If `to` refers to a smart contract, it must implement
996      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
997      * - `quantity` must be greater than 0.
998      *
999      * See {_mint}.
1000      *
1001      * Emits a {Transfer} event for each mint.
1002      */
1003     function _safeMint(
1004         address to,
1005         uint256 quantity,
1006         bytes memory _data
1007     ) internal {
1008         _mint(to, quantity);
1009 
1010         unchecked {
1011             if (to.code.length != 0) {
1012                 uint256 end = _currentIndex;
1013                 uint256 index = end - quantity;
1014                 do {
1015                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1016                         revert TransferToNonERC721ReceiverImplementer();
1017                     }
1018                 } while (index < end);
1019                 // Reentrancy protection.
1020                 if (_currentIndex != end) revert();
1021             }
1022         }
1023     }
1024 
1025     /**
1026      * @dev Mints `quantity` tokens and transfers them to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `quantity` must be greater than 0.
1032      *
1033      * Emits a {Transfer} event for each mint.
1034      */
1035     function _mint(address to, uint256 quantity) internal {
1036         uint256 startTokenId = _currentIndex;
1037         if (to == address(0)) revert MintToZeroAddress();
1038         if (quantity == 0) revert MintZeroQuantity();
1039 
1040         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1041 
1042         // Overflows are incredibly unrealistic.
1043         // `balance` and `numberMinted` have a maximum limit of 2**64.
1044         // `tokenId` has a maximum limit of 2**256.
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
1063             uint256 tokenId = startTokenId;
1064             uint256 end = startTokenId + quantity;
1065             do {
1066                 emit Transfer(address(0), to, tokenId++);
1067             } while (tokenId < end);
1068 
1069             _currentIndex = end;
1070         }
1071         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1072     }
1073 
1074     /**
1075      * @dev Mints `quantity` tokens and transfers them to `to`.
1076      *
1077      * This function is intended for efficient minting only during contract creation.
1078      *
1079      * It emits only one {ConsecutiveTransfer} as defined in
1080      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1081      * instead of a sequence of {Transfer} event(s).
1082      *
1083      * Calling this function outside of contract creation WILL make your contract
1084      * non-compliant with the ERC721 standard.
1085      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1086      * {ConsecutiveTransfer} event is only permissible during contract creation.
1087      *
1088      * Requirements:
1089      *
1090      * - `to` cannot be the zero address.
1091      * - `quantity` must be greater than 0.
1092      *
1093      * Emits a {ConsecutiveTransfer} event.
1094      */
1095     function _mintERC2309(address to, uint256 quantity) internal {
1096         uint256 startTokenId = _currentIndex;
1097         if (to == address(0)) revert MintToZeroAddress();
1098         if (quantity == 0) revert MintZeroQuantity();
1099         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1100 
1101         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1102 
1103         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1104         unchecked {
1105             // Updates:
1106             // - `balance += quantity`.
1107             // - `numberMinted += quantity`.
1108             //
1109             // We can directly add to the `balance` and `numberMinted`.
1110             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1111 
1112             // Updates:
1113             // - `address` to the owner.
1114             // - `startTimestamp` to the timestamp of minting.
1115             // - `burned` to `false`.
1116             // - `nextInitialized` to `quantity == 1`.
1117             _packedOwnerships[startTokenId] = _packOwnershipData(
1118                 to,
1119                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1120             );
1121 
1122             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1123 
1124             _currentIndex = startTokenId + quantity;
1125         }
1126         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1127     }
1128 
1129     /**
1130      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1131      */
1132     function _getApprovedAddress(uint256 tokenId)
1133         private
1134         view
1135         returns (uint256 approvedAddressSlot, address approvedAddress)
1136     {
1137         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1138         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1139         assembly {
1140             // Compute the slot.
1141             mstore(0x00, tokenId)
1142             mstore(0x20, tokenApprovalsPtr.slot)
1143             approvedAddressSlot := keccak256(0x00, 0x40)
1144             // Load the slot's value from storage.
1145             approvedAddress := sload(approvedAddressSlot)
1146         }
1147     }
1148 
1149     /**
1150      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1151      */
1152     function _isOwnerOrApproved(
1153         address approvedAddress,
1154         address from,
1155         address msgSender
1156     ) private pure returns (bool result) {
1157         assembly {
1158             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1159             from := and(from, BITMASK_ADDRESS)
1160             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1161             msgSender := and(msgSender, BITMASK_ADDRESS)
1162             // `msgSender == from || msgSender == approvedAddress`.
1163             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1164         }
1165     }
1166 
1167     /**
1168      * @dev Transfers `tokenId` from `from` to `to`.
1169      *
1170      * Requirements:
1171      *
1172      * - `to` cannot be the zero address.
1173      * - `tokenId` token must be owned by `from`.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function transferFrom(
1178         address from,
1179         address to,
1180         uint256 tokenId
1181     ) public virtual override {
1182         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1183 
1184         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1185 
1186         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1187 
1188         // The nested ifs save around 20+ gas over a compound boolean condition.
1189         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1190             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1191 
1192         if (to == address(0)) revert TransferToZeroAddress();
1193 
1194         _beforeTokenTransfers(from, to, tokenId, 1);
1195 
1196         // Clear approvals from the previous owner.
1197         assembly {
1198             if approvedAddress {
1199                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1200                 sstore(approvedAddressSlot, 0)
1201             }
1202         }
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1207         unchecked {
1208             // We can directly increment and decrement the balances.
1209             --_packedAddressData[from]; // Updates: `balance -= 1`.
1210             ++_packedAddressData[to]; // Updates: `balance += 1`.
1211 
1212             // Updates:
1213             // - `address` to the next owner.
1214             // - `startTimestamp` to the timestamp of transfering.
1215             // - `burned` to `false`.
1216             // - `nextInitialized` to `true`.
1217             _packedOwnerships[tokenId] = _packOwnershipData(
1218                 to,
1219                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1220             );
1221 
1222             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1223             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1224                 uint256 nextTokenId = tokenId + 1;
1225                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1226                 if (_packedOwnerships[nextTokenId] == 0) {
1227                     // If the next slot is within bounds.
1228                     if (nextTokenId != _currentIndex) {
1229                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1230                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1231                     }
1232                 }
1233             }
1234         }
1235 
1236         emit Transfer(from, to, tokenId);
1237         _afterTokenTransfers(from, to, tokenId, 1);
1238     }
1239 
1240     /**
1241      * @dev Equivalent to `_burn(tokenId, false)`.
1242      */
1243     function _burn(uint256 tokenId) internal virtual {
1244         _burn(tokenId, false);
1245     }
1246 
1247     /**
1248      * @dev Destroys `tokenId`.
1249      * The approval is cleared when the token is burned.
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must exist.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1258         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1259 
1260         address from = address(uint160(prevOwnershipPacked));
1261 
1262         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1263 
1264         if (approvalCheck) {
1265             // The nested ifs save around 20+ gas over a compound boolean condition.
1266             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1267                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1268         }
1269 
1270         _beforeTokenTransfers(from, address(0), tokenId, 1);
1271 
1272         // Clear approvals from the previous owner.
1273         assembly {
1274             if approvedAddress {
1275                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1276                 sstore(approvedAddressSlot, 0)
1277             }
1278         }
1279 
1280         // Underflow of the sender's balance is impossible because we check for
1281         // ownership above and the recipient's balance can't realistically overflow.
1282         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1283         unchecked {
1284             // Updates:
1285             // - `balance -= 1`.
1286             // - `numberBurned += 1`.
1287             //
1288             // We can directly decrement the balance, and increment the number burned.
1289             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1290             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1291 
1292             // Updates:
1293             // - `address` to the last owner.
1294             // - `startTimestamp` to the timestamp of burning.
1295             // - `burned` to `true`.
1296             // - `nextInitialized` to `true`.
1297             _packedOwnerships[tokenId] = _packOwnershipData(
1298                 from,
1299                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1300             );
1301 
1302             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1303             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1304                 uint256 nextTokenId = tokenId + 1;
1305                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1306                 if (_packedOwnerships[nextTokenId] == 0) {
1307                     // If the next slot is within bounds.
1308                     if (nextTokenId != _currentIndex) {
1309                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1310                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1311                     }
1312                 }
1313             }
1314         }
1315 
1316         emit Transfer(from, address(0), tokenId);
1317         _afterTokenTransfers(from, address(0), tokenId, 1);
1318 
1319         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1320         unchecked {
1321             _burnCounter++;
1322         }
1323     }
1324 
1325     /**
1326      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1327      *
1328      * @param from address representing the previous owner of the given token ID
1329      * @param to target address that will receive the tokens
1330      * @param tokenId uint256 ID of the token to be transferred
1331      * @param _data bytes optional data to send along with the call
1332      * @return bool whether the call correctly returned the expected magic value
1333      */
1334     function _checkContractOnERC721Received(
1335         address from,
1336         address to,
1337         uint256 tokenId,
1338         bytes memory _data
1339     ) private returns (bool) {
1340         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1341             bytes4 retval
1342         ) {
1343             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1344         } catch (bytes memory reason) {
1345             if (reason.length == 0) {
1346                 revert TransferToNonERC721ReceiverImplementer();
1347             } else {
1348                 assembly {
1349                     revert(add(32, reason), mload(reason))
1350                 }
1351             }
1352         }
1353     }
1354 
1355     /**
1356      * @dev Directly sets the extra data for the ownership data `index`.
1357      */
1358     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1359         uint256 packed = _packedOwnerships[index];
1360         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1361         uint256 extraDataCasted;
1362         // Cast `extraData` with assembly to avoid redundant masking.
1363         assembly {
1364             extraDataCasted := extraData
1365         }
1366         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1367         _packedOwnerships[index] = packed;
1368     }
1369 
1370     /**
1371      * @dev Returns the next extra data for the packed ownership data.
1372      * The returned result is shifted into position.
1373      */
1374     function _nextExtraData(
1375         address from,
1376         address to,
1377         uint256 prevOwnershipPacked
1378     ) private view returns (uint256) {
1379         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1380         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1381     }
1382 
1383     /**
1384      * @dev Called during each token transfer to set the 24bit `extraData` field.
1385      * Intended to be overridden by the cosumer contract.
1386      *
1387      * `previousExtraData` - the value of `extraData` before transfer.
1388      *
1389      * Calling conditions:
1390      *
1391      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1392      * transferred to `to`.
1393      * - When `from` is zero, `tokenId` will be minted for `to`.
1394      * - When `to` is zero, `tokenId` will be burned by `from`.
1395      * - `from` and `to` are never both zero.
1396      */
1397     function _extraData(
1398         address from,
1399         address to,
1400         uint24 previousExtraData
1401     ) internal view virtual returns (uint24) {}
1402 
1403     /**
1404      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1405      * This includes minting.
1406      * And also called before burning one token.
1407      *
1408      * startTokenId - the first token id to be transferred
1409      * quantity - the amount to be transferred
1410      *
1411      * Calling conditions:
1412      *
1413      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1414      * transferred to `to`.
1415      * - When `from` is zero, `tokenId` will be minted for `to`.
1416      * - When `to` is zero, `tokenId` will be burned by `from`.
1417      * - `from` and `to` are never both zero.
1418      */
1419     function _beforeTokenTransfers(
1420         address from,
1421         address to,
1422         uint256 startTokenId,
1423         uint256 quantity
1424     ) internal virtual {}
1425 
1426     /**
1427      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1428      * This includes minting.
1429      * And also called after one token has been burned.
1430      *
1431      * startTokenId - the first token id to be transferred
1432      * quantity - the amount to be transferred
1433      *
1434      * Calling conditions:
1435      *
1436      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1437      * transferred to `to`.
1438      * - When `from` is zero, `tokenId` has been minted for `to`.
1439      * - When `to` is zero, `tokenId` has been burned by `from`.
1440      * - `from` and `to` are never both zero.
1441      */
1442     function _afterTokenTransfers(
1443         address from,
1444         address to,
1445         uint256 startTokenId,
1446         uint256 quantity
1447     ) internal virtual {}
1448 
1449     /**
1450      * @dev Returns the message sender (defaults to `msg.sender`).
1451      *
1452      * If you are writing GSN compatible contracts, you need to override this function.
1453      */
1454     function _msgSenderERC721A() internal view virtual returns (address) {
1455         return msg.sender;
1456     }
1457 
1458     /**
1459      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1460      */
1461     function _toString(uint256 value) internal pure returns (string memory ptr) {
1462         assembly {
1463             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1464             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1465             // We will need 1 32-byte word to store the length,
1466             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1467             ptr := add(mload(0x40), 128)
1468             // Update the free memory pointer to allocate.
1469             mstore(0x40, ptr)
1470 
1471             // Cache the end of the memory to calculate the length later.
1472             let end := ptr
1473 
1474             // We write the string from the rightmost digit to the leftmost digit.
1475             // The following is essentially a do-while loop that also handles the zero case.
1476             // Costs a bit more than early returning for the zero case,
1477             // but cheaper in terms of deployment and overall runtime costs.
1478             for {
1479                 // Initialize and perform the first pass without check.
1480                 let temp := value
1481                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1482                 ptr := sub(ptr, 1)
1483                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1484                 mstore8(ptr, add(48, mod(temp, 10)))
1485                 temp := div(temp, 10)
1486             } temp {
1487                 // Keep dividing `temp` until zero.
1488                 temp := div(temp, 10)
1489             } {
1490                 // Body of the for loop.
1491                 ptr := sub(ptr, 1)
1492                 mstore8(ptr, add(48, mod(temp, 10)))
1493             }
1494 
1495             let length := sub(end, ptr)
1496             // Move the pointer 32 bytes leftwards to make room for the length.
1497             ptr := sub(ptr, 32)
1498             // Store the length.
1499             mstore(ptr, length)
1500         }
1501     }
1502 }
1503 
1504 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1505 
1506 
1507 // ERC721A Contracts v4.1.0
1508 // Creator: Chiru Labs
1509 
1510 pragma solidity ^0.8.4;
1511 
1512 
1513 /**
1514  * @dev Interface of an ERC721AQueryable compliant contract.
1515  */
1516 interface IERC721AQueryable is IERC721A {
1517     /**
1518      * Invalid query range (`start` >= `stop`).
1519      */
1520     error InvalidQueryRange();
1521 
1522     /**
1523      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1524      *
1525      * If the `tokenId` is out of bounds:
1526      *   - `addr` = `address(0)`
1527      *   - `startTimestamp` = `0`
1528      *   - `burned` = `false`
1529      *
1530      * If the `tokenId` is burned:
1531      *   - `addr` = `<Address of owner before token was burned>`
1532      *   - `startTimestamp` = `<Timestamp when token was burned>`
1533      *   - `burned = `true`
1534      *
1535      * Otherwise:
1536      *   - `addr` = `<Address of owner>`
1537      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1538      *   - `burned = `false`
1539      */
1540     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1541 
1542     /**
1543      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1544      * See {ERC721AQueryable-explicitOwnershipOf}
1545      */
1546     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1547 
1548     /**
1549      * @dev Returns an array of token IDs owned by `owner`,
1550      * in the range [`start`, `stop`)
1551      * (i.e. `start <= tokenId < stop`).
1552      *
1553      * This function allows for tokens to be queried if the collection
1554      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1555      *
1556      * Requirements:
1557      *
1558      * - `start` < `stop`
1559      */
1560     function tokensOfOwnerIn(
1561         address owner,
1562         uint256 start,
1563         uint256 stop
1564     ) external view returns (uint256[] memory);
1565 
1566     /**
1567      * @dev Returns an array of token IDs owned by `owner`.
1568      *
1569      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1570      * It is meant to be called off-chain.
1571      *
1572      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1573      * multiple smaller scans if the collection is large enough to cause
1574      * an out-of-gas error (10K pfp collections should be fine).
1575      */
1576     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1577 }
1578 
1579 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1580 
1581 
1582 // ERC721A Contracts v4.1.0
1583 // Creator: Chiru Labs
1584 
1585 pragma solidity ^0.8.4;
1586 
1587 
1588 
1589 /**
1590  * @title ERC721A Queryable
1591  * @dev ERC721A subclass with convenience query functions.
1592  */
1593 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1594     /**
1595      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1596      *
1597      * If the `tokenId` is out of bounds:
1598      *   - `addr` = `address(0)`
1599      *   - `startTimestamp` = `0`
1600      *   - `burned` = `false`
1601      *   - `extraData` = `0`
1602      *
1603      * If the `tokenId` is burned:
1604      *   - `addr` = `<Address of owner before token was burned>`
1605      *   - `startTimestamp` = `<Timestamp when token was burned>`
1606      *   - `burned = `true`
1607      *   - `extraData` = `<Extra data when token was burned>`
1608      *
1609      * Otherwise:
1610      *   - `addr` = `<Address of owner>`
1611      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1612      *   - `burned = `false`
1613      *   - `extraData` = `<Extra data at start of ownership>`
1614      */
1615     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1616         TokenOwnership memory ownership;
1617         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1618             return ownership;
1619         }
1620         ownership = _ownershipAt(tokenId);
1621         if (ownership.burned) {
1622             return ownership;
1623         }
1624         return _ownershipOf(tokenId);
1625     }
1626 
1627     /**
1628      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1629      * See {ERC721AQueryable-explicitOwnershipOf}
1630      */
1631     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1632         unchecked {
1633             uint256 tokenIdsLength = tokenIds.length;
1634             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1635             for (uint256 i; i != tokenIdsLength; ++i) {
1636                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1637             }
1638             return ownerships;
1639         }
1640     }
1641 
1642     /**
1643      * @dev Returns an array of token IDs owned by `owner`,
1644      * in the range [`start`, `stop`)
1645      * (i.e. `start <= tokenId < stop`).
1646      *
1647      * This function allows for tokens to be queried if the collection
1648      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1649      *
1650      * Requirements:
1651      *
1652      * - `start` < `stop`
1653      */
1654     function tokensOfOwnerIn(
1655         address owner,
1656         uint256 start,
1657         uint256 stop
1658     ) external view override returns (uint256[] memory) {
1659         unchecked {
1660             if (start >= stop) revert InvalidQueryRange();
1661             uint256 tokenIdsIdx;
1662             uint256 stopLimit = _nextTokenId();
1663             // Set `start = max(start, _startTokenId())`.
1664             if (start < _startTokenId()) {
1665                 start = _startTokenId();
1666             }
1667             // Set `stop = min(stop, stopLimit)`.
1668             if (stop > stopLimit) {
1669                 stop = stopLimit;
1670             }
1671             uint256 tokenIdsMaxLength = balanceOf(owner);
1672             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1673             // to cater for cases where `balanceOf(owner)` is too big.
1674             if (start < stop) {
1675                 uint256 rangeLength = stop - start;
1676                 if (rangeLength < tokenIdsMaxLength) {
1677                     tokenIdsMaxLength = rangeLength;
1678                 }
1679             } else {
1680                 tokenIdsMaxLength = 0;
1681             }
1682             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1683             if (tokenIdsMaxLength == 0) {
1684                 return tokenIds;
1685             }
1686             // We need to call `explicitOwnershipOf(start)`,
1687             // because the slot at `start` may not be initialized.
1688             TokenOwnership memory ownership = explicitOwnershipOf(start);
1689             address currOwnershipAddr;
1690             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1691             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1692             if (!ownership.burned) {
1693                 currOwnershipAddr = ownership.addr;
1694             }
1695             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1696                 ownership = _ownershipAt(i);
1697                 if (ownership.burned) {
1698                     continue;
1699                 }
1700                 if (ownership.addr != address(0)) {
1701                     currOwnershipAddr = ownership.addr;
1702                 }
1703                 if (currOwnershipAddr == owner) {
1704                     tokenIds[tokenIdsIdx++] = i;
1705                 }
1706             }
1707             // Downsize the array to fit.
1708             assembly {
1709                 mstore(tokenIds, tokenIdsIdx)
1710             }
1711             return tokenIds;
1712         }
1713     }
1714 
1715     /**
1716      * @dev Returns an array of token IDs owned by `owner`.
1717      *
1718      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1719      * It is meant to be called off-chain.
1720      *
1721      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1722      * multiple smaller scans if the collection is large enough to cause
1723      * an out-of-gas error (10K pfp collections should be fine).
1724      */
1725     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1726         unchecked {
1727             uint256 tokenIdsIdx;
1728             address currOwnershipAddr;
1729             uint256 tokenIdsLength = balanceOf(owner);
1730             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1731             TokenOwnership memory ownership;
1732             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1733                 ownership = _ownershipAt(i);
1734                 if (ownership.burned) {
1735                     continue;
1736                 }
1737                 if (ownership.addr != address(0)) {
1738                     currOwnershipAddr = ownership.addr;
1739                 }
1740                 if (currOwnershipAddr == owner) {
1741                     tokenIds[tokenIdsIdx++] = i;
1742                 }
1743             }
1744             return tokenIds;
1745         }
1746     }
1747 }
1748 
1749 
1750 
1751 pragma solidity >=0.8.9 <0.9.0;
1752 
1753 contract HDgenuineundead is ERC721AQueryable, Ownable, ReentrancyGuard {
1754     using Strings for uint256;
1755 
1756     uint256 public maxSupply = 5000;
1757 	uint256 public Ownermint = 1;
1758     uint256 public maxPerAddress = 100;
1759 	uint256 public maxPerTX = 10;
1760     uint256 public cost = 0.002 ether;
1761 	mapping(address => bool) public freeMinted; 
1762 
1763     bool public paused = true;
1764 
1765 	string public uriPrefix = '';
1766     string public uriSuffix = '.json';
1767 	
1768   constructor(string memory baseURI) ERC721A("HD Genuine Undead", "HDGU") {
1769       setUriPrefix(baseURI); 
1770       _safeMint(_msgSender(), Ownermint);
1771 
1772   }
1773 
1774   modifier callerIsUser() {
1775         require(tx.origin == msg.sender, "The caller is another contract");
1776         _;
1777   }
1778 
1779   function numberMinted(address owner) public view returns (uint256) {
1780         return _numberMinted(owner);
1781   }
1782 
1783   function mint (uint256 _mintAmount) public payable nonReentrant callerIsUser{
1784         require(!paused, 'The contract is paused!');
1785         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1786         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1787         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1788 	if (freeMinted[_msgSender()]){
1789         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1790   }
1791     else{
1792 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1793         freeMinted[_msgSender()] = true;
1794   }
1795 
1796     _safeMint(_msgSender(), _mintAmount);
1797   }
1798 
1799   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1800     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1801     string memory currentBaseURI = _baseURI();
1802     return bytes(currentBaseURI).length > 0
1803         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1804         : '';
1805   }
1806 
1807   function unpause () public onlyOwner {
1808     paused = !paused;
1809   }
1810 
1811   function setCost(uint256 _cost) public onlyOwner {
1812     cost = _cost;
1813   }
1814 
1815   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1816     maxPerTX = _maxPerTX;
1817   }
1818 
1819   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1820     uriPrefix = _uriPrefix;
1821   }
1822  
1823   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1824     uriSuffix = _uriSuffix;
1825   }
1826 
1827   function withdraw() external onlyOwner {
1828         payable(msg.sender).transfer(address(this).balance);
1829   }
1830 
1831   function _startTokenId() internal view virtual override returns (uint256) {
1832     return 1;
1833   }
1834 
1835   function _baseURI() internal view virtual override returns (string memory) {
1836     return uriPrefix;
1837   }
1838 }