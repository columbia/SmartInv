1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4                                       >=>   
5               >=>          >=>        >=>   
6 >=>   >=>   >=>  >=>     >=>  >=>   >=>>==> 
7  >=> >=>  >=>     >=>  >=>     >=>    >=>   
8    >==>   >=>      >=> >=>      >=>   >=>   
9     >=>    >=>    >=>   >=>    >=>    >=>   
10    >=>       >==>         >==>         >=>  
11  >=>                                        
12 >=======>>=>          >=>                   
13        >=>            >=>       >>          
14       >=>    >=>  >=> >=>  >=>              
15     >=>      >=>  >=> >=> >=>  >=>          
16    >=>       >=>  >=> >=>=>    >=>          
17  >=>         >=>  >=> >=> >=>  >=>          
18 >==========>   >==>=> >=>  >=> >=>          
19                                                                                                                                                               
20 */
21 
22 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Contract module that helps prevent reentrant calls to a function.
28  *
29  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
30  * available, which can be applied to functions to make sure there are no nested
31  * (reentrant) calls to them.
32  *
33  * Note that because there is a single `nonReentrant` guard, functions marked as
34  * `nonReentrant` may not call one another. This can be worked around by making
35  * those functions `private`, and then adding `external` `nonReentrant` entry
36  * points to them.
37  *
38  * TIP: If you would like to learn more about reentrancy and alternative ways
39  * to protect against it, check out our blog post
40  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
41  */
42 abstract contract ReentrancyGuard {
43     // Booleans are more expensive than uint256 or any type that takes up a full
44     // word because each write operation emits an extra SLOAD to first read the
45     // slot's contents, replace the bits taken up by the boolean, and then write
46     // back. This is the compiler's defense against contract upgrades and
47     // pointer aliasing, and it cannot be disabled.
48 
49     // The values being non-zero value makes deployment a bit more expensive,
50     // but in exchange the refund on every call to nonReentrant will be lower in
51     // amount. Since refunds are capped to a percentage of the total
52     // transaction's gas, it is best to keep them low in cases like this one, to
53     // increase the likelihood of the full refund coming into effect.
54     uint256 private constant _NOT_ENTERED = 1;
55     uint256 private constant _ENTERED = 2;
56 
57     uint256 private _status;
58 
59     constructor() {
60         _status = _NOT_ENTERED;
61     }
62 
63     /**
64      * @dev Prevents a contract from calling itself, directly or indirectly.
65      * Calling a `nonReentrant` function from another `nonReentrant`
66      * function is not supported. It is possible to prevent this from happening
67      * by making the `nonReentrant` function external, and making it call a
68      * `private` function that does the actual work.
69      */
70     modifier nonReentrant() {
71         // On the first call to nonReentrant, _notEntered will be true
72         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
73 
74         // Any calls to nonReentrant after this point will fail
75         _status = _ENTERED;
76 
77         _;
78 
79         // By storing the original value once again, a refund is triggered (see
80         // https://eips.ethereum.org/EIPS/eip-2200)
81         _status = _NOT_ENTERED;
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Strings.sol
86 
87 
88 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev String operations.
94  */
95 library Strings {
96     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
97     uint8 private constant _ADDRESS_LENGTH = 20;
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
101      */
102     function toString(uint256 value) internal pure returns (string memory) {
103         // Inspired by OraclizeAPI's implementation - MIT licence
104         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
105 
106         if (value == 0) {
107             return "0";
108         }
109         uint256 temp = value;
110         uint256 digits;
111         while (temp != 0) {
112             digits++;
113             temp /= 10;
114         }
115         bytes memory buffer = new bytes(digits);
116         while (value != 0) {
117             digits -= 1;
118             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
119             value /= 10;
120         }
121         return string(buffer);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
126      */
127     function toHexString(uint256 value) internal pure returns (string memory) {
128         if (value == 0) {
129             return "0x00";
130         }
131         uint256 temp = value;
132         uint256 length = 0;
133         while (temp != 0) {
134             length++;
135             temp >>= 8;
136         }
137         return toHexString(value, length);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
142      */
143     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
144         bytes memory buffer = new bytes(2 * length + 2);
145         buffer[0] = "0";
146         buffer[1] = "x";
147         for (uint256 i = 2 * length + 1; i > 1; --i) {
148             buffer[i] = _HEX_SYMBOLS[value & 0xf];
149             value >>= 4;
150         }
151         require(value == 0, "Strings: hex length insufficient");
152         return string(buffer);
153     }
154 
155     /**
156      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
157      */
158     function toHexString(address addr) internal pure returns (string memory) {
159         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
160     }
161 }
162 
163 
164 // File: @openzeppelin/contracts/utils/Context.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev Provides information about the current execution context, including the
173  * sender of the transaction and its data. While these are generally available
174  * via msg.sender and msg.data, they should not be accessed in such a direct
175  * manner, since when dealing with meta-transactions the account sending and
176  * paying for execution may not be the actual sender (as far as an application
177  * is concerned).
178  *
179  * This contract is only required for intermediate, library-like contracts.
180  */
181 abstract contract Context {
182     function _msgSender() internal view virtual returns (address) {
183         return msg.sender;
184     }
185 
186     function _msgData() internal view virtual returns (bytes calldata) {
187         return msg.data;
188     }
189 }
190 
191 // File: @openzeppelin/contracts/access/Ownable.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @dev Contract module which provides a basic access control mechanism, where
201  * there is an account (an owner) that can be granted exclusive access to
202  * specific functions.
203  *
204  * By default, the owner account will be the one that deploys the contract. This
205  * can later be changed with {transferOwnership}.
206  *
207  * This module is used through inheritance. It will make available the modifier
208  * `onlyOwner`, which can be applied to your functions to restrict their use to
209  * the owner.
210  */
211 abstract contract Ownable is Context {
212     address private _owner;
213 
214     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
215 
216     /**
217      * @dev Initializes the contract setting the deployer as the initial owner.
218      */
219     constructor() {
220         _transferOwnership(_msgSender());
221     }
222 
223     /**
224      * @dev Throws if called by any account other than the owner.
225      */
226     modifier onlyOwner() {
227         _checkOwner();
228         _;
229     }
230 
231     /**
232      * @dev Returns the address of the current owner.
233      */
234     function owner() public view virtual returns (address) {
235         return _owner;
236     }
237 
238     /**
239      * @dev Throws if the sender is not the owner.
240      */
241     function _checkOwner() internal view virtual {
242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
243     }
244 
245     /**
246      * @dev Leaves the contract without owner. It will not be possible to call
247      * `onlyOwner` functions anymore. Can only be called by the current owner.
248      *
249      * NOTE: Renouncing ownership will leave the contract without an owner,
250      * thereby removing any functionality that is only available to the owner.
251      */
252     function renounceOwnership() public virtual onlyOwner {
253         _transferOwnership(address(0));
254     }
255 
256     /**
257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
258      * Can only be called by the current owner.
259      */
260     function transferOwnership(address newOwner) public virtual onlyOwner {
261         require(newOwner != address(0), "Ownable: new owner is the zero address");
262         _transferOwnership(newOwner);
263     }
264 
265     /**
266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
267      * Internal function without access restriction.
268      */
269     function _transferOwnership(address newOwner) internal virtual {
270         address oldOwner = _owner;
271         _owner = newOwner;
272         emit OwnershipTransferred(oldOwner, newOwner);
273     }
274 }
275 
276 // File: erc721a/contracts/IERC721A.sol
277 
278 
279 // ERC721A Contracts v4.1.0
280 // Creator: Chiru Labs
281 
282 pragma solidity ^0.8.4;
283 
284 /**
285  * @dev Interface of an ERC721A compliant contract.
286  */
287 interface IERC721A {
288     /**
289      * The caller must own the token or be an approved operator.
290      */
291     error ApprovalCallerNotOwnerNorApproved();
292 
293     /**
294      * The token does not exist.
295      */
296     error ApprovalQueryForNonexistentToken();
297 
298     /**
299      * The caller cannot approve to their own address.
300      */
301     error ApproveToCaller();
302 
303     /**
304      * Cannot query the balance for the zero address.
305      */
306     error BalanceQueryForZeroAddress();
307 
308     /**
309      * Cannot mint to the zero address.
310      */
311     error MintToZeroAddress();
312 
313     /**
314      * The quantity of tokens minted must be more than zero.
315      */
316     error MintZeroQuantity();
317 
318     /**
319      * The token does not exist.
320      */
321     error OwnerQueryForNonexistentToken();
322 
323     /**
324      * The caller must own the token or be an approved operator.
325      */
326     error TransferCallerNotOwnerNorApproved();
327 
328     /**
329      * The token must be owned by `from`.
330      */
331     error TransferFromIncorrectOwner();
332 
333     /**
334      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
335      */
336     error TransferToNonERC721ReceiverImplementer();
337 
338     /**
339      * Cannot transfer to the zero address.
340      */
341     error TransferToZeroAddress();
342 
343     /**
344      * The token does not exist.
345      */
346     error URIQueryForNonexistentToken();
347 
348     /**
349      * The `quantity` minted with ERC2309 exceeds the safety limit.
350      */
351     error MintERC2309QuantityExceedsLimit();
352 
353     /**
354      * The `extraData` cannot be set on an unintialized ownership slot.
355      */
356     error OwnershipNotInitializedForExtraData();
357 
358     struct TokenOwnership {
359         // The address of the owner.
360         address addr;
361         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
362         uint64 startTimestamp;
363         // Whether the token has been burned.
364         bool burned;
365         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
366         uint24 extraData;
367     }
368 
369     /**
370      * @dev Returns the total amount of tokens stored by the contract.
371      *
372      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     // ==============================
377     //            IERC165
378     // ==============================
379 
380     /**
381      * @dev Returns true if this contract implements the interface defined by
382      * `interfaceId`. See the corresponding
383      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
384      * to learn more about how these ids are created.
385      *
386      * This function call must use less than 30 000 gas.
387      */
388     function supportsInterface(bytes4 interfaceId) external view returns (bool);
389 
390     // ==============================
391     //            IERC721
392     // ==============================
393 
394     /**
395      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
401      */
402     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
406      */
407     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
408 
409     /**
410      * @dev Returns the number of tokens in ``owner``'s account.
411      */
412     function balanceOf(address owner) external view returns (uint256 balance);
413 
414     /**
415      * @dev Returns the owner of the `tokenId` token.
416      *
417      * Requirements:
418      *
419      * - `tokenId` must exist.
420      */
421     function ownerOf(uint256 tokenId) external view returns (address owner);
422 
423     /**
424      * @dev Safely transfers `tokenId` token from `from` to `to`.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must exist and be owned by `from`.
431      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
433      *
434      * Emits a {Transfer} event.
435      */
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId,
440         bytes calldata data
441     ) external;
442 
443     /**
444      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
445      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must exist and be owned by `from`.
452      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
454      *
455      * Emits a {Transfer} event.
456      */
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) external;
462 
463     /**
464      * @dev Transfers `tokenId` token from `from` to `to`.
465      *
466      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must be owned by `from`.
473      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
474      *
475      * Emits a {Transfer} event.
476      */
477     function transferFrom(
478         address from,
479         address to,
480         uint256 tokenId
481     ) external;
482 
483     /**
484      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
485      * The approval is cleared when the token is transferred.
486      *
487      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
488      *
489      * Requirements:
490      *
491      * - The caller must own the token or be an approved operator.
492      * - `tokenId` must exist.
493      *
494      * Emits an {Approval} event.
495      */
496     function approve(address to, uint256 tokenId) external;
497 
498     /**
499      * @dev Approve or remove `operator` as an operator for the caller.
500      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
501      *
502      * Requirements:
503      *
504      * - The `operator` cannot be the caller.
505      *
506      * Emits an {ApprovalForAll} event.
507      */
508     function setApprovalForAll(address operator, bool _approved) external;
509 
510     /**
511      * @dev Returns the account approved for `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function getApproved(uint256 tokenId) external view returns (address operator);
518 
519     /**
520      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
521      *
522      * See {setApprovalForAll}
523      */
524     function isApprovedForAll(address owner, address operator) external view returns (bool);
525 
526     // ==============================
527     //        IERC721Metadata
528     // ==============================
529 
530     /**
531      * @dev Returns the token collection name.
532      */
533     function name() external view returns (string memory);
534 
535     /**
536      * @dev Returns the token collection symbol.
537      */
538     function symbol() external view returns (string memory);
539 
540     /**
541      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
542      */
543     function tokenURI(uint256 tokenId) external view returns (string memory);
544 
545     // ==============================
546     //            IERC2309
547     // ==============================
548 
549     /**
550      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
551      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
552      */
553     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
554 }
555 
556 // File: erc721a/contracts/ERC721A.sol
557 
558 
559 // ERC721A Contracts v4.1.0
560 // Creator: Chiru Labs
561 
562 pragma solidity ^0.8.4;
563 
564 
565 /**
566  * @dev ERC721 token receiver interface.
567  */
568 interface ERC721A__IERC721Receiver {
569     function onERC721Received(
570         address operator,
571         address from,
572         uint256 tokenId,
573         bytes calldata data
574     ) external returns (bytes4);
575 }
576 
577 /**
578  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
579  * including the Metadata extension. Built to optimize for lower gas during batch mints.
580  *
581  * Assumes serials are sequentially minted starting at `_startTokenId()`
582  * (defaults to 0, e.g. 0, 1, 2, 3..).
583  *
584  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
585  *
586  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
587  */
588 contract ERC721A is IERC721A {
589     // Mask of an entry in packed address data.
590     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
591 
592     // The bit position of `numberMinted` in packed address data.
593     uint256 private constant BITPOS_NUMBER_MINTED = 64;
594 
595     // The bit position of `numberBurned` in packed address data.
596     uint256 private constant BITPOS_NUMBER_BURNED = 128;
597 
598     // The bit position of `aux` in packed address data.
599     uint256 private constant BITPOS_AUX = 192;
600 
601     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
602     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
603 
604     // The bit position of `startTimestamp` in packed ownership.
605     uint256 private constant BITPOS_START_TIMESTAMP = 160;
606 
607     // The bit mask of the `burned` bit in packed ownership.
608     uint256 private constant BITMASK_BURNED = 1 << 224;
609 
610     // The bit position of the `nextInitialized` bit in packed ownership.
611     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
612 
613     // The bit mask of the `nextInitialized` bit in packed ownership.
614     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
615 
616     // The bit position of `extraData` in packed ownership.
617     uint256 private constant BITPOS_EXTRA_DATA = 232;
618 
619     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
620     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
621 
622     // The mask of the lower 160 bits for addresses.
623     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
624 
625     // The maximum `quantity` that can be minted with `_mintERC2309`.
626     // This limit is to prevent overflows on the address data entries.
627     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
628     // is required to cause an overflow, which is unrealistic.
629     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
630 
631     // The tokenId of the next token to be minted.
632     uint256 private _currentIndex;
633 
634     // The number of tokens burned.
635     uint256 private _burnCounter;
636 
637     // Token name
638     string private _name;
639 
640     // Token symbol
641     string private _symbol;
642 
643     // Mapping from token ID to ownership details
644     // An empty struct value does not necessarily mean the token is unowned.
645     // See `_packedOwnershipOf` implementation for details.
646     //
647     // Bits Layout:
648     // - [0..159]   `addr`
649     // - [160..223] `startTimestamp`
650     // - [224]      `burned`
651     // - [225]      `nextInitialized`
652     // - [232..255] `extraData`
653     mapping(uint256 => uint256) private _packedOwnerships;
654 
655     // Mapping owner address to address data.
656     //
657     // Bits Layout:
658     // - [0..63]    `balance`
659     // - [64..127]  `numberMinted`
660     // - [128..191] `numberBurned`
661     // - [192..255] `aux`
662     mapping(address => uint256) private _packedAddressData;
663 
664     // Mapping from token ID to approved address.
665     mapping(uint256 => address) private _tokenApprovals;
666 
667     // Mapping from owner to operator approvals
668     mapping(address => mapping(address => bool)) private _operatorApprovals;
669 
670     constructor(string memory name_, string memory symbol_) {
671         _name = name_;
672         _symbol = symbol_;
673         _currentIndex = _startTokenId();
674     }
675 
676     /**
677      * @dev Returns the starting token ID.
678      * To change the starting token ID, please override this function.
679      */
680     function _startTokenId() internal view virtual returns (uint256) {
681         return 0;
682     }
683 
684     /**
685      * @dev Returns the next token ID to be minted.
686      */
687     function _nextTokenId() internal view returns (uint256) {
688         return _currentIndex;
689     }
690 
691     /**
692      * @dev Returns the total number of tokens in existence.
693      * Burned tokens will reduce the count.
694      * To get the total number of tokens minted, please see `_totalMinted`.
695      */
696     function totalSupply() public view override returns (uint256) {
697         // Counter underflow is impossible as _burnCounter cannot be incremented
698         // more than `_currentIndex - _startTokenId()` times.
699         unchecked {
700             return _currentIndex - _burnCounter - _startTokenId();
701         }
702     }
703 
704     /**
705      * @dev Returns the total amount of tokens minted in the contract.
706      */
707     function _totalMinted() internal view returns (uint256) {
708         // Counter underflow is impossible as _currentIndex does not decrement,
709         // and it is initialized to `_startTokenId()`
710         unchecked {
711             return _currentIndex - _startTokenId();
712         }
713     }
714 
715     /**
716      * @dev Returns the total number of tokens burned.
717      */
718     function _totalBurned() internal view returns (uint256) {
719         return _burnCounter;
720     }
721 
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
726         // The interface IDs are constants representing the first 4 bytes of the XOR of
727         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
728         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
729         return
730             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
731             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
732             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
733     }
734 
735     /**
736      * @dev See {IERC721-balanceOf}.
737      */
738     function balanceOf(address owner) public view override returns (uint256) {
739         if (owner == address(0)) revert BalanceQueryForZeroAddress();
740         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
741     }
742 
743     /**
744      * Returns the number of tokens minted by `owner`.
745      */
746     function _numberMinted(address owner) internal view returns (uint256) {
747         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
748     }
749 
750     /**
751      * Returns the number of tokens burned by or on behalf of `owner`.
752      */
753     function _numberBurned(address owner) internal view returns (uint256) {
754         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
755     }
756 
757     /**
758      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
759      */
760     function _getAux(address owner) internal view returns (uint64) {
761         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
762     }
763 
764     /**
765      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
766      * If there are multiple variables, please pack them into a uint64.
767      */
768     function _setAux(address owner, uint64 aux) internal {
769         uint256 packed = _packedAddressData[owner];
770         uint256 auxCasted;
771         // Cast `aux` with assembly to avoid redundant masking.
772         assembly {
773             auxCasted := aux
774         }
775         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
776         _packedAddressData[owner] = packed;
777     }
778 
779     /**
780      * Returns the packed ownership data of `tokenId`.
781      */
782     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
783         uint256 curr = tokenId;
784 
785         unchecked {
786             if (_startTokenId() <= curr)
787                 if (curr < _currentIndex) {
788                     uint256 packed = _packedOwnerships[curr];
789                     // If not burned.
790                     if (packed & BITMASK_BURNED == 0) {
791                         // Invariant:
792                         // There will always be an ownership that has an address and is not burned
793                         // before an ownership that does not have an address and is not burned.
794                         // Hence, curr will not underflow.
795                         //
796                         // We can directly compare the packed value.
797                         // If the address is zero, packed is zero.
798                         while (packed == 0) {
799                             packed = _packedOwnerships[--curr];
800                         }
801                         return packed;
802                     }
803                 }
804         }
805         revert OwnerQueryForNonexistentToken();
806     }
807 
808     /**
809      * Returns the unpacked `TokenOwnership` struct from `packed`.
810      */
811     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
812         ownership.addr = address(uint160(packed));
813         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
814         ownership.burned = packed & BITMASK_BURNED != 0;
815         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
816     }
817 
818     /**
819      * Returns the unpacked `TokenOwnership` struct at `index`.
820      */
821     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
822         return _unpackedOwnership(_packedOwnerships[index]);
823     }
824 
825     /**
826      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
827      */
828     function _initializeOwnershipAt(uint256 index) internal {
829         if (_packedOwnerships[index] == 0) {
830             _packedOwnerships[index] = _packedOwnershipOf(index);
831         }
832     }
833 
834     /**
835      * Gas spent here starts off proportional to the maximum mint batch size.
836      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
837      */
838     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
839         return _unpackedOwnership(_packedOwnershipOf(tokenId));
840     }
841 
842     /**
843      * @dev Packs ownership data into a single uint256.
844      */
845     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
846         assembly {
847             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
848             owner := and(owner, BITMASK_ADDRESS)
849             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
850             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
851         }
852     }
853 
854     /**
855      * @dev See {IERC721-ownerOf}.
856      */
857     function ownerOf(uint256 tokenId) public view override returns (address) {
858         return address(uint160(_packedOwnershipOf(tokenId)));
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-name}.
863      */
864     function name() public view virtual override returns (string memory) {
865         return _name;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-symbol}.
870      */
871     function symbol() public view virtual override returns (string memory) {
872         return _symbol;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-tokenURI}.
877      */
878     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
879         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
880 
881         string memory baseURI = _baseURI();
882         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
883     }
884 
885     /**
886      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
887      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
888      * by default, it can be overridden in child contracts.
889      */
890     function _baseURI() internal view virtual returns (string memory) {
891         return '';
892     }
893 
894     /**
895      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
896      */
897     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
898         // For branchless setting of the `nextInitialized` flag.
899         assembly {
900             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
901             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
902         }
903     }
904 
905     /**
906      * @dev See {IERC721-approve}.
907      */
908     function approve(address to, uint256 tokenId) public override {
909         address owner = ownerOf(tokenId);
910 
911         if (_msgSenderERC721A() != owner)
912             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
913                 revert ApprovalCallerNotOwnerNorApproved();
914             }
915 
916         _tokenApprovals[tokenId] = to;
917         emit Approval(owner, to, tokenId);
918     }
919 
920     /**
921      * @dev See {IERC721-getApproved}.
922      */
923     function getApproved(uint256 tokenId) public view override returns (address) {
924         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
925 
926         return _tokenApprovals[tokenId];
927     }
928 
929     /**
930      * @dev See {IERC721-setApprovalForAll}.
931      */
932     function setApprovalForAll(address operator, bool approved) public virtual override {
933         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
934 
935         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
936         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
937     }
938 
939     /**
940      * @dev See {IERC721-isApprovedForAll}.
941      */
942     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
943         return _operatorApprovals[owner][operator];
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) public virtual override {
954         safeTransferFrom(from, to, tokenId, '');
955     }
956 
957     /**
958      * @dev See {IERC721-safeTransferFrom}.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) public virtual override {
966         transferFrom(from, to, tokenId);
967         if (to.code.length != 0)
968             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
969                 revert TransferToNonERC721ReceiverImplementer();
970             }
971     }
972 
973     /**
974      * @dev Returns whether `tokenId` exists.
975      *
976      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
977      *
978      * Tokens start existing when they are minted (`_mint`),
979      */
980     function _exists(uint256 tokenId) internal view returns (bool) {
981         return
982             _startTokenId() <= tokenId &&
983             tokenId < _currentIndex && // If within bounds,
984             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
985     }
986 
987     /**
988      * @dev Equivalent to `_safeMint(to, quantity, '')`.
989      */
990     function _safeMint(address to, uint256 quantity) internal {
991         _safeMint(to, quantity, '');
992     }
993 
994     /**
995      * @dev Safely mints `quantity` tokens and transfers them to `to`.
996      *
997      * Requirements:
998      *
999      * - If `to` refers to a smart contract, it must implement
1000      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1001      * - `quantity` must be greater than 0.
1002      *
1003      * See {_mint}.
1004      *
1005      * Emits a {Transfer} event for each mint.
1006      */
1007     function _safeMint(
1008         address to,
1009         uint256 quantity,
1010         bytes memory _data
1011     ) internal {
1012         _mint(to, quantity);
1013 
1014         unchecked {
1015             if (to.code.length != 0) {
1016                 uint256 end = _currentIndex;
1017                 uint256 index = end - quantity;
1018                 do {
1019                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1020                         revert TransferToNonERC721ReceiverImplementer();
1021                     }
1022                 } while (index < end);
1023                 // Reentrancy protection.
1024                 if (_currentIndex != end) revert();
1025             }
1026         }
1027     }
1028 
1029     /**
1030      * @dev Mints `quantity` tokens and transfers them to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - `to` cannot be the zero address.
1035      * - `quantity` must be greater than 0.
1036      *
1037      * Emits a {Transfer} event for each mint.
1038      */
1039     function _mint(address to, uint256 quantity) internal {
1040         uint256 startTokenId = _currentIndex;
1041         if (to == address(0)) revert MintToZeroAddress();
1042         if (quantity == 0) revert MintZeroQuantity();
1043 
1044         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1045 
1046         // Overflows are incredibly unrealistic.
1047         // `balance` and `numberMinted` have a maximum limit of 2**64.
1048         // `tokenId` has a maximum limit of 2**256.
1049         unchecked {
1050             // Updates:
1051             // - `balance += quantity`.
1052             // - `numberMinted += quantity`.
1053             //
1054             // We can directly add to the `balance` and `numberMinted`.
1055             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1056 
1057             // Updates:
1058             // - `address` to the owner.
1059             // - `startTimestamp` to the timestamp of minting.
1060             // - `burned` to `false`.
1061             // - `nextInitialized` to `quantity == 1`.
1062             _packedOwnerships[startTokenId] = _packOwnershipData(
1063                 to,
1064                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1065             );
1066 
1067             uint256 tokenId = startTokenId;
1068             uint256 end = startTokenId + quantity;
1069             do {
1070                 emit Transfer(address(0), to, tokenId++);
1071             } while (tokenId < end);
1072 
1073             _currentIndex = end;
1074         }
1075         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1076     }
1077 
1078     /**
1079      * @dev Mints `quantity` tokens and transfers them to `to`.
1080      *
1081      * This function is intended for efficient minting only during contract creation.
1082      *
1083      * It emits only one {ConsecutiveTransfer} as defined in
1084      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1085      * instead of a sequence of {Transfer} event(s).
1086      *
1087      * Calling this function outside of contract creation WILL make your contract
1088      * non-compliant with the ERC721 standard.
1089      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1090      * {ConsecutiveTransfer} event is only permissible during contract creation.
1091      *
1092      * Requirements:
1093      *
1094      * - `to` cannot be the zero address.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {ConsecutiveTransfer} event.
1098      */
1099     function _mintERC2309(address to, uint256 quantity) internal {
1100         uint256 startTokenId = _currentIndex;
1101         if (to == address(0)) revert MintToZeroAddress();
1102         if (quantity == 0) revert MintZeroQuantity();
1103         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1104 
1105         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1106 
1107         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1108         unchecked {
1109             // Updates:
1110             // - `balance += quantity`.
1111             // - `numberMinted += quantity`.
1112             //
1113             // We can directly add to the `balance` and `numberMinted`.
1114             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1115 
1116             // Updates:
1117             // - `address` to the owner.
1118             // - `startTimestamp` to the timestamp of minting.
1119             // - `burned` to `false`.
1120             // - `nextInitialized` to `quantity == 1`.
1121             _packedOwnerships[startTokenId] = _packOwnershipData(
1122                 to,
1123                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1124             );
1125 
1126             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1127 
1128             _currentIndex = startTokenId + quantity;
1129         }
1130         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1131     }
1132 
1133     /**
1134      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1135      */
1136     function _getApprovedAddress(uint256 tokenId)
1137         private
1138         view
1139         returns (uint256 approvedAddressSlot, address approvedAddress)
1140     {
1141         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1142         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1143         assembly {
1144             // Compute the slot.
1145             mstore(0x00, tokenId)
1146             mstore(0x20, tokenApprovalsPtr.slot)
1147             approvedAddressSlot := keccak256(0x00, 0x40)
1148             // Load the slot's value from storage.
1149             approvedAddress := sload(approvedAddressSlot)
1150         }
1151     }
1152 
1153     /**
1154      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1155      */
1156     function _isOwnerOrApproved(
1157         address approvedAddress,
1158         address from,
1159         address msgSender
1160     ) private pure returns (bool result) {
1161         assembly {
1162             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1163             from := and(from, BITMASK_ADDRESS)
1164             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1165             msgSender := and(msgSender, BITMASK_ADDRESS)
1166             // `msgSender == from || msgSender == approvedAddress`.
1167             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1168         }
1169     }
1170 
1171     /**
1172      * @dev Transfers `tokenId` from `from` to `to`.
1173      *
1174      * Requirements:
1175      *
1176      * - `to` cannot be the zero address.
1177      * - `tokenId` token must be owned by `from`.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function transferFrom(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) public virtual override {
1186         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1187 
1188         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1189 
1190         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1191 
1192         // The nested ifs save around 20+ gas over a compound boolean condition.
1193         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1194             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1195 
1196         if (to == address(0)) revert TransferToZeroAddress();
1197 
1198         _beforeTokenTransfers(from, to, tokenId, 1);
1199 
1200         // Clear approvals from the previous owner.
1201         assembly {
1202             if approvedAddress {
1203                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1204                 sstore(approvedAddressSlot, 0)
1205             }
1206         }
1207 
1208         // Underflow of the sender's balance is impossible because we check for
1209         // ownership above and the recipient's balance can't realistically overflow.
1210         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1211         unchecked {
1212             // We can directly increment and decrement the balances.
1213             --_packedAddressData[from]; // Updates: `balance -= 1`.
1214             ++_packedAddressData[to]; // Updates: `balance += 1`.
1215 
1216             // Updates:
1217             // - `address` to the next owner.
1218             // - `startTimestamp` to the timestamp of transfering.
1219             // - `burned` to `false`.
1220             // - `nextInitialized` to `true`.
1221             _packedOwnerships[tokenId] = _packOwnershipData(
1222                 to,
1223                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1224             );
1225 
1226             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1227             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1228                 uint256 nextTokenId = tokenId + 1;
1229                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1230                 if (_packedOwnerships[nextTokenId] == 0) {
1231                     // If the next slot is within bounds.
1232                     if (nextTokenId != _currentIndex) {
1233                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1234                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1235                     }
1236                 }
1237             }
1238         }
1239 
1240         emit Transfer(from, to, tokenId);
1241         _afterTokenTransfers(from, to, tokenId, 1);
1242     }
1243 
1244     /**
1245      * @dev Equivalent to `_burn(tokenId, false)`.
1246      */
1247     function _burn(uint256 tokenId) internal virtual {
1248         _burn(tokenId, false);
1249     }
1250 
1251     /**
1252      * @dev Destroys `tokenId`.
1253      * The approval is cleared when the token is burned.
1254      *
1255      * Requirements:
1256      *
1257      * - `tokenId` must exist.
1258      *
1259      * Emits a {Transfer} event.
1260      */
1261     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1262         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1263 
1264         address from = address(uint160(prevOwnershipPacked));
1265 
1266         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1267 
1268         if (approvalCheck) {
1269             // The nested ifs save around 20+ gas over a compound boolean condition.
1270             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1271                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1272         }
1273 
1274         _beforeTokenTransfers(from, address(0), tokenId, 1);
1275 
1276         // Clear approvals from the previous owner.
1277         assembly {
1278             if approvedAddress {
1279                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1280                 sstore(approvedAddressSlot, 0)
1281             }
1282         }
1283 
1284         // Underflow of the sender's balance is impossible because we check for
1285         // ownership above and the recipient's balance can't realistically overflow.
1286         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1287         unchecked {
1288             // Updates:
1289             // - `balance -= 1`.
1290             // - `numberBurned += 1`.
1291             //
1292             // We can directly decrement the balance, and increment the number burned.
1293             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1294             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1295 
1296             // Updates:
1297             // - `address` to the last owner.
1298             // - `startTimestamp` to the timestamp of burning.
1299             // - `burned` to `true`.
1300             // - `nextInitialized` to `true`.
1301             _packedOwnerships[tokenId] = _packOwnershipData(
1302                 from,
1303                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1304             );
1305 
1306             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1307             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1308                 uint256 nextTokenId = tokenId + 1;
1309                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1310                 if (_packedOwnerships[nextTokenId] == 0) {
1311                     // If the next slot is within bounds.
1312                     if (nextTokenId != _currentIndex) {
1313                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1314                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1315                     }
1316                 }
1317             }
1318         }
1319 
1320         emit Transfer(from, address(0), tokenId);
1321         _afterTokenTransfers(from, address(0), tokenId, 1);
1322 
1323         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1324         unchecked {
1325             _burnCounter++;
1326         }
1327     }
1328 
1329     /**
1330      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1331      *
1332      * @param from address representing the previous owner of the given token ID
1333      * @param to target address that will receive the tokens
1334      * @param tokenId uint256 ID of the token to be transferred
1335      * @param _data bytes optional data to send along with the call
1336      * @return bool whether the call correctly returned the expected magic value
1337      */
1338     function _checkContractOnERC721Received(
1339         address from,
1340         address to,
1341         uint256 tokenId,
1342         bytes memory _data
1343     ) private returns (bool) {
1344         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1345             bytes4 retval
1346         ) {
1347             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1348         } catch (bytes memory reason) {
1349             if (reason.length == 0) {
1350                 revert TransferToNonERC721ReceiverImplementer();
1351             } else {
1352                 assembly {
1353                     revert(add(32, reason), mload(reason))
1354                 }
1355             }
1356         }
1357     }
1358 
1359     /**
1360      * @dev Directly sets the extra data for the ownership data `index`.
1361      */
1362     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1363         uint256 packed = _packedOwnerships[index];
1364         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1365         uint256 extraDataCasted;
1366         // Cast `extraData` with assembly to avoid redundant masking.
1367         assembly {
1368             extraDataCasted := extraData
1369         }
1370         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1371         _packedOwnerships[index] = packed;
1372     }
1373 
1374     /**
1375      * @dev Returns the next extra data for the packed ownership data.
1376      * The returned result is shifted into position.
1377      */
1378     function _nextExtraData(
1379         address from,
1380         address to,
1381         uint256 prevOwnershipPacked
1382     ) private view returns (uint256) {
1383         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1384         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1385     }
1386 
1387     /**
1388      * @dev Called during each token transfer to set the 24bit `extraData` field.
1389      * Intended to be overridden by the cosumer contract.
1390      *
1391      * `previousExtraData` - the value of `extraData` before transfer.
1392      *
1393      * Calling conditions:
1394      *
1395      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1396      * transferred to `to`.
1397      * - When `from` is zero, `tokenId` will be minted for `to`.
1398      * - When `to` is zero, `tokenId` will be burned by `from`.
1399      * - `from` and `to` are never both zero.
1400      */
1401     function _extraData(
1402         address from,
1403         address to,
1404         uint24 previousExtraData
1405     ) internal view virtual returns (uint24) {}
1406 
1407     /**
1408      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1409      * This includes minting.
1410      * And also called before burning one token.
1411      *
1412      * startTokenId - the first token id to be transferred
1413      * quantity - the amount to be transferred
1414      *
1415      * Calling conditions:
1416      *
1417      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1418      * transferred to `to`.
1419      * - When `from` is zero, `tokenId` will be minted for `to`.
1420      * - When `to` is zero, `tokenId` will be burned by `from`.
1421      * - `from` and `to` are never both zero.
1422      */
1423     function _beforeTokenTransfers(
1424         address from,
1425         address to,
1426         uint256 startTokenId,
1427         uint256 quantity
1428     ) internal virtual {}
1429 
1430     /**
1431      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1432      * This includes minting.
1433      * And also called after one token has been burned.
1434      *
1435      * startTokenId - the first token id to be transferred
1436      * quantity - the amount to be transferred
1437      *
1438      * Calling conditions:
1439      *
1440      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1441      * transferred to `to`.
1442      * - When `from` is zero, `tokenId` has been minted for `to`.
1443      * - When `to` is zero, `tokenId` has been burned by `from`.
1444      * - `from` and `to` are never both zero.
1445      */
1446     function _afterTokenTransfers(
1447         address from,
1448         address to,
1449         uint256 startTokenId,
1450         uint256 quantity
1451     ) internal virtual {}
1452 
1453     /**
1454      * @dev Returns the message sender (defaults to `msg.sender`).
1455      *
1456      * If you are writing GSN compatible contracts, you need to override this function.
1457      */
1458     function _msgSenderERC721A() internal view virtual returns (address) {
1459         return msg.sender;
1460     }
1461 
1462     /**
1463      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1464      */
1465     function _toString(uint256 value) internal pure returns (string memory ptr) {
1466         assembly {
1467             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1468             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1469             // We will need 1 32-byte word to store the length,
1470             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1471             ptr := add(mload(0x40), 128)
1472             // Update the free memory pointer to allocate.
1473             mstore(0x40, ptr)
1474 
1475             // Cache the end of the memory to calculate the length later.
1476             let end := ptr
1477 
1478             // We write the string from the rightmost digit to the leftmost digit.
1479             // The following is essentially a do-while loop that also handles the zero case.
1480             // Costs a bit more than early returning for the zero case,
1481             // but cheaper in terms of deployment and overall runtime costs.
1482             for {
1483                 // Initialize and perform the first pass without check.
1484                 let temp := value
1485                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1486                 ptr := sub(ptr, 1)
1487                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1488                 mstore8(ptr, add(48, mod(temp, 10)))
1489                 temp := div(temp, 10)
1490             } temp {
1491                 // Keep dividing `temp` until zero.
1492                 temp := div(temp, 10)
1493             } {
1494                 // Body of the for loop.
1495                 ptr := sub(ptr, 1)
1496                 mstore8(ptr, add(48, mod(temp, 10)))
1497             }
1498 
1499             let length := sub(end, ptr)
1500             // Move the pointer 32 bytes leftwards to make room for the length.
1501             ptr := sub(ptr, 32)
1502             // Store the length.
1503             mstore(ptr, length)
1504         }
1505     }
1506 }
1507 
1508 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1509 
1510 
1511 // ERC721A Contracts v4.1.0
1512 // Creator: Chiru Labs
1513 
1514 pragma solidity ^0.8.4;
1515 
1516 
1517 /**
1518  * @dev Interface of an ERC721AQueryable compliant contract.
1519  */
1520 interface IERC721AQueryable is IERC721A {
1521     /**
1522      * Invalid query range (`start` >= `stop`).
1523      */
1524     error InvalidQueryRange();
1525 
1526     /**
1527      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1528      *
1529      * If the `tokenId` is out of bounds:
1530      *   - `addr` = `address(0)`
1531      *   - `startTimestamp` = `0`
1532      *   - `burned` = `false`
1533      *
1534      * If the `tokenId` is burned:
1535      *   - `addr` = `<Address of owner before token was burned>`
1536      *   - `startTimestamp` = `<Timestamp when token was burned>`
1537      *   - `burned = `true`
1538      *
1539      * Otherwise:
1540      *   - `addr` = `<Address of owner>`
1541      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1542      *   - `burned = `false`
1543      */
1544     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1545 
1546     /**
1547      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1548      * See {ERC721AQueryable-explicitOwnershipOf}
1549      */
1550     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1551 
1552     /**
1553      * @dev Returns an array of token IDs owned by `owner`,
1554      * in the range [`start`, `stop`)
1555      * (i.e. `start <= tokenId < stop`).
1556      *
1557      * This function allows for tokens to be queried if the collection
1558      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1559      *
1560      * Requirements:
1561      *
1562      * - `start` < `stop`
1563      */
1564     function tokensOfOwnerIn(
1565         address owner,
1566         uint256 start,
1567         uint256 stop
1568     ) external view returns (uint256[] memory);
1569 
1570     /**
1571      * @dev Returns an array of token IDs owned by `owner`.
1572      *
1573      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1574      * It is meant to be called off-chain.
1575      *
1576      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1577      * multiple smaller scans if the collection is large enough to cause
1578      * an out-of-gas error (10K pfp collections should be fine).
1579      */
1580     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1581 }
1582 
1583 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1584 
1585 
1586 // ERC721A Contracts v4.1.0
1587 // Creator: Chiru Labs
1588 
1589 pragma solidity ^0.8.4;
1590 
1591 
1592 
1593 /**
1594  * @title ERC721A Queryable
1595  * @dev ERC721A subclass with convenience query functions.
1596  */
1597 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1598     /**
1599      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1600      *
1601      * If the `tokenId` is out of bounds:
1602      *   - `addr` = `address(0)`
1603      *   - `startTimestamp` = `0`
1604      *   - `burned` = `false`
1605      *   - `extraData` = `0`
1606      *
1607      * If the `tokenId` is burned:
1608      *   - `addr` = `<Address of owner before token was burned>`
1609      *   - `startTimestamp` = `<Timestamp when token was burned>`
1610      *   - `burned = `true`
1611      *   - `extraData` = `<Extra data when token was burned>`
1612      *
1613      * Otherwise:
1614      *   - `addr` = `<Address of owner>`
1615      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1616      *   - `burned = `false`
1617      *   - `extraData` = `<Extra data at start of ownership>`
1618      */
1619     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1620         TokenOwnership memory ownership;
1621         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1622             return ownership;
1623         }
1624         ownership = _ownershipAt(tokenId);
1625         if (ownership.burned) {
1626             return ownership;
1627         }
1628         return _ownershipOf(tokenId);
1629     }
1630 
1631     /**
1632      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1633      * See {ERC721AQueryable-explicitOwnershipOf}
1634      */
1635     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1636         unchecked {
1637             uint256 tokenIdsLength = tokenIds.length;
1638             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1639             for (uint256 i; i != tokenIdsLength; ++i) {
1640                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1641             }
1642             return ownerships;
1643         }
1644     }
1645 
1646     /**
1647      * @dev Returns an array of token IDs owned by `owner`,
1648      * in the range [`start`, `stop`)
1649      * (i.e. `start <= tokenId < stop`).
1650      *
1651      * This function allows for tokens to be queried if the collection
1652      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1653      *
1654      * Requirements:
1655      *
1656      * - `start` < `stop`
1657      */
1658     function tokensOfOwnerIn(
1659         address owner,
1660         uint256 start,
1661         uint256 stop
1662     ) external view override returns (uint256[] memory) {
1663         unchecked {
1664             if (start >= stop) revert InvalidQueryRange();
1665             uint256 tokenIdsIdx;
1666             uint256 stopLimit = _nextTokenId();
1667             // Set `start = max(start, _startTokenId())`.
1668             if (start < _startTokenId()) {
1669                 start = _startTokenId();
1670             }
1671             // Set `stop = min(stop, stopLimit)`.
1672             if (stop > stopLimit) {
1673                 stop = stopLimit;
1674             }
1675             uint256 tokenIdsMaxLength = balanceOf(owner);
1676             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1677             // to cater for cases where `balanceOf(owner)` is too big.
1678             if (start < stop) {
1679                 uint256 rangeLength = stop - start;
1680                 if (rangeLength < tokenIdsMaxLength) {
1681                     tokenIdsMaxLength = rangeLength;
1682                 }
1683             } else {
1684                 tokenIdsMaxLength = 0;
1685             }
1686             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1687             if (tokenIdsMaxLength == 0) {
1688                 return tokenIds;
1689             }
1690             // We need to call `explicitOwnershipOf(start)`,
1691             // because the slot at `start` may not be initialized.
1692             TokenOwnership memory ownership = explicitOwnershipOf(start);
1693             address currOwnershipAddr;
1694             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1695             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1696             if (!ownership.burned) {
1697                 currOwnershipAddr = ownership.addr;
1698             }
1699             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1700                 ownership = _ownershipAt(i);
1701                 if (ownership.burned) {
1702                     continue;
1703                 }
1704                 if (ownership.addr != address(0)) {
1705                     currOwnershipAddr = ownership.addr;
1706                 }
1707                 if (currOwnershipAddr == owner) {
1708                     tokenIds[tokenIdsIdx++] = i;
1709                 }
1710             }
1711             // Downsize the array to fit.
1712             assembly {
1713                 mstore(tokenIds, tokenIdsIdx)
1714             }
1715             return tokenIds;
1716         }
1717     }
1718 
1719     /**
1720      * @dev Returns an array of token IDs owned by `owner`.
1721      *
1722      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1723      * It is meant to be called off-chain.
1724      *
1725      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1726      * multiple smaller scans if the collection is large enough to cause
1727      * an out-of-gas error (10K pfp collections should be fine).
1728      */
1729     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1730         unchecked {
1731             uint256 tokenIdsIdx;
1732             address currOwnershipAddr;
1733             uint256 tokenIdsLength = balanceOf(owner);
1734             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1735             TokenOwnership memory ownership;
1736             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1737                 ownership = _ownershipAt(i);
1738                 if (ownership.burned) {
1739                     continue;
1740                 }
1741                 if (ownership.addr != address(0)) {
1742                     currOwnershipAddr = ownership.addr;
1743                 }
1744                 if (currOwnershipAddr == owner) {
1745                     tokenIds[tokenIdsIdx++] = i;
1746                 }
1747             }
1748             return tokenIds;
1749         }
1750     }
1751 }
1752 
1753 
1754 
1755 pragma solidity >=0.8.9 <0.9.0;
1756 
1757 contract y00tzuki is ERC721AQueryable, Ownable, ReentrancyGuard {
1758     using Strings for uint256;
1759 
1760     uint256 public maxSupply = 4000;
1761 	uint256 public Ownermint = 1;
1762     uint256 public maxPerAddress = 100;
1763 	uint256 public maxPerTX = 10;
1764     uint256 public cost = 0.001 ether;
1765 	mapping(address => bool) public freeMinted; 
1766 
1767     bool public paused = true;
1768 
1769 	string public uriPrefix = '';
1770     string public uriSuffix = '.json';
1771 	
1772   constructor(string memory baseURI) ERC721A("y00tzuki", "YTZKI") {
1773       setUriPrefix(baseURI); 
1774       _safeMint(_msgSender(), Ownermint);
1775 
1776   }
1777 
1778   modifier callerIsUser() {
1779         require(tx.origin == msg.sender, "The caller is another contract");
1780         _;
1781   }
1782 
1783   function numberMinted(address owner) public view returns (uint256) {
1784         return _numberMinted(owner);
1785   }
1786 
1787   function mint(uint256 _mintAmount) public payable nonReentrant callerIsUser{
1788         require(!paused, 'The contract is paused!');
1789         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1790         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1791         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1792 	if (freeMinted[_msgSender()]){
1793         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1794   }
1795     else{
1796 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1797         freeMinted[_msgSender()] = true;
1798   }
1799 
1800     _safeMint(_msgSender(), _mintAmount);
1801   }
1802 
1803   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1804     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1805     string memory currentBaseURI = _baseURI();
1806     return bytes(currentBaseURI).length > 0
1807         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1808         : '';
1809   }
1810 
1811   function setPaused() public onlyOwner {
1812     paused = !paused;
1813   }
1814 
1815   function setCost(uint256 _cost) public onlyOwner {
1816     cost = _cost;
1817   }
1818 
1819   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1820     maxPerTX = _maxPerTX;
1821   }
1822 
1823   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1824     uriPrefix = _uriPrefix;
1825   }
1826  
1827   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1828     uriSuffix = _uriSuffix;
1829   }
1830 
1831   function withdraw() external onlyOwner {
1832         payable(msg.sender).transfer(address(this).balance);
1833   }
1834 
1835   function _startTokenId() internal view virtual override returns (uint256) {
1836     return 1;
1837   }
1838 
1839   function _baseURI() internal view virtual override returns (string memory) {
1840     return uriPrefix;
1841   }
1842 }