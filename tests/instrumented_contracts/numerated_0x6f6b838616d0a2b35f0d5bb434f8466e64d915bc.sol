1 // SPDX-License-Identifier: MIT
2 
3 /*
4        __    ___  _  _  ____  
5       /__\  / __)( \( )(  _ \ 
6      /(__)\( (_-. )  (  )(_) )
7     (__)(__)\___/(_)\_)(____/ 
8 
9 */
10 
11 // File: @openzeppelin/contracts/utils/Strings.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev String operations.
20  */
21 library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
51      */
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
67      */
68     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
69         bytes memory buffer = new bytes(2 * length + 2);
70         buffer[0] = "0";
71         buffer[1] = "x";
72         for (uint256 i = 2 * length + 1; i > 1; --i) {
73             buffer[i] = _HEX_SYMBOLS[value & 0xf];
74             value >>= 4;
75         }
76         require(value == 0, "Strings: hex length insufficient");
77         return string(buffer);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Contract module that helps prevent reentrant calls to a function.
90  *
91  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
92  * available, which can be applied to functions to make sure there are no nested
93  * (reentrant) calls to them.
94  *
95  * Note that because there is a single `nonReentrant` guard, functions marked as
96  * `nonReentrant` may not call one another. This can be worked around by making
97  * those functions `private`, and then adding `external` `nonReentrant` entry
98  * points to them.
99  *
100  * TIP: If you would like to learn more about reentrancy and alternative ways
101  * to protect against it, check out our blog post
102  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
103  */
104 abstract contract ReentrancyGuard {
105     // Booleans are more expensive than uint256 or any type that takes up a full
106     // word because each write operation emits an extra SLOAD to first read the
107     // slot's contents, replace the bits taken up by the boolean, and then write
108     // back. This is the compiler's defense against contract upgrades and
109     // pointer aliasing, and it cannot be disabled.
110 
111     // The values being non-zero value makes deployment a bit more expensive,
112     // but in exchange the refund on every call to nonReentrant will be lower in
113     // amount. Since refunds are capped to a percentage of the total
114     // transaction's gas, it is best to keep them low in cases like this one, to
115     // increase the likelihood of the full refund coming into effect.
116     uint256 private constant _NOT_ENTERED = 1;
117     uint256 private constant _ENTERED = 2;
118 
119     uint256 private _status;
120 
121     constructor() {
122         _status = _NOT_ENTERED;
123     }
124 
125     /**
126      * @dev Prevents a contract from calling itself, directly or indirectly.
127      * Calling a `nonReentrant` function from another `nonReentrant`
128      * function is not supported. It is possible to prevent this from happening
129      * by making the `nonReentrant` function external, and making it call a
130      * `private` function that does the actual work.
131      */
132     modifier nonReentrant() {
133         // On the first call to nonReentrant, _notEntered will be true
134         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
135 
136         // Any calls to nonReentrant after this point will fail
137         _status = _ENTERED;
138 
139         _;
140 
141         // By storing the original value once again, a refund is triggered (see
142         // https://eips.ethereum.org/EIPS/eip-2200)
143         _status = _NOT_ENTERED;
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Context.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Provides information about the current execution context, including the
156  * sender of the transaction and its data. While these are generally available
157  * via msg.sender and msg.data, they should not be accessed in such a direct
158  * manner, since when dealing with meta-transactions the account sending and
159  * paying for execution may not be the actual sender (as far as an application
160  * is concerned).
161  *
162  * This contract is only required for intermediate, library-like contracts.
163  */
164 abstract contract Context {
165     function _msgSender() internal view virtual returns (address) {
166         return msg.sender;
167     }
168 
169     function _msgData() internal view virtual returns (bytes calldata) {
170         return msg.data;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/access/Ownable.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @dev Contract module which provides a basic access control mechanism, where
184  * there is an account (an owner) that can be granted exclusive access to
185  * specific functions.
186  *
187  * By default, the owner account will be the one that deploys the contract. This
188  * can later be changed with {transferOwnership}.
189  *
190  * This module is used through inheritance. It will make available the modifier
191  * `onlyOwner`, which can be applied to your functions to restrict their use to
192  * the owner.
193  */
194 abstract contract Ownable is Context {
195     address private _owner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor() {
203         _transferOwnership(_msgSender());
204     }
205 
206     /**
207      * @dev Returns the address of the current owner.
208      */
209     function owner() public view virtual returns (address) {
210         return _owner;
211     }
212 
213     /**
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         require(owner() == _msgSender(), "Ownable: caller is not the owner");
218         _;
219     }
220 
221     /**
222      * @dev Leaves the contract without owner. It will not be possible to call
223      * `onlyOwner` functions anymore. Can only be called by the current owner.
224      *
225      * NOTE: Renouncing ownership will leave the contract without an owner,
226      * thereby removing any functionality that is only available to the owner.
227      */
228     function renounceOwnership() public virtual onlyOwner {
229         _transferOwnership(address(0));
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Can only be called by the current owner.
235      */
236     function transferOwnership(address newOwner) public virtual onlyOwner {
237         require(newOwner != address(0), "Ownable: new owner is the zero address");
238         _transferOwnership(newOwner);
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Internal function without access restriction.
244      */
245     function _transferOwnership(address newOwner) internal virtual {
246         address oldOwner = _owner;
247         _owner = newOwner;
248         emit OwnershipTransferred(oldOwner, newOwner);
249     }
250 }
251 
252 // File: erc721a/contracts/IERC721A.sol
253 
254 
255 // ERC721A Contracts v4.0.0
256 // Creator: Chiru Labs
257 
258 pragma solidity ^0.8.4;
259 
260 /**
261  * @dev Interface of an ERC721A compliant contract.
262  */
263 interface IERC721A {
264     /**
265      * The caller must own the token or be an approved operator.
266      */
267     error ApprovalCallerNotOwnerNorApproved();
268 
269     /**
270      * The token does not exist.
271      */
272     error ApprovalQueryForNonexistentToken();
273 
274     /**
275      * The caller cannot approve to their own address.
276      */
277     error ApproveToCaller();
278 
279     /**
280      * The caller cannot approve to the current owner.
281      */
282     error ApprovalToCurrentOwner();
283 
284     /**
285      * Cannot query the balance for the zero address.
286      */
287     error BalanceQueryForZeroAddress();
288 
289     /**
290      * Cannot mint to the zero address.
291      */
292     error MintToZeroAddress();
293 
294     /**
295      * The quantity of tokens minted must be more than zero.
296      */
297     error MintZeroQuantity();
298 
299     /**
300      * The token does not exist.
301      */
302     error OwnerQueryForNonexistentToken();
303 
304     /**
305      * The caller must own the token or be an approved operator.
306      */
307     error TransferCallerNotOwnerNorApproved();
308 
309     /**
310      * The token must be owned by `from`.
311      */
312     error TransferFromIncorrectOwner();
313 
314     /**
315      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
316      */
317     error TransferToNonERC721ReceiverImplementer();
318 
319     /**
320      * Cannot transfer to the zero address.
321      */
322     error TransferToZeroAddress();
323 
324     /**
325      * The token does not exist.
326      */
327     error URIQueryForNonexistentToken();
328 
329     struct TokenOwnership {
330         // The address of the owner.
331         address addr;
332         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
333         uint64 startTimestamp;
334         // Whether the token has been burned.
335         bool burned;
336     }
337 
338     /**
339      * @dev Returns the total amount of tokens stored by the contract.
340      *
341      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
342      */
343     function totalSupply() external view returns (uint256);
344 
345     // ==============================
346     //            IERC165
347     // ==============================
348 
349     /**
350      * @dev Returns true if this contract implements the interface defined by
351      * `interfaceId`. See the corresponding
352      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
353      * to learn more about how these ids are created.
354      *
355      * This function call must use less than 30 000 gas.
356      */
357     function supportsInterface(bytes4 interfaceId) external view returns (bool);
358 
359     // ==============================
360     //            IERC721
361     // ==============================
362 
363     /**
364      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
365      */
366     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
367 
368     /**
369      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
370      */
371     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
372 
373     /**
374      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
375      */
376     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
377 
378     /**
379      * @dev Returns the number of tokens in ``owner``'s account.
380      */
381     function balanceOf(address owner) external view returns (uint256 balance);
382 
383     /**
384      * @dev Returns the owner of the `tokenId` token.
385      *
386      * Requirements:
387      *
388      * - `tokenId` must exist.
389      */
390     function ownerOf(uint256 tokenId) external view returns (address owner);
391 
392     /**
393      * @dev Safely transfers `tokenId` token from `from` to `to`.
394      *
395      * Requirements:
396      *
397      * - `from` cannot be the zero address.
398      * - `to` cannot be the zero address.
399      * - `tokenId` token must exist and be owned by `from`.
400      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
401      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
402      *
403      * Emits a {Transfer} event.
404      */
405     function safeTransferFrom(
406         address from,
407         address to,
408         uint256 tokenId,
409         bytes calldata data
410     ) external;
411 
412     /**
413      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
414      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
415      *
416      * Requirements:
417      *
418      * - `from` cannot be the zero address.
419      * - `to` cannot be the zero address.
420      * - `tokenId` token must exist and be owned by `from`.
421      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
422      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
423      *
424      * Emits a {Transfer} event.
425      */
426     function safeTransferFrom(
427         address from,
428         address to,
429         uint256 tokenId
430     ) external;
431 
432     /**
433      * @dev Transfers `tokenId` token from `from` to `to`.
434      *
435      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      *
444      * Emits a {Transfer} event.
445      */
446     function transferFrom(
447         address from,
448         address to,
449         uint256 tokenId
450     ) external;
451 
452     /**
453      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
454      * The approval is cleared when the token is transferred.
455      *
456      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
457      *
458      * Requirements:
459      *
460      * - The caller must own the token or be an approved operator.
461      * - `tokenId` must exist.
462      *
463      * Emits an {Approval} event.
464      */
465     function approve(address to, uint256 tokenId) external;
466 
467     /**
468      * @dev Approve or remove `operator` as an operator for the caller.
469      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
470      *
471      * Requirements:
472      *
473      * - The `operator` cannot be the caller.
474      *
475      * Emits an {ApprovalForAll} event.
476      */
477     function setApprovalForAll(address operator, bool _approved) external;
478 
479     /**
480      * @dev Returns the account approved for `tokenId` token.
481      *
482      * Requirements:
483      *
484      * - `tokenId` must exist.
485      */
486     function getApproved(uint256 tokenId) external view returns (address operator);
487 
488     /**
489      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
490      *
491      * See {setApprovalForAll}
492      */
493     function isApprovedForAll(address owner, address operator) external view returns (bool);
494 
495     // ==============================
496     //        IERC721Metadata
497     // ==============================
498 
499     /**
500      * @dev Returns the token collection name.
501      */
502     function name() external view returns (string memory);
503 
504     /**
505      * @dev Returns the token collection symbol.
506      */
507     function symbol() external view returns (string memory);
508 
509     /**
510      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
511      */
512     function tokenURI(uint256 tokenId) external view returns (string memory);
513 }
514 
515 // File: erc721a/contracts/ERC721A.sol
516 
517 
518 // ERC721A Contracts v4.0.0
519 // Creator: Chiru Labs
520 
521 pragma solidity ^0.8.4;
522 
523 
524 /**
525  * @dev ERC721 token receiver interface.
526  */
527 interface ERC721A__IERC721Receiver {
528     function onERC721Received(
529         address operator,
530         address from,
531         uint256 tokenId,
532         bytes calldata data
533     ) external returns (bytes4);
534 }
535 
536 /**
537  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
538  * the Metadata extension. Built to optimize for lower gas during batch mints.
539  *
540  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
541  *
542  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
543  *
544  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
545  */
546 contract ERC721A is IERC721A {
547     // Mask of an entry in packed address data.
548     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
549 
550     // The bit position of `numberMinted` in packed address data.
551     uint256 private constant BITPOS_NUMBER_MINTED = 64;
552 
553     // The bit position of `numberBurned` in packed address data.
554     uint256 private constant BITPOS_NUMBER_BURNED = 128;
555 
556     // The bit position of `aux` in packed address data.
557     uint256 private constant BITPOS_AUX = 192;
558 
559     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
560     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
561 
562     // The bit position of `startTimestamp` in packed ownership.
563     uint256 private constant BITPOS_START_TIMESTAMP = 160;
564 
565     // The bit mask of the `burned` bit in packed ownership.
566     uint256 private constant BITMASK_BURNED = 1 << 224;
567     
568     // The bit position of the `nextInitialized` bit in packed ownership.
569     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
570 
571     // The bit mask of the `nextInitialized` bit in packed ownership.
572     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
573 
574     // The tokenId of the next token to be minted.
575     uint256 private _currentIndex;
576 
577     // The number of tokens burned.
578     uint256 private _burnCounter;
579 
580     // Token name
581     string private _name;
582 
583     // Token symbol
584     string private _symbol;
585 
586     // Mapping from token ID to ownership details
587     // An empty struct value does not necessarily mean the token is unowned.
588     // See `_packedOwnershipOf` implementation for details.
589     //
590     // Bits Layout:
591     // - [0..159]   `addr`
592     // - [160..223] `startTimestamp`
593     // - [224]      `burned`
594     // - [225]      `nextInitialized`
595     mapping(uint256 => uint256) private _packedOwnerships;
596 
597     // Mapping owner address to address data.
598     //
599     // Bits Layout:
600     // - [0..63]    `balance`
601     // - [64..127]  `numberMinted`
602     // - [128..191] `numberBurned`
603     // - [192..255] `aux`
604     mapping(address => uint256) private _packedAddressData;
605 
606     // Mapping from token ID to approved address.
607     mapping(uint256 => address) private _tokenApprovals;
608 
609     // Mapping from owner to operator approvals
610     mapping(address => mapping(address => bool)) private _operatorApprovals;
611 
612     constructor(string memory name_, string memory symbol_) {
613         _name = name_;
614         _symbol = symbol_;
615         _currentIndex = _startTokenId();
616     }
617 
618     /**
619      * @dev Returns the starting token ID. 
620      * To change the starting token ID, please override this function.
621      */
622     function _startTokenId() internal view virtual returns (uint256) {
623         return 0;
624     }
625 
626     /**
627      * @dev Returns the next token ID to be minted.
628      */
629     function _nextTokenId() internal view returns (uint256) {
630         return _currentIndex;
631     }
632 
633     /**
634      * @dev Returns the total number of tokens in existence.
635      * Burned tokens will reduce the count. 
636      * To get the total number of tokens minted, please see `_totalMinted`.
637      */
638     function totalSupply() public view override returns (uint256) {
639         // Counter underflow is impossible as _burnCounter cannot be incremented
640         // more than `_currentIndex - _startTokenId()` times.
641         unchecked {
642             return _currentIndex - _burnCounter - _startTokenId();
643         }
644     }
645 
646     /**
647      * @dev Returns the total amount of tokens minted in the contract.
648      */
649     function _totalMinted() internal view returns (uint256) {
650         // Counter underflow is impossible as _currentIndex does not decrement,
651         // and it is initialized to `_startTokenId()`
652         unchecked {
653             return _currentIndex - _startTokenId();
654         }
655     }
656 
657     /**
658      * @dev Returns the total number of tokens burned.
659      */
660     function _totalBurned() internal view returns (uint256) {
661         return _burnCounter;
662     }
663 
664     /**
665      * @dev See {IERC165-supportsInterface}.
666      */
667     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
668         // The interface IDs are constants representing the first 4 bytes of the XOR of
669         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
670         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
671         return
672             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
673             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
674             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
675     }
676 
677     /**
678      * @dev See {IERC721-balanceOf}.
679      */
680     function balanceOf(address owner) public view override returns (uint256) {
681         if (owner == address(0)) revert BalanceQueryForZeroAddress();
682         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
683     }
684 
685     /**
686      * Returns the number of tokens minted by `owner`.
687      */
688     function _numberMinted(address owner) internal view returns (uint256) {
689         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
690     }
691 
692     /**
693      * Returns the number of tokens burned by or on behalf of `owner`.
694      */
695     function _numberBurned(address owner) internal view returns (uint256) {
696         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
697     }
698 
699     /**
700      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
701      */
702     function _getAux(address owner) internal view returns (uint64) {
703         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
704     }
705 
706     /**
707      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
708      * If there are multiple variables, please pack them into a uint64.
709      */
710     function _setAux(address owner, uint64 aux) internal {
711         uint256 packed = _packedAddressData[owner];
712         uint256 auxCasted;
713         assembly { // Cast aux without masking.
714             auxCasted := aux
715         }
716         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
717         _packedAddressData[owner] = packed;
718     }
719 
720     /**
721      * Returns the packed ownership data of `tokenId`.
722      */
723     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
724         uint256 curr = tokenId;
725 
726         unchecked {
727             if (_startTokenId() <= curr)
728                 if (curr < _currentIndex) {
729                     uint256 packed = _packedOwnerships[curr];
730                     // If not burned.
731                     if (packed & BITMASK_BURNED == 0) {
732                         // Invariant:
733                         // There will always be an ownership that has an address and is not burned
734                         // before an ownership that does not have an address and is not burned.
735                         // Hence, curr will not underflow.
736                         //
737                         // We can directly compare the packed value.
738                         // If the address is zero, packed is zero.
739                         while (packed == 0) {
740                             packed = _packedOwnerships[--curr];
741                         }
742                         return packed;
743                     }
744                 }
745         }
746         revert OwnerQueryForNonexistentToken();
747     }
748 
749     /**
750      * Returns the unpacked `TokenOwnership` struct from `packed`.
751      */
752     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
753         ownership.addr = address(uint160(packed));
754         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
755         ownership.burned = packed & BITMASK_BURNED != 0;
756     }
757 
758     /**
759      * Returns the unpacked `TokenOwnership` struct at `index`.
760      */
761     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
762         return _unpackedOwnership(_packedOwnerships[index]);
763     }
764 
765     /**
766      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
767      */
768     function _initializeOwnershipAt(uint256 index) internal {
769         if (_packedOwnerships[index] == 0) {
770             _packedOwnerships[index] = _packedOwnershipOf(index);
771         }
772     }
773 
774     /**
775      * Gas spent here starts off proportional to the maximum mint batch size.
776      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
777      */
778     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
779         return _unpackedOwnership(_packedOwnershipOf(tokenId));
780     }
781 
782     /**
783      * @dev See {IERC721-ownerOf}.
784      */
785     function ownerOf(uint256 tokenId) public view override returns (address) {
786         return address(uint160(_packedOwnershipOf(tokenId)));
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-name}.
791      */
792     function name() public view virtual override returns (string memory) {
793         return _name;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-symbol}.
798      */
799     function symbol() public view virtual override returns (string memory) {
800         return _symbol;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-tokenURI}.
805      */
806     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
807         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
808 
809         string memory baseURI = _baseURI();
810         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
811     }
812 
813     /**
814      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
815      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
816      * by default, can be overriden in child contracts.
817      */
818     function _baseURI() internal view virtual returns (string memory) {
819         return '';
820     }
821 
822     /**
823      * @dev Casts the address to uint256 without masking.
824      */
825     function _addressToUint256(address value) private pure returns (uint256 result) {
826         assembly {
827             result := value
828         }
829     }
830 
831     /**
832      * @dev Casts the boolean to uint256 without branching.
833      */
834     function _boolToUint256(bool value) private pure returns (uint256 result) {
835         assembly {
836             result := value
837         }
838     }
839 
840     /**
841      * @dev See {IERC721-approve}.
842      */
843     function approve(address to, uint256 tokenId) public override {
844         address owner = address(uint160(_packedOwnershipOf(tokenId)));
845         if (to == owner) revert ApprovalToCurrentOwner();
846 
847         if (_msgSenderERC721A() != owner)
848             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
849                 revert ApprovalCallerNotOwnerNorApproved();
850             }
851 
852         _tokenApprovals[tokenId] = to;
853         emit Approval(owner, to, tokenId);
854     }
855 
856     /**
857      * @dev See {IERC721-getApproved}.
858      */
859     function getApproved(uint256 tokenId) public view override returns (address) {
860         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
861 
862         return _tokenApprovals[tokenId];
863     }
864 
865     /**
866      * @dev See {IERC721-setApprovalForAll}.
867      */
868     function setApprovalForAll(address operator, bool approved) public virtual override {
869         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
870 
871         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
872         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
873     }
874 
875     /**
876      * @dev See {IERC721-isApprovedForAll}.
877      */
878     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
879         return _operatorApprovals[owner][operator];
880     }
881 
882     /**
883      * @dev See {IERC721-transferFrom}.
884      */
885     function transferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) public virtual override {
890         _transfer(from, to, tokenId);
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         safeTransferFrom(from, to, tokenId, '');
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) public virtual override {
913         _transfer(from, to, tokenId);
914         if (to.code.length != 0)
915             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
916                 revert TransferToNonERC721ReceiverImplementer();
917             }
918     }
919 
920     /**
921      * @dev Returns whether `tokenId` exists.
922      *
923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
924      *
925      * Tokens start existing when they are minted (`_mint`),
926      */
927     function _exists(uint256 tokenId) internal view returns (bool) {
928         return
929             _startTokenId() <= tokenId &&
930             tokenId < _currentIndex && // If within bounds,
931             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
932     }
933 
934     /**
935      * @dev Equivalent to `_safeMint(to, quantity, '')`.
936      */
937     function _safeMint(address to, uint256 quantity) internal {
938         _safeMint(to, quantity, '');
939     }
940 
941     /**
942      * @dev Safely mints `quantity` tokens and transfers them to `to`.
943      *
944      * Requirements:
945      *
946      * - If `to` refers to a smart contract, it must implement
947      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
948      * - `quantity` must be greater than 0.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeMint(
953         address to,
954         uint256 quantity,
955         bytes memory _data
956     ) internal {
957         uint256 startTokenId = _currentIndex;
958         if (to == address(0)) revert MintToZeroAddress();
959         if (quantity == 0) revert MintZeroQuantity();
960 
961         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
962 
963         // Overflows are incredibly unrealistic.
964         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
965         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
966         unchecked {
967             // Updates:
968             // - `balance += quantity`.
969             // - `numberMinted += quantity`.
970             //
971             // We can directly add to the balance and number minted.
972             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
973 
974             // Updates:
975             // - `address` to the owner.
976             // - `startTimestamp` to the timestamp of minting.
977             // - `burned` to `false`.
978             // - `nextInitialized` to `quantity == 1`.
979             _packedOwnerships[startTokenId] =
980                 _addressToUint256(to) |
981                 (block.timestamp << BITPOS_START_TIMESTAMP) |
982                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
983 
984             uint256 updatedIndex = startTokenId;
985             uint256 end = updatedIndex + quantity;
986 
987             if (to.code.length != 0) {
988                 do {
989                     emit Transfer(address(0), to, updatedIndex);
990                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
991                         revert TransferToNonERC721ReceiverImplementer();
992                     }
993                 } while (updatedIndex < end);
994                 // Reentrancy protection
995                 if (_currentIndex != startTokenId) revert();
996             } else {
997                 do {
998                     emit Transfer(address(0), to, updatedIndex++);
999                 } while (updatedIndex < end);
1000             }
1001             _currentIndex = updatedIndex;
1002         }
1003         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1004     }
1005 
1006     /**
1007      * @dev Mints `quantity` tokens and transfers them to `to`.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `quantity` must be greater than 0.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _mint(address to, uint256 quantity) internal {
1017         uint256 startTokenId = _currentIndex;
1018         if (to == address(0)) revert MintToZeroAddress();
1019         if (quantity == 0) revert MintZeroQuantity();
1020 
1021         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1022 
1023         // Overflows are incredibly unrealistic.
1024         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1025         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1026         unchecked {
1027             // Updates:
1028             // - `balance += quantity`.
1029             // - `numberMinted += quantity`.
1030             //
1031             // We can directly add to the balance and number minted.
1032             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1033 
1034             // Updates:
1035             // - `address` to the owner.
1036             // - `startTimestamp` to the timestamp of minting.
1037             // - `burned` to `false`.
1038             // - `nextInitialized` to `quantity == 1`.
1039             _packedOwnerships[startTokenId] =
1040                 _addressToUint256(to) |
1041                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1042                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1043 
1044             uint256 updatedIndex = startTokenId;
1045             uint256 end = updatedIndex + quantity;
1046 
1047             do {
1048                 emit Transfer(address(0), to, updatedIndex++);
1049             } while (updatedIndex < end);
1050 
1051             _currentIndex = updatedIndex;
1052         }
1053         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1054     }
1055 
1056     /**
1057      * @dev Transfers `tokenId` from `from` to `to`.
1058      *
1059      * Requirements:
1060      *
1061      * - `to` cannot be the zero address.
1062      * - `tokenId` token must be owned by `from`.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _transfer(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) private {
1071         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1072 
1073         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1074 
1075         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1076             isApprovedForAll(from, _msgSenderERC721A()) ||
1077             getApproved(tokenId) == _msgSenderERC721A());
1078 
1079         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1080         if (to == address(0)) revert TransferToZeroAddress();
1081 
1082         _beforeTokenTransfers(from, to, tokenId, 1);
1083 
1084         // Clear approvals from the previous owner.
1085         delete _tokenApprovals[tokenId];
1086 
1087         // Underflow of the sender's balance is impossible because we check for
1088         // ownership above and the recipient's balance can't realistically overflow.
1089         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1090         unchecked {
1091             // We can directly increment and decrement the balances.
1092             --_packedAddressData[from]; // Updates: `balance -= 1`.
1093             ++_packedAddressData[to]; // Updates: `balance += 1`.
1094 
1095             // Updates:
1096             // - `address` to the next owner.
1097             // - `startTimestamp` to the timestamp of transfering.
1098             // - `burned` to `false`.
1099             // - `nextInitialized` to `true`.
1100             _packedOwnerships[tokenId] =
1101                 _addressToUint256(to) |
1102                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1103                 BITMASK_NEXT_INITIALIZED;
1104 
1105             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1106             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1107                 uint256 nextTokenId = tokenId + 1;
1108                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1109                 if (_packedOwnerships[nextTokenId] == 0) {
1110                     // If the next slot is within bounds.
1111                     if (nextTokenId != _currentIndex) {
1112                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1113                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1114                     }
1115                 }
1116             }
1117         }
1118 
1119         emit Transfer(from, to, tokenId);
1120         _afterTokenTransfers(from, to, tokenId, 1);
1121     }
1122 
1123     /**
1124      * @dev Equivalent to `_burn(tokenId, false)`.
1125      */
1126     function _burn(uint256 tokenId) internal virtual {
1127         _burn(tokenId, false);
1128     }
1129 
1130     /**
1131      * @dev Destroys `tokenId`.
1132      * The approval is cleared when the token is burned.
1133      *
1134      * Requirements:
1135      *
1136      * - `tokenId` must exist.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1141         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1142 
1143         address from = address(uint160(prevOwnershipPacked));
1144 
1145         if (approvalCheck) {
1146             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1147                 isApprovedForAll(from, _msgSenderERC721A()) ||
1148                 getApproved(tokenId) == _msgSenderERC721A());
1149 
1150             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1151         }
1152 
1153         _beforeTokenTransfers(from, address(0), tokenId, 1);
1154 
1155         // Clear approvals from the previous owner.
1156         delete _tokenApprovals[tokenId];
1157 
1158         // Underflow of the sender's balance is impossible because we check for
1159         // ownership above and the recipient's balance can't realistically overflow.
1160         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1161         unchecked {
1162             // Updates:
1163             // - `balance -= 1`.
1164             // - `numberBurned += 1`.
1165             //
1166             // We can directly decrement the balance, and increment the number burned.
1167             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1168             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1169 
1170             // Updates:
1171             // - `address` to the last owner.
1172             // - `startTimestamp` to the timestamp of burning.
1173             // - `burned` to `true`.
1174             // - `nextInitialized` to `true`.
1175             _packedOwnerships[tokenId] =
1176                 _addressToUint256(from) |
1177                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1178                 BITMASK_BURNED | 
1179                 BITMASK_NEXT_INITIALIZED;
1180 
1181             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1182             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1183                 uint256 nextTokenId = tokenId + 1;
1184                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1185                 if (_packedOwnerships[nextTokenId] == 0) {
1186                     // If the next slot is within bounds.
1187                     if (nextTokenId != _currentIndex) {
1188                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1189                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1190                     }
1191                 }
1192             }
1193         }
1194 
1195         emit Transfer(from, address(0), tokenId);
1196         _afterTokenTransfers(from, address(0), tokenId, 1);
1197 
1198         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1199         unchecked {
1200             _burnCounter++;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1206      *
1207      * @param from address representing the previous owner of the given token ID
1208      * @param to target address that will receive the tokens
1209      * @param tokenId uint256 ID of the token to be transferred
1210      * @param _data bytes optional data to send along with the call
1211      * @return bool whether the call correctly returned the expected magic value
1212      */
1213     function _checkContractOnERC721Received(
1214         address from,
1215         address to,
1216         uint256 tokenId,
1217         bytes memory _data
1218     ) private returns (bool) {
1219         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1220             bytes4 retval
1221         ) {
1222             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1223         } catch (bytes memory reason) {
1224             if (reason.length == 0) {
1225                 revert TransferToNonERC721ReceiverImplementer();
1226             } else {
1227                 assembly {
1228                     revert(add(32, reason), mload(reason))
1229                 }
1230             }
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1236      * And also called before burning one token.
1237      *
1238      * startTokenId - the first token id to be transferred
1239      * quantity - the amount to be transferred
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` will be minted for `to`.
1246      * - When `to` is zero, `tokenId` will be burned by `from`.
1247      * - `from` and `to` are never both zero.
1248      */
1249     function _beforeTokenTransfers(
1250         address from,
1251         address to,
1252         uint256 startTokenId,
1253         uint256 quantity
1254     ) internal virtual {}
1255 
1256     /**
1257      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1258      * minting.
1259      * And also called after one token has been burned.
1260      *
1261      * startTokenId - the first token id to be transferred
1262      * quantity - the amount to be transferred
1263      *
1264      * Calling conditions:
1265      *
1266      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1267      * transferred to `to`.
1268      * - When `from` is zero, `tokenId` has been minted for `to`.
1269      * - When `to` is zero, `tokenId` has been burned by `from`.
1270      * - `from` and `to` are never both zero.
1271      */
1272     function _afterTokenTransfers(
1273         address from,
1274         address to,
1275         uint256 startTokenId,
1276         uint256 quantity
1277     ) internal virtual {}
1278 
1279     /**
1280      * @dev Returns the message sender (defaults to `msg.sender`).
1281      *
1282      * If you are writing GSN compatible contracts, you need to override this function.
1283      */
1284     function _msgSenderERC721A() internal view virtual returns (address) {
1285         return msg.sender;
1286     }
1287 
1288     /**
1289      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1290      */
1291     function _toString(uint256 value) internal pure returns (string memory ptr) {
1292         assembly {
1293             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1294             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1295             // We will need 1 32-byte word to store the length, 
1296             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1297             ptr := add(mload(0x40), 128)
1298             // Update the free memory pointer to allocate.
1299             mstore(0x40, ptr)
1300 
1301             // Cache the end of the memory to calculate the length later.
1302             let end := ptr
1303 
1304             // We write the string from the rightmost digit to the leftmost digit.
1305             // The following is essentially a do-while loop that also handles the zero case.
1306             // Costs a bit more than early returning for the zero case,
1307             // but cheaper in terms of deployment and overall runtime costs.
1308             for { 
1309                 // Initialize and perform the first pass without check.
1310                 let temp := value
1311                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1312                 ptr := sub(ptr, 1)
1313                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1314                 mstore8(ptr, add(48, mod(temp, 10)))
1315                 temp := div(temp, 10)
1316             } temp { 
1317                 // Keep dividing `temp` until zero.
1318                 temp := div(temp, 10)
1319             } { // Body of the for loop.
1320                 ptr := sub(ptr, 1)
1321                 mstore8(ptr, add(48, mod(temp, 10)))
1322             }
1323             
1324             let length := sub(end, ptr)
1325             // Move the pointer 32 bytes leftwards to make room for the length.
1326             ptr := sub(ptr, 32)
1327             // Store the length.
1328             mstore(ptr, length)
1329         }
1330     }
1331 }
1332 
1333 // File: contracts/escapeTheAgenda.sol
1334 
1335 pragma solidity >=0.8.9 <0.9.0;
1336 
1337 contract EscapeTheAgenda is ERC721A, Ownable, ReentrancyGuard {
1338   using Strings for uint256;
1339 
1340   string public baseURI = "ipfs://QmQfiMcUfoURcy49txBFAQ1HtiWhgi3JTjv3o5YvRVbHyK/";
1341   string public hiddenMetadataUri;
1342   uint256 public maxAGND = 5555;
1343   uint256 public Max_AGND_Per_Wallet_PublicSale = 3;
1344   uint256 public publicSaleCost = 0 ether;
1345   uint256 public Max_AGND_Per_Transaction = 50;
1346   bool public paused = true;
1347   bool public revealed = true;
1348   bool public isPublicSaleActive = true;
1349 
1350   modifier publicSaleActive() {
1351     require(isPublicSaleActive, "Public sale is not open");
1352     _;
1353   }
1354 
1355   modifier salePaused() {
1356     require(!paused, "Sale is paused");
1357     _;
1358   }
1359 
1360   modifier maxAGNDPublicSale(uint256 numberOfTokens) {
1361     require(
1362       balanceOf(msg.sender) + numberOfTokens <= Max_AGND_Per_Wallet_PublicSale,
1363       "Max AGND per wallet during public sale is 3"
1364     );
1365     _;
1366   }
1367 
1368   modifier canMintAGND(uint256 numberOfTokens) {
1369     require(
1370       totalSupply() + numberOfTokens <= maxAGND,
1371       "Not enough AGND remaining to mint"
1372     );
1373     require(
1374       numberOfTokens > 0 && numberOfTokens <= Max_AGND_Per_Transaction, "Invalid mint amount!"
1375     );
1376     _;
1377   }
1378 
1379   modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1380     require(
1381       msg.value >= price * numberOfTokens,
1382       "Insufficient Funds!!!"
1383     );
1384     _;
1385   }
1386 
1387   constructor() ERC721A("Escape The Agenda", "AGND") {
1388     setHiddenMetadataUri("ipfs:///hidden.json");
1389   }
1390 
1391   function publicMint(uint256 numberOfTokens)
1392     external
1393     payable
1394     nonReentrant
1395     salePaused
1396     publicSaleActive
1397     canMintAGND(numberOfTokens)
1398     maxAGNDPublicSale(numberOfTokens)
1399     isCorrectPayment(publicSaleCost, numberOfTokens)
1400     {
1401       _safeMint(msg.sender, numberOfTokens); 
1402     }
1403 
1404   // Owner quota for the team and giveaways
1405   function ownerMint(uint256 numberOfTokens, address _receiver)
1406     public
1407     nonReentrant
1408     onlyOwner
1409     canMintAGND(numberOfTokens)
1410     {
1411       _safeMint(_receiver, numberOfTokens);
1412     }
1413   // function getBaseURI() external view returns (string memory) {
1414   //   return baseURI;
1415   // }
1416 
1417   function setBaseURI(string memory _baseURI) external onlyOwner {
1418     baseURI = _baseURI;
1419   }
1420 
1421 
1422   function setRevealed(bool _state) external onlyOwner {
1423     revealed = _state;
1424   }
1425 
1426   function setPaused(bool _state) external onlyOwner {
1427     paused = _state;
1428   }
1429 
1430   function openPublicSale(bool _state) external onlyOwner {
1431     isPublicSaleActive = _state;
1432   }
1433 
1434   function walletOfOwner(address _owner)
1435     public
1436     view
1437     returns (uint256[] memory)
1438   {
1439     uint256 ownerTokenCount = balanceOf(_owner);
1440     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1441     uint256 currentTokenId = 1;
1442     uint256 ownedTokenIndex = 0;
1443 
1444     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxAGND) {
1445       address currentTokenOwner = ownerOf(currentTokenId);
1446 
1447       if (currentTokenOwner == _owner) {
1448         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1449 
1450         ownedTokenIndex++;
1451       }
1452 
1453       currentTokenId++;
1454     }
1455 
1456     return ownedTokenIds;
1457   } 
1458 
1459   function _startTokenId() internal view virtual override returns (uint256) {
1460     return 1;
1461   }
1462 
1463   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1464     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1465 
1466     if (revealed == false) {
1467       return hiddenMetadataUri;
1468     }
1469 
1470     return
1471       string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
1472   }
1473 
1474   function setPublicSaleCost(uint256 _cost) external onlyOwner {
1475     publicSaleCost = _cost;
1476   }
1477 
1478   function setMaxAGNDPerTx(uint256 _maxAGNDPerTx) external onlyOwner {
1479     Max_AGND_Per_Transaction = _maxAGNDPerTx;
1480   }
1481 
1482   function setPublicSaleWalletLimit(uint256 _PublicSaleWalletLimit) external onlyOwner {
1483     Max_AGND_Per_Wallet_PublicSale = _PublicSaleWalletLimit;
1484   }
1485 
1486   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1487     hiddenMetadataUri = _hiddenMetadataUri;
1488   }
1489 
1490   function withdraw() public onlyOwner {    
1491     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1492     require(os);    
1493   }
1494 }