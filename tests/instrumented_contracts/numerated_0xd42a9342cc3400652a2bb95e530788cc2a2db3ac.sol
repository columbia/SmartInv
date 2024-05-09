1 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: operator-filter-registry/src/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Allow spending tokens from addresses with balance
72         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73         // from an EOA.
74         if (from != msg.sender) {
75             _checkFilterOperator(msg.sender);
76         }
77         _;
78     }
79 
80     modifier onlyAllowedOperatorApproval(address operator) virtual {
81         _checkFilterOperator(operator);
82         _;
83     }
84 
85     function _checkFilterOperator(address operator) internal view virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92     }
93 }
94 
95 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: @openzeppelin/contracts/utils/Strings.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev String operations.
120  */
121 library Strings {
122     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
123     uint8 private constant _ADDRESS_LENGTH = 20;
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
127      */
128     function toString(uint256 value) internal pure returns (string memory) {
129         // Inspired by OraclizeAPI's implementation - MIT licence
130         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
131 
132         if (value == 0) {
133             return "0";
134         }
135         uint256 temp = value;
136         uint256 digits;
137         while (temp != 0) {
138             digits++;
139             temp /= 10;
140         }
141         bytes memory buffer = new bytes(digits);
142         while (value != 0) {
143             digits -= 1;
144             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
145             value /= 10;
146         }
147         return string(buffer);
148     }
149 
150     /**
151      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
152      */
153     function toHexString(uint256 value) internal pure returns (string memory) {
154         if (value == 0) {
155             return "0x00";
156         }
157         uint256 temp = value;
158         uint256 length = 0;
159         while (temp != 0) {
160             length++;
161             temp >>= 8;
162         }
163         return toHexString(value, length);
164     }
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
168      */
169     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
170         bytes memory buffer = new bytes(2 * length + 2);
171         buffer[0] = "0";
172         buffer[1] = "x";
173         for (uint256 i = 2 * length + 1; i > 1; --i) {
174             buffer[i] = _HEX_SYMBOLS[value & 0xf];
175             value >>= 4;
176         }
177         require(value == 0, "Strings: hex length insufficient");
178         return string(buffer);
179     }
180 
181     /**
182      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
183      */
184     function toHexString(address addr) internal pure returns (string memory) {
185         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
186     }
187 }
188 
189 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
190 
191 
192 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @dev Contract module that helps prevent reentrant calls to a function.
198  *
199  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
200  * available, which can be applied to functions to make sure there are no nested
201  * (reentrant) calls to them.
202  *
203  * Note that because there is a single `nonReentrant` guard, functions marked as
204  * `nonReentrant` may not call one another. This can be worked around by making
205  * those functions `private`, and then adding `external` `nonReentrant` entry
206  * points to them.
207  *
208  * TIP: If you would like to learn more about reentrancy and alternative ways
209  * to protect against it, check out our blog post
210  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
211  */
212 abstract contract ReentrancyGuard {
213     // Booleans are more expensive than uint256 or any type that takes up a full
214     // word because each write operation emits an extra SLOAD to first read the
215     // slot's contents, replace the bits taken up by the boolean, and then write
216     // back. This is the compiler's defense against contract upgrades and
217     // pointer aliasing, and it cannot be disabled.
218 
219     // The values being non-zero value makes deployment a bit more expensive,
220     // but in exchange the refund on every call to nonReentrant will be lower in
221     // amount. Since refunds are capped to a percentage of the total
222     // transaction's gas, it is best to keep them low in cases like this one, to
223     // increase the likelihood of the full refund coming into effect.
224     uint256 private constant _NOT_ENTERED = 1;
225     uint256 private constant _ENTERED = 2;
226 
227     uint256 private _status;
228 
229     constructor() {
230         _status = _NOT_ENTERED;
231     }
232 
233     /**
234      * @dev Prevents a contract from calling itself, directly or indirectly.
235      * Calling a `nonReentrant` function from another `nonReentrant`
236      * function is not supported. It is possible to prevent this from happening
237      * by making the `nonReentrant` function external, and making it call a
238      * `private` function that does the actual work.
239      */
240     modifier nonReentrant() {
241         // On the first call to nonReentrant, _notEntered will be true
242         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
243 
244         // Any calls to nonReentrant after this point will fail
245         _status = _ENTERED;
246 
247         _;
248 
249         // By storing the original value once again, a refund is triggered (see
250         // https://eips.ethereum.org/EIPS/eip-2200)
251         _status = _NOT_ENTERED;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/utils/Context.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev Provides information about the current execution context, including the
264  * sender of the transaction and its data. While these are generally available
265  * via msg.sender and msg.data, they should not be accessed in such a direct
266  * manner, since when dealing with meta-transactions the account sending and
267  * paying for execution may not be the actual sender (as far as an application
268  * is concerned).
269  *
270  * This contract is only required for intermediate, library-like contracts.
271  */
272 abstract contract Context {
273     function _msgSender() internal view virtual returns (address) {
274         return msg.sender;
275     }
276 
277     function _msgData() internal view virtual returns (bytes calldata) {
278         return msg.data;
279     }
280 }
281 
282 // File: @openzeppelin/contracts/access/Ownable.sol
283 
284 
285 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 
290 /**
291  * @dev Contract module which provides a basic access control mechanism, where
292  * there is an account (an owner) that can be granted exclusive access to
293  * specific functions.
294  *
295  * By default, the owner account will be the one that deploys the contract. This
296  * can later be changed with {transferOwnership}.
297  *
298  * This module is used through inheritance. It will make available the modifier
299  * `onlyOwner`, which can be applied to your functions to restrict their use to
300  * the owner.
301  */
302 abstract contract Ownable is Context {
303     address private _owner;
304 
305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
306 
307     /**
308      * @dev Initializes the contract setting the deployer as the initial owner.
309      */
310     constructor() {
311         _transferOwnership(_msgSender());
312     }
313 
314     /**
315      * @dev Throws if called by any account other than the owner.
316      */
317     modifier onlyOwner() {
318         _checkOwner();
319         _;
320     }
321 
322     /**
323      * @dev Returns the address of the current owner.
324      */
325     function owner() public view virtual returns (address) {
326         return _owner;
327     }
328 
329     /**
330      * @dev Throws if the sender is not the owner.
331      */
332     function _checkOwner() internal view virtual {
333         require(owner() == _msgSender(), "Ownable: caller is not the owner");
334     }
335 
336     /**
337      * @dev Leaves the contract without owner. It will not be possible to call
338      * `onlyOwner` functions anymore. Can only be called by the current owner.
339      *
340      * NOTE: Renouncing ownership will leave the contract without an owner,
341      * thereby removing any functionality that is only available to the owner.
342      */
343     function renounceOwnership() public virtual onlyOwner {
344         _transferOwnership(address(0));
345     }
346 
347     /**
348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
349      * Can only be called by the current owner.
350      */
351     function transferOwnership(address newOwner) public virtual onlyOwner {
352         require(newOwner != address(0), "Ownable: new owner is the zero address");
353         _transferOwnership(newOwner);
354     }
355 
356     /**
357      * @dev Transfers ownership of the contract to a new account (`newOwner`).
358      * Internal function without access restriction.
359      */
360     function _transferOwnership(address newOwner) internal virtual {
361         address oldOwner = _owner;
362         _owner = newOwner;
363         emit OwnershipTransferred(oldOwner, newOwner);
364     }
365 }
366 
367 // File: erc721a/contracts/IERC721A.sol
368 
369 
370 // ERC721A Contracts v4.2.3
371 // Creator: Chiru Labs
372 
373 pragma solidity ^0.8.4;
374 
375 /**
376  * @dev Interface of ERC721A.
377  */
378 interface IERC721A {
379     /**
380      * The caller must own the token or be an approved operator.
381      */
382     error ApprovalCallerNotOwnerNorApproved();
383 
384     /**
385      * The token does not exist.
386      */
387     error ApprovalQueryForNonexistentToken();
388 
389     /**
390      * Cannot query the balance for the zero address.
391      */
392     error BalanceQueryForZeroAddress();
393 
394     /**
395      * Cannot mint to the zero address.
396      */
397     error MintToZeroAddress();
398 
399     /**
400      * The quantity of tokens minted must be more than zero.
401      */
402     error MintZeroQuantity();
403 
404     /**
405      * The token does not exist.
406      */
407     error OwnerQueryForNonexistentToken();
408 
409     /**
410      * The caller must own the token or be an approved operator.
411      */
412     error TransferCallerNotOwnerNorApproved();
413 
414     /**
415      * The token must be owned by `from`.
416      */
417     error TransferFromIncorrectOwner();
418 
419     /**
420      * Cannot safely transfer to a contract that does not implement the
421      * ERC721Receiver interface.
422      */
423     error TransferToNonERC721ReceiverImplementer();
424 
425     /**
426      * Cannot transfer to the zero address.
427      */
428     error TransferToZeroAddress();
429 
430     /**
431      * The token does not exist.
432      */
433     error URIQueryForNonexistentToken();
434 
435     /**
436      * The `quantity` minted with ERC2309 exceeds the safety limit.
437      */
438     error MintERC2309QuantityExceedsLimit();
439 
440     /**
441      * The `extraData` cannot be set on an unintialized ownership slot.
442      */
443     error OwnershipNotInitializedForExtraData();
444 
445     // =============================================================
446     //                            STRUCTS
447     // =============================================================
448 
449     struct TokenOwnership {
450         // The address of the owner.
451         address addr;
452         // Stores the start time of ownership with minimal overhead for tokenomics.
453         uint64 startTimestamp;
454         // Whether the token has been burned.
455         bool burned;
456         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
457         uint24 extraData;
458     }
459 
460     // =============================================================
461     //                         TOKEN COUNTERS
462     // =============================================================
463 
464     /**
465      * @dev Returns the total number of tokens in existence.
466      * Burned tokens will reduce the count.
467      * To get the total number of tokens minted, please see {_totalMinted}.
468      */
469     function totalSupply() external view returns (uint256);
470 
471     // =============================================================
472     //                            IERC165
473     // =============================================================
474 
475     /**
476      * @dev Returns true if this contract implements the interface defined by
477      * `interfaceId`. See the corresponding
478      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
479      * to learn more about how these ids are created.
480      *
481      * This function call must use less than 30000 gas.
482      */
483     function supportsInterface(bytes4 interfaceId) external view returns (bool);
484 
485     // =============================================================
486     //                            IERC721
487     // =============================================================
488 
489     /**
490      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
491      */
492     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
493 
494     /**
495      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
496      */
497     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
498 
499     /**
500      * @dev Emitted when `owner` enables or disables
501      * (`approved`) `operator` to manage all of its assets.
502      */
503     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
504 
505     /**
506      * @dev Returns the number of tokens in `owner`'s account.
507      */
508     function balanceOf(address owner) external view returns (uint256 balance);
509 
510     /**
511      * @dev Returns the owner of the `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function ownerOf(uint256 tokenId) external view returns (address owner);
518 
519     /**
520      * @dev Safely transfers `tokenId` token from `from` to `to`,
521      * checking first that contract recipients are aware of the ERC721 protocol
522      * to prevent tokens from being forever locked.
523      *
524      * Requirements:
525      *
526      * - `from` cannot be the zero address.
527      * - `to` cannot be the zero address.
528      * - `tokenId` token must exist and be owned by `from`.
529      * - If the caller is not `from`, it must be have been allowed to move
530      * this token by either {approve} or {setApprovalForAll}.
531      * - If `to` refers to a smart contract, it must implement
532      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
533      *
534      * Emits a {Transfer} event.
535      */
536     function safeTransferFrom(
537         address from,
538         address to,
539         uint256 tokenId,
540         bytes calldata data
541     ) external payable;
542 
543     /**
544      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId
550     ) external payable;
551 
552     /**
553      * @dev Transfers `tokenId` from `from` to `to`.
554      *
555      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
556      * whenever possible.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token
564      * by either {approve} or {setApprovalForAll}.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transferFrom(
569         address from,
570         address to,
571         uint256 tokenId
572     ) external payable;
573 
574     /**
575      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
576      * The approval is cleared when the token is transferred.
577      *
578      * Only a single account can be approved at a time, so approving the
579      * zero address clears previous approvals.
580      *
581      * Requirements:
582      *
583      * - The caller must own the token or be an approved operator.
584      * - `tokenId` must exist.
585      *
586      * Emits an {Approval} event.
587      */
588     function approve(address to, uint256 tokenId) external payable;
589 
590     /**
591      * @dev Approve or remove `operator` as an operator for the caller.
592      * Operators can call {transferFrom} or {safeTransferFrom}
593      * for any token owned by the caller.
594      *
595      * Requirements:
596      *
597      * - The `operator` cannot be the caller.
598      *
599      * Emits an {ApprovalForAll} event.
600      */
601     function setApprovalForAll(address operator, bool _approved) external;
602 
603     /**
604      * @dev Returns the account approved for `tokenId` token.
605      *
606      * Requirements:
607      *
608      * - `tokenId` must exist.
609      */
610     function getApproved(uint256 tokenId) external view returns (address operator);
611 
612     /**
613      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
614      *
615      * See {setApprovalForAll}.
616      */
617     function isApprovedForAll(address owner, address operator) external view returns (bool);
618 
619     // =============================================================
620     //                        IERC721Metadata
621     // =============================================================
622 
623     /**
624      * @dev Returns the token collection name.
625      */
626     function name() external view returns (string memory);
627 
628     /**
629      * @dev Returns the token collection symbol.
630      */
631     function symbol() external view returns (string memory);
632 
633     /**
634      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
635      */
636     function tokenURI(uint256 tokenId) external view returns (string memory);
637 
638     // =============================================================
639     //                           IERC2309
640     // =============================================================
641 
642     /**
643      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
644      * (inclusive) is transferred from `from` to `to`, as defined in the
645      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
646      *
647      * See {_mintERC2309} for more details.
648      */
649     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
650 }
651 
652 // File: erc721a/contracts/ERC721A.sol
653 
654 
655 // ERC721A Contracts v4.2.3
656 // Creator: Chiru Labs
657 
658 pragma solidity ^0.8.4;
659 
660 
661 /**
662  * @dev Interface of ERC721 token receiver.
663  */
664 interface ERC721A__IERC721Receiver {
665     function onERC721Received(
666         address operator,
667         address from,
668         uint256 tokenId,
669         bytes calldata data
670     ) external returns (bytes4);
671 }
672 
673 /**
674  * @title ERC721A
675  *
676  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
677  * Non-Fungible Token Standard, including the Metadata extension.
678  * Optimized for lower gas during batch mints.
679  *
680  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
681  * starting from `_startTokenId()`.
682  *
683  * Assumptions:
684  *
685  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
686  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
687  */
688 contract ERC721A is IERC721A {
689     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
690     struct TokenApprovalRef {
691         address value;
692     }
693 
694     // =============================================================
695     //                           CONSTANTS
696     // =============================================================
697 
698     // Mask of an entry in packed address data.
699     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
700 
701     // The bit position of `numberMinted` in packed address data.
702     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
703 
704     // The bit position of `numberBurned` in packed address data.
705     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
706 
707     // The bit position of `aux` in packed address data.
708     uint256 private constant _BITPOS_AUX = 192;
709 
710     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
711     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
712 
713     // The bit position of `startTimestamp` in packed ownership.
714     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
715 
716     // The bit mask of the `burned` bit in packed ownership.
717     uint256 private constant _BITMASK_BURNED = 1 << 224;
718 
719     // The bit position of the `nextInitialized` bit in packed ownership.
720     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
721 
722     // The bit mask of the `nextInitialized` bit in packed ownership.
723     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
724 
725     // The bit position of `extraData` in packed ownership.
726     uint256 private constant _BITPOS_EXTRA_DATA = 232;
727 
728     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
729     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
730 
731     // The mask of the lower 160 bits for addresses.
732     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
733 
734     // The maximum `quantity` that can be minted with {_mintERC2309}.
735     // This limit is to prevent overflows on the address data entries.
736     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
737     // is required to cause an overflow, which is unrealistic.
738     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
739 
740     // The `Transfer` event signature is given by:
741     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
742     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
743         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
744 
745     // =============================================================
746     //                            STORAGE
747     // =============================================================
748 
749     // The next token ID to be minted.
750     uint256 private _currentIndex;
751 
752     // The number of tokens burned.
753     uint256 private _burnCounter;
754 
755     // Token name
756     string private _name;
757 
758     // Token symbol
759     string private _symbol;
760 
761     // Mapping from token ID to ownership details
762     // An empty struct value does not necessarily mean the token is unowned.
763     // See {_packedOwnershipOf} implementation for details.
764     //
765     // Bits Layout:
766     // - [0..159]   `addr`
767     // - [160..223] `startTimestamp`
768     // - [224]      `burned`
769     // - [225]      `nextInitialized`
770     // - [232..255] `extraData`
771     mapping(uint256 => uint256) private _packedOwnerships;
772 
773     // Mapping owner address to address data.
774     //
775     // Bits Layout:
776     // - [0..63]    `balance`
777     // - [64..127]  `numberMinted`
778     // - [128..191] `numberBurned`
779     // - [192..255] `aux`
780     mapping(address => uint256) private _packedAddressData;
781 
782     // Mapping from token ID to approved address.
783     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
784 
785     // Mapping from owner to operator approvals
786     mapping(address => mapping(address => bool)) private _operatorApprovals;
787 
788     // =============================================================
789     //                          CONSTRUCTOR
790     // =============================================================
791 
792     constructor(string memory name_, string memory symbol_) {
793         _name = name_;
794         _symbol = symbol_;
795         _currentIndex = _startTokenId();
796     }
797 
798     // =============================================================
799     //                   TOKEN COUNTING OPERATIONS
800     // =============================================================
801 
802     /**
803      * @dev Returns the starting token ID.
804      * To change the starting token ID, please override this function.
805      */
806     function _startTokenId() internal view virtual returns (uint256) {
807         return 0;
808     }
809 
810     /**
811      * @dev Returns the next token ID to be minted.
812      */
813     function _nextTokenId() internal view virtual returns (uint256) {
814         return _currentIndex;
815     }
816 
817     /**
818      * @dev Returns the total number of tokens in existence.
819      * Burned tokens will reduce the count.
820      * To get the total number of tokens minted, please see {_totalMinted}.
821      */
822     function totalSupply() public view virtual override returns (uint256) {
823         // Counter underflow is impossible as _burnCounter cannot be incremented
824         // more than `_currentIndex - _startTokenId()` times.
825         unchecked {
826             return _currentIndex - _burnCounter - _startTokenId();
827         }
828     }
829 
830     /**
831      * @dev Returns the total amount of tokens minted in the contract.
832      */
833     function _totalMinted() internal view virtual returns (uint256) {
834         // Counter underflow is impossible as `_currentIndex` does not decrement,
835         // and it is initialized to `_startTokenId()`.
836         unchecked {
837             return _currentIndex - _startTokenId();
838         }
839     }
840 
841     /**
842      * @dev Returns the total number of tokens burned.
843      */
844     function _totalBurned() internal view virtual returns (uint256) {
845         return _burnCounter;
846     }
847 
848     // =============================================================
849     //                    ADDRESS DATA OPERATIONS
850     // =============================================================
851 
852     /**
853      * @dev Returns the number of tokens in `owner`'s account.
854      */
855     function balanceOf(address owner) public view virtual override returns (uint256) {
856         if (owner == address(0)) revert BalanceQueryForZeroAddress();
857         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
858     }
859 
860     /**
861      * Returns the number of tokens minted by `owner`.
862      */
863     function _numberMinted(address owner) internal view returns (uint256) {
864         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
865     }
866 
867     /**
868      * Returns the number of tokens burned by or on behalf of `owner`.
869      */
870     function _numberBurned(address owner) internal view returns (uint256) {
871         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
872     }
873 
874     /**
875      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
876      */
877     function _getAux(address owner) internal view returns (uint64) {
878         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
879     }
880 
881     /**
882      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
883      * If there are multiple variables, please pack them into a uint64.
884      */
885     function _setAux(address owner, uint64 aux) internal virtual {
886         uint256 packed = _packedAddressData[owner];
887         uint256 auxCasted;
888         // Cast `aux` with assembly to avoid redundant masking.
889         assembly {
890             auxCasted := aux
891         }
892         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
893         _packedAddressData[owner] = packed;
894     }
895 
896     // =============================================================
897     //                            IERC165
898     // =============================================================
899 
900     /**
901      * @dev Returns true if this contract implements the interface defined by
902      * `interfaceId`. See the corresponding
903      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
904      * to learn more about how these ids are created.
905      *
906      * This function call must use less than 30000 gas.
907      */
908     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
909         // The interface IDs are constants representing the first 4 bytes
910         // of the XOR of all function selectors in the interface.
911         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
912         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
913         return
914             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
915             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
916             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
917     }
918 
919     // =============================================================
920     //                        IERC721Metadata
921     // =============================================================
922 
923     /**
924      * @dev Returns the token collection name.
925      */
926     function name() public view virtual override returns (string memory) {
927         return _name;
928     }
929 
930     /**
931      * @dev Returns the token collection symbol.
932      */
933     function symbol() public view virtual override returns (string memory) {
934         return _symbol;
935     }
936 
937     /**
938      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
939      */
940     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
941         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
942 
943         string memory baseURI = _baseURI();
944         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
945     }
946 
947     /**
948      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
949      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
950      * by default, it can be overridden in child contracts.
951      */
952     function _baseURI() internal view virtual returns (string memory) {
953         return '';
954     }
955 
956     // =============================================================
957     //                     OWNERSHIPS OPERATIONS
958     // =============================================================
959 
960     /**
961      * @dev Returns the owner of the `tokenId` token.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      */
967     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
968         return address(uint160(_packedOwnershipOf(tokenId)));
969     }
970 
971     /**
972      * @dev Gas spent here starts off proportional to the maximum mint batch size.
973      * It gradually moves to O(1) as tokens get transferred around over time.
974      */
975     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
976         return _unpackedOwnership(_packedOwnershipOf(tokenId));
977     }
978 
979     /**
980      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
981      */
982     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
983         return _unpackedOwnership(_packedOwnerships[index]);
984     }
985 
986     /**
987      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
988      */
989     function _initializeOwnershipAt(uint256 index) internal virtual {
990         if (_packedOwnerships[index] == 0) {
991             _packedOwnerships[index] = _packedOwnershipOf(index);
992         }
993     }
994 
995     /**
996      * Returns the packed ownership data of `tokenId`.
997      */
998     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
999         uint256 curr = tokenId;
1000 
1001         unchecked {
1002             if (_startTokenId() <= curr)
1003                 if (curr < _currentIndex) {
1004                     uint256 packed = _packedOwnerships[curr];
1005                     // If not burned.
1006                     if (packed & _BITMASK_BURNED == 0) {
1007                         // Invariant:
1008                         // There will always be an initialized ownership slot
1009                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1010                         // before an unintialized ownership slot
1011                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1012                         // Hence, `curr` will not underflow.
1013                         //
1014                         // We can directly compare the packed value.
1015                         // If the address is zero, packed will be zero.
1016                         while (packed == 0) {
1017                             packed = _packedOwnerships[--curr];
1018                         }
1019                         return packed;
1020                     }
1021                 }
1022         }
1023         revert OwnerQueryForNonexistentToken();
1024     }
1025 
1026     /**
1027      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1028      */
1029     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1030         ownership.addr = address(uint160(packed));
1031         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1032         ownership.burned = packed & _BITMASK_BURNED != 0;
1033         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1034     }
1035 
1036     /**
1037      * @dev Packs ownership data into a single uint256.
1038      */
1039     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1040         assembly {
1041             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1042             owner := and(owner, _BITMASK_ADDRESS)
1043             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1044             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1045         }
1046     }
1047 
1048     /**
1049      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1050      */
1051     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1052         // For branchless setting of the `nextInitialized` flag.
1053         assembly {
1054             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1055             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1056         }
1057     }
1058 
1059     // =============================================================
1060     //                      APPROVAL OPERATIONS
1061     // =============================================================
1062 
1063     /**
1064      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1065      * The approval is cleared when the token is transferred.
1066      *
1067      * Only a single account can be approved at a time, so approving the
1068      * zero address clears previous approvals.
1069      *
1070      * Requirements:
1071      *
1072      * - The caller must own the token or be an approved operator.
1073      * - `tokenId` must exist.
1074      *
1075      * Emits an {Approval} event.
1076      */
1077     function approve(address to, uint256 tokenId) public payable virtual override {
1078         address owner = ownerOf(tokenId);
1079 
1080         if (_msgSenderERC721A() != owner)
1081             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1082                 revert ApprovalCallerNotOwnerNorApproved();
1083             }
1084 
1085         _tokenApprovals[tokenId].value = to;
1086         emit Approval(owner, to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Returns the account approved for `tokenId` token.
1091      *
1092      * Requirements:
1093      *
1094      * - `tokenId` must exist.
1095      */
1096     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1097         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1098 
1099         return _tokenApprovals[tokenId].value;
1100     }
1101 
1102     /**
1103      * @dev Approve or remove `operator` as an operator for the caller.
1104      * Operators can call {transferFrom} or {safeTransferFrom}
1105      * for any token owned by the caller.
1106      *
1107      * Requirements:
1108      *
1109      * - The `operator` cannot be the caller.
1110      *
1111      * Emits an {ApprovalForAll} event.
1112      */
1113     function setApprovalForAll(address operator, bool approved) public virtual override {
1114         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1115         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1116     }
1117 
1118     /**
1119      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1120      *
1121      * See {setApprovalForAll}.
1122      */
1123     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1124         return _operatorApprovals[owner][operator];
1125     }
1126 
1127     /**
1128      * @dev Returns whether `tokenId` exists.
1129      *
1130      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1131      *
1132      * Tokens start existing when they are minted. See {_mint}.
1133      */
1134     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1135         return
1136             _startTokenId() <= tokenId &&
1137             tokenId < _currentIndex && // If within bounds,
1138             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1139     }
1140 
1141     /**
1142      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1143      */
1144     function _isSenderApprovedOrOwner(
1145         address approvedAddress,
1146         address owner,
1147         address msgSender
1148     ) private pure returns (bool result) {
1149         assembly {
1150             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1151             owner := and(owner, _BITMASK_ADDRESS)
1152             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1153             msgSender := and(msgSender, _BITMASK_ADDRESS)
1154             // `msgSender == owner || msgSender == approvedAddress`.
1155             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1156         }
1157     }
1158 
1159     /**
1160      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1161      */
1162     function _getApprovedSlotAndAddress(uint256 tokenId)
1163         private
1164         view
1165         returns (uint256 approvedAddressSlot, address approvedAddress)
1166     {
1167         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1168         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1169         assembly {
1170             approvedAddressSlot := tokenApproval.slot
1171             approvedAddress := sload(approvedAddressSlot)
1172         }
1173     }
1174 
1175     // =============================================================
1176     //                      TRANSFER OPERATIONS
1177     // =============================================================
1178 
1179     /**
1180      * @dev Transfers `tokenId` from `from` to `to`.
1181      *
1182      * Requirements:
1183      *
1184      * - `from` cannot be the zero address.
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      * - If the caller is not `from`, it must be approved to move this token
1188      * by either {approve} or {setApprovalForAll}.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function transferFrom(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) public payable virtual override {
1197         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1198 
1199         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1200 
1201         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1202 
1203         // The nested ifs save around 20+ gas over a compound boolean condition.
1204         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1205             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1206 
1207         if (to == address(0)) revert TransferToZeroAddress();
1208 
1209         _beforeTokenTransfers(from, to, tokenId, 1);
1210 
1211         // Clear approvals from the previous owner.
1212         assembly {
1213             if approvedAddress {
1214                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1215                 sstore(approvedAddressSlot, 0)
1216             }
1217         }
1218 
1219         // Underflow of the sender's balance is impossible because we check for
1220         // ownership above and the recipient's balance can't realistically overflow.
1221         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1222         unchecked {
1223             // We can directly increment and decrement the balances.
1224             --_packedAddressData[from]; // Updates: `balance -= 1`.
1225             ++_packedAddressData[to]; // Updates: `balance += 1`.
1226 
1227             // Updates:
1228             // - `address` to the next owner.
1229             // - `startTimestamp` to the timestamp of transfering.
1230             // - `burned` to `false`.
1231             // - `nextInitialized` to `true`.
1232             _packedOwnerships[tokenId] = _packOwnershipData(
1233                 to,
1234                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1235             );
1236 
1237             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1238             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1239                 uint256 nextTokenId = tokenId + 1;
1240                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1241                 if (_packedOwnerships[nextTokenId] == 0) {
1242                     // If the next slot is within bounds.
1243                     if (nextTokenId != _currentIndex) {
1244                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1245                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1246                     }
1247                 }
1248             }
1249         }
1250 
1251         emit Transfer(from, to, tokenId);
1252         _afterTokenTransfers(from, to, tokenId, 1);
1253     }
1254 
1255     /**
1256      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1257      */
1258     function safeTransferFrom(
1259         address from,
1260         address to,
1261         uint256 tokenId
1262     ) public payable virtual override {
1263         safeTransferFrom(from, to, tokenId, '');
1264     }
1265 
1266     /**
1267      * @dev Safely transfers `tokenId` token from `from` to `to`.
1268      *
1269      * Requirements:
1270      *
1271      * - `from` cannot be the zero address.
1272      * - `to` cannot be the zero address.
1273      * - `tokenId` token must exist and be owned by `from`.
1274      * - If the caller is not `from`, it must be approved to move this token
1275      * by either {approve} or {setApprovalForAll}.
1276      * - If `to` refers to a smart contract, it must implement
1277      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function safeTransferFrom(
1282         address from,
1283         address to,
1284         uint256 tokenId,
1285         bytes memory _data
1286     ) public payable virtual override {
1287         transferFrom(from, to, tokenId);
1288         if (to.code.length != 0)
1289             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1290                 revert TransferToNonERC721ReceiverImplementer();
1291             }
1292     }
1293 
1294     /**
1295      * @dev Hook that is called before a set of serially-ordered token IDs
1296      * are about to be transferred. This includes minting.
1297      * And also called before burning one token.
1298      *
1299      * `startTokenId` - the first token ID to be transferred.
1300      * `quantity` - the amount to be transferred.
1301      *
1302      * Calling conditions:
1303      *
1304      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1305      * transferred to `to`.
1306      * - When `from` is zero, `tokenId` will be minted for `to`.
1307      * - When `to` is zero, `tokenId` will be burned by `from`.
1308      * - `from` and `to` are never both zero.
1309      */
1310     function _beforeTokenTransfers(
1311         address from,
1312         address to,
1313         uint256 startTokenId,
1314         uint256 quantity
1315     ) internal virtual {}
1316 
1317     /**
1318      * @dev Hook that is called after a set of serially-ordered token IDs
1319      * have been transferred. This includes minting.
1320      * And also called after one token has been burned.
1321      *
1322      * `startTokenId` - the first token ID to be transferred.
1323      * `quantity` - the amount to be transferred.
1324      *
1325      * Calling conditions:
1326      *
1327      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1328      * transferred to `to`.
1329      * - When `from` is zero, `tokenId` has been minted for `to`.
1330      * - When `to` is zero, `tokenId` has been burned by `from`.
1331      * - `from` and `to` are never both zero.
1332      */
1333     function _afterTokenTransfers(
1334         address from,
1335         address to,
1336         uint256 startTokenId,
1337         uint256 quantity
1338     ) internal virtual {}
1339 
1340     /**
1341      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1342      *
1343      * `from` - Previous owner of the given token ID.
1344      * `to` - Target address that will receive the token.
1345      * `tokenId` - Token ID to be transferred.
1346      * `_data` - Optional data to send along with the call.
1347      *
1348      * Returns whether the call correctly returned the expected magic value.
1349      */
1350     function _checkContractOnERC721Received(
1351         address from,
1352         address to,
1353         uint256 tokenId,
1354         bytes memory _data
1355     ) private returns (bool) {
1356         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1357             bytes4 retval
1358         ) {
1359             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1360         } catch (bytes memory reason) {
1361             if (reason.length == 0) {
1362                 revert TransferToNonERC721ReceiverImplementer();
1363             } else {
1364                 assembly {
1365                     revert(add(32, reason), mload(reason))
1366                 }
1367             }
1368         }
1369     }
1370 
1371     // =============================================================
1372     //                        MINT OPERATIONS
1373     // =============================================================
1374 
1375     /**
1376      * @dev Mints `quantity` tokens and transfers them to `to`.
1377      *
1378      * Requirements:
1379      *
1380      * - `to` cannot be the zero address.
1381      * - `quantity` must be greater than 0.
1382      *
1383      * Emits a {Transfer} event for each mint.
1384      */
1385     function _mint(address to, uint256 quantity) internal virtual {
1386         uint256 startTokenId = _currentIndex;
1387         if (quantity == 0) revert MintZeroQuantity();
1388 
1389         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1390 
1391         // Overflows are incredibly unrealistic.
1392         // `balance` and `numberMinted` have a maximum limit of 2**64.
1393         // `tokenId` has a maximum limit of 2**256.
1394         unchecked {
1395             // Updates:
1396             // - `balance += quantity`.
1397             // - `numberMinted += quantity`.
1398             //
1399             // We can directly add to the `balance` and `numberMinted`.
1400             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1401 
1402             // Updates:
1403             // - `address` to the owner.
1404             // - `startTimestamp` to the timestamp of minting.
1405             // - `burned` to `false`.
1406             // - `nextInitialized` to `quantity == 1`.
1407             _packedOwnerships[startTokenId] = _packOwnershipData(
1408                 to,
1409                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1410             );
1411 
1412             uint256 toMasked;
1413             uint256 end = startTokenId + quantity;
1414 
1415             // Use assembly to loop and emit the `Transfer` event for gas savings.
1416             // The duplicated `log4` removes an extra check and reduces stack juggling.
1417             // The assembly, together with the surrounding Solidity code, have been
1418             // delicately arranged to nudge the compiler into producing optimized opcodes.
1419             assembly {
1420                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1421                 toMasked := and(to, _BITMASK_ADDRESS)
1422                 // Emit the `Transfer` event.
1423                 log4(
1424                     0, // Start of data (0, since no data).
1425                     0, // End of data (0, since no data).
1426                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1427                     0, // `address(0)`.
1428                     toMasked, // `to`.
1429                     startTokenId // `tokenId`.
1430                 )
1431 
1432                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1433                 // that overflows uint256 will make the loop run out of gas.
1434                 // The compiler will optimize the `iszero` away for performance.
1435                 for {
1436                     let tokenId := add(startTokenId, 1)
1437                 } iszero(eq(tokenId, end)) {
1438                     tokenId := add(tokenId, 1)
1439                 } {
1440                     // Emit the `Transfer` event. Similar to above.
1441                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1442                 }
1443             }
1444             if (toMasked == 0) revert MintToZeroAddress();
1445 
1446             _currentIndex = end;
1447         }
1448         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1449     }
1450 
1451     /**
1452      * @dev Mints `quantity` tokens and transfers them to `to`.
1453      *
1454      * This function is intended for efficient minting only during contract creation.
1455      *
1456      * It emits only one {ConsecutiveTransfer} as defined in
1457      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1458      * instead of a sequence of {Transfer} event(s).
1459      *
1460      * Calling this function outside of contract creation WILL make your contract
1461      * non-compliant with the ERC721 standard.
1462      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1463      * {ConsecutiveTransfer} event is only permissible during contract creation.
1464      *
1465      * Requirements:
1466      *
1467      * - `to` cannot be the zero address.
1468      * - `quantity` must be greater than 0.
1469      *
1470      * Emits a {ConsecutiveTransfer} event.
1471      */
1472     function _mintERC2309(address to, uint256 quantity) internal virtual {
1473         uint256 startTokenId = _currentIndex;
1474         if (to == address(0)) revert MintToZeroAddress();
1475         if (quantity == 0) revert MintZeroQuantity();
1476         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1477 
1478         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1479 
1480         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1481         unchecked {
1482             // Updates:
1483             // - `balance += quantity`.
1484             // - `numberMinted += quantity`.
1485             //
1486             // We can directly add to the `balance` and `numberMinted`.
1487             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1488 
1489             // Updates:
1490             // - `address` to the owner.
1491             // - `startTimestamp` to the timestamp of minting.
1492             // - `burned` to `false`.
1493             // - `nextInitialized` to `quantity == 1`.
1494             _packedOwnerships[startTokenId] = _packOwnershipData(
1495                 to,
1496                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1497             );
1498 
1499             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1500 
1501             _currentIndex = startTokenId + quantity;
1502         }
1503         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1504     }
1505 
1506     /**
1507      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1508      *
1509      * Requirements:
1510      *
1511      * - If `to` refers to a smart contract, it must implement
1512      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1513      * - `quantity` must be greater than 0.
1514      *
1515      * See {_mint}.
1516      *
1517      * Emits a {Transfer} event for each mint.
1518      */
1519     function _safeMint(
1520         address to,
1521         uint256 quantity,
1522         bytes memory _data
1523     ) internal virtual {
1524         _mint(to, quantity);
1525 
1526         unchecked {
1527             if (to.code.length != 0) {
1528                 uint256 end = _currentIndex;
1529                 uint256 index = end - quantity;
1530                 do {
1531                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1532                         revert TransferToNonERC721ReceiverImplementer();
1533                     }
1534                 } while (index < end);
1535                 // Reentrancy protection.
1536                 if (_currentIndex != end) revert();
1537             }
1538         }
1539     }
1540 
1541     /**
1542      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1543      */
1544     function _safeMint(address to, uint256 quantity) internal virtual {
1545         _safeMint(to, quantity, '');
1546     }
1547 
1548     // =============================================================
1549     //                        BURN OPERATIONS
1550     // =============================================================
1551 
1552     /**
1553      * @dev Equivalent to `_burn(tokenId, false)`.
1554      */
1555     function _burn(uint256 tokenId) internal virtual {
1556         _burn(tokenId, false);
1557     }
1558 
1559     /**
1560      * @dev Destroys `tokenId`.
1561      * The approval is cleared when the token is burned.
1562      *
1563      * Requirements:
1564      *
1565      * - `tokenId` must exist.
1566      *
1567      * Emits a {Transfer} event.
1568      */
1569     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1570         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1571 
1572         address from = address(uint160(prevOwnershipPacked));
1573 
1574         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1575 
1576         if (approvalCheck) {
1577             // The nested ifs save around 20+ gas over a compound boolean condition.
1578             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1579                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1580         }
1581 
1582         _beforeTokenTransfers(from, address(0), tokenId, 1);
1583 
1584         // Clear approvals from the previous owner.
1585         assembly {
1586             if approvedAddress {
1587                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1588                 sstore(approvedAddressSlot, 0)
1589             }
1590         }
1591 
1592         // Underflow of the sender's balance is impossible because we check for
1593         // ownership above and the recipient's balance can't realistically overflow.
1594         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1595         unchecked {
1596             // Updates:
1597             // - `balance -= 1`.
1598             // - `numberBurned += 1`.
1599             //
1600             // We can directly decrement the balance, and increment the number burned.
1601             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1602             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1603 
1604             // Updates:
1605             // - `address` to the last owner.
1606             // - `startTimestamp` to the timestamp of burning.
1607             // - `burned` to `true`.
1608             // - `nextInitialized` to `true`.
1609             _packedOwnerships[tokenId] = _packOwnershipData(
1610                 from,
1611                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1612             );
1613 
1614             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1615             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1616                 uint256 nextTokenId = tokenId + 1;
1617                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1618                 if (_packedOwnerships[nextTokenId] == 0) {
1619                     // If the next slot is within bounds.
1620                     if (nextTokenId != _currentIndex) {
1621                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1622                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1623                     }
1624                 }
1625             }
1626         }
1627 
1628         emit Transfer(from, address(0), tokenId);
1629         _afterTokenTransfers(from, address(0), tokenId, 1);
1630 
1631         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1632         unchecked {
1633             _burnCounter++;
1634         }
1635     }
1636 
1637     // =============================================================
1638     //                     EXTRA DATA OPERATIONS
1639     // =============================================================
1640 
1641     /**
1642      * @dev Directly sets the extra data for the ownership data `index`.
1643      */
1644     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1645         uint256 packed = _packedOwnerships[index];
1646         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1647         uint256 extraDataCasted;
1648         // Cast `extraData` with assembly to avoid redundant masking.
1649         assembly {
1650             extraDataCasted := extraData
1651         }
1652         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1653         _packedOwnerships[index] = packed;
1654     }
1655 
1656     /**
1657      * @dev Called during each token transfer to set the 24bit `extraData` field.
1658      * Intended to be overridden by the cosumer contract.
1659      *
1660      * `previousExtraData` - the value of `extraData` before transfer.
1661      *
1662      * Calling conditions:
1663      *
1664      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1665      * transferred to `to`.
1666      * - When `from` is zero, `tokenId` will be minted for `to`.
1667      * - When `to` is zero, `tokenId` will be burned by `from`.
1668      * - `from` and `to` are never both zero.
1669      */
1670     function _extraData(
1671         address from,
1672         address to,
1673         uint24 previousExtraData
1674     ) internal view virtual returns (uint24) {}
1675 
1676     /**
1677      * @dev Returns the next extra data for the packed ownership data.
1678      * The returned result is shifted into position.
1679      */
1680     function _nextExtraData(
1681         address from,
1682         address to,
1683         uint256 prevOwnershipPacked
1684     ) private view returns (uint256) {
1685         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1686         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1687     }
1688 
1689     // =============================================================
1690     //                       OTHER OPERATIONS
1691     // =============================================================
1692 
1693     /**
1694      * @dev Returns the message sender (defaults to `msg.sender`).
1695      *
1696      * If you are writing GSN compatible contracts, you need to override this function.
1697      */
1698     function _msgSenderERC721A() internal view virtual returns (address) {
1699         return msg.sender;
1700     }
1701 
1702     /**
1703      * @dev Converts a uint256 to its ASCII string decimal representation.
1704      */
1705     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1706         assembly {
1707             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1708             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1709             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1710             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1711             let m := add(mload(0x40), 0xa0)
1712             // Update the free memory pointer to allocate.
1713             mstore(0x40, m)
1714             // Assign the `str` to the end.
1715             str := sub(m, 0x20)
1716             // Zeroize the slot after the string.
1717             mstore(str, 0)
1718 
1719             // Cache the end of the memory to calculate the length later.
1720             let end := str
1721 
1722             // We write the string from rightmost digit to leftmost digit.
1723             // The following is essentially a do-while loop that also handles the zero case.
1724             // prettier-ignore
1725             for { let temp := value } 1 {} {
1726                 str := sub(str, 1)
1727                 // Write the character to the pointer.
1728                 // The ASCII index of the '0' character is 48.
1729                 mstore8(str, add(48, mod(temp, 10)))
1730                 // Keep dividing `temp` until zero.
1731                 temp := div(temp, 10)
1732                 // prettier-ignore
1733                 if iszero(temp) { break }
1734             }
1735 
1736             let length := sub(end, str)
1737             // Move the pointer 32 bytes leftwards to make room for the length.
1738             str := sub(str, 0x20)
1739             // Store the length.
1740             mstore(str, length)
1741         }
1742     }
1743 }
1744 
1745 // File: dodo.sol
1746 
1747 
1748 pragma solidity ^0.8.9;
1749 
1750 
1751 
1752 
1753 
1754 
1755  
1756  
1757  
1758 contract PB is ERC721A, DefaultOperatorFilterer, Ownable, ReentrancyGuard { 
1759 event DevMintEvent(address ownerAddress, uint256 startWith, uint256 amountMinted);
1760 uint256 public devTotal;
1761     uint256 public _maxSupply = 333;
1762     uint256 public _mintPrice = 0.005 ether;
1763     uint256 public _maxMintPerTx = 10;
1764  
1765     uint256 public _maxFreeMintPerAddr = 1;
1766     uint256 public _maxFreeMintSupply = 50;
1767      uint256 public devSupply = 33;
1768  
1769     using Strings for uint256;
1770     string public baseURI;
1771  
1772     mapping(address => uint256) private _mintedFreeAmount;
1773  
1774  
1775     constructor(string memory initBaseURI) ERC721A("Paper Birds", "PB") {
1776         baseURI = initBaseURI;
1777     }
1778  
1779     function mint(uint256 count) external payable {
1780         uint256 cost = _mintPrice;
1781         bool isFree = ((totalSupply() + count < _maxFreeMintSupply + 1) &&
1782             (_mintedFreeAmount[msg.sender] + count <= _maxFreeMintPerAddr)) ||
1783             (msg.sender == owner());
1784  
1785         if (isFree) {
1786             cost = 0;
1787         }
1788  
1789         require(msg.value >= count * cost, "Please send the exact amount.");
1790         require(totalSupply() + count < _maxSupply - devSupply + 1, "Sold out!");
1791         require(count < _maxMintPerTx + 1, "Max per TX reached.");
1792  
1793         if (isFree) {
1794             _mintedFreeAmount[msg.sender] += count;
1795         }
1796  
1797         _safeMint(msg.sender, count);
1798     }
1799  
1800      function devMint() public onlyOwner {
1801         devTotal += devSupply;
1802         emit DevMintEvent(_msgSender(), devTotal, devSupply);
1803         _safeMint(msg.sender, devSupply);
1804     }
1805  
1806     function _baseURI() internal view virtual override returns (string memory) {
1807         return baseURI;
1808     }
1809  
1810  
1811 function isApprovedForAll(address owner, address operator)
1812         override
1813         public
1814         view
1815         returns (bool)
1816     {
1817         // Block X2Y2
1818         if (operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354) {
1819             return false;
1820         }
1821  
1822  
1823         return super.isApprovedForAll(owner, operator);
1824     }
1825  
1826  
1827  
1828     function tokenURI(uint256 tokenId)
1829         public
1830         view
1831         virtual
1832         override
1833         returns (string memory)
1834     {
1835         require(
1836             _exists(tokenId),
1837             "ERC721Metadata: URI query for nonexistent token"
1838         );
1839         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1840     }
1841  
1842     function setBaseURI(string memory uri) public onlyOwner {
1843         baseURI = uri;
1844     }
1845 
1846     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1847         super.setApprovalForAll(operator, approved);
1848     }
1849 
1850     function approve(address operator, uint256 tokenId) public payable  override onlyAllowedOperatorApproval(operator) {
1851         super.approve(operator, tokenId);
1852     }
1853 
1854     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1855         super.transferFrom(from, to, tokenId);
1856     }
1857 
1858     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1859         super.safeTransferFrom(from, to, tokenId);
1860     }
1861 
1862     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1863         public payable
1864         override
1865         onlyAllowedOperator(from)
1866     {
1867         super.safeTransferFrom(from, to, tokenId, data);
1868     }
1869  
1870     function setFreeAmount(uint256 amount) external onlyOwner {
1871         _maxFreeMintSupply = amount;
1872     }
1873  
1874     function setPrice(uint256 _newPrice) external onlyOwner {
1875         _mintPrice = _newPrice;
1876     }
1877  
1878     function withdraw() public payable onlyOwner nonReentrant {
1879         (bool success, ) = payable(msg.sender).call{
1880             value: address(this).balance
1881         }("");
1882         require(success);
1883     }
1884 }