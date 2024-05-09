1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-18
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
11 /**
12 Where am i?.......                                   
13                                                                            
14 */
15 
16 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Contract module that helps prevent reentrant calls to a function.
22  *
23  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
24  * available, which can be applied to functions to make sure there are no nested
25  * (reentrant) calls to them.
26  *
27  * Note that because there is a single `nonReentrant` guard, functions marked as
28  * `nonReentrant` may not call one another. This can be worked around by making
29  * those functions `private`, and then adding `external` `nonReentrant` entry
30  * points to them.
31  *
32  * TIP: If you would like to learn more about reentrancy and alternative ways
33  * to protect against it, check out our blog post
34  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
35  */
36 abstract contract ReentrancyGuard {
37     // Booleans are more expensive than uint256 or any type that takes up a full
38     // word because each write operation emits an extra SLOAD to first read the
39     // slot's contents, replace the bits taken up by the boolean, and then write
40     // back. This is the compiler's defense against contract upgrades and
41     // pointer aliasing, and it cannot be disabled.
42 
43     // The values being non-zero value makes deployment a bit more expensive,
44     // but in exchange the refund on every call to nonReentrant will be lower in
45     // amount. Since refunds are capped to a percentage of the total
46     // transaction's gas, it is best to keep them low in cases like this one, to
47     // increase the likelihood of the full refund coming into effect.
48     uint256 private constant _NOT_ENTERED = 1;
49     uint256 private constant _ENTERED = 2;
50 
51     uint256 private _status;
52 
53     constructor() {
54         _status = _NOT_ENTERED;
55     }
56 
57     /**
58      * @dev Prevents a contract from calling itself, directly or indirectly.
59      * Calling a `nonReentrant` function from another `nonReentrant`
60      * function is not supported. It is possible to prevent this from happening
61      * by making the `nonReentrant` function external, and making it call a
62      * `private` function that does the actual work.
63      */
64     modifier nonReentrant() {
65         // On the first call to nonReentrant, _notEntered will be true
66         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
67 
68         // Any calls to nonReentrant after this point will fail
69         _status = _ENTERED;
70 
71         _;
72 
73         // By storing the original value once again, a refund is triggered (see
74         // https://eips.ethereum.org/EIPS/eip-2200)
75         _status = _NOT_ENTERED;
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Strings.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev String operations.
88  */
89 library Strings {
90     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
91     uint8 private constant _ADDRESS_LENGTH = 20;
92 
93     /**
94      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
95      */
96     function toString(uint256 value) internal pure returns (string memory) {
97         // Inspired by OraclizeAPI's implementation - MIT licence
98         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
99 
100         if (value == 0) {
101             return "0";
102         }
103         uint256 temp = value;
104         uint256 digits;
105         while (temp != 0) {
106             digits++;
107             temp /= 10;
108         }
109         bytes memory buffer = new bytes(digits);
110         while (value != 0) {
111             digits -= 1;
112             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
113             value /= 10;
114         }
115         return string(buffer);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
120      */
121     function toHexString(uint256 value) internal pure returns (string memory) {
122         if (value == 0) {
123             return "0x00";
124         }
125         uint256 temp = value;
126         uint256 length = 0;
127         while (temp != 0) {
128             length++;
129             temp >>= 8;
130         }
131         return toHexString(value, length);
132     }
133 
134     /**
135      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
136      */
137     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
138         bytes memory buffer = new bytes(2 * length + 2);
139         buffer[0] = "0";
140         buffer[1] = "x";
141         for (uint256 i = 2 * length + 1; i > 1; --i) {
142             buffer[i] = _HEX_SYMBOLS[value & 0xf];
143             value >>= 4;
144         }
145         require(value == 0, "Strings: hex length insufficient");
146         return string(buffer);
147     }
148 
149     /**
150      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
151      */
152     function toHexString(address addr) internal pure returns (string memory) {
153         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
154     }
155 }
156 
157 
158 // File: @openzeppelin/contracts/utils/Context.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev Provides information about the current execution context, including the
167  * sender of the transaction and its data. While these are generally available
168  * via msg.sender and msg.data, they should not be accessed in such a direct
169  * manner, since when dealing with meta-transactions the account sending and
170  * paying for execution may not be the actual sender (as far as an application
171  * is concerned).
172  *
173  * This contract is only required for intermediate, library-like contracts.
174  */
175 abstract contract Context {
176     function _msgSender() internal view virtual returns (address) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view virtual returns (bytes calldata) {
181         return msg.data;
182     }
183 }
184 
185 // File: @openzeppelin/contracts/access/Ownable.sol
186 
187 
188 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 
193 /**
194  * @dev Contract module which provides a basic access control mechanism, where
195  * there is an account (an owner) that can be granted exclusive access to
196  * specific functions.
197  *
198  * By default, the owner account will be the one that deploys the contract. This
199  * can later be changed with {transferOwnership}.
200  *
201  * This module is used through inheritance. It will make available the modifier
202  * `onlyOwner`, which can be applied to your functions to restrict their use to
203  * the owner.
204  */
205 abstract contract Ownable is Context {
206     address private _owner;
207 
208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
209 
210     /**
211      * @dev Initializes the contract setting the deployer as the initial owner.
212      */
213     constructor() {
214         _transferOwnership(_msgSender());
215     }
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         _checkOwner();
222         _;
223     }
224 
225     /**
226      * @dev Returns the address of the current owner.
227      */
228     function owner() public view virtual returns (address) {
229         return _owner;
230     }
231 
232     /**
233      * @dev Throws if the sender is not the owner.
234      */
235     function _checkOwner() internal view virtual {
236         require(owner() == _msgSender(), "Ownable: caller is not the owner");
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public virtual onlyOwner {
247         _transferOwnership(address(0));
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Can only be called by the current owner.
253      */
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         _transferOwnership(newOwner);
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Internal function without access restriction.
262      */
263     function _transferOwnership(address newOwner) internal virtual {
264         address oldOwner = _owner;
265         _owner = newOwner;
266         emit OwnershipTransferred(oldOwner, newOwner);
267     }
268 }
269 
270 // File: erc721a/contracts/IERC721A.sol
271 
272 
273 // ERC721A Contracts v4.1.0
274 // Creator: Chiru Labs
275 
276 pragma solidity ^0.8.4;
277 
278 /**
279  * @dev Interface of an ERC721A compliant contract.
280  */
281 interface IERC721A {
282     /**
283      * The caller must own the token or be an approved operator.
284      */
285     error ApprovalCallerNotOwnerNorApproved();
286 
287     /**
288      * The token does not exist.
289      */
290     error ApprovalQueryForNonexistentToken();
291 
292     /**
293      * The caller cannot approve to their own address.
294      */
295     error ApproveToCaller();
296 
297     /**
298      * Cannot query the balance for the zero address.
299      */
300     error BalanceQueryForZeroAddress();
301 
302     /**
303      * Cannot mint to the zero address.
304      */
305     error MintToZeroAddress();
306 
307     /**
308      * The quantity of tokens minted must be more than zero.
309      */
310     error MintZeroQuantity();
311 
312     /**
313      * The token does not exist.
314      */
315     error OwnerQueryForNonexistentToken();
316 
317     /**
318      * The caller must own the token or be an approved operator.
319      */
320     error TransferCallerNotOwnerNorApproved();
321 
322     /**
323      * The token must be owned by `from`.
324      */
325     error TransferFromIncorrectOwner();
326 
327     /**
328      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
329      */
330     error TransferToNonERC721ReceiverImplementer();
331 
332     /**
333      * Cannot transfer to the zero address.
334      */
335     error TransferToZeroAddress();
336 
337     /**
338      * The token does not exist.
339      */
340     error URIQueryForNonexistentToken();
341 
342     /**
343      * The `quantity` minted with ERC2309 exceeds the safety limit.
344      */
345     error MintERC2309QuantityExceedsLimit();
346 
347     /**
348      * The `extraData` cannot be set on an unintialized ownership slot.
349      */
350     error OwnershipNotInitializedForExtraData();
351 
352     struct TokenOwnership {
353         // The address of the owner.
354         address addr;
355         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
356         uint64 startTimestamp;
357         // Whether the token has been burned.
358         bool burned;
359         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
360         uint24 extraData;
361     }
362 
363     /**
364      * @dev Returns the total amount of tokens stored by the contract.
365      *
366      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
367      */
368     function totalSupply() external view returns (uint256);
369 
370     // ==============================
371     //            IERC165
372     // ==============================
373 
374     /**
375      * @dev Returns true if this contract implements the interface defined by
376      * `interfaceId`. See the corresponding
377      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
378      * to learn more about how these ids are created.
379      *
380      * This function call must use less than 30 000 gas.
381      */
382     function supportsInterface(bytes4 interfaceId) external view returns (bool);
383 
384     // ==============================
385     //            IERC721
386     // ==============================
387 
388     /**
389      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
390      */
391     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
392 
393     /**
394      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
395      */
396     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
397 
398     /**
399      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
400      */
401     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
402 
403     /**
404      * @dev Returns the number of tokens in ``owner``'s account.
405      */
406     function balanceOf(address owner) external view returns (uint256 balance);
407 
408     /**
409      * @dev Returns the owner of the `tokenId` token.
410      *
411      * Requirements:
412      *
413      * - `tokenId` must exist.
414      */
415     function ownerOf(uint256 tokenId) external view returns (address owner);
416 
417     /**
418      * @dev Safely transfers `tokenId` token from `from` to `to`.
419      *
420      * Requirements:
421      *
422      * - `from` cannot be the zero address.
423      * - `to` cannot be the zero address.
424      * - `tokenId` token must exist and be owned by `from`.
425      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
427      *
428      * Emits a {Transfer} event.
429      */
430     function safeTransferFrom(
431         address from,
432         address to,
433         uint256 tokenId,
434         bytes calldata data
435     ) external;
436 
437     /**
438      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
439      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
440      *
441      * Requirements:
442      *
443      * - `from` cannot be the zero address.
444      * - `to` cannot be the zero address.
445      * - `tokenId` token must exist and be owned by `from`.
446      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
447      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
448      *
449      * Emits a {Transfer} event.
450      */
451     function safeTransferFrom(
452         address from,
453         address to,
454         uint256 tokenId
455     ) external;
456 
457     /**
458      * @dev Transfers `tokenId` token from `from` to `to`.
459      *
460      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
461      *
462      * Requirements:
463      *
464      * - `from` cannot be the zero address.
465      * - `to` cannot be the zero address.
466      * - `tokenId` token must be owned by `from`.
467      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
468      *
469      * Emits a {Transfer} event.
470      */
471     function transferFrom(
472         address from,
473         address to,
474         uint256 tokenId
475     ) external;
476 
477     /**
478      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
479      * The approval is cleared when the token is transferred.
480      *
481      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
482      *
483      * Requirements:
484      *
485      * - The caller must own the token or be an approved operator.
486      * - `tokenId` must exist.
487      *
488      * Emits an {Approval} event.
489      */
490     function approve(address to, uint256 tokenId) external;
491 
492     /**
493      * @dev Approve or remove `operator` as an operator for the caller.
494      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
495      *
496      * Requirements:
497      *
498      * - The `operator` cannot be the caller.
499      *
500      * Emits an {ApprovalForAll} event.
501      */
502     function setApprovalForAll(address operator, bool _approved) external;
503 
504     /**
505      * @dev Returns the account approved for `tokenId` token.
506      *
507      * Requirements:
508      *
509      * - `tokenId` must exist.
510      */
511     function getApproved(uint256 tokenId) external view returns (address operator);
512 
513     /**
514      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
515      *
516      * See {setApprovalForAll}
517      */
518     function isApprovedForAll(address owner, address operator) external view returns (bool);
519 
520     // ==============================
521     //        IERC721Metadata
522     // ==============================
523 
524     /**
525      * @dev Returns the token collection name.
526      */
527     function name() external view returns (string memory);
528 
529     /**
530      * @dev Returns the token collection symbol.
531      */
532     function symbol() external view returns (string memory);
533 
534     /**
535      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
536      */
537     function tokenURI(uint256 tokenId) external view returns (string memory);
538 
539     // ==============================
540     //            IERC2309
541     // ==============================
542 
543     /**
544      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
545      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
546      */
547     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
548 }
549 
550 // File: erc721a/contracts/ERC721A.sol
551 
552 
553 // ERC721A Contracts v4.1.0
554 // Creator: Chiru Labs
555 
556 pragma solidity ^0.8.4;
557 
558 
559 /**
560  * @dev ERC721 token receiver interface.
561  */
562 interface ERC721A__IERC721Receiver {
563     function onERC721Received(
564         address operator,
565         address from,
566         uint256 tokenId,
567         bytes calldata data
568     ) external returns (bytes4);
569 }
570 
571 /**
572  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
573  * including the Metadata extension. Built to optimize for lower gas during batch mints.
574  *
575  * Assumes serials are sequentially minted starting at `_startTokenId()`
576  * (defaults to 0, e.g. 0, 1, 2, 3..).
577  *
578  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
579  *
580  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
581  */
582 contract ERC721A is IERC721A {
583     // Mask of an entry in packed address data.
584     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
585 
586     // The bit position of `numberMinted` in packed address data.
587     uint256 private constant BITPOS_NUMBER_MINTED = 64;
588 
589     // The bit position of `numberBurned` in packed address data.
590     uint256 private constant BITPOS_NUMBER_BURNED = 128;
591 
592     // The bit position of `aux` in packed address data.
593     uint256 private constant BITPOS_AUX = 192;
594 
595     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
596     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
597 
598     // The bit position of `startTimestamp` in packed ownership.
599     uint256 private constant BITPOS_START_TIMESTAMP = 160;
600 
601     // The bit mask of the `burned` bit in packed ownership.
602     uint256 private constant BITMASK_BURNED = 1 << 224;
603 
604     // The bit position of the `nextInitialized` bit in packed ownership.
605     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
606 
607     // The bit mask of the `nextInitialized` bit in packed ownership.
608     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
609 
610     // The bit position of `extraData` in packed ownership.
611     uint256 private constant BITPOS_EXTRA_DATA = 232;
612 
613     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
614     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
615 
616     // The mask of the lower 160 bits for addresses.
617     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
618 
619     // The maximum `quantity` that can be minted with `_mintERC2309`.
620     // This limit is to prevent overflows on the address data entries.
621     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
622     // is required to cause an overflow, which is unrealistic.
623     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
624 
625     // The tokenId of the next token to be minted.
626     uint256 private _currentIndex;
627 
628     // The number of tokens burned.
629     uint256 private _burnCounter;
630 
631     // Token name
632     string private _name;
633 
634     // Token symbol
635     string private _symbol;
636 
637     // Mapping from token ID to ownership details
638     // An empty struct value does not necessarily mean the token is unowned.
639     // See `_packedOwnershipOf` implementation for details.
640     //
641     // Bits Layout:
642     // - [0..159]   `addr`
643     // - [160..223] `startTimestamp`
644     // - [224]      `burned`
645     // - [225]      `nextInitialized`
646     // - [232..255] `extraData`
647     mapping(uint256 => uint256) private _packedOwnerships;
648 
649     // Mapping owner address to address data.
650     //
651     // Bits Layout:
652     // - [0..63]    `balance`
653     // - [64..127]  `numberMinted`
654     // - [128..191] `numberBurned`
655     // - [192..255] `aux`
656     mapping(address => uint256) private _packedAddressData;
657 
658     // Mapping from token ID to approved address.
659     mapping(uint256 => address) private _tokenApprovals;
660 
661     // Mapping from owner to operator approvals
662     mapping(address => mapping(address => bool)) private _operatorApprovals;
663 
664     constructor(string memory name_, string memory symbol_) {
665         _name = name_;
666         _symbol = symbol_;
667         _currentIndex = _startTokenId();
668     }
669 
670     /**
671      * @dev Returns the starting token ID.
672      * To change the starting token ID, please override this function.
673      */
674     function _startTokenId() internal view virtual returns (uint256) {
675         return 0;
676     }
677 
678     /**
679      * @dev Returns the next token ID to be minted.
680      */
681     function _nextTokenId() internal view returns (uint256) {
682         return _currentIndex;
683     }
684 
685     /**
686      * @dev Returns the total number of tokens in existence.
687      * Burned tokens will reduce the count.
688      * To get the total number of tokens minted, please see `_totalMinted`.
689      */
690     function totalSupply() public view override returns (uint256) {
691         // Counter underflow is impossible as _burnCounter cannot be incremented
692         // more than `_currentIndex - _startTokenId()` times.
693         unchecked {
694             return _currentIndex - _burnCounter - _startTokenId();
695         }
696     }
697 
698     /**
699      * @dev Returns the total amount of tokens minted in the contract.
700      */
701     function _totalMinted() internal view returns (uint256) {
702         // Counter underflow is impossible as _currentIndex does not decrement,
703         // and it is initialized to `_startTokenId()`
704         unchecked {
705             return _currentIndex - _startTokenId();
706         }
707     }
708 
709     /**
710      * @dev Returns the total number of tokens burned.
711      */
712     function _totalBurned() internal view returns (uint256) {
713         return _burnCounter;
714     }
715 
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
720         // The interface IDs are constants representing the first 4 bytes of the XOR of
721         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
722         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
723         return
724             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
725             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
726             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
727     }
728 
729     /**
730      * @dev See {IERC721-balanceOf}.
731      */
732     function balanceOf(address owner) public view override returns (uint256) {
733         if (owner == address(0)) revert BalanceQueryForZeroAddress();
734         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
735     }
736 
737     /**
738      * Returns the number of tokens minted by `owner`.
739      */
740     function _numberMinted(address owner) internal view returns (uint256) {
741         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
742     }
743 
744     /**
745      * Returns the number of tokens burned by or on behalf of `owner`.
746      */
747     function _numberBurned(address owner) internal view returns (uint256) {
748         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
749     }
750 
751     /**
752      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
753      */
754     function _getAux(address owner) internal view returns (uint64) {
755         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
756     }
757 
758     /**
759      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
760      * If there are multiple variables, please pack them into a uint64.
761      */
762     function _setAux(address owner, uint64 aux) internal {
763         uint256 packed = _packedAddressData[owner];
764         uint256 auxCasted;
765         // Cast `aux` with assembly to avoid redundant masking.
766         assembly {
767             auxCasted := aux
768         }
769         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
770         _packedAddressData[owner] = packed;
771     }
772 
773     /**
774      * Returns the packed ownership data of `tokenId`.
775      */
776     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
777         uint256 curr = tokenId;
778 
779         unchecked {
780             if (_startTokenId() <= curr)
781                 if (curr < _currentIndex) {
782                     uint256 packed = _packedOwnerships[curr];
783                     // If not burned.
784                     if (packed & BITMASK_BURNED == 0) {
785                         // Invariant:
786                         // There will always be an ownership that has an address and is not burned
787                         // before an ownership that does not have an address and is not burned.
788                         // Hence, curr will not underflow.
789                         //
790                         // We can directly compare the packed value.
791                         // If the address is zero, packed is zero.
792                         while (packed == 0) {
793                             packed = _packedOwnerships[--curr];
794                         }
795                         return packed;
796                     }
797                 }
798         }
799         revert OwnerQueryForNonexistentToken();
800     }
801 
802     /**
803      * Returns the unpacked `TokenOwnership` struct from `packed`.
804      */
805     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
806         ownership.addr = address(uint160(packed));
807         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
808         ownership.burned = packed & BITMASK_BURNED != 0;
809         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
810     }
811 
812     /**
813      * Returns the unpacked `TokenOwnership` struct at `index`.
814      */
815     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
816         return _unpackedOwnership(_packedOwnerships[index]);
817     }
818 
819     /**
820      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
821      */
822     function _initializeOwnershipAt(uint256 index) internal {
823         if (_packedOwnerships[index] == 0) {
824             _packedOwnerships[index] = _packedOwnershipOf(index);
825         }
826     }
827 
828     /**
829      * Gas spent here starts off proportional to the maximum mint batch size.
830      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
831      */
832     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
833         return _unpackedOwnership(_packedOwnershipOf(tokenId));
834     }
835 
836     /**
837      * @dev Packs ownership data into a single uint256.
838      */
839     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
840         assembly {
841             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
842             owner := and(owner, BITMASK_ADDRESS)
843             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
844             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
845         }
846     }
847 
848     /**
849      * @dev See {IERC721-ownerOf}.
850      */
851     function ownerOf(uint256 tokenId) public view override returns (address) {
852         return address(uint160(_packedOwnershipOf(tokenId)));
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-name}.
857      */
858     function name() public view virtual override returns (string memory) {
859         return _name;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-symbol}.
864      */
865     function symbol() public view virtual override returns (string memory) {
866         return _symbol;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-tokenURI}.
871      */
872     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
873         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
874 
875         string memory baseURI = _baseURI();
876         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
877     }
878 
879     /**
880      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
881      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
882      * by default, it can be overridden in child contracts.
883      */
884     function _baseURI() internal view virtual returns (string memory) {
885         return '';
886     }
887 
888     /**
889      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
890      */
891     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
892         // For branchless setting of the `nextInitialized` flag.
893         assembly {
894             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
895             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
896         }
897     }
898 
899     /**
900      * @dev See {IERC721-approve}.
901      */
902     function approve(address to, uint256 tokenId) public override {
903         address owner = ownerOf(tokenId);
904 
905         if (_msgSenderERC721A() != owner)
906             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
907                 revert ApprovalCallerNotOwnerNorApproved();
908             }
909 
910         _tokenApprovals[tokenId] = to;
911         emit Approval(owner, to, tokenId);
912     }
913 
914     /**
915      * @dev See {IERC721-getApproved}.
916      */
917     function getApproved(uint256 tokenId) public view override returns (address) {
918         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
919 
920         return _tokenApprovals[tokenId];
921     }
922 
923     /**
924      * @dev See {IERC721-setApprovalForAll}.
925      */
926     function setApprovalForAll(address operator, bool approved) public virtual override {
927         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
928 
929         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
930         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
931     }
932 
933     /**
934      * @dev See {IERC721-isApprovedForAll}.
935      */
936     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev See {IERC721-safeTransferFrom}.
942      */
943     function safeTransferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         safeTransferFrom(from, to, tokenId, '');
949     }
950 
951     /**
952      * @dev See {IERC721-safeTransferFrom}.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) public virtual override {
960         transferFrom(from, to, tokenId);
961         if (to.code.length != 0)
962             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
963                 revert TransferToNonERC721ReceiverImplementer();
964             }
965     }
966 
967     /**
968      * @dev Returns whether `tokenId` exists.
969      *
970      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
971      *
972      * Tokens start existing when they are minted (`_mint`),
973      */
974     function _exists(uint256 tokenId) internal view returns (bool) {
975         return
976             _startTokenId() <= tokenId &&
977             tokenId < _currentIndex && // If within bounds,
978             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
979     }
980 
981     /**
982      * @dev Equivalent to `_safeMint(to, quantity, '')`.
983      */
984     function _safeMint(address to, uint256 quantity) internal {
985         _safeMint(to, quantity, '');
986     }
987 
988     /**
989      * @dev Safely mints `quantity` tokens and transfers them to `to`.
990      *
991      * Requirements:
992      *
993      * - If `to` refers to a smart contract, it must implement
994      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
995      * - `quantity` must be greater than 0.
996      *
997      * See {_mint}.
998      *
999      * Emits a {Transfer} event for each mint.
1000      */
1001     function _safeMint(
1002         address to,
1003         uint256 quantity,
1004         bytes memory _data
1005     ) internal {
1006         _mint(to, quantity);
1007 
1008         unchecked {
1009             if (to.code.length != 0) {
1010                 uint256 end = _currentIndex;
1011                 uint256 index = end - quantity;
1012                 do {
1013                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1014                         revert TransferToNonERC721ReceiverImplementer();
1015                     }
1016                 } while (index < end);
1017                 // Reentrancy protection.
1018                 if (_currentIndex != end) revert();
1019             }
1020         }
1021     }
1022 
1023     /**
1024      * @dev Mints `quantity` tokens and transfers them to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - `quantity` must be greater than 0.
1030      *
1031      * Emits a {Transfer} event for each mint.
1032      */
1033     function _mint(address to, uint256 quantity) internal {
1034         uint256 startTokenId = _currentIndex;
1035         if (to == address(0)) revert MintToZeroAddress();
1036         if (quantity == 0) revert MintZeroQuantity();
1037 
1038         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1039 
1040         // Overflows are incredibly unrealistic.
1041         // `balance` and `numberMinted` have a maximum limit of 2**64.
1042         // `tokenId` has a maximum limit of 2**256.
1043         unchecked {
1044             // Updates:
1045             // - `balance += quantity`.
1046             // - `numberMinted += quantity`.
1047             //
1048             // We can directly add to the `balance` and `numberMinted`.
1049             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1050 
1051             // Updates:
1052             // - `address` to the owner.
1053             // - `startTimestamp` to the timestamp of minting.
1054             // - `burned` to `false`.
1055             // - `nextInitialized` to `quantity == 1`.
1056             _packedOwnerships[startTokenId] = _packOwnershipData(
1057                 to,
1058                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1059             );
1060 
1061             uint256 tokenId = startTokenId;
1062             uint256 end = startTokenId + quantity;
1063             do {
1064                 emit Transfer(address(0), to, tokenId++);
1065             } while (tokenId < end);
1066 
1067             _currentIndex = end;
1068         }
1069         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1070     }
1071 
1072     /**
1073      * @dev Mints `quantity` tokens and transfers them to `to`.
1074      *
1075      * This function is intended for efficient minting only during contract creation.
1076      *
1077      * It emits only one {ConsecutiveTransfer} as defined in
1078      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1079      * instead of a sequence of {Transfer} event(s).
1080      *
1081      * Calling this function outside of contract creation WILL make your contract
1082      * non-compliant with the ERC721 standard.
1083      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1084      * {ConsecutiveTransfer} event is only permissible during contract creation.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {ConsecutiveTransfer} event.
1092      */
1093     function _mintERC2309(address to, uint256 quantity) internal {
1094         uint256 startTokenId = _currentIndex;
1095         if (to == address(0)) revert MintToZeroAddress();
1096         if (quantity == 0) revert MintZeroQuantity();
1097         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1098 
1099         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1100 
1101         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1102         unchecked {
1103             // Updates:
1104             // - `balance += quantity`.
1105             // - `numberMinted += quantity`.
1106             //
1107             // We can directly add to the `balance` and `numberMinted`.
1108             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1109 
1110             // Updates:
1111             // - `address` to the owner.
1112             // - `startTimestamp` to the timestamp of minting.
1113             // - `burned` to `false`.
1114             // - `nextInitialized` to `quantity == 1`.
1115             _packedOwnerships[startTokenId] = _packOwnershipData(
1116                 to,
1117                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1118             );
1119 
1120             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1121 
1122             _currentIndex = startTokenId + quantity;
1123         }
1124         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1125     }
1126 
1127     /**
1128      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1129      */
1130     function _getApprovedAddress(uint256 tokenId)
1131         private
1132         view
1133         returns (uint256 approvedAddressSlot, address approvedAddress)
1134     {
1135         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1136         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1137         assembly {
1138             // Compute the slot.
1139             mstore(0x00, tokenId)
1140             mstore(0x20, tokenApprovalsPtr.slot)
1141             approvedAddressSlot := keccak256(0x00, 0x40)
1142             // Load the slot's value from storage.
1143             approvedAddress := sload(approvedAddressSlot)
1144         }
1145     }
1146 
1147     /**
1148      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1149      */
1150     function _isOwnerOrApproved(
1151         address approvedAddress,
1152         address from,
1153         address msgSender
1154     ) private pure returns (bool result) {
1155         assembly {
1156             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1157             from := and(from, BITMASK_ADDRESS)
1158             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1159             msgSender := and(msgSender, BITMASK_ADDRESS)
1160             // `msgSender == from || msgSender == approvedAddress`.
1161             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1162         }
1163     }
1164 
1165     /**
1166      * @dev Transfers `tokenId` from `from` to `to`.
1167      *
1168      * Requirements:
1169      *
1170      * - `to` cannot be the zero address.
1171      * - `tokenId` token must be owned by `from`.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function transferFrom(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) public virtual override {
1180         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1181 
1182         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1183 
1184         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1185 
1186         // The nested ifs save around 20+ gas over a compound boolean condition.
1187         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1188             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1189 
1190         if (to == address(0)) revert TransferToZeroAddress();
1191 
1192         _beforeTokenTransfers(from, to, tokenId, 1);
1193 
1194         // Clear approvals from the previous owner.
1195         assembly {
1196             if approvedAddress {
1197                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1198                 sstore(approvedAddressSlot, 0)
1199             }
1200         }
1201 
1202         // Underflow of the sender's balance is impossible because we check for
1203         // ownership above and the recipient's balance can't realistically overflow.
1204         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1205         unchecked {
1206             // We can directly increment and decrement the balances.
1207             --_packedAddressData[from]; // Updates: `balance -= 1`.
1208             ++_packedAddressData[to]; // Updates: `balance += 1`.
1209 
1210             // Updates:
1211             // - `address` to the next owner.
1212             // - `startTimestamp` to the timestamp of transfering.
1213             // - `burned` to `false`.
1214             // - `nextInitialized` to `true`.
1215             _packedOwnerships[tokenId] = _packOwnershipData(
1216                 to,
1217                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1218             );
1219 
1220             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1221             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1222                 uint256 nextTokenId = tokenId + 1;
1223                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1224                 if (_packedOwnerships[nextTokenId] == 0) {
1225                     // If the next slot is within bounds.
1226                     if (nextTokenId != _currentIndex) {
1227                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1228                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1229                     }
1230                 }
1231             }
1232         }
1233 
1234         emit Transfer(from, to, tokenId);
1235         _afterTokenTransfers(from, to, tokenId, 1);
1236     }
1237 
1238     /**
1239      * @dev Equivalent to `_burn(tokenId, false)`.
1240      */
1241     function _burn(uint256 tokenId) internal virtual {
1242         _burn(tokenId, false);
1243     }
1244 
1245     /**
1246      * @dev Destroys `tokenId`.
1247      * The approval is cleared when the token is burned.
1248      *
1249      * Requirements:
1250      *
1251      * - `tokenId` must exist.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1256         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1257 
1258         address from = address(uint160(prevOwnershipPacked));
1259 
1260         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1261 
1262         if (approvalCheck) {
1263             // The nested ifs save around 20+ gas over a compound boolean condition.
1264             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1265                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1266         }
1267 
1268         _beforeTokenTransfers(from, address(0), tokenId, 1);
1269 
1270         // Clear approvals from the previous owner.
1271         assembly {
1272             if approvedAddress {
1273                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1274                 sstore(approvedAddressSlot, 0)
1275             }
1276         }
1277 
1278         // Underflow of the sender's balance is impossible because we check for
1279         // ownership above and the recipient's balance can't realistically overflow.
1280         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1281         unchecked {
1282             // Updates:
1283             // - `balance -= 1`.
1284             // - `numberBurned += 1`.
1285             //
1286             // We can directly decrement the balance, and increment the number burned.
1287             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1288             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1289 
1290             // Updates:
1291             // - `address` to the last owner.
1292             // - `startTimestamp` to the timestamp of burning.
1293             // - `burned` to `true`.
1294             // - `nextInitialized` to `true`.
1295             _packedOwnerships[tokenId] = _packOwnershipData(
1296                 from,
1297                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1298             );
1299 
1300             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1301             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1302                 uint256 nextTokenId = tokenId + 1;
1303                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1304                 if (_packedOwnerships[nextTokenId] == 0) {
1305                     // If the next slot is within bounds.
1306                     if (nextTokenId != _currentIndex) {
1307                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1308                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1309                     }
1310                 }
1311             }
1312         }
1313 
1314         emit Transfer(from, address(0), tokenId);
1315         _afterTokenTransfers(from, address(0), tokenId, 1);
1316 
1317         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1318         unchecked {
1319             _burnCounter++;
1320         }
1321     }
1322 
1323     /**
1324      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1325      *
1326      * @param from address representing the previous owner of the given token ID
1327      * @param to target address that will receive the tokens
1328      * @param tokenId uint256 ID of the token to be transferred
1329      * @param _data bytes optional data to send along with the call
1330      * @return bool whether the call correctly returned the expected magic value
1331      */
1332     function _checkContractOnERC721Received(
1333         address from,
1334         address to,
1335         uint256 tokenId,
1336         bytes memory _data
1337     ) private returns (bool) {
1338         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1339             bytes4 retval
1340         ) {
1341             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1342         } catch (bytes memory reason) {
1343             if (reason.length == 0) {
1344                 revert TransferToNonERC721ReceiverImplementer();
1345             } else {
1346                 assembly {
1347                     revert(add(32, reason), mload(reason))
1348                 }
1349             }
1350         }
1351     }
1352 
1353     /**
1354      * @dev Directly sets the extra data for the ownership data `index`.
1355      */
1356     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1357         uint256 packed = _packedOwnerships[index];
1358         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1359         uint256 extraDataCasted;
1360         // Cast `extraData` with assembly to avoid redundant masking.
1361         assembly {
1362             extraDataCasted := extraData
1363         }
1364         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1365         _packedOwnerships[index] = packed;
1366     }
1367 
1368     /**
1369      * @dev Returns the next extra data for the packed ownership data.
1370      * The returned result is shifted into position.
1371      */
1372     function _nextExtraData(
1373         address from,
1374         address to,
1375         uint256 prevOwnershipPacked
1376     ) private view returns (uint256) {
1377         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1378         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1379     }
1380 
1381     /**
1382      * @dev Called during each token transfer to set the 24bit `extraData` field.
1383      * Intended to be overridden by the cosumer contract.
1384      *
1385      * `previousExtraData` - the value of `extraData` before transfer.
1386      *
1387      * Calling conditions:
1388      *
1389      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1390      * transferred to `to`.
1391      * - When `from` is zero, `tokenId` will be minted for `to`.
1392      * - When `to` is zero, `tokenId` will be burned by `from`.
1393      * - `from` and `to` are never both zero.
1394      */
1395     function _extraData(
1396         address from,
1397         address to,
1398         uint24 previousExtraData
1399     ) internal view virtual returns (uint24) {}
1400 
1401     /**
1402      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1403      * This includes minting.
1404      * And also called before burning one token.
1405      *
1406      * startTokenId - the first token id to be transferred
1407      * quantity - the amount to be transferred
1408      *
1409      * Calling conditions:
1410      *
1411      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1412      * transferred to `to`.
1413      * - When `from` is zero, `tokenId` will be minted for `to`.
1414      * - When `to` is zero, `tokenId` will be burned by `from`.
1415      * - `from` and `to` are never both zero.
1416      */
1417     function _beforeTokenTransfers(
1418         address from,
1419         address to,
1420         uint256 startTokenId,
1421         uint256 quantity
1422     ) internal virtual {}
1423 
1424     /**
1425      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1426      * This includes minting.
1427      * And also called after one token has been burned.
1428      *
1429      * startTokenId - the first token id to be transferred
1430      * quantity - the amount to be transferred
1431      *
1432      * Calling conditions:
1433      *
1434      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1435      * transferred to `to`.
1436      * - When `from` is zero, `tokenId` has been minted for `to`.
1437      * - When `to` is zero, `tokenId` has been burned by `from`.
1438      * - `from` and `to` are never both zero.
1439      */
1440     function _afterTokenTransfers(
1441         address from,
1442         address to,
1443         uint256 startTokenId,
1444         uint256 quantity
1445     ) internal virtual {}
1446 
1447     /**
1448      * @dev Returns the message sender (defaults to `msg.sender`).
1449      *
1450      * If you are writing GSN compatible contracts, you need to override this function.
1451      */
1452     function _msgSenderERC721A() internal view virtual returns (address) {
1453         return msg.sender;
1454     }
1455 
1456     /**
1457      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1458      */
1459     function _toString(uint256 value) internal pure returns (string memory ptr) {
1460         assembly {
1461             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1462             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1463             // We will need 1 32-byte word to store the length,
1464             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1465             ptr := add(mload(0x40), 128)
1466             // Update the free memory pointer to allocate.
1467             mstore(0x40, ptr)
1468 
1469             // Cache the end of the memory to calculate the length later.
1470             let end := ptr
1471 
1472             // We write the string from the rightmost digit to the leftmost digit.
1473             // The following is essentially a do-while loop that also handles the zero case.
1474             // Costs a bit more than early returning for the zero case,
1475             // but cheaper in terms of deployment and overall runtime costs.
1476             for {
1477                 // Initialize and perform the first pass without check.
1478                 let temp := value
1479                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1480                 ptr := sub(ptr, 1)
1481                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1482                 mstore8(ptr, add(48, mod(temp, 10)))
1483                 temp := div(temp, 10)
1484             } temp {
1485                 // Keep dividing `temp` until zero.
1486                 temp := div(temp, 10)
1487             } {
1488                 // Body of the for loop.
1489                 ptr := sub(ptr, 1)
1490                 mstore8(ptr, add(48, mod(temp, 10)))
1491             }
1492 
1493             let length := sub(end, ptr)
1494             // Move the pointer 32 bytes leftwards to make room for the length.
1495             ptr := sub(ptr, 32)
1496             // Store the length.
1497             mstore(ptr, length)
1498         }
1499     }
1500 }
1501 
1502 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1503 
1504 
1505 // ERC721A Contracts v4.1.0
1506 // Creator: Chiru Labs
1507 
1508 pragma solidity ^0.8.4;
1509 
1510 
1511 /**
1512  * @dev Interface of an ERC721AQueryable compliant contract.
1513  */
1514 interface IERC721AQueryable is IERC721A {
1515     /**
1516      * Invalid query range (`start` >= `stop`).
1517      */
1518     error InvalidQueryRange();
1519 
1520     /**
1521      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1522      *
1523      * If the `tokenId` is out of bounds:
1524      *   - `addr` = `address(0)`
1525      *   - `startTimestamp` = `0`
1526      *   - `burned` = `false`
1527      *
1528      * If the `tokenId` is burned:
1529      *   - `addr` = `<Address of owner before token was burned>`
1530      *   - `startTimestamp` = `<Timestamp when token was burned>`
1531      *   - `burned = `true`
1532      *
1533      * Otherwise:
1534      *   - `addr` = `<Address of owner>`
1535      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1536      *   - `burned = `false`
1537      */
1538     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1539 
1540     /**
1541      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1542      * See {ERC721AQueryable-explicitOwnershipOf}
1543      */
1544     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1545 
1546     /**
1547      * @dev Returns an array of token IDs owned by `owner`,
1548      * in the range [`start`, `stop`)
1549      * (i.e. `start <= tokenId < stop`).
1550      *
1551      * This function allows for tokens to be queried if the collection
1552      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1553      *
1554      * Requirements:
1555      *
1556      * - `start` < `stop`
1557      */
1558     function tokensOfOwnerIn(
1559         address owner,
1560         uint256 start,
1561         uint256 stop
1562     ) external view returns (uint256[] memory);
1563 
1564     /**
1565      * @dev Returns an array of token IDs owned by `owner`.
1566      *
1567      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1568      * It is meant to be called off-chain.
1569      *
1570      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1571      * multiple smaller scans if the collection is large enough to cause
1572      * an out-of-gas error (10K pfp collections should be fine).
1573      */
1574     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1575 }
1576 
1577 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1578 
1579 
1580 // ERC721A Contracts v4.1.0
1581 // Creator: Chiru Labs
1582 
1583 pragma solidity ^0.8.4;
1584 
1585 
1586 
1587 /**
1588  * @title ERC721A Queryable
1589  * @dev ERC721A subclass with convenience query functions.
1590  */
1591 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1592     /**
1593      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1594      *
1595      * If the `tokenId` is out of bounds:
1596      *   - `addr` = `address(0)`
1597      *   - `startTimestamp` = `0`
1598      *   - `burned` = `false`
1599      *   - `extraData` = `0`
1600      *
1601      * If the `tokenId` is burned:
1602      *   - `addr` = `<Address of owner before token was burned>`
1603      *   - `startTimestamp` = `<Timestamp when token was burned>`
1604      *   - `burned = `true`
1605      *   - `extraData` = `<Extra data when token was burned>`
1606      *
1607      * Otherwise:
1608      *   - `addr` = `<Address of owner>`
1609      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1610      *   - `burned = `false`
1611      *   - `extraData` = `<Extra data at start of ownership>`
1612      */
1613     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1614         TokenOwnership memory ownership;
1615         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1616             return ownership;
1617         }
1618         ownership = _ownershipAt(tokenId);
1619         if (ownership.burned) {
1620             return ownership;
1621         }
1622         return _ownershipOf(tokenId);
1623     }
1624 
1625     /**
1626      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1627      * See {ERC721AQueryable-explicitOwnershipOf}
1628      */
1629     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1630         unchecked {
1631             uint256 tokenIdsLength = tokenIds.length;
1632             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1633             for (uint256 i; i != tokenIdsLength; ++i) {
1634                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1635             }
1636             return ownerships;
1637         }
1638     }
1639 
1640     /**
1641      * @dev Returns an array of token IDs owned by `owner`,
1642      * in the range [`start`, `stop`)
1643      * (i.e. `start <= tokenId < stop`).
1644      *
1645      * This function allows for tokens to be queried if the collection
1646      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1647      *
1648      * Requirements:
1649      *
1650      * - `start` < `stop`
1651      */
1652     function tokensOfOwnerIn(
1653         address owner,
1654         uint256 start,
1655         uint256 stop
1656     ) external view override returns (uint256[] memory) {
1657         unchecked {
1658             if (start >= stop) revert InvalidQueryRange();
1659             uint256 tokenIdsIdx;
1660             uint256 stopLimit = _nextTokenId();
1661             // Set `start = max(start, _startTokenId())`.
1662             if (start < _startTokenId()) {
1663                 start = _startTokenId();
1664             }
1665             // Set `stop = min(stop, stopLimit)`.
1666             if (stop > stopLimit) {
1667                 stop = stopLimit;
1668             }
1669             uint256 tokenIdsMaxLength = balanceOf(owner);
1670             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1671             // to cater for cases where `balanceOf(owner)` is too big.
1672             if (start < stop) {
1673                 uint256 rangeLength = stop - start;
1674                 if (rangeLength < tokenIdsMaxLength) {
1675                     tokenIdsMaxLength = rangeLength;
1676                 }
1677             } else {
1678                 tokenIdsMaxLength = 0;
1679             }
1680             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1681             if (tokenIdsMaxLength == 0) {
1682                 return tokenIds;
1683             }
1684             // We need to call `explicitOwnershipOf(start)`,
1685             // because the slot at `start` may not be initialized.
1686             TokenOwnership memory ownership = explicitOwnershipOf(start);
1687             address currOwnershipAddr;
1688             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1689             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1690             if (!ownership.burned) {
1691                 currOwnershipAddr = ownership.addr;
1692             }
1693             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1694                 ownership = _ownershipAt(i);
1695                 if (ownership.burned) {
1696                     continue;
1697                 }
1698                 if (ownership.addr != address(0)) {
1699                     currOwnershipAddr = ownership.addr;
1700                 }
1701                 if (currOwnershipAddr == owner) {
1702                     tokenIds[tokenIdsIdx++] = i;
1703                 }
1704             }
1705             // Downsize the array to fit.
1706             assembly {
1707                 mstore(tokenIds, tokenIdsIdx)
1708             }
1709             return tokenIds;
1710         }
1711     }
1712 
1713     /**
1714      * @dev Returns an array of token IDs owned by `owner`.
1715      *
1716      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1717      * It is meant to be called off-chain.
1718      *
1719      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1720      * multiple smaller scans if the collection is large enough to cause
1721      * an out-of-gas error (10K pfp collections should be fine).
1722      */
1723     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1724         unchecked {
1725             uint256 tokenIdsIdx;
1726             address currOwnershipAddr;
1727             uint256 tokenIdsLength = balanceOf(owner);
1728             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1729             TokenOwnership memory ownership;
1730             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1731                 ownership = _ownershipAt(i);
1732                 if (ownership.burned) {
1733                     continue;
1734                 }
1735                 if (ownership.addr != address(0)) {
1736                     currOwnershipAddr = ownership.addr;
1737                 }
1738                 if (currOwnershipAddr == owner) {
1739                     tokenIds[tokenIdsIdx++] = i;
1740                 }
1741             }
1742             return tokenIds;
1743         }
1744     }
1745 }
1746 
1747 
1748 
1749 pragma solidity ^0.8.0;
1750 
1751 
1752 
1753 
1754 
1755 /**
1756  * @dev These functions deal with verification of Merkle Tree proofs.
1757  *
1758  * The proofs can be generated using the JavaScript library
1759  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1760  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1761  *
1762  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1763  *
1764  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1765  * hashing, or use a hash function other than keccak256 for hashing leaves.
1766  * This is because the concatenation of a sorted pair of internal nodes in
1767  * the merkle tree could be reinterpreted as a leaf value.
1768  */
1769 library MerkleProof {
1770     /**
1771      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1772      * defined by `root`. For this, a `proof` must be provided, containing
1773      * sibling hashes on the branch from the leaf to the root of the tree. Each
1774      * pair of leaves and each pair of pre-images are assumed to be sorted.
1775      */
1776     function verify(
1777         bytes32[] memory proof,
1778         bytes32 root,
1779         bytes32 leaf
1780     ) internal pure returns (bool) {
1781         return processProof(proof, leaf) == root;
1782     }
1783 
1784     /**
1785      * @dev Calldata version of {verify}
1786      *
1787      * _Available since v4.7._
1788      */
1789     function verifyCalldata(
1790         bytes32[] calldata proof,
1791         bytes32 root,
1792         bytes32 leaf
1793     ) internal pure returns (bool) {
1794         return processProofCalldata(proof, leaf) == root;
1795     }
1796 
1797     /**
1798      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1799      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1800      * hash matches the root of the tree. When processing the proof, the pairs
1801      * of leafs & pre-images are assumed to be sorted.
1802      *
1803      * _Available since v4.4._
1804      */
1805     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1806         bytes32 computedHash = leaf;
1807         for (uint256 i = 0; i < proof.length; i++) {
1808             computedHash = _hashPair(computedHash, proof[i]);
1809         }
1810         return computedHash;
1811     }
1812 
1813     /**
1814      * @dev Calldata version of {processProof}
1815      *
1816      * _Available since v4.7._
1817      */
1818     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1819         bytes32 computedHash = leaf;
1820         for (uint256 i = 0; i < proof.length; i++) {
1821             computedHash = _hashPair(computedHash, proof[i]);
1822         }
1823         return computedHash;
1824     }
1825 
1826     /**
1827      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1828      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1829      *
1830      * _Available since v4.7._
1831      */
1832     function multiProofVerify(
1833         bytes32[] memory proof,
1834         bool[] memory proofFlags,
1835         bytes32 root,
1836         bytes32[] memory leaves
1837     ) internal pure returns (bool) {
1838         return processMultiProof(proof, proofFlags, leaves) == root;
1839     }
1840 
1841     /**
1842      * @dev Calldata version of {multiProofVerify}
1843      *
1844      * _Available since v4.7._
1845      */
1846     function multiProofVerifyCalldata(
1847         bytes32[] calldata proof,
1848         bool[] calldata proofFlags,
1849         bytes32 root,
1850         bytes32[] memory leaves
1851     ) internal pure returns (bool) {
1852         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1853     }
1854 
1855     /**
1856      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1857      * consuming from one or the other at each step according to the instructions given by
1858      * `proofFlags`.
1859      *
1860      * _Available since v4.7._
1861      */
1862     function processMultiProof(
1863         bytes32[] memory proof,
1864         bool[] memory proofFlags,
1865         bytes32[] memory leaves
1866     ) internal pure returns (bytes32 merkleRoot) {
1867         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1868         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1869         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1870         // the merkle tree.
1871         uint256 leavesLen = leaves.length;
1872         uint256 totalHashes = proofFlags.length;
1873 
1874         // Check proof validity.
1875         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1876 
1877         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1878         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1879         bytes32[] memory hashes = new bytes32[](totalHashes);
1880         uint256 leafPos = 0;
1881         uint256 hashPos = 0;
1882         uint256 proofPos = 0;
1883         // At each step, we compute the next hash using two values:
1884         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1885         //   get the next hash.
1886         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1887         //   `proof` array.
1888         for (uint256 i = 0; i < totalHashes; i++) {
1889             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1890             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1891             hashes[i] = _hashPair(a, b);
1892         }
1893 
1894         if (totalHashes > 0) {
1895             return hashes[totalHashes - 1];
1896         } else if (leavesLen > 0) {
1897             return leaves[0];
1898         } else {
1899             return proof[0];
1900         }
1901     }
1902 
1903     /**
1904      * @dev Calldata version of {processMultiProof}
1905      *
1906      * _Available since v4.7._
1907      */
1908     function processMultiProofCalldata(
1909         bytes32[] calldata proof,
1910         bool[] calldata proofFlags,
1911         bytes32[] memory leaves
1912     ) internal pure returns (bytes32 merkleRoot) {
1913         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1914         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1915         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1916         // the merkle tree.
1917         uint256 leavesLen = leaves.length;
1918         uint256 totalHashes = proofFlags.length;
1919 
1920         // Check proof validity.
1921         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1922 
1923         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1924         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1925         bytes32[] memory hashes = new bytes32[](totalHashes);
1926         uint256 leafPos = 0;
1927         uint256 hashPos = 0;
1928         uint256 proofPos = 0;
1929         // At each step, we compute the next hash using two values:
1930         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1931         //   get the next hash.
1932         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1933         //   `proof` array.
1934         for (uint256 i = 0; i < totalHashes; i++) {
1935             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1936             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1937             hashes[i] = _hashPair(a, b);
1938         }
1939 
1940         if (totalHashes > 0) {
1941             return hashes[totalHashes - 1];
1942         } else if (leavesLen > 0) {
1943             return leaves[0];
1944         } else {
1945             return proof[0];
1946         }
1947     }
1948 
1949     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1950         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1951     }
1952 
1953     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1954         /// @solidity memory-safe-assembly
1955         assembly {
1956             mstore(0x00, a)
1957             mstore(0x20, b)
1958             value := keccak256(0x00, 0x40)
1959         }
1960     }
1961 }
1962  pragma solidity ^0.8.0;
1963 
1964  contract Queeny00ts is ERC721A, Ownable, ReentrancyGuard {
1965 
1966 
1967 
1968   using Strings for uint;
1969  string public hiddenMetadataUri;
1970 
1971  bytes32 public merkleRoot;
1972   mapping(address => bool) public whitelistClaimed;
1973 
1974   string  public  baseTokenURI = "ipfs://none/";
1975   uint256  public  maxSupply = 8000;
1976   uint256 public  MAX_MINTS_PER_TX = 10;
1977   uint256 public  PUBLIC_SALE_PRICE = 0.003 ether;
1978   uint256 public  NUM_FREE_MINTS = 8000;
1979   uint256 public  MAX_FREE_PER_WALLET = 1;
1980   uint256 public freeNFTAlreadyMinted = 0;
1981   bool public isPublicSaleActive = false;
1982    bool public whitelistMintEnabled = false;
1983 
1984    constructor(
1985     string memory _tokenName,
1986     string memory _tokenSymbol,
1987     string memory _hiddenMetadataUri
1988   ) ERC721A(_tokenName, _tokenSymbol) {
1989     setHiddenMetadataUri(_hiddenMetadataUri);
1990   }
1991 
1992 
1993   function mint(uint256 numberOfTokens)
1994       external
1995       payable
1996   {
1997     require(isPublicSaleActive, "Public sale is not open");
1998     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1999 
2000     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
2001         require(
2002             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2003             "Incorrect ETH value sent"
2004         );
2005     } else {
2006         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
2007         require(
2008             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2009             "Incorrect ETH value sent"
2010         );
2011         require(
2012             numberOfTokens <= MAX_MINTS_PER_TX,
2013             "Max mints per transaction exceeded"
2014         );
2015         } else {
2016             require(
2017                 numberOfTokens <= MAX_FREE_PER_WALLET,
2018                 "Max mints per transaction exceeded"
2019             );
2020             freeNFTAlreadyMinted += numberOfTokens;
2021         }
2022     }
2023     _safeMint(msg.sender, numberOfTokens);
2024   }
2025 
2026   function setBaseURI(string memory baseURI)
2027     public
2028     onlyOwner
2029   {
2030     baseTokenURI = baseURI;
2031   }
2032 
2033   function treasuryMint(uint quantity)
2034     public
2035     onlyOwner
2036   {
2037     require(
2038       quantity > 0,
2039       "Invalid mint amount"
2040     );
2041     require(
2042       totalSupply() + quantity <= maxSupply,
2043       "Maximum supply exceeded"
2044     );
2045     _safeMint(msg.sender, quantity);
2046   }
2047 
2048 function withdraw() public onlyOwner nonReentrant {
2049     // This will transfer the remaining contract balance to the owner.
2050     // Do not remove this otherwise you will not be able to withdraw the funds.
2051     // =============================================================================
2052     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2053     require(os);
2054     // =============================================================================
2055   }
2056 
2057   function tokenURI(uint _tokenId)
2058     public
2059     view
2060     virtual
2061     override
2062     returns (string memory)
2063   {
2064     require(
2065       _exists(_tokenId),
2066       "ERC721Metadata: URI query for nonexistent token"
2067     );
2068     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
2069   }
2070 
2071   function _baseURI()
2072     internal
2073     view
2074     virtual
2075     override
2076     returns (string memory)
2077   {
2078     return baseTokenURI;
2079   }
2080 
2081   function setIsPublicSaleActive(bool _isPublicSaleActive)
2082       external
2083       onlyOwner
2084   {
2085       isPublicSaleActive = _isPublicSaleActive;
2086   }
2087   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2088     hiddenMetadataUri = _hiddenMetadataUri;
2089   }
2090 
2091   function setNumFreeMints(uint256 _numfreemints)
2092       external
2093       onlyOwner
2094   {
2095       NUM_FREE_MINTS = _numfreemints;
2096   }
2097 
2098   function setSalePrice(uint256 _price)
2099       external
2100       onlyOwner
2101   {
2102       PUBLIC_SALE_PRICE = _price;
2103   }
2104   function setMaxSupply(uint256 _maxsupply)
2105       external
2106       onlyOwner
2107   {
2108       maxSupply = _maxsupply;
2109   }
2110 
2111   function setMaxLimitPerTransaction(uint256 _limit)
2112       external
2113       onlyOwner
2114   {
2115       MAX_MINTS_PER_TX = _limit;
2116   }
2117   function setwhitelistMintEnabled(bool _wlMintEnabled)
2118       external
2119       onlyOwner
2120   {
2121       whitelistMintEnabled = _wlMintEnabled;
2122   }
2123   function whitelistMint(uint256 _price, bytes32[] calldata _merkleProof) public payable  {
2124     // Verify whitelist requirements
2125     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
2126     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
2127     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2128     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
2129 
2130     whitelistClaimed[_msgSender()] = true;
2131     _safeMint(_msgSender(), _price);
2132   }
2133 
2134   function setFreeLimitPerWallet(uint256 _limit)
2135       external
2136       onlyOwner
2137   {
2138       MAX_FREE_PER_WALLET = _limit;
2139   }
2140 }