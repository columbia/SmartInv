1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/utils/Strings.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/security/ReentrancyGuard.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Contract module that helps prevent reentrant calls to a function.
80  *
81  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
82  * available, which can be applied to functions to make sure there are no nested
83  * (reentrant) calls to them.
84  *
85  * Note that because there is a single `nonReentrant` guard, functions marked as
86  * `nonReentrant` may not call one another. This can be worked around by making
87  * those functions `private`, and then adding `external` `nonReentrant` entry
88  * points to them.
89  *
90  * TIP: If you would like to learn more about reentrancy and alternative ways
91  * to protect against it, check out our blog post
92  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
93  */
94 abstract contract ReentrancyGuard {
95     // Booleans are more expensive than uint256 or any type that takes up a full
96     // word because each write operation emits an extra SLOAD to first read the
97     // slot's contents, replace the bits taken up by the boolean, and then write
98     // back. This is the compiler's defense against contract upgrades and
99     // pointer aliasing, and it cannot be disabled.
100 
101     // The values being non-zero value makes deployment a bit more expensive,
102     // but in exchange the refund on every call to nonReentrant will be lower in
103     // amount. Since refunds are capped to a percentage of the total
104     // transaction's gas, it is best to keep them low in cases like this one, to
105     // increase the likelihood of the full refund coming into effect.
106     uint256 private constant _NOT_ENTERED = 1;
107     uint256 private constant _ENTERED = 2;
108 
109     uint256 private _status;
110 
111     constructor() {
112         _status = _NOT_ENTERED;
113     }
114 
115     /**
116      * @dev Prevents a contract from calling itself, directly or indirectly.
117      * Calling a `nonReentrant` function from another `nonReentrant`
118      * function is not supported. It is possible to prevent this from happening
119      * by making the `nonReentrant` function external, and making it call a
120      * `private` function that does the actual work.
121      */
122     modifier nonReentrant() {
123         // On the first call to nonReentrant, _notEntered will be true
124         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
125 
126         // Any calls to nonReentrant after this point will fail
127         _status = _ENTERED;
128 
129         _;
130 
131         // By storing the original value once again, a refund is triggered (see
132         // https://eips.ethereum.org/EIPS/eip-2200)
133         _status = _NOT_ENTERED;
134     }
135 }
136 
137 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/access/Ownable.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: https://github.com/chiru-labs/ERC721A/blob/v4.0.0/contracts/IERC721A.sol
243 
244 
245 // ERC721A Contracts v4.0.0
246 // Creator: Chiru Labs
247 
248 pragma solidity ^0.8.4;
249 
250 /**
251  * @dev Interface of an ERC721A compliant contract.
252  */
253 interface IERC721A {
254     /**
255      * The caller must own the token or be an approved operator.
256      */
257     error ApprovalCallerNotOwnerNorApproved();
258 
259     /**
260      * The token does not exist.
261      */
262     error ApprovalQueryForNonexistentToken();
263 
264     /**
265      * The caller cannot approve to their own address.
266      */
267     error ApproveToCaller();
268 
269     /**
270      * The caller cannot approve to the current owner.
271      */
272     error ApprovalToCurrentOwner();
273 
274     /**
275      * Cannot query the balance for the zero address.
276      */
277     error BalanceQueryForZeroAddress();
278 
279     /**
280      * Cannot mint to the zero address.
281      */
282     error MintToZeroAddress();
283 
284     /**
285      * The quantity of tokens minted must be more than zero.
286      */
287     error MintZeroQuantity();
288 
289     /**
290      * The token does not exist.
291      */
292     error OwnerQueryForNonexistentToken();
293 
294     /**
295      * The caller must own the token or be an approved operator.
296      */
297     error TransferCallerNotOwnerNorApproved();
298 
299     /**
300      * The token must be owned by `from`.
301      */
302     error TransferFromIncorrectOwner();
303 
304     /**
305      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
306      */
307     error TransferToNonERC721ReceiverImplementer();
308 
309     /**
310      * Cannot transfer to the zero address.
311      */
312     error TransferToZeroAddress();
313 
314     /**
315      * The token does not exist.
316      */
317     error URIQueryForNonexistentToken();
318 
319     struct TokenOwnership {
320         // The address of the owner.
321         address addr;
322         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
323         uint64 startTimestamp;
324         // Whether the token has been burned.
325         bool burned;
326     }
327 
328     /**
329      * @dev Returns the total amount of tokens stored by the contract.
330      *
331      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
332      */
333     function totalSupply() external view returns (uint256);
334 
335     // ==============================
336     //            IERC165
337     // ==============================
338 
339     /**
340      * @dev Returns true if this contract implements the interface defined by
341      * `interfaceId`. See the corresponding
342      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
343      * to learn more about how these ids are created.
344      *
345      * This function call must use less than 30 000 gas.
346      */
347     function supportsInterface(bytes4 interfaceId) external view returns (bool);
348 
349     // ==============================
350     //            IERC721
351     // ==============================
352 
353     /**
354      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
355      */
356     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
357 
358     /**
359      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
360      */
361     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
362 
363     /**
364      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
365      */
366     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
367 
368     /**
369      * @dev Returns the number of tokens in ``owner``'s account.
370      */
371     function balanceOf(address owner) external view returns (uint256 balance);
372 
373     /**
374      * @dev Returns the owner of the `tokenId` token.
375      *
376      * Requirements:
377      *
378      * - `tokenId` must exist.
379      */
380     function ownerOf(uint256 tokenId) external view returns (address owner);
381 
382     /**
383      * @dev Safely transfers `tokenId` token from `from` to `to`.
384      *
385      * Requirements:
386      *
387      * - `from` cannot be the zero address.
388      * - `to` cannot be the zero address.
389      * - `tokenId` token must exist and be owned by `from`.
390      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
391      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
392      *
393      * Emits a {Transfer} event.
394      */
395     function safeTransferFrom(
396         address from,
397         address to,
398         uint256 tokenId,
399         bytes calldata data
400     ) external;
401 
402     /**
403      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
404      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
405      *
406      * Requirements:
407      *
408      * - `from` cannot be the zero address.
409      * - `to` cannot be the zero address.
410      * - `tokenId` token must exist and be owned by `from`.
411      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
412      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
413      *
414      * Emits a {Transfer} event.
415      */
416     function safeTransferFrom(
417         address from,
418         address to,
419         uint256 tokenId
420     ) external;
421 
422     /**
423      * @dev Transfers `tokenId` token from `from` to `to`.
424      *
425      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
426      *
427      * Requirements:
428      *
429      * - `from` cannot be the zero address.
430      * - `to` cannot be the zero address.
431      * - `tokenId` token must be owned by `from`.
432      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
433      *
434      * Emits a {Transfer} event.
435      */
436     function transferFrom(
437         address from,
438         address to,
439         uint256 tokenId
440     ) external;
441 
442     /**
443      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
444      * The approval is cleared when the token is transferred.
445      *
446      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
447      *
448      * Requirements:
449      *
450      * - The caller must own the token or be an approved operator.
451      * - `tokenId` must exist.
452      *
453      * Emits an {Approval} event.
454      */
455     function approve(address to, uint256 tokenId) external;
456 
457     /**
458      * @dev Approve or remove `operator` as an operator for the caller.
459      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
460      *
461      * Requirements:
462      *
463      * - The `operator` cannot be the caller.
464      *
465      * Emits an {ApprovalForAll} event.
466      */
467     function setApprovalForAll(address operator, bool _approved) external;
468 
469     /**
470      * @dev Returns the account approved for `tokenId` token.
471      *
472      * Requirements:
473      *
474      * - `tokenId` must exist.
475      */
476     function getApproved(uint256 tokenId) external view returns (address operator);
477 
478     /**
479      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
480      *
481      * See {setApprovalForAll}
482      */
483     function isApprovedForAll(address owner, address operator) external view returns (bool);
484 
485     // ==============================
486     //        IERC721Metadata
487     // ==============================
488 
489     /**
490      * @dev Returns the token collection name.
491      */
492     function name() external view returns (string memory);
493 
494     /**
495      * @dev Returns the token collection symbol.
496      */
497     function symbol() external view returns (string memory);
498 
499     /**
500      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
501      */
502     function tokenURI(uint256 tokenId) external view returns (string memory);
503 }
504 
505 // File: https://github.com/chiru-labs/ERC721A/blob/v4.0.0/contracts/ERC721A.sol
506 
507 
508 // ERC721A Contracts v4.0.0
509 // Creator: Chiru Labs
510 
511 pragma solidity ^0.8.4;
512 
513 
514 /**
515  * @dev ERC721 token receiver interface.
516  */
517 interface ERC721A__IERC721Receiver {
518     function onERC721Received(
519         address operator,
520         address from,
521         uint256 tokenId,
522         bytes calldata data
523     ) external returns (bytes4);
524 }
525 
526 /**
527  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
528  * the Metadata extension. Built to optimize for lower gas during batch mints.
529  *
530  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
531  *
532  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
533  *
534  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
535  */
536 contract ERC721A is IERC721A {
537     // Mask of an entry in packed address data.
538     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
539 
540     // The bit position of `numberMinted` in packed address data.
541     uint256 private constant BITPOS_NUMBER_MINTED = 64;
542 
543     // The bit position of `numberBurned` in packed address data.
544     uint256 private constant BITPOS_NUMBER_BURNED = 128;
545 
546     // The bit position of `aux` in packed address data.
547     uint256 private constant BITPOS_AUX = 192;
548 
549     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
550     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
551 
552     // The bit position of `startTimestamp` in packed ownership.
553     uint256 private constant BITPOS_START_TIMESTAMP = 160;
554 
555     // The bit mask of the `burned` bit in packed ownership.
556     uint256 private constant BITMASK_BURNED = 1 << 224;
557     
558     // The bit position of the `nextInitialized` bit in packed ownership.
559     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
560 
561     // The bit mask of the `nextInitialized` bit in packed ownership.
562     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
563 
564     // The tokenId of the next token to be minted.
565     uint256 private _currentIndex;
566 
567     // The number of tokens burned.
568     uint256 private _burnCounter;
569 
570     // Token name
571     string private _name;
572 
573     // Token symbol
574     string private _symbol;
575 
576     // Mapping from token ID to ownership details
577     // An empty struct value does not necessarily mean the token is unowned.
578     // See `_packedOwnershipOf` implementation for details.
579     //
580     // Bits Layout:
581     // - [0..159]   `addr`
582     // - [160..223] `startTimestamp`
583     // - [224]      `burned`
584     // - [225]      `nextInitialized`
585     mapping(uint256 => uint256) private _packedOwnerships;
586 
587     // Mapping owner address to address data.
588     //
589     // Bits Layout:
590     // - [0..63]    `balance`
591     // - [64..127]  `numberMinted`
592     // - [128..191] `numberBurned`
593     // - [192..255] `aux`
594     mapping(address => uint256) private _packedAddressData;
595 
596     // Mapping from token ID to approved address.
597     mapping(uint256 => address) private _tokenApprovals;
598 
599     // Mapping from owner to operator approvals
600     mapping(address => mapping(address => bool)) private _operatorApprovals;
601 
602     constructor(string memory name_, string memory symbol_) {
603         _name = name_;
604         _symbol = symbol_;
605         _currentIndex = _startTokenId();
606     }
607 
608     /**
609      * @dev Returns the starting token ID. 
610      * To change the starting token ID, please override this function.
611      */
612     function _startTokenId() internal view virtual returns (uint256) {
613         return 0;
614     }
615 
616     /**
617      * @dev Returns the next token ID to be minted.
618      */
619     function _nextTokenId() internal view returns (uint256) {
620         return _currentIndex;
621     }
622 
623     /**
624      * @dev Returns the total number of tokens in existence.
625      * Burned tokens will reduce the count. 
626      * To get the total number of tokens minted, please see `_totalMinted`.
627      */
628     function totalSupply() public view override returns (uint256) {
629         // Counter underflow is impossible as _burnCounter cannot be incremented
630         // more than `_currentIndex - _startTokenId()` times.
631         unchecked {
632             return _currentIndex - _burnCounter - _startTokenId();
633         }
634     }
635 
636     /**
637      * @dev Returns the total amount of tokens minted in the contract.
638      */
639     function _totalMinted() internal view returns (uint256) {
640         // Counter underflow is impossible as _currentIndex does not decrement,
641         // and it is initialized to `_startTokenId()`
642         unchecked {
643             return _currentIndex - _startTokenId();
644         }
645     }
646 
647     /**
648      * @dev Returns the total number of tokens burned.
649      */
650     function _totalBurned() internal view returns (uint256) {
651         return _burnCounter;
652     }
653 
654     /**
655      * @dev See {IERC165-supportsInterface}.
656      */
657     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
658         // The interface IDs are constants representing the first 4 bytes of the XOR of
659         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
660         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
661         return
662             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
663             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
664             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
665     }
666 
667     /**
668      * @dev See {IERC721-balanceOf}.
669      */
670     function balanceOf(address owner) public view override returns (uint256) {
671         if (owner == address(0)) revert BalanceQueryForZeroAddress();
672         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
673     }
674 
675     /**
676      * Returns the number of tokens minted by `owner`.
677      */
678     function _numberMinted(address owner) internal view returns (uint256) {
679         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
680     }
681 
682     /**
683      * Returns the number of tokens burned by or on behalf of `owner`.
684      */
685     function _numberBurned(address owner) internal view returns (uint256) {
686         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
687     }
688 
689     /**
690      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
691      */
692     function _getAux(address owner) internal view returns (uint64) {
693         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
694     }
695 
696     /**
697      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
698      * If there are multiple variables, please pack them into a uint64.
699      */
700     function _setAux(address owner, uint64 aux) internal {
701         uint256 packed = _packedAddressData[owner];
702         uint256 auxCasted;
703         assembly { // Cast aux without masking.
704             auxCasted := aux
705         }
706         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
707         _packedAddressData[owner] = packed;
708     }
709 
710     /**
711      * Returns the packed ownership data of `tokenId`.
712      */
713     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
714         uint256 curr = tokenId;
715 
716         unchecked {
717             if (_startTokenId() <= curr)
718                 if (curr < _currentIndex) {
719                     uint256 packed = _packedOwnerships[curr];
720                     // If not burned.
721                     if (packed & BITMASK_BURNED == 0) {
722                         // Invariant:
723                         // There will always be an ownership that has an address and is not burned
724                         // before an ownership that does not have an address and is not burned.
725                         // Hence, curr will not underflow.
726                         //
727                         // We can directly compare the packed value.
728                         // If the address is zero, packed is zero.
729                         while (packed == 0) {
730                             packed = _packedOwnerships[--curr];
731                         }
732                         return packed;
733                     }
734                 }
735         }
736         revert OwnerQueryForNonexistentToken();
737     }
738 
739     /**
740      * Returns the unpacked `TokenOwnership` struct from `packed`.
741      */
742     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
743         ownership.addr = address(uint160(packed));
744         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
745         ownership.burned = packed & BITMASK_BURNED != 0;
746     }
747 
748     /**
749      * Returns the unpacked `TokenOwnership` struct at `index`.
750      */
751     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
752         return _unpackedOwnership(_packedOwnerships[index]);
753     }
754 
755     /**
756      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
757      */
758     function _initializeOwnershipAt(uint256 index) internal {
759         if (_packedOwnerships[index] == 0) {
760             _packedOwnerships[index] = _packedOwnershipOf(index);
761         }
762     }
763 
764     /**
765      * Gas spent here starts off proportional to the maximum mint batch size.
766      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
767      */
768     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
769         return _unpackedOwnership(_packedOwnershipOf(tokenId));
770     }
771 
772     /**
773      * @dev See {IERC721-ownerOf}.
774      */
775     function ownerOf(uint256 tokenId) public view override returns (address) {
776         return address(uint160(_packedOwnershipOf(tokenId)));
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-name}.
781      */
782     function name() public view virtual override returns (string memory) {
783         return _name;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-symbol}.
788      */
789     function symbol() public view virtual override returns (string memory) {
790         return _symbol;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-tokenURI}.
795      */
796     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
797         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
798 
799         string memory baseURI = _baseURI();
800         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
801     }
802 
803     /**
804      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
805      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
806      * by default, can be overriden in child contracts.
807      */
808     function _baseURI() internal view virtual returns (string memory) {
809         return '';
810     }
811 
812     /**
813      * @dev Casts the address to uint256 without masking.
814      */
815     function _addressToUint256(address value) private pure returns (uint256 result) {
816         assembly {
817             result := value
818         }
819     }
820 
821     /**
822      * @dev Casts the boolean to uint256 without branching.
823      */
824     function _boolToUint256(bool value) private pure returns (uint256 result) {
825         assembly {
826             result := value
827         }
828     }
829 
830     /**
831      * @dev See {IERC721-approve}.
832      */
833     function approve(address to, uint256 tokenId) public override {
834         address owner = address(uint160(_packedOwnershipOf(tokenId)));
835         if (to == owner) revert ApprovalToCurrentOwner();
836 
837         if (_msgSenderERC721A() != owner)
838             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
839                 revert ApprovalCallerNotOwnerNorApproved();
840             }
841 
842         _tokenApprovals[tokenId] = to;
843         emit Approval(owner, to, tokenId);
844     }
845 
846     /**
847      * @dev See {IERC721-getApproved}.
848      */
849     function getApproved(uint256 tokenId) public view override returns (address) {
850         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
851 
852         return _tokenApprovals[tokenId];
853     }
854 
855     /**
856      * @dev See {IERC721-setApprovalForAll}.
857      */
858     function setApprovalForAll(address operator, bool approved) public virtual override {
859         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
860 
861         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
862         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
863     }
864 
865     /**
866      * @dev See {IERC721-isApprovedForAll}.
867      */
868     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
869         return _operatorApprovals[owner][operator];
870     }
871 
872     /**
873      * @dev See {IERC721-transferFrom}.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         _transfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         safeTransferFrom(from, to, tokenId, '');
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) public virtual override {
903         _transfer(from, to, tokenId);
904         if (to.code.length != 0)
905             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
906                 revert TransferToNonERC721ReceiverImplementer();
907             }
908     }
909 
910     /**
911      * @dev Returns whether `tokenId` exists.
912      *
913      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
914      *
915      * Tokens start existing when they are minted (`_mint`),
916      */
917     function _exists(uint256 tokenId) internal view returns (bool) {
918         return
919             _startTokenId() <= tokenId &&
920             tokenId < _currentIndex && // If within bounds,
921             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
922     }
923 
924     /**
925      * @dev Equivalent to `_safeMint(to, quantity, '')`.
926      */
927     function _safeMint(address to, uint256 quantity) internal {
928         _safeMint(to, quantity, '');
929     }
930 
931     /**
932      * @dev Safely mints `quantity` tokens and transfers them to `to`.
933      *
934      * Requirements:
935      *
936      * - If `to` refers to a smart contract, it must implement
937      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
938      * - `quantity` must be greater than 0.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _safeMint(
943         address to,
944         uint256 quantity,
945         bytes memory _data
946     ) internal {
947         uint256 startTokenId = _currentIndex;
948         if (to == address(0)) revert MintToZeroAddress();
949         if (quantity == 0) revert MintZeroQuantity();
950 
951         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
952 
953         // Overflows are incredibly unrealistic.
954         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
955         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
956         unchecked {
957             // Updates:
958             // - `balance += quantity`.
959             // - `numberMinted += quantity`.
960             //
961             // We can directly add to the balance and number minted.
962             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
963 
964             // Updates:
965             // - `address` to the owner.
966             // - `startTimestamp` to the timestamp of minting.
967             // - `burned` to `false`.
968             // - `nextInitialized` to `quantity == 1`.
969             _packedOwnerships[startTokenId] =
970                 _addressToUint256(to) |
971                 (block.timestamp << BITPOS_START_TIMESTAMP) |
972                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
973 
974             uint256 updatedIndex = startTokenId;
975             uint256 end = updatedIndex + quantity;
976 
977             if (to.code.length != 0) {
978                 do {
979                     emit Transfer(address(0), to, updatedIndex);
980                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
981                         revert TransferToNonERC721ReceiverImplementer();
982                     }
983                 } while (updatedIndex < end);
984                 // Reentrancy protection
985                 if (_currentIndex != startTokenId) revert();
986             } else {
987                 do {
988                     emit Transfer(address(0), to, updatedIndex++);
989                 } while (updatedIndex < end);
990             }
991             _currentIndex = updatedIndex;
992         }
993         _afterTokenTransfers(address(0), to, startTokenId, quantity);
994     }
995 
996     /**
997      * @dev Mints `quantity` tokens and transfers them to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `quantity` must be greater than 0.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _mint(address to, uint256 quantity) internal {
1007         uint256 startTokenId = _currentIndex;
1008         if (to == address(0)) revert MintToZeroAddress();
1009         if (quantity == 0) revert MintZeroQuantity();
1010 
1011         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1012 
1013         // Overflows are incredibly unrealistic.
1014         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1015         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1016         unchecked {
1017             // Updates:
1018             // - `balance += quantity`.
1019             // - `numberMinted += quantity`.
1020             //
1021             // We can directly add to the balance and number minted.
1022             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1023 
1024             // Updates:
1025             // - `address` to the owner.
1026             // - `startTimestamp` to the timestamp of minting.
1027             // - `burned` to `false`.
1028             // - `nextInitialized` to `quantity == 1`.
1029             _packedOwnerships[startTokenId] =
1030                 _addressToUint256(to) |
1031                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1032                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1033 
1034             uint256 updatedIndex = startTokenId;
1035             uint256 end = updatedIndex + quantity;
1036 
1037             do {
1038                 emit Transfer(address(0), to, updatedIndex++);
1039             } while (updatedIndex < end);
1040 
1041             _currentIndex = updatedIndex;
1042         }
1043         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1044     }
1045 
1046     /**
1047      * @dev Transfers `tokenId` from `from` to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - `to` cannot be the zero address.
1052      * - `tokenId` token must be owned by `from`.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _transfer(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) private {
1061         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1062 
1063         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1064 
1065         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1066             isApprovedForAll(from, _msgSenderERC721A()) ||
1067             getApproved(tokenId) == _msgSenderERC721A());
1068 
1069         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1070         if (to == address(0)) revert TransferToZeroAddress();
1071 
1072         _beforeTokenTransfers(from, to, tokenId, 1);
1073 
1074         // Clear approvals from the previous owner.
1075         delete _tokenApprovals[tokenId];
1076 
1077         // Underflow of the sender's balance is impossible because we check for
1078         // ownership above and the recipient's balance can't realistically overflow.
1079         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1080         unchecked {
1081             // We can directly increment and decrement the balances.
1082             --_packedAddressData[from]; // Updates: `balance -= 1`.
1083             ++_packedAddressData[to]; // Updates: `balance += 1`.
1084 
1085             // Updates:
1086             // - `address` to the next owner.
1087             // - `startTimestamp` to the timestamp of transfering.
1088             // - `burned` to `false`.
1089             // - `nextInitialized` to `true`.
1090             _packedOwnerships[tokenId] =
1091                 _addressToUint256(to) |
1092                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1093                 BITMASK_NEXT_INITIALIZED;
1094 
1095             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1096             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1097                 uint256 nextTokenId = tokenId + 1;
1098                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1099                 if (_packedOwnerships[nextTokenId] == 0) {
1100                     // If the next slot is within bounds.
1101                     if (nextTokenId != _currentIndex) {
1102                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1103                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1104                     }
1105                 }
1106             }
1107         }
1108 
1109         emit Transfer(from, to, tokenId);
1110         _afterTokenTransfers(from, to, tokenId, 1);
1111     }
1112 
1113     /**
1114      * @dev Equivalent to `_burn(tokenId, false)`.
1115      */
1116     function _burn(uint256 tokenId) internal virtual {
1117         _burn(tokenId, false);
1118     }
1119 
1120     /**
1121      * @dev Destroys `tokenId`.
1122      * The approval is cleared when the token is burned.
1123      *
1124      * Requirements:
1125      *
1126      * - `tokenId` must exist.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1131         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1132 
1133         address from = address(uint160(prevOwnershipPacked));
1134 
1135         if (approvalCheck) {
1136             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1137                 isApprovedForAll(from, _msgSenderERC721A()) ||
1138                 getApproved(tokenId) == _msgSenderERC721A());
1139 
1140             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1141         }
1142 
1143         _beforeTokenTransfers(from, address(0), tokenId, 1);
1144 
1145         // Clear approvals from the previous owner.
1146         delete _tokenApprovals[tokenId];
1147 
1148         // Underflow of the sender's balance is impossible because we check for
1149         // ownership above and the recipient's balance can't realistically overflow.
1150         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1151         unchecked {
1152             // Updates:
1153             // - `balance -= 1`.
1154             // - `numberBurned += 1`.
1155             //
1156             // We can directly decrement the balance, and increment the number burned.
1157             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1158             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1159 
1160             // Updates:
1161             // - `address` to the last owner.
1162             // - `startTimestamp` to the timestamp of burning.
1163             // - `burned` to `true`.
1164             // - `nextInitialized` to `true`.
1165             _packedOwnerships[tokenId] =
1166                 _addressToUint256(from) |
1167                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1168                 BITMASK_BURNED | 
1169                 BITMASK_NEXT_INITIALIZED;
1170 
1171             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1172             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1173                 uint256 nextTokenId = tokenId + 1;
1174                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1175                 if (_packedOwnerships[nextTokenId] == 0) {
1176                     // If the next slot is within bounds.
1177                     if (nextTokenId != _currentIndex) {
1178                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1179                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1180                     }
1181                 }
1182             }
1183         }
1184 
1185         emit Transfer(from, address(0), tokenId);
1186         _afterTokenTransfers(from, address(0), tokenId, 1);
1187 
1188         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1189         unchecked {
1190             _burnCounter++;
1191         }
1192     }
1193 
1194     /**
1195      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1196      *
1197      * @param from address representing the previous owner of the given token ID
1198      * @param to target address that will receive the tokens
1199      * @param tokenId uint256 ID of the token to be transferred
1200      * @param _data bytes optional data to send along with the call
1201      * @return bool whether the call correctly returned the expected magic value
1202      */
1203     function _checkContractOnERC721Received(
1204         address from,
1205         address to,
1206         uint256 tokenId,
1207         bytes memory _data
1208     ) private returns (bool) {
1209         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1210             bytes4 retval
1211         ) {
1212             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1213         } catch (bytes memory reason) {
1214             if (reason.length == 0) {
1215                 revert TransferToNonERC721ReceiverImplementer();
1216             } else {
1217                 assembly {
1218                     revert(add(32, reason), mload(reason))
1219                 }
1220             }
1221         }
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1226      * And also called before burning one token.
1227      *
1228      * startTokenId - the first token id to be transferred
1229      * quantity - the amount to be transferred
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      * - When `to` is zero, `tokenId` will be burned by `from`.
1237      * - `from` and `to` are never both zero.
1238      */
1239     function _beforeTokenTransfers(
1240         address from,
1241         address to,
1242         uint256 startTokenId,
1243         uint256 quantity
1244     ) internal virtual {}
1245 
1246     /**
1247      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1248      * minting.
1249      * And also called after one token has been burned.
1250      *
1251      * startTokenId - the first token id to be transferred
1252      * quantity - the amount to be transferred
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` has been minted for `to`.
1259      * - When `to` is zero, `tokenId` has been burned by `from`.
1260      * - `from` and `to` are never both zero.
1261      */
1262     function _afterTokenTransfers(
1263         address from,
1264         address to,
1265         uint256 startTokenId,
1266         uint256 quantity
1267     ) internal virtual {}
1268 
1269     /**
1270      * @dev Returns the message sender (defaults to `msg.sender`).
1271      *
1272      * If you are writing GSN compatible contracts, you need to override this function.
1273      */
1274     function _msgSenderERC721A() internal view virtual returns (address) {
1275         return msg.sender;
1276     }
1277 
1278     /**
1279      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1280      */
1281     function _toString(uint256 value) internal pure returns (string memory ptr) {
1282         assembly {
1283             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1284             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1285             // We will need 1 32-byte word to store the length, 
1286             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1287             ptr := add(mload(0x40), 128)
1288             // Update the free memory pointer to allocate.
1289             mstore(0x40, ptr)
1290 
1291             // Cache the end of the memory to calculate the length later.
1292             let end := ptr
1293 
1294             // We write the string from the rightmost digit to the leftmost digit.
1295             // The following is essentially a do-while loop that also handles the zero case.
1296             // Costs a bit more than early returning for the zero case,
1297             // but cheaper in terms of deployment and overall runtime costs.
1298             for { 
1299                 // Initialize and perform the first pass without check.
1300                 let temp := value
1301                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1302                 ptr := sub(ptr, 1)
1303                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1304                 mstore8(ptr, add(48, mod(temp, 10)))
1305                 temp := div(temp, 10)
1306             } temp { 
1307                 // Keep dividing `temp` until zero.
1308                 temp := div(temp, 10)
1309             } { // Body of the for loop.
1310                 ptr := sub(ptr, 1)
1311                 mstore8(ptr, add(48, mod(temp, 10)))
1312             }
1313             
1314             let length := sub(end, ptr)
1315             // Move the pointer 32 bytes leftwards to make room for the length.
1316             ptr := sub(ptr, 32)
1317             // Store the length.
1318             mstore(ptr, length)
1319         }
1320     }
1321 }
1322 
1323 // File: contracts/TIHWLL.sol
1324 
1325 
1326 
1327 pragma solidity >=0.8.9 <0.9.0;
1328 
1329 
1330 
1331 
1332 
1333 
1334 contract TIHWLL is ERC721A, Ownable, ReentrancyGuard {
1335   using Strings for uint256;
1336 
1337   string public uriPrefix = '';
1338   string public uriSuffix = '.json';
1339   string public hiddenMetadataUri;
1340 
1341   uint256 public cost = 0.0059 ether;
1342   uint256 public maxSupply = 10000;
1343   uint256 public maxMintAmount = 6;
1344   uint256 public maxFreeMintAmount = 1;
1345 
1346   bool public revealed = false;
1347   bool public paused = true;
1348 
1349   constructor(
1350     string memory _tokenName,
1351     string memory _tokenSymbol,
1352     string memory _hiddenMetadataUri
1353   ) ERC721A(_tokenName, _tokenSymbol) {
1354     setHiddenMetadataUri(_hiddenMetadataUri);
1355   }
1356 
1357   modifier mintCompliance(uint256 _mintAmount) {
1358     require(!paused, "The contract is paused!");
1359     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1360     require(
1361       _mintAmount > 0 && numberMinted(msg.sender) + _mintAmount <= maxMintAmount,
1362        "Invalid mint amount!"
1363     );
1364     _;
1365   }
1366 
1367   modifier mintPriceCompliance(uint256 _mintAmount) {
1368     uint256 costToSubtract = 0;
1369     
1370     if (numberMinted(msg.sender) < maxFreeMintAmount) {
1371       uint256 freeMintsLeft = maxFreeMintAmount - numberMinted(msg.sender);
1372       costToSubtract = cost * freeMintsLeft;
1373     }
1374    
1375     require(msg.value >= cost * _mintAmount - costToSubtract, "Insufficient funds!");
1376     _;
1377   }
1378 
1379   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1380     _safeMint(_msgSender(), _mintAmount);
1381   }
1382   
1383   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1384     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1385     _safeMint(_receiver, _mintAmount);
1386   }
1387 
1388   function _startTokenId() internal view virtual override returns (uint256) {
1389     return 1;
1390   }
1391 
1392   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1393     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1394 
1395     if (revealed == false) {
1396       return hiddenMetadataUri;
1397     }
1398 
1399     string memory currentBaseURI = _baseURI();
1400     return bytes(currentBaseURI).length > 0
1401         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1402         : '';
1403   }
1404 
1405   function setCost(uint256 _cost) public onlyOwner {
1406     cost = _cost;
1407   }
1408 
1409   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1410     maxMintAmount = _maxMintAmount;
1411   }
1412 
1413   function setMaxFreeMintAmount(uint256 _maxFreeMintAmount) public onlyOwner {
1414     maxFreeMintAmount = _maxFreeMintAmount;
1415   }
1416 
1417   function setRevealed(bool _state) public onlyOwner {
1418     revealed = _state;
1419   }
1420 
1421    function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1422     hiddenMetadataUri = _hiddenMetadataUri;
1423   }
1424 
1425   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1426     uriPrefix = _uriPrefix;
1427   }
1428 
1429   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1430     uriSuffix = _uriSuffix;
1431   }
1432 
1433   function setPaused(bool _state) public onlyOwner {
1434     paused = _state;
1435   }
1436 
1437   function withdraw() public onlyOwner nonReentrant {
1438     uint256 artistPayment = address(this).balance * 50 / 100;
1439     uint256 marketerPayment = address(this).balance * 50 / 100;
1440 
1441     (bool artistSuccess, ) = payable(0xcFF00c037cE5D7B23dEAd78BB2FF96e57be62b33).call{value: artistPayment}('');
1442     require(artistSuccess);
1443 
1444     (bool marketerSuccess, ) = payable(0xD1CE3a009B643299f9076261dBf137CEDFF2DDbf).call{value: marketerPayment}('');
1445     require(marketerSuccess);
1446 
1447     (bool devSuccess, ) = payable(owner()).call{value: address(this).balance}('');
1448     require(devSuccess);
1449   }
1450 
1451   function numberMinted(address owner) public view returns (uint256) {
1452     return _numberMinted(owner);
1453   }
1454 
1455   function _baseURI() internal view virtual override returns (string memory) {
1456     return uriPrefix;
1457   }
1458 }