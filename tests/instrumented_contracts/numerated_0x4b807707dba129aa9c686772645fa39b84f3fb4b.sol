1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4  /** 
5 ___________    .___             
6 \_   _____/  __| _/ ____ ___.__.
7  |    __)_  / __ | / ___<   |  |
8  |        \/ /_/ |/ /_/  >___  |
9 /_______  /\____ |\___  // ____|
10         \/      \/_____/ \/     
11 
12   ___             
13  / _ \            
14 / /_\ \_ __   ___ 
15 |  _  | '_ \ / _ \
16 | | | | |_) |  __/
17 \_| |_/ .__/ \___|
18       | |         
19       |_|         
20 
21             .-'''-.                        
22            '   _    \                      
23          /   /` '.   \         .           
24   .--./).   |     \  '       .'|           
25  /.''\\ |   '      |  '  .| <  |           
26 | |  | |\    \     / / .' |_ | |           
27  \`-' /  `.   ` ..' /.'     || | .'''-.    
28  /("'`      '-...-'`'--.  .-'| |/.'''. \   
29  \ '---.               |  |  |  /    | |   
30   /'""'.\              |  |  | |     | |   
31  ||     ||             |  '.'| |     | |   
32  \'. __//              |   / | '.    | '.  
33   `'---'               `'-'  '---'   '---' 
34 
35    ________  ___       ___  ___  ________     
36 |\   ____\|\  \     |\  \|\  \|\   __  \    
37 \ \  \___|\ \  \    \ \  \\\  \ \  \|\ /_   
38  \ \  \    \ \  \    \ \  \\\  \ \   __  \  
39   \ \  \____\ \  \____\ \  \\\  \ \  \|\  \ 
40    \ \_______\ \_______\ \_______\ \_______\
41     \|_______|\|_______|\|_______|\|_______|
42                                                                                
43 */          
44 
45 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev Contract module that helps prevent reentrant calls to a function.
51  *
52  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
53  * available, which can be applied to functions to make sure there are no nested
54  * (reentrant) calls to them.
55  *
56  * Note that because there is a single `nonReentrant` guard, functions marked as
57  * `nonReentrant` may not call one another. This can be worked around by making
58  * those functions `private`, and then adding `external` `nonReentrant` entry
59  * points to them.
60  *
61  * TIP: If you would like to learn more about reentrancy and alternative ways
62  * to protect against it, check out our blog post
63  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
64  */
65 abstract contract ReentrancyGuard {
66     // Booleans are more expensive than uint256 or any type that takes up a full
67     // word because each write operation emits an extra SLOAD to first read the
68     // slot's contents, replace the bits taken up by the boolean, and then write
69     // back. This is the compiler's defense against contract upgrades and
70     // pointer aliasing, and it cannot be disabled.
71 
72     // The values being non-zero value makes deployment a bit more expensive,
73     // but in exchange the refund on every call to nonReentrant will be lower in
74     // amount. Since refunds are capped to a percentage of the total
75     // transaction's gas, it is best to keep them low in cases like this one, to
76     // increase the likelihood of the full refund coming into effect.
77     uint256 private constant _NOT_ENTERED = 1;
78     uint256 private constant _ENTERED = 2;
79 
80     uint256 private _status;
81 
82     constructor() {
83         _status = _NOT_ENTERED;
84     }
85 
86     /**
87      * @dev Prevents a contract from calling itself, directly or indirectly.
88      * Calling a `nonReentrant` function from another `nonReentrant`
89      * function is not supported. It is possible to prevent this from happening
90      * by making the `nonReentrant` function external, and making it call a
91      * `private` function that does the actual work.
92      */
93     modifier nonReentrant() {
94         // On the first call to nonReentrant, _notEntered will be true
95         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
96 
97         // Any calls to nonReentrant after this point will fail
98         _status = _ENTERED;
99 
100         _;
101 
102         // By storing the original value once again, a refund is triggered (see
103         // https://eips.ethereum.org/EIPS/eip-2200)
104         _status = _NOT_ENTERED;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/utils/Strings.sol
109 
110 
111 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev String operations.
117  */
118 library Strings {
119     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
120     uint8 private constant _ADDRESS_LENGTH = 20;
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
124      */
125     function toString(uint256 value) internal pure returns (string memory) {
126         // Inspired by OraclizeAPI's implementation - MIT licence
127         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
128 
129         if (value == 0) {
130             return "0";
131         }
132         uint256 temp = value;
133         uint256 digits;
134         while (temp != 0) {
135             digits++;
136             temp /= 10;
137         }
138         bytes memory buffer = new bytes(digits);
139         while (value != 0) {
140             digits -= 1;
141             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
142             value /= 10;
143         }
144         return string(buffer);
145     }
146 
147     /**
148      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
149      */
150     function toHexString(uint256 value) internal pure returns (string memory) {
151         if (value == 0) {
152             return "0x00";
153         }
154         uint256 temp = value;
155         uint256 length = 0;
156         while (temp != 0) {
157             length++;
158             temp >>= 8;
159         }
160         return toHexString(value, length);
161     }
162 
163     /**
164      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
165      */
166     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
167         bytes memory buffer = new bytes(2 * length + 2);
168         buffer[0] = "0";
169         buffer[1] = "x";
170         for (uint256 i = 2 * length + 1; i > 1; --i) {
171             buffer[i] = _HEX_SYMBOLS[value & 0xf];
172             value >>= 4;
173         }
174         require(value == 0, "Strings: hex length insufficient");
175         return string(buffer);
176     }
177 
178     /**
179      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
180      */
181     function toHexString(address addr) internal pure returns (string memory) {
182         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
183     }
184 }
185 
186 
187 // File: @openzeppelin/contracts/utils/Context.sol
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Provides information about the current execution context, including the
196  * sender of the transaction and its data. While these are generally available
197  * via msg.sender and msg.data, they should not be accessed in such a direct
198  * manner, since when dealing with meta-transactions the account sending and
199  * paying for execution may not be the actual sender (as far as an application
200  * is concerned).
201  *
202  * This contract is only required for intermediate, library-like contracts.
203  */
204 abstract contract Context {
205     function _msgSender() internal view virtual returns (address) {
206         return msg.sender;
207     }
208 
209     function _msgData() internal view virtual returns (bytes calldata) {
210         return msg.data;
211     }
212 }
213 
214 // File: @openzeppelin/contracts/access/Ownable.sol
215 
216 
217 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 
222 /**
223  * @dev Contract module which provides a basic access control mechanism, where
224  * there is an account (an owner) that can be granted exclusive access to
225  * specific functions.
226  *
227  * By default, the owner account will be the one that deploys the contract. This
228  * can later be changed with {transferOwnership}.
229  *
230  * This module is used through inheritance. It will make available the modifier
231  * `onlyOwner`, which can be applied to your functions to restrict their use to
232  * the owner.
233  */
234 abstract contract Ownable is Context {
235     address private _owner;
236 
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     /**
240      * @dev Initializes the contract setting the deployer as the initial owner.
241      */
242     constructor() {
243         _transferOwnership(_msgSender());
244     }
245 
246     /**
247      * @dev Throws if called by any account other than the owner.
248      */
249     modifier onlyOwner() {
250         _checkOwner();
251         _;
252     }
253 
254     /**
255      * @dev Returns the address of the current owner.
256      */
257     function owner() public view virtual returns (address) {
258         return _owner;
259     }
260 
261     /**
262      * @dev Throws if the sender is not the owner.
263      */
264     function _checkOwner() internal view virtual {
265         require(owner() == _msgSender(), "Ownable: caller is not the owner");
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() public virtual onlyOwner {
276         _transferOwnership(address(0));
277     }
278 
279     /**
280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
281      * Can only be called by the current owner.
282      */
283     function transferOwnership(address newOwner) public virtual onlyOwner {
284         require(newOwner != address(0), "Ownable: new owner is the zero address");
285         _transferOwnership(newOwner);
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      * Internal function without access restriction.
291      */
292     function _transferOwnership(address newOwner) internal virtual {
293         address oldOwner = _owner;
294         _owner = newOwner;
295         emit OwnershipTransferred(oldOwner, newOwner);
296     }
297 }
298 
299 // File: erc721a/contracts/IERC721A.sol
300 
301 
302 // ERC721A Contracts v4.1.0
303 // Creator: Chiru Labs
304 
305 pragma solidity ^0.8.4;
306 
307 /**
308  * @dev Interface of an ERC721A compliant contract.
309  */
310 interface IERC721A {
311     /**
312      * The caller must own the token or be an approved operator.
313      */
314     error ApprovalCallerNotOwnerNorApproved();
315 
316     /**
317      * The token does not exist.
318      */
319     error ApprovalQueryForNonexistentToken();
320 
321     /**
322      * The caller cannot approve to their own address.
323      */
324     error ApproveToCaller();
325 
326     /**
327      * Cannot query the balance for the zero address.
328      */
329     error BalanceQueryForZeroAddress();
330 
331     /**
332      * Cannot mint to the zero address.
333      */
334     error MintToZeroAddress();
335 
336     /**
337      * The quantity of tokens minted must be more than zero.
338      */
339     error MintZeroQuantity();
340 
341     /**
342      * The token does not exist.
343      */
344     error OwnerQueryForNonexistentToken();
345 
346     /**
347      * The caller must own the token or be an approved operator.
348      */
349     error TransferCallerNotOwnerNorApproved();
350 
351     /**
352      * The token must be owned by `from`.
353      */
354     error TransferFromIncorrectOwner();
355 
356     /**
357      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
358      */
359     error TransferToNonERC721ReceiverImplementer();
360 
361     /**
362      * Cannot transfer to the zero address.
363      */
364     error TransferToZeroAddress();
365 
366     /**
367      * The token does not exist.
368      */
369     error URIQueryForNonexistentToken();
370 
371     /**
372      * The `quantity` minted with ERC2309 exceeds the safety limit.
373      */
374     error MintERC2309QuantityExceedsLimit();
375 
376     /**
377      * The `extraData` cannot be set on an unintialized ownership slot.
378      */
379     error OwnershipNotInitializedForExtraData();
380 
381     struct TokenOwnership {
382         // The address of the owner.
383         address addr;
384         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
385         uint64 startTimestamp;
386         // Whether the token has been burned.
387         bool burned;
388         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
389         uint24 extraData;
390     }
391 
392     /**
393      * @dev Returns the total amount of tokens stored by the contract.
394      *
395      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
396      */
397     function totalSupply() external view returns (uint256);
398 
399     // ==============================
400     //            IERC165
401     // ==============================
402 
403     /**
404      * @dev Returns true if this contract implements the interface defined by
405      * `interfaceId`. See the corresponding
406      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
407      * to learn more about how these ids are created.
408      *
409      * This function call must use less than 30 000 gas.
410      */
411     function supportsInterface(bytes4 interfaceId) external view returns (bool);
412 
413     // ==============================
414     //            IERC721
415     // ==============================
416 
417     /**
418      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
419      */
420     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
421 
422     /**
423      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
424      */
425     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
426 
427     /**
428      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
429      */
430     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
431 
432     /**
433      * @dev Returns the number of tokens in ``owner``'s account.
434      */
435     function balanceOf(address owner) external view returns (uint256 balance);
436 
437     /**
438      * @dev Returns the owner of the `tokenId` token.
439      *
440      * Requirements:
441      *
442      * - `tokenId` must exist.
443      */
444     function ownerOf(uint256 tokenId) external view returns (address owner);
445 
446     /**
447      * @dev Safely transfers `tokenId` token from `from` to `to`.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `tokenId` token must exist and be owned by `from`.
454      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
455      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
456      *
457      * Emits a {Transfer} event.
458      */
459     function safeTransferFrom(
460         address from,
461         address to,
462         uint256 tokenId,
463         bytes calldata data
464     ) external;
465 
466     /**
467      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
468      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
469      *
470      * Requirements:
471      *
472      * - `from` cannot be the zero address.
473      * - `to` cannot be the zero address.
474      * - `tokenId` token must exist and be owned by `from`.
475      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
476      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
477      *
478      * Emits a {Transfer} event.
479      */
480     function safeTransferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Transfers `tokenId` token from `from` to `to`.
488      *
489      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must be owned by `from`.
496      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
497      *
498      * Emits a {Transfer} event.
499      */
500     function transferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     /**
507      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
508      * The approval is cleared when the token is transferred.
509      *
510      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
511      *
512      * Requirements:
513      *
514      * - The caller must own the token or be an approved operator.
515      * - `tokenId` must exist.
516      *
517      * Emits an {Approval} event.
518      */
519     function approve(address to, uint256 tokenId) external;
520 
521     /**
522      * @dev Approve or remove `operator` as an operator for the caller.
523      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
524      *
525      * Requirements:
526      *
527      * - The `operator` cannot be the caller.
528      *
529      * Emits an {ApprovalForAll} event.
530      */
531     function setApprovalForAll(address operator, bool _approved) external;
532 
533     /**
534      * @dev Returns the account approved for `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function getApproved(uint256 tokenId) external view returns (address operator);
541 
542     /**
543      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
544      *
545      * See {setApprovalForAll}
546      */
547     function isApprovedForAll(address owner, address operator) external view returns (bool);
548 
549     // ==============================
550     //        IERC721Metadata
551     // ==============================
552 
553     /**
554      * @dev Returns the token collection name.
555      */
556     function name() external view returns (string memory);
557 
558     /**
559      * @dev Returns the token collection symbol.
560      */
561     function symbol() external view returns (string memory);
562 
563     /**
564      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
565      */
566     function tokenURI(uint256 tokenId) external view returns (string memory);
567 
568     // ==============================
569     //            IERC2309
570     // ==============================
571 
572     /**
573      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
574      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
575      */
576     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
577 }
578 
579 // File: erc721a/contracts/ERC721A.sol
580 
581 
582 // ERC721A Contracts v4.1.0
583 // Creator: Chiru Labs
584 
585 pragma solidity ^0.8.4;
586 
587 
588 /**
589  * @dev ERC721 token receiver interface.
590  */
591 interface ERC721A__IERC721Receiver {
592     function onERC721Received(
593         address operator,
594         address from,
595         uint256 tokenId,
596         bytes calldata data
597     ) external returns (bytes4);
598 }
599 
600 /**
601  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
602  * including the Metadata extension. Built to optimize for lower gas during batch mints.
603  *
604  * Assumes serials are sequentially minted starting at `_startTokenId()`
605  * (defaults to 0, e.g. 0, 1, 2, 3..).
606  *
607  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
608  *
609  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
610  */
611 contract ERC721A is IERC721A {
612     // Mask of an entry in packed address data.
613     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
614 
615     // The bit position of `numberMinted` in packed address data.
616     uint256 private constant BITPOS_NUMBER_MINTED = 64;
617 
618     // The bit position of `numberBurned` in packed address data.
619     uint256 private constant BITPOS_NUMBER_BURNED = 128;
620 
621     // The bit position of `aux` in packed address data.
622     uint256 private constant BITPOS_AUX = 192;
623 
624     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
625     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
626 
627     // The bit position of `startTimestamp` in packed ownership.
628     uint256 private constant BITPOS_START_TIMESTAMP = 160;
629 
630     // The bit mask of the `burned` bit in packed ownership.
631     uint256 private constant BITMASK_BURNED = 1 << 224;
632 
633     // The bit position of the `nextInitialized` bit in packed ownership.
634     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
635 
636     // The bit mask of the `nextInitialized` bit in packed ownership.
637     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
638 
639     // The bit position of `extraData` in packed ownership.
640     uint256 private constant BITPOS_EXTRA_DATA = 232;
641 
642     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
643     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
644 
645     // The mask of the lower 160 bits for addresses.
646     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
647 
648     // The maximum `quantity` that can be minted with `_mintERC2309`.
649     // This limit is to prevent overflows on the address data entries.
650     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
651     // is required to cause an overflow, which is unrealistic.
652     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
653 
654     // The tokenId of the next token to be minted.
655     uint256 private _currentIndex;
656 
657     // The number of tokens burned.
658     uint256 private _burnCounter;
659 
660     // Token name
661     string private _name;
662 
663     // Token symbol
664     string private _symbol;
665 
666     // Mapping from token ID to ownership details
667     // An empty struct value does not necessarily mean the token is unowned.
668     // See `_packedOwnershipOf` implementation for details.
669     //
670     // Bits Layout:
671     // - [0..159]   `addr`
672     // - [160..223] `startTimestamp`
673     // - [224]      `burned`
674     // - [225]      `nextInitialized`
675     // - [232..255] `extraData`
676     mapping(uint256 => uint256) private _packedOwnerships;
677 
678     // Mapping owner address to address data.
679     //
680     // Bits Layout:
681     // - [0..63]    `balance`
682     // - [64..127]  `numberMinted`
683     // - [128..191] `numberBurned`
684     // - [192..255] `aux`
685     mapping(address => uint256) private _packedAddressData;
686 
687     // Mapping from token ID to approved address.
688     mapping(uint256 => address) private _tokenApprovals;
689 
690     // Mapping from owner to operator approvals
691     mapping(address => mapping(address => bool)) private _operatorApprovals;
692 
693     constructor(string memory name_, string memory symbol_) {
694         _name = name_;
695         _symbol = symbol_;
696         _currentIndex = _startTokenId();
697     }
698 
699     /**
700      * @dev Returns the starting token ID.
701      * To change the starting token ID, please override this function.
702      */
703     function _startTokenId() internal view virtual returns (uint256) {
704         return 0;
705     }
706 
707     /**
708      * @dev Returns the next token ID to be minted.
709      */
710     function _nextTokenId() internal view returns (uint256) {
711         return _currentIndex;
712     }
713 
714     /**
715      * @dev Returns the total number of tokens in existence.
716      * Burned tokens will reduce the count.
717      * To get the total number of tokens minted, please see `_totalMinted`.
718      */
719     function totalSupply() public view override returns (uint256) {
720         // Counter underflow is impossible as _burnCounter cannot be incremented
721         // more than `_currentIndex - _startTokenId()` times.
722         unchecked {
723             return _currentIndex - _burnCounter - _startTokenId();
724         }
725     }
726 
727     /**
728      * @dev Returns the total amount of tokens minted in the contract.
729      */
730     function _totalMinted() internal view returns (uint256) {
731         // Counter underflow is impossible as _currentIndex does not decrement,
732         // and it is initialized to `_startTokenId()`
733         unchecked {
734             return _currentIndex - _startTokenId();
735         }
736     }
737 
738     /**
739      * @dev Returns the total number of tokens burned.
740      */
741     function _totalBurned() internal view returns (uint256) {
742         return _burnCounter;
743     }
744 
745     /**
746      * @dev See {IERC165-supportsInterface}.
747      */
748     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
749         // The interface IDs are constants representing the first 4 bytes of the XOR of
750         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
751         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
752         return
753             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
754             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
755             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
756     }
757 
758     /**
759      * @dev See {IERC721-balanceOf}.
760      */
761     function balanceOf(address owner) public view override returns (uint256) {
762         if (owner == address(0)) revert BalanceQueryForZeroAddress();
763         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
764     }
765 
766     /**
767      * Returns the number of tokens minted by `owner`.
768      */
769     function _numberMinted(address owner) internal view returns (uint256) {
770         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
771     }
772 
773     /**
774      * Returns the number of tokens burned by or on behalf of `owner`.
775      */
776     function _numberBurned(address owner) internal view returns (uint256) {
777         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
778     }
779 
780     /**
781      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
782      */
783     function _getAux(address owner) internal view returns (uint64) {
784         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
785     }
786 
787     /**
788      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
789      * If there are multiple variables, please pack them into a uint64.
790      */
791     function _setAux(address owner, uint64 aux) internal {
792         uint256 packed = _packedAddressData[owner];
793         uint256 auxCasted;
794         // Cast `aux` with assembly to avoid redundant masking.
795         assembly {
796             auxCasted := aux
797         }
798         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
799         _packedAddressData[owner] = packed;
800     }
801 
802     /**
803      * Returns the packed ownership data of `tokenId`.
804      */
805     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
806         uint256 curr = tokenId;
807 
808         unchecked {
809             if (_startTokenId() <= curr)
810                 if (curr < _currentIndex) {
811                     uint256 packed = _packedOwnerships[curr];
812                     // If not burned.
813                     if (packed & BITMASK_BURNED == 0) {
814                         // Invariant:
815                         // There will always be an ownership that has an address and is not burned
816                         // before an ownership that does not have an address and is not burned.
817                         // Hence, curr will not underflow.
818                         //
819                         // We can directly compare the packed value.
820                         // If the address is zero, packed is zero.
821                         while (packed == 0) {
822                             packed = _packedOwnerships[--curr];
823                         }
824                         return packed;
825                     }
826                 }
827         }
828         revert OwnerQueryForNonexistentToken();
829     }
830 
831     /**
832      * Returns the unpacked `TokenOwnership` struct from `packed`.
833      */
834     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
835         ownership.addr = address(uint160(packed));
836         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
837         ownership.burned = packed & BITMASK_BURNED != 0;
838         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
839     }
840 
841     /**
842      * Returns the unpacked `TokenOwnership` struct at `index`.
843      */
844     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
845         return _unpackedOwnership(_packedOwnerships[index]);
846     }
847 
848     /**
849      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
850      */
851     function _initializeOwnershipAt(uint256 index) internal {
852         if (_packedOwnerships[index] == 0) {
853             _packedOwnerships[index] = _packedOwnershipOf(index);
854         }
855     }
856 
857     /**
858      * Gas spent here starts off proportional to the maximum mint batch size.
859      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
860      */
861     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
862         return _unpackedOwnership(_packedOwnershipOf(tokenId));
863     }
864 
865     /**
866      * @dev Packs ownership data into a single uint256.
867      */
868     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
869         assembly {
870             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
871             owner := and(owner, BITMASK_ADDRESS)
872             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
873             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
874         }
875     }
876 
877     /**
878      * @dev See {IERC721-ownerOf}.
879      */
880     function ownerOf(uint256 tokenId) public view override returns (address) {
881         return address(uint160(_packedOwnershipOf(tokenId)));
882     }
883 
884     /**
885      * @dev See {IERC721Metadata-name}.
886      */
887     function name() public view virtual override returns (string memory) {
888         return _name;
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-symbol}.
893      */
894     function symbol() public view virtual override returns (string memory) {
895         return _symbol;
896     }
897 
898     /**
899      * @dev See {IERC721Metadata-tokenURI}.
900      */
901     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
902         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
903 
904         string memory baseURI = _baseURI();
905         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
906     }
907 
908     /**
909      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
910      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
911      * by default, it can be overridden in child contracts.
912      */
913     function _baseURI() internal view virtual returns (string memory) {
914         return '';
915     }
916 
917     /**
918      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
919      */
920     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
921         // For branchless setting of the `nextInitialized` flag.
922         assembly {
923             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
924             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
925         }
926     }
927 
928     /**
929      * @dev See {IERC721-approve}.
930      */
931     function approve(address to, uint256 tokenId) public override {
932         address owner = ownerOf(tokenId);
933 
934         if (_msgSenderERC721A() != owner)
935             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
936                 revert ApprovalCallerNotOwnerNorApproved();
937             }
938 
939         _tokenApprovals[tokenId] = to;
940         emit Approval(owner, to, tokenId);
941     }
942 
943     /**
944      * @dev See {IERC721-getApproved}.
945      */
946     function getApproved(uint256 tokenId) public view override returns (address) {
947         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
948 
949         return _tokenApprovals[tokenId];
950     }
951 
952     /**
953      * @dev See {IERC721-setApprovalForAll}.
954      */
955     function setApprovalForAll(address operator, bool approved) public virtual override {
956         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
957 
958         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
959         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
960     }
961 
962     /**
963      * @dev See {IERC721-isApprovedForAll}.
964      */
965     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
966         return _operatorApprovals[owner][operator];
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         safeTransferFrom(from, to, tokenId, '');
978     }
979 
980     /**
981      * @dev See {IERC721-safeTransferFrom}.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) public virtual override {
989         transferFrom(from, to, tokenId);
990         if (to.code.length != 0)
991             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
992                 revert TransferToNonERC721ReceiverImplementer();
993             }
994     }
995 
996     /**
997      * @dev Returns whether `tokenId` exists.
998      *
999      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1000      *
1001      * Tokens start existing when they are minted (`_mint`),
1002      */
1003     function _exists(uint256 tokenId) internal view returns (bool) {
1004         return
1005             _startTokenId() <= tokenId &&
1006             tokenId < _currentIndex && // If within bounds,
1007             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1008     }
1009 
1010     /**
1011      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1012      */
1013     function _safeMint(address to, uint256 quantity) internal {
1014         _safeMint(to, quantity, '');
1015     }
1016 
1017     /**
1018      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - If `to` refers to a smart contract, it must implement
1023      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1024      * - `quantity` must be greater than 0.
1025      *
1026      * See {_mint}.
1027      *
1028      * Emits a {Transfer} event for each mint.
1029      */
1030     function _safeMint(
1031         address to,
1032         uint256 quantity,
1033         bytes memory _data
1034     ) internal {
1035         _mint(to, quantity);
1036 
1037         unchecked {
1038             if (to.code.length != 0) {
1039                 uint256 end = _currentIndex;
1040                 uint256 index = end - quantity;
1041                 do {
1042                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1043                         revert TransferToNonERC721ReceiverImplementer();
1044                     }
1045                 } while (index < end);
1046                 // Reentrancy protection.
1047                 if (_currentIndex != end) revert();
1048             }
1049         }
1050     }
1051 
1052     /**
1053      * @dev Mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - `to` cannot be the zero address.
1058      * - `quantity` must be greater than 0.
1059      *
1060      * Emits a {Transfer} event for each mint.
1061      */
1062     function _mint(address to, uint256 quantity) internal {
1063         uint256 startTokenId = _currentIndex;
1064         if (to == address(0)) revert MintToZeroAddress();
1065         if (quantity == 0) revert MintZeroQuantity();
1066 
1067         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1068 
1069         // Overflows are incredibly unrealistic.
1070         // `balance` and `numberMinted` have a maximum limit of 2**64.
1071         // `tokenId` has a maximum limit of 2**256.
1072         unchecked {
1073             // Updates:
1074             // - `balance += quantity`.
1075             // - `numberMinted += quantity`.
1076             //
1077             // We can directly add to the `balance` and `numberMinted`.
1078             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1079 
1080             // Updates:
1081             // - `address` to the owner.
1082             // - `startTimestamp` to the timestamp of minting.
1083             // - `burned` to `false`.
1084             // - `nextInitialized` to `quantity == 1`.
1085             _packedOwnerships[startTokenId] = _packOwnershipData(
1086                 to,
1087                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1088             );
1089 
1090             uint256 tokenId = startTokenId;
1091             uint256 end = startTokenId + quantity;
1092             do {
1093                 emit Transfer(address(0), to, tokenId++);
1094             } while (tokenId < end);
1095 
1096             _currentIndex = end;
1097         }
1098         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1099     }
1100 
1101     /**
1102      * @dev Mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * This function is intended for efficient minting only during contract creation.
1105      *
1106      * It emits only one {ConsecutiveTransfer} as defined in
1107      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1108      * instead of a sequence of {Transfer} event(s).
1109      *
1110      * Calling this function outside of contract creation WILL make your contract
1111      * non-compliant with the ERC721 standard.
1112      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1113      * {ConsecutiveTransfer} event is only permissible during contract creation.
1114      *
1115      * Requirements:
1116      *
1117      * - `to` cannot be the zero address.
1118      * - `quantity` must be greater than 0.
1119      *
1120      * Emits a {ConsecutiveTransfer} event.
1121      */
1122     function _mintERC2309(address to, uint256 quantity) internal {
1123         uint256 startTokenId = _currentIndex;
1124         if (to == address(0)) revert MintToZeroAddress();
1125         if (quantity == 0) revert MintZeroQuantity();
1126         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1127 
1128         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1129 
1130         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1131         unchecked {
1132             // Updates:
1133             // - `balance += quantity`.
1134             // - `numberMinted += quantity`.
1135             //
1136             // We can directly add to the `balance` and `numberMinted`.
1137             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1138 
1139             // Updates:
1140             // - `address` to the owner.
1141             // - `startTimestamp` to the timestamp of minting.
1142             // - `burned` to `false`.
1143             // - `nextInitialized` to `quantity == 1`.
1144             _packedOwnerships[startTokenId] = _packOwnershipData(
1145                 to,
1146                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1147             );
1148 
1149             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1150 
1151             _currentIndex = startTokenId + quantity;
1152         }
1153         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1154     }
1155 
1156     /**
1157      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1158      */
1159     function _getApprovedAddress(uint256 tokenId)
1160         private
1161         view
1162         returns (uint256 approvedAddressSlot, address approvedAddress)
1163     {
1164         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1165         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1166         assembly {
1167             // Compute the slot.
1168             mstore(0x00, tokenId)
1169             mstore(0x20, tokenApprovalsPtr.slot)
1170             approvedAddressSlot := keccak256(0x00, 0x40)
1171             // Load the slot's value from storage.
1172             approvedAddress := sload(approvedAddressSlot)
1173         }
1174     }
1175 
1176     /**
1177      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1178      */
1179     function _isOwnerOrApproved(
1180         address approvedAddress,
1181         address from,
1182         address msgSender
1183     ) private pure returns (bool result) {
1184         assembly {
1185             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1186             from := and(from, BITMASK_ADDRESS)
1187             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1188             msgSender := and(msgSender, BITMASK_ADDRESS)
1189             // `msgSender == from || msgSender == approvedAddress`.
1190             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1191         }
1192     }
1193 
1194     /**
1195      * @dev Transfers `tokenId` from `from` to `to`.
1196      *
1197      * Requirements:
1198      *
1199      * - `to` cannot be the zero address.
1200      * - `tokenId` token must be owned by `from`.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function transferFrom(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) public virtual override {
1209         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1210 
1211         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1212 
1213         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1214 
1215         // The nested ifs save around 20+ gas over a compound boolean condition.
1216         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1217             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1218 
1219         if (to == address(0)) revert TransferToZeroAddress();
1220 
1221         _beforeTokenTransfers(from, to, tokenId, 1);
1222 
1223         // Clear approvals from the previous owner.
1224         assembly {
1225             if approvedAddress {
1226                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1227                 sstore(approvedAddressSlot, 0)
1228             }
1229         }
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1234         unchecked {
1235             // We can directly increment and decrement the balances.
1236             --_packedAddressData[from]; // Updates: `balance -= 1`.
1237             ++_packedAddressData[to]; // Updates: `balance += 1`.
1238 
1239             // Updates:
1240             // - `address` to the next owner.
1241             // - `startTimestamp` to the timestamp of transfering.
1242             // - `burned` to `false`.
1243             // - `nextInitialized` to `true`.
1244             _packedOwnerships[tokenId] = _packOwnershipData(
1245                 to,
1246                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1247             );
1248 
1249             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1250             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1251                 uint256 nextTokenId = tokenId + 1;
1252                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1253                 if (_packedOwnerships[nextTokenId] == 0) {
1254                     // If the next slot is within bounds.
1255                     if (nextTokenId != _currentIndex) {
1256                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1257                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1258                     }
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(from, to, tokenId);
1264         _afterTokenTransfers(from, to, tokenId, 1);
1265     }
1266 
1267     /**
1268      * @dev Equivalent to `_burn(tokenId, false)`.
1269      */
1270     function _burn(uint256 tokenId) internal virtual {
1271         _burn(tokenId, false);
1272     }
1273 
1274     /**
1275      * @dev Destroys `tokenId`.
1276      * The approval is cleared when the token is burned.
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must exist.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1285         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1286 
1287         address from = address(uint160(prevOwnershipPacked));
1288 
1289         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1290 
1291         if (approvalCheck) {
1292             // The nested ifs save around 20+ gas over a compound boolean condition.
1293             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1294                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1295         }
1296 
1297         _beforeTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Clear approvals from the previous owner.
1300         assembly {
1301             if approvedAddress {
1302                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1303                 sstore(approvedAddressSlot, 0)
1304             }
1305         }
1306 
1307         // Underflow of the sender's balance is impossible because we check for
1308         // ownership above and the recipient's balance can't realistically overflow.
1309         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1310         unchecked {
1311             // Updates:
1312             // - `balance -= 1`.
1313             // - `numberBurned += 1`.
1314             //
1315             // We can directly decrement the balance, and increment the number burned.
1316             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1317             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1318 
1319             // Updates:
1320             // - `address` to the last owner.
1321             // - `startTimestamp` to the timestamp of burning.
1322             // - `burned` to `true`.
1323             // - `nextInitialized` to `true`.
1324             _packedOwnerships[tokenId] = _packOwnershipData(
1325                 from,
1326                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1327             );
1328 
1329             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1330             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1331                 uint256 nextTokenId = tokenId + 1;
1332                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1333                 if (_packedOwnerships[nextTokenId] == 0) {
1334                     // If the next slot is within bounds.
1335                     if (nextTokenId != _currentIndex) {
1336                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1337                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1338                     }
1339                 }
1340             }
1341         }
1342 
1343         emit Transfer(from, address(0), tokenId);
1344         _afterTokenTransfers(from, address(0), tokenId, 1);
1345 
1346         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1347         unchecked {
1348             _burnCounter++;
1349         }
1350     }
1351 
1352     /**
1353      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1354      *
1355      * @param from address representing the previous owner of the given token ID
1356      * @param to target address that will receive the tokens
1357      * @param tokenId uint256 ID of the token to be transferred
1358      * @param _data bytes optional data to send along with the call
1359      * @return bool whether the call correctly returned the expected magic value
1360      */
1361     function _checkContractOnERC721Received(
1362         address from,
1363         address to,
1364         uint256 tokenId,
1365         bytes memory _data
1366     ) private returns (bool) {
1367         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1368             bytes4 retval
1369         ) {
1370             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1371         } catch (bytes memory reason) {
1372             if (reason.length == 0) {
1373                 revert TransferToNonERC721ReceiverImplementer();
1374             } else {
1375                 assembly {
1376                     revert(add(32, reason), mload(reason))
1377                 }
1378             }
1379         }
1380     }
1381 
1382     /**
1383      * @dev Directly sets the extra data for the ownership data `index`.
1384      */
1385     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1386         uint256 packed = _packedOwnerships[index];
1387         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1388         uint256 extraDataCasted;
1389         // Cast `extraData` with assembly to avoid redundant masking.
1390         assembly {
1391             extraDataCasted := extraData
1392         }
1393         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1394         _packedOwnerships[index] = packed;
1395     }
1396 
1397     /**
1398      * @dev Returns the next extra data for the packed ownership data.
1399      * The returned result is shifted into position.
1400      */
1401     function _nextExtraData(
1402         address from,
1403         address to,
1404         uint256 prevOwnershipPacked
1405     ) private view returns (uint256) {
1406         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1407         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1408     }
1409 
1410     /**
1411      * @dev Called during each token transfer to set the 24bit `extraData` field.
1412      * Intended to be overridden by the cosumer contract.
1413      *
1414      * `previousExtraData` - the value of `extraData` before transfer.
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` will be minted for `to`.
1421      * - When `to` is zero, `tokenId` will be burned by `from`.
1422      * - `from` and `to` are never both zero.
1423      */
1424     function _extraData(
1425         address from,
1426         address to,
1427         uint24 previousExtraData
1428     ) internal view virtual returns (uint24) {}
1429 
1430     /**
1431      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1432      * This includes minting.
1433      * And also called before burning one token.
1434      *
1435      * startTokenId - the first token id to be transferred
1436      * quantity - the amount to be transferred
1437      *
1438      * Calling conditions:
1439      *
1440      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1441      * transferred to `to`.
1442      * - When `from` is zero, `tokenId` will be minted for `to`.
1443      * - When `to` is zero, `tokenId` will be burned by `from`.
1444      * - `from` and `to` are never both zero.
1445      */
1446     function _beforeTokenTransfers(
1447         address from,
1448         address to,
1449         uint256 startTokenId,
1450         uint256 quantity
1451     ) internal virtual {}
1452 
1453     /**
1454      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1455      * This includes minting.
1456      * And also called after one token has been burned.
1457      *
1458      * startTokenId - the first token id to be transferred
1459      * quantity - the amount to be transferred
1460      *
1461      * Calling conditions:
1462      *
1463      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1464      * transferred to `to`.
1465      * - When `from` is zero, `tokenId` has been minted for `to`.
1466      * - When `to` is zero, `tokenId` has been burned by `from`.
1467      * - `from` and `to` are never both zero.
1468      */
1469     function _afterTokenTransfers(
1470         address from,
1471         address to,
1472         uint256 startTokenId,
1473         uint256 quantity
1474     ) internal virtual {}
1475 
1476     /**
1477      * @dev Returns the message sender (defaults to `msg.sender`).
1478      *
1479      * If you are writing GSN compatible contracts, you need to override this function.
1480      */
1481     function _msgSenderERC721A() internal view virtual returns (address) {
1482         return msg.sender;
1483     }
1484 
1485     /**
1486      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1487      */
1488     function _toString(uint256 value) internal pure returns (string memory ptr) {
1489         assembly {
1490             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1491             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1492             // We will need 1 32-byte word to store the length,
1493             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1494             ptr := add(mload(0x40), 128)
1495             // Update the free memory pointer to allocate.
1496             mstore(0x40, ptr)
1497 
1498             // Cache the end of the memory to calculate the length later.
1499             let end := ptr
1500 
1501             // We write the string from the rightmost digit to the leftmost digit.
1502             // The following is essentially a do-while loop that also handles the zero case.
1503             // Costs a bit more than early returning for the zero case,
1504             // but cheaper in terms of deployment and overall runtime costs.
1505             for {
1506                 // Initialize and perform the first pass without check.
1507                 let temp := value
1508                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1509                 ptr := sub(ptr, 1)
1510                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1511                 mstore8(ptr, add(48, mod(temp, 10)))
1512                 temp := div(temp, 10)
1513             } temp {
1514                 // Keep dividing `temp` until zero.
1515                 temp := div(temp, 10)
1516             } {
1517                 // Body of the for loop.
1518                 ptr := sub(ptr, 1)
1519                 mstore8(ptr, add(48, mod(temp, 10)))
1520             }
1521 
1522             let length := sub(end, ptr)
1523             // Move the pointer 32 bytes leftwards to make room for the length.
1524             ptr := sub(ptr, 32)
1525             // Store the length.
1526             mstore(ptr, length)
1527         }
1528     }
1529 }
1530 
1531 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1532 
1533 
1534 // ERC721A Contracts v4.1.0
1535 // Creator: Chiru Labs
1536 
1537 pragma solidity ^0.8.4;
1538 
1539 
1540 /**
1541  * @dev Interface of an ERC721AQueryable compliant contract.
1542  */
1543 interface IERC721AQueryable is IERC721A {
1544     /**
1545      * Invalid query range (`start` >= `stop`).
1546      */
1547     error InvalidQueryRange();
1548 
1549     /**
1550      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1551      *
1552      * If the `tokenId` is out of bounds:
1553      *   - `addr` = `address(0)`
1554      *   - `startTimestamp` = `0`
1555      *   - `burned` = `false`
1556      *
1557      * If the `tokenId` is burned:
1558      *   - `addr` = `<Address of owner before token was burned>`
1559      *   - `startTimestamp` = `<Timestamp when token was burned>`
1560      *   - `burned = `true`
1561      *
1562      * Otherwise:
1563      *   - `addr` = `<Address of owner>`
1564      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1565      *   - `burned = `false`
1566      */
1567     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1568 
1569     /**
1570      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1571      * See {ERC721AQueryable-explicitOwnershipOf}
1572      */
1573     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1574 
1575     /**
1576      * @dev Returns an array of token IDs owned by `owner`,
1577      * in the range [`start`, `stop`)
1578      * (i.e. `start <= tokenId < stop`).
1579      *
1580      * This function allows for tokens to be queried if the collection
1581      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1582      *
1583      * Requirements:
1584      *
1585      * - `start` < `stop`
1586      */
1587     function tokensOfOwnerIn(
1588         address owner,
1589         uint256 start,
1590         uint256 stop
1591     ) external view returns (uint256[] memory);
1592 
1593     /**
1594      * @dev Returns an array of token IDs owned by `owner`.
1595      *
1596      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1597      * It is meant to be called off-chain.
1598      *
1599      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1600      * multiple smaller scans if the collection is large enough to cause
1601      * an out-of-gas error (10K pfp collections should be fine).
1602      */
1603     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1604 }
1605 
1606 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1607 
1608 
1609 // ERC721A Contracts v4.1.0
1610 // Creator: Chiru Labs
1611 
1612 pragma solidity ^0.8.4;
1613 
1614 
1615 
1616 /**
1617  * @title ERC721A Queryable
1618  * @dev ERC721A subclass with convenience query functions.
1619  */
1620 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1621     /**
1622      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1623      *
1624      * If the `tokenId` is out of bounds:
1625      *   - `addr` = `address(0)`
1626      *   - `startTimestamp` = `0`
1627      *   - `burned` = `false`
1628      *   - `extraData` = `0`
1629      *
1630      * If the `tokenId` is burned:
1631      *   - `addr` = `<Address of owner before token was burned>`
1632      *   - `startTimestamp` = `<Timestamp when token was burned>`
1633      *   - `burned = `true`
1634      *   - `extraData` = `<Extra data when token was burned>`
1635      *
1636      * Otherwise:
1637      *   - `addr` = `<Address of owner>`
1638      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1639      *   - `burned = `false`
1640      *   - `extraData` = `<Extra data at start of ownership>`
1641      */
1642     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1643         TokenOwnership memory ownership;
1644         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1645             return ownership;
1646         }
1647         ownership = _ownershipAt(tokenId);
1648         if (ownership.burned) {
1649             return ownership;
1650         }
1651         return _ownershipOf(tokenId);
1652     }
1653 
1654     /**
1655      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1656      * See {ERC721AQueryable-explicitOwnershipOf}
1657      */
1658     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1659         unchecked {
1660             uint256 tokenIdsLength = tokenIds.length;
1661             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1662             for (uint256 i; i != tokenIdsLength; ++i) {
1663                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1664             }
1665             return ownerships;
1666         }
1667     }
1668 
1669     /**
1670      * @dev Returns an array of token IDs owned by `owner`,
1671      * in the range [`start`, `stop`)
1672      * (i.e. `start <= tokenId < stop`).
1673      *
1674      * This function allows for tokens to be queried if the collection
1675      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1676      *
1677      * Requirements:
1678      *
1679      * - `start` < `stop`
1680      */
1681     function tokensOfOwnerIn(
1682         address owner,
1683         uint256 start,
1684         uint256 stop
1685     ) external view override returns (uint256[] memory) {
1686         unchecked {
1687             if (start >= stop) revert InvalidQueryRange();
1688             uint256 tokenIdsIdx;
1689             uint256 stopLimit = _nextTokenId();
1690             // Set `start = max(start, _startTokenId())`.
1691             if (start < _startTokenId()) {
1692                 start = _startTokenId();
1693             }
1694             // Set `stop = min(stop, stopLimit)`.
1695             if (stop > stopLimit) {
1696                 stop = stopLimit;
1697             }
1698             uint256 tokenIdsMaxLength = balanceOf(owner);
1699             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1700             // to cater for cases where `balanceOf(owner)` is too big.
1701             if (start < stop) {
1702                 uint256 rangeLength = stop - start;
1703                 if (rangeLength < tokenIdsMaxLength) {
1704                     tokenIdsMaxLength = rangeLength;
1705                 }
1706             } else {
1707                 tokenIdsMaxLength = 0;
1708             }
1709             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1710             if (tokenIdsMaxLength == 0) {
1711                 return tokenIds;
1712             }
1713             // We need to call `explicitOwnershipOf(start)`,
1714             // because the slot at `start` may not be initialized.
1715             TokenOwnership memory ownership = explicitOwnershipOf(start);
1716             address currOwnershipAddr;
1717             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1718             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1719             if (!ownership.burned) {
1720                 currOwnershipAddr = ownership.addr;
1721             }
1722             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1723                 ownership = _ownershipAt(i);
1724                 if (ownership.burned) {
1725                     continue;
1726                 }
1727                 if (ownership.addr != address(0)) {
1728                     currOwnershipAddr = ownership.addr;
1729                 }
1730                 if (currOwnershipAddr == owner) {
1731                     tokenIds[tokenIdsIdx++] = i;
1732                 }
1733             }
1734             // Downsize the array to fit.
1735             assembly {
1736                 mstore(tokenIds, tokenIdsIdx)
1737             }
1738             return tokenIds;
1739         }
1740     }
1741 
1742     /**
1743      * @dev Returns an array of token IDs owned by `owner`.
1744      *
1745      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1746      * It is meant to be called off-chain.
1747      *
1748      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1749      * multiple smaller scans if the collection is large enough to cause
1750      * an out-of-gas error (10K pfp collections should be fine).
1751      */
1752     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1753         unchecked {
1754             uint256 tokenIdsIdx;
1755             address currOwnershipAddr;
1756             uint256 tokenIdsLength = balanceOf(owner);
1757             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1758             TokenOwnership memory ownership;
1759             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1760                 ownership = _ownershipAt(i);
1761                 if (ownership.burned) {
1762                     continue;
1763                 }
1764                 if (ownership.addr != address(0)) {
1765                     currOwnershipAddr = ownership.addr;
1766                 }
1767                 if (currOwnershipAddr == owner) {
1768                     tokenIds[tokenIdsIdx++] = i;
1769                 }
1770             }
1771             return tokenIds;
1772         }
1773     }
1774 }
1775 
1776 
1777 
1778 pragma solidity >=0.8.9 <0.9.0;
1779 
1780 contract Edgyapegothclub is ERC721AQueryable, Ownable, ReentrancyGuard {
1781     using Strings for uint256;
1782 
1783     uint256 public maxSupply = 10000;
1784 	uint256 public Ownermint = 1;
1785     uint256 public maxPerAddress = 666;
1786 	uint256 public maxPerTX = 10;
1787     uint256 public cost = 0.001 ether;
1788 	mapping(address => bool) public freeMinted; 
1789 
1790     bool public paused = true;
1791 
1792 	string public uriPrefix = '';
1793     string public uriSuffix = '.json';
1794 	
1795   constructor(string memory baseURI) ERC721A("Edgy Ape Goth Club", "EAGC") {
1796       setUriPrefix(baseURI); 
1797       _safeMint(_msgSender(), Ownermint);
1798 
1799   }
1800 
1801   modifier callerIsUser() {
1802         require(tx.origin == msg.sender, "The caller is another contract");
1803         _;
1804   }
1805 
1806   function numberMinted(address owner) public view returns (uint256) {
1807         return _numberMinted(owner);
1808   }
1809 
1810   function Joingothclub (uint256 _mintAmount) public payable nonReentrant callerIsUser{
1811         require(!paused, 'The contract is paused!');
1812         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1813         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1814         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1815 	if (freeMinted[_msgSender()]){
1816         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1817   }
1818     else{
1819 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1820         freeMinted[_msgSender()] = true;
1821   }
1822 
1823     _safeMint(_msgSender(), _mintAmount);
1824   }
1825 
1826   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1827     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1828     string memory currentBaseURI = _baseURI();
1829     return bytes(currentBaseURI).length > 0
1830         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1831         : '';
1832   }
1833 
1834   function unpause() public onlyOwner {
1835     paused = !paused;
1836   }
1837 
1838   function setCost(uint256 _cost) public onlyOwner {
1839     cost = _cost;
1840   }
1841 
1842   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1843     maxPerTX = _maxPerTX;
1844   }
1845 
1846   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1847     uriPrefix = _uriPrefix;
1848   }
1849  
1850   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1851     uriSuffix = _uriSuffix;
1852   }
1853 
1854   function withdraw() external onlyOwner {
1855         payable(msg.sender).transfer(address(this).balance);
1856   }
1857 
1858   function _startTokenId() internal view virtual override returns (uint256) {
1859     return 1;
1860   }
1861 
1862   function _baseURI() internal view virtual override returns (string memory) {
1863     return uriPrefix;
1864   }
1865 }