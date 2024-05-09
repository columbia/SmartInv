1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4  _  _  ____  _  _  ____    ____    __    ____  ___    __    _  _  __  __ 
5 ( )/ )(_  _)( )/ )(_  _)  (  _ \  /__\  (_  _)/ __)  /__\  ( )/ )(  )(  )
6  )  (  _)(_  )  (  _)(_    )(_) )/(__)\  _)(_( (_-. /(__)\  )  (  )(__)( 
7 (_)\_)(____)(_)\_)(____)  (____/(__)(__)(____)\___/(__)(__)(_)\_)(______)                                                              
8 */
9 
10 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Contract module that helps prevent reentrant calls to a function.
16  *
17  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
18  * available, which can be applied to functions to make sure there are no nested
19  * (reentrant) calls to them.
20  *
21  * Note that because there is a single `nonReentrant` guard, functions marked as
22  * `nonReentrant` may not call one another. This can be worked around by making
23  * those functions `private`, and then adding `external` `nonReentrant` entry
24  * points to them.
25  *
26  * TIP: If you would like to learn more about reentrancy and alternative ways
27  * to protect against it, check out our blog post
28  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
29  */
30 abstract contract ReentrancyGuard {
31     // Booleans are more expensive than uint256 or any type that takes up a full
32     // word because each write operation emits an extra SLOAD to first read the
33     // slot's contents, replace the bits taken up by the boolean, and then write
34     // back. This is the compiler's defense against contract upgrades and
35     // pointer aliasing, and it cannot be disabled.
36 
37     // The values being non-zero value makes deployment a bit more expensive,
38     // but in exchange the refund on every call to nonReentrant will be lower in
39     // amount. Since refunds are capped to a percentage of the total
40     // transaction's gas, it is best to keep them low in cases like this one, to
41     // increase the likelihood of the full refund coming into effect.
42     uint256 private constant _NOT_ENTERED = 1;
43     uint256 private constant _ENTERED = 2;
44 
45     uint256 private _status;
46 
47     constructor() {
48         _status = _NOT_ENTERED;
49     }
50 
51     /**
52      * @dev Prevents a contract from calling itself, directly or indirectly.
53      * Calling a `nonReentrant` function from another `nonReentrant`
54      * function is not supported. It is possible to prevent this from happening
55      * by making the `nonReentrant` function external, and making it call a
56      * `private` function that does the actual work.
57      */
58     modifier nonReentrant() {
59         // On the first call to nonReentrant, _notEntered will be true
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64 
65         _;
66 
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Strings.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev String operations.
82  */
83 library Strings {
84     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
85     uint8 private constant _ADDRESS_LENGTH = 20;
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
89      */
90     function toString(uint256 value) internal pure returns (string memory) {
91         // Inspired by OraclizeAPI's implementation - MIT licence
92         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
93 
94         if (value == 0) {
95             return "0";
96         }
97         uint256 temp = value;
98         uint256 digits;
99         while (temp != 0) {
100             digits++;
101             temp /= 10;
102         }
103         bytes memory buffer = new bytes(digits);
104         while (value != 0) {
105             digits -= 1;
106             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
107             value /= 10;
108         }
109         return string(buffer);
110     }
111 
112     /**
113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
114      */
115     function toHexString(uint256 value) internal pure returns (string memory) {
116         if (value == 0) {
117             return "0x00";
118         }
119         uint256 temp = value;
120         uint256 length = 0;
121         while (temp != 0) {
122             length++;
123             temp >>= 8;
124         }
125         return toHexString(value, length);
126     }
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
130      */
131     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
132         bytes memory buffer = new bytes(2 * length + 2);
133         buffer[0] = "0";
134         buffer[1] = "x";
135         for (uint256 i = 2 * length + 1; i > 1; --i) {
136             buffer[i] = _HEX_SYMBOLS[value & 0xf];
137             value >>= 4;
138         }
139         require(value == 0, "Strings: hex length insufficient");
140         return string(buffer);
141     }
142 
143     /**
144      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
145      */
146     function toHexString(address addr) internal pure returns (string memory) {
147         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
148     }
149 }
150 
151 
152 // File: @openzeppelin/contracts/utils/Context.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 abstract contract Context {
170     function _msgSender() internal view virtual returns (address) {
171         return msg.sender;
172     }
173 
174     function _msgData() internal view virtual returns (bytes calldata) {
175         return msg.data;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/access/Ownable.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 
187 /**
188  * @dev Contract module which provides a basic access control mechanism, where
189  * there is an account (an owner) that can be granted exclusive access to
190  * specific functions.
191  *
192  * By default, the owner account will be the one that deploys the contract. This
193  * can later be changed with {transferOwnership}.
194  *
195  * This module is used through inheritance. It will make available the modifier
196  * `onlyOwner`, which can be applied to your functions to restrict their use to
197  * the owner.
198  */
199 abstract contract Ownable is Context {
200     address private _owner;
201 
202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204     /**
205      * @dev Initializes the contract setting the deployer as the initial owner.
206      */
207     constructor() {
208         _transferOwnership(_msgSender());
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         _checkOwner();
216         _;
217     }
218 
219     /**
220      * @dev Returns the address of the current owner.
221      */
222     function owner() public view virtual returns (address) {
223         return _owner;
224     }
225 
226     /**
227      * @dev Throws if the sender is not the owner.
228      */
229     function _checkOwner() internal view virtual {
230         require(owner() == _msgSender(), "Ownable: caller is not the owner");
231     }
232 
233     /**
234      * @dev Leaves the contract without owner. It will not be possible to call
235      * `onlyOwner` functions anymore. Can only be called by the current owner.
236      *
237      * NOTE: Renouncing ownership will leave the contract without an owner,
238      * thereby removing any functionality that is only available to the owner.
239      */
240     function renounceOwnership() public virtual onlyOwner {
241         _transferOwnership(address(0));
242     }
243 
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Can only be called by the current owner.
247      */
248     function transferOwnership(address newOwner) public virtual onlyOwner {
249         require(newOwner != address(0), "Ownable: new owner is the zero address");
250         _transferOwnership(newOwner);
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Internal function without access restriction.
256      */
257     function _transferOwnership(address newOwner) internal virtual {
258         address oldOwner = _owner;
259         _owner = newOwner;
260         emit OwnershipTransferred(oldOwner, newOwner);
261     }
262 }
263 
264 // File: erc721a/contracts/IERC721A.sol
265 
266 
267 // ERC721A Contracts v4.1.0
268 // Creator: Chiru Labs
269 
270 pragma solidity ^0.8.4;
271 
272 /**
273  * @dev Interface of an ERC721A compliant contract.
274  */
275 interface IERC721A {
276     /**
277      * The caller must own the token or be an approved operator.
278      */
279     error ApprovalCallerNotOwnerNorApproved();
280 
281     /**
282      * The token does not exist.
283      */
284     error ApprovalQueryForNonexistentToken();
285 
286     /**
287      * The caller cannot approve to their own address.
288      */
289     error ApproveToCaller();
290 
291     /**
292      * Cannot query the balance for the zero address.
293      */
294     error BalanceQueryForZeroAddress();
295 
296     /**
297      * Cannot mint to the zero address.
298      */
299     error MintToZeroAddress();
300 
301     /**
302      * The quantity of tokens minted must be more than zero.
303      */
304     error MintZeroQuantity();
305 
306     /**
307      * The token does not exist.
308      */
309     error OwnerQueryForNonexistentToken();
310 
311     /**
312      * The caller must own the token or be an approved operator.
313      */
314     error TransferCallerNotOwnerNorApproved();
315 
316     /**
317      * The token must be owned by `from`.
318      */
319     error TransferFromIncorrectOwner();
320 
321     /**
322      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
323      */
324     error TransferToNonERC721ReceiverImplementer();
325 
326     /**
327      * Cannot transfer to the zero address.
328      */
329     error TransferToZeroAddress();
330 
331     /**
332      * The token does not exist.
333      */
334     error URIQueryForNonexistentToken();
335 
336     /**
337      * The `quantity` minted with ERC2309 exceeds the safety limit.
338      */
339     error MintERC2309QuantityExceedsLimit();
340 
341     /**
342      * The `extraData` cannot be set on an unintialized ownership slot.
343      */
344     error OwnershipNotInitializedForExtraData();
345 
346     struct TokenOwnership {
347         // The address of the owner.
348         address addr;
349         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
350         uint64 startTimestamp;
351         // Whether the token has been burned.
352         bool burned;
353         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
354         uint24 extraData;
355     }
356 
357     /**
358      * @dev Returns the total amount of tokens stored by the contract.
359      *
360      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
361      */
362     function totalSupply() external view returns (uint256);
363 
364     // ==============================
365     //            IERC165
366     // ==============================
367 
368     /**
369      * @dev Returns true if this contract implements the interface defined by
370      * `interfaceId`. See the corresponding
371      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
372      * to learn more about how these ids are created.
373      *
374      * This function call must use less than 30 000 gas.
375      */
376     function supportsInterface(bytes4 interfaceId) external view returns (bool);
377 
378     // ==============================
379     //            IERC721
380     // ==============================
381 
382     /**
383      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
384      */
385     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
386 
387     /**
388      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
389      */
390     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
391 
392     /**
393      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
394      */
395     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
396 
397     /**
398      * @dev Returns the number of tokens in ``owner``'s account.
399      */
400     function balanceOf(address owner) external view returns (uint256 balance);
401 
402     /**
403      * @dev Returns the owner of the `tokenId` token.
404      *
405      * Requirements:
406      *
407      * - `tokenId` must exist.
408      */
409     function ownerOf(uint256 tokenId) external view returns (address owner);
410 
411     /**
412      * @dev Safely transfers `tokenId` token from `from` to `to`.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must exist and be owned by `from`.
419      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
420      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
421      *
422      * Emits a {Transfer} event.
423      */
424     function safeTransferFrom(
425         address from,
426         address to,
427         uint256 tokenId,
428         bytes calldata data
429     ) external;
430 
431     /**
432      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
433      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `tokenId` token must exist and be owned by `from`.
440      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
441      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
442      *
443      * Emits a {Transfer} event.
444      */
445     function safeTransferFrom(
446         address from,
447         address to,
448         uint256 tokenId
449     ) external;
450 
451     /**
452      * @dev Transfers `tokenId` token from `from` to `to`.
453      *
454      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must be owned by `from`.
461      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transferFrom(
466         address from,
467         address to,
468         uint256 tokenId
469     ) external;
470 
471     /**
472      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
473      * The approval is cleared when the token is transferred.
474      *
475      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
476      *
477      * Requirements:
478      *
479      * - The caller must own the token or be an approved operator.
480      * - `tokenId` must exist.
481      *
482      * Emits an {Approval} event.
483      */
484     function approve(address to, uint256 tokenId) external;
485 
486     /**
487      * @dev Approve or remove `operator` as an operator for the caller.
488      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
489      *
490      * Requirements:
491      *
492      * - The `operator` cannot be the caller.
493      *
494      * Emits an {ApprovalForAll} event.
495      */
496     function setApprovalForAll(address operator, bool _approved) external;
497 
498     /**
499      * @dev Returns the account approved for `tokenId` token.
500      *
501      * Requirements:
502      *
503      * - `tokenId` must exist.
504      */
505     function getApproved(uint256 tokenId) external view returns (address operator);
506 
507     /**
508      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
509      *
510      * See {setApprovalForAll}
511      */
512     function isApprovedForAll(address owner, address operator) external view returns (bool);
513 
514     // ==============================
515     //        IERC721Metadata
516     // ==============================
517 
518     /**
519      * @dev Returns the token collection name.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the token collection symbol.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
530      */
531     function tokenURI(uint256 tokenId) external view returns (string memory);
532 
533     // ==============================
534     //            IERC2309
535     // ==============================
536 
537     /**
538      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
539      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
540      */
541     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
542 }
543 
544 // File: erc721a/contracts/ERC721A.sol
545 
546 
547 // ERC721A Contracts v4.1.0
548 // Creator: Chiru Labs
549 
550 pragma solidity ^0.8.4;
551 
552 
553 /**
554  * @dev ERC721 token receiver interface.
555  */
556 interface ERC721A__IERC721Receiver {
557     function onERC721Received(
558         address operator,
559         address from,
560         uint256 tokenId,
561         bytes calldata data
562     ) external returns (bytes4);
563 }
564 
565 /**
566  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
567  * including the Metadata extension. Built to optimize for lower gas during batch mints.
568  *
569  * Assumes serials are sequentially minted starting at `_startTokenId()`
570  * (defaults to 0, e.g. 0, 1, 2, 3..).
571  *
572  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
573  *
574  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
575  */
576 contract ERC721A is IERC721A {
577     // Mask of an entry in packed address data.
578     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
579 
580     // The bit position of `numberMinted` in packed address data.
581     uint256 private constant BITPOS_NUMBER_MINTED = 64;
582 
583     // The bit position of `numberBurned` in packed address data.
584     uint256 private constant BITPOS_NUMBER_BURNED = 128;
585 
586     // The bit position of `aux` in packed address data.
587     uint256 private constant BITPOS_AUX = 192;
588 
589     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
590     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
591 
592     // The bit position of `startTimestamp` in packed ownership.
593     uint256 private constant BITPOS_START_TIMESTAMP = 160;
594 
595     // The bit mask of the `burned` bit in packed ownership.
596     uint256 private constant BITMASK_BURNED = 1 << 224;
597 
598     // The bit position of the `nextInitialized` bit in packed ownership.
599     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
600 
601     // The bit mask of the `nextInitialized` bit in packed ownership.
602     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
603 
604     // The bit position of `extraData` in packed ownership.
605     uint256 private constant BITPOS_EXTRA_DATA = 232;
606 
607     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
608     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
609 
610     // The mask of the lower 160 bits for addresses.
611     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
612 
613     // The maximum `quantity` that can be minted with `_mintERC2309`.
614     // This limit is to prevent overflows on the address data entries.
615     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
616     // is required to cause an overflow, which is unrealistic.
617     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
618 
619     // The tokenId of the next token to be minted.
620     uint256 private _currentIndex;
621 
622     // The number of tokens burned.
623     uint256 private _burnCounter;
624 
625     // Token name
626     string private _name;
627 
628     // Token symbol
629     string private _symbol;
630 
631     // Mapping from token ID to ownership details
632     // An empty struct value does not necessarily mean the token is unowned.
633     // See `_packedOwnershipOf` implementation for details.
634     //
635     // Bits Layout:
636     // - [0..159]   `addr`
637     // - [160..223] `startTimestamp`
638     // - [224]      `burned`
639     // - [225]      `nextInitialized`
640     // - [232..255] `extraData`
641     mapping(uint256 => uint256) private _packedOwnerships;
642 
643     // Mapping owner address to address data.
644     //
645     // Bits Layout:
646     // - [0..63]    `balance`
647     // - [64..127]  `numberMinted`
648     // - [128..191] `numberBurned`
649     // - [192..255] `aux`
650     mapping(address => uint256) private _packedAddressData;
651 
652     // Mapping from token ID to approved address.
653     mapping(uint256 => address) private _tokenApprovals;
654 
655     // Mapping from owner to operator approvals
656     mapping(address => mapping(address => bool)) private _operatorApprovals;
657 
658     constructor(string memory name_, string memory symbol_) {
659         _name = name_;
660         _symbol = symbol_;
661         _currentIndex = _startTokenId();
662     }
663 
664     /**
665      * @dev Returns the starting token ID.
666      * To change the starting token ID, please override this function.
667      */
668     function _startTokenId() internal view virtual returns (uint256) {
669         return 0;
670     }
671 
672     /**
673      * @dev Returns the next token ID to be minted.
674      */
675     function _nextTokenId() internal view returns (uint256) {
676         return _currentIndex;
677     }
678 
679     /**
680      * @dev Returns the total number of tokens in existence.
681      * Burned tokens will reduce the count.
682      * To get the total number of tokens minted, please see `_totalMinted`.
683      */
684     function totalSupply() public view override returns (uint256) {
685         // Counter underflow is impossible as _burnCounter cannot be incremented
686         // more than `_currentIndex - _startTokenId()` times.
687         unchecked {
688             return _currentIndex - _burnCounter - _startTokenId();
689         }
690     }
691 
692     /**
693      * @dev Returns the total amount of tokens minted in the contract.
694      */
695     function _totalMinted() internal view returns (uint256) {
696         // Counter underflow is impossible as _currentIndex does not decrement,
697         // and it is initialized to `_startTokenId()`
698         unchecked {
699             return _currentIndex - _startTokenId();
700         }
701     }
702 
703     /**
704      * @dev Returns the total number of tokens burned.
705      */
706     function _totalBurned() internal view returns (uint256) {
707         return _burnCounter;
708     }
709 
710     /**
711      * @dev See {IERC165-supportsInterface}.
712      */
713     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
714         // The interface IDs are constants representing the first 4 bytes of the XOR of
715         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
716         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
717         return
718             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
719             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
720             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
721     }
722 
723     /**
724      * @dev See {IERC721-balanceOf}.
725      */
726     function balanceOf(address owner) public view override returns (uint256) {
727         if (owner == address(0)) revert BalanceQueryForZeroAddress();
728         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
729     }
730 
731     /**
732      * Returns the number of tokens minted by `owner`.
733      */
734     function _numberMinted(address owner) internal view returns (uint256) {
735         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
736     }
737 
738     /**
739      * Returns the number of tokens burned by or on behalf of `owner`.
740      */
741     function _numberBurned(address owner) internal view returns (uint256) {
742         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
743     }
744 
745     /**
746      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
747      */
748     function _getAux(address owner) internal view returns (uint64) {
749         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
750     }
751 
752     /**
753      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
754      * If there are multiple variables, please pack them into a uint64.
755      */
756     function _setAux(address owner, uint64 aux) internal {
757         uint256 packed = _packedAddressData[owner];
758         uint256 auxCasted;
759         // Cast `aux` with assembly to avoid redundant masking.
760         assembly {
761             auxCasted := aux
762         }
763         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
764         _packedAddressData[owner] = packed;
765     }
766 
767     /**
768      * Returns the packed ownership data of `tokenId`.
769      */
770     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
771         uint256 curr = tokenId;
772 
773         unchecked {
774             if (_startTokenId() <= curr)
775                 if (curr < _currentIndex) {
776                     uint256 packed = _packedOwnerships[curr];
777                     // If not burned.
778                     if (packed & BITMASK_BURNED == 0) {
779                         // Invariant:
780                         // There will always be an ownership that has an address and is not burned
781                         // before an ownership that does not have an address and is not burned.
782                         // Hence, curr will not underflow.
783                         //
784                         // We can directly compare the packed value.
785                         // If the address is zero, packed is zero.
786                         while (packed == 0) {
787                             packed = _packedOwnerships[--curr];
788                         }
789                         return packed;
790                     }
791                 }
792         }
793         revert OwnerQueryForNonexistentToken();
794     }
795 
796     /**
797      * Returns the unpacked `TokenOwnership` struct from `packed`.
798      */
799     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
800         ownership.addr = address(uint160(packed));
801         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
802         ownership.burned = packed & BITMASK_BURNED != 0;
803         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
804     }
805 
806     /**
807      * Returns the unpacked `TokenOwnership` struct at `index`.
808      */
809     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
810         return _unpackedOwnership(_packedOwnerships[index]);
811     }
812 
813     /**
814      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
815      */
816     function _initializeOwnershipAt(uint256 index) internal {
817         if (_packedOwnerships[index] == 0) {
818             _packedOwnerships[index] = _packedOwnershipOf(index);
819         }
820     }
821 
822     /**
823      * Gas spent here starts off proportional to the maximum mint batch size.
824      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
825      */
826     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
827         return _unpackedOwnership(_packedOwnershipOf(tokenId));
828     }
829 
830     /**
831      * @dev Packs ownership data into a single uint256.
832      */
833     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
834         assembly {
835             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
836             owner := and(owner, BITMASK_ADDRESS)
837             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
838             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
839         }
840     }
841 
842     /**
843      * @dev See {IERC721-ownerOf}.
844      */
845     function ownerOf(uint256 tokenId) public view override returns (address) {
846         return address(uint160(_packedOwnershipOf(tokenId)));
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, it can be overridden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return '';
880     }
881 
882     /**
883      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
884      */
885     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
886         // For branchless setting of the `nextInitialized` flag.
887         assembly {
888             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
889             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
890         }
891     }
892 
893     /**
894      * @dev See {IERC721-approve}.
895      */
896     function approve(address to, uint256 tokenId) public override {
897         address owner = ownerOf(tokenId);
898 
899         if (_msgSenderERC721A() != owner)
900             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
901                 revert ApprovalCallerNotOwnerNorApproved();
902             }
903 
904         _tokenApprovals[tokenId] = to;
905         emit Approval(owner, to, tokenId);
906     }
907 
908     /**
909      * @dev See {IERC721-getApproved}.
910      */
911     function getApproved(uint256 tokenId) public view override returns (address) {
912         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
913 
914         return _tokenApprovals[tokenId];
915     }
916 
917     /**
918      * @dev See {IERC721-setApprovalForAll}.
919      */
920     function setApprovalForAll(address operator, bool approved) public virtual override {
921         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
922 
923         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
924         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
925     }
926 
927     /**
928      * @dev See {IERC721-isApprovedForAll}.
929      */
930     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
931         return _operatorApprovals[owner][operator];
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public virtual override {
942         safeTransferFrom(from, to, tokenId, '');
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) public virtual override {
954         transferFrom(from, to, tokenId);
955         if (to.code.length != 0)
956             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
957                 revert TransferToNonERC721ReceiverImplementer();
958             }
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted (`_mint`),
967      */
968     function _exists(uint256 tokenId) internal view returns (bool) {
969         return
970             _startTokenId() <= tokenId &&
971             tokenId < _currentIndex && // If within bounds,
972             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
973     }
974 
975     /**
976      * @dev Equivalent to `_safeMint(to, quantity, '')`.
977      */
978     function _safeMint(address to, uint256 quantity) internal {
979         _safeMint(to, quantity, '');
980     }
981 
982     /**
983      * @dev Safely mints `quantity` tokens and transfers them to `to`.
984      *
985      * Requirements:
986      *
987      * - If `to` refers to a smart contract, it must implement
988      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
989      * - `quantity` must be greater than 0.
990      *
991      * See {_mint}.
992      *
993      * Emits a {Transfer} event for each mint.
994      */
995     function _safeMint(
996         address to,
997         uint256 quantity,
998         bytes memory _data
999     ) internal {
1000         _mint(to, quantity);
1001 
1002         unchecked {
1003             if (to.code.length != 0) {
1004                 uint256 end = _currentIndex;
1005                 uint256 index = end - quantity;
1006                 do {
1007                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1008                         revert TransferToNonERC721ReceiverImplementer();
1009                     }
1010                 } while (index < end);
1011                 // Reentrancy protection.
1012                 if (_currentIndex != end) revert();
1013             }
1014         }
1015     }
1016 
1017     /**
1018      * @dev Mints `quantity` tokens and transfers them to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `quantity` must be greater than 0.
1024      *
1025      * Emits a {Transfer} event for each mint.
1026      */
1027     function _mint(address to, uint256 quantity) internal {
1028         uint256 startTokenId = _currentIndex;
1029         if (to == address(0)) revert MintToZeroAddress();
1030         if (quantity == 0) revert MintZeroQuantity();
1031 
1032         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1033 
1034         // Overflows are incredibly unrealistic.
1035         // `balance` and `numberMinted` have a maximum limit of 2**64.
1036         // `tokenId` has a maximum limit of 2**256.
1037         unchecked {
1038             // Updates:
1039             // - `balance += quantity`.
1040             // - `numberMinted += quantity`.
1041             //
1042             // We can directly add to the `balance` and `numberMinted`.
1043             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1044 
1045             // Updates:
1046             // - `address` to the owner.
1047             // - `startTimestamp` to the timestamp of minting.
1048             // - `burned` to `false`.
1049             // - `nextInitialized` to `quantity == 1`.
1050             _packedOwnerships[startTokenId] = _packOwnershipData(
1051                 to,
1052                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1053             );
1054 
1055             uint256 tokenId = startTokenId;
1056             uint256 end = startTokenId + quantity;
1057             do {
1058                 emit Transfer(address(0), to, tokenId++);
1059             } while (tokenId < end);
1060 
1061             _currentIndex = end;
1062         }
1063         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1064     }
1065 
1066     /**
1067      * @dev Mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * This function is intended for efficient minting only during contract creation.
1070      *
1071      * It emits only one {ConsecutiveTransfer} as defined in
1072      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1073      * instead of a sequence of {Transfer} event(s).
1074      *
1075      * Calling this function outside of contract creation WILL make your contract
1076      * non-compliant with the ERC721 standard.
1077      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1078      * {ConsecutiveTransfer} event is only permissible during contract creation.
1079      *
1080      * Requirements:
1081      *
1082      * - `to` cannot be the zero address.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {ConsecutiveTransfer} event.
1086      */
1087     function _mintERC2309(address to, uint256 quantity) internal {
1088         uint256 startTokenId = _currentIndex;
1089         if (to == address(0)) revert MintToZeroAddress();
1090         if (quantity == 0) revert MintZeroQuantity();
1091         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1092 
1093         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1094 
1095         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1096         unchecked {
1097             // Updates:
1098             // - `balance += quantity`.
1099             // - `numberMinted += quantity`.
1100             //
1101             // We can directly add to the `balance` and `numberMinted`.
1102             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1103 
1104             // Updates:
1105             // - `address` to the owner.
1106             // - `startTimestamp` to the timestamp of minting.
1107             // - `burned` to `false`.
1108             // - `nextInitialized` to `quantity == 1`.
1109             _packedOwnerships[startTokenId] = _packOwnershipData(
1110                 to,
1111                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1112             );
1113 
1114             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1115 
1116             _currentIndex = startTokenId + quantity;
1117         }
1118         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1119     }
1120 
1121     /**
1122      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1123      */
1124     function _getApprovedAddress(uint256 tokenId)
1125         private
1126         view
1127         returns (uint256 approvedAddressSlot, address approvedAddress)
1128     {
1129         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1130         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1131         assembly {
1132             // Compute the slot.
1133             mstore(0x00, tokenId)
1134             mstore(0x20, tokenApprovalsPtr.slot)
1135             approvedAddressSlot := keccak256(0x00, 0x40)
1136             // Load the slot's value from storage.
1137             approvedAddress := sload(approvedAddressSlot)
1138         }
1139     }
1140 
1141     /**
1142      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1143      */
1144     function _isOwnerOrApproved(
1145         address approvedAddress,
1146         address from,
1147         address msgSender
1148     ) private pure returns (bool result) {
1149         assembly {
1150             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1151             from := and(from, BITMASK_ADDRESS)
1152             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1153             msgSender := and(msgSender, BITMASK_ADDRESS)
1154             // `msgSender == from || msgSender == approvedAddress`.
1155             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1156         }
1157     }
1158 
1159     /**
1160      * @dev Transfers `tokenId` from `from` to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - `to` cannot be the zero address.
1165      * - `tokenId` token must be owned by `from`.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function transferFrom(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) public virtual override {
1174         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1175 
1176         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1177 
1178         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1179 
1180         // The nested ifs save around 20+ gas over a compound boolean condition.
1181         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1182             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1183 
1184         if (to == address(0)) revert TransferToZeroAddress();
1185 
1186         _beforeTokenTransfers(from, to, tokenId, 1);
1187 
1188         // Clear approvals from the previous owner.
1189         assembly {
1190             if approvedAddress {
1191                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1192                 sstore(approvedAddressSlot, 0)
1193             }
1194         }
1195 
1196         // Underflow of the sender's balance is impossible because we check for
1197         // ownership above and the recipient's balance can't realistically overflow.
1198         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1199         unchecked {
1200             // We can directly increment and decrement the balances.
1201             --_packedAddressData[from]; // Updates: `balance -= 1`.
1202             ++_packedAddressData[to]; // Updates: `balance += 1`.
1203 
1204             // Updates:
1205             // - `address` to the next owner.
1206             // - `startTimestamp` to the timestamp of transfering.
1207             // - `burned` to `false`.
1208             // - `nextInitialized` to `true`.
1209             _packedOwnerships[tokenId] = _packOwnershipData(
1210                 to,
1211                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1212             );
1213 
1214             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1215             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1216                 uint256 nextTokenId = tokenId + 1;
1217                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1218                 if (_packedOwnerships[nextTokenId] == 0) {
1219                     // If the next slot is within bounds.
1220                     if (nextTokenId != _currentIndex) {
1221                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1222                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1223                     }
1224                 }
1225             }
1226         }
1227 
1228         emit Transfer(from, to, tokenId);
1229         _afterTokenTransfers(from, to, tokenId, 1);
1230     }
1231 
1232     /**
1233      * @dev Equivalent to `_burn(tokenId, false)`.
1234      */
1235     function _burn(uint256 tokenId) internal virtual {
1236         _burn(tokenId, false);
1237     }
1238 
1239     /**
1240      * @dev Destroys `tokenId`.
1241      * The approval is cleared when the token is burned.
1242      *
1243      * Requirements:
1244      *
1245      * - `tokenId` must exist.
1246      *
1247      * Emits a {Transfer} event.
1248      */
1249     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1250         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1251 
1252         address from = address(uint160(prevOwnershipPacked));
1253 
1254         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1255 
1256         if (approvalCheck) {
1257             // The nested ifs save around 20+ gas over a compound boolean condition.
1258             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1259                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1260         }
1261 
1262         _beforeTokenTransfers(from, address(0), tokenId, 1);
1263 
1264         // Clear approvals from the previous owner.
1265         assembly {
1266             if approvedAddress {
1267                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1268                 sstore(approvedAddressSlot, 0)
1269             }
1270         }
1271 
1272         // Underflow of the sender's balance is impossible because we check for
1273         // ownership above and the recipient's balance can't realistically overflow.
1274         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1275         unchecked {
1276             // Updates:
1277             // - `balance -= 1`.
1278             // - `numberBurned += 1`.
1279             //
1280             // We can directly decrement the balance, and increment the number burned.
1281             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1282             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1283 
1284             // Updates:
1285             // - `address` to the last owner.
1286             // - `startTimestamp` to the timestamp of burning.
1287             // - `burned` to `true`.
1288             // - `nextInitialized` to `true`.
1289             _packedOwnerships[tokenId] = _packOwnershipData(
1290                 from,
1291                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1292             );
1293 
1294             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1295             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1296                 uint256 nextTokenId = tokenId + 1;
1297                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1298                 if (_packedOwnerships[nextTokenId] == 0) {
1299                     // If the next slot is within bounds.
1300                     if (nextTokenId != _currentIndex) {
1301                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1302                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1303                     }
1304                 }
1305             }
1306         }
1307 
1308         emit Transfer(from, address(0), tokenId);
1309         _afterTokenTransfers(from, address(0), tokenId, 1);
1310 
1311         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1312         unchecked {
1313             _burnCounter++;
1314         }
1315     }
1316 
1317     /**
1318      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1319      *
1320      * @param from address representing the previous owner of the given token ID
1321      * @param to target address that will receive the tokens
1322      * @param tokenId uint256 ID of the token to be transferred
1323      * @param _data bytes optional data to send along with the call
1324      * @return bool whether the call correctly returned the expected magic value
1325      */
1326     function _checkContractOnERC721Received(
1327         address from,
1328         address to,
1329         uint256 tokenId,
1330         bytes memory _data
1331     ) private returns (bool) {
1332         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1333             bytes4 retval
1334         ) {
1335             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1336         } catch (bytes memory reason) {
1337             if (reason.length == 0) {
1338                 revert TransferToNonERC721ReceiverImplementer();
1339             } else {
1340                 assembly {
1341                     revert(add(32, reason), mload(reason))
1342                 }
1343             }
1344         }
1345     }
1346 
1347     /**
1348      * @dev Directly sets the extra data for the ownership data `index`.
1349      */
1350     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1351         uint256 packed = _packedOwnerships[index];
1352         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1353         uint256 extraDataCasted;
1354         // Cast `extraData` with assembly to avoid redundant masking.
1355         assembly {
1356             extraDataCasted := extraData
1357         }
1358         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1359         _packedOwnerships[index] = packed;
1360     }
1361 
1362     /**
1363      * @dev Returns the next extra data for the packed ownership data.
1364      * The returned result is shifted into position.
1365      */
1366     function _nextExtraData(
1367         address from,
1368         address to,
1369         uint256 prevOwnershipPacked
1370     ) private view returns (uint256) {
1371         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1372         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1373     }
1374 
1375     /**
1376      * @dev Called during each token transfer to set the 24bit `extraData` field.
1377      * Intended to be overridden by the cosumer contract.
1378      *
1379      * `previousExtraData` - the value of `extraData` before transfer.
1380      *
1381      * Calling conditions:
1382      *
1383      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1384      * transferred to `to`.
1385      * - When `from` is zero, `tokenId` will be minted for `to`.
1386      * - When `to` is zero, `tokenId` will be burned by `from`.
1387      * - `from` and `to` are never both zero.
1388      */
1389     function _extraData(
1390         address from,
1391         address to,
1392         uint24 previousExtraData
1393     ) internal view virtual returns (uint24) {}
1394 
1395     /**
1396      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1397      * This includes minting.
1398      * And also called before burning one token.
1399      *
1400      * startTokenId - the first token id to be transferred
1401      * quantity - the amount to be transferred
1402      *
1403      * Calling conditions:
1404      *
1405      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1406      * transferred to `to`.
1407      * - When `from` is zero, `tokenId` will be minted for `to`.
1408      * - When `to` is zero, `tokenId` will be burned by `from`.
1409      * - `from` and `to` are never both zero.
1410      */
1411     function _beforeTokenTransfers(
1412         address from,
1413         address to,
1414         uint256 startTokenId,
1415         uint256 quantity
1416     ) internal virtual {}
1417 
1418     /**
1419      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1420      * This includes minting.
1421      * And also called after one token has been burned.
1422      *
1423      * startTokenId - the first token id to be transferred
1424      * quantity - the amount to be transferred
1425      *
1426      * Calling conditions:
1427      *
1428      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1429      * transferred to `to`.
1430      * - When `from` is zero, `tokenId` has been minted for `to`.
1431      * - When `to` is zero, `tokenId` has been burned by `from`.
1432      * - `from` and `to` are never both zero.
1433      */
1434     function _afterTokenTransfers(
1435         address from,
1436         address to,
1437         uint256 startTokenId,
1438         uint256 quantity
1439     ) internal virtual {}
1440 
1441     /**
1442      * @dev Returns the message sender (defaults to `msg.sender`).
1443      *
1444      * If you are writing GSN compatible contracts, you need to override this function.
1445      */
1446     function _msgSenderERC721A() internal view virtual returns (address) {
1447         return msg.sender;
1448     }
1449 
1450     /**
1451      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1452      */
1453     function _toString(uint256 value) internal pure returns (string memory ptr) {
1454         assembly {
1455             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1456             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1457             // We will need 1 32-byte word to store the length,
1458             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1459             ptr := add(mload(0x40), 128)
1460             // Update the free memory pointer to allocate.
1461             mstore(0x40, ptr)
1462 
1463             // Cache the end of the memory to calculate the length later.
1464             let end := ptr
1465 
1466             // We write the string from the rightmost digit to the leftmost digit.
1467             // The following is essentially a do-while loop that also handles the zero case.
1468             // Costs a bit more than early returning for the zero case,
1469             // but cheaper in terms of deployment and overall runtime costs.
1470             for {
1471                 // Initialize and perform the first pass without check.
1472                 let temp := value
1473                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1474                 ptr := sub(ptr, 1)
1475                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1476                 mstore8(ptr, add(48, mod(temp, 10)))
1477                 temp := div(temp, 10)
1478             } temp {
1479                 // Keep dividing `temp` until zero.
1480                 temp := div(temp, 10)
1481             } {
1482                 // Body of the for loop.
1483                 ptr := sub(ptr, 1)
1484                 mstore8(ptr, add(48, mod(temp, 10)))
1485             }
1486 
1487             let length := sub(end, ptr)
1488             // Move the pointer 32 bytes leftwards to make room for the length.
1489             ptr := sub(ptr, 32)
1490             // Store the length.
1491             mstore(ptr, length)
1492         }
1493     }
1494 }
1495 
1496 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1497 
1498 
1499 // ERC721A Contracts v4.1.0
1500 // Creator: Chiru Labs
1501 
1502 pragma solidity ^0.8.4;
1503 
1504 
1505 /**
1506  * @dev Interface of an ERC721AQueryable compliant contract.
1507  */
1508 interface IERC721AQueryable is IERC721A {
1509     /**
1510      * Invalid query range (`start` >= `stop`).
1511      */
1512     error InvalidQueryRange();
1513 
1514     /**
1515      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1516      *
1517      * If the `tokenId` is out of bounds:
1518      *   - `addr` = `address(0)`
1519      *   - `startTimestamp` = `0`
1520      *   - `burned` = `false`
1521      *
1522      * If the `tokenId` is burned:
1523      *   - `addr` = `<Address of owner before token was burned>`
1524      *   - `startTimestamp` = `<Timestamp when token was burned>`
1525      *   - `burned = `true`
1526      *
1527      * Otherwise:
1528      *   - `addr` = `<Address of owner>`
1529      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1530      *   - `burned = `false`
1531      */
1532     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1533 
1534     /**
1535      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1536      * See {ERC721AQueryable-explicitOwnershipOf}
1537      */
1538     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1539 
1540     /**
1541      * @dev Returns an array of token IDs owned by `owner`,
1542      * in the range [`start`, `stop`)
1543      * (i.e. `start <= tokenId < stop`).
1544      *
1545      * This function allows for tokens to be queried if the collection
1546      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1547      *
1548      * Requirements:
1549      *
1550      * - `start` < `stop`
1551      */
1552     function tokensOfOwnerIn(
1553         address owner,
1554         uint256 start,
1555         uint256 stop
1556     ) external view returns (uint256[] memory);
1557 
1558     /**
1559      * @dev Returns an array of token IDs owned by `owner`.
1560      *
1561      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1562      * It is meant to be called off-chain.
1563      *
1564      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1565      * multiple smaller scans if the collection is large enough to cause
1566      * an out-of-gas error (10K pfp collections should be fine).
1567      */
1568     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1569 }
1570 
1571 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1572 
1573 
1574 // ERC721A Contracts v4.1.0
1575 // Creator: Chiru Labs
1576 
1577 pragma solidity ^0.8.4;
1578 
1579 
1580 
1581 /**
1582  * @title ERC721A Queryable
1583  * @dev ERC721A subclass with convenience query functions.
1584  */
1585 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1586     /**
1587      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1588      *
1589      * If the `tokenId` is out of bounds:
1590      *   - `addr` = `address(0)`
1591      *   - `startTimestamp` = `0`
1592      *   - `burned` = `false`
1593      *   - `extraData` = `0`
1594      *
1595      * If the `tokenId` is burned:
1596      *   - `addr` = `<Address of owner before token was burned>`
1597      *   - `startTimestamp` = `<Timestamp when token was burned>`
1598      *   - `burned = `true`
1599      *   - `extraData` = `<Extra data when token was burned>`
1600      *
1601      * Otherwise:
1602      *   - `addr` = `<Address of owner>`
1603      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1604      *   - `burned = `false`
1605      *   - `extraData` = `<Extra data at start of ownership>`
1606      */
1607     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1608         TokenOwnership memory ownership;
1609         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1610             return ownership;
1611         }
1612         ownership = _ownershipAt(tokenId);
1613         if (ownership.burned) {
1614             return ownership;
1615         }
1616         return _ownershipOf(tokenId);
1617     }
1618 
1619     /**
1620      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1621      * See {ERC721AQueryable-explicitOwnershipOf}
1622      */
1623     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1624         unchecked {
1625             uint256 tokenIdsLength = tokenIds.length;
1626             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1627             for (uint256 i; i != tokenIdsLength; ++i) {
1628                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1629             }
1630             return ownerships;
1631         }
1632     }
1633 
1634     /**
1635      * @dev Returns an array of token IDs owned by `owner`,
1636      * in the range [`start`, `stop`)
1637      * (i.e. `start <= tokenId < stop`).
1638      *
1639      * This function allows for tokens to be queried if the collection
1640      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1641      *
1642      * Requirements:
1643      *
1644      * - `start` < `stop`
1645      */
1646     function tokensOfOwnerIn(
1647         address owner,
1648         uint256 start,
1649         uint256 stop
1650     ) external view override returns (uint256[] memory) {
1651         unchecked {
1652             if (start >= stop) revert InvalidQueryRange();
1653             uint256 tokenIdsIdx;
1654             uint256 stopLimit = _nextTokenId();
1655             // Set `start = max(start, _startTokenId())`.
1656             if (start < _startTokenId()) {
1657                 start = _startTokenId();
1658             }
1659             // Set `stop = min(stop, stopLimit)`.
1660             if (stop > stopLimit) {
1661                 stop = stopLimit;
1662             }
1663             uint256 tokenIdsMaxLength = balanceOf(owner);
1664             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1665             // to cater for cases where `balanceOf(owner)` is too big.
1666             if (start < stop) {
1667                 uint256 rangeLength = stop - start;
1668                 if (rangeLength < tokenIdsMaxLength) {
1669                     tokenIdsMaxLength = rangeLength;
1670                 }
1671             } else {
1672                 tokenIdsMaxLength = 0;
1673             }
1674             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1675             if (tokenIdsMaxLength == 0) {
1676                 return tokenIds;
1677             }
1678             // We need to call `explicitOwnershipOf(start)`,
1679             // because the slot at `start` may not be initialized.
1680             TokenOwnership memory ownership = explicitOwnershipOf(start);
1681             address currOwnershipAddr;
1682             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1683             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1684             if (!ownership.burned) {
1685                 currOwnershipAddr = ownership.addr;
1686             }
1687             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1688                 ownership = _ownershipAt(i);
1689                 if (ownership.burned) {
1690                     continue;
1691                 }
1692                 if (ownership.addr != address(0)) {
1693                     currOwnershipAddr = ownership.addr;
1694                 }
1695                 if (currOwnershipAddr == owner) {
1696                     tokenIds[tokenIdsIdx++] = i;
1697                 }
1698             }
1699             // Downsize the array to fit.
1700             assembly {
1701                 mstore(tokenIds, tokenIdsIdx)
1702             }
1703             return tokenIds;
1704         }
1705     }
1706 
1707     /**
1708      * @dev Returns an array of token IDs owned by `owner`.
1709      *
1710      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1711      * It is meant to be called off-chain.
1712      *
1713      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1714      * multiple smaller scans if the collection is large enough to cause
1715      * an out-of-gas error (10K pfp collections should be fine).
1716      */
1717     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1718         unchecked {
1719             uint256 tokenIdsIdx;
1720             address currOwnershipAddr;
1721             uint256 tokenIdsLength = balanceOf(owner);
1722             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1723             TokenOwnership memory ownership;
1724             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1725                 ownership = _ownershipAt(i);
1726                 if (ownership.burned) {
1727                     continue;
1728                 }
1729                 if (ownership.addr != address(0)) {
1730                     currOwnershipAddr = ownership.addr;
1731                 }
1732                 if (currOwnershipAddr == owner) {
1733                     tokenIds[tokenIdsIdx++] = i;
1734                 }
1735             }
1736             return tokenIds;
1737         }
1738     }
1739 }
1740 
1741 
1742 
1743 pragma solidity >=0.8.9 <0.9.0;
1744 
1745 contract KikiDaigaku is ERC721AQueryable, Ownable, ReentrancyGuard {
1746     using Strings for uint256;
1747 
1748     uint256 public maxSupply = 1111;
1749 	uint256 public Ownermint = 3;
1750     uint256 public maxPerAddress = 2;
1751 	uint256 public maxPerTX = 2;
1752     uint256 public cost = 0 ether;
1753 	mapping(address => bool) public freeMinted; 
1754 
1755     bool public paused = true;
1756 
1757 	string public uriPrefix = '';
1758     string public uriSuffix = '';
1759 	
1760   constructor(string memory baseURI) ERC721A("KikiDaigaku", "KIGAKU") {
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
1795         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
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
1815   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1816     uriSuffix = _uriSuffix;
1817   }
1818 
1819   function withdraw() external onlyOwner {
1820         payable(msg.sender).transfer(address(this).balance);
1821   }
1822 
1823   function _startTokenId() internal view virtual override returns (uint256) {
1824     return 1;
1825   }
1826 
1827   function _baseURI() internal view virtual override returns (string memory) {
1828     return uriPrefix;
1829   }
1830 }