1 // SPDX-License-Identifier: MIT
2 
3 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
4 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
5 ////////////////////////&&&&&&&&&&////////////////////////&&&&&&&&&&////////////////////////////////////////////////
6 //////////////////////&&&&&&&&&&&&&&////////////////////&&&&&&&&&&&&&&//////////////////////////////////////////////
7 //////////////////////&OOOOO&&&&&&&&////////////////////&OOOOO&&&&&&&&//////////////////////////////////////////////
8 //////////////////////&OOOOO&&&&&&&&////////////////////&OOOOO&&&&&&&&//////////////////////////////////////////////
9 //////////////////////&OOOOO&&&&&&&&////////////////////&OOOOO&&&&&&&&//////////////////////////////////////////////
10 //////////////////////&OOOOO&&&&&&&&////////////////////&OOOOO&&&&&&&&//////////////////////////////////////////////
11 //////////////////////&&&&&&&&&&&&&&////////////////////&&&&&&&&&&&&&&//////////////////////////////////////////////
12 //////////////////////&&&&&&&&&&&&&&////////////////////&&&&&&&&&&&&&&//////////////////////////////////////////////
13 //////////////////////&&&&&&&&&&&&&&////////////////////&&&&&&&&&&&&&&//////////////////////////////////////////////
14 //////////////////////&&&&&&&&&&&&&&////////////////////&&&&&&&&&&&&&&//////////////////////////////////////////////
15 ////////////////////////&&&&&&&&&&////////////////////////&&&&&&&&&&////////////////////////////////////////////////
16 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
17 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
18 
19 
20 // File: @openzeppelin/contracts/utils/Strings.sol
21 
22 
23 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 }
89 
90 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Contract module that helps prevent reentrant calls to a function.
99  *
100  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
101  * available, which can be applied to functions to make sure there are no nested
102  * (reentrant) calls to them.
103  *
104  * Note that because there is a single `nonReentrant` guard, functions marked as
105  * `nonReentrant` may not call one another. This can be worked around by making
106  * those functions `private`, and then adding `external` `nonReentrant` entry
107  * points to them.
108  *
109  * TIP: If you would like to learn more about reentrancy and alternative ways
110  * to protect against it, check out our blog post
111  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
112  */
113 abstract contract ReentrancyGuard {
114     // Booleans are more expensive than uint256 or any type that takes up a full
115     // word because each write operation emits an extra SLOAD to first read the
116     // slot's contents, replace the bits taken up by the boolean, and then write
117     // back. This is the compiler's defense against contract upgrades and
118     // pointer aliasing, and it cannot be disabled.
119 
120     // The values being non-zero value makes deployment a bit more expensive,
121     // but in exchange the refund on every call to nonReentrant will be lower in
122     // amount. Since refunds are capped to a percentage of the total
123     // transaction's gas, it is best to keep them low in cases like this one, to
124     // increase the likelihood of the full refund coming into effect.
125     uint256 private constant _NOT_ENTERED = 1;
126     uint256 private constant _ENTERED = 2;
127 
128     uint256 private _status;
129 
130     constructor() {
131         _status = _NOT_ENTERED;
132     }
133 
134     /**
135      * @dev Prevents a contract from calling itself, directly or indirectly.
136      * Calling a `nonReentrant` function from another `nonReentrant`
137      * function is not supported. It is possible to prevent this from happening
138      * by making the `nonReentrant` function external, and making it call a
139      * `private` function that does the actual work.
140      */
141     modifier nonReentrant() {
142         // On the first call to nonReentrant, _notEntered will be true
143         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
144 
145         // Any calls to nonReentrant after this point will fail
146         _status = _ENTERED;
147 
148         _;
149 
150         // By storing the original value once again, a refund is triggered (see
151         // https://eips.ethereum.org/EIPS/eip-2200)
152         _status = _NOT_ENTERED;
153     }
154 }
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
186 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
216      * @dev Returns the address of the current owner.
217      */
218     function owner() public view virtual returns (address) {
219         return _owner;
220     }
221 
222     /**
223      * @dev Throws if called by any account other than the owner.
224      */
225     modifier onlyOwner() {
226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229 
230     /**
231      * @dev Leaves the contract without owner. It will not be possible to call
232      * `onlyOwner` functions anymore. Can only be called by the current owner.
233      *
234      * NOTE: Renouncing ownership will leave the contract without an owner,
235      * thereby removing any functionality that is only available to the owner.
236      */
237     function renounceOwnership() public virtual onlyOwner {
238         _transferOwnership(address(0));
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Can only be called by the current owner.
244      */
245     function transferOwnership(address newOwner) public virtual onlyOwner {
246         require(newOwner != address(0), "Ownable: new owner is the zero address");
247         _transferOwnership(newOwner);
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Internal function without access restriction.
253      */
254     function _transferOwnership(address newOwner) internal virtual {
255         address oldOwner = _owner;
256         _owner = newOwner;
257         emit OwnershipTransferred(oldOwner, newOwner);
258     }
259 }
260 
261 // File: erc721a/contracts/IERC721A.sol
262 
263 
264 // ERC721A Contracts v4.0.0
265 // Creator: Chiru Labs
266 
267 pragma solidity ^0.8.4;
268 
269 /**
270  * @dev Interface of an ERC721A compliant contract.
271  */
272 interface IERC721A {
273     /**
274      * The caller must own the token or be an approved operator.
275      */
276     error ApprovalCallerNotOwnerNorApproved();
277 
278     /**
279      * The token does not exist.
280      */
281     error ApprovalQueryForNonexistentToken();
282 
283     /**
284      * The caller cannot approve to their own address.
285      */
286     error ApproveToCaller();
287 
288     /**
289      * The caller cannot approve to the current owner.
290      */
291     error ApprovalToCurrentOwner();
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
338     struct TokenOwnership {
339         // The address of the owner.
340         address addr;
341         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
342         uint64 startTimestamp;
343         // Whether the token has been burned.
344         bool burned;
345     }
346 
347     /**
348      * @dev Returns the total amount of tokens stored by the contract.
349      *
350      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
351      */
352     function totalSupply() external view returns (uint256);
353 
354     // ==============================
355     //            IERC165
356     // ==============================
357 
358     /**
359      * @dev Returns true if this contract implements the interface defined by
360      * `interfaceId`. See the corresponding
361      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
362      * to learn more about how these ids are created.
363      *
364      * This function call must use less than 30 000 gas.
365      */
366     function supportsInterface(bytes4 interfaceId) external view returns (bool);
367 
368     // ==============================
369     //            IERC721
370     // ==============================
371 
372     /**
373      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
376 
377     /**
378      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
379      */
380     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
381 
382     /**
383      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
384      */
385     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
386 
387     /**
388      * @dev Returns the number of tokens in ``owner``'s account.
389      */
390     function balanceOf(address owner) external view returns (uint256 balance);
391 
392     /**
393      * @dev Returns the owner of the `tokenId` token.
394      *
395      * Requirements:
396      *
397      * - `tokenId` must exist.
398      */
399     function ownerOf(uint256 tokenId) external view returns (address owner);
400 
401     /**
402      * @dev Safely transfers `tokenId` token from `from` to `to`.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must exist and be owned by `from`.
409      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
410      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
411      *
412      * Emits a {Transfer} event.
413      */
414     function safeTransferFrom(
415         address from,
416         address to,
417         uint256 tokenId,
418         bytes calldata data
419     ) external;
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Approve or remove `operator` as an operator for the caller.
478      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
479      *
480      * Requirements:
481      *
482      * - The `operator` cannot be the caller.
483      *
484      * Emits an {ApprovalForAll} event.
485      */
486     function setApprovalForAll(address operator, bool _approved) external;
487 
488     /**
489      * @dev Returns the account approved for `tokenId` token.
490      *
491      * Requirements:
492      *
493      * - `tokenId` must exist.
494      */
495     function getApproved(uint256 tokenId) external view returns (address operator);
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     // ==============================
505     //        IERC721Metadata
506     // ==============================
507 
508     /**
509      * @dev Returns the token collection name.
510      */
511     function name() external view returns (string memory);
512 
513     /**
514      * @dev Returns the token collection symbol.
515      */
516     function symbol() external view returns (string memory);
517 
518     /**
519      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
520      */
521     function tokenURI(uint256 tokenId) external view returns (string memory);
522 }
523 
524 // File: erc721a/contracts/ERC721A.sol
525 
526 
527 // ERC721A Contracts v4.0.0
528 // Creator: Chiru Labs
529 
530 pragma solidity ^0.8.4;
531 
532 
533 /**
534  * @dev ERC721 token receiver interface.
535  */
536 interface ERC721A__IERC721Receiver {
537     function onERC721Received(
538         address operator,
539         address from,
540         uint256 tokenId,
541         bytes calldata data
542     ) external returns (bytes4);
543 }
544 
545 /**
546  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
547  * the Metadata extension. Built to optimize for lower gas during batch mints.
548  *
549  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
550  *
551  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
552  *
553  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
554  */
555 contract ERC721A is IERC721A {
556     // Mask of an entry in packed address data.
557     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
558 
559     // The bit position of `numberMinted` in packed address data.
560     uint256 private constant BITPOS_NUMBER_MINTED = 64;
561 
562     // The bit position of `numberBurned` in packed address data.
563     uint256 private constant BITPOS_NUMBER_BURNED = 128;
564 
565     // The bit position of `aux` in packed address data.
566     uint256 private constant BITPOS_AUX = 192;
567 
568     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
569     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
570 
571     // The bit position of `startTimestamp` in packed ownership.
572     uint256 private constant BITPOS_START_TIMESTAMP = 160;
573 
574     // The bit mask of the `burned` bit in packed ownership.
575     uint256 private constant BITMASK_BURNED = 1 << 224;
576     
577     // The bit position of the `nextInitialized` bit in packed ownership.
578     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
579 
580     // The bit mask of the `nextInitialized` bit in packed ownership.
581     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
582 
583     // The tokenId of the next token to be minted.
584     uint256 private _currentIndex;
585 
586     // The number of tokens burned.
587     uint256 private _burnCounter;
588 
589     // Token name
590     string private _name;
591 
592     // Token symbol
593     string private _symbol;
594 
595     // Mapping from token ID to ownership details
596     // An empty struct value does not necessarily mean the token is unowned.
597     // See `_packedOwnershipOf` implementation for details.
598     //
599     // Bits Layout:
600     // - [0..159]   `addr`
601     // - [160..223] `startTimestamp`
602     // - [224]      `burned`
603     // - [225]      `nextInitialized`
604     mapping(uint256 => uint256) private _packedOwnerships;
605 
606     // Mapping owner address to address data.
607     //
608     // Bits Layout:
609     // - [0..63]    `balance`
610     // - [64..127]  `numberMinted`
611     // - [128..191] `numberBurned`
612     // - [192..255] `aux`
613     mapping(address => uint256) private _packedAddressData;
614 
615     // Mapping from token ID to approved address.
616     mapping(uint256 => address) private _tokenApprovals;
617 
618     // Mapping from owner to operator approvals
619     mapping(address => mapping(address => bool)) private _operatorApprovals;
620 
621     constructor(string memory name_, string memory symbol_) {
622         _name = name_;
623         _symbol = symbol_;
624         _currentIndex = _startTokenId();
625     }
626 
627     /**
628      * @dev Returns the starting token ID. 
629      * To change the starting token ID, please override this function.
630      */
631     function _startTokenId() internal view virtual returns (uint256) {
632         return 0;
633     }
634 
635     /**
636      * @dev Returns the next token ID to be minted.
637      */
638     function _nextTokenId() internal view returns (uint256) {
639         return _currentIndex;
640     }
641 
642     /**
643      * @dev Returns the total number of tokens in existence.
644      * Burned tokens will reduce the count. 
645      * To get the total number of tokens minted, please see `_totalMinted`.
646      */
647     function totalSupply() public view override returns (uint256) {
648         // Counter underflow is impossible as _burnCounter cannot be incremented
649         // more than `_currentIndex - _startTokenId()` times.
650         unchecked {
651             return _currentIndex - _burnCounter - _startTokenId();
652         }
653     }
654 
655     /**
656      * @dev Returns the total amount of tokens minted in the contract.
657      */
658     function _totalMinted() internal view returns (uint256) {
659         // Counter underflow is impossible as _currentIndex does not decrement,
660         // and it is initialized to `_startTokenId()`
661         unchecked {
662             return _currentIndex - _startTokenId();
663         }
664     }
665 
666     /**
667      * @dev Returns the total number of tokens burned.
668      */
669     function _totalBurned() internal view returns (uint256) {
670         return _burnCounter;
671     }
672 
673     /**
674      * @dev See {IERC165-supportsInterface}.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
677         // The interface IDs are constants representing the first 4 bytes of the XOR of
678         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
679         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
680         return
681             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
682             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
683             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
684     }
685 
686     /**
687      * @dev See {IERC721-balanceOf}.
688      */
689     function balanceOf(address owner) public view override returns (uint256) {
690         if (owner == address(0)) revert BalanceQueryForZeroAddress();
691         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
692     }
693 
694     /**
695      * Returns the number of tokens minted by `owner`.
696      */
697     function _numberMinted(address owner) internal view returns (uint256) {
698         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
699     }
700 
701     /**
702      * Returns the number of tokens burned by or on behalf of `owner`.
703      */
704     function _numberBurned(address owner) internal view returns (uint256) {
705         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
706     }
707 
708     /**
709      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
710      */
711     function _getAux(address owner) internal view returns (uint64) {
712         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
713     }
714 
715     /**
716      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
717      * If there are multiple variables, please pack them into a uint64.
718      */
719     function _setAux(address owner, uint64 aux) internal {
720         uint256 packed = _packedAddressData[owner];
721         uint256 auxCasted;
722         assembly { // Cast aux without masking.
723             auxCasted := aux
724         }
725         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
726         _packedAddressData[owner] = packed;
727     }
728 
729     /**
730      * Returns the packed ownership data of `tokenId`.
731      */
732     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
733         uint256 curr = tokenId;
734 
735         unchecked {
736             if (_startTokenId() <= curr)
737                 if (curr < _currentIndex) {
738                     uint256 packed = _packedOwnerships[curr];
739                     // If not burned.
740                     if (packed & BITMASK_BURNED == 0) {
741                         // Invariant:
742                         // There will always be an ownership that has an address and is not burned
743                         // before an ownership that does not have an address and is not burned.
744                         // Hence, curr will not underflow.
745                         //
746                         // We can directly compare the packed value.
747                         // If the address is zero, packed is zero.
748                         while (packed == 0) {
749                             packed = _packedOwnerships[--curr];
750                         }
751                         return packed;
752                     }
753                 }
754         }
755         revert OwnerQueryForNonexistentToken();
756     }
757 
758     /**
759      * Returns the unpacked `TokenOwnership` struct from `packed`.
760      */
761     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
762         ownership.addr = address(uint160(packed));
763         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
764         ownership.burned = packed & BITMASK_BURNED != 0;
765     }
766 
767     /**
768      * Returns the unpacked `TokenOwnership` struct at `index`.
769      */
770     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
771         return _unpackedOwnership(_packedOwnerships[index]);
772     }
773 
774     /**
775      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
776      */
777     function _initializeOwnershipAt(uint256 index) internal {
778         if (_packedOwnerships[index] == 0) {
779             _packedOwnerships[index] = _packedOwnershipOf(index);
780         }
781     }
782 
783     /**
784      * Gas spent here starts off proportional to the maximum mint batch size.
785      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
786      */
787     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
788         return _unpackedOwnership(_packedOwnershipOf(tokenId));
789     }
790 
791     /**
792      * @dev See {IERC721-ownerOf}.
793      */
794     function ownerOf(uint256 tokenId) public view override returns (address) {
795         return address(uint160(_packedOwnershipOf(tokenId)));
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-name}.
800      */
801     function name() public view virtual override returns (string memory) {
802         return _name;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-symbol}.
807      */
808     function symbol() public view virtual override returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-tokenURI}.
814      */
815     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
816         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
817 
818         string memory baseURI = _baseURI();
819         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
820     }
821 
822     /**
823      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
824      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
825      * by default, can be overriden in child contracts.
826      */
827     function _baseURI() internal view virtual returns (string memory) {
828         return '';
829     }
830 
831     /**
832      * @dev Casts the address to uint256 without masking.
833      */
834     function _addressToUint256(address value) private pure returns (uint256 result) {
835         assembly {
836             result := value
837         }
838     }
839 
840     /**
841      * @dev Casts the boolean to uint256 without branching.
842      */
843     function _boolToUint256(bool value) private pure returns (uint256 result) {
844         assembly {
845             result := value
846         }
847     }
848 
849     /**
850      * @dev See {IERC721-approve}.
851      */
852     function approve(address to, uint256 tokenId) public override {
853         address owner = address(uint160(_packedOwnershipOf(tokenId)));
854         if (to == owner) revert ApprovalToCurrentOwner();
855 
856         if (_msgSenderERC721A() != owner)
857             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
858                 revert ApprovalCallerNotOwnerNorApproved();
859             }
860 
861         _tokenApprovals[tokenId] = to;
862         emit Approval(owner, to, tokenId);
863     }
864 
865     /**
866      * @dev See {IERC721-getApproved}.
867      */
868     function getApproved(uint256 tokenId) public view override returns (address) {
869         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
870 
871         return _tokenApprovals[tokenId];
872     }
873 
874     /**
875      * @dev See {IERC721-setApprovalForAll}.
876      */
877     function setApprovalForAll(address operator, bool approved) public virtual override {
878         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
879 
880         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
881         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
882     }
883 
884     /**
885      * @dev See {IERC721-isApprovedForAll}.
886      */
887     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
888         return _operatorApprovals[owner][operator];
889     }
890 
891     /**
892      * @dev See {IERC721-transferFrom}.
893      */
894     function transferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public virtual override {
899         _transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-safeTransferFrom}.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override {
910         safeTransferFrom(from, to, tokenId, '');
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) public virtual override {
922         _transfer(from, to, tokenId);
923         if (to.code.length != 0)
924             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
925                 revert TransferToNonERC721ReceiverImplementer();
926             }
927     }
928 
929     /**
930      * @dev Returns whether `tokenId` exists.
931      *
932      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
933      *
934      * Tokens start existing when they are minted (`_mint`),
935      */
936     function _exists(uint256 tokenId) internal view returns (bool) {
937         return
938             _startTokenId() <= tokenId &&
939             tokenId < _currentIndex && // If within bounds,
940             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
941     }
942 
943     /**
944      * @dev Equivalent to `_safeMint(to, quantity, '')`.
945      */
946     function _safeMint(address to, uint256 quantity) internal {
947         _safeMint(to, quantity, '');
948     }
949 
950     /**
951      * @dev Safely mints `quantity` tokens and transfers them to `to`.
952      *
953      * Requirements:
954      *
955      * - If `to` refers to a smart contract, it must implement
956      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
957      * - `quantity` must be greater than 0.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _safeMint(
962         address to,
963         uint256 quantity,
964         bytes memory _data
965     ) internal {
966         uint256 startTokenId = _currentIndex;
967         if (to == address(0)) revert MintToZeroAddress();
968         if (quantity == 0) revert MintZeroQuantity();
969 
970         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
971 
972         // Overflows are incredibly unrealistic.
973         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
974         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
975         unchecked {
976             // Updates:
977             // - `balance += quantity`.
978             // - `numberMinted += quantity`.
979             //
980             // We can directly add to the balance and number minted.
981             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
982 
983             // Updates:
984             // - `address` to the owner.
985             // - `startTimestamp` to the timestamp of minting.
986             // - `burned` to `false`.
987             // - `nextInitialized` to `quantity == 1`.
988             _packedOwnerships[startTokenId] =
989                 _addressToUint256(to) |
990                 (block.timestamp << BITPOS_START_TIMESTAMP) |
991                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
992 
993             uint256 updatedIndex = startTokenId;
994             uint256 end = updatedIndex + quantity;
995 
996             if (to.code.length != 0) {
997                 do {
998                     emit Transfer(address(0), to, updatedIndex);
999                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1000                         revert TransferToNonERC721ReceiverImplementer();
1001                     }
1002                 } while (updatedIndex < end);
1003                 // Reentrancy protection
1004                 if (_currentIndex != startTokenId) revert();
1005             } else {
1006                 do {
1007                     emit Transfer(address(0), to, updatedIndex++);
1008                 } while (updatedIndex < end);
1009             }
1010             _currentIndex = updatedIndex;
1011         }
1012         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
1023      * Emits a {Transfer} event.
1024      */
1025     function _mint(address to, uint256 quantity) internal {
1026         uint256 startTokenId = _currentIndex;
1027         if (to == address(0)) revert MintToZeroAddress();
1028         if (quantity == 0) revert MintZeroQuantity();
1029 
1030         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1031 
1032         // Overflows are incredibly unrealistic.
1033         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1034         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1035         unchecked {
1036             // Updates:
1037             // - `balance += quantity`.
1038             // - `numberMinted += quantity`.
1039             //
1040             // We can directly add to the balance and number minted.
1041             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1042 
1043             // Updates:
1044             // - `address` to the owner.
1045             // - `startTimestamp` to the timestamp of minting.
1046             // - `burned` to `false`.
1047             // - `nextInitialized` to `quantity == 1`.
1048             _packedOwnerships[startTokenId] =
1049                 _addressToUint256(to) |
1050                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1051                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1052 
1053             uint256 updatedIndex = startTokenId;
1054             uint256 end = updatedIndex + quantity;
1055 
1056             do {
1057                 emit Transfer(address(0), to, updatedIndex++);
1058             } while (updatedIndex < end);
1059 
1060             _currentIndex = updatedIndex;
1061         }
1062         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1063     }
1064 
1065     /**
1066      * @dev Transfers `tokenId` from `from` to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `tokenId` token must be owned by `from`.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _transfer(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) private {
1080         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1081 
1082         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1083 
1084         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1085             isApprovedForAll(from, _msgSenderERC721A()) ||
1086             getApproved(tokenId) == _msgSenderERC721A());
1087 
1088         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1089         if (to == address(0)) revert TransferToZeroAddress();
1090 
1091         _beforeTokenTransfers(from, to, tokenId, 1);
1092 
1093         // Clear approvals from the previous owner.
1094         delete _tokenApprovals[tokenId];
1095 
1096         // Underflow of the sender's balance is impossible because we check for
1097         // ownership above and the recipient's balance can't realistically overflow.
1098         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1099         unchecked {
1100             // We can directly increment and decrement the balances.
1101             --_packedAddressData[from]; // Updates: `balance -= 1`.
1102             ++_packedAddressData[to]; // Updates: `balance += 1`.
1103 
1104             // Updates:
1105             // - `address` to the next owner.
1106             // - `startTimestamp` to the timestamp of transfering.
1107             // - `burned` to `false`.
1108             // - `nextInitialized` to `true`.
1109             _packedOwnerships[tokenId] =
1110                 _addressToUint256(to) |
1111                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1112                 BITMASK_NEXT_INITIALIZED;
1113 
1114             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1115             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1116                 uint256 nextTokenId = tokenId + 1;
1117                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1118                 if (_packedOwnerships[nextTokenId] == 0) {
1119                     // If the next slot is within bounds.
1120                     if (nextTokenId != _currentIndex) {
1121                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1122                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1123                     }
1124                 }
1125             }
1126         }
1127 
1128         emit Transfer(from, to, tokenId);
1129         _afterTokenTransfers(from, to, tokenId, 1);
1130     }
1131 
1132     /**
1133      * @dev Equivalent to `_burn(tokenId, false)`.
1134      */
1135     function _burn(uint256 tokenId) internal virtual {
1136         _burn(tokenId, false);
1137     }
1138 
1139     /**
1140      * @dev Destroys `tokenId`.
1141      * The approval is cleared when the token is burned.
1142      *
1143      * Requirements:
1144      *
1145      * - `tokenId` must exist.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1150         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1151 
1152         address from = address(uint160(prevOwnershipPacked));
1153 
1154         if (approvalCheck) {
1155             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1156                 isApprovedForAll(from, _msgSenderERC721A()) ||
1157                 getApproved(tokenId) == _msgSenderERC721A());
1158 
1159             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1160         }
1161 
1162         _beforeTokenTransfers(from, address(0), tokenId, 1);
1163 
1164         // Clear approvals from the previous owner.
1165         delete _tokenApprovals[tokenId];
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             // Updates:
1172             // - `balance -= 1`.
1173             // - `numberBurned += 1`.
1174             //
1175             // We can directly decrement the balance, and increment the number burned.
1176             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1177             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1178 
1179             // Updates:
1180             // - `address` to the last owner.
1181             // - `startTimestamp` to the timestamp of burning.
1182             // - `burned` to `true`.
1183             // - `nextInitialized` to `true`.
1184             _packedOwnerships[tokenId] =
1185                 _addressToUint256(from) |
1186                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1187                 BITMASK_BURNED | 
1188                 BITMASK_NEXT_INITIALIZED;
1189 
1190             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1191             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1192                 uint256 nextTokenId = tokenId + 1;
1193                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1194                 if (_packedOwnerships[nextTokenId] == 0) {
1195                     // If the next slot is within bounds.
1196                     if (nextTokenId != _currentIndex) {
1197                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1198                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1199                     }
1200                 }
1201             }
1202         }
1203 
1204         emit Transfer(from, address(0), tokenId);
1205         _afterTokenTransfers(from, address(0), tokenId, 1);
1206 
1207         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1208         unchecked {
1209             _burnCounter++;
1210         }
1211     }
1212 
1213     /**
1214      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1215      *
1216      * @param from address representing the previous owner of the given token ID
1217      * @param to target address that will receive the tokens
1218      * @param tokenId uint256 ID of the token to be transferred
1219      * @param _data bytes optional data to send along with the call
1220      * @return bool whether the call correctly returned the expected magic value
1221      */
1222     function _checkContractOnERC721Received(
1223         address from,
1224         address to,
1225         uint256 tokenId,
1226         bytes memory _data
1227     ) private returns (bool) {
1228         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1229             bytes4 retval
1230         ) {
1231             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1232         } catch (bytes memory reason) {
1233             if (reason.length == 0) {
1234                 revert TransferToNonERC721ReceiverImplementer();
1235             } else {
1236                 assembly {
1237                     revert(add(32, reason), mload(reason))
1238                 }
1239             }
1240         }
1241     }
1242 
1243     /**
1244      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1245      * And also called before burning one token.
1246      *
1247      * startTokenId - the first token id to be transferred
1248      * quantity - the amount to be transferred
1249      *
1250      * Calling conditions:
1251      *
1252      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1253      * transferred to `to`.
1254      * - When `from` is zero, `tokenId` will be minted for `to`.
1255      * - When `to` is zero, `tokenId` will be burned by `from`.
1256      * - `from` and `to` are never both zero.
1257      */
1258     function _beforeTokenTransfers(
1259         address from,
1260         address to,
1261         uint256 startTokenId,
1262         uint256 quantity
1263     ) internal virtual {}
1264 
1265     /**
1266      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1267      * minting.
1268      * And also called after one token has been burned.
1269      *
1270      * startTokenId - the first token id to be transferred
1271      * quantity - the amount to be transferred
1272      *
1273      * Calling conditions:
1274      *
1275      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1276      * transferred to `to`.
1277      * - When `from` is zero, `tokenId` has been minted for `to`.
1278      * - When `to` is zero, `tokenId` has been burned by `from`.
1279      * - `from` and `to` are never both zero.
1280      */
1281     function _afterTokenTransfers(
1282         address from,
1283         address to,
1284         uint256 startTokenId,
1285         uint256 quantity
1286     ) internal virtual {}
1287 
1288     /**
1289      * @dev Returns the message sender (defaults to `msg.sender`).
1290      *
1291      * If you are writing GSN compatible contracts, you need to override this function.
1292      */
1293     function _msgSenderERC721A() internal view virtual returns (address) {
1294         return msg.sender;
1295     }
1296 
1297     /**
1298      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1299      */
1300     function _toString(uint256 value) internal pure returns (string memory ptr) {
1301         assembly {
1302             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1303             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1304             // We will need 1 32-byte word to store the length, 
1305             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1306             ptr := add(mload(0x40), 128)
1307             // Update the free memory pointer to allocate.
1308             mstore(0x40, ptr)
1309 
1310             // Cache the end of the memory to calculate the length later.
1311             let end := ptr
1312 
1313             // We write the string from the rightmost digit to the leftmost digit.
1314             // The following is essentially a do-while loop that also handles the zero case.
1315             // Costs a bit more than early returning for the zero case,
1316             // but cheaper in terms of deployment and overall runtime costs.
1317             for { 
1318                 // Initialize and perform the first pass without check.
1319                 let temp := value
1320                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1321                 ptr := sub(ptr, 1)
1322                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1323                 mstore8(ptr, add(48, mod(temp, 10)))
1324                 temp := div(temp, 10)
1325             } temp { 
1326                 // Keep dividing `temp` until zero.
1327                 temp := div(temp, 10)
1328             } { // Body of the for loop.
1329                 ptr := sub(ptr, 1)
1330                 mstore8(ptr, add(48, mod(temp, 10)))
1331             }
1332             
1333             let length := sub(end, ptr)
1334             // Move the pointer 32 bytes leftwards to make room for the length.
1335             ptr := sub(ptr, 32)
1336             // Store the length.
1337             mstore(ptr, length)
1338         }
1339     }
1340 }
1341 
1342 pragma solidity ^0.8.2;
1343 
1344 contract AstralFrens is ERC721A, Ownable, ReentrancyGuard {
1345 
1346     using Strings for uint256;
1347 
1348     string public _astralUri;
1349 
1350     bool public is_dreaming = false;
1351 
1352     uint256 public astral_frens = 5555;
1353     uint256 public free_per_wallet = 1; 
1354     uint256 public per_wallet = 5;
1355     uint256 public price = 0.03 ether;
1356 
1357     mapping(address => uint256) public wallet_balance;
1358    
1359 	constructor() ERC721A("AstralFrens", "ASTRAL") {}
1360 
1361     function _baseURI() internal view virtual override returns (string memory) {
1362         return _astralUri;
1363     }
1364 
1365  	function walkInDream(uint256 frens) public payable {
1366         uint256 cost = price * frens;
1367   	    uint256 total = totalSupply();
1368         require(is_dreaming);
1369         require(frens <= per_wallet, "Cannot Mint That Many");
1370         require(wallet_balance[msg.sender] < per_wallet, "Max per Wallet Reached");
1371         require(total + frens <= astral_frens);
1372 
1373         if(wallet_balance[msg.sender] < free_per_wallet) {
1374                 uint256 quantity = frens - free_per_wallet;
1375                 cost = price * quantity;
1376         }
1377 
1378         require(msg.value >= cost, "Not enough supply.");
1379 
1380         _safeMint(msg.sender, frens);
1381         wallet_balance[msg.sender] += frens;
1382     }
1383 
1384     //Functions for Lucid Dreaming Gurus
1385 
1386     function startDreaming(bool _state) external onlyOwner {
1387         is_dreaming = _state;
1388     }
1389 
1390     function setFreeFrens(uint256 _freeFrens) external onlyOwner {
1391         free_per_wallet = _freeFrens;
1392     }
1393 
1394     function setPerWallet(uint256 _maxPerWallet) external onlyOwner {
1395         per_wallet = _maxPerWallet;
1396     }
1397 
1398     function setAstralUri(string memory uri) external onlyOwner {
1399         _astralUri = uri;
1400     }
1401 
1402  	function makeFrenWalkInDream(address astral_fren, uint256 _frens) public onlyOwner {
1403   	    uint256 total = totalSupply();
1404 	    require(total + _frens <= astral_frens);
1405         _safeMint(astral_fren, _frens);
1406     }
1407 
1408     function wakeUp(uint256 _amount) public onlyOwner {
1409         uint256 balance = address(this).balance;
1410         require(_amount <= balance);
1411         payable(msg.sender).transfer(_amount);
1412     }
1413 }