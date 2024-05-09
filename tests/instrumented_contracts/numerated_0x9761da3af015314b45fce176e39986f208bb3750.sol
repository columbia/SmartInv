1 // SPDX-License-Identifier: MIT
2 // File operator-filter-registry/src/lib/Constants.sol@v1.4.2
3 pragma solidity ^0.8.13;
4 
5 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
6 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
7 
8 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.4.2
9 pragma solidity ^0.8.13;
10 
11 interface IOperatorFilterRegistry {
12     /**
13      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
14      *         true if supplied registrant address is not registered.
15      */
16     function isOperatorAllowed(
17         address registrant,
18         address operator
19     ) external view returns (bool);
20 
21     /**
22      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
23      */
24     function register(address registrant) external;
25 
26     /**
27      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
28      */
29     function registerAndSubscribe(
30         address registrant,
31         address subscription
32     ) external;
33 
34     /**
35      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
36      *         address without subscribing.
37      */
38     function registerAndCopyEntries(
39         address registrant,
40         address registrantToCopy
41     ) external;
42 
43     /**
44      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
45      *         Note that this does not remove any filtered addresses or codeHashes.
46      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
47      */
48     function unregister(address addr) external;
49 
50     /**
51      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
52      */
53     function updateOperator(
54         address registrant,
55         address operator,
56         bool filtered
57     ) external;
58 
59     /**
60      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
61      */
62     function updateOperators(
63         address registrant,
64         address[] calldata operators,
65         bool filtered
66     ) external;
67 
68     /**
69      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
70      */
71     function updateCodeHash(
72         address registrant,
73         bytes32 codehash,
74         bool filtered
75     ) external;
76 
77     /**
78      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
79      */
80     function updateCodeHashes(
81         address registrant,
82         bytes32[] calldata codeHashes,
83         bool filtered
84     ) external;
85 
86     /**
87      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
88      *         subscription if present.
89      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
90      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
91      *         used.
92      */
93     function subscribe(
94         address registrant,
95         address registrantToSubscribe
96     ) external;
97 
98     /**
99      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
100      */
101     function unsubscribe(address registrant, bool copyExistingEntries) external;
102 
103     /**
104      * @notice Get the subscription address of a given registrant, if any.
105      */
106     function subscriptionOf(address addr) external returns (address registrant);
107 
108     /**
109      * @notice Get the set of addresses subscribed to a given registrant.
110      *         Note that order is not guaranteed as updates are made.
111      */
112     function subscribers(
113         address registrant
114     ) external returns (address[] memory);
115 
116     /**
117      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
118      *         Note that order is not guaranteed as updates are made.
119      */
120     function subscriberAt(
121         address registrant,
122         uint256 index
123     ) external returns (address);
124 
125     /**
126      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
127      */
128     function copyEntriesOf(
129         address registrant,
130         address registrantToCopy
131     ) external;
132 
133     /**
134      * @notice Returns true if operator is filtered by a given address or its subscription.
135      */
136     function isOperatorFiltered(
137         address registrant,
138         address operator
139     ) external returns (bool);
140 
141     /**
142      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
143      */
144     function isCodeHashOfFiltered(
145         address registrant,
146         address operatorWithCode
147     ) external returns (bool);
148 
149     /**
150      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
151      */
152     function isCodeHashFiltered(
153         address registrant,
154         bytes32 codeHash
155     ) external returns (bool);
156 
157     /**
158      * @notice Returns a list of filtered operators for a given address or its subscription.
159      */
160     function filteredOperators(
161         address addr
162     ) external returns (address[] memory);
163 
164     /**
165      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
166      *         Note that order is not guaranteed as updates are made.
167      */
168     function filteredCodeHashes(
169         address addr
170     ) external returns (bytes32[] memory);
171 
172     /**
173      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
174      *         its subscription.
175      *         Note that order is not guaranteed as updates are made.
176      */
177     function filteredOperatorAt(
178         address registrant,
179         uint256 index
180     ) external returns (address);
181 
182     /**
183      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
184      *         its subscription.
185      *         Note that order is not guaranteed as updates are made.
186      */
187     function filteredCodeHashAt(
188         address registrant,
189         uint256 index
190     ) external returns (bytes32);
191 
192     /**
193      * @notice Returns true if an address has registered
194      */
195     function isRegistered(address addr) external returns (bool);
196 
197     /**
198      * @dev Convenience method to compute the code hash of an arbitrary contract
199      */
200     function codeHashOf(address addr) external returns (bytes32);
201 }
202 
203 // File operator-filter-registry/src/OperatorFilterer.sol@v1.4.2
204 pragma solidity ^0.8.13;
205 
206 /**
207  * @title  OperatorFilterer
208  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
209  *         registrant's entries in the OperatorFilterRegistry.
210  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
211  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
212  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
213  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
214  *         administration methods on the contract itself to interact with the registry otherwise the subscription
215  *         will be locked to the options set during construction.
216  */
217 
218 abstract contract OperatorFilterer {
219     /// @dev Emitted when an operator is not allowed.
220     error OperatorNotAllowed(address operator);
221 
222     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
223         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
224 
225     /// @dev The constructor that is called when the contract is being deployed.
226     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
227         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
228         // will not revert, but the contract will need to be registered with the registry once it is deployed in
229         // order for the modifier to filter addresses.
230         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
231             if (subscribe) {
232                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
233                     address(this),
234                     subscriptionOrRegistrantToCopy
235                 );
236             } else {
237                 if (subscriptionOrRegistrantToCopy != address(0)) {
238                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
239                         address(this),
240                         subscriptionOrRegistrantToCopy
241                     );
242                 } else {
243                     OPERATOR_FILTER_REGISTRY.register(address(this));
244                 }
245             }
246         }
247     }
248 
249     /**
250      * @dev A helper function to check if an operator is allowed.
251      */
252     modifier onlyAllowedOperator(address from) virtual {
253         // Allow spending tokens from addresses with balance
254         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
255         // from an EOA.
256         if (from != msg.sender) {
257             _checkFilterOperator(msg.sender);
258         }
259         _;
260     }
261 
262     /**
263      * @dev A helper function to check if an operator approval is allowed.
264      */
265     modifier onlyAllowedOperatorApproval(address operator) virtual {
266         _checkFilterOperator(operator);
267         _;
268     }
269 
270     /**
271      * @dev A helper function to check if an operator is allowed.
272      */
273     function _checkFilterOperator(address operator) internal view virtual {
274         // Check registry code length to facilitate testing in environments without a deployed registry.
275         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
276             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
277             // may specify their own OperatorFilterRegistry implementations, which may behave differently
278             if (
279                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
280                     address(this),
281                     operator
282                 )
283             ) {
284                 revert OperatorNotAllowed(operator);
285             }
286         }
287     }
288 }
289 
290 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.4.2
291 pragma solidity ^0.8.13;
292 
293 /**
294  * @title  DefaultOperatorFilterer
295  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
296  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
297  *         administration methods on the contract itself to interact with the registry otherwise the subscription
298  *         will be locked to the options set during construction.
299  */
300 
301 abstract contract DefaultOperatorFilterer is OperatorFilterer {
302     /// @dev The constructor that is called when the contract is being deployed.
303     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
304 }
305 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Interface of the ERC165 standard, as defined in the
311  * https://eips.ethereum.org/EIPS/eip-165[EIP].
312  *
313  * Implementers can declare support of contract interfaces, which can then be
314  * queried by others ({ERC165Checker}).
315  *
316  * For an implementation, see {ERC165}.
317  */
318 interface IERC165 {
319     /**
320      * @dev Returns true if this contract implements the interface defined by
321      * `interfaceId`. See the corresponding
322      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
323      * to learn more about how these ids are created.
324      *
325      * This function call must use less than 30 000 gas.
326      */
327     function supportsInterface(bytes4 interfaceId) external view returns (bool);
328 }
329 
330 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.9.2
331 
332 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Required interface of an ERC721 compliant contract.
338  */
339 interface IERC721 is IERC165 {
340     /**
341      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
342      */
343     event Transfer(
344         address indexed from,
345         address indexed to,
346         uint256 indexed tokenId
347     );
348 
349     /**
350      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
351      */
352     event Approval(
353         address indexed owner,
354         address indexed approved,
355         uint256 indexed tokenId
356     );
357 
358     /**
359      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
360      */
361     event ApprovalForAll(
362         address indexed owner,
363         address indexed operator,
364         bool approved
365     );
366 
367     /**
368      * @dev Returns the number of tokens in ``owner``'s account.
369      */
370     function balanceOf(address owner) external view returns (uint256 balance);
371 
372     /**
373      * @dev Returns the owner of the `tokenId` token.
374      *
375      * Requirements:
376      *
377      * - `tokenId` must exist.
378      */
379     function ownerOf(uint256 tokenId) external view returns (address owner);
380 
381     /**
382      * @dev Safely transfers `tokenId` token from `from` to `to`.
383      *
384      * Requirements:
385      *
386      * - `from` cannot be the zero address.
387      * - `to` cannot be the zero address.
388      * - `tokenId` token must exist and be owned by `from`.
389      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
391      *
392      * Emits a {Transfer} event.
393      */
394     function safeTransferFrom(
395         address from,
396         address to,
397         uint256 tokenId,
398         bytes calldata data
399     ) external;
400 
401     /**
402      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
403      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must exist and be owned by `from`.
410      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
411      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
412      *
413      * Emits a {Transfer} event.
414      */
415     function safeTransferFrom(
416         address from,
417         address to,
418         uint256 tokenId
419     ) external;
420 
421     /**
422      * @dev Transfers `tokenId` token from `from` to `to`.
423      *
424      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
425      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
426      * understand this adds an external call which potentially creates a reentrancy vulnerability.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `tokenId` token must be owned by `from`.
433      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
434      *
435      * Emits a {Transfer} event.
436      */
437     function transferFrom(address from, address to, uint256 tokenId) external;
438 
439     /**
440      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
441      * The approval is cleared when the token is transferred.
442      *
443      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
444      *
445      * Requirements:
446      *
447      * - The caller must own the token or be an approved operator.
448      * - `tokenId` must exist.
449      *
450      * Emits an {Approval} event.
451      */
452     function approve(address to, uint256 tokenId) external;
453 
454     /**
455      * @dev Approve or remove `operator` as an operator for the caller.
456      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
457      *
458      * Requirements:
459      *
460      * - The `operator` cannot be the caller.
461      *
462      * Emits an {ApprovalForAll} event.
463      */
464     function setApprovalForAll(address operator, bool approved) external;
465 
466     /**
467      * @dev Returns the account approved for `tokenId` token.
468      *
469      * Requirements:
470      *
471      * - `tokenId` must exist.
472      */
473     function getApproved(
474         uint256 tokenId
475     ) external view returns (address operator);
476 
477     /**
478      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
479      *
480      * See {setApprovalForAll}
481      */
482     function isApprovedForAll(
483         address owner,
484         address operator
485     ) external view returns (bool);
486 }
487 
488 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.9.2
489 
490 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 /**
495  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
496  * @dev See https://eips.ethereum.org/EIPS/eip-721
497  */
498 interface IERC721Metadata is IERC721 {
499     /**
500      * @dev Returns the token collection name.
501      */
502     function name() external view returns (string memory);
503 
504     /**
505      * @dev Returns the token collection symbol.
506      */
507     function symbol() external view returns (string memory);
508 
509     /**
510      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
511      */
512     function tokenURI(uint256 tokenId) external view returns (string memory);
513 }
514 
515 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.9.2
516 
517 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Implementation of the {IERC165} interface.
523  *
524  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
525  * for the additional interface id that will be supported. For example:
526  *
527  * ```solidity
528  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
530  * }
531  * ```
532  *
533  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
534  */
535 abstract contract ERC165 is IERC165 {
536     /**
537      * @dev See {IERC165-supportsInterface}.
538      */
539     function supportsInterface(
540         bytes4 interfaceId
541     ) public view virtual override returns (bool) {
542         return interfaceId == type(IERC165).interfaceId;
543     }
544 }
545 
546 // File @openzeppelin/contracts/utils/math/Math.sol@v4.9.2
547 
548 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev Standard math utilities missing in the Solidity language.
554  */
555 library Math {
556     enum Rounding {
557         Down, // Toward negative infinity
558         Up, // Toward infinity
559         Zero // Toward zero
560     }
561 
562     /**
563      * @dev Returns the largest of two numbers.
564      */
565     function max(uint256 a, uint256 b) internal pure returns (uint256) {
566         return a > b ? a : b;
567     }
568 
569     /**
570      * @dev Returns the smallest of two numbers.
571      */
572     function min(uint256 a, uint256 b) internal pure returns (uint256) {
573         return a < b ? a : b;
574     }
575 
576     /**
577      * @dev Returns the average of two numbers. The result is rounded towards
578      * zero.
579      */
580     function average(uint256 a, uint256 b) internal pure returns (uint256) {
581         // (a + b) / 2 can overflow.
582         return (a & b) + (a ^ b) / 2;
583     }
584 
585     /**
586      * @dev Returns the ceiling of the division of two numbers.
587      *
588      * This differs from standard division with `/` in that it rounds up instead
589      * of rounding down.
590      */
591     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
592         // (a + b - 1) / b can overflow on addition, so we distribute.
593         return a == 0 ? 0 : (a - 1) / b + 1;
594     }
595 
596     /**
597      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
598      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
599      * with further edits by Uniswap Labs also under MIT license.
600      */
601     function mulDiv(
602         uint256 x,
603         uint256 y,
604         uint256 denominator
605     ) internal pure returns (uint256 result) {
606         unchecked {
607             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
608             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
609             // variables such that product = prod1 * 2^256 + prod0.
610             uint256 prod0; // Least significant 256 bits of the product
611             uint256 prod1; // Most significant 256 bits of the product
612             assembly {
613                 let mm := mulmod(x, y, not(0))
614                 prod0 := mul(x, y)
615                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
616             }
617 
618             // Handle non-overflow cases, 256 by 256 division.
619             if (prod1 == 0) {
620                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
621                 // The surrounding unchecked block does not change this fact.
622                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
623                 return prod0 / denominator;
624             }
625 
626             // Make sure the result is less than 2^256. Also prevents denominator == 0.
627             require(denominator > prod1, "Math: mulDiv overflow");
628 
629             ///////////////////////////////////////////////
630             // 512 by 256 division.
631             ///////////////////////////////////////////////
632 
633             // Make division exact by subtracting the remainder from [prod1 prod0].
634             uint256 remainder;
635             assembly {
636                 // Compute remainder using mulmod.
637                 remainder := mulmod(x, y, denominator)
638 
639                 // Subtract 256 bit number from 512 bit number.
640                 prod1 := sub(prod1, gt(remainder, prod0))
641                 prod0 := sub(prod0, remainder)
642             }
643 
644             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
645             // See https://cs.stackexchange.com/q/138556/92363.
646 
647             // Does not overflow because the denominator cannot be zero at this stage in the function.
648             uint256 twos = denominator & (~denominator + 1);
649             assembly {
650                 // Divide denominator by twos.
651                 denominator := div(denominator, twos)
652 
653                 // Divide [prod1 prod0] by twos.
654                 prod0 := div(prod0, twos)
655 
656                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
657                 twos := add(div(sub(0, twos), twos), 1)
658             }
659 
660             // Shift in bits from prod1 into prod0.
661             prod0 |= prod1 * twos;
662 
663             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
664             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
665             // four bits. That is, denominator * inv = 1 mod 2^4.
666             uint256 inverse = (3 * denominator) ^ 2;
667 
668             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
669             // in modular arithmetic, doubling the correct bits in each step.
670             inverse *= 2 - denominator * inverse; // inverse mod 2^8
671             inverse *= 2 - denominator * inverse; // inverse mod 2^16
672             inverse *= 2 - denominator * inverse; // inverse mod 2^32
673             inverse *= 2 - denominator * inverse; // inverse mod 2^64
674             inverse *= 2 - denominator * inverse; // inverse mod 2^128
675             inverse *= 2 - denominator * inverse; // inverse mod 2^256
676 
677             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
678             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
679             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
680             // is no longer required.
681             result = prod0 * inverse;
682             return result;
683         }
684     }
685 
686     /**
687      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
688      */
689     function mulDiv(
690         uint256 x,
691         uint256 y,
692         uint256 denominator,
693         Rounding rounding
694     ) internal pure returns (uint256) {
695         uint256 result = mulDiv(x, y, denominator);
696         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
697             result += 1;
698         }
699         return result;
700     }
701 
702     /**
703      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
704      *
705      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
706      */
707     function sqrt(uint256 a) internal pure returns (uint256) {
708         if (a == 0) {
709             return 0;
710         }
711 
712         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
713         //
714         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
715         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
716         //
717         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
718         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
719         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
720         //
721         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
722         uint256 result = 1 << (log2(a) >> 1);
723 
724         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
725         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
726         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
727         // into the expected uint128 result.
728         unchecked {
729             result = (result + a / result) >> 1;
730             result = (result + a / result) >> 1;
731             result = (result + a / result) >> 1;
732             result = (result + a / result) >> 1;
733             result = (result + a / result) >> 1;
734             result = (result + a / result) >> 1;
735             result = (result + a / result) >> 1;
736             return min(result, a / result);
737         }
738     }
739 
740     /**
741      * @notice Calculates sqrt(a), following the selected rounding direction.
742      */
743     function sqrt(
744         uint256 a,
745         Rounding rounding
746     ) internal pure returns (uint256) {
747         unchecked {
748             uint256 result = sqrt(a);
749             return
750                 result +
751                 (rounding == Rounding.Up && result * result < a ? 1 : 0);
752         }
753     }
754 
755     /**
756      * @dev Return the log in base 2, rounded down, of a positive value.
757      * Returns 0 if given 0.
758      */
759     function log2(uint256 value) internal pure returns (uint256) {
760         uint256 result = 0;
761         unchecked {
762             if (value >> 128 > 0) {
763                 value >>= 128;
764                 result += 128;
765             }
766             if (value >> 64 > 0) {
767                 value >>= 64;
768                 result += 64;
769             }
770             if (value >> 32 > 0) {
771                 value >>= 32;
772                 result += 32;
773             }
774             if (value >> 16 > 0) {
775                 value >>= 16;
776                 result += 16;
777             }
778             if (value >> 8 > 0) {
779                 value >>= 8;
780                 result += 8;
781             }
782             if (value >> 4 > 0) {
783                 value >>= 4;
784                 result += 4;
785             }
786             if (value >> 2 > 0) {
787                 value >>= 2;
788                 result += 2;
789             }
790             if (value >> 1 > 0) {
791                 result += 1;
792             }
793         }
794         return result;
795     }
796 
797     /**
798      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
799      * Returns 0 if given 0.
800      */
801     function log2(
802         uint256 value,
803         Rounding rounding
804     ) internal pure returns (uint256) {
805         unchecked {
806             uint256 result = log2(value);
807             return
808                 result +
809                 (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
810         }
811     }
812 
813     /**
814      * @dev Return the log in base 10, rounded down, of a positive value.
815      * Returns 0 if given 0.
816      */
817     function log10(uint256 value) internal pure returns (uint256) {
818         uint256 result = 0;
819         unchecked {
820             if (value >= 10 ** 64) {
821                 value /= 10 ** 64;
822                 result += 64;
823             }
824             if (value >= 10 ** 32) {
825                 value /= 10 ** 32;
826                 result += 32;
827             }
828             if (value >= 10 ** 16) {
829                 value /= 10 ** 16;
830                 result += 16;
831             }
832             if (value >= 10 ** 8) {
833                 value /= 10 ** 8;
834                 result += 8;
835             }
836             if (value >= 10 ** 4) {
837                 value /= 10 ** 4;
838                 result += 4;
839             }
840             if (value >= 10 ** 2) {
841                 value /= 10 ** 2;
842                 result += 2;
843             }
844             if (value >= 10 ** 1) {
845                 result += 1;
846             }
847         }
848         return result;
849     }
850 
851     /**
852      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
853      * Returns 0 if given 0.
854      */
855     function log10(
856         uint256 value,
857         Rounding rounding
858     ) internal pure returns (uint256) {
859         unchecked {
860             uint256 result = log10(value);
861             return
862                 result +
863                 (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
864         }
865     }
866 
867     /**
868      * @dev Return the log in base 256, rounded down, of a positive value.
869      * Returns 0 if given 0.
870      *
871      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
872      */
873     function log256(uint256 value) internal pure returns (uint256) {
874         uint256 result = 0;
875         unchecked {
876             if (value >> 128 > 0) {
877                 value >>= 128;
878                 result += 16;
879             }
880             if (value >> 64 > 0) {
881                 value >>= 64;
882                 result += 8;
883             }
884             if (value >> 32 > 0) {
885                 value >>= 32;
886                 result += 4;
887             }
888             if (value >> 16 > 0) {
889                 value >>= 16;
890                 result += 2;
891             }
892             if (value >> 8 > 0) {
893                 result += 1;
894             }
895         }
896         return result;
897     }
898 
899     /**
900      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
901      * Returns 0 if given 0.
902      */
903     function log256(
904         uint256 value,
905         Rounding rounding
906     ) internal pure returns (uint256) {
907         unchecked {
908             uint256 result = log256(value);
909             return
910                 result +
911                 (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
912         }
913     }
914 }
915 
916 // File @openzeppelin/contracts/utils/math/SignedMath.sol@v4.9.2
917 
918 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 /**
923  * @dev Standard signed math utilities missing in the Solidity language.
924  */
925 library SignedMath {
926     /**
927      * @dev Returns the largest of two signed numbers.
928      */
929     function max(int256 a, int256 b) internal pure returns (int256) {
930         return a > b ? a : b;
931     }
932 
933     /**
934      * @dev Returns the smallest of two signed numbers.
935      */
936     function min(int256 a, int256 b) internal pure returns (int256) {
937         return a < b ? a : b;
938     }
939 
940     /**
941      * @dev Returns the average of two signed numbers without overflow.
942      * The result is rounded towards zero.
943      */
944     function average(int256 a, int256 b) internal pure returns (int256) {
945         // Formula from the book "Hacker's Delight"
946         int256 x = (a & b) + ((a ^ b) >> 1);
947         return x + (int256(uint256(x) >> 255) & (a ^ b));
948     }
949 
950     /**
951      * @dev Returns the absolute unsigned value of a signed value.
952      */
953     function abs(int256 n) internal pure returns (uint256) {
954         unchecked {
955             // must be unchecked in order to support `n = type(int256).min`
956             return uint256(n >= 0 ? n : -n);
957         }
958     }
959 }
960 
961 // File @openzeppelin/contracts/utils/Strings.sol@v4.9.2
962 
963 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
964 
965 pragma solidity ^0.8.0;
966 
967 /**
968  * @dev String operations.
969  */
970 library Strings {
971     bytes16 private constant _SYMBOLS = "0123456789abcdef";
972     uint8 private constant _ADDRESS_LENGTH = 20;
973 
974     /**
975      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
976      */
977     function toString(uint256 value) internal pure returns (string memory) {
978         unchecked {
979             uint256 length = Math.log10(value) + 1;
980             string memory buffer = new string(length);
981             uint256 ptr;
982             /// @solidity memory-safe-assembly
983             assembly {
984                 ptr := add(buffer, add(32, length))
985             }
986             while (true) {
987                 ptr--;
988                 /// @solidity memory-safe-assembly
989                 assembly {
990                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
991                 }
992                 value /= 10;
993                 if (value == 0) break;
994             }
995             return buffer;
996         }
997     }
998 
999     /**
1000      * @dev Converts a `int256` to its ASCII `string` decimal representation.
1001      */
1002     function toString(int256 value) internal pure returns (string memory) {
1003         return
1004             string(
1005                 abi.encodePacked(
1006                     value < 0 ? "-" : "",
1007                     toString(SignedMath.abs(value))
1008                 )
1009             );
1010     }
1011 
1012     /**
1013      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1014      */
1015     function toHexString(uint256 value) internal pure returns (string memory) {
1016         unchecked {
1017             return toHexString(value, Math.log256(value) + 1);
1018         }
1019     }
1020 
1021     /**
1022      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1023      */
1024     function toHexString(
1025         uint256 value,
1026         uint256 length
1027     ) internal pure returns (string memory) {
1028         bytes memory buffer = new bytes(2 * length + 2);
1029         buffer[0] = "0";
1030         buffer[1] = "x";
1031         for (uint256 i = 2 * length + 1; i > 1; --i) {
1032             buffer[i] = _SYMBOLS[value & 0xf];
1033             value >>= 4;
1034         }
1035         require(value == 0, "Strings: hex length insufficient");
1036         return string(buffer);
1037     }
1038 
1039     /**
1040      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1041      */
1042     function toHexString(address addr) internal pure returns (string memory) {
1043         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1044     }
1045 
1046     /**
1047      * @dev Returns true if the two strings are equal.
1048      */
1049     function equal(
1050         string memory a,
1051         string memory b
1052     ) internal pure returns (bool) {
1053         return keccak256(bytes(a)) == keccak256(bytes(b));
1054     }
1055 }
1056 
1057 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.9.2
1058 
1059 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1060 
1061 pragma solidity ^0.8.0;
1062 
1063 /**
1064  * @title ERC721 token receiver interface
1065  * @dev Interface for any contract that wants to support safeTransfers
1066  * from ERC721 asset contracts.
1067  */
1068 interface IERC721Receiver {
1069     /**
1070      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1071      * by `operator` from `from`, this function is called.
1072      *
1073      * It must return its Solidity selector to confirm the token transfer.
1074      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1075      *
1076      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1077      */
1078     function onERC721Received(
1079         address operator,
1080         address from,
1081         uint256 tokenId,
1082         bytes calldata data
1083     ) external returns (bytes4);
1084 }
1085 
1086 // File @openzeppelin/contracts/utils/Address.sol@v4.9.2
1087 
1088 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
1089 
1090 pragma solidity ^0.8.1;
1091 
1092 /**
1093  * @dev Collection of functions related to the address type
1094  */
1095 library Address {
1096     /**
1097      * @dev Returns true if `account` is a contract.
1098      *
1099      * [IMPORTANT]
1100      * ====
1101      * It is unsafe to assume that an address for which this function returns
1102      * false is an externally-owned account (EOA) and not a contract.
1103      *
1104      * Among others, `isContract` will return false for the following
1105      * types of addresses:
1106      *
1107      *  - an externally-owned account
1108      *  - a contract in construction
1109      *  - an address where a contract will be created
1110      *  - an address where a contract lived, but was destroyed
1111      *
1112      * Furthermore, `isContract` will also return true if the target contract within
1113      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
1114      * which only has an effect at the end of a transaction.
1115      * ====
1116      *
1117      * [IMPORTANT]
1118      * ====
1119      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1120      *
1121      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1122      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1123      * constructor.
1124      * ====
1125      */
1126     function isContract(address account) internal view returns (bool) {
1127         // This method relies on extcodesize/address.code.length, which returns 0
1128         // for contracts in construction, since the code is only stored at the end
1129         // of the constructor execution.
1130 
1131         return account.code.length > 0;
1132     }
1133 
1134     /**
1135      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1136      * `recipient`, forwarding all available gas and reverting on errors.
1137      *
1138      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1139      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1140      * imposed by `transfer`, making them unable to receive funds via
1141      * `transfer`. {sendValue} removes this limitation.
1142      *
1143      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1144      *
1145      * IMPORTANT: because control is transferred to `recipient`, care must be
1146      * taken to not create reentrancy vulnerabilities. Consider using
1147      * {ReentrancyGuard} or the
1148      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1149      */
1150     function sendValue(address payable recipient, uint256 amount) internal {
1151         require(
1152             address(this).balance >= amount,
1153             "Address: insufficient balance"
1154         );
1155 
1156         (bool success, ) = recipient.call{value: amount}("");
1157         require(
1158             success,
1159             "Address: unable to send value, recipient may have reverted"
1160         );
1161     }
1162 
1163     /**
1164      * @dev Performs a Solidity function call using a low level `call`. A
1165      * plain `call` is an unsafe replacement for a function call: use this
1166      * function instead.
1167      *
1168      * If `target` reverts with a revert reason, it is bubbled up by this
1169      * function (like regular Solidity function calls).
1170      *
1171      * Returns the raw returned data. To convert to the expected return value,
1172      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1173      *
1174      * Requirements:
1175      *
1176      * - `target` must be a contract.
1177      * - calling `target` with `data` must not revert.
1178      *
1179      * _Available since v3.1._
1180      */
1181     function functionCall(
1182         address target,
1183         bytes memory data
1184     ) internal returns (bytes memory) {
1185         return
1186             functionCallWithValue(
1187                 target,
1188                 data,
1189                 0,
1190                 "Address: low-level call failed"
1191             );
1192     }
1193 
1194     /**
1195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1196      * `errorMessage` as a fallback revert reason when `target` reverts.
1197      *
1198      * _Available since v3.1._
1199      */
1200     function functionCall(
1201         address target,
1202         bytes memory data,
1203         string memory errorMessage
1204     ) internal returns (bytes memory) {
1205         return functionCallWithValue(target, data, 0, errorMessage);
1206     }
1207 
1208     /**
1209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1210      * but also transferring `value` wei to `target`.
1211      *
1212      * Requirements:
1213      *
1214      * - the calling contract must have an ETH balance of at least `value`.
1215      * - the called Solidity function must be `payable`.
1216      *
1217      * _Available since v3.1._
1218      */
1219     function functionCallWithValue(
1220         address target,
1221         bytes memory data,
1222         uint256 value
1223     ) internal returns (bytes memory) {
1224         return
1225             functionCallWithValue(
1226                 target,
1227                 data,
1228                 value,
1229                 "Address: low-level call with value failed"
1230             );
1231     }
1232 
1233     /**
1234      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1235      * with `errorMessage` as a fallback revert reason when `target` reverts.
1236      *
1237      * _Available since v3.1._
1238      */
1239     function functionCallWithValue(
1240         address target,
1241         bytes memory data,
1242         uint256 value,
1243         string memory errorMessage
1244     ) internal returns (bytes memory) {
1245         require(
1246             address(this).balance >= value,
1247             "Address: insufficient balance for call"
1248         );
1249         (bool success, bytes memory returndata) = target.call{value: value}(
1250             data
1251         );
1252         return
1253             verifyCallResultFromTarget(
1254                 target,
1255                 success,
1256                 returndata,
1257                 errorMessage
1258             );
1259     }
1260 
1261     /**
1262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1263      * but performing a static call.
1264      *
1265      * _Available since v3.3._
1266      */
1267     function functionStaticCall(
1268         address target,
1269         bytes memory data
1270     ) internal view returns (bytes memory) {
1271         return
1272             functionStaticCall(
1273                 target,
1274                 data,
1275                 "Address: low-level static call failed"
1276             );
1277     }
1278 
1279     /**
1280      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1281      * but performing a static call.
1282      *
1283      * _Available since v3.3._
1284      */
1285     function functionStaticCall(
1286         address target,
1287         bytes memory data,
1288         string memory errorMessage
1289     ) internal view returns (bytes memory) {
1290         (bool success, bytes memory returndata) = target.staticcall(data);
1291         return
1292             verifyCallResultFromTarget(
1293                 target,
1294                 success,
1295                 returndata,
1296                 errorMessage
1297             );
1298     }
1299 
1300     /**
1301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1302      * but performing a delegate call.
1303      *
1304      * _Available since v3.4._
1305      */
1306     function functionDelegateCall(
1307         address target,
1308         bytes memory data
1309     ) internal returns (bytes memory) {
1310         return
1311             functionDelegateCall(
1312                 target,
1313                 data,
1314                 "Address: low-level delegate call failed"
1315             );
1316     }
1317 
1318     /**
1319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1320      * but performing a delegate call.
1321      *
1322      * _Available since v3.4._
1323      */
1324     function functionDelegateCall(
1325         address target,
1326         bytes memory data,
1327         string memory errorMessage
1328     ) internal returns (bytes memory) {
1329         (bool success, bytes memory returndata) = target.delegatecall(data);
1330         return
1331             verifyCallResultFromTarget(
1332                 target,
1333                 success,
1334                 returndata,
1335                 errorMessage
1336             );
1337     }
1338 
1339     /**
1340      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1341      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1342      *
1343      * _Available since v4.8._
1344      */
1345     function verifyCallResultFromTarget(
1346         address target,
1347         bool success,
1348         bytes memory returndata,
1349         string memory errorMessage
1350     ) internal view returns (bytes memory) {
1351         if (success) {
1352             if (returndata.length == 0) {
1353                 // only check isContract if the call was successful and the return data is empty
1354                 // otherwise we already know that it was a contract
1355                 require(isContract(target), "Address: call to non-contract");
1356             }
1357             return returndata;
1358         } else {
1359             _revert(returndata, errorMessage);
1360         }
1361     }
1362 
1363     /**
1364      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1365      * revert reason or using the provided one.
1366      *
1367      * _Available since v4.3._
1368      */
1369     function verifyCallResult(
1370         bool success,
1371         bytes memory returndata,
1372         string memory errorMessage
1373     ) internal pure returns (bytes memory) {
1374         if (success) {
1375             return returndata;
1376         } else {
1377             _revert(returndata, errorMessage);
1378         }
1379     }
1380 
1381     function _revert(
1382         bytes memory returndata,
1383         string memory errorMessage
1384     ) private pure {
1385         // Look for revert reason and bubble it up if present
1386         if (returndata.length > 0) {
1387             // The easiest way to bubble the revert reason is using memory via assembly
1388             /// @solidity memory-safe-assembly
1389             assembly {
1390                 let returndata_size := mload(returndata)
1391                 revert(add(32, returndata), returndata_size)
1392             }
1393         } else {
1394             revert(errorMessage);
1395         }
1396     }
1397 }
1398 
1399 // File @openzeppelin/contracts/utils/Context.sol@v4.9.2
1400 
1401 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1402 
1403 pragma solidity ^0.8.0;
1404 
1405 /**
1406  * @dev Provides information about the current execution context, including the
1407  * sender of the transaction and its data. While these are generally available
1408  * via msg.sender and msg.data, they should not be accessed in such a direct
1409  * manner, since when dealing with meta-transactions the account sending and
1410  * paying for execution may not be the actual sender (as far as an application
1411  * is concerned).
1412  *
1413  * This contract is only required for intermediate, library-like contracts.
1414  */
1415 abstract contract Context {
1416     function _msgSender() internal view virtual returns (address) {
1417         return msg.sender;
1418     }
1419 
1420     function _msgData() internal view virtual returns (bytes calldata) {
1421         return msg.data;
1422     }
1423 }
1424 
1425 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.9.2
1426 
1427 // OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
1428 // This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
1429 
1430 pragma solidity ^0.8.0;
1431 
1432 /**
1433  * @dev Library for reading and writing primitive types to specific storage slots.
1434  *
1435  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
1436  * This library helps with reading and writing to such slots without the need for inline assembly.
1437  *
1438  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
1439  *
1440  * Example usage to set ERC1967 implementation slot:
1441  * ```solidity
1442  * contract ERC1967 {
1443  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1444  *
1445  *     function _getImplementation() internal view returns (address) {
1446  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
1447  *     }
1448  *
1449  *     function _setImplementation(address newImplementation) internal {
1450  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
1451  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
1452  *     }
1453  * }
1454  * ```
1455  *
1456  * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
1457  * _Available since v4.9 for `string`, `bytes`._
1458  */
1459 library StorageSlot {
1460     struct AddressSlot {
1461         address value;
1462     }
1463 
1464     struct BooleanSlot {
1465         bool value;
1466     }
1467 
1468     struct Bytes32Slot {
1469         bytes32 value;
1470     }
1471 
1472     struct Uint256Slot {
1473         uint256 value;
1474     }
1475 
1476     struct StringSlot {
1477         string value;
1478     }
1479 
1480     struct BytesSlot {
1481         bytes value;
1482     }
1483 
1484     /**
1485      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
1486      */
1487     function getAddressSlot(
1488         bytes32 slot
1489     ) internal pure returns (AddressSlot storage r) {
1490         /// @solidity memory-safe-assembly
1491         assembly {
1492             r.slot := slot
1493         }
1494     }
1495 
1496     /**
1497      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
1498      */
1499     function getBooleanSlot(
1500         bytes32 slot
1501     ) internal pure returns (BooleanSlot storage r) {
1502         /// @solidity memory-safe-assembly
1503         assembly {
1504             r.slot := slot
1505         }
1506     }
1507 
1508     /**
1509      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
1510      */
1511     function getBytes32Slot(
1512         bytes32 slot
1513     ) internal pure returns (Bytes32Slot storage r) {
1514         /// @solidity memory-safe-assembly
1515         assembly {
1516             r.slot := slot
1517         }
1518     }
1519 
1520     /**
1521      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
1522      */
1523     function getUint256Slot(
1524         bytes32 slot
1525     ) internal pure returns (Uint256Slot storage r) {
1526         /// @solidity memory-safe-assembly
1527         assembly {
1528             r.slot := slot
1529         }
1530     }
1531 
1532     /**
1533      * @dev Returns an `StringSlot` with member `value` located at `slot`.
1534      */
1535     function getStringSlot(
1536         bytes32 slot
1537     ) internal pure returns (StringSlot storage r) {
1538         /// @solidity memory-safe-assembly
1539         assembly {
1540             r.slot := slot
1541         }
1542     }
1543 
1544     /**
1545      * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
1546      */
1547     function getStringSlot(
1548         string storage store
1549     ) internal pure returns (StringSlot storage r) {
1550         /// @solidity memory-safe-assembly
1551         assembly {
1552             r.slot := store.slot
1553         }
1554     }
1555 
1556     /**
1557      * @dev Returns an `BytesSlot` with member `value` located at `slot`.
1558      */
1559     function getBytesSlot(
1560         bytes32 slot
1561     ) internal pure returns (BytesSlot storage r) {
1562         /// @solidity memory-safe-assembly
1563         assembly {
1564             r.slot := slot
1565         }
1566     }
1567 
1568     /**
1569      * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
1570      */
1571     function getBytesSlot(
1572         bytes storage store
1573     ) internal pure returns (BytesSlot storage r) {
1574         /// @solidity memory-safe-assembly
1575         assembly {
1576             r.slot := store.slot
1577         }
1578     }
1579 }
1580 
1581 // File solidity-bits/contracts/BitScan.sol@v0.3.2
1582 
1583 /**
1584    _____       ___     ___ __           ____  _ __      
1585   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1586   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1587  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1588 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1589                            /____/                        
1590 
1591 - npm: https://www.npmjs.com/package/solidity-bits
1592 - github: https://github.com/estarriolvetch/solidity-bits
1593 
1594  */
1595 
1596 pragma solidity ^0.8.0;
1597 
1598 library BitScan {
1599     uint256 private constant DEBRUIJN_256 =
1600         0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
1601     bytes private constant LOOKUP_TABLE_256 =
1602         hex"0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a7506264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee30e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7ff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c816365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6fe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5fd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8";
1603 
1604     /**
1605         @dev Isolate the least significant set bit.
1606      */
1607     function isolateLS1B256(uint256 bb) internal pure returns (uint256) {
1608         require(bb > 0);
1609         unchecked {
1610             return bb & (0 - bb);
1611         }
1612     }
1613 
1614     /**
1615         @dev Isolate the most significant set bit.
1616      */
1617     function isolateMS1B256(uint256 bb) internal pure returns (uint256) {
1618         require(bb > 0);
1619         unchecked {
1620             bb |= bb >> 128;
1621             bb |= bb >> 64;
1622             bb |= bb >> 32;
1623             bb |= bb >> 16;
1624             bb |= bb >> 8;
1625             bb |= bb >> 4;
1626             bb |= bb >> 2;
1627             bb |= bb >> 1;
1628 
1629             return (bb >> 1) + 1;
1630         }
1631     }
1632 
1633     /**
1634         @dev Find the index of the lest significant set bit. (trailing zero count)
1635      */
1636     function bitScanForward256(uint256 bb) internal pure returns (uint8) {
1637         unchecked {
1638             return
1639                 uint8(
1640                     LOOKUP_TABLE_256[(isolateLS1B256(bb) * DEBRUIJN_256) >> 248]
1641                 );
1642         }
1643     }
1644 
1645     /**
1646         @dev Find the index of the most significant set bit.
1647      */
1648     function bitScanReverse256(uint256 bb) internal pure returns (uint8) {
1649         unchecked {
1650             return
1651                 255 -
1652                 uint8(
1653                     LOOKUP_TABLE_256[
1654                         ((isolateMS1B256(bb) * DEBRUIJN_256) >> 248)
1655                     ]
1656                 );
1657         }
1658     }
1659 
1660     function log2(uint256 bb) internal pure returns (uint8) {
1661         unchecked {
1662             return
1663                 uint8(
1664                     LOOKUP_TABLE_256[(isolateMS1B256(bb) * DEBRUIJN_256) >> 248]
1665                 );
1666         }
1667     }
1668 }
1669 
1670 // File solidity-bits/contracts/BitMaps.sol@v0.3.2
1671 
1672 /**
1673    _____       ___     ___ __           ____  _ __      
1674   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
1675   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
1676  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
1677 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
1678                            /____/                        
1679 
1680 - npm: https://www.npmjs.com/package/solidity-bits
1681 - github: https://github.com/estarriolvetch/solidity-bits
1682 
1683  */
1684 pragma solidity ^0.8.0;
1685 
1686 /**
1687  * @dev This Library is a modified version of Openzeppelin's BitMaps library.
1688  * Functions of finding the index of the closest set bit from a given index are added.
1689  * The indexing of each bucket is modifed to count from the MSB to the LSB instead of from the LSB to the MSB.
1690  * The modification of indexing makes finding the closest previous set bit more efficient in gas usage.
1691  */
1692 
1693 /**
1694  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
1695  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
1696  */
1697 
1698 library BitMaps {
1699     using BitScan for uint256;
1700     uint256 private constant MASK_INDEX_ZERO = (1 << 255);
1701     uint256 private constant MASK_FULL = type(uint256).max;
1702 
1703     struct BitMap {
1704         mapping(uint256 => uint256) _data;
1705     }
1706 
1707     /**
1708      * @dev Returns whether the bit at `index` is set.
1709      */
1710     function get(
1711         BitMap storage bitmap,
1712         uint256 index
1713     ) internal view returns (bool) {
1714         uint256 bucket = index >> 8;
1715         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1716         return bitmap._data[bucket] & mask != 0;
1717     }
1718 
1719     /**
1720      * @dev Sets the bit at `index` to the boolean `value`.
1721      */
1722     function setTo(BitMap storage bitmap, uint256 index, bool value) internal {
1723         if (value) {
1724             set(bitmap, index);
1725         } else {
1726             unset(bitmap, index);
1727         }
1728     }
1729 
1730     /**
1731      * @dev Sets the bit at `index`.
1732      */
1733     function set(BitMap storage bitmap, uint256 index) internal {
1734         uint256 bucket = index >> 8;
1735         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1736         bitmap._data[bucket] |= mask;
1737     }
1738 
1739     /**
1740      * @dev Unsets the bit at `index`.
1741      */
1742     function unset(BitMap storage bitmap, uint256 index) internal {
1743         uint256 bucket = index >> 8;
1744         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
1745         bitmap._data[bucket] &= ~mask;
1746     }
1747 
1748     /**
1749      * @dev Consecutively sets `amount` of bits starting from the bit at `startIndex`.
1750      */
1751     function setBatch(
1752         BitMap storage bitmap,
1753         uint256 startIndex,
1754         uint256 amount
1755     ) internal {
1756         uint256 bucket = startIndex >> 8;
1757 
1758         uint256 bucketStartIndex = (startIndex & 0xff);
1759 
1760         unchecked {
1761             if (bucketStartIndex + amount < 256) {
1762                 bitmap._data[bucket] |=
1763                     (MASK_FULL << (256 - amount)) >>
1764                     bucketStartIndex;
1765             } else {
1766                 bitmap._data[bucket] |= MASK_FULL >> bucketStartIndex;
1767                 amount -= (256 - bucketStartIndex);
1768                 bucket++;
1769 
1770                 while (amount > 256) {
1771                     bitmap._data[bucket] = MASK_FULL;
1772                     amount -= 256;
1773                     bucket++;
1774                 }
1775 
1776                 bitmap._data[bucket] |= MASK_FULL << (256 - amount);
1777             }
1778         }
1779     }
1780 
1781     /**
1782      * @dev Consecutively unsets `amount` of bits starting from the bit at `startIndex`.
1783      */
1784     function unsetBatch(
1785         BitMap storage bitmap,
1786         uint256 startIndex,
1787         uint256 amount
1788     ) internal {
1789         uint256 bucket = startIndex >> 8;
1790 
1791         uint256 bucketStartIndex = (startIndex & 0xff);
1792 
1793         unchecked {
1794             if (bucketStartIndex + amount < 256) {
1795                 bitmap._data[bucket] &= ~((MASK_FULL << (256 - amount)) >>
1796                     bucketStartIndex);
1797             } else {
1798                 bitmap._data[bucket] &= ~(MASK_FULL >> bucketStartIndex);
1799                 amount -= (256 - bucketStartIndex);
1800                 bucket++;
1801 
1802                 while (amount > 256) {
1803                     bitmap._data[bucket] = 0;
1804                     amount -= 256;
1805                     bucket++;
1806                 }
1807 
1808                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount));
1809             }
1810         }
1811     }
1812 
1813     /**
1814      * @dev Find the closest index of the set bit before `index`.
1815      */
1816     function scanForward(
1817         BitMap storage bitmap,
1818         uint256 index
1819     ) internal view returns (uint256 setBitIndex) {
1820         uint256 bucket = index >> 8;
1821 
1822         // index within the bucket
1823         uint256 bucketIndex = (index & 0xff);
1824 
1825         // load a bitboard from the bitmap.
1826         uint256 bb = bitmap._data[bucket];
1827 
1828         // offset the bitboard to scan from `bucketIndex`.
1829         bb = bb >> (0xff ^ bucketIndex); // bb >> (255 - bucketIndex)
1830 
1831         if (bb > 0) {
1832             unchecked {
1833                 setBitIndex =
1834                     (bucket << 8) |
1835                     (bucketIndex - bb.bitScanForward256());
1836             }
1837         } else {
1838             while (true) {
1839                 require(
1840                     bucket > 0,
1841                     "BitMaps: The set bit before the index doesn't exist."
1842                 );
1843                 unchecked {
1844                     bucket--;
1845                 }
1846                 // No offset. Always scan from the least significiant bit now.
1847                 bb = bitmap._data[bucket];
1848 
1849                 if (bb > 0) {
1850                     unchecked {
1851                         setBitIndex =
1852                             (bucket << 8) |
1853                             (255 - bb.bitScanForward256());
1854                         break;
1855                     }
1856                 }
1857             }
1858         }
1859     }
1860 
1861     function getBucket(
1862         BitMap storage bitmap,
1863         uint256 bucket
1864     ) internal view returns (uint256) {
1865         return bitmap._data[bucket];
1866     }
1867 }
1868 
1869 // File erc721psi/contracts/ERC721Psi.sol@v0.7.0
1870 
1871 /**
1872   ______ _____   _____ ______ ___  __ _  _  _ 
1873  |  ____|  __ \ / ____|____  |__ \/_ | || || |
1874  | |__  | |__) | |        / /   ) || | \| |/ |
1875  |  __| |  _  /| |       / /   / / | |\_   _/ 
1876  | |____| | \ \| |____  / /   / /_ | |  | |   
1877  |______|_|  \_\\_____|/_/   |____||_|  |_|   
1878 
1879  - github: https://github.com/estarriolvetch/ERC721Psi
1880  - npm: https://www.npmjs.com/package/erc721psi
1881                                           
1882  */
1883 
1884 pragma solidity ^0.8.0;
1885 
1886 contract ERC721Psi is Context, ERC165, IERC721, IERC721Metadata {
1887     using Address for address;
1888     using Strings for uint256;
1889     using BitMaps for BitMaps.BitMap;
1890 
1891     BitMaps.BitMap private _batchHead;
1892 
1893     string private _name;
1894     string private _symbol;
1895 
1896     // Mapping from token ID to owner address
1897     mapping(uint256 => address) internal _owners;
1898     uint256 private _currentIndex;
1899 
1900     mapping(uint256 => address) private _tokenApprovals;
1901     mapping(address => mapping(address => bool)) private _operatorApprovals;
1902 
1903     /**
1904      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1905      */
1906     constructor(string memory name_, string memory symbol_) {
1907         _name = name_;
1908         _symbol = symbol_;
1909         _currentIndex = _startTokenId();
1910     }
1911 
1912     /**
1913      * @dev Returns the starting token ID.
1914      * To change the starting token ID, please override this function.
1915      */
1916     function _startTokenId() internal pure virtual returns (uint256) {
1917         // It will become modifiable in the future versions
1918         return 0;
1919     }
1920 
1921     /**
1922      * @dev Returns the next token ID to be minted.
1923      */
1924     function _nextTokenId() internal view virtual returns (uint256) {
1925         return _currentIndex;
1926     }
1927 
1928     /**
1929      * @dev Returns the total amount of tokens minted in the contract.
1930      */
1931     function _totalMinted() internal view virtual returns (uint256) {
1932         return _currentIndex - _startTokenId();
1933     }
1934 
1935     /**
1936      * @dev See {IERC165-supportsInterface}.
1937      */
1938     function supportsInterface(
1939         bytes4 interfaceId
1940     ) public view virtual override(ERC165, IERC165) returns (bool) {
1941         return
1942             interfaceId == type(IERC721).interfaceId ||
1943             interfaceId == type(IERC721Metadata).interfaceId ||
1944             super.supportsInterface(interfaceId);
1945     }
1946 
1947     /**
1948      * @dev See {IERC721-balanceOf}.
1949      */
1950     function balanceOf(
1951         address owner
1952     ) public view virtual override returns (uint) {
1953         require(
1954             owner != address(0),
1955             "ERC721Psi: balance query for the zero address"
1956         );
1957 
1958         uint count;
1959         for (uint i = _startTokenId(); i < _nextTokenId(); ++i) {
1960             if (_exists(i)) {
1961                 if (owner == ownerOf(i)) {
1962                     ++count;
1963                 }
1964             }
1965         }
1966         return count;
1967     }
1968 
1969     /**
1970      * @dev See {IERC721-ownerOf}.
1971      */
1972     function ownerOf(
1973         uint256 tokenId
1974     ) public view virtual override returns (address) {
1975         (address owner, ) = _ownerAndBatchHeadOf(tokenId);
1976         return owner;
1977     }
1978 
1979     function _ownerAndBatchHeadOf(
1980         uint256 tokenId
1981     ) internal view returns (address owner, uint256 tokenIdBatchHead) {
1982         require(
1983             _exists(tokenId),
1984             "ERC721Psi: owner query for nonexistent token"
1985         );
1986         tokenIdBatchHead = _getBatchHead(tokenId);
1987         owner = _owners[tokenIdBatchHead];
1988     }
1989 
1990     /**
1991      * @dev See {IERC721Metadata-name}.
1992      */
1993     function name() public view virtual override returns (string memory) {
1994         return _name;
1995     }
1996 
1997     /**
1998      * @dev See {IERC721Metadata-symbol}.
1999      */
2000     function symbol() public view virtual override returns (string memory) {
2001         return _symbol;
2002     }
2003 
2004     /**
2005      * @dev See {IERC721Metadata-tokenURI}.
2006      */
2007     function tokenURI(
2008         uint256 tokenId
2009     ) public view virtual override returns (string memory) {
2010         require(_exists(tokenId), "ERC721Psi: URI query for nonexistent token");
2011 
2012         string memory baseURI = _baseURI();
2013         return
2014             bytes(baseURI).length > 0
2015                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2016                 : "";
2017     }
2018 
2019     /**
2020      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2021      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2022      * by default, can be overriden in child contracts.
2023      */
2024     function _baseURI() internal view virtual returns (string memory) {
2025         return "";
2026     }
2027 
2028     /**
2029      * @dev See {IERC721-approve}.
2030      */
2031     function approve(address to, uint256 tokenId) public virtual override {
2032         address owner = ownerOf(tokenId);
2033         require(to != owner, "ERC721Psi: approval to current owner");
2034 
2035         require(
2036             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2037             "ERC721Psi: approve caller is not owner nor approved for all"
2038         );
2039 
2040         _approve(to, tokenId);
2041     }
2042 
2043     /**
2044      * @dev See {IERC721-getApproved}.
2045      */
2046     function getApproved(
2047         uint256 tokenId
2048     ) public view virtual override returns (address) {
2049         require(
2050             _exists(tokenId),
2051             "ERC721Psi: approved query for nonexistent token"
2052         );
2053 
2054         return _tokenApprovals[tokenId];
2055     }
2056 
2057     /**
2058      * @dev See {IERC721-setApprovalForAll}.
2059      */
2060     function setApprovalForAll(
2061         address operator,
2062         bool approved
2063     ) public virtual override {
2064         require(operator != _msgSender(), "ERC721Psi: approve to caller");
2065 
2066         _operatorApprovals[_msgSender()][operator] = approved;
2067         emit ApprovalForAll(_msgSender(), operator, approved);
2068     }
2069 
2070     /**
2071      * @dev See {IERC721-isApprovedForAll}.
2072      */
2073     function isApprovedForAll(
2074         address owner,
2075         address operator
2076     ) public view virtual override returns (bool) {
2077         return _operatorApprovals[owner][operator];
2078     }
2079 
2080     /**
2081      * @dev See {IERC721-transferFrom}.
2082      */
2083     function transferFrom(
2084         address from,
2085         address to,
2086         uint256 tokenId
2087     ) public virtual override {
2088         //solhint-disable-next-line max-line-length
2089         require(
2090             _isApprovedOrOwner(_msgSender(), tokenId),
2091             "ERC721Psi: transfer caller is not owner nor approved"
2092         );
2093 
2094         _transfer(from, to, tokenId);
2095     }
2096 
2097     /**
2098      * @dev See {IERC721-safeTransferFrom}.
2099      */
2100     function safeTransferFrom(
2101         address from,
2102         address to,
2103         uint256 tokenId
2104     ) public virtual override {
2105         safeTransferFrom(from, to, tokenId, "");
2106     }
2107 
2108     /**
2109      * @dev See {IERC721-safeTransferFrom}.
2110      */
2111     function safeTransferFrom(
2112         address from,
2113         address to,
2114         uint256 tokenId,
2115         bytes memory _data
2116     ) public virtual override {
2117         require(
2118             _isApprovedOrOwner(_msgSender(), tokenId),
2119             "ERC721Psi: transfer caller is not owner nor approved"
2120         );
2121         _safeTransfer(from, to, tokenId, _data);
2122     }
2123 
2124     /**
2125      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2126      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2127      *
2128      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2129      *
2130      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2131      * implement alternative mechanisms to perform token transfer, such as signature-based.
2132      *
2133      * Requirements:
2134      *
2135      * - `from` cannot be the zero address.
2136      * - `to` cannot be the zero address.
2137      * - `tokenId` token must exist and be owned by `from`.
2138      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2139      *
2140      * Emits a {Transfer} event.
2141      */
2142     function _safeTransfer(
2143         address from,
2144         address to,
2145         uint256 tokenId,
2146         bytes memory _data
2147     ) internal virtual {
2148         _transfer(from, to, tokenId);
2149         require(
2150             _checkOnERC721Received(from, to, tokenId, 1, _data),
2151             "ERC721Psi: transfer to non ERC721Receiver implementer"
2152         );
2153     }
2154 
2155     /**
2156      * @dev Returns whether `tokenId` exists.
2157      *
2158      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2159      *
2160      * Tokens start existing when they are minted (`_mint`).
2161      */
2162     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2163         return tokenId < _nextTokenId() && _startTokenId() <= tokenId;
2164     }
2165 
2166     /**
2167      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2168      *
2169      * Requirements:
2170      *
2171      * - `tokenId` must exist.
2172      */
2173     function _isApprovedOrOwner(
2174         address spender,
2175         uint256 tokenId
2176     ) internal view virtual returns (bool) {
2177         require(
2178             _exists(tokenId),
2179             "ERC721Psi: operator query for nonexistent token"
2180         );
2181         address owner = ownerOf(tokenId);
2182         return (spender == owner ||
2183             getApproved(tokenId) == spender ||
2184             isApprovedForAll(owner, spender));
2185     }
2186 
2187     /**
2188      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2189      *
2190      * Requirements:
2191      *
2192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2193      * - `quantity` must be greater than 0.
2194      *
2195      * Emits a {Transfer} event.
2196      */
2197     function _safeMint(address to, uint256 quantity) internal virtual {
2198         _safeMint(to, quantity, "");
2199     }
2200 
2201     function _safeMint(
2202         address to,
2203         uint256 quantity,
2204         bytes memory _data
2205     ) internal virtual {
2206         uint256 nextTokenId = _nextTokenId();
2207         _mint(to, quantity);
2208         require(
2209             _checkOnERC721Received(
2210                 address(0),
2211                 to,
2212                 nextTokenId,
2213                 quantity,
2214                 _data
2215             ),
2216             "ERC721Psi: transfer to non ERC721Receiver implementer"
2217         );
2218     }
2219 
2220     function _mint(address to, uint256 quantity) internal virtual {
2221         uint256 nextTokenId = _nextTokenId();
2222 
2223         require(quantity > 0, "ERC721Psi: quantity must be greater 0");
2224         require(to != address(0), "ERC721Psi: mint to the zero address");
2225 
2226         _beforeTokenTransfers(address(0), to, nextTokenId, quantity);
2227         _currentIndex += quantity;
2228         _owners[nextTokenId] = to;
2229         _batchHead.set(nextTokenId);
2230         _afterTokenTransfers(address(0), to, nextTokenId, quantity);
2231 
2232         // Emit events
2233         for (
2234             uint256 tokenId = nextTokenId;
2235             tokenId < nextTokenId + quantity;
2236             tokenId++
2237         ) {
2238             emit Transfer(address(0), to, tokenId);
2239         }
2240     }
2241 
2242     /**
2243      * @dev Transfers `tokenId` from `from` to `to`.
2244      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2245      *
2246      * Requirements:
2247      *
2248      * - `to` cannot be the zero address.
2249      * - `tokenId` token must be owned by `from`.
2250      *
2251      * Emits a {Transfer} event.
2252      */
2253     function _transfer(
2254         address from,
2255         address to,
2256         uint256 tokenId
2257     ) internal virtual {
2258         (address owner, uint256 tokenIdBatchHead) = _ownerAndBatchHeadOf(
2259             tokenId
2260         );
2261 
2262         require(owner == from, "ERC721Psi: transfer of token that is not own");
2263         require(to != address(0), "ERC721Psi: transfer to the zero address");
2264 
2265         _beforeTokenTransfers(from, to, tokenId, 1);
2266 
2267         // Clear approvals from the previous owner
2268         _approve(address(0), tokenId);
2269 
2270         uint256 subsequentTokenId = tokenId + 1;
2271 
2272         if (
2273             !_batchHead.get(subsequentTokenId) &&
2274             subsequentTokenId < _nextTokenId()
2275         ) {
2276             _owners[subsequentTokenId] = from;
2277             _batchHead.set(subsequentTokenId);
2278         }
2279 
2280         _owners[tokenId] = to;
2281         if (tokenId != tokenIdBatchHead) {
2282             _batchHead.set(tokenId);
2283         }
2284 
2285         emit Transfer(from, to, tokenId);
2286 
2287         _afterTokenTransfers(from, to, tokenId, 1);
2288     }
2289 
2290     /**
2291      * @dev Approve `to` to operate on `tokenId`
2292      *
2293      * Emits a {Approval} event.
2294      */
2295     function _approve(address to, uint256 tokenId) internal virtual {
2296         _tokenApprovals[tokenId] = to;
2297         emit Approval(ownerOf(tokenId), to, tokenId);
2298     }
2299 
2300     /**
2301      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2302      * The call is not executed if the target address is not a contract.
2303      *
2304      * @param from address representing the previous owner of the given token ID
2305      * @param to target address that will receive the tokens
2306      * @param startTokenId uint256 the first ID of the tokens to be transferred
2307      * @param quantity uint256 amount of the tokens to be transfered.
2308      * @param _data bytes optional data to send along with the call
2309      * @return r bool whether the call correctly returned the expected magic value
2310      */
2311     function _checkOnERC721Received(
2312         address from,
2313         address to,
2314         uint256 startTokenId,
2315         uint256 quantity,
2316         bytes memory _data
2317     ) private returns (bool r) {
2318         if (to.isContract()) {
2319             r = true;
2320             for (
2321                 uint256 tokenId = startTokenId;
2322                 tokenId < startTokenId + quantity;
2323                 tokenId++
2324             ) {
2325                 try
2326                     IERC721Receiver(to).onERC721Received(
2327                         _msgSender(),
2328                         from,
2329                         tokenId,
2330                         _data
2331                     )
2332                 returns (bytes4 retval) {
2333                     r =
2334                         r &&
2335                         retval == IERC721Receiver.onERC721Received.selector;
2336                 } catch (bytes memory reason) {
2337                     if (reason.length == 0) {
2338                         revert(
2339                             "ERC721Psi: transfer to non ERC721Receiver implementer"
2340                         );
2341                     } else {
2342                         assembly {
2343                             revert(add(32, reason), mload(reason))
2344                         }
2345                     }
2346                 }
2347             }
2348             return r;
2349         } else {
2350             return true;
2351         }
2352     }
2353 
2354     function _getBatchHead(
2355         uint256 tokenId
2356     ) internal view returns (uint256 tokenIdBatchHead) {
2357         tokenIdBatchHead = _batchHead.scanForward(tokenId);
2358     }
2359 
2360     function totalSupply() public view virtual returns (uint256) {
2361         return _totalMinted();
2362     }
2363 
2364     /**
2365      * @dev Returns an array of token IDs owned by `owner`.
2366      *
2367      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2368      * It is meant to be called off-chain.
2369      *
2370      * This function is compatiable with ERC721AQueryable.
2371      */
2372     function tokensOfOwner(
2373         address owner
2374     ) external view virtual returns (uint256[] memory) {
2375         unchecked {
2376             uint256 tokenIdsIdx;
2377             uint256 tokenIdsLength = balanceOf(owner);
2378             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2379             for (
2380                 uint256 i = _startTokenId();
2381                 tokenIdsIdx != tokenIdsLength;
2382                 ++i
2383             ) {
2384                 if (_exists(i)) {
2385                     if (ownerOf(i) == owner) {
2386                         tokenIds[tokenIdsIdx++] = i;
2387                     }
2388                 }
2389             }
2390             return tokenIds;
2391         }
2392     }
2393 
2394     /**
2395      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2396      *
2397      * startTokenId - the first token id to be transferred
2398      * quantity - the amount to be transferred
2399      *
2400      * Calling conditions:
2401      *
2402      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2403      * transferred to `to`.
2404      * - When `from` is zero, `tokenId` will be minted for `to`.
2405      */
2406     function _beforeTokenTransfers(
2407         address from,
2408         address to,
2409         uint256 startTokenId,
2410         uint256 quantity
2411     ) internal virtual {}
2412 
2413     /**
2414      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2415      * minting.
2416      *
2417      * startTokenId - the first token id to be transferred
2418      * quantity - the amount to be transferred
2419      *
2420      * Calling conditions:
2421      *
2422      * - when `from` and `to` are both non-zero.
2423      * - `from` and `to` are never both zero.
2424      */
2425     function _afterTokenTransfers(
2426         address from,
2427         address to,
2428         uint256 startTokenId,
2429         uint256 quantity
2430     ) internal virtual {}
2431 }
2432 
2433 abstract contract Ownable is Context {
2434     address private _owner;
2435 
2436     event OwnershipTransferred(
2437         address indexed previousOwner,
2438         address indexed newOwner
2439     );
2440 
2441     /**
2442      * @dev Initializes the contract setting the deployer as the initial owner.
2443      */
2444     constructor() {
2445         _transferOwnership(_msgSender());
2446     }
2447 
2448     /**
2449      * @dev Returns the address of the current owner.
2450      */
2451     function owner() public view virtual returns (address) {
2452         return _owner;
2453     }
2454 
2455     /**
2456      * @dev Throws if called by any account other than the owner.
2457      */
2458     modifier onlyOwner() virtual {
2459         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2460         _;
2461     }
2462 
2463     /**
2464      * @dev Leaves the contract without owner. It will not be possible to call
2465      * `onlyOwner` functions anymore. Can only be called by the current owner.
2466      *
2467      * NOTE: Renouncing ownership will leave the contract without an owner,
2468      * thereby removing any functionality that is only available to the owner.
2469      */
2470     function renounceOwnership() public virtual onlyOwner {
2471         _transferOwnership(address(0));
2472     }
2473 
2474     /**
2475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2476      * Can only be called by the current owner.
2477      */
2478     function transferOwnership(address newOwner) public virtual onlyOwner {
2479         require(
2480             newOwner != address(0),
2481             "Ownable: new owner is the zero address"
2482         );
2483         _transferOwnership(newOwner);
2484     }
2485 
2486     /**
2487      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2488      * Internal function without access restriction.
2489      */
2490     function _transferOwnership(address newOwner) internal virtual {
2491         address oldOwner = _owner;
2492         _owner = newOwner;
2493         emit OwnershipTransferred(oldOwner, newOwner);
2494     }
2495 }
2496 
2497 interface oldContract {
2498     function ownerOf(uint256 tokenId) external view returns (address owner);
2499 
2500     function totalSupply() external view returns (uint256);
2501 }
2502 
2503 pragma solidity ^0.8.0;
2504 
2505 contract WildTigers is DefaultOperatorFilterer, ERC721Psi, Ownable {
2506     uint256 public constant PUBLIC_MINT_PRICE = 0.025 ether;
2507     uint256 public constant WHITELIST_MINT_PRICE = 0.015 ether;
2508     uint256 public constant MAX_SUPPLY = 4444;
2509     string public baseURI =
2510         "ipfs://QmNmfv1FNNgP4DxKzC2zTeLgdbeeRMVhQeZxQsqyphGxeY/";
2511     uint256 public mintStartTime = 1690761600; // July 31 2023 00:00:00 GMT 1690761600
2512     address public oldContractAddress =
2513         address(0x4db8Cf5e58A36D7c5B38a723a39Cbd8A992ccF66);
2514     uint256 public oldContractTotalSupply = 0;
2515     uint256 public oldContractAirdropped = 0;
2516 
2517     mapping(address => uint) public whitelistedAddresses;
2518 
2519     constructor() ERC721Psi("Wild Tigers", "WLDT") {
2520         oldContractTotalSupply = oldContract(oldContractAddress).totalSupply();
2521     }
2522 
2523     function airdropOld(uint256 quantityToAirdrop) external onlyOwner {
2524         require(
2525             oldContractAirdropped + quantityToAirdrop <= oldContractTotalSupply,
2526             "Airdrop exceeds old contract supply!"
2527         );
2528         for (uint256 i = 0; i < quantityToAirdrop; i++) {
2529             _safeMint(
2530                 oldContract(oldContractAddress).ownerOf(
2531                     oldContractAirdropped + i + 1
2532                 ),
2533                 1
2534             );
2535         }
2536         oldContractAirdropped += quantityToAirdrop;
2537     }
2538 
2539     function mint(uint256 _mintAmount) external payable {
2540         require(
2541             totalSupply() + _mintAmount <= MAX_SUPPLY,
2542             "Max supply exceeded!"
2543         );
2544         require(
2545             block.timestamp >= mintStartTime,
2546             "Minting has not started yet!"
2547         );
2548         if (whitelistedAddresses[msg.sender] == 1) {
2549             require(
2550                 msg.value >= WHITELIST_MINT_PRICE * _mintAmount,
2551                 "Insufficient funds to mint!"
2552             );
2553         } else {
2554             require(
2555                 msg.value >= PUBLIC_MINT_PRICE * _mintAmount,
2556                 "Insufficient funds to mint!"
2557             );
2558         }
2559         // _safeMint's second argument now takes in a quantity, not a tokenId. (same as ERC721A)
2560         _safeMint(msg.sender, _mintAmount);
2561     }
2562 
2563     function setMintStartTime(uint256 _mintStartTime) external onlyOwner {
2564         mintStartTime = _mintStartTime;
2565     }
2566 
2567     function addToWhitelist(
2568         address[] calldata _whitelister
2569     ) external onlyOwner {
2570         for (uint256 i = 0; i < _whitelister.length; i++) {
2571             require(
2572                 whitelistedAddresses[_whitelister[i]] == 0,
2573                 "Address already whitelisted"
2574             );
2575             whitelistedAddresses[_whitelister[i]] = 1;
2576         }
2577     }
2578 
2579     function removeFromWhitelist(
2580         address[] calldata _whitelister
2581     ) external onlyOwner {
2582         for (uint256 i = 0; i < _whitelister.length; i++) {
2583             require(
2584                 whitelistedAddresses[_whitelister[i]] > 0,
2585                 "Address not present in whitelist"
2586             );
2587             whitelistedAddresses[_whitelister[i]] = 0;
2588         }
2589     }
2590 
2591     function _baseURI() internal view virtual override returns (string memory) {
2592         return baseURI;
2593     }
2594 
2595     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2596         baseURI = _newBaseURI;
2597     }
2598 
2599     function _startTokenId() internal pure virtual override returns (uint256) {
2600         return 1;
2601     }
2602 
2603     function tokenURI(
2604         uint256 tokenId
2605     ) public view virtual override returns (string memory) {
2606         require(
2607             _exists(tokenId),
2608             "ERC721Metadata: URI query for nonexistent token"
2609         );
2610         return
2611             string(
2612                 abi.encodePacked(_baseURI(), Strings.toString(tokenId), ".json")
2613             );
2614     }
2615 
2616     function withdraw() external onlyOwner {
2617         uint256 balance = address(this).balance;
2618         payable(msg.sender).transfer(balance);
2619     }
2620 
2621     function setApprovalForAll(
2622         address operator,
2623         bool approved
2624     ) public override onlyAllowedOperatorApproval(operator) {
2625         super.setApprovalForAll(operator, approved);
2626     }
2627 
2628     function approve(
2629         address operator,
2630         uint256 tokenId
2631     ) public override onlyAllowedOperatorApproval(operator) {
2632         super.approve(operator, tokenId);
2633     }
2634 
2635     function transferFrom(
2636         address from,
2637         address to,
2638         uint256 tokenId
2639     ) public override onlyAllowedOperator(from) {
2640         super.transferFrom(from, to, tokenId);
2641     }
2642 
2643     function safeTransferFrom(
2644         address from,
2645         address to,
2646         uint256 tokenId
2647     ) public override onlyAllowedOperator(from) {
2648         super.safeTransferFrom(from, to, tokenId);
2649     }
2650 
2651     function safeTransferFrom(
2652         address from,
2653         address to,
2654         uint256 tokenId,
2655         bytes memory data
2656     ) public override onlyAllowedOperator(from) {
2657         super.safeTransferFrom(from, to, tokenId, data);
2658     }
2659 }