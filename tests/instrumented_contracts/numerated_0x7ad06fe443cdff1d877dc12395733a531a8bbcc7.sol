1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4 Where am i?.......                                   
5                                                                            
6 */
7 
8 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Contract module that helps prevent reentrant calls to a function.
14  *
15  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
16  * available, which can be applied to functions to make sure there are no nested
17  * (reentrant) calls to them.
18  *
19  * Note that because there is a single `nonReentrant` guard, functions marked as
20  * `nonReentrant` may not call one another. This can be worked around by making
21  * those functions `private`, and then adding `external` `nonReentrant` entry
22  * points to them.
23  *
24  * TIP: If you would like to learn more about reentrancy and alternative ways
25  * to protect against it, check out our blog post
26  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
27  */
28 abstract contract ReentrancyGuard {
29     // Booleans are more expensive than uint256 or any type that takes up a full
30     // word because each write operation emits an extra SLOAD to first read the
31     // slot's contents, replace the bits taken up by the boolean, and then write
32     // back. This is the compiler's defense against contract upgrades and
33     // pointer aliasing, and it cannot be disabled.
34 
35     // The values being non-zero value makes deployment a bit more expensive,
36     // but in exchange the refund on every call to nonReentrant will be lower in
37     // amount. Since refunds are capped to a percentage of the total
38     // transaction's gas, it is best to keep them low in cases like this one, to
39     // increase the likelihood of the full refund coming into effect.
40     uint256 private constant _NOT_ENTERED = 1;
41     uint256 private constant _ENTERED = 2;
42 
43     uint256 private _status;
44 
45     constructor() {
46         _status = _NOT_ENTERED;
47     }
48 
49     /**
50      * @dev Prevents a contract from calling itself, directly or indirectly.
51      * Calling a `nonReentrant` function from another `nonReentrant`
52      * function is not supported. It is possible to prevent this from happening
53      * by making the `nonReentrant` function external, and making it call a
54      * `private` function that does the actual work.
55      */
56     modifier nonReentrant() {
57         // On the first call to nonReentrant, _notEntered will be true
58         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
59 
60         // Any calls to nonReentrant after this point will fail
61         _status = _ENTERED;
62 
63         _;
64 
65         // By storing the original value once again, a refund is triggered (see
66         // https://eips.ethereum.org/EIPS/eip-2200)
67         _status = _NOT_ENTERED;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Strings.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev String operations.
80  */
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83     uint8 private constant _ADDRESS_LENGTH = 20;
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
87      */
88     function toString(uint256 value) internal pure returns (string memory) {
89         // Inspired by OraclizeAPI's implementation - MIT licence
90         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
91 
92         if (value == 0) {
93             return "0";
94         }
95         uint256 temp = value;
96         uint256 digits;
97         while (temp != 0) {
98             digits++;
99             temp /= 10;
100         }
101         bytes memory buffer = new bytes(digits);
102         while (value != 0) {
103             digits -= 1;
104             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
105             value /= 10;
106         }
107         return string(buffer);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
112      */
113     function toHexString(uint256 value) internal pure returns (string memory) {
114         if (value == 0) {
115             return "0x00";
116         }
117         uint256 temp = value;
118         uint256 length = 0;
119         while (temp != 0) {
120             length++;
121             temp >>= 8;
122         }
123         return toHexString(value, length);
124     }
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
128      */
129     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
130         bytes memory buffer = new bytes(2 * length + 2);
131         buffer[0] = "0";
132         buffer[1] = "x";
133         for (uint256 i = 2 * length + 1; i > 1; --i) {
134             buffer[i] = _HEX_SYMBOLS[value & 0xf];
135             value >>= 4;
136         }
137         require(value == 0, "Strings: hex length insufficient");
138         return string(buffer);
139     }
140 
141     /**
142      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
143      */
144     function toHexString(address addr) internal pure returns (string memory) {
145         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
146     }
147 }
148 
149 
150 // File: @openzeppelin/contracts/utils/Context.sol
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
154 
155 pragma solidity ^0.8.0;
156 
157 /**
158  * @dev Provides information about the current execution context, including the
159  * sender of the transaction and its data. While these are generally available
160  * via msg.sender and msg.data, they should not be accessed in such a direct
161  * manner, since when dealing with meta-transactions the account sending and
162  * paying for execution may not be the actual sender (as far as an application
163  * is concerned).
164  *
165  * This contract is only required for intermediate, library-like contracts.
166  */
167 abstract contract Context {
168     function _msgSender() internal view virtual returns (address) {
169         return msg.sender;
170     }
171 
172     function _msgData() internal view virtual returns (bytes calldata) {
173         return msg.data;
174     }
175 }
176 
177 // File: @openzeppelin/contracts/access/Ownable.sol
178 
179 
180 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 
185 /**
186  * @dev Contract module which provides a basic access control mechanism, where
187  * there is an account (an owner) that can be granted exclusive access to
188  * specific functions.
189  *
190  * By default, the owner account will be the one that deploys the contract. This
191  * can later be changed with {transferOwnership}.
192  *
193  * This module is used through inheritance. It will make available the modifier
194  * `onlyOwner`, which can be applied to your functions to restrict their use to
195  * the owner.
196  */
197 abstract contract Ownable is Context {
198     address private _owner;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     /**
203      * @dev Initializes the contract setting the deployer as the initial owner.
204      */
205     constructor() {
206         _transferOwnership(_msgSender());
207     }
208 
209     /**
210      * @dev Throws if called by any account other than the owner.
211      */
212     modifier onlyOwner() {
213         _checkOwner();
214         _;
215     }
216 
217     /**
218      * @dev Returns the address of the current owner.
219      */
220     function owner() public view virtual returns (address) {
221         return _owner;
222     }
223 
224     /**
225      * @dev Throws if the sender is not the owner.
226      */
227     function _checkOwner() internal view virtual {
228         require(owner() == _msgSender(), "Ownable: caller is not the owner");
229     }
230 
231     /**
232      * @dev Leaves the contract without owner. It will not be possible to call
233      * `onlyOwner` functions anymore. Can only be called by the current owner.
234      *
235      * NOTE: Renouncing ownership will leave the contract without an owner,
236      * thereby removing any functionality that is only available to the owner.
237      */
238     function renounceOwnership() public virtual onlyOwner {
239         _transferOwnership(address(0));
240     }
241 
242     /**
243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
244      * Can only be called by the current owner.
245      */
246     function transferOwnership(address newOwner) public virtual onlyOwner {
247         require(newOwner != address(0), "Ownable: new owner is the zero address");
248         _transferOwnership(newOwner);
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      * Internal function without access restriction.
254      */
255     function _transferOwnership(address newOwner) internal virtual {
256         address oldOwner = _owner;
257         _owner = newOwner;
258         emit OwnershipTransferred(oldOwner, newOwner);
259     }
260 }
261 
262 // File: erc721a/contracts/IERC721A.sol
263 
264 
265 // ERC721A Contracts v4.1.0
266 // Creator: Chiru Labs
267 
268 pragma solidity ^0.8.4;
269 
270 /**
271  * @dev Interface of an ERC721A compliant contract.
272  */
273 interface IERC721A {
274     /**
275      * The caller must own the token or be an approved operator.
276      */
277     error ApprovalCallerNotOwnerNorApproved();
278 
279     /**
280      * The token does not exist.
281      */
282     error ApprovalQueryForNonexistentToken();
283 
284     /**
285      * The caller cannot approve to their own address.
286      */
287     error ApproveToCaller();
288 
289     /**
290      * Cannot query the balance for the zero address.
291      */
292     error BalanceQueryForZeroAddress();
293 
294     /**
295      * Cannot mint to the zero address.
296      */
297     error MintToZeroAddress();
298 
299     /**
300      * The quantity of tokens minted must be more than zero.
301      */
302     error MintZeroQuantity();
303 
304     /**
305      * The token does not exist.
306      */
307     error OwnerQueryForNonexistentToken();
308 
309     /**
310      * The caller must own the token or be an approved operator.
311      */
312     error TransferCallerNotOwnerNorApproved();
313 
314     /**
315      * The token must be owned by `from`.
316      */
317     error TransferFromIncorrectOwner();
318 
319     /**
320      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
321      */
322     error TransferToNonERC721ReceiverImplementer();
323 
324     /**
325      * Cannot transfer to the zero address.
326      */
327     error TransferToZeroAddress();
328 
329     /**
330      * The token does not exist.
331      */
332     error URIQueryForNonexistentToken();
333 
334     /**
335      * The `quantity` minted with ERC2309 exceeds the safety limit.
336      */
337     error MintERC2309QuantityExceedsLimit();
338 
339     /**
340      * The `extraData` cannot be set on an unintialized ownership slot.
341      */
342     error OwnershipNotInitializedForExtraData();
343 
344     struct TokenOwnership {
345         // The address of the owner.
346         address addr;
347         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
348         uint64 startTimestamp;
349         // Whether the token has been burned.
350         bool burned;
351         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
352         uint24 extraData;
353     }
354 
355     /**
356      * @dev Returns the total amount of tokens stored by the contract.
357      *
358      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
359      */
360     function totalSupply() external view returns (uint256);
361 
362     // ==============================
363     //            IERC165
364     // ==============================
365 
366     /**
367      * @dev Returns true if this contract implements the interface defined by
368      * `interfaceId`. See the corresponding
369      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
370      * to learn more about how these ids are created.
371      *
372      * This function call must use less than 30 000 gas.
373      */
374     function supportsInterface(bytes4 interfaceId) external view returns (bool);
375 
376     // ==============================
377     //            IERC721
378     // ==============================
379 
380     /**
381      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
382      */
383     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
384 
385     /**
386      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
387      */
388     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
389 
390     /**
391      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
392      */
393     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
394 
395     /**
396      * @dev Returns the number of tokens in ``owner``'s account.
397      */
398     function balanceOf(address owner) external view returns (uint256 balance);
399 
400     /**
401      * @dev Returns the owner of the `tokenId` token.
402      *
403      * Requirements:
404      *
405      * - `tokenId` must exist.
406      */
407     function ownerOf(uint256 tokenId) external view returns (address owner);
408 
409     /**
410      * @dev Safely transfers `tokenId` token from `from` to `to`.
411      *
412      * Requirements:
413      *
414      * - `from` cannot be the zero address.
415      * - `to` cannot be the zero address.
416      * - `tokenId` token must exist and be owned by `from`.
417      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
418      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
419      *
420      * Emits a {Transfer} event.
421      */
422     function safeTransferFrom(
423         address from,
424         address to,
425         uint256 tokenId,
426         bytes calldata data
427     ) external;
428 
429     /**
430      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
431      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `tokenId` token must exist and be owned by `from`.
438      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
440      *
441      * Emits a {Transfer} event.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId
447     ) external;
448 
449     /**
450      * @dev Transfers `tokenId` token from `from` to `to`.
451      *
452      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must be owned by `from`.
459      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
460      *
461      * Emits a {Transfer} event.
462      */
463     function transferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) external;
468 
469     /**
470      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
471      * The approval is cleared when the token is transferred.
472      *
473      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
474      *
475      * Requirements:
476      *
477      * - The caller must own the token or be an approved operator.
478      * - `tokenId` must exist.
479      *
480      * Emits an {Approval} event.
481      */
482     function approve(address to, uint256 tokenId) external;
483 
484     /**
485      * @dev Approve or remove `operator` as an operator for the caller.
486      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
487      *
488      * Requirements:
489      *
490      * - The `operator` cannot be the caller.
491      *
492      * Emits an {ApprovalForAll} event.
493      */
494     function setApprovalForAll(address operator, bool _approved) external;
495 
496     /**
497      * @dev Returns the account approved for `tokenId` token.
498      *
499      * Requirements:
500      *
501      * - `tokenId` must exist.
502      */
503     function getApproved(uint256 tokenId) external view returns (address operator);
504 
505     /**
506      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
507      *
508      * See {setApprovalForAll}
509      */
510     function isApprovedForAll(address owner, address operator) external view returns (bool);
511 
512     // ==============================
513     //        IERC721Metadata
514     // ==============================
515 
516     /**
517      * @dev Returns the token collection name.
518      */
519     function name() external view returns (string memory);
520 
521     /**
522      * @dev Returns the token collection symbol.
523      */
524     function symbol() external view returns (string memory);
525 
526     /**
527      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
528      */
529     function tokenURI(uint256 tokenId) external view returns (string memory);
530 
531     // ==============================
532     //            IERC2309
533     // ==============================
534 
535     /**
536      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
537      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
538      */
539     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
540 }
541 
542 // File: erc721a/contracts/ERC721A.sol
543 
544 
545 // ERC721A Contracts v4.1.0
546 // Creator: Chiru Labs
547 
548 pragma solidity ^0.8.4;
549 
550 
551 /**
552  * @dev ERC721 token receiver interface.
553  */
554 interface ERC721A__IERC721Receiver {
555     function onERC721Received(
556         address operator,
557         address from,
558         uint256 tokenId,
559         bytes calldata data
560     ) external returns (bytes4);
561 }
562 
563 /**
564  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
565  * including the Metadata extension. Built to optimize for lower gas during batch mints.
566  *
567  * Assumes serials are sequentially minted starting at `_startTokenId()`
568  * (defaults to 0, e.g. 0, 1, 2, 3..).
569  *
570  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
571  *
572  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
573  */
574 contract ERC721A is IERC721A {
575     // Mask of an entry in packed address data.
576     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
577 
578     // The bit position of `numberMinted` in packed address data.
579     uint256 private constant BITPOS_NUMBER_MINTED = 64;
580 
581     // The bit position of `numberBurned` in packed address data.
582     uint256 private constant BITPOS_NUMBER_BURNED = 128;
583 
584     // The bit position of `aux` in packed address data.
585     uint256 private constant BITPOS_AUX = 192;
586 
587     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
588     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
589 
590     // The bit position of `startTimestamp` in packed ownership.
591     uint256 private constant BITPOS_START_TIMESTAMP = 160;
592 
593     // The bit mask of the `burned` bit in packed ownership.
594     uint256 private constant BITMASK_BURNED = 1 << 224;
595 
596     // The bit position of the `nextInitialized` bit in packed ownership.
597     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
598 
599     // The bit mask of the `nextInitialized` bit in packed ownership.
600     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
601 
602     // The bit position of `extraData` in packed ownership.
603     uint256 private constant BITPOS_EXTRA_DATA = 232;
604 
605     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
606     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
607 
608     // The mask of the lower 160 bits for addresses.
609     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
610 
611     // The maximum `quantity` that can be minted with `_mintERC2309`.
612     // This limit is to prevent overflows on the address data entries.
613     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
614     // is required to cause an overflow, which is unrealistic.
615     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
616 
617     // The tokenId of the next token to be minted.
618     uint256 private _currentIndex;
619 
620     // The number of tokens burned.
621     uint256 private _burnCounter;
622 
623     // Token name
624     string private _name;
625 
626     // Token symbol
627     string private _symbol;
628 
629     // Mapping from token ID to ownership details
630     // An empty struct value does not necessarily mean the token is unowned.
631     // See `_packedOwnershipOf` implementation for details.
632     //
633     // Bits Layout:
634     // - [0..159]   `addr`
635     // - [160..223] `startTimestamp`
636     // - [224]      `burned`
637     // - [225]      `nextInitialized`
638     // - [232..255] `extraData`
639     mapping(uint256 => uint256) private _packedOwnerships;
640 
641     // Mapping owner address to address data.
642     //
643     // Bits Layout:
644     // - [0..63]    `balance`
645     // - [64..127]  `numberMinted`
646     // - [128..191] `numberBurned`
647     // - [192..255] `aux`
648     mapping(address => uint256) private _packedAddressData;
649 
650     // Mapping from token ID to approved address.
651     mapping(uint256 => address) private _tokenApprovals;
652 
653     // Mapping from owner to operator approvals
654     mapping(address => mapping(address => bool)) private _operatorApprovals;
655 
656     constructor(string memory name_, string memory symbol_) {
657         _name = name_;
658         _symbol = symbol_;
659         _currentIndex = _startTokenId();
660     }
661 
662     /**
663      * @dev Returns the starting token ID.
664      * To change the starting token ID, please override this function.
665      */
666     function _startTokenId() internal view virtual returns (uint256) {
667         return 0;
668     }
669 
670     /**
671      * @dev Returns the next token ID to be minted.
672      */
673     function _nextTokenId() internal view returns (uint256) {
674         return _currentIndex;
675     }
676 
677     /**
678      * @dev Returns the total number of tokens in existence.
679      * Burned tokens will reduce the count.
680      * To get the total number of tokens minted, please see `_totalMinted`.
681      */
682     function totalSupply() public view override returns (uint256) {
683         // Counter underflow is impossible as _burnCounter cannot be incremented
684         // more than `_currentIndex - _startTokenId()` times.
685         unchecked {
686             return _currentIndex - _burnCounter - _startTokenId();
687         }
688     }
689 
690     /**
691      * @dev Returns the total amount of tokens minted in the contract.
692      */
693     function _totalMinted() internal view returns (uint256) {
694         // Counter underflow is impossible as _currentIndex does not decrement,
695         // and it is initialized to `_startTokenId()`
696         unchecked {
697             return _currentIndex - _startTokenId();
698         }
699     }
700 
701     /**
702      * @dev Returns the total number of tokens burned.
703      */
704     function _totalBurned() internal view returns (uint256) {
705         return _burnCounter;
706     }
707 
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
712         // The interface IDs are constants representing the first 4 bytes of the XOR of
713         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
714         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
715         return
716             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
717             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
718             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
719     }
720 
721     /**
722      * @dev See {IERC721-balanceOf}.
723      */
724     function balanceOf(address owner) public view override returns (uint256) {
725         if (owner == address(0)) revert BalanceQueryForZeroAddress();
726         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
727     }
728 
729     /**
730      * Returns the number of tokens minted by `owner`.
731      */
732     function _numberMinted(address owner) internal view returns (uint256) {
733         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
734     }
735 
736     /**
737      * Returns the number of tokens burned by or on behalf of `owner`.
738      */
739     function _numberBurned(address owner) internal view returns (uint256) {
740         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
741     }
742 
743     /**
744      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
745      */
746     function _getAux(address owner) internal view returns (uint64) {
747         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
748     }
749 
750     /**
751      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
752      * If there are multiple variables, please pack them into a uint64.
753      */
754     function _setAux(address owner, uint64 aux) internal {
755         uint256 packed = _packedAddressData[owner];
756         uint256 auxCasted;
757         // Cast `aux` with assembly to avoid redundant masking.
758         assembly {
759             auxCasted := aux
760         }
761         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
762         _packedAddressData[owner] = packed;
763     }
764 
765     /**
766      * Returns the packed ownership data of `tokenId`.
767      */
768     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
769         uint256 curr = tokenId;
770 
771         unchecked {
772             if (_startTokenId() <= curr)
773                 if (curr < _currentIndex) {
774                     uint256 packed = _packedOwnerships[curr];
775                     // If not burned.
776                     if (packed & BITMASK_BURNED == 0) {
777                         // Invariant:
778                         // There will always be an ownership that has an address and is not burned
779                         // before an ownership that does not have an address and is not burned.
780                         // Hence, curr will not underflow.
781                         //
782                         // We can directly compare the packed value.
783                         // If the address is zero, packed is zero.
784                         while (packed == 0) {
785                             packed = _packedOwnerships[--curr];
786                         }
787                         return packed;
788                     }
789                 }
790         }
791         revert OwnerQueryForNonexistentToken();
792     }
793 
794     /**
795      * Returns the unpacked `TokenOwnership` struct from `packed`.
796      */
797     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
798         ownership.addr = address(uint160(packed));
799         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
800         ownership.burned = packed & BITMASK_BURNED != 0;
801         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
802     }
803 
804     /**
805      * Returns the unpacked `TokenOwnership` struct at `index`.
806      */
807     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
808         return _unpackedOwnership(_packedOwnerships[index]);
809     }
810 
811     /**
812      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
813      */
814     function _initializeOwnershipAt(uint256 index) internal {
815         if (_packedOwnerships[index] == 0) {
816             _packedOwnerships[index] = _packedOwnershipOf(index);
817         }
818     }
819 
820     /**
821      * Gas spent here starts off proportional to the maximum mint batch size.
822      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
823      */
824     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
825         return _unpackedOwnership(_packedOwnershipOf(tokenId));
826     }
827 
828     /**
829      * @dev Packs ownership data into a single uint256.
830      */
831     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
832         assembly {
833             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
834             owner := and(owner, BITMASK_ADDRESS)
835             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
836             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
837         }
838     }
839 
840     /**
841      * @dev See {IERC721-ownerOf}.
842      */
843     function ownerOf(uint256 tokenId) public view override returns (address) {
844         return address(uint160(_packedOwnershipOf(tokenId)));
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-name}.
849      */
850     function name() public view virtual override returns (string memory) {
851         return _name;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-symbol}.
856      */
857     function symbol() public view virtual override returns (string memory) {
858         return _symbol;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-tokenURI}.
863      */
864     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
865         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
866 
867         string memory baseURI = _baseURI();
868         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
869     }
870 
871     /**
872      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
873      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
874      * by default, it can be overridden in child contracts.
875      */
876     function _baseURI() internal view virtual returns (string memory) {
877         return '';
878     }
879 
880     /**
881      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
882      */
883     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
884         // For branchless setting of the `nextInitialized` flag.
885         assembly {
886             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
887             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
888         }
889     }
890 
891     /**
892      * @dev See {IERC721-approve}.
893      */
894     function approve(address to, uint256 tokenId) public override {
895         address owner = ownerOf(tokenId);
896 
897         if (_msgSenderERC721A() != owner)
898             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
899                 revert ApprovalCallerNotOwnerNorApproved();
900             }
901 
902         _tokenApprovals[tokenId] = to;
903         emit Approval(owner, to, tokenId);
904     }
905 
906     /**
907      * @dev See {IERC721-getApproved}.
908      */
909     function getApproved(uint256 tokenId) public view override returns (address) {
910         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
911 
912         return _tokenApprovals[tokenId];
913     }
914 
915     /**
916      * @dev See {IERC721-setApprovalForAll}.
917      */
918     function setApprovalForAll(address operator, bool approved) public virtual override {
919         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
920 
921         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
922         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
923     }
924 
925     /**
926      * @dev See {IERC721-isApprovedForAll}.
927      */
928     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
929         return _operatorApprovals[owner][operator];
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public virtual override {
940         safeTransferFrom(from, to, tokenId, '');
941     }
942 
943     /**
944      * @dev See {IERC721-safeTransferFrom}.
945      */
946     function safeTransferFrom(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) public virtual override {
952         transferFrom(from, to, tokenId);
953         if (to.code.length != 0)
954             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
955                 revert TransferToNonERC721ReceiverImplementer();
956             }
957     }
958 
959     /**
960      * @dev Returns whether `tokenId` exists.
961      *
962      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
963      *
964      * Tokens start existing when they are minted (`_mint`),
965      */
966     function _exists(uint256 tokenId) internal view returns (bool) {
967         return
968             _startTokenId() <= tokenId &&
969             tokenId < _currentIndex && // If within bounds,
970             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
971     }
972 
973     /**
974      * @dev Equivalent to `_safeMint(to, quantity, '')`.
975      */
976     function _safeMint(address to, uint256 quantity) internal {
977         _safeMint(to, quantity, '');
978     }
979 
980     /**
981      * @dev Safely mints `quantity` tokens and transfers them to `to`.
982      *
983      * Requirements:
984      *
985      * - If `to` refers to a smart contract, it must implement
986      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
987      * - `quantity` must be greater than 0.
988      *
989      * See {_mint}.
990      *
991      * Emits a {Transfer} event for each mint.
992      */
993     function _safeMint(
994         address to,
995         uint256 quantity,
996         bytes memory _data
997     ) internal {
998         _mint(to, quantity);
999 
1000         unchecked {
1001             if (to.code.length != 0) {
1002                 uint256 end = _currentIndex;
1003                 uint256 index = end - quantity;
1004                 do {
1005                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1006                         revert TransferToNonERC721ReceiverImplementer();
1007                     }
1008                 } while (index < end);
1009                 // Reentrancy protection.
1010                 if (_currentIndex != end) revert();
1011             }
1012         }
1013     }
1014 
1015     /**
1016      * @dev Mints `quantity` tokens and transfers them to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `quantity` must be greater than 0.
1022      *
1023      * Emits a {Transfer} event for each mint.
1024      */
1025     function _mint(address to, uint256 quantity) internal {
1026         uint256 startTokenId = _currentIndex;
1027         if (to == address(0)) revert MintToZeroAddress();
1028         if (quantity == 0) revert MintZeroQuantity();
1029 
1030         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1031 
1032         // Overflows are incredibly unrealistic.
1033         // `balance` and `numberMinted` have a maximum limit of 2**64.
1034         // `tokenId` has a maximum limit of 2**256.
1035         unchecked {
1036             // Updates:
1037             // - `balance += quantity`.
1038             // - `numberMinted += quantity`.
1039             //
1040             // We can directly add to the `balance` and `numberMinted`.
1041             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1042 
1043             // Updates:
1044             // - `address` to the owner.
1045             // - `startTimestamp` to the timestamp of minting.
1046             // - `burned` to `false`.
1047             // - `nextInitialized` to `quantity == 1`.
1048             _packedOwnerships[startTokenId] = _packOwnershipData(
1049                 to,
1050                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1051             );
1052 
1053             uint256 tokenId = startTokenId;
1054             uint256 end = startTokenId + quantity;
1055             do {
1056                 emit Transfer(address(0), to, tokenId++);
1057             } while (tokenId < end);
1058 
1059             _currentIndex = end;
1060         }
1061         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1062     }
1063 
1064     /**
1065      * @dev Mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * This function is intended for efficient minting only during contract creation.
1068      *
1069      * It emits only one {ConsecutiveTransfer} as defined in
1070      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1071      * instead of a sequence of {Transfer} event(s).
1072      *
1073      * Calling this function outside of contract creation WILL make your contract
1074      * non-compliant with the ERC721 standard.
1075      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1076      * {ConsecutiveTransfer} event is only permissible during contract creation.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {ConsecutiveTransfer} event.
1084      */
1085     function _mintERC2309(address to, uint256 quantity) internal {
1086         uint256 startTokenId = _currentIndex;
1087         if (to == address(0)) revert MintToZeroAddress();
1088         if (quantity == 0) revert MintZeroQuantity();
1089         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1090 
1091         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1092 
1093         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1094         unchecked {
1095             // Updates:
1096             // - `balance += quantity`.
1097             // - `numberMinted += quantity`.
1098             //
1099             // We can directly add to the `balance` and `numberMinted`.
1100             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1101 
1102             // Updates:
1103             // - `address` to the owner.
1104             // - `startTimestamp` to the timestamp of minting.
1105             // - `burned` to `false`.
1106             // - `nextInitialized` to `quantity == 1`.
1107             _packedOwnerships[startTokenId] = _packOwnershipData(
1108                 to,
1109                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1110             );
1111 
1112             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1113 
1114             _currentIndex = startTokenId + quantity;
1115         }
1116         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1117     }
1118 
1119     /**
1120      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1121      */
1122     function _getApprovedAddress(uint256 tokenId)
1123         private
1124         view
1125         returns (uint256 approvedAddressSlot, address approvedAddress)
1126     {
1127         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1128         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1129         assembly {
1130             // Compute the slot.
1131             mstore(0x00, tokenId)
1132             mstore(0x20, tokenApprovalsPtr.slot)
1133             approvedAddressSlot := keccak256(0x00, 0x40)
1134             // Load the slot's value from storage.
1135             approvedAddress := sload(approvedAddressSlot)
1136         }
1137     }
1138 
1139     /**
1140      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1141      */
1142     function _isOwnerOrApproved(
1143         address approvedAddress,
1144         address from,
1145         address msgSender
1146     ) private pure returns (bool result) {
1147         assembly {
1148             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1149             from := and(from, BITMASK_ADDRESS)
1150             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1151             msgSender := and(msgSender, BITMASK_ADDRESS)
1152             // `msgSender == from || msgSender == approvedAddress`.
1153             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1154         }
1155     }
1156 
1157     /**
1158      * @dev Transfers `tokenId` from `from` to `to`.
1159      *
1160      * Requirements:
1161      *
1162      * - `to` cannot be the zero address.
1163      * - `tokenId` token must be owned by `from`.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function transferFrom(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) public virtual override {
1172         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1173 
1174         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1175 
1176         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1177 
1178         // The nested ifs save around 20+ gas over a compound boolean condition.
1179         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1180             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1181 
1182         if (to == address(0)) revert TransferToZeroAddress();
1183 
1184         _beforeTokenTransfers(from, to, tokenId, 1);
1185 
1186         // Clear approvals from the previous owner.
1187         assembly {
1188             if approvedAddress {
1189                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1190                 sstore(approvedAddressSlot, 0)
1191             }
1192         }
1193 
1194         // Underflow of the sender's balance is impossible because we check for
1195         // ownership above and the recipient's balance can't realistically overflow.
1196         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1197         unchecked {
1198             // We can directly increment and decrement the balances.
1199             --_packedAddressData[from]; // Updates: `balance -= 1`.
1200             ++_packedAddressData[to]; // Updates: `balance += 1`.
1201 
1202             // Updates:
1203             // - `address` to the next owner.
1204             // - `startTimestamp` to the timestamp of transfering.
1205             // - `burned` to `false`.
1206             // - `nextInitialized` to `true`.
1207             _packedOwnerships[tokenId] = _packOwnershipData(
1208                 to,
1209                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1210             );
1211 
1212             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1213             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1214                 uint256 nextTokenId = tokenId + 1;
1215                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1216                 if (_packedOwnerships[nextTokenId] == 0) {
1217                     // If the next slot is within bounds.
1218                     if (nextTokenId != _currentIndex) {
1219                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1220                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1221                     }
1222                 }
1223             }
1224         }
1225 
1226         emit Transfer(from, to, tokenId);
1227         _afterTokenTransfers(from, to, tokenId, 1);
1228     }
1229 
1230     /**
1231      * @dev Equivalent to `_burn(tokenId, false)`.
1232      */
1233     function _burn(uint256 tokenId) internal virtual {
1234         _burn(tokenId, false);
1235     }
1236 
1237     /**
1238      * @dev Destroys `tokenId`.
1239      * The approval is cleared when the token is burned.
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must exist.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1248         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1249 
1250         address from = address(uint160(prevOwnershipPacked));
1251 
1252         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1253 
1254         if (approvalCheck) {
1255             // The nested ifs save around 20+ gas over a compound boolean condition.
1256             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1257                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1258         }
1259 
1260         _beforeTokenTransfers(from, address(0), tokenId, 1);
1261 
1262         // Clear approvals from the previous owner.
1263         assembly {
1264             if approvedAddress {
1265                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1266                 sstore(approvedAddressSlot, 0)
1267             }
1268         }
1269 
1270         // Underflow of the sender's balance is impossible because we check for
1271         // ownership above and the recipient's balance can't realistically overflow.
1272         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1273         unchecked {
1274             // Updates:
1275             // - `balance -= 1`.
1276             // - `numberBurned += 1`.
1277             //
1278             // We can directly decrement the balance, and increment the number burned.
1279             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1280             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1281 
1282             // Updates:
1283             // - `address` to the last owner.
1284             // - `startTimestamp` to the timestamp of burning.
1285             // - `burned` to `true`.
1286             // - `nextInitialized` to `true`.
1287             _packedOwnerships[tokenId] = _packOwnershipData(
1288                 from,
1289                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1290             );
1291 
1292             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1293             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1294                 uint256 nextTokenId = tokenId + 1;
1295                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1296                 if (_packedOwnerships[nextTokenId] == 0) {
1297                     // If the next slot is within bounds.
1298                     if (nextTokenId != _currentIndex) {
1299                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1300                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1301                     }
1302                 }
1303             }
1304         }
1305 
1306         emit Transfer(from, address(0), tokenId);
1307         _afterTokenTransfers(from, address(0), tokenId, 1);
1308 
1309         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1310         unchecked {
1311             _burnCounter++;
1312         }
1313     }
1314 
1315     /**
1316      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1317      *
1318      * @param from address representing the previous owner of the given token ID
1319      * @param to target address that will receive the tokens
1320      * @param tokenId uint256 ID of the token to be transferred
1321      * @param _data bytes optional data to send along with the call
1322      * @return bool whether the call correctly returned the expected magic value
1323      */
1324     function _checkContractOnERC721Received(
1325         address from,
1326         address to,
1327         uint256 tokenId,
1328         bytes memory _data
1329     ) private returns (bool) {
1330         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1331             bytes4 retval
1332         ) {
1333             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1334         } catch (bytes memory reason) {
1335             if (reason.length == 0) {
1336                 revert TransferToNonERC721ReceiverImplementer();
1337             } else {
1338                 assembly {
1339                     revert(add(32, reason), mload(reason))
1340                 }
1341             }
1342         }
1343     }
1344 
1345     /**
1346      * @dev Directly sets the extra data for the ownership data `index`.
1347      */
1348     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1349         uint256 packed = _packedOwnerships[index];
1350         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1351         uint256 extraDataCasted;
1352         // Cast `extraData` with assembly to avoid redundant masking.
1353         assembly {
1354             extraDataCasted := extraData
1355         }
1356         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1357         _packedOwnerships[index] = packed;
1358     }
1359 
1360     /**
1361      * @dev Returns the next extra data for the packed ownership data.
1362      * The returned result is shifted into position.
1363      */
1364     function _nextExtraData(
1365         address from,
1366         address to,
1367         uint256 prevOwnershipPacked
1368     ) private view returns (uint256) {
1369         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1370         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1371     }
1372 
1373     /**
1374      * @dev Called during each token transfer to set the 24bit `extraData` field.
1375      * Intended to be overridden by the cosumer contract.
1376      *
1377      * `previousExtraData` - the value of `extraData` before transfer.
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` will be minted for `to`.
1384      * - When `to` is zero, `tokenId` will be burned by `from`.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _extraData(
1388         address from,
1389         address to,
1390         uint24 previousExtraData
1391     ) internal view virtual returns (uint24) {}
1392 
1393     /**
1394      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1395      * This includes minting.
1396      * And also called before burning one token.
1397      *
1398      * startTokenId - the first token id to be transferred
1399      * quantity - the amount to be transferred
1400      *
1401      * Calling conditions:
1402      *
1403      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1404      * transferred to `to`.
1405      * - When `from` is zero, `tokenId` will be minted for `to`.
1406      * - When `to` is zero, `tokenId` will be burned by `from`.
1407      * - `from` and `to` are never both zero.
1408      */
1409     function _beforeTokenTransfers(
1410         address from,
1411         address to,
1412         uint256 startTokenId,
1413         uint256 quantity
1414     ) internal virtual {}
1415 
1416     /**
1417      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1418      * This includes minting.
1419      * And also called after one token has been burned.
1420      *
1421      * startTokenId - the first token id to be transferred
1422      * quantity - the amount to be transferred
1423      *
1424      * Calling conditions:
1425      *
1426      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1427      * transferred to `to`.
1428      * - When `from` is zero, `tokenId` has been minted for `to`.
1429      * - When `to` is zero, `tokenId` has been burned by `from`.
1430      * - `from` and `to` are never both zero.
1431      */
1432     function _afterTokenTransfers(
1433         address from,
1434         address to,
1435         uint256 startTokenId,
1436         uint256 quantity
1437     ) internal virtual {}
1438 
1439     /**
1440      * @dev Returns the message sender (defaults to `msg.sender`).
1441      *
1442      * If you are writing GSN compatible contracts, you need to override this function.
1443      */
1444     function _msgSenderERC721A() internal view virtual returns (address) {
1445         return msg.sender;
1446     }
1447 
1448     /**
1449      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1450      */
1451     function _toString(uint256 value) internal pure returns (string memory ptr) {
1452         assembly {
1453             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1454             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1455             // We will need 1 32-byte word to store the length,
1456             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1457             ptr := add(mload(0x40), 128)
1458             // Update the free memory pointer to allocate.
1459             mstore(0x40, ptr)
1460 
1461             // Cache the end of the memory to calculate the length later.
1462             let end := ptr
1463 
1464             // We write the string from the rightmost digit to the leftmost digit.
1465             // The following is essentially a do-while loop that also handles the zero case.
1466             // Costs a bit more than early returning for the zero case,
1467             // but cheaper in terms of deployment and overall runtime costs.
1468             for {
1469                 // Initialize and perform the first pass without check.
1470                 let temp := value
1471                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1472                 ptr := sub(ptr, 1)
1473                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1474                 mstore8(ptr, add(48, mod(temp, 10)))
1475                 temp := div(temp, 10)
1476             } temp {
1477                 // Keep dividing `temp` until zero.
1478                 temp := div(temp, 10)
1479             } {
1480                 // Body of the for loop.
1481                 ptr := sub(ptr, 1)
1482                 mstore8(ptr, add(48, mod(temp, 10)))
1483             }
1484 
1485             let length := sub(end, ptr)
1486             // Move the pointer 32 bytes leftwards to make room for the length.
1487             ptr := sub(ptr, 32)
1488             // Store the length.
1489             mstore(ptr, length)
1490         }
1491     }
1492 }
1493 
1494 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1495 
1496 
1497 // ERC721A Contracts v4.1.0
1498 // Creator: Chiru Labs
1499 
1500 pragma solidity ^0.8.4;
1501 
1502 
1503 /**
1504  * @dev Interface of an ERC721AQueryable compliant contract.
1505  */
1506 interface IERC721AQueryable is IERC721A {
1507     /**
1508      * Invalid query range (`start` >= `stop`).
1509      */
1510     error InvalidQueryRange();
1511 
1512     /**
1513      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1514      *
1515      * If the `tokenId` is out of bounds:
1516      *   - `addr` = `address(0)`
1517      *   - `startTimestamp` = `0`
1518      *   - `burned` = `false`
1519      *
1520      * If the `tokenId` is burned:
1521      *   - `addr` = `<Address of owner before token was burned>`
1522      *   - `startTimestamp` = `<Timestamp when token was burned>`
1523      *   - `burned = `true`
1524      *
1525      * Otherwise:
1526      *   - `addr` = `<Address of owner>`
1527      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1528      *   - `burned = `false`
1529      */
1530     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1531 
1532     /**
1533      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1534      * See {ERC721AQueryable-explicitOwnershipOf}
1535      */
1536     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1537 
1538     /**
1539      * @dev Returns an array of token IDs owned by `owner`,
1540      * in the range [`start`, `stop`)
1541      * (i.e. `start <= tokenId < stop`).
1542      *
1543      * This function allows for tokens to be queried if the collection
1544      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1545      *
1546      * Requirements:
1547      *
1548      * - `start` < `stop`
1549      */
1550     function tokensOfOwnerIn(
1551         address owner,
1552         uint256 start,
1553         uint256 stop
1554     ) external view returns (uint256[] memory);
1555 
1556     /**
1557      * @dev Returns an array of token IDs owned by `owner`.
1558      *
1559      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1560      * It is meant to be called off-chain.
1561      *
1562      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1563      * multiple smaller scans if the collection is large enough to cause
1564      * an out-of-gas error (10K pfp collections should be fine).
1565      */
1566     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1567 }
1568 
1569 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1570 
1571 
1572 // ERC721A Contracts v4.1.0
1573 // Creator: Chiru Labs
1574 
1575 pragma solidity ^0.8.4;
1576 
1577 
1578 
1579 /**
1580  * @title ERC721A Queryable
1581  * @dev ERC721A subclass with convenience query functions.
1582  */
1583 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1584     /**
1585      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1586      *
1587      * If the `tokenId` is out of bounds:
1588      *   - `addr` = `address(0)`
1589      *   - `startTimestamp` = `0`
1590      *   - `burned` = `false`
1591      *   - `extraData` = `0`
1592      *
1593      * If the `tokenId` is burned:
1594      *   - `addr` = `<Address of owner before token was burned>`
1595      *   - `startTimestamp` = `<Timestamp when token was burned>`
1596      *   - `burned = `true`
1597      *   - `extraData` = `<Extra data when token was burned>`
1598      *
1599      * Otherwise:
1600      *   - `addr` = `<Address of owner>`
1601      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1602      *   - `burned = `false`
1603      *   - `extraData` = `<Extra data at start of ownership>`
1604      */
1605     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1606         TokenOwnership memory ownership;
1607         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1608             return ownership;
1609         }
1610         ownership = _ownershipAt(tokenId);
1611         if (ownership.burned) {
1612             return ownership;
1613         }
1614         return _ownershipOf(tokenId);
1615     }
1616 
1617     /**
1618      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1619      * See {ERC721AQueryable-explicitOwnershipOf}
1620      */
1621     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1622         unchecked {
1623             uint256 tokenIdsLength = tokenIds.length;
1624             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1625             for (uint256 i; i != tokenIdsLength; ++i) {
1626                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1627             }
1628             return ownerships;
1629         }
1630     }
1631 
1632     /**
1633      * @dev Returns an array of token IDs owned by `owner`,
1634      * in the range [`start`, `stop`)
1635      * (i.e. `start <= tokenId < stop`).
1636      *
1637      * This function allows for tokens to be queried if the collection
1638      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1639      *
1640      * Requirements:
1641      *
1642      * - `start` < `stop`
1643      */
1644     function tokensOfOwnerIn(
1645         address owner,
1646         uint256 start,
1647         uint256 stop
1648     ) external view override returns (uint256[] memory) {
1649         unchecked {
1650             if (start >= stop) revert InvalidQueryRange();
1651             uint256 tokenIdsIdx;
1652             uint256 stopLimit = _nextTokenId();
1653             // Set `start = max(start, _startTokenId())`.
1654             if (start < _startTokenId()) {
1655                 start = _startTokenId();
1656             }
1657             // Set `stop = min(stop, stopLimit)`.
1658             if (stop > stopLimit) {
1659                 stop = stopLimit;
1660             }
1661             uint256 tokenIdsMaxLength = balanceOf(owner);
1662             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1663             // to cater for cases where `balanceOf(owner)` is too big.
1664             if (start < stop) {
1665                 uint256 rangeLength = stop - start;
1666                 if (rangeLength < tokenIdsMaxLength) {
1667                     tokenIdsMaxLength = rangeLength;
1668                 }
1669             } else {
1670                 tokenIdsMaxLength = 0;
1671             }
1672             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1673             if (tokenIdsMaxLength == 0) {
1674                 return tokenIds;
1675             }
1676             // We need to call `explicitOwnershipOf(start)`,
1677             // because the slot at `start` may not be initialized.
1678             TokenOwnership memory ownership = explicitOwnershipOf(start);
1679             address currOwnershipAddr;
1680             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1681             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1682             if (!ownership.burned) {
1683                 currOwnershipAddr = ownership.addr;
1684             }
1685             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1686                 ownership = _ownershipAt(i);
1687                 if (ownership.burned) {
1688                     continue;
1689                 }
1690                 if (ownership.addr != address(0)) {
1691                     currOwnershipAddr = ownership.addr;
1692                 }
1693                 if (currOwnershipAddr == owner) {
1694                     tokenIds[tokenIdsIdx++] = i;
1695                 }
1696             }
1697             // Downsize the array to fit.
1698             assembly {
1699                 mstore(tokenIds, tokenIdsIdx)
1700             }
1701             return tokenIds;
1702         }
1703     }
1704 
1705     /**
1706      * @dev Returns an array of token IDs owned by `owner`.
1707      *
1708      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1709      * It is meant to be called off-chain.
1710      *
1711      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1712      * multiple smaller scans if the collection is large enough to cause
1713      * an out-of-gas error (10K pfp collections should be fine).
1714      */
1715     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1716         unchecked {
1717             uint256 tokenIdsIdx;
1718             address currOwnershipAddr;
1719             uint256 tokenIdsLength = balanceOf(owner);
1720             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1721             TokenOwnership memory ownership;
1722             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1723                 ownership = _ownershipAt(i);
1724                 if (ownership.burned) {
1725                     continue;
1726                 }
1727                 if (ownership.addr != address(0)) {
1728                     currOwnershipAddr = ownership.addr;
1729                 }
1730                 if (currOwnershipAddr == owner) {
1731                     tokenIds[tokenIdsIdx++] = i;
1732                 }
1733             }
1734             return tokenIds;
1735         }
1736     }
1737 }
1738 
1739 
1740 
1741 pragma solidity ^0.8.0;
1742 
1743 
1744 
1745 
1746 
1747 /**
1748  * @dev These functions deal with verification of Merkle Tree proofs.
1749  *
1750  * The proofs can be generated using the JavaScript library
1751  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1752  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1753  *
1754  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1755  *
1756  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1757  * hashing, or use a hash function other than keccak256 for hashing leaves.
1758  * This is because the concatenation of a sorted pair of internal nodes in
1759  * the merkle tree could be reinterpreted as a leaf value.
1760  */
1761 library MerkleProof {
1762     /**
1763      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1764      * defined by `root`. For this, a `proof` must be provided, containing
1765      * sibling hashes on the branch from the leaf to the root of the tree. Each
1766      * pair of leaves and each pair of pre-images are assumed to be sorted.
1767      */
1768     function verify(
1769         bytes32[] memory proof,
1770         bytes32 root,
1771         bytes32 leaf
1772     ) internal pure returns (bool) {
1773         return processProof(proof, leaf) == root;
1774     }
1775 
1776     /**
1777      * @dev Calldata version of {verify}
1778      *
1779      * _Available since v4.7._
1780      */
1781     function verifyCalldata(
1782         bytes32[] calldata proof,
1783         bytes32 root,
1784         bytes32 leaf
1785     ) internal pure returns (bool) {
1786         return processProofCalldata(proof, leaf) == root;
1787     }
1788 
1789     /**
1790      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1791      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1792      * hash matches the root of the tree. When processing the proof, the pairs
1793      * of leafs & pre-images are assumed to be sorted.
1794      *
1795      * _Available since v4.4._
1796      */
1797     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1798         bytes32 computedHash = leaf;
1799         for (uint256 i = 0; i < proof.length; i++) {
1800             computedHash = _hashPair(computedHash, proof[i]);
1801         }
1802         return computedHash;
1803     }
1804 
1805     /**
1806      * @dev Calldata version of {processProof}
1807      *
1808      * _Available since v4.7._
1809      */
1810     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1811         bytes32 computedHash = leaf;
1812         for (uint256 i = 0; i < proof.length; i++) {
1813             computedHash = _hashPair(computedHash, proof[i]);
1814         }
1815         return computedHash;
1816     }
1817 
1818     /**
1819      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1820      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1821      *
1822      * _Available since v4.7._
1823      */
1824     function multiProofVerify(
1825         bytes32[] memory proof,
1826         bool[] memory proofFlags,
1827         bytes32 root,
1828         bytes32[] memory leaves
1829     ) internal pure returns (bool) {
1830         return processMultiProof(proof, proofFlags, leaves) == root;
1831     }
1832 
1833     /**
1834      * @dev Calldata version of {multiProofVerify}
1835      *
1836      * _Available since v4.7._
1837      */
1838     function multiProofVerifyCalldata(
1839         bytes32[] calldata proof,
1840         bool[] calldata proofFlags,
1841         bytes32 root,
1842         bytes32[] memory leaves
1843     ) internal pure returns (bool) {
1844         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1845     }
1846 
1847     /**
1848      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1849      * consuming from one or the other at each step according to the instructions given by
1850      * `proofFlags`.
1851      *
1852      * _Available since v4.7._
1853      */
1854     function processMultiProof(
1855         bytes32[] memory proof,
1856         bool[] memory proofFlags,
1857         bytes32[] memory leaves
1858     ) internal pure returns (bytes32 merkleRoot) {
1859         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1860         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1861         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1862         // the merkle tree.
1863         uint256 leavesLen = leaves.length;
1864         uint256 totalHashes = proofFlags.length;
1865 
1866         // Check proof validity.
1867         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1868 
1869         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1870         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1871         bytes32[] memory hashes = new bytes32[](totalHashes);
1872         uint256 leafPos = 0;
1873         uint256 hashPos = 0;
1874         uint256 proofPos = 0;
1875         // At each step, we compute the next hash using two values:
1876         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1877         //   get the next hash.
1878         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1879         //   `proof` array.
1880         for (uint256 i = 0; i < totalHashes; i++) {
1881             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1882             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1883             hashes[i] = _hashPair(a, b);
1884         }
1885 
1886         if (totalHashes > 0) {
1887             return hashes[totalHashes - 1];
1888         } else if (leavesLen > 0) {
1889             return leaves[0];
1890         } else {
1891             return proof[0];
1892         }
1893     }
1894 
1895     /**
1896      * @dev Calldata version of {processMultiProof}
1897      *
1898      * _Available since v4.7._
1899      */
1900     function processMultiProofCalldata(
1901         bytes32[] calldata proof,
1902         bool[] calldata proofFlags,
1903         bytes32[] memory leaves
1904     ) internal pure returns (bytes32 merkleRoot) {
1905         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1906         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1907         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1908         // the merkle tree.
1909         uint256 leavesLen = leaves.length;
1910         uint256 totalHashes = proofFlags.length;
1911 
1912         // Check proof validity.
1913         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1914 
1915         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1916         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1917         bytes32[] memory hashes = new bytes32[](totalHashes);
1918         uint256 leafPos = 0;
1919         uint256 hashPos = 0;
1920         uint256 proofPos = 0;
1921         // At each step, we compute the next hash using two values:
1922         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1923         //   get the next hash.
1924         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1925         //   `proof` array.
1926         for (uint256 i = 0; i < totalHashes; i++) {
1927             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1928             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1929             hashes[i] = _hashPair(a, b);
1930         }
1931 
1932         if (totalHashes > 0) {
1933             return hashes[totalHashes - 1];
1934         } else if (leavesLen > 0) {
1935             return leaves[0];
1936         } else {
1937             return proof[0];
1938         }
1939     }
1940 
1941     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1942         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1943     }
1944 
1945     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1946         /// @solidity memory-safe-assembly
1947         assembly {
1948             mstore(0x00, a)
1949             mstore(0x20, b)
1950             value := keccak256(0x00, 0x40)
1951         }
1952     }
1953 }
1954  pragma solidity ^0.8.0;
1955 
1956  contract GenesisKatsumiNFT is ERC721A, Ownable, ReentrancyGuard {
1957 
1958 
1959 
1960   using Strings for uint;
1961  string public hiddenMetadataUri;
1962 
1963  bytes32 public merkleRoot; 
1964   mapping(address => bool) public whitelistClaimed;
1965 
1966   string  public  baseTokenURI = "ipfs://secret";
1967   uint256  public  maxSupply = 1111;
1968   uint256 public  MAX_MINTS_PER_TX = 30;
1969   uint256 public  PUBLIC_SALE_PRICE = 0.002 ether;
1970   uint256 public  NUM_FREE_MINTS = 666;
1971   uint256 public  MAX_FREE_PER_WALLET = 1;
1972   uint256 public freeNFTAlreadyMinted = 0;
1973   bool public isPublicSaleActive = false;
1974    bool public whitelistMintEnabled = false;
1975 
1976    constructor(
1977     string memory _tokenName,
1978     string memory _tokenSymbol,
1979     string memory _hiddenMetadataUri
1980   ) ERC721A(_tokenName, _tokenSymbol) {
1981     setHiddenMetadataUri(_hiddenMetadataUri);
1982   }
1983 
1984 
1985   function mint(uint256 numberOfTokens)
1986       external
1987       payable
1988   {
1989     require(isPublicSaleActive, "Public sale is not open");
1990     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1991 
1992     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1993         require(
1994             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1995             "Incorrect ETH value sent"
1996         );
1997     } else {
1998         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1999         require(
2000             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2001             "Incorrect ETH value sent"
2002         );
2003         require(
2004             numberOfTokens <= MAX_MINTS_PER_TX,
2005             "Max mints per transaction exceeded"
2006         );
2007         } else {
2008             require(
2009                 numberOfTokens <= MAX_FREE_PER_WALLET,
2010                 "Max mints per transaction exceeded"
2011             );
2012             freeNFTAlreadyMinted += numberOfTokens;
2013         }
2014     }
2015     _safeMint(msg.sender, numberOfTokens); 
2016   }
2017 
2018   function setBaseURI(string memory baseURI)
2019     public
2020     onlyOwner
2021   {
2022     baseTokenURI = baseURI;
2023   }
2024 
2025   function treasuryMint(uint quantity)
2026     public
2027     onlyOwner
2028   {
2029     require(
2030       quantity > 0,
2031       "Invalid mint amount"
2032     );
2033     require(
2034       totalSupply() + quantity <= maxSupply,
2035       "Maximum supply exceeded"
2036     );
2037     _safeMint(msg.sender, quantity);
2038   }
2039 
2040 function withdraw() public onlyOwner nonReentrant {
2041     // This will transfer the remaining contract balance to the owner.
2042     // Do not remove this otherwise you will not be able to withdraw the funds.
2043     // =============================================================================
2044     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2045     require(os);
2046     // =============================================================================
2047   }
2048 
2049   function tokenURI(uint _tokenId)
2050     public
2051     view
2052     virtual
2053     override
2054     returns (string memory)
2055   {
2056     require(
2057       _exists(_tokenId),
2058       "ERC721Metadata: URI query for nonexistent token"
2059     );
2060     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
2061   }
2062 
2063   function _baseURI()
2064     internal
2065     view
2066     virtual
2067     override
2068     returns (string memory)
2069   {
2070     return baseTokenURI;
2071   }
2072 
2073   function setIsPublicSaleActive(bool _isPublicSaleActive)
2074       external
2075       onlyOwner
2076   {
2077       isPublicSaleActive = _isPublicSaleActive;
2078   }
2079   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2080     hiddenMetadataUri = _hiddenMetadataUri;
2081   }
2082 
2083   function setNumFreeMints(uint256 _numfreemints)
2084       external
2085       onlyOwner
2086   {
2087       NUM_FREE_MINTS = _numfreemints;
2088   }
2089 
2090   function setSalePrice(uint256 _price)
2091       external
2092       onlyOwner
2093   {
2094       PUBLIC_SALE_PRICE = _price;
2095   }
2096   function setGenesis(uint256 _genesis)
2097       external
2098       onlyOwner
2099   {
2100       maxSupply = _genesis;
2101   }
2102 
2103   function setMaxLimitPerTransaction(uint256 _limit)
2104       external
2105       onlyOwner
2106   {
2107       MAX_MINTS_PER_TX = _limit;
2108   }
2109   function setwhitelistMintEnabled(bool _wlMintEnabled)
2110       external
2111       onlyOwner
2112   {
2113       whitelistMintEnabled = _wlMintEnabled;
2114   }
2115   function whitelistMint(uint256 _price, bytes32[] calldata _merkleProof) public payable  {
2116     // Verify whitelist requirements
2117     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
2118     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
2119     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2120     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
2121 
2122     whitelistClaimed[_msgSender()] = true;
2123     _safeMint(_msgSender(), _price);
2124   }
2125 
2126   function setFreeLimitPerWallet(uint256 _limit)
2127       external
2128       onlyOwner
2129   {
2130       MAX_FREE_PER_WALLET = _limit;
2131   }
2132 }