1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 
5  #######  ##       ######## ##     ## ######## ##    ## ########  ######  
6 ##     ## ##       ##       ###   ### ##       ###   ##    ##    ##    ## 
7 ##     ## ##       ##       #### #### ##       ####  ##    ##    ##       
8  #######  ##       ######   ## ### ## ######   ## ## ##    ##     ######  
9 ##     ## ##       ##       ##     ## ##       ##  ####    ##          ## 
10 ##     ## ##       ##       ##     ## ##       ##   ###    ##    ##    ## 
11  #######  ######## ######## ##     ## ######## ##    ##    ##     ######  
12 
13 */
14 
15 pragma solidity ^0.8.13;
16 
17 interface IOperatorFilterRegistry {
18     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
19     function register(address registrant) external;
20     function registerAndSubscribe(address registrant, address subscription) external;
21     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
22     function unregister(address addr) external;
23     function updateOperator(address registrant, address operator, bool filtered) external;
24     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
25     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
26     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
27     function subscribe(address registrant, address registrantToSubscribe) external;
28     function unsubscribe(address registrant, bool copyExistingEntries) external;
29     function subscriptionOf(address addr) external returns (address registrant);
30     function subscribers(address registrant) external returns (address[] memory);
31     function subscriberAt(address registrant, uint256 index) external returns (address);
32     function copyEntriesOf(address registrant, address registrantToCopy) external;
33     function isOperatorFiltered(address registrant, address operator) external returns (bool);
34     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
35     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
36     function filteredOperators(address addr) external returns (address[] memory);
37     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
38     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
39     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
40     function isRegistered(address addr) external returns (bool);
41     function codeHashOf(address addr) external returns (bytes32);
42 }
43 
44 pragma solidity ^0.8.13;
45 
46 /**
47  * @title  OperatorFilterer
48  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
49  *         registrant's entries in the OperatorFilterRegistry.
50  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
51  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
52  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
53  */
54 abstract contract OperatorFilterer {
55     error OperatorNotAllowed(address operator);
56 
57     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
58         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
59 
60     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
61         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
62         // will not revert, but the contract will need to be registered with the registry once it is deployed in
63         // order for the modifier to filter addresses.
64         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
65             if (subscribe) {
66                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
67             } else {
68                 if (subscriptionOrRegistrantToCopy != address(0)) {
69                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
70                 } else {
71                     OPERATOR_FILTER_REGISTRY.register(address(this));
72                 }
73             }
74         }
75     }
76 
77     modifier onlyAllowedOperator(address from) virtual {
78         // Allow spending tokens from addresses with balance
79         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
80         // from an EOA.
81         if (from != msg.sender) {
82             _checkFilterOperator(msg.sender);
83         }
84         _;
85     }
86 
87     modifier onlyAllowedOperatorApproval(address operator) virtual {
88         _checkFilterOperator(operator);
89         _;
90     }
91 
92     function _checkFilterOperator(address operator) internal view virtual {
93         // Check registry code length to facilitate testing in environments without a deployed registry.
94         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
95             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
96                 revert OperatorNotAllowed(operator);
97             }
98         }
99     }
100 }
101 
102 
103 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
104 
105 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Contract module that helps prevent reentrant calls to a function.
111  *
112  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
113  * available, which can be applied to functions to make sure there are no nested
114  * (reentrant) calls to them.
115  *
116  * Note that because there is a single `nonReentrant` guard, functions marked as
117  * `nonReentrant` may not call one another. This can be worked around by making
118  * those functions `private`, and then adding `external` `nonReentrant` entry
119  * points to them.
120  *
121  * TIP: If you would like to learn more about reentrancy and alternative ways
122  * to protect against it, check out our blog post
123  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
124  */
125 abstract contract ReentrancyGuard {
126     // Booleans are more expensive than uint256 or any type that takes up a full
127     // word because each write operation emits an extra SLOAD to first read the
128     // slot's contents, replace the bits taken up by the boolean, and then write
129     // back. This is the compiler's defense against contract upgrades and
130     // pointer aliasing, and it cannot be disabled.
131 
132     // The values being non-zero value makes deployment a bit more expensive,
133     // but in exchange the refund on every call to nonReentrant will be lower in
134     // amount. Since refunds are capped to a percentage of the total
135     // transaction's gas, it is best to keep them low in cases like this one, to
136     // increase the likelihood of the full refund coming into effect.
137     uint256 private constant _NOT_ENTERED = 1;
138     uint256 private constant _ENTERED = 2;
139 
140     uint256 private _status;
141 
142     constructor() {
143         _status = _NOT_ENTERED;
144     }
145 
146     /**
147      * @dev Prevents a contract from calling itself, directly or indirectly.
148      * Calling a `nonReentrant` function from another `nonReentrant`
149      * function is not supported. It is possible to prevent this from happening
150      * by making the `nonReentrant` function external, and making it call a
151      * `private` function that does the actual work.
152      */
153     modifier nonReentrant() {
154         // On the first call to nonReentrant, _notEntered will be true
155         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
156 
157         // Any calls to nonReentrant after this point will fail
158         _status = _ENTERED;
159 
160         _;
161 
162         // By storing the original value once again, a refund is triggered (see
163         // https://eips.ethereum.org/EIPS/eip-2200)
164         _status = _NOT_ENTERED;
165     }
166 }
167 
168 
169 
170 // File: @openzeppelin/contracts/utils/Strings.sol
171 
172 
173 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @dev String operations.
179  */
180 library Strings {
181     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
182     uint8 private constant _ADDRESS_LENGTH = 20;
183 
184     /**
185      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
186      */
187     function toString(uint256 value) internal pure returns (string memory) {
188         // Inspired by OraclizeAPI's implementation - MIT licence
189         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
190 
191         if (value == 0) {
192             return "0";
193         }
194         uint256 temp = value;
195         uint256 digits;
196         while (temp != 0) {
197             digits++;
198             temp /= 10;
199         }
200         bytes memory buffer = new bytes(digits);
201         while (value != 0) {
202             digits -= 1;
203             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
204             value /= 10;
205         }
206         return string(buffer);
207     }
208 
209     /**
210      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
211      */
212     function toHexString(uint256 value) internal pure returns (string memory) {
213         if (value == 0) {
214             return "0x00";
215         }
216         uint256 temp = value;
217         uint256 length = 0;
218         while (temp != 0) {
219             length++;
220             temp >>= 8;
221         }
222         return toHexString(value, length);
223     }
224 
225     /**
226      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
227      */
228     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
229         bytes memory buffer = new bytes(2 * length + 2);
230         buffer[0] = "0";
231         buffer[1] = "x";
232         for (uint256 i = 2 * length + 1; i > 1; --i) {
233             buffer[i] = _HEX_SYMBOLS[value & 0xf];
234             value >>= 4;
235         }
236         require(value == 0, "Strings: hex length insufficient");
237         return string(buffer);
238     }
239 
240     /**
241      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
242      */
243     function toHexString(address addr) internal pure returns (string memory) {
244         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Context.sol
249 
250 
251 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Provides information about the current execution context, including the
257  * sender of the transaction and its data. While these are generally available
258  * via msg.sender and msg.data, they should not be accessed in such a direct
259  * manner, since when dealing with meta-transactions the account sending and
260  * paying for execution may not be the actual sender (as far as an application
261  * is concerned).
262  *
263  * This contract is only required for intermediate, library-like contracts.
264  */
265 abstract contract Context {
266     function _msgSender() internal view virtual returns (address) {
267         return msg.sender;
268     }
269 
270     function _msgData() internal view virtual returns (bytes calldata) {
271         return msg.data;
272     }
273 }
274 
275 // File: @openzeppelin/contracts/access/Ownable.sol
276 
277 
278 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 
283 /**
284  * @dev Contract module which provides a basic access control mechanism, where
285  * there is an account (an owner) that can be granted exclusive access to
286  * specific functions.
287  *
288  * By default, the owner account will be the one that deploys the contract. This
289  * can later be changed with {transferOwnership}.
290  *
291  * This module is used through inheritance. It will make available the modifier
292  * `onlyOwner`, which can be applied to your functions to restrict their use to
293  * the owner.
294  */
295 abstract contract Ownable is Context {
296     address private _owner;
297 
298     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
299 
300     /**
301      * @dev Initializes the contract setting the deployer as the initial owner.
302      */
303     constructor() {
304         _transferOwnership(_msgSender());
305     }
306 
307     /**
308      * @dev Throws if called by any account other than the owner.
309      */
310     modifier onlyOwner() {
311         _checkOwner();
312         _;
313     }
314 
315     /**
316      * @dev Returns the address of the current owner.
317      */
318     function owner() public view virtual returns (address) {
319         return _owner;
320     }
321 
322     /**
323      * @dev Throws if the sender is not the owner.
324      */
325     function _checkOwner() internal view virtual {
326         require(owner() == _msgSender(), "Ownable: caller is not the owner");
327     }
328 
329     /**
330      * @dev Leaves the contract without owner. It will not be possible to call
331      * `onlyOwner` functions anymore. Can only be called by the current owner.
332      *
333      * NOTE: Renouncing ownership will leave the contract without an owner,
334      * thereby removing any functionality that is only available to the owner.
335      */
336     function renounceOwnership() public virtual onlyOwner {
337         _transferOwnership(address(0));
338     }
339 
340     /**
341      * @dev Transfers ownership of the contract to a new account (`newOwner`).
342      * Can only be called by the current owner.
343      */
344     function transferOwnership(address newOwner) public virtual onlyOwner {
345         require(newOwner != address(0), "Ownable: new owner is the zero address");
346         _transferOwnership(newOwner);
347     }
348 
349     /**
350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
351      * Internal function without access restriction.
352      */
353     function _transferOwnership(address newOwner) internal virtual {
354         address oldOwner = _owner;
355         _owner = newOwner;
356         emit OwnershipTransferred(oldOwner, newOwner);
357     }
358 }
359 
360 // File: erc721a/contracts/IERC721A.sol
361 
362 
363 // ERC721A Contracts v4.1.0
364 // Creator: Chiru Labs
365 
366 pragma solidity ^0.8.4;
367 
368 /**
369  * @dev Interface of an ERC721A compliant contract.
370  */
371 interface IERC721A {
372     /**
373      * The caller must own the token or be an approved operator.
374      */
375     error ApprovalCallerNotOwnerNorApproved();
376 
377     /**
378      * The token does not exist.
379      */
380     error ApprovalQueryForNonexistentToken();
381 
382     /**
383      * The caller cannot approve to their own address.
384      */
385     error ApproveToCaller();
386 
387     /**
388      * Cannot query the balance for the zero address.
389      */
390     error BalanceQueryForZeroAddress();
391 
392     /**
393      * Cannot mint to the zero address.
394      */
395     error MintToZeroAddress();
396 
397     /**
398      * The quantity of tokens minted must be more than zero.
399      */
400     error MintZeroQuantity();
401 
402     /**
403      * The token does not exist.
404      */
405     error OwnerQueryForNonexistentToken();
406 
407     /**
408      * The caller must own the token or be an approved operator.
409      */
410     error TransferCallerNotOwnerNorApproved();
411 
412     /**
413      * The token must be owned by `from`.
414      */
415     error TransferFromIncorrectOwner();
416 
417     /**
418      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
419      */
420     error TransferToNonERC721ReceiverImplementer();
421 
422     /**
423      * Cannot transfer to the zero address.
424      */
425     error TransferToZeroAddress();
426 
427     /**
428      * The token does not exist.
429      */
430     error URIQueryForNonexistentToken();
431 
432     /**
433      * The `quantity` minted with ERC2309 exceeds the safety limit.
434      */
435     error MintERC2309QuantityExceedsLimit();
436 
437     /**
438      * The `extraData` cannot be set on an unintialized ownership slot.
439      */
440     error OwnershipNotInitializedForExtraData();
441 
442     struct TokenOwnership {
443         // The address of the owner.
444         address addr;
445         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
446         uint64 startTimestamp;
447         // Whether the token has been burned.
448         bool burned;
449         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
450         uint24 extraData;
451     }
452 
453     /**
454      * @dev Returns the total amount of tokens stored by the contract.
455      *
456      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
457      */
458     function totalSupply() external view returns (uint256);
459 
460     // ==============================
461     //            IERC165
462     // ==============================
463 
464     /**
465      * @dev Returns true if this contract implements the interface defined by
466      * `interfaceId`. See the corresponding
467      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
468      * to learn more about how these ids are created.
469      *
470      * This function call must use less than 30 000 gas.
471      */
472     function supportsInterface(bytes4 interfaceId) external view returns (bool);
473 
474     // ==============================
475     //            IERC721
476     // ==============================
477 
478     /**
479      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
480      */
481     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
485      */
486     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
487 
488     /**
489      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
490      */
491     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
492 
493     /**
494      * @dev Returns the number of tokens in ``owner``'s account.
495      */
496     function balanceOf(address owner) external view returns (uint256 balance);
497 
498     /**
499      * @dev Returns the owner of the `tokenId` token.
500      *
501      * Requirements:
502      *
503      * - `tokenId` must exist.
504      */
505     function ownerOf(uint256 tokenId) external view returns (address owner);
506 
507     /**
508      * @dev Safely transfers `tokenId` token from `from` to `to`.
509      *
510      * Requirements:
511      *
512      * - `from` cannot be the zero address.
513      * - `to` cannot be the zero address.
514      * - `tokenId` token must exist and be owned by `from`.
515      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
516      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
517      *
518      * Emits a {Transfer} event.
519      */
520     function safeTransferFrom(
521         address from,
522         address to,
523         uint256 tokenId,
524         bytes calldata data
525     ) external;
526 
527     /**
528      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
529      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
537      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
538      *
539      * Emits a {Transfer} event.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external;
546 
547     /**
548      * @dev Transfers `tokenId` token from `from` to `to`.
549      *
550      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) external;
566 
567     /**
568      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
569      * The approval is cleared when the token is transferred.
570      *
571      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
572      *
573      * Requirements:
574      *
575      * - The caller must own the token or be an approved operator.
576      * - `tokenId` must exist.
577      *
578      * Emits an {Approval} event.
579      */
580     function approve(address to, uint256 tokenId) external;
581 
582     /**
583      * @dev Approve or remove `operator` as an operator for the caller.
584      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
585      *
586      * Requirements:
587      *
588      * - The `operator` cannot be the caller.
589      *
590      * Emits an {ApprovalForAll} event.
591      */
592     function setApprovalForAll(address operator, bool _approved) external;
593 
594     /**
595      * @dev Returns the account approved for `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function getApproved(uint256 tokenId) external view returns (address operator);
602 
603     /**
604      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
605      *
606      * See {setApprovalForAll}
607      */
608     function isApprovedForAll(address owner, address operator) external view returns (bool);
609 
610     // ==============================
611     //        IERC721Metadata
612     // ==============================
613 
614     /**
615      * @dev Returns the token collection name.
616      */
617     function name() external view returns (string memory);
618 
619     /**
620      * @dev Returns the token collection symbol.
621      */
622     function symbol() external view returns (string memory);
623 
624     /**
625      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
626      */
627     function tokenURI(uint256 tokenId) external view returns (string memory);
628 
629     // ==============================
630     //            IERC2309
631     // ==============================
632 
633     /**
634      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
635      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
636      */
637     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
638 }
639 
640 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
641 
642 
643 // ERC721A Contracts v4.1.0
644 // Creator: Chiru Labs
645 
646 pragma solidity ^0.8.4;
647 
648 
649 /**
650  * @dev Interface of an ERC721ABurnable compliant contract.
651  */
652 interface IERC721ABurnable is IERC721A {
653     /**
654      * @dev Burns `tokenId`. See {ERC721A-_burn}.
655      *
656      * Requirements:
657      *
658      * - The caller must own `tokenId` or be an approved operator.
659      */
660     function burn(uint256 tokenId) external;
661 }
662 
663 // File: erc721a/contracts/ERC721A.sol
664 
665 
666 // ERC721A Contracts v4.1.0
667 // Creator: Chiru Labs
668 
669 pragma solidity ^0.8.4;
670 
671 
672 /**
673  * @dev ERC721 token receiver interface.
674  */
675 interface ERC721A__IERC721Receiver {
676     function onERC721Received(
677         address operator,
678         address from,
679         uint256 tokenId,
680         bytes calldata data
681     ) external returns (bytes4);
682 }
683 
684 /**
685  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
686  * including the Metadata extension. Built to optimize for lower gas during batch mints.
687  *
688  * Assumes serials are sequentially minted starting at `_startTokenId()`
689  * (defaults to 0, e.g. 0, 1, 2, 3..).
690  *
691  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
692  *
693  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
694  */
695 contract ERC721A is IERC721A {
696     // Mask of an entry in packed address data.
697     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
698 
699     // The bit position of `numberMinted` in packed address data.
700     uint256 private constant BITPOS_NUMBER_MINTED = 64;
701 
702     // The bit position of `numberBurned` in packed address data.
703     uint256 private constant BITPOS_NUMBER_BURNED = 128;
704 
705     // The bit position of `aux` in packed address data.
706     uint256 private constant BITPOS_AUX = 192;
707 
708     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
709     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
710 
711     // The bit position of `startTimestamp` in packed ownership.
712     uint256 private constant BITPOS_START_TIMESTAMP = 160;
713 
714     // The bit mask of the `burned` bit in packed ownership.
715     uint256 private constant BITMASK_BURNED = 1 << 224;
716 
717     // The bit position of the `nextInitialized` bit in packed ownership.
718     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
719 
720     // The bit mask of the `nextInitialized` bit in packed ownership.
721     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
722 
723     // The bit position of `extraData` in packed ownership.
724     uint256 private constant BITPOS_EXTRA_DATA = 232;
725 
726     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
727     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
728 
729     // The mask of the lower 160 bits for addresses.
730     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
731 
732     // The maximum `quantity` that can be minted with `_mintERC2309`.
733     // This limit is to prevent overflows on the address data entries.
734     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
735     // is required to cause an overflow, which is unrealistic.
736     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
737 
738     // The tokenId of the next token to be minted.
739     uint256 private _currentIndex;
740 
741     // The number of tokens burned.
742     uint256 private _burnCounter;
743 
744     // Token name
745     string private _name;
746 
747     // Token symbol
748     string private _symbol;
749 
750     // Mapping from token ID to ownership details
751     // An empty struct value does not necessarily mean the token is unowned.
752     // See `_packedOwnershipOf` implementation for details.
753     //
754     // Bits Layout:
755     // - [0..159]   `addr`
756     // - [160..223] `startTimestamp`
757     // - [224]      `burned`
758     // - [225]      `nextInitialized`
759     // - [232..255] `extraData`
760     mapping(uint256 => uint256) private _packedOwnerships;
761 
762     // Mapping owner address to address data.
763     //
764     // Bits Layout:
765     // - [0..63]    `balance`
766     // - [64..127]  `numberMinted`
767     // - [128..191] `numberBurned`
768     // - [192..255] `aux`
769     mapping(address => uint256) private _packedAddressData;
770 
771     // Mapping from token ID to approved address.
772     mapping(uint256 => address) private _tokenApprovals;
773 
774     // Mapping from owner to operator approvals
775     mapping(address => mapping(address => bool)) private _operatorApprovals;
776 
777     constructor(string memory name_, string memory symbol_) {
778         _name = name_;
779         _symbol = symbol_;
780         _currentIndex = _startTokenId();
781     }
782 
783     /**
784      * @dev Returns the starting token ID.
785      * To change the starting token ID, please override this function.
786      */
787     function _startTokenId() internal view virtual returns (uint256) {
788         return 0;
789     }
790 
791     /**
792      * @dev Returns the next token ID to be minted.
793      */
794     function _nextTokenId() internal view returns (uint256) {
795         return _currentIndex;
796     }
797 
798     /**
799      * @dev Returns the total number of tokens in existence.
800      * Burned tokens will reduce the count.
801      * To get the total number of tokens minted, please see `_totalMinted`.
802      */
803     function totalSupply() public view override returns (uint256) {
804         // Counter underflow is impossible as _burnCounter cannot be incremented
805         // more than `_currentIndex - _startTokenId()` times.
806         unchecked {
807             return _currentIndex - _burnCounter - _startTokenId();
808         }
809     }
810 
811     /**
812      * @dev Returns the total amount of tokens minted in the contract.
813      */
814     function _totalMinted() internal view returns (uint256) {
815         // Counter underflow is impossible as _currentIndex does not decrement,
816         // and it is initialized to `_startTokenId()`
817         unchecked {
818             return _currentIndex - _startTokenId();
819         }
820     }
821 
822     /**
823      * @dev Returns the total number of tokens burned.
824      */
825     function _totalBurned() internal view returns (uint256) {
826         return _burnCounter;
827     }
828 
829     /**
830      * @dev See {IERC165-supportsInterface}.
831      */
832     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
833         // The interface IDs are constants representing the first 4 bytes of the XOR of
834         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
835         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
836         return
837             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
838             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
839             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
840     }
841 
842     /**
843      * @dev See {IERC721-balanceOf}.
844      */
845     function balanceOf(address owner) public view override returns (uint256) {
846         if (owner == address(0)) revert BalanceQueryForZeroAddress();
847         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
848     }
849 
850     /**
851      * Returns the number of tokens minted by `owner`.
852      */
853     function _numberMinted(address owner) internal view returns (uint256) {
854         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
855     }
856 
857     /**
858      * Returns the number of tokens burned by or on behalf of `owner`.
859      */
860     function _numberBurned(address owner) internal view returns (uint256) {
861         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
862     }
863 
864     /**
865      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
866      */
867     function _getAux(address owner) internal view returns (uint64) {
868         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
869     }
870 
871     /**
872      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
873      * If there are multiple variables, please pack them into a uint64.
874      */
875     function _setAux(address owner, uint64 aux) internal {
876         uint256 packed = _packedAddressData[owner];
877         uint256 auxCasted;
878         // Cast `aux` with assembly to avoid redundant masking.
879         assembly {
880             auxCasted := aux
881         }
882         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
883         _packedAddressData[owner] = packed;
884     }
885 
886     /**
887      * Returns the packed ownership data of `tokenId`.
888      */
889     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
890         uint256 curr = tokenId;
891 
892         unchecked {
893             if (_startTokenId() <= curr)
894                 if (curr < _currentIndex) {
895                     uint256 packed = _packedOwnerships[curr];
896                     // If not burned.
897                     if (packed & BITMASK_BURNED == 0) {
898                         // Invariant:
899                         // There will always be an ownership that has an address and is not burned
900                         // before an ownership that does not have an address and is not burned.
901                         // Hence, curr will not underflow.
902                         //
903                         // We can directly compare the packed value.
904                         // If the address is zero, packed is zero.
905                         while (packed == 0) {
906                             packed = _packedOwnerships[--curr];
907                         }
908                         return packed;
909                     }
910                 }
911         }
912         revert OwnerQueryForNonexistentToken();
913     }
914 
915     /**
916      * Returns the unpacked `TokenOwnership` struct from `packed`.
917      */
918     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
919         ownership.addr = address(uint160(packed));
920         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
921         ownership.burned = packed & BITMASK_BURNED != 0;
922         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
923     }
924 
925     /**
926      * Returns the unpacked `TokenOwnership` struct at `index`.
927      */
928     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
929         return _unpackedOwnership(_packedOwnerships[index]);
930     }
931 
932     /**
933      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
934      */
935     function _initializeOwnershipAt(uint256 index) internal {
936         if (_packedOwnerships[index] == 0) {
937             _packedOwnerships[index] = _packedOwnershipOf(index);
938         }
939     }
940 
941     /**
942      * Gas spent here starts off proportional to the maximum mint batch size.
943      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
944      */
945     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
946         return _unpackedOwnership(_packedOwnershipOf(tokenId));
947     }
948 
949     /**
950      * @dev Packs ownership data into a single uint256.
951      */
952     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
953         assembly {
954             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
955             owner := and(owner, BITMASK_ADDRESS)
956             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
957             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
958         }
959     }
960 
961     /**
962      * @dev See {IERC721-ownerOf}.
963      */
964     function ownerOf(uint256 tokenId) public view override returns (address) {
965         return address(uint160(_packedOwnershipOf(tokenId)));
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-name}.
970      */
971     function name() public view virtual override returns (string memory) {
972         return _name;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-symbol}.
977      */
978     function symbol() public view virtual override returns (string memory) {
979         return _symbol;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-tokenURI}.
984      */
985     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
986         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
987 
988         string memory baseURI = _baseURI();
989         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
990     }
991 
992     /**
993      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
994      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
995      * by default, it can be overridden in child contracts.
996      */
997     function _baseURI() internal view virtual returns (string memory) {
998         return '';
999     }
1000 
1001     /**
1002      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1003      */
1004     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1005         // For branchless setting of the `nextInitialized` flag.
1006         assembly {
1007             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1008             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1009         }
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-approve}.
1014      */
1015     function approve(address to, uint256 tokenId) virtual public override {
1016         address owner = ownerOf(tokenId);
1017 
1018         if (_msgSenderERC721A() != owner)
1019             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1020                 revert ApprovalCallerNotOwnerNorApproved();
1021             }
1022 
1023         _tokenApprovals[tokenId] = to;
1024         emit Approval(owner, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-getApproved}.
1029      */
1030     function getApproved(uint256 tokenId) public view override returns (address) {
1031         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1032 
1033         return _tokenApprovals[tokenId];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-setApprovalForAll}.
1038      */
1039     function setApprovalForAll(address operator, bool approved) public virtual override {
1040         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1041 
1042         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1043         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-isApprovedForAll}.
1048      */
1049     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1050         return _operatorApprovals[owner][operator];
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-safeTransferFrom}.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) public virtual override {
1061         safeTransferFrom(from, to, tokenId, '');
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-safeTransferFrom}.
1066      */
1067     function safeTransferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) public virtual override {
1073         transferFrom(from, to, tokenId);
1074         if (to.code.length != 0)
1075             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1076                 revert TransferToNonERC721ReceiverImplementer();
1077             }
1078     }
1079 
1080     /**
1081      * @dev Returns whether `tokenId` exists.
1082      *
1083      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1084      *
1085      * Tokens start existing when they are minted (`_mint`),
1086      */
1087     function _exists(uint256 tokenId) internal view returns (bool) {
1088         return
1089             _startTokenId() <= tokenId &&
1090             tokenId < _currentIndex && // If within bounds,
1091             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1092     }
1093 
1094     /**
1095      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1096      */
1097     function _safeMint(address to, uint256 quantity) internal {
1098         _safeMint(to, quantity, '');
1099     }
1100 
1101     /**
1102      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - If `to` refers to a smart contract, it must implement
1107      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1108      * - `quantity` must be greater than 0.
1109      *
1110      * See {_mint}.
1111      *
1112      * Emits a {Transfer} event for each mint.
1113      */
1114     function _safeMint(
1115         address to,
1116         uint256 quantity,
1117         bytes memory _data
1118     ) internal {
1119         _mint(to, quantity);
1120 
1121         unchecked {
1122             if (to.code.length != 0) {
1123                 uint256 end = _currentIndex;
1124                 uint256 index = end - quantity;
1125                 do {
1126                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1127                         revert TransferToNonERC721ReceiverImplementer();
1128                     }
1129                 } while (index < end);
1130                 // Reentrancy protection.
1131                 if (_currentIndex != end) revert();
1132             }
1133         }
1134     }
1135 
1136     /**
1137      * @dev Mints `quantity` tokens and transfers them to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `quantity` must be greater than 0.
1143      *
1144      * Emits a {Transfer} event for each mint.
1145      */
1146     function _mint(address to, uint256 quantity) internal {
1147         uint256 startTokenId = _currentIndex;
1148         if (to == address(0)) revert MintToZeroAddress();
1149         if (quantity == 0) revert MintZeroQuantity();
1150 
1151         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1152 
1153         // Overflows are incredibly unrealistic.
1154         // `balance` and `numberMinted` have a maximum limit of 2**64.
1155         // `tokenId` has a maximum limit of 2**256.
1156         unchecked {
1157             // Updates:
1158             // - `balance += quantity`.
1159             // - `numberMinted += quantity`.
1160             //
1161             // We can directly add to the `balance` and `numberMinted`.
1162             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1163 
1164             // Updates:
1165             // - `address` to the owner.
1166             // - `startTimestamp` to the timestamp of minting.
1167             // - `burned` to `false`.
1168             // - `nextInitialized` to `quantity == 1`.
1169             _packedOwnerships[startTokenId] = _packOwnershipData(
1170                 to,
1171                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1172             );
1173 
1174             uint256 tokenId = startTokenId;
1175             uint256 end = startTokenId + quantity;
1176             do {
1177                 emit Transfer(address(0), to, tokenId++);
1178             } while (tokenId < end);
1179 
1180             _currentIndex = end;
1181         }
1182         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1183     }
1184 
1185     /**
1186      * @dev Mints `quantity` tokens and transfers them to `to`.
1187      *
1188      * This function is intended for efficient minting only during contract creation.
1189      *
1190      * It emits only one {ConsecutiveTransfer} as defined in
1191      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1192      * instead of a sequence of {Transfer} event(s).
1193      *
1194      * Calling this function outside of contract creation WILL make your contract
1195      * non-compliant with the ERC721 standard.
1196      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1197      * {ConsecutiveTransfer} event is only permissible during contract creation.
1198      *
1199      * Requirements:
1200      *
1201      * - `to` cannot be the zero address.
1202      * - `quantity` must be greater than 0.
1203      *
1204      * Emits a {ConsecutiveTransfer} event.
1205      */
1206     function _mintERC2309(address to, uint256 quantity) internal {
1207         uint256 startTokenId = _currentIndex;
1208         if (to == address(0)) revert MintToZeroAddress();
1209         if (quantity == 0) revert MintZeroQuantity();
1210         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1211 
1212         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1213 
1214         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1215         unchecked {
1216             // Updates:
1217             // - `balance += quantity`.
1218             // - `numberMinted += quantity`.
1219             //
1220             // We can directly add to the `balance` and `numberMinted`.
1221             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1222 
1223             // Updates:
1224             // - `address` to the owner.
1225             // - `startTimestamp` to the timestamp of minting.
1226             // - `burned` to `false`.
1227             // - `nextInitialized` to `quantity == 1`.
1228             _packedOwnerships[startTokenId] = _packOwnershipData(
1229                 to,
1230                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1231             );
1232 
1233             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1234 
1235             _currentIndex = startTokenId + quantity;
1236         }
1237         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1238     }
1239 
1240     /**
1241      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1242      */
1243     function _getApprovedAddress(uint256 tokenId)
1244         private
1245         view
1246         returns (uint256 approvedAddressSlot, address approvedAddress)
1247     {
1248         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1249         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1250         assembly {
1251             // Compute the slot.
1252             mstore(0x00, tokenId)
1253             mstore(0x20, tokenApprovalsPtr.slot)
1254             approvedAddressSlot := keccak256(0x00, 0x40)
1255             // Load the slot's value from storage.
1256             approvedAddress := sload(approvedAddressSlot)
1257         }
1258     }
1259 
1260     /**
1261      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1262      */
1263     function _isOwnerOrApproved(
1264         address approvedAddress,
1265         address from,
1266         address msgSender
1267     ) private pure returns (bool result) {
1268         assembly {
1269             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1270             from := and(from, BITMASK_ADDRESS)
1271             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1272             msgSender := and(msgSender, BITMASK_ADDRESS)
1273             // `msgSender == from || msgSender == approvedAddress`.
1274             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1275         }
1276     }
1277 
1278     /**
1279      * @dev Transfers `tokenId` from `from` to `to`.
1280      *
1281      * Requirements:
1282      *
1283      * - `to` cannot be the zero address.
1284      * - `tokenId` token must be owned by `from`.
1285      *
1286      * Emits a {Transfer} event.
1287      */
1288     function transferFrom(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) public virtual override {
1293         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1294 
1295         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1296 
1297         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1298 
1299         // The nested ifs save around 20+ gas over a compound boolean condition.
1300         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1301             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1302 
1303         if (to == address(0)) revert TransferToZeroAddress();
1304 
1305         _beforeTokenTransfers(from, to, tokenId, 1);
1306 
1307         // Clear approvals from the previous owner.
1308         assembly {
1309             if approvedAddress {
1310                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1311                 sstore(approvedAddressSlot, 0)
1312             }
1313         }
1314 
1315         // Underflow of the sender's balance is impossible because we check for
1316         // ownership above and the recipient's balance can't realistically overflow.
1317         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1318         unchecked {
1319             // We can directly increment and decrement the balances.
1320             --_packedAddressData[from]; // Updates: `balance -= 1`.
1321             ++_packedAddressData[to]; // Updates: `balance += 1`.
1322 
1323             // Updates:
1324             // - `address` to the next owner.
1325             // - `startTimestamp` to the timestamp of transfering.
1326             // - `burned` to `false`.
1327             // - `nextInitialized` to `true`.
1328             _packedOwnerships[tokenId] = _packOwnershipData(
1329                 to,
1330                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1331             );
1332 
1333             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1334             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1335                 uint256 nextTokenId = tokenId + 1;
1336                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1337                 if (_packedOwnerships[nextTokenId] == 0) {
1338                     // If the next slot is within bounds.
1339                     if (nextTokenId != _currentIndex) {
1340                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1341                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1342                     }
1343                 }
1344             }
1345         }
1346 
1347         emit Transfer(from, to, tokenId);
1348         _afterTokenTransfers(from, to, tokenId, 1);
1349     }
1350 
1351     /**
1352      * @dev Equivalent to `_burn(tokenId, false)`.
1353      */
1354     function _burn(uint256 tokenId) internal virtual {
1355         _burn(tokenId, false);
1356     }
1357 
1358     /**
1359      * @dev Destroys `tokenId`.
1360      * The approval is cleared when the token is burned.
1361      *
1362      * Requirements:
1363      *
1364      * - `tokenId` must exist.
1365      *
1366      * Emits a {Transfer} event.
1367      */
1368     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1369         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1370 
1371         address from = address(uint160(prevOwnershipPacked));
1372 
1373         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1374 
1375         if (approvalCheck) {
1376             // The nested ifs save around 20+ gas over a compound boolean condition.
1377             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1378                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1379         }
1380 
1381         _beforeTokenTransfers(from, address(0), tokenId, 1);
1382 
1383         // Clear approvals from the previous owner.
1384         assembly {
1385             if approvedAddress {
1386                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1387                 sstore(approvedAddressSlot, 0)
1388             }
1389         }
1390 
1391         // Underflow of the sender's balance is impossible because we check for
1392         // ownership above and the recipient's balance can't realistically overflow.
1393         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1394         unchecked {
1395             // Updates:
1396             // - `balance -= 1`.
1397             // - `numberBurned += 1`.
1398             //
1399             // We can directly decrement the balance, and increment the number burned.
1400             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1401             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1402 
1403             // Updates:
1404             // - `address` to the last owner.
1405             // - `startTimestamp` to the timestamp of burning.
1406             // - `burned` to `true`.
1407             // - `nextInitialized` to `true`.
1408             _packedOwnerships[tokenId] = _packOwnershipData(
1409                 from,
1410                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1411             );
1412 
1413             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1414             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1415                 uint256 nextTokenId = tokenId + 1;
1416                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1417                 if (_packedOwnerships[nextTokenId] == 0) {
1418                     // If the next slot is within bounds.
1419                     if (nextTokenId != _currentIndex) {
1420                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1421                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1422                     }
1423                 }
1424             }
1425         }
1426 
1427         emit Transfer(from, address(0), tokenId);
1428         _afterTokenTransfers(from, address(0), tokenId, 1);
1429 
1430         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1431         unchecked {
1432             _burnCounter++;
1433         }
1434     }
1435 
1436     /**
1437      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1438      *
1439      * @param from address representing the previous owner of the given token ID
1440      * @param to target address that will receive the tokens
1441      * @param tokenId uint256 ID of the token to be transferred
1442      * @param _data bytes optional data to send along with the call
1443      * @return bool whether the call correctly returned the expected magic value
1444      */
1445     function _checkContractOnERC721Received(
1446         address from,
1447         address to,
1448         uint256 tokenId,
1449         bytes memory _data
1450     ) private returns (bool) {
1451         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1452             bytes4 retval
1453         ) {
1454             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1455         } catch (bytes memory reason) {
1456             if (reason.length == 0) {
1457                 revert TransferToNonERC721ReceiverImplementer();
1458             } else {
1459                 assembly {
1460                     revert(add(32, reason), mload(reason))
1461                 }
1462             }
1463         }
1464     }
1465 
1466     /**
1467      * @dev Directly sets the extra data for the ownership data `index`.
1468      */
1469     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1470         uint256 packed = _packedOwnerships[index];
1471         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1472         uint256 extraDataCasted;
1473         // Cast `extraData` with assembly to avoid redundant masking.
1474         assembly {
1475             extraDataCasted := extraData
1476         }
1477         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1478         _packedOwnerships[index] = packed;
1479     }
1480 
1481     /**
1482      * @dev Returns the next extra data for the packed ownership data.
1483      * The returned result is shifted into position.
1484      */
1485     function _nextExtraData(
1486         address from,
1487         address to,
1488         uint256 prevOwnershipPacked
1489     ) private view returns (uint256) {
1490         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1491         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1492     }
1493 
1494     /**
1495      * @dev Called during each token transfer to set the 24bit `extraData` field.
1496      * Intended to be overridden by the cosumer contract.
1497      *
1498      * `previousExtraData` - the value of `extraData` before transfer.
1499      *
1500      * Calling conditions:
1501      *
1502      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1503      * transferred to `to`.
1504      * - When `from` is zero, `tokenId` will be minted for `to`.
1505      * - When `to` is zero, `tokenId` will be burned by `from`.
1506      * - `from` and `to` are never both zero.
1507      */
1508     function _extraData(
1509         address from,
1510         address to,
1511         uint24 previousExtraData
1512     ) internal view virtual returns (uint24) {}
1513 
1514     /**
1515      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1516      * This includes minting.
1517      * And also called before burning one token.
1518      *
1519      * startTokenId - the first token id to be transferred
1520      * quantity - the amount to be transferred
1521      *
1522      * Calling conditions:
1523      *
1524      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1525      * transferred to `to`.
1526      * - When `from` is zero, `tokenId` will be minted for `to`.
1527      * - When `to` is zero, `tokenId` will be burned by `from`.
1528      * - `from` and `to` are never both zero.
1529      */
1530     function _beforeTokenTransfers(
1531         address from,
1532         address to,
1533         uint256 startTokenId,
1534         uint256 quantity
1535     ) internal virtual {}
1536 
1537     /**
1538      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1539      * This includes minting.
1540      * And also called after one token has been burned.
1541      *
1542      * startTokenId - the first token id to be transferred
1543      * quantity - the amount to be transferred
1544      *
1545      * Calling conditions:
1546      *
1547      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1548      * transferred to `to`.
1549      * - When `from` is zero, `tokenId` has been minted for `to`.
1550      * - When `to` is zero, `tokenId` has been burned by `from`.
1551      * - `from` and `to` are never both zero.
1552      */
1553     function _afterTokenTransfers(
1554         address from,
1555         address to,
1556         uint256 startTokenId,
1557         uint256 quantity
1558     ) internal virtual {}
1559 
1560     /**
1561      * @dev Returns the message sender (defaults to `msg.sender`).
1562      *
1563      * If you are writing GSN compatible contracts, you need to override this function.
1564      */
1565     function _msgSenderERC721A() internal view virtual returns (address) {
1566         return msg.sender;
1567     }
1568 
1569     /**
1570      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1571      */
1572     function _toString(uint256 value) internal pure returns (string memory ptr) {
1573         assembly {
1574             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1575             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1576             // We will need 1 32-byte word to store the length,
1577             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1578             ptr := add(mload(0x40), 128)
1579             // Update the free memory pointer to allocate.
1580             mstore(0x40, ptr)
1581 
1582             // Cache the end of the memory to calculate the length later.
1583             let end := ptr
1584 
1585             // We write the string from the rightmost digit to the leftmost digit.
1586             // The following is essentially a do-while loop that also handles the zero case.
1587             // Costs a bit more than early returning for the zero case,
1588             // but cheaper in terms of deployment and overall runtime costs.
1589             for {
1590                 // Initialize and perform the first pass without check.
1591                 let temp := value
1592                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1593                 ptr := sub(ptr, 1)
1594                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1595                 mstore8(ptr, add(48, mod(temp, 10)))
1596                 temp := div(temp, 10)
1597             } temp {
1598                 // Keep dividing `temp` until zero.
1599                 temp := div(temp, 10)
1600             } {
1601                 // Body of the for loop.
1602                 ptr := sub(ptr, 1)
1603                 mstore8(ptr, add(48, mod(temp, 10)))
1604             }
1605 
1606             let length := sub(end, ptr)
1607             // Move the pointer 32 bytes leftwards to make room for the length.
1608             ptr := sub(ptr, 32)
1609             // Store the length.
1610             mstore(ptr, length)
1611         }
1612     }
1613 }
1614 
1615 
1616 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1617 
1618 
1619 // ERC721A Contracts v4.1.0
1620 // Creator: Chiru Labs
1621 
1622 pragma solidity ^0.8.4;
1623 
1624 
1625 /**
1626  * @dev Interface of an ERC721AQueryable compliant contract.
1627  */
1628 interface IERC721AQueryable is IERC721A {
1629     /**
1630      * Invalid query range (`start` >= `stop`).
1631      */
1632     error InvalidQueryRange();
1633 
1634     /**
1635      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1636      *
1637      * If the `tokenId` is out of bounds:
1638      *   - `addr` = `address(0)`
1639      *   - `startTimestamp` = `0`
1640      *   - `burned` = `false`
1641      *
1642      * If the `tokenId` is burned:
1643      *   - `addr` = `<Address of owner before token was burned>`
1644      *   - `startTimestamp` = `<Timestamp when token was burned>`
1645      *   - `burned = `true`
1646      *
1647      * Otherwise:
1648      *   - `addr` = `<Address of owner>`
1649      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1650      *   - `burned = `false`
1651      */
1652     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1653 
1654     /**
1655      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1656      * See {ERC721AQueryable-explicitOwnershipOf}
1657      */
1658     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1659 
1660     /**
1661      * @dev Returns an array of token IDs owned by `owner`,
1662      * in the range [`start`, `stop`)
1663      * (i.e. `start <= tokenId < stop`).
1664      *
1665      * This function allows for tokens to be queried if the collection
1666      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1667      *
1668      * Requirements:
1669      *
1670      * - `start` < `stop`
1671      */
1672     function tokensOfOwnerIn(
1673         address owner,
1674         uint256 start,
1675         uint256 stop
1676     ) external view returns (uint256[] memory);
1677 
1678     /**
1679      * @dev Returns an array of token IDs owned by `owner`.
1680      *
1681      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1682      * It is meant to be called off-chain.
1683      *
1684      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1685      * multiple smaller scans if the collection is large enough to cause
1686      * an out-of-gas error (10K pfp collections should be fine).
1687      */
1688     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1689 }
1690 
1691 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1692 
1693 
1694 // ERC721A Contracts v4.1.0
1695 // Creator: Chiru Labs
1696 
1697 pragma solidity ^0.8.4;
1698 
1699 
1700 
1701 /**
1702  * @title ERC721A Queryable
1703  * @dev ERC721A subclass with convenience query functions.
1704  */
1705 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1706     /**
1707      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1708      *
1709      * If the `tokenId` is out of bounds:
1710      *   - `addr` = `address(0)`
1711      *   - `startTimestamp` = `0`
1712      *   - `burned` = `false`
1713      *   - `extraData` = `0`
1714      *
1715      * If the `tokenId` is burned:
1716      *   - `addr` = `<Address of owner before token was burned>`
1717      *   - `startTimestamp` = `<Timestamp when token was burned>`
1718      *   - `burned = `true`
1719      *   - `extraData` = `<Extra data when token was burned>`
1720      *
1721      * Otherwise:
1722      *   - `addr` = `<Address of owner>`
1723      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1724      *   - `burned = `false`
1725      *   - `extraData` = `<Extra data at start of ownership>`
1726      */
1727     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1728         TokenOwnership memory ownership;
1729         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1730             return ownership;
1731         }
1732         ownership = _ownershipAt(tokenId);
1733         if (ownership.burned) {
1734             return ownership;
1735         }
1736         return _ownershipOf(tokenId);
1737     }
1738 
1739     /**
1740      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1741      * See {ERC721AQueryable-explicitOwnershipOf}
1742      */
1743     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1744         unchecked {
1745             uint256 tokenIdsLength = tokenIds.length;
1746             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1747             for (uint256 i; i != tokenIdsLength; ++i) {
1748                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1749             }
1750             return ownerships;
1751         }
1752     }
1753 
1754     /**
1755      * @dev Returns an array of token IDs owned by `owner`,
1756      * in the range [`start`, `stop`)
1757      * (i.e. `start <= tokenId < stop`).
1758      *
1759      * This function allows for tokens to be queried if the collection
1760      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1761      *
1762      * Requirements:
1763      *
1764      * - `start` < `stop`
1765      */
1766     function tokensOfOwnerIn(
1767         address owner,
1768         uint256 start,
1769         uint256 stop
1770     ) external view override returns (uint256[] memory) {
1771         unchecked {
1772             if (start >= stop) revert InvalidQueryRange();
1773             uint256 tokenIdsIdx;
1774             uint256 stopLimit = _nextTokenId();
1775             // Set `start = max(start, _startTokenId())`.
1776             if (start < _startTokenId()) {
1777                 start = _startTokenId();
1778             }
1779             // Set `stop = min(stop, stopLimit)`.
1780             if (stop > stopLimit) {
1781                 stop = stopLimit;
1782             }
1783             uint256 tokenIdsMaxLength = balanceOf(owner);
1784             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1785             // to cater for cases where `balanceOf(owner)` is too big.
1786             if (start < stop) {
1787                 uint256 rangeLength = stop - start;
1788                 if (rangeLength < tokenIdsMaxLength) {
1789                     tokenIdsMaxLength = rangeLength;
1790                 }
1791             } else {
1792                 tokenIdsMaxLength = 0;
1793             }
1794             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1795             if (tokenIdsMaxLength == 0) {
1796                 return tokenIds;
1797             }
1798             // We need to call `explicitOwnershipOf(start)`,
1799             // because the slot at `start` may not be initialized.
1800             TokenOwnership memory ownership = explicitOwnershipOf(start);
1801             address currOwnershipAddr;
1802             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1803             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1804             if (!ownership.burned) {
1805                 currOwnershipAddr = ownership.addr;
1806             }
1807             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1808                 ownership = _ownershipAt(i);
1809                 if (ownership.burned) {
1810                     continue;
1811                 }
1812                 if (ownership.addr != address(0)) {
1813                     currOwnershipAddr = ownership.addr;
1814                 }
1815                 if (currOwnershipAddr == owner) {
1816                     tokenIds[tokenIdsIdx++] = i;
1817                 }
1818             }
1819             // Downsize the array to fit.
1820             assembly {
1821                 mstore(tokenIds, tokenIdsIdx)
1822             }
1823             return tokenIds;
1824         }
1825     }
1826 
1827     /**
1828      * @dev Returns an array of token IDs owned by `owner`.
1829      *
1830      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1831      * It is meant to be called off-chain.
1832      *
1833      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1834      * multiple smaller scans if the collection is large enough to cause
1835      * an out-of-gas error (10K pfp collections should be fine).
1836      */
1837     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1838         unchecked {
1839             uint256 tokenIdsIdx;
1840             address currOwnershipAddr;
1841             uint256 tokenIdsLength = balanceOf(owner);
1842             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1843             TokenOwnership memory ownership;
1844             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1845                 ownership = _ownershipAt(i);
1846                 if (ownership.burned) {
1847                     continue;
1848                 }
1849                 if (ownership.addr != address(0)) {
1850                     currOwnershipAddr = ownership.addr;
1851                 }
1852                 if (currOwnershipAddr == owner) {
1853                     tokenIds[tokenIdsIdx++] = i;
1854                 }
1855             }
1856             return tokenIds;
1857         }
1858     }
1859 }
1860 
1861 
1862 // File: contracts/8LEMENTS.sol
1863 // 8LEMENTS
1864 
1865 pragma solidity >= 0.8.0;
1866 
1867 contract ELEMENTS is ERC721AQueryable, Ownable, ReentrancyGuard, OperatorFilterer {
1868   using Strings for uint256;
1869 
1870   string public uriPrefix;
1871   string public uriSuffix = ".json";
1872   string public notRevealedURI = "ipfs://QmSvXAQj9wzkxxrZ7ugM7j22XVfrXTT5wTRAVGphK4j5wV/metadata3/hidden.json";
1873   
1874   uint256 public cost = 0.01 ether;
1875   uint256 public maxSupply = 8016;
1876 
1877   uint256 public maxPerTx = 20;
1878   uint256 public maxPerWallet = 200;
1879   
1880   bool public publicMint = false;
1881   bool public claimMint = false;
1882   bool public paused = true;
1883   bool public revealed = false;
1884 
1885   address public parentAddress = 0x9bbE09E8253450856E1dC6B068b07664152E4703;
1886 
1887   mapping(address => uint256) public addressMintedBalance;
1888 
1889   constructor() ERC721A ( "8lements Official", "8L" ) OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), true) {}
1890 
1891 // ~~~~~~~~~~~~~~~~~~~~ URI's ~~~~~~~~~~~~~~~~~~~~
1892   function _baseURI() internal view virtual override returns (string memory) {
1893     return uriPrefix;
1894   }
1895 
1896 // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
1897   modifier mintCompliance(uint256 _mintAmount) {
1898     require(!paused, "The contract is paused!");
1899     require(_mintAmount > 0 && _mintAmount <= maxPerTx, "Invalid mint amount!");
1900     require(_mintAmount + addressMintedBalance[msg.sender] <= maxPerWallet, "Max per wallet exceeded!");
1901     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1902     _;
1903   }
1904 
1905 // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
1906   // PUBLIC MINT
1907   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1908     require(publicMint, "Public mint is not allowed yet.");
1909     require(totalSupply() + _mintAmount <= maxSupply, "Max supply limit exceeded!");
1910     require(msg.value >= cost * _mintAmount,"Insufficient funds!");
1911 
1912     addressMintedBalance[msg.sender] += _mintAmount;
1913     _safeMint(_msgSender(), _mintAmount);
1914   }
1915   
1916   // HOLDERS CLAIM
1917   function claim(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1918     require(claimMint, "Holders claim is not allowed yet.");
1919 
1920     ERC721A token = ERC721A(parentAddress);
1921     uint256 callerBalance = token.balanceOf(msg.sender);
1922 
1923     require(addressMintedBalance[msg.sender] + _mintAmount <= callerBalance, "Max claim amount exceeded!");
1924     addressMintedBalance[msg.sender] += _mintAmount;
1925     _safeMint(_msgSender(), _mintAmount);
1926   }
1927 
1928   // MINT for address
1929   function mintToAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1930     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1931 
1932     addressMintedBalance[_receiver] += _mintAmount;
1933     _safeMint(_receiver, _mintAmount);
1934   }
1935   
1936   // Mass airdrop
1937   function MassAirdrop(uint256 amount, address[] calldata _receivers) public onlyOwner {
1938     for (uint256 i = 0; i < _receivers.length; ++i) {
1939       require(totalSupply() + amount <= maxSupply, "Max supply exceeded!");
1940       _safeMint(_receivers[i], amount);
1941     }
1942   }
1943 
1944 // ~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~
1945   // Start Token
1946   function _startTokenId() internal view virtual override returns (uint256) {
1947     return 1;
1948   }
1949 
1950   // TOKEN URI
1951   function tokenURI(uint256 _tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
1952     require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token.");
1953     
1954     if (revealed == false) { return notRevealedURI; }
1955 
1956     string memory currentBaseURI = _baseURI();
1957     return bytes(currentBaseURI).length > 0
1958     ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1959     : "";
1960     }
1961 
1962 // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
1963   // SET PARENT ADDRESS
1964   function setParentAddress(address _newAddress) public onlyOwner {
1965     parentAddress = _newAddress;
1966   }
1967   
1968   // SET MAX SUPPLY
1969   function setMaxSupply(uint256 _MaxSupply) public onlyOwner {
1970     maxSupply = _MaxSupply;
1971   }
1972   
1973   // SET COST
1974   function setCost(uint256 _cost) public onlyOwner {
1975     cost = _cost;
1976   }
1977   
1978   // SET MAX PER TRANSACTION
1979   function setMaxPerTx(uint256 _maxPerTx) public onlyOwner {
1980     maxPerTx = _maxPerTx;
1981   }
1982   
1983   // SET MAX PER WALLET
1984   function setMaxPerWallet(uint256 _maxPerWallet) public onlyOwner {
1985     maxPerWallet = _maxPerWallet;
1986   }
1987 
1988   // BaseURI
1989   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1990     uriPrefix = _uriPrefix;
1991   }
1992 
1993   // NotRevealedURI
1994   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1995     notRevealedURI = _notRevealedURI;
1996   }
1997 
1998   // ENABLE/DISABLE PUBLIC MINT
1999   function enablePublicMint() public onlyOwner {
2000     if (publicMint == true) { publicMint = false; }
2001     else { publicMint = true; }
2002   }
2003   
2004   // ENABLE/DISABLE HOLDERS CLAIM
2005   function enableClaimMint() public onlyOwner {
2006     if (claimMint == true) { claimMint = false; }
2007     else { claimMint = true; }
2008   }
2009 
2010   // PAUSE
2011   function pause() public onlyOwner {
2012     if (paused == true) { paused = false; }
2013     else { paused = true; }
2014   }
2015 
2016   // REVEAL
2017   function reveal() public onlyOwner {
2018     if (revealed == true) { revealed = false; }
2019     else { revealed = true; }
2020   }
2021 
2022   function setApprovalForAll(address operator, bool approved) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
2023     super.setApprovalForAll(operator, approved);
2024   }
2025 
2026   function approve(address operator, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
2027     super.approve(operator, tokenId);
2028   }
2029 
2030   function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2031     super.transferFrom(from, to, tokenId);
2032   }
2033 
2034   function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2035     super.safeTransferFrom(from, to, tokenId);
2036   }
2037 
2038   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2039     super.safeTransferFrom(from, to, tokenId, data);
2040   }
2041 
2042 // ~~~~~~~~~~~~~~~~~~~~ Withdraw Functions ~~~~~~~~~~~~~~~~~~~~
2043   function withdraw() public onlyOwner nonReentrant {
2044     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2045     require(os);
2046   }
2047 }