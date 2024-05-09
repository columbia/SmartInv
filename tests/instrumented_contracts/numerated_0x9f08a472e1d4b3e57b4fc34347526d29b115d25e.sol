1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-18
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-18
11 */
12 
13 // SPDX-License-Identifier: MIT
14 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
15 /**
16 Where am i?.......                                   
17                                                                            
18 */
19 
20 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Contract module that helps prevent reentrant calls to a function.
26  *
27  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
28  * available, which can be applied to functions to make sure there are no nested
29  * (reentrant) calls to them.
30  *
31  * Note that because there is a single `nonReentrant` guard, functions marked as
32  * `nonReentrant` may not call one another. This can be worked around by making
33  * those functions `private`, and then adding `external` `nonReentrant` entry
34  * points to them.
35  *
36  * TIP: If you would like to learn more about reentrancy and alternative ways
37  * to protect against it, check out our blog post
38  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
39  */
40 abstract contract ReentrancyGuard {
41     // Booleans are more expensive than uint256 or any type that takes up a full
42     // word because each write operation emits an extra SLOAD to first read the
43     // slot's contents, replace the bits taken up by the boolean, and then write
44     // back. This is the compiler's defense against contract upgrades and
45     // pointer aliasing, and it cannot be disabled.
46 
47     // The values being non-zero value makes deployment a bit more expensive,
48     // but in exchange the refund on every call to nonReentrant will be lower in
49     // amount. Since refunds are capped to a percentage of the total
50     // transaction's gas, it is best to keep them low in cases like this one, to
51     // increase the likelihood of the full refund coming into effect.
52     uint256 private constant _NOT_ENTERED = 1;
53     uint256 private constant _ENTERED = 2;
54 
55     uint256 private _status;
56 
57     constructor() {
58         _status = _NOT_ENTERED;
59     }
60 
61     /**
62      * @dev Prevents a contract from calling itself, directly or indirectly.
63      * Calling a `nonReentrant` function from another `nonReentrant`
64      * function is not supported. It is possible to prevent this from happening
65      * by making the `nonReentrant` function external, and making it call a
66      * `private` function that does the actual work.
67      */
68     modifier nonReentrant() {
69         // On the first call to nonReentrant, _notEntered will be true
70         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
71 
72         // Any calls to nonReentrant after this point will fail
73         _status = _ENTERED;
74 
75         _;
76 
77         // By storing the original value once again, a refund is triggered (see
78         // https://eips.ethereum.org/EIPS/eip-2200)
79         _status = _NOT_ENTERED;
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/Strings.sol
84 
85 
86 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev String operations.
92  */
93 library Strings {
94     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
95     uint8 private constant _ADDRESS_LENGTH = 20;
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
152 
153     /**
154      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
155      */
156     function toHexString(address addr) internal pure returns (string memory) {
157         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
158     }
159 }
160 
161 
162 // File: @openzeppelin/contracts/utils/Context.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @dev Provides information about the current execution context, including the
171  * sender of the transaction and its data. While these are generally available
172  * via msg.sender and msg.data, they should not be accessed in such a direct
173  * manner, since when dealing with meta-transactions the account sending and
174  * paying for execution may not be the actual sender (as far as an application
175  * is concerned).
176  *
177  * This contract is only required for intermediate, library-like contracts.
178  */
179 abstract contract Context {
180     function _msgSender() internal view virtual returns (address) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view virtual returns (bytes calldata) {
185         return msg.data;
186     }
187 }
188 
189 // File: @openzeppelin/contracts/access/Ownable.sol
190 
191 
192 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 
197 /**
198  * @dev Contract module which provides a basic access control mechanism, where
199  * there is an account (an owner) that can be granted exclusive access to
200  * specific functions.
201  *
202  * By default, the owner account will be the one that deploys the contract. This
203  * can later be changed with {transferOwnership}.
204  *
205  * This module is used through inheritance. It will make available the modifier
206  * `onlyOwner`, which can be applied to your functions to restrict their use to
207  * the owner.
208  */
209 abstract contract Ownable is Context {
210     address private _owner;
211 
212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214     /**
215      * @dev Initializes the contract setting the deployer as the initial owner.
216      */
217     constructor() {
218         _transferOwnership(_msgSender());
219     }
220 
221     /**
222      * @dev Throws if called by any account other than the owner.
223      */
224     modifier onlyOwner() {
225         _checkOwner();
226         _;
227     }
228 
229     /**
230      * @dev Returns the address of the current owner.
231      */
232     function owner() public view virtual returns (address) {
233         return _owner;
234     }
235 
236     /**
237      * @dev Throws if the sender is not the owner.
238      */
239     function _checkOwner() internal view virtual {
240         require(owner() == _msgSender(), "Ownable: caller is not the owner");
241     }
242 
243     /**
244      * @dev Leaves the contract without owner. It will not be possible to call
245      * `onlyOwner` functions anymore. Can only be called by the current owner.
246      *
247      * NOTE: Renouncing ownership will leave the contract without an owner,
248      * thereby removing any functionality that is only available to the owner.
249      */
250     function renounceOwnership() public virtual onlyOwner {
251         _transferOwnership(address(0));
252     }
253 
254     /**
255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
256      * Can only be called by the current owner.
257      */
258     function transferOwnership(address newOwner) public virtual onlyOwner {
259         require(newOwner != address(0), "Ownable: new owner is the zero address");
260         _transferOwnership(newOwner);
261     }
262 
263     /**
264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
265      * Internal function without access restriction.
266      */
267     function _transferOwnership(address newOwner) internal virtual {
268         address oldOwner = _owner;
269         _owner = newOwner;
270         emit OwnershipTransferred(oldOwner, newOwner);
271     }
272 }
273 
274 // File: erc721a/contracts/IERC721A.sol
275 
276 
277 // ERC721A Contracts v4.1.0
278 // Creator: Chiru Labs
279 
280 pragma solidity ^0.8.4;
281 
282 /**
283  * @dev Interface of an ERC721A compliant contract.
284  */
285 interface IERC721A {
286     /**
287      * The caller must own the token or be an approved operator.
288      */
289     error ApprovalCallerNotOwnerNorApproved();
290 
291     /**
292      * The token does not exist.
293      */
294     error ApprovalQueryForNonexistentToken();
295 
296     /**
297      * The caller cannot approve to their own address.
298      */
299     error ApproveToCaller();
300 
301     /**
302      * Cannot query the balance for the zero address.
303      */
304     error BalanceQueryForZeroAddress();
305 
306     /**
307      * Cannot mint to the zero address.
308      */
309     error MintToZeroAddress();
310 
311     /**
312      * The quantity of tokens minted must be more than zero.
313      */
314     error MintZeroQuantity();
315 
316     /**
317      * The token does not exist.
318      */
319     error OwnerQueryForNonexistentToken();
320 
321     /**
322      * The caller must own the token or be an approved operator.
323      */
324     error TransferCallerNotOwnerNorApproved();
325 
326     /**
327      * The token must be owned by `from`.
328      */
329     error TransferFromIncorrectOwner();
330 
331     /**
332      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
333      */
334     error TransferToNonERC721ReceiverImplementer();
335 
336     /**
337      * Cannot transfer to the zero address.
338      */
339     error TransferToZeroAddress();
340 
341     /**
342      * The token does not exist.
343      */
344     error URIQueryForNonexistentToken();
345 
346     /**
347      * The `quantity` minted with ERC2309 exceeds the safety limit.
348      */
349     error MintERC2309QuantityExceedsLimit();
350 
351     /**
352      * The `extraData` cannot be set on an unintialized ownership slot.
353      */
354     error OwnershipNotInitializedForExtraData();
355 
356     struct TokenOwnership {
357         // The address of the owner.
358         address addr;
359         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
360         uint64 startTimestamp;
361         // Whether the token has been burned.
362         bool burned;
363         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
364         uint24 extraData;
365     }
366 
367     /**
368      * @dev Returns the total amount of tokens stored by the contract.
369      *
370      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
371      */
372     function totalSupply() external view returns (uint256);
373 
374     // ==============================
375     //            IERC165
376     // ==============================
377 
378     /**
379      * @dev Returns true if this contract implements the interface defined by
380      * `interfaceId`. See the corresponding
381      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
382      * to learn more about how these ids are created.
383      *
384      * This function call must use less than 30 000 gas.
385      */
386     function supportsInterface(bytes4 interfaceId) external view returns (bool);
387 
388     // ==============================
389     //            IERC721
390     // ==============================
391 
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`.
423      *
424      * Requirements:
425      *
426      * - `from` cannot be the zero address.
427      * - `to` cannot be the zero address.
428      * - `tokenId` token must exist and be owned by `from`.
429      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
430      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
431      *
432      * Emits a {Transfer} event.
433      */
434     function safeTransferFrom(
435         address from,
436         address to,
437         uint256 tokenId,
438         bytes calldata data
439     ) external;
440 
441     /**
442      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
443      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
444      *
445      * Requirements:
446      *
447      * - `from` cannot be the zero address.
448      * - `to` cannot be the zero address.
449      * - `tokenId` token must exist and be owned by `from`.
450      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
451      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
452      *
453      * Emits a {Transfer} event.
454      */
455     function safeTransferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Transfers `tokenId` token from `from` to `to`.
463      *
464      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
465      *
466      * Requirements:
467      *
468      * - `from` cannot be the zero address.
469      * - `to` cannot be the zero address.
470      * - `tokenId` token must be owned by `from`.
471      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
472      *
473      * Emits a {Transfer} event.
474      */
475     function transferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) external;
480 
481     /**
482      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
483      * The approval is cleared when the token is transferred.
484      *
485      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
486      *
487      * Requirements:
488      *
489      * - The caller must own the token or be an approved operator.
490      * - `tokenId` must exist.
491      *
492      * Emits an {Approval} event.
493      */
494     function approve(address to, uint256 tokenId) external;
495 
496     /**
497      * @dev Approve or remove `operator` as an operator for the caller.
498      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
499      *
500      * Requirements:
501      *
502      * - The `operator` cannot be the caller.
503      *
504      * Emits an {ApprovalForAll} event.
505      */
506     function setApprovalForAll(address operator, bool _approved) external;
507 
508     /**
509      * @dev Returns the account approved for `tokenId` token.
510      *
511      * Requirements:
512      *
513      * - `tokenId` must exist.
514      */
515     function getApproved(uint256 tokenId) external view returns (address operator);
516 
517     /**
518      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
519      *
520      * See {setApprovalForAll}
521      */
522     function isApprovedForAll(address owner, address operator) external view returns (bool);
523 
524     // ==============================
525     //        IERC721Metadata
526     // ==============================
527 
528     /**
529      * @dev Returns the token collection name.
530      */
531     function name() external view returns (string memory);
532 
533     /**
534      * @dev Returns the token collection symbol.
535      */
536     function symbol() external view returns (string memory);
537 
538     /**
539      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
540      */
541     function tokenURI(uint256 tokenId) external view returns (string memory);
542 
543     // ==============================
544     //            IERC2309
545     // ==============================
546 
547     /**
548      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
549      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
550      */
551     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
552 }
553 
554 // File: erc721a/contracts/ERC721A.sol
555 
556 
557 // ERC721A Contracts v4.1.0
558 // Creator: Chiru Labs
559 
560 pragma solidity ^0.8.4;
561 
562 
563 /**
564  * @dev ERC721 token receiver interface.
565  */
566 interface ERC721A__IERC721Receiver {
567     function onERC721Received(
568         address operator,
569         address from,
570         uint256 tokenId,
571         bytes calldata data
572     ) external returns (bytes4);
573 }
574 
575 /**
576  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
577  * including the Metadata extension. Built to optimize for lower gas during batch mints.
578  *
579  * Assumes serials are sequentially minted starting at `_startTokenId()`
580  * (defaults to 0, e.g. 0, 1, 2, 3..).
581  *
582  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
583  *
584  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
585  */
586 contract ERC721A is IERC721A {
587     // Mask of an entry in packed address data.
588     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
589 
590     // The bit position of `numberMinted` in packed address data.
591     uint256 private constant BITPOS_NUMBER_MINTED = 64;
592 
593     // The bit position of `numberBurned` in packed address data.
594     uint256 private constant BITPOS_NUMBER_BURNED = 128;
595 
596     // The bit position of `aux` in packed address data.
597     uint256 private constant BITPOS_AUX = 192;
598 
599     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
600     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
601 
602     // The bit position of `startTimestamp` in packed ownership.
603     uint256 private constant BITPOS_START_TIMESTAMP = 160;
604 
605     // The bit mask of the `burned` bit in packed ownership.
606     uint256 private constant BITMASK_BURNED = 1 << 224;
607 
608     // The bit position of the `nextInitialized` bit in packed ownership.
609     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
610 
611     // The bit mask of the `nextInitialized` bit in packed ownership.
612     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
613 
614     // The bit position of `extraData` in packed ownership.
615     uint256 private constant BITPOS_EXTRA_DATA = 232;
616 
617     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
618     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
619 
620     // The mask of the lower 160 bits for addresses.
621     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
622 
623     // The maximum `quantity` that can be minted with `_mintERC2309`.
624     // This limit is to prevent overflows on the address data entries.
625     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
626     // is required to cause an overflow, which is unrealistic.
627     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
628 
629     // The tokenId of the next token to be minted.
630     uint256 private _currentIndex;
631 
632     // The number of tokens burned.
633     uint256 private _burnCounter;
634 
635     // Token name
636     string private _name;
637 
638     // Token symbol
639     string private _symbol;
640 
641     // Mapping from token ID to ownership details
642     // An empty struct value does not necessarily mean the token is unowned.
643     // See `_packedOwnershipOf` implementation for details.
644     //
645     // Bits Layout:
646     // - [0..159]   `addr`
647     // - [160..223] `startTimestamp`
648     // - [224]      `burned`
649     // - [225]      `nextInitialized`
650     // - [232..255] `extraData`
651     mapping(uint256 => uint256) private _packedOwnerships;
652 
653     // Mapping owner address to address data.
654     //
655     // Bits Layout:
656     // - [0..63]    `balance`
657     // - [64..127]  `numberMinted`
658     // - [128..191] `numberBurned`
659     // - [192..255] `aux`
660     mapping(address => uint256) private _packedAddressData;
661 
662     // Mapping from token ID to approved address.
663     mapping(uint256 => address) private _tokenApprovals;
664 
665     // Mapping from owner to operator approvals
666     mapping(address => mapping(address => bool)) private _operatorApprovals;
667 
668     constructor(string memory name_, string memory symbol_) {
669         _name = name_;
670         _symbol = symbol_;
671         _currentIndex = _startTokenId();
672     }
673 
674     /**
675      * @dev Returns the starting token ID.
676      * To change the starting token ID, please override this function.
677      */
678     function _startTokenId() internal view virtual returns (uint256) {
679         return 0;
680     }
681 
682     /**
683      * @dev Returns the next token ID to be minted.
684      */
685     function _nextTokenId() internal view returns (uint256) {
686         return _currentIndex;
687     }
688 
689     /**
690      * @dev Returns the total number of tokens in existence.
691      * Burned tokens will reduce the count.
692      * To get the total number of tokens minted, please see `_totalMinted`.
693      */
694     function totalSupply() public view override returns (uint256) {
695         // Counter underflow is impossible as _burnCounter cannot be incremented
696         // more than `_currentIndex - _startTokenId()` times.
697         unchecked {
698             return _currentIndex - _burnCounter - _startTokenId();
699         }
700     }
701 
702     /**
703      * @dev Returns the total amount of tokens minted in the contract.
704      */
705     function _totalMinted() internal view returns (uint256) {
706         // Counter underflow is impossible as _currentIndex does not decrement,
707         // and it is initialized to `_startTokenId()`
708         unchecked {
709             return _currentIndex - _startTokenId();
710         }
711     }
712 
713     /**
714      * @dev Returns the total number of tokens burned.
715      */
716     function _totalBurned() internal view returns (uint256) {
717         return _burnCounter;
718     }
719 
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
724         // The interface IDs are constants representing the first 4 bytes of the XOR of
725         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
726         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
727         return
728             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
729             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
730             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
731     }
732 
733     /**
734      * @dev See {IERC721-balanceOf}.
735      */
736     function balanceOf(address owner) public view override returns (uint256) {
737         if (owner == address(0)) revert BalanceQueryForZeroAddress();
738         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
739     }
740 
741     /**
742      * Returns the number of tokens minted by `owner`.
743      */
744     function _numberMinted(address owner) internal view returns (uint256) {
745         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
746     }
747 
748     /**
749      * Returns the number of tokens burned by or on behalf of `owner`.
750      */
751     function _numberBurned(address owner) internal view returns (uint256) {
752         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
753     }
754 
755     /**
756      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
757      */
758     function _getAux(address owner) internal view returns (uint64) {
759         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
760     }
761 
762     /**
763      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
764      * If there are multiple variables, please pack them into a uint64.
765      */
766     function _setAux(address owner, uint64 aux) internal {
767         uint256 packed = _packedAddressData[owner];
768         uint256 auxCasted;
769         // Cast `aux` with assembly to avoid redundant masking.
770         assembly {
771             auxCasted := aux
772         }
773         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
774         _packedAddressData[owner] = packed;
775     }
776 
777     /**
778      * Returns the packed ownership data of `tokenId`.
779      */
780     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
781         uint256 curr = tokenId;
782 
783         unchecked {
784             if (_startTokenId() <= curr)
785                 if (curr < _currentIndex) {
786                     uint256 packed = _packedOwnerships[curr];
787                     // If not burned.
788                     if (packed & BITMASK_BURNED == 0) {
789                         // Invariant:
790                         // There will always be an ownership that has an address and is not burned
791                         // before an ownership that does not have an address and is not burned.
792                         // Hence, curr will not underflow.
793                         //
794                         // We can directly compare the packed value.
795                         // If the address is zero, packed is zero.
796                         while (packed == 0) {
797                             packed = _packedOwnerships[--curr];
798                         }
799                         return packed;
800                     }
801                 }
802         }
803         revert OwnerQueryForNonexistentToken();
804     }
805 
806     /**
807      * Returns the unpacked `TokenOwnership` struct from `packed`.
808      */
809     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
810         ownership.addr = address(uint160(packed));
811         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
812         ownership.burned = packed & BITMASK_BURNED != 0;
813         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
814     }
815 
816     /**
817      * Returns the unpacked `TokenOwnership` struct at `index`.
818      */
819     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
820         return _unpackedOwnership(_packedOwnerships[index]);
821     }
822 
823     /**
824      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
825      */
826     function _initializeOwnershipAt(uint256 index) internal {
827         if (_packedOwnerships[index] == 0) {
828             _packedOwnerships[index] = _packedOwnershipOf(index);
829         }
830     }
831 
832     /**
833      * Gas spent here starts off proportional to the maximum mint batch size.
834      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
835      */
836     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
837         return _unpackedOwnership(_packedOwnershipOf(tokenId));
838     }
839 
840     /**
841      * @dev Packs ownership data into a single uint256.
842      */
843     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
844         assembly {
845             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
846             owner := and(owner, BITMASK_ADDRESS)
847             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
848             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
849         }
850     }
851 
852     /**
853      * @dev See {IERC721-ownerOf}.
854      */
855     function ownerOf(uint256 tokenId) public view override returns (address) {
856         return address(uint160(_packedOwnershipOf(tokenId)));
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-name}.
861      */
862     function name() public view virtual override returns (string memory) {
863         return _name;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-symbol}.
868      */
869     function symbol() public view virtual override returns (string memory) {
870         return _symbol;
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-tokenURI}.
875      */
876     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
877         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
878 
879         string memory baseURI = _baseURI();
880         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
881     }
882 
883     /**
884      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
885      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
886      * by default, it can be overridden in child contracts.
887      */
888     function _baseURI() internal view virtual returns (string memory) {
889         return '';
890     }
891 
892     /**
893      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
894      */
895     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
896         // For branchless setting of the `nextInitialized` flag.
897         assembly {
898             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
899             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
900         }
901     }
902 
903     /**
904      * @dev See {IERC721-approve}.
905      */
906     function approve(address to, uint256 tokenId) public override {
907         address owner = ownerOf(tokenId);
908 
909         if (_msgSenderERC721A() != owner)
910             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
911                 revert ApprovalCallerNotOwnerNorApproved();
912             }
913 
914         _tokenApprovals[tokenId] = to;
915         emit Approval(owner, to, tokenId);
916     }
917 
918     /**
919      * @dev See {IERC721-getApproved}.
920      */
921     function getApproved(uint256 tokenId) public view override returns (address) {
922         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
923 
924         return _tokenApprovals[tokenId];
925     }
926 
927     /**
928      * @dev See {IERC721-setApprovalForAll}.
929      */
930     function setApprovalForAll(address operator, bool approved) public virtual override {
931         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
932 
933         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
934         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
935     }
936 
937     /**
938      * @dev See {IERC721-isApprovedForAll}.
939      */
940     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
941         return _operatorApprovals[owner][operator];
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId
951     ) public virtual override {
952         safeTransferFrom(from, to, tokenId, '');
953     }
954 
955     /**
956      * @dev See {IERC721-safeTransferFrom}.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) public virtual override {
964         transferFrom(from, to, tokenId);
965         if (to.code.length != 0)
966             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
967                 revert TransferToNonERC721ReceiverImplementer();
968             }
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted (`_mint`),
977      */
978     function _exists(uint256 tokenId) internal view returns (bool) {
979         return
980             _startTokenId() <= tokenId &&
981             tokenId < _currentIndex && // If within bounds,
982             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
983     }
984 
985     /**
986      * @dev Equivalent to `_safeMint(to, quantity, '')`.
987      */
988     function _safeMint(address to, uint256 quantity) internal {
989         _safeMint(to, quantity, '');
990     }
991 
992     /**
993      * @dev Safely mints `quantity` tokens and transfers them to `to`.
994      *
995      * Requirements:
996      *
997      * - If `to` refers to a smart contract, it must implement
998      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
999      * - `quantity` must be greater than 0.
1000      *
1001      * See {_mint}.
1002      *
1003      * Emits a {Transfer} event for each mint.
1004      */
1005     function _safeMint(
1006         address to,
1007         uint256 quantity,
1008         bytes memory _data
1009     ) internal {
1010         _mint(to, quantity);
1011 
1012         unchecked {
1013             if (to.code.length != 0) {
1014                 uint256 end = _currentIndex;
1015                 uint256 index = end - quantity;
1016                 do {
1017                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1018                         revert TransferToNonERC721ReceiverImplementer();
1019                     }
1020                 } while (index < end);
1021                 // Reentrancy protection.
1022                 if (_currentIndex != end) revert();
1023             }
1024         }
1025     }
1026 
1027     /**
1028      * @dev Mints `quantity` tokens and transfers them to `to`.
1029      *
1030      * Requirements:
1031      *
1032      * - `to` cannot be the zero address.
1033      * - `quantity` must be greater than 0.
1034      *
1035      * Emits a {Transfer} event for each mint.
1036      */
1037     function _mint(address to, uint256 quantity) internal {
1038         uint256 startTokenId = _currentIndex;
1039         if (to == address(0)) revert MintToZeroAddress();
1040         if (quantity == 0) revert MintZeroQuantity();
1041 
1042         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1043 
1044         // Overflows are incredibly unrealistic.
1045         // `balance` and `numberMinted` have a maximum limit of 2**64.
1046         // `tokenId` has a maximum limit of 2**256.
1047         unchecked {
1048             // Updates:
1049             // - `balance += quantity`.
1050             // - `numberMinted += quantity`.
1051             //
1052             // We can directly add to the `balance` and `numberMinted`.
1053             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1054 
1055             // Updates:
1056             // - `address` to the owner.
1057             // - `startTimestamp` to the timestamp of minting.
1058             // - `burned` to `false`.
1059             // - `nextInitialized` to `quantity == 1`.
1060             _packedOwnerships[startTokenId] = _packOwnershipData(
1061                 to,
1062                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1063             );
1064 
1065             uint256 tokenId = startTokenId;
1066             uint256 end = startTokenId + quantity;
1067             do {
1068                 emit Transfer(address(0), to, tokenId++);
1069             } while (tokenId < end);
1070 
1071             _currentIndex = end;
1072         }
1073         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1074     }
1075 
1076     /**
1077      * @dev Mints `quantity` tokens and transfers them to `to`.
1078      *
1079      * This function is intended for efficient minting only during contract creation.
1080      *
1081      * It emits only one {ConsecutiveTransfer} as defined in
1082      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1083      * instead of a sequence of {Transfer} event(s).
1084      *
1085      * Calling this function outside of contract creation WILL make your contract
1086      * non-compliant with the ERC721 standard.
1087      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1088      * {ConsecutiveTransfer} event is only permissible during contract creation.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {ConsecutiveTransfer} event.
1096      */
1097     function _mintERC2309(address to, uint256 quantity) internal {
1098         uint256 startTokenId = _currentIndex;
1099         if (to == address(0)) revert MintToZeroAddress();
1100         if (quantity == 0) revert MintZeroQuantity();
1101         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1106         unchecked {
1107             // Updates:
1108             // - `balance += quantity`.
1109             // - `numberMinted += quantity`.
1110             //
1111             // We can directly add to the `balance` and `numberMinted`.
1112             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1113 
1114             // Updates:
1115             // - `address` to the owner.
1116             // - `startTimestamp` to the timestamp of minting.
1117             // - `burned` to `false`.
1118             // - `nextInitialized` to `quantity == 1`.
1119             _packedOwnerships[startTokenId] = _packOwnershipData(
1120                 to,
1121                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1122             );
1123 
1124             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1125 
1126             _currentIndex = startTokenId + quantity;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1133      */
1134     function _getApprovedAddress(uint256 tokenId)
1135         private
1136         view
1137         returns (uint256 approvedAddressSlot, address approvedAddress)
1138     {
1139         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1140         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1141         assembly {
1142             // Compute the slot.
1143             mstore(0x00, tokenId)
1144             mstore(0x20, tokenApprovalsPtr.slot)
1145             approvedAddressSlot := keccak256(0x00, 0x40)
1146             // Load the slot's value from storage.
1147             approvedAddress := sload(approvedAddressSlot)
1148         }
1149     }
1150 
1151     /**
1152      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1153      */
1154     function _isOwnerOrApproved(
1155         address approvedAddress,
1156         address from,
1157         address msgSender
1158     ) private pure returns (bool result) {
1159         assembly {
1160             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1161             from := and(from, BITMASK_ADDRESS)
1162             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1163             msgSender := and(msgSender, BITMASK_ADDRESS)
1164             // `msgSender == from || msgSender == approvedAddress`.
1165             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1166         }
1167     }
1168 
1169     /**
1170      * @dev Transfers `tokenId` from `from` to `to`.
1171      *
1172      * Requirements:
1173      *
1174      * - `to` cannot be the zero address.
1175      * - `tokenId` token must be owned by `from`.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function transferFrom(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) public virtual override {
1184         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1185 
1186         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1187 
1188         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1189 
1190         // The nested ifs save around 20+ gas over a compound boolean condition.
1191         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1192             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1193 
1194         if (to == address(0)) revert TransferToZeroAddress();
1195 
1196         _beforeTokenTransfers(from, to, tokenId, 1);
1197 
1198         // Clear approvals from the previous owner.
1199         assembly {
1200             if approvedAddress {
1201                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1202                 sstore(approvedAddressSlot, 0)
1203             }
1204         }
1205 
1206         // Underflow of the sender's balance is impossible because we check for
1207         // ownership above and the recipient's balance can't realistically overflow.
1208         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1209         unchecked {
1210             // We can directly increment and decrement the balances.
1211             --_packedAddressData[from]; // Updates: `balance -= 1`.
1212             ++_packedAddressData[to]; // Updates: `balance += 1`.
1213 
1214             // Updates:
1215             // - `address` to the next owner.
1216             // - `startTimestamp` to the timestamp of transfering.
1217             // - `burned` to `false`.
1218             // - `nextInitialized` to `true`.
1219             _packedOwnerships[tokenId] = _packOwnershipData(
1220                 to,
1221                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1222             );
1223 
1224             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1225             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1226                 uint256 nextTokenId = tokenId + 1;
1227                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1228                 if (_packedOwnerships[nextTokenId] == 0) {
1229                     // If the next slot is within bounds.
1230                     if (nextTokenId != _currentIndex) {
1231                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1232                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1233                     }
1234                 }
1235             }
1236         }
1237 
1238         emit Transfer(from, to, tokenId);
1239         _afterTokenTransfers(from, to, tokenId, 1);
1240     }
1241 
1242     /**
1243      * @dev Equivalent to `_burn(tokenId, false)`.
1244      */
1245     function _burn(uint256 tokenId) internal virtual {
1246         _burn(tokenId, false);
1247     }
1248 
1249     /**
1250      * @dev Destroys `tokenId`.
1251      * The approval is cleared when the token is burned.
1252      *
1253      * Requirements:
1254      *
1255      * - `tokenId` must exist.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1260         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1261 
1262         address from = address(uint160(prevOwnershipPacked));
1263 
1264         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1265 
1266         if (approvalCheck) {
1267             // The nested ifs save around 20+ gas over a compound boolean condition.
1268             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1269                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1270         }
1271 
1272         _beforeTokenTransfers(from, address(0), tokenId, 1);
1273 
1274         // Clear approvals from the previous owner.
1275         assembly {
1276             if approvedAddress {
1277                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1278                 sstore(approvedAddressSlot, 0)
1279             }
1280         }
1281 
1282         // Underflow of the sender's balance is impossible because we check for
1283         // ownership above and the recipient's balance can't realistically overflow.
1284         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1285         unchecked {
1286             // Updates:
1287             // - `balance -= 1`.
1288             // - `numberBurned += 1`.
1289             //
1290             // We can directly decrement the balance, and increment the number burned.
1291             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1292             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1293 
1294             // Updates:
1295             // - `address` to the last owner.
1296             // - `startTimestamp` to the timestamp of burning.
1297             // - `burned` to `true`.
1298             // - `nextInitialized` to `true`.
1299             _packedOwnerships[tokenId] = _packOwnershipData(
1300                 from,
1301                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1302             );
1303 
1304             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1305             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1306                 uint256 nextTokenId = tokenId + 1;
1307                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1308                 if (_packedOwnerships[nextTokenId] == 0) {
1309                     // If the next slot is within bounds.
1310                     if (nextTokenId != _currentIndex) {
1311                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1312                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1313                     }
1314                 }
1315             }
1316         }
1317 
1318         emit Transfer(from, address(0), tokenId);
1319         _afterTokenTransfers(from, address(0), tokenId, 1);
1320 
1321         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1322         unchecked {
1323             _burnCounter++;
1324         }
1325     }
1326 
1327     /**
1328      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1329      *
1330      * @param from address representing the previous owner of the given token ID
1331      * @param to target address that will receive the tokens
1332      * @param tokenId uint256 ID of the token to be transferred
1333      * @param _data bytes optional data to send along with the call
1334      * @return bool whether the call correctly returned the expected magic value
1335      */
1336     function _checkContractOnERC721Received(
1337         address from,
1338         address to,
1339         uint256 tokenId,
1340         bytes memory _data
1341     ) private returns (bool) {
1342         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1343             bytes4 retval
1344         ) {
1345             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1346         } catch (bytes memory reason) {
1347             if (reason.length == 0) {
1348                 revert TransferToNonERC721ReceiverImplementer();
1349             } else {
1350                 assembly {
1351                     revert(add(32, reason), mload(reason))
1352                 }
1353             }
1354         }
1355     }
1356 
1357     /**
1358      * @dev Directly sets the extra data for the ownership data `index`.
1359      */
1360     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1361         uint256 packed = _packedOwnerships[index];
1362         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1363         uint256 extraDataCasted;
1364         // Cast `extraData` with assembly to avoid redundant masking.
1365         assembly {
1366             extraDataCasted := extraData
1367         }
1368         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1369         _packedOwnerships[index] = packed;
1370     }
1371 
1372     /**
1373      * @dev Returns the next extra data for the packed ownership data.
1374      * The returned result is shifted into position.
1375      */
1376     function _nextExtraData(
1377         address from,
1378         address to,
1379         uint256 prevOwnershipPacked
1380     ) private view returns (uint256) {
1381         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1382         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1383     }
1384 
1385     /**
1386      * @dev Called during each token transfer to set the 24bit `extraData` field.
1387      * Intended to be overridden by the cosumer contract.
1388      *
1389      * `previousExtraData` - the value of `extraData` before transfer.
1390      *
1391      * Calling conditions:
1392      *
1393      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1394      * transferred to `to`.
1395      * - When `from` is zero, `tokenId` will be minted for `to`.
1396      * - When `to` is zero, `tokenId` will be burned by `from`.
1397      * - `from` and `to` are never both zero.
1398      */
1399     function _extraData(
1400         address from,
1401         address to,
1402         uint24 previousExtraData
1403     ) internal view virtual returns (uint24) {}
1404 
1405     /**
1406      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1407      * This includes minting.
1408      * And also called before burning one token.
1409      *
1410      * startTokenId - the first token id to be transferred
1411      * quantity - the amount to be transferred
1412      *
1413      * Calling conditions:
1414      *
1415      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1416      * transferred to `to`.
1417      * - When `from` is zero, `tokenId` will be minted for `to`.
1418      * - When `to` is zero, `tokenId` will be burned by `from`.
1419      * - `from` and `to` are never both zero.
1420      */
1421     function _beforeTokenTransfers(
1422         address from,
1423         address to,
1424         uint256 startTokenId,
1425         uint256 quantity
1426     ) internal virtual {}
1427 
1428     /**
1429      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1430      * This includes minting.
1431      * And also called after one token has been burned.
1432      *
1433      * startTokenId - the first token id to be transferred
1434      * quantity - the amount to be transferred
1435      *
1436      * Calling conditions:
1437      *
1438      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1439      * transferred to `to`.
1440      * - When `from` is zero, `tokenId` has been minted for `to`.
1441      * - When `to` is zero, `tokenId` has been burned by `from`.
1442      * - `from` and `to` are never both zero.
1443      */
1444     function _afterTokenTransfers(
1445         address from,
1446         address to,
1447         uint256 startTokenId,
1448         uint256 quantity
1449     ) internal virtual {}
1450 
1451     /**
1452      * @dev Returns the message sender (defaults to `msg.sender`).
1453      *
1454      * If you are writing GSN compatible contracts, you need to override this function.
1455      */
1456     function _msgSenderERC721A() internal view virtual returns (address) {
1457         return msg.sender;
1458     }
1459 
1460     /**
1461      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1462      */
1463     function _toString(uint256 value) internal pure returns (string memory ptr) {
1464         assembly {
1465             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1466             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1467             // We will need 1 32-byte word to store the length,
1468             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1469             ptr := add(mload(0x40), 128)
1470             // Update the free memory pointer to allocate.
1471             mstore(0x40, ptr)
1472 
1473             // Cache the end of the memory to calculate the length later.
1474             let end := ptr
1475 
1476             // We write the string from the rightmost digit to the leftmost digit.
1477             // The following is essentially a do-while loop that also handles the zero case.
1478             // Costs a bit more than early returning for the zero case,
1479             // but cheaper in terms of deployment and overall runtime costs.
1480             for {
1481                 // Initialize and perform the first pass without check.
1482                 let temp := value
1483                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1484                 ptr := sub(ptr, 1)
1485                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1486                 mstore8(ptr, add(48, mod(temp, 10)))
1487                 temp := div(temp, 10)
1488             } temp {
1489                 // Keep dividing `temp` until zero.
1490                 temp := div(temp, 10)
1491             } {
1492                 // Body of the for loop.
1493                 ptr := sub(ptr, 1)
1494                 mstore8(ptr, add(48, mod(temp, 10)))
1495             }
1496 
1497             let length := sub(end, ptr)
1498             // Move the pointer 32 bytes leftwards to make room for the length.
1499             ptr := sub(ptr, 32)
1500             // Store the length.
1501             mstore(ptr, length)
1502         }
1503     }
1504 }
1505 
1506 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1507 
1508 
1509 // ERC721A Contracts v4.1.0
1510 // Creator: Chiru Labs
1511 
1512 pragma solidity ^0.8.4;
1513 
1514 
1515 /**
1516  * @dev Interface of an ERC721AQueryable compliant contract.
1517  */
1518 interface IERC721AQueryable is IERC721A {
1519     /**
1520      * Invalid query range (`start` >= `stop`).
1521      */
1522     error InvalidQueryRange();
1523 
1524     /**
1525      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1526      *
1527      * If the `tokenId` is out of bounds:
1528      *   - `addr` = `address(0)`
1529      *   - `startTimestamp` = `0`
1530      *   - `burned` = `false`
1531      *
1532      * If the `tokenId` is burned:
1533      *   - `addr` = `<Address of owner before token was burned>`
1534      *   - `startTimestamp` = `<Timestamp when token was burned>`
1535      *   - `burned = `true`
1536      *
1537      * Otherwise:
1538      *   - `addr` = `<Address of owner>`
1539      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1540      *   - `burned = `false`
1541      */
1542     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1543 
1544     /**
1545      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1546      * See {ERC721AQueryable-explicitOwnershipOf}
1547      */
1548     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1549 
1550     /**
1551      * @dev Returns an array of token IDs owned by `owner`,
1552      * in the range [`start`, `stop`)
1553      * (i.e. `start <= tokenId < stop`).
1554      *
1555      * This function allows for tokens to be queried if the collection
1556      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1557      *
1558      * Requirements:
1559      *
1560      * - `start` < `stop`
1561      */
1562     function tokensOfOwnerIn(
1563         address owner,
1564         uint256 start,
1565         uint256 stop
1566     ) external view returns (uint256[] memory);
1567 
1568     /**
1569      * @dev Returns an array of token IDs owned by `owner`.
1570      *
1571      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1572      * It is meant to be called off-chain.
1573      *
1574      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1575      * multiple smaller scans if the collection is large enough to cause
1576      * an out-of-gas error (10K pfp collections should be fine).
1577      */
1578     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1579 }
1580 
1581 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1582 
1583 
1584 // ERC721A Contracts v4.1.0
1585 // Creator: Chiru Labs
1586 
1587 pragma solidity ^0.8.4;
1588 
1589 
1590 
1591 /**
1592  * @title ERC721A Queryable
1593  * @dev ERC721A subclass with convenience query functions.
1594  */
1595 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1596     /**
1597      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1598      *
1599      * If the `tokenId` is out of bounds:
1600      *   - `addr` = `address(0)`
1601      *   - `startTimestamp` = `0`
1602      *   - `burned` = `false`
1603      *   - `extraData` = `0`
1604      *
1605      * If the `tokenId` is burned:
1606      *   - `addr` = `<Address of owner before token was burned>`
1607      *   - `startTimestamp` = `<Timestamp when token was burned>`
1608      *   - `burned = `true`
1609      *   - `extraData` = `<Extra data when token was burned>`
1610      *
1611      * Otherwise:
1612      *   - `addr` = `<Address of owner>`
1613      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1614      *   - `burned = `false`
1615      *   - `extraData` = `<Extra data at start of ownership>`
1616      */
1617     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1618         TokenOwnership memory ownership;
1619         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1620             return ownership;
1621         }
1622         ownership = _ownershipAt(tokenId);
1623         if (ownership.burned) {
1624             return ownership;
1625         }
1626         return _ownershipOf(tokenId);
1627     }
1628 
1629     /**
1630      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1631      * See {ERC721AQueryable-explicitOwnershipOf}
1632      */
1633     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1634         unchecked {
1635             uint256 tokenIdsLength = tokenIds.length;
1636             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1637             for (uint256 i; i != tokenIdsLength; ++i) {
1638                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1639             }
1640             return ownerships;
1641         }
1642     }
1643 
1644     /**
1645      * @dev Returns an array of token IDs owned by `owner`,
1646      * in the range [`start`, `stop`)
1647      * (i.e. `start <= tokenId < stop`).
1648      *
1649      * This function allows for tokens to be queried if the collection
1650      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1651      *
1652      * Requirements:
1653      *
1654      * - `start` < `stop`
1655      */
1656     function tokensOfOwnerIn(
1657         address owner,
1658         uint256 start,
1659         uint256 stop
1660     ) external view override returns (uint256[] memory) {
1661         unchecked {
1662             if (start >= stop) revert InvalidQueryRange();
1663             uint256 tokenIdsIdx;
1664             uint256 stopLimit = _nextTokenId();
1665             // Set `start = max(start, _startTokenId())`.
1666             if (start < _startTokenId()) {
1667                 start = _startTokenId();
1668             }
1669             // Set `stop = min(stop, stopLimit)`.
1670             if (stop > stopLimit) {
1671                 stop = stopLimit;
1672             }
1673             uint256 tokenIdsMaxLength = balanceOf(owner);
1674             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1675             // to cater for cases where `balanceOf(owner)` is too big.
1676             if (start < stop) {
1677                 uint256 rangeLength = stop - start;
1678                 if (rangeLength < tokenIdsMaxLength) {
1679                     tokenIdsMaxLength = rangeLength;
1680                 }
1681             } else {
1682                 tokenIdsMaxLength = 0;
1683             }
1684             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1685             if (tokenIdsMaxLength == 0) {
1686                 return tokenIds;
1687             }
1688             // We need to call `explicitOwnershipOf(start)`,
1689             // because the slot at `start` may not be initialized.
1690             TokenOwnership memory ownership = explicitOwnershipOf(start);
1691             address currOwnershipAddr;
1692             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1693             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1694             if (!ownership.burned) {
1695                 currOwnershipAddr = ownership.addr;
1696             }
1697             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1698                 ownership = _ownershipAt(i);
1699                 if (ownership.burned) {
1700                     continue;
1701                 }
1702                 if (ownership.addr != address(0)) {
1703                     currOwnershipAddr = ownership.addr;
1704                 }
1705                 if (currOwnershipAddr == owner) {
1706                     tokenIds[tokenIdsIdx++] = i;
1707                 }
1708             }
1709             // Downsize the array to fit.
1710             assembly {
1711                 mstore(tokenIds, tokenIdsIdx)
1712             }
1713             return tokenIds;
1714         }
1715     }
1716 
1717     /**
1718      * @dev Returns an array of token IDs owned by `owner`.
1719      *
1720      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1721      * It is meant to be called off-chain.
1722      *
1723      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1724      * multiple smaller scans if the collection is large enough to cause
1725      * an out-of-gas error (10K pfp collections should be fine).
1726      */
1727     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1728         unchecked {
1729             uint256 tokenIdsIdx;
1730             address currOwnershipAddr;
1731             uint256 tokenIdsLength = balanceOf(owner);
1732             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1733             TokenOwnership memory ownership;
1734             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1735                 ownership = _ownershipAt(i);
1736                 if (ownership.burned) {
1737                     continue;
1738                 }
1739                 if (ownership.addr != address(0)) {
1740                     currOwnershipAddr = ownership.addr;
1741                 }
1742                 if (currOwnershipAddr == owner) {
1743                     tokenIds[tokenIdsIdx++] = i;
1744                 }
1745             }
1746             return tokenIds;
1747         }
1748     }
1749 }
1750 
1751 
1752 
1753 pragma solidity ^0.8.0;
1754 
1755 
1756 
1757 
1758 
1759 /**
1760  * @dev These functions deal with verification of Merkle Tree proofs.
1761  *
1762  * The proofs can be generated using the JavaScript library
1763  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1764  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1765  *
1766  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1767  *
1768  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1769  * hashing, or use a hash function other than keccak256 for hashing leaves.
1770  * This is because the concatenation of a sorted pair of internal nodes in
1771  * the merkle tree could be reinterpreted as a leaf value.
1772  */
1773 library MerkleProof {
1774     /**
1775      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1776      * defined by `root`. For this, a `proof` must be provided, containing
1777      * sibling hashes on the branch from the leaf to the root of the tree. Each
1778      * pair of leaves and each pair of pre-images are assumed to be sorted.
1779      */
1780     function verify(
1781         bytes32[] memory proof,
1782         bytes32 root,
1783         bytes32 leaf
1784     ) internal pure returns (bool) {
1785         return processProof(proof, leaf) == root;
1786     }
1787 
1788     /**
1789      * @dev Calldata version of {verify}
1790      *
1791      * _Available since v4.7._
1792      */
1793     function verifyCalldata(
1794         bytes32[] calldata proof,
1795         bytes32 root,
1796         bytes32 leaf
1797     ) internal pure returns (bool) {
1798         return processProofCalldata(proof, leaf) == root;
1799     }
1800 
1801     /**
1802      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1803      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1804      * hash matches the root of the tree. When processing the proof, the pairs
1805      * of leafs & pre-images are assumed to be sorted.
1806      *
1807      * _Available since v4.4._
1808      */
1809     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1810         bytes32 computedHash = leaf;
1811         for (uint256 i = 0; i < proof.length; i++) {
1812             computedHash = _hashPair(computedHash, proof[i]);
1813         }
1814         return computedHash;
1815     }
1816 
1817     /**
1818      * @dev Calldata version of {processProof}
1819      *
1820      * _Available since v4.7._
1821      */
1822     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1823         bytes32 computedHash = leaf;
1824         for (uint256 i = 0; i < proof.length; i++) {
1825             computedHash = _hashPair(computedHash, proof[i]);
1826         }
1827         return computedHash;
1828     }
1829 
1830     /**
1831      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1832      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1833      *
1834      * _Available since v4.7._
1835      */
1836     function multiProofVerify(
1837         bytes32[] memory proof,
1838         bool[] memory proofFlags,
1839         bytes32 root,
1840         bytes32[] memory leaves
1841     ) internal pure returns (bool) {
1842         return processMultiProof(proof, proofFlags, leaves) == root;
1843     }
1844 
1845     /**
1846      * @dev Calldata version of {multiProofVerify}
1847      *
1848      * _Available since v4.7._
1849      */
1850     function multiProofVerifyCalldata(
1851         bytes32[] calldata proof,
1852         bool[] calldata proofFlags,
1853         bytes32 root,
1854         bytes32[] memory leaves
1855     ) internal pure returns (bool) {
1856         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1857     }
1858 
1859     /**
1860      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1861      * consuming from one or the other at each step according to the instructions given by
1862      * `proofFlags`.
1863      *
1864      * _Available since v4.7._
1865      */
1866     function processMultiProof(
1867         bytes32[] memory proof,
1868         bool[] memory proofFlags,
1869         bytes32[] memory leaves
1870     ) internal pure returns (bytes32 merkleRoot) {
1871         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1872         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1873         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1874         // the merkle tree.
1875         uint256 leavesLen = leaves.length;
1876         uint256 totalHashes = proofFlags.length;
1877 
1878         // Check proof validity.
1879         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1880 
1881         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1882         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1883         bytes32[] memory hashes = new bytes32[](totalHashes);
1884         uint256 leafPos = 0;
1885         uint256 hashPos = 0;
1886         uint256 proofPos = 0;
1887         // At each step, we compute the next hash using two values:
1888         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1889         //   get the next hash.
1890         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1891         //   `proof` array.
1892         for (uint256 i = 0; i < totalHashes; i++) {
1893             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1894             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1895             hashes[i] = _hashPair(a, b);
1896         }
1897 
1898         if (totalHashes > 0) {
1899             return hashes[totalHashes - 1];
1900         } else if (leavesLen > 0) {
1901             return leaves[0];
1902         } else {
1903             return proof[0];
1904         }
1905     }
1906 
1907     /**
1908      * @dev Calldata version of {processMultiProof}
1909      *
1910      * _Available since v4.7._
1911      */
1912     function processMultiProofCalldata(
1913         bytes32[] calldata proof,
1914         bool[] calldata proofFlags,
1915         bytes32[] memory leaves
1916     ) internal pure returns (bytes32 merkleRoot) {
1917         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1918         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1919         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1920         // the merkle tree.
1921         uint256 leavesLen = leaves.length;
1922         uint256 totalHashes = proofFlags.length;
1923 
1924         // Check proof validity.
1925         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1926 
1927         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1928         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1929         bytes32[] memory hashes = new bytes32[](totalHashes);
1930         uint256 leafPos = 0;
1931         uint256 hashPos = 0;
1932         uint256 proofPos = 0;
1933         // At each step, we compute the next hash using two values:
1934         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1935         //   get the next hash.
1936         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1937         //   `proof` array.
1938         for (uint256 i = 0; i < totalHashes; i++) {
1939             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1940             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1941             hashes[i] = _hashPair(a, b);
1942         }
1943 
1944         if (totalHashes > 0) {
1945             return hashes[totalHashes - 1];
1946         } else if (leavesLen > 0) {
1947             return leaves[0];
1948         } else {
1949             return proof[0];
1950         }
1951     }
1952 
1953     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1954         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1955     }
1956 
1957     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1958         /// @solidity memory-safe-assembly
1959         assembly {
1960             mstore(0x00, a)
1961             mstore(0x20, b)
1962             value := keccak256(0x00, 0x40)
1963         }
1964     }
1965 }
1966  pragma solidity ^0.8.0;
1967 
1968  contract RyokoGenesis is ERC721A, Ownable, ReentrancyGuard {
1969 
1970 
1971 
1972   using Strings for uint;
1973  string public hiddenMetadataUri;
1974 
1975  bytes32 public merkleRoot; 
1976   mapping(address => bool) public whitelistClaimed;
1977 
1978   string  public  baseTokenURI = "ipfs://RyokoGenesis";
1979   uint256  public  maxSupply = 888;
1980   uint256 public  MAX_MINTS_PER_TX = 25;
1981   uint256 public  PUBLIC_SALE_PRICE = 0.002 ether;
1982   uint256 public  NUM_FREE_MINTS = 500;
1983   uint256 public  MAX_FREE_PER_WALLET = 1;
1984   uint256 public freeNFTAlreadyMinted = 0;
1985   bool public isPublicSaleActive = false;
1986    bool public whitelistMintEnabled = false;
1987 
1988    constructor(
1989     string memory _tokenName,
1990     string memory _tokenSymbol,
1991     string memory _hiddenMetadataUri
1992   ) ERC721A(_tokenName, _tokenSymbol) {
1993     setHiddenMetadataUri(_hiddenMetadataUri);
1994   }
1995 
1996 
1997   function mint(uint256 numberOfTokens)
1998       external
1999       payable
2000   {
2001     require(isPublicSaleActive, "Public sale is not open");
2002     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
2003 
2004     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
2005         require(
2006             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2007             "Incorrect ETH value sent"
2008         );
2009     } else {
2010         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
2011         require(
2012             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2013             "Incorrect ETH value sent"
2014         );
2015         require(
2016             numberOfTokens <= MAX_MINTS_PER_TX,
2017             "Max mints per transaction exceeded"
2018         );
2019         } else {
2020             require(
2021                 numberOfTokens <= MAX_FREE_PER_WALLET,
2022                 "Max mints per transaction exceeded"
2023             );
2024             freeNFTAlreadyMinted += numberOfTokens;
2025         }
2026     }
2027     _safeMint(msg.sender, numberOfTokens); 
2028   }
2029 
2030   function setBaseURI(string memory baseURI)
2031     public
2032     onlyOwner
2033   {
2034     baseTokenURI = baseURI;
2035   }
2036 
2037   function treasuryMint(uint quantity)
2038     public
2039     onlyOwner
2040   {
2041     require(
2042       quantity > 0,
2043       "Invalid mint amount"
2044     );
2045     require(
2046       totalSupply() + quantity <= maxSupply,
2047       "Maximum supply exceeded"
2048     );
2049     _safeMint(msg.sender, quantity);
2050   }
2051 
2052 function withdraw() public onlyOwner nonReentrant {
2053     // This will transfer the remaining contract balance to the owner.
2054     // Do not remove this otherwise you will not be able to withdraw the funds.
2055     // =============================================================================
2056     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2057     require(os);
2058     // =============================================================================
2059   }
2060 
2061   function tokenURI(uint _tokenId)
2062     public
2063     view
2064     virtual
2065     override
2066     returns (string memory)
2067   {
2068     require(
2069       _exists(_tokenId),
2070       "ERC721Metadata: URI query for nonexistent token"
2071     );
2072     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
2073   }
2074 
2075   function _baseURI()
2076     internal
2077     view
2078     virtual
2079     override
2080     returns (string memory)
2081   {
2082     return baseTokenURI;
2083   }
2084 
2085   function setIsPublicSaleActive(bool _isPublicSaleActive)
2086       external
2087       onlyOwner
2088   {
2089       isPublicSaleActive = _isPublicSaleActive;
2090   }
2091   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2092     hiddenMetadataUri = _hiddenMetadataUri;
2093   }
2094 
2095   function setNumFreeMints(uint256 _numfreemints)
2096       external
2097       onlyOwner
2098   {
2099       NUM_FREE_MINTS = _numfreemints;
2100   }
2101 
2102   function setSalePrice(uint256 _price)
2103       external
2104       onlyOwner
2105   {
2106       PUBLIC_SALE_PRICE = _price;
2107   }
2108   function setMaxSupply(uint256 _maxsupply)
2109       external
2110       onlyOwner
2111   {
2112       maxSupply = _maxsupply;
2113   }
2114 
2115   function setMaxLimitPerTransaction(uint256 _limit)
2116       external
2117       onlyOwner
2118   {
2119       MAX_MINTS_PER_TX = _limit;
2120   }
2121   function setwhitelistMintEnabled(bool _wlMintEnabled)
2122       external
2123       onlyOwner
2124   {
2125       whitelistMintEnabled = _wlMintEnabled;
2126   }
2127   function whitelistMint(uint256 _price, bytes32[] calldata _merkleProof) public payable  {
2128     // Verify whitelist requirements
2129     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
2130     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
2131     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2132     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
2133 
2134     whitelistClaimed[_msgSender()] = true;
2135     _safeMint(_msgSender(), _price);
2136   }
2137 
2138   function setFreeLimitPerWallet(uint256 _limit)
2139       external
2140       onlyOwner
2141   {
2142       MAX_FREE_PER_WALLET = _limit;
2143   }
2144 }