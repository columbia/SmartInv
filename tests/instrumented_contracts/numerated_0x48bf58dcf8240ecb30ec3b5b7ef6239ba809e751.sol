1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-11
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity ^0.8.9;
9 contract TestContract {
10 // Some logic
11 }
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Contract module that helps prevent reentrant calls to a function.
89  *
90  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
91  * available, which can be applied to functions to make sure there are no nested
92  * (reentrant) calls to them.
93  *
94  * Note that because there is a single `nonReentrant` guard, functions marked as
95  * `nonReentrant` may not call one another. This can be worked around by making
96  * those functions `private`, and then adding `external` `nonReentrant` entry
97  * points to them.
98  *
99  * TIP: If you would like to learn more about reentrancy and alternative ways
100  * to protect against it, check out our blog post
101  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
102  */
103 abstract contract ReentrancyGuard {
104     // Booleans are more expensive than uint256 or any type that takes up a full
105     // word because each write operation emits an extra SLOAD to first read the
106     // slot's contents, replace the bits taken up by the boolean, and then write
107     // back. This is the compiler's defense against contract upgrades and
108     // pointer aliasing, and it cannot be disabled.
109 
110     // The values being non-zero value makes deployment a bit more expensive,
111     // but in exchange the refund on every call to nonReentrant will be lower in
112     // amount. Since refunds are capped to a percentage of the total
113     // transaction's gas, it is best to keep them low in cases like this one, to
114     // increase the likelihood of the full refund coming into effect.
115     uint256 private constant _NOT_ENTERED = 1;
116     uint256 private constant _ENTERED = 2;
117 
118     uint256 private _status;
119 
120     constructor() {
121         _status = _NOT_ENTERED;
122     }
123 
124     /**
125      * @dev Prevents a contract from calling itself, directly or indirectly.
126      * Calling a `nonReentrant` function from another `nonReentrant`
127      * function is not supported. It is possible to prevent this from happening
128      * by making the `nonReentrant` function external, and making it call a
129      * `private` function that does the actual work.
130      */
131     modifier nonReentrant() {
132         // On the first call to nonReentrant, _notEntered will be true
133         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
134 
135         // Any calls to nonReentrant after this point will fail
136         _status = _ENTERED;
137 
138         _;
139 
140         // By storing the original value once again, a refund is triggered (see
141         // https://eips.ethereum.org/EIPS/eip-2200)
142         _status = _NOT_ENTERED;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/Context.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes calldata) {
169         return msg.data;
170     }
171 }
172 
173 // File: @openzeppelin/contracts/access/Ownable.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 
181 /**
182  * @dev Contract module which provides a basic access control mechanism, where
183  * there is an account (an owner) that can be granted exclusive access to
184  * specific functions.
185  *
186  * By default, the owner account will be the one that deploys the contract. This
187  * can later be changed with {transferOwnership}.
188  *
189  * This module is used through inheritance. It will make available the modifier
190  * `onlyOwner`, which can be applied to your functions to restrict their use to
191  * the owner.
192  */
193 abstract contract Ownable is Context {
194     address private _owner;
195 
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198     /**
199      * @dev Initializes the contract setting the deployer as the initial owner.
200      */
201     constructor() {
202         _transferOwnership(_msgSender());
203     }
204 
205     /**
206      * @dev Returns the address of the current owner.
207      */
208     function owner() public view virtual returns (address) {
209         return _owner;
210     }
211 
212     /**
213      * @dev Throws if called by any account other than the owner.
214      */
215     modifier onlyOwner() {
216         require(owner() == _msgSender(), "Ownable: caller is not the owner");
217         _;
218     }
219 
220     /**
221      * @dev Leaves the contract without owner. It will not be possible to call
222      * `onlyOwner` functions anymore. Can only be called by the current owner.
223      *
224      * NOTE: Renouncing ownership will leave the contract without an owner,
225      * thereby removing any functionality that is only available to the owner.
226      */
227     function renounceOwnership() public virtual onlyOwner {
228         _transferOwnership(address(0));
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Can only be called by the current owner.
234      */
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(newOwner != address(0), "Ownable: new owner is the zero address");
237         _transferOwnership(newOwner);
238     }
239 
240     /**
241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
242      * Internal function without access restriction.
243      */
244     function _transferOwnership(address newOwner) internal virtual {
245         address oldOwner = _owner;
246         _owner = newOwner;
247         emit OwnershipTransferred(oldOwner, newOwner);
248     }
249 }
250 
251 // File: erc721a/contracts/IERC721A.sol
252 
253 
254 // ERC721A Contracts v4.0.0
255 // Creator: Chiru Labs
256 
257 pragma solidity ^0.8.4;
258 
259 /**
260  * @dev Interface of an ERC721A compliant contract.
261  */
262 interface IERC721A {
263     /**
264      * The caller must own the token or be an approved operator.
265      */
266     error ApprovalCallerNotOwnerNorApproved();
267 
268     /**
269      * The token does not exist.
270      */
271     error ApprovalQueryForNonexistentToken();
272 
273     /**
274      * The caller cannot approve to their own address.
275      */
276     error ApproveToCaller();
277 
278     /**
279      * The caller cannot approve to the current owner.
280      */
281     error ApprovalToCurrentOwner();
282 
283     /**
284      * Cannot query the balance for the zero address.
285      */
286     error BalanceQueryForZeroAddress();
287 
288     /**
289      * Cannot mint to the zero address.
290      */
291     error MintToZeroAddress();
292 
293     /**
294      * The quantity of tokens minted must be more than zero.
295      */
296     error MintZeroQuantity();
297 
298     /**
299      * The token does not exist.
300      */
301     error OwnerQueryForNonexistentToken();
302 
303     /**
304      * The caller must own the token or be an approved operator.
305      */
306     error TransferCallerNotOwnerNorApproved();
307 
308     /**
309      * The token must be owned by `from`.
310      */
311     error TransferFromIncorrectOwner();
312 
313     /**
314      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
315      */
316     error TransferToNonERC721ReceiverImplementer();
317 
318     /**
319      * Cannot transfer to the zero address.
320      */
321     error TransferToZeroAddress();
322 
323     /**
324      * The token does not exist.
325      */
326     error URIQueryForNonexistentToken();
327 
328     struct TokenOwnership {
329         // The address of the owner.
330         address addr;
331         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
332         uint64 startTimestamp;
333         // Whether the token has been burned.
334         bool burned;
335     }
336 
337     /**
338      * @dev Returns the total amount of tokens stored by the contract.
339      *
340      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
341      */
342     function totalSupply() external view returns (uint256);
343 
344     // ==============================
345     //            IERC165
346     // ==============================
347 
348     /**
349      * @dev Returns true if this contract implements the interface defined by
350      * `interfaceId`. See the corresponding
351      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
352      * to learn more about how these ids are created.
353      *
354      * This function call must use less than 30 000 gas.
355      */
356     function supportsInterface(bytes4 interfaceId) external view returns (bool);
357 
358     // ==============================
359     //            IERC721
360     // ==============================
361 
362     /**
363      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
364      */
365     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
366 
367     /**
368      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
369      */
370     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
371 
372     /**
373      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
374      */
375     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
376 
377     /**
378      * @dev Returns the number of tokens in ``owner``'s account.
379      */
380     function balanceOf(address owner) external view returns (uint256 balance);
381 
382     /**
383      * @dev Returns the owner of the `tokenId` token.
384      *
385      * Requirements:
386      *
387      * - `tokenId` must exist.
388      */
389     function ownerOf(uint256 tokenId) external view returns (address owner);
390 
391     /**
392      * @dev Safely transfers `tokenId` token from `from` to `to`.
393      *
394      * Requirements:
395      *
396      * - `from` cannot be the zero address.
397      * - `to` cannot be the zero address.
398      * - `tokenId` token must exist and be owned by `from`.
399      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
400      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
401      *
402      * Emits a {Transfer} event.
403      */
404     function safeTransferFrom(
405         address from,
406         address to,
407         uint256 tokenId,
408         bytes calldata data
409     ) external;
410 
411     /**
412      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
413      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
414      *
415      * Requirements:
416      *
417      * - `from` cannot be the zero address.
418      * - `to` cannot be the zero address.
419      * - `tokenId` token must exist and be owned by `from`.
420      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
421      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
422      *
423      * Emits a {Transfer} event.
424      */
425     function safeTransferFrom(
426         address from,
427         address to,
428         uint256 tokenId
429     ) external;
430 
431     /**
432      * @dev Transfers `tokenId` token from `from` to `to`.
433      *
434      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `tokenId` token must be owned by `from`.
441      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
442      *
443      * Emits a {Transfer} event.
444      */
445     function transferFrom(
446         address from,
447         address to,
448         uint256 tokenId
449     ) external;
450 
451     /**
452      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
453      * The approval is cleared when the token is transferred.
454      *
455      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
456      *
457      * Requirements:
458      *
459      * - The caller must own the token or be an approved operator.
460      * - `tokenId` must exist.
461      *
462      * Emits an {Approval} event.
463      */
464     function approve(address to, uint256 tokenId) external;
465 
466     /**
467      * @dev Approve or remove `operator` as an operator for the caller.
468      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
469      *
470      * Requirements:
471      *
472      * - The `operator` cannot be the caller.
473      *
474      * Emits an {ApprovalForAll} event.
475      */
476     function setApprovalForAll(address operator, bool _approved) external;
477 
478     /**
479      * @dev Returns the account approved for `tokenId` token.
480      *
481      * Requirements:
482      *
483      * - `tokenId` must exist.
484      */
485     function getApproved(uint256 tokenId) external view returns (address operator);
486 
487     /**
488      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
489      *
490      * See {setApprovalForAll}
491      */
492     function isApprovedForAll(address owner, address operator) external view returns (bool);
493 
494     // ==============================
495     //        IERC721Metadata
496     // ==============================
497 
498     /**
499      * @dev Returns the token collection name.
500      */
501     function name() external view returns (string memory);
502 
503     /**
504      * @dev Returns the token collection symbol.
505      */
506     function symbol() external view returns (string memory);
507 
508     /**
509      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
510      */
511     function tokenURI(uint256 tokenId) external view returns (string memory);
512 }
513 
514 // File: erc721a/contracts/ERC721A.sol
515 
516 
517 // ERC721A Contracts v4.0.0
518 // Creator: Chiru Labs
519 
520 pragma solidity ^0.8.4;
521 
522 
523 /**
524  * @dev ERC721 token receiver interface.
525  */
526 interface ERC721A__IERC721Receiver {
527     function onERC721Received(
528         address operator,
529         address from,
530         uint256 tokenId,
531         bytes calldata data
532     ) external returns (bytes4);
533 }
534 
535 /**
536  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
537  * the Metadata extension. Built to optimize for lower gas during batch mints.
538  *
539  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
540  *
541  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
542  *
543  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
544  */
545 contract ERC721A is IERC721A {
546     // Mask of an entry in packed address data.
547     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
548 
549     // The bit position of `numberMinted` in packed address data.
550     uint256 private constant BITPOS_NUMBER_MINTED = 64;
551 
552     // The bit position of `numberBurned` in packed address data.
553     uint256 private constant BITPOS_NUMBER_BURNED = 128;
554 
555     // The bit position of `aux` in packed address data.
556     uint256 private constant BITPOS_AUX = 192;
557 
558     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
559     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
560 
561     // The bit position of `startTimestamp` in packed ownership.
562     uint256 private constant BITPOS_START_TIMESTAMP = 160;
563 
564     // The bit mask of the `burned` bit in packed ownership.
565     uint256 private constant BITMASK_BURNED = 1 << 224;
566     
567     // The bit position of the `nextInitialized` bit in packed ownership.
568     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
569 
570     // The bit mask of the `nextInitialized` bit in packed ownership.
571     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
572 
573     // The tokenId of the next token to be minted.
574     uint256 private _currentIndex;
575 
576     // The number of tokens burned.
577     uint256 private _burnCounter;
578 
579     // Token name
580     string private _name;
581 
582     // Token symbol
583     string private _symbol;
584 
585     // Mapping from token ID to ownership details
586     // An empty struct value does not necessarily mean the token is unowned.
587     // See `_packedOwnershipOf` implementation for details.
588     //
589     // Bits Layout:
590     // - [0..159]   `addr`
591     // - [160..223] `startTimestamp`
592     // - [224]      `burned`
593     // - [225]      `nextInitialized`
594     mapping(uint256 => uint256) private _packedOwnerships;
595 
596     // Mapping owner address to address data.
597     //
598     // Bits Layout:
599     // - [0..63]    `balance`
600     // - [64..127]  `numberMinted`
601     // - [128..191] `numberBurned`
602     // - [192..255] `aux`
603     mapping(address => uint256) private _packedAddressData;
604 
605     // Mapping from token ID to approved address.
606     mapping(uint256 => address) private _tokenApprovals;
607 
608     // Mapping from owner to operator approvals
609     mapping(address => mapping(address => bool)) private _operatorApprovals;
610 
611     constructor(string memory name_, string memory symbol_) {
612         _name = name_;
613         _symbol = symbol_;
614         _currentIndex = _startTokenId();
615     }
616 
617     /**
618      * @dev Returns the starting token ID. 
619      * To change the starting token ID, please override this function.
620      */
621     function _startTokenId() internal view virtual returns (uint256) {
622         return 0;
623     }
624 
625     /**
626      * @dev Returns the next token ID to be minted.
627      */
628     function _nextTokenId() internal view returns (uint256) {
629         return _currentIndex;
630     }
631 
632     /**
633      * @dev Returns the total number of tokens in existence.
634      * Burned tokens will reduce the count. 
635      * To get the total number of tokens minted, please see `_totalMinted`.
636      */
637     function totalSupply() public view override returns (uint256) {
638         // Counter underflow is impossible as _burnCounter cannot be incremented
639         // more than `_currentIndex - _startTokenId()` times.
640         unchecked {
641             return _currentIndex - _burnCounter - _startTokenId();
642         }
643     }
644 
645     /**
646      * @dev Returns the total amount of tokens minted in the contract.
647      */
648     function _totalMinted() internal view returns (uint256) {
649         // Counter underflow is impossible as _currentIndex does not decrement,
650         // and it is initialized to `_startTokenId()`
651         unchecked {
652             return _currentIndex - _startTokenId();
653         }
654     }
655 
656     /**
657      * @dev Returns the total number of tokens burned.
658      */
659     function _totalBurned() internal view returns (uint256) {
660         return _burnCounter;
661     }
662 
663     /**
664      * @dev See {IERC165-supportsInterface}.
665      */
666     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
667         // The interface IDs are constants representing the first 4 bytes of the XOR of
668         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
669         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
670         return
671             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
672             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
673             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
674     }
675 
676     /**
677      * @dev See {IERC721-balanceOf}.
678      */
679     function balanceOf(address owner) public view override returns (uint256) {
680         if (owner == address(0)) revert BalanceQueryForZeroAddress();
681         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
682     }
683 
684     /**
685      * Returns the number of tokens minted by `owner`.
686      */
687     function _numberMinted(address owner) internal view returns (uint256) {
688         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
689     }
690 
691     /**
692      * Returns the number of tokens burned by or on behalf of `owner`.
693      */
694     function _numberBurned(address owner) internal view returns (uint256) {
695         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
696     }
697 
698     /**
699      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
700      */
701     function _getAux(address owner) internal view returns (uint64) {
702         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
703     }
704 
705     /**
706      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
707      * If there are multiple variables, please pack them into a uint64.
708      */
709     function _setAux(address owner, uint64 aux) internal {
710         uint256 packed = _packedAddressData[owner];
711         uint256 auxCasted;
712         assembly { // Cast aux without masking.
713             auxCasted := aux
714         }
715         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
716         _packedAddressData[owner] = packed;
717     }
718 
719     /**
720      * Returns the packed ownership data of `tokenId`.
721      */
722     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
723         uint256 curr = tokenId;
724 
725         unchecked {
726             if (_startTokenId() <= curr)
727                 if (curr < _currentIndex) {
728                     uint256 packed = _packedOwnerships[curr];
729                     // If not burned.
730                     if (packed & BITMASK_BURNED == 0) {
731                         // Invariant:
732                         // There will always be an ownership that has an address and is not burned
733                         // before an ownership that does not have an address and is not burned.
734                         // Hence, curr will not underflow.
735                         //
736                         // We can directly compare the packed value.
737                         // If the address is zero, packed is zero.
738                         while (packed == 0) {
739                             packed = _packedOwnerships[--curr];
740                         }
741                         return packed;
742                     }
743                 }
744         }
745         revert OwnerQueryForNonexistentToken();
746     }
747 
748     /**
749      * Returns the unpacked `TokenOwnership` struct from `packed`.
750      */
751     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
752         ownership.addr = address(uint160(packed));
753         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
754         ownership.burned = packed & BITMASK_BURNED != 0;
755     }
756 
757     /**
758      * Returns the unpacked `TokenOwnership` struct at `index`.
759      */
760     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
761         return _unpackedOwnership(_packedOwnerships[index]);
762     }
763 
764     /**
765      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
766      */
767     function _initializeOwnershipAt(uint256 index) internal {
768         if (_packedOwnerships[index] == 0) {
769             _packedOwnerships[index] = _packedOwnershipOf(index);
770         }
771     }
772 
773     /**
774      * Gas spent here starts off proportional to the maximum mint batch size.
775      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
776      */
777     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
778         return _unpackedOwnership(_packedOwnershipOf(tokenId));
779     }
780 
781     /**
782      * @dev See {IERC721-ownerOf}.
783      */
784     function ownerOf(uint256 tokenId) public view override returns (address) {
785         return address(uint160(_packedOwnershipOf(tokenId)));
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-name}.
790      */
791     function name() public view virtual override returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-symbol}.
797      */
798     function symbol() public view virtual override returns (string memory) {
799         return _symbol;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-tokenURI}.
804      */
805     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
806         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
807 
808         string memory baseURI = _baseURI();
809         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
810     }
811 
812     /**
813      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
814      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
815      * by default, can be overriden in child contracts.
816      */
817     function _baseURI() internal view virtual returns (string memory) {
818         return '';
819     }
820 
821     /**
822      * @dev Casts the address to uint256 without masking.
823      */
824     function _addressToUint256(address value) private pure returns (uint256 result) {
825         assembly {
826             result := value
827         }
828     }
829 
830     /**
831      * @dev Casts the boolean to uint256 without branching.
832      */
833     function _boolToUint256(bool value) private pure returns (uint256 result) {
834         assembly {
835             result := value
836         }
837     }
838 
839     /**
840      * @dev See {IERC721-approve}.
841      */
842     function approve(address to, uint256 tokenId) public override {
843         address owner = address(uint160(_packedOwnershipOf(tokenId)));
844         if (to == owner) revert ApprovalToCurrentOwner();
845 
846         if (_msgSenderERC721A() != owner)
847             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
848                 revert ApprovalCallerNotOwnerNorApproved();
849             }
850 
851         _tokenApprovals[tokenId] = to;
852         emit Approval(owner, to, tokenId);
853     }
854 
855     /**
856      * @dev See {IERC721-getApproved}.
857      */
858     function getApproved(uint256 tokenId) public view override returns (address) {
859         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
860 
861         return _tokenApprovals[tokenId];
862     }
863 
864     /**
865      * @dev See {IERC721-setApprovalForAll}.
866      */
867     function setApprovalForAll(address operator, bool approved) public virtual override {
868         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
869 
870         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
871         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
872     }
873 
874     /**
875      * @dev See {IERC721-isApprovedForAll}.
876      */
877     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
878         return _operatorApprovals[owner][operator];
879     }
880 
881     /**
882      * @dev See {IERC721-transferFrom}.
883      */
884     function transferFrom(
885         address from,
886         address to,
887         uint256 tokenId
888     ) public virtual override {
889         _transfer(from, to, tokenId);
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public virtual override {
900         safeTransferFrom(from, to, tokenId, '');
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) public virtual override {
912         _transfer(from, to, tokenId);
913         if (to.code.length != 0)
914             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
915                 revert TransferToNonERC721ReceiverImplementer();
916             }
917     }
918 
919     /**
920      * @dev Returns whether `tokenId` exists.
921      *
922      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
923      *
924      * Tokens start existing when they are minted (`_mint`),
925      */
926     function _exists(uint256 tokenId) internal view returns (bool) {
927         return
928             _startTokenId() <= tokenId &&
929             tokenId < _currentIndex && // If within bounds,
930             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
931     }
932 
933     /**
934      * @dev Equivalent to `_safeMint(to, quantity, '')`.
935      */
936     function _safeMint(address to, uint256 quantity) internal {
937         _safeMint(to, quantity, '');
938     }
939 
940     /**
941      * @dev Safely mints `quantity` tokens and transfers them to `to`.
942      *
943      * Requirements:
944      *
945      * - If `to` refers to a smart contract, it must implement
946      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
947      * - `quantity` must be greater than 0.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _safeMint(
952         address to,
953         uint256 quantity,
954         bytes memory _data
955     ) internal {
956         uint256 startTokenId = _currentIndex;
957         if (to == address(0)) revert MintToZeroAddress();
958         if (quantity == 0) revert MintZeroQuantity();
959 
960         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
961 
962         // Overflows are incredibly unrealistic.
963         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
964         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
965         unchecked {
966             // Updates:
967             // - `balance += quantity`.
968             // - `numberMinted += quantity`.
969             //
970             // We can directly add to the balance and number minted.
971             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
972 
973             // Updates:
974             // - `address` to the owner.
975             // - `startTimestamp` to the timestamp of minting.
976             // - `burned` to `false`.
977             // - `nextInitialized` to `quantity == 1`.
978             _packedOwnerships[startTokenId] =
979                 _addressToUint256(to) |
980                 (block.timestamp << BITPOS_START_TIMESTAMP) |
981                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
982 
983             uint256 updatedIndex = startTokenId;
984             uint256 end = updatedIndex + quantity;
985 
986             if (to.code.length != 0) {
987                 do {
988                     emit Transfer(address(0), to, updatedIndex);
989                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
990                         revert TransferToNonERC721ReceiverImplementer();
991                     }
992                 } while (updatedIndex < end);
993                 // Reentrancy protection
994                 if (_currentIndex != startTokenId) revert();
995             } else {
996                 do {
997                     emit Transfer(address(0), to, updatedIndex++);
998                 } while (updatedIndex < end);
999             }
1000             _currentIndex = updatedIndex;
1001         }
1002         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1003     }
1004 
1005     /**
1006      * @dev Mints `quantity` tokens and transfers them to `to`.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `quantity` must be greater than 0.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _mint(address to, uint256 quantity) internal {
1016         uint256 startTokenId = _currentIndex;
1017         if (to == address(0)) revert MintToZeroAddress();
1018         if (quantity == 0) revert MintZeroQuantity();
1019 
1020         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1021 
1022         // Overflows are incredibly unrealistic.
1023         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1024         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1025         unchecked {
1026             // Updates:
1027             // - `balance += quantity`.
1028             // - `numberMinted += quantity`.
1029             //
1030             // We can directly add to the balance and number minted.
1031             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1032 
1033             // Updates:
1034             // - `address` to the owner.
1035             // - `startTimestamp` to the timestamp of minting.
1036             // - `burned` to `false`.
1037             // - `nextInitialized` to `quantity == 1`.
1038             _packedOwnerships[startTokenId] =
1039                 _addressToUint256(to) |
1040                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1041                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1042 
1043             uint256 updatedIndex = startTokenId;
1044             uint256 end = updatedIndex + quantity;
1045 
1046             do {
1047                 emit Transfer(address(0), to, updatedIndex++);
1048             } while (updatedIndex < end);
1049 
1050             _currentIndex = updatedIndex;
1051         }
1052         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1053     }
1054 
1055     /**
1056      * @dev Transfers `tokenId` from `from` to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - `to` cannot be the zero address.
1061      * - `tokenId` token must be owned by `from`.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _transfer(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) private {
1070         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1071 
1072         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1073 
1074         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1075             isApprovedForAll(from, _msgSenderERC721A()) ||
1076             getApproved(tokenId) == _msgSenderERC721A());
1077 
1078         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1079         if (to == address(0)) revert TransferToZeroAddress();
1080 
1081         _beforeTokenTransfers(from, to, tokenId, 1);
1082 
1083         // Clear approvals from the previous owner.
1084         delete _tokenApprovals[tokenId];
1085 
1086         // Underflow of the sender's balance is impossible because we check for
1087         // ownership above and the recipient's balance can't realistically overflow.
1088         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1089         unchecked {
1090             // We can directly increment and decrement the balances.
1091             --_packedAddressData[from]; // Updates: `balance -= 1`.
1092             ++_packedAddressData[to]; // Updates: `balance += 1`.
1093 
1094             // Updates:
1095             // - `address` to the next owner.
1096             // - `startTimestamp` to the timestamp of transfering.
1097             // - `burned` to `false`.
1098             // - `nextInitialized` to `true`.
1099             _packedOwnerships[tokenId] =
1100                 _addressToUint256(to) |
1101                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1102                 BITMASK_NEXT_INITIALIZED;
1103 
1104             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1105             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1106                 uint256 nextTokenId = tokenId + 1;
1107                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1108                 if (_packedOwnerships[nextTokenId] == 0) {
1109                     // If the next slot is within bounds.
1110                     if (nextTokenId != _currentIndex) {
1111                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1112                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1113                     }
1114                 }
1115             }
1116         }
1117 
1118         emit Transfer(from, to, tokenId);
1119         _afterTokenTransfers(from, to, tokenId, 1);
1120     }
1121 
1122     /**
1123      * @dev Equivalent to `_burn(tokenId, false)`.
1124      */
1125     function _burn(uint256 tokenId) internal virtual {
1126         _burn(tokenId, false);
1127     }
1128 
1129     /**
1130      * @dev Destroys `tokenId`.
1131      * The approval is cleared when the token is burned.
1132      *
1133      * Requirements:
1134      *
1135      * - `tokenId` must exist.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1140         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1141 
1142         address from = address(uint160(prevOwnershipPacked));
1143 
1144         if (approvalCheck) {
1145             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1146                 isApprovedForAll(from, _msgSenderERC721A()) ||
1147                 getApproved(tokenId) == _msgSenderERC721A());
1148 
1149             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1150         }
1151 
1152         _beforeTokenTransfers(from, address(0), tokenId, 1);
1153 
1154         // Clear approvals from the previous owner.
1155         delete _tokenApprovals[tokenId];
1156 
1157         // Underflow of the sender's balance is impossible because we check for
1158         // ownership above and the recipient's balance can't realistically overflow.
1159         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1160         unchecked {
1161             // Updates:
1162             // - `balance -= 1`.
1163             // - `numberBurned += 1`.
1164             //
1165             // We can directly decrement the balance, and increment the number burned.
1166             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1167             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1168 
1169             // Updates:
1170             // - `address` to the last owner.
1171             // - `startTimestamp` to the timestamp of burning.
1172             // - `burned` to `true`.
1173             // - `nextInitialized` to `true`.
1174             _packedOwnerships[tokenId] =
1175                 _addressToUint256(from) |
1176                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1177                 BITMASK_BURNED | 
1178                 BITMASK_NEXT_INITIALIZED;
1179 
1180             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1181             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1182                 uint256 nextTokenId = tokenId + 1;
1183                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1184                 if (_packedOwnerships[nextTokenId] == 0) {
1185                     // If the next slot is within bounds.
1186                     if (nextTokenId != _currentIndex) {
1187                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1188                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1189                     }
1190                 }
1191             }
1192         }
1193 
1194         emit Transfer(from, address(0), tokenId);
1195         _afterTokenTransfers(from, address(0), tokenId, 1);
1196 
1197         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1198         unchecked {
1199             _burnCounter++;
1200         }
1201     }
1202 
1203     /**
1204      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1205      *
1206      * @param from address representing the previous owner of the given token ID
1207      * @param to target address that will receive the tokens
1208      * @param tokenId uint256 ID of the token to be transferred
1209      * @param _data bytes optional data to send along with the call
1210      * @return bool whether the call correctly returned the expected magic value
1211      */
1212     function _checkContractOnERC721Received(
1213         address from,
1214         address to,
1215         uint256 tokenId,
1216         bytes memory _data
1217     ) private returns (bool) {
1218         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1219             bytes4 retval
1220         ) {
1221             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1222         } catch (bytes memory reason) {
1223             if (reason.length == 0) {
1224                 revert TransferToNonERC721ReceiverImplementer();
1225             } else {
1226                 assembly {
1227                     revert(add(32, reason), mload(reason))
1228                 }
1229             }
1230         }
1231     }
1232 
1233     /**
1234      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1235      * And also called before burning one token.
1236      *
1237      * startTokenId - the first token id to be transferred
1238      * quantity - the amount to be transferred
1239      *
1240      * Calling conditions:
1241      *
1242      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1243      * transferred to `to`.
1244      * - When `from` is zero, `tokenId` will be minted for `to`.
1245      * - When `to` is zero, `tokenId` will be burned by `from`.
1246      * - `from` and `to` are never both zero.
1247      */
1248     function _beforeTokenTransfers(
1249         address from,
1250         address to,
1251         uint256 startTokenId,
1252         uint256 quantity
1253     ) internal virtual {}
1254 
1255     /**
1256      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1257      * minting.
1258      * And also called after one token has been burned.
1259      *
1260      * startTokenId - the first token id to be transferred
1261      * quantity - the amount to be transferred
1262      *
1263      * Calling conditions:
1264      *
1265      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1266      * transferred to `to`.
1267      * - When `from` is zero, `tokenId` has been minted for `to`.
1268      * - When `to` is zero, `tokenId` has been burned by `from`.
1269      * - `from` and `to` are never both zero.
1270      */
1271     function _afterTokenTransfers(
1272         address from,
1273         address to,
1274         uint256 startTokenId,
1275         uint256 quantity
1276     ) internal virtual {}
1277 
1278     /**
1279      * @dev Returns the message sender (defaults to `msg.sender`).
1280      *
1281      * If you are writing GSN compatible contracts, you need to override this function.
1282      */
1283     function _msgSenderERC721A() internal view virtual returns (address) {
1284         return msg.sender;
1285     }
1286 
1287     /**
1288      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1289      */
1290     function _toString(uint256 value) internal pure returns (string memory ptr) {
1291         assembly {
1292             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1293             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1294             // We will need 1 32-byte word to store the length, 
1295             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1296             ptr := add(mload(0x40), 128)
1297             // Update the free memory pointer to allocate.
1298             mstore(0x40, ptr)
1299 
1300             // Cache the end of the memory to calculate the length later.
1301             let end := ptr
1302 
1303             // We write the string from the rightmost digit to the leftmost digit.
1304             // The following is essentially a do-while loop that also handles the zero case.
1305             // Costs a bit more than early returning for the zero case,
1306             // but cheaper in terms of deployment and overall runtime costs.
1307             for { 
1308                 // Initialize and perform the first pass without check.
1309                 let temp := value
1310                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1311                 ptr := sub(ptr, 1)
1312                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1313                 mstore8(ptr, add(48, mod(temp, 10)))
1314                 temp := div(temp, 10)
1315             } temp { 
1316                 // Keep dividing `temp` until zero.
1317                 temp := div(temp, 10)
1318             } { // Body of the for loop.
1319                 ptr := sub(ptr, 1)
1320                 mstore8(ptr, add(48, mod(temp, 10)))
1321             }
1322             
1323             let length := sub(end, ptr)
1324             // Move the pointer 32 bytes leftwards to make room for the length.
1325             ptr := sub(ptr, 32)
1326             // Store the length.
1327             mstore(ptr, length)
1328         }
1329     }
1330 }
1331 
1332 // File: 000.sol
1333 
1334 
1335 pragma solidity ^0.8.9;
1336 
1337 
1338 
1339 
1340 
1341 contract ColoredTokenArt is ERC721A, Ownable, ReentrancyGuard { 
1342 
1343     uint256 public _maxSupply = 5555;
1344     uint256 public _mintPrice = 0.002 ether;
1345     uint256 public _maxMintPerTx = 10;
1346 
1347     uint256 public _maxFreeMintPerAddr = 5;
1348     uint256 public _maxFreeMintSupply = 3000;
1349     uint256 public revealTimeStamp = block.timestamp+86400*2 ; 
1350 
1351     string private _baseURIExtended;
1352     string private _preRevealURI;
1353     using Strings for uint256;
1354     string public baseURI;
1355     mapping(address => uint256) private _mintedFreeAmount;
1356 
1357     constructor(string memory initBaseURI) ERC721A("ColorTokenArt", "Color") {
1358     }
1359 
1360     function mint(uint256 count) external payable {
1361         uint256 cost = _mintPrice;
1362         bool isFree = ((totalSupply() + count < _maxFreeMintSupply + 1) &&
1363             (_mintedFreeAmount[msg.sender] + count <= _maxFreeMintPerAddr)) ||
1364             (msg.sender == owner());
1365 
1366         if (isFree) {
1367             cost = 0;
1368         }
1369 
1370         require(msg.value >= count * cost, "Please send the exact amount.");
1371         require(totalSupply() + count < _maxSupply + 1, "Sold out!");
1372         require(count < _maxMintPerTx + 1, "Max per TX reached.");
1373 
1374         if (isFree) {
1375             _mintedFreeAmount[msg.sender] += count;
1376         }
1377 
1378         _safeMint(msg.sender, count);
1379     }
1380 
1381     function tokenURI(uint256 tokenId)
1382         public
1383         view
1384         virtual
1385         override
1386         returns (string memory)
1387     {
1388         require(
1389             _exists(tokenId),
1390             "ERC721Metadata: URI query for nonexistent token"
1391         ); if (block.timestamp >= revealTimeStamp) {
1392         return string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
1393     }
1394     {
1395       return _preRevealURI;
1396     }
1397     }
1398     function setRevealTimestamp(uint256 newRevealTimeStamp) external onlyOwner {
1399     revealTimeStamp = newRevealTimeStamp;
1400   }
1401   function setPreRevealURI(string memory preRevealURI) external onlyOwner {
1402     _preRevealURI = preRevealURI;
1403   }
1404   function setBaseURI(string memory baseURI_) external onlyOwner {
1405     _baseURIExtended = baseURI_;
1406   }
1407 
1408   function _baseURI() internal view virtual override returns (string memory) {
1409     return _baseURIExtended;
1410   }
1411 
1412     function setFreeAmount(uint256 amount) external onlyOwner {
1413         _maxFreeMintSupply = amount;
1414     }
1415 
1416     function setPrice(uint256 _newPrice) external onlyOwner {
1417         _mintPrice = _newPrice;
1418     }
1419 
1420     function withdraw() public payable onlyOwner nonReentrant {
1421         (bool success, ) = payable(msg.sender).call{
1422             value: address(this).balance
1423         }("");
1424         require(success);
1425     }
1426 }