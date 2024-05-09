1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4   /$$$$$$                                /$$                 /$$          
5  /$$__  $$                              | $$                | $$          
6 | $$  \ $$ /$$$$$$$$ /$$   /$$  /$$$$$$ | $$$$$$$   /$$$$$$ | $$  /$$$$$$ 
7 | $$$$$$$$|____ /$$/| $$  | $$ /$$__  $$| $$__  $$ |____  $$| $$ |____  $$
8 | $$__  $$   /$$$$/ | $$  | $$| $$  \__/| $$  \ $$  /$$$$$$$| $$  /$$$$$$$
9 | $$  | $$  /$$__/  | $$  | $$| $$      | $$  | $$ /$$__  $$| $$ /$$__  $$
10 | $$  | $$ /$$$$$$$$|  $$$$$$/| $$      | $$$$$$$/|  $$$$$$$| $$|  $$$$$$$
11 |__/  |__/|________/ \______/ |__/      |_______/  \_______/|__/ \_______/
12                                                                           
13                                                                           
14                                                                           
15  /$$                   /$$                                 /$$            
16 | $$                  | $$                                | $$            
17 | $$$$$$$  /$$   /$$ /$$$$$$         /$$$$$$$   /$$$$$$  /$$$$$$          
18 | $$__  $$| $$  | $$|_  $$_/        | $$__  $$ /$$__  $$|_  $$_/          
19 | $$  \ $$| $$  | $$  | $$          | $$  \ $$| $$  \ $$  | $$            
20 | $$  | $$| $$  | $$  | $$ /$$      | $$  | $$| $$  | $$  | $$ /$$        
21 | $$$$$$$/|  $$$$$$/  |  $$$$/      | $$  | $$|  $$$$$$/  |  $$$$/        
22 |_______/  \______/    \___/        |__/  |__/ \______/    \___/          
23                                                                           
24                                                                           
25                                                                           
26            /$$       /$$   /$$     /$$                                    
27           | $$      |__/  | $$    | $$                                    
28   /$$$$$$$| $$$$$$$  /$$ /$$$$$$ /$$$$$$   /$$   /$$                      
29  /$$_____/| $$__  $$| $$|_  $$_/|_  $$_/  | $$  | $$                      
30 |  $$$$$$ | $$  \ $$| $$  | $$    | $$    | $$  | $$                      
31  \____  $$| $$  | $$| $$  | $$ /$$| $$ /$$| $$  | $$                      
32  /$$$$$$$/| $$  | $$| $$  |  $$$$/|  $$$$/|  $$$$$$$                      
33 |_______/ |__/  |__/|__/   \___/   \___/   \____  $$                      
34                                            /$$  | $$                      
35                                           |  $$$$$$/                      
36                                            \______/                                                                                                                                                                                                                                    
37 */
38 
39 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Contract module that helps prevent reentrant calls to a function.
45  *
46  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
47  * available, which can be applied to functions to make sure there are no nested
48  * (reentrant) calls to them.
49  *
50  * Note that because there is a single `nonReentrant` guard, functions marked as
51  * `nonReentrant` may not call one another. This can be worked around by making
52  * those functions `private`, and then adding `external` `nonReentrant` entry
53  * points to them.
54  *
55  * TIP: If you would like to learn more about reentrancy and alternative ways
56  * to protect against it, check out our blog post
57  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
58  */
59 abstract contract ReentrancyGuard {
60     // Booleans are more expensive than uint256 or any type that takes up a full
61     // word because each write operation emits an extra SLOAD to first read the
62     // slot's contents, replace the bits taken up by the boolean, and then write
63     // back. This is the compiler's defense against contract upgrades and
64     // pointer aliasing, and it cannot be disabled.
65 
66     // The values being non-zero value makes deployment a bit more expensive,
67     // but in exchange the refund on every call to nonReentrant will be lower in
68     // amount. Since refunds are capped to a percentage of the total
69     // transaction's gas, it is best to keep them low in cases like this one, to
70     // increase the likelihood of the full refund coming into effect.
71     uint256 private constant _NOT_ENTERED = 1;
72     uint256 private constant _ENTERED = 2;
73 
74     uint256 private _status;
75 
76     constructor() {
77         _status = _NOT_ENTERED;
78     }
79 
80     /**
81      * @dev Prevents a contract from calling itself, directly or indirectly.
82      * Calling a `nonReentrant` function from another `nonReentrant`
83      * function is not supported. It is possible to prevent this from happening
84      * by making the `nonReentrant` function external, and making it call a
85      * `private` function that does the actual work.
86      */
87     modifier nonReentrant() {
88         // On the first call to nonReentrant, _notEntered will be true
89         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
90 
91         // Any calls to nonReentrant after this point will fail
92         _status = _ENTERED;
93 
94         _;
95 
96         // By storing the original value once again, a refund is triggered (see
97         // https://eips.ethereum.org/EIPS/eip-2200)
98         _status = _NOT_ENTERED;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Strings.sol
103 
104 
105 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev String operations.
111  */
112 library Strings {
113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
114     uint8 private constant _ADDRESS_LENGTH = 20;
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
118      */
119     function toString(uint256 value) internal pure returns (string memory) {
120         // Inspired by OraclizeAPI's implementation - MIT licence
121         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
122 
123         if (value == 0) {
124             return "0";
125         }
126         uint256 temp = value;
127         uint256 digits;
128         while (temp != 0) {
129             digits++;
130             temp /= 10;
131         }
132         bytes memory buffer = new bytes(digits);
133         while (value != 0) {
134             digits -= 1;
135             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
136             value /= 10;
137         }
138         return string(buffer);
139     }
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
143      */
144     function toHexString(uint256 value) internal pure returns (string memory) {
145         if (value == 0) {
146             return "0x00";
147         }
148         uint256 temp = value;
149         uint256 length = 0;
150         while (temp != 0) {
151             length++;
152             temp >>= 8;
153         }
154         return toHexString(value, length);
155     }
156 
157     /**
158      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
159      */
160     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
161         bytes memory buffer = new bytes(2 * length + 2);
162         buffer[0] = "0";
163         buffer[1] = "x";
164         for (uint256 i = 2 * length + 1; i > 1; --i) {
165             buffer[i] = _HEX_SYMBOLS[value & 0xf];
166             value >>= 4;
167         }
168         require(value == 0, "Strings: hex length insufficient");
169         return string(buffer);
170     }
171 
172     /**
173      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
174      */
175     function toHexString(address addr) internal pure returns (string memory) {
176         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
177     }
178 }
179 
180 
181 // File: @openzeppelin/contracts/utils/Context.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Provides information about the current execution context, including the
190  * sender of the transaction and its data. While these are generally available
191  * via msg.sender and msg.data, they should not be accessed in such a direct
192  * manner, since when dealing with meta-transactions the account sending and
193  * paying for execution may not be the actual sender (as far as an application
194  * is concerned).
195  *
196  * This contract is only required for intermediate, library-like contracts.
197  */
198 abstract contract Context {
199     function _msgSender() internal view virtual returns (address) {
200         return msg.sender;
201     }
202 
203     function _msgData() internal view virtual returns (bytes calldata) {
204         return msg.data;
205     }
206 }
207 
208 // File: @openzeppelin/contracts/access/Ownable.sol
209 
210 
211 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 
216 /**
217  * @dev Contract module which provides a basic access control mechanism, where
218  * there is an account (an owner) that can be granted exclusive access to
219  * specific functions.
220  *
221  * By default, the owner account will be the one that deploys the contract. This
222  * can later be changed with {transferOwnership}.
223  *
224  * This module is used through inheritance. It will make available the modifier
225  * `onlyOwner`, which can be applied to your functions to restrict their use to
226  * the owner.
227  */
228 abstract contract Ownable is Context {
229     address private _owner;
230 
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233     /**
234      * @dev Initializes the contract setting the deployer as the initial owner.
235      */
236     constructor() {
237         _transferOwnership(_msgSender());
238     }
239 
240     /**
241      * @dev Throws if called by any account other than the owner.
242      */
243     modifier onlyOwner() {
244         _checkOwner();
245         _;
246     }
247 
248     /**
249      * @dev Returns the address of the current owner.
250      */
251     function owner() public view virtual returns (address) {
252         return _owner;
253     }
254 
255     /**
256      * @dev Throws if the sender is not the owner.
257      */
258     function _checkOwner() internal view virtual {
259         require(owner() == _msgSender(), "Ownable: caller is not the owner");
260     }
261 
262     /**
263      * @dev Leaves the contract without owner. It will not be possible to call
264      * `onlyOwner` functions anymore. Can only be called by the current owner.
265      *
266      * NOTE: Renouncing ownership will leave the contract without an owner,
267      * thereby removing any functionality that is only available to the owner.
268      */
269     function renounceOwnership() public virtual onlyOwner {
270         _transferOwnership(address(0));
271     }
272 
273     /**
274      * @dev Transfers ownership of the contract to a new account (`newOwner`).
275      * Can only be called by the current owner.
276      */
277     function transferOwnership(address newOwner) public virtual onlyOwner {
278         require(newOwner != address(0), "Ownable: new owner is the zero address");
279         _transferOwnership(newOwner);
280     }
281 
282     /**
283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
284      * Internal function without access restriction.
285      */
286     function _transferOwnership(address newOwner) internal virtual {
287         address oldOwner = _owner;
288         _owner = newOwner;
289         emit OwnershipTransferred(oldOwner, newOwner);
290     }
291 }
292 
293 // File: erc721a/contracts/IERC721A.sol
294 
295 
296 // ERC721A Contracts v4.1.0
297 // Creator: Chiru Labs
298 
299 pragma solidity ^0.8.4;
300 
301 /**
302  * @dev Interface of an ERC721A compliant contract.
303  */
304 interface IERC721A {
305     /**
306      * The caller must own the token or be an approved operator.
307      */
308     error ApprovalCallerNotOwnerNorApproved();
309 
310     /**
311      * The token does not exist.
312      */
313     error ApprovalQueryForNonexistentToken();
314 
315     /**
316      * The caller cannot approve to their own address.
317      */
318     error ApproveToCaller();
319 
320     /**
321      * Cannot query the balance for the zero address.
322      */
323     error BalanceQueryForZeroAddress();
324 
325     /**
326      * Cannot mint to the zero address.
327      */
328     error MintToZeroAddress();
329 
330     /**
331      * The quantity of tokens minted must be more than zero.
332      */
333     error MintZeroQuantity();
334 
335     /**
336      * The token does not exist.
337      */
338     error OwnerQueryForNonexistentToken();
339 
340     /**
341      * The caller must own the token or be an approved operator.
342      */
343     error TransferCallerNotOwnerNorApproved();
344 
345     /**
346      * The token must be owned by `from`.
347      */
348     error TransferFromIncorrectOwner();
349 
350     /**
351      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
352      */
353     error TransferToNonERC721ReceiverImplementer();
354 
355     /**
356      * Cannot transfer to the zero address.
357      */
358     error TransferToZeroAddress();
359 
360     /**
361      * The token does not exist.
362      */
363     error URIQueryForNonexistentToken();
364 
365     /**
366      * The `quantity` minted with ERC2309 exceeds the safety limit.
367      */
368     error MintERC2309QuantityExceedsLimit();
369 
370     /**
371      * The `extraData` cannot be set on an unintialized ownership slot.
372      */
373     error OwnershipNotInitializedForExtraData();
374 
375     struct TokenOwnership {
376         // The address of the owner.
377         address addr;
378         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
379         uint64 startTimestamp;
380         // Whether the token has been burned.
381         bool burned;
382         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
383         uint24 extraData;
384     }
385 
386     /**
387      * @dev Returns the total amount of tokens stored by the contract.
388      *
389      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
390      */
391     function totalSupply() external view returns (uint256);
392 
393     // ==============================
394     //            IERC165
395     // ==============================
396 
397     /**
398      * @dev Returns true if this contract implements the interface defined by
399      * `interfaceId`. See the corresponding
400      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
401      * to learn more about how these ids are created.
402      *
403      * This function call must use less than 30 000 gas.
404      */
405     function supportsInterface(bytes4 interfaceId) external view returns (bool);
406 
407     // ==============================
408     //            IERC721
409     // ==============================
410 
411     /**
412      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
413      */
414     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
415 
416     /**
417      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
418      */
419     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
420 
421     /**
422      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
423      */
424     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
425 
426     /**
427      * @dev Returns the number of tokens in ``owner``'s account.
428      */
429     function balanceOf(address owner) external view returns (uint256 balance);
430 
431     /**
432      * @dev Returns the owner of the `tokenId` token.
433      *
434      * Requirements:
435      *
436      * - `tokenId` must exist.
437      */
438     function ownerOf(uint256 tokenId) external view returns (address owner);
439 
440     /**
441      * @dev Safely transfers `tokenId` token from `from` to `to`.
442      *
443      * Requirements:
444      *
445      * - `from` cannot be the zero address.
446      * - `to` cannot be the zero address.
447      * - `tokenId` token must exist and be owned by `from`.
448      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
449      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
450      *
451      * Emits a {Transfer} event.
452      */
453     function safeTransferFrom(
454         address from,
455         address to,
456         uint256 tokenId,
457         bytes calldata data
458     ) external;
459 
460     /**
461      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
462      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
463      *
464      * Requirements:
465      *
466      * - `from` cannot be the zero address.
467      * - `to` cannot be the zero address.
468      * - `tokenId` token must exist and be owned by `from`.
469      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
470      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
471      *
472      * Emits a {Transfer} event.
473      */
474     function safeTransferFrom(
475         address from,
476         address to,
477         uint256 tokenId
478     ) external;
479 
480     /**
481      * @dev Transfers `tokenId` token from `from` to `to`.
482      *
483      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
484      *
485      * Requirements:
486      *
487      * - `from` cannot be the zero address.
488      * - `to` cannot be the zero address.
489      * - `tokenId` token must be owned by `from`.
490      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
491      *
492      * Emits a {Transfer} event.
493      */
494     function transferFrom(
495         address from,
496         address to,
497         uint256 tokenId
498     ) external;
499 
500     /**
501      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
502      * The approval is cleared when the token is transferred.
503      *
504      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
505      *
506      * Requirements:
507      *
508      * - The caller must own the token or be an approved operator.
509      * - `tokenId` must exist.
510      *
511      * Emits an {Approval} event.
512      */
513     function approve(address to, uint256 tokenId) external;
514 
515     /**
516      * @dev Approve or remove `operator` as an operator for the caller.
517      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
518      *
519      * Requirements:
520      *
521      * - The `operator` cannot be the caller.
522      *
523      * Emits an {ApprovalForAll} event.
524      */
525     function setApprovalForAll(address operator, bool _approved) external;
526 
527     /**
528      * @dev Returns the account approved for `tokenId` token.
529      *
530      * Requirements:
531      *
532      * - `tokenId` must exist.
533      */
534     function getApproved(uint256 tokenId) external view returns (address operator);
535 
536     /**
537      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
538      *
539      * See {setApprovalForAll}
540      */
541     function isApprovedForAll(address owner, address operator) external view returns (bool);
542 
543     // ==============================
544     //        IERC721Metadata
545     // ==============================
546 
547     /**
548      * @dev Returns the token collection name.
549      */
550     function name() external view returns (string memory);
551 
552     /**
553      * @dev Returns the token collection symbol.
554      */
555     function symbol() external view returns (string memory);
556 
557     /**
558      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
559      */
560     function tokenURI(uint256 tokenId) external view returns (string memory);
561 
562     // ==============================
563     //            IERC2309
564     // ==============================
565 
566     /**
567      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
568      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
569      */
570     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
571 }
572 
573 // File: erc721a/contracts/ERC721A.sol
574 
575 
576 // ERC721A Contracts v4.1.0
577 // Creator: Chiru Labs
578 
579 pragma solidity ^0.8.4;
580 
581 
582 /**
583  * @dev ERC721 token receiver interface.
584  */
585 interface ERC721A__IERC721Receiver {
586     function onERC721Received(
587         address operator,
588         address from,
589         uint256 tokenId,
590         bytes calldata data
591     ) external returns (bytes4);
592 }
593 
594 /**
595  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
596  * including the Metadata extension. Built to optimize for lower gas during batch mints.
597  *
598  * Assumes serials are sequentially minted starting at `_startTokenId()`
599  * (defaults to 0, e.g. 0, 1, 2, 3..).
600  *
601  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
602  *
603  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
604  */
605 contract ERC721A is IERC721A {
606     // Mask of an entry in packed address data.
607     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
608 
609     // The bit position of `numberMinted` in packed address data.
610     uint256 private constant BITPOS_NUMBER_MINTED = 64;
611 
612     // The bit position of `numberBurned` in packed address data.
613     uint256 private constant BITPOS_NUMBER_BURNED = 128;
614 
615     // The bit position of `aux` in packed address data.
616     uint256 private constant BITPOS_AUX = 192;
617 
618     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
619     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
620 
621     // The bit position of `startTimestamp` in packed ownership.
622     uint256 private constant BITPOS_START_TIMESTAMP = 160;
623 
624     // The bit mask of the `burned` bit in packed ownership.
625     uint256 private constant BITMASK_BURNED = 1 << 224;
626 
627     // The bit position of the `nextInitialized` bit in packed ownership.
628     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
629 
630     // The bit mask of the `nextInitialized` bit in packed ownership.
631     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
632 
633     // The bit position of `extraData` in packed ownership.
634     uint256 private constant BITPOS_EXTRA_DATA = 232;
635 
636     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
637     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
638 
639     // The mask of the lower 160 bits for addresses.
640     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
641 
642     // The maximum `quantity` that can be minted with `_mintERC2309`.
643     // This limit is to prevent overflows on the address data entries.
644     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
645     // is required to cause an overflow, which is unrealistic.
646     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
647 
648     // The tokenId of the next token to be minted.
649     uint256 private _currentIndex;
650 
651     // The number of tokens burned.
652     uint256 private _burnCounter;
653 
654     // Token name
655     string private _name;
656 
657     // Token symbol
658     string private _symbol;
659 
660     // Mapping from token ID to ownership details
661     // An empty struct value does not necessarily mean the token is unowned.
662     // See `_packedOwnershipOf` implementation for details.
663     //
664     // Bits Layout:
665     // - [0..159]   `addr`
666     // - [160..223] `startTimestamp`
667     // - [224]      `burned`
668     // - [225]      `nextInitialized`
669     // - [232..255] `extraData`
670     mapping(uint256 => uint256) private _packedOwnerships;
671 
672     // Mapping owner address to address data.
673     //
674     // Bits Layout:
675     // - [0..63]    `balance`
676     // - [64..127]  `numberMinted`
677     // - [128..191] `numberBurned`
678     // - [192..255] `aux`
679     mapping(address => uint256) private _packedAddressData;
680 
681     // Mapping from token ID to approved address.
682     mapping(uint256 => address) private _tokenApprovals;
683 
684     // Mapping from owner to operator approvals
685     mapping(address => mapping(address => bool)) private _operatorApprovals;
686 
687     constructor(string memory name_, string memory symbol_) {
688         _name = name_;
689         _symbol = symbol_;
690         _currentIndex = _startTokenId();
691     }
692 
693     /**
694      * @dev Returns the starting token ID.
695      * To change the starting token ID, please override this function.
696      */
697     function _startTokenId() internal view virtual returns (uint256) {
698         return 0;
699     }
700 
701     /**
702      * @dev Returns the next token ID to be minted.
703      */
704     function _nextTokenId() internal view returns (uint256) {
705         return _currentIndex;
706     }
707 
708     /**
709      * @dev Returns the total number of tokens in existence.
710      * Burned tokens will reduce the count.
711      * To get the total number of tokens minted, please see `_totalMinted`.
712      */
713     function totalSupply() public view override returns (uint256) {
714         // Counter underflow is impossible as _burnCounter cannot be incremented
715         // more than `_currentIndex - _startTokenId()` times.
716         unchecked {
717             return _currentIndex - _burnCounter - _startTokenId();
718         }
719     }
720 
721     /**
722      * @dev Returns the total amount of tokens minted in the contract.
723      */
724     function _totalMinted() internal view returns (uint256) {
725         // Counter underflow is impossible as _currentIndex does not decrement,
726         // and it is initialized to `_startTokenId()`
727         unchecked {
728             return _currentIndex - _startTokenId();
729         }
730     }
731 
732     /**
733      * @dev Returns the total number of tokens burned.
734      */
735     function _totalBurned() internal view returns (uint256) {
736         return _burnCounter;
737     }
738 
739     /**
740      * @dev See {IERC165-supportsInterface}.
741      */
742     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
743         // The interface IDs are constants representing the first 4 bytes of the XOR of
744         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
745         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
746         return
747             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
748             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
749             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
750     }
751 
752     /**
753      * @dev See {IERC721-balanceOf}.
754      */
755     function balanceOf(address owner) public view override returns (uint256) {
756         if (owner == address(0)) revert BalanceQueryForZeroAddress();
757         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
758     }
759 
760     /**
761      * Returns the number of tokens minted by `owner`.
762      */
763     function _numberMinted(address owner) internal view returns (uint256) {
764         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
765     }
766 
767     /**
768      * Returns the number of tokens burned by or on behalf of `owner`.
769      */
770     function _numberBurned(address owner) internal view returns (uint256) {
771         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
772     }
773 
774     /**
775      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
776      */
777     function _getAux(address owner) internal view returns (uint64) {
778         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
779     }
780 
781     /**
782      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
783      * If there are multiple variables, please pack them into a uint64.
784      */
785     function _setAux(address owner, uint64 aux) internal {
786         uint256 packed = _packedAddressData[owner];
787         uint256 auxCasted;
788         // Cast `aux` with assembly to avoid redundant masking.
789         assembly {
790             auxCasted := aux
791         }
792         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
793         _packedAddressData[owner] = packed;
794     }
795 
796     /**
797      * Returns the packed ownership data of `tokenId`.
798      */
799     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
800         uint256 curr = tokenId;
801 
802         unchecked {
803             if (_startTokenId() <= curr)
804                 if (curr < _currentIndex) {
805                     uint256 packed = _packedOwnerships[curr];
806                     // If not burned.
807                     if (packed & BITMASK_BURNED == 0) {
808                         // Invariant:
809                         // There will always be an ownership that has an address and is not burned
810                         // before an ownership that does not have an address and is not burned.
811                         // Hence, curr will not underflow.
812                         //
813                         // We can directly compare the packed value.
814                         // If the address is zero, packed is zero.
815                         while (packed == 0) {
816                             packed = _packedOwnerships[--curr];
817                         }
818                         return packed;
819                     }
820                 }
821         }
822         revert OwnerQueryForNonexistentToken();
823     }
824 
825     /**
826      * Returns the unpacked `TokenOwnership` struct from `packed`.
827      */
828     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
829         ownership.addr = address(uint160(packed));
830         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
831         ownership.burned = packed & BITMASK_BURNED != 0;
832         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
833     }
834 
835     /**
836      * Returns the unpacked `TokenOwnership` struct at `index`.
837      */
838     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
839         return _unpackedOwnership(_packedOwnerships[index]);
840     }
841 
842     /**
843      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
844      */
845     function _initializeOwnershipAt(uint256 index) internal {
846         if (_packedOwnerships[index] == 0) {
847             _packedOwnerships[index] = _packedOwnershipOf(index);
848         }
849     }
850 
851     /**
852      * Gas spent here starts off proportional to the maximum mint batch size.
853      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
854      */
855     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
856         return _unpackedOwnership(_packedOwnershipOf(tokenId));
857     }
858 
859     /**
860      * @dev Packs ownership data into a single uint256.
861      */
862     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
863         assembly {
864             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
865             owner := and(owner, BITMASK_ADDRESS)
866             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
867             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
868         }
869     }
870 
871     /**
872      * @dev See {IERC721-ownerOf}.
873      */
874     function ownerOf(uint256 tokenId) public view override returns (address) {
875         return address(uint160(_packedOwnershipOf(tokenId)));
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-name}.
880      */
881     function name() public view virtual override returns (string memory) {
882         return _name;
883     }
884 
885     /**
886      * @dev See {IERC721Metadata-symbol}.
887      */
888     function symbol() public view virtual override returns (string memory) {
889         return _symbol;
890     }
891 
892     /**
893      * @dev See {IERC721Metadata-tokenURI}.
894      */
895     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
896         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
897 
898         string memory baseURI = _baseURI();
899         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
900     }
901 
902     /**
903      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
904      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
905      * by default, it can be overridden in child contracts.
906      */
907     function _baseURI() internal view virtual returns (string memory) {
908         return '';
909     }
910 
911     /**
912      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
913      */
914     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
915         // For branchless setting of the `nextInitialized` flag.
916         assembly {
917             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
918             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
919         }
920     }
921 
922     /**
923      * @dev See {IERC721-approve}.
924      */
925     function approve(address to, uint256 tokenId) public override {
926         address owner = ownerOf(tokenId);
927 
928         if (_msgSenderERC721A() != owner)
929             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
930                 revert ApprovalCallerNotOwnerNorApproved();
931             }
932 
933         _tokenApprovals[tokenId] = to;
934         emit Approval(owner, to, tokenId);
935     }
936 
937     /**
938      * @dev See {IERC721-getApproved}.
939      */
940     function getApproved(uint256 tokenId) public view override returns (address) {
941         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
942 
943         return _tokenApprovals[tokenId];
944     }
945 
946     /**
947      * @dev See {IERC721-setApprovalForAll}.
948      */
949     function setApprovalForAll(address operator, bool approved) public virtual override {
950         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
951 
952         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
953         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
954     }
955 
956     /**
957      * @dev See {IERC721-isApprovedForAll}.
958      */
959     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
960         return _operatorApprovals[owner][operator];
961     }
962 
963     /**
964      * @dev See {IERC721-safeTransferFrom}.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         safeTransferFrom(from, to, tokenId, '');
972     }
973 
974     /**
975      * @dev See {IERC721-safeTransferFrom}.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) public virtual override {
983         transferFrom(from, to, tokenId);
984         if (to.code.length != 0)
985             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
986                 revert TransferToNonERC721ReceiverImplementer();
987             }
988     }
989 
990     /**
991      * @dev Returns whether `tokenId` exists.
992      *
993      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
994      *
995      * Tokens start existing when they are minted (`_mint`),
996      */
997     function _exists(uint256 tokenId) internal view returns (bool) {
998         return
999             _startTokenId() <= tokenId &&
1000             tokenId < _currentIndex && // If within bounds,
1001             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1002     }
1003 
1004     /**
1005      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1006      */
1007     function _safeMint(address to, uint256 quantity) internal {
1008         _safeMint(to, quantity, '');
1009     }
1010 
1011     /**
1012      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - If `to` refers to a smart contract, it must implement
1017      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1018      * - `quantity` must be greater than 0.
1019      *
1020      * See {_mint}.
1021      *
1022      * Emits a {Transfer} event for each mint.
1023      */
1024     function _safeMint(
1025         address to,
1026         uint256 quantity,
1027         bytes memory _data
1028     ) internal {
1029         _mint(to, quantity);
1030 
1031         unchecked {
1032             if (to.code.length != 0) {
1033                 uint256 end = _currentIndex;
1034                 uint256 index = end - quantity;
1035                 do {
1036                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1037                         revert TransferToNonERC721ReceiverImplementer();
1038                     }
1039                 } while (index < end);
1040                 // Reentrancy protection.
1041                 if (_currentIndex != end) revert();
1042             }
1043         }
1044     }
1045 
1046     /**
1047      * @dev Mints `quantity` tokens and transfers them to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - `to` cannot be the zero address.
1052      * - `quantity` must be greater than 0.
1053      *
1054      * Emits a {Transfer} event for each mint.
1055      */
1056     function _mint(address to, uint256 quantity) internal {
1057         uint256 startTokenId = _currentIndex;
1058         if (to == address(0)) revert MintToZeroAddress();
1059         if (quantity == 0) revert MintZeroQuantity();
1060 
1061         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1062 
1063         // Overflows are incredibly unrealistic.
1064         // `balance` and `numberMinted` have a maximum limit of 2**64.
1065         // `tokenId` has a maximum limit of 2**256.
1066         unchecked {
1067             // Updates:
1068             // - `balance += quantity`.
1069             // - `numberMinted += quantity`.
1070             //
1071             // We can directly add to the `balance` and `numberMinted`.
1072             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1073 
1074             // Updates:
1075             // - `address` to the owner.
1076             // - `startTimestamp` to the timestamp of minting.
1077             // - `burned` to `false`.
1078             // - `nextInitialized` to `quantity == 1`.
1079             _packedOwnerships[startTokenId] = _packOwnershipData(
1080                 to,
1081                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1082             );
1083 
1084             uint256 tokenId = startTokenId;
1085             uint256 end = startTokenId + quantity;
1086             do {
1087                 emit Transfer(address(0), to, tokenId++);
1088             } while (tokenId < end);
1089 
1090             _currentIndex = end;
1091         }
1092         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1093     }
1094 
1095     /**
1096      * @dev Mints `quantity` tokens and transfers them to `to`.
1097      *
1098      * This function is intended for efficient minting only during contract creation.
1099      *
1100      * It emits only one {ConsecutiveTransfer} as defined in
1101      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1102      * instead of a sequence of {Transfer} event(s).
1103      *
1104      * Calling this function outside of contract creation WILL make your contract
1105      * non-compliant with the ERC721 standard.
1106      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1107      * {ConsecutiveTransfer} event is only permissible during contract creation.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `quantity` must be greater than 0.
1113      *
1114      * Emits a {ConsecutiveTransfer} event.
1115      */
1116     function _mintERC2309(address to, uint256 quantity) internal {
1117         uint256 startTokenId = _currentIndex;
1118         if (to == address(0)) revert MintToZeroAddress();
1119         if (quantity == 0) revert MintZeroQuantity();
1120         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1121 
1122         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1123 
1124         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1125         unchecked {
1126             // Updates:
1127             // - `balance += quantity`.
1128             // - `numberMinted += quantity`.
1129             //
1130             // We can directly add to the `balance` and `numberMinted`.
1131             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1132 
1133             // Updates:
1134             // - `address` to the owner.
1135             // - `startTimestamp` to the timestamp of minting.
1136             // - `burned` to `false`.
1137             // - `nextInitialized` to `quantity == 1`.
1138             _packedOwnerships[startTokenId] = _packOwnershipData(
1139                 to,
1140                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1141             );
1142 
1143             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1144 
1145             _currentIndex = startTokenId + quantity;
1146         }
1147         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1148     }
1149 
1150     /**
1151      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1152      */
1153     function _getApprovedAddress(uint256 tokenId)
1154         private
1155         view
1156         returns (uint256 approvedAddressSlot, address approvedAddress)
1157     {
1158         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1159         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1160         assembly {
1161             // Compute the slot.
1162             mstore(0x00, tokenId)
1163             mstore(0x20, tokenApprovalsPtr.slot)
1164             approvedAddressSlot := keccak256(0x00, 0x40)
1165             // Load the slot's value from storage.
1166             approvedAddress := sload(approvedAddressSlot)
1167         }
1168     }
1169 
1170     /**
1171      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1172      */
1173     function _isOwnerOrApproved(
1174         address approvedAddress,
1175         address from,
1176         address msgSender
1177     ) private pure returns (bool result) {
1178         assembly {
1179             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1180             from := and(from, BITMASK_ADDRESS)
1181             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1182             msgSender := and(msgSender, BITMASK_ADDRESS)
1183             // `msgSender == from || msgSender == approvedAddress`.
1184             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1185         }
1186     }
1187 
1188     /**
1189      * @dev Transfers `tokenId` from `from` to `to`.
1190      *
1191      * Requirements:
1192      *
1193      * - `to` cannot be the zero address.
1194      * - `tokenId` token must be owned by `from`.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function transferFrom(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) public virtual override {
1203         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1204 
1205         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1206 
1207         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1208 
1209         // The nested ifs save around 20+ gas over a compound boolean condition.
1210         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1211             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1212 
1213         if (to == address(0)) revert TransferToZeroAddress();
1214 
1215         _beforeTokenTransfers(from, to, tokenId, 1);
1216 
1217         // Clear approvals from the previous owner.
1218         assembly {
1219             if approvedAddress {
1220                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1221                 sstore(approvedAddressSlot, 0)
1222             }
1223         }
1224 
1225         // Underflow of the sender's balance is impossible because we check for
1226         // ownership above and the recipient's balance can't realistically overflow.
1227         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1228         unchecked {
1229             // We can directly increment and decrement the balances.
1230             --_packedAddressData[from]; // Updates: `balance -= 1`.
1231             ++_packedAddressData[to]; // Updates: `balance += 1`.
1232 
1233             // Updates:
1234             // - `address` to the next owner.
1235             // - `startTimestamp` to the timestamp of transfering.
1236             // - `burned` to `false`.
1237             // - `nextInitialized` to `true`.
1238             _packedOwnerships[tokenId] = _packOwnershipData(
1239                 to,
1240                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1241             );
1242 
1243             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1244             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1245                 uint256 nextTokenId = tokenId + 1;
1246                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1247                 if (_packedOwnerships[nextTokenId] == 0) {
1248                     // If the next slot is within bounds.
1249                     if (nextTokenId != _currentIndex) {
1250                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1251                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1252                     }
1253                 }
1254             }
1255         }
1256 
1257         emit Transfer(from, to, tokenId);
1258         _afterTokenTransfers(from, to, tokenId, 1);
1259     }
1260 
1261     /**
1262      * @dev Equivalent to `_burn(tokenId, false)`.
1263      */
1264     function _burn(uint256 tokenId) internal virtual {
1265         _burn(tokenId, false);
1266     }
1267 
1268     /**
1269      * @dev Destroys `tokenId`.
1270      * The approval is cleared when the token is burned.
1271      *
1272      * Requirements:
1273      *
1274      * - `tokenId` must exist.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1279         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1280 
1281         address from = address(uint160(prevOwnershipPacked));
1282 
1283         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1284 
1285         if (approvalCheck) {
1286             // The nested ifs save around 20+ gas over a compound boolean condition.
1287             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1288                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1289         }
1290 
1291         _beforeTokenTransfers(from, address(0), tokenId, 1);
1292 
1293         // Clear approvals from the previous owner.
1294         assembly {
1295             if approvedAddress {
1296                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1297                 sstore(approvedAddressSlot, 0)
1298             }
1299         }
1300 
1301         // Underflow of the sender's balance is impossible because we check for
1302         // ownership above and the recipient's balance can't realistically overflow.
1303         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1304         unchecked {
1305             // Updates:
1306             // - `balance -= 1`.
1307             // - `numberBurned += 1`.
1308             //
1309             // We can directly decrement the balance, and increment the number burned.
1310             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1311             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1312 
1313             // Updates:
1314             // - `address` to the last owner.
1315             // - `startTimestamp` to the timestamp of burning.
1316             // - `burned` to `true`.
1317             // - `nextInitialized` to `true`.
1318             _packedOwnerships[tokenId] = _packOwnershipData(
1319                 from,
1320                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1321             );
1322 
1323             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1324             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1325                 uint256 nextTokenId = tokenId + 1;
1326                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1327                 if (_packedOwnerships[nextTokenId] == 0) {
1328                     // If the next slot is within bounds.
1329                     if (nextTokenId != _currentIndex) {
1330                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1331                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1332                     }
1333                 }
1334             }
1335         }
1336 
1337         emit Transfer(from, address(0), tokenId);
1338         _afterTokenTransfers(from, address(0), tokenId, 1);
1339 
1340         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1341         unchecked {
1342             _burnCounter++;
1343         }
1344     }
1345 
1346     /**
1347      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1348      *
1349      * @param from address representing the previous owner of the given token ID
1350      * @param to target address that will receive the tokens
1351      * @param tokenId uint256 ID of the token to be transferred
1352      * @param _data bytes optional data to send along with the call
1353      * @return bool whether the call correctly returned the expected magic value
1354      */
1355     function _checkContractOnERC721Received(
1356         address from,
1357         address to,
1358         uint256 tokenId,
1359         bytes memory _data
1360     ) private returns (bool) {
1361         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1362             bytes4 retval
1363         ) {
1364             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1365         } catch (bytes memory reason) {
1366             if (reason.length == 0) {
1367                 revert TransferToNonERC721ReceiverImplementer();
1368             } else {
1369                 assembly {
1370                     revert(add(32, reason), mload(reason))
1371                 }
1372             }
1373         }
1374     }
1375 
1376     /**
1377      * @dev Directly sets the extra data for the ownership data `index`.
1378      */
1379     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1380         uint256 packed = _packedOwnerships[index];
1381         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1382         uint256 extraDataCasted;
1383         // Cast `extraData` with assembly to avoid redundant masking.
1384         assembly {
1385             extraDataCasted := extraData
1386         }
1387         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1388         _packedOwnerships[index] = packed;
1389     }
1390 
1391     /**
1392      * @dev Returns the next extra data for the packed ownership data.
1393      * The returned result is shifted into position.
1394      */
1395     function _nextExtraData(
1396         address from,
1397         address to,
1398         uint256 prevOwnershipPacked
1399     ) private view returns (uint256) {
1400         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1401         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1402     }
1403 
1404     /**
1405      * @dev Called during each token transfer to set the 24bit `extraData` field.
1406      * Intended to be overridden by the cosumer contract.
1407      *
1408      * `previousExtraData` - the value of `extraData` before transfer.
1409      *
1410      * Calling conditions:
1411      *
1412      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1413      * transferred to `to`.
1414      * - When `from` is zero, `tokenId` will be minted for `to`.
1415      * - When `to` is zero, `tokenId` will be burned by `from`.
1416      * - `from` and `to` are never both zero.
1417      */
1418     function _extraData(
1419         address from,
1420         address to,
1421         uint24 previousExtraData
1422     ) internal view virtual returns (uint24) {}
1423 
1424     /**
1425      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1426      * This includes minting.
1427      * And also called before burning one token.
1428      *
1429      * startTokenId - the first token id to be transferred
1430      * quantity - the amount to be transferred
1431      *
1432      * Calling conditions:
1433      *
1434      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1435      * transferred to `to`.
1436      * - When `from` is zero, `tokenId` will be minted for `to`.
1437      * - When `to` is zero, `tokenId` will be burned by `from`.
1438      * - `from` and `to` are never both zero.
1439      */
1440     function _beforeTokenTransfers(
1441         address from,
1442         address to,
1443         uint256 startTokenId,
1444         uint256 quantity
1445     ) internal virtual {}
1446 
1447     /**
1448      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1449      * This includes minting.
1450      * And also called after one token has been burned.
1451      *
1452      * startTokenId - the first token id to be transferred
1453      * quantity - the amount to be transferred
1454      *
1455      * Calling conditions:
1456      *
1457      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1458      * transferred to `to`.
1459      * - When `from` is zero, `tokenId` has been minted for `to`.
1460      * - When `to` is zero, `tokenId` has been burned by `from`.
1461      * - `from` and `to` are never both zero.
1462      */
1463     function _afterTokenTransfers(
1464         address from,
1465         address to,
1466         uint256 startTokenId,
1467         uint256 quantity
1468     ) internal virtual {}
1469 
1470     /**
1471      * @dev Returns the message sender (defaults to `msg.sender`).
1472      *
1473      * If you are writing GSN compatible contracts, you need to override this function.
1474      */
1475     function _msgSenderERC721A() internal view virtual returns (address) {
1476         return msg.sender;
1477     }
1478 
1479     /**
1480      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1481      */
1482     function _toString(uint256 value) internal pure returns (string memory ptr) {
1483         assembly {
1484             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1485             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1486             // We will need 1 32-byte word to store the length,
1487             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1488             ptr := add(mload(0x40), 128)
1489             // Update the free memory pointer to allocate.
1490             mstore(0x40, ptr)
1491 
1492             // Cache the end of the memory to calculate the length later.
1493             let end := ptr
1494 
1495             // We write the string from the rightmost digit to the leftmost digit.
1496             // The following is essentially a do-while loop that also handles the zero case.
1497             // Costs a bit more than early returning for the zero case,
1498             // but cheaper in terms of deployment and overall runtime costs.
1499             for {
1500                 // Initialize and perform the first pass without check.
1501                 let temp := value
1502                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1503                 ptr := sub(ptr, 1)
1504                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1505                 mstore8(ptr, add(48, mod(temp, 10)))
1506                 temp := div(temp, 10)
1507             } temp {
1508                 // Keep dividing `temp` until zero.
1509                 temp := div(temp, 10)
1510             } {
1511                 // Body of the for loop.
1512                 ptr := sub(ptr, 1)
1513                 mstore8(ptr, add(48, mod(temp, 10)))
1514             }
1515 
1516             let length := sub(end, ptr)
1517             // Move the pointer 32 bytes leftwards to make room for the length.
1518             ptr := sub(ptr, 32)
1519             // Store the length.
1520             mstore(ptr, length)
1521         }
1522     }
1523 }
1524 
1525 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1526 
1527 
1528 // ERC721A Contracts v4.1.0
1529 // Creator: Chiru Labs
1530 
1531 pragma solidity ^0.8.4;
1532 
1533 
1534 /**
1535  * @dev Interface of an ERC721AQueryable compliant contract.
1536  */
1537 interface IERC721AQueryable is IERC721A {
1538     /**
1539      * Invalid query range (`start` >= `stop`).
1540      */
1541     error InvalidQueryRange();
1542 
1543     /**
1544      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1545      *
1546      * If the `tokenId` is out of bounds:
1547      *   - `addr` = `address(0)`
1548      *   - `startTimestamp` = `0`
1549      *   - `burned` = `false`
1550      *
1551      * If the `tokenId` is burned:
1552      *   - `addr` = `<Address of owner before token was burned>`
1553      *   - `startTimestamp` = `<Timestamp when token was burned>`
1554      *   - `burned = `true`
1555      *
1556      * Otherwise:
1557      *   - `addr` = `<Address of owner>`
1558      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1559      *   - `burned = `false`
1560      */
1561     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1562 
1563     /**
1564      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1565      * See {ERC721AQueryable-explicitOwnershipOf}
1566      */
1567     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1568 
1569     /**
1570      * @dev Returns an array of token IDs owned by `owner`,
1571      * in the range [`start`, `stop`)
1572      * (i.e. `start <= tokenId < stop`).
1573      *
1574      * This function allows for tokens to be queried if the collection
1575      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1576      *
1577      * Requirements:
1578      *
1579      * - `start` < `stop`
1580      */
1581     function tokensOfOwnerIn(
1582         address owner,
1583         uint256 start,
1584         uint256 stop
1585     ) external view returns (uint256[] memory);
1586 
1587     /**
1588      * @dev Returns an array of token IDs owned by `owner`.
1589      *
1590      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1591      * It is meant to be called off-chain.
1592      *
1593      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1594      * multiple smaller scans if the collection is large enough to cause
1595      * an out-of-gas error (10K pfp collections should be fine).
1596      */
1597     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1598 }
1599 
1600 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1601 
1602 
1603 // ERC721A Contracts v4.1.0
1604 // Creator: Chiru Labs
1605 
1606 pragma solidity ^0.8.4;
1607 
1608 
1609 
1610 /**
1611  * @title ERC721A Queryable
1612  * @dev ERC721A subclass with convenience query functions.
1613  */
1614 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1615     /**
1616      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1617      *
1618      * If the `tokenId` is out of bounds:
1619      *   - `addr` = `address(0)`
1620      *   - `startTimestamp` = `0`
1621      *   - `burned` = `false`
1622      *   - `extraData` = `0`
1623      *
1624      * If the `tokenId` is burned:
1625      *   - `addr` = `<Address of owner before token was burned>`
1626      *   - `startTimestamp` = `<Timestamp when token was burned>`
1627      *   - `burned = `true`
1628      *   - `extraData` = `<Extra data when token was burned>`
1629      *
1630      * Otherwise:
1631      *   - `addr` = `<Address of owner>`
1632      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1633      *   - `burned = `false`
1634      *   - `extraData` = `<Extra data at start of ownership>`
1635      */
1636     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1637         TokenOwnership memory ownership;
1638         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1639             return ownership;
1640         }
1641         ownership = _ownershipAt(tokenId);
1642         if (ownership.burned) {
1643             return ownership;
1644         }
1645         return _ownershipOf(tokenId);
1646     }
1647 
1648     /**
1649      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1650      * See {ERC721AQueryable-explicitOwnershipOf}
1651      */
1652     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1653         unchecked {
1654             uint256 tokenIdsLength = tokenIds.length;
1655             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1656             for (uint256 i; i != tokenIdsLength; ++i) {
1657                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1658             }
1659             return ownerships;
1660         }
1661     }
1662 
1663     /**
1664      * @dev Returns an array of token IDs owned by `owner`,
1665      * in the range [`start`, `stop`)
1666      * (i.e. `start <= tokenId < stop`).
1667      *
1668      * This function allows for tokens to be queried if the collection
1669      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1670      *
1671      * Requirements:
1672      *
1673      * - `start` < `stop`
1674      */
1675     function tokensOfOwnerIn(
1676         address owner,
1677         uint256 start,
1678         uint256 stop
1679     ) external view override returns (uint256[] memory) {
1680         unchecked {
1681             if (start >= stop) revert InvalidQueryRange();
1682             uint256 tokenIdsIdx;
1683             uint256 stopLimit = _nextTokenId();
1684             // Set `start = max(start, _startTokenId())`.
1685             if (start < _startTokenId()) {
1686                 start = _startTokenId();
1687             }
1688             // Set `stop = min(stop, stopLimit)`.
1689             if (stop > stopLimit) {
1690                 stop = stopLimit;
1691             }
1692             uint256 tokenIdsMaxLength = balanceOf(owner);
1693             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1694             // to cater for cases where `balanceOf(owner)` is too big.
1695             if (start < stop) {
1696                 uint256 rangeLength = stop - start;
1697                 if (rangeLength < tokenIdsMaxLength) {
1698                     tokenIdsMaxLength = rangeLength;
1699                 }
1700             } else {
1701                 tokenIdsMaxLength = 0;
1702             }
1703             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1704             if (tokenIdsMaxLength == 0) {
1705                 return tokenIds;
1706             }
1707             // We need to call `explicitOwnershipOf(start)`,
1708             // because the slot at `start` may not be initialized.
1709             TokenOwnership memory ownership = explicitOwnershipOf(start);
1710             address currOwnershipAddr;
1711             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1712             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1713             if (!ownership.burned) {
1714                 currOwnershipAddr = ownership.addr;
1715             }
1716             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1717                 ownership = _ownershipAt(i);
1718                 if (ownership.burned) {
1719                     continue;
1720                 }
1721                 if (ownership.addr != address(0)) {
1722                     currOwnershipAddr = ownership.addr;
1723                 }
1724                 if (currOwnershipAddr == owner) {
1725                     tokenIds[tokenIdsIdx++] = i;
1726                 }
1727             }
1728             // Downsize the array to fit.
1729             assembly {
1730                 mstore(tokenIds, tokenIdsIdx)
1731             }
1732             return tokenIds;
1733         }
1734     }
1735 
1736     /**
1737      * @dev Returns an array of token IDs owned by `owner`.
1738      *
1739      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1740      * It is meant to be called off-chain.
1741      *
1742      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1743      * multiple smaller scans if the collection is large enough to cause
1744      * an out-of-gas error (10K pfp collections should be fine).
1745      */
1746     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1747         unchecked {
1748             uint256 tokenIdsIdx;
1749             address currOwnershipAddr;
1750             uint256 tokenIdsLength = balanceOf(owner);
1751             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1752             TokenOwnership memory ownership;
1753             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1754                 ownership = _ownershipAt(i);
1755                 if (ownership.burned) {
1756                     continue;
1757                 }
1758                 if (ownership.addr != address(0)) {
1759                     currOwnershipAddr = ownership.addr;
1760                 }
1761                 if (currOwnershipAddr == owner) {
1762                     tokenIds[tokenIdsIdx++] = i;
1763                 }
1764             }
1765             return tokenIds;
1766         }
1767     }
1768 }
1769 
1770 
1771 
1772 pragma solidity >=0.8.9 <0.9.0;
1773 
1774 contract Azurbalabutnotshitty is ERC721AQueryable, Ownable, ReentrancyGuard {
1775     using Strings for uint256;
1776 
1777     uint256 public maxSupply = 3690;
1778 	uint256 public Ownermint = 1;
1779     uint256 public maxPerAddress = 100;
1780 	uint256 public maxPerTX = 5;
1781     uint256 public cost = 0.002 ether;
1782 	mapping(address => bool) public freeMinted; 
1783 
1784     bool public paused = true;
1785 
1786 	string public uriPrefix = '';
1787     string public uriSuffix = '.json';
1788 	
1789   constructor(string memory baseURI) ERC721A("Azurbala (But Not Shitty)", "ABNS") {
1790       setUriPrefix(baseURI); 
1791       _safeMint(_msgSender(), Ownermint);
1792 
1793   }
1794 
1795   modifier callerIsUser() {
1796         require(tx.origin == msg.sender, "The caller is another contract");
1797         _;
1798   }
1799 
1800   function numberMinted(address owner) public view returns (uint256) {
1801         return _numberMinted(owner);
1802   }
1803 
1804   function Mint (uint256 _mintAmount) public payable nonReentrant callerIsUser{
1805         require(!paused, 'The contract is paused!');
1806         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1807         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1808         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1809 	if (freeMinted[_msgSender()]){
1810         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1811   }
1812     else{
1813 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1814         freeMinted[_msgSender()] = true;
1815   }
1816 
1817     _safeMint(_msgSender(), _mintAmount);
1818   }
1819 
1820   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1821     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1822     string memory currentBaseURI = _baseURI();
1823     return bytes(currentBaseURI).length > 0
1824         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1825         : '';
1826   }
1827 
1828   function unpause () public onlyOwner {
1829     paused = !paused;
1830   }
1831 
1832   function setCost(uint256 _cost) public onlyOwner {
1833     cost = _cost;
1834   }
1835 
1836   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1837     maxPerTX = _maxPerTX;
1838   }
1839 
1840   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1841     uriPrefix = _uriPrefix;
1842   }
1843  
1844   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1845     uriSuffix = _uriSuffix;
1846   }
1847 
1848   function withdraw() external onlyOwner {
1849         payable(msg.sender).transfer(address(this).balance);
1850   }
1851 
1852   function _startTokenId() internal view virtual override returns (uint256) {
1853     return 1;
1854   }
1855 
1856   function _baseURI() internal view virtual override returns (string memory) {
1857     return uriPrefix;
1858   }
1859 }