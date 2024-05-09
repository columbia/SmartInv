1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4    _____ _____________________________    _____ _____.___._________  
5   /  _  \\______   \_   ___ \______   \  /  _  \\__  |   |\_   ___ \ 
6  /  /_\  \|    |  _/    \  \/|    |  _/ /  /_\  \/   |   |/    \  \/ 
7 /    |    \    |   \     \___|    |   \/    |    \____   |\     \____
8 \____|__  /______  /\______  /______  /\____|__  / ______| \______  /
9         \/       \/        \/       \/         \/\/               \/                                                                                                                   
10 */
11 
12 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Contract module that helps prevent reentrant calls to a function.
18  *
19  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
20  * available, which can be applied to functions to make sure there are no nested
21  * (reentrant) calls to them.
22  *
23  * Note that because there is a single `nonReentrant` guard, functions marked as
24  * `nonReentrant` may not call one another. This can be worked around by making
25  * those functions `private`, and then adding `external` `nonReentrant` entry
26  * points to them.
27  *
28  * TIP: If you would like to learn more about reentrancy and alternative ways
29  * to protect against it, check out our blog post
30  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
31  */
32 abstract contract ReentrancyGuard {
33     // Booleans are more expensive than uint256 or any type that takes up a full
34     // word because each write operation emits an extra SLOAD to first read the
35     // slot's contents, replace the bits taken up by the boolean, and then write
36     // back. This is the compiler's defense against contract upgrades and
37     // pointer aliasing, and it cannot be disabled.
38 
39     // The values being non-zero value makes deployment a bit more expensive,
40     // but in exchange the refund on every call to nonReentrant will be lower in
41     // amount. Since refunds are capped to a percentage of the total
42     // transaction's gas, it is best to keep them low in cases like this one, to
43     // increase the likelihood of the full refund coming into effect.
44     uint256 private constant _NOT_ENTERED = 1;
45     uint256 private constant _ENTERED = 2;
46 
47     uint256 private _status;
48 
49     constructor() {
50         _status = _NOT_ENTERED;
51     }
52 
53     /**
54      * @dev Prevents a contract from calling itself, directly or indirectly.
55      * Calling a `nonReentrant` function from another `nonReentrant`
56      * function is not supported. It is possible to prevent this from happening
57      * by making the `nonReentrant` function external, and making it call a
58      * `private` function that does the actual work.
59      */
60     modifier nonReentrant() {
61         // On the first call to nonReentrant, _notEntered will be true
62         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
63 
64         // Any calls to nonReentrant after this point will fail
65         _status = _ENTERED;
66 
67         _;
68 
69         // By storing the original value once again, a refund is triggered (see
70         // https://eips.ethereum.org/EIPS/eip-2200)
71         _status = _NOT_ENTERED;
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Strings.sol
76 
77 
78 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev String operations.
84  */
85 library Strings {
86     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
87     uint8 private constant _ADDRESS_LENGTH = 20;
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
91      */
92     function toString(uint256 value) internal pure returns (string memory) {
93         // Inspired by OraclizeAPI's implementation - MIT licence
94         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
95 
96         if (value == 0) {
97             return "0";
98         }
99         uint256 temp = value;
100         uint256 digits;
101         while (temp != 0) {
102             digits++;
103             temp /= 10;
104         }
105         bytes memory buffer = new bytes(digits);
106         while (value != 0) {
107             digits -= 1;
108             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
109             value /= 10;
110         }
111         return string(buffer);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
116      */
117     function toHexString(uint256 value) internal pure returns (string memory) {
118         if (value == 0) {
119             return "0x00";
120         }
121         uint256 temp = value;
122         uint256 length = 0;
123         while (temp != 0) {
124             length++;
125             temp >>= 8;
126         }
127         return toHexString(value, length);
128     }
129 
130     /**
131      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
132      */
133     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
134         bytes memory buffer = new bytes(2 * length + 2);
135         buffer[0] = "0";
136         buffer[1] = "x";
137         for (uint256 i = 2 * length + 1; i > 1; --i) {
138             buffer[i] = _HEX_SYMBOLS[value & 0xf];
139             value >>= 4;
140         }
141         require(value == 0, "Strings: hex length insufficient");
142         return string(buffer);
143     }
144 
145     /**
146      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
147      */
148     function toHexString(address addr) internal pure returns (string memory) {
149         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
150     }
151 }
152 
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
184 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         _checkOwner();
218         _;
219     }
220 
221     /**
222      * @dev Returns the address of the current owner.
223      */
224     function owner() public view virtual returns (address) {
225         return _owner;
226     }
227 
228     /**
229      * @dev Throws if the sender is not the owner.
230      */
231     function _checkOwner() internal view virtual {
232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
233     }
234 
235     /**
236      * @dev Leaves the contract without owner. It will not be possible to call
237      * `onlyOwner` functions anymore. Can only be called by the current owner.
238      *
239      * NOTE: Renouncing ownership will leave the contract without an owner,
240      * thereby removing any functionality that is only available to the owner.
241      */
242     function renounceOwnership() public virtual onlyOwner {
243         _transferOwnership(address(0));
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Can only be called by the current owner.
249      */
250     function transferOwnership(address newOwner) public virtual onlyOwner {
251         require(newOwner != address(0), "Ownable: new owner is the zero address");
252         _transferOwnership(newOwner);
253     }
254 
255     /**
256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
257      * Internal function without access restriction.
258      */
259     function _transferOwnership(address newOwner) internal virtual {
260         address oldOwner = _owner;
261         _owner = newOwner;
262         emit OwnershipTransferred(oldOwner, newOwner);
263     }
264 }
265 
266 // File: erc721a/contracts/IERC721A.sol
267 
268 
269 // ERC721A Contracts v4.1.0
270 // Creator: Chiru Labs
271 
272 pragma solidity ^0.8.4;
273 
274 /**
275  * @dev Interface of an ERC721A compliant contract.
276  */
277 interface IERC721A {
278     /**
279      * The caller must own the token or be an approved operator.
280      */
281     error ApprovalCallerNotOwnerNorApproved();
282 
283     /**
284      * The token does not exist.
285      */
286     error ApprovalQueryForNonexistentToken();
287 
288     /**
289      * The caller cannot approve to their own address.
290      */
291     error ApproveToCaller();
292 
293     /**
294      * Cannot query the balance for the zero address.
295      */
296     error BalanceQueryForZeroAddress();
297 
298     /**
299      * Cannot mint to the zero address.
300      */
301     error MintToZeroAddress();
302 
303     /**
304      * The quantity of tokens minted must be more than zero.
305      */
306     error MintZeroQuantity();
307 
308     /**
309      * The token does not exist.
310      */
311     error OwnerQueryForNonexistentToken();
312 
313     /**
314      * The caller must own the token or be an approved operator.
315      */
316     error TransferCallerNotOwnerNorApproved();
317 
318     /**
319      * The token must be owned by `from`.
320      */
321     error TransferFromIncorrectOwner();
322 
323     /**
324      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
325      */
326     error TransferToNonERC721ReceiverImplementer();
327 
328     /**
329      * Cannot transfer to the zero address.
330      */
331     error TransferToZeroAddress();
332 
333     /**
334      * The token does not exist.
335      */
336     error URIQueryForNonexistentToken();
337 
338     /**
339      * The `quantity` minted with ERC2309 exceeds the safety limit.
340      */
341     error MintERC2309QuantityExceedsLimit();
342 
343     /**
344      * The `extraData` cannot be set on an unintialized ownership slot.
345      */
346     error OwnershipNotInitializedForExtraData();
347 
348     struct TokenOwnership {
349         // The address of the owner.
350         address addr;
351         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
352         uint64 startTimestamp;
353         // Whether the token has been burned.
354         bool burned;
355         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
356         uint24 extraData;
357     }
358 
359     /**
360      * @dev Returns the total amount of tokens stored by the contract.
361      *
362      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
363      */
364     function totalSupply() external view returns (uint256);
365 
366     // ==============================
367     //            IERC165
368     // ==============================
369 
370     /**
371      * @dev Returns true if this contract implements the interface defined by
372      * `interfaceId`. See the corresponding
373      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
374      * to learn more about how these ids are created.
375      *
376      * This function call must use less than 30 000 gas.
377      */
378     function supportsInterface(bytes4 interfaceId) external view returns (bool);
379 
380     // ==============================
381     //            IERC721
382     // ==============================
383 
384     /**
385      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
391      */
392     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
396      */
397     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
398 
399     /**
400      * @dev Returns the number of tokens in ``owner``'s account.
401      */
402     function balanceOf(address owner) external view returns (uint256 balance);
403 
404     /**
405      * @dev Returns the owner of the `tokenId` token.
406      *
407      * Requirements:
408      *
409      * - `tokenId` must exist.
410      */
411     function ownerOf(uint256 tokenId) external view returns (address owner);
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`.
415      *
416      * Requirements:
417      *
418      * - `from` cannot be the zero address.
419      * - `to` cannot be the zero address.
420      * - `tokenId` token must exist and be owned by `from`.
421      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
422      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
423      *
424      * Emits a {Transfer} event.
425      */
426     function safeTransferFrom(
427         address from,
428         address to,
429         uint256 tokenId,
430         bytes calldata data
431     ) external;
432 
433     /**
434      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
435      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Transfers `tokenId` token from `from` to `to`.
455      *
456      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must be owned by `from`.
463      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
464      *
465      * Emits a {Transfer} event.
466      */
467     function transferFrom(
468         address from,
469         address to,
470         uint256 tokenId
471     ) external;
472 
473     /**
474      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
475      * The approval is cleared when the token is transferred.
476      *
477      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
478      *
479      * Requirements:
480      *
481      * - The caller must own the token or be an approved operator.
482      * - `tokenId` must exist.
483      *
484      * Emits an {Approval} event.
485      */
486     function approve(address to, uint256 tokenId) external;
487 
488     /**
489      * @dev Approve or remove `operator` as an operator for the caller.
490      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
491      *
492      * Requirements:
493      *
494      * - The `operator` cannot be the caller.
495      *
496      * Emits an {ApprovalForAll} event.
497      */
498     function setApprovalForAll(address operator, bool _approved) external;
499 
500     /**
501      * @dev Returns the account approved for `tokenId` token.
502      *
503      * Requirements:
504      *
505      * - `tokenId` must exist.
506      */
507     function getApproved(uint256 tokenId) external view returns (address operator);
508 
509     /**
510      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
511      *
512      * See {setApprovalForAll}
513      */
514     function isApprovedForAll(address owner, address operator) external view returns (bool);
515 
516     // ==============================
517     //        IERC721Metadata
518     // ==============================
519 
520     /**
521      * @dev Returns the token collection name.
522      */
523     function name() external view returns (string memory);
524 
525     /**
526      * @dev Returns the token collection symbol.
527      */
528     function symbol() external view returns (string memory);
529 
530     /**
531      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
532      */
533     function tokenURI(uint256 tokenId) external view returns (string memory);
534 
535     // ==============================
536     //            IERC2309
537     // ==============================
538 
539     /**
540      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
541      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
542      */
543     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
544 }
545 
546 // File: erc721a/contracts/ERC721A.sol
547 
548 
549 // ERC721A Contracts v4.1.0
550 // Creator: Chiru Labs
551 
552 pragma solidity ^0.8.4;
553 
554 
555 /**
556  * @dev ERC721 token receiver interface.
557  */
558 interface ERC721A__IERC721Receiver {
559     function onERC721Received(
560         address operator,
561         address from,
562         uint256 tokenId,
563         bytes calldata data
564     ) external returns (bytes4);
565 }
566 
567 /**
568  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
569  * including the Metadata extension. Built to optimize for lower gas during batch mints.
570  *
571  * Assumes serials are sequentially minted starting at `_startTokenId()`
572  * (defaults to 0, e.g. 0, 1, 2, 3..).
573  *
574  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
575  *
576  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
577  */
578 contract ERC721A is IERC721A {
579     // Mask of an entry in packed address data.
580     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
581 
582     // The bit position of `numberMinted` in packed address data.
583     uint256 private constant BITPOS_NUMBER_MINTED = 64;
584 
585     // The bit position of `numberBurned` in packed address data.
586     uint256 private constant BITPOS_NUMBER_BURNED = 128;
587 
588     // The bit position of `aux` in packed address data.
589     uint256 private constant BITPOS_AUX = 192;
590 
591     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
592     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
593 
594     // The bit position of `startTimestamp` in packed ownership.
595     uint256 private constant BITPOS_START_TIMESTAMP = 160;
596 
597     // The bit mask of the `burned` bit in packed ownership.
598     uint256 private constant BITMASK_BURNED = 1 << 224;
599 
600     // The bit position of the `nextInitialized` bit in packed ownership.
601     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
602 
603     // The bit mask of the `nextInitialized` bit in packed ownership.
604     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
605 
606     // The bit position of `extraData` in packed ownership.
607     uint256 private constant BITPOS_EXTRA_DATA = 232;
608 
609     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
610     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
611 
612     // The mask of the lower 160 bits for addresses.
613     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
614 
615     // The maximum `quantity` that can be minted with `_mintERC2309`.
616     // This limit is to prevent overflows on the address data entries.
617     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
618     // is required to cause an overflow, which is unrealistic.
619     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
620 
621     // The tokenId of the next token to be minted.
622     uint256 private _currentIndex;
623 
624     // The number of tokens burned.
625     uint256 private _burnCounter;
626 
627     // Token name
628     string private _name;
629 
630     // Token symbol
631     string private _symbol;
632 
633     // Mapping from token ID to ownership details
634     // An empty struct value does not necessarily mean the token is unowned.
635     // See `_packedOwnershipOf` implementation for details.
636     //
637     // Bits Layout:
638     // - [0..159]   `addr`
639     // - [160..223] `startTimestamp`
640     // - [224]      `burned`
641     // - [225]      `nextInitialized`
642     // - [232..255] `extraData`
643     mapping(uint256 => uint256) private _packedOwnerships;
644 
645     // Mapping owner address to address data.
646     //
647     // Bits Layout:
648     // - [0..63]    `balance`
649     // - [64..127]  `numberMinted`
650     // - [128..191] `numberBurned`
651     // - [192..255] `aux`
652     mapping(address => uint256) private _packedAddressData;
653 
654     // Mapping from token ID to approved address.
655     mapping(uint256 => address) private _tokenApprovals;
656 
657     // Mapping from owner to operator approvals
658     mapping(address => mapping(address => bool)) private _operatorApprovals;
659 
660     constructor(string memory name_, string memory symbol_) {
661         _name = name_;
662         _symbol = symbol_;
663         _currentIndex = _startTokenId();
664     }
665 
666     /**
667      * @dev Returns the starting token ID.
668      * To change the starting token ID, please override this function.
669      */
670     function _startTokenId() internal view virtual returns (uint256) {
671         return 0;
672     }
673 
674     /**
675      * @dev Returns the next token ID to be minted.
676      */
677     function _nextTokenId() internal view returns (uint256) {
678         return _currentIndex;
679     }
680 
681     /**
682      * @dev Returns the total number of tokens in existence.
683      * Burned tokens will reduce the count.
684      * To get the total number of tokens minted, please see `_totalMinted`.
685      */
686     function totalSupply() public view override returns (uint256) {
687         // Counter underflow is impossible as _burnCounter cannot be incremented
688         // more than `_currentIndex - _startTokenId()` times.
689         unchecked {
690             return _currentIndex - _burnCounter - _startTokenId();
691         }
692     }
693 
694     /**
695      * @dev Returns the total amount of tokens minted in the contract.
696      */
697     function _totalMinted() internal view returns (uint256) {
698         // Counter underflow is impossible as _currentIndex does not decrement,
699         // and it is initialized to `_startTokenId()`
700         unchecked {
701             return _currentIndex - _startTokenId();
702         }
703     }
704 
705     /**
706      * @dev Returns the total number of tokens burned.
707      */
708     function _totalBurned() internal view returns (uint256) {
709         return _burnCounter;
710     }
711 
712     /**
713      * @dev See {IERC165-supportsInterface}.
714      */
715     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
716         // The interface IDs are constants representing the first 4 bytes of the XOR of
717         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
718         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
719         return
720             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
721             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
722             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
723     }
724 
725     /**
726      * @dev See {IERC721-balanceOf}.
727      */
728     function balanceOf(address owner) public view override returns (uint256) {
729         if (owner == address(0)) revert BalanceQueryForZeroAddress();
730         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
731     }
732 
733     /**
734      * Returns the number of tokens minted by `owner`.
735      */
736     function _numberMinted(address owner) internal view returns (uint256) {
737         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
738     }
739 
740     /**
741      * Returns the number of tokens burned by or on behalf of `owner`.
742      */
743     function _numberBurned(address owner) internal view returns (uint256) {
744         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
745     }
746 
747     /**
748      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
749      */
750     function _getAux(address owner) internal view returns (uint64) {
751         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
752     }
753 
754     /**
755      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
756      * If there are multiple variables, please pack them into a uint64.
757      */
758     function _setAux(address owner, uint64 aux) internal {
759         uint256 packed = _packedAddressData[owner];
760         uint256 auxCasted;
761         // Cast `aux` with assembly to avoid redundant masking.
762         assembly {
763             auxCasted := aux
764         }
765         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
766         _packedAddressData[owner] = packed;
767     }
768 
769     /**
770      * Returns the packed ownership data of `tokenId`.
771      */
772     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
773         uint256 curr = tokenId;
774 
775         unchecked {
776             if (_startTokenId() <= curr)
777                 if (curr < _currentIndex) {
778                     uint256 packed = _packedOwnerships[curr];
779                     // If not burned.
780                     if (packed & BITMASK_BURNED == 0) {
781                         // Invariant:
782                         // There will always be an ownership that has an address and is not burned
783                         // before an ownership that does not have an address and is not burned.
784                         // Hence, curr will not underflow.
785                         //
786                         // We can directly compare the packed value.
787                         // If the address is zero, packed is zero.
788                         while (packed == 0) {
789                             packed = _packedOwnerships[--curr];
790                         }
791                         return packed;
792                     }
793                 }
794         }
795         revert OwnerQueryForNonexistentToken();
796     }
797 
798     /**
799      * Returns the unpacked `TokenOwnership` struct from `packed`.
800      */
801     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
802         ownership.addr = address(uint160(packed));
803         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
804         ownership.burned = packed & BITMASK_BURNED != 0;
805         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
806     }
807 
808     /**
809      * Returns the unpacked `TokenOwnership` struct at `index`.
810      */
811     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
812         return _unpackedOwnership(_packedOwnerships[index]);
813     }
814 
815     /**
816      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
817      */
818     function _initializeOwnershipAt(uint256 index) internal {
819         if (_packedOwnerships[index] == 0) {
820             _packedOwnerships[index] = _packedOwnershipOf(index);
821         }
822     }
823 
824     /**
825      * Gas spent here starts off proportional to the maximum mint batch size.
826      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
827      */
828     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
829         return _unpackedOwnership(_packedOwnershipOf(tokenId));
830     }
831 
832     /**
833      * @dev Packs ownership data into a single uint256.
834      */
835     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
836         assembly {
837             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
838             owner := and(owner, BITMASK_ADDRESS)
839             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
840             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
841         }
842     }
843 
844     /**
845      * @dev See {IERC721-ownerOf}.
846      */
847     function ownerOf(uint256 tokenId) public view override returns (address) {
848         return address(uint160(_packedOwnershipOf(tokenId)));
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-name}.
853      */
854     function name() public view virtual override returns (string memory) {
855         return _name;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-symbol}.
860      */
861     function symbol() public view virtual override returns (string memory) {
862         return _symbol;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-tokenURI}.
867      */
868     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
869         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
870 
871         string memory baseURI = _baseURI();
872         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
873     }
874 
875     /**
876      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
877      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
878      * by default, it can be overridden in child contracts.
879      */
880     function _baseURI() internal view virtual returns (string memory) {
881         return '';
882     }
883 
884     /**
885      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
886      */
887     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
888         // For branchless setting of the `nextInitialized` flag.
889         assembly {
890             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
891             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
892         }
893     }
894 
895     /**
896      * @dev See {IERC721-approve}.
897      */
898     function approve(address to, uint256 tokenId) public override {
899         address owner = ownerOf(tokenId);
900 
901         if (_msgSenderERC721A() != owner)
902             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
903                 revert ApprovalCallerNotOwnerNorApproved();
904             }
905 
906         _tokenApprovals[tokenId] = to;
907         emit Approval(owner, to, tokenId);
908     }
909 
910     /**
911      * @dev See {IERC721-getApproved}.
912      */
913     function getApproved(uint256 tokenId) public view override returns (address) {
914         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
915 
916         return _tokenApprovals[tokenId];
917     }
918 
919     /**
920      * @dev See {IERC721-setApprovalForAll}.
921      */
922     function setApprovalForAll(address operator, bool approved) public virtual override {
923         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
924 
925         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
926         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
927     }
928 
929     /**
930      * @dev See {IERC721-isApprovedForAll}.
931      */
932     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
933         return _operatorApprovals[owner][operator];
934     }
935 
936     /**
937      * @dev See {IERC721-safeTransferFrom}.
938      */
939     function safeTransferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public virtual override {
944         safeTransferFrom(from, to, tokenId, '');
945     }
946 
947     /**
948      * @dev See {IERC721-safeTransferFrom}.
949      */
950     function safeTransferFrom(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) public virtual override {
956         transferFrom(from, to, tokenId);
957         if (to.code.length != 0)
958             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
959                 revert TransferToNonERC721ReceiverImplementer();
960             }
961     }
962 
963     /**
964      * @dev Returns whether `tokenId` exists.
965      *
966      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
967      *
968      * Tokens start existing when they are minted (`_mint`),
969      */
970     function _exists(uint256 tokenId) internal view returns (bool) {
971         return
972             _startTokenId() <= tokenId &&
973             tokenId < _currentIndex && // If within bounds,
974             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
975     }
976 
977     /**
978      * @dev Equivalent to `_safeMint(to, quantity, '')`.
979      */
980     function _safeMint(address to, uint256 quantity) internal {
981         _safeMint(to, quantity, '');
982     }
983 
984     /**
985      * @dev Safely mints `quantity` tokens and transfers them to `to`.
986      *
987      * Requirements:
988      *
989      * - If `to` refers to a smart contract, it must implement
990      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
991      * - `quantity` must be greater than 0.
992      *
993      * See {_mint}.
994      *
995      * Emits a {Transfer} event for each mint.
996      */
997     function _safeMint(
998         address to,
999         uint256 quantity,
1000         bytes memory _data
1001     ) internal {
1002         _mint(to, quantity);
1003 
1004         unchecked {
1005             if (to.code.length != 0) {
1006                 uint256 end = _currentIndex;
1007                 uint256 index = end - quantity;
1008                 do {
1009                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1010                         revert TransferToNonERC721ReceiverImplementer();
1011                     }
1012                 } while (index < end);
1013                 // Reentrancy protection.
1014                 if (_currentIndex != end) revert();
1015             }
1016         }
1017     }
1018 
1019     /**
1020      * @dev Mints `quantity` tokens and transfers them to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `quantity` must be greater than 0.
1026      *
1027      * Emits a {Transfer} event for each mint.
1028      */
1029     function _mint(address to, uint256 quantity) internal {
1030         uint256 startTokenId = _currentIndex;
1031         if (to == address(0)) revert MintToZeroAddress();
1032         if (quantity == 0) revert MintZeroQuantity();
1033 
1034         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1035 
1036         // Overflows are incredibly unrealistic.
1037         // `balance` and `numberMinted` have a maximum limit of 2**64.
1038         // `tokenId` has a maximum limit of 2**256.
1039         unchecked {
1040             // Updates:
1041             // - `balance += quantity`.
1042             // - `numberMinted += quantity`.
1043             //
1044             // We can directly add to the `balance` and `numberMinted`.
1045             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1046 
1047             // Updates:
1048             // - `address` to the owner.
1049             // - `startTimestamp` to the timestamp of minting.
1050             // - `burned` to `false`.
1051             // - `nextInitialized` to `quantity == 1`.
1052             _packedOwnerships[startTokenId] = _packOwnershipData(
1053                 to,
1054                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1055             );
1056 
1057             uint256 tokenId = startTokenId;
1058             uint256 end = startTokenId + quantity;
1059             do {
1060                 emit Transfer(address(0), to, tokenId++);
1061             } while (tokenId < end);
1062 
1063             _currentIndex = end;
1064         }
1065         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1066     }
1067 
1068     /**
1069      * @dev Mints `quantity` tokens and transfers them to `to`.
1070      *
1071      * This function is intended for efficient minting only during contract creation.
1072      *
1073      * It emits only one {ConsecutiveTransfer} as defined in
1074      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1075      * instead of a sequence of {Transfer} event(s).
1076      *
1077      * Calling this function outside of contract creation WILL make your contract
1078      * non-compliant with the ERC721 standard.
1079      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1080      * {ConsecutiveTransfer} event is only permissible during contract creation.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - `quantity` must be greater than 0.
1086      *
1087      * Emits a {ConsecutiveTransfer} event.
1088      */
1089     function _mintERC2309(address to, uint256 quantity) internal {
1090         uint256 startTokenId = _currentIndex;
1091         if (to == address(0)) revert MintToZeroAddress();
1092         if (quantity == 0) revert MintZeroQuantity();
1093         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1094 
1095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1096 
1097         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1098         unchecked {
1099             // Updates:
1100             // - `balance += quantity`.
1101             // - `numberMinted += quantity`.
1102             //
1103             // We can directly add to the `balance` and `numberMinted`.
1104             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1105 
1106             // Updates:
1107             // - `address` to the owner.
1108             // - `startTimestamp` to the timestamp of minting.
1109             // - `burned` to `false`.
1110             // - `nextInitialized` to `quantity == 1`.
1111             _packedOwnerships[startTokenId] = _packOwnershipData(
1112                 to,
1113                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1114             );
1115 
1116             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1117 
1118             _currentIndex = startTokenId + quantity;
1119         }
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1125      */
1126     function _getApprovedAddress(uint256 tokenId)
1127         private
1128         view
1129         returns (uint256 approvedAddressSlot, address approvedAddress)
1130     {
1131         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1132         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1133         assembly {
1134             // Compute the slot.
1135             mstore(0x00, tokenId)
1136             mstore(0x20, tokenApprovalsPtr.slot)
1137             approvedAddressSlot := keccak256(0x00, 0x40)
1138             // Load the slot's value from storage.
1139             approvedAddress := sload(approvedAddressSlot)
1140         }
1141     }
1142 
1143     /**
1144      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1145      */
1146     function _isOwnerOrApproved(
1147         address approvedAddress,
1148         address from,
1149         address msgSender
1150     ) private pure returns (bool result) {
1151         assembly {
1152             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1153             from := and(from, BITMASK_ADDRESS)
1154             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1155             msgSender := and(msgSender, BITMASK_ADDRESS)
1156             // `msgSender == from || msgSender == approvedAddress`.
1157             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1158         }
1159     }
1160 
1161     /**
1162      * @dev Transfers `tokenId` from `from` to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function transferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) public virtual override {
1176         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1177 
1178         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1179 
1180         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1181 
1182         // The nested ifs save around 20+ gas over a compound boolean condition.
1183         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1184             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1185 
1186         if (to == address(0)) revert TransferToZeroAddress();
1187 
1188         _beforeTokenTransfers(from, to, tokenId, 1);
1189 
1190         // Clear approvals from the previous owner.
1191         assembly {
1192             if approvedAddress {
1193                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1194                 sstore(approvedAddressSlot, 0)
1195             }
1196         }
1197 
1198         // Underflow of the sender's balance is impossible because we check for
1199         // ownership above and the recipient's balance can't realistically overflow.
1200         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1201         unchecked {
1202             // We can directly increment and decrement the balances.
1203             --_packedAddressData[from]; // Updates: `balance -= 1`.
1204             ++_packedAddressData[to]; // Updates: `balance += 1`.
1205 
1206             // Updates:
1207             // - `address` to the next owner.
1208             // - `startTimestamp` to the timestamp of transfering.
1209             // - `burned` to `false`.
1210             // - `nextInitialized` to `true`.
1211             _packedOwnerships[tokenId] = _packOwnershipData(
1212                 to,
1213                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1214             );
1215 
1216             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1217             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1218                 uint256 nextTokenId = tokenId + 1;
1219                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1220                 if (_packedOwnerships[nextTokenId] == 0) {
1221                     // If the next slot is within bounds.
1222                     if (nextTokenId != _currentIndex) {
1223                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1224                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1225                     }
1226                 }
1227             }
1228         }
1229 
1230         emit Transfer(from, to, tokenId);
1231         _afterTokenTransfers(from, to, tokenId, 1);
1232     }
1233 
1234     /**
1235      * @dev Equivalent to `_burn(tokenId, false)`.
1236      */
1237     function _burn(uint256 tokenId) internal virtual {
1238         _burn(tokenId, false);
1239     }
1240 
1241     /**
1242      * @dev Destroys `tokenId`.
1243      * The approval is cleared when the token is burned.
1244      *
1245      * Requirements:
1246      *
1247      * - `tokenId` must exist.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1252         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1253 
1254         address from = address(uint160(prevOwnershipPacked));
1255 
1256         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1257 
1258         if (approvalCheck) {
1259             // The nested ifs save around 20+ gas over a compound boolean condition.
1260             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1261                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1262         }
1263 
1264         _beforeTokenTransfers(from, address(0), tokenId, 1);
1265 
1266         // Clear approvals from the previous owner.
1267         assembly {
1268             if approvedAddress {
1269                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1270                 sstore(approvedAddressSlot, 0)
1271             }
1272         }
1273 
1274         // Underflow of the sender's balance is impossible because we check for
1275         // ownership above and the recipient's balance can't realistically overflow.
1276         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1277         unchecked {
1278             // Updates:
1279             // - `balance -= 1`.
1280             // - `numberBurned += 1`.
1281             //
1282             // We can directly decrement the balance, and increment the number burned.
1283             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1284             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1285 
1286             // Updates:
1287             // - `address` to the last owner.
1288             // - `startTimestamp` to the timestamp of burning.
1289             // - `burned` to `true`.
1290             // - `nextInitialized` to `true`.
1291             _packedOwnerships[tokenId] = _packOwnershipData(
1292                 from,
1293                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1294             );
1295 
1296             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1297             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1298                 uint256 nextTokenId = tokenId + 1;
1299                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1300                 if (_packedOwnerships[nextTokenId] == 0) {
1301                     // If the next slot is within bounds.
1302                     if (nextTokenId != _currentIndex) {
1303                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1304                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1305                     }
1306                 }
1307             }
1308         }
1309 
1310         emit Transfer(from, address(0), tokenId);
1311         _afterTokenTransfers(from, address(0), tokenId, 1);
1312 
1313         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1314         unchecked {
1315             _burnCounter++;
1316         }
1317     }
1318 
1319     /**
1320      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1321      *
1322      * @param from address representing the previous owner of the given token ID
1323      * @param to target address that will receive the tokens
1324      * @param tokenId uint256 ID of the token to be transferred
1325      * @param _data bytes optional data to send along with the call
1326      * @return bool whether the call correctly returned the expected magic value
1327      */
1328     function _checkContractOnERC721Received(
1329         address from,
1330         address to,
1331         uint256 tokenId,
1332         bytes memory _data
1333     ) private returns (bool) {
1334         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1335             bytes4 retval
1336         ) {
1337             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1338         } catch (bytes memory reason) {
1339             if (reason.length == 0) {
1340                 revert TransferToNonERC721ReceiverImplementer();
1341             } else {
1342                 assembly {
1343                     revert(add(32, reason), mload(reason))
1344                 }
1345             }
1346         }
1347     }
1348 
1349     /**
1350      * @dev Directly sets the extra data for the ownership data `index`.
1351      */
1352     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1353         uint256 packed = _packedOwnerships[index];
1354         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1355         uint256 extraDataCasted;
1356         // Cast `extraData` with assembly to avoid redundant masking.
1357         assembly {
1358             extraDataCasted := extraData
1359         }
1360         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1361         _packedOwnerships[index] = packed;
1362     }
1363 
1364     /**
1365      * @dev Returns the next extra data for the packed ownership data.
1366      * The returned result is shifted into position.
1367      */
1368     function _nextExtraData(
1369         address from,
1370         address to,
1371         uint256 prevOwnershipPacked
1372     ) private view returns (uint256) {
1373         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1374         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1375     }
1376 
1377     /**
1378      * @dev Called during each token transfer to set the 24bit `extraData` field.
1379      * Intended to be overridden by the cosumer contract.
1380      *
1381      * `previousExtraData` - the value of `extraData` before transfer.
1382      *
1383      * Calling conditions:
1384      *
1385      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1386      * transferred to `to`.
1387      * - When `from` is zero, `tokenId` will be minted for `to`.
1388      * - When `to` is zero, `tokenId` will be burned by `from`.
1389      * - `from` and `to` are never both zero.
1390      */
1391     function _extraData(
1392         address from,
1393         address to,
1394         uint24 previousExtraData
1395     ) internal view virtual returns (uint24) {}
1396 
1397     /**
1398      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1399      * This includes minting.
1400      * And also called before burning one token.
1401      *
1402      * startTokenId - the first token id to be transferred
1403      * quantity - the amount to be transferred
1404      *
1405      * Calling conditions:
1406      *
1407      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1408      * transferred to `to`.
1409      * - When `from` is zero, `tokenId` will be minted for `to`.
1410      * - When `to` is zero, `tokenId` will be burned by `from`.
1411      * - `from` and `to` are never both zero.
1412      */
1413     function _beforeTokenTransfers(
1414         address from,
1415         address to,
1416         uint256 startTokenId,
1417         uint256 quantity
1418     ) internal virtual {}
1419 
1420     /**
1421      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1422      * This includes minting.
1423      * And also called after one token has been burned.
1424      *
1425      * startTokenId - the first token id to be transferred
1426      * quantity - the amount to be transferred
1427      *
1428      * Calling conditions:
1429      *
1430      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1431      * transferred to `to`.
1432      * - When `from` is zero, `tokenId` has been minted for `to`.
1433      * - When `to` is zero, `tokenId` has been burned by `from`.
1434      * - `from` and `to` are never both zero.
1435      */
1436     function _afterTokenTransfers(
1437         address from,
1438         address to,
1439         uint256 startTokenId,
1440         uint256 quantity
1441     ) internal virtual {}
1442 
1443     /**
1444      * @dev Returns the message sender (defaults to `msg.sender`).
1445      *
1446      * If you are writing GSN compatible contracts, you need to override this function.
1447      */
1448     function _msgSenderERC721A() internal view virtual returns (address) {
1449         return msg.sender;
1450     }
1451 
1452     /**
1453      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1454      */
1455     function _toString(uint256 value) internal pure returns (string memory ptr) {
1456         assembly {
1457             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1458             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1459             // We will need 1 32-byte word to store the length,
1460             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1461             ptr := add(mload(0x40), 128)
1462             // Update the free memory pointer to allocate.
1463             mstore(0x40, ptr)
1464 
1465             // Cache the end of the memory to calculate the length later.
1466             let end := ptr
1467 
1468             // We write the string from the rightmost digit to the leftmost digit.
1469             // The following is essentially a do-while loop that also handles the zero case.
1470             // Costs a bit more than early returning for the zero case,
1471             // but cheaper in terms of deployment and overall runtime costs.
1472             for {
1473                 // Initialize and perform the first pass without check.
1474                 let temp := value
1475                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1476                 ptr := sub(ptr, 1)
1477                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1478                 mstore8(ptr, add(48, mod(temp, 10)))
1479                 temp := div(temp, 10)
1480             } temp {
1481                 // Keep dividing `temp` until zero.
1482                 temp := div(temp, 10)
1483             } {
1484                 // Body of the for loop.
1485                 ptr := sub(ptr, 1)
1486                 mstore8(ptr, add(48, mod(temp, 10)))
1487             }
1488 
1489             let length := sub(end, ptr)
1490             // Move the pointer 32 bytes leftwards to make room for the length.
1491             ptr := sub(ptr, 32)
1492             // Store the length.
1493             mstore(ptr, length)
1494         }
1495     }
1496 }
1497 
1498 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1499 
1500 
1501 // ERC721A Contracts v4.1.0
1502 // Creator: Chiru Labs
1503 
1504 pragma solidity ^0.8.4;
1505 
1506 
1507 /**
1508  * @dev Interface of an ERC721AQueryable compliant contract.
1509  */
1510 interface IERC721AQueryable is IERC721A {
1511     /**
1512      * Invalid query range (`start` >= `stop`).
1513      */
1514     error InvalidQueryRange();
1515 
1516     /**
1517      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1518      *
1519      * If the `tokenId` is out of bounds:
1520      *   - `addr` = `address(0)`
1521      *   - `startTimestamp` = `0`
1522      *   - `burned` = `false`
1523      *
1524      * If the `tokenId` is burned:
1525      *   - `addr` = `<Address of owner before token was burned>`
1526      *   - `startTimestamp` = `<Timestamp when token was burned>`
1527      *   - `burned = `true`
1528      *
1529      * Otherwise:
1530      *   - `addr` = `<Address of owner>`
1531      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1532      *   - `burned = `false`
1533      */
1534     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1535 
1536     /**
1537      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1538      * See {ERC721AQueryable-explicitOwnershipOf}
1539      */
1540     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1541 
1542     /**
1543      * @dev Returns an array of token IDs owned by `owner`,
1544      * in the range [`start`, `stop`)
1545      * (i.e. `start <= tokenId < stop`).
1546      *
1547      * This function allows for tokens to be queried if the collection
1548      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1549      *
1550      * Requirements:
1551      *
1552      * - `start` < `stop`
1553      */
1554     function tokensOfOwnerIn(
1555         address owner,
1556         uint256 start,
1557         uint256 stop
1558     ) external view returns (uint256[] memory);
1559 
1560     /**
1561      * @dev Returns an array of token IDs owned by `owner`.
1562      *
1563      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1564      * It is meant to be called off-chain.
1565      *
1566      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1567      * multiple smaller scans if the collection is large enough to cause
1568      * an out-of-gas error (10K pfp collections should be fine).
1569      */
1570     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1571 }
1572 
1573 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1574 
1575 
1576 // ERC721A Contracts v4.1.0
1577 // Creator: Chiru Labs
1578 
1579 pragma solidity ^0.8.4;
1580 
1581 
1582 
1583 /**
1584  * @title ERC721A Queryable
1585  * @dev ERC721A subclass with convenience query functions.
1586  */
1587 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1588     /**
1589      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1590      *
1591      * If the `tokenId` is out of bounds:
1592      *   - `addr` = `address(0)`
1593      *   - `startTimestamp` = `0`
1594      *   - `burned` = `false`
1595      *   - `extraData` = `0`
1596      *
1597      * If the `tokenId` is burned:
1598      *   - `addr` = `<Address of owner before token was burned>`
1599      *   - `startTimestamp` = `<Timestamp when token was burned>`
1600      *   - `burned = `true`
1601      *   - `extraData` = `<Extra data when token was burned>`
1602      *
1603      * Otherwise:
1604      *   - `addr` = `<Address of owner>`
1605      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1606      *   - `burned = `false`
1607      *   - `extraData` = `<Extra data at start of ownership>`
1608      */
1609     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1610         TokenOwnership memory ownership;
1611         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1612             return ownership;
1613         }
1614         ownership = _ownershipAt(tokenId);
1615         if (ownership.burned) {
1616             return ownership;
1617         }
1618         return _ownershipOf(tokenId);
1619     }
1620 
1621     /**
1622      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1623      * See {ERC721AQueryable-explicitOwnershipOf}
1624      */
1625     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1626         unchecked {
1627             uint256 tokenIdsLength = tokenIds.length;
1628             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1629             for (uint256 i; i != tokenIdsLength; ++i) {
1630                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1631             }
1632             return ownerships;
1633         }
1634     }
1635 
1636     /**
1637      * @dev Returns an array of token IDs owned by `owner`,
1638      * in the range [`start`, `stop`)
1639      * (i.e. `start <= tokenId < stop`).
1640      *
1641      * This function allows for tokens to be queried if the collection
1642      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1643      *
1644      * Requirements:
1645      *
1646      * - `start` < `stop`
1647      */
1648     function tokensOfOwnerIn(
1649         address owner,
1650         uint256 start,
1651         uint256 stop
1652     ) external view override returns (uint256[] memory) {
1653         unchecked {
1654             if (start >= stop) revert InvalidQueryRange();
1655             uint256 tokenIdsIdx;
1656             uint256 stopLimit = _nextTokenId();
1657             // Set `start = max(start, _startTokenId())`.
1658             if (start < _startTokenId()) {
1659                 start = _startTokenId();
1660             }
1661             // Set `stop = min(stop, stopLimit)`.
1662             if (stop > stopLimit) {
1663                 stop = stopLimit;
1664             }
1665             uint256 tokenIdsMaxLength = balanceOf(owner);
1666             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1667             // to cater for cases where `balanceOf(owner)` is too big.
1668             if (start < stop) {
1669                 uint256 rangeLength = stop - start;
1670                 if (rangeLength < tokenIdsMaxLength) {
1671                     tokenIdsMaxLength = rangeLength;
1672                 }
1673             } else {
1674                 tokenIdsMaxLength = 0;
1675             }
1676             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1677             if (tokenIdsMaxLength == 0) {
1678                 return tokenIds;
1679             }
1680             // We need to call `explicitOwnershipOf(start)`,
1681             // because the slot at `start` may not be initialized.
1682             TokenOwnership memory ownership = explicitOwnershipOf(start);
1683             address currOwnershipAddr;
1684             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1685             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1686             if (!ownership.burned) {
1687                 currOwnershipAddr = ownership.addr;
1688             }
1689             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1690                 ownership = _ownershipAt(i);
1691                 if (ownership.burned) {
1692                     continue;
1693                 }
1694                 if (ownership.addr != address(0)) {
1695                     currOwnershipAddr = ownership.addr;
1696                 }
1697                 if (currOwnershipAddr == owner) {
1698                     tokenIds[tokenIdsIdx++] = i;
1699                 }
1700             }
1701             // Downsize the array to fit.
1702             assembly {
1703                 mstore(tokenIds, tokenIdsIdx)
1704             }
1705             return tokenIds;
1706         }
1707     }
1708 
1709     /**
1710      * @dev Returns an array of token IDs owned by `owner`.
1711      *
1712      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1713      * It is meant to be called off-chain.
1714      *
1715      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1716      * multiple smaller scans if the collection is large enough to cause
1717      * an out-of-gas error (10K pfp collections should be fine).
1718      */
1719     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1720         unchecked {
1721             uint256 tokenIdsIdx;
1722             address currOwnershipAddr;
1723             uint256 tokenIdsLength = balanceOf(owner);
1724             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1725             TokenOwnership memory ownership;
1726             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1727                 ownership = _ownershipAt(i);
1728                 if (ownership.burned) {
1729                     continue;
1730                 }
1731                 if (ownership.addr != address(0)) {
1732                     currOwnershipAddr = ownership.addr;
1733                 }
1734                 if (currOwnershipAddr == owner) {
1735                     tokenIds[tokenIdsIdx++] = i;
1736                 }
1737             }
1738             return tokenIds;
1739         }
1740     }
1741 }
1742 
1743 
1744 
1745 pragma solidity >=0.8.9 <0.9.0;
1746 
1747 contract ABCBAYC is ERC721AQueryable, Ownable, ReentrancyGuard {
1748     using Strings for uint256;
1749 
1750     uint256 public maxSupply = 4000;
1751 	uint256 public Ownermint = 1;
1752     uint256 public maxPerAddress = 50;
1753 	uint256 public maxPerTX = 10;
1754     uint256 public cost = 0.005 ether;
1755 	mapping(address => bool) public freeMinted; 
1756 
1757     bool public paused = true;
1758 
1759 	string public uriPrefix = '';
1760     string public uriSuffix = '.json';
1761 	
1762   constructor(string memory baseURI) ERC721A("ABCBAYC", "ABCBAYC") {
1763       setUriPrefix(baseURI); 
1764       _safeMint(_msgSender(), Ownermint);
1765 
1766   }
1767 
1768   modifier callerIsUser() {
1769         require(tx.origin == msg.sender, "The caller is another contract");
1770         _;
1771   }
1772 
1773   function numberMinted(address owner) public view returns (uint256) {
1774         return _numberMinted(owner);
1775   }
1776 
1777   function mint(uint256 _mintAmount) public payable nonReentrant callerIsUser{
1778         require(!paused, 'The contract is paused!');
1779         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1780         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1781         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1782 	if (freeMinted[_msgSender()]){
1783         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1784   }
1785     else{
1786 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1787         freeMinted[_msgSender()] = true;
1788   }
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
1821   function withdraw() external onlyOwner {
1822         payable(msg.sender).transfer(address(this).balance);
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