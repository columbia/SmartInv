1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-11
3 */
4 
5 /**
6      ___      .______     _______       _______.
7      /   \     |   _  \  |   ____|     /       |
8     /  ^  \    |  |_)  | |  |__       |   (----`  
9    /  /_\  \   |   ___/  |   __|       \   \  
10   /  _____  \  |  |      |  |____  .----)   |   
11  /__/     \__\ | _|      |_______| |_______/       
12 
13 */  
14 // File: @openzeppelin/contracts/utils/Strings.sol
15 
16 // SPDX-License-Identifier: MIT
17 pragma solidity ^0.8.9;
18 contract TestContract {
19 // Some logic
20 }
21 
22 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
34      */
35     function toString(uint256 value) internal pure returns (string memory) {
36         // Inspired by OraclizeAPI's implementation - MIT licence
37         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
38 
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
59      */
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
75      */
76     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
77         bytes memory buffer = new bytes(2 * length + 2);
78         buffer[0] = "0";
79         buffer[1] = "x";
80         for (uint256 i = 2 * length + 1; i > 1; --i) {
81             buffer[i] = _HEX_SYMBOLS[value & 0xf];
82             value >>= 4;
83         }
84         require(value == 0, "Strings: hex length insufficient");
85         return string(buffer);
86     }
87 }
88 
89 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Contract module that helps prevent reentrant calls to a function.
98  *
99  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
100  * available, which can be applied to functions to make sure there are no nested
101  * (reentrant) calls to them.
102  *
103  * Note that because there is a single `nonReentrant` guard, functions marked as
104  * `nonReentrant` may not call one another. This can be worked around by making
105  * those functions `private`, and then adding `external` `nonReentrant` entry
106  * points to them.
107  *
108  * TIP: If you would like to learn more about reentrancy and alternative ways
109  * to protect against it, check out our blog post
110  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
111  */
112 abstract contract ReentrancyGuard {
113     // Booleans are more expensive than uint256 or any type that takes up a full
114     // word because each write operation emits an extra SLOAD to first read the
115     // slot's contents, replace the bits taken up by the boolean, and then write
116     // back. This is the compiler's defense against contract upgrades and
117     // pointer aliasing, and it cannot be disabled.
118 
119     // The values being non-zero value makes deployment a bit more expensive,
120     // but in exchange the refund on every call to nonReentrant will be lower in
121     // amount. Since refunds are capped to a percentage of the total
122     // transaction's gas, it is best to keep them low in cases like this one, to
123     // increase the likelihood of the full refund coming into effect.
124     uint256 private constant _NOT_ENTERED = 1;
125     uint256 private constant _ENTERED = 2;
126 
127     uint256 private _status;
128 
129     constructor() {
130         _status = _NOT_ENTERED;
131     }
132 
133     /**
134      * @dev Prevents a contract from calling itself, directly or indirectly.
135      * Calling a `nonReentrant` function from another `nonReentrant`
136      * function is not supported. It is possible to prevent this from happening
137      * by making the `nonReentrant` function external, and making it call a
138      * `private` function that does the actual work.
139      */
140     modifier nonReentrant() {
141         // On the first call to nonReentrant, _notEntered will be true
142         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
143 
144         // Any calls to nonReentrant after this point will fail
145         _status = _ENTERED;
146 
147         _;
148 
149         // By storing the original value once again, a refund is triggered (see
150         // https://eips.ethereum.org/EIPS/eip-2200)
151         _status = _NOT_ENTERED;
152     }
153 }
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
185 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
215      * @dev Returns the address of the current owner.
216      */
217     function owner() public view virtual returns (address) {
218         return _owner;
219     }
220 
221     /**
222      * @dev Throws if called by any account other than the owner.
223      */
224     modifier onlyOwner() {
225         require(owner() == _msgSender(), "Ownable: caller is not the owner");
226         _;
227     }
228 
229     /**
230      * @dev Leaves the contract without owner. It will not be possible to call
231      * `onlyOwner` functions anymore. Can only be called by the current owner.
232      *
233      * NOTE: Renouncing ownership will leave the contract without an owner,
234      * thereby removing any functionality that is only available to the owner.
235      */
236     function renounceOwnership() public virtual onlyOwner {
237         _transferOwnership(address(0));
238     }
239 
240     /**
241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
242      * Can only be called by the current owner.
243      */
244     function transferOwnership(address newOwner) public virtual onlyOwner {
245         require(newOwner != address(0), "Ownable: new owner is the zero address");
246         _transferOwnership(newOwner);
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Internal function without access restriction.
252      */
253     function _transferOwnership(address newOwner) internal virtual {
254         address oldOwner = _owner;
255         _owner = newOwner;
256         emit OwnershipTransferred(oldOwner, newOwner);
257     }
258 }
259 
260 // File: erc721a/contracts/IERC721A.sol
261 
262 
263 // ERC721A Contracts v4.0.0
264 // Creator: Chiru Labs
265 
266 pragma solidity ^0.8.4;
267 
268 /**
269  * @dev Interface of an ERC721A compliant contract.
270  */
271 interface IERC721A {
272     /**
273      * The caller must own the token or be an approved operator.
274      */
275     error ApprovalCallerNotOwnerNorApproved();
276 
277     /**
278      * The token does not exist.
279      */
280     error ApprovalQueryForNonexistentToken();
281 
282     /**
283      * The caller cannot approve to their own address.
284      */
285     error ApproveToCaller();
286 
287     /**
288      * The caller cannot approve to the current owner.
289      */
290     error ApprovalToCurrentOwner();
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
337     struct TokenOwnership {
338         // The address of the owner.
339         address addr;
340         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
341         uint64 startTimestamp;
342         // Whether the token has been burned.
343         bool burned;
344     }
345 
346     /**
347      * @dev Returns the total amount of tokens stored by the contract.
348      *
349      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
350      */
351     function totalSupply() external view returns (uint256);
352 
353     // ==============================
354     //            IERC165
355     // ==============================
356 
357     /**
358      * @dev Returns true if this contract implements the interface defined by
359      * `interfaceId`. See the corresponding
360      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
361      * to learn more about how these ids are created.
362      *
363      * This function call must use less than 30 000 gas.
364      */
365     function supportsInterface(bytes4 interfaceId) external view returns (bool);
366 
367     // ==============================
368     //            IERC721
369     // ==============================
370 
371     /**
372      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
373      */
374     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
375 
376     /**
377      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
378      */
379     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
383      */
384     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
385 
386     /**
387      * @dev Returns the number of tokens in ``owner``'s account.
388      */
389     function balanceOf(address owner) external view returns (uint256 balance);
390 
391     /**
392      * @dev Returns the owner of the `tokenId` token.
393      *
394      * Requirements:
395      *
396      * - `tokenId` must exist.
397      */
398     function ownerOf(uint256 tokenId) external view returns (address owner);
399 
400     /**
401      * @dev Safely transfers `tokenId` token from `from` to `to`.
402      *
403      * Requirements:
404      *
405      * - `from` cannot be the zero address.
406      * - `to` cannot be the zero address.
407      * - `tokenId` token must exist and be owned by `from`.
408      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
409      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
410      *
411      * Emits a {Transfer} event.
412      */
413     function safeTransferFrom(
414         address from,
415         address to,
416         uint256 tokenId,
417         bytes calldata data
418     ) external;
419 
420     /**
421      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
422      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
423      *
424      * Requirements:
425      *
426      * - `from` cannot be the zero address.
427      * - `to` cannot be the zero address.
428      * - `tokenId` token must exist and be owned by `from`.
429      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
430      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
431      *
432      * Emits a {Transfer} event.
433      */
434     function safeTransferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Transfers `tokenId` token from `from` to `to`.
442      *
443      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
444      *
445      * Requirements:
446      *
447      * - `from` cannot be the zero address.
448      * - `to` cannot be the zero address.
449      * - `tokenId` token must be owned by `from`.
450      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
451      *
452      * Emits a {Transfer} event.
453      */
454     function transferFrom(
455         address from,
456         address to,
457         uint256 tokenId
458     ) external;
459 
460     /**
461      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
462      * The approval is cleared when the token is transferred.
463      *
464      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
465      *
466      * Requirements:
467      *
468      * - The caller must own the token or be an approved operator.
469      * - `tokenId` must exist.
470      *
471      * Emits an {Approval} event.
472      */
473     function approve(address to, uint256 tokenId) external;
474 
475     /**
476      * @dev Approve or remove `operator` as an operator for the caller.
477      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
478      *
479      * Requirements:
480      *
481      * - The `operator` cannot be the caller.
482      *
483      * Emits an {ApprovalForAll} event.
484      */
485     function setApprovalForAll(address operator, bool _approved) external;
486 
487     /**
488      * @dev Returns the account approved for `tokenId` token.
489      *
490      * Requirements:
491      *
492      * - `tokenId` must exist.
493      */
494     function getApproved(uint256 tokenId) external view returns (address operator);
495 
496     /**
497      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
498      *
499      * See {setApprovalForAll}
500      */
501     function isApprovedForAll(address owner, address operator) external view returns (bool);
502 
503     // ==============================
504     //        IERC721Metadata
505     // ==============================
506 
507     /**
508      * @dev Returns the token collection name.
509      */
510     function name() external view returns (string memory);
511 
512     /**
513      * @dev Returns the token collection symbol.
514      */
515     function symbol() external view returns (string memory);
516 
517     /**
518      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
519      */
520     function tokenURI(uint256 tokenId) external view returns (string memory);
521 }
522 
523 // File: erc721a/contracts/ERC721A.sol
524 
525 
526 // ERC721A Contracts v4.0.0
527 // Creator: Chiru Labs
528 
529 pragma solidity ^0.8.4;
530 
531 
532 /**
533  * @dev ERC721 token receiver interface.
534  */
535 interface ERC721A__IERC721Receiver {
536     function onERC721Received(
537         address operator,
538         address from,
539         uint256 tokenId,
540         bytes calldata data
541     ) external returns (bytes4);
542 }
543 
544 /**
545  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
546  * the Metadata extension. Built to optimize for lower gas during batch mints.
547  *
548  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
549  *
550  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
551  *
552  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
553  */
554 contract ERC721A is IERC721A {
555     // Mask of an entry in packed address data.
556     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
557 
558     // The bit position of `numberMinted` in packed address data.
559     uint256 private constant BITPOS_NUMBER_MINTED = 64;
560 
561     // The bit position of `numberBurned` in packed address data.
562     uint256 private constant BITPOS_NUMBER_BURNED = 128;
563 
564     // The bit position of `aux` in packed address data.
565     uint256 private constant BITPOS_AUX = 192;
566 
567     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
568     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
569 
570     // The bit position of `startTimestamp` in packed ownership.
571     uint256 private constant BITPOS_START_TIMESTAMP = 160;
572 
573     // The bit mask of the `burned` bit in packed ownership.
574     uint256 private constant BITMASK_BURNED = 1 << 224;
575     
576     // The bit position of the `nextInitialized` bit in packed ownership.
577     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
578 
579     // The bit mask of the `nextInitialized` bit in packed ownership.
580     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
581 
582     // The tokenId of the next token to be minted.
583     uint256 private _currentIndex;
584 
585     // The number of tokens burned.
586     uint256 private _burnCounter;
587 
588     // Token name
589     string private _name;
590 
591     // Token symbol
592     string private _symbol;
593 
594     // Mapping from token ID to ownership details
595     // An empty struct value does not necessarily mean the token is unowned.
596     // See `_packedOwnershipOf` implementation for details.
597     //
598     // Bits Layout:
599     // - [0..159]   `addr`
600     // - [160..223] `startTimestamp`
601     // - [224]      `burned`
602     // - [225]      `nextInitialized`
603     mapping(uint256 => uint256) private _packedOwnerships;
604 
605     // Mapping owner address to address data.
606     //
607     // Bits Layout:
608     // - [0..63]    `balance`
609     // - [64..127]  `numberMinted`
610     // - [128..191] `numberBurned`
611     // - [192..255] `aux`
612     mapping(address => uint256) private _packedAddressData;
613 
614     // Mapping from token ID to approved address.
615     mapping(uint256 => address) private _tokenApprovals;
616 
617     // Mapping from owner to operator approvals
618     mapping(address => mapping(address => bool)) private _operatorApprovals;
619 
620     constructor(string memory name_, string memory symbol_) {
621         _name = name_;
622         _symbol = symbol_;
623         _currentIndex = _startTokenId();
624     }
625 
626     /**
627      * @dev Returns the starting token ID. 
628      * To change the starting token ID, please override this function.
629      */
630     function _startTokenId() internal view virtual returns (uint256) {
631         return 0;
632     }
633 
634     /**
635      * @dev Returns the next token ID to be minted.
636      */
637     function _nextTokenId() internal view returns (uint256) {
638         return _currentIndex;
639     }
640 
641     /**
642      * @dev Returns the total number of tokens in existence.
643      * Burned tokens will reduce the count. 
644      * To get the total number of tokens minted, please see `_totalMinted`.
645      */
646     function totalSupply() public view override returns (uint256) {
647         // Counter underflow is impossible as _burnCounter cannot be incremented
648         // more than `_currentIndex - _startTokenId()` times.
649         unchecked {
650             return _currentIndex - _burnCounter - _startTokenId();
651         }
652     }
653 
654     /**
655      * @dev Returns the total amount of tokens minted in the contract.
656      */
657     function _totalMinted() internal view returns (uint256) {
658         // Counter underflow is impossible as _currentIndex does not decrement,
659         // and it is initialized to `_startTokenId()`
660         unchecked {
661             return _currentIndex - _startTokenId();
662         }
663     }
664 
665     /**
666      * @dev Returns the total number of tokens burned.
667      */
668     function _totalBurned() internal view returns (uint256) {
669         return _burnCounter;
670     }
671 
672     /**
673      * @dev See {IERC165-supportsInterface}.
674      */
675     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
676         // The interface IDs are constants representing the first 4 bytes of the XOR of
677         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
678         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
679         return
680             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
681             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
682             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
683     }
684 
685     /**
686      * @dev See {IERC721-balanceOf}.
687      */
688     function balanceOf(address owner) public view override returns (uint256) {
689         if (owner == address(0)) revert BalanceQueryForZeroAddress();
690         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
691     }
692 
693     /**
694      * Returns the number of tokens minted by `owner`.
695      */
696     function _numberMinted(address owner) internal view returns (uint256) {
697         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
698     }
699 
700     /**
701      * Returns the number of tokens burned by or on behalf of `owner`.
702      */
703     function _numberBurned(address owner) internal view returns (uint256) {
704         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
705     }
706 
707     /**
708      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
709      */
710     function _getAux(address owner) internal view returns (uint64) {
711         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
712     }
713 
714     /**
715      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
716      * If there are multiple variables, please pack them into a uint64.
717      */
718     function _setAux(address owner, uint64 aux) internal {
719         uint256 packed = _packedAddressData[owner];
720         uint256 auxCasted;
721         assembly { // Cast aux without masking.
722             auxCasted := aux
723         }
724         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
725         _packedAddressData[owner] = packed;
726     }
727 
728     /**
729      * Returns the packed ownership data of `tokenId`.
730      */
731     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
732         uint256 curr = tokenId;
733 
734         unchecked {
735             if (_startTokenId() <= curr)
736                 if (curr < _currentIndex) {
737                     uint256 packed = _packedOwnerships[curr];
738                     // If not burned.
739                     if (packed & BITMASK_BURNED == 0) {
740                         // Invariant:
741                         // There will always be an ownership that has an address and is not burned
742                         // before an ownership that does not have an address and is not burned.
743                         // Hence, curr will not underflow.
744                         //
745                         // We can directly compare the packed value.
746                         // If the address is zero, packed is zero.
747                         while (packed == 0) {
748                             packed = _packedOwnerships[--curr];
749                         }
750                         return packed;
751                     }
752                 }
753         }
754         revert OwnerQueryForNonexistentToken();
755     }
756 
757     /**
758      * Returns the unpacked `TokenOwnership` struct from `packed`.
759      */
760     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
761         ownership.addr = address(uint160(packed));
762         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
763         ownership.burned = packed & BITMASK_BURNED != 0;
764     }
765 
766     /**
767      * Returns the unpacked `TokenOwnership` struct at `index`.
768      */
769     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
770         return _unpackedOwnership(_packedOwnerships[index]);
771     }
772 
773     /**
774      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
775      */
776     function _initializeOwnershipAt(uint256 index) internal {
777         if (_packedOwnerships[index] == 0) {
778             _packedOwnerships[index] = _packedOwnershipOf(index);
779         }
780     }
781 
782     /**
783      * Gas spent here starts off proportional to the maximum mint batch size.
784      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
785      */
786     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
787         return _unpackedOwnership(_packedOwnershipOf(tokenId));
788     }
789 
790     /**
791      * @dev See {IERC721-ownerOf}.
792      */
793     function ownerOf(uint256 tokenId) public view override returns (address) {
794         return address(uint160(_packedOwnershipOf(tokenId)));
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-name}.
799      */
800     function name() public view virtual override returns (string memory) {
801         return _name;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-symbol}.
806      */
807     function symbol() public view virtual override returns (string memory) {
808         return _symbol;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-tokenURI}.
813      */
814     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
815         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
816 
817         string memory baseURI = _baseURI();
818         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
819     }
820 
821     /**
822      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
823      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
824      * by default, can be overriden in child contracts.
825      */
826     function _baseURI() internal view virtual returns (string memory) {
827         return '';
828     }
829 
830     /**
831      * @dev Casts the address to uint256 without masking.
832      */
833     function _addressToUint256(address value) private pure returns (uint256 result) {
834         assembly {
835             result := value
836         }
837     }
838 
839     /**
840      * @dev Casts the boolean to uint256 without branching.
841      */
842     function _boolToUint256(bool value) private pure returns (uint256 result) {
843         assembly {
844             result := value
845         }
846     }
847 
848     /**
849      * @dev See {IERC721-approve}.
850      */
851     function approve(address to, uint256 tokenId) public override {
852         address owner = address(uint160(_packedOwnershipOf(tokenId)));
853         if (to == owner) revert ApprovalToCurrentOwner();
854 
855         if (_msgSenderERC721A() != owner)
856             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
857                 revert ApprovalCallerNotOwnerNorApproved();
858             }
859 
860         _tokenApprovals[tokenId] = to;
861         emit Approval(owner, to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-getApproved}.
866      */
867     function getApproved(uint256 tokenId) public view override returns (address) {
868         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
869 
870         return _tokenApprovals[tokenId];
871     }
872 
873     /**
874      * @dev See {IERC721-setApprovalForAll}.
875      */
876     function setApprovalForAll(address operator, bool approved) public virtual override {
877         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
878 
879         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
880         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
881     }
882 
883     /**
884      * @dev See {IERC721-isApprovedForAll}.
885      */
886     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
887         return _operatorApprovals[owner][operator];
888     }
889 
890     /**
891      * @dev See {IERC721-transferFrom}.
892      */
893     function transferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         _transfer(from, to, tokenId);
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         safeTransferFrom(from, to, tokenId, '');
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) public virtual override {
921         _transfer(from, to, tokenId);
922         if (to.code.length != 0)
923             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
924                 revert TransferToNonERC721ReceiverImplementer();
925             }
926     }
927 
928     /**
929      * @dev Returns whether `tokenId` exists.
930      *
931      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
932      *
933      * Tokens start existing when they are minted (`_mint`),
934      */
935     function _exists(uint256 tokenId) internal view returns (bool) {
936         return
937             _startTokenId() <= tokenId &&
938             tokenId < _currentIndex && // If within bounds,
939             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
940     }
941 
942     /**
943      * @dev Equivalent to `_safeMint(to, quantity, '')`.
944      */
945     function _safeMint(address to, uint256 quantity) internal {
946         _safeMint(to, quantity, '');
947     }
948 
949     /**
950      * @dev Safely mints `quantity` tokens and transfers them to `to`.
951      *
952      * Requirements:
953      *
954      * - If `to` refers to a smart contract, it must implement
955      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
956      * - `quantity` must be greater than 0.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _safeMint(
961         address to,
962         uint256 quantity,
963         bytes memory _data
964     ) internal {
965         uint256 startTokenId = _currentIndex;
966         if (to == address(0)) revert MintToZeroAddress();
967         if (quantity == 0) revert MintZeroQuantity();
968 
969         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
970 
971         // Overflows are incredibly unrealistic.
972         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
973         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
974         unchecked {
975             // Updates:
976             // - `balance += quantity`.
977             // - `numberMinted += quantity`.
978             //
979             // We can directly add to the balance and number minted.
980             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
981 
982             // Updates:
983             // - `address` to the owner.
984             // - `startTimestamp` to the timestamp of minting.
985             // - `burned` to `false`.
986             // - `nextInitialized` to `quantity == 1`.
987             _packedOwnerships[startTokenId] =
988                 _addressToUint256(to) |
989                 (block.timestamp << BITPOS_START_TIMESTAMP) |
990                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
991 
992             uint256 updatedIndex = startTokenId;
993             uint256 end = updatedIndex + quantity;
994 
995             if (to.code.length != 0) {
996                 do {
997                     emit Transfer(address(0), to, updatedIndex);
998                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
999                         revert TransferToNonERC721ReceiverImplementer();
1000                     }
1001                 } while (updatedIndex < end);
1002                 // Reentrancy protection
1003                 if (_currentIndex != startTokenId) revert();
1004             } else {
1005                 do {
1006                     emit Transfer(address(0), to, updatedIndex++);
1007                 } while (updatedIndex < end);
1008             }
1009             _currentIndex = updatedIndex;
1010         }
1011         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1012     }
1013 
1014     /**
1015      * @dev Mints `quantity` tokens and transfers them to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `quantity` must be greater than 0.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _mint(address to, uint256 quantity) internal {
1025         uint256 startTokenId = _currentIndex;
1026         if (to == address(0)) revert MintToZeroAddress();
1027         if (quantity == 0) revert MintZeroQuantity();
1028 
1029         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1030 
1031         // Overflows are incredibly unrealistic.
1032         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1033         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1034         unchecked {
1035             // Updates:
1036             // - `balance += quantity`.
1037             // - `numberMinted += quantity`.
1038             //
1039             // We can directly add to the balance and number minted.
1040             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1041 
1042             // Updates:
1043             // - `address` to the owner.
1044             // - `startTimestamp` to the timestamp of minting.
1045             // - `burned` to `false`.
1046             // - `nextInitialized` to `quantity == 1`.
1047             _packedOwnerships[startTokenId] =
1048                 _addressToUint256(to) |
1049                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1050                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1051 
1052             uint256 updatedIndex = startTokenId;
1053             uint256 end = updatedIndex + quantity;
1054 
1055             do {
1056                 emit Transfer(address(0), to, updatedIndex++);
1057             } while (updatedIndex < end);
1058 
1059             _currentIndex = updatedIndex;
1060         }
1061         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1062     }
1063 
1064     /**
1065      * @dev Transfers `tokenId` from `from` to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `to` cannot be the zero address.
1070      * - `tokenId` token must be owned by `from`.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _transfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) private {
1079         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1080 
1081         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1082 
1083         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1084             isApprovedForAll(from, _msgSenderERC721A()) ||
1085             getApproved(tokenId) == _msgSenderERC721A());
1086 
1087         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1088         if (to == address(0)) revert TransferToZeroAddress();
1089 
1090         _beforeTokenTransfers(from, to, tokenId, 1);
1091 
1092         // Clear approvals from the previous owner.
1093         delete _tokenApprovals[tokenId];
1094 
1095         // Underflow of the sender's balance is impossible because we check for
1096         // ownership above and the recipient's balance can't realistically overflow.
1097         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1098         unchecked {
1099             // We can directly increment and decrement the balances.
1100             --_packedAddressData[from]; // Updates: `balance -= 1`.
1101             ++_packedAddressData[to]; // Updates: `balance += 1`.
1102 
1103             // Updates:
1104             // - `address` to the next owner.
1105             // - `startTimestamp` to the timestamp of transfering.
1106             // - `burned` to `false`.
1107             // - `nextInitialized` to `true`.
1108             _packedOwnerships[tokenId] =
1109                 _addressToUint256(to) |
1110                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1111                 BITMASK_NEXT_INITIALIZED;
1112 
1113             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1114             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1115                 uint256 nextTokenId = tokenId + 1;
1116                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1117                 if (_packedOwnerships[nextTokenId] == 0) {
1118                     // If the next slot is within bounds.
1119                     if (nextTokenId != _currentIndex) {
1120                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1121                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1122                     }
1123                 }
1124             }
1125         }
1126 
1127         emit Transfer(from, to, tokenId);
1128         _afterTokenTransfers(from, to, tokenId, 1);
1129     }
1130 
1131     /**
1132      * @dev Equivalent to `_burn(tokenId, false)`.
1133      */
1134     function _burn(uint256 tokenId) internal virtual {
1135         _burn(tokenId, false);
1136     }
1137 
1138     /**
1139      * @dev Destroys `tokenId`.
1140      * The approval is cleared when the token is burned.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must exist.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1149         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1150 
1151         address from = address(uint160(prevOwnershipPacked));
1152 
1153         if (approvalCheck) {
1154             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1155                 isApprovedForAll(from, _msgSenderERC721A()) ||
1156                 getApproved(tokenId) == _msgSenderERC721A());
1157 
1158             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1159         }
1160 
1161         _beforeTokenTransfers(from, address(0), tokenId, 1);
1162 
1163         // Clear approvals from the previous owner.
1164         delete _tokenApprovals[tokenId];
1165 
1166         // Underflow of the sender's balance is impossible because we check for
1167         // ownership above and the recipient's balance can't realistically overflow.
1168         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1169         unchecked {
1170             // Updates:
1171             // - `balance -= 1`.
1172             // - `numberBurned += 1`.
1173             //
1174             // We can directly decrement the balance, and increment the number burned.
1175             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1176             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1177 
1178             // Updates:
1179             // - `address` to the last owner.
1180             // - `startTimestamp` to the timestamp of burning.
1181             // - `burned` to `true`.
1182             // - `nextInitialized` to `true`.
1183             _packedOwnerships[tokenId] =
1184                 _addressToUint256(from) |
1185                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1186                 BITMASK_BURNED | 
1187                 BITMASK_NEXT_INITIALIZED;
1188 
1189             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1190             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1191                 uint256 nextTokenId = tokenId + 1;
1192                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1193                 if (_packedOwnerships[nextTokenId] == 0) {
1194                     // If the next slot is within bounds.
1195                     if (nextTokenId != _currentIndex) {
1196                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1197                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1198                     }
1199                 }
1200             }
1201         }
1202 
1203         emit Transfer(from, address(0), tokenId);
1204         _afterTokenTransfers(from, address(0), tokenId, 1);
1205 
1206         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1207         unchecked {
1208             _burnCounter++;
1209         }
1210     }
1211 
1212     /**
1213      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1214      *
1215      * @param from address representing the previous owner of the given token ID
1216      * @param to target address that will receive the tokens
1217      * @param tokenId uint256 ID of the token to be transferred
1218      * @param _data bytes optional data to send along with the call
1219      * @return bool whether the call correctly returned the expected magic value
1220      */
1221     function _checkContractOnERC721Received(
1222         address from,
1223         address to,
1224         uint256 tokenId,
1225         bytes memory _data
1226     ) private returns (bool) {
1227         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1228             bytes4 retval
1229         ) {
1230             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1231         } catch (bytes memory reason) {
1232             if (reason.length == 0) {
1233                 revert TransferToNonERC721ReceiverImplementer();
1234             } else {
1235                 assembly {
1236                     revert(add(32, reason), mload(reason))
1237                 }
1238             }
1239         }
1240     }
1241 
1242     /**
1243      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1244      * And also called before burning one token.
1245      *
1246      * startTokenId - the first token id to be transferred
1247      * quantity - the amount to be transferred
1248      *
1249      * Calling conditions:
1250      *
1251      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1252      * transferred to `to`.
1253      * - When `from` is zero, `tokenId` will be minted for `to`.
1254      * - When `to` is zero, `tokenId` will be burned by `from`.
1255      * - `from` and `to` are never both zero.
1256      */
1257     function _beforeTokenTransfers(
1258         address from,
1259         address to,
1260         uint256 startTokenId,
1261         uint256 quantity
1262     ) internal virtual {}
1263 
1264     /**
1265      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1266      * minting.
1267      * And also called after one token has been burned.
1268      *
1269      * startTokenId - the first token id to be transferred
1270      * quantity - the amount to be transferred
1271      *
1272      * Calling conditions:
1273      *
1274      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1275      * transferred to `to`.
1276      * - When `from` is zero, `tokenId` has been minted for `to`.
1277      * - When `to` is zero, `tokenId` has been burned by `from`.
1278      * - `from` and `to` are never both zero.
1279      */
1280     function _afterTokenTransfers(
1281         address from,
1282         address to,
1283         uint256 startTokenId,
1284         uint256 quantity
1285     ) internal virtual {}
1286 
1287     /**
1288      * @dev Returns the message sender (defaults to `msg.sender`).
1289      *
1290      * If you are writing GSN compatible contracts, you need to override this function.
1291      */
1292     function _msgSenderERC721A() internal view virtual returns (address) {
1293         return msg.sender;
1294     }
1295 
1296     /**
1297      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1298      */
1299     function _toString(uint256 value) internal pure returns (string memory ptr) {
1300         assembly {
1301             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1302             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1303             // We will need 1 32-byte word to store the length, 
1304             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1305             ptr := add(mload(0x40), 128)
1306             // Update the free memory pointer to allocate.
1307             mstore(0x40, ptr)
1308 
1309             // Cache the end of the memory to calculate the length later.
1310             let end := ptr
1311 
1312             // We write the string from the rightmost digit to the leftmost digit.
1313             // The following is essentially a do-while loop that also handles the zero case.
1314             // Costs a bit more than early returning for the zero case,
1315             // but cheaper in terms of deployment and overall runtime costs.
1316             for { 
1317                 // Initialize and perform the first pass without check.
1318                 let temp := value
1319                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1320                 ptr := sub(ptr, 1)
1321                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1322                 mstore8(ptr, add(48, mod(temp, 10)))
1323                 temp := div(temp, 10)
1324             } temp { 
1325                 // Keep dividing `temp` until zero.
1326                 temp := div(temp, 10)
1327             } { // Body of the for loop.
1328                 ptr := sub(ptr, 1)
1329                 mstore8(ptr, add(48, mod(temp, 10)))
1330             }
1331             
1332             let length := sub(end, ptr)
1333             // Move the pointer 32 bytes leftwards to make room for the length.
1334             ptr := sub(ptr, 32)
1335             // Store the length.
1336             mstore(ptr, length)
1337         }
1338     }
1339 }
1340 
1341 // File: 000.sol
1342 
1343 
1344 pragma solidity ^0.8.9;
1345 
1346 
1347 
1348 
1349 
1350 contract PixelApe is ERC721A, Ownable, ReentrancyGuard { 
1351 
1352     uint256 public _maxSupply = 5410;
1353     uint256 public _mintPrice = 0.003 ether;
1354     uint256 public _maxMintPerTx = 10;
1355 
1356     uint256 public _maxFreeMintPerAddr = 2;
1357     uint256 public _maxFreeMintSupply = 2000;
1358 
1359     using Strings for uint256;
1360     string public baseURI;
1361     mapping(address => uint256) private _mintedFreeAmount;
1362 
1363     constructor(string memory initBaseURI) ERC721A("PixelApe", "PApe") {
1364         baseURI = initBaseURI;
1365     }
1366 
1367     function mint(uint256 count) external payable {
1368         uint256 cost = _mintPrice;
1369         bool isFree = ((totalSupply() + count < _maxFreeMintSupply + 1) &&
1370             (_mintedFreeAmount[msg.sender] + count <= _maxFreeMintPerAddr)) ||
1371             (msg.sender == owner());
1372 
1373         if (isFree) {
1374             cost = 0;
1375         }
1376 
1377         require(msg.value >= count * cost, "Please send the exact amount.");
1378         require(totalSupply() + count < _maxSupply + 1, "Sold out!");
1379         require(count < _maxMintPerTx + 1, "Max per TX reached.");
1380 
1381         if (isFree) {
1382             _mintedFreeAmount[msg.sender] += count;
1383         }
1384 
1385         _safeMint(msg.sender, count);
1386     }
1387 
1388     function _baseURI() internal view virtual override returns (string memory) {
1389         return baseURI;
1390     }
1391 
1392     function tokenURI(uint256 tokenId)
1393         public
1394         view
1395         virtual
1396         override
1397         returns (string memory)
1398     {
1399         require(
1400             _exists(tokenId),
1401             "ERC721Metadata: URI query for nonexistent token"
1402         );
1403         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1404     }
1405 
1406     function setBaseURI(string memory uri) public onlyOwner {
1407         baseURI = uri;
1408     }
1409 
1410     function setFreeAmount(uint256 amount) external onlyOwner {
1411         _maxFreeMintSupply = amount;
1412     }
1413 
1414     function setPrice(uint256 _newPrice) external onlyOwner {
1415         _mintPrice = _newPrice;
1416     }
1417 
1418     function withdraw() public payable onlyOwner nonReentrant {
1419         (bool success, ) = payable(msg.sender).call{
1420             value: address(this).balance
1421         }("");
1422         require(success);
1423     }
1424 }