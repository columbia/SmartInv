1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 /**
5      __________  _____ _____.___._________  
6 \______   \/  _  \\__  |   |\_   ___ \ 
7  |     ___/  /_\  \/   |   |/    \  \/ 
8  |    |  /    |    \____   |\     \____
9  |____|  \____|__  / ______| \______  /
10                  \/\/               \/ 
11 */   
12 
13 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Contract module that helps prevent reentrant calls to a function.
19  *
20  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
21  * available, which can be applied to functions to make sure there are no nested
22  * (reentrant) calls to them.
23  *
24  * Note that because there is a single `nonReentrant` guard, functions marked as
25  * `nonReentrant` may not call one another. This can be worked around by making
26  * those functions `private`, and then adding `external` `nonReentrant` entry
27  * points to them.
28  *
29  * TIP: If you would like to learn more about reentrancy and alternative ways
30  * to protect against it, check out our blog post
31  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
32  */
33 abstract contract ReentrancyGuard {
34     // Booleans are more expensive than uint256 or any type that takes up a full
35     // word because each write operation emits an extra SLOAD to first read the
36     // slot's contents, replace the bits taken up by the boolean, and then write
37     // back. This is the compiler's defense against contract upgrades and
38     // pointer aliasing, and it cannot be disabled.
39 
40     // The values being non-zero value makes deployment a bit more expensive,
41     // but in exchange the refund on every call to nonReentrant will be lower in
42     // amount. Since refunds are capped to a percentage of the total
43     // transaction's gas, it is best to keep them low in cases like this one, to
44     // increase the likelihood of the full refund coming into effect.
45     uint256 private constant _NOT_ENTERED = 1;
46     uint256 private constant _ENTERED = 2;
47 
48     uint256 private _status;
49 
50     constructor() {
51         _status = _NOT_ENTERED;
52     }
53 
54     /**
55      * @dev Prevents a contract from calling itself, directly or indirectly.
56      * Calling a `nonReentrant` function from another `nonReentrant`
57      * function is not supported. It is possible to prevent this from happening
58      * by making the `nonReentrant` function external, and making it call a
59      * `private` function that does the actual work.
60      */
61     modifier nonReentrant() {
62         // On the first call to nonReentrant, _notEntered will be true
63         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
64 
65         // Any calls to nonReentrant after this point will fail
66         _status = _ENTERED;
67 
68         _;
69 
70         // By storing the original value once again, a refund is triggered (see
71         // https://eips.ethereum.org/EIPS/eip-2200)
72         _status = _NOT_ENTERED;
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Strings.sol
77 
78 
79 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev String operations.
85  */
86 library Strings {
87     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
88     uint8 private constant _ADDRESS_LENGTH = 20;
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
92      */
93     function toString(uint256 value) internal pure returns (string memory) {
94         // Inspired by OraclizeAPI's implementation - MIT licence
95         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
96 
97         if (value == 0) {
98             return "0";
99         }
100         uint256 temp = value;
101         uint256 digits;
102         while (temp != 0) {
103             digits++;
104             temp /= 10;
105         }
106         bytes memory buffer = new bytes(digits);
107         while (value != 0) {
108             digits -= 1;
109             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
110             value /= 10;
111         }
112         return string(buffer);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
117      */
118     function toHexString(uint256 value) internal pure returns (string memory) {
119         if (value == 0) {
120             return "0x00";
121         }
122         uint256 temp = value;
123         uint256 length = 0;
124         while (temp != 0) {
125             length++;
126             temp >>= 8;
127         }
128         return toHexString(value, length);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
133      */
134     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
135         bytes memory buffer = new bytes(2 * length + 2);
136         buffer[0] = "0";
137         buffer[1] = "x";
138         for (uint256 i = 2 * length + 1; i > 1; --i) {
139             buffer[i] = _HEX_SYMBOLS[value & 0xf];
140             value >>= 4;
141         }
142         require(value == 0, "Strings: hex length insufficient");
143         return string(buffer);
144     }
145 
146     /**
147      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
148      */
149     function toHexString(address addr) internal pure returns (string memory) {
150         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
151     }
152 }
153 
154 
155 // File: @openzeppelin/contracts/utils/Context.sol
156 
157 
158 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
159 
160 pragma solidity ^0.8.0;
161 
162 /**
163  * @dev Provides information about the current execution context, including the
164  * sender of the transaction and its data. While these are generally available
165  * via msg.sender and msg.data, they should not be accessed in such a direct
166  * manner, since when dealing with meta-transactions the account sending and
167  * paying for execution may not be the actual sender (as far as an application
168  * is concerned).
169  *
170  * This contract is only required for intermediate, library-like contracts.
171  */
172 abstract contract Context {
173     function _msgSender() internal view virtual returns (address) {
174         return msg.sender;
175     }
176 
177     function _msgData() internal view virtual returns (bytes calldata) {
178         return msg.data;
179     }
180 }
181 
182 // File: @openzeppelin/contracts/access/Ownable.sol
183 
184 
185 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 
190 /**
191  * @dev Contract module which provides a basic access control mechanism, where
192  * there is an account (an owner) that can be granted exclusive access to
193  * specific functions.
194  *
195  * By default, the owner account will be the one that deploys the contract. This
196  * can later be changed with {transferOwnership}.
197  *
198  * This module is used through inheritance. It will make available the modifier
199  * `onlyOwner`, which can be applied to your functions to restrict their use to
200  * the owner.
201  */
202 abstract contract Ownable is Context {
203     address private _owner;
204 
205     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
206 
207     /**
208      * @dev Initializes the contract setting the deployer as the initial owner.
209      */
210     constructor() {
211         _transferOwnership(_msgSender());
212     }
213 
214     /**
215      * @dev Throws if called by any account other than the owner.
216      */
217     modifier onlyOwner() {
218         _checkOwner();
219         _;
220     }
221 
222     /**
223      * @dev Returns the address of the current owner.
224      */
225     function owner() public view virtual returns (address) {
226         return _owner;
227     }
228 
229     /**
230      * @dev Throws if the sender is not the owner.
231      */
232     function _checkOwner() internal view virtual {
233         require(owner() == _msgSender(), "Ownable: caller is not the owner");
234     }
235 
236     /**
237      * @dev Leaves the contract without owner. It will not be possible to call
238      * `onlyOwner` functions anymore. Can only be called by the current owner.
239      *
240      * NOTE: Renouncing ownership will leave the contract without an owner,
241      * thereby removing any functionality that is only available to the owner.
242      */
243     function renounceOwnership() public virtual onlyOwner {
244         _transferOwnership(address(0));
245     }
246 
247     /**
248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
249      * Can only be called by the current owner.
250      */
251     function transferOwnership(address newOwner) public virtual onlyOwner {
252         require(newOwner != address(0), "Ownable: new owner is the zero address");
253         _transferOwnership(newOwner);
254     }
255 
256     /**
257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
258      * Internal function without access restriction.
259      */
260     function _transferOwnership(address newOwner) internal virtual {
261         address oldOwner = _owner;
262         _owner = newOwner;
263         emit OwnershipTransferred(oldOwner, newOwner);
264     }
265 }
266 
267 // File: erc721a/contracts/IERC721A.sol
268 
269 
270 // ERC721A Contracts v4.1.0
271 // Creator: Chiru Labs
272 
273 pragma solidity ^0.8.4;
274 
275 /**
276  * @dev Interface of an ERC721A compliant contract.
277  */
278 interface IERC721A {
279     /**
280      * The caller must own the token or be an approved operator.
281      */
282     error ApprovalCallerNotOwnerNorApproved();
283 
284     /**
285      * The token does not exist.
286      */
287     error ApprovalQueryForNonexistentToken();
288 
289     /**
290      * The caller cannot approve to their own address.
291      */
292     error ApproveToCaller();
293 
294     /**
295      * Cannot query the balance for the zero address.
296      */
297     error BalanceQueryForZeroAddress();
298 
299     /**
300      * Cannot mint to the zero address.
301      */
302     error MintToZeroAddress();
303 
304     /**
305      * The quantity of tokens minted must be more than zero.
306      */
307     error MintZeroQuantity();
308 
309     /**
310      * The token does not exist.
311      */
312     error OwnerQueryForNonexistentToken();
313 
314     /**
315      * The caller must own the token or be an approved operator.
316      */
317     error TransferCallerNotOwnerNorApproved();
318 
319     /**
320      * The token must be owned by `from`.
321      */
322     error TransferFromIncorrectOwner();
323 
324     /**
325      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
326      */
327     error TransferToNonERC721ReceiverImplementer();
328 
329     /**
330      * Cannot transfer to the zero address.
331      */
332     error TransferToZeroAddress();
333 
334     /**
335      * The token does not exist.
336      */
337     error URIQueryForNonexistentToken();
338 
339     /**
340      * The `quantity` minted with ERC2309 exceeds the safety limit.
341      */
342     error MintERC2309QuantityExceedsLimit();
343 
344     /**
345      * The `extraData` cannot be set on an unintialized ownership slot.
346      */
347     error OwnershipNotInitializedForExtraData();
348 
349     struct TokenOwnership {
350         // The address of the owner.
351         address addr;
352         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
353         uint64 startTimestamp;
354         // Whether the token has been burned.
355         bool burned;
356         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
357         uint24 extraData;
358     }
359 
360     /**
361      * @dev Returns the total amount of tokens stored by the contract.
362      *
363      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
364      */
365     function totalSupply() external view returns (uint256);
366 
367     // ==============================
368     //            IERC165
369     // ==============================
370 
371     /**
372      * @dev Returns true if this contract implements the interface defined by
373      * `interfaceId`. See the corresponding
374      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
375      * to learn more about how these ids are created.
376      *
377      * This function call must use less than 30 000 gas.
378      */
379     function supportsInterface(bytes4 interfaceId) external view returns (bool);
380 
381     // ==============================
382     //            IERC721
383     // ==============================
384 
385     /**
386      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
387      */
388     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
389 
390     /**
391      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
392      */
393     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
394 
395     /**
396      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
397      */
398     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
399 
400     /**
401      * @dev Returns the number of tokens in ``owner``'s account.
402      */
403     function balanceOf(address owner) external view returns (uint256 balance);
404 
405     /**
406      * @dev Returns the owner of the `tokenId` token.
407      *
408      * Requirements:
409      *
410      * - `tokenId` must exist.
411      */
412     function ownerOf(uint256 tokenId) external view returns (address owner);
413 
414     /**
415      * @dev Safely transfers `tokenId` token from `from` to `to`.
416      *
417      * Requirements:
418      *
419      * - `from` cannot be the zero address.
420      * - `to` cannot be the zero address.
421      * - `tokenId` token must exist and be owned by `from`.
422      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
424      *
425      * Emits a {Transfer} event.
426      */
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId,
431         bytes calldata data
432     ) external;
433 
434     /**
435      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
436      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must exist and be owned by `from`.
443      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
444      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
445      *
446      * Emits a {Transfer} event.
447      */
448     function safeTransferFrom(
449         address from,
450         address to,
451         uint256 tokenId
452     ) external;
453 
454     /**
455      * @dev Transfers `tokenId` token from `from` to `to`.
456      *
457      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must be owned by `from`.
464      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
465      *
466      * Emits a {Transfer} event.
467      */
468     function transferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) external;
473 
474     /**
475      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
476      * The approval is cleared when the token is transferred.
477      *
478      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
479      *
480      * Requirements:
481      *
482      * - The caller must own the token or be an approved operator.
483      * - `tokenId` must exist.
484      *
485      * Emits an {Approval} event.
486      */
487     function approve(address to, uint256 tokenId) external;
488 
489     /**
490      * @dev Approve or remove `operator` as an operator for the caller.
491      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
492      *
493      * Requirements:
494      *
495      * - The `operator` cannot be the caller.
496      *
497      * Emits an {ApprovalForAll} event.
498      */
499     function setApprovalForAll(address operator, bool _approved) external;
500 
501     /**
502      * @dev Returns the account approved for `tokenId` token.
503      *
504      * Requirements:
505      *
506      * - `tokenId` must exist.
507      */
508     function getApproved(uint256 tokenId) external view returns (address operator);
509 
510     /**
511      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
512      *
513      * See {setApprovalForAll}
514      */
515     function isApprovedForAll(address owner, address operator) external view returns (bool);
516 
517     // ==============================
518     //        IERC721Metadata
519     // ==============================
520 
521     /**
522      * @dev Returns the token collection name.
523      */
524     function name() external view returns (string memory);
525 
526     /**
527      * @dev Returns the token collection symbol.
528      */
529     function symbol() external view returns (string memory);
530 
531     /**
532      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
533      */
534     function tokenURI(uint256 tokenId) external view returns (string memory);
535 
536     // ==============================
537     //            IERC2309
538     // ==============================
539 
540     /**
541      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
542      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
543      */
544     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
545 }
546 
547 // File: erc721a/contracts/ERC721A.sol
548 
549 
550 // ERC721A Contracts v4.1.0
551 // Creator: Chiru Labs
552 
553 pragma solidity ^0.8.4;
554 
555 
556 /**
557  * @dev ERC721 token receiver interface.
558  */
559 interface ERC721A__IERC721Receiver {
560     function onERC721Received(
561         address operator,
562         address from,
563         uint256 tokenId,
564         bytes calldata data
565     ) external returns (bytes4);
566 }
567 
568 /**
569  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
570  * including the Metadata extension. Built to optimize for lower gas during batch mints.
571  *
572  * Assumes serials are sequentially minted starting at `_startTokenId()`
573  * (defaults to 0, e.g. 0, 1, 2, 3..).
574  *
575  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
576  *
577  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
578  */
579 contract ERC721A is IERC721A {
580     // Mask of an entry in packed address data.
581     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
582 
583     // The bit position of `numberMinted` in packed address data.
584     uint256 private constant BITPOS_NUMBER_MINTED = 64;
585 
586     // The bit position of `numberBurned` in packed address data.
587     uint256 private constant BITPOS_NUMBER_BURNED = 128;
588 
589     // The bit position of `aux` in packed address data.
590     uint256 private constant BITPOS_AUX = 192;
591 
592     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
593     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
594 
595     // The bit position of `startTimestamp` in packed ownership.
596     uint256 private constant BITPOS_START_TIMESTAMP = 160;
597 
598     // The bit mask of the `burned` bit in packed ownership.
599     uint256 private constant BITMASK_BURNED = 1 << 224;
600 
601     // The bit position of the `nextInitialized` bit in packed ownership.
602     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
603 
604     // The bit mask of the `nextInitialized` bit in packed ownership.
605     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
606 
607     // The bit position of `extraData` in packed ownership.
608     uint256 private constant BITPOS_EXTRA_DATA = 232;
609 
610     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
611     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
612 
613     // The mask of the lower 160 bits for addresses.
614     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
615 
616     // The maximum `quantity` that can be minted with `_mintERC2309`.
617     // This limit is to prevent overflows on the address data entries.
618     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
619     // is required to cause an overflow, which is unrealistic.
620     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
621 
622     // The tokenId of the next token to be minted.
623     uint256 private _currentIndex;
624 
625     // The number of tokens burned.
626     uint256 private _burnCounter;
627 
628     // Token name
629     string private _name;
630 
631     // Token symbol
632     string private _symbol;
633 
634     // Mapping from token ID to ownership details
635     // An empty struct value does not necessarily mean the token is unowned.
636     // See `_packedOwnershipOf` implementation for details.
637     //
638     // Bits Layout:
639     // - [0..159]   `addr`
640     // - [160..223] `startTimestamp`
641     // - [224]      `burned`
642     // - [225]      `nextInitialized`
643     // - [232..255] `extraData`
644     mapping(uint256 => uint256) private _packedOwnerships;
645 
646     // Mapping owner address to address data.
647     //
648     // Bits Layout:
649     // - [0..63]    `balance`
650     // - [64..127]  `numberMinted`
651     // - [128..191] `numberBurned`
652     // - [192..255] `aux`
653     mapping(address => uint256) private _packedAddressData;
654 
655     // Mapping from token ID to approved address.
656     mapping(uint256 => address) private _tokenApprovals;
657 
658     // Mapping from owner to operator approvals
659     mapping(address => mapping(address => bool)) private _operatorApprovals;
660 
661     constructor(string memory name_, string memory symbol_) {
662         _name = name_;
663         _symbol = symbol_;
664         _currentIndex = _startTokenId();
665     }
666 
667     /**
668      * @dev Returns the starting token ID.
669      * To change the starting token ID, please override this function.
670      */
671     function _startTokenId() internal view virtual returns (uint256) {
672         return 0;
673     }
674 
675     /**
676      * @dev Returns the next token ID to be minted.
677      */
678     function _nextTokenId() internal view returns (uint256) {
679         return _currentIndex;
680     }
681 
682     /**
683      * @dev Returns the total number of tokens in existence.
684      * Burned tokens will reduce the count.
685      * To get the total number of tokens minted, please see `_totalMinted`.
686      */
687     function totalSupply() public view override returns (uint256) {
688         // Counter underflow is impossible as _burnCounter cannot be incremented
689         // more than `_currentIndex - _startTokenId()` times.
690         unchecked {
691             return _currentIndex - _burnCounter - _startTokenId();
692         }
693     }
694 
695     /**
696      * @dev Returns the total amount of tokens minted in the contract.
697      */
698     function _totalMinted() internal view returns (uint256) {
699         // Counter underflow is impossible as _currentIndex does not decrement,
700         // and it is initialized to `_startTokenId()`
701         unchecked {
702             return _currentIndex - _startTokenId();
703         }
704     }
705 
706     /**
707      * @dev Returns the total number of tokens burned.
708      */
709     function _totalBurned() internal view returns (uint256) {
710         return _burnCounter;
711     }
712 
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717         // The interface IDs are constants representing the first 4 bytes of the XOR of
718         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
719         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
720         return
721             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
722             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
723             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
724     }
725 
726     /**
727      * @dev See {IERC721-balanceOf}.
728      */
729     function balanceOf(address owner) public view override returns (uint256) {
730         if (owner == address(0)) revert BalanceQueryForZeroAddress();
731         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
732     }
733 
734     /**
735      * Returns the number of tokens minted by `owner`.
736      */
737     function _numberMinted(address owner) internal view returns (uint256) {
738         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
739     }
740 
741     /**
742      * Returns the number of tokens burned by or on behalf of `owner`.
743      */
744     function _numberBurned(address owner) internal view returns (uint256) {
745         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
746     }
747 
748     /**
749      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
750      */
751     function _getAux(address owner) internal view returns (uint64) {
752         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
753     }
754 
755     /**
756      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
757      * If there are multiple variables, please pack them into a uint64.
758      */
759     function _setAux(address owner, uint64 aux) internal {
760         uint256 packed = _packedAddressData[owner];
761         uint256 auxCasted;
762         // Cast `aux` with assembly to avoid redundant masking.
763         assembly {
764             auxCasted := aux
765         }
766         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
767         _packedAddressData[owner] = packed;
768     }
769 
770     /**
771      * Returns the packed ownership data of `tokenId`.
772      */
773     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
774         uint256 curr = tokenId;
775 
776         unchecked {
777             if (_startTokenId() <= curr)
778                 if (curr < _currentIndex) {
779                     uint256 packed = _packedOwnerships[curr];
780                     // If not burned.
781                     if (packed & BITMASK_BURNED == 0) {
782                         // Invariant:
783                         // There will always be an ownership that has an address and is not burned
784                         // before an ownership that does not have an address and is not burned.
785                         // Hence, curr will not underflow.
786                         //
787                         // We can directly compare the packed value.
788                         // If the address is zero, packed is zero.
789                         while (packed == 0) {
790                             packed = _packedOwnerships[--curr];
791                         }
792                         return packed;
793                     }
794                 }
795         }
796         revert OwnerQueryForNonexistentToken();
797     }
798 
799     /**
800      * Returns the unpacked `TokenOwnership` struct from `packed`.
801      */
802     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
803         ownership.addr = address(uint160(packed));
804         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
805         ownership.burned = packed & BITMASK_BURNED != 0;
806         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
807     }
808 
809     /**
810      * Returns the unpacked `TokenOwnership` struct at `index`.
811      */
812     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
813         return _unpackedOwnership(_packedOwnerships[index]);
814     }
815 
816     /**
817      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
818      */
819     function _initializeOwnershipAt(uint256 index) internal {
820         if (_packedOwnerships[index] == 0) {
821             _packedOwnerships[index] = _packedOwnershipOf(index);
822         }
823     }
824 
825     /**
826      * Gas spent here starts off proportional to the maximum mint batch size.
827      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
828      */
829     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
830         return _unpackedOwnership(_packedOwnershipOf(tokenId));
831     }
832 
833     /**
834      * @dev Packs ownership data into a single uint256.
835      */
836     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
837         assembly {
838             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
839             owner := and(owner, BITMASK_ADDRESS)
840             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
841             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
842         }
843     }
844 
845     /**
846      * @dev See {IERC721-ownerOf}.
847      */
848     function ownerOf(uint256 tokenId) public view override returns (address) {
849         return address(uint160(_packedOwnershipOf(tokenId)));
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-name}.
854      */
855     function name() public view virtual override returns (string memory) {
856         return _name;
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-symbol}.
861      */
862     function symbol() public view virtual override returns (string memory) {
863         return _symbol;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-tokenURI}.
868      */
869     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
870         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
871 
872         string memory baseURI = _baseURI();
873         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
874     }
875 
876     /**
877      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
878      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
879      * by default, it can be overridden in child contracts.
880      */
881     function _baseURI() internal view virtual returns (string memory) {
882         return '';
883     }
884 
885     /**
886      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
887      */
888     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
889         // For branchless setting of the `nextInitialized` flag.
890         assembly {
891             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
892             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
893         }
894     }
895 
896     /**
897      * @dev See {IERC721-approve}.
898      */
899     function approve(address to, uint256 tokenId) public override {
900         address owner = ownerOf(tokenId);
901 
902         if (_msgSenderERC721A() != owner)
903             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
904                 revert ApprovalCallerNotOwnerNorApproved();
905             }
906 
907         _tokenApprovals[tokenId] = to;
908         emit Approval(owner, to, tokenId);
909     }
910 
911     /**
912      * @dev See {IERC721-getApproved}.
913      */
914     function getApproved(uint256 tokenId) public view override returns (address) {
915         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
916 
917         return _tokenApprovals[tokenId];
918     }
919 
920     /**
921      * @dev See {IERC721-setApprovalForAll}.
922      */
923     function setApprovalForAll(address operator, bool approved) public virtual override {
924         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
925 
926         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
927         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
928     }
929 
930     /**
931      * @dev See {IERC721-isApprovedForAll}.
932      */
933     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
934         return _operatorApprovals[owner][operator];
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         safeTransferFrom(from, to, tokenId, '');
946     }
947 
948     /**
949      * @dev See {IERC721-safeTransferFrom}.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) public virtual override {
957         transferFrom(from, to, tokenId);
958         if (to.code.length != 0)
959             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
960                 revert TransferToNonERC721ReceiverImplementer();
961             }
962     }
963 
964     /**
965      * @dev Returns whether `tokenId` exists.
966      *
967      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
968      *
969      * Tokens start existing when they are minted (`_mint`),
970      */
971     function _exists(uint256 tokenId) internal view returns (bool) {
972         return
973             _startTokenId() <= tokenId &&
974             tokenId < _currentIndex && // If within bounds,
975             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
976     }
977 
978     /**
979      * @dev Equivalent to `_safeMint(to, quantity, '')`.
980      */
981     function _safeMint(address to, uint256 quantity) internal {
982         _safeMint(to, quantity, '');
983     }
984 
985     /**
986      * @dev Safely mints `quantity` tokens and transfers them to `to`.
987      *
988      * Requirements:
989      *
990      * - If `to` refers to a smart contract, it must implement
991      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
992      * - `quantity` must be greater than 0.
993      *
994      * See {_mint}.
995      *
996      * Emits a {Transfer} event for each mint.
997      */
998     function _safeMint(
999         address to,
1000         uint256 quantity,
1001         bytes memory _data
1002     ) internal {
1003         _mint(to, quantity);
1004 
1005         unchecked {
1006             if (to.code.length != 0) {
1007                 uint256 end = _currentIndex;
1008                 uint256 index = end - quantity;
1009                 do {
1010                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1011                         revert TransferToNonERC721ReceiverImplementer();
1012                     }
1013                 } while (index < end);
1014                 // Reentrancy protection.
1015                 if (_currentIndex != end) revert();
1016             }
1017         }
1018     }
1019 
1020     /**
1021      * @dev Mints `quantity` tokens and transfers them to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `quantity` must be greater than 0.
1027      *
1028      * Emits a {Transfer} event for each mint.
1029      */
1030     function _mint(address to, uint256 quantity) internal {
1031         uint256 startTokenId = _currentIndex;
1032         if (to == address(0)) revert MintToZeroAddress();
1033         if (quantity == 0) revert MintZeroQuantity();
1034 
1035         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1036 
1037         // Overflows are incredibly unrealistic.
1038         // `balance` and `numberMinted` have a maximum limit of 2**64.
1039         // `tokenId` has a maximum limit of 2**256.
1040         unchecked {
1041             // Updates:
1042             // - `balance += quantity`.
1043             // - `numberMinted += quantity`.
1044             //
1045             // We can directly add to the `balance` and `numberMinted`.
1046             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1047 
1048             // Updates:
1049             // - `address` to the owner.
1050             // - `startTimestamp` to the timestamp of minting.
1051             // - `burned` to `false`.
1052             // - `nextInitialized` to `quantity == 1`.
1053             _packedOwnerships[startTokenId] = _packOwnershipData(
1054                 to,
1055                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1056             );
1057 
1058             uint256 tokenId = startTokenId;
1059             uint256 end = startTokenId + quantity;
1060             do {
1061                 emit Transfer(address(0), to, tokenId++);
1062             } while (tokenId < end);
1063 
1064             _currentIndex = end;
1065         }
1066         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1067     }
1068 
1069     /**
1070      * @dev Mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * This function is intended for efficient minting only during contract creation.
1073      *
1074      * It emits only one {ConsecutiveTransfer} as defined in
1075      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1076      * instead of a sequence of {Transfer} event(s).
1077      *
1078      * Calling this function outside of contract creation WILL make your contract
1079      * non-compliant with the ERC721 standard.
1080      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1081      * {ConsecutiveTransfer} event is only permissible during contract creation.
1082      *
1083      * Requirements:
1084      *
1085      * - `to` cannot be the zero address.
1086      * - `quantity` must be greater than 0.
1087      *
1088      * Emits a {ConsecutiveTransfer} event.
1089      */
1090     function _mintERC2309(address to, uint256 quantity) internal {
1091         uint256 startTokenId = _currentIndex;
1092         if (to == address(0)) revert MintToZeroAddress();
1093         if (quantity == 0) revert MintZeroQuantity();
1094         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1095 
1096         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1097 
1098         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1099         unchecked {
1100             // Updates:
1101             // - `balance += quantity`.
1102             // - `numberMinted += quantity`.
1103             //
1104             // We can directly add to the `balance` and `numberMinted`.
1105             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1106 
1107             // Updates:
1108             // - `address` to the owner.
1109             // - `startTimestamp` to the timestamp of minting.
1110             // - `burned` to `false`.
1111             // - `nextInitialized` to `quantity == 1`.
1112             _packedOwnerships[startTokenId] = _packOwnershipData(
1113                 to,
1114                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1115             );
1116 
1117             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1118 
1119             _currentIndex = startTokenId + quantity;
1120         }
1121         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1122     }
1123 
1124     /**
1125      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1126      */
1127     function _getApprovedAddress(uint256 tokenId)
1128         private
1129         view
1130         returns (uint256 approvedAddressSlot, address approvedAddress)
1131     {
1132         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1133         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1134         assembly {
1135             // Compute the slot.
1136             mstore(0x00, tokenId)
1137             mstore(0x20, tokenApprovalsPtr.slot)
1138             approvedAddressSlot := keccak256(0x00, 0x40)
1139             // Load the slot's value from storage.
1140             approvedAddress := sload(approvedAddressSlot)
1141         }
1142     }
1143 
1144     /**
1145      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1146      */
1147     function _isOwnerOrApproved(
1148         address approvedAddress,
1149         address from,
1150         address msgSender
1151     ) private pure returns (bool result) {
1152         assembly {
1153             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1154             from := and(from, BITMASK_ADDRESS)
1155             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1156             msgSender := and(msgSender, BITMASK_ADDRESS)
1157             // `msgSender == from || msgSender == approvedAddress`.
1158             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1159         }
1160     }
1161 
1162     /**
1163      * @dev Transfers `tokenId` from `from` to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - `to` cannot be the zero address.
1168      * - `tokenId` token must be owned by `from`.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function transferFrom(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) public virtual override {
1177         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1178 
1179         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1180 
1181         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1182 
1183         // The nested ifs save around 20+ gas over a compound boolean condition.
1184         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1185             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1186 
1187         if (to == address(0)) revert TransferToZeroAddress();
1188 
1189         _beforeTokenTransfers(from, to, tokenId, 1);
1190 
1191         // Clear approvals from the previous owner.
1192         assembly {
1193             if approvedAddress {
1194                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1195                 sstore(approvedAddressSlot, 0)
1196             }
1197         }
1198 
1199         // Underflow of the sender's balance is impossible because we check for
1200         // ownership above and the recipient's balance can't realistically overflow.
1201         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1202         unchecked {
1203             // We can directly increment and decrement the balances.
1204             --_packedAddressData[from]; // Updates: `balance -= 1`.
1205             ++_packedAddressData[to]; // Updates: `balance += 1`.
1206 
1207             // Updates:
1208             // - `address` to the next owner.
1209             // - `startTimestamp` to the timestamp of transfering.
1210             // - `burned` to `false`.
1211             // - `nextInitialized` to `true`.
1212             _packedOwnerships[tokenId] = _packOwnershipData(
1213                 to,
1214                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1215             );
1216 
1217             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1218             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1219                 uint256 nextTokenId = tokenId + 1;
1220                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1221                 if (_packedOwnerships[nextTokenId] == 0) {
1222                     // If the next slot is within bounds.
1223                     if (nextTokenId != _currentIndex) {
1224                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1225                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1226                     }
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(from, to, tokenId);
1232         _afterTokenTransfers(from, to, tokenId, 1);
1233     }
1234 
1235     /**
1236      * @dev Equivalent to `_burn(tokenId, false)`.
1237      */
1238     function _burn(uint256 tokenId) internal virtual {
1239         _burn(tokenId, false);
1240     }
1241 
1242     /**
1243      * @dev Destroys `tokenId`.
1244      * The approval is cleared when the token is burned.
1245      *
1246      * Requirements:
1247      *
1248      * - `tokenId` must exist.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1253         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1254 
1255         address from = address(uint160(prevOwnershipPacked));
1256 
1257         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1258 
1259         if (approvalCheck) {
1260             // The nested ifs save around 20+ gas over a compound boolean condition.
1261             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1262                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1263         }
1264 
1265         _beforeTokenTransfers(from, address(0), tokenId, 1);
1266 
1267         // Clear approvals from the previous owner.
1268         assembly {
1269             if approvedAddress {
1270                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1271                 sstore(approvedAddressSlot, 0)
1272             }
1273         }
1274 
1275         // Underflow of the sender's balance is impossible because we check for
1276         // ownership above and the recipient's balance can't realistically overflow.
1277         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1278         unchecked {
1279             // Updates:
1280             // - `balance -= 1`.
1281             // - `numberBurned += 1`.
1282             //
1283             // We can directly decrement the balance, and increment the number burned.
1284             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1285             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1286 
1287             // Updates:
1288             // - `address` to the last owner.
1289             // - `startTimestamp` to the timestamp of burning.
1290             // - `burned` to `true`.
1291             // - `nextInitialized` to `true`.
1292             _packedOwnerships[tokenId] = _packOwnershipData(
1293                 from,
1294                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1295             );
1296 
1297             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1298             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1299                 uint256 nextTokenId = tokenId + 1;
1300                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1301                 if (_packedOwnerships[nextTokenId] == 0) {
1302                     // If the next slot is within bounds.
1303                     if (nextTokenId != _currentIndex) {
1304                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1305                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1306                     }
1307                 }
1308             }
1309         }
1310 
1311         emit Transfer(from, address(0), tokenId);
1312         _afterTokenTransfers(from, address(0), tokenId, 1);
1313 
1314         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1315         unchecked {
1316             _burnCounter++;
1317         }
1318     }
1319 
1320     /**
1321      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1322      *
1323      * @param from address representing the previous owner of the given token ID
1324      * @param to target address that will receive the tokens
1325      * @param tokenId uint256 ID of the token to be transferred
1326      * @param _data bytes optional data to send along with the call
1327      * @return bool whether the call correctly returned the expected magic value
1328      */
1329     function _checkContractOnERC721Received(
1330         address from,
1331         address to,
1332         uint256 tokenId,
1333         bytes memory _data
1334     ) private returns (bool) {
1335         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1336             bytes4 retval
1337         ) {
1338             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1339         } catch (bytes memory reason) {
1340             if (reason.length == 0) {
1341                 revert TransferToNonERC721ReceiverImplementer();
1342             } else {
1343                 assembly {
1344                     revert(add(32, reason), mload(reason))
1345                 }
1346             }
1347         }
1348     }
1349 
1350     /**
1351      * @dev Directly sets the extra data for the ownership data `index`.
1352      */
1353     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1354         uint256 packed = _packedOwnerships[index];
1355         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1356         uint256 extraDataCasted;
1357         // Cast `extraData` with assembly to avoid redundant masking.
1358         assembly {
1359             extraDataCasted := extraData
1360         }
1361         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1362         _packedOwnerships[index] = packed;
1363     }
1364 
1365     /**
1366      * @dev Returns the next extra data for the packed ownership data.
1367      * The returned result is shifted into position.
1368      */
1369     function _nextExtraData(
1370         address from,
1371         address to,
1372         uint256 prevOwnershipPacked
1373     ) private view returns (uint256) {
1374         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1375         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1376     }
1377 
1378     /**
1379      * @dev Called during each token transfer to set the 24bit `extraData` field.
1380      * Intended to be overridden by the cosumer contract.
1381      *
1382      * `previousExtraData` - the value of `extraData` before transfer.
1383      *
1384      * Calling conditions:
1385      *
1386      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1387      * transferred to `to`.
1388      * - When `from` is zero, `tokenId` will be minted for `to`.
1389      * - When `to` is zero, `tokenId` will be burned by `from`.
1390      * - `from` and `to` are never both zero.
1391      */
1392     function _extraData(
1393         address from,
1394         address to,
1395         uint24 previousExtraData
1396     ) internal view virtual returns (uint24) {}
1397 
1398     /**
1399      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1400      * This includes minting.
1401      * And also called before burning one token.
1402      *
1403      * startTokenId - the first token id to be transferred
1404      * quantity - the amount to be transferred
1405      *
1406      * Calling conditions:
1407      *
1408      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1409      * transferred to `to`.
1410      * - When `from` is zero, `tokenId` will be minted for `to`.
1411      * - When `to` is zero, `tokenId` will be burned by `from`.
1412      * - `from` and `to` are never both zero.
1413      */
1414     function _beforeTokenTransfers(
1415         address from,
1416         address to,
1417         uint256 startTokenId,
1418         uint256 quantity
1419     ) internal virtual {}
1420 
1421     /**
1422      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1423      * This includes minting.
1424      * And also called after one token has been burned.
1425      *
1426      * startTokenId - the first token id to be transferred
1427      * quantity - the amount to be transferred
1428      *
1429      * Calling conditions:
1430      *
1431      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1432      * transferred to `to`.
1433      * - When `from` is zero, `tokenId` has been minted for `to`.
1434      * - When `to` is zero, `tokenId` has been burned by `from`.
1435      * - `from` and `to` are never both zero.
1436      */
1437     function _afterTokenTransfers(
1438         address from,
1439         address to,
1440         uint256 startTokenId,
1441         uint256 quantity
1442     ) internal virtual {}
1443 
1444     /**
1445      * @dev Returns the message sender (defaults to `msg.sender`).
1446      *
1447      * If you are writing GSN compatible contracts, you need to override this function.
1448      */
1449     function _msgSenderERC721A() internal view virtual returns (address) {
1450         return msg.sender;
1451     }
1452 
1453     /**
1454      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1455      */
1456     function _toString(uint256 value) internal pure returns (string memory ptr) {
1457         assembly {
1458             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1459             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1460             // We will need 1 32-byte word to store the length,
1461             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1462             ptr := add(mload(0x40), 128)
1463             // Update the free memory pointer to allocate.
1464             mstore(0x40, ptr)
1465 
1466             // Cache the end of the memory to calculate the length later.
1467             let end := ptr
1468 
1469             // We write the string from the rightmost digit to the leftmost digit.
1470             // The following is essentially a do-while loop that also handles the zero case.
1471             // Costs a bit more than early returning for the zero case,
1472             // but cheaper in terms of deployment and overall runtime costs.
1473             for {
1474                 // Initialize and perform the first pass without check.
1475                 let temp := value
1476                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1477                 ptr := sub(ptr, 1)
1478                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1479                 mstore8(ptr, add(48, mod(temp, 10)))
1480                 temp := div(temp, 10)
1481             } temp {
1482                 // Keep dividing `temp` until zero.
1483                 temp := div(temp, 10)
1484             } {
1485                 // Body of the for loop.
1486                 ptr := sub(ptr, 1)
1487                 mstore8(ptr, add(48, mod(temp, 10)))
1488             }
1489 
1490             let length := sub(end, ptr)
1491             // Move the pointer 32 bytes leftwards to make room for the length.
1492             ptr := sub(ptr, 32)
1493             // Store the length.
1494             mstore(ptr, length)
1495         }
1496     }
1497 }
1498 
1499 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1500 
1501 
1502 // ERC721A Contracts v4.1.0
1503 // Creator: Chiru Labs
1504 
1505 pragma solidity ^0.8.4;
1506 
1507 
1508 /**
1509  * @dev Interface of an ERC721AQueryable compliant contract.
1510  */
1511 interface IERC721AQueryable is IERC721A {
1512     /**
1513      * Invalid query range (`start` >= `stop`).
1514      */
1515     error InvalidQueryRange();
1516 
1517     /**
1518      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1519      *
1520      * If the `tokenId` is out of bounds:
1521      *   - `addr` = `address(0)`
1522      *   - `startTimestamp` = `0`
1523      *   - `burned` = `false`
1524      *
1525      * If the `tokenId` is burned:
1526      *   - `addr` = `<Address of owner before token was burned>`
1527      *   - `startTimestamp` = `<Timestamp when token was burned>`
1528      *   - `burned = `true`
1529      *
1530      * Otherwise:
1531      *   - `addr` = `<Address of owner>`
1532      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1533      *   - `burned = `false`
1534      */
1535     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1536 
1537     /**
1538      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1539      * See {ERC721AQueryable-explicitOwnershipOf}
1540      */
1541     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1542 
1543     /**
1544      * @dev Returns an array of token IDs owned by `owner`,
1545      * in the range [`start`, `stop`)
1546      * (i.e. `start <= tokenId < stop`).
1547      *
1548      * This function allows for tokens to be queried if the collection
1549      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1550      *
1551      * Requirements:
1552      *
1553      * - `start` < `stop`
1554      */
1555     function tokensOfOwnerIn(
1556         address owner,
1557         uint256 start,
1558         uint256 stop
1559     ) external view returns (uint256[] memory);
1560 
1561     /**
1562      * @dev Returns an array of token IDs owned by `owner`.
1563      *
1564      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1565      * It is meant to be called off-chain.
1566      *
1567      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1568      * multiple smaller scans if the collection is large enough to cause
1569      * an out-of-gas error (10K pfp collections should be fine).
1570      */
1571     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1572 }
1573 
1574 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1575 
1576 
1577 // ERC721A Contracts v4.1.0
1578 // Creator: Chiru Labs
1579 
1580 pragma solidity ^0.8.4;
1581 
1582 
1583 
1584 /**
1585  * @title ERC721A Queryable
1586  * @dev ERC721A subclass with convenience query functions.
1587  */
1588 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1589     /**
1590      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1591      *
1592      * If the `tokenId` is out of bounds:
1593      *   - `addr` = `address(0)`
1594      *   - `startTimestamp` = `0`
1595      *   - `burned` = `false`
1596      *   - `extraData` = `0`
1597      *
1598      * If the `tokenId` is burned:
1599      *   - `addr` = `<Address of owner before token was burned>`
1600      *   - `startTimestamp` = `<Timestamp when token was burned>`
1601      *   - `burned = `true`
1602      *   - `extraData` = `<Extra data when token was burned>`
1603      *
1604      * Otherwise:
1605      *   - `addr` = `<Address of owner>`
1606      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1607      *   - `burned = `false`
1608      *   - `extraData` = `<Extra data at start of ownership>`
1609      */
1610     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1611         TokenOwnership memory ownership;
1612         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1613             return ownership;
1614         }
1615         ownership = _ownershipAt(tokenId);
1616         if (ownership.burned) {
1617             return ownership;
1618         }
1619         return _ownershipOf(tokenId);
1620     }
1621 
1622     /**
1623      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1624      * See {ERC721AQueryable-explicitOwnershipOf}
1625      */
1626     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1627         unchecked {
1628             uint256 tokenIdsLength = tokenIds.length;
1629             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1630             for (uint256 i; i != tokenIdsLength; ++i) {
1631                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1632             }
1633             return ownerships;
1634         }
1635     }
1636 
1637     /**
1638      * @dev Returns an array of token IDs owned by `owner`,
1639      * in the range [`start`, `stop`)
1640      * (i.e. `start <= tokenId < stop`).
1641      *
1642      * This function allows for tokens to be queried if the collection
1643      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1644      *
1645      * Requirements:
1646      *
1647      * - `start` < `stop`
1648      */
1649     function tokensOfOwnerIn(
1650         address owner,
1651         uint256 start,
1652         uint256 stop
1653     ) external view override returns (uint256[] memory) {
1654         unchecked {
1655             if (start >= stop) revert InvalidQueryRange();
1656             uint256 tokenIdsIdx;
1657             uint256 stopLimit = _nextTokenId();
1658             // Set `start = max(start, _startTokenId())`.
1659             if (start < _startTokenId()) {
1660                 start = _startTokenId();
1661             }
1662             // Set `stop = min(stop, stopLimit)`.
1663             if (stop > stopLimit) {
1664                 stop = stopLimit;
1665             }
1666             uint256 tokenIdsMaxLength = balanceOf(owner);
1667             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1668             // to cater for cases where `balanceOf(owner)` is too big.
1669             if (start < stop) {
1670                 uint256 rangeLength = stop - start;
1671                 if (rangeLength < tokenIdsMaxLength) {
1672                     tokenIdsMaxLength = rangeLength;
1673                 }
1674             } else {
1675                 tokenIdsMaxLength = 0;
1676             }
1677             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1678             if (tokenIdsMaxLength == 0) {
1679                 return tokenIds;
1680             }
1681             // We need to call `explicitOwnershipOf(start)`,
1682             // because the slot at `start` may not be initialized.
1683             TokenOwnership memory ownership = explicitOwnershipOf(start);
1684             address currOwnershipAddr;
1685             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1686             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1687             if (!ownership.burned) {
1688                 currOwnershipAddr = ownership.addr;
1689             }
1690             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1691                 ownership = _ownershipAt(i);
1692                 if (ownership.burned) {
1693                     continue;
1694                 }
1695                 if (ownership.addr != address(0)) {
1696                     currOwnershipAddr = ownership.addr;
1697                 }
1698                 if (currOwnershipAddr == owner) {
1699                     tokenIds[tokenIdsIdx++] = i;
1700                 }
1701             }
1702             // Downsize the array to fit.
1703             assembly {
1704                 mstore(tokenIds, tokenIdsIdx)
1705             }
1706             return tokenIds;
1707         }
1708     }
1709 
1710     /**
1711      * @dev Returns an array of token IDs owned by `owner`.
1712      *
1713      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1714      * It is meant to be called off-chain.
1715      *
1716      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1717      * multiple smaller scans if the collection is large enough to cause
1718      * an out-of-gas error (10K pfp collections should be fine).
1719      */
1720     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1721         unchecked {
1722             uint256 tokenIdsIdx;
1723             address currOwnershipAddr;
1724             uint256 tokenIdsLength = balanceOf(owner);
1725             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1726             TokenOwnership memory ownership;
1727             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1728                 ownership = _ownershipAt(i);
1729                 if (ownership.burned) {
1730                     continue;
1731                 }
1732                 if (ownership.addr != address(0)) {
1733                     currOwnershipAddr = ownership.addr;
1734                 }
1735                 if (currOwnershipAddr == owner) {
1736                     tokenIds[tokenIdsIdx++] = i;
1737                 }
1738             }
1739             return tokenIds;
1740         }
1741     }
1742 }
1743 
1744 // File: contracts/test.sol
1745 
1746 
1747 
1748 pragma solidity >=0.8.9 <0.9.0;
1749 
1750 contract PudgyApeYachtClub is ERC721AQueryable, Ownable, ReentrancyGuard {
1751     using Strings for uint256;
1752 
1753     uint256 public maxSupply = 3333;
1754 	uint256 public Ownermint = 3;
1755     uint256 public maxPerAddress = 100;
1756 	uint256 public maxPerTX = 10;
1757     uint256 public cost = 0.001 ether;
1758 	mapping(address => bool) public freeMinted; 
1759 
1760     bool public paused = true;
1761 
1762 	string public uriPrefix = '';
1763     string public uriSuffix = '';
1764     string public hiddenURI = '';
1765 	
1766   constructor(string memory baseURI) ERC721A("Pudgy Ape Yacht Club", "PAYC") {
1767       setUriPrefix(baseURI); 
1768       _safeMint(_msgSender(), Ownermint);
1769 
1770   }
1771 
1772   modifier callerIsUser() {
1773         require(tx.origin == msg.sender, "The caller is another contract");
1774         _;
1775     }
1776 
1777   function numberMinted(address owner) public view returns (uint256) {
1778         return _numberMinted(owner);
1779     }
1780 
1781   function mint(uint256 _mintAmount) public payable nonReentrant callerIsUser{
1782         require(!paused, 'The contract is paused!');
1783         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1784         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1785         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1786 	if (freeMinted[_msgSender()]){
1787         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1788     }
1789     else{
1790 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1791         freeMinted[_msgSender()] = true;
1792 	}
1793 
1794     _safeMint(_msgSender(), _mintAmount);
1795   }
1796 
1797   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1798     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1799     string memory currentBaseURI = _baseURI();
1800     return bytes(currentBaseURI).length > 0
1801         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1802         : '';
1803   }
1804 
1805   function setPaused() public onlyOwner {
1806     paused = !paused;
1807   }
1808 
1809   function setCost(uint256 _cost) public onlyOwner {
1810     cost = _cost;
1811   }
1812   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1813     maxPerTX = _maxPerTX;
1814   }
1815 
1816   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1817     uriPrefix = _uriPrefix;
1818   }
1819 
1820   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1821     uriSuffix = _uriSuffix;
1822   }
1823 
1824   function withdraw() public onlyOwner nonReentrant {
1825    (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1826    require(os);
1827   }
1828 
1829   // Internal ->
1830   function _startTokenId() internal view virtual override returns (uint256) {
1831     return 1;
1832   }
1833 
1834   function _baseURI() internal view virtual override returns (string memory) {
1835     return uriPrefix;
1836   }
1837 }