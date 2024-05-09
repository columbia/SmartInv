1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4  /$$     /$$ /$$$$$$   /$$$$$$    /$$                    /$$$$$$$$ /$$$$$$$$ /$$   /$$
5 |  $$   /$$//$$$_  $$ /$$$_  $$  | $$                   | $$_____/|__  $$__/| $$  | $$
6  \  $$ /$$/| $$$$\ $$| $$$$\ $$ /$$$$$$   /$$$$$$$      | $$         | $$   | $$  | $$
7   \  $$$$/ | $$ $$ $$| $$ $$ $$|_  $$_/  /$$_____/      | $$$$$      | $$   | $$$$$$$$
8    \  $$/  | $$\ $$$$| $$\ $$$$  | $$   |  $$$$$$       | $$__/      | $$   | $$__  $$
9     | $$   | $$ \ $$$| $$ \ $$$  | $$ /$$\____  $$      | $$         | $$   | $$  | $$
10     | $$   |  $$$$$$/|  $$$$$$/  |  $$$$//$$$$$$$/      | $$$$$$$$   | $$   | $$  | $$
11     |__/    \______/  \______/    \___/ |_______/       |________/   |__/   |__/  |__/
12                                                                                                                                                                                                                              
13 */
14 
15 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Contract module that helps prevent reentrant calls to a function.
21  *
22  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
23  * available, which can be applied to functions to make sure there are no nested
24  * (reentrant) calls to them.
25  *
26  * Note that because there is a single `nonReentrant` guard, functions marked as
27  * `nonReentrant` may not call one another. This can be worked around by making
28  * those functions `private`, and then adding `external` `nonReentrant` entry
29  * points to them.
30  *
31  * TIP: If you would like to learn more about reentrancy and alternative ways
32  * to protect against it, check out our blog post
33  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
34  */
35 abstract contract ReentrancyGuard {
36     // Booleans are more expensive than uint256 or any type that takes up a full
37     // word because each write operation emits an extra SLOAD to first read the
38     // slot's contents, replace the bits taken up by the boolean, and then write
39     // back. This is the compiler's defense against contract upgrades and
40     // pointer aliasing, and it cannot be disabled.
41 
42     // The values being non-zero value makes deployment a bit more expensive,
43     // but in exchange the refund on every call to nonReentrant will be lower in
44     // amount. Since refunds are capped to a percentage of the total
45     // transaction's gas, it is best to keep them low in cases like this one, to
46     // increase the likelihood of the full refund coming into effect.
47     uint256 private constant _NOT_ENTERED = 1;
48     uint256 private constant _ENTERED = 2;
49 
50     uint256 private _status;
51 
52     constructor() {
53         _status = _NOT_ENTERED;
54     }
55 
56     /**
57      * @dev Prevents a contract from calling itself, directly or indirectly.
58      * Calling a `nonReentrant` function from another `nonReentrant`
59      * function is not supported. It is possible to prevent this from happening
60      * by making the `nonReentrant` function external, and making it call a
61      * `private` function that does the actual work.
62      */
63     modifier nonReentrant() {
64         // On the first call to nonReentrant, _notEntered will be true
65         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
66 
67         // Any calls to nonReentrant after this point will fail
68         _status = _ENTERED;
69 
70         _;
71 
72         // By storing the original value once again, a refund is triggered (see
73         // https://eips.ethereum.org/EIPS/eip-2200)
74         _status = _NOT_ENTERED;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Strings.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev String operations.
87  */
88 library Strings {
89     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
90     uint8 private constant _ADDRESS_LENGTH = 20;
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
94      */
95     function toString(uint256 value) internal pure returns (string memory) {
96         // Inspired by OraclizeAPI's implementation - MIT licence
97         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
98 
99         if (value == 0) {
100             return "0";
101         }
102         uint256 temp = value;
103         uint256 digits;
104         while (temp != 0) {
105             digits++;
106             temp /= 10;
107         }
108         bytes memory buffer = new bytes(digits);
109         while (value != 0) {
110             digits -= 1;
111             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
112             value /= 10;
113         }
114         return string(buffer);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
119      */
120     function toHexString(uint256 value) internal pure returns (string memory) {
121         if (value == 0) {
122             return "0x00";
123         }
124         uint256 temp = value;
125         uint256 length = 0;
126         while (temp != 0) {
127             length++;
128             temp >>= 8;
129         }
130         return toHexString(value, length);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
135      */
136     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
137         bytes memory buffer = new bytes(2 * length + 2);
138         buffer[0] = "0";
139         buffer[1] = "x";
140         for (uint256 i = 2 * length + 1; i > 1; --i) {
141             buffer[i] = _HEX_SYMBOLS[value & 0xf];
142             value >>= 4;
143         }
144         require(value == 0, "Strings: hex length insufficient");
145         return string(buffer);
146     }
147 
148     /**
149      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
150      */
151     function toHexString(address addr) internal pure returns (string memory) {
152         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
153     }
154 }
155 
156 
157 // File: @openzeppelin/contracts/utils/Context.sol
158 
159 
160 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 /**
165  * @dev Provides information about the current execution context, including the
166  * sender of the transaction and its data. While these are generally available
167  * via msg.sender and msg.data, they should not be accessed in such a direct
168  * manner, since when dealing with meta-transactions the account sending and
169  * paying for execution may not be the actual sender (as far as an application
170  * is concerned).
171  *
172  * This contract is only required for intermediate, library-like contracts.
173  */
174 abstract contract Context {
175     function _msgSender() internal view virtual returns (address) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view virtual returns (bytes calldata) {
180         return msg.data;
181     }
182 }
183 
184 // File: @openzeppelin/contracts/access/Ownable.sol
185 
186 
187 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 
192 /**
193  * @dev Contract module which provides a basic access control mechanism, where
194  * there is an account (an owner) that can be granted exclusive access to
195  * specific functions.
196  *
197  * By default, the owner account will be the one that deploys the contract. This
198  * can later be changed with {transferOwnership}.
199  *
200  * This module is used through inheritance. It will make available the modifier
201  * `onlyOwner`, which can be applied to your functions to restrict their use to
202  * the owner.
203  */
204 abstract contract Ownable is Context {
205     address private _owner;
206 
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209     /**
210      * @dev Initializes the contract setting the deployer as the initial owner.
211      */
212     constructor() {
213         _transferOwnership(_msgSender());
214     }
215 
216     /**
217      * @dev Throws if called by any account other than the owner.
218      */
219     modifier onlyOwner() {
220         _checkOwner();
221         _;
222     }
223 
224     /**
225      * @dev Returns the address of the current owner.
226      */
227     function owner() public view virtual returns (address) {
228         return _owner;
229     }
230 
231     /**
232      * @dev Throws if the sender is not the owner.
233      */
234     function _checkOwner() internal view virtual {
235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
236     }
237 
238     /**
239      * @dev Leaves the contract without owner. It will not be possible to call
240      * `onlyOwner` functions anymore. Can only be called by the current owner.
241      *
242      * NOTE: Renouncing ownership will leave the contract without an owner,
243      * thereby removing any functionality that is only available to the owner.
244      */
245     function renounceOwnership() public virtual onlyOwner {
246         _transferOwnership(address(0));
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Can only be called by the current owner.
252      */
253     function transferOwnership(address newOwner) public virtual onlyOwner {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         _transferOwnership(newOwner);
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      * Internal function without access restriction.
261      */
262     function _transferOwnership(address newOwner) internal virtual {
263         address oldOwner = _owner;
264         _owner = newOwner;
265         emit OwnershipTransferred(oldOwner, newOwner);
266     }
267 }
268 
269 // File: erc721a/contracts/IERC721A.sol
270 
271 
272 // ERC721A Contracts v4.1.0
273 // Creator: Chiru Labs
274 
275 pragma solidity ^0.8.4;
276 
277 /**
278  * @dev Interface of an ERC721A compliant contract.
279  */
280 interface IERC721A {
281     /**
282      * The caller must own the token or be an approved operator.
283      */
284     error ApprovalCallerNotOwnerNorApproved();
285 
286     /**
287      * The token does not exist.
288      */
289     error ApprovalQueryForNonexistentToken();
290 
291     /**
292      * The caller cannot approve to their own address.
293      */
294     error ApproveToCaller();
295 
296     /**
297      * Cannot query the balance for the zero address.
298      */
299     error BalanceQueryForZeroAddress();
300 
301     /**
302      * Cannot mint to the zero address.
303      */
304     error MintToZeroAddress();
305 
306     /**
307      * The quantity of tokens minted must be more than zero.
308      */
309     error MintZeroQuantity();
310 
311     /**
312      * The token does not exist.
313      */
314     error OwnerQueryForNonexistentToken();
315 
316     /**
317      * The caller must own the token or be an approved operator.
318      */
319     error TransferCallerNotOwnerNorApproved();
320 
321     /**
322      * The token must be owned by `from`.
323      */
324     error TransferFromIncorrectOwner();
325 
326     /**
327      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
328      */
329     error TransferToNonERC721ReceiverImplementer();
330 
331     /**
332      * Cannot transfer to the zero address.
333      */
334     error TransferToZeroAddress();
335 
336     /**
337      * The token does not exist.
338      */
339     error URIQueryForNonexistentToken();
340 
341     /**
342      * The `quantity` minted with ERC2309 exceeds the safety limit.
343      */
344     error MintERC2309QuantityExceedsLimit();
345 
346     /**
347      * The `extraData` cannot be set on an unintialized ownership slot.
348      */
349     error OwnershipNotInitializedForExtraData();
350 
351     struct TokenOwnership {
352         // The address of the owner.
353         address addr;
354         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
355         uint64 startTimestamp;
356         // Whether the token has been burned.
357         bool burned;
358         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
359         uint24 extraData;
360     }
361 
362     /**
363      * @dev Returns the total amount of tokens stored by the contract.
364      *
365      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
366      */
367     function totalSupply() external view returns (uint256);
368 
369     // ==============================
370     //            IERC165
371     // ==============================
372 
373     /**
374      * @dev Returns true if this contract implements the interface defined by
375      * `interfaceId`. See the corresponding
376      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
377      * to learn more about how these ids are created.
378      *
379      * This function call must use less than 30 000 gas.
380      */
381     function supportsInterface(bytes4 interfaceId) external view returns (bool);
382 
383     // ==============================
384     //            IERC721
385     // ==============================
386 
387     /**
388      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
389      */
390     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
391 
392     /**
393      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
394      */
395     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
399      */
400     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
401 
402     /**
403      * @dev Returns the number of tokens in ``owner``'s account.
404      */
405     function balanceOf(address owner) external view returns (uint256 balance);
406 
407     /**
408      * @dev Returns the owner of the `tokenId` token.
409      *
410      * Requirements:
411      *
412      * - `tokenId` must exist.
413      */
414     function ownerOf(uint256 tokenId) external view returns (address owner);
415 
416     /**
417      * @dev Safely transfers `tokenId` token from `from` to `to`.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId,
433         bytes calldata data
434     ) external;
435 
436     /**
437      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
438      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
446      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447      *
448      * Emits a {Transfer} event.
449      */
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId
454     ) external;
455 
456     /**
457      * @dev Transfers `tokenId` token from `from` to `to`.
458      *
459      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must be owned by `from`.
466      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      *
468      * Emits a {Transfer} event.
469      */
470     function transferFrom(
471         address from,
472         address to,
473         uint256 tokenId
474     ) external;
475 
476     /**
477      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
478      * The approval is cleared when the token is transferred.
479      *
480      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
481      *
482      * Requirements:
483      *
484      * - The caller must own the token or be an approved operator.
485      * - `tokenId` must exist.
486      *
487      * Emits an {Approval} event.
488      */
489     function approve(address to, uint256 tokenId) external;
490 
491     /**
492      * @dev Approve or remove `operator` as an operator for the caller.
493      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
494      *
495      * Requirements:
496      *
497      * - The `operator` cannot be the caller.
498      *
499      * Emits an {ApprovalForAll} event.
500      */
501     function setApprovalForAll(address operator, bool _approved) external;
502 
503     /**
504      * @dev Returns the account approved for `tokenId` token.
505      *
506      * Requirements:
507      *
508      * - `tokenId` must exist.
509      */
510     function getApproved(uint256 tokenId) external view returns (address operator);
511 
512     /**
513      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
514      *
515      * See {setApprovalForAll}
516      */
517     function isApprovedForAll(address owner, address operator) external view returns (bool);
518 
519     // ==============================
520     //        IERC721Metadata
521     // ==============================
522 
523     /**
524      * @dev Returns the token collection name.
525      */
526     function name() external view returns (string memory);
527 
528     /**
529      * @dev Returns the token collection symbol.
530      */
531     function symbol() external view returns (string memory);
532 
533     /**
534      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
535      */
536     function tokenURI(uint256 tokenId) external view returns (string memory);
537 
538     // ==============================
539     //            IERC2309
540     // ==============================
541 
542     /**
543      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
544      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
545      */
546     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
547 }
548 
549 // File: erc721a/contracts/ERC721A.sol
550 
551 
552 // ERC721A Contracts v4.1.0
553 // Creator: Chiru Labs
554 
555 pragma solidity ^0.8.4;
556 
557 
558 /**
559  * @dev ERC721 token receiver interface.
560  */
561 interface ERC721A__IERC721Receiver {
562     function onERC721Received(
563         address operator,
564         address from,
565         uint256 tokenId,
566         bytes calldata data
567     ) external returns (bytes4);
568 }
569 
570 /**
571  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
572  * including the Metadata extension. Built to optimize for lower gas during batch mints.
573  *
574  * Assumes serials are sequentially minted starting at `_startTokenId()`
575  * (defaults to 0, e.g. 0, 1, 2, 3..).
576  *
577  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
578  *
579  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
580  */
581 contract ERC721A is IERC721A {
582     // Mask of an entry in packed address data.
583     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
584 
585     // The bit position of `numberMinted` in packed address data.
586     uint256 private constant BITPOS_NUMBER_MINTED = 64;
587 
588     // The bit position of `numberBurned` in packed address data.
589     uint256 private constant BITPOS_NUMBER_BURNED = 128;
590 
591     // The bit position of `aux` in packed address data.
592     uint256 private constant BITPOS_AUX = 192;
593 
594     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
595     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
596 
597     // The bit position of `startTimestamp` in packed ownership.
598     uint256 private constant BITPOS_START_TIMESTAMP = 160;
599 
600     // The bit mask of the `burned` bit in packed ownership.
601     uint256 private constant BITMASK_BURNED = 1 << 224;
602 
603     // The bit position of the `nextInitialized` bit in packed ownership.
604     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
605 
606     // The bit mask of the `nextInitialized` bit in packed ownership.
607     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
608 
609     // The bit position of `extraData` in packed ownership.
610     uint256 private constant BITPOS_EXTRA_DATA = 232;
611 
612     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
613     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
614 
615     // The mask of the lower 160 bits for addresses.
616     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
617 
618     // The maximum `quantity` that can be minted with `_mintERC2309`.
619     // This limit is to prevent overflows on the address data entries.
620     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
621     // is required to cause an overflow, which is unrealistic.
622     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
623 
624     // The tokenId of the next token to be minted.
625     uint256 private _currentIndex;
626 
627     // The number of tokens burned.
628     uint256 private _burnCounter;
629 
630     // Token name
631     string private _name;
632 
633     // Token symbol
634     string private _symbol;
635 
636     // Mapping from token ID to ownership details
637     // An empty struct value does not necessarily mean the token is unowned.
638     // See `_packedOwnershipOf` implementation for details.
639     //
640     // Bits Layout:
641     // - [0..159]   `addr`
642     // - [160..223] `startTimestamp`
643     // - [224]      `burned`
644     // - [225]      `nextInitialized`
645     // - [232..255] `extraData`
646     mapping(uint256 => uint256) private _packedOwnerships;
647 
648     // Mapping owner address to address data.
649     //
650     // Bits Layout:
651     // - [0..63]    `balance`
652     // - [64..127]  `numberMinted`
653     // - [128..191] `numberBurned`
654     // - [192..255] `aux`
655     mapping(address => uint256) private _packedAddressData;
656 
657     // Mapping from token ID to approved address.
658     mapping(uint256 => address) private _tokenApprovals;
659 
660     // Mapping from owner to operator approvals
661     mapping(address => mapping(address => bool)) private _operatorApprovals;
662 
663     constructor(string memory name_, string memory symbol_) {
664         _name = name_;
665         _symbol = symbol_;
666         _currentIndex = _startTokenId();
667     }
668 
669     /**
670      * @dev Returns the starting token ID.
671      * To change the starting token ID, please override this function.
672      */
673     function _startTokenId() internal view virtual returns (uint256) {
674         return 0;
675     }
676 
677     /**
678      * @dev Returns the next token ID to be minted.
679      */
680     function _nextTokenId() internal view returns (uint256) {
681         return _currentIndex;
682     }
683 
684     /**
685      * @dev Returns the total number of tokens in existence.
686      * Burned tokens will reduce the count.
687      * To get the total number of tokens minted, please see `_totalMinted`.
688      */
689     function totalSupply() public view override returns (uint256) {
690         // Counter underflow is impossible as _burnCounter cannot be incremented
691         // more than `_currentIndex - _startTokenId()` times.
692         unchecked {
693             return _currentIndex - _burnCounter - _startTokenId();
694         }
695     }
696 
697     /**
698      * @dev Returns the total amount of tokens minted in the contract.
699      */
700     function _totalMinted() internal view returns (uint256) {
701         // Counter underflow is impossible as _currentIndex does not decrement,
702         // and it is initialized to `_startTokenId()`
703         unchecked {
704             return _currentIndex - _startTokenId();
705         }
706     }
707 
708     /**
709      * @dev Returns the total number of tokens burned.
710      */
711     function _totalBurned() internal view returns (uint256) {
712         return _burnCounter;
713     }
714 
715     /**
716      * @dev See {IERC165-supportsInterface}.
717      */
718     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719         // The interface IDs are constants representing the first 4 bytes of the XOR of
720         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
721         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
722         return
723             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
724             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
725             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
726     }
727 
728     /**
729      * @dev See {IERC721-balanceOf}.
730      */
731     function balanceOf(address owner) public view override returns (uint256) {
732         if (owner == address(0)) revert BalanceQueryForZeroAddress();
733         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
734     }
735 
736     /**
737      * Returns the number of tokens minted by `owner`.
738      */
739     function _numberMinted(address owner) internal view returns (uint256) {
740         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
741     }
742 
743     /**
744      * Returns the number of tokens burned by or on behalf of `owner`.
745      */
746     function _numberBurned(address owner) internal view returns (uint256) {
747         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
748     }
749 
750     /**
751      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
752      */
753     function _getAux(address owner) internal view returns (uint64) {
754         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
755     }
756 
757     /**
758      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
759      * If there are multiple variables, please pack them into a uint64.
760      */
761     function _setAux(address owner, uint64 aux) internal {
762         uint256 packed = _packedAddressData[owner];
763         uint256 auxCasted;
764         // Cast `aux` with assembly to avoid redundant masking.
765         assembly {
766             auxCasted := aux
767         }
768         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
769         _packedAddressData[owner] = packed;
770     }
771 
772     /**
773      * Returns the packed ownership data of `tokenId`.
774      */
775     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
776         uint256 curr = tokenId;
777 
778         unchecked {
779             if (_startTokenId() <= curr)
780                 if (curr < _currentIndex) {
781                     uint256 packed = _packedOwnerships[curr];
782                     // If not burned.
783                     if (packed & BITMASK_BURNED == 0) {
784                         // Invariant:
785                         // There will always be an ownership that has an address and is not burned
786                         // before an ownership that does not have an address and is not burned.
787                         // Hence, curr will not underflow.
788                         //
789                         // We can directly compare the packed value.
790                         // If the address is zero, packed is zero.
791                         while (packed == 0) {
792                             packed = _packedOwnerships[--curr];
793                         }
794                         return packed;
795                     }
796                 }
797         }
798         revert OwnerQueryForNonexistentToken();
799     }
800 
801     /**
802      * Returns the unpacked `TokenOwnership` struct from `packed`.
803      */
804     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
805         ownership.addr = address(uint160(packed));
806         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
807         ownership.burned = packed & BITMASK_BURNED != 0;
808         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
809     }
810 
811     /**
812      * Returns the unpacked `TokenOwnership` struct at `index`.
813      */
814     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
815         return _unpackedOwnership(_packedOwnerships[index]);
816     }
817 
818     /**
819      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
820      */
821     function _initializeOwnershipAt(uint256 index) internal {
822         if (_packedOwnerships[index] == 0) {
823             _packedOwnerships[index] = _packedOwnershipOf(index);
824         }
825     }
826 
827     /**
828      * Gas spent here starts off proportional to the maximum mint batch size.
829      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
830      */
831     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
832         return _unpackedOwnership(_packedOwnershipOf(tokenId));
833     }
834 
835     /**
836      * @dev Packs ownership data into a single uint256.
837      */
838     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
839         assembly {
840             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
841             owner := and(owner, BITMASK_ADDRESS)
842             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
843             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
844         }
845     }
846 
847     /**
848      * @dev See {IERC721-ownerOf}.
849      */
850     function ownerOf(uint256 tokenId) public view override returns (address) {
851         return address(uint160(_packedOwnershipOf(tokenId)));
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-name}.
856      */
857     function name() public view virtual override returns (string memory) {
858         return _name;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-symbol}.
863      */
864     function symbol() public view virtual override returns (string memory) {
865         return _symbol;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-tokenURI}.
870      */
871     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
872         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
873 
874         string memory baseURI = _baseURI();
875         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
876     }
877 
878     /**
879      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
880      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
881      * by default, it can be overridden in child contracts.
882      */
883     function _baseURI() internal view virtual returns (string memory) {
884         return '';
885     }
886 
887     /**
888      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
889      */
890     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
891         // For branchless setting of the `nextInitialized` flag.
892         assembly {
893             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
894             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
895         }
896     }
897 
898     /**
899      * @dev See {IERC721-approve}.
900      */
901     function approve(address to, uint256 tokenId) public override {
902         address owner = ownerOf(tokenId);
903 
904         if (_msgSenderERC721A() != owner)
905             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
906                 revert ApprovalCallerNotOwnerNorApproved();
907             }
908 
909         _tokenApprovals[tokenId] = to;
910         emit Approval(owner, to, tokenId);
911     }
912 
913     /**
914      * @dev See {IERC721-getApproved}.
915      */
916     function getApproved(uint256 tokenId) public view override returns (address) {
917         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
918 
919         return _tokenApprovals[tokenId];
920     }
921 
922     /**
923      * @dev See {IERC721-setApprovalForAll}.
924      */
925     function setApprovalForAll(address operator, bool approved) public virtual override {
926         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
927 
928         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
929         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
936         return _operatorApprovals[owner][operator];
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public virtual override {
947         safeTransferFrom(from, to, tokenId, '');
948     }
949 
950     /**
951      * @dev See {IERC721-safeTransferFrom}.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) public virtual override {
959         transferFrom(from, to, tokenId);
960         if (to.code.length != 0)
961             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
962                 revert TransferToNonERC721ReceiverImplementer();
963             }
964     }
965 
966     /**
967      * @dev Returns whether `tokenId` exists.
968      *
969      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
970      *
971      * Tokens start existing when they are minted (`_mint`),
972      */
973     function _exists(uint256 tokenId) internal view returns (bool) {
974         return
975             _startTokenId() <= tokenId &&
976             tokenId < _currentIndex && // If within bounds,
977             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
978     }
979 
980     /**
981      * @dev Equivalent to `_safeMint(to, quantity, '')`.
982      */
983     function _safeMint(address to, uint256 quantity) internal {
984         _safeMint(to, quantity, '');
985     }
986 
987     /**
988      * @dev Safely mints `quantity` tokens and transfers them to `to`.
989      *
990      * Requirements:
991      *
992      * - If `to` refers to a smart contract, it must implement
993      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
994      * - `quantity` must be greater than 0.
995      *
996      * See {_mint}.
997      *
998      * Emits a {Transfer} event for each mint.
999      */
1000     function _safeMint(
1001         address to,
1002         uint256 quantity,
1003         bytes memory _data
1004     ) internal {
1005         _mint(to, quantity);
1006 
1007         unchecked {
1008             if (to.code.length != 0) {
1009                 uint256 end = _currentIndex;
1010                 uint256 index = end - quantity;
1011                 do {
1012                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1013                         revert TransferToNonERC721ReceiverImplementer();
1014                     }
1015                 } while (index < end);
1016                 // Reentrancy protection.
1017                 if (_currentIndex != end) revert();
1018             }
1019         }
1020     }
1021 
1022     /**
1023      * @dev Mints `quantity` tokens and transfers them to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      * - `quantity` must be greater than 0.
1029      *
1030      * Emits a {Transfer} event for each mint.
1031      */
1032     function _mint(address to, uint256 quantity) internal {
1033         uint256 startTokenId = _currentIndex;
1034         if (to == address(0)) revert MintToZeroAddress();
1035         if (quantity == 0) revert MintZeroQuantity();
1036 
1037         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1038 
1039         // Overflows are incredibly unrealistic.
1040         // `balance` and `numberMinted` have a maximum limit of 2**64.
1041         // `tokenId` has a maximum limit of 2**256.
1042         unchecked {
1043             // Updates:
1044             // - `balance += quantity`.
1045             // - `numberMinted += quantity`.
1046             //
1047             // We can directly add to the `balance` and `numberMinted`.
1048             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1049 
1050             // Updates:
1051             // - `address` to the owner.
1052             // - `startTimestamp` to the timestamp of minting.
1053             // - `burned` to `false`.
1054             // - `nextInitialized` to `quantity == 1`.
1055             _packedOwnerships[startTokenId] = _packOwnershipData(
1056                 to,
1057                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1058             );
1059 
1060             uint256 tokenId = startTokenId;
1061             uint256 end = startTokenId + quantity;
1062             do {
1063                 emit Transfer(address(0), to, tokenId++);
1064             } while (tokenId < end);
1065 
1066             _currentIndex = end;
1067         }
1068         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1069     }
1070 
1071     /**
1072      * @dev Mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * This function is intended for efficient minting only during contract creation.
1075      *
1076      * It emits only one {ConsecutiveTransfer} as defined in
1077      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1078      * instead of a sequence of {Transfer} event(s).
1079      *
1080      * Calling this function outside of contract creation WILL make your contract
1081      * non-compliant with the ERC721 standard.
1082      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1083      * {ConsecutiveTransfer} event is only permissible during contract creation.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {ConsecutiveTransfer} event.
1091      */
1092     function _mintERC2309(address to, uint256 quantity) internal {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1097 
1098         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1099 
1100         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1101         unchecked {
1102             // Updates:
1103             // - `balance += quantity`.
1104             // - `numberMinted += quantity`.
1105             //
1106             // We can directly add to the `balance` and `numberMinted`.
1107             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1108 
1109             // Updates:
1110             // - `address` to the owner.
1111             // - `startTimestamp` to the timestamp of minting.
1112             // - `burned` to `false`.
1113             // - `nextInitialized` to `quantity == 1`.
1114             _packedOwnerships[startTokenId] = _packOwnershipData(
1115                 to,
1116                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1117             );
1118 
1119             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1120 
1121             _currentIndex = startTokenId + quantity;
1122         }
1123         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1124     }
1125 
1126     /**
1127      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1128      */
1129     function _getApprovedAddress(uint256 tokenId)
1130         private
1131         view
1132         returns (uint256 approvedAddressSlot, address approvedAddress)
1133     {
1134         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1135         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1136         assembly {
1137             // Compute the slot.
1138             mstore(0x00, tokenId)
1139             mstore(0x20, tokenApprovalsPtr.slot)
1140             approvedAddressSlot := keccak256(0x00, 0x40)
1141             // Load the slot's value from storage.
1142             approvedAddress := sload(approvedAddressSlot)
1143         }
1144     }
1145 
1146     /**
1147      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1148      */
1149     function _isOwnerOrApproved(
1150         address approvedAddress,
1151         address from,
1152         address msgSender
1153     ) private pure returns (bool result) {
1154         assembly {
1155             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1156             from := and(from, BITMASK_ADDRESS)
1157             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1158             msgSender := and(msgSender, BITMASK_ADDRESS)
1159             // `msgSender == from || msgSender == approvedAddress`.
1160             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1161         }
1162     }
1163 
1164     /**
1165      * @dev Transfers `tokenId` from `from` to `to`.
1166      *
1167      * Requirements:
1168      *
1169      * - `to` cannot be the zero address.
1170      * - `tokenId` token must be owned by `from`.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function transferFrom(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) public virtual override {
1179         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1180 
1181         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1182 
1183         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1184 
1185         // The nested ifs save around 20+ gas over a compound boolean condition.
1186         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1187             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1188 
1189         if (to == address(0)) revert TransferToZeroAddress();
1190 
1191         _beforeTokenTransfers(from, to, tokenId, 1);
1192 
1193         // Clear approvals from the previous owner.
1194         assembly {
1195             if approvedAddress {
1196                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1197                 sstore(approvedAddressSlot, 0)
1198             }
1199         }
1200 
1201         // Underflow of the sender's balance is impossible because we check for
1202         // ownership above and the recipient's balance can't realistically overflow.
1203         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1204         unchecked {
1205             // We can directly increment and decrement the balances.
1206             --_packedAddressData[from]; // Updates: `balance -= 1`.
1207             ++_packedAddressData[to]; // Updates: `balance += 1`.
1208 
1209             // Updates:
1210             // - `address` to the next owner.
1211             // - `startTimestamp` to the timestamp of transfering.
1212             // - `burned` to `false`.
1213             // - `nextInitialized` to `true`.
1214             _packedOwnerships[tokenId] = _packOwnershipData(
1215                 to,
1216                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1217             );
1218 
1219             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1220             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1221                 uint256 nextTokenId = tokenId + 1;
1222                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1223                 if (_packedOwnerships[nextTokenId] == 0) {
1224                     // If the next slot is within bounds.
1225                     if (nextTokenId != _currentIndex) {
1226                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1227                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1228                     }
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(from, to, tokenId);
1234         _afterTokenTransfers(from, to, tokenId, 1);
1235     }
1236 
1237     /**
1238      * @dev Equivalent to `_burn(tokenId, false)`.
1239      */
1240     function _burn(uint256 tokenId) internal virtual {
1241         _burn(tokenId, false);
1242     }
1243 
1244     /**
1245      * @dev Destroys `tokenId`.
1246      * The approval is cleared when the token is burned.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1255         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1256 
1257         address from = address(uint160(prevOwnershipPacked));
1258 
1259         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1260 
1261         if (approvalCheck) {
1262             // The nested ifs save around 20+ gas over a compound boolean condition.
1263             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1264                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1265         }
1266 
1267         _beforeTokenTransfers(from, address(0), tokenId, 1);
1268 
1269         // Clear approvals from the previous owner.
1270         assembly {
1271             if approvedAddress {
1272                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1273                 sstore(approvedAddressSlot, 0)
1274             }
1275         }
1276 
1277         // Underflow of the sender's balance is impossible because we check for
1278         // ownership above and the recipient's balance can't realistically overflow.
1279         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1280         unchecked {
1281             // Updates:
1282             // - `balance -= 1`.
1283             // - `numberBurned += 1`.
1284             //
1285             // We can directly decrement the balance, and increment the number burned.
1286             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1287             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1288 
1289             // Updates:
1290             // - `address` to the last owner.
1291             // - `startTimestamp` to the timestamp of burning.
1292             // - `burned` to `true`.
1293             // - `nextInitialized` to `true`.
1294             _packedOwnerships[tokenId] = _packOwnershipData(
1295                 from,
1296                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1297             );
1298 
1299             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1300             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1301                 uint256 nextTokenId = tokenId + 1;
1302                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1303                 if (_packedOwnerships[nextTokenId] == 0) {
1304                     // If the next slot is within bounds.
1305                     if (nextTokenId != _currentIndex) {
1306                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1307                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1308                     }
1309                 }
1310             }
1311         }
1312 
1313         emit Transfer(from, address(0), tokenId);
1314         _afterTokenTransfers(from, address(0), tokenId, 1);
1315 
1316         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1317         unchecked {
1318             _burnCounter++;
1319         }
1320     }
1321 
1322     /**
1323      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1324      *
1325      * @param from address representing the previous owner of the given token ID
1326      * @param to target address that will receive the tokens
1327      * @param tokenId uint256 ID of the token to be transferred
1328      * @param _data bytes optional data to send along with the call
1329      * @return bool whether the call correctly returned the expected magic value
1330      */
1331     function _checkContractOnERC721Received(
1332         address from,
1333         address to,
1334         uint256 tokenId,
1335         bytes memory _data
1336     ) private returns (bool) {
1337         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1338             bytes4 retval
1339         ) {
1340             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1341         } catch (bytes memory reason) {
1342             if (reason.length == 0) {
1343                 revert TransferToNonERC721ReceiverImplementer();
1344             } else {
1345                 assembly {
1346                     revert(add(32, reason), mload(reason))
1347                 }
1348             }
1349         }
1350     }
1351 
1352     /**
1353      * @dev Directly sets the extra data for the ownership data `index`.
1354      */
1355     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1356         uint256 packed = _packedOwnerships[index];
1357         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1358         uint256 extraDataCasted;
1359         // Cast `extraData` with assembly to avoid redundant masking.
1360         assembly {
1361             extraDataCasted := extraData
1362         }
1363         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1364         _packedOwnerships[index] = packed;
1365     }
1366 
1367     /**
1368      * @dev Returns the next extra data for the packed ownership data.
1369      * The returned result is shifted into position.
1370      */
1371     function _nextExtraData(
1372         address from,
1373         address to,
1374         uint256 prevOwnershipPacked
1375     ) private view returns (uint256) {
1376         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1377         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1378     }
1379 
1380     /**
1381      * @dev Called during each token transfer to set the 24bit `extraData` field.
1382      * Intended to be overridden by the cosumer contract.
1383      *
1384      * `previousExtraData` - the value of `extraData` before transfer.
1385      *
1386      * Calling conditions:
1387      *
1388      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1389      * transferred to `to`.
1390      * - When `from` is zero, `tokenId` will be minted for `to`.
1391      * - When `to` is zero, `tokenId` will be burned by `from`.
1392      * - `from` and `to` are never both zero.
1393      */
1394     function _extraData(
1395         address from,
1396         address to,
1397         uint24 previousExtraData
1398     ) internal view virtual returns (uint24) {}
1399 
1400     /**
1401      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1402      * This includes minting.
1403      * And also called before burning one token.
1404      *
1405      * startTokenId - the first token id to be transferred
1406      * quantity - the amount to be transferred
1407      *
1408      * Calling conditions:
1409      *
1410      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1411      * transferred to `to`.
1412      * - When `from` is zero, `tokenId` will be minted for `to`.
1413      * - When `to` is zero, `tokenId` will be burned by `from`.
1414      * - `from` and `to` are never both zero.
1415      */
1416     function _beforeTokenTransfers(
1417         address from,
1418         address to,
1419         uint256 startTokenId,
1420         uint256 quantity
1421     ) internal virtual {}
1422 
1423     /**
1424      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1425      * This includes minting.
1426      * And also called after one token has been burned.
1427      *
1428      * startTokenId - the first token id to be transferred
1429      * quantity - the amount to be transferred
1430      *
1431      * Calling conditions:
1432      *
1433      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1434      * transferred to `to`.
1435      * - When `from` is zero, `tokenId` has been minted for `to`.
1436      * - When `to` is zero, `tokenId` has been burned by `from`.
1437      * - `from` and `to` are never both zero.
1438      */
1439     function _afterTokenTransfers(
1440         address from,
1441         address to,
1442         uint256 startTokenId,
1443         uint256 quantity
1444     ) internal virtual {}
1445 
1446     /**
1447      * @dev Returns the message sender (defaults to `msg.sender`).
1448      *
1449      * If you are writing GSN compatible contracts, you need to override this function.
1450      */
1451     function _msgSenderERC721A() internal view virtual returns (address) {
1452         return msg.sender;
1453     }
1454 
1455     /**
1456      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1457      */
1458     function _toString(uint256 value) internal pure returns (string memory ptr) {
1459         assembly {
1460             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1461             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1462             // We will need 1 32-byte word to store the length,
1463             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1464             ptr := add(mload(0x40), 128)
1465             // Update the free memory pointer to allocate.
1466             mstore(0x40, ptr)
1467 
1468             // Cache the end of the memory to calculate the length later.
1469             let end := ptr
1470 
1471             // We write the string from the rightmost digit to the leftmost digit.
1472             // The following is essentially a do-while loop that also handles the zero case.
1473             // Costs a bit more than early returning for the zero case,
1474             // but cheaper in terms of deployment and overall runtime costs.
1475             for {
1476                 // Initialize and perform the first pass without check.
1477                 let temp := value
1478                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1479                 ptr := sub(ptr, 1)
1480                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1481                 mstore8(ptr, add(48, mod(temp, 10)))
1482                 temp := div(temp, 10)
1483             } temp {
1484                 // Keep dividing `temp` until zero.
1485                 temp := div(temp, 10)
1486             } {
1487                 // Body of the for loop.
1488                 ptr := sub(ptr, 1)
1489                 mstore8(ptr, add(48, mod(temp, 10)))
1490             }
1491 
1492             let length := sub(end, ptr)
1493             // Move the pointer 32 bytes leftwards to make room for the length.
1494             ptr := sub(ptr, 32)
1495             // Store the length.
1496             mstore(ptr, length)
1497         }
1498     }
1499 }
1500 
1501 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1502 
1503 
1504 // ERC721A Contracts v4.1.0
1505 // Creator: Chiru Labs
1506 
1507 pragma solidity ^0.8.4;
1508 
1509 
1510 /**
1511  * @dev Interface of an ERC721AQueryable compliant contract.
1512  */
1513 interface IERC721AQueryable is IERC721A {
1514     /**
1515      * Invalid query range (`start` >= `stop`).
1516      */
1517     error InvalidQueryRange();
1518 
1519     /**
1520      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1521      *
1522      * If the `tokenId` is out of bounds:
1523      *   - `addr` = `address(0)`
1524      *   - `startTimestamp` = `0`
1525      *   - `burned` = `false`
1526      *
1527      * If the `tokenId` is burned:
1528      *   - `addr` = `<Address of owner before token was burned>`
1529      *   - `startTimestamp` = `<Timestamp when token was burned>`
1530      *   - `burned = `true`
1531      *
1532      * Otherwise:
1533      *   - `addr` = `<Address of owner>`
1534      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1535      *   - `burned = `false`
1536      */
1537     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1538 
1539     /**
1540      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1541      * See {ERC721AQueryable-explicitOwnershipOf}
1542      */
1543     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1544 
1545     /**
1546      * @dev Returns an array of token IDs owned by `owner`,
1547      * in the range [`start`, `stop`)
1548      * (i.e. `start <= tokenId < stop`).
1549      *
1550      * This function allows for tokens to be queried if the collection
1551      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1552      *
1553      * Requirements:
1554      *
1555      * - `start` < `stop`
1556      */
1557     function tokensOfOwnerIn(
1558         address owner,
1559         uint256 start,
1560         uint256 stop
1561     ) external view returns (uint256[] memory);
1562 
1563     /**
1564      * @dev Returns an array of token IDs owned by `owner`.
1565      *
1566      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1567      * It is meant to be called off-chain.
1568      *
1569      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1570      * multiple smaller scans if the collection is large enough to cause
1571      * an out-of-gas error (10K pfp collections should be fine).
1572      */
1573     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1574 }
1575 
1576 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1577 
1578 
1579 // ERC721A Contracts v4.1.0
1580 // Creator: Chiru Labs
1581 
1582 pragma solidity ^0.8.4;
1583 
1584 
1585 
1586 /**
1587  * @title ERC721A Queryable
1588  * @dev ERC721A subclass with convenience query functions.
1589  */
1590 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1591     /**
1592      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1593      *
1594      * If the `tokenId` is out of bounds:
1595      *   - `addr` = `address(0)`
1596      *   - `startTimestamp` = `0`
1597      *   - `burned` = `false`
1598      *   - `extraData` = `0`
1599      *
1600      * If the `tokenId` is burned:
1601      *   - `addr` = `<Address of owner before token was burned>`
1602      *   - `startTimestamp` = `<Timestamp when token was burned>`
1603      *   - `burned = `true`
1604      *   - `extraData` = `<Extra data when token was burned>`
1605      *
1606      * Otherwise:
1607      *   - `addr` = `<Address of owner>`
1608      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1609      *   - `burned = `false`
1610      *   - `extraData` = `<Extra data at start of ownership>`
1611      */
1612     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1613         TokenOwnership memory ownership;
1614         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1615             return ownership;
1616         }
1617         ownership = _ownershipAt(tokenId);
1618         if (ownership.burned) {
1619             return ownership;
1620         }
1621         return _ownershipOf(tokenId);
1622     }
1623 
1624     /**
1625      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1626      * See {ERC721AQueryable-explicitOwnershipOf}
1627      */
1628     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1629         unchecked {
1630             uint256 tokenIdsLength = tokenIds.length;
1631             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1632             for (uint256 i; i != tokenIdsLength; ++i) {
1633                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1634             }
1635             return ownerships;
1636         }
1637     }
1638 
1639     /**
1640      * @dev Returns an array of token IDs owned by `owner`,
1641      * in the range [`start`, `stop`)
1642      * (i.e. `start <= tokenId < stop`).
1643      *
1644      * This function allows for tokens to be queried if the collection
1645      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1646      *
1647      * Requirements:
1648      *
1649      * - `start` < `stop`
1650      */
1651     function tokensOfOwnerIn(
1652         address owner,
1653         uint256 start,
1654         uint256 stop
1655     ) external view override returns (uint256[] memory) {
1656         unchecked {
1657             if (start >= stop) revert InvalidQueryRange();
1658             uint256 tokenIdsIdx;
1659             uint256 stopLimit = _nextTokenId();
1660             // Set `start = max(start, _startTokenId())`.
1661             if (start < _startTokenId()) {
1662                 start = _startTokenId();
1663             }
1664             // Set `stop = min(stop, stopLimit)`.
1665             if (stop > stopLimit) {
1666                 stop = stopLimit;
1667             }
1668             uint256 tokenIdsMaxLength = balanceOf(owner);
1669             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1670             // to cater for cases where `balanceOf(owner)` is too big.
1671             if (start < stop) {
1672                 uint256 rangeLength = stop - start;
1673                 if (rangeLength < tokenIdsMaxLength) {
1674                     tokenIdsMaxLength = rangeLength;
1675                 }
1676             } else {
1677                 tokenIdsMaxLength = 0;
1678             }
1679             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1680             if (tokenIdsMaxLength == 0) {
1681                 return tokenIds;
1682             }
1683             // We need to call `explicitOwnershipOf(start)`,
1684             // because the slot at `start` may not be initialized.
1685             TokenOwnership memory ownership = explicitOwnershipOf(start);
1686             address currOwnershipAddr;
1687             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1688             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1689             if (!ownership.burned) {
1690                 currOwnershipAddr = ownership.addr;
1691             }
1692             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1693                 ownership = _ownershipAt(i);
1694                 if (ownership.burned) {
1695                     continue;
1696                 }
1697                 if (ownership.addr != address(0)) {
1698                     currOwnershipAddr = ownership.addr;
1699                 }
1700                 if (currOwnershipAddr == owner) {
1701                     tokenIds[tokenIdsIdx++] = i;
1702                 }
1703             }
1704             // Downsize the array to fit.
1705             assembly {
1706                 mstore(tokenIds, tokenIdsIdx)
1707             }
1708             return tokenIds;
1709         }
1710     }
1711 
1712     /**
1713      * @dev Returns an array of token IDs owned by `owner`.
1714      *
1715      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1716      * It is meant to be called off-chain.
1717      *
1718      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1719      * multiple smaller scans if the collection is large enough to cause
1720      * an out-of-gas error (10K pfp collections should be fine).
1721      */
1722     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1723         unchecked {
1724             uint256 tokenIdsIdx;
1725             address currOwnershipAddr;
1726             uint256 tokenIdsLength = balanceOf(owner);
1727             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1728             TokenOwnership memory ownership;
1729             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1730                 ownership = _ownershipAt(i);
1731                 if (ownership.burned) {
1732                     continue;
1733                 }
1734                 if (ownership.addr != address(0)) {
1735                     currOwnershipAddr = ownership.addr;
1736                 }
1737                 if (currOwnershipAddr == owner) {
1738                     tokenIds[tokenIdsIdx++] = i;
1739                 }
1740             }
1741             return tokenIds;
1742         }
1743     }
1744 }
1745 
1746 
1747 
1748 pragma solidity >=0.8.9 <0.9.0;
1749 
1750 contract Y00tsETH is ERC721AQueryable, Ownable, ReentrancyGuard {
1751     using Strings for uint256;
1752 
1753     uint256 public maxSupply = 4969;
1754 	uint256 public Ownermint = 5;
1755     uint256 public maxPerAddress = 20;
1756 	uint256 public maxPerTX = 5;
1757     uint256 public cost = 0.003 ether;
1758 	mapping(address => bool) public freeMinted; 
1759 
1760     bool public paused = true;
1761 
1762 	string public uriPrefix = '';
1763     string public uriSuffix = '.json';
1764 	
1765   constructor(string memory baseURI) ERC721A("Y00ts ETH", "YTSETH") {
1766       setUriPrefix(baseURI); 
1767       _safeMint(_msgSender(), Ownermint);
1768 
1769   }
1770 
1771   modifier callerIsUser() {
1772         require(tx.origin == msg.sender, "The caller is another contract");
1773         _;
1774   }
1775 
1776   function numberMinted(address owner) public view returns (uint256) {
1777         return _numberMinted(owner);
1778   }
1779 
1780   function mint(uint256 _mintAmount) public payable nonReentrant callerIsUser{
1781         require(!paused, 'The contract is paused!');
1782         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1783         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1784         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1785 	if (freeMinted[_msgSender()]){
1786         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1787   }
1788     else{
1789 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1790         freeMinted[_msgSender()] = true;
1791   }
1792 
1793     _safeMint(_msgSender(), _mintAmount);
1794   }
1795 
1796   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1797     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1798     string memory currentBaseURI = _baseURI();
1799     return bytes(currentBaseURI).length > 0
1800         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1801         : '';
1802   }
1803 
1804   function setPaused() public onlyOwner {
1805     paused = !paused;
1806   }
1807 
1808   function setCost(uint256 _cost) public onlyOwner {
1809     cost = _cost;
1810   }
1811 
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
1824   function withdraw() external onlyOwner {
1825         payable(msg.sender).transfer(address(this).balance);
1826   }
1827 
1828   function _startTokenId() internal view virtual override returns (uint256) {
1829     return 1;
1830   }
1831 
1832   function _baseURI() internal view virtual override returns (string memory) {
1833     return uriPrefix;
1834   }
1835 }