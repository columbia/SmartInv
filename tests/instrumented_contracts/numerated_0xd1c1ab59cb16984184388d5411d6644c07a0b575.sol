1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 
5 ##     ## ##    ##  #######  ########  ########  #### ##    ##    ###    ##        ######  
6 ##     ## ###   ## ##     ## ##     ## ##     ##  ##  ###   ##   ## ##   ##       ##    ## 
7 ##     ## ####  ## ##     ## ##     ## ##     ##  ##  ####  ##  ##   ##  ##       ##       
8 ##     ## ## ## ## ##     ## ########  ##     ##  ##  ## ## ## ##     ## ##        ######  
9 ##     ## ##  #### ##     ## ##   ##   ##     ##  ##  ##  #### ######### ##             ## 
10 ##     ## ##   ### ##     ## ##    ##  ##     ##  ##  ##   ### ##     ## ##       ##    ## 
11  #######  ##    ##  #######  ##     ## ########  #### ##    ## ##     ## ########  ######  
12                                               
13 */
14 
15 
16 pragma solidity ^0.8.13;
17 
18 interface IOperatorFilterRegistry {
19     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
20     function register(address registrant) external;
21     function registerAndSubscribe(address registrant, address subscription) external;
22     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
23     function unregister(address addr) external;
24     function updateOperator(address registrant, address operator, bool filtered) external;
25     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
26     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
27     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
28     function subscribe(address registrant, address registrantToSubscribe) external;
29     function unsubscribe(address registrant, bool copyExistingEntries) external;
30     function subscriptionOf(address addr) external returns (address registrant);
31     function subscribers(address registrant) external returns (address[] memory);
32     function subscriberAt(address registrant, uint256 index) external returns (address);
33     function copyEntriesOf(address registrant, address registrantToCopy) external;
34     function isOperatorFiltered(address registrant, address operator) external returns (bool);
35     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
36     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
37     function filteredOperators(address addr) external returns (address[] memory);
38     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
39     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
40     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
41     function isRegistered(address addr) external returns (bool);
42     function codeHashOf(address addr) external returns (bytes32);
43 }
44 
45 pragma solidity ^0.8.13;
46 
47 /**
48  * @title  OperatorFilterer
49  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
50  *         registrant's entries in the OperatorFilterRegistry.
51  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
52  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
53  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
54  */
55 abstract contract OperatorFilterer {
56     error OperatorNotAllowed(address operator);
57 
58     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
59         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
60 
61     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
62         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
63         // will not revert, but the contract will need to be registered with the registry once it is deployed in
64         // order for the modifier to filter addresses.
65         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
66             if (subscribe) {
67                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
68             } else {
69                 if (subscriptionOrRegistrantToCopy != address(0)) {
70                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
71                 } else {
72                     OPERATOR_FILTER_REGISTRY.register(address(this));
73                 }
74             }
75         }
76     }
77 
78     modifier onlyAllowedOperator(address from) virtual {
79         // Allow spending tokens from addresses with balance
80         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
81         // from an EOA.
82         if (from != msg.sender) {
83             _checkFilterOperator(msg.sender);
84         }
85         _;
86     }
87 
88     modifier onlyAllowedOperatorApproval(address operator) virtual {
89         _checkFilterOperator(operator);
90         _;
91     }
92 
93     function _checkFilterOperator(address operator) internal view virtual {
94         // Check registry code length to facilitate testing in environments without a deployed registry.
95         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
96             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
97                 revert OperatorNotAllowed(operator);
98             }
99         }
100     }
101 }
102 
103 
104 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
105 
106 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Contract module that helps prevent reentrant calls to a function.
112  *
113  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
114  * available, which can be applied to functions to make sure there are no nested
115  * (reentrant) calls to them.
116  *
117  * Note that because there is a single `nonReentrant` guard, functions marked as
118  * `nonReentrant` may not call one another. This can be worked around by making
119  * those functions `private`, and then adding `external` `nonReentrant` entry
120  * points to them.
121  *
122  * TIP: If you would like to learn more about reentrancy and alternative ways
123  * to protect against it, check out our blog post
124  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
125  */
126 abstract contract ReentrancyGuard {
127     // Booleans are more expensive than uint256 or any type that takes up a full
128     // word because each write operation emits an extra SLOAD to first read the
129     // slot's contents, replace the bits taken up by the boolean, and then write
130     // back. This is the compiler's defense against contract upgrades and
131     // pointer aliasing, and it cannot be disabled.
132 
133     // The values being non-zero value makes deployment a bit more expensive,
134     // but in exchange the refund on every call to nonReentrant will be lower in
135     // amount. Since refunds are capped to a percentage of the total
136     // transaction's gas, it is best to keep them low in cases like this one, to
137     // increase the likelihood of the full refund coming into effect.
138     uint256 private constant _NOT_ENTERED = 1;
139     uint256 private constant _ENTERED = 2;
140 
141     uint256 private _status;
142 
143     constructor() {
144         _status = _NOT_ENTERED;
145     }
146 
147     /**
148      * @dev Prevents a contract from calling itself, directly or indirectly.
149      * Calling a `nonReentrant` function from another `nonReentrant`
150      * function is not supported. It is possible to prevent this from happening
151      * by making the `nonReentrant` function external, and making it call a
152      * `private` function that does the actual work.
153      */
154     modifier nonReentrant() {
155         // On the first call to nonReentrant, _notEntered will be true
156         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
157 
158         // Any calls to nonReentrant after this point will fail
159         _status = _ENTERED;
160 
161         _;
162 
163         // By storing the original value once again, a refund is triggered (see
164         // https://eips.ethereum.org/EIPS/eip-2200)
165         _status = _NOT_ENTERED;
166     }
167 }
168 
169 
170 
171 // File: @openzeppelin/contracts/utils/Strings.sol
172 
173 
174 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev String operations.
180  */
181 library Strings {
182     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
183     uint8 private constant _ADDRESS_LENGTH = 20;
184 
185     /**
186      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
187      */
188     function toString(uint256 value) internal pure returns (string memory) {
189         // Inspired by OraclizeAPI's implementation - MIT licence
190         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
191 
192         if (value == 0) {
193             return "0";
194         }
195         uint256 temp = value;
196         uint256 digits;
197         while (temp != 0) {
198             digits++;
199             temp /= 10;
200         }
201         bytes memory buffer = new bytes(digits);
202         while (value != 0) {
203             digits -= 1;
204             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
205             value /= 10;
206         }
207         return string(buffer);
208     }
209 
210     /**
211      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
212      */
213     function toHexString(uint256 value) internal pure returns (string memory) {
214         if (value == 0) {
215             return "0x00";
216         }
217         uint256 temp = value;
218         uint256 length = 0;
219         while (temp != 0) {
220             length++;
221             temp >>= 8;
222         }
223         return toHexString(value, length);
224     }
225 
226     /**
227      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
228      */
229     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
230         bytes memory buffer = new bytes(2 * length + 2);
231         buffer[0] = "0";
232         buffer[1] = "x";
233         for (uint256 i = 2 * length + 1; i > 1; --i) {
234             buffer[i] = _HEX_SYMBOLS[value & 0xf];
235             value >>= 4;
236         }
237         require(value == 0, "Strings: hex length insufficient");
238         return string(buffer);
239     }
240 
241     /**
242      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
243      */
244     function toHexString(address addr) internal pure returns (string memory) {
245         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
246     }
247 }
248 
249 // File: @openzeppelin/contracts/utils/Context.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev Provides information about the current execution context, including the
258  * sender of the transaction and its data. While these are generally available
259  * via msg.sender and msg.data, they should not be accessed in such a direct
260  * manner, since when dealing with meta-transactions the account sending and
261  * paying for execution may not be the actual sender (as far as an application
262  * is concerned).
263  *
264  * This contract is only required for intermediate, library-like contracts.
265  */
266 abstract contract Context {
267     function _msgSender() internal view virtual returns (address) {
268         return msg.sender;
269     }
270 
271     function _msgData() internal view virtual returns (bytes calldata) {
272         return msg.data;
273     }
274 }
275 
276 // File: @openzeppelin/contracts/access/Ownable.sol
277 
278 
279 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 
284 /**
285  * @dev Contract module which provides a basic access control mechanism, where
286  * there is an account (an owner) that can be granted exclusive access to
287  * specific functions.
288  *
289  * By default, the owner account will be the one that deploys the contract. This
290  * can later be changed with {transferOwnership}.
291  *
292  * This module is used through inheritance. It will make available the modifier
293  * `onlyOwner`, which can be applied to your functions to restrict their use to
294  * the owner.
295  */
296 abstract contract Ownable is Context {
297     address private _owner;
298 
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301     /**
302      * @dev Initializes the contract setting the deployer as the initial owner.
303      */
304     constructor() {
305         _transferOwnership(_msgSender());
306     }
307 
308     /**
309      * @dev Throws if called by any account other than the owner.
310      */
311     modifier onlyOwner() {
312         _checkOwner();
313         _;
314     }
315 
316     /**
317      * @dev Returns the address of the current owner.
318      */
319     function owner() public view virtual returns (address) {
320         return _owner;
321     }
322 
323     /**
324      * @dev Throws if the sender is not the owner.
325      */
326     function _checkOwner() internal view virtual {
327         require(owner() == _msgSender(), "Ownable: caller is not the owner");
328     }
329 
330     /**
331      * @dev Leaves the contract without owner. It will not be possible to call
332      * `onlyOwner` functions anymore. Can only be called by the current owner.
333      *
334      * NOTE: Renouncing ownership will leave the contract without an owner,
335      * thereby removing any functionality that is only available to the owner.
336      */
337     function renounceOwnership() public virtual onlyOwner {
338         _transferOwnership(address(0));
339     }
340 
341     /**
342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
343      * Can only be called by the current owner.
344      */
345     function transferOwnership(address newOwner) public virtual onlyOwner {
346         require(newOwner != address(0), "Ownable: new owner is the zero address");
347         _transferOwnership(newOwner);
348     }
349 
350     /**
351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
352      * Internal function without access restriction.
353      */
354     function _transferOwnership(address newOwner) internal virtual {
355         address oldOwner = _owner;
356         _owner = newOwner;
357         emit OwnershipTransferred(oldOwner, newOwner);
358     }
359 }
360 
361 // File: erc721a/contracts/IERC721A.sol
362 
363 
364 // ERC721A Contracts v4.1.0
365 // Creator: Chiru Labs
366 
367 pragma solidity ^0.8.4;
368 
369 /**
370  * @dev Interface of an ERC721A compliant contract.
371  */
372 interface IERC721A {
373     /**
374      * The caller must own the token or be an approved operator.
375      */
376     error ApprovalCallerNotOwnerNorApproved();
377 
378     /**
379      * The token does not exist.
380      */
381     error ApprovalQueryForNonexistentToken();
382 
383     /**
384      * The caller cannot approve to their own address.
385      */
386     error ApproveToCaller();
387 
388     /**
389      * Cannot query the balance for the zero address.
390      */
391     error BalanceQueryForZeroAddress();
392 
393     /**
394      * Cannot mint to the zero address.
395      */
396     error MintToZeroAddress();
397 
398     /**
399      * The quantity of tokens minted must be more than zero.
400      */
401     error MintZeroQuantity();
402 
403     /**
404      * The token does not exist.
405      */
406     error OwnerQueryForNonexistentToken();
407 
408     /**
409      * The caller must own the token or be an approved operator.
410      */
411     error TransferCallerNotOwnerNorApproved();
412 
413     /**
414      * The token must be owned by `from`.
415      */
416     error TransferFromIncorrectOwner();
417 
418     /**
419      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
420      */
421     error TransferToNonERC721ReceiverImplementer();
422 
423     /**
424      * Cannot transfer to the zero address.
425      */
426     error TransferToZeroAddress();
427 
428     /**
429      * The token does not exist.
430      */
431     error URIQueryForNonexistentToken();
432 
433     /**
434      * The `quantity` minted with ERC2309 exceeds the safety limit.
435      */
436     error MintERC2309QuantityExceedsLimit();
437 
438     /**
439      * The `extraData` cannot be set on an unintialized ownership slot.
440      */
441     error OwnershipNotInitializedForExtraData();
442 
443     struct TokenOwnership {
444         // The address of the owner.
445         address addr;
446         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
447         uint64 startTimestamp;
448         // Whether the token has been burned.
449         bool burned;
450         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
451         uint24 extraData;
452     }
453 
454     /**
455      * @dev Returns the total amount of tokens stored by the contract.
456      *
457      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
458      */
459     function totalSupply() external view returns (uint256);
460 
461     // ==============================
462     //            IERC165
463     // ==============================
464 
465     /**
466      * @dev Returns true if this contract implements the interface defined by
467      * `interfaceId`. See the corresponding
468      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
469      * to learn more about how these ids are created.
470      *
471      * This function call must use less than 30 000 gas.
472      */
473     function supportsInterface(bytes4 interfaceId) external view returns (bool);
474 
475     // ==============================
476     //            IERC721
477     // ==============================
478 
479     /**
480      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
481      */
482     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
483 
484     /**
485      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
486      */
487     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
488 
489     /**
490      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
491      */
492     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
493 
494     /**
495      * @dev Returns the number of tokens in ``owner``'s account.
496      */
497     function balanceOf(address owner) external view returns (uint256 balance);
498 
499     /**
500      * @dev Returns the owner of the `tokenId` token.
501      *
502      * Requirements:
503      *
504      * - `tokenId` must exist.
505      */
506     function ownerOf(uint256 tokenId) external view returns (address owner);
507 
508     /**
509      * @dev Safely transfers `tokenId` token from `from` to `to`.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must exist and be owned by `from`.
516      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
518      *
519      * Emits a {Transfer} event.
520      */
521     function safeTransferFrom(
522         address from,
523         address to,
524         uint256 tokenId,
525         bytes calldata data
526     ) external;
527 
528     /**
529      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
530      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must exist and be owned by `from`.
537      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
538      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
539      *
540      * Emits a {Transfer} event.
541      */
542     function safeTransferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) external;
547 
548     /**
549      * @dev Transfers `tokenId` token from `from` to `to`.
550      *
551      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must be owned by `from`.
558      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
559      *
560      * Emits a {Transfer} event.
561      */
562     function transferFrom(
563         address from,
564         address to,
565         uint256 tokenId
566     ) external;
567 
568     /**
569      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
570      * The approval is cleared when the token is transferred.
571      *
572      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
573      *
574      * Requirements:
575      *
576      * - The caller must own the token or be an approved operator.
577      * - `tokenId` must exist.
578      *
579      * Emits an {Approval} event.
580      */
581     function approve(address to, uint256 tokenId) external;
582 
583     /**
584      * @dev Approve or remove `operator` as an operator for the caller.
585      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
586      *
587      * Requirements:
588      *
589      * - The `operator` cannot be the caller.
590      *
591      * Emits an {ApprovalForAll} event.
592      */
593     function setApprovalForAll(address operator, bool _approved) external;
594 
595     /**
596      * @dev Returns the account approved for `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function getApproved(uint256 tokenId) external view returns (address operator);
603 
604     /**
605      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
606      *
607      * See {setApprovalForAll}
608      */
609     function isApprovedForAll(address owner, address operator) external view returns (bool);
610 
611     // ==============================
612     //        IERC721Metadata
613     // ==============================
614 
615     /**
616      * @dev Returns the token collection name.
617      */
618     function name() external view returns (string memory);
619 
620     /**
621      * @dev Returns the token collection symbol.
622      */
623     function symbol() external view returns (string memory);
624 
625     /**
626      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
627      */
628     function tokenURI(uint256 tokenId) external view returns (string memory);
629 
630     // ==============================
631     //            IERC2309
632     // ==============================
633 
634     /**
635      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
636      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
637      */
638     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
639 }
640 
641 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
642 
643 
644 // ERC721A Contracts v4.1.0
645 // Creator: Chiru Labs
646 
647 pragma solidity ^0.8.4;
648 
649 
650 /**
651  * @dev Interface of an ERC721ABurnable compliant contract.
652  */
653 interface IERC721ABurnable is IERC721A {
654     /**
655      * @dev Burns `tokenId`. See {ERC721A-_burn}.
656      *
657      * Requirements:
658      *
659      * - The caller must own `tokenId` or be an approved operator.
660      */
661     function burn(uint256 tokenId) external;
662 }
663 
664 // File: erc721a/contracts/ERC721A.sol
665 
666 
667 // ERC721A Contracts v4.1.0
668 // Creator: Chiru Labs
669 
670 pragma solidity ^0.8.4;
671 
672 
673 /**
674  * @dev ERC721 token receiver interface.
675  */
676 interface ERC721A__IERC721Receiver {
677     function onERC721Received(
678         address operator,
679         address from,
680         uint256 tokenId,
681         bytes calldata data
682     ) external returns (bytes4);
683 }
684 
685 /**
686  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
687  * including the Metadata extension. Built to optimize for lower gas during batch mints.
688  *
689  * Assumes serials are sequentially minted starting at `_startTokenId()`
690  * (defaults to 0, e.g. 0, 1, 2, 3..).
691  *
692  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
693  *
694  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
695  */
696 contract ERC721A is IERC721A {
697     // Mask of an entry in packed address data.
698     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
699 
700     // The bit position of `numberMinted` in packed address data.
701     uint256 private constant BITPOS_NUMBER_MINTED = 64;
702 
703     // The bit position of `numberBurned` in packed address data.
704     uint256 private constant BITPOS_NUMBER_BURNED = 128;
705 
706     // The bit position of `aux` in packed address data.
707     uint256 private constant BITPOS_AUX = 192;
708 
709     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
710     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
711 
712     // The bit position of `startTimestamp` in packed ownership.
713     uint256 private constant BITPOS_START_TIMESTAMP = 160;
714 
715     // The bit mask of the `burned` bit in packed ownership.
716     uint256 private constant BITMASK_BURNED = 1 << 224;
717 
718     // The bit position of the `nextInitialized` bit in packed ownership.
719     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
720 
721     // The bit mask of the `nextInitialized` bit in packed ownership.
722     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
723 
724     // The bit position of `extraData` in packed ownership.
725     uint256 private constant BITPOS_EXTRA_DATA = 232;
726 
727     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
728     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
729 
730     // The mask of the lower 160 bits for addresses.
731     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
732 
733     // The maximum `quantity` that can be minted with `_mintERC2309`.
734     // This limit is to prevent overflows on the address data entries.
735     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
736     // is required to cause an overflow, which is unrealistic.
737     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
738 
739     // The tokenId of the next token to be minted.
740     uint256 private _currentIndex;
741 
742     // The number of tokens burned.
743     uint256 private _burnCounter;
744 
745     // Token name
746     string private _name;
747 
748     // Token symbol
749     string private _symbol;
750 
751     // Mapping from token ID to ownership details
752     // An empty struct value does not necessarily mean the token is unowned.
753     // See `_packedOwnershipOf` implementation for details.
754     //
755     // Bits Layout:
756     // - [0..159]   `addr`
757     // - [160..223] `startTimestamp`
758     // - [224]      `burned`
759     // - [225]      `nextInitialized`
760     // - [232..255] `extraData`
761     mapping(uint256 => uint256) private _packedOwnerships;
762 
763     // Mapping owner address to address data.
764     //
765     // Bits Layout:
766     // - [0..63]    `balance`
767     // - [64..127]  `numberMinted`
768     // - [128..191] `numberBurned`
769     // - [192..255] `aux`
770     mapping(address => uint256) private _packedAddressData;
771 
772     // Mapping from token ID to approved address.
773     mapping(uint256 => address) private _tokenApprovals;
774 
775     // Mapping from owner to operator approvals
776     mapping(address => mapping(address => bool)) private _operatorApprovals;
777 
778     constructor(string memory name_, string memory symbol_) {
779         _name = name_;
780         _symbol = symbol_;
781         _currentIndex = _startTokenId();
782     }
783 
784     /**
785      * @dev Returns the starting token ID.
786      * To change the starting token ID, please override this function.
787      */
788     function _startTokenId() internal view virtual returns (uint256) {
789         return 0;
790     }
791 
792     /**
793      * @dev Returns the next token ID to be minted.
794      */
795     function _nextTokenId() internal view returns (uint256) {
796         return _currentIndex;
797     }
798 
799     /**
800      * @dev Returns the total number of tokens in existence.
801      * Burned tokens will reduce the count.
802      * To get the total number of tokens minted, please see `_totalMinted`.
803      */
804     function totalSupply() public view override returns (uint256) {
805         // Counter underflow is impossible as _burnCounter cannot be incremented
806         // more than `_currentIndex - _startTokenId()` times.
807         unchecked {
808             return _currentIndex - _burnCounter - _startTokenId();
809         }
810     }
811 
812     /**
813      * @dev Returns the total amount of tokens minted in the contract.
814      */
815     function _totalMinted() internal view returns (uint256) {
816         // Counter underflow is impossible as _currentIndex does not decrement,
817         // and it is initialized to `_startTokenId()`
818         unchecked {
819             return _currentIndex - _startTokenId();
820         }
821     }
822 
823     /**
824      * @dev Returns the total number of tokens burned.
825      */
826     function _totalBurned() internal view returns (uint256) {
827         return _burnCounter;
828     }
829 
830     /**
831      * @dev See {IERC165-supportsInterface}.
832      */
833     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
834         // The interface IDs are constants representing the first 4 bytes of the XOR of
835         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
836         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
837         return
838             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
839             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
840             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
841     }
842 
843     /**
844      * @dev See {IERC721-balanceOf}.
845      */
846     function balanceOf(address owner) public view override returns (uint256) {
847         if (owner == address(0)) revert BalanceQueryForZeroAddress();
848         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
849     }
850 
851     /**
852      * Returns the number of tokens minted by `owner`.
853      */
854     function _numberMinted(address owner) internal view returns (uint256) {
855         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
856     }
857 
858     /**
859      * Returns the number of tokens burned by or on behalf of `owner`.
860      */
861     function _numberBurned(address owner) internal view returns (uint256) {
862         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
863     }
864 
865     /**
866      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
867      */
868     function _getAux(address owner) internal view returns (uint64) {
869         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
870     }
871 
872     /**
873      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
874      * If there are multiple variables, please pack them into a uint64.
875      */
876     function _setAux(address owner, uint64 aux) internal {
877         uint256 packed = _packedAddressData[owner];
878         uint256 auxCasted;
879         // Cast `aux` with assembly to avoid redundant masking.
880         assembly {
881             auxCasted := aux
882         }
883         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
884         _packedAddressData[owner] = packed;
885     }
886 
887     /**
888      * Returns the packed ownership data of `tokenId`.
889      */
890     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
891         uint256 curr = tokenId;
892 
893         unchecked {
894             if (_startTokenId() <= curr)
895                 if (curr < _currentIndex) {
896                     uint256 packed = _packedOwnerships[curr];
897                     // If not burned.
898                     if (packed & BITMASK_BURNED == 0) {
899                         // Invariant:
900                         // There will always be an ownership that has an address and is not burned
901                         // before an ownership that does not have an address and is not burned.
902                         // Hence, curr will not underflow.
903                         //
904                         // We can directly compare the packed value.
905                         // If the address is zero, packed is zero.
906                         while (packed == 0) {
907                             packed = _packedOwnerships[--curr];
908                         }
909                         return packed;
910                     }
911                 }
912         }
913         revert OwnerQueryForNonexistentToken();
914     }
915 
916     /**
917      * Returns the unpacked `TokenOwnership` struct from `packed`.
918      */
919     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
920         ownership.addr = address(uint160(packed));
921         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
922         ownership.burned = packed & BITMASK_BURNED != 0;
923         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
924     }
925 
926     /**
927      * Returns the unpacked `TokenOwnership` struct at `index`.
928      */
929     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
930         return _unpackedOwnership(_packedOwnerships[index]);
931     }
932 
933     /**
934      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
935      */
936     function _initializeOwnershipAt(uint256 index) internal {
937         if (_packedOwnerships[index] == 0) {
938             _packedOwnerships[index] = _packedOwnershipOf(index);
939         }
940     }
941 
942     /**
943      * Gas spent here starts off proportional to the maximum mint batch size.
944      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
945      */
946     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
947         return _unpackedOwnership(_packedOwnershipOf(tokenId));
948     }
949 
950     /**
951      * @dev Packs ownership data into a single uint256.
952      */
953     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
954         assembly {
955             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
956             owner := and(owner, BITMASK_ADDRESS)
957             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
958             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
959         }
960     }
961 
962     /**
963      * @dev See {IERC721-ownerOf}.
964      */
965     function ownerOf(uint256 tokenId) public view override returns (address) {
966         return address(uint160(_packedOwnershipOf(tokenId)));
967     }
968 
969     /**
970      * @dev See {IERC721Metadata-name}.
971      */
972     function name() public view virtual override returns (string memory) {
973         return _name;
974     }
975 
976     /**
977      * @dev See {IERC721Metadata-symbol}.
978      */
979     function symbol() public view virtual override returns (string memory) {
980         return _symbol;
981     }
982 
983     /**
984      * @dev See {IERC721Metadata-tokenURI}.
985      */
986     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
987         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
988 
989         string memory baseURI = _baseURI();
990         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
991     }
992 
993     /**
994      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
995      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
996      * by default, it can be overridden in child contracts.
997      */
998     function _baseURI() internal view virtual returns (string memory) {
999         return '';
1000     }
1001 
1002     /**
1003      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1004      */
1005     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1006         // For branchless setting of the `nextInitialized` flag.
1007         assembly {
1008             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1009             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1010         }
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-approve}.
1015      */
1016     function approve(address to, uint256 tokenId) virtual public override {
1017         address owner = ownerOf(tokenId);
1018 
1019         if (_msgSenderERC721A() != owner)
1020             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1021                 revert ApprovalCallerNotOwnerNorApproved();
1022             }
1023 
1024         _tokenApprovals[tokenId] = to;
1025         emit Approval(owner, to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-getApproved}.
1030      */
1031     function getApproved(uint256 tokenId) public view override returns (address) {
1032         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1033 
1034         return _tokenApprovals[tokenId];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-setApprovalForAll}.
1039      */
1040     function setApprovalForAll(address operator, bool approved) public virtual override {
1041         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1042 
1043         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1044         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-isApprovedForAll}.
1049      */
1050     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1051         return _operatorApprovals[owner][operator];
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-safeTransferFrom}.
1056      */
1057     function safeTransferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) public virtual override {
1062         safeTransferFrom(from, to, tokenId, '');
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-safeTransferFrom}.
1067      */
1068     function safeTransferFrom(
1069         address from,
1070         address to,
1071         uint256 tokenId,
1072         bytes memory _data
1073     ) public virtual override {
1074         transferFrom(from, to, tokenId);
1075         if (to.code.length != 0)
1076             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1077                 revert TransferToNonERC721ReceiverImplementer();
1078             }
1079     }
1080 
1081     /**
1082      * @dev Returns whether `tokenId` exists.
1083      *
1084      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1085      *
1086      * Tokens start existing when they are minted (`_mint`),
1087      */
1088     function _exists(uint256 tokenId) internal view returns (bool) {
1089         return
1090             _startTokenId() <= tokenId &&
1091             tokenId < _currentIndex && // If within bounds,
1092             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1093     }
1094 
1095     /**
1096      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1097      */
1098     function _safeMint(address to, uint256 quantity) internal {
1099         _safeMint(to, quantity, '');
1100     }
1101 
1102     /**
1103      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1104      *
1105      * Requirements:
1106      *
1107      * - If `to` refers to a smart contract, it must implement
1108      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1109      * - `quantity` must be greater than 0.
1110      *
1111      * See {_mint}.
1112      *
1113      * Emits a {Transfer} event for each mint.
1114      */
1115     function _safeMint(
1116         address to,
1117         uint256 quantity,
1118         bytes memory _data
1119     ) internal {
1120         _mint(to, quantity);
1121 
1122         unchecked {
1123             if (to.code.length != 0) {
1124                 uint256 end = _currentIndex;
1125                 uint256 index = end - quantity;
1126                 do {
1127                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1128                         revert TransferToNonERC721ReceiverImplementer();
1129                     }
1130                 } while (index < end);
1131                 // Reentrancy protection.
1132                 if (_currentIndex != end) revert();
1133             }
1134         }
1135     }
1136 
1137     /**
1138      * @dev Mints `quantity` tokens and transfers them to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `quantity` must be greater than 0.
1144      *
1145      * Emits a {Transfer} event for each mint.
1146      */
1147     function _mint(address to, uint256 quantity) internal {
1148         uint256 startTokenId = _currentIndex;
1149         if (to == address(0)) revert MintToZeroAddress();
1150         if (quantity == 0) revert MintZeroQuantity();
1151 
1152         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1153 
1154         // Overflows are incredibly unrealistic.
1155         // `balance` and `numberMinted` have a maximum limit of 2**64.
1156         // `tokenId` has a maximum limit of 2**256.
1157         unchecked {
1158             // Updates:
1159             // - `balance += quantity`.
1160             // - `numberMinted += quantity`.
1161             //
1162             // We can directly add to the `balance` and `numberMinted`.
1163             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1164 
1165             // Updates:
1166             // - `address` to the owner.
1167             // - `startTimestamp` to the timestamp of minting.
1168             // - `burned` to `false`.
1169             // - `nextInitialized` to `quantity == 1`.
1170             _packedOwnerships[startTokenId] = _packOwnershipData(
1171                 to,
1172                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1173             );
1174 
1175             uint256 tokenId = startTokenId;
1176             uint256 end = startTokenId + quantity;
1177             do {
1178                 emit Transfer(address(0), to, tokenId++);
1179             } while (tokenId < end);
1180 
1181             _currentIndex = end;
1182         }
1183         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1184     }
1185 
1186     /**
1187      * @dev Mints `quantity` tokens and transfers them to `to`.
1188      *
1189      * This function is intended for efficient minting only during contract creation.
1190      *
1191      * It emits only one {ConsecutiveTransfer} as defined in
1192      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1193      * instead of a sequence of {Transfer} event(s).
1194      *
1195      * Calling this function outside of contract creation WILL make your contract
1196      * non-compliant with the ERC721 standard.
1197      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1198      * {ConsecutiveTransfer} event is only permissible during contract creation.
1199      *
1200      * Requirements:
1201      *
1202      * - `to` cannot be the zero address.
1203      * - `quantity` must be greater than 0.
1204      *
1205      * Emits a {ConsecutiveTransfer} event.
1206      */
1207     function _mintERC2309(address to, uint256 quantity) internal {
1208         uint256 startTokenId = _currentIndex;
1209         if (to == address(0)) revert MintToZeroAddress();
1210         if (quantity == 0) revert MintZeroQuantity();
1211         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1212 
1213         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1214 
1215         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1216         unchecked {
1217             // Updates:
1218             // - `balance += quantity`.
1219             // - `numberMinted += quantity`.
1220             //
1221             // We can directly add to the `balance` and `numberMinted`.
1222             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1223 
1224             // Updates:
1225             // - `address` to the owner.
1226             // - `startTimestamp` to the timestamp of minting.
1227             // - `burned` to `false`.
1228             // - `nextInitialized` to `quantity == 1`.
1229             _packedOwnerships[startTokenId] = _packOwnershipData(
1230                 to,
1231                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1232             );
1233 
1234             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1235 
1236             _currentIndex = startTokenId + quantity;
1237         }
1238         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1239     }
1240 
1241     /**
1242      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1243      */
1244     function _getApprovedAddress(uint256 tokenId)
1245         private
1246         view
1247         returns (uint256 approvedAddressSlot, address approvedAddress)
1248     {
1249         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1250         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1251         assembly {
1252             // Compute the slot.
1253             mstore(0x00, tokenId)
1254             mstore(0x20, tokenApprovalsPtr.slot)
1255             approvedAddressSlot := keccak256(0x00, 0x40)
1256             // Load the slot's value from storage.
1257             approvedAddress := sload(approvedAddressSlot)
1258         }
1259     }
1260 
1261     /**
1262      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1263      */
1264     function _isOwnerOrApproved(
1265         address approvedAddress,
1266         address from,
1267         address msgSender
1268     ) private pure returns (bool result) {
1269         assembly {
1270             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1271             from := and(from, BITMASK_ADDRESS)
1272             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1273             msgSender := and(msgSender, BITMASK_ADDRESS)
1274             // `msgSender == from || msgSender == approvedAddress`.
1275             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1276         }
1277     }
1278 
1279     /**
1280      * @dev Transfers `tokenId` from `from` to `to`.
1281      *
1282      * Requirements:
1283      *
1284      * - `to` cannot be the zero address.
1285      * - `tokenId` token must be owned by `from`.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function transferFrom(
1290         address from,
1291         address to,
1292         uint256 tokenId
1293     ) public virtual override {
1294         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1295 
1296         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1297 
1298         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1299 
1300         // The nested ifs save around 20+ gas over a compound boolean condition.
1301         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1302             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1303 
1304         if (to == address(0)) revert TransferToZeroAddress();
1305 
1306         _beforeTokenTransfers(from, to, tokenId, 1);
1307 
1308         // Clear approvals from the previous owner.
1309         assembly {
1310             if approvedAddress {
1311                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1312                 sstore(approvedAddressSlot, 0)
1313             }
1314         }
1315 
1316         // Underflow of the sender's balance is impossible because we check for
1317         // ownership above and the recipient's balance can't realistically overflow.
1318         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1319         unchecked {
1320             // We can directly increment and decrement the balances.
1321             --_packedAddressData[from]; // Updates: `balance -= 1`.
1322             ++_packedAddressData[to]; // Updates: `balance += 1`.
1323 
1324             // Updates:
1325             // - `address` to the next owner.
1326             // - `startTimestamp` to the timestamp of transfering.
1327             // - `burned` to `false`.
1328             // - `nextInitialized` to `true`.
1329             _packedOwnerships[tokenId] = _packOwnershipData(
1330                 to,
1331                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1332             );
1333 
1334             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1335             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1336                 uint256 nextTokenId = tokenId + 1;
1337                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1338                 if (_packedOwnerships[nextTokenId] == 0) {
1339                     // If the next slot is within bounds.
1340                     if (nextTokenId != _currentIndex) {
1341                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1342                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1343                     }
1344                 }
1345             }
1346         }
1347 
1348         emit Transfer(from, to, tokenId);
1349         _afterTokenTransfers(from, to, tokenId, 1);
1350     }
1351 
1352     /**
1353      * @dev Equivalent to `_burn(tokenId, false)`.
1354      */
1355     function _burn(uint256 tokenId) internal virtual {
1356         _burn(tokenId, false);
1357     }
1358 
1359     /**
1360      * @dev Destroys `tokenId`.
1361      * The approval is cleared when the token is burned.
1362      *
1363      * Requirements:
1364      *
1365      * - `tokenId` must exist.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1370         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1371 
1372         address from = address(uint160(prevOwnershipPacked));
1373 
1374         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1375 
1376         if (approvalCheck) {
1377             // The nested ifs save around 20+ gas over a compound boolean condition.
1378             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1379                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1380         }
1381 
1382         _beforeTokenTransfers(from, address(0), tokenId, 1);
1383 
1384         // Clear approvals from the previous owner.
1385         assembly {
1386             if approvedAddress {
1387                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1388                 sstore(approvedAddressSlot, 0)
1389             }
1390         }
1391 
1392         // Underflow of the sender's balance is impossible because we check for
1393         // ownership above and the recipient's balance can't realistically overflow.
1394         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1395         unchecked {
1396             // Updates:
1397             // - `balance -= 1`.
1398             // - `numberBurned += 1`.
1399             //
1400             // We can directly decrement the balance, and increment the number burned.
1401             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1402             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1403 
1404             // Updates:
1405             // - `address` to the last owner.
1406             // - `startTimestamp` to the timestamp of burning.
1407             // - `burned` to `true`.
1408             // - `nextInitialized` to `true`.
1409             _packedOwnerships[tokenId] = _packOwnershipData(
1410                 from,
1411                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1412             );
1413 
1414             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1415             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1416                 uint256 nextTokenId = tokenId + 1;
1417                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1418                 if (_packedOwnerships[nextTokenId] == 0) {
1419                     // If the next slot is within bounds.
1420                     if (nextTokenId != _currentIndex) {
1421                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1422                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1423                     }
1424                 }
1425             }
1426         }
1427 
1428         emit Transfer(from, address(0), tokenId);
1429         _afterTokenTransfers(from, address(0), tokenId, 1);
1430 
1431         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1432         unchecked {
1433             _burnCounter++;
1434         }
1435     }
1436 
1437     /**
1438      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1439      *
1440      * @param from address representing the previous owner of the given token ID
1441      * @param to target address that will receive the tokens
1442      * @param tokenId uint256 ID of the token to be transferred
1443      * @param _data bytes optional data to send along with the call
1444      * @return bool whether the call correctly returned the expected magic value
1445      */
1446     function _checkContractOnERC721Received(
1447         address from,
1448         address to,
1449         uint256 tokenId,
1450         bytes memory _data
1451     ) private returns (bool) {
1452         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1453             bytes4 retval
1454         ) {
1455             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1456         } catch (bytes memory reason) {
1457             if (reason.length == 0) {
1458                 revert TransferToNonERC721ReceiverImplementer();
1459             } else {
1460                 assembly {
1461                     revert(add(32, reason), mload(reason))
1462                 }
1463             }
1464         }
1465     }
1466 
1467     /**
1468      * @dev Directly sets the extra data for the ownership data `index`.
1469      */
1470     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1471         uint256 packed = _packedOwnerships[index];
1472         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1473         uint256 extraDataCasted;
1474         // Cast `extraData` with assembly to avoid redundant masking.
1475         assembly {
1476             extraDataCasted := extraData
1477         }
1478         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1479         _packedOwnerships[index] = packed;
1480     }
1481 
1482     /**
1483      * @dev Returns the next extra data for the packed ownership data.
1484      * The returned result is shifted into position.
1485      */
1486     function _nextExtraData(
1487         address from,
1488         address to,
1489         uint256 prevOwnershipPacked
1490     ) private view returns (uint256) {
1491         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1492         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1493     }
1494 
1495     /**
1496      * @dev Called during each token transfer to set the 24bit `extraData` field.
1497      * Intended to be overridden by the cosumer contract.
1498      *
1499      * `previousExtraData` - the value of `extraData` before transfer.
1500      *
1501      * Calling conditions:
1502      *
1503      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1504      * transferred to `to`.
1505      * - When `from` is zero, `tokenId` will be minted for `to`.
1506      * - When `to` is zero, `tokenId` will be burned by `from`.
1507      * - `from` and `to` are never both zero.
1508      */
1509     function _extraData(
1510         address from,
1511         address to,
1512         uint24 previousExtraData
1513     ) internal view virtual returns (uint24) {}
1514 
1515     /**
1516      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1517      * This includes minting.
1518      * And also called before burning one token.
1519      *
1520      * startTokenId - the first token id to be transferred
1521      * quantity - the amount to be transferred
1522      *
1523      * Calling conditions:
1524      *
1525      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1526      * transferred to `to`.
1527      * - When `from` is zero, `tokenId` will be minted for `to`.
1528      * - When `to` is zero, `tokenId` will be burned by `from`.
1529      * - `from` and `to` are never both zero.
1530      */
1531     function _beforeTokenTransfers(
1532         address from,
1533         address to,
1534         uint256 startTokenId,
1535         uint256 quantity
1536     ) internal virtual {}
1537 
1538     /**
1539      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1540      * This includes minting.
1541      * And also called after one token has been burned.
1542      *
1543      * startTokenId - the first token id to be transferred
1544      * quantity - the amount to be transferred
1545      *
1546      * Calling conditions:
1547      *
1548      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1549      * transferred to `to`.
1550      * - When `from` is zero, `tokenId` has been minted for `to`.
1551      * - When `to` is zero, `tokenId` has been burned by `from`.
1552      * - `from` and `to` are never both zero.
1553      */
1554     function _afterTokenTransfers(
1555         address from,
1556         address to,
1557         uint256 startTokenId,
1558         uint256 quantity
1559     ) internal virtual {}
1560 
1561     /**
1562      * @dev Returns the message sender (defaults to `msg.sender`).
1563      *
1564      * If you are writing GSN compatible contracts, you need to override this function.
1565      */
1566     function _msgSenderERC721A() internal view virtual returns (address) {
1567         return msg.sender;
1568     }
1569 
1570     /**
1571      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1572      */
1573     function _toString(uint256 value) internal pure returns (string memory ptr) {
1574         assembly {
1575             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1576             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1577             // We will need 1 32-byte word to store the length,
1578             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1579             ptr := add(mload(0x40), 128)
1580             // Update the free memory pointer to allocate.
1581             mstore(0x40, ptr)
1582 
1583             // Cache the end of the memory to calculate the length later.
1584             let end := ptr
1585 
1586             // We write the string from the rightmost digit to the leftmost digit.
1587             // The following is essentially a do-while loop that also handles the zero case.
1588             // Costs a bit more than early returning for the zero case,
1589             // but cheaper in terms of deployment and overall runtime costs.
1590             for {
1591                 // Initialize and perform the first pass without check.
1592                 let temp := value
1593                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1594                 ptr := sub(ptr, 1)
1595                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1596                 mstore8(ptr, add(48, mod(temp, 10)))
1597                 temp := div(temp, 10)
1598             } temp {
1599                 // Keep dividing `temp` until zero.
1600                 temp := div(temp, 10)
1601             } {
1602                 // Body of the for loop.
1603                 ptr := sub(ptr, 1)
1604                 mstore8(ptr, add(48, mod(temp, 10)))
1605             }
1606 
1607             let length := sub(end, ptr)
1608             // Move the pointer 32 bytes leftwards to make room for the length.
1609             ptr := sub(ptr, 32)
1610             // Store the length.
1611             mstore(ptr, length)
1612         }
1613     }
1614 }
1615 
1616 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1617 
1618 
1619 // ERC721A Contracts v4.1.0
1620 // Creator: Chiru Labs
1621 
1622 pragma solidity ^0.8.4;
1623 
1624 
1625 
1626 /**
1627  * @title ERC721A Burnable Token
1628  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1629  */
1630 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1631     /**
1632      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1633      *
1634      * Requirements:
1635      *
1636      * - The caller must own `tokenId` or be an approved operator.
1637      */
1638     function burn(uint256 tokenId) public virtual override {
1639         _burn(tokenId, true);
1640     }
1641 }
1642 
1643 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1644 
1645 
1646 // ERC721A Contracts v4.1.0
1647 // Creator: Chiru Labs
1648 
1649 pragma solidity ^0.8.4;
1650 
1651 
1652 /**
1653  * @dev Interface of an ERC721AQueryable compliant contract.
1654  */
1655 interface IERC721AQueryable is IERC721A {
1656     /**
1657      * Invalid query range (`start` >= `stop`).
1658      */
1659     error InvalidQueryRange();
1660 
1661     /**
1662      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1663      *
1664      * If the `tokenId` is out of bounds:
1665      *   - `addr` = `address(0)`
1666      *   - `startTimestamp` = `0`
1667      *   - `burned` = `false`
1668      *
1669      * If the `tokenId` is burned:
1670      *   - `addr` = `<Address of owner before token was burned>`
1671      *   - `startTimestamp` = `<Timestamp when token was burned>`
1672      *   - `burned = `true`
1673      *
1674      * Otherwise:
1675      *   - `addr` = `<Address of owner>`
1676      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1677      *   - `burned = `false`
1678      */
1679     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1680 
1681     /**
1682      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1683      * See {ERC721AQueryable-explicitOwnershipOf}
1684      */
1685     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1686 
1687     /**
1688      * @dev Returns an array of token IDs owned by `owner`,
1689      * in the range [`start`, `stop`)
1690      * (i.e. `start <= tokenId < stop`).
1691      *
1692      * This function allows for tokens to be queried if the collection
1693      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1694      *
1695      * Requirements:
1696      *
1697      * - `start` < `stop`
1698      */
1699     function tokensOfOwnerIn(
1700         address owner,
1701         uint256 start,
1702         uint256 stop
1703     ) external view returns (uint256[] memory);
1704 
1705     /**
1706      * @dev Returns an array of token IDs owned by `owner`.
1707      *
1708      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1709      * It is meant to be called off-chain.
1710      *
1711      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1712      * multiple smaller scans if the collection is large enough to cause
1713      * an out-of-gas error (10K pfp collections should be fine).
1714      */
1715     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1716 }
1717 
1718 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1719 
1720 
1721 // ERC721A Contracts v4.1.0
1722 // Creator: Chiru Labs
1723 
1724 pragma solidity ^0.8.4;
1725 
1726 
1727 
1728 /**
1729  * @title ERC721A Queryable
1730  * @dev ERC721A subclass with convenience query functions.
1731  */
1732 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1733     /**
1734      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1735      *
1736      * If the `tokenId` is out of bounds:
1737      *   - `addr` = `address(0)`
1738      *   - `startTimestamp` = `0`
1739      *   - `burned` = `false`
1740      *   - `extraData` = `0`
1741      *
1742      * If the `tokenId` is burned:
1743      *   - `addr` = `<Address of owner before token was burned>`
1744      *   - `startTimestamp` = `<Timestamp when token was burned>`
1745      *   - `burned = `true`
1746      *   - `extraData` = `<Extra data when token was burned>`
1747      *
1748      * Otherwise:
1749      *   - `addr` = `<Address of owner>`
1750      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1751      *   - `burned = `false`
1752      *   - `extraData` = `<Extra data at start of ownership>`
1753      */
1754     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1755         TokenOwnership memory ownership;
1756         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1757             return ownership;
1758         }
1759         ownership = _ownershipAt(tokenId);
1760         if (ownership.burned) {
1761             return ownership;
1762         }
1763         return _ownershipOf(tokenId);
1764     }
1765 
1766     /**
1767      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1768      * See {ERC721AQueryable-explicitOwnershipOf}
1769      */
1770     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1771         unchecked {
1772             uint256 tokenIdsLength = tokenIds.length;
1773             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1774             for (uint256 i; i != tokenIdsLength; ++i) {
1775                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1776             }
1777             return ownerships;
1778         }
1779     }
1780 
1781     /**
1782      * @dev Returns an array of token IDs owned by `owner`,
1783      * in the range [`start`, `stop`)
1784      * (i.e. `start <= tokenId < stop`).
1785      *
1786      * This function allows for tokens to be queried if the collection
1787      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1788      *
1789      * Requirements:
1790      *
1791      * - `start` < `stop`
1792      */
1793     function tokensOfOwnerIn(
1794         address owner,
1795         uint256 start,
1796         uint256 stop
1797     ) external view override returns (uint256[] memory) {
1798         unchecked {
1799             if (start >= stop) revert InvalidQueryRange();
1800             uint256 tokenIdsIdx;
1801             uint256 stopLimit = _nextTokenId();
1802             // Set `start = max(start, _startTokenId())`.
1803             if (start < _startTokenId()) {
1804                 start = _startTokenId();
1805             }
1806             // Set `stop = min(stop, stopLimit)`.
1807             if (stop > stopLimit) {
1808                 stop = stopLimit;
1809             }
1810             uint256 tokenIdsMaxLength = balanceOf(owner);
1811             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1812             // to cater for cases where `balanceOf(owner)` is too big.
1813             if (start < stop) {
1814                 uint256 rangeLength = stop - start;
1815                 if (rangeLength < tokenIdsMaxLength) {
1816                     tokenIdsMaxLength = rangeLength;
1817                 }
1818             } else {
1819                 tokenIdsMaxLength = 0;
1820             }
1821             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1822             if (tokenIdsMaxLength == 0) {
1823                 return tokenIds;
1824             }
1825             // We need to call `explicitOwnershipOf(start)`,
1826             // because the slot at `start` may not be initialized.
1827             TokenOwnership memory ownership = explicitOwnershipOf(start);
1828             address currOwnershipAddr;
1829             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1830             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1831             if (!ownership.burned) {
1832                 currOwnershipAddr = ownership.addr;
1833             }
1834             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1835                 ownership = _ownershipAt(i);
1836                 if (ownership.burned) {
1837                     continue;
1838                 }
1839                 if (ownership.addr != address(0)) {
1840                     currOwnershipAddr = ownership.addr;
1841                 }
1842                 if (currOwnershipAddr == owner) {
1843                     tokenIds[tokenIdsIdx++] = i;
1844                 }
1845             }
1846             // Downsize the array to fit.
1847             assembly {
1848                 mstore(tokenIds, tokenIdsIdx)
1849             }
1850             return tokenIds;
1851         }
1852     }
1853 
1854     /**
1855      * @dev Returns an array of token IDs owned by `owner`.
1856      *
1857      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1858      * It is meant to be called off-chain.
1859      *
1860      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1861      * multiple smaller scans if the collection is large enough to cause
1862      * an out-of-gas error (10K pfp collections should be fine).
1863      */
1864     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1865         unchecked {
1866             uint256 tokenIdsIdx;
1867             address currOwnershipAddr;
1868             uint256 tokenIdsLength = balanceOf(owner);
1869             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1870             TokenOwnership memory ownership;
1871             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1872                 ownership = _ownershipAt(i);
1873                 if (ownership.burned) {
1874                     continue;
1875                 }
1876                 if (ownership.addr != address(0)) {
1877                     currOwnershipAddr = ownership.addr;
1878                 }
1879                 if (currOwnershipAddr == owner) {
1880                     tokenIds[tokenIdsIdx++] = i;
1881                 }
1882             }
1883             return tokenIds;
1884         }
1885     }
1886 }
1887 
1888 
1889 // File: contracts/Unordinals.sol
1890 
1891 pragma solidity >=0.8.0 <0.9.0;
1892 
1893 contract Unordinals is ERC721AQueryable, ERC721ABurnable, Ownable, ReentrancyGuard, OperatorFilterer {
1894 
1895   using Strings for uint256;
1896   address public signerAddress;
1897     
1898   string public uriPrefix = "https://bafybeibjqxtn2b6u6yeijubnvypwvvwxiqfj3i2npmqgto7wuoioryxkoa.ipfs.dweb.link/";
1899   string public notRevealedURI;
1900   string public uriSuffix = ".json";
1901   
1902   uint256 public cost = 0.05 ether;
1903   uint256 public maxSupply = 1000;
1904   
1905   uint256 public maxPerWallet = 2;
1906   uint256 public maxPerTx = 2;
1907 
1908   bool public publicMintEnabled = false;
1909   bool public whitelistMintEnabled = true;
1910 
1911   bool public paused = false;
1912   bool public revealed = true;
1913   bool public burnEnabled = false;
1914 
1915   mapping(address => uint) public burntByOwner;
1916   mapping(address => uint) public addressMintedBalance;
1917 
1918   constructor() ERC721A ( "Unordinals", "BTC" ) OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), true) {}
1919 
1920 
1921 // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
1922   modifier mintCompliance(uint256 _mintAmount) {
1923     require(!paused, "The contract is paused!");
1924     require(_mintAmount > 0 && _mintAmount <= maxPerTx, "Invalid mint amount!");
1925     require(_mintAmount + addressMintedBalance[msg.sender] <= maxPerWallet, "Max per wallet exceeded!");
1926     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1927     _;
1928   }
1929 
1930 // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
1931   // PUBLIC MINT
1932   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1933     require(publicMintEnabled, "Public mint is not active yet!");
1934     require(totalSupply() + _mintAmount <= maxSupply, "Max supply limit reached!");
1935     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1936 
1937     addressMintedBalance[msg.sender] += _mintAmount;
1938     _safeMint(_msgSender(), _mintAmount);
1939   }
1940   
1941   // WHITELIST MINT
1942   function mintWhitelist(uint256 _mintAmount, bytes memory sig) public payable mintCompliance(_mintAmount) {
1943     require(whitelistMintEnabled, "Whitelist mint is not active yet!");
1944     require(isValidData(msg.sender, sig) == true, "User is not whitelisted!");
1945     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1946 
1947     addressMintedBalance[msg.sender] += _mintAmount;
1948     _safeMint(_msgSender(), _mintAmount);
1949   }
1950 
1951   // MINT FOR ADDRESS
1952   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1953     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1954 
1955     _safeMint(_receiver, _mintAmount);
1956   }
1957 
1958 // ~~~~~~~~~~~~~~~~~~~~ Burn Function ~~~~~~~~~~~~~~~~~~~~
1959   //Burn tokens
1960   function BurnToken(uint256[] calldata tokenIds) public {
1961     require(burnEnabled, "Burn is not active yet.");
1962     uint256 tokensAmount = tokenIds.length;
1963 
1964     for (uint256 i = 0; i < tokensAmount; i++) {
1965         _burn(tokenIds[i]);
1966         }
1967 
1968     burntByOwner[msg.sender] += tokensAmount;
1969   }
1970 
1971 // ~~~~~~~~~~~~~~~~~~~~ SIGNATURES ~~~~~~~~~~~~~~~~~~~~
1972   function isValidData(address _user, bytes memory sig) public view returns (bool) {
1973     bytes32 message = keccak256(abi.encodePacked(_user));
1974     return (recoverSigner(message, sig) == signerAddress);
1975   }
1976 
1977   function recoverSigner(bytes32 message, bytes memory sig) public pure returns (address) {
1978     uint8 v; bytes32 r; bytes32 s;
1979     (v, r, s) = splitSignature(sig);
1980     return ecrecover(message, v, r, s);
1981   }
1982 
1983   function splitSignature(bytes memory sig) public pure returns (uint8, bytes32, bytes32) {
1984     require(sig.length == 65);
1985     bytes32 r; bytes32 s; uint8 v;
1986     assembly { r := mload(add(sig, 32)) s := mload(add(sig, 64)) v := byte(0, mload(add(sig, 96))) }
1987     return (v, r, s);
1988   }
1989 
1990 // ~~~~~~~~~~~~~~~~~~~~ Various Checks ~~~~~~~~~~~~~~~~~~~~
1991   function _startTokenId() internal view virtual override returns (uint256) {
1992     return 1;
1993   }
1994 
1995   function _baseURI() internal view virtual override returns (string memory) {
1996     return uriPrefix;
1997   }
1998 
1999   function tokenURI(uint256 _tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2000     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2001 
2002     if (revealed == false) { return notRevealedURI; }
2003 
2004     string memory currentBaseURI = _baseURI();
2005     return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)) : "";
2006   }
2007 
2008 // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
2009   // SIGNER
2010   function setSigner(address _newSigner) public onlyOwner {
2011     signerAddress = _newSigner;
2012   }
2013   
2014   function setBurntByAddress(uint _burnAmount, address _address) public onlyOwner {
2015     burntByOwner[_address] = _burnAmount;
2016   }
2017 
2018   function setCost(uint256 _cost) public onlyOwner {
2019     cost = _cost;
2020   }
2021 
2022   function setMaxPerTx(uint256 _maxPerTx) public onlyOwner {
2023     maxPerTx = _maxPerTx;
2024   }
2025 
2026   function setMaxPerWallet(uint256 _maxPerWallet) public onlyOwner {
2027     maxPerWallet = _maxPerWallet;
2028   }
2029 
2030   // SET PUBLIC MINT STATE
2031   function setPublicMintState(bool _state) public onlyOwner {
2032     publicMintEnabled = _state;
2033   }
2034 
2035   // SET WHITELIST MINT STATE
2036   function setWLMintState(bool _state) public onlyOwner {
2037     whitelistMintEnabled = _state;
2038   }
2039 
2040   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2041     uriPrefix = _uriPrefix;
2042   }
2043 
2044   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2045     notRevealedURI = _notRevealedURI;
2046   }
2047 
2048   function setBurnEnabled(bool _state) public onlyOwner {
2049     burnEnabled = _state;
2050   }
2051 
2052   function setPaused(bool _state) public onlyOwner {
2053     paused = _state;
2054   }
2055 
2056   function reveal(bool _state) public onlyOwner {
2057     revealed = _state;
2058   }
2059 
2060   function setApprovalForAll(address operator, bool approved) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
2061     super.setApprovalForAll(operator, approved);
2062   }
2063 
2064   function approve(address operator, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
2065     super.approve(operator, tokenId);
2066   }
2067 
2068   function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2069     super.transferFrom(from, to, tokenId);
2070   }
2071 
2072   function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2073     super.safeTransferFrom(from, to, tokenId);
2074   }
2075 
2076   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2077     super.safeTransferFrom(from, to, tokenId, data);
2078   }
2079 
2080 // ~~~~~~~~~~~~~~~~~~~~ Withdraw Functions ~~~~~~~~~~~~~~~~~~~~
2081   function withdraw() public onlyOwner nonReentrant {
2082     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2083     require(os);
2084   }
2085 }