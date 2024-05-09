1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4    _____                             .___                .___.__                                                      
5   /     \   ____   ____   ____     __| _/____   ____   __| _/|  |   ____   _____  ______   ____                       
6  /  \ /  \ /  _ \ /  _ \ /    \   / __ |/  _ \ /  _ \ / __ | |  | _/ __ \  \__  \ \____ \_/ __ \                      
7 /    Y    (  <_> |  <_> )   |  \ / /_/ (  <_> |  <_> ) /_/ | |  |_\  ___/   / __ \|  |_> >  ___/                      
8 \____|__  /\____/ \____/|___|  / \____ |\____/ \____/\____ | |____/\___  > (____  /   __/ \___  >                     
9         \/                   \/       \/                  \/           \/       \/|__|        \/                      
10 ___.         ___.           ___.          __            __   .__    __                                    __    _____ 
11 \_ |__ _____ \_ |__ ___.__. \_ |__  __ __|  | _______  |  | _|__| _/  |_  ______  _  ______    __  _  ___/  |__/ ____\
12  | __ \\__  \ | __ <   |  |  | __ \|  |  \  |/ /\__  \ |  |/ /  | \   __\/  _ \ \/ \/ /    \   \ \/ \/ /\   __\   __\ 
13  | \_\ \/ __ \| \_\ \___  |  | \_\ \  |  /    <  / __ \|    <|  |  |  | (  <_> )     /   |  \   \     /  |  |  |  |   
14  |___  (____  /___  / ____|  |___  /____/|__|_ \(____  /__|_ \__|  |__|  \____/ \/\_/|___|  / /\ \/\_/   |__|  |__|   
15      \/     \/    \/\/           \/           \/     \/     \/                            \/  \/                                                      
16                                                                            
17 */
18 
19 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Contract module that helps prevent reentrant calls to a function.
25  *
26  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
27  * available, which can be applied to functions to make sure there are no nested
28  * (reentrant) calls to them.
29  *
30  * Note that because there is a single `nonReentrant` guard, functions marked as
31  * `nonReentrant` may not call one another. This can be worked around by making
32  * those functions `private`, and then adding `external` `nonReentrant` entry
33  * points to them.
34  *
35  * TIP: If you would like to learn more about reentrancy and alternative ways
36  * to protect against it, check out our blog post
37  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
38  */
39 abstract contract ReentrancyGuard {
40     // Booleans are more expensive than uint256 or any type that takes up a full
41     // word because each write operation emits an extra SLOAD to first read the
42     // slot's contents, replace the bits taken up by the boolean, and then write
43     // back. This is the compiler's defense against contract upgrades and
44     // pointer aliasing, and it cannot be disabled.
45 
46     // The values being non-zero value makes deployment a bit more expensive,
47     // but in exchange the refund on every call to nonReentrant will be lower in
48     // amount. Since refunds are capped to a percentage of the total
49     // transaction's gas, it is best to keep them low in cases like this one, to
50     // increase the likelihood of the full refund coming into effect.
51     uint256 private constant _NOT_ENTERED = 1;
52     uint256 private constant _ENTERED = 2;
53 
54     uint256 private _status;
55 
56     constructor() {
57         _status = _NOT_ENTERED;
58     }
59 
60     /**
61      * @dev Prevents a contract from calling itself, directly or indirectly.
62      * Calling a `nonReentrant` function from another `nonReentrant`
63      * function is not supported. It is possible to prevent this from happening
64      * by making the `nonReentrant` function external, and making it call a
65      * `private` function that does the actual work.
66      */
67     modifier nonReentrant() {
68         // On the first call to nonReentrant, _notEntered will be true
69         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
70 
71         // Any calls to nonReentrant after this point will fail
72         _status = _ENTERED;
73 
74         _;
75 
76         // By storing the original value once again, a refund is triggered (see
77         // https://eips.ethereum.org/EIPS/eip-2200)
78         _status = _NOT_ENTERED;
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Strings.sol
83 
84 
85 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev String operations.
91  */
92 library Strings {
93     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
94     uint8 private constant _ADDRESS_LENGTH = 20;
95 
96     /**
97      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
98      */
99     function toString(uint256 value) internal pure returns (string memory) {
100         // Inspired by OraclizeAPI's implementation - MIT licence
101         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
102 
103         if (value == 0) {
104             return "0";
105         }
106         uint256 temp = value;
107         uint256 digits;
108         while (temp != 0) {
109             digits++;
110             temp /= 10;
111         }
112         bytes memory buffer = new bytes(digits);
113         while (value != 0) {
114             digits -= 1;
115             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
116             value /= 10;
117         }
118         return string(buffer);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
123      */
124     function toHexString(uint256 value) internal pure returns (string memory) {
125         if (value == 0) {
126             return "0x00";
127         }
128         uint256 temp = value;
129         uint256 length = 0;
130         while (temp != 0) {
131             length++;
132             temp >>= 8;
133         }
134         return toHexString(value, length);
135     }
136 
137     /**
138      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
139      */
140     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
141         bytes memory buffer = new bytes(2 * length + 2);
142         buffer[0] = "0";
143         buffer[1] = "x";
144         for (uint256 i = 2 * length + 1; i > 1; --i) {
145             buffer[i] = _HEX_SYMBOLS[value & 0xf];
146             value >>= 4;
147         }
148         require(value == 0, "Strings: hex length insufficient");
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
154      */
155     function toHexString(address addr) internal pure returns (string memory) {
156         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
157     }
158 }
159 
160 
161 // File: @openzeppelin/contracts/utils/Context.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @dev Provides information about the current execution context, including the
170  * sender of the transaction and its data. While these are generally available
171  * via msg.sender and msg.data, they should not be accessed in such a direct
172  * manner, since when dealing with meta-transactions the account sending and
173  * paying for execution may not be the actual sender (as far as an application
174  * is concerned).
175  *
176  * This contract is only required for intermediate, library-like contracts.
177  */
178 abstract contract Context {
179     function _msgSender() internal view virtual returns (address) {
180         return msg.sender;
181     }
182 
183     function _msgData() internal view virtual returns (bytes calldata) {
184         return msg.data;
185     }
186 }
187 
188 // File: @openzeppelin/contracts/access/Ownable.sol
189 
190 
191 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 
196 /**
197  * @dev Contract module which provides a basic access control mechanism, where
198  * there is an account (an owner) that can be granted exclusive access to
199  * specific functions.
200  *
201  * By default, the owner account will be the one that deploys the contract. This
202  * can later be changed with {transferOwnership}.
203  *
204  * This module is used through inheritance. It will make available the modifier
205  * `onlyOwner`, which can be applied to your functions to restrict their use to
206  * the owner.
207  */
208 abstract contract Ownable is Context {
209     address private _owner;
210 
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213     /**
214      * @dev Initializes the contract setting the deployer as the initial owner.
215      */
216     constructor() {
217         _transferOwnership(_msgSender());
218     }
219 
220     /**
221      * @dev Throws if called by any account other than the owner.
222      */
223     modifier onlyOwner() {
224         _checkOwner();
225         _;
226     }
227 
228     /**
229      * @dev Returns the address of the current owner.
230      */
231     function owner() public view virtual returns (address) {
232         return _owner;
233     }
234 
235     /**
236      * @dev Throws if the sender is not the owner.
237      */
238     function _checkOwner() internal view virtual {
239         require(owner() == _msgSender(), "Ownable: caller is not the owner");
240     }
241 
242     /**
243      * @dev Leaves the contract without owner. It will not be possible to call
244      * `onlyOwner` functions anymore. Can only be called by the current owner.
245      *
246      * NOTE: Renouncing ownership will leave the contract without an owner,
247      * thereby removing any functionality that is only available to the owner.
248      */
249     function renounceOwnership() public virtual onlyOwner {
250         _transferOwnership(address(0));
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Can only be called by the current owner.
256      */
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         _transferOwnership(newOwner);
260     }
261 
262     /**
263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
264      * Internal function without access restriction.
265      */
266     function _transferOwnership(address newOwner) internal virtual {
267         address oldOwner = _owner;
268         _owner = newOwner;
269         emit OwnershipTransferred(oldOwner, newOwner);
270     }
271 }
272 
273 // File: erc721a/contracts/IERC721A.sol
274 
275 
276 // ERC721A Contracts v4.1.0
277 // Creator: Chiru Labs
278 
279 pragma solidity ^0.8.4;
280 
281 /**
282  * @dev Interface of an ERC721A compliant contract.
283  */
284 interface IERC721A {
285     /**
286      * The caller must own the token or be an approved operator.
287      */
288     error ApprovalCallerNotOwnerNorApproved();
289 
290     /**
291      * The token does not exist.
292      */
293     error ApprovalQueryForNonexistentToken();
294 
295     /**
296      * The caller cannot approve to their own address.
297      */
298     error ApproveToCaller();
299 
300     /**
301      * Cannot query the balance for the zero address.
302      */
303     error BalanceQueryForZeroAddress();
304 
305     /**
306      * Cannot mint to the zero address.
307      */
308     error MintToZeroAddress();
309 
310     /**
311      * The quantity of tokens minted must be more than zero.
312      */
313     error MintZeroQuantity();
314 
315     /**
316      * The token does not exist.
317      */
318     error OwnerQueryForNonexistentToken();
319 
320     /**
321      * The caller must own the token or be an approved operator.
322      */
323     error TransferCallerNotOwnerNorApproved();
324 
325     /**
326      * The token must be owned by `from`.
327      */
328     error TransferFromIncorrectOwner();
329 
330     /**
331      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
332      */
333     error TransferToNonERC721ReceiverImplementer();
334 
335     /**
336      * Cannot transfer to the zero address.
337      */
338     error TransferToZeroAddress();
339 
340     /**
341      * The token does not exist.
342      */
343     error URIQueryForNonexistentToken();
344 
345     /**
346      * The `quantity` minted with ERC2309 exceeds the safety limit.
347      */
348     error MintERC2309QuantityExceedsLimit();
349 
350     /**
351      * The `extraData` cannot be set on an unintialized ownership slot.
352      */
353     error OwnershipNotInitializedForExtraData();
354 
355     struct TokenOwnership {
356         // The address of the owner.
357         address addr;
358         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
359         uint64 startTimestamp;
360         // Whether the token has been burned.
361         bool burned;
362         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
363         uint24 extraData;
364     }
365 
366     /**
367      * @dev Returns the total amount of tokens stored by the contract.
368      *
369      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
370      */
371     function totalSupply() external view returns (uint256);
372 
373     // ==============================
374     //            IERC165
375     // ==============================
376 
377     /**
378      * @dev Returns true if this contract implements the interface defined by
379      * `interfaceId`. See the corresponding
380      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
381      * to learn more about how these ids are created.
382      *
383      * This function call must use less than 30 000 gas.
384      */
385     function supportsInterface(bytes4 interfaceId) external view returns (bool);
386 
387     // ==============================
388     //            IERC721
389     // ==============================
390 
391     /**
392      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
393      */
394     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
398      */
399     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
400 
401     /**
402      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
403      */
404     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
405 
406     /**
407      * @dev Returns the number of tokens in ``owner``'s account.
408      */
409     function balanceOf(address owner) external view returns (uint256 balance);
410 
411     /**
412      * @dev Returns the owner of the `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function ownerOf(uint256 tokenId) external view returns (address owner);
419 
420     /**
421      * @dev Safely transfers `tokenId` token from `from` to `to`.
422      *
423      * Requirements:
424      *
425      * - `from` cannot be the zero address.
426      * - `to` cannot be the zero address.
427      * - `tokenId` token must exist and be owned by `from`.
428      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
429      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
430      *
431      * Emits a {Transfer} event.
432      */
433     function safeTransferFrom(
434         address from,
435         address to,
436         uint256 tokenId,
437         bytes calldata data
438     ) external;
439 
440     /**
441      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
442      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must exist and be owned by `from`.
449      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
450      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
451      *
452      * Emits a {Transfer} event.
453      */
454     function safeTransferFrom(
455         address from,
456         address to,
457         uint256 tokenId
458     ) external;
459 
460     /**
461      * @dev Transfers `tokenId` token from `from` to `to`.
462      *
463      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
464      *
465      * Requirements:
466      *
467      * - `from` cannot be the zero address.
468      * - `to` cannot be the zero address.
469      * - `tokenId` token must be owned by `from`.
470      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
471      *
472      * Emits a {Transfer} event.
473      */
474     function transferFrom(
475         address from,
476         address to,
477         uint256 tokenId
478     ) external;
479 
480     /**
481      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
482      * The approval is cleared when the token is transferred.
483      *
484      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
485      *
486      * Requirements:
487      *
488      * - The caller must own the token or be an approved operator.
489      * - `tokenId` must exist.
490      *
491      * Emits an {Approval} event.
492      */
493     function approve(address to, uint256 tokenId) external;
494 
495     /**
496      * @dev Approve or remove `operator` as an operator for the caller.
497      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
498      *
499      * Requirements:
500      *
501      * - The `operator` cannot be the caller.
502      *
503      * Emits an {ApprovalForAll} event.
504      */
505     function setApprovalForAll(address operator, bool _approved) external;
506 
507     /**
508      * @dev Returns the account approved for `tokenId` token.
509      *
510      * Requirements:
511      *
512      * - `tokenId` must exist.
513      */
514     function getApproved(uint256 tokenId) external view returns (address operator);
515 
516     /**
517      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
518      *
519      * See {setApprovalForAll}
520      */
521     function isApprovedForAll(address owner, address operator) external view returns (bool);
522 
523     // ==============================
524     //        IERC721Metadata
525     // ==============================
526 
527     /**
528      * @dev Returns the token collection name.
529      */
530     function name() external view returns (string memory);
531 
532     /**
533      * @dev Returns the token collection symbol.
534      */
535     function symbol() external view returns (string memory);
536 
537     /**
538      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
539      */
540     function tokenURI(uint256 tokenId) external view returns (string memory);
541 
542     // ==============================
543     //            IERC2309
544     // ==============================
545 
546     /**
547      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
548      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
549      */
550     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
551 }
552 
553 // File: erc721a/contracts/ERC721A.sol
554 
555 
556 // ERC721A Contracts v4.1.0
557 // Creator: Chiru Labs
558 
559 pragma solidity ^0.8.4;
560 
561 
562 /**
563  * @dev ERC721 token receiver interface.
564  */
565 interface ERC721A__IERC721Receiver {
566     function onERC721Received(
567         address operator,
568         address from,
569         uint256 tokenId,
570         bytes calldata data
571     ) external returns (bytes4);
572 }
573 
574 /**
575  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
576  * including the Metadata extension. Built to optimize for lower gas during batch mints.
577  *
578  * Assumes serials are sequentially minted starting at `_startTokenId()`
579  * (defaults to 0, e.g. 0, 1, 2, 3..).
580  *
581  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
582  *
583  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
584  */
585 contract ERC721A is IERC721A {
586     // Mask of an entry in packed address data.
587     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
588 
589     // The bit position of `numberMinted` in packed address data.
590     uint256 private constant BITPOS_NUMBER_MINTED = 64;
591 
592     // The bit position of `numberBurned` in packed address data.
593     uint256 private constant BITPOS_NUMBER_BURNED = 128;
594 
595     // The bit position of `aux` in packed address data.
596     uint256 private constant BITPOS_AUX = 192;
597 
598     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
599     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
600 
601     // The bit position of `startTimestamp` in packed ownership.
602     uint256 private constant BITPOS_START_TIMESTAMP = 160;
603 
604     // The bit mask of the `burned` bit in packed ownership.
605     uint256 private constant BITMASK_BURNED = 1 << 224;
606 
607     // The bit position of the `nextInitialized` bit in packed ownership.
608     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
609 
610     // The bit mask of the `nextInitialized` bit in packed ownership.
611     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
612 
613     // The bit position of `extraData` in packed ownership.
614     uint256 private constant BITPOS_EXTRA_DATA = 232;
615 
616     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
617     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
618 
619     // The mask of the lower 160 bits for addresses.
620     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
621 
622     // The maximum `quantity` that can be minted with `_mintERC2309`.
623     // This limit is to prevent overflows on the address data entries.
624     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
625     // is required to cause an overflow, which is unrealistic.
626     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
627 
628     // The tokenId of the next token to be minted.
629     uint256 private _currentIndex;
630 
631     // The number of tokens burned.
632     uint256 private _burnCounter;
633 
634     // Token name
635     string private _name;
636 
637     // Token symbol
638     string private _symbol;
639 
640     // Mapping from token ID to ownership details
641     // An empty struct value does not necessarily mean the token is unowned.
642     // See `_packedOwnershipOf` implementation for details.
643     //
644     // Bits Layout:
645     // - [0..159]   `addr`
646     // - [160..223] `startTimestamp`
647     // - [224]      `burned`
648     // - [225]      `nextInitialized`
649     // - [232..255] `extraData`
650     mapping(uint256 => uint256) private _packedOwnerships;
651 
652     // Mapping owner address to address data.
653     //
654     // Bits Layout:
655     // - [0..63]    `balance`
656     // - [64..127]  `numberMinted`
657     // - [128..191] `numberBurned`
658     // - [192..255] `aux`
659     mapping(address => uint256) private _packedAddressData;
660 
661     // Mapping from token ID to approved address.
662     mapping(uint256 => address) private _tokenApprovals;
663 
664     // Mapping from owner to operator approvals
665     mapping(address => mapping(address => bool)) private _operatorApprovals;
666 
667     constructor(string memory name_, string memory symbol_) {
668         _name = name_;
669         _symbol = symbol_;
670         _currentIndex = _startTokenId();
671     }
672 
673     /**
674      * @dev Returns the starting token ID.
675      * To change the starting token ID, please override this function.
676      */
677     function _startTokenId() internal view virtual returns (uint256) {
678         return 0;
679     }
680 
681     /**
682      * @dev Returns the next token ID to be minted.
683      */
684     function _nextTokenId() internal view returns (uint256) {
685         return _currentIndex;
686     }
687 
688     /**
689      * @dev Returns the total number of tokens in existence.
690      * Burned tokens will reduce the count.
691      * To get the total number of tokens minted, please see `_totalMinted`.
692      */
693     function totalSupply() public view override returns (uint256) {
694         // Counter underflow is impossible as _burnCounter cannot be incremented
695         // more than `_currentIndex - _startTokenId()` times.
696         unchecked {
697             return _currentIndex - _burnCounter - _startTokenId();
698         }
699     }
700 
701     /**
702      * @dev Returns the total amount of tokens minted in the contract.
703      */
704     function _totalMinted() internal view returns (uint256) {
705         // Counter underflow is impossible as _currentIndex does not decrement,
706         // and it is initialized to `_startTokenId()`
707         unchecked {
708             return _currentIndex - _startTokenId();
709         }
710     }
711 
712     /**
713      * @dev Returns the total number of tokens burned.
714      */
715     function _totalBurned() internal view returns (uint256) {
716         return _burnCounter;
717     }
718 
719     /**
720      * @dev See {IERC165-supportsInterface}.
721      */
722     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
723         // The interface IDs are constants representing the first 4 bytes of the XOR of
724         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
725         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
726         return
727             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
728             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
729             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
730     }
731 
732     /**
733      * @dev See {IERC721-balanceOf}.
734      */
735     function balanceOf(address owner) public view override returns (uint256) {
736         if (owner == address(0)) revert BalanceQueryForZeroAddress();
737         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
738     }
739 
740     /**
741      * Returns the number of tokens minted by `owner`.
742      */
743     function _numberMinted(address owner) internal view returns (uint256) {
744         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
745     }
746 
747     /**
748      * Returns the number of tokens burned by or on behalf of `owner`.
749      */
750     function _numberBurned(address owner) internal view returns (uint256) {
751         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
752     }
753 
754     /**
755      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
756      */
757     function _getAux(address owner) internal view returns (uint64) {
758         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
759     }
760 
761     /**
762      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
763      * If there are multiple variables, please pack them into a uint64.
764      */
765     function _setAux(address owner, uint64 aux) internal {
766         uint256 packed = _packedAddressData[owner];
767         uint256 auxCasted;
768         // Cast `aux` with assembly to avoid redundant masking.
769         assembly {
770             auxCasted := aux
771         }
772         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
773         _packedAddressData[owner] = packed;
774     }
775 
776     /**
777      * Returns the packed ownership data of `tokenId`.
778      */
779     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
780         uint256 curr = tokenId;
781 
782         unchecked {
783             if (_startTokenId() <= curr)
784                 if (curr < _currentIndex) {
785                     uint256 packed = _packedOwnerships[curr];
786                     // If not burned.
787                     if (packed & BITMASK_BURNED == 0) {
788                         // Invariant:
789                         // There will always be an ownership that has an address and is not burned
790                         // before an ownership that does not have an address and is not burned.
791                         // Hence, curr will not underflow.
792                         //
793                         // We can directly compare the packed value.
794                         // If the address is zero, packed is zero.
795                         while (packed == 0) {
796                             packed = _packedOwnerships[--curr];
797                         }
798                         return packed;
799                     }
800                 }
801         }
802         revert OwnerQueryForNonexistentToken();
803     }
804 
805     /**
806      * Returns the unpacked `TokenOwnership` struct from `packed`.
807      */
808     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
809         ownership.addr = address(uint160(packed));
810         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
811         ownership.burned = packed & BITMASK_BURNED != 0;
812         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
813     }
814 
815     /**
816      * Returns the unpacked `TokenOwnership` struct at `index`.
817      */
818     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
819         return _unpackedOwnership(_packedOwnerships[index]);
820     }
821 
822     /**
823      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
824      */
825     function _initializeOwnershipAt(uint256 index) internal {
826         if (_packedOwnerships[index] == 0) {
827             _packedOwnerships[index] = _packedOwnershipOf(index);
828         }
829     }
830 
831     /**
832      * Gas spent here starts off proportional to the maximum mint batch size.
833      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
834      */
835     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
836         return _unpackedOwnership(_packedOwnershipOf(tokenId));
837     }
838 
839     /**
840      * @dev Packs ownership data into a single uint256.
841      */
842     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
843         assembly {
844             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
845             owner := and(owner, BITMASK_ADDRESS)
846             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
847             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
848         }
849     }
850 
851     /**
852      * @dev See {IERC721-ownerOf}.
853      */
854     function ownerOf(uint256 tokenId) public view override returns (address) {
855         return address(uint160(_packedOwnershipOf(tokenId)));
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-name}.
860      */
861     function name() public view virtual override returns (string memory) {
862         return _name;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-symbol}.
867      */
868     function symbol() public view virtual override returns (string memory) {
869         return _symbol;
870     }
871 
872     /**
873      * @dev See {IERC721Metadata-tokenURI}.
874      */
875     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
876         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
877 
878         string memory baseURI = _baseURI();
879         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
880     }
881 
882     /**
883      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
884      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
885      * by default, it can be overridden in child contracts.
886      */
887     function _baseURI() internal view virtual returns (string memory) {
888         return '';
889     }
890 
891     /**
892      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
893      */
894     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
895         // For branchless setting of the `nextInitialized` flag.
896         assembly {
897             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
898             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
899         }
900     }
901 
902     /**
903      * @dev See {IERC721-approve}.
904      */
905     function approve(address to, uint256 tokenId) public override {
906         address owner = ownerOf(tokenId);
907 
908         if (_msgSenderERC721A() != owner)
909             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
910                 revert ApprovalCallerNotOwnerNorApproved();
911             }
912 
913         _tokenApprovals[tokenId] = to;
914         emit Approval(owner, to, tokenId);
915     }
916 
917     /**
918      * @dev See {IERC721-getApproved}.
919      */
920     function getApproved(uint256 tokenId) public view override returns (address) {
921         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
922 
923         return _tokenApprovals[tokenId];
924     }
925 
926     /**
927      * @dev See {IERC721-setApprovalForAll}.
928      */
929     function setApprovalForAll(address operator, bool approved) public virtual override {
930         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
931 
932         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
933         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
934     }
935 
936     /**
937      * @dev See {IERC721-isApprovedForAll}.
938      */
939     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
940         return _operatorApprovals[owner][operator];
941     }
942 
943     /**
944      * @dev See {IERC721-safeTransferFrom}.
945      */
946     function safeTransferFrom(
947         address from,
948         address to,
949         uint256 tokenId
950     ) public virtual override {
951         safeTransferFrom(from, to, tokenId, '');
952     }
953 
954     /**
955      * @dev See {IERC721-safeTransferFrom}.
956      */
957     function safeTransferFrom(
958         address from,
959         address to,
960         uint256 tokenId,
961         bytes memory _data
962     ) public virtual override {
963         transferFrom(from, to, tokenId);
964         if (to.code.length != 0)
965             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
966                 revert TransferToNonERC721ReceiverImplementer();
967             }
968     }
969 
970     /**
971      * @dev Returns whether `tokenId` exists.
972      *
973      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
974      *
975      * Tokens start existing when they are minted (`_mint`),
976      */
977     function _exists(uint256 tokenId) internal view returns (bool) {
978         return
979             _startTokenId() <= tokenId &&
980             tokenId < _currentIndex && // If within bounds,
981             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
982     }
983 
984     /**
985      * @dev Equivalent to `_safeMint(to, quantity, '')`.
986      */
987     function _safeMint(address to, uint256 quantity) internal {
988         _safeMint(to, quantity, '');
989     }
990 
991     /**
992      * @dev Safely mints `quantity` tokens and transfers them to `to`.
993      *
994      * Requirements:
995      *
996      * - If `to` refers to a smart contract, it must implement
997      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
998      * - `quantity` must be greater than 0.
999      *
1000      * See {_mint}.
1001      *
1002      * Emits a {Transfer} event for each mint.
1003      */
1004     function _safeMint(
1005         address to,
1006         uint256 quantity,
1007         bytes memory _data
1008     ) internal {
1009         _mint(to, quantity);
1010 
1011         unchecked {
1012             if (to.code.length != 0) {
1013                 uint256 end = _currentIndex;
1014                 uint256 index = end - quantity;
1015                 do {
1016                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1017                         revert TransferToNonERC721ReceiverImplementer();
1018                     }
1019                 } while (index < end);
1020                 // Reentrancy protection.
1021                 if (_currentIndex != end) revert();
1022             }
1023         }
1024     }
1025 
1026     /**
1027      * @dev Mints `quantity` tokens and transfers them to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `quantity` must be greater than 0.
1033      *
1034      * Emits a {Transfer} event for each mint.
1035      */
1036     function _mint(address to, uint256 quantity) internal {
1037         uint256 startTokenId = _currentIndex;
1038         if (to == address(0)) revert MintToZeroAddress();
1039         if (quantity == 0) revert MintZeroQuantity();
1040 
1041         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1042 
1043         // Overflows are incredibly unrealistic.
1044         // `balance` and `numberMinted` have a maximum limit of 2**64.
1045         // `tokenId` has a maximum limit of 2**256.
1046         unchecked {
1047             // Updates:
1048             // - `balance += quantity`.
1049             // - `numberMinted += quantity`.
1050             //
1051             // We can directly add to the `balance` and `numberMinted`.
1052             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1053 
1054             // Updates:
1055             // - `address` to the owner.
1056             // - `startTimestamp` to the timestamp of minting.
1057             // - `burned` to `false`.
1058             // - `nextInitialized` to `quantity == 1`.
1059             _packedOwnerships[startTokenId] = _packOwnershipData(
1060                 to,
1061                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1062             );
1063 
1064             uint256 tokenId = startTokenId;
1065             uint256 end = startTokenId + quantity;
1066             do {
1067                 emit Transfer(address(0), to, tokenId++);
1068             } while (tokenId < end);
1069 
1070             _currentIndex = end;
1071         }
1072         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1073     }
1074 
1075     /**
1076      * @dev Mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * This function is intended for efficient minting only during contract creation.
1079      *
1080      * It emits only one {ConsecutiveTransfer} as defined in
1081      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1082      * instead of a sequence of {Transfer} event(s).
1083      *
1084      * Calling this function outside of contract creation WILL make your contract
1085      * non-compliant with the ERC721 standard.
1086      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1087      * {ConsecutiveTransfer} event is only permissible during contract creation.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {ConsecutiveTransfer} event.
1095      */
1096     function _mintERC2309(address to, uint256 quantity) internal {
1097         uint256 startTokenId = _currentIndex;
1098         if (to == address(0)) revert MintToZeroAddress();
1099         if (quantity == 0) revert MintZeroQuantity();
1100         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1105         unchecked {
1106             // Updates:
1107             // - `balance += quantity`.
1108             // - `numberMinted += quantity`.
1109             //
1110             // We can directly add to the `balance` and `numberMinted`.
1111             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1112 
1113             // Updates:
1114             // - `address` to the owner.
1115             // - `startTimestamp` to the timestamp of minting.
1116             // - `burned` to `false`.
1117             // - `nextInitialized` to `quantity == 1`.
1118             _packedOwnerships[startTokenId] = _packOwnershipData(
1119                 to,
1120                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1121             );
1122 
1123             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1124 
1125             _currentIndex = startTokenId + quantity;
1126         }
1127         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128     }
1129 
1130     /**
1131      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1132      */
1133     function _getApprovedAddress(uint256 tokenId)
1134         private
1135         view
1136         returns (uint256 approvedAddressSlot, address approvedAddress)
1137     {
1138         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1139         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1140         assembly {
1141             // Compute the slot.
1142             mstore(0x00, tokenId)
1143             mstore(0x20, tokenApprovalsPtr.slot)
1144             approvedAddressSlot := keccak256(0x00, 0x40)
1145             // Load the slot's value from storage.
1146             approvedAddress := sload(approvedAddressSlot)
1147         }
1148     }
1149 
1150     /**
1151      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1152      */
1153     function _isOwnerOrApproved(
1154         address approvedAddress,
1155         address from,
1156         address msgSender
1157     ) private pure returns (bool result) {
1158         assembly {
1159             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1160             from := and(from, BITMASK_ADDRESS)
1161             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1162             msgSender := and(msgSender, BITMASK_ADDRESS)
1163             // `msgSender == from || msgSender == approvedAddress`.
1164             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1165         }
1166     }
1167 
1168     /**
1169      * @dev Transfers `tokenId` from `from` to `to`.
1170      *
1171      * Requirements:
1172      *
1173      * - `to` cannot be the zero address.
1174      * - `tokenId` token must be owned by `from`.
1175      *
1176      * Emits a {Transfer} event.
1177      */
1178     function transferFrom(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) public virtual override {
1183         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1184 
1185         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1186 
1187         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1188 
1189         // The nested ifs save around 20+ gas over a compound boolean condition.
1190         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1191             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1192 
1193         if (to == address(0)) revert TransferToZeroAddress();
1194 
1195         _beforeTokenTransfers(from, to, tokenId, 1);
1196 
1197         // Clear approvals from the previous owner.
1198         assembly {
1199             if approvedAddress {
1200                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1201                 sstore(approvedAddressSlot, 0)
1202             }
1203         }
1204 
1205         // Underflow of the sender's balance is impossible because we check for
1206         // ownership above and the recipient's balance can't realistically overflow.
1207         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1208         unchecked {
1209             // We can directly increment and decrement the balances.
1210             --_packedAddressData[from]; // Updates: `balance -= 1`.
1211             ++_packedAddressData[to]; // Updates: `balance += 1`.
1212 
1213             // Updates:
1214             // - `address` to the next owner.
1215             // - `startTimestamp` to the timestamp of transfering.
1216             // - `burned` to `false`.
1217             // - `nextInitialized` to `true`.
1218             _packedOwnerships[tokenId] = _packOwnershipData(
1219                 to,
1220                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1221             );
1222 
1223             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1224             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1225                 uint256 nextTokenId = tokenId + 1;
1226                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1227                 if (_packedOwnerships[nextTokenId] == 0) {
1228                     // If the next slot is within bounds.
1229                     if (nextTokenId != _currentIndex) {
1230                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1231                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1232                     }
1233                 }
1234             }
1235         }
1236 
1237         emit Transfer(from, to, tokenId);
1238         _afterTokenTransfers(from, to, tokenId, 1);
1239     }
1240 
1241     /**
1242      * @dev Equivalent to `_burn(tokenId, false)`.
1243      */
1244     function _burn(uint256 tokenId) internal virtual {
1245         _burn(tokenId, false);
1246     }
1247 
1248     /**
1249      * @dev Destroys `tokenId`.
1250      * The approval is cleared when the token is burned.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must exist.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1259         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1260 
1261         address from = address(uint160(prevOwnershipPacked));
1262 
1263         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1264 
1265         if (approvalCheck) {
1266             // The nested ifs save around 20+ gas over a compound boolean condition.
1267             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1268                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1269         }
1270 
1271         _beforeTokenTransfers(from, address(0), tokenId, 1);
1272 
1273         // Clear approvals from the previous owner.
1274         assembly {
1275             if approvedAddress {
1276                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1277                 sstore(approvedAddressSlot, 0)
1278             }
1279         }
1280 
1281         // Underflow of the sender's balance is impossible because we check for
1282         // ownership above and the recipient's balance can't realistically overflow.
1283         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1284         unchecked {
1285             // Updates:
1286             // - `balance -= 1`.
1287             // - `numberBurned += 1`.
1288             //
1289             // We can directly decrement the balance, and increment the number burned.
1290             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1291             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1292 
1293             // Updates:
1294             // - `address` to the last owner.
1295             // - `startTimestamp` to the timestamp of burning.
1296             // - `burned` to `true`.
1297             // - `nextInitialized` to `true`.
1298             _packedOwnerships[tokenId] = _packOwnershipData(
1299                 from,
1300                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1301             );
1302 
1303             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1304             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1305                 uint256 nextTokenId = tokenId + 1;
1306                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1307                 if (_packedOwnerships[nextTokenId] == 0) {
1308                     // If the next slot is within bounds.
1309                     if (nextTokenId != _currentIndex) {
1310                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1311                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1312                     }
1313                 }
1314             }
1315         }
1316 
1317         emit Transfer(from, address(0), tokenId);
1318         _afterTokenTransfers(from, address(0), tokenId, 1);
1319 
1320         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1321         unchecked {
1322             _burnCounter++;
1323         }
1324     }
1325 
1326     /**
1327      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1328      *
1329      * @param from address representing the previous owner of the given token ID
1330      * @param to target address that will receive the tokens
1331      * @param tokenId uint256 ID of the token to be transferred
1332      * @param _data bytes optional data to send along with the call
1333      * @return bool whether the call correctly returned the expected magic value
1334      */
1335     function _checkContractOnERC721Received(
1336         address from,
1337         address to,
1338         uint256 tokenId,
1339         bytes memory _data
1340     ) private returns (bool) {
1341         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1342             bytes4 retval
1343         ) {
1344             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1345         } catch (bytes memory reason) {
1346             if (reason.length == 0) {
1347                 revert TransferToNonERC721ReceiverImplementer();
1348             } else {
1349                 assembly {
1350                     revert(add(32, reason), mload(reason))
1351                 }
1352             }
1353         }
1354     }
1355 
1356     /**
1357      * @dev Directly sets the extra data for the ownership data `index`.
1358      */
1359     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1360         uint256 packed = _packedOwnerships[index];
1361         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1362         uint256 extraDataCasted;
1363         // Cast `extraData` with assembly to avoid redundant masking.
1364         assembly {
1365             extraDataCasted := extraData
1366         }
1367         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1368         _packedOwnerships[index] = packed;
1369     }
1370 
1371     /**
1372      * @dev Returns the next extra data for the packed ownership data.
1373      * The returned result is shifted into position.
1374      */
1375     function _nextExtraData(
1376         address from,
1377         address to,
1378         uint256 prevOwnershipPacked
1379     ) private view returns (uint256) {
1380         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1381         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1382     }
1383 
1384     /**
1385      * @dev Called during each token transfer to set the 24bit `extraData` field.
1386      * Intended to be overridden by the cosumer contract.
1387      *
1388      * `previousExtraData` - the value of `extraData` before transfer.
1389      *
1390      * Calling conditions:
1391      *
1392      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1393      * transferred to `to`.
1394      * - When `from` is zero, `tokenId` will be minted for `to`.
1395      * - When `to` is zero, `tokenId` will be burned by `from`.
1396      * - `from` and `to` are never both zero.
1397      */
1398     function _extraData(
1399         address from,
1400         address to,
1401         uint24 previousExtraData
1402     ) internal view virtual returns (uint24) {}
1403 
1404     /**
1405      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1406      * This includes minting.
1407      * And also called before burning one token.
1408      *
1409      * startTokenId - the first token id to be transferred
1410      * quantity - the amount to be transferred
1411      *
1412      * Calling conditions:
1413      *
1414      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1415      * transferred to `to`.
1416      * - When `from` is zero, `tokenId` will be minted for `to`.
1417      * - When `to` is zero, `tokenId` will be burned by `from`.
1418      * - `from` and `to` are never both zero.
1419      */
1420     function _beforeTokenTransfers(
1421         address from,
1422         address to,
1423         uint256 startTokenId,
1424         uint256 quantity
1425     ) internal virtual {}
1426 
1427     /**
1428      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1429      * This includes minting.
1430      * And also called after one token has been burned.
1431      *
1432      * startTokenId - the first token id to be transferred
1433      * quantity - the amount to be transferred
1434      *
1435      * Calling conditions:
1436      *
1437      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1438      * transferred to `to`.
1439      * - When `from` is zero, `tokenId` has been minted for `to`.
1440      * - When `to` is zero, `tokenId` has been burned by `from`.
1441      * - `from` and `to` are never both zero.
1442      */
1443     function _afterTokenTransfers(
1444         address from,
1445         address to,
1446         uint256 startTokenId,
1447         uint256 quantity
1448     ) internal virtual {}
1449 
1450     /**
1451      * @dev Returns the message sender (defaults to `msg.sender`).
1452      *
1453      * If you are writing GSN compatible contracts, you need to override this function.
1454      */
1455     function _msgSenderERC721A() internal view virtual returns (address) {
1456         return msg.sender;
1457     }
1458 
1459     /**
1460      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1461      */
1462     function _toString(uint256 value) internal pure returns (string memory ptr) {
1463         assembly {
1464             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1465             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1466             // We will need 1 32-byte word to store the length,
1467             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1468             ptr := add(mload(0x40), 128)
1469             // Update the free memory pointer to allocate.
1470             mstore(0x40, ptr)
1471 
1472             // Cache the end of the memory to calculate the length later.
1473             let end := ptr
1474 
1475             // We write the string from the rightmost digit to the leftmost digit.
1476             // The following is essentially a do-while loop that also handles the zero case.
1477             // Costs a bit more than early returning for the zero case,
1478             // but cheaper in terms of deployment and overall runtime costs.
1479             for {
1480                 // Initialize and perform the first pass without check.
1481                 let temp := value
1482                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1483                 ptr := sub(ptr, 1)
1484                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1485                 mstore8(ptr, add(48, mod(temp, 10)))
1486                 temp := div(temp, 10)
1487             } temp {
1488                 // Keep dividing `temp` until zero.
1489                 temp := div(temp, 10)
1490             } {
1491                 // Body of the for loop.
1492                 ptr := sub(ptr, 1)
1493                 mstore8(ptr, add(48, mod(temp, 10)))
1494             }
1495 
1496             let length := sub(end, ptr)
1497             // Move the pointer 32 bytes leftwards to make room for the length.
1498             ptr := sub(ptr, 32)
1499             // Store the length.
1500             mstore(ptr, length)
1501         }
1502     }
1503 }
1504 
1505 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1506 
1507 
1508 // ERC721A Contracts v4.1.0
1509 // Creator: Chiru Labs
1510 
1511 pragma solidity ^0.8.4;
1512 
1513 
1514 /**
1515  * @dev Interface of an ERC721AQueryable compliant contract.
1516  */
1517 interface IERC721AQueryable is IERC721A {
1518     /**
1519      * Invalid query range (`start` >= `stop`).
1520      */
1521     error InvalidQueryRange();
1522 
1523     /**
1524      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1525      *
1526      * If the `tokenId` is out of bounds:
1527      *   - `addr` = `address(0)`
1528      *   - `startTimestamp` = `0`
1529      *   - `burned` = `false`
1530      *
1531      * If the `tokenId` is burned:
1532      *   - `addr` = `<Address of owner before token was burned>`
1533      *   - `startTimestamp` = `<Timestamp when token was burned>`
1534      *   - `burned = `true`
1535      *
1536      * Otherwise:
1537      *   - `addr` = `<Address of owner>`
1538      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1539      *   - `burned = `false`
1540      */
1541     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1542 
1543     /**
1544      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1545      * See {ERC721AQueryable-explicitOwnershipOf}
1546      */
1547     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1548 
1549     /**
1550      * @dev Returns an array of token IDs owned by `owner`,
1551      * in the range [`start`, `stop`)
1552      * (i.e. `start <= tokenId < stop`).
1553      *
1554      * This function allows for tokens to be queried if the collection
1555      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1556      *
1557      * Requirements:
1558      *
1559      * - `start` < `stop`
1560      */
1561     function tokensOfOwnerIn(
1562         address owner,
1563         uint256 start,
1564         uint256 stop
1565     ) external view returns (uint256[] memory);
1566 
1567     /**
1568      * @dev Returns an array of token IDs owned by `owner`.
1569      *
1570      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1571      * It is meant to be called off-chain.
1572      *
1573      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1574      * multiple smaller scans if the collection is large enough to cause
1575      * an out-of-gas error (10K pfp collections should be fine).
1576      */
1577     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1578 }
1579 
1580 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1581 
1582 
1583 // ERC721A Contracts v4.1.0
1584 // Creator: Chiru Labs
1585 
1586 pragma solidity ^0.8.4;
1587 
1588 
1589 
1590 /**
1591  * @title ERC721A Queryable
1592  * @dev ERC721A subclass with convenience query functions.
1593  */
1594 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1595     /**
1596      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1597      *
1598      * If the `tokenId` is out of bounds:
1599      *   - `addr` = `address(0)`
1600      *   - `startTimestamp` = `0`
1601      *   - `burned` = `false`
1602      *   - `extraData` = `0`
1603      *
1604      * If the `tokenId` is burned:
1605      *   - `addr` = `<Address of owner before token was burned>`
1606      *   - `startTimestamp` = `<Timestamp when token was burned>`
1607      *   - `burned = `true`
1608      *   - `extraData` = `<Extra data when token was burned>`
1609      *
1610      * Otherwise:
1611      *   - `addr` = `<Address of owner>`
1612      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1613      *   - `burned = `false`
1614      *   - `extraData` = `<Extra data at start of ownership>`
1615      */
1616     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1617         TokenOwnership memory ownership;
1618         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1619             return ownership;
1620         }
1621         ownership = _ownershipAt(tokenId);
1622         if (ownership.burned) {
1623             return ownership;
1624         }
1625         return _ownershipOf(tokenId);
1626     }
1627 
1628     /**
1629      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1630      * See {ERC721AQueryable-explicitOwnershipOf}
1631      */
1632     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1633         unchecked {
1634             uint256 tokenIdsLength = tokenIds.length;
1635             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1636             for (uint256 i; i != tokenIdsLength; ++i) {
1637                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1638             }
1639             return ownerships;
1640         }
1641     }
1642 
1643     /**
1644      * @dev Returns an array of token IDs owned by `owner`,
1645      * in the range [`start`, `stop`)
1646      * (i.e. `start <= tokenId < stop`).
1647      *
1648      * This function allows for tokens to be queried if the collection
1649      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1650      *
1651      * Requirements:
1652      *
1653      * - `start` < `stop`
1654      */
1655     function tokensOfOwnerIn(
1656         address owner,
1657         uint256 start,
1658         uint256 stop
1659     ) external view override returns (uint256[] memory) {
1660         unchecked {
1661             if (start >= stop) revert InvalidQueryRange();
1662             uint256 tokenIdsIdx;
1663             uint256 stopLimit = _nextTokenId();
1664             // Set `start = max(start, _startTokenId())`.
1665             if (start < _startTokenId()) {
1666                 start = _startTokenId();
1667             }
1668             // Set `stop = min(stop, stopLimit)`.
1669             if (stop > stopLimit) {
1670                 stop = stopLimit;
1671             }
1672             uint256 tokenIdsMaxLength = balanceOf(owner);
1673             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1674             // to cater for cases where `balanceOf(owner)` is too big.
1675             if (start < stop) {
1676                 uint256 rangeLength = stop - start;
1677                 if (rangeLength < tokenIdsMaxLength) {
1678                     tokenIdsMaxLength = rangeLength;
1679                 }
1680             } else {
1681                 tokenIdsMaxLength = 0;
1682             }
1683             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1684             if (tokenIdsMaxLength == 0) {
1685                 return tokenIds;
1686             }
1687             // We need to call `explicitOwnershipOf(start)`,
1688             // because the slot at `start` may not be initialized.
1689             TokenOwnership memory ownership = explicitOwnershipOf(start);
1690             address currOwnershipAddr;
1691             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1692             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1693             if (!ownership.burned) {
1694                 currOwnershipAddr = ownership.addr;
1695             }
1696             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1697                 ownership = _ownershipAt(i);
1698                 if (ownership.burned) {
1699                     continue;
1700                 }
1701                 if (ownership.addr != address(0)) {
1702                     currOwnershipAddr = ownership.addr;
1703                 }
1704                 if (currOwnershipAddr == owner) {
1705                     tokenIds[tokenIdsIdx++] = i;
1706                 }
1707             }
1708             // Downsize the array to fit.
1709             assembly {
1710                 mstore(tokenIds, tokenIdsIdx)
1711             }
1712             return tokenIds;
1713         }
1714     }
1715 
1716     /**
1717      * @dev Returns an array of token IDs owned by `owner`.
1718      *
1719      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1720      * It is meant to be called off-chain.
1721      *
1722      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1723      * multiple smaller scans if the collection is large enough to cause
1724      * an out-of-gas error (10K pfp collections should be fine).
1725      */
1726     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1727         unchecked {
1728             uint256 tokenIdsIdx;
1729             address currOwnershipAddr;
1730             uint256 tokenIdsLength = balanceOf(owner);
1731             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1732             TokenOwnership memory ownership;
1733             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1734                 ownership = _ownershipAt(i);
1735                 if (ownership.burned) {
1736                     continue;
1737                 }
1738                 if (ownership.addr != address(0)) {
1739                     currOwnershipAddr = ownership.addr;
1740                 }
1741                 if (currOwnershipAddr == owner) {
1742                     tokenIds[tokenIdsIdx++] = i;
1743                 }
1744             }
1745             return tokenIds;
1746         }
1747     }
1748 }
1749 
1750 
1751 
1752 pragma solidity >=0.8.9 <0.9.0;
1753 
1754 contract MoonDoodleApeBabyBukakiTownwtf is ERC721AQueryable, Ownable, ReentrancyGuard {
1755     using Strings for uint256;
1756 
1757     uint256 public maxSupply = 5522;
1758 	uint256 public Ownermint = 10;
1759     uint256 public maxPerAddress = 100;
1760 	uint256 public maxPerTX = 5;
1761     uint256 public cost = 0.003 ether;
1762 	mapping(address => bool) public freeMinted; 
1763 
1764     bool public paused = true;
1765 
1766 	string public uriPrefix = '';
1767     string public uriSuffix = '.json';
1768 	
1769   constructor(string memory baseURI) ERC721A("Moon Doodle Ape Baby Bukaki Town.WTF", "MDABBTWTF") {
1770       setUriPrefix(baseURI); 
1771       _safeMint(_msgSender(), Ownermint);
1772 
1773   }
1774 
1775   modifier callerIsUser() {
1776         require(tx.origin == msg.sender, "The caller is another contract");
1777         _;
1778   }
1779 
1780   function numberMinted(address owner) public view returns (uint256) {
1781         return _numberMinted(owner);
1782   }
1783 
1784   function mint(uint256 _mintAmount) public payable nonReentrant callerIsUser{
1785         require(!paused, 'The contract is paused!');
1786         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1787         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1788         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1789 	if (freeMinted[_msgSender()]){
1790         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1791   }
1792     else{
1793 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1794         freeMinted[_msgSender()] = true;
1795   }
1796 
1797     _safeMint(_msgSender(), _mintAmount);
1798   }
1799 
1800   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1801     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1802     string memory currentBaseURI = _baseURI();
1803     return bytes(currentBaseURI).length > 0
1804         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1805         : '';
1806   }
1807 
1808   function setPaused() public onlyOwner {
1809     paused = !paused;
1810   }
1811 
1812   function setCost(uint256 _cost) public onlyOwner {
1813     cost = _cost;
1814   }
1815 
1816   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1817     maxPerTX = _maxPerTX;
1818   }
1819 
1820   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1821     uriPrefix = _uriPrefix;
1822   }
1823  
1824   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1825     uriSuffix = _uriSuffix;
1826   }
1827 
1828   function withdraw() external onlyOwner {
1829         payable(msg.sender).transfer(address(this).balance);
1830   }
1831 
1832   function _startTokenId() internal view virtual override returns (uint256) {
1833     return 1;
1834   }
1835 
1836   function _baseURI() internal view virtual override returns (string memory) {
1837     return uriPrefix;
1838   }
1839 }