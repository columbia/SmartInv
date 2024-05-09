1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4                ,---.                   _,.----.          ,-----,--,   
5     _..---.  .--.'  \   ,--.-.  .-,--.' .' -   \         | '-  -\==\  
6   .' .'.-. \ \==\-/\ \ /==/- / /=/_ /==/  ,  ,-'         \,--, '/==/  
7  /==/- '=' / /==/-|_\ |\==\, \/=/. /|==|-   |  .            /  /==/   
8  |==|-,   '  \==\,   - \\==\  \/ -/ |==|_   `-' \          / -/==/    
9  |==|  .=. \ /==/ -   ,| |==|  ,_/  |==|   _  , |         / -/==/     
10  /==/- '=' ,/==/-  /\ - \\==\-, /   \==\.       /        / `\==\_,--, 
11 |==|   -   /\==\ _.\=\.-'/==/._/     `-.`.___.-'        /` -   ,/==/  
12 `-._`.___,'  `--`        `--`-`                         `------`--`  
13 
14 By yuga Labs 2
15 */
16 
17 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Contract module that helps prevent reentrant calls to a function.
23  *
24  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
25  * available, which can be applied to functions to make sure there are no nested
26  * (reentrant) calls to them.
27  *
28  * Note that because there is a single `nonReentrant` guard, functions marked as
29  * `nonReentrant` may not call one another. This can be worked around by making
30  * those functions `private`, and then adding `external` `nonReentrant` entry
31  * points to them.
32  *
33  * TIP: If you would like to learn more about reentrancy and alternative ways
34  * to protect against it, check out our blog post
35  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
36  */
37 abstract contract ReentrancyGuard {
38     // Booleans are more expensive than uint256 or any type that takes up a full
39     // word because each write operation emits an extra SLOAD to first read the
40     // slot's contents, replace the bits taken up by the boolean, and then write
41     // back. This is the compiler's defense against contract upgrades and
42     // pointer aliasing, and it cannot be disabled.
43 
44     // The values being non-zero value makes deployment a bit more expensive,
45     // but in exchange the refund on every call to nonReentrant will be lower in
46     // amount. Since refunds are capped to a percentage of the total
47     // transaction's gas, it is best to keep them low in cases like this one, to
48     // increase the likelihood of the full refund coming into effect.
49     uint256 private constant _NOT_ENTERED = 1;
50     uint256 private constant _ENTERED = 2;
51 
52     uint256 private _status;
53 
54     constructor() {
55         _status = _NOT_ENTERED;
56     }
57 
58     /**
59      * @dev Prevents a contract from calling itself, directly or indirectly.
60      * Calling a `nonReentrant` function from another `nonReentrant`
61      * function is not supported. It is possible to prevent this from happening
62      * by making the `nonReentrant` function external, and making it call a
63      * `private` function that does the actual work.
64      */
65     modifier nonReentrant() {
66         // On the first call to nonReentrant, _notEntered will be true
67         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
68 
69         // Any calls to nonReentrant after this point will fail
70         _status = _ENTERED;
71 
72         _;
73 
74         // By storing the original value once again, a refund is triggered (see
75         // https://eips.ethereum.org/EIPS/eip-2200)
76         _status = _NOT_ENTERED;
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Strings.sol
81 
82 
83 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev String operations.
89  */
90 library Strings {
91     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
92     uint8 private constant _ADDRESS_LENGTH = 20;
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
96      */
97     function toString(uint256 value) internal pure returns (string memory) {
98         // Inspired by OraclizeAPI's implementation - MIT licence
99         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
100 
101         if (value == 0) {
102             return "0";
103         }
104         uint256 temp = value;
105         uint256 digits;
106         while (temp != 0) {
107             digits++;
108             temp /= 10;
109         }
110         bytes memory buffer = new bytes(digits);
111         while (value != 0) {
112             digits -= 1;
113             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
114             value /= 10;
115         }
116         return string(buffer);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
121      */
122     function toHexString(uint256 value) internal pure returns (string memory) {
123         if (value == 0) {
124             return "0x00";
125         }
126         uint256 temp = value;
127         uint256 length = 0;
128         while (temp != 0) {
129             length++;
130             temp >>= 8;
131         }
132         return toHexString(value, length);
133     }
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
137      */
138     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
139         bytes memory buffer = new bytes(2 * length + 2);
140         buffer[0] = "0";
141         buffer[1] = "x";
142         for (uint256 i = 2 * length + 1; i > 1; --i) {
143             buffer[i] = _HEX_SYMBOLS[value & 0xf];
144             value >>= 4;
145         }
146         require(value == 0, "Strings: hex length insufficient");
147         return string(buffer);
148     }
149 
150     /**
151      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
152      */
153     function toHexString(address addr) internal pure returns (string memory) {
154         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
155     }
156 }
157 
158 
159 // File: @openzeppelin/contracts/utils/Context.sol
160 
161 
162 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 /**
167  * @dev Provides information about the current execution context, including the
168  * sender of the transaction and its data. While these are generally available
169  * via msg.sender and msg.data, they should not be accessed in such a direct
170  * manner, since when dealing with meta-transactions the account sending and
171  * paying for execution may not be the actual sender (as far as an application
172  * is concerned).
173  *
174  * This contract is only required for intermediate, library-like contracts.
175  */
176 abstract contract Context {
177     function _msgSender() internal view virtual returns (address) {
178         return msg.sender;
179     }
180 
181     function _msgData() internal view virtual returns (bytes calldata) {
182         return msg.data;
183     }
184 }
185 
186 // File: @openzeppelin/contracts/access/Ownable.sol
187 
188 
189 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 
194 /**
195  * @dev Contract module which provides a basic access control mechanism, where
196  * there is an account (an owner) that can be granted exclusive access to
197  * specific functions.
198  *
199  * By default, the owner account will be the one that deploys the contract. This
200  * can later be changed with {transferOwnership}.
201  *
202  * This module is used through inheritance. It will make available the modifier
203  * `onlyOwner`, which can be applied to your functions to restrict their use to
204  * the owner.
205  */
206 abstract contract Ownable is Context {
207     address private _owner;
208 
209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
210 
211     /**
212      * @dev Initializes the contract setting the deployer as the initial owner.
213      */
214     constructor() {
215         _transferOwnership(_msgSender());
216     }
217 
218     /**
219      * @dev Throws if called by any account other than the owner.
220      */
221     modifier onlyOwner() {
222         _checkOwner();
223         _;
224     }
225 
226     /**
227      * @dev Returns the address of the current owner.
228      */
229     function owner() public view virtual returns (address) {
230         return _owner;
231     }
232 
233     /**
234      * @dev Throws if the sender is not the owner.
235      */
236     function _checkOwner() internal view virtual {
237         require(owner() == _msgSender(), "Ownable: caller is not the owner");
238     }
239 
240     /**
241      * @dev Leaves the contract without owner. It will not be possible to call
242      * `onlyOwner` functions anymore. Can only be called by the current owner.
243      *
244      * NOTE: Renouncing ownership will leave the contract without an owner,
245      * thereby removing any functionality that is only available to the owner.
246      */
247     function renounceOwnership() public virtual onlyOwner {
248         _transferOwnership(address(0));
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      * Can only be called by the current owner.
254      */
255     function transferOwnership(address newOwner) public virtual onlyOwner {
256         require(newOwner != address(0), "Ownable: new owner is the zero address");
257         _transferOwnership(newOwner);
258     }
259 
260     /**
261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
262      * Internal function without access restriction.
263      */
264     function _transferOwnership(address newOwner) internal virtual {
265         address oldOwner = _owner;
266         _owner = newOwner;
267         emit OwnershipTransferred(oldOwner, newOwner);
268     }
269 }
270 
271 // File: erc721a/contracts/IERC721A.sol
272 
273 
274 // ERC721A Contracts v4.1.0
275 // Creator: Chiru Labs
276 
277 pragma solidity ^0.8.4;
278 
279 /**
280  * @dev Interface of an ERC721A compliant contract.
281  */
282 interface IERC721A {
283     /**
284      * The caller must own the token or be an approved operator.
285      */
286     error ApprovalCallerNotOwnerNorApproved();
287 
288     /**
289      * The token does not exist.
290      */
291     error ApprovalQueryForNonexistentToken();
292 
293     /**
294      * The caller cannot approve to their own address.
295      */
296     error ApproveToCaller();
297 
298     /**
299      * Cannot query the balance for the zero address.
300      */
301     error BalanceQueryForZeroAddress();
302 
303     /**
304      * Cannot mint to the zero address.
305      */
306     error MintToZeroAddress();
307 
308     /**
309      * The quantity of tokens minted must be more than zero.
310      */
311     error MintZeroQuantity();
312 
313     /**
314      * The token does not exist.
315      */
316     error OwnerQueryForNonexistentToken();
317 
318     /**
319      * The caller must own the token or be an approved operator.
320      */
321     error TransferCallerNotOwnerNorApproved();
322 
323     /**
324      * The token must be owned by `from`.
325      */
326     error TransferFromIncorrectOwner();
327 
328     /**
329      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
330      */
331     error TransferToNonERC721ReceiverImplementer();
332 
333     /**
334      * Cannot transfer to the zero address.
335      */
336     error TransferToZeroAddress();
337 
338     /**
339      * The token does not exist.
340      */
341     error URIQueryForNonexistentToken();
342 
343     /**
344      * The `quantity` minted with ERC2309 exceeds the safety limit.
345      */
346     error MintERC2309QuantityExceedsLimit();
347 
348     /**
349      * The `extraData` cannot be set on an unintialized ownership slot.
350      */
351     error OwnershipNotInitializedForExtraData();
352 
353     struct TokenOwnership {
354         // The address of the owner.
355         address addr;
356         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
357         uint64 startTimestamp;
358         // Whether the token has been burned.
359         bool burned;
360         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
361         uint24 extraData;
362     }
363 
364     /**
365      * @dev Returns the total amount of tokens stored by the contract.
366      *
367      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
368      */
369     function totalSupply() external view returns (uint256);
370 
371     // ==============================
372     //            IERC165
373     // ==============================
374 
375     /**
376      * @dev Returns true if this contract implements the interface defined by
377      * `interfaceId`. See the corresponding
378      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
379      * to learn more about how these ids are created.
380      *
381      * This function call must use less than 30 000 gas.
382      */
383     function supportsInterface(bytes4 interfaceId) external view returns (bool);
384 
385     // ==============================
386     //            IERC721
387     // ==============================
388 
389     /**
390      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
391      */
392     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
396      */
397     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
401      */
402     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
403 
404     /**
405      * @dev Returns the number of tokens in ``owner``'s account.
406      */
407     function balanceOf(address owner) external view returns (uint256 balance);
408 
409     /**
410      * @dev Returns the owner of the `tokenId` token.
411      *
412      * Requirements:
413      *
414      * - `tokenId` must exist.
415      */
416     function ownerOf(uint256 tokenId) external view returns (address owner);
417 
418     /**
419      * @dev Safely transfers `tokenId` token from `from` to `to`.
420      *
421      * Requirements:
422      *
423      * - `from` cannot be the zero address.
424      * - `to` cannot be the zero address.
425      * - `tokenId` token must exist and be owned by `from`.
426      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
427      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
428      *
429      * Emits a {Transfer} event.
430      */
431     function safeTransferFrom(
432         address from,
433         address to,
434         uint256 tokenId,
435         bytes calldata data
436     ) external;
437 
438     /**
439      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
440      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId
456     ) external;
457 
458     /**
459      * @dev Transfers `tokenId` token from `from` to `to`.
460      *
461      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
462      *
463      * Requirements:
464      *
465      * - `from` cannot be the zero address.
466      * - `to` cannot be the zero address.
467      * - `tokenId` token must be owned by `from`.
468      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
469      *
470      * Emits a {Transfer} event.
471      */
472     function transferFrom(
473         address from,
474         address to,
475         uint256 tokenId
476     ) external;
477 
478     /**
479      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
480      * The approval is cleared when the token is transferred.
481      *
482      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
483      *
484      * Requirements:
485      *
486      * - The caller must own the token or be an approved operator.
487      * - `tokenId` must exist.
488      *
489      * Emits an {Approval} event.
490      */
491     function approve(address to, uint256 tokenId) external;
492 
493     /**
494      * @dev Approve or remove `operator` as an operator for the caller.
495      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
496      *
497      * Requirements:
498      *
499      * - The `operator` cannot be the caller.
500      *
501      * Emits an {ApprovalForAll} event.
502      */
503     function setApprovalForAll(address operator, bool _approved) external;
504 
505     /**
506      * @dev Returns the account approved for `tokenId` token.
507      *
508      * Requirements:
509      *
510      * - `tokenId` must exist.
511      */
512     function getApproved(uint256 tokenId) external view returns (address operator);
513 
514     /**
515      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
516      *
517      * See {setApprovalForAll}
518      */
519     function isApprovedForAll(address owner, address operator) external view returns (bool);
520 
521     // ==============================
522     //        IERC721Metadata
523     // ==============================
524 
525     /**
526      * @dev Returns the token collection name.
527      */
528     function name() external view returns (string memory);
529 
530     /**
531      * @dev Returns the token collection symbol.
532      */
533     function symbol() external view returns (string memory);
534 
535     /**
536      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
537      */
538     function tokenURI(uint256 tokenId) external view returns (string memory);
539 
540     // ==============================
541     //            IERC2309
542     // ==============================
543 
544     /**
545      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
546      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
547      */
548     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
549 }
550 
551 // File: erc721a/contracts/ERC721A.sol
552 
553 
554 // ERC721A Contracts v4.1.0
555 // Creator: Chiru Labs
556 
557 pragma solidity ^0.8.4;
558 
559 
560 /**
561  * @dev ERC721 token receiver interface.
562  */
563 interface ERC721A__IERC721Receiver {
564     function onERC721Received(
565         address operator,
566         address from,
567         uint256 tokenId,
568         bytes calldata data
569     ) external returns (bytes4);
570 }
571 
572 /**
573  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
574  * including the Metadata extension. Built to optimize for lower gas during batch mints.
575  *
576  * Assumes serials are sequentially minted starting at `_startTokenId()`
577  * (defaults to 0, e.g. 0, 1, 2, 3..).
578  *
579  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
580  *
581  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
582  */
583 contract ERC721A is IERC721A {
584     // Mask of an entry in packed address data.
585     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
586 
587     // The bit position of `numberMinted` in packed address data.
588     uint256 private constant BITPOS_NUMBER_MINTED = 64;
589 
590     // The bit position of `numberBurned` in packed address data.
591     uint256 private constant BITPOS_NUMBER_BURNED = 128;
592 
593     // The bit position of `aux` in packed address data.
594     uint256 private constant BITPOS_AUX = 192;
595 
596     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
597     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
598 
599     // The bit position of `startTimestamp` in packed ownership.
600     uint256 private constant BITPOS_START_TIMESTAMP = 160;
601 
602     // The bit mask of the `burned` bit in packed ownership.
603     uint256 private constant BITMASK_BURNED = 1 << 224;
604 
605     // The bit position of the `nextInitialized` bit in packed ownership.
606     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
607 
608     // The bit mask of the `nextInitialized` bit in packed ownership.
609     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
610 
611     // The bit position of `extraData` in packed ownership.
612     uint256 private constant BITPOS_EXTRA_DATA = 232;
613 
614     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
615     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
616 
617     // The mask of the lower 160 bits for addresses.
618     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
619 
620     // The maximum `quantity` that can be minted with `_mintERC2309`.
621     // This limit is to prevent overflows on the address data entries.
622     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
623     // is required to cause an overflow, which is unrealistic.
624     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
625 
626     // The tokenId of the next token to be minted.
627     uint256 private _currentIndex;
628 
629     // The number of tokens burned.
630     uint256 private _burnCounter;
631 
632     // Token name
633     string private _name;
634 
635     // Token symbol
636     string private _symbol;
637 
638     // Mapping from token ID to ownership details
639     // An empty struct value does not necessarily mean the token is unowned.
640     // See `_packedOwnershipOf` implementation for details.
641     //
642     // Bits Layout:
643     // - [0..159]   `addr`
644     // - [160..223] `startTimestamp`
645     // - [224]      `burned`
646     // - [225]      `nextInitialized`
647     // - [232..255] `extraData`
648     mapping(uint256 => uint256) private _packedOwnerships;
649 
650     // Mapping owner address to address data.
651     //
652     // Bits Layout:
653     // - [0..63]    `balance`
654     // - [64..127]  `numberMinted`
655     // - [128..191] `numberBurned`
656     // - [192..255] `aux`
657     mapping(address => uint256) private _packedAddressData;
658 
659     // Mapping from token ID to approved address.
660     mapping(uint256 => address) private _tokenApprovals;
661 
662     // Mapping from owner to operator approvals
663     mapping(address => mapping(address => bool)) private _operatorApprovals;
664 
665     constructor(string memory name_, string memory symbol_) {
666         _name = name_;
667         _symbol = symbol_;
668         _currentIndex = _startTokenId();
669     }
670 
671     /**
672      * @dev Returns the starting token ID.
673      * To change the starting token ID, please override this function.
674      */
675     function _startTokenId() internal view virtual returns (uint256) {
676         return 0;
677     }
678 
679     /**
680      * @dev Returns the next token ID to be minted.
681      */
682     function _nextTokenId() internal view returns (uint256) {
683         return _currentIndex;
684     }
685 
686     /**
687      * @dev Returns the total number of tokens in existence.
688      * Burned tokens will reduce the count.
689      * To get the total number of tokens minted, please see `_totalMinted`.
690      */
691     function totalSupply() public view override returns (uint256) {
692         // Counter underflow is impossible as _burnCounter cannot be incremented
693         // more than `_currentIndex - _startTokenId()` times.
694         unchecked {
695             return _currentIndex - _burnCounter - _startTokenId();
696         }
697     }
698 
699     /**
700      * @dev Returns the total amount of tokens minted in the contract.
701      */
702     function _totalMinted() internal view returns (uint256) {
703         // Counter underflow is impossible as _currentIndex does not decrement,
704         // and it is initialized to `_startTokenId()`
705         unchecked {
706             return _currentIndex - _startTokenId();
707         }
708     }
709 
710     /**
711      * @dev Returns the total number of tokens burned.
712      */
713     function _totalBurned() internal view returns (uint256) {
714         return _burnCounter;
715     }
716 
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
721         // The interface IDs are constants representing the first 4 bytes of the XOR of
722         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
723         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
724         return
725             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
726             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
727             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
728     }
729 
730     /**
731      * @dev See {IERC721-balanceOf}.
732      */
733     function balanceOf(address owner) public view override returns (uint256) {
734         if (owner == address(0)) revert BalanceQueryForZeroAddress();
735         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
736     }
737 
738     /**
739      * Returns the number of tokens minted by `owner`.
740      */
741     function _numberMinted(address owner) internal view returns (uint256) {
742         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
743     }
744 
745     /**
746      * Returns the number of tokens burned by or on behalf of `owner`.
747      */
748     function _numberBurned(address owner) internal view returns (uint256) {
749         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
750     }
751 
752     /**
753      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
754      */
755     function _getAux(address owner) internal view returns (uint64) {
756         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
757     }
758 
759     /**
760      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
761      * If there are multiple variables, please pack them into a uint64.
762      */
763     function _setAux(address owner, uint64 aux) internal {
764         uint256 packed = _packedAddressData[owner];
765         uint256 auxCasted;
766         // Cast `aux` with assembly to avoid redundant masking.
767         assembly {
768             auxCasted := aux
769         }
770         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
771         _packedAddressData[owner] = packed;
772     }
773 
774     /**
775      * Returns the packed ownership data of `tokenId`.
776      */
777     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
778         uint256 curr = tokenId;
779 
780         unchecked {
781             if (_startTokenId() <= curr)
782                 if (curr < _currentIndex) {
783                     uint256 packed = _packedOwnerships[curr];
784                     // If not burned.
785                     if (packed & BITMASK_BURNED == 0) {
786                         // Invariant:
787                         // There will always be an ownership that has an address and is not burned
788                         // before an ownership that does not have an address and is not burned.
789                         // Hence, curr will not underflow.
790                         //
791                         // We can directly compare the packed value.
792                         // If the address is zero, packed is zero.
793                         while (packed == 0) {
794                             packed = _packedOwnerships[--curr];
795                         }
796                         return packed;
797                     }
798                 }
799         }
800         revert OwnerQueryForNonexistentToken();
801     }
802 
803     /**
804      * Returns the unpacked `TokenOwnership` struct from `packed`.
805      */
806     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
807         ownership.addr = address(uint160(packed));
808         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
809         ownership.burned = packed & BITMASK_BURNED != 0;
810         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
811     }
812 
813     /**
814      * Returns the unpacked `TokenOwnership` struct at `index`.
815      */
816     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
817         return _unpackedOwnership(_packedOwnerships[index]);
818     }
819 
820     /**
821      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
822      */
823     function _initializeOwnershipAt(uint256 index) internal {
824         if (_packedOwnerships[index] == 0) {
825             _packedOwnerships[index] = _packedOwnershipOf(index);
826         }
827     }
828 
829     /**
830      * Gas spent here starts off proportional to the maximum mint batch size.
831      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
832      */
833     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
834         return _unpackedOwnership(_packedOwnershipOf(tokenId));
835     }
836 
837     /**
838      * @dev Packs ownership data into a single uint256.
839      */
840     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
841         assembly {
842             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
843             owner := and(owner, BITMASK_ADDRESS)
844             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
845             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
846         }
847     }
848 
849     /**
850      * @dev See {IERC721-ownerOf}.
851      */
852     function ownerOf(uint256 tokenId) public view override returns (address) {
853         return address(uint160(_packedOwnershipOf(tokenId)));
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-name}.
858      */
859     function name() public view virtual override returns (string memory) {
860         return _name;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-symbol}.
865      */
866     function symbol() public view virtual override returns (string memory) {
867         return _symbol;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-tokenURI}.
872      */
873     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
874         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
875 
876         string memory baseURI = _baseURI();
877         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
878     }
879 
880     /**
881      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
882      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
883      * by default, it can be overridden in child contracts.
884      */
885     function _baseURI() internal view virtual returns (string memory) {
886         return '';
887     }
888 
889     /**
890      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
891      */
892     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
893         // For branchless setting of the `nextInitialized` flag.
894         assembly {
895             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
896             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
897         }
898     }
899 
900     /**
901      * @dev See {IERC721-approve}.
902      */
903     function approve(address to, uint256 tokenId) public override {
904         address owner = ownerOf(tokenId);
905 
906         if (_msgSenderERC721A() != owner)
907             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
908                 revert ApprovalCallerNotOwnerNorApproved();
909             }
910 
911         _tokenApprovals[tokenId] = to;
912         emit Approval(owner, to, tokenId);
913     }
914 
915     /**
916      * @dev See {IERC721-getApproved}.
917      */
918     function getApproved(uint256 tokenId) public view override returns (address) {
919         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
920 
921         return _tokenApprovals[tokenId];
922     }
923 
924     /**
925      * @dev See {IERC721-setApprovalForAll}.
926      */
927     function setApprovalForAll(address operator, bool approved) public virtual override {
928         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
929 
930         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
931         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
932     }
933 
934     /**
935      * @dev See {IERC721-isApprovedForAll}.
936      */
937     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
938         return _operatorApprovals[owner][operator];
939     }
940 
941     /**
942      * @dev See {IERC721-safeTransferFrom}.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) public virtual override {
949         safeTransferFrom(from, to, tokenId, '');
950     }
951 
952     /**
953      * @dev See {IERC721-safeTransferFrom}.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) public virtual override {
961         transferFrom(from, to, tokenId);
962         if (to.code.length != 0)
963             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
964                 revert TransferToNonERC721ReceiverImplementer();
965             }
966     }
967 
968     /**
969      * @dev Returns whether `tokenId` exists.
970      *
971      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
972      *
973      * Tokens start existing when they are minted (`_mint`),
974      */
975     function _exists(uint256 tokenId) internal view returns (bool) {
976         return
977             _startTokenId() <= tokenId &&
978             tokenId < _currentIndex && // If within bounds,
979             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
980     }
981 
982     /**
983      * @dev Equivalent to `_safeMint(to, quantity, '')`.
984      */
985     function _safeMint(address to, uint256 quantity) internal {
986         _safeMint(to, quantity, '');
987     }
988 
989     /**
990      * @dev Safely mints `quantity` tokens and transfers them to `to`.
991      *
992      * Requirements:
993      *
994      * - If `to` refers to a smart contract, it must implement
995      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
996      * - `quantity` must be greater than 0.
997      *
998      * See {_mint}.
999      *
1000      * Emits a {Transfer} event for each mint.
1001      */
1002     function _safeMint(
1003         address to,
1004         uint256 quantity,
1005         bytes memory _data
1006     ) internal {
1007         _mint(to, quantity);
1008 
1009         unchecked {
1010             if (to.code.length != 0) {
1011                 uint256 end = _currentIndex;
1012                 uint256 index = end - quantity;
1013                 do {
1014                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1015                         revert TransferToNonERC721ReceiverImplementer();
1016                     }
1017                 } while (index < end);
1018                 // Reentrancy protection.
1019                 if (_currentIndex != end) revert();
1020             }
1021         }
1022     }
1023 
1024     /**
1025      * @dev Mints `quantity` tokens and transfers them to `to`.
1026      *
1027      * Requirements:
1028      *
1029      * - `to` cannot be the zero address.
1030      * - `quantity` must be greater than 0.
1031      *
1032      * Emits a {Transfer} event for each mint.
1033      */
1034     function _mint(address to, uint256 quantity) internal {
1035         uint256 startTokenId = _currentIndex;
1036         if (to == address(0)) revert MintToZeroAddress();
1037         if (quantity == 0) revert MintZeroQuantity();
1038 
1039         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1040 
1041         // Overflows are incredibly unrealistic.
1042         // `balance` and `numberMinted` have a maximum limit of 2**64.
1043         // `tokenId` has a maximum limit of 2**256.
1044         unchecked {
1045             // Updates:
1046             // - `balance += quantity`.
1047             // - `numberMinted += quantity`.
1048             //
1049             // We can directly add to the `balance` and `numberMinted`.
1050             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1051 
1052             // Updates:
1053             // - `address` to the owner.
1054             // - `startTimestamp` to the timestamp of minting.
1055             // - `burned` to `false`.
1056             // - `nextInitialized` to `quantity == 1`.
1057             _packedOwnerships[startTokenId] = _packOwnershipData(
1058                 to,
1059                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1060             );
1061 
1062             uint256 tokenId = startTokenId;
1063             uint256 end = startTokenId + quantity;
1064             do {
1065                 emit Transfer(address(0), to, tokenId++);
1066             } while (tokenId < end);
1067 
1068             _currentIndex = end;
1069         }
1070         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1071     }
1072 
1073     /**
1074      * @dev Mints `quantity` tokens and transfers them to `to`.
1075      *
1076      * This function is intended for efficient minting only during contract creation.
1077      *
1078      * It emits only one {ConsecutiveTransfer} as defined in
1079      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1080      * instead of a sequence of {Transfer} event(s).
1081      *
1082      * Calling this function outside of contract creation WILL make your contract
1083      * non-compliant with the ERC721 standard.
1084      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1085      * {ConsecutiveTransfer} event is only permissible during contract creation.
1086      *
1087      * Requirements:
1088      *
1089      * - `to` cannot be the zero address.
1090      * - `quantity` must be greater than 0.
1091      *
1092      * Emits a {ConsecutiveTransfer} event.
1093      */
1094     function _mintERC2309(address to, uint256 quantity) internal {
1095         uint256 startTokenId = _currentIndex;
1096         if (to == address(0)) revert MintToZeroAddress();
1097         if (quantity == 0) revert MintZeroQuantity();
1098         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1099 
1100         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1101 
1102         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1103         unchecked {
1104             // Updates:
1105             // - `balance += quantity`.
1106             // - `numberMinted += quantity`.
1107             //
1108             // We can directly add to the `balance` and `numberMinted`.
1109             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1110 
1111             // Updates:
1112             // - `address` to the owner.
1113             // - `startTimestamp` to the timestamp of minting.
1114             // - `burned` to `false`.
1115             // - `nextInitialized` to `quantity == 1`.
1116             _packedOwnerships[startTokenId] = _packOwnershipData(
1117                 to,
1118                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1119             );
1120 
1121             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1122 
1123             _currentIndex = startTokenId + quantity;
1124         }
1125         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1126     }
1127 
1128     /**
1129      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1130      */
1131     function _getApprovedAddress(uint256 tokenId)
1132         private
1133         view
1134         returns (uint256 approvedAddressSlot, address approvedAddress)
1135     {
1136         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1137         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1138         assembly {
1139             // Compute the slot.
1140             mstore(0x00, tokenId)
1141             mstore(0x20, tokenApprovalsPtr.slot)
1142             approvedAddressSlot := keccak256(0x00, 0x40)
1143             // Load the slot's value from storage.
1144             approvedAddress := sload(approvedAddressSlot)
1145         }
1146     }
1147 
1148     /**
1149      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1150      */
1151     function _isOwnerOrApproved(
1152         address approvedAddress,
1153         address from,
1154         address msgSender
1155     ) private pure returns (bool result) {
1156         assembly {
1157             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1158             from := and(from, BITMASK_ADDRESS)
1159             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1160             msgSender := and(msgSender, BITMASK_ADDRESS)
1161             // `msgSender == from || msgSender == approvedAddress`.
1162             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1163         }
1164     }
1165 
1166     /**
1167      * @dev Transfers `tokenId` from `from` to `to`.
1168      *
1169      * Requirements:
1170      *
1171      * - `to` cannot be the zero address.
1172      * - `tokenId` token must be owned by `from`.
1173      *
1174      * Emits a {Transfer} event.
1175      */
1176     function transferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) public virtual override {
1181         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1182 
1183         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1184 
1185         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1186 
1187         // The nested ifs save around 20+ gas over a compound boolean condition.
1188         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1189             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1190 
1191         if (to == address(0)) revert TransferToZeroAddress();
1192 
1193         _beforeTokenTransfers(from, to, tokenId, 1);
1194 
1195         // Clear approvals from the previous owner.
1196         assembly {
1197             if approvedAddress {
1198                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1199                 sstore(approvedAddressSlot, 0)
1200             }
1201         }
1202 
1203         // Underflow of the sender's balance is impossible because we check for
1204         // ownership above and the recipient's balance can't realistically overflow.
1205         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1206         unchecked {
1207             // We can directly increment and decrement the balances.
1208             --_packedAddressData[from]; // Updates: `balance -= 1`.
1209             ++_packedAddressData[to]; // Updates: `balance += 1`.
1210 
1211             // Updates:
1212             // - `address` to the next owner.
1213             // - `startTimestamp` to the timestamp of transfering.
1214             // - `burned` to `false`.
1215             // - `nextInitialized` to `true`.
1216             _packedOwnerships[tokenId] = _packOwnershipData(
1217                 to,
1218                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1219             );
1220 
1221             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1222             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1223                 uint256 nextTokenId = tokenId + 1;
1224                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1225                 if (_packedOwnerships[nextTokenId] == 0) {
1226                     // If the next slot is within bounds.
1227                     if (nextTokenId != _currentIndex) {
1228                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1229                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1230                     }
1231                 }
1232             }
1233         }
1234 
1235         emit Transfer(from, to, tokenId);
1236         _afterTokenTransfers(from, to, tokenId, 1);
1237     }
1238 
1239     /**
1240      * @dev Equivalent to `_burn(tokenId, false)`.
1241      */
1242     function _burn(uint256 tokenId) internal virtual {
1243         _burn(tokenId, false);
1244     }
1245 
1246     /**
1247      * @dev Destroys `tokenId`.
1248      * The approval is cleared when the token is burned.
1249      *
1250      * Requirements:
1251      *
1252      * - `tokenId` must exist.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1257         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1258 
1259         address from = address(uint160(prevOwnershipPacked));
1260 
1261         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1262 
1263         if (approvalCheck) {
1264             // The nested ifs save around 20+ gas over a compound boolean condition.
1265             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1266                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1267         }
1268 
1269         _beforeTokenTransfers(from, address(0), tokenId, 1);
1270 
1271         // Clear approvals from the previous owner.
1272         assembly {
1273             if approvedAddress {
1274                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1275                 sstore(approvedAddressSlot, 0)
1276             }
1277         }
1278 
1279         // Underflow of the sender's balance is impossible because we check for
1280         // ownership above and the recipient's balance can't realistically overflow.
1281         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1282         unchecked {
1283             // Updates:
1284             // - `balance -= 1`.
1285             // - `numberBurned += 1`.
1286             //
1287             // We can directly decrement the balance, and increment the number burned.
1288             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1289             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1290 
1291             // Updates:
1292             // - `address` to the last owner.
1293             // - `startTimestamp` to the timestamp of burning.
1294             // - `burned` to `true`.
1295             // - `nextInitialized` to `true`.
1296             _packedOwnerships[tokenId] = _packOwnershipData(
1297                 from,
1298                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1299             );
1300 
1301             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1302             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1303                 uint256 nextTokenId = tokenId + 1;
1304                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1305                 if (_packedOwnerships[nextTokenId] == 0) {
1306                     // If the next slot is within bounds.
1307                     if (nextTokenId != _currentIndex) {
1308                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1309                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1310                     }
1311                 }
1312             }
1313         }
1314 
1315         emit Transfer(from, address(0), tokenId);
1316         _afterTokenTransfers(from, address(0), tokenId, 1);
1317 
1318         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1319         unchecked {
1320             _burnCounter++;
1321         }
1322     }
1323 
1324     /**
1325      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1326      *
1327      * @param from address representing the previous owner of the given token ID
1328      * @param to target address that will receive the tokens
1329      * @param tokenId uint256 ID of the token to be transferred
1330      * @param _data bytes optional data to send along with the call
1331      * @return bool whether the call correctly returned the expected magic value
1332      */
1333     function _checkContractOnERC721Received(
1334         address from,
1335         address to,
1336         uint256 tokenId,
1337         bytes memory _data
1338     ) private returns (bool) {
1339         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1340             bytes4 retval
1341         ) {
1342             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1343         } catch (bytes memory reason) {
1344             if (reason.length == 0) {
1345                 revert TransferToNonERC721ReceiverImplementer();
1346             } else {
1347                 assembly {
1348                     revert(add(32, reason), mload(reason))
1349                 }
1350             }
1351         }
1352     }
1353 
1354     /**
1355      * @dev Directly sets the extra data for the ownership data `index`.
1356      */
1357     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1358         uint256 packed = _packedOwnerships[index];
1359         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1360         uint256 extraDataCasted;
1361         // Cast `extraData` with assembly to avoid redundant masking.
1362         assembly {
1363             extraDataCasted := extraData
1364         }
1365         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1366         _packedOwnerships[index] = packed;
1367     }
1368 
1369     /**
1370      * @dev Returns the next extra data for the packed ownership data.
1371      * The returned result is shifted into position.
1372      */
1373     function _nextExtraData(
1374         address from,
1375         address to,
1376         uint256 prevOwnershipPacked
1377     ) private view returns (uint256) {
1378         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1379         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1380     }
1381 
1382     /**
1383      * @dev Called during each token transfer to set the 24bit `extraData` field.
1384      * Intended to be overridden by the cosumer contract.
1385      *
1386      * `previousExtraData` - the value of `extraData` before transfer.
1387      *
1388      * Calling conditions:
1389      *
1390      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1391      * transferred to `to`.
1392      * - When `from` is zero, `tokenId` will be minted for `to`.
1393      * - When `to` is zero, `tokenId` will be burned by `from`.
1394      * - `from` and `to` are never both zero.
1395      */
1396     function _extraData(
1397         address from,
1398         address to,
1399         uint24 previousExtraData
1400     ) internal view virtual returns (uint24) {}
1401 
1402     /**
1403      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1404      * This includes minting.
1405      * And also called before burning one token.
1406      *
1407      * startTokenId - the first token id to be transferred
1408      * quantity - the amount to be transferred
1409      *
1410      * Calling conditions:
1411      *
1412      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1413      * transferred to `to`.
1414      * - When `from` is zero, `tokenId` will be minted for `to`.
1415      * - When `to` is zero, `tokenId` will be burned by `from`.
1416      * - `from` and `to` are never both zero.
1417      */
1418     function _beforeTokenTransfers(
1419         address from,
1420         address to,
1421         uint256 startTokenId,
1422         uint256 quantity
1423     ) internal virtual {}
1424 
1425     /**
1426      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1427      * This includes minting.
1428      * And also called after one token has been burned.
1429      *
1430      * startTokenId - the first token id to be transferred
1431      * quantity - the amount to be transferred
1432      *
1433      * Calling conditions:
1434      *
1435      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1436      * transferred to `to`.
1437      * - When `from` is zero, `tokenId` has been minted for `to`.
1438      * - When `to` is zero, `tokenId` has been burned by `from`.
1439      * - `from` and `to` are never both zero.
1440      */
1441     function _afterTokenTransfers(
1442         address from,
1443         address to,
1444         uint256 startTokenId,
1445         uint256 quantity
1446     ) internal virtual {}
1447 
1448     /**
1449      * @dev Returns the message sender (defaults to `msg.sender`).
1450      *
1451      * If you are writing GSN compatible contracts, you need to override this function.
1452      */
1453     function _msgSenderERC721A() internal view virtual returns (address) {
1454         return msg.sender;
1455     }
1456 
1457     /**
1458      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1459      */
1460     function _toString(uint256 value) internal pure returns (string memory ptr) {
1461         assembly {
1462             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1463             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1464             // We will need 1 32-byte word to store the length,
1465             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1466             ptr := add(mload(0x40), 128)
1467             // Update the free memory pointer to allocate.
1468             mstore(0x40, ptr)
1469 
1470             // Cache the end of the memory to calculate the length later.
1471             let end := ptr
1472 
1473             // We write the string from the rightmost digit to the leftmost digit.
1474             // The following is essentially a do-while loop that also handles the zero case.
1475             // Costs a bit more than early returning for the zero case,
1476             // but cheaper in terms of deployment and overall runtime costs.
1477             for {
1478                 // Initialize and perform the first pass without check.
1479                 let temp := value
1480                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1481                 ptr := sub(ptr, 1)
1482                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1483                 mstore8(ptr, add(48, mod(temp, 10)))
1484                 temp := div(temp, 10)
1485             } temp {
1486                 // Keep dividing `temp` until zero.
1487                 temp := div(temp, 10)
1488             } {
1489                 // Body of the for loop.
1490                 ptr := sub(ptr, 1)
1491                 mstore8(ptr, add(48, mod(temp, 10)))
1492             }
1493 
1494             let length := sub(end, ptr)
1495             // Move the pointer 32 bytes leftwards to make room for the length.
1496             ptr := sub(ptr, 32)
1497             // Store the length.
1498             mstore(ptr, length)
1499         }
1500     }
1501 }
1502 
1503 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1504 
1505 
1506 // ERC721A Contracts v4.1.0
1507 // Creator: Chiru Labs
1508 
1509 pragma solidity ^0.8.4;
1510 
1511 
1512 /**
1513  * @dev Interface of an ERC721AQueryable compliant contract.
1514  */
1515 interface IERC721AQueryable is IERC721A {
1516     /**
1517      * Invalid query range (`start` >= `stop`).
1518      */
1519     error InvalidQueryRange();
1520 
1521     /**
1522      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1523      *
1524      * If the `tokenId` is out of bounds:
1525      *   - `addr` = `address(0)`
1526      *   - `startTimestamp` = `0`
1527      *   - `burned` = `false`
1528      *
1529      * If the `tokenId` is burned:
1530      *   - `addr` = `<Address of owner before token was burned>`
1531      *   - `startTimestamp` = `<Timestamp when token was burned>`
1532      *   - `burned = `true`
1533      *
1534      * Otherwise:
1535      *   - `addr` = `<Address of owner>`
1536      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1537      *   - `burned = `false`
1538      */
1539     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1540 
1541     /**
1542      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1543      * See {ERC721AQueryable-explicitOwnershipOf}
1544      */
1545     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1546 
1547     /**
1548      * @dev Returns an array of token IDs owned by `owner`,
1549      * in the range [`start`, `stop`)
1550      * (i.e. `start <= tokenId < stop`).
1551      *
1552      * This function allows for tokens to be queried if the collection
1553      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1554      *
1555      * Requirements:
1556      *
1557      * - `start` < `stop`
1558      */
1559     function tokensOfOwnerIn(
1560         address owner,
1561         uint256 start,
1562         uint256 stop
1563     ) external view returns (uint256[] memory);
1564 
1565     /**
1566      * @dev Returns an array of token IDs owned by `owner`.
1567      *
1568      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1569      * It is meant to be called off-chain.
1570      *
1571      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1572      * multiple smaller scans if the collection is large enough to cause
1573      * an out-of-gas error (10K pfp collections should be fine).
1574      */
1575     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1576 }
1577 
1578 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1579 
1580 
1581 // ERC721A Contracts v4.1.0
1582 // Creator: Chiru Labs
1583 
1584 pragma solidity ^0.8.4;
1585 
1586 
1587 
1588 /**
1589  * @title ERC721A Queryable
1590  * @dev ERC721A subclass with convenience query functions.
1591  */
1592 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1593     /**
1594      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1595      *
1596      * If the `tokenId` is out of bounds:
1597      *   - `addr` = `address(0)`
1598      *   - `startTimestamp` = `0`
1599      *   - `burned` = `false`
1600      *   - `extraData` = `0`
1601      *
1602      * If the `tokenId` is burned:
1603      *   - `addr` = `<Address of owner before token was burned>`
1604      *   - `startTimestamp` = `<Timestamp when token was burned>`
1605      *   - `burned = `true`
1606      *   - `extraData` = `<Extra data when token was burned>`
1607      *
1608      * Otherwise:
1609      *   - `addr` = `<Address of owner>`
1610      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1611      *   - `burned = `false`
1612      *   - `extraData` = `<Extra data at start of ownership>`
1613      */
1614     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1615         TokenOwnership memory ownership;
1616         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1617             return ownership;
1618         }
1619         ownership = _ownershipAt(tokenId);
1620         if (ownership.burned) {
1621             return ownership;
1622         }
1623         return _ownershipOf(tokenId);
1624     }
1625 
1626     /**
1627      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1628      * See {ERC721AQueryable-explicitOwnershipOf}
1629      */
1630     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1631         unchecked {
1632             uint256 tokenIdsLength = tokenIds.length;
1633             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1634             for (uint256 i; i != tokenIdsLength; ++i) {
1635                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1636             }
1637             return ownerships;
1638         }
1639     }
1640 
1641     /**
1642      * @dev Returns an array of token IDs owned by `owner`,
1643      * in the range [`start`, `stop`)
1644      * (i.e. `start <= tokenId < stop`).
1645      *
1646      * This function allows for tokens to be queried if the collection
1647      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1648      *
1649      * Requirements:
1650      *
1651      * - `start` < `stop`
1652      */
1653     function tokensOfOwnerIn(
1654         address owner,
1655         uint256 start,
1656         uint256 stop
1657     ) external view override returns (uint256[] memory) {
1658         unchecked {
1659             if (start >= stop) revert InvalidQueryRange();
1660             uint256 tokenIdsIdx;
1661             uint256 stopLimit = _nextTokenId();
1662             // Set `start = max(start, _startTokenId())`.
1663             if (start < _startTokenId()) {
1664                 start = _startTokenId();
1665             }
1666             // Set `stop = min(stop, stopLimit)`.
1667             if (stop > stopLimit) {
1668                 stop = stopLimit;
1669             }
1670             uint256 tokenIdsMaxLength = balanceOf(owner);
1671             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1672             // to cater for cases where `balanceOf(owner)` is too big.
1673             if (start < stop) {
1674                 uint256 rangeLength = stop - start;
1675                 if (rangeLength < tokenIdsMaxLength) {
1676                     tokenIdsMaxLength = rangeLength;
1677                 }
1678             } else {
1679                 tokenIdsMaxLength = 0;
1680             }
1681             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1682             if (tokenIdsMaxLength == 0) {
1683                 return tokenIds;
1684             }
1685             // We need to call `explicitOwnershipOf(start)`,
1686             // because the slot at `start` may not be initialized.
1687             TokenOwnership memory ownership = explicitOwnershipOf(start);
1688             address currOwnershipAddr;
1689             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1690             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1691             if (!ownership.burned) {
1692                 currOwnershipAddr = ownership.addr;
1693             }
1694             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1695                 ownership = _ownershipAt(i);
1696                 if (ownership.burned) {
1697                     continue;
1698                 }
1699                 if (ownership.addr != address(0)) {
1700                     currOwnershipAddr = ownership.addr;
1701                 }
1702                 if (currOwnershipAddr == owner) {
1703                     tokenIds[tokenIdsIdx++] = i;
1704                 }
1705             }
1706             // Downsize the array to fit.
1707             assembly {
1708                 mstore(tokenIds, tokenIdsIdx)
1709             }
1710             return tokenIds;
1711         }
1712     }
1713 
1714     /**
1715      * @dev Returns an array of token IDs owned by `owner`.
1716      *
1717      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1718      * It is meant to be called off-chain.
1719      *
1720      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1721      * multiple smaller scans if the collection is large enough to cause
1722      * an out-of-gas error (10K pfp collections should be fine).
1723      */
1724     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1725         unchecked {
1726             uint256 tokenIdsIdx;
1727             address currOwnershipAddr;
1728             uint256 tokenIdsLength = balanceOf(owner);
1729             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1730             TokenOwnership memory ownership;
1731             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1732                 ownership = _ownershipAt(i);
1733                 if (ownership.burned) {
1734                     continue;
1735                 }
1736                 if (ownership.addr != address(0)) {
1737                     currOwnershipAddr = ownership.addr;
1738                 }
1739                 if (currOwnershipAddr == owner) {
1740                     tokenIds[tokenIdsIdx++] = i;
1741                 }
1742             }
1743             return tokenIds;
1744         }
1745     }
1746 }
1747 
1748 
1749 
1750 pragma solidity >=0.8.9 <0.9.0;
1751 
1752 contract BAYC2 is ERC721AQueryable, Ownable, ReentrancyGuard {
1753     using Strings for uint256;
1754 
1755     uint256 public maxSupply = 10000;
1756 	uint256 public Ownermint = 10;
1757     uint256 public maxPerAddress = 100;
1758 	uint256 public maxPerTX = 10;
1759     uint256 public cost = 0 ether;
1760 	mapping(address => bool) public freeMinted; 
1761 
1762     bool public paused = true;
1763 
1764 	string public uriPrefix = '';
1765     string public uriSuffix = '';
1766 	
1767   constructor(string memory baseURI) ERC721A("BAYC 2", "BAYC2") {
1768       setUriPrefix(baseURI); 
1769       _safeMint(_msgSender(), Ownermint);
1770 
1771   }
1772 
1773   modifier callerIsUser() {
1774         require(tx.origin == msg.sender, "The caller is another contract");
1775         _;
1776   }
1777 
1778   function numberMinted(address owner) public view returns (uint256) {
1779         return _numberMinted(owner);
1780   }
1781 
1782   function mint(uint256 _mintAmount) public payable nonReentrant callerIsUser{
1783         require(!paused, 'The contract is paused!');
1784         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1785         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1786         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1787 	if (freeMinted[_msgSender()]){
1788         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1789   }
1790     else{
1791 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1792         freeMinted[_msgSender()] = true;
1793   }
1794 
1795     _safeMint(_msgSender(), _mintAmount);
1796   }
1797 
1798   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1799     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1800     string memory currentBaseURI = _baseURI();
1801     return bytes(currentBaseURI).length > 0
1802         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1803         : '';
1804   }
1805 
1806   function setPaused() public onlyOwner {
1807     paused = !paused;
1808   }
1809 
1810   function setCost(uint256 _cost) public onlyOwner {
1811     cost = _cost;
1812   }
1813 
1814   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1815     maxPerTX = _maxPerTX;
1816   }
1817 
1818   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1819     uriPrefix = _uriPrefix;
1820   }
1821  
1822   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1823     uriSuffix = _uriSuffix;
1824   }
1825 
1826   function withdraw() external onlyOwner {
1827         payable(msg.sender).transfer(address(this).balance);
1828   }
1829 
1830   function _startTokenId() internal view virtual override returns (uint256) {
1831     return 0;
1832   }
1833 
1834   function _baseURI() internal view virtual override returns (string memory) {
1835     return uriPrefix;
1836   }
1837 }