1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 /**
5  ____  __ __  ____  __  __     _     ____  ____   ____   __  _    _____  ____  __ __  _    
6 | ===||  |  |/ (__`|  |/  /   | |__ / () \/ (_,` / () \ |  \| |   | ()_)/ () \|  |  || |__ 
7 |__|   \___/ \____)|__|\__\   |____|\____/\____)/__/\__\|_|\__|   |_|  /__/\__\\___/ |____|
8 
9 READ OUR WEBSITE!! https://fuckloganpaul.com/
10 1 free - 0.001 each for more. max 10
11 
12 */
13 
14 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Contract module that helps prevent reentrant calls to a function.
20  *
21  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
22  * available, which can be applied to functions to make sure there are no nested
23  * (reentrant) calls to them.
24  *
25  * Note that because there is a single `nonReentrant` guard, functions marked as
26  * `nonReentrant` may not call one another. This can be worked around by making
27  * those functions `private`, and then adding `external` `nonReentrant` entry
28  * points to them.
29  *
30  * TIP: If you would like to learn more about reentrancy and alternative ways
31  * to protect against it, check out our blog post
32  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
33  */
34 abstract contract ReentrancyGuard {
35     // Booleans are more expensive than uint256 or any type that takes up a full
36     // word because each write operation emits an extra SLOAD to first read the
37     // slot's contents, replace the bits taken up by the boolean, and then write
38     // back. This is the compiler's defense against contract upgrades and
39     // pointer aliasing, and it cannot be disabled.
40 
41     // The values being non-zero value makes deployment a bit more expensive,
42     // but in exchange the refund on every call to nonReentrant will be lower in
43     // amount. Since refunds are capped to a percentage of the total
44     // transaction's gas, it is best to keep them low in cases like this one, to
45     // increase the likelihood of the full refund coming into effect.
46     uint256 private constant _NOT_ENTERED = 1;
47     uint256 private constant _ENTERED = 2;
48 
49     uint256 private _status;
50 
51     constructor() {
52         _status = _NOT_ENTERED;
53     }
54 
55     /**
56      * @dev Prevents a contract from calling itself, directly or indirectly.
57      * Calling a `nonReentrant` function from another `nonReentrant`
58      * function is not supported. It is possible to prevent this from happening
59      * by making the `nonReentrant` function external, and making it call a
60      * `private` function that does the actual work.
61      */
62     modifier nonReentrant() {
63         // On the first call to nonReentrant, _notEntered will be true
64         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
65 
66         // Any calls to nonReentrant after this point will fail
67         _status = _ENTERED;
68 
69         _;
70 
71         // By storing the original value once again, a refund is triggered (see
72         // https://eips.ethereum.org/EIPS/eip-2200)
73         _status = _NOT_ENTERED;
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Strings.sol
78 
79 
80 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev String operations.
86  */
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89     uint8 private constant _ADDRESS_LENGTH = 20;
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
93      */
94     function toString(uint256 value) internal pure returns (string memory) {
95         // Inspired by OraclizeAPI's implementation - MIT licence
96         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
97 
98         if (value == 0) {
99             return "0";
100         }
101         uint256 temp = value;
102         uint256 digits;
103         while (temp != 0) {
104             digits++;
105             temp /= 10;
106         }
107         bytes memory buffer = new bytes(digits);
108         while (value != 0) {
109             digits -= 1;
110             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
111             value /= 10;
112         }
113         return string(buffer);
114     }
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
118      */
119     function toHexString(uint256 value) internal pure returns (string memory) {
120         if (value == 0) {
121             return "0x00";
122         }
123         uint256 temp = value;
124         uint256 length = 0;
125         while (temp != 0) {
126             length++;
127             temp >>= 8;
128         }
129         return toHexString(value, length);
130     }
131 
132     /**
133      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
134      */
135     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
136         bytes memory buffer = new bytes(2 * length + 2);
137         buffer[0] = "0";
138         buffer[1] = "x";
139         for (uint256 i = 2 * length + 1; i > 1; --i) {
140             buffer[i] = _HEX_SYMBOLS[value & 0xf];
141             value >>= 4;
142         }
143         require(value == 0, "Strings: hex length insufficient");
144         return string(buffer);
145     }
146 
147     /**
148      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
149      */
150     function toHexString(address addr) internal pure returns (string memory) {
151         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
152     }
153 }
154 
155 
156 // File: @openzeppelin/contracts/utils/Context.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev Provides information about the current execution context, including the
165  * sender of the transaction and its data. While these are generally available
166  * via msg.sender and msg.data, they should not be accessed in such a direct
167  * manner, since when dealing with meta-transactions the account sending and
168  * paying for execution may not be the actual sender (as far as an application
169  * is concerned).
170  *
171  * This contract is only required for intermediate, library-like contracts.
172  */
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes calldata) {
179         return msg.data;
180     }
181 }
182 
183 // File: @openzeppelin/contracts/access/Ownable.sol
184 
185 
186 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 
191 /**
192  * @dev Contract module which provides a basic access control mechanism, where
193  * there is an account (an owner) that can be granted exclusive access to
194  * specific functions.
195  *
196  * By default, the owner account will be the one that deploys the contract. This
197  * can later be changed with {transferOwnership}.
198  *
199  * This module is used through inheritance. It will make available the modifier
200  * `onlyOwner`, which can be applied to your functions to restrict their use to
201  * the owner.
202  */
203 abstract contract Ownable is Context {
204     address private _owner;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     /**
209      * @dev Initializes the contract setting the deployer as the initial owner.
210      */
211     constructor() {
212         _transferOwnership(_msgSender());
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         _checkOwner();
220         _;
221     }
222 
223     /**
224      * @dev Returns the address of the current owner.
225      */
226     function owner() public view virtual returns (address) {
227         return _owner;
228     }
229 
230     /**
231      * @dev Throws if the sender is not the owner.
232      */
233     function _checkOwner() internal view virtual {
234         require(owner() == _msgSender(), "Ownable: caller is not the owner");
235     }
236 
237     /**
238      * @dev Leaves the contract without owner. It will not be possible to call
239      * `onlyOwner` functions anymore. Can only be called by the current owner.
240      *
241      * NOTE: Renouncing ownership will leave the contract without an owner,
242      * thereby removing any functionality that is only available to the owner.
243      */
244     function renounceOwnership() public virtual onlyOwner {
245         _transferOwnership(address(0));
246     }
247 
248     /**
249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
250      * Can only be called by the current owner.
251      */
252     function transferOwnership(address newOwner) public virtual onlyOwner {
253         require(newOwner != address(0), "Ownable: new owner is the zero address");
254         _transferOwnership(newOwner);
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Internal function without access restriction.
260      */
261     function _transferOwnership(address newOwner) internal virtual {
262         address oldOwner = _owner;
263         _owner = newOwner;
264         emit OwnershipTransferred(oldOwner, newOwner);
265     }
266 }
267 
268 // File: erc721a/contracts/IERC721A.sol
269 
270 
271 // ERC721A Contracts v4.1.0
272 // Creator: Chiru Labs
273 
274 pragma solidity ^0.8.4;
275 
276 /**
277  * @dev Interface of an ERC721A compliant contract.
278  */
279 interface IERC721A {
280     /**
281      * The caller must own the token or be an approved operator.
282      */
283     error ApprovalCallerNotOwnerNorApproved();
284 
285     /**
286      * The token does not exist.
287      */
288     error ApprovalQueryForNonexistentToken();
289 
290     /**
291      * The caller cannot approve to their own address.
292      */
293     error ApproveToCaller();
294 
295     /**
296      * Cannot query the balance for the zero address.
297      */
298     error BalanceQueryForZeroAddress();
299 
300     /**
301      * Cannot mint to the zero address.
302      */
303     error MintToZeroAddress();
304 
305     /**
306      * The quantity of tokens minted must be more than zero.
307      */
308     error MintZeroQuantity();
309 
310     /**
311      * The token does not exist.
312      */
313     error OwnerQueryForNonexistentToken();
314 
315     /**
316      * The caller must own the token or be an approved operator.
317      */
318     error TransferCallerNotOwnerNorApproved();
319 
320     /**
321      * The token must be owned by `from`.
322      */
323     error TransferFromIncorrectOwner();
324 
325     /**
326      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
327      */
328     error TransferToNonERC721ReceiverImplementer();
329 
330     /**
331      * Cannot transfer to the zero address.
332      */
333     error TransferToZeroAddress();
334 
335     /**
336      * The token does not exist.
337      */
338     error URIQueryForNonexistentToken();
339 
340     /**
341      * The `quantity` minted with ERC2309 exceeds the safety limit.
342      */
343     error MintERC2309QuantityExceedsLimit();
344 
345     /**
346      * The `extraData` cannot be set on an unintialized ownership slot.
347      */
348     error OwnershipNotInitializedForExtraData();
349 
350     struct TokenOwnership {
351         // The address of the owner.
352         address addr;
353         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
354         uint64 startTimestamp;
355         // Whether the token has been burned.
356         bool burned;
357         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
358         uint24 extraData;
359     }
360 
361     /**
362      * @dev Returns the total amount of tokens stored by the contract.
363      *
364      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     // ==============================
369     //            IERC165
370     // ==============================
371 
372     /**
373      * @dev Returns true if this contract implements the interface defined by
374      * `interfaceId`. See the corresponding
375      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
376      * to learn more about how these ids are created.
377      *
378      * This function call must use less than 30 000 gas.
379      */
380     function supportsInterface(bytes4 interfaceId) external view returns (bool);
381 
382     // ==============================
383     //            IERC721
384     // ==============================
385 
386     /**
387      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
393      */
394     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
398      */
399     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
400 
401     /**
402      * @dev Returns the number of tokens in ``owner``'s account.
403      */
404     function balanceOf(address owner) external view returns (uint256 balance);
405 
406     /**
407      * @dev Returns the owner of the `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function ownerOf(uint256 tokenId) external view returns (address owner);
414 
415     /**
416      * @dev Safely transfers `tokenId` token from `from` to `to`.
417      *
418      * Requirements:
419      *
420      * - `from` cannot be the zero address.
421      * - `to` cannot be the zero address.
422      * - `tokenId` token must exist and be owned by `from`.
423      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
424      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
425      *
426      * Emits a {Transfer} event.
427      */
428     function safeTransferFrom(
429         address from,
430         address to,
431         uint256 tokenId,
432         bytes calldata data
433     ) external;
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
437      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) external;
454 
455     /**
456      * @dev Transfers `tokenId` token from `from` to `to`.
457      *
458      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must be owned by `from`.
465      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      *
467      * Emits a {Transfer} event.
468      */
469     function transferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
477      * The approval is cleared when the token is transferred.
478      *
479      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
480      *
481      * Requirements:
482      *
483      * - The caller must own the token or be an approved operator.
484      * - `tokenId` must exist.
485      *
486      * Emits an {Approval} event.
487      */
488     function approve(address to, uint256 tokenId) external;
489 
490     /**
491      * @dev Approve or remove `operator` as an operator for the caller.
492      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
493      *
494      * Requirements:
495      *
496      * - The `operator` cannot be the caller.
497      *
498      * Emits an {ApprovalForAll} event.
499      */
500     function setApprovalForAll(address operator, bool _approved) external;
501 
502     /**
503      * @dev Returns the account approved for `tokenId` token.
504      *
505      * Requirements:
506      *
507      * - `tokenId` must exist.
508      */
509     function getApproved(uint256 tokenId) external view returns (address operator);
510 
511     /**
512      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
513      *
514      * See {setApprovalForAll}
515      */
516     function isApprovedForAll(address owner, address operator) external view returns (bool);
517 
518     // ==============================
519     //        IERC721Metadata
520     // ==============================
521 
522     /**
523      * @dev Returns the token collection name.
524      */
525     function name() external view returns (string memory);
526 
527     /**
528      * @dev Returns the token collection symbol.
529      */
530     function symbol() external view returns (string memory);
531 
532     /**
533      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
534      */
535     function tokenURI(uint256 tokenId) external view returns (string memory);
536 
537     // ==============================
538     //            IERC2309
539     // ==============================
540 
541     /**
542      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
543      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
544      */
545     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
546 }
547 
548 // File: erc721a/contracts/ERC721A.sol
549 
550 
551 // ERC721A Contracts v4.1.0
552 // Creator: Chiru Labs
553 
554 pragma solidity ^0.8.4;
555 
556 
557 /**
558  * @dev ERC721 token receiver interface.
559  */
560 interface ERC721A__IERC721Receiver {
561     function onERC721Received(
562         address operator,
563         address from,
564         uint256 tokenId,
565         bytes calldata data
566     ) external returns (bytes4);
567 }
568 
569 /**
570  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
571  * including the Metadata extension. Built to optimize for lower gas during batch mints.
572  *
573  * Assumes serials are sequentially minted starting at `_startTokenId()`
574  * (defaults to 0, e.g. 0, 1, 2, 3..).
575  *
576  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
577  *
578  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
579  */
580 contract ERC721A is IERC721A {
581     // Mask of an entry in packed address data.
582     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
583 
584     // The bit position of `numberMinted` in packed address data.
585     uint256 private constant BITPOS_NUMBER_MINTED = 64;
586 
587     // The bit position of `numberBurned` in packed address data.
588     uint256 private constant BITPOS_NUMBER_BURNED = 128;
589 
590     // The bit position of `aux` in packed address data.
591     uint256 private constant BITPOS_AUX = 192;
592 
593     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
594     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
595 
596     // The bit position of `startTimestamp` in packed ownership.
597     uint256 private constant BITPOS_START_TIMESTAMP = 160;
598 
599     // The bit mask of the `burned` bit in packed ownership.
600     uint256 private constant BITMASK_BURNED = 1 << 224;
601 
602     // The bit position of the `nextInitialized` bit in packed ownership.
603     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
604 
605     // The bit mask of the `nextInitialized` bit in packed ownership.
606     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
607 
608     // The bit position of `extraData` in packed ownership.
609     uint256 private constant BITPOS_EXTRA_DATA = 232;
610 
611     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
612     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
613 
614     // The mask of the lower 160 bits for addresses.
615     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
616 
617     // The maximum `quantity` that can be minted with `_mintERC2309`.
618     // This limit is to prevent overflows on the address data entries.
619     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
620     // is required to cause an overflow, which is unrealistic.
621     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
622 
623     // The tokenId of the next token to be minted.
624     uint256 private _currentIndex;
625 
626     // The number of tokens burned.
627     uint256 private _burnCounter;
628 
629     // Token name
630     string private _name;
631 
632     // Token symbol
633     string private _symbol;
634 
635     // Mapping from token ID to ownership details
636     // An empty struct value does not necessarily mean the token is unowned.
637     // See `_packedOwnershipOf` implementation for details.
638     //
639     // Bits Layout:
640     // - [0..159]   `addr`
641     // - [160..223] `startTimestamp`
642     // - [224]      `burned`
643     // - [225]      `nextInitialized`
644     // - [232..255] `extraData`
645     mapping(uint256 => uint256) private _packedOwnerships;
646 
647     // Mapping owner address to address data.
648     //
649     // Bits Layout:
650     // - [0..63]    `balance`
651     // - [64..127]  `numberMinted`
652     // - [128..191] `numberBurned`
653     // - [192..255] `aux`
654     mapping(address => uint256) private _packedAddressData;
655 
656     // Mapping from token ID to approved address.
657     mapping(uint256 => address) private _tokenApprovals;
658 
659     // Mapping from owner to operator approvals
660     mapping(address => mapping(address => bool)) private _operatorApprovals;
661 
662     constructor(string memory name_, string memory symbol_) {
663         _name = name_;
664         _symbol = symbol_;
665         _currentIndex = _startTokenId();
666     }
667 
668     /**
669      * @dev Returns the starting token ID.
670      * To change the starting token ID, please override this function.
671      */
672     function _startTokenId() internal view virtual returns (uint256) {
673         return 0;
674     }
675 
676     /**
677      * @dev Returns the next token ID to be minted.
678      */
679     function _nextTokenId() internal view returns (uint256) {
680         return _currentIndex;
681     }
682 
683     /**
684      * @dev Returns the total number of tokens in existence.
685      * Burned tokens will reduce the count.
686      * To get the total number of tokens minted, please see `_totalMinted`.
687      */
688     function totalSupply() public view override returns (uint256) {
689         // Counter underflow is impossible as _burnCounter cannot be incremented
690         // more than `_currentIndex - _startTokenId()` times.
691         unchecked {
692             return _currentIndex - _burnCounter - _startTokenId();
693         }
694     }
695 
696     /**
697      * @dev Returns the total amount of tokens minted in the contract.
698      */
699     function _totalMinted() internal view returns (uint256) {
700         // Counter underflow is impossible as _currentIndex does not decrement,
701         // and it is initialized to `_startTokenId()`
702         unchecked {
703             return _currentIndex - _startTokenId();
704         }
705     }
706 
707     /**
708      * @dev Returns the total number of tokens burned.
709      */
710     function _totalBurned() internal view returns (uint256) {
711         return _burnCounter;
712     }
713 
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
718         // The interface IDs are constants representing the first 4 bytes of the XOR of
719         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
720         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
721         return
722             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
723             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
724             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
725     }
726 
727     /**
728      * @dev See {IERC721-balanceOf}.
729      */
730     function balanceOf(address owner) public view override returns (uint256) {
731         if (owner == address(0)) revert BalanceQueryForZeroAddress();
732         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
733     }
734 
735     /**
736      * Returns the number of tokens minted by `owner`.
737      */
738     function _numberMinted(address owner) internal view returns (uint256) {
739         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
740     }
741 
742     /**
743      * Returns the number of tokens burned by or on behalf of `owner`.
744      */
745     function _numberBurned(address owner) internal view returns (uint256) {
746         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
747     }
748 
749     /**
750      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
751      */
752     function _getAux(address owner) internal view returns (uint64) {
753         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
754     }
755 
756     /**
757      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
758      * If there are multiple variables, please pack them into a uint64.
759      */
760     function _setAux(address owner, uint64 aux) internal {
761         uint256 packed = _packedAddressData[owner];
762         uint256 auxCasted;
763         // Cast `aux` with assembly to avoid redundant masking.
764         assembly {
765             auxCasted := aux
766         }
767         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
768         _packedAddressData[owner] = packed;
769     }
770 
771     /**
772      * Returns the packed ownership data of `tokenId`.
773      */
774     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
775         uint256 curr = tokenId;
776 
777         unchecked {
778             if (_startTokenId() <= curr)
779                 if (curr < _currentIndex) {
780                     uint256 packed = _packedOwnerships[curr];
781                     // If not burned.
782                     if (packed & BITMASK_BURNED == 0) {
783                         // Invariant:
784                         // There will always be an ownership that has an address and is not burned
785                         // before an ownership that does not have an address and is not burned.
786                         // Hence, curr will not underflow.
787                         //
788                         // We can directly compare the packed value.
789                         // If the address is zero, packed is zero.
790                         while (packed == 0) {
791                             packed = _packedOwnerships[--curr];
792                         }
793                         return packed;
794                     }
795                 }
796         }
797         revert OwnerQueryForNonexistentToken();
798     }
799 
800     /**
801      * Returns the unpacked `TokenOwnership` struct from `packed`.
802      */
803     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
804         ownership.addr = address(uint160(packed));
805         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
806         ownership.burned = packed & BITMASK_BURNED != 0;
807         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
808     }
809 
810     /**
811      * Returns the unpacked `TokenOwnership` struct at `index`.
812      */
813     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
814         return _unpackedOwnership(_packedOwnerships[index]);
815     }
816 
817     /**
818      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
819      */
820     function _initializeOwnershipAt(uint256 index) internal {
821         if (_packedOwnerships[index] == 0) {
822             _packedOwnerships[index] = _packedOwnershipOf(index);
823         }
824     }
825 
826     /**
827      * Gas spent here starts off proportional to the maximum mint batch size.
828      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
829      */
830     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
831         return _unpackedOwnership(_packedOwnershipOf(tokenId));
832     }
833 
834     /**
835      * @dev Packs ownership data into a single uint256.
836      */
837     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
838         assembly {
839             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
840             owner := and(owner, BITMASK_ADDRESS)
841             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
842             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
843         }
844     }
845 
846     /**
847      * @dev See {IERC721-ownerOf}.
848      */
849     function ownerOf(uint256 tokenId) public view override returns (address) {
850         return address(uint160(_packedOwnershipOf(tokenId)));
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-name}.
855      */
856     function name() public view virtual override returns (string memory) {
857         return _name;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-symbol}.
862      */
863     function symbol() public view virtual override returns (string memory) {
864         return _symbol;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-tokenURI}.
869      */
870     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
871         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
872 
873         string memory baseURI = _baseURI();
874         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
875     }
876 
877     /**
878      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
879      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
880      * by default, it can be overridden in child contracts.
881      */
882     function _baseURI() internal view virtual returns (string memory) {
883         return '';
884     }
885 
886     /**
887      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
888      */
889     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
890         // For branchless setting of the `nextInitialized` flag.
891         assembly {
892             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
893             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
894         }
895     }
896 
897     /**
898      * @dev See {IERC721-approve}.
899      */
900     function approve(address to, uint256 tokenId) public override {
901         address owner = ownerOf(tokenId);
902 
903         if (_msgSenderERC721A() != owner)
904             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
905                 revert ApprovalCallerNotOwnerNorApproved();
906             }
907 
908         _tokenApprovals[tokenId] = to;
909         emit Approval(owner, to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-getApproved}.
914      */
915     function getApproved(uint256 tokenId) public view override returns (address) {
916         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
917 
918         return _tokenApprovals[tokenId];
919     }
920 
921     /**
922      * @dev See {IERC721-setApprovalForAll}.
923      */
924     function setApprovalForAll(address operator, bool approved) public virtual override {
925         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
926 
927         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
928         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
929     }
930 
931     /**
932      * @dev See {IERC721-isApprovedForAll}.
933      */
934     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
935         return _operatorApprovals[owner][operator];
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         safeTransferFrom(from, to, tokenId, '');
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) public virtual override {
958         transferFrom(from, to, tokenId);
959         if (to.code.length != 0)
960             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
961                 revert TransferToNonERC721ReceiverImplementer();
962             }
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted (`_mint`),
971      */
972     function _exists(uint256 tokenId) internal view returns (bool) {
973         return
974             _startTokenId() <= tokenId &&
975             tokenId < _currentIndex && // If within bounds,
976             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
977     }
978 
979     /**
980      * @dev Equivalent to `_safeMint(to, quantity, '')`.
981      */
982     function _safeMint(address to, uint256 quantity) internal {
983         _safeMint(to, quantity, '');
984     }
985 
986     /**
987      * @dev Safely mints `quantity` tokens and transfers them to `to`.
988      *
989      * Requirements:
990      *
991      * - If `to` refers to a smart contract, it must implement
992      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
993      * - `quantity` must be greater than 0.
994      *
995      * See {_mint}.
996      *
997      * Emits a {Transfer} event for each mint.
998      */
999     function _safeMint(
1000         address to,
1001         uint256 quantity,
1002         bytes memory _data
1003     ) internal {
1004         _mint(to, quantity);
1005 
1006         unchecked {
1007             if (to.code.length != 0) {
1008                 uint256 end = _currentIndex;
1009                 uint256 index = end - quantity;
1010                 do {
1011                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1012                         revert TransferToNonERC721ReceiverImplementer();
1013                     }
1014                 } while (index < end);
1015                 // Reentrancy protection.
1016                 if (_currentIndex != end) revert();
1017             }
1018         }
1019     }
1020 
1021     /**
1022      * @dev Mints `quantity` tokens and transfers them to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `quantity` must be greater than 0.
1028      *
1029      * Emits a {Transfer} event for each mint.
1030      */
1031     function _mint(address to, uint256 quantity) internal {
1032         uint256 startTokenId = _currentIndex;
1033         if (to == address(0)) revert MintToZeroAddress();
1034         if (quantity == 0) revert MintZeroQuantity();
1035 
1036         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1037 
1038         // Overflows are incredibly unrealistic.
1039         // `balance` and `numberMinted` have a maximum limit of 2**64.
1040         // `tokenId` has a maximum limit of 2**256.
1041         unchecked {
1042             // Updates:
1043             // - `balance += quantity`.
1044             // - `numberMinted += quantity`.
1045             //
1046             // We can directly add to the `balance` and `numberMinted`.
1047             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1048 
1049             // Updates:
1050             // - `address` to the owner.
1051             // - `startTimestamp` to the timestamp of minting.
1052             // - `burned` to `false`.
1053             // - `nextInitialized` to `quantity == 1`.
1054             _packedOwnerships[startTokenId] = _packOwnershipData(
1055                 to,
1056                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1057             );
1058 
1059             uint256 tokenId = startTokenId;
1060             uint256 end = startTokenId + quantity;
1061             do {
1062                 emit Transfer(address(0), to, tokenId++);
1063             } while (tokenId < end);
1064 
1065             _currentIndex = end;
1066         }
1067         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1068     }
1069 
1070     /**
1071      * @dev Mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * This function is intended for efficient minting only during contract creation.
1074      *
1075      * It emits only one {ConsecutiveTransfer} as defined in
1076      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1077      * instead of a sequence of {Transfer} event(s).
1078      *
1079      * Calling this function outside of contract creation WILL make your contract
1080      * non-compliant with the ERC721 standard.
1081      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1082      * {ConsecutiveTransfer} event is only permissible during contract creation.
1083      *
1084      * Requirements:
1085      *
1086      * - `to` cannot be the zero address.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {ConsecutiveTransfer} event.
1090      */
1091     function _mintERC2309(address to, uint256 quantity) internal {
1092         uint256 startTokenId = _currentIndex;
1093         if (to == address(0)) revert MintToZeroAddress();
1094         if (quantity == 0) revert MintZeroQuantity();
1095         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1100         unchecked {
1101             // Updates:
1102             // - `balance += quantity`.
1103             // - `numberMinted += quantity`.
1104             //
1105             // We can directly add to the `balance` and `numberMinted`.
1106             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1107 
1108             // Updates:
1109             // - `address` to the owner.
1110             // - `startTimestamp` to the timestamp of minting.
1111             // - `burned` to `false`.
1112             // - `nextInitialized` to `quantity == 1`.
1113             _packedOwnerships[startTokenId] = _packOwnershipData(
1114                 to,
1115                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1116             );
1117 
1118             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1119 
1120             _currentIndex = startTokenId + quantity;
1121         }
1122         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1123     }
1124 
1125     /**
1126      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1127      */
1128     function _getApprovedAddress(uint256 tokenId)
1129         private
1130         view
1131         returns (uint256 approvedAddressSlot, address approvedAddress)
1132     {
1133         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1134         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1135         assembly {
1136             // Compute the slot.
1137             mstore(0x00, tokenId)
1138             mstore(0x20, tokenApprovalsPtr.slot)
1139             approvedAddressSlot := keccak256(0x00, 0x40)
1140             // Load the slot's value from storage.
1141             approvedAddress := sload(approvedAddressSlot)
1142         }
1143     }
1144 
1145     /**
1146      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1147      */
1148     function _isOwnerOrApproved(
1149         address approvedAddress,
1150         address from,
1151         address msgSender
1152     ) private pure returns (bool result) {
1153         assembly {
1154             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1155             from := and(from, BITMASK_ADDRESS)
1156             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1157             msgSender := and(msgSender, BITMASK_ADDRESS)
1158             // `msgSender == from || msgSender == approvedAddress`.
1159             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1160         }
1161     }
1162 
1163     /**
1164      * @dev Transfers `tokenId` from `from` to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must be owned by `from`.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function transferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) public virtual override {
1178         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1179 
1180         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1181 
1182         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1183 
1184         // The nested ifs save around 20+ gas over a compound boolean condition.
1185         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1186             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1187 
1188         if (to == address(0)) revert TransferToZeroAddress();
1189 
1190         _beforeTokenTransfers(from, to, tokenId, 1);
1191 
1192         // Clear approvals from the previous owner.
1193         assembly {
1194             if approvedAddress {
1195                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1196                 sstore(approvedAddressSlot, 0)
1197             }
1198         }
1199 
1200         // Underflow of the sender's balance is impossible because we check for
1201         // ownership above and the recipient's balance can't realistically overflow.
1202         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1203         unchecked {
1204             // We can directly increment and decrement the balances.
1205             --_packedAddressData[from]; // Updates: `balance -= 1`.
1206             ++_packedAddressData[to]; // Updates: `balance += 1`.
1207 
1208             // Updates:
1209             // - `address` to the next owner.
1210             // - `startTimestamp` to the timestamp of transfering.
1211             // - `burned` to `false`.
1212             // - `nextInitialized` to `true`.
1213             _packedOwnerships[tokenId] = _packOwnershipData(
1214                 to,
1215                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1216             );
1217 
1218             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1219             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1220                 uint256 nextTokenId = tokenId + 1;
1221                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1222                 if (_packedOwnerships[nextTokenId] == 0) {
1223                     // If the next slot is within bounds.
1224                     if (nextTokenId != _currentIndex) {
1225                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1226                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1227                     }
1228                 }
1229             }
1230         }
1231 
1232         emit Transfer(from, to, tokenId);
1233         _afterTokenTransfers(from, to, tokenId, 1);
1234     }
1235 
1236     /**
1237      * @dev Equivalent to `_burn(tokenId, false)`.
1238      */
1239     function _burn(uint256 tokenId) internal virtual {
1240         _burn(tokenId, false);
1241     }
1242 
1243     /**
1244      * @dev Destroys `tokenId`.
1245      * The approval is cleared when the token is burned.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must exist.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1254         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1255 
1256         address from = address(uint160(prevOwnershipPacked));
1257 
1258         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1259 
1260         if (approvalCheck) {
1261             // The nested ifs save around 20+ gas over a compound boolean condition.
1262             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1263                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1264         }
1265 
1266         _beforeTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Clear approvals from the previous owner.
1269         assembly {
1270             if approvedAddress {
1271                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1272                 sstore(approvedAddressSlot, 0)
1273             }
1274         }
1275 
1276         // Underflow of the sender's balance is impossible because we check for
1277         // ownership above and the recipient's balance can't realistically overflow.
1278         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1279         unchecked {
1280             // Updates:
1281             // - `balance -= 1`.
1282             // - `numberBurned += 1`.
1283             //
1284             // We can directly decrement the balance, and increment the number burned.
1285             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1286             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1287 
1288             // Updates:
1289             // - `address` to the last owner.
1290             // - `startTimestamp` to the timestamp of burning.
1291             // - `burned` to `true`.
1292             // - `nextInitialized` to `true`.
1293             _packedOwnerships[tokenId] = _packOwnershipData(
1294                 from,
1295                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1296             );
1297 
1298             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1299             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1300                 uint256 nextTokenId = tokenId + 1;
1301                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1302                 if (_packedOwnerships[nextTokenId] == 0) {
1303                     // If the next slot is within bounds.
1304                     if (nextTokenId != _currentIndex) {
1305                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1306                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1307                     }
1308                 }
1309             }
1310         }
1311 
1312         emit Transfer(from, address(0), tokenId);
1313         _afterTokenTransfers(from, address(0), tokenId, 1);
1314 
1315         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1316         unchecked {
1317             _burnCounter++;
1318         }
1319     }
1320 
1321     /**
1322      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkContractOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1337             bytes4 retval
1338         ) {
1339             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1340         } catch (bytes memory reason) {
1341             if (reason.length == 0) {
1342                 revert TransferToNonERC721ReceiverImplementer();
1343             } else {
1344                 assembly {
1345                     revert(add(32, reason), mload(reason))
1346                 }
1347             }
1348         }
1349     }
1350 
1351     /**
1352      * @dev Directly sets the extra data for the ownership data `index`.
1353      */
1354     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1355         uint256 packed = _packedOwnerships[index];
1356         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1357         uint256 extraDataCasted;
1358         // Cast `extraData` with assembly to avoid redundant masking.
1359         assembly {
1360             extraDataCasted := extraData
1361         }
1362         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1363         _packedOwnerships[index] = packed;
1364     }
1365 
1366     /**
1367      * @dev Returns the next extra data for the packed ownership data.
1368      * The returned result is shifted into position.
1369      */
1370     function _nextExtraData(
1371         address from,
1372         address to,
1373         uint256 prevOwnershipPacked
1374     ) private view returns (uint256) {
1375         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1376         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1377     }
1378 
1379     /**
1380      * @dev Called during each token transfer to set the 24bit `extraData` field.
1381      * Intended to be overridden by the cosumer contract.
1382      *
1383      * `previousExtraData` - the value of `extraData` before transfer.
1384      *
1385      * Calling conditions:
1386      *
1387      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1388      * transferred to `to`.
1389      * - When `from` is zero, `tokenId` will be minted for `to`.
1390      * - When `to` is zero, `tokenId` will be burned by `from`.
1391      * - `from` and `to` are never both zero.
1392      */
1393     function _extraData(
1394         address from,
1395         address to,
1396         uint24 previousExtraData
1397     ) internal view virtual returns (uint24) {}
1398 
1399     /**
1400      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1401      * This includes minting.
1402      * And also called before burning one token.
1403      *
1404      * startTokenId - the first token id to be transferred
1405      * quantity - the amount to be transferred
1406      *
1407      * Calling conditions:
1408      *
1409      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1410      * transferred to `to`.
1411      * - When `from` is zero, `tokenId` will be minted for `to`.
1412      * - When `to` is zero, `tokenId` will be burned by `from`.
1413      * - `from` and `to` are never both zero.
1414      */
1415     function _beforeTokenTransfers(
1416         address from,
1417         address to,
1418         uint256 startTokenId,
1419         uint256 quantity
1420     ) internal virtual {}
1421 
1422     /**
1423      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1424      * This includes minting.
1425      * And also called after one token has been burned.
1426      *
1427      * startTokenId - the first token id to be transferred
1428      * quantity - the amount to be transferred
1429      *
1430      * Calling conditions:
1431      *
1432      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1433      * transferred to `to`.
1434      * - When `from` is zero, `tokenId` has been minted for `to`.
1435      * - When `to` is zero, `tokenId` has been burned by `from`.
1436      * - `from` and `to` are never both zero.
1437      */
1438     function _afterTokenTransfers(
1439         address from,
1440         address to,
1441         uint256 startTokenId,
1442         uint256 quantity
1443     ) internal virtual {}
1444 
1445     /**
1446      * @dev Returns the message sender (defaults to `msg.sender`).
1447      *
1448      * If you are writing GSN compatible contracts, you need to override this function.
1449      */
1450     function _msgSenderERC721A() internal view virtual returns (address) {
1451         return msg.sender;
1452     }
1453 
1454     /**
1455      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1456      */
1457     function _toString(uint256 value) internal pure returns (string memory ptr) {
1458         assembly {
1459             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1460             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1461             // We will need 1 32-byte word to store the length,
1462             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1463             ptr := add(mload(0x40), 128)
1464             // Update the free memory pointer to allocate.
1465             mstore(0x40, ptr)
1466 
1467             // Cache the end of the memory to calculate the length later.
1468             let end := ptr
1469 
1470             // We write the string from the rightmost digit to the leftmost digit.
1471             // The following is essentially a do-while loop that also handles the zero case.
1472             // Costs a bit more than early returning for the zero case,
1473             // but cheaper in terms of deployment and overall runtime costs.
1474             for {
1475                 // Initialize and perform the first pass without check.
1476                 let temp := value
1477                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1478                 ptr := sub(ptr, 1)
1479                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1480                 mstore8(ptr, add(48, mod(temp, 10)))
1481                 temp := div(temp, 10)
1482             } temp {
1483                 // Keep dividing `temp` until zero.
1484                 temp := div(temp, 10)
1485             } {
1486                 // Body of the for loop.
1487                 ptr := sub(ptr, 1)
1488                 mstore8(ptr, add(48, mod(temp, 10)))
1489             }
1490 
1491             let length := sub(end, ptr)
1492             // Move the pointer 32 bytes leftwards to make room for the length.
1493             ptr := sub(ptr, 32)
1494             // Store the length.
1495             mstore(ptr, length)
1496         }
1497     }
1498 }
1499 
1500 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1501 
1502 
1503 // ERC721A Contracts v4.1.0
1504 // Creator: Chiru Labs
1505 
1506 pragma solidity ^0.8.4;
1507 
1508 
1509 /**
1510  * @dev Interface of an ERC721AQueryable compliant contract.
1511  */
1512 interface IERC721AQueryable is IERC721A {
1513     /**
1514      * Invalid query range (`start` >= `stop`).
1515      */
1516     error InvalidQueryRange();
1517 
1518     /**
1519      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1520      *
1521      * If the `tokenId` is out of bounds:
1522      *   - `addr` = `address(0)`
1523      *   - `startTimestamp` = `0`
1524      *   - `burned` = `false`
1525      *
1526      * If the `tokenId` is burned:
1527      *   - `addr` = `<Address of owner before token was burned>`
1528      *   - `startTimestamp` = `<Timestamp when token was burned>`
1529      *   - `burned = `true`
1530      *
1531      * Otherwise:
1532      *   - `addr` = `<Address of owner>`
1533      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1534      *   - `burned = `false`
1535      */
1536     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1537 
1538     /**
1539      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1540      * See {ERC721AQueryable-explicitOwnershipOf}
1541      */
1542     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1543 
1544     /**
1545      * @dev Returns an array of token IDs owned by `owner`,
1546      * in the range [`start`, `stop`)
1547      * (i.e. `start <= tokenId < stop`).
1548      *
1549      * This function allows for tokens to be queried if the collection
1550      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1551      *
1552      * Requirements:
1553      *
1554      * - `start` < `stop`
1555      */
1556     function tokensOfOwnerIn(
1557         address owner,
1558         uint256 start,
1559         uint256 stop
1560     ) external view returns (uint256[] memory);
1561 
1562     /**
1563      * @dev Returns an array of token IDs owned by `owner`.
1564      *
1565      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1566      * It is meant to be called off-chain.
1567      *
1568      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1569      * multiple smaller scans if the collection is large enough to cause
1570      * an out-of-gas error (10K pfp collections should be fine).
1571      */
1572     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1573 }
1574 
1575 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1576 
1577 
1578 // ERC721A Contracts v4.1.0
1579 // Creator: Chiru Labs
1580 
1581 pragma solidity ^0.8.4;
1582 
1583 
1584 
1585 /**
1586  * @title ERC721A Queryable
1587  * @dev ERC721A subclass with convenience query functions.
1588  */
1589 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1590     /**
1591      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1592      *
1593      * If the `tokenId` is out of bounds:
1594      *   - `addr` = `address(0)`
1595      *   - `startTimestamp` = `0`
1596      *   - `burned` = `false`
1597      *   - `extraData` = `0`
1598      *
1599      * If the `tokenId` is burned:
1600      *   - `addr` = `<Address of owner before token was burned>`
1601      *   - `startTimestamp` = `<Timestamp when token was burned>`
1602      *   - `burned = `true`
1603      *   - `extraData` = `<Extra data when token was burned>`
1604      *
1605      * Otherwise:
1606      *   - `addr` = `<Address of owner>`
1607      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1608      *   - `burned = `false`
1609      *   - `extraData` = `<Extra data at start of ownership>`
1610      */
1611     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1612         TokenOwnership memory ownership;
1613         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1614             return ownership;
1615         }
1616         ownership = _ownershipAt(tokenId);
1617         if (ownership.burned) {
1618             return ownership;
1619         }
1620         return _ownershipOf(tokenId);
1621     }
1622 
1623     /**
1624      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1625      * See {ERC721AQueryable-explicitOwnershipOf}
1626      */
1627     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1628         unchecked {
1629             uint256 tokenIdsLength = tokenIds.length;
1630             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1631             for (uint256 i; i != tokenIdsLength; ++i) {
1632                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1633             }
1634             return ownerships;
1635         }
1636     }
1637 
1638     /**
1639      * @dev Returns an array of token IDs owned by `owner`,
1640      * in the range [`start`, `stop`)
1641      * (i.e. `start <= tokenId < stop`).
1642      *
1643      * This function allows for tokens to be queried if the collection
1644      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1645      *
1646      * Requirements:
1647      *
1648      * - `start` < `stop`
1649      */
1650     function tokensOfOwnerIn(
1651         address owner,
1652         uint256 start,
1653         uint256 stop
1654     ) external view override returns (uint256[] memory) {
1655         unchecked {
1656             if (start >= stop) revert InvalidQueryRange();
1657             uint256 tokenIdsIdx;
1658             uint256 stopLimit = _nextTokenId();
1659             // Set `start = max(start, _startTokenId())`.
1660             if (start < _startTokenId()) {
1661                 start = _startTokenId();
1662             }
1663             // Set `stop = min(stop, stopLimit)`.
1664             if (stop > stopLimit) {
1665                 stop = stopLimit;
1666             }
1667             uint256 tokenIdsMaxLength = balanceOf(owner);
1668             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1669             // to cater for cases where `balanceOf(owner)` is too big.
1670             if (start < stop) {
1671                 uint256 rangeLength = stop - start;
1672                 if (rangeLength < tokenIdsMaxLength) {
1673                     tokenIdsMaxLength = rangeLength;
1674                 }
1675             } else {
1676                 tokenIdsMaxLength = 0;
1677             }
1678             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1679             if (tokenIdsMaxLength == 0) {
1680                 return tokenIds;
1681             }
1682             // We need to call `explicitOwnershipOf(start)`,
1683             // because the slot at `start` may not be initialized.
1684             TokenOwnership memory ownership = explicitOwnershipOf(start);
1685             address currOwnershipAddr;
1686             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1687             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1688             if (!ownership.burned) {
1689                 currOwnershipAddr = ownership.addr;
1690             }
1691             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1692                 ownership = _ownershipAt(i);
1693                 if (ownership.burned) {
1694                     continue;
1695                 }
1696                 if (ownership.addr != address(0)) {
1697                     currOwnershipAddr = ownership.addr;
1698                 }
1699                 if (currOwnershipAddr == owner) {
1700                     tokenIds[tokenIdsIdx++] = i;
1701                 }
1702             }
1703             // Downsize the array to fit.
1704             assembly {
1705                 mstore(tokenIds, tokenIdsIdx)
1706             }
1707             return tokenIds;
1708         }
1709     }
1710 
1711     /**
1712      * @dev Returns an array of token IDs owned by `owner`.
1713      *
1714      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1715      * It is meant to be called off-chain.
1716      *
1717      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1718      * multiple smaller scans if the collection is large enough to cause
1719      * an out-of-gas error (10K pfp collections should be fine).
1720      */
1721     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1722         unchecked {
1723             uint256 tokenIdsIdx;
1724             address currOwnershipAddr;
1725             uint256 tokenIdsLength = balanceOf(owner);
1726             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1727             TokenOwnership memory ownership;
1728             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1729                 ownership = _ownershipAt(i);
1730                 if (ownership.burned) {
1731                     continue;
1732                 }
1733                 if (ownership.addr != address(0)) {
1734                     currOwnershipAddr = ownership.addr;
1735                 }
1736                 if (currOwnershipAddr == owner) {
1737                     tokenIds[tokenIdsIdx++] = i;
1738                 }
1739             }
1740             return tokenIds;
1741         }
1742     }
1743 }
1744 
1745 
1746 
1747 pragma solidity >=0.8.9 <0.9.0;
1748 
1749 contract FuckLoganPaul is ERC721AQueryable, Ownable, ReentrancyGuard {
1750     using Strings for uint256;
1751 
1752     uint256 public maxSupply = 4000;
1753 	uint256 public Ownermint = 1;
1754     uint256 public maxPerAddress = 20;
1755 	uint256 public maxPerTX = 10;
1756     uint256 public cost = 0.001 ether;
1757 	mapping(address => bool) public freeMinted; 
1758 
1759     bool public paused = true;
1760 
1761 	string public uriPrefix = '';
1762     string public uriSuffix = '.json';
1763 	
1764   constructor(string memory baseURI) ERC721A("Fuck Logan Paul", "FKLP") {
1765       setUriPrefix(baseURI); 
1766       _safeMint(_msgSender(), Ownermint);
1767 
1768   }
1769 
1770   modifier callerIsUser() {
1771         require(tx.origin == msg.sender, "The caller is another contract");
1772         _;
1773   }
1774 
1775   function numberMinted(address owner) public view returns (uint256) {
1776         return _numberMinted(owner);
1777   }
1778 
1779   function mint (uint256 _mintAmount) public payable nonReentrant callerIsUser{
1780         require(!paused, 'The contract is paused!');
1781         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1782         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1783         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1784 	if (freeMinted[_msgSender()]){
1785         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1786   }
1787     else{
1788 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1789         freeMinted[_msgSender()] = true;
1790   }
1791 
1792     _safeMint(_msgSender(), _mintAmount);
1793   }
1794 
1795   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1796     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1797     string memory currentBaseURI = _baseURI();
1798     return bytes(currentBaseURI).length > 0
1799         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1800         : '';
1801   }
1802 
1803   function unpause() public onlyOwner {
1804     paused = !paused;
1805   }
1806 
1807   function setCost(uint256 _cost) public onlyOwner {
1808     cost = _cost;
1809   }
1810 
1811   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1812     maxPerTX = _maxPerTX;
1813   }
1814 
1815   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1816     uriPrefix = _uriPrefix;
1817   }
1818  
1819   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1820     uriSuffix = _uriSuffix;
1821   }
1822 
1823   function withdraw() external onlyOwner {
1824         payable(msg.sender).transfer(address(this).balance);
1825   }
1826 
1827   function _startTokenId() internal view virtual override returns (uint256) {
1828     return 1;
1829   }
1830 
1831   function _baseURI() internal view virtual override returns (string memory) {
1832     return uriPrefix;
1833   }
1834 }