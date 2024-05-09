1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Contract module that helps prevent reentrant calls to a function.
81  *
82  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
83  * available, which can be applied to functions to make sure there are no nested
84  * (reentrant) calls to them.
85  *
86  * Note that because there is a single `nonReentrant` guard, functions marked as
87  * `nonReentrant` may not call one another. This can be worked around by making
88  * those functions `private`, and then adding `external` `nonReentrant` entry
89  * points to them.
90  *
91  * TIP: If you would like to learn more about reentrancy and alternative ways
92  * to protect against it, check out our blog post
93  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
94  */
95 abstract contract ReentrancyGuard {
96     // Booleans are more expensive than uint256 or any type that takes up a full
97     // word because each write operation emits an extra SLOAD to first read the
98     // slot's contents, replace the bits taken up by the boolean, and then write
99     // back. This is the compiler's defense against contract upgrades and
100     // pointer aliasing, and it cannot be disabled.
101 
102     // The values being non-zero value makes deployment a bit more expensive,
103     // but in exchange the refund on every call to nonReentrant will be lower in
104     // amount. Since refunds are capped to a percentage of the total
105     // transaction's gas, it is best to keep them low in cases like this one, to
106     // increase the likelihood of the full refund coming into effect.
107     uint256 private constant _NOT_ENTERED = 1;
108     uint256 private constant _ENTERED = 2;
109 
110     uint256 private _status;
111 
112     constructor() {
113         _status = _NOT_ENTERED;
114     }
115 
116     /**
117      * @dev Prevents a contract from calling itself, directly or indirectly.
118      * Calling a `nonReentrant` function from another `nonReentrant`
119      * function is not supported. It is possible to prevent this from happening
120      * by making the `nonReentrant` function external, and making it call a
121      * `private` function that does the actual work.
122      */
123     modifier nonReentrant() {
124         // On the first call to nonReentrant, _notEntered will be true
125         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
126 
127         // Any calls to nonReentrant after this point will fail
128         _status = _ENTERED;
129 
130         _;
131 
132         // By storing the original value once again, a refund is triggered (see
133         // https://eips.ethereum.org/EIPS/eip-2200)
134         _status = _NOT_ENTERED;
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Context.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Provides information about the current execution context, including the
147  * sender of the transaction and its data. While these are generally available
148  * via msg.sender and msg.data, they should not be accessed in such a direct
149  * manner, since when dealing with meta-transactions the account sending and
150  * paying for execution may not be the actual sender (as far as an application
151  * is concerned).
152  *
153  * This contract is only required for intermediate, library-like contracts.
154  */
155 abstract contract Context {
156     function _msgSender() internal view virtual returns (address) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view virtual returns (bytes calldata) {
161         return msg.data;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/access/Ownable.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 
173 /**
174  * @dev Contract module which provides a basic access control mechanism, where
175  * there is an account (an owner) that can be granted exclusive access to
176  * specific functions.
177  *
178  * By default, the owner account will be the one that deploys the contract. This
179  * can later be changed with {transferOwnership}.
180  *
181  * This module is used through inheritance. It will make available the modifier
182  * `onlyOwner`, which can be applied to your functions to restrict their use to
183  * the owner.
184  */
185 abstract contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     /**
191      * @dev Initializes the contract setting the deployer as the initial owner.
192      */
193     constructor() {
194         _transferOwnership(_msgSender());
195     }
196 
197     /**
198      * @dev Returns the address of the current owner.
199      */
200     function owner() public view virtual returns (address) {
201         return _owner;
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         require(owner() == _msgSender(), "Ownable: caller is not the owner");
209         _;
210     }
211 
212     /**
213      * @dev Leaves the contract without owner. It will not be possible to call
214      * `onlyOwner` functions anymore. Can only be called by the current owner.
215      *
216      * NOTE: Renouncing ownership will leave the contract without an owner,
217      * thereby removing any functionality that is only available to the owner.
218      */
219     function renounceOwnership() public virtual onlyOwner {
220         _transferOwnership(address(0));
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Can only be called by the current owner.
226      */
227     function transferOwnership(address newOwner) public virtual onlyOwner {
228         require(newOwner != address(0), "Ownable: new owner is the zero address");
229         _transferOwnership(newOwner);
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Internal function without access restriction.
235      */
236     function _transferOwnership(address newOwner) internal virtual {
237         address oldOwner = _owner;
238         _owner = newOwner;
239         emit OwnershipTransferred(oldOwner, newOwner);
240     }
241 }
242 
243 // File: erc721a/contracts/IERC721A.sol
244 
245 
246 // ERC721A Contracts v4.0.0
247 // Creator: Chiru Labs
248 
249 pragma solidity ^0.8.4;
250 
251 /**
252  * @dev Interface of an ERC721A compliant contract.
253  */
254 interface IERC721A {
255     /**
256      * The caller must own the token or be an approved operator.
257      */
258     error ApprovalCallerNotOwnerNorApproved();
259 
260     /**
261      * The token does not exist.
262      */
263     error ApprovalQueryForNonexistentToken();
264 
265     /**
266      * The caller cannot approve to their own address.
267      */
268     error ApproveToCaller();
269 
270     /**
271      * The caller cannot approve to the current owner.
272      */
273     error ApprovalToCurrentOwner();
274 
275     /**
276      * Cannot query the balance for the zero address.
277      */
278     error BalanceQueryForZeroAddress();
279 
280     /**
281      * Cannot mint to the zero address.
282      */
283     error MintToZeroAddress();
284 
285     /**
286      * The quantity of tokens minted must be more than zero.
287      */
288     error MintZeroQuantity();
289 
290     /**
291      * The token does not exist.
292      */
293     error OwnerQueryForNonexistentToken();
294 
295     /**
296      * The caller must own the token or be an approved operator.
297      */
298     error TransferCallerNotOwnerNorApproved();
299 
300     /**
301      * The token must be owned by `from`.
302      */
303     error TransferFromIncorrectOwner();
304 
305     /**
306      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
307      */
308     error TransferToNonERC721ReceiverImplementer();
309 
310     /**
311      * Cannot transfer to the zero address.
312      */
313     error TransferToZeroAddress();
314 
315     /**
316      * The token does not exist.
317      */
318     error URIQueryForNonexistentToken();
319 
320     struct TokenOwnership {
321         // The address of the owner.
322         address addr;
323         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
324         uint64 startTimestamp;
325         // Whether the token has been burned.
326         bool burned;
327     }
328 
329     /**
330      * @dev Returns the total amount of tokens stored by the contract.
331      *
332      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
333      */
334     function totalSupply() external view returns (uint256);
335 
336     // ==============================
337     //            IERC165
338     // ==============================
339 
340     /**
341      * @dev Returns true if this contract implements the interface defined by
342      * `interfaceId`. See the corresponding
343      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
344      * to learn more about how these ids are created.
345      *
346      * This function call must use less than 30 000 gas.
347      */
348     function supportsInterface(bytes4 interfaceId) external view returns (bool);
349 
350     // ==============================
351     //            IERC721
352     // ==============================
353 
354     /**
355      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
356      */
357     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
358 
359     /**
360      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
361      */
362     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
363 
364     /**
365      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
366      */
367     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
368 
369     /**
370      * @dev Returns the number of tokens in ``owner``'s account.
371      */
372     function balanceOf(address owner) external view returns (uint256 balance);
373 
374     /**
375      * @dev Returns the owner of the `tokenId` token.
376      *
377      * Requirements:
378      *
379      * - `tokenId` must exist.
380      */
381     function ownerOf(uint256 tokenId) external view returns (address owner);
382 
383     /**
384      * @dev Safely transfers `tokenId` token from `from` to `to`.
385      *
386      * Requirements:
387      *
388      * - `from` cannot be the zero address.
389      * - `to` cannot be the zero address.
390      * - `tokenId` token must exist and be owned by `from`.
391      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
392      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
393      *
394      * Emits a {Transfer} event.
395      */
396     function safeTransferFrom(
397         address from,
398         address to,
399         uint256 tokenId,
400         bytes calldata data
401     ) external;
402 
403     /**
404      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
405      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
406      *
407      * Requirements:
408      *
409      * - `from` cannot be the zero address.
410      * - `to` cannot be the zero address.
411      * - `tokenId` token must exist and be owned by `from`.
412      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
413      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
414      *
415      * Emits a {Transfer} event.
416      */
417     function safeTransferFrom(
418         address from,
419         address to,
420         uint256 tokenId
421     ) external;
422 
423     /**
424      * @dev Transfers `tokenId` token from `from` to `to`.
425      *
426      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `tokenId` token must be owned by `from`.
433      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
434      *
435      * Emits a {Transfer} event.
436      */
437     function transferFrom(
438         address from,
439         address to,
440         uint256 tokenId
441     ) external;
442 
443     /**
444      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
445      * The approval is cleared when the token is transferred.
446      *
447      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
448      *
449      * Requirements:
450      *
451      * - The caller must own the token or be an approved operator.
452      * - `tokenId` must exist.
453      *
454      * Emits an {Approval} event.
455      */
456     function approve(address to, uint256 tokenId) external;
457 
458     /**
459      * @dev Approve or remove `operator` as an operator for the caller.
460      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
461      *
462      * Requirements:
463      *
464      * - The `operator` cannot be the caller.
465      *
466      * Emits an {ApprovalForAll} event.
467      */
468     function setApprovalForAll(address operator, bool _approved) external;
469 
470     /**
471      * @dev Returns the account approved for `tokenId` token.
472      *
473      * Requirements:
474      *
475      * - `tokenId` must exist.
476      */
477     function getApproved(uint256 tokenId) external view returns (address operator);
478 
479     /**
480      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
481      *
482      * See {setApprovalForAll}
483      */
484     function isApprovedForAll(address owner, address operator) external view returns (bool);
485 
486     // ==============================
487     //        IERC721Metadata
488     // ==============================
489 
490     /**
491      * @dev Returns the token collection name.
492      */
493     function name() external view returns (string memory);
494 
495     /**
496      * @dev Returns the token collection symbol.
497      */
498     function symbol() external view returns (string memory);
499 
500     /**
501      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
502      */
503     function tokenURI(uint256 tokenId) external view returns (string memory);
504 }
505 
506 // File: erc721a/contracts/ERC721A.sol
507 
508 
509 // ERC721A Contracts v4.0.0
510 // Creator: Chiru Labs
511 
512 pragma solidity ^0.8.4;
513 
514 
515 /**
516  * @dev ERC721 token receiver interface.
517  */
518 interface ERC721A__IERC721Receiver {
519     function onERC721Received(
520         address operator,
521         address from,
522         uint256 tokenId,
523         bytes calldata data
524     ) external returns (bytes4);
525 }
526 
527 /**
528  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
529  * the Metadata extension. Built to optimize for lower gas during batch mints.
530  *
531  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
532  *
533  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
534  *
535  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
536  */
537 contract ERC721A is IERC721A {
538     // Mask of an entry in packed address data.
539     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
540 
541     // The bit position of `numberMinted` in packed address data.
542     uint256 private constant BITPOS_NUMBER_MINTED = 64;
543 
544     // The bit position of `numberBurned` in packed address data.
545     uint256 private constant BITPOS_NUMBER_BURNED = 128;
546 
547     // The bit position of `aux` in packed address data.
548     uint256 private constant BITPOS_AUX = 192;
549 
550     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
551     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
552 
553     // The bit position of `startTimestamp` in packed ownership.
554     uint256 private constant BITPOS_START_TIMESTAMP = 160;
555 
556     // The bit mask of the `burned` bit in packed ownership.
557     uint256 private constant BITMASK_BURNED = 1 << 224;
558     
559     // The bit position of the `nextInitialized` bit in packed ownership.
560     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
561 
562     // The bit mask of the `nextInitialized` bit in packed ownership.
563     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
564 
565     // The tokenId of the next token to be minted.
566     uint256 private _currentIndex;
567 
568     // The number of tokens burned.
569     uint256 private _burnCounter;
570 
571     // Token name
572     string private _name;
573 
574     // Token symbol
575     string private _symbol;
576 
577     // Mapping from token ID to ownership details
578     // An empty struct value does not necessarily mean the token is unowned.
579     // See `_packedOwnershipOf` implementation for details.
580     //
581     // Bits Layout:
582     // - [0..159]   `addr`
583     // - [160..223] `startTimestamp`
584     // - [224]      `burned`
585     // - [225]      `nextInitialized`
586     mapping(uint256 => uint256) private _packedOwnerships;
587 
588     // Mapping owner address to address data.
589     //
590     // Bits Layout:
591     // - [0..63]    `balance`
592     // - [64..127]  `numberMinted`
593     // - [128..191] `numberBurned`
594     // - [192..255] `aux`
595     mapping(address => uint256) private _packedAddressData;
596 
597     // Mapping from token ID to approved address.
598     mapping(uint256 => address) private _tokenApprovals;
599 
600     // Mapping from owner to operator approvals
601     mapping(address => mapping(address => bool)) private _operatorApprovals;
602 
603     constructor(string memory name_, string memory symbol_) {
604         _name = name_;
605         _symbol = symbol_;
606         _currentIndex = _startTokenId();
607     }
608 
609     /**
610      * @dev Returns the starting token ID. 
611      * To change the starting token ID, please override this function.
612      */
613     function _startTokenId() internal view virtual returns (uint256) {
614         return 0;
615     }
616 
617     /**
618      * @dev Returns the next token ID to be minted.
619      */
620     function _nextTokenId() internal view returns (uint256) {
621         return _currentIndex;
622     }
623 
624     /**
625      * @dev Returns the total number of tokens in existence.
626      * Burned tokens will reduce the count. 
627      * To get the total number of tokens minted, please see `_totalMinted`.
628      */
629     function totalSupply() public view override returns (uint256) {
630         // Counter underflow is impossible as _burnCounter cannot be incremented
631         // more than `_currentIndex - _startTokenId()` times.
632         unchecked {
633             return _currentIndex - _burnCounter - _startTokenId();
634         }
635     }
636 
637     /**
638      * @dev Returns the total amount of tokens minted in the contract.
639      */
640     function _totalMinted() internal view returns (uint256) {
641         // Counter underflow is impossible as _currentIndex does not decrement,
642         // and it is initialized to `_startTokenId()`
643         unchecked {
644             return _currentIndex - _startTokenId();
645         }
646     }
647 
648     /**
649      * @dev Returns the total number of tokens burned.
650      */
651     function _totalBurned() internal view returns (uint256) {
652         return _burnCounter;
653     }
654 
655     /**
656      * @dev See {IERC165-supportsInterface}.
657      */
658     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
659         // The interface IDs are constants representing the first 4 bytes of the XOR of
660         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
661         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
662         return
663             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
664             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
665             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
666     }
667 
668     /**
669      * @dev See {IERC721-balanceOf}.
670      */
671     function balanceOf(address owner) public view override returns (uint256) {
672         if (owner == address(0)) revert BalanceQueryForZeroAddress();
673         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
674     }
675 
676     /**
677      * Returns the number of tokens minted by `owner`.
678      */
679     function _numberMinted(address owner) internal view returns (uint256) {
680         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
681     }
682 
683     /**
684      * Returns the number of tokens burned by or on behalf of `owner`.
685      */
686     function _numberBurned(address owner) internal view returns (uint256) {
687         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
688     }
689 
690     /**
691      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
692      */
693     function _getAux(address owner) internal view returns (uint64) {
694         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
695     }
696 
697     /**
698      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
699      * If there are multiple variables, please pack them into a uint64.
700      */
701     function _setAux(address owner, uint64 aux) internal {
702         uint256 packed = _packedAddressData[owner];
703         uint256 auxCasted;
704         assembly { // Cast aux without masking.
705             auxCasted := aux
706         }
707         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
708         _packedAddressData[owner] = packed;
709     }
710 
711     /**
712      * Returns the packed ownership data of `tokenId`.
713      */
714     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
715         uint256 curr = tokenId;
716 
717         unchecked {
718             if (_startTokenId() <= curr)
719                 if (curr < _currentIndex) {
720                     uint256 packed = _packedOwnerships[curr];
721                     // If not burned.
722                     if (packed & BITMASK_BURNED == 0) {
723                         // Invariant:
724                         // There will always be an ownership that has an address and is not burned
725                         // before an ownership that does not have an address and is not burned.
726                         // Hence, curr will not underflow.
727                         //
728                         // We can directly compare the packed value.
729                         // If the address is zero, packed is zero.
730                         while (packed == 0) {
731                             packed = _packedOwnerships[--curr];
732                         }
733                         return packed;
734                     }
735                 }
736         }
737         revert OwnerQueryForNonexistentToken();
738     }
739 
740     /**
741      * Returns the unpacked `TokenOwnership` struct from `packed`.
742      */
743     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
744         ownership.addr = address(uint160(packed));
745         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
746         ownership.burned = packed & BITMASK_BURNED != 0;
747     }
748 
749     /**
750      * Returns the unpacked `TokenOwnership` struct at `index`.
751      */
752     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
753         return _unpackedOwnership(_packedOwnerships[index]);
754     }
755 
756     /**
757      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
758      */
759     function _initializeOwnershipAt(uint256 index) internal {
760         if (_packedOwnerships[index] == 0) {
761             _packedOwnerships[index] = _packedOwnershipOf(index);
762         }
763     }
764 
765     /**
766      * Gas spent here starts off proportional to the maximum mint batch size.
767      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
768      */
769     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
770         return _unpackedOwnership(_packedOwnershipOf(tokenId));
771     }
772 
773     /**
774      * @dev See {IERC721-ownerOf}.
775      */
776     function ownerOf(uint256 tokenId) public view override returns (address) {
777         return address(uint160(_packedOwnershipOf(tokenId)));
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-name}.
782      */
783     function name() public view virtual override returns (string memory) {
784         return _name;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-symbol}.
789      */
790     function symbol() public view virtual override returns (string memory) {
791         return _symbol;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-tokenURI}.
796      */
797     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
798         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
799 
800         string memory baseURI = _baseURI();
801         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
802     }
803 
804     /**
805      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
806      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
807      * by default, can be overriden in child contracts.
808      */
809     function _baseURI() internal view virtual returns (string memory) {
810         return '';
811     }
812 
813     /**
814      * @dev Casts the address to uint256 without masking.
815      */
816     function _addressToUint256(address value) private pure returns (uint256 result) {
817         assembly {
818             result := value
819         }
820     }
821 
822     /**
823      * @dev Casts the boolean to uint256 without branching.
824      */
825     function _boolToUint256(bool value) private pure returns (uint256 result) {
826         assembly {
827             result := value
828         }
829     }
830 
831     /**
832      * @dev See {IERC721-approve}.
833      */
834     function approve(address to, uint256 tokenId) public override {
835         address owner = address(uint160(_packedOwnershipOf(tokenId)));
836         if (to == owner) revert ApprovalToCurrentOwner();
837 
838         if (_msgSenderERC721A() != owner)
839             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
840                 revert ApprovalCallerNotOwnerNorApproved();
841             }
842 
843         _tokenApprovals[tokenId] = to;
844         emit Approval(owner, to, tokenId);
845     }
846 
847     /**
848      * @dev See {IERC721-getApproved}.
849      */
850     function getApproved(uint256 tokenId) public view override returns (address) {
851         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
852 
853         return _tokenApprovals[tokenId];
854     }
855 
856     /**
857      * @dev See {IERC721-setApprovalForAll}.
858      */
859     function setApprovalForAll(address operator, bool approved) public virtual override {
860         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
861 
862         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
863         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         _transfer(from, to, tokenId);
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public virtual override {
892         safeTransferFrom(from, to, tokenId, '');
893     }
894 
895     /**
896      * @dev See {IERC721-safeTransferFrom}.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) public virtual override {
904         _transfer(from, to, tokenId);
905         if (to.code.length != 0)
906             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
907                 revert TransferToNonERC721ReceiverImplementer();
908             }
909     }
910 
911     /**
912      * @dev Returns whether `tokenId` exists.
913      *
914      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
915      *
916      * Tokens start existing when they are minted (`_mint`),
917      */
918     function _exists(uint256 tokenId) internal view returns (bool) {
919         return
920             _startTokenId() <= tokenId &&
921             tokenId < _currentIndex && // If within bounds,
922             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
923     }
924 
925     /**
926      * @dev Equivalent to `_safeMint(to, quantity, '')`.
927      */
928     function _safeMint(address to, uint256 quantity) internal {
929         _safeMint(to, quantity, '');
930     }
931 
932     /**
933      * @dev Safely mints `quantity` tokens and transfers them to `to`.
934      *
935      * Requirements:
936      *
937      * - If `to` refers to a smart contract, it must implement
938      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
939      * - `quantity` must be greater than 0.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeMint(
944         address to,
945         uint256 quantity,
946         bytes memory _data
947     ) internal {
948         uint256 startTokenId = _currentIndex;
949         if (to == address(0)) revert MintToZeroAddress();
950         if (quantity == 0) revert MintZeroQuantity();
951 
952         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
953 
954         // Overflows are incredibly unrealistic.
955         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
956         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
957         unchecked {
958             // Updates:
959             // - `balance += quantity`.
960             // - `numberMinted += quantity`.
961             //
962             // We can directly add to the balance and number minted.
963             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
964 
965             // Updates:
966             // - `address` to the owner.
967             // - `startTimestamp` to the timestamp of minting.
968             // - `burned` to `false`.
969             // - `nextInitialized` to `quantity == 1`.
970             _packedOwnerships[startTokenId] =
971                 _addressToUint256(to) |
972                 (block.timestamp << BITPOS_START_TIMESTAMP) |
973                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
974 
975             uint256 updatedIndex = startTokenId;
976             uint256 end = updatedIndex + quantity;
977 
978             if (to.code.length != 0) {
979                 do {
980                     emit Transfer(address(0), to, updatedIndex);
981                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
982                         revert TransferToNonERC721ReceiverImplementer();
983                     }
984                 } while (updatedIndex < end);
985                 // Reentrancy protection
986                 if (_currentIndex != startTokenId) revert();
987             } else {
988                 do {
989                     emit Transfer(address(0), to, updatedIndex++);
990                 } while (updatedIndex < end);
991             }
992             _currentIndex = updatedIndex;
993         }
994         _afterTokenTransfers(address(0), to, startTokenId, quantity);
995     }
996 
997     /**
998      * @dev Mints `quantity` tokens and transfers them to `to`.
999      *
1000      * Requirements:
1001      *
1002      * - `to` cannot be the zero address.
1003      * - `quantity` must be greater than 0.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _mint(address to, uint256 quantity) internal {
1008         uint256 startTokenId = _currentIndex;
1009         if (to == address(0)) revert MintToZeroAddress();
1010         if (quantity == 0) revert MintZeroQuantity();
1011 
1012         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1013 
1014         // Overflows are incredibly unrealistic.
1015         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1016         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1017         unchecked {
1018             // Updates:
1019             // - `balance += quantity`.
1020             // - `numberMinted += quantity`.
1021             //
1022             // We can directly add to the balance and number minted.
1023             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1024 
1025             // Updates:
1026             // - `address` to the owner.
1027             // - `startTimestamp` to the timestamp of minting.
1028             // - `burned` to `false`.
1029             // - `nextInitialized` to `quantity == 1`.
1030             _packedOwnerships[startTokenId] =
1031                 _addressToUint256(to) |
1032                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1033                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1034 
1035             uint256 updatedIndex = startTokenId;
1036             uint256 end = updatedIndex + quantity;
1037 
1038             do {
1039                 emit Transfer(address(0), to, updatedIndex++);
1040             } while (updatedIndex < end);
1041 
1042             _currentIndex = updatedIndex;
1043         }
1044         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1045     }
1046 
1047     /**
1048      * @dev Transfers `tokenId` from `from` to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `tokenId` token must be owned by `from`.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _transfer(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) private {
1062         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1063 
1064         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1065 
1066         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1067             isApprovedForAll(from, _msgSenderERC721A()) ||
1068             getApproved(tokenId) == _msgSenderERC721A());
1069 
1070         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1071         if (to == address(0)) revert TransferToZeroAddress();
1072 
1073         _beforeTokenTransfers(from, to, tokenId, 1);
1074 
1075         // Clear approvals from the previous owner.
1076         delete _tokenApprovals[tokenId];
1077 
1078         // Underflow of the sender's balance is impossible because we check for
1079         // ownership above and the recipient's balance can't realistically overflow.
1080         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1081         unchecked {
1082             // We can directly increment and decrement the balances.
1083             --_packedAddressData[from]; // Updates: `balance -= 1`.
1084             ++_packedAddressData[to]; // Updates: `balance += 1`.
1085 
1086             // Updates:
1087             // - `address` to the next owner.
1088             // - `startTimestamp` to the timestamp of transfering.
1089             // - `burned` to `false`.
1090             // - `nextInitialized` to `true`.
1091             _packedOwnerships[tokenId] =
1092                 _addressToUint256(to) |
1093                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1094                 BITMASK_NEXT_INITIALIZED;
1095 
1096             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1097             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1098                 uint256 nextTokenId = tokenId + 1;
1099                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1100                 if (_packedOwnerships[nextTokenId] == 0) {
1101                     // If the next slot is within bounds.
1102                     if (nextTokenId != _currentIndex) {
1103                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1104                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1105                     }
1106                 }
1107             }
1108         }
1109 
1110         emit Transfer(from, to, tokenId);
1111         _afterTokenTransfers(from, to, tokenId, 1);
1112     }
1113 
1114     /**
1115      * @dev Equivalent to `_burn(tokenId, false)`.
1116      */
1117     function _burn(uint256 tokenId) internal virtual {
1118         _burn(tokenId, false);
1119     }
1120 
1121     /**
1122      * @dev Destroys `tokenId`.
1123      * The approval is cleared when the token is burned.
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must exist.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1132         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1133 
1134         address from = address(uint160(prevOwnershipPacked));
1135 
1136         if (approvalCheck) {
1137             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1138                 isApprovedForAll(from, _msgSenderERC721A()) ||
1139                 getApproved(tokenId) == _msgSenderERC721A());
1140 
1141             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1142         }
1143 
1144         _beforeTokenTransfers(from, address(0), tokenId, 1);
1145 
1146         // Clear approvals from the previous owner.
1147         delete _tokenApprovals[tokenId];
1148 
1149         // Underflow of the sender's balance is impossible because we check for
1150         // ownership above and the recipient's balance can't realistically overflow.
1151         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1152         unchecked {
1153             // Updates:
1154             // - `balance -= 1`.
1155             // - `numberBurned += 1`.
1156             //
1157             // We can directly decrement the balance, and increment the number burned.
1158             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1159             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1160 
1161             // Updates:
1162             // - `address` to the last owner.
1163             // - `startTimestamp` to the timestamp of burning.
1164             // - `burned` to `true`.
1165             // - `nextInitialized` to `true`.
1166             _packedOwnerships[tokenId] =
1167                 _addressToUint256(from) |
1168                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1169                 BITMASK_BURNED | 
1170                 BITMASK_NEXT_INITIALIZED;
1171 
1172             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1173             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1174                 uint256 nextTokenId = tokenId + 1;
1175                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1176                 if (_packedOwnerships[nextTokenId] == 0) {
1177                     // If the next slot is within bounds.
1178                     if (nextTokenId != _currentIndex) {
1179                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1180                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1181                     }
1182                 }
1183             }
1184         }
1185 
1186         emit Transfer(from, address(0), tokenId);
1187         _afterTokenTransfers(from, address(0), tokenId, 1);
1188 
1189         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1190         unchecked {
1191             _burnCounter++;
1192         }
1193     }
1194 
1195     /**
1196      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1197      *
1198      * @param from address representing the previous owner of the given token ID
1199      * @param to target address that will receive the tokens
1200      * @param tokenId uint256 ID of the token to be transferred
1201      * @param _data bytes optional data to send along with the call
1202      * @return bool whether the call correctly returned the expected magic value
1203      */
1204     function _checkContractOnERC721Received(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) private returns (bool) {
1210         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1211             bytes4 retval
1212         ) {
1213             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1214         } catch (bytes memory reason) {
1215             if (reason.length == 0) {
1216                 revert TransferToNonERC721ReceiverImplementer();
1217             } else {
1218                 assembly {
1219                     revert(add(32, reason), mload(reason))
1220                 }
1221             }
1222         }
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1227      * And also called before burning one token.
1228      *
1229      * startTokenId - the first token id to be transferred
1230      * quantity - the amount to be transferred
1231      *
1232      * Calling conditions:
1233      *
1234      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1235      * transferred to `to`.
1236      * - When `from` is zero, `tokenId` will be minted for `to`.
1237      * - When `to` is zero, `tokenId` will be burned by `from`.
1238      * - `from` and `to` are never both zero.
1239      */
1240     function _beforeTokenTransfers(
1241         address from,
1242         address to,
1243         uint256 startTokenId,
1244         uint256 quantity
1245     ) internal virtual {}
1246 
1247     /**
1248      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1249      * minting.
1250      * And also called after one token has been burned.
1251      *
1252      * startTokenId - the first token id to be transferred
1253      * quantity - the amount to be transferred
1254      *
1255      * Calling conditions:
1256      *
1257      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1258      * transferred to `to`.
1259      * - When `from` is zero, `tokenId` has been minted for `to`.
1260      * - When `to` is zero, `tokenId` has been burned by `from`.
1261      * - `from` and `to` are never both zero.
1262      */
1263     function _afterTokenTransfers(
1264         address from,
1265         address to,
1266         uint256 startTokenId,
1267         uint256 quantity
1268     ) internal virtual {}
1269 
1270     /**
1271      * @dev Returns the message sender (defaults to `msg.sender`).
1272      *
1273      * If you are writing GSN compatible contracts, you need to override this function.
1274      */
1275     function _msgSenderERC721A() internal view virtual returns (address) {
1276         return msg.sender;
1277     }
1278 
1279     /**
1280      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1281      */
1282     function _toString(uint256 value) internal pure returns (string memory ptr) {
1283         assembly {
1284             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1285             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1286             // We will need 1 32-byte word to store the length, 
1287             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1288             ptr := add(mload(0x40), 128)
1289             // Update the free memory pointer to allocate.
1290             mstore(0x40, ptr)
1291 
1292             // Cache the end of the memory to calculate the length later.
1293             let end := ptr
1294 
1295             // We write the string from the rightmost digit to the leftmost digit.
1296             // The following is essentially a do-while loop that also handles the zero case.
1297             // Costs a bit more than early returning for the zero case,
1298             // but cheaper in terms of deployment and overall runtime costs.
1299             for { 
1300                 // Initialize and perform the first pass without check.
1301                 let temp := value
1302                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1303                 ptr := sub(ptr, 1)
1304                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1305                 mstore8(ptr, add(48, mod(temp, 10)))
1306                 temp := div(temp, 10)
1307             } temp { 
1308                 // Keep dividing `temp` until zero.
1309                 temp := div(temp, 10)
1310             } { // Body of the for loop.
1311                 ptr := sub(ptr, 1)
1312                 mstore8(ptr, add(48, mod(temp, 10)))
1313             }
1314             
1315             let length := sub(end, ptr)
1316             // Move the pointer 32 bytes leftwards to make room for the length.
1317             ptr := sub(ptr, 32)
1318             // Store the length.
1319             mstore(ptr, length)
1320         }
1321     }
1322 }
1323 
1324 // File: contracts/test.sol
1325 
1326 
1327 pragma solidity ^0.8.2;
1328 
1329 
1330 
1331 
1332 
1333 contract nazgultown is ERC721A, Ownable, ReentrancyGuard {  
1334     using Strings for uint256;
1335     string public _nazgulUri;
1336     bool public sale_open = true;
1337     uint256 public nazguls = 10000;
1338     uint256 public free_nazguls_per_wallet = 4; 
1339     uint256 public nazguls_per_wallet = 100;
1340     uint256 public free_nazguls = 4000;
1341     uint256 public price = 0.0088 ether;
1342     mapping(address => uint256) public howmanynazguls;
1343    
1344 	constructor() ERC721A("nazgultown", "NAZGUL") {}
1345 
1346     function _baseURI() internal view virtual override returns (string memory) {
1347         return _nazgulUri;
1348     }
1349 
1350  	function mint(uint256 quantity) public payable {
1351         uint256 cost = price * quantity;
1352   	    uint256 totalnazguls = totalSupply();
1353         require(sale_open);
1354         require(totalnazguls + quantity <= nazguls);
1355         require(howmanynazguls[msg.sender] < nazguls_per_wallet);
1356 
1357         if(totalnazguls < free_nazguls && howmanynazguls[msg.sender] < free_nazguls_per_wallet) {
1358             if(quantity >= free_nazguls_per_wallet) {
1359                 uint256 nazguls_to_pay = quantity - (free_nazguls_per_wallet - howmanynazguls[msg.sender]);
1360                 cost = price * nazguls_to_pay;
1361             }
1362         }
1363         else {
1364             require(msg.value >= cost, "Not enough supply.");
1365         }
1366         _safeMint(msg.sender, quantity);
1367         howmanynazguls[msg.sender] += quantity;
1368     }
1369 
1370  	function mintForAnotherNazgul(address slayers, uint256 _nazguls) public onlyOwner {
1371   	    uint256 totalnazguls = totalSupply();
1372 	    require(totalnazguls + _nazguls <= nazguls);
1373         _safeMint(slayers, _nazguls);
1374     }
1375 
1376     function openNazgulSale(bool _state) external onlyOwner {
1377         sale_open = _state;
1378     }
1379 
1380     function setNazguls(uint256 _nazguls) external onlyOwner {
1381         nazguls = _nazguls;
1382     }
1383 
1384     function setFreeNazguls(uint256 _freeNazguls) external onlyOwner {
1385         free_nazguls = _freeNazguls;
1386     }
1387 
1388     function setNazgulUri(string memory uri) external onlyOwner {
1389         _nazgulUri = uri;
1390     }
1391 
1392     function withdraw() public payable onlyOwner {
1393 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1394 		require(success);
1395 	}
1396 }