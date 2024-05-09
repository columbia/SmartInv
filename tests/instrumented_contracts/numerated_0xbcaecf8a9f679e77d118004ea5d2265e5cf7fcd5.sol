1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4                                                                   
5                                                                   
6 `7MM"""Mq.`7MMF'`YMM'   `MP' `7MM"""YMM  `7MMF'                   
7   MM   `MM. MM    VMb.  ,P     MM    `7    MM                     
8   MM   ,M9  MM     `MM.M'      MM   d      MM                     
9   MMmmdM9   MM       MMb       MMmmMM      MM                     
10   MM        MM     ,M'`Mb.     MM   Y  ,   MM      ,              
11   MM        MM    ,P   `MM.    MM     ,M   MM     ,M              
12 .JMML.    .JMML..MM:.  .:MMa..JMMmmmmMMM .JMMmmmmMMM              
13                                                                   
14                                                                   
15                                                                   
16                                                                   
17 `7MMF' `YMM' `7MMF'MMP""MM""YMM   db      `7MM"""Mq.   .g8""8q.   
18   MM   .M'     MM  P'   MM   `7  ;MM:       MM   `MM..dP'    `YM. 
19   MM .d"       MM       MM      ,V^MM.      MM   ,M9 dM'      `MM 
20   MMMMM.       MM       MM     ,M  `MM      MMmmdM9  MM        MM 
21   MM  VMA      MM       MM     AbmmmqMA     MM  YM.  MM.      ,MP 
22   MM   `MM.    MM       MM    A'     VML    MM   `Mb.`Mb.    ,dP' 
23 .JMML.   MMb..JMML.   .JMML..AMA.   .AMMA..JMML. .JMM. `"bmmd"'   
24                                                                   
25                                                                                                                                                                                                                                                                                                                                                           
26 */
27 
28 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module that helps prevent reentrant calls to a function.
34  *
35  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
36  * available, which can be applied to functions to make sure there are no nested
37  * (reentrant) calls to them.
38  *
39  * Note that because there is a single `nonReentrant` guard, functions marked as
40  * `nonReentrant` may not call one another. This can be worked around by making
41  * those functions `private`, and then adding `external` `nonReentrant` entry
42  * points to them.
43  *
44  * TIP: If you would like to learn more about reentrancy and alternative ways
45  * to protect against it, check out our blog post
46  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
47  */
48 abstract contract ReentrancyGuard {
49     // Booleans are more expensive than uint256 or any type that takes up a full
50     // word because each write operation emits an extra SLOAD to first read the
51     // slot's contents, replace the bits taken up by the boolean, and then write
52     // back. This is the compiler's defense against contract upgrades and
53     // pointer aliasing, and it cannot be disabled.
54 
55     // The values being non-zero value makes deployment a bit more expensive,
56     // but in exchange the refund on every call to nonReentrant will be lower in
57     // amount. Since refunds are capped to a percentage of the total
58     // transaction's gas, it is best to keep them low in cases like this one, to
59     // increase the likelihood of the full refund coming into effect.
60     uint256 private constant _NOT_ENTERED = 1;
61     uint256 private constant _ENTERED = 2;
62 
63     uint256 private _status;
64 
65     constructor() {
66         _status = _NOT_ENTERED;
67     }
68 
69     /**
70      * @dev Prevents a contract from calling itself, directly or indirectly.
71      * Calling a `nonReentrant` function from another `nonReentrant`
72      * function is not supported. It is possible to prevent this from happening
73      * by making the `nonReentrant` function external, and making it call a
74      * `private` function that does the actual work.
75      */
76     modifier nonReentrant() {
77         // On the first call to nonReentrant, _notEntered will be true
78         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
79 
80         // Any calls to nonReentrant after this point will fail
81         _status = _ENTERED;
82 
83         _;
84 
85         // By storing the original value once again, a refund is triggered (see
86         // https://eips.ethereum.org/EIPS/eip-2200)
87         _status = _NOT_ENTERED;
88     }
89 }
90 
91 // File: @openzeppelin/contracts/utils/Strings.sol
92 
93 
94 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev String operations.
100  */
101 library Strings {
102     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
103     uint8 private constant _ADDRESS_LENGTH = 20;
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
107      */
108     function toString(uint256 value) internal pure returns (string memory) {
109         // Inspired by OraclizeAPI's implementation - MIT licence
110         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
111 
112         if (value == 0) {
113             return "0";
114         }
115         uint256 temp = value;
116         uint256 digits;
117         while (temp != 0) {
118             digits++;
119             temp /= 10;
120         }
121         bytes memory buffer = new bytes(digits);
122         while (value != 0) {
123             digits -= 1;
124             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
125             value /= 10;
126         }
127         return string(buffer);
128     }
129 
130     /**
131      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
132      */
133     function toHexString(uint256 value) internal pure returns (string memory) {
134         if (value == 0) {
135             return "0x00";
136         }
137         uint256 temp = value;
138         uint256 length = 0;
139         while (temp != 0) {
140             length++;
141             temp >>= 8;
142         }
143         return toHexString(value, length);
144     }
145 
146     /**
147      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
148      */
149     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
150         bytes memory buffer = new bytes(2 * length + 2);
151         buffer[0] = "0";
152         buffer[1] = "x";
153         for (uint256 i = 2 * length + 1; i > 1; --i) {
154             buffer[i] = _HEX_SYMBOLS[value & 0xf];
155             value >>= 4;
156         }
157         require(value == 0, "Strings: hex length insufficient");
158         return string(buffer);
159     }
160 
161     /**
162      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
163      */
164     function toHexString(address addr) internal pure returns (string memory) {
165         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
166     }
167 }
168 
169 
170 // File: @openzeppelin/contracts/utils/Context.sol
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @dev Provides information about the current execution context, including the
179  * sender of the transaction and its data. While these are generally available
180  * via msg.sender and msg.data, they should not be accessed in such a direct
181  * manner, since when dealing with meta-transactions the account sending and
182  * paying for execution may not be the actual sender (as far as an application
183  * is concerned).
184  *
185  * This contract is only required for intermediate, library-like contracts.
186  */
187 abstract contract Context {
188     function _msgSender() internal view virtual returns (address) {
189         return msg.sender;
190     }
191 
192     function _msgData() internal view virtual returns (bytes calldata) {
193         return msg.data;
194     }
195 }
196 
197 // File: @openzeppelin/contracts/access/Ownable.sol
198 
199 
200 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
201 
202 pragma solidity ^0.8.0;
203 
204 
205 /**
206  * @dev Contract module which provides a basic access control mechanism, where
207  * there is an account (an owner) that can be granted exclusive access to
208  * specific functions.
209  *
210  * By default, the owner account will be the one that deploys the contract. This
211  * can later be changed with {transferOwnership}.
212  *
213  * This module is used through inheritance. It will make available the modifier
214  * `onlyOwner`, which can be applied to your functions to restrict their use to
215  * the owner.
216  */
217 abstract contract Ownable is Context {
218     address private _owner;
219 
220     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221 
222     /**
223      * @dev Initializes the contract setting the deployer as the initial owner.
224      */
225     constructor() {
226         _transferOwnership(_msgSender());
227     }
228 
229     /**
230      * @dev Throws if called by any account other than the owner.
231      */
232     modifier onlyOwner() {
233         _checkOwner();
234         _;
235     }
236 
237     /**
238      * @dev Returns the address of the current owner.
239      */
240     function owner() public view virtual returns (address) {
241         return _owner;
242     }
243 
244     /**
245      * @dev Throws if the sender is not the owner.
246      */
247     function _checkOwner() internal view virtual {
248         require(owner() == _msgSender(), "Ownable: caller is not the owner");
249     }
250 
251     /**
252      * @dev Leaves the contract without owner. It will not be possible to call
253      * `onlyOwner` functions anymore. Can only be called by the current owner.
254      *
255      * NOTE: Renouncing ownership will leave the contract without an owner,
256      * thereby removing any functionality that is only available to the owner.
257      */
258     function renounceOwnership() public virtual onlyOwner {
259         _transferOwnership(address(0));
260     }
261 
262     /**
263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
264      * Can only be called by the current owner.
265      */
266     function transferOwnership(address newOwner) public virtual onlyOwner {
267         require(newOwner != address(0), "Ownable: new owner is the zero address");
268         _transferOwnership(newOwner);
269     }
270 
271     /**
272      * @dev Transfers ownership of the contract to a new account (`newOwner`).
273      * Internal function without access restriction.
274      */
275     function _transferOwnership(address newOwner) internal virtual {
276         address oldOwner = _owner;
277         _owner = newOwner;
278         emit OwnershipTransferred(oldOwner, newOwner);
279     }
280 }
281 
282 // File: erc721a/contracts/IERC721A.sol
283 
284 
285 // ERC721A Contracts v4.1.0
286 // Creator: Chiru Labs
287 
288 pragma solidity ^0.8.4;
289 
290 /**
291  * @dev Interface of an ERC721A compliant contract.
292  */
293 interface IERC721A {
294     /**
295      * The caller must own the token or be an approved operator.
296      */
297     error ApprovalCallerNotOwnerNorApproved();
298 
299     /**
300      * The token does not exist.
301      */
302     error ApprovalQueryForNonexistentToken();
303 
304     /**
305      * The caller cannot approve to their own address.
306      */
307     error ApproveToCaller();
308 
309     /**
310      * Cannot query the balance for the zero address.
311      */
312     error BalanceQueryForZeroAddress();
313 
314     /**
315      * Cannot mint to the zero address.
316      */
317     error MintToZeroAddress();
318 
319     /**
320      * The quantity of tokens minted must be more than zero.
321      */
322     error MintZeroQuantity();
323 
324     /**
325      * The token does not exist.
326      */
327     error OwnerQueryForNonexistentToken();
328 
329     /**
330      * The caller must own the token or be an approved operator.
331      */
332     error TransferCallerNotOwnerNorApproved();
333 
334     /**
335      * The token must be owned by `from`.
336      */
337     error TransferFromIncorrectOwner();
338 
339     /**
340      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
341      */
342     error TransferToNonERC721ReceiverImplementer();
343 
344     /**
345      * Cannot transfer to the zero address.
346      */
347     error TransferToZeroAddress();
348 
349     /**
350      * The token does not exist.
351      */
352     error URIQueryForNonexistentToken();
353 
354     /**
355      * The `quantity` minted with ERC2309 exceeds the safety limit.
356      */
357     error MintERC2309QuantityExceedsLimit();
358 
359     /**
360      * The `extraData` cannot be set on an unintialized ownership slot.
361      */
362     error OwnershipNotInitializedForExtraData();
363 
364     struct TokenOwnership {
365         // The address of the owner.
366         address addr;
367         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
368         uint64 startTimestamp;
369         // Whether the token has been burned.
370         bool burned;
371         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
372         uint24 extraData;
373     }
374 
375     /**
376      * @dev Returns the total amount of tokens stored by the contract.
377      *
378      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
379      */
380     function totalSupply() external view returns (uint256);
381 
382     // ==============================
383     //            IERC165
384     // ==============================
385 
386     /**
387      * @dev Returns true if this contract implements the interface defined by
388      * `interfaceId`. See the corresponding
389      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
390      * to learn more about how these ids are created.
391      *
392      * This function call must use less than 30 000 gas.
393      */
394     function supportsInterface(bytes4 interfaceId) external view returns (bool);
395 
396     // ==============================
397     //            IERC721
398     // ==============================
399 
400     /**
401      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
402      */
403     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
404 
405     /**
406      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
407      */
408     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
412      */
413     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
414 
415     /**
416      * @dev Returns the number of tokens in ``owner``'s account.
417      */
418     function balanceOf(address owner) external view returns (uint256 balance);
419 
420     /**
421      * @dev Returns the owner of the `tokenId` token.
422      *
423      * Requirements:
424      *
425      * - `tokenId` must exist.
426      */
427     function ownerOf(uint256 tokenId) external view returns (address owner);
428 
429     /**
430      * @dev Safely transfers `tokenId` token from `from` to `to`.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must exist and be owned by `from`.
437      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
438      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
439      *
440      * Emits a {Transfer} event.
441      */
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 tokenId,
446         bytes calldata data
447     ) external;
448 
449     /**
450      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
451      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must exist and be owned by `from`.
458      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
460      *
461      * Emits a {Transfer} event.
462      */
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) external;
468 
469     /**
470      * @dev Transfers `tokenId` token from `from` to `to`.
471      *
472      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must be owned by `from`.
479      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
480      *
481      * Emits a {Transfer} event.
482      */
483     function transferFrom(
484         address from,
485         address to,
486         uint256 tokenId
487     ) external;
488 
489     /**
490      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
491      * The approval is cleared when the token is transferred.
492      *
493      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
494      *
495      * Requirements:
496      *
497      * - The caller must own the token or be an approved operator.
498      * - `tokenId` must exist.
499      *
500      * Emits an {Approval} event.
501      */
502     function approve(address to, uint256 tokenId) external;
503 
504     /**
505      * @dev Approve or remove `operator` as an operator for the caller.
506      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
507      *
508      * Requirements:
509      *
510      * - The `operator` cannot be the caller.
511      *
512      * Emits an {ApprovalForAll} event.
513      */
514     function setApprovalForAll(address operator, bool _approved) external;
515 
516     /**
517      * @dev Returns the account approved for `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function getApproved(uint256 tokenId) external view returns (address operator);
524 
525     /**
526      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
527      *
528      * See {setApprovalForAll}
529      */
530     function isApprovedForAll(address owner, address operator) external view returns (bool);
531 
532     // ==============================
533     //        IERC721Metadata
534     // ==============================
535 
536     /**
537      * @dev Returns the token collection name.
538      */
539     function name() external view returns (string memory);
540 
541     /**
542      * @dev Returns the token collection symbol.
543      */
544     function symbol() external view returns (string memory);
545 
546     /**
547      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
548      */
549     function tokenURI(uint256 tokenId) external view returns (string memory);
550 
551     // ==============================
552     //            IERC2309
553     // ==============================
554 
555     /**
556      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
557      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
558      */
559     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
560 }
561 
562 // File: erc721a/contracts/ERC721A.sol
563 
564 
565 // ERC721A Contracts v4.1.0
566 // Creator: Chiru Labs
567 
568 pragma solidity ^0.8.4;
569 
570 
571 /**
572  * @dev ERC721 token receiver interface.
573  */
574 interface ERC721A__IERC721Receiver {
575     function onERC721Received(
576         address operator,
577         address from,
578         uint256 tokenId,
579         bytes calldata data
580     ) external returns (bytes4);
581 }
582 
583 /**
584  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
585  * including the Metadata extension. Built to optimize for lower gas during batch mints.
586  *
587  * Assumes serials are sequentially minted starting at `_startTokenId()`
588  * (defaults to 0, e.g. 0, 1, 2, 3..).
589  *
590  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
591  *
592  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
593  */
594 contract ERC721A is IERC721A {
595     // Mask of an entry in packed address data.
596     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
597 
598     // The bit position of `numberMinted` in packed address data.
599     uint256 private constant BITPOS_NUMBER_MINTED = 64;
600 
601     // The bit position of `numberBurned` in packed address data.
602     uint256 private constant BITPOS_NUMBER_BURNED = 128;
603 
604     // The bit position of `aux` in packed address data.
605     uint256 private constant BITPOS_AUX = 192;
606 
607     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
608     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
609 
610     // The bit position of `startTimestamp` in packed ownership.
611     uint256 private constant BITPOS_START_TIMESTAMP = 160;
612 
613     // The bit mask of the `burned` bit in packed ownership.
614     uint256 private constant BITMASK_BURNED = 1 << 224;
615 
616     // The bit position of the `nextInitialized` bit in packed ownership.
617     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
618 
619     // The bit mask of the `nextInitialized` bit in packed ownership.
620     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
621 
622     // The bit position of `extraData` in packed ownership.
623     uint256 private constant BITPOS_EXTRA_DATA = 232;
624 
625     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
626     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
627 
628     // The mask of the lower 160 bits for addresses.
629     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
630 
631     // The maximum `quantity` that can be minted with `_mintERC2309`.
632     // This limit is to prevent overflows on the address data entries.
633     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
634     // is required to cause an overflow, which is unrealistic.
635     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
636 
637     // The tokenId of the next token to be minted.
638     uint256 private _currentIndex;
639 
640     // The number of tokens burned.
641     uint256 private _burnCounter;
642 
643     // Token name
644     string private _name;
645 
646     // Token symbol
647     string private _symbol;
648 
649     // Mapping from token ID to ownership details
650     // An empty struct value does not necessarily mean the token is unowned.
651     // See `_packedOwnershipOf` implementation for details.
652     //
653     // Bits Layout:
654     // - [0..159]   `addr`
655     // - [160..223] `startTimestamp`
656     // - [224]      `burned`
657     // - [225]      `nextInitialized`
658     // - [232..255] `extraData`
659     mapping(uint256 => uint256) private _packedOwnerships;
660 
661     // Mapping owner address to address data.
662     //
663     // Bits Layout:
664     // - [0..63]    `balance`
665     // - [64..127]  `numberMinted`
666     // - [128..191] `numberBurned`
667     // - [192..255] `aux`
668     mapping(address => uint256) private _packedAddressData;
669 
670     // Mapping from token ID to approved address.
671     mapping(uint256 => address) private _tokenApprovals;
672 
673     // Mapping from owner to operator approvals
674     mapping(address => mapping(address => bool)) private _operatorApprovals;
675 
676     constructor(string memory name_, string memory symbol_) {
677         _name = name_;
678         _symbol = symbol_;
679         _currentIndex = _startTokenId();
680     }
681 
682     /**
683      * @dev Returns the starting token ID.
684      * To change the starting token ID, please override this function.
685      */
686     function _startTokenId() internal view virtual returns (uint256) {
687         return 0;
688     }
689 
690     /**
691      * @dev Returns the next token ID to be minted.
692      */
693     function _nextTokenId() internal view returns (uint256) {
694         return _currentIndex;
695     }
696 
697     /**
698      * @dev Returns the total number of tokens in existence.
699      * Burned tokens will reduce the count.
700      * To get the total number of tokens minted, please see `_totalMinted`.
701      */
702     function totalSupply() public view override returns (uint256) {
703         // Counter underflow is impossible as _burnCounter cannot be incremented
704         // more than `_currentIndex - _startTokenId()` times.
705         unchecked {
706             return _currentIndex - _burnCounter - _startTokenId();
707         }
708     }
709 
710     /**
711      * @dev Returns the total amount of tokens minted in the contract.
712      */
713     function _totalMinted() internal view returns (uint256) {
714         // Counter underflow is impossible as _currentIndex does not decrement,
715         // and it is initialized to `_startTokenId()`
716         unchecked {
717             return _currentIndex - _startTokenId();
718         }
719     }
720 
721     /**
722      * @dev Returns the total number of tokens burned.
723      */
724     function _totalBurned() internal view returns (uint256) {
725         return _burnCounter;
726     }
727 
728     /**
729      * @dev See {IERC165-supportsInterface}.
730      */
731     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
732         // The interface IDs are constants representing the first 4 bytes of the XOR of
733         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
734         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
735         return
736             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
737             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
738             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
739     }
740 
741     /**
742      * @dev See {IERC721-balanceOf}.
743      */
744     function balanceOf(address owner) public view override returns (uint256) {
745         if (owner == address(0)) revert BalanceQueryForZeroAddress();
746         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
747     }
748 
749     /**
750      * Returns the number of tokens minted by `owner`.
751      */
752     function _numberMinted(address owner) internal view returns (uint256) {
753         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
754     }
755 
756     /**
757      * Returns the number of tokens burned by or on behalf of `owner`.
758      */
759     function _numberBurned(address owner) internal view returns (uint256) {
760         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
761     }
762 
763     /**
764      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
765      */
766     function _getAux(address owner) internal view returns (uint64) {
767         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
768     }
769 
770     /**
771      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
772      * If there are multiple variables, please pack them into a uint64.
773      */
774     function _setAux(address owner, uint64 aux) internal {
775         uint256 packed = _packedAddressData[owner];
776         uint256 auxCasted;
777         // Cast `aux` with assembly to avoid redundant masking.
778         assembly {
779             auxCasted := aux
780         }
781         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
782         _packedAddressData[owner] = packed;
783     }
784 
785     /**
786      * Returns the packed ownership data of `tokenId`.
787      */
788     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
789         uint256 curr = tokenId;
790 
791         unchecked {
792             if (_startTokenId() <= curr)
793                 if (curr < _currentIndex) {
794                     uint256 packed = _packedOwnerships[curr];
795                     // If not burned.
796                     if (packed & BITMASK_BURNED == 0) {
797                         // Invariant:
798                         // There will always be an ownership that has an address and is not burned
799                         // before an ownership that does not have an address and is not burned.
800                         // Hence, curr will not underflow.
801                         //
802                         // We can directly compare the packed value.
803                         // If the address is zero, packed is zero.
804                         while (packed == 0) {
805                             packed = _packedOwnerships[--curr];
806                         }
807                         return packed;
808                     }
809                 }
810         }
811         revert OwnerQueryForNonexistentToken();
812     }
813 
814     /**
815      * Returns the unpacked `TokenOwnership` struct from `packed`.
816      */
817     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
818         ownership.addr = address(uint160(packed));
819         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
820         ownership.burned = packed & BITMASK_BURNED != 0;
821         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
822     }
823 
824     /**
825      * Returns the unpacked `TokenOwnership` struct at `index`.
826      */
827     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
828         return _unpackedOwnership(_packedOwnerships[index]);
829     }
830 
831     /**
832      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
833      */
834     function _initializeOwnershipAt(uint256 index) internal {
835         if (_packedOwnerships[index] == 0) {
836             _packedOwnerships[index] = _packedOwnershipOf(index);
837         }
838     }
839 
840     /**
841      * Gas spent here starts off proportional to the maximum mint batch size.
842      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
843      */
844     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
845         return _unpackedOwnership(_packedOwnershipOf(tokenId));
846     }
847 
848     /**
849      * @dev Packs ownership data into a single uint256.
850      */
851     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
852         assembly {
853             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
854             owner := and(owner, BITMASK_ADDRESS)
855             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
856             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
857         }
858     }
859 
860     /**
861      * @dev See {IERC721-ownerOf}.
862      */
863     function ownerOf(uint256 tokenId) public view override returns (address) {
864         return address(uint160(_packedOwnershipOf(tokenId)));
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-name}.
869      */
870     function name() public view virtual override returns (string memory) {
871         return _name;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-symbol}.
876      */
877     function symbol() public view virtual override returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-tokenURI}.
883      */
884     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
885         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
886 
887         string memory baseURI = _baseURI();
888         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
889     }
890 
891     /**
892      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
893      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
894      * by default, it can be overridden in child contracts.
895      */
896     function _baseURI() internal view virtual returns (string memory) {
897         return '';
898     }
899 
900     /**
901      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
902      */
903     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
904         // For branchless setting of the `nextInitialized` flag.
905         assembly {
906             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
907             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
908         }
909     }
910 
911     /**
912      * @dev See {IERC721-approve}.
913      */
914     function approve(address to, uint256 tokenId) public override {
915         address owner = ownerOf(tokenId);
916 
917         if (_msgSenderERC721A() != owner)
918             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
919                 revert ApprovalCallerNotOwnerNorApproved();
920             }
921 
922         _tokenApprovals[tokenId] = to;
923         emit Approval(owner, to, tokenId);
924     }
925 
926     /**
927      * @dev See {IERC721-getApproved}.
928      */
929     function getApproved(uint256 tokenId) public view override returns (address) {
930         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
931 
932         return _tokenApprovals[tokenId];
933     }
934 
935     /**
936      * @dev See {IERC721-setApprovalForAll}.
937      */
938     function setApprovalForAll(address operator, bool approved) public virtual override {
939         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
940 
941         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
942         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
943     }
944 
945     /**
946      * @dev See {IERC721-isApprovedForAll}.
947      */
948     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
949         return _operatorApprovals[owner][operator];
950     }
951 
952     /**
953      * @dev See {IERC721-safeTransferFrom}.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId
959     ) public virtual override {
960         safeTransferFrom(from, to, tokenId, '');
961     }
962 
963     /**
964      * @dev See {IERC721-safeTransferFrom}.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId,
970         bytes memory _data
971     ) public virtual override {
972         transferFrom(from, to, tokenId);
973         if (to.code.length != 0)
974             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
975                 revert TransferToNonERC721ReceiverImplementer();
976             }
977     }
978 
979     /**
980      * @dev Returns whether `tokenId` exists.
981      *
982      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
983      *
984      * Tokens start existing when they are minted (`_mint`),
985      */
986     function _exists(uint256 tokenId) internal view returns (bool) {
987         return
988             _startTokenId() <= tokenId &&
989             tokenId < _currentIndex && // If within bounds,
990             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
991     }
992 
993     /**
994      * @dev Equivalent to `_safeMint(to, quantity, '')`.
995      */
996     function _safeMint(address to, uint256 quantity) internal {
997         _safeMint(to, quantity, '');
998     }
999 
1000     /**
1001      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1002      *
1003      * Requirements:
1004      *
1005      * - If `to` refers to a smart contract, it must implement
1006      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1007      * - `quantity` must be greater than 0.
1008      *
1009      * See {_mint}.
1010      *
1011      * Emits a {Transfer} event for each mint.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 quantity,
1016         bytes memory _data
1017     ) internal {
1018         _mint(to, quantity);
1019 
1020         unchecked {
1021             if (to.code.length != 0) {
1022                 uint256 end = _currentIndex;
1023                 uint256 index = end - quantity;
1024                 do {
1025                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1026                         revert TransferToNonERC721ReceiverImplementer();
1027                     }
1028                 } while (index < end);
1029                 // Reentrancy protection.
1030                 if (_currentIndex != end) revert();
1031             }
1032         }
1033     }
1034 
1035     /**
1036      * @dev Mints `quantity` tokens and transfers them to `to`.
1037      *
1038      * Requirements:
1039      *
1040      * - `to` cannot be the zero address.
1041      * - `quantity` must be greater than 0.
1042      *
1043      * Emits a {Transfer} event for each mint.
1044      */
1045     function _mint(address to, uint256 quantity) internal {
1046         uint256 startTokenId = _currentIndex;
1047         if (to == address(0)) revert MintToZeroAddress();
1048         if (quantity == 0) revert MintZeroQuantity();
1049 
1050         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1051 
1052         // Overflows are incredibly unrealistic.
1053         // `balance` and `numberMinted` have a maximum limit of 2**64.
1054         // `tokenId` has a maximum limit of 2**256.
1055         unchecked {
1056             // Updates:
1057             // - `balance += quantity`.
1058             // - `numberMinted += quantity`.
1059             //
1060             // We can directly add to the `balance` and `numberMinted`.
1061             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1062 
1063             // Updates:
1064             // - `address` to the owner.
1065             // - `startTimestamp` to the timestamp of minting.
1066             // - `burned` to `false`.
1067             // - `nextInitialized` to `quantity == 1`.
1068             _packedOwnerships[startTokenId] = _packOwnershipData(
1069                 to,
1070                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1071             );
1072 
1073             uint256 tokenId = startTokenId;
1074             uint256 end = startTokenId + quantity;
1075             do {
1076                 emit Transfer(address(0), to, tokenId++);
1077             } while (tokenId < end);
1078 
1079             _currentIndex = end;
1080         }
1081         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1082     }
1083 
1084     /**
1085      * @dev Mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * This function is intended for efficient minting only during contract creation.
1088      *
1089      * It emits only one {ConsecutiveTransfer} as defined in
1090      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1091      * instead of a sequence of {Transfer} event(s).
1092      *
1093      * Calling this function outside of contract creation WILL make your contract
1094      * non-compliant with the ERC721 standard.
1095      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1096      * {ConsecutiveTransfer} event is only permissible during contract creation.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `quantity` must be greater than 0.
1102      *
1103      * Emits a {ConsecutiveTransfer} event.
1104      */
1105     function _mintERC2309(address to, uint256 quantity) internal {
1106         uint256 startTokenId = _currentIndex;
1107         if (to == address(0)) revert MintToZeroAddress();
1108         if (quantity == 0) revert MintZeroQuantity();
1109         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1110 
1111         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1112 
1113         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1114         unchecked {
1115             // Updates:
1116             // - `balance += quantity`.
1117             // - `numberMinted += quantity`.
1118             //
1119             // We can directly add to the `balance` and `numberMinted`.
1120             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1121 
1122             // Updates:
1123             // - `address` to the owner.
1124             // - `startTimestamp` to the timestamp of minting.
1125             // - `burned` to `false`.
1126             // - `nextInitialized` to `quantity == 1`.
1127             _packedOwnerships[startTokenId] = _packOwnershipData(
1128                 to,
1129                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1130             );
1131 
1132             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1133 
1134             _currentIndex = startTokenId + quantity;
1135         }
1136         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1137     }
1138 
1139     /**
1140      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1141      */
1142     function _getApprovedAddress(uint256 tokenId)
1143         private
1144         view
1145         returns (uint256 approvedAddressSlot, address approvedAddress)
1146     {
1147         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1148         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1149         assembly {
1150             // Compute the slot.
1151             mstore(0x00, tokenId)
1152             mstore(0x20, tokenApprovalsPtr.slot)
1153             approvedAddressSlot := keccak256(0x00, 0x40)
1154             // Load the slot's value from storage.
1155             approvedAddress := sload(approvedAddressSlot)
1156         }
1157     }
1158 
1159     /**
1160      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1161      */
1162     function _isOwnerOrApproved(
1163         address approvedAddress,
1164         address from,
1165         address msgSender
1166     ) private pure returns (bool result) {
1167         assembly {
1168             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1169             from := and(from, BITMASK_ADDRESS)
1170             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1171             msgSender := and(msgSender, BITMASK_ADDRESS)
1172             // `msgSender == from || msgSender == approvedAddress`.
1173             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1174         }
1175     }
1176 
1177     /**
1178      * @dev Transfers `tokenId` from `from` to `to`.
1179      *
1180      * Requirements:
1181      *
1182      * - `to` cannot be the zero address.
1183      * - `tokenId` token must be owned by `from`.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function transferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) public virtual override {
1192         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1193 
1194         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1195 
1196         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1197 
1198         // The nested ifs save around 20+ gas over a compound boolean condition.
1199         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1200             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1201 
1202         if (to == address(0)) revert TransferToZeroAddress();
1203 
1204         _beforeTokenTransfers(from, to, tokenId, 1);
1205 
1206         // Clear approvals from the previous owner.
1207         assembly {
1208             if approvedAddress {
1209                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1210                 sstore(approvedAddressSlot, 0)
1211             }
1212         }
1213 
1214         // Underflow of the sender's balance is impossible because we check for
1215         // ownership above and the recipient's balance can't realistically overflow.
1216         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1217         unchecked {
1218             // We can directly increment and decrement the balances.
1219             --_packedAddressData[from]; // Updates: `balance -= 1`.
1220             ++_packedAddressData[to]; // Updates: `balance += 1`.
1221 
1222             // Updates:
1223             // - `address` to the next owner.
1224             // - `startTimestamp` to the timestamp of transfering.
1225             // - `burned` to `false`.
1226             // - `nextInitialized` to `true`.
1227             _packedOwnerships[tokenId] = _packOwnershipData(
1228                 to,
1229                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1230             );
1231 
1232             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1233             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1234                 uint256 nextTokenId = tokenId + 1;
1235                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1236                 if (_packedOwnerships[nextTokenId] == 0) {
1237                     // If the next slot is within bounds.
1238                     if (nextTokenId != _currentIndex) {
1239                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1240                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1241                     }
1242                 }
1243             }
1244         }
1245 
1246         emit Transfer(from, to, tokenId);
1247         _afterTokenTransfers(from, to, tokenId, 1);
1248     }
1249 
1250     /**
1251      * @dev Equivalent to `_burn(tokenId, false)`.
1252      */
1253     function _burn(uint256 tokenId) internal virtual {
1254         _burn(tokenId, false);
1255     }
1256 
1257     /**
1258      * @dev Destroys `tokenId`.
1259      * The approval is cleared when the token is burned.
1260      *
1261      * Requirements:
1262      *
1263      * - `tokenId` must exist.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1268         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1269 
1270         address from = address(uint160(prevOwnershipPacked));
1271 
1272         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1273 
1274         if (approvalCheck) {
1275             // The nested ifs save around 20+ gas over a compound boolean condition.
1276             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1277                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1278         }
1279 
1280         _beforeTokenTransfers(from, address(0), tokenId, 1);
1281 
1282         // Clear approvals from the previous owner.
1283         assembly {
1284             if approvedAddress {
1285                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1286                 sstore(approvedAddressSlot, 0)
1287             }
1288         }
1289 
1290         // Underflow of the sender's balance is impossible because we check for
1291         // ownership above and the recipient's balance can't realistically overflow.
1292         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1293         unchecked {
1294             // Updates:
1295             // - `balance -= 1`.
1296             // - `numberBurned += 1`.
1297             //
1298             // We can directly decrement the balance, and increment the number burned.
1299             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1300             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1301 
1302             // Updates:
1303             // - `address` to the last owner.
1304             // - `startTimestamp` to the timestamp of burning.
1305             // - `burned` to `true`.
1306             // - `nextInitialized` to `true`.
1307             _packedOwnerships[tokenId] = _packOwnershipData(
1308                 from,
1309                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1310             );
1311 
1312             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1313             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1314                 uint256 nextTokenId = tokenId + 1;
1315                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1316                 if (_packedOwnerships[nextTokenId] == 0) {
1317                     // If the next slot is within bounds.
1318                     if (nextTokenId != _currentIndex) {
1319                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1320                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1321                     }
1322                 }
1323             }
1324         }
1325 
1326         emit Transfer(from, address(0), tokenId);
1327         _afterTokenTransfers(from, address(0), tokenId, 1);
1328 
1329         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1330         unchecked {
1331             _burnCounter++;
1332         }
1333     }
1334 
1335     /**
1336      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1337      *
1338      * @param from address representing the previous owner of the given token ID
1339      * @param to target address that will receive the tokens
1340      * @param tokenId uint256 ID of the token to be transferred
1341      * @param _data bytes optional data to send along with the call
1342      * @return bool whether the call correctly returned the expected magic value
1343      */
1344     function _checkContractOnERC721Received(
1345         address from,
1346         address to,
1347         uint256 tokenId,
1348         bytes memory _data
1349     ) private returns (bool) {
1350         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1351             bytes4 retval
1352         ) {
1353             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1354         } catch (bytes memory reason) {
1355             if (reason.length == 0) {
1356                 revert TransferToNonERC721ReceiverImplementer();
1357             } else {
1358                 assembly {
1359                     revert(add(32, reason), mload(reason))
1360                 }
1361             }
1362         }
1363     }
1364 
1365     /**
1366      * @dev Directly sets the extra data for the ownership data `index`.
1367      */
1368     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1369         uint256 packed = _packedOwnerships[index];
1370         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1371         uint256 extraDataCasted;
1372         // Cast `extraData` with assembly to avoid redundant masking.
1373         assembly {
1374             extraDataCasted := extraData
1375         }
1376         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1377         _packedOwnerships[index] = packed;
1378     }
1379 
1380     /**
1381      * @dev Returns the next extra data for the packed ownership data.
1382      * The returned result is shifted into position.
1383      */
1384     function _nextExtraData(
1385         address from,
1386         address to,
1387         uint256 prevOwnershipPacked
1388     ) private view returns (uint256) {
1389         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1390         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1391     }
1392 
1393     /**
1394      * @dev Called during each token transfer to set the 24bit `extraData` field.
1395      * Intended to be overridden by the cosumer contract.
1396      *
1397      * `previousExtraData` - the value of `extraData` before transfer.
1398      *
1399      * Calling conditions:
1400      *
1401      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1402      * transferred to `to`.
1403      * - When `from` is zero, `tokenId` will be minted for `to`.
1404      * - When `to` is zero, `tokenId` will be burned by `from`.
1405      * - `from` and `to` are never both zero.
1406      */
1407     function _extraData(
1408         address from,
1409         address to,
1410         uint24 previousExtraData
1411     ) internal view virtual returns (uint24) {}
1412 
1413     /**
1414      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1415      * This includes minting.
1416      * And also called before burning one token.
1417      *
1418      * startTokenId - the first token id to be transferred
1419      * quantity - the amount to be transferred
1420      *
1421      * Calling conditions:
1422      *
1423      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1424      * transferred to `to`.
1425      * - When `from` is zero, `tokenId` will be minted for `to`.
1426      * - When `to` is zero, `tokenId` will be burned by `from`.
1427      * - `from` and `to` are never both zero.
1428      */
1429     function _beforeTokenTransfers(
1430         address from,
1431         address to,
1432         uint256 startTokenId,
1433         uint256 quantity
1434     ) internal virtual {}
1435 
1436     /**
1437      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1438      * This includes minting.
1439      * And also called after one token has been burned.
1440      *
1441      * startTokenId - the first token id to be transferred
1442      * quantity - the amount to be transferred
1443      *
1444      * Calling conditions:
1445      *
1446      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1447      * transferred to `to`.
1448      * - When `from` is zero, `tokenId` has been minted for `to`.
1449      * - When `to` is zero, `tokenId` has been burned by `from`.
1450      * - `from` and `to` are never both zero.
1451      */
1452     function _afterTokenTransfers(
1453         address from,
1454         address to,
1455         uint256 startTokenId,
1456         uint256 quantity
1457     ) internal virtual {}
1458 
1459     /**
1460      * @dev Returns the message sender (defaults to `msg.sender`).
1461      *
1462      * If you are writing GSN compatible contracts, you need to override this function.
1463      */
1464     function _msgSenderERC721A() internal view virtual returns (address) {
1465         return msg.sender;
1466     }
1467 
1468     /**
1469      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1470      */
1471     function _toString(uint256 value) internal pure returns (string memory ptr) {
1472         assembly {
1473             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1474             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1475             // We will need 1 32-byte word to store the length,
1476             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1477             ptr := add(mload(0x40), 128)
1478             // Update the free memory pointer to allocate.
1479             mstore(0x40, ptr)
1480 
1481             // Cache the end of the memory to calculate the length later.
1482             let end := ptr
1483 
1484             // We write the string from the rightmost digit to the leftmost digit.
1485             // The following is essentially a do-while loop that also handles the zero case.
1486             // Costs a bit more than early returning for the zero case,
1487             // but cheaper in terms of deployment and overall runtime costs.
1488             for {
1489                 // Initialize and perform the first pass without check.
1490                 let temp := value
1491                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1492                 ptr := sub(ptr, 1)
1493                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1494                 mstore8(ptr, add(48, mod(temp, 10)))
1495                 temp := div(temp, 10)
1496             } temp {
1497                 // Keep dividing `temp` until zero.
1498                 temp := div(temp, 10)
1499             } {
1500                 // Body of the for loop.
1501                 ptr := sub(ptr, 1)
1502                 mstore8(ptr, add(48, mod(temp, 10)))
1503             }
1504 
1505             let length := sub(end, ptr)
1506             // Move the pointer 32 bytes leftwards to make room for the length.
1507             ptr := sub(ptr, 32)
1508             // Store the length.
1509             mstore(ptr, length)
1510         }
1511     }
1512 }
1513 
1514 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1515 
1516 
1517 // ERC721A Contracts v4.1.0
1518 // Creator: Chiru Labs
1519 
1520 pragma solidity ^0.8.4;
1521 
1522 
1523 /**
1524  * @dev Interface of an ERC721AQueryable compliant contract.
1525  */
1526 interface IERC721AQueryable is IERC721A {
1527     /**
1528      * Invalid query range (`start` >= `stop`).
1529      */
1530     error InvalidQueryRange();
1531 
1532     /**
1533      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1534      *
1535      * If the `tokenId` is out of bounds:
1536      *   - `addr` = `address(0)`
1537      *   - `startTimestamp` = `0`
1538      *   - `burned` = `false`
1539      *
1540      * If the `tokenId` is burned:
1541      *   - `addr` = `<Address of owner before token was burned>`
1542      *   - `startTimestamp` = `<Timestamp when token was burned>`
1543      *   - `burned = `true`
1544      *
1545      * Otherwise:
1546      *   - `addr` = `<Address of owner>`
1547      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1548      *   - `burned = `false`
1549      */
1550     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1551 
1552     /**
1553      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1554      * See {ERC721AQueryable-explicitOwnershipOf}
1555      */
1556     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1557 
1558     /**
1559      * @dev Returns an array of token IDs owned by `owner`,
1560      * in the range [`start`, `stop`)
1561      * (i.e. `start <= tokenId < stop`).
1562      *
1563      * This function allows for tokens to be queried if the collection
1564      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1565      *
1566      * Requirements:
1567      *
1568      * - `start` < `stop`
1569      */
1570     function tokensOfOwnerIn(
1571         address owner,
1572         uint256 start,
1573         uint256 stop
1574     ) external view returns (uint256[] memory);
1575 
1576     /**
1577      * @dev Returns an array of token IDs owned by `owner`.
1578      *
1579      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1580      * It is meant to be called off-chain.
1581      *
1582      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1583      * multiple smaller scans if the collection is large enough to cause
1584      * an out-of-gas error (10K pfp collections should be fine).
1585      */
1586     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1587 }
1588 
1589 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1590 
1591 
1592 // ERC721A Contracts v4.1.0
1593 // Creator: Chiru Labs
1594 
1595 pragma solidity ^0.8.4;
1596 
1597 
1598 
1599 /**
1600  * @title ERC721A Queryable
1601  * @dev ERC721A subclass with convenience query functions.
1602  */
1603 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1604     /**
1605      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1606      *
1607      * If the `tokenId` is out of bounds:
1608      *   - `addr` = `address(0)`
1609      *   - `startTimestamp` = `0`
1610      *   - `burned` = `false`
1611      *   - `extraData` = `0`
1612      *
1613      * If the `tokenId` is burned:
1614      *   - `addr` = `<Address of owner before token was burned>`
1615      *   - `startTimestamp` = `<Timestamp when token was burned>`
1616      *   - `burned = `true`
1617      *   - `extraData` = `<Extra data when token was burned>`
1618      *
1619      * Otherwise:
1620      *   - `addr` = `<Address of owner>`
1621      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1622      *   - `burned = `false`
1623      *   - `extraData` = `<Extra data at start of ownership>`
1624      */
1625     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1626         TokenOwnership memory ownership;
1627         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1628             return ownership;
1629         }
1630         ownership = _ownershipAt(tokenId);
1631         if (ownership.burned) {
1632             return ownership;
1633         }
1634         return _ownershipOf(tokenId);
1635     }
1636 
1637     /**
1638      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1639      * See {ERC721AQueryable-explicitOwnershipOf}
1640      */
1641     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1642         unchecked {
1643             uint256 tokenIdsLength = tokenIds.length;
1644             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1645             for (uint256 i; i != tokenIdsLength; ++i) {
1646                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1647             }
1648             return ownerships;
1649         }
1650     }
1651 
1652     /**
1653      * @dev Returns an array of token IDs owned by `owner`,
1654      * in the range [`start`, `stop`)
1655      * (i.e. `start <= tokenId < stop`).
1656      *
1657      * This function allows for tokens to be queried if the collection
1658      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1659      *
1660      * Requirements:
1661      *
1662      * - `start` < `stop`
1663      */
1664     function tokensOfOwnerIn(
1665         address owner,
1666         uint256 start,
1667         uint256 stop
1668     ) external view override returns (uint256[] memory) {
1669         unchecked {
1670             if (start >= stop) revert InvalidQueryRange();
1671             uint256 tokenIdsIdx;
1672             uint256 stopLimit = _nextTokenId();
1673             // Set `start = max(start, _startTokenId())`.
1674             if (start < _startTokenId()) {
1675                 start = _startTokenId();
1676             }
1677             // Set `stop = min(stop, stopLimit)`.
1678             if (stop > stopLimit) {
1679                 stop = stopLimit;
1680             }
1681             uint256 tokenIdsMaxLength = balanceOf(owner);
1682             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1683             // to cater for cases where `balanceOf(owner)` is too big.
1684             if (start < stop) {
1685                 uint256 rangeLength = stop - start;
1686                 if (rangeLength < tokenIdsMaxLength) {
1687                     tokenIdsMaxLength = rangeLength;
1688                 }
1689             } else {
1690                 tokenIdsMaxLength = 0;
1691             }
1692             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1693             if (tokenIdsMaxLength == 0) {
1694                 return tokenIds;
1695             }
1696             // We need to call `explicitOwnershipOf(start)`,
1697             // because the slot at `start` may not be initialized.
1698             TokenOwnership memory ownership = explicitOwnershipOf(start);
1699             address currOwnershipAddr;
1700             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1701             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1702             if (!ownership.burned) {
1703                 currOwnershipAddr = ownership.addr;
1704             }
1705             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1706                 ownership = _ownershipAt(i);
1707                 if (ownership.burned) {
1708                     continue;
1709                 }
1710                 if (ownership.addr != address(0)) {
1711                     currOwnershipAddr = ownership.addr;
1712                 }
1713                 if (currOwnershipAddr == owner) {
1714                     tokenIds[tokenIdsIdx++] = i;
1715                 }
1716             }
1717             // Downsize the array to fit.
1718             assembly {
1719                 mstore(tokenIds, tokenIdsIdx)
1720             }
1721             return tokenIds;
1722         }
1723     }
1724 
1725     /**
1726      * @dev Returns an array of token IDs owned by `owner`.
1727      *
1728      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1729      * It is meant to be called off-chain.
1730      *
1731      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1732      * multiple smaller scans if the collection is large enough to cause
1733      * an out-of-gas error (10K pfp collections should be fine).
1734      */
1735     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1736         unchecked {
1737             uint256 tokenIdsIdx;
1738             address currOwnershipAddr;
1739             uint256 tokenIdsLength = balanceOf(owner);
1740             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1741             TokenOwnership memory ownership;
1742             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1743                 ownership = _ownershipAt(i);
1744                 if (ownership.burned) {
1745                     continue;
1746                 }
1747                 if (ownership.addr != address(0)) {
1748                     currOwnershipAddr = ownership.addr;
1749                 }
1750                 if (currOwnershipAddr == owner) {
1751                     tokenIds[tokenIdsIdx++] = i;
1752                 }
1753             }
1754             return tokenIds;
1755         }
1756     }
1757 }
1758 
1759 
1760 
1761 pragma solidity >=0.8.9 <0.9.0;
1762 
1763 contract PixelKitaro is ERC721AQueryable, Ownable, ReentrancyGuard {
1764     using Strings for uint256;
1765 
1766     uint256 public maxSupply = 4000;
1767 	uint256 public Ownermint = 1;
1768     uint256 public maxPerAddress = 100;
1769 	uint256 public maxPerTX = 10;
1770     uint256 public cost = 0.002 ether;
1771 	mapping(address => bool) public freeMinted; 
1772 
1773     bool public paused = true;
1774 
1775 	string public uriPrefix = '';
1776     string public uriSuffix = '.json';
1777 	
1778   constructor(string memory baseURI) ERC721A("Pixel Kitaro", "PKIT") {
1779       setUriPrefix(baseURI); 
1780       _safeMint(_msgSender(), Ownermint);
1781 
1782   }
1783 
1784   modifier callerIsUser() {
1785         require(tx.origin == msg.sender, "The caller is another contract");
1786         _;
1787   }
1788 
1789   function numberMinted(address owner) public view returns (uint256) {
1790         return _numberMinted(owner);
1791   }
1792 
1793   function mint (uint256 _mintAmount) public payable nonReentrant callerIsUser{
1794         require(!paused, 'The contract is paused!');
1795         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1796         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1797         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1798 	if (freeMinted[_msgSender()]){
1799         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1800   }
1801     else{
1802 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1803         freeMinted[_msgSender()] = true;
1804   }
1805 
1806     _safeMint(_msgSender(), _mintAmount);
1807   }
1808 
1809   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1810     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1811     string memory currentBaseURI = _baseURI();
1812     return bytes(currentBaseURI).length > 0
1813         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1814         : '';
1815   }
1816 
1817   function unpause () public onlyOwner {
1818     paused = !paused;
1819   }
1820 
1821   function setCost(uint256 _cost) public onlyOwner {
1822     cost = _cost;
1823   }
1824 
1825   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1826     maxPerTX = _maxPerTX;
1827   }
1828 
1829   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1830     uriPrefix = _uriPrefix;
1831   }
1832  
1833   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1834     uriSuffix = _uriSuffix;
1835   }
1836 
1837   function withdraw() external onlyOwner {
1838         payable(msg.sender).transfer(address(this).balance);
1839   }
1840 
1841   function _startTokenId() internal view virtual override returns (uint256) {
1842     return 1;
1843   }
1844 
1845   function _baseURI() internal view virtual override returns (string memory) {
1846     return uriPrefix;
1847   }
1848 }