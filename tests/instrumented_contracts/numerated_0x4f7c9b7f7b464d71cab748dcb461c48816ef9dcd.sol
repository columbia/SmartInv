1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-16
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
7 /**
8 DO NOT MINT                                                                                                        
9 */
10 
11 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Contract module that helps prevent reentrant calls to a function.
17  *
18  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
19  * available, which can be applied to functions to make sure there are no nested
20  * (reentrant) calls to them.
21  *
22  * Note that because there is a single `nonReentrant` guard, functions marked as
23  * `nonReentrant` may not call one another. This can be worked around by making
24  * those functions `private`, and then adding `external` `nonReentrant` entry
25  * points to them.
26  *
27  * TIP: If you would like to learn more about reentrancy and alternative ways
28  * to protect against it, check out our blog post
29  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
30  */
31 abstract contract ReentrancyGuard {
32     // Booleans are more expensive than uint256 or any type that takes up a full
33     // word because each write operation emits an extra SLOAD to first read the
34     // slot's contents, replace the bits taken up by the boolean, and then write
35     // back. This is the compiler's defense against contract upgrades and
36     // pointer aliasing, and it cannot be disabled.
37 
38     // The values being non-zero value makes deployment a bit more expensive,
39     // but in exchange the refund on every call to nonReentrant will be lower in
40     // amount. Since refunds are capped to a percentage of the total
41     // transaction's gas, it is best to keep them low in cases like this one, to
42     // increase the likelihood of the full refund coming into effect.
43     uint256 private constant _NOT_ENTERED = 1;
44     uint256 private constant _ENTERED = 2;
45 
46     uint256 private _status;
47 
48     constructor() {
49         _status = _NOT_ENTERED;
50     }
51 
52     /**
53      * @dev Prevents a contract from calling itself, directly or indirectly.
54      * Calling a `nonReentrant` function from another `nonReentrant`
55      * function is not supported. It is possible to prevent this from happening
56      * by making the `nonReentrant` function external, and making it call a
57      * `private` function that does the actual work.
58      */
59     modifier nonReentrant() {
60         // On the first call to nonReentrant, _notEntered will be true
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65 
66         _;
67 
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Strings.sol
75 
76 
77 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev String operations.
83  */
84 library Strings {
85     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
86     uint8 private constant _ADDRESS_LENGTH = 20;
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
90      */
91     function toString(uint256 value) internal pure returns (string memory) {
92         // Inspired by OraclizeAPI's implementation - MIT licence
93         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
94 
95         if (value == 0) {
96             return "0";
97         }
98         uint256 temp = value;
99         uint256 digits;
100         while (temp != 0) {
101             digits++;
102             temp /= 10;
103         }
104         bytes memory buffer = new bytes(digits);
105         while (value != 0) {
106             digits -= 1;
107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
108             value /= 10;
109         }
110         return string(buffer);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
115      */
116     function toHexString(uint256 value) internal pure returns (string memory) {
117         if (value == 0) {
118             return "0x00";
119         }
120         uint256 temp = value;
121         uint256 length = 0;
122         while (temp != 0) {
123             length++;
124             temp >>= 8;
125         }
126         return toHexString(value, length);
127     }
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
131      */
132     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
133         bytes memory buffer = new bytes(2 * length + 2);
134         buffer[0] = "0";
135         buffer[1] = "x";
136         for (uint256 i = 2 * length + 1; i > 1; --i) {
137             buffer[i] = _HEX_SYMBOLS[value & 0xf];
138             value >>= 4;
139         }
140         require(value == 0, "Strings: hex length insufficient");
141         return string(buffer);
142     }
143 
144     /**
145      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
146      */
147     function toHexString(address addr) internal pure returns (string memory) {
148         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
149     }
150 }
151 
152 
153 // File: @openzeppelin/contracts/utils/Context.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes calldata) {
176         return msg.data;
177     }
178 }
179 
180 // File: @openzeppelin/contracts/access/Ownable.sol
181 
182 
183 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 
188 /**
189  * @dev Contract module which provides a basic access control mechanism, where
190  * there is an account (an owner) that can be granted exclusive access to
191  * specific functions.
192  *
193  * By default, the owner account will be the one that deploys the contract. This
194  * can later be changed with {transferOwnership}.
195  *
196  * This module is used through inheritance. It will make available the modifier
197  * `onlyOwner`, which can be applied to your functions to restrict their use to
198  * the owner.
199  */
200 abstract contract Ownable is Context {
201     address private _owner;
202 
203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205     /**
206      * @dev Initializes the contract setting the deployer as the initial owner.
207      */
208     constructor() {
209         _transferOwnership(_msgSender());
210     }
211 
212     /**
213      * @dev Throws if called by any account other than the owner.
214      */
215     modifier onlyOwner() {
216         _checkOwner();
217         _;
218     }
219 
220     /**
221      * @dev Returns the address of the current owner.
222      */
223     function owner() public view virtual returns (address) {
224         return _owner;
225     }
226 
227     /**
228      * @dev Throws if the sender is not the owner.
229      */
230     function _checkOwner() internal view virtual {
231         require(owner() == _msgSender(), "Ownable: caller is not the owner");
232     }
233 
234     /**
235      * @dev Leaves the contract without owner. It will not be possible to call
236      * `onlyOwner` functions anymore. Can only be called by the current owner.
237      *
238      * NOTE: Renouncing ownership will leave the contract without an owner,
239      * thereby removing any functionality that is only available to the owner.
240      */
241     function renounceOwnership() public virtual onlyOwner {
242         _transferOwnership(address(0));
243     }
244 
245     /**
246      * @dev Transfers ownership of the contract to a new account (`newOwner`).
247      * Can only be called by the current owner.
248      */
249     function transferOwnership(address newOwner) public virtual onlyOwner {
250         require(newOwner != address(0), "Ownable: new owner is the zero address");
251         _transferOwnership(newOwner);
252     }
253 
254     /**
255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
256      * Internal function without access restriction.
257      */
258     function _transferOwnership(address newOwner) internal virtual {
259         address oldOwner = _owner;
260         _owner = newOwner;
261         emit OwnershipTransferred(oldOwner, newOwner);
262     }
263 }
264 
265 // File: erc721a/contracts/IERC721A.sol
266 
267 
268 // ERC721A Contracts v4.1.0
269 // Creator: Chiru Labs
270 
271 pragma solidity ^0.8.4;
272 
273 /**
274  * @dev Interface of an ERC721A compliant contract.
275  */
276 interface IERC721A {
277     /**
278      * The caller must own the token or be an approved operator.
279      */
280     error ApprovalCallerNotOwnerNorApproved();
281 
282     /**
283      * The token does not exist.
284      */
285     error ApprovalQueryForNonexistentToken();
286 
287     /**
288      * The caller cannot approve to their own address.
289      */
290     error ApproveToCaller();
291 
292     /**
293      * Cannot query the balance for the zero address.
294      */
295     error BalanceQueryForZeroAddress();
296 
297     /**
298      * Cannot mint to the zero address.
299      */
300     error MintToZeroAddress();
301 
302     /**
303      * The quantity of tokens minted must be more than zero.
304      */
305     error MintZeroQuantity();
306 
307     /**
308      * The token does not exist.
309      */
310     error OwnerQueryForNonexistentToken();
311 
312     /**
313      * The caller must own the token or be an approved operator.
314      */
315     error TransferCallerNotOwnerNorApproved();
316 
317     /**
318      * The token must be owned by `from`.
319      */
320     error TransferFromIncorrectOwner();
321 
322     /**
323      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
324      */
325     error TransferToNonERC721ReceiverImplementer();
326 
327     /**
328      * Cannot transfer to the zero address.
329      */
330     error TransferToZeroAddress();
331 
332     /**
333      * The token does not exist.
334      */
335     error URIQueryForNonexistentToken();
336 
337     /**
338      * The `quantity` minted with ERC2309 exceeds the safety limit.
339      */
340     error MintERC2309QuantityExceedsLimit();
341 
342     /**
343      * The `extraData` cannot be set on an unintialized ownership slot.
344      */
345     error OwnershipNotInitializedForExtraData();
346 
347     struct TokenOwnership {
348         // The address of the owner.
349         address addr;
350         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
351         uint64 startTimestamp;
352         // Whether the token has been burned.
353         bool burned;
354         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
355         uint24 extraData;
356     }
357 
358     /**
359      * @dev Returns the total amount of tokens stored by the contract.
360      *
361      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     // ==============================
366     //            IERC165
367     // ==============================
368 
369     /**
370      * @dev Returns true if this contract implements the interface defined by
371      * `interfaceId`. See the corresponding
372      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
373      * to learn more about how these ids are created.
374      *
375      * This function call must use less than 30 000 gas.
376      */
377     function supportsInterface(bytes4 interfaceId) external view returns (bool);
378 
379     // ==============================
380     //            IERC721
381     // ==============================
382 
383     /**
384      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
385      */
386     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
387 
388     /**
389      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
390      */
391     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
392 
393     /**
394      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
395      */
396     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
397 
398     /**
399      * @dev Returns the number of tokens in ``owner``'s account.
400      */
401     function balanceOf(address owner) external view returns (uint256 balance);
402 
403     /**
404      * @dev Returns the owner of the `tokenId` token.
405      *
406      * Requirements:
407      *
408      * - `tokenId` must exist.
409      */
410     function ownerOf(uint256 tokenId) external view returns (address owner);
411 
412     /**
413      * @dev Safely transfers `tokenId` token from `from` to `to`.
414      *
415      * Requirements:
416      *
417      * - `from` cannot be the zero address.
418      * - `to` cannot be the zero address.
419      * - `tokenId` token must exist and be owned by `from`.
420      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
421      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
422      *
423      * Emits a {Transfer} event.
424      */
425     function safeTransferFrom(
426         address from,
427         address to,
428         uint256 tokenId,
429         bytes calldata data
430     ) external;
431 
432     /**
433      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
434      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `tokenId` token must exist and be owned by `from`.
441      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
442      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
443      *
444      * Emits a {Transfer} event.
445      */
446     function safeTransferFrom(
447         address from,
448         address to,
449         uint256 tokenId
450     ) external;
451 
452     /**
453      * @dev Transfers `tokenId` token from `from` to `to`.
454      *
455      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must be owned by `from`.
462      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
463      *
464      * Emits a {Transfer} event.
465      */
466     function transferFrom(
467         address from,
468         address to,
469         uint256 tokenId
470     ) external;
471 
472     /**
473      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
474      * The approval is cleared when the token is transferred.
475      *
476      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
477      *
478      * Requirements:
479      *
480      * - The caller must own the token or be an approved operator.
481      * - `tokenId` must exist.
482      *
483      * Emits an {Approval} event.
484      */
485     function approve(address to, uint256 tokenId) external;
486 
487     /**
488      * @dev Approve or remove `operator` as an operator for the caller.
489      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
490      *
491      * Requirements:
492      *
493      * - The `operator` cannot be the caller.
494      *
495      * Emits an {ApprovalForAll} event.
496      */
497     function setApprovalForAll(address operator, bool _approved) external;
498 
499     /**
500      * @dev Returns the account approved for `tokenId` token.
501      *
502      * Requirements:
503      *
504      * - `tokenId` must exist.
505      */
506     function getApproved(uint256 tokenId) external view returns (address operator);
507 
508     /**
509      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
510      *
511      * See {setApprovalForAll}
512      */
513     function isApprovedForAll(address owner, address operator) external view returns (bool);
514 
515     // ==============================
516     //        IERC721Metadata
517     // ==============================
518 
519     /**
520      * @dev Returns the token collection name.
521      */
522     function name() external view returns (string memory);
523 
524     /**
525      * @dev Returns the token collection symbol.
526      */
527     function symbol() external view returns (string memory);
528 
529     /**
530      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
531      */
532     function tokenURI(uint256 tokenId) external view returns (string memory);
533 
534     // ==============================
535     //            IERC2309
536     // ==============================
537 
538     /**
539      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
540      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
541      */
542     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
543 }
544 
545 // File: erc721a/contracts/ERC721A.sol
546 
547 
548 // ERC721A Contracts v4.1.0
549 // Creator: Chiru Labs
550 
551 pragma solidity ^0.8.4;
552 
553 
554 /**
555  * @dev ERC721 token receiver interface.
556  */
557 interface ERC721A__IERC721Receiver {
558     function onERC721Received(
559         address operator,
560         address from,
561         uint256 tokenId,
562         bytes calldata data
563     ) external returns (bytes4);
564 }
565 
566 /**
567  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
568  * including the Metadata extension. Built to optimize for lower gas during batch mints.
569  *
570  * Assumes serials are sequentially minted starting at `_startTokenId()`
571  * (defaults to 0, e.g. 0, 1, 2, 3..).
572  *
573  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
574  *
575  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
576  */
577 contract ERC721A is IERC721A {
578     // Mask of an entry in packed address data.
579     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
580 
581     // The bit position of `numberMinted` in packed address data.
582     uint256 private constant BITPOS_NUMBER_MINTED = 64;
583 
584     // The bit position of `numberBurned` in packed address data.
585     uint256 private constant BITPOS_NUMBER_BURNED = 128;
586 
587     // The bit position of `aux` in packed address data.
588     uint256 private constant BITPOS_AUX = 192;
589 
590     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
591     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
592 
593     // The bit position of `startTimestamp` in packed ownership.
594     uint256 private constant BITPOS_START_TIMESTAMP = 160;
595 
596     // The bit mask of the `burned` bit in packed ownership.
597     uint256 private constant BITMASK_BURNED = 1 << 224;
598 
599     // The bit position of the `nextInitialized` bit in packed ownership.
600     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
601 
602     // The bit mask of the `nextInitialized` bit in packed ownership.
603     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
604 
605     // The bit position of `extraData` in packed ownership.
606     uint256 private constant BITPOS_EXTRA_DATA = 232;
607 
608     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
609     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
610 
611     // The mask of the lower 160 bits for addresses.
612     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
613 
614     // The maximum `quantity` that can be minted with `_mintERC2309`.
615     // This limit is to prevent overflows on the address data entries.
616     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
617     // is required to cause an overflow, which is unrealistic.
618     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
619 
620     // The tokenId of the next token to be minted.
621     uint256 private _currentIndex;
622 
623     // The number of tokens burned.
624     uint256 private _burnCounter;
625 
626     // Token name
627     string private _name;
628 
629     // Token symbol
630     string private _symbol;
631 
632     // Mapping from token ID to ownership details
633     // An empty struct value does not necessarily mean the token is unowned.
634     // See `_packedOwnershipOf` implementation for details.
635     //
636     // Bits Layout:
637     // - [0..159]   `addr`
638     // - [160..223] `startTimestamp`
639     // - [224]      `burned`
640     // - [225]      `nextInitialized`
641     // - [232..255] `extraData`
642     mapping(uint256 => uint256) private _packedOwnerships;
643 
644     // Mapping owner address to address data.
645     //
646     // Bits Layout:
647     // - [0..63]    `balance`
648     // - [64..127]  `numberMinted`
649     // - [128..191] `numberBurned`
650     // - [192..255] `aux`
651     mapping(address => uint256) private _packedAddressData;
652 
653     // Mapping from token ID to approved address.
654     mapping(uint256 => address) private _tokenApprovals;
655 
656     // Mapping from owner to operator approvals
657     mapping(address => mapping(address => bool)) private _operatorApprovals;
658 
659     constructor(string memory name_, string memory symbol_) {
660         _name = name_;
661         _symbol = symbol_;
662         _currentIndex = _startTokenId();
663     }
664 
665     /**
666      * @dev Returns the starting token ID.
667      * To change the starting token ID, please override this function.
668      */
669     function _startTokenId() internal view virtual returns (uint256) {
670         return 0;
671     }
672 
673     /**
674      * @dev Returns the next token ID to be minted.
675      */
676     function _nextTokenId() internal view returns (uint256) {
677         return _currentIndex;
678     }
679 
680     /**
681      * @dev Returns the total number of tokens in existence.
682      * Burned tokens will reduce the count.
683      * To get the total number of tokens minted, please see `_totalMinted`.
684      */
685     function totalSupply() public view override returns (uint256) {
686         // Counter underflow is impossible as _burnCounter cannot be incremented
687         // more than `_currentIndex - _startTokenId()` times.
688         unchecked {
689             return _currentIndex - _burnCounter - _startTokenId();
690         }
691     }
692 
693     /**
694      * @dev Returns the total amount of tokens minted in the contract.
695      */
696     function _totalMinted() internal view returns (uint256) {
697         // Counter underflow is impossible as _currentIndex does not decrement,
698         // and it is initialized to `_startTokenId()`
699         unchecked {
700             return _currentIndex - _startTokenId();
701         }
702     }
703 
704     /**
705      * @dev Returns the total number of tokens burned.
706      */
707     function _totalBurned() internal view returns (uint256) {
708         return _burnCounter;
709     }
710 
711     /**
712      * @dev See {IERC165-supportsInterface}.
713      */
714     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
715         // The interface IDs are constants representing the first 4 bytes of the XOR of
716         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
717         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
718         return
719             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
720             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
721             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
722     }
723 
724     /**
725      * @dev See {IERC721-balanceOf}.
726      */
727     function balanceOf(address owner) public view override returns (uint256) {
728         if (owner == address(0)) revert BalanceQueryForZeroAddress();
729         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
730     }
731 
732     /**
733      * Returns the number of tokens minted by `owner`.
734      */
735     function _numberMinted(address owner) internal view returns (uint256) {
736         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
737     }
738 
739     /**
740      * Returns the number of tokens burned by or on behalf of `owner`.
741      */
742     function _numberBurned(address owner) internal view returns (uint256) {
743         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
744     }
745 
746     /**
747      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
748      */
749     function _getAux(address owner) internal view returns (uint64) {
750         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
751     }
752 
753     /**
754      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
755      * If there are multiple variables, please pack them into a uint64.
756      */
757     function _setAux(address owner, uint64 aux) internal {
758         uint256 packed = _packedAddressData[owner];
759         uint256 auxCasted;
760         // Cast `aux` with assembly to avoid redundant masking.
761         assembly {
762             auxCasted := aux
763         }
764         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
765         _packedAddressData[owner] = packed;
766     }
767 
768     /**
769      * Returns the packed ownership data of `tokenId`.
770      */
771     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
772         uint256 curr = tokenId;
773 
774         unchecked {
775             if (_startTokenId() <= curr)
776                 if (curr < _currentIndex) {
777                     uint256 packed = _packedOwnerships[curr];
778                     // If not burned.
779                     if (packed & BITMASK_BURNED == 0) {
780                         // Invariant:
781                         // There will always be an ownership that has an address and is not burned
782                         // before an ownership that does not have an address and is not burned.
783                         // Hence, curr will not underflow.
784                         //
785                         // We can directly compare the packed value.
786                         // If the address is zero, packed is zero.
787                         while (packed == 0) {
788                             packed = _packedOwnerships[--curr];
789                         }
790                         return packed;
791                     }
792                 }
793         }
794         revert OwnerQueryForNonexistentToken();
795     }
796 
797     /**
798      * Returns the unpacked `TokenOwnership` struct from `packed`.
799      */
800     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
801         ownership.addr = address(uint160(packed));
802         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
803         ownership.burned = packed & BITMASK_BURNED != 0;
804         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
805     }
806 
807     /**
808      * Returns the unpacked `TokenOwnership` struct at `index`.
809      */
810     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
811         return _unpackedOwnership(_packedOwnerships[index]);
812     }
813 
814     /**
815      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
816      */
817     function _initializeOwnershipAt(uint256 index) internal {
818         if (_packedOwnerships[index] == 0) {
819             _packedOwnerships[index] = _packedOwnershipOf(index);
820         }
821     }
822 
823     /**
824      * Gas spent here starts off proportional to the maximum mint batch size.
825      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
826      */
827     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
828         return _unpackedOwnership(_packedOwnershipOf(tokenId));
829     }
830 
831     /**
832      * @dev Packs ownership data into a single uint256.
833      */
834     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
835         assembly {
836             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
837             owner := and(owner, BITMASK_ADDRESS)
838             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
839             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
840         }
841     }
842 
843     /**
844      * @dev See {IERC721-ownerOf}.
845      */
846     function ownerOf(uint256 tokenId) public view override returns (address) {
847         return address(uint160(_packedOwnershipOf(tokenId)));
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, it can be overridden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return '';
881     }
882 
883     /**
884      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
885      */
886     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
887         // For branchless setting of the `nextInitialized` flag.
888         assembly {
889             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
890             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
891         }
892     }
893 
894     /**
895      * @dev See {IERC721-approve}.
896      */
897     function approve(address to, uint256 tokenId) public override {
898         address owner = ownerOf(tokenId);
899 
900         if (_msgSenderERC721A() != owner)
901             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
902                 revert ApprovalCallerNotOwnerNorApproved();
903             }
904 
905         _tokenApprovals[tokenId] = to;
906         emit Approval(owner, to, tokenId);
907     }
908 
909     /**
910      * @dev See {IERC721-getApproved}.
911      */
912     function getApproved(uint256 tokenId) public view override returns (address) {
913         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
914 
915         return _tokenApprovals[tokenId];
916     }
917 
918     /**
919      * @dev See {IERC721-setApprovalForAll}.
920      */
921     function setApprovalForAll(address operator, bool approved) public virtual override {
922         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
923 
924         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
925         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
926     }
927 
928     /**
929      * @dev See {IERC721-isApprovedForAll}.
930      */
931     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
932         return _operatorApprovals[owner][operator];
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public virtual override {
943         safeTransferFrom(from, to, tokenId, '');
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) public virtual override {
955         transferFrom(from, to, tokenId);
956         if (to.code.length != 0)
957             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
958                 revert TransferToNonERC721ReceiverImplementer();
959             }
960     }
961 
962     /**
963      * @dev Returns whether `tokenId` exists.
964      *
965      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
966      *
967      * Tokens start existing when they are minted (`_mint`),
968      */
969     function _exists(uint256 tokenId) internal view returns (bool) {
970         return
971             _startTokenId() <= tokenId &&
972             tokenId < _currentIndex && // If within bounds,
973             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
974     }
975 
976     /**
977      * @dev Equivalent to `_safeMint(to, quantity, '')`.
978      */
979     function _safeMint(address to, uint256 quantity) internal {
980         _safeMint(to, quantity, '');
981     }
982 
983     /**
984      * @dev Safely mints `quantity` tokens and transfers them to `to`.
985      *
986      * Requirements:
987      *
988      * - If `to` refers to a smart contract, it must implement
989      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
990      * - `quantity` must be greater than 0.
991      *
992      * See {_mint}.
993      *
994      * Emits a {Transfer} event for each mint.
995      */
996     function _safeMint(
997         address to,
998         uint256 quantity,
999         bytes memory _data
1000     ) internal {
1001         _mint(to, quantity);
1002 
1003         unchecked {
1004             if (to.code.length != 0) {
1005                 uint256 end = _currentIndex;
1006                 uint256 index = end - quantity;
1007                 do {
1008                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1009                         revert TransferToNonERC721ReceiverImplementer();
1010                     }
1011                 } while (index < end);
1012                 // Reentrancy protection.
1013                 if (_currentIndex != end) revert();
1014             }
1015         }
1016     }
1017 
1018     /**
1019      * @dev Mints `quantity` tokens and transfers them to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `quantity` must be greater than 0.
1025      *
1026      * Emits a {Transfer} event for each mint.
1027      */
1028     function _mint(address to, uint256 quantity) internal {
1029         uint256 startTokenId = _currentIndex;
1030         if (to == address(0)) revert MintToZeroAddress();
1031         if (quantity == 0) revert MintZeroQuantity();
1032 
1033         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1034 
1035         // Overflows are incredibly unrealistic.
1036         // `balance` and `numberMinted` have a maximum limit of 2**64.
1037         // `tokenId` has a maximum limit of 2**256.
1038         unchecked {
1039             // Updates:
1040             // - `balance += quantity`.
1041             // - `numberMinted += quantity`.
1042             //
1043             // We can directly add to the `balance` and `numberMinted`.
1044             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1045 
1046             // Updates:
1047             // - `address` to the owner.
1048             // - `startTimestamp` to the timestamp of minting.
1049             // - `burned` to `false`.
1050             // - `nextInitialized` to `quantity == 1`.
1051             _packedOwnerships[startTokenId] = _packOwnershipData(
1052                 to,
1053                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1054             );
1055 
1056             uint256 tokenId = startTokenId;
1057             uint256 end = startTokenId + quantity;
1058             do {
1059                 emit Transfer(address(0), to, tokenId++);
1060             } while (tokenId < end);
1061 
1062             _currentIndex = end;
1063         }
1064         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1065     }
1066 
1067     /**
1068      * @dev Mints `quantity` tokens and transfers them to `to`.
1069      *
1070      * This function is intended for efficient minting only during contract creation.
1071      *
1072      * It emits only one {ConsecutiveTransfer} as defined in
1073      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1074      * instead of a sequence of {Transfer} event(s).
1075      *
1076      * Calling this function outside of contract creation WILL make your contract
1077      * non-compliant with the ERC721 standard.
1078      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1079      * {ConsecutiveTransfer} event is only permissible during contract creation.
1080      *
1081      * Requirements:
1082      *
1083      * - `to` cannot be the zero address.
1084      * - `quantity` must be greater than 0.
1085      *
1086      * Emits a {ConsecutiveTransfer} event.
1087      */
1088     function _mintERC2309(address to, uint256 quantity) internal {
1089         uint256 startTokenId = _currentIndex;
1090         if (to == address(0)) revert MintToZeroAddress();
1091         if (quantity == 0) revert MintZeroQuantity();
1092         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1093 
1094         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1095 
1096         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1097         unchecked {
1098             // Updates:
1099             // - `balance += quantity`.
1100             // - `numberMinted += quantity`.
1101             //
1102             // We can directly add to the `balance` and `numberMinted`.
1103             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1104 
1105             // Updates:
1106             // - `address` to the owner.
1107             // - `startTimestamp` to the timestamp of minting.
1108             // - `burned` to `false`.
1109             // - `nextInitialized` to `quantity == 1`.
1110             _packedOwnerships[startTokenId] = _packOwnershipData(
1111                 to,
1112                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1113             );
1114 
1115             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1116 
1117             _currentIndex = startTokenId + quantity;
1118         }
1119         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1120     }
1121 
1122     /**
1123      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1124      */
1125     function _getApprovedAddress(uint256 tokenId)
1126         private
1127         view
1128         returns (uint256 approvedAddressSlot, address approvedAddress)
1129     {
1130         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1131         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1132         assembly {
1133             // Compute the slot.
1134             mstore(0x00, tokenId)
1135             mstore(0x20, tokenApprovalsPtr.slot)
1136             approvedAddressSlot := keccak256(0x00, 0x40)
1137             // Load the slot's value from storage.
1138             approvedAddress := sload(approvedAddressSlot)
1139         }
1140     }
1141 
1142     /**
1143      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1144      */
1145     function _isOwnerOrApproved(
1146         address approvedAddress,
1147         address from,
1148         address msgSender
1149     ) private pure returns (bool result) {
1150         assembly {
1151             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1152             from := and(from, BITMASK_ADDRESS)
1153             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1154             msgSender := and(msgSender, BITMASK_ADDRESS)
1155             // `msgSender == from || msgSender == approvedAddress`.
1156             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1157         }
1158     }
1159 
1160     /**
1161      * @dev Transfers `tokenId` from `from` to `to`.
1162      *
1163      * Requirements:
1164      *
1165      * - `to` cannot be the zero address.
1166      * - `tokenId` token must be owned by `from`.
1167      *
1168      * Emits a {Transfer} event.
1169      */
1170     function transferFrom(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) public virtual override {
1175         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1176 
1177         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1178 
1179         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1180 
1181         // The nested ifs save around 20+ gas over a compound boolean condition.
1182         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1183             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1184 
1185         if (to == address(0)) revert TransferToZeroAddress();
1186 
1187         _beforeTokenTransfers(from, to, tokenId, 1);
1188 
1189         // Clear approvals from the previous owner.
1190         assembly {
1191             if approvedAddress {
1192                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1193                 sstore(approvedAddressSlot, 0)
1194             }
1195         }
1196 
1197         // Underflow of the sender's balance is impossible because we check for
1198         // ownership above and the recipient's balance can't realistically overflow.
1199         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1200         unchecked {
1201             // We can directly increment and decrement the balances.
1202             --_packedAddressData[from]; // Updates: `balance -= 1`.
1203             ++_packedAddressData[to]; // Updates: `balance += 1`.
1204 
1205             // Updates:
1206             // - `address` to the next owner.
1207             // - `startTimestamp` to the timestamp of transfering.
1208             // - `burned` to `false`.
1209             // - `nextInitialized` to `true`.
1210             _packedOwnerships[tokenId] = _packOwnershipData(
1211                 to,
1212                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1213             );
1214 
1215             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1216             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1217                 uint256 nextTokenId = tokenId + 1;
1218                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1219                 if (_packedOwnerships[nextTokenId] == 0) {
1220                     // If the next slot is within bounds.
1221                     if (nextTokenId != _currentIndex) {
1222                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1223                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1224                     }
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(from, to, tokenId);
1230         _afterTokenTransfers(from, to, tokenId, 1);
1231     }
1232 
1233     /**
1234      * @dev Equivalent to `_burn(tokenId, false)`.
1235      */
1236     function _burn(uint256 tokenId) internal virtual {
1237         _burn(tokenId, false);
1238     }
1239 
1240     /**
1241      * @dev Destroys `tokenId`.
1242      * The approval is cleared when the token is burned.
1243      *
1244      * Requirements:
1245      *
1246      * - `tokenId` must exist.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1251         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1252 
1253         address from = address(uint160(prevOwnershipPacked));
1254 
1255         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1256 
1257         if (approvalCheck) {
1258             // The nested ifs save around 20+ gas over a compound boolean condition.
1259             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1260                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1261         }
1262 
1263         _beforeTokenTransfers(from, address(0), tokenId, 1);
1264 
1265         // Clear approvals from the previous owner.
1266         assembly {
1267             if approvedAddress {
1268                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1269                 sstore(approvedAddressSlot, 0)
1270             }
1271         }
1272 
1273         // Underflow of the sender's balance is impossible because we check for
1274         // ownership above and the recipient's balance can't realistically overflow.
1275         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1276         unchecked {
1277             // Updates:
1278             // - `balance -= 1`.
1279             // - `numberBurned += 1`.
1280             //
1281             // We can directly decrement the balance, and increment the number burned.
1282             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1283             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1284 
1285             // Updates:
1286             // - `address` to the last owner.
1287             // - `startTimestamp` to the timestamp of burning.
1288             // - `burned` to `true`.
1289             // - `nextInitialized` to `true`.
1290             _packedOwnerships[tokenId] = _packOwnershipData(
1291                 from,
1292                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1293             );
1294 
1295             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1296             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1297                 uint256 nextTokenId = tokenId + 1;
1298                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1299                 if (_packedOwnerships[nextTokenId] == 0) {
1300                     // If the next slot is within bounds.
1301                     if (nextTokenId != _currentIndex) {
1302                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1303                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1304                     }
1305                 }
1306             }
1307         }
1308 
1309         emit Transfer(from, address(0), tokenId);
1310         _afterTokenTransfers(from, address(0), tokenId, 1);
1311 
1312         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1313         unchecked {
1314             _burnCounter++;
1315         }
1316     }
1317 
1318     /**
1319      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1320      *
1321      * @param from address representing the previous owner of the given token ID
1322      * @param to target address that will receive the tokens
1323      * @param tokenId uint256 ID of the token to be transferred
1324      * @param _data bytes optional data to send along with the call
1325      * @return bool whether the call correctly returned the expected magic value
1326      */
1327     function _checkContractOnERC721Received(
1328         address from,
1329         address to,
1330         uint256 tokenId,
1331         bytes memory _data
1332     ) private returns (bool) {
1333         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1334             bytes4 retval
1335         ) {
1336             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1337         } catch (bytes memory reason) {
1338             if (reason.length == 0) {
1339                 revert TransferToNonERC721ReceiverImplementer();
1340             } else {
1341                 assembly {
1342                     revert(add(32, reason), mload(reason))
1343                 }
1344             }
1345         }
1346     }
1347 
1348     /**
1349      * @dev Directly sets the extra data for the ownership data `index`.
1350      */
1351     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1352         uint256 packed = _packedOwnerships[index];
1353         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1354         uint256 extraDataCasted;
1355         // Cast `extraData` with assembly to avoid redundant masking.
1356         assembly {
1357             extraDataCasted := extraData
1358         }
1359         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1360         _packedOwnerships[index] = packed;
1361     }
1362 
1363     /**
1364      * @dev Returns the next extra data for the packed ownership data.
1365      * The returned result is shifted into position.
1366      */
1367     function _nextExtraData(
1368         address from,
1369         address to,
1370         uint256 prevOwnershipPacked
1371     ) private view returns (uint256) {
1372         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1373         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1374     }
1375 
1376     /**
1377      * @dev Called during each token transfer to set the 24bit `extraData` field.
1378      * Intended to be overridden by the cosumer contract.
1379      *
1380      * `previousExtraData` - the value of `extraData` before transfer.
1381      *
1382      * Calling conditions:
1383      *
1384      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1385      * transferred to `to`.
1386      * - When `from` is zero, `tokenId` will be minted for `to`.
1387      * - When `to` is zero, `tokenId` will be burned by `from`.
1388      * - `from` and `to` are never both zero.
1389      */
1390     function _extraData(
1391         address from,
1392         address to,
1393         uint24 previousExtraData
1394     ) internal view virtual returns (uint24) {}
1395 
1396     /**
1397      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1398      * This includes minting.
1399      * And also called before burning one token.
1400      *
1401      * startTokenId - the first token id to be transferred
1402      * quantity - the amount to be transferred
1403      *
1404      * Calling conditions:
1405      *
1406      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1407      * transferred to `to`.
1408      * - When `from` is zero, `tokenId` will be minted for `to`.
1409      * - When `to` is zero, `tokenId` will be burned by `from`.
1410      * - `from` and `to` are never both zero.
1411      */
1412     function _beforeTokenTransfers(
1413         address from,
1414         address to,
1415         uint256 startTokenId,
1416         uint256 quantity
1417     ) internal virtual {}
1418 
1419     /**
1420      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1421      * This includes minting.
1422      * And also called after one token has been burned.
1423      *
1424      * startTokenId - the first token id to be transferred
1425      * quantity - the amount to be transferred
1426      *
1427      * Calling conditions:
1428      *
1429      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1430      * transferred to `to`.
1431      * - When `from` is zero, `tokenId` has been minted for `to`.
1432      * - When `to` is zero, `tokenId` has been burned by `from`.
1433      * - `from` and `to` are never both zero.
1434      */
1435     function _afterTokenTransfers(
1436         address from,
1437         address to,
1438         uint256 startTokenId,
1439         uint256 quantity
1440     ) internal virtual {}
1441 
1442     /**
1443      * @dev Returns the message sender (defaults to `msg.sender`).
1444      *
1445      * If you are writing GSN compatible contracts, you need to override this function.
1446      */
1447     function _msgSenderERC721A() internal view virtual returns (address) {
1448         return msg.sender;
1449     }
1450 
1451     /**
1452      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1453      */
1454     function _toString(uint256 value) internal pure returns (string memory ptr) {
1455         assembly {
1456             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1457             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1458             // We will need 1 32-byte word to store the length,
1459             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1460             ptr := add(mload(0x40), 128)
1461             // Update the free memory pointer to allocate.
1462             mstore(0x40, ptr)
1463 
1464             // Cache the end of the memory to calculate the length later.
1465             let end := ptr
1466 
1467             // We write the string from the rightmost digit to the leftmost digit.
1468             // The following is essentially a do-while loop that also handles the zero case.
1469             // Costs a bit more than early returning for the zero case,
1470             // but cheaper in terms of deployment and overall runtime costs.
1471             for {
1472                 // Initialize and perform the first pass without check.
1473                 let temp := value
1474                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1475                 ptr := sub(ptr, 1)
1476                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1477                 mstore8(ptr, add(48, mod(temp, 10)))
1478                 temp := div(temp, 10)
1479             } temp {
1480                 // Keep dividing `temp` until zero.
1481                 temp := div(temp, 10)
1482             } {
1483                 // Body of the for loop.
1484                 ptr := sub(ptr, 1)
1485                 mstore8(ptr, add(48, mod(temp, 10)))
1486             }
1487 
1488             let length := sub(end, ptr)
1489             // Move the pointer 32 bytes leftwards to make room for the length.
1490             ptr := sub(ptr, 32)
1491             // Store the length.
1492             mstore(ptr, length)
1493         }
1494     }
1495 }
1496 
1497 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1498 
1499 
1500 // ERC721A Contracts v4.1.0
1501 // Creator: Chiru Labs
1502 
1503 pragma solidity ^0.8.4;
1504 
1505 
1506 /**
1507  * @dev Interface of an ERC721AQueryable compliant contract.
1508  */
1509 interface IERC721AQueryable is IERC721A {
1510     /**
1511      * Invalid query range (`start` >= `stop`).
1512      */
1513     error InvalidQueryRange();
1514 
1515     /**
1516      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1517      *
1518      * If the `tokenId` is out of bounds:
1519      *   - `addr` = `address(0)`
1520      *   - `startTimestamp` = `0`
1521      *   - `burned` = `false`
1522      *
1523      * If the `tokenId` is burned:
1524      *   - `addr` = `<Address of owner before token was burned>`
1525      *   - `startTimestamp` = `<Timestamp when token was burned>`
1526      *   - `burned = `true`
1527      *
1528      * Otherwise:
1529      *   - `addr` = `<Address of owner>`
1530      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1531      *   - `burned = `false`
1532      */
1533     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1534 
1535     /**
1536      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1537      * See {ERC721AQueryable-explicitOwnershipOf}
1538      */
1539     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1540 
1541     /**
1542      * @dev Returns an array of token IDs owned by `owner`,
1543      * in the range [`start`, `stop`)
1544      * (i.e. `start <= tokenId < stop`).
1545      *
1546      * This function allows for tokens to be queried if the collection
1547      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1548      *
1549      * Requirements:
1550      *
1551      * - `start` < `stop`
1552      */
1553     function tokensOfOwnerIn(
1554         address owner,
1555         uint256 start,
1556         uint256 stop
1557     ) external view returns (uint256[] memory);
1558 
1559     /**
1560      * @dev Returns an array of token IDs owned by `owner`.
1561      *
1562      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1563      * It is meant to be called off-chain.
1564      *
1565      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1566      * multiple smaller scans if the collection is large enough to cause
1567      * an out-of-gas error (10K pfp collections should be fine).
1568      */
1569     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1570 }
1571 
1572 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1573 
1574 
1575 // ERC721A Contracts v4.1.0
1576 // Creator: Chiru Labs
1577 
1578 pragma solidity ^0.8.4;
1579 
1580 
1581 
1582 /**
1583  * @title ERC721A Queryable
1584  * @dev ERC721A subclass with convenience query functions.
1585  */
1586 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1587     /**
1588      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1589      *
1590      * If the `tokenId` is out of bounds:
1591      *   - `addr` = `address(0)`
1592      *   - `startTimestamp` = `0`
1593      *   - `burned` = `false`
1594      *   - `extraData` = `0`
1595      *
1596      * If the `tokenId` is burned:
1597      *   - `addr` = `<Address of owner before token was burned>`
1598      *   - `startTimestamp` = `<Timestamp when token was burned>`
1599      *   - `burned = `true`
1600      *   - `extraData` = `<Extra data when token was burned>`
1601      *
1602      * Otherwise:
1603      *   - `addr` = `<Address of owner>`
1604      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1605      *   - `burned = `false`
1606      *   - `extraData` = `<Extra data at start of ownership>`
1607      */
1608     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1609         TokenOwnership memory ownership;
1610         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1611             return ownership;
1612         }
1613         ownership = _ownershipAt(tokenId);
1614         if (ownership.burned) {
1615             return ownership;
1616         }
1617         return _ownershipOf(tokenId);
1618     }
1619 
1620     /**
1621      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1622      * See {ERC721AQueryable-explicitOwnershipOf}
1623      */
1624     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1625         unchecked {
1626             uint256 tokenIdsLength = tokenIds.length;
1627             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1628             for (uint256 i; i != tokenIdsLength; ++i) {
1629                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1630             }
1631             return ownerships;
1632         }
1633     }
1634 
1635     /**
1636      * @dev Returns an array of token IDs owned by `owner`,
1637      * in the range [`start`, `stop`)
1638      * (i.e. `start <= tokenId < stop`).
1639      *
1640      * This function allows for tokens to be queried if the collection
1641      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1642      *
1643      * Requirements:
1644      *
1645      * - `start` < `stop`
1646      */
1647     function tokensOfOwnerIn(
1648         address owner,
1649         uint256 start,
1650         uint256 stop
1651     ) external view override returns (uint256[] memory) {
1652         unchecked {
1653             if (start >= stop) revert InvalidQueryRange();
1654             uint256 tokenIdsIdx;
1655             uint256 stopLimit = _nextTokenId();
1656             // Set `start = max(start, _startTokenId())`.
1657             if (start < _startTokenId()) {
1658                 start = _startTokenId();
1659             }
1660             // Set `stop = min(stop, stopLimit)`.
1661             if (stop > stopLimit) {
1662                 stop = stopLimit;
1663             }
1664             uint256 tokenIdsMaxLength = balanceOf(owner);
1665             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1666             // to cater for cases where `balanceOf(owner)` is too big.
1667             if (start < stop) {
1668                 uint256 rangeLength = stop - start;
1669                 if (rangeLength < tokenIdsMaxLength) {
1670                     tokenIdsMaxLength = rangeLength;
1671                 }
1672             } else {
1673                 tokenIdsMaxLength = 0;
1674             }
1675             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1676             if (tokenIdsMaxLength == 0) {
1677                 return tokenIds;
1678             }
1679             // We need to call `explicitOwnershipOf(start)`,
1680             // because the slot at `start` may not be initialized.
1681             TokenOwnership memory ownership = explicitOwnershipOf(start);
1682             address currOwnershipAddr;
1683             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1684             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1685             if (!ownership.burned) {
1686                 currOwnershipAddr = ownership.addr;
1687             }
1688             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1689                 ownership = _ownershipAt(i);
1690                 if (ownership.burned) {
1691                     continue;
1692                 }
1693                 if (ownership.addr != address(0)) {
1694                     currOwnershipAddr = ownership.addr;
1695                 }
1696                 if (currOwnershipAddr == owner) {
1697                     tokenIds[tokenIdsIdx++] = i;
1698                 }
1699             }
1700             // Downsize the array to fit.
1701             assembly {
1702                 mstore(tokenIds, tokenIdsIdx)
1703             }
1704             return tokenIds;
1705         }
1706     }
1707 
1708     /**
1709      * @dev Returns an array of token IDs owned by `owner`.
1710      *
1711      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1712      * It is meant to be called off-chain.
1713      *
1714      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1715      * multiple smaller scans if the collection is large enough to cause
1716      * an out-of-gas error (10K pfp collections should be fine).
1717      */
1718     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1719         unchecked {
1720             uint256 tokenIdsIdx;
1721             address currOwnershipAddr;
1722             uint256 tokenIdsLength = balanceOf(owner);
1723             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1724             TokenOwnership memory ownership;
1725             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1726                 ownership = _ownershipAt(i);
1727                 if (ownership.burned) {
1728                     continue;
1729                 }
1730                 if (ownership.addr != address(0)) {
1731                     currOwnershipAddr = ownership.addr;
1732                 }
1733                 if (currOwnershipAddr == owner) {
1734                     tokenIds[tokenIdsIdx++] = i;
1735                 }
1736             }
1737             return tokenIds;
1738         }
1739     }
1740 }
1741 
1742 
1743 
1744 pragma solidity >=0.8.9 <0.9.0;
1745 
1746 contract DONOTMINT is ERC721AQueryable, Ownable, ReentrancyGuard {
1747     using Strings for uint256;
1748 
1749     uint256 public maxSupply = 2666;
1750 	uint256 public Ownermint = 6;
1751     uint256 public maxPerAddress = 666;
1752 	uint256 public maxPerTX = 6;
1753     uint256 public cost = 0.006 ether;
1754 	mapping(address => bool) public freeMinted; 
1755 
1756     bool public paused = true;
1757 
1758 	string public uriPrefix = '';
1759 	
1760   constructor(string memory baseURI) ERC721A("DO NOT MINT", "DNMINT") {
1761       setUriPrefix(baseURI); 
1762       _safeMint(_msgSender(), Ownermint);
1763 
1764   }
1765 
1766   modifier callerIsUser() {
1767         require(tx.origin == msg.sender, "The caller is another contract");
1768         _;
1769   }
1770 
1771   function numberMinted(address owner) public view returns (uint256) {
1772         return _numberMinted(owner);
1773   }
1774 
1775   function mint(uint256 _mintAmount) public payable nonReentrant callerIsUser{
1776         require(!paused, 'The contract is paused!');
1777         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1778         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1779         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1780 	if (freeMinted[_msgSender()]){
1781         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1782   }
1783     else{
1784 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1785         freeMinted[_msgSender()] = true;
1786   }
1787 
1788     _safeMint(_msgSender(), _mintAmount);
1789   }
1790 
1791   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1792     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1793     string memory currentBaseURI = _baseURI();
1794     return bytes(currentBaseURI).length > 0
1795         ? string(abi.encodePacked(currentBaseURI))
1796         : '';
1797   }
1798 
1799   function setPaused() public onlyOwner {
1800     paused = !paused;
1801   }
1802 
1803   function setCost(uint256 _cost) public onlyOwner {
1804     cost = _cost;
1805   }
1806 
1807   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1808     maxPerTX = _maxPerTX;
1809   }
1810 
1811   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1812     uriPrefix = _uriPrefix;
1813   }
1814 
1815   function withdraw() external onlyOwner {
1816         payable(msg.sender).transfer(address(this).balance);
1817   }
1818 
1819   function _startTokenId() internal view virtual override returns (uint256) {
1820     return 1;
1821   }
1822 
1823   function _baseURI() internal view virtual override returns (string memory) {
1824     return uriPrefix;
1825   }
1826 }